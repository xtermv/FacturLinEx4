unit uPedidoProveedorAuto;

{$mode objfpc}{$H+}
{$codepage utf8}

{
  FacturLinEx - Propuesta automatica de pedido por proveedor
  Version: 2026-06-26-v2.10.1-BORRADOR-COMPLETO-FIX-COMPILA

  OBJETIVO
  --------
  Generar una PROPUESTA revisable de pedido a proveedor usando ventas reales
  e historial de compras a ese proveedor, sin fiarse del stock actual.

  Hasta v2.2 no creaba pedido real en pedicc/pedidd.
  Desde v2.3 permite crear pedido real SOLO con confirmacion previa y usando las lineas visibles con Cantidad final > 0.

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
  - Recoloca el boton Cerrar arriba a la derecha, separado de botones operativos.
  - Anade Crear pedido real desde las lineas visibles con Cantidad final > 0.
  - Crea cabecera en pediccXXXX y lineas en pediddXXXX con confirmacion previa.
  - Si falla durante la insercion, intenta limpiar la cabecera/lineas creadas.

  v2.3.1:
  - Corrige la posicion de Cerrar: ahora va en una barra inferior separada,
    alineado a la derecha y siempre visible, sin depender del ancho inicial del formulario.

  v2.3.2:
  - Corrige de forma definitiva Cerrar: vuelve al panel superior, fijo y visible.

  v2.4:
  - Antes de crear el pedido real muestra una revision previa con importe aproximado,
    unidades, confianza de lineas y avisos de coste 0, PVP 999, dudas, roturas/equivalencias.
  - No anade botones nuevos para no alterar la pantalla ya validada.

  v2.5:
  - Anade Comparar ant. para comparar el listado visible contra el ultimo pedido real
    de ese proveedor en pedicc/pedidd.
  - Muestra lineas nuevas, lineas que suben/bajan mucho y articulos pedidos antes
    que ahora no entran. No modifica datos.

  v2.6:
  - Anade Ver riesgos para filtrar en pantalla las lineas que conviene revisar antes
    de crear el pedido real: confianza no alta, revisar/excluir, coste 0, PVP 999,
    roturas, equivalencias/duplicados y cantidades finales altas.
  - No modifica datos; solo cambia la vista visible del grid.

  v2.7:
  - Anade historial anti-duplicado en pedido_auto_creados.
  - Registra los pedidos reales creados desde este modulo y avisa si se intenta
    crear otro pedido automatico reciente del mismo proveedor.

  v2.8:
  - Anade boton Hist. auto para consultar desde la propia pantalla los ultimos
    pedidos reales creados desde este modulo para el proveedor seleccionado.


  v2.9:
  - Anade log en fichero para poder diagnosticar fallos en produccion.
  - Registra apertura/cierre del modulo, procesos largos, creacion/verificacion de tablas,
    generacion de PDF, impresion, borradores, creacion de pedido real y errores capturados.
  - Log diario en ~/.local/share/facturlinex/logs/pedido_auto_YYYYMMDD.log.
  - Se mantiene la distribucion validada de botones, especialmente Cerrar.

  v2.10:
  - Corrige Guardar borrador en modo Auto proveedor: ahora guarda el estudio completo,
    no solo la vista visible. Conserva lineas AUTO, DUDAS/REVISAR y EXCLUIDOS/RIESGOS.
  - Al cargar el borrador reconstruye las listas internas para poder usar Ver auto,
    Ver dudas, Ver riesgos y Ver excluidos sin recalcular.
  - Conserva Stock contado y Cantidad final editados en la vista visible antes de guardar.

  v2.11.2:
  - Anade filtro de seguridad para pocas ventas: por defecto, articulos con venta reciente
    positiva pero inferior al umbral pasan a REVISAR, no entran al pedido automatico.
  - Anade vista Compra segura para ver solo lineas ALTA sin riesgos basicos.
  - Corrige Ult. venta para que sea ultima venta real positiva dentro del periodo/grupo,
    no solo la fecha maxima de cualquier movimiento del articulo.

  v2.12:
  - Anade modo Repos. pedidos: calcula reposicion solo sobre articulos presentes
    en los ultimos N pedidos historicos del proveedor (hipedicc/hipedidd).
  - Anade Anadir linea y Quitar linea manual. Las lineas manuales entran como
    confianza ALTA, accion MANUAL, se guardan en borrador y entran al pedido real
    si tienen Cantidad final mayor que 0.

  v2.13:
  - Anade selector Pedidos hist. para que Repos. pedidos use N pedidos historicos
    del proveedor (por defecto 4).
  - El checkbox Ref. compras pedidos usa esos mismos N pedidos como referencia
    de seguridad.
  - Calcula comprado total NP, media por pedido, maximo y ultima compra en uds.
  - La venta sigue mandando, pero las compras historicas pueden subir confianza
    si son coherentes o mandar a revisar si la propuesta se dispara o se queda
    muy lejos de lo comprado habitualmente.

  Integracion esperada:
    uses uPedidoProveedorAuto;

    MostrarPedidoProveedorAuto(Self, TuConexionZConnection, Tienda);

  Donde Tienda suele ser '0000', '0001', etc. segun FacturLinEx.
}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  Grids, Spin, DateUtils, Math, DB, Types, Printers, LConvEncoding, LCLIntf, LCLType, LazUTF8,
  Process, ZConnection, ZDataset;

type

  TLineaPedidoAuto = record
    Codigo: string;
    Descripcion: string;
    VendidoPeriodo: Double;
    VendidoHistorico: Double;
    VendidoTendencia: Double;
    VendidoCobertura: Double; // unidades vendidas en los dias reales a cubrir (pedido + entrega)
    VentaDia: Double;
    Sugerido: Double;
    StockContado: Double;
    CantidadFinal: Double;
    UltVenta: string;
    UltCompra: string;
    CompradoUlt4: Double;
    MediaUlt4: Double;
    MaxUlt4: Double;
    UltCompraUds: Double;
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
    FUsarReposicionUlt4: Boolean;
    FUsarReposicionReal: Boolean;
    FSuppressSelToggle: Boolean;

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
    chkPocasVentasARevisar: TCheckBox;
    chkUsarComprasUlt4Ref: TCheckBox;
    lblNumPedidosHist: TLabel;
    seNumPedidosHist: TSpinEdit;
    seUmbralPocasVentas: TSpinEdit;
    chkAbrirPDF: TCheckBox;
    lblPerfilAuto: TLabel;
    cbPerfilAuto: TComboBox;
    lblDiasEntrega: TLabel;
    seDiasEntrega: TSpinEdit;

    btnCalcular: TButton;
    btnPedidoDepurado: TButton;
    btnPedidoAuto: TButton;
    btnReposicionUlt4: TButton;
    btnReposicionReal: TButton;
    btnVerAuto: TButton;
    btnVerCompraSegura: TButton;
    btnVerRiesgos: TButton;
    btnVerRevisar: TButton;
    btnVerExcluidos: TButton;
    btnGuardarPerfil: TButton;
    btnCargarPerfil: TButton;
    btnAceptarSiempre: TButton;
    btnRevisarSiempre: TButton;
    btnExcluirSiempre: TButton;
    btnQuitarDecision: TButton;
    btnAnadirManual: TButton;
    btnQuitarManual: TButton;
    btnVerSimilares: TButton;
    btnQuitarAhora: TButton;
    btnQuitarMarcadas: TButton;
    btnRevisarMarcadas: TButton;
    btnExcluirMarcadas: TButton;
    btnVerQuitadas: TButton;
    btnDesmarcarTodas: TButton;
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
    procedure BtnReposicionUlt4Click(Sender: TObject);
    procedure BtnReposicionRealClick(Sender: TObject);
    procedure BtnVerAutoClick(Sender: TObject);
    procedure BtnVerCompraSeguraClick(Sender: TObject);
    procedure BtnVerRiesgosClick(Sender: TObject);
    procedure BtnVerRevisarClick(Sender: TObject);
    procedure BtnVerExcluidosClick(Sender: TObject);
    procedure BtnGuardarPerfilClick(Sender: TObject);
    procedure BtnCargarPerfilClick(Sender: TObject);
    procedure BtnAceptarSiempreClick(Sender: TObject);
    procedure BtnRevisarSiempreClick(Sender: TObject);
    procedure BtnExcluirSiempreClick(Sender: TObject);
    procedure BtnQuitarDecisionClick(Sender: TObject);
    procedure BtnAnadirManualClick(Sender: TObject);
    procedure BtnQuitarManualClick(Sender: TObject);
    procedure BtnVerSimilaresClick(Sender: TObject);
    procedure BtnQuitarAhoraClick(Sender: TObject);
    procedure BtnQuitarMarcadasClick(Sender: TObject);
    procedure BtnRevisarMarcadasClick(Sender: TObject);
    procedure BtnExcluirMarcadasClick(Sender: TObject);
    procedure BtnVerQuitadasClick(Sender: TObject);
    procedure BtnDesmarcarTodasClick(Sender: TObject);
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
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
    function LineaAutoQuitada(const L: TLineaPedidoAuto): Boolean;
    procedure MostrarSoloLineasRiesgo;
    procedure MostrarCompraSegura;
    procedure SincronizarListasAutoDesdeGrid;
    function FilaTieneRiesgo(const ARow: Integer): Boolean;
    procedure AplicarDeteccionDuplicados(var Lineas: TArrayLineaPedidoAuto);
    procedure RecalcularCantidadFinalFila(const ARow: Integer);
    procedure RecalcularTodasCantidadesFinales;
    procedure OrdenarPorPrioridad(var Lineas: TArrayLineaPedidoAuto);
    procedure PintarLineasEnGrid(const Lineas: TArrayLineaPedidoAuto; const Limite: Integer);
    procedure AnadirLineaManualAlGrid(const L: TLineaPedidoAuto);
    procedure QuitarLineaManualSeleccionada;
    procedure EliminarManualDeListas(const Codigo: string);
    function ColSel: Integer;
    function FilaMarcada(const ARow: Integer): Boolean;
    procedure MarcarFila(const ARow: Integer; const AMarcada: Boolean);
    procedure DesmarcarTodasLasLineas;
    function ContarMarcadas: Integer;
    function HayMarcadas: Boolean;
    procedure AplicarAccionMarcadas(const AAccion: string);
    procedure MostrarLineasQuitadas;
    procedure MostrarSimilaresVisibles;

    function CodigoProveedorSeleccionado: Integer;
    function NombreProveedorSeleccionado: string;
    function SufijoTiendaSeguro(const S: string): string;
    function TablaExiste(const NombreTabla: string): Boolean;
    function CampoExiste(const NombreTabla, NombreCampo: string): Boolean;
    function SQLComprasProveedor(const CodProveedor: Integer): string;
    function SQLComprasProveedorUltimos4(const CodProveedor: Integer): string;
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
    function NormalizarTextoSimilar(const S: string): string;
    function ClaveDescripcionSimilar(const S: string): string;
    function CantidadDescripcionSimilar(const S: string): Double;
    function CantidadesCompatibles(const A, B: Double): Boolean;
    function ValorFechaTexto(const S: string): TDateTime;
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
  FUsarReposicionUlt4 := False;
  FUsarReposicionReal := False;
  FSuppressSelToggle := False;
  VaciarListasAuto;
  LogPedidoAuto('Apertura modulo pedido automatico v2.14.5. Tienda=' + FTienda);

  Caption := 'Propuesta de pedido por proveedor - v2.14.5 quitar oculta e indice numerico';
  Position := poScreenCenter;
  Width := 1250;
  Height := 720;
  WindowState := wsMaximized;
  KeyPreview := True;
  OnKeyDown := @FormKeyDown;

  ConstruirInterfaz;
  InicializarGrid;
  CbPerfilAutoChange(nil);
  CrearTablasPedidoAuto;
  CargarProveedores;
end;

destructor TfPedidoProveedorAuto.Destroy;
begin
  LogPedidoAuto('Cierre modulo pedido automatico.');
  FreeAndNil(FListaProveedores);
  inherited Destroy;
end;

procedure TfPedidoProveedorAuto.ConstruirInterfaz;
var
  pnlCabecera, pnlProveedor, pnlBusca, pnlProveedorCentro, pnlProveedorAcciones: TPanel;
  pnlParametros: TPanel;
  gbAnalisis, gbReglas: TGroupBox;
  pcAcciones: TPageControl;
  tsCalculo, tsRevision, tsEquivalencias, tsSalida: TTabSheet;
  pnlEstado, pnlGridCab: TPanel;
  lblTitulo, lblSubtitulo, lblGridTitulo, lblGridAyuda: TLabel;

  function NuevoBoton(AParent: TWinControl; ALeft, ATop, AWidth: Integer;
    const ACaption, AHint: string; AClick: TNotifyEvent): TButton;
  begin
    Result := TButton.Create(Self);
    Result.Parent := AParent;
    Result.SetBounds(ALeft, ATop, AWidth, 30);
    Result.Caption := ACaption;
    Result.Hint := AHint;
    Result.ShowHint := Trim(AHint) <> '';
    Result.OnClick := AClick;
  end;

  procedure EstiloBotonPrincipal(B: TButton);
  begin
    if not Assigned(B) then Exit;
    B.Font.Style := [fsBold];
    B.Height := 34;
  end;

begin
  Color := $00F3F5F7;
  BorderStyle := bsSizeable;

  PanelTop := TPanel.Create(Self);
  PanelTop.Parent := Self;
  PanelTop.Align := alTop;
  PanelTop.Height := 500;
  PanelTop.BevelOuter := bvNone;
  PanelTop.Color := $00F3F5F7;

  { CABECERA }
  pnlCabecera := TPanel.Create(Self);
  pnlCabecera.Parent := PanelTop;
  pnlCabecera.Align := alTop;
  pnlCabecera.Height := 66;
  pnlCabecera.BevelOuter := bvNone;
  pnlCabecera.Color := clNavy;

  lblTitulo := TLabel.Create(Self);
  lblTitulo.Parent := pnlCabecera;
  lblTitulo.Left := 18;
  lblTitulo.Top := 10;
  lblTitulo.Caption := 'PEDIDO AUTOMATICO POR PROVEEDOR';
  lblTitulo.Font.Height := -20;
  lblTitulo.Font.Style := [fsBold];
  lblTitulo.Font.Color := clWhite;
  lblTitulo.ParentFont := False;

  lblSubtitulo := TLabel.Create(Self);
  lblSubtitulo.Parent := pnlCabecera;
  lblSubtitulo.Left := 20;
  lblSubtitulo.Top := 38;
  lblSubtitulo.Caption := 'Analisis de ventas, reposicion, revision y creacion del pedido desde una unica pantalla.';
  lblSubtitulo.Font.Height := -12;
  lblSubtitulo.Font.Color := clSilver;
  lblSubtitulo.ParentFont := False;

  btnCerrar := NuevoBoton(pnlCabecera, 0, 16, 110, 'Cerrar',
    'Cerrar esta ventana', @BtnCerrarClick);
  btnCerrar.Left := pnlCabecera.ClientWidth - 122;
  btnCerrar.Top := 16;
  btnCerrar.Anchors := [akTop, akRight];
  btnCerrar.Font.Style := [fsBold];

  { PROVEEDOR Y PERFIL }
  pnlProveedor := TPanel.Create(Self);
  pnlProveedor.Parent := PanelTop;
  pnlProveedor.Align := alTop;
  pnlProveedor.Height := 72;
  pnlProveedor.BevelOuter := bvNone;
  pnlProveedor.Color := clWhite;

  pnlBusca := TPanel.Create(Self);
  pnlBusca.Parent := pnlProveedor;
  pnlBusca.Align := alLeft;
  pnlBusca.Width := 410;
  pnlBusca.BevelOuter := bvNone;
  pnlBusca.ParentColor := True;

  lblBuscarProveedor := TLabel.Create(Self);
  lblBuscarProveedor.Parent := pnlBusca;
  lblBuscarProveedor.Left := 14;
  lblBuscarProveedor.Top := 9;
  lblBuscarProveedor.Caption := 'BUSCAR PROVEEDOR';
  lblBuscarProveedor.Font.Style := [fsBold];

  edtBuscarProveedor := TEdit.Create(Self);
  edtBuscarProveedor.Parent := pnlBusca;
  edtBuscarProveedor.SetBounds(14, 32, 300, 29);
  edtBuscarProveedor.Hint := 'Escriba codigo o nombre del proveedor';
  edtBuscarProveedor.ShowHint := True;
  edtBuscarProveedor.OnChange := @EdtBuscarProveedorChange;

  btnLimpiarProveedor := NuevoBoton(pnlBusca, 322, 31, 76, 'Todos',
    'Mostrar todos los proveedores', @BtnLimpiarProveedorClick);

  pnlProveedorAcciones := TPanel.Create(Self);
  pnlProveedorAcciones.Parent := pnlProveedor;
  pnlProveedorAcciones.Align := alRight;
  pnlProveedorAcciones.Width := 390;
  pnlProveedorAcciones.BevelOuter := bvNone;
  pnlProveedorAcciones.ParentColor := True;

  lblPerfilAuto := TLabel.Create(Self);
  lblPerfilAuto.Parent := pnlProveedorAcciones;
  lblPerfilAuto.Left := 8;
  lblPerfilAuto.Top := 9;
  lblPerfilAuto.Caption := 'PERFIL DE CALCULO';
  lblPerfilAuto.Font.Style := [fsBold];

  cbPerfilAuto := TComboBox.Create(Self);
  cbPerfilAuto.Parent := pnlProveedorAcciones;
  cbPerfilAuto.SetBounds(8, 32, 125, 29);
  cbPerfilAuto.Style := csDropDownList;
  cbPerfilAuto.Items.Add('Semanal');
  cbPerfilAuto.Items.Add('Quincenal');
  cbPerfilAuto.Items.Add('Manual');
  cbPerfilAuto.ItemIndex := 0;
  cbPerfilAuto.Hint := 'Aplica parametros razonables para los dos proveedores principales. Manual no toca los parametros actuales.';
  cbPerfilAuto.ShowHint := True;
  cbPerfilAuto.OnChange := @CbPerfilAutoChange;

  btnGuardarPerfil := NuevoBoton(pnlProveedorAcciones, 143, 31, 115, 'Guardar perfil',
    'Guarda los parametros actuales para este proveedor y tienda', @BtnGuardarPerfilClick);
  btnCargarPerfil := NuevoBoton(pnlProveedorAcciones, 268, 31, 110, 'Cargar perfil',
    'Carga el perfil guardado para este proveedor', @BtnCargarPerfilClick);

  pnlProveedorCentro := TPanel.Create(Self);
  pnlProveedorCentro.Parent := pnlProveedor;
  pnlProveedorCentro.Align := alClient;
  pnlProveedorCentro.BevelOuter := bvNone;
  pnlProveedorCentro.ParentColor := True;

  lblProveedor := TLabel.Create(Self);
  lblProveedor.Parent := pnlProveedorCentro;
  lblProveedor.Left := 12;
  lblProveedor.Top := 9;
  lblProveedor.Caption := 'PROVEEDOR SELECCIONADO';
  lblProveedor.Font.Style := [fsBold];

  cbProveedor := TComboBox.Create(Self);
  cbProveedor.Parent := pnlProveedorCentro;
  cbProveedor.Left := 12;
  cbProveedor.Top := 32;
  cbProveedor.Width := pnlProveedorCentro.ClientWidth - 24;
  if cbProveedor.Width < 180 then cbProveedor.Width := 180;
  cbProveedor.Anchors := [akLeft, akTop, akRight];
  cbProveedor.Style := csDropDownList;
  cbProveedor.OnChange := @CbProveedorChange;

  { PARAMETROS }
  pnlParametros := TPanel.Create(Self);
  pnlParametros.Parent := PanelTop;
  pnlParametros.Align := alTop;
  pnlParametros.Height := 190;
  pnlParametros.BevelOuter := bvNone;
  pnlParametros.Color := $00F3F5F7;

  gbAnalisis := TGroupBox.Create(Self);
  gbAnalisis.Parent := pnlParametros;
  gbAnalisis.Align := alTop;
  gbAnalisis.Height := 92;
  gbAnalisis.Caption := '  ANALISIS Y COBERTURA  ';
  gbAnalisis.Font.Style := [];
  gbAnalisis.ParentFont := False;
  gbAnalisis.Font.Height := -13;

  lblDiasCubrir := TLabel.Create(Self);
  lblDiasCubrir.Parent := gbAnalisis;
  lblDiasCubrir.SetBounds(18, 24, 95, 18);
  lblDiasCubrir.Caption := 'Dias a cubrir';
  lblDiasCubrir.Hint := 'Dias que quieres cubrir con el pedido. No se usa para contar ventas.';
  lblDiasCubrir.ShowHint := True;
  seDiasCubrir := TSpinEdit.Create(Self);
  seDiasCubrir.Parent := gbAnalisis;
  seDiasCubrir.SetBounds(18, 48, 78, 28);
  seDiasCubrir.MinValue := 1; seDiasCubrir.MaxValue := 365; seDiasCubrir.Value := 15;

  lblDiasVentas := TLabel.Create(Self);
  lblDiasVentas.Parent := gbAnalisis;
  lblDiasVentas.SetBounds(135, 24, 105, 18);
  lblDiasVentas.Caption := 'Ventas (dias)';
  lblDiasVentas.Hint := 'Dias hacia atras usados para calcular la venta media principal. No son los dias del pedido.';
  lblDiasVentas.ShowHint := True;
  seDiasVentas := TSpinEdit.Create(Self);
  seDiasVentas.Parent := gbAnalisis;
  seDiasVentas.SetBounds(135, 48, 78, 28);
  seDiasVentas.MinValue := 1; seDiasVentas.MaxValue := 730; seDiasVentas.Value := 60;
  seDiasVentas.Hint := 'Periodo principal de analisis de ventas. Ejemplo: 60 dias.';
  seDiasVentas.ShowHint := True;

  lblDiasTendencia := TLabel.Create(Self);
  lblDiasTendencia.Parent := gbAnalisis;
  lblDiasTendencia.SetBounds(250, 24, 120, 18);
  lblDiasTendencia.Caption := 'Tendencia (dias)';
  lblDiasTendencia.Hint := 'Periodo corto para detectar si el articulo esta vendiendo mas ultimamente.';
  lblDiasTendencia.ShowHint := True;
  seDiasTendencia := TSpinEdit.Create(Self);
  seDiasTendencia.Parent := gbAnalisis;
  seDiasTendencia.SetBounds(250, 48, 78, 28);
  seDiasTendencia.MinValue := 1; seDiasTendencia.MaxValue := 120;
  seDiasTendencia.Value := DayOf(Date);
  if seDiasTendencia.Value < 7 then seDiasTendencia.Value := 7;
  seDiasTendencia.Hint := 'Por defecto usa aproximadamente los dias transcurridos del mes, minimo 7.';
  seDiasTendencia.ShowHint := True;

  chkUsarTendencia := TCheckBox.Create(Self);
  chkUsarTendencia.Parent := gbAnalisis;
  chkUsarTendencia.SetBounds(340, 47, 140, 24);
  chkUsarTendencia.Caption := 'Usar tendencia';
  chkUsarTendencia.Hint := 'Si la venta corta es mayor que la media, refuerza el calculo para no quedarse corto.';
  chkUsarTendencia.ShowHint := True;
  chkUsarTendencia.Checked := True;

  lblDiasHistorico := TLabel.Create(Self);
  lblDiasHistorico.Parent := gbAnalisis;
  lblDiasHistorico.SetBounds(500, 24, 120, 18);
  lblDiasHistorico.Caption := 'Historico anterior';
  seDiasHistorico := TSpinEdit.Create(Self);
  seDiasHistorico.Parent := gbAnalisis;
  seDiasHistorico.SetBounds(500, 48, 84, 28);
  seDiasHistorico.MinValue := 1; seDiasHistorico.MaxValue := 1460; seDiasHistorico.Value := 180;

  lblDiasEntrega := TLabel.Create(Self);
  lblDiasEntrega.Parent := gbAnalisis;
  lblDiasEntrega.SetBounds(640, 24, 100, 18);
  lblDiasEntrega.Caption := 'Entrega (dias)';
  seDiasEntrega := TSpinEdit.Create(Self);
  seDiasEntrega.Parent := gbAnalisis;
  seDiasEntrega.SetBounds(640, 48, 74, 28);
  seDiasEntrega.MinValue := 0; seDiasEntrega.MaxValue := 30; seDiasEntrega.Value := 2;
  seDiasEntrega.Hint := 'Dias aproximados desde que haces el pedido hasta que entra la mercancia. El auto cubre dias pedido + entrega.';
  seDiasEntrega.ShowHint := True;

  lblFactor := TLabel.Create(Self);
  lblFactor.Parent := gbAnalisis;
  lblFactor.SetBounds(760, 24, 60, 18);
  lblFactor.Caption := 'Factor';
  edtFactor := TEdit.Create(Self);
  edtFactor.Parent := gbAnalisis;
  edtFactor.SetBounds(760, 48, 68, 28);
  edtFactor.Text := '1,00';

  lblNumPedidosHist := TLabel.Create(Self);
  lblNumPedidosHist.Parent := gbAnalisis;
  lblNumPedidosHist.SetBounds(870, 24, 105, 18);
  lblNumPedidosHist.Caption := 'Pedidos hist.';
  seNumPedidosHist := TSpinEdit.Create(Self);
  seNumPedidosHist.Parent := gbAnalisis;
  seNumPedidosHist.SetBounds(870, 48, 72, 28);
  seNumPedidosHist.MinValue := 1; seNumPedidosHist.MaxValue := 20; seNumPedidosHist.Value := 4;
  seNumPedidosHist.Hint := 'Numero de ultimos pedidos historicos del proveedor a usar en Repos. pedidos, Repos. real y Ref. compras pedidos.';
  seNumPedidosHist.ShowHint := True;

  chkUsarComprasUlt4Ref := TCheckBox.Create(Self);
  chkUsarComprasUlt4Ref.Parent := gbAnalisis;
  chkUsarComprasUlt4Ref.SetBounds(980, 47, 190, 24);
  chkUsarComprasUlt4Ref.Caption := 'Ref. compras pedidos';
  chkUsarComprasUlt4Ref.Hint := 'Usa unidades compradas en los ultimos N pedidos como referencia. En Repos. real tambien descuenta saldo teorico compras - ventas.';
  chkUsarComprasUlt4Ref.ShowHint := True;
  chkUsarComprasUlt4Ref.Checked := True;

  gbReglas := TGroupBox.Create(Self);
  gbReglas.Parent := pnlParametros;
  gbReglas.Align := alClient;
  gbReglas.Caption := '  REGLAS Y LIMITES  ';
  gbReglas.Font.Style := [];
  gbReglas.ParentFont := False;
  gbReglas.Font.Height := -13;

  lblMinSugerido := TLabel.Create(Self);
  lblMinSugerido.Parent := gbReglas;
  lblMinSugerido.SetBounds(18, 24, 95, 18);
  lblMinSugerido.Caption := 'Min. sugerido';
  seMinSugerido := TSpinEdit.Create(Self);
  seMinSugerido.Parent := gbReglas;
  seMinSugerido.SetBounds(18, 48, 68, 28);
  seMinSugerido.MinValue := 1; seMinSugerido.MaxValue := 9999; seMinSugerido.Value := 1;

  lblMinVentas := TLabel.Create(Self);
  lblMinVentas.Parent := gbReglas;
  lblMinVentas.SetBounds(130, 24, 110, 18);
  lblMinVentas.Caption := 'Min. venta reciente';
  seMinVentas := TSpinEdit.Create(Self);
  seMinVentas.Parent := gbReglas;
  seMinVentas.SetBounds(130, 48, 68, 28);
  seMinVentas.MinValue := 1; seMinVentas.MaxValue := 9999; seMinVentas.Value := 1;

  lblMinHistorico := TLabel.Create(Self);
  lblMinHistorico.Parent := gbReglas;
  lblMinHistorico.SetBounds(250, 24, 115, 18);
  lblMinHistorico.Caption := 'Min. hist. rotura';
  seMinHistorico := TSpinEdit.Create(Self);
  seMinHistorico.Parent := gbReglas;
  seMinHistorico.SetBounds(250, 48, 68, 28);
  seMinHistorico.MinValue := 1; seMinHistorico.MaxValue := 9999; seMinHistorico.Value := 3;

  lblMaxLineas := TLabel.Create(Self);
  lblMaxLineas.Parent := gbReglas;
  lblMaxLineas.SetBounds(370, 24, 85, 18);
  lblMaxLineas.Caption := 'Max. lineas';
  seMaxLineas := TSpinEdit.Create(Self);
  seMaxLineas.Parent := gbReglas;
  seMaxLineas.SetBounds(370, 48, 68, 28);
  seMaxLineas.MinValue := 10; seMaxLineas.MaxValue := 500; seMaxLineas.Value := 180;

  chkPocasVentasARevisar := TCheckBox.Create(Self);
  chkPocasVentasARevisar.Parent := gbReglas;
  chkPocasVentasARevisar.SetBounds(500, 47, 165, 24);
  chkPocasVentasARevisar.Caption := 'Pocas ventas a dudas <';
  chkPocasVentasARevisar.Hint := 'Si esta marcado, articulos con venta reciente positiva inferior a este umbral pasan a Ver dudas, aunque parezcan buenos.';
  chkPocasVentasARevisar.ShowHint := True;
  chkPocasVentasARevisar.Checked := True;
  seUmbralPocasVentas := TSpinEdit.Create(Self);
  seUmbralPocasVentas.Parent := gbReglas;
  seUmbralPocasVentas.SetBounds(670, 45, 58, 28);
  seUmbralPocasVentas.MinValue := 1; seUmbralPocasVentas.MaxValue := 9999; seUmbralPocasVentas.Value := 3;
  seUmbralPocasVentas.Hint := 'Por defecto 3: si vendio 1 o 2 unidades en el periodo, no entra automatico; va a revisar.';
  seUmbralPocasVentas.ShowHint := True;

  chkIncluirRoturas := TCheckBox.Create(Self);
  chkIncluirRoturas.Parent := gbReglas;
  chkIncluirRoturas.SetBounds(760, 47, 165, 24);
  chkIncluirRoturas.Caption := 'Incluir roturas stock';
  chkIncluirRoturas.Checked := True;

  chkExcluirRaros := TCheckBox.Create(Self);
  chkExcluirRaros.Parent := gbReglas;
  chkExcluirRaros.SetBounds(940, 47, 185, 24);
  chkExcluirRaros.Caption := 'Excluir coste 0 / PVP 999';
  chkExcluirRaros.Checked := False;

  chkMostrarCero := TCheckBox.Create(Self);
  chkMostrarCero.Parent := gbReglas;
  chkMostrarCero.SetBounds(1150, 47, 175, 24);
  chkMostrarCero.Caption := 'Mostrar sugerencia 0';
  chkMostrarCero.Checked := False;

  { ACCIONES AGRUPADAS }
  pcAcciones := TPageControl.Create(Self);
  pcAcciones.Parent := PanelTop;
  pcAcciones.Align := alClient;
  pcAcciones.TabPosition := tpTop;

  tsCalculo := TTabSheet.Create(Self);
  tsCalculo.PageControl := pcAcciones;
  tsCalculo.Caption := 'Calculo y vistas';

  tsRevision := TTabSheet.Create(Self);
  tsRevision.PageControl := pcAcciones;
  tsRevision.Caption := 'Revision y seleccion';

  tsEquivalencias := TTabSheet.Create(Self);
  tsEquivalencias.PageControl := pcAcciones;
  tsEquivalencias.Caption := 'Equivalencias';

  tsSalida := TTabSheet.Create(Self);
  tsSalida.PageControl := pcAcciones;
  tsSalida.Caption := 'Borradores y salida';

  btnCalcular := NuevoBoton(tsCalculo, 12, 12, 130, 'Calcular todo', '', @BtnCalcularClick);
  EstiloBotonPrincipal(btnCalcular);
  btnPedidoDepurado := NuevoBoton(tsCalculo, 152, 12, 145, 'Pedido depurado', '', @BtnPedidoDepuradoClick);
  EstiloBotonPrincipal(btnPedidoDepurado);
  btnPedidoAuto := NuevoBoton(tsCalculo, 307, 12, 145, 'Auto proveedor',
    'Genera pedido automatico de alta confianza y separa dudas/excluidos', @BtnPedidoAutoClick);
  EstiloBotonPrincipal(btnPedidoAuto);
  btnReposicionUlt4 := NuevoBoton(tsCalculo, 462, 12, 130, 'Repos. pedidos',
    'Calcula reposicion solo con articulos presentes en los ultimos N pedidos historicos del proveedor.', @BtnReposicionUlt4Click);
  btnReposicionReal := NuevoBoton(tsCalculo, 602, 12, 125, 'Repos. real',
    'Cruza ventas reales a cubrir con compras recientes para descontar saldo teorico.', @BtnReposicionRealClick);

  btnVerAuto := NuevoBoton(tsCalculo, 12, 52, 95, 'Ver auto', '', @BtnVerAutoClick);
  btnVerCompraSegura := NuevoBoton(tsCalculo, 117, 52, 120, 'Compra segura',
    'Muestra solo lineas ALTA, con cantidad final > 0 y sin riesgos basicos.', @BtnVerCompraSeguraClick);
  btnVerRiesgos := NuevoBoton(tsCalculo, 247, 52, 100, 'Ver riesgos',
    'Muestra solo lineas que conviene revisar antes de crear el pedido real', @BtnVerRiesgosClick);
  btnVerRevisar := NuevoBoton(tsCalculo, 357, 52, 95, 'Ver dudas', '', @BtnVerRevisarClick);
  btnVerExcluidos := NuevoBoton(tsCalculo, 462, 52, 105, 'Ver excluidos', '', @BtnVerExcluidosClick);
  btnOrdenTienda := NuevoBoton(tsCalculo, 577, 52, 110, 'Orden tienda',
    'Ordena por familia y descripcion para revisar lineal por lineal', @BtnOrdenTiendaClick);
  btnRecalcularFinal := NuevoBoton(tsCalculo, 697, 52, 125, 'Recalcular final',
    'Recalcula Cantidad final = Sugerido - Stock contado en todas las lineas', @BtnRecalcularFinalClick);
  btnCompararAnterior := NuevoBoton(tsCalculo, 832, 52, 115, 'Comparar ant.',
    'Compara el listado visible con el ultimo pedido real de este proveedor', @BtnCompararAnteriorClick);

  btnAceptarSiempre := NuevoBoton(tsRevision, 12, 12, 120, 'Aceptar siempre',
    'Guarda que este articulo/proveedor debe entrar como alta confianza si tiene cantidad sugerida', @BtnAceptarSiempreClick);
  btnRevisarSiempre := NuevoBoton(tsRevision, 142, 12, 120, 'Revisar siempre',
    'Guarda que este articulo/proveedor debe ir siempre a dudas', @BtnRevisarSiempreClick);
  btnExcluirSiempre := NuevoBoton(tsRevision, 272, 12, 120, 'Excluir siempre',
    'Guarda que este articulo/proveedor no debe entrar en el pedido automatico', @BtnExcluirSiempreClick);
  btnQuitarDecision := NuevoBoton(tsRevision, 402, 12, 110, 'Quitar regla',
    'Elimina la decision guardada para este articulo/proveedor', @BtnQuitarDecisionClick);
  btnAnadirManual := NuevoBoton(tsRevision, 522, 12, 110, 'Anadir linea',
    'Anade manualmente un articulo al pedido visible y a Ver auto.', @BtnAnadirManualClick);
  btnQuitarManual := NuevoBoton(tsRevision, 642, 12, 110, 'Quitar linea',
    'Quita la linea manual seleccionada del grid y de las listas internas.', @BtnQuitarManualClick);
  btnVerSimilares := NuevoBoton(tsRevision, 762, 12, 115, 'Ver similares',
    'Agrupa posibles sustitutos por palabras en distinto orden y cantidades cercanas.', @BtnVerSimilaresClick);
  btnQuitarAhora := NuevoBoton(tsRevision, 887, 12, 110, 'Quitar ahora',
    'Quita la linea actual solo de este pedido.', @BtnQuitarAhoraClick);

  btnQuitarMarcadas := NuevoBoton(tsRevision, 12, 52, 120, 'Quitar marc.',
    'Quita solo de este pedido todas las lineas marcadas en la columna Sel.', @BtnQuitarMarcadasClick);
  btnRevisarMarcadas := NuevoBoton(tsRevision, 142, 52, 120, 'Revisar marc.',
    'Pasa las lineas marcadas a revisar solo en el estudio actual.', @BtnRevisarMarcadasClick);
  btnExcluirMarcadas := NuevoBoton(tsRevision, 272, 52, 120, 'Excluir marc.',
    'Guarda EXCLUIR SIEMPRE para todas las lineas marcadas. Pide confirmacion.', @BtnExcluirMarcadasClick);
  btnVerQuitadas := NuevoBoton(tsRevision, 402, 52, 110, 'Ver quitadas',
    'Muestra lineas quitadas solo del pedido actual.', @BtnVerQuitadasClick);
  btnDesmarcarTodas := NuevoBoton(tsRevision, 522, 52, 110, 'Desmarcar',
    'Limpia todas las marcas de seleccion.', @BtnDesmarcarTodasClick);

  btnMarcarPrincipal := NuevoBoton(tsEquivalencias, 12, 16, 135, 'Marcar principal',
    'Marca el articulo seleccionado como codigo principal para equivalencias de este proveedor', @BtnMarcarPrincipalClick);
  btnEquivaleA := NuevoBoton(tsEquivalencias, 157, 16, 145, 'Equivale a...',
    'Indica que el articulo seleccionado equivale a otro codigo principal. Sus ventas se sumaran al principal.', @BtnEquivaleAClick);
  btnQuitarEquivalencia := NuevoBoton(tsEquivalencias, 312, 16, 145, 'Quitar equival.',
    'Elimina la equivalencia guardada para el articulo seleccionado', @BtnQuitarEquivalenciaClick);
  btnVerEquivalencias := NuevoBoton(tsEquivalencias, 467, 16, 145, 'Ver equival.',
    'Muestra las equivalencias guardadas para este proveedor', @BtnVerEquivalenciasClick);

  btnGuardarBorrador := NuevoBoton(tsSalida, 12, 12, 125, 'Guardar borr.',
    'Guarda la propuesta visible como borrador propio del modulo, sin crear pedido real', @BtnGuardarBorradorClick);
  btnCargarBorrador := NuevoBoton(tsSalida, 147, 12, 125, 'Cargar borr.',
    'Carga el ultimo borrador guardado para el proveedor seleccionado', @BtnCargarBorradorClick);
  btnBorrarBorrador := NuevoBoton(tsSalida, 282, 12, 125, 'Borrar borr.',
    'Borra el ultimo borrador guardado del proveedor seleccionado', @BtnBorrarBorradorClick);
  btnCrearPedidoReal := NuevoBoton(tsSalida, 417, 12, 165, 'Crear pedido real',
    'Crea un pedido real usando solo las lineas visibles con Cantidad final > 0. Pide confirmacion antes de insertar.', @BtnCrearPedidoRealClick);
  EstiloBotonPrincipal(btnCrearPedidoReal);
  btnHistorialCreados := NuevoBoton(tsSalida, 592, 12, 120, 'Hist. auto',
    'Muestra los ultimos pedidos reales creados desde este modulo para este proveedor', @BtnHistorialCreadosClick);

  btnExportar := NuevoBoton(tsSalida, 12, 52, 105, 'Exportar CSV', '', @BtnExportarClick);
  btnPDF := NuevoBoton(tsSalida, 127, 52, 105, 'Generar PDF', '', @BtnPDFClick);
  btnImprimir := NuevoBoton(tsSalida, 242, 52, 95, 'Imprimir', '', @BtnImprimirClick);
  chkAbrirPDF := TCheckBox.Create(Self);
  chkAbrirPDF.Parent := tsSalida;
  chkAbrirPDF.SetBounds(350, 56, 170, 24);
  chkAbrirPDF.Caption := 'Abrir PDF al generar';
  chkAbrirPDF.Checked := True;

  { ESTADO Y PROGRESO }
  pnlEstado := TPanel.Create(Self);
  pnlEstado.Parent := PanelTop;
  pnlEstado.Align := alBottom;
  pnlEstado.Height := 46;
  pnlEstado.BevelOuter := bvNone;
  pnlEstado.Color := $00E8EDF3;

  lblEstado := TLabel.Create(Self);
  lblEstado.Parent := pnlEstado;
  lblEstado.SetBounds(12, 6, 1100, 18);
  lblEstado.Anchors := [akLeft, akTop, akRight];
  lblEstado.AutoSize := False;
  lblEstado.Caption := 'Dias pedido = cobertura. Repos. pedidos usa ultimos N pedidos. Sel marca lineas para acciones masivas.';
  lblEstado.Font.Style := [fsBold];

  pbProgreso := TProgressBar.Create(Self);
  pbProgreso.Parent := pnlEstado;
  pbProgreso.SetBounds(12, 28, 1100, 12);
  pbProgreso.Anchors := [akLeft, akTop, akRight];
  pbProgreso.Min := 0;
  pbProgreso.Max := 100;
  pbProgreso.Position := 0;
  pbProgreso.Visible := False;

  { GRID }
  PanelBottom := TPanel.Create(Self);
  PanelBottom.Parent := Self;
  PanelBottom.Align := alClient;
  PanelBottom.BevelOuter := bvNone;
  PanelBottom.Color := clWhite;

  pnlGridCab := TPanel.Create(Self);
  pnlGridCab.Parent := PanelBottom;
  pnlGridCab.Align := alTop;
  pnlGridCab.Height := 38;
  pnlGridCab.BevelOuter := bvNone;
  pnlGridCab.Color := clWhite;

  lblGridTitulo := TLabel.Create(Self);
  lblGridTitulo.Parent := pnlGridCab;
  lblGridTitulo.Left := 12;
  lblGridTitulo.Top := 10;
  lblGridTitulo.Caption := 'RESULTADO DEL ESTUDIO / PEDIDO';
  lblGridTitulo.Font.Style := [fsBold];

  lblGridAyuda := TLabel.Create(Self);
  lblGridAyuda.Parent := pnlGridCab;
  lblGridAyuda.Left := 330;
  lblGridAyuda.Top := 10;
  lblGridAyuda.Caption := 'Pulsa una cabecera para ordenar. Las acciones se aplican sobre la linea o seleccion visible.';
  lblGridAyuda.Font.Color := clGray;

  Grid := TStringGrid.Create(Self);
  Grid.Parent := PanelBottom;
  Grid.Align := alClient;
  Grid.FixedRows := 1;
  Grid.FixedColor := $00E8EDF3;
  Grid.Color := clWhite;
  Grid.DefaultRowHeight := 25;
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
  FSuppressSelToggle := True;
  try
    FSortCol := -1;
    FSortAsc := True;
    Grid.ColCount := 26;
    Grid.RowCount := 2;

    Grid.Cells[2, 0] := 'Codigo';
    Grid.Cells[3, 0] := 'Descripcion';
    Grid.Cells[4, 0] := 'Vendido periodo';
    Grid.Cells[5, 0] := 'Vend. tendencia';
    Grid.Cells[6, 0] := 'Vendido historico';
    Grid.Cells[7, 0] := 'Venta/dia usada';
    Grid.Cells[8, 0] := 'Sugerido';
    Grid.Cells[9, 0] := 'Stock contado';
    Grid.Cells[10, 0] := 'Cantidad final';
    Grid.Cells[11, 0] := 'Confianza';
    Grid.Cells[12, 0] := 'Accion';
    Grid.Cells[13, 0] := 'Ult. venta';
    Grid.Cells[14, 0] := 'Ult. compra';
    Grid.Cells[15, 0] := 'Coste';
    Grid.Cells[16, 0] := 'PVP';
    Grid.Cells[17, 0] := 'IVA';
    Grid.Cells[18, 0] := 'Stock info';
    Grid.Cells[19, 0] := 'Familia';
    Grid.Cells[20, 0] := 'Estado';
    Grid.Cells[21, 0] := 'Observaciones';
    Grid.Cells[22, 0] := 'Vend. cobertura';
    Grid.Cells[23, 0] := 'Comprado ult. ped.';
    Grid.Cells[24, 0] := 'Media/ped.';
    Grid.Cells[25, 0] := 'Max/ped.';
    Grid.Cells[0, 0] := '#';
    Grid.Cells[1, 0] := 'Sel';

    Grid.Rows[1].Clear;
    Grid.Cells[1, 1] := '';
    if Grid.ColCount > 2 then Grid.Col := 2;
    if Grid.RowCount > 1 then Grid.Row := 1;
    AutoAjustarColumnas;
  finally
    FSuppressSelToggle := False;
  end;
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
    LogPedidoAuto('Conexion no activa al cargar proveedores.');
    ShowMessage('La conexion a la base de datos no esta activa.');
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

  ProgresoInicio('Verificando tablas del pedido automatico...', 6);
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
    ProgresoPaso('Verificando lineas de borradores...', 5, 6);

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
    ProgresoPaso('Verificando historial de pedidos automaticos creados...', 6, 6);
  except
    on E: Exception do
    begin
      LogErrorPedidoAuto('CrearTablasPedidoAuto', E);
      ShowMessage('No se pudieron crear/verificar las tablas del pedido automatico.' + LineEnding +
        E.Message + LineEnding + LineEnding +
        'La pantalla puede seguir funcionando, pero no guardara perfiles ni decisiones.');
    end;
  end;
  Q.Free;
  ProgresoFin('Tablas del pedido automatico verificadas.');
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
    lblEstado.Caption := 'Perfil guardado para ' + NombreProveedorSeleccionado + '. Se cargara automaticamente al seleccionar el proveedor.';
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
        ShowMessage('Este proveedor aun no tiene perfil guardado.');
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
      '. Auto proveedor usara estos parametros.';
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
  Result := Trim(Grid.Cells[2, Grid.Row]);
end;

procedure TfPedidoProveedorAuto.ActualizarDecisionFilaVisible(const Decision: string);
begin
  if (Grid = nil) or (Grid.Row <= 0) or (Grid.Row >= Grid.RowCount) then
    Exit;

  if SameText(Decision, 'ACEPTAR') then
  begin
    Grid.Cells[11, Grid.Row] := 'ALTA';
    Grid.Cells[12, Grid.Row] := 'ACEPTAR SIEMPRE';
  end
  else if SameText(Decision, 'REVISAR') then
  begin
    Grid.Cells[11, Grid.Row] := 'MEDIA';
    Grid.Cells[12, Grid.Row] := 'REVISAR SIEMPRE';
  end
  else if SameText(Decision, 'EXCLUIR') then
  begin
    Grid.Cells[11, Grid.Row] := 'BAJA';
    Grid.Cells[12, Grid.Row] := 'EXCLUIR SIEMPRE';
  end
  else
  begin
    Grid.Cells[12, Grid.Row] := '';
  end;

  if Decision <> '' then
    Grid.Cells[21, Grid.Row] := Grid.Cells[21, Grid.Row] + ' Decision guardada: ' + Decision + '.';
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
    ShowMessage('Seleccione una linea del grid.');
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
    Q.ParamByName('obs').AsString := Copy(Grid.Cells[3, Grid.Row], 1, 240);
    Q.ExecSQL;
    ActualizarDecisionFilaVisible(UpperCase(Decision));
    lblEstado.Caption := 'Decision ' + UpperCase(Decision) + ' guardada para articulo ' + CodArt +
      ' / proveedor ' + NombreProveedorSeleccionado + '.';
    LogPedidoAuto('Decision ' + UpperCase(Decision) + ' guardada. Proveedor=' + NombreProveedorSeleccionado + ' Articulo=' + CodArt);
  except
    on E: Exception do
    begin
      LogErrorPedidoAuto('GuardarDecisionArticulo', E);
      ShowMessage('Error guardando decision:' + LineEnding + E.Message);
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
    ShowMessage('Seleccione proveedor y una linea del grid.');
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
    lblEstado.Caption := 'Regla eliminada para articulo ' + CodArt + '.';
  except
    on E: Exception do
    begin
      LogErrorPedidoAuto('QuitarDecisionArticulo', E);
      ShowMessage('Error eliminando decision:' + LineEnding + E.Message);
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
    ShowMessage('Seleccione una linea/articulo.');
    Exit;
  end;

  if CodPrin = '' then
  begin
    ShowMessage('Indique el codigo principal.');
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
    ShowMessage('Seleccione proveedor y una linea/articulo.');
    Exit;
  end;

  if not TablaExiste('pedido_auto_equivalencias') then
  begin
    ShowMessage('No hay tabla de equivalencias creada todavia.');
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
    ShowMessage('Todavia no hay equivalencias guardadas.');
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
        SL.Add('... ' + IntToStr(N - 80) + ' equivalencias mas no mostradas en este aviso.');
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
    ShowMessage('Seleccione una linea/articulo.');
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
    ShowMessage('Seleccione la linea que quiere marcar como equivalente.');
    Exit;
  end;

  CodPrincipal := CodArt;
  if InputQuery('Equivalencia de articulo',
    'Codigo principal al que debe acumular ventas el articulo ' + CodArt + ':', CodPrincipal) then
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
    // Si algo falla, no bloqueamos el calculo automatico. Simplemente no aplica decisiones guardadas.
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
    // Por defecto, textos ascendente y numeros descendente, que suele ser mas util para unidades/importes.
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
    'Codigo', 'Descripcion', 'Vendido periodo', 'Vend. tendencia',
    'Vendido historico', 'Venta/dia usada', 'Sugerido', 'Stock contado',
    'Cantidad final', 'Confianza', 'Accion', 'Ult. venta', 'Ult. compra',
    'Coste', 'PVP', 'IVA', 'Stock info', 'Familia', 'Estado', 'Observaciones');
var
  I: Integer;
begin
  Grid.Cells[0, 0] := '#';
  Grid.Cells[1, 0] := 'Sel';
  for I := 2 to Grid.ColCount - 1 do
  begin
    if (I - 2) <= High(Headers) then
      Grid.Cells[I, 0] := Headers[I - 2];
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


function TfPedidoProveedorAuto.SQLComprasProveedorUltimos4(const CodProveedor: Integer): string;
var
  THiPedic: string;
  THiPedid: string;
  L: TStringList;
  NumPedidosHist: Integer;
begin
  Result := '';
  THiPedic := 'hipedicc' + FTienda;
  THiPedid := 'hipedidd' + FTienda;
  NumPedidosHist := seNumPedidosHist.Value;
  if NumPedidosHist < 1 then NumPedidosHist := 1;
  if NumPedidosHist > 20 then NumPedidosHist := 20;

  // Modo reposicion segura: solo articulos que estuvieron en los ultimos N pedidos
  // historicos del proveedor. Si no existe hipedicc/hipedidd o falta algun campo,
  // devolvemos vacio y no tocamos nada.
  if (not TablaExiste(THiPedic)) or (not TablaExiste(THiPedid)) then Exit;
  if (not CampoExiste(THiPedic, 'HPC1')) or (not CampoExiste(THiPedic, 'HPC2')) or
     (not CampoExiste(THiPedic, 'HPC3')) or (not CampoExiste(THiPedic, 'HPC4')) then Exit;
  if (not CampoExiste(THiPedid, 'HPD1')) or (not CampoExiste(THiPedid, 'HPD2')) or
     (not CampoExiste(THiPedid, 'HPD3')) or (not CampoExiste(THiPedid, 'HPD4')) or
     (not CampoExiste(THiPedid, 'HPD6')) or (not CampoExiste(THiPedid, 'HPD8')) or
     (not CampoExiste(THiPedid, 'HPD10')) then Exit;

  L := TStringList.Create;
  try
    L.Add('SELECT Y.CODIGO, MAX(Y.FECHA) AS ULT_COMPRA, MAX(Y.COSTE) AS ULT_COSTE, ');
    L.Add('SUM(Y.UDS) AS COMPRADO_ULT4, AVG(Y.UDS) AS MEDIA_ULT4, MAX(Y.UDS) AS MAX_ULT4, ');
    L.Add('MAX(Y.UDS) AS ULT_COMPRA_UDS ');
    L.Add('FROM (');
    L.Add('SELECT HPD.HPD6 AS CODIGO, HPD.HPD3 AS SERIE, HPD.HPD4 AS NUMERO, ');
    L.Add('MAX(HPD.HPD1) AS FECHA, MAX(HPD.HPD10) AS COSTE, ');
    L.Add('SUM(CASE WHEN HPD.HPD8 > 0 THEN HPD.HPD8 ELSE 0 END) AS UDS ');
    L.Add('FROM `' + THiPedid + '` HPD ');
    L.Add('JOIN (SELECT HPC3 AS SERIE, HPC4 AS NUMERO FROM `' + THiPedic + '` ');
    L.Add('WHERE HPC2 = ' + IntToStr(CodProveedor) + ' ');
    L.Add('ORDER BY HPC1 DESC, HPC4 DESC LIMIT ' + IntToStr(NumPedidosHist) + ') U4 ');
    L.Add('ON U4.SERIE = HPD.HPD3 AND U4.NUMERO = HPD.HPD4 ');
    L.Add('WHERE HPD.HPD2 = ' + IntToStr(CodProveedor) + ' AND TRIM(HPD.HPD6) <> '''' ');
    L.Add('GROUP BY HPD.HPD6, HPD.HPD3, HPD.HPD4) Y ');
    L.Add('GROUP BY Y.CODIGO');
    Result := StringReplace(Trim(L.Text), LineEnding, ' ', [rfReplaceAll]);
  finally
    L.Free;
  end;
end;

function TfPedidoProveedorAuto.SQLVentas(const FechaDesdeHistorico,
  FechaHasta: TDateTime; const CodProveedor: Integer): string;
var
  THis: string;
  DiasCobertura: Integer;
  FechaDesdeCobertura: TDateTime;
begin
  Result := '';
  THis := 'hisopdd' + FTienda;

  if not TablaExiste(THis) then Exit;

  DiasCobertura := seDiasCubrir.Value + seDiasEntrega.Value;
  if DiasCobertura < 1 then DiasCobertura := 1;
  FechaDesdeCobertura := IncDay(FechaHasta, -DiasCobertura + 1);

  if TablaExiste('pedido_auto_equivalencias') then
    Result :=
      'SELECT CODIGO, ' +
      'SUM(CASE WHEN FECHA >= ' + FechaSQL(FechaDesdeCobertura) +
      ' THEN UDS ELSE 0 END) AS VENTAS_COBERTURA, ' +
      'SUM(CASE WHEN FECHA >= ' + FechaSQL(IncDay(FechaHasta, -seDiasVentas.Value + 1)) +
      ' THEN UDS ELSE 0 END) AS VENTAS_PERIODO, ' +
      'SUM(CASE WHEN FECHA >= ' + FechaSQL(IncDay(FechaHasta, -seDiasTendencia.Value + 1)) +
      ' THEN UDS ELSE 0 END) AS VENTAS_TENDENCIA, ' +
      'SUM(CASE WHEN FECHA < ' + FechaSQL(IncDay(FechaHasta, -seDiasVentas.Value + 1)) +
      ' THEN UDS ELSE 0 END) AS VENTAS_HISTORICO, ' +
      'MAX(CASE WHEN UDS > 0 THEN FECHA ELSE NULL END) AS ULT_VENTA ' +
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
      'SUM(CASE WHEN FECHA >= ' + FechaSQL(FechaDesdeCobertura) +
      ' THEN UDS ELSE 0 END) AS VENTAS_COBERTURA, ' +
      'SUM(CASE WHEN FECHA >= ' + FechaSQL(IncDay(FechaHasta, -seDiasVentas.Value + 1)) +
      ' THEN UDS ELSE 0 END) AS VENTAS_PERIODO, ' +
      'SUM(CASE WHEN FECHA >= ' + FechaSQL(IncDay(FechaHasta, -seDiasTendencia.Value + 1)) +
      ' THEN UDS ELSE 0 END) AS VENTAS_TENDENCIA, ' +
      'SUM(CASE WHEN FECHA < ' + FechaSQL(IncDay(FechaHasta, -seDiasVentas.Value + 1)) +
      ' THEN UDS ELSE 0 END) AS VENTAS_HISTORICO, ' +
      'MAX(CASE WHEN UDS > 0 THEN FECHA ELSE NULL END) AS ULT_VENTA ' +
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
    ShowMessage('No existe la tabla de articulos: ' + TArti);
    Exit;
  end;

  if FUsarReposicionUlt4 then
    ComprasSQL := SQLComprasProveedorUltimos4(CodProveedor)
  else
    ComprasSQL := SQLComprasProveedor(CodProveedor);
  if ComprasSQL = '' then
  begin
    if FUsarReposicionUlt4 then
      ShowMessage('No encuentro los ultimos ' + IntToStr(seNumPedidosHist.Value) + ' pedidos historicos de este proveedor en hipedicc/hipedidd, o la estructura no parece la esperada. No se ha modificado nada.')
    else
      ShowMessage('No encuentro tablas de pedidos/historico de compras para la tienda ' + FTienda + '.');
    Exit;
  end;

  VentasSQL := SQLVentas(FechaDesdeHistorico, FechaHasta, CodProveedor);

  Result :=
    'SELECT A.A0 AS CODIGO, A.A1 AS DESCRIPCION, A.A2 AS PVP, A.A3 AS IVA, ' +
    'A.A4 AS STOCK_INFO, A.A13 AS ULT_COMPRA_FICHA, A.A14 AS FAMILIA, ' +
    'A.A24 AS COSTE_FICHA, CP.ULT_COMPRA, CP.ULT_COSTE, ';

  if FUsarReposicionUlt4 then
    Result := Result +
      'COALESCE(CP.COMPRADO_ULT4, 0) AS COMPRADO_ULT4, ' +
      'COALESCE(CP.MEDIA_ULT4, 0) AS MEDIA_ULT4, ' +
      'COALESCE(CP.MAX_ULT4, 0) AS MAX_ULT4, ' +
      'COALESCE(CP.ULT_COMPRA_UDS, 0) AS ULT_COMPRA_UDS, '
  else
    Result := Result +
      '0 AS COMPRADO_ULT4, 0 AS MEDIA_ULT4, 0 AS MAX_ULT4, 0 AS ULT_COMPRA_UDS, ';

  if VentasSQL <> '' then
    Result := Result +
      'COALESCE(V.VENTAS_COBERTURA, 0) AS VENTAS_COBERTURA, ' +
      'COALESCE(V.VENTAS_PERIODO, 0) AS VENTAS_PERIODO, ' +
      'COALESCE(V.VENTAS_TENDENCIA, 0) AS VENTAS_TENDENCIA, ' +
      'COALESCE(V.VENTAS_HISTORICO, 0) AS VENTAS_HISTORICO, V.ULT_VENTA '
  else
    Result := Result +
      '0 AS VENTAS_COBERTURA, 0 AS VENTAS_PERIODO, 0 AS VENTAS_TENDENCIA, 0 AS VENTAS_HISTORICO, NULL AS ULT_VENTA ';

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
  // Ordenacion sencilla descendente. Para 1500-3000 lineas es suficiente
  // y evita depender de genericos/colecciones que puedan variar entre Lazarus/FPC.
  for I := Low(Lineas) to High(Lineas) - 1 do
    for J := I + 1 to High(Lineas) do
      if Lineas[J].Prioridad > Lineas[I].Prioridad then
      begin
        Tmp := Lineas[I];
        Lineas[I] := Lineas[J];
        Lineas[J] := Tmp;
      end;
end;

function TfPedidoProveedorAuto.LineaAutoQuitada(const L: TLineaPedidoAuto): Boolean;
var
  T: string;
begin
  T := UpperCase(Trim(L.Accion + ' ' + L.Estado + ' ' + L.Observaciones));
  Result := Pos('QUITADO', T) > 0;
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
    // Las lineas quitadas solo deben verse desde Ver quitadas.
    if LineaAutoQuitada(Lineas[I]) then
      Continue;

    if R >= Grid.RowCount then
      Grid.RowCount := Grid.RowCount + 1;

    Grid.Cells[2, R] := Lineas[I].Codigo;
    Grid.Cells[3, R] := Lineas[I].Descripcion;
    Grid.Cells[4, R] := FormatFloat('0.##', Lineas[I].VendidoPeriodo);
    Grid.Cells[5, R] := FormatFloat('0.##', Lineas[I].VendidoTendencia);
    Grid.Cells[6, R] := FormatFloat('0.##', Lineas[I].VendidoHistorico);
    Grid.Cells[7, R] := FormatFloat('0.####', Lineas[I].VentaDia);
    Grid.Cells[8, R] := FormatFloat('0.##', Lineas[I].Sugerido);
    if Abs(Lineas[I].StockContado) > 0.0001 then
      Grid.Cells[9, R] := FormatFloat('0.##', Lineas[I].StockContado)
    else
      Grid.Cells[9, R] := ''; // Stock contado manual en tienda
    if Abs(Lineas[I].CantidadFinal) > 0.0001 then
      Grid.Cells[10, R] := FormatFloat('0.##', Lineas[I].CantidadFinal)
    else
      Grid.Cells[10, R] := FormatFloat('0.##', Lineas[I].Sugerido); // Cantidad final inicial
    Grid.Cells[11, R] := Lineas[I].Confianza;
    Grid.Cells[12, R] := Lineas[I].Accion;
    Grid.Cells[13, R] := Lineas[I].UltVenta;
    Grid.Cells[14, R] := Lineas[I].UltCompra;
    Grid.Cells[15, R] := FormatFloat('0.000', Lineas[I].Coste);
    Grid.Cells[16, R] := FormatFloat('0.00', Lineas[I].PVP);
    Grid.Cells[17, R] := FormatFloat('0.##', Lineas[I].IVA);
    Grid.Cells[18, R] := FormatFloat('0.##', Lineas[I].StockInfo);
    Grid.Cells[19, R] := Lineas[I].Familia;
    Grid.Cells[20, R] := Lineas[I].Estado;
    Grid.Cells[21, R] := Lineas[I].Observaciones;
    Grid.Cells[22, R] := FormatFloat('0.##', Lineas[I].VendidoCobertura);
    Grid.Cells[23, R] := FormatFloat('0.##', Lineas[I].CompradoUlt4);
    Grid.Cells[24, R] := FormatFloat('0.##', Lineas[I].MediaUlt4);
    Grid.Cells[25, R] := FormatFloat('0.##', Lineas[I].MaxUlt4);
    Grid.Cells[0, R] := IntToStr(R);
    Grid.Cells[1, R] := '';
    Inc(R);
  end;

  if R = 1 then
  begin
    Grid.Rows[1].Clear;
    Grid.Cells[0, 1] := '';
    Grid.Cells[1, 1] := '';
  end;

  FSuppressSelToggle := True;
  try
    DesmarcarTodasLasLineas;
    if Grid.RowCount > 1 then
    begin
      Grid.Row := 1;
      if Grid.ColCount > 2 then Grid.Col := 2;
    end;
  finally
    FSuppressSelToggle := False;
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
  VentasCobertura: Double;
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
  CompradoUlt4: Double;
  MediaUlt4: Double;
  MaxUlt4: Double;
  UltCompraUds: Double;

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
        ProgresoPaso('Analizando articulos comprados al proveedor... ' + IntToStr(TotalLeidas) + ' leidos', -1);
      VentasCobertura := Q.FieldByName('VENTAS_COBERTURA').AsFloat;
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

        // Si la tendencia corta es mas alta que la media principal, usamos una mezcla prudente
        // 65% periodo principal + 35% tendencia corta, pero nunca bajamos por debajo de la media principal.
        if chkUsarTendencia.Checked and (VentasTendencia > 0) and
          (VentaDiaTendencia > VentaDiaPeriodo) then
        begin
          VentaDia := Max(VentaDiaPeriodo, (VentaDiaPeriodo * 0.65) + (VentaDiaTendencia * 0.35));
          Estado := 'VENTA RECIENTE + TENDENCIA';
          Obs := 'Media periodo ' + FormatFloat('0.####', VentaDiaPeriodo) +
            '/dia; tendencia ' + FormatFloat('0.####', VentaDiaTendencia) +
            '/dia. Se refuerza calculo por aceleracion reciente.';
        end
        else
        begin
          Estado := 'VENTA RECIENTE';
          Obs := 'Media periodo ' + FormatFloat('0.####', VentaDiaPeriodo) +
            '/dia. Tendencia ' + FormatFloat('0.####', VentaDiaTendencia) + '/dia.';
        end;
      end
      else if VentasHistorico > 0 then
      begin
        VentaDia := VentasHistorico / seDiasHistorico.Value;
        Estado := 'POSIBLE ROTURA STOCK';
        Obs := 'Sin venta reciente, pero con historico. Revisar posible falta de existencias.';
      end
      else
      begin
        VentaDia := 0;
        Estado := 'SIN VENTA';
        Obs := 'Comprado al proveedor, sin ventas en los periodos analizados.';
      end;

      Sugerido := RedondearArriba(VentaDia * seDiasCubrir.Value * Factor);
      Obs := Obs + ' Formula: ' + FormatFloat('0.####', VentaDia) +
        '/dia x ' + IntToStr(seDiasCubrir.Value) + ' dias x factor ' +
        FormatFloat('0.##', Factor) + ' = ' + FormatFloat('0.##', Sugerido) + '.';

      Coste := Q.FieldByName('ULT_COSTE').AsFloat;
      if Coste <= 0 then
        Coste := Q.FieldByName('COSTE_FICHA').AsFloat;

      StockInfo := Q.FieldByName('STOCK_INFO').AsFloat;
      PVP := Q.FieldByName('PVP').AsFloat;
      CompradoUlt4 := Q.FieldByName('COMPRADO_ULT4').AsFloat;
      MediaUlt4 := Q.FieldByName('MEDIA_ULT4').AsFloat;
      MaxUlt4 := Q.FieldByName('MAX_ULT4').AsFloat;
      UltCompraUds := Q.FieldByName('ULT_COMPRA_UDS').AsFloat;

      UltCompra := '';
      if not Q.FieldByName('ULT_COMPRA').IsNull then
        UltCompra := DateToStr(Q.FieldByName('ULT_COMPRA').AsDateTime)
      else if not Q.FieldByName('ULT_COMPRA_FICHA').IsNull then
        UltCompra := DateToStr(Q.FieldByName('ULT_COMPRA_FICHA').AsDateTime);

      UltVenta := '';
      if not Q.FieldByName('ULT_VENTA').IsNull then
        UltVenta := DateToStr(Q.FieldByName('ULT_VENTA').AsDateTime);

      if UltCompra <> '' then
        Obs := Obs + ' Articulo incluido porque aparece en pedidos/compras anteriores de este proveedor; ultima compra ' + UltCompra + '.'
      else
        Obs := Obs + ' Articulo incluido porque aparece en el historial de pedidos/compras del proveedor.';

      // Modo completo: igual que la version anterior.
      Incluir := (Sugerido > 0) or chkMostrarCero.Checked;

      if Depurada then
      begin
        // Modo pedido depurado:
        // - Nunca mete articulos sin venta util.
        // - Da prioridad absoluta a venta reciente.
        // - Permite roturas de stock, pero solo si tienen algo de historico real.
        // - Limita despues por prioridad a MaxLineas.
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
        L.VendidoCobertura := VentasCobertura;
        L.VentaDia := VentaDia;
        L.Sugerido := Sugerido;
        L.StockContado := 0;
        L.CantidadFinal := Sugerido;
        L.UltVenta := UltVenta;
        L.UltCompra := UltCompra;
        L.CompradoUlt4 := CompradoUlt4;
        L.MediaUlt4 := MediaUlt4;
        L.MaxUlt4 := MaxUlt4;
        L.UltCompraUds := UltCompraUds;
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
      ' de ' + IntToStr(TotalCandidatas) + ' candidatas. Leidas: ' +
      IntToStr(TotalLeidas) + '. Max. lineas: ' + IntToStr(MaxLineas) +
      '. Filtros: min sug ' + FormatFloat('0.##', MinSugerido) +
      ', min venta ' + FormatFloat('0.##', MinVentas) +
      ', min hist ' + FormatFloat('0.##', MinHistorico) +
      '. Ventas analizadas: ' + DateToStr(FechaDesdeVentas) + ' a ' + DateToStr(FechaHasta) +
      '. Pedido cubre ' + IntToStr(seDiasCubrir.Value) + ' dias.');
  end
  else
  begin
    PintarLineasEnGrid(Lineas, 0);
    Mostradas := Length(Lineas);
    ProgresoFin('Propuesta completa calculada. Lineas mostradas: ' +
      IntToStr(Mostradas) + '. Ventas analizadas: ' +
      DateToStr(FechaDesdeVentas) + ' a ' + DateToStr(FechaHasta) +
      '. Pedido cubre ' + IntToStr(seDiasCubrir.Value) + ' dias.');
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
    // Proveedor quincenal: mas cobertura y algo mas de margen.
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

  lblEstado.Caption := 'Perfil auto aplicado. Cobertura real auto = dias pedido + entrega.';
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
    ' linea(s). PDF/CSV/impresion usaran esta vista.';
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

  // Con una clave corta detectamos articulos partidos por formato/EAN,
  // pero evitando claves muy genericas de 4-5 letras.
  if Length(Result) > 18 then
    Result := Copy(Result, 1, 18);
  if Length(Result) < 10 then
    Result := '';
end;


function TfPedidoProveedorAuto.NormalizarTextoSimilar(const S: string): string;
var
  I: Integer;
  C: Char;
  T: string;
begin
  T := UpperCase(S);
  Result := '';
  for I := 1 to Length(T) do
  begin
    C := T[I];
    if C in ['A'..'Z', '0'..'9'] then
      Result := Result + C
    else
      Result := Result + ' ';
  end;
  while Pos('  ', Result) > 0 do
    Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
  Result := Trim(Result);
end;

function TfPedidoProveedorAuto.ClaveDescripcionSimilar(const S: string): string;
var
  Tokens: TStringList;
  T, Tok: string;
  I: Integer;
  EsNumero: Boolean;
begin
  Result := '';
  Tokens := TStringList.Create;
  try
    Tokens.Sorted := True;
    Tokens.Duplicates := dupIgnore;
    T := NormalizarTextoSimilar(S);
    while T <> '' do
    begin
      I := Pos(' ', T);
      if I > 0 then
      begin
        Tok := Copy(T, 1, I - 1);
        Delete(T, 1, I);
      end
      else
      begin
        Tok := T;
        T := '';
      end;
      Tok := Trim(Tok);
      if Tok = '' then Continue;
      EsNumero := True;
      for I := 1 to Length(Tok) do
        if not (Tok[I] in ['0'..'9']) then EsNumero := False;
      if EsNumero then Continue;
      if (Tok = 'DE') or (Tok = 'DEL') or (Tok = 'LA') or (Tok = 'EL') or
         (Tok = 'LOS') or (Tok = 'LAS') or (Tok = 'CON') or (Tok = 'PARA') or
         (Tok = 'ML') or (Tok = 'L') or (Tok = 'GR') or (Tok = 'G') or
         (Tok = 'KG') or (Tok = 'UD') or (Tok = 'UDS') then Continue;
      if (Tok = 'DETERGENTE') or (Tok = 'DETERG') then Tok := 'DET';
      if (Tok = 'MULTIACCION') or (Tok = 'MULTIACCIONES') then Tok := 'MULTI';
      Tokens.Add(Tok);
    end;
    for I := 0 to Tokens.Count - 1 do
    begin
      if Result <> '' then Result := Result + ' ';
      Result := Result + Tokens[I];
    end;
    if Length(Result) < 5 then Result := '';
  finally
    Tokens.Free;
  end;
end;

function TfPedidoProveedorAuto.CantidadDescripcionSimilar(const S: string): Double;
var
  T, Tok, NextTok: string;
  I, P: Integer;
  V: Double;
  EsNumero: Boolean;
  Lista: TStringList;
begin
  Result := 0;
  Lista := TStringList.Create;
  try
    T := NormalizarTextoSimilar(S);
    while T <> '' do
    begin
      P := Pos(' ', T);
      if P > 0 then
      begin
        Tok := Copy(T, 1, P - 1);
        Delete(T, 1, P);
      end
      else
      begin
        Tok := T;
        T := '';
      end;
      if Tok <> '' then Lista.Add(Tok);
    end;
    for I := 0 to Lista.Count - 1 do
    begin
      Tok := Lista[I];
      EsNumero := Tok <> '';
      for P := 1 to Length(Tok) do
        if not (Tok[P] in ['0'..'9']) then EsNumero := False;
      if not EsNumero then Continue;
      V := StrToFloatDef(Tok, 0);
      NextTok := '';
      if I + 1 < Lista.Count then NextTok := Lista[I + 1];
      if (NextTok = 'L') or (NextTok = 'LT') or (NextTok = 'LITRO') or (NextTok = 'LITROS') then
        V := V * 1000
      else if (NextTok = 'KG') or (NextTok = 'KILO') or (NextTok = 'KILOS') then
        V := V * 1000;
      if V > Result then Result := V;
    end;
  finally
    Lista.Free;
  end;
end;

function TfPedidoProveedorAuto.CantidadesCompatibles(const A, B: Double): Boolean;
var
  MinV, Dif: Double;
begin
  Result := True;
  if (A <= 0) or (B <= 0) then Exit;
  MinV := Min(A, B);
  Dif := Abs(A - B);
  if MinV <= 500 then
    Result := Dif <= 50
  else if MinV <= 1000 then
    Result := Dif <= (MinV * 0.15)
  else
    Result := Dif <= (MinV * 0.10);
end;

function TfPedidoProveedorAuto.ValorFechaTexto(const S: string): TDateTime;
begin
  Result := StrToDateDef(Trim(S), 0);
end;

procedure TfPedidoProveedorAuto.MostrarSimilaresVisibles;
var
  R, J, C, Dest, Grupo, Mejor: Integer;
  KeyR, KeyJ, Msg: string;
  CantR, CantJ, FechaR, FechaJ, BestFecha: Double;
  TieneGrupo: Boolean;
  Rows, Parts: TStringList;
begin
  if not HayDatosEnGrid then
  begin
    ShowMessage('No hay lineas visibles para buscar similares.');
    Exit;
  end;

  Rows := TStringList.Create;
  Parts := TStringList.Create;
  try
    Parts.StrictDelimiter := True;
    Parts.Delimiter := #9;
    Grupo := 0;

    for R := 1 to Grid.RowCount - 1 do
    begin
      if Trim(Grid.Cells[2, R]) = '' then Continue;
      KeyR := ClaveDescripcionSimilar(Grid.Cells[3, R]);
      if KeyR = '' then Continue;
      CantR := CantidadDescripcionSimilar(Grid.Cells[3, R]);
      TieneGrupo := False;
      Mejor := R;
      BestFecha := Max(ValorFechaTexto(Grid.Cells[14, R]), ValorFechaTexto(Grid.Cells[13, R]));

      for J := R + 1 to Grid.RowCount - 1 do
      begin
        if Trim(Grid.Cells[2, J]) = '' then Continue;
        KeyJ := ClaveDescripcionSimilar(Grid.Cells[3, J]);
        if KeyJ <> KeyR then Continue;
        CantJ := CantidadDescripcionSimilar(Grid.Cells[3, J]);
        if not CantidadesCompatibles(CantR, CantJ) then Continue;
        TieneGrupo := True;
        FechaJ := Max(ValorFechaTexto(Grid.Cells[14, J]), ValorFechaTexto(Grid.Cells[13, J]));
        if FechaJ > BestFecha then
        begin
          BestFecha := FechaJ;
          Mejor := J;
        end;
      end;

      if TieneGrupo then
      begin
        Inc(Grupo);
        for J := R to Grid.RowCount - 1 do
        begin
          if Trim(Grid.Cells[2, J]) = '' then Continue;
          KeyJ := ClaveDescripcionSimilar(Grid.Cells[3, J]);
          CantJ := CantidadDescripcionSimilar(Grid.Cells[3, J]);
          if (KeyJ = KeyR) and CantidadesCompatibles(CantR, CantJ) then
          begin
            Msg := ' SIMILAR G' + IntToStr(Grupo) + ' clave [' + KeyR + '] cant aprox ' + FormatFloat('0.##', CantJ) + '.';
            if J = Mejor then
              Msg := Msg + ' RECOMENDADO por fecha compra/venta mas reciente.';
            if Pos('SIMILAR G', Grid.Cells[21, J]) = 0 then
              Grid.Cells[21, J] := Grid.Cells[21, J] + Msg;
            Parts.Clear;
            for C := 0 to Grid.ColCount - 1 do Parts.Add(Grid.Cells[C, J]);
            Rows.Add(Parts.DelimitedText);
          end;
        end;
      end;
    end;

    if Rows.Count = 0 then
    begin
      ShowMessage('No se han detectado similares claros en la vista actual.' + LineEnding +
        'Regla: mismas palabras importantes aunque cambie el orden y cantidades cercanas.');
      Exit;
    end;

    Grid.RowCount := Rows.Count + 1;
    for R := 0 to Rows.Count - 1 do
    begin
      Parts.DelimitedText := Rows[R];
      Dest := R + 1;
      for C := 0 to Grid.ColCount - 1 do
        if C < Parts.Count then Grid.Cells[C, Dest] := Parts[C] else Grid.Cells[C, Dest] := '';
    end;
    lblEstado.Caption := 'Similares detectados: ' + IntToStr(Rows.Count) +
      ' linea(s). Revise grupos, marque duplicados y use Quitar marc. si solo quiere quitarlos de este pedido.';
    FSortCol := -1;
    ActualizarCabecerasOrden;
  finally
    Parts.Free;
    Rows.Free;
  end;
end;


procedure TfPedidoProveedorAuto.SincronizarListasAutoDesdeGrid;
var
  R: Integer;
  Cod: string;

  procedure ActualizarLista(var ALista: TArrayLineaPedidoAuto; const Codigo: string; const Row: Integer);
  var
    J: Integer;
  begin
    for J := Low(ALista) to High(ALista) do
    begin
      if SameText(ALista[J].Codigo, Codigo) then
      begin
        ALista[J].Descripcion := Grid.Cells[3, Row];
        ALista[J].VendidoPeriodo := FloatSeguro(Grid.Cells[4, Row], ALista[J].VendidoPeriodo);
        ALista[J].VendidoTendencia := FloatSeguro(Grid.Cells[5, Row], ALista[J].VendidoTendencia);
        ALista[J].VendidoHistorico := FloatSeguro(Grid.Cells[6, Row], ALista[J].VendidoHistorico);
        ALista[J].VentaDia := FloatSeguro(Grid.Cells[7, Row], ALista[J].VentaDia);
        ALista[J].Sugerido := FloatSeguro(Grid.Cells[8, Row], ALista[J].Sugerido);
        ALista[J].StockContado := FloatSeguro(Grid.Cells[9, Row], ALista[J].StockContado);
        ALista[J].CantidadFinal := FloatSeguro(Grid.Cells[10, Row], ALista[J].CantidadFinal);
        ALista[J].Confianza := Grid.Cells[11, Row];
        ALista[J].Accion := Grid.Cells[12, Row];
        ALista[J].UltVenta := Grid.Cells[13, Row];
        ALista[J].UltCompra := Grid.Cells[14, Row];
        ALista[J].Coste := FloatSeguro(Grid.Cells[15, Row], ALista[J].Coste);
        ALista[J].PVP := FloatSeguro(Grid.Cells[16, Row], ALista[J].PVP);
        ALista[J].IVA := FloatSeguro(Grid.Cells[17, Row], ALista[J].IVA);
        ALista[J].StockInfo := FloatSeguro(Grid.Cells[18, Row], ALista[J].StockInfo);
        ALista[J].Familia := Grid.Cells[19, Row];
        ALista[J].Estado := Grid.Cells[20, Row];
        ALista[J].Observaciones := Grid.Cells[21, Row];
        if Grid.ColCount > 22 then ALista[J].VendidoCobertura := FloatSeguro(Grid.Cells[22, Row], ALista[J].VendidoCobertura);
        if Grid.ColCount > 23 then ALista[J].CompradoUlt4 := FloatSeguro(Grid.Cells[23, Row], ALista[J].CompradoUlt4);
        if Grid.ColCount > 24 then ALista[J].MediaUlt4 := FloatSeguro(Grid.Cells[24, Row], ALista[J].MediaUlt4);
        if Grid.ColCount > 25 then ALista[J].MaxUlt4 := FloatSeguro(Grid.Cells[25, Row], ALista[J].MaxUlt4);
        Exit;
      end;
    end;
  end;

begin
  // Si el usuario ha editado Stock contado / Cantidad final en la vista actual,
  // volcamos esos cambios a las listas internas antes de guardar el estudio completo.
  if not HayDatosEnGrid then Exit;
  for R := 1 to Grid.RowCount - 1 do
  begin
    Cod := Trim(Grid.Cells[2, R]);
    if Cod = '' then Continue;
    ActualizarLista(FAutoPedido, Cod, R);
    ActualizarLista(FAutoRevisar, Cod, R);
    ActualizarLista(FAutoExcluidos, Cod, R);
  end;
end;

function TfPedidoProveedorAuto.FilaTieneRiesgo(const ARow: Integer): Boolean;
var
  Cantidad, Coste, PVP: Double;
  Conf, Accion, EstadoTxt, ObsTxt: string;
begin
  Result := False;
  if (ARow <= 0) or (ARow >= Grid.RowCount) then Exit;
  if Trim(Grid.Cells[2, ARow]) = '' then Exit;

  Cantidad := FloatSeguro(Grid.Cells[10, ARow], 0);
  Coste := FloatSeguro(Grid.Cells[15, ARow], 0);
  PVP := FloatSeguro(Grid.Cells[16, ARow], 0);
  Conf := UpperCase(Trim(Grid.Cells[11, ARow]));
  Accion := UpperCase(Trim(Grid.Cells[12, ARow]));
  EstadoTxt := UpperCase(Trim(Grid.Cells[20, ARow]));
  ObsTxt := UpperCase(Trim(Grid.Cells[21, ARow]));

  // Solo nos interesan riesgos de lineas que podrian entrar al pedido real
  // o lineas que han sido marcadas manualmente como delicadas.
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
    ShowMessage('No hay lineas visibles para analizar riesgos.');
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
      ShowMessage('No se han detectado lineas de riesgo en la vista actual.' + LineEnding +
        'Recuerda que este filtro revisa las lineas visibles con Cantidad final > 0.');
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

    lblEstado.Caption := 'Mostrando solo lineas con riesgo: ' + IntToStr(Rows.Count) +
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
            ' Posible duplicado/articulo partido por descripcion similar con codigo ' +
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
            ' Posible duplicado/articulo partido por descripcion similar con codigo ' +
            Lineas[I].Codigo + '.';
        Lineas[J].Prioridad := Lineas[J].Prioridad - 30000;
      end;
    end;
  end;
end;


procedure TfPedidoProveedorAuto.AnadirLineaManualAlGrid(const L: TLineaPedidoAuto);
var
  R: Integer;
begin
  if (Grid.RowCount = 2) and (Trim(Grid.Cells[2, 1]) = '') then
    R := 1
  else
  begin
    R := Grid.RowCount;
    Grid.RowCount := Grid.RowCount + 1;
  end;

  Grid.Cells[2, R] := L.Codigo;
  Grid.Cells[3, R] := L.Descripcion;
  Grid.Cells[4, R] := FormatFloat('0.##', L.VendidoPeriodo);
  Grid.Cells[5, R] := FormatFloat('0.##', L.VendidoTendencia);
  Grid.Cells[6, R] := FormatFloat('0.##', L.VendidoHistorico);
  Grid.Cells[7, R] := FormatFloat('0.####', L.VentaDia);
  Grid.Cells[8, R] := FormatFloat('0.##', L.Sugerido);
  Grid.Cells[9, R] := '';
  Grid.Cells[10, R] := FormatFloat('0.##', L.CantidadFinal);
  Grid.Cells[11, R] := L.Confianza;
  Grid.Cells[12, R] := L.Accion;
  Grid.Cells[13, R] := L.UltVenta;
  Grid.Cells[14, R] := L.UltCompra;
  Grid.Cells[15, R] := FormatFloat('0.000', L.Coste);
  Grid.Cells[16, R] := FormatFloat('0.00', L.PVP);
  Grid.Cells[17, R] := FormatFloat('0.##', L.IVA);
  Grid.Cells[18, R] := FormatFloat('0.##', L.StockInfo);
  Grid.Cells[19, R] := L.Familia;
  Grid.Cells[20, R] := L.Estado;
  Grid.Cells[21, R] := L.Observaciones;
  if Grid.ColCount > 22 then Grid.Cells[22, R] := FormatFloat('0.##', L.VendidoCobertura);
  if Grid.ColCount > 23 then Grid.Cells[23, R] := FormatFloat('0.##', L.CompradoUlt4);
  if Grid.ColCount > 24 then Grid.Cells[24, R] := FormatFloat('0.##', L.MediaUlt4);
  if Grid.ColCount > 25 then Grid.Cells[25, R] := FormatFloat('0.##', L.MaxUlt4);
  Grid.Cells[0, R] := IntToStr(R);
  Grid.Cells[1, R] := '';
  AutoAjustarColumnas;
end;

procedure TfPedidoProveedorAuto.EliminarManualDeListas(const Codigo: string);

  procedure EliminarDeLista(var ALista: TArrayLineaPedidoAuto);
  var
    I, J, N: Integer;
    Obs: string;
  begin
    I := Low(ALista);
    while I <= High(ALista) do
    begin
      Obs := UpperCase(ALista[I].Accion + ' ' + ALista[I].Estado + ' ' + ALista[I].Observaciones);
      if SameText(ALista[I].Codigo, Codigo) and (Pos('MANUAL', Obs) > 0) then
      begin
        N := Length(ALista);
        for J := I to N - 2 do
          ALista[J] := ALista[J + 1];
        SetLength(ALista, N - 1);
      end
      else
        Inc(I);
    end;
  end;

begin
  if Codigo = '' then Exit;
  EliminarDeLista(FAutoPedido);
  EliminarDeLista(FAutoRevisar);
  EliminarDeLista(FAutoExcluidos);
end;

procedure TfPedidoProveedorAuto.QuitarLineaManualSeleccionada;
var
  R, C, I: Integer;
  Cod, Marca: string;
begin
  if (Grid.Row <= 0) or (Grid.Row >= Grid.RowCount) then
  begin
    ShowMessage('Seleccione una linea manual para quitar.');
    Exit;
  end;

  R := Grid.Row;
  Cod := Trim(Grid.Cells[2, R]);
  Marca := UpperCase(Grid.Cells[12, R] + ' ' + Grid.Cells[20, R] + ' ' + Grid.Cells[21, R]);
  if (Cod = '') or (Pos('MANUAL', Marca) = 0) then
  begin
    ShowMessage('La linea seleccionada no parece una linea manual.' + LineEnding +
      'Para no romper el estudio automatico, solo se quitan desde aqui las lineas anadidas manualmente.');
    Exit;
  end;

  EliminarManualDeListas(Cod);

  for I := R to Grid.RowCount - 2 do
    for C := 0 to Grid.ColCount - 1 do
      Grid.Cells[C, I] := Grid.Cells[C, I + 1];

  if Grid.RowCount > 2 then
    Grid.RowCount := Grid.RowCount - 1
  else
    Grid.Rows[1].Clear;

  lblEstado.Caption := 'Linea manual quitada: ' + Cod + '. No se ha tocado ningun pedido real.';
end;

procedure TfPedidoProveedorAuto.BtnAnadirManualClick(Sender: TObject);
var
  TextoBusqueda, CantTxt: string;
  Cantidad: Double;
  Q: TZQuery;
  TArti: string;
  L: TLineaPedidoAuto;
  CodProv: Integer;
begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then
  begin
    ShowMessage('Seleccione un proveedor antes de anadir lineas manuales.');
    Exit;
  end;

  TextoBusqueda := '';
  if not InputQuery('Anadir linea manual', 'Codigo o texto de descripcion:', TextoBusqueda) then Exit;
  TextoBusqueda := Trim(TextoBusqueda);
  if TextoBusqueda = '' then Exit;

  CantTxt := '1';
  if not InputQuery('Anadir linea manual', 'Cantidad final a pedir:', CantTxt) then Exit;
  Cantidad := FloatSeguro(CantTxt, 0);
  if Cantidad <= 0 then
  begin
    ShowMessage('La cantidad debe ser mayor que cero.');
    Exit;
  end;

  TArti := 'artitien' + FTienda;
  if not TablaExiste(TArti) then
  begin
    ShowMessage('No existe la tabla de articulos: ' + TArti);
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT A0, A1, A2, A3, A4, A13, A14, A24 FROM `' + TArti + '` ' +
      'WHERE A0 = :cod OR A1 LIKE :txt ORDER BY CASE WHEN A0 = :cod2 THEN 0 ELSE 1 END, A1 LIMIT 1';
    Q.ParamByName('cod').AsString := TextoBusqueda;
    Q.ParamByName('cod2').AsString := TextoBusqueda;
    Q.ParamByName('txt').AsString := '%' + TextoBusqueda + '%';
    Q.Open;
    if Q.EOF then
    begin
      ShowMessage('No he encontrado ningun articulo con ese codigo o descripcion.' + LineEnding +
        'De momento la busqueda manual mira codigo principal y descripcion.');
      Exit;
    end;

    L.Codigo := Q.FieldByName('A0').AsString;
    L.Descripcion := Q.FieldByName('A1').AsString;
    L.VendidoPeriodo := 0;
    L.VendidoTendencia := 0;
    L.VendidoHistorico := 0;
    L.VendidoCobertura := 0;
    L.VentaDia := 0;
    L.Sugerido := Cantidad;
    L.StockContado := 0;
    L.CantidadFinal := Cantidad;
    L.UltVenta := '';
    L.CompradoUlt4 := 0;
    L.MediaUlt4 := 0;
    L.MaxUlt4 := 0;
    L.UltCompraUds := 0;
    if not Q.FieldByName('A13').IsNull then
      L.UltCompra := DateToStr(Q.FieldByName('A13').AsDateTime)
    else
      L.UltCompra := '';
    L.Coste := Q.FieldByName('A24').AsFloat;
    L.PVP := Q.FieldByName('A2').AsFloat;
    L.IVA := Q.FieldByName('A3').AsFloat;
    L.StockInfo := Q.FieldByName('A4').AsFloat;
    L.Familia := Q.FieldByName('A14').AsString;
    L.Estado := 'MANUAL';
    L.Confianza := 'ALTA';
    L.Accion := 'MANUAL';
    L.Observaciones := 'Linea anadida manualmente por usuario. Revisar cantidad, coste y proveedor antes de crear pedido real.';
    L.Prioridad := 99999999;

    AddLineaAuto(FAutoPedido, L);
    AnadirLineaManualAlGrid(L);
    lblEstado.Caption := 'Linea manual anadida: ' + L.Codigo + ' - ' + L.Descripcion +
      '. Entrara al pedido real si queda visible y Cantidad final > 0.';
    LogPedidoAuto('Linea manual anadida proveedor=' + IntToStr(CodProv) + ' codigo=' + L.Codigo + ' cantidad=' + FormatFloat('0.##', Cantidad));
  except
    on E: Exception do
    begin
      LogErrorPedidoAuto('BtnAnadirManualClick', E);
      ShowMessage('Error anadiendo linea manual:' + LineEnding + E.Message);
    end;
  end;
  Q.Free;
end;

procedure TfPedidoProveedorAuto.BtnQuitarManualClick(Sender: TObject);
begin
  QuitarLineaManualSeleccionada;
end;

procedure TfPedidoProveedorAuto.MostrarCompraSegura;
var
  Seguras: TArrayLineaPedidoAuto;
  I: Integer;
  N: Integer;
  L: TLineaPedidoAuto;
  ObsUpper: string;
begin
  SetLength(Seguras, 0);

  for I := Low(FAutoPedido) to High(FAutoPedido) do
  begin
    L := FAutoPedido[I];
    ObsUpper := UpperCase(L.Observaciones + ' ' + L.Estado + ' ' + L.Accion);

    if not SameText(L.Confianza, 'ALTA') then Continue;
    if L.CantidadFinal <= 0 then Continue;
    if L.Coste <= 0 then Continue;
    if L.PVP >= 999 then Continue;
    if Pos('ROTURA', ObsUpper) > 0 then Continue;
    if Pos('EQUIVAL', ObsUpper) > 0 then Continue;
    if Pos('DUPLIC', ObsUpper) > 0 then Continue;
    if Pos('REVISAR', ObsUpper) > 0 then Continue;
    if Pos('POCAS VENTAS', ObsUpper) > 0 then Continue;

    N := Length(Seguras);
    SetLength(Seguras, N + 1);
    Seguras[N] := L;
  end;

  PintarLineasEnGrid(Seguras, 0);
  lblEstado.Caption := 'Compra segura: ' + IntToStr(Length(Seguras)) +
    ' linea(s). Son ALTA sin riesgos basicos. Revise Ver dudas/Ver riesgos antes de crear pedido real.';
end;

procedure TfPedidoProveedorAuto.BtnPedidoAutoClick(Sender: TObject);
begin
  FUsarReposicionUlt4 := False;
  FUsarReposicionReal := False;
  CalcularAutoProveedor;
end;

procedure TfPedidoProveedorAuto.BtnReposicionUlt4Click(Sender: TObject);
begin
  // Modo existente: se mantiene como antes. Usa ultimos N pedidos como candidatos
  // y la referencia de compras, pero no descuenta saldo teorico compras-ventas.
  FUsarReposicionUlt4 := True;
  FUsarReposicionReal := False;
  try
    CalcularAutoProveedor;
    if HayDatosEnGrid then
      if chkUsarComprasUlt4Ref.Checked then
        lblEstado.Caption := lblEstado.Caption + ' Modo Repos. pedidos (' + IntToStr(seNumPedidosHist.Value) + ') con referencia de compras.'
      else
        lblEstado.Caption := lblEstado.Caption + ' Modo Repos. pedidos (' + IntToStr(seNumPedidosHist.Value) + '): candidatos limitados a historial reciente, sin referencia de unidades compradas.';
  finally
    FUsarReposicionUlt4 := False;
    FUsarReposicionReal := False;
  end;
end;

procedure TfPedidoProveedorAuto.BtnReposicionRealClick(Sender: TObject);
begin
  // Nuevo modo: parte de Repos. pedidos, pero cruza compras recientes y ventas
  // de cobertura para calcular un saldo teorico y evitar compras innecesarias.
  FUsarReposicionUlt4 := True;
  FUsarReposicionReal := True;
  try
    CalcularAutoProveedor;
    if HayDatosEnGrid then
      if chkUsarComprasUlt4Ref.Checked then
        lblEstado.Caption := lblEstado.Caption + ' Modo Repos. real (' + IntToStr(seNumPedidosHist.Value) + ' pedidos): ventas a cubrir - compras recientes, con saldo teorico.'
      else
        lblEstado.Caption := lblEstado.Caption + ' Modo Repos. real (' + IntToStr(seNumPedidosHist.Value) + ' pedidos): ventas a cubrir, sin descontar referencia de compras.';
  finally
    FUsarReposicionUlt4 := False;
    FUsarReposicionReal := False;
  end;
end;

procedure TfPedidoProveedorAuto.BtnVerAutoClick(Sender: TObject);
begin
  PintarListaAuto(FAutoPedido, 'Pedido automatico de alta confianza');
end;

procedure TfPedidoProveedorAuto.BtnVerCompraSeguraClick(Sender: TObject);
begin
  MostrarCompraSegura;
end;

procedure TfPedidoProveedorAuto.BtnVerRiesgosClick(Sender: TObject);
begin
  MostrarSoloLineasRiesgo;
end;

procedure TfPedidoProveedorAuto.BtnVerRevisarClick(Sender: TObject);
begin
  PintarListaAuto(FAutoRevisar, 'Lineas a revisar');
end;

procedure TfPedidoProveedorAuto.BtnVerExcluidosClick(Sender: TObject);
begin
  PintarListaAuto(FAutoExcluidos, 'Lineas excluidas');
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
  VentasCobertura: Double;
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
  PocasVentasARevisar: Boolean;
  UmbralPocasVentas: Integer;
  ForzarPocasVentasARevisar: Boolean;
  UsarComprasUlt4Ref: Boolean;
  CompradoUlt4: Double;
  MediaUlt4: Double;
  MaxUlt4: Double;
  UltCompraUds: Double;
  NumPedidosHist: Integer;
  SaldoTeorico: Double;
  SugeridoAntesAjuste: Double;

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

  PocasVentasARevisar := chkPocasVentasARevisar.Checked;
  UmbralPocasVentas := seUmbralPocasVentas.Value;
  if UmbralPocasVentas < 1 then UmbralPocasVentas := 1;
  UsarComprasUlt4Ref := FUsarReposicionUlt4 and chkUsarComprasUlt4Ref.Checked;
  NumPedidosHist := seNumPedidosHist.Value;
  if NumPedidosHist < 1 then NumPedidosHist := 1;
  if NumPedidosHist > 20 then NumPedidosHist := 20;

  FechaHasta := Date;
  FechaDesdeVentas := IncDay(FechaHasta, -seDiasVentas.Value + 1);
  FechaDesdeHistorico := IncDay(FechaDesdeVentas, -seDiasHistorico.Value);

  SQL := SQLFinal(CodProv, FechaDesdeHistorico, FechaHasta);
  if SQL = '' then Exit;

  VaciarListasAuto;
  InicializarGrid;
  ProgresoInicio('Calculando pedido automatico para ' + NombreProveedorSeleccionado +
    '... cobertura real ' + IntToStr(DiasCoberturaAuto) + ' dias.', 100);

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
        ProgresoPaso('Analizando pedido automatico... ' + IntToStr(TotalLeidas) + ' articulos leidos', -1);
      VentasCobertura := Q.FieldByName('VENTAS_COBERTURA').AsFloat;
      VentasPeriodo := Q.FieldByName('VENTAS_PERIODO').AsFloat;
      VentasTendencia := Q.FieldByName('VENTAS_TENDENCIA').AsFloat;
      VentasHistorico := Q.FieldByName('VENTAS_HISTORICO').AsFloat;
      ForzarPocasVentasARevisar := False;

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
            FormatFloat('0.####', VentaDiaPeriodo) + '/dia; tendencia ' +
            FormatFloat('0.####', VentaDiaTendencia) + '/dia.';
        end
        else
        begin
          Estado := 'VENTA RECIENTE';
          Obs := 'Auto: venta reciente. Media ' +
            FormatFloat('0.####', VentaDiaPeriodo) + '/dia.';
        end;
      end
      else if chkIncluirRoturas.Checked and (VentasHistorico >= MinHistorico) then
      begin
        VentaDia := VentasHistorico / seDiasHistorico.Value;
        Estado := 'POSIBLE ROTURA STOCK';
        Obs := 'Auto: sin venta reciente, pero historico suficiente. Va a revisar, no entra ciego.';
      end
      else
      begin
        VentaDia := 0;
        Estado := 'SIN VENTA';
        Obs := 'Auto: sin venta util para pedido automatico.';
      end;

      Sugerido := RedondearArriba(VentaDia * DiasCoberturaAuto * Factor);
      CompradoUlt4 := Q.FieldByName('COMPRADO_ULT4').AsFloat;
      MediaUlt4 := Q.FieldByName('MEDIA_ULT4').AsFloat;
      MaxUlt4 := Q.FieldByName('MAX_ULT4').AsFloat;
      UltCompraUds := Q.FieldByName('ULT_COMPRA_UDS').AsFloat;

      if FUsarReposicionReal and (VentasCobertura > 0) then
      begin
        Obs := Obs + ' Venta cobertura real (' + IntToStr(DiasCoberturaAuto) +
          ' dias): ' + FormatFloat('0.##', VentasCobertura) + ' uds.';

        if chkUsarComprasUlt4Ref.Checked and (CompradoUlt4 > 0) then
        begin
          SaldoTeorico := CompradoUlt4 - VentasCobertura;
          Obs := Obs + ' Saldo teorico compras-ventas: ' +
            FormatFloat('0.##', CompradoUlt4) + ' compradas - ' +
            FormatFloat('0.##', VentasCobertura) + ' vendidas = ' +
            FormatFloat('0.##', SaldoTeorico) + ' uds.';

          if (Sugerido > 0) and (SaldoTeorico >= Sugerido) then
          begin
            Sugerido := 0;
            Obs := Obs + ' Saldo teorico suficiente: no propone compra.';
          end
          else if (Sugerido > 0) and (SaldoTeorico > 0) then
          begin
            SugeridoAntesAjuste := Sugerido;
            Sugerido := RedondearArriba(Sugerido - SaldoTeorico);
            if Sugerido < 0 then Sugerido := 0;
            Obs := Obs + ' Ajuste real: sugerido ' + FormatFloat('0.##', SugeridoAntesAjuste) +
              ' - saldo ' + FormatFloat('0.##', SaldoTeorico) +
              ' = ' + FormatFloat('0.##', Sugerido) + ' uds.';
          end
          else if (SaldoTeorico <= 0) and (VentasCobertura > Sugerido) then
          begin
            Sugerido := RedondearArriba(VentasCobertura * Factor);
            Obs := Obs + ' Compras recientes no cubren la venta: se usa como minimo la venta de esos dias a cubrir.';
          end;
        end
        else if VentasCobertura > Sugerido then
        begin
          Sugerido := RedondearArriba(VentasCobertura * Factor);
          Obs := Obs + ' Reposicion real: se usa como minimo la venta de esos dias a cubrir.';
        end;
      end;
      Coste := Q.FieldByName('ULT_COSTE').AsFloat;
      if Coste <= 0 then
        Coste := Q.FieldByName('COSTE_FICHA').AsFloat;
      StockInfo := Q.FieldByName('STOCK_INFO').AsFloat;
      PVP := Q.FieldByName('PVP').AsFloat;
      CompradoUlt4 := Q.FieldByName('COMPRADO_ULT4').AsFloat;
      MediaUlt4 := Q.FieldByName('MEDIA_ULT4').AsFloat;
      MaxUlt4 := Q.FieldByName('MAX_ULT4').AsFloat;
      UltCompraUds := Q.FieldByName('ULT_COMPRA_UDS').AsFloat;

      UltCompra := '';
      if not Q.FieldByName('ULT_COMPRA').IsNull then
        UltCompra := DateToStr(Q.FieldByName('ULT_COMPRA').AsDateTime)
      else if not Q.FieldByName('ULT_COMPRA_FICHA').IsNull then
        UltCompra := DateToStr(Q.FieldByName('ULT_COMPRA_FICHA').AsDateTime);

      UltVenta := '';
      if not Q.FieldByName('ULT_VENTA').IsNull then
        UltVenta := DateToStr(Q.FieldByName('ULT_VENTA').AsDateTime);

      if UltCompra <> '' then
        Obs := Obs + ' Articulo comprado/pedido anteriormente a este proveedor; ultima compra ' + UltCompra + '.'
      else
        Obs := Obs + ' Articulo encontrado en pedidos/compras anteriores de este proveedor.';

      if FUsarReposicionUlt4 then
      begin
        if FUsarReposicionReal then
          Obs := Obs + ' Modo Repos. real: candidato por aparecer en los ultimos ' + IntToStr(NumPedidosHist) + ' pedidos historicos del proveedor.'
        else
          Obs := Obs + ' Modo Repos. pedidos: candidato por aparecer en los ultimos ' + IntToStr(NumPedidosHist) + ' pedidos historicos del proveedor.';
        if CompradoUlt4 > 0 then
          Obs := Obs + ' Compras ' + IntToStr(NumPedidosHist) + 'P: total ' + FormatFloat('0.##', CompradoUlt4) +
            ', media pedido ' + FormatFloat('0.##', MediaUlt4) +
            ', max pedido ' + FormatFloat('0.##', MaxUlt4) + '.';
      end;

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

      if UsarComprasUlt4Ref and (CompradoUlt4 > 0) then
      begin
        if (Sugerido > 0) and (MediaUlt4 > 0) and
          (Sugerido >= (MediaUlt4 * 0.50)) and
          (Sugerido <= Max(MediaUlt4 * 1.50, MediaUlt4 + 2)) then
        begin
          Inc(Score, 5);
          Obs := Obs + ' Referencia compras pedidos coherente con ventas.';
        end;

        if (Sugerido > 0) and (MaxUlt4 > 0) and
          (Sugerido > (MaxUlt4 * 1.75)) then
        begin
          if Score > 79 then Score := 79;
          Obs := Obs + ' Sugerido muy superior al maximo comprado en los ultimos ' + IntToStr(NumPedidosHist) + ' pedidos: revisar antes de comprar.';
        end;

        if (Sugerido > 0) and (MediaUlt4 >= 5) and
          (Sugerido < (MediaUlt4 * 0.35)) then
        begin
          if Score > 79 then Score := 79;
          Obs := Obs + ' Antes se compraba bastante mas que lo que ahora sugieren las ventas: revisar por posible stock acumulado, cambio o sustitucion.';
        end;
      end;

      if PocasVentasARevisar and (VentasPeriodo > 0) and
        (VentasPeriodo < UmbralPocasVentas) then
      begin
        ForzarPocasVentasARevisar := True;
        if Score < 50 then Score := 50;
        if Score > 79 then Score := 79;
        Obs := Obs + ' Pocas ventas recientes (' + FormatFloat('0.##', VentasPeriodo) +
          ' < ' + IntToStr(UmbralPocasVentas) + '): pasa a revisar para evitar pedido ciego.';
      end;

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
      L.VendidoCobertura := VentasCobertura;
      L.VentaDia := VentaDia;
      L.Sugerido := Sugerido;
      L.StockContado := 0;
      L.CantidadFinal := Sugerido;
      L.UltVenta := UltVenta;
      L.UltCompra := UltCompra;
      L.CompradoUlt4 := CompradoUlt4;
      L.MediaUlt4 := MediaUlt4;
      L.MaxUlt4 := MaxUlt4;
      L.UltCompraUds := UltCompraUds;
      L.Coste := Coste;
      L.PVP := PVP;
      L.IVA := Q.FieldByName('IVA').AsFloat;
      L.StockInfo := StockInfo;
      L.Familia := Q.FieldByName('FAMILIA').AsString;
      L.Estado := Estado;
      L.Observaciones := Obs + ' Formula auto: ' + FormatFloat('0.####', VentaDia) +
        '/dia x ' + IntToStr(DiasCoberturaAuto) + ' dias x factor ' +
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

      if ForzarPocasVentasARevisar and
        (not SameText(DecisionGuardada, 'ACEPTAR')) and
        not ((PrincipalEquivalente <> '') and (not SameText(PrincipalEquivalente, L.Codigo))) then
      begin
        L.Confianza := 'MEDIA';
        L.Accion := 'REVISAR POCAS VENTAS';
        if Pos('POCAS VENTAS', UpperCase(L.Estado)) = 0 then
          L.Estado := L.Estado + ' / POCAS VENTAS';
      end;

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
      Todas[I].Observaciones := Todas[I].Observaciones + ' Pasada a revisar por superar el maximo de lineas auto.';
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
  PintarListaAuto(FAutoPedido, 'Pedido automatico ALTA confianza');
  ProgresoFin('Auto proveedor: pedido ' + IntToStr(Length(FAutoPedido)) +
    ', revisar ' + IntToStr(Length(FAutoRevisar)) + ', excluidos ' +
    IntToStr(Length(FAutoExcluidos)) + '. Leidas: ' + IntToStr(TotalLeidas) +
    '. Cobertura real: ' + IntToStr(DiasCoberturaAuto) + ' dias. Use Ver dudas antes de crear/mandar pedido.');
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
            ProgresoFin('PDF generado correctamente, pero no se pudo abrir automaticamente.');
            ShowMessage('PDF generado correctamente, pero no se pudo abrir automaticamente.' + LineEnding +
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
    'Se imprimira la propuesta actual en formato horizontal.' + LineEnding +
    '?Desea continuar?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
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
        Cmp := CompararCeldas(Grid.Cells[19, I], Grid.Cells[19, J], 19);
        if Cmp = 0 then
          Cmp := CompararCeldas(Grid.Cells[3, I], Grid.Cells[3, J], 3);

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
  lblEstado.Caption := 'Ordenado para revisar tienda: familia + descripcion. El PDF e impresion respetaran este orden.';
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
  if (Grid.Row > 0) and (Grid.Col in [9, 10]) then
  begin
    if Grid.Col = 9 then
      RecalcularCantidadFinalFila(Grid.Row)
    else
      Grid.Cells[10, Grid.Row] := FormatFloat('0.##', Max(0, FloatSeguro(Grid.Cells[10, Grid.Row], 0)));
  end;
end;


function TfPedidoProveedorAuto.ColSel: Integer;
begin
  Result := 1;
end;

function TfPedidoProveedorAuto.FilaMarcada(const ARow: Integer): Boolean;
begin
  Result := False;
  if (Grid = nil) or (ARow <= 0) or (ARow >= Grid.RowCount) then Exit;
  Result := Trim(Grid.Cells[ColSel, ARow]) <> '';
end;

procedure TfPedidoProveedorAuto.MarcarFila(const ARow: Integer; const AMarcada: Boolean);
begin
  if (Grid = nil) or (ARow <= 0) or (ARow >= Grid.RowCount) then Exit;
  if Trim(Grid.Cells[2, ARow]) = '' then Exit;
  if AMarcada then
    Grid.Cells[ColSel, ARow] := 'X'
  else
    Grid.Cells[ColSel, ARow] := '';
end;

procedure TfPedidoProveedorAuto.DesmarcarTodasLasLineas;
var
  R: Integer;
begin
  if Grid = nil then Exit;
  for R := 1 to Grid.RowCount - 1 do
    Grid.Cells[ColSel, R] := '';
end;

function TfPedidoProveedorAuto.ContarMarcadas: Integer;
var
  R: Integer;
begin
  Result := 0;
  if Grid = nil then Exit;
  for R := 1 to Grid.RowCount - 1 do
    if FilaMarcada(R) then Inc(Result);
end;

function TfPedidoProveedorAuto.HayMarcadas: Boolean;
begin
  Result := ContarMarcadas > 0;
end;

procedure TfPedidoProveedorAuto.BtnDesmarcarTodasClick(Sender: TObject);
begin
  DesmarcarTodasLasLineas;
  lblEstado.Caption := 'Seleccion limpia.';
end;

procedure TfPedidoProveedorAuto.BtnQuitarAhoraClick(Sender: TObject);
begin
  if (Grid.Row <= 0) or (Grid.Row >= Grid.RowCount) or (Trim(Grid.Cells[2, Grid.Row]) = '') then
  begin
    ShowMessage('Seleccione una linea para quitar solo de este pedido.');
    Exit;
  end;
  MarcarFila(Grid.Row, True);
  AplicarAccionMarcadas('QUITAR');
end;

procedure TfPedidoProveedorAuto.BtnQuitarMarcadasClick(Sender: TObject);
begin
  AplicarAccionMarcadas('QUITAR');
end;

procedure TfPedidoProveedorAuto.BtnRevisarMarcadasClick(Sender: TObject);
begin
  AplicarAccionMarcadas('REVISAR');
end;

procedure TfPedidoProveedorAuto.BtnExcluirMarcadasClick(Sender: TObject);
begin
  AplicarAccionMarcadas('EXCLUIR');
end;

procedure TfPedidoProveedorAuto.BtnVerQuitadasClick(Sender: TObject);
begin
  MostrarLineasQuitadas;
end;

procedure TfPedidoProveedorAuto.BtnVerSimilaresClick(Sender: TObject);
begin
  MostrarSimilaresVisibles;
end;

procedure TfPedidoProveedorAuto.AplicarAccionMarcadas(const AAccion: string);
var
  R, C, N, OldRow, Dest: Integer;
  Obs: string;
  Rows, Parts: TStringList;
begin
  if not HayDatosEnGrid then
  begin
    ShowMessage('No hay lineas visibles.');
    Exit;
  end;

  if not HayMarcadas then
  begin
    if (Grid.Row > 0) and (Grid.Row < Grid.RowCount) and (Trim(Grid.Cells[2, Grid.Row]) <> '') then
      MarcarFila(Grid.Row, True)
    else
    begin
      ShowMessage('Marque lineas en la columna Sel o seleccione una linea.');
      Exit;
    end;
  end;

  N := ContarMarcadas;
  if SameText(AAccion, 'EXCLUIR') then
    if MessageDlg('Excluir siempre', 'Va a guardar EXCLUIR SIEMPRE para ' + IntToStr(N) +
      ' articulo(s). Esto es una regla permanente para este proveedor.' + LineEnding +
      'Use Quitar marc. si solo quiere quitarlos de este pedido. Continuar?',
      mtWarning, [mbYes, mbNo], 0) <> mrYes then Exit;

  OldRow := Grid.Row;
  for R := 1 to Grid.RowCount - 1 do
  begin
    if not FilaMarcada(R) then Continue;
    Obs := Grid.Cells[21, R];
    if SameText(AAccion, 'QUITAR') then
    begin
      Grid.Cells[10, R] := '0';
      Grid.Cells[12, R] := 'QUITADO AHORA';
      Grid.Cells[20, R] := 'QUITADO';
      if Pos('Quitado solo de este pedido', Obs) = 0 then
        Grid.Cells[21, R] := Obs + ' Quitado solo de este pedido; no crea regla permanente.';
    end
    else if SameText(AAccion, 'REVISAR') then
    begin
      Grid.Cells[11, R] := 'MEDIA';
      Grid.Cells[12, R] := 'REVISAR AHORA';
      Grid.Cells[20, R] := 'REVISAR';
      if Pos('Pasado a revisar en este estudio', Obs) = 0 then
        Grid.Cells[21, R] := Obs + ' Pasado a revisar en este estudio por seleccion multiple.';
    end
    else if SameText(AAccion, 'EXCLUIR') then
    begin
      Grid.Row := R;
      GuardarDecisionArticulo('EXCLUIR');
      Grid.Cells[10, R] := '0';
      Grid.Cells[20, R] := 'EXCLUIDO';
    end;
    Grid.Cells[ColSel, R] := '';
  end;
  if (OldRow > 0) and (OldRow < Grid.RowCount) then Grid.Row := OldRow;
  SincronizarListasAutoDesdeGrid;

  // Quitar ahora debe ocultar del listado actual. La linea sigue guardada internamente
  // y se puede consultar desde Ver quitadas.
  if SameText(AAccion, 'QUITAR') then
  begin
    Rows := TStringList.Create;
    Parts := TStringList.Create;
    try
      Parts.StrictDelimiter := True;
      Parts.Delimiter := #9;
      for R := 1 to Grid.RowCount - 1 do
      begin
        if Trim(Grid.Cells[2, R]) = '' then Continue;
        if Pos('QUITADO', UpperCase(Grid.Cells[12, R] + ' ' + Grid.Cells[20, R] + ' ' + Grid.Cells[21, R])) > 0 then
          Continue;
        Parts.Clear;
        for C := 0 to Grid.ColCount - 1 do Parts.Add(Grid.Cells[C, R]);
        Rows.Add(Parts.DelimitedText);
      end;

      Grid.RowCount := Max(2, Rows.Count + 1);
      for R := 1 to Grid.RowCount - 1 do Grid.Rows[R].Clear;
      for R := 0 to Rows.Count - 1 do
      begin
        Parts.DelimitedText := Rows[R];
        Dest := R + 1;
        for C := 0 to Grid.ColCount - 1 do
          if C < Parts.Count then Grid.Cells[C, Dest] := Parts[C] else Grid.Cells[C, Dest] := '';
        Grid.Cells[0, Dest] := IntToStr(Dest);
        Grid.Cells[1, Dest] := '';
      end;
      if Grid.RowCount > 1 then
      begin
        Grid.Row := 1;
        if Grid.ColCount > 2 then Grid.Col := 2;
      end;
    finally
      Parts.Free;
      Rows.Free;
    end;
    lblEstado.Caption := 'QUITAR aplicado a ' + IntToStr(N) + ' linea(s). Ocultadas del listado actual; use Ver quitadas para consultarlas.';
  end
  else
    lblEstado.Caption := AAccion + ' aplicado a ' + IntToStr(N) + ' linea(s).';
end;

procedure TfPedidoProveedorAuto.MostrarLineasQuitadas;
var
  R, C, Dest: Integer;
  Rows, Parts, Codigos: TStringList;

  procedure AddLineaQuitada(const L: TLineaPedidoAuto);
  var
    K: string;
  begin
    if not LineaAutoQuitada(L) then Exit;
    K := UpperCase(Trim(L.Codigo));
    if K = '' then Exit;
    if Codigos.IndexOf(K) >= 0 then Exit;
    Codigos.Add(K);

    Parts.Clear;
    Parts.Add('');
    Parts.Add('');
    Parts.Add(L.Codigo);
    Parts.Add(L.Descripcion);
    Parts.Add(FormatFloat('0.##', L.VendidoPeriodo));
    Parts.Add(FormatFloat('0.##', L.VendidoTendencia));
    Parts.Add(FormatFloat('0.##', L.VendidoHistorico));
    Parts.Add(FormatFloat('0.####', L.VentaDia));
    Parts.Add(FormatFloat('0.##', L.Sugerido));
    if Abs(L.StockContado) > 0.0001 then
      Parts.Add(FormatFloat('0.##', L.StockContado))
    else
      Parts.Add('');
    Parts.Add(FormatFloat('0.##', L.CantidadFinal));
    Parts.Add(L.Confianza);
    Parts.Add(L.Accion);
    Parts.Add(L.UltVenta);
    Parts.Add(L.UltCompra);
    Parts.Add(FormatFloat('0.000', L.Coste));
    Parts.Add(FormatFloat('0.00', L.PVP));
    Parts.Add(FormatFloat('0.##', L.IVA));
    Parts.Add(FormatFloat('0.##', L.StockInfo));
    Parts.Add(L.Familia);
    Parts.Add(L.Estado);
    Parts.Add(L.Observaciones);
    Parts.Add(FormatFloat('0.##', L.VendidoCobertura));
    Parts.Add(FormatFloat('0.##', L.CompradoUlt4));
    Parts.Add(FormatFloat('0.##', L.MediaUlt4));
    Parts.Add(FormatFloat('0.##', L.MaxUlt4));
    Rows.Add(Parts.DelimitedText);
  end;

  procedure AddListaQuitadas(const ALista: TArrayLineaPedidoAuto);
  var
    I: Integer;
  begin
    for I := Low(ALista) to High(ALista) do
      AddLineaQuitada(ALista[I]);
  end;

begin
  Rows := TStringList.Create;
  Parts := TStringList.Create;
  Codigos := TStringList.Create;
  try
    Parts.StrictDelimiter := True;
    Parts.Delimiter := #9;
    Codigos.Sorted := True;
    Codigos.Duplicates := dupIgnore;

    // Las quitadas pueden estar ya ocultas del grid, asi que se leen desde las listas internas.
    AddListaQuitadas(FAutoPedido);
    AddListaQuitadas(FAutoRevisar);
    AddListaQuitadas(FAutoExcluidos);

    if Rows.Count = 0 then
    begin
      ShowMessage('No hay lineas quitadas en el pedido actual.');
      Exit;
    end;

    InicializarGrid;
    Grid.RowCount := Rows.Count + 1;
    for R := 0 to Rows.Count - 1 do
    begin
      Parts.DelimitedText := Rows[R];
      Dest := R + 1;
      for C := 0 to Grid.ColCount - 1 do
        if C < Parts.Count then Grid.Cells[C, Dest] := Parts[C] else Grid.Cells[C, Dest] := '';
      Grid.Cells[0, Dest] := IntToStr(Dest);
      Grid.Cells[1, Dest] := '';
    end;
    lblEstado.Caption := 'Mostrando lineas quitadas solo de este pedido: ' + IntToStr(Rows.Count) + '.';
  finally
    Codigos.Free;
    Parts.Free;
    Rows.Free;
  end;
end;

procedure TfPedidoProveedorAuto.GridSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect := True;

  if (aRow > 0) and (aCol = ColSel) then
  begin
    Grid.Options := Grid.Options - [goEditing];
    if not FSuppressSelToggle then
    begin
      MarcarFila(aRow, not FilaMarcada(aRow));
      lblEstado.Caption := 'Lineas marcadas: ' + IntToStr(ContarMarcadas) + '. Use Quitar marc., Revisar marc. o Excluir marc.';
    end;
    Exit;
  end;

  // Solo dejamos editar Stock contado y Cantidad final. El resto queda como tabla de consulta.
  if (aRow > 0) and (aCol in [9, 10]) then
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

  Sugerido := FloatSeguro(Grid.Cells[8, ARow], 0);

  if Trim(Grid.Cells[9, ARow]) = '' then
    CantidadFinal := Sugerido
  else
  begin
    StockContado := FloatSeguro(Grid.Cells[9, ARow], 0);
    CantidadFinal := Sugerido - StockContado;
    if CantidadFinal < 0 then
      CantidadFinal := 0;
    CantidadFinal := RedondearArriba(CantidadFinal);
  end;

  Grid.Cells[10, ARow] := FormatFloat('0.##', CantidadFinal);
end;

procedure TfPedidoProveedorAuto.RecalcularTodasCantidadesFinales;
var
  R: Integer;
begin
  if not HayDatosEnGrid then Exit;

  for R := 1 to Grid.RowCount - 1 do
    if Trim(Grid.Cells[2, R]) <> '' then
      RecalcularCantidadFinalFila(R);
end;

procedure TfPedidoProveedorAuto.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then
    Exit;

  { Si hay un desplegable activo, ESC lo cierra antes de salir del formulario. }
  if (ActiveControl is TComboBox) and TComboBox(ActiveControl).DroppedDown then
  begin
    TComboBox(ActiveControl).DroppedDown := False;
    Key := 0;
    Exit;
  end;

  Key := 0;
  BtnCerrarClick(Self);
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
  // Columna 0 = indice fijo numerico; 1 = Sel; 2 = Codigo; 3 = Descripcion.
  // Tambien son numericas las columnas de unidades/importes/stock tras desplazar Sel a columna 1.
  Result := Col in [0, 4, 5, 6, 7, 8, 9, 10, 15, 16, 17, 18, 22, 23, 24, 25];
end;

function TfPedidoProveedorAuto.EsColumnaFecha(const Col: Integer): Boolean;
begin
  // Ult. venta y Ult. compra tras desplazar Sel a columna 1.
  Result := Col in [13, 14];
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
  // para que acentos, enes y simbolo euro salgan correctamente.
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
    (Trim(Grid.Cells[2, 1]) <> '');
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

  // En Linux suele ser mas fiable lanzar xdg-open/visor directamente.
  // OpenDocument se deja como ultimo recurso porque en algunos escritorios/xrdp
  // puede devolver exito sin llegar a mostrar nada visible.
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
  TColWidthsPDF = array[0..21] of Double;
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

  BaseW[0] := 12;   // Indice fijo
  BaseW[1] := 12;   // Sel
  BaseW[2] := 34;   // Codigo
  BaseW[3] := 105;  // Descripcion
  BaseW[4] := 34;   // Vendido periodo
  BaseW[5] := 34;   // Vendido tendencia
  BaseW[6] := 34;   // Vendido historico
  BaseW[7] := 31;   // Venta/dia
  BaseW[8] := 29;   // Sugerido
  BaseW[9] := 31;   // Stock contado
  BaseW[10] := 31;  // Cantidad final
  BaseW[11] := 34;  // Confianza
  BaseW[12] := 42;  // Accion
  BaseW[13] := 35;  // Ultima venta
  BaseW[14] := 35;  // Ultima compra
  BaseW[15] := 28;  // Coste
  BaseW[16] := 26;  // PVP
  BaseW[17] := 22;  // IVA
  BaseW[18] := 26;  // Stock info
  BaseW[19] := 24;  // Familia
  BaseW[20] := 50;  // Estado
  BaseW[21] := 105; // Observaciones

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
    ProgresoPaso('Generando PDF... pagina ' + IntToStr(PageNum) + ' de ' + IntToStr(PageCount), PageNum, PageCount);
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
  TColWidthsPrint = array[0..21] of Integer;
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
      '   Pagina ' + IntToStr(PageNum));
  end;

begin
  if not HayDatosEnGrid then
    raise Exception.Create('No hay datos para imprimir.');

  BaseW[0] := 12;
  BaseW[1] := 12;
  BaseW[2] := 34;
  BaseW[3] := 105;
  BaseW[4] := 34;
  BaseW[5] := 34;
  BaseW[6] := 34;
  BaseW[7] := 31;
  BaseW[8] := 29;
  BaseW[9] := 31;
  BaseW[10] := 31;
  BaseW[11] := 34;
  BaseW[12] := 42;
  BaseW[13] := 35;
  BaseW[14] := 35;
  BaseW[15] := 28;
  BaseW[16] := 26;
  BaseW[17] := 22;
  BaseW[18] := 26;
  BaseW[19] := 24;
  BaseW[20] := 50;
  BaseW[21] := 105;

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
      ProgresoPaso('Imprimiendo pagina ' + IntToStr(PageNum) + '...', -1);
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
  R, Lineas, NumLinea: Integer;
  EstudioCompleto: Boolean;

  function ContarLineasGrid: Integer;
  var
    RR: Integer;
  begin
    Result := 0;
    for RR := 1 to Grid.RowCount - 1 do
      if Trim(Grid.Cells[2, RR]) <> '' then Inc(Result);
  end;

  procedure PrepararSQLLineas;
  begin
    Q.SQL.Text :=
      'INSERT INTO pedido_auto_borrador_lin ' +
      '(borrador_id, linea, codigo_articulo, descripcion, vendido_periodo, vendido_tendencia, vendido_historico, venta_dia, sugerido, stock_contado, cantidad_final, confianza, accion, ult_venta, ult_compra, coste, pvp, iva, stock_info, familia, estado, observaciones) VALUES ' +
      '(:bid, :lin, :codart, :des, :vp, :vt, :vh, :vdia, :sug, :stc, :fin, :conf, :acc, :uv, :uc, :coste, :pvp, :iva, :stock, :fam, :est, :obs)';
  end;

  procedure InsertarLineaValores(const ANumLinea: Integer; const Codigo, Descripcion: string;
    const VendidoPeriodo, VendidoTendencia, VendidoHistorico, VentaDia, Sugerido,
    StockContado, CantidadFinal: Double; const Confianza, Accion, UltVenta,
    UltCompra: string; const Coste, PVP, IVA, StockInfo: Double; const Familia,
    Estado, Observaciones: string);
  begin
    Q.ParamByName('bid').AsInteger := BorradorID;
    Q.ParamByName('lin').AsInteger := ANumLinea;
    Q.ParamByName('codart').AsString := Copy(Codigo, 1, 50);
    Q.ParamByName('des').AsString := Copy(Descripcion, 1, 255);
    Q.ParamByName('vp').AsFloat := VendidoPeriodo;
    Q.ParamByName('vt').AsFloat := VendidoTendencia;
    Q.ParamByName('vh').AsFloat := VendidoHistorico;
    Q.ParamByName('vdia').AsFloat := VentaDia;
    Q.ParamByName('sug').AsFloat := Sugerido;
    Q.ParamByName('stc').AsFloat := StockContado;
    Q.ParamByName('fin').AsFloat := CantidadFinal;
    Q.ParamByName('conf').AsString := Copy(Confianza, 1, 20);
    Q.ParamByName('acc').AsString := Copy(Accion, 1, 40);
    Q.ParamByName('uv').AsString := Copy(UltVenta, 1, 20);
    Q.ParamByName('uc').AsString := Copy(UltCompra, 1, 20);
    Q.ParamByName('coste').AsFloat := Coste;
    Q.ParamByName('pvp').AsFloat := PVP;
    Q.ParamByName('iva').AsFloat := IVA;
    Q.ParamByName('stock').AsFloat := StockInfo;
    Q.ParamByName('fam').AsString := Copy(Familia, 1, 50);
    Q.ParamByName('est').AsString := Copy(Estado, 1, 80);
    Q.ParamByName('obs').AsString := Observaciones;
    Q.ExecSQL;
  end;

  procedure InsertarLineaAuto(const L: TLineaPedidoAuto; const ANumLinea: Integer);
  begin
    InsertarLineaValores(ANumLinea, L.Codigo, L.Descripcion,
      L.VendidoPeriodo, L.VendidoTendencia, L.VendidoHistorico, L.VentaDia,
      L.Sugerido, L.StockContado, L.CantidadFinal, L.Confianza, L.Accion,
      L.UltVenta, L.UltCompra, L.Coste, L.PVP, L.IVA, L.StockInfo,
      L.Familia, L.Estado, L.Observaciones);
  end;

  procedure InsertarListaAuto(const ALista: TArrayLineaPedidoAuto; const NombreLista: string);
  var
    I: Integer;
  begin
    for I := Low(ALista) to High(ALista) do
    begin
      Inc(NumLinea);
      if (NumLinea mod 25) = 0 then
        ProgresoPaso('Guardando borrador completo... ' + NombreLista + ' linea ' + IntToStr(NumLinea) + ' de ' + IntToStr(Lineas), NumLinea, Lineas);
      InsertarLineaAuto(ALista[I], NumLinea);
    end;
  end;

begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then begin ShowMessage('Seleccione un proveedor antes de guardar el borrador.'); Exit; end;
  if not HayDatosEnGrid then begin ShowMessage('No hay lineas en pantalla para guardar como borrador.'); Exit; end;

  CrearTablasPedidoAuto;

  EstudioCompleto := (Length(FAutoPedido) + Length(FAutoRevisar) + Length(FAutoExcluidos)) > 0;
  if EstudioCompleto then
  begin
    SincronizarListasAutoDesdeGrid;
    Lineas := Length(FAutoPedido) + Length(FAutoRevisar) + Length(FAutoExcluidos);
  end
  else
    Lineas := ContarLineasGrid;

  if Lineas <= 0 then begin ShowMessage('No hay lineas validas para guardar como borrador.'); Exit; end;

  ProgresoInicio('Guardando borrador de pedido automatico...', Lineas);
  LogPedidoAuto('Guardando borrador. Proveedor=' + IntToStr(CodProv) +
    ' completo=' + IntToStr(Ord(EstudioCompleto)) + ' lineas=' + IntToStr(Lineas));

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
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
    if EstudioCompleto then
      Q.ParamByName('obs').AsString := Copy('BORRADOR COMPLETO AUTO: auto=' + IntToStr(Length(FAutoPedido)) +
        ', dudas=' + IntToStr(Length(FAutoRevisar)) + ', excluidos=' + IntToStr(Length(FAutoExcluidos)) + '. ' + lblEstado.Caption, 1, 250)
    else
      Q.ParamByName('obs').AsString := Copy('BORRADOR VISTA ACTUAL: ' + lblEstado.Caption, 1, 250);
    Q.ExecSQL;

    Q.SQL.Text := 'SELECT LAST_INSERT_ID() AS ID';
    Q.Open;
    BorradorID := Q.FieldByName('ID').AsInteger;
    Q.Close;

    PrepararSQLLineas;
    NumLinea := 0;

    if EstudioCompleto then
    begin
      InsertarListaAuto(FAutoPedido, 'AUTO');
      InsertarListaAuto(FAutoRevisar, 'DUDAS');
      InsertarListaAuto(FAutoExcluidos, 'EXCLUIDOS');
    end
    else
    begin
      for R := 1 to Grid.RowCount - 1 do
      begin
        if Trim(Grid.Cells[2, R]) = '' then Continue;
        Inc(NumLinea);
        if (NumLinea mod 25) = 0 then
          ProgresoPaso('Guardando borrador vista... linea ' + IntToStr(NumLinea) + ' de ' + IntToStr(Lineas), NumLinea, Lineas);
        InsertarLineaValores(NumLinea,
          Grid.Cells[2, R], Grid.Cells[3, R],
          FloatSeguro(Grid.Cells[4, R], 0), FloatSeguro(Grid.Cells[5, R], 0),
          FloatSeguro(Grid.Cells[6, R], 0), FloatSeguro(Grid.Cells[7, R], 0),
          FloatSeguro(Grid.Cells[8, R], 0), FloatSeguro(Grid.Cells[9, R], 0),
          FloatSeguro(Grid.Cells[10, R], 0), Grid.Cells[11, R], Grid.Cells[12, R],
          Grid.Cells[13, R], Grid.Cells[14, R], FloatSeguro(Grid.Cells[15, R], 0),
          FloatSeguro(Grid.Cells[16, R], 0), FloatSeguro(Grid.Cells[17, R], 0),
          FloatSeguro(Grid.Cells[18, R], 0), Grid.Cells[19, R], Grid.Cells[20, R],
          Grid.Cells[21, R]);
      end;
    end;

    ProgresoFin('Borrador completo guardado #' + IntToStr(BorradorID) + ' para ' + NombreProveedorSeleccionado +
      ' con ' + IntToStr(NumLinea) + ' lineas. Auto=' + IntToStr(Length(FAutoPedido)) +
      ', dudas=' + IntToStr(Length(FAutoRevisar)) + ', excluidos=' + IntToStr(Length(FAutoExcluidos)) + '.');
    LogPedidoAuto('Borrador guardado #' + IntToStr(BorradorID) + ' lineas=' + IntToStr(NumLinea));
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
  L: TLineaPedidoAuto;
  CntAuto, CntDudas, CntExcl: Integer;

  procedure ClasificarLineaBorrador(const ALinea: TLineaPedidoAuto);
  var
    Conf, Acc: string;
  begin
    Conf := UpperCase(Trim(ALinea.Confianza));
    Acc := UpperCase(Trim(ALinea.Accion));
    if Conf = 'ALTA' then
    begin
      AddLineaAuto(FAutoPedido, ALinea);
      Inc(CntAuto);
    end
    else if (Conf = 'MEDIA') or (Pos('REVISAR', Acc) > 0) then
    begin
      AddLineaAuto(FAutoRevisar, ALinea);
      Inc(CntDudas);
    end
    else
    begin
      AddLineaAuto(FAutoExcluidos, ALinea);
      Inc(CntExcl);
    end;
  end;

begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then begin ShowMessage('Seleccione un proveedor antes de cargar el borrador.'); Exit; end;
  BorradorID := UltimoBorradorIDProveedor(CodProv);
  if BorradorID <= 0 then begin ShowMessage('No hay borradores guardados para este proveedor.'); Exit; end;

  ProgresoInicio('Cargando borrador completo #' + IntToStr(BorradorID) + '...', 100);
  LogPedidoAuto('Cargando borrador #' + IntToStr(BorradorID) + ' proveedor=' + IntToStr(CodProv));
  InicializarGrid;
  VaciarListasAuto;
  CntAuto := 0;
  CntDudas := 0;
  CntExcl := 0;

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
      if (R mod 25) = 0 then ProgresoPaso('Cargando borrador... linea ' + IntToStr(R), -1);

      L.Codigo := Q.FieldByName('codigo_articulo').AsString;
      L.Descripcion := Q.FieldByName('descripcion').AsString;
      L.VendidoPeriodo := Q.FieldByName('vendido_periodo').AsFloat;
      L.VendidoTendencia := Q.FieldByName('vendido_tendencia').AsFloat;
      L.VendidoHistorico := Q.FieldByName('vendido_historico').AsFloat;
      L.VendidoCobertura := 0;
      L.VentaDia := Q.FieldByName('venta_dia').AsFloat;
      L.Sugerido := Q.FieldByName('sugerido').AsFloat;
      L.StockContado := Q.FieldByName('stock_contado').AsFloat;
      L.CantidadFinal := Q.FieldByName('cantidad_final').AsFloat;
      L.Confianza := Q.FieldByName('confianza').AsString;
      L.Accion := Q.FieldByName('accion').AsString;
      L.UltVenta := Q.FieldByName('ult_venta').AsString;
      L.UltCompra := Q.FieldByName('ult_compra').AsString;
      L.Coste := Q.FieldByName('coste').AsFloat;
      L.PVP := Q.FieldByName('pvp').AsFloat;
      L.IVA := Q.FieldByName('iva').AsFloat;
      L.StockInfo := Q.FieldByName('stock_info').AsFloat;
      L.Familia := Q.FieldByName('familia').AsString;
      L.Estado := Q.FieldByName('estado').AsString;
      L.Observaciones := Q.FieldByName('observaciones').AsString;
      L.Prioridad := (L.Sugerido * 100) + (L.VendidoPeriodo * 1000) + (L.VendidoTendencia * 500);

      Grid.Cells[2, R] := L.Codigo;
      Grid.Cells[3, R] := L.Descripcion;
      Grid.Cells[4, R] := FormatFloat('0.##', L.VendidoPeriodo);
      Grid.Cells[5, R] := FormatFloat('0.##', L.VendidoTendencia);
      Grid.Cells[6, R] := FormatFloat('0.##', L.VendidoHistorico);
      Grid.Cells[7, R] := FormatFloat('0.####', L.VentaDia);
      Grid.Cells[8, R] := FormatFloat('0.##', L.Sugerido);
      if Abs(L.StockContado) > 0.0001 then
        Grid.Cells[9, R] := FormatFloat('0.##', L.StockContado)
      else
        Grid.Cells[9, R] := '';
      Grid.Cells[10, R] := FormatFloat('0.##', L.CantidadFinal);
      Grid.Cells[11, R] := L.Confianza;
      Grid.Cells[12, R] := L.Accion;
      Grid.Cells[13, R] := L.UltVenta;
      Grid.Cells[14, R] := L.UltCompra;
      Grid.Cells[15, R] := FormatFloat('0.000', L.Coste);
      Grid.Cells[16, R] := FormatFloat('0.00', L.PVP);
      Grid.Cells[17, R] := FormatFloat('0.##', L.IVA);
      Grid.Cells[18, R] := FormatFloat('0.##', L.StockInfo);
      Grid.Cells[19, R] := L.Familia;
      Grid.Cells[20, R] := L.Estado;
      Grid.Cells[21, R] := L.Observaciones;
      if Grid.ColCount > 22 then Grid.Cells[22, R] := FormatFloat('0.##', L.VendidoCobertura);
      if Grid.ColCount > 23 then Grid.Cells[23, R] := FormatFloat('0.##', L.CompradoUlt4);
      if Grid.ColCount > 24 then Grid.Cells[24, R] := FormatFloat('0.##', L.MediaUlt4);
      if Grid.ColCount > 25 then Grid.Cells[25, R] := FormatFloat('0.##', L.MaxUlt4);
      Grid.Cells[0, R] := IntToStr(R);
      Grid.Cells[1, R] := '';

      ClasificarLineaBorrador(L);
      Inc(R);
      Q.Next;
    end;
    FSuppressSelToggle := True;
    try
      if Grid.RowCount > 1 then
      begin
        Grid.Row := 1;
        if Grid.ColCount > 2 then Grid.Col := 2;
      end;
    finally
      FSuppressSelToggle := False;
    end;
    AutoAjustarColumnas;
    ProgresoFin('Borrador #' + IntToStr(BorradorID) + ' cargado. Total lineas: ' + IntToStr(R - 1) +
      '. Auto=' + IntToStr(CntAuto) + ', dudas=' + IntToStr(CntDudas) + ', excluidos=' + IntToStr(CntExcl) +
      '. Puede usar Ver auto / Ver dudas / Ver riesgos / Ver excluidos.');
    LogPedidoAuto('Borrador cargado #' + IntToStr(BorradorID) + ' total=' + IntToStr(R - 1) +
      ' auto=' + IntToStr(CntAuto) + ' dudas=' + IntToStr(CntDudas) + ' excluidos=' + IntToStr(CntExcl));
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
  if MessageDlg('Borrar borrador', 'Se va a borrar el ultimo borrador guardado para este proveedor (#' + IntToStr(BorradorID) + ').' + LineEnding + 'No se tocara ningun pedido real. ?Continuar?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'DELETE FROM pedido_auto_borrador_lin WHERE borrador_id=:bid';
    Q.ParamByName('bid').AsInteger := BorradorID;
    Q.ExecSQL;
    Q.SQL.Text := 'DELETE FROM pedido_auto_borrador_cab WHERE id=:bid';
    Q.ParamByName('bid').AsInteger := BorradorID;
    Q.ExecSQL;
    lblEstado.Caption := 'Borrador #' + IntToStr(BorradorID) + ' borrado. No se ha tocado ningun pedido real.';
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
    // El pedido real ya esta creado. No bloqueamos por un fallo en el historial propio.
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
    ShowMessage('Seleccione un proveedor para consultar su historial automatico.');
    Exit;
  end;

  if not TablaExiste('pedido_auto_creados') then
  begin
    ShowMessage('No existe todavia la tabla pedido_auto_creados.' + LineEnding +
      'Se creara automaticamente al abrir/verificar el modulo, o cuando cree el primer pedido real desde esta pantalla.');
    Exit;
  end;

  ProgresoInicio('Consultando historial de pedidos automaticos creados...', 20);
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

    Texto := 'Historial de pedidos automaticos creados' + LineEnding +
             'Proveedor: ' + NombreProveedorSeleccionado + LineEnding +
             StringOfChar('-', 72) + LineEnding;

    Cont := 0;
    while not Q.EOF do
    begin
      Inc(Cont);
      ProgresoPaso('Leyendo historial automatico... ' + IntToStr(Cont), Cont, 20);

      Linea := Format('%s  %s/%d  Lineas:%d  Uds:%s  Coste:%s EUR  PVP:%s EUR', [
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
      Texto := Texto + 'No hay pedidos automaticos creados todavia para este proveedor.' + LineEnding
    else
      Texto := Texto + StringOfChar('-', 72) + LineEnding +
        'Mostrando los ultimos ' + IntToStr(Cont) + ' registros. Este historial sirve para detectar duplicados y consultar lo creado desde este modulo.';

    ProgresoFin('Historial automatico consultado.');
    ShowMessage(Texto);
  except
    on E: Exception do
    begin
      ProgresoFin('Error consultando historial automatico.');
      ShowMessage('Error consultando historial de pedidos automaticos:' + LineEnding + E.Message);
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
    ShowMessage('No hay lineas visibles para comparar.');
    Exit;
  end;

  TPedid := 'pedidd' + FTienda;
  if (not TablaExiste(TPedid)) or (not CampoExiste(TPedid, 'PD2')) or
     (not CampoExiste(TPedid, 'PD3')) or (not CampoExiste(TPedid, 'PD4')) or
     (not CampoExiste(TPedid, 'PD6')) or (not CampoExiste(TPedid, 'PD8')) then
  begin
    ShowMessage('No encuentro la tabla real de lineas de pedido o su estructura no parece la esperada:' + LineEnding +
      TPedid + LineEnding + LineEnding + 'No se ha modificado nada.');
    Exit;
  end;

  if not UltimoPedidoRealProveedor(SerieAnt, NumAnt, FechaAnt) then
  begin
    ShowMessage('No he encontrado ningun pedido real anterior para este proveedor en pedicc/pedidd.' + LineEnding +
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

    ProgresoInicio('Comparando con ultimo pedido real...', Grid.RowCount + 50);

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
        ProgresoPaso('Leyendo pedido anterior... ' + IntToStr(LastQty.Count) + ' lineas', -1);
      Q.Next;
    end;

    for R := 1 to Grid.RowCount - 1 do
    begin
      Cod := Trim(Grid.Cells[2, R]);
      Qty := FloatSeguro(Grid.Cells[10, R], 0);
      if (Cod = '') or (Qty <= 0) then Continue;
      Desc := Grid.Cells[3, R];
      AddQty(CurQty, CurDesc, Cod, Desc, Qty);
      TotalCur := TotalCur + Qty;
      CosteCur := CosteCur + (Qty * FloatSeguro(Grid.Cells[15, R], 0));
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
      'Comparativa contra el ultimo pedido real del proveedor:' + LineEnding + LineEnding +
      'Proveedor: ' + NombreProveedorSeleccionado + LineEnding +
      'Pedido anterior: ' + SerieAnt + '/' + IntToStr(NumAnt) +
        ' del ' + FormatDateTime('dd/mm/yyyy', FechaAnt) + LineEnding + LineEnding +
      'Pedido anterior:' + LineEnding +
      '  Lineas: ' + IntToStr(LineasLast) + LineEnding +
      '  Unidades: ' + FormatFloat('0.##', TotalLast) + LineEnding +
      '  Coste aprox.: ' + FormatFloat('0.00', CosteLast) + ' EUR' + LineEnding + LineEnding +
      'Pedido visible actual:' + LineEnding +
      '  Lineas: ' + IntToStr(LineasCur) + LineEnding +
      '  Unidades: ' + FormatFloat('0.##', TotalCur) + LineEnding +
      '  Coste aprox.: ' + FormatFloat('0.00', CosteCur) + ' EUR' + LineEnding + LineEnding;

    if CntNuevas > 0 then
    begin
      Resumen := Resumen + 'Lineas nuevas respecto al pedido anterior: ' + IntToStr(CntNuevas) + LineEnding + Nuevas;
      if CntNuevas > 12 then Resumen := Resumen + '  ... y ' + IntToStr(CntNuevas - 12) + ' mas.' + LineEnding;
      Resumen := Resumen + LineEnding;
    end;
    if CntSuben > 0 then
    begin
      Resumen := Resumen + 'Lineas que suben mucho: ' + IntToStr(CntSuben) + LineEnding + Suben;
      if CntSuben > 12 then Resumen := Resumen + '  ... y ' + IntToStr(CntSuben - 12) + ' mas.' + LineEnding;
      Resumen := Resumen + LineEnding;
    end;
    if CntBajan > 0 then
    begin
      Resumen := Resumen + 'Lineas que bajan mucho: ' + IntToStr(CntBajan) + LineEnding + Bajan;
      if CntBajan > 12 then Resumen := Resumen + '  ... y ' + IntToStr(CntBajan - 12) + ' mas.' + LineEnding;
      Resumen := Resumen + LineEnding;
    end;
    if CntFaltan > 0 then
    begin
      Resumen := Resumen + 'Pedidas anteriormente y ahora no entran: ' + IntToStr(CntFaltan) + LineEnding + Faltan;
      if CntFaltan > 12 then Resumen := Resumen + '  ... y ' + IntToStr(CntFaltan - 12) + ' mas.' + LineEnding;
      Resumen := Resumen + LineEnding;
    end;

    if (CntNuevas + CntSuben + CntBajan + CntFaltan) = 0 then
      Resumen := Resumen + 'No veo diferencias llamativas respecto al pedido anterior.' + LineEnding;

    Resumen := Resumen + LineEnding +
      'Esta comparativa es informativa. No se ha modificado ningun pedido ni borrador.';

    MessageDlg('Comparativa con pedido anterior', Resumen, mtInformation, [mbOK], 0);
  except
    on E: Exception do
    begin
      ProgresoFin('Error comparando con pedido anterior.');
      ShowMessage('Error comparando con el pedido anterior:' + LineEnding + E.Message + LineEnding + LineEnding +
        'No se ha modificado ningun dato.');
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
    if Trim(Grid.Cells[2, R]) = '' then Continue;
    Cant := FloatSeguro(Grid.Cells[10, R], 0);
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
    ShowMessage('No hay lineas visibles para crear un pedido.');
    Exit;
  end;

  LineasValidas := LineasFinalesValidasEnGrid;
  LogPedidoAuto('Crear pedido real solicitado. Proveedor=' + NombreProveedorSeleccionado + ' LineasValidas=' + IntToStr(LineasValidas));
  if LineasValidas <= 0 then
  begin
    ShowMessage('No hay lineas con Cantidad final mayor que 0.' + LineEnding +
      'Revise la columna Cantidad final antes de crear el pedido real.');
    Exit;
  end;

  TPedic := 'pedicc' + FTienda;
  TPedid := 'pedidd' + FTienda;
  if (not TablaExiste(TPedic)) or (not TablaExiste(TPedid)) then
  begin
    ShowMessage('No existen las tablas reales de pedidos para esta tienda:' + LineEnding +
      TPedic + LineEnding + TPedid + LineEnding + LineEnding +
      'No se ha creado ningun pedido.');
    Exit;
  end;

  // Comprobacion minima de campos esperados antes de insertar.
  if (not CampoExiste(TPedic, 'PC0')) or (not CampoExiste(TPedic, 'PC4')) or
     (not CampoExiste(TPedid, 'PD0')) or (not CampoExiste(TPedid, 'PD8')) then
  begin
    ShowMessage('La estructura de pedicc/pedidd no parece la esperada.' + LineEnding +
      'No se ha creado ningun pedido real para evitar errores.');
    Exit;
  end;

  RecalcularTodasCantidadesFinales;
  LineasValidas := LineasFinalesValidasEnGrid;
  if LineasValidas <= 0 then Exit;

  Serie := 'PED';
  NumPedido := SiguienteNumeroPedidoReal(Serie);
  FechaPed := Date;
  TiendaNum := StrToIntDef(FTienda, 0);

  // Revision previa: se calcula antes de tocar pedicc/pedidd para que el usuario vea
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
    Codigo := Trim(Grid.Cells[2, R]);
    Cantidad := FloatSeguro(Grid.Cells[10, R], 0);
    if (Codigo = '') or (Cantidad <= 0) then Continue;

    CosteSinIVA := FloatSeguro(Grid.Cells[15, R], 0);
    IVA := FloatSeguro(Grid.Cells[17, R], 0);
    PVP := FloatSeguro(Grid.Cells[16, R], 0);
    CosteConIVA := CosteSinIVA * (1 + (IVA / 100));
    TotalCosteSin := TotalCosteSin + (CosteSinIVA * Cantidad);
    TotalCosteCon := TotalCosteCon + (CosteConIVA * Cantidad);
    TotalPVP := TotalPVP + (PVP * Cantidad);
    TotalUnidades := TotalUnidades + Cantidad;

    Conf := UpperCase(Trim(Grid.Cells[11, R]));
    Accion := UpperCase(Trim(Grid.Cells[12, R]));
    EstadoTxt := UpperCase(Trim(Grid.Cells[20, R]));
    ObsLinea := UpperCase(Trim(Grid.Cells[21, R]));

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
    'Serie/Numero: ' + Serie + '/' + IntToStr(NumPedido) + LineEnding +
    'Lineas con Cantidad final > 0: ' + IntToStr(LineasValidas) + LineEnding +
    'Unidades totales aproximadas: ' + FormatFloat('0.##', TotalUnidades) + LineEnding +
    'Coste sin IVA aproximado: ' + FormatFloat('0.00', TotalCosteSin) + ' EUR' + LineEnding +
    'Coste con IVA aproximado: ' + FormatFloat('0.00', TotalCosteCon) + ' EUR' + LineEnding +
    'PVP venta aproximado: ' + FormatFloat('0.00', TotalPVP) + ' EUR' + LineEnding + LineEnding +
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
        'Ya consta un pedido real creado desde este modulo para este proveedor:' + LineEnding + LineEnding +
        'Pedido anterior automatico: ' + UltAutoSerie + '/' + IntToStr(UltAutoNumero) + LineEnding +
        'Fecha creacion: ' + FormatDateTime('dd/mm/yyyy hh:nn', UltAutoFecha) + LineEnding +
        'Lineas: ' + IntToStr(UltAutoLineas) + LineEnding +
        'Hace: ' + IntToStr(DiasDesdeUltimo) + ' dias' + LineEnding +
        'Cobertura configurada: ' + IntToStr(LimiteDias) + ' dias' + LineEnding + LineEnding +
        'Si continua, podria estar duplicando un pedido reciente.' + LineEnding +
        '?Esta seguro de que quiere seguir?';

      if MessageDlg('Posible pedido duplicado', UltAutoMsg, mtWarning,
        [mbYes, mbNo], 0) <> mrYes then
        Exit;

      Avisos := Avisos + '- POSIBLE DUPLICADO: ya existe un pedido automatico reciente ' +
        UltAutoSerie + '/' + IntToStr(UltAutoNumero) + ' del ' +
        FormatDateTime('dd/mm/yyyy hh:nn', UltAutoFecha) + '.' + LineEnding;
    end;
  end;

  if CntRevisar > 0 then
    Avisos := Avisos + '- ' + IntToStr(CntRevisar) + ' lineas marcadas como revisar.' + LineEnding;
  if CntExcluir > 0 then
    Avisos := Avisos + '- ' + IntToStr(CntExcluir) + ' lineas tienen decision EXCLUIR y aun asi cantidad final > 0.' + LineEnding;
  if CntCoste0 > 0 then
    Avisos := Avisos + '- ' + IntToStr(CntCoste0) + ' lineas con coste 0.' + LineEnding;
  if CntPVP999 > 0 then
    Avisos := Avisos + '- ' + IntToStr(CntPVP999) + ' lineas con PVP 999 o superior.' + LineEnding;
  if CntRoturas > 0 then
    Avisos := Avisos + '- ' + IntToStr(CntRoturas) + ' lineas parecen roturas de stock.' + LineEnding;
  if CntEquiv > 0 then
    Avisos := Avisos + '- ' + IntToStr(CntEquiv) + ' lineas con equivalencias/posibles duplicados.' + LineEnding;
  if CntCantidadAlta > 0 then
    Avisos := Avisos + '- ' + IntToStr(CntCantidadAlta) + ' lineas con cantidad final igual o superior a 50.' + LineEnding;
  if CntMedia + CntBaja + CntSinConf > 0 then
    Avisos := Avisos + '- Hay lineas que no son de confianza ALTA. Conviene revisar antes de confirmar.' + LineEnding;
  if CntRaros > 0 then
    Avisos := Avisos + '- Hay lineas raras por coste/PVP. Revisa si deben entrar al pedido real.' + LineEnding;

  if Avisos <> '' then
    Revision := Revision + LineEnding + 'Avisos antes de crear:' + LineEnding + Avisos;

  Revision := Revision + LineEnding +
    'Solo se insertaran las lineas VISIBLES con Cantidad final mayor que 0.' + LineEnding +
    '?Continuar y crear el pedido real?';

  if MessageDlg('Revision previa del pedido real', Revision,
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  LogPedidoAuto('Creando pedido real ' + Serie + '/' + IntToStr(NumPedido) + ' proveedor=' + NombreProveedorSeleccionado + ' lineas=' + IntToStr(LineasValidas));
  ProgresoInicio('Creando pedido real...', LineasValidas + 2);
  Q := TZQuery.Create(nil);
  Insertado := False;
  try
    Q.Connection := FConn;

    Obs := 'Pedido generado desde Pedido automatico por proveedor el ' +
      FormatDateTime('dd/mm/yyyy hh:nn', Now) + '. Revise antes de enviar/recibir.';

    // Insertamos cabecera con la estructura estandar PC0..PC32.
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
    ProgresoPaso('Cabecera creada. Insertando lineas...', 1, LineasValidas + 2);

    Q.SQL.Text :=
      'INSERT INTO `' + TPedid + '` (' +
      'PD0,PD1,PD2,PD3,PD4,PD5,PD6,PD7,PD8,PD9,PD10,PD11,PD12,PD13,PD14,PD15,PD16,PD17,PD18,PD19,PD20,PD21,PD22,PD23,PD24,PD25,PD26,PD27,PD28,PD29,PD30) VALUES (' +
      ':PD0,:PD1,:PD2,:PD3,:PD4,:PD5,:PD6,:PD7,:PD8,:PD9,:PD10,:PD11,:PD12,:PD13,:PD14,:PD15,:PD16,:PD17,:PD18,:PD19,:PD20,:PD21,:PD22,:PD23,:PD24,:PD25,:PD26,:PD27,:PD28,:PD29,:PD30)';

    Lin := 0;
    for R := 1 to Grid.RowCount - 1 do
    begin
      Codigo := Trim(Grid.Cells[2, R]);
      Cantidad := FloatSeguro(Grid.Cells[10, R], 0);
      if (Codigo = '') or (Cantidad <= 0) then Continue;
      Inc(Lin);

      Descripcion := Copy(Grid.Cells[3, R], 1, 50);
      VendPeriodo := FloatSeguro(Grid.Cells[4, R], 0);
      VendHistorico := FloatSeguro(Grid.Cells[6, R], 0);
      CosteSinIVA := FloatSeguro(Grid.Cells[15, R], 0);
      PVP := FloatSeguro(Grid.Cells[16, R], 0);
      IVA := FloatSeguro(Grid.Cells[17, R], 0);
      StockInfo := FloatSeguro(Grid.Cells[18, R], 0);
      FamiliaTxt := Grid.Cells[19, R];
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

      ProgresoPaso('Insertando linea real ' + IntToStr(Lin) + ' de ' + IntToStr(LineasValidas), Lin + 1, LineasValidas + 2);
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
      'Pedido real creado desde listado visible de pedido automatico');

    LogPedidoAuto('Pedido real creado correctamente ' + Serie + '/' + IntToStr(NumPedido) + ' lineas=' + IntToStr(LineasValidas) + ' unidades=' + FormatFloat('0.##', TotalUnidades) + ' coste=' + FormatFloat('0.00', TotalCosteCon));
    ProgresoFin('Pedido real creado: ' + Serie + '/' + IntToStr(NumPedido) +
      ' - ' + IntToStr(LineasValidas) + ' lineas.');
    ShowMessage('Pedido real creado correctamente.' + LineEnding + LineEnding +
      'Proveedor: ' + NombreProveedorSeleccionado + LineEnding +
      'Pedido: ' + Serie + '/' + IntToStr(NumPedido) + LineEnding +
      'Lineas: ' + IntToStr(LineasValidas));

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
          LogPedidoAuto('Limpieza automatica ejecutada tras error creando pedido ' + Serie + '/' + IntToStr(NumPedido));
        except
          // Si tambien falla la limpieza, se informa abajo con el error principal.
        end;
      end;
      ShowMessage('Error creando pedido real:' + LineEnding + E.Message + LineEnding + LineEnding +
        'Si se llego a insertar algo, se ha intentado limpiar automaticamente la cabecera y lineas del pedido ' +
        Serie + '/' + IntToStr(NumPedido) + '.');
    end;
  end;
  Q.Free;
end;

procedure TfPedidoProveedorAuto.AutoAjustarColumnas;
begin
  if Grid.ColCount < 22 then Exit;

  Grid.ColWidths[2] := 90;
  Grid.ColWidths[3] := 245;
  Grid.ColWidths[4] := 95;
  Grid.ColWidths[5] := 95;
  Grid.ColWidths[6] := 105;
  Grid.ColWidths[7] := 95;
  Grid.ColWidths[8] := 80;
  Grid.ColWidths[9] := 90;
  Grid.ColWidths[10] := 90;
  Grid.ColWidths[11] := 80;
  Grid.ColWidths[12] := 95;
  Grid.ColWidths[13] := 85;
  Grid.ColWidths[14] := 85;
  Grid.ColWidths[15] := 70;
  Grid.ColWidths[16] := 70;
  Grid.ColWidths[17] := 55;
  Grid.ColWidths[18] := 75;
  Grid.ColWidths[19] := 60;
  Grid.ColWidths[20] := 150;
  Grid.ColWidths[21] := 380;
  if Grid.ColCount > 22 then Grid.ColWidths[22] := 100;
  if Grid.ColCount > 23 then Grid.ColWidths[23] := 110;
  if Grid.ColCount > 24 then Grid.ColWidths[24] := 80;
  if Grid.ColCount > 25 then Grid.ColWidths[25] := 80;
  Grid.ColWidths[0] := 45;
  Grid.ColWidths[1] := 45;
end;

end.
