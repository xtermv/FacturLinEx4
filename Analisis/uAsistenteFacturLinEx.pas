unit uAsistenteFacturLinEx;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, LCLType, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, Grids, DB, ZConnection, ZDataset,
  uFLXGridStyle, uFLXExport, uFLXIcons, uFLXDialogs;

procedure MostrarAsistenteFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);

implementation

type
  TAsistenteFacturLinExForm = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;
    FSortCol: Integer;
    FSortDesc: Boolean;

    FTotal: Integer;
    FAlta: Integer;
    FMedia: Integer;
    FBaja: Integer;
    FInfo: Integer;

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
    LblKPIInfo: TLabel;
    LblKPISalud: TLabel;

    BtnGenerar: TBitBtn;
    BtnCSV: TBitBtn;
    BtnCerrar: TBitBtn;

    procedure CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
    procedure CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer = 118);
    procedure CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
    procedure ResetGrid;
    procedure AddRow(const Prioridad, Area, Mensaje, Accion: string);
    procedure AplicarEstiloGrid;
    procedure AjustarColumnas;
    procedure LimpiarKPIs;
    procedure ActualizarKPIs;
    procedure RefrescarResumen;

    function DBName: string;
    function SQLIdent(const S: string): string;
    function TableName(const BaseName: string; const WithStore: Boolean = True): string;
    function TableExists(const ATable: string): Boolean;
    function ColumnExists(const ATable, AColumn: string): Boolean;
    function FirstExistingColumn(const ATable: string; const Candidates: array of string): string;
    function ScalarInt(const ASQL: string; const ADefault: Int64 = 0): Int64;
    function ScalarFloat(const ASQL: string; const ADefault: Double = 0): Double;
    function FiltroAcepta(const Prioridad, Area: string): Boolean;

    procedure GenerarResumen;
    procedure RevisarVentasHoy;
    procedure RevisarPendientesDatos;
    procedure RevisarPromociones;
    procedure RevisarVerifactu;
    procedure RevisarPreciosCostes;

    procedure GenerarClick(Sender: TObject);
    procedure CSVClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CerrarClick(Sender: TObject);
    procedure VistaChange(Sender: TObject);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
  public
    constructor CreateAsistente(AOwner: TComponent; AConnection: TZConnection; const ATienda: string); reintroduce;
  end;

procedure TAsistenteFacturLinExForm.CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
begin
  FLXSetBitBtnIcon(ABtn, AIcon, ASize);
end;

procedure TAsistenteFacturLinExForm.CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer);
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
  ABtn.Spacing := 4;
  CargarIconoBoton(ABtn, AIcon, 30);
end;

procedure TAsistenteFacturLinExForm.CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
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

constructor TAsistenteFacturLinExForm.CreateAsistente(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  Logo: TImage;
  Pic: TPicture;
  FN: string;
  L: TLabel;
begin
  inherited CreateNew(AOwner, 1);
  KeyPreview := True;
  OnKeyDown := @FormKeyDown;
  FConn := AConnection;
  FTienda := ATienda;
  FSortCol := -1;
  FSortDesc := False;

  Caption := 'FacturLinEx - Asistente diario';
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
  FN := FLXIconFile('inteligencia_asistente', 64);
  if FN = '' then FN := FLXIconFile('centro_inteligencia', 64);
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
  LblTitulo.Caption := 'Asistente diario';
  LblTitulo.Font.Size := 24;
  LblTitulo.Font.Style := [fsBold];
  LblTitulo.Font.Color := RGBToColor(0,32,80);

  LblSubtitulo := TLabel.Create(Self);
  LblSubtitulo.Parent := HeaderPanel;
  LblSubtitulo.Left := 114;
  LblSubtitulo.Top := 68;
  LblSubtitulo.Caption := 'Resumen práctico de qué conviene mirar primero. Solo lectura, sin modificar datos.';
  LblSubtitulo.Font.Size := 11;
  LblSubtitulo.Font.Color := RGBToColor(45,70,105);

  ActionPanel := TPanel.Create(Self);
  ActionPanel.Parent := HeaderPanel;
  ActionPanel.Align := alRight;
  ActionPanel.Width := 420;
  ActionPanel.BevelOuter := bvNone;
  ActionPanel.Color := HeaderPanel.Color;

  CrearBotonAccion(ActionPanel, BtnGenerar, 'Generar', 'actualizar', 16, 118);
  BtnGenerar.Hint := 'Generar resumen del asistente';
  BtnGenerar.OnClick := @GenerarClick;

  CrearBotonAccion(ActionPanel, BtnCSV, 'Exportar', 'exportar', 146, 118);
  BtnCSV.Hint := 'Exportar el resumen a CSV';
  BtnCSV.OnClick := @CSVClick;

  CrearBotonAccion(ActionPanel, BtnCerrar, 'Cerrar', 'cerrar', 276, 118);
  BtnCerrar.Hint := 'Cerrar asistente';
  BtnCerrar.OnClick := @CerrarClick;

  KPIPanel := TPanel.Create(Self);
  KPIPanel.Parent := Self;
  KPIPanel.Align := alBottom;
  KPIPanel.Height := 108;
  KPIPanel.BevelOuter := bvNone;
  KPIPanel.Color := RGBToColor(245,248,252);

  CrearKPI(KPIPanel, 'Tareas', 'inteligencia_asistente', 18, LblKPITotal);
  CrearKPI(KPIPanel, 'Alta', 'alertas', 248, LblKPIAlta);
  CrearKPI(KPIPanel, 'Media', 'acciones', 478, LblKPIMedia);
  CrearKPI(KPIPanel, 'Info', 'centro_inteligencia', 708, LblKPIInfo);
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
  LblSubtituloVista.Height := 120;
  LblSubtituloVista.WordWrap := True;
  LblSubtituloVista.Caption := 'El asistente no sustituye a Doctor, Alertas o Dashboard: ordena lo más importante para empezar el día.';
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
  CmbVista.Items.Add('Todo');
  CmbVista.Items.Add('Solo prioridad ALTA');
  CmbVista.Items.Add('Media/Alta');
  CmbVista.Items.Add('Datos maestros');
  CmbVista.Items.Add('Operativa / VeriFactu');
  CmbVista.ItemIndex := 0;
  CmbVista.OnChange := @VistaChange;

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 20;
  L.Top := 270;
  L.Width := 225;
  L.Height := 138;
  L.WordWrap := True;
  L.Caption := 'Pulsa Generar para obtener una lista corta de recomendaciones prácticas. Todas las comprobaciones son de lectura.';
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
  MemoResumen.Lines.Text := 'Pendiente de generar.' + LineEnding +
                            'Módulo de solo lectura.';

  ContentPanel := TPanel.Create(Self);
  ContentPanel.Parent := Self;
  ContentPanel.Align := alClient;
  ContentPanel.BevelOuter := bvNone;
  ContentPanel.BorderSpacing.Left := 12;
  ContentPanel.BorderSpacing.Top := 12;
  ContentPanel.BorderSpacing.Right := 12;
  ContentPanel.BorderSpacing.Bottom := 12;
  ContentPanel.Color := RGBToColor(245,248,252);

  Grid := TStringGrid.Create(Self);
  Grid.Parent := ContentPanel;
  Grid.Align := alClient;
  Grid.ColCount := 4;
  Grid.RowCount := 1;
  Grid.FixedRows := 1;
  Grid.Cells[0,0] := 'Prioridad';
  Grid.Cells[1,0] := 'Área';
  Grid.Cells[2,0] := 'Resumen';
  Grid.Cells[3,0] := 'Acción recomendada';
  Grid.OnMouseDown := @GridMouseDown;
  Grid.OnPrepareCanvas := @GridPrepareCanvas;
  AplicarEstiloGrid;
  LimpiarKPIs;
end;

procedure TAsistenteFacturLinExForm.AplicarEstiloGrid;
begin
  FLXGridPreparar(Grid);
  Grid.DefaultRowHeight := 26;
  Grid.RowHeights[0] := 30;
  Grid.ColWidths[0] := 95;
  Grid.ColWidths[1] := 170;
  Grid.ColWidths[2] := 620;
  Grid.ColWidths[3] := 420;
end;

procedure TAsistenteFacturLinExForm.AjustarColumnas;
begin
  FLXGridAutoAjustar(Grid, 80, 620);
  if Grid.ColWidths[2] < 420 then Grid.ColWidths[2] := 420;
  if Grid.ColWidths[3] < 330 then Grid.ColWidths[3] := 330;
end;

procedure TAsistenteFacturLinExForm.LimpiarKPIs;
begin
  FTotal := 0;
  FAlta := 0;
  FMedia := 0;
  FBaja := 0;
  FInfo := 0;
  ActualizarKPIs;
end;

procedure TAsistenteFacturLinExForm.ActualizarKPIs;
var
  Salud: Integer;
begin
  LblKPITotal.Caption := IntToStr(FTotal);
  LblKPIAlta.Caption := IntToStr(FAlta);
  LblKPIMedia.Caption := IntToStr(FMedia);
  LblKPIInfo.Caption := IntToStr(FInfo + FBaja);

  if FTotal = 0 then Salud := 100
  else
  begin
    Salud := 100 - (FAlta * 35) - (FMedia * 12) - (FBaja * 4);
    if Salud < 0 then Salud := 0;
    if Salud > 100 then Salud := 100;
  end;
  LblKPISalud.Caption := IntToStr(Salud) + ' %';
end;

procedure TAsistenteFacturLinExForm.ResetGrid;
begin
  Grid.RowCount := 1;
  FTotal := 0;
  FAlta := 0;
  FMedia := 0;
  FBaja := 0;
  FInfo := 0;
  FSortCol := -1;
  FSortDesc := False;
  Grid.Cells[0,0] := 'Prioridad';
  Grid.Cells[1,0] := 'Área';
  Grid.Cells[2,0] := 'Resumen';
  Grid.Cells[3,0] := 'Acción recomendada';
end;

function TAsistenteFacturLinExForm.FiltroAcepta(const Prioridad, Area: string): Boolean;
var
  P, A: string;
begin
  Result := True;
  if CmbVista.ItemIndex <= 0 then Exit;

  P := UpperCase(Trim(Prioridad));
  A := UpperCase(Trim(Area));

  case CmbVista.ItemIndex of
    1: Result := P = 'ALTA';
    2: Result := (P = 'ALTA') or (P = 'MEDIA');
    3: Result := (Pos('ART', A) > 0) or (Pos('CLIENT', A) > 0) or (Pos('PRECIO', A) > 0) or (Pos('COSTE', A) > 0);
    4: Result := (Pos('VERIFACTU', A) > 0) or (Pos('VENTAS', A) > 0) or (Pos('PROMO', A) > 0);
  end;
end;

procedure TAsistenteFacturLinExForm.AddRow(const Prioridad, Area, Mensaje, Accion: string);
var
  R: Integer;
  P: string;
begin
  P := UpperCase(Trim(Prioridad));

  Inc(FTotal);
  if P = 'ALTA' then Inc(FAlta)
  else if P = 'MEDIA' then Inc(FMedia)
  else if P = 'BAJA' then Inc(FBaja)
  else Inc(FInfo);

  if not FiltroAcepta(Prioridad, Area) then Exit;

  R := Grid.RowCount;
  Grid.RowCount := R + 1;
  Grid.Cells[0,R] := Prioridad;
  Grid.Cells[1,R] := Area;
  Grid.Cells[2,R] := Mensaje;
  Grid.Cells[3,R] := Accion;
end;

function TAsistenteFacturLinExForm.DBName: string;
begin
  Result := '';
  if Assigned(FConn) then Result := FConn.Database;
end;

function TAsistenteFacturLinExForm.SQLIdent(const S: string): string;
begin
  Result := '`' + StringReplace(S, '`', '', [rfReplaceAll]) + '`';
end;

function TAsistenteFacturLinExForm.TableName(const BaseName: string; const WithStore: Boolean): string;
begin
  if WithStore then Result := BaseName + FTienda else Result := BaseName;
end;

function TAsistenteFacturLinExForm.TableExists(const ATable: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (not Assigned(FConn)) or (ATable = '') then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=:db AND TABLE_NAME=:tb';
    Q.ParamByName('db').AsString := DBName;
    Q.ParamByName('tb').AsString := ATable;
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TAsistenteFacturLinExForm.ColumnExists(const ATable, AColumn: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (not Assigned(FConn)) or (ATable = '') or (AColumn = '') then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=:db AND TABLE_NAME=:tb AND COLUMN_NAME=:co';
    Q.ParamByName('db').AsString := DBName;
    Q.ParamByName('tb').AsString := ATable;
    Q.ParamByName('co').AsString := AColumn;
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TAsistenteFacturLinExForm.FirstExistingColumn(const ATable: string; const Candidates: array of string): string;
var
  I: Integer;
begin
  Result := '';
  for I := Low(Candidates) to High(Candidates) do
    if ColumnExists(ATable, Candidates[I]) then
    begin
      Result := Candidates[I];
      Exit;
    end;
end;

function TAsistenteFacturLinExForm.ScalarInt(const ASQL: string; const ADefault: Int64): Int64;
var
  Q: TZQuery;
begin
  Result := ADefault;
  if not Assigned(FConn) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := ASQL;
    Q.Open;
    if not Q.EOF then Result := Q.Fields[0].AsLargeInt;
  finally
    Q.Free;
  end;
end;

function TAsistenteFacturLinExForm.ScalarFloat(const ASQL: string; const ADefault: Double): Double;
var
  Q: TZQuery;
begin
  Result := ADefault;
  if not Assigned(FConn) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := ASQL;
    Q.Open;
    if not Q.EOF then Result := Q.Fields[0].AsFloat;
  finally
    Q.Free;
  end;
end;

procedure TAsistenteFacturLinExForm.RevisarVentasHoy;
var
  T, F, Total: string;
  N: Int64;
  Importe: Double;
begin
  T := TableName('hisopcc');
  if not TableExists(T) then Exit;
  F := FirstExistingColumn(T, ['HO0','fecha','Fecha']);
  Total := FirstExistingColumn(T, ['HO9','HO14','total','Total','importe']);
  if F = '' then Exit;

  N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(T) + ' WHERE DATE(' + SQLIdent(F) + ')=CURDATE()');
  if Total <> '' then
    Importe := ScalarFloat('SELECT COALESCE(SUM(' + SQLIdent(Total) + '),0) FROM ' + SQLIdent(T) + ' WHERE DATE(' + SQLIdent(F) + ')=CURDATE()')
  else
    Importe := 0;

  if N = 0 then
    AddRow('INFO', 'Ventas hoy', 'Todavía no hay documentos registrados hoy.',
      'No es un problema si aún no se ha abierto caja; revisar Dashboard/Hoy cuando empiece la venta.')
  else if Importe > 0 then
    AddRow('INFO', 'Ventas hoy', 'Hoy hay ' + IntToStr(N) + ' documentos registrados por aprox. ' + FormatFloat('#,##0.00', Importe) + ' €.',
      'Consultar Dashboard/Hoy para detalle por horas y formas de pago.')
  else
    AddRow('INFO', 'Ventas hoy', 'Hoy hay ' + IntToStr(N) + ' documentos registrados.',
      'Consultar Dashboard/Hoy para detalle por horas y formas de pago.');
end;

procedure TAsistenteFacturLinExForm.RevisarPendientesDatos;
var
  T, C: string;
  N: Int64;
begin
  T := TableName('artitien');
  if TableExists(T) then
  begin
    C := FirstExistingColumn(T, ['A1','descripcion','Descripcion','DESCRIPCION']);
    if C <> '' then
    begin
      N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(T) +
                     ' WHERE ' + SQLIdent(C) + ' LIKE ' + QuotedStr('%''%') +
                     ' OR ' + SQLIdent(C) + ' LIKE ' + QuotedStr('%"%') +
                     ' OR ' + SQLIdent(C) + ' LIKE ' + QuotedStr('%;%'));
      if N > 0 then
        AddRow('MEDIA', 'Artículos', 'Hay ' + IntToStr(N) + ' artículos con caracteres de riesgo en descripción.',
               'Revisar Doctor / Artículos para evitar errores al vender o facturar.');
    end;
  end;

  T := 'clientes';
  if TableExists(T) then
  begin
    C := FirstExistingColumn(T, ['C5','CL2','nif','NIF','cif','CIF']);
    if C <> '' then
    begin
      N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(T) + ' WHERE COALESCE(TRIM(' + SQLIdent(C) + '),'''')=''''');
      if N > 0 then
        AddRow('BAJA', 'Clientes', 'Hay ' + IntToStr(N) + ' clientes sin NIF/CIF informado.',
               'Revisar clientes usados en factura completa o administraciones públicas.');
    end;
  end;
end;

procedure TAsistenteFacturLinExForm.RevisarPromociones;
var
  T, FFin, Act, SQL: string;
  N: Int64;
begin
  T := TableName('promo');
  if not TableExists(T) then Exit;
  FFin := FirstExistingColumn(T, ['fecha_fin','FechaFin','FIN','PFIN']);
  Act := FirstExistingColumn(T, ['activo','ACTIVO','Activa']);
  if FFin = '' then Exit;

  if Act <> '' then
  begin
    SQL := 'SELECT COUNT(*) FROM ' + SQLIdent(T) +
           ' WHERE DATE(' + SQLIdent(FFin) + ') < CURDATE() ' +
           ' AND UPPER(COALESCE(' + SQLIdent(Act) + ','''')) IN (''S'',''SI'',''1'',''T'')';
    N := ScalarInt(SQL);
  end
  else
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(T) + ' WHERE DATE(' + SQLIdent(FFin) + ') < CURDATE()');

  if N > 0 then
    AddRow('ALTA', 'Promociones', 'Hay ' + IntToStr(N) + ' promociones caducadas que conviene revisar.',
           'Abrir promociones y desactivar o corregir fechas si procede.');
end;

procedure TAsistenteFacturLinExForm.RevisarVerifactu;
var
  T, C: string;
  N: Int64;
begin
  T := 'verifactu_queue';
  if not TableExists(T) then Exit;
  C := FirstExistingColumn(T, ['estado','Estado']);
  if C = '' then Exit;

  N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(T) + ' WHERE UPPER(COALESCE(' + SQLIdent(C) + ','''')) IN (''PENDIENTE'',''EN_PROCESO'',''ERROR_TECNICO'')');
  if N > 0 then
    AddRow('ALTA', 'VeriFactu', 'Hay ' + IntToStr(N) + ' registros VeriFactu pendientes o técnicos.',
           'Abrir Monitor VeriFactu y revisar antes de cerrar el día.')
  else
    AddRow('OK', 'VeriFactu', 'No se detectan pendientes técnicos destacados en la cola.',
           'Continuar; revisar monitor si hay avisos de AEAT.');
end;

procedure TAsistenteFacturLinExForm.RevisarPreciosCostes;
var
  T: string;
  NCoste, NPVP: Int64;
begin
  T := TableName('artitien');
  if not TableExists(T) then Exit;
  if not ColumnExists(T, 'A24') then Exit;

  NCoste := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(T) + ' WHERE COALESCE(A24,0)<=0');
  if ColumnExists(T, 'A2') then
    NPVP := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(T) + ' WHERE COALESCE(A2,0)<=0')
  else
    NPVP := 0;

  if NCoste > 0 then
    AddRow('MEDIA', 'Precios/Costes', 'Hay ' + IntToStr(NCoste) + ' artículos sin coste o con coste cero.',
           'Revisar Rentabilidad antes de tomar decisiones de margen.');

  if NPVP > 0 then
    AddRow('ALTA', 'Precios/Costes', 'Hay ' + IntToStr(NPVP) + ' artículos sin PVP con IVA.',
           'Revisar ficha de artículos antes de venderlos.');
end;

procedure TAsistenteFacturLinExForm.RefrescarResumen;
begin
  MemoResumen.Lines.Clear;
  MemoResumen.Lines.Add('Generado: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
  MemoResumen.Lines.Add('');
  MemoResumen.Lines.Add('Tareas totales: ' + IntToStr(FTotal));
  MemoResumen.Lines.Add('Prioridad alta: ' + IntToStr(FAlta));
  MemoResumen.Lines.Add('Prioridad media: ' + IntToStr(FMedia));
  MemoResumen.Lines.Add('Información / baja: ' + IntToStr(FInfo + FBaja));
  MemoResumen.Lines.Add('');
  if FAlta > 0 then
    MemoResumen.Lines.Add('Recomendación: atender primero las líneas ALTA.')
  else if FMedia > 0 then
    MemoResumen.Lines.Add('Recomendación: revisar medias cuando haya hueco.')
  else
    MemoResumen.Lines.Add('Recomendación: no hay avisos críticos destacados.');
end;

procedure TAsistenteFacturLinExForm.GenerarResumen;
begin
  ResetGrid;
  try
    RevisarVentasHoy;
    RevisarVerifactu;
    RevisarPromociones;
    RevisarPreciosCostes;
    RevisarPendientesDatos;

    if FTotal = 0 then
      AddRow('OK', 'General', 'No se han detectado avisos destacados en esta revisión básica.',
             'Seguir trabajando normalmente.');

    ActualizarKPIs;
    RefrescarResumen;

    if Grid.RowCount = 1 then
      AddRow('INFO', 'Filtro', 'Hay avisos, pero el filtro actual no muestra ninguno.',
             'Cambiar el filtro a Todo para ver el resumen completo.');

    AjustarColumnas;
  except
    on E: Exception do
    begin
      AddRow('ERROR', 'Asistente', E.Message, 'Revisar el mensaje y continuar con Doctor/Alertas si hace falta.');
      ActualizarKPIs;
      RefrescarResumen;
    end;
  end;
end;

procedure TAsistenteFacturLinExForm.GenerarClick(Sender: TObject);
begin
  GenerarResumen;
end;

procedure TAsistenteFacturLinExForm.CSVClick(Sender: TObject);
var
  FN: string;
begin
  FN := 'asistente_facturlinex_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.csv';
  if FLXGuardarCSVConDialogo(Grid, 'Exportar Asistente diario', FN) then
    FLXInfo('CSV generado correctamente.', 'Asistente diario');
end;

procedure TAsistenteFacturLinExForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then Exit;

  // Si hay un desplegable activo, ESC lo cierra antes de salir del formulario.
  if (ActiveControl is TComboBox) and TComboBox(ActiveControl).DroppedDown then
  begin
    TComboBox(ActiveControl).DroppedDown := False;
    Key := 0;
    Exit;
  end;

  Key := 0;
  CerrarClick(Self);
end;

procedure TAsistenteFacturLinExForm.CerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TAsistenteFacturLinExForm.VistaChange(Sender: TObject);
begin
  GenerarResumen;
end;

procedure TAsistenteFacturLinExForm.GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  C, R: Integer;
begin
  if Button <> mbLeft then Exit;
  Grid.MouseToCell(X, Y, C, R);
  if (R = 0) and (C >= 0) then
    FLXGridOrdenar(Grid, C, FSortCol, FSortDesc);
end;

procedure TAsistenteFacturLinExForm.GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
begin
  FLXGridPrepararCanvasSeleccion(Grid, aRow, aState);
end;

procedure MostrarAsistenteFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  F: TAsistenteFacturLinExForm;
begin
  F := TAsistenteFacturLinExForm.CreateAsistente(AOwner, AConnection, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

end.
