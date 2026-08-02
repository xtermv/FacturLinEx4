{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010, Nicolas Lopez de Lerma Aymerich
                           nicolas@puntodev.com
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

unit config;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Inifiles,
  Process, ExtCtrls, Buttons, StdCtrls, ComCtrls, LCLType, ZConnection, ExtDlgs,
  EditBtn, ZDataset, db, uFLXRemoteBackup, uFLXTemaVisual;

type
  { TFConfig }

  TFConfig = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    btnValidarCopiasAutomaticas: TBitBtn;
    BitBtnCambiable1: TBitBtn;
    BitBtnCambiable2: TBitBtn;
    Button1: TButton;
    cbCopia1: TCheckBox;
    cbCopia2: TCheckBox;
    cbCopia3: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CgSCajon: TEdit;
    cbSSL: TCheckBox;
    cbTLS: TCheckBox;
    bbdd_autocopy: TCheckBox;
    CBMbbdd: TComboBox;
    Edit73: TEdit;
    edLeyendaSuperior: TEdit;
    edLeyendaInferior: TEdit;
    edTextoQR: TEdit;
    GroupBox2: TGroupBox;
    Label160: TLabel;
    Label161: TLabel;
    lbLeyendaSuperior: TLabel;
    lbLeyendaInferior: TLabel;
    lbTxtQr: TLabel;
    vfCheckTest: TCheckBox;
    edCuenta: TEdit;
    edCuentaCopia: TEdit;
    Edit70: TEdit;
    Edit71: TEdit;
    Edit72: TEdit;
    edUsuario: TEdit;
    edClave: TEdit;
    edHost: TEdit;
    edPuerto: TEdit;
    edCabecera: TEdit;
    edMensaje1: TEdit;
    edMensaje2: TEdit;
    edMensaje3: TEdit;
    edmensaje4: TEdit;
    ficherosiva: TCheckGroup;
    ColorDialog1: TColorDialog;
    Combo1: TComboBox;
    Combo2: TComboBox;
    ComboBox1: TComboBox;
    ComboBox10: TComboBox;
    ComboBox11: TComboBox;
    ComboBox13: TComboBox;
    ComboBox14: TComboBox;
    ComboBox15: TComboBox;
    ComboBox16: TComboBox;
    ComboBox17: TComboBox;
    ComboBox18: TComboBox;
    ComboBox19: TComboBox;
    ComboBox2: TComboBox;
    ComboBox20: TComboBox;
    ComboBox21: TComboBox;
    ComboBox22: TComboBox;
    ComboBox23: TComboBox;
    ComboBox24: TComboBox;
    ComboBox25: TComboBox;
    ComboBox26: TComboBox;
    ComboBox27: TComboBox;
    ComboBox28: TComboBox;
    ComboBox29: TComboBox;
    ComboBox3: TComboBox;
    ComboBox30: TComboBox;
    ComboBox31: TComboBox;
    cbPrecision: TComboBox;
    ComboBoxLOPD: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ComboBox9: TComboBox;
    cbRupturaStock: TComboBox;
    ComboCambiableNombre1: TComboBox;
    ComboCambiableNombre2: TComboBox;
    Copia1FinHora: TEdit;
    Copia2FinHora: TEdit;
    Copia1FinMinutos: TEdit;
    Copia3FinHora: TEdit;
    Copia2FinMinutos: TEdit;
    Copia3FinMinutos: TEdit;
    Copia2FinUD1: TUpDown;
    Copia2FinUD2: TUpDown;
    Copia3FinUD1: TUpDown;
    Copia3FinUD2: TUpDown;
    Copia3Destino: TEdit;
    Copia3InicioHora: TEdit;
    Copia3InicioMinutos: TEdit;
    Copia3InicioUD1: TUpDown;
    Copia3InicioUD2: TUpDown;
    Copia2Destino: TEdit;
    Copia1InicioHora: TEdit;
    Copia1Destino: TEdit;
    Copia2InicioHora: TEdit;
    Copia1InicioMinutos: TEdit;
    Copia2InicioMinutos: TEdit;
    Copia1InicioUD1: TUpDown;
    Copia1InicioUD2: TUpDown;
    Copia2InicioUD1: TUpDown;
    Copia2InicioUD2: TUpDown;
    Datasource1: TDatasource;
    fechaiva: TDateEdit;
    dbCambiable2: TZQuery;
    dbCambiable1: TZQuery;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit2: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit3: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    Edit37: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Edit4: TEdit;
    Edit40: TEdit;
    Edit41: TEdit;
    Edit42: TEdit;
    Edit43: TEdit;
    Edit44: TEdit;
    Edit45: TEdit;
    Edit46: TEdit;
    Edit47: TEdit;
    Edit48: TEdit;
    Edit49: TEdit;
    Edit5: TEdit;
    Edit50: TEdit;
    Edit51: TEdit;
    Edit52: TEdit;
    Edit53: TEdit;
    Edit54: TEdit;
    Edit55: TEdit;
    Edit56: TEdit;
    Edit57: TEdit;
    Edit58: TEdit;
    Edit59: TEdit;
    Edit6: TEdit;
    Edit60: TEdit;
    Edit61: TEdit;
    Edit62: TEdit;
    Edit63: TEdit;
    Edit64: TEdit;
    Edit65: TEdit;
    Edit66: TEdit;
    Edit67: TEdit;
    Edit68: TEdit;
    Edit69: TEdit;
    Edit7: TEdit;
    edMoneda: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    EditAbrirArchivo: TEdit;
    EditCambiableCodigo1: TEdit;
    EditCambiableCodigo2: TEdit;
    edCliVario: TEdit;
    gbCopia1: TGroupBox;
    gbCopia2: TGroupBox;
    gbCopia3: TGroupBox;
    gbTipoInstalacion: TGroupBox;
    GroupBox1: TGroupBox;
    Image1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label100: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label11: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    Label114: TLabel;
    Label115: TLabel;
    Label116: TLabel;
    Label117: TLabel;
    Label118: TLabel;
    Label119: TLabel;
    Label12: TLabel;
    Label120: TLabel;
    Label121: TLabel;
    Label122: TLabel;
    Label123: TLabel;
    Label124: TLabel;
    Label125: TLabel;
    Label126: TLabel;
    Label127: TLabel;
    Label128: TLabel;
    Label129: TLabel;
    Label130: TLabel;
    Label131: TLabel;
    Label132: TLabel;
    Label133: TLabel;
    Label134: TLabel;
    Label135: TLabel;
    Label136: TLabel;
    Label137: TLabel;
    Label138: TLabel;
    Label139: TLabel;
    Label140: TLabel;
    Label141: TLabel;
    Label142: TLabel;
    Label143: TLabel;
    Label144: TLabel;
    Label145: TLabel;
    Label146: TLabel;
    Label147: TLabel;
    Label148: TLabel;
    Label149: TLabel;
    Label150: TLabel;
    Label151: TLabel;
    Label152: TLabel;
    Label153: TLabel;
    Label154: TLabel;
    Label155: TLabel;
    Label156: TLabel;
    Label157: TLabel;
    Label158: TLabel;
    Label159: TLabel;
    Label17: TLabel;
    Label30: TLabel;
    lbCliVario1: TLabel;
    lbSistema: TLabel;
    lbIni: TLabel;
    lbSql: TLabel;
    lbReport: TLabel;
    lbImagenes: TLabel;
    lbBinario: TLabel;
    lbModulos: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label96: TLabel;
    lbMoneda: TLabel;
    LabelAbrirArchivo: TLabel;
    LabelLOPD: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label4: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label5: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label6: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label7: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label8: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    Label89: TLabel;
    Label9: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label95: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    LabelCambiable1: TLabel;
    LabelCambiable2: TLabel;
    lbCliVario: TLabel;
    lbStock: TLabel;
    OpenDialog2: TOpenDialog;
    OpenPictureDialog1: TOpenPictureDialog;
    PageControl1: TPageControl;
    Panel1: TPanel;
    PanelCambiable1: TPanel;
    PanelCambiable2: TPanel;
    pcAplicacionesExtra: TPageControl;
    RadioGroup1: TRadioGroup;
    CambioIVA: TRadioGroup;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    StaticTextCambiableNombre1: TStaticText;
    StaticTextCambiableNombre2: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet10: TTabSheet;
    TabSheet11: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    dbArti: TZQuery;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    tsCopiasAutomaticas: TTabSheet;
    tsGeneral: TTabSheet;
    Copia1FinUD1: TUpDown;
    Copia1FinUD2: TUpDown;
    procedure bbdd_autocopyChange(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtnCambiable1Click(Sender: TObject);
    procedure BitBtnCambiable2Click(Sender: TObject);
    procedure btnValidarCopiasAutomaticasClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure ComboBox14Change(Sender: TObject);
    procedure ComboBox17Change(Sender: TObject);
    procedure ComboBox19Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboCambiableNombre1Click(Sender: TObject);
    procedure ComboCambiableNombre1KeyPress(Sender: TObject; var Key: char);
    procedure ComboCambiableNombre2Click(Sender: TObject);
    procedure ComboCambiableNombre2KeyPress(Sender: TObject; var Key: char);
    procedure Edit26KeyPress(Sender: TObject; var Key: char);
    procedure Edit60KeyPress(Sender: TObject; var Key: char);
    procedure ActivaArticulos();
    procedure DesactivaArticulos();
    procedure Edit64KeyPress(Sender: TObject; var Key: char);
    procedure Edit70Change(Sender: TObject);
    procedure VeriFactuChange(Sender: TObject);
    procedure AplicarDefaultsVeriFactuEnBlanco;
    procedure EditCambiableCodigo1Change(Sender: TObject);
    procedure Edit57Exit(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure EditCambiableCodigo1Enter(Sender: TObject);
    procedure EditCambiableCodigo1Exit(Sender: TObject);
    procedure EditCambiableCodigo2Enter(Sender: TObject);
    procedure EditCambiableCodigo2Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RestaurarIni();
    procedure GuardarIni();
    procedure CargaValoresEnIniReader(IniReader : TIniFile);
    procedure CargaValoresEnGlobales();

    procedure pcAplicacionesExtraEnter(Sender: TObject);
    procedure cbCopia3Change(Sender: TObject);
    procedure cbCopia2Change(Sender: TObject);
    procedure cbCopia1Change(Sender: TObject);
  private
    FHeaderTitle: TLabel;
    FHeaderSubtitle: TLabel;
    FBtnLogoVisual: TPanel;
    FBtnColorFormularioVisual: TPanel;
    FBtnColorBotonesVisual: TPanel;
    FBtnTiendaVisual: TPanel;
    FBtnPuestoVisual: TPanel;
    FBtnVisorPDFVisual: TPanel;
    FBtnRutaPDFVisual: TPanel;
    FBtnRutaImagenesVisual: TPanel;
    FBtnTestBBDDVisual: TPanel;
    FBtnTestSICVisual: TPanel;
    FCheckMonoVisual: TPanel;
    FCheckSICVisual: TPanel;
    FCheckVFVisual: TPanel;
    FLabelSICVisual: TPanel;
    FLabelVFVisual: TPanel;
    FDisenoFinalAplicado: Boolean;
    function CrearTarjetaVisual(AParent: TWinControl; ALeft, ATop,
      AWidth, AHeight: Integer; AColor: TColor;
      const ATitulo: string = ''): TShape;
    procedure CrearBotonVisual(ABoton: TBitBtn; var APanel: TPanel;
      const AHint: string);
    procedure CrearBotonAccionVisual(ABoton: TBitBtn; var APanel: TPanel;
      const ACaption, AHint: string; AColor: TColor);
    procedure BotonAccionVisualClick(Sender: TObject);
    procedure ActualizarBotonesConexionVisual;
    procedure CrearCheckVisual(ACheck: TCheckBox; var APanel: TPanel;
      const ACaption, AHint: string; AColorFondo, AColorTexto: TColor);
    procedure CrearEtiquetaVisual(AOriginal: TLabel; var APanel: TPanel;
      const ACaption: string; AColorFondo, AColorTexto: TColor);
    procedure CheckVisualClick(Sender: TObject);
    procedure SincronizarCheckVisual(APanel: TPanel; ACheck: TCheckBox);
    procedure SincronizarChecksVisuales;
    procedure SincronizarPosicionControlesVisuales;
    procedure LimpiarTarjetasModernas;
    procedure FormShowModerno(Sender: TObject);
    procedure BotonVisualKeyPress(Sender: TObject; var Key: char);
    procedure PrepararBotonPrincipal(ABoton: TBitBtn; AColor: TColor;
      ATextoClaro: Boolean);
    procedure AplicarEstiloModerno;
    procedure CrearTarjetasModernas;
    procedure EstilizarControlesModernos;
    procedure RecolocarDisenoModerno;
    procedure FormResizeModerno(Sender: TObject);
  private
    lbClientesBuscarNIFCodigo: TLabel;
    lbClientesModoCodigoAltaNIF: TLabel;
    lbClientesCodigoSuperiorDesde: TLabel;
    cbClientesBuscarNIFCodigo: TComboBox;
    cbClientesModoCodigoAltaNIF: TComboBox;
    edClientesCodigoSuperiorDesde: TEdit;
    procedure CrearControlesClientesCodigo;
    procedure ClientesCodigoConfigChange(Sender: TObject);

  private
    { Apariencia y accesibilidad. Se crea en ejecución para no desplazar ni
      alterar las pestañas históricas del formulario. }
    FAparienciaTab: TTabSheet;
    FAparienciaHeader: TPanel;
    FAparienciaBody: TPanel;
    FAparienciaOptions: TPanel;
    FAparienciaPreview: TPanel;
    FAparienciaTitle: TLabel;
    FAparienciaSubtitle: TLabel;
    FAparienciaModeInfo: TLabel;
    FAparienciaPreviewTitle: TLabel;
    FContrasteVisual: TRadioGroup;
    FPreviewBlue: TPanel;
    FPreviewGreen: TPanel;
    FPreviewPurple: TPanel;
    procedure CrearControlesApariencia;
    procedure ContrasteVisualChange(Sender: TObject);
    procedure ActualizarVistaPreviaContraste;
    function TemaContrasteSeleccionado: TFLXTemaVisual;

  private
    { Se abre una nueva sección de visibilidad porque FPC no permite declarar
      campos después de métodos dentro de la misma sección. }
    { Configuración de la copia física remota. Se crea en ejecución en una
      pestaña propia, junto a Copias automáticas, para disponer de todo el
      espacio necesario sin desplazar ni reducir los controles existentes. }
    FRemoteBackupTab: TTabSheet;
    FRemoteBackupPanel: TPanel;
    FRemoteBackupHeader: TPanel;
    FRemoteBackupTitle: TLabel;
    FRemoteBackupInfo: TLabel;
    FRemoteEnabled: TCheckBox;
    FRemoteAutoOnExit: TCheckBox;
    FRemoteFTPOnExit: TCheckBox;
    FRemoteHostLabel: TLabel;
    FRemotePortLabel: TLabel;
    FRemoteUserLabel: TLabel;
    FRemoteAuthLabel: TLabel;
    FRemoteKeyLabel: TLabel;
    FRemoteDestinationLabel: TLabel;
    FRemoteCommandLabel: TLabel;
    FRemoteKeepLabel: TLabel;
    FRemoteHost: TEdit;
    FRemotePort: TEdit;
    FRemoteUser: TEdit;
    FRemoteAuth: TComboBox;
    FRemoteKey: TEdit;
    FRemotePassword: TEdit;
    FRemoteDestination: TEdit;
    FRemoteCommand: TEdit;
    FRemoteKeep: TEdit;
    FRemoteKeyBrowse: TBitBtn;
    FRemoteDestinationBrowse: TBitBtn;
    FRemoteTest: TBitBtn;
    FRemoteRunNow: TBitBtn;
    procedure CrearControlesBackupRemoto;
    procedure RecolocarControlesBackupRemoto;
    procedure ActualizarEstadoBackupRemoto;
    procedure BackupRemotoCambio(Sender: TObject);
    procedure BackupRemotoBuscarClave(Sender: TObject);
    procedure BackupRemotoBuscarDestino(Sender: TObject);
    procedure BackupRemotoProbar(Sender: TObject);
    procedure BackupRemotoEjecutar(Sender: TObject);
    procedure GuardarConfiguracionBackupRemoto(AIni: TIniFile);
    procedure GuardarConfiguracionBackupRemotoPersistente;
    procedure CargarConfiguracionBackupRemotoPersistente;
    procedure RecargarIniReaderDesdeDisco;
    function ConfiguracionBackupRemotoActual: TFLXRemoteBackupConfig;
    { private declarations }
  public
    { public declarations }
   IniReader : TIniFile;
   Sections : TStringList;
  end;

 procedure ShowFormConfig;

var
  FConfig: TFConfig;
  IniForm: boolean;


implementation

uses
    Global, Funciones, Menu, uFLX_CryptoIni;

const
  VF_DEFAULT_URL_QR     = 'https://prewww2.aeat.es/wlpl/TIKE-CONT/ValidarQR?';
  VF_DEFAULT_URL_SOAP   = 'https://prewww10.aeat.es/wlpl/TIKE-CONT/ws/SistemaFacturacion/VerifactuSOAP';
  VF_DEFAULT_URL_LOCAL  = 'http://127.0.0.1:8080/verifactu/test';
  VF_DEFAULT_MODE       = 'PRODUCCION';

procedure TFConfig.CrearControlesApariencia;

  procedure PrepararPanel(APanel: TPanel; AParent: TWinControl;
    AAlign: TAlign; AColor: TColor);
  begin
    APanel.Parent := AParent;
    APanel.Align := AAlign;
    APanel.Caption := '';
    APanel.BevelOuter := bvNone;
    APanel.BevelInner := bvNone;
    APanel.ParentColor := False;
    APanel.Color := AColor;
  end;

  procedure PrepararTarjeta(APanel: TPanel; AParent: TWinControl;
    ATop: Integer; const ACaption: string; AColor: TColor);
  begin
    APanel.Parent := AParent;
    APanel.SetBounds(38, ATop, 760, 82);
    APanel.Anchors := [akLeft, akTop, akRight];
    APanel.Caption := ACaption;
    APanel.BevelOuter := bvLowered;
    APanel.BevelInner := bvNone;
    APanel.ParentColor := False;
    APanel.Color := AColor;
    APanel.ParentFont := False;
    APanel.Font.Name := 'Sans';
    APanel.Font.Height := -13;
    APanel.Font.Style := [fsBold];
    APanel.Font.Color := RGBToColor(30, 41, 59);
  end;

begin
  if Assigned(FAparienciaTab) then Exit;

  FAparienciaTab := TTabSheet.Create(Self);
  FAparienciaTab.PageControl := PageControl1;
  FAparienciaTab.Caption := '  Apariencia / Accesibilidad  ';
  FAparienciaTab.ParentFont := False;
  FAparienciaTab.Color := RGBToColor(241, 245, 247);

  FAparienciaHeader := TPanel.Create(Self);
  PrepararPanel(FAparienciaHeader, FAparienciaTab, alTop,
    RGBToColor(18, 76, 91));
  FAparienciaHeader.Height := 92;

  FAparienciaTitle := TLabel.Create(Self);
  FAparienciaTitle.Parent := FAparienciaHeader;
  FAparienciaTitle.SetBounds(28, 16, 900, 30);
  FAparienciaTitle.Caption := 'Apariencia y accesibilidad visual';
  FAparienciaTitle.ParentFont := False;
  FAparienciaTitle.Font.Name := 'Sans';
  FAparienciaTitle.Font.Height := -20;
  FAparienciaTitle.Font.Style := [fsBold];
  FAparienciaTitle.Font.Color := clWhite;

  FAparienciaSubtitle := TLabel.Create(Self);
  FAparienciaSubtitle.Parent := FAparienciaHeader;
  FAparienciaSubtitle.SetBounds(30, 52, 1200, 24);
  FAparienciaSubtitle.Caption :=
    'La preferencia se guarda solamente en este puesto de trabajo.';
  FAparienciaSubtitle.ParentFont := False;
  FAparienciaSubtitle.Font.Name := 'Sans';
  FAparienciaSubtitle.Font.Height := -12;
  FAparienciaSubtitle.Font.Color := RGBToColor(220, 235, 239);

  FAparienciaBody := TPanel.Create(Self);
  PrepararPanel(FAparienciaBody, FAparienciaTab, alClient,
    RGBToColor(241, 245, 247));

  FAparienciaOptions := TPanel.Create(Self);
  PrepararPanel(FAparienciaOptions, FAparienciaBody, alLeft,
    RGBToColor(226, 238, 242));
  FAparienciaOptions.Width := 560;

  FContrasteVisual := TRadioGroup.Create(Self);
  FContrasteVisual.Parent := FAparienciaOptions;
  FContrasteVisual.SetBounds(30, 34, 500, 172);
  FContrasteVisual.Caption := '  Contraste de la interfaz  ';
  FContrasteVisual.Items.Add('Normal');
  FContrasteVisual.Items.Add('Reforzado');
  FContrasteVisual.Items.Add('Alto contraste');
  FContrasteVisual.ItemIndex := 0;
  FContrasteVisual.ParentFont := False;
  FContrasteVisual.Font.Name := 'Sans';
  FContrasteVisual.Font.Height := -13;
  FContrasteVisual.Font.Style := [fsBold];
  FContrasteVisual.Font.Color := RGBToColor(30, 41, 59);
  FContrasteVisual.ParentColor := False;
  FContrasteVisual.Color := RGBToColor(226, 238, 242);

  FAparienciaModeInfo := TLabel.Create(Self);
  FAparienciaModeInfo.Parent := FAparienciaOptions;
  FAparienciaModeInfo.SetBounds(34, 232, 490, 190);
  FAparienciaModeInfo.AutoSize := False;
  FAparienciaModeInfo.WordWrap := True;
  FAparienciaModeInfo.ParentFont := False;
  FAparienciaModeInfo.Font.Name := 'Sans';
  FAparienciaModeInfo.Font.Height := -12;
  FAparienciaModeInfo.Font.Color := RGBToColor(51, 65, 85);

  FAparienciaPreview := TPanel.Create(Self);
  PrepararPanel(FAparienciaPreview, FAparienciaBody, alClient,
    RGBToColor(248, 250, 251));

  FAparienciaPreviewTitle := TLabel.Create(Self);
  FAparienciaPreviewTitle.Parent := FAparienciaPreview;
  FAparienciaPreviewTitle.SetBounds(38, 30, 900, 32);
  FAparienciaPreviewTitle.Caption := 'Vista previa de paneles interiores';
  FAparienciaPreviewTitle.ParentFont := False;
  FAparienciaPreviewTitle.Font.Name := 'Sans';
  FAparienciaPreviewTitle.Font.Height := -17;
  FAparienciaPreviewTitle.Font.Style := [fsBold];
  FAparienciaPreviewTitle.Font.Color := RGBToColor(18, 76, 91);

  FPreviewBlue := TPanel.Create(Self);
  PrepararTarjeta(FPreviewBlue, FAparienciaPreview, 92,
    'Datos generales · panel azul', RGBToColor(226, 238, 242));

  FPreviewGreen := TPanel.Create(Self);
  PrepararTarjeta(FPreviewGreen, FAparienciaPreview, 194,
    'Opciones y condiciones · panel verde', RGBToColor(231, 243, 234));

  FPreviewPurple := TPanel.Create(Self);
  PrepararTarjeta(FPreviewPurple, FAparienciaPreview, 296,
    'Observaciones · panel violeta', RGBToColor(239, 235, 247));

  ActualizarVistaPreviaContraste;
  FLXAplicarTemaVisual(FAparienciaTab, tvNormal);
end;

function TFConfig.TemaContrasteSeleccionado: TFLXTemaVisual;
begin
  Result := tvNormal;
  if not Assigned(FContrasteVisual) then Exit;
  case FContrasteVisual.ItemIndex of
    1: Result := tvContrasteReforzado;
    2: Result := tvAltoContraste;
  end;
end;

procedure TFConfig.ActualizarVistaPreviaContraste;
var
  LTema: TFLXTemaVisual;
begin
  if not Assigned(FContrasteVisual) then Exit;
  LTema := TemaContrasteSeleccionado;

  if Assigned(FAparienciaTab) then
    FAparienciaTab.Color := FLXColorTema(RGBToColor(241, 245, 247), LTema);
  if Assigned(FAparienciaBody) then
    FAparienciaBody.Color := FLXColorTema(RGBToColor(241, 245, 247), LTema);
  if Assigned(FAparienciaOptions) then
    FAparienciaOptions.Color := FLXColorTema(RGBToColor(226, 238, 242), LTema);
  if Assigned(FContrasteVisual) then
    FContrasteVisual.Color := FLXColorTema(RGBToColor(226, 238, 242), LTema);
  if Assigned(FAparienciaPreview) then
    FAparienciaPreview.Color := FLXColorTema(RGBToColor(248, 250, 251), LTema);
  if Assigned(FPreviewBlue) then
    FPreviewBlue.Color := FLXColorTema(RGBToColor(226, 238, 242), LTema);
  if Assigned(FPreviewGreen) then
    FPreviewGreen.Color := FLXColorTema(RGBToColor(231, 243, 234), LTema);
  if Assigned(FPreviewPurple) then
    FPreviewPurple.Color := FLXColorTema(RGBToColor(239, 235, 247), LTema);

  if not Assigned(FAparienciaModeInfo) then Exit;
  case LTema of
    tvContrasteReforzado:
      FAparienciaModeInfo.Caption :=
        'REFORZADO'#10#10 +
        'Aumenta la intensidad de los paneles pastel y hace más visibles ' +
        'los bordes y separadores, manteniendo el estilo actual.'#10#10 +
        'Recomendado para monitores con contraste limitado.';
    tvAltoContraste:
      FAparienciaModeInfo.Caption :=
        'ALTO CONTRASTE'#10#10 +
        'Ofrece la separación más clara entre fondo, paneles y tarjetas. ' +
        'Los colores siguen siendo suaves, pero se distinguen con mayor ' +
        'facilidad.'#10#10 +
        'Pensado para pantallas especialmente apagadas.';
  else
    FAparienciaModeInfo.Caption :=
      'NORMAL'#10#10 +
      'Conserva exactamente los colores actuales de FacturLinEx. No se ' +
      'modifica ningún formulario ni tono existente.';
  end;
end;

procedure TFConfig.ContrasteVisualChange(Sender: TObject);
begin
  ActualizarVistaPreviaContraste;
  if BitBtn1.Enabled then Exit;
  BitBtn1.Enabled := True;
  BitBtn2.Enabled := True;
end;

procedure TFConfig.CrearControlesBackupRemoto;

  procedure CrearEtiqueta(var ALabel: TLabel; const ACaption: string);
  begin
    ALabel := TLabel.Create(Self);
    ALabel.Parent := FRemoteBackupPanel;
    ALabel.AutoSize := False;
    ALabel.Caption := ACaption;
    ALabel.Transparent := True;
    ALabel.ParentFont := False;
    ALabel.Font.Name := 'Sans';
    ALabel.Font.Height := -11;
    ALabel.Font.Style := [fsBold];
    ALabel.Font.Color := RGBToColor(30, 41, 59);
  end;

  procedure CrearEditor(var AEdit: TEdit);
  begin
    AEdit := TEdit.Create(Self);
    AEdit.Parent := FRemoteBackupPanel;
    AEdit.ParentFont := False;
    AEdit.Font.Name := 'Sans';
    AEdit.Font.Height := -11;
    AEdit.Color := clWhite;
  end;

  procedure PrepararBoton(ABtn: TBitBtn; const ACaption: string;
    const AColor: TColor);
  begin
    ABtn.Parent := FRemoteBackupPanel;
    ABtn.Caption := ACaption;
    ABtn.ParentFont := False;
    ABtn.Font.Name := 'Sans';
    ABtn.Font.Height := -11;
    ABtn.Font.Style := [fsBold];
    ABtn.Color := AColor;
    ABtn.Font.Color := clWhite;
  end;

begin
  if Assigned(FRemoteBackupPanel) then Exit;

  { La copia física remota dispone de una pestaña independiente. Se crea en
    ejecución para mantener intacto el LFM y situarla justo después de la
    pestaña de Copias automáticas. }
  FRemoteBackupTab := TTabSheet.Create(Self);
  FRemoteBackupTab.PageControl := pcAplicacionesExtra;
  FRemoteBackupTab.Caption := 'Copias remotas';
  FRemoteBackupTab.ParentFont := False;
  FRemoteBackupTab.Color := RGBToColor(241, 245, 247);

  FRemoteBackupPanel := TPanel.Create(Self);
  FRemoteBackupPanel.Parent := FRemoteBackupTab;
  FRemoteBackupPanel.Caption := '';
  FRemoteBackupPanel.BevelOuter := bvNone;
  FRemoteBackupPanel.ParentColor := False;
  FRemoteBackupPanel.Color := RGBToColor(226, 238, 242);

  FRemoteBackupHeader := TPanel.Create(Self);
  FRemoteBackupHeader.Parent := FRemoteBackupPanel;
  FRemoteBackupHeader.Caption := '';
  FRemoteBackupHeader.BevelOuter := bvNone;
  FRemoteBackupHeader.ParentColor := False;
  FRemoteBackupHeader.Color := RGBToColor(23, 96, 116);

  FRemoteBackupTitle := TLabel.Create(Self);
  FRemoteBackupTitle.Parent := FRemoteBackupHeader;
  FRemoteBackupTitle.AutoSize := False;
  FRemoteBackupTitle.Caption := 'COPIA FÍSICA REMOTA DEL SERVIDOR MARIADB';
  FRemoteBackupTitle.Transparent := True;
  FRemoteBackupTitle.ParentFont := False;
  FRemoteBackupTitle.Font.Name := 'Sans';
  FRemoteBackupTitle.Font.Height := -12;
  FRemoteBackupTitle.Font.Style := [fsBold];
  FRemoteBackupTitle.Font.Color := clWhite;
  FRemoteBackupTitle.Alignment := taCenter;
  FRemoteBackupTitle.Layout := tlCenter;

  FRemoteEnabled := TCheckBox.Create(Self);
  FRemoteEnabled.Parent := FRemoteBackupPanel;
  FRemoteEnabled.Caption := 'Habilitar copia física remota';
  FRemoteEnabled.ParentColor := False;
  FRemoteEnabled.Color := FRemoteBackupPanel.Color;
  FRemoteEnabled.ParentFont := False;
  FRemoteEnabled.Font.Name := 'Sans';
  FRemoteEnabled.Font.Height := -11;
  FRemoteEnabled.Font.Style := [fsBold];

  FRemoteAutoOnExit := TCheckBox.Create(Self);
  FRemoteAutoOnExit.Parent := FRemoteBackupPanel;
  FRemoteAutoOnExit.Caption :=
    'Ejecutar automáticamente al cerrar FacturLinEx';
  FRemoteAutoOnExit.ParentColor := False;
  FRemoteAutoOnExit.Color := FRemoteBackupPanel.Color;
  FRemoteAutoOnExit.ParentFont := False;
  FRemoteAutoOnExit.Font.Name := 'Sans';
  FRemoteAutoOnExit.Font.Height := -11;
  FRemoteAutoOnExit.Font.Style := [fsBold];

  FRemoteFTPOnExit := TCheckBox.Create(Self);
  FRemoteFTPOnExit.Parent := FRemoteBackupPanel;
  FRemoteFTPOnExit.Caption :=
    'Enviar también al FTP configurado cuando la copia se ejecute al cerrar';
  FRemoteFTPOnExit.ParentColor := False;
  FRemoteFTPOnExit.Color := FRemoteBackupPanel.Color;
  FRemoteFTPOnExit.ParentFont := False;
  FRemoteFTPOnExit.Font.Name := 'Sans';
  FRemoteFTPOnExit.Font.Height := -11;
  FRemoteFTPOnExit.Font.Style := [fsBold];

  CrearEtiqueta(FRemoteHostLabel, 'Servidor / IP:');
  CrearEtiqueta(FRemotePortLabel, 'Puerto SSH:');
  CrearEtiqueta(FRemoteUserLabel, 'Usuario SSH:');
  CrearEtiqueta(FRemoteAuthLabel, 'Autenticación:');
  CrearEtiqueta(FRemoteKeyLabel, 'Clave privada:');
  CrearEtiqueta(FRemoteDestinationLabel, 'Destino local:');
  CrearEtiqueta(FRemoteCommandLabel, 'Script servidor:');
  CrearEtiqueta(FRemoteKeepLabel, 'Copias servidor:');

  CrearEditor(FRemoteHost);
  CrearEditor(FRemotePort);
  CrearEditor(FRemoteUser);

  FRemoteAuth := TComboBox.Create(Self);
  FRemoteAuth.Parent := FRemoteBackupPanel;
  FRemoteAuth.ParentFont := False;
  FRemoteAuth.Font.Name := 'Sans';
  FRemoteAuth.Font.Height := -11;
  FRemoteAuth.Style := csDropDownList;
  FRemoteAuth.Items.Add('Clave privada');
  FRemoteAuth.Items.Add('Contraseña');
  FRemoteAuth.ItemIndex := 0;

  CrearEditor(FRemoteKey);
  CrearEditor(FRemotePassword);
  FRemotePassword.PasswordChar := '*';
  CrearEditor(FRemoteDestination);
  CrearEditor(FRemoteCommand);
  CrearEditor(FRemoteKeep);

  FRemoteKeyBrowse := TBitBtn.Create(Self);
  PrepararBoton(FRemoteKeyBrowse, '...', RGBToColor(55, 65, 81));
  FRemoteKeyBrowse.OnClick := @BackupRemotoBuscarClave;

  FRemoteDestinationBrowse := TBitBtn.Create(Self);
  PrepararBoton(FRemoteDestinationBrowse, '...', RGBToColor(55, 65, 81));
  FRemoteDestinationBrowse.OnClick := @BackupRemotoBuscarDestino;

  FRemoteTest := TBitBtn.Create(Self);
  PrepararBoton(FRemoteTest, 'Probar conexión', RGBToColor(23, 96, 116));
  FRemoteTest.OnClick := @BackupRemotoProbar;

  FRemoteRunNow := TBitBtn.Create(Self);
  PrepararBoton(FRemoteRunNow, 'Ejecutar ahora', RGBToColor(22, 130, 84));
  FRemoteRunNow.OnClick := @BackupRemotoEjecutar;

  FRemoteBackupInfo := TLabel.Create(Self);
  FRemoteBackupInfo.Parent := FRemoteBackupPanel;
  FRemoteBackupInfo.AutoSize := False;
  FRemoteBackupInfo.Transparent := True;
  FRemoteBackupInfo.ParentFont := False;
  FRemoteBackupInfo.Font.Name := 'Sans';
  FRemoteBackupInfo.Font.Height := -10;
  FRemoteBackupInfo.Font.Style := [fsBold];
  FRemoteBackupInfo.Font.Color := RGBToColor(71, 85, 105);
  FRemoteBackupInfo.WordWrap := True;

  RecolocarControlesBackupRemoto;
end;

procedure TFConfig.RecolocarControlesBackupRemoto;
var
  W, Half, LeftEditX, LeftEditW, RightX, RightEditX, RightEditW: Integer;
begin
  if not Assigned(FRemoteBackupPanel) then Exit;

  if not Assigned(FRemoteBackupTab) then Exit;

  W := FRemoteBackupTab.ClientWidth - 36;
  if W < 820 then W := 820;
  FRemoteBackupPanel.SetBounds(18, 18, W, 318);
  FRemoteBackupHeader.SetBounds(0, 0, W, 38);
  FRemoteBackupTitle.SetBounds(12, 0, W - 24, 38);

  Half := W div 2;
  LeftEditX := 126;
  LeftEditW := Half - LeftEditX - 24;
  RightX := Half + 18;
  RightEditX := RightX + 118;
  RightEditW := W - RightEditX - 22;

  FRemoteEnabled.SetBounds(20, 46, Half - 30, 28);
  FRemoteAutoOnExit.SetBounds(Half + 12, 46, Half - 32, 28);
  FRemoteFTPOnExit.SetBounds(20, 76, W - 40, 26);

  FRemoteHostLabel.SetBounds(20, 110, 102, 28);
  FRemoteHost.SetBounds(LeftEditX, 108, LeftEditW, 29);
  FRemoteUserLabel.SetBounds(RightX, 110, 108, 28);
  FRemoteUser.SetBounds(RightEditX, 108, RightEditW, 29);

  FRemotePortLabel.SetBounds(20, 150, 102, 28);
  FRemotePort.SetBounds(LeftEditX, 148, 90, 29);
  FRemoteKeepLabel.SetBounds(RightX, 150, 108, 28);
  FRemoteKeep.SetBounds(RightEditX, 148, 90, 29);

  FRemoteAuthLabel.SetBounds(20, 190, 102, 28);
  FRemoteAuth.SetBounds(LeftEditX, 188, LeftEditW, 29);

  FRemoteDestinationLabel.SetBounds(RightX, 190, 108, 28);
  FRemoteDestination.SetBounds(RightEditX, 188, RightEditW - 38, 29);
  FRemoteDestinationBrowse.SetBounds(RightEditX + RightEditW - 34, 188, 34, 29);

  FRemoteKeyLabel.SetBounds(20, 230, 102, 28);
  FRemoteKey.SetBounds(LeftEditX, 228, LeftEditW - 38, 29);
  FRemotePassword.SetBounds(LeftEditX, 228, LeftEditW, 29);
  FRemoteKeyBrowse.SetBounds(LeftEditX + LeftEditW - 34, 228, 34, 29);

  FRemoteCommandLabel.SetBounds(RightX, 230, 108, 28);
  FRemoteCommand.SetBounds(RightEditX, 228, RightEditW, 29);

  FRemoteTest.SetBounds(20, 275, 150, 35);
  FRemoteRunNow.SetBounds(182, 275, 150, 35);
  FRemoteBackupInfo.SetBounds(350, 274, W - 370, 38);
  FRemoteBackupPanel.BringToFront;
end;

procedure TFConfig.ActualizarEstadoBackupRemoto;
var
  Activo, UsarPassword: Boolean;
begin
  if not Assigned(FRemoteEnabled) then Exit;
  Activo := FRemoteEnabled.Checked;
  UsarPassword := Assigned(FRemoteAuth) and (FRemoteAuth.ItemIndex = 1);
  FRemoteAutoOnExit.Enabled := Activo;
  FRemoteFTPOnExit.Enabled := Activo and FRemoteAutoOnExit.Checked;
  FRemoteHost.Enabled := Activo;
  FRemotePort.Enabled := Activo;
  FRemoteUser.Enabled := Activo;
  FRemoteAuth.Enabled := Activo;
  FRemoteKey.Enabled := Activo and not UsarPassword;
  FRemotePassword.Enabled := Activo and UsarPassword;
  FRemoteKey.Visible := not UsarPassword;
  FRemotePassword.Visible := UsarPassword;
  FRemoteKeyBrowse.Visible := not UsarPassword;
  FRemoteKeyBrowse.Enabled := Activo and not UsarPassword;
  if UsarPassword then
    FRemoteKeyLabel.Caption := 'Contraseña SSH:'
  else
    FRemoteKeyLabel.Caption := 'Clave privada:';
  FRemoteDestination.Enabled := Activo;
  FRemoteCommand.Enabled := Activo;
  FRemoteKeep.Enabled := Activo;
  FRemoteDestinationBrowse.Enabled := Activo;
  FRemoteTest.Enabled := Activo;
  FRemoteRunNow.Enabled := Activo;

  if not Activo then
  begin
    FRemoteBackupInfo.Font.Color := RGBToColor(71, 85, 105);
    FRemoteBackupInfo.Caption := 'La copia física remota está desactivada.';
  end
  else
  begin
    FRemoteBackupInfo.Font.Color := RGBToColor(22, 101, 52);
    if FRemoteFTPOnExit.Checked then
      FRemoteBackupInfo.Caption :=
        'Copia física completa, SHA-256 y FTP al cerrar; independiente del modo mono-usuario.'
    else
      FRemoteBackupInfo.Caption :=
        'Copia física completa por SSH y SHA-256; independiente del modo mono-usuario.';
  end;
end;

procedure TFConfig.BackupRemotoCambio(Sender: TObject);
begin
  ActualizarEstadoBackupRemoto;
  Edit1Change(Sender);

  { Las opciones principales se guardan inmediatamente en el fichero real.
    Se abre un TIniFile nuevo para no depender de una instancia que pueda
    conservar valores anteriores en memoria. }
  if Sender is TCheckBox then
    GuardarConfiguracionBackupRemotoPersistente;
end;

procedure TFConfig.BackupRemotoBuscarClave(Sender: TObject);
var
  Dlg: TOpenDialog;
begin
  Dlg := TOpenDialog.Create(Self);
  try
    Dlg.Title := 'Seleccionar clave privada SSH';
    Dlg.FileName := FRemoteKey.Text;
    if Dlg.Execute then
    begin
      FRemoteKey.Text := Dlg.FileName;
      BackupRemotoCambio(FRemoteKey);
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TFConfig.BackupRemotoBuscarDestino(Sender: TObject);
begin
  SelectDirectoryDialog1.Title := 'Carpeta local para las copias remotas';
  SelectDirectoryDialog1.FileName := FRemoteDestination.Text;
  if SelectDirectoryDialog1.Execute then
  begin
    FRemoteDestination.Text := SelectDirectoryDialog1.FileName;
    BackupRemotoCambio(FRemoteDestination);
  end;
end;

procedure TFConfig.GuardarConfiguracionBackupRemoto(AIni: TIniFile);
begin
  if (not Assigned(AIni)) or (not Assigned(FRemoteEnabled)) then Exit;

  { Se usa 1/0 como formato canónico y una lectura tolerante. Así se
    aceptan también configuraciones anteriores que contengan True/False. }
  FLXIniWriteBoolCompat(AIni, 'BackupRemoto', 'Activo',
    FRemoteEnabled.Checked);
  FLXIniWriteBoolCompat(AIni, 'BackupRemoto', 'AutomaticoAlSalir',
    FRemoteAutoOnExit.Checked);
  FLXIniWriteBoolCompat(AIni, 'BackupRemoto', 'EnviarFTPAlSalir',
    FRemoteFTPOnExit.Checked);
  AIni.WriteString('BackupRemoto','Host',Trim(FRemoteHost.Text));
  AIni.WriteString('BackupRemoto','Puerto',Trim(FRemotePort.Text));
  AIni.WriteString('BackupRemoto','UsuarioSSH',Trim(FRemoteUser.Text));
  if Assigned(FRemoteAuth) and (FRemoteAuth.ItemIndex = 1) then
    AIni.WriteString('BackupRemoto','AutenticacionSSH',FLX_SSH_AUTH_PASSWORD)
  else
    AIni.WriteString('BackupRemoto','AutenticacionSSH',FLX_SSH_AUTH_KEY);
  AIni.WriteString('BackupRemoto','ClaveSSH',Trim(FRemoteKey.Text));
  FLX_IniWritePassword(AIni, 'BackupRemoto', 'PasswordSSH',
    FRemotePassword.Text);
  AIni.WriteString('BackupRemoto','DestinoLocal',Trim(FRemoteDestination.Text));
  AIni.WriteString('BackupRemoto','ComandoServidor',Trim(FRemoteCommand.Text));
  AIni.WriteString('BackupRemoto','CopiasEnServidor',Trim(FRemoteKeep.Text));
  AIni.WriteInteger('BackupRemoto','TiempoEsperaSegundos',14400);
end;

procedure TFConfig.RecargarIniReaderDesdeDisco;
begin
  FreeAndNil(IniReader);
  IniReader := FLXOpenFacturConfIni;

  if Assigned(Sections) then
  begin
    Sections.Clear;
    IniReader.ReadSections(Sections);
  end;
end;

procedure TFConfig.GuardarConfiguracionBackupRemotoPersistente;
var
  LIni: TIniFile;
begin
  if not Assigned(FRemoteEnabled) then Exit;

  { Siempre se parte del contenido ACTUAL que hay en disco. De este modo se
    conservan todas las secciones y claves que no pertenecen a BackupRemoto. }
  FLXCreateFacturConfBackup;
  LIni := FLXOpenFacturConfIni;
  try
    GuardarConfiguracionBackupRemoto(LIni);
    LIni.UpdateFile;
  finally
    LIni.Free;
  end;

  { La instancia mantenida por el formulario no puede quedar desfasada. }
  RecargarIniReaderDesdeDisco;
end;

procedure TFConfig.CargarConfiguracionBackupRemotoPersistente;
var
  LIni: TIniFile;
begin
  if not Assigned(FRemoteEnabled) then Exit;

  LIni := FLXOpenFacturConfIni;
  try
    FRemoteEnabled.Checked :=
      FLXIniReadBoolCompat(LIni, 'BackupRemoto', 'Activo', False);
    FRemoteAutoOnExit.Checked :=
      FLXIniReadBoolCompat(LIni, 'BackupRemoto',
        'AutomaticoAlSalir', False);
    FRemoteFTPOnExit.Checked :=
      FLXIniReadBoolCompat(LIni, 'BackupRemoto',
        'EnviarFTPAlSalir', False);
    FRemoteHost.Text := LIni.ReadString('BackupRemoto','Host','');
    FRemotePort.Text := LIni.ReadString('BackupRemoto','Puerto','22');
    FRemoteUser.Text := LIni.ReadString('BackupRemoto','UsuarioSSH','');
    if UpperCase(LIni.ReadString('BackupRemoto','AutenticacionSSH',
      FLX_SSH_AUTH_KEY)) = FLX_SSH_AUTH_PASSWORD then
      FRemoteAuth.ItemIndex := 1
    else
      FRemoteAuth.ItemIndex := 0;
    FRemoteKey.Text := LIni.ReadString('BackupRemoto','ClaveSSH',
      IncludeTrailingPathDelimiter(GetUserDir)+'.ssh'+PathDelim+'id_ed25519');
    FRemotePassword.Text := FLX_IniReadPassword(LIni,
      'BackupRemoto', 'PasswordSSH', '');
    FRemoteDestination.Text := LIni.ReadString('BackupRemoto','DestinoLocal',
      IncludeTrailingPathDelimiter(GetUserDir)+'CopiasFacturLinEx');
    FRemoteCommand.Text := LIni.ReadString('BackupRemoto','ComandoServidor',
      '/usr/local/sbin/flx_remote_backup_server');
    FRemoteKeep.Text := LIni.ReadString('BackupRemoto','CopiasEnServidor','7');
  finally
    LIni.Free;
  end;
end;

function TFConfig.ConfiguracionBackupRemotoActual: TFLXRemoteBackupConfig;
begin
  FLXRemoteBackupDefaults(Result);
  Result.Enabled := FRemoteEnabled.Checked;
  Result.AutoOnExit := FRemoteAutoOnExit.Checked;
  Result.FTPOnExit := FRemoteFTPOnExit.Checked;
  Result.Host := Trim(FRemoteHost.Text);
  Result.Port := StrToIntDef(Trim(FRemotePort.Text), 0);
  Result.UserName := Trim(FRemoteUser.Text);
  if Assigned(FRemoteAuth) and (FRemoteAuth.ItemIndex = 1) then
    Result.AuthMethod := FLX_SSH_AUTH_PASSWORD
  else
    Result.AuthMethod := FLX_SSH_AUTH_KEY;
  Result.IdentityFile := Trim(FRemoteKey.Text);
  Result.Password := FRemotePassword.Text;
  Result.LocalDestination := Trim(FRemoteDestination.Text);
  Result.RemoteCommand := Trim(FRemoteCommand.Text);
  Result.KeepRemoteCopies := StrToIntDef(Trim(FRemoteKeep.Text), 0);
  Result.TimeoutSeconds := 14400;
  Result.DatabaseLabel := Trim(Edit14.Text);
  if Result.DatabaseLabel = '' then Result.DatabaseLabel := 'facturlinex';
end;

procedure TFConfig.BackupRemotoProbar(Sender: TObject);
var
  Cfg: TFLXRemoteBackupConfig;
  Msg: string;
begin
  GuardarConfiguracionBackupRemotoPersistente;
  Cfg := ConfiguracionBackupRemotoActual;
  Screen.Cursor := crHourGlass;
  FRemoteTest.Enabled := False;
  try
    if FLXTestRemoteBackupConnection(Cfg, Msg) then
      ShowMessage(Msg + LineEnding +
        'La prueba confirma SSH, sudo, mariadb-backup y el fichero de credenciales del servidor.')
    else
      ShowMessage('ERROR DE CONEXIÓN:' + LineEnding + Msg);
  finally
    Screen.Cursor := crDefault;
    ActualizarEstadoBackupRemoto;
  end;
end;

procedure TFConfig.BackupRemotoEjecutar(Sender: TObject);
var
  Cfg: TFLXRemoteBackupConfig;
  LocalFile, Msg: string;
begin
  GuardarConfiguracionBackupRemotoPersistente;
  Cfg := ConfiguracionBackupRemotoActual;
  Screen.Cursor := crHourGlass;
  FRemoteRunNow.Enabled := False;
  try
    if FLXRunRemoteBackup(Cfg, LocalFile, Msg) then
      ShowMessage(Msg)
    else
      ShowMessage('ERROR EN LA COPIA FÍSICA REMOTA:' + LineEnding + Msg);
  finally
    Screen.Cursor := crDefault;
    ActualizarEstadoBackupRemoto;
  end;
end;

//============================================================================
//====================== CAPA VISUAL MODERNA =================================
//============================================================================
function TFConfig.CrearTarjetaVisual(AParent: TWinControl; ALeft, ATop,
  AWidth, AHeight: Integer; AColor: TColor; const ATitulo: string): TShape;
var
  LTitulo: TLabel;
begin
  Result := TShape.Create(Self);
  Result.Parent := AParent;
  Result.Shape := stRectangle;
  Result.SetBounds(ALeft, ATop, AWidth, AHeight);
  Result.Brush.Color := AColor;
  Result.Pen.Color := RGBToColor(207, 218, 224);
  Result.Pen.Width := 1;
  Result.Tag := 4202601;
  Result.SendToBack;

  if Trim(ATitulo) <> '' then
  begin
    LTitulo := TLabel.Create(Self);
    LTitulo.Parent := AParent;
    LTitulo.SetBounds(ALeft + 16, ATop + 4, AWidth - 32, 22);
    LTitulo.AutoSize := False;
    LTitulo.Caption := ATitulo;
    LTitulo.Transparent := True;
    LTitulo.ParentFont := False;
    LTitulo.Font.Name := 'Sans';
    LTitulo.Font.Height := -12;
    LTitulo.Font.Style := [fsBold];
    LTitulo.Font.Color := RGBToColor(18, 76, 91);
    LTitulo.Tag := 4202601;
    LTitulo.Layout := tlCenter;
    LTitulo.BringToFront;
  end;
end;

procedure TFConfig.CrearBotonVisual(ABoton: TBitBtn; var APanel: TPanel;
  const AHint: string);
var
  LTexto: TLabel;
  W, H: Integer;
  Evento: TNotifyEvent;
begin
  if not Assigned(ABoton) then Exit;

  W := ABoton.Width;
  H := ABoton.Height;
  if W < 36 then W := 36;
  if H < 29 then H := 29;
  Evento := ABoton.OnClick;

  APanel := TPanel.Create(Self);
  APanel.Parent := ABoton.Parent;
  APanel.SetBounds(ABoton.Left, ABoton.Top, W, H);
  APanel.Caption := '';
  APanel.BevelOuter := bvRaised;
  APanel.BevelInner := bvNone;
  APanel.BorderWidth := 1;
  APanel.ParentColor := False;
  APanel.Color := RGBToColor(23, 96, 116);
  APanel.Cursor := crHandPoint;
  APanel.Hint := AHint;
  APanel.ShowHint := True;
  APanel.OnClick := Evento;
  APanel.OnKeyPress := @BotonVisualKeyPress;
  APanel.TabStop := True;
  APanel.TabOrder := ABoton.TabOrder;
  APanel.Enabled := ABoton.Enabled;
  APanel.Visible := ABoton.Visible;

  LTexto := TLabel.Create(Self);
  LTexto.Parent := APanel;
  LTexto.Align := alClient;
  LTexto.Alignment := taCenter;
  LTexto.Layout := tlCenter;
  LTexto.AutoSize := False;
  LTexto.Transparent := False;
  LTexto.ParentColor := False;
  LTexto.Color := APanel.Color;
  LTexto.ParentFont := False;
  LTexto.Font.Name := 'Sans';
  LTexto.Font.Height := -12;
  LTexto.Font.Style := [fsBold];
  LTexto.Font.Color := clWhite;
  LTexto.Cursor := crHandPoint;
  LTexto.Caption := '...';
  LTexto.Hint := AHint;
  LTexto.ShowHint := True;
  LTexto.OnClick := Evento;
  LTexto.BringToFront;

  ABoton.Visible := False;
end;

procedure TFConfig.CrearBotonAccionVisual(ABoton: TBitBtn;
  var APanel: TPanel; const ACaption, AHint: string; AColor: TColor);
var
  LTexto: TLabel;
  W, H: Integer;
begin
  if not Assigned(ABoton) then Exit;

  W := ABoton.Width;
  H := ABoton.Height;
  if W < 150 then W := 150;
  if H < 38 then H := 38;

  APanel := TPanel.Create(Self);
  APanel.Parent := ABoton.Parent;
  APanel.SetBounds(ABoton.Left, ABoton.Top, W, H);
  APanel.Caption := '';
  APanel.BevelOuter := bvRaised;
  APanel.BevelInner := bvLowered;
  APanel.BorderWidth := 2;
  APanel.ParentColor := False;
  APanel.Color := AColor;
  APanel.Cursor := crHandPoint;
  APanel.Hint := AHint;
  APanel.ShowHint := True;
  APanel.OnClick := @BotonAccionVisualClick;
  APanel.OnKeyPress := @BotonVisualKeyPress;
  APanel.TabStop := True;
  APanel.TabOrder := ABoton.TabOrder;
  APanel.Enabled := ABoton.Enabled;
  APanel.Visible := ABoton.Visible;

  LTexto := TLabel.Create(Self);
  LTexto.Parent := APanel;
  LTexto.Align := alClient;
  LTexto.Alignment := taCenter;
  LTexto.Layout := tlCenter;
  LTexto.AutoSize := False;
  LTexto.Transparent := False;
  LTexto.ParentColor := False;
  LTexto.Color := APanel.Color;
  LTexto.ParentFont := False;
  LTexto.Font.Name := 'Sans';
  LTexto.Font.Height := -12;
  LTexto.Font.Style := [fsBold];
  LTexto.Font.Color := clWhite;
  LTexto.Cursor := crHandPoint;
  LTexto.Caption := ACaption;
  LTexto.Hint := AHint;
  LTexto.ShowHint := True;
  LTexto.OnClick := @BotonAccionVisualClick;
  LTexto.BringToFront;

  ABoton.Visible := False;
end;

procedure TFConfig.BotonAccionVisualClick(Sender: TObject);
var
  LPanel: TPanel;
begin
  LPanel := nil;
  if Sender is TPanel then
    LPanel := TPanel(Sender)
  else if (Sender is TLabel) and (TLabel(Sender).Parent is TPanel) then
    LPanel := TPanel(TLabel(Sender).Parent);

  if LPanel = FBtnTestBBDDVisual then
  begin
    if BitBtn4.Enabled then BitBtn4Click(BitBtn4);
  end
  else if LPanel = FBtnTestSICVisual then
  begin
    if BitBtn5.Enabled then BitBtn5Click(BitBtn5);
  end;
end;

procedure TFConfig.ActualizarBotonesConexionVisual;
  procedure Actualiza(APanel: TPanel; AOriginal: TBitBtn);
  var
    LColor: TColor;
  begin
    if not Assigned(APanel) or not Assigned(AOriginal) then Exit;
    APanel.Enabled := AOriginal.Enabled;
    if AOriginal.Enabled then
      LColor := RGBToColor(23, 96, 116)
    else
      LColor := RGBToColor(148, 163, 184);
    APanel.Color := LColor;
    if (APanel.ControlCount > 0) and (APanel.Controls[0] is TLabel) then
    begin
      TLabel(APanel.Controls[0]).Color := LColor;
      TLabel(APanel.Controls[0]).Font.Color := clWhite;
      TLabel(APanel.Controls[0]).Enabled := AOriginal.Enabled;
    end;
  end;
begin
  Actualiza(FBtnTestBBDDVisual, BitBtn4);
  Actualiza(FBtnTestSICVisual, BitBtn5);
end;


procedure TFConfig.CrearCheckVisual(ACheck: TCheckBox; var APanel: TPanel;
  const ACaption, AHint: string; AColorFondo, AColorTexto: TColor);
var
  LMarca: TPanel;
  LTexto: TLabel;
  H: Integer;
begin
  if not Assigned(ACheck) then Exit;
  if Assigned(APanel) then Exit;

  H := ACheck.Height;
  if H < 34 then H := 34;

  APanel := TPanel.Create(Self);
  APanel.Parent := ACheck.Parent;
  APanel.SetBounds(ACheck.Left, ACheck.Top, ACheck.Width, H);
  APanel.Caption := '';
  APanel.BevelOuter := bvNone;
  APanel.BevelInner := bvNone;
  APanel.ParentColor := False;
  APanel.Color := AColorFondo;
  APanel.Cursor := crHandPoint;
  APanel.Hint := AHint;
  APanel.ShowHint := True;
  APanel.TabStop := True;
  APanel.TabOrder := ACheck.TabOrder;
  APanel.OnClick := @CheckVisualClick;
  APanel.OnKeyPress := @BotonVisualKeyPress;

  LMarca := TPanel.Create(Self);
  LMarca.Parent := APanel;
  LMarca.SetBounds(2, (H - 24) div 2, 24, 24);
  LMarca.Caption := '';
  LMarca.BevelOuter := bvLowered;
  LMarca.BevelInner := bvNone;
  LMarca.BorderWidth := 1;
  LMarca.ParentColor := False;
  LMarca.Color := clWhite;
  LMarca.Font.Name := 'Sans';
  LMarca.Font.Height := -14;
  LMarca.Font.Style := [fsBold];
  LMarca.Font.Color := RGBToColor(18, 76, 91);
  LMarca.Cursor := crHandPoint;
  LMarca.Tag := 1;
  LMarca.OnClick := @CheckVisualClick;

  LTexto := TLabel.Create(Self);
  LTexto.Parent := APanel;
  LTexto.SetBounds(36, 0, APanel.Width - 40, H);
  LTexto.AutoSize := False;
  LTexto.Alignment := taLeftJustify;
  LTexto.Layout := tlCenter;
  LTexto.WordWrap := False;
  LTexto.Transparent := False;
  LTexto.ParentColor := False;
  LTexto.Color := AColorFondo;
  LTexto.ParentFont := False;
  LTexto.Font.Name := 'Sans';
  LTexto.Font.Height := -13;
  LTexto.Font.Style := [fsBold];
  LTexto.Font.Color := AColorTexto;
  LTexto.Caption := ACaption;
  LTexto.Cursor := crHandPoint;
  LTexto.Hint := AHint;
  LTexto.ShowHint := True;
  LTexto.Tag := 2;
  LTexto.OnClick := @CheckVisualClick;

  ACheck.Visible := False;
  APanel.BringToFront;
end;

procedure TFConfig.CrearEtiquetaVisual(AOriginal: TLabel; var APanel: TPanel;
  const ACaption: string; AColorFondo, AColorTexto: TColor);
begin
  if not Assigned(AOriginal) then Exit;
  if Assigned(APanel) then Exit;

  APanel := TPanel.Create(Self);
  APanel.Parent := AOriginal.Parent;
  APanel.SetBounds(AOriginal.Left, AOriginal.Top, AOriginal.Width,
    AOriginal.Height);
  APanel.Caption := ACaption;
  APanel.BevelOuter := bvNone;
  APanel.BevelInner := bvNone;
  APanel.ParentColor := False;
  APanel.Color := AColorFondo;
  APanel.ParentFont := False;
  APanel.Font.Name := 'Sans';
  APanel.Font.Height := -13;
  APanel.Font.Style := [fsBold];
  APanel.Font.Color := AColorTexto;
  APanel.Alignment := taLeftJustify;
  AOriginal.Visible := False;
  APanel.BringToFront;
end;

procedure TFConfig.CheckVisualClick(Sender: TObject);
var
  LPanel: TPanel;
  LCheck: TCheckBox;
  LEvento: TNotifyEvent;
begin
  LPanel := nil;
  LCheck := nil;

  if Sender is TPanel then
  begin
    if TPanel(Sender).Parent is TPanel then
      LPanel := TPanel(TPanel(Sender).Parent)
    else
      LPanel := TPanel(Sender);
  end
  else if (Sender is TLabel) and (TLabel(Sender).Parent is TPanel) then
    LPanel := TPanel(TLabel(Sender).Parent);

  if LPanel = FCheckMonoVisual then
    LCheck := bbdd_autocopy
  else if LPanel = FCheckSICVisual then
    LCheck := CheckBox1
  else if LPanel = FCheckVFVisual then
    LCheck := vfCheckTest;

  if not Assigned(LCheck) or not LCheck.Enabled then Exit;

  LEvento := LCheck.OnChange;
  LCheck.OnChange := nil;
  LCheck.Checked := not LCheck.Checked;
  LCheck.OnChange := LEvento;
  if Assigned(LEvento) then
    LEvento(LCheck);

  SincronizarChecksVisuales;
end;

procedure TFConfig.SincronizarCheckVisual(APanel: TPanel; ACheck: TCheckBox);
var
  I: Integer;
  LMarca: TPanel;
  LTexto: TLabel;
  LColor: TColor;
begin
  if not Assigned(APanel) or not Assigned(ACheck) then Exit;

  LMarca := nil;
  LTexto := nil;
  for I := 0 to APanel.ControlCount - 1 do
  begin
    if (APanel.Controls[I] is TPanel) and (APanel.Controls[I].Tag = 1) then
      LMarca := TPanel(APanel.Controls[I])
    else if (APanel.Controls[I] is TLabel) and
      (APanel.Controls[I].Tag = 2) then
      LTexto := TLabel(APanel.Controls[I]);
  end;

  if Assigned(LMarca) then
    LMarca.SetBounds(2, (APanel.ClientHeight - 24) div 2, 24, 24);
  if Assigned(LTexto) then
    LTexto.SetBounds(36, 0, APanel.ClientWidth - 40, APanel.ClientHeight);

  APanel.Enabled := ACheck.Enabled;
  if ACheck.Enabled then
    LColor := RGBToColor(18, 76, 91)
  else
    LColor := RGBToColor(148, 163, 184);

  if Assigned(LMarca) then
  begin
    if ACheck.Checked then
      LMarca.Caption := 'X'
    else
      LMarca.Caption := '';
    LMarca.Font.Color := LColor;
    LMarca.Enabled := ACheck.Enabled;
  end;

  if Assigned(LTexto) then
  begin
    LTexto.Enabled := ACheck.Enabled;
    if ACheck.Enabled then
      LTexto.Font.Color := ACheck.Font.Color
    else
      LTexto.Font.Color := RGBToColor(100, 116, 139);
  end;
end;

procedure TFConfig.SincronizarChecksVisuales;
begin
  SincronizarCheckVisual(FCheckMonoVisual, bbdd_autocopy);
  SincronizarCheckVisual(FCheckSICVisual, CheckBox1);
  SincronizarCheckVisual(FCheckVFVisual, vfCheckTest);
end;

procedure TFConfig.SincronizarPosicionControlesVisuales;
  procedure SyncPanel(APanel: TPanel; AControl: TControl;
    AMinWidth, AMinHeight: Integer);
  var
    W, H: Integer;
  begin
    if not Assigned(APanel) or not Assigned(AControl) then Exit;
    W := AControl.Width;
    H := AControl.Height;
    if W < AMinWidth then W := AMinWidth;
    if H < AMinHeight then H := AMinHeight;
    APanel.SetBounds(AControl.Left, AControl.Top, W, H);
    APanel.BringToFront;
  end;
begin
  SyncPanel(FBtnLogoVisual, BitBtn12, 36, 29);
  SyncPanel(FBtnColorFormularioVisual, BitBtn7, 36, 29);
  SyncPanel(FBtnColorBotonesVisual, BitBtn8, 36, 29);
  SyncPanel(FBtnTiendaVisual, BitBtnCambiable1, 36, 29);
  SyncPanel(FBtnPuestoVisual, BitBtnCambiable2, 36, 29);
  SyncPanel(FBtnVisorPDFVisual, BitBtn13, 36, 29);
  SyncPanel(FBtnRutaPDFVisual, BitBtn14, 36, 29);
  SyncPanel(FBtnRutaImagenesVisual, BitBtn15, 36, 29);
  SyncPanel(FBtnTestBBDDVisual, BitBtn4, 150, 38);
  SyncPanel(FBtnTestSICVisual, BitBtn5, 150, 38);

  SyncPanel(FCheckMonoVisual, bbdd_autocopy, 420, 34);
  SyncPanel(FCheckSICVisual, CheckBox1, 360, 34);
  SyncPanel(FCheckVFVisual, vfCheckTest, 390, 34);
  SyncPanel(FLabelSICVisual, Label29, 360, 29);
  SyncPanel(FLabelVFVisual, Label159, 390, 42);
end;

procedure TFConfig.LimpiarTarjetasModernas;
var
  I: Integer;
begin
  for I := ComponentCount - 1 downto 0 do
    if (Components[I] is TControl) and
      (TControl(Components[I]).Tag = 4202601) then
      Components[I].Free;
end;

procedure TFConfig.FormShowModerno(Sender: TObject);
begin
  if FDisenoFinalAplicado then
  begin
    FLXAplicarTemaVisual(Self);
    ActualizarVistaPreviaContraste;
    Exit;
  end;
  FDisenoFinalAplicado := True;

  LimpiarTarjetasModernas;
  CrearTarjetasModernas;
  SincronizarPosicionControlesVisuales;
  SincronizarChecksVisuales;
  ActualizarBotonesConexionVisual;

  if Assigned(FHeaderTitle) then FHeaderTitle.BringToFront;
  if Assigned(FHeaderSubtitle) then FHeaderSubtitle.BringToFront;
  FLXAplicarTemaVisual(Self);
  ActualizarVistaPreviaContraste;
end;

procedure TFConfig.BotonVisualKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = #13) or (Key = #32) then
  begin
    if (Sender is TPanel) and Assigned(TPanel(Sender).OnClick) then
      TPanel(Sender).OnClick(Sender);
    Key := #0;
  end;
end;

procedure TFConfig.PrepararBotonPrincipal(ABoton: TBitBtn; AColor: TColor;
  ATextoClaro: Boolean);
begin
  if not Assigned(ABoton) then Exit;
  ABoton.ParentFont := False;
  ABoton.Font.Name := 'Sans';
  ABoton.Font.Height := -12;
  ABoton.Font.Style := [fsBold];
  ABoton.Height := 54;
  ABoton.Width := 130;
  ABoton.Color := AColor;
  if ATextoClaro then
    ABoton.Font.Color := clWhite
  else
    ABoton.Font.Color := RGBToColor(30, 41, 59);
end;

procedure TFConfig.CrearTarjetasModernas;
var
  W, M, G, Avail, C1, C2, C3, X1, X2, X3: Integer;
  MainW, SideW, SideX, EditX, EditW, RowY: Integer;
  SICX, SICW, SICY, SMTPX, SMTPW, SMTPY, SMTPH: Integer;
  FieldX, FieldW: Integer;

  procedure Pos(C: TControl; ALeft, ATop, AWidth, AHeight: Integer);
  begin
    if C <> nil then
      C.SetBounds(ALeft, ATop, AWidth, AHeight);
  end;

  procedure Lbl(C: TLabel; ALeft, ATop, AWidth, AHeight: Integer);
  begin
    if C = nil then Exit;
    C.SetBounds(ALeft, ATop, AWidth, AHeight);
    C.AutoSize := False;
    C.WordWrap := False;
    C.Layout := tlCenter;
  end;

  procedure WrapLbl(C: TLabel; ALeft, ATop, AWidth, AHeight: Integer);
  begin
    if C = nil then Exit;
    C.SetBounds(ALeft, ATop, AWidth, AHeight);
    C.AutoSize := False;
    C.WordWrap := True;
    C.Layout := tlTop;
  end;

  procedure EncabezadoTarjeta(AParent: TWinControl; ALeft, ATop,
    AWidth, AHeight: Integer; const ATitulo: string; AColor: TColor);
  var
    P: TPanel;
  begin
    if not Assigned(AParent) then Exit;
    P := TPanel.Create(Self);
    P.Parent := AParent;
    P.SetBounds(ALeft, ATop, AWidth, AHeight);
    P.Caption := ATitulo;
    P.BevelOuter := bvNone;
    P.BevelInner := bvNone;
    P.ParentColor := False;
    P.Color := AColor;
    P.ParentFont := False;
    P.Font.Name := 'Sans';
    P.Font.Height := -13;
    P.Font.Style := [fsBold];
    P.Font.Color := clWhite;
    P.Alignment := taCenter;
    P.Tag := 4202601;
    P.BringToFront;
  end;

  procedure LayoutBackup(GB: TGroupBox; CB: TCheckBox;
    LInicio, LHoras1, LMin1, LDestino, LFin, LHoras2, LMin2: TLabel;
    EIniH, EIniM, EFinH, EFinM, EDestino: TEdit;
    UIniH, UIniM, UFinH, UFinM: TUpDown; ATop, AWidth: Integer);
  var
    Mid: Integer;
  begin
    if GB = nil then Exit;
    GB.SetBounds(90, ATop, AWidth, 146);
    Mid := AWidth div 2;

    Pos(CB, 24, 18, 190, 24);

    Lbl(LInicio, 24, 53, 105, 24);
    Pos(EIniH, 136, 49, 42, 29);
    Pos(UIniH, 178, 49, 16, 29);
    Lbl(LHoras1, 202, 53, 44, 24);
    Pos(EIniM, 252, 49, 42, 29);
    Pos(UIniM, 294, 49, 16, 29);
    Lbl(LMin1, 318, 53, 58, 24);

    Lbl(LFin, Mid, 53, 95, 24);
    Pos(EFinH, Mid + 102, 49, 42, 29);
    Pos(UFinH, Mid + 144, 49, 16, 29);
    Lbl(LHoras2, Mid + 168, 53, 44, 24);
    Pos(EFinM, Mid + 218, 49, 42, 29);
    Pos(UFinM, Mid + 260, 49, 16, 29);
    Lbl(LMin2, Mid + 284, 53, 58, 24);

    Lbl(LDestino, 24, 98, 105, 24);
    Pos(EDestino, 136, 94, AWidth - 168, 29);
  end;

begin
  W := PageControl1.ClientWidth - 24;
  if W <= 0 then
    W := Screen.Width - 48;
  if W < 1160 then W := 1160;
  if W > 1900 then W := 1900;
  M := 16;
  G := 16;

  Bevel1.Visible := False;
  Bevel2.Visible := False;

  { -----------------------------------------------------------------------
    REGISTRO: datos de empresa a la izquierda y apariencia a la derecha.
    ----------------------------------------------------------------------- }
  SideW := W div 3;
  if SideW < 450 then SideW := 450;
  if SideW > 560 then SideW := 560;
  MainW := W - (M * 2) - G - SideW;
  SideX := M + MainW + G;

  CrearTarjetaVisual(TabSheet1, M, 16, MainW, 530,
    RGBToColor(226, 238, 242), 'DATOS DE LA EMPRESA');
  CrearTarjetaVisual(TabSheet1, SideX, 16, SideW, 530,
    RGBToColor(231, 243, 234), 'LOGOTIPO Y APARIENCIA');
  CrearTarjetaVisual(TabSheet1, M, 562, W - (M * 2), 70,
    RGBToColor(239, 242, 244), 'MODO DE TRABAJO');

  EditX := M + 150;
  EditW := MainW - 178;
  Lbl(Label1, M + 24, 50, 118, 29);
  Pos(Edit1, EditX, 50, EditW, 29);
  Lbl(Label2, M + 24, 98, 118, 29);
  Pos(Edit2, EditX, 98, EditW, 29);
  Lbl(Label3, M + 24, 146, 118, 29);
  Pos(Edit3, EditX, 146, EditW, 29);

  C1 := (EditW * 35) div 100;
  Lbl(Label5, M + 24, 194, 118, 29);
  Pos(Edit4, EditX, 194, C1, 29);
  Lbl(Label4, EditX + C1 + 10, 194, 78, 29);
  Pos(Edit5, EditX + C1 + 92, 194, 78, 29);
  Lbl(Label6, EditX + C1 + 180, 194, 82, 29);
  Pos(Edit6, EditX + C1 + 266, 194, EditW - C1 - 266, 29);

  C1 := (EditW - 170) div 3;
  Lbl(Label7, M + 24, 242, 118, 29);
  Pos(Edit7, EditX, 242, C1, 29);
  Lbl(Label8, EditX + C1 + 10, 242, 72, 29);
  Pos(Edit8, EditX + C1 + 86, 242, C1, 29);
  Lbl(Label9, EditX + (C1 * 2) + 96, 242, 48, 29);
  Pos(Edit9, EditX + (C1 * 2) + 148, 242, EditW - (C1 * 2) - 148, 29);

  Lbl(Label10, M + 24, 290, 118, 29);
  Pos(Edit10, EditX, 290, EditW, 29);
  Lbl(Label18, M + 24, 338, 118, 29);
  Pos(Edit16, EditX, 338, EditW, 29);

  Pos(Image1, SideX + ((SideW - 240) div 2), 52, 240, 220);
  Lbl(Label68, SideX + 24, 292, 110, 29);
  Pos(Edit57, SideX + 136, 292, SideW - 196, 29);
  Pos(BitBtn12, SideX + SideW - 52, 292, 34, 29);
  Lbl(Label115, SideX + 24, 346, 170, 29);
  Pos(Edit67, SideX + 210, 346, SideW - 270, 29);
  Pos(BitBtn7, SideX + SideW - 52, 346, 34, 29);
  Lbl(Label116, SideX + 24, 398, 170, 29);
  Pos(Edit68, SideX + 210, 398, SideW - 270, 29);
  Pos(BitBtn8, SideX + SideW - 52, 398, 34, 29);
  Pos(bbdd_autocopy, M + 26, 586, W - 72, 28);

  { -----------------------------------------------------------------------
    CONFIGURACIÓN GENERAL 1: tres zonas completas, sin textos entre tarjetas.
    ----------------------------------------------------------------------- }
  Avail := W - (M * 2) - (G * 2);
  C1 := (Avail * 30) div 100;
  C2 := (Avail * 34) div 100;
  C3 := Avail - C1 - C2;
  X1 := M;
  X2 := X1 + C1 + G;
  X3 := X2 + C2 + G;

  CrearTarjetaVisual(TabSheet10, X1, 16, C1, 610,
    RGBToColor(226, 238, 242), 'ACCESO Y FUNCIONAMIENTO DE VENTAS');
  CrearTarjetaVisual(TabSheet10, X2, 16, C2, 610,
    RGBToColor(231, 243, 234), 'AVISOS, PRECISIÓN Y PARÁMETROS');
  CrearTarjetaVisual(TabSheet10, X3, 16, C3, 610,
    RGBToColor(239, 235, 247), 'CLIENTES Y CAJA');

  RowY := 52;
  Lbl(Label118, X1 + 22, RowY, C1 - 120, 29); Pos(ComboBox29, X1 + C1 - 82, RowY + 3, 56, 25);
  Inc(RowY, 48);
  Lbl(Label85, X1 + 22, RowY, C1 - 120, 29); Pos(ComboBox1, X1 + C1 - 82, RowY + 3, 56, 25);
  Inc(RowY, 48);
  Lbl(Label123, X1 + 22, RowY, C1 - 120, 29); Pos(ComboBox31, X1 + C1 - 82, RowY + 3, 56, 25);
  Inc(RowY, 48);
  Lbl(lbStock, X1 + 22, RowY, C1 - 120, 29); Pos(cbRupturaStock, X1 + C1 - 82, RowY + 3, 56, 25);
  Inc(RowY, 48);
  Lbl(Label87, X1 + 22, RowY, C1 - 120, 29); Pos(ComboBox3, X1 + C1 - 82, RowY + 3, 56, 25);
  Inc(RowY, 48);
  Lbl(LabelLOPD, X1 + 22, RowY, C1 - 120, 29); Pos(ComboBoxLOPD, X1 + C1 - 82, RowY + 3, 56, 25);
  Inc(RowY, 48);
  Lbl(Label93, X1 + 22, RowY, C1 - 120, 29); Pos(ComboBox9, X1 + C1 - 82, RowY + 3, 56, 25);
  Inc(RowY, 48);
  Lbl(Label94, X1 + 22, RowY, C1 - 120, 29); Pos(ComboBox10, X1 + C1 - 82, RowY + 3, 56, 25);
  Inc(RowY, 48);
  Lbl(Label95, X1 + 22, RowY, C1 - 120, 29); Pos(ComboBox11, X1 + C1 - 82, RowY + 3, 56, 25);

  RowY := 52;
  WrapLbl(Label84, X2 + 22, RowY, C2 - 250, 42); Pos(Edit66, X2 + C2 - 210, RowY + 6, 180, 29);
  Inc(RowY, 54);
  WrapLbl(Label111, X2 + 22, RowY, C2 - 300, 42);
  Pos(ComboBox27, X2 + C2 - 270, RowY + 3, 56, 25);
  Lbl(Label82, X2 + C2 - 205, RowY, 100, 29);
  Pos(Edit64, X2 + C2 - 105, RowY, 42, 29);
  Lbl(Label113, X2 + C2 - 58, RowY, 40, 29);
  Inc(RowY, 54);
  WrapLbl(Label112, X2 + 22, RowY, C2 - 300, 42);
  Pos(ComboBox28, X2 + C2 - 270, RowY + 3, 56, 25);
  Lbl(Label83, X2 + C2 - 205, RowY, 100, 29);
  Pos(Edit65, X2 + C2 - 105, RowY, 42, 29);
  Lbl(Label114, X2 + C2 - 58, RowY, 40, 29);
  Inc(RowY, 54);
  WrapLbl(Label124, X2 + 22, RowY, C2 - 250, 42); Pos(cbPrecision, X2 + C2 - 210, RowY + 6, 180, 25);
  Inc(RowY, 54);
  Lbl(lbMoneda, X2 + 22, RowY, C2 - 250, 29); Pos(edMoneda, X2 + C2 - 210, RowY, 180, 29);

  RowY := 52;
  Lbl(lbCliVario, X3 + 22, RowY, C3 - 250, 29); Pos(edCliVario, X3 + C3 - 210, RowY, 180, 29);
  Inc(RowY, 54);
  Lbl(lbCliVario1, X3 + 22, RowY, C3 - 250, 29); Pos(CgSCajon, X3 + C3 - 210, RowY, 180, 29);
  Inc(RowY, 62);
  if Assigned(lbClientesBuscarNIFCodigo) then
  begin
    WrapLbl(lbClientesBuscarNIFCodigo, X3 + 22, RowY, C3 - 250, 42);
    Pos(cbClientesBuscarNIFCodigo, X3 + C3 - 210, RowY + 3, 90, 29);
    Inc(RowY, 62);
    WrapLbl(lbClientesModoCodigoAltaNIF, X3 + 22, RowY, C3 - 250, 42);
    Pos(cbClientesModoCodigoAltaNIF, X3 + C3 - 210, RowY + 3, 180, 29);
    Inc(RowY, 62);
    WrapLbl(lbClientesCodigoSuperiorDesde, X3 + 22, RowY, C3 - 250, 42);
    Pos(edClientesCodigoSuperiorDesde, X3 + C3 - 210, RowY + 3, 180, 29);
  end;

  { -----------------------------------------------------------------------
    CONFIGURACIÓN GENERAL 2.
    ----------------------------------------------------------------------- }
  CrearTarjetaVisual(TabSheet9, X1, 16, C1, 610,
    RGBToColor(226, 238, 242), 'REGLAS DE VENTA Y CRÉDITO');
  CrearTarjetaVisual(TabSheet9, X2, 16, C2, 610,
    RGBToColor(231, 243, 234), 'IMPRESIÓN AUTOMÁTICA');
  CrearTarjetaVisual(TabSheet9, X3, 16, C3, 610,
    RGBToColor(242, 238, 226), 'AVISOS Y DOCUMENTOS');

  RowY := 52;
  Lbl(Label86, X1 + 22, RowY, C1 - 120, 29); Pos(ComboBox2, X1 + C1 - 82, RowY + 3, 56, 25);
  Inc(RowY, 54);
  Lbl(Label88, X1 + 22, RowY, C1 - 120, 29); Pos(ComboBox4, X1 + C1 - 82, RowY + 3, 56, 25);
  Inc(RowY, 48);
  Lbl(Label89, X1 + 22, RowY, C1 - 120, 29); Pos(ComboBox5, X1 + C1 - 82, RowY + 3, 56, 25);
  Inc(RowY, 54);
  Lbl(Label90, X1 + 22, RowY, C1 - 120, 29); Pos(ComboBox6, X1 + C1 - 82, RowY + 3, 56, 25);
  Inc(RowY, 54);
  Lbl(Label91, X1 + 22, RowY, C1 - 120, 29); Pos(ComboBox7, X1 + C1 - 82, RowY + 3, 56, 25);
  Inc(RowY, 48);
  Lbl(Label92, X1 + 22, RowY, C1 - 120, 29); Pos(ComboBox8, X1 + C1 - 82, RowY + 3, 56, 25);

  RowY := 52;
  Lbl(Label98, X2 + 22, RowY, C2 - 210, 29); Pos(ComboBox14, X2 + C2 - 180, RowY + 3, 150, 25);
  Inc(RowY, 48);
  Lbl(Label99, X2 + 22, RowY, C2 - 210, 29); Pos(ComboBox15, X2 + C2 - 180, RowY + 3, 150, 25);
  Inc(RowY, 48);
  Lbl(Label100, X2 + 22, RowY, C2 - 210, 29); Pos(ComboBox16, X2 + C2 - 180, RowY + 3, 150, 25);
  Inc(RowY, 48);
  Lbl(Label101, X2 + 22, RowY, C2 - 210, 29); Pos(ComboBox17, X2 + C2 - 180, RowY + 3, 150, 25);
  Inc(RowY, 48);
  Lbl(Label102, X2 + 22, RowY, C2 - 210, 29); Pos(ComboBox18, X2 + C2 - 180, RowY + 3, 150, 25);
  Inc(RowY, 48);
  Lbl(Label103, X2 + 22, RowY, C2 - 210, 29); Pos(ComboBox19, X2 + C2 - 180, RowY + 3, 150, 25);
  Inc(RowY, 48);
  Lbl(Label104, X2 + 22, RowY, C2 - 210, 29); Pos(ComboBox20, X2 + C2 - 180, RowY + 3, 150, 25);

  RowY := 52;
  Lbl(Label110, X3 + 22, RowY, C3 - 210, 54);
  Pos(ComboBox26, X3 + C3 - 180, RowY + 12, 150, 25);
  Inc(RowY, 82);
  Lbl(Label97, X3 + 22, RowY, C3 - 120, 34);
  Pos(ComboBox13, X3 + C3 - 82, RowY + 4, 56, 25);
  Inc(RowY, 62);
  Lbl(Label105, X3 + 22, RowY, C3 - 120, 54);
  Pos(ComboBox21, X3 + C3 - 82, RowY + 12, 56, 25);

  { -----------------------------------------------------------------------
    CONEXIONES.
    ----------------------------------------------------------------------- }
  X1 := M;
  if W >= 1600 then
  begin
    C1 := 550;
    C2 := 590;
    C3 := W - (M * 2) - (G * 2) - C1 - C2;
    X2 := X1 + C1 + G;
    X3 := X2 + C2 + G;
    SICX := X2;
    SICW := C2;
    SICY := 212;
    SMTPX := X3;
    SMTPW := C3;
    SMTPY := 16;
    SMTPH := 626;
  end
  else
  begin
    C1 := (W - (M * 2) - G) div 2;
    C2 := W - (M * 2) - G - C1;
    C3 := C2;
    X2 := X1 + C1 + G;
    X3 := X2;
    SICX := X1;
    SICW := C1;
    SICY := 362;
    SMTPX := X2;
    SMTPW := C2;
    SMTPY := 212;
    SMTPH := 550;
  end;

  CrearTarjetaVisual(TabSheet2, X1, 16, C1, 330,
    RGBToColor(226, 238, 242), 'BASE DE DATOS PRINCIPAL');
  CrearTarjetaVisual(TabSheet2, X2, 16, C2, 180,
    RGBToColor(231, 243, 234), 'TIENDA ACTIVA Y PUESTO');
  CrearTarjetaVisual(TabSheet2, SICX, SICY, SICW, 400,
    RGBToColor(239, 235, 247), 'SISTEMA DE INFORMACIÓN COMÚN');
  CrearTarjetaVisual(TabSheet2, SMTPX, SMTPY, SMTPW, SMTPH,
    RGBToColor(242, 238, 226), 'CORREO ELECTRÓNICO (SMTP)');

  Lbl(Label11, X1 + 24, 52, 140, 29); Pos(Edit11, X1 + 174, 52, C1 - 204, 29);
  Lbl(Label12, X1 + 24, 94, 140, 29); Pos(Edit12, X1 + 174, 94, C1 - 204, 29);
  Lbl(Label13, X1 + 24, 136, 140, 29); Pos(Edit13, X1 + 174, 136, C1 - 204, 29);
  Lbl(Label14, X1 + 24, 178, 140, 29); Pos(Edit14, X1 + 174, 178, C1 - 204, 29);
  Lbl(Label15, X1 + 24, 220, 140, 29); Pos(Edit15, X1 + 174, 220, 92, 29);
  Lbl(Label161, X1 + 284, 220, 145, 29); Pos(CBMbbdd, X1 + 430, 218, C1 - 454, 31);
  Lbl(Label16, X1 + 24, 262, 140, 29); Pos(Combo1, X1 + 174, 262, C1 - 358, 31);
  Pos(BitBtn4, X1 + C1 - 176, 263, 150, 34);

  Pos(PanelCambiable1, X2 + 18, 52, C2 - 36, 50);
  Pos(PanelCambiable2, X2 + 18, 112, C2 - 36, 50);
  Lbl(LabelCambiable1, 10, 10, 128, 29);
  Pos(EditCambiableCodigo1, 142, 10, 92, 29);
  Pos(BitBtnCambiable1, 240, 10, 34, 29);
  Pos(ComboCambiableNombre1, 282, 9, PanelCambiable1.Width - 296, 31);
  Pos(StaticTextCambiableNombre1, 282, 10, PanelCambiable1.Width - 296, 29);
  Lbl(LabelCambiable2, 10, 10, 128, 29);
  Pos(EditCambiableCodigo2, 142, 10, 92, 29);
  Pos(BitBtnCambiable2, 240, 10, 34, 29);
  Pos(ComboCambiableNombre2, 282, 9, PanelCambiable2.Width - 296, 31);
  Pos(StaticTextCambiableNombre2, 282, 10, PanelCambiable2.Width - 296, 29);

  Lbl(Label29, SICX + 24, SICY + 34, SICW - 48, 29);
  Pos(CheckBox1, SICX + 24, SICY + 70, SICW - 48, 26);
  RowY := SICY + 110;
  Lbl(Label23, SICX + 24, RowY, 128, 29); Pos(Edit21, SICX + 158, RowY, SICW - 184, 29); Inc(RowY, 38);
  Lbl(Label24, SICX + 24, RowY, 128, 29); Pos(Edit22, SICX + 158, RowY, SICW - 184, 29); Inc(RowY, 38);
  Lbl(Label25, SICX + 24, RowY, 128, 29); Pos(Edit23, SICX + 158, RowY, SICW - 184, 29); Inc(RowY, 38);
  Lbl(Label26, SICX + 24, RowY, 128, 29); Pos(Edit24, SICX + 158, RowY, SICW - 184, 29); Inc(RowY, 38);
  Lbl(Label27, SICX + 24, RowY, 128, 29); Pos(Edit25, SICX + 158, RowY, 92, 29); Inc(RowY, 38);
  Lbl(Label28, SICX + 24, RowY, 128, 29); Pos(Combo2, SICX + 158, RowY, SICW - 184, 31);
  Pos(BitBtn5, SICX + ((SICW - 220) div 2), SICY + 350, 220, 34);

  Pos(GroupBox1, SMTPX + 12, SMTPY + 42, SMTPW - 24, SMTPH - 58);
  Pos(edCuenta, 118, 24, GroupBox1.Width - 236, 29);
  Lbl(Label17, 18, 24, 94, 29);
  Pos(cbSSL, GroupBox1.Width - 94, 25, 64, 24);
  Lbl(Label155, 18, 68, 94, 29);
  Pos(edCuentaCopia, 118, 68, GroupBox1.Width - 236, 29);
  Pos(cbTLS, GroupBox1.Width - 94, 69, 64, 24);
  Lbl(Label30, 18, 112, 94, 29); Pos(edUsuario, 118, 112, GroupBox1.Width - 148, 29);
  Lbl(Label150, 18, 156, 94, 29); Pos(edClave, 118, 156, GroupBox1.Width - 148, 29);
  Lbl(Label152, 18, 200, 94, 29); Pos(edHost, 118, 200, GroupBox1.Width - 330, 29);
  Lbl(Label151, GroupBox1.Width - 200, 200, 70, 29); Pos(edPuerto, GroupBox1.Width - 124, 200, 92, 29);
  Lbl(Label153, 18, 252, 94, 29); Pos(edCabecera, 118, 252, GroupBox1.Width - 148, 29);
  Lbl(Label154, 18, 296, 94, 29);
  Pos(edMensaje1, 118, 296, GroupBox1.Width - 148, 29);
  Pos(edMensaje2, 118, 330, GroupBox1.Width - 148, 29);
  Pos(edMensaje3, 118, 364, GroupBox1.Width - 148, 29);
  Pos(edmensaje4, 118, 398, GroupBox1.Width - 148, 29);

  { -----------------------------------------------------------------------
    ACTUALIZACIONES.
    ----------------------------------------------------------------------- }
  CrearTarjetaVisual(TabSheet3, M, 16, W - (M * 2), 280,
    RGBToColor(226, 238, 242), 'SERVIDOR DE ACTUALIZACIONES');
  Lbl(Label20, M + 28, 62, 230, 29); Pos(Edit18, M + 270, 62, W - 330, 29);
  Lbl(Label21, M + 28, 116, 230, 29); Pos(Edit19, M + 270, 116, W - 330, 29);
  Lbl(Label22, M + 28, 170, 230, 29); Pos(Edit20, M + 270, 170, W - 330, 29);

  { -----------------------------------------------------------------------
    TICKETS Y PERIFÉRICOS: tres zonas reales.
    ----------------------------------------------------------------------- }
  C1 := (W - (M * 2) - G) div 2;
  C2 := W - (M * 2) - G - C1;
  X1 := M;
  X2 := X1 + C1 + G;
  CrearTarjetaVisual(TabSheet5, X1, 16, C1, 190,
    RGBToColor(226, 238, 242), 'IMPRESORAS DE TICKETS');
  CrearTarjetaVisual(TabSheet5, X1, 222, C1, 436,
    RGBToColor(231, 243, 234), 'CABECERAS, PIES Y VISOR');
  CrearTarjetaVisual(TabSheet5, X2, 16, C2, 642,
    RGBToColor(239, 235, 247), 'SECUENCIAS Y OPCIONES DE IMPRESIÓN');

  Lbl(Label43, X1 + 22, 52, 150, 29); Pos(Edit32, X1 + 176, 52, C1 - 420, 29);
  Lbl(Label44, X1 + C1 - 226, 52, 140, 29); Pos(Edit33, X1 + C1 - 82, 52, 50, 29);
  Lbl(Label45, X1 + C1 - 226, 90, 140, 29); Pos(Edit34, X1 + C1 - 82, 90, 50, 29);
  Lbl(Label46, X1 + 22, 90, 150, 29); Pos(Edit35, X1 + 176, 90, C1 - 420, 29);
  Lbl(Label47, X1 + 22, 128, 150, 29); Pos(Edit36, X1 + 176, 128, C1 - 420, 29);
  Lbl(Label48, X1 + C1 - 226, 128, 140, 29); Pos(Edit37, X1 + C1 - 82, 128, 50, 29);
  Lbl(Label49, X1 + C1 - 226, 166, 140, 29); Pos(Edit38, X1 + C1 - 82, 166, 50, 29);
  Lbl(Label50, X1 + 22, 166, 150, 29); Pos(Edit39, X1 + 176, 166, C1 - 420, 29);

  RowY := 258;
  Lbl(Label51, X1 + 22, RowY, 150, 29); Pos(Edit40, X1 + 176, RowY, C1 - 208, 29); Inc(RowY, 38);
  Lbl(Label52, X1 + 22, RowY, 150, 29); Pos(Edit41, X1 + 176, RowY, C1 - 208, 29); Inc(RowY, 38);
  Lbl(Label53, X1 + 22, RowY, 150, 29); Pos(Edit42, X1 + 176, RowY, C1 - 208, 29); Inc(RowY, 38);
  Lbl(Label54, X1 + 22, RowY, 150, 29); Pos(Edit43, X1 + 176, RowY, C1 - 208, 29); Inc(RowY, 38);
  Lbl(Label57, X1 + 22, RowY, 150, 29); Pos(Edit44, X1 + 176, RowY, C1 - 208, 29); Inc(RowY, 38);
  Lbl(Label56, X1 + 22, RowY, 150, 29); Pos(Edit45, X1 + 176, RowY, C1 - 208, 29); Inc(RowY, 38);
  Lbl(Label55, X1 + 22, RowY, 150, 29); Pos(Edit46, X1 + 176, RowY, C1 - 208, 29); Inc(RowY, 38);
  Lbl(Label58, X1 + 22, RowY, 150, 29); Pos(Edit47, X1 + 176, RowY, C1 - 208, 29); Inc(RowY, 38);
  Lbl(Label59, X1 + 22, RowY, 150, 29); Pos(Edit48, X1 + 176, RowY, C1 - 208, 29); Inc(RowY, 38);
  Lbl(Label60, X1 + 22, RowY, 150, 29); Pos(Edit49, X1 + 176, RowY, C1 - 208, 29);

  RowY := 52;
  Lbl(Label61, X2 + 22, RowY, 210, 29); Pos(Edit50, X2 + 240, RowY, C2 - 270, 29); Inc(RowY, 40);
  Lbl(Label62, X2 + 22, RowY, 210, 29); Pos(Edit51, X2 + 240, RowY, C2 - 270, 29); Inc(RowY, 40);
  Lbl(Label63, X2 + 22, RowY, 210, 29); Pos(Edit52, X2 + 240, RowY, C2 - 270, 29); Inc(RowY, 40);
  Lbl(Label64, X2 + 22, RowY, 210, 29); Pos(Edit53, X2 + 240, RowY, C2 - 270, 29); Inc(RowY, 40);
  Lbl(Label65, X2 + 22, RowY, 210, 29); Pos(Edit54, X2 + 240, RowY, C2 - 270, 29); Inc(RowY, 40);
  Lbl(Label66, X2 + 22, RowY, 210, 29); Pos(Edit55, X2 + 240, RowY, C2 - 270, 29); Inc(RowY, 40);
  Lbl(Label67, X2 + 22, RowY, 210, 29); Pos(Edit56, X2 + 240, RowY, C2 - 270, 29); Inc(RowY, 48);
  Lbl(Label106, X2 + 22, RowY, C2 - 130, 29); Pos(ComboBox22, X2 + C2 - 100, RowY + 3, 70, 25); Inc(RowY, 40);
  Lbl(Label107, X2 + 22, RowY, C2 - 130, 29); Pos(ComboBox23, X2 + C2 - 100, RowY + 3, 70, 25); Inc(RowY, 40);
  Lbl(Label108, X2 + 22, RowY, C2 - 130, 29); Pos(ComboBox24, X2 + C2 - 100, RowY + 3, 70, 25); Inc(RowY, 40);
  Lbl(Label109, X2 + 22, RowY, C2 - 130, 29); Pos(ComboBox25, X2 + C2 - 100, RowY + 3, 70, 25); Inc(RowY, 40);
  Lbl(Label122, X2 + 22, RowY, C2 - 130, 29); Pos(ComboBox30, X2 + C2 - 100, RowY + 3, 70, 25); Inc(RowY, 40);
  Lbl(Label156, X2 + 22, RowY, 210, 29); Pos(Edit70, X2 + 240, RowY, C2 - 270, 29);

  { -----------------------------------------------------------------------
    IMPUESTOS.
    ----------------------------------------------------------------------- }
  C1 := 600;
  if W < 1450 then C1 := 540;
  C2 := W - (M * 2) - G - C1;
  X1 := M;
  X2 := X1 + C1 + G;
  CrearTarjetaVisual(TabSheet4, X1, 16, C1, 320,
    RGBToColor(226, 238, 242), 'TIPOS DE IVA Y RECARGO DE EQUIVALENCIA');
  CrearTarjetaVisual(TabSheet4, X2, 16, C2, 320,
    RGBToColor(242, 238, 226), 'COMPORTAMIENTO Y FICHEROS AFECTADOS');
  CrearTarjetaVisual(TabSheet4, M, 352, W - (M * 2), 370,
    RGBToColor(254, 242, 242), 'CAMBIO DE IVA · OPERACIÓN DELICADA');

  RowY := 62;
  Lbl(Label31, X1 + 24, RowY, 120, 29); Pos(Edit26, X1 + 150, RowY, 70, 29); Lbl(Label37, X1 + 224, RowY, 24, 29);
  Lbl(Label36, X1 + 280, RowY, 120, 29); Pos(Edit29, X1 + 406, RowY, 70, 29); Lbl(Label40, X1 + 480, RowY, 24, 29);
  Inc(RowY, 58);
  Lbl(Label32, X1 + 24, RowY, 120, 29); Pos(Edit27, X1 + 150, RowY, 70, 29); Lbl(Label38, X1 + 224, RowY, 24, 29);
  Lbl(Label35, X1 + 280, RowY, 120, 29); Pos(Edit30, X1 + 406, RowY, 70, 29); Lbl(Label41, X1 + 480, RowY, 24, 29);
  Inc(RowY, 58);
  Lbl(Label33, X1 + 24, RowY, 120, 29); Pos(Edit28, X1 + 150, RowY, 70, 29); Lbl(Label39, X1 + 224, RowY, 24, 29);
  Lbl(Label34, X1 + 280, RowY, 120, 29); Pos(Edit31, X1 + 406, RowY, 70, 29); Lbl(Label42, X1 + 480, RowY, 24, 29);
  Lbl(Label96, X1 + 24, 250, 200, 29); Pos(fechaiva, X1 + 230, 250, 190, 29);

  Pos(CambioIVA, X2 + 18, 48, C2 - 36, 92);
  Pos(ficherosiva, X2 + 18, 150, C2 - 36, 166);

  WrapLbl(Label120, M + 42, 388, W - 100, 38);
  WrapLbl(Label121, M + 42, 430, W - 100, 38);
  WrapLbl(Label146, M + 42, 476, W - 100, 32);
  WrapLbl(Label147, M + 42, 510, W - 100, 32);
  WrapLbl(Label148, M + 42, 544, W - 100, 32);
  WrapLbl(Label149, M + 42, 578, W - 100, 46);
  Pos(Button1, M + ((W - (M * 2) - 520) div 2), 620, 520, 48);
  Lbl(Label119, M + 42, 674, W - 100, 32);

  { -----------------------------------------------------------------------
    INFORMES: zonas fijas, sin anclajes heredados del LFM.
    ----------------------------------------------------------------------- }
  Avail := W - (M * 2) - G;
  C1 := (Avail * 38) div 100;
  if C1 < 500 then C1 := 500;
  if C1 > 640 then C1 := 640;
  C2 := Avail - C1;
  X1 := M;
  X2 := X1 + C1 + G;

  { Los AnchorSide del LFM tenían prioridad sobre SetBounds y desplazaban
    RadioGroup1 y gbTipoInstalacion hacia el borde izquierdo. Se eliminan
    todas las relaciones de anclaje antes de fijar la geometría definitiva. }
  RadioGroup1.Align := alNone;
  RadioGroup1.Anchors := [akTop, akLeft];
  RadioGroup1.AnchorSideLeft.Control := nil;
  RadioGroup1.AnchorSideTop.Control := nil;
  RadioGroup1.AnchorSideRight.Control := nil;
  RadioGroup1.AnchorSideBottom.Control := nil;
  RadioGroup1.BorderSpacing.Left := 0;
  RadioGroup1.BorderSpacing.Right := 0;
  RadioGroup1.BorderSpacing.Top := 0;
  RadioGroup1.BorderSpacing.Bottom := 0;

  GroupBox2.Align := alNone;
  GroupBox2.Anchors := [akTop, akLeft];
  GroupBox2.AnchorSideLeft.Control := nil;
  GroupBox2.AnchorSideTop.Control := nil;
  GroupBox2.AnchorSideRight.Control := nil;
  GroupBox2.AnchorSideBottom.Control := nil;
  GroupBox2.BorderSpacing.Left := 0;
  GroupBox2.BorderSpacing.Right := 0;
  GroupBox2.BorderSpacing.Top := 0;
  GroupBox2.BorderSpacing.Bottom := 0;

  gbTipoInstalacion.Align := alNone;
  gbTipoInstalacion.Anchors := [akTop, akLeft];
  gbTipoInstalacion.AnchorSideLeft.Control := nil;
  gbTipoInstalacion.AnchorSideTop.Control := nil;
  gbTipoInstalacion.AnchorSideRight.Control := nil;
  gbTipoInstalacion.AnchorSideBottom.Control := nil;
  gbTipoInstalacion.BorderSpacing.Left := 0;
  gbTipoInstalacion.BorderSpacing.Right := 0;
  gbTipoInstalacion.BorderSpacing.Top := 0;
  gbTipoInstalacion.BorderSpacing.Bottom := 0;

  CrearTarjetaVisual(TabSheet8, X1, 16, C1, 302,
    RGBToColor(226, 238, 242), '');
  CrearTarjetaVisual(TabSheet8, X2, 16, C2, 302,
    RGBToColor(231, 243, 234), '');
  CrearTarjetaVisual(TabSheet8, M, 334, W - (M * 2), 390,
    RGBToColor(239, 242, 244), '');

  EncabezadoTarjeta(TabSheet8, X1 + 1, 17, C1 - 2, 38,
    'IMPRESIÓN DE INFORMES', RGBToColor(23, 96, 116));
  EncabezadoTarjeta(TabSheet8, X2 + 1, 17, C2 - 2, 38,
    'DATOS QR NO VERI*FACTU', RGBToColor(22, 130, 84));
  EncabezadoTarjeta(TabSheet8, M + 1, 335, W - (M * 2) - 2, 38,
    'ENTORNO DEL SISTEMA', RGBToColor(55, 65, 81));

  Pos(CheckBox2, X1 + 24, 68, C1 - 48, 32);
  CheckBox2.ParentColor := False;
  CheckBox2.Color := RGBToColor(226, 238, 242);
  CheckBox2.ParentFont := False;
  CheckBox2.Font.Name := 'Sans';
  CheckBox2.Font.Height := -12;
  CheckBox2.Font.Style := [fsBold];
  CheckBox2.Font.Color := RGBToColor(30, 41, 59);
  CheckBox2.BringToFront;

  Pos(RadioGroup1, X1 + 24, 108, C1 - 48, 184);
  RadioGroup1.ParentColor := False;
  RadioGroup1.Color := RGBToColor(226, 238, 242);
  RadioGroup1.ParentFont := False;
  RadioGroup1.Font.Name := 'Sans';
  RadioGroup1.Font.Height := -12;
  RadioGroup1.Font.Style := [fsBold];
  RadioGroup1.BringToFront;

  Pos(GroupBox2, X2 + 18, 68, C2 - 36, 224);
  GroupBox2.Caption := '';
  GroupBox2.ParentColor := False;
  GroupBox2.Color := RGBToColor(231, 243, 234);
  EditX := 192;
  EditW := GroupBox2.ClientWidth - EditX - 20;
  if EditW < 260 then EditW := 260;
  Lbl(lbLeyendaSuperior, 20, 24, 160, 30);
  Pos(edLeyendaSuperior, EditX, 24, EditW, 30);
  Lbl(lbLeyendaInferior, 20, 82, 160, 30);
  Pos(edLeyendaInferior, EditX, 82, EditW, 30);
  Lbl(lbTxtQr, 20, 140, 160, 30);
  Pos(edTextoQR, EditX, 140, EditW, 30);
  lbLeyendaSuperior.Font.Style := [fsBold];
  lbLeyendaInferior.Font.Style := [fsBold];
  lbTxtQr.Font.Style := [fsBold];
  GroupBox2.BringToFront;

  Pos(gbTipoInstalacion, M + 24, 382, W - (M * 2) - 48, 324);
  gbTipoInstalacion.Caption := '';
  gbTipoInstalacion.ParentColor := False;
  gbTipoInstalacion.Color := RGBToColor(239, 242, 244);

  Lbl(lbSistema, 24, 16, gbTipoInstalacion.ClientWidth - 48, 64);
  lbSistema.Alignment := taCenter;
  lbSistema.Layout := tlCenter;
  Lbl(lbIni, 24, 94, gbTipoInstalacion.ClientWidth - 48, 30);
  Lbl(lbSql, 24, 132, gbTipoInstalacion.ClientWidth - 48, 30);
  Lbl(lbReport, 24, 170, gbTipoInstalacion.ClientWidth - 48, 30);
  Lbl(lbImagenes, 24, 208, gbTipoInstalacion.ClientWidth - 48, 30);
  Lbl(lbBinario, 24, 246, gbTipoInstalacion.ClientWidth - 48, 30);
  Lbl(lbModulos, 24, 284, gbTipoInstalacion.ClientWidth - 48, 30);

  lbIni.Font.Color := RGBToColor(30, 41, 59);
  lbSql.Font.Color := RGBToColor(30, 41, 59);
  lbReport.Font.Color := RGBToColor(30, 41, 59);
  lbImagenes.Font.Color := RGBToColor(30, 41, 59);
  lbBinario.Font.Color := RGBToColor(30, 41, 59);
  lbModulos.Font.Color := RGBToColor(30, 41, 59);
  gbTipoInstalacion.BringToFront;

  { -----------------------------------------------------------------------
    APLICACIONES EXTRA.
    ----------------------------------------------------------------------- }
  CrearTarjetaVisual(tsGeneral, M, 16, W - (M * 2), 250,
    RGBToColor(226, 238, 242), 'APLICACIONES, INFORMES E IMÁGENES');
  Lbl(Label69, M + 24, 56, 260, 29);
  Pos(Edit58, M + 294, 56, W - 380, 29);
  Pos(BitBtn13, W - 66, 56, 34, 29);
  Lbl(Label70, M + 24, 104, 260, 29);
  Pos(Edit59, M + 294, 104, W - 380, 29);
  Pos(BitBtn14, W - 66, 104, 34, 29);
  Lbl(Label117, M + 24, 152, 260, 29);
  Pos(Edit69, M + 294, 152, W - 380, 29);
  Pos(BitBtn15, W - 66, 152, 34, 29);
  Lbl(LabelAbrirArchivo, M + 24, 200, 260, 29);
  Pos(EditAbrirArchivo, M + 294, 200, W - 326, 29);

  LayoutBackup(gbCopia1, cbCopia1, Label125, Label126, Label127,
    Label129, Label128, Label140, Label141,
    Copia1InicioHora, Copia1InicioMinutos, Copia1FinHora,
    Copia1FinMinutos, Copia1Destino,
    Copia1InicioUD1, Copia1InicioUD2, Copia1FinUD1, Copia1FinUD2,
    18, W - 180);
  LayoutBackup(gbCopia2, cbCopia2, Label130, Label131, Label132,
    Label134, Label133, Label142, Label143,
    Copia2InicioHora, Copia2InicioMinutos, Copia2FinHora,
    Copia2FinMinutos, Copia2Destino,
    Copia2InicioUD1, Copia2InicioUD2, Copia2FinUD1, Copia2FinUD2,
    180, W - 180);
  LayoutBackup(gbCopia3, cbCopia3, Label135, Label136, Label137,
    Label139, Label138, Label144, Label145,
    Copia3InicioHora, Copia3InicioMinutos, Copia3FinHora,
    Copia3FinMinutos, Copia3Destino,
    Copia3InicioUD1, Copia3InicioUD2, Copia3FinUD1, Copia3FinUD2,
    342, W - 180);
  Pos(btnValidarCopiasAutomaticas, (W - 270) div 2, 510, 270, 48);
  RecolocarControlesBackupRemoto;

  { -----------------------------------------------------------------------
    SISTEMA DE PUNTOS: editores centrados y texto a ambos lados.
    ----------------------------------------------------------------------- }
  C1 := 700;
  if W < 1450 then C1 := 620;
  C2 := W - (M * 2) - G - C1;
  X1 := M;
  X2 := X1 + C1 + G;
  CrearTarjetaVisual(TabSheet7, X1, 16, C1, 430,
    RGBToColor(231, 243, 234), 'CONFIGURACIÓN DEL SISTEMA DE PUNTOS');
  CrearTarjetaVisual(TabSheet7, X2, 16, C2, 430,
    RGBToColor(226, 238, 242), 'NIVELES Y FUNCIONAMIENTO');

  FieldW := 104;
  FieldX := X1 + (C1 div 2) - (FieldW div 2);

  RowY := 58;
  Lbl(Label19, X1 + 24, RowY, FieldX - X1 - 40, 29);
  Pos(Edit17, FieldX, RowY, FieldW, 29);
  Inc(RowY, 48);

  Lbl(Label71, X1 + 24, RowY, FieldX - X1 - 40, 29);
  Pos(Edit60, FieldX, RowY, FieldW, 29);
  Inc(RowY, 48);

  Lbl(Label72, X1 + 24, RowY, FieldX - X1 - 40, 29);
  Pos(Edit61, FieldX, RowY, FieldW, 29);
  Lbl(Label79, FieldX + FieldW + 8, RowY, 24, 29);
  Inc(RowY, 54);

  Lbl(Label73, X1 + 24, RowY, FieldX - X1 - 40, 42);
  Pos(Edit62, FieldX, RowY + 6, FieldW, 29);
  Lbl(Label80, FieldX + FieldW + 8, RowY + 6, 24, 29);
  Lbl(Label74, FieldX + FieldW + 38, RowY + 4,
    C1 - (FieldX - X1) - FieldW - 58, 36);
  Inc(RowY, 66);

  Lbl(Label75, X1 + 24, RowY, FieldX - X1 - 40, 42);
  Pos(Edit63, FieldX, RowY + 6, FieldW, 29);
  Lbl(Label76, FieldX + FieldW + 18, RowY + 2,
    C1 - (FieldX - X1) - FieldW - 38, 40);

  WrapLbl(Label81, X2 + 24, 58, C2 - 48, 44);
  WrapLbl(Label78, X2 + 24, 114, C2 - 48, 44);
  WrapLbl(Label77, X2 + 24, 176, C2 - 48, 194);

  { -----------------------------------------------------------------------
    VERI*FACTU.
    ----------------------------------------------------------------------- }
  CrearTarjetaVisual(TabSheet11, M, 16, W - (M * 2), 286,
    RGBToColor(226, 238, 242), 'CONEXIONES DE VERI*FACTU');
  CrearTarjetaVisual(TabSheet11, M, 318, W - (M * 2), 150,
    RGBToColor(254, 242, 242), 'MODO DE FUNCIONAMIENTO');

  Lbl(Label157, M + 28, 62, 300, 29); Pos(Edit71, M + 338, 62, W - 392, 29);
  Lbl(Label158, M + 28, 124, 300, 29); Pos(Edit72, M + 338, 124, W - 392, 29);
  Lbl(Label160, M + 28, 186, 300, 29); Pos(Edit73, M + 338, 186, W - 392, 29);
  Lbl(Label159, M + 28, 360, 390, 42);
  Pos(vfCheckTest, M + 430, 366, 390, 28);
end;

procedure TFConfig.EstilizarControlesModernos;
var
  I: Integer;
  C: TComponent;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    C := Components[I];

    if C is TDateEdit then
    begin
      TDateEdit(C).ParentFont := False;
      TDateEdit(C).Font.Name := 'Sans';
      TDateEdit(C).Font.Height := -12;
      TDateEdit(C).Height := 29;
      TDateEdit(C).Color := clWhite;
    end
    else if C is TEdit then
    begin
      TEdit(C).ParentFont := False;
      TEdit(C).Font.Name := 'Sans';
      TEdit(C).Font.Height := -12;
      TEdit(C).Height := 29;
      TEdit(C).Color := clWhite;
    end
    else if C is TComboBox then
    begin
      TComboBox(C).ParentFont := False;
      TComboBox(C).Font.Name := 'Sans';
      TComboBox(C).Font.Height := -12;
      TComboBox(C).Color := clWhite;
    end
    else if C is TCheckBox then
    begin
      TCheckBox(C).ParentFont := False;
      TCheckBox(C).Font.Name := 'Sans';
      TCheckBox(C).Font.Height := -12;
      TCheckBox(C).Font.Color := RGBToColor(51, 65, 85);
      TCheckBox(C).ParentColor := False;
      TCheckBox(C).Color := clWhite;
      TCheckBox(C).BringToFront;
    end
    else if C is TCheckGroup then
    begin
      TCheckGroup(C).ParentFont := False;
      TCheckGroup(C).Font.Name := 'Sans';
      TCheckGroup(C).Font.Height := -12;
      TCheckGroup(C).Font.Color := RGBToColor(51, 65, 85);
      TCheckGroup(C).ParentColor := False;
      TCheckGroup(C).Color := RGBToColor(250, 251, 252);
    end
    else if C is TRadioGroup then
    begin
      TRadioGroup(C).ParentFont := False;
      TRadioGroup(C).Font.Name := 'Sans';
      TRadioGroup(C).Font.Height := -12;
      TRadioGroup(C).Font.Color := RGBToColor(51, 65, 85);
      TRadioGroup(C).ParentColor := False;
      TRadioGroup(C).Color := RGBToColor(250, 251, 252);
    end
    else if C is TGroupBox then
    begin
      TGroupBox(C).ParentFont := False;
      TGroupBox(C).Font.Name := 'Sans';
      TGroupBox(C).Font.Height := -12;
      TGroupBox(C).Font.Style := [fsBold];
      TGroupBox(C).Font.Color := RGBToColor(18, 76, 91);
      TGroupBox(C).ParentColor := False;
      TGroupBox(C).Color := RGBToColor(248, 250, 251);
    end
    else if C is TStaticText then
    begin
      TStaticText(C).ParentFont := False;
      TStaticText(C).Font.Name := 'Sans';
      TStaticText(C).Font.Height := -12;
      TStaticText(C).Font.Color := RGBToColor(51, 65, 85);
      TStaticText(C).Color := RGBToColor(248, 250, 251);
    end
    else if C is TLabel then
    begin
      TLabel(C).ParentFont := False;
      TLabel(C).Font.Name := 'Sans';
      if TLabel(C).Font.Height > -12 then
        TLabel(C).Font.Height := -12;
      TLabel(C).Font.Color := RGBToColor(51, 65, 85);
    end;
  end;
end;

procedure TFConfig.RecolocarDisenoModerno;
var
  X, Gap: Integer;
begin
  if not Assigned(Panel1) then Exit;

  Gap := 10;
  X := Panel1.ClientWidth - 18 - BitBtn3.Width;
  BitBtn3.Left := X;
  BitBtn3.Top := 17;
  Dec(X, Gap + BitBtn6.Width);
  BitBtn6.Left := X;
  BitBtn6.Top := 17;
  Dec(X, Gap + BitBtn2.Width);
  BitBtn2.Left := X;
  BitBtn2.Top := 17;
  Dec(X, Gap + BitBtn1.Width);
  BitBtn1.Left := X;
  BitBtn1.Top := 17;

  if Assigned(FHeaderTitle) then
    FHeaderTitle.Width := X - FHeaderTitle.Left - 20;
  if Assigned(FHeaderSubtitle) then
    FHeaderSubtitle.Width := X - FHeaderSubtitle.Left - 20;
end;

procedure TFConfig.FormResizeModerno(Sender: TObject);
begin
  RecolocarDisenoModerno;
  if FDisenoFinalAplicado then
  begin
    LimpiarTarjetasModernas;
    CrearTarjetasModernas;
    SincronizarPosicionControlesVisuales;
    SincronizarChecksVisuales;
    ActualizarBotonesConexionVisual;
  end;
end;

procedure TFConfig.AplicarEstiloModerno;
begin
  Caption := 'FacturLinEx · Configuración general del sistema';
  Color := RGBToColor(241, 245, 247);
  ParentFont := False;
  Font.Name := 'Sans';
  Font.Height := -12;
  Constraints.MinWidth := 1180;
  Constraints.MinHeight := 720;
  WindowState := wsMaximized;

  Panel1.Align := alTop;
  Panel1.Height := 88;
  Panel1.Caption := '';
  Panel1.BevelOuter := bvNone;
  Panel1.BevelInner := bvNone;
  Panel1.ParentColor := False;
  Panel1.Color := RGBToColor(18, 76, 91);

  FHeaderTitle := TLabel.Create(Self);
  FHeaderTitle.Parent := Panel1;
  FHeaderTitle.SetBounds(22, 12, 720, 28);
  FHeaderTitle.AutoSize := False;
  FHeaderTitle.Caption := 'CONFIGURACIÓN GENERAL DE FACTURLINEX';
  FHeaderTitle.Transparent := True;
  FHeaderTitle.ParentFont := False;
  FHeaderTitle.Font.Name := 'Sans';
  FHeaderTitle.Font.Height := -20;
  FHeaderTitle.Font.Style := [fsBold];
  FHeaderTitle.Font.Color := clWhite;

  FHeaderSubtitle := TLabel.Create(Self);
  FHeaderSubtitle.Parent := Panel1;
  FHeaderSubtitle.SetBounds(24, 47, 900, 20);
  FHeaderSubtitle.AutoSize := False;
  FHeaderSubtitle.Caption :=
    'Empresa, BBDD, ventas, impresión, impuestos, copias, puntos y Veri*Factu';
  FHeaderSubtitle.Transparent := True;
  FHeaderSubtitle.ParentFont := False;
  FHeaderSubtitle.Font.Name := 'Sans';
  FHeaderSubtitle.Font.Height := -11;
  FHeaderSubtitle.Font.Style := [fsBold];
  FHeaderSubtitle.Font.Color := clWhite;

  PrepararBotonPrincipal(BitBtn1, RGBToColor(22, 130, 84), True);
  PrepararBotonPrincipal(BitBtn2, RGBToColor(219, 234, 239), False);
  PrepararBotonPrincipal(BitBtn6, RGBToColor(23, 96, 116), True);
  PrepararBotonPrincipal(BitBtn3, RGBToColor(55, 65, 81), True);
  BitBtn1.Caption := 'Guardar';
  BitBtn2.Caption := 'Recuperar';
  BitBtn6.Caption := 'Aplicar';
  BitBtn3.Caption := 'Cerrar';

  PageControl1.Align := alClient;
  PageControl1.ParentFont := False;
  PageControl1.Font.Name := 'Sans';
  PageControl1.Font.Height := -12;
  PageControl1.Font.Style := [fsBold];
  PageControl1.Color := RGBToColor(241, 245, 247);

  TabSheet1.Caption := 'Registro';
  TabSheet10.Caption := 'Configuración general 1';
  TabSheet9.Caption := 'Configuración general 2';
  TabSheet2.Caption := 'Conexiones';
  TabSheet3.Caption := 'Actualizaciones';
  TabSheet5.Caption := 'Tickets y periféricos';
  TabSheet4.Caption := 'Impuestos';
  TabSheet8.Caption := 'Informes';
  TabSheet6.Caption := 'Aplicaciones extra';
  TabSheet7.Caption := 'Sistema de puntos';
  TabSheet11.Caption := 'VeriFactu';
  tsGeneral.Caption := 'General';
  tsCopiasAutomaticas.Caption := 'Copias automáticas';
  if Assigned(FRemoteBackupTab) then
    FRemoteBackupTab.Caption := 'Copias remotas';

  TabSheet1.Color := RGBToColor(241, 245, 247);
  TabSheet10.Color := RGBToColor(241, 245, 247);
  TabSheet9.Color := RGBToColor(241, 245, 247);
  TabSheet2.Color := RGBToColor(241, 245, 247);
  TabSheet3.Color := RGBToColor(241, 245, 247);
  TabSheet5.Color := RGBToColor(241, 245, 247);
  TabSheet4.Color := RGBToColor(241, 245, 247);
  TabSheet8.Color := RGBToColor(241, 245, 247);
  TabSheet6.Color := RGBToColor(241, 245, 247);
  TabSheet7.Color := RGBToColor(241, 245, 247);
  TabSheet11.Color := RGBToColor(241, 245, 247);
  tsGeneral.Color := RGBToColor(241, 245, 247);
  tsCopiasAutomaticas.Color := RGBToColor(241, 245, 247);
  if Assigned(FRemoteBackupTab) then
    FRemoteBackupTab.Color := RGBToColor(241, 245, 247);
  pcAplicacionesExtra.ParentFont := False;
  pcAplicacionesExtra.Font.Name := 'Sans';
  pcAplicacionesExtra.Font.Height := -12;
  pcAplicacionesExtra.Font.Style := [fsBold];

  EstilizarControlesModernos;
  CrearTarjetasModernas;

  { Paneles y grupos existentes. }
  PanelCambiable1.BevelOuter := bvNone;
  PanelCambiable1.ParentColor := False;
  PanelCambiable1.Color := RGBToColor(231, 243, 234);
  PanelCambiable2.BevelOuter := bvNone;
  PanelCambiable2.ParentColor := False;
  PanelCambiable2.Color := RGBToColor(231, 243, 234);
  GroupBox1.Color := RGBToColor(226, 238, 242);
  GroupBox1.Caption := '';
  GroupBox2.Color := RGBToColor(226, 238, 242);
  GroupBox2.Caption := '';
  gbTipoInstalacion.Color := RGBToColor(239, 242, 244);
  gbTipoInstalacion.Caption := '';
  gbCopia1.Color := RGBToColor(226, 238, 242);
  gbCopia2.Color := RGBToColor(231, 243, 234);
  gbCopia3.Color := RGBToColor(242, 238, 226);

  { Botones pequeños: solución sólida validada en Clientes. }
  CrearBotonVisual(BitBtn12, FBtnLogoVisual,
    'Seleccionar el logotipo de la empresa');
  CrearBotonVisual(BitBtn7, FBtnColorFormularioVisual,
    'Seleccionar el color del formulario');
  CrearBotonVisual(BitBtn8, FBtnColorBotonesVisual,
    'Seleccionar el color de los botones');
  CrearBotonVisual(BitBtnCambiable1, FBtnTiendaVisual,
    'Seleccionar la tienda activa');
  CrearBotonVisual(BitBtnCambiable2, FBtnPuestoVisual,
    'Seleccionar el puesto');
  CrearBotonVisual(BitBtn13, FBtnVisorPDFVisual,
    'Seleccionar la aplicación para abrir PDF');
  CrearBotonVisual(BitBtn14, FBtnRutaPDFVisual,
    'Seleccionar la carpeta de informes PDF');
  CrearBotonVisual(BitBtn15, FBtnRutaImagenesVisual,
    'Seleccionar la carpeta de imágenes de artículos');

  { Botones de prueba de conexión: controles sólidos, visibles y con relieve. }
  CrearBotonAccionVisual(BitBtn4, FBtnTestBBDDVisual,
    'Test de conexión', 'Comprobar la conexión con la base de datos principal',
    RGBToColor(23, 96, 116));
  CrearBotonAccionVisual(BitBtn5, FBtnTestSICVisual,
    'Test de conexión', 'Comprobar la conexión con el sistema de información común',
    RGBToColor(23, 96, 116));
  ActualizarBotonesConexionVisual;

  { Checkboxes críticos: representación sólida independiente del tema GTK. }
  CrearCheckVisual(bbdd_autocopy, FCheckMonoVisual,
    'SISTEMA MONO-USUARIO (SE ACTIVAN LAS COPIAS DE SEGURIDAD AUTOMÁTICAS AL CERRAR EL PROGRAMA)',
    'Activar o desactivar el modo monousuario y sus copias automáticas',
    RGBToColor(239, 242, 244), RGBToColor(153, 27, 27));
  CrearEtiquetaVisual(Label29, FLabelSICVisual,
    'Servidor SIC (Sistema de Información Común)',
    RGBToColor(239, 235, 247), RGBToColor(18, 76, 91));
  CrearCheckVisual(CheckBox1, FCheckSICVisual,
    'Activar sistema de información común',
    'Activar o desactivar la conexión con el sistema de información común',
    RGBToColor(239, 235, 247), RGBToColor(18, 76, 91));
  CrearEtiquetaVisual(Label159, FLabelVFVisual,
    'CheckBox ON = Pruebas / OFF = Producción',
    RGBToColor(254, 242, 242), RGBToColor(153, 27, 27));
  CrearCheckVisual(vfCheckTest, FCheckVFVisual,
    'ON = PRUEBAS   //   OFF = PRODUCCIÓN',
    'Seleccionar el modo de funcionamiento de VeriFactu',
    RGBToColor(254, 242, 242), RGBToColor(153, 27, 27));
  SincronizarChecksVisuales;

  btnValidarCopiasAutomaticas.ParentFont := False;
  btnValidarCopiasAutomaticas.Font.Name := 'Sans';
  btnValidarCopiasAutomaticas.Font.Height := -12;
  btnValidarCopiasAutomaticas.Font.Style := [fsBold];
  btnValidarCopiasAutomaticas.Color := RGBToColor(22, 130, 84);
  btnValidarCopiasAutomaticas.Font.Color := clWhite;
  btnValidarCopiasAutomaticas.Width := 250;
  btnValidarCopiasAutomaticas.Height := 48;

  Button1.ParentFont := False;
  Button1.Font.Name := 'Sans';
  Button1.Font.Height := -13;
  Button1.Font.Style := [fsBold];
  Button1.Font.Color := clWhite;
  Button1.Color := RGBToColor(185, 28, 28);
  Button1.Caption := 'EJECUTAR CAMBIO DE IVA';

  { Textos visibles corregidos sin cambiar identificadores ni datos. }
  Label3.Caption := 'Dirección';
  Label4.Caption := 'Cód. postal';
  Label5.Caption := 'Población';
  Label8.Caption := 'Teléfono';
  Label115.Caption := 'Color del formulario';
  Label116.Caption := 'Color de los botones';
  CheckBox1.Caption := 'Activar sistema de información común';
  Label29.Caption := 'Servidor SIC (Sistema de Información Común)';
  Label20.Caption := 'Servidor de actualizaciones';
  Label44.Caption := 'Líneas al final del ticket';
  Label48.Caption := 'Líneas al final del ticket 1';
  Label61.Caption := 'Secuencia para abrir cajón';
  Label63.Caption := 'Secuencia de anulación';
  Label156.Caption := 'Secuencia de impresión del logotipo';
  Label69.Caption := 'Aplicación para visualizar informes PDF';
  Label70.Caption := 'Carpeta para guardar informes PDF';
  Label117.Caption := 'Carpeta para imágenes de artículos';
  LabelAbrirArchivo.Caption := 'Orden para abrir archivos';
  lbReport.Caption := StringReplace(lbReport.Caption, 'Pantillas',
    'Plantillas', [rfReplaceAll]);

  Image1.Proportional := True;
  Image1.Stretch := True;
  Image1.Center := True;

  { Advertencias y estados recuperan colores semánticos. }
  Label119.Font.Color := RGBToColor(153, 27, 27);
  Label119.Font.Style := [fsBold];
  Label146.Font.Color := RGBToColor(153, 27, 27);
  Label146.Font.Style := [fsBold];
  Label147.Font.Color := RGBToColor(153, 27, 27);
  Label148.Font.Color := RGBToColor(153, 27, 27);
  Label149.Font.Color := RGBToColor(153, 27, 27);

  { Controles críticos: color explícito para evitar texto invisible en GTK. }
  bbdd_autocopy.ParentColor := False;
  bbdd_autocopy.Color := RGBToColor(239, 242, 244);
  bbdd_autocopy.ParentFont := False;
  bbdd_autocopy.Font.Name := 'Sans';
  bbdd_autocopy.Font.Height := -13;
  bbdd_autocopy.Font.Style := [fsBold];
  bbdd_autocopy.Font.Color := RGBToColor(153, 27, 27);
  bbdd_autocopy.BringToFront;

  CheckBox1.ParentColor := False;
  CheckBox1.Color := RGBToColor(239, 235, 247);
  CheckBox1.ParentFont := False;
  CheckBox1.Font.Name := 'Sans';
  CheckBox1.Font.Height := -13;
  CheckBox1.Font.Style := [fsBold];
  CheckBox1.Font.Color := RGBToColor(18, 76, 91);
  CheckBox1.BringToFront;
  Label29.Transparent := False;
  Label29.ParentColor := False;
  Label29.Color := RGBToColor(239, 235, 247);
  Label29.Font.Color := RGBToColor(18, 76, 91);
  Label29.Font.Style := [fsBold];
  Label29.BringToFront;

  Label159.Transparent := False;
  Label159.ParentColor := False;
  Label159.Color := RGBToColor(254, 242, 242);
  Label159.Font.Color := RGBToColor(153, 27, 27);
  Label159.Font.Style := [fsBold];
  Label159.BringToFront;
  vfCheckTest.ParentColor := False;
  vfCheckTest.Color := RGBToColor(254, 242, 242);
  vfCheckTest.ParentFont := False;
  vfCheckTest.Font.Name := 'Sans';
  vfCheckTest.Font.Height := -13;
  vfCheckTest.Font.Style := [fsBold];
  vfCheckTest.Font.Color := RGBToColor(153, 27, 27);
  vfCheckTest.BringToFront;

  { Estado del entorno: indicador grande, centrado y semántico. }
  lbSistema.Transparent := False;
  lbSistema.ParentColor := False;
  lbSistema.ParentFont := False;
  lbSistema.Font.Name := 'Sans';
  lbSistema.Font.Height := -24;
  lbSistema.Font.Style := [fsBold];
  lbSistema.Alignment := taCenter;
  lbSistema.Layout := tlCenter;
  if RutaBin = '/usr/bin/' then
  begin
    lbSistema.Color := RGBToColor(220, 252, 231);
    lbSistema.Font.Color := RGBToColor(21, 128, 61);
    lbSistema.Caption := 'Sistema en producción';
  end
  else
  begin
    lbSistema.Color := RGBToColor(254, 226, 226);
    lbSistema.Font.Color := RGBToColor(153, 27, 27);
    lbSistema.Caption := 'Sistema en desarrollo';
  end;
  lbSistema.BringToFront;

  FHeaderTitle.Font.Color := clWhite;
  FHeaderSubtitle.Font.Color := clWhite;
  FHeaderTitle.BringToFront;
  FHeaderSubtitle.BringToFront;

  FDisenoFinalAplicado := False;
  OnShow := @FormShowModerno;
  OnResize := @FormResizeModerno;
  RecolocarDisenoModerno;
  SincronizarPosicionControlesVisuales;
  SincronizarChecksVisuales;
end;

//--------------- Controles runtime para codigo de cliente desde NIF -----------
procedure TFConfig.CrearControlesClientesCodigo;
var
  AParent: TWinControl;
  LLeft, CLeft, LWidth, CWidth, Top1: Integer;
begin
  if Assigned(cbClientesBuscarNIFCodigo) then Exit;

  AParent := edCliVario.Parent;
  LLeft := lbCliVario.Left;
  CLeft := edCliVario.Left;
  LWidth := lbCliVario.Width;
  CWidth := 220;
  Top1 := CgSCajon.Top + 42;

  lbClientesBuscarNIFCodigo := TLabel.Create(Self);
  lbClientesBuscarNIFCodigo.Parent := AParent;
  lbClientesBuscarNIFCodigo.SetBounds(LLeft, Top1, LWidth, lbCliVario.Height);
  lbClientesBuscarNIFCodigo.AutoSize := False;
  lbClientesBuscarNIFCodigo.Layout := tlCenter;
  lbClientesBuscarNIFCodigo.Caption := 'Buscar NIF/CIF desde codigo cliente';

  cbClientesBuscarNIFCodigo := TComboBox.Create(Self);
  cbClientesBuscarNIFCodigo.Parent := AParent;
  cbClientesBuscarNIFCodigo.SetBounds(CLeft, Top1-3, 56, ComboBox1.Height);
  cbClientesBuscarNIFCodigo.Style := csDropDownList;
  cbClientesBuscarNIFCodigo.Items.Add('S');
  cbClientesBuscarNIFCodigo.Items.Add('N');

  lbClientesModoCodigoAltaNIF := TLabel.Create(Self);
  lbClientesModoCodigoAltaNIF.Parent := AParent;
  lbClientesModoCodigoAltaNIF.SetBounds(LLeft, Top1 + 40, LWidth, lbCliVario.Height);
  lbClientesModoCodigoAltaNIF.AutoSize := False;
  lbClientesModoCodigoAltaNIF.Layout := tlCenter;
  lbClientesModoCodigoAltaNIF.Caption := 'Codigo al crear cliente desde NIF';

  cbClientesModoCodigoAltaNIF := TComboBox.Create(Self);
  cbClientesModoCodigoAltaNIF.Parent := AParent;
  cbClientesModoCodigoAltaNIF.SetBounds(CLeft, Top1 + 37, CWidth, ComboBox1.Height);
  cbClientesModoCodigoAltaNIF.Style := csDropDownList;
  cbClientesModoCodigoAltaNIF.Items.Add('SIGUIENTE_NORMAL');
  cbClientesModoCodigoAltaNIF.Items.Add('NIF_SIN_LETRA');
  cbClientesModoCodigoAltaNIF.Items.Add('SIGUIENTE_SUPERIOR');

  lbClientesCodigoSuperiorDesde := TLabel.Create(Self);
  lbClientesCodigoSuperiorDesde.Parent := AParent;
  lbClientesCodigoSuperiorDesde.SetBounds(LLeft, Top1 + 80, LWidth, lbCliVario.Height);
  lbClientesCodigoSuperiorDesde.AutoSize := False;
  lbClientesCodigoSuperiorDesde.Layout := tlCenter;
  lbClientesCodigoSuperiorDesde.Caption := 'Siguiente superior a';

  edClientesCodigoSuperiorDesde := TEdit.Create(Self);
  edClientesCodigoSuperiorDesde.Parent := AParent;
  edClientesCodigoSuperiorDesde.SetBounds(CLeft, Top1 + 77, edCliVario.Width, edCliVario.Height);
  edClientesCodigoSuperiorDesde.Alignment := taCenter;
  edClientesCodigoSuperiorDesde.Text := '999999';
  edClientesCodigoSuperiorDesde.OnKeyPress := @Edit64KeyPress;
end;

procedure TFConfig.ClientesCodigoConfigChange(Sender: TObject);
begin
  if BitBtn1.Enabled=True then Exit;
  BitBtn1.Enabled := True;
  BitBtn2.Enabled := True;
end;

//--------------- Valores por defecto VeriFactu ----------------
procedure TFConfig.AplicarDefaultsVeriFactuEnBlanco;
begin
  if Trim(Edit71.Text)='' then
    Edit71.Text := VF_DEFAULT_URL_QR;

  if Trim(Edit72.Text)='' then
    Edit72.Text := VF_DEFAULT_URL_SOAP;

  if Trim(Edit73.Text)='' then
    Edit73.Text := VF_DEFAULT_URL_LOCAL;

  if Trim(vfMode)='' then
    vfMode := VF_DEFAULT_MODE;
end;

//---------------CARGA DE VALORES EN LAS VARIABLES
//Recoge los valores introducidos en la página y se cargan las variables Globales
procedure TFConfig.CargaValoresEnGlobales();
var
  contador: integer;
begin
    AplicarDefaultsVeriFactuEnBlanco;

    //---------- Sección Empresa ---------
    Empresa:=Edit1.Text;
    Representante:=Edit2.Text;
    Direccion:=Edit3.Text;
    Localidad:=Edit4.Text;
    CP:=Edit5.Text;
    Provincia:=Edit6.Text;
    Nif:=Edit7.Text;
    Telefono:=Edit8.Text;
    Fax:=Edit9.Text;
    EMail:=Edit10.Text;
    LogoEmpresa:=Edit57.Text;
    Registro:=Edit16.Text;
    ColorFondo:=Edit67.Text;
    ColorBotones:=Edit68.Text;
    if Assigned(FContrasteVisual) then
      ContrasteInterfaz := FLXTemaVisualATexto(TemaContrasteSeleccionado)
    else
      ContrasteInterfaz := 'NORMAL';
    //----------- Seccion BBDD -----------
    DBHost:=Edit11.Text;
    DBUsuario:=Edit12.Text;
    DBPasswd:=Edit13.Text;
    DBDatabase:=Edit14.Text;
    DBPuerto:=Edit15.Text;
    DBProtocolo:=Combo1.Text;
    //----------- Seccion Tienda Activa
    Tienda:=FormatFloat('0000',StrToFloat(EditCambiableCodigo1.Text));
    Puesto:=EditCambiableCodigo2.Text;
    //----------- Seccion SicLinEx -----------
    if CheckBox1.Checked=true then
      ActivarSIC:='S'
    else
      ActivarSIC:='N';
    SIChost:=Edit21.Text;
    SICusuario:=Edit22.Text;
    SICpasswd:=Edit23.Text;
    SICdatabase:=Edit24.Text;
    SICpuerto:=Edit25.Text;
    SICprotocolo:=Combo2.Text;
    //-------------- IVAS -------------------
    IVA1:=StrToFloat(Edit26.Text);
    IVA2:=StrToFloat(Edit27.Text);
    IVA3:=StrToFloat(Edit28.Text);
    RIVA1:=StrToFloat(Edit29.Text);
    RIVA2:=StrToFloat(Edit30.Text);
    RIVA3:=StrToFloat(Edit31.Text);
    //----------- Seccion tickets
    DevTicket:=Edit32.Text;
    LiFinTick:=Edit33.Text;
    CopiaTicket:=Edit34.Text;
    CmdTicket:=Edit35.Text;
    DevTicket1:=Edit36.Text;
    LiFinTick1:=Edit37.Text;
    CopiaTicket1:=Edit38.Text;
    CmdTicket1:=Edit39.Text;
    LCTI1:=Edit40.Text;
    LCTI2:=Edit41.Text;
    LCTI3:=Edit42.Text;
    LCTI4:=Edit43.Text;
    LPTI1:=Edit44.Text;
    LPTI2:=Edit45.Text;
    LPTI3:=Edit46.Text;
    DevVisor:=Edit47.Text;
    LVIS1:=Edit48.Text;
    LVIS2:=Edit49.Text;
    CgoCajon:=Edit50.Text;
    CgoCorte:=Edit51.Text;
    SecNil:=Edit52.Text;
    Negro:=Edit53.Text;
    Rojo:=Edit54.Text;
    NegroD:=Edit55.Text;
    RojoD:=Edit56.Text;
    DevLogo:=Edit70.Text;

    HoraEnTicket:=ComboBox22.Text;
    SacaVende:=ComboBox23.Text;
    DesgloIva:=ComboBox24.Text;
    SacaIva:=ComboBox25.Text;
    CgoEnTicket:=ComboBox30.Text;
    TicketRegalo:=ComboBox16.Text;

    //----------- Seccion informes
    DatosEmpresa:='N';
    ImprePrevisu:='N';
    ImpreDirecto:='N';
    ImprePdf:='N';
    if CheckBox2.Checked=true then DatosEmpresa:='S';
    if RadioGroup1.ItemIndex = 0 then ImprePrevisu:='S';
    if RadioGroup1.ItemIndex = 1 then ImpreDirecto:='S';
    if RadioGroup1.ItemIndex = 2 then ImprePdf:='S';

    LeyendaSuperiorQR:= EdLeyendaSuperior.Text;
    LeyendaInferiorQR:= EdLeyendaInferior.Text;
    TextoCodigoQR:= EdTextoQR.Text;

    //------------------------
      {  LA MAYORÍA DE LOS DATOS DE LA SECCIÓN PROGRAMA ESTÁN IMPLEMENTADOS EN LA SECCIÓN CONFIGURACIÓN GENERAL
         CON NUEVAS VARIABLES, REVISAR Y DECIDIR QUE Y COMO UTILIZARLAS

          (* Sección para Internet *)
          Internet:='direccion:=EditW3.Text;
          Internet:='usuario:=EditW3User.Text;
          Internet:='password:=EditW3Paswd.Text;
          Internet:='Version:=EditVersion.Text;

          (* Sección para los datos del programa *)
          Programa:='FechaHora:=EditD2.Text;
          Programa:='Contabilidad:=EditD3.Text;
          Programa:='Papelera:=EditD4.Text;
          Programa:='TraspaAuto:=EditD5.Text;
          Programa:='HostConta:=EditD6.Text;
          Programa:='TarjeCliVar:=EditD7.Text;
          Programa:='TipoTicket:=EditD8.Text;
          Programa:='VisuTicket:=EditD9.Text;
          Programa:='DtoEuros:=EditD10.Text;
          Programa:='UsuarioCo:=EditD11.Text;
          Programa:='ClaveCo:=EditD12.Text;
          Programa:='PuertoCo:=EditCPuerto.Text;
          Programa:='ProtocoloCo:=Combo2.Text;
          Programa:='PasaClieCo:=EditCClie.Text;
          Programa:='CtaIVAE1:=EditIVAE1.Text;
          Programa:='CtaIVAE2:=EditIVAE2.Text;
          Programa:='CtaIVAE3:=EditIVAE3.Text;
          Programa:='CtaIVAR1:=EditIVAR1.Text;
          Programa:='CtaIVAR2:=EditIVAR2.Text;
          Programa:='CtaIVAR3:=EditIVAR3.Text;
          Programa:='CtaIVARE1:=EditIVARE1.Text;
          Programa:='CtaIVARE2:=EditIVARE2.Text;
          Programa:='CtaIVARE3:=EditIVARE3.Text;
          Programa:='ClaveCajon:=EditCajon.Text;
          Programa:='SacaVende:=EditVende.Text;
          Programa:='SacaIva:=EditIVA.Text;
          Programa:='DesgloIva:=EditIvaDes.Text;
          Programa:='LetrasFin:=EditLetras.Text;
          Programa:='Moneda:=EditMoneda.Text;
          Programa:='VerAlbaran:=EditObser.Text;
          Programa:='ImpriAlba:=EditImpAlba.Text;
          Programa:='VerFactura:=EditPreFact.Text;
          Programa:='ImpriFact:=EditImpFact.Text;
          Programa:='ControStock:=EditControStock.Text;
          Programa:='CodiPeso:=EditCodiPeso.Text;
          Programa:='PreciIva:=EditIVAP.Text;
          Programa:='CrediAlba:=EditPAlba.Text;
          Programa:='CrediFactu:=EditPFact.Text;
          Programa:='BeneCaja:=EditBene.Text;
          Programa:='AgruEnva:=EditAgru.Text;
          Programa:='UtiEnva:=EditUtiEnva.Text;
          Programa:='UtiLote:=EditUtiLote.Text;
          Programa:='TicketRega:=EditTicketRega.Text;
          Programa:='BorraAlba:=EditBoAl.Text;
          Programa:='MarcaVentas:=EditMarVen.Text;
          Programa:='Horario:=EditHora.Text;

          (* Sección para Recibos CSB19 *)
          CSB19:='HostReci:=EditCSB1.Text;
          CSB19:='UsuReci:=EditCSB2.Text;
          CSB19:='ClaveReci:=EditCSB3.Text;
          CSB19:='ProtocoloReci:=ComboCSB.Text;
          CSB19:='BBDDReci:=EditCSB4.Text;
          CSB19:='PuertoReci:=EditCSB5.Text;
          CSB19:='PapeReci:=EditCSB6.Text;
          CSB19:='PasaFaReci:=EditCSB7.Text;
          CSB19:='UsaCliReci:=EditCSB8.Text;

          (* Sección para los modulos del programa *)
          Programa:='Modulo1:=EditMod1.Text;
          Programa:='CompraCierre:=EditMod2.Text;
          Programa:='Tarifas:=EditMod3.Text;
          Programa:='Teclado:=EditMod4.Text;

  }
          //-------------- Aplicaciones Extras -------------------
          VisorPdf:=Edit58.Text;
          RutaPdf:=Edit59.Text;
          RutaImagenes:=Edit69.Text;
          AbrirAchivo:=EditAbrirArchivo.Text;

    //---------- Sección Puntos ---------
    APuntos:=Edit17.Text;
    AProductos:=Edit60.Text;
    Porcentaje:=Edit61.Text;
    Extra:=Edit62.Text;
    Especial:=Edit63.Text;

    //----------------------------------- Configuración General --------------
    CgCodBal:=Edit66.Text;
    CgClaves:=ComboBox29.Text;
    CgTarVar:=ComboBox1.Text;
    CgPvp:=ComboBox2.Text;
    CgBenCaj:=ComboBox3.Text;
    CgForzAl:=ComboBox4.Text;
    CgPFaCr:=ComboBox5.Text;
    CgBorrAlFac:=ComboBox6.Text;
    CgMOferta:=ComboBox7.Text;
    CgCHora:=ComboBox8.Text;
    CgActLote:=ComboBox9.Text;
    CgActEnvase:=ComboBox10.Text;
    CgAgruEnvase:=ComboBox11.Text;
    CgPrDto:=ComboBox13.Text;
    CgVPr:=ComboBox14.Text;
    CgPrTicket:=ComboBox15.Text;
    CgPrRegal:=ComboBox16.Text;
    CgPrAlbV:=ComboBox17.Text;
    CgPrAlb:=ComboBox18.Text;
    CgPrFraV:=ComboBox19.Text;
    CgPrFra:=ComboBox20.Text;
    CgFraLetra:=ComboBox21.Text;

    RoturaStock:=cbRupturaStock.Text;

    txtMoneda:= edMoneda.Text;
    if txtMoneda='' then txtMoneda:='Euros';

    ClienteVario:= edCliVario.Text;
    if ClienteVario='' then ClienteVario:='999999';

    ClientesBuscarNIFDesdeCodigo := 'S';
    if Assigned(cbClientesBuscarNIFCodigo) and (Trim(cbClientesBuscarNIFCodigo.Text)<>'') then
      ClientesBuscarNIFDesdeCodigo := UpperCase(Trim(cbClientesBuscarNIFCodigo.Text));

    ClientesModoCodigoAltaNIF := 'SIGUIENTE_NORMAL';
    if Assigned(cbClientesModoCodigoAltaNIF) and (Trim(cbClientesModoCodigoAltaNIF.Text)<>'') then
      ClientesModoCodigoAltaNIF := UpperCase(Trim(cbClientesModoCodigoAltaNIF.Text));

    ClientesCodigoSuperiorDesde := 999999;
    if Assigned(edClientesCodigoSuperiorDesde) then
      ClientesCodigoSuperiorDesde := StrToIntDef(Trim(edClientesCodigoSuperiorDesde.Text),999999);

    CgSegCajon:=CgSCajon.Text;

    PedirSiempreUsuario:=ComboBox31.Text;

    TiempoAvisoCliente:=0;        // Asignamos el tiempo de visualización
    if ComboBox26.Text = '5' then TiempoAvisoCliente:=5;
    if ComboBox26.Text = '30' then TiempoAvisoCliente:=30;
    if ComboBox26.Text = '60' then TiempoAvisoCliente:=60;

    AvisoLlamadas:=ComboBox27.Text;
    if Edit64.Text<>'' then DiasLlamadas:=StrToInt(Edit64.Text) else DiasLlamadas:=0;
    AvisoPedidos:=ComboBox28.Text;
    if Edit64.Text<>'' then DiasPedidos:=StrToInt(Edit65.Text) else DiasPedidos:=0;

    MascaraDecimales:='0.###';
    if cbPrecision.ItemIndex=0 then MascaraDecimales:='0.###';
    if cbPrecision.ItemIndex=1 then MascaraDecimales:='0.####';
    if cbPrecision.ItemIndex=2 then MascaraDecimales:='0.########';


    //------------Correo electrónico -------
    CorreoCopia:= edCuentaCopia.Text;
    CorreoEmisor:= edCuenta.Text;
    CorreoCabecera:= edCabecera.Text;
    CorreoMensaje1:= edMensaje1.Text;
    CorreoMensaje2:= edMensaje2.Text;
    CorreoMensaje3:= edMensaje3.Text;
    CorreoMensaje4:= edMensaje4.Text;
    CorreoUsuario:= edUsuario.Text;
    CorreoHost:= edHost.Text;
    CorreoPuerto:= edPuerto.Text;
    CorreoTLS:= cbTLS.Checked;
    CorreoSSL:= cbSSL.Checked;
    CorreoClave:= edClave.Text;

    //-------------- VeriFactu ---------------
    vfUrl:= Edit71.Text;
    vfUrlTP:= Edit72.Text;
    vfUrlTLocal:= Edit73.Text;
    If vfCheckTest.Checked then vfMode:='PRUEBAS' else vfMode:='PRODUCCION';
//    if vfMode:='PRUEBAS' then vfCheckTest.Checked:= True else vfCheckTest.Checked:= FALSE;
    MotorDB := CBMbbdd.Text;
  FLXAplicarTemaEnFormulariosAbiertos;


end;

//---------------CARGA DE VALORES EN EL INIREADER
//Recoge los valores introducidos en la página y se cargan en el IniReader
procedure TFConfig.CargaValoresEnIniReader(IniReader : TIniFile);
begin
    //---------- Sección Empresa ---------
    IniReader.WriteString('datos','nombre',Edit1.Text);
    IniReader.WriteString('datos','representante',Edit2.Text);
    IniReader.WriteString('datos','direccion',Edit3.Text);
    IniReader.WriteString('datos','poblacion',Edit4.Text);
    IniReader.WriteString('datos','cp',Edit5.Text);
    IniReader.WriteString('datos','provincia',Edit6.Text);
    IniReader.WriteString('datos','CIF',Edit7.Text);
    IniReader.WriteString('datos','telefono',Edit8.Text);
    IniReader.WriteString('datos','fax',Edit9.Text);
    IniReader.WriteString('datos','mail',Edit10.Text);
    IniReader.WriteString('datos','logo',Edit57.Text);
    IniReader.WriteString('datos','registro',Edit16.Text);
    IniReader.WriteString('datos','ColorFondo',Edit67.Text);
    IniReader.WriteString('datos','ColorBotones',Edit68.Text);
    if Assigned(FContrasteVisual) then
      IniReader.WriteString('Apariencia','ContrasteInterfaz',
        FLXTemaVisualATexto(TemaContrasteSeleccionado))
    else
      IniReader.WriteString('Apariencia','ContrasteInterfaz','NORMAL');
    //----------- Seccion BBDD -----------
    IniReader.WriteString('BBDD','host',Edit11.Text);
    IniReader.WriteString('BBDD','usuario',Edit12.Text);
    //-- IniReader.WriteString('BBDD','passwd',Edit13.Text);
    FLX_IniWritePassword(IniReader, 'BBDD', 'passwd',Edit13.Text);

    IniReader.WriteString('BBDD','database',Edit14.Text);
    IniReader.WriteString('BBDD','puerto',Edit15.Text);
    IniReader.WriteString('BBDD','protocolo',Combo1.Text);
    //----------- Seccion Tienda Activa
    IniReader.WriteString('tienda','codigo',FormatFloat('0000',StrToFloat(EditCambiableCodigo1.Text)));
    IniReader.WriteString('tienda','puesto',EditCambiableCodigo2.Text);

    //----------- Seccion SicLinEx -----------
    if CheckBox1.Checked=true then
      IniReader.WriteString('BBDD','ActivarSIC','S')
    else
      IniReader.WriteString('BBDD','ActivarSIC','N');
    IniReader.WriteString('BBDD','SIChost',Edit21.Text);
    IniReader.WriteString('BBDD','SICusuario',Edit22.Text);
    IniReader.WriteString('BBDD','SICpasswd',Edit23.Text);
    IniReader.WriteString('BBDD','SICdatabase',Edit24.Text);
    IniReader.WriteString('BBDD','SICpuerto',Edit25.Text);
    IniReader.WriteString('BBDD','SICprotocolo',Combo2.Text);
    //-------------- IVAS -------------------
    IniReader.WriteString('Programa','IVA1',Edit26.Text);
    IniReader.WriteString('Programa','IVA2',Edit27.Text);
    IniReader.WriteString('Programa','IVA3',Edit28.Text);
    IniReader.WriteString('Programa','RIVA1',Edit29.Text);
    IniReader.WriteString('Programa','RIVA2',Edit30.Text);
    IniReader.WriteString('Programa','RIVA3',Edit31.Text);
    //----------- Seccion tickets
    IniReader.WriteString('tickets','DevTicket',Edit32.Text);
    IniReader.WriteString('tickets','LiFinTick',Edit33.Text);
    IniReader.WriteString('tickets','CopiaTicket',Edit34.Text);
    IniReader.WriteString('tickets','CmdTicket',Edit35.Text);
    IniReader.WriteString('tickets','DevTicket1',Edit36.Text);
    IniReader.WriteString('tickets','LiFinTick1',Edit37.Text);
    IniReader.WriteString('tickets','CopiaTicket1',Edit38.Text);
    IniReader.WriteString('tickets','CmdTicket1',Edit39.Text);
    IniReader.WriteString('tickets','1LC',Edit40.Text);
    IniReader.WriteString('tickets','2LC',Edit41.Text);
    IniReader.WriteString('tickets','3LC',Edit42.Text);
    IniReader.WriteString('tickets','4LC',Edit43.Text);
    IniReader.WriteString('tickets','1LP',Edit44.Text);
    IniReader.WriteString('tickets','2LP',Edit45.Text);
    IniReader.WriteString('tickets','3LP',Edit46.Text);
    IniReader.WriteString('tickets','DevVisor',Edit47.Text);
    IniReader.WriteString('tickets','1LV',Edit48.Text);
    IniReader.WriteString('tickets','2LV',Edit49.Text);
    IniReader.WriteString('tickets','AperCajon',Edit50.Text);
    IniReader.WriteString('tickets','CortePapel',Edit51.Text);
    IniReader.WriteString('tickets','SecNil',Edit52.Text);
    IniReader.WriteString('tickets','Negro',Edit53.Text);
    IniReader.WriteString('tickets','Rojo',Edit54.Text);
    IniReader.WriteString('tickets','NegroD',Edit55.Text);
    IniReader.WriteString('tickets','RojoD',Edit56.Text);
    IniReader.WriteString('tickets','DevLogo',Edit70.Text);

    //---------- Sección Tickets ---------
    IniReader.WriteString('tickets','HoraEnTicket',ComboBox22.Text);
    IniReader.WriteString('tickets','SacaVende',ComboBox23.Text);
    IniReader.WriteString('tickets','DesgloIva',ComboBox24.Text);
    IniReader.WriteString('tickets','SacaIva',ComboBox25.Text);
    IniReader.WriteString('tickets','CgoEnTicket',ComboBox30.Text);

    //----------- Seccion informes
    IniReader.WriteString('informes','DatosEmpresa','N');
    IniReader.WriteString('informes','ImprePrevisu','N');
    IniReader.WriteString('informes','ImpreDirecto','N');
    IniReader.WriteString('informes','ImprePdf','N');

    IniReader.WriteString('informes','LeyendaInferiorQR',EdLeyendaInferior.Text);
    IniReader.WriteString('informes','LeyendaSuperiorQR',EdLeyendaSuperior.Text);
    IniReader.WriteString('informes','TextoCodigoQR',EdTextoQR.Text);


    if CheckBox2.Checked=true then IniReader.WriteString('informes','DatosEmpresa','S');
    if RadioGroup1.ItemIndex = 0 then IniReader.WriteString('informes','ImprePrevisu','S');
    if RadioGroup1.ItemIndex = 1 then IniReader.WriteString('informes','ImpreDirecto','S');
    if RadioGroup1.ItemIndex = 2 then IniReader.WriteString('informes','ImprePdf','S');
    //------------------------
  {    LA MAYORÍA DE LOS DATOS DE LA SECCIÓN PROGRAMA ESTÁN IMPLEMENTADOS EN LA SECCIÓN CONFIGURACIÓN GENERAL
         CON NUEVAS VARIABLES, REVISAR Y DECIDIR QUE Y COMO UTILIZARLAS


          (* Sección para Internet *)
          IniReader.WriteString('Internet','direccion',EditW3.Text);
          IniReader.WriteString('Internet','usuario',EditW3User.Text);
          IniReader.WriteString('Internet','password',EditW3Paswd.Text);
          IniReader.WriteString('Internet','Version',EditVersion.Text);

          (* Sección para los datos del programa *)
          IniReader.WriteString('Programa','FechaHora',EditD2.Text);
          IniReader.WriteString('Programa','Contabilidad',EditD3.Text);
          IniReader.WriteString('Programa','Papelera',EditD4.Text);
          IniReader.WriteString('Programa','TraspaAuto',EditD5.Text);
          IniReader.WriteString('Programa','HostConta',EditD6.Text);
          IniReader.WriteString('Programa','TarjeCliVar',EditD7.Text);
          IniReader.WriteString('Programa','TipoTicket',EditD8.Text);
          IniReader.WriteString('Programa','VisuTicket',EditD9.Text);
          IniReader.WriteString('Programa','DtoEuros',EditD10.Text);
          IniReader.WriteString('Programa','UsuarioCo',EditD11.Text);
          IniReader.WriteString('Programa','ClaveCo',EditD12.Text);
          IniReader.WriteString('Programa','PuertoCo',EditCPuerto.Text);
          IniReader.WriteString('Programa','ProtocoloCo',Combo2.Text);
          IniReader.WriteString('Programa','PasaClieCo',EditCClie.Text);
          IniReader.WriteString('Programa','CtaIVAE1',EditIVAE1.Text);
          IniReader.WriteString('Programa','CtaIVAE2',EditIVAE2.Text);
          IniReader.WriteString('Programa','CtaIVAE3',EditIVAE3.Text);
          IniReader.WriteString('Programa','CtaIVAR1',EditIVAR1.Text);
          IniReader.WriteString('Programa','CtaIVAR2',EditIVAR2.Text);
          IniReader.WriteString('Programa','CtaIVAR3',EditIVAR3.Text);
          IniReader.WriteString('Programa','CtaIVARE1',EditIVARE1.Text);
          IniReader.WriteString('Programa','CtaIVARE2',EditIVARE2.Text);
          IniReader.WriteString('Programa','CtaIVARE3',EditIVARE3.Text);
          IniReader.WriteString('Programa','ClaveCajon',EditCajon.Text);
          IniReader.WriteString('Programa','SacaVende',EditVende.Text);
          IniReader.WriteString('Programa','SacaIva',EditIVA.Text);
          IniReader.WriteString('Programa','DesgloIva',EditIvaDes.Text);
          IniReader.WriteString('Programa','LetrasFin',EditLetras.Text);
          IniReader.WriteString('Programa','Moneda',EditMoneda.Text);
          IniReader.WriteString('Programa','VerAlbaran',EditObser.Text);
          IniReader.WriteString('Programa','ImpriAlba',EditImpAlba.Text);
          IniReader.WriteString('Programa','VerFactura',EditPreFact.Text);
          IniReader.WriteString('Programa','ImpriFact',EditImpFact.Text);
          IniReader.WriteString('Programa','ControStock',EditControStock.Text);
          IniReader.WriteString('Programa','CodiPeso',EditCodiPeso.Text);
          IniReader.WriteString('Programa','PreciIva',EditIVAP.Text);
          IniReader.WriteString('Programa','CrediAlba',EditPAlba.Text);
          IniReader.WriteString('Programa','CrediFactu',EditPFact.Text);
          IniReader.WriteString('Programa','BeneCaja',EditBene.Text);
          IniReader.WriteString('Programa','AgruEnva',EditAgru.Text);
          IniReader.WriteString('Programa','UtiEnva',EditUtiEnva.Text);
          IniReader.WriteString('Programa','UtiLote',EditUtiLote.Text);
          IniReader.WriteString('Programa','TicketRega',EditTicketRega.Text);
          IniReader.WriteString('Programa','BorraAlba',EditBoAl.Text);
          IniReader.WriteString('Programa','MarcaVentas',EditMarVen.Text);
          IniReader.WriteString('Programa','Horario',EditHora.Text);

          (* Sección para Recibos CSB19 *)
          IniReader.WriteString('CSB19','HostReci',EditCSB1.Text);
          IniReader.WriteString('CSB19','UsuReci',EditCSB2.Text);
          IniReader.WriteString('CSB19','ClaveReci',EditCSB3.Text);
          IniReader.WriteString('CSB19','ProtocoloReci',ComboCSB.Text);
          IniReader.WriteString('CSB19','BBDDReci',EditCSB4.Text);
          IniReader.WriteString('CSB19','PuertoReci',EditCSB5.Text);
          IniReader.WriteString('CSB19','PapeReci',EditCSB6.Text);
          IniReader.WriteString('CSB19','PasaFaReci',EditCSB7.Text);
          IniReader.WriteString('CSB19','UsaCliReci',EditCSB8.Text);

          (* Sección para los modulos del programa *)
          IniReader.WriteString('Programa','Modulo1',EditMod1.Text);
          IniReader.WriteString('Programa','CompraCierre',EditMod2.Text);
          IniReader.WriteString('Programa','Tarifas',EditMod3.Text);
          IniReader.WriteString('Programa','Teclado',EditMod4.Text);

  }
          //-------------- Aplicaciones Extras -------------------
          IniReader.WriteString('ProExt','Pdf',Edit58.Text);
          IniReader.WriteString('ProExt','CarpetaPdf',Edit59.Text);
          IniReader.WriteString('ProExt','CarpetaImagenes',Edit69.Text);
          IniReader.WriteString('ProExt','AbrirAchivo',EditAbrirArchivo.Text);

         if cbCopia1.Checked then
             IniReader.WriteString('ProExt','Copia1Activada','SI')
          else
             IniReader.WriteString('ProExt','Copia1Activada','NO');
          IniReader.WriteString('ProExt','Copia1InicioHora',Copia1InicioHora.Text);
          IniReader.WriteString('ProExt','Copia1InicioMinutos',Copia1InicioMinutos.Text);
          IniReader.WriteString('ProExt','Copia1FinHora',Copia1FinHora.Text);
          IniReader.WriteString('ProExt','Copia1FinMinutos',Copia1FinMinutos.Text);
          IniReader.WriteString('ProExt','Copia1Destino',Copia1Destino.Text);

         if cbCopia2.Checked then
             IniReader.WriteString('ProExt','Copia2Activada','SI')
          else
             IniReader.WriteString('ProExt','Copia2Activada','NO');
          IniReader.WriteString('ProExt','Copia2InicioHora',Copia2InicioHora.Text);
          IniReader.WriteString('ProExt','Copia2InicioMinutos',Copia2InicioMinutos.Text);
          IniReader.WriteString('ProExt','Copia2FinHora',Copia2FinHora.Text);
          IniReader.WriteString('ProExt','Copia2FinMinutos',Copia2FinMinutos.Text);
          IniReader.WriteString('ProExt','Copia2Destino',Copia2Destino.Text);

          if cbCopia3.Checked then
             IniReader.WriteString('ProExt','Copia3Activada','SI')
          else
             IniReader.WriteString('ProExt','Copia3Activada','NO');
          IniReader.WriteString('ProExt','Copia3InicioHora',Copia3InicioHora.Text);
          IniReader.WriteString('ProExt','Copia3InicioMinutos',Copia3InicioMinutos.Text);
          IniReader.WriteString('ProExt','Copia3FinHora',Copia3FinHora.Text);
          IniReader.WriteString('ProExt','Copia3FinMinutos',Copia3FinMinutos.Text);
          IniReader.WriteString('ProExt','Copia3Destino',Copia3Destino.Text);

    //---------- Sección Puntos ---------
    IniReader.WriteString('Puntos','Activar_Puntos',Edit17.Text);
    IniReader.WriteString('Puntos','Activar_Productos',Edit60.Text);
    IniReader.WriteString('Puntos','Porcentaje',Edit61.Text);
    IniReader.WriteString('Puntos','Extra',Edit62.Text);
    IniReader.WriteString('Puntos','Especial',Edit63.Text);

    //---------- Sección de Configuración General ----------
    IniReader.WriteString('CGeneral','Cod_balanza',Edit66.Text);
    IniReader.WriteString('CGeneral','Tarjetas_Varios',ComboBox1.Text);
    IniReader.WriteString('CGeneral','Precio_IVA_Inc',ComboBox2.Text);
    IniReader.WriteString('CGeneral','Benficio_Caja',ComboBox3.Text);
    IniReader.WriteString('CGeneral','Forzar_Albaranes',ComboBox4.Text);
    IniReader.WriteString('CGeneral','Permitir_Fras_Credito',ComboBox5.Text);
    IniReader.WriteString('CGeneral','Borra_Albaran_Facturado',ComboBox6.Text);
    IniReader.WriteString('CGeneral','Mostrar_Oferta',ComboBox7.Text);
    IniReader.WriteString('CGeneral','Controlar_Horas',ComboBox8.Text);
    IniReader.WriteString('CGeneral','Activar_Lotes',ComboBox9.Text);
    IniReader.WriteString('CGeneral','Activar_Envases',ComboBox10.Text);
    IniReader.WriteString('CGeneral','Agrupar_Envases',ComboBox11.Text);
    IniReader.WriteString('CGeneral','Imprimir_Dto',ComboBox13.Text);
    IniReader.WriteString('CGeneral','Visualiar_antes_imprimir',ComboBox14.Text);
    IniReader.WriteString('CGeneral','Imprimir_Ticket',ComboBox15.Text);
    IniReader.WriteString('CGeneral','Imprimir_Ticket_Regalo',ComboBox16.Text);
    IniReader.WriteString('CGeneral','Previsualizar_Albaran_Ventas',ComboBox17.Text);
    IniReader.WriteString('CGeneral','Imprimir_Albaranes',ComboBox18.Text);
    IniReader.WriteString('CGeneral','Previsualizar_Facturas_Ventas',ComboBox19.Text);
    IniReader.WriteString('CGeneral','Imprimir_Facturas',ComboBox20.Text);
    IniReader.WriteString('CGeneral','Importe_Letras_Facturas',ComboBox21.Text);
    IniReader.WriteString('CGeneral','Tiempo_Visualizar_Aviso',ComboBox26.Text);
    IniReader.WriteString('CGeneral','Avisar_Llamadas',ComboBox27.Text);
    IniReader.WriteString('CGeneral','Dias_Aviso_Llamadas',Edit64.Text);
    IniReader.WriteString('CGeneral','Avisar_Pedidos',ComboBox27.Text);
    IniReader.WriteString('CGeneral','Dias_Aviso_Pedidos',Edit65.Text);
    IniReader.WriteString('CGeneral','Activar_Claves',ComboBox29.Text);
    IniReader.WriteString('CGeneral','PedirUsuario',ComboBox31.Text);
    IniReader.WriteString('CGeneral','NumeroDecimales',cbPrecision.Text);
    IniReader.WriteString('CGeneral','ImprimirLOPD',ComboboxLOPD.Text);
    IniReader.WriteString('CGeneral','Stock_suficiente', cbRupturaStock.Text);
    IniReader.WriteString('CGeneral','CgClienteVario', edCliVario.Text);
    if Assigned(cbClientesBuscarNIFCodigo) then
      IniReader.WriteString('CGeneral','ClientesBuscarNIFDesdeCodigo', cbClientesBuscarNIFCodigo.Text)
    else
      IniReader.WriteString('CGeneral','ClientesBuscarNIFDesdeCodigo', 'S');
    if Assigned(cbClientesModoCodigoAltaNIF) then
      IniReader.WriteString('CGeneral','ClientesModoCodigoAltaNIF', cbClientesModoCodigoAltaNIF.Text)
    else
      IniReader.WriteString('CGeneral','ClientesModoCodigoAltaNIF', 'SIGUIENTE_NORMAL');
    if Assigned(edClientesCodigoSuperiorDesde) then
      IniReader.WriteString('CGeneral','ClientesCodigoSuperiorDesde', edClientesCodigoSuperiorDesde.Text)
    else
      IniReader.WriteString('CGeneral','ClientesCodigoSuperiorDesde', '999999');
    IniReader.WriteString('CGeneral','CgSeguroCajon',CgSCajon.Text);
    IniReader.WriteString('CGeneral','Moneda', edMoneda.Text);

       //------------Correo electrónico -------
    IniReader.WriteString('Correo','Copia',edCuentaCopia.Text);
    IniReader.WriteString('Correo','Emisor',edCuenta.Text);
    IniReader.WriteString('Correo','Cabecera',edCabecera.Text);
    IniReader.WriteString('Correo','Mensaje1',edMensaje1.Text);
    IniReader.WriteString('Correo','Mensaje2',edMensaje2.Text);
    IniReader.WriteString('Correo','Mensaje3',edMensaje3.Text);
    IniReader.WriteString('Correo','Mensaje4',edMensaje4.Text);
    IniReader.WriteString('Correo','Usuario',edUsuario.Text);
    IniReader.WriteString('Correo','Host',edHost.Text);
    FLX_IniWritePassword(IniReader, 'Correo', 'Clave', edClave.Text);
    IniReader.WriteString('Correo','Puerto',edPuerto.Text);
    IniReader.WriteString('Correo','SSL',BoolToStr(cbSSL.Checked));
    IniReader.WriteString('Correo','TLS',BoolToStr(cbTLS.Checked));


      //--------------- VeriFactu ---------------------
    AplicarDefaultsVeriFactuEnBlanco;
    IniReader.WriteString('VeriFactu','vfUrl',edit71.Text);
    IniReader.WriteString('VeriFactu','vfUrlTP',edit72.Text);
    IniReader.WriteString('VeriFactu','vfUrlTLocal',edit73.Text);
    if vfCheckTest.Checked then vfMode:='PRUEBAS' else vfMode:='PRODUCCION';
    IniReader.WriteString('VeriFactu','vfMode',vfMode);

      //---------- Sistema de copia automática MONO-USUARIO
    IniReader.WriteString('bbdd_copy','MonoUsuario',BoolToStr(bbdd_autocopy.Checked));

    GuardarConfiguracionBackupRemoto(IniReader);

    IniReader.WriteString('MotorBBDD','mbbdd',CBMbbdd.Text);

end;

//=============== Crea el formulario ================
procedure ShowFormConfig;
begin
  with TFConfig.Create(Application) do
    begin
       ShowModal;
    end;
end;

{ TFConfig }

//================== CREAR APLICACION ================
procedure TFConfig.FormCreate(Sender: TObject);
begin
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.

  IniReader := FLXOpenFacturConfIni;

  Sections := TStringList.Create;
  IniReader.ReadSections( Sections );

  PageControl1.ActivePage := TabSheet1;
  CrearControlesClientesCodigo;
  CrearControlesBackupRemoto;
  CrearControlesApariencia;
  RestaurarIni;

  LabelCambiable1.Caption:='Tienda Activa';
  LabelCambiable2.Caption:='Puesto';

  EditAbrirArchivo.Text:=AbrirAchivo;

  // La carga inicial ya ha terminado. A partir de aquí,
  // el primer cambio del usuario debe activar Guardar/Recuperar.
  IniForm:=False;

  fechaiva.Date:=Date;

  lbIni.Caption:='Fichero de configuración en ' + RutaIni;
  lbBinario.Caption:='Sistema instalado en ' + RutaBin;
  lbSql.Caption:='Definición de la BBDD almacenada en ' + RutaSql;
  lbImagenes.Caption:='Imágenes guardadas en ' + RutaIconos;
  lbReport.Caption:='Plantillas de informes y documentos en ' + RutaReports ;
  lbModulos.Caption:='Módulos instalados en ' + RutaModulos;

  // Los controles de VeriFactu no tenían evento OnChange.
  // Se asignan aquí, DESPUÉS de RestaurarIni, para que la carga inicial
  // no marque la configuración como modificada.
  Edit71.OnChange      := @VeriFactuChange;
  Edit72.OnChange      := @VeriFactuChange;
  Edit73.OnChange      := @VeriFactuChange;
  vfCheckTest.OnChange := @VeriFactuChange;

  if Assigned(cbClientesBuscarNIFCodigo) then
    cbClientesBuscarNIFCodigo.OnChange := @ClientesCodigoConfigChange;
  if Assigned(cbClientesModoCodigoAltaNIF) then
    cbClientesModoCodigoAltaNIF.OnChange := @ClientesCodigoConfigChange;
  if Assigned(edClientesCodigoSuperiorDesde) then
    edClientesCodigoSuperiorDesde.OnChange := @ClientesCodigoConfigChange;
  if Assigned(FContrasteVisual) then
    FContrasteVisual.OnClick := @ContrasteVisualChange;

  FRemoteEnabled.OnChange := @BackupRemotoCambio;
  FRemoteAutoOnExit.OnChange := @BackupRemotoCambio;
  FRemoteFTPOnExit.OnChange := @BackupRemotoCambio;
  FRemoteHost.OnChange := @BackupRemotoCambio;
  FRemotePort.OnChange := @BackupRemotoCambio;
  FRemoteUser.OnChange := @BackupRemotoCambio;
  FRemoteAuth.OnChange := @BackupRemotoCambio;
  FRemoteKey.OnChange := @BackupRemotoCambio;
  FRemotePassword.OnChange := @BackupRemotoCambio;
  FRemoteDestination.OnChange := @BackupRemotoCambio;
  FRemoteCommand.OnChange := @BackupRemotoCambio;
  FRemoteKeep.OnChange := @BackupRemotoCambio;
  ActualizarEstadoBackupRemoto;

  // Estado inicial limpio: no hay cambios pendientes al abrir configuración.
  BitBtn1.Enabled := False;
  BitBtn2.Enabled := False;
  IniForm := False;

  If rutaBin='/usr/bin/' then
       begin
        lbSistema.Font.Color:=clGreen;
        lbSistema.Caption:=' Sistema en producción ';

       end else
       begin
        lbSistema.Font.Color:=clMaroon;
        lbSistema.Caption:=' Sistema en desarrollo ';
       end;

  AplicarEstiloModerno;
  FLXAplicarTemaVisual(Self);
  ActualizarVistaPreviaContraste;
end;

procedure TFConfig.pcAplicacionesExtraEnter(Sender: TObject);
begin
  cbCopia1Change(Self);
  cbCopia2Change(Self);
  cbCopia3Change(Self);
end;

//================== CERRAR FORMULARIO ===============
procedure TFConfig.BitBtn3Click(Sender: TObject);
begin
  Close();
end;

procedure TFConfig.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(FRemoteEnabled) then
    GuardarConfiguracionBackupRemotoPersistente;

  FreeAndNil(IniReader);
  FreeAndNil(Sections);

  showmessage('Se recomienda reiniciar la aplicación para evitar errores');
  CloseAction:=CaFree;
  //-- COMENTADO PORQUE HACÍA QUE EL FICHERO .INI FUESE REESCRITO CON DATOS ANTERIORES
//--  if Assigned(FMenu) then
//--      FMenu.VF_SetMode(vfMode); // ← instancia, no TFMenu.
end;


//Procedure para leer los valores del fichero INI
procedure TFConfig.RestaurarIni();
var
  tmpBoolean: string;
begin
  { Recuperar siempre desde la versión actual del fichero. }
  RecargarIniReaderDesdeDisco;

  //---------- Sección Empresa ---------
  Edit1.Text := IniReader.ReadString('datos','nombre','');
  Edit2.Text := IniReader.ReadString('datos','representante','');
  Edit3.Text := IniReader.ReadString('datos','direccion','');
  Edit4.Text := IniReader.ReadString('datos','poblacion','');
  Edit5.Text := IniReader.ReadString('datos','cp','');
  Edit6.Text := IniReader.ReadString('datos','provincia','');
  Edit7.Text := IniReader.ReadString('datos','CIF','');
  Edit8.Text := IniReader.ReadString('datos','telefono','');
  Edit9.Text := IniReader.ReadString('datos','fax','');
  Edit10.Text := IniReader.ReadString('datos','mail','');
  Edit57.Text := IniReader.ReadString('datos','logo','');
  if Edit57.Text<>'' then Edit57Exit(Edit57);//----- Cargar logo.
  Edit16.Text := IniReader.ReadString('datos','registro','');
  Edit67.Text := IniReader.ReadString('datos','ColorFondo','');
  Edit68.Text := IniReader.ReadString('datos','ColorBotones','');
  if Assigned(FContrasteVisual) then
  begin
    FContrasteVisual.ItemIndex := Ord(FLXTemaVisualDesdeTexto(
      IniReader.ReadString('Apariencia','ContrasteInterfaz','NORMAL')));
    ActualizarVistaPreviaContraste;
  end;
  //----------- Seccion BBDD -----------
  Edit11.Text := IniReader.ReadString('BBDD','host','');
  Edit12.Text := IniReader.ReadString('BBDD','usuario','');
  //-- Edit13.Text := IniReader.ReadString('BBDD','passwd','');
  Edit13.Text := FLX_IniReadPassword(IniReader, 'BBDD', 'passwd', '');
  Edit14.Text := IniReader.ReadString('BBDD','database','');
  Edit15.Text := IniReader.ReadString('BBDD','puerto','');
  Combo1.Text := IniReader.ReadString('BBDD','protocolo','');
  //----------- Seccion Tienda Activa --------
  EditCambiableCodigo1.Text:= IniReader.ReadString('tienda','codigo','');
  EditCambiableCodigo2.Text:= IniReader.ReadString('tienda','puesto','');
  //----------- Seccion SicLinEx -----------
  if IniReader.ReadString('BBDD','ActivarSIC','')='S' then
   CheckBox1.Checked:=true else CheckBox1.Checked:=false;
  Edit21.Text := IniReader.ReadString('BBDD','SIChost','');
  Edit22.Text := IniReader.ReadString('BBDD','SICusuario','');
  Edit23.Text := IniReader.ReadString('BBDD','SICpasswd','');
  Edit24.Text := IniReader.ReadString('BBDD','SICdatabase','');
  Edit25.Text := IniReader.ReadString('BBDD','SICpuerto','');
  Combo2.Text := IniReader.ReadString('BBDD','SICprotocolo','');
  //----------- Seccion datos del programa
  Edit26.Text := IniReader.ReadString('Programa','IVA1','');
  Edit27.Text := IniReader.ReadString('Programa','IVA2','');
  Edit28.Text := IniReader.ReadString('Programa','IVA3','');
  Edit29.Text := IniReader.ReadString('Programa','RIVA1','');
  Edit30.Text := IniReader.ReadString('Programa','RIVA2','');
  Edit31.Text := IniReader.ReadString('Programa','RIVA3','');
  //----------- Seccion tickets
  Edit32.Text := IniReader.ReadString('tickets','DevTicket','');
  Edit33.Text := IniReader.ReadString('tickets','LiFinTick','');
  Edit34.Text := IniReader.ReadString('tickets','CopiaTicket','');
  Edit35.Text := IniReader.ReadString('tickets','CmdTicket','');
  Edit36.Text := IniReader.ReadString('tickets','DevTicket1','');
  Edit37.Text := IniReader.ReadString('tickets','LiFinTick1','');
  Edit38.Text := IniReader.ReadString('tickets','CopiaTicket1','');
  Edit39.Text := IniReader.ReadString('tickets','CmdTicket1','');
  Edit40.Text := IniReader.ReadString('tickets','1LC','');
  Edit41.Text := IniReader.ReadString('tickets','2LC','');
  Edit42.Text := IniReader.ReadString('tickets','3LC','');
  Edit43.Text := IniReader.ReadString('tickets','4LC','');
  Edit44.Text := IniReader.ReadString('tickets','1LP','');
  Edit45.Text := IniReader.ReadString('tickets','2LP','');
  Edit46.Text := IniReader.ReadString('tickets','3LP','');
  Edit47.Text := IniReader.ReadString('tickets','DevVisor','');
  Edit48.Text := IniReader.ReadString('tickets','1LV','');
  Edit49.Text := IniReader.ReadString('tickets','2LV','');
  Edit50.Text := IniReader.ReadString('tickets','AperCajon','');
  Edit51.Text := IniReader.ReadString('tickets','CortePapel','');
  Edit52.Text := IniReader.ReadString('tickets','SecNil','');
  Edit53.Text := IniReader.ReadString('tickets','Negro','');
  Edit54.Text := IniReader.ReadString('tickets','Rojo','');
  Edit55.Text := IniReader.ReadString('tickets','NegroD','');
  Edit56.Text := IniReader.ReadString('tickets','RojoD','');
  Edit70.Text := IniReader.ReadString('tickets','DevLogo','');

  ComboBox22.Text:=IniReader.ReadString('tickets','HoraEnTicket','');
  ComboBox23.Text:=IniReader.ReadString('tickets','SacaVende','');
  ComboBox24.Text:=IniReader.ReadString('tickets','DesgloIva','');
  ComboBox25.Text:=IniReader.ReadString('tickets','SacaIva','');
  ComboBox30.Text:=IniReader.ReadString('tickets','CgoEnTicket','');

  //----------- Seccion informes
  CheckBox2.Checked:=False;
  RadioGroup1.ItemIndex:=1;
  if IniReader.ReadString('informes','DatosEmpresa','')='S' then CheckBox2.Checked:=true;
  if IniReader.ReadString('informes','ImprePrevisu','')='S' then RadioGroup1.ItemIndex:=0;
  if IniReader.ReadString('informes','ImpreDirecto','')='S' then RadioGroup1.ItemIndex:=1;
  if IniReader.ReadString('informes','ImprePdf','')='S' then RadioGroup1.ItemIndex:=2;

  EdLeyendaInferior.Text:= IniReader.ReadString('informes','LeyendaInferiorQR','');
  EdLeyendaSuperior.Text:= IniReader.ReadString('informes','LeyendaSuperiorQR','');
  EdTextoQR.Text:= IniReader.ReadString('informes','TextoCodigoQR','');


{
        (* Sección para Datos de la tienda *)

        (* Sección para Internet *)
        EditW3.Text := IniReader.ReadString('Internet','direccion','');
        EditW3User.Text := IniReader.ReadString('Internet','usuario','');
        EditW3Paswd.Text := IniReader.ReadString('Internet','password','');
        EditVersion.Text := IniReader.ReadString('Internet','Version','');


        (* Sección para las datos de la programa *)
        EditD2.Text := IniReader.ReadString('Programa','FechaHora','');
        EditD3.Text := IniReader.ReadString('Programa','Contabilidad','');
        EditD4.Text := IniReader.ReadString('Programa','Papelera','');
        EditD5.Text := IniReader.ReadString('Programa','TraspaAuto','');
        EditD6.Text := IniReader.ReadString('Programa','HostConta','');
        EditD7.Text := IniReader.ReadString('Programa','TarjeCliVar','');
        EditD8.Text := IniReader.ReadString('Programa','TipoTicket','');
        EditD9.Text := IniReader.ReadString('Programa','VisuTicket','');
        EditD10.Text := IniReader.ReadString('Programa','DtoEuros','');
        EditD11.Text := IniReader.ReadString('Programa','UsuarioCo','');
        EditD12.Text := IniReader.ReadString('Programa','ClaveCo','');
        EditCPuerto.Text := IniReader.ReadString('Programa','PuertoCo','');
        Combo2.Text := IniReader.ReadString('Programa','ProtocoloCo','');
        EditCClie.Text := IniReader.ReadString('Programa','PasaClieCo','');
        EditIVAE1.Text := IniReader.ReadString('Programa','CtaIVAE1','');
        EditIVAE2.Text := IniReader.ReadString('Programa','CtaIVAE2','');
        EditIVAE3.Text := IniReader.ReadString('Programa','CtaIVAE3','');
        EditIVAR1.Text := IniReader.ReadString('Programa','CtaIVAR1','');
        EditIVAR2.Text := IniReader.ReadString('Programa','CtaIVAR2','');
        EditIVAR3.Text := IniReader.ReadString('Programa','CtaIVAR3','');
        EditIVARE1.Text := IniReader.ReadString('Programa','CtaIVARE1','');
        EditIVARE2.Text := IniReader.ReadString('Programa','CtaIVARE2','');
        EditIVARE3.Text := IniReader.ReadString('Programa','CtaIVARE3','');
        EditCajon.Text := IniReader.ReadString('Programa','ClaveCajon','');
        EditVende.Text := IniReader.ReadString('Programa','SacaVende','');
        EditIVA.Text := IniReader.ReadString('Programa','SacaIva','');
        EditIVADES.Text := IniReader.ReadString('Programa','DesgloIva','');
        EditLetras.Text := IniReader.ReadString('Programa','LetrasFin','');
        EditMoneda.Text := IniReader.ReadString('Programa','Moneda','');
        EditObser.Text := IniReader.ReadString('Programa','VerAlbaran','');
        EditImpAlba.Text := IniReader.ReadString('Programa','ImpriAlba','');
        EditPreFact.Text := IniReader.ReadString('Programa','VerFactura','');
        EditImpFact.Text := IniReader.ReadString('Programa','ImpriFact','');
        EditControStock.Text := IniReader.ReadString('Programa','ControStock','');
        EditCodiPeso.Text := IniReader.ReadString('Programa','CodiPeso','');
        EditIVAP.Text := IniReader.ReadString('Programa','PreciIva','');
        EditPAlba.Text := IniReader.ReadString('Programa','CrediAlba','');
        EditPFact.Text := IniReader.ReadString('Programa','CrediFactu','');
        EditBene.Text := IniReader.ReadString('Programa','BeneCaja','');
        EditAgru.Text := IniReader.ReadString('Programa','AgruEnva','');
        EditUtiEnva.Text := IniReader.ReadString('Programa','UtiEnva','');
        EditUtiLote.Text := IniReader.ReadString('Programa','UtiLote','');
        EditTicketRega.Text := IniReader.ReadString('Programa','TicketRega','');
        EditBoAl.Text := IniReader.ReadString('Programa','BorraAlba','');
        EditMarVen.Text := IniReader.ReadString('Programa','MarcaVentas','');
        EditHora.Text := IniReader.ReadString('Programa','Horario','');

        (* Sección para Recibos CSB19 *)
        EditCSB1.Text:=IniReader.ReadString('CSB19','HostReci','');
        EditCSB2.Text:=IniReader.ReadString('CSB19','UsuReci','');
        EditCSB3.Text:=IniReader.ReadString('CSB19','ClaveReci','');
        ComboCSB.Text:=IniReader.ReadString('CSB19','ProtocoloReci','');
        EditCSB4.Text:=IniReader.ReadString('CSB19','BBDDReci','');
        EditCSB5.Text:=IniReader.ReadString('CSB19','PuertoReci','');
        EditCSB6.Text:=IniReader.ReadString('CSB19','PapeReci','');
        EditCSB7.Text:=IniReader.ReadString('CSB19','PasaFaReci','');
        EditCSB8.Text:=IniReader.ReadString('CSB19','UsaCliReci','');

        (* Sección para los modulos del programa *)
        EditMod1.Text := IniReader.ReadString('Programa','Modulo1','');
        EditMod2.Text := IniReader.ReadString('Programa','CompraCierre','');
        EditMod3.Text := IniReader.ReadString('Programa','Tarifas','');
        EditMod4.Text := IniReader.ReadString('Programa','Teclado','');

        (* Sección para Programas Externos Datos de la empresa *)
        EditPE1.Text:=IniReader.ReadString('ProExt','Correo','');
        EditPE2.Text:=IniReader.ReadString('ProExt','Navegador','');
        EditPE3.Text:=IniReader.ReadString('ProExt','Procesador','');
        EditPE4.Text:=IniReader.ReadString('ProExt','Hoja','');
        EditPE5.Text:=IniReader.ReadString('ProExt','Pdf','');
        EditPE6.Text:=IniReader.ReadString('ProExt','Vozip','');
}

        //-------------- Aplicaciones Extras -------------------
        Edit58.Text          :=IniReader.ReadString('ProExt','Pdf','');
        Edit59.Text          :=IniReader.ReadString('ProExt','CarpetaPdf','');
        Edit69.Text          :=IniReader.ReadString('ProExt','CarpetaImagenes','');
        EditAbrirArchivo.Text:=IniReader.ReadString('ProExt','AbrirAchivo','');

        if IniReader.ReadString('ProExt','Copia1Activada','')='SI' then
           cbCopia1.Checked      :=True
        else
           cbCopia1.Checked      :=False;
        Copia1InicioHora.Text    :=IniReader.ReadString('ProExt','Copia1InicioHora','');
        Copia1InicioMinutos.Text :=IniReader.ReadString('ProExt','Copia1InicioMinutos','');
        Copia1FinHora.Text       :=IniReader.ReadString('ProExt','Copia1FinHora','');
        Copia1FinMinutos.Text    :=IniReader.ReadString('ProExt','Copia1FinMinutos','');
        Copia1Destino.Text       :=IniReader.ReadString('ProExt','Copia1Destino','');

        if IniReader.ReadString('ProExt','Copia2Activada','')='SI' then
           cbCopia2.Checked  :=True
        else
           cbCopia2.Checked  :=False;
        Copia2InicioHora.Text    :=IniReader.ReadString('ProExt','Copia2InicioHora','');
        Copia2InicioMinutos.Text :=IniReader.ReadString('ProExt','Copia2InicioMinutos','');
        Copia2FinHora.Text       :=IniReader.ReadString('ProExt','Copia2FinHora','');
        Copia2FinMinutos.Text    :=IniReader.ReadString('ProExt','Copia2FinMinutos','');
        Copia2Destino.Text       :=IniReader.ReadString('ProExt','Copia2Destino','');

        if IniReader.ReadString('ProExt','Copia3Activada','')='SI' then
           cbCopia3.Checked  :=True
        else
           cbCopia3.Checked  :=False;
        Copia3InicioHora.Text    :=IniReader.ReadString('ProExt','Copia3InicioHora','');
        Copia3InicioMinutos.Text :=IniReader.ReadString('ProExt','Copia3InicioMinutos','');
        Copia3FinHora.Text       :=IniReader.ReadString('ProExt','Copia3FinHora','');
        Copia3FinMinutos.Text    :=IniReader.ReadString('ProExt','Copia3FinMinutos','');
        Copia3Destino.Text       :=IniReader.ReadString('ProExt','Copia3Destino','');

  //---------- Sección Puntos ---------
  Edit17.Text := IniReader.ReadString('Puntos','Activar_Puntos','');
  Edit60.Text := IniReader.ReadString('Puntos','Activar_Productos','');
  Edit61.Text := IniReader.ReadString('Puntos','Porcentaje','');
  Edit62.Text := IniReader.ReadString('Puntos','Extra','');
  Edit63.Text := IniReader.ReadString('Puntos','Especial','');

    //----------------------------------- Configuración General --------------
    Edit66.Text:=IniReader.ReadString('CGeneral','Cod_balanza','');
    ComboBox1.Text:=IniReader.ReadString('CGeneral','Tarjetas_Varios','');
    ComboBox2.Text:=IniReader.ReadString('CGeneral','Precio_IVA_Inc','');
    ComboBox3.Text:=IniReader.ReadString('CGeneral','Benficio_Caja','');
    ComboBox4.Text:=IniReader.ReadString('CGeneral','Forzar_Albaranes','');
    ComboBox5.Text:=IniReader.ReadString('CGeneral','Permitir_Fras_Credito','');
    ComboBox6.Text:=IniReader.ReadString('CGeneral','Borra_Albaran_Facturado','');
    ComboBox7.Text:=IniReader.ReadString('CGeneral','Mostrar_Oferta','');
    ComboBox8.Text:=IniReader.ReadString('CGeneral','Controlar_Horas','');
    ComboBox9.Text:=IniReader.ReadString('CGeneral','Activar_Lotes','');
    ComboBox10.Text:=IniReader.ReadString('CGeneral','Activar_Envases','');
    ComboBox11.Text:=IniReader.ReadString('CGeneral','Agrupar_Envases','');
    ComboBox13.Text:=IniReader.ReadString('CGeneral','Imprimir_Dto','');
    ComboBox14.Text:=IniReader.ReadString('CGeneral','Visualiar_antes_imprimir','');
    ComboBox15.Text:=IniReader.ReadString('CGeneral','Imprimir_Ticket','');
    ComboBox16.Text:=IniReader.ReadString('CGeneral','Imprimir_Ticket_Regalo','');
    ComboBox17.Text:=IniReader.ReadString('CGeneral','Previsualizar_Albaran_Ventas','');
    ComboBox18.Text:=IniReader.ReadString('CGeneral','Imprimir_Albaranes','');
    ComboBox19.Text:=IniReader.ReadString('CGeneral','Previsualizar_Facturas_Ventas','');
    ComboBox20.Text:=IniReader.ReadString('CGeneral','Imprimir_Facturas','');
    ComboBox21.Text:=IniReader.ReadString('CGeneral','Importe_Letras_Facturas','');
    ComboBox26.Text:=IniReader.ReadString('CGeneral','Tiempo_Visualizar_Aviso','');
    ComboBox27.Text:=IniReader.ReadString('CGeneral','Avisar_Llamadas','');
    Edit64.Text:=IniReader.ReadString('CGeneral','Dias_Aviso_Llamadas','');
    ComboBox27.Text:=IniReader.ReadString('CGeneral','Avisar_Pedidos','');
    Edit65.Text:=IniReader.ReadString('CGeneral','Dias_Aviso_Pedidos','');
    ComboBox29.Text:=IniReader.ReadString('CGeneral','Activar_Claves','');
    ComboBox31.Text:=IniReader.ReadString('CGeneral','PedirUsuario','');
    cbPrecision.Text:= IniReader.ReadString('CGeneral','NumeroDecimales','');
    ComboboxLOPD.Text:= IniReader.ReadString('CGeneral','ImprimirLOPD','');
    cbRupturaStock.Text:=IniReader.ReadString('CGeneral','Stock_suficiente','');
    edMoneda.Text:=IniReader.ReadString('CGeneral','Moneda','');
    edCliVario.Text:=IniReader.ReadString('CGeneral','CgClienteVario','');
    if Assigned(cbClientesBuscarNIFCodigo) then
    begin
      cbClientesBuscarNIFCodigo.Text:=UpperCase(Trim(IniReader.ReadString('CGeneral','ClientesBuscarNIFDesdeCodigo','S')));
      if cbClientesBuscarNIFCodigo.Text='' then cbClientesBuscarNIFCodigo.Text:='S';
    end;
    if Assigned(cbClientesModoCodigoAltaNIF) then
    begin
      cbClientesModoCodigoAltaNIF.Text:=UpperCase(Trim(IniReader.ReadString('CGeneral','ClientesModoCodigoAltaNIF','SIGUIENTE_NORMAL')));
      if cbClientesModoCodigoAltaNIF.Text='' then cbClientesModoCodigoAltaNIF.Text:='SIGUIENTE_NORMAL';
    end;
    if Assigned(edClientesCodigoSuperiorDesde) then
      edClientesCodigoSuperiorDesde.Text:=IniReader.ReadString('CGeneral','ClientesCodigoSuperiorDesde','999999');
    CgSCajon.Text:= IniReader.ReadString('CGeneral','CgSeguroCajon','');

       //Rellenar valores de Combo Tienda y puesto
       RellenaPanelCambiableN('SELECT T1 FROM tiendas WHERE T0="'+EditCambiableCodigo1.Text+'"',dbCambiable1, StaticTextCambiableNombre1);
       //WriteLn('SELECT PT1 FROM puestos'+Tienda+' WHERE P0="'+EditCambiableCodigo2.Text+'"');
       RellenaPanelCambiableN('SELECT PT1 FROM puestos'+tienda+' WHERE PT0="'+EditCambiableCodigo2.Text+'"',dbCambiable2, StaticTextCambiableNombre2);


        (* Desactivamos botones *)
        BitBtn1.Enabled := False;
        BitBtn2.Enabled := False;


        //------------Correo electrónico -------
     edCuentaCopia.Text:=    IniReader.ReadString('Correo','Copia','');
     edCuenta.Text:=    IniReader.ReadString('Correo','Emisor','');
     edCabecera.Text:=  IniReader.ReadString('Correo','Cabecera','');
     edMensaje1.Text:=  IniReader.ReadString('Correo','Mensaje1','');
     edMensaje2.Text:=  IniReader.ReadString('Correo','Mensaje2','');
     edMensaje3.Text:=  IniReader.ReadString('Correo','Mensaje3','');
     edMensaje4.Text:=  IniReader.ReadString('Correo','Mensaje4','');
     edUsuario.Text:=   IniReader.ReadString('Correo','Usuario','');
     edHost.Text:=      IniReader.ReadString('Correo','Host','');
     edClave.Text:=     FLX_IniReadPassword(IniReader, 'Correo', 'Clave', '');
     edPuerto.Text:=    IniReader.ReadString('Correo','Puerto','');

         //----------------- VeriFactu -----------------------------
     Edit71.Text:=      IniReader.ReadString('VeriFactu','vfUrl','');
     Edit72.Text:=      IniReader.ReadString('VeriFactu','vfUrlTP','');
     Edit73.Text:=      IniReader.ReadString('VeriFactu','vfUrlTLocal','');
     vfMode:=           IniReader.ReadString('VeriFactu','vfMode','');
     AplicarDefaultsVeriFactuEnBlanco;
     vfCheckTest.Checked := (vfMode='PRUEBAS');
     // if vfMode = 'PRUEBAS' then vfCheckTest.Checked:= True else vfCheckTest.Checked:=False;

     tmpBoolean:=  IniReader.ReadString('Correo','SSL','');
     if tmpBoolean='' then cbSSL.Checked:=True else cbSSL.Checked:= StrToBool(IniReader.ReadString('Correo','SSL',''));

     tmpBoolean:=  IniReader.ReadString('Correo','TLS','');
     if tmpBoolean='' then cbTLS.Checked:=True else cbTLS.Checked:= StrToBool(IniReader.ReadString('Correo','TLS',''));

//     cbSSL.Checked:=    StrToBool(IniReader.ReadString('Correo','SSL',''));
//     cbTLS.Checked:=    StrToBool(IniReader.ReadString('Correo','TLS',''));


        //---------- Sistema de copia automática MONO-USUARIO
        tmpBoolean:=         IniReader.ReadString('bbdd_copy','MonoUsuario','');
        if tmpBoolean='' then bbdd_autocopy.Checked:=True else bbdd_autocopy.Checked:=StrToBool(IniReader.ReadString('bbdd_copy','MonoUsuario',''));

        CargarConfiguracionBackupRemotoPersistente;

     CBMbbdd.Text := IniReader.ReadString('MotorBBDD','mbbdd','');

end;

//Procedure para guardar los valores del fichero INI
procedure TFConfig.GuardarIni();
var
  LIni: TIniFile;
begin
  { No se escribe nunca sobre el IniReader que lleva abierto desde que se
    mostró el formulario. Se abre una copia nueva del fichero existente,
    se actualizan únicamente las claves conocidas y se conservan todas las
    demás secciones y claves. }
  FLXCreateFacturConfBackup;
  LIni := FLXOpenFacturConfIni;
  try
    CargaValoresEnIniReader(LIni);
    LIni.UpdateFile;
  finally
    LIni.Free;
  end;

  { Sincronizar el lector del formulario con lo que realmente quedó en disco. }
  RecargarIniReaderDesdeDisco;

  //---- Desactivamos botones ---
  BitBtn1.Enabled := False;
  BitBtn2.Enabled := False;
  CargaValoresIniReaderEnVariables(IniReader);
  FLXAplicarTemaEnFormulariosAbiertos;
end;

//============== LOGO DE LA EMPRESA ==================
procedure TFConfig.Edit57Exit(Sender: TObject);
begin
  if Edit57.Text='' then
    begin
      Image1.Picture:=Nil; Image1.Refresh;
    end;
  if FileExists(Edit57.Text) then
    Image1.Picture.LoadFromFile(Edit57.Text)
  else
    begin
     Image1.Picture:=Nil; Image1.Refresh;
    end;
end;

procedure TFConfig.EditCambiableCodigo1Change(Sender: TObject);
begin
  if BitBtn1.Enabled=True then exit;
  EditCambiableCodigo2.Text:='';
  StaticTextCambiableNombre2.Caption:='';
  BitBtn1.Enabled := True;
  BitBtn2.Enabled := True;
end;

procedure TFConfig.EditCambiableCodigo1Enter(Sender: TObject);
begin
   StaticTextCambiableNombre1.Caption:='';
end;

procedure TFConfig.EditCambiableCodigo1Exit(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT T1 FROM tiendas WHERE T0="'+EditCambiableCodigo1.Text+'"';
  if EditCambiableCodigo1.Text<>'' then
    begin
      RellenaPanelCambiableN(TxtQuery, dbCambiable1, StaticTextCambiableNombre1);
      if dbCambiable1.RecordCount=0 then
       begin
         Showmessage('NO HAY '+LabelCambiable1.Caption+' CON ESE CODIGO');
         EditCambiableCodigo1.Text:='';
         exit;
       end;
   end;
end;

procedure TFConfig.EditCambiableCodigo2Enter(Sender: TObject);
begin
   StaticTextCambiableNombre2.Caption:='';
end;

procedure TFConfig.EditCambiableCodigo2Exit(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT PT1 FROM puestos'+tienda+' WHERE PT0="'+EditCambiableCodigo2.Text+'"';
  if EditCambiableCodigo2.Text<>'' then
    begin
      RellenaPanelCambiableN(TxtQuery, dbCambiable2, StaticTextCambiableNombre2);
      if dbCambiable2.RecordCount=0 then
       begin
         Showmessage('NO HAY '+LabelCambiable2.Caption+' CON ESE CODIGO');
         EditCambiableCodigo2.Text:='';
         exit;
       end;
   end;
end;

procedure TFConfig.BitBtn12Click(Sender: TObject);
begin
 if OpenPictureDialog1.Execute then
   begin
     Edit57.Text:=OpenPictureDialog1.FileName;
     if FileExists(OpenPictureDialog1.FileName) then
       Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName)
   end;
end;

procedure TFConfig.bbdd_autocopyChange(Sender: TObject);
begin
 ActualizarEstadoBackupRemoto;
 if BitBtn1.Enabled=True then exit;
 BitBtn1.Enabled := True;
 BitBtn2.Enabled := True;
end;

//==================== Visor Informes PDF ====================
procedure TFConfig.BitBtn13Click(Sender: TObject);
begin
 if OpenDialog2.Execute then
   begin
     Edit58.Text:=OpenDialog2.FileName;
     //if not FileExists(OpenDialog1.FileName) then
   end;
end;
//==================== Carpeta Informes PDF ====================
procedure TFConfig.BitBtn14Click(Sender: TObject);
begin
 if SelectDirectoryDialog1.Execute then
   begin
     Edit59.Text:=SelectDirectoryDialog1.FileName;
     //if not DirectoryExists(SelectDirectoryDialog1.FileName) then
   end;
end;
//==================== Carpeta Imagenes ====================
procedure TFConfig.BitBtn15Click(Sender: TObject);
begin
 if SelectDirectoryDialog1.Execute then
   begin
     Edit69.Text:=SelectDirectoryDialog1.FileName;
     //if not DirectoryExists(SelectDirectoryDialog1.FileName) then
   end;
end;

//============= GUARDAR DATOS =====================
procedure TFConfig.BitBtn1Click(Sender: TObject);
begin
  GuardarIni();
  BitBtn1.Enabled := False;
  BitBtn2.Enabled := False;
end;

//============= RECUPERAR DATOS ===================
procedure TFConfig.BitBtn2Click(Sender: TObject);
begin
  RestaurarIni();
  BitBtn1.Enabled := False;
  BitBtn2.Enabled := False;
end;

//============= APLICAR CAMBIOS ===================
procedure TFConfig.BitBtn6Click(Sender: TObject);
begin
  CargaValoresEnGlobales();
end;

procedure TFConfig.BitBtn7Click(Sender: TObject);
begin
  if ColorDialog1.Execute=true then Edit67.Text:=ColorToString(ColorDialog1.Color);
end;

procedure TFConfig.BitBtn8Click(Sender: TObject);
begin
  if ColorDialog1.Execute=true then Edit68.Text:=ColorToString(ColorDialog1.Color);
end;


//=============== SI CAMBIA ALGUN DATO ============
procedure TFConfig.Edit1Change(Sender: TObject);
begin
  if IniForm=True then
    begin
       IniForm:=False;
       exit;
    end;
  if BitBtn1.Enabled=True then exit;
  BitBtn1.Enabled := True;
  BitBtn2.Enabled := True;
end;

//=============== Si cambia algún dato de VeriFactu ============
procedure TFConfig.VeriFactuChange(Sender: TObject);
begin
  // No tocamos IniForm aquí. Este evento se asigna después de RestaurarIni,
  // así evitamos que la carga inicial active Guardar/Recuperar.
  if BitBtn1.Enabled=True then exit;
  BitBtn1.Enabled := True;
  BitBtn2.Enabled := True;
end;

//=============== Cambio en la activación de las copias de seguridad programadas =========
procedure TFConfig.cbCopia1Change(Sender: TObject);
begin
   label125.Enabled:=cbCopia1.Checked;
   label126.Enabled:=cbCopia1.Checked;
   label127.Enabled:=cbCopia1.Checked;
   label128.Enabled:=cbCopia1.Checked;
   label129.Enabled:=cbCopia1.Checked;
   label140.Enabled:=cbCopia1.Checked;
   label141.Enabled:=cbCopia1.Checked;

   Copia1InicioUD1.Enabled:=cbCopia1.Checked;
   Copia1InicioUD2.Enabled:=cbCopia1.Checked;
   Copia1FinUD1.Enabled:=cbCopia1.Checked;
   Copia1FinUD2.Enabled:=cbCopia1.Checked;

   Copia1InicioHora.Enabled:=cbCopia1.Checked;
   Copia1InicioMinutos.Enabled:=cbCopia1.Checked;
   Copia1FinHora.Enabled:=cbCopia1.Checked;
   Copia1FinMinutos.Enabled:=cbCopia1.Checked;
   Copia1Destino.Enabled:=cbCopia1.Checked;

   Edit1Change(self);

end;

procedure TFConfig.cbCopia2Change(Sender: TObject);
begin
   label130.Enabled:=cbCopia2.Checked;
   label131.Enabled:=cbCopia2.Checked;
   label132.Enabled:=cbCopia2.Checked;
   label133.Enabled:=cbCopia2.Checked;
   label134.Enabled:=cbCopia2.Checked;
   label142.Enabled:=cbCopia2.Checked;
   label143.Enabled:=cbCopia2.Checked;

   Copia2InicioUD1.Enabled:=cbCopia2.Checked;
   Copia2InicioUD2.Enabled:=cbCopia2.Checked;
   Copia2FinUD1.Enabled:=cbCopia2.Checked;
   Copia2FinUD2.Enabled:=cbCopia2.Checked;

   Copia2InicioHora.Enabled:=cbCopia2.Checked;
   Copia2InicioMinutos.Enabled:=cbCopia2.Checked;
   Copia2FinHora.Enabled:=cbCopia2.Checked;
   Copia2FinMinutos.Enabled:=cbCopia2.Checked;
   Copia2Destino.Enabled:=cbCopia2.Checked;

   Edit1Change(self);
end;

procedure TFConfig.cbCopia3Change(Sender: TObject);
begin
   label135.Enabled:=cbCopia3.Checked;
   label136.Enabled:=cbCopia3.Checked;
   label137.Enabled:=cbCopia3.Checked;
   label138.Enabled:=cbCopia3.Checked;
   label139.Enabled:=cbCopia3.Checked;
   label145.Enabled:=cbCopia3.Checked;
   label144.Enabled:=cbCopia3.Checked;

   Copia3InicioUD1.Enabled:=cbCopia3.Checked;
   Copia3InicioUD2.Enabled:=cbCopia3.Checked;
   Copia3FinUD1.Enabled:=cbCopia3.Checked;
   Copia3FinUD2.Enabled:=cbCopia3.Checked;

   Copia3InicioHora.Enabled:=cbCopia3.Checked;
   Copia3InicioMinutos.Enabled:=cbCopia3.Checked;
   Copia3FinHora.Enabled:=cbCopia3.Checked;
   Copia3FinMinutos.Enabled:=cbCopia3.Checked;
   Copia3Destino.Enabled:=cbCopia3.Checked;

   Edit1Change(self);
end;


procedure TFConfig.Edit60KeyPress(Sender: TObject; var Key: char);
begin
  if BitBtn1.Enabled=False then
   Begin
        BitBtn1.Enabled := True;
        BitBtn2.Enabled := True;
   end;
  if ( StrScan('SNsn',Key) <> nil ) or ( Key = Char(VK_BACK) ) or  ( Key = Char(VK_TAB) )
   or  ( Key = Char(VK_RETURN) ) or  ( Key = Char(VK_UP) ) or  ( Key = Char(VK_DOWN) ) then
    begin
         case Key of
          'S': ActivaArticulos();
          's': ActivaArticulos();
          'N': DesactivaArticulos();
          'n': DesactivaArticulos();
         end;
    end;
   if ( key = Char(VK_RETURN) ) then // -- En caso de pulsar enter, pasa al siguiente campo
     begin
          key:=#0;
          SelectNext(activecontrol,true,true);
     end;
end;

//=============== Activa/Desactiva Articulos ===============
procedure TFConfig.ActivaArticulos();
   begin
        If Application.MessageBox('SE VAN A ACTIVAR TODOS LOS ARTICULOS CON SISTEMA BASICO (1) DE PUNTOS','FacturLinEx', boxstyle) = IDNO Then Exit;
        dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A35="1" WHERE A0<>"9999999999999"';
        dbArti.ExecSQL;
   end;
procedure TFConfig.DesactivaArticulos();
   begin
        If Application.MessageBox('SE VA HA DESACTIVAR EL SISTEMA DE PUNTOS DE TODOS LOS ARTICULOS','FacturLinEx', boxstyle) = IDNO Then Exit;
        dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A35="0" WHERE A0<>"9999999999999"';
        dbArti.ExecSQL;
   end;

//============== GESTION DE IMPUESTOS ======================00
//============== GESTION DE IMPUESTOS ======================00
//============== GESTION DE IMPUESTOS ======================00
//============== GESTION DE IMPUESTOS ======================00
//============== GESTION DE IMPUESTOS ======================00
//============== GESTION DE IMPUESTOS ======================00
//============== GESTION DE IMPUESTOS ======================00
//============== GESTION DE IMPUESTOS ======================00
//============== GESTION DE IMPUESTOS ======================00
//============== GESTION DE IMPUESTOS ======================00
//============== GESTION DE IMPUESTOS ======================00

procedure TFConfig.Edit26KeyPress(Sender: TObject; var Key: char);
begin
  if BitBtn1.Enabled=False then
   Begin
        BitBtn1.Enabled := True;
        BitBtn2.Enabled := True;
   end;
  if ( StrScan('.012345679',Key) <> nil ) or ( Key = Char(VK_BACK) ) or  ( Key = Char(VK_TAB) )
   or  ( Key = Char(VK_RETURN) ) or  ( Key = Char(VK_UP) ) or  ( Key = Char(VK_DOWN) ) then
   begin

   end;
   if ( key = Char(VK_RETURN) ) then // -- En caso de pulsar enter, pasa al siguiente campo
     begin
          key:=#0;
          SelectNext(activecontrol,true,true);
     end;
end;

//--- Ivas
//--- Recargos de equivalencia

//=========== NUEVO PROCEDIMIENTO IMPUESTOS =============00
//=========== NUEVO PROCEDIMIENTO IMPUESTOS =============00
//=========== NUEVO PROCEDIMIENTO IMPUESTOS =============00
//=========== NUEVO PROCEDIMIENTO IMPUESTOS =============00

procedure TFConfig.Button1Click(Sender: TObject);
var
 tempiva : array [1..3] of string;
 newiva  : array [1..3] of string;
 tempre  : array [1..3] of string;
 newre   : array [1..3] of string;
 contiva : Integer;
 fechatmp: string;
begin
   fechatmp:=(FormatDateTime('YYYY-MM-DD',StrToDate(fechaiva.Text)));
   ShowMessage('OJO, SE RECOMIENDA HACER COPIA DE SEGURIDAD ANTES DE REALIZAR CAMBIOS MASIVOS EN LA BBDD');
   If Application.MessageBox('SE VA HA MODIFICAR EL IVA DE TODOS LOS ARTICULOS DE TIPO IVA1, IVA2 e IVA3 A LOS NUEVOS TIPOS DE IVA, ASÍ COMO LOS RE','FacturLinEx', boxstyle) = IDNO Then Exit;

   For contiva:=1 to 3 Do
    begin
     tempiva[contiva]:=IniReader.ReadString('Programa','IVA'+InttoStr(contiva),'');
     tempre[contiva]:=IniReader.ReadString('Programa','RIVA'+InttoStr(contiva),'');
     Case contiva of
      1 : begin newiva[contiva]:=Edit26.Text; newre[contiva]:=Edit29.Text; end;
      2 : begin newiva[contiva]:=Edit27.Text; newre[contiva]:=Edit30.Text; end;
      3 : begin newiva[contiva]:=Edit28.Text; newre[contiva]:=Edit31.Text; end;
      end;
     dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A3="'+newiva[contiva]+'" WHERE A3="'+tempiva[contiva]+'"';   //-- Cambia el IVA Tipos 1,2 y 3
     dbArti.ExecSQL;
     dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A36="'+newre[contiva]+'" WHERE A36="'+tempre[contiva]+'"';   //-- Cambia el RE
     dbArti.ExecSQL;
    end;


     Case CambioIVA.ItemIndex OF
      //Solo varía el IVA, mantiene PVP (SE ASUME LA SUBIDA DEL IVA, NO CAMBIA EL PVP)
          0 :  begin
                 If ficherosiva.Checked[0]=True then // CAMBIA ARTICULOS, EXCLUIDO DEL BUCLE FOR, PARA AHORRAR TIEMPO DE PROCESO.
                   begin
                     //--- ARTICULOS
                     //--- ARTICULOS (PARTE 1, EXLUIDA DEL BUCLE FOR)
                     ShowMessage('ESTA OPERACIÓN, VARIARÁ EL PRECIO DE VENTA SIN IMPUESTOS DE LOS ARTICULOS');
                     dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A26=((A2-(A24*(1+((A3+A36)/100))))*100)/(A24*(1+((A3+A36)/100)))';   //-- Cambia el Margen
                     dbArti.ExecSQL;
                     dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A37=((((A24*(1+((A3+A36)/100)))/A2) - 1) * -100)';   //-- Cambia el Margen Sobre la Venta
                     dbArti.ExecSQL;
                     dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A21=(A2/(1+(A3/100)))';   //-- Cambia el Precio sin IVA y sin recargo, vamos, sin impuestos
                     dbArti.ExecSQL;
                     //--- CAMBIA RECARGO DE EQUIVALENCIA
                     dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A26=((A2-(A24*(1+((A3+A36)/100))))*100)/(A24*(1+((A3+A36)/100)))';   //-- Cambia el Margen
                     dbArti.ExecSQL;
                     dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A37=((((A24*(1+((A3+A36)/100)))/A2) - 1) * -100)';   //-- Cambia el Margen Sobre la Venta
                     dbArti.ExecSQL;
                     dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A21=(A2/(1+(A3/100)))';   //-- Cambia el Precio sin IVA y sin recargo, vamos, sin impuestos
                     dbArti.ExecSQL;
                    end;
                   For contiva:=1 to 3 Do
                     begin
                       If ficherosiva.Checked[0]=True then
                         begin
                          //--- TARIFAS     (LAS TARIFAS VAN EN FUNCIÓN DEL IVA)
                                          // (Falta RECALCULAR EL MARGEN en función del nuevo Precio SIN IVA)
                           //--- ARTICULOS (PARTE 2, INCLUIDA EN BUCLE FOR)
                           //--- TARIFAS (LAS TARIFAS VAN EN FUNCIÓN DEL IVA1, IVA2 e IVA3)
                          dbArti.SQL.Text:='UPDATE tarifas SET TAR2=(TAR7/(1+('+newiva[contiva]+'/100))) where round((((TAR7-TAR2)*100)/TAR2),0)="'+tempiva[contiva]+'"';   //-- Cambia el PVenta SIN IVA ajustandolo al nuevo IVA
                          dbArti.ExecSQL;
                          dbArti.SQL.Text:='UPDATE tarifas SET TAR4=(TAR8/(1+('+newiva[contiva]+'/100))) where round((((TAR8-TAR4)*100)/TAR4),0)="'+tempiva[contiva]+'"';   //-- Cambia el PVenta SIN IVA ajustandolo al nuevo IVA
                          dbArti.ExecSQL;
                          dbArti.SQL.Text:='UPDATE tarifas SET TAR6=(TAR9/(1+('+newiva[contiva]+'/100))) where round((((TAR9-TAR6)*100)/TAR6),0)="'+tempiva[contiva]+'"';   //-- Cambia el PVenta SIN IVA ajustandolo al nuevo IVA
                          dbArti.ExecSQL;
                         end;
                       If ficherosiva.Checked[1]=True then
                         begin
                          //--- VENTAS0000A,B Y C
                          dbArti.SQL.Text:='UPDATE ventas'+Tienda+'A SET V10="'+newiva[contiva]+'" where V10="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                          dbArti.ExecSQL;
                          dbArti.SQL.Text:='UPDATE ventas'+Tienda+'A SET V7=(V6/(1+(V10/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                          dbArti.ExecSQL;
                          dbArti.SQL.Text:='UPDATE ventas'+Tienda+'A SET V9=(V11/(1+(V10/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                          dbArti.ExecSQL;
                          dbArti.SQL.Text:='UPDATE ventas'+Tienda+'B SET V10="'+newiva[contiva]+'" where V10="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                          dbArti.ExecSQL;
                          dbArti.SQL.Text:='UPDATE ventas'+Tienda+'B SET V7=(V6/(1+(V10/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                          dbArti.ExecSQL;
                          dbArti.SQL.Text:='UPDATE ventas'+Tienda+'B SET V9=(V11/(1+(V10/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                          dbArti.ExecSQL;
                          dbArti.SQL.Text:='UPDATE ventas'+Tienda+'C SET V10="'+newiva[contiva]+'" where V10="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                          dbArti.ExecSQL;
                          dbArti.SQL.Text:='UPDATE ventas'+Tienda+'C SET V7=(V6/(1+(V10/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                          dbArti.ExecSQL;
                          dbArti.SQL.Text:='UPDATE ventas'+Tienda+'C SET V9=(V11/(1+(V10/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                          dbArti.ExecSQL;
                         end;
                       If ficherosiva.Checked[2]=True then
                         begin
                           //--- PRESUC
                           dbArti.SQL.Text:='UPDATE presuc'+Tienda+' SET PRC8=(PRC9/(1+('+newiva[contiva]+'/100))) where (((PRC9-PRC8)*100)/PRC8)="'+tempiva[contiva]+'"';   //-- Cambia el PVP ajustandolo al nuevo IVA
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE presuc'+Tienda+' SET PRC1="'+fechatmp+'" WHERE PRC1<"'+fechatmp+'"';   //-- Cambia la fecha del Presupuesto
                           dbArti.ExecSQL;
                           //--- PRESUD
                           dbArti.SQL.Text:='UPDATE presud'+Tienda+' SET PRD12="'+newiva[contiva]+'" where PRD12="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE presud'+Tienda+' SET PRD9=(PRD8/(1+(PRD12/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE presud'+Tienda+' SET PRD11=(PRD13/(1+(PRD12/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA Total LINEA
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE presud'+Tienda+' SET PRD1="'+fechatmp+'" WHERE PRD1<"'+fechatmp+'"';   //-- Cambia la fecha del Presupuesto
                           dbArti.ExecSQL;
                         end;
                       If ficherosiva.Checked[3]=True then
                         begin
                           //--- ALBAC
                           dbArti.SQL.Text:='UPDATE albac'+Tienda+' SET AC8=(AC9/(1+('+newiva[contiva]+'/100))) where AC1>"'+fechatmp+'" and (((AC9-AC8)*100)/AC8)="'+tempiva[contiva]+'"';   //-- Cambia el PVP ajustandolo al nuevo IVA
                           dbArti.ExecSQL;
                           //--- ALBAD
                           dbArti.SQL.Text:='UPDATE albad'+Tienda+' SET AD12="'+newiva[contiva]+'" where AD1>"'+fechatmp+'" and AD12="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE albad'+Tienda+' SET AD9=(AD8/(1+(AD12/100))) where AD1>"'+fechatmp+'"';   //-- Cambia el PVP ajustandolo al nuevo IVA
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE albad'+Tienda+' SET AD11=(AD13/(1+(AD12/100))) where AD1>"'+fechatmp+'"';   //-- Cambia el PVP ajustandolo al nuevo IVA
                           dbArti.ExecSQL;
                         end;
                       If ficherosiva.Checked[4]=True then
                         begin
                           //--- FACTURAS
                          If contiva=1 then
                          begin
                           If Application.MessageBox('OJO, ESTE PROCESO PODRÍA NO SER DEL TODO LEGAL, DADO QUE ESTÁ PROHIBIDO MODIFICAR UNA FACTURA REALIZADA','FacturLinEx', boxstyle) = IDyes Then
                             begin
                               ShowMessage('ESTE PROCESO AÚN NO ESTÁ IMPLEMENTADO, Disculpe las molestias');
                             end;
                          end;
                         end;
                       If ficherosiva.Checked[5]=True then
                         begin
                           //--- PROFORC
                           dbArti.SQL.Text:='UPDATE proforc'+Tienda+' SET PRC8=(PRC9/(1+('+newiva[contiva]+'/100))) where (((PRC9-PRC8)*100)/PRC8)="'+tempiva[contiva]+'"';   //-- Cambia el PVP ajustandolo al nuevo IVA
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE proforc'+Tienda+' SET PRC1="'+fechatmp+'" WHERE PRC1<"'+fechatmp+'"';   //-- Cambia la fecha del Presupuesto
                           dbArti.ExecSQL;
                           //--- PROFORD
                           dbArti.SQL.Text:='UPDATE proford'+Tienda+' SET PRD12="'+newiva[contiva]+'" where PRD12="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE proford'+Tienda+' SET PRD9=(PRD8/(1+(PRD12/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE proford'+Tienda+' SET PRD11=(PRD13/(1+(PRD12/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA Total LINEA
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE proford'+Tienda+' SET PRD1="'+fechatmp+'" WHERE PRD1<"'+fechatmp+'"';   //-- Cambia la fecha del Presupuesto
                           dbArti.ExecSQL;
                         end;
                       If ficherosiva.Checked[6]=True then
                         begin
                           //--- LOTESCC  (Falta actualizar el Margen)
                           dbArti.SQL.Text:='UPDATE lotescc'+Tienda+' SET PROC5="'+newiva[contiva]+'" where PROC5="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE lotescc'+Tienda+' SET PROC4=(PROC6/(1+(PROC5/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE lotescc'+Tienda+' SET PROC3=(((PROC6-(PROC2*(1+(PROC5/100))))/(PROC2*(1+(PROC5/100))))*100)'; //-- Cambia el Margen
                           dbArti.ExecSQL;
                         end;
                       If ficherosiva.Checked[7]=True then
                         begin
                           //--- PEDIDD (Falta Calcular el Margen)
                           dbArti.SQL.Text:='UPDATE pedidd'+Tienda+' SET PD14="'+newiva[contiva]+'" where PD1>"'+fechatmp+'" and PD14="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE pedidd'+Tienda+' SET PD12=(PD16/(1+(PD14/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE pedidd'+Tienda+' SET PD15=(PD10*(1+((PD14+PD13)/100)))';   //-- Cambia el PCOSTE con IMPUESTOS
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE pedidd'+Tienda+' SET PD17=(PD8*PD15)';   //-- Total Linea a Precio de Coste CON IMPUESTOS
                           dbArti.ExecSQL;
                           dbArti.SQL.Text:='UPDATE pedidd'+Tienda+' SET PD11=((PD16-PD15)/PD15)'; //-- Cambia el Margen
                           dbArti.ExecSQL;
                         end;

                     end; // End del FOR

                     showmessage('LOS PVP E IMPORTES CONTINUAN SIENDO LOS MISMOS, SE HA ACTUALIZADO EL NUEVO IVA');

               end;
////////////////////////////////////////////////////////////
//********************************************************//
//**********FALTA AÑADIR EL CONTROL DE FECHA**************//
//********************************************************//
////////////////////////////////////////////////////////////
      //Varia el PVP, mantiene el NETO
          1 :  begin
                  If ficherosiva.Checked[0]=True then // CAMBIA ARTICULOS, EXCLUIDO DEL BUCLE FOR, PARA AHORRAR TIEMPO DE PROCESO.
                  begin
                    //--- ARTICULOS (PARTE 1, EXLUIDA DEL BUCLE FOR)
                    ShowMessage('ESTA OPERACIÓN, VARIARÁ EL PRECIO DE VENTA A PUBLICO, "PVP", DE LOS ARTICULOS, ASÍ COMO LAS TARIFAS');
                    dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A2=(A21*(1+(A3/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                    //--- CAMBIA EL RECARGO DE EQUIVALENCIA
                    dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A2=(A21*(1+(A3/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                  End;
               For contiva:=1 to 3 Do
                begin
                  If ficherosiva.Checked[0]=True then
                  begin
                   //--- ARTICULOS (PARTE 2, INCLUIDA EN BUCLE FOR)
                   //--- TARIFAS (LAS TARIFAS VAN EN FUNCIÓN DEL IVA1, IVA2 e IVA3)

                   dbArti.SQL.Text:='UPDATE tarifas SET TAR7=(TAR2*(1+('+newiva[contiva]+'/100))) where round((((TAR7-TAR2)*100)/TAR2),0)="'+tempiva[contiva]+'"';   //-- Cambia el PVP ajustandolo al nuevo IVA
                   dbArti.ExecSQL;
                   dbArti.SQL.Text:='UPDATE tarifas SET TAR8=(TAR4*(1+('+newiva[contiva]+'/100))) where round((((TAR8-TAR4)*100)/TAR4),0)="'+tempiva[contiva]+'"';   //-- Cambia el PVP ajustandolo al nuevo IVA
                   dbArti.ExecSQL;
                   dbArti.SQL.Text:='UPDATE tarifas SET TAR9=(TAR6*(1+('+newiva[contiva]+'/100))) where round((((TAR9-TAR6)*100)/TAR6),0)="'+tempiva[contiva]+'"';   //-- Cambia el PVP ajustandolo al nuevo IVA
                   dbArti.ExecSQL;
                  end;
                  If ficherosiva.Checked[1]=True then
                  begin
                     //--- VENTAS0000A,B Y C
                    dbArti.SQL.Text:='UPDATE ventas'+Tienda+'A SET V10="'+newiva[contiva]+'" where V10="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE ventas'+Tienda+'A SET V6=(V7*(1+(V10/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE ventas'+Tienda+'A SET V11=(V9*(1+(V10/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE ventas'+Tienda+'B SET V10="'+newiva[contiva]+'" where V10="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE ventas'+Tienda+'B SET V6=(V7*(1+(V10/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE ventas'+Tienda+'B SET V11=(V9*(1+(V10/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE ventas'+Tienda+'C SET V10="'+newiva[contiva]+'" where V10="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE ventas'+Tienda+'C SET V6=(V7*(1+(V10/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE ventas'+Tienda+'C SET V11=(V9*(1+(V10/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                 end;
                  If ficherosiva.Checked[2]=True then
                  begin
                     //--- PRESUC (NO SE ACTUALIZAN LAS CABECERAS)
                    dbArti.SQL.Text:='UPDATE presuc'+Tienda+' SET PRC9=(PRC8*(1+('+newiva[contiva]+'/100))) where (((PRC9-PRC8)*100)/PRC8)="'+tempiva[contiva]+'"';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE presuc'+Tienda+' SET PRC1="'+fechatmp+'" WHERE PRC1<"'+fechatmp+'"';   //-- Cambia la fecha del Presupuesto
                    dbArti.ExecSQL;
                    //--- PRESUD
                    dbArti.SQL.Text:='UPDATE presud'+Tienda+' SET PRD12="'+newiva[contiva]+'" where PRD12="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE presud'+Tienda+' SET PRD8=(PRD9*(1+(PRD12/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE presud'+Tienda+' SET PRD13=(PRD11*(1+(PRD12/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA Total LINEA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE presud'+Tienda+' SET PRD1="'+fechatmp+'" WHERE PRD1<"'+fechatmp+'"';   //-- Cambia la fecha del Presupuesto
                    dbArti.ExecSQL;
                 end;
                  If ficherosiva.Checked[3]=True then
                  begin
                    //--- ALBAC
                    dbArti.SQL.Text:='UPDATE albac'+Tienda+' SET AC9=(AC8*(1+('+newiva[contiva]+'/100))) where AC1>"'+fechatmp+'" and (((AC9-AC8)*100)/AC8)="'+tempiva[contiva]+'"';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                    //--- ALBAD
                    dbArti.SQL.Text:='UPDATE albad'+Tienda+' SET AD12="'+newiva[contiva]+'" where AD1>"'+fechatmp+'" and AD12="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE albad'+Tienda+' SET AD8=(AD9*(1+(AD12/100))) where AD1>"'+fechatmp+'"';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE albad'+Tienda+' SET AD13=(AD11*(1+(AD12/100))) where AD1>"'+fechatmp+'"';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                  end;
                  If ficherosiva.Checked[4]=True then
                  begin
                    //--- FACTURAS
                   If contiva=1 then
                   begin
                    If Application.MessageBox('OJO, ESTE PROCESO PODRÍA NO SER DEL TODO LEGAL, DADO QUE ESTÁ PROHIBIDO MODIFICAR UNA FACTURA REALIZADA','FacturLinEx', boxstyle) = IDyes Then
                        begin
                          ShowMessage('ESTE PROCESO AÚN NO ESTÁ IMPLEMENTADO, Disculpe las molestias');
                        end;
                   end;
                  end;
                  If ficherosiva.Checked[5]=True then
                  begin
                    //--- PROFORC (NO SE ACTUALIZAN LAS CABECERAS)
                    dbArti.SQL.Text:='UPDATE proforc'+Tienda+' SET PRC9=(PRC8*(1+('+newiva[contiva]+'/100))) where (((PRC9-PRC8)*100)/PRC8)="'+tempiva[contiva]+'"';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE proforc'+Tienda+' SET PRC1="'+fechatmp+'" WHERE PRC1<"'+fechatmp+'"';   //-- Cambia la fecha del Presupuesto
                    dbArti.ExecSQL;
                    //--- PROFORD
                    dbArti.SQL.Text:='UPDATE proford'+Tienda+' SET PRD12="'+newiva[contiva]+'" where PRD12="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE proford'+Tienda+' SET PRD8=(PRD9*(1+(PRD12/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE proford'+Tienda+' SET PRD13=(PRD11*(1+(PRD12/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA Total LINEA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE proford'+Tienda+' SET PRD1="'+fechatmp+'" WHERE PRD1<"'+fechatmp+'"';   //-- Cambia la fecha del Presupuesto
                    dbArti.ExecSQL;
                  end;
                  If ficherosiva.Checked[6]=True then
                  begin
                    //--- LOTESCC
                    dbArti.SQL.Text:='UPDATE lotescc'+Tienda+' SET PROC5="'+newiva[contiva]+'" where PROC5="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE lotescc'+Tienda+' SET PROC6=(PROC4*(1+(PROC5/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                  end;
                  If ficherosiva.Checked[7]=True then
                  begin
                    //--- PEDIDD
                    dbArti.SQL.Text:='UPDATE pedidd'+Tienda+' SET PD14="'+newiva[contiva]+'" where PD1>"'+fechatmp+'" and PD14="'+tempiva[contiva]+'"';   //-- Cambia el IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE pedidd'+Tienda+' SET PD16=(PD12*(1+(PD14/100)))';   //-- Cambia el PVP ajustandolo al nuevo IVA
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE pedidd'+Tienda+' SET PD15=(PD10*(1+((PD14+PD13)/100)))';   //-- Cambia el PCOSTE con IMPUESTOS
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE pedidd'+Tienda+' SET PD17=(PD8*PD15)';   //-- Total Linea a Precio de Coste CON IMPUESTOS
                    dbArti.ExecSQL;
                    dbArti.SQL.Text:='UPDATE pedidd'+Tienda+' SET PD18=(PD8*PD16)';   //-- Cambia TOTAL Linea a PVP
                    dbArti.ExecSQL;
                  end;
                end;


                showmessage('SE HAN ACTUALIZADO TODOS LOS PVP AL NUEVO IVA, LAS CABECERAS SE ACTUALIZAN AL ENTRAR Y SALIR DEL DOCUMENTO');

               end;
                    /////////////////////////////////////

     end;

     BitBtn1.Click;
     BitBtn6.Click;
end;

//=========== FIN APARTADO IMPUESTOS =============00
//=========== FIN APARTADO IMPUESTOS =============00
//=========== FIN APARTADO IMPUESTOS =============00
//=========== FIN APARTADO IMPUESTOS =============00
//=========== FIN APARTADO IMPUESTOS =============00



//=========== PESTAÑA DE CONFIGURACIÓN GENERAL =============

procedure TFConfig.ComboBox1Change(Sender: TObject);
begin
    if BitBtn1.Enabled=False then
   Begin
        BitBtn1.Enabled := True;
        BitBtn2.Enabled := True;
   end;
end;

procedure TFConfig.Edit64KeyPress(Sender: TObject; var Key: char);
begin
  if BitBtn1.Enabled=False then
   Begin
        BitBtn1.Enabled := True;
        BitBtn2.Enabled := True;
   end;
   if ( key = Char(VK_RETURN) ) then // -- En caso de pulsar enter, pasa al siguiente campo
     begin
          key:=#0;
          SelectNext(activecontrol,true,true);
     end;
end;

procedure TFConfig.Edit70Change(Sender: TObject);
begin
   if BitBtn1.Enabled=True then exit;
   BitBtn1.Enabled := True;
   BitBtn2.Enabled := True;
end;

   //  No puede haber previsualización si se imprime por ticketera

procedure TFConfig.ComboBox14Change(Sender: TObject);
begin
  if (ComboBox14.ItemIndex=0) and (ComboBox15.ItemIndex=0) then ComboBox14.ItemIndex:=1;
  ComboBox1Change(Self);
end;

procedure TFConfig.ComboBox17Change(Sender: TObject);
begin
  if (ComboBox17.ItemIndex=0) and (ComboBox18.ItemIndex=0) then ComboBox17.ItemIndex:=1;
  ComboBox1Change(Self);
end;

procedure TFConfig.ComboBox19Change(Sender: TObject);
begin
if (ComboBox19.ItemIndex=0) and (ComboBox20.ItemIndex=0) then ComboBox19.ItemIndex:=1;
   ComboBox1Change(Self)
end;

//=============== COMPROBAR CONEXION ===============
procedure TFConfig.BitBtn4Click(Sender: TObject);
begin
  BitBtn4.cursor := crSQLWait;
  datamodule1.dbConexion.Connected:=False;
  datamodule1.dbConexion.HostName:=Edit11.Text;
  datamodule1.dbConexion.User:=Edit12.Text;
  datamodule1.dbConexion.Password:=Edit13.Text;
  datamodule1.dbConexion.Database:=Edit14.Text;
  datamodule1.dbConexion.Port:=StrToInt(Edit15.Text);
  datamodule1.dbConexion.Protocol:=Combo1.Text;
  Try
    datamodule1.dbConexion.Connected:=True;
    ShowMessage('Conexion realizada con exito');
    BitBtn4.Cursor := crDefault;
    datamodule1.dbConexion.Connected:=False;
  Except
    ShowMessage('La conexion NO tuvo exito, revise los datos!');
    BitBtn4.Cursor := crDefault;
  End
end;

//=============== COMPROBAR CONEXION SICLinEx ===============
procedure TFConfig.BitBtn5Click(Sender: TObject);
begin
  BitBtn5.cursor := crSQLWait;
  datamodule1.dbConexion.Connected:=False;
  datamodule1.dbConexion.HostName:=Edit21.Text;
  datamodule1.dbConexion.User:=Edit22.Text;
  datamodule1.dbConexion.Password:=Edit23.Text;
  datamodule1.dbConexion.Database:=Edit24.Text;
  datamodule1.dbConexion.Port:=StrToInt(Edit25.Text);
  datamodule1.dbConexion.Protocol:=Combo2.Text;
  Try
    datamodule1.dbConexion.Connected:=True;
    ShowMessage('Conexion SicLinEx realizada con exito');
    BitBtn5.Cursor := crDefault;
    datamodule1.dbConexion.Connected:=False;
  Except
    ShowMessage('La conexion SicLinEx NO tuvo exito, revise los datos!');
    BitBtn5.Cursor := crDefault;
  End
end;

procedure TFConfig.BitBtnCambiable1Click(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT T0, T1 FROM tiendas ORDER BY T1';
  CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre1, dbCambiable1, LabelCambiable1);
end;

procedure TFConfig.BitBtnCambiable2Click(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT PT0, PT1 FROM puestos'+tienda+' ORDER BY PT1';
  CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre2, dbCambiable2, LabelCambiable2);

end;

procedure TFConfig.btnValidarCopiasAutomaticasClick(Sender: TObject);
begin
  // Procedimiento para validar las opciones introducidas para las copias automáticas
  Edit1Change(Self);
end;

//============= ACTIVAR / DESACTIVAR SIC ==============
procedure TFConfig.CheckBox1Change(Sender: TObject);
begin
  Edit1Change(Edit1);
  if CheckBox1.Checked=true then
    begin
     Edit21.Enabled:=True; Edit22.Enabled:=True; Edit23.Enabled:=True;
     Edit24.Enabled:=True; Edit25.Enabled:=True; Combo2.Enabled:=True;
     BitBtn5.Enabled:=True;
    end
  else
    begin
     Edit21.Enabled:=False; Edit22.Enabled:=False; Edit23.Enabled:=False;
     Edit24.Enabled:=False; Edit25.Enabled:=False; Combo2.Enabled:=False;
     BitBtn5.Enabled:=False;
    end;
  ActualizarBotonesConexionVisual;
end;

procedure TFConfig.ComboCambiableNombre1Click(Sender: TObject);
var TxtCampo: string;
begin
  TxtCampo:='T1';
  EscogeNombreComboCambiable( TxtCampo, ComboCambiableNombre1, dbCambiable1, EditCambiableCodigo1, StaticTextCambiableNombre1)
end;

procedure TFConfig.ComboCambiableNombre1KeyPress(Sender: TObject; var Key: char
  );
begin
  if key=#13 then ComboCambiableNombre1Click(ComboCambiableNombre1);
end;

procedure TFConfig.ComboCambiableNombre2Click(Sender: TObject);
var TxtCampo: string;
begin
  TxtCampo:='PT1';
  EscogeNombreComboCambiable( TxtCampo, ComboCambiableNombre2, dbCambiable2, EditCambiableCodigo2, StaticTextCambiableNombre2)
end;

procedure TFConfig.ComboCambiableNombre2KeyPress(Sender: TObject; var Key: char
  );
begin
  if key=#13 then ComboCambiableNombre2Click(ComboCambiableNombre2);
end;


initialization
  {$I config.lrs}

end.

