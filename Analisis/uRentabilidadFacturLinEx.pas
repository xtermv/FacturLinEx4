unit uRentabilidadFacturLinEx;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, StdCtrls, Buttons,
  Grids, Graphics, DB, ZConnection, ZDataset,
  uFLXGridStyle, uFLXExport, uFLXIcons, uFLXDialogs;

procedure MostrarRentabilidadFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);

implementation

type
  TRentabilidadFacturLinExForm = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;
    Grid: TStringGrid;
    Memo: TMemo;
    BtnArticulos: TBitBtn;
    BtnFamilias: TBitBtn;
    BtnProveedores: TBitBtn;
    BtnActualizar: TBitBtn;
    BtnCSV: TBitBtn;
    BtnCerrar: TBitBtn;
    EditFiltro: TEdit;
    FSortCol: Integer;
    FSortDesc: Boolean;
    FVistaActual: string;
    FTotalLineas: Integer;
    FCriticos: Integer;
    FSinCoste: Integer;
    FSinPVP: Integer;
    FMargenAcum: Double;
    FMargenNum: Integer;
    HeaderPanel: TPanel;
    ActionPanel: TPanel;
    InfoPanel: TPanel;
    ContentPanel: TPanel;
    TitlePanel: TPanel;
    KPIPanel: TPanel;
    LblTitulo: TLabel;
    LblSubtitulo: TLabel;
    LblVistaActual: TLabel;
    LblSubtituloVista: TLabel;
    LblKPILineas: TLabel;
    LblKPIMargen: TLabel;
    LblKPISinCoste: TLabel;
    LblKPISinPVP: TLabel;
    LblKPICriticos: TLabel;
    procedure CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
    procedure CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer = 118);
    procedure CrearBotonVista(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ATop: Integer);
    procedure CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
    function DBName: string;
    function CleanIdent(const S: string): string;
    function SQLIdent(const S: string): string;
    function ArtTable: string;
    function FamTable: string;
    function TableExists(const ATable: string): Boolean;
    procedure ResetGrid(const Headers: array of string);
    procedure AddRow(const Values: array of string);
    procedure AplicarEstiloGrid;
    procedure AjustarColumnas;
    procedure LimpiarKPIs;
    procedure AcumularMargen(AMargen: Double);
    procedure IncAvisos(const Aviso: string; SinCoste, SinPVP: Boolean);
    procedure ActualizarKPIs;
    function Money4(V: Double): string;
    function Porc2(V: Double): string;
    function AvisoRentabilidad(Coste, PVP, PVPIVA, Margen: Double): string;
    procedure CargarArticulos;
    procedure CargarAgrupado(const Campo, Titulo: string);
    procedure RecargarVista;
    procedure ArticulosClick(Sender: TObject);
    procedure FamiliasClick(Sender: TObject);
    procedure ProveedoresClick(Sender: TObject);
    procedure ActualizarClick(Sender: TObject);
    procedure CSVClick(Sender: TObject);
    procedure CerrarClick(Sender: TObject);
    procedure GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  public
    constructor CreateRentabilidad(AOwner: TComponent; AConnection: TZConnection; const ATienda: string); reintroduce;
  end;

procedure TRentabilidadFacturLinExForm.CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
begin
  FLXSetBitBtnIcon(ABtn, AIcon, ASize);
end;

procedure TRentabilidadFacturLinExForm.CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer);
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

procedure TRentabilidadFacturLinExForm.CrearBotonVista(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ATop: Integer);
begin
  ABtn := TBitBtn.Create(Self);
  ABtn.Parent := AParent;
  ABtn.Left := 18;
  ABtn.Top := ATop;
  ABtn.Width := 205;
  ABtn.Height := 52;
  ABtn.Caption := ACaption;
  ABtn.Layout := blGlyphLeft;
  ABtn.Font.Style := [fsBold];
  CargarIconoBoton(ABtn, AIcon, 30);
end;

procedure TRentabilidadFacturLinExForm.CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
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

constructor TRentabilidadFacturLinExForm.CreateRentabilidad(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
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
  FVistaActual := 'ARTICULOS';

  Caption := 'FacturLinEx - Rentabilidad';
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
  FN := FLXIconFile('rentabilidad', 64);
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
  LblTitulo.Caption := 'Rentabilidad';
  LblTitulo.Font.Size := 24;
  LblTitulo.Font.Style := [fsBold];
  LblTitulo.Font.Color := RGBToColor(0,32,80);

  LblSubtitulo := TLabel.Create(Self);
  LblSubtitulo.Parent := HeaderPanel;
  LblSubtitulo.Left := 114;
  LblSubtitulo.Top := 68;
  LblSubtitulo.Caption := 'Foto de márgenes teóricos por artículo, familia y proveedor. Consulta segura de solo lectura.';
  LblSubtitulo.Font.Size := 11;
  LblSubtitulo.Font.Color := RGBToColor(45,70,105);

  ActionPanel := TPanel.Create(Self);
  ActionPanel.Parent := HeaderPanel;
  ActionPanel.Align := alRight;
  ActionPanel.Width := 430;
  ActionPanel.BevelOuter := bvNone;
  ActionPanel.Color := HeaderPanel.Color;

  CrearBotonAccion(ActionPanel, BtnActualizar, 'Actualizar', 'tend_actualizar', 8, 124);
  BtnActualizar.OnClick := @ActualizarClick;
  CrearBotonAccion(ActionPanel, BtnCSV, 'Exportar', 'tend_exportar', 146, 118);
  BtnCSV.OnClick := @CSVClick;
  CrearBotonAccion(ActionPanel, BtnCerrar, 'Cerrar', 'tend_cerrar', 278, 118);
  BtnCerrar.OnClick := @CerrarClick;

  InfoPanel := TPanel.Create(Self);
  InfoPanel.Parent := Self;
  InfoPanel.Align := alLeft;
  InfoPanel.Width := 245;
  InfoPanel.BevelOuter := bvLowered;
  InfoPanel.Color := RGBToColor(248,251,255);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 18;
  L.Caption := 'Vistas';
  L.Font.Size := 12;
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,65,145);

  CrearBotonVista(InfoPanel, BtnArticulos, 'Artículos', 'tend_articulos', 50);
  BtnArticulos.OnClick := @ArticulosClick;
  CrearBotonVista(InfoPanel, BtnFamilias, 'Familias', 'tend_familias', 110);
  BtnFamilias.OnClick := @FamiliasClick;
  CrearBotonVista(InfoPanel, BtnProveedores, 'Proveedores', 'tend_proveedores', 170);
  BtnProveedores.OnClick := @ProveedoresClick;

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 246;
  L.Caption := 'Filtro';
  L.Font.Size := 12;
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,65,145);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 278;
  L.Width := 205;
  L.Height := 34;
  L.WordWrap := True;
  L.Caption := 'Código o descripción en artículos:';
  L.Font.Color := RGBToColor(45,70,105);

  EditFiltro := TEdit.Create(Self);
  EditFiltro.Parent := InfoPanel;
  EditFiltro.Left := 18;
  EditFiltro.Top := 316;
  EditFiltro.Width := 205;
  EditFiltro.Height := 28;

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 382;
  L.Caption := 'Criterios';
  L.Font.Size := 12;
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,65,145);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 420;
  L.Width := 205;
  L.Height := 190;
  L.WordWrap := True;
  L.Caption := 'Se usa coste A24, PVP con IVA A2 y PVP sin IVA A21 de artitien' + FTienda + '.' + LineEnding +
               'Avisos: sin coste, sin PVP, pérdida teórica y margen bajo.' + LineEnding +
               'La pantalla no modifica datos ni crea tablas.';
  L.Font.Color := RGBToColor(45,70,105);

  ContentPanel := TPanel.Create(Self);
  ContentPanel.Parent := Self;
  ContentPanel.Align := alClient;
  ContentPanel.BevelOuter := bvNone;
  ContentPanel.Color := RGBToColor(245,248,252);

  TitlePanel := TPanel.Create(Self);
  TitlePanel.Parent := ContentPanel;
  TitlePanel.Align := alTop;
  TitlePanel.Height := 62;
  TitlePanel.BevelOuter := bvLowered;
  TitlePanel.Color := RGBToColor(250,252,255);

  LblVistaActual := TLabel.Create(Self);
  LblVistaActual.Parent := TitlePanel;
  LblVistaActual.Left := 16;
  LblVistaActual.Top := 14;
  LblVistaActual.Caption := 'Rentabilidad por artículos';
  LblVistaActual.Font.Size := 12;
  LblVistaActual.Font.Style := [fsBold];
  LblVistaActual.Font.Color := RGBToColor(0,65,145);

  LblSubtituloVista := TLabel.Create(Self);
  LblSubtituloVista.Parent := TitlePanel;
  LblSubtituloVista.Left := 16;
  LblSubtituloVista.Top := 38;
  LblSubtituloVista.Caption := 'Use las vistas laterales y ordene por cabeceras para detectar márgenes bajos o negativos.';
  LblSubtituloVista.Font.Color := RGBToColor(45,70,105);

  KPIPanel := TPanel.Create(Self);
  KPIPanel.Parent := ContentPanel;
  KPIPanel.Align := alBottom;
  KPIPanel.Height := 108;
  KPIPanel.BevelOuter := bvLowered;
  KPIPanel.Color := RGBToColor(250,252,255);

  CrearKPI(KPIPanel, 'Líneas', 'tend_resumen', 12, LblKPILineas);
  CrearKPI(KPIPanel, 'Margen medio', 'tend_kpi_margen', 252, LblKPIMargen);
  CrearKPI(KPIPanel, 'Sin coste', 'tend_configuracion', 492, LblKPISinCoste);
  CrearKPI(KPIPanel, 'Sin PVP', 'historico_precios', 732, LblKPISinPVP);
  CrearKPI(KPIPanel, 'Críticos', 'alertas', 972, LblKPICriticos);

  Grid := TStringGrid.Create(Self);
  Grid.Parent := ContentPanel;
  Grid.Align := alClient;
  Grid.OnMouseDown := @GridMouseDown;
  Grid.OnPrepareCanvas := @GridPrepareCanvas;
  AplicarEstiloGrid;

  Memo := TMemo.Create(Self);
  Memo.Parent := Self;
  Memo.Align := alBottom;
  Memo.Height := 78;
  Memo.ReadOnly := True;
  Memo.ScrollBars := ssVertical;
  Memo.Color := RGBToColor(250,252,255);
  Memo.Lines.Text := 'Rentabilidad lista. Vista inicial: artículos.' + LineEnding +
                     'Cálculo teórico: margen = (PVP sin IVA - coste) / PVP sin IVA.' + LineEnding +
                     'Modo seguro: solo lectura, sin cambios en artículos, familias ni proveedores.';

  CargarArticulos;
end;

function TRentabilidadFacturLinExForm.DBName: string;
begin
  Result := '';
  if Assigned(FConn) then Result := FConn.Database;
end;

function TRentabilidadFacturLinExForm.CleanIdent(const S: string): string;
begin
  Result := StringReplace(S, '`', '', [rfReplaceAll]);
end;

function TRentabilidadFacturLinExForm.SQLIdent(const S: string): string;
begin
  Result := '`' + CleanIdent(S) + '`';
end;

function TRentabilidadFacturLinExForm.ArtTable: string;
begin
  Result := 'artitien' + FTienda;
end;

function TRentabilidadFacturLinExForm.FamTable: string;
begin
  Result := 'familias' + FTienda;
end;

function TRentabilidadFacturLinExForm.TableExists(const ATable: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (not Assigned(FConn)) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    try
      Q.Connection := FConn;
      Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=:DB AND TABLE_NAME=:T';
      Q.ParamByName('DB').AsString := DBName;
      Q.ParamByName('T').AsString := CleanIdent(ATable);
      Q.Open;
      Result := Q.FieldByName('C').AsInteger > 0;
    except
      Result := False;
    end;
  finally
    Q.Free;
  end;
end;

procedure TRentabilidadFacturLinExForm.ResetGrid(const Headers: array of string);
var
  I: Integer;
begin
  Grid.BeginUpdate;
  try
    Grid.ColCount := Length(Headers);
    Grid.FixedRows := 1;
    Grid.RowCount := 1;
    for I := Low(Headers) to High(Headers) do
      Grid.Cells[I,0] := Headers[I];
    FSortCol := -1;
    FSortDesc := False;
    LimpiarKPIs;
  finally
    Grid.EndUpdate;
  end;
end;

procedure TRentabilidadFacturLinExForm.AddRow(const Values: array of string);
var
  R, I: Integer;
begin
  R := Grid.RowCount;
  Grid.RowCount := R + 1;
  for I := Low(Values) to High(Values) do
    if I < Grid.ColCount then Grid.Cells[I,R] := Values[I];
end;

procedure TRentabilidadFacturLinExForm.AplicarEstiloGrid;
begin
  FLXGridPreparar(Grid);
  Grid.Color := clWhite;
  Grid.FixedColor := RGBToColor(225,238,252);
  Grid.AlternateColor := RGBToColor(248,251,255);
  Grid.Font.Color := clBlack;
  Grid.TitleFont.Color := RGBToColor(0,32,80);
  Grid.TitleFont.Style := [fsBold];
  Grid.Options := Grid.Options + [goRowSelect, goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goThumbTracking];
end;

procedure TRentabilidadFacturLinExForm.AjustarColumnas;
var
  W, DescW: Integer;
begin
  if Grid.ColCount = 9 then
  begin
    W := Grid.ClientWidth - 60;
    if W < 1050 then W := 1050;
    DescW := W - 110 - 90 - 100 - 90 - 95 - 95 - 90 - 240;
    if DescW < 300 then DescW := 300;
    Grid.ColWidths[0] := 110;
    Grid.ColWidths[1] := DescW;
    Grid.ColWidths[2] := 90;
    Grid.ColWidths[3] := 100;
    Grid.ColWidths[4] := 90;
    Grid.ColWidths[5] := 95;
    Grid.ColWidths[6] := 95;
    Grid.ColWidths[7] := 90;
    Grid.ColWidths[8] := 240;
  end
  else if Grid.ColCount = 9 then
  begin
    FLXGridAutoAjustar(Grid, 80, 360);
  end
  else
    FLXGridAutoAjustar(Grid, 80, 360);
end;

procedure TRentabilidadFacturLinExForm.LimpiarKPIs;
begin
  FTotalLineas := 0;
  FCriticos := 0;
  FSinCoste := 0;
  FSinPVP := 0;
  FMargenAcum := 0;
  FMargenNum := 0;
end;

procedure TRentabilidadFacturLinExForm.AcumularMargen(AMargen: Double);
begin
  Inc(FMargenNum);
  FMargenAcum := FMargenAcum + AMargen;
end;

procedure TRentabilidadFacturLinExForm.IncAvisos(const Aviso: string; SinCoste, SinPVP: Boolean);
var
  A: string;
begin
  Inc(FTotalLineas);
  if SinCoste then Inc(FSinCoste);
  if SinPVP then Inc(FSinPVP);
  A := LowerCase(Aviso);
  if (Pos('pérdida', A) > 0) or (Pos('perdida', A) > 0) or (Pos('margen bajo', A) > 0) or (Pos('sin coste', A) > 0) or (Pos('sin pvp', A) > 0) then
    Inc(FCriticos);
end;

procedure TRentabilidadFacturLinExForm.ActualizarKPIs;
var
  M: Double;
begin
  LblKPILineas.Caption := IntToStr(FTotalLineas);
  if FMargenNum > 0 then M := FMargenAcum / FMargenNum else M := 0;
  LblKPIMargen.Caption := FormatFloat('0.00', M) + ' %';
  LblKPISinCoste.Caption := IntToStr(FSinCoste);
  LblKPISinPVP.Caption := IntToStr(FSinPVP);
  LblKPICriticos.Caption := IntToStr(FCriticos);
end;

function TRentabilidadFacturLinExForm.Money4(V: Double): string;
begin
  Result := FormatFloat('0.0000', V);
end;

function TRentabilidadFacturLinExForm.Porc2(V: Double): string;
begin
  Result := FormatFloat('0.00', V) + ' %';
end;

function TRentabilidadFacturLinExForm.AvisoRentabilidad(Coste, PVP, PVPIVA, Margen: Double): string;
begin
  Result := 'OK';
  if PVPIVA = 0 then Result := 'Sin PVP con IVA';
  if PVP = 0 then Result := 'Sin PVP sin IVA';
  if Coste = 0 then Result := 'Sin coste';
  if (PVP > 0) and (Coste > PVP) then Result := 'Pérdida teórica: coste mayor que PVP';
  if (PVP > 0) and (Coste > 0) and (Margen < 10) then Result := 'Margen bajo';
end;

procedure TRentabilidadFacturLinExForm.CargarArticulos;
var
  Q: TZQuery;
  T, Filtro, WhereSQL, Aviso: string;
  Coste, PVP, PVPIVA, Benef, Margen: Double;
begin
  FVistaActual := 'ARTICULOS';
  LblVistaActual.Caption := 'Rentabilidad por artículos';
  LblSubtituloVista.Caption := 'Detecta artículos con coste cero, PVP cero, pérdida teórica o margen bajo.';
  ResetGrid(['Código','Descripción','Familia','Proveedor','Coste','PVP c/IVA','PVP s/IVA','Margen','Aviso']);
  AjustarColumnas;

  T := ArtTable;
  if not TableExists(T) then
  begin
    AddRow(['','','','','','','','','No existe la tabla ' + T]);
    ActualizarKPIs;
    Exit;
  end;

  Filtro := Trim(EditFiltro.Text);
  WhereSQL := ' WHERE 1=1 ';
  if Filtro <> '' then
    WhereSQL := WhereSQL + ' AND (A0 LIKE ' + QuotedStr('%' + Filtro + '%') + ' OR A1 LIKE ' + QuotedStr('%' + Filtro + '%') + ') ';

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT A0,A1,A14,A32,A24,A2,A21 FROM ' + SQLIdent(T) + WhereSQL + ' ORDER BY A1 LIMIT 1500';
    Q.Open;
    while not Q.EOF do
    begin
      Coste := Q.FieldByName('A24').AsFloat;
      PVPIVA := Q.FieldByName('A2').AsFloat;
      PVP := Q.FieldByName('A21').AsFloat;
      Benef := PVP - Coste;
      Margen := 0;
      if PVP <> 0 then Margen := (Benef / PVP) * 100;
      Aviso := AvisoRentabilidad(Coste, PVP, PVPIVA, Margen);

      AddRow([Q.FieldByName('A0').AsString,
              Q.FieldByName('A1').AsString,
              Q.FieldByName('A14').AsString,
              Q.FieldByName('A32').AsString,
              Money4(Coste), Money4(PVPIVA), Money4(PVP), Porc2(Margen), Aviso]);
      AcumularMargen(Margen);
      IncAvisos(Aviso, Coste = 0, (PVP = 0) or (PVPIVA = 0));
      Q.Next;
    end;
    if Grid.RowCount = 1 then AddRow(['','','','','','','','','Sin resultados']);
  finally
    Q.Free;
  end;
  AjustarColumnas;
  ActualizarKPIs;
end;

procedure TRentabilidadFacturLinExForm.CargarAgrupado(const Campo, Titulo: string);
var
  Q: TZQuery;
  T, Aviso, SQLJoin, SQLDesc, GroupExpr: string;
  Coste, PVP, Margen: Double;
  SinCoste, SinPVP: Integer;
begin
  FVistaActual := UpperCase(Titulo);
  LblVistaActual.Caption := 'Rentabilidad por ' + LowerCase(Titulo);
  LblSubtituloVista.Caption := 'Agrupa artículos para localizar familias o proveedores con margen medio bajo.';
  ResetGrid([Titulo,'Descripción','Artículos','Coste medio','PVP medio','Margen medio','Art. sin coste','Art. sin PVP','Aviso']);
  AjustarColumnas;

  T := ArtTable;
  if not TableExists(T) then
  begin
    AddRow(['','','','','','','','','No existe la tabla ' + T]);
    ActualizarKPIs;
    Exit;
  end;

  SQLJoin := '';
  SQLDesc := ''''' DESCRIP';
  GroupExpr := 'a.' + Campo;

  if (Campo = 'A14') and TableExists(FamTable) then
  begin
    SQLJoin := ' LEFT JOIN ' + SQLIdent(FamTable) + ' f ON f.F0 = a.A14 ';
    SQLDesc := 'MAX(IFNULL(f.F1,''Sin familia'')) DESCRIP';
  end
  else if (Campo = 'A32') and TableExists('proveedores') then
  begin
    SQLJoin := ' LEFT JOIN ' + SQLIdent('proveedores') + ' p ON p.P0 = a.A32 ';
    SQLDesc := 'MAX(IFNULL(p.P1,''Sin proveedor'')) DESCRIP';
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT ' + GroupExpr + ' GRP, ' + SQLDesc + ', COUNT(*) N, AVG(a.A24) COSTE, AVG(a.A21) PVP, ' +
                  'SUM(CASE WHEN a.A24=0 THEN 1 ELSE 0 END) SINCOSTE, ' +
                  'SUM(CASE WHEN a.A2=0 OR a.A21=0 THEN 1 ELSE 0 END) SINPVP ' +
                  'FROM ' + SQLIdent(T) + ' a ' + SQLJoin +
                  ' GROUP BY ' + GroupExpr + ' ORDER BY GRP LIMIT 1000';
    Q.Open;
    while not Q.EOF do
    begin
      Coste := Q.FieldByName('COSTE').AsFloat;
      PVP := Q.FieldByName('PVP').AsFloat;
      Margen := 0;
      if PVP <> 0 then Margen := ((PVP - Coste) / PVP) * 100;
      SinCoste := Q.FieldByName('SINCOSTE').AsInteger;
      SinPVP := Q.FieldByName('SINPVP').AsInteger;
      Aviso := 'OK';
      if SinPVP > 0 then Aviso := 'Hay artículos sin PVP';
      if SinCoste > 0 then Aviso := 'Hay artículos sin coste';
      if (PVP > 0) and (Coste > PVP) then Aviso := 'Grupo con pérdida teórica';
      if (PVP > 0) and (Coste > 0) and (Margen < 10) then Aviso := 'Margen medio bajo';

      AddRow([Q.FieldByName('GRP').AsString,
              Q.FieldByName('DESCRIP').AsString,
              Q.FieldByName('N').AsString,
              Money4(Coste), Money4(PVP), Porc2(Margen),
              IntToStr(SinCoste), IntToStr(SinPVP), Aviso]);
      AcumularMargen(Margen);
      IncAvisos(Aviso, SinCoste > 0, SinPVP > 0);
      Q.Next;
    end;
    if Grid.RowCount = 1 then AddRow(['','','','','','','','','Sin resultados']);
  finally
    Q.Free;
  end;
  AjustarColumnas;
  ActualizarKPIs;
end;

procedure TRentabilidadFacturLinExForm.RecargarVista;
begin
  if FVistaActual = 'FAMILIA' then
    CargarAgrupado('A14', 'Familia')
  else if FVistaActual = 'PROVEEDOR' then
    CargarAgrupado('A32', 'Proveedor')
  else
    CargarArticulos;
end;

procedure TRentabilidadFacturLinExForm.ArticulosClick(Sender: TObject);
begin
  CargarArticulos;
end;

procedure TRentabilidadFacturLinExForm.FamiliasClick(Sender: TObject);
begin
  CargarAgrupado('A14', 'Familia');
end;

procedure TRentabilidadFacturLinExForm.ProveedoresClick(Sender: TObject);
begin
  CargarAgrupado('A32', 'Proveedor');
end;

procedure TRentabilidadFacturLinExForm.ActualizarClick(Sender: TObject);
begin
  RecargarVista;
end;

procedure TRentabilidadFacturLinExForm.CSVClick(Sender: TObject);
begin
  if FLXGuardarCSVConDialogo(Grid, 'Exportar rentabilidad a CSV', 'rentabilidad_facturlinex.csv') then
    ShowMessage('CSV generado correctamente.');
end;

procedure TRentabilidadFacturLinExForm.CerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TRentabilidadFacturLinExForm.GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
begin
  FLXGridPrepararCanvasSeleccion(Grid, aRow, aState);
end;

procedure TRentabilidadFacturLinExForm.GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  C, R: Integer;
begin
  if Button <> mbLeft then Exit;
  Grid.MouseToCell(X, Y, C, R);
  if (R = 0) and (C >= 0) then
    FLXGridOrdenar(Grid, C, FSortCol, FSortDesc);
end;

procedure MostrarRentabilidadFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  F: TRentabilidadFacturLinExForm;
begin
  F := TRentabilidadFacturLinExForm.CreateRentabilidad(AOwner, AConnection, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

end.
