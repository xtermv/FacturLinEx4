unit uAccionesRecomendadasFacturLinEx;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, StdCtrls, Buttons,
  Grids, Graphics, DB, ZConnection, ZDataset,
  uFLXGridStyle, uFLXExport, uFLXIcons, uFLXDialogs;

procedure MostrarAccionesRecomendadasFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);

implementation

type
  TAccionesRecomendadasForm = class(TForm)
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

    HeaderPanel: TPanel;
    ActionPanel: TPanel;
    InfoPanel: TPanel;
    ContentPanel: TPanel;
    KPIPanel: TPanel;
    Grid: TStringGrid;
    MemoResumen: TMemo;
    CmbVista: TComboBox;
    LblTitulo: TLabel;
    LblSubtitulo: TLabel;
    LblVistaActual: TLabel;
    LblSubtituloVista: TLabel;
    LblKPITotal: TLabel;
    LblKPIAlta: TLabel;
    LblKPIMedia: TLabel;
    LblKPIAvisos: TLabel;
    LblKPISalud: TLabel;
    BtnAnalizar: TBitBtn;
    BtnCSV: TBitBtn;
    BtnCerrar: TBitBtn;

    procedure CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
    procedure CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer = 118);
    procedure CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
    procedure ResetGrid;
    procedure AddRow(const Prioridad, Area, Accion, Motivo, Referencia, Detalle: string);
    procedure AplicarEstiloGrid;
    procedure AjustarColumnas;
    procedure LimpiarKPIs;
    procedure ActualizarKPIs;
    procedure RefrescarResumen;
    procedure AnalizarClick(Sender: TObject);
    procedure CSVClick(Sender: TObject);
    procedure CerrarClick(Sender: TObject);
    procedure VistaChange(Sender: TObject);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
    function CleanIdent(const S: string): string;
    function SQLIdent(const S: string): string;
    function TableName(const Prefix: string): string;
    function DBName: string;
    function TableExists(const ATable: string): Boolean;
    function ColumnExists(const ATable, AColumn: string): Boolean;
    function ScalarInt(const ASQL: string; const ADefault: Integer = 0): Integer;
    procedure AnalizarVeriFactu;
    procedure AnalizarPromociones;
    procedure AnalizarArticulos;
    procedure AnalizarClientes;
  public
    constructor CreateForm(AOwner: TComponent; AConnection: TZConnection; const ATienda: string); reintroduce;
  end;

procedure TAccionesRecomendadasForm.CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
begin
  FLXSetBitBtnIcon(ABtn, AIcon, ASize);
end;

procedure TAccionesRecomendadasForm.CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer);
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
  ABtn.ShowHint := True;
  CargarIconoBoton(ABtn, AIcon, 30);
end;

procedure TAccionesRecomendadasForm.CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
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
  P.Width := 218;
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
  L.Left := 66;
  L.Top := 12;
  L.Caption := ATitle;
  L.Font.Color := RGBToColor(10,45,95);
  L.Font.Style := [fsBold];

  AValueLabel := TLabel.Create(Self);
  AValueLabel.Parent := P;
  AValueLabel.Left := 66;
  AValueLabel.Top := 38;
  AValueLabel.Caption := '-';
  AValueLabel.Font.Size := 13;
  AValueLabel.Font.Style := [fsBold];
  AValueLabel.Font.Color := RGBToColor(0,32,80);
end;

constructor TAccionesRecomendadasForm.CreateForm(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
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

  Caption := 'FacturLinEx - Acciones recomendadas';
  Width := 1360;
  Height := 830;
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
  FN := FLXIconFile('acciones', 64);
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
  LblTitulo.Caption := 'Acciones recomendadas';
  LblTitulo.Font.Size := 24;
  LblTitulo.Font.Style := [fsBold];
  LblTitulo.Font.Color := RGBToColor(0,32,80);

  LblSubtitulo := TLabel.Create(Self);
  LblSubtitulo.Parent := HeaderPanel;
  LblSubtitulo.Left := 114;
  LblSubtitulo.Top := 68;
  LblSubtitulo.Caption := 'Bandeja inteligente de tareas concretas: VeriFactu, promociones, artículos y clientes. Solo lectura.';
  LblSubtitulo.Font.Size := 11;
  LblSubtitulo.Font.Color := RGBToColor(45,70,105);

  ActionPanel := TPanel.Create(Self);
  ActionPanel.Parent := HeaderPanel;
  ActionPanel.Align := alRight;
  ActionPanel.Width := 420;
  ActionPanel.BevelOuter := bvNone;
  ActionPanel.Color := HeaderPanel.Color;

  CrearBotonAccion(ActionPanel, BtnAnalizar, 'Analizar', 'actualizar', 16, 118);
  BtnAnalizar.OnClick := @AnalizarClick;
  CrearBotonAccion(ActionPanel, BtnCSV, 'Exportar', 'tend_exportar', 146, 118);
  BtnCSV.OnClick := @CSVClick;
  CrearBotonAccion(ActionPanel, BtnCerrar, 'Cerrar', 'cerrar', 276, 118);
  BtnCerrar.OnClick := @CerrarClick;

  KPIPanel := TPanel.Create(Self);
  KPIPanel.Parent := Self;
  KPIPanel.Align := alBottom;
  KPIPanel.Height := 108;
  KPIPanel.BevelOuter := bvNone;
  KPIPanel.Color := RGBToColor(245,248,252);

  CrearKPI(KPIPanel, 'Acciones', 'acciones', 18, LblKPITotal);
  CrearKPI(KPIPanel, 'Alta', 'alertas', 248, LblKPIAlta);
  CrearKPI(KPIPanel, 'Media', 'mantenimiento', 478, LblKPIMedia);
  CrearKPI(KPIPanel, 'Avisos', 'doctor', 708, LblKPIAvisos);
  CrearKPI(KPIPanel, 'Salud', 'tend_kpi_porcentaje', 938, LblKPISalud);

  InfoPanel := TPanel.Create(Self);
  InfoPanel.Parent := Self;
  InfoPanel.Align := alLeft;
  InfoPanel.Width := 270;
  InfoPanel.BevelOuter := bvNone;
  InfoPanel.Color := RGBToColor(236,244,255);

  LblVistaActual := TLabel.Create(Self);
  LblVistaActual.Parent := InfoPanel;
  LblVistaActual.Left := 18;
  LblVistaActual.Top := 24;
  LblVistaActual.Width := 230;
  LblVistaActual.Caption := 'Vista de trabajo';
  LblVistaActual.Font.Size := 15;
  LblVistaActual.Font.Style := [fsBold];
  LblVistaActual.Font.Color := RGBToColor(0,32,80);

  LblSubtituloVista := TLabel.Create(Self);
  LblSubtituloVista.Parent := InfoPanel;
  LblSubtituloVista.Left := 20;
  LblSubtituloVista.Top := 62;
  LblSubtituloVista.Width := 230;
  LblSubtituloVista.Height := 118;
  LblSubtituloVista.WordWrap := True;
  LblSubtituloVista.Caption := 'Filtra la bandeja para centrarte en lo urgente o en un bloque concreto. Cambia la vista y pulsa Analizar.';
  LblSubtituloVista.Font.Color := RGBToColor(50,75,105);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 20;
  L.Top := 196;
  L.Caption := 'Filtro';
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(10,45,95);

  CmbVista := TComboBox.Create(Self);
  CmbVista.Parent := InfoPanel;
  CmbVista.Left := 18;
  CmbVista.Top := 218;
  CmbVista.Width := 228;
  CmbVista.Style := csDropDownList;
  CmbVista.Items.Add('Todas las acciones');
  CmbVista.Items.Add('Solo prioridad ALTA');
  CmbVista.Items.Add('Solo prioridad MEDIA/ALTA');
  CmbVista.Items.Add('Solo datos maestros');
  CmbVista.Items.Add('Solo VeriFactu/promociones');
  CmbVista.ItemIndex := 0;
  CmbVista.OnChange := @VistaChange;

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 20;
  L.Top := 270;
  L.Width := 225;
  L.Height := 135;
  L.WordWrap := True;
  L.Caption := 'Este módulo no arregla automáticamente nada: ordena las tareas para decidir qué conviene revisar primero.';
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(10,45,95);

  MemoResumen := TMemo.Create(Self);
  MemoResumen.Parent := InfoPanel;
  MemoResumen.Left := 18;
  MemoResumen.Top := 430;
  MemoResumen.Width := 228;
  MemoResumen.Height := 205;
  MemoResumen.ScrollBars := ssVertical;
  MemoResumen.ReadOnly := True;
  MemoResumen.Color := RGBToColor(252,254,255);
  MemoResumen.Lines.Text := 'Pendiente de análisis.' + LineEnding +
                            'Solo se usan consultas de lectura.';

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

procedure TAccionesRecomendadasForm.ResetGrid;
begin
  Grid.ColCount := 6;
  Grid.RowCount := 1;
  Grid.Cells[0,0] := 'Prioridad';
  Grid.Cells[1,0] := 'Área';
  Grid.Cells[2,0] := 'Acción recomendada';
  Grid.Cells[3,0] := 'Motivo';
  Grid.Cells[4,0] := 'Referencia';
  Grid.Cells[5,0] := 'Detalle';
  AjustarColumnas;
end;

procedure TAccionesRecomendadasForm.AddRow(const Prioridad, Area, Accion, Motivo, Referencia, Detalle: string);
var
  R: Integer;
  V: Integer;
begin
  V := CmbVista.ItemIndex;
  if (V = 1) and (Prioridad <> 'ALTA') then Exit;
  if (V = 2) and not ((Prioridad = 'ALTA') or (Prioridad = 'MEDIA')) then Exit;
  if (V = 3) and not ((Area = 'Artículos') or (Area = 'Clientes')) then Exit;
  if (V = 4) and not ((Area = 'VeriFactu') or (Area = 'Promociones')) then Exit;

  R := Grid.RowCount;
  Grid.RowCount := R + 1;
  Grid.Cells[0,R] := Prioridad;
  Grid.Cells[1,R] := Area;
  Grid.Cells[2,R] := Accion;
  Grid.Cells[3,R] := Motivo;
  Grid.Cells[4,R] := Referencia;
  Grid.Cells[5,R] := Detalle;
end;

procedure TAccionesRecomendadasForm.AplicarEstiloGrid;
begin
  FLXGridPreparar(Grid);
  Grid.DefaultRowHeight := 26;
  Grid.RowHeights[0] := 30;
  Grid.Font.Size := 9;
end;

procedure TAccionesRecomendadasForm.AjustarColumnas;
begin
  if Grid = nil then Exit;
  Grid.ColWidths[0] := 90;
  Grid.ColWidths[1] := 125;
  Grid.ColWidths[2] := 245;
  Grid.ColWidths[3] := 285;
  Grid.ColWidths[4] := 120;
  Grid.ColWidths[5] := 440;
end;

procedure TAccionesRecomendadasForm.LimpiarKPIs;
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

procedure TAccionesRecomendadasForm.ActualizarKPIs;
var
  R, Pct: Integer;
  P: string;
begin
  LimpiarKPIs;
  for R := 1 to Grid.RowCount - 1 do
  begin
    Inc(FTotal);
    P := Grid.Cells[0,R];
    if P = 'ALTA' then Inc(FAltas)
    else if P = 'MEDIA' then Inc(FMedias)
    else if P = 'AVISO' then Inc(FAvisos)
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

function TAccionesRecomendadasForm.CleanIdent(const S: string): string;
begin
  Result := StringReplace(S, '`', '', [rfReplaceAll]);
end;

function TAccionesRecomendadasForm.SQLIdent(const S: string): string;
begin
  Result := '`' + CleanIdent(S) + '`';
end;

function TAccionesRecomendadasForm.TableName(const Prefix: string): string;
begin
  Result := Prefix + FTienda;
end;

function TAccionesRecomendadasForm.DBName: string;
begin
  Result := '';
  if FConn <> nil then Result := FConn.Database;
end;

function TAccionesRecomendadasForm.TableExists(const ATable: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (FConn = nil) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.TABLES ' +
                  'WHERE TABLE_SCHEMA = :db AND TABLE_NAME = :t';
    Q.ParamByName('db').AsString := DBName;
    Q.ParamByName('t').AsString := CleanIdent(ATable);
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  except
    Result := False;
  end;
  Q.Free;
end;

function TAccionesRecomendadasForm.ColumnExists(const ATable, AColumn: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (FConn = nil) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.COLUMNS ' +
                  'WHERE TABLE_SCHEMA = :db AND TABLE_NAME = :t AND COLUMN_NAME = :c';
    Q.ParamByName('db').AsString := DBName;
    Q.ParamByName('t').AsString := CleanIdent(ATable);
    Q.ParamByName('c').AsString := CleanIdent(AColumn);
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  except
    Result := False;
  end;
  Q.Free;
end;

function TAccionesRecomendadasForm.ScalarInt(const ASQL: string; const ADefault: Integer): Integer;
var
  Q: TZQuery;
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

procedure TAccionesRecomendadasForm.AnalizarVeriFactu;
var
  Pend, Err, ErrTec, Proc: Integer;
begin
  if not TableExists('verifactu_queue') then
  begin
    AddRow('AVISO', 'VeriFactu', 'Comprobar instalación VeriFactu', 'No se encuentra verifactu_queue', 'verifactu_queue', 'Puede ser normal si esta base aún no tiene VeriFactu activado.');
    Exit;
  end;

  Pend := ScalarInt('SELECT COUNT(*) FROM verifactu_queue WHERE estado=''PENDIENTE''', 0);
  Err := ScalarInt('SELECT COUNT(*) FROM verifactu_queue WHERE estado=''ERROR''', 0);
  ErrTec := ScalarInt('SELECT COUNT(*) FROM verifactu_queue WHERE estado=''ERROR_TECNICO''', 0);
  Proc := ScalarInt('SELECT COUNT(*) FROM verifactu_queue WHERE estado=''EN_PROCESO''', 0);

  if Pend > 0 then
    AddRow('ALTA', 'VeriFactu', 'Revisar documentos pendientes', 'Hay documentos pendientes de envío', IntToStr(Pend), 'Abrir monitor VeriFactu y revisar cola pendiente.');
  if Err > 0 then
    AddRow('ALTA', 'VeriFactu', 'Revisar errores VeriFactu', 'Existen documentos con ERROR', IntToStr(Err), 'Revisar respuesta AEAT o error de validación antes de darlo por correcto.');
  if ErrTec > 0 then
    AddRow('ALTA', 'VeriFactu', 'Revisar errores técnicos', 'Existen documentos con ERROR_TECNICO', IntToStr(ErrTec), 'Revisar conectividad, certificados, servicio local o reintento manual según versión instalada.');
  if Proc > 0 then
    AddRow('MEDIA', 'VeriFactu', 'Comprobar documentos en proceso', 'Hay documentos EN_PROCESO', IntToStr(Proc), 'Si permanecen mucho tiempo, revisar monitor o servicio de envío.');
  if (Pend = 0) and (Err = 0) and (ErrTec = 0) and (Proc = 0) then
    AddRow('OK', 'VeriFactu', 'Sin acciones prioritarias', 'Cola sin pendientes ni errores', '-', 'Estado correcto en esta revisión.');
end;

procedure TAccionesRecomendadasForm.AnalizarPromociones;
var
  T: string;
  N: Integer;
begin
  T := TableName('promo');
  if TableExists(T) and ColumnExists(T, 'P6') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(T) +
                   ' WHERE P6 IS NOT NULL AND P6 <> ''0000-00-00'' AND P6 < CURDATE()', 0);
    if N > 0 then
      AddRow('MEDIA', 'Promociones', 'Revisar promociones caducadas', 'Hay promociones con fecha fin vencida', IntToStr(N), 'Revisar si deben desactivarse, prorrogarse o archivarse.');
  end;

  T := TableName('promo_rules');
  if TableExists(T) and ColumnExists(T, 'activo') and ColumnExists(T, 'fin_dt') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(T) +
                   ' WHERE activo=''S'' AND fin_dt IS NOT NULL AND fin_dt < NOW()', 0);
    if N > 0 then
      AddRow('MEDIA', 'Promociones', 'Revisar reglas caducadas activas', 'Hay reglas activas con fin vencido', IntToStr(N), 'Evita reglas antiguas activas en futuras ventas.');
  end;
end;

procedure TAccionesRecomendadasForm.AnalizarArticulos;
var
  T: string;
  N: Integer;
begin
  T := TableName('artitien');
  if not TableExists(T) then
  begin
    AddRow('ALTA', 'Artículos', 'Comprobar tabla de artículos', 'No se encuentra ' + T, T, 'Sin tabla de artículos no se pueden proponer acciones de artículos.');
    Exit;
  end;

  if ColumnExists(T, 'A32') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(T) + ' WHERE IFNULL(A32,0)=0', 0);
    if N > 0 then
      AddRow('MEDIA', 'Artículos', 'Asignar proveedor en ficha', 'Artículos sin proveedor principal', IntToStr(N), 'Mejora pedidos, asesor de compras y análisis por proveedor.');
  end;

  if ColumnExists(T, 'A14') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(T) + ' WHERE IFNULL(A14,0)=0', 0);
    if N > 0 then
      AddRow('BAJA', 'Artículos', 'Asignar familia', 'Artículos sin familia', IntToStr(N), 'Mejora tendencias, rentabilidad y estadísticas por familia.');
  end;

  if ColumnExists(T, 'A2') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(T) + ' WHERE IFNULL(A2,0)<=0', 0);
    if N > 0 then
      AddRow('MEDIA', 'Artículos', 'Revisar PVP cero o negativo', 'Artículos con PVP no válido', IntToStr(N), 'Puede provocar ventas sin importe o márgenes incorrectos.');
  end;

  if ColumnExists(T, 'A24') and ColumnExists(T, 'A21') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(T) +
                   ' WHERE IFNULL(A24,0)>IFNULL(A21,0) AND IFNULL(A21,0)>0', 0);
    if N > 0 then
      AddRow('ALTA', 'Artículos', 'Revisar posible pérdida', 'Coste superior al PVP sin IVA', IntToStr(N), 'Prioritario para rentabilidad. Revisar coste A24, PVP sin IVA A21 o IVA.');
  end
  else if ColumnExists(T, 'A24') and ColumnExists(T, 'A2') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(T) +
                   ' WHERE IFNULL(A24,0)>IFNULL(A2,0) AND IFNULL(A2,0)>0', 0);
    if N > 0 then
      AddRow('ALTA', 'Artículos', 'Revisar posible pérdida', 'Coste superior al PVP con IVA', IntToStr(N), 'Revisión conservadora porque no se localizó A21. Revisar coste A24 y PVP A2.');
  end;
end;

procedure TAccionesRecomendadasForm.AnalizarClientes;
var
  N: Integer;
begin
  if not TableExists('clientes') then Exit;
  if not ColumnExists('clientes', 'C5') then
  begin
    AddRow('AVISO', 'Clientes', 'Comprobar campo NIF/CIF', 'No se pudo usar el campo C5', 'clientes', 'La estructura de clientes puede usar otro nombre de campo.');
    Exit;
  end;

  N := ScalarInt('SELECT COUNT(*) FROM clientes WHERE IFNULL(TRIM(C5),'''')='''' OR LENGTH(TRIM(C5))<8', 0);
  if N > 0 then
    AddRow('BAJA', 'Clientes', 'Revisar NIF/CIF incompletos', 'Clientes sin NIF/CIF válido aparente', IntToStr(N), 'Útil para facturación completa, VeriFactu y calidad de datos.');
end;

procedure TAccionesRecomendadasForm.AnalizarClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  BtnAnalizar.Enabled := False;
  try
    ResetGrid;
    MemoResumen.Clear;
    MemoResumen.Lines.Add('Análisis iniciado: ' + DateTimeToStr(Now));
    MemoResumen.Lines.Add('Filtro: ' + CmbVista.Text);
    if (FConn = nil) or (not FConn.Connected) then
    begin
      AddRow('ALTA', 'Sistema', 'Revisar conexión de base de datos', 'No hay conexión activa', '-', 'No se puede analizar sin conexión.');
      RefrescarResumen;
      Exit;
    end;

    AnalizarVeriFactu;
    AnalizarPromociones;
    AnalizarArticulos;
    AnalizarClientes;

    if Grid.RowCount = 1 then
      AddRow('OK', 'General', 'Sin acciones destacadas', 'No se han detectado acciones con los criterios actuales', '-', 'Puedes cambiar el filtro de vista y volver a analizar.');

    RefrescarResumen;
    AjustarColumnas;
  finally
    BtnAnalizar.Enabled := True;
    Screen.Cursor := crDefault;
  end;
end;

procedure TAccionesRecomendadasForm.RefrescarResumen;
begin
  ActualizarKPIs;
  MemoResumen.Lines.Add('');
  MemoResumen.Lines.Add('Resultado visible:');
  MemoResumen.Lines.Add('Acciones: ' + IntToStr(FTotal));
  MemoResumen.Lines.Add('Alta: ' + IntToStr(FAltas));
  MemoResumen.Lines.Add('Media: ' + IntToStr(FMedias));
  MemoResumen.Lines.Add('Avisos: ' + IntToStr(FAvisos));
  MemoResumen.Lines.Add('OK: ' + IntToStr(FOK));
end;

procedure TAccionesRecomendadasForm.CSVClick(Sender: TObject);
begin
  if Grid.RowCount <= 1 then
  begin
    FLXWarning('No hay datos para exportar. Pulsa Analizar primero.', 'Acciones recomendadas');
    Exit;
  end;

  if FLXGuardarCSVConDialogo(Grid, 'Exportar acciones recomendadas',
     'acciones_recomendadas_' + FormatDateTime('yyyymmdd_hhnn', Now) + '.csv') then
    FLXInfo('CSV guardado correctamente.', 'Acciones recomendadas');
end;

procedure TAccionesRecomendadasForm.CerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TAccionesRecomendadasForm.VistaChange(Sender: TObject);
begin
  MemoResumen.Lines.Text := 'Filtro cambiado a: ' + CmbVista.Text + LineEnding +
                            'Pulsa Analizar para recalcular la bandeja visible.';
end;

procedure TAccionesRecomendadasForm.GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  C, R: Integer;
begin
  if Button <> mbLeft then Exit;
  Grid.MouseToCell(X, Y, C, R);
  if R = 0 then
    FLXGridOrdenar(Grid, C, FSortCol, FSortDesc);
end;

procedure TAccionesRecomendadasForm.GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
var
  P: string;
begin
  FLXGridPrepararCanvasSeleccion(Grid, aRow, aState);
  if (aRow <= 0) or (gdSelected in aState) then Exit;

  P := Grid.Cells[0,aRow];
  if P = 'ALTA' then Grid.Canvas.Brush.Color := RGBToColor(255,232,232)
  else if P = 'MEDIA' then Grid.Canvas.Brush.Color := RGBToColor(255,249,220)
  else if P = 'AVISO' then Grid.Canvas.Brush.Color := RGBToColor(242,242,242)
  else if P = 'OK' then Grid.Canvas.Brush.Color := RGBToColor(232,255,235);
  Grid.Canvas.Font.Color := clBlack;
end;

procedure MostrarAccionesRecomendadasFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  F: TAccionesRecomendadasForm;
begin
  F := TAccionesRecomendadasForm.CreateForm(AOwner, AConnection, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

end.
