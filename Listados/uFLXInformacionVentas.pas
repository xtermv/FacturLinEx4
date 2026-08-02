unit uFLXInformacionVentas;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  Classes, SysUtils;

implementation

uses
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Buttons,
  ComCtrls, Grids, EditBtn, DB, ZConnection, ZDataset, LCLType,
  LCLIntf, FileUtil, Process, DateUtils, Math, StrUtils, LazUTF8,
  uFLXPDFSimple, Global;

const
  C_FONDO      = TColor($00F8FAFC);
  C_TARJETA    = clWhite;
  C_CABECERA   = TColor($0033210F);
  C_PRIMARIO   = TColor($00EB631D);
  C_TEXTO      = TColor($0033291E);
  C_TEXTO_SUAVE= TColor($006B5E53);
  C_AZUL_SUAVE = TColor($00F8EDE5);
  C_VERDE_SUAVE= TColor($00EAF5EA);
  C_CREMA_SUAVE= TColor($00DCF7FF);
  C_GRIS_SUAVE = TColor($00F2F4F5);
  C_ROJO       = TColor($002B2BC7);

type
  TFLXVentaFila = record
    Codigo: string;
    Descripcion: string;
    FamiliaCodigo: Integer;
    Familia: string;
    ProveedorCodigo: Integer;
    Proveedor: string;
    Unidades: Double;
    PVPMedio: Double;
    DtoMedio: Double;
    Base: Double;
    IVA: Double;
    Total: Double;
    UltimaVenta: TDateTime;
  end;

  TFLXVentaFilas = array of TFLXVentaFila;

  { TFLXSelectorArticulo }

  TFLXSelectorArticulo = class(TForm)
  private
    FConexion: TZConnection;
    FTienda: string;
    FBuscar: TEdit;
    FGrid: TStringGrid;
    FBtnAceptar: TButton;
    FBtnCancelar: TButton;
    FNumeroResultados: Integer;
    procedure BuscarChange(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDownSelector(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AceptarClick(Sender: TObject);
    procedure CargarResultados;
  public
    constructor CreateSelector(AOwner: TComponent;
      AConexion: TZConnection; const ATienda: string);
    function Ejecutar(out ACodigo: string): Boolean;
  end;

  { TFLXInformacionVentasForm }

  TFLXInformacionVentasForm = class(TForm)
  private
    FConexion: TZConnection;
    FTienda: string;
    FFilas: TFLXVentaFilas;
    FOrdenColumna: Integer;
    FOrdenAscendente: Boolean;

    FCabecera: TPanel;
    FFiltros: TPanel;
    FKPI: TPanel;
    FPie: TPanel;

    FDesde: TDateEdit;
    FHasta: TDateEdit;
    FBtnMes: TButton;
    FBtnMesAnterior: TButton;
    FBtnAnio: TButton;

    FAmbito: TComboBox;
    FCodigoDesde: TEdit;
    FCodigoHasta: TEdit;
    FBtnCodigoDesde: TButton;
    FBtnCodigoHasta: TButton;

    FFamilia: TComboBox;
    FProveedor: TComboBox;

    FChkNS: TCheckBox;
    FChkNT: TCheckBox;
    FChkFA: TCheckBox;
    FChkAL: TCheckBox;

    FGrid: TStringGrid;
    FEstado: TLabel;

    FKPIArticulos: TLabel;
    FKPIUnidades: TLabel;
    FKPIBase: TLabel;
    FKPITotal: TLabel;

    FBtnConsultar: TButton;
    FBtnLimpiar: TButton;
    FBtnPDF: TButton;
    FBtnGuardarPDF: TButton;
    FBtnImprimir: TButton;
    FBtnCSV: TButton;
    FBtnSalir: TButton;

    procedure ConstruirInterfaz;
    procedure CrearKPI(AParent: TWinControl; const ATitulo: string;
      var AValor: TLabel);
    procedure CargarFamilias;
    procedure CargarProveedores;
    procedure ActualizarEstadoFiltros;
    procedure LimpiarResultados;
    procedure Consultar;
    procedure RellenarGrid;
    procedure ActualizarKPIs;
    procedure ActualizarCabeceras;
    procedure OrdenarFilas;
    procedure QuickSort(AIni, AFin: Integer);
    function CompararFilas(const A, B: TFLXVentaFila): Integer;
    function SufijoTiendaValido: Boolean;
    function CodigoCombo(ACombo: TComboBox): Integer;
    function TextoFiltroActual: string;
    function TextoOperaciones: string;
    function ArchivoTemporalPDF: string;
    function TextoCorto(const S: string; AMax: Integer): string;
    function CSVTexto(const S: string): string;

    procedure GenerarPDF(const AArchivo: string);
    procedure DibujarCabeceraPDF(APDF: TFLXPDFDocument;
      var AY: Double; const APagina: Integer);
    procedure DibujarCabeceraTablaPDF(APDF: TFLXPDFDocument;
      var AY: Double);
    procedure GuardarCSV(const AArchivo: string);

    procedure AmbitoChange(Sender: TObject);
    procedure ConsultarClick(Sender: TObject);
    procedure LimpiarClick(Sender: TObject);
    procedure MesClick(Sender: TObject);
    procedure MesAnteriorClick(Sender: TObject);
    procedure AnioClick(Sender: TObject);
    procedure BuscarCodigoDesdeClick(Sender: TObject);
    procedure BuscarCodigoHastaClick(Sender: TObject);
    procedure GridHeaderClick(Sender: TObject; IsColumn: Boolean;
      Index: Integer);
    procedure GridPrepareCanvas(Sender: TObject; ACol, ARow: Integer;
      AState: TGridDrawState);
    procedure GridResize(Sender: TObject);
    procedure VistaPDFClick(Sender: TObject);
    procedure GuardarPDFClick(Sender: TObject);
    procedure ImprimirClick(Sender: TObject);
    procedure CSVClick(Sender: TObject);
    procedure SalirClick(Sender: TObject);
    procedure FormKeyDownInfo(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public
    constructor CreateInforme(AOwner: TComponent;
      AConexion: TZConnection; const ATienda: string);
  end;

  { TFLXInformacionVentasInstaller }

  TFLXInformacionVentasInstaller = class(TComponent)
  private
    FTimer: TTimer;
    FInstalado: Boolean;
    procedure TimerTimer(Sender: TObject);
    procedure BotonClick(Sender: TObject);
    function BuscarPaginaListados(AControl: TWinControl): TTabSheet;
    function BuscarConexion(AComponent: TComponent;
      const ASufijo: string): TZConnection;
    function ConexionContieneHistorico(AConexion: TZConnection;
      const ASufijo: string): Boolean;
    function SufijoSeguro(const S: string): Boolean;
    procedure CrearIconoBoton(ABoton: TBitBtn);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  GInstaller: TFLXInformacionVentasInstaller;

function NuevaEtiqueta(AOwner: TComponent; AParent: TWinControl;
  const ACaption: string; AX, AY, AAncho, AAlto: Integer;
  ANegrita: Boolean = False): TLabel;
begin
  Result := TLabel.Create(AOwner);
  Result.Parent := AParent;
  Result.Caption := ACaption;
  Result.SetBounds(AX, AY, AAncho, AAlto);
  Result.AutoSize := False;
  Result.Font.Name := 'Sans';
  Result.Font.Height := -13;
  Result.Font.Color := C_TEXTO;
  if ANegrita then
    Result.Font.Style := [fsBold];
end;

function NuevoBoton(AOwner: TComponent; AParent: TWinControl;
  const ACaption: string; AX, AY, AAncho, AAlto: Integer): TButton;
begin
  Result := TButton.Create(AOwner);
  Result.Parent := AParent;
  Result.Caption := ACaption;
  Result.SetBounds(AX, AY, AAncho, AAlto);
  Result.Font.Name := 'Sans';
  Result.Font.Height := -13;
end;

{ TFLXSelectorArticulo }

constructor TFLXSelectorArticulo.CreateSelector(AOwner: TComponent;
  AConexion: TZConnection; const ATienda: string);
begin
  inherited CreateNew(AOwner, 1);

  FConexion := AConexion;
  FTienda := ATienda;
  FNumeroResultados := 0;

  Caption := 'Seleccionar artículo';
  Position := poScreenCenter;
  Width := 860;
  Height := 580;
  Constraints.MinWidth := 650;
  Constraints.MinHeight := 420;
  Color := C_FONDO;
  KeyPreview := True;
  OnKeyDown := @FormKeyDownSelector;

  NuevaEtiqueta(Self, Self, 'Buscar por código o descripción',
    18, 16, 260, 22, True);

  FBuscar := TEdit.Create(Self);
  FBuscar.Parent := Self;
  FBuscar.SetBounds(18, 42, 810, 32);
  FBuscar.Font.Name := 'Sans';
  FBuscar.Font.Height := -14;
  FBuscar.OnChange := @BuscarChange;

  FGrid := TStringGrid.Create(Self);
  FGrid.Parent := Self;
  FGrid.Align := alClient;
  FGrid.BorderSpacing.Around := 18;
  FGrid.BorderSpacing.Top := 84;
  FGrid.BorderSpacing.Bottom := 62;
  FGrid.FixedRows := 1;
  FGrid.ColCount := 4;
  FGrid.RowCount := 2;
  FGrid.DefaultRowHeight := 27;
  FGrid.Options := FGrid.Options +
    [goRowSelect, goColSizing, goThumbTracking];
  FGrid.Cells[0, 0] := 'Código';
  FGrid.Cells[1, 0] := 'Descripción';
  FGrid.Cells[2, 0] := 'PVP';
  FGrid.Cells[3, 0] := 'Última compra';
  FGrid.ColWidths[0] := 125;
  FGrid.ColWidths[1] := 430;
  FGrid.ColWidths[2] := 90;
  FGrid.ColWidths[3] := 130;
  FGrid.OnDblClick := @GridDblClick;
  FGrid.OnKeyDown := @GridKeyDown;

  FBtnAceptar := NuevoBoton(Self, Self, 'Seleccionar',
    565, 510, 125, 36);
  FBtnAceptar.Anchors := [akRight, akBottom];
  FBtnAceptar.OnClick := @AceptarClick;

  FBtnCancelar := NuevoBoton(Self, Self, 'Cancelar',
    705, 510, 125, 36);
  FBtnCancelar.Anchors := [akRight, akBottom];
  FBtnCancelar.ModalResult := mrCancel;

  CargarResultados;
end;

procedure TFLXSelectorArticulo.CargarResultados;
var
  Q: TZQuery;
  P: string;
  R: Integer;
begin
  FNumeroResultados := 0;
  FGrid.RowCount := 2;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConexion;
    P := '%' + Trim(FBuscar.Text) + '%';

    Q.SQL.Text :=
      'SELECT A0,A1,A2,A13 FROM `artitien' + FTienda + '` ' +
      'WHERE A0 LIKE :P OR A1 LIKE :P ' +
      'ORDER BY A1,A0 LIMIT 300';
    Q.ParamByName('P').AsString := P;
    Q.Open;

    R := 1;
    while not Q.EOF do
    begin
      if R >= FGrid.RowCount then
        FGrid.RowCount := R + 1;

      FGrid.Cells[0, R] := Q.FieldByName('A0').AsString;
      FGrid.Cells[1, R] := Q.FieldByName('A1').AsString;
      FGrid.Cells[2, R] :=
        FormatFloat('#,##0.00', Q.FieldByName('A2').AsFloat);

      if Q.FieldByName('A13').IsNull then
        FGrid.Cells[3, R] := ''
      else
        FGrid.Cells[3, R] :=
          FormatDateTime('dd/mm/yyyy',
            Q.FieldByName('A13').AsDateTime);

      Inc(R);
      Q.Next;
    end;

    FNumeroResultados := R - 1;
    if FNumeroResultados = 0 then
    begin
      FGrid.RowCount := 2;
      FGrid.Cells[0, 1] := '';
      FGrid.Cells[1, 1] := 'No se encontraron artículos';
      FGrid.Cells[2, 1] := '';
      FGrid.Cells[3, 1] := '';
    end
    else
      FGrid.Row := 1;
  finally
    Q.Free;
  end;
end;

procedure TFLXSelectorArticulo.BuscarChange(Sender: TObject);
begin
  CargarResultados;
end;

procedure TFLXSelectorArticulo.AceptarClick(Sender: TObject);
begin
  if (FNumeroResultados > 0) and
     (FGrid.Row >= 1) and
     (FGrid.Row <= FNumeroResultados) then
    ModalResult := mrOk;
end;

procedure TFLXSelectorArticulo.GridDblClick(Sender: TObject);
begin
  AceptarClick(Sender);
end;

procedure TFLXSelectorArticulo.GridKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    AceptarClick(Sender);
  end
  else if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end;
end;

procedure TFLXSelectorArticulo.FormKeyDownSelector(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end;
end;

function TFLXSelectorArticulo.Ejecutar(out ACodigo: string): Boolean;
begin
  Result := ShowModal = mrOk;
  if Result and (FGrid.Row >= 1) and
     (FGrid.Row <= FNumeroResultados) then
    ACodigo := FGrid.Cells[0, FGrid.Row]
  else
    ACodigo := '';
end;

{ TFLXInformacionVentasForm }

constructor TFLXInformacionVentasForm.CreateInforme(AOwner: TComponent;
  AConexion: TZConnection; const ATienda: string);
begin
  inherited CreateNew(AOwner, 1);

  FConexion := AConexion;
  FTienda := Trim(ATienda);
  FOrdenColumna := 0;
  FOrdenAscendente := True;

  Caption := 'FacturLinEx - Información de ventas';
  Position := poScreenCenter;
  WindowState := wsMaximized;
  Width := 1450;
  Height := 850;
  Constraints.MinWidth := 1100;
  Constraints.MinHeight := 650;
  Color := C_FONDO;
  KeyPreview := True;
  OnKeyDown := @FormKeyDownInfo;

  ConstruirInterfaz;
  CargarFamilias;
  CargarProveedores;

  FDesde.Date := StartOfTheMonth(Date);
  FHasta.Date := Date;
  FAmbito.ItemIndex := 0;

  ActualizarEstadoFiltros;
  LimpiarResultados;
end;

procedure TFLXInformacionVentasForm.CrearKPI(AParent: TWinControl;
  const ATitulo: string; var AValor: TLabel);
var
  P: TPanel;
begin
  P := TPanel.Create(Self);
  P.Parent := AParent;
  P.Align := alLeft;
  P.Width := 245;
  P.BorderSpacing.Around := 8;
  P.Caption := '';
  P.BevelOuter := bvNone;
  P.ParentBackground := False;
  P.Color := C_TARJETA;

  NuevaEtiqueta(Self, P, ATitulo, 14, 10, 215, 20, True);

  AValor := NuevaEtiqueta(Self, P, '0',
    14, 33, 215, 30, True);
  AValor.Font.Height := -21;
  AValor.Font.Color := C_PRIMARIO;
end;

procedure TFLXInformacionVentasForm.ConstruirInterfaz;
var
  LTitulo, LSubtitulo: TLabel;
begin
  FCabecera := TPanel.Create(Self);
  FCabecera.Parent := Self;
  FCabecera.Align := alTop;
  FCabecera.Height := 84;
  FCabecera.Caption := '';
  FCabecera.BevelOuter := bvNone;
  FCabecera.ParentBackground := False;
  FCabecera.Color := C_CABECERA;

  LTitulo := NuevaEtiqueta(Self, FCabecera,
    'INFORMACIÓN DE VENTAS', 28, 14, 650, 32, True);
  LTitulo.Font.Height := -24;
  LTitulo.Font.Color := clWhite;

  LSubtitulo := NuevaEtiqueta(Self, FCabecera,
    'Unidades, precios e importes reales vendidos por artículo',
    30, 49, 800, 22, False);
  LSubtitulo.Font.Color := TColor($00DDE8EE);

  FFiltros := TPanel.Create(Self);
  FFiltros.Parent := Self;
  FFiltros.Align := alTop;
  FFiltros.Height := 190;
  FFiltros.Caption := '';
  FFiltros.BevelOuter := bvNone;
  FFiltros.ParentBackground := False;
  FFiltros.Color := C_AZUL_SUAVE;

  NuevaEtiqueta(Self, FFiltros, 'PERIODO',
    20, 12, 180, 22, True);
  NuevaEtiqueta(Self, FFiltros, 'Desde',
    20, 40, 70, 22, False);
  NuevaEtiqueta(Self, FFiltros, 'Hasta',
    188, 40, 70, 22, False);

  FDesde := TDateEdit.Create(Self);
  FDesde.Parent := FFiltros;
  FDesde.SetBounds(20, 64, 150, 31);
  FDesde.DateOrder := doDMY;
  FDesde.DateFormat := 'dd/mm/yyyy';
  FDesde.ButtonOnlyWhenFocused := False;
  FDesde.FocusOnButtonClick := False;
  FDesde.DirectInput := True;

  FHasta := TDateEdit.Create(Self);
  FHasta.Parent := FFiltros;
  FHasta.SetBounds(188, 64, 150, 31);
  FHasta.DateOrder := doDMY;
  FHasta.DateFormat := 'dd/mm/yyyy';
  FHasta.ButtonOnlyWhenFocused := False;
  FHasta.FocusOnButtonClick := False;
  FHasta.DirectInput := True;

  FBtnMes := NuevoBoton(Self, FFiltros, 'Mes actual',
    20, 108, 100, 32);
  FBtnMes.OnClick := @MesClick;

  FBtnMesAnterior := NuevoBoton(Self, FFiltros, 'Mes anterior',
    128, 108, 105, 32);
  FBtnMesAnterior.OnClick := @MesAnteriorClick;

  FBtnAnio := NuevoBoton(Self, FFiltros, 'Este año',
    241, 108, 97, 32);
  FBtnAnio.OnClick := @AnioClick;

  NuevaEtiqueta(Self, FFiltros, 'ÁMBITO DE ARTÍCULOS',
    380, 12, 260, 22, True);

  FAmbito := TComboBox.Create(Self);
  FAmbito.Parent := FFiltros;
  FAmbito.SetBounds(380, 40, 235, 31);
  FAmbito.Style := csDropDownList;
  FAmbito.Items.Add('Todos los artículos');
  FAmbito.Items.Add('Un artículo');
  FAmbito.Items.Add('Desde código / hasta código');
  FAmbito.Items.Add('Una familia');
  FAmbito.ItemIndex := 0;
  FAmbito.OnChange := @AmbitoChange;

  NuevaEtiqueta(Self, FFiltros, 'Código / Desde',
    380, 82, 120, 20, False);

  FCodigoDesde := TEdit.Create(Self);
  FCodigoDesde.Parent := FFiltros;
  FCodigoDesde.SetBounds(380, 105, 170, 31);

  FBtnCodigoDesde := NuevoBoton(Self, FFiltros, '...',
    555, 105, 42, 31);
  FBtnCodigoDesde.OnClick := @BuscarCodigoDesdeClick;

  NuevaEtiqueta(Self, FFiltros, 'Hasta',
    620, 82, 80, 20, False);

  FCodigoHasta := TEdit.Create(Self);
  FCodigoHasta.Parent := FFiltros;
  FCodigoHasta.SetBounds(620, 105, 170, 31);

  FBtnCodigoHasta := NuevoBoton(Self, FFiltros, '...',
    795, 105, 42, 31);
  FBtnCodigoHasta.OnClick := @BuscarCodigoHastaClick;

  NuevaEtiqueta(Self, FFiltros, 'Familia',
    620, 12, 100, 20, False);

  FFamilia := TComboBox.Create(Self);
  FFamilia.Parent := FFiltros;
  FFamilia.SetBounds(620, 40, 310, 31);
  FFamilia.Style := csDropDownList;

  NuevaEtiqueta(Self, FFiltros, 'PROVEEDOR',
    970, 12, 200, 22, True);

  FProveedor := TComboBox.Create(Self);
  FProveedor.Parent := FFiltros;
  FProveedor.SetBounds(970, 40, 360, 31);
  FProveedor.Style := csDropDownList;

  NuevaEtiqueta(Self, FFiltros, 'DOCUMENTOS DE VENTA',
    970, 82, 260, 22, True);

  FChkNS := TCheckBox.Create(Self);
  FChkNS.Parent := FFiltros;
  FChkNS.SetBounds(970, 108, 110, 25);
  FChkNS.Caption := 'NS - Normal';
  FChkNS.Checked := True;

  FChkNT := TCheckBox.Create(Self);
  FChkNT.Parent := FFiltros;
  FChkNT.SetBounds(1085, 108, 110, 25);
  FChkNT.Caption := 'NT - Ticket';
  FChkNT.Checked := True;

  FChkFA := TCheckBox.Create(Self);
  FChkFA.Parent := FFiltros;
  FChkFA.SetBounds(1200, 108, 110, 25);
  FChkFA.Caption := 'FA - Factura';
  FChkFA.Checked := True;

  FChkAL := TCheckBox.Create(Self);
  FChkAL.Parent := FFiltros;
  FChkAL.SetBounds(1315, 108, 120, 25);
  FChkAL.Caption := 'AL - Albarán';
  FChkAL.Checked := True;

  NuevaEtiqueta(Self, FFiltros,
    'Las operaciones anuladas quedan excluidas.',
    970, 141, 430, 22, False).Font.Color := C_TEXTO_SUAVE;

  FKPI := TPanel.Create(Self);
  FKPI.Parent := Self;
  FKPI.Align := alTop;
  FKPI.Height := 82;
  FKPI.Caption := '';
  FKPI.BevelOuter := bvNone;
  FKPI.ParentBackground := False;
  FKPI.Color := C_GRIS_SUAVE;

  CrearKPI(FKPI, 'ARTÍCULOS', FKPIArticulos);
  CrearKPI(FKPI, 'UNIDADES NETAS', FKPIUnidades);
  CrearKPI(FKPI, 'BASE IMPONIBLE', FKPIBase);
  CrearKPI(FKPI, 'TOTAL VENDIDO', FKPITotal);

  FPie := TPanel.Create(Self);
  FPie.Parent := Self;
  FPie.Align := alBottom;
  FPie.Height := 68;
  FPie.Caption := '';
  FPie.BevelOuter := bvNone;
  FPie.ParentBackground := False;
  FPie.Color := C_CABECERA;

  FBtnConsultar := NuevoBoton(Self, FPie, 'Consultar',
    18, 14, 120, 40);
  FBtnConsultar.OnClick := @ConsultarClick;

  FBtnLimpiar := NuevoBoton(Self, FPie, 'Limpiar filtros',
    146, 14, 125, 40);
  FBtnLimpiar.OnClick := @LimpiarClick;

  FBtnPDF := NuevoBoton(Self, FPie, 'Ver PDF',
    310, 14, 105, 40);
  FBtnPDF.OnClick := @VistaPDFClick;

  FBtnGuardarPDF := NuevoBoton(Self, FPie, 'Guardar PDF',
    423, 14, 115, 40);
  FBtnGuardarPDF.OnClick := @GuardarPDFClick;

  FBtnImprimir := NuevoBoton(Self, FPie, 'Imprimir',
    546, 14, 105, 40);
  FBtnImprimir.OnClick := @ImprimirClick;

  FBtnCSV := NuevoBoton(Self, FPie, 'Exportar CSV',
    659, 14, 125, 40);
  FBtnCSV.OnClick := @CSVClick;

  FBtnSalir := NuevoBoton(Self, FPie, 'Salir',
    802, 14, 105, 40);
  FBtnSalir.OnClick := @SalirClick;

  FEstado := NuevaEtiqueta(Self, FPie,
    'Seleccione los filtros y pulse Consultar.',
    930, 22, 470, 25, False);
  FEstado.Font.Color := clWhite;

  FGrid := TStringGrid.Create(Self);
  FGrid.Parent := Self;
  FGrid.Align := alClient;
  FGrid.BorderSpacing.Around := 12;
  FGrid.FixedRows := 1;
  FGrid.ColCount := 11;
  FGrid.RowCount := 2;
  FGrid.DefaultRowHeight := 27;
  FGrid.FixedColor := C_CABECERA;
  FGrid.Font.Name := 'Sans';
  FGrid.Font.Height := -13;
  FGrid.Options := FGrid.Options +
    [goRowSelect, goColSizing, goThumbTracking];
  FGrid.OnHeaderClick := @GridHeaderClick;
  FGrid.OnPrepareCanvas := @GridPrepareCanvas;
  FGrid.OnResize := @GridResize;

  ActualizarCabeceras;
  GridResize(FGrid);
end;

procedure TFLXInformacionVentasForm.CargarFamilias;
var
  Q: TZQuery;
begin
  FFamilia.Items.Clear;
  FFamilia.Items.AddObject('Todas las familias', TObject(PtrInt(-1)));

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConexion;
    Q.SQL.Text :=
      'SELECT F0,F1 FROM `familias' + FTienda + '` ORDER BY F1,F0';
    Q.Open;

    while not Q.EOF do
    begin
      FFamilia.Items.AddObject(
        Q.FieldByName('F0').AsString + ' - ' +
        Q.FieldByName('F1').AsString,
        TObject(PtrInt(Q.FieldByName('F0').AsInteger)));
      Q.Next;
    end;
  finally
    Q.Free;
  end;

  FFamilia.ItemIndex := 0;
end;

procedure TFLXInformacionVentasForm.CargarProveedores;
var
  Q: TZQuery;
begin
  FProveedor.Items.Clear;
  FProveedor.Items.AddObject('Todos los proveedores',
    TObject(PtrInt(-1)));

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConexion;
    Q.SQL.Text := 'SELECT P0,P1 FROM proveedores ORDER BY P1,P0';
    Q.Open;

    while not Q.EOF do
    begin
      FProveedor.Items.AddObject(
        Q.FieldByName('P0').AsString + ' - ' +
        Q.FieldByName('P1').AsString,
        TObject(PtrInt(Q.FieldByName('P0').AsInteger)));
      Q.Next;
    end;
  finally
    Q.Free;
  end;

  FProveedor.ItemIndex := 0;
end;

function TFLXInformacionVentasForm.SufijoTiendaValido: Boolean;
var
  I: Integer;
begin
  Result := (Length(FTienda) > 0) and (Length(FTienda) <= 8);
  if not Result then Exit;

  for I := 1 to Length(FTienda) do
    if not (FTienda[I] in ['0'..'9']) then
      Exit(False);
end;

function TFLXInformacionVentasForm.CodigoCombo(
  ACombo: TComboBox): Integer;
begin
  Result := -1;
  if Assigned(ACombo) and
     (ACombo.ItemIndex >= 0) then
    Result := PtrInt(ACombo.Items.Objects[ACombo.ItemIndex]);
end;

procedure TFLXInformacionVentasForm.ActualizarEstadoFiltros;
var
  EsUno, EsRango, EsFamilia: Boolean;
begin
  EsUno := FAmbito.ItemIndex = 1;
  EsRango := FAmbito.ItemIndex = 2;
  EsFamilia := FAmbito.ItemIndex = 3;

  FCodigoDesde.Enabled := EsUno or EsRango;
  FBtnCodigoDesde.Enabled := EsUno or EsRango;

  FCodigoHasta.Enabled := EsRango;
  FBtnCodigoHasta.Enabled := EsRango;

  FFamilia.Enabled := EsFamilia;
end;

procedure TFLXInformacionVentasForm.AmbitoChange(Sender: TObject);
begin
  ActualizarEstadoFiltros;
end;

procedure TFLXInformacionVentasForm.LimpiarResultados;
var
  C: Integer;
begin
  SetLength(FFilas, 0);
  FGrid.RowCount := 2;

  for C := 0 to FGrid.ColCount - 1 do
    FGrid.Cells[C, 1] := '';

  FKPIArticulos.Caption := '0';
  FKPIUnidades.Caption := '0,00';
  FKPIBase.Caption := '0,00 €';
  FKPITotal.Caption := '0,00 €';
end;

function TFLXInformacionVentasForm.TextoOperaciones: string;
begin
  Result := '';
  if FChkNS.Checked then Result := 'NS';
  if FChkNT.Checked then
  begin
    if Result <> '' then Result := Result + ', ';
    Result := Result + 'NT';
  end;
  if FChkFA.Checked then
  begin
    if Result <> '' then Result := Result + ', ';
    Result := Result + 'FA';
  end;
  if FChkAL.Checked then
  begin
    if Result <> '' then Result := Result + ', ';
    Result := Result + 'AL';
  end;
end;

function TFLXInformacionVentasForm.TextoFiltroActual: string;
begin
  case FAmbito.ItemIndex of
    1:
      Result := 'Artículo ' + Trim(FCodigoDesde.Text);
    2:
      Result := 'Artículos ' + Trim(FCodigoDesde.Text) +
        ' a ' + Trim(FCodigoHasta.Text);
    3:
      if FFamilia.ItemIndex > 0 then
        Result := FFamilia.Text
      else
        Result := 'Todas las familias';
  else
    Result := 'Todos los artículos';
  end;

  if FProveedor.ItemIndex > 0 then
    Result := Result + ' | ' + FProveedor.Text;

  Result := Result + ' | Operaciones: ' + TextoOperaciones;
end;

procedure TFLXInformacionVentasForm.Consultar;
var
  Q: TZQuery;
  SQL, Ops: string;
  N, Fam, Prov: Integer;
begin
  if not SufijoTiendaValido then
  begin
    MessageDlg('El código de tienda no es válido.', mtError, [mbOK], 0);
    Exit;
  end;

  if FDesde.Date > FHasta.Date then
  begin
    MessageDlg('La fecha Desde no puede ser posterior a Hasta.',
      mtWarning, [mbOK], 0);
    Exit;
  end;

  Ops := '';
  if FChkNS.Checked then Ops := '''NS''';
  if FChkNT.Checked then
  begin
    if Ops <> '' then Ops := Ops + ',';
    Ops := Ops + '''NT''';
  end;
  if FChkFA.Checked then
  begin
    if Ops <> '' then Ops := Ops + ',';
    Ops := Ops + '''FA''';
  end;
  if FChkAL.Checked then
  begin
    if Ops <> '' then Ops := Ops + ',';
    Ops := Ops + '''AL''';
  end;

  if Ops = '' then
  begin
    MessageDlg('Seleccione al menos un tipo de documento.',
      mtWarning, [mbOK], 0);
    Exit;
  end;

  case FAmbito.ItemIndex of
    1:
      if Trim(FCodigoDesde.Text) = '' then
      begin
        MessageDlg('Indique el artículo.', mtWarning, [mbOK], 0);
        Exit;
      end;
    2:
      if (Trim(FCodigoDesde.Text) = '') or
         (Trim(FCodigoHasta.Text) = '') then
      begin
        MessageDlg('Indique los códigos Desde y Hasta.',
          mtWarning, [mbOK], 0);
        Exit;
      end;
    3:
      if FFamilia.ItemIndex <= 0 then
      begin
        MessageDlg('Seleccione una familia.',
          mtWarning, [mbOK], 0);
        Exit;
      end;
  end;

  Screen.Cursor := crHourGlass;
  FEstado.Caption := 'Consultando ventas...';
  Application.ProcessMessages;

  Q := TZQuery.Create(nil);
  try
   try
    Q.Connection := FConexion;

    SQL :=
      'SELECT ' +
      ' d.HOD6 AS CODIGO, ' +
      ' COALESCE(NULLIF(MAX(a.A1),''''),' +
      ' MAX(CAST(d.HOD7 AS CHAR(255))),'''') AS DESCRIPCION, ' +
      ' COALESCE(a.A14,0) AS FAMILIA_CODIGO, ' +
      ' COALESCE(MAX(f.F1),'''') AS FAMILIA, ' +
      ' COALESCE(a.A32,0) AS PROVEEDOR_CODIGO, ' +
      ' COALESCE(MAX(p.P1),'''') AS PROVEEDOR, ' +
      ' SUM(d.HOD8) AS UNIDADES, ' +
      ' COALESCE(SUM(ABS(d.HOD14)) / ' +
      ' NULLIF(SUM(ABS(d.HOD8)),0),0) AS PVP_MEDIO, ' +
      ' COALESCE(SUM(ABS(d.HOD8) * d.HOD11) / ' +
      ' NULLIF(SUM(ABS(d.HOD8)),0),0) AS DTO_MEDIO, ' +
      ' SUM(d.HOD12) AS BASE, ' +
      ' SUM(d.HOD14)-SUM(d.HOD12) AS IVA, ' +
      ' SUM(d.HOD14) AS TOTAL, ' +
      ' MAX(d.HOD0) AS ULTIMA_VENTA ' +

      'FROM `hisopdd' + FTienda + '` d ' +

      'INNER JOIN `hisopcc' + FTienda + '` c ON ' +
      ' c.HO0=d.HOD0 AND c.HO1=d.HOD1 AND ' +
      ' c.HO2=d.HOD2 AND c.HO3=d.HOD3 AND c.HO4=d.HOD4 ' +

      'LEFT JOIN `artitien' + FTienda + '` a ON ' +
      ' BINARY a.A0=BINARY d.HOD6 ' +

      'LEFT JOIN `familias' + FTienda + '` f ON f.F0=a.A14 ' +
      'LEFT JOIN proveedores p ON p.P0=a.A32 ' +

      'WHERE d.HOD0 BETWEEN :DESDE AND :HASTA ' +
      ' AND d.HOD6 IS NOT NULL AND TRIM(d.HOD6)<>'''' ' +
      ' AND c.HO5 IN (' + Ops + ') ' +
      ' AND COALESCE(c.HO16,'''')<>''A'' ';

    case FAmbito.ItemIndex of
      1:
        SQL := SQL + ' AND BINARY d.HOD6=BINARY :CODIGO ';
      2:
        SQL := SQL +
          ' AND BINARY d.HOD6>=BINARY :CODIGO_DESDE ' +
          ' AND BINARY d.HOD6<=BINARY :CODIGO_HASTA ';
      3:
        SQL := SQL + ' AND a.A14=:FAMILIA ';
    end;

    Prov := CodigoCombo(FProveedor);
    if FProveedor.ItemIndex > 0 then
      SQL := SQL + ' AND a.A32=:PROVEEDOR ';

    SQL := SQL +
      'GROUP BY d.HOD6,a.A14,a.A32 ' +
      'ORDER BY d.HOD6';

    Q.SQL.Text := SQL;
    Q.ParamByName('DESDE').AsDateTime := FDesde.Date;
    Q.ParamByName('HASTA').AsDateTime := FHasta.Date;

    case FAmbito.ItemIndex of
      1:
        Q.ParamByName('CODIGO').AsString :=
          Trim(FCodigoDesde.Text);
      2:
      begin
        Q.ParamByName('CODIGO_DESDE').AsString :=
          Trim(FCodigoDesde.Text);
        Q.ParamByName('CODIGO_HASTA').AsString :=
          Trim(FCodigoHasta.Text);
      end;
      3:
      begin
        Fam := CodigoCombo(FFamilia);
        Q.ParamByName('FAMILIA').AsInteger := Fam;
      end;
    end;

    if FProveedor.ItemIndex > 0 then
      Q.ParamByName('PROVEEDOR').AsInteger := Prov;

    Q.Open;

    SetLength(FFilas, 0);
    N := 0;

    while not Q.EOF do
    begin
      SetLength(FFilas, N + 1);

      FFilas[N].Codigo :=
        Q.FieldByName('CODIGO').AsString;
      FFilas[N].Descripcion :=
        Q.FieldByName('DESCRIPCION').AsString;
      FFilas[N].FamiliaCodigo :=
        Q.FieldByName('FAMILIA_CODIGO').AsInteger;
      FFilas[N].Familia :=
        Q.FieldByName('FAMILIA').AsString;
      FFilas[N].ProveedorCodigo :=
        Q.FieldByName('PROVEEDOR_CODIGO').AsInteger;
      FFilas[N].Proveedor :=
        Q.FieldByName('PROVEEDOR').AsString;
      FFilas[N].Unidades :=
        Q.FieldByName('UNIDADES').AsFloat;
      FFilas[N].PVPMedio :=
        Q.FieldByName('PVP_MEDIO').AsFloat;
      FFilas[N].DtoMedio :=
        Q.FieldByName('DTO_MEDIO').AsFloat;
      FFilas[N].Base :=
        Q.FieldByName('BASE').AsFloat;
      FFilas[N].IVA :=
        Q.FieldByName('IVA').AsFloat;
      FFilas[N].Total :=
        Q.FieldByName('TOTAL').AsFloat;

      if Q.FieldByName('ULTIMA_VENTA').IsNull then
        FFilas[N].UltimaVenta := 0
      else
        FFilas[N].UltimaVenta :=
          Q.FieldByName('ULTIMA_VENTA').AsDateTime;

      Inc(N);
      Q.Next;
    end;

    FOrdenColumna := 0;
    FOrdenAscendente := True;
    RellenarGrid;
    ActualizarKPIs;

    FEstado.Caption :=
      IntToStr(Length(FFilas)) + ' artículos encontrados.';
  except
    on E: Exception do
    begin
      LimpiarResultados;
      FEstado.Caption := 'Error durante la consulta.';
      MessageDlg('No se pudo consultar la información de ventas:' +
        LineEnding + E.Message, mtError, [mbOK], 0);
    end;
   end;
  finally
    Q.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFLXInformacionVentasForm.RellenarGrid;
var
  I, R, C: Integer;
  Fam, Prov: string;
begin
  FGrid.RowCount := Max(2, Length(FFilas) + 1);

  for R := 1 to FGrid.RowCount - 1 do
    for C := 0 to FGrid.ColCount - 1 do
      FGrid.Cells[C, R] := '';

  for I := 0 to High(FFilas) do
  begin
    R := I + 1;

    if FFilas[I].FamiliaCodigo <> 0 then
      Fam := IntToStr(FFilas[I].FamiliaCodigo)
    else
      Fam := '';

    if Trim(FFilas[I].Familia) <> '' then
    begin
      if Fam <> '' then Fam := Fam + ' - ';
      Fam := Fam + FFilas[I].Familia;
    end;

    if FFilas[I].ProveedorCodigo <> 0 then
      Prov := IntToStr(FFilas[I].ProveedorCodigo)
    else
      Prov := '';

    if Trim(FFilas[I].Proveedor) <> '' then
    begin
      if Prov <> '' then Prov := Prov + ' - ';
      Prov := Prov + FFilas[I].Proveedor;
    end;

    FGrid.Cells[0, R] := FFilas[I].Codigo;
    FGrid.Cells[1, R] := FFilas[I].Descripcion;
    FGrid.Cells[2, R] := Fam;
    FGrid.Cells[3, R] := Prov;
    FGrid.Cells[4, R] :=
      FormatFloat('#,##0.00', FFilas[I].Unidades);
    FGrid.Cells[5, R] :=
      FormatFloat('#,##0.00', FFilas[I].PVPMedio);
    FGrid.Cells[6, R] :=
      FormatFloat('#,##0.00', FFilas[I].DtoMedio) + ' %';
    FGrid.Cells[7, R] :=
      FormatFloat('#,##0.00', FFilas[I].Base);
    FGrid.Cells[8, R] :=
      FormatFloat('#,##0.00', FFilas[I].IVA);
    FGrid.Cells[9, R] :=
      FormatFloat('#,##0.00', FFilas[I].Total);

    if FFilas[I].UltimaVenta > 0 then
      FGrid.Cells[10, R] :=
        FormatDateTime('dd/mm/yyyy', FFilas[I].UltimaVenta);
  end;

  ActualizarCabeceras;
end;

procedure TFLXInformacionVentasForm.ActualizarKPIs;
var
  I: Integer;
  Unidades, Base, Total: Double;
begin
  Unidades := 0;
  Base := 0;
  Total := 0;

  for I := 0 to High(FFilas) do
  begin
    Unidades := Unidades + FFilas[I].Unidades;
    Base := Base + FFilas[I].Base;
    Total := Total + FFilas[I].Total;
  end;

  FKPIArticulos.Caption := IntToStr(Length(FFilas));
  FKPIUnidades.Caption := FormatFloat('#,##0.00', Unidades);
  FKPIBase.Caption := FormatFloat('#,##0.00 €', Base);
  FKPITotal.Caption := FormatFloat('#,##0.00 €', Total);
end;

procedure TFLXInformacionVentasForm.ActualizarCabeceras;
const
  Titulos: array[0..10] of string = (
    'Código', 'Descripción', 'Familia', 'Proveedor',
    'Unidades', 'PVP medio', 'Dto. medio',
    'Base', 'IVA', 'Total', 'Última venta'
  );
var
  I: Integer;
  Flecha: string;
begin
  for I := 0 to 10 do
  begin
    FGrid.Cells[I, 0] := Titulos[I];

    if I = FOrdenColumna then
    begin
      if FOrdenAscendente then
        Flecha := ' ▲'
      else
        Flecha := ' ▼';

      FGrid.Cells[I, 0] := FGrid.Cells[I, 0] + Flecha;
    end;
  end;
end;

function TFLXInformacionVentasForm.CompararFilas(
  const A, B: TFLXVentaFila): Integer;

  function ComparaDouble(X, Y: Double): Integer;
  begin
    if SameValue(X, Y, 0.000001) then Result := 0
    else if X < Y then Result := -1
    else Result := 1;
  end;

begin
  case FOrdenColumna of
    0: Result := CompareText(A.Codigo, B.Codigo);
    1: Result := CompareText(A.Descripcion, B.Descripcion);
    2:
      begin
        Result := A.FamiliaCodigo - B.FamiliaCodigo;
        if Result = 0 then
          Result := CompareText(A.Familia, B.Familia);
      end;
    3:
      begin
        Result := A.ProveedorCodigo - B.ProveedorCodigo;
        if Result = 0 then
          Result := CompareText(A.Proveedor, B.Proveedor);
      end;
    4: Result := ComparaDouble(A.Unidades, B.Unidades);
    5: Result := ComparaDouble(A.PVPMedio, B.PVPMedio);
    6: Result := ComparaDouble(A.DtoMedio, B.DtoMedio);
    7: Result := ComparaDouble(A.Base, B.Base);
    8: Result := ComparaDouble(A.IVA, B.IVA);
    9: Result := ComparaDouble(A.Total, B.Total);
    10: Result := CompareDateTime(A.UltimaVenta, B.UltimaVenta);
  else
    Result := 0;
  end;

  if not FOrdenAscendente then
    Result := -Result;
end;

procedure TFLXInformacionVentasForm.QuickSort(AIni, AFin: Integer);
var
  I, J: Integer;
  Pivote, Temp: TFLXVentaFila;
begin
  I := AIni;
  J := AFin;
  Pivote := FFilas[(AIni + AFin) div 2];

  repeat
    while CompararFilas(FFilas[I], Pivote) < 0 do Inc(I);
    while CompararFilas(FFilas[J], Pivote) > 0 do Dec(J);

    if I <= J then
    begin
      Temp := FFilas[I];
      FFilas[I] := FFilas[J];
      FFilas[J] := Temp;
      Inc(I);
      Dec(J);
    end;
  until I > J;

  if AIni < J then QuickSort(AIni, J);
  if I < AFin then QuickSort(I, AFin);
end;

procedure TFLXInformacionVentasForm.OrdenarFilas;
begin
  if Length(FFilas) > 1 then
    QuickSort(0, High(FFilas));

  RellenarGrid;
end;

procedure TFLXInformacionVentasForm.GridHeaderClick(Sender: TObject;
  IsColumn: Boolean; Index: Integer);
begin
  if not IsColumn then Exit;
  if (Index < 0) or (Index > 10) then Exit;

  if FOrdenColumna = Index then
    FOrdenAscendente := not FOrdenAscendente
  else
  begin
    FOrdenColumna := Index;
    FOrdenAscendente := True;
  end;

  OrdenarFilas;
end;

procedure TFLXInformacionVentasForm.GridPrepareCanvas(
  Sender: TObject; ACol, ARow: Integer; AState: TGridDrawState);
var
  V: Double;
  S: string;
begin
  if ARow = 0 then
  begin
    FGrid.Canvas.Brush.Color := C_CABECERA;
    FGrid.Canvas.Font.Color := clWhite;
    FGrid.Canvas.Font.Style := [fsBold];
    Exit;
  end;

  if gdSelected in AState then
  begin
    FGrid.Canvas.Brush.Color := TColor($00E6D5C4);
    FGrid.Canvas.Font.Color := clBlack;
  end
  else
  begin
    if Odd(ARow) then
      FGrid.Canvas.Brush.Color := clWhite
    else
      FGrid.Canvas.Brush.Color := C_GRIS_SUAVE;

    FGrid.Canvas.Font.Color := C_TEXTO;
  end;

  if ACol in [4, 5, 7, 8, 9] then
  begin
    S := StringReplace(FGrid.Cells[ACol, ARow],
      '.', '', [rfReplaceAll]);
    S := StringReplace(S, ',', DefaultFormatSettings.DecimalSeparator,
      [rfReplaceAll]);
    S := StringReplace(S, '€', '', [rfReplaceAll]);
    S := Trim(S);

    if TryStrToFloat(S, V) and (V < 0) then
      FGrid.Canvas.Font.Color := C_ROJO;
  end;
end;

procedure TFLXInformacionVentasForm.GridResize(Sender: TObject);
var
  Disponible: Integer;
begin
  if not Assigned(FGrid) then Exit;

  FGrid.ColWidths[0] := 105;
  FGrid.ColWidths[2] := 175;
  FGrid.ColWidths[3] := 195;
  FGrid.ColWidths[4] := 90;
  FGrid.ColWidths[5] := 90;
  FGrid.ColWidths[6] := 90;
  FGrid.ColWidths[7] := 95;
  FGrid.ColWidths[8] := 90;
  FGrid.ColWidths[9] := 100;
  FGrid.ColWidths[10] := 110;

  Disponible := FGrid.ClientWidth -
    FGrid.ColWidths[0] - FGrid.ColWidths[2] -
    FGrid.ColWidths[3] - FGrid.ColWidths[4] -
    FGrid.ColWidths[5] - FGrid.ColWidths[6] -
    FGrid.ColWidths[7] - FGrid.ColWidths[8] -
    FGrid.ColWidths[9] - FGrid.ColWidths[10] - 55;

  FGrid.ColWidths[1] := Max(250, Disponible);
end;

procedure TFLXInformacionVentasForm.ConsultarClick(Sender: TObject);
begin
  Consultar;
end;

procedure TFLXInformacionVentasForm.LimpiarClick(Sender: TObject);
begin
  FDesde.Date := StartOfTheMonth(Date);
  FHasta.Date := Date;
  FAmbito.ItemIndex := 0;
  FCodigoDesde.Clear;
  FCodigoHasta.Clear;
  FFamilia.ItemIndex := 0;
  FProveedor.ItemIndex := 0;
  FChkNS.Checked := True;
  FChkNT.Checked := True;
  FChkFA.Checked := True;
  FChkAL.Checked := True;
  ActualizarEstadoFiltros;
  LimpiarResultados;
  FEstado.Caption := 'Filtros restablecidos.';
end;

procedure TFLXInformacionVentasForm.MesClick(Sender: TObject);
begin
  FDesde.Date := StartOfTheMonth(Date);
  FHasta.Date := EndOfTheMonth(Date);
end;

procedure TFLXInformacionVentasForm.MesAnteriorClick(Sender: TObject);
var
  D: TDateTime;
begin
  D := IncMonth(Date, -1);
  FDesde.Date := StartOfTheMonth(D);
  FHasta.Date := EndOfTheMonth(D);
end;

procedure TFLXInformacionVentasForm.AnioClick(Sender: TObject);
begin
  FDesde.Date := EncodeDate(YearOf(Date), 1, 1);
  FHasta.Date := EncodeDate(YearOf(Date), 12, 31);
end;

procedure TFLXInformacionVentasForm.BuscarCodigoDesdeClick(
  Sender: TObject);
var
  S: TFLXSelectorArticulo;
  Codigo: string;
begin
  S := TFLXSelectorArticulo.CreateSelector(
    Self, FConexion, FTienda);
  try
    if S.Ejecutar(Codigo) then
      FCodigoDesde.Text := Codigo;
  finally
    S.Free;
  end;
end;

procedure TFLXInformacionVentasForm.BuscarCodigoHastaClick(
  Sender: TObject);
var
  S: TFLXSelectorArticulo;
  Codigo: string;
begin
  S := TFLXSelectorArticulo.CreateSelector(
    Self, FConexion, FTienda);
  try
    if S.Ejecutar(Codigo) then
      FCodigoHasta.Text := Codigo;
  finally
    S.Free;
  end;
end;

function TFLXInformacionVentasForm.TextoCorto(
  const S: string; AMax: Integer): string;
begin
  Result := Trim(S);
  if UTF8Length(Result) > AMax then
    Result := UTF8Copy(Result, 1, AMax - 1) + '…';
end;

function TFLXInformacionVentasForm.ArchivoTemporalPDF: string;
begin
  Result := IncludeTrailingPathDelimiter(GetTempDir(False)) +
    'FacturLinEx_Ventas_' +
    FormatDateTime('yyyymmdd_hhnnss', Now) + '.pdf';
end;

procedure TFLXInformacionVentasForm.DibujarCabeceraPDF(
  APDF: TFLXPDFDocument; var AY: Double; const APagina: Integer);
var
  NomEmpresa, Periodo: string;
begin
  APDF.NewPage;
  APDF.SetFillColor(0.05, 0.25, 0.28);
  APDF.FillRect(0, 770, APDF.PageWidth, 72);

  APDF.SetFillColor(1, 1, 1);

  NomEmpresa := Trim(Empresa);
  if NomEmpresa = '' then
    NomEmpresa := 'FacturLinEx';

  APDF.Text(30, 812, 17, NomEmpresa, True);
  APDF.Text(30, 790, 12, 'Información de ventas', True);
  APDF.TextRight(APDF.PageWidth - 30, 790, 9,
    'Página ' + IntToStr(APagina), False);

  APDF.SetFillColor(0.15, 0.18, 0.20);

  Periodo := 'Periodo: ' +
    FormatDateTime('dd/mm/yyyy', FDesde.Date) + ' - ' +
    FormatDateTime('dd/mm/yyyy', FHasta.Date);

  APDF.Text(30, 748, 10, Periodo, True);
  APDF.TextRight(APDF.PageWidth - 30, 748, 8,
    'Generado: ' + FormatDateTime('dd/mm/yyyy hh:nn', Now), False);

  APDF.Text(30, 731, 8,
    TextoCorto(TextoFiltroActual, 105), False);

  if Trim(Nif) <> '' then
    APDF.Text(30, 715, 8, 'NIF: ' + Nif, False);

  if Trim(Direccion) <> '' then
    APDF.Text(150, 715, 8,
      TextoCorto(Direccion + ' - ' + Localidad, 65), False);

  APDF.SetStrokeColor(0.75, 0.78, 0.80);
  APDF.SetLineWidth(0.7);
  APDF.Line(30, 704, APDF.PageWidth - 30, 704);

  AY := 680;
  DibujarCabeceraTablaPDF(APDF, AY);
end;

procedure TFLXInformacionVentasForm.DibujarCabeceraTablaPDF(
  APDF: TFLXPDFDocument; var AY: Double);
begin
  APDF.SetFillColor(0.10, 0.36, 0.40);
  APDF.FillRect(28, AY - 4, APDF.PageWidth - 56, 20);

  APDF.SetFillColor(1, 1, 1);
  APDF.Text(32, AY + 2, 7.5, 'Código', True);
  APDF.Text(88, AY + 2, 7.5, 'Descripción', True);
  APDF.Text(254, AY + 2, 7.5, 'Familia / proveedor', True);
  APDF.TextRight(400, AY + 2, 7.5, 'Uds.', True);
  APDF.TextRight(444, AY + 2, 7.5, 'PVP', True);
  APDF.TextRight(488, AY + 2, 7.5, 'Base', True);
  APDF.TextRight(528, AY + 2, 7.5, 'IVA', True);
  APDF.TextRight(566, AY + 2, 7.5, 'Total', True);

  AY := AY - 22;
end;

procedure TFLXInformacionVentasForm.GenerarPDF(
  const AArchivo: string);
var
  PDF: TFLXPDFDocument;
  I, Pagina: Integer;
  Y: Double;
  Info: string;
  TotalUds, TotalBase, TotalIVA, Total: Double;
begin
  if Length(FFilas) = 0 then
    raise Exception.Create('No hay datos para generar el PDF.');

  PDF := TFLXPDFDocument.Create;
  try
    Pagina := 1;
    DibujarCabeceraPDF(PDF, Y, Pagina);

    TotalUds := 0;
    TotalBase := 0;
    TotalIVA := 0;
    Total := 0;

    for I := 0 to High(FFilas) do
    begin
      if Y < 75 then
      begin
        Inc(Pagina);
        DibujarCabeceraPDF(PDF, Y, Pagina);
      end;

      if Odd(I) then
      begin
        PDF.SetFillColor(0.96, 0.97, 0.98);
        PDF.FillRect(28, Y - 4, PDF.PageWidth - 56, 16);
      end;

      PDF.SetFillColor(0.15, 0.18, 0.20);

      Info := '';
      if FFilas[I].FamiliaCodigo <> 0 then
        Info := IntToStr(FFilas[I].FamiliaCodigo);

      if Trim(FFilas[I].Familia) <> '' then
      begin
        if Info <> '' then Info := Info + ' ';
        Info := Info + FFilas[I].Familia;
      end;

      if FFilas[I].ProveedorCodigo <> 0 then
      begin
        if Info <> '' then Info := Info + ' / ';
        Info := Info + IntToStr(FFilas[I].ProveedorCodigo);
      end;

      if Trim(FFilas[I].Proveedor) <> '' then
      begin
        if Info <> '' then Info := Info + ' ';
        Info := Info + FFilas[I].Proveedor;
      end;

      PDF.Text(32, Y, 7.2,
        TextoCorto(FFilas[I].Codigo, 13), False);
      PDF.Text(88, Y, 7.2,
        TextoCorto(FFilas[I].Descripcion, 35), False);
      PDF.Text(254, Y, 6.6,
        TextoCorto(Info, 25), False);
      PDF.TextRight(400, Y, 7.2,
        FormatFloat('#,##0.00', FFilas[I].Unidades), False);
      PDF.TextRight(444, Y, 7.2,
        FormatFloat('#,##0.00', FFilas[I].PVPMedio), False);
      PDF.TextRight(488, Y, 7.2,
        FormatFloat('#,##0.00', FFilas[I].Base), False);
      PDF.TextRight(528, Y, 7.2,
        FormatFloat('#,##0.00', FFilas[I].IVA), False);
      PDF.TextRight(566, Y, 7.2,
        FormatFloat('#,##0.00', FFilas[I].Total), False);

      TotalUds := TotalUds + FFilas[I].Unidades;
      TotalBase := TotalBase + FFilas[I].Base;
      TotalIVA := TotalIVA + FFilas[I].IVA;
      Total := Total + FFilas[I].Total;

      Y := Y - 17;
    end;

    if Y < 95 then
    begin
      Inc(Pagina);
      DibujarCabeceraPDF(PDF, Y, Pagina);
    end;

    PDF.SetStrokeColor(0.10, 0.36, 0.40);
    PDF.SetLineWidth(1);
    PDF.Line(320, Y + 5, 566, Y + 5);

    PDF.SetFillColor(0.05, 0.25, 0.28);
    PDF.Text(320, Y - 12, 9, 'TOTALES', True);
    PDF.TextRight(400, Y - 12, 8,
      FormatFloat('#,##0.00', TotalUds), True);
    PDF.TextRight(488, Y - 12, 8,
      FormatFloat('#,##0.00', TotalBase), True);
    PDF.TextRight(528, Y - 12, 8,
      FormatFloat('#,##0.00', TotalIVA), True);
    PDF.TextRight(566, Y - 12, 8,
      FormatFloat('#,##0.00', Total), True);

    PDF.AddPageNumbers;
    PDF.SaveToFile(AArchivo);
  finally
    PDF.Free;
  end;
end;

procedure TFLXInformacionVentasForm.VistaPDFClick(Sender: TObject);
var
  Archivo: string;
begin
  try
    Archivo := ArchivoTemporalPDF;
    GenerarPDF(Archivo);
    OpenDocument(Archivo);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TFLXInformacionVentasForm.GuardarPDFClick(Sender: TObject);
var
  D: TSaveDialog;
begin
  if Length(FFilas) = 0 then
  begin
    MessageDlg('No hay datos para guardar.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  D := TSaveDialog.Create(Self);
  try
    D.Title := 'Guardar información de ventas';
    D.Filter := 'Documento PDF|*.pdf';
    D.DefaultExt := 'pdf';
    D.FileName := 'Informacion_ventas_' +
      FormatDateTime('yyyymmdd', Date) + '.pdf';

    if D.Execute then
    begin
      GenerarPDF(D.FileName);
      MessageDlg('PDF guardado correctamente.',
        mtInformation, [mbOK], 0);
    end;
  finally
    D.Free;
  end;
end;

procedure TFLXInformacionVentasForm.ImprimirClick(Sender: TObject);
var
  Archivo, Lpr: string;
  P: TProcess;
  Impreso: Boolean;
begin
  try
    Archivo := ArchivoTemporalPDF;
    GenerarPDF(Archivo);

    Impreso := False;
    Lpr := FindDefaultExecutablePath('lpr');

    if Lpr <> '' then
    begin
      P := TProcess.Create(nil);
      try
        P.Executable := Lpr;
        P.Parameters.Add(Archivo);
        P.Options := [poWaitOnExit];
        P.Execute;
        Impreso := P.ExitStatus = 0;
      finally
        P.Free;
      end;
    end;

    if not Impreso then
    begin
      OpenDocument(Archivo);
      MessageDlg(
        'No se pudo enviar directamente a lpr.' + LineEnding +
        'Se ha abierto el PDF para imprimir desde el visor.',
        mtInformation, [mbOK], 0);
    end;
  except
    on E: Exception do
      MessageDlg('No se pudo imprimir:' + LineEnding + E.Message,
        mtError, [mbOK], 0);
  end;
end;

function TFLXInformacionVentasForm.CSVTexto(
  const S: string): string;
begin
  Result := '"' +
    StringReplace(S, '"', '""', [rfReplaceAll]) + '"';
end;

procedure TFLXInformacionVentasForm.GuardarCSV(
  const AArchivo: string);
var
  SL: TStringList;
  FS: TFileStream;
  Data: UTF8String;
  BOM: array[0..2] of Byte;
  I: Integer;
  Fam, Prov: string;
begin
  SL := TStringList.Create;
  try
    SL.Add('Periodo;' +
      CSVTexto(FormatDateTime('dd/mm/yyyy', FDesde.Date)) + ';' +
      CSVTexto(FormatDateTime('dd/mm/yyyy', FHasta.Date)));
    SL.Add('Filtros;' + CSVTexto(TextoFiltroActual));
    SL.Add('');

    SL.Add(
      'Código;Descripción;Código familia;Familia;' +
      'Código proveedor;Proveedor;Unidades;PVP medio;' +
      'Dto. medio;Base;IVA;Total;Última venta');

    for I := 0 to High(FFilas) do
    begin
      Fam := FFilas[I].Familia;
      Prov := FFilas[I].Proveedor;

      SL.Add(
        CSVTexto(FFilas[I].Codigo) + ';' +
        CSVTexto(FFilas[I].Descripcion) + ';' +
        IntToStr(FFilas[I].FamiliaCodigo) + ';' +
        CSVTexto(Fam) + ';' +
        IntToStr(FFilas[I].ProveedorCodigo) + ';' +
        CSVTexto(Prov) + ';' +
        FormatFloat('0.00', FFilas[I].Unidades) + ';' +
        FormatFloat('0.00', FFilas[I].PVPMedio) + ';' +
        FormatFloat('0.00', FFilas[I].DtoMedio) + ';' +
        FormatFloat('0.00', FFilas[I].Base) + ';' +
        FormatFloat('0.00', FFilas[I].IVA) + ';' +
        FormatFloat('0.00', FFilas[I].Total) + ';' +
        CSVTexto(
          IfThen(FFilas[I].UltimaVenta > 0,
            FormatDateTime('dd/mm/yyyy', FFilas[I].UltimaVenta), '')
        )
      );
    end;

    FS := TFileStream.Create(AArchivo, fmCreate);
    try
      BOM[0] := $EF;
      BOM[1] := $BB;
      BOM[2] := $BF;
      FS.WriteBuffer(BOM, SizeOf(BOM));

      Data := UTF8String(SL.Text);
      if Length(Data) > 0 then
        FS.WriteBuffer(Data[1], Length(Data));
    finally
      FS.Free;
    end;
  finally
    SL.Free;
  end;
end;

procedure TFLXInformacionVentasForm.CSVClick(Sender: TObject);
var
  D: TSaveDialog;
begin
  if Length(FFilas) = 0 then
  begin
    MessageDlg('No hay datos para exportar.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  D := TSaveDialog.Create(Self);
  try
    D.Title := 'Exportar información de ventas';
    D.Filter := 'Archivo CSV|*.csv';
    D.DefaultExt := 'csv';
    D.FileName := 'Informacion_ventas_' +
      FormatDateTime('yyyymmdd', Date) + '.csv';

    if D.Execute then
    begin
      GuardarCSV(D.FileName);
      MessageDlg('CSV exportado correctamente.',
        mtInformation, [mbOK], 0);
    end;
  finally
    D.Free;
  end;
end;

procedure TFLXInformacionVentasForm.SalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFLXInformacionVentasForm.FormKeyDownInfo(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

{ TFLXInformacionVentasInstaller }

constructor TFLXInformacionVentasInstaller.Create(
  AOwner: TComponent);
begin
  inherited Create(AOwner);

  FInstalado := False;
  FTimer := TTimer.Create(Self);
  FTimer.Interval := 400;
  FTimer.OnTimer := @TimerTimer;
  FTimer.Enabled := True;
end;

destructor TFLXInformacionVentasInstaller.Destroy;
begin
  if Assigned(FTimer) then
    FTimer.Enabled := False;
  inherited Destroy;
end;

function TFLXInformacionVentasInstaller.SufijoSeguro(
  const S: string): Boolean;
var
  I: Integer;
begin
  Result := (Length(S) > 0) and (Length(S) <= 8);
  if not Result then Exit;

  for I := 1 to Length(S) do
    if not (S[I] in ['0'..'9']) then
      Exit(False);
end;

function TFLXInformacionVentasInstaller.BuscarPaginaListados(
  AControl: TWinControl): TTabSheet;
var
  I: Integer;
  C: TControl;
  S: string;
begin
  Result := nil;
  if not Assigned(AControl) then Exit;

  if AControl is TTabSheet then
  begin
    S := UpperCase(Trim(TTabSheet(AControl).Caption));
    if (AControl.Name = 'TabSheet3') or
       (Pos('LISTAD', S) > 0) then
      Exit(TTabSheet(AControl));
  end;

  for I := 0 to AControl.ControlCount - 1 do
  begin
    C := AControl.Controls[I];
    if C is TWinControl then
    begin
      Result := BuscarPaginaListados(TWinControl(C));
      if Assigned(Result) then Exit;
    end;
  end;
end;

function TFLXInformacionVentasInstaller.ConexionContieneHistorico(
  AConexion: TZConnection; const ASufijo: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;

  if not Assigned(AConexion) or not AConexion.Connected then
    Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConexion;
    Q.SQL.Text :=
      'SELECT COUNT(*) N FROM information_schema.tables ' +
      'WHERE table_schema=DATABASE() AND table_name=:T';
    Q.ParamByName('T').AsString := 'hisopcc' + ASufijo;
    Q.Open;
    Result := Q.FieldByName('N').AsInteger > 0;
  except
    Result := False;
  end;
  Q.Free;
end;

function TFLXInformacionVentasInstaller.BuscarConexion(
  AComponent: TComponent; const ASufijo: string): TZConnection;
var
  I: Integer;
begin
  Result := nil;
  if not Assigned(AComponent) then Exit;

  if AComponent is TZConnection then
    if ConexionContieneHistorico(
      TZConnection(AComponent), ASufijo) then
      Exit(TZConnection(AComponent));

  for I := 0 to AComponent.ComponentCount - 1 do
  begin
    Result := BuscarConexion(
      AComponent.Components[I], ASufijo);
    if Assigned(Result) then Exit;
  end;
end;

procedure TFLXInformacionVentasInstaller.CrearIconoBoton(
  ABoton: TBitBtn);
begin
  ABoton.Glyph.SetSize(38, 34);
  ABoton.Glyph.Canvas.Brush.Color := clWhite;
  ABoton.Glyph.Canvas.FillRect(0, 0, 38, 34);

  ABoton.Glyph.Canvas.Pen.Color := C_CABECERA;

  ABoton.Glyph.Canvas.Brush.Color := TColor($00D88A32);
  ABoton.Glyph.Canvas.Rectangle(5, 18, 11, 30);

  ABoton.Glyph.Canvas.Brush.Color := TColor($006EB45C);
  ABoton.Glyph.Canvas.Rectangle(15, 11, 22, 30);

  ABoton.Glyph.Canvas.Brush.Color := TColor($00D96B42);
  ABoton.Glyph.Canvas.Rectangle(26, 5, 34, 30);

  ABoton.Layout := blGlyphTop;
end;

procedure TFLXInformacionVentasInstaller.TimerTimer(Sender: TObject);
var
  I: Integer;
  F: TCustomForm;
  Pagina: TTabSheet;
  B: TBitBtn;
begin
  if FInstalado then
  begin
    FTimer.Enabled := False;
    Exit;
  end;

  for I := 0 to Screen.FormCount - 1 do
  begin
    F := Screen.Forms[I];

    if SameText(F.Name, 'FMenu') or
       SameText(F.ClassName, 'TFMenu') then
    begin
      Pagina := BuscarPaginaListados(F);
      if not Assigned(Pagina) then
        Continue;

      if Assigned(F.FindComponent('btnFLXInformacionVentas')) then
      begin
        FInstalado := True;
        FTimer.Enabled := False;
        Exit;
      end;

      B := TBitBtn.Create(F);
      B.Name := 'btnFLXInformacionVentas';
      B.Parent := Pagina;
      B.SetBounds(884, 8, 142, 80);
      B.Caption := 'Información' + LineEnding + 'de ventas';
      B.Hint :=
        'Consulta ventas por artículo, familia, proveedor o rango de códigos';
      B.ShowHint := True;
      B.Font.Name := 'Sans';
      B.Font.Height := -12;
      B.Font.Style := [fsBold];
      B.Color := C_AZUL_SUAVE;
      B.TabOrder := 10;
      B.OnClick := @BotonClick;
      CrearIconoBoton(B);

      FInstalado := True;
      FTimer.Enabled := False;
      Exit;
    end;
  end;
end;

procedure TFLXInformacionVentasInstaller.BotonClick(Sender: TObject);
var
  Conexion: TZConnection;
  Formulario: TFLXInformacionVentasForm;
  Sufijo: string;
begin
  Sufijo := Trim(Tienda);

  if not SufijoSeguro(Sufijo) then
  begin
    MessageDlg(
      'No se ha podido determinar la tienda actual.',
      mtError, [mbOK], 0);
    Exit;
  end;

  Conexion := BuscarConexion(Application, Sufijo);

  if not Assigned(Conexion) then
  begin
    MessageDlg(
      'No se ha encontrado la conexión principal activa ' +
      'que contiene el histórico de ventas.',
      mtError, [mbOK], 0);
    Exit;
  end;

  Formulario := TFLXInformacionVentasForm.CreateInforme(
    Application, Conexion, Sufijo);
  try
    Formulario.ShowModal;
  finally
    Formulario.Free;
  end;
end;

initialization
  GInstaller := TFLXInformacionVentasInstaller.Create(nil);

finalization
  FreeAndNil(GInstaller);

end.
