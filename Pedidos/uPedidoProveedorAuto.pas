unit uPedidoProveedorAuto;

{$mode objfpc}{$H+}
{$codepage utf8}

{
  FacturLinEx - Propuesta automática de pedido por proveedor
  Version: 2026-06-20-v1.7-STOCK-CONTADO-CANTIDAD-FINAL

  OBJETIVO
  --------
  Generar una PROPUESTA revisable de pedido a proveedor usando ventas reales
  e historial de compras a ese proveedor, sin fiarse del stock actual.

  Esta primera versión NO crea pedido real en pedicc/pedidd.
  Solo consulta y muestra sugerencias en pantalla, permite exportar CSV/PDF, visualizar el PDF con apertura robusta, imprimir, ordenar por columnas y añade un modo de pedido depurado limitado por prioridad y filtros finos.

  v1.6:
  - Diferencia visualmente dias a cubrir del pedido y dias de analisis de ventas.
  - Anade periodo corto de tendencia, por defecto dia actual del mes.
  - El calculo puede reforzarse con tendencia reciente para no quedarse corto si el articulo acelera ventas.
  - Observaciones muestra la formula usada en cada linea.

  v1.7:
  - Anade columnas editables Stock contado y Cantidad final.
  - Si se introduce Stock contado, Cantidad final = Sugerido - Stock contado, sin bajar de cero.
  - CSV, PDF e impresion usan Cantidad final y el orden visible del grid.

  Integración esperada:
    uses uPedidoProveedorAuto;

    MostrarPedidoProveedorAuto(Self, TuConexionZConnection, Tienda);

  Donde Tienda suele ser '0000', '0001', etc. según FacturLinEx.
}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Grids, Spin, DateUtils, Math, DB, Types, Printers, LConvEncoding, LCLIntf, LazUTF8,
  Process, ZConnection, ZDataset;

type

  TLineaPedidoAuto = record
    Codigo: string;
    Descripcion: string;
    VendidoPeriodo: Double;
    VendidoHistorico: Double;
    VendidoTendencia: Double;
    VentaDia: Double;
    Sugerido: Double;
    UltVenta: string;
    UltCompra: string;
    Coste: Double;
    PVP: Double;
    IVA: Double;
    StockInfo: Double;
    Familia: string;
    Estado: string;
    Observaciones: string;
    Prioridad: Double;
  end;

  TArrayLineaPedidoAuto = array of TLineaPedidoAuto;

  { TfPedidoProveedorAuto }

  TfPedidoProveedorAuto = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;
    FListaProveedores: TStringList;
    FSortCol: Integer;
    FSortAsc: Boolean;

    PanelTop: TPanel;
    PanelBottom: TPanel;
    Grid: TStringGrid;

    lblBuscarProveedor: TLabel;
    edtBuscarProveedor: TEdit;
    btnLimpiarProveedor: TButton;
    lblProveedor: TLabel;
    cbProveedor: TComboBox;
    lblDiasCubrir: TLabel;
    seDiasCubrir: TSpinEdit;
    lblDiasVentas: TLabel;
    seDiasVentas: TSpinEdit;
    lblDiasHistorico: TLabel;
    seDiasHistorico: TSpinEdit;
    lblDiasTendencia: TLabel;
    seDiasTendencia: TSpinEdit;
    chkUsarTendencia: TCheckBox;
    lblFactor: TLabel;
    edtFactor: TEdit;
    lblMaxLineas: TLabel;
    seMaxLineas: TSpinEdit;
    lblMinSugerido: TLabel;
    seMinSugerido: TSpinEdit;
    lblMinVentas: TLabel;
    seMinVentas: TSpinEdit;
    lblMinHistorico: TLabel;
    seMinHistorico: TSpinEdit;
    chkIncluirRoturas: TCheckBox;
    chkExcluirRaros: TCheckBox;
    chkMostrarCero: TCheckBox;
    chkAbrirPDF: TCheckBox;

    btnCalcular: TButton;
    btnPedidoDepurado: TButton;
    btnExportar: TButton;
    btnPDF: TButton;
    btnImprimir: TButton;
    btnOrdenTienda: TButton;
    btnRecalcularFinal: TButton;
    btnCerrar: TButton;

    lblEstado: TLabel;

    procedure BtnCalcularClick(Sender: TObject);
    procedure BtnPedidoDepuradoClick(Sender: TObject);
    procedure BtnExportarClick(Sender: TObject);
    procedure BtnPDFClick(Sender: TObject);
    procedure BtnImprimirClick(Sender: TObject);
    procedure BtnOrdenTiendaClick(Sender: TObject);
    procedure BtnRecalcularFinalClick(Sender: TObject);
    procedure BtnCerrarClick(Sender: TObject);
    procedure GridEditingDone(Sender: TObject);
    procedure GridSelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
    procedure EdtBuscarProveedorChange(Sender: TObject);
    procedure BtnLimpiarProveedorClick(Sender: TObject);
    procedure GridHeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer);

    procedure ConstruirInterfaz;
    procedure InicializarGrid;
    procedure CargarProveedores;
    procedure FiltrarProveedores(const Texto: string);
    procedure OrdenarGridPorColumna(const Col: Integer; const Ascendente: Boolean);
    procedure ActualizarCabecerasOrden;
    procedure CalcularPropuesta(const Depurada: Boolean);
    procedure RecalcularCantidadFinalFila(const ARow: Integer);
    procedure RecalcularTodasCantidadesFinales;
    procedure OrdenarPorPrioridad(var Lineas: TArrayLineaPedidoAuto);
    procedure PintarLineasEnGrid(const Lineas: TArrayLineaPedidoAuto; const Limite: Integer);

    function CodigoProveedorSeleccionado: Integer;
    function NombreProveedorSeleccionado: string;
    function SufijoTiendaSeguro(const S: string): string;
    function TablaExiste(const NombreTabla: string): Boolean;
    function SQLComprasProveedor(const CodProveedor: Integer): string;
    function SQLVentas(const FechaDesdeHistorico, FechaHasta: TDateTime): string;
    function SQLFinal(const CodProveedor: Integer; const FechaDesdeHistorico,
      FechaHasta: TDateTime): string;

    function FloatSeguro(const S: string; const Def: Double): Double;
    function CompararCeldas(const A, B: string; const Col: Integer): Integer;
    function EsColumnaNumerica(const Col: Integer): Boolean;
    function EsColumnaFecha(const Col: Integer): Boolean;
    function TextoContiene(const Texto, Busqueda: string): Boolean;
    function RedondearArriba(const Valor: Double): Double;
    function FechaSQL(const Fecha: TDateTime): string;
    function CSVSeguro(const S: string): string;
    function PDFTextoSeguro(const S: string): AnsiString;
    function PDFNum(const V: Double): string;
    function HayDatosEnGrid: Boolean;
    function AbrirPDFGenerado(const NombreFichero: string; out Metodo, ErrorDetalle: string): Boolean;
    function IntentarAbrirConPrograma(const Programa, NombreFichero: string; out ErrorDetalle: string): Boolean;
    procedure GenerarPDFDesdeGrid(const NombreFichero: string);
    procedure ImprimirGrid;
    procedure AutoAjustarColumnas;

  public
    constructor CreateAuto(AOwner: TComponent; AConn: TZConnection;
      const ATienda: string); reintroduce;
    destructor Destroy; override;
  end;

procedure MostrarPedidoProveedorAuto(AOwner: TComponent; AConn: TZConnection;
  const ATienda: string);

implementation

procedure MostrarPedidoProveedorAuto(AOwner: TComponent; AConn: TZConnection;
  const ATienda: string);
var
  F: TfPedidoProveedorAuto;
begin
  F := TfPedidoProveedorAuto.CreateAuto(AOwner, AConn, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

{ TfPedidoProveedorAuto }

constructor TfPedidoProveedorAuto.CreateAuto(AOwner: TComponent;
  AConn: TZConnection; const ATienda: string);
begin
  // Formulario sin .lfm: hay que usar CreateNew para que Lazarus no intente cargar recurso .lfm
  inherited CreateNew(AOwner, 0);

  FConn := AConn;
  FTienda := SufijoTiendaSeguro(ATienda);
  FListaProveedores := TStringList.Create;
  FSortCol := -1;
  FSortAsc := True;

  Caption := 'Propuesta de pedido por proveedor';
  Position := poScreenCenter;
  Width := 1250;
  Height := 720;
  WindowState := wsMaximized;

  ConstruirInterfaz;
  InicializarGrid;
  CargarProveedores;
end;

destructor TfPedidoProveedorAuto.Destroy;
begin
  FreeAndNil(FListaProveedores);
  inherited Destroy;
end;

procedure TfPedidoProveedorAuto.ConstruirInterfaz;
begin
  PanelTop := TPanel.Create(Self);
  PanelTop.Parent := Self;
  PanelTop.Align := alTop;
  PanelTop.Height := 150;
  PanelTop.BevelOuter := bvNone;

  lblBuscarProveedor := TLabel.Create(Self);
  lblBuscarProveedor.Parent := PanelTop;
  lblBuscarProveedor.Left := 10;
  lblBuscarProveedor.Top := 12;
  lblBuscarProveedor.Caption := 'Buscar proveedor:';

  edtBuscarProveedor := TEdit.Create(Self);
  edtBuscarProveedor.Parent := PanelTop;
  edtBuscarProveedor.Left := 125;
  edtBuscarProveedor.Top := 8;
  edtBuscarProveedor.Width := 210;
  edtBuscarProveedor.Hint := 'Escriba código o nombre del proveedor';
  edtBuscarProveedor.ShowHint := True;
  edtBuscarProveedor.OnChange := @EdtBuscarProveedorChange;

  btnLimpiarProveedor := TButton.Create(Self);
  btnLimpiarProveedor.Parent := PanelTop;
  btnLimpiarProveedor.Left := 342;
  btnLimpiarProveedor.Top := 8;
  btnLimpiarProveedor.Width := 55;
  btnLimpiarProveedor.Caption := 'Todos';
  btnLimpiarProveedor.OnClick := @BtnLimpiarProveedorClick;

  lblProveedor := TLabel.Create(Self);
  lblProveedor.Parent := PanelTop;
  lblProveedor.Left := 410;
  lblProveedor.Top := 12;
  lblProveedor.Caption := 'Proveedor:';

  cbProveedor := TComboBox.Create(Self);
  cbProveedor.Parent := PanelTop;
  cbProveedor.Left := 485;
  cbProveedor.Top := 8;
  cbProveedor.Width := 430;
  cbProveedor.Style := csDropDownList;

  lblDiasCubrir := TLabel.Create(Self);
  lblDiasCubrir.Parent := PanelTop;
  lblDiasCubrir.Left := 10;
  lblDiasCubrir.Top := 44;
  lblDiasCubrir.Caption := 'Días pedido a cubrir:';
  lblDiasCubrir.Hint := 'Días que quieres cubrir con el pedido. No se usa para contar ventas.';
  lblDiasCubrir.ShowHint := True;

  seDiasCubrir := TSpinEdit.Create(Self);
  seDiasCubrir.Parent := PanelTop;
  seDiasCubrir.Left := 150;
  seDiasCubrir.Top := 40;
  seDiasCubrir.Width := 70;
  seDiasCubrir.MinValue := 1;
  seDiasCubrir.MaxValue := 365;
  seDiasCubrir.Value := 15;

  lblDiasVentas := TLabel.Create(Self);
  lblDiasVentas.Parent := PanelTop;
  lblDiasVentas.Left := 235;
  lblDiasVentas.Top := 44;
  lblDiasVentas.Caption := 'Analizar ventas días:';
  lblDiasVentas.Hint := 'Días hacia atrás usados para calcular la venta media principal. No son los días del pedido.';
  lblDiasVentas.ShowHint := True;

  seDiasVentas := TSpinEdit.Create(Self);
  seDiasVentas.Parent := PanelTop;
  seDiasVentas.Left := 365;
  seDiasVentas.Top := 40;
  seDiasVentas.Width := 70;
  seDiasVentas.MinValue := 1;
  seDiasVentas.MaxValue := 730;
  seDiasVentas.Value := 60;
  seDiasVentas.Hint := 'Periodo principal de análisis de ventas. Ejemplo: 60 días.';
  seDiasVentas.ShowHint := True;

  lblDiasTendencia := TLabel.Create(Self);
  lblDiasTendencia.Parent := PanelTop;
  lblDiasTendencia.Left := 455;
  lblDiasTendencia.Top := 44;
  lblDiasTendencia.Caption := 'Tendencia días:';
  lblDiasTendencia.Hint := 'Periodo corto para detectar si el artículo está vendiendo más últimamente.';
  lblDiasTendencia.ShowHint := True;

  seDiasTendencia := TSpinEdit.Create(Self);
  seDiasTendencia.Parent := PanelTop;
  seDiasTendencia.Left := 560;
  seDiasTendencia.Top := 40;
  seDiasTendencia.Width := 60;
  seDiasTendencia.MinValue := 1;
  seDiasTendencia.MaxValue := 120;
  seDiasTendencia.Value := DayOf(Date);
  if seDiasTendencia.Value < 7 then
    seDiasTendencia.Value := 7;
  seDiasTendencia.Hint := 'Por defecto usa aproximadamente los días transcurridos del mes, mínimo 7.';
  seDiasTendencia.ShowHint := True;

  chkUsarTendencia := TCheckBox.Create(Self);
  chkUsarTendencia.Parent := PanelTop;
  chkUsarTendencia.Left := 630;
  chkUsarTendencia.Top := 42;
  chkUsarTendencia.Width := 150;
  chkUsarTendencia.Caption := 'Usar tendencia';
  chkUsarTendencia.Hint := 'Si la venta corta es mayor que la media, refuerza el cálculo para no quedarse corto.';
  chkUsarTendencia.ShowHint := True;
  chkUsarTendencia.Checked := True;

  lblDiasHistorico := TLabel.Create(Self);
  lblDiasHistorico.Parent := PanelTop;
  lblDiasHistorico.Left := 780;
  lblDiasHistorico.Top := 44;
  lblDiasHistorico.Caption := 'Histórico anterior:';

  seDiasHistorico := TSpinEdit.Create(Self);
  seDiasHistorico.Parent := PanelTop;
  seDiasHistorico.Left := 900;
  seDiasHistorico.Top := 40;
  seDiasHistorico.Width := 60;
  seDiasHistorico.MinValue := 1;
  seDiasHistorico.MaxValue := 1460;
  seDiasHistorico.Value := 180;

  lblFactor := TLabel.Create(Self);
  lblFactor.Parent := PanelTop;
  lblFactor.Left := 970;
  lblFactor.Top := 44;
  lblFactor.Caption := 'Factor:';

  edtFactor := TEdit.Create(Self);
  edtFactor.Parent := PanelTop;
  edtFactor.Left := 1020;
  edtFactor.Top := 40;
  edtFactor.Width := 55;
  edtFactor.Text := '1,00';

  lblMaxLineas := TLabel.Create(Self);
  lblMaxLineas.Parent := PanelTop;
  lblMaxLineas.Left := 1090;
  lblMaxLineas.Top := 44;
  lblMaxLineas.Caption := 'Máx:';

  seMaxLineas := TSpinEdit.Create(Self);
  seMaxLineas.Parent := PanelTop;
  seMaxLineas.Left := 1130;
  seMaxLineas.Top := 40;
  seMaxLineas.Width := 65;
  seMaxLineas.MinValue := 10;
  seMaxLineas.MaxValue := 500;
  seMaxLineas.Value := 180;

  chkMostrarCero := TCheckBox.Create(Self);
  chkMostrarCero.Parent := PanelTop;
  chkMostrarCero.Left := 1210;
  chkMostrarCero.Top := 42;
  chkMostrarCero.Width := 210;
  chkMostrarCero.Caption := 'Mostrar sugerencia 0';
  chkMostrarCero.Checked := False;

  chkAbrirPDF := TCheckBox.Create(Self);
  chkAbrirPDF.Parent := PanelTop;
  chkAbrirPDF.Left := 1410;
  chkAbrirPDF.Top := 42;
  chkAbrirPDF.Width := 170;
  chkAbrirPDF.Caption := 'Abrir PDF al generar';
  chkAbrirPDF.Checked := True;

  lblMinSugerido := TLabel.Create(Self);
  lblMinSugerido.Parent := PanelTop;
  lblMinSugerido.Left := 10;
  lblMinSugerido.Top := 82;
  lblMinSugerido.Caption := 'Mín. sugerido:';

  seMinSugerido := TSpinEdit.Create(Self);
  seMinSugerido.Parent := PanelTop;
  seMinSugerido.Left := 105;
  seMinSugerido.Top := 78;
  seMinSugerido.Width := 60;
  seMinSugerido.MinValue := 1;
  seMinSugerido.MaxValue := 9999;
  seMinSugerido.Value := 1;

  lblMinVentas := TLabel.Create(Self);
  lblMinVentas.Parent := PanelTop;
  lblMinVentas.Left := 185;
  lblMinVentas.Top := 82;
  lblMinVentas.Caption := 'Mín. venta reciente:';

  seMinVentas := TSpinEdit.Create(Self);
  seMinVentas.Parent := PanelTop;
  seMinVentas.Left := 320;
  seMinVentas.Top := 78;
  seMinVentas.Width := 60;
  seMinVentas.MinValue := 1;
  seMinVentas.MaxValue := 9999;
  seMinVentas.Value := 1;

  lblMinHistorico := TLabel.Create(Self);
  lblMinHistorico.Parent := PanelTop;
  lblMinHistorico.Left := 400;
  lblMinHistorico.Top := 82;
  lblMinHistorico.Caption := 'Mín. hist. rotura:';

  seMinHistorico := TSpinEdit.Create(Self);
  seMinHistorico.Parent := PanelTop;
  seMinHistorico.Left := 525;
  seMinHistorico.Top := 78;
  seMinHistorico.Width := 60;
  seMinHistorico.MinValue := 1;
  seMinHistorico.MaxValue := 9999;
  seMinHistorico.Value := 3;

  chkIncluirRoturas := TCheckBox.Create(Self);
  chkIncluirRoturas.Parent := PanelTop;
  chkIncluirRoturas.Left := 605;
  chkIncluirRoturas.Top := 80;
  chkIncluirRoturas.Width := 180;
  chkIncluirRoturas.Caption := 'Incluir roturas stock';
  chkIncluirRoturas.Checked := True;

  chkExcluirRaros := TCheckBox.Create(Self);
  chkExcluirRaros.Parent := PanelTop;
  chkExcluirRaros.Left := 785;
  chkExcluirRaros.Top := 80;
  chkExcluirRaros.Width := 210;
  chkExcluirRaros.Caption := 'Excluir coste 0 / PVP 999';
  chkExcluirRaros.Checked := False;

  btnCalcular := TButton.Create(Self);
  btnCalcular.Parent := PanelTop;
  btnCalcular.Left := 10;
  btnCalcular.Top := 112;
  btnCalcular.Width := 130;
  btnCalcular.Caption := 'Calcular todo';
  btnCalcular.OnClick := @BtnCalcularClick;

  btnPedidoDepurado := TButton.Create(Self);
  btnPedidoDepurado.Parent := PanelTop;
  btnPedidoDepurado.Left := 150;
  btnPedidoDepurado.Top := 112;
  btnPedidoDepurado.Width := 145;
  btnPedidoDepurado.Caption := 'Pedido depurado';
  btnPedidoDepurado.OnClick := @BtnPedidoDepuradoClick;

  btnExportar := TButton.Create(Self);
  btnExportar.Parent := PanelTop;
  btnExportar.Left := 305;
  btnExportar.Top := 112;
  btnExportar.Width := 100;
  btnExportar.Caption := 'Exportar CSV';
  btnExportar.OnClick := @BtnExportarClick;

  btnPDF := TButton.Create(Self);
  btnPDF.Parent := PanelTop;
  btnPDF.Left := 415;
  btnPDF.Top := 112;
  btnPDF.Width := 105;
  btnPDF.Caption := 'Generar PDF';
  btnPDF.OnClick := @BtnPDFClick;

  btnImprimir := TButton.Create(Self);
  btnImprimir.Parent := PanelTop;
  btnImprimir.Left := 530;
  btnImprimir.Top := 112;
  btnImprimir.Width := 90;
  btnImprimir.Caption := 'Imprimir';
  btnImprimir.OnClick := @BtnImprimirClick;

  btnOrdenTienda := TButton.Create(Self);
  btnOrdenTienda.Parent := PanelTop;
  btnOrdenTienda.Left := 630;
  btnOrdenTienda.Top := 112;
  btnOrdenTienda.Width := 110;
  btnOrdenTienda.Caption := 'Orden tienda';
  btnOrdenTienda.Hint := 'Ordena por familia y descripción para revisar lineal por lineal';
  btnOrdenTienda.ShowHint := True;
  btnOrdenTienda.OnClick := @BtnOrdenTiendaClick;

  btnRecalcularFinal := TButton.Create(Self);
  btnRecalcularFinal.Parent := PanelTop;
  btnRecalcularFinal.Left := 750;
  btnRecalcularFinal.Top := 112;
  btnRecalcularFinal.Width := 125;
  btnRecalcularFinal.Caption := 'Recalcular final';
  btnRecalcularFinal.Hint := 'Recalcula Cantidad final = Sugerido - Stock contado en todas las líneas';
  btnRecalcularFinal.ShowHint := True;
  btnRecalcularFinal.OnClick := @BtnRecalcularFinalClick;

  btnCerrar := TButton.Create(Self);
  btnCerrar.Parent := PanelTop;
  btnCerrar.Left := 885;
  btnCerrar.Top := 112;
  btnCerrar.Width := 90;
  btnCerrar.Caption := 'Cerrar';
  btnCerrar.OnClick := @BtnCerrarClick;

  lblEstado := TLabel.Create(Self);
  lblEstado.Parent := PanelTop;
  lblEstado.Left := 995;
  lblEstado.Top := 118;
  lblEstado.Width := 700;
  lblEstado.Caption := 'Días pedido = cobertura. Stock contado y cantidad final son editables. Pulse cabeceras para ordenar.';

  PanelBottom := TPanel.Create(Self);
  PanelBottom.Parent := Self;
  PanelBottom.Align := alClient;
  PanelBottom.BevelOuter := bvNone;

  Grid := TStringGrid.Create(Self);
  Grid.Parent := PanelBottom;
  Grid.Align := alClient;
  Grid.FixedRows := 1;
  Grid.Options := Grid.Options + [goColSizing, goThumbTracking];
  Grid.OnHeaderClick := @GridHeaderClick;
  Grid.OnEditingDone := @GridEditingDone;
  Grid.OnSelectCell := @GridSelectCell;
end;

procedure TfPedidoProveedorAuto.InicializarGrid;
begin
  FSortCol := -1;
  FSortAsc := True;
  Grid.ColCount := 18;
  Grid.RowCount := 2;

  Grid.Cells[0, 0] := 'Código';
  Grid.Cells[1, 0] := 'Descripción';
  Grid.Cells[2, 0] := 'Vendido periodo';
  Grid.Cells[3, 0] := 'Vend. tendencia';
  Grid.Cells[4, 0] := 'Vendido histórico';
  Grid.Cells[5, 0] := 'Venta/día usada';
  Grid.Cells[6, 0] := 'Sugerido';
  Grid.Cells[7, 0] := 'Stock contado';
  Grid.Cells[8, 0] := 'Cantidad final';
  Grid.Cells[9, 0] := 'Últ. venta';
  Grid.Cells[10, 0] := 'Últ. compra';
  Grid.Cells[11, 0] := 'Coste';
  Grid.Cells[12, 0] := 'PVP';
  Grid.Cells[13, 0] := 'IVA';
  Grid.Cells[14, 0] := 'Stock info';
  Grid.Cells[15, 0] := 'Familia';
  Grid.Cells[16, 0] := 'Estado';
  Grid.Cells[17, 0] := 'Observaciones';

  Grid.Rows[1].Clear;
  AutoAjustarColumnas;
end;

procedure TfPedidoProveedorAuto.CargarProveedores;
var
  Q: TZQuery;
begin
  cbProveedor.Items.Clear;
  FListaProveedores.Clear;

  if (FConn = nil) or (not FConn.Connected) then
  begin
    ShowMessage('La conexión a la base de datos no está activa.');
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT P0, P1 FROM proveedores ORDER BY P1';
    Q.Open;
    while not Q.EOF do
    begin
      FListaProveedores.Add(Q.FieldByName('P0').AsString + ' - ' +
        Q.FieldByName('P1').AsString);
      Q.Next;
    end;
  finally
    Q.Free;
  end;

  FiltrarProveedores('');
end;

procedure TfPedidoProveedorAuto.FiltrarProveedores(const Texto: string);
var
  I: Integer;
  CodActual: Integer;
  NuevoIndex: Integer;
  Item: string;
  P: Integer;
  CodItem: Integer;
begin
  CodActual := CodigoProveedorSeleccionado;
  NuevoIndex := -1;

  cbProveedor.Items.BeginUpdate;
  try
    cbProveedor.Items.Clear;
    for I := 0 to FListaProveedores.Count - 1 do
    begin
      Item := FListaProveedores[I];
      if (Trim(Texto) = '') or TextoContiene(Item, Texto) then
      begin
        cbProveedor.Items.Add(Item);
        P := Pos(' - ', Item);
        if P > 0 then
          CodItem := StrToIntDef(Copy(Item, 1, P - 1), 0)
        else
          CodItem := 0;
        if (CodActual > 0) and (CodItem = CodActual) then
          NuevoIndex := cbProveedor.Items.Count - 1;
      end;
    end;
  finally
    cbProveedor.Items.EndUpdate;
  end;

  if cbProveedor.Items.Count > 0 then
  begin
    if NuevoIndex >= 0 then
      cbProveedor.ItemIndex := NuevoIndex
    else
      cbProveedor.ItemIndex := 0;
  end
  else
    cbProveedor.ItemIndex := -1;

  if Trim(Texto) <> '' then
    lblEstado.Caption := 'Filtro proveedor: ' + IntToStr(cbProveedor.Items.Count) +
      ' coincidencia(s).'
  else
    lblEstado.Caption := 'Proveedores cargados: ' + IntToStr(cbProveedor.Items.Count) +
      '. Pulse cabeceras para ordenar la propuesta visible.';
end;

procedure TfPedidoProveedorAuto.EdtBuscarProveedorChange(Sender: TObject);
begin
  FiltrarProveedores(edtBuscarProveedor.Text);
end;

procedure TfPedidoProveedorAuto.BtnLimpiarProveedorClick(Sender: TObject);
begin
  edtBuscarProveedor.Text := '';
  FiltrarProveedores('');
  if edtBuscarProveedor.CanFocus then
    edtBuscarProveedor.SetFocus;
end;

procedure TfPedidoProveedorAuto.GridHeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer);
begin
  if (not IsColumn) or (Index < 0) or (Index >= Grid.ColCount) then
    Exit;

  if not HayDatosEnGrid then
    Exit;

  if FSortCol = Index then
    FSortAsc := not FSortAsc
  else
  begin
    FSortCol := Index;
    // Por defecto, textos ascendente y números descendente, que suele ser más útil para unidades/importes.
    FSortAsc := not EsColumnaNumerica(Index);
  end;

  OrdenarGridPorColumna(FSortCol, FSortAsc);
  ActualizarCabecerasOrden;

  if FSortAsc then
    lblEstado.Caption := 'Ordenado por ' + Grid.Cells[FSortCol, 0] + ' ascendente.'
  else
    lblEstado.Caption := 'Ordenado por ' + Grid.Cells[FSortCol, 0] + ' descendente.';
end;

procedure TfPedidoProveedorAuto.OrdenarGridPorColumna(const Col: Integer; const Ascendente: Boolean);
var
  I: Integer;
  J: Integer;
  Cmp: Integer;
  Tmp: TStringList;
begin
  if (Grid.RowCount <= 2) or (Col < 0) or (Col >= Grid.ColCount) then
    Exit;

  Tmp := TStringList.Create;
  try
    for I := 1 to Grid.RowCount - 2 do
      for J := I + 1 to Grid.RowCount - 1 do
      begin
        Cmp := CompararCeldas(Grid.Cells[Col, I], Grid.Cells[Col, J], Col);
        if (Ascendente and (Cmp > 0)) or ((not Ascendente) and (Cmp < 0)) then
        begin
          Tmp.Assign(Grid.Rows[I]);
          Grid.Rows[I].Assign(Grid.Rows[J]);
          Grid.Rows[J].Assign(Tmp);
        end;
      end;
  finally
    Tmp.Free;
  end;
end;

procedure TfPedidoProveedorAuto.ActualizarCabecerasOrden;
const
  Headers: array[0..17] of string = (
    'Código', 'Descripción', 'Vendido periodo', 'Vend. tendencia',
    'Vendido histórico', 'Venta/día usada', 'Sugerido', 'Stock contado',
    'Cantidad final', 'Últ. venta', 'Últ. compra', 'Coste', 'PVP', 'IVA',
    'Stock info', 'Familia', 'Estado', 'Observaciones');
var
  I: Integer;
begin
  for I := 0 to Grid.ColCount - 1 do
  begin
    if I <= High(Headers) then
      Grid.Cells[I, 0] := Headers[I];
  end;

  if (FSortCol >= 0) and (FSortCol < Grid.ColCount) then
  begin
    if FSortAsc then
      Grid.Cells[FSortCol, 0] := Grid.Cells[FSortCol, 0] + ' ^'
    else
      Grid.Cells[FSortCol, 0] := Grid.Cells[FSortCol, 0] + ' v';
  end;
end;

function TfPedidoProveedorAuto.CodigoProveedorSeleccionado: Integer;
var
  S: string;
  P: Integer;
begin
  Result := 0;
  if cbProveedor.ItemIndex < 0 then Exit;

  S := cbProveedor.Text;
  P := Pos(' - ', S);
  if P > 0 then
    S := Copy(S, 1, P - 1);

  Result := StrToIntDef(Trim(S), 0);
end;

function TfPedidoProveedorAuto.NombreProveedorSeleccionado: string;
var
  S: string;
  P: Integer;
begin
  Result := '';
  if cbProveedor.ItemIndex < 0 then Exit;

  S := cbProveedor.Text;
  P := Pos(' - ', S);
  if P > 0 then
    Result := Copy(S, P + 3, Length(S))
  else
    Result := S;
end;

function TfPedidoProveedorAuto.SufijoTiendaSeguro(const S: string): string;
var
  I: Integer;
  C: Char;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    C := S[I];
    if C in ['0'..'9', 'A'..'Z', 'a'..'z', '_'] then
      Result := Result + C;
  end;
end;

function TfPedidoProveedorAuto.TablaExiste(const NombreTabla: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) AS C FROM information_schema.TABLES ' +
      'WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = :T';
    Q.ParamByName('T').AsString := NombreTabla;
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TfPedidoProveedorAuto.SQLComprasProveedor(const CodProveedor: Integer): string;
var
  TPedid: string;
  THiPedid: string;
  THiPedifa: string;
  L: TStringList;
begin
  Result := '';
  TPedid := 'pedidd' + FTienda;
  THiPedid := 'hipedidd' + FTienda;
  THiPedifa := 'hipedifadd' + FTienda;

  L := TStringList.Create;
  try
    if TablaExiste(TPedid) then
      L.Add('SELECT PD6 AS CODIGO, MAX(PD1) AS ULT_COMPRA, MAX(PD10) AS ULT_COSTE ' +
        'FROM `' + TPedid + '` WHERE PD2 = ' + IntToStr(CodProveedor) +
        ' AND TRIM(PD6) <> '''' GROUP BY PD6');

    if TablaExiste(THiPedid) then
      L.Add('SELECT HPD6 AS CODIGO, MAX(HPD1) AS ULT_COMPRA, MAX(HPD10) AS ULT_COSTE ' +
        'FROM `' + THiPedid + '` WHERE HPD2 = ' + IntToStr(CodProveedor) +
        ' AND TRIM(HPD6) <> '''' GROUP BY HPD6');

    if TablaExiste(THiPedifa) then
      L.Add('SELECT HPD6 AS CODIGO, MAX(HPD1) AS ULT_COMPRA, MAX(HPD10) AS ULT_COSTE ' +
        'FROM `' + THiPedifa + '` WHERE HPD2 = ' + IntToStr(CodProveedor) +
        ' AND TRIM(HPD6) <> '''' GROUP BY HPD6');

    if L.Count = 0 then Exit;

    Result := 'SELECT CODIGO, MAX(ULT_COMPRA) AS ULT_COMPRA, MAX(ULT_COSTE) AS ULT_COSTE ' +
      'FROM (' + StringReplace(Trim(L.Text), LineEnding, ' UNION ALL ', [rfReplaceAll]) +
      ') CP GROUP BY CODIGO';
  finally
    L.Free;
  end;
end;

function TfPedidoProveedorAuto.SQLVentas(const FechaDesdeHistorico,
  FechaHasta: TDateTime): string;
var
  THis: string;
begin
  Result := '';
  THis := 'hisopdd' + FTienda;

  if not TablaExiste(THis) then Exit;

  Result :=
    'SELECT CODIGO, ' +
    'SUM(CASE WHEN FECHA >= ' + FechaSQL(IncDay(FechaHasta, -seDiasVentas.Value + 1)) +
    ' THEN UDS ELSE 0 END) AS VENTAS_PERIODO, ' +
    'SUM(CASE WHEN FECHA >= ' + FechaSQL(IncDay(FechaHasta, -seDiasTendencia.Value + 1)) +
    ' THEN UDS ELSE 0 END) AS VENTAS_TENDENCIA, ' +
    'SUM(CASE WHEN FECHA < ' + FechaSQL(IncDay(FechaHasta, -seDiasVentas.Value + 1)) +
    ' THEN UDS ELSE 0 END) AS VENTAS_HISTORICO, ' +
    'MAX(FECHA) AS ULT_VENTA ' +
    'FROM (SELECT HOD6 AS CODIGO, HOD0 AS FECHA, ' +
    'CASE WHEN HOD8 > 0 THEN HOD8 ELSE 0 END AS UDS ' +
    'FROM `' + THis + '` WHERE HOD0 BETWEEN ' + FechaSQL(FechaDesdeHistorico) +
    ' AND ' + FechaSQL(FechaHasta) + ' AND TRIM(HOD6) <> '''') V ' +
    'GROUP BY CODIGO';
end;

function TfPedidoProveedorAuto.SQLFinal(const CodProveedor: Integer;
  const FechaDesdeHistorico, FechaHasta: TDateTime): string;
var
  ComprasSQL: string;
  VentasSQL: string;
  TArti: string;
begin
  Result := '';
  TArti := 'artitien' + FTienda;

  if not TablaExiste(TArti) then
  begin
    ShowMessage('No existe la tabla de artículos: ' + TArti);
    Exit;
  end;

  ComprasSQL := SQLComprasProveedor(CodProveedor);
  if ComprasSQL = '' then
  begin
    ShowMessage('No encuentro tablas de pedidos/histórico de compras para la tienda ' + FTienda + '.');
    Exit;
  end;

  VentasSQL := SQLVentas(FechaDesdeHistorico, FechaHasta);

  Result :=
    'SELECT A.A0 AS CODIGO, A.A1 AS DESCRIPCION, A.A2 AS PVP, A.A3 AS IVA, ' +
    'A.A4 AS STOCK_INFO, A.A13 AS ULT_COMPRA_FICHA, A.A14 AS FAMILIA, ' +
    'A.A24 AS COSTE_FICHA, CP.ULT_COMPRA, CP.ULT_COSTE, ';

  if VentasSQL <> '' then
    Result := Result +
      'COALESCE(V.VENTAS_PERIODO, 0) AS VENTAS_PERIODO, ' +
      'COALESCE(V.VENTAS_TENDENCIA, 0) AS VENTAS_TENDENCIA, ' +
      'COALESCE(V.VENTAS_HISTORICO, 0) AS VENTAS_HISTORICO, V.ULT_VENTA '
  else
    Result := Result +
      '0 AS VENTAS_PERIODO, 0 AS VENTAS_TENDENCIA, 0 AS VENTAS_HISTORICO, NULL AS ULT_VENTA ';

  Result := Result +
    'FROM (' + ComprasSQL + ') CP ' +
    'JOIN `' + TArti + '` A ON A.A0 = CP.CODIGO ';

  if VentasSQL <> '' then
    Result := Result + 'LEFT JOIN (' + VentasSQL + ') V ON V.CODIGO = A.A0 ';

  Result := Result + 'ORDER BY A.A1';
end;

procedure TfPedidoProveedorAuto.BtnCalcularClick(Sender: TObject);
begin
  CalcularPropuesta(False);
end;

procedure TfPedidoProveedorAuto.BtnPedidoDepuradoClick(Sender: TObject);
begin
  CalcularPropuesta(True);
end;

procedure TfPedidoProveedorAuto.OrdenarPorPrioridad(var Lineas: TArrayLineaPedidoAuto);
var
  I: Integer;
  J: Integer;
  Tmp: TLineaPedidoAuto;
begin
  // Ordenación sencilla descendente. Para 1500-3000 líneas es suficiente
  // y evita depender de genéricos/colecciones que puedan variar entre Lazarus/FPC.
  for I := Low(Lineas) to High(Lineas) - 1 do
    for J := I + 1 to High(Lineas) do
      if Lineas[J].Prioridad > Lineas[I].Prioridad then
      begin
        Tmp := Lineas[I];
        Lineas[I] := Lineas[J];
        Lineas[J] := Tmp;
      end;
end;

procedure TfPedidoProveedorAuto.PintarLineasEnGrid(const Lineas: TArrayLineaPedidoAuto;
  const Limite: Integer);
var
  I: Integer;
  R: Integer;
  MaxI: Integer;
begin
  InicializarGrid;

  if Length(Lineas) = 0 then
  begin
    Grid.Rows[1].Clear;
    Exit;
  end;

  MaxI := High(Lineas);
  if (Limite > 0) and (Limite - 1 < MaxI) then
    MaxI := Limite - 1;

  R := 1;
  for I := 0 to MaxI do
  begin
    if R >= Grid.RowCount then
      Grid.RowCount := Grid.RowCount + 1;

    Grid.Cells[0, R] := Lineas[I].Codigo;
    Grid.Cells[1, R] := Lineas[I].Descripcion;
    Grid.Cells[2, R] := FormatFloat('0.##', Lineas[I].VendidoPeriodo);
    Grid.Cells[3, R] := FormatFloat('0.##', Lineas[I].VendidoTendencia);
    Grid.Cells[4, R] := FormatFloat('0.##', Lineas[I].VendidoHistorico);
    Grid.Cells[5, R] := FormatFloat('0.####', Lineas[I].VentaDia);
    Grid.Cells[6, R] := FormatFloat('0.##', Lineas[I].Sugerido);
    Grid.Cells[7, R] := ''; // Stock contado manual en tienda
    Grid.Cells[8, R] := FormatFloat('0.##', Lineas[I].Sugerido); // Cantidad final inicial
    Grid.Cells[9, R] := Lineas[I].UltVenta;
    Grid.Cells[10, R] := Lineas[I].UltCompra;
    Grid.Cells[11, R] := FormatFloat('0.000', Lineas[I].Coste);
    Grid.Cells[12, R] := FormatFloat('0.00', Lineas[I].PVP);
    Grid.Cells[13, R] := FormatFloat('0.##', Lineas[I].IVA);
    Grid.Cells[14, R] := FormatFloat('0.##', Lineas[I].StockInfo);
    Grid.Cells[15, R] := Lineas[I].Familia;
    Grid.Cells[16, R] := Lineas[I].Estado;
    Grid.Cells[17, R] := Lineas[I].Observaciones;
    Inc(R);
  end;

  AutoAjustarColumnas;
end;

procedure TfPedidoProveedorAuto.CalcularPropuesta(const Depurada: Boolean);
var
  Q: TZQuery;
  SQL: string;
  CodProv: Integer;
  FechaHasta: TDateTime;
  FechaDesdeVentas: TDateTime;
  FechaDesdeHistorico: TDateTime;
  Factor: Double;
  VentasPeriodo: Double;
  VentasTendencia: Double;
  VentasHistorico: Double;
  VentaDia: Double;
  VentaDiaPeriodo: Double;
  VentaDiaTendencia: Double;
  Sugerido: Double;
  Estado: string;
  Obs: string;
  UltCompra: string;
  UltVenta: string;
  Coste: Double;
  StockInfo: Double;
  PVP: Double;
  Lineas: TArrayLineaPedidoAuto;
  L: TLineaPedidoAuto;
  TotalCandidatas: Integer;
  TotalLeidas: Integer;
  MaxLineas: Integer;
  Mostradas: Integer;
  Incluir: Boolean;
  MinSugerido: Double;
  MinVentas: Double;
  MinHistorico: Double;
  ExcluirRaros: Boolean;

  procedure AddLinea(const ALinea: TLineaPedidoAuto);
  var
    N: Integer;
  begin
    N := Length(Lineas);
    SetLength(Lineas, N + 1);
    Lineas[N] := ALinea;
  end;

begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then
  begin
    ShowMessage('Seleccione un proveedor.');
    Exit;
  end;

  Factor := FloatSeguro(edtFactor.Text, 1.0);
  if Factor <= 0 then Factor := 1.0;

  MaxLineas := seMaxLineas.Value;
  if MaxLineas < 10 then MaxLineas := 10;

  MinSugerido := seMinSugerido.Value;
  if MinSugerido < 1 then MinSugerido := 1;

  MinVentas := seMinVentas.Value;
  if MinVentas < 1 then MinVentas := 1;

  MinHistorico := seMinHistorico.Value;
  if MinHistorico < 1 then MinHistorico := 1;

  ExcluirRaros := chkExcluirRaros.Checked;

  FechaHasta := Date;
  FechaDesdeVentas := IncDay(FechaHasta, -seDiasVentas.Value + 1);
  FechaDesdeHistorico := IncDay(FechaDesdeVentas, -seDiasHistorico.Value);

  SQL := SQLFinal(CodProv, FechaDesdeHistorico, FechaHasta);
  if SQL = '' then Exit;

  InicializarGrid;
  if Depurada then
    lblEstado.Caption := 'Calculando pedido depurado para ' + NombreProveedorSeleccionado + '...'
  else
    lblEstado.Caption := 'Calculando propuesta completa para ' + NombreProveedorSeleccionado + '...';
  Application.ProcessMessages;

  SetLength(Lineas, 0);
  TotalCandidatas := 0;
  TotalLeidas := 0;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := SQL;
    Q.Open;

    while not Q.EOF do
    begin
      Inc(TotalLeidas);
      VentasPeriodo := Q.FieldByName('VENTAS_PERIODO').AsFloat;
      VentasTendencia := Q.FieldByName('VENTAS_TENDENCIA').AsFloat;
      VentasHistorico := Q.FieldByName('VENTAS_HISTORICO').AsFloat;

      VentaDiaPeriodo := 0;
      VentaDiaTendencia := 0;

      if seDiasVentas.Value > 0 then
        VentaDiaPeriodo := VentasPeriodo / seDiasVentas.Value;
      if seDiasTendencia.Value > 0 then
        VentaDiaTendencia := VentasTendencia / seDiasTendencia.Value;

      if VentasPeriodo > 0 then
      begin
        VentaDia := VentaDiaPeriodo;

        // Si la tendencia corta es más alta que la media principal, usamos una mezcla prudente
        // 65% periodo principal + 35% tendencia corta, pero nunca bajamos por debajo de la media principal.
        if chkUsarTendencia.Checked and (VentasTendencia > 0) and
          (VentaDiaTendencia > VentaDiaPeriodo) then
        begin
          VentaDia := Max(VentaDiaPeriodo, (VentaDiaPeriodo * 0.65) + (VentaDiaTendencia * 0.35));
          Estado := 'VENTA RECIENTE + TENDENCIA';
          Obs := 'Media periodo ' + FormatFloat('0.####', VentaDiaPeriodo) +
            '/día; tendencia ' + FormatFloat('0.####', VentaDiaTendencia) +
            '/día. Se refuerza cálculo por aceleración reciente.';
        end
        else
        begin
          Estado := 'VENTA RECIENTE';
          Obs := 'Media periodo ' + FormatFloat('0.####', VentaDiaPeriodo) +
            '/día. Tendencia ' + FormatFloat('0.####', VentaDiaTendencia) + '/día.';
        end;
      end
      else if VentasHistorico > 0 then
      begin
        VentaDia := VentasHistorico / seDiasHistorico.Value;
        Estado := 'POSIBLE ROTURA STOCK';
        Obs := 'Sin venta reciente, pero con histórico. Revisar posible falta de existencias.';
      end
      else
      begin
        VentaDia := 0;
        Estado := 'SIN VENTA';
        Obs := 'Comprado al proveedor, sin ventas en los periodos analizados.';
      end;

      Sugerido := RedondearArriba(VentaDia * seDiasCubrir.Value * Factor);
      Obs := Obs + ' Fórmula: ' + FormatFloat('0.####', VentaDia) +
        '/día x ' + IntToStr(seDiasCubrir.Value) + ' días x factor ' +
        FormatFloat('0.##', Factor) + ' = ' + FormatFloat('0.##', Sugerido) + '.';

      Coste := Q.FieldByName('ULT_COSTE').AsFloat;
      if Coste <= 0 then
        Coste := Q.FieldByName('COSTE_FICHA').AsFloat;

      StockInfo := Q.FieldByName('STOCK_INFO').AsFloat;
      PVP := Q.FieldByName('PVP').AsFloat;

      UltCompra := '';
      if not Q.FieldByName('ULT_COMPRA').IsNull then
        UltCompra := DateToStr(Q.FieldByName('ULT_COMPRA').AsDateTime)
      else if not Q.FieldByName('ULT_COMPRA_FICHA').IsNull then
        UltCompra := DateToStr(Q.FieldByName('ULT_COMPRA_FICHA').AsDateTime);

      UltVenta := '';
      if not Q.FieldByName('ULT_VENTA').IsNull then
        UltVenta := DateToStr(Q.FieldByName('ULT_VENTA').AsDateTime);

      // Modo completo: igual que la versión anterior.
      Incluir := (Sugerido > 0) or chkMostrarCero.Checked;

      if Depurada then
      begin
        // Modo pedido depurado:
        // - Nunca mete artículos sin venta útil.
        // - Da prioridad absoluta a venta reciente.
        // - Permite roturas de stock, pero solo si tienen algo de histórico real.
        // - Limita después por prioridad a MaxLineas.
        Incluir := False;

        if Sugerido >= MinSugerido then
        begin
          if VentasPeriodo >= MinVentas then
            Incluir := True
          else if chkIncluirRoturas.Checked and (VentasHistorico >= MinHistorico) and (VentaDia > 0) then
            Incluir := True;
        end;

        if ExcluirRaros and ((Coste <= 0) or (Abs(PVP - 999) < 0.001)) then
          Incluir := False;
      end;

      if Incluir then
      begin
        Inc(TotalCandidatas);

        L.Codigo := Q.FieldByName('CODIGO').AsString;
        L.Descripcion := Q.FieldByName('DESCRIPCION').AsString;
        L.VendidoPeriodo := VentasPeriodo;
        L.VendidoTendencia := VentasTendencia;
        L.VendidoHistorico := VentasHistorico;
        L.VentaDia := VentaDia;
        L.Sugerido := Sugerido;
        L.UltVenta := UltVenta;
        L.UltCompra := UltCompra;
        L.Coste := Coste;
        L.PVP := PVP;
        L.IVA := Q.FieldByName('IVA').AsFloat;
        L.StockInfo := StockInfo;
        L.Familia := Q.FieldByName('FAMILIA').AsString;
        L.Estado := Estado;
        L.Observaciones := Obs;

        if Depurada then
        begin
          if VentasPeriodo > 0 then
          begin
            L.Prioridad := 1000000 + (VentasPeriodo * 1000) + (Sugerido * 100);
            L.Observaciones := L.Observaciones + ' Prioridad alta por venta reciente.';
          end
          else
          begin
            L.Prioridad := 500000 + (VentasHistorico * 100) + (Sugerido * 50);
            L.Observaciones := L.Observaciones + ' Incluido como posible rotura de stock.';
          end;

          if Coste <= 0 then
          begin
            L.Prioridad := L.Prioridad - 25000;
            L.Observaciones := L.Observaciones + ' Revisar coste 0.';
          end;

          if Abs(PVP - 999) < 0.001 then
          begin
            L.Prioridad := L.Prioridad - 25000;
            L.Observaciones := L.Observaciones + ' Revisar PVP 999.';
          end;
        end
        else
          L.Prioridad := TotalCandidatas;

        AddLinea(L);
      end;

      Q.Next;
    end;
  finally
    Q.Free;
  end;

  if Depurada then
  begin
    OrdenarPorPrioridad(Lineas);
    PintarLineasEnGrid(Lineas, MaxLineas);
    Mostradas := Length(Lineas);
    if Mostradas > MaxLineas then
      Mostradas := MaxLineas;
    lblEstado.Caption := 'Pedido depurado: mostradas ' + IntToStr(Mostradas) +
      ' de ' + IntToStr(TotalCandidatas) + ' candidatas. Leídas: ' +
      IntToStr(TotalLeidas) + '. Máx. líneas: ' + IntToStr(MaxLineas) +
      '. Filtros: mín sug ' + FormatFloat('0.##', MinSugerido) +
      ', mín venta ' + FormatFloat('0.##', MinVentas) +
      ', mín hist ' + FormatFloat('0.##', MinHistorico) +
      '. Ventas analizadas: ' + DateToStr(FechaDesdeVentas) + ' a ' + DateToStr(FechaHasta) +
      '. Pedido cubre ' + IntToStr(seDiasCubrir.Value) + ' días.';
  end
  else
  begin
    PintarLineasEnGrid(Lineas, 0);
    Mostradas := Length(Lineas);
    lblEstado.Caption := 'Propuesta completa calculada. Líneas mostradas: ' +
      IntToStr(Mostradas) + '. Ventas analizadas: ' +
      DateToStr(FechaDesdeVentas) + ' a ' + DateToStr(FechaHasta) +
      '. Pedido cubre ' + IntToStr(seDiasCubrir.Value) + ' días.';
  end;
end;

procedure TfPedidoProveedorAuto.BtnExportarClick(Sender: TObject);
var
  SD: TSaveDialog;
  SL: TStringList;
  R: Integer;
  C: Integer;
  Linea: string;
begin
  if not HayDatosEnGrid then
  begin
    ShowMessage('No hay datos para exportar.');
    Exit;
  end;

  SD := TSaveDialog.Create(nil);
  SL := TStringList.Create;
  try
    SD.Filter := 'CSV (*.csv)|*.csv|Todos los ficheros|*.*';
    SD.DefaultExt := 'csv';
    SD.FileName := 'propuesta_pedido_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.csv';

    if not SD.Execute then Exit;

    for R := 0 to Grid.RowCount - 1 do
    begin
      Linea := '';
      for C := 0 to Grid.ColCount - 1 do
      begin
        if C > 0 then Linea := Linea + ';';
        Linea := Linea + CSVSeguro(Grid.Cells[C, R]);
      end;
      SL.Add(Linea);
    end;

    SL.SaveToFile(SD.FileName);
    ShowMessage('CSV exportado correctamente:' + LineEnding + SD.FileName);
  finally
    SL.Free;
    SD.Free;
  end;
end;


procedure TfPedidoProveedorAuto.BtnPDFClick(Sender: TObject);
var
  SD: TSaveDialog;
  Metodo: string;
  ErrorDetalle: string;
begin
  if not HayDatosEnGrid then
  begin
    ShowMessage('No hay datos para generar PDF.');
    Exit;
  end;

  SD := TSaveDialog.Create(nil);
  try
    SD.Filter := 'PDF (*.pdf)|*.pdf|Todos los ficheros|*.*';
    SD.DefaultExt := 'pdf';
    SD.FileName := 'propuesta_pedido_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.pdf';

    if not SD.Execute then Exit;

    try
      GenerarPDFDesdeGrid(SD.FileName);

      if chkAbrirPDF.Checked then
      begin
        if AbrirPDFGenerado(SD.FileName, Metodo, ErrorDetalle) then
          lblEstado.Caption := 'PDF generado y abierto con ' + Metodo + ': ' + SD.FileName
        else
          ShowMessage('PDF generado correctamente, pero no se pudo abrir automáticamente.' + LineEnding +
            'Fichero: ' + SD.FileName + LineEnding + LineEnding +
            'Detalle: ' + ErrorDetalle + LineEnding + LineEnding +
            'Puede abrirlo manualmente con su visor PDF o instalar/asociar xdg-open.');
      end
      else
        ShowMessage('PDF generado correctamente:' + LineEnding + SD.FileName);
    except
      on E: Exception do
        ShowMessage('Error generando PDF:' + LineEnding + E.Message);
    end;
  finally
    SD.Free;
  end;
end;

procedure TfPedidoProveedorAuto.BtnImprimirClick(Sender: TObject);
begin
  if not HayDatosEnGrid then
  begin
    ShowMessage('No hay datos para imprimir.');
    Exit;
  end;

  if MessageDlg('Imprimir propuesta',
    'Se imprimirá la propuesta actual en formato horizontal.' + LineEnding +
    '¿Desea continuar?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  try
    ImprimirGrid;
    ShowMessage('Propuesta enviada a la impresora.');
  except
    on E: Exception do
      ShowMessage('Error imprimiendo propuesta:' + LineEnding + E.Message);
  end;
end;

procedure TfPedidoProveedorAuto.BtnOrdenTiendaClick(Sender: TObject);
var
  I: Integer;
  J: Integer;
  Cmp: Integer;
  Tmp: TStringList;
begin
  if not HayDatosEnGrid then Exit;

  Tmp := TStringList.Create;
  try
    for I := 1 to Grid.RowCount - 2 do
      for J := I + 1 to Grid.RowCount - 1 do
      begin
        Cmp := CompararCeldas(Grid.Cells[15, I], Grid.Cells[15, J], 15);
        if Cmp = 0 then
          Cmp := CompararCeldas(Grid.Cells[1, I], Grid.Cells[1, J], 1);

        if Cmp > 0 then
        begin
          Tmp.Assign(Grid.Rows[I]);
          Grid.Rows[I].Assign(Grid.Rows[J]);
          Grid.Rows[J].Assign(Tmp);
        end;
      end;
  finally
    Tmp.Free;
  end;

  FSortCol := -1;
  ActualizarCabecerasOrden;
  lblEstado.Caption := 'Ordenado para revisar tienda: familia + descripción. El PDF e impresión respetarán este orden.';
end;

procedure TfPedidoProveedorAuto.BtnRecalcularFinalClick(Sender: TObject);
begin
  if not HayDatosEnGrid then
  begin
    ShowMessage('No hay datos para recalcular.');
    Exit;
  end;

  RecalcularTodasCantidadesFinales;
  lblEstado.Caption := 'Cantidades finales recalculadas: Cantidad final = Sugerido - Stock contado.';
end;

procedure TfPedidoProveedorAuto.GridEditingDone(Sender: TObject);
begin
  if (Grid.Row > 0) and (Grid.Col in [7, 8]) then
  begin
    if Grid.Col = 7 then
      RecalcularCantidadFinalFila(Grid.Row)
    else
      Grid.Cells[8, Grid.Row] := FormatFloat('0.##', Max(0, FloatSeguro(Grid.Cells[8, Grid.Row], 0)));
  end;
end;

procedure TfPedidoProveedorAuto.GridSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect := True;

  // Solo dejamos editar Stock contado y Cantidad final. El resto queda como tabla de consulta.
  if (aRow > 0) and (aCol in [7, 8]) then
    Grid.Options := Grid.Options + [goEditing]
  else
    Grid.Options := Grid.Options - [goEditing];
end;

procedure TfPedidoProveedorAuto.RecalcularCantidadFinalFila(const ARow: Integer);
var
  Sugerido: Double;
  StockContado: Double;
  CantidadFinal: Double;
begin
  if (ARow <= 0) or (ARow >= Grid.RowCount) then Exit;

  Sugerido := FloatSeguro(Grid.Cells[6, ARow], 0);

  if Trim(Grid.Cells[7, ARow]) = '' then
    CantidadFinal := Sugerido
  else
  begin
    StockContado := FloatSeguro(Grid.Cells[7, ARow], 0);
    CantidadFinal := Sugerido - StockContado;
    if CantidadFinal < 0 then
      CantidadFinal := 0;
    CantidadFinal := RedondearArriba(CantidadFinal);
  end;

  Grid.Cells[8, ARow] := FormatFloat('0.##', CantidadFinal);
end;

procedure TfPedidoProveedorAuto.RecalcularTodasCantidadesFinales;
var
  R: Integer;
begin
  if not HayDatosEnGrid then Exit;

  for R := 1 to Grid.RowCount - 1 do
    if Trim(Grid.Cells[0, R]) <> '' then
      RecalcularCantidadFinalFila(R);
end;

procedure TfPedidoProveedorAuto.BtnCerrarClick(Sender: TObject);
begin
  Close;
end;

function TfPedidoProveedorAuto.FloatSeguro(const S: string; const Def: Double): Double;
var
  T: string;
  FS: TFormatSettings;
begin
  T := Trim(S);
  if T = '' then Exit(Def);

  FS := DefaultFormatSettings;
  T := StringReplace(T, '.', FS.DecimalSeparator, [rfReplaceAll]);
  T := StringReplace(T, ',', FS.DecimalSeparator, [rfReplaceAll]);
  Result := StrToFloatDef(T, Def, FS);
end;


function TfPedidoProveedorAuto.EsColumnaNumerica(const Col: Integer): Boolean;
begin
  Result := Col in [2, 3, 4, 5, 6, 7, 8, 11, 12, 13, 14];
end;

function TfPedidoProveedorAuto.EsColumnaFecha(const Col: Integer): Boolean;
begin
  Result := Col in [9, 10];
end;

function TfPedidoProveedorAuto.TextoContiene(const Texto, Busqueda: string): Boolean;
var
  T: string;
  B: string;
begin
  B := UTF8LowerCase(Trim(Busqueda));
  if B = '' then
    Exit(True);

  T := UTF8LowerCase(Texto);
  Result := Pos(B, T) > 0;
end;

function TfPedidoProveedorAuto.CompararCeldas(const A, B: string; const Col: Integer): Integer;
var
  FA: Double;
  FB: Double;
  DA: TDateTime;
  DB: TDateTime;
  OKA: Boolean;
  OKB: Boolean;
begin
  Result := 0;

  if EsColumnaNumerica(Col) then
  begin
    FA := FloatSeguro(A, 0);
    FB := FloatSeguro(B, 0);
    if FA < FB then Result := -1
    else if FA > FB then Result := 1;
    Exit;
  end;

  if EsColumnaFecha(Col) then
  begin
    OKA := TryStrToDate(Trim(A), DA);
    OKB := TryStrToDate(Trim(B), DB);
    if OKA and OKB then
    begin
      if DA < DB then Result := -1
      else if DA > DB then Result := 1;
      Exit;
    end;
  end;

  Result := AnsiCompareText(Trim(A), Trim(B));
end;

function TfPedidoProveedorAuto.RedondearArriba(const Valor: Double): Double;
begin
  if Valor <= 0 then
    Result := 0
  else
    Result := Ceil(Valor);
end;

function TfPedidoProveedorAuto.FechaSQL(const Fecha: TDateTime): string;
begin
  Result := QuotedStr(FormatDateTime('yyyy-mm-dd', Fecha));
end;

function TfPedidoProveedorAuto.CSVSeguro(const S: string): string;
var
  T: string;
begin
  T := StringReplace(S, '"', '""', [rfReplaceAll]);
  Result := '"' + T + '"';
end;


function TfPedidoProveedorAuto.PDFTextoSeguro(const S: string): AnsiString;
var
  T: string;
begin
  // El PDF manual usa Helvetica/WinAnsi. Convertimos desde UTF-8 a CP1252
  // para que acentos, eñes y símbolo euro salgan correctamente.
  T := UTF8ToCP1252(S);
  T := StringReplace(T, '\', '\\', [rfReplaceAll]);
  T := StringReplace(T, '(', '\(', [rfReplaceAll]);
  T := StringReplace(T, ')', '\)', [rfReplaceAll]);
  Result := AnsiString(T);
end;

function TfPedidoProveedorAuto.PDFNum(const V: Double): string;
var
  FS: TFormatSettings;
begin
  FS := DefaultFormatSettings;
  FS.DecimalSeparator := '.';
  Result := FloatToStrF(V, ffFixed, 12, 2, FS);
end;

function TfPedidoProveedorAuto.HayDatosEnGrid: Boolean;
begin
  Result := (Grid <> nil) and (Grid.RowCount > 1) and
    (Trim(Grid.Cells[0, 1]) <> '');
end;

function TfPedidoProveedorAuto.IntentarAbrirConPrograma(const Programa,
  NombreFichero: string; out ErrorDetalle: string): Boolean;
var
  P: TProcess;
begin
  Result := False;
  ErrorDetalle := '';

  P := TProcess.Create(nil);
  try
    P.Executable := Programa;
    if Programa = 'gio' then
      P.Parameters.Add('open');
    P.Parameters.Add(NombreFichero);
    P.Options := [];
    try
      P.Execute;
      Result := True;
    except
      on E: Exception do
      begin
        ErrorDetalle := Programa + ': ' + E.Message;
        Result := False;
      end;
    end;
  finally
    P.Free;
  end;
end;

function TfPedidoProveedorAuto.AbrirPDFGenerado(const NombreFichero: string;
  out Metodo, ErrorDetalle: string): Boolean;
var
  Err: string;

  function Probar(const Programa: string): Boolean;
  begin
    Result := IntentarAbrirConPrograma(Programa, NombreFichero, Err);
    if Result then
      Metodo := Programa
    else
    begin
      if ErrorDetalle <> '' then
        ErrorDetalle := ErrorDetalle + LineEnding;
      ErrorDetalle := ErrorDetalle + Err;
    end;
  end;

begin
  Result := False;
  Metodo := '';
  ErrorDetalle := '';

  if not FileExists(NombreFichero) then
  begin
    ErrorDetalle := 'El fichero no existe: ' + NombreFichero;
    Exit;
  end;

  // En Linux suele ser más fiable lanzar xdg-open/visor directamente.
  // OpenDocument se deja como último recurso porque en algunos escritorios/xrdp
  // puede devolver éxito sin llegar a mostrar nada visible.
  if Probar('xdg-open') then Exit(True);
  if Probar('gio') then Exit(True);
  if Probar('evince') then Exit(True);
  if Probar('atril') then Exit(True);
  if Probar('xreader') then Exit(True);
  if Probar('okular') then Exit(True);
  if Probar('qpdfview') then Exit(True);

  try
    if OpenDocument(NombreFichero) then
    begin
      Metodo := 'OpenDocument';
      Exit(True);
    end;
  except
    on E: Exception do
    begin
      if ErrorDetalle <> '' then
        ErrorDetalle := ErrorDetalle + LineEnding;
      ErrorDetalle := ErrorDetalle + 'OpenDocument: ' + E.Message;
    end;
  end;
end;

procedure TfPedidoProveedorAuto.GenerarPDFDesdeGrid(const NombreFichero: string);
type
  TColWidthsPDF = array[0..17] of Double;
var
  BaseW: TColWidthsPDF;
  PageW: Double;
  PageH: Double;
  Margin: Double;
  TitleH: Double;
  HeaderH: Double;
  RowH: Double;
  FontSize: Double;
  HeaderFontSize: Double;
  Scale: Double;
  TotalBase: Double;
  RowsPerPage: Integer;
  PageCount: Integer;
  CurRow: Integer;
  PageNum: Integer;
  Objects: array of AnsiString;
  Offsets: array of Integer;
  Kids: AnsiString;

  function AddObject(const Body: AnsiString): Integer;
  begin
    SetLength(Objects, Length(Objects) + 1);
    Objects[High(Objects)] := Body;
    Result := Length(Objects);
  end;

  function PdfCellText(const S: string): AnsiString;
  begin
    Result := PDFTextoSeguro(S);
  end;

  procedure AddCmd(var C: AnsiString; const S: AnsiString);
  begin
    C := C + S + #10;
  end;

  procedure AddText(var C: AnsiString; const X, TopY, Size: Double;
    const S: string; const Bold: Boolean);
  var
    BY: Double;
  begin
    BY := PageH - TopY - Size;
    if Bold then
      AddCmd(C, 'BT /F1 ' + AnsiString(PDFNum(Size)) + ' Tf ' +
        AnsiString(PDFNum(X)) + ' ' + AnsiString(PDFNum(BY)) +
        ' Td (' + PdfCellText(S) + ') Tj ET')
    else
      AddCmd(C, 'BT /F1 ' + AnsiString(PDFNum(Size)) + ' Tf ' +
        AnsiString(PDFNum(X)) + ' ' + AnsiString(PDFNum(BY)) +
        ' Td (' + PdfCellText(S) + ') Tj ET');
  end;

  procedure AddCell(var C: AnsiString; const X, TopY, W, H: Double;
    const S: string; const IsHeader: Boolean);
  var
    BY: Double;
    SizeUse: Double;
  begin
    BY := PageH - TopY - H;

    if IsHeader then
    begin
      AddCmd(C, '0.90 0.90 0.90 rg');
      AddCmd(C, AnsiString(PDFNum(X)) + ' ' + AnsiString(PDFNum(BY)) + ' ' +
        AnsiString(PDFNum(W)) + ' ' + AnsiString(PDFNum(H)) + ' re f');
      AddCmd(C, '0 0 0 rg');
      SizeUse := HeaderFontSize;
    end
    else
      SizeUse := FontSize;

    AddCmd(C, '0.35 w');
    AddCmd(C, AnsiString(PDFNum(X)) + ' ' + AnsiString(PDFNum(BY)) + ' ' +
      AnsiString(PDFNum(W)) + ' ' + AnsiString(PDFNum(H)) + ' re S');

    // Recorte por celda para que descripciones/observaciones largas no invadan columnas.
    AddCmd(C, 'q');
    AddCmd(C, AnsiString(PDFNum(X + 1)) + ' ' + AnsiString(PDFNum(BY + 1)) + ' ' +
      AnsiString(PDFNum(W - 2)) + ' ' + AnsiString(PDFNum(H - 2)) + ' re W n');
    AddText(C, X + 2, TopY + 4, SizeUse, S, IsHeader);
    AddCmd(C, 'Q');
  end;

  function BuildPage(const StartRow, EndRow, APage, APageCount: Integer): AnsiString;
  var
    C: AnsiString;
    X: Double;
    Y: Double;
    R: Integer;
    Col: Integer;
  begin
    C := '';
    AddCmd(C, '0 0 0 rg');
    AddText(C, Margin, Margin, 11, 'Propuesta de pedido - ' + NombreProveedorSeleccionado, True);
    AddText(C, Margin, Margin + 14, 7,
      'Generado: ' + DateTimeToStr(Now) + '   Proveedor: ' + cbProveedor.Text +
      '   Pagina ' + IntToStr(APage) + ' de ' + IntToStr(APageCount), False);

    Y := Margin + TitleH;
    X := Margin;
    for Col := 0 to Grid.ColCount - 1 do
    begin
      AddCell(C, X, Y, BaseW[Col] * Scale, HeaderH, Grid.Cells[Col, 0], True);
      X := X + BaseW[Col] * Scale;
    end;

    Y := Y + HeaderH;
    for R := StartRow to EndRow do
    begin
      X := Margin;
      for Col := 0 to Grid.ColCount - 1 do
      begin
        AddCell(C, X, Y, BaseW[Col] * Scale, RowH, Grid.Cells[Col, R], False);
        X := X + BaseW[Col] * Scale;
      end;
      Y := Y + RowH;
    end;

    Result := C;
  end;

  procedure SavePDFToFile(const FileName: string);
  var
    FS: TFileStream;
    PDF: AnsiString;
    XRefPos: Integer;
    I: Integer;

    procedure AddPDF(const S: AnsiString);
    begin
      PDF := PDF + S;
    end;

    function Pad10(const N: Integer): AnsiString;
    begin
      Result := AnsiString(Format('%.10d', [N]));
    end;

  begin
    PDF := '%PDF-1.4'#10 + '%FacturLinEx Pedido Auto'#10;
    SetLength(Offsets, Length(Objects) + 1);

    for I := 0 to High(Objects) do
    begin
      Offsets[I + 1] := Length(PDF);
      AddPDF(AnsiString(IntToStr(I + 1)) + ' 0 obj'#10 + Objects[I] + #10'endobj'#10);
    end;

    XRefPos := Length(PDF);
    AddPDF('xref'#10);
    AddPDF('0 ' + AnsiString(IntToStr(Length(Objects) + 1)) + #10);
    AddPDF('0000000000 65535 f '#10);
    for I := 1 to Length(Objects) do
      AddPDF(Pad10(Offsets[I]) + ' 00000 n '#10);

    AddPDF('trailer'#10);
    AddPDF('<< /Size ' + AnsiString(IntToStr(Length(Objects) + 1)) +
      ' /Root 1 0 R >>'#10);
    AddPDF('startxref'#10 + AnsiString(IntToStr(XRefPos)) + #10'%%EOF'#10);

    FS := TFileStream.Create(FileName, fmCreate);
    try
      if Length(PDF) > 0 then
        FS.WriteBuffer(PDF[1], Length(PDF));
    finally
      FS.Free;
    end;
  end;

var
  Content: AnsiString;
  ContentObj: Integer;
  PageObj: Integer;
  StartR: Integer;
  EndR: Integer;
  P: Integer;
begin
  if not HayDatosEnGrid then
    raise Exception.Create('No hay datos para generar PDF.');

  // A4 horizontal en puntos PDF.
  PageW := 842;
  PageH := 595;
  Margin := 16;
  TitleH := 34;
  HeaderH := 17;
  RowH := 15;
  FontSize := 5.8;
  HeaderFontSize := 5.6;

  BaseW[0] := 38;   // Código
  BaseW[1] := 122;  // Descripción
  BaseW[2] := 38;   // Vendido periodo
  BaseW[3] := 38;   // Vendido tendencia
  BaseW[4] := 38;   // Vendido histórico
  BaseW[5] := 34;   // Venta/día
  BaseW[6] := 32;   // Sugerido
  BaseW[7] := 34;   // Stock contado
  BaseW[8] := 34;   // Cantidad final
  BaseW[9] := 39;   // Última venta
  BaseW[10] := 39;  // Última compra
  BaseW[11] := 31;  // Coste
  BaseW[12] := 29;  // PVP
  BaseW[13] := 24;  // IVA
  BaseW[14] := 28;  // Stock info
  BaseW[15] := 26;  // Familia
  BaseW[16] := 58;  // Estado
  BaseW[17] := 110; // Observaciones

  TotalBase := 0;
  for P := 0 to High(BaseW) do
    TotalBase := TotalBase + BaseW[P];
  Scale := (PageW - (Margin * 2)) / TotalBase;

  RowsPerPage := Trunc((PageH - (Margin * 2) - TitleH - HeaderH) / RowH);
  if RowsPerPage < 1 then RowsPerPage := 1;

  PageCount := Ceil((Grid.RowCount - 1) / RowsPerPage);
  if PageCount < 1 then PageCount := 1;

  SetLength(Objects, 0);
  AddObject('<< /Type /Catalog /Pages 2 0 R >>');
  AddObject('');
  AddObject('<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>');

  Kids := '';
  CurRow := 1;
  PageNum := 1;
  while CurRow < Grid.RowCount do
  begin
    StartR := CurRow;
    EndR := CurRow + RowsPerPage - 1;
    if EndR > Grid.RowCount - 1 then
      EndR := Grid.RowCount - 1;

    Content := BuildPage(StartR, EndR, PageNum, PageCount);
    PageObj := Length(Objects) + 1;
    ContentObj := PageObj + 1;

    AddObject('<< /Type /Page /Parent 2 0 R /MediaBox [0 0 842 595] ' +
      '/Resources << /Font << /F1 3 0 R >> >> /Contents ' +
      AnsiString(IntToStr(ContentObj)) + ' 0 R >>');
    AddObject('<< /Length ' + AnsiString(IntToStr(Length(Content))) +
      ' >>'#10'stream'#10 + Content + 'endstream');

    Kids := Kids + AnsiString(IntToStr(PageObj)) + ' 0 R ';
    CurRow := EndR + 1;
    Inc(PageNum);
  end;

  Objects[1] := '<< /Type /Pages /Kids [' + Kids + '] /Count ' +
    AnsiString(IntToStr(PageCount)) + ' >>';

  SavePDFToFile(NombreFichero);
end;

procedure TfPedidoProveedorAuto.ImprimirGrid;
type
  TColWidthsPrint = array[0..17] of Integer;
var
  BaseW: TColWidthsPrint;
  TotalBase: Integer;
  Scale: Double;
  ColW: TColWidthsPrint;
  MarginX: Integer;
  MarginY: Integer;
  TitleH: Integer;
  HeaderH: Integer;
  RowH: Integer;
  RowsPerPage: Integer;
  CurRow: Integer;
  EndRow: Integer;
  PageNum: Integer;
  Col: Integer;
  R: Integer;
  X: Integer;
  Y: Integer;
  TxtRect: TRect;

  procedure DrawCell(const AX, AY, AW, AH: Integer; const S: string; const IsHeader: Boolean);
  var
    OldColor: TColor;
  begin
    OldColor := Printer.Canvas.Brush.Color;
    if IsHeader then
      Printer.Canvas.Brush.Color := clSilver
    else
      Printer.Canvas.Brush.Color := clWhite;

    Printer.Canvas.Rectangle(AX, AY, AX + AW, AY + AH);
    Printer.Canvas.Brush.Color := OldColor;

    TxtRect := Rect(AX + 3, AY + 2, AX + AW - 3, AY + AH - 2);
    Printer.Canvas.TextRect(TxtRect, TxtRect.Left, TxtRect.Top, S);
  end;

  procedure DrawPageHeader;
  begin
    Printer.Canvas.Font.Name := 'Helvetica';
    Printer.Canvas.Font.Size := 10;
    Printer.Canvas.Font.Style := [fsBold];
    Printer.Canvas.TextOut(MarginX, MarginY, 'Propuesta de pedido - ' + NombreProveedorSeleccionado);

    Printer.Canvas.Font.Size := 7;
    Printer.Canvas.Font.Style := [];
    Printer.Canvas.TextOut(MarginX, MarginY + Printer.Canvas.TextHeight('Ag') + 4,
      'Generado: ' + DateTimeToStr(Now) + '   Proveedor: ' + cbProveedor.Text +
      '   Página ' + IntToStr(PageNum));
  end;

begin
  if not HayDatosEnGrid then
    raise Exception.Create('No hay datos para imprimir.');

  BaseW[0] := 38;
  BaseW[1] := 122;
  BaseW[2] := 38;
  BaseW[3] := 38;
  BaseW[4] := 38;
  BaseW[5] := 34;
  BaseW[6] := 32;
  BaseW[7] := 34;
  BaseW[8] := 34;
  BaseW[9] := 39;
  BaseW[10] := 39;
  BaseW[11] := 31;
  BaseW[12] := 29;
  BaseW[13] := 24;
  BaseW[14] := 28;
  BaseW[15] := 26;
  BaseW[16] := 58;
  BaseW[17] := 110;

  TotalBase := 0;
  for Col := 0 to High(BaseW) do
    Inc(TotalBase, BaseW[Col]);

  Printer.Orientation := poLandscape;
  Printer.Title := 'Propuesta pedido proveedor';
  Printer.BeginDoc;
  try
    MarginX := Printer.PageWidth div 50;
    MarginY := Printer.PageHeight div 45;
    if MarginX < 20 then MarginX := 20;
    if MarginY < 20 then MarginY := 20;

    Scale := (Printer.PageWidth - (MarginX * 2)) / TotalBase;
    for Col := 0 to High(BaseW) do
      ColW[Col] := Round(BaseW[Col] * Scale);

    Printer.Canvas.Font.Name := 'Helvetica';
    Printer.Canvas.Font.Size := 6;
    HeaderH := Printer.Canvas.TextHeight('Ag') + 8;
    RowH := Printer.Canvas.TextHeight('Ag') + 7;
    TitleH := (Printer.Canvas.TextHeight('Ag') * 3) + 12;

    RowsPerPage := (Printer.PageHeight - (MarginY * 2) - TitleH - HeaderH) div RowH;
    if RowsPerPage < 1 then RowsPerPage := 1;

    CurRow := 1;
    PageNum := 1;
    while CurRow < Grid.RowCount do
    begin
      if PageNum > 1 then
        Printer.NewPage;

      DrawPageHeader;

      Y := MarginY + TitleH;
      X := MarginX;
      Printer.Canvas.Font.Size := 6;
      Printer.Canvas.Font.Style := [fsBold];
      for Col := 0 to Grid.ColCount - 1 do
      begin
        DrawCell(X, Y, ColW[Col], HeaderH, Grid.Cells[Col, 0], True);
        Inc(X, ColW[Col]);
      end;

      EndRow := CurRow + RowsPerPage - 1;
      if EndRow > Grid.RowCount - 1 then
        EndRow := Grid.RowCount - 1;

      Y := Y + HeaderH;
      Printer.Canvas.Font.Style := [];
      for R := CurRow to EndRow do
      begin
        X := MarginX;
        for Col := 0 to Grid.ColCount - 1 do
        begin
          DrawCell(X, Y, ColW[Col], RowH, Grid.Cells[Col, R], False);
          Inc(X, ColW[Col]);
        end;
        Y := Y + RowH;
      end;

      CurRow := EndRow + 1;
      Inc(PageNum);
    end;

    Printer.EndDoc;
  except
    Printer.Abort;
    raise;
  end;
end;

procedure TfPedidoProveedorAuto.AutoAjustarColumnas;
begin
  if Grid.ColCount < 18 then Exit;

  Grid.ColWidths[0] := 90;
  Grid.ColWidths[1] := 245;
  Grid.ColWidths[2] := 95;
  Grid.ColWidths[3] := 95;
  Grid.ColWidths[4] := 105;
  Grid.ColWidths[5] := 95;
  Grid.ColWidths[6] := 80;
  Grid.ColWidths[7] := 90;
  Grid.ColWidths[8] := 90;
  Grid.ColWidths[9] := 85;
  Grid.ColWidths[10] := 85;
  Grid.ColWidths[11] := 70;
  Grid.ColWidths[12] := 70;
  Grid.ColWidths[13] := 55;
  Grid.ColWidths[14] := 75;
  Grid.ColWidths[15] := 60;
  Grid.ColWidths[16] := 150;
  Grid.ColWidths[17] := 430;
end;

end.
