unit uFLXConfigTecladoProductos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, ExtCtrls, StdCtrls,
  Dialogs, Buttons, CheckLst, ZConnection, ZAbstractConnection, ZDataset;

function FLXRutaIconosTeclado: string;
function FLXRutaIconoGrupo(const AIcono: string): string;
function FLXIconoPredeterminadoGrupo(const ANombre: string): string;
function FLXTablaTecladoGrupos(const ATienda: string): string;
function FLXTablaTecladoProductos(const ATienda: string): string;
procedure FLXAsegurarTablasTecladoProductos(AConnection: TZAbstractConnection;
  const ATienda: string);
procedure FLXConfigurarTecladoProductos(AOwner: TComponent;
  AConnection: TZAbstractConnection; const ATienda: string);

implementation

type
  { TFLXSelectorArticulosForm }

  TFLXSelectorArticulosForm = class(TForm)
  private
    FConnection: TZAbstractConnection;
    FTienda: string;
    FEditFiltro: TEdit;
    FLista: TCheckListBox;
    FInfo: TLabel;
    FCodigos: TStringList;
    procedure AceptarClick(Sender: TObject);
    procedure BuscarClick(Sender: TObject);
    procedure BuscarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EjecutarBusqueda;
  public
    constructor CreateSelector(AOwner: TComponent;
      AConnection: TZAbstractConnection; const ATienda: string); reintroduce;
    destructor Destroy; override;
    procedure CopiarCodigosSeleccionados(ADestino: TStrings);
  end;

  { TFLXConfigTecladoProductosForm }

  TFLXConfigTecladoProductosForm = class(TForm)
  private
    FConnection: TZAbstractConnection;
    FTienda: string;
    FListaGrupos: TListBox;
    FListaProductos: TCheckListBox;
    procedure ActivarProductoClick(Sender: TObject);
    procedure DesactivarProductoClick(Sender: TObject);
    procedure AsignarIconoGrupoClick(Sender: TObject);
    procedure AgregarFamiliaClick(Sender: TObject);
    procedure AgregarGrupoClick(Sender: TObject);
    procedure AgregarProductoClick(Sender: TObject);
    procedure BajarGrupoClick(Sender: TObject);
    procedure BajarProductoClick(Sender: TObject);
    procedure CerrarClick(Sender: TObject);
    procedure EditarProductoClick(Sender: TObject);
    procedure EliminarGrupoClick(Sender: TObject);
    procedure EliminarProductoClick(Sender: TObject);
    procedure GrupoClick(Sender: TObject);
    procedure LimpiarSeleccionProductosClick(Sender: TObject);
    procedure SeleccionarTodosProductosClick(Sender: TObject);
    procedure QuitarIconoGrupoClick(Sender: TObject);
    procedure RenombrarGrupoClick(Sender: TObject);
    procedure SubirGrupoClick(Sender: TObject);
    procedure SubirProductoClick(Sender: TObject);
    function GrupoActualID: Integer;
    function ProductoActualID: Integer;
    function ContarProductosSeleccionados: Integer;
    function NuevoQuery: TZQuery;
    procedure EstablecerActivoSeleccionados(const AActivo: string);
    procedure RefrescarGrupos(ASeleccionarID: Integer = 0);
    procedure RefrescarProductos(ASeleccionarID: Integer = 0);
    procedure SeleccionarID(ALista: TCustomListBox; AID: Integer);
    procedure IntercambiarOrden(const ATabla, ACampoID,
      ACampoOrden: string; AID1, AID2: Integer);
  public
    constructor CreateConfig(AOwner: TComponent;
      AConnection: TZAbstractConnection; const ATienda: string); reintroduce;
  end;

function FLXTiendaSegura(const ATienda: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(ATienda) do
    if ATienda[I] in ['0'..'9'] then
      Result := Result + ATienda[I];

  if Result = '' then
    raise Exception.Create('No se ha podido determinar la tienda.');
end;

function FLXEsEjecucionProduccion: Boolean;
var
  Ejecutable: string;
begin
  Ejecutable := ExpandFileName(Application.ExeName);
  Result :=
    (Pos('/usr/bin/', Ejecutable) = 1) or
    (Pos('/usr/share/facturlinex2/', Ejecutable) = 1);
end;

function FLXRutaIconosProduccion: string;
begin
  Result := '/usr/share/facturlinex2' + PathDelim +
    'Recursos' + PathDelim + 'Teclado' + PathDelim + 'Grupos';
  Result := IncludeTrailingPathDelimiter(Result);
end;

function FLXRutaIconosProyecto: string;
var
  DirectorioExe, RaizProyecto: string;
begin
  DirectorioExe := ExcludeTrailingPathDelimiter(
    ExtractFilePath(ExpandFileName(Application.ExeName)));

  if SameText(ExtractFileName(DirectorioExe), 'Bin') then
    RaizProyecto := ExtractFileDir(DirectorioExe)
  else
    RaizProyecto := GetCurrentDir;

  Result := IncludeTrailingPathDelimiter(RaizProyecto) +
    'Recursos' + PathDelim + 'Teclado' + PathDelim + 'Grupos';
  Result := IncludeTrailingPathDelimiter(ExpandFileName(Result));
end;

function FLXRutaIconosEjecutable: string;
begin
  Result := IncludeTrailingPathDelimiter(
    ExtractFilePath(ExpandFileName(Application.ExeName))) +
    'Recursos' + PathDelim + 'Teclado' + PathDelim + 'Grupos';
  Result := IncludeTrailingPathDelimiter(ExpandFileName(Result));
end;

function FLXRutaIconosUsuario: string;
var
  CarpetaUsuario: string;
begin
  CarpetaUsuario := GetEnvironmentVariable('HOME');
  if Trim(CarpetaUsuario) = '' then
    CarpetaUsuario := GetCurrentDir;

  Result := IncludeTrailingPathDelimiter(CarpetaUsuario) +
    '.local' + PathDelim + 'share' + PathDelim + 'facturlinex2' +
    PathDelim + 'Recursos' + PathDelim + 'Teclado' + PathDelim + 'Grupos';
  Result := IncludeTrailingPathDelimiter(ExpandFileName(Result));
end;

function FLXDirectorioEscribible(const ARuta: string): Boolean;
var
  Ruta, FicheroPrueba: string;
  Flujo: TFileStream;
begin
  Result := False;
  Ruta := IncludeTrailingPathDelimiter(ARuta);

  try
    if not DirectoryExists(Ruta) then
      if not ForceDirectories(Ruta) then
        Exit;

    FicheroPrueba := Ruta + '.flx_prueba_escritura.tmp';
    Flujo := TFileStream.Create(FicheroPrueba, fmCreate);
    try
      Result := True;
    finally
      Flujo.Free;
    end;
    DeleteFile(FicheroPrueba);
  except
    Result := False;
  end;
end;

function FLXRutaInicialSelectorIconos: string;
begin
  if FLXEsEjecucionProduccion and
     DirectoryExists(FLXRutaIconosProduccion) then
    Result := FLXRutaIconosProduccion
  else if DirectoryExists(FLXRutaIconosProyecto) then
    Result := FLXRutaIconosProyecto
  else if DirectoryExists(FLXRutaIconosEjecutable) then
    Result := FLXRutaIconosEjecutable
  else
    Result := FLXRutaIconosTeclado;
end;

function FLXRutaIconosTeclado: string;
begin
  // En producción se intenta primero la ubicación compartida oficial.
  // Si /usr/share no es escribible para el usuario actual, los iconos
  // personalizados se guardan en ~/.local/share/facturlinex2/.
  if FLXEsEjecucionProduccion then
  begin
    Result := FLXRutaIconosProduccion;
    if FLXDirectorioEscribible(Result) then
      Exit;

    Result := FLXRutaIconosUsuario;
    ForceDirectories(Result);
    Exit;
  end;

  // En desarrollo/pruebas, cuando el ejecutable está en Bin/, la raíz de
  // recursos es el directorio padre de Bin/.
  Result := FLXRutaIconosProyecto;
  if FLXDirectorioEscribible(Result) then
    Exit;

  Result := FLXRutaIconosEjecutable;
  if FLXDirectorioEscribible(Result) then
    Exit;

  Result := FLXRutaIconosUsuario;
  ForceDirectories(Result);
end;

function FLXRutaIconoGrupo(const AIcono: string): string;
var
  NombreSeguro: string;

  function ProbarRuta(const ARuta: string): Boolean;
  begin
    Result := FileExists(IncludeTrailingPathDelimiter(ARuta) + NombreSeguro);
    if Result then
      FLXRutaIconoGrupo := IncludeTrailingPathDelimiter(ARuta) + NombreSeguro;
  end;

begin
  Result := '';
  NombreSeguro := ExtractFileName(Trim(AIcono));
  if NombreSeguro = '' then
    Exit;

  // Los iconos personalizados del usuario tienen prioridad. Después se
  // buscan los recursos compartidos de producción y las rutas de pruebas.
  if ProbarRuta(FLXRutaIconosUsuario) then
    Exit;
  if ProbarRuta(FLXRutaIconosProduccion) then
    Exit;
  if ProbarRuta(FLXRutaIconosProyecto) then
    Exit;
  if ProbarRuta(FLXRutaIconosEjecutable) then
    Exit;
end;

function FLXIconoPredeterminadoGrupo(const ANombre: string): string;
var
  N: string;
begin
  Result := '';
  N := UpperCase(Trim(ANombre));

  if Pos('DROGUER', N) > 0 then
    Result := 'drogueria_spray.png'
  else if Pos('PERFUM', N) > 0 then
    Result := 'perfumeria_perfume.png'
  else if Pos('PINT', N) > 0 then
    Result := 'pinturas_brocha_y_bote.png'
  else if Pos('LIMPI', N) > 0 then
    Result := 'limpieza_cubo_y_esponja.png'
  else if Pos('FERRET', N) > 0 then
    Result := 'ferreteria_herramientas.png'
  else if (Pos('HOGAR', N) > 0) or (Pos('CASA', N) > 0) then
    Result := 'hogar_casa.png';
end;

function FLXColumnaExiste(AConnection: TZAbstractConnection;
  const ATabla, AColumna: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS C FROM INFORMATION_SCHEMA.COLUMNS ' +
      'WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=:T ' +
      'AND COLUMN_NAME=:C';
    Q.ParamByName('T').AsString := ATabla;
    Q.ParamByName('C').AsString := AColumna;
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

procedure FLXCopiarFichero(const AOrigen, ADestino: string);
var
  Entrada, Salida: TFileStream;
begin
  if SameText(ExpandFileName(AOrigen), ExpandFileName(ADestino)) then
    Exit;

  ForceDirectories(ExtractFileDir(ADestino));
  Entrada := TFileStream.Create(AOrigen, fmOpenRead or fmShareDenyWrite);
  try
    Salida := TFileStream.Create(ADestino, fmCreate);
    try
      Salida.CopyFrom(Entrada, 0);
    finally
      Salida.Free;
    end;
  finally
    Entrada.Free;
  end;
end;

function FLXTablaTecladoGrupos(const ATienda: string): string;
begin
  Result := 'flx_teclado_grupos' + FLXTiendaSegura(ATienda);
end;

function FLXTablaTecladoProductos(const ATienda: string): string;
begin
  Result := 'flx_teclado_productos' + FLXTiendaSegura(ATienda);
end;

function FLXTablaExiste(AConnection: TZAbstractConnection;
  const ATabla: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if not Assigned(AConnection) or not AConnection.Connected then
    Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS C FROM INFORMATION_SCHEMA.TABLES ' +
      'WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=:T';
    Q.ParamByName('T').AsString := ATabla;
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

procedure FLXEjecutarSQL(AConnection: TZAbstractConnection;
  const ASQL: string);
var
  Q: TZQuery;
begin
  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.SQL.Text := ASQL;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;


function FLXIdentificadorSQLSeguro(const AValor, ANombre: string): string;
var
  I: Integer;
begin
  Result := Trim(AValor);

  if Result = '' then
    raise Exception.Create(ANombre + ' vacío al consultar la base de datos.');

  for I := 1 to Length(Result) do
    if not (Result[I] in ['A'..'Z', 'a'..'z', '0'..'9', '_']) then
      raise Exception.Create(
        ANombre + ' contiene un valor no válido: ' + Result);
end;

function FLXLeerEstructuraTabla(AConnection: TZAbstractConnection;
  const ATabla: string; out AMotor, ACharset,
  ACollation: string): Boolean;
var
  Q: TZQuery;
  PosSeparador: Integer;
begin
  Result := False;
  AMotor := '';
  ACharset := '';
  ACollation := '';

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;

    // MariaDB no siempre devuelve CHARACTER_SET_NAME al enlazar TABLES con
    // COLLATIONS. ENGINE y TABLE_COLLATION sí están disponibles de forma
    // estable en INFORMATION_SCHEMA.TABLES.
    Q.SQL.Text :=
      'SELECT ENGINE,TABLE_COLLATION ' +
      'FROM INFORMATION_SCHEMA.TABLES ' +
      'WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=:T';
    Q.ParamByName('T').AsString := ATabla;
    Q.Open;

    if Q.IsEmpty then
      Exit;

    AMotor := Trim(Q.FieldByName('ENGINE').AsString);
    ACollation := Trim(Q.FieldByName('TABLE_COLLATION').AsString);
    Q.Close;

    // Si una tabla excepcionalmente no informa su collation, se toma la
    // configuración por defecto de la base de datos actual.
    if ACollation = '' then
    begin
      Q.SQL.Text :=
        'SELECT DEFAULT_CHARACTER_SET_NAME,DEFAULT_COLLATION_NAME ' +
        'FROM INFORMATION_SCHEMA.SCHEMATA ' +
        'WHERE SCHEMA_NAME=DATABASE()';
      Q.Open;

      if not Q.IsEmpty then
      begin
        ACharset := Trim(
          Q.FieldByName('DEFAULT_CHARACTER_SET_NAME').AsString);
        ACollation := Trim(
          Q.FieldByName('DEFAULT_COLLATION_NAME').AsString);
      end;
      Q.Close;
    end;

    // La parte anterior al primer guion bajo de una collation identifica
    // siempre su charset: utf8mb4_spanish_ci -> utf8mb4.
    if (ACharset = '') and (ACollation <> '') then
    begin
      PosSeparador := Pos('_', ACollation);
      if PosSeparador > 1 then
        ACharset := Copy(ACollation, 1, PosSeparador - 1);
    end;

    AMotor := FLXIdentificadorSQLSeguro(AMotor, 'Motor');
    ACollation := FLXIdentificadorSQLSeguro(ACollation, 'Collation');
    ACharset := FLXIdentificadorSQLSeguro(ACharset, 'Charset');

    Result := True;
  finally
    Q.Free;
  end;
end;

procedure FLXAjustarEstructuraTabla(AConnection: TZAbstractConnection;
  const ATabla, AMotor, ACharset, ACollation: string);
var
  MotorActual, CharsetActual, CollationActual: string;
begin
  if not FLXLeerEstructuraTabla(AConnection, ATabla,
    MotorActual, CharsetActual, CollationActual) then
    Exit;

  if not SameText(MotorActual, AMotor) then
    FLXEjecutarSQL(AConnection,
      'ALTER TABLE `' + ATabla + '` ENGINE=' + AMotor);

  if not SameText(CharsetActual, ACharset) or
     not SameText(CollationActual, ACollation) then
    FLXEjecutarSQL(AConnection,
      'ALTER TABLE `' + ATabla + '` CONVERT TO CHARACTER SET ' +
      ACharset + ' COLLATE ' + ACollation);
end;

procedure FLXAsegurarTablasTecladoProductos(
  AConnection: TZAbstractConnection; const ATienda: string);
var
  TablaArticulos, TablaGrupos, TablaProductos: string;
  MotorReferencia, CharsetReferencia, CollationReferencia: string;
  SufijoEstructura: string;
begin
  if not Assigned(AConnection) then
    raise Exception.Create(
      'No se ha recibido una conexión a la base de datos.');

  if not AConnection.Connected then
    raise Exception.Create(
      'La conexión a la base de datos no está activa.');

  TablaArticulos := 'artitien' + FLXTiendaSegura(ATienda);
  TablaGrupos := FLXTablaTecladoGrupos(ATienda);
  TablaProductos := FLXTablaTecladoProductos(ATienda);

  if not FLXLeerEstructuraTabla(AConnection, TablaArticulos,
    MotorReferencia, CharsetReferencia, CollationReferencia) then
    raise Exception.Create(
      'No se ha encontrado la tabla de artículos ' + TablaArticulos + '.');

  SufijoEstructura :=
    ' ENGINE=' + MotorReferencia +
    ' DEFAULT CHARSET=' + CharsetReferencia +
    ' COLLATE=' + CollationReferencia;

  if not FLXTablaExiste(AConnection, TablaGrupos) then
    FLXEjecutarSQL(AConnection,
      'CREATE TABLE `' + TablaGrupos + '` (' +
      'TG_ID INT NOT NULL AUTO_INCREMENT,' +
      'TG_NOMBRE VARCHAR(50) NOT NULL,' +
      'TG_ORDEN INT NOT NULL DEFAULT 0,' +
      'TG_COLOR BIGINT NOT NULL DEFAULT 0,' +
      'TG_ICONO VARCHAR(120) NOT NULL DEFAULT '''',' +
      'TG_ACTIVO CHAR(1) NOT NULL DEFAULT ''S'',' +
      'PRIMARY KEY (TG_ID),' +
      'UNIQUE KEY UK_TG_NOMBRE (TG_NOMBRE),' +
      'KEY IX_TG_ORDEN (TG_ORDEN)' +
      ')' + SufijoEstructura);

  if not FLXTablaExiste(AConnection, TablaProductos) then
    FLXEjecutarSQL(AConnection,
      'CREATE TABLE `' + TablaProductos + '` (' +
      'TP_ID INT NOT NULL AUTO_INCREMENT,' +
      'TP_GRUPO_ID INT NOT NULL,' +
      'TP_CODIGO VARCHAR(30) NOT NULL,' +
      'TP_TEXTO VARCHAR(60) NOT NULL DEFAULT '''',' +
      'TP_ORDEN INT NOT NULL DEFAULT 0,' +
      'TP_COLOR BIGINT NOT NULL DEFAULT 0,' +
      'TP_CANTIDAD DECIMAL(12,3) NOT NULL DEFAULT 1.000,' +
      'TP_ACTIVO CHAR(1) NOT NULL DEFAULT ''S'',' +
      'PRIMARY KEY (TP_ID),' +
      'UNIQUE KEY UK_TP_GRUPO_CODIGO (TP_GRUPO_ID,TP_CODIGO),' +
      'KEY IX_TP_GRUPO_ORDEN (TP_GRUPO_ID,TP_ORDEN),' +
      'KEY IX_TP_CODIGO (TP_CODIGO)' +
      ')' + SufijoEstructura);

  if not FLXColumnaExiste(AConnection, TablaGrupos, 'TG_ICONO') then
    FLXEjecutarSQL(AConnection,
      'ALTER TABLE `' + TablaGrupos + '` ADD COLUMN ' +
      'TG_ICONO VARCHAR(120) NOT NULL DEFAULT '''' AFTER TG_COLOR');

  FLXAjustarEstructuraTabla(AConnection, TablaGrupos,
    MotorReferencia, CharsetReferencia, CollationReferencia);
  FLXAjustarEstructuraTabla(AConnection, TablaProductos,
    MotorReferencia, CharsetReferencia, CollationReferencia);
end;


constructor TFLXSelectorArticulosForm.CreateSelector(
  AOwner: TComponent; AConnection: TZAbstractConnection;
  const ATienda: string);
var
  Superior, Inferior: TPanel;
  L: TLabel;
  B: TButton;
begin
  inherited CreateNew(AOwner, 1);

  FConnection := AConnection;
  FTienda := FLXTiendaSegura(ATienda);
  FCodigos := TStringList.Create;

  Caption := 'Buscar y añadir artículos';
  Position := poScreenCenter;
  BorderStyle := bsSizeable;
  Width := 920;
  Height := 620;
  Constraints.MinWidth := 920;
  Constraints.MinHeight := 480;
  Color := RGBToColor(239, 244, 248);

  Superior := TPanel.Create(Self);
  Superior.Parent := Self;
  Superior.Align := alTop;
  Superior.Height := 88;
  Superior.Caption := '';
  Superior.BevelOuter := bvNone;
  Superior.Color := RGBToColor(4, 58, 87);
  Superior.ParentBackground := False;
  Superior.ParentColor := False;

  L := TLabel.Create(Self);
  L.Parent := Superior;
  L.SetBounds(16, 9, 620, 24);
  L.Caption := 'Buscar por código, descripción o EAN';
  L.Font.Height := -16;
  L.Font.Style := [fsBold];
  L.Font.Color := clWhite;
  L.ParentFont := False;

  FEditFiltro := TEdit.Create(Self);
  FEditFiltro.Parent := Superior;
  FEditFiltro.SetBounds(16, 39, 660, 30);
  FEditFiltro.Font.Height := -13;
  FEditFiltro.ParentFont := False;
  FEditFiltro.OnKeyDown := @BuscarKeyDown;

  B := TButton.Create(Self);
  B.Parent := Superior;
  B.SetBounds(687, 38, 105, 32);
  B.Caption := 'Buscar';
  B.OnClick := @BuscarClick;
  B.Default := True;

  FInfo := TLabel.Create(Self);
  FInfo.Parent := Superior;
  FInfo.SetBounds(16, 70, 760, 16);
  FInfo.Caption := 'Búsqueda rápida por código, descripción o EAN. Máximo 250 resultados.';
  FInfo.Font.Height := -9;
  FInfo.Font.Color := RGBToColor(207, 227, 239);
  FInfo.ParentFont := False;

  Inferior := TPanel.Create(Self);
  Inferior.Parent := Self;
  Inferior.Align := alBottom;
  Inferior.Height := 62;
  Inferior.Caption := '';
  Inferior.BevelOuter := bvNone;

  B := TButton.Create(Self);
  B.Parent := Inferior;
  B.SetBounds(584, 12, 185, 38);
  B.Caption := 'Añadir seleccionados';
  B.OnClick := @AceptarClick;

  B := TButton.Create(Self);
  B.Parent := Inferior;
  B.SetBounds(779, 12, 115, 38);
  B.Caption := 'Cancelar';
  B.ModalResult := mrCancel;
  B.Cancel := True;

  FLista := TCheckListBox.Create(Self);
  FLista.Parent := Self;
  FLista.Align := alClient;
  FLista.BorderSpacing.Around := 10;
  FLista.Font.Height := -12;
  FLista.ParentFont := False;
  FLista.OnDblClick := @AceptarClick;

  ActiveControl := FEditFiltro;
end;

destructor TFLXSelectorArticulosForm.Destroy;
begin
  FreeAndNil(FCodigos);
  inherited Destroy;
end;

procedure TFLXSelectorArticulosForm.BuscarKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    EjecutarBusqueda;
    Key := 0;
  end;
end;

procedure TFLXSelectorArticulosForm.BuscarClick(Sender: TObject);
begin
  EjecutarBusqueda;
end;

procedure TFLXSelectorArticulosForm.EjecutarBusqueda;
var
  Q, QArticulo: TZQuery;
  CodigosVistos: TStringList;
  TextoBuscado, PatronCodigo, PatronDescripcion, PatronEAN: string;
  Codigo, EAN, Texto: string;
  I, Digitos: Integer;
  EsPosibleEAN: Boolean;

  procedure AnadirResultado(const ACodigo, ADescripcion: string;
    APVP: Double; const AEAN: string);
  begin
    Codigo := Trim(ACodigo);
    if Codigo = '' then
      Exit;

    if CodigosVistos.IndexOf(Codigo) >= 0 then
      Exit;

    CodigosVistos.Add(Codigo);

    Texto := Codigo + ' - ' + ADescripcion;
    if Trim(AEAN) <> '' then
      Texto := Texto + ' | EAN: ' + Trim(AEAN);
    Texto := Texto + ' | PVP: ' + FormatFloat('0.00', APVP);

    FLista.Items.Add(Texto);
    FCodigos.Add(Codigo);
  end;

begin
  TextoBuscado := Trim(FEditFiltro.Text);

  if Length(TextoBuscado) < 2 then
  begin
    FInfo.Caption :=
      'Escriba al menos 2 caracteres para buscar.';
    FEditFiltro.SetFocus;
    Exit;
  end;

  TextoBuscado := StringReplace(
    TextoBuscado, '*', '%', [rfReplaceAll]);

  if Pos('%', TextoBuscado) = 0 then
  begin
    // Código y EAN por comienzo para aprovechar sus índices.
    PatronCodigo := TextoBuscado + '%';
    PatronEAN := TextoBuscado + '%';

    // La descripción sí permite localizar palabras interiores.
    PatronDescripcion := '%' + TextoBuscado + '%';
  end
  else
  begin
    PatronCodigo := TextoBuscado;
    PatronDescripcion := TextoBuscado;
    PatronEAN := TextoBuscado;
  end;

  Digitos := 0;
  EsPosibleEAN := True;
  for I := 1 to Length(TextoBuscado) do
  begin
    if TextoBuscado[I] in ['0'..'9'] then
      Inc(Digitos)
    else if not (TextoBuscado[I] in [' ', '-', '.', '%']) then
      EsPosibleEAN := False;
  end;
  EsPosibleEAN := EsPosibleEAN and (Digitos >= 3);

  FEditFiltro.Enabled := False;
  FInfo.Caption := 'Buscando artículos...';
  Application.ProcessMessages;

  FLista.Items.BeginUpdate;
  CodigosVistos := TStringList.Create;
  Q := TZQuery.Create(nil);
  QArticulo := nil;
  try
    FLista.Clear;
    FCodigos.Clear;

    CodigosVistos.Sorted := True;
    CodigosVistos.Duplicates := dupIgnore;
    CodigosVistos.CaseSensitive := False;

    Q.Connection := FConnection;

    // Primera consulta: artículos por código o descripción.
    // Se evita consultar EAN por cada artículo, que era el origen del bloqueo.
    Q.SQL.Text :=
      'SELECT A0,A1,A2 FROM `artitien' + FTienda + '` ' +
      'WHERE A0 LIKE :PC OR A1 LIKE :PD LIMIT 250';
    Q.ParamByName('PC').AsString := PatronCodigo;
    Q.ParamByName('PD').AsString := PatronDescripcion;
    Q.Open;

    while not Q.EOF do
    begin
      AnadirResultado(
        Q.FieldByName('A0').AsString,
        Q.FieldByName('A1').AsString,
        Q.FieldByName('A2').AsFloat,
        '');
      Q.Next;
    end;
    Q.Close;

    // Segunda consulta, únicamente cuando el texto puede ser un EAN.
    // Primero se localiza el código en eans y después se consulta el artículo
    // por su código exacto, evitando JOIN y subconsultas correlacionadas.
    if EsPosibleEAN and (FLista.Items.Count < 250) then
    begin
      QArticulo := TZQuery.Create(nil);
      QArticulo.Connection := FConnection;
      QArticulo.SQL.Text :=
        'SELECT A0,A1,A2 FROM `artitien' + FTienda + '` ' +
        'WHERE A0=:C LIMIT 1';

      Q.SQL.Text :=
        'SELECT EAN0,EAN1 FROM eans ' +
        'WHERE EAN0 LIKE :PE LIMIT 250';
      Q.ParamByName('PE').AsString := PatronEAN;
      Q.Open;

      I := 0;
      while not Q.EOF and (FLista.Items.Count < 250) do
      begin
        Codigo := Trim(Q.FieldByName('EAN1').AsString);
        EAN := Trim(Q.FieldByName('EAN0').AsString);

        if (Codigo <> '') and
           (CodigosVistos.IndexOf(Codigo) < 0) then
        begin
          QArticulo.Close;
          QArticulo.ParamByName('C').AsString := Codigo;
          QArticulo.Open;

          if not QArticulo.IsEmpty then
            AnadirResultado(
              QArticulo.FieldByName('A0').AsString,
              QArticulo.FieldByName('A1').AsString,
              QArticulo.FieldByName('A2').AsFloat,
              EAN);
        end;

        Inc(I);
        if (I mod 25) = 0 then
          Application.ProcessMessages;

        Q.Next;
      end;
    end;
  finally
    QArticulo.Free;
    Q.Free;
    CodigosVistos.Free;
    FLista.Items.EndUpdate;
    FEditFiltro.Enabled := True;
  end;

  FInfo.Caption := Format(
    'Resultados: %d (máximo 250). Marque los artículos que desea añadir.',
    [FLista.Items.Count]);

  if FLista.Items.Count > 0 then
  begin
    FLista.ItemIndex := 0;
    FLista.SetFocus;
  end
  else
    FEditFiltro.SetFocus;
end;

procedure TFLXSelectorArticulosForm.AceptarClick(Sender: TObject);
var
  I, Seleccionados: Integer;
begin
  Seleccionados := 0;
  for I := 0 to FLista.Items.Count - 1 do
    if FLista.Checked[I] then
      Inc(Seleccionados);

  if (Seleccionados = 0) and (FLista.ItemIndex >= 0) then
  begin
    FLista.Checked[FLista.ItemIndex] := True;
    Seleccionados := 1;
  end;

  if Seleccionados = 0 then
  begin
    MessageDlg('Seleccione al menos un artículo.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  ModalResult := mrOk;
end;

procedure TFLXSelectorArticulosForm.CopiarCodigosSeleccionados(
  ADestino: TStrings);
var
  I: Integer;
begin
  if not Assigned(ADestino) then
    Exit;

  for I := 0 to FLista.Items.Count - 1 do
    if FLista.Checked[I] and (I < FCodigos.Count) then
      ADestino.Add(FCodigos[I]);
end;

constructor TFLXConfigTecladoProductosForm.CreateConfig(
  AOwner: TComponent; AConnection: TZAbstractConnection;
  const ATienda: string);
var
  Cabecera, Izquierda, Derecha, AvisoSeleccion: TPanel;
  BotonesGrupos, BotonesProductos: TPanel;
  L: TLabel;
  B: TButton;

  function NuevoBoton(AParent: TWinControl;
    const ACaption: string; AX, AY, AW, AH: Integer;
    AEvento: TNotifyEvent): TButton;
  begin
    Result := TButton.Create(Self);
    Result.Parent := AParent;
    Result.SetBounds(AX, AY, AW, AH);
    Result.Caption := ACaption;
    Result.OnClick := AEvento;
  end;

begin
  inherited CreateNew(AOwner, 1);

  FConnection := AConnection;
  FTienda := FLXTiendaSegura(ATienda);

  Caption := 'Configurar teclado de productos - V1 FIX18';
  Position := poScreenCenter;
  BorderStyle := bsSizeable;
  Width := 1040;
  Height := 650;
  Constraints.MinWidth := 900;
  Constraints.MinHeight := 560;
  Color := RGBToColor(239, 244, 248);

  Cabecera := TPanel.Create(Self);
  Cabecera.Parent := Self;
  Cabecera.Align := alTop;
  Cabecera.Height := 58;
  Cabecera.Caption := '';
  Cabecera.BevelOuter := bvNone;
  Cabecera.Color := RGBToColor(4, 58, 87);
  Cabecera.ParentBackground := False;
  Cabecera.ParentColor := False;

  L := TLabel.Create(Self);
  L.Parent := Cabecera;
  L.Left := 18;
  L.Top := 9;
  L.Caption := 'Teclado de productos';
  L.Font.Name := 'Sans';
  L.Font.Height := -19;
  L.Font.Style := [fsBold];
  L.Font.Color := clWhite;
  L.ParentFont := False;

  L := TLabel.Create(Self);
  L.Parent := Cabecera;
  L.Left := 19;
  L.Top := 36;
  L.Caption := 'V1 FIX17 · búsqueda por código, descripción o EAN · selección mediante casillas';
  L.Font.Name := 'Sans';
  L.Font.Height := -10;
  L.Font.Color := RGBToColor(207, 227, 239);
  L.ParentFont := False;

  Izquierda := TPanel.Create(Self);
  Izquierda.Parent := Self;
  Izquierda.Align := alLeft;
  Izquierda.Width := 315;
  Izquierda.Caption := '';
  Izquierda.BevelOuter := bvNone;
  Izquierda.BorderSpacing.Around := 10;

  L := TLabel.Create(Self);
  L.Parent := Izquierda;
  L.Align := alTop;
  L.Height := 30;
  L.Caption := '  GRUPOS / PÁGINAS';
  L.Layout := tlCenter;
  L.Font.Style := [fsBold];
  L.ParentFont := False;

  BotonesGrupos := TPanel.Create(Self);
  BotonesGrupos.Parent := Izquierda;
  BotonesGrupos.Align := alBottom;
  BotonesGrupos.Height := 174;
  BotonesGrupos.Caption := '';
  BotonesGrupos.BevelOuter := bvNone;

  FListaGrupos := TListBox.Create(Self);
  FListaGrupos.Parent := Izquierda;
  FListaGrupos.Align := alClient;
  FListaGrupos.Font.Height := -13;
  FListaGrupos.ParentFont := False;
  FListaGrupos.OnClick := @GrupoClick;

  NuevoBoton(BotonesGrupos, 'Nuevo grupo', 4, 5, 145, 32,
    @AgregarGrupoClick);
  NuevoBoton(BotonesGrupos, 'Renombrar', 155, 5, 145, 32,
    @RenombrarGrupoClick);
  NuevoBoton(BotonesGrupos, 'Eliminar', 4, 43, 145, 32,
    @EliminarGrupoClick);
  NuevoBoton(BotonesGrupos, 'Subir', 155, 43, 70, 32,
    @SubirGrupoClick);
  NuevoBoton(BotonesGrupos, 'Bajar', 230, 43, 70, 32,
    @BajarGrupoClick);

  NuevoBoton(BotonesGrupos, 'Icono...', 4, 81, 145, 32,
    @AsignarIconoGrupoClick);
  NuevoBoton(BotonesGrupos, 'Sin icono', 155, 81, 145, 32,
    @QuitarIconoGrupoClick);

  L := TLabel.Create(Self);
  L.Parent := BotonesGrupos;
  L.SetBounds(6, 122, 292, 42);
  L.AutoSize := False;
  L.WordWrap := True;
  L.Caption := 'La imagen se guarda como fichero, no dentro de MariaDB.';
  L.Font.Height := -10;
  L.ParentFont := False;

  Derecha := TPanel.Create(Self);
  Derecha.Parent := Self;
  Derecha.Align := alClient;
  Derecha.Caption := '';
  Derecha.BevelOuter := bvNone;
  Derecha.BorderSpacing.Around := 10;

  L := TLabel.Create(Self);
  L.Parent := Derecha;
  L.Align := alTop;
  L.Height := 30;
  L.Caption := '  PRODUCTOS DEL GRUPO';
  L.Layout := tlCenter;
  L.Font.Style := [fsBold];
  L.ParentFont := False;

  AvisoSeleccion := TPanel.Create(Self);
  AvisoSeleccion.Parent := Derecha;
  AvisoSeleccion.Align := alTop;
  AvisoSeleccion.Height := 34;
  AvisoSeleccion.Caption :=
    'MARQUE LAS CASILLAS para activar, desactivar o eliminar varios artículos';
  AvisoSeleccion.BevelOuter := bvNone;
  AvisoSeleccion.Color := RGBToColor(214, 239, 230);
  AvisoSeleccion.Font.Style := [fsBold];
  AvisoSeleccion.Font.Color := RGBToColor(24, 93, 66);
  AvisoSeleccion.ParentFont := False;
  AvisoSeleccion.ParentBackground := False;
  AvisoSeleccion.ParentColor := False;

  BotonesProductos := TPanel.Create(Self);
  BotonesProductos.Parent := Derecha;
  BotonesProductos.Align := alBottom;
  BotonesProductos.Height := 132;
  BotonesProductos.Caption := '';
  BotonesProductos.BevelOuter := bvNone;

  FListaProductos := TCheckListBox.Create(Self);
  FListaProductos.Parent := Derecha;
  FListaProductos.Align := alClient;
  FListaProductos.Font.Height := -12;
  FListaProductos.ParentFont := False;

  NuevoBoton(BotonesProductos, 'Buscar por descripción / EAN', 4, 5, 145, 32,
    @AgregarProductoClick);
  NuevoBoton(BotonesProductos, 'Cargar familia', 155, 5, 145, 32,
    @AgregarFamiliaClick);
  NuevoBoton(BotonesProductos, 'Editar', 306, 5, 105, 32,
    @EditarProductoClick);
  NuevoBoton(BotonesProductos, 'Activar marcados',
    417, 5, 128, 32, @ActivarProductoClick);
  NuevoBoton(BotonesProductos, 'Desactivar marcados',
    551, 5, 128, 32, @DesactivarProductoClick);

  NuevoBoton(BotonesProductos, 'Eliminar marcados', 4, 43, 145, 32,
    @EliminarProductoClick);
  NuevoBoton(BotonesProductos, 'Subir', 155, 43, 70, 32,
    @SubirProductoClick);
  NuevoBoton(BotonesProductos, 'Bajar', 230, 43, 70, 32,
    @BajarProductoClick);
  NuevoBoton(BotonesProductos, 'Marcar todos', 306, 43, 130, 32,
    @SeleccionarTodosProductosClick);
  NuevoBoton(BotonesProductos, 'Desmarcar todos', 442, 43, 137, 32,
    @LimpiarSeleccionProductosClick);

  B := NuevoBoton(BotonesProductos, 'Cerrar', 467, 84, 115, 38,
    @CerrarClick);
  B.Default := True;

  L := TLabel.Create(Self);
  L.Parent := BotonesProductos;
  L.SetBounds(6, 84, 445, 42);
  L.AutoSize := False;
  L.WordWrap := True;
  L.Caption := 'Marque las casillas. Editar, Subir y Bajar actúan sobre la fila actualmente resaltada.';
  L.Font.Height := -10;
  L.ParentFont := False;

  FLXAsegurarTablasTecladoProductos(FConnection, FTienda);
  RefrescarGrupos;
end;

function TFLXConfigTecladoProductosForm.NuevoQuery: TZQuery;
begin
  Result := TZQuery.Create(nil);
  Result.Connection := FConnection;
end;

function TFLXConfigTecladoProductosForm.GrupoActualID: Integer;
begin
  Result := 0;
  if FListaGrupos.ItemIndex >= 0 then
    Result := PtrInt(
      FListaGrupos.Items.Objects[FListaGrupos.ItemIndex]);
end;

function TFLXConfigTecladoProductosForm.ProductoActualID: Integer;
begin
  Result := 0;
  if FListaProductos.ItemIndex >= 0 then
    Result := PtrInt(
      FListaProductos.Items.Objects[FListaProductos.ItemIndex]);
end;

function TFLXConfigTecladoProductosForm.ContarProductosSeleccionados: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FListaProductos.Items.Count - 1 do
    if FListaProductos.Checked[I] then
      Inc(Result);

  if (Result = 0) and (FListaProductos.ItemIndex >= 0) then
    Result := 1;
end;

procedure TFLXConfigTecladoProductosForm.EstablecerActivoSeleccionados(
  const AActivo: string);
var
  I: Integer;
  HaySeleccionExplicita: Boolean;
  Q: TZQuery;
begin
  HaySeleccionExplicita := False;
  for I := 0 to FListaProductos.Items.Count - 1 do
    if FListaProductos.Checked[I] then
    begin
      HaySeleccionExplicita := True;
      Break;
    end;

  if not HaySeleccionExplicita and (FListaProductos.ItemIndex >= 0) then
    FListaProductos.Checked[FListaProductos.ItemIndex] := True;

  if ContarProductosSeleccionados = 0 then
    Exit;

  Q := NuevoQuery;
  try
    Q.SQL.Text :=
      'UPDATE `' + FLXTablaTecladoProductos(FTienda) +
      '` SET TP_ACTIVO=:A WHERE TP_ID=:ID';

    for I := 0 to FListaProductos.Items.Count - 1 do
      if FListaProductos.Checked[I] then
      begin
        Q.ParamByName('A').AsString := AActivo;
        Q.ParamByName('ID').AsInteger := PtrInt(
          FListaProductos.Items.Objects[I]);
        Q.ExecSQL;
      end;
  finally
    Q.Free;
  end;

  RefrescarProductos;
end;

procedure TFLXConfigTecladoProductosForm.SeleccionarID(
  ALista: TCustomListBox; AID: Integer);
var
  I: Integer;
begin
  if AID <= 0 then
    Exit;

  for I := 0 to ALista.Items.Count - 1 do
    if PtrInt(ALista.Items.Objects[I]) = AID then
    begin
      ALista.ItemIndex := I;
      Exit;
    end;
end;

procedure TFLXConfigTecladoProductosForm.RefrescarGrupos(
  ASeleccionarID: Integer);
var
  Q: TZQuery;
  IDAnterior: Integer;
begin
  IDAnterior := ASeleccionarID;
  if IDAnterior = 0 then
    IDAnterior := GrupoActualID;

  FListaGrupos.Items.BeginUpdate;
  try
    FListaGrupos.Clear;
    Q := NuevoQuery;
    try
      Q.SQL.Text :=
        'SELECT TG_ID,TG_NOMBRE,TG_ICONO FROM `' +
        FLXTablaTecladoGrupos(FTienda) +
        '` ORDER BY TG_ORDEN,TG_ID';
      Q.Open;
      while not Q.EOF do
      begin
        if Trim(Q.FieldByName('TG_ICONO').AsString) = '-' then
          FListaGrupos.Items.AddObject(
            Q.FieldByName('TG_NOMBRE').AsString + '  [sin icono]',
            TObject(PtrUInt(Q.FieldByName('TG_ID').AsInteger)))
        else if Trim(Q.FieldByName('TG_ICONO').AsString) <> '' then
          FListaGrupos.Items.AddObject(
            Q.FieldByName('TG_NOMBRE').AsString + '  [' +
            Q.FieldByName('TG_ICONO').AsString + ']',
            TObject(PtrUInt(Q.FieldByName('TG_ID').AsInteger)))
        else if FLXIconoPredeterminadoGrupo(
          Q.FieldByName('TG_NOMBRE').AsString) <> '' then
          FListaGrupos.Items.AddObject(
            Q.FieldByName('TG_NOMBRE').AsString + '  [automático]',
            TObject(PtrUInt(Q.FieldByName('TG_ID').AsInteger)))
        else
          FListaGrupos.Items.AddObject(
            Q.FieldByName('TG_NOMBRE').AsString,
            TObject(PtrUInt(Q.FieldByName('TG_ID').AsInteger)));
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  finally
    FListaGrupos.Items.EndUpdate;
  end;

  if FListaGrupos.Items.Count > 0 then
  begin
    FListaGrupos.ItemIndex := 0;
    SeleccionarID(FListaGrupos, IDAnterior);
  end;

  RefrescarProductos;
end;

procedure TFLXConfigTecladoProductosForm.RefrescarProductos(
  ASeleccionarID: Integer);
var
  Q: TZQuery;
  IDAnterior, GrupoID: Integer;
  Marca, Texto: string;
begin
  IDAnterior := ASeleccionarID;
  if IDAnterior = 0 then
    IDAnterior := ProductoActualID;

  GrupoID := GrupoActualID;
  FListaProductos.Items.BeginUpdate;
  try
    FListaProductos.Clear;
    if GrupoID = 0 then
      Exit;

    Q := NuevoQuery;
    try
      Q.SQL.Text :=
        'SELECT p.TP_ID,p.TP_CODIGO,p.TP_TEXTO,' +
        'p.TP_CANTIDAD,p.TP_ACTIVO,a.A1 FROM `' +
        FLXTablaTecladoProductos(FTienda) + '` p ' +
        'LEFT JOIN `artitien' + FTienda +
        '` a ON a.A0=p.TP_CODIGO ' +
        'WHERE p.TP_GRUPO_ID=:G ' +
        'ORDER BY p.TP_ORDEN,p.TP_ID';
      Q.ParamByName('G').AsInteger := GrupoID;
      Q.Open;

      while not Q.EOF do
      begin
        if SameText(Q.FieldByName('TP_ACTIVO').AsString, 'S') then
          Marca := '[X] '
        else
          Marca := '[ ] ';

        Texto := Trim(Q.FieldByName('TP_TEXTO').AsString);
        if Texto = '' then
          Texto := Trim(Q.FieldByName('A1').AsString);
        if Texto = '' then
          Texto := '(artículo no encontrado)';

        FListaProductos.Items.AddObject(
          Marca + Q.FieldByName('TP_CODIGO').AsString +
          ' - ' + Texto + ' | Cant.: ' +
          FormatFloat('0.###',
            Q.FieldByName('TP_CANTIDAD').AsFloat),
          TObject(PtrUInt(Q.FieldByName('TP_ID').AsInteger)));
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  finally
    FListaProductos.Items.EndUpdate;
  end;

  if FListaProductos.Items.Count > 0 then
  begin
    FListaProductos.ItemIndex := 0;
    SeleccionarID(FListaProductos, IDAnterior);
  end;
end;

procedure TFLXConfigTecladoProductosForm.GrupoClick(Sender: TObject);
begin
  RefrescarProductos;
end;

procedure TFLXConfigTecladoProductosForm.AsignarIconoGrupoClick(
  Sender: TObject);
var
  ID: Integer;
  Dialogo: TOpenDialog;
  NombreIcono, RutaDestino: string;
  Q: TZQuery;
begin
  ID := GrupoActualID;
  if ID = 0 then
    Exit;

  Dialogo := TOpenDialog.Create(Self);
  try
    Dialogo.Title := 'Seleccionar icono del grupo';
    Dialogo.InitialDir := FLXRutaInicialSelectorIconos;
    Dialogo.Filter :=
      'Imágenes|*.png;*.jpg;*.jpeg;*.bmp|' +
      'PNG|*.png|JPEG|*.jpg;*.jpeg|Bitmap|*.bmp|Todos|*.*';

    if not Dialogo.Execute then
      Exit;

    NombreIcono := ExtractFileName(Dialogo.FileName);
    RutaDestino := FLXRutaIconosTeclado + NombreIcono;

    try
      FLXCopiarFichero(Dialogo.FileName, RutaDestino);
    except
      on E: Exception do
      begin
        MessageDlg('No se ha podido copiar el icono.' +
          LineEnding + E.Message, mtError, [mbOK], 0);
        Exit;
      end;
    end;

    Q := NuevoQuery;
    try
      Q.SQL.Text :=
        'UPDATE `' + FLXTablaTecladoGrupos(FTienda) +
        '` SET TG_ICONO=:I WHERE TG_ID=:ID';
      Q.ParamByName('I').AsString := NombreIcono;
      Q.ParamByName('ID').AsInteger := ID;
      Q.ExecSQL;
    finally
      Q.Free;
    end;

    RefrescarGrupos(ID);
  finally
    Dialogo.Free;
  end;
end;

procedure TFLXConfigTecladoProductosForm.QuitarIconoGrupoClick(
  Sender: TObject);
var
  ID: Integer;
  Q: TZQuery;
begin
  ID := GrupoActualID;
  if ID = 0 then
    Exit;

  Q := NuevoQuery;
  try
    Q.SQL.Text :=
      'UPDATE `' + FLXTablaTecladoGrupos(FTienda) +
      '` SET TG_ICONO=''-'' WHERE TG_ID=:ID';
    Q.ParamByName('ID').AsInteger := ID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;

  RefrescarGrupos(ID);
end;

procedure TFLXConfigTecladoProductosForm.AgregarGrupoClick(
  Sender: TObject);
var
  Nombre: string;
  Q: TZQuery;
begin
  Nombre := '';
  if not InputQuery('Nuevo grupo', 'Nombre del grupo:', Nombre) then
    Exit;

  Nombre := Trim(Nombre);
  if Nombre = '' then
    Exit;

  Q := NuevoQuery;
  try
    Q.SQL.Text :=
      'INSERT INTO `' + FLXTablaTecladoGrupos(FTienda) +
      '` (TG_NOMBRE,TG_ORDEN,TG_COLOR,TG_ICONO,TG_ACTIVO) ' +
      'SELECT :N,COALESCE(MAX(TG_ORDEN),0)+10,0,:I,''S'' FROM `' +
      FLXTablaTecladoGrupos(FTienda) + '`';
    Q.ParamByName('N').AsString := Nombre;
    Q.ParamByName('I').AsString :=
      FLXIconoPredeterminadoGrupo(Nombre);
    try
      Q.ExecSQL;
    except
      on E: Exception do
        MessageDlg('No se ha podido crear el grupo.' +
          LineEnding + E.Message, mtError, [mbOK], 0);
    end;
  finally
    Q.Free;
  end;

  RefrescarGrupos;
end;

procedure TFLXConfigTecladoProductosForm.RenombrarGrupoClick(
  Sender: TObject);
var
  ID: Integer;
  Nombre: string;
  Q: TZQuery;
begin
  ID := GrupoActualID;
  if ID = 0 then
    Exit;

  Q := NuevoQuery;
  try
    Q.SQL.Text :=
      'SELECT TG_NOMBRE FROM `' + FLXTablaTecladoGrupos(FTienda) +
      '` WHERE TG_ID=:ID';
    Q.ParamByName('ID').AsInteger := ID;
    Q.Open;
    if Q.IsEmpty then
      Exit;
    Nombre := Q.FieldByName('TG_NOMBRE').AsString;
    Q.Close;
  finally
    Q.Free;
  end;

  if not InputQuery('Renombrar grupo', 'Nuevo nombre:', Nombre) then
    Exit;

  Nombre := Trim(Nombre);
  if Nombre = '' then
    Exit;

  Q := NuevoQuery;
  try
    Q.SQL.Text :=
      'UPDATE `' + FLXTablaTecladoGrupos(FTienda) +
      '` SET TG_NOMBRE=:N,' +
      'TG_ICONO=IF(TG_ICONO='''',:I,TG_ICONO) WHERE TG_ID=:ID';
    Q.ParamByName('N').AsString := Nombre;
    Q.ParamByName('I').AsString :=
      FLXIconoPredeterminadoGrupo(Nombre);
    Q.ParamByName('ID').AsInteger := ID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;

  RefrescarGrupos(ID);
end;

procedure TFLXConfigTecladoProductosForm.EliminarGrupoClick(
  Sender: TObject);
var
  ID: Integer;
  Q: TZQuery;
begin
  ID := GrupoActualID;
  if ID = 0 then
    Exit;

  if MessageDlg('Eliminar grupo',
    'Se eliminará el grupo y sus botones.' + LineEnding +
    'Los artículos de la base de datos no se eliminarán.',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  Q := NuevoQuery;
  try
    Q.SQL.Text :=
      'DELETE FROM `' + FLXTablaTecladoProductos(FTienda) +
      '` WHERE TP_GRUPO_ID=:G';
    Q.ParamByName('G').AsInteger := ID;
    Q.ExecSQL;

    Q.SQL.Text :=
      'DELETE FROM `' + FLXTablaTecladoGrupos(FTienda) +
      '` WHERE TG_ID=:G';
    Q.ParamByName('G').AsInteger := ID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;

  RefrescarGrupos;
end;

procedure TFLXConfigTecladoProductosForm.IntercambiarOrden(
  const ATabla, ACampoID, ACampoOrden: string;
  AID1, AID2: Integer);
var
  Q: TZQuery;
  Orden1, Orden2: Integer;
begin
  if (AID1 = 0) or (AID2 = 0) then
    Exit;

  Q := NuevoQuery;
  try
    Q.SQL.Text :=
      'SELECT `' + ACampoID + '`,`' + ACampoOrden +
      '` FROM `' + ATabla + '` WHERE `' + ACampoID +
      '` IN (:A,:B)';
    Q.ParamByName('A').AsInteger := AID1;
    Q.ParamByName('B').AsInteger := AID2;
    Q.Open;

    Orden1 := 0;
    Orden2 := 0;
    while not Q.EOF do
    begin
      if Q.FieldByName(ACampoID).AsInteger = AID1 then
        Orden1 := Q.FieldByName(ACampoOrden).AsInteger
      else
        Orden2 := Q.FieldByName(ACampoOrden).AsInteger;
      Q.Next;
    end;
    Q.Close;

    Q.SQL.Text :=
      'UPDATE `' + ATabla + '` SET `' + ACampoOrden +
      '`=:O WHERE `' + ACampoID + '`=:ID';
    Q.ParamByName('O').AsInteger := Orden2;
    Q.ParamByName('ID').AsInteger := AID1;
    Q.ExecSQL;

    Q.ParamByName('O').AsInteger := Orden1;
    Q.ParamByName('ID').AsInteger := AID2;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TFLXConfigTecladoProductosForm.SubirGrupoClick(
  Sender: TObject);
var
  I, ID1, ID2: Integer;
begin
  I := FListaGrupos.ItemIndex;
  if I <= 0 then
    Exit;

  ID1 := PtrInt(FListaGrupos.Items.Objects[I]);
  ID2 := PtrInt(FListaGrupos.Items.Objects[I - 1]);
  IntercambiarOrden(FLXTablaTecladoGrupos(FTienda),
    'TG_ID', 'TG_ORDEN', ID1, ID2);
  RefrescarGrupos(ID1);
end;

procedure TFLXConfigTecladoProductosForm.BajarGrupoClick(
  Sender: TObject);
var
  I, ID1, ID2: Integer;
begin
  I := FListaGrupos.ItemIndex;
  if (I < 0) or (I >= FListaGrupos.Items.Count - 1) then
    Exit;

  ID1 := PtrInt(FListaGrupos.Items.Objects[I]);
  ID2 := PtrInt(FListaGrupos.Items.Objects[I + 1]);
  IntercambiarOrden(FLXTablaTecladoGrupos(FTienda),
    'TG_ID', 'TG_ORDEN', ID1, ID2);
  RefrescarGrupos(ID1);
end;

procedure TFLXConfigTecladoProductosForm.AgregarProductoClick(
  Sender: TObject);
var
  GrupoID, Orden, I: Integer;
  Selector: TFLXSelectorArticulosForm;
  Codigos: TStringList;
  QArt, QIns, QMax: TZQuery;
begin
  GrupoID := GrupoActualID;
  if GrupoID = 0 then
  begin
    MessageDlg('Primero debe crear o seleccionar un grupo.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  Selector := TFLXSelectorArticulosForm.CreateSelector(
    Self, FConnection, FTienda);
  Codigos := TStringList.Create;
  try
    if Selector.ShowModal <> mrOk then
      Exit;

    Selector.CopiarCodigosSeleccionados(Codigos);
    if Codigos.Count = 0 then
      Exit;

    QArt := NuevoQuery;
    QIns := NuevoQuery;
    QMax := NuevoQuery;
    try
      QMax.SQL.Text :=
        'SELECT COALESCE(MAX(TP_ORDEN),0) AS O FROM `' +
        FLXTablaTecladoProductos(FTienda) +
        '` WHERE TP_GRUPO_ID=:G';
      QMax.ParamByName('G').AsInteger := GrupoID;
      QMax.Open;
      Orden := QMax.FieldByName('O').AsInteger;
      QMax.Close;

      QArt.SQL.Text :=
        'SELECT A0,A1 FROM `artitien' + FTienda +
        '` WHERE A0=:C LIMIT 1';

      QIns.SQL.Text :=
        'INSERT IGNORE INTO `' +
        FLXTablaTecladoProductos(FTienda) +
        '` (TP_GRUPO_ID,TP_CODIGO,TP_TEXTO,TP_ORDEN,' +
        'TP_COLOR,TP_CANTIDAD,TP_ACTIVO) ' +
        'VALUES (:G,:C,:T,:O,0,1,''S'')';

      for I := 0 to Codigos.Count - 1 do
      begin
        QArt.ParamByName('C').AsString := Codigos[I];
        QArt.Open;
        if not QArt.IsEmpty then
        begin
          Inc(Orden, 10);
          QIns.ParamByName('G').AsInteger := GrupoID;
          QIns.ParamByName('C').AsString :=
            QArt.FieldByName('A0').AsString;
          QIns.ParamByName('T').AsString := Copy(
            QArt.FieldByName('A1').AsString, 1, 60);
          QIns.ParamByName('O').AsInteger := Orden;
          QIns.ExecSQL;
        end;
        QArt.Close;
      end;
    finally
      QMax.Free;
      QIns.Free;
      QArt.Free;
    end;
  finally
    Codigos.Free;
    Selector.Free;
  end;

  RefrescarProductos;
end;

procedure TFLXConfigTecladoProductosForm.AgregarFamiliaClick(
  Sender: TObject);
var
  GrupoID, Orden: Integer;
  Familia: string;
  QArt, QIns, QMax: TZQuery;
begin
  GrupoID := GrupoActualID;
  if GrupoID = 0 then
  begin
    MessageDlg('Primero debe crear o seleccionar un grupo.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  Familia := '';
  if not InputQuery('Cargar familia',
    'Código de la familia:', Familia) then
    Exit;

  Familia := Trim(Familia);
  if Familia = '' then
    Exit;

  QArt := NuevoQuery;
  QIns := NuevoQuery;
  QMax := NuevoQuery;
  try
    QMax.SQL.Text :=
      'SELECT COALESCE(MAX(TP_ORDEN),0) AS O FROM `' +
      FLXTablaTecladoProductos(FTienda) +
      '` WHERE TP_GRUPO_ID=:G';
    QMax.ParamByName('G').AsInteger := GrupoID;
    QMax.Open;
    Orden := QMax.FieldByName('O').AsInteger;
    QMax.Close;

    QArt.SQL.Text :=
      'SELECT A0,A1 FROM `artitien' + FTienda +
      '` WHERE A14=:F ORDER BY A1,A0';
    QArt.ParamByName('F').AsString := Familia;
    QArt.Open;

    if QArt.IsEmpty then
    begin
      MessageDlg('No se han encontrado artículos en esa familia.',
        mtInformation, [mbOK], 0);
      Exit;
    end;

    QIns.SQL.Text :=
      'INSERT IGNORE INTO `' +
      FLXTablaTecladoProductos(FTienda) +
      '` (TP_GRUPO_ID,TP_CODIGO,TP_TEXTO,TP_ORDEN,' +
      'TP_COLOR,TP_CANTIDAD,TP_ACTIVO) ' +
      'VALUES (:G,:C,:T,:O,0,1,''S'')';

    while not QArt.EOF do
    begin
      Inc(Orden, 10);
      QIns.ParamByName('G').AsInteger := GrupoID;
      QIns.ParamByName('C').AsString :=
        QArt.FieldByName('A0').AsString;
      QIns.ParamByName('T').AsString := Copy(
        QArt.FieldByName('A1').AsString, 1, 60);
      QIns.ParamByName('O').AsInteger := Orden;
      QIns.ExecSQL;
      QArt.Next;
    end;
  finally
    QMax.Free;
    QIns.Free;
    QArt.Free;
  end;

  RefrescarProductos;
end;

procedure TFLXConfigTecladoProductosForm.EditarProductoClick(
  Sender: TObject);
var
  ID: Integer;
  Texto, CantidadTexto: string;
  Cantidad: Double;
  Q: TZQuery;
begin
  ID := ProductoActualID;
  if ID = 0 then
    Exit;

  Q := NuevoQuery;
  try
    Q.SQL.Text :=
      'SELECT TP_TEXTO,TP_CANTIDAD FROM `' +
      FLXTablaTecladoProductos(FTienda) +
      '` WHERE TP_ID=:ID';
    Q.ParamByName('ID').AsInteger := ID;
    Q.Open;

    if Q.IsEmpty then
      Exit;

    Texto := Q.FieldByName('TP_TEXTO').AsString;
    CantidadTexto := FormatFloat('0.###',
      Q.FieldByName('TP_CANTIDAD').AsFloat);
    Q.Close;

    if not InputQuery('Editar botón',
      'Texto que aparecerá:', Texto) then
      Exit;

    if not InputQuery('Editar cantidad',
      'Cantidad predeterminada:', CantidadTexto) then
      Exit;

    if not TryStrToFloat(CantidadTexto, Cantidad) or
       (Cantidad <= 0) then
    begin
      MessageDlg('La cantidad introducida no es válida.',
        mtWarning, [mbOK], 0);
      Exit;
    end;

    Q.SQL.Text :=
      'UPDATE `' + FLXTablaTecladoProductos(FTienda) +
      '` SET TP_TEXTO=:T,TP_CANTIDAD=:Q WHERE TP_ID=:ID';
    Q.ParamByName('T').AsString := Copy(Trim(Texto), 1, 60);
    Q.ParamByName('Q').AsFloat := Cantidad;
    Q.ParamByName('ID').AsInteger := ID;
    Q.ExecSQL;
  finally
    Q.Free;
  end;

  RefrescarProductos(ID);
end;

procedure TFLXConfigTecladoProductosForm.ActivarProductoClick(
  Sender: TObject);
begin
  EstablecerActivoSeleccionados('S');
end;

procedure TFLXConfigTecladoProductosForm.DesactivarProductoClick(
  Sender: TObject);
begin
  EstablecerActivoSeleccionados('N');
end;

procedure TFLXConfigTecladoProductosForm.SeleccionarTodosProductosClick(
  Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to FListaProductos.Items.Count - 1 do
    FListaProductos.Checked[I] := True;
end;

procedure TFLXConfigTecladoProductosForm.LimpiarSeleccionProductosClick(
  Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to FListaProductos.Items.Count - 1 do
    FListaProductos.Checked[I] := False;
end;

procedure TFLXConfigTecladoProductosForm.EliminarProductoClick(
  Sender: TObject);
var
  I, Cantidad: Integer;
  HaySeleccionExplicita: Boolean;
  Q: TZQuery;
begin
  HaySeleccionExplicita := False;
  for I := 0 to FListaProductos.Items.Count - 1 do
    if FListaProductos.Checked[I] then
    begin
      HaySeleccionExplicita := True;
      Break;
    end;

  if not HaySeleccionExplicita and (FListaProductos.ItemIndex >= 0) then
    FListaProductos.Checked[FListaProductos.ItemIndex] := True;

  Cantidad := ContarProductosSeleccionados;
  if Cantidad = 0 then
    Exit;

  if MessageDlg('Eliminar botones',
    Format('Se eliminarán %d botones del teclado.', [Cantidad]) +
    LineEnding + 'Los artículos seguirán existiendo en la base de datos.',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  Q := NuevoQuery;
  try
    Q.SQL.Text :=
      'DELETE FROM `' + FLXTablaTecladoProductos(FTienda) +
      '` WHERE TP_ID=:ID';

    for I := 0 to FListaProductos.Items.Count - 1 do
      if FListaProductos.Checked[I] then
      begin
        Q.ParamByName('ID').AsInteger := PtrInt(
          FListaProductos.Items.Objects[I]);
        Q.ExecSQL;
      end;
  finally
    Q.Free;
  end;

  RefrescarProductos;
end;

procedure TFLXConfigTecladoProductosForm.SubirProductoClick(
  Sender: TObject);
var
  I, ID1, ID2: Integer;
begin
  I := FListaProductos.ItemIndex;
  if I <= 0 then
    Exit;

  ID1 := PtrInt(FListaProductos.Items.Objects[I]);
  ID2 := PtrInt(FListaProductos.Items.Objects[I - 1]);
  IntercambiarOrden(FLXTablaTecladoProductos(FTienda),
    'TP_ID', 'TP_ORDEN', ID1, ID2);
  RefrescarProductos(ID1);
end;

procedure TFLXConfigTecladoProductosForm.BajarProductoClick(
  Sender: TObject);
var
  I, ID1, ID2: Integer;
begin
  I := FListaProductos.ItemIndex;
  if (I < 0) or (I >= FListaProductos.Items.Count - 1) then
    Exit;

  ID1 := PtrInt(FListaProductos.Items.Objects[I]);
  ID2 := PtrInt(FListaProductos.Items.Objects[I + 1]);
  IntercambiarOrden(FLXTablaTecladoProductos(FTienda),
    'TP_ID', 'TP_ORDEN', ID1, ID2);
  RefrescarProductos(ID1);
end;

procedure TFLXConfigTecladoProductosForm.CerrarClick(
  Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure FLXConfigurarTecladoProductos(AOwner: TComponent;
  AConnection: TZAbstractConnection; const ATienda: string);
var
  F: TFLXConfigTecladoProductosForm;
begin
  F := TFLXConfigTecladoProductosForm.CreateConfig(
    AOwner, AConnection, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

end.
