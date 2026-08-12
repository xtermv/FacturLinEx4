unit uAuditoriaEANFacturLinEx;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBGrids, Grids, DB, ZDataset, ComCtrls, Spin, LCLType;

type
  TAuditoriaEANFacturLinExForm = class(TForm)
    ActionPanel: TPanel;
    BtnAbrirImagen: TBitBtn;
    BtnActualizar: TBitBtn;
    BtnAuditoriaLocal: TBitBtn;
    BtnCerrar: TBitBtn;
    BtnCopiarEAN: TBitBtn;
    BtnDetener: TBitBtn;
    BtnExportarCSV: TBitBtn;
    BtnGS1: TBitBtn;
    BtnInternet: TBitBtn;
    BtnMarcarRevisado: TBitBtn;
    BtnRegistrarGS1: TBitBtn;
    DataSource1: TDataSource;
    DetailPanel: TPanel;
    EdBuscar: TEdit;
    FilterPanel: TPanel;
    Grid: TDBGrid;
    HeaderPanel: TPanel;
    KpiPanel: TPanel;
    LblBuscar: TLabel;
    LblKpiCorrectos: TLabel;
    LblKpiIncidencias: TLabel;
    LblKpiPendientes: TLabel;
    LblKpiTotal: TLabel;
    LblLimite: TLabel;
    LblPausa: TLabel;
    LblProgreso: TLabel;
    LblSubtitulo: TLabel;
    LblTitulo: TLabel;
    LblVista: TLabel;
    MemoDetalle: TMemo;
    PnlKpiCorrectos: TPanel;
    PnlKpiIncidencias: TPanel;
    PnlKpiPendientes: TPanel;
    PnlKpiTotal: TPanel;
    ProgressBar1: TProgressBar;
    ProgressPanel: TPanel;
    qAux: TZQuery;
    qLista: TZQuery;
    qTrabajo: TZQuery;
    SaveDialog1: TSaveDialog;
    SeLimite: TSpinEdit;
    SePausa: TSpinEdit;
    StatusBar1: TStatusBar;
    CbVista: TComboBox;
    procedure BtnAbrirImagenClick(Sender: TObject);
    procedure BtnActualizarClick(Sender: TObject);
    procedure BtnAuditoriaLocalClick(Sender: TObject);
    procedure BtnCerrarClick(Sender: TObject);
    procedure BtnCopiarEANClick(Sender: TObject);
    procedure BtnDetenerClick(Sender: TObject);
    procedure BtnExportarCSVClick(Sender: TObject);
    procedure BtnGS1Click(Sender: TObject);
    procedure BtnInternetClick(Sender: TObject);
    procedure BtnMarcarRevisadoClick(Sender: TObject);
    procedure BtnRegistrarGS1Click(Sender: TObject);
    procedure CbVistaChange(Sender: TObject);
    procedure EdBuscarChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GridTitleClick(Column: TColumn);
    procedure qListaAfterScroll(DataSet: TDataSet);
  private
    FProcesando: Boolean;
    FCancelar: Boolean;
    FOrdenCampo: string;
    FOrdenDesc: Boolean;
    FTablaArticulos: string;
    procedure AplicarEstadoControles;
    procedure AsegurarTablaAuditoria;
    procedure ObtenerParametrosTablaAuditoria(out AMotor, ACharset, ACollation: string);
    procedure AlinearTablaAuditoria(const AMotor, ACharset, ACollation: string);
    procedure ActualizarDetalle;
    procedure ActualizarKPIs;
    procedure CargarLista;
    procedure ConfigurarColumnas;
    procedure EjecutarAuditoriaLocal;
    procedure EjecutarAuditoriaInternet;
    procedure ExportarCSV;
    procedure RegistrarResultadoGS1;
    function ConexionDisponible: Boolean;
    function EANSeleccionado: string;
    function IdSeleccionado: Int64;
    function TableExists(const ATable: string): Boolean;
  public
  end;

procedure MostrarAuditoriaEANFacturLinEx;

implementation

uses
  Global, uFLXTemaVisual, fphttpclient, opensslsockets, fpjson, jsonparser,
  LazUTF8, LCLIntf, Clipbrd, DateUtils, Math;

{$R *.lfm}

type
  TOpenFactsResult = record
    Encontrado: Boolean;
    ErrorTemporal: Boolean;
    EstadoHTTP: Integer;
    Nombre: string;
    Marca: string;
    Cantidad: string;
    Categoria: string;
    TipoProducto: string;
    Fuente: string;
    ImagenURL: string;
    RespuestaJSON: string;
    ErrorTexto: string;
  end;

const
  TABLA_AUDITORIA = 'flx_auditoria_ean';
  OPENFACTS_URL = 'https://world.openfoodfacts.org/api/v3/product/';
  OPENFACTS_USER_AGENT = 'FacturLinEx/4.2.6 (EAN audit; local desktop installation)';
  GS1_URL = 'https://www.gs1.org/services/verified-by-gs1';

function SQLIdentSeguro(const S: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
    if S[I] in ['A'..'Z', 'a'..'z', '0'..'9', '_'] then
      Result := Result + S[I];
  if Result = '' then
    raise Exception.Create('Nombre SQL no válido.');
  Result := '`' + Result + '`';
end;

function SQLTokenSeguro(const S, ADefecto: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
    if S[I] in ['A'..'Z', 'a'..'z', '0'..'9', '_'] then
      Result := Result + S[I];
  if Result = '' then Result := ADefecto;
end;

function NormalizarMotorTabla(const S: string): string;
var
  U: string;
begin
  U := UpperCase(Trim(S));
  if Pos('ARIA', U) > 0 then
    Result := 'Aria'
  else if Pos('INNODB', U) > 0 then
    Result := 'InnoDB'
  else if (Pos('MYISAM', U) > 0) or (Pos('MYSQL', U) > 0) then
    Result := 'MyISAM'
  else
    Result := 'MyISAM';
end;

function SoloDigitos(const S: string): Boolean;
var
  I: Integer;
begin
  Result := S <> '';
  for I := 1 to Length(S) do
    if not (S[I] in ['0'..'9']) then
      Exit(False);
end;

function EsGTINValido(const ACode: string): Boolean;
var
  I, Suma, Peso, DigitoCalculado: Integer;
  C: string;
begin
  C := Trim(ACode);
  Result := False;
  if not (Length(C) in [8, 12, 13, 14]) then Exit;
  if not SoloDigitos(C) then Exit;

  Suma := 0;
  Peso := 3;
  for I := Length(C) - 1 downto 1 do
  begin
    Inc(Suma, (Ord(C[I]) - Ord('0')) * Peso);
    if Peso = 3 then Peso := 1 else Peso := 3;
  end;
  DigitoCalculado := (10 - (Suma mod 10)) mod 10;
  Result := DigitoCalculado = (Ord(C[Length(C)]) - Ord('0'));
end;

function EsEANInternoOVariable(const ACode: string): Boolean;
var
  Prefijo: Integer;
begin
  Result := False;
  if (Length(ACode) <> 13) or not SoloDigitos(ACode) then Exit;
  Prefijo := StrToIntDef(Copy(ACode, 1, 2), -1);
  Result := (Prefijo >= 20) and (Prefijo <= 29);
end;

function HuellaTexto(const S: string): string;
var
  H: QWord;
  I: Integer;
begin
  H := QWord($CBF29CE484222325);
  for I := 1 to Length(S) do
  begin
    H := H xor Ord(S[I]);
    H := H * QWord($100000001B3);
  end;
  Result := IntToHex(H, 16);
end;

function NormalizarTexto(const ATexto: string): string;
var
  S: string;
  I: Integer;
begin
  S := UTF8UpperCase(Trim(ATexto));
  S := StringReplace(S, 'Á', 'A', [rfReplaceAll]);
  S := StringReplace(S, 'À', 'A', [rfReplaceAll]);
  S := StringReplace(S, 'Ä', 'A', [rfReplaceAll]);
  S := StringReplace(S, 'É', 'E', [rfReplaceAll]);
  S := StringReplace(S, 'È', 'E', [rfReplaceAll]);
  S := StringReplace(S, 'Ë', 'E', [rfReplaceAll]);
  S := StringReplace(S, 'Í', 'I', [rfReplaceAll]);
  S := StringReplace(S, 'Ì', 'I', [rfReplaceAll]);
  S := StringReplace(S, 'Ï', 'I', [rfReplaceAll]);
  S := StringReplace(S, 'Ó', 'O', [rfReplaceAll]);
  S := StringReplace(S, 'Ò', 'O', [rfReplaceAll]);
  S := StringReplace(S, 'Ö', 'O', [rfReplaceAll]);
  S := StringReplace(S, 'Ú', 'U', [rfReplaceAll]);
  S := StringReplace(S, 'Ù', 'U', [rfReplaceAll]);
  S := StringReplace(S, 'Ü', 'U', [rfReplaceAll]);
  S := StringReplace(S, 'Ñ', 'N', [rfReplaceAll]);
  S := StringReplace(S, 'Ç', 'C', [rfReplaceAll]);

  for I := 1 to Length(S) do
    if not (S[I] in ['A'..'Z', '0'..'9']) then
      S[I] := ' ';

  while Pos('  ', S) > 0 do
    S := StringReplace(S, '  ', ' ', [rfReplaceAll]);
  Result := Trim(S);
end;

function EsPalabraVacia(const S: string): Boolean;
const
  StopWords: array[0..20] of string =
    ('DE','DEL','LA','LAS','EL','LOS','Y','CON','PARA','POR','EN','UN','UNA',
     'THE','AND','OF','A','AL','PACK','UD','UDS');
var
  I: Integer;
begin
  Result := Length(S) <= 1;
  if Result then Exit;
  for I := Low(StopWords) to High(StopWords) do
    if S = StopWords[I] then Exit(True);
  Result := False;
end;

procedure CrearTokens(const S: string; ALista: TStringList);
var
  Partes: TStringList;
  I: Integer;
begin
  ALista.Clear;
  ALista.Sorted := True;
  ALista.Duplicates := dupIgnore;
  Partes := TStringList.Create;
  try
    Partes.Delimiter := ' ';
    Partes.StrictDelimiter := True;
    Partes.DelimitedText := NormalizarTexto(S);
    for I := 0 to Partes.Count - 1 do
      if not EsPalabraVacia(Partes[I]) then
        ALista.Add(Partes[I]);
  finally
    Partes.Free;
  end;
end;

function CalcularCoincidencia(const ALocal, AExterno: string): Integer;
var
  L1, L2: TStringList;
  I, Comunes, Maximo: Integer;
  N1, N2: string;
begin
  Result := 0;
  N1 := NormalizarTexto(ALocal);
  N2 := NormalizarTexto(AExterno);
  if (N1 = '') or (N2 = '') then Exit;

  if (Length(N1) >= 6) and (Length(N2) >= 6) and
     ((Pos(N1, N2) > 0) or (Pos(N2, N1) > 0)) then
    Result := 90;

  L1 := TStringList.Create;
  L2 := TStringList.Create;
  try
    CrearTokens(N1, L1);
    CrearTokens(N2, L2);
    Comunes := 0;
    for I := 0 to L1.Count - 1 do
      if L2.IndexOf(L1[I]) >= 0 then Inc(Comunes);
    Maximo := L1.Count;
    if L2.Count > Maximo then Maximo := L2.Count;
    if Maximo > 0 then
      Result := Max(Result, Round((Comunes * 100.0) / Maximo));
  finally
    L1.Free;
    L2.Free;
  end;
end;

function JSONString(AObj: TJSONObject; const AName: string): string;
var
  D: TJSONData;
begin
  Result := '';
  if not Assigned(AObj) then Exit;
  D := AObj.Find(AName);
  if Assigned(D) and (D.JSONType <> jtNull) then
    Result := D.AsString;
end;

function FuenteDesdeTipo(const ATipo: string): string;
var
  T: string;
begin
  T := LowerCase(Trim(ATipo));
  if T = 'food' then
    Result := 'Open Food Facts'
  else if T = 'beauty' then
    Result := 'Open Beauty Facts'
  else if T = 'petfood' then
    Result := 'Open Pet Food Facts'
  else if T = 'product' then
    Result := 'Open Products Facts'
  else
    Result := 'Open Facts';
end;

function ConsultarOpenFacts(const AEAN: string; out R: TOpenFactsResult): Boolean;
var
  Cliente: TFPHTTPClient;
  URL, Respuesta: string;
  Datos, ProductoData: TJSONData;
  Producto: TJSONObject;
begin
  R.Encontrado := False;
  R.ErrorTemporal := False;
  R.EstadoHTTP := 0;
  R.Nombre := '';
  R.Marca := '';
  R.Cantidad := '';
  R.Categoria := '';
  R.TipoProducto := '';
  R.Fuente := '';
  R.ImagenURL := '';
  R.RespuestaJSON := '';
  R.ErrorTexto := '';
  Result := False;
  Cliente := TFPHTTPClient.Create(nil);
  Datos := nil;
  try
    Cliente.AllowRedirect := True;
    Cliente.AddHeader('User-Agent', OPENFACTS_USER_AGENT);
    Cliente.AddHeader('Accept', 'application/json');
    Cliente.AddHeader('Accept-Language', 'es,ca;q=0.8,en;q=0.6');

    URL := OPENFACTS_URL + AEAN +
      '?fields=code,product_name,product_name_es,abbreviated_product_name,' +
      'generic_name,brands,quantity,product_quantity,product_quantity_unit,' +
      'categories,product_type,image_front_url,image_url&product_type=all';
    try
      Respuesta := Cliente.Get(URL);
      R.EstadoHTTP := Cliente.ResponseStatusCode;
    except
      on E: Exception do
      begin
        R.EstadoHTTP := Cliente.ResponseStatusCode;
        if R.EstadoHTTP = 404 then
        begin
          R.ErrorTexto := '';
          Exit(True);
        end;
        R.ErrorTexto := E.Message;
        R.ErrorTemporal := (R.EstadoHTTP = 429) or (R.EstadoHTTP = 503) or
          (R.EstadoHTTP = 0);
        Exit(False);
      end;
    end;

    R.RespuestaJSON := Respuesta;
    if (R.EstadoHTTP = 404) or (Trim(Respuesta) = '') then
    begin
      Result := True;
      Exit;
    end;
    if (R.EstadoHTTP < 200) or (R.EstadoHTTP >= 300) then
    begin
      R.ErrorTexto := 'Respuesta HTTP ' + IntToStr(R.EstadoHTTP);
      R.ErrorTemporal := (R.EstadoHTTP = 429) or (R.EstadoHTTP = 503);
      Exit(False);
    end;

    try
      Datos := GetJSON(Respuesta);
    except
      on E: Exception do
      begin
        R.ErrorTexto := 'JSON no válido: ' + E.Message;
        Exit(False);
      end;
    end;

    ProductoData := Datos.FindPath('product');
    if not (ProductoData is TJSONObject) then
    begin
      Result := True;
      Exit;
    end;

    Producto := TJSONObject(ProductoData);
    R.Nombre := JSONString(Producto, 'product_name_es');
    if R.Nombre = '' then R.Nombre := JSONString(Producto, 'product_name');
    if R.Nombre = '' then R.Nombre := JSONString(Producto, 'abbreviated_product_name');
    if R.Nombre = '' then R.Nombre := JSONString(Producto, 'generic_name');
    R.Marca := JSONString(Producto, 'brands');
    R.Cantidad := JSONString(Producto, 'quantity');
    if R.Cantidad = '' then
    begin
      R.Cantidad := JSONString(Producto, 'product_quantity');
      if R.Cantidad <> '' then
        R.Cantidad := R.Cantidad + ' ' + JSONString(Producto, 'product_quantity_unit');
    end;
    R.Categoria := JSONString(Producto, 'categories');
    R.TipoProducto := JSONString(Producto, 'product_type');
    R.Fuente := FuenteDesdeTipo(R.TipoProducto);
    R.ImagenURL := JSONString(Producto, 'image_front_url');
    if R.ImagenURL = '' then R.ImagenURL := JSONString(Producto, 'image_url');
    R.Encontrado := (R.Nombre <> '') or (R.Marca <> '') or
      (R.Cantidad <> '') or (R.Categoria <> '');
    Result := True;
  finally
    Datos.Free;
    Cliente.Free;
  end;
end;

procedure MostrarAuditoriaEANFacturLinEx;
var
  F: TAuditoriaEANFacturLinExForm;
begin
  F := TAuditoriaEANFacturLinExForm.Create(Application);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

{ TAuditoriaEANFacturLinExForm }

function TAuditoriaEANFacturLinExForm.ConexionDisponible: Boolean;
begin
  Result := Assigned(DataModule1) and Assigned(DataModule1.dbConexion) and
    DataModule1.dbConexion.Connected;
end;

function TAuditoriaEANFacturLinExForm.TableExists(const ATable: string): Boolean;
begin
  Result := False;
  if not ConexionDisponible then Exit;
  qAux.Close;
  qAux.SQL.Text :=
    'SELECT COUNT(*) AS N FROM information_schema.tables ' +
    'WHERE table_schema=DATABASE() AND table_name=:TABLA';
  qAux.ParamByName('TABLA').AsString := ATable;
  qAux.Open;
  Result := qAux.FieldByName('N').AsInteger > 0;
  qAux.Close;
end;

procedure TAuditoriaEANFacturLinExForm.ObtenerParametrosTablaAuditoria(
  out AMotor, ACharset, ACollation: string);
var
  TablaReferencia: string;
  MotorConfig: string;
begin
  { Preferimos los parámetros reales de la tabla principal de artículos. Así la
    tabla auxiliar queda exactamente con el mismo motor, charset y collation que
    la instalación activa. MotorDB se usa únicamente como respaldo. }
  MotorConfig := '';
  try
    MotorConfig := MotorDB;
  except
    MotorConfig := '';
  end;

  AMotor := NormalizarMotorTabla(MotorConfig);
  ACharset := 'utf8mb4';
  ACollation := 'utf8mb4_spanish_ci';

  TablaReferencia := FTablaArticulos;
  if (TablaReferencia = '') or not TableExists(TablaReferencia) then
  begin
    if TableExists('artitien0000') then
      TablaReferencia := 'artitien0000'
    else if TableExists('eans') then
      TablaReferencia := 'eans'
    else
      TablaReferencia := '';
  end;

  if TablaReferencia <> '' then
  begin
    qAux.Close;
    qAux.SQL.Text :=
      'SELECT COALESCE(t.ENGINE,'''') AS MOTOR, ' +
      'COALESCE(c.CHARACTER_SET_NAME,'''') AS CHARSET_TABLA, ' +
      'COALESCE(t.TABLE_COLLATION,'''') AS COLLATION_TABLA ' +
      'FROM information_schema.TABLES t ' +
      'LEFT JOIN information_schema.COLLATIONS c ' +
      'ON c.COLLATION_NAME=t.TABLE_COLLATION ' +
      'WHERE t.TABLE_SCHEMA=DATABASE() AND t.TABLE_NAME=:TABLA LIMIT 1';
    qAux.ParamByName('TABLA').AsString := TablaReferencia;
    qAux.Open;
    if not qAux.IsEmpty then
    begin
      if Trim(qAux.FieldByName('MOTOR').AsString) <> '' then
        AMotor := NormalizarMotorTabla(qAux.FieldByName('MOTOR').AsString);
      if Trim(qAux.FieldByName('CHARSET_TABLA').AsString) <> '' then
        ACharset := SQLTokenSeguro(qAux.FieldByName('CHARSET_TABLA').AsString,
          ACharset);
      if Trim(qAux.FieldByName('COLLATION_TABLA').AsString) <> '' then
        ACollation := SQLTokenSeguro(qAux.FieldByName('COLLATION_TABLA').AsString,
          ACollation);
    end;
    qAux.Close;
  end;

  AMotor := NormalizarMotorTabla(AMotor);
  ACharset := SQLTokenSeguro(ACharset, 'utf8mb4');
  ACollation := SQLTokenSeguro(ACollation, ACharset + '_spanish_ci');
end;

procedure TAuditoriaEANFacturLinExForm.AlinearTablaAuditoria(
  const AMotor, ACharset, ACollation: string);
var
  MotorActual, CharsetActual, CollationActual: string;
begin
  if not TableExists(TABLA_AUDITORIA) then Exit;

  qAux.Close;
  qAux.SQL.Text :=
    'SELECT COALESCE(t.ENGINE,'''') AS MOTOR, ' +
    'COALESCE(c.CHARACTER_SET_NAME,'''') AS CHARSET_TABLA, ' +
    'COALESCE(t.TABLE_COLLATION,'''') AS COLLATION_TABLA ' +
    'FROM information_schema.TABLES t ' +
    'LEFT JOIN information_schema.COLLATIONS c ' +
    'ON c.COLLATION_NAME=t.TABLE_COLLATION ' +
    'WHERE t.TABLE_SCHEMA=DATABASE() AND t.TABLE_NAME=:TABLA LIMIT 1';
  qAux.ParamByName('TABLA').AsString := TABLA_AUDITORIA;
  qAux.Open;
  if qAux.IsEmpty then
  begin
    qAux.Close;
    Exit;
  end;
  MotorActual := qAux.FieldByName('MOTOR').AsString;
  CharsetActual := qAux.FieldByName('CHARSET_TABLA').AsString;
  CollationActual := qAux.FieldByName('COLLATION_TABLA').AsString;
  qAux.Close;

  { Si una versión anterior creó la tabla con MyISAM o con otra collation,
    alineamos solamente esta tabla auxiliar. No se toca eans ni artitien. }
  if not SameText(Trim(MotorActual), Trim(AMotor)) then
  begin
    qAux.SQL.Text := 'ALTER TABLE `' + TABLA_AUDITORIA + '` ENGINE=' +
      SQLTokenSeguro(AMotor, 'MyISAM');
    qAux.ExecSQL;
  end;

  if (not SameText(Trim(CharsetActual), Trim(ACharset))) or
     (not SameText(Trim(CollationActual), Trim(ACollation))) then
  begin
    qAux.SQL.Text := 'ALTER TABLE `' + TABLA_AUDITORIA +
      '` CONVERT TO CHARACTER SET ' + SQLTokenSeguro(ACharset, 'utf8mb4') +
      ' COLLATE ' + SQLTokenSeguro(ACollation, 'utf8mb4_spanish_ci');
    qAux.ExecSQL;
  end;
end;

procedure TAuditoriaEANFacturLinExForm.AsegurarTablaAuditoria;
var
  MotorTabla, CharsetTabla, CollationTabla: string;
begin
  if not ConexionDisponible then
    raise Exception.Create('No existe una conexión activa con la base de datos.');

  ObtenerParametrosTablaAuditoria(MotorTabla, CharsetTabla, CollationTabla);

  qAux.Close;
  qAux.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS `' + TABLA_AUDITORIA + '` (' +
    '  `id` bigint unsigned NOT NULL AUTO_INCREMENT,' +
    '  `ean` varchar(32) NOT NULL,' +
    '  `codigo_articulo` varchar(32) NOT NULL,' +
    '  `descripcion_ean` varchar(255) NOT NULL DEFAULT '''',' +
    '  `descripcion_local` varchar(255) NOT NULL DEFAULT '''',' +
    '  `unidades` decimal(12,4) NOT NULL DEFAULT 0,' +
    '  `asignaciones` int NOT NULL DEFAULT 1,' +
    '  `duplicados_fila` int NOT NULL DEFAULT 1,' +
    '  `estado_local` varchar(40) NOT NULL DEFAULT ''PENDIENTE'',' +
    '  `motivo_local` varchar(500) NOT NULL DEFAULT '''',' +
    '  `huella_local` varchar(32) NOT NULL DEFAULT '''',' +
    '  `estado_internet` varchar(40) NOT NULL DEFAULT ''PENDIENTE'',' +
    '  `descripcion_externa` varchar(255) NOT NULL DEFAULT '''',' +
    '  `marca_externa` varchar(255) NOT NULL DEFAULT '''',' +
    '  `cantidad_externa` varchar(120) NOT NULL DEFAULT '''',' +
    '  `categoria_externa` varchar(500) NOT NULL DEFAULT '''',' +
    '  `tipo_producto` varchar(40) NOT NULL DEFAULT '''',' +
    '  `fuente` varchar(80) NOT NULL DEFAULT '''',' +
    '  `imagen_url` varchar(1000) NOT NULL DEFAULT '''',' +
    '  `coincidencia` int NOT NULL DEFAULT 0,' +
    '  `estado_final` varchar(40) NOT NULL DEFAULT ''PENDIENTE'',' +
    '  `respuesta_json` mediumtext,' +
    '  `error_internet` varchar(1000) NOT NULL DEFAULT '''',' +
    '  `fecha_internet` datetime DEFAULT NULL,' +
    '  `gs1_estado` varchar(50) NOT NULL DEFAULT '''',' +
    '  `gs1_observaciones` text,' +
    '  `fecha_gs1` datetime DEFAULT NULL,' +
    '  `revisado_manual` char(1) NOT NULL DEFAULT ''N'',' +
    '  `activo` char(1) NOT NULL DEFAULT ''S'',' +
    '  `fecha_local` datetime DEFAULT NULL,' +
    '  PRIMARY KEY (`id`),' +
    '  UNIQUE KEY `uq_flx_auditoria_ean_codigo` (`ean`,`codigo_articulo`),' +
    '  KEY `idx_flx_auditoria_estado` (`estado_final`),' +
    '  KEY `idx_flx_auditoria_pendiente` (`estado_internet`,`estado_local`),' +
    '  KEY `idx_flx_auditoria_codigo` (`codigo_articulo`)' +
    ') ENGINE=' + SQLTokenSeguro(MotorTabla, 'MyISAM') +
    ' DEFAULT CHARSET=' + SQLTokenSeguro(CharsetTabla, 'utf8mb4') +
    ' COLLATE=' + SQLTokenSeguro(CollationTabla, 'utf8mb4_spanish_ci');
  qAux.ExecSQL;

  AlinearTablaAuditoria(MotorTabla, CharsetTabla, CollationTabla);
  StatusBar1.SimpleText := 'Tabla auxiliar preparada: ' + MotorTabla + ' · ' +
    CharsetTabla + ' · ' + CollationTabla;
end;

procedure TAuditoriaEANFacturLinExForm.FormCreate(Sender: TObject);
var
  Sufijo: string;
begin
  FProcesando := False;
  FCancelar := False;
  FOrdenCampo := 'estado_final';
  FOrdenDesc := False;

  if Assigned(DataModule1) and Assigned(DataModule1.dbConexion) then
  begin
    qLista.Connection := DataModule1.dbConexion;
    qTrabajo.Connection := DataModule1.dbConexion;
    qAux.Connection := DataModule1.dbConexion;
  end;

  Sufijo := '';
  try
    Sufijo := Tienda;
  except
    Sufijo := '0000';
  end;
  FTablaArticulos := 'artitien' + StringReplace(Sufijo, '`', '', [rfReplaceAll]);

  CbVista.Items.Clear;
  CbVista.Items.Add('Todos');
  CbVista.Items.Add('Incidencias');
  CbVista.Items.Add('Pendientes de Internet');
  CbVista.Items.Add('Correctos');
  CbVista.Items.Add('Sin datos externos');
  CbVista.Items.Add('Revisados con GS1');
  CbVista.Items.Add('EAN internos / variables');
  CbVista.ItemIndex := 0;

  SeLimite.MinValue := 1;
  SeLimite.MaxValue := 1000;
  SeLimite.Value := 50;
  SePausa.MinValue := 4;
  SePausa.MaxValue := 30;
  SePausa.Value := 5;

  Grid.OnTitleClick := @GridTitleClick;
  qLista.AfterScroll := @qListaAfterScroll;
  AplicarEstadoControles;

  if ConexionDisponible then
  begin
    try
      AsegurarTablaAuditoria;
      CargarLista;
    except
      on E: Exception do
      begin
        StatusBar1.SimpleText := 'No se pudo iniciar la auditoría: ' + E.Message;
        MessageDlg('Auditoría de EAN',
          'No se pudo preparar el módulo:' + LineEnding + E.Message,
          mtError, [mbOK], 0);
      end;
    end;
  end
  else
    StatusBar1.SimpleText := 'Base de datos no conectada.';
end;

procedure TAuditoriaEANFacturLinExForm.FormShow(Sender: TObject);
begin
  WindowState := wsMaximized;
  FLXAplicarTemaVisual(Self);
  if EdBuscar.CanFocus then EdBuscar.SetFocus;
end;

procedure TAuditoriaEANFacturLinExForm.AplicarEstadoControles;
begin
  BtnAuditoriaLocal.Enabled := not FProcesando;
  BtnInternet.Enabled := not FProcesando;
  BtnActualizar.Enabled := not FProcesando;
  BtnGS1.Enabled := not FProcesando;
  BtnRegistrarGS1.Enabled := not FProcesando;
  BtnAbrirImagen.Enabled := not FProcesando;
  BtnCopiarEAN.Enabled := not FProcesando;
  BtnMarcarRevisado.Enabled := not FProcesando;
  BtnExportarCSV.Enabled := not FProcesando;
  BtnDetener.Enabled := FProcesando;
  EdBuscar.Enabled := not FProcesando;
  CbVista.Enabled := not FProcesando;
  SeLimite.Enabled := not FProcesando;
  SePausa.Enabled := not FProcesando;
end;

procedure TAuditoriaEANFacturLinExForm.CargarLista;
var
  WhereSQL, BuscaSQL, OrdenSQL: string;
begin
  if not ConexionDisponible or not TableExists(TABLA_AUDITORIA) then Exit;

  WhereSQL := ' WHERE activo=''S'' ';
  case CbVista.ItemIndex of
    1: WhereSQL := WhereSQL +
      'AND estado_final IN (''FORMATO_INVALIDO'',''DIGITO_CONTROL'',' +
      '''DUPLICADO'',''DUPLICADO_FILA'',''ARTICULO_INEXISTENTE'',' +
      '''SIN_DESCRIPCION'',''POSIBLE_ERROR'',''POSIBLE_ERROR_GS1'') ';
    2: WhereSQL := WhereSQL +
      'AND estado_local=''VALIDO'' AND estado_internet IN (''PENDIENTE'',''ERROR_TEMPORAL'') ';
    3: WhereSQL := WhereSQL +
      'AND estado_final IN (''CORRECTO'',''CORRECTO_GS1'',''REVISADO'') ';
    4: WhereSQL := WhereSQL + 'AND estado_internet=''SIN_DATOS'' ';
    5: WhereSQL := WhereSQL + 'AND COALESCE(gs1_estado,'''')<>'''' ';
    6: WhereSQL := WhereSQL + 'AND estado_local=''INTERNO'' ';
  end;

  BuscaSQL := Trim(EdBuscar.Text);
  if BuscaSQL <> '' then
    WhereSQL := WhereSQL +
      'AND (ean LIKE :BUSCA OR codigo_articulo LIKE :BUSCA OR ' +
      'descripcion_local LIKE :BUSCA OR descripcion_ean LIKE :BUSCA OR ' +
      'descripcion_externa LIKE :BUSCA OR marca_externa LIKE :BUSCA) ';

  if FOrdenCampo = '' then FOrdenCampo := 'estado_final';
  OrdenSQL := ' ORDER BY ' + SQLIdentSeguro(FOrdenCampo);
  if FOrdenDesc then OrdenSQL := OrdenSQL + ' DESC' else OrdenSQL := OrdenSQL + ' ASC';
  OrdenSQL := OrdenSQL + ', descripcion_local, ean';

  qLista.Close;
  qLista.SQL.Text :=
    'SELECT id, estado_final, ean, codigo_articulo, descripcion_local, ' +
    'descripcion_ean, descripcion_externa, marca_externa, cantidad_externa, ' +
    'coincidencia, fuente, estado_local, motivo_local, estado_internet, ' +
    'fecha_internet, imagen_url, gs1_estado, gs1_observaciones, fecha_gs1, ' +
    'revisado_manual, asignaciones, duplicados_fila, categoria_externa, ' +
    'tipo_producto, error_internet FROM `' + TABLA_AUDITORIA + '` ' +
    WhereSQL + OrdenSQL;
  if BuscaSQL <> '' then
    qLista.ParamByName('BUSCA').AsString := '%' + BuscaSQL + '%';
  qLista.Open;
  ConfigurarColumnas;
  ActualizarKPIs;
  ActualizarDetalle;
  StatusBar1.SimpleText := Format('Registros mostrados: %d', [qLista.RecordCount]);
end;

procedure TAuditoriaEANFacturLinExForm.ConfigurarColumnas;
  procedure AddCol(const Campo, Titulo: string; Ancho: Integer;
    Alineacion: TAlignment = taLeftJustify);
  var
    C: TColumn;
  begin
    C := Grid.Columns.Add;
    C.FieldName := Campo;
    C.Title.Caption := Titulo;
    C.Width := Ancho;
    C.Alignment := Alineacion;
  end;
begin
  Grid.Columns.Clear;
  AddCol('estado_final', 'Estado', 145);
  AddCol('ean', 'EAN / GTIN', 125);
  AddCol('codigo_articulo', 'Código', 105);
  AddCol('descripcion_local', 'Descripción del artículo', 265);
  AddCol('descripcion_ean', 'Descripción en EAN', 210);
  AddCol('descripcion_externa', 'Descripción de Internet', 265);
  AddCol('marca_externa', 'Marca', 150);
  AddCol('cantidad_externa', 'Formato', 105);
  AddCol('coincidencia', 'Coinc. %', 75, taRightJustify);
  AddCol('fuente', 'Fuente', 135);
  AddCol('fecha_internet', 'Última consulta', 135);
  AddCol('gs1_estado', 'GS1', 135);
end;

procedure TAuditoriaEANFacturLinExForm.ActualizarKPIs;
var
  Total, Incidencias, Pendientes, Correctos: Integer;
begin
  Total := 0;
  Incidencias := 0;
  Pendientes := 0;
  Correctos := 0;
  if not ConexionDisponible or not TableExists(TABLA_AUDITORIA) then Exit;

  qAux.Close;
  qAux.SQL.Text :=
    'SELECT COUNT(*) AS total, ' +
    'SUM(estado_final IN (''FORMATO_INVALIDO'',''DIGITO_CONTROL'',''DUPLICADO'',' +
    '''DUPLICADO_FILA'',''ARTICULO_INEXISTENTE'',''SIN_DESCRIPCION'',' +
    '''POSIBLE_ERROR'',''POSIBLE_ERROR_GS1'')) AS incidencias, ' +
    'SUM(estado_local=''VALIDO'' AND estado_internet IN (''PENDIENTE'',''ERROR_TEMPORAL'')) AS pendientes, ' +
    'SUM(estado_final IN (''CORRECTO'',''CORRECTO_GS1'',''REVISADO'')) AS correctos ' +
    'FROM `' + TABLA_AUDITORIA + '` WHERE activo=''S''';
  qAux.Open;
  Total := qAux.FieldByName('total').AsInteger;
  Incidencias := qAux.FieldByName('incidencias').AsInteger;
  Pendientes := qAux.FieldByName('pendientes').AsInteger;
  Correctos := qAux.FieldByName('correctos').AsInteger;
  qAux.Close;

  LblKpiTotal.Caption := 'TOTAL' + LineEnding + IntToStr(Total);
  LblKpiIncidencias.Caption := 'INCIDENCIAS' + LineEnding + IntToStr(Incidencias);
  LblKpiPendientes.Caption := 'PENDIENTES INTERNET' + LineEnding + IntToStr(Pendientes);
  LblKpiCorrectos.Caption := 'CONFIRMADOS' + LineEnding + IntToStr(Correctos);
end;

procedure TAuditoriaEANFacturLinExForm.EjecutarAuditoriaLocal;
var
  EAN, Codigo, DescEAN, DescLocal, EstadoLocal, EstadoFinal, Motivo, Huella: string;
  Unidades: Double;
  Asignaciones, DuplicadosFila, Procesados: Integer;
  ArticuloExiste: Boolean;
begin
  if not ConexionDisponible then
  begin
    MessageDlg('Auditoría local', 'No hay conexión con la base de datos.',
      mtError, [mbOK], 0);
    Exit;
  end;
  if not TableExists('eans') then
  begin
    MessageDlg('Auditoría local', 'No existe la tabla eans.', mtError, [mbOK], 0);
    Exit;
  end;
  if not TableExists(FTablaArticulos) then
  begin
    MessageDlg('Auditoría local',
      'No existe la tabla de artículos ' + FTablaArticulos + '.', mtError, [mbOK], 0);
    Exit;
  end;

  AsegurarTablaAuditoria;
  FProcesando := True;
  FCancelar := False;
  AplicarEstadoControles;
  ProgressBar1.Position := 0;
  LblProgreso.Caption := 'Preparando auditoría local...';
  Application.ProcessMessages;

  try
    qAux.Close;
    qAux.SQL.Text := 'UPDATE `' + TABLA_AUDITORIA + '` SET activo=''N''';
    qAux.ExecSQL;

    qTrabajo.Close;
    qTrabajo.SQL.Text :=
      'SELECT e.EAN0 AS ean, e.EAN1 AS codigo, COALESCE(e.EAN2,'''') AS desc_ean, ' +
      'COALESCE(e.EAN3,0) AS unidades, a.A1 AS desc_local, ' +
      '(SELECT COUNT(DISTINCT x.EAN1) FROM eans x WHERE x.EAN0=e.EAN0) AS asignaciones, ' +
      '(SELECT COUNT(*) FROM eans y WHERE y.EAN0=e.EAN0 AND y.EAN1=e.EAN1) AS duplicados_fila ' +
      'FROM eans e LEFT JOIN ' + SQLIdentSeguro(FTablaArticulos) +
      ' a ON a.A0=e.EAN1 ORDER BY e.EAN0,e.EAN1';
    qTrabajo.Open;
    qTrabajo.Last;
    ProgressBar1.Max := Max(1, qTrabajo.RecordCount);
    qTrabajo.First;

    qAux.Close;
    qAux.SQL.Text :=
      'INSERT INTO `' + TABLA_AUDITORIA + '` ' +
      '(ean,codigo_articulo,descripcion_ean,descripcion_local,unidades,asignaciones,' +
      'duplicados_fila,estado_local,motivo_local,huella_local,estado_final,activo,fecha_local) ' +
      'VALUES (:ean,:codigo,:desc_ean,:desc_local,:unidades,:asignaciones,:duplicados,' +
      ':estado_local,:motivo,:huella,:estado_final,''S'',NOW()) ' +
      'ON DUPLICATE KEY UPDATE ' +
      'descripcion_ean=VALUES(descripcion_ean),descripcion_local=VALUES(descripcion_local),' +
      'unidades=VALUES(unidades),asignaciones=VALUES(asignaciones),' +
      'duplicados_fila=VALUES(duplicados_fila),estado_local=VALUES(estado_local),' +
      'motivo_local=VALUES(motivo_local),' +
      'estado_internet=IF(huella_local<>VALUES(huella_local),''PENDIENTE'',estado_internet),' +
      'descripcion_externa=IF(huella_local<>VALUES(huella_local),'''',descripcion_externa),' +
      'marca_externa=IF(huella_local<>VALUES(huella_local),'''',marca_externa),' +
      'cantidad_externa=IF(huella_local<>VALUES(huella_local),'''',cantidad_externa),' +
      'categoria_externa=IF(huella_local<>VALUES(huella_local),'''',categoria_externa),' +
      'fuente=IF(huella_local<>VALUES(huella_local),'''',fuente),' +
      'imagen_url=IF(huella_local<>VALUES(huella_local),'''',imagen_url),' +
      'coincidencia=IF(huella_local<>VALUES(huella_local),0,coincidencia),' +
      'estado_final=IF(VALUES(estado_local)<>''VALIDO'',VALUES(estado_final),' +
      'IF(huella_local<>VALUES(huella_local),''PENDIENTE'',estado_final)),' +
      'huella_local=VALUES(huella_local),activo=''S'',fecha_local=NOW()';

    Procesados := 0;
    while not qTrabajo.EOF do
    begin
      if FCancelar then Break;
      EAN := Trim(qTrabajo.FieldByName('ean').AsString);
      Codigo := Trim(qTrabajo.FieldByName('codigo').AsString);
      DescEAN := Trim(qTrabajo.FieldByName('desc_ean').AsString);
      ArticuloExiste := not qTrabajo.FieldByName('desc_local').IsNull;
      DescLocal := Trim(qTrabajo.FieldByName('desc_local').AsString);
      Unidades := qTrabajo.FieldByName('unidades').AsFloat;
      Asignaciones := qTrabajo.FieldByName('asignaciones').AsInteger;
      DuplicadosFila := qTrabajo.FieldByName('duplicados_fila').AsInteger;

      EstadoLocal := 'VALIDO';
      EstadoFinal := 'PENDIENTE';
      Motivo := 'Formato, dígito de control y asignación local correctos.';

      if EAN = '' then
      begin
        EstadoLocal := 'FORMATO_INVALIDO';
        EstadoFinal := EstadoLocal;
        Motivo := 'El código EAN está vacío.';
      end
      else if not SoloDigitos(EAN) or not (Length(EAN) in [8,12,13,14]) then
      begin
        EstadoLocal := 'FORMATO_INVALIDO';
        EstadoFinal := EstadoLocal;
        Motivo := 'Debe contener únicamente dígitos y tener longitud GTIN 8, 12, 13 o 14.';
      end
      else if not EsGTINValido(EAN) then
      begin
        EstadoLocal := 'DIGITO_CONTROL';
        EstadoFinal := EstadoLocal;
        Motivo := 'El dígito de control no coincide.';
      end
      else if Asignaciones > 1 then
      begin
        EstadoLocal := 'DUPLICADO';
        EstadoFinal := EstadoLocal;
        Motivo := 'El mismo EAN está asignado a ' + IntToStr(Asignaciones) +
          ' códigos de artículo diferentes.';
      end
      else if DuplicadosFila > 1 then
      begin
        EstadoLocal := 'DUPLICADO_FILA';
        EstadoFinal := EstadoLocal;
        Motivo := 'La misma relación EAN/artículo aparece ' +
          IntToStr(DuplicadosFila) + ' veces en la tabla eans.';
      end
      else if not ArticuloExiste then
      begin
        EstadoLocal := 'ARTICULO_INEXISTENTE';
        EstadoFinal := EstadoLocal;
        Motivo := 'El código interno no existe en ' + FTablaArticulos + '.';
      end
      else if EsEANInternoOVariable(EAN) then
      begin
        EstadoLocal := 'INTERNO';
        EstadoFinal := EstadoLocal;
        Motivo := 'Prefijo 20-29 reservado para distribución restringida o peso/precio variable; no se consulta masivamente.';
      end
      else if (DescLocal = '') and (DescEAN = '') then
      begin
        EstadoLocal := 'SIN_DESCRIPCION';
        EstadoFinal := EstadoLocal;
        Motivo := 'No existe descripción local suficiente para comparar.';
      end;

      Huella := HuellaTexto(EAN + '|' + Codigo + '|' + DescEAN + '|' + DescLocal +
        '|' + FloatToStr(Unidades) + '|' + EstadoLocal);

      qAux.ParamByName('ean').AsString := EAN;
      qAux.ParamByName('codigo').AsString := Codigo;
      qAux.ParamByName('desc_ean').AsString := DescEAN;
      qAux.ParamByName('desc_local').AsString := DescLocal;
      qAux.ParamByName('unidades').AsFloat := Unidades;
      qAux.ParamByName('asignaciones').AsInteger := Asignaciones;
      qAux.ParamByName('duplicados').AsInteger := DuplicadosFila;
      qAux.ParamByName('estado_local').AsString := EstadoLocal;
      qAux.ParamByName('motivo').AsString := Motivo;
      qAux.ParamByName('huella').AsString := Huella;
      qAux.ParamByName('estado_final').AsString := EstadoFinal;
      qAux.ExecSQL;

      Inc(Procesados);
      ProgressBar1.Position := Procesados;
      LblProgreso.Caption := Format('Auditoría local: %d de %d',
        [Procesados, ProgressBar1.Max]);
      if (Procesados mod 25) = 0 then Application.ProcessMessages;
      qTrabajo.Next;
    end;
    qTrabajo.Close;

    LblProgreso.Caption := 'Auditoría local finalizada: ' + IntToStr(Procesados) + ' registros.';
    StatusBar1.SimpleText := LblProgreso.Caption;
  finally
    FProcesando := False;
    AplicarEstadoControles;
    CargarLista;
  end;
end;

procedure TAuditoriaEANFacturLinExForm.EjecutarAuditoriaInternet;
var
  R: TOpenFactsResult;
  ID: Int64;
  EAN, LocalTexto, ExternoTexto, EstadoInternet, EstadoFinal, ErrorTexto: string;
  Coincidencia, Procesados, Total, I: Integer;
  ConsultaOK: Boolean;
begin
  if not ConexionDisponible then
  begin
    MessageDlg('Comprobación por Internet', 'No hay conexión con la base de datos.',
      mtError, [mbOK], 0);
    Exit;
  end;
  if not TableExists(TABLA_AUDITORIA) then
  begin
    MessageDlg('Comprobación por Internet',
      'Ejecute primero la auditoría local.', mtInformation, [mbOK], 0);
    Exit;
  end;

  qTrabajo.Close;
  qTrabajo.SQL.Text :=
    'SELECT id,ean,descripcion_local,descripcion_ean FROM `' + TABLA_AUDITORIA + '` ' +
    'WHERE activo=''S'' AND estado_local=''VALIDO'' ' +
    'AND estado_internet IN (''PENDIENTE'',''ERROR_TEMPORAL'') ' +
    'ORDER BY id LIMIT ' + IntToStr(SeLimite.Value);
  qTrabajo.Open;
  qTrabajo.Last;
  Total := qTrabajo.RecordCount;
  qTrabajo.First;
  if Total = 0 then
  begin
    qTrabajo.Close;
    MessageDlg('Comprobación por Internet',
      'No hay códigos pendientes dentro de los criterios actuales.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  FProcesando := True;
  FCancelar := False;
  AplicarEstadoControles;
  ProgressBar1.Max := Total;
  ProgressBar1.Position := 0;
  Procesados := 0;

  try
    while not qTrabajo.EOF do
    begin
      if FCancelar then Break;
      ID := qTrabajo.FieldByName('id').AsLargeInt;
      EAN := Trim(qTrabajo.FieldByName('ean').AsString);
      LocalTexto := Trim(qTrabajo.FieldByName('descripcion_local').AsString + ' ' +
        qTrabajo.FieldByName('descripcion_ean').AsString);
      LblProgreso.Caption := Format('Consultando %s (%d de %d)...',
        [EAN, Procesados + 1, Total]);
      Application.ProcessMessages;

      ConsultaOK := ConsultarOpenFacts(EAN, R);
      Coincidencia := 0;
      EstadoInternet := 'ERROR';
      EstadoFinal := 'ERROR_INTERNET';
      ErrorTexto := R.ErrorTexto;

      if ConsultaOK and not R.Encontrado then
      begin
        EstadoInternet := 'SIN_DATOS';
        EstadoFinal := 'SIN_DATOS';
        ErrorTexto := '';
      end
      else if ConsultaOK and R.Encontrado then
      begin
        ExternoTexto := Trim(R.Nombre + ' ' + R.Marca + ' ' + R.Cantidad);
        Coincidencia := CalcularCoincidencia(LocalTexto, ExternoTexto);
        EstadoInternet := 'ENCONTRADO';
        ErrorTexto := '';
        if Coincidencia >= 75 then
          EstadoFinal := 'CORRECTO'
        else if Coincidencia >= 45 then
          EstadoFinal := 'REVISAR'
        else
          EstadoFinal := 'POSIBLE_ERROR';
      end
      else if R.ErrorTemporal then
      begin
        EstadoInternet := 'ERROR_TEMPORAL';
        EstadoFinal := 'ERROR_INTERNET';
      end;

      qAux.Close;
      qAux.SQL.Text :=
        'UPDATE `' + TABLA_AUDITORIA + '` SET ' +
        'estado_internet=:estado_internet,descripcion_externa=:descripcion,' +
        'marca_externa=:marca,cantidad_externa=:cantidad,categoria_externa=:categoria,' +
        'tipo_producto=:tipo,fuente=:fuente,imagen_url=:imagen,coincidencia=:coincidencia,' +
        'respuesta_json=:json,error_internet=:error,fecha_internet=NOW(),' +
        'estado_final=CASE WHEN gs1_estado=''COINCIDE'' THEN ''CORRECTO_GS1'' ' +
        'WHEN gs1_estado=''NO_COINCIDE'' THEN ''POSIBLE_ERROR_GS1'' ELSE :estado_final END ' +
        'WHERE id=:id';
      qAux.ParamByName('estado_internet').AsString := EstadoInternet;
      qAux.ParamByName('descripcion').AsString := R.Nombre;
      qAux.ParamByName('marca').AsString := R.Marca;
      qAux.ParamByName('cantidad').AsString := R.Cantidad;
      qAux.ParamByName('categoria').AsString := R.Categoria;
      qAux.ParamByName('tipo').AsString := R.TipoProducto;
      qAux.ParamByName('fuente').AsString := R.Fuente;
      qAux.ParamByName('imagen').AsString := R.ImagenURL;
      qAux.ParamByName('coincidencia').AsInteger := Coincidencia;
      qAux.ParamByName('json').AsString := R.RespuestaJSON;
      qAux.ParamByName('error').AsString := ErrorTexto;
      qAux.ParamByName('estado_final').AsString := EstadoFinal;
      qAux.ParamByName('id').AsLargeInt := ID;
      qAux.ExecSQL;

      Inc(Procesados);
      ProgressBar1.Position := Procesados;
      LblProgreso.Caption := Format('Comprobados por Internet: %d de %d',
        [Procesados, Total]);
      Application.ProcessMessages;
      qTrabajo.Next;

      if not qTrabajo.EOF and not FCancelar then
        for I := 1 to SePausa.Value * 10 do
        begin
          Sleep(100);
          Application.ProcessMessages;
          if FCancelar then Break;
        end;
    end;

    if FCancelar then
      LblProgreso.Caption := 'Proceso detenido después de ' + IntToStr(Procesados) + ' consultas.'
    else
      LblProgreso.Caption := 'Comprobación por Internet finalizada: ' +
        IntToStr(Procesados) + ' consultas.';
    StatusBar1.SimpleText := LblProgreso.Caption;
  finally
    qTrabajo.Close;
    FProcesando := False;
    AplicarEstadoControles;
    CargarLista;
  end;
end;

function TAuditoriaEANFacturLinExForm.IdSeleccionado: Int64;
begin
  Result := 0;
  if qLista.Active and not qLista.IsEmpty then
    Result := qLista.FieldByName('id').AsLargeInt;
end;

function TAuditoriaEANFacturLinExForm.EANSeleccionado: string;
begin
  Result := '';
  if qLista.Active and not qLista.IsEmpty then
    Result := Trim(qLista.FieldByName('ean').AsString);
end;

procedure TAuditoriaEANFacturLinExForm.ActualizarDetalle;
var
  S: TStringList;
begin
  MemoDetalle.Clear;
  if not qLista.Active or qLista.IsEmpty then Exit;
  S := TStringList.Create;
  try
    S.Add('EAN / GTIN: ' + qLista.FieldByName('ean').AsString);
    S.Add('Código interno: ' + qLista.FieldByName('codigo_articulo').AsString);
    S.Add('Estado final: ' + qLista.FieldByName('estado_final').AsString);
    S.Add('Estado local: ' + qLista.FieldByName('estado_local').AsString);
    S.Add('Motivo local: ' + qLista.FieldByName('motivo_local').AsString);
    S.Add('');
    S.Add('Descripción artículo: ' + qLista.FieldByName('descripcion_local').AsString);
    S.Add('Descripción en eans: ' + qLista.FieldByName('descripcion_ean').AsString);
    S.Add('');
    S.Add('Descripción externa: ' + qLista.FieldByName('descripcion_externa').AsString);
    S.Add('Marca: ' + qLista.FieldByName('marca_externa').AsString);
    S.Add('Cantidad / formato: ' + qLista.FieldByName('cantidad_externa').AsString);
    S.Add('Categoría: ' + qLista.FieldByName('categoria_externa').AsString);
    S.Add('Fuente: ' + qLista.FieldByName('fuente').AsString);
    S.Add('Coincidencia orientativa: ' + qLista.FieldByName('coincidencia').AsString + ' %');
    if qLista.FieldByName('error_internet').AsString <> '' then
      S.Add('Error de Internet: ' + qLista.FieldByName('error_internet').AsString);
    S.Add('');
    S.Add('GS1: ' + qLista.FieldByName('gs1_estado').AsString);
    S.Add('Observaciones GS1: ' + qLista.FieldByName('gs1_observaciones').AsString);
    S.Add('Revisado manualmente: ' + qLista.FieldByName('revisado_manual').AsString);
    MemoDetalle.Lines.Assign(S);
  finally
    S.Free;
  end;
end;

procedure TAuditoriaEANFacturLinExForm.RegistrarResultadoGS1;
var
  F: TForm;
  L: TLabel;
  C: TComboBox;
  M: TMemo;
  BOk, BCancel: TButton;
  Estado, EstadoFinal: string;
  ID: Int64;
begin
  ID := IdSeleccionado;
  if ID = 0 then Exit;

  F := TForm.CreateNew(Self);
  try
    F.Caption := 'Registrar comprobación manual de GS1';
    F.Position := poScreenCenter;
    F.BorderStyle := bsDialog;
    F.ClientWidth := 560;
    F.ClientHeight := 330;
    F.Color := RGBToColor(244, 248, 252);

    L := TLabel.Create(F);
    L.Parent := F;
    L.SetBounds(24, 20, 510, 42);
    L.AutoSize := False;
    L.WordWrap := True;
    L.Caption := 'EAN ' + EANSeleccionado +
      '. Seleccione el resultado observado en la página oficial Verified by GS1.';

    C := TComboBox.Create(F);
    C.Parent := F;
    C.SetBounds(24, 72, 512, 34);
    C.Style := csDropDownList;
    C.Items.Add('COINCIDE');
    C.Items.Add('NO_COINCIDE');
    C.Items.Add('EMPRESA_IDENTIFICADA');
    C.Items.Add('SIN_DATOS_PRODUCTO');
    C.Items.Add('PENDIENTE');
    C.ItemIndex := 0;

    M := TMemo.Create(F);
    M.Parent := F;
    M.SetBounds(24, 122, 512, 132);
    M.ScrollBars := ssAutoVertical;
    M.Text := qLista.FieldByName('gs1_observaciones').AsString;

    BOk := TButton.Create(F);
    BOk.Parent := F;
    BOk.SetBounds(326, 274, 100, 36);
    BOk.Caption := 'Guardar';
    BOk.ModalResult := mrOk;

    BCancel := TButton.Create(F);
    BCancel.Parent := F;
    BCancel.SetBounds(436, 274, 100, 36);
    BCancel.Caption := 'Cancelar';
    BCancel.ModalResult := mrCancel;

    FLXAplicarTemaVisual(F);
    if F.ShowModal <> mrOk then Exit;

    Estado := C.Text;
    if Estado = 'COINCIDE' then
      EstadoFinal := 'CORRECTO_GS1'
    else if Estado = 'NO_COINCIDE' then
      EstadoFinal := 'POSIBLE_ERROR_GS1'
    else
      EstadoFinal := qLista.FieldByName('estado_final').AsString;

    qAux.Close;
    qAux.SQL.Text :=
      'UPDATE `' + TABLA_AUDITORIA + '` SET gs1_estado=:estado,' +
      'gs1_observaciones=:observaciones,fecha_gs1=NOW(),revisado_manual=''S'',' +
      'estado_final=:estado_final WHERE id=:id';
    qAux.ParamByName('estado').AsString := Estado;
    qAux.ParamByName('observaciones').AsString := M.Text;
    qAux.ParamByName('estado_final').AsString := EstadoFinal;
    qAux.ParamByName('id').AsLargeInt := ID;
    qAux.ExecSQL;
    CargarLista;
  finally
    F.Free;
  end;
end;

function CSVTexto(const S: string): string;
begin
  Result := '"' + StringReplace(S, '"', '""', [rfReplaceAll]) + '"';
end;

procedure EscribirUTF8(Stream: TStream; const S: string);
begin
  if S <> '' then Stream.WriteBuffer(S[1], Length(S));
end;

procedure TAuditoriaEANFacturLinExForm.ExportarCSV;
const
  BOM: array[0..2] of Byte = ($EF, $BB, $BF);
var
  FS: TFileStream;
  Linea: string;
  Contador: Integer;
begin
  if not qLista.Active or qLista.IsEmpty then
  begin
    MessageDlg('Exportar', 'No hay datos para exportar.', mtInformation, [mbOK], 0);
    Exit;
  end;

  SaveDialog1.Title := 'Exportar auditoría EAN a CSV';
  SaveDialog1.Filter := 'CSV (*.csv)|*.csv|Todos los archivos|*.*';
  SaveDialog1.DefaultExt := 'csv';
  SaveDialog1.FileName := 'auditoria_ean_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.csv';
  if not SaveDialog1.Execute then Exit;

  FS := TFileStream.Create(SaveDialog1.FileName, fmCreate);
  try
    FS.WriteBuffer(BOM, SizeOf(BOM));
    EscribirUTF8(FS,
      'Estado;EAN;Codigo;Descripcion local;Descripcion EAN;Descripcion externa;' +
      'Marca;Formato;Coincidencia;Fuente;Fecha Internet;GS1;Observaciones GS1' + LineEnding);
    qLista.DisableControls;
    try
      qLista.First;
      Contador := 0;
      while not qLista.EOF do
      begin
        Linea :=
          CSVTexto(qLista.FieldByName('estado_final').AsString) + ';' +
          CSVTexto(qLista.FieldByName('ean').AsString) + ';' +
          CSVTexto(qLista.FieldByName('codigo_articulo').AsString) + ';' +
          CSVTexto(qLista.FieldByName('descripcion_local').AsString) + ';' +
          CSVTexto(qLista.FieldByName('descripcion_ean').AsString) + ';' +
          CSVTexto(qLista.FieldByName('descripcion_externa').AsString) + ';' +
          CSVTexto(qLista.FieldByName('marca_externa').AsString) + ';' +
          CSVTexto(qLista.FieldByName('cantidad_externa').AsString) + ';' +
          CSVTexto(qLista.FieldByName('coincidencia').AsString) + ';' +
          CSVTexto(qLista.FieldByName('fuente').AsString) + ';' +
          CSVTexto(qLista.FieldByName('fecha_internet').AsString) + ';' +
          CSVTexto(qLista.FieldByName('gs1_estado').AsString) + ';' +
          CSVTexto(qLista.FieldByName('gs1_observaciones').AsString) + LineEnding;
        EscribirUTF8(FS, Linea);
        Inc(Contador);
        qLista.Next;
      end;
    finally
      qLista.EnableControls;
    end;
  finally
    FS.Free;
  end;
  CargarLista;
  MessageDlg('Exportar', 'CSV generado correctamente.', mtInformation, [mbOK], 0);
end;

procedure TAuditoriaEANFacturLinExForm.BtnAuditoriaLocalClick(Sender: TObject);
begin
  EjecutarAuditoriaLocal;
end;

procedure TAuditoriaEANFacturLinExForm.BtnInternetClick(Sender: TObject);
begin
  if MessageDlg('Comprobación por Internet',
    'Se consultarán hasta ' + IntToStr(SeLimite.Value) + ' códigos pendientes.' +
    LineEnding + 'El proceso respeta una pausa de ' + IntToStr(SePausa.Value) +
    ' segundos entre consultas.' + LineEnding + LineEnding + '¿Continuar?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    EjecutarAuditoriaInternet;
end;

procedure TAuditoriaEANFacturLinExForm.BtnDetenerClick(Sender: TObject);
begin
  FCancelar := True;
  BtnDetener.Enabled := False;
  LblProgreso.Caption := 'Deteniendo después de la consulta actual...';
end;

procedure TAuditoriaEANFacturLinExForm.BtnActualizarClick(Sender: TObject);
begin
  CargarLista;
end;

procedure TAuditoriaEANFacturLinExForm.BtnGS1Click(Sender: TObject);
var
  EAN: string;
begin
  EAN := EANSeleccionado;
  if EAN = '' then
  begin
    MessageDlg('Verified by GS1', 'Seleccione una fila con un EAN.',
      mtInformation, [mbOK], 0);
    Exit;
  end;
  Clipboard.AsText := EAN;
  if not OpenURL(GS1_URL) then
    MessageDlg('Verified by GS1',
      'No se pudo abrir el navegador. El EAN se ha copiado al portapapeles: ' + EAN,
      mtWarning, [mbOK], 0)
  else
    MessageDlg('Verified by GS1',
      'Se ha copiado el EAN ' + EAN + ' al portapapeles.' + LineEnding +
      'Péguelo en la página oficial y después use “Registrar resultado GS1”.',
      mtInformation, [mbOK], 0);
end;

procedure TAuditoriaEANFacturLinExForm.BtnRegistrarGS1Click(Sender: TObject);
begin
  RegistrarResultadoGS1;
end;

procedure TAuditoriaEANFacturLinExForm.BtnAbrirImagenClick(Sender: TObject);
var
  URL: string;
begin
  if not qLista.Active or qLista.IsEmpty then Exit;
  URL := Trim(qLista.FieldByName('imagen_url').AsString);
  if URL = '' then
  begin
    MessageDlg('Imagen externa', 'El resultado no contiene una imagen.',
      mtInformation, [mbOK], 0);
    Exit;
  end;
  if not OpenURL(URL) then
    MessageDlg('Imagen externa', 'No se pudo abrir la imagen en el navegador.',
      mtWarning, [mbOK], 0);
end;

procedure TAuditoriaEANFacturLinExForm.BtnCopiarEANClick(Sender: TObject);
var
  EAN: string;
begin
  EAN := EANSeleccionado;
  if EAN <> '' then
  begin
    Clipboard.AsText := EAN;
    StatusBar1.SimpleText := 'EAN copiado: ' + EAN;
  end;
end;

procedure TAuditoriaEANFacturLinExForm.BtnMarcarRevisadoClick(Sender: TObject);
var
  ID: Int64;
begin
  ID := IdSeleccionado;
  if ID = 0 then Exit;
  qAux.Close;
  qAux.SQL.Text :=
    'UPDATE `' + TABLA_AUDITORIA + '` SET revisado_manual=''S'',' +
    'estado_final=CASE WHEN estado_final=''REVISAR'' THEN ''REVISADO'' ELSE estado_final END ' +
    'WHERE id=:id';
  qAux.ParamByName('id').AsLargeInt := ID;
  qAux.ExecSQL;
  CargarLista;
end;

procedure TAuditoriaEANFacturLinExForm.BtnExportarCSVClick(Sender: TObject);
begin
  ExportarCSV;
end;

procedure TAuditoriaEANFacturLinExForm.BtnCerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TAuditoriaEANFacturLinExForm.CbVistaChange(Sender: TObject);
begin
  if not FProcesando then CargarLista;
end;

procedure TAuditoriaEANFacturLinExForm.EdBuscarChange(Sender: TObject);
begin
  if not FProcesando then CargarLista;
end;

procedure TAuditoriaEANFacturLinExForm.qListaAfterScroll(DataSet: TDataSet);
begin
  ActualizarDetalle;
end;

procedure TAuditoriaEANFacturLinExForm.GridDblClick(Sender: TObject);
begin
  ActualizarDetalle;
end;

procedure TAuditoriaEANFacturLinExForm.GridTitleClick(Column: TColumn);
begin
  if not Assigned(Column) or (Column.FieldName = '') then Exit;
  if SameText(FOrdenCampo, Column.FieldName) then
    FOrdenDesc := not FOrdenDesc
  else
  begin
    FOrdenCampo := Column.FieldName;
    FOrdenDesc := False;
  end;
  CargarLista;
end;

procedure TAuditoriaEANFacturLinExForm.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Estado: string;
begin
  if gdSelected in State then
  begin
    Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    Exit;
  end;

  Estado := '';
  if qLista.Active and not qLista.IsEmpty then
    Estado := qLista.FieldByName('estado_final').AsString;

  if (Estado = 'CORRECTO') or (Estado = 'CORRECTO_GS1') then
    Grid.Canvas.Brush.Color := RGBToColor(226, 246, 231)
  else if (Estado = 'REVISAR') or (Estado = 'REVISADO') or
          (Estado = 'SIN_DATOS') or (Estado = 'PENDIENTE') then
    Grid.Canvas.Brush.Color := RGBToColor(255, 248, 218)
  else if (Estado = 'INTERNO') then
    Grid.Canvas.Brush.Color := RGBToColor(235, 238, 243)
  else if (Estado = 'ERROR_INTERNET') then
    Grid.Canvas.Brush.Color := RGBToColor(232, 242, 252)
  else
    Grid.Canvas.Brush.Color := RGBToColor(255, 229, 229);

  Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TAuditoriaEANFacturLinExForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    if FProcesando then
    begin
      FCancelar := True;
      LblProgreso.Caption := 'Deteniendo después de la consulta actual...';
    end
    else
      Close;
    Key := 0;
  end
  else if (Key = Ord('F')) and (ssCtrl in Shift) then
  begin
    EdBuscar.SetFocus;
    EdBuscar.SelectAll;
    Key := 0;
  end
  else if (Key = Ord('G')) and (ssCtrl in Shift) then
  begin
    BtnGS1Click(BtnGS1);
    Key := 0;
  end;
end;

procedure TAuditoriaEANFacturLinExForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if FProcesando then
  begin
    FCancelar := True;
    CanClose := False;
    MessageDlg('Auditoría de EAN',
      'Se ha solicitado detener el proceso. Cierre el formulario cuando termine la consulta actual.',
      mtInformation, [mbOK], 0);
  end
  else
    CanClose := True;
end;

end.
