unit uCentroMantenimientoFacturLinEx;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, StdCtrls, Buttons,
  Grids, Graphics, DB, ZConnection, ZDataset, Global,
  uFLXGridStyle, uFLXExport, uFLXIcons, uFLXDialogs;

procedure MostrarCentroMantenimientoFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);

implementation

type
  TCentroMantenimientoForm = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;
    FSortCol: Integer;
    FSortDesc: Boolean;
    FTotal: Integer;
    FAltas: Integer;
    FMedias: Integer;
    FAvisos: Integer;
    FOK: Integer;
    Grid: TStringGrid;
    Memo: TMemo;
    HeaderPanel: TPanel;
    ActionPanel: TPanel;
    InfoPanel: TPanel;
    ContentPanel: TPanel;
    KPIPanel: TPanel;
    LblTitulo: TLabel;
    LblSubtitulo: TLabel;
    LblVistaActual: TLabel;
    LblSubtituloVista: TLabel;
    LblKPITotal: TLabel;
    LblKPIAlta: TLabel;
    LblKPIMedia: TLabel;
    LblKPIAvisos: TLabel;
    LblKPISalud: TLabel;
    BtnRevisar: TBitBtn;
    BtnInfoBBDD: TBitBtn;
    BtnCheckTablas: TBitBtn;
    BtnRepararTablas: TBitBtn;
    BtnConvertirMotor: TBitBtn;
    BtnCSV: TBitBtn;
    BtnCerrar: TBitBtn;
    procedure CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
    procedure CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer = 118);
    procedure CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
    procedure ResetGrid;
    procedure AddRow(const Categoria, Elemento, Estado, Detalle, Accion: string; Prioridad: Integer);
    procedure AplicarEstiloGrid;
    procedure AjustarColumnas;
    procedure LimpiarKPIs;
    procedure ActualizarKPIs;
    procedure RevisarClick(Sender: TObject);
    procedure InfoBBDDClick(Sender: TObject);
    procedure CheckTablasClick(Sender: TObject);
    procedure RepararTablasClick(Sender: TObject);
    procedure ConvertirMotorClick(Sender: TObject);
    procedure CSVClick(Sender: TObject);
    procedure CerrarClick(Sender: TObject);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
    function DBName: string;
    function CleanIdent(const S: string): string;
    function SQLIdent(const S: string): string;
    function TableName(const Prefix: string): string;
    function TableExists(const ATable: string): Boolean;
    function ColumnExists(const ATable, AColumn: string): Boolean;
    function ScalarInt(const ASQL: string; const ADefault: Integer = 0): Integer;
    function DirFileCount(const ADir: string): Integer;
    function DirSizeBytes(const ADir: string): Int64;
    function MotorObjetivoConfigurado: string;
    function TableMsgPriority(const AMsgType, AMsgText: string): Integer;
    procedure ExecSQLDirect(const ASQL: string);
    procedure ListarInfoBBDD;
    procedure ChequearTablas;
    procedure RepararTablasConError;
    procedure ConvertirTablasAMotorConfigurado;
    procedure CheckTable(const Categoria, Tabla, DetalleOK, AccionFalta: string; PrioridadFalta: Integer = 2);
    procedure CheckColumns(const Tabla, Columnas, Descripcion: string);
    procedure RevisarBaseDatos;
    procedure RevisarVerifactu;
    procedure RevisarLogs;
    procedure RevisarDisco;
  public
    constructor CreateForm(AOwner: TComponent; AConnection: TZConnection; const ATienda: string); reintroduce;
  end;

procedure TCentroMantenimientoForm.CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
begin
  FLXSetBitBtnIcon(ABtn, AIcon, ASize);
end;

procedure TCentroMantenimientoForm.CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer);
begin
  ABtn := TBitBtn.Create(Self);
  ABtn.Parent := AParent;
  ABtn.Left := ALeft;
  ABtn.Top := 8;
  ABtn.Width := AWidth;
  ABtn.Height := 58;
  ABtn.Caption := ACaption;
  ABtn.Layout := blGlyphTop;
  ABtn.Font.Style := [fsBold];
  CargarIconoBoton(ABtn, AIcon, 30);
end;

procedure TCentroMantenimientoForm.CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
var
  P: TPanel;
  Img: TImage;
  L: TLabel;
  FN: string;
  Pic: TPicture;
begin
  P := TPanel.Create(Self);
  P.Parent := AParent;
  P.Left := ALeft;
  P.Top := 12;
  P.Width := 230;
  P.Height := 82;
  P.BevelOuter := bvLowered;
  P.Color := RGBToColor(250,252,255);

  Img := TImage.Create(Self);
  Img.Parent := P;
  Img.Left := 12;
  Img.Top := 16;
  Img.Width := 42;
  Img.Height := 42;
  Img.Stretch := True;
  FN := FLXIconFile(AIcon, 48);
  if FN <> '' then
  begin
    Pic := TPicture.Create;
    try
      Pic.LoadFromFile(FN);
      Img.Picture.Assign(Pic);
    finally
      Pic.Free;
    end;
  end;

  L := TLabel.Create(Self);
  L.Parent := P;
  L.Left := 68;
  L.Top := 12;
  L.Caption := ATitle;
  L.Font.Color := RGBToColor(10,45,95);
  L.Font.Style := [fsBold];

  AValueLabel := TLabel.Create(Self);
  AValueLabel.Parent := P;
  AValueLabel.Left := 68;
  AValueLabel.Top := 38;
  AValueLabel.Caption := '-';
  AValueLabel.Font.Size := 14;
  AValueLabel.Font.Style := [fsBold];
  AValueLabel.Font.Color := RGBToColor(0,32,80);
end;

constructor TCentroMantenimientoForm.CreateForm(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  Logo: TImage;
  Pic: TPicture;
  FN: string;
  L: TLabel;
begin
  inherited CreateNew(AOwner, 1);
  FConn := AConnection;
  FTienda := ATienda;
  FSortCol := -1;
  FSortDesc := False;

  Caption := 'FacturLinEx - Mantenimiento';
  Width := 1300;
  Height := 820;
  Position := poScreenCenter;
  WindowState := wsMaximized;
  BorderIcons := [biSystemMenu, biMaximize];
  Color := RGBToColor(245,248,252);

  HeaderPanel := TPanel.Create(Self);
  HeaderPanel.Parent := Self;
  HeaderPanel.Align := alTop;
  HeaderPanel.Height := 118;
  HeaderPanel.BevelOuter := bvNone;
  HeaderPanel.Color := RGBToColor(248,251,255);

  Logo := TImage.Create(Self);
  Logo.Parent := HeaderPanel;
  Logo.Left := 24;
  Logo.Top := 18;
  Logo.Width := 68;
  Logo.Height := 68;
  Logo.Stretch := True;
  FN := FLXIconFile('mantenimiento', 64);
  if FN <> '' then
  begin
    Pic := TPicture.Create;
    try
      Pic.LoadFromFile(FN);
      Logo.Picture.Assign(Pic);
    finally
      Pic.Free;
    end;
  end;

  LblTitulo := TLabel.Create(Self);
  LblTitulo.Parent := HeaderPanel;
  LblTitulo.Left := 112;
  LblTitulo.Top := 24;
  LblTitulo.Caption := 'Mantenimiento inteligente';
  LblTitulo.Font.Size := 24;
  LblTitulo.Font.Style := [fsBold];
  LblTitulo.Font.Color := RGBToColor(0,32,80);

  LblSubtitulo := TLabel.Create(Self);
  LblSubtitulo.Parent := HeaderPanel;
  LblSubtitulo.Left := 114;
  LblSubtitulo.Top := 68;
  LblSubtitulo.Caption := 'Revisión segura de BBDD, VeriFactu, logs y espacio libre. No modifica datos.';
  LblSubtitulo.Font.Size := 11;
  LblSubtitulo.Font.Color := RGBToColor(45,70,105);

  ActionPanel := TPanel.Create(Self);
  ActionPanel.Parent := HeaderPanel;
  ActionPanel.Align := alRight;
  ActionPanel.Width := 760;
  ActionPanel.BevelOuter := bvNone;
  ActionPanel.Color := HeaderPanel.Color;

  CrearBotonAccion(ActionPanel, BtnRevisar, 'Revisar', 'actualizar', 8, 94);
  BtnRevisar.OnClick := @RevisarClick;
  CrearBotonAccion(ActionPanel, BtnInfoBBDD, 'Info BBDD', 'mantenimiento', 108, 100);
  BtnInfoBBDD.OnClick := @InfoBBDDClick;
  CrearBotonAccion(ActionPanel, BtnCheckTablas, 'Check', 'doctor', 214, 90);
  BtnCheckTablas.OnClick := @CheckTablasClick;
  CrearBotonAccion(ActionPanel, BtnRepararTablas, 'Reparar', 'alertas', 310, 96);
  BtnRepararTablas.OnClick := @RepararTablasClick;
  CrearBotonAccion(ActionPanel, BtnConvertirMotor, 'Motor', 'centro', 412, 90);
  BtnConvertirMotor.OnClick := @ConvertirMotorClick;
  CrearBotonAccion(ActionPanel, BtnCSV, 'Exportar', 'tend_exportar', 508, 100);
  BtnCSV.OnClick := @CSVClick;
  CrearBotonAccion(ActionPanel, BtnCerrar, 'Cerrar', 'cerrar', 614, 90);
  BtnCerrar.OnClick := @CerrarClick;

  KPIPanel := TPanel.Create(Self);
  KPIPanel.Parent := Self;
  KPIPanel.Align := alBottom;
  KPIPanel.Height := 108;
  KPIPanel.BevelOuter := bvNone;
  KPIPanel.Color := RGBToColor(245,248,252);

  CrearKPI(KPIPanel, 'Elementos', 'tend_resumen', 18, LblKPITotal);
  CrearKPI(KPIPanel, 'Alta', 'alertas', 258, LblKPIAlta);
  CrearKPI(KPIPanel, 'Media', 'mantenimiento', 498, LblKPIMedia);
  CrearKPI(KPIPanel, 'Avisos', 'doctor', 738, LblKPIAvisos);
  CrearKPI(KPIPanel, 'Salud', 'tend_kpi_porcentaje', 978, LblKPISalud);

  InfoPanel := TPanel.Create(Self);
  InfoPanel.Parent := Self;
  InfoPanel.Align := alLeft;
  InfoPanel.Width := 255;
  InfoPanel.BevelOuter := bvNone;
  InfoPanel.Color := RGBToColor(236,244,255);

  LblVistaActual := TLabel.Create(Self);
  LblVistaActual.Parent := InfoPanel;
  LblVistaActual.Left := 18;
  LblVistaActual.Top := 24;
  LblVistaActual.Width := 215;
  LblVistaActual.Caption := 'Revisión segura';
  LblVistaActual.Font.Size := 15;
  LblVistaActual.Font.Style := [fsBold];
  LblVistaActual.Font.Color := RGBToColor(0,32,80);

  LblSubtituloVista := TLabel.Create(Self);
  LblSubtituloVista.Parent := InfoPanel;
  LblSubtituloVista.Left := 20;
  LblSubtituloVista.Top := 62;
  LblSubtituloVista.Width := 210;
  LblSubtituloVista.Height := 170;
  LblSubtituloVista.WordWrap := True;
  LblSubtituloVista.Caption := 'Pulsa Revisar para comprobar tablas principales, columnas clave, cola VeriFactu, logs locales y espacio libre del puesto.';
  LblSubtituloVista.Font.Color := RGBToColor(50,75,105);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 20;
  L.Top := 250;
  L.Width := 210;
  L.Height := 145;
  L.WordWrap := True;
  L.Caption := 'Modo conservador por defecto: Revisar, Info BBDD y Check no modifican datos. Reparar y Motor piden confirmacion explicita antes de tocar tablas.';
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(10,45,95);

  Memo := TMemo.Create(Self);
  Memo.Parent := InfoPanel;
  Memo.Left := 18;
  Memo.Top := 430;
  Memo.Width := 218;
  Memo.Height := 205;
  Memo.ScrollBars := ssVertical;
  Memo.ReadOnly := True;
  Memo.Color := RGBToColor(252,254,255);
  Memo.Lines.Text := 'Pendiente de revisión.' + LineEnding +
                     'No se han realizado cambios.';

  ContentPanel := TPanel.Create(Self);
  ContentPanel.Parent := Self;
  ContentPanel.Align := alClient;
  ContentPanel.BevelOuter := bvNone;
  ContentPanel.BorderSpacing.Left := 12;
  ContentPanel.BorderSpacing.Right := 12;
  ContentPanel.BorderSpacing.Top := 8;
  ContentPanel.BorderSpacing.Bottom := 8;
  ContentPanel.Color := RGBToColor(245,248,252);

  Grid := TStringGrid.Create(Self);
  Grid.Parent := ContentPanel;
  Grid.Align := alClient;
  Grid.BorderStyle := bsSingle;
  Grid.OnMouseDown := @GridMouseDown;
  Grid.OnPrepareCanvas := @GridPrepareCanvas;
  AplicarEstiloGrid;
  ResetGrid;
  LimpiarKPIs;
end;

procedure TCentroMantenimientoForm.ResetGrid;
begin
  Grid.ColCount := 6;
  Grid.RowCount := 1;
  Grid.Cells[0,0] := 'Prioridad';
  Grid.Cells[1,0] := 'Categoría';
  Grid.Cells[2,0] := 'Elemento';
  Grid.Cells[3,0] := 'Estado';
  Grid.Cells[4,0] := 'Detalle';
  Grid.Cells[5,0] := 'Acción recomendada';
  AjustarColumnas;
end;

procedure TCentroMantenimientoForm.AddRow(const Categoria, Elemento, Estado, Detalle, Accion: string; Prioridad: Integer);
var R: Integer;
begin
  R := Grid.RowCount;
  Grid.RowCount := R + 1;
  case Prioridad of
    3: Grid.Cells[0,R] := 'ALTA';
    2: Grid.Cells[0,R] := 'MEDIA';
    1: Grid.Cells[0,R] := 'AVISO';
  else
    Grid.Cells[0,R] := 'OK';
  end;
  Grid.Cells[1,R] := Categoria;
  Grid.Cells[2,R] := Elemento;
  Grid.Cells[3,R] := Estado;
  Grid.Cells[4,R] := Detalle;
  Grid.Cells[5,R] := Accion;
end;

procedure TCentroMantenimientoForm.AplicarEstiloGrid;
begin
  FLXGridPreparar(Grid);
  Grid.DefaultRowHeight := 26;
  Grid.RowHeights[0] := 30;
  Grid.Font.Size := 9;
end;

procedure TCentroMantenimientoForm.AjustarColumnas;
begin
  if Grid = nil then Exit;
  Grid.ColWidths[0] := 90;
  Grid.ColWidths[1] := 135;
  Grid.ColWidths[2] := 195;
  Grid.ColWidths[3] := 110;
  Grid.ColWidths[4] := 410;
  Grid.ColWidths[5] := 360;
end;

procedure TCentroMantenimientoForm.LimpiarKPIs;
begin
  FTotal := 0;
  FAltas := 0;
  FMedias := 0;
  FAvisos := 0;
  FOK := 0;
  LblKPITotal.Caption := '0';
  LblKPIAlta.Caption := '0';
  LblKPIMedia.Caption := '0';
  LblKPIAvisos.Caption := '0';
  LblKPISalud.Caption := '-';
end;

procedure TCentroMantenimientoForm.ActualizarKPIs;
var R, Pct: Integer; S: string;
begin
  LimpiarKPIs;
  for R := 1 to Grid.RowCount - 1 do
  begin
    Inc(FTotal);
    S := Grid.Cells[0,R];
    if S = 'ALTA' then Inc(FAltas)
    else if S = 'MEDIA' then Inc(FMedias)
    else if S = 'AVISO' then Inc(FAvisos)
    else Inc(FOK);
  end;

  LblKPITotal.Caption := IntToStr(FTotal);
  LblKPIAlta.Caption := IntToStr(FAltas);
  LblKPIMedia.Caption := IntToStr(FMedias);
  LblKPIAvisos.Caption := IntToStr(FAvisos);
  if FTotal > 0 then
  begin
    Pct := Round((FOK / FTotal) * 100);
    LblKPISalud.Caption := IntToStr(Pct) + ' % OK';
  end;
end;

function TCentroMantenimientoForm.CleanIdent(const S: string): string;
begin
  Result := StringReplace(S, '`', '', [rfReplaceAll]);
end;

function TCentroMantenimientoForm.SQLIdent(const S: string): string;
begin
  Result := '`' + CleanIdent(S) + '`';
end;

function TCentroMantenimientoForm.DBName: string;
begin
  Result := '';
  if FConn <> nil then Result := FConn.Database;
end;

function TCentroMantenimientoForm.TableName(const Prefix: string): string;
begin
  Result := Prefix + FTienda;
end;

function TCentroMantenimientoForm.TableExists(const ATable: string): Boolean;
var Q: TZQuery;
begin
  Result := False;
  if (FConn = nil) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.TABLES ' +
                  'WHERE TABLE_SCHEMA = :db AND TABLE_NAME = :tb';
    Q.ParamByName('db').AsString := DBName;
    Q.ParamByName('tb').AsString := CleanIdent(ATable);
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  except
    Result := False;
  end;
  Q.Free;
end;

function TCentroMantenimientoForm.ColumnExists(const ATable, AColumn: string): Boolean;
var Q: TZQuery;
begin
  Result := False;
  if (FConn = nil) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.COLUMNS ' +
                  'WHERE TABLE_SCHEMA = :db AND TABLE_NAME = :tb AND COLUMN_NAME = :col';
    Q.ParamByName('db').AsString := DBName;
    Q.ParamByName('tb').AsString := CleanIdent(ATable);
    Q.ParamByName('col').AsString := CleanIdent(AColumn);
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  except
    Result := False;
  end;
  Q.Free;
end;

function TCentroMantenimientoForm.ScalarInt(const ASQL: string; const ADefault: Integer): Integer;
var Q: TZQuery;
begin
  Result := ADefault;
  if (FConn = nil) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := ASQL;
    Q.Open;
    if not Q.EOF then Result := Q.Fields[0].AsInteger;
  except
    Result := ADefault;
  end;
  Q.Free;
end;

function TCentroMantenimientoForm.DirFileCount(const ADir: string): Integer;
var SR: TSearchRec;
begin
  Result := 0;
  if not DirectoryExists(ADir) then Exit;
  if FindFirst(IncludeTrailingPathDelimiter(ADir) + '*', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Name <> '.') and (SR.Name <> '..') and ((SR.Attr and faDirectory) = 0) then Inc(Result);
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

function TCentroMantenimientoForm.DirSizeBytes(const ADir: string): Int64;
var SR: TSearchRec;
begin
  Result := 0;
  if not DirectoryExists(ADir) then Exit;
  if FindFirst(IncludeTrailingPathDelimiter(ADir) + '*', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Name <> '.') and (SR.Name <> '..') and ((SR.Attr and faDirectory) = 0) then
        Inc(Result, SR.Size);
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

function TCentroMantenimientoForm.MotorObjetivoConfigurado: string;
var S: string;
begin
  S := UpperCase(Trim(MotorDB));
  if S = '' then S := UpperCase(Trim(mbbdd));

  if S = 'MYISAM' then Result := 'MyISAM'
  else if S = 'ARIA' then Result := 'Aria'
  else if S = 'INNODB' then Result := 'InnoDB'
  else Result := '';
end;

function TCentroMantenimientoForm.TableMsgPriority(const AMsgType, AMsgText: string): Integer;
var T, M: string;
begin
  T := UpperCase(Trim(AMsgType));
  M := UpperCase(Trim(AMsgText));
  Result := 0;
  if (T = 'ERROR') or (Pos('CORRUPT', M) > 0) or (Pos('CRASH', M) > 0) then
    Result := 3
  else if (T = 'WARNING') or (T = 'WARN') then
    Result := 2
  else if (T <> '') and (T <> 'STATUS') and (T <> 'NOTE') then
    Result := 1;
end;

procedure TCentroMantenimientoForm.ExecSQLDirect(const ASQL: string);
var Q: TZQuery;
begin
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := ASQL;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TCentroMantenimientoForm.ListarInfoBBDD;
var
  Q: TZQuery;
  Tabla, Motor, Filas, TamDatos, TamIdx, Collation, RowFmt: string;
begin
  ResetGrid;
  LimpiarKPIs;
  Memo.Clear;
  Memo.Lines.Add('Información BBDD: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
  Memo.Lines.Add('Base de datos: ' + DBName);
  Memo.Lines.Add('Motor configurado en FacturConf.ini: ' + MotorObjetivoConfigurado);

  if (FConn = nil) or (not FConn.Connected) then
  begin
    AddRow('BBDD', 'Conexión', 'ERROR', 'No hay conexión activa.', 'Revisar conexión.', 3);
    ActualizarKPIs;
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT TABLE_NAME, ENGINE, TABLE_ROWS, DATA_LENGTH, INDEX_LENGTH, TABLE_COLLATION, ROW_FORMAT ' +
      'FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=:DB AND TABLE_TYPE=''BASE TABLE'' ORDER BY TABLE_NAME';
    Q.ParamByName('DB').AsString := DBName;
    Q.Open;
    while not Q.EOF do
    begin
      Tabla := Q.FieldByName('TABLE_NAME').AsString;
      Motor := Q.FieldByName('ENGINE').AsString;
      Filas := Q.FieldByName('TABLE_ROWS').AsString;
      TamDatos := FormatFloat('0.00', Q.FieldByName('DATA_LENGTH').AsFloat / 1024 / 1024) + ' MB';
      TamIdx := FormatFloat('0.00', Q.FieldByName('INDEX_LENGTH').AsFloat / 1024 / 1024) + ' MB';
      Collation := Q.FieldByName('TABLE_COLLATION').AsString;
      RowFmt := Q.FieldByName('ROW_FORMAT').AsString;
      AddRow('Info BBDD', Tabla, Motor,
        'Filas aprox.: ' + Filas + ' | Datos: ' + TamDatos + ' | Índices: ' + TamIdx,
        'Collation: ' + Collation + ' | Row format: ' + RowFmt, 0);
      Q.Next;
    end;
    if Grid.RowCount = 1 then
      AddRow('Info BBDD', DBName, 'AVISO', 'No se han localizado tablas base.', 'Revisar BBDD seleccionada.', 1);
  finally
    Q.Free;
  end;

  ActualizarKPIs;
  AjustarColumnas;
end;

procedure TCentroMantenimientoForm.ChequearTablas;
var
  QT, QC: TZQuery;
  Tabla, MsgType, MsgText: string;
  Pri: Integer;
begin
  ResetGrid;
  LimpiarKPIs;
  Memo.Clear;
  Memo.Lines.Add('CHECK TABLE iniciado: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
  Memo.Lines.Add('No modifica datos. Puede tardar si hay tablas grandes.');

  if (FConn = nil) or (not FConn.Connected) then
  begin
    AddRow('BBDD', 'Conexión', 'ERROR', 'No hay conexión activa.', 'Revisar conexión.', 3);
    ActualizarKPIs;
    Exit;
  end;

  QT := TZQuery.Create(nil);
  QC := TZQuery.Create(nil);
  try
    QT.Connection := FConn;
    QC.Connection := FConn;
    QT.SQL.Text := 'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=:DB AND TABLE_TYPE=''BASE TABLE'' ORDER BY TABLE_NAME';
    QT.ParamByName('DB').AsString := DBName;
    QT.Open;
    while not QT.EOF do
    begin
      Tabla := QT.FieldByName('TABLE_NAME').AsString;
      try
        QC.Close;
        QC.SQL.Text := 'CHECK TABLE ' + SQLIdent(Tabla);
        QC.Open;
        while not QC.EOF do
        begin
          MsgType := QC.FieldByName('Msg_type').AsString;
          MsgText := QC.FieldByName('Msg_text').AsString;
          Pri := TableMsgPriority(MsgType, MsgText);
          AddRow('Check tablas', Tabla, MsgType, MsgText,
            'Si aparece error/corrupt/crashed, usar Reparar tablas o revisar desde MariaDB.', Pri);
          QC.Next;
        end;
      except
        on E: Exception do
          AddRow('Check tablas', Tabla, 'ERROR', E.Message, 'Revisar tabla desde gestor/MariaDB.', 3);
      end;
      QT.Next;
    end;
  finally
    QC.Free;
    QT.Free;
  end;

  ActualizarKPIs;
  AjustarColumnas;
  Memo.Lines.Add('CHECK TABLE finalizado: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
end;

procedure TCentroMantenimientoForm.RepararTablasConError;
var
  QT, QC, QR: TZQuery;
  Tabla, Motor, MsgType, MsgText, RMsgType, RMsgText: string;
  Pri, MaxPri: Integer;
begin
  ResetGrid;
  LimpiarKPIs;
  Memo.Clear;
  Memo.Lines.Add('Reparación controlada iniciada: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
  Memo.Lines.Add('Primero se ejecuta CHECK TABLE. Solo se intenta REPAIR si hay error y el motor lo soporta.');

  if (FConn = nil) or (not FConn.Connected) then
  begin
    AddRow('Reparar tablas', 'Conexión', 'ERROR', 'No hay conexión activa.', 'Revisar conexión antes de reparar.', 3);
    ActualizarKPIs;
    Exit;
  end;

  if MessageDlg('Reparar tablas',
    'Se recomienda hacer copia de seguridad antes de reparar tablas.' + LineEnding +
    'Se comprobarán las tablas y solo se intentará REPAIR TABLE sobre MyISAM/Aria con error.' + LineEnding +
    '¿Continuar?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
  begin
    AddRow('Reparar tablas', 'Cancelado', 'AVISO', 'Operación cancelada por el usuario.', 'Sin cambios.', 1);
    ActualizarKPIs;
    Exit;
  end;

  QT := TZQuery.Create(nil);
  QC := TZQuery.Create(nil);
  QR := TZQuery.Create(nil);
  try
    QT.Connection := FConn;
    QC.Connection := FConn;
    QR.Connection := FConn;
    QT.SQL.Text := 'SELECT TABLE_NAME, ENGINE FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=:DB AND TABLE_TYPE=''BASE TABLE'' ORDER BY TABLE_NAME';
    QT.ParamByName('DB').AsString := DBName;
    QT.Open;
    while not QT.EOF do
    begin
      Tabla := QT.FieldByName('TABLE_NAME').AsString;
      Motor := QT.FieldByName('ENGINE').AsString;
      MaxPri := 0;
      MsgText := '';
      try
        QC.Close;
        QC.SQL.Text := 'CHECK TABLE ' + SQLIdent(Tabla);
        QC.Open;
        while not QC.EOF do
        begin
          MsgType := QC.FieldByName('Msg_type').AsString;
          MsgText := QC.FieldByName('Msg_text').AsString;
          Pri := TableMsgPriority(MsgType, MsgText);
          if Pri > MaxPri then MaxPri := Pri;
          QC.Next;
        end;

        if MaxPri = 0 then
          AddRow('Reparar tablas', Tabla, 'OK', 'CHECK TABLE correcto. No se repara.', 'Sin acción.', 0)
        else if (CompareText(Motor, 'MyISAM') = 0) or (CompareText(Motor, 'Aria') = 0) then
        begin
          QR.Close;
          QR.SQL.Text := 'REPAIR TABLE ' + SQLIdent(Tabla);
          QR.Open;
          RMsgType := '';
          RMsgText := '';
          while not QR.EOF do
          begin
            RMsgType := QR.FieldByName('Msg_type').AsString;
            RMsgText := QR.FieldByName('Msg_text').AsString;
            QR.Next;
          end;
          AddRow('Reparar tablas', Tabla, RMsgType, 'Motor ' + Motor + ' | ' + RMsgText,
            'Ejecutado REPAIR TABLE. Repetir Check para verificar.', TableMsgPriority(RMsgType, RMsgText));
        end
        else
          AddRow('Reparar tablas', Tabla, 'NO SOPORTADO', 'Motor ' + Motor + ' con aviso/error: ' + MsgText,
            'InnoDB no se repara con REPAIR TABLE; revisar logs/backup/MariaDB.', 2);
      except
        on E: Exception do
          AddRow('Reparar tablas', Tabla, 'ERROR', E.Message, 'Revisar manualmente desde MariaDB.', 3);
      end;
      QT.Next;
    end;
  finally
    QR.Free;
    QC.Free;
    QT.Free;
  end;

  ActualizarKPIs;
  AjustarColumnas;
  Memo.Lines.Add('Reparación controlada finalizada: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
end;

procedure TCentroMantenimientoForm.ConvertirTablasAMotorConfigurado;
var
  QT: TZQuery;
  Tabla, MotorActual, MotorDestino: string;
begin
  ResetGrid;
  LimpiarKPIs;
  Memo.Clear;
  MotorDestino := MotorObjetivoConfigurado;
  Memo.Lines.Add('Conversión de motor iniciada: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
  Memo.Lines.Add('Motor configurado: ' + MotorDestino);

  if MotorDestino = '' then
  begin
    AddRow('Motor tablas', 'Configuración', 'ERROR', 'MotorDB/mbbdd no contiene MyISAM, Aria o InnoDB.', 'Revisar pestaña Configuración.', 3);
    ActualizarKPIs;
    Exit;
  end;

  if (FConn = nil) or (not FConn.Connected) then
  begin
    AddRow('Motor tablas', 'Conexión', 'ERROR', 'No hay conexión activa.', 'Revisar conexión antes de convertir.', 3);
    ActualizarKPIs;
    Exit;
  end;

  if MessageDlg('Convertir motor de tablas',
    'Se convertirán las tablas de la BBDD activa al motor configurado: ' + MotorDestino + '.' + LineEnding +
    'Esta operación ejecuta ALTER TABLE y puede tardar/bloquear tablas grandes.' + LineEnding +
    'Haz copia de seguridad antes de continuar.' + LineEnding +
    '¿Continuar?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
  begin
    AddRow('Motor tablas', 'Cancelado', 'AVISO', 'Operación cancelada por el usuario.', 'Sin cambios.', 1);
    ActualizarKPIs;
    Exit;
  end;

  QT := TZQuery.Create(nil);
  try
    QT.Connection := FConn;
    QT.SQL.Text := 'SELECT TABLE_NAME, ENGINE FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=:DB AND TABLE_TYPE=''BASE TABLE'' ORDER BY TABLE_NAME';
    QT.ParamByName('DB').AsString := DBName;
    QT.Open;
    while not QT.EOF do
    begin
      Tabla := QT.FieldByName('TABLE_NAME').AsString;
      MotorActual := QT.FieldByName('ENGINE').AsString;
      try
        if CompareText(MotorActual, MotorDestino) = 0 then
          AddRow('Motor tablas', Tabla, 'OK', 'Ya está en motor ' + MotorDestino + '.', 'Sin acción.', 0)
        else
        begin
          ExecSQLDirect('ALTER TABLE ' + SQLIdent(Tabla) + ' ENGINE=' + MotorDestino);
          AddRow('Motor tablas', Tabla, 'CONVERTIDA', MotorActual + ' -> ' + MotorDestino, 'Revisar con Info BBDD si procede.', 1);
        end;
      except
        on E: Exception do
          AddRow('Motor tablas', Tabla, 'ERROR', MotorActual + ' -> ' + MotorDestino + ': ' + E.Message, 'Revisar manualmente esta tabla.', 3);
      end;
      QT.Next;
    end;
  finally
    QT.Free;
  end;

  ActualizarKPIs;
  AjustarColumnas;
  Memo.Lines.Add('Conversión de motor finalizada: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
end;

procedure TCentroMantenimientoForm.CheckTable(const Categoria, Tabla, DetalleOK, AccionFalta: string; PrioridadFalta: Integer);
begin
  if TableExists(Tabla) then
    AddRow(Categoria, Tabla, 'OK', DetalleOK, 'Sin acción.', 0)
  else
    AddRow(Categoria, Tabla, 'FALTA', 'No se encuentra la tabla.', AccionFalta, PrioridadFalta);
end;

procedure TCentroMantenimientoForm.CheckColumns(const Tabla, Columnas, Descripcion: string);
var
  SL: TStringList;
  I: Integer;
  Falta: string;
begin
  if not TableExists(Tabla) then Exit;
  SL := TStringList.Create;
  try
    SL.StrictDelimiter := True;
    SL.Delimiter := ',';
    SL.DelimitedText := Columnas;
    Falta := '';
    for I := 0 to SL.Count - 1 do
      if not ColumnExists(Tabla, Trim(SL[I])) then
      begin
        if Falta <> '' then Falta := Falta + ', ';
        Falta := Falta + Trim(SL[I]);
      end;

    if Falta = '' then
      AddRow('BBDD', Tabla + ' columnas', 'OK', Descripcion + ': columnas esperadas presentes.', 'Sin acción.', 0)
    else
      AddRow('BBDD', Tabla + ' columnas', 'MEDIA', 'Faltan columnas: ' + Falta, 'Revisar estructura antes de usar módulos dependientes.', 2);
  finally
    SL.Free;
  end;
end;

procedure TCentroMantenimientoForm.RevisarBaseDatos;
var T: string;
begin
  if (FConn = nil) or (not FConn.Connected) then
  begin
    AddRow('BBDD', 'Conexión', 'ERROR', 'No hay conexión activa a la base de datos.', 'Revisar conexión antes de continuar.', 3);
    Exit;
  end;
  AddRow('BBDD', 'Conexión', 'OK', 'Conectado a ' + DBName, 'Sin acción.', 0);

  T := TableName('artitien');
  CheckTable('BBDD', T, 'Tabla de artículos encontrada.', 'Revisar tienda/configuración.', 3);
  CheckColumns(T, 'A0,A1,A2,A21,A24,A14,A32', 'Artículo, descripción, PVP, coste, familia y proveedor');

  CheckTable('BBDD', 'clientes', 'Tabla de clientes encontrada.', 'Revisar estructura de la BBDD.', 3);
  CheckColumns('clientes', 'C0,C1,C5', 'Código, nombre y NIF/CIF');

  CheckTable('BBDD', 'proveedores', 'Tabla de proveedores encontrada.', 'Revisar estructura de la BBDD.', 3);
  CheckColumns('proveedores', 'P0,P1', 'Código y nombre de proveedor');

  T := TableName('familias');
  CheckTable('BBDD', T, 'Tabla de familias encontrada.', 'Revisar si esta instalación usa familias por tienda.', 1);

  if TableExists('eans') then
    AddRow('BBDD', 'eans', 'OK', 'Tabla de códigos auxiliares/EAN disponible.', 'Sin acción.', 0)
  else
    AddRow('BBDD', 'eans', 'AVISO', 'No se encuentra tabla eans.', 'Ignorar si esta instalación no usa EAN auxiliares.', 1);

  T := TableName('hisopcc');
  CheckTable('BBDD', T, 'Histórico de cabeceras disponible.', 'Módulos de análisis tendrán menos datos.', 2);
  T := TableName('hisopdd');
  CheckTable('BBDD', T, 'Histórico de líneas disponible.', 'Módulos de análisis tendrán menos datos.', 2);

  T := TableName('hipedidd');
  if TableExists(T) then AddRow('BBDD', T, 'OK', 'Detalle histórico de compras disponible.', 'Sin acción.', 0)
  else AddRow('BBDD', T, 'AVISO', 'No se encuentra detalle histórico de compras.', 'El Asesor de Compras puede tener menos información.', 1);

  T := TableName('ultimopedi');
  if TableExists(T) then AddRow('BBDD', T, 'OK', 'Histórico último pedido disponible.', 'Sin acción.', 0)
  else AddRow('BBDD', T, 'AVISO', 'No se encuentra ultimopedi de la tienda.', 'Revisar si esta tabla se usa en esta instalación.', 1);
end;

procedure TCentroMantenimientoForm.RevisarVerifactu;
var Pend, ErrTec, Err: Integer;
begin
  if not TableExists('verifactu_queue') then
  begin
    AddRow('VeriFactu', 'verifactu_queue', 'AVISO', 'No se encuentra la cola VeriFactu.', 'Ignorar si esta instalación no usa VeriFactu.', 1);
    Exit;
  end;

  Pend := ScalarInt('SELECT COUNT(*) FROM verifactu_queue WHERE UPPER(COALESCE(estado,'''')) IN (''PENDIENTE'',''EN_PROCESO'')', 0);
  ErrTec := ScalarInt('SELECT COUNT(*) FROM verifactu_queue WHERE UPPER(COALESCE(estado,'''')) = ''ERROR_TECNICO''', 0);
  Err := ScalarInt('SELECT COUNT(*) FROM verifactu_queue WHERE UPPER(COALESCE(estado,'''')) = ''ERROR''', 0);

  if ErrTec > 0 then
    AddRow('VeriFactu', 'Cola', 'ALTA', IntToStr(ErrTec) + ' registros en ERROR_TECNICO.', 'Abrir monitor VeriFactu y revisar reintentos.', 3)
  else if Pend > 0 then
    AddRow('VeriFactu', 'Cola', 'MEDIA', IntToStr(Pend) + ' registros pendientes/en proceso.', 'Revisar si son recientes o están atascados.', 2)
  else
    AddRow('VeriFactu', 'Cola', 'OK', 'No hay pendientes críticos.', 'Sin acción.', 0);

  if Err > 0 then
    AddRow('VeriFactu', 'Errores AEAT', 'AVISO', IntToStr(Err) + ' registros ERROR con respuesta/revisión.', 'Revisar monitor para subsanar si procede.', 1);
end;

procedure TCentroMantenimientoForm.RevisarLogs;
var Home, L1, L2: string; C1, C2: Integer; S1, S2: Int64;
begin
  Home := GetEnvironmentVariable('HOME');
  L1 := IncludeTrailingPathDelimiter(Home) + '.local/share/facturlinex/logs';
  L2 := IncludeTrailingPathDelimiter(Home) + '.local/share/verifactu/logs';
  C1 := DirFileCount(L1); S1 := DirSizeBytes(L1);
  C2 := DirFileCount(L2); S2 := DirSizeBytes(L2);

  if DirectoryExists(L1) then
    AddRow('Logs', 'FacturLinEx', 'OK', IntToStr(C1) + ' ficheros, aprox. ' + FormatFloat('0.00', S1 / 1024 / 1024) + ' MB.', 'Vigilar si crece demasiado.', 0)
  else
    AddRow('Logs', 'FacturLinEx', 'AVISO', 'No se encuentra carpeta de logs.', 'Se creará cuando el programa escriba logs.', 1);

  if DirectoryExists(L2) then
    AddRow('Logs', 'VeriFactu', 'OK', IntToStr(C2) + ' ficheros, aprox. ' + FormatFloat('0.00', S2 / 1024 / 1024) + ' MB.', 'Vigilar si crece demasiado.', 0)
  else
    AddRow('Logs', 'VeriFactu', 'AVISO', 'No se encuentra carpeta de logs VeriFactu.', 'Ignorar si no se usa en este puesto.', 1);
end;

procedure TCentroMantenimientoForm.RevisarDisco;
var FreeB: Int64; FreeGB: Double;
begin
  FreeB := DiskFree(0);
  if FreeB < 0 then
  begin
    AddRow('Sistema', 'Espacio libre', 'AVISO', 'No se pudo calcular el espacio libre.', 'Revisar manualmente si procede.', 1);
    Exit;
  end;
  FreeGB := FreeB / 1024 / 1024 / 1024;
  if FreeGB < 2 then
    AddRow('Sistema', 'Espacio libre', 'ALTA', FormatFloat('0.00', FreeGB) + ' GB libres.', 'Liberar espacio antes de trabajar con seguridad.', 3)
  else if FreeGB < 10 then
    AddRow('Sistema', 'Espacio libre', 'MEDIA', FormatFloat('0.00', FreeGB) + ' GB libres.', 'Conviene revisar copias/logs antiguos.', 2)
  else
    AddRow('Sistema', 'Espacio libre', 'OK', FormatFloat('0.00', FreeGB) + ' GB libres.', 'Sin acción.', 0);
end;

procedure TCentroMantenimientoForm.RevisarClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    ResetGrid;
    LimpiarKPIs;
    Memo.Clear;
    Memo.Lines.Add('Revisión iniciada: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
    Memo.Lines.Add('Modo solo lectura. No se modificará la BBDD.');
    RevisarBaseDatos;
    RevisarVerifactu;
    RevisarLogs;
    RevisarDisco;
    ActualizarKPIs;
    AjustarColumnas;
    Memo.Lines.Add('Revisión finalizada: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
    Memo.Lines.Add('Elementos revisados: ' + IntToStr(FTotal));
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TCentroMantenimientoForm.InfoBBDDClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    ListarInfoBBDD;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TCentroMantenimientoForm.CheckTablasClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    ChequearTablas;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TCentroMantenimientoForm.RepararTablasClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    RepararTablasConError;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TCentroMantenimientoForm.ConvertirMotorClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    ConvertirTablasAMotorConfigurado;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TCentroMantenimientoForm.CSVClick(Sender: TObject);
begin
  if FLXGuardarCSVConDialogo(Grid, 'Exportar mantenimiento a CSV', 'mantenimiento_facturlinex.csv') then
    ShowMessage('CSV exportado correctamente.');
end;

procedure TCentroMantenimientoForm.CerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TCentroMantenimientoForm.GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var C, R: Integer;
begin
  Grid.MouseToCell(X, Y, C, R);
  if (R = 0) and (C >= 0) then
  begin
    FLXGridOrdenar(Grid, C, FSortCol, FSortDesc);
    AjustarColumnas;
  end;
end;

procedure TCentroMantenimientoForm.GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
var P: string;
begin
  FLXGridPrepararCanvasSeleccion(Grid, aRow, aState);
  if (aRow = 0) or (gdSelected in aState) then Exit;
  P := Grid.Cells[0,aRow];
  if P = 'ALTA' then Grid.Canvas.Brush.Color := RGBToColor(255,220,220)
  else if P = 'MEDIA' then Grid.Canvas.Brush.Color := RGBToColor(255,245,205)
  else if P = 'AVISO' then Grid.Canvas.Brush.Color := RGBToColor(235,244,255)
  else if P = 'OK' then Grid.Canvas.Brush.Color := RGBToColor(230,255,235);
end;

procedure MostrarCentroMantenimientoFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var F: TCentroMantenimientoForm;
begin
  F := TCentroMantenimientoForm.CreateForm(AOwner, AConnection, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

end.
