{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010,

  Jose Belenguer.
  
  Nicolas Lopez de Lerma Aymerich
  PuntoDev GNU S.L. <info@puntodev.com>

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


unit acaja;

{$mode objfpc}{$H+}

interface

uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType, DBGrids,
  db, DbCtrls, EditBtn, LR_DBSet, LR_Class, ExtDlgs, Process, Types;


type

  { TFCaja }

  TFCaja = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn17: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn19: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn21: TBitBtn;
    BitBtn22: TBitBtn;
    BitBtn23: TBitBtn;
    BitBtn24: TBitBtn;
    BitBtn25: TBitBtn;
    BitBtn26: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    Button1: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Datasource1: TDatasource;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    DateEdit3: TDateEdit;
    DateEdit4: TDateEdit;
    DateEdit5: TDateEdit;
    DateEdit6: TDateEdit;
    DateEdit7: TDateEdit;
    dbACaja: TZQuery;
    dbCajas: TZQuery;
    DBGrid1: TDBGrid;
    DBGrid12: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
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
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label3variable: TLabel;
    Label3variable2: TLabel;
    Memo1: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    RadioButton1: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText100: TStaticText;
    StaticText101: TStaticText;
    StaticText102: TStaticText;
    StaticText103: TStaticText;
    StaticText104: TStaticText;
    StaticText105: TStaticText;
    StaticText106: TStaticText;
    StaticText107: TStaticText;
    StaticText108: TStaticText;
    StaticText109: TStaticText;
    StaticText11: TStaticText;
    StaticText110: TStaticText;
    StaticText111: TStaticText;
    StaticText113: TStaticText;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    StaticText14: TStaticText;
    StaticText15: TStaticText;
    StaticText16: TStaticText;
    StaticText17: TStaticText;
    StaticText18: TStaticText;
    StaticText19: TStaticText;
    StaticText2: TStaticText;
    StaticText20: TStaticText;
    StaticText21: TStaticText;
    StaticText22: TStaticText;
    StaticText23: TStaticText;
    StaticText24: TStaticText;
    StaticText25: TStaticText;
    StaticText26: TStaticText;
    StaticText27: TStaticText;
    StaticText28: TStaticText;
    StaticText29: TStaticText;
    StaticText3: TStaticText;
    StaticText30: TStaticText;
    StaticText31: TStaticText;
    StaticText32: TStaticText;
    StaticText33: TStaticText;
    StaticText34: TStaticText;
    StaticText35: TStaticText;
    StaticText36: TStaticText;
    StaticText37: TStaticText;
    StaticText38: TStaticText;
    StaticText39: TStaticText;
    StaticText4: TStaticText;
    StaticText40: TStaticText;
    StaticText41: TStaticText;
    StaticText42: TStaticText;
    StaticText43: TStaticText;
    StaticText44: TStaticText;
    StaticText45: TStaticText;
    StaticText46: TStaticText;
    StaticText47: TStaticText;
    StaticText48: TStaticText;
    StaticText49: TStaticText;
    StaticText5: TStaticText;
    StaticText50: TStaticText;
    StaticText51: TStaticText;
    StaticText52: TStaticText;
    StaticText53: TStaticText;
    StaticText54: TStaticText;
    StaticText55: TStaticText;
    StaticText56: TStaticText;
    StaticText57: TStaticText;
    StaticText58: TStaticText;
    StaticText59: TStaticText;
    StaticText6: TStaticText;
    StaticText60: TStaticText;
    StaticText61: TStaticText;
    StaticText62: TStaticText;
    StaticText63: TStaticText;
    StaticText64: TStaticText;
    StaticText65: TStaticText;
    StaticText66: TStaticText;
    StaticText67: TStaticText;
    StaticText68: TStaticText;
    StaticText69: TStaticText;
    StaticText7: TStaticText;
    StaticText70: TStaticText;
    StaticText71: TStaticText;
    StaticText72: TStaticText;
    StaticText73: TStaticText;
    StaticText74: TStaticText;
    StaticText75: TStaticText;
    StaticText76: TStaticText;
    StaticText77: TStaticText;
    StaticText78: TStaticText;
    StaticText79: TStaticText;
    StaticText8: TStaticText;
    StaticText80: TStaticText;
    StaticText81: TStaticText;
    StaticText82: TStaticText;
    StaticText83: TStaticText;
    StaticText84: TStaticText;
    StaticText85: TStaticText;
    StaticText86: TStaticText;
    StaticText87: TStaticText;
    StaticText88: TStaticText;
    StaticText89: TStaticText;
    StaticText9: TStaticText;
    StaticText90: TStaticText;
    StaticText91: TStaticText;
    StaticText92: TStaticText;
    StaticText93: TStaticText;
    StaticText94: TStaticText;
    StaticText95: TStaticText;
    StaticText96: TStaticText;
    StaticText97: TStaticText;
    StaticText98: TStaticText;
    StaticText99: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ZQPuesto: TZQuery;
    ZQTienda: TZQuery;
    ZQCaja: TZQuery;
    dbIva: TZQuery;
    dbCajaGlob: TZQuery;
    dbACajaGlob: TZQuery;
    dbIvaGlob: TZQuery;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn17Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn19Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure BitBtn23Click(Sender: TObject);
    procedure BitBtn24Click(Sender: TObject);
    procedure BitBtn25Click(Sender: TObject);
    procedure BitBtn26Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn22Click(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: char);
    procedure ComboBox2Click(Sender: TObject);
    procedure ComboBox2KeyPress(Sender: TObject; var Key: char);
    procedure ComboBox3Click(Sender: TObject);
    procedure ComboBox3KeyPress(Sender: TObject; var Key: char);
    procedure DateEdit1Change(Sender: TObject);
    procedure DateEdit2Change(Sender: TObject);
    procedure Edit10Exit(Sender: TObject);
    procedure Edit11Exit(Sender: TObject);
    procedure Edit12Exit(Sender: TObject);
    procedure Edit13Exit(Sender: TObject);
    procedure Edit14Exit(Sender: TObject);
    procedure Edit15Exit(Sender: TObject);
    procedure Edit16Exit(Sender: TObject);
    procedure Edit17Exit(Sender: TObject);
    procedure Edit17KeyPress(Sender: TObject; var Key: char);
//---    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Edit18Exit(Sender: TObject);
    procedure Edit19Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure Edit20Enter(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit6Exit(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
    procedure Edit8Exit(Sender: TObject);
    procedure Edit9Exit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure RadioButton1Click(Sender: TObject);

    procedure LimpiaForm();
    procedure Relleno();
    procedure RellenoInfo();
    procedure LlenaReg();
    procedure ICambio(const AImporte: Double);
    procedure CuentaCaja();

//    procedure keyloger(const monedas,cantidad: string);
    procedure keyloger(moneda,cantidad:string);

    function compruebatecla(key: char):char;
    function compruebateclanegativo(key: char):char;

    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StaticText95Click(Sender: TObject);
    procedure TabSheet2Enter(Sender: TObject);

    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
  private
    FPanelDiagnostico: TPanel;
    FDiagTitulo: TLabel;
    FDiagEfectivo: TLabel;
    FDiagTarjetas: TLabel;
    FDiagTotal: TLabel;
    FDiagCausa: TLabel;
    FDiagMovimientos: TLabel;
    FDiagQuery: TZQuery;
    FResumenMovimientos: String;
    procedure CrearPanelDiagnostico;
    procedure ActualizarPanelDiagnostico;
    procedure ActualizarResumenMovimientos;
    function ValorNumericoSeguro(const ATexto: String): Double;
    function TextoDiferencia(const AValor: Double): String;
    function SolicitarImporteCambio(const APropuesto, AExistente: Double;
      const AYaExiste: Boolean; out AImporte: Double): Boolean;
    procedure AplicarEstiloModernoSeguro;
    function SeleccionarFechaCaja(out AFecha: TDateTime): Boolean;
    { private declarations }
  public
    { public declarations }
  end;

  procedure ShowFormCaja;

Var
  FCaja: TFCaja;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;
  inicio: Boolean;
  Base1,Base2,Base3,Iva1,Iva2,Iva3,TIva1,TIva2,TIva3 : String;
  TBases,TIvas,VTTotal : String;
  Base1Glob,Base2Glob,Base3Glob,Iva1Glob,Iva2Glob,Iva3Glob,TIva1Glob,TIva2Glob,TIva3Glob : String;
  TBasesGlob,TIvasGlob,VTTotalGlob : String;
  Cambio,Billetes,Anterior : String;
  CambioGlob,BilletesGlob,AnteriorGlob : String;
  TBilletes, TCambio, TTalTarj, TCambioA : String;


Implementation

uses
  Global, Funciones, pagos, uFLXInformeIVAPeriodos;

{ TFCaja }


//=============== Crea el formulario ================
procedure ShowFormCaja;
begin
  with TFCaja.Create(Application) do
    begin
       ShowModal;
       Inicio:=True;
       Base1:='0';
       Base2:='0';
       Base3:='0';
       Iva1:='0';
       Iva2:='0';
       Iva3:='0';
       TIva1:='0';
       TIva2:='0';
       TIva3:='0';
       TBases:='0';
       TIvas:='0';
       VTTotal:='0';

       Base1Glob:='0';
       Base2Glob:='0';
       Base3Glob:='0';
       Iva1Glob:='0';
       Iva2Glob:='0';
       Iva3Glob:='0';
       TIva1Glob:='0';
       TIva2Glob:='0';
       TIva3Glob:='0';
       TBasesGlob:='0';
       TIvasGlob:='0';
       VTTotalGlob:='0';

       Cambio:='0';
       Billetes:='0';
       Anterior:='0';

       CambioGlob:='0';
       BilletesGlob:='0';
       AnteriorGlob:='0';

    end;
end;

procedure TFCaja.FormActivate(Sender: TObject);
begin
//--- Al iniciar el Formulario comprueba si ya se ha realizado algun arqueo de este dia, y de ser asi, lo muestra en pantalla
   dbCajas.Sql.Text:='SELECT * FROM arqueos'+Tienda+' WHERE fecha="'+  FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text)) +'" and CAJA="'+StaticText95.Caption+'"';
   dbCajas.Active := True;
   If dbCajas.RecordCount=0 then
     Begin
        dbCajas.Sql.Text:='SELECT * FROM arqueos'+Tienda+'';
        dbCajas.Active := True;
        RellenoInfo(); // -- Pinta la informacion de las ventas en el dia de hoy
     End
   else
     Begin
        If TabSheet2.Visible then exit;
        LimpiaForm(); Relleno(); CuentaCaja();
     End;
   If inicio then
     Begin
        Edit9.SetFocus;
        inicio:=False;
     End;
end;

procedure TFCaja.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then
    Exit;

  { Los selectores auxiliares se cierran antes de cambiar de pantalla. }
  if ComboBox1.Visible then
  begin
    ComboBox1.Visible := False;
    if Edit9.CanFocus then
      Edit9.SetFocus;
    Key := 0;
    Exit;
  end;

  if ComboBox2.Visible then
  begin
    ComboBox2.Visible := False;
    if Edit19.CanFocus then
      Edit19.SetFocus;
    Key := 0;
    Exit;
  end;

  if ComboBox3.Visible then
  begin
    ComboBox3.Visible := False;
    if Edit20.CanFocus then
      Edit20.SetFocus;
    Key := 0;
    Exit;
  end;

  { En consultas, ESC retrocede un nivel: resultados/modificaciones ->
    selección -> pantalla principal. }
  if PageControl1.ActivePage = TabSheet2 then
  begin
    if DBGrid1.Visible or DBGrid2.Visible or DBGrid3.Visible or
       (not Panel8.Visible) then
    begin
      BitBtn16Click(BitBtn16);
      DBGrid3.Visible := False;
      Key := 0;
      Exit;
    end;

    PageControl1.ActivePage := TabSheet1;
    if Edit9.CanFocus then
      Edit9.SetFocus;
    Key := 0;
    Exit;
  end;

  { Cualquier otra pestaña interna creada en ejecución vuelve al arqueo. }
  if PageControl1.ActivePage <> TabSheet1 then
  begin
    PageControl1.ActivePage := TabSheet1;
    if Edit9.CanFocus then
      Edit9.SetFocus;
    Key := 0;
    Exit;
  end;

  { En la pantalla principal, ESC ejecuta exactamente el botón Cerrar. }
  Key := 0;
  BitBtn1Click(BitBtn1);
end;

Procedure TFCaja.Formcreate(Sender: Tobject);
Begin
  ShortDateFormat:='DD/MM/YYYY';
  {$IFDEF LINUX}
     DecimalSeparator:='.';
  {$ELSE}
     DecimalSeparator:=',';
  {$ENDIF}
  //----------------- CONEXION -----------------
  //Conectate(dbConect);     // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbCajas.Sql.Text:='SELECT * FROM arqueos'+Tienda+'';
  dbCajas.Active := True;

  //------------------- Inicializacion ----------
  DateEdit2.Date:=Date;              // -- Asigna fecha a los campos
  DateEdit1.Date:=Date;              // -- Asigna fecha a los campos
  DateEdit3.Date:=DateEdit2.Date+1;  // -- Asigna fecha a los campos
//-- Se modifica en el evento Onchange DateEdit2
   if DayOfWeek(DateEdit3.Date)=1 then
    begin
     DateEdit3.Date:=DateEdit3.Date+1;
     showmessage('Hoy es sabado, se almacena cambio para el lunes');
    end;
  StaticText95.Caption:=Puesto;      // -- Informacion sobre el puesto de trabajo en Pantalla

  //Asignamos valor de la moneda a los static.

  StaticText27.Caption:=txtMoneda;
  StaticText28.Caption:=txtMoneda;
  StaticText29.Caption:=txtMoneda;
  StaticText30.Caption:=txtMoneda;
  StaticText31.Caption:=txtMoneda;
  StaticText32.Caption:=txtMoneda;
  StaticText33.Caption:=txtMoneda;
  StaticText34.Caption:=txtMoneda;
  StaticText35.Caption:=txtMoneda;
  StaticText44.Caption:=txtMoneda;
  StaticText45.Caption:=txtMoneda;
  StaticText46.Caption:=txtMoneda;
  StaticText47.Caption:=txtMoneda;
  StaticText48.Caption:=txtMoneda;
  StaticText49.Caption:=txtMoneda;
  StaticText50.Caption:=txtMoneda;
  StaticText51.Caption:=txtMoneda;
  StaticText60.Caption:=txtMoneda;
  StaticText61.Caption:=txtMoneda;
  StaticText63.Caption:=txtMoneda;
  StaticText64.Caption:=txtMoneda;
  StaticText65.Caption:=txtMoneda;
  StaticText66.Caption:=txtMoneda;
  StaticText110.Caption:=txtMoneda;
  StaticText83.Caption:=txtMoneda;
  StaticText85.Caption:=txtMoneda;
  StaticText87.Caption:=txtMoneda;
  StaticText89.Caption:=txtMoneda;
  StaticText91.Caption:=txtMoneda;
  StaticText93.Caption:=txtMoneda;

  AplicarEstiloModernoSeguro;

  // Informe independiente por mes, trimestre, año o periodo personalizado.
  // La pestaña y todos sus controles se crean en tiempo de ejecución.
  FLXInstalarInformeIVAPeriodos(Self, PageControl1, dbCajas.Connection, Tienda);
end;

function TFCaja.ValorNumericoSeguro(const ATexto: String): Double;
var
  S: String;
begin
  S := Trim(ATexto);
  if S = '' then
  begin
    Result := 0;
    Exit;
  end;

  { Acepta tanto coma como punto al introducir importes, respetando el
    separador decimal que ya utiliza FacturLinEx en cada plataforma. }
  if DecimalSeparator = '.' then
    S := StringReplace(S, ',', '.', [rfReplaceAll])
  else
    S := StringReplace(S, '.', ',', [rfReplaceAll]);

  if not TryStrToFloat(S, Result) then
    Result := 0;
end;

function TFCaja.TextoDiferencia(const AValor: Double): String;
begin
  if Abs(AValor) < 0.005 then
    Result := '0.00 (correcto)'
  else if AValor > 0 then
    Result := '+' + FormatFloat('0.00', AValor) + ' (sobra)'
  else
    Result := FormatFloat('0.00', AValor) + ' (falta)';
end;

procedure TFCaja.CrearPanelDiagnostico;
const
  CAlturaCabecera = 64;
  CAlturaDiagnostico = 112;
begin
  if Assigned(FPanelDiagnostico) then
    Exit;

  { El formulario maximizado deja una franja libre sobre las pestañas.
    Se aprovecha para mostrar información de ayuda sin mover el arqueo. }
  Panel2.Height := CAlturaCabecera + CAlturaDiagnostico;

  FPanelDiagnostico := TPanel.Create(Self);
  FPanelDiagnostico.Name := 'pnlDiagnosticoCaja';
  FPanelDiagnostico.Caption := '';
  FPanelDiagnostico.Parent := Panel2;
  FPanelDiagnostico.Align := alBottom;
  FPanelDiagnostico.Height := CAlturaDiagnostico;
  FPanelDiagnostico.BevelOuter := bvNone;
  FPanelDiagnostico.Color := $00F4EEE5;
  FPanelDiagnostico.ParentFont := False;
  FPanelDiagnostico.Font.Name := 'Sans';

  FDiagTitulo := TLabel.Create(Self);
  FDiagTitulo.Name := 'lblDiagnosticoCajaTitulo';
  FDiagTitulo.Parent := FPanelDiagnostico;
  FDiagTitulo.SetBounds(14, 5, 520, 18);
  FDiagTitulo.Caption := 'AYUDA PARA LOCALIZAR DESCUADRES';
  FDiagTitulo.ParentFont := False;
  FDiagTitulo.Font.Name := 'Sans';
  FDiagTitulo.Font.Height := -12;
  FDiagTitulo.Font.Style := [fsBold];
  FDiagTitulo.Font.Color := clNavy;
  FDiagTitulo.Transparent := True;
  FDiagTitulo.BringToFront;

  FDiagEfectivo := TLabel.Create(Self);
  FDiagEfectivo.Name := 'lblDiagnosticoEfectivo';
  FDiagEfectivo.Parent := FPanelDiagnostico;
  FDiagEfectivo.SetBounds(14, 26, 425, 18);
  FDiagEfectivo.AutoSize := False;
  FDiagEfectivo.ParentFont := False;
  FDiagEfectivo.Font.Name := 'Sans';
  FDiagEfectivo.Font.Height := -11;
  FDiagEfectivo.Font.Style := [fsBold];
  FDiagEfectivo.Transparent := True;

  FDiagTarjetas := TLabel.Create(Self);
  FDiagTarjetas.Name := 'lblDiagnosticoTarjetas';
  FDiagTarjetas.Parent := FPanelDiagnostico;
  FDiagTarjetas.SetBounds(450, 26, 458, 18);
  FDiagTarjetas.AutoSize := False;
  FDiagTarjetas.Anchors := [akLeft, akTop, akRight];
  FDiagTarjetas.ParentFont := False;
  FDiagTarjetas.Font.Name := 'Sans';
  FDiagTarjetas.Font.Height := -11;
  FDiagTarjetas.Font.Style := [fsBold];
  FDiagTarjetas.Transparent := True;

  FDiagTotal := TLabel.Create(Self);
  FDiagTotal.Name := 'lblDiagnosticoTotal';
  FDiagTotal.Parent := FPanelDiagnostico;
  FDiagTotal.SetBounds(14, 49, 245, 22);
  FDiagTotal.AutoSize := False;
  FDiagTotal.ParentFont := False;
  FDiagTotal.Font.Name := 'Sans';
  FDiagTotal.Font.Height := -13;
  FDiagTotal.Font.Style := [fsBold];
  FDiagTotal.Transparent := True;

  FDiagCausa := TLabel.Create(Self);
  FDiagCausa.Name := 'lblDiagnosticoCausa';
  FDiagCausa.Parent := FPanelDiagnostico;
  FDiagCausa.SetBounds(270, 48, 638, 36);
  FDiagCausa.AutoSize := False;
  FDiagCausa.WordWrap := True;
  FDiagCausa.Anchors := [akLeft, akTop, akRight];
  FDiagCausa.ParentFont := False;
  FDiagCausa.Font.Name := 'Sans';
  FDiagCausa.Font.Height := -11;
  FDiagCausa.Font.Color := clNavy;
  FDiagCausa.Transparent := True;

  FDiagMovimientos := TLabel.Create(Self);
  FDiagMovimientos.Name := 'lblDiagnosticoMovimientos';
  FDiagMovimientos.Parent := FPanelDiagnostico;
  FDiagMovimientos.SetBounds(14, 82, 894, 28);
  FDiagMovimientos.AutoSize := False;
  FDiagMovimientos.WordWrap := True;
  FDiagMovimientos.Anchors := [akLeft, akTop, akRight];
  FDiagMovimientos.ParentFont := False;
  FDiagMovimientos.Font.Name := 'Sans';
  FDiagMovimientos.Font.Height := -10;
  FDiagMovimientos.Font.Color := $00404040;
  FDiagMovimientos.Transparent := True;

  FDiagQuery := TZQuery.Create(Self);
  FDiagQuery.Connection := dbCajas.Connection;

  FResumenMovimientos := 'Movimientos del periodo: todavía sin calcular.';
  ActualizarPanelDiagnostico;
end;

procedure TFCaja.ActualizarResumenMovimientos;
var
  Ventas, Devoluciones, Albaranes, Tarjetas, SaldoInicial, Cambios,
  Retiradas, Pagos, Deudas, Cobros, Entregas, Descuentos: Double;
begin
  if (not Assigned(FDiagQuery)) or (DateEdit1.Text = '') or
     (DateEdit2.Text = '') or (StaticText95.Caption = '') then
    Exit;

  try
    FDiagQuery.Close;
    FDiagQuery.SQL.Text :=
      'SELECT COALESCE(SUM(CA5),0) AS VENTAS,' +
      ' COALESCE(SUM(CA7),0) AS DEVOLUCIONES,' +
      ' COALESCE(SUM(CA12),0) AS ALBARANES,' +
      ' COALESCE(SUM(CA14),0) AS TARJETAS,' +
      ' COALESCE(SUM(CA16),0) AS SALDOINI,' +
      ' COALESCE(SUM(CA17),0) AS CAMBIOS,' +
      ' COALESCE(SUM(CA18),0) AS RETIRADAS,' +
      ' COALESCE(SUM(CA19),0) AS PAGOS,' +
      ' COALESCE(SUM(CA20),0) AS DEUDAS,' +
      ' COALESCE(SUM(CA21),0) AS COBROS,' +
      ' COALESCE(SUM(CA22),0) AS ENTREGAS,' +
      ' COALESCE(SUM(CA23),0)+COALESCE(SUM(CA24),0) AS DESCUENTOS' +
      ' FROM cajas' + Tienda +
      ' WHERE (CA0 >= "' +
        FormatDateTime('YYYY/MM/DD', StrToDate(DateEdit1.Text)) +
      '" AND CA0 <= "' +
        FormatDateTime('YYYY/MM/DD', StrToDate(DateEdit2.Text)) +
      '") AND CA2 = "' + StaticText95.Caption + '"';
    FDiagQuery.Open;

    Ventas := FDiagQuery.FieldByName('VENTAS').AsFloat;
    Devoluciones := FDiagQuery.FieldByName('DEVOLUCIONES').AsFloat;
    Albaranes := FDiagQuery.FieldByName('ALBARANES').AsFloat;
    Tarjetas := FDiagQuery.FieldByName('TARJETAS').AsFloat;
    SaldoInicial := FDiagQuery.FieldByName('SALDOINI').AsFloat;
    Cambios := FDiagQuery.FieldByName('CAMBIOS').AsFloat;
    Retiradas := FDiagQuery.FieldByName('RETIRADAS').AsFloat;
    Pagos := FDiagQuery.FieldByName('PAGOS').AsFloat;
    Deudas := FDiagQuery.FieldByName('DEUDAS').AsFloat;
    Cobros := FDiagQuery.FieldByName('COBROS').AsFloat;
    Entregas := FDiagQuery.FieldByName('ENTREGAS').AsFloat;
    Descuentos := FDiagQuery.FieldByName('DESCUENTOS').AsFloat;

    FResumenMovimientos :=
      'Movimientos: ventas ' + FormatFloat('0.00', Ventas) +
      ' | devoluciones ' + FormatFloat('0.00', Devoluciones) +
      ' | albaranes ' + FormatFloat('0.00', Albaranes) +
      ' | tarjetas ' + FormatFloat('0.00', Tarjetas) +
      ' | saldo inicial ' + FormatFloat('0.00', SaldoInicial) +
      ' | cambios/ingresos ' + FormatFloat('0.00', Cambios) +
      ' | retiradas ' + FormatFloat('0.00', Retiradas) +
      ' | pagos ' + FormatFloat('0.00', Pagos) +
      ' | crédito/cobros ' + FormatFloat('0.00', Deudas) + '/' +
        FormatFloat('0.00', Cobros) +
      ' | entregas ' + FormatFloat('0.00', Entregas) +
      ' | descuentos ' + FormatFloat('0.00', Descuentos) + ' ' + txtMoneda;
  except
    on E: Exception do
      FResumenMovimientos :=
        'No se pudo obtener el detalle de movimientos: ' + E.Message;
  end;

  ActualizarPanelDiagnostico;
end;

procedure TFCaja.ActualizarPanelDiagnostico;
var
  EfectivoEsperado, EfectivoContado, TarjetasEsperadas, TarjetasAnotadas,
  DifEfectivo, DifTarjetas, DifTotal, SaldoInicial: Double;
  Causa: String;
const
  Tolerancia = 0.005;
begin
  if not Assigned(FPanelDiagnostico) then
    Exit;

  EfectivoEsperado := ValorNumericoSeguro(StaticText68.Caption);
  EfectivoContado := ValorNumericoSeguro(StaticText84.Caption) +
    ValorNumericoSeguro(StaticText86.Caption);
  TarjetasEsperadas := ValorNumericoSeguro(StaticText69.Caption);
  TarjetasAnotadas := ValorNumericoSeguro(StaticText82.Caption);
  SaldoInicial := ValorNumericoSeguro(StaticText71.Caption);

  DifEfectivo := EfectivoContado - EfectivoEsperado;
  DifTarjetas := TarjetasAnotadas - TarjetasEsperadas;
  DifTotal := DifEfectivo + DifTarjetas;

  FDiagEfectivo.Caption :=
    'Efectivo: esperado ' + FormatFloat('0.00', EfectivoEsperado) +
    ' | contado ' + FormatFloat('0.00', EfectivoContado) +
    ' | ' + TextoDiferencia(DifEfectivo) + ' ' + txtMoneda;
  FDiagTarjetas.Caption :=
    'Tarjetas/talones: esperado ' + FormatFloat('0.00', TarjetasEsperadas) +
    ' | anotado ' + FormatFloat('0.00', TarjetasAnotadas) +
    ' | ' + TextoDiferencia(DifTarjetas) + ' ' + txtMoneda;
  FDiagTotal.Caption :=
    'DESCUADRE TOTAL: ' + TextoDiferencia(DifTotal) + ' ' + txtMoneda;

  if Abs(DifEfectivo) < Tolerancia then
    FDiagEfectivo.Font.Color := $00007000
  else
    FDiagEfectivo.Font.Color := clMaroon;

  if Abs(DifTarjetas) < Tolerancia then
    FDiagTarjetas.Font.Color := $00007000
  else
    FDiagTarjetas.Font.Color := clMaroon;

  if Abs(DifTotal) < Tolerancia then
    FDiagTotal.Font.Color := $00007000
  else
    FDiagTotal.Font.Color := clRed;

  if (Abs(DifTotal) < Tolerancia) and
     ((Abs(DifEfectivo) >= Tolerancia) or (Abs(DifTarjetas) >= Tolerancia)) then
    Causa := 'El total cuadra, pero efectivo y tarjeta se compensan: revise una venta ' +
      'registrada con una forma de pago distinta de la realmente cobrada.'
  else if Abs(DifTotal) < Tolerancia then
    Causa := 'Sin diferencias. El efectivo y las tarjetas/talones coinciden con lo esperado.'
  else if (Abs(DifEfectivo) >= Tolerancia) and
          (Abs(DifTarjetas) >= Tolerancia) and
          ((DifEfectivo > 0) <> (DifTarjetas > 0)) then
    Causa := 'Las diferencias van en sentidos opuestos: es muy probable que exista un cobro ' +
      'clasificado como efectivo en vez de tarjeta, o al contrario.'
  else if (Abs(DifEfectivo) >= Tolerancia) and
          (Abs(DifTarjetas) < Tolerancia) then
  begin
    if (Abs(SaldoInicial) >= Tolerancia) and
       (Abs(Abs(DifEfectivo) - Abs(SaldoInicial)) < Tolerancia) then
      Causa := 'La diferencia coincide con el saldo inicial/cambio anterior. Compruebe que ' +
        'el cambio se anotó para la fecha y la caja correctas.'
    else
      Causa := 'El fallo está concentrado en efectivo: revise recuento, cambio inicial, ' +
        'retiradas de fondos, pagos varios, cobros de deuda y entregas a cuenta.';
  end
  else if (Abs(DifTarjetas) >= Tolerancia) and
          (Abs(DifEfectivo) < Tolerancia) then
    Causa := 'El fallo está en tarjetas/talones: compare el cierre del terminal bancario y ' +
      'revise duplicados, anulaciones y formas de pago incorrectas.'
  else
    Causa := 'Hay diferencias en efectivo y en tarjetas/talones. Revise primero el cierre ' +
      'del terminal y después los movimientos manuales mostrados debajo.';

  FDiagCausa.Caption := 'Revisión sugerida: ' + Causa;
  FDiagMovimientos.Caption := FResumenMovimientos;
end;

function TFCaja.SolicitarImporteCambio(const APropuesto, AExistente: Double;
  const AYaExiste: Boolean; out AImporte: Double): Boolean;
var
  Texto, Mensaje: String;
begin
  Result := False;
  Texto := FormatFloat('0.00', APropuesto);

  Mensaje := 'Se propone anotar ' + FormatFloat('0.00', APropuesto) + ' ' +
    txtMoneda + ' como cambio para el día ' + DateEdit3.Text + '.' + LineEnding +
    'Puede modificar la cantidad antes de guardarla.';
  if AYaExiste then
    Mensaje := Mensaje + LineEnding + 'Actualmente ya constan ' +
      FormatFloat('0.00', AExistente) + ' ' + txtMoneda +
      '; el nuevo importe sustituirá al anterior.';

  repeat
    if not InputQuery('Confirmar cambio', Mensaje, Texto) then
      Exit;

    Texto := Trim(Texto);
    if DecimalSeparator = '.' then
      Texto := StringReplace(Texto, ',', '.', [rfReplaceAll])
    else
      Texto := StringReplace(Texto, '.', ',', [rfReplaceAll]);

    if TryStrToFloat(Texto, AImporte) and (AImporte >= 0) then
      Break;

    ShowMessage('Introduzca una cantidad válida, igual o superior a cero.');
  until False;

  Result := True;
end;


procedure TFCaja.AplicarEstiloModernoSeguro;
var
  LTitle, LSub: TLabel;
  I: Integer;

  procedure AsignarIconoSimple(ABoton: TBitBtn; ATipo: Integer; ATamano: Integer = 18);
  var
    B: TBitmap;
    C: TCanvas;
    M: Integer;
  begin
    if not Assigned(ABoton) then Exit;

    B := TBitmap.Create;
    try
      B.SetSize(ATamano, ATamano);
      B.Transparent := True;
      B.TransparentColor := clFuchsia;
      C := B.Canvas;
      C.Brush.Style := bsSolid;
      C.Brush.Color := clFuchsia;
      C.FillRect(Rect(0, 0, ATamano, ATamano));
      C.Pen.Color := clNavy;
      C.Pen.Width := 2;
      C.Brush.Style := bsClear;
      M := ATamano div 2;

      case ATipo of
        1: begin { cajon }
             C.Rectangle(2, 5, ATamano - 2, ATamano - 2);
             C.MoveTo(3, 8); C.LineTo(ATamano - 3, 8);
             C.Rectangle(M - 2, 10, M + 2, 13);
           end;
        2: begin { primero }
             C.MoveTo(3, 3); C.LineTo(3, ATamano - 3);
             C.MoveTo(ATamano - 4, 3); C.LineTo(6, M);
             C.LineTo(ATamano - 4, ATamano - 3);
           end;
        3: begin { ultimo }
             C.MoveTo(ATamano - 3, 3); C.LineTo(ATamano - 3, ATamano - 3);
             C.MoveTo(4, 3); C.LineTo(ATamano - 6, M);
             C.LineTo(4, ATamano - 3);
           end;
        4: begin { reloj }
             C.Ellipse(2, 2, ATamano - 2, ATamano - 2);
             C.MoveTo(M, 4); C.LineTo(M, M);
             C.LineTo(ATamano - 5, M + 2);
           end;
        5: begin { cerrar }
             C.MoveTo(3, 3); C.LineTo(ATamano - 3, ATamano - 3);
             C.MoveTo(ATamano - 3, 3); C.LineTo(3, ATamano - 3);
           end;
        6: begin { nuevo }
             C.Rectangle(3, 3, ATamano - 3, ATamano - 3);
             C.MoveTo(M, 6); C.LineTo(M, ATamano - 6);
             C.MoveTo(6, M); C.LineTo(ATamano - 6, M);
           end;
        7: begin { borrar }
             C.Rectangle(5, 6, ATamano - 5, ATamano - 2);
             C.MoveTo(3, 5); C.LineTo(ATamano - 3, 5);
             C.MoveTo(7, 2); C.LineTo(ATamano - 7, 2);
           end;
        8: begin { modificar }
             C.MoveTo(3, ATamano - 3); C.LineTo(6, ATamano - 4);
             C.LineTo(ATamano - 3, 7); C.LineTo(ATamano - 7, 3);
             C.LineTo(4, ATamano - 6); C.LineTo(3, ATamano - 3);
           end;
        9: begin { anterior }
             C.MoveTo(ATamano - 3, 3); C.LineTo(5, M);
             C.LineTo(ATamano - 3, ATamano - 3);
           end;
        10: begin { siguiente }
              C.MoveTo(3, 3); C.LineTo(ATamano - 5, M);
              C.LineTo(3, ATamano - 3);
            end;
        11: begin { limpiar }
              C.MoveTo(4, ATamano - 4); C.LineTo(ATamano - 5, 4);
              C.LineTo(ATamano - 2, 7); C.LineTo(7, ATamano - 2);
              C.LineTo(4, ATamano - 4);
            end;
        12: begin { recalcular }
              C.Arc(2, 2, ATamano - 2, ATamano - 2, ATamano - 3, M, M, 2);
              C.MoveTo(ATamano - 4, 3); C.LineTo(ATamano - 2, 8);
              C.LineTo(ATamano - 7, 7);
            end;
        13: begin { cambio / efectivo }
              C.MoveTo(3, 5); C.LineTo(ATamano - 5, 5);
              C.LineTo(ATamano - 8, 2);
              C.MoveTo(ATamano - 5, 5); C.LineTo(ATamano - 8, 8);
              C.MoveTo(ATamano - 3, ATamano - 5); C.LineTo(5, ATamano - 5);
              C.LineTo(8, ATamano - 8);
              C.MoveTo(5, ATamano - 5); C.LineTo(8, ATamano - 2);
            end;
        14: begin { imprimir }
              C.Rectangle(4, 2, ATamano - 4, 7);
              C.Rectangle(2, 7, ATamano - 2, ATamano - 5);
              C.Rectangle(5, ATamano - 9, ATamano - 5, ATamano - 2);
            end;
        15: begin { pagos }
              C.Ellipse(2, 2, ATamano - 2, ATamano - 2);
              C.MoveTo(M + 3, 5); C.LineTo(M - 2, 5);
              C.LineTo(M - 4, M); C.LineTo(M + 3, M);
              C.LineTo(M + 2, ATamano - 5); C.LineTo(M - 3, ATamano - 5);
            end;
        16: begin { calendario }
              C.Rectangle(2, 4, ATamano - 2, ATamano - 2);
              C.MoveTo(2, 8); C.LineTo(ATamano - 2, 8);
              C.MoveTo(6, 2); C.LineTo(6, 6);
              C.MoveTo(ATamano - 6, 2); C.LineTo(ATamano - 6, 6);
            end;
        17: begin { buscar }
              C.Ellipse(2, 2, ATamano - 6, ATamano - 6);
              C.MoveTo(ATamano - 7, ATamano - 7);
              C.LineTo(ATamano - 2, ATamano - 2);
            end;
        18: begin { aceptar }
              C.MoveTo(2, M); C.LineTo(M - 2, ATamano - 3);
              C.LineTo(ATamano - 2, 3);
            end;
        19: begin { visualizar }
              C.Arc(2, 4, ATamano - 2, ATamano - 4, 2, M, ATamano - 2, M);
              C.Ellipse(M - 2, M - 2, M + 2, M + 2);
            end;
        20: begin { seleccionar }
              C.Rectangle(2, 2, ATamano - 2, ATamano - 2);
              C.MoveTo(4, M); C.LineTo(M - 1, ATamano - 5);
              C.LineTo(ATamano - 4, 5);
            end;
        21: begin { lista/varios }
              C.Rectangle(3, 2, ATamano - 3, ATamano - 2);
              C.MoveTo(6, 6); C.LineTo(ATamano - 6, 6);
              C.MoveTo(6, M); C.LineTo(ATamano - 6, M);
              C.MoveTo(6, ATamano - 6); C.LineTo(ATamano - 6, ATamano - 6);
            end;
      end;

      { Se fuerza un icono coherente incluso cuando el glyph antiguo no se
        representaba correctamente en el tema actual. }
      ABoton.Glyph.Clear;
      ABoton.Glyph.Assign(B);
      ABoton.NumGlyphs := 1;
      ABoton.Layout := blGlyphLeft;
      ABoton.Spacing := 4;
      ABoton.Margin := -1;
    finally
      B.Free;
    end;
  end;

begin
  { Modernizacion conservadora: no se recoloca ni redimensiona ningun
    componente funcional del arqueo. Se respeta la geometria del LFM. }
  Caption := 'Arqueo de caja';
  WindowState := wsMaximized;
  { Fondo general azul grisaceo suave para evitar una pantalla excesivamente blanca. }
  Color := $00E8E2DC;

  Panel2.Caption := '';
  Panel2.Align := alTop;
  Panel2.Height := 64;
  Panel2.BevelOuter := bvNone;
  Panel2.Color := clNavy;

  PageControl1.Align := alBottom;
  PageControl1.ParentFont := False;
  PageControl1.Font.Name := 'Sans';
  PageControl1.Font.Height := -12;
  TabSheet1.Caption := 'Arqueo y conteo';
  TabSheet2.Caption := 'Consultas e informes';
  TabSheet1.Color := $00E8E2DC;
  TabSheet2.Color := $00E8E2DC;

  LTitle := TLabel.Create(Self);
  LTitle.Parent := Panel2;
  LTitle.SetBounds(20, 7, 760, 27);
  LTitle.Caption := 'ARQUEO DE CAJA';
  LTitle.ParentFont := False;
  LTitle.Font.Name := 'Sans';
  LTitle.Font.Height := -20;
  LTitle.Font.Style := [fsBold];
  LTitle.Font.Color := clWhite;
  LTitle.Transparent := True;
  LTitle.Anchors := [akLeft, akTop, akRight];

  LSub := TLabel.Create(Self);
  LSub.Parent := Panel2;
  LSub.SetBounds(22, 36, 1050, 18);
  LSub.Caption := 'Conteo de efectivo, contraste con ventas, pagos y movimientos de caja.';
  LSub.ParentFont := False;
  LSub.Font.Name := 'Sans';
  LSub.Font.Height := -11;
  LSub.Font.Color := clSilver;
  LSub.Transparent := True;
  LSub.Anchors := [akLeft, akTop, akRight];

  { Mantener textos cortos para que no se recorten en los bloques originales. }
  GroupBox1.Caption := ' BILLETES ';
  GroupBox2.Caption := ' MONEDAS ';
  GroupBox3.Caption := ' INFORMACION DE CAJA ';
  GroupBox4.Caption := ' RESULTADO DEL ARQUEO ';
  GroupBox5.Caption := ' INFO. ADICIONAL ';
  GroupBox6.Caption := ' FECHAS ';

  Panel1.Caption := '';
  Panel1.Color := $00E1D8CD;
  Panel5.Caption := '';
  Panel6.Caption := '';
  Panel5.Color := $00E8E2DC;
  Panel6.Color := $00E8E2DC;
  Panel3.ParentFont := False;
  Panel3.Font.Name := 'Sans';
  Panel3.Font.Height := -14;
  Panel3.Font.Style := [fsBold];

  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TGroupBox then
    begin
      TGroupBox(Components[I]).ParentFont := False;
      TGroupBox(Components[I]).Font.Name := 'Sans';
      TGroupBox(Components[I]).Font.Height := -12;
      TGroupBox(Components[I]).Font.Style := [fsBold];
      TGroupBox(Components[I]).Font.Color := clNavy;
      { Tarjetas suaves: se conserva el contraste de los campos sin llenar la pantalla de blanco. }
      TGroupBox(Components[I]).Color := $00F0EBE4;
      TGroupBox(Components[I]).ParentColor := False;
    end
    else if Components[I] is TBitBtn then
    begin
      TBitBtn(Components[I]).ParentFont := False;
      TBitBtn(Components[I]).Font.Name := 'Sans';
      TBitBtn(Components[I]).Font.Height := -11;
    end
    else if Components[I] is TEdit then
    begin
      TEdit(Components[I]).ParentFont := False;
      TEdit(Components[I]).Font.Name := 'Sans';
      if TEdit(Components[I]).ReadOnly then
        TEdit(Components[I]).Color := $00E4E1DD
      else
        TEdit(Components[I]).Color := $00FCFBF9;
    end;
  end;

  { Mejora visual de grids sin alterar posiciones, columnas ni eventos. }
  DBGrid12.Color := clWhite;
  DBGrid1.Color := clWhite;
  DBGrid2.Color := clWhite;
  DBGrid3.Color := clWhite;
  DBGrid12.FixedColor := $00DDD3C9;
  DBGrid1.FixedColor := $00DDD3C9;
  DBGrid2.FixedColor := $00DDD3C9;
  DBGrid3.FixedColor := $00DDD3C9;
  DBGrid12.TitleFont.Style := [fsBold];
  DBGrid1.TitleFont.Style := [fsBold];
  DBGrid2.TitleFont.Style := [fsBold];
  DBGrid3.TitleFont.Style := [fsBold];

  Panel7.Caption := '';
  Panel8.Caption := '';
  Panel9.Caption := '';
  Panel4.Caption := '';
  Panel7.Color := $00E7DFD6;
  Panel8.Color := $00E7DFD6;
  Panel9.Color := $00E7DFD6;
  Panel4.Color := $00E7DFD6;

  { Iconos coherentes para todos los botones del arqueo. }
  AsignarIconoSimple(BitBtn1, 5, 16);   { cerrar }
  AsignarIconoSimple(BitBtn2, 6, 16);   { nuevo }
  AsignarIconoSimple(BitBtn3, 7, 16);   { borrar }
  AsignarIconoSimple(BitBtn4, 8, 16);   { modificar }
  AsignarIconoSimple(BitBtn5, 9, 16);   { anterior }
  AsignarIconoSimple(BitBtn6, 10, 16);  { siguiente }
  AsignarIconoSimple(BitBtn7, 11, 16);  { limpiar }
  AsignarIconoSimple(BitBtn8, 16, 14);  { fecha desde }
  AsignarIconoSimple(BitBtn9, 17, 14);  { buscar arqueo }
  AsignarIconoSimple(BitBtn10, 18, 14); { validar fecha }
  AsignarIconoSimple(BitBtn11, 12, 16); { recalcular }
  AsignarIconoSimple(BitBtn12, 13, 16); { cambio }
  AsignarIconoSimple(BitBtn13, 4, 14);  { hora inicial }
  AsignarIconoSimple(BitBtn14, 19, 18); { visualizar }
  AsignarIconoSimple(BitBtn15, 14, 18); { imprimir }
  AsignarIconoSimple(BitBtn16, 20, 18); { seleccionar }
  AsignarIconoSimple(BitBtn17, 21, 18); { varios }
  AsignarIconoSimple(BitBtn18, 5, 18);  { cerrar consulta }
  AsignarIconoSimple(BitBtn19, 4, 14);  { hora final }
  AsignarIconoSimple(BitBtn20, 18, 18); { aceptar }
  AsignarIconoSimple(BitBtn21, 14, 16); { imprimir arqueo }
  AsignarIconoSimple(BitBtn22, 15, 16); { pagos/ingresos }
  AsignarIconoSimple(BitBtn23, 1, 18);  { cajon }
  AsignarIconoSimple(BitBtn24, 3, 16);  { ultimo }
  AsignarIconoSimple(BitBtn25, 2, 16);  { primero }
  AsignarIconoSimple(BitBtn26, 16, 16); { buscar caja por fecha }

  CrearPanelDiagnostico;
end;

//==================== CERRAR ======================
Procedure TFCaja.Bitbtn1click(Sender: Tobject);
Begin
  dbCajas.Active:=False;
  Close();

//--- CONTROL FINAL
//-- Caja
    keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
//-- Fechas
    keyloger('=============== NUEVO ',' APUNTE =============');
    keyloger('Desde : ',DateEdit1.Text);
    keyloger('Hasta : ',DateEdit2.Text);
    keyloger('Cambio : ',DateEdit3.Text);
//-- Billetes
    keyloger('############### Billetes ##############',TimeToStr(Time));
   if Edit9.Text<>'' then keyloger(StaticText1.Caption, Edit9.Text) ELSE keyloger(StaticText1.Caption, '0');
   if Edit10.Text<>'' then keyloger(StaticText2.Caption, Edit10.Text) ELSE keyloger(StaticText2.Caption, '0');
   if Edit11.Text<>'' then keyloger(StaticText3.Caption, Edit11.Text) ELSE keyloger(StaticText3.Caption, '0');
   if Edit12.Text<>'' then keyloger(StaticText4.Caption, Edit12.Text) ELSE keyloger(StaticText4.Caption, '0');
   if Edit13.Text<>'' then keyloger(StaticText5.Caption, Edit13.Text) ELSE keyloger(StaticText5.Caption, '0');
   if Edit14.Text<>'' then keyloger(StaticText6.Caption, Edit14.Text) ELSE keyloger(StaticText6.Caption, '0');
   if Edit15.Text<>'' then keyloger(StaticText7.Caption, Edit15.Text) ELSE keyloger(StaticText7.Caption, '0');
//-- Tarjetas y Talones
   keyloger('Tarjetas y Talones',TimeToStr(Time));
   if Edit16.Text<>'' then keyloger(StaticText8.Caption, Edit16.Text) ELSE keyloger(StaticText8.Caption, '0');
   if Edit17.Text<>'' then keyloger(StaticText17.Caption, Edit17.Text) ELSE keyloger(StaticText17.Caption, '0');
//-- Monedas
   keyloger('************** Monedas ****************',TimeToStr(Time));
   if Edit1.Text<>'' then keyloger(StaticText9.Caption, Edit1.Text) ELSE keyloger(StaticText9.Caption, '0');
   if Edit2.Text<>'' then keyloger(StaticText10.Caption, Edit2.Text) ELSE keyloger(StaticText10.Caption, '0');
   if Edit3.Text<>'' then keyloger(StaticText11.Caption, Edit3.Text) ELSE keyloger(StaticText11.Caption, '0');
   if Edit4.Text<>'' then keyloger(StaticText12.Caption, Edit4.Text) ELSE keyloger(StaticText12.Caption, '0');
   if Edit5.Text<>'' then keyloger(StaticText13.Caption, Edit5.Text) ELSE keyloger(StaticText13.Caption, '0');
   if Edit6.Text<>'' then keyloger(StaticText14.Caption, Edit6.Text) ELSE keyloger(StaticText14.Caption, '0');
   if Edit7.Text<>'' then keyloger(StaticText15.Caption, Edit7.Text) ELSE keyloger(StaticText15.Caption, '0');
   if Edit8.Text<>'' then keyloger(StaticText16.Caption, Edit8.Text) ELSE keyloger(StaticText16.Caption, '0');

End;

Procedure TFCaja.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;


//=================== REGISTRO NUEVO ===================
Procedure TFCaja.Bitbtn2click(Sender: Tobject);
Begin
//--- Trabajo con el conteo de monedas

  if DateEdit2.Text='' then exit;

  dbCajas.Sql.Text:='SELECT * FROM arqueos'+Tienda+' WHERE fecha="'+  FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text)) +'" and CAJA="'+StaticText95.Caption+'"';
  dbCajas.Active := True;

  if dbCajas.RecordCount=1 then
   begin
     //-- Showmessage('ESE REGISTRO YA EXISTE');  //-- Sustituido por la linea inferior para aceptar la modificación
     If Application.MessageBox('ESE REGISTRO YA EXISTE - CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then Exit;
     dbCajas.Edit; LlenaReg(); dbCajas.Post;
     StaticText94.Caption:='MODIFICADO';
     Exit;
     {
     dbCajas.Sql.Text:='SELECT * FROM arqueos'+Tienda+'';
     dbCajas.Active := True;
     exit;
     }
   end;
  if dbCajas.RecordCount=0 then
   begin
        dbCajas.Append; LlenaReg(); dbCajas.Post;
        StaticText94.Caption:='ALMACENADO';
   end;
End;

//=================== BORRAR REGISTRO ===================
Procedure TFCaja.Bitbtn3click(Sender: Tobject);
Begin
//--- Trabajo con el conteo de monedas
   if DateEdit2.Text='' then exit;

   dbCajas.Sql.Text:='SELECT * FROM arqueos'+Tienda+' WHERE fecha="'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text)) +'" and CAJA="'+StaticText95.Caption+'"';
   dbCajas.Active := True;

  if dbCajas.RecordCount=0 then
   begin
     Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
     dbCajas.Sql.Text:='SELECT * FROM arqueos'+Tienda+'';
     dbCajas.Active := True;
     exit;
   end;

   if Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
       Exit;
   dbCajas.Delete; LimpiaForm();
   StaticText94.Caption:='ELIMINADO';
End;

//=================== MODIFICAR ===================
Procedure TFCaja.Bitbtn4click(Sender: Tobject);
Begin
//--- Trabajo con el conteo de monedas
   if DateEdit2.Text='' then exit;

   dbCajas.Sql.Text:='SELECT * FROM arqueos'+Tienda+' WHERE fecha="'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text)) +'" and CAJA="'+StaticText95.Caption+'"';
   dbCajas.Active := True;

   if dbCajas.Recordcount=0 then
      begin
        {
           Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO!');
           exit;
        }
        If Application.MessageBox('ESE REGISTRO NO EXISTE - DESEA CREARLO NUEVO ?','FacturLinEx', boxstyle) = IDNO Then Exit;
        dbCajas.Append; LlenaReg(); dbCajas.Post;
        StaticText94.Caption:='ALMACENADO';
        Exit;
      end;
   If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
   if dbCajas.Recordcount=1 then
      begin
           dbCajas.Edit; LlenaReg(); dbCajas.Post;
           StaticText94.Caption:='MODIFICADO';
      end;
End;

//==================== CALCULAR LOS RESULTADOS DEL CONTEO DE LA CAJA ====================
//====================  Y PINTAR LOS RESULTADOS DEL MISMO  ==============================
Procedure TFCaja.CuentaCaja();
Var
   Temporal,Temporal2,Global: Double;
Begin
     // ------ Calculos del conteo de caja, RESULTADOS ------
     Global:=0;
     //--- Suma el importe de los billetes contados
     Temporal:=0;
     Temporal2:=0;
     If Edit1.Text<>'' then Temporal:= Temporal + (StrToFloat(Edit1.Text) * 2);
     Temporal2:=Temporal + Temporal2;
     StaticText36.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE MONEDA INDIVIDUAL
     Temporal:=0;
     If Edit2.Text<>'' then Temporal:= (StrToFloat(Edit2.Text) * 1);
     Temporal2:=Temporal + Temporal2;
     StaticText37.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE MONEDA INDIVIDUAL
     Temporal:=0;
     If Edit3.Text<>'' then Temporal:= (StrToFloat(Edit3.Text) * 0.50);
     Temporal2:=Temporal + Temporal2;
     StaticText38.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE MONEDA INDIVIDUAL
     Temporal:=0;
     If Edit4.Text<>'' then Temporal:= (StrToFloat(Edit4.Text) * 0.20);
     Temporal2:=Temporal + Temporal2;
     StaticText39.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE MONEDA INDIVIDUAL
     Temporal:=0;
     If Edit5.Text<>'' then Temporal:= (StrToFloat(Edit5.Text) * 0.10);
     Temporal2:=Temporal + Temporal2;
     StaticText40.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE MONEDA INDIVIDUAL
     Temporal:=0;
     If Edit6.Text<>'' then Temporal:= (StrToFloat(Edit6.Text) * 0.05);
     Temporal2:=Temporal + Temporal2;
     StaticText41.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE MONEDA INDIVIDUAL
     Temporal:=0;
     If Edit7.Text<>'' then Temporal:= (StrToFloat(Edit7.Text) * 0.02);
     Temporal2:=Temporal + Temporal2;
     StaticText42.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE MONEDA INDIVIDUAL
     Temporal:=0;
     If Edit8.Text<>'' then Temporal:= (StrToFloat(Edit8.Text) * 0.01);
     Temporal2:=Temporal + Temporal2;
     StaticText43.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE MONEDA INDIVIDUAL

     StaticText86.Caption:= FormatFloat('0.00',Temporal2); // -- Campo de RESULTADO - MONEDAS

     //--- Suma el importe de los billetes contados
     Temporal:=0;
     Temporal2:=0;
     If Edit9.Text<>'' then Temporal:= (StrToFloat(Edit9.Text) * 500);
     Temporal2:=Temporal + Temporal2;
     StaticText18.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE BILLETE INDIVIDUAL
     Temporal:=0;
     If Edit10.Text<>'' then Temporal:= (StrToFloat(Edit10.Text) * 200);
     Temporal2:=Temporal + Temporal2;
     StaticText19.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE BILLETE INDIVIDUAL
     Temporal:=0;
     If Edit11.Text<>'' then Temporal:= (StrToFloat(Edit11.Text) * 100);
     Temporal2:=Temporal + Temporal2;
     StaticText20.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE BILLETE INDIVIDUAL
     Temporal:=0;
     If Edit12.Text<>'' then Temporal:= (StrToFloat(Edit12.Text) * 50);
     Temporal2:=Temporal + Temporal2;
     StaticText21.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE BILLETE INDIVIDUAL
     Temporal:=0;
     If Edit13.Text<>'' then Temporal:= (StrToFloat(Edit13.Text) * 20);
     Temporal2:=Temporal + Temporal2;
     StaticText22.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE BILLETE INDIVIDUAL
     Temporal:=0;
     If Edit14.Text<>'' then Temporal:= (StrToFloat(Edit14.Text) * 10);
     Temporal2:=Temporal + Temporal2;
     StaticText23.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE BILLETE INDIVIDUAL
     Temporal:=0;
     If Edit15.Text<>'' then Temporal:= (StrToFloat(Edit15.Text) * 5);
     Temporal2:=Temporal + Temporal2;
     StaticText24.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - POR TIPO DE BILLETE INDIVIDUAL

     StaticText84.Caption:= FormatFloat('0.00',Temporal2); // -- Campo de RESULTADO - BILLETES

     //--- Suma el importe de las Tarjetas y Talones contados
     Temporal:=0;
     Temporal2:=0;
     If Edit16.Text<>'' then Temporal:= (StrToFloat(Edit16.Text));
     Temporal2:=Temporal + Temporal2;
     StaticText25.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - TALONES INDIVIDUAL
     Temporal:=0;
     If Edit17.Text<>'' then Temporal:= (StrToFloat(Edit17.Text));
     Temporal2:=Temporal + Temporal2;
     StaticText26.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO - TARJETAS INDIVIDUAL


     StaticText82.Caption:= FormatFloat('0.00',Temporal2); // -- Campo de RESULTADO - TARJETAS Y TALONES
     
     // ------ Calculos del conteo de caja, RESULTADOS ------
        //--- Calcula la diferencia en caja, Efectivo
     Temporal:=0;
     Temporal2:=0;
     If StaticText84.Caption<>'' then Temporal:= Temporal + (StrToFloat(StaticText84.Caption));
     If StaticText86.Caption<>'' then Temporal:= Temporal + (StrToFloat(StaticText86.Caption));
     If StaticText68.Caption<>'' then Temporal2:= Temporal2 + (StrToFloat(StaticText68.Caption));
     Temporal:= Temporal - Temporal2; // -- Calcula el Descuadre
     Global:= Global + Temporal; // -- Almacena la diferencia para acumularla al DESCUADRE GLOBAL
     StaticText92.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO DESCUADRE- EFECTIVO (BILLETES Y MONEDAS)

        //--- Calcula la diferencia en caja, Tarjetas y Talones
     Temporal:=0;
     Temporal2:=0;
     If StaticText82.Caption<>'' then Temporal:= Temporal + (StrToFloat(StaticText82.Caption));
     If StaticText69.Caption<>'' then Temporal2:= Temporal2 + (StrToFloat(StaticText69.Caption));
     Temporal:= Temporal - Temporal2; // -- Calcula el Descuadre
     Global:= Global + Temporal; // -- Almacena la diferencia para acumularla al DESCUADRE GLOBAL
     StaticText90.Caption:= FormatFloat('0.00',Temporal); // -- Campo de RESULTADO DESCUADRE - (TARJETAS Y TALONES)
     
     StaticText88.Caption:= FormatFloat('0.00',Global); // -- Campo de RESULTADO DESCUADRE - (GLOBAL)

     ActualizarPanelDiagnostico;

//---------- Asigna un color informativo segun el RESULTADO del arqueo
      If ((StaticText88.Caption='0.00') or (StaticText88.Caption='-0.00') or (StaticText88.Caption='0')) Then
        Begin
           Panel3.Caption:='EL ARQUEO ES CORRECTO';
           Panel3.Font.Color:=$00007F00; // Texto Verde TODO CORRECTO
           Panel3.Color:=$00CFCFCF;
           Exit;
        End
      Else
        Begin
           If Global>0 Then
             Begin
                Panel3.Color:=$007F0000; // -- SOBRA DINERO - Azul
                Panel3.Caption:='SOBRA DINERO';
                Panel3.Font.Color:= $000BFFF4; // TEXTO EN AMARILLO PARA SER LEGIBLE
                Exit;
             End
           Else
             Begin
                Panel3.Color:=$0000007F; // -- FALTA DINERO - Rojo/Marron
                Panel3.Caption:='FALTA DINERO';
                Panel3.Font.Color:= $000BFFF4; // TEXTO EN AMARILLO PARA SER LEGIBLE
             End;
        End;

  //-- Comprobación de asignaciones
  {
  Cambio:=StaticText86.Caption;
  Billetes:=StaticText84.Caption;
  Anterior:=StaticText71.Caption;
  }

End;

//==================== REG. ANTERIOR ===============
Procedure TFCaja.Bitbtn5click(Sender: Tobject);
Begin
  dbCajas.Prior;
  LimpiaForm(); Relleno(); CuentaCaja();
End;

//==================== REG. POSTERIOR ===============
Procedure TFCaja.Bitbtn6click(Sender: Tobject);
Begin
   dbCajas.Next;
   LimpiaForm(); Relleno(); CuentaCaja();
End;



//==================== CONTROLES ADICIONALES ========
//==================== LIMPIEZA DE PANTALLA =========
procedure TFCaja.BitBtn7Click(Sender: TObject);
begin
//--- Elimina posibles limitaciones, provocadas por alguna seleccion anterior
   dbCajas.Sql.Text:='SELECT * FROM arqueos'+Tienda+'';
   dbCajas.Active := True;

   LimpiaForm(); RellenoInfo();
end;

//==================== CAMBIO DE PUESTO =========
procedure TFCaja.StaticText95Click(Sender: TObject);
var
 TxtQuery: String;
begin
//--- Al hacer click sobre la caja, se activa la posibilidad de cambiar la caja
//   Edit18.Visible:=True;
//   Edit18.SetFocus;
   ComboBox1.Visible:=True;
   ComboBox1.BringToFront;
   TxtQuery:='SELECT PT0, PT1 FROM puestos'+tienda+' ORDER BY PT1';
   CargaValoresEnComboCambiable(TxtQuery, ComboBox1, ZQPuesto, Label3variable);
end;
//--- Inicio Metodo Antonio rellenado combo PUESTO --- Más las 4 lineas combo box procedimiento anterior
procedure TFCaja.ComboBox1Click(Sender: TObject);
var TxtCampo: string;
begin
  TxtCampo:='PT1';
  EscogeNombreComboCambiable( TxtCampo, ComboBox1, ZQPuesto, Edit18, StaticText95);
//  Edit18.Text:=StaticText95.Caption;
  Edit18Exit(Edit18);
end;

procedure TFCaja.ComboBox1KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   Begin
        ComboBox1Click(ComboBox1);
        ComboBox1.Visible:=False;
   end;
end;
//--- Fin Metodo Antonio rellenado combo PUESTO ---
procedure TFCaja.Edit18Exit(Sender: TObject);
begin
//--- Al salir del campo para cambiar la caja asigna a la info el valor de la nueva caja y oculta de nuevo el campo
   If Edit18.Text='' then exit;
   Edit18.Text:=UpperCase(Edit18.Text);
   StaticText95.Caption:=Edit18.Text;
   Edit18.Visible:=False;
   RellenoInfo();
   If dbACaja.RecordCount=0 then showmessage('NO EXISTE INFORMACION DE ESTA CAJA EN ESTE DIA');

end;

//--- Inicio Metodo Antonio rellenado combo TIENDA ---
procedure TFCaja.Edit19Enter(Sender: TObject);
var
 TxtQuery: String;
begin
   ComboBox2.Visible:=True;
   ComboBox2.BringToFront;
   TxtQuery:='SELECT T0, T1 FROM tiendas ORDER BY T1';
   CargaValoresEnComboCambiable(TxtQuery, ComboBox2, ZQTienda, Label3variable2);
end;

procedure TFCaja.ComboBox2Click(Sender: TObject);
var TxtCampo: string;
begin
  TxtCampo:='T1';
  EscogeNombreComboCambiable( TxtCampo, ComboBox2, ZQTienda, Edit19, StaticText106);
end;

procedure TFCaja.ComboBox2KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   Begin
        ComboBox2Click(ComboBox2);
        ComboBox2.Visible:=False;
   end;
end;
//--- Fin Metodo Antonio rellenado combo PUESTO ---

//--- Inicio Metodo Antonio rellenado combo CAJA ---
procedure TFCaja.Edit20Enter(Sender: TObject);
var
 TxtQuery: String;
begin
   ComboBox3.Visible:=True;
   ComboBox3.BringToFront;
   TxtQuery:='SELECT PT0, PT1 FROM puestos'+tienda+' ORDER BY PT1';
   CargaValoresEnComboCambiable(TxtQuery, ComboBox3, ZQCaja, Label3variable2);
end;

procedure TFCaja.ComboBox3Click(Sender: TObject);
var TxtCampo: string;
begin
  TxtCampo:='PT1';
  EscogeNombreComboCambiable( TxtCampo, ComboBox3, ZQCaja, Edit20, StaticText113);
end;

procedure TFCaja.ComboBox3KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
   Begin
        ComboBox3Click(ComboBox3);
        ComboBox3.Visible:=False;
   end;
end;

procedure TFCaja.DateEdit1Change(Sender: TObject);
begin
  DateEdit2.Date:=DateEdit1.Date;
end;

procedure TFCaja.DateEdit2Change(Sender: TObject);
begin
  DateEdit3.Date:=DateEdit2.Date+1;
  if DayOfWeek(DateEdit3.Date)=1 then
    begin
     DateEdit3.Date:=DateEdit3.Date+1;
//--     showmessage('Hoy es sabado, se almacena cambio para el lunes');
    end;
end;

//--- Fin Metodo Antonio rellenado combo PUESTO ---

//==================== RECALCULA Y REPINTA LA INFORMACION DE CAJA =========
function TFCaja.SeleccionarFechaCaja(
  out AFecha: TDateTime): Boolean;
var
  F: TForm;
  LTitulo, LInfo: TLabel;
  Fecha: TDateEdit;
  BtnAceptar, BtnCancelar: TButton;
  R: TModalResult;
begin
  Result := False;
  AFecha := Date;

  F := TForm.CreateNew(Self, 1);
  try
    F.Caption := 'Buscar caja por fecha';
    F.BorderStyle := bsDialog;
    F.Position := poScreenCenter;
    F.ClientWidth := 420;
    F.ClientHeight := 190;
    F.Color := $00F0EBE4;

    LTitulo := TLabel.Create(F);
    LTitulo.Parent := F;
    LTitulo.SetBounds(24, 18, 372, 28);
    LTitulo.AutoSize := False;
    LTitulo.Caption := 'LOCALIZAR UNA CAJA GUARDADA';
    LTitulo.Font.Name := 'Sans';
    LTitulo.Font.Height := -16;
    LTitulo.Font.Style := [fsBold];
    LTitulo.Font.Color := clNavy;

    LInfo := TLabel.Create(F);
    LInfo.Parent := F;
    LInfo.SetBounds(24, 54, 372, 22);
    LInfo.AutoSize := False;
    LInfo.Caption := 'Puesto actual: ' + StaticText95.Caption;
    LInfo.Font.Name := 'Sans';
    LInfo.Font.Height := -12;
    LInfo.Font.Color := clGray;

    Fecha := TDateEdit.Create(F);
    Fecha.Parent := F;
    Fecha.Left := 24;
    Fecha.Top := 86;
    Fecha.Width := 180;
    Fecha.DateOrder := doDMY;
    Fecha.DateFormat := 'dd/mm/yyyy';
    Fecha.DefaultToday := True;
    Fecha.DirectInput := True;
    Fecha.ButtonOnlyWhenFocused := False;
    Fecha.FocusOnButtonClick := False;
    Fecha.ButtonHint := 'Seleccionar fecha en el calendario';
    Fecha.ShowHint := True;
    Fecha.TabOrder := 0;

    if DateEdit2.Date > 0 then
      Fecha.Date := DateEdit2.Date
    else
      Fecha.Date := Date;

    BtnAceptar := TButton.Create(F);
    BtnAceptar.Parent := F;
    BtnAceptar.SetBounds(216, 84, 88, 32);
    BtnAceptar.Caption := 'Aceptar';
    BtnAceptar.ModalResult := mrOK;
    BtnAceptar.Default := True;
    BtnAceptar.TabOrder := 1;

    BtnCancelar := TButton.Create(F);
    BtnCancelar.Parent := F;
    BtnCancelar.SetBounds(310, 84, 86, 32);
    BtnCancelar.Caption := 'Cancelar';
    BtnCancelar.ModalResult := mrCancel;
    BtnCancelar.Cancel := True;
    BtnCancelar.TabOrder := 2;

    repeat
      F.ModalResult := mrNone;
      R := F.ShowModal;

      if R <> mrOK then
        Exit;

      if TryStrToDate(Trim(Fecha.Text), AFecha) then
      begin
        Result := True;
        Exit;
      end;

      ShowMessage('LA FECHA INDICADA NO ES VÁLIDA.');
    until False;
  finally
    F.Free;
  end;
end;

procedure TFCaja.BitBtn26Click(Sender: TObject);
var
  FechaCaja: TDateTime;
  Q: TZQuery;
begin
  if not SeleccionarFechaCaja(FechaCaja) then
    Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := dbCajas.Connection;
    Q.SQL.Text :=
      'SELECT * FROM `arqueos' + Tienda + '` ' +
      'WHERE fecha=:FECHA AND CAJA=:CAJA';
    Q.ParamByName('FECHA').AsDateTime := FechaCaja;
    Q.ParamByName('CAJA').AsString := Trim(StaticText95.Caption);

    try
      Q.Open;
    except
      on E: Exception do
      begin
        ShowMessage(
          'NO SE PUDO LOCALIZAR LA CAJA.' + LineEnding +
          E.Message
        );
        Exit;
      end;
    end;

    if Q.IsEmpty then
    begin
      ShowMessage(
        'NO HAY NINGUNA CAJA GUARDADA PARA EL DÍA ' +
        FormatDateTime('dd/mm/yyyy', FechaCaja) + LineEnding +
        'EN EL PUESTO ' + StaticText95.Caption + '.'
      );
      Exit;
    end;
  finally
    Q.Free;
  end;

  // Actualiza el periodo visible y carga el arqueo almacenado.
  // DateEdit1Change mantiene sincronizada la fecha Hasta y
  // DateEdit2Change calcula el día del cambio.
  DateEdit1.Date := FechaCaja;
  DateEdit2.Date := FechaCaja;

  dbCajas.Close;
  dbCajas.SQL.Text :=
    'SELECT * FROM `arqueos' + Tienda + '` ' +
    'WHERE fecha=:FECHA AND CAJA=:CAJA';
  dbCajas.ParamByName('FECHA').AsDateTime := FechaCaja;
  dbCajas.ParamByName('CAJA').AsString := Trim(StaticText95.Caption);

  try
    dbCajas.Open;
  except
    on E: Exception do
    begin
      ShowMessage(
        'LA CAJA EXISTE, PERO NO SE PUDO CARGAR.' + LineEnding +
        E.Message
      );
      Exit;
    end;
  end;

  LimpiaForm();
  Relleno();
  CuentaCaja();

  PageControl1.ActivePage := TabSheet1;
  StaticText94.Caption :=
    'CAJA ' + FormatDateTime('dd/mm/yyyy', FechaCaja);

  // Queda preparada para usar el botón Imprimir original.
end;

procedure TFCaja.BitBtn11Click(Sender: TObject);
begin
//--- Recalcula y repinta la informacion sobre la caja con los nuevos datos si los hay, (caso de tener que repetir el arqueo de un dia ya hecho)
   RellenoInfo();
end;

procedure TFCaja.BitBtn12Click(Sender: TObject);
var
  ImportePropuesto, ImporteExistente, ImporteConfirmado: Double;
  YaExiste: Boolean;
begin
//--- Propone el cambio calculado, permite corregirlo y solo lo guarda tras confirmar.

     if DateEdit3.Text = '' then
     begin
       ShowMessage('Indique primero la fecha para la que se anotará el cambio.');
       Exit;
     end;

     ImportePropuesto := ValorNumericoSeguro(StaticText86.Caption);

     dbACaja.Active:=false;
     dbACaja.Sql.text:='select * from cajas' + Tienda + ' where ca1="9999" and ca3="9999" and ca0="' + FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit3.Text)) + '" and ca2="' + StaticText95.Caption + '"';
     dbACaja.Active:=true;

     YaExiste := dbACaja.RecordCount > 0;
     ImporteExistente := 0;
     if YaExiste then
       ImporteExistente := dbACaja.FieldByName('CA16').AsFloat;

     if not SolicitarImporteCambio(ImportePropuesto, ImporteExistente,
       YaExiste, ImporteConfirmado) then
     begin
       StaticText94.Caption := 'CAMBIO NO ANOTADO';
       Exit;
     end;

     if not YaExiste then
       dbACaja.Append
     else
       dbACaja.Edit;
     ICambio(ImporteConfirmado);
     dbACaja.Post;
     dbACaja.ApplyUpdates;

     StaticText94.Caption:='CAMBIO CONFIRMADO';
     keyloger('Cambio confirmado para ' + DateEdit3.Text,
       FormatFloat('0.00', ImporteConfirmado));

end;

//============== BUSCAR ARQUEOS ANTERIORES ==================
procedure TFCaja.BitBtn9Click(Sender: TObject);
begin
  If DateEdit1.Text='' then exit; If DateEdit2.Text = '' then Exit;
  If DateEdit1.Date > DateEdit2.Date then DateEdit1.Date := DateEdit2.Date; // -- Control de que el arqueo entre fechas sea correcto
  
//--- Selecciona una caja de un dia anterior para visualizarla o modificarla
  dbCajas.Sql.Text:='SELECT * FROM arqueos'+Tienda+' WHERE fecha="'+  FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text)) +'" and CAJA="'+StaticText95.Caption+'"';
  dbCajas.Active := True;

  Relleno();
  CuentaCaja();
end;

procedure TFCaja.BitBtn8Click(Sender: TObject); //--- Indica desde que dia se hara el arqueo, y en caso de ser mayor que el dia hasta, actualiza las fechas
begin
  If DateEdit1.Text ='' then exit; If DateEdit2.Text='' then Exit;
  If DateEdit1.Date > DateEdit2.Date then
   Begin
    DateEdit2.Date := DateEdit1.Date; // -- Control de que el arqueo entre fechas sea correcto
    DateEdit3.Date := DateEdit2.Date + 1;
    RellenoInfo();
   End;
end;

procedure TFCaja.BitBtn10Click(Sender: TObject); //--- No se permite almacenar el arqueo con una fecha anterior a la del mismo
begin
    If DateEdit3.Date > DateEdit2.Date then Exit;
    If DateEdit3.Date > DateEdit1.Date then Exit;
    Showmessage('ESA FECHA NO ES UNA FECHA VALIDA PARA ANOTAR EL CAMBIO');
    DateEdit3.Date := DateEdit2.Date + 1;
end;

//===================== LIMPIAR DATOS =======================
Procedure TFCaja.LimpiaForm();
Begin
//--- Trabajo con el conteo de monedas
  Edit1.Text:=''; Edit2.Text:=''; Edit3.Text:=''; Edit4.Text:='';
  Edit5.Text:=''; Edit6.Text:=''; Edit7.Text:=''; Edit8.Text:='';
  Edit9.Text:=''; Edit10.Text:=''; Edit11.Text:=''; Edit12.Text:='';
  Edit13.Text:=''; Edit14.Text:=''; Edit15.Text:=''; Edit16.Text:='';
  Edit17.Text:=''; StaticText95.Caption:=Puesto ; StaticText94.Caption:='SIN ESTADO';;
  DateEdit1.Date:=Date;
  DateEdit2.Date:=Date;
  DateEdit3.Date:=Date+1;
  StaticText68.Caption:=''; StaticText69.Caption:=''; StaticText70.Caption:='';
  StaticText71.Caption:=''; StaticText72.Caption:=''; StaticText73.Caption:='';
  StaticText74.Caption:=''; StaticText75.Caption:=''; StaticText109.Caption:='';
  Memo1.Text:='';
  Edit9.SetFocus;
End;

//===================== PINTAR DATOS =======================
Procedure TFCaja.Relleno();
Begin

//---- Pinta los datos del conteo de monedas
  if dbCajas.RecordCount=0 then exit;

  DateEdit2.Date:=dbCajas.FieldByName('fecha').AsDateTime; //------- Fecha del Arqueo
  StaticText95.Caption:=dbCajas.FieldByName('CAJA').AsString; //---- Puesto de Trabajo del Arqueo

  Edit1.Text:=dbCajas.FieldByName('C2E').AsString;//---------------- Monedas de 2    Euros
  Edit2.Text:=dbCajas.FieldByName('C1E').AsString;//---------------- Monedas de 1    Euro
  Edit3.Text:=dbCajas.FieldByName('C05E').AsString;//--------------- Monedas de 0.50 Euros
  Edit4.Text:=dbCajas.FieldByName('C02E').AsString;//--------------- Monedas de 0.20 Euros
  Edit5.Text:=dbCajas.FieldByName('C01E').AsString;//--------------- Monedas de 0.10 Euros
  Edit6.Text:=dbCajas.FieldByName('C005E').AsString;//-------------- Monedas de 0.05 Euros
  Edit7.Text:=dbCajas.FieldByName('C002E').AsString;//-------------- Monedas de 0.02 Euros
  Edit8.Text:=dbCajas.FieldByName('C001E').AsString;//-------------- Monedas de 0.01 Euros

  //----------- Billetes del Arqueo y Otros --------
  Edit9.Text:=dbCajas.FieldByName('C500E').AsString;//-------------- Billetes de 500 Euros
  Edit10.Text:=dbCajas.FieldByName('C200E').AsString;//------------- Billetes de 200 Euros
  Edit11.Text:=dbCajas.FieldByName('C100E').AsString;//------------- Billetes de 100 Euros
  Edit12.Text:=dbCajas.FieldByName('C50E').AsString;//-------------- Billetes de  50 Euros
  Edit13.Text:=dbCajas.FieldByName('C20E').AsString;//-------------- Billetes de  20 Euros
  Edit14.Text:=dbCajas.FieldByName('C10E').AsString;//-------------- Billetes de  10 Euros
  Edit15.Text:=dbCajas.FieldByName('C5E').AsString;//--------------- Billetes de   5 Euros
  Edit16.Text:=dbCajas.FieldByName('CTALONES').AsString;//---------- Importe en TALONES, en Euros
  Edit17.Text:=dbCajas.FieldByName('CTARJETAS').AsString;//--------- Importe en TARJETAS, en Euros

  //----------- Informacion sobre el Arqueo y Otros --------
  DateEdit1.Date:=dbCajas.FieldByName('FDESDE').AsDateTime;//------- Fecha desde la que se realiza el Arqueo de Caja
  DateEdit2.Date:=dbCajas.FieldByName('FHASTA').AsDateTime;//------- Fecha hasta la que se realiza el Arqueo de Caja
  DateEdit3.Date:=dbCajas.FieldByName('FCAMBIO').AsDateTime;//------- Fecha para la que se va ha anotar el cambio
  StaticText68.Caption:=dbCajas.FieldByName('IEFECTIVO').AsString;//--- Importe en Efectivo (Billetes y Monedas) que debia haber
  StaticText69.Caption:=dbCajas.FieldByName('ITT').AsString;//--------- Importe en Tarjetas y Talones que debia haber
  StaticText70.Caption:=dbCajas.FieldByName('NTT').AsString;//--------- Numero de Tarjetas y Talones que debia haber
  StaticText71.Caption:=dbCajas.FieldByName('CANT').AsString;//-------- Cambio Anterior ultimo antes del arqueo para tener en cuenta



  StaticText72.Caption:=dbCajas.FieldByName('TOTALC').AsString;//------ TOTAL EN CAJA que debia hber
  StaticText73.Caption:=dbCajas.FieldByName('ENTREGAS').AsString;//---- Total Entrgas a Cuenta Realizadas entre los dias del arqueo
  StaticText74.Caption:=dbCajas.FieldByName('DEUDASP').AsString;//----- Total Ventas a Credito entre los dias del arqueo
  StaticText75.Caption:=dbCajas.FieldByName('NALB').AsString;//-------- Numero de Albaranes realizados entre los dias del Arqueo

  //----------- Información Extra --------
  Memo1.Text:=dbCajas.FieldByName('INCIDENCIA').AsString;//-------------- Posibles incidencias en la venta del día (Metereología y varios)
  StaticText94.Caption:='ACTUALIZADO';
  ActualizarResumenMovimientos;
End;

Procedure TFCaja.RellenoInfo();
Begin
//---- Pinta los datos de informacion de las ventas

  dbACaja.Active:=False;
  dbACaja.SQL.Text:='select CA0,CA2,SUM(CA11) AS UNIALB,SUM(CA13) AS UNITAR,SUM(CA14) AS IMPTAR,';
  dbACaja.SQL.Text:= dbACaja.SQL.Text +'SUM(CA5)+SUM(CA7)-SUM(CA12)-SUM(CA14)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TOTAL,';
  dbACaja.SQL.Text:= dbACaja.SQL.Text + 'SUM(CA5)+SUM(CA7)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TTOTAL,';
  dbACaja.SQL.Text:= dbACaja.SQL.Text + 'SUM(CA16) AS SALDOINI,SUM(CA20) AS DEUDAS,SUM(CA22) AS ENTREGAS';
  dbACaja.SQL.Text:= dbACaja.SQL.Text + ' from cajas' + Tienda + ' where (CA0 >= "' + FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text)) +'" and CA0 <= "' + FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text)) +'") and (CA2 = "' + StaticText95.Caption + '" ) GROUP BY CA2';
  dbACaja.Active:=True;
  
  if dbACaja.RecordCount=0 then
    Begin
//--- Puesta a Cero de todos los campos mostrados
       StaticText68.Caption:='0.00';//--------------- Importe de las ventas en EFECTIVO
       StaticText69.Caption:='0.00';//--------------- Importe de las ventas en Tarjetas y Talones
       StaticText70.Caption:='0';//--------------- Nº de Ventas con Tarjeta o Talon
       StaticText71.Caption:='0.00';//--------------- Cambio en Caja del dia anterior
       StaticText72.Caption:='0.00';//--------------- Total en Caja (Efectivo + Talones + Tarjetas)
       StaticText73.Caption:='0.00';//--------------- Importe de Entregas a cuenta de los Clientes
       StaticText74.Caption:='0.00';//--------------- Importe de Ventas a Credito
       StaticText75.Caption:='0';//--------------- Nº de Albaranes realizados
       StaticText109.Caption:='0.00';//-------------- Importe Puntos de fidelización
       ActualizarResumenMovimientos;
       CuentaCaja();
       Exit;
    End;

  StaticText68.Caption:=dbACaja.Fields[5].AsString;//--------------- Importe de las ventas en EFECTIVO
  StaticText69.Caption:=dbACaja.Fields[4].AsString;//--------------- Importe de las ventas en Tarjetas y Talones
  StaticText70.Caption:=dbACaja.Fields[3].AsString;//--------------- Nº de Ventas con Tarjeta o Talon
  StaticText71.Caption:=dbACaja.Fields[7].AsString;//--------------- Cambio en Caja del dia anterior
  StaticText72.Caption:=dbACaja.Fields[6].AsString;//--------------- Total en Caja (Efectivo + Talones + Tarjetas)
  StaticText73.Caption:=dbACaja.Fields[9].AsString;//--------------- Importe de Entregas a cuenta de los Clientes
  StaticText74.Caption:=dbACaja.Fields[8].AsString;//--------------- Importe de Ventas a Credito
  StaticText75.Caption:=dbACaja.Fields[2].AsString;//--------------- Nº de Albaranes realizados

  ActualizarResumenMovimientos;
  CuentaCaja();
  
End;

//===================== RELLENAR DATOS =======================
Procedure TFCaja.LlenaReg();
Begin

//--- Trabajo con el conteo de monedas

  dbCajas.FieldByName('fecha').AsDateTime:=DateEdit2.Date;//-------- Fecha del Arqueo de Caja
  dbCajas.FieldByName('CAJA').AsString:=StaticText95.Caption;//----- Puesto del que se realiza el arqueo (CAJA A,B o C)

  //---------- Cambio para anotar ------------------
  dbCajas.FieldByName('C2E').AsString:=Edit1.Text;//---------------- Monedas de 2    Euros
  dbCajas.FieldByName('C1E').AsString:=Edit2.Text;//---------------- Monedas de 1    Euro
  dbCajas.FieldByName('C05E').AsString:=Edit3.Text;//--------------- Monedas de 0.50 Euros
  dbCajas.FieldByName('C02E').AsString:=Edit4.Text;//--------------- Monedas de 0.20 Euros
  dbCajas.FieldByName('C01E').AsString:=Edit5.Text;//--------------- Monedas de 0.10 Euros
  dbCajas.FieldByName('C005E').AsString:=Edit6.Text;//-------------- Monedas de 0.05 Euros
  dbCajas.FieldByName('C002E').AsString:=Edit7.Text;//-------------- Monedas de 0.02 Euros
  dbCajas.FieldByName('C001E').AsString:=Edit8.Text;//-------------- Monedas de 0.01 Euros
  
  //----------- Billetes del Arqueo y Otros --------
  dbCajas.FieldByName('C500E').AsString:=Edit9.Text;//-------------- Billetes de 500 Euros
  dbCajas.FieldByName('C200E').AsString:=Edit10.Text;//------------- Billetes de 200 Euros
  dbCajas.FieldByName('C100E').AsString:=Edit11.Text;//------------- Billetes de 100 Euros
  dbCajas.FieldByName('C50E').AsString:=Edit12.Text;//-------------- Billetes de  50 Euros
  dbCajas.FieldByName('C20E').AsString:=Edit13.Text;//-------------- Billetes de  20 Euros
  dbCajas.FieldByName('C10E').AsString:=Edit14.Text;//-------------- Billetes de  10 Euros
  dbCajas.FieldByName('C5E').AsString:=Edit15.Text;//--------------- Billetes de   5 Euros
  dbCajas.FieldByName('CTALONES').AsString:=Edit16.Text;//---------- Importe en TALONES, en Euros
  dbCajas.FieldByName('CTARJETAS').AsString:=Edit17.Text;//--------- Importe en TARJETAS, en Euros

  //----------- Informacion sobre el Arqueo y Otros --------
  dbCajas.FieldByName('FDESDE').AsDateTime:=DateEdit1.Date;//------- Fecha desde la que se realiza el Arqueo de Caja
  dbCajas.FieldByName('FHASTA').AsDateTime:=DateEdit2.Date;//------- Fecha hasta la que se realiza el Arqueo de Caja
  dbCajas.FieldByName('FCAMBIO').AsDateTime:=DateEdit3.Date;//------- Fecha para la que se va ha anotar el cambio
  dbCajas.FieldByName('IEFECTIVO').AsString:=StaticText68.Caption;//--- Importe en Efectivo (Billetes y Monedas) que debia haber
  dbCajas.FieldByName('ITT').AsString:=StaticText69.Caption;//--------- Importe en Tarjetas y Talones que debia haber
  dbCajas.FieldByName('NTT').AsString:=StaticText70.Caption;//--------- Numero de Tarjetas y Talones que debia haber
  dbCajas.FieldByName('CANT').AsString:=StaticText71.Caption;//-------- Cambio Anterior ultimo antes del arqueo para tener en cuenta
  dbCajas.FieldByName('TOTALC').AsString:=StaticText72.Caption;//------ TOTAL EN CAJA que debia hber
  dbCajas.FieldByName('ENTREGAS').AsString:=StaticText73.Caption;//---- Total Entrgas a Cuenta Realizadas entre los dias del arqueo
  dbCajas.FieldByName('DEUDASP').AsString:=StaticText74.Caption;//----- Total Ventas a Credito entre los dias del arqueo
  dbCajas.FieldByName('NALB').AsString:=StaticText75.Caption;//-------- Numero de Albaranes realizados entre los dias del Arqueo

  //----------- Información Extra --------
  dbCajas.FieldByName('INCIDENCIA').AsString:=Memo1.Text;//-------------- Posibles incidencias en la venta del día (Metereología y varios)

End;

Procedure TFCaja.ICambio(const AImporte: Double);
Begin
  dbACaja.FieldByName('CA0').AsDateTime:=DateEdit3.Date;//-------- Fecha para insertar el Cambio
  dbACaja.FieldByName('CA1').AsString:='9999';//-------- Indica que es linea de Cambio
  dbACaja.FieldByName('CA3').AsString:='9999';//-------- Indica que es linea de Cambio
{ NO SE PUEDE HACER UNA ANOTACIÓN INCREMENTAL, PUES CADA VEZ QUE PULSES EL BOTÓN VUELVE A SUMAR LA CANTIDAD
  if dbACaja.RecordCount=0 then
    begin
      dbACaja.FieldByName('CA16').AsString:=StaticText86.Caption;//-------- Importe del Cambio si NO hay ningún PAGO ANOTADO
    end
  else
    begin
      dbACaja.FieldByName('CA16').AsString:=FloatToStr(StrToFloat(dbACaja.FieldByName('CA16').AsString)+StrToFloat(StaticText86.Caption));//-------- Importe del Cambio si hay algún PAGO ANOTADO
    end;
 NO SE PUEDE HACER UNA ANOTACIÓN INCREMENTAL, PUES CADA VEZ QUE PULSES EL BOTÓN VUELVE A SUMAR LA CANTIDAD }
  dbACaja.FieldByName('CA16').AsFloat:=AImporte;//-------- Importe confirmado por el usuario para el cambio.

  dbACaja.FieldByName('CA2').AsString:=StaticText95.Caption;//-------- Puesto para el que se inserta el Cambio en Caja
End;

//=============== CONTROL DE TECLAS PULSADAS PARA CAMBIO DE CAMPOS, ETC ===========================
procedure TFCaja.Edit1KeyPress(Sender: TObject; var Key: char);
begin
     key:=compruebatecla(key); // -- Las funciones OnKeyPress de todos los campos Edit, estan asociados a este mismo procedimiento, no siendo necesario crear un procedimiento por cada campo
end;

procedure TFCaja.Edit17KeyPress(Sender: TObject; var Key: char);
begin
     key:=compruebateclanegativo(key); // -- Las funciones OnKeyPress de todos los campos Edit, estan asociados a este mismo procedimiento, no siendo necesario crear un procedimiento por cada campo
end;

procedure TFCaja.Edit9Exit(Sender: TObject); // -- Las funciones EditXExit de todos los campos Edit del 1 al 18, están asociados a este mismo procedimiento, no siendo necesario crear un procedimiento por cada campo
begin
    CuentaCaja();// -- CALCULAR INFORMACION DE VENTAS (cuadre o descuadre de caja, se actualiza en tiempo real)
//-- Caja
    keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
//-- Fechas
    keyloger('=============== NUEVO ',' APUNTE =============');
    keyloger('Desde : ',DateEdit1.Text);
    keyloger('Hasta : ',DateEdit2.Text);
    keyloger('Cambio : ',DateEdit3.Text);
//-- Billetes
    keyloger('############### Billetes ##############',TimeToStr(Time));
    if Edit9.Text<>'' then keyloger(StaticText1.Caption, Edit9.Text);
end;

procedure TFCaja.Edit10Exit(Sender: TObject);
begin
  //-- Caja
      keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
      keyloger('=============== NUEVO ',' APUNTE =============');
      keyloger('Desde : ',DateEdit1.Text);
      keyloger('Hasta : ',DateEdit2.Text);
      keyloger('Cambio : ',DateEdit3.Text);
  //-- Billetes
      keyloger('############### Billetes ##############',TimeToStr(Time));
      if Edit9.Text<>'' then keyloger(StaticText1.Caption, Edit9.Text);
    if Edit10.Text<>'' then keyloger(StaticText2.Caption, Edit10.Text);
end;

procedure TFCaja.Edit11Exit(Sender: TObject);
begin
  //-- Caja
      keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
      keyloger('=============== NUEVO ',' APUNTE =============');
      keyloger('Desde : ',DateEdit1.Text);
      keyloger('Hasta : ',DateEdit2.Text);
      keyloger('Cambio : ',DateEdit3.Text);
  //-- Billetes
      keyloger('############### Billetes ##############',TimeToStr(Time));
      if Edit9.Text<>'' then keyloger(StaticText1.Caption, Edit9.Text);
    if Edit11.Text<>'' then keyloger(StaticText3.Caption, Edit11.Text);
end;

procedure TFCaja.Edit12Exit(Sender: TObject);
begin
  //-- Caja
      keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
      keyloger('=============== NUEVO ',' APUNTE =============');
      keyloger('Desde : ',DateEdit1.Text);
      keyloger('Hasta : ',DateEdit2.Text);
      keyloger('Cambio : ',DateEdit3.Text);
  //-- Billetes
      keyloger('############### Billetes ##############',TimeToStr(Time));
      if Edit9.Text<>'' then keyloger(StaticText1.Caption, Edit9.Text);
    if Edit12.Text<>'' then keyloger(StaticText4.Caption, Edit12.Text);
end;

procedure TFCaja.Edit13Exit(Sender: TObject);
begin
  //-- Caja
      keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
      keyloger('=============== NUEVO ',' APUNTE =============');
      keyloger('Desde : ',DateEdit1.Text);
      keyloger('Hasta : ',DateEdit2.Text);
      keyloger('Cambio : ',DateEdit3.Text);
  //-- Billetes
      keyloger('############### Billetes ##############',TimeToStr(Time));
      if Edit9.Text<>'' then keyloger(StaticText1.Caption, Edit9.Text);
    if Edit13.Text<>'' then keyloger(StaticText5.Caption, Edit13.Text);
end;

procedure TFCaja.Edit14Exit(Sender: TObject);
begin
  //-- Caja
      keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
      keyloger('=============== NUEVO ',' APUNTE =============');
      keyloger('Desde : ',DateEdit1.Text);
      keyloger('Hasta : ',DateEdit2.Text);
      keyloger('Cambio : ',DateEdit3.Text);
  //-- Billetes
      keyloger('############### Billetes ##############',TimeToStr(Time));
      if Edit9.Text<>'' then keyloger(StaticText1.Caption, Edit9.Text);
    if Edit14.Text<>'' then keyloger(StaticText6.Caption, Edit14.Text);
end;

procedure TFCaja.Edit15Exit(Sender: TObject);
begin
  //-- Caja
      keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
      keyloger('=============== NUEVO ',' APUNTE =============');
      keyloger('Desde : ',DateEdit1.Text);
      keyloger('Hasta : ',DateEdit2.Text);
      keyloger('Cambio : ',DateEdit3.Text);
  //-- Billetes
      keyloger('############### Billetes ##############',TimeToStr(Time));
      if Edit9.Text<>'' then keyloger(StaticText1.Caption, Edit9.Text);
    if Edit15.Text<>'' then keyloger(StaticText7.Caption, Edit15.Text);
end;

procedure TFCaja.Edit16Exit(Sender: TObject);
begin
  //-- Caja
       keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
       keyloger('=============== NUEVO ',' APUNTE =============');
       keyloger('Desde : ',DateEdit1.Text);
       keyloger('Hasta : ',DateEdit2.Text);
       keyloger('Cambio : ',DateEdit3.Text);
  //-- Tarjetas y Talones
      keyloger('Tarjetas y Talones',TimeToStr(Time));
    if Edit16.Text<>'' then keyloger(StaticText8.Caption, Edit16.Text);
end;

procedure TFCaja.Edit17Exit(Sender: TObject);
begin
//-- Caja
     keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
//-- Fechas
     keyloger('=============== NUEVO ',' APUNTE =============');
     keyloger('Desde : ',DateEdit1.Text);
     keyloger('Hasta : ',DateEdit2.Text);
     keyloger('Cambio : ',DateEdit3.Text);
//-- Tarjetas y Talones
     keyloger('Tarjetas y Talones',TimeToStr(Time));
     if Edit17.Text<>'' then keyloger(StaticText17.Caption, Edit17.Text);
end;

procedure TFCaja.Edit1Exit(Sender: TObject);
begin
  //-- Caja
      keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
      keyloger('=============== NUEVO ',' APUNTE =============');
      keyloger('Desde : ',DateEdit1.Text);
      keyloger('Hasta : ',DateEdit2.Text);
      keyloger('Cambio : ',DateEdit3.Text);
  //-- Monedas
      keyloger('************** Monedas ****************',TimeToStr(Time));
    if Edit1.Text<>'' then keyloger(StaticText9.Caption, Edit1.Text);
end;

procedure TFCaja.Edit2Exit(Sender: TObject);
begin
  //-- Caja
      keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
      keyloger('=============== NUEVO ',' APUNTE =============');
      keyloger('Desde : ',DateEdit1.Text);
      keyloger('Hasta : ',DateEdit2.Text);
      keyloger('Cambio : ',DateEdit3.Text);
  //-- Monedas
      keyloger('************** Monedas ****************',TimeToStr(Time));
    if Edit2.Text<>'' then keyloger(StaticText10.Caption, Edit2.Text);
end;

procedure TFCaja.Edit3Exit(Sender: TObject);
begin
  //-- Caja
      keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
      keyloger('=============== NUEVO ',' APUNTE =============');
      keyloger('Desde : ',DateEdit1.Text);
      keyloger('Hasta : ',DateEdit2.Text);
      keyloger('Cambio : ',DateEdit3.Text);
  //-- Monedas
      keyloger('************** Monedas ****************',TimeToStr(Time));
    if Edit3.Text<>'' then keyloger(StaticText11.Caption, Edit3.Text);
end;

procedure TFCaja.Edit4Exit(Sender: TObject);
begin
  //-- Caja
      keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
      keyloger('=============== NUEVO ',' APUNTE =============');
      keyloger('Desde : ',DateEdit1.Text);
      keyloger('Hasta : ',DateEdit2.Text);
      keyloger('Cambio : ',DateEdit3.Text);
  //-- Monedas
      keyloger('************** Monedas ****************',TimeToStr(Time));
    if Edit4.Text<>'' then keyloger(StaticText12.Caption, Edit4.Text);
end;

procedure TFCaja.Edit5Exit(Sender: TObject);
begin
  //-- Caja
      keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
      keyloger('=============== NUEVO ',' APUNTE =============');
      keyloger('Desde : ',DateEdit1.Text);
      keyloger('Hasta : ',DateEdit2.Text);
      keyloger('Cambio : ',DateEdit3.Text);
  //-- Monedas
      keyloger('************** Monedas ****************',TimeToStr(Time));
    if Edit5.Text<>'' then keyloger(StaticText13.Caption, Edit5.Text);
end;

procedure TFCaja.Edit6Exit(Sender: TObject);
begin
  //-- Caja
      keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
      keyloger('=============== NUEVO ',' APUNTE =============');
      keyloger('Desde : ',DateEdit1.Text);
      keyloger('Hasta : ',DateEdit2.Text);
      keyloger('Cambio : ',DateEdit3.Text);
  //-- Monedas
      keyloger('************** Monedas ****************',TimeToStr(Time));
    if Edit6.Text<>'' then keyloger(StaticText14.Caption, Edit6.Text);
end;

procedure TFCaja.Edit7Exit(Sender: TObject);
begin
  //-- Caja
      keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
      keyloger('=============== NUEVO ',' APUNTE =============');
      keyloger('Desde : ',DateEdit1.Text);
      keyloger('Hasta : ',DateEdit2.Text);
      keyloger('Cambio : ',DateEdit3.Text);
  //-- Monedas
      keyloger('************** Monedas ****************',TimeToStr(Time));
    if Edit7.Text<>'' then keyloger(StaticText15.Caption, Edit7.Text);
end;

procedure TFCaja.Edit8Exit(Sender: TObject);
begin
  //-- Caja
      keyloger('//------------------------------ CAJA DE TRABAJO - ',StaticText95.Caption);
  //-- Fechas
      keyloger('=============== NUEVO ',' APUNTE =============');
      keyloger('Desde : ',DateEdit1.Text);
      keyloger('Hasta : ',DateEdit2.Text);
      keyloger('Cambio : ',DateEdit3.Text);
  //-- Monedas
      keyloger('************** Monedas ****************',TimeToStr(Time));
    if Edit8.Text<>'' then keyloger(StaticText16.Caption, Edit8.Text);
end;

//================= PROCEDIMIENTO KEYLOGER PARA CONTROL DE CAJA ====================================
procedure TFCaja.keyloger(moneda,cantidad:string);
var
 F : TextFile;
 fichero : string;
begin
  fichero:='';
  if FileExists(RutaIni+'Caja_'+FormatDateTime('YYYYMMDD',(Date-10))+'.txt' ) then
    begin
      //-- borrado del fichero de hace 10 días
      fichero:=(RutaIni+'Caja_'+FormatDateTime('YYYYMMDD',(Date-10))+'.txt' );
      DeleteFile(fichero);
    end;
  AssignFile( F, RutaIni + 'Caja_'+FormatDateTime('YYYYMMDD',Date)+'.txt' );
  if FileExists(RutaIni+'Caja_'+FormatDateTime('YYYYMMDD',(Date))+'.txt' ) then Append(F) else Rewrite( F );
  WriteLn( F, 'Moneda o Billete :' + moneda +' - Cantidad existente : ' + cantidad );
  CloseFile( F );
end;


//================== INSERCION SOLO DE NUMEROS JUNTO A CONTROL TECLAS PULSADAS  ====================
function TFCaja.compruebatecla(key:char):char;
begin
      // -- Solo permite la insercion de numeros y la pulsacion de enter o teclas especiales -------
      if ( StrScan('0123456789',Key) <> nil ) or ( Key = Char(VK_BACK) )
           or  ( Key = Char(VK_TAB) )  or  ( Key = Char(VK_RETURN) ) or  ( Key = Char(VK_UP) )
           or  ( Key = Char(VK_DOWN) ) then
         begin
              CuentaCaja();// -- CALCULAR INFORMACION DE VENTAS (cuadre o descuadre de caja, se actualiza en tiempo real)
         end
      else
          begin
               Key := #0;
          end;
      if ( key = Char(VK_RETURN) ) then // -- En caso de pulsar enter, pasa al siguiente campo
         begin
              key:=#0;
              SelectNext(activecontrol,true,true);
         end;
      if ( key = Char(VK_UP) ) then // -- Si pulsamos la flecha arriba, vuelve al campo anterior
         begin
              key:=#0;
              SelectNext(activecontrol,false,true);
         end;
      if ( key = Char(VK_DOWN) ) then // -- Si pulsamos la flecha abajo, pasa al campo siguiente
         begin
              key:=#0;
              SelectNext(activecontrol,true,true);
         end;
      compruebatecla:=(key);
end;

//================== INSERCION SOLO DE NUMEROS PUNTO Y NEGATIVO JUNTO A CONTROL TECLAS PULSADAS  ====================
function TFCaja.compruebateclanegativo(key:char):char;
begin
      // -- Solo permite la insercion de numeros y la pulsacion de enter o teclas especiales -------
      if ( StrScan('0123456789.-',Key) <> nil ) or ( Key = Char(VK_BACK) )
           or  ( Key = Char(VK_TAB) )  or  ( Key = Char(VK_RETURN) ) or  ( Key = Char(VK_UP) )
           or  ( Key = Char(VK_DOWN) ) then
         begin
              If (Edit16.Text='-') or (Edit17.Text='-') then compruebateclanegativo:=(key)
              Else CuentaCaja();// -- CALCULAR INFORMACION DE VENTAS (cuadre o descuadre de caja, se actualiza en tiempo real)
         end
      else
          begin
               Key := #0;
          end;
      if ( key = Char(VK_RETURN) ) then // -- En caso de pulsar enter, pasa al siguiente campo
         begin
              key:=#0;
              SelectNext(activecontrol,true,true);
         end;
      if ( key = Char(VK_UP) ) then // -- Si pulsamos la flecha arriba, vuelve al campo anterior
         begin
              key:=#0;
              SelectNext(activecontrol,false,true);
         end;
      if ( key = Char(VK_DOWN) ) then // -- Si pulsamos la flecha abajo, pasa al campo siguiente
         begin
              key:=#0;
              SelectNext(activecontrol,true,true);
         end;
      compruebateclanegativo:=(key);
end;

//================== PESTAÑA DE LISTADOS =======================================
//==============================================================================
//================== LISTADOS DE CAJAS =========================================
//==============================================================================
procedure TFCaja.TabSheet2Enter(Sender: TObject);
begin
//  dbACaja.Active:=True;
  Edit19.Text:='0';
  DateEdit4.Date:=Date;
  DateEdit5.Date:=Date;
  DateEdit6.Date:=Date;
  DateEdit7.Date:=Date;
  Edit21.Text:= '00:00:00';
  Edit22.Text:= FormatDateTime('HH:MM:SS',Time);
{
  Panel8.Visible:=True;
  Panel9.Visible:=False;
  Panel7.Visible:=False;
}
  If ((Panel8.Visible) and (TabSheet2.Visible)) then Edit19.SetFocus;
end;

//==================== CERRAR ======================
procedure TFCaja.BitBtn18Click(Sender: TObject);
begin
  dbCajas.Active:=False;
  dbACaja.Active:=False;
  Panel8.Visible:=True;
  Panel9.Visible:=False;
  Panel7.Visible:=False;
  dbGrid1.Visible:=False;
  Close();
End;

//==================== VISUALIZAR ===================
procedure TFCaja.BitBtn14Click(Sender: TObject);
Var
  TxtQuery: String;
begin

  AntColun:='0';Ordenado:=False;
  if RadioButton1.Checked=True then
    begin

      Panel7.Visible:=True;
      Panel8.Visible:=False;
      Panel9.Visible:=False;
      dbGrid12.Visible:=True;

      TituloGrid:='LISTADO DE CAJAS (LOCALES)';
      TxtQuery:= 'select CA0,CA2,SUM(CA11) AS UNIALB,SUM(CA13) AS UNITAR,'+'SUM(CA14) AS IMPTAR,';
      TxtQuery:= TxtQuery + 'SUM(CA5)+SUM(CA7)-SUM(CA12)-SUM(CA14)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TOTAL,';
      TxtQuery:= TxtQuery + 'SUM(CA5)+SUM(CA7)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TTOTAL,';
      TxtQuery:= TxtQuery + 'SUM(CA16) AS SALDOINI,SUM(CA20) AS DEUDAS,SUM(CA22) AS ENTREGAS' + ' from cajas' + Tienda;
      TxtQuery:= TxtQuery + ' where (CA0 >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit4.Text)) + '" and CA0 <= "' + FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit5.Text)) +'")';
      If Edit20.Text<>'' then
        Begin
             TxtQuery:= TxtQuery  + ' and (CA2 = "'+ Edit20.Text + '" )'
        End;
      TxtQuery:= TxtQuery + ' GROUP BY CA0';
      dbACaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbACaja.Active:=True;
      DBGrid12.BringToFront;
    end;
//--- Solo cajas locales Desglosadas
  if RadioButton2.Checked=True then
    begin

      Panel7.Visible:=True;
      Panel8.Visible:=False;
      Panel9.Visible:=False;
      dbGrid12.Visible:=True;

      TituloGrid:='LISTADO DE CAJAS DESGLOSADAS (LOCALES)';
      TxtQuery:= 'select CA0,CA2,SUM(CA11) AS UNIALB,SUM(CA13) AS UNITAR,'+'SUM(CA14) AS IMPTAR,';
      TxtQuery:= TxtQuery + 'SUM(CA5)+SUM(CA7)-SUM(CA12)-SUM(CA14)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TOTAL,';
      TxtQuery:= TxtQuery + 'SUM(CA5)+SUM(CA7)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TTOTAL,';
      TxtQuery:= TxtQuery + 'SUM(CA16) AS SALDOINI,SUM(CA20) AS DEUDAS,SUM(CA22) AS ENTREGAS' + ' from cajas' + Tienda;
      TxtQuery:= TxtQuery + ' where (CA0 >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit4.Text)) + '" and CA0 <= "' + FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit5.Text)) +'")';
      If Edit20.Text<>'' then
        Begin
             TxtQuery:= TxtQuery  + ' and (CA2 = "'+ Edit20.Text + '" )'
        End;
      TxtQuery:= TxtQuery + ' GROUP BY CA0,CA2';
      dbACaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbACaja.Active:=True;
      DBGrid12.BringToFront;
    end;
  //--- Ver la caja de una tienda remota
  if RadioButton3.Checked=True then
    begin
      Showmessage('ESTA SELECCION AUN NO ESTA DISPONIBLE, DISCULPE LAS MOLESTIAS');
    end;
  //--- Ver la caja de todas las tiendas remotas
  if RadioButton4.Checked=True then
    begin
      Showmessage('ESTA SELECCION AUN NO ESTA DISPONIBLE, DISCULPE LAS MOLESTIAS');
    end;
  //--- Pedir la caja de una tienda remota
  if RadioButton5.Checked=True then
    begin
      Showmessage('ESTA SELECCION AUN NO ESTA DISPONIBLE, DISCULPE LAS MOLESTIAS');
    end;
  //--- Cajas por familias
  if RadioButton6.Checked=True then
    begin

      DBGrid3.Visible:=True;

      TituloGrid:='LISTADO DE CAJAS POR FAMILIAS (LOCALES)';
{
      TxtQuery:= 'select CA0,CA2,SUM(CA11) AS UNIALB,SUM(CA13) AS UNITAR,'+'SUM(CA14) AS IMPTAR,';
      TxtQuery:= TxtQuery + 'SUM(CA5)+SUM(CA7)-SUM(CA12)-SUM(CA14)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TOTAL,';
      TxtQuery:= TxtQuery + 'SUM(CA5)+SUM(CA7)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TTOTAL,';
      TxtQuery:= TxtQuery + 'SUM(CA16) AS SALDOINI,SUM(CA20) AS DEUDAS,SUM(CA22) AS ENTREGAS' + ' from cajas' + Tienda;
}
      TxtQuery:='select * from cajas' + Tienda;
      TxtQuery:= TxtQuery + ' where (CA0 >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit4.Text)) + '" and CA0 <= "' + FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit5.Text)) +'")';
      If Edit20.Text<>'' then
        Begin
             TxtQuery:= TxtQuery  + ' and (CA2 = "'+ Edit20.Text + '" )'
        End;
      TxtQuery:= TxtQuery + ' GROUP BY CA3';
      dbACaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbACaja.Active:=True;
      DBGrid3.BringToFront;
//      Showmessage('ESTA SELECCION AUN NO ESTA DISPONIBLE, DISCULPE LAS MOLESTIAS');
    end;
  //--- Cajas por puestos
  if RadioButton7.Checked=True then
    begin

      Panel7.Visible:=True;
      Panel8.Visible:=False;
      Panel9.Visible:=False;
      dbGrid12.Visible:=True;

      TituloGrid:='Cajas por puestos';
      TxtQuery:='select CA0,CA2,SUM(CA11) AS UNIALB,SUM(CA13) AS UNITAR,'+'SUM(CA14) AS IMPTAR,'+'SUM(CA5)+SUM(CA7)-SUM(CA12)-SUM(CA14)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TOTAL,';
      TxtQuery:= TxtQuery + 'SUM(CA5)+SUM(CA7)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TTOTAL,'+'SUM(CA16) AS SALDOINI,SUM(CA20) AS DEUDAS,SUM(CA22) AS ENTREGAS';
      TxtQuery:= TxtQuery +' from cajas' + Tienda + ' where (CA0 >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit6.Text)) +'" and CA0 <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit7.Text)) +'")';
      If Edit20.Text<>'' then
        Begin
             TxtQuery:= TxtQuery  + ' and (CA2 = "'+ Edit20.Text + '" )'
        End;
      TxtQuery:= TxtQuery + ' GROUP BY CA2';
      dbAcaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbAcaja.Active:=True;
     if dbACaja.RecordCount=0 then
       begin
         BitBtn15.SetFocus;
         Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
         exit;
       end;
     DBGrid12.BringToFront;
  end;
  //--- Relacion de articulos vendidos
  if RadioButton8.Checked=True then
    begin

      dbGrid1.Visible:=True;

      TituloGrid:='Listado Cajas - Relación de Articulos Vendidos';
      TxtQuery:='select * from hisopdd' + Tienda + ' where hod0 >="' + FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit4.Text));
      TxtQuery:= TxtQuery +'" and HOD0 <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit5.Text)) +'"';
      If Edit20.Text<>'' then
        Begin
             TxtQuery:= TxtQuery  + ' and (HOD2 = "'+ Edit20.Text + '" ) group by HOD7'
        End;
      dbAcaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbAcaja.Active:=True;
     if dbACaja.RecordCount=0 then
       begin
         Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
         exit;
       end;
     DBGrid1.BringToFront;
  end;
  //--- Relacion de tickets (Operaciones realizadas)
  if RadioButton9.Checked=True then
    begin

      dbGrid2.Visible:=True;

      TituloGrid:='Listado de Cajas - Relación de Ventas realizadas';
      TxtQuery:='select * from hisopcc' + Tienda + ' where HO0 >="' + FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit4.Text)) +'" and HO0 <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit5.Text)) +'"';
      TxtQuery:= TxtQuery + ' and HO1>="' + Edit21.Text + '" and HO1<="' + Edit22.Text + '"';
      If Edit20.Text<>'' then
        Begin
             TxtQuery:= TxtQuery  + ' and (HO2 = "'+ Edit20.Text + '" )'
        End;
      dbAcaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbAcaja.Active:=True;
     if dbACaja.RecordCount=0 then
       begin
         Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
         exit;
       end;
     DBGrid2.BringToFront;
  end;
  //--- Relacion de pagos realizados (AHORA REPARACIONES)
  if RadioButton10.Checked=True then
    begin

      dbGrid2.Visible:=True;

      TxtQuery:='select * from hisopcc' + Tienda + ' where HO0 >="' + FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit4.Text)) +'" and HO0 <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit5.Text)) +'"';
      If Edit20.Text<>'' then
        Begin
             TxtQuery:= TxtQuery  + ' and (HO2 = "'+ Edit20.Text + '" )'
        End;
      TxtQuery:= TxtQuery + ' and HO5="RE"';
      dbAcaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbAcaja.Active:=True;
     if dbACaja.RecordCount=0 then
       begin
         Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
         exit;
       end;
     DBGrid2.BringToFront;
  end;
  //--- Relacion de Creditos / Entregas / Vales
  if RadioButton11.Checked=True then
    begin

      dbGrid2.Visible:=True;

      TxtQuery:='select * from hisopcc' + Tienda + ' where HO0 >="' + FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit4.Text)) +'" and HO0 <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit5.Text)) +'"';
      If Edit20.Text<>'' then
        Begin
             TxtQuery:= TxtQuery  + ' and (HO2 = "'+ Edit20.Text + '" )'
        End;
      TxtQuery:= TxtQuery + ' and (HO5="EN" or HO5="CO")';
      dbAcaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbAcaja.Active:=True;
     if dbACaja.RecordCount=0 then
       begin
         Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
         exit;
       end;
     DBGrid2.BringToFront;
  end;

  If ((Panel8.Visible) or (Panel7.Visible)) then BitBtn14.SetFocus;
end;

procedure TFCaja.Button1Click(Sender: TObject);
begin
  frReport1.DesignReport;
end;

//--------------------------- PAGOS ----------------------
procedure TFCaja.BitBtn22Click(Sender: TObject);
begin
  ShowFormpagos();
end;


//============================= IMPRIMIR ==============================
//==================== ARQUEOS EN PESTAÑA PRINCIPAL ===================
procedure TFCaja.BitBtn21Click(Sender: TObject);
var
  TxtQuery, TxtQ, TxtQueryGlob, TxtQGlob, TxtQueryGlob2, TxtQGlob2:String;
  Temp1, Temp2, Temp3 : Double;
  cont: Integer;
begin
  TxtQ:='';
  TxtQuery:='';
  TxtQGlob:='';
  TxtQueryGlob:='';
  TxtQGlob2:='';
  TxtQueryGlob2:='';
  Cont:=1;

  TBilletes:='';
  TCambio:='';
  TTalTarj:='';
  TCambioA:='';

  //----------- LOS FINALES GLOB INDICAN GLOBALES, ES DECIR, NO SE SEPARA INFORMACIÓN POR CAJA,SINO QUE SE AGRUPA TODO EL COMERCIO

  //-------------------------- Datos Principales Arqueo
  TituloGrid:='Datos Principales Arqueo';
  TxtQuery:='select * from arqueos' + Tienda + ' where fecha = "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text)) + '" and CAJA="'+StaticText95.Caption+'"';
  dbACaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbACaja.Active:=True;
  if dbACaja.RecordCount=0 then
     begin
       Showmessage('LA INFORMACIÓN NO ESTÁ ALMACENADA O ESTÁ EN BLANCO');
       exit;
     end;

  TxtQueryGlob:='select * from arqueos' + Tienda + ' where fecha = "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text)) + '"';
  dbACajaGlob.Active:=False; dbACajaGlob.Sql.Text:=TxtQueryGlob; dbACajaGlob.Active:=True;

//--  TxtQ:='select sum(Base) as Base,sum(Iva) as Iva,TIva as TIva,sum(Total) as Total from iva' + Tienda + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text)) + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text)) + '" and Puesto="'+StaticText95.Caption+'" and TipoOp<>"FM" group by TIva order by TIva DESC';
//--ELIMINADA LA DISCRIMINACIÓN DE LA FACTURACIÓN, SACARÁ DATOS DE IVA DE TODAS LAS VENTAS, INCLUIDA FACTURACIÓN DE ALBARANES
  TxtQ:='select sum(Base) as Base,sum(Iva) as Iva,TIva as TIva,sum(Total) as Total from iva' + Tienda + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text)) + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text)) + '" and Puesto="'+StaticText95.Caption+'" group by TIva order by TIva DESC';
  dbIva.Active:=False; dbIva.Sql.Text:=TxtQ; dbIva.Active:=True;

  dbIva.First;
           while not dbIva.eof do
           begin
              Case Cont of
                   1 : begin Base3:=dbIva.FieldByName('Base').AsString; Iva3:= dbIva.FieldByName('Iva').AsString; TIva3:= dbIva.FieldByName('TIva').AsString; end;
                   2 : begin Base2:=dbIva.FieldByName('Base').AsString; Iva2:= dbIva.FieldByName('Iva').AsString; TIva2:= dbIva.FieldByName('TIva').AsString; end;
                   3 : begin Base1:=dbIva.FieldByName('Base').AsString; Iva1:= dbIva.FieldByName('Iva').AsString; TIva1:= dbIva.FieldByName('TIva').AsString; end;
              end;
              dbIva.Next;
              Cont:=Cont+1;
           end;

//--  TxtQGlob:='select sum(Base) as Base,sum(Iva) as Iva,TIva as TIva,sum(Total) as Total from iva' + Tienda + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text)) + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text)) + '" and TipoOp<>"FM" group by TIva order by TIva DESC';
//--ELIMINADA LA DISCRIMINACIÓN DE LA FACTURACIÓN, SACARÁ DATOS DE IVA DE TODAS LAS VENTAS, INCLUIDA FACTURACIÓN DE ALBARANES
    TxtQGlob:='select sum(Base) as Base,sum(Iva) as Iva,TIva as TIva,sum(Total) as Total from iva' + Tienda + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text)) + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text)) + '" group by TIva order by TIva DESC';
  dbIvaGlob.Active:=False; dbIvaGlob.Sql.Text:=TxtQGlob; dbIvaGlob.Active:=True;

  Cont:=1;
  dbIvaGlob.First;
           while not dbIvaGlob.eof do
           begin
              Case Cont of
                   1 : begin Base3Glob:=dbIvaGlob.FieldByName('Base').AsString; Iva3Glob:= dbIvaGlob.FieldByName('Iva').AsString; TIva3Glob:= dbIvaGlob.FieldByName('TIva').AsString; end;
                   2 : begin Base2Glob:=dbIvaGlob.FieldByName('Base').AsString; Iva2Glob:= dbIvaGlob.FieldByName('Iva').AsString; TIva2Glob:= dbIvaGlob.FieldByName('TIva').AsString; end;
                   3 : begin Base1Glob:=dbIvaGlob.FieldByName('Base').AsString; Iva1Glob:= dbIvaGlob.FieldByName('Iva').AsString; TIva1Glob:= dbIvaGlob.FieldByName('TIva').AsString; end;
              end;
              dbIvaGlob.Next;
              Cont:=Cont+1;
           end;


//  frReport2.DesignReport;
  if Base1='' then Base1:='0';
  if Base2='' then Base2:='0';
  if Base3='' then Base3:='0';
  if Iva1='' then Iva1:='0';
  if Iva2='' then Iva2:='0';
  if Iva3='' then Iva3:='0';

  if Base1Glob='' then Base1Glob:='0';
  if Base2Glob='' then Base2Glob:='0';
  if Base3Glob='' then Base3Glob:='0';
  if Iva1Glob='' then Iva1Glob:='0';
  if Iva2Glob='' then Iva2Glob:='0';
  if Iva3Glob='' then Iva3Glob:='0';


    TBases:=FloatToStr(StrToFloat(Base1)+StrToFloat(Base2)+StrToFloat(Base3));
    TIvas:=FloatToStr(StrToFloat(Iva1)+StrToFloat(Iva2)+StrToFloat(Iva3));
    VTTotal:=FloatToStr(StrToFloat(TBases)+StrToFloat(TIvas));

    TBasesGlob:=FloatToStr(StrToFloat(Base1Glob)+StrToFloat(Base2Glob)+StrToFloat(Base3Glob));
    TIvasGlob:=FloatToStr(StrToFloat(Iva1Glob)+StrToFloat(Iva2Glob)+StrToFloat(Iva3Glob));
    VTTotalGlob:=FloatToStr(StrToFloat(TBasesGlob)+StrToFloat(TIvasGlob));


  Cambio:=StaticText86.Caption;
  Billetes:=StaticText84.Caption;
  Anterior:=StaticText71.Caption;

  //--  showmessage(temp1+'-'+temp2+'-'+temp3);

  //------- CONTROL DE DATOS ECONOMICOS
  TxtQGlob2:='select fecha,sum(C2E) as C2E,sum(C1E) as C1E,sum(C05E) as C05E,sum(C02E) as C02E,sum(C01E) as C01E,sum(C005E) as C005E,sum(C002E) as C002E,sum(C001E) as C001E';
  TxtQGlob2:=TxtQGlob2 + ',sum(C500E) as C500E,sum(C200E) as C200E,sum(C100E) as C100E,sum(C50E) as C50E,sum(C20E) as C20E,sum(C10E) as C10E,sum(C5E) as C5E';
  TxtQGlob2:=TxtQGlob2 + ',sum(CTALONES) as CTALONES,sum(CTARJETAS) as CTARJETAS,sum(IEFECTIVO) as Efectivo,sum(ITT) as ImpTT,sum(NTT),sum(CANT) as CANT,sum(TOTALC) as TotalCaja';
  TxtQGlob2:=TxtQGlob2 + ',sum(ENTREGAS) as TEntregas,sum(DEUDASP),sum(NALB) from arqueos'+ Tienda;
  TxtQGlob2:=TxtQGlob2 + ' where fecha = "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text)) + '"';
  dbCajaGlob.Active:=False;dbCajaGlob.SQL.Text:=TxtQGlob2;dbCajaGlob.Active:=True;

  Temp1:=(StrToFloat(dbCajaGlob.FieldByName('C500E').AsString)*500)+(StrToFloat(dbCajaGlob.FieldByName('C200E').AsString)*200)+(StrToFloat(dbCajaGlob.FieldByName('C100E').AsString)*100)+(StrToFloat(dbCajaGlob.FieldByName('C50E').AsString)*50)+(StrToFloat(dbCajaGlob.FieldByName('C20E').AsString)*20)+(StrToFloat(dbCajaGlob.FieldByName('C10E').AsString)*10)+(StrToFloat(dbCajaGlob.FieldByName('C5E').AsString)*5);
  Temp2:=(StrToFloat(dbCajaGlob.FieldByName('C2E').AsString)*2)+(StrToFloat(dbCajaGlob.FieldByName('C1E').AsString)*1)+(StrToFloat(dbCajaGlob.FieldByName('C05E').AsString)*0.5)+(StrToFloat(dbCajaGlob.FieldByName('C02E').AsString)*0.2)+(StrToFloat(dbCajaGlob.FieldByName('C01E').AsString)*0.1)+(StrToFloat(dbCajaGlob.FieldByName('C005E').AsString)*0.05)+(StrToFloat(dbCajaGlob.FieldByName('C002E').AsString)*0.02)+(StrToFloat(dbCajaGlob.FieldByName('C001E').AsString)*0.01);
  Temp3:=StrToFloat(dbCajaGlob.FieldByName('CTALONES').AsString)+StrToFloat(dbCajaGlob.FieldByName('CTARJETAS').AsString);
  TBilletes:=FloatToStr(Temp1);
  TCambio:=FloatToStr(Temp2);
  TTalTarj:=FloatToStr(Temp3);
  TCambioA:=dbCajaGlob.FieldByName('CANT').AsString;


  frDBDataSet1.DataSet:=dbACaja;
  frReport1.LoadFromFile(RutaReports+'ListaArqueo.lrf');
  frReport1.ShowReport;
end;

procedure TFCaja.BitBtn23Click(Sender: TObject);
VAR
   PrintText:TextFile;
   F : TextFile;
   fichero : string;
begin

  //============================= KeyLog de Apertura CAJON ===============================
  //-- textoaprobación,codigo13 y descrip50, canti3,precio6,total6 añadidos por el keyloger
          fichero:='';
          if FileExists(RutaIni+'Cajon_'+FormatDateTime('YYYYMM',(Date-63))+'.txt' ) then
            begin
              //-- borrado del fichero de hace 63 días
              fichero:=(RutaIni+'Cajon_'+FormatDateTime('YYYYMM',(Date-63))+'.txt' );
              DeleteFile(fichero);
            end;
           AssignFile( F, RutaIni + 'Cajon_'+FormatDateTime('YYYYMM',Date)+'.txt' );
           if FileExists(RutaIni+'Cajon_'+FormatDateTime('YYYYMM',(Date))+'.txt' ) then Append(F) else Rewrite( F );
           WriteLn( F, '#============== APERTURA DE CAJON SIN VENTA ================');
           WriteLn( F, '#= AUTORIZACION - DESDE CAJA ARQUEO');
           WriteLn( F, 'CAJA : ' + Puesto +' - Dia : ' + FormatDateTime('YYYYMMDD',(Date)) + ' - Hora : ' + FormatDateTime('HH:MM:SS',(time)) );
           CloseFile( F );
  //============================= KeyLog de Apertura CAJON ===============================

  if trim(CgoCajon)='' then exit;
  try
   AssignFile(PrintText, DevTicket);
   Rewrite(PrintText);
   WriteLn(PrintText, PCgoCajon);
   CloseFile(PrintText);

//TODO: Falta solucionar la impresion en cola

(*    //------ Imprimir en cola
    if CmdTicket<>'' then
      begin
       TxtCmd:=PChar(String(CmdTicket+' '+DevTicket));
       libc.system(TxtCmd);
      end;
*)
  except
   DataModule1.Mensaje('Información','Revise ticketera, no se puede abrir cajón.', 2000 , clGray);
  end;
end;

procedure TFCaja.BitBtn24Click(Sender: TObject);
begin
  dbCajas.Last;
  LimpiaForm(); Relleno(); CuentaCaja();
end;

procedure TFCaja.BitBtn25Click(Sender: TObject);
begin
  dbCajas.First;
  LimpiaForm(); Relleno(); CuentaCaja();
end;


//==================== IMPRIMIR ===================
procedure TFCaja.BitBtn15Click(Sender: TObject);
var
  TxtQuery:String;
begin
  //-------------------------- Datos Principales
  //--- Solo cajas locales
  if RadioButton1.Checked=True then
    begin
      TituloGrid:='Listado de Cajas - SOLO CAJAS LOCALES';
      TxtQuery:='select CA0,CA2,SUM(CA11) AS UNIALB,SUM(CA13) AS UNITAR,'+'SUM(CA14) AS IMPTAR,'+'SUM(CA5)+SUM(CA7)-SUM(CA12)-SUM(CA14)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TOTAL,';
      TxtQuery:= TxtQuery + 'SUM(CA5)+SUM(CA7)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TTOTAL,'+'SUM(CA16) AS SALDOINI,SUM(CA20) AS DEUDAS,SUM(CA22) AS ENTREGAS';
      TxtQuery:= TxtQuery +' from cajas' + Tienda + ' where (CA0 >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit4.Text)) +'" and CA0 <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit5.Text)) +'")';
      TxtQuery:= TxtQuery + ' GROUP BY CA0';
      dbAcaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbAcaja.Active:=True;
     if dbACaja.RecordCount=0 then
       begin
         Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
         exit;
       end;
     frDBDataSet1.DataSet:=dbACaja;
     frReport1.LoadFromFile(RutaReports+'ListaCajas.lrf');
     frReport1.ShowReport;
  end;
  //--- Solo cajas locales desglosadas
  if RadioButton2.Checked=True then
    begin
      TituloGrid:='Listado de Cajas - SOLO CAJAS LOCALES - DESGLOSADAS';
      TxtQuery:='select CA0,CA2,SUM(CA11) AS UNIALB,SUM(CA13) AS UNITAR,'+'SUM(CA14) AS IMPTAR,'+'SUM(CA5)+SUM(CA7)-SUM(CA12)-SUM(CA14)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TOTAL,';
      TxtQuery:= TxtQuery + 'SUM(CA5)+SUM(CA7)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TTOTAL,'+'SUM(CA16) AS SALDOINI,SUM(CA20) AS DEUDAS,SUM(CA22) AS ENTREGAS';
      TxtQuery:= TxtQuery +' from cajas' + Tienda + ' where (CA0 >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit4.Text)) +'" and CA0 <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit5.Text)) +'")';
      If Edit20.Text<>'' then
        Begin
             TxtQuery:= TxtQuery  + ' and (CA2 = "'+ Edit20.Text + '" )'
        End;
      TxtQuery:= TxtQuery + ' GROUP BY CA0,CA2';
      dbAcaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbAcaja.Active:=True;
     if dbACaja.RecordCount=0 then
       begin
         Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
         exit;
       end;
     frDBDataSet1.DataSet:=dbACaja;
     frReport1.LoadFromFile(RutaReports+'ListaCajasDesglosadas.lrf');
     frReport1.ShowReport;
  end;
  //--- Ver la caja de una tienda remota
  if RadioButton3.Checked=True then
    begin
     if dbACaja.RecordCount=0 then
       begin
         Showmessage('ESTA SELECCION AUN NO ESTA DISPONIBLE, DISCULPE LAS MOLESTIAS');
         exit;
       end;

  end;
  //--- Ver la caja de todas las tiendas remotas
  if RadioButton4.Checked=True then
    begin
     if dbACaja.RecordCount=0 then
       begin
         Showmessage('ESTA SELECCION AUN NO ESTA DISPONIBLE, DISCULPE LAS MOLESTIAS');
         exit;
       end;

  end;
  //--- Pedir la caja de una tienda remota
  if RadioButton5.Checked=True then
    begin
     if dbACaja.RecordCount=0 then
       begin
         Showmessage('ESTA SELECCION AUN NO ESTA DISPONIBLE, DISCULPE LAS MOLESTIAS');
         exit;
       end;
  end;
  //--- Cajas por familias
  if RadioButton6.Checked=True then
    begin
     if dbACaja.RecordCount=0 then
       begin
         Showmessage('ESTA SELECCION AUN NO ESTA DISPONIBLE, DISCULPE LAS MOLESTIAS');
         exit;
       end;
  end;
  //--- Cajas por puestos
  if RadioButton7.Checked=True then
    begin
      TituloGrid:='Cajas por puestos';
      TxtQuery:='select CA0,CA2,SUM(CA11) AS UNIALB,SUM(CA13) AS UNITAR,'+'SUM(CA14) AS IMPTAR,'+'SUM(CA5)+SUM(CA7)-SUM(CA12)-SUM(CA14)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TOTAL,';
      TxtQuery:= TxtQuery + 'SUM(CA5)+SUM(CA7)+SUM(CA16)+SUM(CA17)-SUM(CA18)-SUM(CA19)-SUM(CA20)+SUM(CA21)+SUM(CA22)-SUM(CA23)-SUM(CA24) AS TTOTAL,'+'SUM(CA16) AS SALDOINI,SUM(CA20) AS DEUDAS,SUM(CA22) AS ENTREGAS';
      TxtQuery:= TxtQuery +' from cajas' + Tienda + ' where (CA0 >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit4.Text)) +'" and CA0 <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit5.Text)) +'")';
      If Edit20.Text<>'' then
        Begin
             TxtQuery:= TxtQuery  + ' and (CA2 = "'+ Edit20.Text + '" )'
        End;
      TxtQuery:= TxtQuery + ' GROUP BY CA2';
      dbAcaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbAcaja.Active:=True;
     if dbACaja.RecordCount=0 then
       begin
         BitBtn15.SetFocus;
         Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
         exit;
       end;

     frDBDataSet1.DataSet:=dbACaja;
     frReport1.LoadFromFile(RutaReports+'ListaCajasDesglosadas.lrf');
     frReport1.ShowReport;

  end;
  //--- Relacion de articulos vendidos
  if RadioButton8.Checked=True then
    begin
      TituloGrid:='Listado Cajas - Relación de Articulos Vendidos';
      TxtQuery:='select * from hisopdd' + Tienda + ' where hod0 >="' + FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit4.Text));
      TxtQuery:= TxtQuery +'" and HOD0 <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit5.Text)) +'"';
      If Edit20.Text<>'' then
        Begin
             TxtQuery:= TxtQuery  + ' and (HOD2 = "'+ Edit20.Text + '" )'
        End;
      dbAcaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbAcaja.Active:=True;
     if dbACaja.RecordCount=0 then
       begin
         Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
         exit;
       end;
     frDBDataSet1.DataSet:=dbACaja;
     frReport1.LoadFromFile(RutaReports+'ListaCajaArticulosVendidos.lrf');
     frReport1.ShowReport;
  end;
  //--- Relacion de tickets (Operaciones realizadas)
  if RadioButton9.Checked=True then
    begin
      TituloGrid:='Listado de Cajas - Relación de Ventas realizadas';
      TxtQuery:='select * from hisopcc' + Tienda + ' where HO0 >="' + FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit4.Text)) +'" and HO0 <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit5.Text)) +'"';
      TxtQuery:= TxtQuery + ' and HO1>="' + Edit21.Text + '" and HO1<="' + Edit22.Text + '"';
      If Edit20.Text<>'' then
        Begin
             TxtQuery:= TxtQuery  + ' and (HO2 = "'+ Edit20.Text + '" )'
        End;
      dbAcaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbAcaja.Active:=True;
     if dbACaja.RecordCount=0 then
       begin
         Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
         exit;
       end;
     frDBDataSet1.DataSet:=dbACaja;
     frReport1.LoadFromFile(RutaReports+'ListaCajaVentasRealizadas.lrf');
     frReport1.ShowReport;
  end;
  //--- Relacion de pagos realizados (AHORA REPARACIONES)
  if RadioButton10.Checked=True then
    begin
      TituloGrid:='Listado de Cajas - REPARACIONES';

      TxtQuery:='select * from hisopcc' + Tienda + ' where HO0 >="' + FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit4.Text)) +'" and HO0 <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit5.Text)) +'"';
      If Edit20.Text<>'' then
        Begin
             TxtQuery:= TxtQuery  + ' and (HO2 = "'+ Edit20.Text + '" )'
        End;
      TxtQuery:= TxtQuery + ' and HO5="RE"';
      dbAcaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbAcaja.Active:=True;
     if dbACaja.RecordCount=0 then
       begin
         Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
         exit;
       end;

     frDBDataSet1.DataSet:=dbACaja;
     frReport1.LoadFromFile(RutaReports+'ListaCajaVentasReparaciones.lrf');
     frReport1.ShowReport;

  end;
  //--- Relacion de Creditos / Entregas / Vales
  if RadioButton11.Checked=True then
    begin
      TituloGrid:='Listado de Cajas - CREDITOS / ENTREGAS / VALES';

      TxtQuery:='select * from hisopcc' + Tienda + ' where HO0 >="' + FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit4.Text)) +'" and HO0 <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit5.Text)) +'"';
      If Edit20.Text<>'' then
        Begin
             TxtQuery:= TxtQuery  + ' and (HO2 = "'+ Edit20.Text + '" )'
        End;
      TxtQuery:= TxtQuery + ' and (HO5="EN" or HO5="CO")';
      dbAcaja.Active:=False; dbACaja.Sql.Text:=TxtQuery; dbAcaja.Active:=True;
     if dbACaja.RecordCount=0 then
       begin
         Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
         exit;
       end;

     frDBDataSet1.DataSet:=dbACaja;
     frReport1.LoadFromFile(RutaReports+'ListaCajaVentasCreditos.lrf');
     frReport1.ShowReport;

  end;
//  WriteLn(TxtQuery);
end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFCaja.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  if ParName ='EMPRESA' then ParValue := Empresa;
  if ParName='DIRECCION' then ParValue := Direccion;
  if ParName='LOCALIDAD' then ParValue := Localidad;
  if ParName='PROVINCIA' then ParValue := Provincia;
  if ParName='NIF' then ParValue := Nif;
  if ParName='TELEFONO' then ParValue := Telefono;
  if ParName='FAX' then ParValue := Fax;
  if ParName='EMAIL' then ParValue := EMail;
  if ParName='CP' then ParValue := CP;
  if ParName='TITULO' then ParValue := TituloGrid;
  if ParName='Base1' then ParValue := Base1;
  if ParName='Base2' then ParValue := Base2;
  if ParName='Base3' then ParValue := Base3;
  if ParName='Iva1' then ParValue := Iva1;
  if ParName='Iva2' then ParValue := Iva2;
  if ParName='Iva3' then ParValue := Iva3;
  if ParName='TIva1' then ParValue := TIva1;
  if ParName='TIva2' then ParValue := TIva2;
  if ParName='TIva3' then ParValue := TIva3;
  if ParName='TBase' then ParValue := TBases;
  if ParName='TIva' then ParValue := TIvas;
  if ParName='Total' then ParValue := VTTotal;
  if ParName='Cambio' then ParValue := Cambio;
  if ParName='Billetes' then ParValue := Billetes;
  if ParName='Anterior' then ParValue := Anterior;
//-- Datos Globales del Comercio
  if ParName='Base1Glob' then ParValue := Base1Glob;
  if ParName='Base2Glob' then ParValue := Base2Glob;
  if ParName='Base3Glob' then ParValue := Base3Glob;
  if ParName='Iva1Glob' then ParValue := Iva1Glob;
  if ParName='Iva2Glob' then ParValue := Iva2Glob;
  if ParName='Iva3Glob' then ParValue := Iva3Glob;
  if ParName='TIva1Glob' then ParValue := TIva1Glob;
  if ParName='TIva2Glob' then ParValue := TIva2Glob;
  if ParName='TIva3Glob' then ParValue := TIva3Glob;
  if ParName='TBaseGlob' then ParValue := TBasesGlob;
  if ParName='TIvaGlob' then ParValue := TIvasGlob;
  if ParName='TotalGlob' then ParValue := VTTotalGlob;

  if ParName='CambioGlob' then ParValue := CambioGlob;
  if ParName='BilletesGlob' then ParValue := BilletesGlob;
  if ParName='AnteriorGlob' then ParValue := AnteriorGlob;

  if ParName='TBilletes' then ParValue := TBilletes;
  if ParName='TCambio' then ParValue := TCambio;
  if ParName='TTalTarj' then ParValue := TTalTarj;
  if ParName='TCambioA' then ParValue := TCambioA;

end;
//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFCaja.frReport1EnterRect(Memo: TStringList; View: TfrView);
var
  vImage: TImage;
begin
  frReport1.Title:=TituloGrid;
  if assigned( View ) and
     (View.Name = 'Picture1') and
     (View is TfrPictureView)
  then
    try
      vImage := TImage.Create( nil );
      try
         TfrPictureView(View).Picture.Clear;
         TfrPictureView(View).Picture.LoadFromFile(LogoEmpresa);
      finally
        FreeAndNil(vImage);
      end;
    except
      TfrPictureView(View).Picture.Clear;
    end;
end;

//============== Controles DBGrid ==============================
//-------- Al pulsar en el titulo de la columna ordenar por ella
{
procedure TFCaja.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid12,dbACaja, AntColun, Orden, TituloColumn, Ordenado);
end;
}

procedure TFCaja.BitBtn16Click(Sender: TObject);   //-- SELECCIONAR
begin
  dbGrid1.Visible:=False;
  dbGrid2.Visible:=False;
  If not Panel8.Visible then Panel8.Visible:=True;
  If Panel9.Visible then Panel9.Visible:=False;
  If Panel7.Visible then Panel7.Visible:=False;
  If Panel8.Visible then BitBtn16.SetFocus;
end;

procedure TFCaja.BitBtn17Click(Sender: TObject);   //-- VARIOS - INSERTAR PAGOS
begin
  dbGrid1.Visible:=False;
  dbGrid2.Visible:=False;
  dbGrid3.Visible:=False;
  If Panel8.Visible then Panel8.Visible:=False;
  If not Panel9.Visible then Panel9.Visible:=True;
  If Panel7.Visible then Panel7.Visible:=False;
  If Panel9.visible then statictext107.Caption:='MODIFICACIONES PARA EL DIA' + DatetoStr(Date);
  If Panel9.Visible then BitBtn17.SetFocus;
end;

//-- Pone los contadores de hora a 0
procedure TFCaja.BitBtn13Click(Sender: TObject);
begin
  Edit21.Text:='00:00:00';
  If ((Panel8.Visible) and (Edit21.Visible)) then BitBtn13.SetFocus;
end;

procedure TFCaja.BitBtn19Click(Sender: TObject);
begin
  Edit22.Text:='23:59:59';
  If ((Panel8.Visible) and (Edit22.Visible)) then BitBtn19.SetFocus;
end;


//--- Todos los RadioButton.Click de esta pantalla estan asociados a este mismo procedimiento para optimizar lineas de codigo
procedure TFCaja.RadioButton1Click(Sender: TObject);
begin
     IF (RadioButton1.Checked) or (RadioButton2.Checked) or (RadioButton3.Checked) or
        (RadioButton4.Checked) or (RadioButton6.Checked) or (RadioButton8.Checked) or
        (RadioButton10.Checked) or (RadioButton11.Checked) then
       Begin
            //--- Los campos StaticText100 y Edit19 son comunes para todos los radiobuttons
            
            Edit21.Visible:=False;//--- Oculta datos para radiobutton9
            Edit22.Visible:=False;//--- Oculta datos para radiobutton9
            BitBtn13.Visible:=False;//--- Oculta datos para radiobutton9
            BitBtn19.Visible:=False;//--- Oculta datos para radiobutton9

            StaticText104.Visible:=False;//--- Oculta datos para radiobuttons 5 y 7
            StaticText105.Visible:=False;//--- Oculta datos para radiobuttons 5 y 7
            DateEdit6.Visible:=False;//--- Oculta datos para radiobuttons 5 y 7
            DateEdit7.Visible:=False;//--- Oculta datos para radiobuttons 5 y 7

            StaticText101.Visible:=True;//--- Muestra Datos de radiobuttons 1,2,3,4,6,8,10 y 11  -- 9
            StaticText102.Visible:=True;//--- Muestra Datos de radiobuttons 1,2,3,4,6,8,10 y 11  -- 9
            StaticText103.Visible:=True;//--- Muestra Datos de radiobuttons 1,2,3,4,6,8,10 y 11  -- 9
            Edit20.Visible:=True;//--- Muestra Datos de radiobuttons 1,2,3,4,6,8,10 y 11  -- 9
            StaticText113.Visible:=True;
            DateEdit4.Visible:=True;//--- Muestra Datos de radiobuttons 1,2,3,4,6,8,10 y 11  -- 9
            DateEdit5.Visible:=True;//--- Muestra Datos de radiobuttons 1,2,3,4,6,8,10 y 11  -- 9
       End
     Else
       If RadioButton9.Checked then
         Begin
            Edit21.Visible:=True;//--- Muestra datos para radiobutton9
            Edit22.Visible:=True;//--- Muestra datos para radiobutton9
            BitBtn13.Visible:=True;//--- Muestra datos para radiobutton9
            BitBtn19.Visible:=True;//--- Muestra datos para radiobutton9

            StaticText104.Visible:=False;//--- Oculta datos para radiobuttons 5 y 7
            StaticText105.Visible:=False;//--- Oculta datos para radiobuttons 5 y 7
            DateEdit6.Visible:=False;//--- Oculta datos para radiobuttons 5 y 7
            DateEdit7.Visible:=False;//--- Oculta datos para radiobuttons 5 y 7

            StaticText101.Visible:=True;//--- Muestra Datos de radiobuttons 1,2,3,4,6,8,10 y 11
            StaticText102.Visible:=True;//--- Muestra Datos de radiobuttons 1,2,3,4,6,8,10 y 11
            StaticText103.Visible:=True;//--- Muestra Datos de radiobuttons 1,2,3,4,6,8,10 y 11
            Edit20.Visible:=True;//--- Muestra Datos de radiobuttons 1,2,3,4,6,8,10 y 11
            StaticText113.Visible:=True;
            DateEdit4.Visible:=True;//--- Muestra Datos de radiobuttons 1,2,3,4,6,8,10 y 11
            DateEdit5.Visible:=True;//--- Muestra Datos de radiobuttons 1,2,3,4,6,8,10 y 11
         End
       Else
         Begin
            Edit21.Visible:=False;//--- Oculta datos para radiobutton9
            Edit22.Visible:=False;//--- Oculta datos para radiobutton9
            BitBtn13.Visible:=False;//--- Oculta datos para radiobutton9
            BitBtn19.Visible:=False;//--- Oculta datos para radiobutton9

            StaticText104.Visible:=True;//--- Muestra datos para radiobuttons 5 y 7
            StaticText105.Visible:=True;//--- Muestra datos para radiobuttons 5 y 7
            DateEdit6.Visible:=True;//--- Muestra datos para radiobuttons 5 y 7
            DateEdit7.Visible:=True;//--- Muestra datos para radiobuttons 5 y 7

            StaticText101.Visible:=False;//--- Oculta Datos de radiobuttons 1,2,3,4,6,8,10 y 11
            StaticText102.Visible:=False;//--- Oculta Datos de radiobuttons 1,2,3,4,6,8,10 y 11
            StaticText103.Visible:=False;//--- Oculta Datos de radiobuttons 1,2,3,4,6,8,10 y 11
            Edit20.Visible:=False;//--- Oculta Datos de radiobuttons 1,2,3,4,6,8,10 y 11
            StaticText113.Visible:=False;
            DateEdit4.Visible:=False;//--- Oculta Datos de radiobuttons 1,2,3,4,6,8,10 y 11
            DateEdit5.Visible:=False;//--- Oculta Datos de radiobuttons 1,2,3,4,6,8,10 y 11
         End;
       If Panel8.Visible then BitBtn14.SetFocus;
end;



initialization
  {$I acaja.lrs}

end.

