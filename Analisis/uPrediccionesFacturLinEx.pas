unit uPrediccionesFacturLinEx;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, LCLType, Dialogs, ExtCtrls, StdCtrls, Buttons,
  Grids, Graphics, DB, ZConnection, ZDataset, Math,
  uFLXGridStyle, uFLXExport, uFLXDialogs, uFLXIcons;

procedure MostrarPrediccionesFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);

implementation

type
  TPrediccionesForm = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;
    FSortCol: Integer;
    FSortDesc: Boolean;
    Grid: TStringGrid;
    Memo: TMemo;
    LblTitulo: TLabel;
    LblResumen: TLabel;
    BtnAnalizar: TBitBtn;
    BtnCSV: TBitBtn;
    BtnCerrar: TBitBtn;
    CmbVista: TComboBox;
    CmbFiltro: TComboBox;
    CmbHorizonte: TComboBox;
    EdMinUds: TEdit;
    HeaderPanel: TPanel;
    NavPanel: TPanel;
    FiltrosPanel: TPanel;
    ContentPanel: TPanel;
    TitlePanel: TPanel;
    KPIPanel: TPanel;
    LblVistaActual: TLabel;
    LblSubtituloVista: TLabel;
    LblKPI1: TLabel;
    LblKPI2: TLabel;
    LblKPI3: TLabel;
    LblKPI4: TLabel;
    LblKPI5: TLabel;
    BtnResumen: TBitBtn;
    BtnArticulos: TBitBtn;
    BtnFamilias: TBitBtn;
    BtnProveedores: TBitBtn;
    BtnClientes: TBitBtn;
    procedure CrearBotonVista(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AIndex: Integer);
    procedure CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer);
    procedure CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
    procedure VistaButtonClick(Sender: TObject);
    procedure AplicarEstiloGrid;
    procedure CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
    procedure ResetGrid;
    procedure AddRow(const Tipo, Codigo, Descripcion: string; Actual, Anterior, Porc, Prevision: Double; const Confianza, Prioridad, Diagnostico, Accion: string);
    procedure AnalizarClick(Sender: TObject);
    procedure CSVClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CerrarClick(Sender: TObject);
    procedure GridHeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer);
    procedure GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
    procedure AjustarColumnas;
    function HorizonteDias: Integer;
    function MinUds: Double;
    function SQLFloat(V: Double): string;
    function SQLIdent(const S: string): string;
    function TableName(const Prefix: string): string;
    function DBName: string;
    function TableExists(const ATable: string): Boolean;
    function FmtMoney(V: Double): string;
    function FmtPct(V: Double): string;
    function PrevisionValor(const Actual, Anterior: Double): Double;
    function ConfianzaTexto(const Actual, Anterior: Double): string;
    function DiagnosticoTexto(const Actual, Anterior, Porc, Prevision: Double): string;
    function AccionTexto(const Actual, Anterior, Porc, Prevision: Double): string;
    function PrioridadTexto(const Actual, Anterior, Porc, UdsActual, UdsAnterior: Double; const Diagnostico: string): string;
    function PasaFiltro(const Prioridad, Diagnostico: string): Boolean;
    procedure AnalizarResumen;
    procedure AnalizarArticulos;
    procedure AnalizarFamilias;
    procedure AnalizarProveedores;
    procedure AnalizarClientes;
    procedure RefrescarResumen;
  public
    constructor CreateForm(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
  end;

procedure TPrediccionesForm.CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
begin
  FLXSetBitBtnIcon(ABtn, AIcon, ASize);
end;

procedure TPrediccionesForm.CrearBotonVista(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AIndex: Integer);
begin
  ABtn := TBitBtn.Create(Self);
  ABtn.Parent := AParent;
  ABtn.Left := ALeft;
  ABtn.Top := 8;
  ABtn.Width := 146;
  ABtn.Height := 58;
  ABtn.Caption := ACaption;
  ABtn.Tag := AIndex;
  ABtn.Font.Style := [fsBold];
  ABtn.Layout := blGlyphLeft;
  ABtn.Spacing := 8;
  ABtn.OnClick := @VistaButtonClick;
  CargarIconoBoton(ABtn, AIcon, 30);
end;

procedure TPrediccionesForm.CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer);
begin
  ABtn := TBitBtn.Create(Self);
  ABtn.Parent := AParent;
  ABtn.Left := ALeft;
  ABtn.Top := 8;
  ABtn.Width := 118;
  ABtn.Height := 58;
  ABtn.Caption := ACaption;
  ABtn.Layout := blGlyphTop;
  ABtn.Font.Style := [fsBold];
  CargarIconoBoton(ABtn, AIcon, 30);
end;

procedure TPrediccionesForm.CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
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

procedure TPrediccionesForm.VistaButtonClick(Sender: TObject);
begin
  if Sender is TBitBtn then
  begin
    CmbVista.ItemIndex := TBitBtn(Sender).Tag;
    AnalizarClick(Sender);
  end;
end;

procedure TPrediccionesForm.AplicarEstiloGrid;
begin
  Grid.Color := clWhite;
  Grid.FixedColor := RGBToColor(225,238,252);
  Grid.AlternateColor := RGBToColor(248,251,255);
  Grid.Font.Color := clBlack;
  Grid.TitleFont.Color := RGBToColor(0,32,80);
  Grid.TitleFont.Style := [fsBold];
  Grid.Options := Grid.Options + [goRowSelect, goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goThumbTracking];
end;

constructor TPrediccionesForm.CreateForm(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  Logo: TImage;
  Pic: TPicture;
  FN: string;
  L: TLabel;
  ActionPanel: TPanel;
  FilterTitle: TLabel;
  BtnAplicar: TBitBtn;
begin
  inherited CreateNew(AOwner, 1);
  KeyPreview := True;
  OnKeyDown := @FormKeyDown;
  FConn := AConnection;
  FTienda := ATienda;
  FSortCol := -1;
  FSortDesc := False;

  Caption := 'FacturLinEx - Predicciones';
  Width := 1300;
  Height := 820;
  Position := poScreenCenter;
  WindowState := wsMaximized;
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
  FN := FLXIconFile('predicciones', 64);
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
  LblTitulo.Caption := 'Predicciones';
  LblTitulo.Font.Size := 24;
  LblTitulo.Font.Style := [fsBold];
  LblTitulo.Font.Color := RGBToColor(0,32,80);

  LblResumen := TLabel.Create(Self);
  LblResumen.Parent := HeaderPanel;
  LblResumen.Left := 114;
  LblResumen.Top := 68;
  LblResumen.Caption := 'Estimación orientativa de ventas próximas según histórico reciente';
  LblResumen.Font.Size := 11;
  LblResumen.Font.Color := RGBToColor(45,70,105);

  ActionPanel := TPanel.Create(Self);
  ActionPanel.Parent := HeaderPanel;
  ActionPanel.Align := alRight;
  ActionPanel.Width := 610;
  ActionPanel.BevelOuter := bvNone;
  ActionPanel.Color := HeaderPanel.Color;

  CrearBotonAccion(ActionPanel, BtnAnalizar, 'Actualizar', 'tend_actualizar', 8);
  BtnAnalizar.OnClick := @AnalizarClick;
  CrearBotonAccion(ActionPanel, BtnCSV, 'Exportar', 'tend_exportar', 134);
  BtnCSV.OnClick := @CSVClick;

  BtnCerrar := TBitBtn.Create(Self);
  BtnCerrar.Parent := ActionPanel;
  BtnCerrar.Left := 476;
  BtnCerrar.Top := 8;
  BtnCerrar.Width := 118;
  BtnCerrar.Height := 58;
  BtnCerrar.Caption := 'Cerrar';
  BtnCerrar.Layout := blGlyphTop;
  BtnCerrar.Font.Style := [fsBold];
  BtnCerrar.OnClick := @CerrarClick;
  CargarIconoBoton(BtnCerrar, 'tend_cerrar', 30);

  NavPanel := TPanel.Create(Self);
  NavPanel.Parent := Self;
  NavPanel.Align := alTop;
  NavPanel.Height := 74;
  NavPanel.BevelOuter := bvNone;
  NavPanel.Color := RGBToColor(248,251,255);

  CrearBotonVista(NavPanel, BtnResumen, 'Resumen', 'tend_resumen', 16, 0);
  CrearBotonVista(NavPanel, BtnArticulos, 'Artículos', 'tend_articulos', 170, 1);
  CrearBotonVista(NavPanel, BtnFamilias, 'Familias', 'tend_familias', 324, 2);
  CrearBotonVista(NavPanel, BtnProveedores, 'Proveedores', 'tend_proveedores', 478, 3);
  CrearBotonVista(NavPanel, BtnClientes, 'Clientes', 'tend_clientes', 632, 4);

  FiltrosPanel := TPanel.Create(Self);
  FiltrosPanel.Parent := Self;
  FiltrosPanel.Align := alLeft;
  FiltrosPanel.Width := 245;
  FiltrosPanel.BevelOuter := bvLowered;
  FiltrosPanel.Color := RGBToColor(248,251,255);

  FilterTitle := TLabel.Create(Self);
  FilterTitle.Parent := FiltrosPanel;
  FilterTitle.Left := 18;
  FilterTitle.Top := 20;
  FilterTitle.Caption := 'Filtros';
  FilterTitle.Font.Size := 12;
  FilterTitle.Font.Style := [fsBold];
  FilterTitle.Font.Color := RGBToColor(0,65,145);

  L := TLabel.Create(Self);
  L.Parent := FiltrosPanel;
  L.Left := 18;
  L.Top := 62;
  L.Caption := 'Horizonte / periodo base';

  CmbHorizonte := TComboBox.Create(Self);
  CmbHorizonte.Parent := FiltrosPanel;
  CmbHorizonte.Left := 18;
  CmbHorizonte.Top := 82;
  CmbHorizonte.Width := 205;
  CmbHorizonte.Style := csDropDownList;
  CmbHorizonte.Items.Add('15 días');
  CmbHorizonte.Items.Add('30 días');
  CmbHorizonte.Items.Add('60 días');
  CmbHorizonte.Items.Add('90 días');
  CmbHorizonte.ItemIndex := 1;

  L := TLabel.Create(Self);
  L.Parent := FiltrosPanel;
  L.Left := 18;
  L.Top := 132;
  L.Caption := 'Vista de predicción';

  CmbVista := TComboBox.Create(Self);
  CmbVista.Parent := FiltrosPanel;
  CmbVista.Left := 18;
  CmbVista.Top := 152;
  CmbVista.Width := 205;
  CmbVista.Style := csDropDownList;
  CmbVista.Items.Add('Resumen');
  CmbVista.Items.Add('Artículos');
  CmbVista.Items.Add('Familias');
  CmbVista.Items.Add('Proveedores');
  CmbVista.Items.Add('Clientes');
  CmbVista.ItemIndex := 0;

  L := TLabel.Create(Self);
  L.Parent := FiltrosPanel;
  L.Left := 18;
  L.Top := 204;
  L.Caption := 'Filtro de sugerencias';

  CmbFiltro := TComboBox.Create(Self);
  CmbFiltro.Parent := FiltrosPanel;
  CmbFiltro.Left := 18;
  CmbFiltro.Top := 224;
  CmbFiltro.Width := 205;
  CmbFiltro.Style := csDropDownList;
  CmbFiltro.Items.Add('Todas');
  CmbFiltro.Items.Add('Alta prioridad');
  CmbFiltro.Items.Add('Posibles roturas');
  CmbFiltro.Items.Add('Crecimiento / reposición');
  CmbFiltro.ItemIndex := 0;

  L := TLabel.Create(Self);
  L.Parent := FiltrosPanel;
  L.Left := 18;
  L.Top := 274;
  L.Caption := 'Mínimo de unidades';

  EdMinUds := TEdit.Create(Self);
  EdMinUds.Parent := FiltrosPanel;
  EdMinUds.Left := 18;
  EdMinUds.Top := 294;
  EdMinUds.Width := 205;
  EdMinUds.Text := '3';
  EdMinUds.Hint := 'Mínimo de diferencia en unidades para considerar una sugerencia';
  EdMinUds.ShowHint := True;

  BtnAplicar := TBitBtn.Create(Self);
  BtnAplicar.Parent := FiltrosPanel;
  BtnAplicar.Left := 18;
  BtnAplicar.Top := 356;
  BtnAplicar.Width := 205;
  BtnAplicar.Height := 50;
  BtnAplicar.Caption := 'Aplicar filtros';
  BtnAplicar.Font.Style := [fsBold];
  BtnAplicar.Layout := blGlyphLeft;
  BtnAplicar.OnClick := @AnalizarClick;
  CargarIconoBoton(BtnAplicar, 'tend_filtro', 30);

  L := TLabel.Create(Self);
  L.Parent := FiltrosPanel;
  L.Left := 18;
  L.Top := 430;
  L.Width := 205;
  L.Height := 170;
  L.WordWrap := True;
  L.Caption := 'Solo lectura. La v1.1 mantiene el diseño v1 y añade clientes, prioridad, filtros útiles y mínimo de unidades.';
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
  LblVistaActual.Caption := 'Vista actual: RESUMEN';
  LblVistaActual.Font.Size := 12;
  LblVistaActual.Font.Style := [fsBold];
  LblVistaActual.Font.Color := RGBToColor(0,65,145);

  LblSubtituloVista := TLabel.Create(Self);
  LblSubtituloVista.Parent := TitlePanel;
  LblSubtituloVista.Left := 16;
  LblSubtituloVista.Top := 38;
  LblSubtituloVista.Caption := 'Predicción basada en ventas recientes contra periodo anterior.';
  LblSubtituloVista.Font.Color := RGBToColor(45,70,105);

  KPIPanel := TPanel.Create(Self);
  KPIPanel.Parent := ContentPanel;
  KPIPanel.Align := alBottom;
  KPIPanel.Height := 108;
  KPIPanel.BevelOuter := bvLowered;
  KPIPanel.Color := RGBToColor(250,252,255);

  CrearKPI(KPIPanel, 'Líneas', 'tend_kpi_ventas', 12, LblKPI1);
  CrearKPI(KPIPanel, 'Al alza', 'rentabilidad', 252, LblKPI2);
  CrearKPI(KPIPanel, 'A la baja', 'predicciones', 492, LblKPI3);
  CrearKPI(KPIPanel, 'Revisar', 'alertas', 732, LblKPI4);
  CrearKPI(KPIPanel, 'Horizonte', 'tend_configuracion', 972, LblKPI5);

  Grid := TStringGrid.Create(Self);
  Grid.Parent := ContentPanel;
  Grid.Align := alClient;
  Grid.FixedRows := 1;
  Grid.Options := Grid.Options + [goRowSelect, goColSizing];
  Grid.OnHeaderClick := @GridHeaderClick;
  Grid.OnPrepareCanvas := @GridPrepareCanvas;
  AplicarEstiloGrid;

  Memo := TMemo.Create(Self);
  Memo.Parent := Self;
  Memo.Align := alBottom;
  Memo.Height := 78;
  Memo.ScrollBars := ssVertical;
  Memo.Color := RGBToColor(250,252,255);
  Memo.Lines.Text := 'Predicciones es orientativo: no modifica datos, no crea pedidos y no cambia precios.' + LineEnding +
                     'La previsión se calcula comparando el periodo seleccionado con el periodo anterior equivalente.' + LineEnding +
                     'v1.1 añade filtros de prioridad/rotura/crecimiento y mínimo de unidades sin cambiar la estética v1.';
  ResetGrid;
end;

procedure TPrediccionesForm.ResetGrid;
begin
  Grid.ColCount := 11;
  Grid.RowCount := 1;
  Grid.Cells[0,0] := 'Tipo';
  Grid.Cells[1,0] := 'Código';
  Grid.Cells[2,0] := 'Descripción';
  Grid.Cells[3,0] := 'Periodo reciente';
  Grid.Cells[4,0] := 'Periodo anterior';
  Grid.Cells[5,0] := 'Tendencia %';
  Grid.Cells[6,0] := 'Previsión';
  Grid.Cells[7,0] := 'Confianza';
  Grid.Cells[8,0] := 'Prioridad';
  Grid.Cells[9,0] := 'Diagnóstico';
  Grid.Cells[10,0] := 'Acción recomendada';
  AjustarColumnas;
end;

procedure TPrediccionesForm.AjustarColumnas;
var
  Total, Disponible: Integer;
begin
  if Grid.ColCount < 11 then Exit;
  Grid.ColWidths[0] := 95;
  Grid.ColWidths[1] := 90;
  Grid.ColWidths[3] := 118;
  Grid.ColWidths[4] := 118;
  Grid.ColWidths[5] := 92;
  Grid.ColWidths[6] := 112;
  Grid.ColWidths[7] := 88;
  Grid.ColWidths[8] := 92;
  Grid.ColWidths[9] := 155;
  Grid.ColWidths[10] := 260;
  Total := Grid.ColWidths[0] + Grid.ColWidths[1] + Grid.ColWidths[3] + Grid.ColWidths[4] +
           Grid.ColWidths[5] + Grid.ColWidths[6] + Grid.ColWidths[7] + Grid.ColWidths[8] +
           Grid.ColWidths[9] + Grid.ColWidths[10] + 42;
  Disponible := Grid.ClientWidth - Total;
  if Disponible < 230 then Disponible := 230;
  Grid.ColWidths[2] := Disponible;
end;

function TPrediccionesForm.HorizonteDias: Integer;
begin
  case CmbHorizonte.ItemIndex of
    0: Result := 15;
    2: Result := 60;
    3: Result := 90;
  else
    Result := 30;
  end;
end;

function TPrediccionesForm.MinUds: Double;
begin
  Result := 3;
  if Assigned(EdMinUds) then
  begin
    if not TryStrToFloat(StringReplace(Trim(EdMinUds.Text), ',', '.', [rfReplaceAll]), Result) then
      Result := 3;
  end;
  if Result < 0 then Result := 0;
end;

function TPrediccionesForm.SQLFloat(V: Double): string;
begin
  Result := StringReplace(FloatToStr(V), ',', '.', [rfReplaceAll]);
end;

function TPrediccionesForm.FmtMoney(V: Double): string;
begin
  Result := FormatFloat('#,##0.00 €', V);
end;

function TPrediccionesForm.FmtPct(V: Double): string;
begin
  Result := FormatFloat('#,##0.00 %', V);
end;

function TPrediccionesForm.PrevisionValor(const Actual, Anterior: Double): Double;
var
  Momentum: Double;
begin
  if (Actual <= 0.0001) and (Anterior <= 0.0001) then
    Result := 0
  else if Anterior <= 0.0001 then
    Result := Actual
  else
  begin
    Momentum := (Actual - Anterior) / Anterior;
    if Momentum > 0.50 then Momentum := 0.50;
    if Momentum < -0.50 then Momentum := -0.50;
    Result := Actual * (1 + (Momentum * 0.50));
  end;
  if Result < 0 then Result := 0;
end;

function TPrediccionesForm.ConfianzaTexto(const Actual, Anterior: Double): string;
begin
  if (Actual <= 0.0001) and (Anterior <= 0.0001) then Result := 'Sin datos'
  else if (Actual > 0) and (Anterior > 0) then
  begin
    if Abs(Actual - Anterior) <= (Max(Actual, Anterior) * 0.15) then Result := 'Alta'
    else Result := 'Media';
  end
  else
    Result := 'Baja';
end;

function TPrediccionesForm.DiagnosticoTexto(const Actual, Anterior, Porc, Prevision: Double): string;
begin
  if (Actual <= 0.0001) and (Anterior <= 0.0001) then Result := 'Sin datos'
  else if (Anterior <= 0.0001) and (Actual > 0) then Result := 'Demanda nueva'
  else if (Actual <= 0.0001) and (Anterior > 0) then Result := 'Riesgo de caída'
  else if Porc >= 25 then Result := 'Previsión al alza'
  else if Porc <= -25 then Result := 'Previsión a la baja'
  else if Prevision > Actual * 1.10 then Result := 'Ligera subida'
  else if Prevision < Actual * 0.90 then Result := 'Ligera bajada'
  else Result := 'Estable';
end;

function TPrediccionesForm.AccionTexto(const Actual, Anterior, Porc, Prevision: Double): string;
begin
  if (Anterior <= 0.0001) and (Actual > 0) then Result := 'Revisar si conviene reforzar stock'
  else if (Actual <= 0.0001) and (Anterior > 0) then Result := 'Revisar rotura, baja o cambio de demanda'
  else if Porc >= 25 then Result := 'Vigilar reposición y compras próximas'
  else if Porc <= -25 then Result := 'Evitar sobrecompra y revisar causa'
  else if Prevision > Actual * 1.10 then Result := 'Mantener seguimiento'
  else if Prevision < Actual * 0.90 then Result := 'Comprar con prudencia'
  else Result := 'Sin acción prioritaria';
end;

function TPrediccionesForm.PrioridadTexto(const Actual, Anterior, Porc, UdsActual, UdsAnterior: Double; const Diagnostico: string): string;
var
  D: string;
  M: Double;
begin
  D := UpperCase(Diagnostico);
  M := MinUds;
  Result := 'BAJA';

  if (Pos('RIESGO', D) > 0) and (UdsAnterior >= (M * 3)) then
    Result := 'ALTA'
  else if ((Pos('ALZA', D) > 0) or (Pos('DEMANDA NUEVA', D) > 0)) and (UdsActual >= (M * 4)) then
    Result := 'ALTA'
  else if (Pos('RIESGO', D) > 0) or (Pos('ALZA', D) > 0) or
          (Pos('BAJA', D) > 0) or (Pos('DEMANDA', D) > 0) or
          (Pos('SUBIDA', D) > 0) or (Pos('BAJADA', D) > 0) then
    Result := 'MEDIA';
end;

function TPrediccionesForm.PasaFiltro(const Prioridad, Diagnostico: string): Boolean;
var
  D, P: string;
begin
  Result := True;
  if not Assigned(CmbFiltro) then Exit;

  D := UpperCase(Diagnostico);
  P := UpperCase(Prioridad);
  case CmbFiltro.ItemIndex of
    1: Result := P = 'ALTA';
    2: Result := Pos('RIESGO', D) > 0;
    3: Result := (Pos('ALZA', D) > 0) or (Pos('DEMANDA NUEVA', D) > 0) or
                 (Pos('SUBIDA', D) > 0);
  else
    Result := True;
  end;
end;

procedure TPrediccionesForm.AddRow(const Tipo, Codigo, Descripcion: string; Actual, Anterior, Porc, Prevision: Double; const Confianza, Prioridad, Diagnostico, Accion: string);
var
  R: Integer;
begin
  R := Grid.RowCount;
  Grid.RowCount := R + 1;
  Grid.Cells[0,R] := Tipo;
  Grid.Cells[1,R] := Codigo;
  Grid.Cells[2,R] := Descripcion;
  Grid.Cells[3,R] := FmtMoney(Actual);
  Grid.Cells[4,R] := FmtMoney(Anterior);
  Grid.Cells[5,R] := FmtPct(Porc);
  Grid.Cells[6,R] := FmtMoney(Prevision);
  Grid.Cells[7,R] := Confianza;
  Grid.Cells[8,R] := Prioridad;
  Grid.Cells[9,R] := Diagnostico;
  Grid.Cells[10,R] := Accion;
end;

function TPrediccionesForm.SQLIdent(const S: string): string;
begin
  Result := '`' + StringReplace(S, '`', '', [rfReplaceAll]) + '`';
end;

function TPrediccionesForm.TableName(const Prefix: string): string;
begin
  Result := Prefix + FTienda;
end;

function TPrediccionesForm.DBName: string;
begin
  Result := '';
  if Assigned(FConn) then Result := FConn.Database;
end;

function TPrediccionesForm.TableExists(const ATable: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (FConn = nil) or (not FConn.Connected) or (DBName = '') then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = :db AND TABLE_NAME = :t';
    Q.ParamByName('db').AsString := DBName;
    Q.ParamByName('t').AsString := StringReplace(ATable, '`', '', [rfReplaceAll]);
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

procedure TPrediccionesForm.AnalizarResumen;
var
  Q: TZQuery;
  T: string;
  A, P, Porc, Prev: Double;
  H: Integer;
  Diagnostico, Prioridad: string;
begin
  H := HorizonteDias;
  T := TableName('hisopdd');
  if not TableExists(T) then
  begin
    AddRow('Sistema', T, 'Tabla de ventas no encontrada', 0, 0, 0, 0, 'Sin datos', '', 'No disponible', 'Revisar configuración de tienda');
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT '+
      'SUM(IF(HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), HOD14, 0)) ACT, '+
      'SUM(IF(HOD0 < DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), HOD14, 0)) PREV '+
      'FROM '+SQLIdent(T)+' WHERE HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H*2)+' DAY)';
    Q.Open;
    A := Q.FieldByName('ACT').AsFloat;
    P := Q.FieldByName('PREV').AsFloat;
    if Abs(P) > 0.0001 then Porc := ((A - P) / P) * 100 else if A > 0 then Porc := 100 else Porc := 0;
    Prev := PrevisionValor(A, P);
    Diagnostico := DiagnosticoTexto(A, P, Porc, Prev);
    Prioridad := PrioridadTexto(A, P, Porc, 0, 0, Diagnostico);
    AddRow('Resumen', 'VENTAS', 'Estimación global de ventas para próximos '+IntToStr(H)+' días', A, P, Porc, Prev,
      ConfianzaTexto(A, P), Prioridad, Diagnostico, AccionTexto(A, P, Porc, Prev));
  finally
    Q.Free;
  end;
end;

procedure TPrediccionesForm.AnalizarArticulos;
var
  Q: TZQuery;
  T, ATab, MS: string;
  A, P, Porc, Prev, UAct, UPrev: Double;
  H: Integer;
  Diagnostico, Prioridad: string;
begin
  H := HorizonteDias;
  MS := SQLFloat(MinUds);
  T := TableName('hisopdd');
  ATab := TableName('artitien');
  if not TableExists(T) then
  begin
    AddRow('Sistema', T, 'Tabla de ventas no encontrada', 0,0,0,0,'Sin datos','','No disponible','Revisar configuración');
    Exit;
  end;
  if not TableExists(ATab) then
  begin
    AddRow('Sistema', ATab, 'Tabla de artículos no encontrada', 0,0,0,0,'Sin datos','','No disponible','Revisar configuración');
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT * FROM ( '+
      'SELECT h.HOD6 COD, IFNULL(MAX(a.A1), LEFT(CAST(MAX(h.HOD7) AS CHAR),70)) DES, '+
      'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD14, 0)) ACT, '+
      'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD14, 0)) PREV, '+
      'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD8, 0)) UACT, '+
      'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD8, 0)) UPREV '+
      'FROM '+SQLIdent(T)+' h '+
      'LEFT JOIN '+SQLIdent(ATab)+' a ON a.A0 = h.HOD6 '+
      'WHERE h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H*2)+' DAY) AND IFNULL(h.HOD6,'''') <> '''' '+
      'GROUP BY h.HOD6 '+
      ') X '+
      'WHERE (ABS(X.ACT) > 0.01 OR ABS(X.PREV) > 0.01) '+
      'AND (ABS(X.UACT-X.UPREV) >= '+MS+' OR '+MS+' <= 0) '+
      'ORDER BY ABS(X.UACT-X.UPREV) DESC, ABS(X.ACT-X.PREV) DESC LIMIT 400';
    Q.Open;
    while not Q.EOF do
    begin
      A := Q.FieldByName('ACT').AsFloat;
      P := Q.FieldByName('PREV').AsFloat;
      UAct := Q.FieldByName('UACT').AsFloat;
      UPrev := Q.FieldByName('UPREV').AsFloat;
      if Abs(P) > 0.0001 then Porc := ((A - P) / P) * 100 else if A > 0 then Porc := 100 else Porc := 0;
      Prev := PrevisionValor(A, P);
      Diagnostico := DiagnosticoTexto(A, P, Porc, Prev);
      Prioridad := PrioridadTexto(A, P, Porc, UAct, UPrev, Diagnostico);
      if PasaFiltro(Prioridad, Diagnostico) then
        AddRow('Artículo', Q.FieldByName('COD').AsString, Q.FieldByName('DES').AsString, A, P, Porc, Prev,
          ConfianzaTexto(A, P), Prioridad, Diagnostico, AccionTexto(A, P, Porc, Prev));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TPrediccionesForm.AnalizarFamilias;
var
  Q: TZQuery;
  T, ATab, FTab, MS: string;
  A, P, Porc, Prev, UAct, UPrev: Double;
  H: Integer;
  Diagnostico, Prioridad: string;
begin
  H := HorizonteDias;
  MS := SQLFloat(MinUds);
  T := TableName('hisopdd');
  ATab := TableName('artitien');
  FTab := TableName('familias');
  if not TableExists(T) then
  begin
    AddRow('Sistema', T, 'Tabla de ventas no encontrada', 0,0,0,0,'Sin datos','','No disponible','Revisar configuración');
    Exit;
  end;
  if not TableExists(ATab) then
  begin
    AddRow('Sistema', ATab, 'Tabla de artículos no encontrada', 0,0,0,0,'Sin datos','','No disponible','Revisar configuración');
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    if TableExists(FTab) then
      Q.SQL.Text :=
        'SELECT * FROM ( '+
        'SELECT IFNULL(a.A14,0) COD, IFNULL(MAX(f.F1), ''Sin familia'') DES, '+
        'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD14, 0)) ACT, '+
        'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD14, 0)) PREV, '+
        'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD8, 0)) UACT, '+
        'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD8, 0)) UPREV '+
        'FROM '+SQLIdent(T)+' h '+
        'LEFT JOIN '+SQLIdent(ATab)+' a ON a.A0 = h.HOD6 '+
        'LEFT JOIN '+SQLIdent(FTab)+' f ON f.F0 = a.A14 '+
        'WHERE h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H*2)+' DAY) '+
        'GROUP BY IFNULL(a.A14,0) '+
        ') X WHERE (ABS(X.ACT) > 0.01 OR ABS(X.PREV) > 0.01) '+
        'AND (ABS(X.UACT-X.UPREV) >= '+MS+' OR '+MS+' <= 0) '+
        'ORDER BY ABS(X.UACT-X.UPREV) DESC, ABS(X.ACT-X.PREV) DESC LIMIT 200'
    else
      Q.SQL.Text :=
        'SELECT * FROM ( '+
        'SELECT IFNULL(a.A14,0) COD, CONCAT(''Familia '', IFNULL(a.A14,0)) DES, '+
        'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD14, 0)) ACT, '+
        'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD14, 0)) PREV, '+
        'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD8, 0)) UACT, '+
        'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD8, 0)) UPREV '+
        'FROM '+SQLIdent(T)+' h '+
        'LEFT JOIN '+SQLIdent(ATab)+' a ON a.A0 = h.HOD6 '+
        'WHERE h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H*2)+' DAY) '+
        'GROUP BY IFNULL(a.A14,0) '+
        ') X WHERE (ABS(X.ACT) > 0.01 OR ABS(X.PREV) > 0.01) '+
        'AND (ABS(X.UACT-X.UPREV) >= '+MS+' OR '+MS+' <= 0) '+
        'ORDER BY ABS(X.UACT-X.UPREV) DESC, ABS(X.ACT-X.PREV) DESC LIMIT 200';
    Q.Open;
    while not Q.EOF do
    begin
      A := Q.FieldByName('ACT').AsFloat;
      P := Q.FieldByName('PREV').AsFloat;
      UAct := Q.FieldByName('UACT').AsFloat;
      UPrev := Q.FieldByName('UPREV').AsFloat;
      if Abs(P) > 0.0001 then Porc := ((A - P) / P) * 100 else if A > 0 then Porc := 100 else Porc := 0;
      Prev := PrevisionValor(A, P);
      Diagnostico := DiagnosticoTexto(A, P, Porc, Prev);
      Prioridad := PrioridadTexto(A, P, Porc, UAct, UPrev, Diagnostico);
      if PasaFiltro(Prioridad, Diagnostico) then
        AddRow('Familia', Q.FieldByName('COD').AsString, Q.FieldByName('DES').AsString, A, P, Porc, Prev,
          ConfianzaTexto(A, P), Prioridad, Diagnostico, AccionTexto(A, P, Porc, Prev));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TPrediccionesForm.AnalizarProveedores;
var
  Q: TZQuery;
  T, ATab, PTab, MS: string;
  A, P, Porc, Prev, UAct, UPrev: Double;
  H: Integer;
  Diagnostico, Prioridad: string;
begin
  H := HorizonteDias;
  MS := SQLFloat(MinUds);
  T := TableName('hisopdd');
  ATab := TableName('artitien');
  PTab := 'proveedores';
  if not TableExists(T) then
  begin
    AddRow('Sistema', T, 'Tabla de ventas no encontrada', 0,0,0,0,'Sin datos','','No disponible','Revisar configuración');
    Exit;
  end;
  if not TableExists(ATab) then
  begin
    AddRow('Sistema', ATab, 'Tabla de artículos no encontrada', 0,0,0,0,'Sin datos','','No disponible','Revisar configuración');
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    if TableExists(PTab) then
      Q.SQL.Text :=
        'SELECT * FROM ( '+
        'SELECT IFNULL(a.A32,0) COD, IFNULL(MAX(p.P1), ''Sin proveedor'') DES, '+
        'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD14, 0)) ACT, '+
        'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD14, 0)) PREV, '+
        'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD8, 0)) UACT, '+
        'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD8, 0)) UPREV '+
        'FROM '+SQLIdent(T)+' h '+
        'LEFT JOIN '+SQLIdent(ATab)+' a ON a.A0 = h.HOD6 '+
        'LEFT JOIN '+SQLIdent(PTab)+' p ON p.P0 = a.A32 '+
        'WHERE h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H*2)+' DAY) '+
        'GROUP BY IFNULL(a.A32,0) '+
        ') X WHERE (ABS(X.ACT) > 0.01 OR ABS(X.PREV) > 0.01) '+
        'AND (ABS(X.UACT-X.UPREV) >= '+MS+' OR '+MS+' <= 0) '+
        'ORDER BY ABS(X.UACT-X.UPREV) DESC, ABS(X.ACT-X.PREV) DESC LIMIT 200'
    else
      Q.SQL.Text :=
        'SELECT * FROM ( '+
        'SELECT IFNULL(a.A32,0) COD, CONCAT(''Proveedor '', IFNULL(a.A32,0)) DES, '+
        'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD14, 0)) ACT, '+
        'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD14, 0)) PREV, '+
        'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD8, 0)) UACT, '+
        'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD8, 0)) UPREV '+
        'FROM '+SQLIdent(T)+' h '+
        'LEFT JOIN '+SQLIdent(ATab)+' a ON a.A0 = h.HOD6 '+
        'WHERE h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H*2)+' DAY) '+
        'GROUP BY IFNULL(a.A32,0) '+
        ') X WHERE (ABS(X.ACT) > 0.01 OR ABS(X.PREV) > 0.01) '+
        'AND (ABS(X.UACT-X.UPREV) >= '+MS+' OR '+MS+' <= 0) '+
        'ORDER BY ABS(X.UACT-X.UPREV) DESC, ABS(X.ACT-X.PREV) DESC LIMIT 200';
    Q.Open;
    while not Q.EOF do
    begin
      A := Q.FieldByName('ACT').AsFloat;
      P := Q.FieldByName('PREV').AsFloat;
      UAct := Q.FieldByName('UACT').AsFloat;
      UPrev := Q.FieldByName('UPREV').AsFloat;
      if Abs(P) > 0.0001 then Porc := ((A - P) / P) * 100 else if A > 0 then Porc := 100 else Porc := 0;
      Prev := PrevisionValor(A, P);
      Diagnostico := DiagnosticoTexto(A, P, Porc, Prev);
      Prioridad := PrioridadTexto(A, P, Porc, UAct, UPrev, Diagnostico);
      if PasaFiltro(Prioridad, Diagnostico) then
        AddRow('Proveedor', Q.FieldByName('COD').AsString, Q.FieldByName('DES').AsString, A, P, Porc, Prev,
          ConfianzaTexto(A, P), Prioridad, Diagnostico, AccionTexto(A, P, Porc, Prev));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TPrediccionesForm.AnalizarClientes;
var
  Q: TZQuery;
  T, CTab, CliTab, MS, JoinClientes, DescClientes: string;
  A, P, Porc, Prev, UAct, UPrev: Double;
  H: Integer;
  Diagnostico, Prioridad: string;
begin
  H := HorizonteDias;
  MS := SQLFloat(MinUds);
  T := TableName('hisopdd');
  CTab := TableName('hisopcc');
  CliTab := 'clientes';
  if not TableExists(T) then
  begin
    AddRow('Sistema', T, 'Tabla de ventas no encontrada', 0,0,0,0,'Sin datos','','No disponible','Revisar configuración');
    Exit;
  end;
  if not TableExists(CTab) then
  begin
    AddRow('Sistema', CTab, 'Tabla de cabeceras no encontrada', 0,0,0,0,'Sin datos','','No disponible','Revisar configuración');
    Exit;
  end;

  if TableExists(CliTab) then
  begin
    JoinClientes := ' LEFT JOIN '+SQLIdent(CliTab)+' cli ON cli.C0 = cab.HO8 ';
    DescClientes := 'IFNULL(MAX(cli.C1), CONCAT(''Cliente '', IFNULL(cab.HO8,0)))';
  end
  else
  begin
    JoinClientes := '';
    DescClientes := 'CONCAT(''Cliente '', IFNULL(cab.HO8,0))';
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT * FROM ( '+
      'SELECT IFNULL(cab.HO8,0) COD, '+DescClientes+' DES, '+
      'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD14, 0)) ACT, '+
      'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD14, 0)) PREV, '+
      'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD8, 0)) UACT, '+
      'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H)+' DAY), h.HOD8, 0)) UPREV '+
      'FROM '+SQLIdent(T)+' h '+
      'LEFT JOIN '+SQLIdent(CTab)+' cab ON cab.HO3 = h.HOD3 AND cab.HO4 = h.HOD4 AND cab.HO0 = h.HOD0 '+
      JoinClientes+
      'WHERE h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL '+IntToStr(H*2)+' DAY) AND IFNULL(cab.HO8,0) <> 0 '+
      'GROUP BY IFNULL(cab.HO8,0) '+
      ') X WHERE (ABS(X.ACT) > 0.01 OR ABS(X.PREV) > 0.01) '+
      'AND (ABS(X.UACT-X.UPREV) >= '+MS+' OR '+MS+' <= 0) '+
      'ORDER BY ABS(X.UACT-X.UPREV) DESC, ABS(X.ACT-X.PREV) DESC LIMIT 250';
    Q.Open;
    while not Q.EOF do
    begin
      A := Q.FieldByName('ACT').AsFloat;
      P := Q.FieldByName('PREV').AsFloat;
      UAct := Q.FieldByName('UACT').AsFloat;
      UPrev := Q.FieldByName('UPREV').AsFloat;
      if Abs(P) > 0.0001 then Porc := ((A - P) / P) * 100 else if A > 0 then Porc := 100 else Porc := 0;
      Prev := PrevisionValor(A, P);
      Diagnostico := DiagnosticoTexto(A, P, Porc, Prev);
      Prioridad := PrioridadTexto(A, P, Porc, UAct, UPrev, Diagnostico);
      if PasaFiltro(Prioridad, Diagnostico) then
        AddRow('Cliente', Q.FieldByName('COD').AsString, Q.FieldByName('DES').AsString, A, P, Porc, Prev,
          ConfianzaTexto(A, P), Prioridad, Diagnostico, AccionTexto(A, P, Porc, Prev));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TPrediccionesForm.AnalizarClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    ResetGrid;
    Memo.Clear;
    Memo.Lines.Add('Predicción iniciada: ' + DateTimeToStr(Now));
    Memo.Lines.Add('Horizonte seleccionado: ' + IntToStr(HorizonteDias) + ' días. Mínimo unidades: ' + FormatFloat('#,##0.##', MinUds));
    if Assigned(CmbFiltro) then
      Memo.Lines.Add('Filtro activo: ' + CmbFiltro.Items[CmbFiltro.ItemIndex]);
    case CmbVista.ItemIndex of
      1: AnalizarArticulos;
      2: AnalizarFamilias;
      3: AnalizarProveedores;
      4: AnalizarClientes;
    else
      begin
        AnalizarResumen;
        AnalizarFamilias;
        AnalizarArticulos;
        AnalizarProveedores;
        AnalizarClientes;
      end;
    end;
    RefrescarResumen;
    Memo.Lines.Add('Predicción finalizada. Resultados limitados para mantener agilidad.');
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TPrediccionesForm.RefrescarResumen;
var
  R, Alza, Baja, Revisar: Integer;
  D, C, P: string;
begin
  Alza := 0;
  Baja := 0;
  Revisar := 0;
  for R := 1 to Grid.RowCount - 1 do
  begin
    D := UpperCase(Grid.Cells[9,R]);
    C := UpperCase(Grid.Cells[7,R]);
    P := UpperCase(Grid.Cells[8,R]);
    if (Pos('ALZA', D) > 0) or (Pos('DEMANDA', D) > 0) or (Pos('SUBIDA', D) > 0) then Inc(Alza);
    if (Pos('BAJA', D) > 0) or (Pos('RIESGO', D) > 0) or (Pos('BAJADA', D) > 0) then Inc(Baja);
    if (Pos('RIESGO', D) > 0) or (P = 'ALTA') or (C = 'BAJA') then Inc(Revisar);
  end;
  LblResumen.Caption := Format('Líneas: %d | Al alza: %d | A la baja/rotura: %d | Revisar: %d', [Grid.RowCount-1, Alza, Baja, Revisar]);
  if Assigned(LblKPI1) then LblKPI1.Caption := IntToStr(Grid.RowCount-1);
  if Assigned(LblKPI2) then LblKPI2.Caption := IntToStr(Alza);
  if Assigned(LblKPI3) then LblKPI3.Caption := IntToStr(Baja);
  if Assigned(LblKPI4) then LblKPI4.Caption := IntToStr(Revisar);
  if Assigned(LblKPI5) then LblKPI5.Caption := IntToStr(HorizonteDias) + ' días';
  if Assigned(LblVistaActual) and Assigned(CmbVista) and (CmbVista.ItemIndex >= 0) then
  begin
    LblVistaActual.Caption := 'Vista actual: ' + UpperCase(CmbVista.Items[CmbVista.ItemIndex]);
    if Assigned(CmbFiltro) and (CmbFiltro.ItemIndex > 0) then
      LblVistaActual.Caption := LblVistaActual.Caption + ' / ' + UpperCase(CmbFiltro.Items[CmbFiltro.ItemIndex]);
  end;
  if Assigned(LblSubtituloVista) then
    LblSubtituloVista.Caption := 'Comparando últimos ' + IntToStr(HorizonteDias) + ' días contra los ' + IntToStr(HorizonteDias) + ' días anteriores. Mínimo: ' + FormatFloat('#,##0.##', MinUds) + ' uds.';
end;

procedure TPrediccionesForm.CSVClick(Sender: TObject);
begin
  FLXGuardarCSVConDialogo(Grid,
    'Exportar Predicciones',
    'predicciones_facturlinex_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.csv');
end;

procedure TPrediccionesForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TPrediccionesForm.CerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TPrediccionesForm.GridHeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer);
begin
  if IsColumn then FLXGridOrdenar(Grid, Index, FSortCol, FSortDesc);
end;

procedure TPrediccionesForm.GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
var
  S, P: string;
begin
  if aRow = 0 then Exit;
  FLXGridPrepararCanvasSeleccion(Grid, aRow, aState);
  if gdSelected in aState then Exit;
  S := UpperCase(Grid.Cells[9,aRow]);
  P := UpperCase(Grid.Cells[8,aRow]);
  if P = 'ALTA' then Grid.Canvas.Brush.Color := $00D7D7FF
  else if Pos('ALZA', S) > 0 then Grid.Canvas.Brush.Color := $00D8FFD8
  else if Pos('BAJA', S) > 0 then Grid.Canvas.Brush.Color := $00D8D8FF
  else if Pos('RIESGO', S) > 0 then Grid.Canvas.Brush.Color := $00D7F7FF
  else if Pos('ESTABLE', S) > 0 then Grid.Canvas.Brush.Color := $00F8FFF8;
end;

procedure MostrarPrediccionesFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  F: TPrediccionesForm;
begin
  F := TPrediccionesForm.CreateForm(AOwner, AConnection, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

end.
