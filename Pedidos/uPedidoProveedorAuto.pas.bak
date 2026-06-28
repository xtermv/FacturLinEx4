unit uPedidoProveedorAuto;

{$mode objfpc}{$H+}
{$codepage utf8}

{
  FacturLinEx - Propuesta automática de pedido por proveedor
  Version: 2026-06-21-v2.9-LOGS-FINAL-PROVISIONAL

  OBJETIVO
  --------
  Generar una PROPUESTA revisable de pedido a proveedor usando ventas reales
  e historial de compras a ese proveedor, sin fiarse del stock actual.

  Hasta v2.2 no creaba pedido real en pedicc/pedidd.
  Desde v2.3 permite crear pedido real SOLO con confirmación previa y usando las líneas visibles con Cantidad final > 0.

  v1.6:
  - Diferencia visualmente dias a cubrir del pedido y dias de analisis de ventas.
  - Anade periodo corto de tendencia, por defecto dia actual del mes.
  - El calculo puede reforzarse con tendencia reciente para no quedarse corto si el articulo acelera ventas.
  - Observaciones muestra la formula usada en cada linea.

  v1.7:
  - Anade columnas editables Stock contado y Cantidad final.
  - Si se introduce Stock contado, Cantidad final = Sugerido - Stock contado, sin bajar de cero.
  - CSV, PDF e impresion usan Cantidad final y el orden visible del grid.

  v1.8:
  - Anade modo Pedido auto proveedor con perfiles semanal/quincenal/manual.
  - Clasifica lineas por confianza ALTA/MEDIA/BAJA.
  - Separa pedido automatico, lineas a revisar y excluidos.
  - Penaliza coste 0, PVP 999, cantidades anormalmente altas y posibles duplicados por descripcion.

  v1.9:
  - Crea tablas propias del modulo con CREATE TABLE IF NOT EXISTS.
  - Guarda y carga perfiles por proveedor/tienda.
  - Permite guardar decisiones por articulo/proveedor: ACEPTAR, REVISAR, EXCLUIR.
  - El modo Auto proveedor aplica esas decisiones persistentes para aprender de tus correcciones.

  v2.0:
  - Anade equivalencias por proveedor/articulo para productos duplicados o EAN cambiados.
  - Permite marcar un articulo como principal o indicar que una linea equivale a otro codigo.
  - Las ventas de los codigos equivalentes se agrupan sobre el codigo principal en el calculo.
  - Los articulos secundarios quedan identificados como equivalentes para evitar pedir duplicados.

  v2.1:
  - Anade barra de progreso y mensajes vivos en procesos largos para evitar sensacion de cuelgue.
  - Refuerza el uso de pedidos anteriores: el articulo candidato sale de pedidd/hipedidd/hipedifadd.
  - Muestra en observaciones que la linea procede del historial de compras/pedidos del proveedor.

  v2.2:
  - Anade borradores propios de pedido automatico, sin crear pedido real en pedicc/pedidd.
  - Permite guardar el grid actual como borrador, cargar el ultimo borrador del proveedor y borrarlo.
  - El borrador conserva cantidades finales, stock contado, confianza, acciones y observaciones.

  v2.3:
  - Recoloca el botón Cerrar arriba a la derecha, separado de botones operativos.
  - Añade Crear pedido real desde las líneas visibles con Cantidad final > 0.
  - Crea cabecera en pediccXXXX y líneas en pediddXXXX con confirmación previa.
  - Si falla durante la inserción, intenta limpiar la cabecera/líneas creadas.

  v2.3.1:
  - Corrige la posición de Cerrar: ahora va en una barra inferior separada,
    alineado a la derecha y siempre visible, sin depender del ancho inicial del formulario.

  v2.3.2:
  - Corrige de forma definitiva Cerrar: vuelve al panel superior, fijo y visible.

  v2.4:
  - Antes de crear el pedido real muestra una revisión previa con importe aproximado,
    unidades, confianza de líneas y avisos de coste 0, PVP 999, dudas, roturas/equivalencias.
  - No añade botones nuevos para no alterar la pantalla ya validada.

  v2.5:
  - Añade Comparar ant. para comparar el listado visible contra el último pedido real
    de ese proveedor en pedicc/pedidd.
  - Muestra líneas nuevas, líneas que suben/bajan mucho y artículos pedidos antes
    que ahora no entran. No modifica datos.

  v2.6:
  - Añade Ver riesgos para filtrar en pantalla las líneas que conviene revisar antes
    de crear el pedido real: confianza no alta, revisar/excluir, coste 0, PVP 999,
    roturas, equivalencias/duplicados y cantidades finales altas.
  - No modifica datos; solo cambia la vista visible del grid.

  v2.7:
  - Añade historial anti-duplicado en pedido_auto_creados.
  - Registra los pedidos reales creados desde este módulo y avisa si se intenta
    crear otro pedido automático reciente del mismo proveedor.

  v2.8:
  - Añade botón Hist. auto para consultar desde la propia pantalla los últimos
    pedidos reales creados desde este módulo para el proveedor seleccionado.


  v2.9:
  - Añade log en fichero para poder diagnosticar fallos en producción.
  - Registra apertura/cierre del módulo, procesos largos, creación/verificación de tablas,
    generación de PDF, impresión, borradores, creación de pedido real y errores capturados.
  - Log diario en ~/.local/share/facturlinex/logs/pedido_auto_YYYYMMDD.log.
  - Se mantiene la distribución validada de botones, especialmente Cerrar.

  Integración esperada:
    uses uPedidoProveedorAuto;

    MostrarPedidoProveedorAuto(Self, TuConexionZConnection, Tienda);

  Donde Tienda suele ser '0000', '0001', etc. según FacturLinEx.
}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls,
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
    Confianza: string;
    Accion: string;
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
    FAutoPedido: TArrayLineaPedidoAuto;
    FAutoRevisar: TArrayLineaPedidoAuto;
    FAutoExcluidos: TArrayLineaPedidoAuto;

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
    lblPerfilAuto: TLabel;
    cbPerfilAuto: TComboBox;
    lblDiasEntrega: TLabel;
    seDiasEntrega: TSpinEdit;

    btnCalcular: TButton;
    btnPedidoDepurado: TButton;
    btnPedidoAuto: TButton;
    btnVerAuto: TButton;
    btnVerRiesgos: TButton;
    btnVerRevisar: TButton;
    btnVerExcluidos: TButton;
    btnGuardarPerfil: TButton;
    btnCargarPerfil: TButton;
    btnAceptarSiempre: TButton;
    btnRevisarSiempre: TButton;
    btnExcluirSiempre: TButton;
    btnQuitarDecision: TButton;
    btnMarcarPrincipal: TButton;
    btnEquivaleA: TButton;
    btnQuitarEquivalencia: TButton;
    btnVerEquivalencias: TButton;
    btnGuardarBorrador: TButton;
    btnCargarBorrador: TButton;
    btnBorrarBorrador: TButton;
    btnCrearPedidoReal: TButton;
    btnCompararAnterior: TButton;
    btnHistorialCreados: TButton;
    btnExportar: TButton;
    btnPDF: TButton;
    btnImprimir: TButton;
    btnOrdenTienda: TButton;
    btnRecalcularFinal: TButton;
    btnCerrar: TButton;

    lblEstado: TLabel;
    pbProgreso: TProgressBar;

    procedure BtnCalcularClick(Sender: TObject);
    procedure BtnPedidoDepuradoClick(Sender: TObject);
    procedure BtnPedidoAutoClick(Sender: TObject);
    procedure BtnVerAutoClick(Sender: TObject);
    procedure BtnVerRiesgosClick(Sender: TObject);
    procedure BtnVerRevisarClick(Sender: TObject);
    procedure BtnVerExcluidosClick(Sender: TObject);
    procedure BtnGuardarPerfilClick(Sender: TObject);
    procedure BtnCargarPerfilClick(Sender: TObject);
    procedure BtnAceptarSiempreClick(Sender: TObject);
    procedure BtnRevisarSiempreClick(Sender: TObject);
    procedure BtnExcluirSiempreClick(Sender: TObject);
    procedure BtnQuitarDecisionClick(Sender: TObject);
    procedure BtnMarcarPrincipalClick(Sender: TObject);
    procedure BtnEquivaleAClick(Sender: TObject);
    procedure BtnQuitarEquivalenciaClick(Sender: TObject);
    procedure BtnVerEquivalenciasClick(Sender: TObject);
    procedure BtnGuardarBorradorClick(Sender: TObject);
    procedure BtnCargarBorradorClick(Sender: TObject);
    procedure BtnBorrarBorradorClick(Sender: TObject);
    procedure BtnCrearPedidoRealClick(Sender: TObject);
    procedure BtnCompararAnteriorClick(Sender: TObject);
    procedure BtnHistorialCreadosClick(Sender: TObject);
    procedure CbProveedorChange(Sender: TObject);
    procedure CbPerfilAutoChange(Sender: TObject);
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
    procedure ProgresoInicio(const AMensaje: string; const AMax: Integer = 100);
    procedure ProgresoPaso(const AMensaje: string; const APos: Integer = -1; const AMax: Integer = -1);
    procedure ProgresoFin(const AMensaje: string);
    procedure InicializarGrid;
    procedure CargarProveedores;
    procedure FiltrarProveedores(const Texto: string);
    procedure OrdenarGridPorColumna(const Col: Integer; const Ascendente: Boolean);
    procedure ActualizarCabecerasOrden;
    procedure CalcularPropuesta(const Depurada: Boolean);
    procedure CalcularAutoProveedor;
    procedure VaciarListasAuto;
    procedure AddLineaAuto(var ALista: TArrayLineaPedidoAuto; const ALinea: TLineaPedidoAuto);
    procedure PintarListaAuto(const ALista: TArrayLineaPedidoAuto; const Titulo: string);
    procedure MostrarSoloLineasRiesgo;
    function FilaTieneRiesgo(const ARow: Integer): Boolean;
    procedure AplicarDeteccionDuplicados(var Lineas: TArrayLineaPedidoAuto);
    procedure RecalcularCantidadFinalFila(const ARow: Integer);
    procedure RecalcularTodasCantidadesFinales;
    procedure OrdenarPorPrioridad(var Lineas: TArrayLineaPedidoAuto);
    procedure PintarLineasEnGrid(const Lineas: TArrayLineaPedidoAuto; const Limite: Integer);

    function CodigoProveedorSeleccionado: Integer;
    function NombreProveedorSeleccionado: string;
    function SufijoTiendaSeguro(const S: string): string;
    function TablaExiste(const NombreTabla: string): Boolean;
    function CampoExiste(const NombreTabla, NombreCampo: string): Boolean;
    function SQLComprasProveedor(const CodProveedor: Integer): string;
    function SQLVentas(const FechaDesdeHistorico, FechaHasta: TDateTime;
      const CodProveedor: Integer): string;
    function SQLFinal(const CodProveedor: Integer; const FechaDesdeHistorico,
      FechaHasta: TDateTime): string;

    function FloatSeguro(const S: string; const Def: Double): Double;
    function CompararCeldas(const A, B: string; const Col: Integer): Integer;
    function EsColumnaNumerica(const Col: Integer): Boolean;
    function EsColumnaFecha(const Col: Integer): Boolean;
    function TextoContiene(const Texto, Busqueda: string): Boolean;
    function ClaveDescripcionDuplicado(const S: string): string;
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

    procedure CrearTablasPedidoAuto;
    procedure GuardarPerfilProveedor;
    procedure CargarPerfilProveedor(const MostrarAviso: Boolean);
    procedure GuardarDecisionArticulo(const Decision: string);
    procedure QuitarDecisionArticulo;
    procedure ActualizarDecisionFilaVisible(const Decision: string);
    function CodigoArticuloFilaActual: string;
    function PerfilAutoTexto: string;
    function CargarDecisionesProveedor(const CodProveedor: Integer): TStringList;
    function ObtenerDecision(const Decisiones: TStringList; const Codigo: string): string;
    procedure AplicarDecisionPersistente(var Linea: TLineaPedidoAuto; const Decision: string; var Score: Integer);

    procedure GuardarEquivalenciaArticulo(const CodigoArticulo, CodigoPrincipal, Observacion: string);
    procedure QuitarEquivalenciaArticulo;
    function CargarEquivalenciasProveedor(const CodProveedor: Integer): TStringList;
    function ObtenerPrincipalEquivalencia(const Equivalencias: TStringList; const Codigo: string): string;
    procedure MostrarEquivalenciasProveedor;

    function UltimoBorradorIDProveedor(const CodProveedor: Integer): Integer;
    procedure GuardarBorradorActual;
    procedure CargarUltimoBorradorProveedor;
    procedure BorrarUltimoBorradorProveedor;
    function SiguienteNumeroPedidoReal(const Serie: string): Integer;
    function LineasFinalesValidasEnGrid: Integer;
    procedure CrearPedidoRealDesdeGrid;
    function UltimoPedidoRealProveedor(out ASerie: string; out ANumero: Integer;
      out AFecha: TDateTime): Boolean;
    function UltimoPedidoAutoCreadoProveedor(out ASerie: string; out ANumero: Integer;
      out AFecha: TDateTime; out ALineas: Integer): Boolean;
    procedure RegistrarPedidoAutoCreado(const CodProveedor: Integer; const Serie: string;
      const Numero, Lineas: Integer; const Unidades, TotalCosteSin, TotalCosteCon,
      TotalPVP: Double; const Observacion: string);
    procedure CompararConUltimoPedidoReal;
    procedure MostrarHistorialPedidosAutoCreados;

    function RutaLogPedidoAuto: string;
    procedure LogPedidoAuto(const AMensaje: string);
    procedure LogErrorPedidoAuto(const AContexto: string; E: Exception);

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
  VaciarListasAuto;
  LogPedidoAuto('Apertura módulo pedido automático v2.9. Tienda=' + FTienda);

  Caption := 'Propuesta de pedido por proveedor - v2.9 LOGS';
  Position := poScreenCenter;
  Width := 1250;
  Height := 720;
  WindowState := wsMaximized;

  ConstruirInterfaz;
  InicializarGrid;
  CbPerfilAutoChange(nil);
  CrearTablasPedidoAuto;
  CargarProveedores;
end;

destructor TfPedidoProveedorAuto.Destroy;
begin
  LogPedidoAuto('Cierre módulo pedido automático.');
  FreeAndNil(FListaProveedores);
  inherited Destroy;
end;

procedure TfPedidoProveedorAuto.ConstruirInterfaz;
begin
  PanelTop := TPanel.Create(Self);
  PanelTop.Parent := Self;
  PanelTop.Align := alTop;
  PanelTop.Height := 276;
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
  cbProveedor.OnChange := @CbProveedorChange;

  // Botón Cerrar visible y sencillo, sin depender de Align ni del tamaño final de la ventana.
  // Se coloca en la primera fila del panel superior, separado de los botones de cálculo/impresión.
  btnCerrar := TButton.Create(Self);
  btnCerrar.Parent := PanelTop;
  btnCerrar.Left := 930;
  btnCerrar.Top := 8;
  btnCerrar.Width := 110;
  btnCerrar.Height := 26;
  btnCerrar.Caption := 'Cerrar';
  btnCerrar.Hint := 'Cerrar esta ventana';
  btnCerrar.ShowHint := True;
  btnCerrar.OnClick := @BtnCerrarClick;
  btnCerrar.Visible := True;
  btnCerrar.BringToFront;

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

  lblPerfilAuto := TLabel.Create(Self);
  lblPerfilAuto.Parent := PanelTop;
  lblPerfilAuto.Left := 995;
  lblPerfilAuto.Top := 82;
  lblPerfilAuto.Caption := 'Perfil auto:';

  cbPerfilAuto := TComboBox.Create(Self);
  cbPerfilAuto.Parent := PanelTop;
  cbPerfilAuto.Left := 1070;
  cbPerfilAuto.Top := 78;
  cbPerfilAuto.Width := 120;
  cbPerfilAuto.Style := csDropDownList;
  cbPerfilAuto.Items.Add('Semanal');
  cbPerfilAuto.Items.Add('Quincenal');
  cbPerfilAuto.Items.Add('Manual');
  cbPerfilAuto.ItemIndex := 0;
  cbPerfilAuto.Hint := 'Aplica parametros razonables para los dos proveedores principales. Manual no toca los parametros actuales.';
  cbPerfilAuto.ShowHint := True;
  cbPerfilAuto.OnChange := @CbPerfilAutoChange;

  lblDiasEntrega := TLabel.Create(Self);
  lblDiasEntrega.Parent := PanelTop;
  lblDiasEntrega.Left := 1205;
  lblDiasEntrega.Top := 82;
  lblDiasEntrega.Caption := 'Entrega días:';

  seDiasEntrega := TSpinEdit.Create(Self);
  seDiasEntrega.Parent := PanelTop;
  seDiasEntrega.Left := 1290;
  seDiasEntrega.Top := 78;
  seDiasEntrega.Width := 55;
  seDiasEntrega.MinValue := 0;
  seDiasEntrega.MaxValue := 30;
  seDiasEntrega.Value := 2;
  seDiasEntrega.Hint := 'Días aproximados desde que haces el pedido hasta que entra la mercancía. El auto cubre días pedido + entrega.';
  seDiasEntrega.ShowHint := True;

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

  btnPedidoAuto := TButton.Create(Self);
  btnPedidoAuto.Parent := PanelTop;
  btnPedidoAuto.Left := 305;
  btnPedidoAuto.Top := 112;
  btnPedidoAuto.Width := 145;
  btnPedidoAuto.Caption := 'Auto proveedor';
  btnPedidoAuto.Hint := 'Genera pedido automático de alta confianza y separa dudas/excluidos';
  btnPedidoAuto.ShowHint := True;
  btnPedidoAuto.OnClick := @BtnPedidoAutoClick;

  btnVerAuto := TButton.Create(Self);
  btnVerAuto.Parent := PanelTop;
  btnVerAuto.Left := 460;
  btnVerAuto.Top := 112;
  btnVerAuto.Width := 90;
  btnVerAuto.Caption := 'Ver auto';
  btnVerAuto.OnClick := @BtnVerAutoClick;

  btnVerRiesgos := TButton.Create(Self);
  btnVerRiesgos.Parent := PanelTop;
  btnVerRiesgos.Left := 560;
  btnVerRiesgos.Top := 112;
  btnVerRiesgos.Width := 95;
  btnVerRiesgos.Caption := 'Ver riesgos';
  btnVerRiesgos.Hint := 'Muestra solo líneas que conviene revisar antes de crear el pedido real';
  btnVerRiesgos.ShowHint := True;
  btnVerRiesgos.OnClick := @BtnVerRiesgosClick;

  btnVerRevisar := TButton.Create(Self);
  btnVerRevisar.Parent := PanelTop;
  btnVerRevisar.Left := 665;
  btnVerRevisar.Top := 112;
  btnVerRevisar.Width := 95;
  btnVerRevisar.Caption := 'Ver dudas';
  btnVerRevisar.OnClick := @BtnVerRevisarClick;

  btnVerExcluidos := TButton.Create(Self);
  btnVerExcluidos.Parent := PanelTop;
  btnVerExcluidos.Left := 770;
  btnVerExcluidos.Top := 112;
  btnVerExcluidos.Width := 105;
  btnVerExcluidos.Caption := 'Ver excluidos';
  btnVerExcluidos.OnClick := @BtnVerExcluidosClick;

  btnGuardarPerfil := TButton.Create(Self);
  btnGuardarPerfil.Parent := PanelTop;
  btnGuardarPerfil.Left := 890;
  btnGuardarPerfil.Top := 112;
  btnGuardarPerfil.Width := 115;
  btnGuardarPerfil.Caption := 'Guardar perfil';
  btnGuardarPerfil.Hint := 'Guarda los parametros actuales para este proveedor y tienda';
  btnGuardarPerfil.ShowHint := True;
  btnGuardarPerfil.OnClick := @BtnGuardarPerfilClick;

  btnCargarPerfil := TButton.Create(Self);
  btnCargarPerfil.Parent := PanelTop;
  btnCargarPerfil.Left := 1015;
  btnCargarPerfil.Top := 112;
  btnCargarPerfil.Width := 110;
  btnCargarPerfil.Caption := 'Cargar perfil';
  btnCargarPerfil.Hint := 'Carga el perfil guardado para este proveedor';
  btnCargarPerfil.ShowHint := True;
  btnCargarPerfil.OnClick := @BtnCargarPerfilClick;

  btnExportar := TButton.Create(Self);
  btnExportar.Parent := PanelTop;
  btnExportar.Left := 10;
  btnExportar.Top := 148;
  btnExportar.Width := 100;
  btnExportar.Caption := 'Exportar CSV';
  btnExportar.OnClick := @BtnExportarClick;

  btnPDF := TButton.Create(Self);
  btnPDF.Parent := PanelTop;
  btnPDF.Left := 120;
  btnPDF.Top := 148;
  btnPDF.Width := 105;
  btnPDF.Caption := 'Generar PDF';
  btnPDF.OnClick := @BtnPDFClick;

  btnImprimir := TButton.Create(Self);
  btnImprimir.Parent := PanelTop;
  btnImprimir.Left := 235;
  btnImprimir.Top := 148;
  btnImprimir.Width := 90;
  btnImprimir.Caption := 'Imprimir';
  btnImprimir.OnClick := @BtnImprimirClick;

  btnOrdenTienda := TButton.Create(Self);
  btnOrdenTienda.Parent := PanelTop;
  btnOrdenTienda.Left := 335;
  btnOrdenTienda.Top := 148;
  btnOrdenTienda.Width := 110;
  btnOrdenTienda.Caption := 'Orden tienda';
  btnOrdenTienda.Hint := 'Ordena por familia y descripción para revisar lineal por lineal';
  btnOrdenTienda.ShowHint := True;
  btnOrdenTienda.OnClick := @BtnOrdenTiendaClick;

  btnRecalcularFinal := TButton.Create(Self);
  btnRecalcularFinal.Parent := PanelTop;
  btnRecalcularFinal.Left := 455;
  btnRecalcularFinal.Top := 148;
  btnRecalcularFinal.Width := 125;
  btnRecalcularFinal.Caption := 'Recalcular final';
  btnRecalcularFinal.Hint := 'Recalcula Cantidad final = Sugerido - Stock contado en todas las líneas';
  btnRecalcularFinal.ShowHint := True;
  btnRecalcularFinal.OnClick := @BtnRecalcularFinalClick;

  btnCompararAnterior := TButton.Create(Self);
  btnCompararAnterior.Parent := PanelTop;
  btnCompararAnterior.Left := 590;
  btnCompararAnterior.Top := 148;
  btnCompararAnterior.Width := 105;
  btnCompararAnterior.Caption := 'Comparar ant.';
  btnCompararAnterior.Hint := 'Compara el listado visible con el último pedido real de este proveedor';
  btnCompararAnterior.ShowHint := True;
  btnCompararAnterior.OnClick := @BtnCompararAnteriorClick;

  btnHistorialCreados := TButton.Create(Self);
  btnHistorialCreados.Parent := PanelTop;
  btnHistorialCreados.Left := 1210;
  btnHistorialCreados.Top := 184;
  btnHistorialCreados.Width := 120;
  btnHistorialCreados.Caption := 'Hist. auto';
  btnHistorialCreados.Hint := 'Muestra los últimos pedidos reales creados desde este módulo para este proveedor';
  btnHistorialCreados.ShowHint := True;
  btnHistorialCreados.OnClick := @BtnHistorialCreadosClick;

  btnAceptarSiempre := TButton.Create(Self);
  btnAceptarSiempre.Parent := PanelTop;
  btnAceptarSiempre.Left := 700;
  btnAceptarSiempre.Top := 148;
  btnAceptarSiempre.Width := 120;
  btnAceptarSiempre.Caption := 'Aceptar siempre';
  btnAceptarSiempre.Hint := 'Guarda que este articulo/proveedor debe entrar como alta confianza si tiene cantidad sugerida';
  btnAceptarSiempre.ShowHint := True;
  btnAceptarSiempre.OnClick := @BtnAceptarSiempreClick;

  btnRevisarSiempre := TButton.Create(Self);
  btnRevisarSiempre.Parent := PanelTop;
  btnRevisarSiempre.Left := 830;
  btnRevisarSiempre.Top := 148;
  btnRevisarSiempre.Width := 120;
  btnRevisarSiempre.Caption := 'Revisar siempre';
  btnRevisarSiempre.Hint := 'Guarda que este articulo/proveedor debe ir siempre a dudas';
  btnRevisarSiempre.ShowHint := True;
  btnRevisarSiempre.OnClick := @BtnRevisarSiempreClick;

  btnExcluirSiempre := TButton.Create(Self);
  btnExcluirSiempre.Parent := PanelTop;
  btnExcluirSiempre.Left := 960;
  btnExcluirSiempre.Top := 148;
  btnExcluirSiempre.Width := 120;
  btnExcluirSiempre.Caption := 'Excluir siempre';
  btnExcluirSiempre.Hint := 'Guarda que este articulo/proveedor no debe entrar en el pedido automatico';
  btnExcluirSiempre.ShowHint := True;
  btnExcluirSiempre.OnClick := @BtnExcluirSiempreClick;

  btnQuitarDecision := TButton.Create(Self);
  btnQuitarDecision.Parent := PanelTop;
  btnQuitarDecision.Left := 1090;
  btnQuitarDecision.Top := 148;
  btnQuitarDecision.Width := 120;
  btnQuitarDecision.Caption := 'Quitar regla';
  btnQuitarDecision.Hint := 'Elimina la decision guardada para este articulo/proveedor';
  btnQuitarDecision.ShowHint := True;
  btnQuitarDecision.OnClick := @BtnQuitarDecisionClick;

  btnMarcarPrincipal := TButton.Create(Self);
  btnMarcarPrincipal.Parent := PanelTop;
  btnMarcarPrincipal.Left := 10;
  btnMarcarPrincipal.Top := 184;
  btnMarcarPrincipal.Width := 130;
  btnMarcarPrincipal.Caption := 'Marcar principal';
  btnMarcarPrincipal.Hint := 'Marca el articulo seleccionado como codigo principal para equivalencias de este proveedor';
  btnMarcarPrincipal.ShowHint := True;
  btnMarcarPrincipal.OnClick := @BtnMarcarPrincipalClick;

  btnEquivaleA := TButton.Create(Self);
  btnEquivaleA.Parent := PanelTop;
  btnEquivaleA.Left := 150;
  btnEquivaleA.Top := 184;
  btnEquivaleA.Width := 145;
  btnEquivaleA.Caption := 'Equivale a...';
  btnEquivaleA.Hint := 'Indica que el articulo seleccionado equivale a otro codigo principal. Sus ventas se sumaran al principal.';
  btnEquivaleA.ShowHint := True;
  btnEquivaleA.OnClick := @BtnEquivaleAClick;

  btnQuitarEquivalencia := TButton.Create(Self);
  btnQuitarEquivalencia.Parent := PanelTop;
  btnQuitarEquivalencia.Left := 305;
  btnQuitarEquivalencia.Top := 184;
  btnQuitarEquivalencia.Width := 145;
  btnQuitarEquivalencia.Caption := 'Quitar equival.';
  btnQuitarEquivalencia.Hint := 'Elimina la equivalencia guardada para el articulo seleccionado';
  btnQuitarEquivalencia.ShowHint := True;
  btnQuitarEquivalencia.OnClick := @BtnQuitarEquivalenciaClick;

  btnVerEquivalencias := TButton.Create(Self);
  btnVerEquivalencias.Parent := PanelTop;
  btnVerEquivalencias.Left := 460;
  btnVerEquivalencias.Top := 184;
  btnVerEquivalencias.Width := 145;
  btnVerEquivalencias.Caption := 'Ver equival.';
  btnVerEquivalencias.Hint := 'Muestra las equivalencias guardadas para este proveedor';
  btnVerEquivalencias.ShowHint := True;
  btnVerEquivalencias.OnClick := @BtnVerEquivalenciasClick;

  btnGuardarBorrador := TButton.Create(Self);
  btnGuardarBorrador.Parent := PanelTop;
  btnGuardarBorrador.Left := 620;
  btnGuardarBorrador.Top := 184;
  btnGuardarBorrador.Width := 125;
  btnGuardarBorrador.Caption := 'Guardar borr.';
  btnGuardarBorrador.Hint := 'Guarda la propuesta visible como borrador propio del modulo, sin crear pedido real';
  btnGuardarBorrador.ShowHint := True;
  btnGuardarBorrador.OnClick := @BtnGuardarBorradorClick;

  btnCargarBorrador := TButton.Create(Self);
  btnCargarBorrador.Parent := PanelTop;
  btnCargarBorrador.Left := 755;
  btnCargarBorrador.Top := 184;
  btnCargarBorrador.Width := 125;
  btnCargarBorrador.Caption := 'Cargar borr.';
  btnCargarBorrador.Hint := 'Carga el ultimo borrador guardado para el proveedor seleccionado';
  btnCargarBorrador.ShowHint := True;
  btnCargarBorrador.OnClick := @BtnCargarBorradorClick;

  btnBorrarBorrador := TButton.Create(Self);
  btnBorrarBorrador.Parent := PanelTop;
  btnBorrarBorrador.Left := 890;
  btnBorrarBorrador.Top := 184;
  btnBorrarBorrador.Width := 125;
  btnBorrarBorrador.Caption := 'Borrar borr.';
  btnBorrarBorrador.Hint := 'Borra el ultimo borrador guardado del proveedor seleccionado';
  btnBorrarBorrador.ShowHint := True;
  btnBorrarBorrador.OnClick := @BtnBorrarBorradorClick;

  btnCrearPedidoReal := TButton.Create(Self);
  btnCrearPedidoReal.Parent := PanelTop;
  btnCrearPedidoReal.Left := 1030;
  btnCrearPedidoReal.Top := 184;
  btnCrearPedidoReal.Width := 165;
  btnCrearPedidoReal.Caption := 'Crear pedido real';
  btnCrearPedidoReal.Hint := 'Crea un pedido real en pedicc/pedidd usando solo las líneas visibles con Cantidad final > 0. Pide confirmación antes de insertar.';
  btnCrearPedidoReal.ShowHint := True;
  btnCrearPedidoReal.OnClick := @BtnCrearPedidoRealClick;

  lblEstado := TLabel.Create(Self);
  lblEstado.Parent := PanelTop;
  lblEstado.Left := 10;
  lblEstado.Top := 224;
  lblEstado.Width := 1500;
  lblEstado.Caption := 'Días pedido = cobertura. Auto proveedor separa pedido claro, dudas y excluidos. Log activo en ~/.local/share/facturlinex/logs/.';

  pbProgreso := TProgressBar.Create(Self);
  pbProgreso.Parent := PanelTop;
  pbProgreso.Left := 10;
  pbProgreso.Top := 248;
  pbProgreso.Width := 1500;
  pbProgreso.Height := 16;
  pbProgreso.Min := 0;
  pbProgreso.Max := 100;
  pbProgreso.Position := 0;
  pbProgreso.Visible := False;

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


procedure TfPedidoProveedorAuto.ProgresoInicio(const AMensaje: string; const AMax: Integer);
begin
  LogPedidoAuto('INICIO: ' + AMensaje);
  if Assigned(pbProgreso) then
  begin
    pbProgreso.Visible := True;
    pbProgreso.Min := 0;
    if AMax > 0 then
      pbProgreso.Max := AMax
    else
      pbProgreso.Max := 100;
    pbProgreso.Position := 0;
  end;
  lblEstado.Caption := AMensaje;
  Application.ProcessMessages;
end;

procedure TfPedidoProveedorAuto.ProgresoPaso(const AMensaje: string; const APos: Integer; const AMax: Integer);
var
  P: Integer;
begin
  if Assigned(pbProgreso) then
  begin
    if AMax > 0 then
      pbProgreso.Max := AMax;
    if APos >= 0 then
      P := APos
    else
      P := pbProgreso.Position + 1;
    if P > pbProgreso.Max then
      P := 0;
    pbProgreso.Position := P;
  end;
  if AMensaje <> '' then
    lblEstado.Caption := AMensaje;
  Application.ProcessMessages;
end;

procedure TfPedidoProveedorAuto.ProgresoFin(const AMensaje: string);
begin
  if AMensaje <> '' then
    LogPedidoAuto('FIN: ' + AMensaje);
  if Assigned(pbProgreso) then
  begin
    pbProgreso.Position := 0;
    pbProgreso.Visible := False;
  end;
  if AMensaje <> '' then
    lblEstado.Caption := AMensaje;
  Application.ProcessMessages;
end;


function TfPedidoProveedorAuto.RutaLogPedidoAuto: string;
var
  BaseDir: string;
  HomeDir: string;
begin
  HomeDir := GetEnvironmentVariable('HOME');
  if HomeDir <> '' then
    BaseDir := IncludeTrailingPathDelimiter(HomeDir) + '.local' + PathDelim +
      'share' + PathDelim + 'facturlinex' + PathDelim + 'logs'
  else
    BaseDir := GetTempDir(False);

  try
    ForceDirectories(BaseDir);
  except
    BaseDir := GetTempDir(False);
  end;

  Result := IncludeTrailingPathDelimiter(BaseDir) + 'pedido_auto_' +
    FormatDateTime('yyyymmdd', Date) + '.log';
end;

procedure TfPedidoProveedorAuto.LogPedidoAuto(const AMensaje: string);
var
  F: TextFile;
  FN: string;
begin
  try
    FN := RutaLogPedidoAuto;
    AssignFile(F, FN);
    if FileExists(FN) then
      Append(F)
    else
      Rewrite(F);
    try
      Writeln(F, FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) +
        ' [tienda=' + FTienda + '] ' + AMensaje);
    finally
      CloseFile(F);
    end;
  except
    // El log nunca debe bloquear el trabajo del TPV.
  end;
end;

procedure TfPedidoProveedorAuto.LogErrorPedidoAuto(const AContexto: string; E: Exception);
begin
  if E <> nil then
    LogPedidoAuto('ERROR [' + AContexto + '] ' + E.ClassName + ': ' + E.Message)
  else
    LogPedidoAuto('ERROR [' + AContexto + ']');
end;

procedure TfPedidoProveedorAuto.InicializarGrid;
begin
  FSortCol := -1;
  FSortAsc := True;
  Grid.ColCount := 20;
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
  Grid.Cells[9, 0] := 'Confianza';
  Grid.Cells[10, 0] := 'Acción';
  Grid.Cells[11, 0] := 'Últ. venta';
  Grid.Cells[12, 0] := 'Últ. compra';
  Grid.Cells[13, 0] := 'Coste';
  Grid.Cells[14, 0] := 'PVP';
  Grid.Cells[15, 0] := 'IVA';
  Grid.Cells[16, 0] := 'Stock info';
  Grid.Cells[17, 0] := 'Familia';
  Grid.Cells[18, 0] := 'Estado';
  Grid.Cells[19, 0] := 'Observaciones';

  Grid.Rows[1].Clear;
  AutoAjustarColumnas;
end;

procedure TfPedidoProveedorAuto.CargarProveedores;
var
  Q: TZQuery;
  N: Integer;
begin
  ProgresoInicio('Cargando proveedores...', 100);
  cbProveedor.Items.Clear;
  FListaProveedores.Clear;

  if (FConn = nil) or (not FConn.Connected) then
  begin
    LogPedidoAuto('Conexión no activa al cargar proveedores.');
    ShowMessage('La conexión a la base de datos no está activa.');
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT P0, P1 FROM proveedores ORDER BY P1';
    Q.Open;
    N := 0;
    while not Q.EOF do
    begin
      Inc(N);
      if (N mod 25) = 0 then
        ProgresoPaso('Cargando proveedores... ' + IntToStr(N), -1);
      FListaProveedores.Add(Q.FieldByName('P0').AsString + ' - ' +
        Q.FieldByName('P1').AsString);
      Q.Next;
    end;
  finally
    Q.Free;
  end;

  FiltrarProveedores('');
  CargarPerfilProveedor(False);
  ProgresoFin('Proveedores cargados: ' + IntToStr(cbProveedor.Items.Count));
end;

procedure TfPedidoProveedorAuto.CrearTablasPedidoAuto;
var
  Q: TZQuery;
begin
  if (FConn = nil) or (not FConn.Connected) then
    Exit;

  ProgresoInicio('Verificando tablas del pedido automático...', 6);
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;

    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS pedido_auto_perfiles (' +
      'tienda VARCHAR(20) NOT NULL, ' +
      'cod_proveedor INT NOT NULL, ' +
      'perfil VARCHAR(20) DEFAULT ''Manual'', ' +
      'dias_cubrir INT DEFAULT 7, ' +
      'dias_ventas INT DEFAULT 45, ' +
      'dias_tendencia INT DEFAULT 7, ' +
      'dias_historico INT DEFAULT 180, ' +
      'dias_entrega INT DEFAULT 2, ' +
      'factor DECIMAL(10,4) DEFAULT 1, ' +
      'max_lineas INT DEFAULT 180, ' +
      'min_sugerido DECIMAL(10,4) DEFAULT 1, ' +
      'min_ventas DECIMAL(10,4) DEFAULT 1, ' +
      'min_historico DECIMAL(10,4) DEFAULT 1, ' +
      'usar_tendencia TINYINT DEFAULT 1, ' +
      'incluir_roturas TINYINT DEFAULT 1, ' +
      'excluir_raros TINYINT DEFAULT 0, ' +
      'updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, ' +
      'PRIMARY KEY (tienda, cod_proveedor)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8';
    Q.ExecSQL;
    ProgresoPaso('Verificando perfiles...', 1, 6);

    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS pedido_auto_decisiones (' +
      'tienda VARCHAR(20) NOT NULL, ' +
      'cod_proveedor INT NOT NULL, ' +
      'codigo_articulo VARCHAR(50) NOT NULL, ' +
      'decision VARCHAR(20) NOT NULL, ' +
      'factor DECIMAL(10,4) DEFAULT NULL, ' +
      'cantidad_min DECIMAL(10,4) DEFAULT NULL, ' +
      'cantidad_max DECIMAL(10,4) DEFAULT NULL, ' +
      'observacion VARCHAR(255) DEFAULT '''', ' +
      'updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, ' +
      'PRIMARY KEY (tienda, cod_proveedor, codigo_articulo)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8';
    Q.ExecSQL;
    ProgresoPaso('Verificando decisiones...', 2, 6);

    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS pedido_auto_equivalencias (' +
      'tienda VARCHAR(20) NOT NULL, ' +
      'cod_proveedor INT NOT NULL, ' +
      'codigo_articulo VARCHAR(50) NOT NULL, ' +
      'codigo_principal VARCHAR(50) NOT NULL, ' +
      'observacion VARCHAR(255) DEFAULT '''', ' +
      'updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, ' +
      'PRIMARY KEY (tienda, cod_proveedor, codigo_articulo), ' +
      'KEY idx_principal (tienda, cod_proveedor, codigo_principal)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8';
    Q.ExecSQL;
    ProgresoPaso('Verificando equivalencias...', 3, 6);

    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS pedido_auto_borrador_cab (' +
      'id INT NOT NULL AUTO_INCREMENT, ' +
      'tienda VARCHAR(20) NOT NULL, ' +
      'cod_proveedor INT NOT NULL, ' +
      'nombre_proveedor VARCHAR(160) DEFAULT '''', ' +
      'fecha DATETIME DEFAULT CURRENT_TIMESTAMP, ' +
      'perfil VARCHAR(20) DEFAULT ''Manual'', ' +
      'dias_cubrir INT DEFAULT 0, ' +
      'dias_ventas INT DEFAULT 0, ' +
      'dias_tendencia INT DEFAULT 0, ' +
      'dias_historico INT DEFAULT 0, ' +
      'dias_entrega INT DEFAULT 0, ' +
      'factor DECIMAL(10,4) DEFAULT 1, ' +
      'max_lineas INT DEFAULT 0, ' +
      'estado VARCHAR(20) DEFAULT ''BORRADOR'', ' +
      'total_lineas INT DEFAULT 0, ' +
      'observacion VARCHAR(255) DEFAULT '''', ' +
      'PRIMARY KEY (id), ' +
      'KEY idx_proveedor (tienda, cod_proveedor, fecha)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8';
    Q.ExecSQL;
    ProgresoPaso('Verificando cabeceras de borradores...', 4, 6);

    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS pedido_auto_borrador_lin (' +
      'id INT NOT NULL AUTO_INCREMENT, ' +
      'borrador_id INT NOT NULL, ' +
      'linea INT NOT NULL, ' +
      'codigo_articulo VARCHAR(50) DEFAULT '''', ' +
      'descripcion VARCHAR(255) DEFAULT '''', ' +
      'vendido_periodo DECIMAL(14,4) DEFAULT 0, ' +
      'vendido_tendencia DECIMAL(14,4) DEFAULT 0, ' +
      'vendido_historico DECIMAL(14,4) DEFAULT 0, ' +
      'venta_dia DECIMAL(14,6) DEFAULT 0, ' +
      'sugerido DECIMAL(14,4) DEFAULT 0, ' +
      'stock_contado DECIMAL(14,4) DEFAULT 0, ' +
      'cantidad_final DECIMAL(14,4) DEFAULT 0, ' +
      'confianza VARCHAR(20) DEFAULT '''', ' +
      'accion VARCHAR(40) DEFAULT '''', ' +
      'ult_venta VARCHAR(20) DEFAULT '''', ' +
      'ult_compra VARCHAR(20) DEFAULT '''', ' +
      'coste DECIMAL(14,4) DEFAULT 0, ' +
      'pvp DECIMAL(14,4) DEFAULT 0, ' +
      'iva DECIMAL(8,4) DEFAULT 0, ' +
      'stock_info DECIMAL(14,4) DEFAULT 0, ' +
      'familia VARCHAR(50) DEFAULT '''', ' +
      'estado VARCHAR(80) DEFAULT '''', ' +
      'observaciones TEXT, ' +
      'PRIMARY KEY (id), ' +
      'KEY idx_borrador (borrador_id), ' +
      'KEY idx_codigo (codigo_articulo)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8';
    Q.ExecSQL;
    ProgresoPaso('Verificando líneas de borradores...', 5, 6);

    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS pedido_auto_creados (' +
      'id INT NOT NULL AUTO_INCREMENT, ' +
      'tienda VARCHAR(20) NOT NULL, ' +
      'cod_proveedor INT NOT NULL, ' +
      'nombre_proveedor VARCHAR(160) DEFAULT '''', ' +
      'fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP, ' +
      'serie VARCHAR(20) NOT NULL, ' +
      'numero INT NOT NULL, ' +
      'lineas INT DEFAULT 0, ' +
      'unidades DECIMAL(14,4) DEFAULT 0, ' +
      'total_coste_sin DECIMAL(14,4) DEFAULT 0, ' +
      'total_coste_con DECIMAL(14,4) DEFAULT 0, ' +
      'total_pvp DECIMAL(14,4) DEFAULT 0, ' +
      'origen VARCHAR(30) DEFAULT ''AUTO'', ' +
      'estado VARCHAR(20) DEFAULT ''CREADO'', ' +
      'observacion VARCHAR(255) DEFAULT '''', ' +
      'PRIMARY KEY (id), ' +
      'KEY idx_proveedor_fecha (tienda, cod_proveedor, fecha_creacion), ' +
      'KEY idx_pedido (tienda, serie, numero)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8';
    Q.ExecSQL;
    ProgresoPaso('Verificando historial de pedidos automáticos creados...', 6, 6);
  except
    on E: Exception do
    begin
      LogErrorPedidoAuto('CrearTablasPedidoAuto', E);
      ShowMessage('No se pudieron crear/verificar las tablas del pedido automático.' + LineEnding +
        E.Message + LineEnding + LineEnding +
        'La pantalla puede seguir funcionando, pero no guardará perfiles ni decisiones.');
    end;
  end;
  Q.Free;
  ProgresoFin('Tablas del pedido automático verificadas.');
end;

function TfPedidoProveedorAuto.PerfilAutoTexto: string;
begin
  Result := 'Manual';
  if cbPerfilAuto.ItemIndex >= 0 then
    Result := cbPerfilAuto.Text;
end;

procedure TfPedidoProveedorAuto.GuardarPerfilProveedor;
var
  Q: TZQuery;
  CodProv: Integer;
begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then
  begin
    ShowMessage('Seleccione un proveedor antes de guardar el perfil.');
    Exit;
  end;

  CrearTablasPedidoAuto;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'INSERT INTO pedido_auto_perfiles ' +
      '(tienda, cod_proveedor, perfil, dias_cubrir, dias_ventas, dias_tendencia, dias_historico, ' +
      'dias_entrega, factor, max_lineas, min_sugerido, min_ventas, min_historico, usar_tendencia, ' +
      'incluir_roturas, excluir_raros) VALUES ' +
      '(:tienda, :cod, :perfil, :dc, :dv, :dt, :dh, :de, :factor, :maxl, :minsug, :minven, :minhis, :tend, :rot, :raros) ' +
      'ON DUPLICATE KEY UPDATE perfil=:perfil, dias_cubrir=:dc, dias_ventas=:dv, dias_tendencia=:dt, ' +
      'dias_historico=:dh, dias_entrega=:de, factor=:factor, max_lineas=:maxl, min_sugerido=:minsug, ' +
      'min_ventas=:minven, min_historico=:minhis, usar_tendencia=:tend, incluir_roturas=:rot, excluir_raros=:raros';
    Q.ParamByName('tienda').AsString := FTienda;
    Q.ParamByName('cod').AsInteger := CodProv;
    Q.ParamByName('perfil').AsString := PerfilAutoTexto;
    Q.ParamByName('dc').AsInteger := seDiasCubrir.Value;
    Q.ParamByName('dv').AsInteger := seDiasVentas.Value;
    Q.ParamByName('dt').AsInteger := seDiasTendencia.Value;
    Q.ParamByName('dh').AsInteger := seDiasHistorico.Value;
    Q.ParamByName('de').AsInteger := seDiasEntrega.Value;
    Q.ParamByName('factor').AsFloat := FloatSeguro(edtFactor.Text, 1.0);
    Q.ParamByName('maxl').AsInteger := seMaxLineas.Value;
    Q.ParamByName('minsug').AsFloat := seMinSugerido.Value;
    Q.ParamByName('minven').AsFloat := seMinVentas.Value;
    Q.ParamByName('minhis').AsFloat := seMinHistorico.Value;
    Q.ParamByName('tend').AsInteger := Ord(chkUsarTendencia.Checked);
    Q.ParamByName('rot').AsInteger := Ord(chkIncluirRoturas.Checked);
    Q.ParamByName('raros').AsInteger := Ord(chkExcluirRaros.Checked);
    Q.ExecSQL;
    lblEstado.Caption := 'Perfil guardado para ' + NombreProveedorSeleccionado + '. Se cargará automáticamente al seleccionar el proveedor.';
    LogPedidoAuto('Perfil guardado proveedor=' + NombreProveedorSeleccionado);
  except
    on E: Exception do
    begin
      LogErrorPedidoAuto('GuardarPerfilProveedor', E);
      ShowMessage('Error guardando perfil:' + LineEnding + E.Message);
    end;
  end;
  Q.Free;
end;

procedure TfPedidoProveedorAuto.CargarPerfilProveedor(const MostrarAviso: Boolean);
var
  Q: TZQuery;
  CodProv: Integer;
  Perfil: string;
begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then Exit;

  if not TablaExiste('pedido_auto_perfiles') then
    Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT * FROM pedido_auto_perfiles WHERE tienda=:tienda AND cod_proveedor=:cod';
    Q.ParamByName('tienda').AsString := FTienda;
    Q.ParamByName('cod').AsInteger := CodProv;
    Q.Open;
    if Q.EOF then
    begin
      if MostrarAviso then
        ShowMessage('Este proveedor aún no tiene perfil guardado.');
      Exit;
    end;

    Perfil := Q.FieldByName('perfil').AsString;
    if SameText(Perfil, 'Semanal') then cbPerfilAuto.ItemIndex := 0
    else if SameText(Perfil, 'Quincenal') then cbPerfilAuto.ItemIndex := 1
    else cbPerfilAuto.ItemIndex := 2;

    seDiasCubrir.Value := Q.FieldByName('dias_cubrir').AsInteger;
    seDiasVentas.Value := Q.FieldByName('dias_ventas').AsInteger;
    seDiasTendencia.Value := Q.FieldByName('dias_tendencia').AsInteger;
    seDiasHistorico.Value := Q.FieldByName('dias_historico').AsInteger;
    seDiasEntrega.Value := Q.FieldByName('dias_entrega').AsInteger;
    edtFactor.Text := FormatFloat('0.00', Q.FieldByName('factor').AsFloat);
    seMaxLineas.Value := Q.FieldByName('max_lineas').AsInteger;
    seMinSugerido.Value := Round(Q.FieldByName('min_sugerido').AsFloat);
    seMinVentas.Value := Round(Q.FieldByName('min_ventas').AsFloat);
    seMinHistorico.Value := Round(Q.FieldByName('min_historico').AsFloat);
    chkUsarTendencia.Checked := Q.FieldByName('usar_tendencia').AsInteger <> 0;
    chkIncluirRoturas.Checked := Q.FieldByName('incluir_roturas').AsInteger <> 0;
    chkExcluirRaros.Checked := Q.FieldByName('excluir_raros').AsInteger <> 0;

    lblEstado.Caption := 'Perfil cargado para ' + NombreProveedorSeleccionado +
      '. Auto proveedor usará estos parámetros.';
  except
    on E: Exception do
    begin
      LogErrorPedidoAuto('CargarPerfilProveedor', E);
      if MostrarAviso then
        ShowMessage('Error cargando perfil:' + LineEnding + E.Message);
    end;
  end;
  Q.Free;
end;

procedure TfPedidoProveedorAuto.CbProveedorChange(Sender: TObject);
begin
  CargarPerfilProveedor(False);
end;

procedure TfPedidoProveedorAuto.BtnGuardarPerfilClick(Sender: TObject);
begin
  GuardarPerfilProveedor;
end;

procedure TfPedidoProveedorAuto.BtnCargarPerfilClick(Sender: TObject);
begin
  CargarPerfilProveedor(True);
end;

function TfPedidoProveedorAuto.CodigoArticuloFilaActual: string;
begin
  Result := '';
  if (Grid = nil) or (Grid.Row <= 0) or (Grid.Row >= Grid.RowCount) then
    Exit;
  Result := Trim(Grid.Cells[0, Grid.Row]);
end;

procedure TfPedidoProveedorAuto.ActualizarDecisionFilaVisible(const Decision: string);
begin
  if (Grid = nil) or (Grid.Row <= 0) or (Grid.Row >= Grid.RowCount) then
    Exit;

  if SameText(Decision, 'ACEPTAR') then
  begin
    Grid.Cells[9, Grid.Row] := 'ALTA';
    Grid.Cells[10, Grid.Row] := 'ACEPTAR SIEMPRE';
  end
  else if SameText(Decision, 'REVISAR') then
  begin
    Grid.Cells[9, Grid.Row] := 'MEDIA';
    Grid.Cells[10, Grid.Row] := 'REVISAR SIEMPRE';
  end
  else if SameText(Decision, 'EXCLUIR') then
  begin
    Grid.Cells[9, Grid.Row] := 'BAJA';
    Grid.Cells[10, Grid.Row] := 'EXCLUIR SIEMPRE';
  end
  else
  begin
    Grid.Cells[10, Grid.Row] := '';
  end;

  if Decision <> '' then
    Grid.Cells[19, Grid.Row] := Grid.Cells[19, Grid.Row] + ' Decisión guardada: ' + Decision + '.';
end;

procedure TfPedidoProveedorAuto.GuardarDecisionArticulo(const Decision: string);
var
  Q: TZQuery;
  CodProv: Integer;
  CodArt: string;
begin
  CodProv := CodigoProveedorSeleccionado;
  CodArt := CodigoArticuloFilaActual;
  if CodProv <= 0 then
  begin
    ShowMessage('Seleccione un proveedor.');
    Exit;
  end;
  if CodArt = '' then
  begin
    ShowMessage('Seleccione una línea del grid.');
    Exit;
  end;

  CrearTablasPedidoAuto;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'INSERT INTO pedido_auto_decisiones ' +
      '(tienda, cod_proveedor, codigo_articulo, decision, observacion) VALUES ' +
      '(:tienda, :cod, :art, :dec, :obs) ' +
      'ON DUPLICATE KEY UPDATE decision=:dec, observacion=:obs';
    Q.ParamByName('tienda').AsString := FTienda;
    Q.ParamByName('cod').AsInteger := CodProv;
    Q.ParamByName('art').AsString := CodArt;
    Q.ParamByName('dec').AsString := UpperCase(Decision);
    Q.ParamByName('obs').AsString := Copy(Grid.Cells[1, Grid.Row], 1, 240);
    Q.ExecSQL;
    ActualizarDecisionFilaVisible(UpperCase(Decision));
    lblEstado.Caption := 'Decisión ' + UpperCase(Decision) + ' guardada para artículo ' + CodArt +
      ' / proveedor ' + NombreProveedorSeleccionado + '.';
    LogPedidoAuto('Decisión ' + UpperCase(Decision) + ' guardada. Proveedor=' + NombreProveedorSeleccionado + ' Artículo=' + CodArt);
  except
    on E: Exception do
    begin
      LogErrorPedidoAuto('GuardarDecisionArticulo', E);
      ShowMessage('Error guardando decisión:' + LineEnding + E.Message);
    end;
  end;
  Q.Free;
end;

procedure TfPedidoProveedorAuto.QuitarDecisionArticulo;
var
  Q: TZQuery;
  CodProv: Integer;
  CodArt: string;
begin
  CodProv := CodigoProveedorSeleccionado;
  CodArt := CodigoArticuloFilaActual;
  if (CodProv <= 0) or (CodArt = '') then
  begin
    ShowMessage('Seleccione proveedor y una línea del grid.');
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'DELETE FROM pedido_auto_decisiones WHERE tienda=:tienda AND cod_proveedor=:cod AND codigo_articulo=:art';
    Q.ParamByName('tienda').AsString := FTienda;
    Q.ParamByName('cod').AsInteger := CodProv;
    Q.ParamByName('art').AsString := CodArt;
    Q.ExecSQL;
    ActualizarDecisionFilaVisible('');
    lblEstado.Caption := 'Regla eliminada para artículo ' + CodArt + '.';
  except
    on E: Exception do
    begin
      LogErrorPedidoAuto('QuitarDecisionArticulo', E);
      ShowMessage('Error eliminando decisión:' + LineEnding + E.Message);
    end;
  end;
  Q.Free;
end;

procedure TfPedidoProveedorAuto.BtnAceptarSiempreClick(Sender: TObject);
begin
  GuardarDecisionArticulo('ACEPTAR');
end;

procedure TfPedidoProveedorAuto.BtnRevisarSiempreClick(Sender: TObject);
begin
  GuardarDecisionArticulo('REVISAR');
end;

procedure TfPedidoProveedorAuto.BtnExcluirSiempreClick(Sender: TObject);
begin
  GuardarDecisionArticulo('EXCLUIR');
end;

procedure TfPedidoProveedorAuto.BtnQuitarDecisionClick(Sender: TObject);
begin
  QuitarDecisionArticulo;
end;


procedure TfPedidoProveedorAuto.GuardarEquivalenciaArticulo(const CodigoArticulo,
  CodigoPrincipal, Observacion: string);
var
  Q: TZQuery;
  CodProv: Integer;
  CodArt: string;
  CodPrin: string;
begin
  CodProv := CodigoProveedorSeleccionado;
  CodArt := Trim(CodigoArticulo);
  CodPrin := Trim(CodigoPrincipal);

  if CodProv <= 0 then
  begin
    ShowMessage('Seleccione un proveedor antes de guardar equivalencias.');
    Exit;
  end;

  if CodArt = '' then
  begin
    ShowMessage('Seleccione una línea/artículo.');
    Exit;
  end;

  if CodPrin = '' then
  begin
    ShowMessage('Indique el código principal.');
    Exit;
  end;

  CrearTablasPedidoAuto;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'INSERT INTO pedido_auto_equivalencias ' +
      '(tienda, cod_proveedor, codigo_articulo, codigo_principal, observacion) VALUES ' +
      '(:tienda, :cod, :art, :prin, :obs) ' +
      'ON DUPLICATE KEY UPDATE codigo_principal=:prin, observacion=:obs';
    Q.ParamByName('tienda').AsString := FTienda;
    Q.ParamByName('cod').AsInteger := CodProv;
    Q.ParamByName('art').AsString := CodArt;
    Q.ParamByName('prin').AsString := CodPrin;
    Q.ParamByName('obs').AsString := Copy(Observacion, 1, 255);
    Q.ExecSQL;
    lblEstado.Caption := 'Equivalencia guardada: ' + CodArt + ' -> ' + CodPrin +
      '. Recalcule Auto proveedor para acumular ventas.';
  except
    on E: Exception do
      ShowMessage('Error guardando equivalencia:' + LineEnding + E.Message);
  end;
  Q.Free;
end;

procedure TfPedidoProveedorAuto.QuitarEquivalenciaArticulo;
var
  Q: TZQuery;
  CodProv: Integer;
  CodArt: string;
begin
  CodProv := CodigoProveedorSeleccionado;
  CodArt := CodigoArticuloFilaActual;
  if (CodProv <= 0) or (CodArt = '') then
  begin
    ShowMessage('Seleccione proveedor y una línea/artículo.');
    Exit;
  end;

  if not TablaExiste('pedido_auto_equivalencias') then
  begin
    ShowMessage('No hay tabla de equivalencias creada todavía.');
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'DELETE FROM pedido_auto_equivalencias WHERE tienda=:tienda AND cod_proveedor=:cod AND codigo_articulo=:art';
    Q.ParamByName('tienda').AsString := FTienda;
    Q.ParamByName('cod').AsInteger := CodProv;
    Q.ParamByName('art').AsString := CodArt;
    Q.ExecSQL;
    lblEstado.Caption := 'Equivalencia eliminada para ' + CodArt + '. Recalcule Auto proveedor.';
  except
    on E: Exception do
      ShowMessage('Error eliminando equivalencia:' + LineEnding + E.Message);
  end;
  Q.Free;
end;

function TfPedidoProveedorAuto.CargarEquivalenciasProveedor(const CodProveedor: Integer): TStringList;
var
  Q: TZQuery;
begin
  Result := TStringList.Create;
  Result.NameValueSeparator := '=';
  Result.CaseSensitive := False;
  if (CodProveedor <= 0) or (not TablaExiste('pedido_auto_equivalencias')) then
    Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT codigo_articulo, codigo_principal FROM pedido_auto_equivalencias WHERE tienda=:tienda AND cod_proveedor=:cod';
    Q.ParamByName('tienda').AsString := FTienda;
    Q.ParamByName('cod').AsInteger := CodProveedor;
    Q.Open;
    while not Q.EOF do
    begin
      Result.Values[Trim(Q.FieldByName('codigo_articulo').AsString)] :=
        Trim(Q.FieldByName('codigo_principal').AsString);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

function TfPedidoProveedorAuto.ObtenerPrincipalEquivalencia(
  const Equivalencias: TStringList; const Codigo: string): string;
begin
  Result := '';
  if Equivalencias = nil then Exit;
  Result := Trim(Equivalencias.Values[Trim(Codigo)]);
end;

procedure TfPedidoProveedorAuto.MostrarEquivalenciasProveedor;
var
  Q: TZQuery;
  CodProv: Integer;
  SL: TStringList;
  N: Integer;
begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then
  begin
    ShowMessage('Seleccione proveedor.');
    Exit;
  end;

  if not TablaExiste('pedido_auto_equivalencias') then
  begin
    ShowMessage('Todavía no hay equivalencias guardadas.');
    Exit;
  end;

  SL := TStringList.Create;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT codigo_articulo, codigo_principal, observacion FROM pedido_auto_equivalencias ' +
      'WHERE tienda=:tienda AND cod_proveedor=:cod ORDER BY codigo_principal, codigo_articulo';
    Q.ParamByName('tienda').AsString := FTienda;
    Q.ParamByName('cod').AsInteger := CodProv;
    Q.Open;
    N := 0;
    while not Q.EOF do
    begin
      Inc(N);
      if N <= 80 then
        SL.Add(Q.FieldByName('codigo_articulo').AsString + ' -> ' +
          Q.FieldByName('codigo_principal').AsString + '  ' +
          Q.FieldByName('observacion').AsString);
      Q.Next;
    end;

    if N = 0 then
      ShowMessage('Este proveedor no tiene equivalencias guardadas.')
    else
    begin
      if N > 80 then
        SL.Add('... ' + IntToStr(N - 80) + ' equivalencias más no mostradas en este aviso.');
      ShowMessage('Equivalencias de ' + NombreProveedorSeleccionado + ':' + LineEnding + LineEnding + SL.Text);
    end;
  finally
    Q.Free;
    SL.Free;
  end;
end;

procedure TfPedidoProveedorAuto.BtnMarcarPrincipalClick(Sender: TObject);
var
  CodArt: string;
begin
  CodArt := CodigoArticuloFilaActual;
  if CodArt = '' then
  begin
    ShowMessage('Seleccione una línea/artículo.');
    Exit;
  end;
  GuardarEquivalenciaArticulo(CodArt, CodArt, 'Articulo principal marcado manualmente');
end;

procedure TfPedidoProveedorAuto.BtnEquivaleAClick(Sender: TObject);
var
  CodArt: string;
  CodPrincipal: string;
begin
  CodArt := CodigoArticuloFilaActual;
  if CodArt = '' then
  begin
    ShowMessage('Seleccione la línea que quiere marcar como equivalente.');
    Exit;
  end;

  CodPrincipal := CodArt;
  if InputQuery('Equivalencia de artículo',
    'Código principal al que debe acumular ventas el artículo ' + CodArt + ':', CodPrincipal) then
  begin
    CodPrincipal := Trim(CodPrincipal);
    if CodPrincipal <> '' then
      GuardarEquivalenciaArticulo(CodArt, CodPrincipal,
        'Equivalencia manual: ' + CodArt + ' acumula ventas en ' + CodPrincipal);
  end;
end;

procedure TfPedidoProveedorAuto.BtnQuitarEquivalenciaClick(Sender: TObject);
begin
  QuitarEquivalenciaArticulo;
end;

procedure TfPedidoProveedorAuto.BtnVerEquivalenciasClick(Sender: TObject);
begin
  MostrarEquivalenciasProveedor;
end;

procedure TfPedidoProveedorAuto.BtnGuardarBorradorClick(Sender: TObject);
begin
  GuardarBorradorActual;
end;

procedure TfPedidoProveedorAuto.BtnCargarBorradorClick(Sender: TObject);
begin
  CargarUltimoBorradorProveedor;
end;

procedure TfPedidoProveedorAuto.BtnBorrarBorradorClick(Sender: TObject);
begin
  BorrarUltimoBorradorProveedor;
end;

procedure TfPedidoProveedorAuto.BtnCrearPedidoRealClick(Sender: TObject);
begin
  CrearPedidoRealDesdeGrid;
end;

procedure TfPedidoProveedorAuto.BtnCompararAnteriorClick(Sender: TObject);
begin
  CompararConUltimoPedidoReal;
end;

procedure TfPedidoProveedorAuto.BtnHistorialCreadosClick(Sender: TObject);
begin
  MostrarHistorialPedidosAutoCreados;
end;

function TfPedidoProveedorAuto.CargarDecisionesProveedor(const CodProveedor: Integer): TStringList;
var
  Q: TZQuery;
begin
  Result := TStringList.Create;
  Result.CaseSensitive := False;
  Result.NameValueSeparator := '=';

  if (CodProveedor <= 0) or (not TablaExiste('pedido_auto_decisiones')) then
    Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT codigo_articulo, decision FROM pedido_auto_decisiones WHERE tienda=:tienda AND cod_proveedor=:cod';
    Q.ParamByName('tienda').AsString := FTienda;
    Q.ParamByName('cod').AsInteger := CodProveedor;
    Q.Open;
    while not Q.EOF do
    begin
      Result.Values[Q.FieldByName('codigo_articulo').AsString] := UpperCase(Q.FieldByName('decision').AsString);
      Q.Next;
    end;
  except
    // Si algo falla, no bloqueamos el cálculo automático. Simplemente no aplica decisiones guardadas.
  end;
  Q.Free;
end;

function TfPedidoProveedorAuto.ObtenerDecision(const Decisiones: TStringList; const Codigo: string): string;
begin
  Result := '';
  if Decisiones = nil then Exit;
  Result := UpperCase(Trim(Decisiones.Values[Codigo]));
end;

procedure TfPedidoProveedorAuto.AplicarDecisionPersistente(var Linea: TLineaPedidoAuto;
  const Decision: string; var Score: Integer);
begin
  if Decision = '' then Exit;

  if SameText(Decision, 'EXCLUIR') then
  begin
    Score := 0;
    Linea.Observaciones := Linea.Observaciones + ' Regla guardada: EXCLUIR SIEMPRE.';
  end
  else if SameText(Decision, 'REVISAR') then
  begin
    if Score < 50 then Score := 50;
    if Score >= 80 then Score := 79;
    Linea.Observaciones := Linea.Observaciones + ' Regla guardada: REVISAR SIEMPRE.';
  end
  else if SameText(Decision, 'ACEPTAR') then
  begin
    if Linea.Sugerido > 0 then
    begin
      if Score < 85 then Score := 85;
      Linea.Observaciones := Linea.Observaciones + ' Regla guardada: ACEPTAR SIEMPRE.';
    end
    else
      Linea.Observaciones := Linea.Observaciones + ' Regla ACEPTAR guardada, pero sin cantidad sugerida.';
  end;
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
  Headers: array[0..19] of string = (
    'Código', 'Descripción', 'Vendido periodo', 'Vend. tendencia',
    'Vendido histórico', 'Venta/día usada', 'Sugerido', 'Stock contado',
    'Cantidad final', 'Confianza', 'Acción', 'Últ. venta', 'Últ. compra',
    'Coste', 'PVP', 'IVA', 'Stock info', 'Familia', 'Estado', 'Observaciones');
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


function TfPedidoProveedorAuto.CampoExiste(const NombreTabla, NombreCampo: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) AS C FROM information_schema.COLUMNS ' +
      'WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = :T AND COLUMN_NAME = :CPO';
    Q.ParamByName('T').AsString := NombreTabla;
    Q.ParamByName('CPO').AsString := NombreCampo;
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
  FechaHasta: TDateTime; const CodProveedor: Integer): string;
var
  THis: string;
begin
  Result := '';
  THis := 'hisopdd' + FTienda;

  if not TablaExiste(THis) then Exit;

  if TablaExiste('pedido_auto_equivalencias') then
    Result :=
      'SELECT CODIGO, ' +
      'SUM(CASE WHEN FECHA >= ' + FechaSQL(IncDay(FechaHasta, -seDiasVentas.Value + 1)) +
      ' THEN UDS ELSE 0 END) AS VENTAS_PERIODO, ' +
      'SUM(CASE WHEN FECHA >= ' + FechaSQL(IncDay(FechaHasta, -seDiasTendencia.Value + 1)) +
      ' THEN UDS ELSE 0 END) AS VENTAS_TENDENCIA, ' +
      'SUM(CASE WHEN FECHA < ' + FechaSQL(IncDay(FechaHasta, -seDiasVentas.Value + 1)) +
      ' THEN UDS ELSE 0 END) AS VENTAS_HISTORICO, ' +
      'MAX(FECHA) AS ULT_VENTA ' +
      'FROM (SELECT COALESCE(E.codigo_principal, H.HOD6) AS CODIGO, H.HOD0 AS FECHA, ' +
      'CASE WHEN H.HOD8 > 0 THEN H.HOD8 ELSE 0 END AS UDS ' +
      'FROM `' + THis + '` H LEFT JOIN pedido_auto_equivalencias E ON ' +
      'E.tienda = ''' + FTienda + ''' AND E.cod_proveedor = ' + IntToStr(CodProveedor) +
      ' AND E.codigo_articulo = H.HOD6 ' +
      'WHERE H.HOD0 BETWEEN ' + FechaSQL(FechaDesdeHistorico) +
      ' AND ' + FechaSQL(FechaHasta) + ' AND TRIM(H.HOD6) <> '''') V ' +
      'GROUP BY CODIGO'
  else
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

  VentasSQL := SQLVentas(FechaDesdeHistorico, FechaHasta, CodProveedor);

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
    Grid.Cells[9, R] := Lineas[I].Confianza;
    Grid.Cells[10, R] := Lineas[I].Accion;
    Grid.Cells[11, R] := Lineas[I].UltVenta;
    Grid.Cells[12, R] := Lineas[I].UltCompra;
    Grid.Cells[13, R] := FormatFloat('0.000', Lineas[I].Coste);
    Grid.Cells[14, R] := FormatFloat('0.00', Lineas[I].PVP);
    Grid.Cells[15, R] := FormatFloat('0.##', Lineas[I].IVA);
    Grid.Cells[16, R] := FormatFloat('0.##', Lineas[I].StockInfo);
    Grid.Cells[17, R] := Lineas[I].Familia;
    Grid.Cells[18, R] := Lineas[I].Estado;
    Grid.Cells[19, R] := Lineas[I].Observaciones;
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
  VaciarListasAuto;
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
    ProgresoInicio('Calculando pedido depurado para ' + NombreProveedorSeleccionado + '...', 100)
  else
    ProgresoInicio('Calculando propuesta completa para ' + NombreProveedorSeleccionado + '...', 100);

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
      if (TotalLeidas mod 25) = 0 then
        ProgresoPaso('Analizando artículos comprados al proveedor... ' + IntToStr(TotalLeidas) + ' leídos', -1);
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

      if UltCompra <> '' then
        Obs := Obs + ' Artículo incluido porque aparece en pedidos/compras anteriores de este proveedor; última compra ' + UltCompra + '.'
      else
        Obs := Obs + ' Artículo incluido porque aparece en el historial de pedidos/compras del proveedor.';

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
        L.Confianza := '';
        L.Accion := '';
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
    ProgresoFin('Pedido depurado: mostradas ' + IntToStr(Mostradas) +
      ' de ' + IntToStr(TotalCandidatas) + ' candidatas. Leídas: ' +
      IntToStr(TotalLeidas) + '. Máx. líneas: ' + IntToStr(MaxLineas) +
      '. Filtros: mín sug ' + FormatFloat('0.##', MinSugerido) +
      ', mín venta ' + FormatFloat('0.##', MinVentas) +
      ', mín hist ' + FormatFloat('0.##', MinHistorico) +
      '. Ventas analizadas: ' + DateToStr(FechaDesdeVentas) + ' a ' + DateToStr(FechaHasta) +
      '. Pedido cubre ' + IntToStr(seDiasCubrir.Value) + ' días.');
  end
  else
  begin
    PintarLineasEnGrid(Lineas, 0);
    Mostradas := Length(Lineas);
    ProgresoFin('Propuesta completa calculada. Líneas mostradas: ' +
      IntToStr(Mostradas) + '. Ventas analizadas: ' +
      DateToStr(FechaDesdeVentas) + ' a ' + DateToStr(FechaHasta) +
      '. Pedido cubre ' + IntToStr(seDiasCubrir.Value) + ' días.');
  end;
end;

procedure TfPedidoProveedorAuto.CbPerfilAutoChange(Sender: TObject);
begin
  if cbPerfilAuto.ItemIndex = 0 then
  begin
    // Proveedor semanal: cubrir una semana + entrega, listado corto y prudente.
    seDiasCubrir.Value := 7;
    seDiasVentas.Value := 45;
    seDiasHistorico.Value := 180;
    seDiasEntrega.Value := 2;
    edtFactor.Text := '1,10';
    seMaxLineas.Value := 160;
    seMinSugerido.Value := 2;
    seMinVentas.Value := 2;
    seMinHistorico.Value := 8;
    chkUsarTendencia.Checked := True;
    chkIncluirRoturas.Checked := True;
  end
  else if cbPerfilAuto.ItemIndex = 1 then
  begin
    // Proveedor quincenal: más cobertura y algo más de margen.
    seDiasCubrir.Value := 14;
    seDiasVentas.Value := 60;
    seDiasHistorico.Value := 240;
    seDiasEntrega.Value := 2;
    edtFactor.Text := '1,15';
    seMaxLineas.Value := 220;
    seMinSugerido.Value := 2;
    seMinVentas.Value := 2;
    seMinHistorico.Value := 10;
    chkUsarTendencia.Checked := True;
    chkIncluirRoturas.Checked := True;
  end;

  lblEstado.Caption := 'Perfil auto aplicado. Cobertura real auto = días pedido + entrega.';
end;

procedure TfPedidoProveedorAuto.VaciarListasAuto;
begin
  SetLength(FAutoPedido, 0);
  SetLength(FAutoRevisar, 0);
  SetLength(FAutoExcluidos, 0);
end;

procedure TfPedidoProveedorAuto.AddLineaAuto(var ALista: TArrayLineaPedidoAuto;
  const ALinea: TLineaPedidoAuto);
var
  N: Integer;
begin
  N := Length(ALista);
  SetLength(ALista, N + 1);
  ALista[N] := ALinea;
end;

procedure TfPedidoProveedorAuto.PintarListaAuto(const ALista: TArrayLineaPedidoAuto;
  const Titulo: string);
begin
  PintarLineasEnGrid(ALista, 0);
  lblEstado.Caption := Titulo + ': ' + IntToStr(Length(ALista)) +
    ' línea(s). PDF/CSV/impresión usarán esta vista.';
end;

function TfPedidoProveedorAuto.ClaveDescripcionDuplicado(const S: string): string;
var
  I: Integer;
  C: Char;
  T: string;
begin
  T := UTF8LowerCase(S);
  Result := '';
  for I := 1 to Length(T) do
  begin
    C := T[I];
    if C in ['a'..'z', '0'..'9'] then
      Result := Result + C;
  end;

  // Con una clave corta detectamos artículos partidos por formato/EAN,
  // pero evitando claves muy genéricas de 4-5 letras.
  if Length(Result) > 18 then
    Result := Copy(Result, 1, 18);
  if Length(Result) < 10 then
    Result := '';
end;

function TfPedidoProveedorAuto.FilaTieneRiesgo(const ARow: Integer): Boolean;
var
  Cantidad, Coste, PVP: Double;
  Conf, Accion, EstadoTxt, ObsTxt: string;
begin
  Result := False;
  if (ARow <= 0) or (ARow >= Grid.RowCount) then Exit;
  if Trim(Grid.Cells[0, ARow]) = '' then Exit;

  Cantidad := FloatSeguro(Grid.Cells[8, ARow], 0);
  Coste := FloatSeguro(Grid.Cells[13, ARow], 0);
  PVP := FloatSeguro(Grid.Cells[14, ARow], 0);
  Conf := UpperCase(Trim(Grid.Cells[9, ARow]));
  Accion := UpperCase(Trim(Grid.Cells[10, ARow]));
  EstadoTxt := UpperCase(Trim(Grid.Cells[18, ARow]));
  ObsTxt := UpperCase(Trim(Grid.Cells[19, ARow]));

  // Solo nos interesan riesgos de líneas que podrían entrar al pedido real
  // o líneas que han sido marcadas manualmente como delicadas.
  if Cantidad > 0 then
  begin
    if (Conf <> '') and (Conf <> 'ALTA') then Exit(True);
    if Pos('REVISAR', Accion) > 0 then Exit(True);
    if Pos('EXCLUIR', Accion) > 0 then Exit(True);
    if Coste <= 0 then Exit(True);
    if PVP >= 999 then Exit(True);
    if Cantidad >= 50 then Exit(True);
    if (Pos('ROTURA', EstadoTxt) > 0) or (Pos('ROTURA', ObsTxt) > 0) then Exit(True);
    if (Pos('EQUIVAL', EstadoTxt) > 0) or (Pos('EQUIVAL', ObsTxt) > 0) or
       (Pos('DUPLIC', EstadoTxt) > 0) or (Pos('DUPLIC', ObsTxt) > 0) then Exit(True);
  end;
end;

procedure TfPedidoProveedorAuto.MostrarSoloLineasRiesgo;
var
  Rows, Parts: TStringList;
  R, C, Dest: Integer;
begin
  if not HayDatosEnGrid then
  begin
    ShowMessage('No hay líneas visibles para analizar riesgos.');
    Exit;
  end;

  Rows := TStringList.Create;
  Parts := TStringList.Create;
  try
    Parts.StrictDelimiter := True;
    Parts.Delimiter := #9;

    for R := 1 to Grid.RowCount - 1 do
    begin
      if FilaTieneRiesgo(R) then
      begin
        Parts.Clear;
        for C := 0 to Grid.ColCount - 1 do
          Parts.Add(Grid.Cells[C, R]);
        Rows.Add(Parts.DelimitedText);
      end;
    end;

    if Rows.Count = 0 then
    begin
      ShowMessage('No se han detectado líneas de riesgo en la vista actual.' + LineEnding +
        'Recuerda que este filtro revisa las líneas visibles con Cantidad final > 0.');
      Exit;
    end;

    Grid.RowCount := Rows.Count + 1;
    for R := 0 to Rows.Count - 1 do
    begin
      Parts.DelimitedText := Rows[R];
      Dest := R + 1;
      for C := 0 to Grid.ColCount - 1 do
      begin
        if C < Parts.Count then
          Grid.Cells[C, Dest] := Parts[C]
        else
          Grid.Cells[C, Dest] := '';
      end;
    end;

    lblEstado.Caption := 'Mostrando solo líneas con riesgo: ' + IntToStr(Rows.Count) +
      '. Para volver al listado, pulse Ver auto, Ver dudas, Ver excluidos, Calcular o Cargar borrador.';
    FSortCol := -1;
    ActualizarCabecerasOrden;
  finally
    Parts.Free;
    Rows.Free;
  end;
end;


procedure TfPedidoProveedorAuto.AplicarDeteccionDuplicados(var Lineas: TArrayLineaPedidoAuto);
var
  I: Integer;
  J: Integer;
  KI: string;
  KJ: string;
begin
  for I := Low(Lineas) to High(Lineas) - 1 do
  begin
    KI := ClaveDescripcionDuplicado(Lineas[I].Descripcion);
    if KI = '' then Continue;

    for J := I + 1 to High(Lineas) do
    begin
      KJ := ClaveDescripcionDuplicado(Lineas[J].Descripcion);
      if (KJ <> '') and (KI = KJ) and (Lineas[I].Codigo <> Lineas[J].Codigo) then
      begin
        if (Lineas[I].Confianza = 'ALTA') and
          (Pos('ACEPTAR SIEMPRE', UpperCase(Lineas[I].Observaciones)) = 0) then
        begin
          Lineas[I].Confianza := 'MEDIA';
          Lineas[I].Accion := 'REVISAR';
        end;
        if Pos('Posible duplicado', Lineas[I].Observaciones) = 0 then
          Lineas[I].Observaciones := Lineas[I].Observaciones +
            ' Posible duplicado/artículo partido por descripción similar con código ' +
            Lineas[J].Codigo + '.';
        Lineas[I].Prioridad := Lineas[I].Prioridad - 30000;

        if (Lineas[J].Confianza = 'ALTA') and
          (Pos('ACEPTAR SIEMPRE', UpperCase(Lineas[J].Observaciones)) = 0) then
        begin
          Lineas[J].Confianza := 'MEDIA';
          Lineas[J].Accion := 'REVISAR';
        end;
        if Pos('Posible duplicado', Lineas[J].Observaciones) = 0 then
          Lineas[J].Observaciones := Lineas[J].Observaciones +
            ' Posible duplicado/artículo partido por descripción similar con código ' +
            Lineas[I].Codigo + '.';
        Lineas[J].Prioridad := Lineas[J].Prioridad - 30000;
      end;
    end;
  end;
end;

procedure TfPedidoProveedorAuto.BtnPedidoAutoClick(Sender: TObject);
begin
  CalcularAutoProveedor;
end;

procedure TfPedidoProveedorAuto.BtnVerAutoClick(Sender: TObject);
begin
  PintarListaAuto(FAutoPedido, 'Pedido automático de alta confianza');
end;

procedure TfPedidoProveedorAuto.BtnVerRiesgosClick(Sender: TObject);
begin
  MostrarSoloLineasRiesgo;
end;

procedure TfPedidoProveedorAuto.BtnVerRevisarClick(Sender: TObject);
begin
  PintarListaAuto(FAutoRevisar, 'Líneas a revisar');
end;

procedure TfPedidoProveedorAuto.BtnVerExcluidosClick(Sender: TObject);
begin
  PintarListaAuto(FAutoExcluidos, 'Líneas excluidas');
end;

procedure TfPedidoProveedorAuto.CalcularAutoProveedor;
var
  Q: TZQuery;
  SQL: string;
  CodProv: Integer;
  FechaHasta: TDateTime;
  FechaDesdeVentas: TDateTime;
  FechaDesdeHistorico: TDateTime;
  Factor: Double;
  DiasCoberturaAuto: Integer;
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
  Todas: TArrayLineaPedidoAuto;
  L: TLineaPedidoAuto;
  TotalLeidas: Integer;
  MaxLineas: Integer;
  MinSugerido: Double;
  MinVentas: Double;
  MinHistorico: Double;
  Score: Integer;
  I: Integer;
  Decisiones: TStringList;
  Equivalencias: TStringList;
  DecisionGuardada: string;
  PrincipalEquivalente: string;

  procedure AddTodas(const ALinea: TLineaPedidoAuto);
  var
    N: Integer;
  begin
    N := Length(Todas);
    SetLength(Todas, N + 1);
    Todas[N] := ALinea;
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
  MinVentas := seMinVentas.Value;
  MinHistorico := seMinHistorico.Value;
  DiasCoberturaAuto := seDiasCubrir.Value + seDiasEntrega.Value;
  if DiasCoberturaAuto < 1 then DiasCoberturaAuto := seDiasCubrir.Value;

  FechaHasta := Date;
  FechaDesdeVentas := IncDay(FechaHasta, -seDiasVentas.Value + 1);
  FechaDesdeHistorico := IncDay(FechaDesdeVentas, -seDiasHistorico.Value);

  SQL := SQLFinal(CodProv, FechaDesdeHistorico, FechaHasta);
  if SQL = '' then Exit;

  VaciarListasAuto;
  InicializarGrid;
  ProgresoInicio('Calculando pedido automático para ' + NombreProveedorSeleccionado +
    '... cobertura real ' + IntToStr(DiasCoberturaAuto) + ' días.', 100);

  SetLength(Todas, 0);
  TotalLeidas := 0;

  Decisiones := CargarDecisionesProveedor(CodProv);
  Equivalencias := CargarEquivalenciasProveedor(CodProv);
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := SQL;
    Q.Open;

    while not Q.EOF do
    begin
      Inc(TotalLeidas);
      if (TotalLeidas mod 25) = 0 then
        ProgresoPaso('Analizando pedido automático... ' + IntToStr(TotalLeidas) + ' artículos leídos', -1);
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
        if chkUsarTendencia.Checked and (VentasTendencia > 0) and
          (VentaDiaTendencia > VentaDiaPeriodo) then
        begin
          VentaDia := Max(VentaDiaPeriodo, (VentaDiaPeriodo * 0.65) + (VentaDiaTendencia * 0.35));
          Estado := 'VENTA RECIENTE + TENDENCIA';
          Obs := 'Auto: venta reciente con tendencia. Media ' +
            FormatFloat('0.####', VentaDiaPeriodo) + '/día; tendencia ' +
            FormatFloat('0.####', VentaDiaTendencia) + '/día.';
        end
        else
        begin
          Estado := 'VENTA RECIENTE';
          Obs := 'Auto: venta reciente. Media ' +
            FormatFloat('0.####', VentaDiaPeriodo) + '/día.';
        end;
      end
      else if chkIncluirRoturas.Checked and (VentasHistorico >= MinHistorico) then
      begin
        VentaDia := VentasHistorico / seDiasHistorico.Value;
        Estado := 'POSIBLE ROTURA STOCK';
        Obs := 'Auto: sin venta reciente, pero histórico suficiente. Va a revisar, no entra ciego.';
      end
      else
      begin
        VentaDia := 0;
        Estado := 'SIN VENTA';
        Obs := 'Auto: sin venta útil para pedido automático.';
      end;

      Sugerido := RedondearArriba(VentaDia * DiasCoberturaAuto * Factor);
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

      if UltCompra <> '' then
        Obs := Obs + ' Artículo comprado/pedido anteriormente a este proveedor; última compra ' + UltCompra + '.'
      else
        Obs := Obs + ' Artículo encontrado en pedidos/compras anteriores de este proveedor.';

      Score := 0;
      if Sugerido >= MinSugerido then Inc(Score, 20);
      if VentasPeriodo >= MinVentas then Inc(Score, 45);
      if VentasPeriodo >= (MinVentas * 2) then Inc(Score, 10);
      if VentasTendencia > 0 then Inc(Score, 5);
      if (VentaDiaTendencia > 0) and (VentaDiaTendencia > VentaDiaPeriodo * 1.20) then Inc(Score, 10);
      if VentasHistorico >= MinHistorico then Inc(Score, 5);
      if UltCompra <> '' then Inc(Score, 5);
      if Coste > 0 then Inc(Score, 10) else Dec(Score, 30);
      if (PVP > 0) and (Abs(PVP - 999) > 0.001) then Inc(Score, 10) else Dec(Score, 30);

      if Estado = 'POSIBLE ROTURA STOCK' then
      begin
        if Score > 65 then Score := 65;
        Obs := Obs + ' Rotura tratada como duda para evitar pedir a ciegas.';
      end;

      if Sugerido <= 0 then
        Score := 0;
      if Sugerido < MinSugerido then
        Score := 0;

      if Sugerido > 30 then
      begin
        Dec(Score, 10);
        Obs := Obs + ' Cantidad alta, revisar.';
      end;
      if Sugerido > 60 then
      begin
        Dec(Score, 15);
        Obs := Obs + ' Cantidad muy alta, no se mete ciego.';
      end;

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
      L.Observaciones := Obs + ' Fórmula auto: ' + FormatFloat('0.####', VentaDia) +
        '/día x ' + IntToStr(DiasCoberturaAuto) + ' días x factor ' +
        FormatFloat('0.##', Factor) + ' = ' + FormatFloat('0.##', Sugerido) + '.';

      PrincipalEquivalente := ObtenerPrincipalEquivalencia(Equivalencias, L.Codigo);
      if (PrincipalEquivalente <> '') and (not SameText(PrincipalEquivalente, L.Codigo)) then
      begin
        // Este articulo es secundario: sus ventas ya se acumulan sobre el principal en SQLVentas.
        // Lo mantenemos como excluido/informativo para evitar pedir duplicado.
        Score := 0;
        L.Confianza := 'BAJA';
        L.Accion := 'EQUIVALENTE';
        L.Estado := 'EQUIVALENTE';
        L.Observaciones := L.Observaciones + ' Articulo equivalente de ' + PrincipalEquivalente +
          ': sus ventas se acumulan en el principal para no duplicar pedido.';
      end;

      DecisionGuardada := ObtenerDecision(Decisiones, L.Codigo);
      if DecisionGuardada <> '' then
        AplicarDecisionPersistente(L, DecisionGuardada, Score);

      L.Observaciones := L.Observaciones + ' Score final ' + IntToStr(Score) + '.';
      L.Prioridad := Score * 100000 + (VentasPeriodo * 1000) + (VentasTendencia * 500) + (Sugerido * 100);

      if Score >= 80 then
      begin
        L.Confianza := 'ALTA';
        L.Accion := 'PEDIDO AUTO';
      end
      else if Score >= 50 then
      begin
        L.Confianza := 'MEDIA';
        L.Accion := 'REVISAR';
      end
      else
      begin
        L.Confianza := 'BAJA';
        L.Accion := 'EXCLUIDO';
      end;

      if (PrincipalEquivalente <> '') and (not SameText(PrincipalEquivalente, L.Codigo)) then
      begin
        L.Confianza := 'BAJA';
        L.Accion := 'EQUIVALENTE';
      end
      else if SameText(DecisionGuardada, 'ACEPTAR') then
        L.Accion := 'ACEPTAR SIEMPRE'
      else if SameText(DecisionGuardada, 'REVISAR') then
        L.Accion := 'REVISAR SIEMPRE'
      else if SameText(DecisionGuardada, 'EXCLUIR') then
        L.Accion := 'EXCLUIR SIEMPRE';

      AddTodas(L);
      Q.Next;
    end;
  finally
    Q.Free;
    Decisiones.Free;
    Equivalencias.Free;
  end;

  ProgresoPaso('Detectando posibles duplicados y equivalencias...', 60, 100);
  AplicarDeteccionDuplicados(Todas);
  ProgresoPaso('Ordenando prioridades...', 75, 100);
  OrdenarPorPrioridad(Todas);

  for I := Low(Todas) to High(Todas) do
  begin
    if (Todas[I].Confianza = 'ALTA') and (Length(FAutoPedido) < MaxLineas) then
      AddLineaAuto(FAutoPedido, Todas[I])
    else if (Todas[I].Confianza = 'ALTA') then
    begin
      Todas[I].Confianza := 'MEDIA';
      Todas[I].Accion := 'REVISAR';
      Todas[I].Observaciones := Todas[I].Observaciones + ' Pasada a revisar por superar el máximo de líneas auto.';
      AddLineaAuto(FAutoRevisar, Todas[I]);
    end
    else if Todas[I].Confianza = 'MEDIA' then
      AddLineaAuto(FAutoRevisar, Todas[I])
    else
      AddLineaAuto(FAutoExcluidos, Todas[I]);
  end;

  OrdenarPorPrioridad(FAutoPedido);
  OrdenarPorPrioridad(FAutoRevisar);
  OrdenarPorPrioridad(FAutoExcluidos);
  PintarListaAuto(FAutoPedido, 'Pedido automático ALTA confianza');
  ProgresoFin('Auto proveedor: pedido ' + IntToStr(Length(FAutoPedido)) +
    ', revisar ' + IntToStr(Length(FAutoRevisar)) + ', excluidos ' +
    IntToStr(Length(FAutoExcluidos)) + '. Leídas: ' + IntToStr(TotalLeidas) +
    '. Cobertura real: ' + IntToStr(DiasCoberturaAuto) + ' días. Use Ver dudas antes de crear/mandar pedido.');
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
      ProgresoInicio('Generando PDF...', 100);
      GenerarPDFDesdeGrid(SD.FileName);

      if chkAbrirPDF.Checked then
      begin
        if AbrirPDFGenerado(SD.FileName, Metodo, ErrorDetalle) then
          ProgresoFin('PDF generado y abierto con ' + Metodo + ': ' + SD.FileName)
        else
          begin
            ProgresoFin('PDF generado correctamente, pero no se pudo abrir automáticamente.');
            ShowMessage('PDF generado correctamente, pero no se pudo abrir automáticamente.' + LineEnding +
            'Fichero: ' + SD.FileName + LineEnding + LineEnding +
            'Detalle: ' + ErrorDetalle + LineEnding + LineEnding +
            'Puede abrirlo manualmente con su visor PDF o instalar/asociar xdg-open.');
          end;
      end
      else
      begin
        ProgresoFin('PDF generado correctamente: ' + SD.FileName);
        ShowMessage('PDF generado correctamente:' + LineEnding + SD.FileName);
      end;
    except
      on E: Exception do
      begin
        ProgresoFin('Error generando PDF.');
        LogErrorPedidoAuto('BtnPDFClick', E);
        ShowMessage('Error generando PDF:' + LineEnding + E.Message);
      end;
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
    ProgresoInicio('Enviando propuesta a la impresora...', 100);
    ImprimirGrid;
    ProgresoFin('Propuesta enviada a la impresora.');
    ShowMessage('Propuesta enviada a la impresora.');
  except
    on E: Exception do
    begin
      ProgresoFin('Error imprimiendo propuesta.');
      LogErrorPedidoAuto('BtnImprimirClick', E);
      ShowMessage('Error imprimiendo propuesta:' + LineEnding + E.Message);
    end;
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
        Cmp := CompararCeldas(Grid.Cells[17, I], Grid.Cells[17, J], 17);
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
  Result := Col in [2, 3, 4, 5, 6, 7, 8, 13, 14, 15, 16];
end;

function TfPedidoProveedorAuto.EsColumnaFecha(const Col: Integer): Boolean;
begin
  Result := Col in [11, 12];
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
  TColWidthsPDF = array[0..19] of Double;
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

  BaseW[0] := 34;   // Código
  BaseW[1] := 105;  // Descripción
  BaseW[2] := 34;   // Vendido periodo
  BaseW[3] := 34;   // Vendido tendencia
  BaseW[4] := 34;   // Vendido histórico
  BaseW[5] := 31;   // Venta/día
  BaseW[6] := 29;   // Sugerido
  BaseW[7] := 31;   // Stock contado
  BaseW[8] := 31;   // Cantidad final
  BaseW[9] := 34;   // Confianza
  BaseW[10] := 42;  // Acción
  BaseW[11] := 35;  // Última venta
  BaseW[12] := 35;  // Última compra
  BaseW[13] := 28;  // Coste
  BaseW[14] := 26;  // PVP
  BaseW[15] := 22;  // IVA
  BaseW[16] := 26;  // Stock info
  BaseW[17] := 24;  // Familia
  BaseW[18] := 50;  // Estado
  BaseW[19] := 105; // Observaciones

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
    ProgresoPaso('Generando PDF... página ' + IntToStr(PageNum) + ' de ' + IntToStr(PageCount), PageNum, PageCount);
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
  TColWidthsPrint = array[0..19] of Integer;
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

  BaseW[0] := 34;
  BaseW[1] := 105;
  BaseW[2] := 34;
  BaseW[3] := 34;
  BaseW[4] := 34;
  BaseW[5] := 31;
  BaseW[6] := 29;
  BaseW[7] := 31;
  BaseW[8] := 31;
  BaseW[9] := 34;
  BaseW[10] := 42;
  BaseW[11] := 35;
  BaseW[12] := 35;
  BaseW[13] := 28;
  BaseW[14] := 26;
  BaseW[15] := 22;
  BaseW[16] := 26;
  BaseW[17] := 24;
  BaseW[18] := 50;
  BaseW[19] := 105;

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
      ProgresoPaso('Imprimiendo página ' + IntToStr(PageNum) + '...', -1);
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


function TfPedidoProveedorAuto.UltimoBorradorIDProveedor(const CodProveedor: Integer): Integer;
var
  Q: TZQuery;
begin
  Result := 0;
  if (CodProveedor <= 0) or (not TablaExiste('pedido_auto_borrador_cab')) then
    Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT id FROM pedido_auto_borrador_cab WHERE tienda=:tienda AND cod_proveedor=:cod ORDER BY fecha DESC, id DESC LIMIT 1';
    Q.ParamByName('tienda').AsString := FTienda;
    Q.ParamByName('cod').AsInteger := CodProveedor;
    Q.Open;
    if not Q.EOF then Result := Q.FieldByName('id').AsInteger;
  finally
    Q.Free;
  end;
end;

procedure TfPedidoProveedorAuto.GuardarBorradorActual;
var
  Q: TZQuery;
  CodProv: Integer;
  BorradorID: Integer;
  R, Lineas: Integer;
begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then begin ShowMessage('Seleccione un proveedor antes de guardar el borrador.'); Exit; end;
  if not HayDatosEnGrid then begin ShowMessage('No hay líneas en pantalla para guardar como borrador.'); Exit; end;

  CrearTablasPedidoAuto;
  ProgresoInicio('Guardando borrador de pedido automático...', Grid.RowCount);
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Lineas := Grid.RowCount - 1;
    Q.SQL.Text :=
      'INSERT INTO pedido_auto_borrador_cab ' +
      '(tienda, cod_proveedor, nombre_proveedor, perfil, dias_cubrir, dias_ventas, dias_tendencia, dias_historico, dias_entrega, factor, max_lineas, estado, total_lineas, observacion) VALUES ' +
      '(:tienda, :cod, :nom, :perfil, :dc, :dv, :dt, :dh, :de, :factor, :maxl, ''BORRADOR'', :tot, :obs)';
    Q.ParamByName('tienda').AsString := FTienda;
    Q.ParamByName('cod').AsInteger := CodProv;
    Q.ParamByName('nom').AsString := Copy(NombreProveedorSeleccionado, 1, 160);
    Q.ParamByName('perfil').AsString := PerfilAutoTexto;
    Q.ParamByName('dc').AsInteger := seDiasCubrir.Value;
    Q.ParamByName('dv').AsInteger := seDiasVentas.Value;
    Q.ParamByName('dt').AsInteger := seDiasTendencia.Value;
    Q.ParamByName('dh').AsInteger := seDiasHistorico.Value;
    Q.ParamByName('de').AsInteger := seDiasEntrega.Value;
    Q.ParamByName('factor').AsFloat := FloatSeguro(edtFactor.Text, 1.0);
    Q.ParamByName('maxl').AsInteger := seMaxLineas.Value;
    Q.ParamByName('tot').AsInteger := Lineas;
    Q.ParamByName('obs').AsString := Copy(lblEstado.Caption, 1, 250);
    Q.ExecSQL;

    Q.SQL.Text := 'SELECT LAST_INSERT_ID() AS ID';
    Q.Open;
    BorradorID := Q.FieldByName('ID').AsInteger;
    Q.Close;

    Q.SQL.Text :=
      'INSERT INTO pedido_auto_borrador_lin ' +
      '(borrador_id, linea, codigo_articulo, descripcion, vendido_periodo, vendido_tendencia, vendido_historico, venta_dia, sugerido, stock_contado, cantidad_final, confianza, accion, ult_venta, ult_compra, coste, pvp, iva, stock_info, familia, estado, observaciones) VALUES ' +
      '(:bid, :lin, :codart, :des, :vp, :vt, :vh, :vdia, :sug, :stc, :fin, :conf, :acc, :uv, :uc, :coste, :pvp, :iva, :stock, :fam, :est, :obs)';

    for R := 1 to Grid.RowCount - 1 do
    begin
      if Trim(Grid.Cells[0, R]) = '' then Continue;
      ProgresoPaso('Guardando borrador... línea ' + IntToStr(R) + ' de ' + IntToStr(Lineas), R, Grid.RowCount);
      Q.ParamByName('bid').AsInteger := BorradorID;
      Q.ParamByName('lin').AsInteger := R;
      Q.ParamByName('codart').AsString := Copy(Grid.Cells[0, R], 1, 50);
      Q.ParamByName('des').AsString := Copy(Grid.Cells[1, R], 1, 255);
      Q.ParamByName('vp').AsFloat := FloatSeguro(Grid.Cells[2, R], 0);
      Q.ParamByName('vt').AsFloat := FloatSeguro(Grid.Cells[3, R], 0);
      Q.ParamByName('vh').AsFloat := FloatSeguro(Grid.Cells[4, R], 0);
      Q.ParamByName('vdia').AsFloat := FloatSeguro(Grid.Cells[5, R], 0);
      Q.ParamByName('sug').AsFloat := FloatSeguro(Grid.Cells[6, R], 0);
      Q.ParamByName('stc').AsFloat := FloatSeguro(Grid.Cells[7, R], 0);
      Q.ParamByName('fin').AsFloat := FloatSeguro(Grid.Cells[8, R], 0);
      Q.ParamByName('conf').AsString := Copy(Grid.Cells[9, R], 1, 20);
      Q.ParamByName('acc').AsString := Copy(Grid.Cells[10, R], 1, 40);
      Q.ParamByName('uv').AsString := Copy(Grid.Cells[11, R], 1, 20);
      Q.ParamByName('uc').AsString := Copy(Grid.Cells[12, R], 1, 20);
      Q.ParamByName('coste').AsFloat := FloatSeguro(Grid.Cells[13, R], 0);
      Q.ParamByName('pvp').AsFloat := FloatSeguro(Grid.Cells[14, R], 0);
      Q.ParamByName('iva').AsFloat := FloatSeguro(Grid.Cells[15, R], 0);
      Q.ParamByName('stock').AsFloat := FloatSeguro(Grid.Cells[16, R], 0);
      Q.ParamByName('fam').AsString := Copy(Grid.Cells[17, R], 1, 50);
      Q.ParamByName('est').AsString := Copy(Grid.Cells[18, R], 1, 80);
      Q.ParamByName('obs').AsString := Grid.Cells[19, R];
      Q.ExecSQL;
    end;
    ProgresoFin('Borrador guardado #' + IntToStr(BorradorID) + ' para ' + NombreProveedorSeleccionado + ' con ' + IntToStr(Lineas) + ' líneas. No se ha creado pedido real.');
  except
    on E: Exception do begin ProgresoFin('Error guardando borrador.'); LogErrorPedidoAuto('GuardarBorradorActual', E); ShowMessage('Error guardando borrador:' + LineEnding + E.Message); end;
  end;
  Q.Free;
end;

procedure TfPedidoProveedorAuto.CargarUltimoBorradorProveedor;
var
  Q: TZQuery;
  CodProv: Integer;
  BorradorID: Integer;
  R: Integer;
begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then begin ShowMessage('Seleccione un proveedor antes de cargar el borrador.'); Exit; end;
  BorradorID := UltimoBorradorIDProveedor(CodProv);
  if BorradorID <= 0 then begin ShowMessage('No hay borradores guardados para este proveedor.'); Exit; end;

  ProgresoInicio('Cargando borrador #' + IntToStr(BorradorID) + '...', 100);
  InicializarGrid;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT * FROM pedido_auto_borrador_lin WHERE borrador_id=:bid ORDER BY linea';
    Q.ParamByName('bid').AsInteger := BorradorID;
    Q.Open;
    R := 1;
    while not Q.EOF do
    begin
      if R >= Grid.RowCount then Grid.RowCount := Grid.RowCount + 1;
      if (R mod 25) = 0 then ProgresoPaso('Cargando borrador... línea ' + IntToStr(R), -1);
      Grid.Cells[0, R] := Q.FieldByName('codigo_articulo').AsString;
      Grid.Cells[1, R] := Q.FieldByName('descripcion').AsString;
      Grid.Cells[2, R] := FormatFloat('0.##', Q.FieldByName('vendido_periodo').AsFloat);
      Grid.Cells[3, R] := FormatFloat('0.##', Q.FieldByName('vendido_tendencia').AsFloat);
      Grid.Cells[4, R] := FormatFloat('0.##', Q.FieldByName('vendido_historico').AsFloat);
      Grid.Cells[5, R] := FormatFloat('0.####', Q.FieldByName('venta_dia').AsFloat);
      Grid.Cells[6, R] := FormatFloat('0.##', Q.FieldByName('sugerido').AsFloat);
      Grid.Cells[7, R] := FormatFloat('0.##', Q.FieldByName('stock_contado').AsFloat);
      Grid.Cells[8, R] := FormatFloat('0.##', Q.FieldByName('cantidad_final').AsFloat);
      Grid.Cells[9, R] := Q.FieldByName('confianza').AsString;
      Grid.Cells[10, R] := Q.FieldByName('accion').AsString;
      Grid.Cells[11, R] := Q.FieldByName('ult_venta').AsString;
      Grid.Cells[12, R] := Q.FieldByName('ult_compra').AsString;
      Grid.Cells[13, R] := FormatFloat('0.000', Q.FieldByName('coste').AsFloat);
      Grid.Cells[14, R] := FormatFloat('0.00', Q.FieldByName('pvp').AsFloat);
      Grid.Cells[15, R] := FormatFloat('0.##', Q.FieldByName('iva').AsFloat);
      Grid.Cells[16, R] := FormatFloat('0.##', Q.FieldByName('stock_info').AsFloat);
      Grid.Cells[17, R] := Q.FieldByName('familia').AsString;
      Grid.Cells[18, R] := Q.FieldByName('estado').AsString;
      Grid.Cells[19, R] := Q.FieldByName('observaciones').AsString;
      Inc(R);
      Q.Next;
    end;
    AutoAjustarColumnas;
    ProgresoFin('Borrador #' + IntToStr(BorradorID) + ' cargado. Líneas: ' + IntToStr(R - 1) + '. No es pedido real todavía.');
  except
    on E: Exception do begin ProgresoFin('Error cargando borrador.'); LogErrorPedidoAuto('CargarUltimoBorradorProveedor', E); ShowMessage('Error cargando borrador:' + LineEnding + E.Message); end;
  end;
  Q.Free;
end;

procedure TfPedidoProveedorAuto.BorrarUltimoBorradorProveedor;
var
  Q: TZQuery;
  CodProv: Integer;
  BorradorID: Integer;
begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then begin ShowMessage('Seleccione un proveedor antes de borrar el borrador.'); Exit; end;
  BorradorID := UltimoBorradorIDProveedor(CodProv);
  if BorradorID <= 0 then begin ShowMessage('No hay borradores guardados para este proveedor.'); Exit; end;
  if MessageDlg('Borrar borrador', 'Se va a borrar el último borrador guardado para este proveedor (#' + IntToStr(BorradorID) + ').' + LineEnding + 'No se tocará ningún pedido real. ¿Continuar?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'DELETE FROM pedido_auto_borrador_lin WHERE borrador_id=:bid';
    Q.ParamByName('bid').AsInteger := BorradorID;
    Q.ExecSQL;
    Q.SQL.Text := 'DELETE FROM pedido_auto_borrador_cab WHERE id=:bid';
    Q.ParamByName('bid').AsInteger := BorradorID;
    Q.ExecSQL;
    lblEstado.Caption := 'Borrador #' + IntToStr(BorradorID) + ' borrado. No se ha tocado ningún pedido real.';
  except
    on E: Exception do begin LogErrorPedidoAuto('BorrarUltimoBorradorProveedor', E); ShowMessage('Error borrando borrador:' + LineEnding + E.Message); end;
  end;
  Q.Free;
end;



function TfPedidoProveedorAuto.UltimoPedidoRealProveedor(out ASerie: string;
  out ANumero: Integer; out AFecha: TDateTime): Boolean;
var
  Q: TZQuery;
  CodProv: Integer;
  TPedic: string;
begin
  Result := False;
  ASerie := '';
  ANumero := 0;
  AFecha := 0;
  CodProv := CodigoProveedorSeleccionado;
  TPedic := 'pedicc' + FTienda;

  if (CodProv <= 0) or (not TablaExiste(TPedic)) then
    Exit;
  if (not CampoExiste(TPedic, 'PC1')) or (not CampoExiste(TPedic, 'PC2')) or
     (not CampoExiste(TPedic, 'PC3')) or (not CampoExiste(TPedic, 'PC4')) then
    Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT PC1, PC3, PC4 FROM `' + TPedic + '` ' +
      'WHERE PC2=:prov ORDER BY PC1 DESC, PC4 DESC LIMIT 1';
    Q.ParamByName('prov').AsInteger := CodProv;
    Q.Open;
    if not Q.EOF then
    begin
      AFecha := Q.FieldByName('PC1').AsDateTime;
      ASerie := Q.FieldByName('PC3').AsString;
      ANumero := Q.FieldByName('PC4').AsInteger;
      Result := True;
    end;
  finally
    Q.Free;
  end;
end;

function TfPedidoProveedorAuto.UltimoPedidoAutoCreadoProveedor(out ASerie: string;
  out ANumero: Integer; out AFecha: TDateTime; out ALineas: Integer): Boolean;
var
  Q: TZQuery;
  CodProv: Integer;
begin
  Result := False;
  ASerie := '';
  ANumero := 0;
  AFecha := 0;
  ALineas := 0;
  CodProv := CodigoProveedorSeleccionado;

  if (CodProv <= 0) or (not TablaExiste('pedido_auto_creados')) then
    Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT serie, numero, fecha_creacion, lineas FROM pedido_auto_creados ' +
      'WHERE tienda=:tienda AND cod_proveedor=:prov AND estado=''CREADO'' ' +
      'ORDER BY fecha_creacion DESC, id DESC LIMIT 1';
    Q.ParamByName('tienda').AsString := FTienda;
    Q.ParamByName('prov').AsInteger := CodProv;
    Q.Open;
    if not Q.EOF then
    begin
      ASerie := Q.FieldByName('serie').AsString;
      ANumero := Q.FieldByName('numero').AsInteger;
      AFecha := Q.FieldByName('fecha_creacion').AsDateTime;
      ALineas := Q.FieldByName('lineas').AsInteger;
      Result := True;
    end;
  finally
    Q.Free;
  end;
end;

procedure TfPedidoProveedorAuto.RegistrarPedidoAutoCreado(const CodProveedor: Integer;
  const Serie: string; const Numero, Lineas: Integer; const Unidades,
  TotalCosteSin, TotalCosteCon, TotalPVP: Double; const Observacion: string);
var
  Q: TZQuery;
begin
  if (CodProveedor <= 0) or (not TablaExiste('pedido_auto_creados')) then
    Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'INSERT INTO pedido_auto_creados ' +
      '(tienda, cod_proveedor, nombre_proveedor, fecha_creacion, serie, numero, lineas, unidades, total_coste_sin, total_coste_con, total_pvp, origen, estado, observacion) VALUES ' +
      '(:tienda, :cod, :nombre, NOW(), :serie, :numero, :lineas, :unidades, :total_sin, :total_con, :total_pvp, ''AUTO'', ''CREADO'', :obs)';
    Q.ParamByName('tienda').AsString := FTienda;
    Q.ParamByName('cod').AsInteger := CodProveedor;
    Q.ParamByName('nombre').AsString := Copy(NombreProveedorSeleccionado, 1, 160);
    Q.ParamByName('serie').AsString := Copy(Serie, 1, 20);
    Q.ParamByName('numero').AsInteger := Numero;
    Q.ParamByName('lineas').AsInteger := Lineas;
    Q.ParamByName('unidades').AsFloat := Unidades;
    Q.ParamByName('total_sin').AsFloat := TotalCosteSin;
    Q.ParamByName('total_con').AsFloat := TotalCosteCon;
    Q.ParamByName('total_pvp').AsFloat := TotalPVP;
    Q.ParamByName('obs').AsString := Copy(Observacion, 1, 255);
    Q.ExecSQL;
  except
    // El pedido real ya está creado. No bloqueamos por un fallo en el historial propio.
  end;
  Q.Free;
end;


procedure TfPedidoProveedorAuto.MostrarHistorialPedidosAutoCreados;
var
  CodProv, Cont: Integer;
  Q: TZQuery;
  Texto, Linea: string;
begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then
  begin
    ShowMessage('Seleccione un proveedor para consultar su historial automático.');
    Exit;
  end;

  if not TablaExiste('pedido_auto_creados') then
  begin
    ShowMessage('No existe todavía la tabla pedido_auto_creados.' + LineEnding +
      'Se creará automáticamente al abrir/verificar el módulo, o cuando cree el primer pedido real desde esta pantalla.');
    Exit;
  end;

  ProgresoInicio('Consultando historial de pedidos automáticos creados...', 20);
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT fecha_creacion, serie, numero, lineas, unidades, total_coste_sin, total_coste_con, total_pvp, estado, observacion ' +
      'FROM pedido_auto_creados ' +
      'WHERE tienda = :tienda AND cod_proveedor = :cod ' +
      'ORDER BY fecha_creacion DESC, id DESC LIMIT 20';
    Q.ParamByName('tienda').AsString := FTienda;
    Q.ParamByName('cod').AsInteger := CodProv;
    Q.Open;

    Texto := 'Historial de pedidos automáticos creados' + LineEnding +
             'Proveedor: ' + NombreProveedorSeleccionado + LineEnding +
             StringOfChar('-', 72) + LineEnding;

    Cont := 0;
    while not Q.EOF do
    begin
      Inc(Cont);
      ProgresoPaso('Leyendo historial automático... ' + IntToStr(Cont), Cont, 20);

      Linea := Format('%s  %s/%d  Líneas:%d  Uds:%s  Coste:%s €  PVP:%s €', [
        FormatDateTime('dd/mm/yyyy hh:nn', Q.FieldByName('fecha_creacion').AsDateTime),
        Q.FieldByName('serie').AsString,
        Q.FieldByName('numero').AsInteger,
        Q.FieldByName('lineas').AsInteger,
        FormatFloat('0.##', Q.FieldByName('unidades').AsFloat),
        FormatFloat('0.00', Q.FieldByName('total_coste_con').AsFloat),
        FormatFloat('0.00', Q.FieldByName('total_pvp').AsFloat)
      ]);
      Texto := Texto + Linea + LineEnding;

      if Trim(Q.FieldByName('observacion').AsString) <> '' then
        Texto := Texto + '   Obs: ' + Copy(Q.FieldByName('observacion').AsString, 1, 120) + LineEnding;

      Q.Next;
    end;

    if Cont = 0 then
      Texto := Texto + 'No hay pedidos automáticos creados todavía para este proveedor.' + LineEnding
    else
      Texto := Texto + StringOfChar('-', 72) + LineEnding +
        'Mostrando los últimos ' + IntToStr(Cont) + ' registros. Este historial sirve para detectar duplicados y consultar lo creado desde este módulo.';

    ProgresoFin('Historial automático consultado.');
    ShowMessage(Texto);
  except
    on E: Exception do
    begin
      ProgresoFin('Error consultando historial automático.');
      ShowMessage('Error consultando historial de pedidos automáticos:' + LineEnding + E.Message);
    end;
  end;
  Q.Free;
end;

procedure TfPedidoProveedorAuto.CompararConUltimoPedidoReal;
var
  Q: TZQuery;
  CodProv: Integer;
  TPedid: string;
  SerieAnt: string;
  NumAnt: Integer;
  FechaAnt: TDateTime;
  LastQty, LastDesc, CurQty, CurDesc: TStringList;
  R, I: Integer;
  Cod, Desc: string;
  Qty, LastU, CurU: Double;
  TotalLast, TotalCur, CosteLast, CosteCur: Double;
  LineasLast, LineasCur: Integer;
  Nuevas, Suben, Bajan, Faltan: string;
  CntNuevas, CntSuben, CntBajan, CntFaltan: Integer;
  Resumen: string;

  procedure AddQty(AList, ADesc: TStringList; const ACod, ADescTxt: string; const AQty: Double);
  var
    OldQty: Double;
  begin
    if ACod = '' then Exit;
    OldQty := FloatSeguro(AList.Values[ACod], 0);
    AList.Values[ACod] := FormatFloat('0.######', OldQty + AQty);
    if ADesc.Values[ACod] = '' then
      ADesc.Values[ACod] := ADescTxt;
  end;

  procedure AddLinea(var Texto: string; var Contador: Integer; const Linea: string);
  begin
    Inc(Contador);
    if Contador <= 12 then
      Texto := Texto + '  - ' + Linea + LineEnding;
  end;

begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then
  begin
    ShowMessage('Seleccione un proveedor antes de comparar con el pedido anterior.');
    Exit;
  end;
  if not HayDatosEnGrid then
  begin
    ShowMessage('No hay líneas visibles para comparar.');
    Exit;
  end;

  TPedid := 'pedidd' + FTienda;
  if (not TablaExiste(TPedid)) or (not CampoExiste(TPedid, 'PD2')) or
     (not CampoExiste(TPedid, 'PD3')) or (not CampoExiste(TPedid, 'PD4')) or
     (not CampoExiste(TPedid, 'PD6')) or (not CampoExiste(TPedid, 'PD8')) then
  begin
    ShowMessage('No encuentro la tabla real de líneas de pedido o su estructura no parece la esperada:' + LineEnding +
      TPedid + LineEnding + LineEnding + 'No se ha modificado nada.');
    Exit;
  end;

  if not UltimoPedidoRealProveedor(SerieAnt, NumAnt, FechaAnt) then
  begin
    ShowMessage('No he encontrado ningún pedido real anterior para este proveedor en pedicc/pedidd.' + LineEnding +
      'No se ha modificado nada.');
    Exit;
  end;

  LastQty := TStringList.Create;
  LastDesc := TStringList.Create;
  CurQty := TStringList.Create;
  CurDesc := TStringList.Create;
  Q := TZQuery.Create(nil);
  try
    LastQty.Sorted := False;
    LastDesc.Sorted := False;
    CurQty.Sorted := False;
    CurDesc.Sorted := False;
    TotalLast := 0;
    TotalCur := 0;
    CosteLast := 0;
    CosteCur := 0;

    ProgresoInicio('Comparando con último pedido real...', Grid.RowCount + 50);

    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT PD6, MAX(PD7) AS DESCRIP, SUM(PD8) AS UDS, AVG(PD10) AS COSTE ' +
      'FROM `' + TPedid + '` WHERE PD2=:prov AND PD3=:serie AND PD4=:num ' +
      'GROUP BY PD6 ORDER BY PD6';
    Q.ParamByName('prov').AsInteger := CodProv;
    Q.ParamByName('serie').AsString := SerieAnt;
    Q.ParamByName('num').AsInteger := NumAnt;
    Q.Open;
    while not Q.EOF do
    begin
      Cod := Trim(Q.FieldByName('PD6').AsString);
      Desc := Q.FieldByName('DESCRIP').AsString;
      Qty := Q.FieldByName('UDS').AsFloat;
      AddQty(LastQty, LastDesc, Cod, Desc, Qty);
      TotalLast := TotalLast + Qty;
      CosteLast := CosteLast + (Qty * Q.FieldByName('COSTE').AsFloat);
      if (LastQty.Count mod 25) = 0 then
        ProgresoPaso('Leyendo pedido anterior... ' + IntToStr(LastQty.Count) + ' líneas', -1);
      Q.Next;
    end;

    for R := 1 to Grid.RowCount - 1 do
    begin
      Cod := Trim(Grid.Cells[0, R]);
      Qty := FloatSeguro(Grid.Cells[8, R], 0);
      if (Cod = '') or (Qty <= 0) then Continue;
      Desc := Grid.Cells[1, R];
      AddQty(CurQty, CurDesc, Cod, Desc, Qty);
      TotalCur := TotalCur + Qty;
      CosteCur := CosteCur + (Qty * FloatSeguro(Grid.Cells[13, R], 0));
      if (R mod 25) = 0 then
        ProgresoPaso('Leyendo pedido visible... fila ' + IntToStr(R), R, Grid.RowCount + 50);
    end;

    LineasLast := LastQty.Count;
    LineasCur := CurQty.Count;
    Nuevas := '';
    Suben := '';
    Bajan := '';
    Faltan := '';
    CntNuevas := 0;
    CntSuben := 0;
    CntBajan := 0;
    CntFaltan := 0;

    for I := 0 to CurQty.Count - 1 do
    begin
      Cod := CurQty.Names[I];
      CurU := FloatSeguro(CurQty.ValueFromIndex[I], 0);
      LastU := FloatSeguro(LastQty.Values[Cod], 0);
      if LastQty.IndexOfName(Cod) < 0 then
        AddLinea(Nuevas, CntNuevas, Cod + '  ' + Copy(CurDesc.Values[Cod], 1, 38) +
          '  actual: ' + FormatFloat('0.##', CurU))
      else if (CurU >= LastU + 5) and (CurU >= LastU * 1.5) then
        AddLinea(Suben, CntSuben, Cod + '  ' + Copy(CurDesc.Values[Cod], 1, 38) +
          '  ant.: ' + FormatFloat('0.##', LastU) + '  actual: ' + FormatFloat('0.##', CurU))
      else if (LastU >= CurU + 5) and (CurU <= LastU * 0.5) then
        AddLinea(Bajan, CntBajan, Cod + '  ' + Copy(CurDesc.Values[Cod], 1, 38) +
          '  ant.: ' + FormatFloat('0.##', LastU) + '  actual: ' + FormatFloat('0.##', CurU));
    end;

    for I := 0 to LastQty.Count - 1 do
    begin
      Cod := LastQty.Names[I];
      if CurQty.IndexOfName(Cod) < 0 then
        AddLinea(Faltan, CntFaltan, Cod + '  ' + Copy(LastDesc.Values[Cod], 1, 38) +
          '  ant.: ' + FormatFloat('0.##', FloatSeguro(LastQty.ValueFromIndex[I], 0)));
    end;

    ProgresoFin('Comparativa preparada contra pedido ' + SerieAnt + '/' + IntToStr(NumAnt));

    Resumen :=
      'Comparativa contra el último pedido real del proveedor:' + LineEnding + LineEnding +
      'Proveedor: ' + NombreProveedorSeleccionado + LineEnding +
      'Pedido anterior: ' + SerieAnt + '/' + IntToStr(NumAnt) +
        ' del ' + FormatDateTime('dd/mm/yyyy', FechaAnt) + LineEnding + LineEnding +
      'Pedido anterior:' + LineEnding +
      '  Líneas: ' + IntToStr(LineasLast) + LineEnding +
      '  Unidades: ' + FormatFloat('0.##', TotalLast) + LineEnding +
      '  Coste aprox.: ' + FormatFloat('0.00', CosteLast) + ' €' + LineEnding + LineEnding +
      'Pedido visible actual:' + LineEnding +
      '  Líneas: ' + IntToStr(LineasCur) + LineEnding +
      '  Unidades: ' + FormatFloat('0.##', TotalCur) + LineEnding +
      '  Coste aprox.: ' + FormatFloat('0.00', CosteCur) + ' €' + LineEnding + LineEnding;

    if CntNuevas > 0 then
    begin
      Resumen := Resumen + 'Líneas nuevas respecto al pedido anterior: ' + IntToStr(CntNuevas) + LineEnding + Nuevas;
      if CntNuevas > 12 then Resumen := Resumen + '  ... y ' + IntToStr(CntNuevas - 12) + ' más.' + LineEnding;
      Resumen := Resumen + LineEnding;
    end;
    if CntSuben > 0 then
    begin
      Resumen := Resumen + 'Líneas que suben mucho: ' + IntToStr(CntSuben) + LineEnding + Suben;
      if CntSuben > 12 then Resumen := Resumen + '  ... y ' + IntToStr(CntSuben - 12) + ' más.' + LineEnding;
      Resumen := Resumen + LineEnding;
    end;
    if CntBajan > 0 then
    begin
      Resumen := Resumen + 'Líneas que bajan mucho: ' + IntToStr(CntBajan) + LineEnding + Bajan;
      if CntBajan > 12 then Resumen := Resumen + '  ... y ' + IntToStr(CntBajan - 12) + ' más.' + LineEnding;
      Resumen := Resumen + LineEnding;
    end;
    if CntFaltan > 0 then
    begin
      Resumen := Resumen + 'Pedidas anteriormente y ahora no entran: ' + IntToStr(CntFaltan) + LineEnding + Faltan;
      if CntFaltan > 12 then Resumen := Resumen + '  ... y ' + IntToStr(CntFaltan - 12) + ' más.' + LineEnding;
      Resumen := Resumen + LineEnding;
    end;

    if (CntNuevas + CntSuben + CntBajan + CntFaltan) = 0 then
      Resumen := Resumen + 'No veo diferencias llamativas respecto al pedido anterior.' + LineEnding;

    Resumen := Resumen + LineEnding +
      'Esta comparativa es informativa. No se ha modificado ningún pedido ni borrador.';

    MessageDlg('Comparativa con pedido anterior', Resumen, mtInformation, [mbOK], 0);
  except
    on E: Exception do
    begin
      ProgresoFin('Error comparando con pedido anterior.');
      ShowMessage('Error comparando con el pedido anterior:' + LineEnding + E.Message + LineEnding + LineEnding +
        'No se ha modificado ningún dato.');
    end;
  end;
  Q.Free;
  CurDesc.Free;
  CurQty.Free;
  LastDesc.Free;
  LastQty.Free;
end;

function TfPedidoProveedorAuto.SiguienteNumeroPedidoReal(const Serie: string): Integer;
var
  Q: TZQuery;
  TPedic: string;
begin
  Result := 1;
  TPedic := 'pedicc' + FTienda;
  if not TablaExiste(TPedic) then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COALESCE(MAX(PC4),0)+1 AS N FROM `' + TPedic + '` WHERE PC3=:serie';
    Q.ParamByName('serie').AsString := Serie;
    Q.Open;
    Result := Q.FieldByName('N').AsInteger;
    if Result <= 0 then Result := 1;
  finally
    Q.Free;
  end;
end;

function TfPedidoProveedorAuto.LineasFinalesValidasEnGrid: Integer;
var
  R: Integer;
  Cant: Double;
begin
  Result := 0;
  if Grid = nil then Exit;
  for R := 1 to Grid.RowCount - 1 do
  begin
    if Trim(Grid.Cells[0, R]) = '' then Continue;
    Cant := FloatSeguro(Grid.Cells[8, R], 0);
    if Cant > 0 then
      Inc(Result);
  end;
end;

procedure TfPedidoProveedorAuto.CrearPedidoRealDesdeGrid;
var
  Q: TZQuery;
  CodProv: Integer;
  LineasValidas: Integer;
  Serie: string;
  NumPedido: Integer;
  FechaPed: TDateTime;
  TPedic, TPedid: string;
  TiendaNum: Integer;
  R, Lin: Integer;
  Codigo, Descripcion, FamiliaTxt: string;
  Cantidad, CosteSinIVA, IVA, CosteConIVA, PVP, PVPSinIVA: Double;
  ImporteCosteSin, ImporteCosteCon, ImportePVP: Double;
  TotalCosteSin, TotalCosteCon, TotalPVP, TotalUnidades: Double;
  MargenCoste, MargenPVP, StockInfo, VendPeriodo, VendHistorico: Double;
  Obs, Revision, Avisos, Conf, Accion, EstadoTxt, ObsLinea: string;
  Insertado: Boolean;
  CntAlta, CntMedia, CntBaja, CntSinConf, CntRevisar, CntExcluir: Integer;
  CntCoste0, CntPVP999, CntRaros, CntRoturas, CntEquiv, CntCantidadAlta: Integer;
  UltAutoSerie, UltAutoMsg: string;
  UltAutoNumero, UltAutoLineas, DiasDesdeUltimo, LimiteDias: Integer;
  UltAutoFecha: TDateTime;
begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then
  begin
    ShowMessage('Seleccione un proveedor antes de crear el pedido real.');
    Exit;
  end;

  if not HayDatosEnGrid then
  begin
    ShowMessage('No hay líneas visibles para crear un pedido.');
    Exit;
  end;

  LineasValidas := LineasFinalesValidasEnGrid;
  LogPedidoAuto('Crear pedido real solicitado. Proveedor=' + NombreProveedorSeleccionado + ' LineasValidas=' + IntToStr(LineasValidas));
  if LineasValidas <= 0 then
  begin
    ShowMessage('No hay líneas con Cantidad final mayor que 0.' + LineEnding +
      'Revise la columna Cantidad final antes de crear el pedido real.');
    Exit;
  end;

  TPedic := 'pedicc' + FTienda;
  TPedid := 'pedidd' + FTienda;
  if (not TablaExiste(TPedic)) or (not TablaExiste(TPedid)) then
  begin
    ShowMessage('No existen las tablas reales de pedidos para esta tienda:' + LineEnding +
      TPedic + LineEnding + TPedid + LineEnding + LineEnding +
      'No se ha creado ningún pedido.');
    Exit;
  end;

  // Comprobación mínima de campos esperados antes de insertar.
  if (not CampoExiste(TPedic, 'PC0')) or (not CampoExiste(TPedic, 'PC4')) or
     (not CampoExiste(TPedid, 'PD0')) or (not CampoExiste(TPedid, 'PD8')) then
  begin
    ShowMessage('La estructura de pedicc/pedidd no parece la esperada.' + LineEnding +
      'No se ha creado ningún pedido real para evitar errores.');
    Exit;
  end;

  RecalcularTodasCantidadesFinales;
  LineasValidas := LineasFinalesValidasEnGrid;
  if LineasValidas <= 0 then Exit;

  Serie := 'PED';
  NumPedido := SiguienteNumeroPedidoReal(Serie);
  FechaPed := Date;
  TiendaNum := StrToIntDef(FTienda, 0);

  // Revisión previa: se calcula antes de tocar pedicc/pedidd para que el usuario vea
  // si hay dudas, rarezas o importes anormales antes de crear el pedido real.
  TotalCosteSin := 0;
  TotalCosteCon := 0;
  TotalPVP := 0;
  TotalUnidades := 0;
  CntAlta := 0;
  CntMedia := 0;
  CntBaja := 0;
  CntSinConf := 0;
  CntRevisar := 0;
  CntExcluir := 0;
  CntCoste0 := 0;
  CntPVP999 := 0;
  CntRaros := 0;
  CntRoturas := 0;
  CntEquiv := 0;
  CntCantidadAlta := 0;

  for R := 1 to Grid.RowCount - 1 do
  begin
    Codigo := Trim(Grid.Cells[0, R]);
    Cantidad := FloatSeguro(Grid.Cells[8, R], 0);
    if (Codigo = '') or (Cantidad <= 0) then Continue;

    CosteSinIVA := FloatSeguro(Grid.Cells[13, R], 0);
    IVA := FloatSeguro(Grid.Cells[15, R], 0);
    PVP := FloatSeguro(Grid.Cells[14, R], 0);
    CosteConIVA := CosteSinIVA * (1 + (IVA / 100));
    TotalCosteSin := TotalCosteSin + (CosteSinIVA * Cantidad);
    TotalCosteCon := TotalCosteCon + (CosteConIVA * Cantidad);
    TotalPVP := TotalPVP + (PVP * Cantidad);
    TotalUnidades := TotalUnidades + Cantidad;

    Conf := UpperCase(Trim(Grid.Cells[9, R]));
    Accion := UpperCase(Trim(Grid.Cells[10, R]));
    EstadoTxt := UpperCase(Trim(Grid.Cells[18, R]));
    ObsLinea := UpperCase(Trim(Grid.Cells[19, R]));

    if Conf = 'ALTA' then Inc(CntAlta)
    else if Conf = 'MEDIA' then Inc(CntMedia)
    else if Conf = 'BAJA' then Inc(CntBaja)
    else Inc(CntSinConf);

    if Pos('REVISAR', Accion) > 0 then Inc(CntRevisar);
    if Pos('EXCLUIR', Accion) > 0 then Inc(CntExcluir);
    if CosteSinIVA <= 0 then Inc(CntCoste0);
    if PVP >= 999 then Inc(CntPVP999);
    if (CosteSinIVA <= 0) or (PVP >= 999) then Inc(CntRaros);
    if (Pos('ROTURA', EstadoTxt) > 0) or (Pos('ROTURA', ObsLinea) > 0) then Inc(CntRoturas);
    if (Pos('EQUIVAL', EstadoTxt) > 0) or (Pos('EQUIVAL', ObsLinea) > 0) or
       (Pos('DUPLIC', EstadoTxt) > 0) or (Pos('DUPLIC', ObsLinea) > 0) then Inc(CntEquiv);
    if Cantidad >= 50 then Inc(CntCantidadAlta);
  end;

  Revision :=
    'Se va a crear un pedido REAL en FacturLinEx.' + LineEnding + LineEnding +
    'Proveedor: ' + NombreProveedorSeleccionado + LineEnding +
    'Serie/Número: ' + Serie + '/' + IntToStr(NumPedido) + LineEnding +
    'Líneas con Cantidad final > 0: ' + IntToStr(LineasValidas) + LineEnding +
    'Unidades totales aproximadas: ' + FormatFloat('0.##', TotalUnidades) + LineEnding +
    'Coste sin IVA aproximado: ' + FormatFloat('0.00', TotalCosteSin) + ' €' + LineEnding +
    'Coste con IVA aproximado: ' + FormatFloat('0.00', TotalCosteCon) + ' €' + LineEnding +
    'PVP venta aproximado: ' + FormatFloat('0.00', TotalPVP) + ' €' + LineEnding + LineEnding +
    'Confianza:' + LineEnding +
    '  Alta: ' + IntToStr(CntAlta) + LineEnding +
    '  Media: ' + IntToStr(CntMedia) + LineEnding +
    '  Baja: ' + IntToStr(CntBaja) + LineEnding;
  if CntSinConf > 0 then
    Revision := Revision + '  Sin clasificar: ' + IntToStr(CntSinConf) + LineEnding;

  Avisos := '';

  if UltimoPedidoAutoCreadoProveedor(UltAutoSerie, UltAutoNumero, UltAutoFecha, UltAutoLineas) then
  begin
    DiasDesdeUltimo := DaysBetween(Date, DateOf(UltAutoFecha));
    LimiteDias := seDiasCubrir.Value + seDiasEntrega.Value;
    if LimiteDias < 1 then
      LimiteDias := 1;

    if DiasDesdeUltimo <= LimiteDias then
    begin
      UltAutoMsg :=
        'Ya consta un pedido real creado desde este módulo para este proveedor:' + LineEnding + LineEnding +
        'Pedido anterior automático: ' + UltAutoSerie + '/' + IntToStr(UltAutoNumero) + LineEnding +
        'Fecha creación: ' + FormatDateTime('dd/mm/yyyy hh:nn', UltAutoFecha) + LineEnding +
        'Líneas: ' + IntToStr(UltAutoLineas) + LineEnding +
        'Hace: ' + IntToStr(DiasDesdeUltimo) + ' días' + LineEnding +
        'Cobertura configurada: ' + IntToStr(LimiteDias) + ' días' + LineEnding + LineEnding +
        'Si continúa, podría estar duplicando un pedido reciente.' + LineEnding +
        '¿Está seguro de que quiere seguir?';

      if MessageDlg('Posible pedido duplicado', UltAutoMsg, mtWarning,
        [mbYes, mbNo], 0) <> mrYes then
        Exit;

      Avisos := Avisos + '- POSIBLE DUPLICADO: ya existe un pedido automático reciente ' +
        UltAutoSerie + '/' + IntToStr(UltAutoNumero) + ' del ' +
        FormatDateTime('dd/mm/yyyy hh:nn', UltAutoFecha) + '.' + LineEnding;
    end;
  end;

  if CntRevisar > 0 then
    Avisos := Avisos + '- ' + IntToStr(CntRevisar) + ' líneas marcadas como revisar.' + LineEnding;
  if CntExcluir > 0 then
    Avisos := Avisos + '- ' + IntToStr(CntExcluir) + ' líneas tienen decisión EXCLUIR y aun así cantidad final > 0.' + LineEnding;
  if CntCoste0 > 0 then
    Avisos := Avisos + '- ' + IntToStr(CntCoste0) + ' líneas con coste 0.' + LineEnding;
  if CntPVP999 > 0 then
    Avisos := Avisos + '- ' + IntToStr(CntPVP999) + ' líneas con PVP 999 o superior.' + LineEnding;
  if CntRoturas > 0 then
    Avisos := Avisos + '- ' + IntToStr(CntRoturas) + ' líneas parecen roturas de stock.' + LineEnding;
  if CntEquiv > 0 then
    Avisos := Avisos + '- ' + IntToStr(CntEquiv) + ' líneas con equivalencias/posibles duplicados.' + LineEnding;
  if CntCantidadAlta > 0 then
    Avisos := Avisos + '- ' + IntToStr(CntCantidadAlta) + ' líneas con cantidad final igual o superior a 50.' + LineEnding;
  if CntMedia + CntBaja + CntSinConf > 0 then
    Avisos := Avisos + '- Hay líneas que no son de confianza ALTA. Conviene revisar antes de confirmar.' + LineEnding;
  if CntRaros > 0 then
    Avisos := Avisos + '- Hay líneas raras por coste/PVP. Revisa si deben entrar al pedido real.' + LineEnding;

  if Avisos <> '' then
    Revision := Revision + LineEnding + 'Avisos antes de crear:' + LineEnding + Avisos;

  Revision := Revision + LineEnding +
    'Solo se insertarán las líneas VISIBLES con Cantidad final mayor que 0.' + LineEnding +
    '¿Continuar y crear el pedido real?';

  if MessageDlg('Revisión previa del pedido real', Revision,
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  LogPedidoAuto('Creando pedido real ' + Serie + '/' + IntToStr(NumPedido) + ' proveedor=' + NombreProveedorSeleccionado + ' lineas=' + IntToStr(LineasValidas));
  ProgresoInicio('Creando pedido real...', LineasValidas + 2);
  Q := TZQuery.Create(nil);
  Insertado := False;
  try
    Q.Connection := FConn;

    Obs := 'Pedido generado desde Pedido automático por proveedor el ' +
      FormatDateTime('dd/mm/yyyy hh:nn', Now) + '. Revise antes de enviar/recibir.';

    // Insertamos cabecera con la estructura estándar PC0..PC32.
    Q.SQL.Text :=
      'INSERT INTO `' + TPedic + '` (' +
      'PC0,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20,PC21,PC22,PC23,PC24,PC25,PC26,PC27,PC28,PC29,PC30,PC31,PC32) VALUES (' +
      ':PC0,:PC1,:PC2,:PC3,:PC4,:PC5,:PC6,:PC7,:PC8,:PC9,:PC10,:PC11,:PC12,:PC13,:PC14,:PC15,:PC16,:PC17,:PC18,:PC19,:PC20,:PC21,:PC22,:PC23,:PC24,:PC25,:PC26,:PC27,:PC28,:PC29,:PC30,:PC31,:PC32)';
    Q.ParamByName('PC0').AsInteger := TiendaNum;
    Q.ParamByName('PC1').AsDateTime := FechaPed;
    Q.ParamByName('PC2').AsInteger := CodProv;
    Q.ParamByName('PC3').AsString := Serie;
    Q.ParamByName('PC4').AsInteger := NumPedido;
    Q.ParamByName('PC5').AsInteger := LineasValidas;
    Q.ParamByName('PC6').AsInteger := Round(TotalUnidades);
    Q.ParamByName('PC7').AsFloat := TotalCosteSin;
    Q.ParamByName('PC8').AsFloat := TotalCosteCon;
    Q.ParamByName('PC9').AsFloat := TotalPVP;
    Q.ParamByName('PC10').AsString := 'N';
    Q.ParamByName('PC11').AsString := 'P';
    Q.ParamByName('PC12').AsString := '';
    Q.ParamByName('PC13').AsString := Copy(NombreProveedorSeleccionado, 1, 50);
    Q.ParamByName('PC14').AsInteger := 0;
    Q.ParamByName('PC15').AsString := '';
    Q.ParamByName('PC16').AsString := '';
    Q.ParamByName('PC17').AsFloat := TotalCosteCon;
    Q.ParamByName('PC18').AsFloat := 0;
    Q.ParamByName('PC19').AsFloat := TotalCosteCon;
    Q.ParamByName('PC20').Clear;
    Q.ParamByName('PC21').AsFloat := 0;
    Q.ParamByName('PC22').Clear;
    Q.ParamByName('PC23').AsFloat := 0;
    Q.ParamByName('PC24').Clear;
    Q.ParamByName('PC25').AsFloat := 0;
    Q.ParamByName('PC26').Clear;
    Q.ParamByName('PC27').AsFloat := 0;
    Q.ParamByName('PC28').AsString := 'P';
    Q.ParamByName('PC29').AsString := '';
    Q.ParamByName('PC30').Clear;
    Q.ParamByName('PC31').AsString := Obs;
    Q.ParamByName('PC32').AsInteger := 0;
    Q.ExecSQL;
    Insertado := True;
    ProgresoPaso('Cabecera creada. Insertando líneas...', 1, LineasValidas + 2);

    Q.SQL.Text :=
      'INSERT INTO `' + TPedid + '` (' +
      'PD0,PD1,PD2,PD3,PD4,PD5,PD6,PD7,PD8,PD9,PD10,PD11,PD12,PD13,PD14,PD15,PD16,PD17,PD18,PD19,PD20,PD21,PD22,PD23,PD24,PD25,PD26,PD27,PD28,PD29,PD30) VALUES (' +
      ':PD0,:PD1,:PD2,:PD3,:PD4,:PD5,:PD6,:PD7,:PD8,:PD9,:PD10,:PD11,:PD12,:PD13,:PD14,:PD15,:PD16,:PD17,:PD18,:PD19,:PD20,:PD21,:PD22,:PD23,:PD24,:PD25,:PD26,:PD27,:PD28,:PD29,:PD30)';

    Lin := 0;
    for R := 1 to Grid.RowCount - 1 do
    begin
      Codigo := Trim(Grid.Cells[0, R]);
      Cantidad := FloatSeguro(Grid.Cells[8, R], 0);
      if (Codigo = '') or (Cantidad <= 0) then Continue;
      Inc(Lin);

      Descripcion := Copy(Grid.Cells[1, R], 1, 50);
      VendPeriodo := FloatSeguro(Grid.Cells[2, R], 0);
      VendHistorico := FloatSeguro(Grid.Cells[4, R], 0);
      CosteSinIVA := FloatSeguro(Grid.Cells[13, R], 0);
      PVP := FloatSeguro(Grid.Cells[14, R], 0);
      IVA := FloatSeguro(Grid.Cells[15, R], 0);
      StockInfo := FloatSeguro(Grid.Cells[16, R], 0);
      FamiliaTxt := Grid.Cells[17, R];
      CosteConIVA := CosteSinIVA * (1 + (IVA / 100));
      if IVA > -99 then
        PVPSinIVA := PVP / (1 + (IVA / 100))
      else
        PVPSinIVA := PVP;
      ImporteCosteSin := CosteSinIVA * Cantidad;
      ImporteCosteCon := CosteConIVA * Cantidad;
      ImportePVP := PVP * Cantidad;
      if CosteSinIVA > 0 then
        MargenCoste := ((PVPSinIVA - CosteSinIVA) / CosteSinIVA) * 100
      else
        MargenCoste := 0;
      if PVP > 0 then
        MargenPVP := ((PVP - CosteConIVA) / PVP) * 100
      else
        MargenPVP := 0;

      ProgresoPaso('Insertando línea real ' + IntToStr(Lin) + ' de ' + IntToStr(LineasValidas), Lin + 1, LineasValidas + 2);
      Q.ParamByName('PD0').AsInteger := TiendaNum;
      Q.ParamByName('PD1').AsDateTime := FechaPed;
      Q.ParamByName('PD2').AsInteger := CodProv;
      Q.ParamByName('PD3').AsString := Serie;
      Q.ParamByName('PD4').AsInteger := NumPedido;
      Q.ParamByName('PD5').AsInteger := Lin;
      Q.ParamByName('PD6').AsString := Copy(Codigo, 1, 13);
      Q.ParamByName('PD7').AsString := Descripcion;
      Q.ParamByName('PD8').AsFloat := Cantidad;
      Q.ParamByName('PD9').AsFloat := 0;
      Q.ParamByName('PD10').AsFloat := CosteSinIVA;
      Q.ParamByName('PD11').AsFloat := MargenCoste;
      Q.ParamByName('PD12').AsFloat := PVPSinIVA;
      Q.ParamByName('PD13').AsFloat := 0;
      Q.ParamByName('PD14').AsFloat := IVA;
      Q.ParamByName('PD15').AsFloat := CosteConIVA;
      Q.ParamByName('PD16').AsFloat := PVP;
      Q.ParamByName('PD17').AsFloat := ImporteCosteCon;
      Q.ParamByName('PD18').AsFloat := ImportePVP;
      Q.ParamByName('PD19').AsInteger := StrToIntDef(Trim(FamiliaTxt), 0);
      Q.ParamByName('PD20').AsFloat := StockInfo;
      Q.ParamByName('PD21').AsFloat := VendPeriodo;
      Q.ParamByName('PD22').AsFloat := VendHistorico;
      Q.ParamByName('PD23').AsString := 'N';
      Q.ParamByName('PD24').AsString := '';
      Q.ParamByName('PD25').AsString := '';
      Q.ParamByName('PD26').AsFloat := 0;
      Q.ParamByName('PD27').AsFloat := 0;
      Q.ParamByName('PD28').AsFloat := 0;
      Q.ParamByName('PD29').AsFloat := 0;
      Q.ParamByName('PD30').AsFloat := MargenPVP;
      Q.ExecSQL;
    end;

    RegistrarPedidoAutoCreado(CodProv, Serie, NumPedido, LineasValidas,
      TotalUnidades, TotalCosteSin, TotalCosteCon, TotalPVP,
      'Pedido real creado desde listado visible de pedido automático');

    LogPedidoAuto('Pedido real creado correctamente ' + Serie + '/' + IntToStr(NumPedido) + ' lineas=' + IntToStr(LineasValidas) + ' unidades=' + FormatFloat('0.##', TotalUnidades) + ' coste=' + FormatFloat('0.00', TotalCosteCon));
    ProgresoFin('Pedido real creado: ' + Serie + '/' + IntToStr(NumPedido) +
      ' - ' + IntToStr(LineasValidas) + ' líneas.');
    ShowMessage('Pedido real creado correctamente.' + LineEnding + LineEnding +
      'Proveedor: ' + NombreProveedorSeleccionado + LineEnding +
      'Pedido: ' + Serie + '/' + IntToStr(NumPedido) + LineEnding +
      'Líneas: ' + IntToStr(LineasValidas));

  except
    on E: Exception do
    begin
      ProgresoFin('Error creando pedido real.');
      LogErrorPedidoAuto('CrearPedidoRealDesdeGrid', E);
      if Insertado then
      begin
        try
          Q.SQL.Text := 'DELETE FROM `' + TPedid + '` WHERE PD2=:prov AND PD3=:serie AND PD4=:num';
          Q.ParamByName('prov').AsInteger := CodProv;
          Q.ParamByName('serie').AsString := Serie;
          Q.ParamByName('num').AsInteger := NumPedido;
          Q.ExecSQL;
          Q.SQL.Text := 'DELETE FROM `' + TPedic + '` WHERE PC2=:prov AND PC3=:serie AND PC4=:num';
          Q.ParamByName('prov').AsInteger := CodProv;
          Q.ParamByName('serie').AsString := Serie;
          Q.ParamByName('num').AsInteger := NumPedido;
          Q.ExecSQL;
          LogPedidoAuto('Limpieza automática ejecutada tras error creando pedido ' + Serie + '/' + IntToStr(NumPedido));
        except
          // Si también falla la limpieza, se informa abajo con el error principal.
        end;
      end;
      ShowMessage('Error creando pedido real:' + LineEnding + E.Message + LineEnding + LineEnding +
        'Si se llegó a insertar algo, se ha intentado limpiar automáticamente la cabecera y líneas del pedido ' +
        Serie + '/' + IntToStr(NumPedido) + '.');
    end;
  end;
  Q.Free;
end;

procedure TfPedidoProveedorAuto.AutoAjustarColumnas;
begin
  if Grid.ColCount < 20 then Exit;

  Grid.ColWidths[0] := 90;
  Grid.ColWidths[1] := 245;
  Grid.ColWidths[2] := 95;
  Grid.ColWidths[3] := 95;
  Grid.ColWidths[4] := 105;
  Grid.ColWidths[5] := 95;
  Grid.ColWidths[6] := 80;
  Grid.ColWidths[7] := 90;
  Grid.ColWidths[8] := 90;
  Grid.ColWidths[9] := 80;
  Grid.ColWidths[10] := 95;
  Grid.ColWidths[11] := 85;
  Grid.ColWidths[12] := 85;
  Grid.ColWidths[13] := 70;
  Grid.ColWidths[14] := 70;
  Grid.ColWidths[15] := 55;
  Grid.ColWidths[16] := 75;
  Grid.ColWidths[17] := 60;
  Grid.ColWidths[18] := 150;
  Grid.ColWidths[19] := 430;
end;

end.
