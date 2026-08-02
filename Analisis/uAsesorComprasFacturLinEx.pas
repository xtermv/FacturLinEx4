unit uAsesorComprasFacturLinEx;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, LCLType, Dialogs, ExtCtrls, StdCtrls, Buttons,
  Grids, Graphics, IniFiles, ZConnection,
  uFLXCompraAnalyzer, uFLXGridStyle, uFLXExport, uFLXIcons, uFLXDialogs;

procedure MostrarAsesorComprasFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);

implementation

type
  TAsesorComprasFacturLinExForm = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;
    FResultados: TList; // TFLXCompraRecomendacion
    FSortCol: Integer;
    FSortDesc: Boolean;

    HeaderPanel: TPanel;
    ActionPanel: TPanel;
    InfoPanel: TPanel;
    ContentPanel: TPanel;
    TitlePanel: TPanel;
    DetailPanel: TPanel;
    KPIPanel: TPanel;

    Grid: TStringGrid;
    MemoResumen: TMemo;
    MemoDetalle: TMemo;
    EditFiltro: TEdit;
    EditProv1: TEdit;
    EditProv2: TEdit;
    EditProv3: TEdit;
    ChkIncluirOtros: TCheckBox;
    EditMinConf: TEdit;
    EditMinAhorro: TEdit;
    CmbDiagnostico: TComboBox;

    BtnAnalizar: TBitBtn;
    BtnDetalle: TBitBtn;
    BtnCSV: TBitBtn;
    BtnGuardarConfig: TBitBtn;
    BtnCargarConfig: TBitBtn;
    BtnFiltroRecomendado: TBitBtn;
    BtnFiltroRecomendadoLateral: TBitBtn;
    BtnCerrar: TBitBtn;

    LblTitulo: TLabel;
    LblSubtitulo: TLabel;
    LblVistaActual: TLabel;
    LblSubtituloVista: TLabel;
    LblKPIAnalizados: TLabel;
    LblKPICambios: TLabel;
    LblKPIAhorro: TLabel;
    LblKPIConfianza: TLabel;
    LblKPIAvisos: TLabel;

    procedure CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
    procedure CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer = 118);
    procedure CrearBotonLateral(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ATop: Integer);
    procedure CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
    procedure ResetGrid(const Headers: array of string);
    procedure AddRow(const Values: array of string);
    procedure AplicarEstiloGrid;
    procedure AjustarColumnas;
    procedure LimpiarKPIs;
    procedure ActualizarPanelEjecutivo;
    procedure AplicarFiltrosDecision;
    function PasaFiltroDecision(R: TFLXCompraRecomendacion): Boolean;
    procedure ClearResultados;
    procedure AnalizarClick(Sender: TObject);
    procedure DetalleClick(Sender: TObject);
    procedure CSVClick(Sender: TObject);
    procedure GuardarConfigClick(Sender: TObject);
    procedure CargarConfigClick(Sender: TObject);
    procedure FiltroRecomendadoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CerrarClick(Sender: TObject);
    function ConfigFileName: string;
    procedure GuardarConfig;
    procedure CargarConfig;
    procedure GridDblClick(Sender: TObject);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
    procedure CargarAnalisis;
    procedure MostrarDetalleArticulo(const ACodigo: string);
    function RecSeleccionada: TFLXCompraRecomendacion;
  public
    constructor CreateAsesor(AOwner: TComponent; AConnection: TZConnection; const ATienda: string); reintroduce;
    destructor Destroy; override;
  end;

procedure TAsesorComprasFacturLinExForm.CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
begin
  FLXSetBitBtnIcon(ABtn, AIcon, ASize);
end;

procedure TAsesorComprasFacturLinExForm.CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer);
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

procedure TAsesorComprasFacturLinExForm.CrearBotonLateral(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ATop: Integer);
begin
  ABtn := TBitBtn.Create(Self);
  ABtn.Parent := AParent;
  ABtn.Left := 18;
  ABtn.Top := ATop;
  ABtn.Width := 205;
  ABtn.Height := 50;
  ABtn.Caption := ACaption;
  ABtn.Layout := blGlyphLeft;
  ABtn.Font.Style := [fsBold];
  ABtn.ShowHint := True;
  CargarIconoBoton(ABtn, AIcon, 30);
end;

procedure TAsesorComprasFacturLinExForm.CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
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
  P.Width := 210;
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

constructor TAsesorComprasFacturLinExForm.CreateAsesor(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
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
  FResultados := TList.Create;
  FSortCol := -1;
  FSortDesc := False;

  Caption := 'FacturLinEx - Asesor inteligente de compras';
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
  FN := FLXIconFile('asesor_compras', 64);
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
  LblTitulo.Caption := 'Asesor inteligente de compras';
  LblTitulo.Font.Size := 24;
  LblTitulo.Font.Style := [fsBold];
  LblTitulo.Font.Color := RGBToColor(0,32,80);

  LblSubtitulo := TLabel.Create(Self);
  LblSubtitulo.Parent := HeaderPanel;
  LblSubtitulo.Left := 114;
  LblSubtitulo.Top := 68;
  LblSubtitulo.Caption := 'Detecta oportunidades de compra comparando proveedores, recencia, estabilidad, consumo y ahorro estimado. Modo seguro de solo lectura.';
  LblSubtitulo.Font.Size := 11;
  LblSubtitulo.Font.Color := RGBToColor(45,70,105);

  ActionPanel := TPanel.Create(Self);
  ActionPanel.Parent := HeaderPanel;
  ActionPanel.Align := alRight;
  ActionPanel.Width := 875;
  ActionPanel.BevelOuter := bvNone;
  ActionPanel.Color := HeaderPanel.Color;

  CrearBotonAccion(ActionPanel, BtnAnalizar, 'Analizar', 'tend_actualizar', 8, 112);
  BtnAnalizar.Hint := 'Analiza compras comparables de los últimos 12 meses';
  BtnAnalizar.OnClick := @AnalizarClick;

  CrearBotonAccion(ActionPanel, BtnDetalle, 'Detalle', 'doctor', 128, 104);
  BtnDetalle.Hint := 'Muestra la ficha explicativa del artículo seleccionado';
  BtnDetalle.OnClick := @DetalleClick;

  CrearBotonAccion(ActionPanel, BtnCSV, 'Exportar', 'tend_exportar', 240, 104);
  BtnCSV.Hint := 'Exporta el grid actual a CSV';
  BtnCSV.OnClick := @CSVClick;

  CrearBotonAccion(ActionPanel, BtnFiltroRecomendado, 'Filtro útil', 'tend_filtro', 352, 110);
  BtnFiltroRecomendado.Hint := 'Aplica confianza 80%, ahorro 3% y cambios + revisar';
  BtnFiltroRecomendado.OnClick := @FiltroRecomendadoClick;

  CrearBotonAccion(ActionPanel, BtnGuardarConfig, 'Guardar', 'tend_configuracion', 470, 98);
  BtnGuardarConfig.Hint := 'Guarda filtros y umbrales en el ini del usuario';
  BtnGuardarConfig.OnClick := @GuardarConfigClick;

  CrearBotonAccion(ActionPanel, BtnCargarConfig, 'Cargar', 'tend_configuracion', 576, 98);
  BtnCargarConfig.Hint := 'Carga filtros y umbrales guardados';
  BtnCargarConfig.OnClick := @CargarConfigClick;

  CrearBotonAccion(ActionPanel, BtnCerrar, 'Cerrar', 'tend_cerrar', 682, 104);
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
  L.Caption := 'Filtros';
  L.Font.Size := 12;
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,65,145);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 52;
  L.Width := 205;
  L.Height := 36;
  L.WordWrap := True;
  L.Caption := 'Código, descripción o proveedor:';
  L.Font.Color := RGBToColor(45,70,105);

  EditFiltro := TEdit.Create(Self);
  EditFiltro.Parent := InfoPanel;
  EditFiltro.Left := 18;
  EditFiltro.Top := 90;
  EditFiltro.Width := 205;
  EditFiltro.Height := 28;

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 134;
  L.Caption := 'Proveedores concretos';
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,65,145);

  EditProv1 := TEdit.Create(Self);
  EditProv1.Parent := InfoPanel;
  EditProv1.Left := 18;
  EditProv1.Top := 162;
  EditProv1.Width := 61;
  EditProv1.Hint := 'Código proveedor 1';
  EditProv1.ShowHint := True;

  EditProv2 := TEdit.Create(Self);
  EditProv2.Parent := InfoPanel;
  EditProv2.Left := 90;
  EditProv2.Top := 162;
  EditProv2.Width := 61;
  EditProv2.Hint := 'Código proveedor 2';
  EditProv2.ShowHint := True;

  EditProv3 := TEdit.Create(Self);
  EditProv3.Parent := InfoPanel;
  EditProv3.Left := 162;
  EditProv3.Top := 162;
  EditProv3.Width := 61;
  EditProv3.Hint := 'Código proveedor 3 opcional';
  EditProv3.ShowHint := True;

  ChkIncluirOtros := TCheckBox.Create(Self);
  ChkIncluirOtros.Parent := InfoPanel;
  ChkIncluirOtros.Left := 18;
  ChkIncluirOtros.Top := 198;
  ChkIncluirOtros.Width := 210;
  ChkIncluirOtros.Caption := 'Incluir otros del histórico';
  ChkIncluirOtros.Checked := True;
  ChkIncluirOtros.Font.Color := RGBToColor(45,70,105);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 238;
  L.Caption := 'Umbrales';
  L.Font.Size := 12;
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,65,145);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 276;
  L.Caption := 'Confianza mínima %';
  L.Font.Color := RGBToColor(45,70,105);

  EditMinConf := TEdit.Create(Self);
  EditMinConf.Parent := InfoPanel;
  EditMinConf.Left := 160;
  EditMinConf.Top := 270;
  EditMinConf.Width := 63;
  EditMinConf.Text := '0';
  EditMinConf.Hint := '0 muestra todo. Para trabajar: 80';
  EditMinConf.ShowHint := True;

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 316;
  L.Caption := 'Ahorro mínimo %';
  L.Font.Color := RGBToColor(45,70,105);

  EditMinAhorro := TEdit.Create(Self);
  EditMinAhorro.Parent := InfoPanel;
  EditMinAhorro.Left := 160;
  EditMinAhorro.Top := 310;
  EditMinAhorro.Width := 63;
  EditMinAhorro.Text := '0';
  EditMinAhorro.Hint := '0 muestra todo. Para trabajar: 3 o 5';
  EditMinAhorro.ShowHint := True;

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 356;
  L.Caption := 'Diagnóstico';
  L.Font.Color := RGBToColor(45,70,105);

  CmbDiagnostico := TComboBox.Create(Self);
  CmbDiagnostico.Parent := InfoPanel;
  CmbDiagnostico.Left := 18;
  CmbDiagnostico.Top := 382;
  CmbDiagnostico.Width := 205;
  CmbDiagnostico.Style := csDropDownList;
  CmbDiagnostico.Items.Add('Todos');
  CmbDiagnostico.Items.Add('Solo cambios claros');
  CmbDiagnostico.Items.Add('Cambios + revisar');
  CmbDiagnostico.Items.Add('No fiables');
  CmbDiagnostico.ItemIndex := 0;

  CrearBotonLateral(InfoPanel, BtnFiltroRecomendadoLateral, 'Filtro recomendado', 'tend_filtro', 432);
  BtnFiltroRecomendadoLateral.Hint := 'Confianza 80%, ahorro 3%, cambios + revisar';
  BtnFiltroRecomendadoLateral.OnClick := @FiltroRecomendadoClick;

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 510;
  L.Caption := 'Criterios';
  L.Font.Size := 12;
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,65,145);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 546;
  L.Width := 205;
  L.Height := 180;
  L.WordWrap := True;
  L.Caption := 'Motor de compras comparable: no elige solo el más barato. Puntúa precio, recencia, número de compras, cantidades comparables y estabilidad.' + LineEnding +
               'Trabaja con hipedidd' + FTienda + ', artitien' + FTienda + ', proveedores y ventas históricas para estimar consumo anual.' + LineEnding +
               'No modifica compras, artículos ni proveedores.';
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
  LblVistaActual.Caption := 'Oportunidades de compra';
  LblVistaActual.Font.Size := 12;
  LblVistaActual.Font.Style := [fsBold];
  LblVistaActual.Font.Color := RGBToColor(0,65,145);

  LblSubtituloVista := TLabel.Create(Self);
  LblSubtituloVista.Parent := TitlePanel;
  LblSubtituloVista.Left := 16;
  LblSubtituloVista.Top := 38;
  LblSubtituloVista.Caption := 'Pulsa Analizar. Ordena por prioridad, ahorro anual, confianza o diagnóstico para revisar primero lo importante.';
  LblSubtituloVista.Font.Color := RGBToColor(45,70,105);

  KPIPanel := TPanel.Create(Self);
  KPIPanel.Parent := ContentPanel;
  KPIPanel.Align := alBottom;
  KPIPanel.Height := 108;
  KPIPanel.BevelOuter := bvLowered;
  KPIPanel.Color := RGBToColor(250,252,255);

  CrearKPI(KPIPanel, 'Analizados', 'tend_resumen', 12, LblKPIAnalizados);
  CrearKPI(KPIPanel, 'Cambios', 'acciones', 232, LblKPICambios);
  CrearKPI(KPIPanel, 'Ahorro anual', 'tend_kpi_compras', 452, LblKPIAhorro);
  CrearKPI(KPIPanel, 'Confianza', 'tend_kpi_porcentaje', 672, LblKPIConfianza);
  CrearKPI(KPIPanel, 'Avisos', 'alertas', 892, LblKPIAvisos);

  DetailPanel := TPanel.Create(Self);
  DetailPanel.Parent := ContentPanel;
  DetailPanel.Align := alRight;
  DetailPanel.Width := 430;
  DetailPanel.BevelOuter := bvLowered;
  DetailPanel.Color := RGBToColor(250,252,255);

  L := TLabel.Create(Self);
  L.Parent := DetailPanel;
  L.Align := alTop;
  L.Height := 30;
  L.Alignment := taCenter;
  L.Layout := tlCenter;
  L.Caption := 'Ficha explicativa';
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,65,145);

  MemoDetalle := TMemo.Create(Self);
  MemoDetalle.Parent := DetailPanel;
  MemoDetalle.Align := alClient;
  MemoDetalle.ReadOnly := True;
  MemoDetalle.ScrollBars := ssVertical;
  MemoDetalle.Font.Name := 'Monospace';
  MemoDetalle.Color := RGBToColor(252,253,255);
  MemoDetalle.Lines.Text := 'Selecciona una línea y pulsa Detalle, o doble clic sobre el grid.';

  MemoResumen := TMemo.Create(Self);
  MemoResumen.Parent := ContentPanel;
  MemoResumen.Align := alBottom;
  MemoResumen.Height := 78;
  MemoResumen.ReadOnly := True;
  MemoResumen.ScrollBars := ssVertical;
  MemoResumen.Color := RGBToColor(250,252,255);
  MemoResumen.Lines.Text := 'Asesor inteligente de compras listo.' + LineEnding +
                            'Modo seguro: solo lectura, sin cambios en proveedores, compras ni artículos.' + LineEnding +
                            'El motor explica cada recomendación y marca comparaciones no fiables.';

  Grid := TStringGrid.Create(Self);
  Grid.Parent := ContentPanel;
  Grid.Align := alClient;
  Grid.OnDblClick := @GridDblClick;
  Grid.OnMouseDown := @GridMouseDown;
  Grid.OnPrepareCanvas := @GridPrepareCanvas;
  AplicarEstiloGrid;

  ResetGrid(['Prioridad','Impacto','Código','Descripción','Proveedor actual','Coste actual','Proveedor recomendado','Coste recomendado','Ahorro','Consumo anual','Ahorro anual','Confianza','Índice','Diagnóstico','Acción','Motivo principal']);
  AddRow(['','','','','','','','','','','','','','Pulsa Analizar. Puedes filtrar por artículo/proveedor o comparar 2-3 proveedores concretos.','','']);
  AjustarColumnas;
  LimpiarKPIs;
  CargarConfig;
end;

destructor TAsesorComprasFacturLinExForm.Destroy;
begin
  ClearResultados;
  FResultados.Free;
  inherited Destroy;
end;

procedure TAsesorComprasFacturLinExForm.ClearResultados;
var
  I: Integer;
begin
  for I := 0 to FResultados.Count - 1 do TObject(FResultados[I]).Free;
  FResultados.Clear;
end;

procedure TAsesorComprasFacturLinExForm.ResetGrid(const Headers: array of string);
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
  finally
    Grid.EndUpdate;
  end;
end;

procedure TAsesorComprasFacturLinExForm.AddRow(const Values: array of string);
var
  R, I: Integer;
begin
  R := Grid.RowCount;
  Grid.RowCount := R + 1;
  for I := Low(Values) to High(Values) do
    if I < Grid.ColCount then Grid.Cells[I,R] := Values[I];
end;

procedure TAsesorComprasFacturLinExForm.AplicarEstiloGrid;
begin
  FLXGridPreparar(Grid);
  Grid.DefaultRowHeight := 24;
  Grid.Options := Grid.Options + [goColSizing, goRowSelect, goThumbTracking];
end;

procedure TAsesorComprasFacturLinExForm.AjustarColumnas;
begin
  if Grid.ColCount >= 16 then
  begin
    Grid.ColWidths[0] := 75;
    Grid.ColWidths[1] := 62;
    Grid.ColWidths[2] := 82;
    Grid.ColWidths[3] := 245;
    Grid.ColWidths[4] := 155;
    Grid.ColWidths[5] := 84;
    Grid.ColWidths[6] := 170;
    Grid.ColWidths[7] := 92;
    Grid.ColWidths[8] := 70;
    Grid.ColWidths[9] := 96;
    Grid.ColWidths[10] := 92;
    Grid.ColWidths[11] := 76;
    Grid.ColWidths[12] := 58;
    Grid.ColWidths[13] := 110;
    Grid.ColWidths[14] := 190;
    Grid.ColWidths[15] := 340;
  end
  else
    FLXGridAutoAjustar(Grid, 60, 360);
end;

procedure TAsesorComprasFacturLinExForm.LimpiarKPIs;
begin
  if Assigned(LblKPIAnalizados) then LblKPIAnalizados.Caption := '0';
  if Assigned(LblKPICambios) then LblKPICambios.Caption := '0';
  if Assigned(LblKPIAhorro) then LblKPIAhorro.Caption := '0,00 €';
  if Assigned(LblKPIConfianza) then LblKPIConfianza.Caption := '0 %';
  if Assigned(LblKPIAvisos) then LblKPIAvisos.Caption := '0';
end;

function StrToFloatDefFLX(const S: string; Def: Double): Double;
var
  T: string;
begin
  T := Trim(S);
  T := StringReplace(T, ',', '.', [rfReplaceAll]);
  Result := StrToFloatDef(T, Def);
end;

function TAsesorComprasFacturLinExForm.PasaFiltroDecision(R: TFLXCompraRecomendacion): Boolean;
var
  MinConf: Integer;
  MinAhorro: Double;
  Modo: Integer;
begin
  Result := False;
  if R = nil then Exit;
  MinConf := StrToIntDef(Trim(EditMinConf.Text), 0);
  MinAhorro := StrToFloatDefFLX(EditMinAhorro.Text, 0);
  Modo := CmbDiagnostico.ItemIndex;

  if R.Confianza < MinConf then Exit;
  if R.AhorroPct < MinAhorro then Exit;

  case Modo of
    1: if R.Diagnostico <> 'CAMBIO CLARO' then Exit;
    2: if (R.Diagnostico <> 'CAMBIO CLARO') and (R.Diagnostico <> 'REVISAR') then Exit;
    3: if R.Diagnostico <> 'NO FIABLE' then Exit;
  end;
  Result := True;
end;

procedure TAsesorComprasFacturLinExForm.AplicarFiltrosDecision;
var
  I: Integer;
begin
  I := 0;
  while I < FResultados.Count do
  begin
    if not PasaFiltroDecision(TFLXCompraRecomendacion(FResultados[I])) then
    begin
      TObject(FResultados[I]).Free;
      FResultados.Delete(I);
    end
    else
      Inc(I);
  end;
end;

procedure TAsesorComprasFacturLinExForm.ActualizarPanelEjecutivo;
var
  I, CambiosClaros, Revisar, NoFiables, SumaIndice, SumaConf, Avisos: Integer;
  AhorroAnual: Double;
  R: TFLXCompraRecomendacion;
begin
  CambiosClaros := 0;
  Revisar := 0;
  NoFiables := 0;
  Avisos := 0;
  SumaIndice := 0;
  SumaConf := 0;
  AhorroAnual := 0;
  for I := 0 to FResultados.Count - 1 do
  begin
    R := TFLXCompraRecomendacion(FResultados[I]);
    SumaIndice := SumaIndice + R.IndiceCompra;
    SumaConf := SumaConf + R.Confianza;
    if R.AhorroAnual > 0 then AhorroAnual := AhorroAnual + R.AhorroAnual;
    if R.Diagnostico = 'CAMBIO CLARO' then Inc(CambiosClaros)
    else if R.Diagnostico = 'REVISAR' then Inc(Revisar)
    else if R.Diagnostico = 'NO FIABLE' then Inc(NoFiables);
    if (R.Prioridad = 'ALTA') or (R.Diagnostico = 'NO FIABLE') then Inc(Avisos);
  end;

  LblKPIAnalizados.Caption := IntToStr(FResultados.Count);
  LblKPICambios.Caption := IntToStr(CambiosClaros) + ' / ' + IntToStr(Revisar);
  LblKPIAhorro.Caption := FormatFloat('#,##0.00', AhorroAnual) + ' €';
  if FResultados.Count > 0 then
    LblKPIConfianza.Caption := IntToStr(Round(SumaConf / FResultados.Count)) + ' %'
  else
    LblKPIConfianza.Caption := '0 %';
  LblKPIAvisos.Caption := IntToStr(Avisos + NoFiables);

  if FResultados.Count > 0 then
    LblSubtituloVista.Caption := 'Índice medio ' + IntToStr(Round(SumaIndice / FResultados.Count)) + '/100. Cambios claros: ' +
      IntToStr(CambiosClaros) + '. Revisar: ' + IntToStr(Revisar) + '. No fiables: ' + IntToStr(NoFiables) + '.'
  else
    LblSubtituloVista.Caption := 'Sin oportunidades con los filtros actuales.';
end;

function TAsesorComprasFacturLinExForm.RecSeleccionada: TFLXCompraRecomendacion;
var
  I: Integer;
  Cod: string;
begin
  Result := nil;
  if (Grid.Row <= 0) or (Grid.ColCount <= 2) then Exit;
  Cod := Trim(Grid.Cells[2, Grid.Row]);
  if Cod = '' then Exit;
  for I := 0 to FResultados.Count - 1 do
    if TFLXCompraRecomendacion(FResultados[I]).CodigoArticulo = Cod then
      Exit(TFLXCompraRecomendacion(FResultados[I]));
end;

procedure TAsesorComprasFacturLinExForm.CargarAnalisis;
var
  Analyzer: TFLXCompraAnalyzer;
  Resumen: TStringList;
  I: Integer;
  R: TFLXCompraRecomendacion;
  ActNom, RecNom: string;
begin
  ClearResultados;
  ResetGrid(['Prioridad','Impacto','Código','Descripción','Proveedor actual','Coste actual','Proveedor recomendado','Coste recomendado','Ahorro','Consumo anual','Ahorro anual','Confianza','Índice','Diagnóstico','Acción','Motivo principal']);
  AjustarColumnas;
  LimpiarKPIs;
  MemoDetalle.Lines.Text := 'Analizando...';
  LblVistaActual.Caption := 'Analizando oportunidades de compra';

  Analyzer := TFLXCompraAnalyzer.Create(FConn, FTienda);
  Resumen := TStringList.Create;
  try
    Analyzer.MaxFilasSQL := 4000;
    Analyzer.Analizar(EditFiltro.Text, EditProv1.Text, EditProv2.Text, EditProv3.Text, ChkIncluirOtros.Checked, FResultados, Resumen);
    MemoResumen.Lines.Assign(Resumen);
    MemoResumen.Lines.Add('Filtros aplicados: confianza >= ' + EditMinConf.Text +
      ' | ahorro % >= ' + EditMinAhorro.Text +
      ' | modo: ' + CmbDiagnostico.Text);
    AplicarFiltrosDecision;

    Grid.BeginUpdate;
    try
      for I := 0 to FResultados.Count - 1 do
      begin
        R := TFLXCompraRecomendacion(FResultados[I]);
        ActNom := R.ProveedorActual + ' - ' + R.ProveedorActualNombre;
        RecNom := R.ProveedorRecomendado + ' - ' + R.ProveedorRecomendadoNombre;
        AddRow([R.Prioridad, IntToStr(R.ImpactoScore), R.CodigoArticulo, R.Descripcion, ActNom,
          FormatFloat('0.00000', R.PrecioActual), RecNom,
          FormatFloat('0.00000', R.PrecioRecomendado),
          FormatFloat('0.00', R.AhorroPct) + ' %',
          FormatFloat('0.##', R.ConsumoAnual),
          FormatFloat('#,##0.00', R.AhorroAnual),
          IntToStr(R.Confianza) + ' %',
          IntToStr(R.IndiceCompra), R.Diagnostico, R.Accion, R.MotivoPrincipal]);
      end;
      if Grid.RowCount = 1 then
        AddRow(['','','','','','','','','','','','','','Sin artículos comparables con los filtros indicados.','','']);
    finally
      Grid.EndUpdate;
    end;

    AjustarColumnas;
    ActualizarPanelEjecutivo;
    LblVistaActual.Caption := 'Oportunidades de compra';
    MemoDetalle.Lines.Text := 'Análisis terminado. Selecciona una línea y pulsa Detalle.';
  finally
    Resumen.Free;
    Analyzer.Free;
  end;
end;

procedure TAsesorComprasFacturLinExForm.MostrarDetalleArticulo(const ACodigo: string);
var
  Analyzer: TFLXCompraAnalyzer;
  R: TFLXCompraRecomendacion;
  I: Integer;
  S: TStringList;
  St: TFLXProveedorCompraStat;
begin
  R := RecSeleccionada;
  if R = nil then
  begin
    FLXWarning('Selecciona primero una línea válida del análisis.', 'Asesor de compras');
    Exit;
  end;

  MemoDetalle.Clear;
  MemoDetalle.Lines.Add('===============================================');
  MemoDetalle.Lines.Add('  FICHA INTELIGENTE DE COMPRA');
  MemoDetalle.Lines.Add('===============================================');
  MemoDetalle.Lines.Add('Artículo: ' + R.CodigoArticulo);
  MemoDetalle.Lines.Add(R.Descripcion);
  MemoDetalle.Lines.Add('');
  MemoDetalle.Lines.Add('DIAGNÓSTICO');
  MemoDetalle.Lines.Add('  Prioridad: ' + R.Prioridad + '  Impacto: ' + IntToStr(R.ImpactoScore) + '/100');
  MemoDetalle.Lines.Add('  ' + R.Diagnostico + ' - ' + R.Accion);
  MemoDetalle.Lines.Add('  ' + R.MotivoPrincipal);
  MemoDetalle.Lines.Add('');
  MemoDetalle.Lines.Add('PROVEEDOR ACTUAL');
  MemoDetalle.Lines.Add('  ' + R.ProveedorActual + ' - ' + R.ProveedorActualNombre);
  MemoDetalle.Lines.Add('  Coste medio: ' + FormatFloat('0.00000', R.PrecioActual));
  MemoDetalle.Lines.Add('');
  MemoDetalle.Lines.Add('PROVEEDOR RECOMENDADO');
  MemoDetalle.Lines.Add('  ' + R.ProveedorRecomendado + ' - ' + R.ProveedorRecomendadoNombre);
  MemoDetalle.Lines.Add('  Coste medio: ' + FormatFloat('0.00000', R.PrecioRecomendado));
  MemoDetalle.Lines.Add('  Ahorro unitario: ' + FormatFloat('0.00000', R.AhorroUnitario));
  MemoDetalle.Lines.Add('  Ahorro %: ' + FormatFloat('0.00', R.AhorroPct) + ' %');
  MemoDetalle.Lines.Add('  Consumo anual estimado: ' + FormatFloat('0.##', R.ConsumoAnual));
  MemoDetalle.Lines.Add('  Ahorro anual estimado: ' + FormatFloat('#,##0.00', R.AhorroAnual) + ' EUR');
  MemoDetalle.Lines.Add('  Confianza: ' + IntToStr(R.Confianza) + ' %');
  MemoDetalle.Lines.Add('  Índice compra: ' + IntToStr(R.IndiceCompra) + '/100');
  MemoDetalle.Lines.Add('');
  MemoDetalle.Lines.Add('RANKING DE PROVEEDORES');
  MemoDetalle.Lines.Add('  Prov.      Compras  Media uds  Precio     Score  Última');
  MemoDetalle.Lines.Add('  -------------------------------------------------------');
  for I := 0 to R.Proveedores.Count - 1 do
  begin
    St := TFLXProveedorCompraStat(R.Proveedores[I]);
    MemoDetalle.Lines.Add('  ' + St.Codigo + '  ' + Copy(St.Nombre,1,13) +
      '  C:' + IntToStr(St.Compras) +
      '  U:' + FormatFloat('0.##', St.MediaUds) +
      '  P:' + FormatFloat('0.00000', St.PrecioMedio) +
      '  S:' + IntToStr(St.Score) +
      '  ' + St.UltFecha);
  end;
  MemoDetalle.Lines.Add('');
  MemoDetalle.Lines.Add('MOTIVOS');
  for I := 0 to R.Motivos.Count - 1 do
    MemoDetalle.Lines.Add('  - ' + R.Motivos[I]);
  MemoDetalle.Lines.Add('');
  MemoDetalle.Lines.Add('HISTÓRICO RECIENTE');
  MemoDetalle.Lines.Add('  Fecha       Proveedor                Uds      Coste');
  MemoDetalle.Lines.Add('  -------------------------------------------------------');

  Analyzer := TFLXCompraAnalyzer.Create(FConn, FTienda);
  S := TStringList.Create;
  try
    Analyzer.CargarHistoricoArticulo(ACodigo, S);
    MemoDetalle.Lines.AddStrings(S);
  finally
    S.Free;
    Analyzer.Free;
  end;
end;

procedure TAsesorComprasFacturLinExForm.AnalizarClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    try
      CargarAnalisis;
    except
      on E: Exception do
      begin
        ClearResultados;
        ResetGrid(['Prioridad','Impacto','Código','Descripción','Proveedor actual','Coste actual','Proveedor recomendado','Coste recomendado','Ahorro','Consumo anual','Ahorro anual','Confianza','Índice','Diagnóstico','Acción','Motivo principal']);
        AddRow(['','','','','','','','','','','','','','Error: ' + E.Message,'','']);
        AjustarColumnas;
        LimpiarKPIs;
        MemoDetalle.Lines.Text := 'Error durante el análisis: ' + E.Message;
        MemoResumen.Lines.Text := 'No se pudo completar el análisis.' + LineEnding + E.Message;
        LblVistaActual.Caption := 'Error en análisis';
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TAsesorComprasFacturLinExForm.DetalleClick(Sender: TObject);
begin
  if (Grid.Row > 0) and (Grid.ColCount > 2) then
    MostrarDetalleArticulo(Grid.Cells[2, Grid.Row])
  else
    FLXWarning('Selecciona primero una línea.', 'Asesor de compras');
end;

procedure TAsesorComprasFacturLinExForm.GridDblClick(Sender: TObject);
begin
  DetalleClick(Sender);
end;

procedure TAsesorComprasFacturLinExForm.GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  C, R: Integer;
begin
  if Button <> mbLeft then Exit;
  Grid.MouseToCell(X, Y, C, R);
  if (R = 0) and (C >= 0) then
  begin
    FLXGridOrdenar(Grid, C, FSortCol, FSortDesc);
    if Grid.RowCount > 1 then Grid.Row := 1;
  end;
end;

procedure TAsesorComprasFacturLinExForm.GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
var
  Pri, Diag: string;
begin
  FLXGridPrepararCanvasSeleccion(Grid, aRow, aState);
  if (aRow <= 0) or (aRow >= Grid.RowCount) then Exit;
  if gdSelected in aState then Exit;

  Pri := UpperCase(Trim(Grid.Cells[0, aRow]));
  Diag := UpperCase(Trim(Grid.Cells[13, aRow]));

  if Pri = 'ALTA' then
    Grid.Canvas.Brush.Color := $00D6D6FF
  else if Pri = 'MEDIA' then
    Grid.Canvas.Brush.Color := $00C8FFFF
  else if Diag = 'NO FIABLE' then
    Grid.Canvas.Brush.Color := $00E8E8E8
  else if Diag = 'CAMBIO CLARO' then
    Grid.Canvas.Brush.Color := $00D8FFD8;
  Grid.Canvas.Font.Color := clBlack;
end;

procedure TAsesorComprasFacturLinExForm.CSVClick(Sender: TObject);
var
  F: string;
begin
  F := 'asesor_compras_facturlinex_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.csv';
  if FLXGuardarCSVConDialogo(Grid, 'Exportar asesor de compras', F) then
    FLXInfo('CSV generado correctamente.', 'Asesor de compras');
end;

function TAsesorComprasFacturLinExForm.ConfigFileName: string;
var
  Dir: string;
begin
  Dir := IncludeTrailingPathDelimiter(GetUserDir) + '.config/facturlinex';
  if not DirectoryExists(Dir) then
    ForceDirectories(Dir);
  Result := IncludeTrailingPathDelimiter(Dir) + 'asesor_compras.ini';
end;

procedure TAsesorComprasFacturLinExForm.GuardarConfig;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ConfigFileName);
  try
    Ini.WriteString('Filtros', 'Texto', EditFiltro.Text);
    Ini.WriteString('Filtros', 'Proveedor1', EditProv1.Text);
    Ini.WriteString('Filtros', 'Proveedor2', EditProv2.Text);
    Ini.WriteString('Filtros', 'Proveedor3', EditProv3.Text);
    Ini.WriteBool('Filtros', 'IncluirOtros', ChkIncluirOtros.Checked);
    Ini.WriteString('Decision', 'MinConfianza', EditMinConf.Text);
    Ini.WriteString('Decision', 'MinAhorro', EditMinAhorro.Text);
    Ini.WriteInteger('Decision', 'Diagnostico', CmbDiagnostico.ItemIndex);
  finally
    Ini.Free;
  end;
end;

procedure TAsesorComprasFacturLinExForm.CargarConfig;
var
  Ini: TIniFile;
  Idx: Integer;
begin
  if not FileExists(ConfigFileName) then Exit;
  Ini := TIniFile.Create(ConfigFileName);
  try
    EditFiltro.Text := Ini.ReadString('Filtros', 'Texto', EditFiltro.Text);
    EditProv1.Text := Ini.ReadString('Filtros', 'Proveedor1', EditProv1.Text);
    EditProv2.Text := Ini.ReadString('Filtros', 'Proveedor2', EditProv2.Text);
    EditProv3.Text := Ini.ReadString('Filtros', 'Proveedor3', EditProv3.Text);
    ChkIncluirOtros.Checked := Ini.ReadBool('Filtros', 'IncluirOtros', ChkIncluirOtros.Checked);
    EditMinConf.Text := Ini.ReadString('Decision', 'MinConfianza', EditMinConf.Text);
    EditMinAhorro.Text := Ini.ReadString('Decision', 'MinAhorro', EditMinAhorro.Text);
    Idx := Ini.ReadInteger('Decision', 'Diagnostico', CmbDiagnostico.ItemIndex);
    if (Idx >= 0) and (Idx < CmbDiagnostico.Items.Count) then CmbDiagnostico.ItemIndex := Idx;
  finally
    Ini.Free;
  end;
end;

procedure TAsesorComprasFacturLinExForm.GuardarConfigClick(Sender: TObject);
begin
  try
    GuardarConfig;
    FLXInfo('Configuración guardada en:' + LineEnding + ConfigFileName, 'Asesor de compras');
  except
    on E: Exception do FLXError('No se pudo guardar la configuración: ' + E.Message, 'Asesor de compras');
  end;
end;

procedure TAsesorComprasFacturLinExForm.CargarConfigClick(Sender: TObject);
begin
  try
    CargarConfig;
    FLXInfo('Configuración cargada. Pulsa Analizar para aplicar los filtros.', 'Asesor de compras');
  except
    on E: Exception do FLXError('No se pudo cargar la configuración: ' + E.Message, 'Asesor de compras');
  end;
end;

procedure TAsesorComprasFacturLinExForm.FiltroRecomendadoClick(Sender: TObject);
begin
  EditMinConf.Text := '80';
  EditMinAhorro.Text := '3';
  if CmbDiagnostico.Items.Count > 2 then
    CmbDiagnostico.ItemIndex := 2;
  FLXInfo('Filtro recomendado aplicado.' + LineEnding +
    'Confianza mínima: 80%' + LineEnding +
    'Ahorro mínimo: 3%' + LineEnding +
    'Diagnóstico: cambios + revisar' + LineEnding + LineEnding +
    'Pulsa Analizar para recalcular con estos criterios.', 'Asesor de compras');
end;

procedure TAsesorComprasFacturLinExForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TAsesorComprasFacturLinExForm.CerrarClick(Sender: TObject);
begin
  Close;
end;

procedure MostrarAsesorComprasFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  F: TAsesorComprasFacturLinExForm;
begin
  F := TAsesorComprasFacturLinExForm.CreateAsesor(AOwner, AConnection, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

end.
