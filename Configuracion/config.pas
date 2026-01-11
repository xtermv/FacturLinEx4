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

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Inifiles,
  Process, ExtCtrls, Buttons, StdCtrls, ComCtrls, LCLType, ZConnection, ExtDlgs,
  EditBtn, ZDataset, db;

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
//---------------CARGA DE VALORES EN LAS VARIABLES
//Recoge los valores introducidos en la página y se cargan las variables Globales
procedure TFConfig.CargaValoresEnGlobales();
var
  contador: integer;
begin
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
    IniReader.WriteString('Correo','Clave',edClave.Text);
    IniReader.WriteString('Correo','Puerto',edPuerto.Text);
    IniReader.WriteString('Correo','SSL',BoolToStr(cbSSL.Checked));
    IniReader.WriteString('Correo','TLS',BoolToStr(cbTLS.Checked));


      //--------------- VeriFactu ---------------------
    IniReader.WriteString('VeriFactu','vfUrl',edit71.Text);
    IniReader.WriteString('VeriFactu','vfUrlTP',edit72.Text);
    IniReader.WriteString('VeriFactu','vfUrlTLocal',edit73.Text);
    if vfCheckTest.Checked then vfMode:='PRUEBAS' else vfMode:='PRODUCCION';
    IniReader.WriteString('VeriFactu','vfMode',vfMode);

      //---------- Sistema de copia automática MONO-USUARIO
    IniReader.WriteString('bbdd_copy','MonoUsuario',BoolToStr(bbdd_autocopy.Checked));

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

  IniReader := TIniFile.Create(RutaIni+'FacturConf.ini');

  Sections := TStringList.Create;
  IniReader.ReadSections( Sections );

  PageControl1.ActivePage := TabSheet1;
  RestaurarIni;

  LabelCambiable1.Caption:='Tienda Activa';
  LabelCambiable2.Caption:='Puesto';

  EditAbrirArchivo.Text:=AbrirAchivo;

  IniForm:=true;

  fechaiva.Date:=Date;

  lbIni.Caption:='Fichero de configuración en ' + RutaIni;
  lbBinario.Caption:='Sistema instalado en ' + RutaBin;
  lbSql.Caption:='Definición de la BBDD almacenada en ' + RutaSql;
  lbImagenes.Caption:='Imágenes guardadas en ' + RutaIconos;
  lbReport.Caption:='Plantillas de informes y documentos en ' + RutaReports ;
  lbModulos.Caption:='Módulos instalados en ' + RutaModulos;

  If rutaBin='/usr/bin/' then
       begin
        lbSistema.Font.Color:=clGreen;
        lbSistema.Caption:=' Sistema en producción ';

       end else
       begin
        lbSistema.Font.Color:=clMaroon;
        lbSistema.Caption:=' Sistema en desarrollo ';
       end;
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
     edClave.Text:=     IniReader.ReadString('Correo','Clave','');
     edPuerto.Text:=    IniReader.ReadString('Correo','Puerto','');

         //----------------- VeriFactu -----------------------------
     Edit71.Text:=      IniReader.ReadString('VeriFactu','vfUrl','');
     Edit72.Text:=      IniReader.ReadString('VeriFactu','vfUrlTP','');
     Edit73.Text:=      IniReader.ReadString('VeriFactu','vfUrlTLocal','');
     if IniReader.ReadString('VeriFactu','vfMode','')='PRUEBAS' then vfCheckTest.Checked:=true;
     vfMode:=           IniReader.ReadString('VeriFactu','vfMode','');
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

     CBMbbdd.Text := IniReader.ReadString('MotorBBDD','mbbdd','');

end;

//Procedure para guardar los valores del fichero INI
procedure TFConfig.GuardarIni();
begin
  CargaValoresEnIniReader(IniReader);

  //---- Guardar IniFile
  IniReader.UpdateFile;
  //---- Desactivamos botones ---
  BitBtn1.Enabled := False;
  BitBtn2.Enabled := False;
  CargaValoresIniReaderEnVariables(IniReader);
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

