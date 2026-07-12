unit uComparadorProveedoresFacturLinEx;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, StdCtrls, Buttons,
  Grids, Graphics, DB, ZConnection, ZDataset,
  uFLXGridStyle, uFLXExport, uFLXIcons, uFLXDialogs;

procedure MostrarComparadorProveedoresFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);

implementation

type
  TComparadorProveedoresFacturLinExForm = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;
    Grid: TStringGrid;
    Memo: TMemo;
    EditFiltro: TEdit;
    BtnResumen: TBitBtn;
    BtnArticulos: TBitBtn;
    BtnCompras: TBitBtn;
    BtnActualizar: TBitBtn;
    BtnCSV: TBitBtn;
    BtnCerrar: TBitBtn;
    FSortCol: Integer;
    FSortDesc: Boolean;
    FVistaActual: string;
    FTotalLineas: Integer;
    FProveedores: Integer;
    FSinProveedor: Integer;
    FProvInexistente: Integer;
    FAvisos: Integer;
    FMargenAcum: Double;
    FMargenNum: Integer;
    FListaProveedores: TStringList;
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
    LblKPIProveedores: TLabel;
    LblKPISinProveedor: TLabel;
    LblKPIMargen: TLabel;
    LblKPIAvisos: TLabel;
    procedure CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
    procedure CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer = 118);
    procedure CrearBotonVista(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ATop: Integer);
    procedure CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
    function DBName: string;
    function CleanIdent(const S: string): string;
    function SQLIdent(const S: string): string;
    function ArtTable: string;
    function CompraLinTable: string;
    function UltimoPediTable: string;
    function TableExists(const ATable: string): Boolean;
    function SafeFloat(AField: TField): Double;
    function Money4(V: Double): string;
    function Porc2(V: Double): string;
    function AvisoProveedor(Coste, PVP, Margen: Double; const Prov, Nombre: string): string;
    procedure ResetGrid(const Headers: array of string);
    procedure AddRow(const Values: array of string);
    procedure AplicarEstiloGrid;
    procedure AjustarColumnas;
    procedure LimpiarKPIs;
    procedure AcumularLinea(Coste, PVP, Margen: Double; const Prov, Aviso: string; AArticulosSinProveedor: Integer = 0; AProveedorInexistente: Integer = 0);
    procedure ActualizarKPIs;
    procedure CargarResumen;
    procedure CargarArticulos;
    procedure CargarUltimasCompras;
    procedure RecargarVista;
    procedure ResumenClick(Sender: TObject);
    procedure ArticulosClick(Sender: TObject);
    procedure ComprasClick(Sender: TObject);
    procedure ActualizarClick(Sender: TObject);
    procedure CSVClick(Sender: TObject);
    procedure CerrarClick(Sender: TObject);
    procedure GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  public
    constructor CreateComparador(AOwner: TComponent; AConnection: TZConnection; const ATienda: string); reintroduce;
    destructor Destroy; override;
  end;

procedure TComparadorProveedoresFacturLinExForm.CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
begin
  FLXSetBitBtnIcon(ABtn, AIcon, ASize);
end;

procedure TComparadorProveedoresFacturLinExForm.CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer);
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

procedure TComparadorProveedoresFacturLinExForm.CrearBotonVista(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ATop: Integer);
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

procedure TComparadorProveedoresFacturLinExForm.CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
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

constructor TComparadorProveedoresFacturLinExForm.CreateComparador(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
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
  FVistaActual := 'RESUMEN';
  FListaProveedores := TStringList.Create;
  FListaProveedores.Sorted := True;
  FListaProveedores.Duplicates := dupIgnore;

  Caption := 'FacturLinEx - Proveedores inteligentes';
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
  FN := FLXIconFile('proveedores', 64);
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
  LblTitulo.Caption := 'Proveedores inteligentes';
  LblTitulo.Font.Size := 24;
  LblTitulo.Font.Style := [fsBold];
  LblTitulo.Font.Color := RGBToColor(0,32,80);

  LblSubtitulo := TLabel.Create(Self);
  LblSubtitulo.Parent := HeaderPanel;
  LblSubtitulo.Left := 114;
  LblSubtitulo.Top := 68;
  LblSubtitulo.Caption := 'Comparador visual de proveedores, artículos asignados, márgenes y últimas compras. Consulta segura de solo lectura.';
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

  CrearBotonVista(InfoPanel, BtnResumen, 'Resumen', 'tend_resumen', 50);
  BtnResumen.OnClick := @ResumenClick;
  CrearBotonVista(InfoPanel, BtnArticulos, 'Artículos/proveedor', 'proveedores', 110);
  BtnArticulos.OnClick := @ArticulosClick;
  CrearBotonVista(InfoPanel, BtnCompras, 'Últimas compras', 'compras', 170);
  BtnCompras.OnClick := @ComprasClick;

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
  L.Caption := 'Proveedor, código o descripción:';
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
  L.Height := 210;
  L.WordWrap := True;
  L.Caption := 'Resumen agrupa artitien' + FTienda + '.A32 contra proveedores.P0/P1.' + LineEnding +
               'Artículos/proveedor lista artículos, coste A24, PVP A2/A21 y margen teórico.' + LineEnding +
               'Últimas compras usa hipedidd' + FTienda + ' y, si no existe, ultimopedi' + FTienda + '.' + LineEnding +
               'Consultas limitadas para evitar bloqueos. No modifica datos ni crea tablas.';
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
  LblVistaActual.Caption := 'Resumen de proveedores';
  LblVistaActual.Font.Size := 12;
  LblVistaActual.Font.Style := [fsBold];
  LblVistaActual.Font.Color := RGBToColor(0,65,145);

  LblSubtituloVista := TLabel.Create(Self);
  LblSubtituloVista.Parent := TitlePanel;
  LblSubtituloVista.Left := 16;
  LblSubtituloVista.Top := 38;
  LblSubtituloVista.Caption := 'Ordene por cabeceras para detectar proveedores sin ficha, márgenes bajos o costes superiores al PVP.';
  LblSubtituloVista.Font.Color := RGBToColor(45,70,105);

  KPIPanel := TPanel.Create(Self);
  KPIPanel.Parent := ContentPanel;
  KPIPanel.Align := alBottom;
  KPIPanel.Height := 108;
  KPIPanel.BevelOuter := bvLowered;
  KPIPanel.Color := RGBToColor(250,252,255);

  CrearKPI(KPIPanel, 'Líneas', 'tend_resumen', 12, LblKPILineas);
  CrearKPI(KPIPanel, 'Proveedores', 'proveedores', 252, LblKPIProveedores);
  CrearKPI(KPIPanel, 'Sin proveedor', 'alertas', 492, LblKPISinProveedor);
  CrearKPI(KPIPanel, 'Margen medio', 'tend_kpi_margen', 732, LblKPIMargen);
  CrearKPI(KPIPanel, 'Avisos', 'doctor', 972, LblKPIAvisos);

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
  Memo.Lines.Text := 'Proveedores inteligentes listo. Vista inicial: resumen agrupado.' + LineEnding +
                     'Modo seguro: solo lectura, sin cambios en proveedores, artículos ni compras.' + LineEnding +
                     'Las consultas están limitadas a 300/500 líneas para evitar bloqueos en BBDD grandes.';

  CargarResumen;
end;

destructor TComparadorProveedoresFacturLinExForm.Destroy;
begin
  FListaProveedores.Free;
  inherited Destroy;
end;

function TComparadorProveedoresFacturLinExForm.DBName: string;
begin
  Result := '';
  if Assigned(FConn) then Result := FConn.Database;
end;

function TComparadorProveedoresFacturLinExForm.CleanIdent(const S: string): string;
begin
  Result := StringReplace(S, '`', '', [rfReplaceAll]);
end;

function TComparadorProveedoresFacturLinExForm.SQLIdent(const S: string): string;
begin
  Result := '`' + CleanIdent(S) + '`';
end;

function TComparadorProveedoresFacturLinExForm.ArtTable: string;
begin
  Result := 'artitien' + FTienda;
end;

function TComparadorProveedoresFacturLinExForm.CompraLinTable: string;
begin
  Result := 'hipedidd' + FTienda;
end;

function TComparadorProveedoresFacturLinExForm.UltimoPediTable: string;
begin
  Result := 'ultimopedi' + FTienda;
end;

function TComparadorProveedoresFacturLinExForm.TableExists(const ATable: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (not Assigned(FConn)) or (not FConn.Connected) or (ATable = '') then Exit;
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

function TComparadorProveedoresFacturLinExForm.SafeFloat(AField: TField): Double;
begin
  Result := 0;
  if Assigned(AField) and (not AField.IsNull) then
  begin
    try
      Result := AField.AsFloat;
    except
      Result := 0;
    end;
  end;
end;

function TComparadorProveedoresFacturLinExForm.Money4(V: Double): string;
begin
  Result := FormatFloat('0.0000', V);
end;

function TComparadorProveedoresFacturLinExForm.Porc2(V: Double): string;
begin
  Result := FormatFloat('0.00', V) + ' %';
end;

function TComparadorProveedoresFacturLinExForm.AvisoProveedor(Coste, PVP, Margen: Double; const Prov, Nombre: string): string;
begin
  Result := 'OK';
  if (Trim(Prov) = '') or (Trim(Prov) = '0') then Result := 'Sin proveedor en ficha A32';
  if (Trim(Prov) <> '') and (Trim(Prov) <> '0') and (Trim(Nombre) = '') then Result := 'Proveedor A32 no existe';
  if (PVP > 0) and (Coste > PVP) then Result := 'Coste mayor que PVP con IVA';
  if (PVP > 0) and (Coste > 0) and (Margen < 10) and (Result = 'OK') then Result := 'Margen bajo';
end;

procedure TComparadorProveedoresFacturLinExForm.ResetGrid(const Headers: array of string);
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

procedure TComparadorProveedoresFacturLinExForm.AddRow(const Values: array of string);
var
  R, I: Integer;
begin
  R := Grid.RowCount;
  Grid.RowCount := R + 1;
  for I := Low(Values) to High(Values) do
    if I < Grid.ColCount then Grid.Cells[I,R] := Values[I];
end;

procedure TComparadorProveedoresFacturLinExForm.AplicarEstiloGrid;
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

procedure TComparadorProveedoresFacturLinExForm.AjustarColumnas;
var
  W, DescW: Integer;
begin
  if Grid.ColCount = 7 then
  begin
    W := Grid.ClientWidth - 60;
    if W < 1000 then W := 1000;
    DescW := W - 100 - 270 - 105 - 130 - 130 - 110 - 260;
    if DescW < 270 then DescW := 270;
    Grid.ColWidths[0] := 100;
    Grid.ColWidths[1] := DescW;
    Grid.ColWidths[2] := 105;
    Grid.ColWidths[3] := 130;
    Grid.ColWidths[4] := 130;
    Grid.ColWidths[5] := 110;
    Grid.ColWidths[6] := 260;
  end
  else if Grid.ColCount = 9 then
  begin
    W := Grid.ClientWidth - 60;
    if W < 1200 then W := 1200;
    DescW := W - 95 - 300 - 105 - 190 - 105 - 105 - 105 - 90 - 250;
    if DescW < 300 then DescW := 300;
    Grid.ColWidths[0] := 95;
    Grid.ColWidths[1] := DescW;
    Grid.ColWidths[2] := 105;
    Grid.ColWidths[3] := 190;
    Grid.ColWidths[4] := 105;
    Grid.ColWidths[5] := 105;
    Grid.ColWidths[6] := 105;
    Grid.ColWidths[7] := 90;
    Grid.ColWidths[8] := 250;
  end
  else if Grid.ColCount = 8 then
  begin
    W := Grid.ClientWidth - 60;
    if W < 1150 then W := 1150;
    DescW := W - 95 - 100 - 190 - 110 - 300 - 100 - 105 - 120;
    if DescW < 300 then DescW := 300;
    Grid.ColWidths[0] := 95;
    Grid.ColWidths[1] := 100;
    Grid.ColWidths[2] := 190;
    Grid.ColWidths[3] := 110;
    Grid.ColWidths[4] := DescW;
    Grid.ColWidths[5] := 100;
    Grid.ColWidths[6] := 105;
    Grid.ColWidths[7] := 120;
  end
  else
    FLXGridAutoAjustar(Grid, 80, 360);
end;

procedure TComparadorProveedoresFacturLinExForm.LimpiarKPIs;
begin
  FTotalLineas := 0;
  FProveedores := 0;
  FSinProveedor := 0;
  FProvInexistente := 0;
  FAvisos := 0;
  FMargenAcum := 0;
  FMargenNum := 0;
  FListaProveedores.Clear;
  LblKPILineas.Caption := '0';
  LblKPIProveedores.Caption := '0';
  LblKPISinProveedor.Caption := '0';
  LblKPIMargen.Caption := '-';
  LblKPIAvisos.Caption := '0';
end;

procedure TComparadorProveedoresFacturLinExForm.AcumularLinea(Coste, PVP, Margen: Double; const Prov, Aviso: string; AArticulosSinProveedor: Integer; AProveedorInexistente: Integer);
begin
  Inc(FTotalLineas);
  if Trim(Prov) <> '' then
    FListaProveedores.Add(Trim(Prov));
  if AArticulosSinProveedor > 0 then
    Inc(FSinProveedor, AArticulosSinProveedor)
  else if (Trim(Prov) = '') or (Trim(Prov) = '0') then
    Inc(FSinProveedor);
  if AProveedorInexistente > 0 then
    Inc(FProvInexistente, AProveedorInexistente)
  else if Pos('no existe', AnsiLowerCase(Aviso)) > 0 then
    Inc(FProvInexistente);
  if (Aviso <> '') and (Aviso <> 'OK') then
    Inc(FAvisos);
  if (PVP > 0) and (Coste > 0) then
  begin
    FMargenAcum := FMargenAcum + Margen;
    Inc(FMargenNum);
  end;
end;

procedure TComparadorProveedoresFacturLinExForm.ActualizarKPIs;
begin
  FProveedores := FListaProveedores.Count;
  LblKPILineas.Caption := IntToStr(FTotalLineas);
  LblKPIProveedores.Caption := IntToStr(FProveedores);
  if FProvInexistente > 0 then
    LblKPISinProveedor.Caption := IntToStr(FSinProveedor) + ' / ' + IntToStr(FProvInexistente) + ' inex.'
  else
    LblKPISinProveedor.Caption := IntToStr(FSinProveedor);
  if FMargenNum > 0 then
    LblKPIMargen.Caption := Porc2(FMargenAcum / FMargenNum)
  else
    LblKPIMargen.Caption := '-';
  LblKPIAvisos.Caption := IntToStr(FAvisos);
end;

procedure TComparadorProveedoresFacturLinExForm.CargarResumen;
var
  Q: TZQuery;
  T, Filtro, WhereSQL, Aviso, Prov, Nombre: string;
  Coste, PVP, Margen: Double;
  SinProv, ProvInex: Integer;
begin
  FVistaActual := 'RESUMEN';
  LblVistaActual.Caption := 'Resumen de proveedores';
  LblSubtituloVista.Caption := 'Agrupa artículos por proveedor de ficha A32 y calcula margen medio teórico.';
  T := ArtTable;
  ResetGrid(['Proveedor','Nombre','Artículos','Coste medio','PVP IVA medio','Margen','Aviso']);
  if not TableExists(T) then begin AddRow(['','','','','','','No existe la tabla ' + T]); ActualizarKPIs; Exit; end;
  if not TableExists('proveedores') then begin AddRow(['','','','','','','No existe la tabla proveedores']); ActualizarKPIs; Exit; end;

  Filtro := Trim(EditFiltro.Text);
  WhereSQL := ' WHERE 1=1 ';
  if Filtro <> '' then
    WhereSQL := WhereSQL + ' AND (CAST(A.A32 AS CHAR) LIKE ' + QuotedStr('%' + Filtro + '%') +
      ' OR A.A0 LIKE ' + QuotedStr('%' + Filtro + '%') + ' OR A.A1 LIKE ' + QuotedStr('%' + Filtro + '%') +
      ' OR P.P1 LIKE ' + QuotedStr('%' + Filtro + '%') + ') ';

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    try
      Q.SQL.Text := 'SELECT A.A32 PROV, COALESCE(P.P1,'''') NOMBRE, COUNT(*) N, AVG(A.A24) COSTE, AVG(A.A2) PVP, ' +
        'SUM(CASE WHEN IFNULL(A.A32,0)=0 THEN 1 ELSE 0 END) SINPROV, ' +
        'SUM(CASE WHEN P.P0 IS NULL AND IFNULL(A.A32,0)<>0 THEN 1 ELSE 0 END) PROVINEX ' +
        'FROM ' + SQLIdent(T) + ' A LEFT JOIN proveedores P ON TRIM(CAST(P.P0 AS CHAR))=TRIM(CAST(A.A32 AS CHAR)) ' + WhereSQL +
        ' GROUP BY A.A32, P.P1 ORDER BY N DESC LIMIT 300';
      Q.Open;
      while not Q.EOF do
      begin
        Coste := SafeFloat(Q.FieldByName('COSTE'));
        PVP := SafeFloat(Q.FieldByName('PVP'));
        Margen := 0;
        if PVP <> 0 then Margen := ((PVP - Coste) / PVP) * 100;
        Prov := Q.FieldByName('PROV').AsString;
        Nombre := Q.FieldByName('NOMBRE').AsString;
        SinProv := Q.FieldByName('SINPROV').AsInteger;
        ProvInex := Q.FieldByName('PROVINEX').AsInteger;
        Aviso := AvisoProveedor(Coste, PVP, Margen, Prov, Nombre);
        if ProvInex > 0 then Aviso := 'Proveedor A32 no existe en proveedores';
        if SinProv > 0 then Aviso := 'Artículos sin proveedor asignado en A32';
        AddRow([Prov, Nombre, Q.FieldByName('N').AsString, Money4(Coste), Money4(PVP), Porc2(Margen), Aviso]);
        AcumularLinea(Coste, PVP, Margen, Prov, Aviso, SinProv, ProvInex);
        Q.Next;
      end;
      if Grid.RowCount = 1 then AddRow(['','','','','','','Sin resultados']);
    except
      on E: Exception do AddRow(['','','','','','','Error consulta: ' + E.Message]);
    end;
  finally
    Q.Free;
  end;
  AjustarColumnas;
  ActualizarKPIs;
end;

procedure TComparadorProveedoresFacturLinExForm.CargarArticulos;
var
  Q: TZQuery;
  T, Filtro, WhereSQL, Aviso, Prov, Nombre: string;
  Coste, PVP, PVPSin, Margen: Double;
begin
  FVistaActual := 'ARTICULOS';
  LblVistaActual.Caption := 'Artículos por proveedor';
  LblSubtituloVista.Caption := 'Lista artículos con proveedor de ficha, coste, PVP y margen teórico. Límite 500 líneas.';
  T := ArtTable;
  ResetGrid(['Código','Descripción','Prov. A32','Nombre proveedor','Coste','PVP IVA','PVP sin IVA','Margen','Aviso']);
  if not TableExists(T) then begin AddRow(['','','','','','','','','No existe la tabla ' + T]); ActualizarKPIs; Exit; end;
  if not TableExists('proveedores') then begin AddRow(['','','','','','','','','No existe la tabla proveedores']); ActualizarKPIs; Exit; end;

  Filtro := Trim(EditFiltro.Text);
  WhereSQL := ' WHERE 1=1 ';
  if Filtro <> '' then
    WhereSQL := WhereSQL + ' AND (A.A0 LIKE ' + QuotedStr('%' + Filtro + '%') + ' OR A.A1 LIKE ' + QuotedStr('%' + Filtro + '%') +
      ' OR CAST(A.A32 AS CHAR) LIKE ' + QuotedStr('%' + Filtro + '%') + ' OR P.P1 LIKE ' + QuotedStr('%' + Filtro + '%') + ') ';

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    try
      Q.SQL.Text := 'SELECT A.A0,A.A1,A.A32 AS PROVFICHA,A.A24 COSTE,A.A2 PVPIVA,A.A21 PVPSIN,COALESCE(P.P1,'''') P1 FROM ' + SQLIdent(T) +
        ' A LEFT JOIN proveedores P ON TRIM(CAST(P.P0 AS CHAR))=TRIM(CAST(A.A32 AS CHAR)) ' + WhereSQL + ' ORDER BY PROVFICHA,A.A1 LIMIT 500';
      Q.Open;
      while not Q.EOF do
      begin
        Coste := SafeFloat(Q.FieldByName('COSTE'));
        PVP := SafeFloat(Q.FieldByName('PVPIVA'));
        PVPSin := SafeFloat(Q.FieldByName('PVPSIN'));
        Margen := 0;
        if PVP <> 0 then Margen := ((PVP - Coste) / PVP) * 100;
        Prov := Q.FieldByName('PROVFICHA').AsString;
        Nombre := Q.FieldByName('P1').AsString;
        Aviso := AvisoProveedor(Coste, PVP, Margen, Prov, Nombre);
        AddRow([Q.FieldByName('A0').AsString, Q.FieldByName('A1').AsString, Prov, Nombre,
          Money4(Coste), Money4(PVP), Money4(PVPSin), Porc2(Margen), Aviso]);
        AcumularLinea(Coste, PVP, Margen, Prov, Aviso);
        Q.Next;
      end;
      if Grid.RowCount = 1 then AddRow(['','','','','','','','','Sin resultados']);
    except
      on E: Exception do AddRow(['','','','','','','','','Error consulta: ' + E.Message]);
    end;
  finally
    Q.Free;
  end;
  AjustarColumnas;
  ActualizarKPIs;
end;

procedure TComparadorProveedoresFacturLinExForm.CargarUltimasCompras;
var
  Q: TZQuery;
  HD, UP, Filtro, WhereSQL, Prov: string;
  Coste: Double;
begin
  FVistaActual := 'COMPRAS';
  LblVistaActual.Caption := 'Últimas compras';
  LblSubtituloVista.Caption := 'Consulta últimas líneas de compra desde hipedidd o ultimopedi, según exista en esta instalación.';
  HD := CompraLinTable;
  UP := UltimoPediTable;
  ResetGrid(['Fecha','Proveedor','Nombre proveedor','Código','Descripción','Cantidad','Coste compra','Origen']);

  Filtro := Trim(EditFiltro.Text);
  WhereSQL := ' WHERE 1=1 ';

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    try
      if TableExists(HD) then
      begin
        if Filtro <> '' then
          WhereSQL := WhereSQL + ' AND (D.HPD6 LIKE ' + QuotedStr('%' + Filtro + '%') + ' OR D.HPD7 LIKE ' + QuotedStr('%' + Filtro + '%') +
            ' OR CAST(D.HPD2 AS CHAR) LIKE ' + QuotedStr('%' + Filtro + '%') + ' OR P.P1 LIKE ' + QuotedStr('%' + Filtro + '%') + ') ';

        Q.SQL.Text := 'SELECT D.HPD1 FECHA, D.HPD2 PROV, COALESCE(P.P1,'''') PNOM, D.HPD6 COD, D.HPD7 DES, D.HPD8 UDS, D.HPD10 COSTE, ''hipedidd'' ORIGEN ' +
          'FROM ' + SQLIdent(HD) + ' D LEFT JOIN proveedores P ON P.P0=D.HPD2 ' + WhereSQL +
          ' ORDER BY D.HPD1 DESC, D.HPD2, D.HPD6 LIMIT 500';
      end
      else if TableExists(UP) then
      begin
        if Filtro <> '' then
          WhereSQL := WhereSQL + ' AND (U.AP0 LIKE ' + QuotedStr('%' + Filtro + '%') +
            ' OR CAST(U.AP2 AS CHAR) LIKE ' + QuotedStr('%' + Filtro + '%') + ' OR P.P1 LIKE ' + QuotedStr('%' + Filtro + '%') + ') ';

        Q.SQL.Text := 'SELECT U.AP1 FECHA, U.AP2 PROV, COALESCE(P.P1,'''') PNOM, U.AP0 COD, COALESCE(A.A1,'''') DES, U.AP3 UDS, U.AP4 COSTE, ''ultimopedi'' ORIGEN ' +
          'FROM ' + SQLIdent(UP) + ' U LEFT JOIN proveedores P ON P.P0=U.AP2 LEFT JOIN ' + SQLIdent(ArtTable) + ' A ON A.A0=U.AP0 ' +
          WhereSQL + ' ORDER BY U.AP1 DESC, U.AP2, U.AP0 LIMIT 500';
      end
      else
      begin
        AddRow(['','','','','','','','No existe ' + HD + ' ni ' + UP]);
        ActualizarKPIs;
        Exit;
      end;

      Q.Open;
      while not Q.EOF do
      begin
        Prov := Q.FieldByName('PROV').AsString;
        Coste := SafeFloat(Q.FieldByName('COSTE'));
        AddRow([Q.FieldByName('FECHA').AsString, Prov, Q.FieldByName('PNOM').AsString,
          Q.FieldByName('COD').AsString, Q.FieldByName('DES').AsString, Q.FieldByName('UDS').AsString,
          FormatFloat('0.00000', Coste), Q.FieldByName('ORIGEN').AsString]);
        AcumularLinea(Coste, 0, 0, Prov, 'OK');
        Q.Next;
      end;
      if Grid.RowCount = 1 then AddRow(['','','','','','','','Sin resultados']);
    except
      on E: Exception do AddRow(['','','','','','','','Error consulta: ' + E.Message]);
    end;
  finally
    Q.Free;
  end;
  AjustarColumnas;
  ActualizarKPIs;
end;

procedure TComparadorProveedoresFacturLinExForm.RecargarVista;
begin
  if FVistaActual = 'ARTICULOS' then CargarArticulos
  else if FVistaActual = 'COMPRAS' then CargarUltimasCompras
  else CargarResumen;
end;

procedure TComparadorProveedoresFacturLinExForm.ResumenClick(Sender: TObject);
begin
  CargarResumen;
end;

procedure TComparadorProveedoresFacturLinExForm.ArticulosClick(Sender: TObject);
begin
  CargarArticulos;
end;

procedure TComparadorProveedoresFacturLinExForm.ComprasClick(Sender: TObject);
begin
  CargarUltimasCompras;
end;

procedure TComparadorProveedoresFacturLinExForm.ActualizarClick(Sender: TObject);
begin
  RecargarVista;
end;

procedure TComparadorProveedoresFacturLinExForm.CSVClick(Sender: TObject);
begin
  if FLXGuardarCSVConDialogo(Grid, 'Exportar proveedores', 'proveedores_facturlinex.csv') then
    FLXInfo('CSV generado correctamente.', 'Proveedores');
end;

procedure TComparadorProveedoresFacturLinExForm.CerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TComparadorProveedoresFacturLinExForm.GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
begin
  FLXGridPrepararCanvasSeleccion(Grid, aRow, aState);
end;

procedure TComparadorProveedoresFacturLinExForm.GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  C, R: Integer;
begin
  if Button <> mbLeft then Exit;
  Grid.MouseToCell(X, Y, C, R);
  if (R = 0) and (C >= 0) then
    FLXGridOrdenar(Grid, C, FSortCol, FSortDesc);
end;

procedure MostrarComparadorProveedoresFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  F: TComparadorProveedoresFacturLinExForm;
begin
  F := TComparadorProveedoresFacturLinExForm.CreateComparador(AOwner, AConnection, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

end.
