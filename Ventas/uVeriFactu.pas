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
procedure VeriFactu_ForceTempConnectionForCurrentThread(const AForce: Boolean);

// Habilita/deshabilita la escritura dual (DB + copia .json). Por defecto: True
procedure VeriFactu_EnableDualWriteJSON(const Enable: Boolean);

// -------- Control de estados / reintentos / concurrencia --------

// Reclamación segura (multiusuario) del siguiente pendiente.
// Devuelve False si no hay pendientes reclamables.
function VeriFactu_TakeNextPending(out Serie: string; out Numero: Integer;
  out PayloadJSON: string; out EncadenamientoHash: string): Boolean;



// Reclama UNA factura concreta PENDIENTE (serie+numero) y recalcula encadenamiento.
function VeriFactu_TakeSpecificPending(const SerieIn: string; const NumeroIn: Integer;
  out PayloadJSON: string; out EncadenamientoHash: string): Boolean;

// Marca una factura como ENVIADO. Permite guardar hash y respuesta (opcional).
procedure VeriFactu_MarkSent(const Serie: string; const Numero: Integer; const Hash: string = ''; const Respuesta: string = '');

// Marca una factura como ERROR (y deja el mensaje). Mantiene payload para reintentos.
procedure VeriFactu_MarkError(const Serie: string; const Numero: Integer; const MensajeError: string; const Respuesta: string = '');

// Error técnico/transitorio: queda en PENDIENTE para reintento automático continuado.
// No depende de revisión manual; mantiene el orden porque las posteriores esperan a esta fila.
procedure VeriFactu_MarkRetryOrError(const Serie: string; const Numero: Integer; const MensajeError: string; const Respuesta: string = '');

// Devuelve una factura a estado PENDIENTE (por ejemplo tras corregir).
procedure VeriFactu_ResetToPending(const Serie: string; const Numero: Integer);

// Recoloca en PENDIENTE las bloqueadas en EN_PROCESO cuyo "lease" haya expirado.
procedure VeriFactu_RequeueStuck(InMinutes: Integer = 10);

// Hacemos pública la función para obtener el número de id
function GetMachineUUIDFromFile: string;

implementation

uses
  IniFiles, ZConnection, ZDataset, uVeriHash, uVF_HashChain, uVeriChain, uVeriChainCheck,
  Global, uFLX_CryptoIni; // <-- Para tener acceso a las variables Nif, Empresa y vfUrlTP

const
  // Límite conservador para que los logs de VeriFactu no crezcan sin control.
  // Mantiene las últimas líneas útiles para diagnóstico sin ralentizar el TPV.
  VF_LOG_MAX_LINES      = 2000;
  VF_LOG_TRIM_AT_BYTES  = 512 * 1024; // recorta cuando supera 512 KB
  VF_LOG_MAX_LINE_CHARS = 4000;       // evita líneas enormes tipo XML completo
  VF_MAX_AUTO_ATTEMPTS  = 3;          // umbral informativo; los fallos técnicos siguen reintentándose automáticamente


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

threadvar
  GVFForceTempConnection: Boolean;

// Escritura dual (DB + .json)
var
  GDualWriteJSON: Boolean = True; // confirmado por el usuario
  MotorDB: String = 'MyISAM';     // motor bbdd en creación, que será sustituido por un módulo variable ARIA, MyISAM, InnoDB
  GVFSchemaCheckedOK: Boolean = False; // estructura comprobada OK en esta ejecucion
  GVFSchemaCheckAttempted: Boolean = False; // evita reintentar comprobaciones/migraciones en cada factura si quedaron aplazadas

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

function VF_LimitLogLine(const S: string): string;
begin
  Result := S;
  if Length(Result) > VF_LOG_MAX_LINE_CHARS then
    Result := Copy(Result, 1, VF_LOG_MAX_LINE_CHARS) +
              ' ... [TRUNCADO, longitud original=' + IntToStr(Length(S)) + ' caracteres]';
end;

function VF_GetFileSizeBytes(const FileName: string): Int64;
var
  FS: TFileStream;
begin
  Result := 0;
  if not FileExists(FileName) then
    Exit;

  FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    Result := FS.Size;
  finally
    FS.Free;
  end;
end;

procedure VF_TrimLogFile(const FileName: string);
var
  SL, LastLines: TStringList;
  I, StartIdx: Integer;
begin
  try
    if (VF_LOG_MAX_LINES <= 0) or (not FileExists(FileName)) then
      Exit;

    // Para no penalizar cada escritura, solo recortamos cuando el fichero ya pesa.
    if VF_GetFileSizeBytes(FileName) < VF_LOG_TRIM_AT_BYTES then
      Exit;

    SL := TStringList.Create;
    LastLines := TStringList.Create;
    try
      SL.LoadFromFile(FileName);
      if SL.Count <= VF_LOG_MAX_LINES then
        Exit;

      StartIdx := SL.Count - VF_LOG_MAX_LINES;
      for I := StartIdx to SL.Count - 1 do
        LastLines.Add(SL[I]);

      LastLines.SaveToFile(FileName);
    finally
      LastLines.Free;
      SL.Free;
    end;
  except
    on E: Exception do ; // el log nunca debe romper el flujo
  end;
end;

procedure SafeAppendLine(const FileName, Line: string);
var
  FS: TFileStream;
  S : string;
begin
  try
    EnsureDir(ExtractFilePath(FileName));

    if FileExists(FileName) then
      FS := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone)
    else
      FS := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);

    try
      FS.Position := FS.Size;
      S := VF_LimitLogLine(Line) + LineEnding;
      if S <> '' then
        FS.WriteBuffer(Pointer(S)^, Length(S));
    finally
      FS.Free;
    end;

    VF_TrimLogFile(FileName);
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
  GVFSchemaCheckedOK := False; // si cambia la conexion/BBDD, revalidamos estructura una vez
  GVFSchemaCheckAttempted := False;
  if GHasExtDBParams then
    WriteDiag('Recibidos DB params externos para modo MIXTO.');
end;

procedure VeriFactu_ForceTempConnectionForCurrentThread(const AForce: Boolean);
begin
  GVFForceTempConnection := AForce;
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
      //-- Password := ini.ReadString('mariadb','password',Password);
      Password := FLX_IniReadPassword(ini, 'mariadb', 'password', Password);
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

  // Rectificativa de factura simplificada: FS-R26, FS-R25, etc.
  // Debe ir como R5, no como F2.
  if (Copy(SUp, 1, 4) = 'FS-R') or (Copy(SUp, 1, 5) = 'FS-R-') then
    Exit('R5');

  // Rectificativa de factura completa: R26, R25, etc.
  // Usamos R1 como tipo general de rectificativa por diferencias.
  if (Length(SUp) >= 1) and (SUp[1] = 'R') then
    Exit('R1');

  // Tickets TPV / factura simplificada normal: FS-A26, FS-B26, etc.
  if (Copy(SUp, 1, 3) = 'FS-') or (Copy(SUp, 1, 2) = 'FS') then
    Exit('F2');

  // Resto: factura completa normal.
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
      '"tipoFactura":"' + JsonEscape(VF_DetectTipoFacturaFromSerie(Serie)) + '",' +
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

function ColumnExists(Conn: TZConnection; const TableName, ColumnName: string): Boolean;
var
  q: TZQuery;
begin
  Result := False;
  if (Conn = nil) or (not Conn.Connected) then Exit;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS ' +
      'WHERE TABLE_SCHEMA=:db AND TABLE_NAME=:t AND COLUMN_NAME=:c LIMIT 1';
    q.ParamByName('db').AsString := CurrentDatabase(Conn);
    q.ParamByName('t').AsString := TableName;
    q.ParamByName('c').AsString := ColumnName;
    q.Open;
    Result := not q.IsEmpty;
  finally
    q.Free;
  end;
end;

function IndexExists(Conn: TZConnection; const TableName, IndexName: string): Boolean;
var
  q: TZQuery;
begin
  Result := False;
  if (Conn = nil) or (not Conn.Connected) then Exit;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS ' +
      'WHERE TABLE_SCHEMA=:db AND TABLE_NAME=:t AND INDEX_NAME=:i LIMIT 1';
    q.ParamByName('db').AsString := CurrentDatabase(Conn);
    q.ParamByName('t').AsString := TableName;
    q.ParamByName('i').AsString := IndexName;
    q.Open;
    Result := not q.IsEmpty;
  finally
    q.Free;
  end;
end;

function GetColumnInfo(Conn: TZConnection; const TableName, ColumnName: string;
  out ColumnType, IsNullable, ColumnDefault: string): Boolean;
var
  q: TZQuery;
begin
  Result := False;
  ColumnType := '';
  IsNullable := '';
  ColumnDefault := '';

  if (Conn = nil) or (not Conn.Connected) then Exit;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'SELECT COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT ' +
      'FROM INFORMATION_SCHEMA.COLUMNS ' +
      'WHERE TABLE_SCHEMA=:db AND TABLE_NAME=:t AND COLUMN_NAME=:c LIMIT 1';
    q.ParamByName('db').AsString := CurrentDatabase(Conn);
    q.ParamByName('t').AsString := TableName;
    q.ParamByName('c').AsString := ColumnName;
    q.Open;
    if not q.IsEmpty then
    begin
      ColumnType := q.FieldByName('COLUMN_TYPE').AsString;
      IsNullable := q.FieldByName('IS_NULLABLE').AsString;
      if q.FieldByName('COLUMN_DEFAULT').IsNull then
        ColumnDefault := ''
      else
        ColumnDefault := q.FieldByName('COLUMN_DEFAULT').AsString;
      Result := True;
    end;
  finally
    q.Free;
  end;
end;

function VF_QueueRuntimeSchemaOK(Conn: TZConnection; out Missing: string): Boolean;

  procedure NeedCol(const C: string);
  begin
    if not ColumnExists(Conn, 'verifactu_queue', C) then
    begin
      if Missing <> '' then
        Missing := Missing + ', ';
      Missing := Missing + C;
      Result := False;
    end;
  end;

begin
  Result := True;
  Missing := '';

  if (Conn = nil) or (not Conn.Connected) then
  begin
    Result := False;
    Missing := 'sin conexion';
    Exit;
  end;

  if not TableExists(Conn, 'verifactu_queue') then
  begin
    Result := False;
    Missing := 'tabla verifactu_queue inexistente';
    Exit;
  end;

  // Columnas usadas por encolado, monitor, envio y encadenamiento.
  NeedCol('id');
  NeedCol('serie');
  NeedCol('numero');
  NeedCol('fecha');
  NeedCol('hora');
  NeedCol('total_con_iva');
  NeedCol('estado');
  NeedCol('intentos');
  NeedCol('payload_json');
  NeedCol('hash');
  NeedCol('hash_prev');
  NeedCol('respuesta_text');
  NeedCol('last_error');
  NeedCol('last_attempt_at');
  NeedCol('token');
  NeedCol('claimed_by');
  NeedCol('claimed_at');
  NeedCol('claimed_until');
  NeedCol('fecha_isoz');
  NeedCol('canonical');
  NeedCol('tipo_factura');
  NeedCol('created_at');
  NeedCol('updated_at');
end;

function VF_OtherDBSessionsExist(Conn: TZConnection): Boolean;
var
  q: TZQuery;
begin
  // Para DDL somos deliberadamente conservadores: si no podemos comprobarlo,
  // asumimos que NO es seguro modificar estructura automaticamente.
  Result := True;
  if (Conn = nil) or (not Conn.Connected) then Exit;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'SELECT COUNT(*) AS n ' +
      'FROM INFORMATION_SCHEMA.PROCESSLIST ' +
      'WHERE DB=:db AND ID<>CONNECTION_ID()';
    q.ParamByName('db').AsString := CurrentDatabase(Conn);
    q.Open;
    Result := q.FieldByName('n').AsInteger > 0;
  except
    on E: Exception do
    begin
      WriteDiag('VF_OtherDBSessionsExist: no se pudo comprobar PROCESSLIST; DDL automatico no seguro: ' + E.Message);
      Result := True;
    end;
  end;
  q.Free;
end;

function VF_TryExecDDLSafe(Conn: TZConnection; const SQLText, Desc: string): Boolean;
var
  q: TZQuery;
  OldTimeout: Integer;
begin
  Result := False;
  if (Conn = nil) or (not Conn.Connected) then Exit;

  if VF_OtherDBSessionsExist(Conn) then
  begin
    WriteDiag(Desc + ' aplazado: hay otros puestos/conexiones usando la BBDD. SQL=' + SQLText);
    Exit;
  end;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    OldTimeout := -1;

    try
      q.SQL.Text := 'SELECT @@SESSION.lock_wait_timeout AS t';
      q.Open;
      if not q.IsEmpty then
        OldTimeout := q.FieldByName('t').AsInteger;
      q.Close;
    except
      on E: Exception do
      begin
        try q.Close; except end;
        WriteDiag('VF_TryExecDDLSafe: no se pudo leer lock_wait_timeout: ' + E.Message);
      end;
    end;

    try
      q.SQL.Text := 'SET SESSION lock_wait_timeout = 3';
      q.ExecSQL;
    except
      on E: Exception do
        WriteDiag('VF_TryExecDDLSafe: no se pudo fijar lock_wait_timeout=3: ' + E.Message);
    end;

    try
      q.SQL.Text := SQLText;
      q.ExecSQL;
      Result := True;
      WriteDiag(Desc + ' ejecutado.');
    except
      on E: Exception do
        WriteDiag(Desc + ' cancelado/error DDL: ' + E.Message);
    end;

    if OldTimeout > 0 then
    begin
      try
        q.SQL.Text := 'SET SESSION lock_wait_timeout = ' + IntToStr(OldTimeout);
        q.ExecSQL;
      except
        on E: Exception do
          WriteDiag('VF_TryExecDDLSafe: no se pudo restaurar lock_wait_timeout: ' + E.Message);
      end;
    end;
  finally
    q.Free;
  end;
end;

function VF_AddColumnIfMissing(Conn: TZConnection; const TableName, ColumnName, ColumnDDL: string): Boolean;
begin
  Result := True;
  if ColumnExists(Conn, TableName, ColumnName) then
    Exit;

  Result := VF_TryExecDDLSafe(Conn,
    'ALTER TABLE ' + QuoteIdent(TableName) + ' ADD COLUMN ' + ColumnDDL,
    'ADD COLUMN ' + TableName + '.' + ColumnName);
end;

function VF_AddIndexIfMissing(Conn: TZConnection; const TableName, IndexName, IndexDDL: string): Boolean;
begin
  Result := True;
  if IndexExists(Conn, TableName, IndexName) then
    Exit;

  Result := VF_TryExecDDLSafe(Conn,
    'ALTER TABLE ' + QuoteIdent(TableName) + ' ADD ' + IndexDDL,
    'ADD INDEX ' + TableName + '.' + IndexName);
end;

function VF_TipoFacturaNeedsModify(Conn: TZConnection): Boolean;
var
  CT, Nul, Def: string;
begin
  Result := True;
  if not GetColumnInfo(Conn, 'verifactu_queue', 'tipo_factura', CT, Nul, Def) then
    Exit;

  CT := LowerCase(Trim(CT));
  Nul := UpperCase(Trim(Nul));
  Def := UpperCase(Trim(Def));

  Result := not ((CT = 'char(2)') and (Nul = 'NO') and (Def = 'F1'));
end;

function VF_EstadoNeedsModify(Conn: TZConnection): Boolean;
var
  CT, Nul, Def, U: string;
begin
  Result := True;
  if not GetColumnInfo(Conn, 'verifactu_queue', 'estado', CT, Nul, Def) then
    Exit;

  U := UpperCase(CT);
  Nul := UpperCase(Trim(Nul));
  Def := UpperCase(Trim(Def));

  Result := not (
    (Pos('PENDIENTE', U) > 0) and
    (Pos('EN_PROCESO', U) > 0) and
    (Pos('ENVIADO', U) > 0) and
    (Pos('ERROR', U) > 0) and
    (Nul = 'NO') and
    (Def = 'PENDIENTE')
  );
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


// -----------------------------------------------------------------------------
// F2/R5: carga de desglose real desde ivaNNNN
// -----------------------------------------------------------------------------
// ventas.pas llama a ActualizaIva() antes de encolar Veri*Factu. Ahí deja una fila
// por línea en ivaNNNN con Serie interna (A26/R26, sin prefijo FS-), Operacion,
// Base, Iva, TIva y Total. Las facturas F1/R1 siguen usando factuc/factud.

function VF_InternalSerieForIva(const SerieAEAT: string): string;
begin
  Result := Trim(UpperCase(SerieAEAT));
  if Copy(Result, 1, 3) = 'FS-' then
    Delete(Result, 1, 3);
end;

function DetectIvaTableExact(Conn: TZConnection; out TableName: string): boolean;
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
      'WHERE TABLE_SCHEMA=:db AND TABLE_NAME REGEXP ''^iva[0-9]{4}$'' ORDER BY TABLE_NAME';
    q.ParamByName('db').AsString := CurrentDatabase(Conn);
    q.Open;
    while not q.EOF do
    begin
      t := q.Fields[0].AsString;
      if TableHasColumns(Conn, t, ['Operacion','Serie','Base','Iva','TIva','Total']) then
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

procedure LoadTaxesFromIvaTable(Conn: TZConnection; const Serie: string; Numero: Integer;
  out IvasJSON: string);
var
  tname, SerieInt, ivaKey: string;
  q: TZQuery;
  i: Integer;
  baseV, ivaV: Double;

  function ReadF(const F: string): Double;
  begin
    try
      Result := q.FieldByName(F).AsFloat;
    except
      Result := 0;
    end;
  end;

begin
  IvasJSON := '[]';

  if not DetectIvaTableExact(Conn, tname) then
  begin
    WriteDiag('FIX_F2_IVA_PAYLOAD_V2: no se detectó tabla ivaNNNN con columnas Operacion,Serie,Base,Iva,TIva,Total.');
    Exit;
  end;

  SerieInt := VF_InternalSerieForIva(Serie);

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'SELECT ' + QuoteIdent('TIva') + ' AS TIva, ' +
      'SUM(' + QuoteIdent('Base') + ') AS BaseSum, ' +
      'SUM(' + QuoteIdent('Iva') + ') AS IvaSum, ' +
      'SUM(' + QuoteIdent('Total') + ') AS TotalSum ' +
      'FROM ' + QuoteIdent(tname) + ' ' +
      'WHERE ' + QuoteIdent('Serie') + '=:serie AND ' + QuoteIdent('Operacion') + '=:num ' +
      'GROUP BY ' + QuoteIdent('TIva') + ' ORDER BY ' + QuoteIdent('TIva');
    q.ParamByName('serie').AsString := SerieInt;
    q.ParamByName('num').AsInteger := Numero;
    q.Open;

    IvasJSON := '[';
    i := 0;
    while not q.EOF do
    begin
      ivaKey := F2(ReadF('TIva'));
      baseV := ReadF('BaseSum');
      ivaV  := ReadF('IvaSum');

      if i > 0 then
        IvasJSON := IvasJSON + ',';

      IvasJSON := IvasJSON + '{' +
        '"tipo":"' + JsonEscape(ivaKey) + '",' +
        '"base":' + F2(baseV) + ',' +
        '"cuota":' + F2(ivaV) +
      '}';

      Inc(i);
      q.Next;
    end;
    IvasJSON := IvasJSON + ']';

    if i = 0 then
      WriteDiag('FIX_F2_IVA_PAYLOAD_V2: sin filas en ' + tname +
        ' para serie interna=' + SerieInt + ' numero=' + IntToStr(Numero))
    else
      WriteDiag('FIX_F2_IVA_PAYLOAD_V2: IVA cargado desde ' + tname +
        ' serie interna=' + SerieInt + ' numero=' + IntToStr(Numero) +
        ' grupos=' + IntToStr(i) + ' json=' + IvasJSON);
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
  Missing: string;
begin
  if (Conn = nil) or (not Conn.Connected) then
    Exit;

  // Si en esta ejecucion ya hemos comprobado que la estructura esta bien,
  // no repetimos comprobaciones ni migraciones en cada factura.
  if GVFSchemaCheckedOK then
    Exit;

  // Si ya se intento comprobar/migrar y quedo algo pendiente/aplazado,
  // no se reintenta en cada factura. Esto evita coste en INFORMATION_SCHEMA,
  // logs repetidos y nuevos intentos DDL durante ventas/facturacion.
  // La migracion pendiente debe ejecutarse desde Actualizador/Utilidades
  // con todos los puestos cerrados, o al reiniciar cuando ya sea seguro.
  if GVFSchemaCheckAttempted then
    Exit;

  GVFSchemaCheckAttempted := True;

  qry := TZQuery.Create(nil);
  try
    qry.Connection := Conn;

    // verifactu_config: crear si no existe. Crear una tabla inexistente no tiene el
    // mismo riesgo que modificar una tabla en uso.
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

    // Migraciones condicionadas de verifactu_config: solo si falta la columna,
    // nunca por costumbre, y solo si no hay otros puestos/conexiones.
    VF_AddColumnIfMissing(Conn, 'verifactu_config', 'cert_pass_enc',
      'cert_pass_enc VARCHAR(64) NULL');
    VF_AddColumnIfMissing(Conn, 'verifactu_config', 'endpoint_local',
      'endpoint_local VARCHAR(255) DEFAULT "http://127.0.0.1:8080/verifactu/test"');

    // verifactu_config: insertar fila inicial si está vacía
    try
      qry.Close;
      qry.SQL.Text := 'SELECT COUNT(*) AS c FROM verifactu_config';
      qry.Open;
      if (not qry.EOF) and (qry.Fields[0].AsInteger = 0) then
      begin
        qry.Close;

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

    // verifactu_queue: crear si no existe con la estructura final conocida.
    if not TableExists(Conn, 'verifactu_queue') then
    begin
      try
        qry.Close;
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

    // Migraciones condicionadas de verifactu_queue.
    // IMPORTANTE: antes se ejecutaban ALTER TABLE siempre, aunque la columna ya
    // estuviera bien. Ahora se consulta INFORMATION_SCHEMA y solo se ejecuta DDL
    // si falta o difiere algo. Ademas, el DDL se aplaza si hay otros puestos y
    // lleva lock_wait_timeout=3 para no congelar ventas/facturacion.
    if TableExists(Conn, 'verifactu_queue') then
    begin
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'last_attempt_at', 'last_attempt_at DATETIME NULL');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'token', 'token VARCHAR(64) NULL');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'claimed_by', 'claimed_by VARCHAR(64) NULL');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'claimed_at', 'claimed_at DATETIME NULL');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'claimed_until', 'claimed_until DATETIME NULL');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'hash_prev', 'hash_prev VARCHAR(64) DEFAULT NULL');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'fecha_isoz', 'fecha_isoz VARCHAR(30) NULL DEFAULT NULL');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'canonical', 'canonical TEXT NULL');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'tipo_factura', 'tipo_factura CHAR(2) NOT NULL DEFAULT "F1"');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'payload_json', 'payload_json MEDIUMTEXT');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'respuesta_text', 'respuesta_text MEDIUMTEXT');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'last_error', 'last_error VARCHAR(255)');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'hash', 'hash VARCHAR(128)');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'intentos', 'intentos INT NOT NULL DEFAULT 0');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'created_at', 'created_at DATETIME NULL');
      VF_AddColumnIfMissing(Conn, 'verifactu_queue', 'updated_at', 'updated_at DATETIME NULL');

      if ColumnExists(Conn, 'verifactu_queue', 'token') then
        VF_AddIndexIfMissing(Conn, 'verifactu_queue', 'idx_token', 'KEY idx_token (token)');

      if ColumnExists(Conn, 'verifactu_queue', 'estado') and VF_EstadoNeedsModify(Conn) then
        VF_TryExecDDLSafe(Conn,
          'ALTER TABLE verifactu_queue MODIFY COLUMN estado ENUM("PENDIENTE","EN_PROCESO","ENVIADO","ERROR") NOT NULL DEFAULT "PENDIENTE"',
          'MODIFY verifactu_queue.estado');

      if ColumnExists(Conn, 'verifactu_queue', 'tipo_factura') and VF_TipoFacturaNeedsModify(Conn) then
        VF_TryExecDDLSafe(Conn,
          'ALTER TABLE verifactu_queue MODIFY COLUMN tipo_factura CHAR(2) NOT NULL DEFAULT "F1"',
          'MODIFY verifactu_queue.tipo_factura');
    end;

    if VF_QueueRuntimeSchemaOK(Conn, Missing) then
    begin
      GVFSchemaCheckedOK := True;
      WriteDiag('Estructura verifactu_queue comprobada OK; no se repetira en esta ejecucion.');
    end
    else
    begin
      GVFSchemaCheckedOK := False;
      WriteDiag('Estructura verifactu_queue pendiente de migracion: ' + Missing +
        '. No se debe bloquear la facturacion; se usara copia JSON si no se puede insertar en DB.');
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



function DetectHistoTableExact(Conn: TZConnection; out TableName: string): boolean;
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
      'WHERE TABLE_SCHEMA=:db AND TABLE_NAME REGEXP ''^hisopcc[0-9]{4}$'' ORDER BY TABLE_NAME';
    q.ParamByName('db').AsString := CurrentDatabase(Conn);
    q.Open;
    while not q.EOF do
    begin
      t := q.Fields[0].AsString;
      // Requisitos mínimos para leer la rectificación desde histórico
      if TableHasColumns(Conn, t, ['HO0','HO1','HO2','HO3','HO4','HO20_RECT']) then
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

function VF_NormalizeRectifTag(const S: string): string;
begin
  Result := Trim(S);
  // Evita ';' final, por consistencia con el formato que usas en facturas
  while (Result <> '') and (Result[Length(Result)] = ';') do
    Delete(Result, Length(Result), 1);
end;

function LoadRectifTagFromFacturaObs(Conn: TZConnection; const Serie: string; Numero: Integer): string;
var
  tname: string;
  q: TZQuery;
  obs: string;
  p: Integer;
begin
  Result := '';
  if not DetectCabTableExact(Conn, tname) then Exit;

  q := TZQuery.Create(nil);
  try
    try
      q.Connection := Conn;
      // FC19 = observaciones (si existe en tu schema)
      q.SQL.Text := 'SELECT FC19 FROM ' + QuoteIdent(tname) + ' WHERE FC2=:serie AND FC3=:num LIMIT 1';
      q.ParamByName('serie').AsString := Serie;
      q.ParamByName('num').AsInteger := Numero;
      q.Open;
      if not q.IsEmpty then
      begin
        obs := q.Fields[0].AsString;
        p := Pos('VF_RECTIF:', obs);
        if p > 0 then
          Result := VF_NormalizeRectifTag(Copy(obs, p, 255));
      end;
    except
      // Si FC19 no existe o hay cualquier problema, simplemente no devolvemos tag
      Result := '';
    end;
  finally
    q.Free;
  end;
end;

function LoadRectifTagFromHisto(Conn: TZConnection; const Serie: string; Numero: Integer;
  const FechaISO, HoraISO: string): string;
var
  tname: string;
  q: TZQuery;
  d: TDate;
  t: TTime;
  cand1, cand2, cand3, tail: string;
  p: Integer;

  function ParseISODate(const S: string; out AD: TDate): Boolean;
  var
    Y, M, Dd: Word;
  begin
    Result := False;
    if Length(S) < 10 then Exit;
    try
      Y  := StrToInt(Copy(S, 1, 4));
      M  := StrToInt(Copy(S, 6, 2));
      Dd := StrToInt(Copy(S, 9, 2));
      AD := EncodeDate(Y, M, Dd);
      Result := True;
    except
      Result := False;
    end;
  end;

  function ParseISOTime(const S: string; out AT: TTime): Boolean;
  var
    H, N, Sec: Word;
  begin
    Result := False;
    if Length(S) < 8 then Exit;
    try
      H   := StrToInt(Copy(S, 1, 2));
      N   := StrToInt(Copy(S, 4, 2));
      Sec := StrToInt(Copy(S, 7, 2));
      AT := EncodeTime(H, N, Sec, 0);
      Result := True;
    except
      Result := False;
    end;
  end;

  function TrimTo3(const S: string): string;
  begin
    Result := Trim(S);
    if Length(Result) > 3 then
      Result := Copy(Result, 1, 3);
  end;

  function SameCand(const A, B: string): Boolean;
  begin
    Result := (A <> '') and (B <> '') and (AnsiCompareText(A, B) = 0);
  end;

  function TryWithSerie(const S: string): Boolean;
  begin
    Result := False;
    if S = '' then Exit;
    if q.Active then q.Close;
    q.ParamByName('serie').AsString := S;
    q.Open;
    Result := not q.IsEmpty;
  end;

begin
  Result := '';
  if not DetectHistoTableExact(Conn, tname) then Exit;

  // Parse defensivo de fecha/hora (sin depender de ISO8601ToDate)
  if (not ParseISODate(FechaISO, d)) or (not ParseISOTime(HoraISO, t)) then
    Exit;

  // Candidatos de serie para hisopcc.HO4 (3 chars):
  // - Si Serie ya viene en 3 caracteres, probamos tal cual.
  // - Si viene como serie VF (p.ej. 'FS-XX' / 'RYY' / etc.), probamos la parte derecha y/o últimos 3.
  cand1 := '';
  cand2 := '';
  cand3 := '';

  if Length(Trim(Serie)) <= 3 then
    cand1 := Trim(Serie);

  // Parte derecha después de 'FS-' o del primer '-'
  if Length(Serie) > 3 then
  begin
    tail := Serie;
    if (Length(Serie) >= 3) and (AnsiCompareText(Copy(Serie, 1, 3), 'FS-') = 0) then
      tail := Copy(Serie, 4, 255)
    else
    begin
      p := Pos('-', Serie);
      if p > 0 then
        tail := Copy(Serie, p + 1, 255);
    end;
    cand2 := TrimTo3(tail);

    // Últimos 3 caracteres como fallback
    if Length(Serie) >= 3 then
      cand3 := Copy(Serie, Length(Serie) - 2, 3);
  end;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    // HO4 es CHAR(3) en hisopcc, por lo que la serie VF tipo "FS-XXX" no casa.
    // Buscamos por fecha + serie interna (3 chars) + número. La hora se usa si está disponible,
    // pero no es imprescindible para localizar el registro.
    q.SQL.Text :=
      'SELECT HO20_RECT FROM ' + QuoteIdent(tname) +
      ' WHERE HO0=:d AND HO4=:serie AND HO3=:num AND (HO1=:t OR :t IS NULL)' +
      ' ORDER BY HO1 DESC LIMIT 1';
    q.ParamByName('d').AsDate := d;
    q.ParamByName('num').AsInteger := Numero;
    q.ParamByName('t').AsTime := t;

    // Intentamos con varios candidatos (sin duplicados)
    if TryWithSerie(cand1) then
      Result := VF_NormalizeRectifTag(q.Fields[0].AsString)
    else if (cand2 <> '') and (not SameCand(cand2, cand1)) and TryWithSerie(cand2) then
      Result := VF_NormalizeRectifTag(q.Fields[0].AsString)
    else if (cand3 <> '') and (not SameCand(cand3, cand1)) and (not SameCand(cand3, cand2)) and TryWithSerie(cand3) then
      Result := VF_NormalizeRectifTag(q.Fields[0].AsString);

  finally
    q.Free;
  end;
end;

function LoadRectifTag(Conn: TZConnection; const Serie: string; Numero: Integer;
  const FechaISO, HoraISO: string): string;
begin
  Result := '';
  // 1) Preferimos observaciones de factura (factuc.FC19), si existen.
  Result := LoadRectifTagFromFacturaObs(Conn, Serie, Numero);
  if Result <> '' then Exit;

  // 2) Fallback a histórico de operaciones (hisopcc.HO20_RECT)
  Result := LoadRectifTagFromHisto(Conn, Serie, Numero, FechaISO, HoraISO);
end;

type
  TVFRectifInfo = record
    HasRectif: Boolean;
    OrigIsFS: Boolean;
    OrigSerieRaw: string;   // tal y como viene en el tag (puede venir FS-A26)
    OrigSerieInt: string;   // serie interna 3 chars (A26)
    OrigNumText: string;    // texto del número (para compatibilidad)
    OrigNum: Integer;       // si es numérico, >0
  end;

function VF_ParseRectifTag(const Tag: string; out Info: TVFRectifInfo): Boolean;
var
  S, Body, Part, Key, Val: string;
  i, p, eq: Integer;
  Parts: TStringList;
begin
  FillChar(Info, SizeOf(Info), 0);
  Info.HasRectif := False;
  Info.OrigNum := 0;
  Info.OrigNumText := '';

  S := Trim(Tag);
  if S = '' then Exit(False);

  p := Pos('VF_RECTIF:', S);
  if p <= 0 then Exit(False);

  Body := Copy(S, p + Length('VF_RECTIF:'), 2048);
  Parts := TStringList.Create;
  try
    Parts.StrictDelimiter := True;
    Parts.Delimiter := ';';
    Parts.DelimitedText := Body;

    for i := 0 to Parts.Count - 1 do
    begin
      Part := Trim(Parts[i]);
      if Part = '' then Continue;
      eq := Pos('=', Part);
      if eq <= 0 then Continue;
      Key := UpperCase(Trim(Copy(Part, 1, eq - 1)));
      Val := Trim(Copy(Part, eq + 1, 2048));

      if Key = 'TYPE' then
      begin
        Info.OrigIsFS := (UpperCase(Val) = 'FS');
        Info.HasRectif := True;
      end
      else if Key = 'ORIG_SERIE' then
        Info.OrigSerieRaw := Val
      else if Key = 'ORIG_NUM' then
      begin
        Info.OrigNumText := Val;
        Info.OrigNum := StrToIntDef(Val, 0);
      end;
    end;

    if not Info.HasRectif then
      Exit(False);

    // Derivar serie interna de 3 chars (HO4)
    Info.OrigSerieInt := Trim(Info.OrigSerieRaw);
    if (Length(Info.OrigSerieInt) >= 3) and (AnsiCompareText(Copy(Info.OrigSerieInt, 1, 3), 'FS-') = 0) then
      Info.OrigSerieInt := Copy(Info.OrigSerieInt, 4, 255);
    // Nos quedamos con 3 caracteres máximo
    Info.OrigSerieInt := Trim(Info.OrigSerieInt);
    if Length(Info.OrigSerieInt) > 3 then
      Info.OrigSerieInt := Copy(Info.OrigSerieInt, 1, 3);

    Result := True;
  finally
    Parts.Free;
  end;
end;

function VF_LoadOrigDateTimeFromHisto(Conn: TZConnection; const SerieInt: string; OrigNum: Integer;
  ClienteID: Integer; out OrigFechaISO, OrigHoraISO: string): Boolean;
var
  tname: string;
  q: TZQuery;
  d: TDate;
  t: TTime;
  useCli: Boolean;
begin
  Result := False;
  OrigFechaISO := '';
  OrigHoraISO := '';
  if (Conn = nil) or (not Conn.Connected) then Exit;
  if (SerieInt = '') or (OrigNum <= 0) then Exit;

  if not DetectHistoTableExact(Conn, tname) then Exit;

  useCli := (ClienteID > 0);

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    // HO8 = cliente (int). Si lo tenemos, lo usamos para desambiguar.
    if useCli then
      q.SQL.Text :=
        'SELECT HO0, HO1 FROM ' + QuoteIdent(tname) +
        ' WHERE HO4=:serie AND HO3=:num AND HO8=:cli' +
        ' ORDER BY HO0 DESC, HO1 DESC LIMIT 1'
    else
      q.SQL.Text :=
        'SELECT HO0, HO1 FROM ' + QuoteIdent(tname) +
        ' WHERE HO4=:serie AND HO3=:num' +
        ' ORDER BY HO0 DESC, HO1 DESC LIMIT 1';

    q.ParamByName('serie').AsString := SerieInt;
    q.ParamByName('num').AsInteger := OrigNum;
    if useCli then
      q.ParamByName('cli').AsInteger := ClienteID;

    q.Open;
    if q.IsEmpty then Exit(False);

    d := q.Fields[0].AsDateTime;
    t := q.Fields[1].AsDateTime;

    OrigFechaISO := FormatDateTime('yyyy-mm-dd', d);
    OrigHoraISO  := FormatDateTime('hh:nn:ss', t);
    Result := True;
  finally
    q.Free;
  end;
end;

function VF_BuildRectifExtraJSON(Conn: TZConnection; const RectifTag, CodCliente: string): string;
var
  Info: TVFRectifInfo;
  cliID: Integer;
  ofecha, ohora: string;
  numJSON: string;
begin
  Result := '';
  if not VF_ParseRectifTag(RectifTag, Info) then Exit('');

  // Cliente (HO8) solo aplica si lo tenemos (facturas normales). En FS suele venir vacío.
  cliID := StrToIntDef(Trim(CodCliente), 0);

  // Número original: en producción será numérico. En pruebas puedes estar usando YYYYMMDD.
  if Info.OrigNum > 0 then
    numJSON := IntToStr(Info.OrigNum)
  else
    numJSON := '"' + JsonEscape(Info.OrigNumText) + '"';

  // Intentamos cargar fecha/hora originales desde histórico
  ofecha := '';
  ohora := '';
  if (Info.OrigNum > 0) then
    VF_LoadOrigDateTimeFromHisto(Conn, Info.OrigSerieInt, Info.OrigNum, cliID, ofecha, ohora);

  // Construimos bloque estructurado para que el sender XML no tenga que consultar BD.
  Result := '"rectif":{' +
              '"tipo_rect":"I",' +
              '"orig_is_fs":' + LowerCase(BoolToStr(Info.OrigIsFS, True)) + ',' +
              '"orig_serie":"' + JsonEscape(Info.OrigSerieRaw) + '",' +
              '"orig_serie_int":"' + JsonEscape(Info.OrigSerieInt) + '",' +
              '"orig_num":' + numJSON;

  if ofecha <> '' then
    Result := Result + ',"orig_fecha":"' + ofecha + '"';
  if ohora <> '' then
    Result := Result + ',"orig_hora":"' + ohora + '"';

  Result := Result + '},';
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

function MergeHeaderIntoJSON(const Payload, NIFCliente, CodCliente, NombreCliente, RectifTag: string;
  const TotalSinIVA, TotalConIVA: Double;
  LineasTotales: Integer; CantArticulos: Double;
  const RectifExtra: string = ''): string;
var
  S: string;
  NomCliEsc: string;
  RectPart: string;
begin
  S := Payload;
  
  // Escapamos por si trae comillas, etc.
  NomCliEsc := JsonEscape(NombreCliente);

  RectPart := '';

  if Trim(RectifTag) <> '' then
    RectPart := RectPart + '"rectif_tag":"' + JsonEscape(VF_NormalizeRectifTag(RectifTag)) + '",' ;

  if Trim(RectifExtra) <> '' then
    RectPart := RectPart + RectifExtra;

  S := StringReplace(S, '"cabecera":{',
        '"cabecera":{' +
        '"nifCliente":"' + JsonEscape(NIFCliente) + '",' +
        '"codCliente":"' + JsonEscape(CodCliente) + '",' +
        '"nombreCliente":"' + NomCliEsc + '",' +
        '"totalSinIVA":' + F2(TotalSinIVA) + ',' +
        '"lineasTotales":' + IntToStr(LineasTotales) + ',' +
        '"cantidadTotalArticulos":' + F2(CantArticulos) + ',' + RectPart, []);
  Result := S;
end;

// ----- Conexión temporal -----

function TryOpenTempConn(out Temp: TZConnection): boolean;
var
  Host, Port, DBName, UserName, Password, IniUsed: string;
  protos: array[0..1] of string = ('mariadb','mysql');
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
  RectifTag: string; // <-- rectificativas
  RectifExtra: string; // <-- rectificativas (bloque JSON estructurado)
begin
  skel := BuildJSONSkeleton(Serie, Numero, FechaISO, HoraISO, TotalConIVA);
  lines := '[]';
  ivas  := '[]';
  NIFCliente := ''; CodCliente := ''; TSin := 0; TCon := TotalConIVA; nLineas := 0; nArt := 0;
  NombreCliente := ''; // <-- inicializado
  RectifTag := '';
  RectifExtra := '';

  if Assigned(GConn) and GConn.Connected then
  begin
    try
      LoadHeaderFromCab(GConn, Serie, Numero, NIFCliente, CodCliente, TSin, TCon, nLineas, nArt);
      LoadLinesAndTaxes(GConn, Serie, Numero, lines, ivas);

      // F2/R5 (tickets y rectificativas simplificadas): no viven en factudNNNN.
      // Si no hay desglose por factud, cargamos el IVA real desde ivaNNNN.
      // F1/R1 no se toca: siguen usando factuc/factud como hasta ahora.
      if ((VF_DetectTipoFacturaFromSerie(Serie) = 'F2') or
          (VF_DetectTipoFacturaFromSerie(Serie) = 'R5')) and
         (ivas = '[]') then
        LoadTaxesFromIvaTable(GConn, Serie, Numero, ivas);

      // NUEVO: intentamos cargar el nombre del cliente desde la tabla clientesNNNN
      NombreCliente := LoadClienteNombreFromDB(GConn, CodCliente);
      
      // Rectificativas: tag desde factuc.FC19 o hisopcc.HO20_RECT
      RectifTag := LoadRectifTag(GConn, Serie, Numero, FechaISO, HoraISO);
      RectifExtra := VF_BuildRectifExtraJSON(GConn, RectifTag, CodCliente);
    except
      on E: Exception do WriteDiag('BuildJSON(DB) error: ' + E.Message);
    end;
  end
  else if TryOpenTempConn(temp) then
  begin
    try
      LoadHeaderFromCab(temp, Serie, Numero, NIFCliente, CodCliente, TSin, TCon, nLineas, nArt);
      LoadLinesAndTaxes(temp, Serie, Numero, lines, ivas);

      // F2/R5: cargar desglose real desde ivaNNNN si no hay factud.
      // F1/R1 se dejan exactamente como estaban.
      if ((VF_DetectTipoFacturaFromSerie(Serie) = 'F2') or
          (VF_DetectTipoFacturaFromSerie(Serie) = 'R5')) and
         (ivas = '[]') then
        LoadTaxesFromIvaTable(temp, Serie, Numero, ivas);

      // NUEVO: nombre cliente usando conexión temporal
      NombreCliente := LoadClienteNombreFromDB(temp, CodCliente);
      
      RectifTag := LoadRectifTag(temp, Serie, Numero, FechaISO, HoraISO);
      RectifExtra := VF_BuildRectifExtraJSON(temp, RectifTag, CodCliente);
RectifTag := LoadRectifTag(temp, Serie, Numero, FechaISO, HoraISO);
    finally
      try if temp.Connected then temp.Disconnect; except end;
      temp.Free;
    end;
  end
  else
    WriteDiag('BuildJSON: sin DB disponible → JSON básico.');

  Result := MergeJSON(skel, lines, ivas);
  Result := MergeHeaderIntoJSON(Result, NIFCliente, CodCliente, NombreCliente, RectifTag, TSin, TCon, nLineas, nArt, RectifExtra);
end;


// ----- Queue helpers -----

procedure QueueToDB_Conn(Conn: TZConnection; const Serie: string; Numero: Integer; const FechaISO, HoraISO: string; TotalConIVA: Double; const PayloadJSON: string);
var
  qry: TZQuery;
  TipoFactura: string;
  PayloadFinal: string;
begin
  // Idempotencia: si ya existe, no insertar
  if ExistsInQueue(Conn, Serie, Numero) then
  begin
    WriteDiag('Factura ya existente en verifactu_queue (serie=' + Serie + ' num=' + IntToStr(Numero) + '). Ignorada.');
    Exit;
  end;

  // Determinamos el tipo de factura en el momento de encolar.
  // OJO: FS-Rxx debe ser R5 y Rxx debe ser R1.
  TipoFactura := VF_DetectTipoFacturaFromSerie(Serie);

  // Guardamos también el tipo dentro del JSON para que el sender no tenga que
  // recalcularlo ni pueda volver a convertir una FS-Rxx en F2.
  PayloadFinal := PayloadJSON;
  if Pos('"tipoFactura"', PayloadFinal) = 0 then
    PayloadFinal := StringReplace(PayloadFinal, '"cabecera":{',
      '"cabecera":{"tipoFactura":"' + JsonEscape(TipoFactura) + '",', []);

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
    qry.ParamByName('payload').AsString := PayloadFinal;
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
      QueueToFiles(Serie, Numero, FechaISO, HoraISO, TotalConIVA, PayloadFinal);
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
  Missing: string;
begin
  try
    // Construimos el JSON intentando leer cabecera + líneas de DB (GConn o temp)
    FechaISO := FormatDateTime('yyyy-mm-dd', Fecha);
    HoraISO  := FormatDateTime('hh:nn:ss', Hora);
    Payload := BuildJSON(Serie, Numero, FechaISO, HoraISO, TotalConIVA);

    // 1) Si tenemos conexión DB viva (GConn), escribimos en DB.
    // Si la estructura no está lista o la inserción falla, dejamos copia JSON
    // para no perder el documento ni bloquear ventas/facturación.
    if Assigned(GConn) and GConn.Connected then
    begin
      EnsureTables_DB_Conn(GConn);
      if VF_QueueRuntimeSchemaOK(GConn, Missing) then
      begin
        try
          QueueToDB_Conn(GConn, Serie, Numero, FechaISO, HoraISO, TotalConIVA, Payload);
        except
          on E: Exception do
          begin
            WriteDiag('QueueToDB_Conn fallo; se deja copia JSON: ' + E.Message);
            QueueToFiles(Serie, Numero, FechaISO, HoraISO, TotalConIVA, Payload);
          end;
        end;
      end
      else
      begin
        WriteDiag('Estructura verifactu_queue no valida (' + Missing + '); se deja copia JSON.');
        QueueToFiles(Serie, Numero, FechaISO, HoraISO, TotalConIVA, Payload);
      end;
      Exit;
    end;

    // 2) Si no, intentamos una conexión temporal SOLO para escribir en DB
    if TryOpenTempConn(temp) then
    begin
      try
        EnsureTables_DB_Conn(temp);
        if VF_QueueRuntimeSchemaOK(temp, Missing) then
        begin
          try
            QueueToDB_Conn(temp, Serie, Numero, FechaISO, HoraISO, TotalConIVA, Payload);
            if GDualWriteJSON then
            begin
              QueueToFiles(Serie, Numero, FechaISO, HoraISO, TotalConIVA, Payload);
              WriteDiag('Insertada (temp-DB) + copia JSON (dual-write).');
            end
            else
              WriteDiag('Insertada en DB principal con conexión temporal.');
          except
            on E: Exception do
            begin
              WriteDiag('QueueToDB_Conn temp fallo; se deja copia JSON: ' + E.Message);
              QueueToFiles(Serie, Numero, FechaISO, HoraISO, TotalConIVA, Payload);
            end;
          end;
        end
        else
        begin
          WriteDiag('Estructura verifactu_queue no valida en conexion temporal (' + Missing + '); se deja copia JSON.');
          QueueToFiles(Serie, Numero, FechaISO, HoraISO, TotalConIVA, Payload);
        end;
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
      try
        QueueToFiles(Serie, Numero, FechaISO, HoraISO, TotalConIVA, Payload);
      except
        on E2: Exception do
          WriteDiag('EXCEPTION guardando JSON tras fallo VeriFactu_QueueFactura: ' + E2.Message);
      end;
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
  // En hilos de envío VeriFactu NO reutilizamos la conexión global visual.
  // Cada worker debe abrir su propia conexión temporal para evitar bloqueos o
  // uso simultáneo de TZConnection desde menú/ventas.
  if (not GVFForceTempConnection) and Assigned(GConn) and GConn.Connected then
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

// -------------------- Lock DB para encadenamiento hash/hash_prev --------------------
// NOTA: Necesario si hay concurrencia (threads o varios procesos) para evitar que varios
//       registros usen el mismo hash_prev. Se usa GET_LOCK/RELEASE_LOCK (MySQL/MariaDB).

function VF_MakeChainLockName(const Serie: string): string;
var
  S: string;
  k: Integer;
  ch: Char;
begin
  S := Trim(Serie);
  // Normalizamos: solo [A-Za-z0-9_-] para nombre de lock estable
  for k := 1 to Length(S) do
  begin
    ch := S[k];
    if not (ch in ['A'..'Z','a'..'z','0'..'9','_','-']) then
      S[k] := '_';
  end;
  Result := 'VF_CHAIN_' + S;
  // MySQL limita el nombre del lock a 64 caracteres
  if Length(Result) > 64 then
    SetLength(Result, 64);
end;

function VF_DB_GetLock(Conn: TZConnection; const LockName: string; TimeoutSec: Integer): Boolean;
var
  q: TZQuery;
begin
  Result := False;
  if (Conn = nil) or (not Conn.Connected) then Exit;
  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text := 'SELECT GET_LOCK(:n, :t) AS L';
    q.ParamByName('n').AsString := LockName;
    q.ParamByName('t').AsInteger := TimeoutSec;
    q.Open;
    // GET_LOCK devuelve 1 si obtiene el lock, 0 si timeout, NULL si error
    if (not q.IsEmpty) then
      Result := (q.FieldByName('L').AsInteger = 1);
  finally
    q.Free;
  end;
end;

procedure VF_DB_ReleaseLock(Conn: TZConnection; const LockName: string);
var
  q: TZQuery;
begin
  if (Conn = nil) or (not Conn.Connected) then Exit;
  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text := 'SELECT RELEASE_LOCK(:n)';
    q.ParamByName('n').AsString := LockName;
    q.Open;
  finally
    q.Free;
  end;
end;

function HostTag: string;
begin
  Result := Trim(GetEnvironmentVariable('HOSTNAME'));
  if Result = '' then
    Result := Trim(GetEnvironmentVariable('COMPUTERNAME'));
  if Result = '' then
    Result := 'host';

  // El token usa HostTag, así que lo mantenemos corto y sin separadores raros.
  Result := StringReplace(Result, '|', '-', [rfReplaceAll]);
  Result := StringReplace(Result, ' ', '_', [rfReplaceAll]);
  if Length(Result) > 18 then
    Result := Copy(Result, 1, 18);
end;

function VF_ClaimTag: string;
var
  Host, VPuesto, VEnv: string;
begin
  Host := HostTag;

  VPuesto := Trim(Puesto);
  if VPuesto = '' then
    VPuesto := '?';
  VPuesto := StringReplace(VPuesto, '|', '-', [rfReplaceAll]);
  if Length(VPuesto) > 3 then
    VPuesto := Copy(VPuesto, 1, 3);

  // Mantenerlo compacto porque verifactu_queue.claimed_by es VARCHAR(64).
  // Cambiar aquí la versión visible cuando quieras identificar una revisión nueva.
  VEnv := 'PROD';
  if (Pos('prewww', LowerCase(vfUrlTP)) > 0) or
     (Pos('prewww', LowerCase(vfUrl)) > 0) or
     (Pos('prueba', LowerCase(vfUrlTP)) > 0) then
    VEnv := 'PRE';

  Result := Host + '|P=' + VPuesto + '|V=35|'+ VEnv;
  if Length(Result) > 64 then
    Result := Copy(Result, 1, 64);
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
  LockName: string;
  Locked: Boolean;
  RowId: Integer;
begin
  Result := False;
  Serie := '';
  Numero := 0;
  PayloadJSON := '';
  EncadenamientoHash := '';

  ownTemp := False;
  Locked := False;
  RowId := 0;

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

    // 1) Buscar la siguiente PENDIENTE reclamable, respetando orden por serie SOLO
    //    para incidencias técnicas/transitorias sin respuesta válida.
    //    Regla v5:
    //    - PENDIENTE / EN_PROCESO anteriores bloquean.
    //    - ERROR con respuesta AEAT NO bloquea; queda para subsanación/revisión.
    //    - ENVIADO incluye Correcto y AceptadoConErrores; NO bloquea.
    //    - Fallos técnicos/timeout/SOAP sin respuesta válida quedan en PENDIENTE.
    //    - IMPORTANTE: no filtramos por last_attempt_at/intentos aquí.
    //      El worker ya corre en segundo plano y para el lote ante fallo técnico, así que
    //      el documento que bloquea la serie debe reintentarse en cada ciclo disponible.
    //      Esto evita que una fila PENDIENTE_REINTENTO quede sin seleccionarse por
    //      desfases de hora, last_attempt_at o condiciones SQL demasiado restrictivas.
    q.SQL.Text :=
      'SELECT q.id, q.serie, q.numero ' +
      'FROM verifactu_queue q ' +
      'WHERE q.estado="PENDIENTE" ' +
      '  AND NOT EXISTS ( ' +
      '       SELECT 1 FROM verifactu_queue p ' +
      '       WHERE p.serie=q.serie AND p.id<q.id ' +
      '         AND p.estado IN ("PENDIENTE","EN_PROCESO") ' +
      '  ) ' +
      'ORDER BY q.created_at ASC, q.id ASC ' +
      'LIMIT 1';
    q.Open;

    if q.IsEmpty then
      Exit(False);

    RowId := q.FieldByName('id').AsInteger;
    q.Close;

    // 2) Reclamar la fila exacta por ID. Si otro proceso la cogió antes, no hacemos nada.
    q.SQL.Text :=
      'UPDATE verifactu_queue ' +
      'SET estado="EN_PROCESO", token=:t, claimed_by=:cb, claimed_at=NOW(), ' +
      '    claimed_until=DATE_ADD(NOW(), INTERVAL 10 MINUTE), ' +
      '    intentos=intentos+1, updated_at=NOW(), last_attempt_at=NOW() ' +
      'WHERE id=:id AND estado="PENDIENTE" ' +
      'LIMIT 1';
    q.ParamByName('t').AsString  := token;
    q.ParamByName('cb').AsString := VF_ClaimTag;
    q.ParamByName('id').AsInteger := RowId;
    q.ExecSQL;

    if q.RowsAffected = 0 then
      Exit(False);

    // 3) Obtenemos serie, numero y payload_json de la fila reclamada
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

    // 4) AHORA SÍ: recalculamos hash_prev en este momento
    // -- LOCK DB para asegurar encadenamiento (evita hash_prev repetido con concurrencia)
    LockName := VF_MakeChainLockName(Serie);
    Locked := VF_DB_GetLock(Conn, LockName, 10);
    if not Locked then
    begin
      WriteDiag('TakeNextPending: GET_LOCK timeout ' + LockName);
      Exit(False);
    end;
    try
      VF_AttachHashToQueue(Conn, Serie, Numero, PayloadJSON, 'ALTA');
    finally
      VF_DB_ReleaseLock(Conn, LockName);
    end;

    // 5) Volvemos a leer la fila, ahora con hash y hash_prev actualizados
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
function VeriFactu_TakeSpecificPending(const SerieIn: string; const NumeroIn: Integer;
  out PayloadJSON: string; out EncadenamientoHash: string): Boolean;
var
  ownTemp: Boolean;
  Conn: TZConnection;
  q: TZQuery;
  token: string;
  LockName: string;
  Locked: Boolean;
  RowId: Integer;
begin
  Result := False;
  PayloadJSON := '';
  EncadenamientoHash := '';

  ownTemp := False;
  Locked := False;
  RowId := 0;

  if not GetConnForOps(Conn) then
  begin
    WriteDiag('TakeSpecificPending: no hay conexión DB.');
    Exit(False);
  end;
  if Conn <> GConn then ownTemp := True;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    token := NewToken;

    // 1) Localizar esa factura concreta, pero sin saltarse una anterior pendiente/en proceso
    //    de la misma serie. Los errores con respuesta AEAT no bloquean; quedan para
    //    subsanación/revisión y el resto de la cola puede continuar.
    q.SQL.Text :=
      'SELECT q.id ' +
      'FROM verifactu_queue q ' +
      'WHERE q.estado="PENDIENTE" AND q.serie=:s AND q.numero=:n ' +
      '  AND NOT EXISTS ( ' +
      '       SELECT 1 FROM verifactu_queue p ' +
      '       WHERE p.serie=q.serie AND p.id<q.id ' +
      '         AND p.estado IN ("PENDIENTE","EN_PROCESO") ' +
      '  ) ' +
      'LIMIT 1';
    q.ParamByName('s').AsString := SerieIn;
    q.ParamByName('n').AsInteger := NumeroIn;
    q.Open;

    if q.IsEmpty then
      Exit(False);

    RowId := q.FieldByName('id').AsInteger;
    q.Close;

    // 2) Reclamo seguro de ESA PENDIENTE por ID
    q.SQL.Text :=
      'UPDATE verifactu_queue ' +
      'SET estado="EN_PROCESO", token=:t, claimed_by=:cb, claimed_at=NOW(), ' +
      '    claimed_until=DATE_ADD(NOW(), INTERVAL 10 MINUTE), intentos=intentos+1, ' +
      '    updated_at=NOW(), last_attempt_at=NOW() ' +
      'WHERE id=:id AND estado="PENDIENTE" ' +
      'LIMIT 1';
    q.ParamByName('t').AsString  := token;
    q.ParamByName('cb').AsString := VF_ClaimTag;
    q.ParamByName('id').AsInteger := RowId;
    q.ExecSQL;

    if q.RowsAffected = 0 then
      Exit(False);

    // 3) Obtenemos payload de la fila reclamada
    q.Close;
    q.SQL.Text := 'SELECT payload_json FROM verifactu_queue WHERE token=:t LIMIT 1';
    q.ParamByName('t').AsString := token;
    q.Open;
    if q.IsEmpty then
    begin
      WriteDiag('TakeSpecificPending: no fila por token tras UPDATE.');
      Exit(False);
    end;

    PayloadJSON := q.FieldByName('payload_json').AsString;

    // 4) Recalcular hash_prev/hashes (LOCK DB para encadenamiento)
    LockName := VF_MakeChainLockName(SerieIn);
    Locked := VF_DB_GetLock(Conn, LockName, 10);
    if not Locked then
    begin
      WriteDiag('TakeSpecificPending: GET_LOCK timeout ' + LockName);
      Exit(False);
    end;

    try
      VF_AttachHashToQueue(Conn, SerieIn, NumeroIn, PayloadJSON, 'ALTA');
    finally
      VF_DB_ReleaseLock(Conn, LockName);
    end;

    // 5) Leer ya con hash y hash_prev actualizado
    q.Close;
    q.SQL.Text :=
      'SELECT payload_json, hash, hash_prev ' +
      'FROM verifactu_queue WHERE token=:t LIMIT 1';
    q.ParamByName('t').AsString := token;
    q.Open;
    if q.IsEmpty then
    begin
      WriteDiag('TakeSpecificPending: no fila por token (2ª lectura).');
      Exit(False);
    end;

    PayloadJSON        := q.FieldByName('payload_json').AsString;
    EncadenamientoHash := q.FieldByName('hash').AsString;

    GHash     := q.FieldByName('hash').AsString;
    GHashPrev := q.FieldByName('hash_prev').AsString;

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
        'updated_at=NOW(), ' +
        'token=NULL, claimed_until=NULL ' +
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
      'UPDATE verifactu_queue SET estado="ERROR", last_error=:e, respuesta_text=:r, ' +
      'updated_at=NOW(), token=NULL, claimed_until=NULL ' +
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

procedure VeriFactu_MarkRetryOrError(const Serie: string; const Numero: Integer; const MensajeError: string; const Respuesta: string = '');
var
  ownTemp: Boolean;
  Conn: TZConnection;
  q: TZQuery;
  IntentosActuales: Integer;
  MsgCorto: string;
begin
  ownTemp := False;
  IntentosActuales := VF_MAX_AUTO_ATTEMPTS;

  if not GetConnForOps(Conn) then
  begin
    WriteDiag('MarkRetryOrError: no hay conexión DB.');
    Exit;
  end;
  if Conn <> GConn then ownTemp := True;

  MsgCorto := Copy(MensajeError, 1, 255);

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;

    try
      q.SQL.Text := 'SELECT intentos FROM verifactu_queue WHERE serie=:s AND numero=:n LIMIT 1';
      q.ParamByName('s').AsString := Serie;
      q.ParamByName('n').AsInteger := Numero;
      q.Open;
      if not q.IsEmpty then
        IntentosActuales := q.FieldByName('intentos').AsInteger;
      q.Close;
    except
      on E: Exception do
      begin
        WriteDiag('MarkRetryOrError SELECT error: ' + E.Message);
        IntentosActuales := VF_MAX_AUTO_ATTEMPTS;
      end;
    end;

    // Error técnico/transitorio: SIEMPRE se devuelve a PENDIENTE para reintento automático.
    // No se pasa a ERROR/ERROR_TECNICO para no depender de una persona ni bloquear
    // ilegalmente envíos posteriores cuando el sistema vuelva a estar operativo.
    // El orden de serie queda protegido porque esta fila PENDIENTE sigue bloqueando
    // a las posteriores hasta que consiga respuesta válida o se convierta en ERROR
    // con respuesta AEAT desde el sender.
    q.SQL.Text :=
      'UPDATE verifactu_queue SET estado="PENDIENTE", last_error=:e, respuesta_text=:r, ' +
      'updated_at=NOW(), token=NULL, claimed_until=NULL ' +
      'WHERE serie=:s AND numero=:n LIMIT 1';
    q.ParamByName('e').AsString := MsgCorto;
    q.ParamByName('r').AsString := Respuesta;
    q.ParamByName('s').AsString := Serie;
    q.ParamByName('n').AsInteger := Numero;
    q.ExecSQL;

    if IntentosActuales >= VF_MAX_AUTO_ATTEMPTS then
      WriteDiag(Format('MarkRetryOrError: %s-%d → PENDIENTE reintento tecnico automatico continuado (%d intentos).',
        [Serie, Numero, IntentosActuales]))
    else
      WriteDiag(Format('MarkRetryOrError: %s-%d → PENDIENTE para reintento automatico (%d/%d).',
        [Serie, Numero, IntentosActuales, VF_MAX_AUTO_ATTEMPTS]));

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
      'UPDATE verifactu_queue SET estado="PENDIENTE", intentos=0, last_error=NULL, respuesta_text=NULL, ' +
      'updated_at=NOW(), last_attempt_at=NULL, token=NULL, claimed_until=NULL ' +
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
      'SET estado="PENDIENTE", token=NULL, claimed_until=NULL, updated_at=NOW() ' +
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