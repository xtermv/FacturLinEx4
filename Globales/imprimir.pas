{
  Gestion LinEx FacturLinEx

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit Imprimir;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Spin,
  lr_e_pdf, LR_DBSet, LR_Class,
  ZConnection, ZDataset,
  LCLType, Process,
  smtpsend, synacode,
  DB,
  ubarcodes,
  ZAbstractConnection, ZAbstractRODataset, ZExceptions, ZAbstractDataset, ZClasses, // ZEOS
  Crt;

// -----------------------------------------------------------------------------
// Flag global para controlar el comportamiento al imprimir desde FACTURAR.
// - False (por defecto): comportamiento normal (UI, export PDF, etc.)
// - True: desde FACTURAR solo se IMPRIME (se evita ExportTo(PDF)+Delay+esperas)
//   porque el PDF ya se genera por otro método (FPPDF).
//   Debe activarse temporalmente antes de llamar a Imprime(), y volver a False
//   al terminar (try/finally).
// -----------------------------------------------------------------------------
var
  VF_ImprimirFromFacturar: Boolean = False;

 // Delay()

type

  { TFImpresion }

  TFImpresion = class(TForm)
    BarcodeQR1: TBarcodeQR;
    btxml: TBitBtn;
    btOk1: TBitBtn;
    btCorreo: TBitBtn;
    btSalir: TBitBtn;
    cbFechasAlbaranes: TCheckBox;
    cbEsCopia: TCheckBox;
    cbDuplicado: TCheckBox;
    cbPVP: TCheckBox;
    cbprecio: TCheckBox;
    CheckBox1: TCheckBox;
    cbObservaciones: TCheckBox;
    cbEnviarCorreo: TCheckBox;
    CheckBoxAnexos: TCheckBox;

    dbCabecera: TZQuery;
    dbDatosCliente: TZQuery;
    dbQueryAnexos: TZQuery;
    dbImprimir: TZQuery;
    dbDetalles: TZQuery;
    dbTemporal: TZQuery;
    edDestinatarioCopia: TEdit;
    Edit1: TEdit;
    edDestinatario: TEdit;
    edAdjunto: TEdit;
    edAsunto: TEdit;

    frDBDataSet: TfrDBDataSet;
    frReport: TfrReport;
    frTNPDFExport: TfrTNPDFExport;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lbGenerando: TLabel;
    Label9: TLabel;
    mmTexto: TMemo;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    lbCopias: TLabel;
    Panel1: TPanel;
    PanelCorreo: TPanel;
    pnCabecera: TPanel;
    Panel10: TPanel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    sbBuscar: TSpeedButton;
    SpinEdit1: TSpinEdit;

    procedure btCorreoClick(Sender: TObject);
    procedure btOk1Click(Sender: TObject);
    procedure btSalirClick(Sender: TObject);
    procedure btxmlClick(Sender: TObject);
    procedure cbDuplicadoChange(Sender: TObject);
    procedure cbEnviarCorreoChange(Sender: TObject);
    procedure cbEsCopiaChange(Sender: TObject);
    procedure edDestinatarioChange(Sender: TObject);
    procedure edDestinatarioExit(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure frReportBeginDoc;
    procedure frReportBeginPage(pgNo: Integer);
    procedure frReportEndPage(pgNo: Integer);

    function Imprime(dbMuestrad: TZQuery; dbMuestrac: TZQuery; dbCliente: TZQuery;
                   TipoDocumento: String; directo: boolean; nCopias: integer): integer;
    procedure Imprime(TxtInforme: String; Informe: String; Titulo: String);
    procedure GeneraImpresion();
    procedure ImpDocumento();

    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);

    procedure CalculaIvas();

    procedure RadioGroup2Click(Sender: TObject);
    procedure sbBuscarClick(Sender: TObject);
    procedure VerRecargo();
    procedure frReportGetValue(const ParName: String; var ParValue: Variant);
    procedure frReportEnterRect(Memo: TStringList; View: TfrView);

    procedure ImpreTicket(dbMuestrad: TZQuery; dbMuestrac: TZQuery; dbCliente: TZQuery; TipoDocumento: String);
    procedure CabeceraTicket();
    procedure PieTicket();
    procedure EsVentas;
    procedure TipoImpreso();

    procedure BuscarAnexos();
    function GeneraKeyDelNodo():string;

    procedure CorreosElectronicos;
    function FirmarFactura(XMLFile: string): string;
  private
    { Modernización visual de la ventana de impresión. }
    pnlFormatoModerno: TPanel;
    pnlMetodoModerno: TPanel;
    pnlPDFModerno: TPanel;
    pnlOpcionesModerno: TPanel;
    pnlGenerandoModerno: TPanel;
    frmAvisoFlotante: TForm;
    lblAvisoFlotante: TLabel;
    lblTituloModerno: TLabel;
    lblSubtituloModerno: TLabel;
    lblOpcionesModerno: TLabel;
    FEstiloModernoAplicado: Boolean;
    FEsInformeSQL: Boolean;
    FCorreoClienteGestionado: Boolean;
    FCargandoCorreoCliente: Boolean;
    FCorreoClienteInicial: String;
    FCorreoUltimoEvaluado: String;
    procedure VF_AplicarEstiloModerno;
    procedure VF_ActualizarTituloModerno;
    procedure VF_CrearAvisoFlotante;
    procedure VF_OcultarAvisoFlotante;
    procedure VF_MostrarGenerandoPDF(const AVisible: Boolean);
    procedure VF_MostrarAvisoFrontal(const ATitulo, ATexto: String;
      const ADuracion: Integer; const AColor: TColor);
    function VF_HayClienteParaGuardarCorreo: Boolean;
    procedure VF_OfrecerGuardarCorreoCliente;
    function VF_GuardarCorreoEnFicha(const ACorreo: String;
      const AEnObservaciones: Boolean): Boolean;
  public
    { public declarations }
  end; 

var
  FImpresion: TFImpresion;
  BASE1,BASE2,BASE3,IMPOIVA1,IMPOIVA2,IMPOIVA3,TOTAL1,TOTAL2,TOTAL3: Double;
  IRIVA1,IRIVA2,IRIVA3,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PRIVA1,PRIVA2,PRIVA3:Double;
  Documento: String;
  DirectorioReport: String;
  Impreso: String;
  NombrePDF: String;
  TituloInforme: String;
  PrintText: TextFile;
  Impresiondirecta: boolean;
  nPagina: integer;                      //  Contador de páginas.
  SubTotalPagina, TotalPagina: Double;    // Variables para subtotales en report
  camposKey: integer;                    // Número de campos clave de la tabla
  CodigoSalida: integer;                 // Significado del código de salida de imprime :
                                         // 0 -> No se imprimió ni se envió por correo electrónico.
                                         // 1 -> Documento imprimido.
                                         // 2 -> Documento enviado por email.
                                         // 3 -> Documento imprimido y enviado por email.
  xml: integer;
  txtQR, DirectorioQR: String;

implementation

{$R *.lfm}

uses
  Global, Funciones, uFacturaE_Generator, uFacturaE_Signer,
  uFLXTemaVisual;

{ Helpers QR Veri*Factu -------------------------------------------------------
  Se dejan en Imprimir para que el QR de FACTURAS use la misma lógica
  que ventas.pas: modo producción tolerante, numserie con guiones
  y el importe siempre con punto decimal.
}
function VF_Imprimir_EsModoProduccion: Boolean;
var
  M: string;
begin
  M := UpperCase(Trim(vfMode));
  Result := (M = 'PRODUCCION') or (Copy(M, 1, 4) = 'PROD');
end;

function VF_Imprimir_QRImporte(const AImporte: Double): string;
begin
  // AEAT/QR espera punto decimal aunque el sistema esté en locale español.
  Result := StringReplace(FormatFloat('0.00', AImporte), ',', '.', [rfReplaceAll]);
end;

function VF_Imprimir_BuildQRTributarioFactura(const ASerie, ANumero: string;
  const AFecha: TDateTime; const AImporte: Double): string;
begin
  // Facturas completas: NO añadimos FS-.  La serie ya debe venir preparada
  // por el proceso que genera la factura (A26/B26/R26/etc.).
  Result := vfUrl + 'nif=' + NIF +
            '&numserie=' + Trim(ASerie) + '-' + Trim(ANumero) +
            '&fecha=' + FormatDateTime('dd-mm-yyyy', AFecha) +
            '&importe=' + VF_Imprimir_QRImporte(AImporte);
end;

{ TFImpresion }

procedure TFImpresion.VF_AplicarEstiloModerno;
const
  CFondo       = TColor($00F4F6F8);
  CTarjeta     = clWhite;
  CCabecera    = TColor($00654A16); // azul petróleo (BGR)
  CPrimario    = TColor($00967816);
  CVerde       = TColor($007A8B22);
  CRojo        = TColor($003C4FD9);
  CTexto       = TColor($00302A25);
  CTextoSuave  = TColor($00796F68);
  CBorde       = TColor($00DDD7D2);

  procedure PrepararPanel(var APanel: TPanel; const AName: String;
    ALeft, ATop, AWidth, AHeight: Integer);
  begin
    if not Assigned(APanel) then
    begin
      APanel := TPanel.Create(Self);
      APanel.Name := AName;
      APanel.Parent := Panel10;
      APanel.BevelOuter := bvNone;
      APanel.ParentBackground := False;
      APanel.Caption := '';
    end;
    APanel.SetBounds(ALeft, ATop, AWidth, AHeight);
    APanel.Color := CTarjeta;
    APanel.SendToBack;
  end;

  procedure EstiloEtiqueta(ALabel: TLabel; const AColor: TColor;
    const AHeight: Integer = -13; const ANegrita: Boolean = False);
  begin
    ALabel.ParentFont := False;
    ALabel.Font.Name := 'Sans';
    ALabel.Font.Height := AHeight;
    ALabel.Font.Color := AColor;
    if ANegrita then
      ALabel.Font.Style := [fsBold]
    else
      ALabel.Font.Style := [];
  end;

  procedure EstiloCampo(AEdit: TCustomEdit);
  begin
    { TCustomEdit no expone ParentFont en todas las versiones de LCL. }
    AEdit.Font.Name := 'Sans';
    AEdit.Font.Height := -13;
    AEdit.Font.Color := CTexto;
    AEdit.Color := clWhite;
  end;

  procedure EstiloBoton(AButton: TBitBtn; const AColor, AFontColor: TColor);
  begin
    AButton.ParentFont := False;
    AButton.Font.Name := 'Sans';
    AButton.Font.Height := -13;
    AButton.Font.Style := [fsBold];
    AButton.Font.Color := AFontColor;
    AButton.Color := AColor;
    AButton.Margin := 8;
    AButton.Spacing := 8;
  end;

var
  I: Integer;
begin
  if FEstiloModernoAplicado then Exit;
  FEstiloModernoAplicado := True;

  Caption := 'FacturLinEx · Impresión de documentos';
  Color := CFondo;
  Font.Name := 'Sans';
  Font.Height := -13;
  Position := poScreenCenter;
  BorderStyle := bsSingle;
  ClientWidth := 1090;
  ClientHeight := 745;

  Panel10.ParentBackground := False;
  Panel10.Color := CFondo;
  Panel10.BevelOuter := bvNone;

  // Cabecera coherente con la nueva pantalla de ventas.
  pnCabecera.ParentBackground := False;
  pnCabecera.Color := CCabecera;
  pnCabecera.BevelOuter := bvNone;
  pnCabecera.Height := 84;

  if not Assigned(lblTituloModerno) then
  begin
    lblTituloModerno := TLabel.Create(Self);
    lblTituloModerno.Name := 'lblTituloImpresionModerno';
    lblTituloModerno.Parent := pnCabecera;
    lblTituloModerno.Transparent := True;
    lblTituloModerno.AutoSize := False;
  end;
  lblTituloModerno.SetBounds(24, 12, 500, 30);
  EstiloEtiqueta(lblTituloModerno, clWhite, -22, True);
  lblTituloModerno.Caption := 'Impresión de documentos';

  if not Assigned(lblSubtituloModerno) then
  begin
    lblSubtituloModerno := TLabel.Create(Self);
    lblSubtituloModerno.Name := 'lblSubtituloImpresionModerno';
    lblSubtituloModerno.Parent := pnCabecera;
    lblSubtituloModerno.Transparent := True;
    lblSubtituloModerno.AutoSize := False;
  end;
  lblSubtituloModerno.SetBounds(25, 45, 500, 22);
  EstiloEtiqueta(lblSubtituloModerno, TColor($00DED7D1), -12, False);
  lblSubtituloModerno.Caption := 'Formato, método de salida y opciones del documento';

  btOk1.SetBounds(548, 14, 150, 54);
  btOk1.Caption := 'Continuar';
  EstiloBoton(btOk1, CVerde, clWhite);
  btCorreo.SetBounds(708, 14, 126, 54);
  btCorreo.Caption := 'Correo';
  EstiloBoton(btCorreo, CPrimario, clWhite);
  btxml.SetBounds(844, 14, 112, 54);
  btxml.Caption := 'XML';
  EstiloBoton(btxml, TColor($008A817B), clWhite);
  btSalir.SetBounds(966, 14, 106, 54);
  btSalir.Caption := 'Cerrar';
  EstiloBoton(btSalir, CRojo, clWhite);

  // Tarjetas principales. Los controles se convierten en hijos reales de
  // cada tarjeta para evitar que GTK oculte labels y checkboxes detrás de
  // paneles con ventana propia.
  PrepararPanel(pnlFormatoModerno, 'pnlFormatoImpresionModerno', 24, 102, 500, 174);
  PrepararPanel(pnlMetodoModerno, 'pnlMetodoImpresionModerno', 542, 102, 524, 174);
  PrepararPanel(pnlPDFModerno, 'pnlPDFImpresionModerno', 24, 292, 1042, 78);
  PrepararPanel(pnlOpcionesModerno, 'pnlOpcionesImpresionModerno', 24, 386, 500, 326);

  RadioGroup1.Parent := pnlFormatoModerno;
  RadioGroup1.SetBounds(16, 14, 468, 144);
  RadioGroup1.Caption := '  Formato del documento  ';
  RadioGroup1.ParentBackground := False;
  RadioGroup1.ParentColor := False;
  RadioGroup1.Color := CTarjeta;
  RadioGroup1.ParentFont := False;
  RadioGroup1.Font.Name := 'Sans';
  RadioGroup1.Font.Height := -13;
  RadioGroup1.Font.Color := CTexto;

  RadioGroup2.Parent := pnlMetodoModerno;
  RadioGroup2.SetBounds(16, 14, 298, 144);
  RadioGroup2.Caption := '  Método de salida  ';
  RadioGroup2.ParentBackground := False;
  RadioGroup2.ParentColor := False;
  RadioGroup2.Color := CTarjeta;
  RadioGroup2.ParentFont := False;
  RadioGroup2.Font.Name := 'Sans';
  RadioGroup2.Font.Height := -13;
  RadioGroup2.Font.Color := CTexto;

  // QR VeriFactu integrado en la tarjeta del método de salida.
  Panel1.Parent := pnlMetodoModerno;
  Panel1.SetBounds(342, 14, 158, 144);
  Panel1.Caption := '';
  Panel1.BevelOuter := bvNone;
  Panel1.ParentBackground := False;
  Panel1.Color := clWhite;
  Label9.SetBounds(8, 6, 142, 22);
  Label9.Alignment := taCenter;
  Label9.Caption := 'QR veri*factu';
  Label9.Color := clWhite;
  EstiloEtiqueta(Label9, CCabecera, -12, True);
  BarcodeQR1.SetBounds(18, 30, 122, 108);

  // Nombre de PDF y copias en una única banda clara.
  Label1.Parent := pnlPDFModerno;
  Label1.SetBounds(16, 10, 200, 20);
  Label1.Caption := 'Archivo PDF a generar';
  EstiloEtiqueta(Label1, CTextoSuave, -12, True);

  Edit1.Parent := pnlPDFModerno;
  Edit1.SetBounds(16, 34, 772, 31);
  EstiloCampo(Edit1);

  lbCopias.Parent := pnlPDFModerno;
  lbCopias.SetBounds(820, 10, 150, 20);
  lbCopias.Caption := 'Copias';
  EstiloEtiqueta(lbCopias, CTextoSuave, -12, True);

  SpinEdit1.Parent := pnlPDFModerno;
  SpinEdit1.SetBounds(820, 34, 90, 31);
  SpinEdit1.ParentFont := False;
  SpinEdit1.Font.Name := 'Sans';
  SpinEdit1.Font.Height := -13;
  SpinEdit1.Color := clWhite;

  // El antiguo aviso incrustado se mantiene oculto. En GTK los controles
  // nativos pueden dibujarse por encima de paneles hermanos aunque se altere
  // el orden Z. Los avisos se muestran ahora en una única ventana flotante.
  if Assigned(pnlGenerandoModerno) then
    pnlGenerandoModerno.Visible := False;
  lbGenerando.Visible := False;

  if not Assigned(lblOpcionesModerno) then
  begin
    lblOpcionesModerno := TLabel.Create(Self);
    lblOpcionesModerno.Name := 'lblOpcionesImpresionModerno';
    lblOpcionesModerno.Transparent := True;
    lblOpcionesModerno.AutoSize := False;
  end;
  lblOpcionesModerno.Parent := pnlOpcionesModerno;
  lblOpcionesModerno.SetBounds(20, 16, 450, 24);
  lblOpcionesModerno.Caption := 'Opciones del documento';
  EstiloEtiqueta(lblOpcionesModerno, CCabecera, -15, True);

  // Primera columna: contenido y precios.
  cbFechasAlbaranes.Parent := pnlOpcionesModerno;
  cbFechasAlbaranes.SetBounds(20, 54, 300, 24);
  cbObservaciones.Parent := pnlOpcionesModerno;
  cbObservaciones.SetBounds(20, 92, 300, 24);
  cbprecio.Parent := pnlOpcionesModerno;
  cbprecio.SetBounds(20, 130, 300, 24);
  cbPVP.Parent := pnlOpcionesModerno;
  cbPVP.SetBounds(20, 168, 300, 24);

  // Segunda zona: formato especial y marcas del documento.
  CheckBox1.Parent := pnlOpcionesModerno;
  CheckBox1.SetBounds(20, 214, 220, 24);
  cbDuplicado.Parent := pnlOpcionesModerno;
  cbDuplicado.SetBounds(250, 214, 220, 24);
  cbEsCopia.Parent := pnlOpcionesModerno;
  cbEsCopia.SetBounds(250, 252, 220, 24);
  CheckBoxAnexos.Parent := pnlOpcionesModerno;
  CheckBoxAnexos.SetBounds(20, 252, 220, 24);

  for I := 0 to pnlOpcionesModerno.ControlCount - 1 do
    if pnlOpcionesModerno.Controls[I] is TCheckBox then
      with TCheckBox(pnlOpcionesModerno.Controls[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -13;
        Font.Color := CTexto;
      end;

  // Correo como tarjeta completa a la derecha.
  cbEnviarCorreo.SetBounds(562, 394, 300, 26);
  cbEnviarCorreo.ParentFont := False;
  cbEnviarCorreo.Font.Name := 'Sans';
  cbEnviarCorreo.Font.Height := -13;
  cbEnviarCorreo.Font.Style := [fsBold];
  cbEnviarCorreo.Font.Color := CCabecera;

  PanelCorreo.SetBounds(542, 424, 524, 288);
  PanelCorreo.BevelOuter := bvNone;
  PanelCorreo.ParentBackground := False;
  PanelCorreo.Color := CTarjeta;
  Label2.SetBounds(18, 12, 488, 25);
  Label2.Alignment := taLeftJustify;
  Label2.Caption := 'Datos del correo electrónico';
  EstiloEtiqueta(Label2, CCabecera, -15, True);

  Label3.SetBounds(18, 52, 72, 20);
  Label7.SetBounds(18, 88, 72, 20);
  Label4.SetBounds(18, 124, 72, 20);
  Label5.SetBounds(18, 160, 72, 20);
  Label6.SetBounds(18, 196, 72, 20);
  EstiloEtiqueta(Label3, CTextoSuave, -12, True);
  EstiloEtiqueta(Label7, CTextoSuave, -12, True);
  EstiloEtiqueta(Label4, CTextoSuave, -12, True);
  EstiloEtiqueta(Label5, CTextoSuave, -12, True);
  EstiloEtiqueta(Label6, CTextoSuave, -12, True);

  edDestinatario.SetBounds(92, 46, 412, 29);
  edDestinatarioCopia.SetBounds(92, 82, 412, 29);
  edAsunto.SetBounds(92, 118, 412, 29);
  edAdjunto.SetBounds(92, 154, 374, 29);
  sbBuscar.SetBounds(472, 154, 32, 29);
  mmTexto.SetBounds(92, 190, 412, 82);
  EstiloCampo(edDestinatario);
  EstiloCampo(edDestinatarioCopia);
  EstiloCampo(edAsunto);
  EstiloCampo(edAdjunto);
  mmTexto.ParentFont := False;
  mmTexto.Font.Name := 'Sans';
  mmTexto.Font.Height := -13;
  mmTexto.Font.Color := CTexto;
  mmTexto.Color := clWhite;

  // Asegura el orden visual dentro de cada tarjeta.
  RadioGroup1.BringToFront;
  RadioGroup2.BringToFront;
  Panel1.BringToFront;
  Label1.BringToFront;
  Edit1.BringToFront;
  lbCopias.BringToFront;
  SpinEdit1.BringToFront;
  lblOpcionesModerno.BringToFront;
  cbFechasAlbaranes.BringToFront;
  cbObservaciones.BringToFront;
  cbprecio.BringToFront;
  cbPVP.BringToFront;
  CheckBox1.BringToFront;
  cbDuplicado.BringToFront;
  cbEsCopia.BringToFront;
  CheckBoxAnexos.BringToFront;
  cbEnviarCorreo.BringToFront;
  PanelCorreo.BringToFront;
  pnCabecera.BringToFront;
end;

procedure TFImpresion.VF_CrearAvisoFlotante;
begin
  if Assigned(frmAvisoFlotante) then Exit;

  frmAvisoFlotante := TForm.CreateNew(Self);
  frmAvisoFlotante.Name := '';
  frmAvisoFlotante.Caption := '';
  frmAvisoFlotante.BorderStyle := bsNone;
  frmAvisoFlotante.FormStyle := fsStayOnTop;
  frmAvisoFlotante.Position := poDesigned;
  frmAvisoFlotante.Width := 600;
  frmAvisoFlotante.Height := 116;
  frmAvisoFlotante.Color := clNavy;
  frmAvisoFlotante.Visible := False;

  lblAvisoFlotante := TLabel.Create(frmAvisoFlotante);
  lblAvisoFlotante.Name := '';
  lblAvisoFlotante.Parent := frmAvisoFlotante;
  lblAvisoFlotante.Align := alClient;
  lblAvisoFlotante.AutoSize := False;
  lblAvisoFlotante.Transparent := False;
  lblAvisoFlotante.Color := clNavy;
  lblAvisoFlotante.Alignment := taCenter;
  lblAvisoFlotante.Layout := tlCenter;
  lblAvisoFlotante.WordWrap := True;
  lblAvisoFlotante.ParentFont := False;
  lblAvisoFlotante.Font.Name := 'Sans';
  lblAvisoFlotante.Font.Height := -16;
  lblAvisoFlotante.Font.Style := [fsBold];
  lblAvisoFlotante.Font.Color := clWhite;
  lblAvisoFlotante.Caption := '';
end;

procedure TFImpresion.VF_OcultarAvisoFlotante;
begin
  if not Assigned(frmAvisoFlotante) then Exit;

  frmAvisoFlotante.Hide;
  if Assigned(lblAvisoFlotante) then
    lblAvisoFlotante.Caption := '';
  Application.ProcessMessages;
end;

procedure TFImpresion.VF_MostrarGenerandoPDF(const AVisible: Boolean);
var
  P: TPoint;
begin
  VF_CrearAvisoFlotante;

  if AVisible then
  begin
    { Limpiamos y ocultamos antes de reutilizar la ventana. Así GTK no conserva
      restos del mensaje anterior en el búfer de dibujo. }
    VF_OcultarAvisoFlotante;

    frmAvisoFlotante.Color := $00C07020;
    lblAvisoFlotante.Color := frmAvisoFlotante.Color;
    frmAvisoFlotante.Width := 600;
    frmAvisoFlotante.Height := 116;
    lblAvisoFlotante.Caption := 'GENERANDO FICHERO PDF...';

    P := ClientToScreen(Point((ClientWidth - frmAvisoFlotante.Width) div 2,
      (ClientHeight - frmAvisoFlotante.Height) div 2));
    frmAvisoFlotante.Left := P.X;
    frmAvisoFlotante.Top := P.Y;

    frmAvisoFlotante.Show;
    frmAvisoFlotante.BringToFront;
    frmAvisoFlotante.Update;
    lblAvisoFlotante.Update;
    Application.ProcessMessages;
    Sleep(60);
    Application.ProcessMessages;
  end
  else
    VF_OcultarAvisoFlotante;
end;

procedure TFImpresion.VF_MostrarAvisoFrontal(const ATitulo, ATexto: String;
  const ADuracion: Integer; const AColor: TColor);
var
  P: TPoint;
  Espera: Integer;
  Inicio: QWord;
  TextoAviso: String;
begin
  VF_CrearAvisoFlotante;
  VF_OcultarAvisoFlotante;

  TextoAviso := Trim(ATitulo);
  if Trim(ATexto) <> '' then
  begin
    if TextoAviso <> '' then
      TextoAviso := TextoAviso + LineEnding + Trim(ATexto)
    else
      TextoAviso := Trim(ATexto);
  end;

  frmAvisoFlotante.Color := AColor;
  lblAvisoFlotante.Color := frmAvisoFlotante.Color;
  frmAvisoFlotante.Width := 600;
  frmAvisoFlotante.Height := 132;
  lblAvisoFlotante.Caption := TextoAviso;

  P := ClientToScreen(Point((ClientWidth - frmAvisoFlotante.Width) div 2,
    (ClientHeight - frmAvisoFlotante.Height) div 2));
  frmAvisoFlotante.Left := P.X;
  frmAvisoFlotante.Top := P.Y;

  frmAvisoFlotante.Show;
  frmAvisoFlotante.BringToFront;
  frmAvisoFlotante.Update;
  lblAvisoFlotante.Update;
  Application.ProcessMessages;

  Espera := ADuracion;
  if Espera < 250 then Espera := 250;
  Inicio := GetTickCount64;
  while (GetTickCount64 - Inicio) < QWord(Espera) do
  begin
    Application.ProcessMessages;
    Sleep(20);
  end;

  VF_OcultarAvisoFlotante;
end;

procedure TFImpresion.VF_ActualizarTituloModerno;
var
  DocTexto: String;
begin
  if not Assigned(lblTituloModerno) then Exit;

  DocTexto := Trim(Documento);
  if DocTexto = '' then
    DocTexto := 'documento';

  if FEsInformeSQL then
  begin
    if SameText(DocTexto, 'ListaFacturas') then
      lblTituloModerno.Caption := 'Listado de facturas'
    else if Trim(TituloInforme) <> '' then
      lblTituloModerno.Caption := Trim(TituloInforme)
    else
      lblTituloModerno.Caption := 'Impresión de listado';
  end
  else if SameText(DocTexto, 'FACTURA') then
    lblTituloModerno.Caption := 'Impresión de factura'
  else if SameText(DocTexto, 'ALBARAN') then
    lblTituloModerno.Caption := 'Impresión de albarán'
  else
    lblTituloModerno.Caption := 'Impresión de ' + LowerCase(DocTexto);

  lblSubtituloModerno.Caption :=
    'Seleccione el formato, el método de salida y las opciones antes de continuar';
  Caption := 'FacturLinEx · ' + lblTituloModerno.Caption;
end;

procedure TFImpresion.edDestinatarioChange(Sender: TObject);
begin
  if FCargandoCorreoCliente then Exit;

  { Si el usuario vuelve a modificar el destinatario, permitimos que la
    consulta se muestre de nuevo al abandonar el campo. }
  if not SameText(Trim(edDestinatario.Text),
                  Trim(FCorreoUltimoEvaluado)) then
    FCorreoClienteGestionado := False;
end;

procedure TFImpresion.edDestinatarioExit(Sender: TObject);
var
  CorreoActualCampo: String;
begin
  if FCargandoCorreoCliente then Exit;

  CorreoActualCampo := Trim(edDestinatario.Text);
  if SameText(CorreoActualCampo, Trim(FCorreoUltimoEvaluado)) then Exit;

  { La misma consulta se realiza al terminar de editar el correo. De este
    modo funciona tanto al añadir uno nuevo como al corregir uno existente. }
  VF_OfrecerGuardarCorreoCliente;
  FCorreoUltimoEvaluado := Trim(edDestinatario.Text);
end;

function TFImpresion.VF_HayClienteParaGuardarCorreo: Boolean;
begin
  Result := Assigned(dbDatosCliente) and dbDatosCliente.Active and
            (not dbDatosCliente.IsEmpty) and
            Assigned(dbDatosCliente.FindField('C0')) and
            Assigned(dbDatosCliente.FindField('C1')) and
            Assigned(dbDatosCliente.FindField('C40')) and
            Assigned(dbDatosCliente.FindField('C36')) and
            (Trim(dbDatosCliente.FieldByName('C0').AsString) <> '');
end;

function TFImpresion.VF_GuardarCorreoEnFicha(const ACorreo: String;
  const AEnObservaciones: Boolean): Boolean;
var
  Observaciones, LineaCorreo: String;
begin
  Result := False;
  if not VF_HayClienteParaGuardarCorreo then Exit;

  try
    dbDatosCliente.Edit;

    if AEnObservaciones then
    begin
      Observaciones := dbDatosCliente.FieldByName('C36').AsString;

      { Evitamos añadir exactamente el mismo correo varias veces. }
      if Pos(LowerCase(Trim(ACorreo)), LowerCase(Observaciones)) = 0 then
      begin
        LineaCorreo := 'E-mail adicional (' +
          FormatDateTime('dd/mm/yyyy', Date) + '): ' + Trim(ACorreo);
        if Trim(Observaciones) <> '' then
          Observaciones := Observaciones + LineEnding;
        dbDatosCliente.FieldByName('C36').AsString :=
          Observaciones + LineaCorreo;
      end;
    end
    else
    begin
      dbDatosCliente.FieldByName('C40').AsString := Trim(ACorreo);
      FCorreoClienteInicial := Trim(ACorreo);
    end;

    dbDatosCliente.Post;
    Result := True;
  except
    on E: Exception do
    begin
      if dbDatosCliente.State in dsEditModes then
        dbDatosCliente.Cancel;
      VF_MostrarAvisoFrontal('No se pudo actualizar el cliente',
        'El correo se ha enviado, pero no se pudo guardar en la ficha: ' +
        E.Message, 3500, clRed);
    end;
  end;
end;

procedure TFImpresion.VF_OfrecerGuardarCorreoCliente;
var
  CorreoNuevo, CorreoActual, NombreCliente, TextoPregunta: String;
  Respuesta: Integer;
begin
  if FCorreoClienteGestionado then Exit;
  if not VF_HayClienteParaGuardarCorreo then Exit;

  CorreoNuevo := Trim(edDestinatario.Text);
  if CorreoNuevo = '' then Exit;

  CorreoActual := Trim(dbDatosCliente.FieldByName('C40').AsString);
  if SameText(CorreoNuevo, CorreoActual) then Exit;

  FCorreoClienteGestionado := True;
  NombreCliente := Trim(dbDatosCliente.FieldByName('C1').AsString);
  if NombreCliente = '' then
    NombreCliente := 'código ' +
      Trim(dbDatosCliente.FieldByName('C0').AsString);

  if CorreoActual = '' then
    TextoPregunta :=
      'El cliente ' + NombreCliente + ' no tiene e-mail en su ficha.' +
      LineEnding + LineEnding +
      'Correo utilizado: ' + CorreoNuevo + LineEnding + LineEnding +
      '¿Dónde desea guardarlo?' + LineEnding +
      'SÍ: como e-mail principal del cliente.' + LineEnding +
      'NO: añadirlo al campo Observaciones.' + LineEnding +
      'CANCELAR: no guardar el correo.'
  else
    TextoPregunta :=
      'El cliente ' + NombreCliente + ' ya tiene este e-mail:' +
      LineEnding + CorreoActual + LineEnding + LineEnding +
      'Correo utilizado ahora: ' + CorreoNuevo + LineEnding + LineEnding +
      '¿Qué desea hacer?' + LineEnding +
      'SÍ: sustituir el e-mail principal.' + LineEnding +
      'NO: añadir el nuevo correo a Observaciones.' + LineEnding +
      'CANCELAR: no modificar la ficha.';

  Respuesta := Application.MessageBox(PChar(TextoPregunta),
    'FacturLinEx · Guardar e-mail del cliente',
    MB_ICONQUESTION + MB_YESNOCANCEL);

  case Respuesta of
    IDYES:
      if VF_GuardarCorreoEnFicha(CorreoNuevo, False) then
        VF_MostrarAvisoFrontal('Ficha de cliente actualizada',
          'El correo se ha guardado como e-mail principal.', 2200, clGreen);
    IDNO:
      if VF_GuardarCorreoEnFicha(CorreoNuevo, True) then
        VF_MostrarAvisoFrontal('Ficha de cliente actualizada',
          'El correo se ha añadido a Observaciones.', 2200, clGreen);
  end;
end;

function TFImpresion.Imprime(dbMuestrad: TZQuery; dbMuestrac: TZQuery; dbCliente: TZQuery;
                   TipoDocumento: String; directo: boolean; nCopias:integer): integer;
var
  PDFCreado: Boolean;
  InicioContador: integer;

begin
  with TFImpresion.Create(Application) do
    begin
       FEsInformeSQL := False;
       xml:= 0;

       txtQR := '';

       ImpresionDirecta:= directo;
       dbDatosCliente:= dbCliente;
       dbCabecera:= dbMuestrac;
       dbDetalles:= dbMuestrad;
       Documento:=TipoDocumento;
       Impreso:='';

  //  Asigna valor correcto para el QR de verifactu
  //-------------------------------------------------
  //{ //-- Estudiar la posibilidad de poner un if que no lo ejecute en caso de ser Albaran, así podremos seguir usando fieldbyname('FC9') etc
  //     BarcodeQR1.Text:=txtQR+'numserie='+dbCabecera.Fields[2].AsString+'%2F'+dbCabecera.Fields[3].AsString
  //                             +'&fecha='+FormatDateTime('dd-mm-yyyy',dbCabecera.Fields[1].AsDateTime)
  //                             +'&importe='+FormatFloat('0.00',dbCabecera.Fields[9].AsFloat);

 //      BarcodeQR1.Text:= TextoCodigoQR;                    // ' FacturLinEx Veri*factu 4.0 ';

       if VF_Imprimir_EsModoProduccion and (UpperCase(Trim(Documento)) = 'FACTURA') then
         BarcodeQR1.Text := VF_Imprimir_BuildQRTributarioFactura(
                            dbCabecera.Fields[2].AsString,
                            dbCabecera.Fields[3].AsString,
                            dbCabecera.Fields[1].AsDateTime,
                            dbCabecera.Fields[9].AsFloat)
       else
         BarcodeQR1.Text := TextoCodigoQR;

       txtQR := BarcodeQR1.Text;

       DirectorioQR:='';

       if DirectoryExists(RutaPdf) then DirectorioQR:=RutaPdf+'/QR.png'
                                else DirectorioQR:= IncludeTrailingPathDelimiter(RutaIni)+'QR.png';

       if FileExists(DirectorioQR) then DeleteFile(DirectorioQR);
                                                                // Creamos el fichero QR para incluir en el report.

       BarcodeQR1.SaveToFile(DirectorioQR, TPortableNetworkGraphic);

       if Documento='FACTURA' then
         begin
           cbFechasAlbaranes.Enabled:= True;
           cbObservaciones.Enabled:=False;
         end
       else
         begin
           cbFechasAlbaranes.Enabled:= False;
           cbObservaciones.Enabled:=True;
         end;

       if copy(TipoDocumento,1,1)='V' then begin EsVentas; Exit; end;

       //showmessage(RutaPDF);

       if DirectoryExists(RutaPdf) then
              NombrePDF:= RutaPdf+copy(Documento,1,3)+'_'+dbCabecera.Fields[2].AsString
                        +'_'+dbCabecera.Fields[3].AsString+'.pdf' else
              NombrePDF:= RutaIni+copy(Documento,1,3)+'_'+dbCabecera.Fields[2].AsString
                        +'_'+dbCabecera.Fields[3].AsString+'.pdf';
       Caption:='Imprimiendo '+Documento;
       spinEdit1.Value:= dbDatosCliente.FieldByName('C8').AsInteger;
       if spinEdit1.Value=0 then spinEdit1.Value:=1;

 //        cbEnviarCorreo.Checked:= False;
       cbEnviarCorreo.Checked:= dbDatosCliente.FieldByName('C55').AsBoolean;
 //      cbEnviarCorreoChange(self);             // Desactivamos/activamos envíos email.
       CorreosElectronicos;                    // Cargamos datos para envío de email

       if (directo=true) then
         begin
             ImpDocumento();
             TipoImpreso();
             
             // ==== PREPARADO TEMPORAL MIENTRAS LLEGAN LOS CAMBIOS DE XAIME ===
             // ---- IMPRIMIR DE VERDAD EN MODO DIRECTO (sin PDF) ----
             frReport.LoadFromFile(Impreso);
             frReport.PrepareReport;
             //frReport.PrintPreparedReport('', SpinEdit1.Value);
             //SpinEdit1 y nCopias toman sus valores de la ficha de cliente.
             frReport.PrintPreparedReport('',nCopias);
             // ------------------------------------------------------
             
             CodigoSalida := 1;
           Result:= 1;                                 //Código de salida = 1 ( Imprimido )
             Close();
             exit;
         end;

       //Si el módulo AsistenteParaAnexos está instalado,
       //activa el CheckBox para buscar posibles anexos
       if (AsistenteAnexos='S') then
         begin
           CheckBoxAnexos.Visible:=True;
           CheckBoxAnexos.Checked:=True;
         end;

       CodigoSalida := 0;

       ShowModal;

       if CodigoSalida <> -1 then Result:= CodigoSalida;

  end;
end;

procedure TFImpresion.Imprime(TxtInforme: String; Informe: String; Titulo: String);
begin
    with TFImpresion.Create(Application) do
    begin
       FEsInformeSQL := True;
       dbDetalles.Active:=False;
       dbDetalles.SQL.Text:= TxtInforme;
       dbDetalles.Active:=True;
       TituloInforme:= Titulo;
       Documento:=Informe;
       Impreso:=DirectorioReport+Informe+'.lrf';
       if DirectoryExists(RutaPdf) then
              NombrePDF:= RutaPdf+'/'+'Informe_'+FormatDateTime('yyyymmdd',now)+'.pdf' else
              NombrePDF:= RutaIni+'Informe_'+FormatDateTime('yyyymmdd',now)+'.pdf';
       Caption:='Imprimiendo informe';
       spinEdit1.Value:=1;
       RadioGroup1.Enabled:=False;
       CheckBox1.Enabled:=False;
       cbObservaciones.Enabled:=False;
       cbPVP.Enabled:=False;
       cbPrecio.Enabled:=False;

       CodigoSalida:= 0;

       ShowModal;
    end;
end;

procedure TFImpresion.btOk1Click(Sender: TObject);
begin
   // No usar Caption para distinguir el modo: FormShow actualiza el título
   // visual y puede cambiarlo. La bandera conserva el modo real.
   if FEsInformeSQL then
     begin
       frDBDataSet.DataSet:=dbDetalles;
       GeneraImpresion();
       btSalirClick(Self);
     end else
     begin
      ImpDocumento();
      TipoImpreso();
      GeneraImpresion();
      if (CodigoSalida = 0) or (CodigoSalida = 2) then CodigoSalida:= CodigoSalida + 1;

      { El correo y su aviso deben finalizar antes de cerrar esta ventana.
        Si se cierra primero, el aviso queda detrás del formulario modal. }
      btCorreoClick(Self);
      btSalirClick(Self);
     end;
      // Imprime Facturas/albaranes
end;

procedure TFImpresion.btCorreoClick(Sender: TObject);
var

  SMTP: TSMTPSend;
  Encabezados, Cuerpo, Adjunto, MensajeCompleto, Boundary: String;
  Archivo: TFileStream;
  Base64Str: AnsiString;
  MemStream: TMemoryStream;
  InputStr: AnsiString;
  Mensaje: TStringList; // Usar TStringList para MailData
  DestinatariosCC: TStringList; // Lista de destinatarios en CC
  ContDest: Integer; // Contador de destinatarios CC
  ArchivoSalida: Text; // Variable para el archivo de texto

begin

  InputStr := '';

  if not cbEnviarCorreo.Checked then exit;

  if CorreoEmisor='' then begin
                                   VF_MostrarAvisoFrontal('Información', 'Falta correo electrónico del EMISOR', 2000, clRed);
                                   exit;
                                  end;

  if edDestinatario.Text='' then begin
                                   VF_MostrarAvisoFrontal('Información', 'Falta correo electrónico del cliente', 2000, clRed);
                                   exit;
                                  end;

  // Asociar la variable ArchivoSalida con un archivo físico
  AssignFile(ArchivoSalida, 'salida.txt');

// Definir un boundary único para el mensaje MIME
  Boundary := 'frontier';

  // Lista de destinatarios en CC (separados por comas)
  DestinatariosCC := TStringList.Create;
  try
     DestinatariosCC.CommaText := edDestinatarioCopia.Text; // Destinatarios en CC

    // Construir los encabezados con los valores de las cajas de texto
  Encabezados :=
    'From: ' + CorreoEmisor + #13#10 + // Campo From
    'To: ' + edDestinatario.Text + #13#10 + // Campo To
    'Cc: ' + DestinatariosCC.CommaText + #13#10 + // Encabezado CC
    'Subject: ' + edAsunto.Text + #13#10 + // Campo Subject
    'Date: ' + FormatDateTime('ddd, dd mmm yyyy hh:nn:ss', Now) + ' +0200' + #13#10 +
    'MIME-Version: 1.0' + #13#10 +
    'Content-Type: multipart/mixed; boundary="' + Boundary + '"' + #13#10 +
    #13#10;

  // Construir el cuerpo del mensaje con el contenido del TMemo
   Cuerpo :=
    '--' + Boundary + #13#10 +
    'Content-Type: text/plain; charset=UTF-8' + #13#10 +
    #13#10 +
    mmTexto.Lines.Text + #13#10;

  // Construir la parte del archivo adjunto
    if FileExists(edAdjunto.Text) then // Cambia por la ruta de tu archivo
    begin
      Archivo := TFileStream.Create(edAdjunto.Text, fmOpenRead);
      try
        MemStream := TMemoryStream.Create;
        try
       // Copiar el contenido del archivo al MemoryStream
          MemStream.CopyFrom(Archivo, Archivo.Size);
          MemStream.Position := 0;

          // Convertir el contenido del MemoryStream a AnsiString
          SetLength(InputStr, MemStream.Size);
          if MemStream.Size > 0 then
            MemStream.ReadBuffer(InputStr[1], MemStream.Size);

          // Codificar el contenido en Base64 usando EncodeBase64
          Base64Str := EncodeBase64(InputStr);
        finally
          MemStream.Free;
        end;
      finally
        Archivo.Free;
      end;

      // Agregar el archivo adjunto al mensaje
      Cuerpo := Cuerpo +
        '--' + Boundary + #13#10 +
        'Content-Type: application/pdf; name="'+edAdjunto.Text+'"' + #13#10 +
        'Content-Disposition: attachment; filename="'+edAdjunto.Text+'"' + #13#10 +
        'Content-Transfer-Encoding: base64' + #13#10 +
        #13#10 +
        Base64Str + #13#10;
    end;

    // Cerrar el mensaje MIME
    Cuerpo := Cuerpo + '--' + Boundary + '--' + #13#10;

// Combinar encabezados y cuerpo
    MensajeCompleto := Encabezados + Cuerpo;

  // Mostrar el mensaje en la terminal para verificar (opcional)
  try
    // Abrir el archivo en modo escritura (sobrescribe el archivo si ya existe)
    Rewrite(ArchivoSalida);

    WriteLn(ArchivoSalida, 'Mensaje que se enviará:');
    WriteLn(ArchivoSalida, '---------------------');
    WriteLn(ArchivoSalida, MensajeCompleto);
    WriteLn(ArchivoSalida, '---------------------');
    // Cerrar el archivo
    CloseFile(ArchivoSalida);

    WriteLn('La salida se ha guardado en el archivo "salida.txt".');
  except
    on E: Exception do
    begin
      WriteLn('Error al escribir en el archivo: ', E.Message);
    end;
  end;

  // Convertir el mensaje a TStrings
  Mensaje := TStringList.Create;
  try
    Mensaje.Text := MensajeCompleto; // Asignar el mensaje completo al TStringList

  // Configuración del servidor SMTP (Gmail en este caso)
  SMTP := TSMTPSend.Create;
  try
    // Configuración del servidor SMTP de Gmail
    SMTP.TargetHost := CorreoHost; // Servidor SMTP de Gmail
    SMTP.TargetPort := CorreoPuerto; // Puerto para SSL
    SMTP.AutoTLS := CorreoTLS; // Usar TLS
    SMTP.FullSSL := CorreoSSL; // Usar SSL
    SMTP.Username := CorreoUsuario; // Correo del remitente
    SMTP.Password := CorreoClave; // Contraseña del remitente

    if SMTP.AutoTLS then SMTP.StartTLS else SMTP.StartTLS;

//-- CHEKERS
    if SMTP.AutoTLS then WriteLn('El TLS Está ACTIVO') ELSE WriteLn('El TLS NO Está ACTIVO');
    if SMTP.FullSSL then WriteLn('El SSL Está ACTIVO') ELSE WriteLn('El SSL NO Está ACTIVO');
    WriteLn('CorreoHost.-'+CorreoHost);
    WriteLn('CorreoPuerto.-'+CorreoPuerto);
    WriteLn('CorreoUsuario.-'+CorreoUsuario);
    if SMTP.Login then
    begin
      WriteLn('Conexión exitosa al servidor SMTP.');

      // Especificar el remitente (From)
      if SMTP.MailFrom(CorreoEmisor, Length(MensajeCompleto)) then
      begin
        // Especificar el destinatario (To)  y los destinatarios en CC
        if SMTP.MailTo(edDestinatario.Text) then
        begin
          // Especificar los destinatarios en CC
          for ContDest := 0 to DestinatariosCC.Count - 1 do
              begin
               if not SMTP.MailTo(DestinatariosCC[ContDest]) then
                  begin
                    ShowMessage('Error al especificar el destinatario en CC: ' + DestinatariosCC[ContDest]);
                    Exit;
                  end;
              end;
          // Enviar el mensaje completo (encabezados + cuerpo)
          if SMTP.MailData(Mensaje) then
          begin
            // ShowMessage('Correo enviado correctamente.');
            VF_MostrarAvisoFrontal('Información', 'Correo enviado correctamente', 2000, clGreen);
            if (CodigoSalida < 2) then CodigoSalida:= CodigoSalida + 2;
            VF_OfrecerGuardarCorreoCliente;
          end
          else
          begin
            ShowMessage('Error al enviar el cuerpo del mensaje.');
          end;
        end
        else
        begin
          ShowMessage('Error al especificar el destinatario.');
        end;
      end
      else
      begin
        ShowMessage('Error al especificar el remitente.');
      end;

      SMTP.Logout;
    end
    else
    begin
      ShowMessage('Error al conectar al servidor SMTP.');
    end;
  finally
    SMTP.Free;
  end;

  finally
         Mensaje.Free;
  end;

  finally
         DestinatariosCC.Free;
  end;

end;

procedure TFImpresion.ImpDocumento();    // Imprime Documentos
var
  TxtQ: String;
  tablad:String;
  TxtAux: String;

  DrclnFacturacion, IzqlnFacturacion, lnFacturacion: string;
  posGuion1, posGuion2: integer;
begin

  tablad:='factud'; camposKey:=4;
  if ( Documento = 'ALBARAN' ) or ( Documento = 'VALBARAN' ) then begin tablad:= 'albad'; camposKey:=4; end;
  if Documento = 'PRESUPUESTO' then begin tablad:='presud'; camposKey:=4; end;
  if Documento = 'PROFORMA' then begin tablad:='proford'; camposKey:=4; end;
  if Documento = 'ALBARAN(H)' then begin tablad:='hisalbad'; camposKey:=4; end;

  dbImprimir.Active:=False;
  TxtQ:='DELETE FROM imptmp';                       // Borra todos los registros del temporal.
  dbImprimir.SQL.Text:=TxtQ; 
  try
     dbImprimir.ExecSQL;
  except
     on EDB: EDatabaseError do
     begin
       Showmessage('Error : ' + EDB.Message);
     end;
  end;

 if tablad='factud' then
   begin
     TxtAux:='0';
     TxtQ:='INSERT INTO imptmp SELECT '+tablad+Tienda+'.*, MID('+TxtAux+',1,300) as ANotas,'+dbDetalles.Fields[16].FieldName+' FROM '+tablad+Tienda+
                   ' WHERE '+ dbDetalles.Fields[0].FieldName+'='+dbCabecera.Fields[0].AsString+
                   ' AND '+dbDetalles.Fields[2].FieldName+'="'+dbCabecera.Fields[2].AsString+'"'+
                   ' AND '+dbDetalles.Fields[3].FieldName+'='+dbCabecera.Fields[3].AsString;
     //showmessage(TxtQ);
     dbImprimir.SQL.Text:=TxtQ; 
     try
        dbImprimir.ExecSQL;
     except
        on EDB: EDatabaseError do
        begin
          Showmessage('Error : ' + EDB.Message);
        end;
     end;
   end
 else
   begin
    //-- Inserta Lineas sobre código de Articulos
      TxtQ:='INSERT INTO imptmp SELECT '+tablad+Tienda+'.*, MID(A17,1,300) as ANotas, A0 FROM '+tablad+Tienda+', artitien'+Tienda+' WHERE '+ dbDetalles.Fields[0].FieldName+'='+dbCabecera.Fields[0].AsString+
            ' AND '+dbDetalles.Fields[2].FieldName+'="'+dbCabecera.Fields[2].AsString+'"'+
            ' AND '+dbDetalles.Fields[3].FieldName+'='+dbCabecera.Fields[3].AsString+
            ' AND '+dbDetalles.Fields[5].FieldName+'=A0' ;
      //-- showmessage(TxtQ);
      dbImprimir.SQL.Text:=TxtQ; 
      Try
         dbImprimir.ExecSQL;
      except
         on EDB: EDatabaseError do
         begin
         	Showmessage('Error : ' + EDB.Message);
         end;
      end;
      //-- showmessage(TxtQ);
      //-- Inserta Lineas sobre Código EAN
      TxtQ:='INSERT INTO imptmp SELECT '+tablad+Tienda+'.*, MID(A17,1,300) as ANotas, A0 FROM '+tablad+Tienda+
            ', (Select * from artitien'+Tienda+
            ' RIGHT JOIN eans on A0=EAN1) as eantmp WHERE '+ dbDetalles.Fields[0].FieldName+'='+dbCabecera.Fields[0].AsString+
            ' AND '+dbDetalles.Fields[2].FieldName+'="'+dbCabecera.Fields[2].AsString+'"'+
            ' AND '+dbDetalles.Fields[3].FieldName+'='+dbCabecera.Fields[3].AsString+
            ' AND '+dbDetalles.Fields[5].FieldName+'=EAN0' ;
       dbImprimir.SQL.Text:=TxtQ; dbImprimir.ExecSQL;
      //-- showmessage(TxtQ);
   end;

  dbImprimir.Active:=False; dbImprimir.SQL.Text:= 'SELECT * FROM imptmp';
  try
     dbImprimir.ExecSQL;
  except
     on EDB: EDatabaseError do
     begin
       Showmessage('Error : ' + EDB.Message);
     end;
  end;
  dbImprimir.Active:=True;

    //------------------ Suprimimos fecha de los albaranes en facturación -----------
  if cbFechasAlbaranes.Checked=true  then
     begin
         dbImprimir.First;
         while not dbImprimir.eof do
         begin
            dbImprimir.Edit;

            posGuion1:= 0; posGuion2:= 0;

            lnFacturacion:= dbImprimir.FieldByName('IMP16').AsString;

            posGuion1:= pos('-',lnFacturacion);

            if posGuion1 <> 0 Then
               Begin
                 IzqlnFacturacion:= copy(lnFacturacion,1,posGuion1-1);
                 delete(lnFacturacion,1, posGuion1);
               End;

            posGuion2:= pos('-', lnFacturacion);

            if posGuion2 <> 0 Then
               DrclnFacturacion:= copy(lnFacturacion,posGuion2+1, length(lnFacturacion));

            if (posGuion1<>0) and (posGuion2<>0) then
              begin
                dbImprimir.FieldByName('IMP16').Value:= IzqlnFacturacion+'-'+DrclnFacturacion;
                dbImprimir.Post;
              end;

            dbImprimir.Next;
          end;

  end;

  frDBDataSet.DataSet:=dbImprimir;

  IMPOIVA1:=0; BASE1:=0; TOTAL1:=0; IRIVA1:=0; PIVA1:=0; PRIVA1:=0;
  IMPOIVA2:=0; BASE2:=0; TOTAL2:=0; IRIVA2:=0; PIVA2:=0; PRIVA2:=0;
  IMPOIVA3:=0; BASE3:=0; TOTAL3:=0; IRIVA3:=0; PIVA3:=0; PRIVA3:=0;

    //--------------- Sacar distintos ivas ------------------
  TxtQ:='SELECT DISTINCT(IMP12), (SUM(IMP13-IMP11)) As Ivas, '+
        'SUM(IMP11) As Bases, SUM(IMP13) As Totales, '+
        'SUM(IMP10) As Dtos, (((SUM(IMP11)*SUM(IMP10)) / 100)) As ImpoDtos FROM imptmp '+
        ' WHERE IMP0='+dbCabecera.Fields[0].AsString+
        ' AND IMP1="'+FormatDateTime('yyyy/mm/dd',dbCabecera.Fields[1].asDateTime)+'"'+
        ' AND IMP2="'+dbCabecera.Fields[2].AsString+'"'+
        ' AND IMP3='+dbCabecera.Fields[3].AsString+' GROUP BY IMP12 ORDER BY IMP12 ASC';
  dbTemporal.Active:=False; dbTemporal.Sql.Text:=TxtQ; 
  try
     dbTemporal.ExecSQL; 
  except
     on EDB: EDatabaseError do
     begin
       Showmessage('Error : ' + EDB.Message);
     end;
  end;
  dbTemporal.Active:=True;

  CalculaIvas();

  //  Impuestos incluidos
  if RadioGroup1.ItemIndex=1 then
      begin
         dbImprimir.First;
         while not dbImprimir.eof do
         begin
            dbImprimir.Edit;
            if (dbImprimir.FieldByName('IMP7').Value <> 0) then dbImprimir.FieldByName('IMP9').Value:= FormatFloat('0.000',dbImprimir.FieldByName('IMP13').Value / dbImprimir.FieldByName('IMP7').Value);
            dbImprimir.FieldByName('IMP10').Value:= 0;
            dbImprimir.FieldByName('IMP11').Value:= dbImprimir.FieldByName('IMP13').Value;
            dbImprimir.FieldByName('IMP12').Value:= 0;
            dbImprimir.FieldByName('IMP8').Value := 0;
            try
               dbImprimir.Post;
            except
               on EDB: EDatabaseError do
               begin
                 Showmessage('Error : ' + EDB.Message);
               end;
            end;
            dbImprimir.Next;
          end;
          BASE1:=TOTAL1; PIVA1:=0; IMPOIVA1:=0; PRIVA1:=0; IRIVA1:=0;
          BASE2:=TOTAL2; PIVA2:=0; IMPOIVA2:=0; PRIVA2:=0; IRIVA2:=0;
          BASE3:=TOTAL3; PIVA3:=0; IMPOIVA3:=0; PRIVA3:=0; IRIVA3:=0;
      end;

  //  Sólo PVP
  if RadioGroup1.ItemIndex=2 then
      begin
         dbImprimir.First;
         while not dbImprimir.eof do
         begin
            dbImprimir.Edit;
            dbImprimir.FieldByName('IMP9').Value:= dbImprimir.FieldByName('IMP17').Value;
            dbImprimir.FieldByName('IMP10').Value:= 0;
            dbImprimir.FieldByName('IMP11').Value:= FormatFloat('0.000',dbImprimir.FieldByName('IMP9').Value * dbImprimir.FieldByName('IMP7').Value);
            dbImprimir.FieldByName('IMP13').Value:= dbImprimir.FieldByName('IMP11').Value;
            //------ El orden debe ser este, no tocar
            dbImprimir.FieldByName('IMP8').Value:= 0;
            dbImprimir.FieldByName('IMP12').Value:= 0;
            try
               dbImprimir.Post;
            except
               on EDB: EDatabaseError do
               begin
                 Showmessage('Error : ' + EDB.Message);
               end;
            end;
            dbImprimir.Next;
          end;
          IMPOIVA1:=0; BASE1:=0; TOTAL1:=0; IRIVA1:=0; PIVA1:=0; PRIVA1:=0;
          IMPOIVA2:=0; BASE2:=0; TOTAL2:=0; IRIVA2:=0; PIVA2:=0; PRIVA2:=0;
          IMPOIVA3:=0; BASE3:=0; TOTAL3:=0; IRIVA3:=0; PIVA3:=0; PRIVA3:=0;

          //--------------- Sacar distintos ivas ------------------
         TxtQ:='SELECT DISTINCT(IMP12), (SUM(IMP13-IMP11)) As Ivas, '+
         'SUM(IMP11) As Bases, SUM(IMP13) As Totales, '+
         'SUM(IMP10) As Dtos, (((SUM(IMP11)*SUM(IMP10)) / 100)) As ImpoDtos FROM imptmp '+
         ' WHERE IMP0='+dbCabecera.Fields[0].AsString+
         ' AND IMP1="'+FormatDateTime('yyyy/mm/dd',dbCabecera.Fields[1].asDateTime)+'"'+
         ' AND IMP2="'+dbCabecera.Fields[2].AsString+'"'+
         ' AND IMP3='+dbCabecera.Fields[3].AsString+' GROUP BY IMP12 ORDER BY IMP12 ASC';
         dbTemporal.Active:=False; dbTemporal.Sql.Text:=TxtQ; dbTemporal.ExecSQL; dbTemporal.Active:=True;

         CalculaIvas();

         dbImprimir.First;
         while not dbImprimir.eof do
         begin
            dbImprimir.Edit;
            dbImprimir.FieldByName('IMP12').Value:= 0;
            dbImprimir.FieldByName('IMP8').Value:= 0;
            try
               dbImprimir.Post;
            except
               on EDB: EDatabaseError do
               begin
                 Showmessage('Error : ' + EDB.Message);
               end;
            end;
            dbImprimir.Next;
          end;

          BASE1:=TOTAL1; PIVA1:=0; IMPOIVA1:=0; PRIVA1:=0; IRIVA1:=0;
          BASE2:=TOTAL2; PIVA2:=0; IMPOIVA2:=0; PRIVA2:=0; IRIVA2:=0;
          BASE3:=TOTAL3; PIVA3:=0; IMPOIVA3:=0; PRIVA3:=0; IRIVA3:=0;

      end;

  //  Sin valorar.
  if RadioGroup1.ItemIndex=3 then
      begin
         dbImprimir.First;
         while not dbImprimir.eof do
         begin
            dbImprimir.Edit;
            dbImprimir.FieldByName('IMP8').Value:= 0;
            dbImprimir.FieldByName('IMP9').Value:= 0;
            dbImprimir.FieldByName('IMP10').Value:= 0;
            dbImprimir.FieldByName('IMP11').Value:= 0;
            dbImprimir.FieldByName('IMP12').Value:= 0;
            dbImprimir.FieldByName('IMP13').Value:= 0;
            dbImprimir.FieldByName('IMP17').Value:= 0;
            try
               dbImprimir.Post;
            except
               on EDB: EDatabaseError do
               begin
                 Showmessage('Error : ' + EDB.Message);
               end;
            end;
            dbImprimir.Next;
          end;
          BASE1:=0; PIVA1:=0; IMPOIVA1:=0; PRIVA1:=0; IRIVA1:=0; TOTAL1:=0;
          BASE2:=0; PIVA2:=0; IMPOIVA2:=0; PRIVA2:=0; IRIVA2:=0; TOTAL2:=0;
          BASE3:=0; PIVA3:=0; IMPOIVA3:=0; PRIVA3:=0; IRIVA3:=0; TOTAL3:=0;
      end;

  // Anulamos las columnas de PVP o precio si el checkbox está desactivado.

    if cbprecio.Checked=False then
      begin
        dbImprimir.First;
        while not dbImprimir.eof do
         begin
           dbImprimir.Edit;
           dbImprimir.FieldByName('IMP9').Value:= 0;      //---- precio sin iva
           dbImprimir.FieldByName('IMP11').Value:= 0;     //---- total sin iva
            try
               dbImprimir.Post;
            except
               on EDB: EDatabaseError do
               begin
                 Showmessage('Error : ' + EDB.Message);
               end;
            end;
           dbImprimir.Next;
         end;
      end;

    if cbPVP.Checked=False then
      begin
        dbImprimir.First;
        while not dbImprimir.eof do
         begin
           dbImprimir.Edit;
           dbImprimir.FieldByName('IMP8').Value:= 0;      //---- precio con iva
           try
              dbImprimir.Post;
           except
              on EDB: EDatabaseError do
              begin
                Showmessage('Error : ' + EDB.Message);
              end;
           end;
           dbImprimir.Next;
         end;
      end;

end;

Procedure TFImpresion.cbDuplicadoChange(Sender: TObject);
begin
  if (cbDuplicado.Checked=true) then cbEsCopia.Checked:=False;
end;

procedure TFImpresion.cbEnviarCorreoChange(Sender: TObject);
var
  PDFCreado: Boolean;
  Contador: Integer;
  nuevoPDF: string;
  posNombrePDF: integer;

begin
  if not (cbEnviarCorreo.Checked) then begin
                                        PanelCorreo.Enabled:=False;
                                        exit;
                                       end;
  PanelCorreo.Enabled:=True;

  posNombrePDF := pos('FAC_', NombrePDF);
  if posNombrePDF>0 then
    begin
      nuevoPDF:=NombrePDF; Delete(nuevoPDF, posNombrePDF, 4);       // Eliminamos prefijo nombre factura ( FAC_ ).
    end;

//  if FileExists(NombrePDF) then exit;            // Generamos pdf del documento.
  if (FileExists(NombrePDF)) and ( not (assigned(FImpresion)))  then exit;

  if FileExists(NombrePDF) then
             if Application.MessageBox(' Ya existe un archivo con ese nombre,' +
               #13 + ' Desea reemplazarlo ?', 'FacturLinEx',
               MB_ICONQUESTION + MB_YESNO) = idYes then DeleteFile(NombrePDF)
                                                   else exit;
   if FileExists(nuevoPDF) then
             if Application.MessageBox(' Factura ya existente en otro formato' +
               #13 + ' Utilizar la existente ?', 'FacturLinEx',
               MB_ICONQUESTION + MB_YESNO) = idYes then begin
                                                           NombrePDF:=nuevoPDF;
                                                           Edit1.Text:= NombrePDF;
                                                           edAdjunto.Text:= NombrePDF;
                                                           exit;
                                                           end;

  ImpDocumento();
  TipoImpreso();

  frReport.LoadFromFile(Impreso);
  frReport.PrepareReport;

  VF_MostrarGenerandoPDF(True);

  frReport.ExportTo(TFrTNPDFExportFilter, NombrePDF);

  PDFCreado:= False;   // Esperamos hasta que el archivo está creado.
  Contador:= 0;
  Delay(2000);

 //   if (not PDFCreado) or (FileSize(NombrePDF)=0) then GeneraImpresion();  // Intentamos generar el PDF.

   while (not PDFCreado) and (Contador < 15) do             // Retardo de 15 segundos.
     begin
       if FileExists(NombrePDF) and (FileSize(NombrePDF) > 0) then
           begin
               PDFCreado:=True;
               VF_MostrarGenerandoPDF(False);
             end
       else
             Contador:= Contador+1;

       end;

       if not PDFCreado then
         begin
             VF_MostrarGenerandoPDF(False);
             VF_MostrarAvisoFrontal('Error', 'El archivo PDF no se pudo generar.', 2000, clRed);
             Exit;
          end;

       VF_MostrarGenerandoPDF(False);

end;

procedure TFImpresion.cbEsCopiaChange(Sender: TObject);
begin
  if (cbEsCopia.Checked=true) then cbDuplicado.Checked:=False;
end;

//==================== Definimos el report a utilizar ===================
procedure TFImpresion.TipoImpreso();
var
  TImpreso: String;
  ObservacionesArticulos: string;
begin

  if Impreso<>'' then exit;

  if Documento<>'FACTURA' then
    begin
        if ( Documento<>'ALBARAN' ) and ( Documento<>'VALBARAN' ) then DirectorioReport:= DirectorioReport+'Documento'
                                else DirectorioReport:= DirectorioReport+'Albaran';
    end
  else DirectorioReport:= DirectorioReport+'Factura';

  if (cbObservaciones.Checked=true) then ObservacionesArticulos:='2' else
                                         ObservacionesArticulos:='';
  if (CheckBox1.Checked=True) then TImpreso:='P' else TImpreso:='';

  Impreso:= DirectorioReport + ObservacionesArticulos + TImpreso + '.lrf';

end;

procedure TFImpresion.GeneraImpresion();
var
  Contador: Integer;
  PDFCreado: Boolean;
  nuevoPDF: string;
  posNombrePDF: integer;

begin
  nuevoPDF := '';

  // ------------------------------------------------------------
  // Modo FACTURAR (facturación rápida):
  //  - Evita ExportTo(PDF) + Delay + espera de fichero, porque el PDF ya
  //    se genera por otro método (FPPDF).
  //  - Si el usuario tiene seleccionado "PDF" en la UI (RadioGroup2=2),
  //    aquí lo redirigimos a "Imprimir" (RadioGroup2=1).
  // ------------------------------------------------------------
  if VF_ImprimirFromFacturar and (RadioGroup2.ItemIndex = 2) then
  begin
    // En modo FACTURAR no necesitamos exportar a PDF con LazReport (ya existe PDF FPPDF),
    // pero SÍ queremos poder imprimir respetando el report seleccionado.
    // MUY IMPORTANTE: hay que cargar el .lrf antes de preparar/imprimir.
    // Impreso debería estar ya calculado por TipoImpreso() antes de llamar a GeneraImpresion().
    frReport.LoadFromFile(Impreso);
    frReport.PrepareReport;
    frReport.PrintPreparedReport('', SpinEdit1.Value);
    Exit;
  end;


  frReport.LoadFromFile(Impreso);

  posNombrePDF := pos('FAC_', NombrePDF);
  if posNombrePDF>0 then
    begin
      nuevoPDF:=NombrePDF; Delete(nuevoPDF, posNombrePDF, 4);       // Eliminamos prefijo nombre factura ( FAC_ ).
    end;

 // showmessage(nombrePDF +' ----- '+nuevoPDF);

  if RadioGroup2.ItemIndex=0 then frReport.ShowReport;

  if RadioGroup2.ItemIndex=1 then
      begin
        frReport.PrepareReport;
        frReport.PrintPreparedReport('',SpinEdit1.Value);
      end;

  if RadioGroup2.ItemIndex=2 then
      begin
        frReport.PrepareReport;

        if FileExists(NombrePDF) then
           if Application.MessageBox(' Ya existe un archivo con ese nombre,' +
             #13 + ' Desea reemplazarlo ?', 'FacturLinEx',
             MB_ICONQUESTION + MB_YESNO) = idYes then DeleteFile(NombrePDF);

           if (nuevoPDF <> '') and FileExists(nuevoPDF) then
             if Application.MessageBox(' Factura ya existente en otro formato. ' +
               #13 + ' Utilizar la existente ?', 'FacturLinEx',
               MB_ICONQUESTION + MB_YESNO) = idYes then begin
                                                         NombrePDF:=nuevoPDF;
                                                         Edit1.Text:= NombrePDF;
                                                         edAdjunto.Text:= NombrePDF;
                                                         BuscarAnexos();
                                                         exit;
                                                        end;

        VF_MostrarGenerandoPDF(True);

        frReport.ExportTo(TFrTNPDFExportFilter, NombrePDF);

        PDFCreado:= False;   // Esperamos hasta que el archivo está creado.
        Contador:= 0;
        Delay(2000);

 //   if (not PDFCreado) or (FileSize(NombrePDF)=0) then GeneraImpresion();  // Intentamos generar el PDF.

        while (not PDFCreado) and (Contador < 15) do             // Retardo de 15 segundos.
        begin
         if FileExists(NombrePDF) and (FileSize(NombrePDF) > 0) then
             begin
               PDFCreado:=True;
               VF_MostrarGenerandoPDF(False);
             end
         else
             Contador:= Contador+1;

        end;

        if not PDFCreado then
          begin
             VF_MostrarGenerandoPDF(False);
             VF_MostrarAvisoFrontal('Error', 'El archivo PDF no se pudo generar.', 2000, clRed);
             Exit;
          end;

        VF_MostrarGenerandoPDF(False);

        end;

  //       AProcess := TProcess.Create(nil);
  //       AProcess.CommandLine := VisorPdf+' '+RutaPdf+'\Albaran.pdf';
  //       AProcess.Execute;
  //       AProcess.Destroy;

  BuscarAnexos();

end;
//================= BUSCAR DOCUMENTOS ANEXOS ===============
// Si NO está instalado el Asistente para Anexos, el checkBoxAnexos debe estar
// Visible:=False y Checked:=False. En la instalación del asistente estos
// valores guardados en el config.ini pasan a TRUE

procedure TFImpresion.BuscarAnexos();
var
  TxtQuery: string;
  Orden: string;
begin
  if CheckBoxAnexos.Checked then
    begin
      TxtQuery:='SELECT * FROM docuanexos WHERE claveNodo="'+ GeneraKeyDelNodo()+'";';
      dbQueryAnexos.Active:=False; dbQueryAnexos.SQL.Text:=TxtQuery; dbQueryAnexos.Active:=True;
      if dbQueryAnexos.RecordCount<>0 then
        begin
          while not dbQueryAnexos.EOF do
          begin
          AProcess := TProcess.Create(nil);
          Orden:= AbrirAchivo+' '+ dbQueryAnexos.FieldByName('rutaDoc').AsString;
          //showmessage(orden);
          try
            AProcess.CommandLine := Orden;
            AProcess.Execute;
          except
            showmessage('No se pudo abrir el archivo '+ dbQueryAnexos.FieldByName('rutaDoc').AsString);
            showmessage('NO EXISTE EL FICHERO O LA ORDEN PARA ABRIR ARCHIVOS NO ES CORRECTA'+ #13 +
                         '   COMPRUEBE LA ORDEN EN LA CONFIGURACIÓN DE FACTURLINEX2');
            exit;
          end;

          AProcess.Destroy;

          dbQueryAnexos.Next;
          end;
        end;
    end;
end;
//============== GENERA CLAVE DEL NODO =====================
function TFImpresion.GeneraKeyDelNodo():string;
var
  cadena: string;
  cont: integer;
begin
  cadena:='';
  cont:=0;
  while cont < camposKey-1 do
    begin
      cadena:=cadena+dbCabecera.Fields[cont].AsString+'|-|';
      cont:=cont+1;
    end;
  cadena:=cadena+dbCabecera.Fields[cont].AsString;
  //showmessage(cadena);
  Result:=cadena;
end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFImpresion.frReportGetValue(const ParName: String;
  var ParValue: Variant);

var
  LeyendaCabeceraQR, LeyendaPieQR: string;

begin

     if VF_Imprimir_EsModoProduccion and (UpperCase(Trim(Documento)) = 'FACTURA') then
     begin
      LeyendaCabeceraQR := ' QR Tributario : ';
      LeyendaPieQR := ' VERI*FACTU ';
     end else
     begin
      LeyendaCabeceraQR := LeyendaSuperiorQR;
      LeyendaPieQR := LeyendaInferiorQR;
     end;

  if ParName ='FechaImpresion' then ParValue := inttostr(frReport.EMFPages.Count) + FormatDateTime('yymmddhhnn', now);

  if ParName='leyenda1' then ParValue := LeyendaCabeceraQR;
  if ParName='leyenda2' then ParValue := LeyendaPieQR;

  if ParName ='EMPRESA' then ParValue := Empresa;
  if ParName='DIRECCION' then ParValue := Direccion;
  if ParName='LOCALIDAD' then ParValue := Localidad;
  if ParName='PROVINCIA' then ParValue := Provincia;
  if ParName='NIF' then ParValue := Nif;
  if ParName='TELEFONO' then ParValue := Telefono;
  if ParName='FAX' then ParValue := Fax;
  if ParName='EMAIL' then ParValue := eMail;
  if ParName='CP' then ParValue := CP;
  if ParName='REGISTRO' then ParValue := REGISTRO;

  if ParName='CCODIGO' then ParValue := dbDatosCliente.FieldByName('C0').AsString;
  if ParName='CCLIENTE' then ParValue := dbDatosCliente.FieldByName('C1').AsString;
  if ParName='CDIRECCION' then ParValue := dbDatosCliente.FieldByName('C3').AsString;
  if ParName='CLOCALIDAD' then ParValue := dbDatosCliente.FieldByName('C4').AsString;
  if ParName='CCIF' then ParValue := dbDatosCliente.FieldByName('C5').AsString;
  if ParName='CCP' then ParValue := dbDatosCliente.FieldByName('C37').AsString;
  if ParName='CPROVINCIA' then ParValue := dbDatosCliente.FieldByName('C38').AsString;

  if ParName='DOCUMENTO' then ParValue := Documento;
  if ParName='FECHA' then ParValue := dbCabecera.Fields[1].AsString;
  if ParName='SERIE' then ParValue := dbCabecera.Fields[2].AsString;
  if ParName='NUMERO' then ParValue := dbCabecera.Fields[3].AsString;

  if nPagina = frReport.EMFPages.Count then
  begin
    if ParName='BASE1' then if BASE1<>0 then ParValue:=FormatFloat('0.000',BASE1) else ParValue:='';
    if ParName='PIVA1' then if PIVA1<>0 then ParValue:=FormatFloat('0',PIVA1) else ParValue:='';
    if ParName='IMPOIVA1' then if IMPOIVA1<>0 then ParValue:=FormatFloat('0.000',IMPOIVA1) else  ParValue:='';
    if ParName='TOTAL1' then if TOTAL1<>0 then ParValue := FormatFloat('0.00',TOTAL1) else  ParValue:='';
    if ParName='PRIVA1' then if PRIVA1<>0 then ParValue := FormatFloat('0',PRIVA1) else  ParValue:='';
    if ParName='IRIVA1' then if IRIVA1<>0 then ParValue := FormatFloat('0.00',IRIVA1) else  ParValue:='';

    if ParName='BASE2' then if BASE2<>0 then ParValue:=FormatFloat('0.000',BASE2) else ParValue:='';
    if ParName='PIVA2' then if PIVA2<>0 then ParValue:=FormatFloat('0',PIVA2) else ParValue:='';
    if ParName='IMPOIVA2' then if IMPOIVA2<>0 then ParValue:=FormatFloat('0.000',IMPOIVA2) else  ParValue:='';
    if ParName='TOTAL2' then if TOTAL2<>0 then ParValue := FormatFloat('0.00',TOTAL2) else  ParValue:='';
    if ParName='PRIVA2' then if PRIVA2<>0 then ParValue := FormatFloat('0',PRIVA2) else  ParValue:='';
    if ParName='IRIVA2' then if IRIVA2<>0 then ParValue := FormatFloat('0.00',IRIVA2) else  ParValue:='';

    if ParName='BASE3' then if BASE3<>0 then ParValue:=FormatFloat('0.000',BASE3) else ParValue:='';
    if ParName='PIVA3' then if PIVA3<>0 then ParValue:=FormatFloat('0',PIVA3) else ParValue:='';
    if ParName='IMPOIVA3' then if IMPOIVA3<>0 then ParValue:=FormatFloat('0.000',IMPOIVA3) else  ParValue:='';
    if ParName='TOTAL3' then if TOTAL3<>0 then ParValue := FormatFloat('0.00',TOTAL3) else  ParValue:='';
    if ParName='PRIVA3' then if PRIVA3<>0 then ParValue := FormatFloat('0',PRIVA3) else  ParValue:='';
    if ParName='IRIVA3' then if IRIVA3<>0 then ParValue := FormatFloat('0.00',IRIVA3) else  ParValue:='';
    if ParName='TOTALGENERAL' then if TOTAL1+TOTAL2+TOTAL3<>0 then ParValue := FormatFloat('0.00',TOTAL1+TOTAL2+TOTAL3) else  ParValue:='';
    if ParName='OBSERVACIONES' then
    if Documento<>'FACTURA' then ParValue := dbCabecera.Fields[11].AsString else
                                  ParValue := dbCabecera.Fields[19].AsString;

    if ParName='FECHAV1' then ParValue:=dbCabecera.Fields[11].AsString;
    if ParName='IMPOV1' then if dbCabecera.Fields[12].AsString<>'0' then ParValue:=dbCabecera.Fields[12].AsString else ParValue:='';
    if ParName='FECHAV2' then ParValue:=dbCabecera.Fields[13].AsString;
    if ParName='IMPOV2' then if dbCabecera.Fields[14].AsString<>'0' then ParValue:=dbCabecera.Fields[14].AsString else ParValue:='';
    if ParName='FECHAV3' then ParValue:=dbCabecera.Fields[15].AsString;
    if ParName='IMPOV3' then if dbCabecera.Fields[16].AsString<>'0' then ParValue:=dbCabecera.Fields[16].AsString else ParValue:='';
    if ParName='FECHAV4' then ParValue:=dbCabecera.Fields[17].AsString;
    if ParName='IMPOV4' then if dbCabecera.Fields[18].AsString<>'0' then ParValue:=dbCabecera.Fields[18].AsString else ParValue:='';
  end else
  begin
    if ParName='BASE1' then ParValue:='';
    if ParName='PIVA1' then ParValue:='';
    if ParName='IMPOIVA1' then ParValue:='';
    if ParName='TOTAL1' then ParValue:='';
    if ParName='PRIVA1' then ParValue:='';
    if ParName='IRIVA1' then ParValue:='';

    if ParName='BASE2' then ParValue:='';
    if ParName='PIVA2' then ParValue:='';
    if ParName='IMPOIVA2' then ParValue:='';
    if ParName='TOTAL2' then ParValue:='';
    if ParName='PRIVA2' then ParValue:='';
    if ParName='IRIVA2' then ParValue:='';

    if ParName='BASE3' then ParValue:='';
    if ParName='PIVA3' then ParValue:='';
    if ParName='IMPOIVA3' then ParValue:='';
    if ParName='TOTAL3' then ParValue:='';
    if ParName='PRIVA3' then ParValue:='';
    if ParName='IRIVA3' then ParValue:='';
    if ParName='TOTALGENERAL' then ParValue:='';
    if ParName='OBSERVACIONES' then ParValue:='';

    if ParName='FECHAV1' then ParValue:='';
    if ParName='IMPOV1' then ParValue:='';
    if ParName='FECHAV2' then ParValue:='';;
    if ParName='IMPOV2' then ParValue:='';
    if ParName='FECHAV3' then ParValue:='';
    if ParName='IMPOV3' then ParValue:='';
    if ParName='FECHAV4' then ParValue:='';
    if ParName='IMPOV4' then ParValue:='';
  end;

  if ParName='TITULO' then ParValue := TituloInforme;

  if ParName = 'SUMAS' then SubTotalPagina := SubTotalPagina + dbImprimir.FieldByName('IMP13').Value;

  if ParName='SUBTOTAL' then ParValue := TotalPagina;

  if ImprimirLOPD='S' then begin
    if ParName='LOPD1' then ParValue := Lopd1;
    if ParName='LOPDEMP' then ParValue := Empresa;
    if ParName='LOPD2' then ParValue := Lopd2;
    if ParName='LOPDDIR' then ParValue := Direccion+', '+CP+' '+Localidad+' ('+Provincia+')';
  end else begin
    if ParName='LOPD1' then ParValue := '';
    if ParName='LOPDEMP' then ParValue := '';
    if ParName='LOPD2' then ParValue := '';
    if ParName='LOPDDIR' then ParValue := '';
  end;

 // BarcodeQR1.Text:=txtQR+'numserie='+dbCabecera.Fields[2].AsString+'%2F'+dbCabecera.Fields[3].AsString
 //                       +'&fecha='+FormatDateTime('dd-mm-yyyy',dbCabecera.Fields[1].AsDateTime)
 //                       +'&importe='+FormatFloat('0.00',dbCabecera.FieldByName('FC9').AsFloat);

end;

//======================= LOGOTIPO DEL FORMULARIO ========================

procedure TFImpresion.frReportEnterRect(Memo: TStringList; View: TfrView);
var
  vImage: TImage;
  RutaLogo: string;
begin

  RutaLogo:=RutaIconos+'Vacio.png';
  if assigned( View ) and  (View is TfrPictureView) then
  begin
     if (view.Name = 'PictureQR') then RutaLogo:=DirectorioQR;
     if (View.Name = 'Picture1') then RutaLogo:= LogoEmpresa;
     if (View.Name = 'EsCopiaDuplicado') then
       begin
          if (cbEsCopia.Checked) then RutaLogo:=RutaIconos+'EsCopia.png';
          if (cbDuplicado.Checked) then RutaLogo:=RutaIconos+'Duplicado.png';
       end;
     if (View.Name = 'Picture2') then RutaLogo:=RutaIconos+'FacturLinExGNU.jpeg';

     try
        vImage := TImage.Create( nil );
        try
           TfrPictureView(View).Picture.Clear;
           TfrPictureView(View).Picture.LoadFromFile(RutaLogo);
        finally
          FreeAndNil(vImage);
        end;
    except
        TfrPictureView(View).Picture.Clear;
    end;
  end;

end;

//=================== CALCULAR TIPOS DE IVAS ==================
procedure TFImpresion.CalculaIvas();
begin

  // Debe cargarse previamente en dbTemporal la consulta de detalles.

  dbTemporal.First;

  //------------------------ Primer tipo de iva
  if dbTemporal.Eof=False then
   begin
    PIVA1:=dbTemporal.Fields[0].AsInteger;
//    IMPOIVA1:=dbTemporal.Fields[1].AsFloat;
//    BASE1:=dbTemporal.Fields[2].AsFloat;
    TOTAL1:=dbTemporal.Fields[3].AsFloat;
    BASE1:=TOTAL1/(1+(dbTemporal.Fields[0].AsInteger/100));
    IMPOIVA1:=BASE1*(dbTemporal.Fields[0].AsInteger/100);
    //---------------- Recargo
    if dbDatosCliente.FieldByName('C19').AsString='S' then
      begin
       VerRecargo();
       PRIVA1:=RECARGO;
       IRIVA1:=dbTemporal.Fields[2].AsFloat-((dbTemporal.Fields[2].AsFloat*100)/(RECARGO+100));
       TOTAL1:=dbTemporal.Fields[3].AsFloat+dbTemporal.Fields[2].AsFloat-((dbTemporal.Fields[2].AsFloat*100)/(RECARGO+100));
      end;
   end;
  dbTemporal.Next;
  //------------------------ Segundo tipo de iva
  if dbTemporal.Eof=False then
   begin
    PIVA2:=dbTemporal.Fields[0].AsInteger;
//    IMPOIVA2:=dbTemporal.Fields[1].AsFloat;
//    BASE2:=dbTemporal.Fields[2].AsFloat;
    TOTAL2:=dbTemporal.Fields[3].AsFloat;
    BASE2:=TOTAL2/(1+(dbTemporal.Fields[0].AsInteger/100));
    IMPOIVA2:=BASE2*(dbTemporal.Fields[0].AsInteger/100);
    //---------------- Recargo
    if dbDatosCliente.FieldByName('C19').AsString='S' then
      begin
       VerRecargo();
       PRIVA2:=RECARGO;
       IRIVA2:=dbTemporal.Fields[2].AsFloat-((dbTemporal.Fields[2].AsFloat*100)/(RECARGO+100));
       TOTAL2:=dbTemporal.Fields[3].AsFloat+dbTemporal.Fields[2].AsFloat-((dbTemporal.Fields[2].AsFloat*100)/(RECARGO+100));
      end;
   end;
  dbTemporal.Next;
  //------------------------ Tercer tipo de iva
  if dbTemporal.Eof=False then
   begin
    PIVA3:=dbTemporal.Fields[0].AsInteger;
//    IMPOIVA3:=dbTemporal.Fields[1].AsFloat;
//    BASE3:=dbTemporal.Fields[2].AsFloat;
    TOTAL3:=dbTemporal.Fields[3].AsFloat;
    BASE3:=TOTAL3/(1+(dbTemporal.Fields[0].AsInteger/100));
    IMPOIVA3:=BASE3*(dbTemporal.Fields[0].AsInteger/100);
    //---------------- Recargo
    if dbDatosCliente.FieldByName('C19').AsString='S' then
      begin
       VerRecargo();
       PRIVA3:=RECARGO;
       IRIVA3:=dbTemporal.Fields[2].AsFloat-((dbTemporal.Fields[2].AsFloat*100)/(RECARGO+100));
       TOTAL3:=dbTemporal.Fields[3].AsFloat+dbTemporal.Fields[2].AsFloat-((dbTemporal.Fields[2].AsFloat*100)/(RECARGO+100));
      end;
   end;
end;

procedure TFImpresion.RadioGroup2Click(Sender: TObject);
begin
  if (RadioGroup2.ItemIndex=2) then
    Begin
         Edit1.Enabled:= True;
         SpinEdit1.Value:=1;
    End
  else
    Begin
         Edit1.Enabled:= False;
//         SpinEdit1.Value:=dbDatosCliente.FieldByName('C8').AsInteger;
         if SpinEdit1.Value=0 then SpinEdit1.Value:=1;
    End;
end;

//================ TIPOS DE RECARGO =====================
procedure TFImpresion.VerRecargo();
begin
   RECARGO:=RIVA1;
   if dbTemporal.Fields[0].AsFloat=IVA1 then RECARGO:=RIVA1;
   if dbTemporal.Fields[0].AsFloat=IVA2 then RECARGO:=RIVA2;
   if dbTemporal.Fields[0].AsFloat=IVA3 then RECARGO:=RIVA3;
end;

procedure TFImpresion.btSalirClick(Sender: TObject);
begin
  Close();
end;

//========================== Creación de .XML para FacturaE ==============
procedure TFImpresion.btxmlClick(Sender: TObject);
var
  Gen: TFacturaEGenerator;
  XMLFile, XMLFirmado: String;
begin
  // Solo FACTURA
  if Documento <> 'FACTURA' then
  begin
    ShowMessage('Solo se genera FacturaE para FACTURAS.');
    Exit;
  end;

  // Asegúrate de que dbImprimir tiene imptmp listo (ya lo haces en ImpDocumento)
  ImpDocumento();       // prepara imptmp y dbImprimir
  TipoImpreso();        // no afecta al XML, pero mantiene tu flujo

  XMLFile := Edit1.Text + '.xml'; // o lo que tú quieras como ruta/nombre

  Gen := TFacturaEGenerator.Create;
  try
    Gen.BuildFacturaE(dbCabecera, dbImprimir, dbDatosCliente, XMLFile);
  finally
    Gen.Free;
  end;

  // Firmar
  XMLFirmado := FirmarFactura(XMLFile);

  ShowMessage('FacturaE generada y firmada: ' + XMLFirmado);
end;

//**********************************
//**** PRUEBA FIRMA XML COPILOT ****
//**********************************
function TFImpresion.FirmarFactura(XMLFile: string): string;
var
  OutputFile: String;
begin
  // Salida: mismo nombre + sufijo _firmada
  OutputFile := ChangeFileExt(XMLFile, '') + '_firmada.xml';

  if SignFacturaEXAdES(XMLFile, OutputFile) then
    Result := OutputFile
  else
    raise Exception.Create('No se pudo firmar la factura FacturaE.');
end;

procedure TFImpresion.Edit1Exit(Sender: TObject);
begin
  NombrePDF:= Edit1.Text;
end;

//=========================== Imprimir con Ticket ==================
procedure TFImpresion.ImpreTicket(dbMuestrad: TZQuery; dbMuestrac: TZQuery; dbCliente: TZQuery;
                                 TipoDocumento: String);
var
  Precio, SubTotal: Double;
  Texto: String;
begin
  with TFImpresion.Create(Application) do
    begin
     Documento:= TipoDocumento;
     dbDatosCliente:= dbCliente;
     dbCabecera:= dbMuestrac;
     dbDetalles:= dbMuestrad;

     AssignFile(PrintText, DevTicket); //añadido por javi para quitar opendialog
     Rewrite(PrintText);
     CabeceraTicket();
     dbMuestrad.First;
     while not dbDetalles.Eof do
       begin
         if DesgloIva='S' then
           begin
            Precio:=dbDetalles.Fields[9].AsFloat;
            SubTotal:=dbDetalles.Fields[11].AsFloat;
           end else
           begin
            Precio:=dbDetalles.Fields[8].AsFloat;
            SubTotal:=dbDetalles.Fields[13].AsFloat;
           end;
         Texto:=Copy(dbMuestrad.Fields[6].AsString+'                    ',1,18)+' ';
         Texto:=Texto + DataModule1.LFill(FormatFloat('##0.00',dbDetalles.Fields[7].AsFloat),6,' ') + ' ';
         Texto:=Texto + DataModule1.LFill(FormatFloat('##0.00',Precio),6,' ') + ' ';
         Texto:=Texto + DataModule1.LFill(FormatFloat('###0.00',SubTotal),7,' ');
         Writeln(PrintText, Texto);
         dbDetalles.Next;
       end;
     PieTicket();
     CloseFile(PrintText);
     Close();
    end;
end;

//============== CABECERA DEL TICKET ===================================
procedure TFImpresion.CabeceraTicket();
var
hora: String;
begin
  if Trim(LCTI1)<>'' then Writeln(PrintText, LCTI1);
  if Trim(LCTI2)<>'' then Writeln(PrintText, LCTI2);
  if Trim(LCTI3)<>'' then Writeln(PrintText, LCTI3);
  if Trim(LCTI4)<>'' then Writeln(PrintText, LCTI4);
  hora:='';
  if HoraEnTicket='S' then hora:='   Hora.:'+FormatDateTime('hh:mm:ss',TIME);

  Writeln(PrintText, ' ');

  Writeln(PrintText, 'N.'+Documento+':'+ dbCabecera.Fields[2].AsString+'/'+DataModule1.LFill(FormatFloat('#######',dbCabecera.Fields[3].AsFloat),7,' '));

  Writeln(PrintText, ' ');
  Writeln(PrintText, 'Fecha.: '+FormatDateTime('dd/mm/yyyy',dbCabecera.Fields[1].AsDateTime)+hora);
  Writeln(PrintText, ' ');
  Writeln(PrintText, 'ARTICULO              UND PRECIO   TOTAL');
  Writeln(PrintText, '========================================');
end;

//====================== PIE DEL TICKETC =============================
procedure TFImpresion.PieTicket();
Var
  Impuestos: Double;
  Conta: Integer;
begin
  Writeln(PrintText, ' ');
  Writeln(PrintText, '                               ---------');

  Impuestos:=dbCabecera.Fields[9].AsFloat - dbCabecera.Fields[8].AsFloat;

  if SacaIva='N' then
    begin
      Writeln(PrintText, '                    NETO      '+DataModule1.LFill( FormatFloat('######0.00',dbCabecera.Fields[8].AsFloat),7,' '));
      Writeln(PrintText, '                    IVA       '+DataModule1.LFill( FormatFloat('######0.00',Impuestos),7,' '));
    end;

  Writeln(PrintText, '                    TOTAL     '+DataModule1.LFill( FormatFloat('######0.00',dbCabecera.Fields[9].AsFloat),7,' '));
  Writeln(PrintText, ' ');
  //----------------- Sacar iva uncluido en el ticket o no --------------
  if SacaIva<>'N' then
    begin

     Writeln(PrintText, '            * IVA INCLUIDO *            ');
     Writeln(PrintText, ' ');
    end;

  Writeln(PrintText, 'Cliente: '+dbDatosCliente.FieldByName('C0').AsString);
  Writeln(PrintText, dbDatosCliente.FieldByName('C1').AsString);
  Writeln(PrintText, ' ');

  //----------------- Sacar vendedor en el ticket o no --------------
   if SacaVende<>'N' then Writeln(PrintText, 'LE ATENDIO.: '+ copy(UsuarioActivo,1,35));

  //----------------------------------------------------------------
  if Trim(LPTI1)<>'' then Writeln(PrintText, LPTI1);
  if Trim(LPTI2)<>'' then Writeln(PrintText, LPTI2);
  if Trim(LPTI3)<>'' then Writeln(PrintText, LPTI3);
  for Conta:=1 to StrToInt(LiFinTick) do Writeln(PrintText, ' ');
end;

procedure TFImpresion.EsVentas;
begin
   Delete(Documento,1,1);
   if Documento='ALBARAN'  then
     if CgPrAlbV='S' then  RadioGroup2.ItemIndex:=0           //previsualización.
                     else  RadioGroup2.ItemIndex:=1;           // Imprime.

   if Documento='FACTURA'  then
     if CgPrFraV='S' then  RadioGroup2.ItemIndex:=0           //previsualización.
                     else  RadioGroup2.ItemIndex:=1;           // Imprime.

   btOk1Click(Self);

   Close();

end;

procedure TFImpresion.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_ESCAPE) then begin key:=0; btSalirClick(self); Exit; End;
  if (key=VK_RETURN) and (btOK1.Enabled=True) and not(mmTexto.Focused) then begin key:=0; btOk1Click(self) ; Exit; End;
end;

procedure TFImpresion.FormShow(Sender: TObject);
begin
  VF_AplicarEstiloModerno;
  VF_ActualizarTituloModerno;
  Edit1.Text:= NombrePDF;
  edAdjunto.Text:= NombrePDF;
  FLXAplicarTemaVisual(Self);
end;

procedure TFImpresion.frReportBeginDoc;
begin
  nPagina:= 0;              // Inicializamos página.
end;

procedure TFImpresion.frReportBeginPage(pgNo: Integer);
begin
  SubTotalPagina:=0;
end;

procedure TFImpresion.frReportEndPage(pgNo: Integer);
begin
  TotalPagina:= TotalPagina + SubTotalPagina;
  if (frReport.DoublePass) and (not frReport.FinalPass) then Inc(nPagina); // Incrementamos número de página
end;

procedure TFImpresion.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    CloseAction:=CaFree;
end;

procedure TFImpresion.sbBuscarClick(Sender: TObject);
begin
    if OpenDialog1.Execute then
      begin
       edAdjunto.Text := OpenDialog1.FileName;
      end;
end;

procedure TFImpresion.FormCreate(Sender: TObject);
begin
  FCorreoClienteGestionado := False;
  FCargandoCorreoCliente := False;
  FCorreoClienteInicial := '';
  FCorreoUltimoEvaluado := '';

  // Conectate(dbConect);               // Usamos dbConexion como conexión única para todo el proyecto.

  if DatosEmpresa='S' then CheckBox1.Checked:=False;

  Edit1.Enabled:=False;
  RadioGroup2.ItemIndex:=1;
  if ImprePrevisu='S' then RadioGroup2.ItemIndex:=0;
  if ImprePDF='S' then begin RadioGroup2.ItemIndex:=2; Edit1.Enabled:= True; end;

  DirectorioReport:=RutaReports;

  VF_AplicarEstiloModerno;
  FLXAplicarTemaVisual(Self);
end;

procedure TFImpresion.CorreosElectronicos;
begin

  FCargandoCorreoCliente := True;
  try
    FCorreoClienteInicial :=
      Trim(dbdatoscliente.FieldByName('C40').AsString);
    edDestinatario.Text := FCorreoClienteInicial;
    FCorreoUltimoEvaluado := FCorreoClienteInicial;
    FCorreoClienteGestionado := False;
  finally
    FCargandoCorreoCliente := False;
  end;

  edAsunto.Text:= Documento+' / Cliente # '+ dbdatoscliente.FieldByName('C0').AsString;                                         //CorreoCabecera;
  edDestinatarioCopia.Text:= CorreoCopia;

  mmTexto.lines.Add(CorreoMensaje1);
  mmTexto.lines.Add(CorreoMensaje2);
  mmTexto.lines.Add(CorreoMensaje3);
  mmTexto.lines.Add(CorreoMensaje4);
  mmTexto.lines.Add(chr(13));
  mmTexto.lines.Add(CorreoLOPD1 +' '+empresa );
  mmTexto.lines.Add(CorreoLOPD2 +' '+direccion+' '+localidad +'('+Provincia+')');
  mmTexto.lines.Add(CorreoLOPD3 +' '+Email+chr(13));
  mmTexto.Lines.Add(chr(13)+' *** Mensaje generado por Facturlinex VF 4 *** ');

end;

end.
