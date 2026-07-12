unit uDashboardProductividad;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DateUtils, Math, IniFiles, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, Buttons, DBGrids, Grids, DB, ZConnection, ZDataset, LCLIntf;

procedure ShowFormDashboardProductividad(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);

implementation

{ Declaraciones adelantadas: estas rutinas se usan tambien desde la pestaña Consulta libre, antes de su implementacion real. }
procedure FLXAplicarFormatoDataSet(DS: TDataSet); forward;
procedure FLXAutoAjustarGrid(Grid: TDBGrid); forward;

type
  TDashboardAlerta = (
    daStockBajo,
    daCosteCero,
    daPVP999,
    daFamiliaCero,
    daSinProveedor,
    daStockCeroVendido30
  );

  TDoubleMonthArray = array[1..12] of Double;
  TDoubleHourArray = array[0..23] of Double;
  TIntegerHourArray = array[0..23] of Integer;
  TString20Array = array[0..19] of string;
  TDouble20Array = array[0..19] of Double;

  TComparativaAvRow = record
    Etiqueta: string;
    DesdeFecha: TDateTime;
    HastaFecha: TDateTime;
    Ventas: Double;
    CajaTotal: Double;
    Tickets: Integer;
    DocsCaja: Integer;
    DifVentas: Double;
    DifVentasPct: Double;
    DifCaja: Double;
    DifCajaPct: Double;
  end;

  TDouble6Array = array[0..5] of Double;
  TString6Array = array[0..5] of string;

  { TFLXCalendarPicker }

  TFLXCalendarPicker = class(TForm)
  private
    FSelectedDate: TDateTime;
    FYear: Word;
    FMonth: Word;
    lblTitulo: TLabel;
    btnPrev: TButton;
    btnNext: TButton;
    btnHoy: TButton;
    btnCancelar: TButton;
    FDayButtons: array[1..42] of TButton;
    procedure PrevClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure HoyClick(Sender: TObject);
    procedure DiaClick(Sender: TObject);
    procedure PintarCalendario;
  public
    constructor CreateCalendar(AOwner: TComponent; const AFechaInicial: TDateTime);
    property SelectedDate: TDateTime read FSelectedDate;
  end;



  TFDashboardProductividad = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;

    pnlFiltro: TPanel;
    cbIrAPestana: TComboBox;
    cbGrupoArticulos: TComboBox;
    cbGrupoCompras: TComboBox;
    btnPestanaIzq: TButton;
    btnPestanaDer: TButton;
    FActualizandoSelector: Boolean;
    pcPrincipal: TPageControl;
    tsDashboard: TTabSheet;
    tsHoy: TTabSheet;
    tsCuadroGestion: TTabSheet;
    tsVentasAbiertas: TTabSheet;
    tsCierreTarde: TTabSheet;
    tsDiagnostico: TTabSheet;
    tsAlertas: TTabSheet;
    tsEstudios: TTabSheet;
    tsComparativa: TTabSheet;
    tsTendencias: TTabSheet;
    tsClientes: TTabSheet;
    tsPuestos: TTabSheet;
    tsCompras: TTabSheet;
    tsPromociones: TTabSheet;
    tsRentabilidad: TTabSheet;
    tsRotacion: TTabSheet;
    tsReposicion: TTabSheet;
    tsPicking: TTabSheet;
    tsCalidad: TTabSheet;
    tsVeriFactu: TTabSheet;
    tsGraficas: TTabSheet;
    tsComparativaAvanzada: TTabSheet;
    tsConsultaLibre: TTabSheet;

    dtDesde: TEdit;
    dtHasta: TEdit;
    btnCalDesde: TButton;
    btnCalHasta: TButton;
    btnRefrescar: TButton;
    btnExportCSV: TButton;
    btnInformeHTML: TButton;
    btnInformePDF: TButton;
    btnCerrar: TButton;
    btnHoy: TButton;
    btnAyer: TButton;
    btn7Dias: TButton;
    btn30Dias: TButton;

    lblVentasHoy: TLabel;
    lblVentasAyer: TLabel;
    lblTicketsHoy: TLabel;
    lblTicketMedio: TLabel;
    lblBaseHoy: TLabel;
    lblIvaHoy: TLabel;

    lblHoyFecha: TLabel;
    lblHoyVentas: TLabel;
    lblHoyTickets: TLabel;
    lblHoyTicketMedio: TLabel;
    lblHoyBase: TLabel;
    lblHoyIva: TLabel;
    lblHoyHoraPico: TLabel;
    lblHoyImportePico: TLabel;

    dtCGDesdeAct: TEdit;
    dtCGHastaAct: TEdit;
    dtCGDesdeComp: TEdit;
    dtCGHastaComp: TEdit;
    btnCGCalDesdeAct: TButton;
    btnCGCalHastaAct: TButton;
    btnCGCalDesdeComp: TButton;
    btnCGCalHastaComp: TButton;
    btnCGDia: TButton;
    btnCGMes: TButton;
    btnCGAno: TButton;
    btnCGPeriodo: TButton;
    btnCGRefrescar: TButton;
    lblCGFacturacion: TLabel;
    lblCGMargen: TLabel;
    lblCGClientes: TLabel;
    lblCGArticulos: TLabel;
    lblCGCesta: TLabel;

    qPagos: TZQuery;
    qTopArticulos: TZQuery;
    qTopFamilias: TZQuery;
    qHoras: TZQuery;
    qHoyResumen: TZQuery;
    qHoyHoras: TZQuery;
    qHoyPagos: TZQuery;
    qCGResumen: TZQuery;
    qCGNegocio: TZQuery;
    qCGHoras: TZQuery;
    qCGMargen: TZQuery;
    qCGEmpleados: TZQuery;
    qVNAResumen: TZQuery;
    qVNATickets: TZQuery;
    qVNADetalle: TZQuery;
    qVNAHoras: TZQuery;
    qVNARevision: TZQuery;
    qCTResumen: TZQuery;
    qCTDias: TZQuery;
    qCTCandidatos: TZQuery;
    qCTSemana: TZQuery;
    qCTHoras: TZQuery;
    qDiagResumen: TZQuery;
    qDiagMargen: TZQuery;
    qDiagHoras: TZQuery;
    qDiagProveedor: TZQuery;
    qAlertas: TZQuery;
    qEstVentasDia: TZQuery;
    qEstVentasHora: TZQuery;
    qEstFamilias: TZQuery;
    qEstProveedores: TZQuery;
    qEstMargen: TZQuery;
    qEstProblemas: TZQuery;
    qCompResumen: TZQuery;
    qCompDiaActual: TZQuery;
    qCompDiaAnterior: TZQuery;
    qCompFamilias: TZQuery;
    qCompArticulos: TZQuery;
    qCompPagos: TZQuery;
    qTendResumen: TZQuery;
    qTendMeses: TZQuery;
    qTendAnual: TZQuery;
    qTendSemana: TZQuery;
    qTendAlza: TZQuery;
    qTendBaja: TZQuery;
    qCliResumen: TZQuery;
    qCliTopImporte: TZQuery;
    qCliTopFrecuencia: TZQuery;
    qCliTicketMedio: TZQuery;
    qCliSinCliente: TZQuery;
    qCliDatosIncompletos: TZQuery;
    qPueResumen: TZQuery;
    qPueUsuarios: TZQuery;
    qPueCajas: TZQuery;
    qPueHorasUsuario: TZQuery;
    qPuePagosCaja: TZQuery;
    qPueRevision: TZQuery;
    qComResumen: TZQuery;
    qComPendientes: TZQuery;
    qComDetallePend: TZQuery;
    qComProveedor: TZQuery;
    qComArticulos: TZQuery;
    qComRevision: TZQuery;
    qPromoResumen: TZQuery;
    qPromoDescuentos: TZQuery;
    qPromoArticulos: TZQuery;
    qPromoFamilias: TZQuery;
    qPromoBajoCoste: TZQuery;
    qPromoRevision: TZQuery;
    qRentResumen: TZQuery;
    qRentArticulos: TZQuery;
    qRentFamilias: TZQuery;
    qRentProveedores: TZQuery;
    qRentDias: TZQuery;
    qRentRevision: TZQuery;
    qRotResumen: TZQuery;
    qRotAlta: TZQuery;
    qRotRiesgo: TZQuery;
    qRotBaja: TZQuery;
    qRotExceso: TZQuery;
    qRotSinVentas: TZQuery;
    qRepResumen: TZQuery;
    qRepSugerido: TZQuery;
    qRepUrgente: TZQuery;
    qRepProveedor: TZQuery;
    qRepSinProveedor: TZQuery;
    qRepBajaRotacion: TZQuery;
    qPickResumen: TZQuery;
    qPickRuta: TZQuery;
    qPickUbicacion: TZQuery;
    qPickProveedor: TZQuery;
    qPickSinUbicacion: TZQuery;
    qPickRevision: TZQuery;
    qCalResumen: TZQuery;
    qCalIncompletos: TZQuery;
    qCalPrecios: TZQuery;
    qCalStock: TZQuery;
    qCalDuplicados: TZQuery;
    qCalSinMovimiento: TZQuery;
    qVFResumen: TZQuery;
    qVFPendientes: TZQuery;
    qVFAceptadosErrores: TZQuery;
    qVFErrores: TZQuery;
    qVFSeries: TZQuery;
    qVFUltimos: TZQuery;
    qCmpAvResumen: TZQuery;
    qCmpAvDia: TZQuery;
    qCmpAvMes: TZQuery;
    qCmpAvPeriodo: TZQuery;
    qLibreTablas: TZQuery;
    qLibreCampos: TZQuery;
    qLibreResultado: TZQuery;

    dsPagos: TDataSource;
    dsTopArticulos: TDataSource;
    dsTopFamilias: TDataSource;
    dsHoras: TDataSource;
    dsHoyHoras: TDataSource;
    dsHoyPagos: TDataSource;
    dsCGResumen: TDataSource;
    dsCGNegocio: TDataSource;
    dsCGHoras: TDataSource;
    dsCGMargen: TDataSource;
    dsCGEmpleados: TDataSource;
    dsVNAResumen: TDataSource;
    dsVNATickets: TDataSource;
    dsVNADetalle: TDataSource;
    dsVNAHoras: TDataSource;
    dsVNARevision: TDataSource;
    dsCTResumen: TDataSource;
    dsCTDias: TDataSource;
    dsCTCandidatos: TDataSource;
    dsCTSemana: TDataSource;
    dsCTHoras: TDataSource;
    dsDiagResumen: TDataSource;
    dsDiagMargen: TDataSource;
    dsDiagHoras: TDataSource;
    dsDiagProveedor: TDataSource;
    dsAlertas: TDataSource;
    dsEstVentasDia: TDataSource;
    dsEstVentasHora: TDataSource;
    dsEstFamilias: TDataSource;
    dsEstProveedores: TDataSource;
    dsEstMargen: TDataSource;
    dsEstProblemas: TDataSource;
    dsCompResumen: TDataSource;
    dsCompDiaActual: TDataSource;
    dsCompDiaAnterior: TDataSource;
    dsCompFamilias: TDataSource;
    dsCompArticulos: TDataSource;
    dsCompPagos: TDataSource;
    dsTendResumen: TDataSource;
    dsTendMeses: TDataSource;
    dsTendAnual: TDataSource;
    dsTendSemana: TDataSource;
    dsTendAlza: TDataSource;
    dsTendBaja: TDataSource;
    dsCliResumen: TDataSource;
    dsCliTopImporte: TDataSource;
    dsCliTopFrecuencia: TDataSource;
    dsCliTicketMedio: TDataSource;
    dsCliSinCliente: TDataSource;
    dsCliDatosIncompletos: TDataSource;
    dsPueResumen: TDataSource;
    dsPueUsuarios: TDataSource;
    dsPueCajas: TDataSource;
    dsPueHorasUsuario: TDataSource;
    dsPuePagosCaja: TDataSource;
    dsPueRevision: TDataSource;
    dsComResumen: TDataSource;
    dsComPendientes: TDataSource;
    dsComDetallePend: TDataSource;
    dsComProveedor: TDataSource;
    dsComArticulos: TDataSource;
    dsComRevision: TDataSource;
    dsPromoResumen: TDataSource;
    dsPromoDescuentos: TDataSource;
    dsPromoArticulos: TDataSource;
    dsPromoFamilias: TDataSource;
    dsPromoBajoCoste: TDataSource;
    dsPromoRevision: TDataSource;
    dsRentResumen: TDataSource;
    dsRentArticulos: TDataSource;
    dsRentFamilias: TDataSource;
    dsRentProveedores: TDataSource;
    dsRentDias: TDataSource;
    dsRentRevision: TDataSource;
    dsRotResumen: TDataSource;
    dsRotAlta: TDataSource;
    dsRotRiesgo: TDataSource;
    dsRotBaja: TDataSource;
    dsRotExceso: TDataSource;
    dsRotSinVentas: TDataSource;
    dsRepResumen: TDataSource;
    dsRepSugerido: TDataSource;
    dsRepUrgente: TDataSource;
    dsRepProveedor: TDataSource;
    dsRepSinProveedor: TDataSource;
    dsRepBajaRotacion: TDataSource;
    dsPickResumen: TDataSource;
    dsPickRuta: TDataSource;
    dsPickUbicacion: TDataSource;
    dsPickProveedor: TDataSource;
    dsPickSinUbicacion: TDataSource;
    dsPickRevision: TDataSource;
    dsCalResumen: TDataSource;
    dsCalIncompletos: TDataSource;
    dsCalPrecios: TDataSource;
    dsCalStock: TDataSource;
    dsCalDuplicados: TDataSource;
    dsCalSinMovimiento: TDataSource;
    dsVFResumen: TDataSource;
    dsVFPendientes: TDataSource;
    dsVFAceptadosErrores: TDataSource;
    dsVFErrores: TDataSource;
    dsVFSeries: TDataSource;
    dsVFUltimos: TDataSource;
    dsCmpAvResumen: TDataSource;
    dsCmpAvDia: TDataSource;
    dsCmpAvMes: TDataSource;
    dsCmpAvPeriodo: TDataSource;
    dsLibreResultado: TDataSource;

    gridPagos: TDBGrid;
    gridTopArticulos: TDBGrid;
    gridTopFamilias: TDBGrid;
    gridHoras: TDBGrid;
    gridHoyHoras: TDBGrid;
    gridHoyPagos: TDBGrid;
    gridCGResumen: TDBGrid;
    gridCGNegocio: TDBGrid;
    gridCGHoras: TDBGrid;
    gridCGMargen: TDBGrid;
    gridCGEmpleados: TDBGrid;
    memoCGAnalisis: TMemo;
    gridVNAResumen: TDBGrid;
    gridVNATickets: TDBGrid;
    gridVNADetalle: TDBGrid;
    gridVNAHoras: TDBGrid;
    gridVNARevision: TDBGrid;
    gridCTResumen: TDBGrid;
    gridCTDias: TDBGrid;
    gridCTCandidatos: TDBGrid;
    gridCTSemana: TDBGrid;
    gridCTHoras: TDBGrid;
    memoCTSugerencia: TMemo;
    memoDiagnostico: TMemo;
    gridDiagResumen: TDBGrid;
    gridDiagMargen: TDBGrid;
    gridDiagHoras: TDBGrid;
    gridDiagProveedor: TDBGrid;
    gridAlertas: TDBGrid;
    gridEstVentasDia: TDBGrid;
    gridEstVentasHora: TDBGrid;
    gridEstFamilias: TDBGrid;
    gridEstProveedores: TDBGrid;
    gridEstMargen: TDBGrid;
    gridEstProblemas: TDBGrid;
    gridCompResumen: TDBGrid;
    gridCompDiaActual: TDBGrid;
    gridCompDiaAnterior: TDBGrid;
    gridCompFamilias: TDBGrid;
    gridCompArticulos: TDBGrid;
    gridCompPagos: TDBGrid;
    gridTendResumen: TDBGrid;
    gridTendMeses: TDBGrid;
    gridTendAnual: TDBGrid;
    gridTendSemana: TDBGrid;
    gridTendAlza: TDBGrid;
    gridTendBaja: TDBGrid;
    gridCliResumen: TDBGrid;
    gridCliTopImporte: TDBGrid;
    gridCliTopFrecuencia: TDBGrid;
    gridCliTicketMedio: TDBGrid;
    gridCliSinCliente: TDBGrid;
    gridCliDatosIncompletos: TDBGrid;
    gridPueResumen: TDBGrid;
    gridPueUsuarios: TDBGrid;
    gridPueCajas: TDBGrid;
    gridPueHorasUsuario: TDBGrid;
    gridPuePagosCaja: TDBGrid;
    gridPueRevision: TDBGrid;
    gridComResumen: TDBGrid;
    gridComPendientes: TDBGrid;
    gridComDetallePend: TDBGrid;
    gridComProveedor: TDBGrid;
    gridComArticulos: TDBGrid;
    gridComRevision: TDBGrid;
    gridPromoResumen: TDBGrid;
    gridPromoDescuentos: TDBGrid;
    gridPromoArticulos: TDBGrid;
    gridPromoFamilias: TDBGrid;
    gridPromoBajoCoste: TDBGrid;
    gridPromoRevision: TDBGrid;
    gridRentResumen: TDBGrid;
    gridRentArticulos: TDBGrid;
    gridRentFamilias: TDBGrid;
    gridRentProveedores: TDBGrid;
    gridRentDias: TDBGrid;
    gridRentRevision: TDBGrid;
    gridRotResumen: TDBGrid;
    gridRotAlta: TDBGrid;
    gridRotRiesgo: TDBGrid;
    gridRotBaja: TDBGrid;
    gridRotExceso: TDBGrid;
    gridRotSinVentas: TDBGrid;
    gridRepResumen: TDBGrid;
    gridRepSugerido: TDBGrid;
    gridRepUrgente: TDBGrid;
    gridRepProveedor: TDBGrid;
    gridRepSinProveedor: TDBGrid;
    gridRepBajaRotacion: TDBGrid;
    gridPickResumen: TDBGrid;
    gridPickRuta: TDBGrid;
    gridPickUbicacion: TDBGrid;
    gridPickProveedor: TDBGrid;
    gridPickSinUbicacion: TDBGrid;
    gridPickRevision: TDBGrid;
    gridCalResumen: TDBGrid;
    gridCalIncompletos: TDBGrid;
    gridCalPrecios: TDBGrid;
    gridCalStock: TDBGrid;
    gridCalDuplicados: TDBGrid;
    gridCalSinMovimiento: TDBGrid;
    gridVFResumen: TDBGrid;
    gridVFPendientes: TDBGrid;
    gridVFAceptadosErrores: TDBGrid;
    gridVFErrores: TDBGrid;
    gridVFSeries: TDBGrid;
    gridVFUltimos: TDBGrid;
    gridCmpAvResumen: TDBGrid;
    gridCmpAvDia: TDBGrid;
    gridCmpAvMes: TDBGrid;
    gridCmpAvPeriodo: TDBGrid;
    gridLibreResultado: TDBGrid;
    cbLibreTabla: TComboBox;
    lbLibreCampos: TListBox;
    memoLibreSQL: TMemo;
    btnLibreCargarTablas: TButton;
    btnLibreEjecutarSelector: TButton;
    btnLibreEjecutarSQL: TButton;
    btnLibreGuardarSQL: TButton;
    btnLibreAbrirSQL: TButton;
    btnLibreAbrirCarpetaSQL: TButton;
    lblLibreInfo: TLabel;

    pbGraficoPagos: TPaintBox;
    pbGraficoHoras: TPaintBox;
    pbHoyTicketsHora: TPaintBox;
    pbHoyImportesHora: TPaintBox;
    pbHoyPagos: TPaintBox;
    pbCGNegocio: TPaintBox;
    pbCGHoras: TPaintBox;
    pbCGMargen: TPaintBox;
    pbCGEmpleados: TPaintBox;
    pbGrafAnoActualAnterior: TPaintBox;
    pbGrafTicketMedioHora: TPaintBox;
    pbGrafTicketsHora: TPaintBox;
    pbGrafPagosComparativa: TPaintBox;
    pbGrafComprasVentas: TPaintBox;
    pbGrafVentasCobros: TPaintBox;
    pbCmpAvVentas: TPaintBox;
    pbCmpAvCaja: TPaintBox;

    FPagoCount: Integer;
    FPagoNombres: array[0..19] of string;
    FPagoImportes: array[0..19] of Double;
    FHoraImportes: array[0..23] of Double;
    FHoraTickets: array[0..23] of Integer;

    FHoyPagoCount: Integer;
    FHoyPagoNombres: array[0..19] of string;
    FHoyPagoImportes: array[0..19] of Double;
    FHoyHoraImportes: array[0..23] of Double;
    FHoyHoraTickets: array[0..23] of Integer;

    FCGNegocioCount: Integer;
    FCGNegocioNombres: TString20Array;
    FCGNegocioActual: TDouble20Array;
    FCGNegocioComp: TDouble20Array;
    FCGMargenCount: Integer;
    FCGMargenNombres: TString20Array;
    FCGMargenActual: TDouble20Array;
    FCGMargenComp: TDouble20Array;
    FCGHoraImportesAct: TDoubleHourArray;
    FCGHoraImportesComp: TDoubleHourArray;
    FCGHoraTicketsAct: TIntegerHourArray;
    FCGHoraTicketsComp: TIntegerHourArray;
    FCGEmpleadoCount: Integer;
    FCGEmpleadoNombres: TString20Array;
    FCGEmpleadoImportes: TDouble20Array;

    FGAnoActualYear: Integer;
    FGAnoAnteriorYear: Integer;
    FGAnoActual: TDoubleMonthArray;
    FGAnoAnterior: TDoubleMonthArray;
    FGTicketMedioHora: TDoubleHourArray;
    FGTicketsHora: TIntegerHourArray;
    FGPagoCompCount: Integer;
    FGPagoNombres: TString20Array;
    FGPagoActual: TDouble20Array;
    FGPagoAnterior: TDouble20Array;
    FGComprasMes: TDoubleMonthArray;
    FGVentasMes: TDoubleMonthArray;
    FGVentasCobros: TDoubleMonthArray;
    FGCobrosMes: TDoubleMonthArray;

    FCmpAvCount: Integer;
    FCmpAvEtiquetas: TString6Array;
    FCmpAvVentas: TDouble6Array;
    FCmpAvCaja: TDouble6Array;

    lblAlertaTitulo: TLabel;

    procedure ConstruirPantalla;
    procedure CrearFiltro;
    procedure CrearTabDashboard;
    procedure CrearTabHoy;
    procedure CrearTabCuadroGestion;
    procedure CrearTabVentasAbiertas;
    procedure CrearTabCierreTarde;
    procedure CrearTabDiagnostico;
    procedure CrearTabAlertas;
    procedure CrearTabEstudios;
    procedure CrearTabComparativa;
    procedure CrearTabTendencias;
    procedure CrearTabClientes;
    procedure CrearTabPuestos;
    procedure CrearTabCompras;
    procedure CrearTabPromociones;
    procedure CrearTabRentabilidad;
    procedure CrearTabRotacion;
    procedure CrearTabReposicion;
    procedure CrearTabPicking;
    procedure CrearTabCalidad;
    procedure CrearTabVeriFactu;
    procedure CrearTabGraficas;
    procedure CrearTabComparativaAvanzada;
    procedure CrearTabConsultaLibre;
    procedure OrdenarPestanasPrincipales;
    function PestanaID(APage: TTabSheet): string;
    function PestanaPorID(const AID: string): TTabSheet;
    procedure CargarOrdenPestanas;
    procedure GuardarOrdenPestanas;
    procedure MoverPestanaActiva(Delta: Integer);
    procedure MoverPestanaIzquierdaClick(Sender: TObject);
    procedure MoverPestanaDerechaClick(Sender: TObject);
    procedure RellenarSelectoresPestanas;
    procedure SincronizarSelectoresPestanas;
    procedure SelectorPestanaChange(Sender: TObject);
    procedure SelectorArticulosChange(Sender: TObject);
    procedure SelectorComprasChange(Sender: TObject);
    procedure PaginaPrincipalChange(Sender: TObject);

    function CrearQuery: TZQuery;
    function Tabla(const Base: string): string;
    function TablaExiste(const ANombre: string): Boolean;
    function ColumnaExiste(const ANombreTabla, ANombreCampo: string): Boolean;
    function CampoHoraVentas(const ANombreTabla: string): string;
    function SQLUnionVentasAbiertas: string;
    function FechaDesde: TDateTime;
    function FechaHasta: TDateTime;
    function FechaSQL(const ADate: TDateTime): string;
    function ParseFecha(const S: string; out ADate: TDateTime): Boolean;
    function FechasValidas(out ADesde, AHasta: TDateTime): Boolean;
    procedure SetEditFecha(AEdit: TEdit; const AFecha: TDateTime);
    function ElegirFecha(var AFecha: TDateTime): Boolean;
    procedure AbrirCalendarioFecha(AEdit: TEdit);
    function Dinero(const V: Double): string;
    function Numero(const V: Double): string;
    function CampoDouble(Q: TZQuery; const Campo: string): Double;
    function CampoInteger(Q: TZQuery; const Campo: string): Integer;
    procedure AjustarCampo(Q: TZQuery; const Campo, Titulo: string; Ancho: Integer);
    procedure AjustarCampoMoneda(Q: TZQuery; const Campo, Titulo: string; Ancho: Integer);
    procedure AjustarCampoNumero(Q: TZQuery; const Campo, Titulo: string; Ancho: Integer; const Formato: string);
    procedure AplicarFormatoYAnchos;
    function TextoCSV(const S: string): string;
    function TextoHTML(const S: string): string;
    function TextoPDF(const S: string): AnsiString;
    function TextoPlanoPDF(const S: string): string;
    function TituloGridPDF(Grid: TDBGrid): string;
    procedure RecogerGridsPDF(AControl: TWinControl; AList: TList);
    procedure AnyadirDataSetPDF(L: TStringList; const Titulo: string; DS: TDataSet);
    procedure GuardarLineasPDF(L: TStringList; const AFichero: string);
    procedure ExportarPestanaPDF(const AFichero: string);
    function NombreFicheroSeguro(const S: string): string;
    procedure AnyadirDataSetCSV(L: TStringList; const Titulo: string; DS: TDataSet);
    procedure AnyadirDataSetHTML(L: TStringList; const Titulo: string; DS: TDataSet);
    procedure ExportarPestanaCSV(const AFichero: string);
    procedure ExportarPestanaHTML(const AFichero: string);

    procedure RefrescarTodo(Sender: TObject);
    procedure ExportarCSVClick(Sender: TObject);
    procedure InformeHTMLClick(Sender: TObject);
    procedure InformePDFClick(Sender: TObject);
    procedure CerrarClick(Sender: TObject);
    procedure CalendarioDesdeClick(Sender: TObject);
    procedure CalendarioHastaClick(Sender: TObject);
    procedure RangoHoy(Sender: TObject);
    procedure RangoAyer(Sender: TObject);
    procedure Rango7Dias(Sender: TObject);
    procedure Rango30Dias(Sender: TObject);

    procedure CargarDashboard;
    procedure CargarHoy;
    procedure CargarHoyResumen;
    procedure CargarHoyHoras;
    procedure CargarHoyPagos;
    procedure CargarCuadroGestion;
    function CGFechasValidas(out AActDesde, AActHasta, ACompDesde, ACompHasta: TDateTime): Boolean;
    procedure CGSetPeriodoDia(Sender: TObject);
    procedure CGSetPeriodoMes(Sender: TObject);
    procedure CGSetPeriodoAno(Sender: TObject);
    procedure CGPeriodoManual(Sender: TObject);
    procedure CGRefrescarClick(Sender: TObject);
    procedure CGCalDesdeActClick(Sender: TObject);
    procedure CGCalHastaActClick(Sender: TObject);
    procedure CGCalDesdeCompClick(Sender: TObject);
    procedure CGCalHastaCompClick(Sender: TObject);
    procedure CargarCGResumen;
    procedure CargarCGNegocio;
    procedure CargarCGHoras;
    procedure CargarCGMargen;
    procedure CargarCGEmpleados;
    procedure CargarCGAnalisis;
    procedure ActualizarTarjetasCG;
    procedure PintarCGNegocio(Sender: TObject);
    procedure PintarCGHoras(Sender: TObject);
    procedure PintarCGMargen(Sender: TObject);
    procedure PintarCGEmpleados(Sender: TObject);
    procedure PintarBarrasComparativas(APaintBox: TPaintBox; const ATitulo, ALeg1, ALeg2: string; const ANombres: TString20Array; const AActual, AComp: TDouble20Array; ACount: Integer; const APrefijo, ASufijo: string);
    procedure PintarBarrasHorasComparativas(APaintBox: TPaintBox; const ATitulo: string; const AAct, AComp: TIntegerHourArray);
    procedure CargarVentasAbiertas;
    procedure CargarVNAResumen;
    procedure CargarVNATickets;
    procedure CargarVNADetalle;
    procedure CargarVNAHoras;
    procedure CargarVNARevision;
    procedure CargarCierreTarde;
    procedure CargarCTSugerencia;
    procedure CargarCTResumen;
    procedure CargarCTDias;
    procedure CargarCTCandidatos;
    procedure CargarCTSemana;
    procedure CargarCTHoras;
    procedure CargarDiagnostico;
    procedure CargarDiagResumen;
    procedure CargarDiagMargen;
    procedure CargarDiagHoras;
    procedure CargarDiagProveedor;
    procedure CargarDiagInforme;
    procedure CargarResumen;
    procedure CargarPagos;
    procedure CargarTopArticulos;
    procedure CargarTopFamilias;
    procedure CargarHoras;
    procedure CargarEstudios;
    procedure CargarEstVentasDia;
    procedure CargarEstVentasHora;
    procedure CargarEstFamilias;
    procedure CargarEstProveedores;
    procedure CargarEstMargen;
    procedure CargarEstProblemas;
    procedure CargarComparativa;
    procedure CargarCompResumen;
    procedure CargarCompDiaActual;
    procedure CargarCompDiaAnterior;
    procedure CargarCompFamilias;
    procedure CargarCompArticulos;
    procedure CargarCompPagos;
    procedure CargarTendencias;
    procedure CargarTendResumen;
    procedure CargarTendMeses;
    procedure CargarTendAnual;
    procedure CargarTendSemana;
    procedure CargarTendAlza;
    procedure CargarTendBaja;
    procedure CargarClientes;
    procedure CargarClientesNoDisponible;
    procedure CargarCliResumen;
    procedure CargarCliTopImporte;
    procedure CargarCliTopFrecuencia;
    procedure CargarCliTicketMedio;
    procedure CargarCliSinCliente;
    procedure CargarCliDatosIncompletos;
    procedure CargarPuestos;
    procedure CargarPueResumen;
    procedure CargarPueUsuarios;
    procedure CargarPueCajas;
    procedure CargarPueHorasUsuario;
    procedure CargarPuePagosCaja;
    procedure CargarPueRevision;
    procedure CargarCompras;
    procedure CargarComprasNoDisponible;
    procedure CargarComResumen;
    procedure CargarComPendientes;
    procedure CargarComDetallePend;
    procedure CargarComProveedor;
    procedure CargarComArticulos;
    procedure CargarComRevision;
    procedure CargarPromociones;
    procedure CargarPromoResumen;
    procedure CargarPromoDescuentos;
    procedure CargarPromoArticulos;
    procedure CargarPromoFamilias;
    procedure CargarPromoBajoCoste;
    procedure CargarPromoRevision;
    procedure CargarRentabilidad;
    procedure CargarRentResumen;
    procedure CargarRentArticulos;
    procedure CargarRentFamilias;
    procedure CargarRentProveedores;
    procedure CargarRentDias;
    procedure CargarRentRevision;
    procedure CargarRotacion;
    procedure CargarRotResumen;
    procedure CargarRotAlta;
    procedure CargarRotRiesgo;
    procedure CargarRotBaja;
    procedure CargarRotExceso;
    procedure CargarRotSinVentas;
    procedure CargarReposicion;
    procedure CargarRepResumen;
    procedure CargarRepSugerido;
    procedure CargarRepUrgente;
    procedure CargarRepProveedor;
    procedure CargarRepSinProveedor;
    procedure CargarRepBajaRotacion;
    procedure CargarPicking;
    procedure CargarPickResumen;
    procedure CargarPickRuta;
    procedure CargarPickUbicacion;
    procedure CargarPickProveedor;
    procedure CargarPickSinUbicacion;
    procedure CargarPickRevision;
    procedure CargarCalidad;
    procedure CargarCalResumen;
    procedure CargarCalIncompletos;
    procedure CargarCalPrecios;
    procedure CargarCalStock;
    procedure CargarCalDuplicados;
    procedure CargarCalSinMovimiento;
    procedure CargarVeriFactu;
    procedure CargarVFNoDisponible;
    procedure CargarVFResumen;
    procedure CargarVFPendientes;
    procedure CargarVFAceptadosErrores;
    procedure CargarVFErrores;
    procedure CargarVFSeries;
    procedure CargarVFUltimos;
    procedure CargarGraficas;
    procedure CargarComparativaAvanzada;
    procedure CargarCmpAvResumen;
    procedure CargarCmpAvDia;
    procedure CargarCmpAvMes;
    procedure CargarCmpAvPeriodo;
    procedure ObtenerTotalesComparativa(const ADesde, AHasta: TDateTime; out AVentas, ACajaTotal: Double; out ATickets, ADocsCaja: Integer);
    procedure CalcularDiferenciasComparativa(var ARows: array of TComparativaAvRow);
    procedure AbrirQueryComparativa(Q: TZQuery; const ARows: array of TComparativaAvRow);
    procedure GuardarDatosGraficaComparativa(const ARows: array of TComparativaAvRow);
    procedure PintarComparativaAvanzada(APaintBox: TPaintBox; const ATitulo: string; const AValores: TDouble6Array);
    procedure CmpAvVentasPaint(Sender: TObject);
    procedure CmpAvCajaPaint(Sender: TObject);
    procedure CargarGrafAnoActualAnterior;
    procedure CargarGrafHoras;
    procedure CargarGrafPagosComparativa;
    procedure CargarGrafComprasVentas;
    procedure CargarGrafVentasCobros;
    function IndicePagoGrafica(const ANombre: string): Integer;
    procedure PintarBarrasMeses(APaintBox: TPaintBox; const ATitulo, ALeg1, ALeg2: string; const A1, A2: TDoubleMonthArray; const APrefijo, ASufijo: string);
    procedure PintarBarrasHorasDouble(APaintBox: TPaintBox; const ATitulo: string; const A: TDoubleHourArray; const APrefijo, ASufijo: string);
    procedure PintarBarrasHorasEntero(APaintBox: TPaintBox; const ATitulo: string; const A: TIntegerHourArray);
    procedure PintarPagosComparativa(Sender: TObject);
    procedure GrafAnoActualAnteriorPaint(Sender: TObject);
    procedure GrafTicketMedioHoraPaint(Sender: TObject);
    procedure GrafTicketsHoraPaint(Sender: TObject);
    procedure GrafComprasVentasPaint(Sender: TObject);
    procedure GrafVentasCobrosPaint(Sender: TObject);
    procedure ActualizarDatosGraficoPagos;
    procedure ActualizarDatosGraficoHoras;
    procedure GraficoPagosPaint(Sender: TObject);
    procedure GraficoHorasPaint(Sender: TObject);
    procedure HoyTicketsPaint(Sender: TObject);
    procedure HoyImportesPaint(Sender: TObject);
    procedure HoyPagosPaint(Sender: TObject);

    procedure CargarConsultaLibreTablas;
    procedure CargarConsultaLibreCampos;
    procedure ConsultaLibreTablaChange(Sender: TObject);
    procedure ConsultaLibreCargarTablasClick(Sender: TObject);
    procedure ConsultaLibreEjecutarSelectorClick(Sender: TObject);
    procedure ConsultaLibreEjecutarSQLClick(Sender: TObject);
    procedure ConsultaLibreGuardarSQLClick(Sender: TObject);
    procedure ConsultaLibreAbrirSQLClick(Sender: TObject);
    procedure ConsultaLibreAbrirCarpetaSQLClick(Sender: TObject);
    function DashboardCarpetaConfig: string;
    function DashboardEstadoIni: string;
    procedure CargarEstadoVisual;
    procedure GuardarEstadoVisual;
    function ConsultaLibreCarpetaSQL: string;
    procedure ConsultaLibreCampoMemoGetText(Sender: TField; var AText: string; DisplayText: Boolean);
    procedure ConsultaLibreAplicarTextoBlob;
    function ConsultaLibreCampoEsTextoLargo(const ATabla, ACampo: string): Boolean;
    function ConsultaLibreExpresionCampo(const ATabla, ACampo: string): string;
    function SQLSoloLectura(const ASQL: string): Boolean;
    function IdentificadorSQLSeguro(const S: string): Boolean;
    function SQLIdent(const S: string): string;

    procedure CargarAlerta(AAlerta: TDashboardAlerta);
    procedure AlertaStockBajo(Sender: TObject);
    procedure AlertaCosteCero(Sender: TObject);
    procedure AlertaPVP999(Sender: TObject);
    procedure AlertaFamiliaCero(Sender: TObject);
    procedure AlertaSinProveedor(Sender: TObject);
    procedure AlertaStockCeroVendido30(Sender: TObject);

    procedure AplicarEstiloVisualDashboard;
    procedure EstilizarControl(AControl: TControl);
    procedure EstilizarDBGrid(Grid: TDBGrid);
    procedure DashboardGridPrepareCanvas(Sender: TObject; DataCol: Integer; Column: TColumn; AState: TGridDrawState);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Inicializar(AConnection: TZConnection; const ATienda: string);
  end;

procedure ShowFormDashboardProductividad(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  F: TFDashboardProductividad;
begin
  F := TFDashboardProductividad.Create(AOwner);
  try
    F.Inicializar(AConnection, ATienda);
    F.WindowState := wsMaximized;
    F.ShowModal;
    F.GuardarEstadoVisual;
  finally
    F.Free;
  end;
end;


{ TFLXCalendarPicker }

constructor TFLXCalendarPicker.CreateCalendar(AOwner: TComponent; const AFechaInicial: TDateTime);
const
  DiasSemana: array[0..6] of string = ('L', 'M', 'X', 'J', 'V', 'S', 'D');
var
  I, Row, Col: Integer;
  DiaInicial: Word;
  L: TLabel;
  BaseFecha: TDateTime;
begin
  inherited CreateNew(AOwner, 0);

  Caption := 'Seleccionar fecha';
  Position := poOwnerFormCenter;
  BorderStyle := bsDialog;
  Width := 315;
  Height := 330;
  Color := RGBToColor(245,248,252);
  Font.Color := RGBToColor(0,32,80);

  if AFechaInicial > 0 then
    BaseFecha := AFechaInicial
  else
    BaseFecha := SysUtils.Date;

  DecodeDate(BaseFecha, FYear, FMonth, DiaInicial);
  FSelectedDate := Trunc(BaseFecha);

  btnPrev := TButton.Create(Self);
  btnPrev.Parent := Self;
  btnPrev.Left := 8;
  btnPrev.Top := 8;
  btnPrev.Width := 34;
  btnPrev.Height := 28;
  btnPrev.Caption := '<';
  btnPrev.Font.Style := [fsBold];
  btnPrev.Font.Color := RGBToColor(0,32,80);
  btnPrev.OnClick := @PrevClick;

  lblTitulo := TLabel.Create(Self);
  lblTitulo.Parent := Self;
  lblTitulo.Left := 48;
  lblTitulo.Top := 14;
  lblTitulo.Width := 210;
  lblTitulo.Alignment := taCenter;
  lblTitulo.Font.Style := [fsBold];
  lblTitulo.Font.Size := 10;
  lblTitulo.Font.Color := RGBToColor(0,32,80);

  btnNext := TButton.Create(Self);
  btnNext.Parent := Self;
  btnNext.Left := 266;
  btnNext.Top := 8;
  btnNext.Width := 34;
  btnNext.Height := 28;
  btnNext.Caption := '>';
  btnNext.Font.Style := [fsBold];
  btnNext.Font.Color := RGBToColor(0,32,80);
  btnNext.OnClick := @NextClick;

  for I := 0 to 6 do
  begin
    L := TLabel.Create(Self);
    L.Parent := Self;
    L.Left := 14 + (I * 41);
    L.Top := 48;
    L.Width := 34;
    L.Alignment := taCenter;
    L.Caption := DiasSemana[I];
    L.Font.Style := [fsBold];
    L.Font.Color := RGBToColor(0,32,80);
  end;

  for I := 1 to 42 do
  begin
    Row := (I - 1) div 7;
    Col := (I - 1) mod 7;
    FDayButtons[I] := TButton.Create(Self);
    FDayButtons[I].Parent := Self;
    FDayButtons[I].Left := 10 + (Col * 41);
    FDayButtons[I].Top := 68 + (Row * 31);
    FDayButtons[I].Width := 38;
    FDayButtons[I].Height := 28;
    FDayButtons[I].Caption := '';
    FDayButtons[I].Tag := 0;
    FDayButtons[I].Font.Color := RGBToColor(38,62,92);
    FDayButtons[I].OnClick := @DiaClick;
  end;

  btnHoy := TButton.Create(Self);
  btnHoy.Parent := Self;
  btnHoy.Left := 10;
  btnHoy.Top := 262;
  btnHoy.Width := 120;
  btnHoy.Height := 30;
  btnHoy.Caption := 'Hoy';
  btnHoy.Font.Style := [fsBold];
  btnHoy.Font.Color := RGBToColor(0,32,80);
  btnHoy.OnClick := @HoyClick;

  btnCancelar := TButton.Create(Self);
  btnCancelar.Parent := Self;
  btnCancelar.Left := 180;
  btnCancelar.Top := 262;
  btnCancelar.Width := 120;
  btnCancelar.Height := 30;
  btnCancelar.Caption := 'Cancelar';
  btnCancelar.Font.Color := RGBToColor(0,32,80);
  btnCancelar.Cancel := True;
  btnCancelar.ModalResult := mrCancel;

  PintarCalendario;
end;

procedure TFLXCalendarPicker.PrevClick(Sender: TObject);
begin
  if FMonth = 1 then
  begin
    FMonth := 12;
    Dec(FYear);
  end
  else
    Dec(FMonth);
  PintarCalendario;
end;

procedure TFLXCalendarPicker.NextClick(Sender: TObject);
begin
  if FMonth = 12 then
  begin
    FMonth := 1;
    Inc(FYear);
  end
  else
    Inc(FMonth);
  PintarCalendario;
end;

procedure TFLXCalendarPicker.HoyClick(Sender: TObject);
begin
  FSelectedDate := SysUtils.Date;
  ModalResult := mrOk;
end;

procedure TFLXCalendarPicker.DiaClick(Sender: TObject);
var
  D: Integer;
begin
  D := (Sender as TButton).Tag;
  if D <= 0 then Exit;
  FSelectedDate := EncodeDate(FYear, FMonth, D);
  ModalResult := mrOk;
end;

procedure TFLXCalendarPicker.PintarCalendario;
var
  I, D, Offset, NumDias: Integer;
  PrimerDia: TDateTime;
  Btn: TButton;
  SelY, SelM, SelD: Word;
begin
  lblTitulo.Caption := FormatDateTime('mmmm yyyy', EncodeDate(FYear, FMonth, 1));

  for I := 1 to 42 do
  begin
    FDayButtons[I].Caption := '';
    FDayButtons[I].Tag := 0;
    FDayButtons[I].Enabled := False;
    FDayButtons[I].Font.Style := [];
    FDayButtons[I].Font.Color := RGBToColor(90,105,125);
    FDayButtons[I].Color := clBtnFace;
  end;

  PrimerDia := EncodeDate(FYear, FMonth, 1);
  Offset := DayOfWeek(PrimerDia) - 2; // lunes = 0
  if Offset < 0 then Offset := 6;
  NumDias := DaysInAMonth(FYear, FMonth);

  DecodeDate(FSelectedDate, SelY, SelM, SelD);

  for D := 1 to NumDias do
  begin
    I := Offset + D;
    if (I >= 1) and (I <= 42) then
    begin
      Btn := FDayButtons[I];
      Btn.Caption := IntToStr(D);
      Btn.Tag := D;
      Btn.Enabled := True;
      Btn.Font.Color := RGBToColor(38,62,92);
      if (SelY = FYear) and (SelM = FMonth) and (SelD = D) then
      begin
        Btn.Caption := '[' + IntToStr(D) + ']';
        Btn.Font.Style := [fsBold];
        Btn.Font.Color := clWhite;
        Btn.Color := RGBToColor(0,82,160);
      end;
    end;
  end;
end;

{ TFDashboardProductividad }

constructor TFDashboardProductividad.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner, 0);

  Caption := 'FacturLinEx - Productividad / Dashboard';
  Position := poScreenCenter;
  Width := 1180;
  Height := 720;
  BorderIcons := [biSystemMenu, biMinimize, biMaximize];
  WindowState := wsMaximized;

  ConstruirPantalla;
end;

procedure TFDashboardProductividad.Inicializar(AConnection: TZConnection; const ATienda: string);
begin
  FConn := AConnection;
  FTienda := Trim(ATienda);
  if FTienda = '' then
    FTienda := '0000';

  if FConn = nil then
    raise Exception.Create('No se ha recibido conexión MariaDB para el dashboard.');

  if not FConn.Connected then
    FConn.Connect;

  qPagos.Connection := FConn;
  qTopArticulos.Connection := FConn;
  qTopFamilias.Connection := FConn;
  qHoras.Connection := FConn;
  qHoyResumen.Connection := FConn;
  qHoyHoras.Connection := FConn;
  qHoyPagos.Connection := FConn;
  qCGResumen.Connection := FConn;
  qCGNegocio.Connection := FConn;
  qCGHoras.Connection := FConn;
  qCGMargen.Connection := FConn;
  qCGEmpleados.Connection := FConn;
  qVNAResumen.Connection := FConn;
  qVNATickets.Connection := FConn;
  qVNADetalle.Connection := FConn;
  qVNAHoras.Connection := FConn;
  qVNARevision.Connection := FConn;
  qCTResumen.Connection := FConn;
  qCTDias.Connection := FConn;
  qCTCandidatos.Connection := FConn;
  qCTSemana.Connection := FConn;
  qCTHoras.Connection := FConn;
  qDiagResumen.Connection := FConn;
  qDiagMargen.Connection := FConn;
  qDiagHoras.Connection := FConn;
  qDiagProveedor.Connection := FConn;
  qAlertas.Connection := FConn;
  qEstVentasDia.Connection := FConn;
  qEstVentasHora.Connection := FConn;
  qEstFamilias.Connection := FConn;
  qEstProveedores.Connection := FConn;
  qEstMargen.Connection := FConn;
  qEstProblemas.Connection := FConn;
  qCompResumen.Connection := FConn;
  qCompDiaActual.Connection := FConn;
  qCompDiaAnterior.Connection := FConn;
  qCompFamilias.Connection := FConn;
  qCompArticulos.Connection := FConn;
  qCompPagos.Connection := FConn;
  qTendResumen.Connection := FConn;
  qTendMeses.Connection := FConn;
  qTendAnual.Connection := FConn;
  qTendSemana.Connection := FConn;
  qTendAlza.Connection := FConn;
  qTendBaja.Connection := FConn;
  qCliResumen.Connection := FConn;
  qCliTopImporte.Connection := FConn;
  qCliTopFrecuencia.Connection := FConn;
  qCliTicketMedio.Connection := FConn;
  qCliSinCliente.Connection := FConn;
  qCliDatosIncompletos.Connection := FConn;
  qPueResumen.Connection := FConn;
  qPueUsuarios.Connection := FConn;
  qPueCajas.Connection := FConn;
  qPueHorasUsuario.Connection := FConn;
  qPuePagosCaja.Connection := FConn;
  qPueRevision.Connection := FConn;
  qComResumen.Connection := FConn;
  qComPendientes.Connection := FConn;
  qComDetallePend.Connection := FConn;
  qComProveedor.Connection := FConn;
  qComArticulos.Connection := FConn;
  qComRevision.Connection := FConn;
  qPromoResumen.Connection := FConn;
  qPromoDescuentos.Connection := FConn;
  qPromoArticulos.Connection := FConn;
  qPromoFamilias.Connection := FConn;
  qPromoBajoCoste.Connection := FConn;
  qPromoRevision.Connection := FConn;
  qRentResumen.Connection := FConn;
  qRentArticulos.Connection := FConn;
  qRentFamilias.Connection := FConn;
  qRentProveedores.Connection := FConn;
  qRentDias.Connection := FConn;
  qRentRevision.Connection := FConn;
  qRotResumen.Connection := FConn;
  qRotAlta.Connection := FConn;
  qRotRiesgo.Connection := FConn;
  qRotBaja.Connection := FConn;
  qRotExceso.Connection := FConn;
  qRotSinVentas.Connection := FConn;
  qRepResumen.Connection := FConn;
  qRepSugerido.Connection := FConn;
  qRepUrgente.Connection := FConn;
  qRepProveedor.Connection := FConn;
  qRepSinProveedor.Connection := FConn;
  qRepBajaRotacion.Connection := FConn;
  qPickResumen.Connection := FConn;
  qPickRuta.Connection := FConn;
  qPickUbicacion.Connection := FConn;
  qPickProveedor.Connection := FConn;
  qPickSinUbicacion.Connection := FConn;
  qPickRevision.Connection := FConn;
  qCalResumen.Connection := FConn;
  qCalIncompletos.Connection := FConn;
  qCalPrecios.Connection := FConn;
  qCalStock.Connection := FConn;
  qCalDuplicados.Connection := FConn;
  qCalSinMovimiento.Connection := FConn;
  qVFResumen.Connection := FConn;
  qVFPendientes.Connection := FConn;
  qVFAceptadosErrores.Connection := FConn;
  qVFErrores.Connection := FConn;
  qVFSeries.Connection := FConn;
  qVFUltimos.Connection := FConn;
  qCmpAvResumen.Connection := FConn;
  qCmpAvDia.Connection := FConn;
  qCmpAvMes.Connection := FConn;
  qCmpAvPeriodo.Connection := FConn;
  qLibreTablas.Connection := FConn;
  qLibreCampos.Connection := FConn;
  qLibreResultado.Connection := FConn;

  WindowState := wsMaximized;
  CargarConsultaLibreTablas;

  // La pesta�a principal al abrir Productividad debe ser siempre Dashboard.
  // CargarEstadoVisual solo recupera las fechas; no debe reabrir Alertas u otra pesta�a.
  pcPrincipal.ActivePage := tsDashboard;
  CargarEstadoVisual;
  pcPrincipal.ActivePage := tsDashboard;

  CargarDashboard;
  CargarAlerta(daStockBajo);

  // CargarAlerta prepara los datos de la pesta�a Alertas y, por dise�o,
  // cambia a esa pesta�a cuando se pulsa un bot�n de alerta.
  // Durante la apertura del formulario queremos dejarla cargada, pero
  // la pesta�a visible inicial debe ser siempre Dashboard.
  if pcPrincipal <> nil then
    pcPrincipal.ActivePage := tsDashboard;
end;

procedure TFDashboardProductividad.ConstruirPantalla;
begin
  CrearFiltro;

  pcPrincipal := TPageControl.Create(Self);
  pcPrincipal.Parent := Self;
  pcPrincipal.Align := alClient;
  pcPrincipal.MultiLine := False;
  pcPrincipal.ShowTabs := True;
  pcPrincipal.TabPosition := tpTop;
  pcPrincipal.OnChange := @PaginaPrincipalChange;

  tsDashboard := TTabSheet.Create(Self);
  tsDashboard.PageControl := pcPrincipal;
  tsDashboard.Caption := 'Dashboard';

  tsHoy := TTabSheet.Create(Self);
  tsHoy.PageControl := pcPrincipal;
  tsHoy.Caption := 'Hoy';

  tsCuadroGestion := TTabSheet.Create(Self);
  tsCuadroGestion.PageControl := pcPrincipal;
  tsCuadroGestion.Caption := 'Cuadro gestion';

  tsVentasAbiertas := TTabSheet.Create(Self);
  tsVentasAbiertas.PageControl := pcPrincipal;
  tsVentasAbiertas.Caption := 'Ventas ab.';

  tsCierreTarde := TTabSheet.Create(Self);
  tsCierreTarde.PageControl := pcPrincipal;
  tsCierreTarde.Caption := 'Cierre tardes';

  tsDiagnostico := TTabSheet.Create(Self);
  tsDiagnostico.PageControl := pcPrincipal;
  tsDiagnostico.Caption := 'Diagnostico';

  tsAlertas := TTabSheet.Create(Self);
  tsAlertas.PageControl := pcPrincipal;
  tsAlertas.Caption := 'Alertas';

  tsEstudios := TTabSheet.Create(Self);
  tsEstudios.PageControl := pcPrincipal;
  tsEstudios.Caption := 'Estudios';

  tsComparativa := TTabSheet.Create(Self);
  tsComparativa.PageControl := pcPrincipal;
  tsComparativa.Caption := 'Comparativa';

  tsTendencias := TTabSheet.Create(Self);
  tsTendencias.PageControl := pcPrincipal;
  tsTendencias.Caption := 'Tendencias';

  tsClientes := TTabSheet.Create(Self);
  tsClientes.PageControl := pcPrincipal;
  tsClientes.Caption := 'Clientes';

  tsPuestos := TTabSheet.Create(Self);
  tsPuestos.PageControl := pcPrincipal;
  tsPuestos.Caption := 'Puestos';

  tsCompras := TTabSheet.Create(Self);
  tsCompras.PageControl := pcPrincipal;
  tsCompras.Caption := 'Compras';

  tsPromociones := TTabSheet.Create(Self);
  tsPromociones.PageControl := pcPrincipal;
  tsPromociones.Caption := 'Promociones';

  tsRentabilidad := TTabSheet.Create(Self);
  tsRentabilidad.PageControl := pcPrincipal;
  tsRentabilidad.Caption := 'Rentabilidad';

  tsRotacion := TTabSheet.Create(Self);
  tsRotacion.PageControl := pcPrincipal;
  tsRotacion.Caption := 'Rotación';

  tsReposicion := TTabSheet.Create(Self);
  tsReposicion.PageControl := pcPrincipal;
  tsReposicion.Caption := 'Reposición';

  tsPicking := TTabSheet.Create(Self);
  tsPicking.PageControl := pcPrincipal;
  tsPicking.Caption := 'Preparación';

  tsCalidad := TTabSheet.Create(Self);
  tsCalidad.PageControl := pcPrincipal;
  tsCalidad.Caption := 'Calidad';

  tsVeriFactu := TTabSheet.Create(Self);
  tsVeriFactu.PageControl := pcPrincipal;
  tsVeriFactu.Caption := 'VeriFactu';

  tsGraficas := TTabSheet.Create(Self);
  tsGraficas.PageControl := pcPrincipal;
  tsGraficas.Caption := 'Gráficas';

  tsComparativaAvanzada := TTabSheet.Create(Self);
  tsComparativaAvanzada.PageControl := pcPrincipal;
  tsComparativaAvanzada.Caption := 'Comp. fechas';

  tsConsultaLibre := TTabSheet.Create(Self);
  tsConsultaLibre.PageControl := pcPrincipal;
  tsConsultaLibre.Caption := 'SQL libre';

  CrearTabDashboard;
  CrearTabHoy;
  CrearTabCuadroGestion;
  CrearTabVentasAbiertas;
  CrearTabCierreTarde;
  CrearTabDiagnostico;
  CrearTabAlertas;
  CrearTabEstudios;
  CrearTabComparativa;
  CrearTabTendencias;
  CrearTabClientes;
  CrearTabPuestos;
  CrearTabCompras;
  CrearTabPromociones;
  CrearTabRentabilidad;
  CrearTabRotacion;
  CrearTabReposicion;
  CrearTabPicking;
  CrearTabCalidad;
  CrearTabVeriFactu;
  CrearTabGraficas;
  CrearTabComparativaAvanzada;
  CrearTabConsultaLibre;

  OrdenarPestanasPrincipales;
  CargarOrdenPestanas;
  RellenarSelectoresPestanas;
  AplicarEstiloVisualDashboard;
end;


procedure TFDashboardProductividad.DashboardGridPrepareCanvas(Sender: TObject; DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  if not (Sender is TDBGrid) then Exit;

  with TDBGrid(Sender).Canvas do
  begin
    Font.Color := clBlack;
    if gdSelected in AState then
    begin
      Brush.Color := RGBToColor(214,232,252);
      Font.Color := clBlack;
      Font.Style := [];
    end
    else if gdFixed in AState then
    begin
      Brush.Color := RGBToColor(232,238,247);
      Font.Color := RGBToColor(0,32,80);
      Font.Style := [fsBold];
    end
    else
    begin
      Brush.Color := clWhite;
      Font.Color := clBlack;
      Font.Style := [];
    end;
  end;
end;

procedure TFDashboardProductividad.EstilizarDBGrid(Grid: TDBGrid);
begin
  if Grid = nil then Exit;

  Grid.Color := clWhite;
  Grid.Font.Color := clBlack;
  Grid.Font.Size := 9;
  Grid.DefaultRowHeight := 24;
  Grid.TitleFont.Color := RGBToColor(0,32,80);
  Grid.TitleFont.Style := [fsBold];
  Grid.FixedColor := RGBToColor(232,238,247);
  Grid.Options := Grid.Options + [dgTitles, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection];
  Grid.OnPrepareCanvas := @DashboardGridPrepareCanvas;
end;

procedure TFDashboardProductividad.EstilizarControl(AControl: TControl);
var
  I: Integer;
  P: TPanel;
  G: TGroupBox;
begin
  if AControl = nil then Exit;

  if AControl is TPanel then
  begin
    P := TPanel(AControl);
    if P = pnlFiltro then
    begin
      P.Color := RGBToColor(235,243,255);
      P.BevelOuter := bvNone;
    end
    else
    begin
      if P.Color = clDefault then
        P.Color := RGBToColor(245,248,252);
      if P.BevelOuter <> bvLowered then
        P.BevelOuter := bvNone;

      // Tarjetas/KPI compactas: aspecto más limpio sin cambiar medidas.
      if (P.Height >= 60) and (P.Height <= 110) and (P.Width >= 140) and (P.Width <= 260) then
      begin
        P.Color := RGBToColor(250,252,255);
        P.BevelOuter := bvLowered;
      end;
    end;
  end
  else if AControl is TGroupBox then
  begin
    G := TGroupBox(AControl);
    G.Color := RGBToColor(250,252,255);
    G.Font.Color := RGBToColor(0,32,80);
    G.Font.Style := [fsBold];
  end
  else if AControl is TDBGrid then
    EstilizarDBGrid(TDBGrid(AControl))
  else if AControl is TLabel then
  begin
    TLabel(AControl).Transparent := True;
    if fsBold in TLabel(AControl).Font.Style then
      TLabel(AControl).Font.Color := RGBToColor(0,32,80)
    else
      TLabel(AControl).Font.Color := RGBToColor(38,62,92);
  end
  else if AControl is TEdit then
  begin
    TEdit(AControl).Color := clWhite;
    TEdit(AControl).Font.Color := clBlack;
  end
  else if AControl is TComboBox then
  begin
    TComboBox(AControl).Color := clWhite;
    TComboBox(AControl).Font.Color := clBlack;
  end
  else if AControl is TMemo then
  begin
    TMemo(AControl).Color := RGBToColor(252,254,255);
    TMemo(AControl).Font.Color := clBlack;
  end
  else if AControl is TSplitter then
    TSplitter(AControl).Color := RGBToColor(230,236,245)
  else if AControl is TBitBtn then
  begin
    TBitBtn(AControl).Font.Color := RGBToColor(0,32,80);
    if TBitBtn(AControl).Height < 28 then
      TBitBtn(AControl).Height := 28;
  end
  else if AControl is TButton then
  begin
    TButton(AControl).Font.Color := RGBToColor(0,32,80);
    if TButton(AControl).Height < 25 then
      TButton(AControl).Height := 25;
  end;

  if AControl is TWinControl then
    for I := 0 to TWinControl(AControl).ControlCount - 1 do
      EstilizarControl(TWinControl(AControl).Controls[I]);
end;

procedure TFDashboardProductividad.AplicarEstiloVisualDashboard;
begin
  Color := RGBToColor(245,248,252);

  if pcPrincipal <> nil then
  begin
    pcPrincipal.Color := RGBToColor(245,248,252);
    pcPrincipal.Font.Color := RGBToColor(0,32,80);
    pcPrincipal.Font.Style := [fsBold];
  end;

  EstilizarControl(Self);

  // El filtro superior se mantiene compacto, pero con un aspecto más moderno.
  if pnlFiltro <> nil then
  begin
    pnlFiltro.Height := 70;
    pnlFiltro.Color := RGBToColor(235,243,255);
  end;
end;


procedure TFDashboardProductividad.OrdenarPestanasPrincipales;
  procedure P(APage: TTabSheet; AIndex: Integer);
  begin
    if APage <> nil then
      APage.PageIndex := AIndex;
  end;
begin
  if pcPrincipal = nil then Exit;

  // Orden agrupado y estable, sin ocultar pestanas ni usar popups.
  // Evita los Access Violation de las pruebas con pestanas dinamicas en GTK.
  P(tsDashboard, 0);
  P(tsHoy, 1);
  P(tsCuadroGestion, 2);
  P(tsDiagnostico, 3);
  P(tsComparativa, 4);
  P(tsComparativaAvanzada, 5);
  P(tsVentasAbiertas, 6);
  P(tsCierreTarde, 7);
  P(tsEstudios, 8);
  P(tsRentabilidad, 9);
  P(tsAlertas, 10);
  P(tsRotacion, 11);
  P(tsTendencias, 12);
  P(tsClientes, 13);
  P(tsPuestos, 14);
  P(tsPromociones, 15);
  P(tsCompras, 16);
  P(tsReposicion, 17);
  P(tsPicking, 18);
  P(tsCalidad, 19);
  P(tsVeriFactu, 20);
  P(tsGraficas, 21);
  P(tsConsultaLibre, 22);
end;


function TFDashboardProductividad.PestanaID(APage: TTabSheet): string;
begin
  Result := '';
  if APage = tsDashboard then Result := 'dashboard'
  else if APage = tsHoy then Result := 'hoy'
  else if APage = tsCuadroGestion then Result := 'cuadro_gestion'
  else if APage = tsDiagnostico then Result := 'diagnostico'
  else if APage = tsComparativa then Result := 'comparativa'
  else if APage = tsComparativaAvanzada then Result := 'comp_fechas'
  else if APage = tsVentasAbiertas then Result := 'ventas_abiertas'
  else if APage = tsCierreTarde then Result := 'cierre_tardes'
  else if APage = tsEstudios then Result := 'estudios'
  else if APage = tsRentabilidad then Result := 'rentabilidad'
  else if APage = tsAlertas then Result := 'alertas'
  else if APage = tsRotacion then Result := 'rotacion'
  else if APage = tsTendencias then Result := 'tendencias'
  else if APage = tsClientes then Result := 'clientes'
  else if APage = tsPuestos then Result := 'puestos'
  else if APage = tsPromociones then Result := 'promociones'
  else if APage = tsCompras then Result := 'compras'
  else if APage = tsReposicion then Result := 'reposicion'
  else if APage = tsPicking then Result := 'preparacion'
  else if APage = tsCalidad then Result := 'calidad'
  else if APage = tsVeriFactu then Result := 'verifactu'
  else if APage = tsGraficas then Result := 'graficas'
  else if APage = tsConsultaLibre then Result := 'sql_libre';
end;

function TFDashboardProductividad.PestanaPorID(const AID: string): TTabSheet;
var
  K: string;
begin
  Result := nil;
  K := LowerCase(Trim(AID));
  if K = 'dashboard' then Result := tsDashboard
  else if K = 'hoy' then Result := tsHoy
  else if K = 'cuadro_gestion' then Result := tsCuadroGestion
  else if K = 'diagnostico' then Result := tsDiagnostico
  else if K = 'comparativa' then Result := tsComparativa
  else if K = 'comp_fechas' then Result := tsComparativaAvanzada
  else if K = 'ventas_abiertas' then Result := tsVentasAbiertas
  else if K = 'cierre_tardes' then Result := tsCierreTarde
  else if K = 'estudios' then Result := tsEstudios
  else if K = 'rentabilidad' then Result := tsRentabilidad
  else if K = 'alertas' then Result := tsAlertas
  else if K = 'rotacion' then Result := tsRotacion
  else if K = 'tendencias' then Result := tsTendencias
  else if K = 'clientes' then Result := tsClientes
  else if K = 'puestos' then Result := tsPuestos
  else if K = 'promociones' then Result := tsPromociones
  else if K = 'compras' then Result := tsCompras
  else if K = 'reposicion' then Result := tsReposicion
  else if K = 'preparacion' then Result := tsPicking
  else if K = 'calidad' then Result := tsCalidad
  else if K = 'verifactu' then Result := tsVeriFactu
  else if K = 'graficas' then Result := tsGraficas
  else if K = 'sql_libre' then Result := tsConsultaLibre;
end;

procedure TFDashboardProductividad.CargarOrdenPestanas;
var
  INI: TIniFile;
  S: string;
  L: TStringList;
  I, PosIndex: Integer;
  APage: TTabSheet;
begin
  if pcPrincipal = nil then Exit;

  INI := TIniFile.Create(DashboardEstadoIni);
  L := TStringList.Create;
  try
    S := Trim(INI.ReadString('Pestanas', 'Orden', ''));
    if S = '' then Exit;

    ExtractStrings([','], [' '], PChar(S), L);
    PosIndex := 0;
    for I := 0 to L.Count - 1 do
    begin
      APage := PestanaPorID(L[I]);
      if APage <> nil then
      begin
        APage.PageIndex := PosIndex;
        Inc(PosIndex);
      end;
    end;
  finally
    L.Free;
    INI.Free;
  end;
end;

procedure TFDashboardProductividad.GuardarOrdenPestanas;
var
  INI: TIniFile;
  I: Integer;
  ID, S: string;
begin
  if pcPrincipal = nil then Exit;

  S := '';
  for I := 0 to pcPrincipal.PageCount - 1 do
  begin
    ID := PestanaID(pcPrincipal.Pages[I]);
    if ID <> '' then
    begin
      if S <> '' then
        S := S + ',';
      S := S + ID;
    end;
  end;

  INI := TIniFile.Create(DashboardEstadoIni);
  try
    INI.WriteString('Pestanas', 'Orden', S);
  finally
    INI.Free;
  end;
end;

procedure TFDashboardProductividad.MoverPestanaActiva(Delta: Integer);
var
  APage: TTabSheet;
  NewIndex: Integer;
begin
  if (pcPrincipal = nil) or (pcPrincipal.ActivePage = nil) then Exit;

  APage := pcPrincipal.ActivePage;
  NewIndex := APage.PageIndex + Delta;
  if NewIndex < 0 then NewIndex := 0;
  if NewIndex >= pcPrincipal.PageCount then NewIndex := pcPrincipal.PageCount - 1;
  if NewIndex = APage.PageIndex then Exit;

  APage.PageIndex := NewIndex;
  pcPrincipal.ActivePage := APage;
  RellenarSelectoresPestanas;
  SincronizarSelectoresPestanas;
  GuardarOrdenPestanas;
end;

procedure TFDashboardProductividad.MoverPestanaIzquierdaClick(Sender: TObject);
begin
  MoverPestanaActiva(-1);
end;

procedure TFDashboardProductividad.MoverPestanaDerechaClick(Sender: TObject);
begin
  MoverPestanaActiva(1);
end;

procedure TFDashboardProductividad.RellenarSelectoresPestanas;
  procedure AddP(CB: TComboBox; const ACaption: string; APage: TTabSheet);
  begin
    if (CB <> nil) and (APage <> nil) then
      CB.Items.AddObject(ACaption, TObject(APage));
  end;
var
  I: Integer;
  APage: TTabSheet;
begin
  FActualizandoSelector := True;
  try
    if cbIrAPestana <> nil then
    begin
      cbIrAPestana.Items.Clear;
      if pcPrincipal <> nil then
      begin
        for I := 0 to pcPrincipal.PageCount - 1 do
        begin
          APage := pcPrincipal.Pages[I];
          AddP(cbIrAPestana, APage.Caption, APage);
        end;
      end;
    end;

    // En esta version se deja un unico desplegable principal "Ir a".
    // Se mantienen estas comprobaciones por compatibilidad si alguna prueba anterior
    // hubiera dejado creados los combos de grupo.
    if cbGrupoArticulos <> nil then
    begin
      cbGrupoArticulos.Items.Clear;
      AddP(cbGrupoArticulos, 'Alertas', tsAlertas);
      AddP(cbGrupoArticulos, 'Rotacion', tsRotacion);
      AddP(cbGrupoArticulos, 'Tendencias', tsTendencias);
    end;

    if cbGrupoCompras <> nil then
    begin
      cbGrupoCompras.Items.Clear;
      AddP(cbGrupoCompras, 'Compras', tsCompras);
      AddP(cbGrupoCompras, 'Reposicion', tsReposicion);
      AddP(cbGrupoCompras, 'Preparacion', tsPicking);
    end;
  finally
    FActualizandoSelector := False;
  end;

  SincronizarSelectoresPestanas;
end;

procedure TFDashboardProductividad.SincronizarSelectoresPestanas;
  procedure SyncCB(CB: TComboBox; APage: TTabSheet);
  var
    I: Integer;
  begin
    if CB = nil then Exit;
    CB.ItemIndex := -1;
    if APage = nil then Exit;
    for I := 0 to CB.Items.Count - 1 do
      if CB.Items.Objects[I] = TObject(APage) then
      begin
        CB.ItemIndex := I;
        Break;
      end;
  end;
begin
  if (pcPrincipal = nil) or (pcPrincipal.ActivePage = nil) then Exit;

  FActualizandoSelector := True;
  try
    SyncCB(cbIrAPestana, pcPrincipal.ActivePage);
    SyncCB(cbGrupoArticulos, pcPrincipal.ActivePage);
    SyncCB(cbGrupoCompras, pcPrincipal.ActivePage);
  finally
    FActualizandoSelector := False;
  end;
end;

procedure TFDashboardProductividad.SelectorPestanaChange(Sender: TObject);
var
  APage: TTabSheet;
begin
  if FActualizandoSelector then Exit;
  if (cbIrAPestana = nil) or (cbIrAPestana.ItemIndex < 0) then Exit;

  APage := TTabSheet(cbIrAPestana.Items.Objects[cbIrAPestana.ItemIndex]);
  if (pcPrincipal <> nil) and (APage <> nil) then
    pcPrincipal.ActivePage := APage;
  SincronizarSelectoresPestanas;
end;

procedure TFDashboardProductividad.SelectorArticulosChange(Sender: TObject);
var
  APage: TTabSheet;
begin
  if FActualizandoSelector then Exit;
  if (cbGrupoArticulos = nil) or (cbGrupoArticulos.ItemIndex < 0) then Exit;

  APage := TTabSheet(cbGrupoArticulos.Items.Objects[cbGrupoArticulos.ItemIndex]);
  if (pcPrincipal <> nil) and (APage <> nil) then
    pcPrincipal.ActivePage := APage;
  SincronizarSelectoresPestanas;
end;

procedure TFDashboardProductividad.SelectorComprasChange(Sender: TObject);
var
  APage: TTabSheet;
begin
  if FActualizandoSelector then Exit;
  if (cbGrupoCompras = nil) or (cbGrupoCompras.ItemIndex < 0) then Exit;

  APage := TTabSheet(cbGrupoCompras.Items.Objects[cbGrupoCompras.ItemIndex]);
  if (pcPrincipal <> nil) and (APage <> nil) then
    pcPrincipal.ActivePage := APage;
  SincronizarSelectoresPestanas;
end;

procedure TFDashboardProductividad.PaginaPrincipalChange(Sender: TObject);
begin
  SincronizarSelectoresPestanas;
end;

procedure TFDashboardProductividad.CrearFiltro;
var
  L: TLabel;
begin
  pnlFiltro := TPanel.Create(Self);
  pnlFiltro.Parent := Self;
  pnlFiltro.Align := alTop;
  pnlFiltro.Height := 72;
  pnlFiltro.BevelOuter := bvNone;

  L := TLabel.Create(Self);
  L.Parent := pnlFiltro;
  L.Caption := 'Desde:';
  L.Left := 10;
  L.Top := 13;

  dtDesde := TEdit.Create(Self);
  dtDesde.Parent := pnlFiltro;
  dtDesde.Left := 58;
  dtDesde.Top := 8;
  dtDesde.Width := 105;
  dtDesde.Text := FormatDateTime('dd/mm/yyyy', SysUtils.Date);
  dtDesde.Hint := 'Fecha desde en formato dd/mm/aaaa';
  dtDesde.ShowHint := True;

  btnCalDesde := TButton.Create(Self);
  btnCalDesde.Parent := pnlFiltro;
  btnCalDesde.Left := 166;
  btnCalDesde.Top := 8;
  btnCalDesde.Width := 28;
  btnCalDesde.Height := 24;
  btnCalDesde.Caption := '...';
  btnCalDesde.Hint := 'Elegir fecha desde en calendario';
  btnCalDesde.ShowHint := True;
  btnCalDesde.OnClick := @CalendarioDesdeClick;

  L := TLabel.Create(Self);
  L.Parent := pnlFiltro;
  L.Caption := 'Hasta:';
  L.Left := 205;
  L.Top := 13;

  dtHasta := TEdit.Create(Self);
  dtHasta.Parent := pnlFiltro;
  dtHasta.Left := 253;
  dtHasta.Top := 8;
  dtHasta.Width := 105;
  dtHasta.Text := FormatDateTime('dd/mm/yyyy', SysUtils.Date);
  dtHasta.Hint := 'Fecha hasta en formato dd/mm/aaaa';
  dtHasta.ShowHint := True;

  btnCalHasta := TButton.Create(Self);
  btnCalHasta.Parent := pnlFiltro;
  btnCalHasta.Left := 361;
  btnCalHasta.Top := 8;
  btnCalHasta.Width := 28;
  btnCalHasta.Height := 24;
  btnCalHasta.Caption := '...';
  btnCalHasta.Hint := 'Elegir fecha hasta en calendario';
  btnCalHasta.ShowHint := True;
  btnCalHasta.OnClick := @CalendarioHastaClick;

  btnHoy := TButton.Create(Self);
  btnHoy.Parent := pnlFiltro;
  btnHoy.Left := 402;
  btnHoy.Top := 7;
  btnHoy.Width := 70;
  btnHoy.Caption := 'Hoy';
  btnHoy.OnClick := @RangoHoy;

  btnAyer := TButton.Create(Self);
  btnAyer.Parent := pnlFiltro;
  btnAyer.Left := 478;
  btnAyer.Top := 7;
  btnAyer.Width := 70;
  btnAyer.Caption := 'Ayer';
  btnAyer.OnClick := @RangoAyer;

  btn7Dias := TButton.Create(Self);
  btn7Dias.Parent := pnlFiltro;
  btn7Dias.Left := 554;
  btn7Dias.Top := 7;
  btn7Dias.Width := 90;
  btn7Dias.Caption := '7 días';
  btn7Dias.OnClick := @Rango7Dias;

  btn30Dias := TButton.Create(Self);
  btn30Dias.Parent := pnlFiltro;
  btn30Dias.Left := 650;
  btn30Dias.Top := 7;
  btn30Dias.Width := 90;
  btn30Dias.Caption := '30 días';
  btn30Dias.OnClick := @Rango30Dias;

  btnRefrescar := TButton.Create(Self);
  btnRefrescar.Parent := pnlFiltro;
  btnRefrescar.Left := 752;
  btnRefrescar.Top := 7;
  btnRefrescar.Width := 100;
  btnRefrescar.Caption := 'Refrescar';
  btnRefrescar.OnClick := @RefrescarTodo;

  btnExportCSV := TButton.Create(Self);
  btnExportCSV.Parent := pnlFiltro;
  btnExportCSV.Left := 860;
  btnExportCSV.Top := 7;
  btnExportCSV.Width := 120;
  btnExportCSV.Caption := 'Exportar CSV';
  btnExportCSV.Hint := 'Exporta a CSV todos los paneles de la pestaña activa';
  btnExportCSV.ShowHint := True;
  btnExportCSV.OnClick := @ExportarCSVClick;

  btnInformeHTML := TButton.Create(Self);
  btnInformeHTML.Parent := pnlFiltro;
  btnInformeHTML.Left := 986;
  btnInformeHTML.Top := 7;
  btnInformeHTML.Width := 125;
  btnInformeHTML.Caption := 'Informe HTML';
  btnInformeHTML.Hint := 'Genera un informe imprimible de la pestaña activa';
  btnInformeHTML.ShowHint := True;
  btnInformeHTML.OnClick := @InformeHTMLClick;

  btnInformePDF := TButton.Create(Self);
  btnInformePDF.Parent := pnlFiltro;
  btnInformePDF.Left := 1118;
  btnInformePDF.Top := 7;
  btnInformePDF.Width := 115;
  btnInformePDF.Caption := 'PDF directo';
  btnInformePDF.Hint := 'Genera directamente un PDF simple de la pesta�a activa';
  btnInformePDF.ShowHint := True;
  btnInformePDF.OnClick := @InformePDFClick;


  L := TLabel.Create(Self);
  L.Parent := pnlFiltro;
  L.Caption := 'Ir a:';
  L.Left := 10;
  L.Top := 45;

  cbIrAPestana := TComboBox.Create(Self);
  cbIrAPestana.Parent := pnlFiltro;
  cbIrAPestana.Left := 58;
  cbIrAPestana.Top := 40;
  cbIrAPestana.Width := 230;
  cbIrAPestana.Style := csDropDownList;
  cbIrAPestana.Hint := 'Acceso rapido a cualquier pestana del dashboard';
  cbIrAPestana.ShowHint := True;
  cbIrAPestana.OnChange := @SelectorPestanaChange;

  L := TLabel.Create(Self);
  L.Parent := pnlFiltro;
  L.Caption := 'Mover pestana:';
  L.Left := 310;
  L.Top := 45;

  btnPestanaIzq := TButton.Create(Self);
  btnPestanaIzq.Parent := pnlFiltro;
  btnPestanaIzq.Left := 405;
  btnPestanaIzq.Top := 40;
  btnPestanaIzq.Width := 34;
  btnPestanaIzq.Height := 25;
  btnPestanaIzq.Caption := '<';
  btnPestanaIzq.Hint := 'Mueve la pestana activa una posicion a la izquierda y guarda el orden';
  btnPestanaIzq.ShowHint := True;
  btnPestanaIzq.OnClick := @MoverPestanaIzquierdaClick;

  btnPestanaDer := TButton.Create(Self);
  btnPestanaDer.Parent := pnlFiltro;
  btnPestanaDer.Left := 443;
  btnPestanaDer.Top := 40;
  btnPestanaDer.Width := 34;
  btnPestanaDer.Height := 25;
  btnPestanaDer.Caption := '>';
  btnPestanaDer.Hint := 'Mueve la pestana activa una posicion a la derecha y guarda el orden';
  btnPestanaDer.ShowHint := True;
  btnPestanaDer.OnClick := @MoverPestanaDerechaClick;

  btnCerrar := TButton.Create(Self);
  btnCerrar.Parent := pnlFiltro;
  btnCerrar.Align := alRight;
  btnCerrar.Width := 100;
  btnCerrar.Caption := 'Cerrar';
  btnCerrar.Hint := 'Cerrar el dashboard';
  btnCerrar.ShowHint := True;
  btnCerrar.Cancel := True;
  btnCerrar.OnClick := @CerrarClick;
end;

procedure TFDashboardProductividad.CrearTabDashboard;
var
  pnlCards: TPanel;
  pnlBody: TPanel;
  pnlTop: TPanel;
  pnlBottom: TPanel;
  gbPagos, gbArt, gbFam, gbHoras, gbGraficoPagos, gbGraficoHoras: TGroupBox;
  spPagos, spFilas, spHoras: TSplitter;

  procedure CrearTarjeta(var LValor: TLabel; const Titulo: string; ALeft: Integer);
  var
    P: TPanel;
    LTit: TLabel;
  begin
    P := TPanel.Create(Self);
    P.Parent := pnlCards;
    P.Left := ALeft;
    P.Top := 8;
    P.Width := 175;
    P.Height := 74;
    P.BevelOuter := bvLowered;

    LTit := TLabel.Create(Self);
    LTit.Parent := P;
    LTit.Caption := Titulo;
    LTit.Left := 8;
    LTit.Top := 8;
    LTit.Font.Style := [fsBold];

    LValor := TLabel.Create(Self);
    LValor.Parent := P;
    LValor.Caption := '-';
    LValor.Left := 8;
    LValor.Top := 34;
    LValor.Font.Size := 13;
    LValor.Font.Style := [fsBold];
  end;

begin
  pnlCards := TPanel.Create(Self);
  pnlCards.Parent := tsDashboard;
  pnlCards.Align := alTop;
  pnlCards.Height := 92;
  pnlCards.BevelOuter := bvNone;

  CrearTarjeta(lblVentasHoy, 'Ventas hoy', 8);
  CrearTarjeta(lblVentasAyer, 'Ventas ayer', 190);
  CrearTarjeta(lblTicketsHoy, 'Tickets hoy', 372);
  CrearTarjeta(lblTicketMedio, 'Ticket medio', 554);
  CrearTarjeta(lblBaseHoy, 'Base imponible', 736);
  CrearTarjeta(lblIvaHoy, 'IVA estimado', 918);

  pnlBody := TPanel.Create(Self);
  pnlBody.Parent := tsDashboard;
  pnlBody.Align := alClient;
  pnlBody.BevelOuter := bvNone;

  // Fila superior: datos principales.
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := pnlBody;
  pnlTop.Align := alTop;
  pnlTop.Height := 300;
  pnlTop.BevelOuter := bvNone;

  gbPagos := TGroupBox.Create(Self);
  gbPagos.Parent := pnlTop;
  gbPagos.Align := alLeft;
  // Se mantiene ancho para poder ver correctamente forma de pago, documentos e importe.
  gbPagos.Width := 560;
  gbPagos.Caption := 'Formas de pago';

  qPagos := CrearQuery;
  dsPagos := TDataSource.Create(Self);
  dsPagos.DataSet := qPagos;

  gridPagos := TDBGrid.Create(Self);
  gridPagos.Parent := gbPagos;
  gridPagos.Align := alClient;
  gridPagos.DataSource := dsPagos;
  gridPagos.ReadOnly := True;
  gridPagos.Options := gridPagos.Options + [dgDisplayMemoText];

  spPagos := TSplitter.Create(Self);
  spPagos.Parent := pnlTop;
  spPagos.Align := alLeft;
  spPagos.Width := 5;

  gbFam := TGroupBox.Create(Self);
  gbFam.Parent := pnlTop;
  gbFam.Align := alRight;
  gbFam.Width := 390;
  gbFam.Caption := 'Top familias';

  qTopFamilias := CrearQuery;
  dsTopFamilias := TDataSource.Create(Self);
  dsTopFamilias.DataSet := qTopFamilias;

  gridTopFamilias := TDBGrid.Create(Self);
  gridTopFamilias.Parent := gbFam;
  gridTopFamilias.Align := alClient;
  gridTopFamilias.DataSource := dsTopFamilias;
  gridTopFamilias.ReadOnly := True;
  gridTopFamilias.Options := gridTopFamilias.Options + [dgDisplayMemoText];

  gbArt := TGroupBox.Create(Self);
  gbArt.Parent := pnlTop;
  gbArt.Align := alClient;
  gbArt.Caption := 'Top artículos';

  qTopArticulos := CrearQuery;
  dsTopArticulos := TDataSource.Create(Self);
  dsTopArticulos.DataSet := qTopArticulos;

  gridTopArticulos := TDBGrid.Create(Self);
  gridTopArticulos.Parent := gbArt;
  gridTopArticulos.Align := alClient;
  gridTopArticulos.DataSource := dsTopArticulos;
  gridTopArticulos.ReadOnly := True;
  gridTopArticulos.Options := gridTopArticulos.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := pnlBody;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  // Fila inferior: frecuencia horaria y gráficos sencillos sin componentes externos.
  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := pnlBody;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbHoras := TGroupBox.Create(Self);
  gbHoras.Parent := pnlBottom;
  gbHoras.Align := alLeft;
  gbHoras.Width := 430;
  gbHoras.Caption := 'Ventas entre horas';

  qHoras := CrearQuery;
  dsHoras := TDataSource.Create(Self);
  dsHoras.DataSet := qHoras;

  gridHoras := TDBGrid.Create(Self);
  gridHoras.Parent := gbHoras;
  gridHoras.Align := alClient;
  gridHoras.DataSource := dsHoras;
  gridHoras.ReadOnly := True;
  gridHoras.Options := gridHoras.Options + [dgDisplayMemoText];

  spHoras := TSplitter.Create(Self);
  spHoras.Parent := pnlBottom;
  spHoras.Align := alLeft;
  spHoras.Width := 5;

  gbGraficoHoras := TGroupBox.Create(Self);
  gbGraficoHoras.Parent := pnlBottom;
  gbGraficoHoras.Align := alRight;
  gbGraficoHoras.Width := 500;
  gbGraficoHoras.Caption := 'Gráfico frecuencia horaria (importe)';

  pbGraficoHoras := TPaintBox.Create(Self);
  pbGraficoHoras.Parent := gbGraficoHoras;
  pbGraficoHoras.Align := alClient;
  pbGraficoHoras.OnPaint := @GraficoHorasPaint;

  gbGraficoPagos := TGroupBox.Create(Self);
  gbGraficoPagos.Parent := pnlBottom;
  gbGraficoPagos.Align := alClient;
  gbGraficoPagos.Caption := 'Gráfico formas de pago';

  pbGraficoPagos := TPaintBox.Create(Self);
  pbGraficoPagos.Parent := gbGraficoPagos;
  pbGraficoPagos.Align := alClient;
  pbGraficoPagos.OnPaint := @GraficoPagosPaint;
end;


procedure TFDashboardProductividad.CrearTabHoy;
var
  pnlCards, pnlBody, pnlTop, pnlBottom: TPanel;
  gbHoras, gbPagos, gbTicketsGraf, gbImporteGraf, gbPagosGraf: TGroupBox;
  spTop, spBottom1, spBottom2, spFilas: TSplitter;

  procedure CrearTarjeta(var LValor: TLabel; const Titulo: string; ALeft: Integer);
  var
    P: TPanel;
    LTit: TLabel;
  begin
    P := TPanel.Create(Self);
    P.Parent := pnlCards;
    P.Left := ALeft;
    P.Top := 8;
    P.Width := 175;
    P.Height := 74;
    P.BevelOuter := bvLowered;

    LTit := TLabel.Create(Self);
    LTit.Parent := P;
    LTit.Caption := Titulo;
    LTit.Left := 8;
    LTit.Top := 8;
    LTit.Font.Style := [fsBold];

    LValor := TLabel.Create(Self);
    LValor.Parent := P;
    LValor.Caption := '-';
    LValor.Left := 8;
    LValor.Top := 34;
    LValor.Font.Size := 13;
    LValor.Font.Style := [fsBold];
  end;

begin
  pnlCards := TPanel.Create(Self);
  pnlCards.Parent := tsHoy;
  pnlCards.Align := alTop;
  pnlCards.Height := 142;
  pnlCards.BevelOuter := bvNone;

  lblHoyFecha := TLabel.Create(Self);
  lblHoyFecha.Parent := pnlCards;
  lblHoyFecha.Left := 8;
  lblHoyFecha.Top := 90;
  lblHoyFecha.Caption := 'Analisis del dia actual';
  lblHoyFecha.Font.Style := [fsBold];

  CrearTarjeta(lblHoyVentas, 'Ventas hoy', 8);
  CrearTarjeta(lblHoyTickets, 'Tickets hoy', 190);
  CrearTarjeta(lblHoyTicketMedio, 'Ticket medio', 372);
  CrearTarjeta(lblHoyBase, 'Base sin IVA', 554);
  CrearTarjeta(lblHoyIva, 'IVA estimado', 736);
  CrearTarjeta(lblHoyHoraPico, 'Hora pico tickets', 918);

  lblHoyImportePico := TLabel.Create(Self);
  lblHoyImportePico.Parent := pnlCards;
  lblHoyImportePico.Left := 8;
  lblHoyImportePico.Top := 112;
  lblHoyImportePico.Caption := 'Hora pico importe: -';
  lblHoyImportePico.Font.Style := [fsBold];

  pnlBody := TPanel.Create(Self);
  pnlBody.Parent := tsHoy;
  pnlBody.Align := alClient;
  pnlBody.BevelOuter := bvNone;

  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := pnlBody;
  pnlTop.Align := alTop;
  pnlTop.Height := 270;
  pnlTop.BevelOuter := bvNone;

  gbHoras := TGroupBox.Create(Self);
  gbHoras.Parent := pnlTop;
  gbHoras.Align := alLeft;
  gbHoras.Width := 620;
  gbHoras.Caption := 'Numero de tickets e importe por horas';

  qHoyResumen := CrearQuery;
  qHoyHoras := CrearQuery;
  dsHoyHoras := TDataSource.Create(Self);
  dsHoyHoras.DataSet := qHoyHoras;

  gridHoyHoras := TDBGrid.Create(Self);
  gridHoyHoras.Parent := gbHoras;
  gridHoyHoras.Align := alClient;
  gridHoyHoras.DataSource := dsHoyHoras;
  gridHoyHoras.ReadOnly := True;
  gridHoyHoras.Options := gridHoyHoras.Options + [dgDisplayMemoText];

  spTop := TSplitter.Create(Self);
  spTop.Parent := pnlTop;
  spTop.Align := alLeft;
  spTop.Width := 5;

  gbPagos := TGroupBox.Create(Self);
  gbPagos.Parent := pnlTop;
  gbPagos.Align := alClient;
  gbPagos.Caption := 'Formas de pago hoy';

  qHoyPagos := CrearQuery;
  dsHoyPagos := TDataSource.Create(Self);
  dsHoyPagos.DataSet := qHoyPagos;

  gridHoyPagos := TDBGrid.Create(Self);
  gridHoyPagos.Parent := gbPagos;
  gridHoyPagos.Align := alClient;
  gridHoyPagos.DataSource := dsHoyPagos;
  gridHoyPagos.ReadOnly := True;
  gridHoyPagos.Options := gridHoyPagos.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := pnlBody;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := pnlBody;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbTicketsGraf := TGroupBox.Create(Self);
  gbTicketsGraf.Parent := pnlBottom;
  gbTicketsGraf.Align := alLeft;
  gbTicketsGraf.Width := 390;
  gbTicketsGraf.Caption := 'Grafico: numero de tickets por hora';

  pbHoyTicketsHora := TPaintBox.Create(Self);
  pbHoyTicketsHora.Parent := gbTicketsGraf;
  pbHoyTicketsHora.Align := alClient;
  pbHoyTicketsHora.OnPaint := @HoyTicketsPaint;

  spBottom1 := TSplitter.Create(Self);
  spBottom1.Parent := pnlBottom;
  spBottom1.Align := alLeft;
  spBottom1.Width := 5;

  gbImporteGraf := TGroupBox.Create(Self);
  gbImporteGraf.Parent := pnlBottom;
  gbImporteGraf.Align := alLeft;
  gbImporteGraf.Width := 430;
  gbImporteGraf.Caption := 'Grafico: importe de tickets por hora';

  pbHoyImportesHora := TPaintBox.Create(Self);
  pbHoyImportesHora.Parent := gbImporteGraf;
  pbHoyImportesHora.Align := alClient;
  pbHoyImportesHora.OnPaint := @HoyImportesPaint;

  spBottom2 := TSplitter.Create(Self);
  spBottom2.Parent := pnlBottom;
  spBottom2.Align := alLeft;
  spBottom2.Width := 5;

  gbPagosGraf := TGroupBox.Create(Self);
  gbPagosGraf.Parent := pnlBottom;
  gbPagosGraf.Align := alClient;
  gbPagosGraf.Caption := 'Grafico: formas de pago hoy';

  pbHoyPagos := TPaintBox.Create(Self);
  pbHoyPagos.Parent := gbPagosGraf;
  pbHoyPagos.Align := alClient;
  pbHoyPagos.OnPaint := @HoyPagosPaint;
end;



procedure TFDashboardProductividad.CrearTabCuadroGestion;
var
  pnlParams, pnlCards, pnlBody, pnlTop, pnlBottom: TPanel;
  gbNegocio, gbHoras, gbMargen, gbEmpleados, gbResumen: TGroupBox;
  spTop, spBottom, spFilas, spResumen: TSplitter;
  L: TLabel;

  procedure Etiqueta(const ACaption: string; AX, AY: Integer);
  begin
    L := TLabel.Create(Self);
    L.Parent := pnlParams;
    L.Caption := ACaption;
    L.Left := AX;
    L.Top := AY;
  end;

  procedure CrearTarjeta(var LValor: TLabel; const Titulo: string; ALeft: Integer);
  var
    P: TPanel;
    LTit: TLabel;
  begin
    P := TPanel.Create(Self);
    P.Parent := pnlCards;
    P.Left := ALeft;
    P.Top := 8;
    P.Width := 205;
    P.Height := 74;
    P.BevelOuter := bvLowered;

    LTit := TLabel.Create(Self);
    LTit.Parent := P;
    LTit.Caption := Titulo;
    LTit.Left := 8;
    LTit.Top := 8;
    LTit.Font.Style := [fsBold];

    LValor := TLabel.Create(Self);
    LValor.Parent := P;
    LValor.Caption := '-';
    LValor.Left := 8;
    LValor.Top := 34;
    LValor.Font.Size := 12;
    LValor.Font.Style := [fsBold];
  end;

  procedure CrearBotonCal(var B: TButton; AX, AY: Integer; AOnClick: TNotifyEvent);
  begin
    B := TButton.Create(Self);
    B.Parent := pnlParams;
    B.Left := AX;
    B.Top := AY;
    B.Width := 26;
    B.Height := 24;
    B.Caption := '...';
    B.OnClick := AOnClick;
  end;

begin
  pnlParams := TPanel.Create(Self);
  pnlParams.Parent := tsCuadroGestion;
  pnlParams.Align := alTop;
  pnlParams.Height := 78;
  pnlParams.BevelOuter := bvNone;

  Etiqueta('Periodo actual:', 8, 10);
  dtCGDesdeAct := TEdit.Create(Self);
  dtCGDesdeAct.Parent := pnlParams;
  dtCGDesdeAct.Left := 105;
  dtCGDesdeAct.Top := 6;
  dtCGDesdeAct.Width := 90;
  dtCGHastaAct := TEdit.Create(Self);
  dtCGHastaAct.Parent := pnlParams;
  dtCGHastaAct.Left := 230;
  dtCGHastaAct.Top := 6;
  dtCGHastaAct.Width := 90;
  Etiqueta('a', 208, 10);
  CrearBotonCal(btnCGCalDesdeAct, 196, 6, @CGCalDesdeActClick);
  CrearBotonCal(btnCGCalHastaAct, 322, 6, @CGCalHastaActClick);

  Etiqueta('Comparar con:', 8, 43);
  dtCGDesdeComp := TEdit.Create(Self);
  dtCGDesdeComp.Parent := pnlParams;
  dtCGDesdeComp.Left := 105;
  dtCGDesdeComp.Top := 39;
  dtCGDesdeComp.Width := 90;
  dtCGHastaComp := TEdit.Create(Self);
  dtCGHastaComp.Parent := pnlParams;
  dtCGHastaComp.Left := 230;
  dtCGHastaComp.Top := 39;
  dtCGHastaComp.Width := 90;
  Etiqueta('a', 208, 43);
  CrearBotonCal(btnCGCalDesdeComp, 196, 39, @CGCalDesdeCompClick);
  CrearBotonCal(btnCGCalHastaComp, 322, 39, @CGCalHastaCompClick);

  btnCGDia := TButton.Create(Self);
  btnCGDia.Parent := pnlParams;
  btnCGDia.Left := 365;
  btnCGDia.Top := 6;
  btnCGDia.Width := 70;
  btnCGDia.Height := 25;
  btnCGDia.Caption := 'Dia';
  btnCGDia.OnClick := @CGSetPeriodoDia;

  btnCGMes := TButton.Create(Self);
  btnCGMes.Parent := pnlParams;
  btnCGMes.Left := 440;
  btnCGMes.Top := 6;
  btnCGMes.Width := 70;
  btnCGMes.Height := 25;
  btnCGMes.Caption := 'Mes';
  btnCGMes.OnClick := @CGSetPeriodoMes;

  btnCGAno := TButton.Create(Self);
  btnCGAno.Parent := pnlParams;
  btnCGAno.Left := 515;
  btnCGAno.Top := 6;
  btnCGAno.Width := 70;
  btnCGAno.Height := 25;
  btnCGAno.Caption := 'Ano';
  btnCGAno.OnClick := @CGSetPeriodoAno;

  btnCGPeriodo := TButton.Create(Self);
  btnCGPeriodo.Parent := pnlParams;
  btnCGPeriodo.Left := 590;
  btnCGPeriodo.Top := 6;
  btnCGPeriodo.Width := 80;
  btnCGPeriodo.Height := 25;
  btnCGPeriodo.Caption := 'Periodo';
  btnCGPeriodo.OnClick := @CGPeriodoManual;

  btnCGRefrescar := TButton.Create(Self);
  btnCGRefrescar.Parent := pnlParams;
  btnCGRefrescar.Left := 365;
  btnCGRefrescar.Top := 39;
  btnCGRefrescar.Width := 120;
  btnCGRefrescar.Height := 25;
  btnCGRefrescar.Caption := 'Actualizar cuadro';
  btnCGRefrescar.OnClick := @CGRefrescarClick;

  L := TLabel.Create(Self);
  L.Parent := pnlParams;
  L.Left := 500;
  L.Top := 44;
  L.Caption := 'Independiente del filtro general. Por defecto: hoy vs mismo dia del ano anterior.';

  SetEditFecha(dtCGDesdeAct, SysUtils.Date);
  SetEditFecha(dtCGHastaAct, SysUtils.Date);
  SetEditFecha(dtCGDesdeComp, IncYear(SysUtils.Date, -1));
  SetEditFecha(dtCGHastaComp, IncYear(SysUtils.Date, -1));

  pnlCards := TPanel.Create(Self);
  pnlCards.Parent := tsCuadroGestion;
  pnlCards.Align := alTop;
  pnlCards.Height := 92;
  pnlCards.BevelOuter := bvNone;

  CrearTarjeta(lblCGFacturacion, 'Facturacion', 8);
  CrearTarjeta(lblCGMargen, 'Margen indicativo', 220);
  CrearTarjeta(lblCGClientes, 'Clientes', 432);
  CrearTarjeta(lblCGArticulos, 'Articulos / uds', 644);
  CrearTarjeta(lblCGCesta, 'Cesta media euros', 856);

  pnlBody := TPanel.Create(Self);
  pnlBody.Parent := tsCuadroGestion;
  pnlBody.Align := alClient;
  pnlBody.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlBody;
  gbResumen.Align := alTop;
  // v36 fix3: resumen + lectura analitica al lado, como cuadro de ayuda.
  gbResumen.Height := 145;
  gbResumen.Caption := 'Resumen comparativo / lectura inteligente';

  qCGResumen := CrearQuery;
  dsCGResumen := TDataSource.Create(Self);
  dsCGResumen.DataSet := qCGResumen;
  gridCGResumen := TDBGrid.Create(Self);
  gridCGResumen.Parent := gbResumen;
  gridCGResumen.Align := alLeft;
  gridCGResumen.Width := 900;
  gridCGResumen.DataSource := dsCGResumen;
  gridCGResumen.ReadOnly := True;
  gridCGResumen.Options := gridCGResumen.Options + [dgDisplayMemoText];

  spResumen := TSplitter.Create(Self);
  spResumen.Parent := gbResumen;
  spResumen.Align := alLeft;
  spResumen.Width := 5;

  memoCGAnalisis := TMemo.Create(Self);
  memoCGAnalisis.Parent := gbResumen;
  memoCGAnalisis.Align := alClient;
  memoCGAnalisis.ReadOnly := True;
  memoCGAnalisis.ScrollBars := ssVertical;
  memoCGAnalisis.WordWrap := True;
  memoCGAnalisis.Lines.Text := 'Actualiza el cuadro para ver la lectura analitica.';

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := pnlBody;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := pnlBody;
  pnlTop.Align := alTop;
  pnlTop.Height := 245;
  pnlTop.BevelOuter := bvNone;

  gbNegocio := TGroupBox.Create(Self);
  gbNegocio.Parent := pnlTop;
  gbNegocio.Align := alLeft;
  gbNegocio.Width := 620;
  gbNegocio.Caption := 'Cifra de negocio por negocio / familia';

  qCGNegocio := CrearQuery;
  dsCGNegocio := TDataSource.Create(Self);
  dsCGNegocio.DataSet := qCGNegocio;
  gridCGNegocio := TDBGrid.Create(Self);
  gridCGNegocio.Parent := gbNegocio;
  gridCGNegocio.Align := alBottom;
  gridCGNegocio.Height := 82;
  gridCGNegocio.DataSource := dsCGNegocio;
  gridCGNegocio.ReadOnly := True;
  gridCGNegocio.Options := gridCGNegocio.Options + [dgDisplayMemoText];
  pbCGNegocio := TPaintBox.Create(Self);
  pbCGNegocio.Parent := gbNegocio;
  pbCGNegocio.Align := alClient;
  pbCGNegocio.OnPaint := @PintarCGNegocio;

  spTop := TSplitter.Create(Self);
  spTop.Parent := pnlTop;
  spTop.Align := alLeft;
  spTop.Width := 5;

  gbHoras := TGroupBox.Create(Self);
  gbHoras.Parent := pnlTop;
  gbHoras.Align := alClient;
  gbHoras.Caption := 'Frecuencia clientes / tickets por hora';

  qCGHoras := CrearQuery;
  dsCGHoras := TDataSource.Create(Self);
  dsCGHoras.DataSet := qCGHoras;
  gridCGHoras := TDBGrid.Create(Self);
  gridCGHoras.Parent := gbHoras;
  gridCGHoras.Align := alBottom;
  gridCGHoras.Height := 82;
  gridCGHoras.DataSource := dsCGHoras;
  gridCGHoras.ReadOnly := True;
  gridCGHoras.Options := gridCGHoras.Options + [dgDisplayMemoText];
  pbCGHoras := TPaintBox.Create(Self);
  pbCGHoras.Parent := gbHoras;
  pbCGHoras.Align := alClient;
  pbCGHoras.OnPaint := @PintarCGHoras;

  spBottom := TSplitter.Create(Self);
  spBottom.Parent := pnlBody;
  spBottom.Align := alTop;
  spBottom.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := pnlBody;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbMargen := TGroupBox.Create(Self);
  gbMargen.Parent := pnlBottom;
  gbMargen.Align := alLeft;
  gbMargen.Width := 620;
  gbMargen.Caption := 'Margen indicativo por negocio / familia';

  qCGMargen := CrearQuery;
  dsCGMargen := TDataSource.Create(Self);
  dsCGMargen.DataSet := qCGMargen;
  gridCGMargen := TDBGrid.Create(Self);
  gridCGMargen.Parent := gbMargen;
  gridCGMargen.Align := alBottom;
  gridCGMargen.Height := 82;
  gridCGMargen.DataSource := dsCGMargen;
  gridCGMargen.ReadOnly := True;
  gridCGMargen.Options := gridCGMargen.Options + [dgDisplayMemoText];
  pbCGMargen := TPaintBox.Create(Self);
  pbCGMargen.Parent := gbMargen;
  pbCGMargen.Align := alClient;
  pbCGMargen.OnPaint := @PintarCGMargen;

  spBottom := TSplitter.Create(Self);
  spBottom.Parent := pnlBottom;
  spBottom.Align := alLeft;
  spBottom.Width := 5;

  gbEmpleados := TGroupBox.Create(Self);
  gbEmpleados.Parent := pnlBottom;
  gbEmpleados.Align := alClient;
  gbEmpleados.Caption := 'Empleados / usuario y cifra de negocio';

  qCGEmpleados := CrearQuery;
  dsCGEmpleados := TDataSource.Create(Self);
  dsCGEmpleados.DataSet := qCGEmpleados;
  gridCGEmpleados := TDBGrid.Create(Self);
  gridCGEmpleados.Parent := gbEmpleados;
  gridCGEmpleados.Align := alBottom;
  gridCGEmpleados.Height := 82;
  gridCGEmpleados.DataSource := dsCGEmpleados;
  gridCGEmpleados.ReadOnly := True;
  gridCGEmpleados.Options := gridCGEmpleados.Options + [dgDisplayMemoText];
  pbCGEmpleados := TPaintBox.Create(Self);
  pbCGEmpleados.Parent := gbEmpleados;
  pbCGEmpleados.Align := alClient;
  pbCGEmpleados.OnPaint := @PintarCGEmpleados;
end;

procedure TFDashboardProductividad.CrearTabVentasAbiertas;
var
  pnlTop, pnlMiddle, pnlBottom: TPanel;
  gbResumen, gbTickets, gbDetalle, gbHoras, gbRevision: TGroupBox;
  spTop, spBottom, spRows1, spRows2: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsVentasAbiertas;
  pnlTop.Align := alTop;
  pnlTop.Height := 190;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 430;
  gbResumen.Caption := 'Resumen por caja';

  qVNAResumen := CrearQuery;
  dsVNAResumen := TDataSource.Create(Self);
  dsVNAResumen.DataSet := qVNAResumen;
  gridVNAResumen := TDBGrid.Create(Self);
  gridVNAResumen.Parent := gbResumen;
  gridVNAResumen.Align := alClient;
  gridVNAResumen.DataSource := dsVNAResumen;
  gridVNAResumen.ReadOnly := True;
  gridVNAResumen.Options := gridVNAResumen.Options + [dgDisplayMemoText];

  spTop := TSplitter.Create(Self);
  spTop.Parent := pnlTop;
  spTop.Align := alLeft;
  spTop.Width := 5;

  gbTickets := TGroupBox.Create(Self);
  gbTickets.Parent := pnlTop;
  gbTickets.Align := alClient;
  gbTickets.Caption := 'Ventas / tickets abiertos';

  qVNATickets := CrearQuery;
  dsVNATickets := TDataSource.Create(Self);
  dsVNATickets.DataSet := qVNATickets;
  gridVNATickets := TDBGrid.Create(Self);
  gridVNATickets.Parent := gbTickets;
  gridVNATickets.Align := alClient;
  gridVNATickets.DataSource := dsVNATickets;
  gridVNATickets.ReadOnly := True;
  gridVNATickets.Options := gridVNATickets.Options + [dgDisplayMemoText];

  spRows1 := TSplitter.Create(Self);
  spRows1.Parent := tsVentasAbiertas;
  spRows1.Align := alTop;
  spRows1.Height := 5;

  pnlMiddle := TPanel.Create(Self);
  pnlMiddle.Parent := tsVentasAbiertas;
  pnlMiddle.Align := alTop;
  pnlMiddle.Height := 290;
  pnlMiddle.BevelOuter := bvNone;

  gbDetalle := TGroupBox.Create(Self);
  gbDetalle.Parent := pnlMiddle;
  gbDetalle.Align := alClient;
  gbDetalle.Caption := 'Detalle de lineas abiertas para comprobar en video-vigilancia';

  qVNADetalle := CrearQuery;
  dsVNADetalle := TDataSource.Create(Self);
  dsVNADetalle.DataSet := qVNADetalle;
  gridVNADetalle := TDBGrid.Create(Self);
  gridVNADetalle.Parent := gbDetalle;
  gridVNADetalle.Align := alClient;
  gridVNADetalle.DataSource := dsVNADetalle;
  gridVNADetalle.ReadOnly := True;
  gridVNADetalle.Options := gridVNADetalle.Options + [dgDisplayMemoText];

  spRows2 := TSplitter.Create(Self);
  spRows2.Parent := tsVentasAbiertas;
  spRows2.Align := alTop;
  spRows2.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsVentasAbiertas;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbHoras := TGroupBox.Create(Self);
  gbHoras.Parent := pnlBottom;
  gbHoras.Align := alLeft;
  gbHoras.Width := 500;
  gbHoras.Caption := 'Lineas por hora y caja';

  qVNAHoras := CrearQuery;
  dsVNAHoras := TDataSource.Create(Self);
  dsVNAHoras.DataSet := qVNAHoras;
  gridVNAHoras := TDBGrid.Create(Self);
  gridVNAHoras.Parent := gbHoras;
  gridVNAHoras.Align := alClient;
  gridVNAHoras.DataSource := dsVNAHoras;
  gridVNAHoras.ReadOnly := True;
  gridVNAHoras.Options := gridVNAHoras.Options + [dgDisplayMemoText];

  spBottom := TSplitter.Create(Self);
  spBottom.Parent := pnlBottom;
  spBottom.Align := alLeft;
  spBottom.Width := 5;

  gbRevision := TGroupBox.Create(Self);
  gbRevision.Parent := pnlBottom;
  gbRevision.Align := alClient;
  gbRevision.Caption := 'Revision rapida';

  qVNARevision := CrearQuery;
  dsVNARevision := TDataSource.Create(Self);
  dsVNARevision.DataSet := qVNARevision;
  gridVNARevision := TDBGrid.Create(Self);
  gridVNARevision.Parent := gbRevision;
  gridVNARevision.Align := alClient;
  gridVNARevision.DataSource := dsVNARevision;
  gridVNARevision.ReadOnly := True;
  gridVNARevision.Options := gridVNARevision.Options + [dgDisplayMemoText];
end;

procedure TFDashboardProductividad.CrearTabCierreTarde;
var
  pnlIdea, pnlTop, pnlMiddle, pnlBottom: TPanel;
  gbIdea, gbResumen, gbCandidatos, gbDias, gbSemana, gbHoras: TGroupBox;
  spTop, spRowsIdea, spRows1, spRows2, spBottom: TSplitter;
begin
  pnlIdea := TPanel.Create(Self);
  pnlIdea.Parent := tsCierreTarde;
  pnlIdea.Align := alTop;
  pnlIdea.Height := 112;
  pnlIdea.BevelOuter := bvNone;

  gbIdea := TGroupBox.Create(Self);
  gbIdea.Parent := pnlIdea;
  gbIdea.Align := alClient;
  gbIdea.Caption := 'Sugerencia inteligente para cierres de tarde en Agosto';

  memoCTSugerencia := TMemo.Create(Self);
  memoCTSugerencia.Parent := gbIdea;
  memoCTSugerencia.Align := alClient;
  memoCTSugerencia.ReadOnly := True;
  memoCTSugerencia.ScrollBars := ssVertical;
  memoCTSugerencia.WordWrap := True;
  memoCTSugerencia.Lines.Text := 'La sugerencia inteligente se calcula sobre Agosto, comparando con Agosto del ano anterior.';

  spRowsIdea := TSplitter.Create(Self);
  spRowsIdea.Parent := tsCierreTarde;
  spRowsIdea.Align := alTop;
  spRowsIdea.Height := 5;

  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsCierreTarde;
  pnlTop.Align := alTop;
  pnlTop.Height := 190;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 520;
  gbResumen.Caption := 'Resumen del periodo - tarde desde las 15:00';

  qCTResumen := CrearQuery;
  dsCTResumen := TDataSource.Create(Self);
  dsCTResumen.DataSet := qCTResumen;
  gridCTResumen := TDBGrid.Create(Self);
  gridCTResumen.Parent := gbResumen;
  gridCTResumen.Align := alClient;
  gridCTResumen.DataSource := dsCTResumen;
  gridCTResumen.ReadOnly := True;
  gridCTResumen.Options := gridCTResumen.Options + [dgDisplayMemoText];

  spTop := TSplitter.Create(Self);
  spTop.Parent := pnlTop;
  spTop.Align := alLeft;
  spTop.Width := 5;

  gbCandidatos := TGroupBox.Create(Self);
  gbCandidatos.Parent := pnlTop;
  gbCandidatos.Align := alClient;
  gbCandidatos.Caption := 'Top 15 candidatos a cerrar por la tarde';

  qCTCandidatos := CrearQuery;
  dsCTCandidatos := TDataSource.Create(Self);
  dsCTCandidatos.DataSet := qCTCandidatos;
  gridCTCandidatos := TDBGrid.Create(Self);
  gridCTCandidatos.Parent := gbCandidatos;
  gridCTCandidatos.Align := alClient;
  gridCTCandidatos.DataSource := dsCTCandidatos;
  gridCTCandidatos.ReadOnly := True;
  gridCTCandidatos.Options := gridCTCandidatos.Options + [dgDisplayMemoText];

  spRows1 := TSplitter.Create(Self);
  spRows1.Parent := tsCierreTarde;
  spRows1.Align := alTop;
  spRows1.Height := 5;

  pnlMiddle := TPanel.Create(Self);
  pnlMiddle.Parent := tsCierreTarde;
  pnlMiddle.Align := alTop;
  pnlMiddle.Height := 300;
  pnlMiddle.BevelOuter := bvNone;

  gbDias := TGroupBox.Create(Self);
  gbDias.Parent := pnlMiddle;
  gbDias.Align := alClient;
  gbDias.Caption := 'Dia a dia del periodo seleccionado';

  qCTDias := CrearQuery;
  dsCTDias := TDataSource.Create(Self);
  dsCTDias.DataSet := qCTDias;
  gridCTDias := TDBGrid.Create(Self);
  gridCTDias.Parent := gbDias;
  gridCTDias.Align := alClient;
  gridCTDias.DataSource := dsCTDias;
  gridCTDias.ReadOnly := True;
  gridCTDias.Options := gridCTDias.Options + [dgDisplayMemoText];

  spRows2 := TSplitter.Create(Self);
  spRows2.Parent := tsCierreTarde;
  spRows2.Align := alTop;
  spRows2.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsCierreTarde;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbSemana := TGroupBox.Create(Self);
  gbSemana.Parent := pnlBottom;
  gbSemana.Align := alLeft;
  gbSemana.Width := 560;
  gbSemana.Caption := 'Resumen por dia de la semana';

  qCTSemana := CrearQuery;
  dsCTSemana := TDataSource.Create(Self);
  dsCTSemana.DataSet := qCTSemana;
  gridCTSemana := TDBGrid.Create(Self);
  gridCTSemana.Parent := gbSemana;
  gridCTSemana.Align := alClient;
  gridCTSemana.DataSource := dsCTSemana;
  gridCTSemana.ReadOnly := True;
  gridCTSemana.Options := gridCTSemana.Options + [dgDisplayMemoText];

  spBottom := TSplitter.Create(Self);
  spBottom.Parent := pnlBottom;
  spBottom.Align := alLeft;
  spBottom.Width := 5;

  gbHoras := TGroupBox.Create(Self);
  gbHoras.Parent := pnlBottom;
  gbHoras.Align := alClient;
  gbHoras.Caption := 'Actividad por horas de tarde';

  qCTHoras := CrearQuery;
  dsCTHoras := TDataSource.Create(Self);
  dsCTHoras.DataSet := qCTHoras;
  gridCTHoras := TDBGrid.Create(Self);
  gridCTHoras.Parent := gbHoras;
  gridCTHoras.Align := alClient;
  gridCTHoras.DataSource := dsCTHoras;
  gridCTHoras.ReadOnly := True;
  gridCTHoras.Options := gridCTHoras.Options + [dgDisplayMemoText];
end;


procedure TFDashboardProductividad.CrearTabDiagnostico;
var
  pnlTop: TPanel;
  pnlMiddle: TPanel;
  pnlBottom: TPanel;
  gbInforme, gbResumen, gbMargen, gbHoras, gbProveedor: TGroupBox;
  spTop, spMiddle, spMid, spBot: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsDiagnostico;
  pnlTop.Align := alTop;
  pnlTop.Height := 175;
  pnlTop.BevelOuter := bvNone;

  gbInforme := TGroupBox.Create(Self);
  gbInforme.Parent := pnlTop;
  gbInforme.Align := alClient;
  gbInforme.Caption := 'Diagnostico inteligente del periodo';

  memoDiagnostico := TMemo.Create(Self);
  memoDiagnostico.Parent := gbInforme;
  memoDiagnostico.Align := alClient;
  memoDiagnostico.ReadOnly := True;
  memoDiagnostico.ScrollBars := ssVertical;
  memoDiagnostico.WordWrap := True;
  memoDiagnostico.Lines.Text := 'Pendiente de cargar diagnostico...';

  spTop := TSplitter.Create(Self);
  spTop.Parent := tsDiagnostico;
  spTop.Align := alTop;
  spTop.Height := 5;

  pnlMiddle := TPanel.Create(Self);
  pnlMiddle.Parent := tsDiagnostico;
  pnlMiddle.Align := alTop;
  pnlMiddle.Height := 260;
  pnlMiddle.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlMiddle;
  gbResumen.Align := alLeft;
  gbResumen.Width := 520;
  gbResumen.Caption := 'Resumen de alertas y acciones';

  qDiagResumen := CrearQuery;
  dsDiagResumen := TDataSource.Create(Self);
  dsDiagResumen.DataSet := qDiagResumen;

  gridDiagResumen := TDBGrid.Create(Self);
  gridDiagResumen.Parent := gbResumen;
  gridDiagResumen.Align := alClient;
  gridDiagResumen.DataSource := dsDiagResumen;
  gridDiagResumen.ReadOnly := True;
  gridDiagResumen.Options := gridDiagResumen.Options + [dgDisplayMemoText];

  spMiddle := TSplitter.Create(Self);
  spMiddle.Parent := pnlMiddle;
  spMiddle.Align := alLeft;
  spMiddle.Width := 5;

  gbMargen := TGroupBox.Create(Self);
  gbMargen.Parent := pnlMiddle;
  gbMargen.Align := alClient;
  gbMargen.Caption := 'Lineas con margen negativo o bajo';

  qDiagMargen := CrearQuery;
  dsDiagMargen := TDataSource.Create(Self);
  dsDiagMargen.DataSet := qDiagMargen;

  gridDiagMargen := TDBGrid.Create(Self);
  gridDiagMargen.Parent := gbMargen;
  gridDiagMargen.Align := alClient;
  gridDiagMargen.DataSource := dsDiagMargen;
  gridDiagMargen.ReadOnly := True;
  gridDiagMargen.Options := gridDiagMargen.Options + [dgDisplayMemoText];

  spMid := TSplitter.Create(Self);
  spMid.Parent := tsDiagnostico;
  spMid.Align := alTop;
  spMid.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsDiagnostico;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbHoras := TGroupBox.Create(Self);
  gbHoras.Parent := pnlBottom;
  gbHoras.Align := alLeft;
  gbHoras.Width := 540;
  gbHoras.Caption := 'Lectura profesional de horas';

  qDiagHoras := CrearQuery;
  dsDiagHoras := TDataSource.Create(Self);
  dsDiagHoras.DataSet := qDiagHoras;

  gridDiagHoras := TDBGrid.Create(Self);
  gridDiagHoras.Parent := gbHoras;
  gridDiagHoras.Align := alClient;
  gridDiagHoras.DataSource := dsDiagHoras;
  gridDiagHoras.ReadOnly := True;
  gridDiagHoras.Options := gridDiagHoras.Options + [dgDisplayMemoText];

  spBot := TSplitter.Create(Self);
  spBot.Parent := pnlBottom;
  spBot.Align := alLeft;
  spBot.Width := 5;

  gbProveedor := TGroupBox.Create(Self);
  gbProveedor.Parent := pnlBottom;
  gbProveedor.Align := alClient;
  gbProveedor.Caption := 'Ventas y margen por proveedor del articulo';

  qDiagProveedor := CrearQuery;
  dsDiagProveedor := TDataSource.Create(Self);
  dsDiagProveedor.DataSet := qDiagProveedor;

  gridDiagProveedor := TDBGrid.Create(Self);
  gridDiagProveedor.Parent := gbProveedor;
  gridDiagProveedor.Align := alClient;
  gridDiagProveedor.DataSource := dsDiagProveedor;
  gridDiagProveedor.ReadOnly := True;
  gridDiagProveedor.Options := gridDiagProveedor.Options + [dgDisplayMemoText];
end;


procedure TFDashboardProductividad.CrearTabAlertas;
var
  pnlBotones: TPanel;

  procedure CrearBoton(const Texto: string; ALeft: Integer; AOnClick: TNotifyEvent);
  var
    B: TButton;
  begin
    B := TButton.Create(Self);
    B.Parent := pnlBotones;
    B.Left := ALeft;
    B.Top := 7;
    B.Width := 145;
    B.Height := 28;
    B.Caption := Texto;
    B.OnClick := AOnClick;
  end;

begin
  pnlBotones := TPanel.Create(Self);
  pnlBotones.Parent := tsAlertas;
  pnlBotones.Align := alTop;
  pnlBotones.Height := 44;
  pnlBotones.BevelOuter := bvNone;

  CrearBoton('Stock bajo', 8, @AlertaStockBajo);
  CrearBoton('Coste 0', 160, @AlertaCosteCero);
  CrearBoton('PVP 999', 312, @AlertaPVP999);
  CrearBoton('Familia 0', 464, @AlertaFamiliaCero);
  CrearBoton('Sin proveedor', 616, @AlertaSinProveedor);
  CrearBoton('Stock 0 vendido', 768, @AlertaStockCeroVendido30);

  lblAlertaTitulo := TLabel.Create(Self);
  lblAlertaTitulo.Parent := tsAlertas;
  lblAlertaTitulo.Align := alTop;
  lblAlertaTitulo.Height := 26;
  lblAlertaTitulo.Layout := tlCenter;
  lblAlertaTitulo.Font.Style := [fsBold];
  lblAlertaTitulo.Caption := 'Alertas';

  qAlertas := CrearQuery;
  dsAlertas := TDataSource.Create(Self);
  dsAlertas.DataSet := qAlertas;

  gridAlertas := TDBGrid.Create(Self);
  gridAlertas.Parent := tsAlertas;
  gridAlertas.Align := alClient;
  gridAlertas.DataSource := dsAlertas;
  gridAlertas.ReadOnly := True;
  gridAlertas.Options := gridAlertas.Options + [dgDisplayMemoText];
end;


procedure TFDashboardProductividad.CrearTabEstudios;
var
  pnlTop: TPanel;
  pnlBottom: TPanel;
  gbDia, gbHora, gbFam, gbProv, gbMargen, gbProblemas: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsEstudios;
  pnlTop.Align := alTop;
  pnlTop.Height := 300;
  pnlTop.BevelOuter := bvNone;

  gbDia := TGroupBox.Create(Self);
  gbDia.Parent := pnlTop;
  gbDia.Align := alLeft;
  gbDia.Width := 360;
  gbDia.Caption := 'Ventas por día';

  qEstVentasDia := CrearQuery;
  dsEstVentasDia := TDataSource.Create(Self);
  dsEstVentasDia.DataSet := qEstVentasDia;

  gridEstVentasDia := TDBGrid.Create(Self);
  gridEstVentasDia.Parent := gbDia;
  gridEstVentasDia.Align := alClient;
  gridEstVentasDia.DataSource := dsEstVentasDia;
  gridEstVentasDia.ReadOnly := True;
  gridEstVentasDia.Options := gridEstVentasDia.Options + [dgDisplayMemoText];

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbHora := TGroupBox.Create(Self);
  gbHora.Parent := pnlTop;
  gbHora.Align := alRight;
  gbHora.Width := 390;
  gbHora.Caption := 'Ventas por hora';

  qEstVentasHora := CrearQuery;
  dsEstVentasHora := TDataSource.Create(Self);
  dsEstVentasHora.DataSet := qEstVentasHora;

  gridEstVentasHora := TDBGrid.Create(Self);
  gridEstVentasHora.Parent := gbHora;
  gridEstVentasHora.Align := alClient;
  gridEstVentasHora.DataSource := dsEstVentasHora;
  gridEstVentasHora.ReadOnly := True;
  gridEstVentasHora.Options := gridEstVentasHora.Options + [dgDisplayMemoText];

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbFam := TGroupBox.Create(Self);
  gbFam.Parent := pnlTop;
  gbFam.Align := alClient;
  gbFam.Caption := 'Ventas por familia';

  qEstFamilias := CrearQuery;
  dsEstFamilias := TDataSource.Create(Self);
  dsEstFamilias.DataSet := qEstFamilias;

  gridEstFamilias := TDBGrid.Create(Self);
  gridEstFamilias.Parent := gbFam;
  gridEstFamilias.Align := alClient;
  gridEstFamilias.DataSource := dsEstFamilias;
  gridEstFamilias.ReadOnly := True;
  gridEstFamilias.Options := gridEstFamilias.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsEstudios;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsEstudios;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbProv := TGroupBox.Create(Self);
  gbProv.Parent := pnlBottom;
  gbProv.Align := alLeft;
  gbProv.Width := 420;
  gbProv.Caption := 'Ventas por proveedor estimado';

  qEstProveedores := CrearQuery;
  dsEstProveedores := TDataSource.Create(Self);
  dsEstProveedores.DataSet := qEstProveedores;

  gridEstProveedores := TDBGrid.Create(Self);
  gridEstProveedores.Parent := gbProv;
  gridEstProveedores.Align := alClient;
  gridEstProveedores.DataSource := dsEstProveedores;
  gridEstProveedores.ReadOnly := True;
  gridEstProveedores.Options := gridEstProveedores.Options + [dgDisplayMemoText];

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbProblemas := TGroupBox.Create(Self);
  gbProblemas.Parent := pnlBottom;
  gbProblemas.Align := alRight;
  gbProblemas.Width := 450;
  gbProblemas.Caption := 'Coste 0 / margen negativo vendido';

  qEstProblemas := CrearQuery;
  dsEstProblemas := TDataSource.Create(Self);
  dsEstProblemas.DataSet := qEstProblemas;

  gridEstProblemas := TDBGrid.Create(Self);
  gridEstProblemas.Parent := gbProblemas;
  gridEstProblemas.Align := alClient;
  gridEstProblemas.DataSource := dsEstProblemas;
  gridEstProblemas.ReadOnly := True;
  gridEstProblemas.Options := gridEstProblemas.Options + [dgDisplayMemoText];

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbMargen := TGroupBox.Create(Self);
  gbMargen.Parent := pnlBottom;
  gbMargen.Align := alClient;
  gbMargen.Caption := 'Top artículos por margen estimado';

  qEstMargen := CrearQuery;
  dsEstMargen := TDataSource.Create(Self);
  dsEstMargen.DataSet := qEstMargen;

  gridEstMargen := TDBGrid.Create(Self);
  gridEstMargen.Parent := gbMargen;
  gridEstMargen.Align := alClient;
  gridEstMargen.DataSource := dsEstMargen;
  gridEstMargen.ReadOnly := True;
  gridEstMargen.Options := gridEstMargen.Options + [dgDisplayMemoText];
end;



procedure TFDashboardProductividad.CrearTabComparativa;
var
  pnlTop: TPanel;
  pnlBottom: TPanel;
  gbResumen, gbDiaActual, gbDiaAnterior, gbFam, gbArt, gbPagos: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsComparativa;
  pnlTop.Align := alTop;
  pnlTop.Height := 300;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 430;
  gbResumen.Caption := 'Resumen comparativo';

  qCompResumen := CrearQuery;
  dsCompResumen := TDataSource.Create(Self);
  dsCompResumen.DataSet := qCompResumen;

  gridCompResumen := TDBGrid.Create(Self);
  gridCompResumen.Parent := gbResumen;
  gridCompResumen.Align := alClient;
  gridCompResumen.DataSource := dsCompResumen;
  gridCompResumen.ReadOnly := True;
  gridCompResumen.Options := gridCompResumen.Options + [dgDisplayMemoText];

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbDiaAnterior := TGroupBox.Create(Self);
  gbDiaAnterior.Parent := pnlTop;
  gbDiaAnterior.Align := alRight;
  gbDiaAnterior.Width := 390;
  gbDiaAnterior.Caption := 'Días periodo anterior';

  qCompDiaAnterior := CrearQuery;
  dsCompDiaAnterior := TDataSource.Create(Self);
  dsCompDiaAnterior.DataSet := qCompDiaAnterior;

  gridCompDiaAnterior := TDBGrid.Create(Self);
  gridCompDiaAnterior.Parent := gbDiaAnterior;
  gridCompDiaAnterior.Align := alClient;
  gridCompDiaAnterior.DataSource := dsCompDiaAnterior;
  gridCompDiaAnterior.ReadOnly := True;
  gridCompDiaAnterior.Options := gridCompDiaAnterior.Options + [dgDisplayMemoText];

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbDiaActual := TGroupBox.Create(Self);
  gbDiaActual.Parent := pnlTop;
  gbDiaActual.Align := alClient;
  gbDiaActual.Caption := 'Días rango actual';

  qCompDiaActual := CrearQuery;
  dsCompDiaActual := TDataSource.Create(Self);
  dsCompDiaActual.DataSet := qCompDiaActual;

  gridCompDiaActual := TDBGrid.Create(Self);
  gridCompDiaActual.Parent := gbDiaActual;
  gridCompDiaActual.Align := alClient;
  gridCompDiaActual.DataSource := dsCompDiaActual;
  gridCompDiaActual.ReadOnly := True;
  gridCompDiaActual.Options := gridCompDiaActual.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsComparativa;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsComparativa;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbFam := TGroupBox.Create(Self);
  gbFam.Parent := pnlBottom;
  gbFam.Align := alLeft;
  gbFam.Width := 430;
  gbFam.Caption := 'Familias con variación';

  qCompFamilias := CrearQuery;
  dsCompFamilias := TDataSource.Create(Self);
  dsCompFamilias.DataSet := qCompFamilias;

  gridCompFamilias := TDBGrid.Create(Self);
  gridCompFamilias.Parent := gbFam;
  gridCompFamilias.Align := alClient;
  gridCompFamilias.DataSource := dsCompFamilias;
  gridCompFamilias.ReadOnly := True;
  gridCompFamilias.Options := gridCompFamilias.Options + [dgDisplayMemoText];

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbPagos := TGroupBox.Create(Self);
  gbPagos.Parent := pnlBottom;
  gbPagos.Align := alRight;
  gbPagos.Width := 390;
  gbPagos.Caption := 'Formas de pago con variación';

  qCompPagos := CrearQuery;
  dsCompPagos := TDataSource.Create(Self);
  dsCompPagos.DataSet := qCompPagos;

  gridCompPagos := TDBGrid.Create(Self);
  gridCompPagos.Parent := gbPagos;
  gridCompPagos.Align := alClient;
  gridCompPagos.DataSource := dsCompPagos;
  gridCompPagos.ReadOnly := True;
  gridCompPagos.Options := gridCompPagos.Options + [dgDisplayMemoText];

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbArt := TGroupBox.Create(Self);
  gbArt.Parent := pnlBottom;
  gbArt.Align := alClient;
  gbArt.Caption := 'Artículos con variación';

  qCompArticulos := CrearQuery;
  dsCompArticulos := TDataSource.Create(Self);
  dsCompArticulos.DataSet := qCompArticulos;

  gridCompArticulos := TDBGrid.Create(Self);
  gridCompArticulos.Parent := gbArt;
  gridCompArticulos.Align := alClient;
  gridCompArticulos.DataSource := dsCompArticulos;
  gridCompArticulos.ReadOnly := True;
  gridCompArticulos.Options := gridCompArticulos.Options + [dgDisplayMemoText];
end;



procedure TFDashboardProductividad.CrearTabTendencias;
var
  pnlTop: TPanel;
  pnlBottom: TPanel;
  gbResumen, gbMeses, gbAnual, gbSemana, gbAlza, gbBaja: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsTendencias;
  pnlTop.Align := alTop;
  pnlTop.Height := 300;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 430;
  gbResumen.Caption := 'Resumen tendencias';

  qTendResumen := CrearQuery;
  dsTendResumen := TDataSource.Create(Self);
  dsTendResumen.DataSet := qTendResumen;

  gridTendResumen := TDBGrid.Create(Self);
  gridTendResumen.Parent := gbResumen;
  gridTendResumen.Align := alClient;
  gridTendResumen.DataSource := dsTendResumen;
  gridTendResumen.ReadOnly := True;
  gridTendResumen.Options := gridTendResumen.Options + [dgDisplayMemoText];

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbAnual := TGroupBox.Create(Self);
  gbAnual.Parent := pnlTop;
  gbAnual.Align := alRight;
  gbAnual.Width := 470;
  gbAnual.Caption := 'Año actual vs anterior';

  qTendAnual := CrearQuery;
  dsTendAnual := TDataSource.Create(Self);
  dsTendAnual.DataSet := qTendAnual;

  gridTendAnual := TDBGrid.Create(Self);
  gridTendAnual.Parent := gbAnual;
  gridTendAnual.Align := alClient;
  gridTendAnual.DataSource := dsTendAnual;
  gridTendAnual.ReadOnly := True;
  gridTendAnual.Options := gridTendAnual.Options + [dgDisplayMemoText];

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbMeses := TGroupBox.Create(Self);
  gbMeses.Parent := pnlTop;
  gbMeses.Align := alClient;
  gbMeses.Caption := 'Últimos 12 meses';

  qTendMeses := CrearQuery;
  dsTendMeses := TDataSource.Create(Self);
  dsTendMeses.DataSet := qTendMeses;

  gridTendMeses := TDBGrid.Create(Self);
  gridTendMeses.Parent := gbMeses;
  gridTendMeses.Align := alClient;
  gridTendMeses.DataSource := dsTendMeses;
  gridTendMeses.ReadOnly := True;
  gridTendMeses.Options := gridTendMeses.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsTendencias;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsTendencias;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbSemana := TGroupBox.Create(Self);
  gbSemana.Parent := pnlBottom;
  gbSemana.Align := alLeft;
  gbSemana.Width := 430;
  gbSemana.Caption := 'Día de la semana';

  qTendSemana := CrearQuery;
  dsTendSemana := TDataSource.Create(Self);
  dsTendSemana.DataSet := qTendSemana;

  gridTendSemana := TDBGrid.Create(Self);
  gridTendSemana.Parent := gbSemana;
  gridTendSemana.Align := alClient;
  gridTendSemana.DataSource := dsTendSemana;
  gridTendSemana.ReadOnly := True;
  gridTendSemana.Options := gridTendSemana.Options + [dgDisplayMemoText];

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbBaja := TGroupBox.Create(Self);
  gbBaja.Parent := pnlBottom;
  gbBaja.Align := alRight;
  gbBaja.Width := 470;
  gbBaja.Caption := 'Artículos a la baja';

  qTendBaja := CrearQuery;
  dsTendBaja := TDataSource.Create(Self);
  dsTendBaja.DataSet := qTendBaja;

  gridTendBaja := TDBGrid.Create(Self);
  gridTendBaja.Parent := gbBaja;
  gridTendBaja.Align := alClient;
  gridTendBaja.DataSource := dsTendBaja;
  gridTendBaja.ReadOnly := True;
  gridTendBaja.Options := gridTendBaja.Options + [dgDisplayMemoText];

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbAlza := TGroupBox.Create(Self);
  gbAlza.Parent := pnlBottom;
  gbAlza.Align := alClient;
  gbAlza.Caption := 'Artículos al alza';

  qTendAlza := CrearQuery;
  dsTendAlza := TDataSource.Create(Self);
  dsTendAlza.DataSet := qTendAlza;

  gridTendAlza := TDBGrid.Create(Self);
  gridTendAlza.Parent := gbAlza;
  gridTendAlza.Align := alClient;
  gridTendAlza.DataSource := dsTendAlza;
  gridTendAlza.ReadOnly := True;
  gridTendAlza.Options := gridTendAlza.Options + [dgDisplayMemoText];
end;


procedure TFDashboardProductividad.CrearTabClientes;
var
  pnlTop: TPanel;
  pnlBottom: TPanel;
  gbResumen, gbTopImporte, gbTopFrecuencia, gbTicketMedio, gbSinCliente, gbDatos: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsClientes;
  pnlTop.Align := alTop;
  pnlTop.Height := 300;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 430;
  gbResumen.Caption := 'Resumen clientes';

  qCliResumen := CrearQuery;
  dsCliResumen := TDataSource.Create(Self);
  dsCliResumen.DataSet := qCliResumen;

  gridCliResumen := TDBGrid.Create(Self);
  gridCliResumen.Parent := gbResumen;
  gridCliResumen.Align := alClient;
  gridCliResumen.DataSource := dsCliResumen;
  gridCliResumen.ReadOnly := True;
  gridCliResumen.Options := gridCliResumen.Options + [dgDisplayMemoText];

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbTopFrecuencia := TGroupBox.Create(Self);
  gbTopFrecuencia.Parent := pnlTop;
  gbTopFrecuencia.Align := alRight;
  gbTopFrecuencia.Width := 420;
  gbTopFrecuencia.Caption := 'Top clientes por frecuencia';

  qCliTopFrecuencia := CrearQuery;
  dsCliTopFrecuencia := TDataSource.Create(Self);
  dsCliTopFrecuencia.DataSet := qCliTopFrecuencia;

  gridCliTopFrecuencia := TDBGrid.Create(Self);
  gridCliTopFrecuencia.Parent := gbTopFrecuencia;
  gridCliTopFrecuencia.Align := alClient;
  gridCliTopFrecuencia.DataSource := dsCliTopFrecuencia;
  gridCliTopFrecuencia.ReadOnly := True;
  gridCliTopFrecuencia.Options := gridCliTopFrecuencia.Options + [dgDisplayMemoText];

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbTopImporte := TGroupBox.Create(Self);
  gbTopImporte.Parent := pnlTop;
  gbTopImporte.Align := alClient;
  gbTopImporte.Caption := 'Top clientes por importe';

  qCliTopImporte := CrearQuery;
  dsCliTopImporte := TDataSource.Create(Self);
  dsCliTopImporte.DataSet := qCliTopImporte;

  gridCliTopImporte := TDBGrid.Create(Self);
  gridCliTopImporte.Parent := gbTopImporte;
  gridCliTopImporte.Align := alClient;
  gridCliTopImporte.DataSource := dsCliTopImporte;
  gridCliTopImporte.ReadOnly := True;
  gridCliTopImporte.Options := gridCliTopImporte.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsClientes;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsClientes;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbTicketMedio := TGroupBox.Create(Self);
  gbTicketMedio.Parent := pnlBottom;
  gbTicketMedio.Align := alLeft;
  gbTicketMedio.Width := 430;
  gbTicketMedio.Caption := 'Clientes por ticket medio';

  qCliTicketMedio := CrearQuery;
  dsCliTicketMedio := TDataSource.Create(Self);
  dsCliTicketMedio.DataSet := qCliTicketMedio;

  gridCliTicketMedio := TDBGrid.Create(Self);
  gridCliTicketMedio.Parent := gbTicketMedio;
  gridCliTicketMedio.Align := alClient;
  gridCliTicketMedio.DataSource := dsCliTicketMedio;
  gridCliTicketMedio.ReadOnly := True;
  gridCliTicketMedio.Options := gridCliTicketMedio.Options + [dgDisplayMemoText];

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbDatos := TGroupBox.Create(Self);
  gbDatos.Parent := pnlBottom;
  gbDatos.Align := alRight;
  gbDatos.Width := 430;
  gbDatos.Caption := 'Clientes vendidos con datos incompletos';

  qCliDatosIncompletos := CrearQuery;
  dsCliDatosIncompletos := TDataSource.Create(Self);
  dsCliDatosIncompletos.DataSet := qCliDatosIncompletos;

  gridCliDatosIncompletos := TDBGrid.Create(Self);
  gridCliDatosIncompletos.Parent := gbDatos;
  gridCliDatosIncompletos.Align := alClient;
  gridCliDatosIncompletos.DataSource := dsCliDatosIncompletos;
  gridCliDatosIncompletos.ReadOnly := True;
  gridCliDatosIncompletos.Options := gridCliDatosIncompletos.Options + [dgDisplayMemoText];

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbSinCliente := TGroupBox.Create(Self);
  gbSinCliente.Parent := pnlBottom;
  gbSinCliente.Align := alClient;
  gbSinCliente.Caption := 'Ventas sin cliente asignado';

  qCliSinCliente := CrearQuery;
  dsCliSinCliente := TDataSource.Create(Self);
  dsCliSinCliente.DataSet := qCliSinCliente;

  gridCliSinCliente := TDBGrid.Create(Self);
  gridCliSinCliente.Parent := gbSinCliente;
  gridCliSinCliente.Align := alClient;
  gridCliSinCliente.DataSource := dsCliSinCliente;
  gridCliSinCliente.ReadOnly := True;
  gridCliSinCliente.Options := gridCliSinCliente.Options + [dgDisplayMemoText];
end;



procedure TFDashboardProductividad.CrearTabPuestos;
var
  pnlTop: TPanel;
  pnlBottom: TPanel;
  gbResumen, gbUsuarios, gbCajas, gbHorasUsuario, gbPagosCaja, gbRevision: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsPuestos;
  pnlTop.Align := alTop;
  pnlTop.Height := 300;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 430;
  gbResumen.Caption := 'Resumen usuarios / puestos';

  qPueResumen := CrearQuery;
  dsPueResumen := TDataSource.Create(Self);
  dsPueResumen.DataSet := qPueResumen;

  gridPueResumen := TDBGrid.Create(Self);
  gridPueResumen.Parent := gbResumen;
  gridPueResumen.Align := alClient;
  gridPueResumen.DataSource := dsPueResumen;
  gridPueResumen.ReadOnly := True;
  gridPueResumen.Options := gridPueResumen.Options + [dgDisplayMemoText];

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbCajas := TGroupBox.Create(Self);
  gbCajas.Parent := pnlTop;
  gbCajas.Align := alRight;
  gbCajas.Width := 430;
  gbCajas.Caption := 'Ventas por caja / puesto';

  qPueCajas := CrearQuery;
  dsPueCajas := TDataSource.Create(Self);
  dsPueCajas.DataSet := qPueCajas;

  gridPueCajas := TDBGrid.Create(Self);
  gridPueCajas.Parent := gbCajas;
  gridPueCajas.Align := alClient;
  gridPueCajas.DataSource := dsPueCajas;
  gridPueCajas.ReadOnly := True;
  gridPueCajas.Options := gridPueCajas.Options + [dgDisplayMemoText];

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbUsuarios := TGroupBox.Create(Self);
  gbUsuarios.Parent := pnlTop;
  gbUsuarios.Align := alClient;
  gbUsuarios.Caption := 'Ventas por usuario';

  qPueUsuarios := CrearQuery;
  dsPueUsuarios := TDataSource.Create(Self);
  dsPueUsuarios.DataSet := qPueUsuarios;

  gridPueUsuarios := TDBGrid.Create(Self);
  gridPueUsuarios.Parent := gbUsuarios;
  gridPueUsuarios.Align := alClient;
  gridPueUsuarios.DataSource := dsPueUsuarios;
  gridPueUsuarios.ReadOnly := True;
  gridPueUsuarios.Options := gridPueUsuarios.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsPuestos;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsPuestos;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbHorasUsuario := TGroupBox.Create(Self);
  gbHorasUsuario.Parent := pnlBottom;
  gbHorasUsuario.Align := alLeft;
  gbHorasUsuario.Width := 430;
  gbHorasUsuario.Caption := 'Frecuencia por usuario / hora';

  qPueHorasUsuario := CrearQuery;
  dsPueHorasUsuario := TDataSource.Create(Self);
  dsPueHorasUsuario.DataSet := qPueHorasUsuario;

  gridPueHorasUsuario := TDBGrid.Create(Self);
  gridPueHorasUsuario.Parent := gbHorasUsuario;
  gridPueHorasUsuario.Align := alClient;
  gridPueHorasUsuario.DataSource := dsPueHorasUsuario;
  gridPueHorasUsuario.ReadOnly := True;
  gridPueHorasUsuario.Options := gridPueHorasUsuario.Options + [dgDisplayMemoText];

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbRevision := TGroupBox.Create(Self);
  gbRevision.Parent := pnlBottom;
  gbRevision.Align := alRight;
  gbRevision.Width := 430;
  gbRevision.Caption := 'Operaciones a revisar';

  qPueRevision := CrearQuery;
  dsPueRevision := TDataSource.Create(Self);
  dsPueRevision.DataSet := qPueRevision;

  gridPueRevision := TDBGrid.Create(Self);
  gridPueRevision.Parent := gbRevision;
  gridPueRevision.Align := alClient;
  gridPueRevision.DataSource := dsPueRevision;
  gridPueRevision.ReadOnly := True;
  gridPueRevision.Options := gridPueRevision.Options + [dgDisplayMemoText];

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbPagosCaja := TGroupBox.Create(Self);
  gbPagosCaja.Parent := pnlBottom;
  gbPagosCaja.Align := alClient;
  gbPagosCaja.Caption := 'Formas de pago por caja';

  qPuePagosCaja := CrearQuery;
  dsPuePagosCaja := TDataSource.Create(Self);
  dsPuePagosCaja.DataSet := qPuePagosCaja;

  gridPuePagosCaja := TDBGrid.Create(Self);
  gridPuePagosCaja.Parent := gbPagosCaja;
  gridPuePagosCaja.Align := alClient;
  gridPuePagosCaja.DataSource := dsPuePagosCaja;
  gridPuePagosCaja.ReadOnly := True;
  gridPuePagosCaja.Options := gridPuePagosCaja.Options + [dgDisplayMemoText];
end;



procedure TFDashboardProductividad.CrearTabCompras;
var
  pnlTop: TPanel;
  pnlBottom: TPanel;
  gbResumen, gbPendientes, gbDetallePend, gbProveedor, gbArticulos, gbRevision: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsCompras;
  pnlTop.Align := alTop;
  pnlTop.Height := 300;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 430;
  gbResumen.Caption := 'Resumen compras / pedidos';

  qComResumen := CrearQuery;
  dsComResumen := TDataSource.Create(Self);
  dsComResumen.DataSet := qComResumen;

  gridComResumen := TDBGrid.Create(Self);
  gridComResumen.Parent := gbResumen;
  gridComResumen.Align := alClient;
  gridComResumen.DataSource := dsComResumen;
  gridComResumen.ReadOnly := True;
  gridComResumen.Options := gridComResumen.Options + [dgDisplayMemoText];

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbDetallePend := TGroupBox.Create(Self);
  gbDetallePend.Parent := pnlTop;
  gbDetallePend.Align := alRight;
  gbDetallePend.Width := 520;
  gbDetallePend.Caption := 'Líneas pendientes de recibir';

  qComDetallePend := CrearQuery;
  dsComDetallePend := TDataSource.Create(Self);
  dsComDetallePend.DataSet := qComDetallePend;

  gridComDetallePend := TDBGrid.Create(Self);
  gridComDetallePend.Parent := gbDetallePend;
  gridComDetallePend.Align := alClient;
  gridComDetallePend.DataSource := dsComDetallePend;
  gridComDetallePend.ReadOnly := True;
  gridComDetallePend.Options := gridComDetallePend.Options + [dgDisplayMemoText];

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbPendientes := TGroupBox.Create(Self);
  gbPendientes.Parent := pnlTop;
  gbPendientes.Align := alClient;
  gbPendientes.Caption := 'Pedidos en curso / pendientes';

  qComPendientes := CrearQuery;
  dsComPendientes := TDataSource.Create(Self);
  dsComPendientes.DataSet := qComPendientes;

  gridComPendientes := TDBGrid.Create(Self);
  gridComPendientes.Parent := gbPendientes;
  gridComPendientes.Align := alClient;
  gridComPendientes.DataSource := dsComPendientes;
  gridComPendientes.ReadOnly := True;
  gridComPendientes.Options := gridComPendientes.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsCompras;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsCompras;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbProveedor := TGroupBox.Create(Self);
  gbProveedor.Parent := pnlBottom;
  gbProveedor.Align := alLeft;
  gbProveedor.Width := 430;
  gbProveedor.Caption := 'Compras / pedidos por proveedor';

  qComProveedor := CrearQuery;
  dsComProveedor := TDataSource.Create(Self);
  dsComProveedor.DataSet := qComProveedor;

  gridComProveedor := TDBGrid.Create(Self);
  gridComProveedor.Parent := gbProveedor;
  gridComProveedor.Align := alClient;
  gridComProveedor.DataSource := dsComProveedor;
  gridComProveedor.ReadOnly := True;
  gridComProveedor.Options := gridComProveedor.Options + [dgDisplayMemoText];

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbRevision := TGroupBox.Create(Self);
  gbRevision.Parent := pnlBottom;
  gbRevision.Align := alRight;
  gbRevision.Width := 430;
  gbRevision.Caption := 'Revisión de compras';

  qComRevision := CrearQuery;
  dsComRevision := TDataSource.Create(Self);
  dsComRevision.DataSet := qComRevision;

  gridComRevision := TDBGrid.Create(Self);
  gridComRevision.Parent := gbRevision;
  gridComRevision.Align := alClient;
  gridComRevision.DataSource := dsComRevision;
  gridComRevision.ReadOnly := True;
  gridComRevision.Options := gridComRevision.Options + [dgDisplayMemoText];

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbArticulos := TGroupBox.Create(Self);
  gbArticulos.Parent := pnlBottom;
  gbArticulos.Align := alClient;
  gbArticulos.Caption := 'Artículos más pedidos';

  qComArticulos := CrearQuery;
  dsComArticulos := TDataSource.Create(Self);
  dsComArticulos.DataSet := qComArticulos;

  gridComArticulos := TDBGrid.Create(Self);
  gridComArticulos.Parent := gbArticulos;
  gridComArticulos.Align := alClient;
  gridComArticulos.DataSource := dsComArticulos;
  gridComArticulos.ReadOnly := True;
  gridComArticulos.Options := gridComArticulos.Options + [dgDisplayMemoText];
end;


procedure TFDashboardProductividad.CrearTabPromociones;
var
  pnlTop: TPanel;
  pnlBottom: TPanel;
  gbResumen, gbDescuentos, gbArticulos, gbFamilias, gbBajoCoste, gbRevision: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsPromociones;
  pnlTop.Align := alTop;
  pnlTop.Height := 300;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 430;
  gbResumen.Caption := 'Resumen promociones / descuentos';

  qPromoResumen := CrearQuery;
  dsPromoResumen := TDataSource.Create(Self);
  dsPromoResumen.DataSet := qPromoResumen;

  gridPromoResumen := TDBGrid.Create(Self);
  gridPromoResumen.Parent := gbResumen;
  gridPromoResumen.Align := alClient;
  gridPromoResumen.DataSource := dsPromoResumen;
  gridPromoResumen.ReadOnly := True;
  gridPromoResumen.Options := gridPromoResumen.Options + [dgDisplayMemoText];

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbArticulos := TGroupBox.Create(Self);
  gbArticulos.Parent := pnlTop;
  gbArticulos.Align := alRight;
  gbArticulos.Width := 520;
  gbArticulos.Caption := 'Artículos con más descuento';

  qPromoArticulos := CrearQuery;
  dsPromoArticulos := TDataSource.Create(Self);
  dsPromoArticulos.DataSet := qPromoArticulos;

  gridPromoArticulos := TDBGrid.Create(Self);
  gridPromoArticulos.Parent := gbArticulos;
  gridPromoArticulos.Align := alClient;
  gridPromoArticulos.DataSource := dsPromoArticulos;
  gridPromoArticulos.ReadOnly := True;
  gridPromoArticulos.Options := gridPromoArticulos.Options + [dgDisplayMemoText];

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbDescuentos := TGroupBox.Create(Self);
  gbDescuentos.Parent := pnlTop;
  gbDescuentos.Align := alClient;
  gbDescuentos.Caption := 'Líneas vendidas con descuento';

  qPromoDescuentos := CrearQuery;
  dsPromoDescuentos := TDataSource.Create(Self);
  dsPromoDescuentos.DataSet := qPromoDescuentos;

  gridPromoDescuentos := TDBGrid.Create(Self);
  gridPromoDescuentos.Parent := gbDescuentos;
  gridPromoDescuentos.Align := alClient;
  gridPromoDescuentos.DataSource := dsPromoDescuentos;
  gridPromoDescuentos.ReadOnly := True;
  gridPromoDescuentos.Options := gridPromoDescuentos.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsPromociones;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsPromociones;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbFamilias := TGroupBox.Create(Self);
  gbFamilias.Parent := pnlBottom;
  gbFamilias.Align := alLeft;
  gbFamilias.Width := 430;
  gbFamilias.Caption := 'Promociones / descuentos por familia';

  qPromoFamilias := CrearQuery;
  dsPromoFamilias := TDataSource.Create(Self);
  dsPromoFamilias.DataSet := qPromoFamilias;

  gridPromoFamilias := TDBGrid.Create(Self);
  gridPromoFamilias.Parent := gbFamilias;
  gridPromoFamilias.Align := alClient;
  gridPromoFamilias.DataSource := dsPromoFamilias;
  gridPromoFamilias.ReadOnly := True;
  gridPromoFamilias.Options := gridPromoFamilias.Options + [dgDisplayMemoText];

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbRevision := TGroupBox.Create(Self);
  gbRevision.Parent := pnlBottom;
  gbRevision.Align := alRight;
  gbRevision.Width := 430;
  gbRevision.Caption := 'Revisión de descuentos';

  qPromoRevision := CrearQuery;
  dsPromoRevision := TDataSource.Create(Self);
  dsPromoRevision.DataSet := qPromoRevision;

  gridPromoRevision := TDBGrid.Create(Self);
  gridPromoRevision.Parent := gbRevision;
  gridPromoRevision.Align := alClient;
  gridPromoRevision.DataSource := dsPromoRevision;
  gridPromoRevision.ReadOnly := True;
  gridPromoRevision.Options := gridPromoRevision.Options + [dgDisplayMemoText];

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbBajoCoste := TGroupBox.Create(Self);
  gbBajoCoste.Parent := pnlBottom;
  gbBajoCoste.Align := alClient;
  gbBajoCoste.Caption := 'Posibles ventas bajo coste';

  qPromoBajoCoste := CrearQuery;
  dsPromoBajoCoste := TDataSource.Create(Self);
  dsPromoBajoCoste.DataSet := qPromoBajoCoste;

  gridPromoBajoCoste := TDBGrid.Create(Self);
  gridPromoBajoCoste.Parent := gbBajoCoste;
  gridPromoBajoCoste.Align := alClient;
  gridPromoBajoCoste.DataSource := dsPromoBajoCoste;
  gridPromoBajoCoste.ReadOnly := True;
  gridPromoBajoCoste.Options := gridPromoBajoCoste.Options + [dgDisplayMemoText];
end;

procedure TFDashboardProductividad.CrearTabRentabilidad;
var
  pnlTop: TPanel;
  pnlBottom: TPanel;
  gbResumen, gbArticulos, gbFamilias, gbProveedores, gbDias, gbRevision: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsRentabilidad;
  pnlTop.Align := alTop;
  pnlTop.Height := 300;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 430;
  gbResumen.Caption := 'Resumen rentabilidad';

  qRentResumen := CrearQuery;
  dsRentResumen := TDataSource.Create(Self);
  dsRentResumen.DataSet := qRentResumen;

  gridRentResumen := TDBGrid.Create(Self);
  gridRentResumen.Parent := gbResumen;
  gridRentResumen.Align := alClient;
  gridRentResumen.DataSource := dsRentResumen;
  gridRentResumen.ReadOnly := True;
  gridRentResumen.Options := gridRentResumen.Options + [dgDisplayMemoText];

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbFamilias := TGroupBox.Create(Self);
  gbFamilias.Parent := pnlTop;
  gbFamilias.Align := alRight;
  gbFamilias.Width := 470;
  gbFamilias.Caption := 'Margen por familia';

  qRentFamilias := CrearQuery;
  dsRentFamilias := TDataSource.Create(Self);
  dsRentFamilias.DataSet := qRentFamilias;

  gridRentFamilias := TDBGrid.Create(Self);
  gridRentFamilias.Parent := gbFamilias;
  gridRentFamilias.Align := alClient;
  gridRentFamilias.DataSource := dsRentFamilias;
  gridRentFamilias.ReadOnly := True;
  gridRentFamilias.Options := gridRentFamilias.Options + [dgDisplayMemoText];

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbArticulos := TGroupBox.Create(Self);
  gbArticulos.Parent := pnlTop;
  gbArticulos.Align := alClient;
  gbArticulos.Caption := 'Top margen por artículo';

  qRentArticulos := CrearQuery;
  dsRentArticulos := TDataSource.Create(Self);
  dsRentArticulos.DataSet := qRentArticulos;

  gridRentArticulos := TDBGrid.Create(Self);
  gridRentArticulos.Parent := gbArticulos;
  gridRentArticulos.Align := alClient;
  gridRentArticulos.DataSource := dsRentArticulos;
  gridRentArticulos.ReadOnly := True;
  gridRentArticulos.Options := gridRentArticulos.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsRentabilidad;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsRentabilidad;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbDias := TGroupBox.Create(Self);
  gbDias.Parent := pnlBottom;
  gbDias.Align := alLeft;
  gbDias.Width := 430;
  gbDias.Caption := 'Rentabilidad por día';

  qRentDias := CrearQuery;
  dsRentDias := TDataSource.Create(Self);
  dsRentDias.DataSet := qRentDias;

  gridRentDias := TDBGrid.Create(Self);
  gridRentDias.Parent := gbDias;
  gridRentDias.Align := alClient;
  gridRentDias.DataSource := dsRentDias;
  gridRentDias.ReadOnly := True;
  gridRentDias.Options := gridRentDias.Options + [dgDisplayMemoText];

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbRevision := TGroupBox.Create(Self);
  gbRevision.Parent := pnlBottom;
  gbRevision.Align := alRight;
  gbRevision.Width := 470;
  gbRevision.Caption := 'Revisión margen / coste';

  qRentRevision := CrearQuery;
  dsRentRevision := TDataSource.Create(Self);
  dsRentRevision.DataSet := qRentRevision;

  gridRentRevision := TDBGrid.Create(Self);
  gridRentRevision.Parent := gbRevision;
  gridRentRevision.Align := alClient;
  gridRentRevision.DataSource := dsRentRevision;
  gridRentRevision.ReadOnly := True;
  gridRentRevision.Options := gridRentRevision.Options + [dgDisplayMemoText];

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbProveedores := TGroupBox.Create(Self);
  gbProveedores.Parent := pnlBottom;
  gbProveedores.Align := alClient;
  gbProveedores.Caption := 'Margen por proveedor estimado';

  qRentProveedores := CrearQuery;
  dsRentProveedores := TDataSource.Create(Self);
  dsRentProveedores.DataSet := qRentProveedores;

  gridRentProveedores := TDBGrid.Create(Self);
  gridRentProveedores.Parent := gbProveedores;
  gridRentProveedores.Align := alClient;
  gridRentProveedores.DataSource := dsRentProveedores;
  gridRentProveedores.ReadOnly := True;
  gridRentProveedores.Options := gridRentProveedores.Options + [dgDisplayMemoText];
end;




procedure TFDashboardProductividad.CrearTabRotacion;
var
  pnlTop: TPanel;
  pnlBottom: TPanel;
  gbResumen, gbAlta, gbRiesgo, gbBaja, gbExceso, gbSinVentas: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsRotacion;
  pnlTop.Align := alTop;
  pnlTop.Height := 300;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 430;
  gbResumen.Caption := 'Resumen rotación / stock';

  qRotResumen := CrearQuery;
  dsRotResumen := TDataSource.Create(Self);
  dsRotResumen.DataSet := qRotResumen;

  gridRotResumen := TDBGrid.Create(Self);
  gridRotResumen.Parent := gbResumen;
  gridRotResumen.Align := alClient;
  gridRotResumen.DataSource := dsRotResumen;
  gridRotResumen.ReadOnly := True;
  gridRotResumen.Options := gridRotResumen.Options + [dgDisplayMemoText];

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbRiesgo := TGroupBox.Create(Self);
  gbRiesgo.Parent := pnlTop;
  gbRiesgo.Align := alRight;
  gbRiesgo.Width := 470;
  gbRiesgo.Caption := 'Riesgo de rotura / cobertura baja';

  qRotRiesgo := CrearQuery;
  dsRotRiesgo := TDataSource.Create(Self);
  dsRotRiesgo.DataSet := qRotRiesgo;

  gridRotRiesgo := TDBGrid.Create(Self);
  gridRotRiesgo.Parent := gbRiesgo;
  gridRotRiesgo.Align := alClient;
  gridRotRiesgo.DataSource := dsRotRiesgo;
  gridRotRiesgo.ReadOnly := True;
  gridRotRiesgo.Options := gridRotRiesgo.Options + [dgDisplayMemoText];

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbAlta := TGroupBox.Create(Self);
  gbAlta.Parent := pnlTop;
  gbAlta.Align := alClient;
  gbAlta.Caption := 'Alta rotación';

  qRotAlta := CrearQuery;
  dsRotAlta := TDataSource.Create(Self);
  dsRotAlta.DataSet := qRotAlta;

  gridRotAlta := TDBGrid.Create(Self);
  gridRotAlta.Parent := gbAlta;
  gridRotAlta.Align := alClient;
  gridRotAlta.DataSource := dsRotAlta;
  gridRotAlta.ReadOnly := True;
  gridRotAlta.Options := gridRotAlta.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsRotacion;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsRotacion;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbBaja := TGroupBox.Create(Self);
  gbBaja.Parent := pnlBottom;
  gbBaja.Align := alLeft;
  gbBaja.Width := 430;
  gbBaja.Caption := 'Baja rotación con stock';

  qRotBaja := CrearQuery;
  dsRotBaja := TDataSource.Create(Self);
  dsRotBaja.DataSet := qRotBaja;

  gridRotBaja := TDBGrid.Create(Self);
  gridRotBaja.Parent := gbBaja;
  gridRotBaja.Align := alClient;
  gridRotBaja.DataSource := dsRotBaja;
  gridRotBaja.ReadOnly := True;
  gridRotBaja.Options := gridRotBaja.Options + [dgDisplayMemoText];

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbSinVentas := TGroupBox.Create(Self);
  gbSinVentas.Parent := pnlBottom;
  gbSinVentas.Align := alRight;
  gbSinVentas.Width := 470;
  gbSinVentas.Caption := 'Stock sin ventas en el rango';

  qRotSinVentas := CrearQuery;
  dsRotSinVentas := TDataSource.Create(Self);
  dsRotSinVentas.DataSet := qRotSinVentas;

  gridRotSinVentas := TDBGrid.Create(Self);
  gridRotSinVentas.Parent := gbSinVentas;
  gridRotSinVentas.Align := alClient;
  gridRotSinVentas.DataSource := dsRotSinVentas;
  gridRotSinVentas.ReadOnly := True;
  gridRotSinVentas.Options := gridRotSinVentas.Options + [dgDisplayMemoText];

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbExceso := TGroupBox.Create(Self);
  gbExceso.Parent := pnlBottom;
  gbExceso.Align := alClient;
  gbExceso.Caption := 'Exceso de stock / cobertura alta';

  qRotExceso := CrearQuery;
  dsRotExceso := TDataSource.Create(Self);
  dsRotExceso.DataSet := qRotExceso;

  gridRotExceso := TDBGrid.Create(Self);
  gridRotExceso.Parent := gbExceso;
  gridRotExceso.Align := alClient;
  gridRotExceso.DataSource := dsRotExceso;
  gridRotExceso.ReadOnly := True;
  gridRotExceso.Options := gridRotExceso.Options + [dgDisplayMemoText];
end;


procedure TFDashboardProductividad.CrearTabReposicion;
var
  pnlTop: TPanel;
  pnlBottom: TPanel;
  gbResumen, gbSugerido, gbUrgente, gbProveedor, gbSinProveedor, gbBajaRotacion: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsReposicion;
  pnlTop.Align := alTop;
  pnlTop.Height := 300;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 360;
  gbResumen.Caption := 'Resumen reposición';

  qRepResumen := CrearQuery;
  dsRepResumen := TDataSource.Create(Self);
  dsRepResumen.DataSet := qRepResumen;

  gridRepResumen := TDBGrid.Create(Self);
  gridRepResumen.Parent := gbResumen;
  gridRepResumen.Align := alClient;
  gridRepResumen.DataSource := dsRepResumen;
  gridRepResumen.ReadOnly := True;
  gridRepResumen.Options := gridRepResumen.Options + [dgDisplayMemoText];

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbUrgente := TGroupBox.Create(Self);
  gbUrgente.Parent := pnlTop;
  gbUrgente.Align := alRight;
  gbUrgente.Width := 440;
  gbUrgente.Caption := 'Urgente: stock 0 vendido';

  qRepUrgente := CrearQuery;
  dsRepUrgente := TDataSource.Create(Self);
  dsRepUrgente.DataSet := qRepUrgente;

  gridRepUrgente := TDBGrid.Create(Self);
  gridRepUrgente.Parent := gbUrgente;
  gridRepUrgente.Align := alClient;
  gridRepUrgente.DataSource := dsRepUrgente;
  gridRepUrgente.ReadOnly := True;
  gridRepUrgente.Options := gridRepUrgente.Options + [dgDisplayMemoText];

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbSugerido := TGroupBox.Create(Self);
  gbSugerido.Parent := pnlTop;
  gbSugerido.Align := alClient;
  gbSugerido.Caption := 'Pedido sugerido orientativo';

  qRepSugerido := CrearQuery;
  dsRepSugerido := TDataSource.Create(Self);
  dsRepSugerido.DataSet := qRepSugerido;

  gridRepSugerido := TDBGrid.Create(Self);
  gridRepSugerido.Parent := gbSugerido;
  gridRepSugerido.Align := alClient;
  gridRepSugerido.DataSource := dsRepSugerido;
  gridRepSugerido.ReadOnly := True;
  gridRepSugerido.Options := gridRepSugerido.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsReposicion;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsReposicion;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbProveedor := TGroupBox.Create(Self);
  gbProveedor.Parent := pnlBottom;
  gbProveedor.Align := alLeft;
  gbProveedor.Width := 430;
  gbProveedor.Caption := 'Necesidad por proveedor';

  qRepProveedor := CrearQuery;
  dsRepProveedor := TDataSource.Create(Self);
  dsRepProveedor.DataSet := qRepProveedor;

  gridRepProveedor := TDBGrid.Create(Self);
  gridRepProveedor.Parent := gbProveedor;
  gridRepProveedor.Align := alClient;
  gridRepProveedor.DataSource := dsRepProveedor;
  gridRepProveedor.ReadOnly := True;
  gridRepProveedor.Options := gridRepProveedor.Options + [dgDisplayMemoText];

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbBajaRotacion := TGroupBox.Create(Self);
  gbBajaRotacion.Parent := pnlBottom;
  gbBajaRotacion.Align := alRight;
  gbBajaRotacion.Width := 470;
  gbBajaRotacion.Caption := 'Stock con baja rotación';

  qRepBajaRotacion := CrearQuery;
  dsRepBajaRotacion := TDataSource.Create(Self);
  dsRepBajaRotacion.DataSet := qRepBajaRotacion;

  gridRepBajaRotacion := TDBGrid.Create(Self);
  gridRepBajaRotacion.Parent := gbBajaRotacion;
  gridRepBajaRotacion.Align := alClient;
  gridRepBajaRotacion.DataSource := dsRepBajaRotacion;
  gridRepBajaRotacion.ReadOnly := True;
  gridRepBajaRotacion.Options := gridRepBajaRotacion.Options + [dgDisplayMemoText];

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbSinProveedor := TGroupBox.Create(Self);
  gbSinProveedor.Parent := pnlBottom;
  gbSinProveedor.Align := alClient;
  gbSinProveedor.Caption := 'Vendidos sin proveedor asignado';

  qRepSinProveedor := CrearQuery;
  dsRepSinProveedor := TDataSource.Create(Self);
  dsRepSinProveedor.DataSet := qRepSinProveedor;

  gridRepSinProveedor := TDBGrid.Create(Self);
  gridRepSinProveedor.Parent := gbSinProveedor;
  gridRepSinProveedor.Align := alClient;
  gridRepSinProveedor.DataSource := dsRepSinProveedor;
  gridRepSinProveedor.ReadOnly := True;
  gridRepSinProveedor.Options := gridRepSinProveedor.Options + [dgDisplayMemoText];
end;


procedure TFDashboardProductividad.CrearTabPicking;
var
  pnlTop: TPanel;
  pnlBottom: TPanel;
  gbResumen, gbRuta, gbUbicacion, gbProveedor, gbSinUbicacion, gbRevision: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsPicking;
  pnlTop.Align := alTop;
  pnlTop.Height := 300;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 360;
  gbResumen.Caption := 'Resumen preparación';

  qPickResumen := CrearQuery;
  dsPickResumen := TDataSource.Create(Self);
  dsPickResumen.DataSet := qPickResumen;

  gridPickResumen := TDBGrid.Create(Self);
  gridPickResumen.Parent := gbResumen;
  gridPickResumen.Align := alClient;
  gridPickResumen.DataSource := dsPickResumen;
  gridPickResumen.ReadOnly := True;
  gridPickResumen.Options := gridPickResumen.Options + [dgDisplayMemoText];

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbProveedor := TGroupBox.Create(Self);
  gbProveedor.Parent := pnlTop;
  gbProveedor.Align := alRight;
  gbProveedor.Width := 430;
  gbProveedor.Caption := 'Preparación por proveedor';

  qPickProveedor := CrearQuery;
  dsPickProveedor := TDataSource.Create(Self);
  dsPickProveedor.DataSet := qPickProveedor;

  gridPickProveedor := TDBGrid.Create(Self);
  gridPickProveedor.Parent := gbProveedor;
  gridPickProveedor.Align := alClient;
  gridPickProveedor.DataSource := dsPickProveedor;
  gridPickProveedor.ReadOnly := True;
  gridPickProveedor.Options := gridPickProveedor.Options + [dgDisplayMemoText];

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbRuta := TGroupBox.Create(Self);
  gbRuta.Parent := pnlTop;
  gbRuta.Align := alClient;
  gbRuta.Caption := 'Ruta de preparación / picking sugerido';

  qPickRuta := CrearQuery;
  dsPickRuta := TDataSource.Create(Self);
  dsPickRuta.DataSet := qPickRuta;

  gridPickRuta := TDBGrid.Create(Self);
  gridPickRuta.Parent := gbRuta;
  gridPickRuta.Align := alClient;
  gridPickRuta.DataSource := dsPickRuta;
  gridPickRuta.ReadOnly := True;
  gridPickRuta.Options := gridPickRuta.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsPicking;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsPicking;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbUbicacion := TGroupBox.Create(Self);
  gbUbicacion.Parent := pnlBottom;
  gbUbicacion.Align := alLeft;
  gbUbicacion.Width := 430;
  gbUbicacion.Caption := 'Preparación por ubicación / familia';

  qPickUbicacion := CrearQuery;
  dsPickUbicacion := TDataSource.Create(Self);
  dsPickUbicacion.DataSet := qPickUbicacion;

  gridPickUbicacion := TDBGrid.Create(Self);
  gridPickUbicacion.Parent := gbUbicacion;
  gridPickUbicacion.Align := alClient;
  gridPickUbicacion.DataSource := dsPickUbicacion;
  gridPickUbicacion.ReadOnly := True;
  gridPickUbicacion.Options := gridPickUbicacion.Options + [dgDisplayMemoText];

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbRevision := TGroupBox.Create(Self);
  gbRevision.Parent := pnlBottom;
  gbRevision.Align := alRight;
  gbRevision.Width := 460;
  gbRevision.Caption := 'Revisión antes de preparar';

  qPickRevision := CrearQuery;
  dsPickRevision := TDataSource.Create(Self);
  dsPickRevision.DataSet := qPickRevision;

  gridPickRevision := TDBGrid.Create(Self);
  gridPickRevision.Parent := gbRevision;
  gridPickRevision.Align := alClient;
  gridPickRevision.DataSource := dsPickRevision;
  gridPickRevision.ReadOnly := True;
  gridPickRevision.Options := gridPickRevision.Options + [dgDisplayMemoText];

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbSinUbicacion := TGroupBox.Create(Self);
  gbSinUbicacion.Parent := pnlBottom;
  gbSinUbicacion.Align := alClient;
  gbSinUbicacion.Caption := 'Artículos a preparar sin ubicación';

  qPickSinUbicacion := CrearQuery;
  dsPickSinUbicacion := TDataSource.Create(Self);
  dsPickSinUbicacion.DataSet := qPickSinUbicacion;

  gridPickSinUbicacion := TDBGrid.Create(Self);
  gridPickSinUbicacion.Parent := gbSinUbicacion;
  gridPickSinUbicacion.Align := alClient;
  gridPickSinUbicacion.DataSource := dsPickSinUbicacion;
  gridPickSinUbicacion.ReadOnly := True;
  gridPickSinUbicacion.Options := gridPickSinUbicacion.Options + [dgDisplayMemoText];
end;



procedure TFDashboardProductividad.CrearTabCalidad;
var
  pnlTop: TPanel;
  pnlBottom: TPanel;
  gbResumen, gbIncompletos, gbPrecios, gbStock, gbDuplicados, gbSinMovimiento: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsCalidad;
  pnlTop.Align := alTop;
  pnlTop.Height := 300;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 360;
  gbResumen.Caption := 'Resumen calidad de datos';

  qCalResumen := CrearQuery;
  dsCalResumen := TDataSource.Create(Self);
  dsCalResumen.DataSet := qCalResumen;

  gridCalResumen := TDBGrid.Create(Self);
  gridCalResumen.Parent := gbResumen;
  gridCalResumen.Align := alClient;
  gridCalResumen.DataSource := dsCalResumen;
  gridCalResumen.ReadOnly := True;
  gridCalResumen.Options := gridCalResumen.Options + [dgDisplayMemoText];

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbPrecios := TGroupBox.Create(Self);
  gbPrecios.Parent := pnlTop;
  gbPrecios.Align := alRight;
  gbPrecios.Width := 470;
  gbPrecios.Caption := 'Precios / márgenes sospechosos';

  qCalPrecios := CrearQuery;
  dsCalPrecios := TDataSource.Create(Self);
  dsCalPrecios.DataSet := qCalPrecios;

  gridCalPrecios := TDBGrid.Create(Self);
  gridCalPrecios.Parent := gbPrecios;
  gridCalPrecios.Align := alClient;
  gridCalPrecios.DataSource := dsCalPrecios;
  gridCalPrecios.ReadOnly := True;
  gridCalPrecios.Options := gridCalPrecios.Options + [dgDisplayMemoText];

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbIncompletos := TGroupBox.Create(Self);
  gbIncompletos.Parent := pnlTop;
  gbIncompletos.Align := alClient;
  gbIncompletos.Caption := 'Artículos incompletos';

  qCalIncompletos := CrearQuery;
  dsCalIncompletos := TDataSource.Create(Self);
  dsCalIncompletos.DataSet := qCalIncompletos;

  gridCalIncompletos := TDBGrid.Create(Self);
  gridCalIncompletos.Parent := gbIncompletos;
  gridCalIncompletos.Align := alClient;
  gridCalIncompletos.DataSource := dsCalIncompletos;
  gridCalIncompletos.ReadOnly := True;
  gridCalIncompletos.Options := gridCalIncompletos.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsCalidad;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsCalidad;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbStock := TGroupBox.Create(Self);
  gbStock.Parent := pnlBottom;
  gbStock.Align := alLeft;
  gbStock.Width := 430;
  gbStock.Caption := 'Stock sospechoso';

  qCalStock := CrearQuery;
  dsCalStock := TDataSource.Create(Self);
  dsCalStock.DataSet := qCalStock;

  gridCalStock := TDBGrid.Create(Self);
  gridCalStock.Parent := gbStock;
  gridCalStock.Align := alClient;
  gridCalStock.DataSource := dsCalStock;
  gridCalStock.ReadOnly := True;
  gridCalStock.Options := gridCalStock.Options + [dgDisplayMemoText];

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbSinMovimiento := TGroupBox.Create(Self);
  gbSinMovimiento.Parent := pnlBottom;
  gbSinMovimiento.Align := alRight;
  gbSinMovimiento.Width := 470;
  gbSinMovimiento.Caption := 'Stock sin movimiento +365 días';

  qCalSinMovimiento := CrearQuery;
  dsCalSinMovimiento := TDataSource.Create(Self);
  dsCalSinMovimiento.DataSet := qCalSinMovimiento;

  gridCalSinMovimiento := TDBGrid.Create(Self);
  gridCalSinMovimiento.Parent := gbSinMovimiento;
  gridCalSinMovimiento.Align := alClient;
  gridCalSinMovimiento.DataSource := dsCalSinMovimiento;
  gridCalSinMovimiento.ReadOnly := True;
  gridCalSinMovimiento.Options := gridCalSinMovimiento.Options + [dgDisplayMemoText];

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbDuplicados := TGroupBox.Create(Self);
  gbDuplicados.Parent := pnlBottom;
  gbDuplicados.Align := alClient;
  gbDuplicados.Caption := 'Posibles duplicados por descripción';

  qCalDuplicados := CrearQuery;
  dsCalDuplicados := TDataSource.Create(Self);
  dsCalDuplicados.DataSet := qCalDuplicados;

  gridCalDuplicados := TDBGrid.Create(Self);
  gridCalDuplicados.Parent := gbDuplicados;
  gridCalDuplicados.Align := alClient;
  gridCalDuplicados.DataSource := dsCalDuplicados;
  gridCalDuplicados.ReadOnly := True;
  gridCalDuplicados.Options := gridCalDuplicados.Options + [dgDisplayMemoText];
end;


procedure TFDashboardProductividad.CrearTabVeriFactu;
var
  pnlTop: TPanel;
  pnlBottom: TPanel;
  gbResumen, gbPendientes, gbAceptadosErrores, gbErrores, gbSeries, gbUltimos: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsVeriFactu;
  pnlTop.Align := alTop;
  pnlTop.Height := 300;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 360;
  gbResumen.Caption := 'Resumen VeriFactu';

  qVFResumen := CrearQuery;
  dsVFResumen := TDataSource.Create(Self);
  dsVFResumen.DataSet := qVFResumen;

  gridVFResumen := TDBGrid.Create(Self);
  gridVFResumen.Parent := gbResumen;
  gridVFResumen.Align := alClient;
  gridVFResumen.DataSource := dsVFResumen;
  gridVFResumen.ReadOnly := True;
  gridVFResumen.Options := gridVFResumen.Options + [dgDisplayMemoText];

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbAceptadosErrores := TGroupBox.Create(Self);
  gbAceptadosErrores.Parent := pnlTop;
  gbAceptadosErrores.Align := alRight;
  gbAceptadosErrores.Width := 460;
  gbAceptadosErrores.Caption := 'Aceptados con errores';

  qVFAceptadosErrores := CrearQuery;
  dsVFAceptadosErrores := TDataSource.Create(Self);
  dsVFAceptadosErrores.DataSet := qVFAceptadosErrores;

  gridVFAceptadosErrores := TDBGrid.Create(Self);
  gridVFAceptadosErrores.Parent := gbAceptadosErrores;
  gridVFAceptadosErrores.Align := alClient;
  gridVFAceptadosErrores.DataSource := dsVFAceptadosErrores;
  gridVFAceptadosErrores.ReadOnly := True;
  gridVFAceptadosErrores.Options := gridVFAceptadosErrores.Options + [dgDisplayMemoText];

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbPendientes := TGroupBox.Create(Self);
  gbPendientes.Parent := pnlTop;
  gbPendientes.Align := alClient;
  gbPendientes.Caption := 'Pendientes / en cola';

  qVFPendientes := CrearQuery;
  dsVFPendientes := TDataSource.Create(Self);
  dsVFPendientes.DataSet := qVFPendientes;

  gridVFPendientes := TDBGrid.Create(Self);
  gridVFPendientes.Parent := gbPendientes;
  gridVFPendientes.Align := alClient;
  gridVFPendientes.DataSource := dsVFPendientes;
  gridVFPendientes.ReadOnly := True;
  gridVFPendientes.Options := gridVFPendientes.Options + [dgDisplayMemoText];

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsVeriFactu;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsVeriFactu;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbErrores := TGroupBox.Create(Self);
  gbErrores.Parent := pnlBottom;
  gbErrores.Align := alLeft;
  gbErrores.Width := 460;
  gbErrores.Caption := 'Últimos errores';

  qVFErrores := CrearQuery;
  dsVFErrores := TDataSource.Create(Self);
  dsVFErrores.DataSet := qVFErrores;

  gridVFErrores := TDBGrid.Create(Self);
  gridVFErrores.Parent := gbErrores;
  gridVFErrores.Align := alClient;
  gridVFErrores.DataSource := dsVFErrores;
  gridVFErrores.ReadOnly := True;
  gridVFErrores.Options := gridVFErrores.Options + [dgDisplayMemoText];

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbUltimos := TGroupBox.Create(Self);
  gbUltimos.Parent := pnlBottom;
  gbUltimos.Align := alRight;
  gbUltimos.Width := 520;
  gbUltimos.Caption := 'Últimos registros';

  qVFUltimos := CrearQuery;
  dsVFUltimos := TDataSource.Create(Self);
  dsVFUltimos.DataSet := qVFUltimos;

  gridVFUltimos := TDBGrid.Create(Self);
  gridVFUltimos.Parent := gbUltimos;
  gridVFUltimos.Align := alClient;
  gridVFUltimos.DataSource := dsVFUltimos;
  gridVFUltimos.ReadOnly := True;
  gridVFUltimos.Options := gridVFUltimos.Options + [dgDisplayMemoText];

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbSeries := TGroupBox.Create(Self);
  gbSeries.Parent := pnlBottom;
  gbSeries.Align := alClient;
  gbSeries.Caption := 'Series / cadena hash';

  qVFSeries := CrearQuery;
  dsVFSeries := TDataSource.Create(Self);
  dsVFSeries.DataSet := qVFSeries;

  gridVFSeries := TDBGrid.Create(Self);
  gridVFSeries.Parent := gbSeries;
  gridVFSeries.Align := alClient;
  gridVFSeries.DataSource := dsVFSeries;
  gridVFSeries.ReadOnly := True;
  gridVFSeries.Options := gridVFSeries.Options + [dgDisplayMemoText];
end;


procedure TFDashboardProductividad.CrearTabGraficas;
var
  pnlTop, pnlBottom: TPanel;
  gbAno, gbTicketMedio, gbTicketsHora, gbPagos, gbComprasVentas, gbVentasCobros: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsGraficas;
  pnlTop.Align := alTop;
  pnlTop.Height := 310;
  pnlTop.BevelOuter := bvNone;

  gbAno := TGroupBox.Create(Self);
  gbAno.Parent := pnlTop;
  gbAno.Align := alLeft;
  gbAno.Width := 420;
  gbAno.Caption := 'Año actual vs anterior';

  pbGrafAnoActualAnterior := TPaintBox.Create(Self);
  pbGrafAnoActualAnterior.Parent := gbAno;
  pbGrafAnoActualAnterior.Align := alClient;
  pbGrafAnoActualAnterior.OnPaint := @GrafAnoActualAnteriorPaint;

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbTicketsHora := TGroupBox.Create(Self);
  gbTicketsHora.Parent := pnlTop;
  gbTicketsHora.Align := alRight;
  gbTicketsHora.Width := 420;
  gbTicketsHora.Caption := 'Número de tickets por hora';

  pbGrafTicketsHora := TPaintBox.Create(Self);
  pbGrafTicketsHora.Parent := gbTicketsHora;
  pbGrafTicketsHora.Align := alClient;
  pbGrafTicketsHora.OnPaint := @GrafTicketsHoraPaint;

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbTicketMedio := TGroupBox.Create(Self);
  gbTicketMedio.Parent := pnlTop;
  gbTicketMedio.Align := alClient;
  gbTicketMedio.Caption := 'Ticket medio según horas';

  pbGrafTicketMedioHora := TPaintBox.Create(Self);
  pbGrafTicketMedioHora.Parent := gbTicketMedio;
  pbGrafTicketMedioHora.Align := alClient;
  pbGrafTicketMedioHora.OnPaint := @GrafTicketMedioHoraPaint;

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsGraficas;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsGraficas;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbPagos := TGroupBox.Create(Self);
  gbPagos.Parent := pnlBottom;
  gbPagos.Align := alLeft;
  gbPagos.Width := 420;
  gbPagos.Caption := 'Formas de pago vs año anterior';

  pbGrafPagosComparativa := TPaintBox.Create(Self);
  pbGrafPagosComparativa.Parent := gbPagos;
  pbGrafPagosComparativa.Align := alClient;
  pbGrafPagosComparativa.OnPaint := @PintarPagosComparativa;

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbVentasCobros := TGroupBox.Create(Self);
  gbVentasCobros.Parent := pnlBottom;
  gbVentasCobros.Align := alRight;
  gbVentasCobros.Width := 420;
  gbVentasCobros.Caption := 'Ventas vs cobros';

  pbGrafVentasCobros := TPaintBox.Create(Self);
  pbGrafVentasCobros.Parent := gbVentasCobros;
  pbGrafVentasCobros.Align := alClient;
  pbGrafVentasCobros.OnPaint := @GrafVentasCobrosPaint;

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbComprasVentas := TGroupBox.Create(Self);
  gbComprasVentas.Parent := pnlBottom;
  gbComprasVentas.Align := alClient;
  gbComprasVentas.Caption := 'Compras vs ventas';

  pbGrafComprasVentas := TPaintBox.Create(Self);
  pbGrafComprasVentas.Parent := gbComprasVentas;
  pbGrafComprasVentas.Align := alClient;
  pbGrafComprasVentas.OnPaint := @GrafComprasVentasPaint;
end;


procedure TFDashboardProductividad.CrearTabComparativaAvanzada;
var
  pnlTop, pnlBottom: TPanel;
  gbResumen, gbDia, gbMes, gbPeriodo, gbGrafVentas, gbGrafCaja: TGroupBox;
  spTopLeft, spTopRight, spFilas, spBottomLeft, spBottomRight: TSplitter;

  procedure PrepararGrid(var Q: TZQuery; var DS: TDataSource; var Grid: TDBGrid; AParent: TWinControl);
  begin
    Q := CrearQuery;
    DS := TDataSource.Create(Self);
    DS.DataSet := Q;
    Grid := TDBGrid.Create(Self);
    Grid.Parent := AParent;
    Grid.Align := alClient;
    Grid.DataSource := DS;
    Grid.ReadOnly := True;
    Grid.Options := Grid.Options + [dgDisplayMemoText];
  end;

begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsComparativaAvanzada;
  pnlTop.Align := alTop;
  pnlTop.Height := 310;
  pnlTop.BevelOuter := bvNone;

  gbResumen := TGroupBox.Create(Self);
  gbResumen.Parent := pnlTop;
  gbResumen.Align := alLeft;
  gbResumen.Width := 430;
  gbResumen.Caption := 'Resumen periodo seleccionado';
  PrepararGrid(qCmpAvResumen, dsCmpAvResumen, gridCmpAvResumen, gbResumen);

  spTopLeft := TSplitter.Create(Self);
  spTopLeft.Parent := pnlTop;
  spTopLeft.Align := alLeft;
  spTopLeft.Width := 5;

  gbMes := TGroupBox.Create(Self);
  gbMes.Parent := pnlTop;
  gbMes.Align := alRight;
  gbMes.Width := 430;
  gbMes.Caption := 'Mes vs mes anterior / año anterior';
  PrepararGrid(qCmpAvMes, dsCmpAvMes, gridCmpAvMes, gbMes);

  spTopRight := TSplitter.Create(Self);
  spTopRight.Parent := pnlTop;
  spTopRight.Align := alRight;
  spTopRight.Width := 5;

  gbDia := TGroupBox.Create(Self);
  gbDia.Parent := pnlTop;
  gbDia.Align := alClient;
  gbDia.Caption := 'Día vs semana / mes / año anterior';
  PrepararGrid(qCmpAvDia, dsCmpAvDia, gridCmpAvDia, gbDia);

  spFilas := TSplitter.Create(Self);
  spFilas.Parent := tsComparativaAvanzada;
  spFilas.Align := alTop;
  spFilas.Height := 5;

  pnlBottom := TPanel.Create(Self);
  pnlBottom.Parent := tsComparativaAvanzada;
  pnlBottom.Align := alClient;
  pnlBottom.BevelOuter := bvNone;

  gbPeriodo := TGroupBox.Create(Self);
  gbPeriodo.Parent := pnlBottom;
  gbPeriodo.Align := alLeft;
  gbPeriodo.Width := 430;
  gbPeriodo.Caption := 'Periodo vs semana / mes / año anterior';
  PrepararGrid(qCmpAvPeriodo, dsCmpAvPeriodo, gridCmpAvPeriodo, gbPeriodo);

  spBottomLeft := TSplitter.Create(Self);
  spBottomLeft.Parent := pnlBottom;
  spBottomLeft.Align := alLeft;
  spBottomLeft.Width := 5;

  gbGrafCaja := TGroupBox.Create(Self);
  gbGrafCaja.Parent := pnlBottom;
  gbGrafCaja.Align := alRight;
  gbGrafCaja.Width := 430;
  gbGrafCaja.Caption := 'Gráfico caja total';

  pbCmpAvCaja := TPaintBox.Create(Self);
  pbCmpAvCaja.Parent := gbGrafCaja;
  pbCmpAvCaja.Align := alClient;
  pbCmpAvCaja.OnPaint := @CmpAvCajaPaint;

  spBottomRight := TSplitter.Create(Self);
  spBottomRight.Parent := pnlBottom;
  spBottomRight.Align := alRight;
  spBottomRight.Width := 5;

  gbGrafVentas := TGroupBox.Create(Self);
  gbGrafVentas.Parent := pnlBottom;
  gbGrafVentas.Align := alClient;
  gbGrafVentas.Caption := 'Gráfico ventas';

  pbCmpAvVentas := TPaintBox.Create(Self);
  pbCmpAvVentas.Parent := gbGrafVentas;
  pbCmpAvVentas.Align := alClient;
  pbCmpAvVentas.OnPaint := @CmpAvVentasPaint;
end;


procedure TFDashboardProductividad.CrearTabConsultaLibre;
var
  pnlTop, pnlIzq, pnlSQL, pnlBotones: TPanel;
  L: TLabel;
begin
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := tsConsultaLibre;
  pnlTop.Align := alTop;
  pnlTop.Height := 230;
  pnlTop.BevelOuter := bvNone;

  pnlIzq := TPanel.Create(Self);
  pnlIzq.Parent := pnlTop;
  pnlIzq.Align := alLeft;
  pnlIzq.Width := 330;
  pnlIzq.BevelOuter := bvNone;

  L := TLabel.Create(Self);
  L.Parent := pnlIzq;
  L.Left := 8;
  L.Top := 8;
  L.Caption := 'Tabla';
  L.Font.Style := [fsBold];

  cbLibreTabla := TComboBox.Create(Self);
  cbLibreTabla.Parent := pnlIzq;
  cbLibreTabla.Left := 8;
  cbLibreTabla.Top := 28;
  cbLibreTabla.Width := 310;
  cbLibreTabla.Style := csDropDownList;
  cbLibreTabla.OnChange := @ConsultaLibreTablaChange;

  btnLibreCargarTablas := TButton.Create(Self);
  btnLibreCargarTablas.Parent := pnlIzq;
  btnLibreCargarTablas.Left := 8;
  btnLibreCargarTablas.Top := 58;
  btnLibreCargarTablas.Width := 150;
  btnLibreCargarTablas.Height := 28;
  btnLibreCargarTablas.Caption := 'Recargar tablas';
  btnLibreCargarTablas.OnClick := @ConsultaLibreCargarTablasClick;

  btnLibreEjecutarSelector := TButton.Create(Self);
  btnLibreEjecutarSelector.Parent := pnlIzq;
  btnLibreEjecutarSelector.Left := 168;
  btnLibreEjecutarSelector.Top := 58;
  btnLibreEjecutarSelector.Width := 150;
  btnLibreEjecutarSelector.Height := 28;
  btnLibreEjecutarSelector.Caption := 'Listar selección';
  btnLibreEjecutarSelector.OnClick := @ConsultaLibreEjecutarSelectorClick;

  L := TLabel.Create(Self);
  L.Parent := pnlIzq;
  L.Left := 8;
  L.Top := 96;
  L.Caption := 'Campos (selección múltiple)';
  L.Font.Style := [fsBold];

  lbLibreCampos := TListBox.Create(Self);
  lbLibreCampos.Parent := pnlIzq;
  lbLibreCampos.Left := 8;
  lbLibreCampos.Top := 116;
  lbLibreCampos.Width := 310;
  lbLibreCampos.Height := 104;
  lbLibreCampos.MultiSelect := True;

  pnlSQL := TPanel.Create(Self);
  pnlSQL.Parent := pnlTop;
  pnlSQL.Align := alClient;
  pnlSQL.BevelOuter := bvNone;

  L := TLabel.Create(Self);
  L.Parent := pnlSQL;
  L.Left := 8;
  L.Top := 8;
  L.Caption := 'Consulta SQL manual (solo lectura: SELECT / SHOW / DESCRIBE / EXPLAIN)';
  L.Font.Style := [fsBold];

  memoLibreSQL := TMemo.Create(Self);
  memoLibreSQL.Parent := pnlSQL;
  memoLibreSQL.Left := 8;
  memoLibreSQL.Top := 28;
  memoLibreSQL.Align := alClient;
  memoLibreSQL.BorderSpacing.Left := 8;
  memoLibreSQL.BorderSpacing.Right := 8;
  memoLibreSQL.BorderSpacing.Top := 28;
  // Dejar solo un peque�o margen hasta el panel de botones.
  // Antes estaba en 76 y hac�a demasiado peque�a la zona de SQL manual.
  memoLibreSQL.BorderSpacing.Bottom := 8;
  memoLibreSQL.ScrollBars := ssBoth;
  memoLibreSQL.WordWrap := False;
  memoLibreSQL.Lines.Text := 'SELECT * FROM ' + Tabla('hisopcc') + ' LIMIT 100';

  pnlBotones := TPanel.Create(Self);
  pnlBotones.Parent := pnlSQL;
  pnlBotones.Align := alBottom;
  pnlBotones.Height := 72;
  pnlBotones.BevelOuter := bvNone;

  btnLibreEjecutarSQL := TButton.Create(Self);
  btnLibreEjecutarSQL.Parent := pnlBotones;
  btnLibreEjecutarSQL.Left := 8;
  btnLibreEjecutarSQL.Top := 5;
  btnLibreEjecutarSQL.Width := 120;
  btnLibreEjecutarSQL.Height := 28;
  btnLibreEjecutarSQL.Caption := 'Ejecutar SQL';
  btnLibreEjecutarSQL.OnClick := @ConsultaLibreEjecutarSQLClick;

  btnLibreGuardarSQL := TButton.Create(Self);
  btnLibreGuardarSQL.Parent := pnlBotones;
  btnLibreGuardarSQL.Left := 138;
  btnLibreGuardarSQL.Top := 5;
  btnLibreGuardarSQL.Width := 120;
  btnLibreGuardarSQL.Height := 28;
  btnLibreGuardarSQL.Caption := 'Guardar SQL';
  btnLibreGuardarSQL.OnClick := @ConsultaLibreGuardarSQLClick;

  btnLibreAbrirSQL := TButton.Create(Self);
  btnLibreAbrirSQL.Parent := pnlBotones;
  btnLibreAbrirSQL.Left := 268;
  btnLibreAbrirSQL.Top := 5;
  btnLibreAbrirSQL.Width := 120;
  btnLibreAbrirSQL.Height := 28;
  btnLibreAbrirSQL.Caption := 'Abrir SQL';
  btnLibreAbrirSQL.OnClick := @ConsultaLibreAbrirSQLClick;

  btnLibreAbrirCarpetaSQL := TButton.Create(Self);
  btnLibreAbrirCarpetaSQL.Parent := pnlBotones;
  btnLibreAbrirCarpetaSQL.Left := 8;
  btnLibreAbrirCarpetaSQL.Top := 39;
  btnLibreAbrirCarpetaSQL.Width := 120;
  btnLibreAbrirCarpetaSQL.Height := 28;
  btnLibreAbrirCarpetaSQL.Caption := 'Carpeta SQL';
  btnLibreAbrirCarpetaSQL.Hint := 'Abrir la carpeta donde se guardan las consultas SQL del dashboard';
  btnLibreAbrirCarpetaSQL.ShowHint := True;
  btnLibreAbrirCarpetaSQL.OnClick := @ConsultaLibreAbrirCarpetaSQLClick;

  lblLibreInfo := TLabel.Create(Self);
  lblLibreInfo.Parent := pnlBotones;
  lblLibreInfo.Left := 138;
  lblLibreInfo.Top := 45;
  lblLibreInfo.Caption := 'SQL solo lectura. Puedes guardar y abrir consultas .sql seguras.';

  qLibreTablas := CrearQuery;
  qLibreCampos := CrearQuery;
  qLibreResultado := CrearQuery;
  dsLibreResultado := TDataSource.Create(Self);
  dsLibreResultado.DataSet := qLibreResultado;

  gridLibreResultado := TDBGrid.Create(Self);
  gridLibreResultado.Parent := tsConsultaLibre;
  gridLibreResultado.Align := alClient;
  gridLibreResultado.DataSource := dsLibreResultado;
  gridLibreResultado.ReadOnly := True;
  gridLibreResultado.Options := gridLibreResultado.Options + [dgDisplayMemoText];
end;


function TFDashboardProductividad.CrearQuery: TZQuery;
begin
  Result := TZQuery.Create(Self);
  Result.Connection := FConn;
end;

function TFDashboardProductividad.Tabla(const Base: string): string;
begin
  Result := '`' + Base + FTienda + '`';
end;


function TFDashboardProductividad.TablaExiste(const ANombre: string): Boolean;
var
  Q: TZQuery;
  NombreTabla: string;
begin
  Result := False;

  // Tabla() devuelve el nombre preparado para SQL, entre acentos graves
  // (`usuarios0000`). Para INFORMATION_SCHEMA hay que consultar el nombre
  // real de tabla, sin esos acentos graves. Esto afectaba a usuarios+tienda
  // y por eso no se leia USU9 en Cuadro gestion.
  NombreTabla := StringReplace(ANombre, '`', '', [rfReplaceAll]);

  Q := CrearQuery;
  try
    Q.SQL.Text :=
      'SELECT COUNT(*) AS existe ' +
      'FROM information_schema.tables ' +
      'WHERE table_schema = DATABASE() AND table_name = :tabla';
    Q.ParamByName('tabla').AsString := NombreTabla;
    Q.Open;
    Result := CampoInteger(Q, 'existe') > 0;
    Q.Close;
  except
    on E: Exception do
      Result := False;
  end;
  Q.Free;
end;


function TFDashboardProductividad.IdentificadorSQLSeguro(const S: string): Boolean;
var
  I: Integer;
  C: Char;
begin
  Result := Trim(S) <> '';
  if not Result then Exit;

  for I := 1 to Length(S) do
  begin
    C := S[I];
    if not (C in ['A'..'Z', 'a'..'z', '0'..'9', '_']) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

function TFDashboardProductividad.SQLIdent(const S: string): string;
begin
  Result := '`' + StringReplace(S, '`', '``', [rfReplaceAll]) + '`';
end;

function TFDashboardProductividad.SQLSoloLectura(const ASQL: string): Boolean;
var
  T, U: string;
  I: Integer;
const
  PalabrasProhibidas: array[0..22] of string = (
    ' insert ', ' update ', ' delete ', ' drop ', ' alter ', ' create ',
    ' truncate ', ' replace ', ' grant ', ' revoke ', ' lock ', ' unlock ',
    ' load ', ' outfile', ' infile ', ' into outfile', ' call ', ' set ',
    ' optimize ', ' repair ', ' analyze ', ' handler ', ' do '
  );
begin
  T := Trim(ASQL);
  Result := False;
  if T = '' then Exit;

  // Permitimos un único ; final, pero no varias sentencias encadenadas.
  while (T <> '') and (T[Length(T)] = ';') do
    Delete(T, Length(T), 1);

  U := ' ' + LowerCase(T) + ' ';
  U := StringReplace(U, #13, ' ', [rfReplaceAll]);
  U := StringReplace(U, #10, ' ', [rfReplaceAll]);
  U := StringReplace(U, #9,  ' ', [rfReplaceAll]);

  if Pos(';', U) > 0 then Exit;

  if not ((Copy(Trim(U), 1, 6) = 'select') or
          (Copy(Trim(U), 1, 4) = 'show') or
          (Copy(Trim(U), 1, 8) = 'describe') or
          (Copy(Trim(U), 1, 4) = 'desc') or
          (Copy(Trim(U), 1, 7) = 'explain')) then
    Exit;

  for I := Low(PalabrasProhibidas) to High(PalabrasProhibidas) do
    if Pos(PalabrasProhibidas[I], U) > 0 then
      Exit;

  Result := True;
end;

procedure TFDashboardProductividad.CargarConsultaLibreTablas;
var
  TablaSel: string;
begin
  if (qLibreTablas = nil) or (cbLibreTabla = nil) then Exit;

  TablaSel := cbLibreTabla.Text;
  cbLibreTabla.Items.BeginUpdate;
  try
    cbLibreTabla.Items.Clear;
    qLibreTablas.Close;
    qLibreTablas.SQL.Text :=
      'SELECT table_name AS tabla ' +
      'FROM information_schema.tables ' +
      'WHERE table_schema = DATABASE() ' +
      '  AND table_type = ''BASE TABLE'' ' +
      'ORDER BY table_name';
    qLibreTablas.Open;

    while not qLibreTablas.EOF do
    begin
      cbLibreTabla.Items.Add(qLibreTablas.FieldByName('tabla').AsString);
      qLibreTablas.Next;
    end;
  finally
    cbLibreTabla.Items.EndUpdate;
  end;

  if (TablaSel <> '') and (cbLibreTabla.Items.IndexOf(TablaSel) >= 0) then
    cbLibreTabla.ItemIndex := cbLibreTabla.Items.IndexOf(TablaSel)
  else if cbLibreTabla.Items.Count > 0 then
  begin
    if cbLibreTabla.Items.IndexOf('hisopcc' + FTienda) >= 0 then
      cbLibreTabla.ItemIndex := cbLibreTabla.Items.IndexOf('hisopcc' + FTienda)
    else
      cbLibreTabla.ItemIndex := 0;
  end;

  CargarConsultaLibreCampos;
end;

procedure TFDashboardProductividad.CargarConsultaLibreCampos;
var
  T: string;
begin
  if (qLibreCampos = nil) or (lbLibreCampos = nil) or (cbLibreTabla = nil) then Exit;

  T := Trim(cbLibreTabla.Text);
  lbLibreCampos.Items.Clear;
  if not IdentificadorSQLSeguro(T) then Exit;

  qLibreCampos.Close;
  qLibreCampos.SQL.Text :=
    'SELECT column_name AS campo ' +
    'FROM information_schema.columns ' +
    'WHERE table_schema = DATABASE() AND table_name = :tabla ' +
    'ORDER BY ordinal_position';
  qLibreCampos.ParamByName('tabla').AsString := T;
  qLibreCampos.Open;

  while not qLibreCampos.EOF do
  begin
    lbLibreCampos.Items.Add(qLibreCampos.FieldByName('campo').AsString);
    qLibreCampos.Next;
  end;

  if memoLibreSQL <> nil then
    memoLibreSQL.Lines.Text := 'SELECT * FROM ' + SQLIdent(T) + ' LIMIT 100';
end;

procedure TFDashboardProductividad.ConsultaLibreTablaChange(Sender: TObject);
begin
  CargarConsultaLibreCampos;
end;

procedure TFDashboardProductividad.ConsultaLibreCargarTablasClick(Sender: TObject);
begin
  CargarConsultaLibreTablas;
end;

procedure TFDashboardProductividad.ConsultaLibreEjecutarSelectorClick(Sender: TObject);
var
  I: Integer;
  T, Campos, SQLText: string;
begin
  T := Trim(cbLibreTabla.Text);
  if not IdentificadorSQLSeguro(T) then
  begin
    ShowMessage('Selecciona una tabla válida.');
    Exit;
  end;

  Campos := '';
  for I := 0 to lbLibreCampos.Items.Count - 1 do
  begin
    if (lbLibreCampos.SelCount = 0) or lbLibreCampos.Selected[I] then
    begin
      if Campos <> '' then Campos := Campos + ', ';
      Campos := Campos + ConsultaLibreExpresionCampo(T, lbLibreCampos.Items[I]);
    end;
  end;

  if Campos = '' then
    Campos := '*';

  SQLText := 'SELECT ' + Campos + ' FROM ' + SQLIdent(T) + ' LIMIT 500';
  memoLibreSQL.Lines.Text := SQLText;

  qLibreResultado.Close;
  qLibreResultado.SQL.Text := SQLText;
  qLibreResultado.Open;
  ConsultaLibreAplicarTextoBlob;
  lblLibreInfo.Caption := 'Resultado de ' + T + ' - máximo 500 registros. Campos MEMO/BLOB convertidos a texto cuando es posible.';
  FLXAplicarFormatoDataSet(qLibreResultado);
  FLXAutoAjustarGrid(gridLibreResultado);
end;

procedure TFDashboardProductividad.ConsultaLibreCampoMemoGetText(Sender: TField; var AText: string; DisplayText: Boolean);
begin
  AText := '';
  if Sender = nil then Exit;
  try
    AText := Sender.AsString;
  except
    AText := '';
  end;
end;

procedure TFDashboardProductividad.ConsultaLibreAplicarTextoBlob;
var
  I: Integer;
  F: TField;
begin
  if (qLibreResultado = nil) or (not qLibreResultado.Active) then Exit;

  for I := 0 to qLibreResultado.FieldCount - 1 do
  begin
    F := qLibreResultado.Fields[I];
    if F = nil then Continue;

    // En consultas libres, algunos campos de texto largo llegan como MEMO/BLOB.
    // Asignamos OnGetText para que el DBGrid, CSV e informe HTML usen el texto real.
    if F.DataType in [ftMemo, ftBlob, ftFmtMemo] then
    begin
      F.OnGetText := @ConsultaLibreCampoMemoGetText;
      if F.DisplayWidth > 60 then
        F.DisplayWidth := 60;
    end;
  end;

  if gridLibreResultado <> nil then
    gridLibreResultado.Options := gridLibreResultado.Options + [dgDisplayMemoText];
end;

function TFDashboardProductividad.ConsultaLibreCampoEsTextoLargo(const ATabla, ACampo: string): Boolean;
var
  Q: TZQuery;
  Tipo: string;
begin
  Result := False;
  if (not IdentificadorSQLSeguro(ATabla)) or (not IdentificadorSQLSeguro(ACampo)) then Exit;

  Q := CrearQuery;
  try
    Q.SQL.Text :=
      'SELECT LOWER(data_type) AS tipo ' +
      'FROM information_schema.columns ' +
      'WHERE table_schema = DATABASE() AND table_name = :tabla AND column_name = :campo ' +
      'LIMIT 1';
    Q.ParamByName('tabla').AsString := ATabla;
    Q.ParamByName('campo').AsString := ACampo;
    Q.Open;
    if not Q.EOF then
    begin
      Tipo := LowerCase(Q.FieldByName('tipo').AsString);
      Result := (Pos('text', Tipo) > 0) or (Pos('blob', Tipo) > 0) or (Tipo = 'json');
    end;
  finally
    Q.Free;
  end;
end;

function TFDashboardProductividad.ConsultaLibreExpresionCampo(const ATabla, ACampo: string): string;
begin
  if ConsultaLibreCampoEsTextoLargo(ATabla, ACampo) then
    Result := 'CAST(' + SQLIdent(ACampo) + ' AS CHAR(1000)) AS ' + SQLIdent(ACampo)
  else
    Result := SQLIdent(ACampo);
end;

procedure TFDashboardProductividad.ConsultaLibreEjecutarSQLClick(Sender: TObject);
var
  SQLText, LowSQL: string;
begin
  SQLText := Trim(memoLibreSQL.Lines.Text);
  while (SQLText <> '') and (SQLText[Length(SQLText)] = ';') do
    Delete(SQLText, Length(SQLText), 1);

  if not SQLSoloLectura(SQLText) then
  begin
    ShowMessage('Por seguridad solo se permiten consultas de lectura: SELECT, SHOW, DESCRIBE o EXPLAIN. No se permiten INSERT, UPDATE, DELETE, DROP, ALTER, CREATE, etc.');
    Exit;
  end;

  LowSQL := LowerCase(' ' + SQLText + ' ');
  if (Copy(Trim(LowSQL), 1, 6) = 'select') and (Pos(' limit ', LowSQL) = 0) then
    SQLText := SQLText + ' LIMIT 1000';

  try
    qLibreResultado.Close;
    qLibreResultado.SQL.Text := SQLText;
    qLibreResultado.Open;
    ConsultaLibreAplicarTextoBlob;
    memoLibreSQL.Lines.Text := SQLText;
    lblLibreInfo.Caption := 'Consulta ejecutada. Si no indicabas LIMIT, se limita a 1000 registros. MEMO/BLOB visibles cuando el motor los entrega como texto.';
    FLXAplicarFormatoDataSet(qLibreResultado);
    FLXAutoAjustarGrid(gridLibreResultado);
  except
    on E: Exception do
    begin
      lblLibreInfo.Caption := 'Error ejecutando consulta.';
      ShowMessage('Error en la consulta:' + LineEnding + E.Message);
    end;
  end;
end;

function TFDashboardProductividad.DashboardCarpetaConfig: string;
begin
  Result := IncludeTrailingPathDelimiter(GetUserDir) + '.local' + DirectorySeparator +
            'share' + DirectorySeparator + 'facturlinex' + DirectorySeparator +
            'dashboard';
  try
    ForceDirectories(Result);
  except
    Result := ExtractFilePath(ParamStr(0));
  end;
end;

function TFDashboardProductividad.DashboardEstadoIni: string;
begin
  Result := IncludeTrailingPathDelimiter(DashboardCarpetaConfig) + 'dashboard_estado.ini';
end;

procedure TFDashboardProductividad.CargarEstadoVisual;
begin
  // Por rendimiento, al abrir Productividad NO recuperamos el ultimo periodo usado.
  // Si se quedo guardado un mes completo (por ejemplo agosto), la entrada al panel
  // puede ser muy lenta porque el Dashboard carga demasiadas consultas al iniciar.
  // El periodo inicial debe ser siempre el dia actual.
  SetEditFecha(dtDesde, SysUtils.Date);
  SetEditFecha(dtHasta, SysUtils.Date);

  // Tampoco recuperamos la ultima pestana usada: al abrir, Dashboard debe ser siempre
  // la pestana principal activa.
end;

procedure TFDashboardProductividad.GuardarEstadoVisual;
var
  INI: TIniFile;
begin
  INI := TIniFile.Create(DashboardEstadoIni);
  try
    INI.WriteString('Filtro', 'Desde', dtDesde.Text);
    INI.WriteString('Filtro', 'Hasta', dtHasta.Text);
    if (pcPrincipal <> nil) and (pcPrincipal.ActivePage <> nil) then
      INI.WriteString('Vista', 'Pestana', pcPrincipal.ActivePage.Caption);
  finally
    INI.Free;
  end;
end;

procedure TFDashboardProductividad.ConsultaLibreAbrirCarpetaSQLClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := ConsultaLibreCarpetaSQL;
  if not OpenDocument(Dir) then
    ShowMessage('Carpeta de consultas SQL:' + LineEnding + Dir);
end;

function TFDashboardProductividad.ConsultaLibreCarpetaSQL: string;
begin
  Result := IncludeTrailingPathDelimiter(GetUserDir) + '.local' + DirectorySeparator +
            'share' + DirectorySeparator + 'facturlinex' + DirectorySeparator +
            'dashboard_consultas';
  try
    ForceDirectories(Result);
  except
    // Si por cualquier motivo no se puede crear, dejamos el directorio del ejecutable como alternativa.
    Result := ExtractFilePath(ParamStr(0));
  end;
end;

procedure TFDashboardProductividad.ConsultaLibreGuardarSQLClick(Sender: TObject);
var
  SQLText, FN: string;
  D: TSaveDialog;
begin
  SQLText := Trim(memoLibreSQL.Lines.Text);
  while (SQLText <> '') and (SQLText[Length(SQLText)] = ';') do
    Delete(SQLText, Length(SQLText), 1);

  if not SQLSoloLectura(SQLText) then
  begin
    ShowMessage('No se puede guardar esta consulta porque no cumple las reglas de solo lectura.' + LineEnding +
                'Solo se permiten SELECT, SHOW, DESCRIBE/DESC o EXPLAIN.');
    Exit;
  end;

  D := TSaveDialog.Create(Self);
  try
    D.Title := 'Guardar consulta SQL';
    D.InitialDir := ConsultaLibreCarpetaSQL;
    D.Filter := 'Consultas SQL (*.sql)|*.sql|Todos los ficheros (*.*)|*.*';
    D.DefaultExt := 'sql';
    D.Options := D.Options + [ofOverwritePrompt, ofPathMustExist];
    D.FileName := 'consulta_dashboard.sql';

    if D.Execute then
    begin
      FN := D.FileName;
      if LowerCase(ExtractFileExt(FN)) <> '.sql' then
        FN := FN + '.sql';
      memoLibreSQL.Lines.SaveToFile(FN);
      lblLibreInfo.Caption := 'Consulta guardada: ' + ExtractFileName(FN);
    end;
  finally
    D.Free;
  end;
end;

procedure TFDashboardProductividad.ConsultaLibreAbrirSQLClick(Sender: TObject);
var
  SQLText: string;
  D: TOpenDialog;
  L: TStringList;
begin
  D := TOpenDialog.Create(Self);
  L := TStringList.Create;
  try
    D.Title := 'Abrir consulta SQL';
    D.InitialDir := ConsultaLibreCarpetaSQL;
    D.Filter := 'Consultas SQL (*.sql)|*.sql|Todos los ficheros (*.*)|*.*';
    D.Options := D.Options + [ofFileMustExist, ofPathMustExist];

    if not D.Execute then Exit;

    L.LoadFromFile(D.FileName);
    SQLText := Trim(L.Text);
    while (SQLText <> '') and (SQLText[Length(SQLText)] = ';') do
      Delete(SQLText, Length(SQLText), 1);

    if not SQLSoloLectura(SQLText) then
    begin
      ShowMessage('El fichero no se admite porque contiene una consulta no permitida.' + LineEnding +
                  'Solo se permiten SELECT, SHOW, DESCRIBE/DESC o EXPLAIN y una única sentencia.');
      Exit;
    end;

    memoLibreSQL.Lines.Text := SQLText;
    lblLibreInfo.Caption := 'Consulta cargada y validada: ' + ExtractFileName(D.FileName);
  finally
    L.Free;
    D.Free;
  end;
end;


function TFDashboardProductividad.FechaDesde: TDateTime;
begin
  if not ParseFecha(dtDesde.Text, Result) then
    Result := SysUtils.Date;
  Result := Trunc(Result);
end;

function TFDashboardProductividad.FechaHasta: TDateTime;
begin
  if not ParseFecha(dtHasta.Text, Result) then
    Result := SysUtils.Date;
  Result := Trunc(Result);
end;

function TFDashboardProductividad.ParseFecha(const S: string; out ADate: TDateTime): Boolean;
var
  T: string;
  FS: TFormatSettings;
  Y, M, D: Word;
  IY, IM, ID: Integer;
begin
  T := Trim(S);
  ADate := 0;
  Result := False;

  if T = '' then
    Exit;

  FS := DefaultFormatSettings;
  FS.DateSeparator := '/';
  FS.ShortDateFormat := 'dd/mm/yyyy';

  Result := TryStrToDate(T, ADate, FS);
  if Result then
    Exit;

  T := StringReplace(T, '-', '/', [rfReplaceAll]);
  Result := TryStrToDate(T, ADate, FS);
  if Result then
    Exit;

  // Acepta también yyyy-mm-dd / yyyy/mm/dd por si se copia desde SQL.
  T := Trim(S);
  if (Length(T) = 10) and (T[5] in ['-', '/']) and (T[8] in ['-', '/']) then
  begin
    if TryStrToInt(Copy(T, 1, 4), IY) and
       TryStrToInt(Copy(T, 6, 2), IM) and
       TryStrToInt(Copy(T, 9, 2), ID) then
    begin
      Y := IY;
      M := IM;
      D := ID;
      Result := TryEncodeDate(Y, M, D, ADate);
    end;
  end;
end;

function TFDashboardProductividad.FechasValidas(out ADesde, AHasta: TDateTime): Boolean;
begin
  Result := False;

  if not ParseFecha(dtDesde.Text, ADesde) then
  begin
    ShowMessage('Fecha DESDE no válida. Usa el formato dd/mm/aaaa.');
    dtDesde.SetFocus;
    Exit;
  end;

  if not ParseFecha(dtHasta.Text, AHasta) then
  begin
    ShowMessage('Fecha HASTA no válida. Usa el formato dd/mm/aaaa.');
    dtHasta.SetFocus;
    Exit;
  end;

  ADesde := Trunc(ADesde);
  AHasta := Trunc(AHasta);

  if ADesde > AHasta then
  begin
    ShowMessage('La fecha desde no puede ser posterior a la fecha hasta.');
    dtDesde.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TFDashboardProductividad.SetEditFecha(AEdit: TEdit; const AFecha: TDateTime);
begin
  if AEdit <> nil then
    AEdit.Text := FormatDateTime('dd/mm/yyyy', AFecha);
end;

function TFDashboardProductividad.ElegirFecha(var AFecha: TDateTime): Boolean;
var
  F: TFLXCalendarPicker;
begin
  Result := False;
  F := TFLXCalendarPicker.CreateCalendar(Self, AFecha);
  try
    if F.ShowModal = mrOk then
    begin
      AFecha := F.SelectedDate;
      Result := True;
    end;
  finally
    F.Free;
  end;
end;

procedure TFDashboardProductividad.AbrirCalendarioFecha(AEdit: TEdit);
var
  F: TDateTime;
begin
  if AEdit = nil then Exit;

  if not ParseFecha(AEdit.Text, F) then
    F := SysUtils.Date;

  if ElegirFecha(F) then
  begin
    SetEditFecha(AEdit, F);
    CargarDashboard;
  end;
end;

function TFDashboardProductividad.FechaSQL(const ADate: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd', ADate);
end;

function TFDashboardProductividad.Dinero(const V: Double): string;
begin
  Result := FormatFloat('#,##0.00', V) + ' €';
end;

function TFDashboardProductividad.Numero(const V: Double): string;
begin
  Result := FormatFloat('#,##0.##', V);
end;

function FLXContiene(const Texto, Patron: string): Boolean;
begin
  Result := Pos(Patron, Texto) > 0;
end;

function FLXEsCampoPorcentaje(const Campo: string): Boolean;
var
  N: string;
begin
  N := LowerCase(Campo);
  Result := FLXContiene(N, 'pct') or
            FLXContiene(N, 'porcentaje') or
            FLXContiene(N, 'porc') or
            FLXContiene(N, 'percent') or
            (N = 'dto') or FLXContiene(N, 'dto_') or FLXContiene(N, '_dto') or
            FLXContiene(N, 'variacion') or FLXContiene(N, 'variacion_pct') or
            FLXContiene(N, 'margen_pct') or FLXContiene(N, 'dif_ventas_pct') or
            FLXContiene(N, 'dif_caja_pct');
end;

function FLXEsCampoConteoONoImporte(const Campo: string): Boolean;
var
  N: string;
begin
  N := LowerCase(Campo);
  Result :=
    FLXContiene(N, 'codigo') or FLXContiene(N, 'cliente') or
    FLXContiene(N, 'proveedor') or FLXContiene(N, 'familia') or
    FLXContiene(N, 'pedido') or FLXContiene(N, 'linea') or
    FLXContiene(N, 'serie') or FLXContiene(N, 'numero') or
    FLXContiene(N, 'document') or FLXContiene(N, 'docs') or
    FLXContiene(N, 'ticket') and not FLXContiene(N, 'ticket_medio') or
    FLXContiene(N, 'tickets') or FLXContiene(N, 'registros') or
    FLXContiene(N, 'usuarios') or FLXContiene(N, 'articulos') or
    FLXContiene(N, 'pedidos') or FLXContiene(N, 'lineas') or
    FLXContiene(N, 'pendientes') or FLXContiene(N, 'cantidad') or
    FLXContiene(N, 'unidades') or FLXContiene(N, 'uds') or
    FLXContiene(N, 'stock') or FLXContiene(N, 'cobertura') or
    FLXContiene(N, 'dias') or FLXContiene(N, 'hora') or
    FLXContiene(N, 'mes') or FLXContiene(N, 'anyo') or
    FLXContiene(N, 'ventas_dia') or FLXContiene(N, 'venta_dia');
end;

function FLXEsCampoMoneda(const Campo: string): Boolean;
var
  N: string;
begin
  N := LowerCase(Campo);
  if FLXEsCampoPorcentaje(N) or FLXEsCampoConteoONoImporte(N) then
    Exit(False);

  Result :=
    FLXContiene(N, 'total') or FLXContiene(N, 'importe') or
    FLXContiene(N, 'base') or FLXContiene(N, 'iva') or
    FLXContiene(N, 'coste') or FLXContiene(N, 'precio') or
    FLXContiene(N, 'pvp') or FLXContiene(N, 'margen') or
    FLXContiene(N, 'ahorro') or FLXContiene(N, 'ticket_medio') or
    FLXContiene(N, 'valor_stock') or FLXContiene(N, 'coste_stock') or
    FLXContiene(N, 'cobros') or FLXContiene(N, 'cobro') or
    FLXContiene(N, 'entrega') or FLXContiene(N, 'cambio');
end;

procedure FLXAsignarFormatoNumerico(F: TField; const Formato: string);
begin
  if F is TFloatField then
    TFloatField(F).DisplayFormat := Formato
  else if F is TCurrencyField then
    TCurrencyField(F).DisplayFormat := Formato
  else if F is TBCDField then
    TBCDField(F).DisplayFormat := Formato
  else if F is TFMTBCDField then
    TFMTBCDField(F).DisplayFormat := Formato
  else if F is TIntegerField then
    TIntegerField(F).DisplayFormat := Formato;
end;

procedure FLXAplicarFormatoDataSet(DS: TDataSet);
var
  I: Integer;
  F: TField;
begin
  if (DS = nil) or (not DS.Active) then Exit;

  for I := 0 to DS.FieldCount - 1 do
  begin
    F := DS.Fields[I];
    if F = nil then Continue;

    if FLXEsCampoMoneda(F.FieldName) then
      FLXAsignarFormatoNumerico(F, '#,##0.00 €')
    else if FLXEsCampoPorcentaje(F.FieldName) then
      FLXAsignarFormatoNumerico(F, '#,##0.00 %')
    else if (F.DataType in [ftInteger, ftSmallint, ftWord, ftLargeint]) then
      FLXAsignarFormatoNumerico(F, '#,##0')
    else if (F.DataType in [ftFloat, ftCurrency, ftBCD, ftFMTBcd]) and
            (F.DisplayWidth > 12) then
      FLXAsignarFormatoNumerico(F, '#,##0.##');
  end;
end;

function FLXMaxAnchoPxParaCampo(F: TField): Integer;
var
  N: string;
begin
  N := LowerCase(F.FieldName);
  Result := 260;

  if FLXContiene(N, 'descripcion') or FLXContiene(N, 'detalle') or
     FLXContiene(N, 'motivo') or FLXContiene(N, 'respuesta') or
     FLXContiene(N, 'error') or FLXContiene(N, 'incidencia') then
    Result := 360
  else if FLXContiene(N, 'nombre') or FLXContiene(N, 'forma_pago') or
          FLXContiene(N, 'familia') or FLXContiene(N, 'proveedor') then
    Result := 230
  else if FLXEsCampoMoneda(N) then
    Result := 125
  else if FLXEsCampoPorcentaje(N) then
    Result := 95
  else if F.DataType in [ftDate, ftTime, ftDateTime] then
    Result := 110
  else if F.DataType in [ftInteger, ftSmallint, ftWord, ftLargeint, ftFloat, ftCurrency, ftBCD, ftFMTBcd] then
    Result := 105;
end;

procedure FLXAutoAjustarGrid(Grid: TDBGrid);
var
  DS: TDataSet;
  I, C, NReg, MaxPx, MinPx, LimitePx, W: Integer;
  F: TField;
  S: string;
begin
  if (Grid = nil) or (Grid.DataSource = nil) then Exit;
  DS := Grid.DataSource.DataSet;
  if (DS = nil) or (not DS.Active) then Exit;

  FLXAplicarFormatoDataSet(DS);

  Grid.Options := Grid.Options + [dgDisplayMemoText];

  if DS.IsEmpty then Exit;

  DS.DisableControls;
  try
    for I := 0 to DS.FieldCount - 1 do
    begin
      F := DS.Fields[I];
      if (F = nil) or (not F.Visible) then Continue;

      MaxPx := Grid.Canvas.TextWidth(F.DisplayLabel) + 22;
      NReg := 0;
      DS.First;
      while (not DS.EOF) and (NReg < 300) do
      begin
        S := F.DisplayText;
        if Length(S) > 80 then
          S := Copy(S, 1, 80);
        W := Grid.Canvas.TextWidth(S) + 22;
        if W > MaxPx then MaxPx := W;
        Inc(NReg);
        DS.Next;
      end;

      MinPx := 45;
      LimitePx := FLXMaxAnchoPxParaCampo(F);
      MaxPx := EnsureRange(MaxPx, MinPx, LimitePx);

      if Grid.Columns.Count > I then
        Grid.Columns[I].Width := MaxPx;

      // DisplayWidth se deja también ajustado por si el grid usa columnas automáticas.
      F.DisplayWidth := EnsureRange(MaxPx div Max(Grid.Canvas.TextWidth('0'), 7), 4, 45);
    end;

    DS.First;
  finally
    DS.EnableControls;
  end;
end;

function TFDashboardProductividad.CampoDouble(Q: TZQuery; const Campo: string): Double;
begin
  Result := 0;
  if (Q <> nil) and Q.Active and (not Q.IsEmpty) and (Q.FindField(Campo) <> nil) then
    Result := Q.FieldByName(Campo).AsFloat;
end;

function TFDashboardProductividad.CampoInteger(Q: TZQuery; const Campo: string): Integer;
begin
  Result := 0;
  if (Q <> nil) and Q.Active and (not Q.IsEmpty) and (Q.FindField(Campo) <> nil) then
    Result := Q.FieldByName(Campo).AsInteger;
end;

procedure TFDashboardProductividad.AjustarCampo(Q: TZQuery; const Campo, Titulo: string; Ancho: Integer);
var
  F: TField;
begin
  if Q = nil then Exit;
  F := Q.FindField(Campo);
  if F = nil then Exit;
  F.DisplayLabel := Titulo;
  if Ancho > 0 then
    F.DisplayWidth := Ancho;
end;

procedure TFDashboardProductividad.AjustarCampoMoneda(Q: TZQuery; const Campo, Titulo: string; Ancho: Integer);
var
  F: TField;
begin
  AjustarCampo(Q, Campo, Titulo, Ancho);
  F := Q.FindField(Campo);
  if F = nil then Exit;
  if F is TFloatField then
    TFloatField(F).DisplayFormat := '#,##0.00 €'
  else if F is TCurrencyField then
    TCurrencyField(F).DisplayFormat := '#,##0.00 €'
  else if F is TBCDField then
    TBCDField(F).DisplayFormat := '#,##0.00 €'
  else if F is TFMTBCDField then
    TFMTBCDField(F).DisplayFormat := '#,##0.00 €';
end;

procedure TFDashboardProductividad.AjustarCampoNumero(Q: TZQuery; const Campo, Titulo: string; Ancho: Integer; const Formato: string);
var
  F: TField;
begin
  AjustarCampo(Q, Campo, Titulo, Ancho);
  F := Q.FindField(Campo);
  if F = nil then Exit;
  if F is TFloatField then
    TFloatField(F).DisplayFormat := Formato
  else if F is TBCDField then
    TBCDField(F).DisplayFormat := Formato
  else if F is TFMTBCDField then
    TFMTBCDField(F).DisplayFormat := Formato;
end;

procedure TFDashboardProductividad.AplicarFormatoYAnchos;
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TZQuery then
      FLXAplicarFormatoDataSet(TZQuery(Components[I]));
  end;

  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TDBGrid then
      FLXAutoAjustarGrid(TDBGrid(Components[I]));
  end;
end;


function TFDashboardProductividad.TextoCSV(const S: string): string;
var
  R: string;
begin
  R := StringReplace(S, '"', '""', [rfReplaceAll]);
  if (Pos(';', R) > 0) or (Pos('"', S) > 0) or (Pos(#10, R) > 0) or (Pos(#13, R) > 0) then
    Result := '"' + R + '"'
  else
    Result := R;
end;


function TFDashboardProductividad.TextoHTML(const S: string): string;
begin
  Result := S;
  Result := StringReplace(Result, '&', '&amp;', [rfReplaceAll]);
  Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
  Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
  Result := StringReplace(Result, #13#10, '<br>', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '<br>', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '<br>', [rfReplaceAll]);
end;


function TFDashboardProductividad.TextoPDF(const S: string): AnsiString;
var
  W: WideString;
  I: Integer;
  C: Word;

  procedure AddByte(B: Byte);
  begin
    case B of
      40, 41, 92:
        Result := Result + '\' + AnsiChar(B);
      32..39, 42..91, 93..126:
        Result := Result + AnsiChar(B);
    else
      Result := Result + '\' + Format('%.3d', [B]);
    end;
  end;

begin
  Result := '(';
  W := UTF8Decode(S);
  for I := 1 to Length(W) do
  begin
    C := Ord(W[I]);
    case C of
      9, 10, 13:
        AddByte(32);
      8364: // Euro: lo dejamos como texto para evitar problemas de fuentes/encoding.
        begin
          AddByte(32);
          AddByte(69); AddByte(85); AddByte(82);
        end;
      0..8, 11..12, 14..255:
        AddByte(Byte(C));
    else
      AddByte(Ord('?'));
    end;
  end;
  Result := Result + ')';
end;

function TFDashboardProductividad.TextoPlanoPDF(const S: string): string;
begin
  Result := Trim(S);
  Result := StringReplace(Result, #13#10, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #10, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #13, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #9, ' ', [rfReplaceAll]);
  while Pos('  ', Result) > 0 do
    Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
end;

function TFDashboardProductividad.TituloGridPDF(Grid: TDBGrid): string;
var
  C: TControl;
begin
  Result := 'Listado';
  if Grid = nil then
    Exit;

  C := Grid.Parent;
  while C <> nil do
  begin
    if C is TGroupBox then
    begin
      Result := TGroupBox(C).Caption;
      Exit;
    end;
    C := C.Parent;
  end;
end;

procedure TFDashboardProductividad.RecogerGridsPDF(AControl: TWinControl; AList: TList);
var
  I: Integer;
begin
  if (AControl = nil) or (AList = nil) then
    Exit;

  for I := 0 to AControl.ControlCount - 1 do
  begin
    if AControl.Controls[I] is TDBGrid then
      AList.Add(AControl.Controls[I]);

    if AControl.Controls[I] is TWinControl then
      RecogerGridsPDF(TWinControl(AControl.Controls[I]), AList);
  end;
end;

procedure TFDashboardProductividad.AnyadirDataSetPDF(L: TStringList; const Titulo: string; DS: TDataSet);
var
  I: Integer;
  Widths: array of Integer;

  function Recortar(const S: string; W: Integer): string;
  begin
    Result := TextoPlanoPDF(S);
    if Length(Result) > W then
    begin
      if W > 1 then
        Result := Copy(Result, 1, W - 1) + '~'
      else
        Result := Copy(Result, 1, W);
    end;
  end;

  function PadR(const S: string; W: Integer): string;
  begin
    Result := Recortar(S, W);
    while Length(Result) < W do
      Result := Result + ' ';
  end;

  function LineaCampos(EsCabecera: Boolean): string;
  var
    J: Integer;
    S: string;
  begin
    Result := '';
    for J := 0 to DS.FieldCount - 1 do
    begin
      if J > 0 then
        Result := Result + ' | ';
      if EsCabecera then
        S := DS.Fields[J].DisplayLabel
      else
        S := DS.Fields[J].DisplayText;
      Result := Result + PadR(S, Widths[J]);
    end;
  end;

begin
  L.Add('');
  L.Add('[' + Titulo + ']');

  if (DS = nil) or (not DS.Active) then
  begin
    L.Add('Sin datos disponibles.');
    Exit;
  end;

  if DS.FieldCount = 0 then
  begin
    L.Add('Sin columnas.');
    Exit;
  end;

  SetLength(Widths, DS.FieldCount);
  for I := 0 to DS.FieldCount - 1 do
  begin
    Widths[I] := Length(TextoPlanoPDF(DS.Fields[I].DisplayLabel));
    if Widths[I] < 8 then
      Widths[I] := 8;
    if Pos('DESCRIP', UpperCase(DS.Fields[I].FieldName)) > 0 then
    begin
      if Widths[I] < 30 then
        Widths[I] := 30;
      if Widths[I] > 42 then
        Widths[I] := 42;
    end
    else if Pos('OBSERV', UpperCase(DS.Fields[I].FieldName)) > 0 then
    begin
      if Widths[I] < 26 then
        Widths[I] := 26;
      if Widths[I] > 36 then
        Widths[I] := 36;
    end
    else if Widths[I] > 18 then
      Widths[I] := 18;
  end;

  DS.DisableControls;
  try
    DS.First;
    if DS.EOF then
    begin
      L.Add('Sin registros.');
      Exit;
    end;

    L.Add(LineaCampos(True));
    L.Add(StringOfChar('-', Length(L[L.Count - 1])));

    while not DS.EOF do
    begin
      L.Add(LineaCampos(False));
      DS.Next;
    end;
    DS.First;
  finally
    DS.EnableControls;
  end;
end;

procedure TFDashboardProductividad.GuardarLineasPDF(L: TStringList; const AFichero: string);
const
  PageW = 842;
  PageH = 595;
  MarginL = 30;
  StartY = 560;
  LineStep = 10;
  LinesPerPage = 53;
var
  FS: TFileStream;
  Offsets: array of Int64;
  PageCount: Integer;
  FontObj: Integer;
  I, P, ObjNum, LineIndex, StartLine, EndLine: Integer;
  StartXRef: Int64;
  Kids, StreamData, S: AnsiString;

  procedure WriteA(const A: AnsiString);
  begin
    if Length(A) > 0 then
      FS.WriteBuffer(A[1], Length(A));
  end;

  procedure StartObj(Num: Integer);
  begin
    Offsets[Num] := FS.Position;
    WriteA(AnsiString(IntToStr(Num) + ' 0 obj' + #10));
  end;

  procedure EndObj;
  begin
    WriteA('endobj' + #10);
  end;

begin
  if L = nil then
    Exit;

  PageCount := (L.Count + LinesPerPage - 1) div LinesPerPage;
  if PageCount < 1 then
    PageCount := 1;

  FontObj := 3 + (PageCount * 2);
  SetLength(Offsets, FontObj + 1);

  FS := TFileStream.Create(AFichero, fmCreate);
  try
    WriteA('%PDF-1.4' + #10);
    WriteA('% Dashboard FacturLinEx' + #10);

    StartObj(1);
    WriteA('<< /Type /Catalog /Pages 2 0 R >>' + #10);
    EndObj;

    Kids := '';
    for P := 0 to PageCount - 1 do
      Kids := Kids + AnsiString(IntToStr(3 + (P * 2)) + ' 0 R ');

    StartObj(2);
    WriteA('<< /Type /Pages /Kids [' + Kids + '] /Count ' + AnsiString(IntToStr(PageCount)) + ' >>' + #10);
    EndObj;

    for P := 0 to PageCount - 1 do
    begin
      ObjNum := 3 + (P * 2);
      StartObj(ObjNum);
      WriteA('<< /Type /Page /Parent 2 0 R /MediaBox [0 0 ' +
             AnsiString(IntToStr(PageW)) + ' ' + AnsiString(IntToStr(PageH)) +
             '] /Resources << /Font << /F1 ' + AnsiString(IntToStr(FontObj)) +
             ' 0 R >> >> /Contents ' + AnsiString(IntToStr(ObjNum + 1)) + ' 0 R >>' + #10);
      EndObj;

      StartLine := P * LinesPerPage;
      EndLine := StartLine + LinesPerPage - 1;
      if EndLine >= L.Count then
        EndLine := L.Count - 1;

      StreamData := 'BT' + #10 + '/F1 8 Tf' + #10 +
                    AnsiString(IntToStr(MarginL) + ' ' + IntToStr(StartY) + ' Td' + #10);
      for LineIndex := StartLine to EndLine do
        StreamData := StreamData + TextoPDF(L[LineIndex]) + ' Tj' + #10 + '0 -' + AnsiString(IntToStr(LineStep)) + ' Td' + #10;
      StreamData := StreamData + 'ET' + #10;

      StartObj(ObjNum + 1);
      WriteA('<< /Length ' + AnsiString(IntToStr(Length(StreamData))) + ' >>' + #10 + 'stream' + #10);
      WriteA(StreamData);
      WriteA('endstream' + #10);
      EndObj;
    end;

    StartObj(FontObj);
    WriteA('<< /Type /Font /Subtype /Type1 /BaseFont /Courier /Encoding /WinAnsiEncoding >>' + #10);
    EndObj;

    StartXRef := FS.Position;
    WriteA('xref' + #10);
    WriteA('0 ' + AnsiString(IntToStr(FontObj + 1)) + #10);
    WriteA('0000000000 65535 f ' + #10);
    for P := 1 to FontObj do
    begin
      S := AnsiString(Format('%.10d 00000 n ', [Offsets[P]]));
      WriteA(S + #10);
    end;
    WriteA('trailer' + #10);
    WriteA('<< /Size ' + AnsiString(IntToStr(FontObj + 1)) + ' /Root 1 0 R >>' + #10);
    WriteA('startxref' + #10);
    WriteA(AnsiString(IntToStr(StartXRef)) + #10);
    WriteA('%%EOF' + #10);
  finally
    FS.Free;
  end;
end;

procedure TFDashboardProductividad.ExportarPestanaPDF(const AFichero: string);
var
  L: TStringList;
  Grids: TList;
  I: Integer;
  G: TDBGrid;
  DS: TDataSet;
begin
  L := TStringList.Create;
  Grids := TList.Create;
  try
    L.Add('FacturLinEx - Productividad / Dashboard');
    L.Add('Pestana: ' + pcPrincipal.ActivePage.Caption);
    L.Add('Desde: ' + dtDesde.Text + '   Hasta: ' + dtHasta.Text);
    L.Add('Generado: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));

    RecogerGridsPDF(pcPrincipal.ActivePage, Grids);
    if Grids.Count = 0 then
      L.Add('La pestana activa no contiene rejillas exportables a PDF directo.');

    for I := 0 to Grids.Count - 1 do
    begin
      G := TDBGrid(Grids[I]);
      DS := nil;
      if (G.DataSource <> nil) and (G.DataSource.DataSet <> nil) then
        DS := G.DataSource.DataSet;
      AnyadirDataSetPDF(L, TituloGridPDF(G), DS);
    end;

    GuardarLineasPDF(L, AFichero);
  finally
    Grids.Free;
    L.Free;
  end;
end;

function TFDashboardProductividad.NombreFicheroSeguro(const S: string): string;
var
  I: Integer;
  C: Char;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    C := S[I];
    if C in ['A'..'Z', 'a'..'z', '0'..'9', '_', '-'] then
      Result := Result + C
    else if C = ' ' then
      Result := Result + '_';
  end;
  if Result = '' then
    Result := 'dashboard';
end;

procedure TFDashboardProductividad.AnyadirDataSetCSV(L: TStringList; const Titulo: string; DS: TDataSet);
var
  I: Integer;
  Linea: string;
begin
  L.Add('');
  L.Add(TextoCSV(Titulo));

  if (DS = nil) or (not DS.Active) then
  begin
    L.Add(TextoCSV('Sin datos disponibles'));
    Exit;
  end;

  if DS.FieldCount = 0 then
  begin
    L.Add(TextoCSV('Sin columnas'));
    Exit;
  end;

  Linea := '';
  for I := 0 to DS.FieldCount - 1 do
  begin
    if I > 0 then
      Linea := Linea + ';';
    Linea := Linea + TextoCSV(DS.Fields[I].DisplayLabel);
  end;
  L.Add(Linea);

  DS.DisableControls;
  try
    DS.First;
    if DS.EOF then
      L.Add(TextoCSV('Sin registros'));

    while not DS.EOF do
    begin
      Linea := '';
      for I := 0 to DS.FieldCount - 1 do
      begin
        if I > 0 then
          Linea := Linea + ';';
        Linea := Linea + TextoCSV(DS.Fields[I].DisplayText);
      end;
      L.Add(Linea);
      DS.Next;
    end;
    DS.First;
  finally
    DS.EnableControls;
  end;
end;


procedure TFDashboardProductividad.AnyadirDataSetHTML(L: TStringList; const Titulo: string; DS: TDataSet);
var
  I: Integer;
begin
  L.Add('<h2>' + TextoHTML(Titulo) + '</h2>');

  if (DS = nil) or (not DS.Active) then
  begin
    L.Add('<p><em>Sin datos disponibles.</em></p>');
    Exit;
  end;

  if DS.FieldCount = 0 then
  begin
    L.Add('<p><em>Sin columnas.</em></p>');
    Exit;
  end;

  L.Add('<table>');
  L.Add('<thead><tr>');
  for I := 0 to DS.FieldCount - 1 do
    L.Add('<th>' + TextoHTML(DS.Fields[I].DisplayLabel) + '</th>');
  L.Add('</tr></thead>');
  L.Add('<tbody>');

  DS.DisableControls;
  try
    DS.First;
    if DS.EOF then
      L.Add('<tr><td colspan="' + IntToStr(DS.FieldCount) + '"><em>Sin registros.</em></td></tr>');

    while not DS.EOF do
    begin
      L.Add('<tr>');
      for I := 0 to DS.FieldCount - 1 do
        L.Add('<td>' + TextoHTML(DS.Fields[I].DisplayText) + '</td>');
      L.Add('</tr>');
      DS.Next;
    end;
    DS.First;
  finally
    DS.EnableControls;
  end;

  L.Add('</tbody>');
  L.Add('</table>');
end;

procedure TFDashboardProductividad.ExportarPestanaCSV(const AFichero: string);
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Add(TextoCSV('FacturLinEx - Productividad / Dashboard'));
    L.Add(TextoCSV('Pestaña') + ';' + TextoCSV(pcPrincipal.ActivePage.Caption));
    L.Add(TextoCSV('Desde') + ';' + TextoCSV(dtDesde.Text));
    L.Add(TextoCSV('Hasta') + ';' + TextoCSV(dtHasta.Text));
    L.Add(TextoCSV('Generado') + ';' + TextoCSV(FormatDateTime('dd/mm/yyyy hh:nn:ss', Now)));

    if pcPrincipal.ActivePage = tsDashboard then
    begin
      AnyadirDataSetCSV(L, 'Dashboard - Formas de pago', qPagos);
      AnyadirDataSetCSV(L, 'Dashboard - Top artículos', qTopArticulos);
      AnyadirDataSetCSV(L, 'Dashboard - Top familias', qTopFamilias);
      AnyadirDataSetCSV(L, 'Dashboard - Ventas entre horas', qHoras);
    end
    else if pcPrincipal.ActivePage = tsHoy then
    begin
      AnyadirDataSetCSV(L, 'Hoy - Resumen actual', qHoyResumen);
      AnyadirDataSetCSV(L, 'Hoy - Tickets e importes por hora', qHoyHoras);
      AnyadirDataSetCSV(L, 'Hoy - Formas de pago', qHoyPagos);
    end
    else if pcPrincipal.ActivePage = tsCuadroGestion then
    begin
      AnyadirDataSetCSV(L, 'Cuadro gestion - Resumen comparativo', qCGResumen);
      AnyadirDataSetCSV(L, 'Cuadro gestion - Cifra por negocio', qCGNegocio);
      AnyadirDataSetCSV(L, 'Cuadro gestion - Frecuencia por hora', qCGHoras);
      AnyadirDataSetCSV(L, 'Cuadro gestion - Margen por negocio', qCGMargen);
      AnyadirDataSetCSV(L, 'Cuadro gestion - Empleados', qCGEmpleados);
    end
    else if pcPrincipal.ActivePage = tsVentasAbiertas then
    begin
      AnyadirDataSetCSV(L, 'Ventas abiertas - Resumen por caja', qVNAResumen);
      AnyadirDataSetCSV(L, 'Ventas abiertas - Tickets abiertos', qVNATickets);
      AnyadirDataSetCSV(L, 'Ventas abiertas - Detalle de lineas', qVNADetalle);
      AnyadirDataSetCSV(L, 'Ventas abiertas - Lineas por hora y caja', qVNAHoras);
      AnyadirDataSetCSV(L, 'Ventas abiertas - Revision video-vigilancia', qVNARevision);
    end
    else if pcPrincipal.ActivePage = tsCierreTarde then
    begin
      AnyadirDataSetCSV(L, 'Cierre tardes - Resumen', qCTResumen);
      AnyadirDataSetCSV(L, 'Cierre tardes - Top 15 candidatos', qCTCandidatos);
      AnyadirDataSetCSV(L, 'Cierre tardes - Dia a dia', qCTDias);
      AnyadirDataSetCSV(L, 'Cierre tardes - Dia de la semana', qCTSemana);
      AnyadirDataSetCSV(L, 'Cierre tardes - Horas de tarde', qCTHoras);
    end
    else if pcPrincipal.ActivePage = tsDiagnostico then
    begin
      AnyadirDataSetCSV(L, 'Diagnostico - Resumen inteligente', qDiagResumen);
      AnyadirDataSetCSV(L, 'Diagnostico - Margen negativo / bajo', qDiagMargen);
      AnyadirDataSetCSV(L, 'Diagnostico - Lectura de horas', qDiagHoras);
      AnyadirDataSetCSV(L, 'Diagnostico - Ventas y margen por proveedor', qDiagProveedor);
    end
    else if pcPrincipal.ActivePage = tsAlertas then
      AnyadirDataSetCSV(L, 'Alertas - ' + lblAlertaTitulo.Caption, qAlertas)
    else if pcPrincipal.ActivePage = tsEstudios then
    begin
      AnyadirDataSetCSV(L, 'Estudios - Ventas por día', qEstVentasDia);
      AnyadirDataSetCSV(L, 'Estudios - Ventas por hora', qEstVentasHora);
      AnyadirDataSetCSV(L, 'Estudios - Ventas por familia', qEstFamilias);
      AnyadirDataSetCSV(L, 'Estudios - Ventas por proveedor estimado', qEstProveedores);
      AnyadirDataSetCSV(L, 'Estudios - Top artículos por margen estimado', qEstMargen);
      AnyadirDataSetCSV(L, 'Estudios - Coste 0 / margen negativo vendido', qEstProblemas);
    end
    else if pcPrincipal.ActivePage = tsComparativa then
    begin
      AnyadirDataSetCSV(L, 'Comparativa - Resumen comparativo', qCompResumen);
      AnyadirDataSetCSV(L, 'Comparativa - Días rango actual', qCompDiaActual);
      AnyadirDataSetCSV(L, 'Comparativa - Días periodo anterior', qCompDiaAnterior);
      AnyadirDataSetCSV(L, 'Comparativa - Familias con variación', qCompFamilias);
      AnyadirDataSetCSV(L, 'Comparativa - Artículos con variación', qCompArticulos);
      AnyadirDataSetCSV(L, 'Comparativa - Formas de pago con variación', qCompPagos);
    end
    else if pcPrincipal.ActivePage = tsTendencias then
    begin
      AnyadirDataSetCSV(L, 'Tendencias - Resumen tendencias', qTendResumen);
      AnyadirDataSetCSV(L, 'Tendencias - Últimos 12 meses', qTendMeses);
      AnyadirDataSetCSV(L, 'Tendencias - Año actual vs anterior', qTendAnual);
      AnyadirDataSetCSV(L, 'Tendencias - Día de la semana', qTendSemana);
      AnyadirDataSetCSV(L, 'Tendencias - Artículos al alza', qTendAlza);
      AnyadirDataSetCSV(L, 'Tendencias - Artículos a la baja', qTendBaja);
    end
    else if pcPrincipal.ActivePage = tsClientes then
    begin
      AnyadirDataSetCSV(L, 'Clientes - Resumen clientes', qCliResumen);
      AnyadirDataSetCSV(L, 'Clientes - Top clientes por importe', qCliTopImporte);
      AnyadirDataSetCSV(L, 'Clientes - Top clientes por frecuencia', qCliTopFrecuencia);
      AnyadirDataSetCSV(L, 'Clientes - Clientes por ticket medio', qCliTicketMedio);
      AnyadirDataSetCSV(L, 'Clientes - Ventas sin cliente asignado', qCliSinCliente);
      AnyadirDataSetCSV(L, 'Clientes - Clientes vendidos con datos incompletos', qCliDatosIncompletos);
    end
    else if pcPrincipal.ActivePage = tsPuestos then
    begin
      AnyadirDataSetCSV(L, 'Puestos - Resumen usuarios / puestos', qPueResumen);
      AnyadirDataSetCSV(L, 'Puestos - Ventas por usuario', qPueUsuarios);
      AnyadirDataSetCSV(L, 'Puestos - Ventas por caja / puesto', qPueCajas);
      AnyadirDataSetCSV(L, 'Puestos - Frecuencia por usuario / hora', qPueHorasUsuario);
      AnyadirDataSetCSV(L, 'Puestos - Formas de pago por caja', qPuePagosCaja);
      AnyadirDataSetCSV(L, 'Puestos - Operaciones a revisar', qPueRevision);
    end
    else if pcPrincipal.ActivePage = tsCompras then
    begin
      AnyadirDataSetCSV(L, 'Compras - Resumen compras / pedidos', qComResumen);
      AnyadirDataSetCSV(L, 'Compras - Pedidos en curso / pendientes', qComPendientes);
      AnyadirDataSetCSV(L, 'Compras - Líneas pendientes de recibir', qComDetallePend);
      AnyadirDataSetCSV(L, 'Compras - Compras / pedidos por proveedor', qComProveedor);
      AnyadirDataSetCSV(L, 'Compras - Artículos más pedidos', qComArticulos);
      AnyadirDataSetCSV(L, 'Compras - Revisión de compras', qComRevision);
    end
    else if pcPrincipal.ActivePage = tsPromociones then
    begin
      AnyadirDataSetCSV(L, 'Promociones - Resumen promociones / descuentos', qPromoResumen);
      AnyadirDataSetCSV(L, 'Promociones - Líneas vendidas con descuento', qPromoDescuentos);
      AnyadirDataSetCSV(L, 'Promociones - Artículos con más descuento', qPromoArticulos);
      AnyadirDataSetCSV(L, 'Promociones - Promociones / descuentos por familia', qPromoFamilias);
      AnyadirDataSetCSV(L, 'Promociones - Posibles ventas bajo coste', qPromoBajoCoste);
      AnyadirDataSetCSV(L, 'Promociones - Revisión de descuentos', qPromoRevision);
    end
    else if pcPrincipal.ActivePage = tsRentabilidad then
    begin
      AnyadirDataSetCSV(L, 'Rentabilidad - Resumen rentabilidad', qRentResumen);
      AnyadirDataSetCSV(L, 'Rentabilidad - Top margen por artículo', qRentArticulos);
      AnyadirDataSetCSV(L, 'Rentabilidad - Margen por familia', qRentFamilias);
      AnyadirDataSetCSV(L, 'Rentabilidad - Margen por proveedor estimado', qRentProveedores);
      AnyadirDataSetCSV(L, 'Rentabilidad - Rentabilidad por día', qRentDias);
      AnyadirDataSetCSV(L, 'Rentabilidad - Revisión margen / coste', qRentRevision);
    end
    else if pcPrincipal.ActivePage = tsRotacion then
    begin
      AnyadirDataSetCSV(L, 'Rotación - Resumen rotación / stock', qRotResumen);
      AnyadirDataSetCSV(L, 'Rotación - Alta rotación', qRotAlta);
      AnyadirDataSetCSV(L, 'Rotación - Riesgo de rotura / cobertura baja', qRotRiesgo);
      AnyadirDataSetCSV(L, 'Rotación - Baja rotación con stock', qRotBaja);
      AnyadirDataSetCSV(L, 'Rotación - Exceso de stock / cobertura alta', qRotExceso);
      AnyadirDataSetCSV(L, 'Rotación - Stock sin ventas en el rango', qRotSinVentas);
    end
    else if pcPrincipal.ActivePage = tsReposicion then
    begin
      AnyadirDataSetCSV(L, 'Reposición - Resumen reposición', qRepResumen);
      AnyadirDataSetCSV(L, 'Reposición - Pedido sugerido orientativo', qRepSugerido);
      AnyadirDataSetCSV(L, 'Reposición - Urgente: stock 0 vendido', qRepUrgente);
      AnyadirDataSetCSV(L, 'Reposición - Necesidad por proveedor', qRepProveedor);
      AnyadirDataSetCSV(L, 'Reposición - Vendidos sin proveedor asignado', qRepSinProveedor);
      AnyadirDataSetCSV(L, 'Reposición - Stock con baja rotación', qRepBajaRotacion);
    end
    else if pcPrincipal.ActivePage = tsPicking then
    begin
      AnyadirDataSetCSV(L, 'Preparación - Resumen preparación', qPickResumen);
      AnyadirDataSetCSV(L, 'Preparación - Ruta de preparación / picking sugerido', qPickRuta);
      AnyadirDataSetCSV(L, 'Preparación - Preparación por proveedor', qPickProveedor);
      AnyadirDataSetCSV(L, 'Preparación - Preparación por ubicación / familia', qPickUbicacion);
      AnyadirDataSetCSV(L, 'Preparación - Artículos a preparar sin ubicación', qPickSinUbicacion);
      AnyadirDataSetCSV(L, 'Preparación - Revisión antes de preparar', qPickRevision);
    end
    else if pcPrincipal.ActivePage = tsCalidad then
    begin
      AnyadirDataSetCSV(L, 'Calidad datos - Resumen calidad de datos', qCalResumen);
      AnyadirDataSetCSV(L, 'Calidad datos - Artículos incompletos', qCalIncompletos);
      AnyadirDataSetCSV(L, 'Calidad datos - Precios / márgenes sospechosos', qCalPrecios);
      AnyadirDataSetCSV(L, 'Calidad datos - Stock sospechoso', qCalStock);
      AnyadirDataSetCSV(L, 'Calidad datos - Posibles duplicados por descripción', qCalDuplicados);
      AnyadirDataSetCSV(L, 'Calidad datos - Stock sin movimiento +365 días', qCalSinMovimiento);
    end
    else if pcPrincipal.ActivePage = tsVeriFactu then
    begin
      AnyadirDataSetCSV(L, 'VeriFactu - Resumen VeriFactu', qVFResumen);
      AnyadirDataSetCSV(L, 'VeriFactu - Pendientes / en cola', qVFPendientes);
      AnyadirDataSetCSV(L, 'VeriFactu - Aceptados con errores', qVFAceptadosErrores);
      AnyadirDataSetCSV(L, 'VeriFactu - Últimos errores', qVFErrores);
      AnyadirDataSetCSV(L, 'VeriFactu - Series / cadena hash', qVFSeries);
      AnyadirDataSetCSV(L, 'VeriFactu - Últimos registros', qVFUltimos);
    end
    else if pcPrincipal.ActivePage = tsComparativaAvanzada then
    begin
      AnyadirDataSetCSV(L, 'Comparativa fechas - Resumen', qCmpAvResumen);
      AnyadirDataSetCSV(L, 'Comparativa fechas - Día seleccionado', qCmpAvDia);
      AnyadirDataSetCSV(L, 'Comparativa fechas - Mes seleccionado', qCmpAvMes);
      AnyadirDataSetCSV(L, 'Comparativa fechas - Periodo seleccionado', qCmpAvPeriodo);
    end
    else if pcPrincipal.ActivePage = tsConsultaLibre then
      AnyadirDataSetCSV(L, 'Consulta libre - Resultado', qLibreResultado);

    L.SaveToFile(AFichero);
  finally
    L.Free;
  end;
end;


procedure TFDashboardProductividad.ExportarPestanaHTML(const AFichero: string);
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Add('<!DOCTYPE html>');
    L.Add('<html>');
    L.Add('<head>');
    L.Add('<meta charset="utf-8">');
    L.Add('<title>FacturLinEx - Productividad</title>');
    L.Add('<style>');
    L.Add('body{font-family:Arial,Helvetica,sans-serif;margin:18px;color:#222;}');
    L.Add('h1{font-size:20px;margin:0 0 6px 0;}');
    L.Add('h2{font-size:15px;margin:22px 0 8px 0;border-bottom:1px solid #ccc;padding-bottom:3px;}');
    L.Add('.meta{font-size:12px;color:#555;margin-bottom:12px;}');
    L.Add('table{border-collapse:collapse;width:100%;font-size:11px;margin-bottom:12px;}');
    L.Add('th,td{border:1px solid #ccc;padding:4px 6px;vertical-align:top;}');
    L.Add('th{background:#eee;text-align:left;}');
    L.Add('tr:nth-child(even){background:#fafafa;}');
    L.Add('@media print{body{margin:8mm;} button{display:none;} table{font-size:9px;} h2{page-break-after:avoid;}}');
    L.Add('</style>');
    L.Add('</head>');
    L.Add('<body>');
    L.Add('<h1>FacturLinEx - Productividad / Dashboard</h1>');
    L.Add('<div class="meta">');
    L.Add('Pestaña: <strong>' + TextoHTML(pcPrincipal.ActivePage.Caption) + '</strong><br>');
    L.Add('Desde: ' + TextoHTML(dtDesde.Text) + ' &nbsp;&nbsp; Hasta: ' + TextoHTML(dtHasta.Text) + '<br>');
    L.Add('Generado: ' + TextoHTML(FormatDateTime('dd/mm/yyyy hh:nn:ss', Now)));
    L.Add('</div>');

    if pcPrincipal.ActivePage = tsDashboard then
    begin
      AnyadirDataSetHTML(L, 'Dashboard - Formas de pago', qPagos);
      AnyadirDataSetHTML(L, 'Dashboard - Top artículos', qTopArticulos);
      AnyadirDataSetHTML(L, 'Dashboard - Top familias', qTopFamilias);
      AnyadirDataSetHTML(L, 'Dashboard - Ventas entre horas', qHoras);
    end
    else if pcPrincipal.ActivePage = tsHoy then
    begin
      AnyadirDataSetHTML(L, 'Hoy - Resumen actual', qHoyResumen);
      AnyadirDataSetHTML(L, 'Hoy - Tickets e importes por hora', qHoyHoras);
      AnyadirDataSetHTML(L, 'Hoy - Formas de pago', qHoyPagos);
    end
    else if pcPrincipal.ActivePage = tsCuadroGestion then
    begin
      AnyadirDataSetHTML(L, 'Cuadro gestion - Resumen comparativo', qCGResumen);
      AnyadirDataSetHTML(L, 'Cuadro gestion - Cifra por negocio', qCGNegocio);
      AnyadirDataSetHTML(L, 'Cuadro gestion - Frecuencia por hora', qCGHoras);
      AnyadirDataSetHTML(L, 'Cuadro gestion - Margen por negocio', qCGMargen);
      AnyadirDataSetHTML(L, 'Cuadro gestion - Empleados', qCGEmpleados);
    end
    else if pcPrincipal.ActivePage = tsVentasAbiertas then
    begin
      AnyadirDataSetHTML(L, 'Ventas abiertas - Resumen por caja', qVNAResumen);
      AnyadirDataSetHTML(L, 'Ventas abiertas - Tickets abiertos', qVNATickets);
      AnyadirDataSetHTML(L, 'Ventas abiertas - Detalle de lineas', qVNADetalle);
      AnyadirDataSetHTML(L, 'Ventas abiertas - Lineas por hora y caja', qVNAHoras);
      AnyadirDataSetHTML(L, 'Ventas abiertas - Revision video-vigilancia', qVNARevision);
    end
    else if pcPrincipal.ActivePage = tsCierreTarde then
    begin
      AnyadirDataSetHTML(L, 'Cierre tardes - Resumen', qCTResumen);
      AnyadirDataSetHTML(L, 'Cierre tardes - Top 15 candidatos', qCTCandidatos);
      AnyadirDataSetHTML(L, 'Cierre tardes - Dia a dia', qCTDias);
      AnyadirDataSetHTML(L, 'Cierre tardes - Dia de la semana', qCTSemana);
      AnyadirDataSetHTML(L, 'Cierre tardes - Horas de tarde', qCTHoras);
    end
    else if pcPrincipal.ActivePage = tsDiagnostico then
    begin
      AnyadirDataSetHTML(L, 'Diagnostico - Resumen inteligente', qDiagResumen);
      AnyadirDataSetHTML(L, 'Diagnostico - Margen negativo / bajo', qDiagMargen);
      AnyadirDataSetHTML(L, 'Diagnostico - Lectura de horas', qDiagHoras);
      AnyadirDataSetHTML(L, 'Diagnostico - Ventas y margen por proveedor', qDiagProveedor);
    end
    else if pcPrincipal.ActivePage = tsAlertas then
      AnyadirDataSetHTML(L, 'Alertas - ' + lblAlertaTitulo.Caption, qAlertas)
    else if pcPrincipal.ActivePage = tsEstudios then
    begin
      AnyadirDataSetHTML(L, 'Estudios - Ventas por día', qEstVentasDia);
      AnyadirDataSetHTML(L, 'Estudios - Ventas por hora', qEstVentasHora);
      AnyadirDataSetHTML(L, 'Estudios - Ventas por familia', qEstFamilias);
      AnyadirDataSetHTML(L, 'Estudios - Ventas por proveedor estimado', qEstProveedores);
      AnyadirDataSetHTML(L, 'Estudios - Top artículos por margen estimado', qEstMargen);
      AnyadirDataSetHTML(L, 'Estudios - Coste 0 / margen negativo vendido', qEstProblemas);
    end
    else if pcPrincipal.ActivePage = tsComparativa then
    begin
      AnyadirDataSetHTML(L, 'Comparativa - Resumen comparativo', qCompResumen);
      AnyadirDataSetHTML(L, 'Comparativa - Días rango actual', qCompDiaActual);
      AnyadirDataSetHTML(L, 'Comparativa - Días periodo anterior', qCompDiaAnterior);
      AnyadirDataSetHTML(L, 'Comparativa - Familias con variación', qCompFamilias);
      AnyadirDataSetHTML(L, 'Comparativa - Artículos con variación', qCompArticulos);
      AnyadirDataSetHTML(L, 'Comparativa - Formas de pago con variación', qCompPagos);
    end
    else if pcPrincipal.ActivePage = tsTendencias then
    begin
      AnyadirDataSetHTML(L, 'Tendencias - Resumen tendencias', qTendResumen);
      AnyadirDataSetHTML(L, 'Tendencias - Últimos 12 meses', qTendMeses);
      AnyadirDataSetHTML(L, 'Tendencias - Año actual vs anterior', qTendAnual);
      AnyadirDataSetHTML(L, 'Tendencias - Día de la semana', qTendSemana);
      AnyadirDataSetHTML(L, 'Tendencias - Artículos al alza', qTendAlza);
      AnyadirDataSetHTML(L, 'Tendencias - Artículos a la baja', qTendBaja);
    end
    else if pcPrincipal.ActivePage = tsClientes then
    begin
      AnyadirDataSetHTML(L, 'Clientes - Resumen clientes', qCliResumen);
      AnyadirDataSetHTML(L, 'Clientes - Top clientes por importe', qCliTopImporte);
      AnyadirDataSetHTML(L, 'Clientes - Top clientes por frecuencia', qCliTopFrecuencia);
      AnyadirDataSetHTML(L, 'Clientes - Clientes por ticket medio', qCliTicketMedio);
      AnyadirDataSetHTML(L, 'Clientes - Ventas sin cliente asignado', qCliSinCliente);
      AnyadirDataSetHTML(L, 'Clientes - Clientes vendidos con datos incompletos', qCliDatosIncompletos);
    end
    else if pcPrincipal.ActivePage = tsPuestos then
    begin
      AnyadirDataSetHTML(L, 'Puestos - Resumen usuarios / puestos', qPueResumen);
      AnyadirDataSetHTML(L, 'Puestos - Ventas por usuario', qPueUsuarios);
      AnyadirDataSetHTML(L, 'Puestos - Ventas por caja / puesto', qPueCajas);
      AnyadirDataSetHTML(L, 'Puestos - Frecuencia por usuario / hora', qPueHorasUsuario);
      AnyadirDataSetHTML(L, 'Puestos - Formas de pago por caja', qPuePagosCaja);
      AnyadirDataSetHTML(L, 'Puestos - Operaciones a revisar', qPueRevision);
    end
    else if pcPrincipal.ActivePage = tsCompras then
    begin
      AnyadirDataSetHTML(L, 'Compras - Resumen compras / pedidos', qComResumen);
      AnyadirDataSetHTML(L, 'Compras - Pedidos en curso / pendientes', qComPendientes);
      AnyadirDataSetHTML(L, 'Compras - Líneas pendientes de recibir', qComDetallePend);
      AnyadirDataSetHTML(L, 'Compras - Compras / pedidos por proveedor', qComProveedor);
      AnyadirDataSetHTML(L, 'Compras - Artículos más pedidos', qComArticulos);
      AnyadirDataSetHTML(L, 'Compras - Revisión de compras', qComRevision);
    end
    else if pcPrincipal.ActivePage = tsPromociones then
    begin
      AnyadirDataSetHTML(L, 'Promociones - Resumen promociones / descuentos', qPromoResumen);
      AnyadirDataSetHTML(L, 'Promociones - Líneas vendidas con descuento', qPromoDescuentos);
      AnyadirDataSetHTML(L, 'Promociones - Artículos con más descuento', qPromoArticulos);
      AnyadirDataSetHTML(L, 'Promociones - Promociones / descuentos por familia', qPromoFamilias);
      AnyadirDataSetHTML(L, 'Promociones - Posibles ventas bajo coste', qPromoBajoCoste);
      AnyadirDataSetHTML(L, 'Promociones - Revisión de descuentos', qPromoRevision);
    end
    else if pcPrincipal.ActivePage = tsRentabilidad then
    begin
      AnyadirDataSetHTML(L, 'Rentabilidad - Resumen rentabilidad', qRentResumen);
      AnyadirDataSetHTML(L, 'Rentabilidad - Top margen por artículo', qRentArticulos);
      AnyadirDataSetHTML(L, 'Rentabilidad - Margen por familia', qRentFamilias);
      AnyadirDataSetHTML(L, 'Rentabilidad - Margen por proveedor estimado', qRentProveedores);
      AnyadirDataSetHTML(L, 'Rentabilidad - Rentabilidad por día', qRentDias);
      AnyadirDataSetHTML(L, 'Rentabilidad - Revisión margen / coste', qRentRevision);
    end
    else if pcPrincipal.ActivePage = tsRotacion then
    begin
      AnyadirDataSetHTML(L, 'Rotación - Resumen rotación / stock', qRotResumen);
      AnyadirDataSetHTML(L, 'Rotación - Alta rotación', qRotAlta);
      AnyadirDataSetHTML(L, 'Rotación - Riesgo de rotura / cobertura baja', qRotRiesgo);
      AnyadirDataSetHTML(L, 'Rotación - Baja rotación con stock', qRotBaja);
      AnyadirDataSetHTML(L, 'Rotación - Exceso de stock / cobertura alta', qRotExceso);
      AnyadirDataSetHTML(L, 'Rotación - Stock sin ventas en el rango', qRotSinVentas);
    end
    else if pcPrincipal.ActivePage = tsReposicion then
    begin
      AnyadirDataSetHTML(L, 'Reposición - Resumen reposición', qRepResumen);
      AnyadirDataSetHTML(L, 'Reposición - Pedido sugerido orientativo', qRepSugerido);
      AnyadirDataSetHTML(L, 'Reposición - Urgente: stock 0 vendido', qRepUrgente);
      AnyadirDataSetHTML(L, 'Reposición - Necesidad por proveedor', qRepProveedor);
      AnyadirDataSetHTML(L, 'Reposición - Vendidos sin proveedor asignado', qRepSinProveedor);
      AnyadirDataSetHTML(L, 'Reposición - Stock con baja rotación', qRepBajaRotacion);
    end
    else if pcPrincipal.ActivePage = tsPicking then
    begin
      AnyadirDataSetHTML(L, 'Preparación - Resumen preparación', qPickResumen);
      AnyadirDataSetHTML(L, 'Preparación - Ruta de preparación / picking sugerido', qPickRuta);
      AnyadirDataSetHTML(L, 'Preparación - Preparación por proveedor', qPickProveedor);
      AnyadirDataSetHTML(L, 'Preparación - Preparación por ubicación / familia', qPickUbicacion);
      AnyadirDataSetHTML(L, 'Preparación - Artículos a preparar sin ubicación', qPickSinUbicacion);
      AnyadirDataSetHTML(L, 'Preparación - Revisión antes de preparar', qPickRevision);
    end
    else if pcPrincipal.ActivePage = tsCalidad then
    begin
      AnyadirDataSetHTML(L, 'Calidad datos - Resumen calidad de datos', qCalResumen);
      AnyadirDataSetHTML(L, 'Calidad datos - Artículos incompletos', qCalIncompletos);
      AnyadirDataSetHTML(L, 'Calidad datos - Precios / márgenes sospechosos', qCalPrecios);
      AnyadirDataSetHTML(L, 'Calidad datos - Stock sospechoso', qCalStock);
      AnyadirDataSetHTML(L, 'Calidad datos - Posibles duplicados por descripción', qCalDuplicados);
      AnyadirDataSetHTML(L, 'Calidad datos - Stock sin movimiento +365 días', qCalSinMovimiento);
    end
    else if pcPrincipal.ActivePage = tsVeriFactu then
    begin
      AnyadirDataSetHTML(L, 'VeriFactu - Resumen VeriFactu', qVFResumen);
      AnyadirDataSetHTML(L, 'VeriFactu - Pendientes / en cola', qVFPendientes);
      AnyadirDataSetHTML(L, 'VeriFactu - Aceptados con errores', qVFAceptadosErrores);
      AnyadirDataSetHTML(L, 'VeriFactu - Últimos errores', qVFErrores);
      AnyadirDataSetHTML(L, 'VeriFactu - Series / cadena hash', qVFSeries);
      AnyadirDataSetHTML(L, 'VeriFactu - Últimos registros', qVFUltimos);
    end
    else if pcPrincipal.ActivePage = tsComparativaAvanzada then
    begin
      AnyadirDataSetHTML(L, 'Comparativa fechas - Resumen', qCmpAvResumen);
      AnyadirDataSetHTML(L, 'Comparativa fechas - Día seleccionado', qCmpAvDia);
      AnyadirDataSetHTML(L, 'Comparativa fechas - Mes seleccionado', qCmpAvMes);
      AnyadirDataSetHTML(L, 'Comparativa fechas - Periodo seleccionado', qCmpAvPeriodo);
    end
    else if pcPrincipal.ActivePage = tsConsultaLibre then
      AnyadirDataSetHTML(L, 'Consulta libre - Resultado', qLibreResultado);

    L.Add('</body>');
    L.Add('</html>');
    L.SaveToFile(AFichero);
  finally
    L.Free;
  end;
end;

procedure TFDashboardProductividad.ExportarCSVClick(Sender: TObject);
var
  SD: TSaveDialog;
  D1, D2: TDateTime;
begin
  if not FechasValidas(D1, D2) then
    Exit;

  SD := TSaveDialog.Create(Self);
  try
    SD.Title := 'Exportar pestaña actual a CSV';
    SD.Filter := 'Ficheros CSV (*.csv)|*.csv|Todos los ficheros (*.*)|*.*';
    SD.DefaultExt := 'csv';
    SD.FileName := 'productividad_' +
                   NombreFicheroSeguro(pcPrincipal.ActivePage.Caption) + '_' +
                   FormatDateTime('yyyymmdd', D1) + '_' +
                   FormatDateTime('yyyymmdd', D2) + '.csv';
    if SD.Execute then
    begin
      ExportarPestanaCSV(SD.FileName);
      ShowMessage('Exportación CSV finalizada:' + LineEnding + SD.FileName);
    end;
  finally
    SD.Free;
  end;
end;


procedure TFDashboardProductividad.InformeHTMLClick(Sender: TObject);
var
  SD: TSaveDialog;
  D1, D2: TDateTime;
begin
  if not FechasValidas(D1, D2) then
    Exit;

  SD := TSaveDialog.Create(Self);
  try
    SD.Title := 'Generar informe HTML imprimible';
    SD.Filter := 'Ficheros HTML (*.html)|*.html|Todos los ficheros (*.*)|*.*';
    SD.DefaultExt := 'html';
    SD.FileName := 'productividad_' +
                   NombreFicheroSeguro(pcPrincipal.ActivePage.Caption) + '_' +
                   FormatDateTime('yyyymmdd', D1) + '_' +
                   FormatDateTime('yyyymmdd', D2) + '.html';
    if SD.Execute then
    begin
      ExportarPestanaHTML(SD.FileName);
      if not OpenDocument(SD.FileName) then
        ShowMessage('Informe HTML generado:' + LineEnding + SD.FileName)
      else
        ShowMessage('Informe HTML generado y abierto:' + LineEnding + SD.FileName + LineEnding +
                    'Desde el navegador puedes imprimirlo o guardarlo como PDF.');
    end;
  finally
    SD.Free;
  end;
end;


procedure TFDashboardProductividad.InformePDFClick(Sender: TObject);
var
  SD: TSaveDialog;
  D1, D2: TDateTime;
begin
  if not FechasValidas(D1, D2) then
    Exit;

  SD := TSaveDialog.Create(Self);
  try
    SD.Title := 'Generar PDF directo';
    SD.Filter := 'Ficheros PDF (*.pdf)|*.pdf|Todos los ficheros (*.*)|*.*';
    SD.DefaultExt := 'pdf';
    SD.FileName := 'productividad_' +
                   NombreFicheroSeguro(pcPrincipal.ActivePage.Caption) + '_' +
                   FormatDateTime('yyyymmdd', D1) + '_' +
                   FormatDateTime('yyyymmdd', D2) + '.pdf';
    if SD.Execute then
    begin
      ExportarPestanaPDF(SD.FileName);
      if not OpenDocument(SD.FileName) then
        ShowMessage('PDF generado:' + LineEnding + SD.FileName)
      else
        ShowMessage('PDF generado y abierto:' + LineEnding + SD.FileName);
    end;
  finally
    SD.Free;
  end;
end;

procedure TFDashboardProductividad.RefrescarTodo(Sender: TObject);
begin
  CargarDashboard;
end;

procedure TFDashboardProductividad.CerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TFDashboardProductividad.CalendarioDesdeClick(Sender: TObject);
begin
  AbrirCalendarioFecha(dtDesde);
end;

procedure TFDashboardProductividad.CalendarioHastaClick(Sender: TObject);
begin
  AbrirCalendarioFecha(dtHasta);
end;

procedure TFDashboardProductividad.RangoHoy(Sender: TObject);
begin
  SetEditFecha(dtDesde, SysUtils.Date);
  SetEditFecha(dtHasta, SysUtils.Date);
  CargarDashboard;
end;

procedure TFDashboardProductividad.RangoAyer(Sender: TObject);
begin
  SetEditFecha(dtDesde, IncDay(SysUtils.Date, -1));
  SetEditFecha(dtHasta, IncDay(SysUtils.Date, -1));
  CargarDashboard;
end;

procedure TFDashboardProductividad.Rango7Dias(Sender: TObject);
begin
  SetEditFecha(dtDesde, IncDay(SysUtils.Date, -6));
  SetEditFecha(dtHasta, SysUtils.Date);
  CargarDashboard;
end;

procedure TFDashboardProductividad.Rango30Dias(Sender: TObject);
begin
  SetEditFecha(dtDesde, IncDay(SysUtils.Date, -29));
  SetEditFecha(dtHasta, SysUtils.Date);
  CargarDashboard;
end;

procedure TFDashboardProductividad.CargarDashboard;
var
  D1, D2: TDateTime;
begin
  if not FechasValidas(D1, D2) then
    Exit;

  CargarResumen;
  CargarHoy;
  CargarCuadroGestion;
  CargarVentasAbiertas;
  CargarCierreTarde;
  CargarDiagnostico;
  CargarPagos;
  CargarTopArticulos;
  CargarTopFamilias;
  CargarHoras;
  CargarEstudios;
  CargarComparativa;
  CargarTendencias;
  CargarClientes;
  CargarPuestos;
  CargarCompras;
  CargarPromociones;
  CargarRentabilidad;
  CargarRotacion;
  CargarReposicion;
  CargarPicking;
  CargarCalidad;
  CargarVeriFactu;
  CargarGraficas;
  CargarComparativaAvanzada;
  AplicarFormatoYAnchos;
end;


procedure TFDashboardProductividad.CargarHoy;
begin
  CargarHoyResumen;
  CargarHoyHoras;
  CargarHoyPagos;

  if pbHoyTicketsHora <> nil then pbHoyTicketsHora.Invalidate;
  if pbHoyImportesHora <> nil then pbHoyImportesHora.Invalidate;
  if pbHoyPagos <> nil then pbHoyPagos.Invalidate;
end;

procedure TFDashboardProductividad.CargarHoyResumen;
begin
  if qHoyResumen = nil then Exit;

  qHoyResumen.Close;
  qHoyResumen.SQL.Text :=
    'SELECT CURDATE() AS fecha, ' +
    '  (SELECT COUNT(*) FROM ' + Tabla('hisopcc') + ' C ' +
    '   WHERE C.HO0 = CURDATE() AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16, '''') <> ''A'') AS tickets, ' +
    '  (SELECT ROUND(COALESCE(SUM(IF(COALESCE(C.HO11,0) <> 0, C.HO11, C.HO9)),0),2) FROM ' + Tabla('hisopcc') + ' C ' +
    '   WHERE C.HO0 = CURDATE() AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16, '''') <> ''A'') AS ventas, ' +
    '  (SELECT ROUND(COALESCE(AVG(IF(COALESCE(C.HO11,0) <> 0, C.HO11, C.HO9)),0),2) FROM ' + Tabla('hisopcc') + ' C ' +
    '   WHERE C.HO0 = CURDATE() AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16, '''') <> ''A'') AS ticket_medio, ' +
    '  (SELECT ROUND(COALESCE(SUM(D.HOD12),0),2) FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ' +
    '    ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '   WHERE C.HO0 = CURDATE() AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16, '''') <> ''A'') AS base, ' +
    '  (SELECT ROUND(COALESCE(SUM(D.HOD14 - D.HOD12),0),2) FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ' +
    '    ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '   WHERE C.HO0 = CURDATE() AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16, '''') <> ''A'') AS iva';
  qHoyResumen.Open;

  if lblHoyFecha <> nil then
    lblHoyFecha.Caption := 'Analisis del dia actual - ' + FormatDateTime('dd/mm/yyyy hh:nn', Now);
  if lblHoyVentas <> nil then lblHoyVentas.Caption := Dinero(CampoDouble(qHoyResumen, 'ventas'));
  if lblHoyTickets <> nil then lblHoyTickets.Caption := IntToStr(CampoInteger(qHoyResumen, 'tickets'));
  if lblHoyTicketMedio <> nil then lblHoyTicketMedio.Caption := Dinero(CampoDouble(qHoyResumen, 'ticket_medio'));
  if lblHoyBase <> nil then lblHoyBase.Caption := Dinero(CampoDouble(qHoyResumen, 'base'));
  if lblHoyIva <> nil then lblHoyIva.Caption := Dinero(CampoDouble(qHoyResumen, 'iva'));
end;

procedure TFDashboardProductividad.CargarHoyHoras;
var
  H, MaxTicketsHora, MaxImporteHora: Integer;
  MaxTickets: Integer;
  MaxImporte: Double;
begin
  FillChar(FHoyHoraImportes, SizeOf(FHoyHoraImportes), 0);
  FillChar(FHoyHoraTickets, SizeOf(FHoyHoraTickets), 0);
  MaxTickets := 0;
  MaxImporte := 0;
  MaxTicketsHora := -1;
  MaxImporteHora := -1;

  qHoyHoras.Close;
  qHoyHoras.SQL.Text :=
    'SELECT HOUR(HO1) AS hora, ' +
    '       CONCAT(LPAD(HOUR(HO1),2,''0''), '':00 - '', LPAD(HOUR(HO1),2,''0''), '':59'') AS franja, ' +
    '       COUNT(*) AS tickets, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS importe, ' +
    '       ROUND(COALESCE(AVG(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS ticket_medio ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 = CURDATE() ' +
    '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '  AND COALESCE(HO16, '''') <> ''A'' ' +
    'GROUP BY HOUR(HO1) ' +
    'ORDER BY hora';
  qHoyHoras.Open;

  qHoyHoras.DisableControls;
  try
    qHoyHoras.First;
    while not qHoyHoras.EOF do
    begin
      H := CampoInteger(qHoyHoras, 'hora');
      if (H >= 0) and (H <= 23) then
      begin
        FHoyHoraTickets[H] := CampoInteger(qHoyHoras, 'tickets');
        FHoyHoraImportes[H] := CampoDouble(qHoyHoras, 'importe');
        if FHoyHoraTickets[H] > MaxTickets then
        begin
          MaxTickets := FHoyHoraTickets[H];
          MaxTicketsHora := H;
        end;
        if FHoyHoraImportes[H] > MaxImporte then
        begin
          MaxImporte := FHoyHoraImportes[H];
          MaxImporteHora := H;
        end;
      end;
      qHoyHoras.Next;
    end;
    qHoyHoras.First;
  finally
    qHoyHoras.EnableControls;
  end;

  if lblHoyHoraPico <> nil then
  begin
    if MaxTicketsHora >= 0 then
      lblHoyHoraPico.Caption := Format('%.2d:00 (%d)', [MaxTicketsHora, MaxTickets])
    else
      lblHoyHoraPico.Caption := '-';
  end;

  if lblHoyImportePico <> nil then
  begin
    if MaxImporteHora >= 0 then
      lblHoyImportePico.Caption := Format('Hora pico importe: %.2d:00 (%s)', [MaxImporteHora, Dinero(MaxImporte)])
    else
      lblHoyImportePico.Caption := 'Hora pico importe: -';
  end;
end;

procedure TFDashboardProductividad.CargarHoyPagos;
var
  F: TField;
  I: Integer;
begin
  for I := Low(FHoyPagoNombres) to High(FHoyPagoNombres) do
  begin
    FHoyPagoNombres[I] := '';
    FHoyPagoImportes[I] := 0;
  end;
  FHoyPagoCount := 0;

  qHoyPagos.Close;
  qHoyPagos.SQL.Text :=
    'SELECT forma_pago, SUM(documentos) AS documentos, ROUND(SUM(importe),2) AS total ' +
    'FROM ( ' +
    '  SELECT CASE WHEN (UPPER(TRIM(HO6)) IN (''CONT.+TARJ'',''TARJETA+CO'',''CONT+TARJ'',''TARJ+CONT'') ' +
    '                    OR (COALESCE(HO12,0) <> 0 AND COALESCE(HO14,0) <> 0)) ' +
    '              THEN ''CONTADO'' ' +
    '              ELSE COALESCE(NULLIF(TRIM(HO6), ''''), ''SIN FORMA'') END AS forma_pago, ' +
    '         1 AS documentos, ' +
    '         CASE ' +
    '           WHEN (UPPER(TRIM(HO6)) IN (''CONT.+TARJ'',''TARJETA+CO'',''CONT+TARJ'',''TARJ+CONT'') ' +
    '                 OR (COALESCE(HO12,0) <> 0 AND COALESCE(HO14,0) <> 0)) ' +
    '             THEN GREATEST(COALESCE(HO12,0) - COALESCE(HO13,0), 0) ' +
    '           WHEN UPPER(TRIM(HO6)) = ''CONTADO'' ' +
    '             THEN CASE WHEN COALESCE(HO12,0) <> 0 THEN GREATEST(COALESCE(HO12,0) - COALESCE(HO13,0), 0) ' +
    '                       ELSE IF(COALESCE(HO11,0) <> 0, HO11, HO9) END ' +
    '           WHEN UPPER(TRIM(HO6)) IN (''VISA'',''MASTER CARD'',''MASTER'',''4-B'',''RED 6000'',''TARJETA'') ' +
    '             THEN CASE WHEN COALESCE(HO14,0) <> 0 THEN COALESCE(HO14,0) ' +
    '                       ELSE IF(COALESCE(HO11,0) <> 0, HO11, HO9) END ' +
    '           ELSE IF(COALESCE(HO11,0) <> 0, HO11, HO9) ' +
    '         END AS importe ' +
    '  FROM ' + Tabla('hisopcc') + ' ' +
    '  WHERE HO0 = CURDATE() ' +
    '    AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '    AND COALESCE(HO16, '''') <> ''A'' ' +
    '  UNION ALL ' +
    '  SELECT ''TARJETA'' AS forma_pago, 0 AS documentos, COALESCE(HO14,0) AS importe ' +
    '  FROM ' + Tabla('hisopcc') + ' ' +
    '  WHERE HO0 = CURDATE() ' +
    '    AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '    AND COALESCE(HO16, '''') <> ''A'' ' +
    '    AND (UPPER(TRIM(HO6)) IN (''CONT.+TARJ'',''TARJETA+CO'',''CONT+TARJ'',''TARJ+CONT'') ' +
    '         OR (COALESCE(HO12,0) <> 0 AND COALESCE(HO14,0) <> 0)) ' +
    '    AND COALESCE(HO14,0) <> 0 ' +
    ') X ' +
    'GROUP BY forma_pago ' +
    'HAVING ABS(total) > 0.0001 OR SUM(documentos) > 0 ' +
    'ORDER BY total DESC';
  qHoyPagos.Open;

  qHoyPagos.DisableControls;
  try
    qHoyPagos.First;
    while (not qHoyPagos.EOF) and (FHoyPagoCount < 20) do
    begin
      F := qHoyPagos.FindField('forma_pago');
      if F <> nil then FHoyPagoNombres[FHoyPagoCount] := F.AsString;
      F := qHoyPagos.FindField('total');
      if F <> nil then FHoyPagoImportes[FHoyPagoCount] := F.AsFloat;
      Inc(FHoyPagoCount);
      qHoyPagos.Next;
    end;
    qHoyPagos.First;
  finally
    qHoyPagos.EnableControls;
  end;
end;


function TFDashboardProductividad.ColumnaExiste(const ANombreTabla, ANombreCampo: string): Boolean;
var
  Q: TZQuery;
  NombreTabla: string;
begin
  Result := False;

  // Igual que en TablaExiste: INFORMATION_SCHEMA espera usuarios0000,
  // no `usuarios0000`. Sin esta limpieza, ColumnaExiste podia devolver
  // False aunque USU9 existiera realmente.
  NombreTabla := StringReplace(ANombreTabla, '`', '', [rfReplaceAll]);

  Q := CrearQuery;
  try
    Q.SQL.Text :=
      'SELECT COUNT(*) AS existe ' +
      'FROM information_schema.columns ' +
      'WHERE table_schema = DATABASE() AND table_name = :tabla AND column_name = :campo';
    Q.ParamByName('tabla').AsString := NombreTabla;
    Q.ParamByName('campo').AsString := ANombreCampo;
    Q.Open;
    Result := CampoInteger(Q, 'existe') > 0;
    Q.Close;
  except
    on E: Exception do
      Result := False;
  end;
  Q.Free;
end;

function TFDashboardProductividad.CampoHoraVentas(const ANombreTabla: string): string;
const
  // En las tablas activas ventasXXXXA-H de FacturLinEx:
  //   V14 = Fecha de creacion de la linea
  //   V15 = Hora de creacion de la linea
  // V15 se pone el primero para que la pestaña Ventas abiertas tenga hora real
  // y no termine mostrando "NO DISPONIBLE".
  Candidatos: array[0..14] of string = (
    'V15',
    'VHORA', 'V_HORA', 'HORA', 'hora', 'Hora',
    'VFECHAHORA', 'FECHAHORA', 'FECHA_HORA',
    'created_at', 'CREATED_AT', 'timestamp', 'TIMESTAMP',
    'V21', 'V22'
  );
var
  I: Integer;
begin
  Result := '';
  for I := Low(Candidatos) to High(Candidatos) do
    if ColumnaExiste(ANombreTabla, Candidatos[I]) then
    begin
      Result := Candidatos[I];
      Exit;
    end;
end;

function TFDashboardProductividad.SQLUnionVentasAbiertas: string;
var
  C: Char;
  T, FechaExpr, HoraCampo, HoraExpr, Sep: string;
begin
  Result := '';
  Sep := '';
  for C := 'A' to 'H' do
  begin
    T := 'ventas' + FTienda + C;
    if not TablaExiste(T) then
      Continue;

    if ColumnaExiste(T, 'V14') then
      FechaExpr := 'COALESCE(NULLIF(TRIM(CAST(`V14` AS CHAR(30))), ''''), ''NO DISPONIBLE'')'
    else
      FechaExpr := '''NO DISPONIBLE''';

    // Hora real de creacion de linea: V15. Si en alguna instalacion antigua no existe,
    // mantenemos la deteccion flexible como respaldo.
    HoraCampo := CampoHoraVentas(T);
    if HoraCampo <> '' then
      HoraExpr := 'COALESCE(NULLIF(TRIM(CAST(`' + HoraCampo + '` AS CHAR(30))), ''''), ''NO DISPONIBLE'')'
    else
      HoraExpr := '''NO DISPONIBLE''';

    Result := Result + Sep +
      'SELECT ' +
      QuotedStr(String(C)) + ' AS caja, ' +
      QuotedStr(T) + ' AS tabla, ' +
      FechaExpr + ' AS fecha_linea, ' +
      HoraExpr + ' AS hora_linea, ' +
      'COALESCE(`V0`,0) AS ticket0, ' +
      'COALESCE(`V1`,0) AS ticket, ' +
      'COALESCE(`V2`,0) AS linea, ' +
      'COALESCE(NULLIF(TRIM(`V3`),''''),'''') AS codigo, ' +
      'CAST(`V4` AS CHAR(255)) AS descripcion, ' +
      'COALESCE(`V5`,0) AS unidades, ' +
      'COALESCE(`V6`,0) AS pvp, ' +
      'COALESCE(`V8`,0) AS dto, ' +
      'COALESCE(`V9`,0) AS importe, ' +
      'COALESCE(`V10`,0) AS iva, ' +
      'COALESCE(`V11`,0) AS total_linea, ' +
      'COALESCE(`V12`,0) AS cliente, ' +
      'COALESCE(`V13`,'''') AS marcada ' +
      'FROM `' + T + '` ' +
      'WHERE COALESCE(`V2`,0) >= 0';
    Sep := ' UNION ALL ';
  end;
end;


function TFDashboardProductividad.CGFechasValidas(out AActDesde, AActHasta, ACompDesde, ACompHasta: TDateTime): Boolean;
begin
  Result := False;
  if not ParseFecha(dtCGDesdeAct.Text, AActDesde) then
  begin
    ShowMessage('Fecha inicial del periodo actual no valida.');
    Exit;
  end;
  if not ParseFecha(dtCGHastaAct.Text, AActHasta) then
  begin
    ShowMessage('Fecha final del periodo actual no valida.');
    Exit;
  end;
  if not ParseFecha(dtCGDesdeComp.Text, ACompDesde) then
  begin
    ShowMessage('Fecha inicial de comparacion no valida.');
    Exit;
  end;
  if not ParseFecha(dtCGHastaComp.Text, ACompHasta) then
  begin
    ShowMessage('Fecha final de comparacion no valida.');
    Exit;
  end;
  if AActHasta < AActDesde then
  begin
    ShowMessage('El periodo actual tiene la fecha final anterior a la inicial.');
    Exit;
  end;
  if ACompHasta < ACompDesde then
  begin
    ShowMessage('El periodo de comparacion tiene la fecha final anterior a la inicial.');
    Exit;
  end;
  Result := True;
end;

procedure TFDashboardProductividad.CGSetPeriodoDia(Sender: TObject);
begin
  SetEditFecha(dtCGDesdeAct, SysUtils.Date);
  SetEditFecha(dtCGHastaAct, SysUtils.Date);
  SetEditFecha(dtCGDesdeComp, IncYear(SysUtils.Date, -1));
  SetEditFecha(dtCGHastaComp, IncYear(SysUtils.Date, -1));
  CargarCuadroGestion;
end;

procedure TFDashboardProductividad.CGSetPeriodoMes(Sender: TObject);
var
  D1, D2: TDateTime;
begin
  D1 := EncodeDate(YearOf(SysUtils.Date), MonthOf(SysUtils.Date), 1);
  D2 := SysUtils.Date;
  SetEditFecha(dtCGDesdeAct, D1);
  SetEditFecha(dtCGHastaAct, D2);
  SetEditFecha(dtCGDesdeComp, IncYear(D1, -1));
  SetEditFecha(dtCGHastaComp, IncYear(D2, -1));
  CargarCuadroGestion;
end;

procedure TFDashboardProductividad.CGSetPeriodoAno(Sender: TObject);
var
  D1, D2: TDateTime;
begin
  D1 := EncodeDate(YearOf(SysUtils.Date), 1, 1);
  D2 := SysUtils.Date;
  SetEditFecha(dtCGDesdeAct, D1);
  SetEditFecha(dtCGHastaAct, D2);
  SetEditFecha(dtCGDesdeComp, IncYear(D1, -1));
  SetEditFecha(dtCGHastaComp, IncYear(D2, -1));
  CargarCuadroGestion;
end;

procedure TFDashboardProductividad.CGPeriodoManual(Sender: TObject);
begin
  ShowMessage('Modo periodo: ajusta las cuatro fechas manualmente y pulsa Actualizar cuadro.');
end;

procedure TFDashboardProductividad.CGRefrescarClick(Sender: TObject);
begin
  CargarCuadroGestion;
end;

procedure TFDashboardProductividad.CGCalDesdeActClick(Sender: TObject);
begin
  AbrirCalendarioFecha(dtCGDesdeAct);
end;

procedure TFDashboardProductividad.CGCalHastaActClick(Sender: TObject);
begin
  AbrirCalendarioFecha(dtCGHastaAct);
end;

procedure TFDashboardProductividad.CGCalDesdeCompClick(Sender: TObject);
begin
  AbrirCalendarioFecha(dtCGDesdeComp);
end;

procedure TFDashboardProductividad.CGCalHastaCompClick(Sender: TObject);
begin
  AbrirCalendarioFecha(dtCGHastaComp);
end;

procedure TFDashboardProductividad.CargarCuadroGestion;
begin
  if (qCGResumen = nil) or (dtCGDesdeAct = nil) then Exit;
  CargarCGResumen;
  CargarCGNegocio;
  CargarCGHoras;
  CargarCGMargen;
  CargarCGEmpleados;
  ActualizarTarjetasCG;
  CargarCGAnalisis;
  if pbCGNegocio <> nil then pbCGNegocio.Invalidate;
  if pbCGHoras <> nil then pbCGHoras.Invalidate;
  if pbCGMargen <> nil then pbCGMargen.Invalidate;
  if pbCGEmpleados <> nil then pbCGEmpleados.Invalidate;
end;

procedure TFDashboardProductividad.CargarCGResumen;
var
  AD1, AD2, CD1, CD2: TDateTime;
begin
  if not CGFechasValidas(AD1, AD2, CD1, CD2) then Exit;

  qCGResumen.Close;
  qCGResumen.SQL.Text :=
    'SELECT periodo, ROUND(facturacion,2) AS facturacion, ROUND(margen,2) AS margen_indicativo, clientes, ROUND(articulos,2) AS articulos, tickets, ROUND(facturacion/NULLIF(tickets,0),2) AS cesta_media ' +
    'FROM ( ' +
    ' SELECT ''Actual'' AS periodo, ' +
    '   (SELECT COALESCE(SUM(IF(COALESCE(HO11,0)<>0,HO11,HO9)),0) FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :ad1 AND :ad2 AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A'') AS facturacion, ' +
    '   (SELECT COALESCE(SUM(D.HOD12-(D.HOD8*COALESCE(A.A24,0))),0) FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 WHERE C.HO0 BETWEEN :ad3 AND :ad4 AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''')<>''A'') AS margen, ' +
    '   (SELECT COUNT(DISTINCT CASE WHEN COALESCE(HO8,0)<>0 THEN CONCAT(''C'',HO8) ELSE CONCAT(''T'',HO0,''-'',HO1,''-'',HO2,''-'',HO3,''-'',HO4) END) FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :ad5 AND :ad6 AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A'') AS clientes, ' +
    '   (SELECT COALESCE(SUM(D.HOD8),0) FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 WHERE C.HO0 BETWEEN :ad7 AND :ad8 AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''')<>''A'') AS articulos, ' +
    '   (SELECT COUNT(*) FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :ad9 AND :ad10 AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A'') AS tickets ' +
    ' UNION ALL SELECT ''Comparacion'', ' +
    '   (SELECT COALESCE(SUM(IF(COALESCE(HO11,0)<>0,HO11,HO9)),0) FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :cd1 AND :cd2 AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A''), ' +
    '   (SELECT COALESCE(SUM(D.HOD12-(D.HOD8*COALESCE(A.A24,0))),0) FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 WHERE C.HO0 BETWEEN :cd3 AND :cd4 AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''')<>''A''), ' +
    '   (SELECT COUNT(DISTINCT CASE WHEN COALESCE(HO8,0)<>0 THEN CONCAT(''C'',HO8) ELSE CONCAT(''T'',HO0,''-'',HO1,''-'',HO2,''-'',HO3,''-'',HO4) END) FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :cd5 AND :cd6 AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A''), ' +
    '   (SELECT COALESCE(SUM(D.HOD8),0) FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 WHERE C.HO0 BETWEEN :cd7 AND :cd8 AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''')<>''A''), ' +
    '   (SELECT COUNT(*) FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :cd9 AND :cd10 AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A'') ' +
    ') X';
  qCGResumen.ParamByName('ad1').AsDateTime := AD1; qCGResumen.ParamByName('ad2').AsDateTime := AD2;
  qCGResumen.ParamByName('ad3').AsDateTime := AD1; qCGResumen.ParamByName('ad4').AsDateTime := AD2;
  qCGResumen.ParamByName('ad5').AsDateTime := AD1; qCGResumen.ParamByName('ad6').AsDateTime := AD2;
  qCGResumen.ParamByName('ad7').AsDateTime := AD1; qCGResumen.ParamByName('ad8').AsDateTime := AD2;
  qCGResumen.ParamByName('ad9').AsDateTime := AD1; qCGResumen.ParamByName('ad10').AsDateTime := AD2;
  qCGResumen.ParamByName('cd1').AsDateTime := CD1; qCGResumen.ParamByName('cd2').AsDateTime := CD2;
  qCGResumen.ParamByName('cd3').AsDateTime := CD1; qCGResumen.ParamByName('cd4').AsDateTime := CD2;
  qCGResumen.ParamByName('cd5').AsDateTime := CD1; qCGResumen.ParamByName('cd6').AsDateTime := CD2;
  qCGResumen.ParamByName('cd7').AsDateTime := CD1; qCGResumen.ParamByName('cd8').AsDateTime := CD2;
  qCGResumen.ParamByName('cd9').AsDateTime := CD1; qCGResumen.ParamByName('cd10').AsDateTime := CD2;
  qCGResumen.Open;

  AjustarCampo(qCGResumen, 'periodo', 'Periodo', 14);
  AjustarCampoMoneda(qCGResumen, 'facturacion', 'Facturacion', 13);
  AjustarCampoMoneda(qCGResumen, 'margen_indicativo', 'Margen indic.', 13);
  AjustarCampoNumero(qCGResumen, 'clientes', 'Clientes', 10, '#,##0');
  AjustarCampoNumero(qCGResumen, 'articulos', 'Articulos/uds', 12, '#,##0.##');
  AjustarCampoNumero(qCGResumen, 'tickets', 'Tickets', 10, '#,##0');
  AjustarCampoMoneda(qCGResumen, 'cesta_media', 'Cesta media', 12);
end;

procedure TFDashboardProductividad.CargarCGNegocio;
var
  AD1, AD2, CD1, CD2: TDateTime;
  I: Integer;
begin
  for I := 0 to 19 do
  begin
    FCGNegocioNombres[I] := '';
    FCGNegocioActual[I] := 0;
    FCGNegocioComp[I] := 0;
  end;
  FCGNegocioCount := 0;
  if not CGFechasValidas(AD1, AD2, CD1, CD2) then Exit;

  qCGNegocio.Close;
  qCGNegocio.SQL.Text :=
    'SELECT negocio, ROUND(SUM(actual),2) AS actual, ROUND(SUM(comparacion),2) AS comparacion, ' +
    '       ROUND(SUM(actual)-SUM(comparacion),2) AS diferencia, ' +
    '       ROUND((SUM(actual)-SUM(comparacion))/NULLIF(SUM(comparacion),0)*100,2) AS diferencia_pct ' +
    'FROM ( ' +
    ' SELECT COALESCE(F.F1,''Sin familia'') AS negocio, COALESCE(SUM(D.HOD14),0) AS actual, 0 AS comparacion ' +
    ' FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    ' LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    ' WHERE C.HO0 BETWEEN :ad1 AND :ad2 AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''')<>''A'' GROUP BY COALESCE(F.F1,''Sin familia'') ' +
    ' UNION ALL ' +
    ' SELECT COALESCE(F.F1,''Sin familia''), 0, COALESCE(SUM(D.HOD14),0) ' +
    ' FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    ' LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    ' WHERE C.HO0 BETWEEN :cd1 AND :cd2 AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''')<>''A'' GROUP BY COALESCE(F.F1,''Sin familia'') ' +
    ') S GROUP BY negocio ORDER BY actual DESC LIMIT 20';
  qCGNegocio.ParamByName('ad1').AsDateTime := AD1; qCGNegocio.ParamByName('ad2').AsDateTime := AD2;
  qCGNegocio.ParamByName('cd1').AsDateTime := CD1; qCGNegocio.ParamByName('cd2').AsDateTime := CD2;
  qCGNegocio.Open;

  qCGNegocio.DisableControls;
  try
    I := 0;
    qCGNegocio.First;
    while (not qCGNegocio.EOF) and (I <= 19) do
    begin
      FCGNegocioNombres[I] := qCGNegocio.FieldByName('negocio').AsString;
      FCGNegocioActual[I] := CampoDouble(qCGNegocio, 'actual');
      FCGNegocioComp[I] := CampoDouble(qCGNegocio, 'comparacion');
      Inc(I);
      qCGNegocio.Next;
    end;
    FCGNegocioCount := I;
    qCGNegocio.First;
  finally
    qCGNegocio.EnableControls;
  end;

  AjustarCampo(qCGNegocio, 'negocio', 'Negocio / familia', 28);
  AjustarCampoMoneda(qCGNegocio, 'actual', 'Actual', 12);
  AjustarCampoMoneda(qCGNegocio, 'comparacion', 'Comparacion', 12);
  AjustarCampoMoneda(qCGNegocio, 'diferencia', 'Dif.', 12);
  AjustarCampoNumero(qCGNegocio, 'diferencia_pct', 'Dif %', 9, '#,##0.00 %');
end;

procedure TFDashboardProductividad.CargarCGHoras;
var
  AD1, AD2, CD1, CD2: TDateTime;
  I, H: Integer;
begin
  for I := 0 to 23 do
  begin
    FCGHoraImportesAct[I] := 0;
    FCGHoraImportesComp[I] := 0;
    FCGHoraTicketsAct[I] := 0;
    FCGHoraTicketsComp[I] := 0;
  end;
  if not CGFechasValidas(AD1, AD2, CD1, CD2) then Exit;

  qCGHoras.Close;
  qCGHoras.SQL.Text :=
    'SELECT hora, CONCAT(LPAD(hora,2,''0''), '':00'') AS franja, SUM(tickets_act) AS tickets_actual, SUM(tickets_comp) AS tickets_comparacion, ' +
    '       ROUND(SUM(importe_act),2) AS importe_actual, ROUND(SUM(importe_comp),2) AS importe_comparacion ' +
    'FROM ( ' +
    ' SELECT HOUR(HO1) AS hora, COUNT(*) AS tickets_act, 0 AS tickets_comp, COALESCE(SUM(IF(COALESCE(HO11,0)<>0,HO11,HO9)),0) AS importe_act, 0 AS importe_comp ' +
    ' FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :ad1 AND :ad2 AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A'' GROUP BY HOUR(HO1) ' +
    ' UNION ALL ' +
    ' SELECT HOUR(HO1), 0, COUNT(*), 0, COALESCE(SUM(IF(COALESCE(HO11,0)<>0,HO11,HO9)),0) ' +
    ' FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :cd1 AND :cd2 AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A'' GROUP BY HOUR(HO1) ' +
    ') S GROUP BY hora ORDER BY hora';
  qCGHoras.ParamByName('ad1').AsDateTime := AD1; qCGHoras.ParamByName('ad2').AsDateTime := AD2;
  qCGHoras.ParamByName('cd1').AsDateTime := CD1; qCGHoras.ParamByName('cd2').AsDateTime := CD2;
  qCGHoras.Open;

  qCGHoras.DisableControls;
  try
    qCGHoras.First;
    while not qCGHoras.EOF do
    begin
      H := CampoInteger(qCGHoras, 'hora');
      if (H >= 0) and (H <= 23) then
      begin
        FCGHoraTicketsAct[H] := CampoInteger(qCGHoras, 'tickets_actual');
        FCGHoraTicketsComp[H] := CampoInteger(qCGHoras, 'tickets_comparacion');
        FCGHoraImportesAct[H] := CampoDouble(qCGHoras, 'importe_actual');
        FCGHoraImportesComp[H] := CampoDouble(qCGHoras, 'importe_comparacion');
      end;
      qCGHoras.Next;
    end;
    qCGHoras.First;
  finally
    qCGHoras.EnableControls;
  end;

  AjustarCampo(qCGHoras, 'franja', 'Hora', 8);
  AjustarCampoNumero(qCGHoras, 'tickets_actual', 'Tickets act.', 10, '#,##0');
  AjustarCampoNumero(qCGHoras, 'tickets_comparacion', 'Tickets comp.', 10, '#,##0');
  AjustarCampoMoneda(qCGHoras, 'importe_actual', 'Importe act.', 12);
  AjustarCampoMoneda(qCGHoras, 'importe_comparacion', 'Importe comp.', 12);
end;

procedure TFDashboardProductividad.CargarCGMargen;
var
  AD1, AD2, CD1, CD2: TDateTime;
  I: Integer;
begin
  for I := 0 to 19 do
  begin
    FCGMargenNombres[I] := '';
    FCGMargenActual[I] := 0;
    FCGMargenComp[I] := 0;
  end;
  FCGMargenCount := 0;
  if not CGFechasValidas(AD1, AD2, CD1, CD2) then Exit;

  qCGMargen.Close;
  qCGMargen.SQL.Text :=
    'SELECT negocio, ROUND(SUM(actual),2) AS actual, ROUND(SUM(comparacion),2) AS comparacion, ' +
    '       ROUND(SUM(actual)-SUM(comparacion),2) AS diferencia, ' +
    '       ROUND((SUM(actual)-SUM(comparacion))/NULLIF(SUM(comparacion),0)*100,2) AS diferencia_pct ' +
    'FROM ( ' +
    ' SELECT COALESCE(F.F1,''Sin familia'') AS negocio, COALESCE(SUM(D.HOD12-(D.HOD8*COALESCE(A.A24,0))),0) AS actual, 0 AS comparacion ' +
    ' FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    ' LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    ' WHERE C.HO0 BETWEEN :ad1 AND :ad2 AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''')<>''A'' GROUP BY COALESCE(F.F1,''Sin familia'') ' +
    ' UNION ALL ' +
    ' SELECT COALESCE(F.F1,''Sin familia''), 0, COALESCE(SUM(D.HOD12-(D.HOD8*COALESCE(A.A24,0))),0) ' +
    ' FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    ' LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    ' WHERE C.HO0 BETWEEN :cd1 AND :cd2 AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''')<>''A'' GROUP BY COALESCE(F.F1,''Sin familia'') ' +
    ') S GROUP BY negocio ORDER BY actual DESC LIMIT 20';
  qCGMargen.ParamByName('ad1').AsDateTime := AD1; qCGMargen.ParamByName('ad2').AsDateTime := AD2;
  qCGMargen.ParamByName('cd1').AsDateTime := CD1; qCGMargen.ParamByName('cd2').AsDateTime := CD2;
  qCGMargen.Open;

  qCGMargen.DisableControls;
  try
    I := 0;
    qCGMargen.First;
    while (not qCGMargen.EOF) and (I <= 19) do
    begin
      FCGMargenNombres[I] := qCGMargen.FieldByName('negocio').AsString;
      FCGMargenActual[I] := CampoDouble(qCGMargen, 'actual');
      FCGMargenComp[I] := CampoDouble(qCGMargen, 'comparacion');
      Inc(I);
      qCGMargen.Next;
    end;
    FCGMargenCount := I;
    qCGMargen.First;
  finally
    qCGMargen.EnableControls;
  end;

  AjustarCampo(qCGMargen, 'negocio', 'Negocio / familia', 28);
  AjustarCampoMoneda(qCGMargen, 'actual', 'Actual', 12);
  AjustarCampoMoneda(qCGMargen, 'comparacion', 'Comparacion', 12);
  AjustarCampoMoneda(qCGMargen, 'diferencia', 'Dif.', 12);
  AjustarCampoNumero(qCGMargen, 'diferencia_pct', 'Dif %', 9, '#,##0.00 %');
end;

procedure TFDashboardProductividad.CargarCGEmpleados;
var
  AD1, AD2, CD1, CD2: TDateTime;
  I: Integer;
  TieneUsuarios, TieneUSU9, TieneUSU1: Boolean;
  EmpExpr, JoinUsuarios, NombreUsuarioExpr: string;
begin
  for I := 0 to 19 do
  begin
    FCGEmpleadoNombres[I] := '';
    FCGEmpleadoImportes[I] := 0;
  end;
  FCGEmpleadoCount := 0;
  if not CGFechasValidas(AD1, AD2, CD1, CD2) then Exit;

  // Si existe la tabla de usuarios, mostramos codigo + nombre corto.
  // En FacturLinEx el nombre visible en el boton del usuario esta en USU9.
  // Si USU9 no existe en alguna instalacion antigua, se intenta USU1 como
  // reserva; si tampoco existe, se conserva solo el codigo original.
  TieneUsuarios := TablaExiste(Tabla('usuarios')) and ColumnaExiste(Tabla('usuarios'), 'USU0');
  TieneUSU9 := False;
  TieneUSU1 := False;
  if TieneUsuarios then
  begin
    TieneUSU9 := ColumnaExiste(Tabla('usuarios'), 'USU9');
    TieneUSU1 := ColumnaExiste(Tabla('usuarios'), 'USU1');
  end;

  if TieneUsuarios and (TieneUSU9 or TieneUSU1) then
  begin
    JoinUsuarios := ' LEFT JOIN ' + Tabla('usuarios') + ' U ON U.USU0=C.HO7 ';
    if TieneUSU9 and TieneUSU1 then
      NombreUsuarioExpr := 'COALESCE(NULLIF(TRIM(U.USU9),''''), NULLIF(TRIM(U.USU1),''''), ''Sin nombre'')'
    else if TieneUSU9 then
      NombreUsuarioExpr := 'COALESCE(NULLIF(TRIM(U.USU9),''''), ''Sin nombre'')'
    else
      NombreUsuarioExpr := 'COALESCE(NULLIF(TRIM(U.USU1),''''), ''Sin nombre'')';

    EmpExpr := 'CONCAT(COALESCE(NULLIF(TRIM(CAST(C.HO7 AS CHAR)),''''),''?''), '' - '', ' + NombreUsuarioExpr + ')';
  end
  else
  begin
    JoinUsuarios := '';
    EmpExpr := 'COALESCE(NULLIF(TRIM(CAST(C.HO7 AS CHAR)),''''),''Sin usuario'')';
  end;

  qCGEmpleados.Close;
  qCGEmpleados.SQL.Text :=
    'SELECT ' + EmpExpr + ' AS empleado, COUNT(*) AS tickets, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(C.HO11,0)<>0,C.HO11,C.HO9)),0),2) AS facturacion, ' +
    '       ROUND(COALESCE(AVG(IF(COALESCE(C.HO11,0)<>0,C.HO11,C.HO9)),0),2) AS ticket_medio ' +
    'FROM ' + Tabla('hisopcc') + ' C ' + JoinUsuarios +
    'WHERE C.HO0 BETWEEN :ad1 AND :ad2 AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''')<>''A'' ' +
    'GROUP BY empleado ORDER BY facturacion DESC LIMIT 20';
  qCGEmpleados.ParamByName('ad1').AsDateTime := AD1; qCGEmpleados.ParamByName('ad2').AsDateTime := AD2;
  qCGEmpleados.Open;

  qCGEmpleados.DisableControls;
  try
    I := 0;
    qCGEmpleados.First;
    while (not qCGEmpleados.EOF) and (I <= 19) do
    begin
      FCGEmpleadoNombres[I] := qCGEmpleados.FieldByName('empleado').AsString;
      FCGEmpleadoImportes[I] := CampoDouble(qCGEmpleados, 'facturacion');
      Inc(I);
      qCGEmpleados.Next;
    end;
    FCGEmpleadoCount := I;
    qCGEmpleados.First;
  finally
    qCGEmpleados.EnableControls;
  end;

  AjustarCampo(qCGEmpleados, 'empleado', 'Empleado / usuario', 32);
  AjustarCampoNumero(qCGEmpleados, 'tickets', 'Tickets', 8, '#,##0');
  AjustarCampoMoneda(qCGEmpleados, 'facturacion', 'Facturacion', 12);
  AjustarCampoMoneda(qCGEmpleados, 'ticket_medio', 'Ticket medio', 12);
end;

procedure TFDashboardProductividad.CargarCGAnalisis;
var
  L: TStringList;
  AD1, AD2, CD1, CD2: TDateTime;
  FactAct, FactComp, MargAct, MargComp, CliAct, CliComp, ArtAct, ArtComp, TicketsAct, TicketsComp, CestaAct, CestaComp: Double;
  PctFact, PctMarg, PctCli, PctArt, PctTickets, PctCesta, MargenPctAct, MargenPctComp: Double;
  I, HoraTopTickets, HoraTopImporte: Integer;
  TopTickets: Integer;
  TopImporte: Double;
  TopFamilia, TopMargenFamilia, TopEmpleado: string;
  TopFamiliaImp, TopMargenImp, TopEmpleadoImp: Double;

  function DifPct(const A, B: Double): Double;
  begin
    if Abs(B) < 0.0001 then
      Result := 0
    else
      Result := ((A - B) / B) * 100;
  end;

  function TxtPct(const P: Double): string;
  begin
    Result := FormatFloat('+#,##0.00;-#,##0.00;0.00', P) + '%';
  end;

  function Tendencia(const P: Double): string;
  begin
    if P > 3 then Result := 'sube'
    else if P < -3 then Result := 'baja'
    else Result := 'se mantiene';
  end;

  procedure LeerResumen;
  begin
    FactAct := 0; FactComp := 0; MargAct := 0; MargComp := 0; CliAct := 0; CliComp := 0;
    ArtAct := 0; ArtComp := 0; TicketsAct := 0; TicketsComp := 0; CestaAct := 0; CestaComp := 0;
    if (qCGResumen = nil) or (not qCGResumen.Active) then Exit;
    qCGResumen.DisableControls;
    try
      qCGResumen.First;
      while not qCGResumen.EOF do
      begin
        if SameText(qCGResumen.FieldByName('periodo').AsString, 'Actual') then
        begin
          FactAct := CampoDouble(qCGResumen, 'facturacion');
          MargAct := CampoDouble(qCGResumen, 'margen_indicativo');
          CliAct := CampoDouble(qCGResumen, 'clientes');
          ArtAct := CampoDouble(qCGResumen, 'articulos');
          TicketsAct := CampoDouble(qCGResumen, 'tickets');
          CestaAct := CampoDouble(qCGResumen, 'cesta_media');
        end
        else
        begin
          FactComp := CampoDouble(qCGResumen, 'facturacion');
          MargComp := CampoDouble(qCGResumen, 'margen_indicativo');
          CliComp := CampoDouble(qCGResumen, 'clientes');
          ArtComp := CampoDouble(qCGResumen, 'articulos');
          TicketsComp := CampoDouble(qCGResumen, 'tickets');
          CestaComp := CampoDouble(qCGResumen, 'cesta_media');
        end;
        qCGResumen.Next;
      end;
      qCGResumen.First;
    finally
      qCGResumen.EnableControls;
    end;
  end;

begin
  if memoCGAnalisis = nil then Exit;
  L := TStringList.Create;
  try
    if not CGFechasValidas(AD1, AD2, CD1, CD2) then
    begin
      L.Text := 'No se pueden interpretar los datos: revisa las fechas del cuadro.';
      memoCGAnalisis.Lines.Assign(L);
      Exit;
    end;

    LeerResumen;
    PctFact := DifPct(FactAct, FactComp);
    PctMarg := DifPct(MargAct, MargComp);
    PctCli := DifPct(CliAct, CliComp);
    PctArt := DifPct(ArtAct, ArtComp);
    PctTickets := DifPct(TicketsAct, TicketsComp);
    PctCesta := DifPct(CestaAct, CestaComp);
    MargenPctAct := 0;
    MargenPctComp := 0;
    if Abs(FactAct) > 0.0001 then MargenPctAct := (MargAct / FactAct) * 100;
    if Abs(FactComp) > 0.0001 then MargenPctComp := (MargComp / FactComp) * 100;

    HoraTopTickets := -1; TopTickets := 0;
    HoraTopImporte := -1; TopImporte := 0;
    for I := 0 to 23 do
    begin
      if FCGHoraTicketsAct[I] > TopTickets then
      begin
        TopTickets := FCGHoraTicketsAct[I];
        HoraTopTickets := I;
      end;
      if FCGHoraImportesAct[I] > TopImporte then
      begin
        TopImporte := FCGHoraImportesAct[I];
        HoraTopImporte := I;
      end;
    end;

    TopFamilia := '';
    TopFamiliaImp := 0;
    if FCGNegocioCount > 0 then
    begin
      TopFamilia := FCGNegocioNombres[0];
      TopFamiliaImp := FCGNegocioActual[0];
    end;
    TopMargenFamilia := '';
    TopMargenImp := 0;
    if FCGMargenCount > 0 then
    begin
      TopMargenFamilia := FCGMargenNombres[0];
      TopMargenImp := FCGMargenActual[0];
    end;
    TopEmpleado := '';
    TopEmpleadoImp := 0;
    if FCGEmpleadoCount > 0 then
    begin
      TopEmpleado := FCGEmpleadoNombres[0];
      TopEmpleadoImp := FCGEmpleadoImportes[0];
    end;

    L.Add('LECTURA DEL CUADRO');
    L.Add('Actual: ' + FormatDateTime('dd/mm/yyyy', AD1) + ' - ' + FormatDateTime('dd/mm/yyyy', AD2) +
          ' | Comparacion: ' + FormatDateTime('dd/mm/yyyy', CD1) + ' - ' + FormatDateTime('dd/mm/yyyy', CD2));
    L.Add('');
    L.Add('- Facturacion: ' + Dinero(FactAct) + ' frente a ' + Dinero(FactComp) +
          ' (' + TxtPct(PctFact) + '). La venta ' + Tendencia(PctFact) + '.');
    L.Add('- Margen indicativo: ' + Dinero(MargAct) + ' frente a ' + Dinero(MargComp) +
          ' (' + TxtPct(PctMarg) + '). Margen sobre venta actual: ' + FormatFloat('#,##0.00', MargenPctAct) + '%.');
    L.Add('- Clientes/tickets: clientes ' + TxtPct(PctCli) + ', tickets ' + TxtPct(PctTickets) +
          ', cesta media ' + Dinero(CestaAct) + ' (' + TxtPct(PctCesta) + ').');

    if HoraTopTickets >= 0 then
      L.Add('- Hora con mas tickets: ' + Format('%.2d:00', [HoraTopTickets]) + ' con ' + IntToStr(TopTickets) + ' tickets.');
    if HoraTopImporte >= 0 then
      L.Add('- Hora con mas facturacion: ' + Format('%.2d:00', [HoraTopImporte]) + ' con ' + Dinero(TopImporte) + '.');
    if TopFamilia <> '' then
      L.Add('- Familia con mas venta: ' + TopFamilia + ' (' + Dinero(TopFamiliaImp) + ').');
    if TopMargenFamilia <> '' then
      L.Add('- Familia con mas margen: ' + TopMargenFamilia + ' (' + Dinero(TopMargenImp) + ').');
    if TopEmpleado <> '' then
      L.Add('- Empleado/usuario con mas facturacion: ' + TopEmpleado + ' (' + Dinero(TopEmpleadoImp) + ').');

    L.Add('');
    L.Add('ACCIONES RECOMENDADAS');
    if PctMarg < PctFact - 5 then
      L.Add('1. Revisar descuentos, costes y articulos de bajo margen: la venta va mejor que el margen, por lo que puede haber perdida de rentabilidad.')
    else if MargenPctAct < 15 then
      L.Add('1. Margen global bajo: revisar precios de familias principales y posibles articulos vendidos por debajo de coste.')
    else
      L.Add('1. Margen razonable: mantener vigilancia sobre descuentos y costes anormales.');

    if PctCli < -5 then
      L.Add('2. Hay menos clientes que en la comparacion. Conviene revisar captacion, escaparate, promociones y horas con baja entrada.')
    else if PctCli > 5 then
      L.Add('2. La entrada de clientes mejora. Aprovechar las horas fuertes para tener reposicion y personal preparado.')
    else
      L.Add('2. Clientes estables. Usar las horas fuertes para reforzar reposicion y atencion.');

    if (PctCesta > 5) and (PctCli < 0) then
      L.Add('3. Menos clientes pero cesta mayor: el cliente que entra compra mas. Interesa atraer mas trafico sin bajar margen.')
    else if (PctCesta < -5) then
      L.Add('3. Baja la cesta media: revisar ventas cruzadas, promociones y exposicion de productos complementarios.')
    else
      L.Add('3. Cesta media estable: centrar mejora en familias, horarios y margen.');

    if HoraTopTickets >= 0 then
      L.Add('4. Planificar personal/reposicion antes de las ' + Format('%.2d:00', [HoraTopTickets]) + ', que es la franja con mas tickets.');
    if TopFamilia <> '' then
      L.Add('5. Revisar la familia principal (' + TopFamilia + '): si concentra mucha venta, asegurar stock y precio correcto.');
  finally
    memoCGAnalisis.Lines.Assign(L);
    L.Free;
  end;
end;

procedure TFDashboardProductividad.ActualizarTarjetasCG;
var
  FactAct, FactComp, MargAct, MargComp, CliAct, CliComp, ArtAct, ArtComp, CestaAct, CestaComp: Double;

  function FmtPct(const A, B: Double): string;
  var
    P: Double;
  begin
    if Abs(B) < 0.0001 then
      Result := ''
    else
    begin
      P := ((A - B) / B) * 100;
      Result := ' (' + FormatFloat('+#,##0.00;-#,##0.00;0.00', P) + '%)';
    end;
  end;

  procedure LeerResumen;
  begin
    FactAct := 0; FactComp := 0; MargAct := 0; MargComp := 0; CliAct := 0; CliComp := 0; ArtAct := 0; ArtComp := 0; CestaAct := 0; CestaComp := 0;
    if (qCGResumen = nil) or (not qCGResumen.Active) then Exit;
    qCGResumen.DisableControls;
    try
      qCGResumen.First;
      while not qCGResumen.EOF do
      begin
        if SameText(qCGResumen.FieldByName('periodo').AsString, 'Actual') then
        begin
          FactAct := CampoDouble(qCGResumen, 'facturacion');
          MargAct := CampoDouble(qCGResumen, 'margen_indicativo');
          CliAct := CampoDouble(qCGResumen, 'clientes');
          ArtAct := CampoDouble(qCGResumen, 'articulos');
          CestaAct := CampoDouble(qCGResumen, 'cesta_media');
        end
        else
        begin
          FactComp := CampoDouble(qCGResumen, 'facturacion');
          MargComp := CampoDouble(qCGResumen, 'margen_indicativo');
          CliComp := CampoDouble(qCGResumen, 'clientes');
          ArtComp := CampoDouble(qCGResumen, 'articulos');
          CestaComp := CampoDouble(qCGResumen, 'cesta_media');
        end;
        qCGResumen.Next;
      end;
      qCGResumen.First;
    finally
      qCGResumen.EnableControls;
    end;
  end;

begin
  LeerResumen;
  if lblCGFacturacion <> nil then lblCGFacturacion.Caption := Dinero(FactAct) + FmtPct(FactAct, FactComp);
  if lblCGMargen <> nil then lblCGMargen.Caption := Dinero(MargAct) + FmtPct(MargAct, MargComp);
  if lblCGClientes <> nil then lblCGClientes.Caption := FormatFloat('#,##0', CliAct) + FmtPct(CliAct, CliComp);
  if lblCGArticulos <> nil then lblCGArticulos.Caption := FormatFloat('#,##0.##', ArtAct) + FmtPct(ArtAct, ArtComp);
  if lblCGCesta <> nil then lblCGCesta.Caption := Dinero(CestaAct) + FmtPct(CestaAct, CestaComp);
end;

procedure TFDashboardProductividad.PintarBarrasComparativas(APaintBox: TPaintBox; const ATitulo, ALeg1, ALeg2: string; const ANombres: TString20Array; const AActual, AComp: TDouble20Array; ACount: Integer; const APrefijo, ASufijo: string);
var
  C: TCanvas;
  W,H,I,Y,LeftM,BarH,MaxNameW,PlotW,B1,B2: Integer;
  MaxV: Double;
  Nom, Val: string;
begin
  if APaintBox = nil then Exit;
  C := APaintBox.Canvas;
  W := APaintBox.Width;
  H := APaintBox.Height;
  C.Brush.Color := clWhite;
  C.FillRect(Rect(0,0,W,H));
  C.Font.Color := clBlack;
  C.Font.Style := [fsBold];
  C.TextOut(8,6,ATitulo);
  C.Font.Style := [];
  if ALeg2 <> '' then
    C.TextOut(W-210, 8, ALeg1 + ' / ' + ALeg2)
  else
    C.TextOut(W-120, 8, ALeg1);
  if ACount <= 0 then
  begin
    C.TextOut(12,34,'Sin datos para pintar.');
    Exit;
  end;
  MaxV := 0;
  for I := 0 to ACount-1 do
  begin
    if Abs(AActual[I]) > MaxV then MaxV := Abs(AActual[I]);
    if Abs(AComp[I]) > MaxV then MaxV := Abs(AComp[I]);
  end;
  if MaxV <= 0.004 then
  begin
    C.TextOut(12,34,'No hay importes en el periodo.');
    Exit;
  end;
  MaxNameW := 150;
  LeftM := MaxNameW + 8;
  PlotW := W - LeftM - 80;
  BarH := Max(8, (H - 42) div Max(ACount,1) div 2);
  for I := 0 to ACount-1 do
  begin
    Y := 32 + I * Max(18, BarH*2 + 5);
    if Y + BarH*2 > H-4 then Break;
    Nom := ANombres[I];
    if Length(Nom) > 24 then Nom := Copy(Nom,1,24);
    C.TextOut(4, Y, Nom);
    B1 := Round((Abs(AActual[I]) / MaxV) * PlotW);
    B2 := Round((Abs(AComp[I]) / MaxV) * PlotW);
    C.Brush.Color := clSkyBlue;
    C.Rectangle(LeftM, Y, LeftM+B1, Y+BarH);
    if ALeg2 <> '' then
    begin
      C.Brush.Color := clMoneyGreen;
      C.Rectangle(LeftM, Y+BarH+2, LeftM+B2, Y+BarH*2+2);
    end;
    C.Brush.Style := bsClear;
    Val := APrefijo + FormatFloat('#,##0.##', AActual[I]) + ASufijo;
    C.TextOut(LeftM+B1+4, Y-1, Val);
    C.Brush.Style := bsSolid;
  end;
end;

procedure TFDashboardProductividad.PintarBarrasHorasComparativas(APaintBox: TPaintBox; const ATitulo: string; const AAct, AComp: TIntegerHourArray);
var
  C: TCanvas;
  W,H,I,X,YBase,PlotTop,PlotH,PlotW,BarW,B1,B2,MaxV: Integer;
  Step: Double;

  procedure TextoVerticalClaro(const S: string; AX, ABarTop: Integer; AColor: TColor);
  var
    J, TW, TH, LabelW, LabelH, LY, OldSize: Integer;
    OldStyle: TFontStyles;
    OldColor: TColor;
  begin
    if S = '' then Exit;

    OldSize := C.Font.Size;
    OldStyle := C.Font.Style;
    OldColor := C.Font.Color;
    C.Font.Size := 8;
    C.Font.Style := [fsBold];
    TW := C.TextWidth('8');
    TH := C.TextHeight('8');
    LabelW := TW + 6;
    LabelH := Length(S) * TH + 4;

    // v36 fix2: los numeros horizontales se mezclaban cuando habia dos barras
    // juntas por hora. Se pintan en vertical y con fondo blanco para que la
    // lectura sea clara incluso en monitores pequenos o con muchos tickets.
    LY := ABarTop - LabelH - 2;
    if LY < 22 then
      LY := 22;
    if AX + LabelW > W - 2 then
      AX := W - LabelW - 2;
    if AX < 2 then
      AX := 2;

    C.Brush.Color := clWhite;
    C.Pen.Color := clSilver;
    C.Rectangle(AX, LY, AX + LabelW, LY + LabelH);
    C.Brush.Style := bsClear;
    C.Font.Color := AColor;
    for J := 1 to Length(S) do
      C.TextOut(AX + 3, LY + 2 + (J-1) * TH, S[J]);
    C.Brush.Style := bsSolid;
    C.Font.Size := OldSize;
    C.Font.Style := OldStyle;
    C.Font.Color := OldColor;
  end;

begin
  if APaintBox = nil then Exit;
  C := APaintBox.Canvas;
  W := APaintBox.Width;
  H := APaintBox.Height;
  C.Brush.Color := clWhite;
  C.FillRect(Rect(0,0,W,H));
  C.Font.Color := clBlack;
  C.Font.Style := [fsBold];
  C.TextOut(8,6,ATitulo);
  C.Font.Style := [];
  MaxV := 0;
  for I := 0 to 23 do
  begin
    if AAct[I] > MaxV then MaxV := AAct[I];
    if AComp[I] > MaxV then MaxV := AComp[I];
  end;
  if MaxV <= 0 then
  begin
    C.TextOut(12,34,'Sin tickets en los periodos.');
    Exit;
  end;

  // Mas margen superior para numeros verticales y legibles.
  PlotTop := 58;
  YBase := H - 34;
  PlotH := Max(10, YBase - PlotTop - 10);
  PlotW := W - 44;
  Step := PlotW / 24;
  BarW := Max(5, Round(Step / 3));

  // Leyenda sencilla.
  C.Brush.Color := clSkyBlue;
  C.Rectangle(W-190, 10, W-178, 22);
  C.TextOut(W-174, 8, 'Actual');
  C.Brush.Color := clMoneyGreen;
  C.Rectangle(W-112, 10, W-100, 22);
  C.TextOut(W-96, 8, 'Comparacion');

  C.Pen.Color := clGray;
  C.Line(28, PlotTop, 28, YBase);
  C.Line(28, YBase, W-8, YBase);
  for I := 0 to 23 do
  begin
    X := 30 + Round(I * Step);
    B1 := Round((AAct[I] / MaxV) * PlotH);
    B2 := Round((AComp[I] / MaxV) * PlotH);

    C.Brush.Color := clSkyBlue;
    C.Rectangle(X, YBase-B1, X+BarW, YBase);
    C.Brush.Color := clMoneyGreen;
    C.Rectangle(X+BarW+2, YBase-B2, X+BarW*2+2, YBase);

    if (I mod 2)=0 then
      C.TextOut(X-2, YBase+4, IntToStr(I));

    if AAct[I] > 0 then
      TextoVerticalClaro(IntToStr(AAct[I]), X + (BarW div 2) - 5, YBase-B1, clNavy);

    if AComp[I] > 0 then
      TextoVerticalClaro(IntToStr(AComp[I]), X + BarW + 2 + (BarW div 2) - 5, YBase-B2, clGreen);
  end;
end;

procedure TFDashboardProductividad.PintarCGNegocio(Sender: TObject);
begin
  PintarBarrasComparativas(Sender as TPaintBox, 'Cifra de negocio por negocio', 'Actual', 'Comparacion', FCGNegocioNombres, FCGNegocioActual, FCGNegocioComp, FCGNegocioCount, '', '');
end;

procedure TFDashboardProductividad.PintarCGHoras(Sender: TObject);
begin
  PintarBarrasHorasComparativas(Sender as TPaintBox, 'Frecuencia clientes / tickets por hora', FCGHoraTicketsAct, FCGHoraTicketsComp);
end;

procedure TFDashboardProductividad.PintarCGMargen(Sender: TObject);
begin
  PintarBarrasComparativas(Sender as TPaintBox, 'Margen indicativo por negocio', 'Actual', 'Comparacion', FCGMargenNombres, FCGMargenActual, FCGMargenComp, FCGMargenCount, '', '');
end;

procedure TFDashboardProductividad.PintarCGEmpleados(Sender: TObject);
var
  Zeros: TDouble20Array;
  I: Integer;
begin
  for I := 0 to 19 do Zeros[I] := 0;
  PintarBarrasComparativas(Sender as TPaintBox, 'Empleados / cifra de negocio', 'Actual', '', FCGEmpleadoNombres, FCGEmpleadoImportes, Zeros, FCGEmpleadoCount, '', '');
end;

procedure TFDashboardProductividad.CargarVentasAbiertas;
begin
  CargarVNAResumen;
  CargarVNATickets;
  CargarVNADetalle;
  CargarVNAHoras;
  CargarVNARevision;
end;

procedure TFDashboardProductividad.CargarVNAResumen;
var
  U: string;
begin
  U := SQLUnionVentasAbiertas;
  qVNAResumen.Close;
  if U = '' then
    qVNAResumen.SQL.Text := 'SELECT ''No se han encontrado tablas ventas' + FTienda + 'A-H'' AS aviso'
  else
    qVNAResumen.SQL.Text :=
      'SELECT caja, tabla, ' +
      'COUNT(DISTINCT CONCAT(ticket0,''/'',ticket)) AS ventas_abiertas, ' +
      'COUNT(*) AS lineas, ' +
      'SUM(unidades) AS unidades, ' +
      'SUM(total_linea) AS importe_total, ' +
      'MIN(fecha_linea) AS primera_fecha, ' +
      'MAX(fecha_linea) AS ultima_fecha, ' +
      'MIN(hora_linea) AS primera_hora, ' +
      'MAX(hora_linea) AS ultima_hora, ' +
      'SUM(CASE WHEN hora_linea = ''NO DISPONIBLE'' THEN 1 ELSE 0 END) AS lineas_sin_hora ' +
      'FROM (' + U + ') X ' +
      'GROUP BY caja, tabla ' +
      'ORDER BY caja';
  qVNAResumen.Open;
end;

procedure TFDashboardProductividad.CargarVNATickets;
var
  U: string;
begin
  U := SQLUnionVentasAbiertas;
  qVNATickets.Close;
  if U = '' then
    qVNATickets.SQL.Text := 'SELECT ''No se han encontrado ventas abiertas'' AS aviso'
  else
    qVNATickets.SQL.Text :=
      'SELECT caja, ticket0, ticket, ' +
      'COUNT(*) AS lineas, ' +
      'SUM(unidades) AS unidades, ' +
      'SUM(total_linea) AS importe_total, ' +
      'MIN(fecha_linea) AS primera_fecha, ' +
      'MAX(fecha_linea) AS ultima_fecha, ' +
      'MIN(hora_linea) AS primera_hora, ' +
      'MAX(hora_linea) AS ultima_hora, ' +
      'SUM(CASE WHEN hora_linea = ''NO DISPONIBLE'' THEN 1 ELSE 0 END) AS lineas_sin_hora ' +
      'FROM (' + U + ') X ' +
      'GROUP BY caja, ticket0, ticket ' +
      'ORDER BY caja, primera_fecha, primera_hora, ticket0, ticket';
  qVNATickets.Open;
end;

procedure TFDashboardProductividad.CargarVNADetalle;
var
  U: string;
begin
  U := SQLUnionVentasAbiertas;
  qVNADetalle.Close;
  if U = '' then
    qVNADetalle.SQL.Text := 'SELECT ''No se han encontrado ventas abiertas'' AS aviso'
  else
    qVNADetalle.SQL.Text :=
      'SELECT caja, fecha_linea, hora_linea, ticket0, ticket, linea, codigo, descripcion, ' +
      'unidades, pvp, dto, importe, iva, total_linea, cliente, marcada ' +
      'FROM (' + U + ') X ' +
      'ORDER BY caja, fecha_linea, CASE WHEN hora_linea = ''NO DISPONIBLE'' THEN 1 ELSE 0 END, hora_linea, ticket0, ticket, linea';
  qVNADetalle.Open;
end;

procedure TFDashboardProductividad.CargarVNAHoras;
var
  U: string;
begin
  U := SQLUnionVentasAbiertas;
  qVNAHoras.Close;
  if U = '' then
    qVNAHoras.SQL.Text := 'SELECT ''No se han encontrado ventas abiertas'' AS aviso'
  else
    qVNAHoras.SQL.Text :=
      'SELECT caja, fecha_linea, ' +
      'CASE WHEN hora_linea = ''NO DISPONIBLE'' THEN ''NO DISPONIBLE'' ELSE LEFT(hora_linea,2) END AS hora, ' +
      'COUNT(DISTINCT CONCAT(ticket0,''/'',ticket)) AS ventas_abiertas, ' +
      'COUNT(*) AS lineas, ' +
      'SUM(unidades) AS unidades, ' +
      'SUM(total_linea) AS importe_total ' +
      'FROM (' + U + ') X ' +
      'GROUP BY caja, fecha_linea, CASE WHEN hora_linea = ''NO DISPONIBLE'' THEN ''NO DISPONIBLE'' ELSE LEFT(hora_linea,2) END ' +
      'ORDER BY caja, fecha_linea, hora';
  qVNAHoras.Open;
end;

procedure TFDashboardProductividad.CargarVNARevision;
var
  U: string;
begin
  U := SQLUnionVentasAbiertas;
  qVNARevision.Close;
  if U = '' then
    qVNARevision.SQL.Text := 'SELECT ''No se han encontrado ventas abiertas'' AS aviso'
  else
    qVNARevision.SQL.Text :=
      'SELECT caja, fecha_linea, hora_linea, ticket0, ticket, linea, codigo, descripcion, unidades, total_linea, ' +
      'CASE ' +
      'WHEN hora_linea = ''NO DISPONIBLE'' THEN ''Sin hora de linea'' ' +
      'WHEN codigo = '''' THEN ''Sin codigo'' ' +
      'WHEN total_linea < 0 THEN ''Importe negativo'' ' +
      'WHEN total_linea = 0 THEN ''Importe cero'' ' +
      'WHEN dto <> 0 THEN ''Con descuento'' ' +
      'ELSE ''Revisar'' END AS motivo ' +
      'FROM (' + U + ') X ' +
      'WHERE hora_linea = ''NO DISPONIBLE'' OR codigo = '''' OR total_linea <= 0 OR dto <> 0 ' +
      'ORDER BY caja, fecha_linea, CASE WHEN hora_linea = ''NO DISPONIBLE'' THEN 1 ELSE 0 END, hora_linea, ticket0, ticket, linea';
  qVNARevision.Open;
end;

procedure TFDashboardProductividad.CargarCierreTarde;
begin
  CargarCTSugerencia;
  CargarCTResumen;
  CargarCTDias;
  CargarCTCandidatos;
  CargarCTSemana;
  CargarCTHoras;
end;

procedure TFDashboardProductividad.CargarCTSugerencia;
type
  TDiaCierre = record
    FechaHist: TDateTime;
    FechaObjetivo: TDateTime;
    DiaSemana: string;
    TicketsTotal: Integer;
    VentasTotal: Double;
    TicketsTarde: Integer;
    VentasTarde: Double;
    PctTarde: Double;
    Score: Double;
  end;
var
  ADesde, AHasta: TDateTime;
  HistDesde, HistHasta, ObjDesde, ObjHasta: TDateTime;
  HoySistema, ProgDesde, ProgHasta: TDateTime;
  AnyoActual, AnyoSel, AnyoHist, AnyoObj: Integer;
  Q: TZQuery;
  Dias: array of TDiaCierre;
  I, J, N, WindowLen: Integer;
  WorkDays, BestWorkDays, TotalDiasAgosto: Integer;
  SumVentasTarde, SumTicketsTarde, SumPctTarde: Double;
  AvgVentasTarde, AvgTicketsTarde, AvgPctTarde: Double;
  VentasProgAct, VentasProgAnt, TicketsProgAct, TicketsProgAnt: Double;
  FactorVentas, FactorTickets, BestScore, S, ScoreBloque: Double;
  DiasHastaInicio, DiasAgostoTranscurridos, Fiabilidad: Integer;
  BestDesde, BestHasta, CandDesde, CandHasta: TDateTime;
  TopTxt, Linea, Motivo, TextoProg: string;
begin
  if memoCTSugerencia = nil then Exit;
  memoCTSugerencia.Clear;

  ADesde := FechaDesde;
  AHasta := FechaHasta;
  HoySistema := SysUtils.Date;
  AnyoActual := YearOf(HoySistema);
  AnyoSel := YearOf(ADesde);

  // Esta pestaña esta pensada para decidir cierres de tarde de AGOSTO.
  // Aunque el filtro general tenga otro periodo o un ano completo, la sugerencia inteligente
  // se centra siempre en Agosto para evitar que sabados/domingos de todo el ano falseen el resultado.
  if AnyoSel < AnyoActual then
  begin
    AnyoHist := AnyoSel;
    AnyoObj := AnyoActual;
  end
  else
  begin
    AnyoObj := AnyoSel;
    AnyoHist := AnyoObj - 1;
  end;

  HistDesde := EncodeDate(AnyoHist, 8, 1);
  HistHasta := EncodeDate(AnyoHist, 8, 31);
  ObjDesde := EncodeDate(AnyoObj, 8, 1);
  ObjHasta := EncodeDate(AnyoObj, 8, 31);

  Q := CrearQuery;
  try
    Q.SQL.Text :=
      'SELECT HO0 AS fecha0, ' +
      '       ELT(WEEKDAY(HO0)+1,''Lunes'',''Martes'',''Miercoles'',''Jueves'',''Viernes'',''Sabado'',''Domingo'') AS dia_semana, ' +
      '       COUNT(*) AS tickets_total, ' +
      '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS ventas_total, ' +
      '       SUM(IF(HOUR(HO1) >= 15, 1, 0)) AS tickets_tarde, ' +
      '       ROUND(COALESCE(SUM(IF(HOUR(HO1) >= 15, IF(COALESCE(HO11,0) <> 0, HO11, HO9), 0)),0),2) AS ventas_tarde, ' +
      '       ROUND((COALESCE(SUM(IF(HOUR(HO1) >= 15, IF(COALESCE(HO11,0) <> 0, HO11, HO9), 0)),0) / NULLIF(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),0)) * 100, 2) AS pct_tarde ' +
      'FROM ' + Tabla('hisopcc') + ' ' +
      'WHERE HO0 BETWEEN :desde AND :hasta ' +
      '  AND WEEKDAY(HO0) BETWEEN 0 AND 4 ' +
      '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
      '  AND COALESCE(HO16, '''') <> ''A'' ' +
      'GROUP BY HO0 ORDER BY HO0';
    Q.ParamByName('desde').AsDateTime := HistDesde;
    Q.ParamByName('hasta').AsDateTime := HistHasta;
    Q.Open;

    while not Q.EOF do
    begin
      N := Length(Dias);
      SetLength(Dias, N + 1);
      Dias[N].FechaHist := Trunc(Q.FieldByName('fecha0').AsDateTime);
      Dias[N].FechaObjetivo := IncYear(Dias[N].FechaHist, AnyoObj - YearOf(Dias[N].FechaHist));
      Dias[N].DiaSemana := Q.FieldByName('dia_semana').AsString;
      Dias[N].TicketsTotal := CampoInteger(Q, 'tickets_total');
      Dias[N].VentasTotal := CampoDouble(Q, 'ventas_total');
      Dias[N].TicketsTarde := CampoInteger(Q, 'tickets_tarde');
      Dias[N].VentasTarde := CampoDouble(Q, 'ventas_tarde');
      Dias[N].PctTarde := CampoDouble(Q, 'pct_tarde');
      Q.Next;
    end;
    Q.Close;

    if Length(Dias) = 0 then
    begin
      memoCTSugerencia.Lines.Add('No hay datos de Agosto laborable para calcular la sugerencia.');
      memoCTSugerencia.Lines.Add('La sugerencia IA usa Agosto y dias de lunes a viernes. Revisa que haya ventas historicas en Agosto del ano anterior.');
      Exit;
    end;

    SumVentasTarde := 0;
    SumTicketsTarde := 0;
    SumPctTarde := 0;
    for I := 0 to High(Dias) do
    begin
      SumVentasTarde := SumVentasTarde + Dias[I].VentasTarde;
      SumTicketsTarde := SumTicketsTarde + Dias[I].TicketsTarde;
      SumPctTarde := SumPctTarde + Dias[I].PctTarde;
    end;

    AvgVentasTarde := SumVentasTarde / Length(Dias);
    AvgTicketsTarde := SumTicketsTarde / Length(Dias);
    AvgPctTarde := SumPctTarde / Length(Dias);
    if AvgVentasTarde <= 0 then AvgVentasTarde := 1;
    if AvgTicketsTarde <= 0 then AvgTicketsTarde := 1;
    if AvgPctTarde <= 0 then AvgPctTarde := 1;

    // Factor de progresion:
    // - Si ya estamos en Agosto del ano objetivo, compara Agosto real transcurrido contra Agosto anterior.
    // - Antes de Agosto, usa los ultimos 60 dias laborables como tendencia aproximada.
    // - Despues de Agosto, usa todo Agosto real del ano objetivo.
    FactorVentas := 1;
    FactorTickets := 1;
    TextoProg := 'Tendencia aplicada: x1.00';

    if (AnyoActual = AnyoObj) and (HoySistema >= ObjDesde) then
    begin
      ProgDesde := ObjDesde;
      if HoySistema <= ObjHasta then
        ProgHasta := IncDay(HoySistema, -1)
      else
        ProgHasta := ObjHasta;
      TextoProg := 'Progresion Agosto real';
    end
    else
    begin
      ProgHasta := IncDay(HoySistema, -1);
      ProgDesde := IncDay(ProgHasta, -60);
      if ProgDesde < EncodeDate(AnyoActual, 1, 1) then
        ProgDesde := EncodeDate(AnyoActual, 1, 1);
      TextoProg := 'Progresion ultimos 60 dias laborables';
    end;

    if ProgDesde <= ProgHasta then
    begin
      Q.SQL.Text :=
        'SELECT ROUND(COALESCE(SUM(IF(HOUR(HO1) >= 15, IF(COALESCE(HO11,0) <> 0, HO11, HO9), 0)),0),2) AS ventas_tarde, ' +
        '       SUM(IF(HOUR(HO1) >= 15, 1, 0)) AS tickets_tarde ' +
        'FROM ' + Tabla('hisopcc') + ' ' +
        'WHERE HO0 BETWEEN :desde AND :hasta ' +
        '  AND WEEKDAY(HO0) BETWEEN 0 AND 4 ' +
        '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
        '  AND COALESCE(HO16, '''') <> ''A''';
      Q.ParamByName('desde').AsDateTime := ProgDesde;
      Q.ParamByName('hasta').AsDateTime := ProgHasta;
      Q.Open;
      VentasProgAct := CampoDouble(Q, 'ventas_tarde');
      TicketsProgAct := CampoDouble(Q, 'tickets_tarde');
      Q.Close;

      Q.ParamByName('desde').AsDateTime := IncYear(ProgDesde, -1);
      Q.ParamByName('hasta').AsDateTime := IncYear(ProgHasta, -1);
      Q.Open;
      VentasProgAnt := CampoDouble(Q, 'ventas_tarde');
      TicketsProgAnt := CampoDouble(Q, 'tickets_tarde');
      Q.Close;

      if VentasProgAnt > 0 then
        FactorVentas := EnsureRange(VentasProgAct / VentasProgAnt, 0.60, 1.60);
      if TicketsProgAnt > 0 then
        FactorTickets := EnsureRange(TicketsProgAct / TicketsProgAnt, 0.60, 1.60);
    end;

    for I := 0 to High(Dias) do
    begin
      Dias[I].Score :=
        ((Dias[I].VentasTarde * FactorVentas) / AvgVentasTarde) * 0.55 +
        ((Dias[I].TicketsTarde * FactorTickets) / AvgTicketsTarde) * 0.30 +
        (Dias[I].PctTarde / AvgPctTarde) * 0.15;
      if Dias[I].TicketsTarde = 0 then
        Dias[I].Score := Dias[I].Score * 0.65;
    end;

    // No buscar ya "dias sueltos" ni 15 laborables saltando fines de semana,
    // porque eso puede dejar lunes aislados abiertos dentro de una quincena floja.
    // Para decisiones reales de horario es mejor proponer un TRAMO CONTINUO
    // de calendario de Agosto y cerrar todas las tardes laborables incluidas.
    WindowLen := 15; // dias naturales de calendario, no 15 dias laborables sueltos
    TotalDiasAgosto := DaysBetween(ObjDesde, ObjHasta) + 1;
    BestScore := 1.0E308;
    BestDesde := ObjDesde;
    BestHasta := IncDay(ObjDesde, WindowLen - 1);
    BestWorkDays := 0;

    for I := 0 to TotalDiasAgosto - 1 do
    begin
      CandDesde := IncDay(ObjDesde, I);
      CandHasta := IncDay(CandDesde, WindowLen - 1);
      if CandHasta > ObjHasta then
        CandHasta := ObjHasta;

      S := 0;
      WorkDays := 0;
      for J := 0 to High(Dias) do
      begin
        if (Dias[J].FechaObjetivo >= CandDesde) and (Dias[J].FechaObjetivo <= CandHasta) then
        begin
          S := S + Dias[J].Score;
          Inc(WorkDays);
        end;
      end;

      // Evitar tramos demasiado cortos a final de mes o bloques poco representativos.
      if WorkDays < 8 then
        Continue;

      ScoreBloque := S / WorkDays;

      // Preferencia ligera por bloques naturales que empiezan en lunes.
      // No manda sobre la venta, solo desempata para que la sugerencia sea mas coherente.
      if DayOfTheWeek(CandDesde) <> 1 then
        ScoreBloque := ScoreBloque * 1.03;

      if ScoreBloque < BestScore then
      begin
        BestScore := ScoreBloque;
        BestDesde := CandDesde;
        BestHasta := CandHasta;
        BestWorkDays := WorkDays;
      end;
    end;

    TopTxt := '';
    // Mostrar las tardes laborables incluidas dentro del bloque recomendado,
    // no una lista de dias sueltos que pueda inducir a abrir un lunes aislado.
    for N := 0 to High(Dias) do
    begin
      if (Dias[N].FechaObjetivo >= BestDesde) and (Dias[N].FechaObjetivo <= BestHasta) then
      begin
        if TopTxt <> '' then TopTxt := TopTxt + ', ';
        TopTxt := TopTxt + FormatDateTime('dd/mm', Dias[N].FechaObjetivo) + ' ' + Dias[N].DiaSemana;
      end;
    end;

    DiasHastaInicio := DaysBetween(HoySistema, ObjDesde);
    if (AnyoActual = AnyoObj) and (HoySistema >= ObjDesde) and (HoySistema <= ObjHasta) then
    begin
      DiasAgostoTranscurridos := DaysBetween(ObjDesde, HoySistema);
      Fiabilidad := Round(EnsureRange(70.0 + (DiasAgostoTranscurridos * 0.8), 70.0, 92.0));
    end
    else if ObjDesde < HoySistema then
      Fiabilidad := 90
    else
      Fiabilidad := Round(EnsureRange(55.0 + ((60.0 - EnsureRange(DiasHastaInicio, 0, 60)) * 0.5), 55.0, 85.0));

    memoCTSugerencia.Lines.Add('Modo Agosto: la IA usa SOLO Agosto y solo dias de lunes a viernes. Sabados y domingos se excluyen para no falsear la recomendacion.');
    memoCTSugerencia.Lines.Add('Base historica: Agosto ' + IntToStr(AnyoHist) + '  |  Periodo objetivo: Agosto ' + IntToStr(AnyoObj));
    memoCTSugerencia.Lines.Add(TextoProg + ': ventas tarde x' + FormatFloat('0.00', FactorVentas) +
      ', tickets tarde x' + FormatFloat('0.00', FactorTickets) + '  |  Fiabilidad orientativa: ' + IntToStr(Fiabilidad) + '%');

    if BestWorkDays > 0 then
    begin
      Linea := 'Sugerencia principal: cerrar por la tarde el tramo continuo del ' +
        FormatDateTime('dd/mm/yyyy', BestDesde) + ' al ' +
        FormatDateTime('dd/mm/yyyy', BestHasta) +
        ' (' + IntToStr(BestWorkDays) + ' tardes laborables incluidas).';
      memoCTSugerencia.Lines.Add(Linea);
    end;

    Motivo := 'Motivo: se prioriza un bloque continuo de Agosto, no dias sueltos. Si una quincena sale floja, es mas coherente cerrar tambien los lunes laborables incluidos en ese tramo.';
    memoCTSugerencia.Lines.Add(Motivo);
    if TopTxt <> '' then
      memoCTSugerencia.Lines.Add('Tardes laborables incluidas en el bloque: ' + TopTxt + '.');
    memoCTSugerencia.Lines.Add('Revisar antes de decidir: festivos locales, personal, proveedores, promociones, climatologia, turismo y video-vigilancia.');
  finally
    Q.Free;
  end;
end;

procedure TFDashboardProductividad.CargarCTResumen;
begin
  qCTResumen.Close;
  qCTResumen.SQL.Text :=
    'SELECT DATE_FORMAT(MIN(HO0), ''%d/%m/%Y'') AS primera_fecha, ' +
    '       DATE_FORMAT(MAX(HO0), ''%d/%m/%Y'') AS ultima_fecha, ' +
    '       COUNT(*) AS tickets_total, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS ventas_total, ' +
    '       SUM(IF(HOUR(HO1) >= 15, 1, 0)) AS tickets_tarde, ' +
    '       ROUND(COALESCE(SUM(IF(HOUR(HO1) >= 15, IF(COALESCE(HO11,0) <> 0, HO11, HO9), 0)),0),2) AS ventas_tarde, ' +
    '       ROUND((COALESCE(SUM(IF(HOUR(HO1) >= 15, IF(COALESCE(HO11,0) <> 0, HO11, HO9), 0)),0) / NULLIF(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),0)) * 100, 2) AS pct_importe_tarde, ' +
    '       ROUND((SUM(IF(HOUR(HO1) >= 15, 1, 0)) / NULLIF(COUNT(*),0)) * 100, 2) AS pct_tickets_tarde, ' +
    '       ROUND(COALESCE(SUM(IF(HOUR(HO1) >= 15, IF(COALESCE(HO11,0) <> 0, HO11, HO9), 0)),0) / NULLIF(COUNT(DISTINCT HO0),0),2) AS media_tarde_dia, ' +
    '       ''Tarde desde las 15:00. Para estudiar Agosto, selecciona 01/08 a 31/08 del ano anterior.'' AS criterio ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta ' +
    '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '  AND COALESCE(HO16, '''') <> ''A''';
  qCTResumen.ParamByName('desde').AsDateTime := FechaDesde;
  qCTResumen.ParamByName('hasta').AsDateTime := FechaHasta;
  qCTResumen.Open;

  AjustarCampo(qCTResumen, 'primera_fecha', 'Primera fecha', 12);
  AjustarCampo(qCTResumen, 'ultima_fecha', 'Ultima fecha', 12);
  AjustarCampo(qCTResumen, 'tickets_total', 'Tickets total', 10);
  AjustarCampoMoneda(qCTResumen, 'ventas_total', 'Ventas total', 13);
  AjustarCampo(qCTResumen, 'tickets_tarde', 'Tickets tarde', 10);
  AjustarCampoMoneda(qCTResumen, 'ventas_tarde', 'Ventas tarde', 13);
  AjustarCampoNumero(qCTResumen, 'pct_importe_tarde', '% imp. tarde', 11, '#,##0.00 %');
  AjustarCampoNumero(qCTResumen, 'pct_tickets_tarde', '% tickets tarde', 12, '#,##0.00 %');
  AjustarCampoMoneda(qCTResumen, 'media_tarde_dia', 'Media tarde/dia', 13);
  AjustarCampo(qCTResumen, 'criterio', 'Criterio', 55);
end;

procedure TFDashboardProductividad.CargarCTDias;
begin
  qCTDias.Close;
  qCTDias.SQL.Text :=
    'SELECT DATE_FORMAT(fecha0, ''%d/%m/%Y'') AS fecha, dia_semana, ' +
    '       tickets_total, ventas_total, tickets_manana, ventas_manana, ' +
    '       tickets_tarde, ventas_tarde, ticket_medio_tarde, pct_tarde, ' +
    '       CASE ' +
    '         WHEN tickets_tarde = 0 THEN ''Cierre tarde muy claro'' ' +
    '         WHEN tickets_tarde <= 3 AND pct_tarde <= 10 THEN ''Candidato fuerte'' ' +
    '         WHEN pct_tarde <= 15 THEN ''Candidato posible'' ' +
    '         ELSE ''Mantener / revisar'' END AS sugerencia ' +
    'FROM ( ' +
    '  SELECT HO0 AS fecha0, ' +
    '         ELT(WEEKDAY(HO0)+1,''Lunes'',''Martes'',''Miercoles'',''Jueves'',''Viernes'',''Sabado'',''Domingo'') AS dia_semana, ' +
    '         COUNT(*) AS tickets_total, ' +
    '         ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS ventas_total, ' +
    '         SUM(IF(HOUR(HO1) < 15, 1, 0)) AS tickets_manana, ' +
    '         ROUND(COALESCE(SUM(IF(HOUR(HO1) < 15, IF(COALESCE(HO11,0) <> 0, HO11, HO9), 0)),0),2) AS ventas_manana, ' +
    '         SUM(IF(HOUR(HO1) >= 15, 1, 0)) AS tickets_tarde, ' +
    '         ROUND(COALESCE(SUM(IF(HOUR(HO1) >= 15, IF(COALESCE(HO11,0) <> 0, HO11, HO9), 0)),0),2) AS ventas_tarde, ' +
    '         ROUND(COALESCE(AVG(IF(HOUR(HO1) >= 15, IF(COALESCE(HO11,0) <> 0, HO11, HO9), NULL)),0),2) AS ticket_medio_tarde, ' +
    '         ROUND((COALESCE(SUM(IF(HOUR(HO1) >= 15, IF(COALESCE(HO11,0) <> 0, HO11, HO9), 0)),0) / NULLIF(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),0)) * 100, 2) AS pct_tarde ' +
    '  FROM ' + Tabla('hisopcc') + ' ' +
    '  WHERE HO0 BETWEEN :desde AND :hasta ' +
    '    AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '    AND COALESCE(HO16, '''') <> ''A'' ' +
    '  GROUP BY HO0 ' +
    ') D ORDER BY fecha0';
  qCTDias.ParamByName('desde').AsDateTime := FechaDesde;
  qCTDias.ParamByName('hasta').AsDateTime := FechaHasta;
  qCTDias.Open;

  AjustarCampo(qCTDias, 'fecha', 'Fecha', 11);
  AjustarCampo(qCTDias, 'dia_semana', 'Dia', 10);
  AjustarCampo(qCTDias, 'tickets_total', 'Tickets total', 10);
  AjustarCampoMoneda(qCTDias, 'ventas_total', 'Ventas total', 12);
  AjustarCampo(qCTDias, 'tickets_manana', 'Tickets manana', 11);
  AjustarCampoMoneda(qCTDias, 'ventas_manana', 'Ventas manana', 12);
  AjustarCampo(qCTDias, 'tickets_tarde', 'Tickets tarde', 10);
  AjustarCampoMoneda(qCTDias, 'ventas_tarde', 'Ventas tarde', 12);
  AjustarCampoMoneda(qCTDias, 'ticket_medio_tarde', 'Ticket medio tarde', 14);
  AjustarCampoNumero(qCTDias, 'pct_tarde', '% tarde', 9, '#,##0.00 %');
  AjustarCampo(qCTDias, 'sugerencia', 'Sugerencia', 18);
end;

procedure TFDashboardProductividad.CargarCTCandidatos;
begin
  qCTCandidatos.Close;
  qCTCandidatos.SQL.Text :=
    'SELECT DATE_FORMAT(fecha0, ''%d/%m/%Y'') AS fecha, dia_semana, ' +
    '       tickets_tarde, ventas_tarde, pct_tarde, tickets_total, ventas_total, ' +
    '       ''Revisar video, personal y eventos antes de decidir'' AS observacion ' +
    'FROM ( ' +
    '  SELECT HO0 AS fecha0, ' +
    '         ELT(WEEKDAY(HO0)+1,''Lunes'',''Martes'',''Miercoles'',''Jueves'',''Viernes'',''Sabado'',''Domingo'') AS dia_semana, ' +
    '         COUNT(*) AS tickets_total, ' +
    '         ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS ventas_total, ' +
    '         SUM(IF(HOUR(HO1) >= 15, 1, 0)) AS tickets_tarde, ' +
    '         ROUND(COALESCE(SUM(IF(HOUR(HO1) >= 15, IF(COALESCE(HO11,0) <> 0, HO11, HO9), 0)),0),2) AS ventas_tarde, ' +
    '         ROUND((COALESCE(SUM(IF(HOUR(HO1) >= 15, IF(COALESCE(HO11,0) <> 0, HO11, HO9), 0)),0) / NULLIF(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),0)) * 100, 2) AS pct_tarde ' +
    '  FROM ' + Tabla('hisopcc') + ' ' +
    '  WHERE HO0 BETWEEN :desde AND :hasta ' +
    '    AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '    AND COALESCE(HO16, '''') <> ''A'' ' +
    '  GROUP BY HO0 ' +
    ') D ORDER BY ventas_tarde, tickets_tarde, pct_tarde, fecha0 LIMIT 15';
  qCTCandidatos.ParamByName('desde').AsDateTime := FechaDesde;
  qCTCandidatos.ParamByName('hasta').AsDateTime := FechaHasta;
  qCTCandidatos.Open;

  AjustarCampo(qCTCandidatos, 'fecha', 'Fecha', 11);
  AjustarCampo(qCTCandidatos, 'dia_semana', 'Dia', 10);
  AjustarCampo(qCTCandidatos, 'tickets_tarde', 'Tickets tarde', 10);
  AjustarCampoMoneda(qCTCandidatos, 'ventas_tarde', 'Ventas tarde', 12);
  AjustarCampoNumero(qCTCandidatos, 'pct_tarde', '% tarde', 9, '#,##0.00 %');
  AjustarCampo(qCTCandidatos, 'tickets_total', 'Tickets total', 10);
  AjustarCampoMoneda(qCTCandidatos, 'ventas_total', 'Ventas total', 12);
  AjustarCampo(qCTCandidatos, 'observacion', 'Observacion', 36);
end;

procedure TFDashboardProductividad.CargarCTSemana;
begin
  qCTSemana.Close;
  qCTSemana.SQL.Text :=
    'SELECT dia_semana, dias, tickets_total, ventas_total, tickets_tarde, ventas_tarde, ' +
    '       ROUND(ventas_tarde / NULLIF(dias,0),2) AS media_tarde_dia, pct_tarde ' +
    'FROM ( ' +
    '  SELECT WEEKDAY(HO0) AS orden_dia, ' +
    '         ELT(WEEKDAY(HO0)+1,''Lunes'',''Martes'',''Miercoles'',''Jueves'',''Viernes'',''Sabado'',''Domingo'') AS dia_semana, ' +
    '         COUNT(DISTINCT HO0) AS dias, COUNT(*) AS tickets_total, ' +
    '         ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS ventas_total, ' +
    '         SUM(IF(HOUR(HO1) >= 15, 1, 0)) AS tickets_tarde, ' +
    '         ROUND(COALESCE(SUM(IF(HOUR(HO1) >= 15, IF(COALESCE(HO11,0) <> 0, HO11, HO9), 0)),0),2) AS ventas_tarde, ' +
    '         ROUND((COALESCE(SUM(IF(HOUR(HO1) >= 15, IF(COALESCE(HO11,0) <> 0, HO11, HO9), 0)),0) / NULLIF(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),0)) * 100, 2) AS pct_tarde ' +
    '  FROM ' + Tabla('hisopcc') + ' ' +
    '  WHERE HO0 BETWEEN :desde AND :hasta ' +
    '    AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '    AND COALESCE(HO16, '''') <> ''A'' ' +
    '  GROUP BY WEEKDAY(HO0) ' +
    ') D ORDER BY orden_dia';
  qCTSemana.ParamByName('desde').AsDateTime := FechaDesde;
  qCTSemana.ParamByName('hasta').AsDateTime := FechaHasta;
  qCTSemana.Open;

  AjustarCampo(qCTSemana, 'dia_semana', 'Dia', 10);
  AjustarCampo(qCTSemana, 'dias', 'Dias', 5);
  AjustarCampo(qCTSemana, 'tickets_total', 'Tickets total', 10);
  AjustarCampoMoneda(qCTSemana, 'ventas_total', 'Ventas total', 12);
  AjustarCampo(qCTSemana, 'tickets_tarde', 'Tickets tarde', 10);
  AjustarCampoMoneda(qCTSemana, 'ventas_tarde', 'Ventas tarde', 12);
  AjustarCampoMoneda(qCTSemana, 'media_tarde_dia', 'Media tarde/dia', 13);
  AjustarCampoNumero(qCTSemana, 'pct_tarde', '% tarde', 9, '#,##0.00 %');
end;

procedure TFDashboardProductividad.CargarCTHoras;
begin
  qCTHoras.Close;
  qCTHoras.SQL.Text :=
    'SELECT HOUR(HO1) AS hora, ' +
    '       CONCAT(LPAD(HOUR(HO1),2,''0''), '':00 - '', LPAD((HOUR(HO1)+1) MOD 24,2,''0''), '':00'') AS franja, ' +
    '       COUNT(*) AS tickets, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS importe, ' +
    '       ROUND(COALESCE(AVG(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS ticket_medio ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta ' +
    '  AND HOUR(HO1) >= 15 ' +
    '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '  AND COALESCE(HO16, '''') <> ''A'' ' +
    'GROUP BY HOUR(HO1) ORDER BY hora';
  qCTHoras.ParamByName('desde').AsDateTime := FechaDesde;
  qCTHoras.ParamByName('hasta').AsDateTime := FechaHasta;
  qCTHoras.Open;

  AjustarCampo(qCTHoras, 'hora', 'Hora', 5);
  AjustarCampo(qCTHoras, 'franja', 'Franja', 14);
  AjustarCampo(qCTHoras, 'tickets', 'Tickets', 7);
  AjustarCampoMoneda(qCTHoras, 'importe', 'Importe', 12);
  AjustarCampoMoneda(qCTHoras, 'ticket_medio', 'Ticket medio', 12);
end;

procedure TFDashboardProductividad.CargarDiagnostico;
begin
  CargarDiagResumen;
  CargarDiagMargen;
  CargarDiagHoras;
  CargarDiagProveedor;
  CargarDiagInforme;
end;

procedure TFDashboardProductividad.CargarDiagResumen;
begin
  qDiagResumen.Close;
  qDiagResumen.SQL.Text :=
    'SELECT ''TOTAL'' AS clave, ''Ventas del periodo'' AS indicador, COUNT(*) AS cantidad, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS importe, ' +
    '       ''Base para comparar rendimiento, personal y horarios'' AS accion ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde1 AND :hasta1 AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16, '''') <> ''A'' ' +
    'UNION ALL ' +
    'SELECT ''MARGEN_NEG'', ''Lineas con margen negativo'', COUNT(*), ' +
    '       ROUND(COALESCE(SUM((COALESCE(D.HOD8,0)*COALESCE(A.A24,0))-COALESCE(D.HOD12,0)),0),2), ' +
    '       ''Revisar PVP, coste, descuento, promocion o error de articulo'' ' +
    'FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'WHERE C.HO0 BETWEEN :desde2 AND :hasta2 AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' ' +
    '  AND COALESCE(A.A24,0)>0 AND COALESCE(D.HOD8,0)>0 AND COALESCE(D.HOD12,0) < (COALESCE(D.HOD8,0)*COALESCE(A.A24,0)) ' +
    'UNION ALL ' +
    'SELECT ''COSTE0'', ''Lineas vendidas con coste 0'', COUNT(*), ROUND(COALESCE(SUM(D.HOD12),0),2), ' +
    '       ''Completar coste para que el margen sea fiable'' ' +
    'FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'WHERE C.HO0 BETWEEN :desde3 AND :hasta3 AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' ' +
    '  AND COALESCE(D.HOD8,0)>0 AND COALESCE(D.HOD6,'''')<>'''' AND COALESCE(A.A24,0)=0 ' +
    'UNION ALL ' +
    'SELECT ''DTO_ALTO'', ''Lineas con descuento >= 30%'', COUNT(*), ROUND(COALESCE(SUM(D.HOD14),0),2), ' +
    '       ''Comprobar si son promociones correctas o descuentos manuales'' ' +
    'FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'WHERE C.HO0 BETWEEN :desde4 AND :hasta4 AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD11,0) >= 30 ' +
    'UNION ALL ' +
    'SELECT ''PVP_CERO'', ''Lineas con PVP o importe 0'', COUNT(*), ROUND(COALESCE(SUM(D.HOD14),0),2), ' +
    '       ''Revisar errores de venta, regalos o articulos mal grabados'' ' +
    'FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'WHERE C.HO0 BETWEEN :desde5 AND :hasta5 AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' ' +
    '  AND COALESCE(D.HOD8,0)>0 AND (COALESCE(D.HOD10,0)<=0 OR COALESCE(D.HOD14,0)=0)';
  qDiagResumen.ParamByName('desde1').AsDateTime := FechaDesde; qDiagResumen.ParamByName('hasta1').AsDateTime := FechaHasta;
  qDiagResumen.ParamByName('desde2').AsDateTime := FechaDesde; qDiagResumen.ParamByName('hasta2').AsDateTime := FechaHasta;
  qDiagResumen.ParamByName('desde3').AsDateTime := FechaDesde; qDiagResumen.ParamByName('hasta3').AsDateTime := FechaHasta;
  qDiagResumen.ParamByName('desde4').AsDateTime := FechaDesde; qDiagResumen.ParamByName('hasta4').AsDateTime := FechaHasta;
  qDiagResumen.ParamByName('desde5').AsDateTime := FechaDesde; qDiagResumen.ParamByName('hasta5').AsDateTime := FechaHasta;
  qDiagResumen.Open;

  AjustarCampo(qDiagResumen, 'indicador', 'Indicador', 28);
  AjustarCampoNumero(qDiagResumen, 'cantidad', 'Cantidad', 10, '#,##0.##');
  AjustarCampoMoneda(qDiagResumen, 'importe', 'Importe / impacto', 14);
  AjustarCampo(qDiagResumen, 'accion', 'Accion recomendada', 48);
end;

procedure TFDashboardProductividad.CargarDiagMargen;
begin
  qDiagMargen.Close;
  qDiagMargen.SQL.Text :=
    'SELECT DATE_FORMAT(C.HO0,''%d/%m/%Y'') AS fecha, TIME_FORMAT(C.HO1,''%H:%i:%s'') AS hora, C.HO2 AS caja, ' +
    '       C.HO4 AS serie, C.HO3 AS ticket, D.HOD5 AS linea, D.HOD6 AS codigo, CAST(D.HOD7 AS CHAR(255)) AS descripcion, ' +
    '       ROUND(COALESCE(D.HOD8,0),2) AS unidades, ROUND(COALESCE(D.HOD10,0),3) AS precio_sin_iva, ' +
    '       ROUND(COALESCE(D.HOD11,0),2) AS dto, ROUND(COALESCE(D.HOD12,0),2) AS base_linea, ' +
    '       ROUND(COALESCE(A.A24,0),3) AS coste_actual, ROUND(COALESCE(D.HOD8,0)*COALESCE(A.A24,0),2) AS coste_linea, ' +
    '       ROUND(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0)),2) AS margen_estimado, ' +
    '       ROUND(COALESCE((COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))) / NULLIF(D.HOD12,0) * 100,0),2) AS margen_pct, ' +
    '       CASE WHEN COALESCE(A.A24,0)=0 THEN ''Coste 0'' ' +
    '            WHEN COALESCE(D.HOD12,0) < (COALESCE(D.HOD8,0)*COALESCE(A.A24,0)) THEN ''Margen negativo'' ' +
    '            WHEN ROUND(COALESCE((COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))) / NULLIF(D.HOD12,0) * 100,0),2) < 10 THEN ''Margen bajo <10%'' ' +
    '            ELSE ''Revisar'' END AS motivo ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' ' +
    '  AND COALESCE(D.HOD8,0)>0 AND COALESCE(D.HOD6,'''')<>'''' ' +
    '  AND (COALESCE(A.A24,0)=0 OR COALESCE(D.HOD12,0) < (COALESCE(D.HOD8,0)*COALESCE(A.A24,0)) ' +
    '       OR ROUND(COALESCE((COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))) / NULLIF(D.HOD12,0) * 100,0),2) < 10) ' +
    'ORDER BY margen_estimado ASC, C.HO0 DESC, C.HO1 DESC LIMIT 300';
  qDiagMargen.ParamByName('desde').AsDateTime := FechaDesde;
  qDiagMargen.ParamByName('hasta').AsDateTime := FechaHasta;
  qDiagMargen.Open;

  AjustarCampo(qDiagMargen, 'fecha', 'Fecha', 11);
  AjustarCampo(qDiagMargen, 'hora', 'Hora', 9);
  AjustarCampo(qDiagMargen, 'caja', 'Caja', 5);
  AjustarCampo(qDiagMargen, 'serie', 'Serie', 6);
  AjustarCampo(qDiagMargen, 'ticket', 'Ticket', 8);
  AjustarCampo(qDiagMargen, 'linea', 'Linea', 6);
  AjustarCampo(qDiagMargen, 'codigo', 'Codigo', 13);
  AjustarCampo(qDiagMargen, 'descripcion', 'Descripcion', 28);
  AjustarCampoNumero(qDiagMargen, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qDiagMargen, 'precio_sin_iva', 'PVP s/IVA', 10);
  AjustarCampoNumero(qDiagMargen, 'dto', 'Dto %', 8, '#,##0.00 %');
  AjustarCampoMoneda(qDiagMargen, 'base_linea', 'Base', 10);
  AjustarCampoMoneda(qDiagMargen, 'coste_actual', 'Coste', 10);
  AjustarCampoMoneda(qDiagMargen, 'coste_linea', 'Coste linea', 11);
  AjustarCampoMoneda(qDiagMargen, 'margen_estimado', 'Margen', 10);
  AjustarCampoNumero(qDiagMargen, 'margen_pct', 'Margen %', 9, '#,##0.00 %');
  AjustarCampo(qDiagMargen, 'motivo', 'Motivo', 18);
end;

procedure TFDashboardProductividad.CargarDiagHoras;
begin
  qDiagHoras.Close;
  qDiagHoras.SQL.Text :=
    'SELECT HOUR(HO1) AS hora, CONCAT(LPAD(HOUR(HO1),2,''0''), '':00 - '', LPAD((HOUR(HO1)+1) MOD 24,2,''0''), '':00'') AS franja, ' +
    '       COUNT(*) AS tickets, ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS importe, ' +
    '       ROUND(COALESCE(AVG(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS ticket_medio, ' +
    '       ROUND((COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0) / NULLIF((SELECT COALESCE(SUM(IF(COALESCE(H2.HO11,0) <> 0, H2.HO11, H2.HO9)),0) FROM ' + Tabla('hisopcc') + ' H2 WHERE H2.HO0 BETWEEN :desde_total AND :hasta_total AND H2.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(H2.HO16,'''') <> ''A''),0)) * 100,2) AS peso_importe_pct, ' +
    '       CASE WHEN COUNT(*) >= 1 AND ROUND((COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0) / NULLIF((SELECT COALESCE(SUM(IF(COALESCE(H3.HO11,0) <> 0, H3.HO11, H3.HO9)),0) FROM ' + Tabla('hisopcc') + ' H3 WHERE H3.HO0 BETWEEN :desde_total2 AND :hasta_total2 AND H3.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(H3.HO16,'''') <> ''A''),0)) * 100,2) >= 25 THEN ''Hora fuerte: asegurar personal y reposicion'' ' +
    '            WHEN COUNT(*) >= 3 AND ROUND(COALESCE(AVG(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) < 8 THEN ''Muchos tickets pequenos: impulsar venta complementaria'' ' +
    '            WHEN COUNT(*) <= 1 THEN ''Hora floja: revisar si merece refuerzo'' ' +
    '            ELSE ''Normal: seguir observando'' END AS lectura ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''') <> ''A'' ' +
    'GROUP BY HOUR(HO1) ORDER BY hora';
  qDiagHoras.ParamByName('desde').AsDateTime := FechaDesde;
  qDiagHoras.ParamByName('hasta').AsDateTime := FechaHasta;
  qDiagHoras.ParamByName('desde_total').AsDateTime := FechaDesde;
  qDiagHoras.ParamByName('hasta_total').AsDateTime := FechaHasta;
  qDiagHoras.ParamByName('desde_total2').AsDateTime := FechaDesde;
  qDiagHoras.ParamByName('hasta_total2').AsDateTime := FechaHasta;
  qDiagHoras.Open;

  AjustarCampo(qDiagHoras, 'hora', 'Hora', 5);
  AjustarCampo(qDiagHoras, 'franja', 'Franja', 14);
  AjustarCampo(qDiagHoras, 'tickets', 'Tickets', 8);
  AjustarCampoMoneda(qDiagHoras, 'importe', 'Importe', 12);
  AjustarCampoMoneda(qDiagHoras, 'ticket_medio', 'Ticket medio', 12);
  AjustarCampoNumero(qDiagHoras, 'peso_importe_pct', 'Peso %', 9, '#,##0.00 %');
  AjustarCampo(qDiagHoras, 'lectura', 'Lectura', 38);
end;

procedure TFDashboardProductividad.CargarDiagProveedor;
begin
  qDiagProveedor.Close;
  qDiagProveedor.SQL.Text :=
    'SELECT COALESCE(A.A32,0) AS proveedor, COALESCE(P.P1,''Sin proveedor'') AS nombre_proveedor, COUNT(DISTINCT D.HOD6) AS articulos, ' +
    '       ROUND(COALESCE(SUM(D.HOD8),0),2) AS unidades, ROUND(COALESCE(SUM(D.HOD14),0),2) AS total_con_iva, ' +
    '       ROUND(COALESCE(SUM(D.HOD12),0),2) AS base_sin_iva, ROUND(COALESCE(SUM(D.HOD8*COALESCE(A.A24,0)),0),2) AS coste_estimado, ' +
    '       ROUND(COALESCE(SUM(D.HOD12-(D.HOD8*COALESCE(A.A24,0))),0),2) AS margen_estimado, ' +
    '       ROUND(COALESCE(SUM(D.HOD12-(D.HOD8*COALESCE(A.A24,0))) / NULLIF(SUM(D.HOD12),0) * 100,0),2) AS margen_pct, ' +
    '       CASE WHEN ROUND(COALESCE(SUM(D.HOD12-(D.HOD8*COALESCE(A.A24,0))) / NULLIF(SUM(D.HOD12),0) * 100,0),2) < 0 THEN ''Proveedor con margen negativo'' ' +
    '            WHEN ROUND(COALESCE(SUM(D.HOD12-(D.HOD8*COALESCE(A.A24,0))) / NULLIF(SUM(D.HOD12),0) * 100,0),2) < 10 THEN ''Margen bajo: revisar costes/PVP'' ' +
    '            WHEN COUNT(DISTINCT D.HOD6) <= 2 THEN ''Pocos articulos: revisar caso a caso'' ' +
    '            ELSE ''Correcto / seguimiento normal'' END AS lectura ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' ' +
    '  AND COALESCE(D.HOD6,'''')<>'''' AND COALESCE(D.HOD8,0)>0 ' +
    'GROUP BY COALESCE(A.A32,0), COALESCE(P.P1,''Sin proveedor'') ' +
    'ORDER BY margen_pct ASC, total_con_iva DESC LIMIT 100';
  qDiagProveedor.ParamByName('desde').AsDateTime := FechaDesde;
  qDiagProveedor.ParamByName('hasta').AsDateTime := FechaHasta;
  qDiagProveedor.Open;

  AjustarCampo(qDiagProveedor, 'proveedor', 'Prov.', 7);
  AjustarCampo(qDiagProveedor, 'nombre_proveedor', 'Proveedor', 26);
  AjustarCampo(qDiagProveedor, 'articulos', 'Arts.', 7);
  AjustarCampoNumero(qDiagProveedor, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qDiagProveedor, 'total_con_iva', 'Venta', 12);
  AjustarCampoMoneda(qDiagProveedor, 'base_sin_iva', 'Base', 12);
  AjustarCampoMoneda(qDiagProveedor, 'coste_estimado', 'Coste', 12);
  AjustarCampoMoneda(qDiagProveedor, 'margen_estimado', 'Margen', 12);
  AjustarCampoNumero(qDiagProveedor, 'margen_pct', 'Margen %', 9, '#,##0.00 %');
  AjustarCampo(qDiagProveedor, 'lectura', 'Lectura', 32);
end;

procedure TFDashboardProductividad.CargarDiagInforme;
var
  TotalTickets, MargenNeg, Coste0, DtoAlto, PvpCero: Integer;
  TotalVentas, ImpactoMargen, MaxImporte, MaxTicketMedio, MinTicketMedio, Imp, TM: Double;
  H, MaxHoraImporte, MaxHoraTickets, MaxTickets, Tickets, ProveedoresRiesgo: Integer;
  HoraTextoImp, HoraTextoTickets, ProveedorRiesgo: string;
  Clave: string;
begin
  if memoDiagnostico = nil then
    Exit;

  TotalTickets := 0;
  MargenNeg := 0;
  Coste0 := 0;
  DtoAlto := 0;
  PvpCero := 0;
  ProveedoresRiesgo := 0;
  TotalVentas := 0;
  ImpactoMargen := 0;
  MaxImporte := -1;
  MaxTicketMedio := -1;
  MinTicketMedio := 999999999;
  MaxHoraImporte := -1;
  MaxHoraTickets := -1;
  MaxTickets := -1;
  HoraTextoImp := '';
  HoraTextoTickets := '';
  ProveedorRiesgo := '';

  if qDiagResumen.Active then
  begin
    qDiagResumen.First;
    while not qDiagResumen.EOF do
    begin
      Clave := qDiagResumen.FieldByName('clave').AsString;
      if Clave = 'TOTAL' then
      begin
        TotalTickets := CampoInteger(qDiagResumen, 'cantidad');
        TotalVentas := CampoDouble(qDiagResumen, 'importe');
      end
      else if Clave = 'MARGEN_NEG' then
      begin
        MargenNeg := CampoInteger(qDiagResumen, 'cantidad');
        ImpactoMargen := CampoDouble(qDiagResumen, 'importe');
      end
      else if Clave = 'COSTE0' then
        Coste0 := CampoInteger(qDiagResumen, 'cantidad')
      else if Clave = 'DTO_ALTO' then
        DtoAlto := CampoInteger(qDiagResumen, 'cantidad')
      else if Clave = 'PVP_CERO' then
        PvpCero := CampoInteger(qDiagResumen, 'cantidad');
      qDiagResumen.Next;
    end;
    qDiagResumen.First;
  end;

  if qDiagHoras.Active then
  begin
    qDiagHoras.First;
    while not qDiagHoras.EOF do
    begin
      H := CampoInteger(qDiagHoras, 'hora');
      Tickets := CampoInteger(qDiagHoras, 'tickets');
      Imp := CampoDouble(qDiagHoras, 'importe');
      TM := CampoDouble(qDiagHoras, 'ticket_medio');
      if Imp > MaxImporte then
      begin
        MaxImporte := Imp;
        MaxHoraImporte := H;
        HoraTextoImp := qDiagHoras.FieldByName('franja').AsString;
      end;
      if Tickets > MaxTickets then
      begin
        MaxTickets := Tickets;
        MaxHoraTickets := H;
        HoraTextoTickets := qDiagHoras.FieldByName('franja').AsString;
      end;
      if (Tickets > 0) and (TM > MaxTicketMedio) then
        MaxTicketMedio := TM;
      if (Tickets > 0) and (TM < MinTicketMedio) then
        MinTicketMedio := TM;
      qDiagHoras.Next;
    end;
    qDiagHoras.First;
  end;

  if qDiagProveedor.Active then
  begin
    qDiagProveedor.First;
    while not qDiagProveedor.EOF do
    begin
      if CampoDouble(qDiagProveedor, 'margen_pct') < 10 then
      begin
        Inc(ProveedoresRiesgo);
        if ProveedorRiesgo = '' then
          ProveedorRiesgo := qDiagProveedor.FieldByName('nombre_proveedor').AsString;
      end;
      qDiagProveedor.Next;
    end;
    qDiagProveedor.First;
  end;

  memoDiagnostico.Lines.BeginUpdate;
  try
    memoDiagnostico.Clear;
    memoDiagnostico.Lines.Add('DIAGNOSTICO PROFESIONAL DEL NEGOCIO');
    memoDiagnostico.Lines.Add('Periodo analizado: ' + dtDesde.Text + ' - ' + dtHasta.Text);
    memoDiagnostico.Lines.Add('');

    if (MargenNeg > 0) or (Coste0 > 0) or (DtoAlto > 0) or (PvpCero > 0) then
      memoDiagnostico.Lines.Add('Estado general: ATENCION. Hay puntos que conviene revisar antes del cierre.')
    else
      memoDiagnostico.Lines.Add('Estado general: correcto. No se detectan incidencias graves en las reglas principales.');

    memoDiagnostico.Lines.Add('Venta: ' + Dinero(TotalVentas) + ' en ' + IntToStr(TotalTickets) + ' tickets.');

    if MargenNeg > 0 then
      memoDiagnostico.Lines.Add('Prioridad 1: hay ' + IntToStr(MargenNeg) + ' lineas con margen negativo. Impacto estimado contra coste: ' + Dinero(ImpactoMargen) + '. Revisar PVP, coste actual A24, descuento/promocion y articulo vendido.');
    if Coste0 > 0 then
      memoDiagnostico.Lines.Add('Prioridad 2: hay ' + IntToStr(Coste0) + ' lineas vendidas con coste 0. El margen de esos articulos no es fiable hasta completar el coste.');
    if DtoAlto > 0 then
      memoDiagnostico.Lines.Add('Aviso: hay ' + IntToStr(DtoAlto) + ' lineas con descuento igual o superior al 30%. Confirmar si son promociones correctas o descuentos manuales.');
    if PvpCero > 0 then
      memoDiagnostico.Lines.Add('Aviso: hay ' + IntToStr(PvpCero) + ' lineas con PVP/importe 0. Revisar regalos, errores o articulos mal grabados.');

    if MaxHoraImporte >= 0 then
      memoDiagnostico.Lines.Add('Hora fuerte por importe: ' + HoraTextoImp + ' con ' + Dinero(MaxImporte) + '. Conviene tener reposicion y personal preparados antes de esa franja.');
    if MaxHoraTickets >= 0 then
      memoDiagnostico.Lines.Add('Hora fuerte por cantidad de tickets: ' + HoraTextoTickets + ' con ' + IntToStr(MaxTickets) + ' tickets. Si el ticket medio es bajo, se puede trabajar venta complementaria o articulos de impulso.');
    if (MaxTicketMedio > 0) and (MinTicketMedio < 999999999) and (MaxTicketMedio > MinTicketMedio * 1.8) then
      memoDiagnostico.Lines.Add('Lectura de horarios: hay mucha diferencia entre tickets medios por hora. Revisar que se ofrece en horas flojas y que articulos se venden en horas fuertes.');

    if ProveedoresRiesgo > 0 then
      memoDiagnostico.Lines.Add('Proveedores: hay ' + IntToStr(ProveedoresRiesgo) + ' proveedores/articulos con margen inferior al 10%. Primer caso a revisar: ' + ProveedorRiesgo + '.');

    memoDiagnostico.Lines.Add('');
    memoDiagnostico.Lines.Add('Accion recomendada: revisar primero la tabla de margen negativo/bajo, despues las horas fuertes/flojas y por ultimo proveedores con margen bajo.');
    memoDiagnostico.Lines.Add('Nota compras: esta primera version cruza ventas y margen por proveedor del articulo. En el siguiente paso revisaremos albaranes de compra, porque tus pedidos reales entran normalmente como albaranes y no como pedicc/pedidd.');
  finally
    memoDiagnostico.Lines.EndUpdate;
  end;
end;


procedure TFDashboardProductividad.CargarResumen;
var
  Q: TZQuery;
  TotalHoy, TotalAyer, BaseHoy, IvaHoy, TicketMedio: Double;
  TicketsHoy: Integer;
begin
  Q := CrearQuery;
  try
    Q.Connection := FConn;

    Q.SQL.Text :=
      'SELECT COUNT(*) AS tickets, ' +
      '       COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0) AS total, ' +
      '       COALESCE(AVG(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0) AS ticket_medio ' +
      'FROM ' + Tabla('hisopcc') + ' ' +
      'WHERE HO0 = :fecha ' +
      '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
      '  AND COALESCE(HO16, '''') <> ''A''';
    Q.ParamByName('fecha').AsDateTime := SysUtils.Date;
    Q.Open;
    TicketsHoy := CampoInteger(Q, 'tickets');
    TotalHoy := CampoDouble(Q, 'total');
    TicketMedio := CampoDouble(Q, 'ticket_medio');
    Q.Close;

    Q.ParamByName('fecha').AsDateTime := IncDay(SysUtils.Date, -1);
    Q.Open;
    TotalAyer := CampoDouble(Q, 'total');
    Q.Close;

    Q.SQL.Text :=
      'SELECT COALESCE(SUM(D.HOD12),0) AS base, ' +
      '       COALESCE(SUM(D.HOD14 - D.HOD12),0) AS iva ' +
      'FROM ' + Tabla('hisopdd') + ' D ' +
      'JOIN ' + Tabla('hisopcc') + ' C ' +
      '  ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 ' +
      ' AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
      'WHERE C.HO0 = :fecha ' +
      '  AND C.HO5 IN (''NS'',''NT'',''FA'') ' +
      '  AND COALESCE(C.HO16, '''') <> ''A''';
    Q.ParamByName('fecha').AsDateTime := SysUtils.Date;
    Q.Open;
    BaseHoy := CampoDouble(Q, 'base');
    IvaHoy := CampoDouble(Q, 'iva');
    Q.Close;

    lblVentasHoy.Caption := Dinero(TotalHoy);
    lblVentasAyer.Caption := Dinero(TotalAyer);
    lblTicketsHoy.Caption := IntToStr(TicketsHoy);
    lblTicketMedio.Caption := Dinero(TicketMedio);
    lblBaseHoy.Caption := Dinero(BaseHoy);
    lblIvaHoy.Caption := Dinero(IvaHoy);
  finally
    Q.Free;
  end;
end;

procedure TFDashboardProductividad.CargarPagos;
var
  F: TField;
begin
  qPagos.Close;

  // HO6 guarda la forma de pago como texto, pero en ventas mixtas también
  // se usan HO12/HO13/HO14. Dejamos el importe como campo numérico y
  // aplicamos formato en el grid para que se vea como en la v4, con €.
  qPagos.SQL.Text :=
    'SELECT forma_pago, SUM(documentos) AS documentos, ROUND(SUM(importe),2) AS total ' +
    'FROM ( ' +
    '  SELECT CASE WHEN (UPPER(TRIM(HO6)) IN (''CONT.+TARJ'',''TARJETA+CO'',''CONT+TARJ'',''TARJ+CONT'') ' +
    '                    OR (COALESCE(HO12,0) <> 0 AND COALESCE(HO14,0) <> 0)) ' +
    '              THEN ''CONTADO'' ' +
    '              ELSE COALESCE(NULLIF(TRIM(HO6), ''''), ''SIN FORMA'') END AS forma_pago, ' +
    '         1 AS documentos, ' +
    '         CASE ' +
    '           WHEN (UPPER(TRIM(HO6)) IN (''CONT.+TARJ'',''TARJETA+CO'',''CONT+TARJ'',''TARJ+CONT'') ' +
    '                 OR (COALESCE(HO12,0) <> 0 AND COALESCE(HO14,0) <> 0)) ' +
    '             THEN GREATEST(COALESCE(HO12,0) - COALESCE(HO13,0), 0) ' +
    '           WHEN UPPER(TRIM(HO6)) = ''CONTADO'' ' +
    '             THEN CASE WHEN COALESCE(HO12,0) <> 0 THEN GREATEST(COALESCE(HO12,0) - COALESCE(HO13,0), 0) ' +
    '                       ELSE IF(COALESCE(HO11,0) <> 0, HO11, HO9) END ' +
    '           WHEN UPPER(TRIM(HO6)) IN (''VISA'',''MASTER CARD'',''MASTER'',''4-B'',''RED 6000'',''TARJETA'') ' +
    '             THEN CASE WHEN COALESCE(HO14,0) <> 0 THEN COALESCE(HO14,0) ' +
    '                       ELSE IF(COALESCE(HO11,0) <> 0, HO11, HO9) END ' +
    '           ELSE IF(COALESCE(HO11,0) <> 0, HO11, HO9) ' +
    '         END AS importe ' +
    '  FROM ' + Tabla('hisopcc') + ' ' +
    '  WHERE HO0 BETWEEN :desde1 AND :hasta1 ' +
    '    AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '    AND COALESCE(HO16, '''') <> ''A'' ' +
    '  UNION ALL ' +
    '  SELECT ''TARJETA'' AS forma_pago, 1 AS documentos, COALESCE(HO14,0) AS importe ' +
    '  FROM ' + Tabla('hisopcc') + ' ' +
    '  WHERE HO0 BETWEEN :desde2 AND :hasta2 ' +
    '    AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '    AND COALESCE(HO16, '''') <> ''A'' ' +
    '    AND (UPPER(TRIM(HO6)) IN (''CONT.+TARJ'',''TARJETA+CO'',''CONT+TARJ'',''TARJ+CONT'') ' +
    '         OR (COALESCE(HO12,0) <> 0 AND COALESCE(HO14,0) <> 0)) ' +
    '    AND COALESCE(HO14,0) <> 0 ' +
    ') X ' +
    'WHERE ABS(importe) > 0.004 ' +
    'GROUP BY forma_pago ' +
    'ORDER BY SUM(importe) DESC';

  qPagos.ParamByName('desde1').AsDateTime := FechaDesde;
  qPagos.ParamByName('hasta1').AsDateTime := FechaHasta;
  qPagos.ParamByName('desde2').AsDateTime := FechaDesde;
  qPagos.ParamByName('hasta2').AsDateTime := FechaHasta;
  qPagos.Open;

  F := qPagos.FindField('forma_pago');
  if F <> nil then
  begin
    F.DisplayLabel := 'Forma de pago';
    F.DisplayWidth := 22;
  end;

  F := qPagos.FindField('documentos');
  if F <> nil then
  begin
    F.DisplayLabel := 'Docs.';
    F.DisplayWidth := 6;
  end;

  F := qPagos.FindField('total');
  if F <> nil then
  begin
    F.DisplayLabel := 'Total';
    F.DisplayWidth := 14;
    if F is TFloatField then
      TFloatField(F).DisplayFormat := '#,##0.00 €'
    else if F is TCurrencyField then
      TCurrencyField(F).DisplayFormat := '#,##0.00 €'
    else if F is TBCDField then
      TBCDField(F).DisplayFormat := '#,##0.00 €';
  end;

  if gridPagos.Columns.Count >= 3 then
  begin
    gridPagos.Columns[0].Width := 190;
    gridPagos.Columns[1].Width := 55;
    gridPagos.Columns[2].Width := 115;
  end;

  ActualizarDatosGraficoPagos;
  if pbGraficoPagos <> nil then
    pbGraficoPagos.Invalidate;
end;



procedure TFDashboardProductividad.ObtenerTotalesComparativa(const ADesde, AHasta: TDateTime; out AVentas, ACajaTotal: Double; out ATickets, ADocsCaja: Integer);
var
  Q: TZQuery;
begin
  AVentas := 0;
  ACajaTotal := 0;
  ATickets := 0;
  ADocsCaja := 0;

  Q := CrearQuery;
  try
    Q.SQL.Text :=
      'SELECT ' +
      '  ROUND(COALESCE(SUM(CASE WHEN HO5 IN (''NS'',''NT'',''FA'') ' +
      '    THEN IF(COALESCE(HO11,0) <> 0, HO11, HO9) ELSE 0 END),0),2) AS ventas, ' +
      '  ROUND(COALESCE(SUM(CASE ' +
      '    WHEN HO5 IN (''NS'',''NT'',''FA'') THEN ' +
      '      CASE ' +
      '        WHEN (UPPER(TRIM(HO6)) IN (''CONT.+TARJ'',''TARJETA+CO'',''CONT+TARJ'',''TARJ+CONT'') ' +
      '              OR (COALESCE(HO12,0) <> 0 AND COALESCE(HO14,0) <> 0)) ' +
      '          THEN GREATEST(COALESCE(HO12,0) - COALESCE(HO13,0),0) + COALESCE(HO14,0) ' +
      '        WHEN UPPER(TRIM(HO6)) = ''CONTADO'' ' +
      '          THEN CASE WHEN COALESCE(HO12,0) <> 0 THEN GREATEST(COALESCE(HO12,0)-COALESCE(HO13,0),0) ' +
      '                    ELSE IF(COALESCE(HO11,0) <> 0, HO11, HO9) END ' +
      '        WHEN UPPER(TRIM(HO6)) IN (''VISA'',''MASTER CARD'',''MASTER'',''4-B'',''RED 6000'',''TARJETA'') ' +
      '          THEN CASE WHEN COALESCE(HO14,0) <> 0 THEN COALESCE(HO14,0) ' +
      '                    ELSE IF(COALESCE(HO11,0) <> 0, HO11, HO9) END ' +
      '        ELSE IF(COALESCE(HO11,0) <> 0, HO11, HO9) ' +
      '      END ' +
      '    WHEN HO5 IN (''CO'',''EN'') THEN IF(COALESCE(HO11,0) <> 0, HO11, HO9) ' +
      '    ELSE 0 END),0),2) AS caja_total, ' +
      '  COALESCE(SUM(CASE WHEN HO5 IN (''NS'',''NT'',''FA'') THEN 1 ELSE 0 END),0) AS tickets, ' +
      '  COALESCE(SUM(CASE WHEN HO5 IN (''CO'',''EN'') THEN 1 ELSE 0 END),0) AS docs_caja ' +
      'FROM ' + Tabla('hisopcc') + ' ' +
      'WHERE HO0 BETWEEN :desde AND :hasta ' +
      '  AND HO5 IN (''NS'',''NT'',''FA'',''CO'',''EN'') ' +
      '  AND COALESCE(HO16, '''') <> ''A''';
    Q.ParamByName('desde').AsDateTime := ADesde;
    Q.ParamByName('hasta').AsDateTime := AHasta;
    Q.Open;
    AVentas := CampoDouble(Q, 'ventas');
    ACajaTotal := CampoDouble(Q, 'caja_total');
    ATickets := CampoInteger(Q, 'tickets');
    ADocsCaja := CampoInteger(Q, 'docs_caja');
  finally
    Q.Free;
  end;
end;

procedure TFDashboardProductividad.CalcularDiferenciasComparativa(var ARows: array of TComparativaAvRow);
var
  I: Integer;
  BaseVentas, BaseCaja: Double;
begin
  if Length(ARows) = 0 then Exit;

  BaseVentas := ARows[0].Ventas;
  BaseCaja := ARows[0].CajaTotal;

  for I := 0 to High(ARows) do
  begin
    ARows[I].DifVentas := BaseVentas - ARows[I].Ventas;
    if Abs(ARows[I].Ventas) > 0.004 then
      ARows[I].DifVentasPct := (ARows[I].DifVentas / ARows[I].Ventas) * 100
    else
      ARows[I].DifVentasPct := 0;

    ARows[I].DifCaja := BaseCaja - ARows[I].CajaTotal;
    if Abs(ARows[I].CajaTotal) > 0.004 then
      ARows[I].DifCajaPct := (ARows[I].DifCaja / ARows[I].CajaTotal) * 100
    else
      ARows[I].DifCajaPct := 0;
  end;
end;

procedure TFDashboardProductividad.AbrirQueryComparativa(Q: TZQuery; const ARows: array of TComparativaAvRow);
var
  I: Integer;
  SQL: string;
  Suf: string;
begin
  if Q = nil then Exit;

  Q.Close;
  if Length(ARows) = 0 then
  begin
    Q.SQL.Text := 'SELECT ''Sin datos'' AS comparacion';
    Q.Open;
    Exit;
  end;

  SQL := '';
  for I := 0 to High(ARows) do
  begin
    if I > 0 then
      SQL := SQL + ' UNION ALL ';
    Suf := IntToStr(I);
    SQL := SQL +
      'SELECT :etq' + Suf + ' AS comparacion, ' +
      '       :desde' + Suf + ' AS desde, ' +
      '       :hasta' + Suf + ' AS hasta, ' +
      '       :ventas' + Suf + ' AS ventas, ' +
      '       :caja' + Suf + ' AS caja_total, ' +
      '       :tickets' + Suf + ' AS tickets, ' +
      '       :docs' + Suf + ' AS docs_caja, ' +
      '       :difventas' + Suf + ' AS dif_ventas, ' +
      '       :pctventas' + Suf + ' AS dif_ventas_pct, ' +
      '       :difcaja' + Suf + ' AS dif_caja, ' +
      '       :pctcaja' + Suf + ' AS dif_caja_pct';
  end;

  Q.SQL.Text := SQL;
  for I := 0 to High(ARows) do
  begin
    Suf := IntToStr(I);
    Q.ParamByName('etq' + Suf).AsString := ARows[I].Etiqueta;
    Q.ParamByName('desde' + Suf).AsString := FormatDateTime('dd/mm/yyyy', ARows[I].DesdeFecha);
    Q.ParamByName('hasta' + Suf).AsString := FormatDateTime('dd/mm/yyyy', ARows[I].HastaFecha);
    Q.ParamByName('ventas' + Suf).AsFloat := ARows[I].Ventas;
    Q.ParamByName('caja' + Suf).AsFloat := ARows[I].CajaTotal;
    Q.ParamByName('tickets' + Suf).AsInteger := ARows[I].Tickets;
    Q.ParamByName('docs' + Suf).AsInteger := ARows[I].DocsCaja;
    Q.ParamByName('difventas' + Suf).AsFloat := ARows[I].DifVentas;
    Q.ParamByName('pctventas' + Suf).AsString := FormatFloat('#,##0.00', ARows[I].DifVentasPct) + ' %';
    Q.ParamByName('difcaja' + Suf).AsFloat := ARows[I].DifCaja;
    Q.ParamByName('pctcaja' + Suf).AsString := FormatFloat('#,##0.00', ARows[I].DifCajaPct) + ' %';
  end;
  Q.Open;

  AjustarCampo(Q, 'comparacion', 'Comparación', 24);
  AjustarCampo(Q, 'desde', 'Desde', 10);
  AjustarCampo(Q, 'hasta', 'Hasta', 10);
  AjustarCampoMoneda(Q, 'ventas', 'Ventas', 13);
  AjustarCampoMoneda(Q, 'caja_total', 'Caja total', 13);
  AjustarCampo(Q, 'tickets', 'Tickets', 8);
  AjustarCampo(Q, 'docs_caja', 'Docs. caja', 8);
  AjustarCampoMoneda(Q, 'dif_ventas', 'Dif. ventas', 13);
  AjustarCampo(Q, 'dif_ventas_pct', 'Dif. ventas %', 12);
  AjustarCampoMoneda(Q, 'dif_caja', 'Dif. caja', 13);
  AjustarCampo(Q, 'dif_caja_pct', 'Dif. caja %', 12);
end;

procedure TFDashboardProductividad.GuardarDatosGraficaComparativa(const ARows: array of TComparativaAvRow);
var
  I: Integer;
begin
  FCmpAvCount := Min(Length(ARows), 6);
  for I := 0 to High(FCmpAvEtiquetas) do
  begin
    FCmpAvEtiquetas[I] := '';
    FCmpAvVentas[I] := 0;
    FCmpAvCaja[I] := 0;
  end;

  for I := 0 to FCmpAvCount - 1 do
  begin
    FCmpAvEtiquetas[I] := ARows[I].Etiqueta;
    FCmpAvVentas[I] := ARows[I].Ventas;
    FCmpAvCaja[I] := ARows[I].CajaTotal;
  end;
end;

procedure TFDashboardProductividad.CargarCmpAvResumen;
var
  R: array of TComparativaAvRow;
  D1, D2: TDateTime;
  Dias, I: Integer;
begin
  D1 := FechaDesde;
  D2 := FechaHasta;
  Dias := DaysBetween(D1, D2) + 1;
  if Dias < 1 then Dias := 1;

  SetLength(R, 4);
  R[0].Etiqueta := 'Periodo actual';
  R[0].DesdeFecha := D1;
  R[0].HastaFecha := D2;
  R[1].Etiqueta := 'Periodo anterior';
  R[1].DesdeFecha := IncDay(D1, -Dias);
  R[1].HastaFecha := IncDay(D1, -1);
  R[2].Etiqueta := 'Mismo periodo mes anterior';
  R[2].DesdeFecha := IncMonth(D1, -1);
  R[2].HastaFecha := IncMonth(D2, -1);
  R[3].Etiqueta := 'Mismo periodo año anterior';
  R[3].DesdeFecha := IncYear(D1, -1);
  R[3].HastaFecha := IncYear(D2, -1);

  for I := 0 to High(R) do
    ObtenerTotalesComparativa(R[I].DesdeFecha, R[I].HastaFecha, R[I].Ventas, R[I].CajaTotal, R[I].Tickets, R[I].DocsCaja);

  CalcularDiferenciasComparativa(R);
  AbrirQueryComparativa(qCmpAvResumen, R);
end;

procedure TFDashboardProductividad.CargarCmpAvDia;
var
  R: array of TComparativaAvRow;
  D: TDateTime;
  I: Integer;
begin
  D := FechaDesde;
  SetLength(R, 4);
  R[0].Etiqueta := 'Día actual';
  R[0].DesdeFecha := D;
  R[0].HastaFecha := D;
  R[1].Etiqueta := 'Mismo día semana anterior';
  R[1].DesdeFecha := IncDay(D, -7);
  R[1].HastaFecha := IncDay(D, -7);
  R[2].Etiqueta := 'Mismo día mes anterior';
  R[2].DesdeFecha := IncMonth(D, -1);
  R[2].HastaFecha := IncMonth(D, -1);
  R[3].Etiqueta := 'Mismo día año anterior';
  R[3].DesdeFecha := IncYear(D, -1);
  R[3].HastaFecha := IncYear(D, -1);

  for I := 0 to High(R) do
    ObtenerTotalesComparativa(R[I].DesdeFecha, R[I].HastaFecha, R[I].Ventas, R[I].CajaTotal, R[I].Tickets, R[I].DocsCaja);

  CalcularDiferenciasComparativa(R);
  AbrirQueryComparativa(qCmpAvDia, R);
end;

procedure TFDashboardProductividad.CargarCmpAvMes;
var
  R: array of TComparativaAvRow;
  D, M0, MPrev, MYear: TDateTime;
  I: Integer;

  function InicioMes(const AFecha: TDateTime): TDateTime;
  begin
    Result := EncodeDate(YearOf(AFecha), MonthOf(AFecha), 1);
  end;

  function FinMes(const AFecha: TDateTime): TDateTime;
  begin
    Result := IncDay(IncMonth(InicioMes(AFecha), 1), -1);
  end;

begin
  D := FechaDesde;
  M0 := InicioMes(D);
  MPrev := IncMonth(M0, -1);
  MYear := IncYear(M0, -1);

  SetLength(R, 3);
  R[0].Etiqueta := 'Mes actual';
  R[0].DesdeFecha := M0;
  R[0].HastaFecha := FinMes(M0);
  R[1].Etiqueta := 'Mes anterior';
  R[1].DesdeFecha := MPrev;
  R[1].HastaFecha := FinMes(MPrev);
  R[2].Etiqueta := 'Mismo mes año anterior';
  R[2].DesdeFecha := MYear;
  R[2].HastaFecha := FinMes(MYear);

  for I := 0 to High(R) do
    ObtenerTotalesComparativa(R[I].DesdeFecha, R[I].HastaFecha, R[I].Ventas, R[I].CajaTotal, R[I].Tickets, R[I].DocsCaja);

  CalcularDiferenciasComparativa(R);
  AbrirQueryComparativa(qCmpAvMes, R);
end;

procedure TFDashboardProductividad.CargarCmpAvPeriodo;
var
  R: array of TComparativaAvRow;
  D1, D2: TDateTime;
  Dias, I: Integer;
begin
  D1 := FechaDesde;
  D2 := FechaHasta;
  Dias := DaysBetween(D1, D2) + 1;
  if Dias < 1 then Dias := 1;

  SetLength(R, 4);
  R[0].Etiqueta := 'Periodo actual';
  R[0].DesdeFecha := D1;
  R[0].HastaFecha := D2;
  R[1].Etiqueta := 'Periodo anterior equivalente';
  R[1].DesdeFecha := IncDay(D1, -Dias);
  R[1].HastaFecha := IncDay(D1, -1);
  R[2].Etiqueta := 'Mismo periodo mes anterior';
  R[2].DesdeFecha := IncMonth(D1, -1);
  R[2].HastaFecha := IncMonth(D2, -1);
  R[3].Etiqueta := 'Mismo periodo año anterior';
  R[3].DesdeFecha := IncYear(D1, -1);
  R[3].HastaFecha := IncYear(D2, -1);

  for I := 0 to High(R) do
    ObtenerTotalesComparativa(R[I].DesdeFecha, R[I].HastaFecha, R[I].Ventas, R[I].CajaTotal, R[I].Tickets, R[I].DocsCaja);

  CalcularDiferenciasComparativa(R);
  AbrirQueryComparativa(qCmpAvPeriodo, R);
  GuardarDatosGraficaComparativa(R);
end;

procedure TFDashboardProductividad.CargarComparativaAvanzada;
begin
  CargarCmpAvResumen;
  CargarCmpAvDia;
  CargarCmpAvMes;
  CargarCmpAvPeriodo;

  if pbCmpAvVentas <> nil then pbCmpAvVentas.Invalidate;
  if pbCmpAvCaja <> nil then pbCmpAvCaja.Invalidate;
end;

procedure TFDashboardProductividad.PintarComparativaAvanzada(APaintBox: TPaintBox; const ATitulo: string; const AValores: TDouble6Array);
var
  C: TCanvas;
  W, H, I, X, YBase, PlotH, PlotW, BarW, BarH, LeftM, TopM: Integer;
  MaxV: Double;
  Etiq, Val: string;
begin
  if APaintBox = nil then Exit;

  C := APaintBox.Canvas;
  W := APaintBox.Width;
  H := APaintBox.Height;
  C.Brush.Color := clWhite;
  C.FillRect(Rect(0, 0, W, H));
  C.Font.Color := clBlack;
  C.Font.Style := [fsBold];
  C.TextOut(8, 6, ATitulo);
  C.Font.Style := [];

  if FCmpAvCount <= 0 then
  begin
    C.TextOut(12, 34, 'Sin datos para pintar la gráfica.');
    Exit;
  end;

  MaxV := 0;
  for I := 0 to FCmpAvCount - 1 do
    if Abs(AValores[I]) > MaxV then
      MaxV := Abs(AValores[I]);

  if MaxV <= 0.004 then
  begin
    C.TextOut(12, 34, 'No hay importes en el periodo seleccionado.');
    Exit;
  end;

  LeftM := 45;
  TopM := 34;
  YBase := H - 52;
  PlotH := YBase - TopM;
  PlotW := W - LeftM - 18;
  if PlotH < 20 then Exit;
  if PlotW < 80 then Exit;

  C.Pen.Color := clGray;
  C.Line(LeftM, TopM, LeftM, YBase);
  C.Line(LeftM, YBase, W - 12, YBase);

  BarW := Max(18, (PlotW div Max(FCmpAvCount, 1)) - 26);
  for I := 0 to FCmpAvCount - 1 do
  begin
    X := LeftM + 18 + I * (PlotW div Max(FCmpAvCount, 1));
    BarH := Round((Abs(AValores[I]) / MaxV) * (PlotH - 12));
    C.Brush.Color := clMoneyGreen;
    C.Rectangle(X, YBase - BarH, X + BarW, YBase);

    C.Brush.Style := bsClear;
    Val := Dinero(AValores[I]);
    C.TextOut(X - 4, Max(TopM, YBase - BarH - 16), Val);
    Etiq := FCmpAvEtiquetas[I];
    if Length(Etiq) > 14 then
      Etiq := Copy(Etiq, 1, 14);
    C.TextOut(X - 4, YBase + 6, Etiq);
    C.Brush.Style := bsSolid;
  end;
end;

procedure TFDashboardProductividad.CmpAvVentasPaint(Sender: TObject);
begin
  PintarComparativaAvanzada(Sender as TPaintBox, 'Ventas comparadas', FCmpAvVentas);
end;

procedure TFDashboardProductividad.CmpAvCajaPaint(Sender: TObject);
begin
  PintarComparativaAvanzada(Sender as TPaintBox, 'Caja total comparada', FCmpAvCaja);
end;

procedure TFDashboardProductividad.CargarGraficas;
begin
  CargarGrafAnoActualAnterior;
  CargarGrafHoras;
  CargarGrafPagosComparativa;
  CargarGrafComprasVentas;
  CargarGrafVentasCobros;

  if pbGrafAnoActualAnterior <> nil then pbGrafAnoActualAnterior.Invalidate;
  if pbGrafTicketMedioHora <> nil then pbGrafTicketMedioHora.Invalidate;
  if pbGrafTicketsHora <> nil then pbGrafTicketsHora.Invalidate;
  if pbGrafPagosComparativa <> nil then pbGrafPagosComparativa.Invalidate;
  if pbGrafComprasVentas <> nil then pbGrafComprasVentas.Invalidate;
  if pbGrafVentasCobros <> nil then pbGrafVentasCobros.Invalidate;
end;

procedure TFDashboardProductividad.CargarGrafAnoActualAnterior;
var
  Q: TZQuery;
  I, M, Y: Integer;
  V: Double;
begin
  FGAnoActualYear := YearOf(FechaHasta);
  FGAnoAnteriorYear := FGAnoActualYear - 1;
  for I := 1 to 12 do
  begin
    FGAnoActual[I] := 0;
    FGAnoAnterior[I] := 0;
  end;

  Q := CrearQuery;
  try
    Q.SQL.Text :=
      'SELECT YEAR(HO0) AS anyo, MONTH(HO0) AS mes, ' +
      '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS total ' +
      'FROM ' + Tabla('hisopcc') + ' ' +
      'WHERE YEAR(HO0) IN (:anyo_actual, :anyo_anterior) ' +
      '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
      '  AND COALESCE(HO16, '''') <> ''A'' ' +
      'GROUP BY YEAR(HO0), MONTH(HO0) ' +
      'ORDER BY anyo, mes';
    Q.ParamByName('anyo_actual').AsInteger := FGAnoActualYear;
    Q.ParamByName('anyo_anterior').AsInteger := FGAnoAnteriorYear;
    Q.Open;
    while not Q.EOF do
    begin
      Y := CampoInteger(Q, 'anyo');
      M := CampoInteger(Q, 'mes');
      V := CampoDouble(Q, 'total');
      if (M >= 1) and (M <= 12) then
      begin
        if Y = FGAnoActualYear then
          FGAnoActual[M] := V
        else if Y = FGAnoAnteriorYear then
          FGAnoAnterior[M] := V;
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TFDashboardProductividad.CargarGrafHoras;
var
  Q: TZQuery;
  I, H: Integer;
begin
  for I := 0 to 23 do
  begin
    FGTicketMedioHora[I] := 0;
    FGTicketsHora[I] := 0;
  end;

  Q := CrearQuery;
  try
    Q.SQL.Text :=
      'SELECT HOUR(HO1) AS hora, COUNT(*) AS tickets, ' +
      '       ROUND(AVG(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),2) AS ticket_medio ' +
      'FROM ' + Tabla('hisopcc') + ' ' +
      'WHERE HO0 BETWEEN :desde AND :hasta ' +
      '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
      '  AND COALESCE(HO16, '''') <> ''A'' ' +
      'GROUP BY HOUR(HO1) ' +
      'ORDER BY hora';
    Q.ParamByName('desde').AsDateTime := FechaDesde;
    Q.ParamByName('hasta').AsDateTime := FechaHasta;
    Q.Open;
    while not Q.EOF do
    begin
      H := CampoInteger(Q, 'hora');
      if (H >= 0) and (H <= 23) then
      begin
        FGTicketsHora[H] := CampoInteger(Q, 'tickets');
        FGTicketMedioHora[H] := CampoDouble(Q, 'ticket_medio');
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

function TFDashboardProductividad.IndicePagoGrafica(const ANombre: string): Integer;
var
  I: Integer;
  N: string;
begin
  N := Trim(ANombre);
  if N = '' then
    N := 'SIN FORMA';

  for I := 0 to FGPagoCompCount - 1 do
    if SameText(FGPagoNombres[I], N) then
    begin
      Result := I;
      Exit;
    end;

  if FGPagoCompCount <= High(FGPagoNombres) then
  begin
    Result := FGPagoCompCount;
    FGPagoNombres[Result] := N;
    FGPagoActual[Result] := 0;
    FGPagoAnterior[Result] := 0;
    Inc(FGPagoCompCount);
  end
  else
    Result := -1;
end;

procedure TFDashboardProductividad.CargarGrafPagosComparativa;
var
  I: Integer;
  D1, D2, D1Ant, D2Ant: TDateTime;

  procedure CargarPeriodo(const ADesde, AHasta: TDateTime; AEsActual: Boolean);
  var
    Q: TZQuery;
    Idx: Integer;
    Forma: string;
    Total: Double;
  begin
    Q := CrearQuery;
    try
      Q.SQL.Text :=
        'SELECT COALESCE(NULLIF(TRIM(HO6), ''''), ''SIN FORMA'') AS forma_pago, ' +
        '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS total ' +
        'FROM ' + Tabla('hisopcc') + ' ' +
        'WHERE HO0 BETWEEN :desde AND :hasta ' +
        '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
        '  AND COALESCE(HO16, '''') <> ''A'' ' +
        'GROUP BY COALESCE(NULLIF(TRIM(HO6), ''''), ''SIN FORMA'') ' +
        'ORDER BY total DESC';
      Q.ParamByName('desde').AsDateTime := ADesde;
      Q.ParamByName('hasta').AsDateTime := AHasta;
      Q.Open;
      while not Q.EOF do
      begin
        Forma := Q.FieldByName('forma_pago').AsString;
        Total := CampoDouble(Q, 'total');
        Idx := IndicePagoGrafica(Forma);
        if Idx >= 0 then
        begin
          if AEsActual then
            FGPagoActual[Idx] := FGPagoActual[Idx] + Total
          else
            FGPagoAnterior[Idx] := FGPagoAnterior[Idx] + Total;
        end;
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  end;

begin
  FGPagoCompCount := 0;
  for I := Low(FGPagoNombres) to High(FGPagoNombres) do
  begin
    FGPagoNombres[I] := '';
    FGPagoActual[I] := 0;
    FGPagoAnterior[I] := 0;
  end;

  D1 := FechaDesde;
  D2 := FechaHasta;
  D1Ant := IncYear(D1, -1);
  D2Ant := IncYear(D2, -1);

  CargarPeriodo(D1, D2, True);
  CargarPeriodo(D1Ant, D2Ant, False);
end;

procedure TFDashboardProductividad.CargarGrafComprasVentas;
var
  Q: TZQuery;
  I, M, Y: Integer;
begin
  Y := YearOf(FechaHasta);
  for I := 1 to 12 do
  begin
    FGComprasMes[I] := 0;
    FGVentasMes[I] := 0;
  end;

  Q := CrearQuery;
  try
    Q.SQL.Text :=
      'SELECT MONTH(HO0) AS mes, ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS total ' +
      'FROM ' + Tabla('hisopcc') + ' ' +
      'WHERE YEAR(HO0)=:anyo ' +
      '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
      '  AND COALESCE(HO16, '''') <> ''A'' ' +
      'GROUP BY MONTH(HO0)';
    Q.ParamByName('anyo').AsInteger := Y;
    Q.Open;
    while not Q.EOF do
    begin
      M := CampoInteger(Q, 'mes');
      if (M >= 1) and (M <= 12) then
        FGVentasMes[M] := CampoDouble(Q, 'total');
      Q.Next;
    end;
    Q.Close;

    if TablaExiste('pedicc' + FTienda) then
    begin
      Q.SQL.Text :=
        'SELECT MONTH(PC1) AS mes, ROUND(COALESCE(SUM(PC8),0),2) AS total ' +
        'FROM ' + Tabla('pedicc') + ' ' +
        'WHERE YEAR(PC1)=:anyo ' +
        'GROUP BY MONTH(PC1)';
      Q.ParamByName('anyo').AsInteger := Y;
      Q.Open;
      while not Q.EOF do
      begin
        M := CampoInteger(Q, 'mes');
        if (M >= 1) and (M <= 12) then
          FGComprasMes[M] := CampoDouble(Q, 'total');
        Q.Next;
      end;
    end;
  finally
    Q.Free;
  end;
end;

procedure TFDashboardProductividad.CargarGrafVentasCobros;
var
  Q: TZQuery;
  I, M, Y: Integer;
begin
  Y := YearOf(FechaHasta);
  for I := 1 to 12 do
  begin
    FGVentasCobros[I] := 0;
    FGCobrosMes[I] := 0;
  end;

  Q := CrearQuery;
  try
    Q.SQL.Text :=
      'SELECT MONTH(HO0) AS mes, ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS total ' +
      'FROM ' + Tabla('hisopcc') + ' ' +
      'WHERE YEAR(HO0)=:anyo ' +
      '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
      '  AND COALESCE(HO16, '''') <> ''A'' ' +
      'GROUP BY MONTH(HO0)';
    Q.ParamByName('anyo').AsInteger := Y;
    Q.Open;
    while not Q.EOF do
    begin
      M := CampoInteger(Q, 'mes');
      if (M >= 1) and (M <= 12) then
        FGVentasCobros[M] := CampoDouble(Q, 'total');
      Q.Next;
    end;
    Q.Close;

    Q.SQL.Text :=
      'SELECT MONTH(HO0) AS mes, ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS total ' +
      'FROM ' + Tabla('hisopcc') + ' ' +
      'WHERE YEAR(HO0)=:anyo ' +
      '  AND HO5 IN (''CO'',''EN'') ' +
      '  AND COALESCE(HO16, '''') <> ''A'' ' +
      'GROUP BY MONTH(HO0)';
    Q.ParamByName('anyo').AsInteger := Y;
    Q.Open;
    while not Q.EOF do
    begin
      M := CampoInteger(Q, 'mes');
      if (M >= 1) and (M <= 12) then
        FGCobrosMes[M] := CampoDouble(Q, 'total');
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TFDashboardProductividad.PintarBarrasMeses(APaintBox: TPaintBox; const ATitulo, ALeg1, ALeg2: string; const A1, A2: TDoubleMonthArray; const APrefijo, ASufijo: string);
const
  Meses: array[1..12] of string = ('E','F','M','A','M','J','J','A','S','O','N','D');
var
  C: TCanvas;
  W, H, I, X, YBase, TopY, PlotW, PlotH, StepX, BarW, H1, H2: Integer;
  MaxV: Double;
  TextoMax: string;
begin
  if APaintBox = nil then Exit;

  C := APaintBox.Canvas;
  W := APaintBox.Width;
  H := APaintBox.Height;
  C.Brush.Color := clWhite;
  C.FillRect(Rect(0,0,W,H));
  C.Font.Color := clBlack;
  C.Font.Style := [fsBold];
  C.TextOut(8,6,ATitulo);
  C.Font.Style := [];

  MaxV := 0;
  for I := 1 to 12 do
  begin
    if Abs(A1[I]) > MaxV then MaxV := Abs(A1[I]);
    if Abs(A2[I]) > MaxV then MaxV := Abs(A2[I]);
  end;

  if MaxV <= 0 then
  begin
    C.TextOut(8,30,'Sin datos para dibujar.');
    Exit;
  end;

  TopY := 42;
  YBase := H - 34;
  PlotH := Max(20, YBase - TopY);
  PlotW := W - 58;
  StepX := Max(16, PlotW div 12);
  BarW := Max(5, (StepX - 6) div 2);

  C.Pen.Color := clGray;
  C.Line(34, TopY, 34, YBase);
  C.Line(34, YBase, W - 16, YBase);

  for I := 1 to 12 do
  begin
    X := 38 + (I-1) * StepX;
    H1 := Round((Abs(A1[I]) / MaxV) * PlotH);
    H2 := Round((Abs(A2[I]) / MaxV) * PlotH);

    C.Brush.Color := clSkyBlue;
    C.Pen.Color := clBlue;
    C.Rectangle(X, YBase - H1, X + BarW, YBase);

    C.Brush.Color := clMoneyGreen;
    C.Pen.Color := clGreen;
    C.Rectangle(X + BarW + 2, YBase - H2, X + (BarW*2) + 2, YBase);

    C.Font.Color := clBlack;
    C.TextOut(X, YBase + 4, Meses[I]);
  end;

  C.Brush.Color := clSkyBlue;
  C.Rectangle(8, 24, 18, 34);
  C.Brush.Color := clMoneyGreen;
  C.Rectangle(105, 24, 115, 34);
  C.Font.Color := clBlack;
  C.TextOut(22, 22, ALeg1);
  C.TextOut(119, 22, ALeg2);

  TextoMax := 'Max.: ' + APrefijo + FormatFloat('#,##0.##', MaxV) + ASufijo;
  C.TextOut(Max(8, W - C.TextWidth(TextoMax) - 8), 22, TextoMax);
end;

procedure TFDashboardProductividad.PintarBarrasHorasDouble(APaintBox: TPaintBox; const ATitulo: string; const A: TDoubleHourArray; const APrefijo, ASufijo: string);
var
  C: TCanvas;
  W, H, I, X, YBase, TopY, PlotW, PlotH, StepX, BarW, BarH: Integer;
  MaxV: Double;
  TextoMax, TextoValor: string;
begin
  if APaintBox = nil then Exit;

  C := APaintBox.Canvas;
  W := APaintBox.Width;
  H := APaintBox.Height;
  C.Brush.Color := clWhite;
  C.FillRect(Rect(0,0,W,H));
  C.Font.Color := clBlack;
  C.Font.Style := [fsBold];
  C.TextOut(8,6,ATitulo);
  C.Font.Style := [];

  MaxV := 0;
  for I := 0 to 23 do
    if Abs(A[I]) > MaxV then MaxV := Abs(A[I]);

  if MaxV <= 0 then
  begin
    C.TextOut(8,30,'Sin datos en el rango seleccionado.');
    Exit;
  end;

  TopY := 34;
  YBase := H - 34;
  PlotH := Max(20, YBase - TopY);
  PlotW := W - 58;
  StepX := Max(8, PlotW div 24);
  BarW := Max(5, StepX - 2);

  C.Pen.Color := clGray;
  C.Line(34, TopY, 34, YBase);
  C.Line(34, YBase, W - 16, YBase);

  for I := 0 to 23 do
  begin
    X := 38 + I * StepX;
    BarH := Round((Abs(A[I]) / MaxV) * PlotH);
    C.Brush.Color := clSkyBlue;
    C.Pen.Color := clBlue;
    C.Rectangle(X, YBase - BarH, X + BarW, YBase);

    if Abs(A[I]) > 0.0001 then
    begin
      TextoValor := APrefijo + FormatFloat('#,##0.##', A[I]) + ASufijo;
      C.Brush.Style := bsClear;
      C.Font.Size := 7;
      C.Font.Orientation := 900;
      C.Font.Color := clBlack;
      C.TextOut(X + BarW - 1, YBase - BarH - 4, TextoValor);
      C.Font.Orientation := 0;
      C.Font.Size := 8;
      C.Brush.Style := bsSolid;
    end;

    if (I mod 2) = 0 then
      C.TextOut(X - 2, YBase + 4, Format('%.2d', [I]));
  end;

  TextoMax := 'Max.: ' + APrefijo + FormatFloat('#,##0.##', MaxV) + ASufijo;
  C.TextOut(42, TopY + 2, TextoMax);
end;

procedure TFDashboardProductividad.PintarBarrasHorasEntero(APaintBox: TPaintBox; const ATitulo: string; const A: TIntegerHourArray);
var
  C: TCanvas;
  W, H, I, X, YBase, TopY, PlotW, PlotH, StepX, BarW, BarH, MaxV: Integer;
  TextoMax, TextoValor: string;
begin
  if APaintBox = nil then Exit;

  C := APaintBox.Canvas;
  W := APaintBox.Width;
  H := APaintBox.Height;
  C.Brush.Color := clWhite;
  C.FillRect(Rect(0,0,W,H));
  C.Font.Color := clBlack;
  C.Font.Style := [fsBold];
  C.TextOut(8,6,ATitulo);
  C.Font.Style := [];

  MaxV := 0;
  for I := 0 to 23 do
    if A[I] > MaxV then MaxV := A[I];

  if MaxV <= 0 then
  begin
    C.TextOut(8,30,'Sin tickets en el rango seleccionado.');
    Exit;
  end;

  TopY := 34;
  YBase := H - 34;
  PlotH := Max(20, YBase - TopY);
  PlotW := W - 58;
  StepX := Max(8, PlotW div 24);
  BarW := Max(5, StepX - 2);

  C.Pen.Color := clGray;
  C.Line(34, TopY, 34, YBase);
  C.Line(34, YBase, W - 16, YBase);

  for I := 0 to 23 do
  begin
    X := 38 + I * StepX;
    BarH := Round((A[I] / MaxV) * PlotH);
    C.Brush.Color := clMoneyGreen;
    C.Pen.Color := clGreen;
    C.Rectangle(X, YBase - BarH, X + BarW, YBase);

    if A[I] > 0 then
    begin
      TextoValor := IntToStr(A[I]);
      C.Brush.Style := bsClear;
      C.Font.Size := 7;
      C.Font.Orientation := 900;
      C.Font.Color := clBlack;
      C.TextOut(X + BarW - 1, YBase - BarH - 4, TextoValor);
      C.Font.Orientation := 0;
      C.Font.Size := 8;
      C.Brush.Style := bsSolid;
    end;

    if (I mod 2) = 0 then
      C.TextOut(X - 2, YBase + 4, Format('%.2d', [I]));
  end;

  TextoMax := 'Max.: ' + IntToStr(MaxV) + ' tickets';
  C.TextOut(42, TopY + 2, TextoMax);
end;

procedure TFDashboardProductividad.PintarPagosComparativa(Sender: TObject);
var
  C: TCanvas;
  W, H, I, Y, RowH, X0, X1, MaxW, WAct, WAnt: Integer;
  MaxV: Double;
  Texto: string;
begin
  if pbGrafPagosComparativa = nil then Exit;

  C := pbGrafPagosComparativa.Canvas;
  W := pbGrafPagosComparativa.Width;
  H := pbGrafPagosComparativa.Height;
  C.Brush.Color := clWhite;
  C.FillRect(Rect(0,0,W,H));
  C.Font.Color := clBlack;
  C.Font.Style := [fsBold];
  C.TextOut(8,6,'Formas de pago: rango actual vs año anterior');
  C.Font.Style := [];

  if FGPagoCompCount = 0 then
  begin
    C.TextOut(8,30,'Sin datos en el rango seleccionado.');
    Exit;
  end;

  MaxV := 0;
  for I := 0 to FGPagoCompCount - 1 do
  begin
    if Abs(FGPagoActual[I]) > MaxV then MaxV := Abs(FGPagoActual[I]);
    if Abs(FGPagoAnterior[I]) > MaxV then MaxV := Abs(FGPagoAnterior[I]);
  end;
  if MaxV <= 0 then
  begin
    C.TextOut(8,30,'Sin importes para dibujar.');
    Exit;
  end;

  X0 := 112;
  X1 := W - 92;
  if X1 <= X0 then X1 := X0 + 20;
  MaxW := X1 - X0;
  RowH := Max(22, (H - 50) div Max(1, FGPagoCompCount));
  Y := 34;

  C.Brush.Color := clSkyBlue;
  C.Rectangle(8, 22, 18, 32);
  C.Brush.Color := clMoneyGreen;
  C.Rectangle(74, 22, 84, 32);
  C.Font.Color := clBlack;
  C.TextOut(22, 20, 'Actual');
  C.TextOut(88, 20, 'Año ant.');

  for I := 0 to FGPagoCompCount - 1 do
  begin
    if Y > H - 18 then Break;
    C.Font.Color := clBlack;
    C.TextOut(8, Y + 2, Copy(FGPagoNombres[I],1,15));

    WAct := Round((Abs(FGPagoActual[I]) / MaxV) * MaxW);
    WAnt := Round((Abs(FGPagoAnterior[I]) / MaxV) * MaxW);

    C.Brush.Color := clSkyBlue;
    C.Pen.Color := clBlue;
    C.Rectangle(X0, Y, X0 + WAct, Y + 8);

    C.Brush.Color := clMoneyGreen;
    C.Pen.Color := clGreen;
    C.Rectangle(X0, Y + 10, X0 + WAnt, Y + 18);

    Texto := Dinero(FGPagoActual[I]) + ' / ' + Dinero(FGPagoAnterior[I]);
    C.Brush.Style := bsClear;
    C.TextOut(X0 + Max(WAct, WAnt) + 6, Y + 2, Texto);
    C.Brush.Style := bsSolid;

    Inc(Y, RowH);
  end;
end;

procedure TFDashboardProductividad.GrafAnoActualAnteriorPaint(Sender: TObject);
begin
  PintarBarrasMeses(pbGrafAnoActualAnterior,
                    'Ventas mensuales: ' + IntToStr(FGAnoActualYear) + ' vs ' + IntToStr(FGAnoAnteriorYear),
                    IntToStr(FGAnoActualYear), IntToStr(FGAnoAnteriorYear),
                    FGAnoActual, FGAnoAnterior, '', ' €');
end;

procedure TFDashboardProductividad.GrafTicketMedioHoraPaint(Sender: TObject);
begin
  PintarBarrasHorasDouble(pbGrafTicketMedioHora, 'Ticket medio por hora', FGTicketMedioHora, '', ' €');
end;

procedure TFDashboardProductividad.GrafTicketsHoraPaint(Sender: TObject);
begin
  PintarBarrasHorasEntero(pbGrafTicketsHora, 'Número de tickets por hora', FGTicketsHora);
end;

procedure TFDashboardProductividad.GrafComprasVentasPaint(Sender: TObject);
begin
  PintarBarrasMeses(pbGrafComprasVentas,
                    'Compras vs ventas - ' + IntToStr(YearOf(FechaHasta)),
                    'Ventas', 'Compras',
                    FGVentasMes, FGComprasMes, '', ' €');
end;

procedure TFDashboardProductividad.GrafVentasCobrosPaint(Sender: TObject);
begin
  PintarBarrasMeses(pbGrafVentasCobros,
                    'Ventas vs cobros - ' + IntToStr(YearOf(FechaHasta)),
                    'Ventas', 'Cobros',
                    FGVentasCobros, FGCobrosMes, '', ' €');
end;

procedure TFDashboardProductividad.ActualizarDatosGraficoPagos;
var
  BM: TBookmark;
  I: Integer;
begin
  FPagoCount := 0;
  for I := Low(FPagoNombres) to High(FPagoNombres) do
  begin
    FPagoNombres[I] := '';
    FPagoImportes[I] := 0;
  end;

  if (qPagos = nil) or (not qPagos.Active) then
    Exit;

  BM := qPagos.GetBookmark;
  qPagos.DisableControls;
  try
    qPagos.First;
    while (not qPagos.EOF) and (FPagoCount <= High(FPagoNombres)) do
    begin
      FPagoNombres[FPagoCount] := qPagos.FieldByName('forma_pago').AsString;
      FPagoImportes[FPagoCount] := qPagos.FieldByName('total').AsFloat;
      Inc(FPagoCount);
      qPagos.Next;
    end;
  finally
    if qPagos.BookmarkValid(BM) then
      qPagos.GotoBookmark(BM);
    qPagos.FreeBookmark(BM);
    qPagos.EnableControls;
  end;
end;

procedure TFDashboardProductividad.ActualizarDatosGraficoHoras;
var
  BM: TBookmark;
  H, I: Integer;
begin
  for I := 0 to 23 do
  begin
    FHoraImportes[I] := 0;
    FHoraTickets[I] := 0;
  end;

  if (qHoras = nil) or (not qHoras.Active) then
    Exit;

  BM := qHoras.GetBookmark;
  qHoras.DisableControls;
  try
    qHoras.First;
    while not qHoras.EOF do
    begin
      H := qHoras.FieldByName('hora').AsInteger;
      if (H >= 0) and (H <= 23) then
      begin
        FHoraTickets[H] := qHoras.FieldByName('documentos').AsInteger;
        FHoraImportes[H] := qHoras.FieldByName('total').AsFloat;
      end;
      qHoras.Next;
    end;
  finally
    if qHoras.BookmarkValid(BM) then
      qHoras.GotoBookmark(BM);
    qHoras.FreeBookmark(BM);
    qHoras.EnableControls;
  end;
end;


procedure TFDashboardProductividad.HoyTicketsPaint(Sender: TObject);
begin
  PintarBarrasHorasEntero(pbHoyTicketsHora, 'Numero de tickets por hora - hoy', FHoyHoraTickets);
end;

procedure TFDashboardProductividad.HoyImportesPaint(Sender: TObject);
begin
  PintarBarrasHorasDouble(pbHoyImportesHora, 'Importe de tickets por hora - hoy', FHoyHoraImportes, '', ' €');
end;

procedure TFDashboardProductividad.HoyPagosPaint(Sender: TObject);
var
  C: TCanvas;
  W, H, I, BarW, BarH, X0, X1, Y, MaxW: Integer;
  MaxV, V: Double;
  Texto: string;
begin
  if pbHoyPagos = nil then Exit;

  C := pbHoyPagos.Canvas;
  W := pbHoyPagos.Width;
  H := pbHoyPagos.Height;

  C.Brush.Color := clWhite;
  C.FillRect(Rect(0, 0, W, H));
  C.Font.Color := clBlack;
  C.Font.Style := [fsBold];
  C.TextOut(8, 6, 'Formas de pago hoy');
  C.Font.Style := [];

  if FHoyPagoCount = 0 then
  begin
    C.TextOut(8, 30, 'Sin datos de pago hoy.');
    Exit;
  end;

  MaxV := 0;
  for I := 0 to FHoyPagoCount - 1 do
    if Abs(FHoyPagoImportes[I]) > MaxV then
      MaxV := Abs(FHoyPagoImportes[I]);

  if MaxV <= 0 then
  begin
    C.TextOut(8, 30, 'Sin importes para dibujar.');
    Exit;
  end;

  X0 := 115;
  X1 := W - 85;
  if X1 <= X0 then X1 := X0 + 10;
  MaxW := X1 - X0;
  BarH := Max(16, (H - 46) div Max(1, FHoyPagoCount));
  Y := 32;

  for I := 0 to FHoyPagoCount - 1 do
  begin
    V := Abs(FHoyPagoImportes[I]);
    BarW := Round((V / MaxV) * MaxW);
    C.Font.Color := clBlack;
    C.TextOut(8, Y + 2, Copy(FHoyPagoNombres[I], 1, 16));

    C.Brush.Color := clMoneyGreen;
    C.Pen.Color := clGreen;
    C.Rectangle(X0, Y, X0 + BarW, Y + BarH - 4);

    Texto := Dinero(FHoyPagoImportes[I]);
    C.Brush.Style := bsClear;
    C.Font.Color := clBlack;
    C.TextOut(X0 + BarW + 6, Y + 2, Texto);
    C.Brush.Style := bsSolid;

    Inc(Y, BarH);
    if Y > H - 18 then Break;
  end;
end;

procedure TFDashboardProductividad.GraficoPagosPaint(Sender: TObject);
var
  C: TCanvas;
  W, H, I, BarW, BarH, X0, X1, Y, MaxW: Integer;
  MaxV, V: Double;
  Texto: string;
begin
  if pbGraficoPagos = nil then Exit;

  C := pbGraficoPagos.Canvas;
  W := pbGraficoPagos.Width;
  H := pbGraficoPagos.Height;

  C.Brush.Color := clWhite;
  C.FillRect(Rect(0, 0, W, H));
  C.Font.Color := clBlack;
  C.Font.Style := [fsBold];
  C.TextOut(8, 6, 'Importe por forma de pago');
  C.Font.Style := [];

  if FPagoCount = 0 then
  begin
    C.TextOut(8, 30, 'Sin datos en el rango seleccionado.');
    Exit;
  end;

  MaxV := 0;
  for I := 0 to FPagoCount - 1 do
    if Abs(FPagoImportes[I]) > MaxV then
      MaxV := Abs(FPagoImportes[I]);

  if MaxV <= 0 then
  begin
    C.TextOut(8, 30, 'Sin importes para dibujar.');
    Exit;
  end;

  X0 := 115;
  X1 := W - 85;
  if X1 <= X0 then X1 := X0 + 10;
  MaxW := X1 - X0;
  BarH := Max(16, (H - 46) div Max(1, FPagoCount));
  Y := 32;

  for I := 0 to FPagoCount - 1 do
  begin
    V := Abs(FPagoImportes[I]);
    BarW := Round((V / MaxV) * MaxW);
    C.Font.Color := clBlack;
    C.TextOut(8, Y + 2, Copy(FPagoNombres[I], 1, 16));

    C.Brush.Color := clMoneyGreen;
    C.Pen.Color := clGreen;
    C.Rectangle(X0, Y, X0 + BarW, Y + BarH - 4);

    Texto := Dinero(FPagoImportes[I]);
    C.Brush.Style := bsClear;
    C.Font.Color := clBlack;
    C.TextOut(X0 + BarW + 6, Y + 2, Texto);
    C.Brush.Style := bsSolid;

    Inc(Y, BarH);
    if Y > H - 18 then Break;
  end;
end;

procedure TFDashboardProductividad.GraficoHorasPaint(Sender: TObject);
var
  C: TCanvas;
  W, H, I, X, YBase, TopY, BarW, BarH, PlotW, PlotH, StepX: Integer;
  MaxV: Double;
  Texto: string;
begin
  if pbGraficoHoras = nil then Exit;

  C := pbGraficoHoras.Canvas;
  W := pbGraficoHoras.Width;
  H := pbGraficoHoras.Height;

  C.Brush.Color := clWhite;
  C.FillRect(Rect(0, 0, W, H));
  C.Font.Color := clBlack;
  C.Font.Style := [fsBold];
  C.TextOut(8, 6, 'Importe vendido por hora');
  C.Font.Style := [];

  MaxV := 0;
  for I := 0 to 23 do
    if FHoraImportes[I] > MaxV then
      MaxV := FHoraImportes[I];

  if MaxV <= 0 then
  begin
    C.TextOut(8, 30, 'Sin ventas en el rango seleccionado.');
    Exit;
  end;

  TopY := 32;
  YBase := H - 34;
  PlotH := YBase - TopY;
  PlotW := W - 62;
  if PlotW < 100 then PlotW := 100;
  StepX := Max(6, PlotW div 24);
  BarW := Max(5, StepX - 2);

  C.Pen.Color := clGray;
  C.Line(36, TopY, 36, YBase);
  C.Line(36, YBase, W - 18, YBase);

  for I := 0 to 23 do
  begin
    X := 40 + I * StepX;
    BarH := Round((FHoraImportes[I] / MaxV) * PlotH);

    C.Brush.Color := clSkyBlue;
    C.Pen.Color := clBlue;
    C.Rectangle(X, YBase - BarH, X + BarW, YBase);

    if (I mod 2) = 0 then
    begin
      C.Font.Color := clBlack;
      C.TextOut(X - 2, YBase + 4, Format('%.2d', [I]));
    end;
  end;

  Texto := 'Max.: ' + Dinero(MaxV);
  C.Font.Color := clBlack;
  C.TextOut(44, TopY + 2, Texto);
end;

procedure TFDashboardProductividad.CargarHoras;
var
  F: TField;
begin
  qHoras.Close;
  qHoras.SQL.Text :=
    'SELECT HOUR(HO1) AS hora, ' +
    '       CONCAT(LPAD(HOUR(HO1),2,''0''), '':00 - '', LPAD((HOUR(HO1)+1) MOD 24,2,''0''), '':00'') AS franja, ' +
    '       COUNT(*) AS documentos, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS total ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta ' +
    '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '  AND COALESCE(HO16, '''') <> ''A'' ' +
    'GROUP BY HOUR(HO1) ' +
    'ORDER BY hora';
  qHoras.ParamByName('desde').AsDateTime := FechaDesde;
  qHoras.ParamByName('hasta').AsDateTime := FechaHasta;
  qHoras.Open;

  F := qHoras.FindField('hora');
  if F <> nil then
  begin
    F.DisplayLabel := 'Hora';
    F.DisplayWidth := 4;
  end;

  F := qHoras.FindField('franja');
  if F <> nil then
  begin
    F.DisplayLabel := 'Franja horaria';
    F.DisplayWidth := 14;
  end;

  F := qHoras.FindField('documentos');
  if F <> nil then
  begin
    F.DisplayLabel := 'Ventas';
    F.DisplayWidth := 7;
  end;

  F := qHoras.FindField('total');
  if F <> nil then
  begin
    F.DisplayLabel := 'Importe';
    F.DisplayWidth := 12;
    if F is TFloatField then
      TFloatField(F).DisplayFormat := '#,##0.00 €'
    else if F is TCurrencyField then
      TCurrencyField(F).DisplayFormat := '#,##0.00 €'
    else if F is TBCDField then
      TBCDField(F).DisplayFormat := '#,##0.00 €';
  end;

  if gridHoras.Columns.Count >= 4 then
  begin
    gridHoras.Columns[0].Width := 45;
    gridHoras.Columns[1].Width := 105;
    gridHoras.Columns[2].Width := 65;
    gridHoras.Columns[3].Width := 95;
  end;

  ActualizarDatosGraficoHoras;
  if pbGraficoHoras <> nil then
    pbGraficoHoras.Invalidate;
end;

procedure TFDashboardProductividad.CargarTopArticulos;
begin
  qTopArticulos.Close;
  qTopArticulos.SQL.Text :=
    'SELECT D.HOD6 AS codigo, ' +
    '       MAX(CAST(D.HOD7 AS CHAR(255))) AS descripcion, ' +
    '       COALESCE(SUM(D.HOD8),0) AS unidades, ' +
    '       COALESCE(SUM(D.HOD14),0) AS total_con_iva, ' +
    '       COALESCE(SUM(D.HOD12),0) AS total_sin_iva, ' +
    '       COALESCE(SUM(D.HOD12 - (D.HOD8 * COALESCE(A.A24,0))),0) AS margen_estimado ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ' +
    '  ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 ' +
    ' AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta ' +
    '  AND C.HO5 IN (''NS'',''NT'',''FA'') ' +
    '  AND COALESCE(C.HO16, '''') <> ''A'' ' +
    '  AND COALESCE(D.HOD6, '''') <> '''' ' +
    'GROUP BY D.HOD6 ' +
    'ORDER BY total_con_iva DESC ' +
    'LIMIT 10';
  qTopArticulos.ParamByName('desde').AsDateTime := FechaDesde;
  qTopArticulos.ParamByName('hasta').AsDateTime := FechaHasta;
  qTopArticulos.Open;
end;

procedure TFDashboardProductividad.CargarTopFamilias;
begin
  qTopFamilias.Close;
  qTopFamilias.SQL.Text :=
    'SELECT COALESCE(A.A14,0) AS familia, ' +
    '       COALESCE(F.F1, ''Sin familia / No asignada'') AS nombre_familia, ' +
    '       COALESCE(SUM(D.HOD8),0) AS unidades, ' +
    '       COALESCE(SUM(D.HOD14),0) AS total_con_iva, ' +
    '       COALESCE(SUM(D.HOD12),0) AS total_sin_iva, ' +
    '       COALESCE(SUM(D.HOD12 - (D.HOD8 * COALESCE(A.A24,0))),0) AS margen_estimado ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ' +
    '  ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 ' +
    ' AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta ' +
    '  AND C.HO5 IN (''NS'',''NT'',''FA'') ' +
    '  AND COALESCE(C.HO16, '''') <> ''A'' ' +
    'GROUP BY COALESCE(A.A14,0), COALESCE(F.F1, ''Sin familia / No asignada'') ' +
    'ORDER BY total_con_iva DESC';
  qTopFamilias.ParamByName('desde').AsDateTime := FechaDesde;
  qTopFamilias.ParamByName('hasta').AsDateTime := FechaHasta;
  qTopFamilias.Open;
end;


procedure TFDashboardProductividad.CargarEstudios;
begin
  CargarEstVentasDia;
  CargarEstVentasHora;
  CargarEstFamilias;
  CargarEstProveedores;
  CargarEstMargen;
  CargarEstProblemas;
end;

procedure TFDashboardProductividad.CargarEstVentasDia;
begin
  qEstVentasDia.Close;
  qEstVentasDia.SQL.Text :=
    'SELECT DATE_FORMAT(HO0, ''%d/%m/%Y'') AS fecha, ' +
    '       COUNT(*) AS documentos, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS total, ' +
    '       ROUND(COALESCE(AVG(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS ticket_medio ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta ' +
    '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '  AND COALESCE(HO16, '''') <> ''A'' ' +
    'GROUP BY HO0 ' +
    'ORDER BY HO0';
  qEstVentasDia.ParamByName('desde').AsDateTime := FechaDesde;
  qEstVentasDia.ParamByName('hasta').AsDateTime := FechaHasta;
  qEstVentasDia.Open;

  AjustarCampo(qEstVentasDia, 'fecha', 'Fecha', 11);
  AjustarCampo(qEstVentasDia, 'documentos', 'Docs.', 7);
  AjustarCampoMoneda(qEstVentasDia, 'total', 'Total', 12);
  AjustarCampoMoneda(qEstVentasDia, 'ticket_medio', 'Ticket medio', 12);
end;

procedure TFDashboardProductividad.CargarEstVentasHora;
begin
  qEstVentasHora.Close;
  qEstVentasHora.SQL.Text :=
    'SELECT HOUR(HO1) AS hora, ' +
    '       CONCAT(LPAD(HOUR(HO1),2,''0''), '':00 - '', LPAD((HOUR(HO1)+1) MOD 24,2,''0''), '':00'') AS franja, ' +
    '       COUNT(*) AS documentos, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS total, ' +
    '       ROUND(COALESCE(AVG(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS ticket_medio ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta ' +
    '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '  AND COALESCE(HO16, '''') <> ''A'' ' +
    'GROUP BY HOUR(HO1) ' +
    'ORDER BY hora';
  qEstVentasHora.ParamByName('desde').AsDateTime := FechaDesde;
  qEstVentasHora.ParamByName('hasta').AsDateTime := FechaHasta;
  qEstVentasHora.Open;

  AjustarCampo(qEstVentasHora, 'hora', 'Hora', 4);
  AjustarCampo(qEstVentasHora, 'franja', 'Franja', 13);
  AjustarCampo(qEstVentasHora, 'documentos', 'Docs.', 6);
  AjustarCampoMoneda(qEstVentasHora, 'total', 'Total', 12);
  AjustarCampoMoneda(qEstVentasHora, 'ticket_medio', 'Ticket medio', 12);
end;

procedure TFDashboardProductividad.CargarEstFamilias;
begin
  qEstFamilias.Close;
  qEstFamilias.SQL.Text :=
    'SELECT COALESCE(A.A14,0) AS familia, ' +
    '       COALESCE(F.F1, ''Sin familia / No asignada'') AS nombre_familia, ' +
    '       ROUND(COALESCE(SUM(D.HOD8),0),2) AS unidades, ' +
    '       ROUND(COALESCE(SUM(D.HOD14),0),2) AS total_con_iva, ' +
    '       ROUND(COALESCE(SUM(D.HOD12),0),2) AS total_sin_iva, ' +
    '       ROUND(COALESCE(SUM(D.HOD12 - (D.HOD8 * COALESCE(A.A24,0))),0),2) AS margen_estimado ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ' +
    '  ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 ' +
    ' AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta ' +
    '  AND C.HO5 IN (''NS'',''NT'',''FA'') ' +
    '  AND COALESCE(C.HO16, '''') <> ''A'' ' +
    'GROUP BY COALESCE(A.A14,0), COALESCE(F.F1, ''Sin familia / No asignada'') ' +
    'ORDER BY total_con_iva DESC';
  qEstFamilias.ParamByName('desde').AsDateTime := FechaDesde;
  qEstFamilias.ParamByName('hasta').AsDateTime := FechaHasta;
  qEstFamilias.Open;

  AjustarCampo(qEstFamilias, 'familia', 'Fam.', 6);
  AjustarCampo(qEstFamilias, 'nombre_familia', 'Familia', 24);
  AjustarCampoNumero(qEstFamilias, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qEstFamilias, 'total_con_iva', 'Total', 12);
  AjustarCampoMoneda(qEstFamilias, 'total_sin_iva', 'Base', 12);
  AjustarCampoMoneda(qEstFamilias, 'margen_estimado', 'Margen est.', 12);
end;

procedure TFDashboardProductividad.CargarEstProveedores;
begin
  qEstProveedores.Close;
  qEstProveedores.SQL.Text :=
    'SELECT COALESCE(A.A32,0) AS proveedor, ' +
    '       COALESCE(P.P1, ''Sin proveedor / no encontrado'') AS nombre_proveedor, ' +
    '       ROUND(COALESCE(SUM(D.HOD8),0),2) AS unidades, ' +
    '       ROUND(COALESCE(SUM(D.HOD14),0),2) AS total_con_iva, ' +
    '       ROUND(COALESCE(SUM(D.HOD12 - (D.HOD8 * COALESCE(A.A24,0))),0),2) AS margen_estimado ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ' +
    '  ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 ' +
    ' AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta ' +
    '  AND C.HO5 IN (''NS'',''NT'',''FA'') ' +
    '  AND COALESCE(C.HO16, '''') <> ''A'' ' +
    'GROUP BY COALESCE(A.A32,0), COALESCE(P.P1, ''Sin proveedor / no encontrado'') ' +
    'ORDER BY total_con_iva DESC ' +
    'LIMIT 50';
  qEstProveedores.ParamByName('desde').AsDateTime := FechaDesde;
  qEstProveedores.ParamByName('hasta').AsDateTime := FechaHasta;
  qEstProveedores.Open;

  AjustarCampo(qEstProveedores, 'proveedor', 'Prov.', 7);
  AjustarCampo(qEstProveedores, 'nombre_proveedor', 'Proveedor', 25);
  AjustarCampoNumero(qEstProveedores, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qEstProveedores, 'total_con_iva', 'Total', 12);
  AjustarCampoMoneda(qEstProveedores, 'margen_estimado', 'Margen est.', 12);
end;

procedure TFDashboardProductividad.CargarEstMargen;
begin
  qEstMargen.Close;
  qEstMargen.SQL.Text :=
    'SELECT D.HOD6 AS codigo, ' +
    '       MAX(CAST(D.HOD7 AS CHAR(255))) AS descripcion, ' +
    '       ROUND(COALESCE(SUM(D.HOD8),0),2) AS unidades, ' +
    '       ROUND(COALESCE(SUM(D.HOD12),0),2) AS total_sin_iva, ' +
    '       ROUND(COALESCE(SUM(D.HOD8 * COALESCE(A.A24,0)),0),2) AS coste_estimado, ' +
    '       ROUND(COALESCE(SUM(D.HOD12 - (D.HOD8 * COALESCE(A.A24,0))),0),2) AS margen_estimado, ' +
    '       ROUND(IF(COALESCE(SUM(D.HOD12),0) <> 0, ' +
    '                (SUM(D.HOD12 - (D.HOD8 * COALESCE(A.A24,0))) / SUM(D.HOD12)) * 100, 0),2) AS margen_pct ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ' +
    '  ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 ' +
    ' AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta ' +
    '  AND C.HO5 IN (''NS'',''NT'',''FA'') ' +
    '  AND COALESCE(C.HO16, '''') <> ''A'' ' +
    '  AND COALESCE(D.HOD6, '''') <> '''' ' +
    '  AND COALESCE(D.HOD8,0) > 0 ' +
    'GROUP BY D.HOD6 ' +
    'ORDER BY margen_estimado DESC ' +
    'LIMIT 25';
  qEstMargen.ParamByName('desde').AsDateTime := FechaDesde;
  qEstMargen.ParamByName('hasta').AsDateTime := FechaHasta;
  qEstMargen.Open;

  AjustarCampo(qEstMargen, 'codigo', 'Código', 13);
  AjustarCampo(qEstMargen, 'descripcion', 'Descripción', 28);
  AjustarCampoNumero(qEstMargen, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qEstMargen, 'total_sin_iva', 'Base', 12);
  AjustarCampoMoneda(qEstMargen, 'coste_estimado', 'Coste est.', 12);
  AjustarCampoMoneda(qEstMargen, 'margen_estimado', 'Margen est.', 12);
  AjustarCampoNumero(qEstMargen, 'margen_pct', 'Margen %', 10, '#,##0.00 %');
end;

procedure TFDashboardProductividad.CargarEstProblemas;
begin
  qEstProblemas.Close;
  qEstProblemas.SQL.Text :=
    'SELECT D.HOD6 AS codigo, ' +
    '       MAX(CAST(D.HOD7 AS CHAR(255))) AS descripcion, ' +
    '       ROUND(COALESCE(SUM(D.HOD8),0),2) AS unidades, ' +
    '       ROUND(COALESCE(SUM(D.HOD12),0),2) AS total_sin_iva, ' +
    '       ROUND(COALESCE(SUM(D.HOD8 * COALESCE(A.A24,0)),0),2) AS coste_estimado, ' +
    '       ROUND(COALESCE(SUM(D.HOD12 - (D.HOD8 * COALESCE(A.A24,0))),0),2) AS margen_estimado, ' +
    '       CASE WHEN COALESCE(MAX(A.A24),0) = 0 THEN ''Coste 0'' ELSE ''Margen negativo'' END AS motivo ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ' +
    '  ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 ' +
    ' AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta ' +
    '  AND C.HO5 IN (''NS'',''NT'',''FA'') ' +
    '  AND COALESCE(C.HO16, '''') <> ''A'' ' +
    '  AND COALESCE(D.HOD6, '''') <> '''' ' +
    '  AND COALESCE(D.HOD8,0) > 0 ' +
    'GROUP BY D.HOD6 ' +
    'HAVING COALESCE(MAX(A.A24),0) = 0 OR margen_estimado < 0 ' +
    'ORDER BY motivo, margen_estimado ASC ' +
    'LIMIT 50';
  qEstProblemas.ParamByName('desde').AsDateTime := FechaDesde;
  qEstProblemas.ParamByName('hasta').AsDateTime := FechaHasta;
  qEstProblemas.Open;

  AjustarCampo(qEstProblemas, 'codigo', 'Código', 13);
  AjustarCampo(qEstProblemas, 'descripcion', 'Descripción', 26);
  AjustarCampoNumero(qEstProblemas, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qEstProblemas, 'total_sin_iva', 'Base', 12);
  AjustarCampoMoneda(qEstProblemas, 'coste_estimado', 'Coste est.', 12);
  AjustarCampoMoneda(qEstProblemas, 'margen_estimado', 'Margen est.', 12);
  AjustarCampo(qEstProblemas, 'motivo', 'Motivo', 16);
end;



procedure TFDashboardProductividad.CargarComparativa;
begin
  CargarCompResumen;
  CargarCompDiaActual;
  CargarCompDiaAnterior;
  CargarCompFamilias;
  CargarCompArticulos;
  CargarCompPagos;
end;

procedure TFDashboardProductividad.CargarCompResumen;
var
  D1, D2, P1, P2: TDateTime;
  Dias: Integer;
begin
  if not FechasValidas(D1, D2) then Exit;
  Dias := DaysBetween(D1, D2) + 1;
  P2 := IncDay(D1, -1);
  P1 := IncDay(P2, -Dias + 1);

  qCompResumen.Close;
  qCompResumen.SQL.Text :=
    'SELECT indicador, actual, anterior, ROUND(actual - anterior, 2) AS diferencia, ' +
    '       CASE WHEN anterior = 0 THEN NULL ELSE ROUND(((actual - anterior) / anterior) * 100, 2) END AS porcentaje ' +
    'FROM ( ' +
    '  SELECT ''Total ventas'' AS indicador, ' +
    '    (SELECT ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :d1a AND :d2a AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16, '''') <> ''A'') AS actual, ' +
    '    (SELECT ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :p1a AND :p2a AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16, '''') <> ''A'') AS anterior ' +
    '  UNION ALL SELECT ''Nº documentos'', ' +
    '    (SELECT COUNT(*) FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :d1b AND :d2b AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16, '''') <> ''A''), ' +
    '    (SELECT COUNT(*) FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :p1b AND :p2b AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16, '''') <> ''A'') ' +
    '  UNION ALL SELECT ''Ticket medio'', ' +
    '    (SELECT ROUND(COALESCE(AVG(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :d1c AND :d2c AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16, '''') <> ''A''), ' +
    '    (SELECT ROUND(COALESCE(AVG(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :p1c AND :p2c AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16, '''') <> ''A'') ' +
    '  UNION ALL SELECT ''Unidades vendidas'', ' +
    '    (SELECT ROUND(COALESCE(SUM(D.HOD8),0),2) FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 WHERE C.HO0 BETWEEN :d1d AND :d2d AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16, '''') <> ''A''), ' +
    '    (SELECT ROUND(COALESCE(SUM(D.HOD8),0),2) FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 WHERE C.HO0 BETWEEN :p1d AND :p2d AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16, '''') <> ''A'') ' +
    ') X';
  qCompResumen.ParamByName('d1a').AsDateTime := D1; qCompResumen.ParamByName('d2a').AsDateTime := D2;
  qCompResumen.ParamByName('p1a').AsDateTime := P1; qCompResumen.ParamByName('p2a').AsDateTime := P2;
  qCompResumen.ParamByName('d1b').AsDateTime := D1; qCompResumen.ParamByName('d2b').AsDateTime := D2;
  qCompResumen.ParamByName('p1b').AsDateTime := P1; qCompResumen.ParamByName('p2b').AsDateTime := P2;
  qCompResumen.ParamByName('d1c').AsDateTime := D1; qCompResumen.ParamByName('d2c').AsDateTime := D2;
  qCompResumen.ParamByName('p1c').AsDateTime := P1; qCompResumen.ParamByName('p2c').AsDateTime := P2;
  qCompResumen.ParamByName('d1d').AsDateTime := D1; qCompResumen.ParamByName('d2d').AsDateTime := D2;
  qCompResumen.ParamByName('p1d').AsDateTime := P1; qCompResumen.ParamByName('p2d').AsDateTime := P2;
  qCompResumen.Open;
  AjustarCampo(qCompResumen, 'indicador', 'Indicador', 20);
  AjustarCampoNumero(qCompResumen, 'actual', 'Actual', 13, '#,##0.##');
  AjustarCampoNumero(qCompResumen, 'anterior', 'Anterior', 13, '#,##0.##');
  AjustarCampoNumero(qCompResumen, 'diferencia', 'Diferencia', 13, '#,##0.##');
  AjustarCampoNumero(qCompResumen, 'porcentaje', '%', 8, '#,##0.00 %');
end;

procedure TFDashboardProductividad.CargarCompDiaActual;
begin
  qCompDiaActual.Close;
  qCompDiaActual.SQL.Text :=
    'SELECT HO0 AS fecha, COUNT(*) AS documentos, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS total ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta ' +
    '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '  AND COALESCE(HO16, '''') <> ''A'' ' +
    'GROUP BY HO0 ORDER BY HO0';
  qCompDiaActual.ParamByName('desde').AsDateTime := FechaDesde;
  qCompDiaActual.ParamByName('hasta').AsDateTime := FechaHasta;
  qCompDiaActual.Open;
  AjustarCampo(qCompDiaActual, 'fecha', 'Fecha', 10);
  AjustarCampo(qCompDiaActual, 'documentos', 'Docs.', 6);
  AjustarCampoMoneda(qCompDiaActual, 'total', 'Total', 13);
end;

procedure TFDashboardProductividad.CargarCompDiaAnterior;
var
  D1, D2, P1, P2: TDateTime;
  Dias: Integer;
begin
  if not FechasValidas(D1, D2) then Exit;
  Dias := DaysBetween(D1, D2) + 1;
  P2 := IncDay(D1, -1);
  P1 := IncDay(P2, -Dias + 1);

  qCompDiaAnterior.Close;
  qCompDiaAnterior.SQL.Text :=
    'SELECT HO0 AS fecha, COUNT(*) AS documentos, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS total ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta ' +
    '  AND HO5 IN (''NS'',''NT'',''FA'') ' +
    '  AND COALESCE(HO16, '''') <> ''A'' ' +
    'GROUP BY HO0 ORDER BY HO0';
  qCompDiaAnterior.ParamByName('desde').AsDateTime := P1;
  qCompDiaAnterior.ParamByName('hasta').AsDateTime := P2;
  qCompDiaAnterior.Open;
  AjustarCampo(qCompDiaAnterior, 'fecha', 'Fecha', 10);
  AjustarCampo(qCompDiaAnterior, 'documentos', 'Docs.', 6);
  AjustarCampoMoneda(qCompDiaAnterior, 'total', 'Total', 13);
end;

procedure TFDashboardProductividad.CargarCompFamilias;
var
  D1, D2, P1, P2: TDateTime;
  Dias: Integer;
begin
  if not FechasValidas(D1, D2) then Exit;
  Dias := DaysBetween(D1, D2) + 1;
  P2 := IncDay(D1, -1);
  P1 := IncDay(P2, -Dias + 1);

  qCompFamilias.Close;
  qCompFamilias.SQL.Text :=
    'SELECT C.familia, C.nombre_familia, C.actual, COALESCE(P.anterior,0) AS anterior, ' +
    '       ROUND(C.actual - COALESCE(P.anterior,0),2) AS diferencia, ' +
    '       CASE WHEN COALESCE(P.anterior,0)=0 THEN NULL ELSE ROUND(((C.actual-COALESCE(P.anterior,0))/P.anterior)*100,2) END AS porcentaje ' +
    'FROM (SELECT COALESCE(A.A14,0) AS familia, COALESCE(F.F1,''Sin familia / No asignada'') AS nombre_familia, ROUND(COALESCE(SUM(D.HOD14),0),2) AS actual ' +
    '      FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' H ON H.HO0=D.HOD0 AND H.HO1=D.HOD1 AND H.HO2=D.HOD2 AND H.HO3=D.HOD3 AND H.HO4=D.HOD4 ' +
    '      LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    '      WHERE H.HO0 BETWEEN :d1 AND :d2 AND H.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(H.HO16, '''') <> ''A'' ' +
    '      GROUP BY COALESCE(A.A14,0), COALESCE(F.F1,''Sin familia / No asignada'')) C ' +
    'LEFT JOIN (SELECT COALESCE(A.A14,0) AS familia, ROUND(COALESCE(SUM(D.HOD14),0),2) AS anterior ' +
    '      FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' H ON H.HO0=D.HOD0 AND H.HO1=D.HOD1 AND H.HO2=D.HOD2 AND H.HO3=D.HOD3 AND H.HO4=D.HOD4 ' +
    '      LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    '      WHERE H.HO0 BETWEEN :p1 AND :p2 AND H.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(H.HO16, '''') <> ''A'' ' +
    '      GROUP BY COALESCE(A.A14,0)) P ON P.familia=C.familia ' +
    'ORDER BY ABS(ROUND(C.actual - COALESCE(P.anterior,0),2)) DESC LIMIT 50';
  qCompFamilias.ParamByName('d1').AsDateTime := D1;
  qCompFamilias.ParamByName('d2').AsDateTime := D2;
  qCompFamilias.ParamByName('p1').AsDateTime := P1;
  qCompFamilias.ParamByName('p2').AsDateTime := P2;
  qCompFamilias.Open;
  AjustarCampo(qCompFamilias, 'familia', 'Familia', 7);
  AjustarCampo(qCompFamilias, 'nombre_familia', 'Nombre familia', 22);
  AjustarCampoMoneda(qCompFamilias, 'actual', 'Actual', 12);
  AjustarCampoMoneda(qCompFamilias, 'anterior', 'Anterior', 12);
  AjustarCampoMoneda(qCompFamilias, 'diferencia', 'Diferencia', 12);
  AjustarCampoNumero(qCompFamilias, 'porcentaje', '%', 8, '#,##0.00 %');
end;

procedure TFDashboardProductividad.CargarCompArticulos;
var
  D1, D2, P1, P2: TDateTime;
  Dias: Integer;
begin
  if not FechasValidas(D1, D2) then Exit;
  Dias := DaysBetween(D1, D2) + 1;
  P2 := IncDay(D1, -1);
  P1 := IncDay(P2, -Dias + 1);

  qCompArticulos.Close;
  qCompArticulos.SQL.Text :=
    'SELECT C.codigo, C.descripcion, C.unidades_actual, COALESCE(P.unidades_anterior,0) AS unidades_anterior, ' +
    '       C.actual, COALESCE(P.anterior,0) AS anterior, ROUND(C.actual - COALESCE(P.anterior,0),2) AS diferencia ' +
    'FROM (SELECT D.HOD6 AS codigo, CAST(D.HOD7 AS CHAR(255)) AS descripcion, ROUND(SUM(D.HOD8),2) AS unidades_actual, ROUND(SUM(D.HOD14),2) AS actual ' +
    '      FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' H ON H.HO0=D.HOD0 AND H.HO1=D.HOD1 AND H.HO2=D.HOD2 AND H.HO3=D.HOD3 AND H.HO4=D.HOD4 ' +
    '      WHERE H.HO0 BETWEEN :d1 AND :d2 AND H.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(H.HO16, '''') <> ''A'' ' +
    '      GROUP BY D.HOD6, CAST(D.HOD7 AS CHAR(255))) C ' +
    'LEFT JOIN (SELECT D.HOD6 AS codigo, ROUND(SUM(D.HOD8),2) AS unidades_anterior, ROUND(SUM(D.HOD14),2) AS anterior ' +
    '      FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' H ON H.HO0=D.HOD0 AND H.HO1=D.HOD1 AND H.HO2=D.HOD2 AND H.HO3=D.HOD3 AND H.HO4=D.HOD4 ' +
    '      WHERE H.HO0 BETWEEN :p1 AND :p2 AND H.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(H.HO16, '''') <> ''A'' ' +
    '      GROUP BY D.HOD6) P ON P.codigo=C.codigo ' +
    'ORDER BY ABS(ROUND(C.actual - COALESCE(P.anterior,0),2)) DESC LIMIT 50';
  qCompArticulos.ParamByName('d1').AsDateTime := D1;
  qCompArticulos.ParamByName('d2').AsDateTime := D2;
  qCompArticulos.ParamByName('p1').AsDateTime := P1;
  qCompArticulos.ParamByName('p2').AsDateTime := P2;
  qCompArticulos.Open;
  AjustarCampo(qCompArticulos, 'codigo', 'Código', 13);
  AjustarCampo(qCompArticulos, 'descripcion', 'Descripción', 28);
  AjustarCampoNumero(qCompArticulos, 'unidades_actual', 'Ud. act.', 8, '#,##0.##');
  AjustarCampoNumero(qCompArticulos, 'unidades_anterior', 'Ud. ant.', 8, '#,##0.##');
  AjustarCampoMoneda(qCompArticulos, 'actual', 'Actual', 12);
  AjustarCampoMoneda(qCompArticulos, 'anterior', 'Anterior', 12);
  AjustarCampoMoneda(qCompArticulos, 'diferencia', 'Diferencia', 12);
end;

procedure TFDashboardProductividad.CargarCompPagos;
var
  D1, D2, P1, P2: TDateTime;
  Dias: Integer;
begin
  if not FechasValidas(D1, D2) then Exit;
  Dias := DaysBetween(D1, D2) + 1;
  P2 := IncDay(D1, -1);
  P1 := IncDay(P2, -Dias + 1);

  qCompPagos.Close;
  qCompPagos.SQL.Text :=
    'SELECT C.forma_pago, C.actual, COALESCE(P.anterior,0) AS anterior, ROUND(C.actual-COALESCE(P.anterior,0),2) AS diferencia ' +
    'FROM (SELECT COALESCE(NULLIF(TRIM(HO6), ''''), ''SIN FORMA'') AS forma_pago, ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS actual ' +
    '      FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :d1 AND :d2 AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16, '''') <> ''A'' GROUP BY COALESCE(NULLIF(TRIM(HO6), ''''), ''SIN FORMA'')) C ' +
    'LEFT JOIN (SELECT COALESCE(NULLIF(TRIM(HO6), ''''), ''SIN FORMA'') AS forma_pago, ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS anterior ' +
    '      FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :p1 AND :p2 AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16, '''') <> ''A'' GROUP BY COALESCE(NULLIF(TRIM(HO6), ''''), ''SIN FORMA'')) P ON P.forma_pago=C.forma_pago ' +
    'ORDER BY ABS(ROUND(C.actual-COALESCE(P.anterior,0),2)) DESC';
  qCompPagos.ParamByName('d1').AsDateTime := D1;
  qCompPagos.ParamByName('d2').AsDateTime := D2;
  qCompPagos.ParamByName('p1').AsDateTime := P1;
  qCompPagos.ParamByName('p2').AsDateTime := P2;
  qCompPagos.Open;
  AjustarCampo(qCompPagos, 'forma_pago', 'Forma pago', 18);
  AjustarCampoMoneda(qCompPagos, 'actual', 'Actual', 12);
  AjustarCampoMoneda(qCompPagos, 'anterior', 'Anterior', 12);
  AjustarCampoMoneda(qCompPagos, 'diferencia', 'Diferencia', 12);
end;



procedure TFDashboardProductividad.CargarTendencias;
begin
  CargarTendResumen;
  CargarTendMeses;
  CargarTendAnual;
  CargarTendSemana;
  CargarTendAlza;
  CargarTendBaja;
end;

procedure TFDashboardProductividad.CargarTendResumen;
begin
  qTendResumen.Close;
  qTendResumen.SQL.Text :=
    'SELECT ''Importe rango seleccionado'' AS concepto, ROUND(COALESCE(SUM(IF(COALESCE(HO11,0)<>0,HO11,HO9)),0),2) AS valor, COUNT(*) AS documentos, '''' AS detalle ' +
    'FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A'' ' +
    'UNION ALL ' +
    'SELECT ''Ticket medio rango'', ROUND(COALESCE(AVG(IF(COALESCE(HO11,0)<>0,HO11,HO9)),0),2), COUNT(*), '''' ' +
    'FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A'' ' +
    'UNION ALL ' +
    'SELECT ''Importe periodo anterior'', ROUND(COALESCE(SUM(IF(COALESCE(HO11,0)<>0,HO11,HO9)),0),2), COUNT(*), ''Mismo número de días anterior'' ' +
    'FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN DATE_SUB(:desde, INTERVAL GREATEST(DATEDIFF(:hasta,:desde)+1,1) DAY) AND DATE_SUB(:desde, INTERVAL 1 DAY) AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A'' ' +
    'UNION ALL ' +
    'SELECT ''Variación % actual vs anterior'', ROUND(((A.actual-B.anterior)/NULLIF(B.anterior,0))*100,2), A.docs, ''%'' ' +
    'FROM (SELECT COALESCE(SUM(IF(COALESCE(HO11,0)<>0,HO11,HO9)),0) AS actual, COUNT(*) AS docs FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A'') A, ' +
    '     (SELECT COALESCE(SUM(IF(COALESCE(HO11,0)<>0,HO11,HO9)),0) AS anterior FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN DATE_SUB(:desde, INTERVAL GREATEST(DATEDIFF(:hasta,:desde)+1,1) DAY) AND DATE_SUB(:desde, INTERVAL 1 DAY) AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A'') B';
  qTendResumen.ParamByName('desde').AsDateTime := FechaDesde;
  qTendResumen.ParamByName('hasta').AsDateTime := FechaHasta;
  qTendResumen.Open;
  AjustarCampo(qTendResumen, 'concepto', 'Concepto', 30);
  AjustarCampoNumero(qTendResumen, 'valor', 'Valor', 13, '#,##0.00');
  AjustarCampoNumero(qTendResumen, 'documentos', 'Docs', 8, '#,##0');
  AjustarCampo(qTendResumen, 'detalle', 'Detalle', 20);
end;

procedure TFDashboardProductividad.CargarTendMeses;
begin
  qTendMeses.Close;
  qTendMeses.SQL.Text :=
    'SELECT DATE_FORMAT(HO0,''%Y-%m'') AS mes, COUNT(*) AS documentos, ROUND(COALESCE(SUM(IF(COALESCE(HO11,0)<>0,HO11,HO9)),0),2) AS importe, ' +
    '       ROUND(COALESCE(AVG(IF(COALESCE(HO11,0)<>0,HO11,HO9)),0),2) AS ticket_medio ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN DATE_SUB(:hasta, INTERVAL 11 MONTH) AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A'' ' +
    'GROUP BY DATE_FORMAT(HO0,''%Y-%m'') ORDER BY mes';
  qTendMeses.ParamByName('hasta').AsDateTime := FechaHasta;
  qTendMeses.Open;
  AjustarCampo(qTendMeses, 'mes', 'Mes', 9);
  AjustarCampoNumero(qTendMeses, 'documentos', 'Docs', 8, '#,##0');
  AjustarCampoMoneda(qTendMeses, 'importe', 'Importe', 12);
  AjustarCampoMoneda(qTendMeses, 'ticket_medio', 'Ticket medio', 12);
end;

procedure TFDashboardProductividad.CargarTendAnual;
begin
  qTendAnual.Close;
  qTendAnual.SQL.Text :=
    'SELECT LPAD(MONTH(HO0),2,''0'') AS mes, ' +
    '       ROUND(COALESCE(SUM(IF(YEAR(HO0)=YEAR(:hasta), IF(COALESCE(HO11,0)<>0,HO11,HO9), 0)),0),2) AS actual, ' +
    '       ROUND(COALESCE(SUM(IF(YEAR(HO0)=YEAR(:hasta)-1, IF(COALESCE(HO11,0)<>0,HO11,HO9), 0)),0),2) AS anterior, ' +
    '       ROUND(COALESCE(SUM(IF(YEAR(HO0)=YEAR(:hasta), IF(COALESCE(HO11,0)<>0,HO11,HO9), 0)),0) - COALESCE(SUM(IF(YEAR(HO0)=YEAR(:hasta)-1, IF(COALESCE(HO11,0)<>0,HO11,HO9), 0)),0),2) AS diferencia, ' +
    '       ROUND(((COALESCE(SUM(IF(YEAR(HO0)=YEAR(:hasta), IF(COALESCE(HO11,0)<>0,HO11,HO9), 0)),0) - COALESCE(SUM(IF(YEAR(HO0)=YEAR(:hasta)-1, IF(COALESCE(HO11,0)<>0,HO11,HO9), 0)),0)) / NULLIF(COALESCE(SUM(IF(YEAR(HO0)=YEAR(:hasta)-1, IF(COALESCE(HO11,0)<>0,HO11,HO9), 0)),0),0))*100,2) AS variacion_pct ' +
    'FROM ' + Tabla('hisopcc') + ' WHERE YEAR(HO0) IN (YEAR(:hasta), YEAR(:hasta)-1) AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A'' ' +
    'GROUP BY MONTH(HO0) ORDER BY MONTH(HO0)';
  qTendAnual.ParamByName('hasta').AsDateTime := FechaHasta;
  qTendAnual.Open;
  AjustarCampo(qTendAnual, 'mes', 'Mes', 5);
  AjustarCampoMoneda(qTendAnual, 'actual', 'Año actual', 12);
  AjustarCampoMoneda(qTendAnual, 'anterior', 'Año anterior', 12);
  AjustarCampoMoneda(qTendAnual, 'diferencia', 'Diferencia', 12);
  AjustarCampoNumero(qTendAnual, 'variacion_pct', '% Var.', 10, '#,##0.00 %');
end;

procedure TFDashboardProductividad.CargarTendSemana;
begin
  qTendSemana.Close;
  qTendSemana.SQL.Text :=
    'SELECT ELT(WEEKDAY(HO0)+1,''Lunes'',''Martes'',''Miércoles'',''Jueves'',''Viernes'',''Sábado'',''Domingo'') AS dia_semana, ' +
    '       COUNT(*) AS documentos, ROUND(COALESCE(SUM(IF(COALESCE(HO11,0)<>0,HO11,HO9)),0),2) AS importe, ' +
    '       ROUND(COALESCE(AVG(IF(COALESCE(HO11,0)<>0,HO11,HO9)),0),2) AS ticket_medio ' +
    'FROM ' + Tabla('hisopcc') + ' WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''')<>''A'' ' +
    'GROUP BY WEEKDAY(HO0), dia_semana ORDER BY WEEKDAY(HO0)';
  qTendSemana.ParamByName('desde').AsDateTime := FechaDesde;
  qTendSemana.ParamByName('hasta').AsDateTime := FechaHasta;
  qTendSemana.Open;
  AjustarCampo(qTendSemana, 'dia_semana', 'Día', 12);
  AjustarCampoNumero(qTendSemana, 'documentos', 'Docs', 8, '#,##0');
  AjustarCampoMoneda(qTendSemana, 'importe', 'Importe', 12);
  AjustarCampoMoneda(qTendSemana, 'ticket_medio', 'Ticket medio', 12);
end;

procedure TFDashboardProductividad.CargarTendAlza;
begin
  qTendAlza.Close;
  qTendAlza.SQL.Text :=
    'SELECT C.codigo, C.descripcion, ROUND(C.actual,2) AS actual, ROUND(COALESCE(P.anterior,0),2) AS anterior, ' +
    '       ROUND(C.actual-COALESCE(P.anterior,0),2) AS diferencia, ROUND(((C.actual-COALESCE(P.anterior,0))/NULLIF(COALESCE(P.anterior,0),0))*100,2) AS variacion_pct ' +
    'FROM (SELECT D.HOD6 AS codigo, MAX(CAST(D.HOD7 AS CHAR(255))) AS descripcion, SUM(D.HOD14) AS actual FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' H ON H.HO0=D.HOD0 AND H.HO1=D.HOD1 AND H.HO2=D.HOD2 AND H.HO3=D.HOD3 AND H.HO4=D.HOD4 ' +
    '      WHERE H.HO0 BETWEEN :desde AND :hasta AND H.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(H.HO16,'''')<>''A'' GROUP BY D.HOD6) C ' +
    'LEFT JOIN (SELECT D.HOD6 AS codigo, SUM(D.HOD14) AS anterior FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' H ON H.HO0=D.HOD0 AND H.HO1=D.HOD1 AND H.HO2=D.HOD2 AND H.HO3=D.HOD3 AND H.HO4=D.HOD4 ' +
    '           WHERE H.HO0 BETWEEN DATE_SUB(:desde, INTERVAL GREATEST(DATEDIFF(:hasta,:desde)+1,1) DAY) AND DATE_SUB(:desde, INTERVAL 1 DAY) AND H.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(H.HO16,'''')<>''A'' GROUP BY D.HOD6) P ON P.codigo=C.codigo ' +
    'WHERE C.actual > COALESCE(P.anterior,0) ORDER BY diferencia DESC LIMIT 100';
  qTendAlza.ParamByName('desde').AsDateTime := FechaDesde;
  qTendAlza.ParamByName('hasta').AsDateTime := FechaHasta;
  qTendAlza.Open;
  AjustarCampo(qTendAlza, 'codigo', 'Código', 13);
  AjustarCampo(qTendAlza, 'descripcion', 'Descripción', 30);
  AjustarCampoMoneda(qTendAlza, 'actual', 'Actual', 11);
  AjustarCampoMoneda(qTendAlza, 'anterior', 'Anterior', 11);
  AjustarCampoMoneda(qTendAlza, 'diferencia', 'Diferencia', 11);
  AjustarCampoNumero(qTendAlza, 'variacion_pct', '% Var.', 10, '#,##0.00 %');
end;

procedure TFDashboardProductividad.CargarTendBaja;
begin
  qTendBaja.Close;
  qTendBaja.SQL.Text :=
    'SELECT P.codigo, P.descripcion, ROUND(COALESCE(C.actual,0),2) AS actual, ROUND(P.anterior,2) AS anterior, ' +
    '       ROUND(COALESCE(C.actual,0)-P.anterior,2) AS diferencia, ROUND(((COALESCE(C.actual,0)-P.anterior)/NULLIF(P.anterior,0))*100,2) AS variacion_pct ' +
    'FROM (SELECT D.HOD6 AS codigo, MAX(CAST(D.HOD7 AS CHAR(255))) AS descripcion, SUM(D.HOD14) AS anterior FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' H ON H.HO0=D.HOD0 AND H.HO1=D.HOD1 AND H.HO2=D.HOD2 AND H.HO3=D.HOD3 AND H.HO4=D.HOD4 ' +
    '      WHERE H.HO0 BETWEEN DATE_SUB(:desde, INTERVAL GREATEST(DATEDIFF(:hasta,:desde)+1,1) DAY) AND DATE_SUB(:desde, INTERVAL 1 DAY) AND H.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(H.HO16,'''')<>''A'' GROUP BY D.HOD6) P ' +
    'LEFT JOIN (SELECT D.HOD6 AS codigo, SUM(D.HOD14) AS actual FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' H ON H.HO0=D.HOD0 AND H.HO1=D.HOD1 AND H.HO2=D.HOD2 AND H.HO3=D.HOD3 AND H.HO4=D.HOD4 ' +
    '           WHERE H.HO0 BETWEEN :desde AND :hasta AND H.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(H.HO16,'''')<>''A'' GROUP BY D.HOD6) C ON C.codigo=P.codigo ' +
    'WHERE P.anterior > COALESCE(C.actual,0) ORDER BY diferencia ASC LIMIT 100';
  qTendBaja.ParamByName('desde').AsDateTime := FechaDesde;
  qTendBaja.ParamByName('hasta').AsDateTime := FechaHasta;
  qTendBaja.Open;
  AjustarCampo(qTendBaja, 'codigo', 'Código', 13);
  AjustarCampo(qTendBaja, 'descripcion', 'Descripción', 30);
  AjustarCampoMoneda(qTendBaja, 'actual', 'Actual', 11);
  AjustarCampoMoneda(qTendBaja, 'anterior', 'Anterior', 11);
  AjustarCampoMoneda(qTendBaja, 'diferencia', 'Diferencia', 11);
  AjustarCampoNumero(qTendBaja, 'variacion_pct', '% Var.', 10, '#,##0.00 %');
end;


procedure TFDashboardProductividad.CargarClientes;
begin
  if not TablaExiste('clientes') then
  begin
    CargarClientesNoDisponible;
    Exit;
  end;

  CargarCliResumen;
  CargarCliTopImporte;
  CargarCliTopFrecuencia;
  CargarCliTicketMedio;
  CargarCliSinCliente;
  CargarCliDatosIncompletos;
end;

procedure TFDashboardProductividad.CargarClientesNoDisponible;

  procedure CargarAviso(Q: TZQuery; const Panel: string);
  begin
    Q.Close;
    Q.SQL.Text := 'SELECT :panel AS panel, ''La tabla clientes no existe en esta base de datos'' AS aviso';
    Q.ParamByName('panel').AsString := Panel;
    Q.Open;
    AjustarCampo(Q, 'panel', 'Panel', 22);
    AjustarCampo(Q, 'aviso', 'Aviso', 60);
  end;

begin
  CargarAviso(qCliResumen, 'Resumen clientes');
  CargarAviso(qCliTopImporte, 'Top clientes por importe');
  CargarAviso(qCliTopFrecuencia, 'Top clientes por frecuencia');
  CargarAviso(qCliTicketMedio, 'Clientes por ticket medio');
  CargarAviso(qCliSinCliente, 'Ventas sin cliente asignado');
  CargarAviso(qCliDatosIncompletos, 'Datos incompletos');
end;

procedure TFDashboardProductividad.CargarCliResumen;
begin
  qCliResumen.Close;
  qCliResumen.SQL.Text :=
    'SELECT ''Documentos con cliente'' AS concepto, COUNT(*) AS documentos, COUNT(DISTINCT HO8) AS clientes, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS importe ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''') <> ''A'' AND COALESCE(HO8,0) <> 0 ' +
    'UNION ALL ' +
    'SELECT ''Documentos sin cliente'', COUNT(*), 0, ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''') <> ''A'' AND COALESCE(HO8,0) = 0 ' +
    'UNION ALL ' +
    'SELECT ''Clientes distintos'', 0, COUNT(DISTINCT HO8), CAST(NULL AS DECIMAL(12,2)) ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''') <> ''A'' AND COALESCE(HO8,0) <> 0 ' +
    'UNION ALL ' +
    'SELECT ''Ticket medio con cliente'', COUNT(*), COUNT(DISTINCT HO8), ROUND(COALESCE(AVG(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''') <> ''A'' AND COALESCE(HO8,0) <> 0';
  qCliResumen.ParamByName('desde').AsDateTime := FechaDesde;
  qCliResumen.ParamByName('hasta').AsDateTime := FechaHasta;
  qCliResumen.Open;

  AjustarCampo(qCliResumen, 'concepto', 'Concepto', 28);
  AjustarCampo(qCliResumen, 'documentos', 'Docs.', 8);
  AjustarCampo(qCliResumen, 'clientes', 'Clientes', 9);
  AjustarCampoMoneda(qCliResumen, 'importe', 'Importe', 12);
end;

procedure TFDashboardProductividad.CargarCliTopImporte;
begin
  qCliTopImporte.Close;
  qCliTopImporte.SQL.Text :=
    'SELECT C.HO8 AS cliente, COALESCE(CL.C1,''Cliente sin ficha'') AS nombre, COALESCE(CL.C5,'''') AS nif, ' +
    '       COUNT(*) AS documentos, ROUND(COALESCE(SUM(IF(COALESCE(C.HO11,0) <> 0, C.HO11, C.HO9)),0),2) AS importe, ' +
    '       ROUND(COALESCE(AVG(IF(COALESCE(C.HO11,0) <> 0, C.HO11, C.HO9)),0),2) AS ticket_medio, ' +
    '       DATE_FORMAT(MAX(C.HO0), ''%d/%m/%Y'') AS ultima_venta ' +
    'FROM ' + Tabla('hisopcc') + ' C ' +
    'LEFT JOIN `clientes` CL ON CL.C0=C.HO8 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(C.HO8,0) <> 0 ' +
    'GROUP BY C.HO8, COALESCE(CL.C1,''Cliente sin ficha''), COALESCE(CL.C5,'''') ' +
    'ORDER BY importe DESC LIMIT 100';
  qCliTopImporte.ParamByName('desde').AsDateTime := FechaDesde;
  qCliTopImporte.ParamByName('hasta').AsDateTime := FechaHasta;
  qCliTopImporte.Open;

  AjustarCampo(qCliTopImporte, 'cliente', 'Cliente', 8);
  AjustarCampo(qCliTopImporte, 'nombre', 'Nombre', 28);
  AjustarCampo(qCliTopImporte, 'nif', 'NIF', 12);
  AjustarCampo(qCliTopImporte, 'documentos', 'Docs.', 7);
  AjustarCampoMoneda(qCliTopImporte, 'importe', 'Importe', 12);
  AjustarCampoMoneda(qCliTopImporte, 'ticket_medio', 'Ticket medio', 12);
  AjustarCampo(qCliTopImporte, 'ultima_venta', 'Última', 11);
end;

procedure TFDashboardProductividad.CargarCliTopFrecuencia;
begin
  qCliTopFrecuencia.Close;
  qCliTopFrecuencia.SQL.Text :=
    'SELECT C.HO8 AS cliente, COALESCE(CL.C1,''Cliente sin ficha'') AS nombre, ' +
    '       COUNT(*) AS documentos, ROUND(COALESCE(SUM(IF(COALESCE(C.HO11,0) <> 0, C.HO11, C.HO9)),0),2) AS importe, ' +
    '       ROUND(COALESCE(AVG(IF(COALESCE(C.HO11,0) <> 0, C.HO11, C.HO9)),0),2) AS ticket_medio, ' +
    '       DATE_FORMAT(MAX(C.HO0), ''%d/%m/%Y'') AS ultima_venta ' +
    'FROM ' + Tabla('hisopcc') + ' C ' +
    'LEFT JOIN `clientes` CL ON CL.C0=C.HO8 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(C.HO8,0) <> 0 ' +
    'GROUP BY C.HO8, COALESCE(CL.C1,''Cliente sin ficha'') ' +
    'ORDER BY documentos DESC, importe DESC LIMIT 100';
  qCliTopFrecuencia.ParamByName('desde').AsDateTime := FechaDesde;
  qCliTopFrecuencia.ParamByName('hasta').AsDateTime := FechaHasta;
  qCliTopFrecuencia.Open;

  AjustarCampo(qCliTopFrecuencia, 'cliente', 'Cliente', 8);
  AjustarCampo(qCliTopFrecuencia, 'nombre', 'Nombre', 28);
  AjustarCampo(qCliTopFrecuencia, 'documentos', 'Docs.', 7);
  AjustarCampoMoneda(qCliTopFrecuencia, 'importe', 'Importe', 12);
  AjustarCampoMoneda(qCliTopFrecuencia, 'ticket_medio', 'Ticket medio', 12);
  AjustarCampo(qCliTopFrecuencia, 'ultima_venta', 'Última', 11);
end;

procedure TFDashboardProductividad.CargarCliTicketMedio;
begin
  qCliTicketMedio.Close;
  qCliTicketMedio.SQL.Text :=
    'SELECT C.HO8 AS cliente, COALESCE(CL.C1,''Cliente sin ficha'') AS nombre, COUNT(*) AS documentos, ' +
    '       ROUND(COALESCE(AVG(IF(COALESCE(C.HO11,0) <> 0, C.HO11, C.HO9)),0),2) AS ticket_medio, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(C.HO11,0) <> 0, C.HO11, C.HO9)),0),2) AS importe ' +
    'FROM ' + Tabla('hisopcc') + ' C ' +
    'LEFT JOIN `clientes` CL ON CL.C0=C.HO8 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(C.HO8,0) <> 0 ' +
    'GROUP BY C.HO8, COALESCE(CL.C1,''Cliente sin ficha'') ' +
    'HAVING COUNT(*) >= 2 ' +
    'ORDER BY ticket_medio DESC LIMIT 100';
  qCliTicketMedio.ParamByName('desde').AsDateTime := FechaDesde;
  qCliTicketMedio.ParamByName('hasta').AsDateTime := FechaHasta;
  qCliTicketMedio.Open;

  AjustarCampo(qCliTicketMedio, 'cliente', 'Cliente', 8);
  AjustarCampo(qCliTicketMedio, 'nombre', 'Nombre', 30);
  AjustarCampo(qCliTicketMedio, 'documentos', 'Docs.', 7);
  AjustarCampoMoneda(qCliTicketMedio, 'ticket_medio', 'Ticket medio', 12);
  AjustarCampoMoneda(qCliTicketMedio, 'importe', 'Importe', 12);
end;

procedure TFDashboardProductividad.CargarCliSinCliente;
begin
  qCliSinCliente.Close;
  qCliSinCliente.SQL.Text :=
    'SELECT DATE_FORMAT(HO0, ''%d/%m/%Y'') AS fecha, HO1 AS hora, HO4 AS serie, HO3 AS numero, HO5 AS tipo, ' +
    '       COALESCE(NULLIF(TRIM(HO6),''''),''SIN FORMA'') AS forma_pago, ' +
    '       ROUND(IF(COALESCE(HO11,0) <> 0, HO11, HO9),2) AS importe ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''') <> ''A'' AND COALESCE(HO8,0) = 0 ' +
    'ORDER BY HO0 DESC, HO1 DESC LIMIT 200';
  qCliSinCliente.ParamByName('desde').AsDateTime := FechaDesde;
  qCliSinCliente.ParamByName('hasta').AsDateTime := FechaHasta;
  qCliSinCliente.Open;

  AjustarCampo(qCliSinCliente, 'fecha', 'Fecha', 11);
  AjustarCampo(qCliSinCliente, 'hora', 'Hora', 8);
  AjustarCampo(qCliSinCliente, 'serie', 'Serie', 6);
  AjustarCampo(qCliSinCliente, 'numero', 'Número', 8);
  AjustarCampo(qCliSinCliente, 'tipo', 'Tipo', 5);
  AjustarCampo(qCliSinCliente, 'forma_pago', 'Forma pago', 16);
  AjustarCampoMoneda(qCliSinCliente, 'importe', 'Importe', 12);
end;

procedure TFDashboardProductividad.CargarCliDatosIncompletos;
begin
  qCliDatosIncompletos.Close;
  qCliDatosIncompletos.SQL.Text :=
    'SELECT C.HO8 AS cliente, COALESCE(CL.C1,''Cliente sin ficha'') AS nombre, COALESCE(CL.C5,'''') AS nif, ' +
    '       CASE WHEN CL.C0 IS NULL THEN ''Sin ficha de cliente'' ' +
    '            WHEN TRIM(COALESCE(CL.C1,'''')) = '''' THEN ''Nombre vacío'' ' +
    '            WHEN TRIM(COALESCE(CL.C5,'''')) = '''' THEN ''NIF vacío'' ' +
    '            ELSE ''Revisar'' END AS incidencia, ' +
    '       COUNT(*) AS documentos, ROUND(COALESCE(SUM(IF(COALESCE(C.HO11,0) <> 0, C.HO11, C.HO9)),0),2) AS importe ' +
    'FROM ' + Tabla('hisopcc') + ' C ' +
    'LEFT JOIN `clientes` CL ON CL.C0=C.HO8 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(C.HO8,0) <> 0 ' +
    '  AND (CL.C0 IS NULL OR TRIM(COALESCE(CL.C1,'''')) = '''' OR TRIM(COALESCE(CL.C5,'''')) = '''') ' +
    'GROUP BY C.HO8, COALESCE(CL.C1,''Cliente sin ficha''), COALESCE(CL.C5,''''), incidencia ' +
    'ORDER BY importe DESC, documentos DESC LIMIT 200';
  qCliDatosIncompletos.ParamByName('desde').AsDateTime := FechaDesde;
  qCliDatosIncompletos.ParamByName('hasta').AsDateTime := FechaHasta;
  qCliDatosIncompletos.Open;

  AjustarCampo(qCliDatosIncompletos, 'cliente', 'Cliente', 8);
  AjustarCampo(qCliDatosIncompletos, 'nombre', 'Nombre', 26);
  AjustarCampo(qCliDatosIncompletos, 'nif', 'NIF', 12);
  AjustarCampo(qCliDatosIncompletos, 'incidencia', 'Incidencia', 22);
  AjustarCampo(qCliDatosIncompletos, 'documentos', 'Docs.', 7);
  AjustarCampoMoneda(qCliDatosIncompletos, 'importe', 'Importe', 12);
end;



procedure TFDashboardProductividad.CargarPuestos;
begin
  CargarPueResumen;
  CargarPueUsuarios;
  CargarPueCajas;
  CargarPueHorasUsuario;
  CargarPuePagosCaja;
  CargarPueRevision;
end;

procedure TFDashboardProductividad.CargarPueResumen;
begin
  qPueResumen.Close;
  qPueResumen.SQL.Text :=
    'SELECT ''Documentos venta'' AS concepto, COUNT(*) AS cantidad, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS importe ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''') <> ''A'' ' +
    'UNION ALL ' +
    'SELECT ''Usuarios con ventas'', COUNT(DISTINCT HO7), CAST(NULL AS DECIMAL(12,2)) ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''') <> ''A'' ' +
    'UNION ALL ' +
    'SELECT ''Cajas / puestos con ventas'', COUNT(DISTINCT HO2), CAST(NULL AS DECIMAL(12,2)) ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''') <> ''A'' ' +
    'UNION ALL ' +
    'SELECT ''Ticket medio'', COUNT(*), ROUND(COALESCE(AVG(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''') <> ''A'' ' +
    'UNION ALL ' +
    'SELECT ''Anuladas / marcadas A'', COUNT(*), ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND COALESCE(HO16,'''') = ''A''';
  qPueResumen.ParamByName('desde').AsDateTime := FechaDesde;
  qPueResumen.ParamByName('hasta').AsDateTime := FechaHasta;
  qPueResumen.Open;

  AjustarCampo(qPueResumen, 'concepto', 'Concepto', 30);
  AjustarCampo(qPueResumen, 'cantidad', 'Cantidad', 10);
  AjustarCampoMoneda(qPueResumen, 'importe', 'Importe', 12);
end;

procedure TFDashboardProductividad.CargarPueUsuarios;
begin
  qPueUsuarios.Close;
  qPueUsuarios.SQL.Text :=
    'SELECT COALESCE(HO7,0) AS usuario, COUNT(*) AS documentos, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS importe, ' +
    '       ROUND(COALESCE(AVG(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS ticket_medio, ' +
    '       TIME_FORMAT(MIN(HO1), ''%H:%i'') AS primera_venta, TIME_FORMAT(MAX(HO1), ''%H:%i'') AS ultima_venta ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''') <> ''A'' ' +
    'GROUP BY COALESCE(HO7,0) ORDER BY importe DESC, documentos DESC';
  qPueUsuarios.ParamByName('desde').AsDateTime := FechaDesde;
  qPueUsuarios.ParamByName('hasta').AsDateTime := FechaHasta;
  qPueUsuarios.Open;

  AjustarCampo(qPueUsuarios, 'usuario', 'Usuario', 8);
  AjustarCampo(qPueUsuarios, 'documentos', 'Docs.', 8);
  AjustarCampoMoneda(qPueUsuarios, 'importe', 'Importe', 12);
  AjustarCampoMoneda(qPueUsuarios, 'ticket_medio', 'Ticket medio', 12);
  AjustarCampo(qPueUsuarios, 'primera_venta', 'Primera', 8);
  AjustarCampo(qPueUsuarios, 'ultima_venta', 'Última', 8);
end;

procedure TFDashboardProductividad.CargarPueCajas;
begin
  qPueCajas.Close;
  qPueCajas.SQL.Text :=
    'SELECT COALESCE(NULLIF(TRIM(HO2),''''),''SIN CAJA'') AS caja, COUNT(*) AS documentos, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS importe, ' +
    '       ROUND(COALESCE(AVG(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS ticket_medio, ' +
    '       COUNT(DISTINCT HO7) AS usuarios ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''') <> ''A'' ' +
    'GROUP BY COALESCE(NULLIF(TRIM(HO2),''''),''SIN CAJA'') ORDER BY importe DESC';
  qPueCajas.ParamByName('desde').AsDateTime := FechaDesde;
  qPueCajas.ParamByName('hasta').AsDateTime := FechaHasta;
  qPueCajas.Open;

  AjustarCampo(qPueCajas, 'caja', 'Caja', 8);
  AjustarCampo(qPueCajas, 'documentos', 'Docs.', 8);
  AjustarCampoMoneda(qPueCajas, 'importe', 'Importe', 12);
  AjustarCampoMoneda(qPueCajas, 'ticket_medio', 'Ticket medio', 12);
  AjustarCampo(qPueCajas, 'usuarios', 'Usuarios', 8);
end;

procedure TFDashboardProductividad.CargarPueHorasUsuario;
begin
  qPueHorasUsuario.Close;
  qPueHorasUsuario.SQL.Text :=
    'SELECT COALESCE(HO7,0) AS usuario, LPAD(HOUR(HO1),2,''0'') AS hora, COUNT(*) AS documentos, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS importe ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''') <> ''A'' ' +
    'GROUP BY COALESCE(HO7,0), HOUR(HO1) ORDER BY usuario, HOUR(HO1)';
  qPueHorasUsuario.ParamByName('desde').AsDateTime := FechaDesde;
  qPueHorasUsuario.ParamByName('hasta').AsDateTime := FechaHasta;
  qPueHorasUsuario.Open;

  AjustarCampo(qPueHorasUsuario, 'usuario', 'Usuario', 8);
  AjustarCampo(qPueHorasUsuario, 'hora', 'Hora', 6);
  AjustarCampo(qPueHorasUsuario, 'documentos', 'Docs.', 8);
  AjustarCampoMoneda(qPueHorasUsuario, 'importe', 'Importe', 12);
end;

procedure TFDashboardProductividad.CargarPuePagosCaja;
begin
  qPuePagosCaja.Close;
  qPuePagosCaja.SQL.Text :=
    'SELECT COALESCE(NULLIF(TRIM(HO2),''''),''SIN CAJA'') AS caja, ' +
    '       COALESCE(NULLIF(TRIM(HO6),''''),''SIN FORMA'') AS forma_pago, COUNT(*) AS documentos, ' +
    '       ROUND(COALESCE(SUM(IF(COALESCE(HO11,0) <> 0, HO11, HO9)),0),2) AS importe ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta AND HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(HO16,'''') <> ''A'' ' +
    'GROUP BY COALESCE(NULLIF(TRIM(HO2),''''),''SIN CAJA''), COALESCE(NULLIF(TRIM(HO6),''''),''SIN FORMA'') ' +
    'ORDER BY caja, importe DESC';
  qPuePagosCaja.ParamByName('desde').AsDateTime := FechaDesde;
  qPuePagosCaja.ParamByName('hasta').AsDateTime := FechaHasta;
  qPuePagosCaja.Open;

  AjustarCampo(qPuePagosCaja, 'caja', 'Caja', 8);
  AjustarCampo(qPuePagosCaja, 'forma_pago', 'Forma pago', 18);
  AjustarCampo(qPuePagosCaja, 'documentos', 'Docs.', 8);
  AjustarCampoMoneda(qPuePagosCaja, 'importe', 'Importe', 12);
end;

procedure TFDashboardProductividad.CargarPueRevision;
begin
  qPueRevision.Close;
  qPueRevision.SQL.Text :=
    'SELECT DATE_FORMAT(HO0,''%d/%m/%Y'') AS fecha, TIME_FORMAT(HO1,''%H:%i'') AS hora, ' +
    '       COALESCE(NULLIF(TRIM(HO2),''''),''?'') AS caja, COALESCE(HO7,0) AS usuario, HO5 AS tipo, HO16 AS estado, ' +
    '       HO4 AS serie, HO3 AS numero, COALESCE(NULLIF(TRIM(HO6),''''),''SIN FORMA'') AS forma_pago, ' +
    '       ROUND(IF(COALESCE(HO11,0) <> 0, HO11, HO9),2) AS importe, ' +
    '       CASE WHEN COALESCE(HO16,'''') = ''A'' THEN ''Anulada'' ' +
    '            WHEN HO5 NOT IN (''NS'',''NT'',''FA'') THEN ''Tipo no venta'' ' +
    '            WHEN ROUND(IF(COALESCE(HO11,0) <> 0, HO11, HO9),2) < 0 THEN ''Importe negativo'' ' +
    '            WHEN TRIM(COALESCE(HO6,'''')) = '''' THEN ''Sin forma de pago'' ' +
    '            ELSE ''Revisar'' END AS incidencia ' +
    'FROM ' + Tabla('hisopcc') + ' ' +
    'WHERE HO0 BETWEEN :desde AND :hasta ' +
    '  AND (COALESCE(HO16,'''') = ''A'' OR HO5 NOT IN (''NS'',''NT'',''FA'') ' +
    '       OR ROUND(IF(COALESCE(HO11,0) <> 0, HO11, HO9),2) < 0 OR TRIM(COALESCE(HO6,'''')) = '''') ' +
    'ORDER BY HO0 DESC, HO1 DESC LIMIT 300';
  qPueRevision.ParamByName('desde').AsDateTime := FechaDesde;
  qPueRevision.ParamByName('hasta').AsDateTime := FechaHasta;
  qPueRevision.Open;

  AjustarCampo(qPueRevision, 'fecha', 'Fecha', 11);
  AjustarCampo(qPueRevision, 'hora', 'Hora', 7);
  AjustarCampo(qPueRevision, 'caja', 'Caja', 6);
  AjustarCampo(qPueRevision, 'usuario', 'Usuario', 8);
  AjustarCampo(qPueRevision, 'tipo', 'Tipo', 5);
  AjustarCampo(qPueRevision, 'estado', 'Estado', 6);
  AjustarCampo(qPueRevision, 'serie', 'Serie', 6);
  AjustarCampo(qPueRevision, 'numero', 'Número', 8);
  AjustarCampo(qPueRevision, 'forma_pago', 'Forma pago', 16);
  AjustarCampoMoneda(qPueRevision, 'importe', 'Importe', 12);
  AjustarCampo(qPueRevision, 'incidencia', 'Incidencia', 18);
end;



procedure TFDashboardProductividad.CargarCompras;
begin
  if (not TablaExiste('pedicc' + FTienda)) or (not TablaExiste('pedidd' + FTienda)) then
  begin
    CargarComprasNoDisponible;
    Exit;
  end;

  CargarComResumen;
  CargarComPendientes;
  CargarComDetallePend;
  CargarComProveedor;
  CargarComArticulos;
  CargarComRevision;
end;

procedure TFDashboardProductividad.CargarComprasNoDisponible;

  procedure CargarAviso(Q: TZQuery; const Panel: string);
  begin
    Q.Close;
    Q.SQL.Text := 'SELECT :panel AS panel, ''No existen las tablas pedicc/pedidd de esta tienda en esta base de datos'' AS aviso';
    Q.ParamByName('panel').AsString := Panel;
    Q.Open;
    AjustarCampo(Q, 'panel', 'Panel', 28);
    AjustarCampo(Q, 'aviso', 'Aviso', 70);
  end;

begin
  CargarAviso(qComResumen, 'Resumen compras / pedidos');
  CargarAviso(qComPendientes, 'Pedidos en curso / pendientes');
  CargarAviso(qComDetallePend, 'Líneas pendientes de recibir');
  CargarAviso(qComProveedor, 'Compras / pedidos por proveedor');
  CargarAviso(qComArticulos, 'Artículos más pedidos');
  CargarAviso(qComRevision, 'Revisión de compras');
end;

procedure TFDashboardProductividad.CargarComResumen;
begin
  qComResumen.Close;
  qComResumen.SQL.Text :=
    'SELECT ''Pedidos en rango'' AS concepto, COUNT(*) AS cantidad, COALESCE(SUM(PC5),0) AS lineas, ROUND(COALESCE(SUM(PC8),0),2) AS importe ' +
    'FROM ' + Tabla('pedicc') + ' WHERE PC1 BETWEEN :desde AND :hasta ' +
    'UNION ALL ' +
    'SELECT ''Líneas de pedido'', COUNT(*), COALESCE(SUM(PD8),0), ROUND(COALESCE(SUM(PD17),0),2) ' +
    'FROM ' + Tabla('pedidd') + ' WHERE PD1 BETWEEN :desde AND :hasta ' +
    'UNION ALL ' +
    'SELECT ''Pendiente recibir'', COUNT(*), COALESCE(SUM(PD8),0), ROUND(COALESCE(SUM(PD17),0),2) ' +
    'FROM ' + Tabla('pedidd') + ' WHERE PD1 BETWEEN :desde AND :hasta AND COALESCE(PD23,''N'') <> ''S'' ' +
    'UNION ALL ' +
    'SELECT ''Recibido'', COUNT(*), COALESCE(SUM(PD8),0), ROUND(COALESCE(SUM(PD17),0),2) ' +
    'FROM ' + Tabla('pedidd') + ' WHERE PD1 BETWEEN :desde AND :hasta AND COALESCE(PD23,''N'') = ''S'' ' +
    'UNION ALL ' +
    'SELECT ''Pedidos sin proveedor'', COUNT(*), 0, ROUND(COALESCE(SUM(PC8),0),2) ' +
    'FROM ' + Tabla('pedicc') + ' WHERE PC1 BETWEEN :desde AND :hasta AND COALESCE(PC2,0)=0 ' +
    'UNION ALL ' +
    'SELECT ''Líneas con coste 0'', COUNT(*), COALESCE(SUM(PD8),0), ROUND(COALESCE(SUM(PD17),0),2) ' +
    'FROM ' + Tabla('pedidd') + ' WHERE PD1 BETWEEN :desde AND :hasta AND COALESCE(PD10,0)=0';
  qComResumen.ParamByName('desde').AsDateTime := FechaDesde;
  qComResumen.ParamByName('hasta').AsDateTime := FechaHasta;
  qComResumen.Open;

  AjustarCampo(qComResumen, 'concepto', 'Concepto', 28);
  AjustarCampoNumero(qComResumen, 'cantidad', 'Cantidad', 10, '#,##0.##');
  AjustarCampoNumero(qComResumen, 'lineas', 'Líneas / uds.', 12, '#,##0.##');
  AjustarCampoMoneda(qComResumen, 'importe', 'Importe', 12);
end;

procedure TFDashboardProductividad.CargarComPendientes;
begin
  qComPendientes.Close;
  qComPendientes.SQL.Text :=
    'SELECT DATE_FORMAT(C.PC1,''%d/%m/%Y'') AS fecha, C.PC2 AS proveedor, COALESCE(P.P1,C.PC13,''Sin proveedor'') AS nombre_proveedor, ' +
    '       C.PC3 AS serie, C.PC4 AS pedido, C.PC5 AS lineas, C.PC6 AS articulos, C.PC10 AS transmitido, ' +
    '       ROUND(COALESCE(C.PC7,0),2) AS coste, ROUND(COALESCE(C.PC8,0),2) AS coste_impuestos, ROUND(COALESCE(C.PC9,0),2) AS pvp_estimado ' +
    'FROM ' + Tabla('pedicc') + ' C ' +
    'LEFT JOIN `proveedores` P ON P.P0=C.PC2 ' +
    'WHERE C.PC1 BETWEEN :desde AND :hasta ' +
    'ORDER BY C.PC1 DESC, C.PC2, C.PC4 DESC LIMIT 300';
  qComPendientes.ParamByName('desde').AsDateTime := FechaDesde;
  qComPendientes.ParamByName('hasta').AsDateTime := FechaHasta;
  qComPendientes.Open;

  AjustarCampo(qComPendientes, 'fecha', 'Fecha', 11);
  AjustarCampo(qComPendientes, 'proveedor', 'Prov.', 7);
  AjustarCampo(qComPendientes, 'nombre_proveedor', 'Proveedor', 24);
  AjustarCampo(qComPendientes, 'serie', 'Serie', 6);
  AjustarCampo(qComPendientes, 'pedido', 'Pedido', 8);
  AjustarCampo(qComPendientes, 'lineas', 'Líneas', 7);
  AjustarCampo(qComPendientes, 'articulos', 'Art.', 7);
  AjustarCampo(qComPendientes, 'transmitido', 'Trans.', 7);
  AjustarCampoMoneda(qComPendientes, 'coste', 'Coste', 11);
  AjustarCampoMoneda(qComPendientes, 'coste_impuestos', 'Coste+Imp.', 12);
  AjustarCampoMoneda(qComPendientes, 'pvp_estimado', 'PVP est.', 11);
end;

procedure TFDashboardProductividad.CargarComDetallePend;
begin
  qComDetallePend.Close;
  qComDetallePend.SQL.Text :=
    'SELECT DATE_FORMAT(D.PD1,''%d/%m/%Y'') AS fecha, D.PD2 AS proveedor, COALESCE(P.P1,''Sin proveedor'') AS nombre_proveedor, ' +
    '       D.PD3 AS serie, D.PD4 AS pedido, D.PD5 AS linea, D.PD6 AS codigo, D.PD7 AS descripcion, ' +
    '       ROUND(COALESCE(D.PD8,0),2) AS unidades, ROUND(COALESCE(D.PD10,0),3) AS coste_sin_iva, ' +
    '       ROUND(COALESCE(D.PD15,0),3) AS coste_con_imp, ROUND(COALESCE(D.PD17,0),2) AS importe_coste, COALESCE(D.PD23,''N'') AS recibido ' +
    'FROM ' + Tabla('pedidd') + ' D ' +
    'LEFT JOIN `proveedores` P ON P.P0=D.PD2 ' +
    'WHERE D.PD1 BETWEEN :desde AND :hasta AND COALESCE(D.PD23,''N'') <> ''S'' ' +
    'ORDER BY D.PD1 DESC, D.PD2, D.PD4 DESC, D.PD5 LIMIT 300';
  qComDetallePend.ParamByName('desde').AsDateTime := FechaDesde;
  qComDetallePend.ParamByName('hasta').AsDateTime := FechaHasta;
  qComDetallePend.Open;

  AjustarCampo(qComDetallePend, 'fecha', 'Fecha', 11);
  AjustarCampo(qComDetallePend, 'proveedor', 'Prov.', 7);
  AjustarCampo(qComDetallePend, 'nombre_proveedor', 'Proveedor', 22);
  AjustarCampo(qComDetallePend, 'serie', 'Serie', 6);
  AjustarCampo(qComDetallePend, 'pedido', 'Pedido', 8);
  AjustarCampo(qComDetallePend, 'linea', 'Línea', 7);
  AjustarCampo(qComDetallePend, 'codigo', 'Código', 13);
  AjustarCampo(qComDetallePend, 'descripcion', 'Descripción', 28);
  AjustarCampoNumero(qComDetallePend, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qComDetallePend, 'coste_sin_iva', 'Coste s/IVA', 11);
  AjustarCampoMoneda(qComDetallePend, 'coste_con_imp', 'Coste c/Imp.', 11);
  AjustarCampoMoneda(qComDetallePend, 'importe_coste', 'Importe', 11);
  AjustarCampo(qComDetallePend, 'recibido', 'Rec.', 5);
end;

procedure TFDashboardProductividad.CargarComProveedor;
begin
  qComProveedor.Close;
  qComProveedor.SQL.Text :=
    'SELECT D.PD2 AS proveedor, COALESCE(P.P1,''Sin proveedor'') AS nombre_proveedor, COUNT(DISTINCT CONCAT(D.PD3,''/'',D.PD4)) AS pedidos, ' +
    '       COUNT(*) AS lineas, ROUND(COALESCE(SUM(D.PD8),0),2) AS unidades, ROUND(COALESCE(SUM(D.PD17),0),2) AS coste_total, ' +
    '       ROUND(COALESCE(SUM(D.PD18),0),2) AS pvp_estimado ' +
    'FROM ' + Tabla('pedidd') + ' D ' +
    'LEFT JOIN `proveedores` P ON P.P0=D.PD2 ' +
    'WHERE D.PD1 BETWEEN :desde AND :hasta ' +
    'GROUP BY D.PD2, COALESCE(P.P1,''Sin proveedor'') ORDER BY coste_total DESC LIMIT 200';
  qComProveedor.ParamByName('desde').AsDateTime := FechaDesde;
  qComProveedor.ParamByName('hasta').AsDateTime := FechaHasta;
  qComProveedor.Open;

  AjustarCampo(qComProveedor, 'proveedor', 'Prov.', 7);
  AjustarCampo(qComProveedor, 'nombre_proveedor', 'Proveedor', 24);
  AjustarCampo(qComProveedor, 'pedidos', 'Pedidos', 8);
  AjustarCampo(qComProveedor, 'lineas', 'Líneas', 8);
  AjustarCampoNumero(qComProveedor, 'unidades', 'Uds.', 9, '#,##0.##');
  AjustarCampoMoneda(qComProveedor, 'coste_total', 'Coste', 12);
  AjustarCampoMoneda(qComProveedor, 'pvp_estimado', 'PVP est.', 12);
end;

procedure TFDashboardProductividad.CargarComArticulos;
begin
  qComArticulos.Close;
  qComArticulos.SQL.Text :=
    'SELECT D.PD6 AS codigo, D.PD7 AS descripcion, COUNT(DISTINCT CONCAT(D.PD3,''/'',D.PD4)) AS pedidos, ' +
    '       ROUND(COALESCE(SUM(D.PD8),0),2) AS unidades, ROUND(COALESCE(AVG(D.PD10),0),3) AS coste_medio, ' +
    '       ROUND(COALESCE(SUM(D.PD17),0),2) AS coste_total, MAX(D.PD1) AS ultima_fecha ' +
    'FROM ' + Tabla('pedidd') + ' D ' +
    'WHERE D.PD1 BETWEEN :desde AND :hasta ' +
    'GROUP BY D.PD6, D.PD7 ORDER BY coste_total DESC LIMIT 100';
  qComArticulos.ParamByName('desde').AsDateTime := FechaDesde;
  qComArticulos.ParamByName('hasta').AsDateTime := FechaHasta;
  qComArticulos.Open;

  AjustarCampo(qComArticulos, 'codigo', 'Código', 13);
  AjustarCampo(qComArticulos, 'descripcion', 'Descripción', 30);
  AjustarCampo(qComArticulos, 'pedidos', 'Pedidos', 8);
  AjustarCampoNumero(qComArticulos, 'unidades', 'Uds.', 9, '#,##0.##');
  AjustarCampoMoneda(qComArticulos, 'coste_medio', 'Coste medio', 12);
  AjustarCampoMoneda(qComArticulos, 'coste_total', 'Coste total', 12);
  AjustarCampo(qComArticulos, 'ultima_fecha', 'Última fecha', 12);
end;

procedure TFDashboardProductividad.CargarComRevision;
begin
  qComRevision.Close;
  qComRevision.SQL.Text :=
    'SELECT DATE_FORMAT(D.PD1,''%d/%m/%Y'') AS fecha, D.PD2 AS proveedor, D.PD3 AS serie, D.PD4 AS pedido, D.PD5 AS linea, ' +
    '       D.PD6 AS codigo, D.PD7 AS descripcion, ROUND(COALESCE(D.PD8,0),2) AS unidades, ' +
    '       ROUND(COALESCE(D.PD10,0),3) AS coste, ROUND(COALESCE(D.PD16,0),2) AS pvp, COALESCE(D.PD19,0) AS familia, ' +
    '       CASE WHEN COALESCE(D.PD8,0) <= 0 THEN ''Unidades 0/negativas'' ' +
    '            WHEN COALESCE(D.PD10,0) = 0 THEN ''Coste 0'' ' +
    '            WHEN COALESCE(D.PD16,0) = 999 THEN ''PVP 999'' ' +
    '            WHEN COALESCE(D.PD19,0) = 0 THEN ''Familia 0'' ' +
    '            WHEN COALESCE(D.PD2,0) = 0 THEN ''Proveedor 0'' ' +
    '            ELSE ''Revisar'' END AS incidencia ' +
    'FROM ' + Tabla('pedidd') + ' D ' +
    'WHERE D.PD1 BETWEEN :desde AND :hasta ' +
    '  AND (COALESCE(D.PD8,0) <= 0 OR COALESCE(D.PD10,0) = 0 OR COALESCE(D.PD16,0) = 999 OR COALESCE(D.PD19,0) = 0 OR COALESCE(D.PD2,0) = 0) ' +
    'ORDER BY D.PD1 DESC, D.PD4 DESC, D.PD5 LIMIT 300';
  qComRevision.ParamByName('desde').AsDateTime := FechaDesde;
  qComRevision.ParamByName('hasta').AsDateTime := FechaHasta;
  qComRevision.Open;

  AjustarCampo(qComRevision, 'fecha', 'Fecha', 11);
  AjustarCampo(qComRevision, 'proveedor', 'Prov.', 7);
  AjustarCampo(qComRevision, 'serie', 'Serie', 6);
  AjustarCampo(qComRevision, 'pedido', 'Pedido', 8);
  AjustarCampo(qComRevision, 'linea', 'Línea', 7);
  AjustarCampo(qComRevision, 'codigo', 'Código', 13);
  AjustarCampo(qComRevision, 'descripcion', 'Descripción', 28);
  AjustarCampoNumero(qComRevision, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qComRevision, 'coste', 'Coste', 10);
  AjustarCampoMoneda(qComRevision, 'pvp', 'PVP', 10);
  AjustarCampo(qComRevision, 'familia', 'Familia', 8);
  AjustarCampo(qComRevision, 'incidencia', 'Incidencia', 18);
end;


procedure TFDashboardProductividad.CargarPromociones;
begin
  CargarPromoResumen;
  CargarPromoDescuentos;
  CargarPromoArticulos;
  CargarPromoFamilias;
  CargarPromoBajoCoste;
  CargarPromoRevision;
end;

procedure TFDashboardProductividad.CargarPromoResumen;
begin
  qPromoResumen.Close;
  qPromoResumen.SQL.Text :=
    'SELECT ''Documentos con descuento'' AS concepto, COUNT(DISTINCT CONCAT(C.HO0,''|'',C.HO1,''|'',C.HO2,''|'',C.HO3,''|'',C.HO4)) AS cantidad, ' +
    '       ROUND(COALESCE(SUM(D.HOD14),0),2) AS importe, ROUND(COALESCE(SUM(D.HOD12 * COALESCE(D.HOD11,0) / 100),0),2) AS ahorro_estimado ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD11,0) > 0 ' +
    'UNION ALL ' +
    'SELECT ''Líneas con descuento'', COUNT(*), ROUND(COALESCE(SUM(D.HOD14),0),2), ROUND(COALESCE(SUM(D.HOD12 * COALESCE(D.HOD11,0) / 100),0),2) ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD11,0) > 0 ' +
    'UNION ALL ' +
    'SELECT ''Dto. igual/superior 50%'', COUNT(*), ROUND(COALESCE(SUM(D.HOD14),0),2), ROUND(COALESCE(SUM(D.HOD12 * COALESCE(D.HOD11,0) / 100),0),2) ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD11,0) >= 50 ' +
    'UNION ALL ' +
    'SELECT ''Posibles bajo coste'', COUNT(*), ROUND(COALESCE(SUM(D.HOD14),0),2), ROUND(COALESCE(SUM((COALESCE(D.HOD8,0)*COALESCE(A.A24,0))-COALESCE(D.HOD12,0)),0),2) ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(A.A24,0) > 0 AND COALESCE(D.HOD12,0) < (COALESCE(D.HOD8,0)*COALESCE(A.A24,0)) ' +
    'UNION ALL ' +
    'SELECT ''Ventas con posible oferta'', COUNT(*), ROUND(COALESCE(SUM(D.HOD14),0),2), ROUND(COALESCE(SUM(D.HOD12 * COALESCE(D.HOD11,0) / 100),0),2) ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND (COALESCE(D.HOD11,0) > 0 OR COALESCE(D.HOD9,0) < COALESCE(D.HOD23,0))';
  qPromoResumen.ParamByName('desde').AsDateTime := FechaDesde;
  qPromoResumen.ParamByName('hasta').AsDateTime := FechaHasta;
  qPromoResumen.Open;

  AjustarCampo(qPromoResumen, 'concepto', 'Concepto', 28);
  AjustarCampoNumero(qPromoResumen, 'cantidad', 'Cantidad', 10, '#,##0.##');
  AjustarCampoMoneda(qPromoResumen, 'importe', 'Importe', 12);
  AjustarCampoMoneda(qPromoResumen, 'ahorro_estimado', 'Ahorro est.', 12);
end;

procedure TFDashboardProductividad.CargarPromoDescuentos;
begin
  qPromoDescuentos.Close;
  qPromoDescuentos.SQL.Text :=
    'SELECT DATE_FORMAT(C.HO0,''%d/%m/%Y'') AS fecha, TIME_FORMAT(C.HO1,''%H:%i'') AS hora, C.HO4 AS serie, C.HO3 AS numero, ' +
    '       D.HOD6 AS codigo, CAST(D.HOD7 AS CHAR(255)) AS descripcion, ROUND(COALESCE(D.HOD8,0),2) AS unidades, ' +
    '       ROUND(COALESCE(D.HOD9,0),2) AS pvp, ROUND(COALESCE(D.HOD11,0),2) AS dto, ' +
    '       ROUND(COALESCE(D.HOD14,0),2) AS total, ROUND(COALESCE(D.HOD12 * COALESCE(D.HOD11,0) / 100,0),2) AS ahorro_estimado ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD11,0) > 0 ' +
    'ORDER BY C.HO0 DESC, C.HO1 DESC, D.HOD11 DESC LIMIT 300';
  qPromoDescuentos.ParamByName('desde').AsDateTime := FechaDesde;
  qPromoDescuentos.ParamByName('hasta').AsDateTime := FechaHasta;
  qPromoDescuentos.Open;

  AjustarCampo(qPromoDescuentos, 'fecha', 'Fecha', 11);
  AjustarCampo(qPromoDescuentos, 'hora', 'Hora', 7);
  AjustarCampo(qPromoDescuentos, 'serie', 'Serie', 6);
  AjustarCampo(qPromoDescuentos, 'numero', 'Número', 8);
  AjustarCampo(qPromoDescuentos, 'codigo', 'Código', 13);
  AjustarCampo(qPromoDescuentos, 'descripcion', 'Descripción', 30);
  AjustarCampoNumero(qPromoDescuentos, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qPromoDescuentos, 'pvp', 'PVP', 10);
  AjustarCampoNumero(qPromoDescuentos, 'dto', 'Dto %', 10, '#,##0.00 %');
  AjustarCampoMoneda(qPromoDescuentos, 'total', 'Total', 11);
  AjustarCampoMoneda(qPromoDescuentos, 'ahorro_estimado', 'Ahorro est.', 12);
end;

procedure TFDashboardProductividad.CargarPromoArticulos;
begin
  qPromoArticulos.Close;
  qPromoArticulos.SQL.Text :=
    'SELECT D.HOD6 AS codigo, MAX(CAST(D.HOD7 AS CHAR(255))) AS descripcion, COUNT(*) AS lineas, ROUND(COALESCE(SUM(D.HOD8),0),2) AS unidades, ' +
    '       ROUND(COALESCE(AVG(NULLIF(D.HOD11,0)),0),2) AS dto_medio, ROUND(COALESCE(MAX(D.HOD11),0),2) AS dto_max, ' +
    '       ROUND(COALESCE(SUM(D.HOD14),0),2) AS importe, ROUND(COALESCE(SUM(D.HOD12 * COALESCE(D.HOD11,0) / 100),0),2) AS ahorro_estimado ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD11,0) > 0 ' +
    'GROUP BY D.HOD6 ORDER BY ahorro_estimado DESC LIMIT 100';
  qPromoArticulos.ParamByName('desde').AsDateTime := FechaDesde;
  qPromoArticulos.ParamByName('hasta').AsDateTime := FechaHasta;
  qPromoArticulos.Open;

  AjustarCampo(qPromoArticulos, 'codigo', 'Código', 13);
  AjustarCampo(qPromoArticulos, 'descripcion', 'Descripción', 30);
  AjustarCampo(qPromoArticulos, 'lineas', 'Líneas', 8);
  AjustarCampoNumero(qPromoArticulos, 'unidades', 'Uds.', 9, '#,##0.##');
  AjustarCampoNumero(qPromoArticulos, 'dto_medio', 'Dto medio %', 10, '#,##0.00 %');
  AjustarCampoNumero(qPromoArticulos, 'dto_max', 'Dto máx. %', 10, '#,##0.00 %');
  AjustarCampoMoneda(qPromoArticulos, 'importe', 'Importe', 11);
  AjustarCampoMoneda(qPromoArticulos, 'ahorro_estimado', 'Ahorro est.', 12);
end;

procedure TFDashboardProductividad.CargarPromoFamilias;
begin
  qPromoFamilias.Close;
  qPromoFamilias.SQL.Text :=
    'SELECT COALESCE(A.A14,0) AS familia, COALESCE(F.F1,''Sin familia / No asignada'') AS nombre_familia, COUNT(*) AS lineas, ' +
    '       ROUND(COALESCE(SUM(D.HOD8),0),2) AS unidades, ROUND(COALESCE(AVG(NULLIF(D.HOD11,0)),0),2) AS dto_medio, ' +
    '       ROUND(COALESCE(SUM(D.HOD14),0),2) AS importe, ROUND(COALESCE(SUM(D.HOD12 * COALESCE(D.HOD11,0) / 100),0),2) AS ahorro_estimado ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD11,0) > 0 ' +
    'GROUP BY COALESCE(A.A14,0), COALESCE(F.F1,''Sin familia / No asignada'') ORDER BY ahorro_estimado DESC LIMIT 200';
  qPromoFamilias.ParamByName('desde').AsDateTime := FechaDesde;
  qPromoFamilias.ParamByName('hasta').AsDateTime := FechaHasta;
  qPromoFamilias.Open;

  AjustarCampo(qPromoFamilias, 'familia', 'Familia', 8);
  AjustarCampo(qPromoFamilias, 'nombre_familia', 'Familia', 24);
  AjustarCampo(qPromoFamilias, 'lineas', 'Líneas', 8);
  AjustarCampoNumero(qPromoFamilias, 'unidades', 'Uds.', 9, '#,##0.##');
  AjustarCampoNumero(qPromoFamilias, 'dto_medio', 'Dto medio %', 10, '#,##0.00 %');
  AjustarCampoMoneda(qPromoFamilias, 'importe', 'Importe', 11);
  AjustarCampoMoneda(qPromoFamilias, 'ahorro_estimado', 'Ahorro est.', 12);
end;

procedure TFDashboardProductividad.CargarPromoBajoCoste;
begin
  qPromoBajoCoste.Close;
  qPromoBajoCoste.SQL.Text :=
    'SELECT DATE_FORMAT(C.HO0,''%d/%m/%Y'') AS fecha, C.HO4 AS serie, C.HO3 AS numero, D.HOD6 AS codigo, CAST(D.HOD7 AS CHAR(255)) AS descripcion, ' +
    '       ROUND(COALESCE(D.HOD8,0),2) AS unidades, ROUND(COALESCE(A.A24,0),3) AS coste_actual, ROUND(COALESCE(D.HOD10,0),3) AS precio_sin_iva, ' +
    '       ROUND(COALESCE(D.HOD12,0),2) AS base_linea, ROUND(COALESCE(D.HOD8,0)*COALESCE(A.A24,0),2) AS coste_linea, ' +
    '       ROUND(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0)),2) AS margen_estimado, ROUND(COALESCE(D.HOD11,0),2) AS dto ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' ' +
    '  AND COALESCE(A.A24,0) > 0 AND COALESCE(D.HOD8,0) > 0 AND COALESCE(D.HOD12,0) < (COALESCE(D.HOD8,0)*COALESCE(A.A24,0)) ' +
    'ORDER BY margen_estimado ASC LIMIT 300';
  qPromoBajoCoste.ParamByName('desde').AsDateTime := FechaDesde;
  qPromoBajoCoste.ParamByName('hasta').AsDateTime := FechaHasta;
  qPromoBajoCoste.Open;

  AjustarCampo(qPromoBajoCoste, 'fecha', 'Fecha', 11);
  AjustarCampo(qPromoBajoCoste, 'serie', 'Serie', 6);
  AjustarCampo(qPromoBajoCoste, 'numero', 'Número', 8);
  AjustarCampo(qPromoBajoCoste, 'codigo', 'Código', 13);
  AjustarCampo(qPromoBajoCoste, 'descripcion', 'Descripción', 28);
  AjustarCampoNumero(qPromoBajoCoste, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qPromoBajoCoste, 'coste_actual', 'Coste act.', 11);
  AjustarCampoMoneda(qPromoBajoCoste, 'precio_sin_iva', 'Precio s/IVA', 11);
  AjustarCampoMoneda(qPromoBajoCoste, 'base_linea', 'Base', 11);
  AjustarCampoMoneda(qPromoBajoCoste, 'coste_linea', 'Coste línea', 12);
  AjustarCampoMoneda(qPromoBajoCoste, 'margen_estimado', 'Margen est.', 12);
  AjustarCampoNumero(qPromoBajoCoste, 'dto', 'Dto %', 10, '#,##0.00 %');
end;

procedure TFDashboardProductividad.CargarPromoRevision;
begin
  qPromoRevision.Close;
  qPromoRevision.SQL.Text :=
    'SELECT DATE_FORMAT(C.HO0,''%d/%m/%Y'') AS fecha, C.HO4 AS serie, C.HO3 AS numero, D.HOD5 AS linea, D.HOD6 AS codigo, CAST(D.HOD7 AS CHAR(255)) AS descripcion, ' +
    '       ROUND(COALESCE(D.HOD8,0),2) AS unidades, ROUND(COALESCE(D.HOD9,0),2) AS pvp, ROUND(COALESCE(D.HOD11,0),2) AS dto, ' +
    '       ROUND(COALESCE(D.HOD14,0),2) AS total, ' +
    '       CASE WHEN COALESCE(D.HOD11,0) >= 100 THEN ''Dto 100% o más'' ' +
    '            WHEN COALESCE(D.HOD11,0) >= 50 THEN ''Dto alto'' ' +
    '            WHEN COALESCE(D.HOD11,0) < 0 THEN ''Dto negativo'' ' +
    '            WHEN COALESCE(D.HOD14,0) < 0 THEN ''Total negativo'' ' +
    '            WHEN COALESCE(D.HOD9,0) < COALESCE(D.HOD23,0) AND COALESCE(D.HOD23,0) > 0 THEN ''PVP bajo tarifa'' ' +
    '            ELSE ''Revisar'' END AS incidencia ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' ' +
    '  AND (COALESCE(D.HOD11,0) >= 50 OR COALESCE(D.HOD11,0) < 0 OR COALESCE(D.HOD14,0) < 0 OR (COALESCE(D.HOD9,0) < COALESCE(D.HOD23,0) AND COALESCE(D.HOD23,0) > 0)) ' +
    'ORDER BY C.HO0 DESC, C.HO1 DESC, D.HOD11 DESC LIMIT 300';
  qPromoRevision.ParamByName('desde').AsDateTime := FechaDesde;
  qPromoRevision.ParamByName('hasta').AsDateTime := FechaHasta;
  qPromoRevision.Open;

  AjustarCampo(qPromoRevision, 'fecha', 'Fecha', 11);
  AjustarCampo(qPromoRevision, 'serie', 'Serie', 6);
  AjustarCampo(qPromoRevision, 'numero', 'Número', 8);
  AjustarCampo(qPromoRevision, 'linea', 'Línea', 7);
  AjustarCampo(qPromoRevision, 'codigo', 'Código', 13);
  AjustarCampo(qPromoRevision, 'descripcion', 'Descripción', 28);
  AjustarCampoNumero(qPromoRevision, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qPromoRevision, 'pvp', 'PVP', 10);
  AjustarCampoNumero(qPromoRevision, 'dto', 'Dto %', 10, '#,##0.00 %');
  AjustarCampoMoneda(qPromoRevision, 'total', 'Total', 11);
  AjustarCampo(qPromoRevision, 'incidencia', 'Incidencia', 18);
end;


procedure TFDashboardProductividad.CargarRentabilidad;
begin
  CargarRentResumen;
  CargarRentArticulos;
  CargarRentFamilias;
  CargarRentProveedores;
  CargarRentDias;
  CargarRentRevision;
end;

procedure TFDashboardProductividad.CargarRentResumen;
begin
  qRentResumen.Close;
  qRentResumen.SQL.Text :=
    'SELECT ''Ventas netas'' AS concepto, COUNT(DISTINCT CONCAT(C.HO0,''|'',C.HO1,''|'',C.HO2,''|'',C.HO3,''|'',C.HO4)) AS documentos, ' +
    '       ROUND(COALESCE(SUM(D.HOD14),0),2) AS total_con_iva, ROUND(COALESCE(SUM(D.HOD12),0),2) AS base_sin_iva, ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD8,0)*COALESCE(A.A24,0)),0),2) AS coste_estimado, ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))),0),2) AS margen_estimado, ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))) / NULLIF(SUM(D.HOD12),0) * 100,0),2) AS margen_pct ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' ' +
    'UNION ALL ' +
    'SELECT ''Líneas con coste 0'', COUNT(*), ROUND(COALESCE(SUM(D.HOD14),0),2), ROUND(COALESCE(SUM(D.HOD12),0),2), 0, ROUND(COALESCE(SUM(D.HOD12),0),2), 100 ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(A.A24,0)=0 ' +
    'UNION ALL ' +
    'SELECT ''Margen negativo'', COUNT(*), ROUND(COALESCE(SUM(D.HOD14),0),2), ROUND(COALESCE(SUM(D.HOD12),0),2), ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD8,0)*COALESCE(A.A24,0)),0),2), ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))),0),2), ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))) / NULLIF(SUM(D.HOD12),0) * 100,0),2) ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' ' +
    '  AND COALESCE(A.A24,0)>0 AND COALESCE(D.HOD12,0) < (COALESCE(D.HOD8,0)*COALESCE(A.A24,0))';
  qRentResumen.ParamByName('desde').AsDateTime := FechaDesde;
  qRentResumen.ParamByName('hasta').AsDateTime := FechaHasta;
  qRentResumen.Open;

  AjustarCampo(qRentResumen, 'concepto', 'Concepto', 24);
  AjustarCampoNumero(qRentResumen, 'documentos', 'Docs/Líneas', 10, '#,##0');
  AjustarCampoMoneda(qRentResumen, 'total_con_iva', 'Total IVA', 12);
  AjustarCampoMoneda(qRentResumen, 'base_sin_iva', 'Base', 12);
  AjustarCampoMoneda(qRentResumen, 'coste_estimado', 'Coste est.', 12);
  AjustarCampoMoneda(qRentResumen, 'margen_estimado', 'Margen est.', 12);
  AjustarCampoNumero(qRentResumen, 'margen_pct', 'Margen %', 10, '#,##0.00 %');
end;

procedure TFDashboardProductividad.CargarRentArticulos;
begin
  qRentArticulos.Close;
  qRentArticulos.SQL.Text :=
    'SELECT D.HOD6 AS codigo, MAX(CAST(D.HOD7 AS CHAR(255))) AS descripcion, ROUND(COALESCE(SUM(D.HOD8),0),2) AS unidades, ' +
    '       ROUND(COALESCE(SUM(D.HOD14),0),2) AS total_con_iva, ROUND(COALESCE(SUM(D.HOD12),0),2) AS base_sin_iva, ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD8,0)*COALESCE(A.A24,0)),0),2) AS coste_estimado, ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))),0),2) AS margen_estimado, ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))) / NULLIF(SUM(D.HOD12),0) * 100,0),2) AS margen_pct ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' ' +
    'GROUP BY D.HOD6 ORDER BY margen_estimado DESC LIMIT 100';
  qRentArticulos.ParamByName('desde').AsDateTime := FechaDesde;
  qRentArticulos.ParamByName('hasta').AsDateTime := FechaHasta;
  qRentArticulos.Open;

  AjustarCampo(qRentArticulos, 'codigo', 'Código', 13);
  AjustarCampo(qRentArticulos, 'descripcion', 'Descripción', 30);
  AjustarCampoNumero(qRentArticulos, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qRentArticulos, 'total_con_iva', 'Total', 11);
  AjustarCampoMoneda(qRentArticulos, 'base_sin_iva', 'Base', 11);
  AjustarCampoMoneda(qRentArticulos, 'coste_estimado', 'Coste', 11);
  AjustarCampoMoneda(qRentArticulos, 'margen_estimado', 'Margen', 11);
  AjustarCampoNumero(qRentArticulos, 'margen_pct', '%', 9, '#,##0.00 %');
end;

procedure TFDashboardProductividad.CargarRentFamilias;
begin
  qRentFamilias.Close;
  qRentFamilias.SQL.Text :=
    'SELECT COALESCE(A.A14,0) AS familia, COALESCE(F.F1,''Sin familia / No asignada'') AS nombre_familia, ' +
    '       ROUND(COALESCE(SUM(D.HOD8),0),2) AS unidades, ROUND(COALESCE(SUM(D.HOD14),0),2) AS total_con_iva, ' +
    '       ROUND(COALESCE(SUM(D.HOD12),0),2) AS base_sin_iva, ROUND(COALESCE(SUM(COALESCE(D.HOD8,0)*COALESCE(A.A24,0)),0),2) AS coste_estimado, ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))),0),2) AS margen_estimado, ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))) / NULLIF(SUM(D.HOD12),0) * 100,0),2) AS margen_pct ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' ' +
    'GROUP BY COALESCE(A.A14,0), COALESCE(F.F1,''Sin familia / No asignada'') ORDER BY margen_estimado DESC LIMIT 200';
  qRentFamilias.ParamByName('desde').AsDateTime := FechaDesde;
  qRentFamilias.ParamByName('hasta').AsDateTime := FechaHasta;
  qRentFamilias.Open;

  AjustarCampo(qRentFamilias, 'familia', 'Familia', 8);
  AjustarCampo(qRentFamilias, 'nombre_familia', 'Familia', 24);
  AjustarCampoNumero(qRentFamilias, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qRentFamilias, 'total_con_iva', 'Total', 11);
  AjustarCampoMoneda(qRentFamilias, 'base_sin_iva', 'Base', 11);
  AjustarCampoMoneda(qRentFamilias, 'coste_estimado', 'Coste', 11);
  AjustarCampoMoneda(qRentFamilias, 'margen_estimado', 'Margen', 11);
  AjustarCampoNumero(qRentFamilias, 'margen_pct', '%', 9, '#,##0.00 %');
end;

procedure TFDashboardProductividad.CargarRentProveedores;
begin
  qRentProveedores.Close;
  qRentProveedores.SQL.Text :=
    'SELECT COALESCE(A.A32,0) AS proveedor, COALESCE(P.P1,''Sin proveedor'') AS nombre_proveedor, COUNT(DISTINCT D.HOD6) AS articulos, ' +
    '       ROUND(COALESCE(SUM(D.HOD8),0),2) AS unidades, ROUND(COALESCE(SUM(D.HOD14),0),2) AS total_con_iva, ' +
    '       ROUND(COALESCE(SUM(D.HOD12),0),2) AS base_sin_iva, ROUND(COALESCE(SUM(COALESCE(D.HOD8,0)*COALESCE(A.A24,0)),0),2) AS coste_estimado, ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))),0),2) AS margen_estimado, ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))) / NULLIF(SUM(D.HOD12),0) * 100,0),2) AS margen_pct ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' ' +
    'GROUP BY COALESCE(A.A32,0), COALESCE(P.P1,''Sin proveedor'') ORDER BY margen_estimado DESC LIMIT 200';
  qRentProveedores.ParamByName('desde').AsDateTime := FechaDesde;
  qRentProveedores.ParamByName('hasta').AsDateTime := FechaHasta;
  qRentProveedores.Open;

  AjustarCampo(qRentProveedores, 'proveedor', 'Prov.', 7);
  AjustarCampo(qRentProveedores, 'nombre_proveedor', 'Proveedor', 24);
  AjustarCampo(qRentProveedores, 'articulos', 'Art.', 6);
  AjustarCampoNumero(qRentProveedores, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qRentProveedores, 'total_con_iva', 'Total', 11);
  AjustarCampoMoneda(qRentProveedores, 'base_sin_iva', 'Base', 11);
  AjustarCampoMoneda(qRentProveedores, 'coste_estimado', 'Coste', 11);
  AjustarCampoMoneda(qRentProveedores, 'margen_estimado', 'Margen', 11);
  AjustarCampoNumero(qRentProveedores, 'margen_pct', '%', 9, '#,##0.00 %');
end;

procedure TFDashboardProductividad.CargarRentDias;
begin
  qRentDias.Close;
  qRentDias.SQL.Text :=
    'SELECT DATE_FORMAT(C.HO0,''%d/%m/%Y'') AS fecha, COUNT(DISTINCT CONCAT(C.HO0,''|'',C.HO1,''|'',C.HO2,''|'',C.HO3,''|'',C.HO4)) AS documentos, ' +
    '       ROUND(COALESCE(SUM(D.HOD14),0),2) AS total_con_iva, ROUND(COALESCE(SUM(D.HOD12),0),2) AS base_sin_iva, ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD8,0)*COALESCE(A.A24,0)),0),2) AS coste_estimado, ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))),0),2) AS margen_estimado, ' +
    '       ROUND(COALESCE(SUM(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))) / NULLIF(SUM(D.HOD12),0) * 100,0),2) AS margen_pct ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' ' +
    'GROUP BY C.HO0 ORDER BY C.HO0 DESC LIMIT 370';
  qRentDias.ParamByName('desde').AsDateTime := FechaDesde;
  qRentDias.ParamByName('hasta').AsDateTime := FechaHasta;
  qRentDias.Open;

  AjustarCampo(qRentDias, 'fecha', 'Fecha', 11);
  AjustarCampoNumero(qRentDias, 'documentos', 'Docs', 7, '#,##0');
  AjustarCampoMoneda(qRentDias, 'total_con_iva', 'Total', 11);
  AjustarCampoMoneda(qRentDias, 'base_sin_iva', 'Base', 11);
  AjustarCampoMoneda(qRentDias, 'coste_estimado', 'Coste', 11);
  AjustarCampoMoneda(qRentDias, 'margen_estimado', 'Margen', 11);
  AjustarCampoNumero(qRentDias, 'margen_pct', '%', 9, '#,##0.00 %');
end;

procedure TFDashboardProductividad.CargarRentRevision;
begin
  qRentRevision.Close;
  qRentRevision.SQL.Text :=
    'SELECT CASE ' +
    '         WHEN COALESCE(A.A24,0)=0 THEN ''Coste 0'' ' +
    '         WHEN COALESCE(D.HOD12,0) < (COALESCE(D.HOD8,0)*COALESCE(A.A24,0)) THEN ''Margen negativo'' ' +
    '         WHEN (COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))) / NULLIF(D.HOD12,0) * 100 < 10 THEN ''Margen bajo <10%'' ' +
    '         ELSE ''Revisar'' END AS incidencia, ' +
    '       DATE_FORMAT(C.HO0,''%d/%m/%Y'') AS fecha, C.HO4 AS serie, C.HO3 AS numero, D.HOD6 AS codigo, CAST(D.HOD7 AS CHAR(255)) AS descripcion, ' +
    '       ROUND(COALESCE(D.HOD8,0),2) AS unidades, ROUND(COALESCE(D.HOD12,0),2) AS base_linea, ' +
    '       ROUND(COALESCE(D.HOD8,0)*COALESCE(A.A24,0),2) AS coste_linea, ' +
    '       ROUND(COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0)),2) AS margen_estimado, ' +
    '       ROUND(COALESCE((COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))) / NULLIF(D.HOD12,0) * 100,0),2) AS margen_pct, ' +
    '       ROUND(COALESCE(A.A24,0),3) AS coste_actual ' +
    'FROM ' + Tabla('hisopdd') + ' D ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=D.HOD6 ' +
    'WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' ' +
    '  AND (COALESCE(A.A24,0)=0 OR COALESCE(D.HOD12,0) < (COALESCE(D.HOD8,0)*COALESCE(A.A24,0)) ' +
    '       OR COALESCE((COALESCE(D.HOD12,0)-(COALESCE(D.HOD8,0)*COALESCE(A.A24,0))) / NULLIF(D.HOD12,0) * 100,0) < 10) ' +
    'ORDER BY incidencia, margen_estimado ASC LIMIT 300';
  qRentRevision.ParamByName('desde').AsDateTime := FechaDesde;
  qRentRevision.ParamByName('hasta').AsDateTime := FechaHasta;
  qRentRevision.Open;

  AjustarCampo(qRentRevision, 'incidencia', 'Incidencia', 17);
  AjustarCampo(qRentRevision, 'fecha', 'Fecha', 11);
  AjustarCampo(qRentRevision, 'serie', 'Serie', 6);
  AjustarCampo(qRentRevision, 'numero', 'Número', 8);
  AjustarCampo(qRentRevision, 'codigo', 'Código', 13);
  AjustarCampo(qRentRevision, 'descripcion', 'Descripción', 28);
  AjustarCampoNumero(qRentRevision, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qRentRevision, 'base_linea', 'Base', 10);
  AjustarCampoMoneda(qRentRevision, 'coste_linea', 'Coste', 10);
  AjustarCampoMoneda(qRentRevision, 'margen_estimado', 'Margen', 10);
  AjustarCampoNumero(qRentRevision, 'margen_pct', '%', 9, '#,##0.00 %');
  AjustarCampoNumero(qRentRevision, 'coste_actual', 'Coste act.', 10, '#,##0.000');
end;


procedure TFDashboardProductividad.CargarRotacion;
begin
  CargarRotResumen;
  CargarRotAlta;
  CargarRotRiesgo;
  CargarRotBaja;
  CargarRotExceso;
  CargarRotSinVentas;
end;

procedure TFDashboardProductividad.CargarRotResumen;
begin
  qRotResumen.Close;
  qRotResumen.SQL.Text :=
    'SELECT ''Artículos con ventas en rango'' AS concepto, COUNT(*) AS articulos, ROUND(COALESCE(SUM(V.unidades),0),2) AS unidades_o_stock, ROUND(COALESCE(SUM(V.total_con_iva),0),2) AS importe_o_valor ' +
    'FROM (SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS unidades, SUM(D.HOD14) AS total_con_iva ' +
    '      FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '      WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' GROUP BY D.HOD6) V ' +
    'UNION ALL ' +
    'SELECT ''Artículos bajo mínimo'', COUNT(*), ROUND(COALESCE(SUM(A4),0),2), ROUND(COALESCE(SUM(A4*A24),0),2) FROM ' + Tabla('artitien') + ' WHERE COALESCE(A5,0)>0 AND COALESCE(A4,0)<=COALESCE(A5,0) ' +
    'UNION ALL ' +
    'SELECT ''Stock sin ventas en rango'', COUNT(*), ROUND(COALESCE(SUM(A.A4),0),2), ROUND(COALESCE(SUM(A.A4*A.A24),0),2) ' +
    'FROM ' + Tabla('artitien') + ' A LEFT JOIN (SELECT D.HOD6 AS codigo FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '      WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' GROUP BY D.HOD6) V ON V.codigo=A.A0 WHERE COALESCE(A.A4,0)>0 AND V.codigo IS NULL ' +
    'UNION ALL ' +
    'SELECT ''Valor stock actual estimado'', COUNT(*), ROUND(COALESCE(SUM(A4),0),2), ROUND(COALESCE(SUM(A4*A24),0),2) FROM ' + Tabla('artitien') + ' WHERE COALESCE(A4,0)>0';
  qRotResumen.ParamByName('desde').AsDateTime := FechaDesde;
  qRotResumen.ParamByName('hasta').AsDateTime := FechaHasta;
  qRotResumen.Open;

  AjustarCampo(qRotResumen, 'concepto', 'Concepto', 30);
  AjustarCampoNumero(qRotResumen, 'articulos', 'Artículos', 9, '#,##0');
  AjustarCampoNumero(qRotResumen, 'unidades_o_stock', 'Uds/Stock', 11, '#,##0.##');
  AjustarCampoMoneda(qRotResumen, 'importe_o_valor', 'Importe/Valor', 14);
end;

procedure TFDashboardProductividad.CargarRotAlta;
begin
  qRotAlta.Close;
  qRotAlta.SQL.Text :=
    'SELECT V.codigo, A.A1 AS descripcion, COALESCE(F.F1,''Sin familia'') AS familia, ROUND(COALESCE(V.unidades,0),2) AS unidades, ' +
    '       ROUND(COALESCE(V.total_con_iva,0),2) AS total_con_iva, ROUND(COALESCE(A.A4,0),2) AS stock_actual, ROUND(COALESCE(A.A5,0),2) AS stock_minimo, ' +
    '       ROUND(COALESCE(V.unidades,0) / GREATEST(DATEDIFF(:hasta,:desde)+1,1),2) AS ventas_dia, ' +
    '       ROUND(COALESCE(A.A4,0) / NULLIF(COALESCE(V.unidades,0) / GREATEST(DATEDIFF(:hasta,:desde)+1,1),0),1) AS dias_cobertura ' +
    'FROM (SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS unidades, SUM(D.HOD14) AS total_con_iva ' +
    '      FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '      WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' GROUP BY D.HOD6) V ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=V.codigo LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    'ORDER BY V.unidades DESC LIMIT 100';
  qRotAlta.ParamByName('desde').AsDateTime := FechaDesde;
  qRotAlta.ParamByName('hasta').AsDateTime := FechaHasta;
  qRotAlta.Open;

  AjustarCampo(qRotAlta, 'codigo', 'Código', 13);
  AjustarCampo(qRotAlta, 'descripcion', 'Descripción', 30);
  AjustarCampo(qRotAlta, 'familia', 'Familia', 20);
  AjustarCampoNumero(qRotAlta, 'unidades', 'Uds.', 8, '#,##0.##');
  AjustarCampoMoneda(qRotAlta, 'total_con_iva', 'Total', 11);
  AjustarCampoNumero(qRotAlta, 'stock_actual', 'Stock', 8, '#,##0.##');
  AjustarCampoNumero(qRotAlta, 'stock_minimo', 'Mín.', 8, '#,##0.##');
  AjustarCampoNumero(qRotAlta, 'ventas_dia', 'Uds/día', 8, '#,##0.##');
  AjustarCampoNumero(qRotAlta, 'dias_cobertura', 'Días cob.', 9, '#,##0.0');
end;

procedure TFDashboardProductividad.CargarRotRiesgo;
begin
  qRotRiesgo.Close;
  qRotRiesgo.SQL.Text :=
    'SELECT V.codigo, A.A1 AS descripcion, COALESCE(P.P1,''Sin proveedor'') AS proveedor, ROUND(COALESCE(A.A4,0),2) AS stock_actual, ROUND(COALESCE(A.A5,0),2) AS stock_minimo, ' +
    '       ROUND(COALESCE(V.unidades,0),2) AS unidades_vendidas, ROUND(COALESCE(V.unidades,0) / GREATEST(DATEDIFF(:hasta,:desde)+1,1),2) AS ventas_dia, ' +
    '       ROUND(COALESCE(A.A4,0) / NULLIF(COALESCE(V.unidades,0) / GREATEST(DATEDIFF(:hasta,:desde)+1,1),0),1) AS dias_cobertura ' +
    'FROM (SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS unidades FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '      WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' GROUP BY D.HOD6) V ' +
    'LEFT JOIN ' + Tabla('artitien') + ' A ON A.A0=V.codigo LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
    'WHERE COALESCE(A.A4,0)<=COALESCE(A.A5,0) OR COALESCE(A.A4,0) <= ((COALESCE(V.unidades,0) / GREATEST(DATEDIFF(:hasta,:desde)+1,1)) * 7) ' +
    'ORDER BY dias_cobertura ASC, unidades_vendidas DESC LIMIT 150';
  qRotRiesgo.ParamByName('desde').AsDateTime := FechaDesde;
  qRotRiesgo.ParamByName('hasta').AsDateTime := FechaHasta;
  qRotRiesgo.Open;

  AjustarCampo(qRotRiesgo, 'codigo', 'Código', 13);
  AjustarCampo(qRotRiesgo, 'descripcion', 'Descripción', 28);
  AjustarCampo(qRotRiesgo, 'proveedor', 'Proveedor', 20);
  AjustarCampoNumero(qRotRiesgo, 'stock_actual', 'Stock', 8, '#,##0.##');
  AjustarCampoNumero(qRotRiesgo, 'stock_minimo', 'Mín.', 8, '#,##0.##');
  AjustarCampoNumero(qRotRiesgo, 'unidades_vendidas', 'Uds. vend.', 10, '#,##0.##');
  AjustarCampoNumero(qRotRiesgo, 'ventas_dia', 'Uds/día', 8, '#,##0.##');
  AjustarCampoNumero(qRotRiesgo, 'dias_cobertura', 'Días cob.', 9, '#,##0.0');
end;

procedure TFDashboardProductividad.CargarRotBaja;
begin
  qRotBaja.Close;
  qRotBaja.SQL.Text :=
    'SELECT A.A0 AS codigo, A.A1 AS descripcion, COALESCE(F.F1,''Sin familia'') AS familia, ROUND(COALESCE(A.A4,0),2) AS stock_actual, ' +
    '       ROUND(COALESCE(V.unidades,0),2) AS unidades_vendidas, DATE_FORMAT(A.A12,''%d/%m/%Y'') AS ultima_venta, ' +
    '       DATEDIFF(CURDATE(), A.A12) AS dias_sin_venta, ROUND(COALESCE(A.A4,0)*COALESCE(A.A24,0),2) AS valor_stock ' +
    'FROM ' + Tabla('artitien') + ' A LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    'LEFT JOIN (SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS unidades FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '           WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' GROUP BY D.HOD6) V ON V.codigo=A.A0 ' +
    'WHERE COALESCE(A.A4,0)>0 AND COALESCE(V.unidades,0)<=1 ' +
    'ORDER BY valor_stock DESC, dias_sin_venta DESC LIMIT 200';
  qRotBaja.ParamByName('desde').AsDateTime := FechaDesde;
  qRotBaja.ParamByName('hasta').AsDateTime := FechaHasta;
  qRotBaja.Open;

  AjustarCampo(qRotBaja, 'codigo', 'Código', 13);
  AjustarCampo(qRotBaja, 'descripcion', 'Descripción', 30);
  AjustarCampo(qRotBaja, 'familia', 'Familia', 20);
  AjustarCampoNumero(qRotBaja, 'stock_actual', 'Stock', 8, '#,##0.##');
  AjustarCampoNumero(qRotBaja, 'unidades_vendidas', 'Uds. vend.', 10, '#,##0.##');
  AjustarCampo(qRotBaja, 'ultima_venta', 'Últ. venta', 11);
  AjustarCampoNumero(qRotBaja, 'dias_sin_venta', 'Días', 7, '#,##0');
  AjustarCampoMoneda(qRotBaja, 'valor_stock', 'Valor stock', 12);
end;

procedure TFDashboardProductividad.CargarRotExceso;
begin
  qRotExceso.Close;
  qRotExceso.SQL.Text :=
    'SELECT A.A0 AS codigo, A.A1 AS descripcion, COALESCE(F.F1,''Sin familia'') AS familia, ROUND(COALESCE(A.A4,0),2) AS stock_actual, ROUND(COALESCE(A.A6,0),2) AS stock_maximo, ' +
    '       ROUND(COALESCE(V.unidades,0),2) AS unidades_vendidas, ROUND(COALESCE(V.unidades,0) / GREATEST(DATEDIFF(:hasta,:desde)+1,1),2) AS ventas_dia, ' +
    '       ROUND(COALESCE(A.A4,0) / NULLIF(COALESCE(V.unidades,0) / GREATEST(DATEDIFF(:hasta,:desde)+1,1),0),1) AS dias_cobertura, ' +
    '       ROUND(COALESCE(A.A4,0)*COALESCE(A.A24,0),2) AS valor_stock ' +
    'FROM ' + Tabla('artitien') + ' A LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    'LEFT JOIN (SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS unidades FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '           WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' GROUP BY D.HOD6) V ON V.codigo=A.A0 ' +
    'WHERE COALESCE(A.A4,0)>0 AND ((COALESCE(A.A6,0)>0 AND COALESCE(A.A4,0)>COALESCE(A.A6,0)) ' +
    '      OR (COALESCE(V.unidades,0)>0 AND COALESCE(A.A4,0) / NULLIF(COALESCE(V.unidades,0) / GREATEST(DATEDIFF(:hasta,:desde)+1,1),0) > 90) ' +
    '      OR (V.codigo IS NULL AND (A.A12 IS NULL OR DATEDIFF(CURDATE(), A.A12)>180))) ' +
    'ORDER BY valor_stock DESC LIMIT 200';
  qRotExceso.ParamByName('desde').AsDateTime := FechaDesde;
  qRotExceso.ParamByName('hasta').AsDateTime := FechaHasta;
  qRotExceso.Open;

  AjustarCampo(qRotExceso, 'codigo', 'Código', 13);
  AjustarCampo(qRotExceso, 'descripcion', 'Descripción', 30);
  AjustarCampo(qRotExceso, 'familia', 'Familia', 20);
  AjustarCampoNumero(qRotExceso, 'stock_actual', 'Stock', 8, '#,##0.##');
  AjustarCampoNumero(qRotExceso, 'stock_maximo', 'Máx.', 8, '#,##0.##');
  AjustarCampoNumero(qRotExceso, 'unidades_vendidas', 'Uds. vend.', 10, '#,##0.##');
  AjustarCampoNumero(qRotExceso, 'ventas_dia', 'Uds/día', 8, '#,##0.##');
  AjustarCampoNumero(qRotExceso, 'dias_cobertura', 'Días cob.', 9, '#,##0.0');
  AjustarCampoMoneda(qRotExceso, 'valor_stock', 'Valor stock', 12);
end;

procedure TFDashboardProductividad.CargarRotSinVentas;
begin
  qRotSinVentas.Close;
  qRotSinVentas.SQL.Text :=
    'SELECT A.A0 AS codigo, A.A1 AS descripcion, COALESCE(P.P1,''Sin proveedor'') AS proveedor, COALESCE(F.F1,''Sin familia'') AS familia, ' +
    '       ROUND(COALESCE(A.A4,0),2) AS stock_actual, DATE_FORMAT(A.A12,''%d/%m/%Y'') AS ultima_venta, DATEDIFF(CURDATE(), A.A12) AS dias_sin_venta, ' +
    '       ROUND(COALESCE(A.A24,0),3) AS coste_actual, ROUND(COALESCE(A.A4,0)*COALESCE(A.A24,0),2) AS valor_stock ' +
    'FROM ' + Tabla('artitien') + ' A LEFT JOIN `proveedores` P ON P.P0=A.A32 LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    'LEFT JOIN (SELECT D.HOD6 AS codigo FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '           WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' GROUP BY D.HOD6) V ON V.codigo=A.A0 ' +
    'WHERE COALESCE(A.A4,0)>0 AND V.codigo IS NULL ' +
    'ORDER BY valor_stock DESC, dias_sin_venta DESC LIMIT 300';
  qRotSinVentas.ParamByName('desde').AsDateTime := FechaDesde;
  qRotSinVentas.ParamByName('hasta').AsDateTime := FechaHasta;
  qRotSinVentas.Open;

  AjustarCampo(qRotSinVentas, 'codigo', 'Código', 13);
  AjustarCampo(qRotSinVentas, 'descripcion', 'Descripción', 30);
  AjustarCampo(qRotSinVentas, 'proveedor', 'Proveedor', 20);
  AjustarCampo(qRotSinVentas, 'familia', 'Familia', 18);
  AjustarCampoNumero(qRotSinVentas, 'stock_actual', 'Stock', 8, '#,##0.##');
  AjustarCampo(qRotSinVentas, 'ultima_venta', 'Últ. venta', 11);
  AjustarCampoNumero(qRotSinVentas, 'dias_sin_venta', 'Días', 7, '#,##0');
  AjustarCampoNumero(qRotSinVentas, 'coste_actual', 'Coste', 9, '#,##0.000');
  AjustarCampoMoneda(qRotSinVentas, 'valor_stock', 'Valor stock', 12);
end;

procedure TFDashboardProductividad.CargarReposicion;
begin
  CargarRepResumen;
  CargarRepSugerido;
  CargarRepUrgente;
  CargarRepProveedor;
  CargarRepSinProveedor;
  CargarRepBajaRotacion;
end;

procedure TFDashboardProductividad.CargarRepResumen;
begin
  qRepResumen.Close;
  qRepResumen.SQL.Text :=
    'SELECT ''Stock bajo'' AS concepto, COUNT(*) AS articulos, CAST(NULL AS DECIMAL(12,2)) AS importe ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'WHERE COALESCE(A.A5,0) > 0 AND COALESCE(A.A4,0) <= COALESCE(A.A5,0) ' +
    'UNION ALL ' +
    'SELECT ''Stock 0 vendido'', COUNT(DISTINCT A.A0), ROUND(COALESCE(SUM(D.HOD14),0),2) ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'JOIN ' + Tabla('hisopdd') + ' D ON D.HOD6=A.A0 ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'WHERE COALESCE(A.A4,0) <= 0 AND C.HO0 BETWEEN :desde AND :hasta ' +
    '  AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 ' +
    'UNION ALL ' +
    'SELECT ''Vendidos sin proveedor'', COUNT(DISTINCT A.A0), ROUND(COALESCE(SUM(D.HOD14),0),2) ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
    'JOIN ' + Tabla('hisopdd') + ' D ON D.HOD6=A.A0 ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'WHERE (COALESCE(A.A32,0)=0 OR P.P0 IS NULL) AND C.HO0 BETWEEN :desde AND :hasta ' +
    '  AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 ' +
    'UNION ALL ' +
    'SELECT ''Coste 0 vendido'', COUNT(DISTINCT A.A0), ROUND(COALESCE(SUM(D.HOD14),0),2) ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'JOIN ' + Tabla('hisopdd') + ' D ON D.HOD6=A.A0 ' +
    'JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    'WHERE COALESCE(A.A24,0)=0 AND C.HO0 BETWEEN :desde AND :hasta ' +
    '  AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 ' +
    'UNION ALL ' +
    'SELECT ''Stock sin ventas en rango'', COUNT(*), CAST(NULL AS DECIMAL(12,2)) ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'LEFT JOIN ( ' +
    '  SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS uds ' +
    '  FROM ' + Tabla('hisopdd') + ' D ' +
    '  JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '  WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 ' +
    '  GROUP BY D.HOD6 ' +
    ') V ON V.codigo=A.A0 ' +
    'WHERE COALESCE(A.A4,0) > 0 AND COALESCE(V.uds,0)=0';
  qRepResumen.ParamByName('desde').AsDateTime := FechaDesde;
  qRepResumen.ParamByName('hasta').AsDateTime := FechaHasta;
  qRepResumen.Open;

  AjustarCampo(qRepResumen, 'concepto', 'Concepto', 28);
  AjustarCampo(qRepResumen, 'articulos', 'Artículos', 9);
  AjustarCampoMoneda(qRepResumen, 'importe', 'Importe', 12);
end;

procedure TFDashboardProductividad.CargarRepSugerido;
var
  Dias: Double;
begin
  Dias := DaysBetween(FechaHasta, FechaDesde) + 1;
  if Dias < 1 then Dias := 1;

  qRepSugerido.Close;
  qRepSugerido.SQL.Text :=
    'SELECT A.A0 AS codigo, A.A1 AS descripcion, ' +
    '       ROUND(COALESCE(A.A4,0),2) AS stock, ROUND(COALESCE(A.A5,0),2) AS stock_min, ' +
    '       ROUND(COALESCE(V.uds,0),2) AS uds_vendidas, ' +
    '       ROUND(COALESCE(V.uds,0) / :dias, 2) AS venta_dia, ' +
    '       CASE WHEN COALESCE(V.uds,0) > 0 THEN ROUND(COALESCE(A.A4,0) / (COALESCE(V.uds,0) / :dias),1) ELSE 9999 END AS cobertura_dias, ' +
    '       GREATEST(0, CEIL(GREATEST(COALESCE(A.A5,0)-COALESCE(A.A4,0), ((COALESCE(V.uds,0) / :dias) * 15) - COALESCE(A.A4,0)))) AS pedir_sugerido, ' +
    '       COALESCE(A.A32,0) AS proveedor, COALESCE(P.P1,''Sin proveedor'') AS nombre_proveedor ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
    'LEFT JOIN ( ' +
    '  SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS uds, SUM(D.HOD14) AS importe, MAX(D.HOD0) AS ultima_venta ' +
    '  FROM ' + Tabla('hisopdd') + ' D ' +
    '  JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '  WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 ' +
    '  GROUP BY D.HOD6 ' +
    ') V ON V.codigo=A.A0 ' +
    'WHERE (COALESCE(A.A5,0) > 0 AND COALESCE(A.A4,0) <= COALESCE(A.A5,0)) ' +
    '   OR (COALESCE(V.uds,0) > 0 AND COALESCE(A.A4,0) <= ((COALESCE(V.uds,0) / :dias) * 7)) ' +
    'ORDER BY pedir_sugerido DESC, cobertura_dias ASC, A.A1 ' +
    'LIMIT 100';
  qRepSugerido.ParamByName('desde').AsDateTime := FechaDesde;
  qRepSugerido.ParamByName('hasta').AsDateTime := FechaHasta;
  qRepSugerido.ParamByName('dias').AsFloat := Dias;
  qRepSugerido.Open;

  AjustarCampo(qRepSugerido, 'codigo', 'Código', 13);
  AjustarCampo(qRepSugerido, 'descripcion', 'Descripción', 28);
  AjustarCampoNumero(qRepSugerido, 'stock', 'Stock', 8, '#,##0.##');
  AjustarCampoNumero(qRepSugerido, 'stock_min', 'Mín.', 8, '#,##0.##');
  AjustarCampoNumero(qRepSugerido, 'uds_vendidas', 'Vendidas', 9, '#,##0.##');
  AjustarCampoNumero(qRepSugerido, 'venta_dia', 'Uds/día', 8, '#,##0.##');
  AjustarCampoNumero(qRepSugerido, 'cobertura_dias', 'Días cub.', 9, '#,##0.0');
  AjustarCampoNumero(qRepSugerido, 'pedir_sugerido', 'Pedir', 8, '#,##0');
  AjustarCampo(qRepSugerido, 'proveedor', 'Prov.', 6);
  AjustarCampo(qRepSugerido, 'nombre_proveedor', 'Proveedor', 20);
end;

procedure TFDashboardProductividad.CargarRepUrgente;
begin
  qRepUrgente.Close;
  qRepUrgente.SQL.Text :=
    'SELECT A.A0 AS codigo, A.A1 AS descripcion, ROUND(COALESCE(A.A4,0),2) AS stock, ' +
    '       ROUND(COALESCE(V.uds,0),2) AS uds_vendidas, ROUND(COALESCE(V.importe,0),2) AS importe, ' +
    '       DATE_FORMAT(V.ultima_venta, ''%d/%m/%Y'') AS ultima_venta, COALESCE(P.P1,''Sin proveedor'') AS proveedor ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
    'JOIN ( ' +
    '  SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS uds, SUM(D.HOD14) AS importe, MAX(D.HOD0) AS ultima_venta ' +
    '  FROM ' + Tabla('hisopdd') + ' D ' +
    '  JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '  WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 ' +
    '  GROUP BY D.HOD6 ' +
    ') V ON V.codigo=A.A0 ' +
    'WHERE COALESCE(A.A4,0) <= 0 ' +
    'ORDER BY V.uds DESC, V.ultima_venta DESC ' +
    'LIMIT 100';
  qRepUrgente.ParamByName('desde').AsDateTime := FechaDesde;
  qRepUrgente.ParamByName('hasta').AsDateTime := FechaHasta;
  qRepUrgente.Open;

  AjustarCampo(qRepUrgente, 'codigo', 'Código', 13);
  AjustarCampo(qRepUrgente, 'descripcion', 'Descripción', 26);
  AjustarCampoNumero(qRepUrgente, 'stock', 'Stock', 7, '#,##0.##');
  AjustarCampoNumero(qRepUrgente, 'uds_vendidas', 'Vendidas', 9, '#,##0.##');
  AjustarCampoMoneda(qRepUrgente, 'importe', 'Importe', 10);
  AjustarCampo(qRepUrgente, 'ultima_venta', 'Últ. venta', 11);
  AjustarCampo(qRepUrgente, 'proveedor', 'Proveedor', 20);
end;

procedure TFDashboardProductividad.CargarRepProveedor;
var
  Dias: Double;
begin
  Dias := DaysBetween(FechaHasta, FechaDesde) + 1;
  if Dias < 1 then Dias := 1;

  qRepProveedor.Close;
  qRepProveedor.SQL.Text :=
    'SELECT X.proveedor, X.nombre_proveedor, COUNT(*) AS articulos, ' +
    '       ROUND(SUM(X.uds_vendidas),2) AS uds_vendidas, ' +
    '       ROUND(SUM(X.pedir_sugerido),0) AS uds_a_pedir ' +
    'FROM ( ' +
    '  SELECT COALESCE(A.A32,0) AS proveedor, COALESCE(P.P1,''Sin proveedor'') AS nombre_proveedor, ' +
    '         COALESCE(V.uds,0) AS uds_vendidas, ' +
    '         GREATEST(0, CEIL(GREATEST(COALESCE(A.A5,0)-COALESCE(A.A4,0), ((COALESCE(V.uds,0) / :dias) * 15) - COALESCE(A.A4,0)))) AS pedir_sugerido ' +
    '  FROM ' + Tabla('artitien') + ' A ' +
    '  LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
    '  LEFT JOIN ( ' +
    '    SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS uds ' +
    '    FROM ' + Tabla('hisopdd') + ' D ' +
    '    JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '    WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 ' +
    '    GROUP BY D.HOD6 ' +
    '  ) V ON V.codigo=A.A0 ' +
    '  WHERE (COALESCE(A.A5,0) > 0 AND COALESCE(A.A4,0) <= COALESCE(A.A5,0)) ' +
    '     OR (COALESCE(V.uds,0) > 0 AND COALESCE(A.A4,0) <= ((COALESCE(V.uds,0) / :dias) * 7)) ' +
    ') X ' +
    'WHERE X.pedir_sugerido > 0 ' +
    'GROUP BY X.proveedor, X.nombre_proveedor ' +
    'ORDER BY uds_a_pedir DESC, articulos DESC ' +
    'LIMIT 50';
  qRepProveedor.ParamByName('desde').AsDateTime := FechaDesde;
  qRepProveedor.ParamByName('hasta').AsDateTime := FechaHasta;
  qRepProveedor.ParamByName('dias').AsFloat := Dias;
  qRepProveedor.Open;

  AjustarCampo(qRepProveedor, 'proveedor', 'Prov.', 7);
  AjustarCampo(qRepProveedor, 'nombre_proveedor', 'Proveedor', 28);
  AjustarCampo(qRepProveedor, 'articulos', 'Arts.', 7);
  AjustarCampoNumero(qRepProveedor, 'uds_vendidas', 'Vendidas', 9, '#,##0.##');
  AjustarCampoNumero(qRepProveedor, 'uds_a_pedir', 'A pedir', 9, '#,##0');
end;

procedure TFDashboardProductividad.CargarRepSinProveedor;
begin
  qRepSinProveedor.Close;
  qRepSinProveedor.SQL.Text :=
    'SELECT A.A0 AS codigo, A.A1 AS descripcion, ROUND(COALESCE(A.A4,0),2) AS stock, ' +
    '       ROUND(COALESCE(V.uds,0),2) AS uds_vendidas, ROUND(COALESCE(V.importe,0),2) AS importe, ' +
    '       COALESCE(A.A32,0) AS proveedor ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
    'JOIN ( ' +
    '  SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS uds, SUM(D.HOD14) AS importe ' +
    '  FROM ' + Tabla('hisopdd') + ' D ' +
    '  JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '  WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 ' +
    '  GROUP BY D.HOD6 ' +
    ') V ON V.codigo=A.A0 ' +
    'WHERE COALESCE(A.A32,0)=0 OR P.P0 IS NULL ' +
    'ORDER BY V.uds DESC, A.A1 ' +
    'LIMIT 100';
  qRepSinProveedor.ParamByName('desde').AsDateTime := FechaDesde;
  qRepSinProveedor.ParamByName('hasta').AsDateTime := FechaHasta;
  qRepSinProveedor.Open;

  AjustarCampo(qRepSinProveedor, 'codigo', 'Código', 13);
  AjustarCampo(qRepSinProveedor, 'descripcion', 'Descripción', 28);
  AjustarCampoNumero(qRepSinProveedor, 'stock', 'Stock', 8, '#,##0.##');
  AjustarCampoNumero(qRepSinProveedor, 'uds_vendidas', 'Vendidas', 9, '#,##0.##');
  AjustarCampoMoneda(qRepSinProveedor, 'importe', 'Importe', 11);
  AjustarCampo(qRepSinProveedor, 'proveedor', 'Prov.', 7);
end;

procedure TFDashboardProductividad.CargarRepBajaRotacion;
begin
  qRepBajaRotacion.Close;
  qRepBajaRotacion.SQL.Text :=
    'SELECT A.A0 AS codigo, A.A1 AS descripcion, ROUND(COALESCE(A.A4,0),2) AS stock, ' +
    '       ROUND(COALESCE(A.A24,0),2) AS coste, ' +
    '       ROUND(COALESCE(A.A4,0) * COALESCE(A.A24,0),2) AS valor_stock, ' +
    '       DATE_FORMAT(A.A12, ''%d/%m/%Y'') AS ultima_venta, ' +
    '       COALESCE(F.F1,''Sin familia'') AS familia ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    'LEFT JOIN ( ' +
    '  SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS uds ' +
    '  FROM ' + Tabla('hisopdd') + ' D ' +
    '  JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '  WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 ' +
    '  GROUP BY D.HOD6 ' +
    ') V ON V.codigo=A.A0 ' +
    'WHERE COALESCE(A.A4,0) > 0 AND COALESCE(V.uds,0)=0 ' +
    'ORDER BY valor_stock DESC, A.A12 ' +
    'LIMIT 100';
  qRepBajaRotacion.ParamByName('desde').AsDateTime := FechaDesde;
  qRepBajaRotacion.ParamByName('hasta').AsDateTime := FechaHasta;
  qRepBajaRotacion.Open;

  AjustarCampo(qRepBajaRotacion, 'codigo', 'Código', 13);
  AjustarCampo(qRepBajaRotacion, 'descripcion', 'Descripción', 28);
  AjustarCampoNumero(qRepBajaRotacion, 'stock', 'Stock', 8, '#,##0.##');
  AjustarCampoMoneda(qRepBajaRotacion, 'coste', 'Coste', 10);
  AjustarCampoMoneda(qRepBajaRotacion, 'valor_stock', 'Valor stock', 12);
  AjustarCampo(qRepBajaRotacion, 'ultima_venta', 'Últ. venta', 11);
  AjustarCampo(qRepBajaRotacion, 'familia', 'Familia', 20);
end;


procedure TFDashboardProductividad.CargarPicking;
begin
  CargarPickResumen;
  CargarPickRuta;
  CargarPickUbicacion;
  CargarPickProveedor;
  CargarPickSinUbicacion;
  CargarPickRevision;
end;

procedure TFDashboardProductividad.CargarPickResumen;
var
  Dias: Double;
begin
  Dias := DaysBetween(FechaHasta, FechaDesde) + 1;
  if Dias < 1 then Dias := 1;

  qPickResumen.Close;
  qPickResumen.SQL.Text :=
    'SELECT ''Líneas a preparar'' AS concepto, COUNT(*) AS cantidad, ROUND(SUM(X.pedir_sugerido),0) AS unidades ' +
    'FROM ( ' +
    '  SELECT A.A0, COALESCE(A.A23,'''') AS ubicacion, COALESCE(A.A32,0) AS proveedor, ' +
    '         GREATEST(0, CEIL(GREATEST(COALESCE(A.A5,0)-COALESCE(A.A4,0), ((COALESCE(V.uds,0) / :dias) * 15) - COALESCE(A.A4,0)))) AS pedir_sugerido ' +
    '  FROM ' + Tabla('artitien') + ' A ' +
    '  LEFT JOIN ( ' +
    '    SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS uds ' +
    '    FROM ' + Tabla('hisopdd') + ' D ' +
    '    JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '    WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 ' +
    '    GROUP BY D.HOD6 ' +
    '  ) V ON V.codigo=A.A0 ' +
    '  WHERE (COALESCE(A.A5,0) > 0 AND COALESCE(A.A4,0) <= COALESCE(A.A5,0)) ' +
    '     OR (COALESCE(V.uds,0) > 0 AND COALESCE(A.A4,0) <= ((COALESCE(V.uds,0) / :dias) * 7)) ' +
    ') X WHERE X.pedir_sugerido > 0 ' +
    'UNION ALL ' +
    'SELECT ''Sin ubicación'', COUNT(*), ROUND(SUM(X.pedir_sugerido),0) FROM ( ' +
    '  SELECT A.A0, COALESCE(A.A23,'''') AS ubicacion, ' +
    '         GREATEST(0, CEIL(GREATEST(COALESCE(A.A5,0)-COALESCE(A.A4,0), ((COALESCE(V.uds,0) / :dias) * 15) - COALESCE(A.A4,0)))) AS pedir_sugerido ' +
    '  FROM ' + Tabla('artitien') + ' A ' +
    '  LEFT JOIN (SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS uds FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 GROUP BY D.HOD6) V ON V.codigo=A.A0 ' +
    '  WHERE (COALESCE(A.A5,0) > 0 AND COALESCE(A.A4,0) <= COALESCE(A.A5,0)) OR (COALESCE(V.uds,0) > 0 AND COALESCE(A.A4,0) <= ((COALESCE(V.uds,0) / :dias) * 7)) ' +
    ') X WHERE X.pedir_sugerido > 0 AND TRIM(COALESCE(X.ubicacion,'''')) = '''' ' +
    'UNION ALL ' +
    'SELECT ''Proveedores implicados'', COUNT(DISTINCT X.proveedor), ROUND(SUM(X.pedir_sugerido),0) FROM ( ' +
    '  SELECT COALESCE(A.A32,0) AS proveedor, GREATEST(0, CEIL(GREATEST(COALESCE(A.A5,0)-COALESCE(A.A4,0), ((COALESCE(V.uds,0) / :dias) * 15) - COALESCE(A.A4,0)))) AS pedir_sugerido ' +
    '  FROM ' + Tabla('artitien') + ' A ' +
    '  LEFT JOIN (SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS uds FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 GROUP BY D.HOD6) V ON V.codigo=A.A0 ' +
    '  WHERE (COALESCE(A.A5,0) > 0 AND COALESCE(A.A4,0) <= COALESCE(A.A5,0)) OR (COALESCE(V.uds,0) > 0 AND COALESCE(A.A4,0) <= ((COALESCE(V.uds,0) / :dias) * 7)) ' +
    ') X WHERE X.pedir_sugerido > 0 ' +
    'UNION ALL ' +
    'SELECT ''Revisiones necesarias'', COUNT(*), NULL FROM ' + Tabla('artitien') + ' A ' +
    'WHERE COALESCE(A.A2,0)=999 OR COALESCE(A.A24,0)=0 OR COALESCE(A.A14,0)=0 OR COALESCE(A.A32,0)=0';
  qPickResumen.ParamByName('desde').AsDateTime := FechaDesde;
  qPickResumen.ParamByName('hasta').AsDateTime := FechaHasta;
  qPickResumen.ParamByName('dias').AsFloat := Dias;
  qPickResumen.Open;

  AjustarCampo(qPickResumen, 'concepto', 'Concepto', 26);
  AjustarCampo(qPickResumen, 'cantidad', 'Cantidad', 9);
  AjustarCampoNumero(qPickResumen, 'unidades', 'Unidades', 10, '#,##0');
end;

procedure TFDashboardProductividad.CargarPickRuta;
var
  Dias: Double;
begin
  Dias := DaysBetween(FechaHasta, FechaDesde) + 1;
  if Dias < 1 then Dias := 1;

  qPickRuta.Close;
  qPickRuta.SQL.Text :=
    'SELECT A.A0 AS codigo, A.A1 AS descripcion, ' +
    '       COALESCE(NULLIF(TRIM(A.A23),''''),''SIN UBICACIÓN'') AS ubicacion, ' +
    '       ROUND(COALESCE(A.A4,0),2) AS stock, ROUND(COALESCE(A.A5,0),2) AS stock_min, ' +
    '       ROUND(COALESCE(V.uds,0),2) AS uds_vendidas, ' +
    '       GREATEST(0, CEIL(GREATEST(COALESCE(A.A5,0)-COALESCE(A.A4,0), ((COALESCE(V.uds,0) / :dias) * 15) - COALESCE(A.A4,0)))) AS preparar, ' +
    '       COALESCE(F.F1,''Sin familia'') AS familia, COALESCE(P.P1,''Sin proveedor'') AS proveedor ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
    'LEFT JOIN ( ' +
    '  SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS uds ' +
    '  FROM ' + Tabla('hisopdd') + ' D ' +
    '  JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
    '  WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 ' +
    '  GROUP BY D.HOD6 ' +
    ') V ON V.codigo=A.A0 ' +
    'WHERE ((COALESCE(A.A5,0) > 0 AND COALESCE(A.A4,0) <= COALESCE(A.A5,0)) ' +
    '   OR (COALESCE(V.uds,0) > 0 AND COALESCE(A.A4,0) <= ((COALESCE(V.uds,0) / :dias) * 7))) ' +
    'HAVING preparar > 0 ' +
    'ORDER BY CASE WHEN ubicacion=''SIN UBICACIÓN'' THEN 1 ELSE 0 END, ubicacion, familia, A.A1 ' +
    'LIMIT 150';
  qPickRuta.ParamByName('desde').AsDateTime := FechaDesde;
  qPickRuta.ParamByName('hasta').AsDateTime := FechaHasta;
  qPickRuta.ParamByName('dias').AsFloat := Dias;
  qPickRuta.Open;

  AjustarCampo(qPickRuta, 'codigo', 'Código', 13);
  AjustarCampo(qPickRuta, 'descripcion', 'Descripción', 30);
  AjustarCampo(qPickRuta, 'ubicacion', 'Ubicación', 16);
  AjustarCampoNumero(qPickRuta, 'stock', 'Stock', 8, '#,##0.##');
  AjustarCampoNumero(qPickRuta, 'stock_min', 'Mín.', 7, '#,##0.##');
  AjustarCampoNumero(qPickRuta, 'uds_vendidas', 'Vendidas', 9, '#,##0.##');
  AjustarCampoNumero(qPickRuta, 'preparar', 'Preparar', 9, '#,##0');
  AjustarCampo(qPickRuta, 'familia', 'Familia', 20);
  AjustarCampo(qPickRuta, 'proveedor', 'Proveedor', 20);
end;

procedure TFDashboardProductividad.CargarPickUbicacion;
var
  Dias: Double;
begin
  Dias := DaysBetween(FechaHasta, FechaDesde) + 1;
  if Dias < 1 then Dias := 1;

  qPickUbicacion.Close;
  qPickUbicacion.SQL.Text :=
    'SELECT X.ubicacion, X.familia, COUNT(*) AS articulos, ROUND(SUM(X.preparar),0) AS preparar, ROUND(SUM(X.uds_vendidas),2) AS uds_vendidas ' +
    'FROM ( ' +
    '  SELECT COALESCE(NULLIF(TRIM(A.A23),''''),''SIN UBICACIÓN'') AS ubicacion, COALESCE(F.F1,''Sin familia'') AS familia, COALESCE(V.uds,0) AS uds_vendidas, ' +
    '         GREATEST(0, CEIL(GREATEST(COALESCE(A.A5,0)-COALESCE(A.A4,0), ((COALESCE(V.uds,0) / :dias) * 15) - COALESCE(A.A4,0)))) AS preparar ' +
    '  FROM ' + Tabla('artitien') + ' A ' +
    '  LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    '  LEFT JOIN (SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS uds FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 GROUP BY D.HOD6) V ON V.codigo=A.A0 ' +
    '  WHERE (COALESCE(A.A5,0) > 0 AND COALESCE(A.A4,0) <= COALESCE(A.A5,0)) OR (COALESCE(V.uds,0) > 0 AND COALESCE(A.A4,0) <= ((COALESCE(V.uds,0) / :dias) * 7)) ' +
    ') X WHERE X.preparar > 0 ' +
    'GROUP BY X.ubicacion, X.familia ' +
    'ORDER BY CASE WHEN X.ubicacion=''SIN UBICACIÓN'' THEN 1 ELSE 0 END, X.ubicacion, X.familia';
  qPickUbicacion.ParamByName('desde').AsDateTime := FechaDesde;
  qPickUbicacion.ParamByName('hasta').AsDateTime := FechaHasta;
  qPickUbicacion.ParamByName('dias').AsFloat := Dias;
  qPickUbicacion.Open;

  AjustarCampo(qPickUbicacion, 'ubicacion', 'Ubicación', 18);
  AjustarCampo(qPickUbicacion, 'familia', 'Familia', 24);
  AjustarCampo(qPickUbicacion, 'articulos', 'Arts.', 7);
  AjustarCampoNumero(qPickUbicacion, 'preparar', 'Preparar', 9, '#,##0');
  AjustarCampoNumero(qPickUbicacion, 'uds_vendidas', 'Vendidas', 9, '#,##0.##');
end;

procedure TFDashboardProductividad.CargarPickProveedor;
var
  Dias: Double;
begin
  Dias := DaysBetween(FechaHasta, FechaDesde) + 1;
  if Dias < 1 then Dias := 1;

  qPickProveedor.Close;
  qPickProveedor.SQL.Text :=
    'SELECT X.proveedor, X.nombre_proveedor, COUNT(*) AS articulos, ROUND(SUM(X.preparar),0) AS preparar, ROUND(SUM(X.coste_orientativo),2) AS coste_orientativo ' +
    'FROM ( ' +
    '  SELECT COALESCE(A.A32,0) AS proveedor, COALESCE(P.P1,''Sin proveedor'') AS nombre_proveedor, ' +
    '         GREATEST(0, CEIL(GREATEST(COALESCE(A.A5,0)-COALESCE(A.A4,0), ((COALESCE(V.uds,0) / :dias) * 15) - COALESCE(A.A4,0)))) AS preparar, ' +
    '         GREATEST(0, CEIL(GREATEST(COALESCE(A.A5,0)-COALESCE(A.A4,0), ((COALESCE(V.uds,0) / :dias) * 15) - COALESCE(A.A4,0)))) * COALESCE(A.A24,0) AS coste_orientativo ' +
    '  FROM ' + Tabla('artitien') + ' A ' +
    '  LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
    '  LEFT JOIN (SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS uds FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 GROUP BY D.HOD6) V ON V.codigo=A.A0 ' +
    '  WHERE (COALESCE(A.A5,0) > 0 AND COALESCE(A.A4,0) <= COALESCE(A.A5,0)) OR (COALESCE(V.uds,0) > 0 AND COALESCE(A.A4,0) <= ((COALESCE(V.uds,0) / :dias) * 7)) ' +
    ') X WHERE X.preparar > 0 ' +
    'GROUP BY X.proveedor, X.nombre_proveedor ' +
    'ORDER BY preparar DESC, coste_orientativo DESC ' +
    'LIMIT 80';
  qPickProveedor.ParamByName('desde').AsDateTime := FechaDesde;
  qPickProveedor.ParamByName('hasta').AsDateTime := FechaHasta;
  qPickProveedor.ParamByName('dias').AsFloat := Dias;
  qPickProveedor.Open;

  AjustarCampo(qPickProveedor, 'proveedor', 'Prov.', 7);
  AjustarCampo(qPickProveedor, 'nombre_proveedor', 'Proveedor', 28);
  AjustarCampo(qPickProveedor, 'articulos', 'Arts.', 7);
  AjustarCampoNumero(qPickProveedor, 'preparar', 'Preparar', 9, '#,##0');
  AjustarCampoMoneda(qPickProveedor, 'coste_orientativo', 'Coste orient.', 12);
end;

procedure TFDashboardProductividad.CargarPickSinUbicacion;
var
  Dias: Double;
begin
  Dias := DaysBetween(FechaHasta, FechaDesde) + 1;
  if Dias < 1 then Dias := 1;

  qPickSinUbicacion.Close;
  qPickSinUbicacion.SQL.Text :=
    'SELECT A.A0 AS codigo, A.A1 AS descripcion, ROUND(COALESCE(A.A4,0),2) AS stock, ROUND(COALESCE(V.uds,0),2) AS uds_vendidas, ' +
    '       GREATEST(0, CEIL(GREATEST(COALESCE(A.A5,0)-COALESCE(A.A4,0), ((COALESCE(V.uds,0) / :dias) * 15) - COALESCE(A.A4,0)))) AS preparar, ' +
    '       COALESCE(F.F1,''Sin familia'') AS familia, COALESCE(P.P1,''Sin proveedor'') AS proveedor ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
    'LEFT JOIN (SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS uds FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 GROUP BY D.HOD6) V ON V.codigo=A.A0 ' +
    'WHERE TRIM(COALESCE(A.A23,'''')) = '''' AND ((COALESCE(A.A5,0) > 0 AND COALESCE(A.A4,0) <= COALESCE(A.A5,0)) OR (COALESCE(V.uds,0) > 0 AND COALESCE(A.A4,0) <= ((COALESCE(V.uds,0) / :dias) * 7))) ' +
    'HAVING preparar > 0 ' +
    'ORDER BY preparar DESC, A.A1 ' +
    'LIMIT 120';
  qPickSinUbicacion.ParamByName('desde').AsDateTime := FechaDesde;
  qPickSinUbicacion.ParamByName('hasta').AsDateTime := FechaHasta;
  qPickSinUbicacion.ParamByName('dias').AsFloat := Dias;
  qPickSinUbicacion.Open;

  AjustarCampo(qPickSinUbicacion, 'codigo', 'Código', 13);
  AjustarCampo(qPickSinUbicacion, 'descripcion', 'Descripción', 30);
  AjustarCampoNumero(qPickSinUbicacion, 'stock', 'Stock', 8, '#,##0.##');
  AjustarCampoNumero(qPickSinUbicacion, 'uds_vendidas', 'Vendidas', 9, '#,##0.##');
  AjustarCampoNumero(qPickSinUbicacion, 'preparar', 'Preparar', 9, '#,##0');
  AjustarCampo(qPickSinUbicacion, 'familia', 'Familia', 20);
  AjustarCampo(qPickSinUbicacion, 'proveedor', 'Proveedor', 20);
end;

procedure TFDashboardProductividad.CargarPickRevision;
var
  Dias: Double;
begin
  Dias := DaysBetween(FechaHasta, FechaDesde) + 1;
  if Dias < 1 then Dias := 1;

  qPickRevision.Close;
  qPickRevision.SQL.Text :=
    'SELECT A.A0 AS codigo, A.A1 AS descripcion, ' +
    '       GREATEST(0, CEIL(GREATEST(COALESCE(A.A5,0)-COALESCE(A.A4,0), ((COALESCE(V.uds,0) / :dias) * 15) - COALESCE(A.A4,0)))) AS preparar, ' +
    '       ROUND(COALESCE(A.A2,0),2) AS pvp, ROUND(COALESCE(A.A24,0),2) AS coste, COALESCE(A.A14,0) AS familia, COALESCE(A.A32,0) AS proveedor, ' +
    '       CONCAT_WS('', '', IF(COALESCE(A.A2,0)=999,''PVP 999'',NULL), IF(COALESCE(A.A24,0)=0,''Coste 0'',NULL), IF(COALESCE(A.A14,0)=0,''Familia 0'',NULL), IF(COALESCE(A.A32,0)=0,''Proveedor 0'',NULL), IF(TRIM(COALESCE(A.A23,''''))='''',''Sin ubicación'',NULL)) AS revisar ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'LEFT JOIN (SELECT D.HOD6 AS codigo, SUM(D.HOD8) AS uds FROM ' + Tabla('hisopdd') + ' D JOIN ' + Tabla('hisopcc') + ' C ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 WHERE C.HO0 BETWEEN :desde AND :hasta AND C.HO5 IN (''NS'',''NT'',''FA'') AND COALESCE(C.HO16,'''') <> ''A'' AND COALESCE(D.HOD8,0) > 0 GROUP BY D.HOD6) V ON V.codigo=A.A0 ' +
    'WHERE ((COALESCE(A.A5,0) > 0 AND COALESCE(A.A4,0) <= COALESCE(A.A5,0)) OR (COALESCE(V.uds,0) > 0 AND COALESCE(A.A4,0) <= ((COALESCE(V.uds,0) / :dias) * 7))) ' +
    '  AND (COALESCE(A.A2,0)=999 OR COALESCE(A.A24,0)=0 OR COALESCE(A.A14,0)=0 OR COALESCE(A.A32,0)=0 OR TRIM(COALESCE(A.A23,''''))='''') ' +
    'HAVING preparar > 0 ' +
    'ORDER BY preparar DESC, A.A1 ' +
    'LIMIT 120';
  qPickRevision.ParamByName('desde').AsDateTime := FechaDesde;
  qPickRevision.ParamByName('hasta').AsDateTime := FechaHasta;
  qPickRevision.ParamByName('dias').AsFloat := Dias;
  qPickRevision.Open;

  AjustarCampo(qPickRevision, 'codigo', 'Código', 13);
  AjustarCampo(qPickRevision, 'descripcion', 'Descripción', 28);
  AjustarCampoNumero(qPickRevision, 'preparar', 'Preparar', 9, '#,##0');
  AjustarCampoMoneda(qPickRevision, 'pvp', 'PVP', 9);
  AjustarCampoMoneda(qPickRevision, 'coste', 'Coste', 9);
  AjustarCampo(qPickRevision, 'familia', 'Fam.', 6);
  AjustarCampo(qPickRevision, 'proveedor', 'Prov.', 7);
  AjustarCampo(qPickRevision, 'revisar', 'Revisar', 30);
end;


procedure TFDashboardProductividad.CargarCalidad;
begin
  CargarCalResumen;
  CargarCalIncompletos;
  CargarCalPrecios;
  CargarCalStock;
  CargarCalDuplicados;
  CargarCalSinMovimiento;
end;

procedure TFDashboardProductividad.CargarCalResumen;
begin
  qCalResumen.Close;
  qCalResumen.SQL.Text :=
    'SELECT ''Artículos totales'' AS concepto, COUNT(*) AS cantidad, NULL AS importe FROM ' + Tabla('artitien') + ' A ' +
    'UNION ALL SELECT ''Coste 0'', COUNT(*), NULL FROM ' + Tabla('artitien') + ' A WHERE COALESCE(A.A24,0)=0 ' +
    'UNION ALL SELECT ''PVP 999'', COUNT(*), NULL FROM ' + Tabla('artitien') + ' A WHERE COALESCE(A.A2,0)=999 ' +
    'UNION ALL SELECT ''Familia 0'', COUNT(*), NULL FROM ' + Tabla('artitien') + ' A WHERE COALESCE(A.A14,0)=0 ' +
    'UNION ALL SELECT ''Proveedor 0'', COUNT(*), NULL FROM ' + Tabla('artitien') + ' A WHERE COALESCE(A.A32,0)=0 ' +
    'UNION ALL SELECT ''Familia inexistente'', COUNT(*), NULL FROM ' + Tabla('artitien') + ' A LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 WHERE COALESCE(A.A14,0)<>0 AND F.F0 IS NULL ' +
    'UNION ALL SELECT ''Proveedor inexistente'', COUNT(*), NULL FROM ' + Tabla('artitien') + ' A LEFT JOIN `proveedores` P ON P.P0=A.A32 WHERE COALESCE(A.A32,0)<>0 AND P.P0 IS NULL ' +
    'UNION ALL SELECT ''Stock bajo'', COUNT(*), NULL FROM ' + Tabla('artitien') + ' A WHERE COALESCE(A.A5,0)>0 AND COALESCE(A.A4,0)<=COALESCE(A.A5,0) ' +
    'UNION ALL SELECT ''Stock negativo'', COUNT(*), NULL FROM ' + Tabla('artitien') + ' A WHERE COALESCE(A.A4,0)<0 ' +
    'UNION ALL SELECT ''Margen negativo estimado'', COUNT(*), NULL FROM ' + Tabla('artitien') + ' A WHERE COALESCE(A.A21,0)>0 AND COALESCE(A.A24,0)>COALESCE(A.A21,0) ' +
    'UNION ALL SELECT ''Stock sin movimiento +365d'', COUNT(*), ROUND(SUM(COALESCE(A.A4,0)*COALESCE(A.A24,0)),2) FROM ' + Tabla('artitien') + ' A WHERE COALESCE(A.A4,0)>0 AND (A.A12 IS NULL OR A.A12 < DATE_SUB(CURDATE(), INTERVAL 365 DAY))';
  qCalResumen.Open;

  AjustarCampo(qCalResumen, 'concepto', 'Concepto', 28);
  AjustarCampo(qCalResumen, 'cantidad', 'Cantidad', 10);
  AjustarCampoMoneda(qCalResumen, 'importe', 'Importe orient.', 13);
end;

procedure TFDashboardProductividad.CargarCalIncompletos;
begin
  qCalIncompletos.Close;
  qCalIncompletos.SQL.Text :=
    'SELECT A.A0 AS codigo, A.A1 AS descripcion, COALESCE(A.A14,0) AS familia, COALESCE(F.F1,''Sin familia'') AS nombre_familia, ' +
    '       COALESCE(A.A32,0) AS proveedor, COALESCE(P.P1,''Sin proveedor'') AS nombre_proveedor, ' +
    '       CONCAT_WS('', '', ' +
    '         IF(COALESCE(A.A14,0)=0,''Familia 0'',NULL), ' +
    '         IF(COALESCE(A.A14,0)<>0 AND F.F0 IS NULL,''Familia inexistente'',NULL), ' +
    '         IF(COALESCE(A.A32,0)=0,''Proveedor 0'',NULL), ' +
    '         IF(COALESCE(A.A32,0)<>0 AND P.P0 IS NULL,''Proveedor inexistente'',NULL), ' +
    '         IF(TRIM(COALESCE(A.A1,''''))='''',''Sin descripción'',NULL) ' +
    '       ) AS revisar ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
    'WHERE COALESCE(A.A14,0)=0 OR F.F0 IS NULL OR COALESCE(A.A32,0)=0 OR P.P0 IS NULL OR TRIM(COALESCE(A.A1,''''))='''' ' +
    'ORDER BY A.A1 ' +
    'LIMIT 250';
  qCalIncompletos.Open;

  AjustarCampo(qCalIncompletos, 'codigo', 'Código', 13);
  AjustarCampo(qCalIncompletos, 'descripcion', 'Descripción', 28);
  AjustarCampo(qCalIncompletos, 'familia', 'Fam.', 6);
  AjustarCampo(qCalIncompletos, 'nombre_familia', 'Familia', 20);
  AjustarCampo(qCalIncompletos, 'proveedor', 'Prov.', 7);
  AjustarCampo(qCalIncompletos, 'nombre_proveedor', 'Proveedor', 24);
  AjustarCampo(qCalIncompletos, 'revisar', 'Revisar', 32);
end;

procedure TFDashboardProductividad.CargarCalPrecios;
begin
  qCalPrecios.Close;
  qCalPrecios.SQL.Text :=
    'SELECT A.A0 AS codigo, A.A1 AS descripcion, ROUND(COALESCE(A.A2,0),2) AS pvp, ROUND(COALESCE(A.A21,0),3) AS precio_sin_iva, ' +
    '       ROUND(COALESCE(A.A24,0),3) AS coste, ' +
    '       CASE WHEN COALESCE(A.A21,0)>0 THEN ROUND(((COALESCE(A.A21,0)-COALESCE(A.A24,0))/COALESCE(A.A21,0))*100,2) ELSE NULL END AS margen_pct, ' +
    '       CONCAT_WS('', '', ' +
    '         IF(COALESCE(A.A2,0)=999,''PVP 999'',NULL), ' +
    '         IF(COALESCE(A.A2,0)<=0,''PVP <= 0'',NULL), ' +
    '         IF(COALESCE(A.A21,0)<=0,''Sin precio s/IVA'',NULL), ' +
    '         IF(COALESCE(A.A24,0)=0,''Coste 0'',NULL), ' +
    '         IF(COALESCE(A.A21,0)>0 AND COALESCE(A.A24,0)>COALESCE(A.A21,0),''Coste > precio s/IVA'',NULL) ' +
    '       ) AS problema ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'WHERE COALESCE(A.A2,0)=999 OR COALESCE(A.A2,0)<=0 OR COALESCE(A.A21,0)<=0 OR COALESCE(A.A24,0)=0 OR (COALESCE(A.A21,0)>0 AND COALESCE(A.A24,0)>COALESCE(A.A21,0)) ' +
    'ORDER BY A.A1 ' +
    'LIMIT 250';
  qCalPrecios.Open;

  AjustarCampo(qCalPrecios, 'codigo', 'Código', 13);
  AjustarCampo(qCalPrecios, 'descripcion', 'Descripción', 26);
  AjustarCampoMoneda(qCalPrecios, 'pvp', 'PVP', 9);
  AjustarCampoMoneda(qCalPrecios, 'precio_sin_iva', 'P. s/IVA', 9);
  AjustarCampoMoneda(qCalPrecios, 'coste', 'Coste', 9);
  AjustarCampoNumero(qCalPrecios, 'margen_pct', 'Margen %', 10, '#,##0.00 %');
  AjustarCampo(qCalPrecios, 'problema', 'Problema', 34);
end;

procedure TFDashboardProductividad.CargarCalStock;
begin
  qCalStock.Close;
  qCalStock.SQL.Text :=
    'SELECT A.A0 AS codigo, A.A1 AS descripcion, ROUND(COALESCE(A.A4,0),2) AS stock, ROUND(COALESCE(A.A5,0),2) AS stock_min, ROUND(COALESCE(A.A6,0),2) AS stock_max, ' +
    '       A.A12 AS ultima_venta, A.A13 AS ultima_compra, ' +
    '       CONCAT_WS('', '', ' +
    '         IF(COALESCE(A.A4,0)<0,''Stock negativo'',NULL), ' +
    '         IF(COALESCE(A.A5,0)>0 AND COALESCE(A.A4,0)<=COALESCE(A.A5,0),''Bajo mínimo'',NULL), ' +
    '         IF(COALESCE(A.A6,0)>0 AND COALESCE(A.A4,0)>COALESCE(A.A6,0),''Sobre máximo'',NULL), ' +
    '         IF(COALESCE(A.A4,0)=0 AND COALESCE(A.A5,0)>0,''Stock 0 con mínimo'',NULL) ' +
    '       ) AS problema ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'WHERE COALESCE(A.A4,0)<0 OR (COALESCE(A.A5,0)>0 AND COALESCE(A.A4,0)<=COALESCE(A.A5,0)) OR (COALESCE(A.A6,0)>0 AND COALESCE(A.A4,0)>COALESCE(A.A6,0)) ' +
    'ORDER BY A.A1 ' +
    'LIMIT 250';
  qCalStock.Open;

  AjustarCampo(qCalStock, 'codigo', 'Código', 13);
  AjustarCampo(qCalStock, 'descripcion', 'Descripción', 28);
  AjustarCampoNumero(qCalStock, 'stock', 'Stock', 9, '#,##0.##');
  AjustarCampoNumero(qCalStock, 'stock_min', 'Mín.', 9, '#,##0.##');
  AjustarCampoNumero(qCalStock, 'stock_max', 'Máx.', 9, '#,##0.##');
  AjustarCampo(qCalStock, 'ultima_venta', 'Últ. venta', 11);
  AjustarCampo(qCalStock, 'ultima_compra', 'Últ. compra', 11);
  AjustarCampo(qCalStock, 'problema', 'Problema', 28);
end;

procedure TFDashboardProductividad.CargarCalDuplicados;
begin
  qCalDuplicados.Close;
  qCalDuplicados.SQL.Text :=
    'SELECT UPPER(TRIM(A.A1)) AS descripcion_normalizada, COUNT(*) AS articulos, ' +
    '       GROUP_CONCAT(A.A0 ORDER BY A.A0 SEPARATOR '', '') AS codigos, ' +
    '       ROUND(SUM(COALESCE(A.A4,0)),2) AS stock_total, ROUND(SUM(COALESCE(A.A4,0)*COALESCE(A.A24,0)),2) AS coste_stock ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'WHERE TRIM(COALESCE(A.A1,''''))<>'''' ' +
    'GROUP BY UPPER(TRIM(A.A1)) ' +
    'HAVING COUNT(*) > 1 ' +
    'ORDER BY articulos DESC, descripcion_normalizada ' +
    'LIMIT 150';
  qCalDuplicados.Open;

  AjustarCampo(qCalDuplicados, 'descripcion_normalizada', 'Descripción', 34);
  AjustarCampo(qCalDuplicados, 'articulos', 'Arts.', 7);
  AjustarCampo(qCalDuplicados, 'codigos', 'Códigos', 35);
  AjustarCampoNumero(qCalDuplicados, 'stock_total', 'Stock', 9, '#,##0.##');
  AjustarCampoMoneda(qCalDuplicados, 'coste_stock', 'Coste stock', 11);
end;

procedure TFDashboardProductividad.CargarCalSinMovimiento;
begin
  qCalSinMovimiento.Close;
  qCalSinMovimiento.SQL.Text :=
    'SELECT A.A0 AS codigo, A.A1 AS descripcion, ROUND(COALESCE(A.A4,0),2) AS stock, ROUND(COALESCE(A.A24,0),3) AS coste, ' +
    '       ROUND(COALESCE(A.A4,0)*COALESCE(A.A24,0),2) AS coste_stock, A.A12 AS ultima_venta, A.A13 AS ultima_compra, ' +
    '       COALESCE(F.F1,''Sin familia'') AS familia, COALESCE(P.P1,''Sin proveedor'') AS proveedor ' +
    'FROM ' + Tabla('artitien') + ' A ' +
    'LEFT JOIN ' + Tabla('familias') + ' F ON F.F0=A.A14 ' +
    'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
    'WHERE COALESCE(A.A4,0)>0 AND (A.A12 IS NULL OR A.A12 < DATE_SUB(CURDATE(), INTERVAL 365 DAY)) ' +
    'ORDER BY coste_stock DESC, A.A12, A.A1 ' +
    'LIMIT 250';
  qCalSinMovimiento.Open;

  AjustarCampo(qCalSinMovimiento, 'codigo', 'Código', 13);
  AjustarCampo(qCalSinMovimiento, 'descripcion', 'Descripción', 28);
  AjustarCampoNumero(qCalSinMovimiento, 'stock', 'Stock', 9, '#,##0.##');
  AjustarCampoMoneda(qCalSinMovimiento, 'coste', 'Coste', 9);
  AjustarCampoMoneda(qCalSinMovimiento, 'coste_stock', 'Coste stock', 12);
  AjustarCampo(qCalSinMovimiento, 'ultima_venta', 'Últ. venta', 11);
  AjustarCampo(qCalSinMovimiento, 'ultima_compra', 'Últ. compra', 11);
  AjustarCampo(qCalSinMovimiento, 'familia', 'Familia', 18);
  AjustarCampo(qCalSinMovimiento, 'proveedor', 'Proveedor', 22);
end;


procedure TFDashboardProductividad.CargarVeriFactu;
begin
  if not TablaExiste('verifactu_queue') then
  begin
    CargarVFNoDisponible;
    Exit;
  end;

  CargarVFResumen;
  CargarVFPendientes;
  CargarVFAceptadosErrores;
  CargarVFErrores;
  CargarVFSeries;
  CargarVFUltimos;
end;

procedure TFDashboardProductividad.CargarVFNoDisponible;
const
  SQLAviso = 'SELECT ''No existe la tabla verifactu_queue en esta base de datos.'' AS aviso';
begin
  qVFResumen.Close;
  qVFResumen.SQL.Text := SQLAviso;
  qVFResumen.Open;

  qVFPendientes.Close;
  qVFPendientes.SQL.Text := SQLAviso;
  qVFPendientes.Open;

  qVFAceptadosErrores.Close;
  qVFAceptadosErrores.SQL.Text := SQLAviso;
  qVFAceptadosErrores.Open;

  qVFErrores.Close;
  qVFErrores.SQL.Text := SQLAviso;
  qVFErrores.Open;

  qVFSeries.Close;
  qVFSeries.SQL.Text := SQLAviso;
  qVFSeries.Open;

  qVFUltimos.Close;
  qVFUltimos.SQL.Text := SQLAviso;
  qVFUltimos.Open;
end;

procedure TFDashboardProductividad.CargarVFResumen;
begin
  qVFResumen.Close;
  qVFResumen.SQL.Text :=
    'SELECT ''Total registros rango'' AS concepto, COUNT(*) AS cantidad, ROUND(COALESCE(SUM(total_con_iva),0),2) AS importe FROM `verifactu_queue` WHERE fecha BETWEEN :desde1 AND :hasta1 ' +
    'UNION ALL SELECT ''Pendientes / cola'', COUNT(*), ROUND(COALESCE(SUM(total_con_iva),0),2) FROM `verifactu_queue` WHERE fecha BETWEEN :desde2 AND :hasta2 AND (TRIM(COALESCE(estado,''''))='''' OR UPPER(COALESCE(estado,'''')) IN (''PENDIENTE'',''PENDIENTE_ENVIO'',''EN_COLA'',''COLA'',''NUEVO'',''ERROR_REINTENTO'')) ' +
    'UNION ALL SELECT ''Aceptados'', COUNT(*), ROUND(COALESCE(SUM(total_con_iva),0),2) FROM `verifactu_queue` WHERE fecha BETWEEN :desde3 AND :hasta3 AND UPPER(COALESCE(estado,'''')) LIKE ''%ACEPT%'' AND UPPER(COALESCE(estado,'''')) NOT LIKE ''%ERROR%'' ' +
    'UNION ALL SELECT ''Aceptados con errores'', COUNT(*), ROUND(COALESCE(SUM(total_con_iva),0),2) FROM `verifactu_queue` WHERE fecha BETWEEN :desde4 AND :hasta4 AND ((UPPER(COALESCE(estado,'''')) LIKE ''%ACEPT%'' AND UPPER(COALESCE(estado,'''')) LIKE ''%ERROR%'') OR UPPER(COALESCE(respuesta_text,'''')) LIKE ''%ACEPT%ERROR%'') ' +
    'UNION ALL SELECT ''Errores / revisar'', COUNT(*), ROUND(COALESCE(SUM(total_con_iva),0),2) FROM `verifactu_queue` WHERE fecha BETWEEN :desde5 AND :hasta5 AND (UPPER(COALESCE(estado,'''')) LIKE ''%ERROR%'' OR TRIM(COALESCE(last_error,''''))<>'''') AND NOT ((UPPER(COALESCE(estado,'''')) LIKE ''%ACEPT%'' AND UPPER(COALESCE(estado,'''')) LIKE ''%ERROR%'')) ' +
    'UNION ALL SELECT ''F1'', COUNT(*), ROUND(COALESCE(SUM(total_con_iva),0),2) FROM `verifactu_queue` WHERE fecha BETWEEN :desde6 AND :hasta6 AND UPPER(COALESCE(tipo_factura,''''))=''F1'' ' +
    'UNION ALL SELECT ''F2 simplificadas'', COUNT(*), ROUND(COALESCE(SUM(total_con_iva),0),2) FROM `verifactu_queue` WHERE fecha BETWEEN :desde7 AND :hasta7 AND UPPER(COALESCE(tipo_factura,''''))=''F2''';
  qVFResumen.ParamByName('desde1').AsDateTime := FechaDesde;
  qVFResumen.ParamByName('hasta1').AsDateTime := FechaHasta;
  qVFResumen.ParamByName('desde2').AsDateTime := FechaDesde;
  qVFResumen.ParamByName('hasta2').AsDateTime := FechaHasta;
  qVFResumen.ParamByName('desde3').AsDateTime := FechaDesde;
  qVFResumen.ParamByName('hasta3').AsDateTime := FechaHasta;
  qVFResumen.ParamByName('desde4').AsDateTime := FechaDesde;
  qVFResumen.ParamByName('hasta4').AsDateTime := FechaHasta;
  qVFResumen.ParamByName('desde5').AsDateTime := FechaDesde;
  qVFResumen.ParamByName('hasta5').AsDateTime := FechaHasta;
  qVFResumen.ParamByName('desde6').AsDateTime := FechaDesde;
  qVFResumen.ParamByName('hasta6').AsDateTime := FechaHasta;
  qVFResumen.ParamByName('desde7').AsDateTime := FechaDesde;
  qVFResumen.ParamByName('hasta7').AsDateTime := FechaHasta;
  qVFResumen.Open;

  AjustarCampo(qVFResumen, 'concepto', 'Concepto', 26);
  AjustarCampo(qVFResumen, 'cantidad', 'Cantidad', 10);
  AjustarCampoMoneda(qVFResumen, 'importe', 'Importe', 13);
end;

procedure TFDashboardProductividad.CargarVFPendientes;
begin
  qVFPendientes.Close;
  qVFPendientes.SQL.Text :=
    'SELECT fecha, hora, serie, numero, COALESCE(tipo_factura,'''') AS tipo, ROUND(COALESCE(total_con_iva,0),2) AS total, COALESCE(estado,'''') AS estado ' +
    'FROM `verifactu_queue` ' +
    'WHERE fecha BETWEEN :desde AND :hasta ' +
    '  AND (TRIM(COALESCE(estado,''''))='''' OR UPPER(COALESCE(estado,'''')) IN (''PENDIENTE'',''PENDIENTE_ENVIO'',''EN_COLA'',''COLA'',''NUEVO'',''ERROR_REINTENTO'')) ' +
    'ORDER BY fecha, hora, serie, numero ' +
    'LIMIT 200';
  qVFPendientes.ParamByName('desde').AsDateTime := FechaDesde;
  qVFPendientes.ParamByName('hasta').AsDateTime := FechaHasta;
  qVFPendientes.Open;

  AjustarCampo(qVFPendientes, 'fecha', 'Fecha', 11);
  AjustarCampo(qVFPendientes, 'hora', 'Hora', 9);
  AjustarCampo(qVFPendientes, 'serie', 'Serie', 7);
  AjustarCampo(qVFPendientes, 'numero', 'Número', 8);
  AjustarCampo(qVFPendientes, 'tipo', 'Tipo', 5);
  AjustarCampoMoneda(qVFPendientes, 'total', 'Total', 10);
  AjustarCampo(qVFPendientes, 'estado', 'Estado', 18);
end;

procedure TFDashboardProductividad.CargarVFAceptadosErrores;
begin
  qVFAceptadosErrores.Close;
  qVFAceptadosErrores.SQL.Text :=
    'SELECT fecha, hora, serie, numero, COALESCE(tipo_factura,'''') AS tipo, ROUND(COALESCE(total_con_iva,0),2) AS total, COALESCE(estado,'''') AS estado, LEFT(COALESCE(respuesta_text,''''),120) AS respuesta ' +
    'FROM `verifactu_queue` ' +
    'WHERE fecha BETWEEN :desde AND :hasta ' +
    '  AND ((UPPER(COALESCE(estado,'''')) LIKE ''%ACEPT%'' AND UPPER(COALESCE(estado,'''')) LIKE ''%ERROR%'') OR UPPER(COALESCE(respuesta_text,'''')) LIKE ''%ACEPT%ERROR%'') ' +
    'ORDER BY fecha DESC, hora DESC, serie, numero ' +
    'LIMIT 200';
  qVFAceptadosErrores.ParamByName('desde').AsDateTime := FechaDesde;
  qVFAceptadosErrores.ParamByName('hasta').AsDateTime := FechaHasta;
  qVFAceptadosErrores.Open;

  AjustarCampo(qVFAceptadosErrores, 'fecha', 'Fecha', 11);
  AjustarCampo(qVFAceptadosErrores, 'hora', 'Hora', 9);
  AjustarCampo(qVFAceptadosErrores, 'serie', 'Serie', 7);
  AjustarCampo(qVFAceptadosErrores, 'numero', 'Número', 8);
  AjustarCampo(qVFAceptadosErrores, 'tipo', 'Tipo', 5);
  AjustarCampoMoneda(qVFAceptadosErrores, 'total', 'Total', 10);
  AjustarCampo(qVFAceptadosErrores, 'estado', 'Estado', 18);
  AjustarCampo(qVFAceptadosErrores, 'respuesta', 'Respuesta', 45);
end;

procedure TFDashboardProductividad.CargarVFErrores;
begin
  qVFErrores.Close;
  qVFErrores.SQL.Text :=
    'SELECT fecha, hora, serie, numero, COALESCE(tipo_factura,'''') AS tipo, COALESCE(estado,'''') AS estado, LEFT(COALESCE(last_error, respuesta_text, ''''),160) AS error ' +
    'FROM `verifactu_queue` ' +
    'WHERE fecha BETWEEN :desde AND :hasta ' +
    '  AND (UPPER(COALESCE(estado,'''')) LIKE ''%ERROR%'' OR TRIM(COALESCE(last_error,''''))<>'''') ' +
    '  AND NOT ((UPPER(COALESCE(estado,'''')) LIKE ''%ACEPT%'' AND UPPER(COALESCE(estado,'''')) LIKE ''%ERROR%'')) ' +
    'ORDER BY fecha DESC, hora DESC, serie, numero ' +
    'LIMIT 200';
  qVFErrores.ParamByName('desde').AsDateTime := FechaDesde;
  qVFErrores.ParamByName('hasta').AsDateTime := FechaHasta;
  qVFErrores.Open;

  AjustarCampo(qVFErrores, 'fecha', 'Fecha', 11);
  AjustarCampo(qVFErrores, 'hora', 'Hora', 9);
  AjustarCampo(qVFErrores, 'serie', 'Serie', 7);
  AjustarCampo(qVFErrores, 'numero', 'Número', 8);
  AjustarCampo(qVFErrores, 'tipo', 'Tipo', 5);
  AjustarCampo(qVFErrores, 'estado', 'Estado', 18);
  AjustarCampo(qVFErrores, 'error', 'Error / motivo', 55);
end;

procedure TFDashboardProductividad.CargarVFSeries;
begin
  qVFSeries.Close;
  qVFSeries.SQL.Text :=
    'SELECT COALESCE(serie,'''') AS serie, COALESCE(tipo_factura,'''') AS tipo, COUNT(*) AS registros, ' +
    '       SUM(CASE WHEN TRIM(COALESCE(estado,''''))='''' OR UPPER(COALESCE(estado,'''')) IN (''PENDIENTE'',''PENDIENTE_ENVIO'',''EN_COLA'',''COLA'',''NUEVO'',''ERROR_REINTENTO'') THEN 1 ELSE 0 END) AS pendientes, ' +
    '       SUM(CASE WHEN UPPER(COALESCE(estado,'''')) LIKE ''%ERROR%'' OR TRIM(COALESCE(last_error,''''))<>'''' THEN 1 ELSE 0 END) AS con_error, ' +
    '       SUM(CASE WHEN TRIM(COALESCE(hash,''''))='''' THEN 1 ELSE 0 END) AS sin_hash, ' +
    '       SUM(CASE WHEN TRIM(COALESCE(hash_prev,''''))='''' THEN 1 ELSE 0 END) AS sin_hash_prev, ' +
    '       ROUND(COALESCE(SUM(total_con_iva),0),2) AS importe ' +
    'FROM `verifactu_queue` ' +
    'WHERE fecha BETWEEN :desde AND :hasta ' +
    'GROUP BY COALESCE(serie,''''), COALESCE(tipo_factura,'''') ' +
    'ORDER BY serie, tipo';
  qVFSeries.ParamByName('desde').AsDateTime := FechaDesde;
  qVFSeries.ParamByName('hasta').AsDateTime := FechaHasta;
  qVFSeries.Open;

  AjustarCampo(qVFSeries, 'serie', 'Serie', 7);
  AjustarCampo(qVFSeries, 'tipo', 'Tipo', 5);
  AjustarCampo(qVFSeries, 'registros', 'Regs.', 7);
  AjustarCampo(qVFSeries, 'pendientes', 'Pend.', 7);
  AjustarCampo(qVFSeries, 'con_error', 'Error', 7);
  AjustarCampo(qVFSeries, 'sin_hash', 'Sin hash', 8);
  AjustarCampo(qVFSeries, 'sin_hash_prev', 'Sin prev', 8);
  AjustarCampoMoneda(qVFSeries, 'importe', 'Importe', 10);
end;

procedure TFDashboardProductividad.CargarVFUltimos;
begin
  qVFUltimos.Close;
  qVFUltimos.SQL.Text :=
    'SELECT fecha, hora, serie, numero, COALESCE(tipo_factura,'''') AS tipo, ROUND(COALESCE(total_con_iva,0),2) AS total, COALESCE(estado,'''') AS estado, LEFT(COALESCE(last_error, respuesta_text, ''''),120) AS resultado ' +
    'FROM `verifactu_queue` ' +
    'WHERE fecha BETWEEN :desde AND :hasta ' +
    'ORDER BY fecha DESC, hora DESC, serie DESC, numero DESC ' +
    'LIMIT 250';
  qVFUltimos.ParamByName('desde').AsDateTime := FechaDesde;
  qVFUltimos.ParamByName('hasta').AsDateTime := FechaHasta;
  qVFUltimos.Open;

  AjustarCampo(qVFUltimos, 'fecha', 'Fecha', 11);
  AjustarCampo(qVFUltimos, 'hora', 'Hora', 9);
  AjustarCampo(qVFUltimos, 'serie', 'Serie', 7);
  AjustarCampo(qVFUltimos, 'numero', 'Número', 8);
  AjustarCampo(qVFUltimos, 'tipo', 'Tipo', 5);
  AjustarCampoMoneda(qVFUltimos, 'total', 'Total', 10);
  AjustarCampo(qVFUltimos, 'estado', 'Estado', 18);
  AjustarCampo(qVFUltimos, 'resultado', 'Resultado / error', 45);
end;

procedure TFDashboardProductividad.CargarAlerta(AAlerta: TDashboardAlerta);
begin
  qAlertas.Close;

  case AAlerta of
    daStockBajo:
      begin
        lblAlertaTitulo.Caption := 'Artículos con stock bajo';
        qAlertas.SQL.Text :=
          'SELECT A.A0 AS codigo, A.A1 AS descripcion, A.A4 AS stock_actual, ' +
          '       A.A5 AS stock_minimo, A.A14 AS familia, ' +
          '       A.A32 AS proveedor, P.P1 AS nombre_proveedor ' +
          'FROM ' + Tabla('artitien') + ' A ' +
          'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
          'WHERE COALESCE(A.A5,0) > 0 ' +
          '  AND COALESCE(A.A4,0) <= COALESCE(A.A5,0) ' +
          'ORDER BY A.A1';
      end;

    daCosteCero:
      begin
        lblAlertaTitulo.Caption := 'Artículos con coste 0';
        qAlertas.SQL.Text :=
          'SELECT A.A0 AS codigo, A.A1 AS descripcion, A.A2 AS pvp, ' +
          '       A.A24 AS coste, A.A14 AS familia, A.A32 AS proveedor, P.P1 AS nombre_proveedor ' +
          'FROM ' + Tabla('artitien') + ' A ' +
          'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
          'WHERE COALESCE(A.A24,0) = 0 ' +
          'ORDER BY A.A1';
      end;

    daPVP999:
      begin
        lblAlertaTitulo.Caption := 'Artículos con PVP 999';
        qAlertas.SQL.Text :=
          'SELECT A.A0 AS codigo, A.A1 AS descripcion, A.A2 AS pvp, ' +
          '       A.A24 AS coste, A.A14 AS familia, A.A32 AS proveedor, P.P1 AS nombre_proveedor ' +
          'FROM ' + Tabla('artitien') + ' A ' +
          'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
          'WHERE COALESCE(A.A2,0) = 999 ' +
          'ORDER BY A.A1';
      end;

    daFamiliaCero:
      begin
        lblAlertaTitulo.Caption := 'Artículos con familia 0 / sin familia';
        qAlertas.SQL.Text :=
          'SELECT A.A0 AS codigo, A.A1 AS descripcion, A.A14 AS familia, ' +
          '       A.A2 AS pvp, A.A24 AS coste, A.A32 AS proveedor, P.P1 AS nombre_proveedor ' +
          'FROM ' + Tabla('artitien') + ' A ' +
          'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
          'WHERE COALESCE(A.A14,0) = 0 ' +
          'ORDER BY A.A1';
      end;

    daSinProveedor:
      begin
        lblAlertaTitulo.Caption := 'Artículos sin proveedor válido';
        qAlertas.SQL.Text :=
          'SELECT A.A0 AS codigo, A.A1 AS descripcion, A.A32 AS proveedor, ' +
          '       A.A14 AS familia, A.A2 AS pvp, A.A24 AS coste ' +
          'FROM ' + Tabla('artitien') + ' A ' +
          'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
          'WHERE COALESCE(A.A32,0) = 0 OR P.P0 IS NULL ' +
          'ORDER BY A.A1';
      end;

    daStockCeroVendido30:
      begin
        lblAlertaTitulo.Caption := 'Artículos con stock 0 vendidos en los últimos 30 días';
        qAlertas.SQL.Text :=
          'SELECT A.A0 AS codigo, A.A1 AS descripcion, A.A4 AS stock_actual, ' +
          '       COALESCE(SUM(D.HOD8),0) AS unidades_vendidas, MAX(D.HOD0) AS ultima_venta, ' +
          '       A.A14 AS familia, A.A32 AS proveedor, P.P1 AS nombre_proveedor ' +
          'FROM ' + Tabla('artitien') + ' A ' +
          'JOIN ' + Tabla('hisopdd') + ' D ON D.HOD6=A.A0 ' +
          'JOIN ' + Tabla('hisopcc') + ' C ' +
          '  ON C.HO0=D.HOD0 AND C.HO1=D.HOD1 AND C.HO2=D.HOD2 ' +
          ' AND C.HO3=D.HOD3 AND C.HO4=D.HOD4 ' +
          'LEFT JOIN `proveedores` P ON P.P0=A.A32 ' +
          'WHERE COALESCE(A.A4,0) <= 0 ' +
          '  AND D.HOD0 >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) ' +
          '  AND C.HO5 IN (''NS'',''NT'',''FA'') ' +
          '  AND COALESCE(C.HO16, '''') <> ''A'' ' +
          'GROUP BY A.A0, A.A1, A.A4, A.A14, A.A32, P.P1 ' +
          'ORDER BY ultima_venta DESC';
      end;
  end;

  qAlertas.Open;
  AplicarFormatoYAnchos;
  pcPrincipal.ActivePage := tsAlertas;
end;

procedure TFDashboardProductividad.AlertaStockBajo(Sender: TObject);
begin
  CargarAlerta(daStockBajo);
end;

procedure TFDashboardProductividad.AlertaCosteCero(Sender: TObject);
begin
  CargarAlerta(daCosteCero);
end;

procedure TFDashboardProductividad.AlertaPVP999(Sender: TObject);
begin
  CargarAlerta(daPVP999);
end;

procedure TFDashboardProductividad.AlertaFamiliaCero(Sender: TObject);
begin
  CargarAlerta(daFamiliaCero);
end;

procedure TFDashboardProductividad.AlertaSinProveedor(Sender: TObject);
begin
  CargarAlerta(daSinProveedor);
end;

procedure TFDashboardProductividad.AlertaStockCeroVendido30(Sender: TObject);
begin
  CargarAlerta(daStockCeroVendido30);
end;

end.
