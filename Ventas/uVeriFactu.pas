unit uVeriFactu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DateUtils;

procedure VeriFactu_QueueFactura(
  const Serie: string;
  const Numero: Integer;
  const Fecha: TDate;
  const Hora: TTime;
  const TotalConIVA: Double
);

// Permite pasar credenciales DB desde tu propia configuración (evita .ini extra)
procedure VeriFactu_SetDBParams(const Host, Port, DBName, UserName, Password: string);

// Habilita/deshabilita la escritura dual (DB + copia .json). Por defecto: True
procedure VeriFactu_EnableDualWriteJSON(const Enable: Boolean);

// -------- Control de estados / reintentos / concurrencia --------

// Reclamación segura (multiusuario) del siguiente pendiente.
// Devuelve False si no hay pendientes reclamables.
function VeriFactu_TakeNextPending(out Serie: string; out Numero: Integer;
  out PayloadJSON: string; out EncadenamientoHash: string): Boolean;


// Marca una factura como ENVIADO. Permite guardar hash y respuesta (opcional).
procedure VeriFactu_MarkSent(const Serie: string; const Numero: Integer; const Hash: string = ''; const Respuesta: string = '');

// Marca una factura como ERROR (y deja el mensaje). Mantiene payload para reintentos.
procedure VeriFactu_MarkError(const Serie: string; const Numero: Integer; const MensajeError: string; const Respuesta: string = '');

// Devuelve una factura a estado PENDIENTE (por ejemplo tras corregir).
procedure VeriFactu_ResetToPending(const Serie: string; const Numero: Integer);

// Recoloca en PENDIENTE las bloqueadas en EN_PROCESO cuyo "lease" haya expirado.
procedure VeriFactu_RequeueStuck(InMinutes: Integer = 10);

// Hacemos pública la función para obtener el número de id
function GetMachineUUIDFromFile: string;

implementation

uses
  IniFiles, ZConnection, ZDataset, uVeriHash, uVF_HashChain, uVeriChain, uVeriChainCheck,
  Global; // <-- Para tener acceso a las variables Nif, Empresa y vfUrlTP

procedure QueueToFiles(const Serie: string; Numero: Integer; const FechaISO, HoraISO: string;
  TotalConIVA: Double; const PayloadJSON: string); forward;

type
  TStorageMode = (smUnknown, smDB, smFiles);

var
  GMode: TStorageMode = smUnknown;
  GConn: TZConnection = nil;

// Parámetros DB opcionales (para modo MIXTO sin necesitar verifactu.ini)
var
  GHasExtDBParams: Boolean = False;
  GExtHost, GExtPort, GExtDB, GExtUser, GExtPass: string;

// Escritura dual (DB + .json)
var
  GDualWriteJSON: Boolean = True; // confirmado por el usuario
  MotorDB: String = 'MyISAM';     // motor bbdd en creación, que será sustituido por un módulo variable ARIA, MyISAM, InnoDB

// ---------- Helpers de E/S seguras (evitan "File not found" emergente) ----------

function HomeDir: string;
begin
  {$IFDEF UNIX}
  Result := GetEnvironmentVariable('HOME');
  {$ELSE}
  Result := GetEnvironmentVariable('USERPROFILE');
  {$ENDIF}
  if Result = '' then
    Result := GetTempDir(False);
end;

function ConfigPath: string;
begin
  Result := IncludeTrailingPathDelimiter(HomeDir) + '.config' + DirectorySeparator + 'verifactu';
end;

function DataPath: string;
begin
  Result := IncludeTrailingPathDelimiter(HomeDir) + '.local' + DirectorySeparator + 'share' + DirectorySeparator + 'verifactu';
end;

procedure EnsureDir(const APath: string);
begin
  if (APath <> '') and (not DirectoryExists(APath)) then
    ForceDirectories(APath);
end;

procedure SafeSaveText(const FileName, Text: string);
var
  SL: TStringList;
begin
  try
    EnsureDir(ExtractFilePath(FileName));
    SL := TStringList.Create;
    try
      SL.Text := Text;
      SL.SaveToFile(FileName);
    finally
      SL.Free;
    end;
  except
    on E: Exception do
      ; // no re-lanzamos para evitar diálogo; el log se hará en WriteDiag si procede
  end;
end;

procedure SafeAppendLine(const FileName, Line: string);
var
  SL: TStringList;
begin
  try
    EnsureDir(ExtractFilePath(FileName));
    SL := TStringList.Create;
    try
      if FileExists(FileName) then SL.LoadFromFile(FileName);
      SL.Add(Line);
      SL.SaveToFile(FileName);
    finally
      SL.Free;
    end;
  except
    on E: Exception do ; // evitar propagación
  end;
end;

procedure WriteDiag(const Msg: string);
var
  f: string;
begin
  f := IncludeTrailingPathDelimiter(DataPath) + 'logs' + DirectorySeparator + 'driver.log';
  SafeAppendLine(f, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + '  ' + Msg);
end;

// Lee el UUID de la máquina desde /etc/machine-id
function GetMachineUUIDFromFile: string;
var
  SL: TStringList;
  FN: string;
begin
  Result := '';
  FN := '/etc/machine-id';
  try
    if FileExists(FN) then
    begin
      SL := TStringList.Create;
      try
        SL.LoadFromFile(FN);
        if SL.Count > 0 then
          Result := Trim(SL[0]);
      finally
        SL.Free;
      end;
    end;
  except
    on E: Exception do
      WriteDiag('GetMachineUUIDFromFile error: ' + E.Message);
  end;
end;

// ---------- Configuración DB ----------

procedure VeriFactu_SetDBParams(const Host, Port, DBName, UserName, Password: string);
begin
  GExtHost := Host;
  GExtPort := Port;
  GExtDB   := DBName;
  GExtUser := UserName;
  GExtPass := Password;
  GHasExtDBParams := (GExtHost <> '') and (GExtDB <> '') and (GExtUser <> '');
  if GHasExtDBParams then
    WriteDiag('Recibidos DB params externos para modo MIXTO.');
end;

procedure VeriFactu_EnableDualWriteJSON(const Enable: Boolean);
begin
  GDualWriteJSON := Enable;
  if GDualWriteJSON then
    WriteDiag('DualWriteJSON ACTIVADO (DB + copia .json).')
  else
    WriteDiag('DualWriteJSON DESACTIVADO (solo DB o solo .json si no hay DB).');
end;

function ReadIni(out Host, Port, DBName, UserName, Password: string; out IniUsed: string): boolean;
var
  ini: TIniFile;
  fn: string;
begin
  Result := False;
  fn := IncludeTrailingPathDelimiter(ConfigPath) + 'verifactu.ini';
  IniUsed := fn;
  if not FileExists(fn) then Exit;
  try
    ini := TIniFile.Create(fn);
    try
      Host     := ini.ReadString('mariadb','host',Host);
      Port     := ini.ReadString('mariadb','port',Port);
      DBName   := ini.ReadString('mariadb','database',DBName);
      UserName := ini.ReadString('mariadb','user',UserName);
      Password := ini.ReadString('mariadb','password',Password);
      Result := True;
    finally
      ini.Free;
    end;
  except
    on E: Exception do
      WriteDiag('ReadIni error: ' + E.Message + ' [' + fn + ']');
  end;
end;

//--------- Función para indicar el tipo de factura que estamos enviando, F1, F2 y posteriormente otros tipos
function VF_CalcTipoFactura(const Serie: string; EsRectificativa, EsTicketTPV: Boolean): string;
begin
  // Ajusta la lógica a tu caso real
  if EsRectificativa or EsTicketTPV then
    Result := 'F2'
  else
    Result := 'F1';
end;

// Detección automática básica a partir de la serie (FS-* → TPV simplificada = F2, resto F1)
function VF_DetectTipoFacturaFromSerie(const Serie: string): string;
var
  SUp: string;
begin
  SUp := UpperCase(Trim(Serie));
  // Tickets TPV: series tipo FS-A25, FS-XXXX...
  if (Copy(SUp, 1, 3) = 'FS-') or (Copy(SUp, 1, 2) = 'FS') then
    Result := 'F2'
  else
    Result := 'F1';
end;

// ---------- JSON helpers ----------

function JsonEscape(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
  begin
    case S[i] of
      '"': Result += '\"';
      '\': Result += '\\';
      #8: Result += '\b';
      #9: Result += '\t';
      #10: Result += '\n';
      #12: Result += '\f';
      #13: Result += '\r';
    else
      Result += S[i];
    end;
  end;
end;

function F2(const V: Double): string;
begin
  Result := StringReplace(FormatFloat('0.00', V), ',', '.', [rfReplaceAll]);
end;

function BuildJSONSkeleton(const Serie: string; Numero: Integer; const FechaISO, HoraISO: string; TotalConIVA: Double): string;
begin
  Result := '{' +
    '"version":"1.2.1",' +
    '"tipo":"FACTURA",' +
    '"cabecera":{' +
      '"serie":"' + JsonEscape(Serie) + '",' +
      '"numero":' + IntToStr(Numero) + ',' +
      '"fecha":"' + FechaISO + '",' +
      '"hora":"' + HoraISO + '",' +
      '"totalConIVA":' + F2(TotalConIVA) +
    '},' +
    '"lineas":[],' +
    '"impuestos":{"ivas":[]}' +
  '}';
end;

function QuoteIdent(const S: string): string;
begin
  Result := '`' + StringReplace(S, '`', '``', [rfReplaceAll]) + '`';
end;

function CurrentDatabase(Conn: TZConnection): string;
begin
  if Assigned(Conn) then
    Result := Conn.Database
  else
    Result := '';
end;

function TableExists(Conn: TZConnection; const TableName: string): Boolean;
var
  q: TZQuery;
begin
  Result := False;
  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text := 'SHOW TABLES LIKE :t';
    q.ParamByName('t').AsString := TableName;
    q.Open;
    Result := not q.IsEmpty;
  finally
    q.Free;
  end;
end;

function TableHasColumns(Conn: TZConnection; const TableName: string; const Cols: array of string): boolean;
var
  q: TZQuery;
  found, i: Integer;
begin
  Result := False;
  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text := 'SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=:db AND TABLE_NAME=:t';
    q.ParamByName('db').AsString := CurrentDatabase(Conn);
    q.ParamByName('t').AsString := TableName;
    q.Open;
    found := 0;
    for i:=Low(Cols) to High(Cols) do
      if q.Locate('COLUMN_NAME', Cols[i], []) then
        Inc(found);
    Result := (found = Length(Cols));
  finally
    q.Free;
  end;
end;


// ----------------------------------
// --FUNCION PARA EXTRAER CLIENTE ---
// ----------------------------------
function DetectClientesTableExact(Conn: TZConnection; out TableName: string): boolean;
begin
  // En tu caso, la tabla se llama exactamente "clientes"
  TableName := 'clientes';

  // Comprobamos que existe y que tiene al menos C0 (código) y C1 (nombre)
  Result := TableExists(Conn, TableName) and
            TableHasColumns(Conn, TableName, ['C0','C1']);

  if not Result then
    WriteDiag('No se encontró tabla clientes con columnas C0,C1.');
end;

function LoadClienteNombreFromDB(Conn: TZConnection; const CodCliente: string): string;
var
  tname: string;
  q: TZQuery;
begin
  Result := '';
  if CodCliente = '' then
    Exit;

  if not DetectClientesTableExact(Conn, tname) then
  begin
    WriteDiag('No se detectó tabla clientes con columnas C0,C1.');
    Exit;
  end;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text := 'SELECT C1 FROM ' + QuoteIdent(tname) +
                  ' WHERE C0=:cod LIMIT 1';
    q.ParamByName('cod').AsString := CodCliente;
    q.Open;
    if not q.IsEmpty then
      Result := q.FieldByName('C1').AsString;
  finally
    q.Free;
  end;
end;

// ------------- FINAL DEL PROCESO DE ASIGNACIÓN DE CLIENTES -------------------

function DetectLinesTableExact(Conn: TZConnection; out TableName: string): boolean;
var
  q: TZQuery;
  t: string;
begin
  Result := False;
  TableName := '';
  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES ' +
      'WHERE TABLE_SCHEMA=:db AND TABLE_NAME REGEXP ''^factud[0-9]{4}$'' ORDER BY TABLE_NAME';
    q.ParamByName('db').AsString := CurrentDatabase(Conn);
    q.Open;
    while not q.EOF do
    begin
      t := q.Fields[0].AsString;
      if TableHasColumns(Conn, t, ['FD2','FD3','FD4','FD6','FD7','FD8','FD9','FD11','FD12','FD13']) then
      begin
        TableName := t;
        Result := True;
        Exit;
      end;
      q.Next;
    end;
  finally
    q.Free;
  end;
end;

// ---------- Creación robusta de tablas (con log detallado) ----------

procedure DumpDDLToFile;
var
  ddl: string;
begin
  // DDL actualizado a la estructura real final de verifactu_queue
  ddl :=
    'CREATE TABLE verifactu_queue ('#10 +
    '  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,'#10 +
    '  serie VARCHAR(20) NOT NULL,'#10 +
    '  numero INT NOT NULL,'#10 +
    '  fecha DATE NOT NULL,'#10 +
    '  hora TIME NOT NULL,'#10 +
    '  total_con_iva DECIMAL(14,2) NOT NULL,'#10 +
    '  estado ENUM("PENDIENTE","EN_PROCESO","ENVIADO","ERROR") NOT NULL DEFAULT "PENDIENTE",'#10 +
    '  intentos INT NOT NULL DEFAULT 0,'#10 +
    '  payload_json MEDIUMTEXT,'#10 +
    '  hash VARCHAR(128),'#10 +
    '  hash_prev VARCHAR(64) DEFAULT NULL,'#10 +
    '  respuesta_text MEDIUMTEXT,'#10 +
    '  last_error VARCHAR(255),'#10 +
    '  token VARCHAR(64) NULL,'#10 +
    '  claimed_by VARCHAR(64) NULL,'#10 +
    '  claimed_at DATETIME NULL,'#10 +
    '  claimed_until DATETIME NULL,'#10 +
    '  last_attempt_at DATETIME NULL,'#10 +
    '  fecha_isoz VARCHAR(30) NULL DEFAULT NULL,'#10 +
    '  canonical TEXT NULL,'#10 +
    '  tipo_factura CHAR(2) NOT NULL DEFAULT "F1",'#10 +
    '  created_at DATETIME NOT NULL,'#10 +
    '  updated_at DATETIME NOT NULL,'#10 +
    '  PRIMARY KEY (id),'#10 +
    '  UNIQUE KEY uq_serie_numero (serie, numero),'#10 +
    '  KEY idx_estado (estado),'#10 +
    '  KEY idx_serie_numero (serie, numero),'#10 +
    '  KEY idx_token (token)'#10 +
    ') ENGINE=' + MotorDB + ' DEFAULT CHARSET=utf8;';
  SafeSaveText(IncludeTrailingPathDelimiter(DataPath) + 'ddl' + DirectorySeparator + 'verifactu_queue.sql', ddl);
end;

procedure EnsureTables_DB_Conn(Conn: TZConnection);
var
  qry: TZQuery;
begin
  qry := TZQuery.Create(nil);
  try
    qry.Connection := Conn;

    // verifactu_config (por si futuras configuraciones)
    try
      qry.SQL.Text :=
        'CREATE TABLE IF NOT EXISTS verifactu_config (' +
        '  id INT UNSIGNED NOT NULL AUTO_INCREMENT,' +
        '  uuid_emisor VARCHAR(64) DEFAULT NULL,' +
        '  nif_emisor  VARCHAR(16) DEFAULT NULL,' +
        '  razon_emisor VARCHAR(120) DEFAULT NULL,' +
        '  endpoint    VARCHAR(255) DEFAULT NULL,' +
        '  PRIMARY KEY(id)' +
        ') ENGINE='+MotorDB+' DEFAULT CHARSET=utf8;';
      qry.ExecSQL;
    except
      on E: Exception do
        WriteDiag('CREATE verifactu_config error: ' + E.Message);
    end;

    // columnas tolerantes (ALTER ... dentro de try/except)
    try qry.SQL.Text := 'ALTER TABLE verifactu_config ADD COLUMN cert_pass_enc VARCHAR(64) NULL'; qry.ExecSQL; except on E: Exception do ; end;


    // verifactu_config: insertar fila inicial si está vacía
    try
      qry.SQL.Text := 'SELECT COUNT(*) AS c FROM verifactu_config';
      qry.Open;
      if (not qry.EOF) and (qry.Fields[0].AsInteger = 0) then
      begin
        qry.Close;

        // Obtenemos datos del emisor desde la config global
        // y el UUID desde /etc/machine-id
        // (si algo viene vacío, lo insertamos vacío, pero al menos hay fila)
        qry.SQL.Text :=
          'INSERT INTO verifactu_config ' +
          '  (uuid_emisor, nif_emisor, razon_emisor, endpoint) ' +
          'VALUES (:u, :n, :r, :e)';

        qry.ParamByName('u').AsString := GetMachineUUIDFromFile;
        qry.ParamByName('n').AsString := Trim(Nif);
        qry.ParamByName('r').AsString := Trim(Empresa);
        qry.ParamByName('e').AsString := Trim(vfUrlTP);

        qry.ExecSQL;

        WriteDiag('verifactu_config: fila inicial insertada automaticamente.');
      end
      else
      begin
        qry.Close;
        WriteDiag('verifactu_config: ya tiene filas, no se inserta fila inicial.');
      end;
    except
      on E: Exception do
        WriteDiag('Ensure verifactu_config initial row error: ' + E.Message);
    end;

    // verifactu_queue
    if not TableExists(Conn, 'verifactu_queue') then
    begin
      try
        // CREATE inicial ya actualizado a la estructura final
        qry.SQL.Text :=
          'CREATE TABLE verifactu_queue (' +
          '  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,' +
          '  serie VARCHAR(20) NOT NULL,' +
          '  numero INT NOT NULL,' +
          '  fecha DATE NOT NULL,' +
          '  hora TIME NOT NULL,' +
          '  total_con_iva DECIMAL(14,2) NOT NULL,' +
          '  estado ENUM("PENDIENTE","EN_PROCESO","ENVIADO","ERROR") NOT NULL DEFAULT "PENDIENTE",' +
          '  intentos INT NOT NULL DEFAULT 0,' +
          '  payload_json MEDIUMTEXT,' +
          '  hash VARCHAR(128),' +
          '  hash_prev VARCHAR(64) DEFAULT NULL,' +
          '  respuesta_text MEDIUMTEXT,' +
          '  last_error VARCHAR(255),' +
          '  token VARCHAR(64) NULL,' +
          '  claimed_by VARCHAR(64) NULL,' +
          '  claimed_at DATETIME NULL,' +
          '  claimed_until DATETIME NULL,' +
          '  last_attempt_at DATETIME NULL,' +
          '  fecha_isoz VARCHAR(30) NULL DEFAULT NULL,' +
          '  canonical TEXT NULL,' +
          '  tipo_factura CHAR(2) NOT NULL DEFAULT "F1",' +
          '  created_at DATETIME NOT NULL,' +
          '  updated_at DATETIME NOT NULL,' +
          '  PRIMARY KEY (id),' +
          '  UNIQUE KEY uq_serie_numero (serie, numero),' +
          '  KEY idx_estado (estado),' +
          '  KEY idx_serie_numero (serie, numero),' +
          '  KEY idx_token (token)' +
          ') ENGINE='+MotorDB+' DEFAULT CHARSET=utf8;';
        qry.ExecSQL;
        WriteDiag('CREATE verifactu_queue ejecutado.');
      except
        on E: Exception do
        begin
          WriteDiag('CREATE verifactu_queue error: ' + E.Message);
          DumpDDLToFile;
        end;
      end;
    end;

    // columnas tolerantes (ALTER ... dentro de try/except)
    try qry.SQL.Text := 'ALTER TABLE verifactu_queue ADD COLUMN last_attempt_at DATETIME NULL'; qry.ExecSQL; except on E: Exception do ; end;
    try qry.SQL.Text := 'ALTER TABLE verifactu_queue MODIFY COLUMN estado ENUM("PENDIENTE","EN_PROCESO","ENVIADO","ERROR") NOT NULL DEFAULT "PENDIENTE"'; qry.ExecSQL; except on E: Exception do ; end;
    try qry.SQL.Text := 'ALTER TABLE verifactu_queue ADD COLUMN token VARCHAR(64) NULL'; qry.ExecSQL; except on E: Exception do ; end;
    try qry.SQL.Text := 'ALTER TABLE verifactu_queue ADD COLUMN claimed_by VARCHAR(64) NULL'; qry.ExecSQL; except on E: Exception do ; end;
    try qry.SQL.Text := 'ALTER TABLE verifactu_queue ADD COLUMN claimed_at DATETIME NULL'; qry.ExecSQL; except on E: Exception do ; end;
    try qry.SQL.Text := 'ALTER TABLE verifactu_queue ADD COLUMN claimed_until DATETIME NULL'; qry.ExecSQL; except on E: Exception do ; end;

    //--- Añadido hash_prev NO existente
    try
      qry.SQL.Text := 'ALTER TABLE verifactu_queue ADD COLUMN hash_prev VARCHAR(64) DEFAULT NULL';
      qry.ExecSQL;
      WriteDiag('Campo hash_prev añadido a verifactu_queue');
    except
      on E: Exception do
      begin
        if Pos('Duplicate column', E.Message) = 0 then
          WriteDiag('VF_EnsureHashPrevField error: ' + E.Message);
      end;
    end;

    try qry.SQL.Text := 'ALTER TABLE verifactu_queue ADD KEY idx_token (token)'; qry.ExecSQL; except on E: Exception do ; end;
    try qry.SQL.Text := 'ALTER TABLE verifactu_queue ADD COLUMN fecha_isoz VARCHAR(30) NULL DEFAULT NULL'; qry.ExecSQL; except on E: Exception do ; end;
    try qry.SQL.Text := 'ALTER TABLE verifactu_queue ADD COLUMN canonical TEXT NULL'; qry.ExecSQL; except on E: Exception do ; end;

    // tipo_factura: columna + default final F1
    try
      qry.SQL.Text := 'ALTER TABLE verifactu_queue ADD COLUMN tipo_factura CHAR(2) NOT NULL DEFAULT "F1"';
      qry.ExecSQL;
    except
      on E: Exception do ; // si ya existe, ignoramos
    end;
    try
      // Aseguramos default F1 aunque la columna existiese de antes con otro default
      qry.SQL.Text := 'ALTER TABLE verifactu_queue MODIFY COLUMN tipo_factura CHAR(2) NOT NULL DEFAULT "F1"';
      qry.ExecSQL;
    except
      on E: Exception do ; // ignoramos fallos aquí
    end;

  finally
    qry.Free;
  end;
end;

// ---------- Cola / JSON ----------

function ExistsInQueue(Conn: TZConnection; const Serie: string; Numero: Integer): Boolean;
var
  q: TZQuery;
begin
  Result := False;
  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text := 'SELECT id FROM verifactu_queue WHERE serie=:s AND numero=:n LIMIT 1';
    q.ParamByName('s').AsString := Serie;
    q.ParamByName('n').AsInteger := Numero;
    q.Open;
    Result := not q.IsEmpty;
  finally
    q.Free;
  end;
end;

// ============ CARGA CABECERA/LÍNEAS ============

function DetectCabTableExact(Conn: TZConnection; out TableName: string): boolean;
var
  q: TZQuery;
  t: string;
begin
  Result := False;
  TableName := '';
  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES ' +
      'WHERE TABLE_SCHEMA=:db AND TABLE_NAME REGEXP ''^factuc[0-9]{4}$'' ORDER BY TABLE_NAME';
    q.ParamByName('db').AsString := CurrentDatabase(Conn);
    q.Open;
    while not q.EOF do
    begin
      t := q.Fields[0].AsString;
      if TableHasColumns(Conn, t, ['FC0','FC1','FC2','FC3','FC4','FC5','FC8','FC9','FC24']) then
      begin
        TableName := t;
        Result := True;
        Exit;
      end;
      q.Next;
    end;
  finally
    q.Free;
  end;
end;

procedure LoadHeaderFromCab(Conn: TZConnection; const Serie: string; Numero: Integer;
                            out NIFCliente: string; out CodCliente: string;
                            out TotalSinIVA, TotalConIVA: Double;
                            out LineasTotales: Integer; out CantArticulos: Double);
var
  tname: string;
  q: TZQuery;
begin
  NIFCliente := '';
  CodCliente := '';
  TotalSinIVA := 0;
  TotalConIVA := 0;
  LineasTotales := 0;
  CantArticulos := 0;

  if not DetectCabTableExact(Conn, tname) then
  begin
    WriteDiag('No se detectó tabla factucNNNN con columnas requeridas.');
    Exit;
  end;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text := 'SELECT FC0,FC1,FC2,FC3,FC4,FC5,FC8,FC9,FC24 FROM ' + QuoteIdent(tname) +
                  ' WHERE FC2=:serie AND FC3=:num LIMIT 1';
    q.ParamByName('serie').AsString := Serie;
    q.ParamByName('num').AsInteger := Numero;
    q.Open;
    if not q.IsEmpty then
    begin
      CodCliente    := q.FieldByName('FC0').AsString;
      NIFCliente    := q.FieldByName('FC24').AsString;
      TotalSinIVA   := q.FieldByName('FC8').AsFloat;
      TotalConIVA   := q.FieldByName('FC9').AsFloat;
      LineasTotales := q.FieldByName('FC4').AsInteger;
      CantArticulos := q.FieldByName('FC5').AsFloat;
    end;
  finally
    q.Free;
  end;
end;

procedure LoadLinesAndTaxes(Conn: TZConnection; const Serie: string; Numero: Integer;
                            out LinesJSON: string; out IvasJSON: string);
var
  tname: string;
  q: TZQuery;
  bases, cuotas, cuotasRE: TStringList;
  ivaKey: string;
  descS: string;
  cant, pvpConIVA, pvpSinIVA, baseSinIVA, totalConIVA, ivaPct, rePct, cuotaIVA, cuotaRE: Double;
  i: Integer;
  baseV, ivaV, reV: Double;

  function ReadF(const F: string): Double;
  begin
    try Result := q.FieldByName(F).AsFloat; except Result := 0; end;
  end;
  function ReadS(const F: string): string;
  begin
    try Result := q.FieldByName(F).AsString; except Result := ''; end;
  end;
  function GetVal(L: TStringList; const K: string): Double;
  begin
    Result := StrToFloatDef(StringReplace(L.Values[K], ',', '.', [rfReplaceAll]), 0);
  end;
  procedure SetVal(L: TStringList; const K: string; const V: Double);
  begin
    L.Values[K] := F2(V);
  end;
begin
  LinesJSON := '[]';
  IvasJSON  := '[]';

  if not DetectLinesTableExact(Conn, tname) then
  begin
    WriteDiag('No se detectó tabla factudNNNN con columnas FD2,FD3,FD4,FD6,FD7,FD8,FD9,FD11,FD12,FD13');
    Exit;
  end;

  bases   := TStringList.Create;  bases.NameValueSeparator := '=';
  cuotas  := TStringList.Create;  cuotas.NameValueSeparator := '=';
  cuotasRE:= TStringList.Create;  cuotasRE.NameValueSeparator := '=';

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text := 'SELECT * FROM ' + QuoteIdent(tname) + ' WHERE ' + QuoteIdent('FD2') + '=:serie AND ' + QuoteIdent('FD3') + '=:num ORDER BY FD4';
    q.ParamByName('serie').AsString := Serie;
    q.ParamByName('num').AsInteger := Numero;
    q.Open;

    LinesJSON := '[';
    while not q.EOF do
    begin
      descS      := ReadS('FD6');
      cant       := ReadF('FD7');
      pvpConIVA  := ReadF('FD8');
      pvpSinIVA  := ReadF('FD9');
      baseSinIVA := ReadF('FD11');
      totalConIVA:= ReadF('FD13');
      ivaPct     := ReadF('FD12');
      rePct      := 0;

      if (baseSinIVA = 0) and (cant<>0) and (pvpSinIVA<>0) then
        baseSinIVA := cant * pvpSinIVA;

      cuotaIVA := baseSinIVA * (ivaPct/100.0);
      cuotaRE  := 0;

      ivaKey := F2(ivaPct);
      SetVal(bases,   ivaKey, GetVal(bases, ivaKey) + baseSinIVA);
      SetVal(cuotas,  ivaKey, GetVal(cuotas, ivaKey) + cuotaIVA);
      SetVal(cuotasRE,ivaKey, GetVal(cuotasRE, ivaKey) + cuotaRE);

      if Length(LinesJSON)>1 then LinesJSON := LinesJSON + ',';
      LinesJSON := LinesJSON + '{' +
        '"descripcion":"' + JsonEscape(descS) + '",' +
        '"cantidad":' + F2(cant) + ',' +
        '"precioUnitSinIVA":' + F2(pvpSinIVA) + ',' +
        '"precioUnitConIVA":' + F2(pvpConIVA) + ',' +
        '"baseSinIVA":' + F2(baseSinIVA) + ',' +
        '"totalConIVA":' + F2(totalConIVA) + ',' +
        '"ivaPct":' + F2(ivaPct) + ',' +
        '"cuotaIVA":' + F2(cuotaIVA) +
      '}';

      q.Next;
    end;
    LinesJSON := LinesJSON + ']';

    IvasJSON := '[';
    for i:=0 to bases.Count-1 do
    begin
      ivaKey := bases.Names[i];
      baseV := GetVal(bases, ivaKey);
      ivaV  := GetVal(cuotas, ivaKey);
      reV   := GetVal(cuotasRE, ivaKey);
      if i>0 then IvasJSON := IvasJSON + ',';
      IvasJSON := IvasJSON + '{' +
        '"tipo":"' + ivaKey + '",' +
        '"base":' + F2(baseV) + ',' +
        '"cuota":' + F2(ivaV);
      if reV<>0 then
        IvasJSON := IvasJSON + ',"reCuota":' + F2(reV);
      IvasJSON := IvasJSON + '}';
    end;
    IvasJSON := IvasJSON + ']';

  finally
    q.Free;
    bases.Free; cuotas.Free; cuotasRE.Free;
  end;
end;

function MergeJSON(const Skel, LinesJSON, IvasJSON: string): string;
var
  S: string;
begin
  S := Skel;
  S := StringReplace(S, '"lineas":[]', '"lineas":' + LinesJSON, []);
  S := StringReplace(S, '"ivas":[]', '"ivas":' + IvasJSON, []);
  Result := S;
end;

function MergeHeaderIntoJSON(const Payload, NIFCliente, CodCliente, NombreCliente: string;
                             const TotalSinIVA, TotalConIVA: Double;
                             LineasTotales: Integer; CantArticulos: Double): string;
var
  S: string;
  NomCliEsc: string;
begin
  S := Payload;
  
  // Escapamos por si trae comillas, etc.
  NomCliEsc := JsonEscape(NombreCliente);
  
  S := StringReplace(S, '"cabecera":{',
        '"cabecera":{' +
        '"nifCliente":"' + JsonEscape(NIFCliente) + '",' +
        '"codCliente":"' + JsonEscape(CodCliente) + '",' +
        '"nombreCliente":"' + NomCliEsc + '",' +
        '"totalSinIVA":' + F2(TotalSinIVA) + ',' +
        '"lineasTotales":' + IntToStr(LineasTotales) + ',' +
        '"cantidadTotalArticulos":' + F2(CantArticulos) + ',', []);
  Result := S;
end;

// ----- Conexión temporal -----

function TryOpenTempConn(out Temp: TZConnection): boolean;
var
  Host, Port, DBName, UserName, Password, IniUsed: string;
  protos: array[0..4] of string = ('mariadb-10','mariadb','mysql-8','mysql-5','mysql');
  i: Integer;
begin
  Result := False;
  Temp := nil;

  // Preferir INI
  if not ReadIni(Host, Port, DBName, UserName, Password, IniUsed) then
  begin
    // Si no hay INI, usar params externos si existen
    if not GHasExtDBParams then
    begin
      WriteDiag('TryOpenTempConn: no INI ni params externos.');
      Exit(False);
    end;
    Host := GExtHost; Port := GExtPort; DBName := GExtDB; UserName := GExtUser; Password := GExtPass;
    WriteDiag('TryOpenTempConn: usando params externos.');
  end
  else
    WriteDiag('TryOpenTempConn: usando INI.');

  Temp := TZConnection.Create(nil);
  for i:=Low(protos) to High(protos) do
  begin
    try
      Temp.Protocol := protos[i];
      Temp.HostName := Host;
      Temp.Port     := StrToIntDef(Port, 3306);
      Temp.Database := DBName;
      Temp.User     := UserName;
      Temp.Password := Password;
      Temp.AutoCommit := True;
      Temp.ClientCodepage := 'utf8';
      Temp.Connect;
      WriteDiag('TryOpenTempConn: conectado con ' + protos[i]);
      Exit(True);
    except
      on E: Exception do
      begin
        WriteDiag('TryOpenTempConn fallo (' + protos[i] + '): ' + E.Message);
        try if Temp.Connected then Temp.Disconnect; except end;
      end;
    end;
  end;

  Temp.Free;
  Temp := nil;
  Result := False;
end;

// ----- Build JSON (puede usar DB o temp DB) -----

function BuildJSON(const Serie: string; Numero: Integer; const FechaISO, HoraISO: string; TotalConIVA: Double): string;
var
  skel, lines, ivas: string;
  temp: TZConnection;
  NIFCliente, CodCliente: string;
  TSin, TCon: Double;
  nLineas: Integer;
  nArt: Double;
  NombreCliente: string; // <-- NUEVO
begin
  skel := BuildJSONSkeleton(Serie, Numero, FechaISO, HoraISO, TotalConIVA);
  lines := '[]';
  ivas  := '[]';
  NIFCliente := ''; CodCliente := ''; TSin := 0; TCon := TotalConIVA; nLineas := 0; nArt := 0;
  NombreCliente := ''; // <-- inicializado


  if Assigned(GConn) and GConn.Connected then
  begin
    try
      LoadHeaderFromCab(GConn, Serie, Numero, NIFCliente, CodCliente, TSin, TCon, nLineas, nArt);
      LoadLinesAndTaxes(GConn, Serie, Numero, lines, ivas);
      // NUEVO: intentamos cargar el nombre del cliente desde la tabla clientesNNNN
      NombreCliente := LoadClienteNombreFromDB(GConn, CodCliente);
    except
      on E: Exception do WriteDiag('BuildJSON(DB) error: ' + E.Message);
    end;
  end
  else if TryOpenTempConn(temp) then
  begin
    try
      LoadHeaderFromCab(temp, Serie, Numero, NIFCliente, CodCliente, TSin, TCon, nLineas, nArt);
      LoadLinesAndTaxes(temp, Serie, Numero, lines, ivas);
      // NUEVO: nombre cliente usando conexión temporal
      NombreCliente := LoadClienteNombreFromDB(temp, CodCliente);
    finally
      try if temp.Connected then temp.Disconnect; except end;
      temp.Free;
    end;
  end
  else
    WriteDiag('BuildJSON: sin DB disponible → JSON básico.');

  Result := MergeJSON(skel, lines, ivas);
  Result := MergeHeaderIntoJSON(Result, NIFCliente, CodCliente, NombreCliente, TSin, TCon, nLineas, nArt);
end;


// ----- Queue helpers -----

procedure QueueToDB_Conn(Conn: TZConnection; const Serie: string; Numero: Integer; const FechaISO, HoraISO: string; TotalConIVA: Double; const PayloadJSON: string);
var
  qry: TZQuery;
  TipoFactura: string;
begin
  // Idempotencia: si ya existe, no insertar
  if ExistsInQueue(Conn, Serie, Numero) then
  begin
    WriteDiag('Factura ya existente en verifactu_queue (serie=' + Serie + ' num=' + IntToStr(Numero) + '). Ignorada.');
    Exit;
  end;

  // Determinamos el tipo de factura en el momento de encolar (F1/F2) según la serie
  TipoFactura := VF_DetectTipoFacturaFromSerie(Serie);

  qry := TZQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text :=
      'INSERT INTO verifactu_queue ' +
      '(serie, numero, fecha, hora, total_con_iva, estado, intentos, payload_json, hash, ' +
      ' created_at, updated_at, last_attempt_at, token, claimed_by, claimed_at, claimed_until, tipo_factura) ' +
      'VALUES (:serie, :numero, :fecha, :hora, :total, "PENDIENTE", 0, :payload, "", ' +
      ' NOW(), NOW(), NULL, NULL, NULL, NULL, NULL, :tipo_factura)';
    qry.ParamByName('serie').AsString := Serie;
    qry.ParamByName('numero').AsInteger := Numero;
    qry.ParamByName('fecha').AsString := FechaISO;
    qry.ParamByName('hora').AsString := HoraISO;
    qry.ParamByName('total').AsFloat := TotalConIVA;
    qry.ParamByName('payload').AsString := PayloadJSON;
    qry.ParamByName('tipo_factura').AsString := TipoFactura;
    qry.ExecSQL;

    WriteDiag('Insertada en DB principal (verifactu_queue) tipo_factura=' + TipoFactura + '.');

  finally
    qry.Free;
  end;

  // Copia JSON si dual-write
  if GDualWriteJSON then
  begin
    try
      WriteDiag('Copia JSON (dual-write) iniciada.');
      QueueToFiles(Serie, Numero, FechaISO, HoraISO, TotalConIVA, PayloadJSON);
    except
      on E: Exception do WriteDiag('Fallo en copia JSON (dual-write): ' + E.Message);
    end;
  end;
end;

procedure QueueToFiles(const Serie: string; Numero: Integer; const FechaISO, HoraISO: string; TotalConIVA: Double; const PayloadJSON: string);
var
  qdir, fjson, flog: string;
begin
  qdir  := IncludeTrailingPathDelimiter(DataPath) + 'queue';
  EnsureDir(qdir);
  fjson := IncludeTrailingPathDelimiter(qdir) + FormatDateTime('yyyymmdd_hhnnss_zzz', Now) +
           '_' + StringReplace(Serie, ' ', '_', [rfReplaceAll]) + '_' + IntToStr(Numero) + '.json';
  flog  := IncludeTrailingPathDelimiter(DataPath) + 'logs' + DirectorySeparator + 'verifactu.log';

  SafeSaveText(fjson, PayloadJSON);
  SafeAppendLine(flog, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + '  queued -> ' + ExtractFileName(fjson));
end;

// ----- Flujo principal -----

procedure VeriFactu_QueueFactura(
  const Serie: string;
  const Numero: Integer;
  const Fecha: TDate;
  const Hora: TTime;
  const TotalConIVA: Double
);
var
  FechaISO, HoraISO, Payload: string;
  temp: TZConnection;
begin
  try
    // Construimos el JSON intentando leer cabecera + líneas de DB (GConn o temp)
    FechaISO := FormatDateTime('yyyy-mm-dd', Fecha);
    HoraISO  := FormatDateTime('hh:nn:ss', Hora);
    Payload := BuildJSON(Serie, Numero, FechaISO, HoraISO, TotalConIVA);

    // 1) Si tenemos conexión DB viva (GConn), escribimos en DB
    if Assigned(GConn) and GConn.Connected then
    begin
      EnsureTables_DB_Conn(GConn);
      QueueToDB_Conn(GConn, Serie, Numero, FechaISO, HoraISO, TotalConIVA, Payload);
      Exit;
    end;

    // 2) Si no, intentamos una conexión temporal SOLO para escribir en DB
    if TryOpenTempConn(temp) then
    begin
      try
        EnsureTables_DB_Conn(temp);
        QueueToDB_Conn(temp, Serie, Numero, FechaISO, HoraISO, TotalConIVA, Payload);
        if GDualWriteJSON then
        begin
          QueueToFiles(Serie, Numero, FechaISO, HoraISO, TotalConIVA, Payload);
          WriteDiag('Insertada (temp-DB) + copia JSON (dual-write).');
        end
        else
          WriteDiag('Insertada en DB principal con conexión temporal.');
        Exit;
      finally
        try if temp.Connected then temp.Disconnect; except end;
        temp.Free;
      end;
    end;

    // 3) Si no hay forma de DB, volcamos a archivos
    WriteDiag('Sin DB → cola en archivos (fallback).');
    QueueToFiles(Serie, Numero, FechaISO, HoraISO, TotalConIVA, Payload);
  except
    on E: Exception do
    begin
      // Captura total para evitar diálogos en UI
      WriteDiag('EXCEPTION VeriFactu_QueueFactura: ' + E.Message);
    end;
  end;
end;

// ----------- CONCURRENCIA: RECLAMACIÓN SEGURA -----------

function GetConnForOps(out Conn: TZConnection): Boolean;
var
  temp: TZConnection;
begin
  Result := False;
  Conn := nil;
  if Assigned(GConn) and GConn.Connected then
  begin
    Conn := GConn;
    Exit(True);
  end;
  if TryOpenTempConn(temp) then
  begin
    Conn := temp; // devolveremos un temporal; el caller debe desconectar
    Exit(True);
  end;
end;

function HostTag: string;
begin
  Result := GetEnvironmentVariable('HOSTNAME');
  if Result = '' then Result := 'host';
end;

function NewToken: string;
begin
  Randomize;
  Result := Format('%s-%8.8x-%s', [HostTag, Random($7FFFFFFF), FormatDateTime('yyyymmddhhnnsszzz', Now)]);
end;

function VeriFactu_TakeNextPending(out Serie: string; out Numero: Integer;
  out PayloadJSON: string; out EncadenamientoHash: string): Boolean;
var
  ownTemp: Boolean;
  Conn: TZConnection;
  q: TZQuery;
  token: string;
begin
  Result := False;
  Serie := '';
  Numero := 0;
  PayloadJSON := '';
  EncadenamientoHash := '';

  ownTemp := False;
  if not GetConnForOps(Conn) then
  begin
    WriteDiag('TakeNextPending: no hay conexión DB.');
    Exit(False);
  end;
  if Conn <> GConn then ownTemp := True;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    token := NewToken;

    // Reclamo seguro de una PENDIENTE
    q.SQL.Text :=
      'UPDATE verifactu_queue ' +
      'SET estado="EN_PROCESO", token=:t, claimed_by=:cb, claimed_at=NOW(), ' +
      '    claimed_until=DATE_ADD(NOW(), INTERVAL 10 MINUTE), intentos=intentos+1, updated_at=NOW(), last_attempt_at=NOW() ' +
      'WHERE estado="PENDIENTE" ' +
      'ORDER BY created_at ASC ' +
      'LIMIT 1';
    q.ParamByName('t').AsString  := token;
    q.ParamByName('cb').AsString := HostTag;
    q.ExecSQL;

    if q.RowsAffected = 0 then
      Exit(False);

    // 2) Obtenemos serie, numero y payload_json de la fila reclamada
    q.Close;
    q.SQL.Text := 'SELECT serie, numero, payload_json FROM verifactu_queue WHERE token=:t LIMIT 1';
    q.ParamByName('t').AsString := token;
    q.Open;
    if q.IsEmpty then
    begin
      WriteDiag('TakeNextPending: no fila por token tras UPDATE.');
      Exit(False);
    end;

    Serie := q.FieldByName('serie').AsString;
    Numero := q.FieldByName('numero').AsInteger;
    PayloadJSON := q.FieldByName('payload_json').AsString;

    // 3) AHORA SÍ: recalculamos hash_prev en este momento
    VF_AttachHashToQueue(Conn, Serie, Numero, PayloadJSON, 'ALTA');

    // 4) Volvemos a leer la fila, ahora con hash y hash_prev actualizados
    q.Close;
    q.SQL.Text :=
      'SELECT serie, numero, payload_json, hash, hash_prev ' +
      'FROM verifactu_queue WHERE token=:t LIMIT 1';
    q.ParamByName('t').AsString := token;
    q.Open;
    if q.IsEmpty then
    begin
      WriteDiag('TakeNextPending: no fila por token (2ª lectura).');
      Exit(False);
    end;

    Serie            := q.FieldByName('serie').AsString;
    Numero           := q.FieldByName('numero').AsInteger;
    PayloadJSON      := q.FieldByName('payload_json').AsString;

    EncadenamientoHash := q.FieldByName('hash').AsString;
    GHash              := q.FieldByName('hash').AsString;
    GHashPrev          := q.FieldByName('hash_prev').AsString;

    Result := True;
  finally
    q.Free;
    if ownTemp then
    begin
      try
        if Conn.Connected then Conn.Disconnect;
      except
      end;
      Conn.Free;
    end;
  end;
end;

procedure VeriFactu_MarkSent(const Serie: string; const Numero: Integer; const Hash: string = ''; const Respuesta: string = '');
var
  ownTemp: Boolean;
  Conn: TZConnection;
  q: TZQuery;
begin
  ownTemp := False;
  if not GetConnForOps(Conn) then
  begin
    WriteDiag('MarkSent: no hay conexión DB.');
    Exit;
  end;
  if Conn <> GConn then ownTemp := True;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
  			'UPDATE verifactu_queue SET ' +
  			'estado="ENVIADO", ' +
  			'hash = IF(:h<>"", :h, hash), ' +  // si :h está vacío, conserva el hash actual
  			'respuesta_text = :r, ' +
  			'last_error=NULL, ' +
  			'intentos=intentos+1, ' +
  			'updated_at=NOW(), ' +
  			'token=NULL, claimed_by=NULL, claimed_until=NULL ' +
  			'WHERE serie=:s AND numero=:n LIMIT 1';

    q.ParamByName('h').AsString := Hash;
    q.ParamByName('r').AsString := Respuesta;
    q.ParamByName('s').AsString := Serie;
    q.ParamByName('n').AsInteger := Numero;
    q.ExecSQL;
    WriteDiag('MarkSent: ' + Serie + '-' + IntToStr(Numero) + ' → ENVIADO.');
  finally
    q.Free;
    if ownTemp then
    begin
      try if Conn.Connected then Conn.Disconnect; except end;
      Conn.Free;
    end;
  end;
end;

procedure VeriFactu_MarkError(const Serie: string; const Numero: Integer; const MensajeError: string; const Respuesta: string = '');
var
  ownTemp: Boolean;
  Conn: TZConnection;
  q: TZQuery;
begin
  ownTemp := False;
  if not GetConnForOps(Conn) then
  begin
    WriteDiag('MarkError: no hay conexión DB.');
    Exit;
  end;
  if Conn <> GConn then ownTemp := True;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'UPDATE verifactu_queue SET estado="ERROR", last_error=:e, respuesta_text=:r, updated_at=NOW(), token=NULL, claimed_by=NULL, claimed_until=NULL ' +
      'WHERE serie=:s AND numero=:n LIMIT 1';
    q.ParamByName('e').AsString := Copy(MensajeError, 1, 255);
    q.ParamByName('r').AsString := Respuesta;
    q.ParamByName('s').AsString := Serie;
    q.ParamByName('n').AsInteger := Numero;
    q.ExecSQL;
    WriteDiag('MarkError: ' + Serie + '-' + IntToStr(Numero) + ' → ERROR (' + MensajeError + ').');
  finally
    q.Free;
    if ownTemp then
    begin
      try if Conn.Connected then Conn.Disconnect; except end;
      Conn.Free;
    end;
  end;
end;

procedure VeriFactu_ResetToPending(const Serie: string; const Numero: Integer);
var
  ownTemp: Boolean;
  Conn: TZConnection;
  q: TZQuery;
begin
  ownTemp := False;
  if not GetConnForOps(Conn) then
  begin
    WriteDiag('ResetToPending: no hay conexión DB.');
    Exit;
  end;
  if Conn <> GConn then ownTemp := True;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'UPDATE verifactu_queue SET estado="PENDIENTE", last_error=NULL, respuesta_text=NULL, updated_at=NOW(), token=NULL, claimed_by=NULL, claimed_until=NULL ' +
      'WHERE serie=:s AND numero=:n LIMIT 1';
    q.ParamByName('s').AsString := Serie;
    q.ParamByName('n').AsInteger := Numero;
    q.ExecSQL;
    WriteDiag('ResetToPending: ' + Serie + '-' + IntToStr(Numero) + ' → PENDIENTE.');
  finally
    q.Free;
    if ownTemp then
    begin
      try if Conn.Connected then Conn.Disconnect; except end;
      Conn.Free;
    end;
  end;
end;

procedure VeriFactu_RequeueStuck(InMinutes: Integer = 10);
var
  ownTemp: Boolean;
  Conn: TZConnection;
  q: TZQuery;
begin
  ownTemp := False;
  if not GetConnForOps(Conn) then
  begin
    WriteDiag('RequeueStuck: no hay conexión DB.');
    Exit;
  end;
  if Conn <> GConn then ownTemp := True;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'UPDATE verifactu_queue ' +
      'SET estado="PENDIENTE", token=NULL, claimed_by=NULL, claimed_until=NULL ' +
      'WHERE estado="EN_PROCESO" AND (claimed_until IS NULL OR claimed_until < NOW())';
    q.ExecSQL;
    if q.RowsAffected > 0 then
      WriteDiag(Format('RequeueStuck: reactivadas %d entradas.', [q.RowsAffected]));
  finally
    q.Free;
    if ownTemp then
    begin
      try if Conn.Connected then Conn.Disconnect; except end;
      Conn.Free;
    end;
  end;
end;

end.
