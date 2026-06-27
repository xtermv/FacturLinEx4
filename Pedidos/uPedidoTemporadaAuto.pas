unit uPedidoTemporadaAuto;

{$mode objfpc}{$H+}
{$codepage utf8}

{
  FacturLinEx - Pedido automatico de temporada
  Version: 2026-06-27-v1.7.1-MULTITEMPORADA-MODOS-COMPARATIVA-FIX-BOTON

  OBJETIVO
  --------
  Unidad independiente para preparar pedidos de temporada sin tocar el modulo
  estable de pedido automatico normal por proveedor.

  Esta primera version NO crea pedido real. Solo:
    - detecta candidatos por palabras clave, marcas/alias, articulos guardados de temporada
      y opcionalmente todos los articulos comprados alguna vez al proveedor;
    - calcula sugerido por ventas de la misma temporada del ano base;
    - mezcla tendencia reciente si ya empezo la temporada;
    - permite guardar articulos visibles y codigos manuales como articulos de temporada;
    - exporta CSV, genera PDF simple e imprime;
    - registra log diario.

  Integracion futura:
    uses uPedidoTemporadaAuto;
    MostrarPedidoTemporadaAuto(Self, TuConexionZConnection, Tienda);
}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Grids, Spin, DateUtils, Math, DB, Types, Printers, LCLIntf,
  LazUTF8, Process, ZConnection, ZDataset;

type
  TLineaTemporada = record
    Codigo: string;
    Descripcion: string;
    VentasBase: Double;
    VentasActual: Double;
    VentaDia: Double;
    Sugerido: Double;
    CantidadFinal: Double;
    UltVentaBase: string;
    UltVentaActual: string;
    UltCompra: string;
    Coste: Double;
    PVP: Double;
    IVA: Double;
    Familia: string;
    Estado: string;
    Confianza: string;
    Observaciones: string;
    Prioridad: Double;
    MarcadoTemporada: Boolean;
  end;

  TArrayLineaTemporada = array of TLineaTemporada;

  { TfPedidoTemporadaAuto }

  TfPedidoTemporadaAuto = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;
    FListaProveedores: TStringList;
    FLineasTodas: TArrayLineaTemporada;
    FLineasAuto: TArrayLineaTemporada;
    FLineasDudas: TArrayLineaTemporada;
    FLineasExcluidas: TArrayLineaTemporada;
    FSortCol: Integer;
    FSortAsc: Boolean;

    PanelTop: TPanel;
    PanelBottom: TPanel;
    Grid: TStringGrid;
    Progress: TProgressBar;
    lblEstado: TLabel;

    lblBuscarProveedor: TLabel;
    edtBuscarProveedor: TEdit;
    btnLimpiarProveedor: TButton;
    lblProveedor: TLabel;
    cbProveedor: TComboBox;
    btnCerrar: TButton;

    lblTemporada: TLabel;
    cbTemporada: TComboBox;
    lblModo: TLabel;
    cbModo: TComboBox;
    lblDesdeBase: TLabel;
    edtDesdeBase: TEdit;
    lblHastaBase: TLabel;
    edtHastaBase: TEdit;
    lblDiasCubrir: TLabel;
    seDiasCubrir: TSpinEdit;
    lblDiasActual: TLabel;
    seDiasActual: TSpinEdit;
    lblFactor: TLabel;
    edtFactor: TEdit;
    lblMaxLineas: TLabel;
    seMaxLineas: TSpinEdit;
    chkUsarActual: TCheckBox;
    chkProveedorTemporada: TCheckBox;
    chkAbrirPDF: TCheckBox;

    lblKeywords: TLabel;
    memoKeywords: TMemo;

    btnDetectar: TButton;
    btnCalcular: TButton;
    btnVerAuto: TButton;
    btnVerCompra: TButton;
    btnVerDudas: TButton;
    btnVerExcluidos: TButton;
    btnAceptarLinea: TButton;
    btnRevisarLinea: TButton;
    btnExcluirLinea: TButton;
    btnGuardarTemporada: TButton;
    btnCSV: TButton;
    btnPDF: TButton;
    btnImprimir: TButton;
    btnOrdenTienda: TButton;
    btnGuardarKeywords: TButton;
    btnGuardarBorrador: TButton;
    btnCargarBorrador: TButton;
    btnBorrarBorrador: TButton;
    btnCompararTempAnt: TButton;
    lblCodigoManual: TLabel;
    edtCodigoManual: TEdit;
    btnIncluirManual: TButton;
    btnQuitarManual: TButton;
    btnVerGuardados: TButton;

    procedure ConstruirInterfaz;
    procedure InicializarGrid;
    procedure CargarProveedores;
    procedure FiltrarProveedores(const Texto: string);
    procedure CrearTablasTemporada;
    procedure CargarKeywordsTemporada;
    procedure GuardarKeywordsTemporada;
    procedure InicializarTemporadasBase;
    procedure InicializarModosTemporada;
    function ModoTemporadaSeleccionado: string;
    procedure AplicarDefaultsTemporada(const ATemporada: string);
    function KeywordsPorDefecto(const ATemporada: string): string;
    function MesDiaFechaBase(const Anio: Integer; const Mes, Dia: Word): string;
    function KeywordsComoTexto: string;
    procedure SincronizarGridAFLineasTodas;
    procedure GuardarBorradorCompleto;
    procedure CargarUltimoBorrador;
    procedure BorrarUltimoBorrador;
    procedure ProgresoInicio(const AMsg: string; const AMax: Integer = 100);
    procedure ProgresoPaso(const AMsg: string; const APos: Integer = -1; const AMax: Integer = -1);
    procedure ProgresoFin(const AMsg: string);
    procedure Log(const S: string);

    function CodigoProveedorSeleccionado: Integer;
    function NombreProveedorSeleccionado: string;
    function SufijoTiendaSeguro(const S: string): string;
    function TablaExiste(const NombreTabla: string): Boolean;
    function FechaSQL(const Fecha: TDateTime): string;
    function ParseFechaISO(const S: string; out D: TDateTime): Boolean;
    function FloatSeguro(const S: string; const Def: Double): Double;
    function CSVSeguro(const S: string): string;
    function TextoPDFSeguro(const S: string): AnsiString;
    function EscPDF(const S: AnsiString): AnsiString;
    function PDFNum(const V: Double): string;
    function HayDatosEnGrid: Boolean;
    function KeywordsSQL: string;
    function SQLComprasProveedor(const CodProveedor: Integer): string;
    function SQLVentasEntre(const FechaDesde, FechaHasta: TDateTime; const AliasVentas: string): string;
    function SQLTemporada(const CodProveedor: Integer; const FechaDesdeBase, FechaHastaBase,
      FechaDesdeActual, FechaHastaActual: TDateTime): string;

    procedure VaciarLineas;
    procedure AddLinea(var ALista: TArrayLineaTemporada; const L: TLineaTemporada);
    procedure OrdenarPorPrioridad(var ALista: TArrayLineaTemporada);
    procedure PintarLineas(const ALista: TArrayLineaTemporada; const Limite: Integer; const Titulo: string);
    procedure SepararLineas;
    procedure CalcularTemporada;
    procedure GuardarArticulosTemporadaVisibles;
    procedure IncluirCodigoTemporada(const ACodigo, AObs: string);
    procedure GuardarCodigoTemporadaSilencioso(const ACodigo, AObs: string);
    procedure QuitarCodigoTemporada(const ACodigo: string);
    function CodigoGridSeleccionado: string;
    procedure MarcarLineaSeleccionada(const NuevaConfianza, NuevoEstado, ObsExtra: string);
    procedure VerArticulosTemporadaGuardados;
    procedure OrdenarGridPorColumna(const Col: Integer; const Ascendente: Boolean);
    function CompararCeldas(const A, B: string; const Col: Integer): Integer;
    function EsColumnaNumerica(const Col: Integer): Boolean;
    procedure GenerarPDFDesdeGrid(const NombreFichero: string);
    function AbrirFichero(const NombreFichero: string): Boolean;
    procedure ImprimirGrid;
    procedure AutoAjustarColumnas;

    procedure BtnCerrarClick(Sender: TObject);
    procedure BtnLimpiarProveedorClick(Sender: TObject);
    procedure EdtBuscarProveedorChange(Sender: TObject);
    procedure BtnDetectarClick(Sender: TObject);
    procedure BtnCalcularClick(Sender: TObject);
    procedure BtnVerAutoClick(Sender: TObject);
    procedure BtnVerCompraClick(Sender: TObject);
    procedure BtnVerDudasClick(Sender: TObject);
    procedure BtnVerExcluidosClick(Sender: TObject);
    procedure BtnAceptarLineaClick(Sender: TObject);
    procedure BtnRevisarLineaClick(Sender: TObject);
    procedure BtnExcluirLineaClick(Sender: TObject);
    procedure BtnGuardarTemporadaClick(Sender: TObject);
    procedure BtnIncluirManualClick(Sender: TObject);
    procedure BtnQuitarManualClick(Sender: TObject);
    procedure BtnVerGuardadosClick(Sender: TObject);
    procedure BtnCSVClick(Sender: TObject);
    procedure BtnPDFClick(Sender: TObject);
    procedure BtnImprimirClick(Sender: TObject);
    procedure BtnOrdenTiendaClick(Sender: TObject);
    procedure BtnGuardarKeywordsClick(Sender: TObject);
    procedure BtnGuardarBorradorClick(Sender: TObject);
    procedure BtnCargarBorradorClick(Sender: TObject);
    procedure BtnBorrarBorradorClick(Sender: TObject);
    procedure BtnCompararTempAntClick(Sender: TObject);
    procedure CbTemporadaChange(Sender: TObject);
    procedure GridHeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer);
  public
    constructor CreateAuto(AOwner: TComponent; AConn: TZConnection; const ATienda: string);
    destructor Destroy; override;
  end;

procedure MostrarPedidoTemporadaAuto(AOwner: TComponent; AConn: TZConnection;
  const Tienda: string);

implementation

procedure LogPedidoTemporada(const Msg: string);
var
  DirLog: string;
  NomLog: string;
  F: TextFile;
begin
  try
    DirLog := GetEnvironmentVariable('HOME') + '/.local/share/facturlinex/logs';
    if DirLog = '/.local/share/facturlinex/logs' then
      DirLog := GetTempDir(False);
    ForceDirectories(DirLog);
    NomLog := IncludeTrailingPathDelimiter(DirLog) +
      'pedido_temporada_' + FormatDateTime('yyyymmdd', Now) + '.log';
    AssignFile(F, NomLog);
    if FileExists(NomLog) then
      Append(F)
    else
      Rewrite(F);
    WriteLn(F, FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + ' ' + Msg);
    CloseFile(F);
  except
  end;
end;

procedure MostrarPedidoTemporadaAuto(AOwner: TComponent; AConn: TZConnection;
  const Tienda: string);
var
  F: TfPedidoTemporadaAuto;
begin
  F := TfPedidoTemporadaAuto.CreateAuto(AOwner, AConn, Tienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

{ TfPedidoTemporadaAuto }

constructor TfPedidoTemporadaAuto.CreateAuto(AOwner: TComponent;
  AConn: TZConnection; const ATienda: string);
begin
  inherited CreateNew(AOwner, 0);
  FConn := AConn;
  FTienda := SufijoTiendaSeguro(ATienda);
  FListaProveedores := TStringList.Create;
  FSortCol := -1;
  FSortAsc := True;
  Caption := 'FacturLinEx - Pedido automatico de temporada v1.8';
  Position := poScreenCenter;
  WindowState := wsMaximized;
  Width := 1200;
  Height := 760;
  ConstruirInterfaz;
  CrearTablasTemporada;
  CargarKeywordsTemporada;
  CargarProveedores;
  Log('Modulo abierto. Tienda=' + FTienda);
end;

destructor TfPedidoTemporadaAuto.Destroy;
begin
  Log('Modulo cerrado.');
  FListaProveedores.Free;
  inherited Destroy;
end;

procedure TfPedidoTemporadaAuto.Log(const S: string);
begin
  LogPedidoTemporada(S);
end;

procedure TfPedidoTemporadaAuto.ConstruirInterfaz;
var
  Y: Integer;
begin
  PanelTop := TPanel.Create(Self);
  PanelTop.Parent := Self;
  PanelTop.Align := alTop;
  PanelTop.Height := 238;
  PanelTop.BevelOuter := bvNone;

  lblBuscarProveedor := TLabel.Create(Self);
  lblBuscarProveedor.Parent := PanelTop;
  lblBuscarProveedor.Caption := 'Buscar proveedor:';
  lblBuscarProveedor.Left := 8;
  lblBuscarProveedor.Top := 12;

  edtBuscarProveedor := TEdit.Create(Self);
  edtBuscarProveedor.Parent := PanelTop;
  edtBuscarProveedor.Left := 115;
  edtBuscarProveedor.Top := 8;
  edtBuscarProveedor.Width := 180;
  edtBuscarProveedor.OnChange := @EdtBuscarProveedorChange;

  btnLimpiarProveedor := TButton.Create(Self);
  btnLimpiarProveedor.Parent := PanelTop;
  btnLimpiarProveedor.Left := 300;
  btnLimpiarProveedor.Top := 7;
  btnLimpiarProveedor.Width := 60;
  btnLimpiarProveedor.Height := 26;
  btnLimpiarProveedor.Caption := 'Todos';
  btnLimpiarProveedor.OnClick := @BtnLimpiarProveedorClick;

  lblProveedor := TLabel.Create(Self);
  lblProveedor.Parent := PanelTop;
  lblProveedor.Caption := 'Proveedor:';
  lblProveedor.Left := 370;
  lblProveedor.Top := 12;

  cbProveedor := TComboBox.Create(Self);
  cbProveedor.Parent := PanelTop;
  cbProveedor.Left := 445;
  cbProveedor.Top := 8;
  cbProveedor.Width := 450;
  cbProveedor.Style := csDropDownList;

  btnCerrar := TButton.Create(Self);
  btnCerrar.Parent := PanelTop;
  btnCerrar.Left := 930;
  btnCerrar.Top := 8;
  btnCerrar.Width := 110;
  btnCerrar.Height := 26;
  btnCerrar.Caption := 'Cerrar';
  btnCerrar.OnClick := @BtnCerrarClick;
  btnCerrar.Visible := True;
  btnCerrar.BringToFront;

  Y := 42;
  lblTemporada := TLabel.Create(Self);
  lblTemporada.Parent := PanelTop;
  lblTemporada.Caption := 'Temporada:';
  lblTemporada.Left := 8;
  lblTemporada.Top := Y + 4;

  cbTemporada := TComboBox.Create(Self);
  cbTemporada.Parent := PanelTop;
  cbTemporada.Left := 88;
  cbTemporada.Top := Y;
  cbTemporada.Width := 130;
  cbTemporada.Style := csDropDownList;
  InicializarTemporadasBase;
  cbTemporada.ItemIndex := 0;
  cbTemporada.OnChange := @CbTemporadaChange;

  lblModo := TLabel.Create(Self);
  lblModo.Parent := PanelTop;
  lblModo.Caption := 'Modo:';
  lblModo.Left := 500;
  lblModo.Top := 176;

  cbModo := TComboBox.Create(Self);
  cbModo.Parent := PanelTop;
  cbModo.Left := 548;
  cbModo.Top := 172;
  cbModo.Width := 170;
  cbModo.Style := csDropDownList;
  InicializarModosTemporada;
  cbModo.ItemIndex := 0;
  cbModo.Hint := 'Pretemporada prepara base inicial; Reposicion mezcla temporada anterior y venta actual; Final reduce cantidades y evita exceso.';
  cbModo.ShowHint := True;

  lblDesdeBase := TLabel.Create(Self);
  lblDesdeBase.Parent := PanelTop;
  lblDesdeBase.Caption := 'Desde base:';
  lblDesdeBase.Left := 230;
  lblDesdeBase.Top := Y + 4;

  edtDesdeBase := TEdit.Create(Self);
  edtDesdeBase.Parent := PanelTop;
  edtDesdeBase.Left := 310;
  edtDesdeBase.Top := Y;
  edtDesdeBase.Width := 95;
  edtDesdeBase.Text := IntToStr(YearOf(Date) - 1) + '-04-01';

  lblHastaBase := TLabel.Create(Self);
  lblHastaBase.Parent := PanelTop;
  lblHastaBase.Caption := 'Hasta base:';
  lblHastaBase.Left := 415;
  lblHastaBase.Top := Y + 4;

  edtHastaBase := TEdit.Create(Self);
  edtHastaBase.Parent := PanelTop;
  edtHastaBase.Left := 492;
  edtHastaBase.Top := Y;
  edtHastaBase.Width := 95;
  edtHastaBase.Text := IntToStr(YearOf(Date) - 1) + '-08-31';

  lblDiasCubrir := TLabel.Create(Self);
  lblDiasCubrir.Parent := PanelTop;
  lblDiasCubrir.Caption := 'Dias cubrir:';
  lblDiasCubrir.Left := 600;
  lblDiasCubrir.Top := Y + 4;

  seDiasCubrir := TSpinEdit.Create(Self);
  seDiasCubrir.Parent := PanelTop;
  seDiasCubrir.Left := 680;
  seDiasCubrir.Top := Y;
  seDiasCubrir.Width := 58;
  seDiasCubrir.MinValue := 1;
  seDiasCubrir.MaxValue := 180;
  seDiasCubrir.Value := 30;

  lblDiasActual := TLabel.Create(Self);
  lblDiasActual.Parent := PanelTop;
  lblDiasActual.Caption := 'Tend. dias:';
  lblDiasActual.Left := 750;
  lblDiasActual.Top := Y + 4;

  seDiasActual := TSpinEdit.Create(Self);
  seDiasActual.Parent := PanelTop;
  seDiasActual.Left := 825;
  seDiasActual.Top := Y;
  seDiasActual.Width := 58;
  seDiasActual.MinValue := 1;
  seDiasActual.MaxValue := 120;
  seDiasActual.Value := 30;

  chkUsarActual := TCheckBox.Create(Self);
  chkUsarActual.Parent := PanelTop;
  chkUsarActual.Left := 900;
  chkUsarActual.Top := Y + 2;
  chkUsarActual.Caption := 'Mezclar tendencia';
  chkUsarActual.Checked := True;

  chkProveedorTemporada := TCheckBox.Create(Self);
  chkProveedorTemporada.Parent := PanelTop;
  chkProveedorTemporada.Left := 1040;
  chkProveedorTemporada.Top := Y + 2;
  chkProveedorTemporada.Width := 150;
  chkProveedorTemporada.Caption := 'Prov. temporada';
  chkProveedorTemporada.Hint := 'Si esta marcado, se incluyen todos los articulos comprados alguna vez al proveedor seleccionado, aunque no coincidan palabras clave.';
  chkProveedorTemporada.ShowHint := True;
  chkProveedorTemporada.Checked := False;

  Y := 74;
  lblFactor := TLabel.Create(Self);
  lblFactor.Parent := PanelTop;
  lblFactor.Caption := 'Factor:';
  lblFactor.Left := 8;
  lblFactor.Top := Y + 4;

  edtFactor := TEdit.Create(Self);
  edtFactor.Parent := PanelTop;
  edtFactor.Left := 62;
  edtFactor.Top := Y;
  edtFactor.Width := 55;
  edtFactor.Text := '1,20';

  lblMaxLineas := TLabel.Create(Self);
  lblMaxLineas.Parent := PanelTop;
  lblMaxLineas.Caption := 'Max lineas:';
  lblMaxLineas.Left := 130;
  lblMaxLineas.Top := Y + 4;

  seMaxLineas := TSpinEdit.Create(Self);
  seMaxLineas.Parent := PanelTop;
  seMaxLineas.Left := 205;
  seMaxLineas.Top := Y;
  seMaxLineas.Width := 65;
  seMaxLineas.MinValue := 10;
  seMaxLineas.MaxValue := 2000;
  seMaxLineas.Value := 250;

  chkAbrirPDF := TCheckBox.Create(Self);
  chkAbrirPDF.Parent := PanelTop;
  chkAbrirPDF.Left := 285;
  chkAbrirPDF.Top := Y + 2;
  chkAbrirPDF.Caption := 'Abrir PDF';
  chkAbrirPDF.Checked := True;

  btnDetectar := TButton.Create(Self);
  btnDetectar.Parent := PanelTop;
  btnDetectar.Left := 390;
  btnDetectar.Top := Y - 1;
  btnDetectar.Width := 120;
  btnDetectar.Height := 27;
  btnDetectar.Caption := 'Detectar cand.';
  btnDetectar.OnClick := @BtnDetectarClick;

  btnCalcular := TButton.Create(Self);
  btnCalcular.Parent := PanelTop;
  btnCalcular.Left := 515;
  btnCalcular.Top := Y - 1;
  btnCalcular.Width := 130;
  btnCalcular.Height := 27;
  btnCalcular.Caption := 'Calcular temp.';
  btnCalcular.OnClick := @BtnCalcularClick;

  btnVerAuto := TButton.Create(Self);
  btnVerAuto.Parent := PanelTop;
  btnVerAuto.Left := 650;
  btnVerAuto.Top := Y - 1;
  btnVerAuto.Width := 80;
  btnVerAuto.Height := 27;
  btnVerAuto.Caption := 'Ver auto';
  btnVerAuto.OnClick := @BtnVerAutoClick;

  btnVerDudas := TButton.Create(Self);
  btnVerDudas.Parent := PanelTop;
  btnVerDudas.Left := 735;
  btnVerDudas.Top := Y - 1;
  btnVerDudas.Width := 85;
  btnVerDudas.Height := 27;
  btnVerDudas.Caption := 'Ver dudas';
  btnVerDudas.OnClick := @BtnVerDudasClick;

  btnVerExcluidos := TButton.Create(Self);
  btnVerExcluidos.Parent := PanelTop;
  btnVerExcluidos.Left := 825;
  btnVerExcluidos.Top := Y - 1;
  btnVerExcluidos.Width := 95;
  btnVerExcluidos.Height := 27;
  btnVerExcluidos.Caption := 'Ver excl.';
  btnVerExcluidos.OnClick := @BtnVerExcluidosClick;

  btnAceptarLinea := TButton.Create(Self);
  btnAceptarLinea.Parent := PanelTop;
  btnAceptarLinea.Left := 925;
  btnAceptarLinea.Top := Y - 1;
  btnAceptarLinea.Width := 95;
  btnAceptarLinea.Height := 27;
  btnAceptarLinea.Caption := 'Aceptar';
  btnAceptarLinea.Hint := 'Marca la linea seleccionada como correcta/ALTA y la guarda como articulo de temporada';
  btnAceptarLinea.ShowHint := True;
  btnAceptarLinea.OnClick := @BtnAceptarLineaClick;

  btnRevisarLinea := TButton.Create(Self);
  btnRevisarLinea.Parent := PanelTop;
  btnRevisarLinea.Left := 1025;
  btnRevisarLinea.Top := Y - 1;
  btnRevisarLinea.Width := 90;
  btnRevisarLinea.Height := 27;
  btnRevisarLinea.Caption := 'Revisar';
  btnRevisarLinea.Hint := 'Marca la linea seleccionada como duda/MEDIA';
  btnRevisarLinea.ShowHint := True;
  btnRevisarLinea.OnClick := @BtnRevisarLineaClick;

  btnExcluirLinea := TButton.Create(Self);
  btnExcluirLinea.Parent := PanelTop;
  btnExcluirLinea.Left := 1120;
  btnExcluirLinea.Top := Y - 1;
  btnExcluirLinea.Width := 85;
  btnExcluirLinea.Height := 27;
  btnExcluirLinea.Caption := 'Excluir';
  btnExcluirLinea.Hint := 'Marca la linea seleccionada como excluida/BAJA y pone cantidad final a 0';
  btnExcluirLinea.ShowHint := True;
  btnExcluirLinea.OnClick := @BtnExcluirLineaClick;

  Y := 106;
  btnGuardarTemporada := TButton.Create(Self);
  btnGuardarTemporada.Parent := PanelTop;
  btnGuardarTemporada.Left := 8;
  btnGuardarTemporada.Top := Y;
  btnGuardarTemporada.Width := 130;
  btnGuardarTemporada.Height := 27;
  btnGuardarTemporada.Caption := 'Guardar temp.';
  btnGuardarTemporada.OnClick := @BtnGuardarTemporadaClick;

  btnCSV := TButton.Create(Self);
  btnCSV.Parent := PanelTop;
  btnCSV.Left := 145;
  btnCSV.Top := Y;
  btnCSV.Width := 95;
  btnCSV.Height := 27;
  btnCSV.Caption := 'CSV';
  btnCSV.OnClick := @BtnCSVClick;

  btnPDF := TButton.Create(Self);
  btnPDF.Parent := PanelTop;
  btnPDF.Left := 245;
  btnPDF.Top := Y;
  btnPDF.Width := 95;
  btnPDF.Height := 27;
  btnPDF.Caption := 'PDF';
  btnPDF.OnClick := @BtnPDFClick;

  btnImprimir := TButton.Create(Self);
  btnImprimir.Parent := PanelTop;
  btnImprimir.Left := 345;
  btnImprimir.Top := Y;
  btnImprimir.Width := 95;
  btnImprimir.Height := 27;
  btnImprimir.Caption := 'Imprimir';
  btnImprimir.OnClick := @BtnImprimirClick;

  btnOrdenTienda := TButton.Create(Self);
  btnOrdenTienda.Parent := PanelTop;
  btnOrdenTienda.Left := 445;
  btnOrdenTienda.Top := Y;
  btnOrdenTienda.Width := 110;
  btnOrdenTienda.Height := 27;
  btnOrdenTienda.Caption := 'Orden tienda';
  btnOrdenTienda.OnClick := @BtnOrdenTiendaClick;

  btnVerCompra := TButton.Create(Self);
  btnVerCompra.Parent := PanelTop;
  btnVerCompra.Left := 560;
  btnVerCompra.Top := Y;
  btnVerCompra.Width := 105;
  btnVerCompra.Height := 27;
  btnVerCompra.Caption := 'Ver compra';
  btnVerCompra.Hint := 'Muestra solo lineas con cantidad final > 0 para imprimir, PDF o crear borrador';
  btnVerCompra.ShowHint := True;
  btnVerCompra.OnClick := @BtnVerCompraClick;

  Y := 172;
  btnGuardarKeywords := TButton.Create(Self);
  btnGuardarKeywords.Parent := PanelTop;
  btnGuardarKeywords.Left := 8;
  btnGuardarKeywords.Top := Y;
  btnGuardarKeywords.Width := 120;
  btnGuardarKeywords.Height := 27;
  btnGuardarKeywords.Caption := 'Guardar claves';
  btnGuardarKeywords.Hint := 'Guarda las palabras clave de esta temporada para futuras sesiones';
  btnGuardarKeywords.ShowHint := True;
  btnGuardarKeywords.OnClick := @BtnGuardarKeywordsClick;

  btnGuardarBorrador := TButton.Create(Self);
  btnGuardarBorrador.Parent := PanelTop;
  btnGuardarBorrador.Left := 135;
  btnGuardarBorrador.Top := Y;
  btnGuardarBorrador.Width := 115;
  btnGuardarBorrador.Height := 27;
  btnGuardarBorrador.Caption := 'Guardar borr.';
  btnGuardarBorrador.Hint := 'Guarda el estudio completo: auto, dudas y excluidos';
  btnGuardarBorrador.ShowHint := True;
  btnGuardarBorrador.OnClick := @BtnGuardarBorradorClick;

  btnCargarBorrador := TButton.Create(Self);
  btnCargarBorrador.Parent := PanelTop;
  btnCargarBorrador.Left := 255;
  btnCargarBorrador.Top := Y;
  btnCargarBorrador.Width := 110;
  btnCargarBorrador.Height := 27;
  btnCargarBorrador.Caption := 'Cargar borr.';
  btnCargarBorrador.Hint := 'Carga el ultimo borrador guardado de esta temporada/proveedor';
  btnCargarBorrador.ShowHint := True;
  btnCargarBorrador.OnClick := @BtnCargarBorradorClick;

  btnBorrarBorrador := TButton.Create(Self);
  btnBorrarBorrador.Parent := PanelTop;
  btnBorrarBorrador.Left := 370;
  btnBorrarBorrador.Top := Y;
  btnBorrarBorrador.Width := 110;
  btnBorrarBorrador.Height := 27;
  btnBorrarBorrador.Caption := 'Borrar borr.';
  btnBorrarBorrador.Hint := 'Borra el ultimo borrador guardado de esta temporada/proveedor';
  btnBorrarBorrador.ShowHint := True;
  btnBorrarBorrador.OnClick := @BtnBorrarBorradorClick;

  btnCompararTempAnt := TButton.Create(Self);
  btnCompararTempAnt.Parent := PanelTop;
  btnCompararTempAnt.Left := 500;
  btnCompararTempAnt.Top := 204;
  btnCompararTempAnt.Width := 145;
  btnCompararTempAnt.Height := 27;
  btnCompararTempAnt.Caption := 'Comparar ant.';
  btnCompararTempAnt.Hint := 'Compara el estudio visible/completo con la temporada base anterior y muestra articulos vendidos antes que ahora no entran.';
  btnCompararTempAnt.ShowHint := True;
  btnCompararTempAnt.OnClick := @BtnCompararTempAntClick;

  Y := 106;
  lblCodigoManual := TLabel.Create(Self);
  lblCodigoManual.Parent := PanelTop;
  lblCodigoManual.Caption := 'Codigo temporada:';
  lblCodigoManual.Left := 8;
  lblCodigoManual.Top := Y + 38;

  edtCodigoManual := TEdit.Create(Self);
  edtCodigoManual.Parent := PanelTop;
  edtCodigoManual.Left := 125;
  edtCodigoManual.Top := Y + 34;
  edtCodigoManual.Width := 105;
  edtCodigoManual.Hint := 'Codigo de articulo a incluir/quitar manualmente';

  btnIncluirManual := TButton.Create(Self);
  btnIncluirManual.Parent := PanelTop;
  btnIncluirManual.Left := 235;
  btnIncluirManual.Top := Y + 33;
  btnIncluirManual.Width := 105;
  btnIncluirManual.Height := 27;
  btnIncluirManual.Caption := 'Incluir cod.';
  btnIncluirManual.OnClick := @BtnIncluirManualClick;

  btnQuitarManual := TButton.Create(Self);
  btnQuitarManual.Parent := PanelTop;
  btnQuitarManual.Left := 345;
  btnQuitarManual.Top := Y + 33;
  btnQuitarManual.Width := 100;
  btnQuitarManual.Height := 27;
  btnQuitarManual.Caption := 'Quitar cod.';
  btnQuitarManual.OnClick := @BtnQuitarManualClick;

  btnVerGuardados := TButton.Create(Self);
  btnVerGuardados.Parent := PanelTop;
  btnVerGuardados.Left := 450;
  btnVerGuardados.Top := Y + 33;
  btnVerGuardados.Width := 105;
  btnVerGuardados.Height := 27;
  btnVerGuardados.Caption := 'Ver guard.';
  btnVerGuardados.OnClick := @BtnVerGuardadosClick;

  lblKeywords := TLabel.Create(Self);
  lblKeywords.Parent := PanelTop;
  lblKeywords.Caption := 'Palabras clave temporada:';
  lblKeywords.Left := 565;
  lblKeywords.Top := Y + 4;

  memoKeywords := TMemo.Create(Self);
  memoKeywords.Parent := PanelTop;
  memoKeywords.Left := 735;
  memoKeywords.Top := 102;
  memoKeywords.Width := 420;
  memoKeywords.Height := 94;
  memoKeywords.ScrollBars := ssVertical;
  memoKeywords.Lines.Text := 'CLORO' + LineEnding + 'CLOR' + LineEnding +
    'PISCINA' + LineEnding + 'PH' + LineEnding + 'ANTIALGAS' + LineEnding +
    'ALGICIDA' + LineEnding + 'SALFUMANT' + LineEnding + 'FLOCULANTE' + LineEnding +
    'MULTIFUNCION' + LineEnding + 'LIMPIAFONDOS' + LineEnding + 'INCREMENTADOR' + LineEnding +
    'REDUCTOR' + LineEnding + 'ALBORAL' + LineEnding + 'ALB' + LineEnding +
    'PASTILLA' + LineEnding + 'PASTILLAS' + LineEnding + 'GRANULADO' + LineEnding +
    'TABLETA' + LineEnding + 'TABLETAS' + LineEnding + 'MULTIACCION' + LineEnding +
    'TRICLORO' + LineEnding + 'DICLORO' + LineEnding + 'BROMO' + LineEnding +
    'TEC';

  PanelBottom := TPanel.Create(Self);
  PanelBottom.Parent := Self;
  PanelBottom.Align := alBottom;
  PanelBottom.Height := 28;
  PanelBottom.BevelOuter := bvNone;

  Progress := TProgressBar.Create(Self);
  Progress.Parent := PanelBottom;
  Progress.Left := 8;
  Progress.Top := 5;
  Progress.Width := 300;
  Progress.Height := 16;
  Progress.Min := 0;
  Progress.Max := 100;
  Progress.Position := 0;

  lblEstado := TLabel.Create(Self);
  lblEstado.Parent := PanelBottom;
  lblEstado.Left := 320;
  lblEstado.Top := 7;
  lblEstado.Caption := 'Preparado';

  Grid := TStringGrid.Create(Self);
  Grid.Parent := Self;
  Grid.Align := alClient;
  Grid.FixedRows := 1;
  { goFixedRowClick no existe en algunas versiones de Lazarus/FPC.
    La ordenacion por cabecera se mantiene con OnHeaderClick. }
  Grid.Options := Grid.Options + [goRowSelect, goColSizing, goEditing];
  Grid.OnHeaderClick := @GridHeaderClick;
  InicializarGrid;
end;

procedure TfPedidoTemporadaAuto.InicializarGrid;
const
  Headers: array[0..14] of string = (
    'Codigo', 'Descripcion', 'Vend. base', 'Vend. actual', 'Venta/dia',
    'Sugerido', 'Cantidad final', 'Confianza', 'Ult. compra', 'Coste', 'PVP',
    'IVA', 'Familia', 'Estado', 'Observaciones');
var
  I: Integer;
begin
  Grid.ColCount := Length(Headers);
  Grid.RowCount := 2;
  for I := 0 to High(Headers) do
    Grid.Cells[I, 0] := Headers[I];
  Grid.Rows[1].Clear;
  Grid.ColWidths[0] := 90;
  Grid.ColWidths[1] := 310;
  Grid.ColWidths[2] := 80;
  Grid.ColWidths[3] := 80;
  Grid.ColWidths[4] := 80;
  Grid.ColWidths[5] := 80;
  Grid.ColWidths[6] := 90;
  Grid.ColWidths[7] := 80;
  Grid.ColWidths[8] := 90;
  Grid.ColWidths[9] := 70;
  Grid.ColWidths[10] := 70;
  Grid.ColWidths[11] := 55;
  Grid.ColWidths[12] := 70;
  Grid.ColWidths[13] := 120;
  Grid.ColWidths[14] := 520;
end;

procedure TfPedidoTemporadaAuto.ProgresoInicio(const AMsg: string; const AMax: Integer);
begin
  Progress.Max := Max(1, AMax);
  Progress.Position := 0;
  lblEstado.Caption := AMsg;
  Log(AMsg);
  Application.ProcessMessages;
end;

procedure TfPedidoTemporadaAuto.ProgresoPaso(const AMsg: string; const APos: Integer; const AMax: Integer);
begin
  if AMax > 0 then Progress.Max := AMax;
  if APos >= 0 then Progress.Position := Min(Progress.Max, APos)
  else if Progress.Position < Progress.Max then Progress.Position := Progress.Position + 1;
  lblEstado.Caption := AMsg;
  Application.ProcessMessages;
end;

procedure TfPedidoTemporadaAuto.ProgresoFin(const AMsg: string);
begin
  Progress.Position := Progress.Max;
  lblEstado.Caption := AMsg;
  Log(AMsg);
  Application.ProcessMessages;
end;

function TfPedidoTemporadaAuto.SufijoTiendaSeguro(const S: string): string;
var
  I: Integer;
  C: Char;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    C := S[I];
    if C in ['0'..'9','A'..'Z','a'..'z','_'] then Result := Result + C;
  end;
end;

function TfPedidoTemporadaAuto.TablaExiste(const NombreTabla: string): Boolean;
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

procedure TfPedidoTemporadaAuto.CrearTablasTemporada;
var
  Q: TZQuery;
begin
  if (FConn = nil) or (not FConn.Connected) then Exit;
  ProgresoInicio('Verificando tablas de temporada...', 5);
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS pedido_temporada_articulos (' +
      'tienda VARCHAR(20) NOT NULL, ' +
      'temporada VARCHAR(50) NOT NULL, ' +
      'codigo VARCHAR(50) NOT NULL, ' +
      'activo TINYINT DEFAULT 1, ' +
      'principal TINYINT DEFAULT 0, ' +
      'observacion VARCHAR(255) DEFAULT '''', ' +
      'updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, ' +
      'PRIMARY KEY (tienda, temporada, codigo)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8';
    Q.ExecSQL;
    ProgresoPaso('Tabla pedido_temporada_articulos OK', 1, 5);

    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS pedido_temporada_perfiles (' +
      'tienda VARCHAR(20) NOT NULL, ' +
      'temporada VARCHAR(50) NOT NULL, ' +
      'cod_proveedor INT DEFAULT 0, ' +
      'desde_base VARCHAR(10) DEFAULT '''', ' +
      'hasta_base VARCHAR(10) DEFAULT '''', ' +
      'dias_cubrir INT DEFAULT 30, ' +
      'dias_actual INT DEFAULT 30, ' +
      'factor DECIMAL(10,4) DEFAULT 1.2, ' +
      'keywords TEXT, ' +
      'updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, ' +
      'PRIMARY KEY (tienda, temporada)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8';
    Q.ExecSQL;
    ProgresoPaso('Tabla pedido_temporada_perfiles OK', 2, 5);

    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS pedido_temporada_keywords (' +
      'tienda VARCHAR(20) NOT NULL, ' +
      'temporada VARCHAR(50) NOT NULL, ' +
      'keyword VARCHAR(120) NOT NULL, ' +
      'orden INT DEFAULT 0, ' +
      'activo TINYINT DEFAULT 1, ' +
      'updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, ' +
      'PRIMARY KEY (tienda, temporada, keyword)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8';
    Q.ExecSQL;
    ProgresoPaso('Tabla pedido_temporada_keywords OK', 3, 5);

    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS pedido_temporada_borrador_cab (' +
      'id INT NOT NULL AUTO_INCREMENT, ' +
      'tienda VARCHAR(20) NOT NULL, ' +
      'temporada VARCHAR(50) NOT NULL, ' +
      'cod_proveedor INT DEFAULT 0, ' +
      'nombre_proveedor VARCHAR(160) DEFAULT '''', ' +
      'fecha DATETIME DEFAULT CURRENT_TIMESTAMP, ' +
      'desde_base VARCHAR(10) DEFAULT '''', ' +
      'hasta_base VARCHAR(10) DEFAULT '''', ' +
      'dias_cubrir INT DEFAULT 30, ' +
      'dias_actual INT DEFAULT 30, ' +
      'factor DECIMAL(10,4) DEFAULT 1.2, ' +
      'max_lineas INT DEFAULT 250, ' +
      'usar_actual TINYINT DEFAULT 1, ' +
      'proveedor_temporada TINYINT DEFAULT 0, ' +
      'keywords TEXT, ' +
      'observacion VARCHAR(255) DEFAULT '''', ' +
      'PRIMARY KEY (id), KEY idx_temp_prov (tienda, temporada, cod_proveedor)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8';
    Q.ExecSQL;
    ProgresoPaso('Tabla pedido_temporada_borrador_cab OK', 4, 5);

    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS pedido_temporada_borrador_lin (' +
      'id INT NOT NULL AUTO_INCREMENT, ' +
      'borrador_id INT NOT NULL, ' +
      'codigo VARCHAR(50) NOT NULL, ' +
      'descripcion VARCHAR(255) DEFAULT '''', ' +
      'ventas_base DECIMAL(12,4) DEFAULT 0, ' +
      'ventas_actual DECIMAL(12,4) DEFAULT 0, ' +
      'venta_dia DECIMAL(12,6) DEFAULT 0, ' +
      'sugerido DECIMAL(12,4) DEFAULT 0, ' +
      'cantidad_final DECIMAL(12,4) DEFAULT 0, ' +
      'ult_venta_base VARCHAR(20) DEFAULT '''', ' +
      'ult_venta_actual VARCHAR(20) DEFAULT '''', ' +
      'ult_compra VARCHAR(20) DEFAULT '''', ' +
      'coste DECIMAL(12,4) DEFAULT 0, ' +
      'pvp DECIMAL(12,4) DEFAULT 0, ' +
      'iva DECIMAL(12,4) DEFAULT 0, ' +
      'familia VARCHAR(50) DEFAULT '''', ' +
      'estado VARCHAR(80) DEFAULT '''', ' +
      'confianza VARCHAR(20) DEFAULT '''', ' +
      'observaciones TEXT, ' +
      'prioridad DECIMAL(14,4) DEFAULT 0, ' +
      'marcado_temporada TINYINT DEFAULT 0, ' +
      'PRIMARY KEY (id), KEY idx_borrador (borrador_id), KEY idx_codigo (codigo)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8';
    Q.ExecSQL;
    ProgresoPaso('Tabla pedido_temporada_borrador_lin OK', 5, 5);
  finally
    Q.Free;
  end;

  ProgresoFin('Tablas de temporada verificadas');
end;

function TfPedidoTemporadaAuto.KeywordsComoTexto: string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to memoKeywords.Lines.Count - 1 do
    if Trim(memoKeywords.Lines[I]) <> '' then
    begin
      if Result <> '' then Result := Result + LineEnding;
      Result := Result + Trim(memoKeywords.Lines[I]);
    end;
end;


procedure TfPedidoTemporadaAuto.InicializarTemporadasBase;
begin
  cbTemporada.Items.Clear;
  cbTemporada.Items.Add('Piscinas');
  cbTemporada.Items.Add('Verano');
  cbTemporada.Items.Add('Invierno');
  cbTemporada.Items.Add('Primavera');
  cbTemporada.Items.Add('Otono');
  cbTemporada.Items.Add('Navidad');
  cbTemporada.Items.Add('San Valentin');
  cbTemporada.Items.Add('Fallas');
  cbTemporada.Items.Add('Nou de Octubre');
end;

procedure TfPedidoTemporadaAuto.InicializarModosTemporada;
begin
  cbModo.Items.Clear;
  cbModo.Items.Add('Pretemporada');
  cbModo.Items.Add('Reposicion');
  cbModo.Items.Add('Final temporada');
end;

function TfPedidoTemporadaAuto.ModoTemporadaSeleccionado: string;
begin
  Result := UTF8UpperString(Trim(cbModo.Text));
  if Result = '' then Result := 'PRETEMPORADA';
end;

function TfPedidoTemporadaAuto.MesDiaFechaBase(const Anio: Integer; const Mes, Dia: Word): string;
begin
  Result := Format('%.4d-%.2d-%.2d', [Anio, Mes, Dia]);
end;

function TfPedidoTemporadaAuto.KeywordsPorDefecto(const ATemporada: string): string;
var
  T: string;
begin
  T := UTF8UpperString(Trim(ATemporada));
  if T = 'PISCINAS' then
    Result := 'CLORO' + LineEnding + 'CLOR' + LineEnding + 'PISCINA' + LineEnding +
      'PH' + LineEnding + 'ANTIALGAS' + LineEnding + 'ALGICIDA' + LineEnding +
      'SALFUMANT' + LineEnding + 'FLOCULANTE' + LineEnding + 'MULTIFUNCION' + LineEnding +
      'LIMPIAFONDOS' + LineEnding + 'INCREMENTADOR' + LineEnding + 'REDUCTOR' + LineEnding +
      'ALBORAL' + LineEnding + 'ALB' + LineEnding + 'PASTILLA' + LineEnding +
      'PASTILLAS' + LineEnding + 'GRANULADO' + LineEnding + 'TABLETA' + LineEnding +
      'TABLETAS' + LineEnding + 'MULTIACCION' + LineEnding + 'TRICLORO' + LineEnding +
      'DICLORO' + LineEnding + 'BROMO' + LineEnding + 'TEC'
  else if T = 'VERANO' then
    Result := 'VERANO' + LineEnding + 'PLAYA' + LineEnding + 'SOLAR' + LineEnding +
      'PROTECTOR' + LineEnding + 'BRONCEADOR' + LineEnding + 'AFTERSUN' + LineEnding +
      'MOSQUITO' + LineEnding + 'MOSQUITOS' + LineEnding + 'REPELENTE' + LineEnding +
      'INSECTICIDA' + LineEnding + 'CUCARACHA' + LineEnding + 'HORMIGA' + LineEnding +
      'SOMBRILLA' + LineEnding + 'NEVERA' + LineEnding + 'HIELO' + LineEnding +
      'PISCINA' + LineEnding + 'CLORO'
  else if T = 'INVIERNO' then
    Result := 'INVIERNO' + LineEnding + 'FRIO' + LineEnding + 'HUMEDAD' + LineEnding +
      'ANTIHUMEDAD' + LineEnding + 'DESHUMIDIFICADOR' + LineEnding + 'CALEFACTOR' + LineEnding +
      'ESTUFA' + LineEnding + 'BOLSA AGUA' + LineEnding + 'MANTA' + LineEnding +
      'LENA' + LineEnding + 'ENCENDEDOR' + LineEnding + 'CERILLA' + LineEnding +
      'VELA' + LineEnding + 'PILAS'
  else if T = 'PRIMAVERA' then
    Result := 'PRIMAVERA' + LineEnding + 'JARDIN' + LineEnding + 'PLANTA' + LineEnding +
      'MACETA' + LineEnding + 'TIERRA' + LineEnding + 'ABONO' + LineEnding +
      'FERTILIZANTE' + LineEnding + 'INSECTICIDA' + LineEnding + 'MOSQUITO' + LineEnding +
      'HORMIGA' + LineEnding + 'POLILLA' + LineEnding + 'AMBIENTADOR'
  else if T = 'OTONO' then
    Result := 'OTONO' + LineEnding + 'HUMEDAD' + LineEnding + 'ANTIHUMEDAD' + LineEnding +
      'DESHUMIDIFICADOR' + LineEnding + 'POLILLA' + LineEnding + 'ANTIPOLILLA' + LineEnding +
      'GUARDARROPA' + LineEnding + 'ARMARIO' + LineEnding + 'PERCHA' + LineEnding +
      'FUNDA' + LineEnding + 'AMBIENTADOR' + LineEnding + 'LLUVIA'
  else if T = 'NAVIDAD' then
    Result := 'NAVIDAD' + LineEnding + 'REGALO' + LineEnding + 'REGALOS' + LineEnding +
      'CESTA' + LineEnding + 'LOTE' + LineEnding + 'VELA' + LineEnding +
      'VELAS' + LineEnding + 'PILAS' + LineEnding + 'ADORNO' + LineEnding +
      'DECORACION' + LineEnding + 'BOLSA REGALO' + LineEnding + 'PAPEL REGALO' + LineEnding +
      'CINTA' + LineEnding + 'LAZO' + LineEnding + 'PERFUME' + LineEnding + 'COLONIA'
  else if T = 'SAN VALENTIN' then
    Result := 'SAN VALENTIN' + LineEnding + 'VALENTIN' + LineEnding + 'REGALO' + LineEnding +
      'REGALOS' + LineEnding + 'CORAZON' + LineEnding + 'PERFUME' + LineEnding +
      'COLONIA' + LineEnding + 'VELA' + LineEnding + 'VELAS' + LineEnding +
      'BOLSA REGALO' + LineEnding + 'PAPEL REGALO' + LineEnding + 'LAZO'
  else if T = 'FALLAS' then
    Result := 'FALLAS' + LineEnding + 'FALLA' + LineEnding + 'VALENCIA' + LineEnding +
      'REGALO' + LineEnding + 'REGALOS' + LineEnding + 'PANUELO' + LineEnding +
      'PANUELOS' + LineEnding + 'BANDERA' + LineEnding + 'FLOR' + LineEnding +
      'FLORES' + LineEnding + 'PILAS' + LineEnding + 'TOALLITA' + LineEnding +
      'LIMPIEZA' + LineEnding + 'DESENGRASANTE'
  else if T = 'NOU DE OCTUBRE' then
    Result := 'NOU DE OCTUBRE' + LineEnding + '9 OCTUBRE' + LineEnding + 'NOU OCTUBRE' + LineEnding +
      'REGALO' + LineEnding + 'REGALOS' + LineEnding + 'MOCADORA' + LineEnding +
      'MOCAORA' + LineEnding + 'PANUELO' + LineEnding + 'PANUELOS' + LineEnding +
      'BOLSA REGALO' + LineEnding + 'PAPEL REGALO' + LineEnding + 'LAZO' + LineEnding +
      'DULCE' + LineEnding + 'DULCES'
  else
    Result := 'REGALO' + LineEnding + 'TEMPORADA';
end;

procedure TfPedidoTemporadaAuto.AplicarDefaultsTemporada(const ATemporada: string);
var
  BaseYear: Integer;
  T: string;
begin
  BaseYear := YearOf(Date) - 1;
  T := UTF8UpperString(Trim(ATemporada));
  if cbModo <> nil then
  begin
    if (T = 'SAN VALENTIN') or (T = 'FALLAS') or (T = 'NOU DE OCTUBRE') then
      cbModo.ItemIndex := 1
    else
      cbModo.ItemIndex := 0;
  end;

  if T = 'PISCINAS' then
  begin
    edtDesdeBase.Text := MesDiaFechaBase(BaseYear, 4, 1);
    edtHastaBase.Text := MesDiaFechaBase(BaseYear, 8, 31);
    seDiasCubrir.Value := 30;
    seDiasActual.Value := 30;
    edtFactor.Text := '1,20';
  end
  else if T = 'VERANO' then
  begin
    edtDesdeBase.Text := MesDiaFechaBase(BaseYear, 6, 1);
    edtHastaBase.Text := MesDiaFechaBase(BaseYear, 8, 31);
    seDiasCubrir.Value := 30;
    seDiasActual.Value := 30;
    edtFactor.Text := '1,15';
  end
  else if T = 'INVIERNO' then
  begin
    if MonthOf(Date) <= 2 then
    begin
      edtDesdeBase.Text := MesDiaFechaBase(BaseYear - 1, 11, 1);
      edtHastaBase.Text := MesDiaFechaBase(BaseYear, 2, 28);
    end
    else
    begin
      edtDesdeBase.Text := MesDiaFechaBase(BaseYear, 11, 1);
      edtHastaBase.Text := MesDiaFechaBase(BaseYear + 1, 2, 28);
    end;
    seDiasCubrir.Value := 30;
    seDiasActual.Value := 30;
    edtFactor.Text := '1,10';
  end
  else if T = 'PRIMAVERA' then
  begin
    edtDesdeBase.Text := MesDiaFechaBase(BaseYear, 3, 1);
    edtHastaBase.Text := MesDiaFechaBase(BaseYear, 5, 31);
    seDiasCubrir.Value := 30;
    seDiasActual.Value := 30;
    edtFactor.Text := '1,10';
  end
  else if T = 'OTONO' then
  begin
    edtDesdeBase.Text := MesDiaFechaBase(BaseYear, 9, 1);
    edtHastaBase.Text := MesDiaFechaBase(BaseYear, 11, 30);
    seDiasCubrir.Value := 30;
    seDiasActual.Value := 30;
    edtFactor.Text := '1,10';
  end
  else if T = 'NAVIDAD' then
  begin
    if MonthOf(Date) <= 1 then
    begin
      edtDesdeBase.Text := MesDiaFechaBase(BaseYear - 1, 11, 15);
      edtHastaBase.Text := MesDiaFechaBase(BaseYear, 1, 6);
    end
    else
    begin
      edtDesdeBase.Text := MesDiaFechaBase(BaseYear, 11, 15);
      edtHastaBase.Text := MesDiaFechaBase(BaseYear + 1, 1, 6);
    end;
    seDiasCubrir.Value := 45;
    seDiasActual.Value := 30;
    edtFactor.Text := '1,20';
  end
  else if T = 'SAN VALENTIN' then
  begin
    edtDesdeBase.Text := MesDiaFechaBase(BaseYear, 1, 25);
    edtHastaBase.Text := MesDiaFechaBase(BaseYear, 2, 14);
    seDiasCubrir.Value := 21;
    seDiasActual.Value := 21;
    edtFactor.Text := '1,15';
  end
  else if T = 'FALLAS' then
  begin
    edtDesdeBase.Text := MesDiaFechaBase(BaseYear, 3, 1);
    edtHastaBase.Text := MesDiaFechaBase(BaseYear, 3, 19);
    seDiasCubrir.Value := 21;
    seDiasActual.Value := 21;
    edtFactor.Text := '1,15';
  end
  else if T = 'NOU DE OCTUBRE' then
  begin
    edtDesdeBase.Text := MesDiaFechaBase(BaseYear, 9, 20);
    edtHastaBase.Text := MesDiaFechaBase(BaseYear, 10, 9);
    seDiasCubrir.Value := 21;
    seDiasActual.Value := 21;
    edtFactor.Text := '1,15';
  end;

  memoKeywords.Lines.Text := KeywordsPorDefecto(ATemporada);
  Log('Defaults aplicados para temporada ' + ATemporada);
end;

procedure TfPedidoTemporadaAuto.CargarKeywordsTemporada;
var
  Q: TZQuery;
begin
  if (FConn = nil) or (not FConn.Connected) then Exit;
  if not TablaExiste('pedido_temporada_keywords') then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT keyword FROM pedido_temporada_keywords ' +
      'WHERE tienda=:T AND temporada=:TEMP AND activo=1 ORDER BY orden, keyword';
    Q.ParamByName('T').AsString := FTienda;
    Q.ParamByName('TEMP').AsString := cbTemporada.Text;
    Q.Open;
    if not Q.EOF then
    begin
      memoKeywords.Lines.BeginUpdate;
      try
        memoKeywords.Clear;
        while not Q.EOF do
        begin
          if Trim(Q.FieldByName('keyword').AsString) <> '' then
            memoKeywords.Lines.Add(Q.FieldByName('keyword').AsString);
          Q.Next;
        end;
      finally
        memoKeywords.Lines.EndUpdate;
      end;
      Log('Palabras clave de temporada cargadas: ' + IntToStr(memoKeywords.Lines.Count));
    end;
  finally
    Q.Free;
  end;
end;

procedure TfPedidoTemporadaAuto.GuardarKeywordsTemporada;
var
  Q: TZQuery;
  I, N: Integer;
  K: string;
begin
  if (FConn = nil) or (not FConn.Connected) then Exit;
  CrearTablasTemporada;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'DELETE FROM pedido_temporada_keywords WHERE tienda=:T AND temporada=:TEMP';
    Q.ParamByName('T').AsString := FTienda;
    Q.ParamByName('TEMP').AsString := cbTemporada.Text;
    Q.ExecSQL;
    N := 0;
    for I := 0 to memoKeywords.Lines.Count - 1 do
    begin
      K := UTF8UpperString(Trim(memoKeywords.Lines[I]));
      if K = '' then Continue;
      Inc(N);
      Q.SQL.Text := 'REPLACE INTO pedido_temporada_keywords ' +
        '(tienda, temporada, keyword, orden, activo) VALUES (:T,:TEMP,:K,:O,1)';
      Q.ParamByName('T').AsString := FTienda;
      Q.ParamByName('TEMP').AsString := cbTemporada.Text;
      Q.ParamByName('K').AsString := K;
      Q.ParamByName('O').AsInteger := N;
      Q.ExecSQL;
    end;
  finally
    Q.Free;
  end;
  Log('Palabras clave guardadas para temporada ' + cbTemporada.Text + ': ' + IntToStr(N));
end;

procedure TfPedidoTemporadaAuto.SincronizarGridAFLineasTodas;
var
  R, I: Integer;
  Cod: string;
  L: TLineaTemporada;
  Encontrado: Boolean;
begin
  if not HayDatosEnGrid then Exit;
  for R := 1 to Grid.RowCount - 1 do
  begin
    Cod := Trim(Grid.Cells[0, R]);
    if Cod = '' then Continue;
    Encontrado := False;
    for I := 0 to High(FLineasTodas) do
      if SameText(Trim(FLineasTodas[I].Codigo), Cod) then
      begin
        FLineasTodas[I].Descripcion := Grid.Cells[1, R];
        FLineasTodas[I].VentasBase := FloatSeguro(Grid.Cells[2, R], FLineasTodas[I].VentasBase);
        FLineasTodas[I].VentasActual := FloatSeguro(Grid.Cells[3, R], FLineasTodas[I].VentasActual);
        FLineasTodas[I].VentaDia := FloatSeguro(Grid.Cells[4, R], FLineasTodas[I].VentaDia);
        FLineasTodas[I].Sugerido := FloatSeguro(Grid.Cells[5, R], FLineasTodas[I].Sugerido);
        FLineasTodas[I].CantidadFinal := FloatSeguro(Grid.Cells[6, R], FLineasTodas[I].CantidadFinal);
        FLineasTodas[I].Confianza := Trim(Grid.Cells[7, R]);
        FLineasTodas[I].UltCompra := Trim(Grid.Cells[8, R]);
        FLineasTodas[I].Coste := FloatSeguro(Grid.Cells[9, R], FLineasTodas[I].Coste);
        FLineasTodas[I].PVP := FloatSeguro(Grid.Cells[10, R], FLineasTodas[I].PVP);
        FLineasTodas[I].IVA := FloatSeguro(Grid.Cells[11, R], FLineasTodas[I].IVA);
        FLineasTodas[I].Familia := Trim(Grid.Cells[12, R]);
        FLineasTodas[I].Estado := Trim(Grid.Cells[13, R]);
        FLineasTodas[I].Observaciones := Trim(Grid.Cells[14, R]);
        Encontrado := True;
        Break;
      end;
    if not Encontrado then
    begin
      FillChar(L, SizeOf(L), 0);
      L.Codigo := Cod;
      L.Descripcion := Grid.Cells[1, R];
      L.VentasBase := FloatSeguro(Grid.Cells[2, R], 0);
      L.VentasActual := FloatSeguro(Grid.Cells[3, R], 0);
      L.VentaDia := FloatSeguro(Grid.Cells[4, R], 0);
      L.Sugerido := FloatSeguro(Grid.Cells[5, R], 0);
      L.CantidadFinal := FloatSeguro(Grid.Cells[6, R], 0);
      L.Confianza := Trim(Grid.Cells[7, R]);
      L.UltCompra := Trim(Grid.Cells[8, R]);
      L.Coste := FloatSeguro(Grid.Cells[9, R], 0);
      L.PVP := FloatSeguro(Grid.Cells[10, R], 0);
      L.IVA := FloatSeguro(Grid.Cells[11, R], 0);
      L.Familia := Trim(Grid.Cells[12, R]);
      L.Estado := Trim(Grid.Cells[13, R]);
      L.Observaciones := Trim(Grid.Cells[14, R]);
      L.MarcadoTemporada := SameText(L.Confianza, 'ALTA');
      AddLinea(FLineasTodas, L);
    end;
  end;
  SepararLineas;
end;

procedure TfPedidoTemporadaAuto.GuardarBorradorCompleto;
var
  Q: TZQuery;
  I, IdBorrador, UsarAct, ProvTemp: Integer;
  Factor: Double;
begin
  if Length(FLineasTodas) = 0 then
  begin
    if HayDatosEnGrid then SincronizarGridAFLineasTodas;
    if Length(FLineasTodas) = 0 then
    begin
      ShowMessage('No hay estudio de temporada para guardar. Calcula o carga candidatos primero.');
      Exit;
    end;
  end;

  SincronizarGridAFLineasTodas;
  GuardarKeywordsTemporada;
  Factor := FloatSeguro(edtFactor.Text, 1.20);
  UsarAct := 0;
  ProvTemp := 0;
  if chkUsarActual.Checked then UsarAct := 1;
  if chkProveedorTemporada.Checked then ProvTemp := 1;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    ProgresoInicio('Guardando borrador completo...', Length(FLineasTodas));
    Q.SQL.Text := 'INSERT INTO pedido_temporada_borrador_cab ' +
      '(tienda, temporada, cod_proveedor, nombre_proveedor, desde_base, hasta_base, dias_cubrir, dias_actual, ' +
      'factor, max_lineas, usar_actual, proveedor_temporada, keywords, observacion) VALUES ' +
      '(:T,:TEMP,:P,:NP,:DB,:HB,:DC,:DA,:F,:MAX,:UA,:PT,:KW,:OBS)';
    Q.ParamByName('T').AsString := FTienda;
    Q.ParamByName('TEMP').AsString := cbTemporada.Text;
    Q.ParamByName('P').AsInteger := CodigoProveedorSeleccionado;
    Q.ParamByName('NP').AsString := NombreProveedorSeleccionado;
    Q.ParamByName('DB').AsString := edtDesdeBase.Text;
    Q.ParamByName('HB').AsString := edtHastaBase.Text;
    Q.ParamByName('DC').AsInteger := seDiasCubrir.Value;
    Q.ParamByName('DA').AsInteger := seDiasActual.Value;
    Q.ParamByName('F').AsFloat := Factor;
    Q.ParamByName('MAX').AsInteger := seMaxLineas.Value;
    Q.ParamByName('UA').AsInteger := UsarAct;
    Q.ParamByName('PT').AsInteger := ProvTemp;
    Q.ParamByName('KW').AsString := KeywordsComoTexto;
    Q.ParamByName('OBS').AsString := 'Borrador completo temporada';
    Q.ExecSQL;

    Q.SQL.Text := 'SELECT LAST_INSERT_ID() AS ID';
    Q.Open;
    IdBorrador := Q.FieldByName('ID').AsInteger;
    Q.Close;

    for I := 0 to High(FLineasTodas) do
    begin
      Q.SQL.Text := 'INSERT INTO pedido_temporada_borrador_lin ' +
        '(borrador_id,codigo,descripcion,ventas_base,ventas_actual,venta_dia,sugerido,cantidad_final,' +
        'ult_venta_base,ult_venta_actual,ult_compra,coste,pvp,iva,familia,estado,confianza,observaciones,prioridad,marcado_temporada) VALUES ' +
        '(:B,:COD,:DES,:VB,:VA,:VD,:SUG,:CF,:UVB,:UVA,:UC,:COS,:PVP,:IVA,:FAM,:EST,:CON,:OBS,:PRI,:MAR)';
      Q.ParamByName('B').AsInteger := IdBorrador;
      Q.ParamByName('COD').AsString := FLineasTodas[I].Codigo;
      Q.ParamByName('DES').AsString := FLineasTodas[I].Descripcion;
      Q.ParamByName('VB').AsFloat := FLineasTodas[I].VentasBase;
      Q.ParamByName('VA').AsFloat := FLineasTodas[I].VentasActual;
      Q.ParamByName('VD').AsFloat := FLineasTodas[I].VentaDia;
      Q.ParamByName('SUG').AsFloat := FLineasTodas[I].Sugerido;
      Q.ParamByName('CF').AsFloat := FLineasTodas[I].CantidadFinal;
      Q.ParamByName('UVB').AsString := FLineasTodas[I].UltVentaBase;
      Q.ParamByName('UVA').AsString := FLineasTodas[I].UltVentaActual;
      Q.ParamByName('UC').AsString := FLineasTodas[I].UltCompra;
      Q.ParamByName('COS').AsFloat := FLineasTodas[I].Coste;
      Q.ParamByName('PVP').AsFloat := FLineasTodas[I].PVP;
      Q.ParamByName('IVA').AsFloat := FLineasTodas[I].IVA;
      Q.ParamByName('FAM').AsString := FLineasTodas[I].Familia;
      Q.ParamByName('EST').AsString := FLineasTodas[I].Estado;
      Q.ParamByName('CON').AsString := FLineasTodas[I].Confianza;
      Q.ParamByName('OBS').AsString := FLineasTodas[I].Observaciones;
      Q.ParamByName('PRI').AsFloat := FLineasTodas[I].Prioridad;
      if FLineasTodas[I].MarcadoTemporada then
        Q.ParamByName('MAR').AsInteger := 1
      else
        Q.ParamByName('MAR').AsInteger := 0;
      Q.ExecSQL;
      if (I mod 25) = 0 then ProgresoPaso('Guardando borrador... ' + IntToStr(I + 1), I + 1, Length(FLineasTodas));
    end;
  finally
    Q.Free;
  end;
  ProgresoFin('Borrador completo guardado');
  Log('Borrador completo guardado. Lineas=' + IntToStr(Length(FLineasTodas)));
  ShowMessage('Borrador completo guardado.' + LineEnding +
    'Lineas totales: ' + IntToStr(Length(FLineasTodas)) + LineEnding +
    'Incluye AUTO, DUDAS y EXCLUIDOS.');
end;

procedure TfPedidoTemporadaAuto.CargarUltimoBorrador;
var
  Q: TZQuery;
  IdBorrador, CodProv: Integer;
  L: TLineaTemporada;
begin
  CrearTablasTemporada;
  CodProv := CodigoProveedorSeleccionado;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT * FROM pedido_temporada_borrador_cab ' +
      'WHERE tienda=:T AND temporada=:TEMP AND (:P=0 OR cod_proveedor=:P) ' +
      'ORDER BY id DESC LIMIT 1';
    Q.ParamByName('T').AsString := FTienda;
    Q.ParamByName('TEMP').AsString := cbTemporada.Text;
    Q.ParamByName('P').AsInteger := CodProv;
    Q.Open;
    if Q.EOF then
    begin
      ShowMessage('No hay borrador guardado para esta temporada/proveedor.');
      Exit;
    end;
    IdBorrador := Q.FieldByName('id').AsInteger;
    edtDesdeBase.Text := Q.FieldByName('desde_base').AsString;
    edtHastaBase.Text := Q.FieldByName('hasta_base').AsString;
    seDiasCubrir.Value := Q.FieldByName('dias_cubrir').AsInteger;
    seDiasActual.Value := Q.FieldByName('dias_actual').AsInteger;
    edtFactor.Text := FormatFloat('0.00', Q.FieldByName('factor').AsFloat);
    seMaxLineas.Value := Q.FieldByName('max_lineas').AsInteger;
    chkUsarActual.Checked := Q.FieldByName('usar_actual').AsInteger <> 0;
    chkProveedorTemporada.Checked := Q.FieldByName('proveedor_temporada').AsInteger <> 0;
    if Trim(Q.FieldByName('keywords').AsString) <> '' then
      memoKeywords.Lines.Text := Q.FieldByName('keywords').AsString;
    Q.Close;

    VaciarLineas;
    ProgresoInicio('Cargando borrador completo...', 100);
    Q.SQL.Text := 'SELECT * FROM pedido_temporada_borrador_lin WHERE borrador_id=:B ORDER BY id';
    Q.ParamByName('B').AsInteger := IdBorrador;
    Q.Open;
    while not Q.EOF do
    begin
      FillChar(L, SizeOf(L), 0);
      L.Codigo := Q.FieldByName('codigo').AsString;
      L.Descripcion := Q.FieldByName('descripcion').AsString;
      L.VentasBase := Q.FieldByName('ventas_base').AsFloat;
      L.VentasActual := Q.FieldByName('ventas_actual').AsFloat;
      L.VentaDia := Q.FieldByName('venta_dia').AsFloat;
      L.Sugerido := Q.FieldByName('sugerido').AsFloat;
      L.CantidadFinal := Q.FieldByName('cantidad_final').AsFloat;
      L.UltVentaBase := Q.FieldByName('ult_venta_base').AsString;
      L.UltVentaActual := Q.FieldByName('ult_venta_actual').AsString;
      L.UltCompra := Q.FieldByName('ult_compra').AsString;
      L.Coste := Q.FieldByName('coste').AsFloat;
      L.PVP := Q.FieldByName('pvp').AsFloat;
      L.IVA := Q.FieldByName('iva').AsFloat;
      L.Familia := Q.FieldByName('familia').AsString;
      L.Estado := Q.FieldByName('estado').AsString;
      L.Confianza := Q.FieldByName('confianza').AsString;
      L.Observaciones := Q.FieldByName('observaciones').AsString;
      L.Prioridad := Q.FieldByName('prioridad').AsFloat;
      L.MarcadoTemporada := Q.FieldByName('marcado_temporada').AsInteger <> 0;
      AddLinea(FLineasTodas, L);
      if (Length(FLineasTodas) mod 25) = 0 then
        ProgresoPaso('Cargando borrador... ' + IntToStr(Length(FLineasTodas)));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
  SepararLineas;
  PintarLineas(FLineasAuto, seMaxLineas.Value, 'Pedido temporada AUTO desde borrador');
  ProgresoFin('Borrador cargado. Auto=' + IntToStr(Length(FLineasAuto)) +
    ' Dudas=' + IntToStr(Length(FLineasDudas)) + ' Excluidos=' + IntToStr(Length(FLineasExcluidas)));
end;

procedure TfPedidoTemporadaAuto.BorrarUltimoBorrador;
var
  Q: TZQuery;
  IdBorrador, CodProv: Integer;
begin
  CodProv := CodigoProveedorSeleccionado;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT id FROM pedido_temporada_borrador_cab ' +
      'WHERE tienda=:T AND temporada=:TEMP AND (:P=0 OR cod_proveedor=:P) ORDER BY id DESC LIMIT 1';
    Q.ParamByName('T').AsString := FTienda;
    Q.ParamByName('TEMP').AsString := cbTemporada.Text;
    Q.ParamByName('P').AsInteger := CodProv;
    Q.Open;
    if Q.EOF then
    begin
      ShowMessage('No hay borrador para borrar.');
      Exit;
    end;
    IdBorrador := Q.FieldByName('id').AsInteger;
    Q.Close;
    if MessageDlg('Borrar borrador', 'Borrar el ultimo borrador de temporada?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
    Q.SQL.Text := 'DELETE FROM pedido_temporada_borrador_lin WHERE borrador_id=:B';
    Q.ParamByName('B').AsInteger := IdBorrador;
    Q.ExecSQL;
    Q.SQL.Text := 'DELETE FROM pedido_temporada_borrador_cab WHERE id=:B';
    Q.ParamByName('B').AsInteger := IdBorrador;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
  Log('Borrador temporada borrado: ' + IntToStr(IdBorrador));
  ShowMessage('Borrador borrado.');
end;

procedure TfPedidoTemporadaAuto.CargarProveedores;
var
  Q: TZQuery;
begin
  ProgresoInicio('Cargando proveedores...', 100);
  cbProveedor.Items.Clear;
  FListaProveedores.Clear;
  if (FConn = nil) or (not FConn.Connected) then
  begin
    ShowMessage('La conexion a la base de datos no esta activa.');
    Exit;
  end;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT P0, P1 FROM proveedores ORDER BY P1';
    Q.Open;
    while not Q.EOF do
    begin
      FListaProveedores.Add(Q.FieldByName('P0').AsString + ' - ' + Q.FieldByName('P1').AsString);
      if (FListaProveedores.Count mod 25) = 0 then
        ProgresoPaso('Cargando proveedores... ' + IntToStr(FListaProveedores.Count));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
  FiltrarProveedores('');
  ProgresoFin('Proveedores cargados: ' + IntToStr(cbProveedor.Items.Count));
end;

procedure TfPedidoTemporadaAuto.FiltrarProveedores(const Texto: string);
var
  I: Integer;
  T: string;
begin
  cbProveedor.Items.BeginUpdate;
  try
    cbProveedor.Items.Clear;
    T := UTF8UpperString(Trim(Texto));
    for I := 0 to FListaProveedores.Count - 1 do
      if (T = '') or (Pos(T, UTF8UpperString(FListaProveedores[I])) > 0) then
        cbProveedor.Items.Add(FListaProveedores[I]);
    if cbProveedor.Items.Count > 0 then cbProveedor.ItemIndex := 0;
  finally
    cbProveedor.Items.EndUpdate;
  end;
end;

function TfPedidoTemporadaAuto.CodigoProveedorSeleccionado: Integer;
var
  S: string;
  P: Integer;
begin
  Result := 0;
  if cbProveedor.ItemIndex < 0 then Exit;
  S := cbProveedor.Text;
  P := Pos(' - ', S);
  if P > 0 then S := Copy(S, 1, P - 1);
  Result := StrToIntDef(Trim(S), 0);
end;

function TfPedidoTemporadaAuto.NombreProveedorSeleccionado: string;
var
  S: string;
  P: Integer;
begin
  Result := '';
  if cbProveedor.ItemIndex < 0 then Exit;
  S := cbProveedor.Text;
  P := Pos(' - ', S);
  if P > 0 then Result := Copy(S, P + 3, Length(S)) else Result := S;
end;

function TfPedidoTemporadaAuto.ParseFechaISO(const S: string; out D: TDateTime): Boolean;
var
  Y, M, Day: Integer;
  T: string;
begin
  Result := False;
  D := 0;
  T := Trim(S);
  if Length(T) <> 10 then Exit;
  Y := StrToIntDef(Copy(T, 1, 4), 0);
  M := StrToIntDef(Copy(T, 6, 2), 0);
  Day := StrToIntDef(Copy(T, 9, 2), 0);
  Result := TryEncodeDate(Y, M, Day, D);
end;

function TfPedidoTemporadaAuto.FechaSQL(const Fecha: TDateTime): string;
begin
  Result := QuotedStr(FormatDateTime('yyyy-mm-dd', Fecha));
end;

function TfPedidoTemporadaAuto.FloatSeguro(const S: string; const Def: Double): Double;
var
  T: string;
begin
  T := StringReplace(Trim(S), '.', DecimalSeparator, [rfReplaceAll]);
  T := StringReplace(T, ',', DecimalSeparator, [rfReplaceAll]);
  Result := StrToFloatDef(T, Def);
end;

function TfPedidoTemporadaAuto.CSVSeguro(const S: string): string;
begin
  Result := '"' + StringReplace(S, '"', '""', [rfReplaceAll]) + '"';
end;

function TfPedidoTemporadaAuto.TextoPDFSeguro(const S: string): AnsiString;
var
  T, R: string;
  I: Integer;
  C: Char;
begin
  // PDF manual con fuente Helvetica basica: evitamos dependencias externas
  // como UTF8ToCP1252, que no existe en algunos Lazarus/FPC.
  // Convertimos los caracteres habituales a ASCII seguro.
  T := S;

  // Vocales y caracteres frecuentes en UTF-8, escritos como bytes ASCII-safe.
  T := StringReplace(T, #195#161, 'a', [rfReplaceAll]);
  T := StringReplace(T, #195#169, 'e', [rfReplaceAll]);
  T := StringReplace(T, #195#173, 'i', [rfReplaceAll]);
  T := StringReplace(T, #195#179, 'o', [rfReplaceAll]);
  T := StringReplace(T, #195#186, 'u', [rfReplaceAll]);
  T := StringReplace(T, #195#129, 'A', [rfReplaceAll]);
  T := StringReplace(T, #195#137, 'E', [rfReplaceAll]);
  T := StringReplace(T, #195#141, 'I', [rfReplaceAll]);
  T := StringReplace(T, #195#147, 'O', [rfReplaceAll]);
  T := StringReplace(T, #195#154, 'U', [rfReplaceAll]);
  T := StringReplace(T, #195#177, 'n', [rfReplaceAll]);
  T := StringReplace(T, #195#145, 'N', [rfReplaceAll]);
  T := StringReplace(T, #195#188, 'u', [rfReplaceAll]);
  T := StringReplace(T, #195#156, 'U', [rfReplaceAll]);
  T := StringReplace(T, #194#186, 'o', [rfReplaceAll]);
  T := StringReplace(T, #194#170, 'a', [rfReplaceAll]);
  T := StringReplace(T, #226#130#172, ' EUR ', [rfReplaceAll]);

  R := '';
  for I := 1 to Length(T) do
  begin
    C := T[I];
    if (Ord(C) >= 32) and (Ord(C) <= 126) then
      R := R + C
    else
      R := R + ' ';
  end;

  Result := AnsiString(R);
end;

function TfPedidoTemporadaAuto.EscPDF(const S: AnsiString): AnsiString;
var
  T: string;
begin
  T := string(S);
  T := StringReplace(T, '\', '\\', [rfReplaceAll]);
  T := StringReplace(T, '(', '\(', [rfReplaceAll]);
  T := StringReplace(T, ')', '\)', [rfReplaceAll]);
  Result := AnsiString(T);
end;

function TfPedidoTemporadaAuto.PDFNum(const V: Double): string;
var
  FS: TFormatSettings;
begin
  FS := DefaultFormatSettings;
  FS.DecimalSeparator := '.';
  Result := FloatToStrF(V, ffFixed, 12, 2, FS);
end;

function TfPedidoTemporadaAuto.HayDatosEnGrid: Boolean;
begin
  Result := (Grid.RowCount > 1) and (Trim(Grid.Cells[0, 1]) <> '');
end;

function TfPedidoTemporadaAuto.KeywordsSQL: string;
var
  I: Integer;
  K: string;
  L: TStringList;
begin
  Result := '';
  L := TStringList.Create;
  try
    for I := 0 to memoKeywords.Lines.Count - 1 do
    begin
      K := UTF8UpperString(Trim(memoKeywords.Lines[I]));
      K := StringReplace(K, '''', '''''', [rfReplaceAll]);
      if K <> '' then L.Add('UPPER(A.A1) LIKE ''%' + K + '%''');
    end;
    if L.Count > 0 then
      Result := '(' + StringReplace(Trim(L.Text), LineEnding, ' OR ', [rfReplaceAll]) + ')';
  finally
    L.Free;
  end;
end;

function TfPedidoTemporadaAuto.SQLComprasProveedor(const CodProveedor: Integer): string;
var
  TPedid, THiPedid, THiPedifa: string;
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
    Result := 'SELECT CODIGO, MAX(ULT_COMPRA) AS ULT_COMPRA, MAX(ULT_COSTE) AS ULT_COSTE FROM (' +
      StringReplace(Trim(L.Text), LineEnding, ' UNION ALL ', [rfReplaceAll]) + ') CP GROUP BY CODIGO';
  finally
    L.Free;
  end;
end;

function TfPedidoTemporadaAuto.SQLVentasEntre(const FechaDesde, FechaHasta: TDateTime;
  const AliasVentas: string): string;
var
  THis: string;
begin
  Result := '';
  THis := 'hisopdd' + FTienda;
  if not TablaExiste(THis) then Exit;
  Result := 'SELECT HOD6 AS CODIGO, SUM(CASE WHEN HOD8 > 0 THEN HOD8 ELSE 0 END) AS ' + AliasVentas +
    ', MAX(HOD0) AS ULT_' + AliasVentas + ' FROM `' + THis + '` WHERE HOD0 BETWEEN ' +
    FechaSQL(FechaDesde) + ' AND ' + FechaSQL(FechaHasta) +
    ' AND TRIM(HOD6) <> '''' GROUP BY HOD6';
end;

function TfPedidoTemporadaAuto.SQLTemporada(const CodProveedor: Integer;
  const FechaDesdeBase, FechaHastaBase, FechaDesdeActual, FechaHastaActual: TDateTime): string;
var
  TArti: string;
  ComprasSQL, VentasBaseSQL, VentasActualSQL, KW: string;
begin
  Result := '';
  TArti := 'artitien' + FTienda;
  if not TablaExiste(TArti) then
  begin
    ShowMessage('No existe la tabla de articulos: ' + TArti);
    Exit;
  end;
  ComprasSQL := SQLComprasProveedor(CodProveedor);
  if ComprasSQL = '' then
  begin
    ShowMessage('No encuentro pedidos/historico de compras para esta tienda.');
    Exit;
  end;
  VentasBaseSQL := SQLVentasEntre(FechaDesdeBase, FechaHastaBase, 'VENTAS_BASE');
  VentasActualSQL := SQLVentasEntre(FechaDesdeActual, FechaHastaActual, 'VENTAS_ACTUAL');
  KW := KeywordsSQL;

  Result := 'SELECT A.A0 AS CODIGO, A.A1 AS DESCRIPCION, A.A2 AS PVP, A.A3 AS IVA, ' +
    'A.A14 AS FAMILIA, A.A24 AS COSTE_FICHA, CP.ULT_COMPRA, CP.ULT_COSTE, ' +
    'CASE WHEN TA.codigo IS NULL THEN 0 ELSE 1 END AS MARCADO_TEMP, ';
  if VentasBaseSQL <> '' then
    Result := Result + 'COALESCE(VB.VENTAS_BASE,0) AS VENTAS_BASE, VB.ULT_VENTAS_BASE, '
  else
    Result := Result + '0 AS VENTAS_BASE, NULL AS ULT_VENTAS_BASE, ';
  if VentasActualSQL <> '' then
    Result := Result + 'COALESCE(VA.VENTAS_ACTUAL,0) AS VENTAS_ACTUAL, VA.ULT_VENTAS_ACTUAL '
  else
    Result := Result + '0 AS VENTAS_ACTUAL, NULL AS ULT_VENTAS_ACTUAL ';

  Result := Result + 'FROM (' + ComprasSQL + ') CP JOIN `' + TArti + '` A ON A.A0 = CP.CODIGO ' +
    'LEFT JOIN pedido_temporada_articulos TA ON TA.tienda = ' + QuotedStr(FTienda) +
    ' AND TA.temporada = ' + QuotedStr(cbTemporada.Text) + ' AND TA.codigo = A.A0 AND TA.activo = 1 ';
  if VentasBaseSQL <> '' then
    Result := Result + 'LEFT JOIN (' + VentasBaseSQL + ') VB ON VB.CODIGO = A.A0 ';
  if VentasActualSQL <> '' then
    Result := Result + 'LEFT JOIN (' + VentasActualSQL + ') VA ON VA.CODIGO = A.A0 ';
  if chkProveedorTemporada.Checked then
    Result := Result + 'WHERE 1=1 '
  else if KW <> '' then
    Result := Result + 'WHERE (TA.codigo IS NOT NULL OR ' + KW + ') '
  else
    Result := Result + 'WHERE TA.codigo IS NOT NULL ';
  Result := Result + 'ORDER BY A.A1';
end;

procedure TfPedidoTemporadaAuto.VaciarLineas;
begin
  SetLength(FLineasTodas, 0);
  SetLength(FLineasAuto, 0);
  SetLength(FLineasDudas, 0);
  SetLength(FLineasExcluidas, 0);
end;

procedure TfPedidoTemporadaAuto.AddLinea(var ALista: TArrayLineaTemporada; const L: TLineaTemporada);
var
  N: Integer;
begin
  N := Length(ALista);
  SetLength(ALista, N + 1);
  ALista[N] := L;
end;

procedure TfPedidoTemporadaAuto.OrdenarPorPrioridad(var ALista: TArrayLineaTemporada);
var
  I, J: Integer;
  T: TLineaTemporada;
begin
  for I := Low(ALista) to High(ALista) - 1 do
    for J := I + 1 to High(ALista) do
      if ALista[J].Prioridad > ALista[I].Prioridad then
      begin
        T := ALista[I];
        ALista[I] := ALista[J];
        ALista[J] := T;
      end;
end;

procedure TfPedidoTemporadaAuto.PintarLineas(const ALista: TArrayLineaTemporada;
  const Limite: Integer; const Titulo: string);
var
  I, R, MaxI: Integer;
begin
  InicializarGrid;
  if Length(ALista) = 0 then
  begin
    Grid.Rows[1].Clear;
    lblEstado.Caption := Titulo + ': 0 lineas';
    Exit;
  end;
  MaxI := High(ALista);
  if (Limite > 0) and (Limite - 1 < MaxI) then MaxI := Limite - 1;
  R := 1;
  for I := 0 to MaxI do
  begin
    if R >= Grid.RowCount then Grid.RowCount := Grid.RowCount + 1;
    Grid.Cells[0, R] := ALista[I].Codigo;
    Grid.Cells[1, R] := ALista[I].Descripcion;
    Grid.Cells[2, R] := FormatFloat('0.##', ALista[I].VentasBase);
    Grid.Cells[3, R] := FormatFloat('0.##', ALista[I].VentasActual);
    Grid.Cells[4, R] := FormatFloat('0.####', ALista[I].VentaDia);
    Grid.Cells[5, R] := FormatFloat('0.##', ALista[I].Sugerido);
    Grid.Cells[6, R] := FormatFloat('0.##', ALista[I].CantidadFinal);
    Grid.Cells[7, R] := ALista[I].Confianza;
    Grid.Cells[8, R] := ALista[I].UltCompra;
    Grid.Cells[9, R] := FormatFloat('0.000', ALista[I].Coste);
    Grid.Cells[10, R] := FormatFloat('0.00', ALista[I].PVP);
    Grid.Cells[11, R] := FormatFloat('0.##', ALista[I].IVA);
    Grid.Cells[12, R] := ALista[I].Familia;
    Grid.Cells[13, R] := ALista[I].Estado;
    Grid.Cells[14, R] := ALista[I].Observaciones;
    Inc(R);
  end;
  AutoAjustarColumnas;
  lblEstado.Caption := Titulo + ': ' + IntToStr(MaxI + 1) + ' lineas visibles';
end;

procedure TfPedidoTemporadaAuto.SepararLineas;
var
  I: Integer;
begin
  SetLength(FLineasAuto, 0);
  SetLength(FLineasDudas, 0);
  SetLength(FLineasExcluidas, 0);
  for I := 0 to High(FLineasTodas) do
  begin
    if (FLineasTodas[I].Confianza = 'ALTA') and (FLineasTodas[I].CantidadFinal > 0) then
      AddLinea(FLineasAuto, FLineasTodas[I])
    else if (FLineasTodas[I].Confianza = 'MEDIA') or (FLineasTodas[I].CantidadFinal > 0) then
      AddLinea(FLineasDudas, FLineasTodas[I])
    else
      AddLinea(FLineasExcluidas, FLineasTodas[I]);
  end;
end;

procedure TfPedidoTemporadaAuto.CalcularTemporada;
var
  CodProv: Integer;
  DesdeBase, HastaBase, DesdeActual, HastaActual: TDateTime;
  DiasBase: Integer;
  Factor: Double;
  SQL: string;
  Q: TZQuery;
  L: TLineaTemporada;
  BaseDia, ActualDia, Usada, AjusteModo: Double;
  N: Integer;
  Modo, ModoObs: string;
begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then
  begin
    ShowMessage('Selecciona proveedor.');
    Exit;
  end;
  if not ParseFechaISO(edtDesdeBase.Text, DesdeBase) or not ParseFechaISO(edtHastaBase.Text, HastaBase) then
  begin
    ShowMessage('Fechas base incorrectas. Usa formato AAAA-MM-DD.');
    Exit;
  end;
  if HastaBase < DesdeBase then
  begin
    ShowMessage('La fecha Hasta base no puede ser anterior a Desde base.');
    Exit;
  end;

  HastaActual := Date;
  DesdeActual := IncDay(HastaActual, -seDiasActual.Value + 1);
  DiasBase := Trunc(HastaBase) - Trunc(DesdeBase) + 1;
  Factor := FloatSeguro(edtFactor.Text, 1.20);
  Modo := ModoTemporadaSeleccionado;

  if chkProveedorTemporada.Checked then
    ProgresoInicio('Calculando temporada por proveedor completo...', 100)
  else
    ProgresoInicio('Calculando temporada...', 100);
  VaciarLineas;
  SQL := SQLTemporada(CodProv, DesdeBase, HastaBase, DesdeActual, HastaActual);
  if SQL = '' then Exit;
  if chkProveedorTemporada.Checked then
    Log('Calculo temporada por proveedor completo. Proveedor=' + IntToStr(CodProv) + ' temporada=' + cbTemporada.Text)
  else
    Log('Calculo temporada por palabras/guardados. Proveedor=' + IntToStr(CodProv) + ' temporada=' + cbTemporada.Text);

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := SQL;
    Q.Open;
    N := 0;
    while not Q.EOF do
    begin
      Inc(N);
      if (N mod 25) = 0 then
        ProgresoPaso('Calculando temporada... ' + IntToStr(N) + ' articulos');
      FillChar(L, SizeOf(L), 0);
      L.Codigo := Q.FieldByName('CODIGO').AsString;
      L.Descripcion := Q.FieldByName('DESCRIPCION').AsString;
      L.VentasBase := Q.FieldByName('VENTAS_BASE').AsFloat;
      L.VentasActual := Q.FieldByName('VENTAS_ACTUAL').AsFloat;
      L.MarcadoTemporada := Q.FieldByName('MARCADO_TEMP').AsInteger <> 0;
      L.UltVentaBase := Q.FieldByName('ULT_VENTAS_BASE').AsString;
      L.UltVentaActual := Q.FieldByName('ULT_VENTAS_ACTUAL').AsString;
      L.UltCompra := Q.FieldByName('ULT_COMPRA').AsString;
      L.Coste := Q.FieldByName('ULT_COSTE').AsFloat;
      if L.Coste <= 0 then L.Coste := Q.FieldByName('COSTE_FICHA').AsFloat;
      L.PVP := Q.FieldByName('PVP').AsFloat;
      L.IVA := Q.FieldByName('IVA').AsFloat;
      L.Familia := Q.FieldByName('FAMILIA').AsString;

      BaseDia := 0;
      if DiasBase > 0 then BaseDia := L.VentasBase / DiasBase;
      ActualDia := 0;
      if seDiasActual.Value > 0 then ActualDia := L.VentasActual / seDiasActual.Value;
      AjusteModo := 1.0;
      Usada := BaseDia;
      ModoObs := 'Modo pretemporada: usa principalmente la venta de la temporada base anterior.';

      if Modo = 'REPOSICION' then
      begin
        Usada := BaseDia;
        if chkUsarActual.Checked and (ActualDia > BaseDia) then
          Usada := (BaseDia * 0.65) + (ActualDia * 0.35);
        ModoObs := 'Modo reposicion: mezcla temporada anterior con tendencia actual si acelera.';
      end
      else if Modo = 'FINAL TEMPORADA' then
      begin
        AjusteModo := 0.70;
        if chkUsarActual.Checked and (ActualDia > 0) then
          Usada := (BaseDia * 0.35) + (ActualDia * 0.65)
        else
          Usada := BaseDia * 0.25;
        ModoObs := 'Modo final temporada: reduce propuesta y prioriza venta actual para evitar exceso.';
      end
      else
      begin
        Usada := BaseDia;
        if chkUsarActual.Checked and (ActualDia > BaseDia * 1.50) then
          Usada := (BaseDia * 0.80) + (ActualDia * 0.20);
      end;

      L.VentaDia := Usada;
      L.Sugerido := Ceil(Max(0.0, Usada * seDiasCubrir.Value * Factor * AjusteModo));
      L.CantidadFinal := L.Sugerido;

      L.Estado := 'TEMPORADA';
      L.Confianza := 'MEDIA';
      if (L.MarcadoTemporada and (L.Sugerido > 0)) or (L.VentasBase >= 3) then
        L.Confianza := 'ALTA';
      if (L.Coste <= 0) or (L.PVP >= 999) then
        L.Confianza := 'MEDIA';
      if (L.Sugerido <= 0) and (not L.MarcadoTemporada) then
      begin
        L.Confianza := 'BAJA';
        L.Estado := 'CANDIDATO SIN VENTA';
      end;
      if (Modo = 'FINAL TEMPORADA') and (L.VentasActual <= 0) and (not L.MarcadoTemporada) then
      begin
        L.Confianza := 'BAJA';
        L.CantidadFinal := 0;
        L.Estado := 'FINAL SIN VENTA ACTUAL';
      end;
      if L.MarcadoTemporada then
        L.Observaciones := 'Articulo guardado en temporada. '
      else if chkProveedorTemporada.Checked then
        L.Observaciones := 'Incluido por proveedor de temporada. '
      else
        L.Observaciones := 'Detectado por palabra clave. ';
      L.Observaciones := L.Observaciones + ModoObs + ' Base ' + FormatFloat('0.##', L.VentasBase) +
        ' uds entre ' + edtDesdeBase.Text + ' y ' + edtHastaBase.Text +
        '; actual ' + FormatFloat('0.##', L.VentasActual) + ' uds ultimos ' +
        IntToStr(seDiasActual.Value) + ' dias; formula ' + FormatFloat('0.####', Usada) +
        '/dia x ' + IntToStr(seDiasCubrir.Value) + ' dias x factor ' +
        FormatFloat('0.##', Factor) + ' = ' + FormatFloat('0.##', L.Sugerido) + '.';
      L.Prioridad := (L.Sugerido * 10) + (L.VentasActual * 2) + L.VentasBase;
      if L.MarcadoTemporada then L.Prioridad := L.Prioridad + 1000;
      AddLinea(FLineasTodas, L);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
  OrdenarPorPrioridad(FLineasTodas);
  SepararLineas;
  PintarLineas(FLineasAuto, seMaxLineas.Value, 'Pedido temporada AUTO');
  ProgresoFin('Temporada calculada. Auto=' + IntToStr(Length(FLineasAuto)) +
    ' Dudas=' + IntToStr(Length(FLineasDudas)) + ' Excluidos=' + IntToStr(Length(FLineasExcluidas)));
end;

procedure TfPedidoTemporadaAuto.GuardarArticulosTemporadaVisibles;
var
  Q: TZQuery;
  R, N: Integer;
begin
  if not HayDatosEnGrid then
  begin
    ShowMessage('No hay lineas visibles para guardar como temporada.');
    Exit;
  end;
  if MessageDlg('Guardar temporada',
    'Se guardaran los articulos visibles como parte de la temporada ' + cbTemporada.Text + '. Continuar?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  ProgresoInicio('Guardando articulos de temporada...', Grid.RowCount - 1);
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    N := 0;
    for R := 1 to Grid.RowCount - 1 do
      if Trim(Grid.Cells[0, R]) <> '' then
      begin
        Inc(N);
        Q.SQL.Text := 'REPLACE INTO pedido_temporada_articulos ' +
          '(tienda, temporada, codigo, activo, principal, observacion) VALUES ' +
          '(:T,:TEMP,:COD,1,0,:OBS)';
        Q.ParamByName('T').AsString := FTienda;
        Q.ParamByName('TEMP').AsString := cbTemporada.Text;
        Q.ParamByName('COD').AsString := Grid.Cells[0, R];
        Q.ParamByName('OBS').AsString := 'Guardado desde pantalla temporada';
        Q.ExecSQL;
        if (N mod 20) = 0 then ProgresoPaso('Guardando articulos... ' + IntToStr(N), N, Grid.RowCount - 1);
      end;
  finally
    Q.Free;
  end;
  ProgresoFin('Articulos guardados en temporada: ' + IntToStr(N));
  ShowMessage('Articulos visibles guardados en temporada: ' + IntToStr(N));
end;

procedure TfPedidoTemporadaAuto.IncluirCodigoTemporada(const ACodigo, AObs: string);
var
  Q: TZQuery;
  Cod: string;
begin
  Cod := Trim(ACodigo);
  if Cod = '' then
  begin
    ShowMessage('Indica un codigo de articulo o selecciona una linea del grid.');
    Exit;
  end;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'REPLACE INTO pedido_temporada_articulos ' +
      '(tienda, temporada, codigo, activo, principal, observacion) VALUES ' +
      '(:T,:TEMP,:COD,1,0,:OBS)';
    Q.ParamByName('T').AsString := FTienda;
    Q.ParamByName('TEMP').AsString := cbTemporada.Text;
    Q.ParamByName('COD').AsString := Cod;
    Q.ParamByName('OBS').AsString := AObs;
    Q.ExecSQL;
    Log('Codigo incluido manualmente en temporada ' + cbTemporada.Text + ': ' + Cod);
    ShowMessage('Codigo incluido en temporada: ' + Cod);
  finally
    Q.Free;
  end;
end;


procedure TfPedidoTemporadaAuto.GuardarCodigoTemporadaSilencioso(const ACodigo, AObs: string);
var
  Q: TZQuery;
  Cod: string;
begin
  Cod := Trim(ACodigo);
  if Cod = '' then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'REPLACE INTO pedido_temporada_articulos ' +
      '(tienda, temporada, codigo, activo, principal, observacion) VALUES ' +
      '(:T,:TEMP,:COD,1,0,:OBS)';
    Q.ParamByName('T').AsString := FTienda;
    Q.ParamByName('TEMP').AsString := cbTemporada.Text;
    Q.ParamByName('COD').AsString := Cod;
    Q.ParamByName('OBS').AsString := AObs;
    Q.ExecSQL;
    Log('Codigo guardado silenciosamente en temporada ' + cbTemporada.Text + ': ' + Cod);
  finally
    Q.Free;
  end;
end;

function TfPedidoTemporadaAuto.CodigoGridSeleccionado: string;
begin
  Result := '';
  if (Grid.Row > 0) and (Grid.Row < Grid.RowCount) then
    Result := Trim(Grid.Cells[0, Grid.Row]);
end;

procedure TfPedidoTemporadaAuto.MarcarLineaSeleccionada(const NuevaConfianza, NuevoEstado, ObsExtra: string);
var
  Cod: string;
  I: Integer;
  Encontrado: Boolean;
  FinalGrid, SugGrid: Double;
begin
  Cod := CodigoGridSeleccionado;
  if Cod = '' then
  begin
    ShowMessage('Selecciona una linea del grid.');
    Exit;
  end;

  Encontrado := False;
  FinalGrid := 0;
  SugGrid := 0;
  if (Grid.Row > 0) and (Grid.Row < Grid.RowCount) then
  begin
    SugGrid := FloatSeguro(Grid.Cells[5, Grid.Row], 0);
    FinalGrid := FloatSeguro(Grid.Cells[6, Grid.Row], 0);
  end;

  for I := 0 to High(FLineasTodas) do
    if SameText(Trim(FLineasTodas[I].Codigo), Cod) then
    begin
      Encontrado := True;
      FLineasTodas[I].Confianza := NuevaConfianza;
      FLineasTodas[I].Estado := NuevoEstado;
      if SugGrid > 0 then FLineasTodas[I].Sugerido := SugGrid;
      if FinalGrid > 0 then FLineasTodas[I].CantidadFinal := FinalGrid;
      if NuevaConfianza = 'BAJA' then
        FLineasTodas[I].CantidadFinal := 0;
      if NuevaConfianza = 'ALTA' then
      begin
        FLineasTodas[I].MarcadoTemporada := True;
        // Si la linea venia de EXCLUIDOS normalmente tenia cantidad final 0.
        // Para que pueda aparecer en "Ver auto" debe tener cantidad final > 0.
        // Usamos el sugerido si existe; si tampoco hay sugerido, dejamos 1 unidad
        // como cantidad minima revisable y editable por el usuario.
        if FLineasTodas[I].CantidadFinal <= 0 then
        begin
          if FLineasTodas[I].Sugerido > 0 then
            FLineasTodas[I].CantidadFinal := FLineasTodas[I].Sugerido
          else
            FLineasTodas[I].CantidadFinal := 1;
        end;
        GuardarCodigoTemporadaSilencioso(Cod, 'Aceptado como correcto desde pedido temporada');
      end;
      FLineasTodas[I].Observaciones := Trim(FLineasTodas[I].Observaciones + ' ' + ObsExtra);
      Break;
    end;

  if not Encontrado then
  begin
    ShowMessage('No encuentro el codigo en el estudio actual: ' + Cod);
    Exit;
  end;

  SepararLineas;
  Log('Linea temporada marcada: codigo=' + Cod + ' confianza=' + NuevaConfianza + ' estado=' + NuevoEstado);

  if NuevaConfianza = 'ALTA' then
    PintarLineas(FLineasAuto, seMaxLineas.Value, 'Pedido temporada AUTO')
  else if NuevaConfianza = 'MEDIA' then
    PintarLineas(FLineasDudas, seMaxLineas.Value, 'Dudas temporada')
  else
    PintarLineas(FLineasExcluidas, seMaxLineas.Value, 'Excluidos temporada');
end;

procedure TfPedidoTemporadaAuto.QuitarCodigoTemporada(const ACodigo: string);
var
  Q: TZQuery;
  Cod: string;
begin
  Cod := Trim(ACodigo);
  if Cod = '' then
  begin
    ShowMessage('Indica un codigo de articulo o selecciona una linea del grid.');
    Exit;
  end;
  if MessageDlg('Quitar de temporada', 'Quitar el codigo ' + Cod + ' de la temporada ' +
    cbTemporada.Text + '?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'UPDATE pedido_temporada_articulos SET activo=0, observacion=:OBS ' +
      'WHERE tienda=:T AND temporada=:TEMP AND codigo=:COD';
    Q.ParamByName('T').AsString := FTienda;
    Q.ParamByName('TEMP').AsString := cbTemporada.Text;
    Q.ParamByName('COD').AsString := Cod;
    Q.ParamByName('OBS').AsString := 'Desactivado desde pantalla temporada';
    Q.ExecSQL;
    Log('Codigo quitado manualmente de temporada ' + cbTemporada.Text + ': ' + Cod);
    ShowMessage('Codigo quitado de temporada: ' + Cod);
  finally
    Q.Free;
  end;
end;

procedure TfPedidoTemporadaAuto.VerArticulosTemporadaGuardados;
var
  Q: TZQuery;
  TArti: string;
  L: TLineaTemporada;
  N: Integer;
begin
  TArti := 'artitien' + FTienda;
  if not TablaExiste(TArti) then
  begin
    ShowMessage('No existe la tabla de articulos: ' + TArti);
    Exit;
  end;
  ProgresoInicio('Cargando articulos guardados de temporada...', 100);
  VaciarLineas;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT TA.codigo, COALESCE(A.A1,'''') AS DESCRIPCION, ' +
      'COALESCE(A.A2,0) AS PVP, COALESCE(A.A3,0) AS IVA, COALESCE(A.A14,'''') AS FAMILIA, ' +
      'COALESCE(A.A24,0) AS COSTE, TA.observacion ' +
      'FROM pedido_temporada_articulos TA LEFT JOIN `' + TArti + '` A ON A.A0 = TA.codigo ' +
      'WHERE TA.tienda=:T AND TA.temporada=:TEMP AND TA.activo=1 ORDER BY A.A1, TA.codigo';
    Q.ParamByName('T').AsString := FTienda;
    Q.ParamByName('TEMP').AsString := cbTemporada.Text;
    Q.Open;
    N := 0;
    while not Q.EOF do
    begin
      Inc(N);
      FillChar(L, SizeOf(L), 0);
      L.Codigo := Q.FieldByName('codigo').AsString;
      L.Descripcion := Q.FieldByName('DESCRIPCION').AsString;
      L.PVP := Q.FieldByName('PVP').AsFloat;
      L.IVA := Q.FieldByName('IVA').AsFloat;
      L.Coste := Q.FieldByName('COSTE').AsFloat;
      L.Familia := Q.FieldByName('FAMILIA').AsString;
      L.MarcadoTemporada := True;
      L.Estado := 'GUARDADO TEMPORADA';
      L.Confianza := 'ALTA';
      L.Observaciones := 'Articulo incluido manualmente/guardado en temporada. ' +
        Q.FieldByName('observacion').AsString;
      AddLinea(FLineasTodas, L);
      if (N mod 25) = 0 then ProgresoPaso('Cargando guardados... ' + IntToStr(N));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
  SepararLineas;
  PintarLineas(FLineasTodas, seMaxLineas.Value, 'Articulos guardados temporada');
  ProgresoFin('Articulos guardados de temporada: ' + IntToStr(Length(FLineasTodas)));
end;

function TfPedidoTemporadaAuto.EsColumnaNumerica(const Col: Integer): Boolean;
begin
  Result := Col in [2,3,4,5,6,9,10,11,12];
end;

function TfPedidoTemporadaAuto.CompararCeldas(const A, B: string; const Col: Integer): Integer;
var
  FA, FB: Double;
begin
  if EsColumnaNumerica(Col) then
  begin
    FA := FloatSeguro(A, 0);
    FB := FloatSeguro(B, 0);
    if FA < FB then Result := -1 else if FA > FB then Result := 1 else Result := 0;
  end
  else
    Result := CompareText(A, B);
end;

procedure TfPedidoTemporadaAuto.OrdenarGridPorColumna(const Col: Integer; const Ascendente: Boolean);
var
  I, J, C: Integer;
  Tmp: TStringList;
  Cmp: Integer;
begin
  if not HayDatosEnGrid then Exit;
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
    for C := 0 to Grid.ColCount - 1 do
      Grid.Cells[C, 0] := StringReplace(StringReplace(Grid.Cells[C, 0], ' ^', '', []), ' v', '', []);
    if Ascendente then Grid.Cells[Col, 0] := Grid.Cells[Col, 0] + ' ^'
    else Grid.Cells[Col, 0] := Grid.Cells[Col, 0] + ' v';
  finally
    Tmp.Free;
  end;
end;

procedure TfPedidoTemporadaAuto.AutoAjustarColumnas;
begin
  // Mantener columnas principales legibles sin recalcular cada celda para evitar lentitud.
  Grid.ColWidths[1] := 360;
  Grid.ColWidths[14] := 560;
end;

procedure TfPedidoTemporadaAuto.GenerarPDFDesdeGrid(const NombreFichero: string);
type
  TColWidthsPDF = array[0..14] of Double;
var
  BaseW: TColWidthsPDF;
  PageW, PageH, Margin, TitleH, HeaderH, RowH: Double;
  FontSize, HeaderFontSize, Scale, TotalBase: Double;
  RowsPerPage, PageCount, CurRow, PageNum: Integer;
  Objects: array of AnsiString;
  Offsets: array of Integer;
  Kids: AnsiString;

  function AddObject(const Body: AnsiString): Integer;
  begin
    SetLength(Objects, Length(Objects) + 1);
    Objects[High(Objects)] := Body;
    Result := Length(Objects);
  end;

  procedure AddCmd(var C: AnsiString; const Cmd: AnsiString);
  begin
    C := C + Cmd + #10;
  end;

  function PdfCellText(const Txt: string): AnsiString;
  begin
    Result := EscPDF(TextoPDFSeguro(Txt));
  end;

  procedure AddText(var C: AnsiString; const X, TopY, Size: Double;
    const Txt: string);
  var
    BY: Double;
  begin
    BY := PageH - TopY - Size;
    AddCmd(C, 'BT /F1 ' + AnsiString(PDFNum(Size)) + ' Tf ' +
      AnsiString(PDFNum(X)) + ' ' + AnsiString(PDFNum(BY)) +
      ' Td (' + PdfCellText(Txt) + ') Tj ET');
  end;

  procedure AddCell(var C: AnsiString; const X, TopY, W, H: Double;
    const Txt: string; const IsHeader: Boolean);
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

    AddCmd(C, '0.30 w');
    AddCmd(C, AnsiString(PDFNum(X)) + ' ' + AnsiString(PDFNum(BY)) + ' ' +
      AnsiString(PDFNum(W)) + ' ' + AnsiString(PDFNum(H)) + ' re S');

    // Clip por celda: evita que descripciones/observaciones largas invadan columnas.
    AddCmd(C, 'q');
    AddCmd(C, AnsiString(PDFNum(X + 1)) + ' ' + AnsiString(PDFNum(BY + 1)) + ' ' +
      AnsiString(PDFNum(W - 2)) + ' ' + AnsiString(PDFNum(H - 2)) + ' re W n');
    AddText(C, X + 2, TopY + 4, SizeUse, Txt);
    AddCmd(C, 'Q');
  end;

  function BuildPage(const StartRow, EndRow, APage, APageCount: Integer): AnsiString;
  var
    C: AnsiString;
    X, Y: Double;
    R, Col: Integer;
  begin
    C := '';
    AddCmd(C, '0 0 0 rg');
    AddText(C, Margin, Margin, 11, 'Pedido temporada - ' + cbTemporada.Text);
    AddText(C, Margin, Margin + 14, 7,
      'Proveedor: ' + cbProveedor.Text + '   Base: ' + edtDesdeBase.Text + ' a ' + edtHastaBase.Text +
      '   Generado: ' + FormatDateTime('dd/mm/yyyy hh:nn', Now) +
      '   Pagina ' + IntToStr(APage) + ' de ' + IntToStr(APageCount));

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
    XRefPos, I: Integer;

    procedure AddPDF(const S: AnsiString);
    begin
      PDF := PDF + S;
    end;

    function Pad10(const N: Integer): AnsiString;
    begin
      Result := AnsiString(Format('%.10d', [N]));
    end;

  begin
    PDF := '%PDF-1.4'#10 + '%FacturLinEx pedido temporada'#10;
    SetLength(Offsets, Length(Objects) + 1);
    for I := 0 to High(Objects) do
    begin
      Offsets[I + 1] := Length(PDF);
      AddPDF(AnsiString(IntToStr(I + 1)) + ' 0 obj'#10 + Objects[I] + #10'endobj'#10);
    end;
    XRefPos := Length(PDF);
    AddPDF('xref'#10'0 ' + AnsiString(IntToStr(Length(Objects) + 1)) + #10);
    AddPDF('0000000000 65535 f '#10);
    for I := 1 to Length(Objects) do
      AddPDF(Pad10(Offsets[I]) + ' 00000 n '#10);
    AddPDF('trailer'#10'<< /Size ' + AnsiString(IntToStr(Length(Objects) + 1)) +
      ' /Root 1 0 R >>'#10'startxref'#10 + AnsiString(IntToStr(XRefPos)) + #10'%%EOF'#10);

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
  ContentObj, PageObj: Integer;
  StartR, EndR, P, Col: Integer;
begin
  if not HayDatosEnGrid then
    raise Exception.Create('No hay datos para generar PDF.');

  PageW := 842;  // A4 horizontal
  PageH := 595;
  Margin := 16;
  TitleH := 34;
  HeaderH := 17;
  RowH := 15;
  FontSize := 5.7;
  HeaderFontSize := 5.5;

  BaseW[0] := 38;   // Codigo
  BaseW[1] := 120;  // Descripcion
  BaseW[2] := 36;   // Vend. base
  BaseW[3] := 36;   // Vend. actual
  BaseW[4] := 34;   // Venta/dia
  BaseW[5] := 32;   // Sugerido
  BaseW[6] := 35;   // Cantidad final
  BaseW[7] := 38;   // Confianza
  BaseW[8] := 42;   // Ult. compra
  BaseW[9] := 30;   // Coste
  BaseW[10] := 30;  // PVP
  BaseW[11] := 22;  // IVA
  BaseW[12] := 28;  // Familia
  BaseW[13] := 55;  // Estado
  BaseW[14] := 130; // Observaciones

  TotalBase := 0;
  for Col := 0 to High(BaseW) do
    TotalBase := TotalBase + BaseW[Col];
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
    if EndR > Grid.RowCount - 1 then EndR := Grid.RowCount - 1;

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

function TfPedidoTemporadaAuto.AbrirFichero(const NombreFichero: string): Boolean;
var
  P: TProcess;
  I: Integer;
  Programas: array[0..6] of string = ('xdg-open', 'gio', 'atril', 'evince', 'xreader', 'okular', 'qpdfview');
begin
  Result := False;
  try
    Result := OpenDocument(NombreFichero);
    if Result then Exit;
  except
    Result := False;
  end;

  for I := Low(Programas) to High(Programas) do
  begin
    P := TProcess.Create(nil);
    try
      P.Options := [];
      P.Executable := Programas[I];
      if Programas[I] = 'gio' then
        P.Parameters.Add('open');
      P.Parameters.Add(NombreFichero);
      try
        P.Execute;
        Result := True;
        Exit;
      except
        Result := False;
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TfPedidoTemporadaAuto.ImprimirGrid;
type
  TColWidthsPrint = array[0..14] of Integer;
var
  BaseW, ColW: TColWidthsPrint;
  TotalBase, Col, R, X, Y: Integer;
  Scale: Double;
  MarginX, MarginY, TitleH, HeaderH, RowH: Integer;
  RowsPerPage, CurRow, EndRow, PageNum: Integer;
  TxtRect: TRect;

  procedure DrawCell(const AX, AY, AW, AH: Integer; const S: string; const IsHeader: Boolean);
  var
    OldColor: TColor;
  begin
    OldColor := Printer.Canvas.Brush.Color;
    if IsHeader then Printer.Canvas.Brush.Color := clSilver
    else Printer.Canvas.Brush.Color := clWhite;
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
    Printer.Canvas.TextOut(MarginX, MarginY, 'Pedido temporada - ' + cbTemporada.Text);
    Printer.Canvas.Font.Size := 7;
    Printer.Canvas.Font.Style := [];
    Printer.Canvas.TextOut(MarginX, MarginY + Printer.Canvas.TextHeight('Ag') + 4,
      'Proveedor: ' + cbProveedor.Text + '   Base: ' + edtDesdeBase.Text + ' a ' + edtHastaBase.Text +
      '   Generado: ' + DateTimeToStr(Now) + '   Pagina ' + IntToStr(PageNum));
  end;

begin
  if not HayDatosEnGrid then
    raise Exception.Create('No hay datos para imprimir.');

  BaseW[0] := 38; BaseW[1] := 120; BaseW[2] := 36; BaseW[3] := 36; BaseW[4] := 34;
  BaseW[5] := 32; BaseW[6] := 35; BaseW[7] := 38; BaseW[8] := 42; BaseW[9] := 30;
  BaseW[10] := 30; BaseW[11] := 22; BaseW[12] := 28; BaseW[13] := 55; BaseW[14] := 130;

  TotalBase := 0;
  for Col := 0 to High(BaseW) do Inc(TotalBase, BaseW[Col]);

  Printer.Orientation := poLandscape;
  Printer.Title := 'Pedido temporada';
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
      if PageNum > 1 then Printer.NewPage;
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
      if EndRow > Grid.RowCount - 1 then EndRow := Grid.RowCount - 1;
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

procedure TfPedidoTemporadaAuto.BtnCerrarClick(Sender: TObject);
begin
  try
    GuardarKeywordsTemporada;
  except
    on E: Exception do Log('ERROR guardando palabras clave al cerrar: ' + E.Message);
  end;
  Close;
end;

procedure TfPedidoTemporadaAuto.BtnLimpiarProveedorClick(Sender: TObject);
begin
  edtBuscarProveedor.Text := '';
  FiltrarProveedores('');
end;

procedure TfPedidoTemporadaAuto.EdtBuscarProveedorChange(Sender: TObject);
begin
  FiltrarProveedores(edtBuscarProveedor.Text);
end;

procedure TfPedidoTemporadaAuto.BtnDetectarClick(Sender: TObject);
begin
  CalcularTemporada;
  PintarLineas(FLineasTodas, seMaxLineas.Value, 'Candidatos temporada');
end;

procedure TfPedidoTemporadaAuto.BtnCalcularClick(Sender: TObject);
begin
  CalcularTemporada;
end;

procedure TfPedidoTemporadaAuto.BtnVerAutoClick(Sender: TObject);
begin
  PintarLineas(FLineasAuto, seMaxLineas.Value, 'Pedido temporada AUTO');
end;

procedure TfPedidoTemporadaAuto.BtnVerCompraClick(Sender: TObject);
var
  I: Integer;
  LCompra: TArrayLineaTemporada;
begin
  // Actualiza cambios manuales del grid antes de filtrar.
  SincronizarGridAFLineasTodas;
  SepararLineas;

  SetLength(LCompra, 0);
  for I := 0 to High(FLineasTodas) do
    if FLineasTodas[I].CantidadFinal > 0 then
      AddLinea(LCompra, FLineasTodas[I]);

  OrdenarPorPrioridad(LCompra);
  PintarLineas(LCompra, seMaxLineas.Value, 'Pedido temporada COMPRA');
end;

procedure TfPedidoTemporadaAuto.BtnVerDudasClick(Sender: TObject);
begin
  PintarLineas(FLineasDudas, seMaxLineas.Value, 'Dudas temporada');
end;

procedure TfPedidoTemporadaAuto.BtnVerExcluidosClick(Sender: TObject);
begin
  PintarLineas(FLineasExcluidas, seMaxLineas.Value, 'Excluidos temporada');
end;


procedure TfPedidoTemporadaAuto.BtnAceptarLineaClick(Sender: TObject);
begin
  MarcarLineaSeleccionada('ALTA', 'ACEPTADO MANUAL', '[Aceptado manualmente como correcto.]');
end;

procedure TfPedidoTemporadaAuto.BtnRevisarLineaClick(Sender: TObject);
begin
  MarcarLineaSeleccionada('MEDIA', 'REVISAR MANUAL', '[Marcado manualmente para revisar.]');
end;

procedure TfPedidoTemporadaAuto.BtnExcluirLineaClick(Sender: TObject);
begin
  MarcarLineaSeleccionada('BAJA', 'EXCLUIDO MANUAL', '[Excluido manualmente del pedido de temporada.]');
end;

procedure TfPedidoTemporadaAuto.BtnGuardarTemporadaClick(Sender: TObject);
begin
  GuardarArticulosTemporadaVisibles;
end;

procedure TfPedidoTemporadaAuto.BtnIncluirManualClick(Sender: TObject);
var
  Cod: string;
begin
  Cod := Trim(edtCodigoManual.Text);
  if (Cod = '') and (Grid.Row > 0) then
    Cod := Trim(Grid.Cells[0, Grid.Row]);
  IncluirCodigoTemporada(Cod, 'Incluido manualmente desde pantalla temporada');
end;

procedure TfPedidoTemporadaAuto.BtnQuitarManualClick(Sender: TObject);
var
  Cod: string;
begin
  Cod := Trim(edtCodigoManual.Text);
  if (Cod = '') and (Grid.Row > 0) then
    Cod := Trim(Grid.Cells[0, Grid.Row]);
  QuitarCodigoTemporada(Cod);
end;

procedure TfPedidoTemporadaAuto.BtnVerGuardadosClick(Sender: TObject);
begin
  VerArticulosTemporadaGuardados;
end;

procedure TfPedidoTemporadaAuto.BtnCSVClick(Sender: TObject);
var
  SL: TStringList;
  R, C: Integer;
  Linea: string;
  FN: string;
begin
  if not HayDatosEnGrid then
  begin
    ShowMessage('No hay datos para exportar.');
    Exit;
  end;
  FN := GetTempDir(False) + 'pedido_temporada_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.csv';
  SL := TStringList.Create;
  try
    for R := 0 to Grid.RowCount - 1 do
    begin
      Linea := '';
      for C := 0 to Grid.ColCount - 1 do
      begin
        if C > 0 then Linea := Linea + ';';
        Linea := Linea + CSVSeguro(Grid.Cells[C,R]);
      end;
      SL.Add(Linea);
    end;
    SL.SaveToFile(FN);
  finally
    SL.Free;
  end;
  Log('CSV generado: ' + FN);
  ShowMessage('CSV generado:' + LineEnding + FN);
end;

procedure TfPedidoTemporadaAuto.BtnPDFClick(Sender: TObject);
var
  FN: string;
begin
  if not HayDatosEnGrid then
  begin
    ShowMessage('No hay datos para PDF.');
    Exit;
  end;
  FN := GetTempDir(False) + 'pedido_temporada_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.pdf';
  try
    ProgresoInicio('Generando PDF...', Grid.RowCount - 1);
    GenerarPDFDesdeGrid(FN);
    ProgresoFin('PDF generado: ' + FN);
    if chkAbrirPDF.Checked then AbrirFichero(FN);
  except
    on E: Exception do
    begin
      Log('ERROR generando PDF: ' + E.Message);
      ShowMessage('Error generando PDF: ' + E.Message);
    end;
  end;
end;

procedure TfPedidoTemporadaAuto.BtnImprimirClick(Sender: TObject);
begin
  try
    ImprimirGrid;
  except
    on E: Exception do
    begin
      Log('ERROR imprimiendo: ' + E.Message);
      ShowMessage('Error imprimiendo: ' + E.Message);
    end;
  end;
end;

procedure TfPedidoTemporadaAuto.BtnOrdenTiendaClick(Sender: TObject);
begin
  OrdenarGridPorColumna(12, True);
end;



procedure TfPedidoTemporadaAuto.BtnCompararTempAntClick(Sender: TObject);
var
  I, NBase, NAuto, NDudas, NExcl, NNuevos, NAvisos: Integer;
  TotalBase, TotalActual, TotalFinal: Double;
  SL: TStringList;
  L: TLineaTemporada;
  Linea: string;
begin
  if Length(FLineasTodas) = 0 then
  begin
    if HayDatosEnGrid then SincronizarGridAFLineasTodas;
    if Length(FLineasTodas) = 0 then
    begin
      ShowMessage('No hay estudio para comparar. Pulsa primero Calcular temp. o carga un borrador.');
      Exit;
    end;
  end;

  NBase := 0; NAuto := 0; NDudas := 0; NExcl := 0; NNuevos := 0;
  TotalBase := 0; TotalActual := 0; TotalFinal := 0;
  SL := TStringList.Create;
  try
    SL.Add('Comparativa temporada anterior - ' + cbTemporada.Text);
    SL.Add('Modo: ' + cbModo.Text);
    SL.Add('Base: ' + edtDesdeBase.Text + ' a ' + edtHastaBase.Text);
    SL.Add('');

    for I := 0 to High(FLineasTodas) do
    begin
      L := FLineasTodas[I];
      TotalBase := TotalBase + L.VentasBase;
      TotalActual := TotalActual + L.VentasActual;
      TotalFinal := TotalFinal + L.CantidadFinal;
      if L.VentasBase > 0 then Inc(NBase);
      if (L.Confianza = 'ALTA') and (L.CantidadFinal > 0) then Inc(NAuto)
      else if (L.Confianza = 'MEDIA') or (L.CantidadFinal > 0) then Inc(NDudas)
      else Inc(NExcl);
      if (L.VentasBase <= 0) and (L.CantidadFinal > 0) then Inc(NNuevos);
    end;

    SL.Add('Lineas con venta en base anterior: ' + IntToStr(NBase));
    SL.Add('Lineas AUTO actuales: ' + IntToStr(NAuto));
    SL.Add('Lineas en dudas/revision: ' + IntToStr(NDudas));
    SL.Add('Lineas excluidas: ' + IntToStr(NExcl));
    SL.Add('Lineas nuevas sin venta base y con propuesta: ' + IntToStr(NNuevos));
    SL.Add('');
    SL.Add('Unidades vendidas base anterior: ' + FormatFloat('0.##', TotalBase));
    SL.Add('Unidades vendidas tendencia actual: ' + FormatFloat('0.##', TotalActual));
    SL.Add('Unidades finales propuestas: ' + FormatFloat('0.##', TotalFinal));
    SL.Add('');
    SL.Add('Avisos principales:');
    NAvisos := 0;

    for I := 0 to High(FLineasTodas) do
    begin
      L := FLineasTodas[I];
      Linea := '';
      if (L.VentasBase >= 3) and (L.CantidadFinal <= 0) then
        Linea := 'NO ENTRA: ' + L.Codigo + ' - ' + Copy(L.Descripcion, 1, 55) +
          ' vendio ' + FormatFloat('0.##', L.VentasBase) + ' en base anterior.'
      else if (L.VentasBase >= 5) and (L.Confianza <> 'ALTA') then
        Linea := 'REVISAR: ' + L.Codigo + ' - ' + Copy(L.Descripcion, 1, 55) +
          ' vendio ' + FormatFloat('0.##', L.VentasBase) + ' y no esta en ALTA.'
      else if (L.VentasBase <= 0) and (L.CantidadFinal > 0) then
        Linea := 'NUEVO/ACTUAL: ' + L.Codigo + ' - ' + Copy(L.Descripcion, 1, 55) +
          ' no vendio en base y propone ' + FormatFloat('0.##', L.CantidadFinal) + '.'
      else if (ModoTemporadaSeleccionado = 'FINAL TEMPORADA') and (L.CantidadFinal >= 20) then
        Linea := 'FINAL ALTO: ' + L.Codigo + ' - ' + Copy(L.Descripcion, 1, 55) +
          ' propone ' + FormatFloat('0.##', L.CantidadFinal) + ' en final de temporada.';

      if Linea <> '' then
      begin
        Inc(NAvisos);
        if NAvisos <= 80 then SL.Add(Linea);
      end;
    end;

    if NAvisos = 0 then
      SL.Add('Sin avisos importantes.')
    else if NAvisos > 80 then
      SL.Add('... y ' + IntToStr(NAvisos - 80) + ' avisos mas.');

    ShowMessage(SL.Text);
    Log('Comparativa temporada anterior ejecutada. Avisos=' + IntToStr(NAvisos));
  finally
    SL.Free;
  end;
end;

procedure TfPedidoTemporadaAuto.BtnGuardarKeywordsClick(Sender: TObject);
begin
  try
    GuardarKeywordsTemporada;
    ShowMessage('Palabras clave guardadas para la temporada ' + cbTemporada.Text + '.');
  except
    on E: Exception do
    begin
      Log('ERROR guardando palabras clave: ' + E.Message);
      ShowMessage('Error guardando palabras clave: ' + E.Message);
    end;
  end;
end;

procedure TfPedidoTemporadaAuto.BtnGuardarBorradorClick(Sender: TObject);
begin
  try
    GuardarBorradorCompleto;
  except
    on E: Exception do
    begin
      Log('ERROR guardando borrador completo: ' + E.Message);
      ShowMessage('Error guardando borrador: ' + E.Message);
    end;
  end;
end;

procedure TfPedidoTemporadaAuto.BtnCargarBorradorClick(Sender: TObject);
begin
  try
    CargarUltimoBorrador;
  except
    on E: Exception do
    begin
      Log('ERROR cargando borrador completo: ' + E.Message);
      ShowMessage('Error cargando borrador: ' + E.Message);
    end;
  end;
end;

procedure TfPedidoTemporadaAuto.BtnBorrarBorradorClick(Sender: TObject);
begin
  try
    BorrarUltimoBorrador;
  except
    on E: Exception do
    begin
      Log('ERROR borrando borrador completo: ' + E.Message);
      ShowMessage('Error borrando borrador: ' + E.Message);
    end;
  end;
end;


procedure TfPedidoTemporadaAuto.CbTemporadaChange(Sender: TObject);
begin
  AplicarDefaultsTemporada(cbTemporada.Text);
  CargarKeywordsTemporada;
  VaciarLineas;
  InicializarGrid;
  lblEstado.Caption := 'Temporada seleccionada: ' + cbTemporada.Text + '. Ajusta proveedor y pulsa Calcular temp.';
end;

procedure TfPedidoTemporadaAuto.GridHeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer);
begin
  if not IsColumn then Exit;
  if FSortCol = Index then FSortAsc := not FSortAsc else
  begin
    FSortCol := Index;
    FSortAsc := True;
  end;
  OrdenarGridPorColumna(Index, FSortAsc);
end;

end.
