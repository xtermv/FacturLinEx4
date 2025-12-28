{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010, Nicolas Lopez de Lerma Aymerich

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

Unit Clientes;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType, DBGrids,
  TAGraph, TASeries, LR_DBSet, LR_Class, db, DbCtrls, variants;


Type

  { TFClientes }

  TFClientes = Class(Tform)
    Bevel1: TBevel;
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
    BitBtn20: TBitBtn;
    BitBtn21: TBitBtn;
    btCodigo: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    Chart1: TChart;
    Chart1AreaSeries1: TAreaSeries;
    Chart1BarSeries1: TBarSeries;
    Chart1PieSeries1: TPieSeries;
    Chart1Serie1: TLineSeries;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    cbEmail: TCheckBox;
    CheckBox7: TCheckBox;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    Datasource3: TDatasource;
    Datasource4: TDatasource;
    dbClientes1: TZQuery;
    dbCliSic: TZQuery;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    dbRutas: TZQuery;
    dbSubRutas: TZQuery;
    dbTrabajo: TZQuery;
    dbBusca: TZQuery;
    Edit15: TEdit;
    Edit48: TEdit;
    Edit49: TEdit;
    Edit50: TEdit;
    Edit51: TEdit;
    Edit52: TEdit;
    Edit53: TEdit;
    Edit54: TEdit;
    Edit55: TEdit;
    Edit56: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label15: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    lbBeneficio: TLabel;
    lbIC: TLabel;
    lbIVC: TLabel;
    lbIVP: TLabel;
    lbUC: TLabel;
    lbUV: TLabel;
    ListBox1: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    ListBox7: TListBox;
    PanelNuevoCl: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    SicConnect: TZConnection;
    dbGrafica: TZQuery;
    dbHisto: TZQuery;
    DBGrid2: TDBGrid;
    dbPagos: TZQuery;
    DBGrid1: TDBGrid;
    dbEsta: TZQuery;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
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
    Edit40: TEdit;
    Edit41: TEdit;
    Edit42: TEdit;
    Edit43: TEdit;
    Edit44: TEdit;
    Edit45: TEdit;
    Edit46: TEdit;
    Edit47: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
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
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label49: TLabel;
    Label57: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox2: TListBox;
    ListBox5: TListBox;
    Memo1: TMemo;
    Edit1: Tedit;
    dbClientes: TZQuery;
    Panel1: Tpanel;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    Bitbtn4: Tbitbtn;
    Bitbtn5: Tbitbtn;
    Bitbtn6: Tbitbtn;
    Bitbtn1: Tbitbtn;
    Label7: Tlabel;
    Pagecontrol1: Tpagecontrol;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel5: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Tabsheet1: Ttabsheet;
    Tabsheet2: Ttabsheet;
    Tabsheet3: Ttabsheet;
    TabSheet4: TTabSheet;
    Label2: Tlabel;
    Label3: Tlabel;
    Label4: Tlabel;
    Label5: Tlabel;
    Label6: Tlabel;
    Edit2: Tedit;
    Edit3: Tedit;
    Edit4: Tedit;
    Edit5: Tedit;
    Edit6: Tedit;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn19Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure btCodigoClick(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure Datasource3DataChange(Sender: TObject; Field: TField);
    procedure Edit12Enter(Sender: TObject);
    procedure Edit12Exit(Sender: TObject);
    procedure Edit15Enter(Sender: TObject);
    procedure Edit15Exit(Sender: TObject);
    procedure Edit1MouseEnter(Sender: TObject);
    procedure Edit1MouseLeave(Sender: TObject);
    procedure Edit22Exit(Sender: TObject);
    function ClienteDuplicado(): string;
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit51Enter(Sender: TObject);
    procedure Edit51Exit(Sender: TObject);
    procedure Edit52Exit(Sender: TObject);
    Procedure Formcreate(Sender: Tobject);
    Procedure Edit1enter(Sender: Tobject);
    Procedure Edit1exit(Sender: Tobject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    Procedure LimpiaForm();
    procedure ListBox2DblClick(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure ListBox4Click(Sender: TObject);
    procedure ListBox5Click(Sender: TObject);
    procedure ListBox7Click(Sender: TObject);
    Procedure Relleno();
    Procedure LlenaReg();
    Procedure VerTipoPago();
    Procedure VerRuta();
    procedure VerSubRuta();
    Procedure Bitbtn1click(Sender: Tobject);
    Procedure Bitbtn6click(Sender: Tobject);
    Procedure Bitbtn5click(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    Procedure Bitbtn4click(Sender: Tobject);
    Procedure Bitbtn2click(Sender: Tobject);
    Procedure Bitbtn3click(Sender: Tobject);
    procedure Graficas();
    procedure CambiarGrafica();
    procedure RellenaEsta(Ano: String);
    procedure GrabarModificarSic();
    procedure BorrarSic();
    procedure RellenaSIC();
    procedure CargaSIC();
    function LeerClienteSic: Boolean;

  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormClientes;
  
Var
  FClientes: TFClientes;
  Cargando, CargaGrafica, NTienda: Integer;
  CodClienteSic: String;
  TituloGrid: String;

Implementation

uses
  Global, Funciones, Busquedas;
  
//=============== CREAR EL FORMULARIO ================
procedure ShowFormClientes;
begin
  with TFClientes.Create(Application) do
    begin
       ShowModal;
    end;
end;
Procedure TFClientes.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbClientes.Sql.Text:='SELECT * FROM clientes ORDER BY C0';
  dbClientes.Active := True;
  //---------------- CONEXION SIC -----------------
  if ActivarSIC='S' then
   begin
    SicConnect.HostName:=SICHost;
    SicConnect.Database:=SICDataBase;
    SicConnect.User:=SICUsuario;
    SicConnect.Password:=SICPasswd;
    SicConnect.Port:=StrToInt(SICPuerto);
    SicConnect.Protocol:=SICProtocolo;
    SicConnect.Connected:=True;
    BitBtn15.Visible:=True;
   end;

End;

//==================== CERRAR ======================
Procedure TFClientes.Bitbtn1click(Sender: Tobject);
Begin
  Close();
End;
Procedure TFClientes.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;
//=================== REGISTRO NUEVO ===================
Procedure TFClientes.Bitbtn2click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if dbClientes.Locate('C0', Edit1.Text, []) then
    begin
      DataModule1.Mensaje('Información','Ya existe ese cliente', 3000 , clGray);
      exit;
    end;

  if ClienteDuplicado<>'' then
    if Application.MessageBox('Grabar cliente','FacturLinEx', boxstyle) = IDNO Then Exit;

  dbClientes.Append; LlenaReg(); dbClientes.Post;
  Label7.Caption:=dbClientes.Fields[1].AsString;//--- Refrescar nombre.
  if ActivarSIC='S' then GrabarModificarSic();//------ Comprobar si se crea cliente en el SIC.
End;
//=================== BORRAR REGISTRO ===================
Procedure TFClientes.Bitbtn3click(Sender: Tobject);
Begin
   if Edit1.Text='' then exit;
   if not dbClientes.Locate('C0', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
       exit;
     end;
   CodClienteSic:=dbClientes.FieldByName('C47').AsString;//---- Para leer cliente en el sic.
   if Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
       Exit;
   dbClientes.Delete; Edit1.Text := ''; LimpiaForm();
   if ActivarSIC='S' then BorrarSic();//------ Comprobar si se crea cliente en el SIC.
End;

//=================== MODIFICAR ===================
Procedure TFClientes.Bitbtn4click(Sender: Tobject);
Begin
   if (Edit1.Text='') or (dbClientes.Recordcount=0) then exit;
   if not dbClientes.Locate('C0,', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO!');
       exit;
     end;
   If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
   dbClientes.Edit; LlenaReg(); dbClientes.Post;
   Label7.Caption:=dbClientes.Fields[1].AsString;//--- Refrescar nombre.
   if ActivarSIC='S' then GrabarModificarSic();//------ Comprobar si se modifica cliente en el SIC.
End;


//==================== REG. ANTERIOR ===============
Procedure TFClientes.Bitbtn5click(Sender: Tobject);
Begin
  dbClientes.Prior;
  LimpiaForm(); Relleno();
End;

//==================== REG. POSTERIOR ===============
Procedure TFClientes.Bitbtn6click(Sender: Tobject);
Begin
   dbClientes.Next;
   LimpiaForm(); Relleno();
End;


//=================== CODIGO DEL CLIENTE ================
Procedure TFClientes.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;

Procedure TFClientes.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbClientes.Locate('C0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;

//=================== BOTON LOPD ================
procedure TFClientes.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
   if ParName='EMPRESA' then ParValue := Empresa;
   if ParName='DIRECCION' then ParValue := Direccion;
   if ParName='LOCALIDAD' then ParValue := Localidad;
   if ParName='PROVINCIA' then ParValue := Provincia;
   if ParName='NIF' then ParValue := Nif;
   if ParName='TELEFONO' then ParValue := Telefono;
   if ParName='FAX' then ParValue := Fax;
   if ParName='EMAIL' then ParValue := EMail;
   if ParName='CP' then ParValue := CP;
   if ParName='TITULO' then ParValue := TituloGrid;
   if ParName='REGISTRO' then ParValue := REGISTRO;
end;

procedure TFClientes.BitBtn21Click(Sender: TObject);
var
  TxtQuery:String;
begin
      TituloGrid:='LOPD - Toma de datos de Cliente';
      TxtQuery:='SELECT * FROM clientes WHERE C0="'+Edit1.Text+'"';
      dbClientes1.Active:=False; dbClientes1.Sql.Text:=TxtQuery; dbClientes1.Active:=True;
     if (dbClientes1.RecordCount=0) then
       begin
         Showmessage('NO HA SELECCIONADO NINGÚN CLIENTE');
         exit;
       end;
     frDBDataSet1.DataSet:=dbClientes1;
     frReport1.LoadFromFile(RutaReports+'LopdClientes.lrf');
     frReport1.ShowReport;
end;

//================== Comprobaciones de duplicidad de cliente ========

function TFClientes.ClienteDuplicado(): string;
var
  txtQuery: string;
  Duplicado: string;
begin
 Duplicado:='';

 if Edit2.Text<>'' then
   begin
     txtQuery:='SELECT * FROM clientes WHERE C1="'+Edit2.Text+'"';
     dbBusca.Active:=False; dbBusca.Sql.Text:=txtQuery; dbBusca.Active:=True;
     if (dbBusca.RecordCount>0) then Duplicado:=' RAZON SOCIAL,';
   end;

 if Edit8.Text<>'' then
   begin
     txtQuery:='SELECT * FROM clientes WHERE C5="'+Edit8.Text+'"';
     dbBusca.Active:=False; dbBusca.Sql.Text:=txtQuery; dbBusca.Active:=True;
     if (dbBusca.RecordCount>0) then Duplicado:= Duplicado +' CIF/NIF,';
   end;

 Result:= Duplicado;
 if Duplicado='' then exit;

 DataModule1.Mensaje('Información','Duplicidad en'+Duplicado+' Cliente :' +
                        dbClientes.FieldByName('C0').AsString+' ', 3000 , clGray);

end;

//================== BUSCAR CLIENTES =========================
procedure TFClientes.BitBtn18Click(Sender: TObject);
begin
  if Edit2.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit2.SetFocus;
     Exit;
  end;
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT C0,C1,C5 FROM clientes WHERE C1 LIKE "%'+Edit2.Text+'%"',
              ['Código','Nombre','Nif'],'C0');
  if Edit1.Text<>'' then Edit1Exit(Edit1);
end;

procedure TFClientes.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn18Click(BitBtn18);
end;

//===================== LIMPIAR DATOS =======================
Procedure TFClientes.LimpiaForm();
Begin
  Edit2.Text:=''; Edit3.Text:=''; Edit4.Text:=''; Edit5.Text:='';
  Edit6.Text:=''; Label7.Caption:='';
  Edit7.Text:=''; Edit8.Text:=''; Edit9.Text:=''; Edit10.Text:='';
  Edit11.Text:=''; Edit12.Text:=''; Edit13.Text:='';
  Edit14.Text:=''; Memo1.Lines.Text:=''; Edit15.Text:='';
  Edit16.Text:=''; Edit17.Text:=''; Edit18.Text:='';
  Edit19.Text:=''; Edit20.Text:=''; Edit21.Text:='';
  Edit22.Text:='N'; Edit23.Text:=''; Edit24.Text:='';
  Edit25.Text:=''; Edit26.Text:=''; Edit27.Text:='';
  Edit28.Text:=''; Edit29.Text:=''; Edit30.Text:='';
  Edit31.Text:=''; Edit32.Text:=''; Edit33.Text:='';
  Edit34.Text:=''; Edit35.Text:=''; Edit36.Text:='';
  Edit37.Text:=''; Edit38.Text:=''; Edit39.Text:='';
  Edit40.Text:=''; Edit41.Text:=''; Edit42.Text:='';
  Edit43.Text:=''; Edit44.Text:=''; Edit45.Text:='';
  Edit46.Text:=''; Edit47.Text:=''; Edit50.Text:='';
  Edit51.Text:=''; Edit52.Text:=''; Edit53.Text:='';
  Edit54.Text:=''; Edit55.Text:=''; Edit56.Text:='';
  CheckBox1.Checked:=False; CheckBox2.Checked:=False;
  CheckBox3.Checked:=False; CheckBox4.Checked:=False;
  CheckBox5.Checked:=False; CheckBox6.Checked:=False;
  StaticText1.Caption:='';  StaticText2.Caption:='';
  cbEmail.Checked:= False;
End;

//===================== PINTAR DATOS =======================
Procedure TFClientes.Relleno();
Begin
  if dbClientes.RecordCount=0 then exit;
  Label7.Caption:=dbClientes.Fields[1].AsString;
  Edit1.Text:=dbClientes.FieldByName('C0').AsString;//-------------- Cgo. Tienda
  Edit2.Text:=dbClientes.FieldByName('C1').AsString;//-------------- Nombre
  Edit3.Text:=dbClientes.FieldByName('C2').AsString;//-------------- Representante
  Edit4.Text:=dbClientes.FieldByName('C3').AsString;//-------------- Direccion
  Edit5.Text:=dbClientes.FieldByName('C4').AsString;//-------------- Localidad
  Edit6.Text:=dbClientes.FieldByName('C37').AsString;//------------- C.Postal
  Edit7.Text:=dbClientes.FieldByName('C38').AsString;//------------- Provincia
  Edit8.Text:=dbClientes.FieldByName('C5').AsString;//-------------- N.I.F.
  Edit9.Text:=dbClientes.FieldByName('C40').AsString;//------------- E-Mail
  cbEmail.Checked:=dbClientes.FieldByName('C55').AsBoolean; //------ Envío de facturas por email.
  CheckBox7.Checked:=dbClientes.FieldByName('C56').AsBoolean; //------ Captura Observaciones en VENTAS
  Edit10.Text:=dbClientes.FieldByName('C6').AsString;//------------- Telef.
  Edit11.Text:=dbClientes.FieldByName('C7').AsString;//------------- Fax
  Edit12.Text:=dbClientes.FieldByName('C9').AsString;//------------- Tipo de pago
  if Edit12.Text<>'' then VerTipoPago();//-------------------------- Nombre tipo de pago
  Edit13.Text:=dbClientes.FieldByName('C11').AsString;//------------ Mes de vacaciones
  Edit14.Text:=dbClientes.FieldByName('C12').AsString;//------------ Dias de pago
  Memo1.Lines.Text:=dbClientes.FieldByName('C36').AsString;//------- Observaciones
  Edit16.Text:=dbClientes.FieldByName('C13').AsString;//------------ Dias hasta 1º plazo
  Edit17.Text:=dbClientes.FieldByName('C14').AsString;//------------ Dias entre plazos
  Edit18.Text:=dbClientes.FieldByName('C15').AsString;//------------ Numero de plazos
  Edit19.Text:=dbClientes.FieldByName('C16').AsString;//------------ Tipo de Dto.
  Edit20.Text:=dbClientes.FieldByName('C17').AsString;//------------ Dto. comercial
  Edit21.Text:=dbClientes.FieldByName('C18').AsString;//------------ Dto. pronto pago
  Edit22.Text:=dbClientes.FieldByName('C19').AsString;//------------ Recargo equivalencia S/N
  Edit23.Text:=dbClientes.FieldByName('C43').AsString;//------------ Tipo de tarifa
  Edit24.Text:=dbClientes.FieldByName('C20').AsString;//------------ Importe credito actual
  Edit25.Text:=dbClientes.FieldByName('C21').AsString;//------------ Entregas a cuenta
  Edit26.Text:=dbClientes.FieldByName('C22').AsString;//------------ Riesgo maximo
  Edit27.Text:=dbClientes.FieldByName('C44').AsString;//------------ Fecha ultima entrega
  Edit28.Text:=dbClientes.FieldByName('C23').AsString;//------------ Minimo a facturar
  Edit29.Text:=dbClientes.FieldByName('C24').AsString;//------------ Minimo primer plazo
  Edit30.Text:=dbClientes.FieldByName('C45').AsString;//------------ Importe ultima entrega
  Edit50.Text:=dbClientes.FieldByName('C8').AsString;//------------- N. Copias Facturas
  Edit31.Text:=dbClientes.FieldByName('C39').AsString;//------------ Formulario de facturas
  Edit15.Text:=dbClientes.FieldByName('C10').AsString;//------------ Ruta de facturacion
  if Edit15.Text<>'' then VerRuta();//------------------------------ Nombre Ruta Facturacion
  Edit51.Text:=dbClientes.FieldByName('C48').AsString;//------------ Sub Ruta de facturacion
  if Edit51.Text<>'' then VerSubRuta();//--------------------------- Nombre Sub Ruta Facturacion
  Edit32.Text:=dbClientes.FieldByName('C25').AsString;//------------ Agencia de transportes
  Edit33.Text:=dbClientes.FieldByName('C27').AsString;//------------ Domicilio de entrega
  Edit34.Text:=dbClientes.FieldByName('C28').AsString;//------------ Localidad de entrega
  Edit35.Text:=dbClientes.FieldByName('C26').AsString;//------------ Portes D/P
  if dbClientes.FieldByName('C41').AsInteger=1 then
   CheckBox1.Checked:=True else CheckBox1.Checked:=False;//----- Generar Recibos bancarios
  if dbClientes.FieldByName('C42').AsInteger=1 then
   CheckBox2.Checked:=True else CheckBox2.Checked:=False;//----- Imprimir banco / Caja en facturas

  Edit36.Text:=dbClientes.FieldByName('C29').AsString;//------------ Cliente a facturar
  Edit37.Text:=dbClientes.FieldByName('C30').AsString;//------------ Nombre banco / caja
  Edit38.Text:=dbClientes.FieldByName('C31').AsString;//------------ N. Cuenta
  Edit39.Text:=dbClientes.FieldByName('C32').AsString;//------------ Domicilio banco
  Edit40.Text:=dbClientes.FieldByName('C33').AsString;//------------ Localidad banco
  Edit41.Text:=dbClientes.FieldByName('C34').AsString;//------------ Cuenta de cargo
  Edit42.Text:=dbClientes.FieldByName('C35').AsString;//------------ Cuenta de abono

  Edit52.Text:=dbClientes.FieldByName('C49').AsString;//------------ Sistema de puntos activado
  Edit53.Text:=dbClientes.FieldByName('C50').AsString;//------------ Total de puntos acumulados

  Edit54.Text:=dbClientes.FieldByName('C51').AsString;//------------ Avisos en las ventas.
  Edit55.Text:=dbClientes.FieldByName('C52').AsString;//------------ Usuario en Tienda Virtual
  Edit56.Text:=dbClientes.FieldByName('C53').AsString;//------------ Contraseña en Tienda Virtual
  If dbClientes.FieldByName('C54').AsInteger=0 then
  CheckBox6.Checked:=True else CheckBox6.Checked:=False;//----- Usuario activo en Tienda Virtual

  //-------------- Estadisticas --------------------
  RellenaEsta(FormatDateTime('YYYY',Date));//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, CC6-CC7 As BENEF FROM estaclie WHERE CC0="'+Edit1.Text+'"'+
                   ' AND CC1='+FormatDateTime('YYYY',Date)+
                   ' ORDER BY CC1 ASC, CC2 ASC';
  dbEsta.Active:=True;
  //------------------------------------------------
  CargaGrafica:=1; Graficas(); CargaGrafica:=0;//---------------- Pintar Graficas
  //-------------- Historico de compras --------------------
  Edit43.Text:='01/'+FormatDateTime('MM/YYYY',Date);
  Edit44.Text:=FormatDateTime('DD/MM/YYYY',Date);
  dbHisto.Active:=False;
  dbHisto.SQL.Text:='SELECT * FROM histoclie WHERE HC0='+Edit1.Text+
                    ' AND HC1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit43.Text))+'"'+
                    ' AND HC1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit44.Text))+'"'+
                    ' ORDER BY HC1 DESC, HC2 DESC';
  dbHisto.Active:=True;
  //-------------- Ver si esta es la misma version que la del SIC
  CodClienteSic:=dbClientes.FieldByName('C47').AsString;
  if (ActivarSIC='S') and (LeerClienteSic=true) then
    begin
      if (dbCliSic.FieldByName('ES_CLIENTE').AsString='1') and
         (dbClientes.FieldByName('C46').AsInteger<dbCliSic.FieldByName('version').AsInteger) then
         If Application.MessageBox('EXISTE DATOS ACTUALIZADOS DE ESTE CLIENTE EN EL SISTEMA SIC, LOS ACTUALIZO AQUI?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
            Exit
         else
          begin
            CargaSic();
            If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
               Exit;
            dbClientes.Edit; LlenaReg(); dbClientes.Post;
            Label7.Caption:=dbClientes.Fields[1].AsString;//--- Refrescar nombre.
            dbClientes.Edit;
            dbClientes.FieldByName('C46').Value:=dbCliSic.FieldByName('version').Value;//------- Control de Version
            dbClientes.Post;
          end;
    end;
  
End;
//===================== RELLENAR DATOS =======================
Procedure TFClientes.LlenaReg();
Begin
  dbClientes.FieldByName('C0').AsString:=Edit1.Text;//-------------- Cgo. Tienda
  dbClientes.FieldByName('C1').AsString:=Edit2.Text;//-------------- Nombre
  dbClientes.FieldByName('C2').AsString:=Edit3.Text;//-------------- Representante
  dbClientes.FieldByName('C3').AsString:=Edit4.Text;//-------------- Direccion
  dbClientes.FieldByName('C4').AsString:=Edit5.Text;//-------------- Localidad
  dbClientes.FieldByName('C37').AsString:=Edit6.Text;//------------- C.Postal
  dbClientes.FieldByName('C38').AsString:=Edit7.Text;//------------- Provincia
  dbClientes.FieldByName('C5').AsString:=Edit8.Text;//-------------- N.I.F.
  dbClientes.FieldByName('C40').AsString:=Edit9.Text;//------------- E-Mail
  dbClientes.FieldByName('C55').AsBoolean:=cbEmail.Checked;//------- Envío facturas por E-Mail
  dbClientes.FieldByName('C56').AsBoolean:=CheckBox7.Checked;//------- Captura datos Observaciones para VENTAS
  dbClientes.FieldByName('C6').AsString:=Edit10.Text;//------------- Telef.
  dbClientes.FieldByName('C7').AsString:=Edit11.Text;//------------- Fax
  dbClientes.FieldByName('C9').AsString:=Edit12.Text;//------------- Tipo de pago
  dbClientes.FieldByName('C11').AsString:=Edit13.Text;//------------ Mes de vacaciones
  dbClientes.FieldByName('C12').AsString:=Edit14.Text;//------------ Dias de pago
  dbClientes.FieldByName('C36').AsString:=Memo1.Lines.Text;//------- Observaciones

  dbClientes.FieldByName('C13').AsString:=Edit16.Text;//------------ Dias hasta 1º plazo
  dbClientes.FieldByName('C14').AsString:=Edit17.Text;//------------ Dias entre plazos
  dbClientes.FieldByName('C15').AsString:=Edit18.Text;//------------ Numero de plazos
  dbClientes.FieldByName('C16').AsString:=Edit19.Text;//------------ Tipo de Dto.
  dbClientes.FieldByName('C17').AsString:=Edit20.Text;//------------ Dto. comercial
  dbClientes.FieldByName('C18').AsString:=Edit21.Text;//------------ Dto. pronto pago
  dbClientes.FieldByName('C19').AsString:=Edit22.Text;//------------ Recargo equivalencia S/N
  dbClientes.FieldByName('C43').AsString:=Edit23.Text;//------------ Tipo de tarifa
  dbClientes.FieldByName('C20').AsString:=Edit24.Text;//------------ Importe credito actual
  dbClientes.FieldByName('C21').AsString:=Edit25.Text;//------------ Entregas a cuenta
  dbClientes.FieldByName('C22').AsString:=Edit26.Text;//------------ Riesgo maximo
  //----- Fecha ultima entrega
  if Edit27.Text='' then
    dbClientes.FieldByName('C44').Value:=Null
  else
    dbClientes.FieldByName('C44').AsString:=Edit27.Text;//---------- Fecha ultima entrega
  dbClientes.FieldByName('C23').AsString:=Edit28.Text;//------------ Minimo a facturar
  dbClientes.FieldByName('C24').AsString:=Edit29.Text;//------------ Minimo primer plazo
  dbClientes.FieldByName('C45').AsString:=Edit30.Text;//------------ Importe ultima entrega
  dbClientes.FieldByName('C8').AsString:=Edit50.Text;//------------- N. Copias Facturas
  dbClientes.FieldByName('C39').AsString:=Edit31.Text;//------------ Formulario de facturas
  dbClientes.FieldByName('C10').AsString:=Edit15.Text;//------------ Ruta de facturacion
  dbClientes.FieldByName('C48').AsString:=Edit51.Text;//------------ Sub ruta de facturacion
  dbClientes.FieldByName('C25').AsString:=Edit32.Text;//------------ Agencia de transportes
  dbClientes.FieldByName('C27').AsString:=Edit33.Text;//------------ Domicilio de entrega
  dbClientes.FieldByName('C28').AsString:=Edit34.Text;//------------ Localidad de entrega
  dbClientes.FieldByName('C26').AsString:=Edit35.Text;//------------ Portes D/P
  if  CheckBox1.Checked=True then
    dbClientes.FieldByName('C41').AsString:='1' else
    dbClientes.FieldByName('C41').AsString:='0';//----- Generar Recibos bancarios
  if CheckBox2.Checked=True then
    dbClientes.FieldByName('C42').AsString:='1' else
    dbClientes.FieldByName('C42').AsString:='0';//----- Imprimir banco / Caja en facturas

  dbClientes.FieldByName('C29').AsString:=Edit36.Text;//------------ Cliente a facturar
  dbClientes.FieldByName('C30').AsString:=Edit37.Text;//------------ Nombre banco / caja
  dbClientes.FieldByName('C31').AsString:=Edit38.Text;//------------ N. Cuenta
  dbClientes.FieldByName('C32').AsString:=Edit39.Text;//------------ Domicilio banco
  dbClientes.FieldByName('C33').AsString:=Edit40.Text;//------------ Localidad banco
  dbClientes.FieldByName('C34').AsString:=Edit41.Text;//------------ Cuenta de cargo
  dbClientes.FieldByName('C35').AsString:=Edit42.Text;//------------ Cuenta de abono

  dbClientes.FieldByName('C49').AsString:=Edit52.Text;//------------ Sistema de puntos activado
  dbClientes.FieldByName('C50').AsString:=Edit53.Text;//------------ Total de puntos acumulados

  dbClientes.FieldByName('C51').AsString:=Edit54.Text;//------------ Aviso en ventas.
  dbClientes.FieldByName('C52').AsString:=Edit55.Text;//------------ Usuario en Tienda Virtual
  dbClientes.FieldByName('C53').AsString:=Edit56.Text;//------------ Contraseña en Tienda Virtual
  If CheckBox6.Checked=True then
    dbClientes.FieldByName('C54').AsString:='0' else
    dbClientes.FieldByName('C54').AsString:='1';//----- Usuario activo en Tienda Virtual
End;
//========================================================
//=================== TIPOS DE PAGOS =====================
//========================================================
procedure TFClientes.BitBtn7Click(Sender: TObject);
begin
  dbPagos.SQL.Text:='SELECT * FROM formapago ORDER BY FPA1 ASC';
  dbPagos.Active:=True;
  if dbPagos.RecordCount=0 then exit;
  dbPagos.First; ListBox2.Items.Clear;
  while not dbPagos.EOF do
    begin
      ListBox2.Items.Add(Space(4-length(dbPagos.FieldByName('FPA0').AsString))+
                         dbPagos.FieldByName('FPA0').AsString+' '+
                         dbPagos.FieldByName('FPA1').AsString);
      dbPagos.Next;
    end;
  dbPagos.Active:=False; Panel5.Visible:=True;
end;

//----------------- SELECCIONAR TIPO DE PAGO ------------
procedure TFClientes.ListBox2DblClick(Sender: TObject);
begin
  Edit12.Text:=trim(copy(ListBox2.Items.Strings[ListBox2.ItemIndex],1,4));
  if Edit12.Text<>'' then Edit12Exit(Edit12);
  Panel5.Visible:=False;
end;
//--------------- CERRAR TIPOS DE PAGOS / COBROS ------
procedure TFClientes.BitBtn16Click(Sender: TObject);
begin
  Panel5.Visible:=False;
end;

//==================== VER TIPOS DE PAGO ===============
procedure TFClientes.Edit12Enter(Sender: TObject);
begin
  StaticText1.Caption:=''
end;
procedure TFClientes.Edit12Exit(Sender: TObject);
begin
  if Edit12.Text<>'' then VerTipoPago();
end;
Procedure TFClientes.VerTipoPago();
Begin
  dbPagos.Active:=False;
  dbPagos.SQL.Text:='SELECT * FROM formapago WHERE FPA0='+Edit12.Text;
  dbPagos.Active:=True;
  if dbPagos.RecordCount=0 then
   StaticText1.Caption:=''
  else
   StaticText1.Caption:=dbPagos.Fields[1].AsString;
  dbPagos.Active:=False;
end;

//================ REC. EQUIVALENCIA ======================
procedure TFClientes.Edit22Exit(Sender: TObject);
begin
  if Edit22.Text='' then Edit22.Text:='N';
  if (Edit22.Text='S') or (Edit22.Text='N') then exit;
  showmessage('Debe teclear S o N en este campo.');
  Edit22.SetFocus;
end;


//===================================================
//================ RUTA DE FACTURACION ==============
//===================================================
procedure TFClientes.BitBtn8Click(Sender: TObject);
Var
 Campo: Array [1..2] of variant;
begin
  cargando:=1;
  dbRutas.SQL.Text:='SELECT * FROM rutas'+Tienda+' ORDER BY RUT1 ASC';
  dbRutas.Active:=True;
  if dbRutas.RecordCount=0 then exit;
  cargando:=0;
  dbRutas.First;
  if Edit15.Text<>'' then dbRutas.Locate('RUT0',Edit15.Text,[locaseinsensitive]);
  if (Edit15.Text<>'') and (Edit51.Text<>'') then
    begin
     Campo[1]:=Edit15.Text; Campo[2]:=Edit51.Text;
     dbSubRutas.Locate('SRUT0,SRUT1',VarArrayof([Edit15.Text,Edit51.Text]),[locaseinsensitive]);
    end;
  Panel7.Visible:=True;
end;

//------- GENERAR CLIENTE NUEVO
procedure TFClientes.btCodigoClick(Sender: TObject);
begin
  dbBusca.Active:=False;
  dbBusca.Sql.Text:='SELECT * FROM clientes ORDER BY C0 DESC LIMIT 2';
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then Edit1.Text:='1'
    else
     begin
      if (dbBusca.RecordCount=1) and (dbBusca.FieldByName('C0').AsString=ClienteVario) then
        Begin
         Edit1.Text:='1';
         Exit;
        end;

      if (dbBusca.RecordCount>1) and (dbBusca.FieldByName('C0').AsString=ClienteVario) then dbBusca.Next;
      Edit1.Text:=IntToStr(dbBusca.FieldByName('C0').AsInteger+1);
      if Edit1.Text=ClienteVario then edit1.Text:='1000000';
     end;
  dbBusca.Active:=False;
  edit2.SetFocus;   // pasamos el foco a la descripción
end;

//------------------- CERRAR PANEL RUTAS ---------
procedure TFClientes.BitBtn20Click(Sender: TObject);
begin
   dbRutas.Active:=False; dbSubRutas.Active:=False;
   Panel7.Visible:=False;
end;

//----------------- SELECCIONAR RUTA ---------
procedure TFClientes.BitBtn19Click(Sender: TObject);
begin
  Edit15.Text:=dbSubRutas.FieldByName('SRUT0').AsString;
  if Edit15.Text<>'' then Edit15Exit(Edit15);
  Edit51.Text:=dbSubRutas.FieldByName('SRUT1').AsString;
  if Edit51.Text<>'' then Edit51Exit(Edit51);
  Panel7.Visible:=False;
end;



//----------------- LEER RUTA ------------
procedure TFClientes.Edit15Enter(Sender: TObject);
begin
  StaticText2.Caption:='';
end;
procedure TFClientes.Edit15Exit(Sender: TObject);
begin
  if Edit15.Text<>'' then VerRuta();
end;

procedure TFClientes.Edit1MouseEnter(Sender: TObject);
var
  Ultimo : Integer;
begin
  PanelNuevoCl.Visible:=True;
  //------ Ver cual es el ultimo proveedor en nuestro file
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT C0 FROM clientes where C0<"'+IntToStr(StrToInt(ClienteVario)-9)+'" ORDER BY C0 DESC';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then Ultimo:=1 else Ultimo:=dbTRabajo.FieldByName('C0').AsInteger+1;
  //------ Cargar datos en pantalla
  PanelNuevoCl.Caption:=IntToStr(Ultimo);end;

procedure TFClientes.Edit1MouseLeave(Sender: TObject);
begin
  PanelNuevoCl.Visible:=False;
end;

Procedure TFClientes.VerRuta();
begin
  cargando:=1;
  dbRutas.Active:=False;
  dbRutas.SQL.Text:='SELECT * FROM rutas'+Tienda+' WHERE RUT0='+Edit15.Text;
  dbRutas.Active:=True;
  if dbRutas.RecordCount=0 then
   StaticText2.Caption:=''
  else
   StaticText2.Caption:=dbRutas.Fields[1].AsString;
  dbRutas.Active:=False;
  cargando:=0;
end;

//----------------- LEER SUB RUTA ------------
procedure TFClientes.Edit51Enter(Sender: TObject);
begin
  StaticText2.Caption:='';
end;
procedure TFClientes.Edit51Exit(Sender: TObject);
begin
  if Edit51.Text<>'' then
   begin
    if Edit15.Text='' then begin showmessage('PRIMERO DEBE DEFINIR LA RUTA'); exit; end;
    VerSubRuta();
   end;
end;

procedure TFClientes.Edit52Exit(Sender: TObject);
begin
  Edit52.Text:=UpperCase(Edit52.Text);
end;

Procedure TFClientes.VerSubRuta();
begin
  cargando:=1;
  dbSubRutas.Active:=False;
  dbSubRutas.SQL.Text:='SELECT * FROM subrutas'+Tienda+' WHERE SRUT0='+Edit15.Text+
                       ' AND SRUT1='+Edit51.Text;
  dbSubRutas.Active:=True;
  if dbSubRutas.RecordCount=0 then
   StaticText2.Caption:=''
  else
   StaticText2.Caption:=dbSubRutas.Fields[2].AsString;
  dbSubRutas.Active:=False;
  cargando:=0;
end;


//============== MOSTRAR SUB RUTAS AL SELECCIONAR UNA RUTA ===============
procedure TFClientes.Datasource3DataChange(Sender: TObject; Field: TField);
begin
  if cargando=1 then exit;
  if dbRutas.FieldByName('RUT0').AsString='' then exit;
  dbSubRutas.Active:=False;
  dbSubRutas.SQL.Text:='SELECT * FROM subrutas'+Tienda+
                      ' WHERE SRUT0='+dbRutas.FieldByName('RUT0').AsString+
                      ' ORDER BY SRUT1';
  dbSubRutas.Active:=True;
end;


//=======================================================
//============= FILTRO HIST. COMPRAS ====================
//=======================================================
//------------- Buscar codigo ------------
procedure TFClientes.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked=True then
    Edit45.Enabled:=True else Edit45.Enabled:=False;
end;
//------------- Buscar unidades ----------
procedure TFClientes.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked=True then
    Edit46.Enabled:=True else Edit46.Enabled:=False;
end;
//------------- Buscar importe ----------
procedure TFClientes.CheckBox5Click(Sender: TObject);
begin
  if CheckBox5.Checked=True then
    Edit47.Enabled:=True else Edit47.Enabled:=False;
end;

//------------ APLICAR FILTRO -----------
procedure TFClientes.BitBtn11Click(Sender: TObject);
var
  Codigo,Unidades,Importe: String;
begin
  if Edit43.Text='' then Edit43.Text:='01/'+FormatDateTime('MM/YYYY',Date);
  if Edit44.Text='' then Edit44.Text:=FormatDateTime('DD/MM/YYYY',Date);
  if StrToDate(Edit43.Text) > StrToDate(Edit44.Text) then
    begin ShowMessage('LA PRIMERA FECHA NO PUEDE SER MAYOR QUE LA ULTIMA'); exit; end;
  //------- Ver si buscar por codigo
  if (CheckBox3.Checked=True) and (Edit45.Text<>'') then
    Codigo:=' AND HC4="'+Edit45.Text+'"' else Codigo:='';
  //------- Ver si buscar por unidades
  if (CheckBox4.Checked=True) and (Edit46.Text<>'') then
    Unidades:=' AND HC6='+Edit46.Text else Unidades:='';
  //------- Ver si buscar por importe
  if (CheckBox5.Checked=True) and (Edit47.Text<>'') then
    Importe:=' AND HC7='+Edit47.Text else Importe:='';
  //-------------------------------------
  dbHisto.Active:=False;
  dbHisto.SQL.Text:='SELECT * FROM histoclie WHERE HC0='+Edit1.Text+
                    ' AND HC1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit43.Text))+'"'+
                    ' AND HC1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit44.Text))+'"'+
                    Codigo + Unidades + Importe +
                    ' ORDER BY HC1 DESC, HC2 DESC';
  dbHisto.Active:=True;
end;

//============================================================
//===================== GRAFICAS =============================
//============================================================
procedure TFClientes.Graficas();
Var
  Conta: Integer;
begin
  //-------------- Mostrar los distintos años ------------------
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT DISTINCT CC1 FROM estaclie WHERE CC0="'+Edit1.Text+'" ORDER BY CC1 DESC';
  dbGrafica.Active:=True;
  ListBox3.Items.Clear; ListBox5.Items.Clear;
  dbGrafica.First;
  while not dbGrafica.EOF do
    begin
      ListBox3.Items.Add(dbGrafica.FieldByName('CC1').AsString);
      ListBox5.Items.Add(dbGrafica.FieldByName('CC1').AsString);
      dbGrafica.Next;
    end;
  ListBox4.ItemIndex:=0;
  //-------------- Mostrar las unidades compradas ------------------
  if ListBox3.Items.Count<>0 then
    begin
     ListBox3.ItemIndex:=0;
     Chart1Serie1.Clear; Chart1AreaSeries1.Clear;
     Chart1BarSeries1.Clear; Chart1PieSeries1.Clear;
     dbGrafica.Active:=False;
     dbGrafica.SQL.Text:='SELECT *, CC6-CC7 As BENEF FROM estaclie WHERE CC0="'+Edit1.Text+'"'+
                         ' AND CC1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                         ' ORDER BY CC1 ASC, CC2 ASC';
     dbGrafica.Active:=True; ListBox7.ItemIndex:=0;
     dbGrafica.First; Chart1.Title.Text.Text:='Unidades Compradas';
     for conta:=1 to dbGrafica.RecordCount do
       begin
        Chart1Serie1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        Chart1AreaSeries1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        Chart1BarSeries1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        Chart1PieSeries1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        dbGrafica.Next;
       end;
    end;
end;
//------------------ Cambiar años grafica -------------------
procedure TFClientes.ListBox3Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//------------------ Cambiar datos grafica -------------------
procedure TFClientes.ListBox4Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//----------------- Cambiar tipo de grafica ----------------
procedure TFClientes.ListBox7Click(Sender: TObject);
begin
 Chart1Serie1.Active:=False; Chart1AreaSeries1.Active:=False;
 Chart1BarSeries1.Active:=False; Chart1PieSeries1.Active:=False;
 case ListBox7.ItemIndex of
   0: Chart1Serie1.Active:=True;
   1: Chart1BarSeries1.Active:=True;
   2: Chart1AreaSeries1.Active:=True;
   3: Chart1PieSeries1.Active:=True;
 end;
end;

//--------------- Cambiar Grafica -----------------
procedure TFClientes.CambiarGrafica();
var
  Conta: Integer;
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox3.Items.Count=0 then exit;//----- Si no hay años
  if ListBox3.ItemIndex=-1 then ListBox3.ItemIndex:=0;
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT *, CC6-CC7 As BENEF FROM estaclie WHERE CC0="'+Edit1.Text+'"'+
                      ' AND CC1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                      ' ORDER BY CC1 ASC, CC2 ASC';
  dbGrafica.Active:=True;
  Chart1Serie1.Clear; Chart1AreaSeries1.Clear;
  Chart1BarSeries1.Clear; Chart1PieSeries1.Clear;
  if ListBox4.ItemIndex=-1 then ListBox4.ItemIndex:=0;
  dbGrafica.First; Chart1.Title.Text.Text:=ListBox4.Items.Strings[ListBox4.ItemIndex];
  for conta:=1 to dbGrafica.RecordCount do
    begin
     Chart1Serie1.AddXY(conta,dbGrafica.Fields[ListBox4.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox4.ItemIndex+3].AsFloat), clred);
     Chart1AreaSeries1.AddXY(conta,dbGrafica.Fields[ListBox4.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox4.ItemIndex+3].AsFloat), clred);
     Chart1BarSeries1.AddXY(conta,dbGrafica.Fields[ListBox4.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox4.ItemIndex+3].AsFloat), clred);
     Chart1PieSeries1.AddXY(conta,dbGrafica.Fields[ListBox4.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox4.ItemIndex+3].AsFloat), clred);
     dbGrafica.Next;
    end;
end;
//----------------- Cambiar estadisticas ---------------
procedure TFClientes.ListBox5Click(Sender: TObject);
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox5.Items.Count=0 then exit;//----- Si no hay años
  if ListBox5.ItemIndex=-1 then ListBox5.ItemIndex:=0;
  RellenaEsta(ListBox5.Items.Strings[ListBox5.ItemIndex]);//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, CC6-CC7 As BENEF FROM estaclie WHERE CC0="'+Edit1.Text+'"'+
                   ' AND CC1='+ListBox5.Items.Strings[ListBox5.ItemIndex]+
                   ' ORDER BY CC1 ASC, CC2 ASC';
  dbEsta.Active:=True;
end;

//==========================================================
//============= RELLENAR MESES QUE ESTEN A 0 ===============
//==========================================================
procedure TFClientes.RellenaEsta(Ano: String);
var
  Conta: Integer;
  UC,IC,UV,IVP,IVC,Beneficio : Double;
begin
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT * FROM estaclie WHERE CC0="'+Edit1.Text+'"'+
                   ' AND CC1='+Ano+
                   ' ORDER BY CC1 ASC, CC2 ASC';
  dbEsta.Active:=True;
  dbEsta.First;

  //*********** IMPLEMENTACIÓN DE MUESTREO DE TOTALES
    UC:=0; IC:=0; UV:=0; IVP:=0; IVC:=0; Beneficio:=0;
    While not dbEsta.EOF do
      begin
        UC := UC + dbEsta.FieldByName('CC3').Value;
        IC := IC + dbEsta.FieldByName('CC4').Value;
        UV := UV + dbEsta.FieldByName('CC5').Value;
        IVP := IVP + dbEsta.FieldByName('CC6').Value;
        IVC := IVC + dbEsta.FieldByName('CC7').Value;
        Beneficio := Beneficio + ( dbEsta.FieldByName('CC6').Value - dbEsta.FieldByName('CC7').Value );
        dbEsta.Next;
      end;

    lbUC.Caption := FormatFloat('#0.00',UC);
    lbIC.Caption := FormatFloat('#0.00',IC);
    lbUV.Caption := FormatFloat('#0.00',UV);
    lbIVP.Caption := FormatFloat('#0.00',IVP);
    lbIVC.Caption := FormatFloat('#0.00',IVC);
    lbBeneficio.Caption := FormatFloat('#0.00',Beneficio);

    dbEsta.First;
  //*********** FIN IMPLEMENTACIÓN DE MUESTREO DE TOTALES

  for Conta:=1 to 12 do
    begin
      if not dbEsta.Locate('CC2',Conta,[]) then
        begin
           dbEsta.Append;
           dbEsta.FieldByName('CC0').AsString:=Edit1.Text;
           dbEsta.FieldByName('CC1').AsString:=Ano;
           dbEsta.FieldByName('CC2').AsString:=IntToStr(Conta);
           dbEsta.Post;
        end;
    end;
end;

//============================================================================
//======================== SISTEMA DE INFORMACION COMUN ======================
//============================================================================

//============= COMPROBAR CLIENTE EN SIC ==============
procedure TFClientes.GrabarModificarSic();
begin
   CodClienteSic:=dbClientes.FieldByName('C47').AsString;
   if LeerClienteSic=False then
     begin
        If Application.MessageBox('ESTE CLIENTE NO EXISTE EN EL S.I.C. (SISTEMA DE INFORMACION COMUN),    LO CREAMOS?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Append;
        RellenaSIC();
        dbCliSic.FieldByName('version').Value:=1;
        dbCliSic.Post;
        dbClientes.Edit;
        dbClientes.FieldByName('C46').AsString:='1';//------- Control de Version
        dbClientes.FieldByName('C47').AsString:=Edit1.Text;//-- Codigo siclinex
        dbClientes.Post;
     end
   else
     begin
        If Application.MessageBox('QUIERE ACTUALIZAR LOS CAMBIOS EN EL S.I.C.  (SISTEMA DE INFORMACION COMUN)?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Edit;
        dbCliSic.FieldByName('version').Value:=dbCliSic.FieldByName('version').AsInteger+1;
        RellenaSIC();
        dbCliSic.Post;
        dbClientes.Edit;
        dbClientes.FieldByName('C46').Value:=dbCliSic.FieldByName('version').Value;//------- Control de Version
        dbClientes.Post;
     end;
end;
//============= BORRAR CLIENTE EN SIC ==============
procedure TFClientes.BorrarSic();
begin
   if LeerClienteSic=False then exit;
     begin
        If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO EN EL S.I.C.  (SISTEMA DE INFORMACION COMUN)?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Delete;
     end;
end;

//============= LOCALIZAR CLIENTE EN SIC POR CODIGO INTERNO ==============
function TFClientes.LeerClienteSic: Boolean;
begin
  LeerClienteSic:=False;
  //------ Buscar por codigo interno
  if dbClientes.FieldByName('C47').AsString<>'' then
    begin
     dbCliSic.Active:=False;
     dbCliSic.SQL.Text:='SELECT * FROM clientes_proveedores WHERE CODIGO="'+CodClienteSic+'"'+
                        ' AND ES_CLIENTE=1';
     dbCliSic.Active:=True;
     if dbCliSIc.RecordCount<>0 then begin LeerClienteSic:=True; exit; end;
    end
  else
    begin
     //----- De todas maneras abro el dataset para grabar el cliente si no existe
     dbCliSic.Active:=False;
     dbCliSic.SQL.Text:='SELECT * FROM clientes_proveedores WHERE CODIGO="'+CodClienteSic+'"'+
                        ' AND ES_CLIENTE=1';
     dbCliSic.Active:=True;
    end;
end;

//=============== MOSTRAR PANEL DE BUSQUEDA CLIENTES SIC ===============
procedure TFClientes.BitBtn15Click(Sender: TObject);
begin
  Panel6.Visible:=True;
end;

//=================== BUSCAR CLIENTES DEL SIC PARA IMPORTAR ============
procedure TFClientes.BitBtn13Click(Sender: TObject);
var
  TxtQ: String;
begin
  BitBtn12.Enabled:=False; ListBox1.Items.Clear;
  if (Edit48.Text='') and (Edit49.Text='') then exit;
  TxtQ:='SELECT * FROM clientes_proveedores WHERE ES_CLIENTE=1 AND ';
  if Edit49.Text<>'' then TxtQ:=TxtQ+'NOMBRE LIKE "'+Edit49.Text+'%" ';
  if (Edit49.Text<>'') and (Edit48.Text<>'') then TxtQ:=TxtQ+'AND ';
  if Edit48.Text<>'' then TxtQ:=TxtQ+'NIF LIKE "'+Edit48.Text+'%"';
  dbCliSic.Active:=False;
  dbCliSic.SQL.Text:=TxtQ;
  dbCliSic.Active:=True;
  if dbCliSIc.RecordCount=0 then begin showmessage('NO EXISTEN DATOS CON ESE FILTRO.'); exit; end;
  dbCliSic.First;
  while not dbCliSic.EOF do
    begin
      ListBox1.Items.Add(dbCliSic.FieldByName('NOMBRE').AsString);
      dbCliSic.Next;
    end;
  ListBox1.ItemIndex:=0;
  BitBtn12.Enabled:=True;
end;

//=================== IMPORTAR CLIENTES DEL SIC ===============
procedure TFClientes.BitBtn12Click(Sender: TObject);
var
  Ultimo: Integer;
begin
  if ListBox1.Items.Count=0 then exit;//----- Si no hay clientes en la lista
  if ListBox1.ItemIndex=-1 then ListBox1.ItemIndex:=0; //--- Si no hay selecionado ninguno
  dbCliSic.Locate('Nombre',ListBox1.Items.Strings[ListBox1.ItemIndex],[]);
  //----- Buscar si existe en nuestro fichero
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM clientes WHERE C47="'+dbCliSic.FieldByName('CODIGO').AsString+'"';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    begin
       ShowMessage('ESTE CLIENTE DEL SIC YA EXISTE EN NUESTRO FICHERO CON EL CGO.:'+dbTrabajo.FieldByName('C0').AsString);
       Exit;
    end;
  //------ Ver cual es el ultimo cliente en nuestro file
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT C0 FROM clientes where C0<999990 ORDER BY C0 DESC';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then Ultimo:=1 else Ultimo:=dbTRabajo.FieldByName('C0').AsInteger+1;
  //------ Cargar datos en pantalla
  Edit1.Text:=IntToStr(Ultimo);
  CargaSIC();
  //------ Crear cliente en nuestro file
  if Application.MessageBox('CREAMOS EL REGISTRO EN NUESTRO FICHERO?','FacturLinEx', boxstyle) = IDYES Then
    begin
     dbClientes.Append;
     LlenaReg();
     dbClientes.FieldByName('C46').AsInteger:=dbCliSic.FieldByName('version').AsInteger;//- Control de Version
     dbClientes.FieldByName('C47').AsString:=dbCliSic.FieldByName('CODIGO').AsString;//--- Codigo siclinex
     dbClientes.Post;
     Label7.Caption:=dbClientes.FieldByName('C1').AsString;//--- Refrescar nombre.
    end
  else LimpiaForm();
  //---------------------
  dbTrabajo.Active:=False; ListBox1.Items.Clear;
  BitBtn12.Enabled:=False; Panel6.Visible:=False;
  Tabsheet1.SetFocus;
end;

//============== CERRAR PANEL IMPORTAR CLIENTES SIC ===========
procedure TFClientes.BitBtn14Click(Sender: TObject);
begin
  Panel6.Visible:=False; BitBtn12.Enabled:=False;
end;

//================== RELLENAR CAMPOS DEL SIC ===================
procedure TFClientes.RellenaSIC();
begin
  dbCliSic.FieldByName('NOMBRE').AsString:=Edit2.Text;
  dbCliSic.FieldByName('NIF').AsString:=Edit8.Text;
  dbCliSic.FieldByName('CODIGO').AsString:=Edit1.Text;
  dbCliSic.FieldByName('DIRECCION').AsString:=Edit4.Text;
  dbCliSic.FieldByName('CODPOSTAL').AsString:=Edit6.Text;
  dbCliSic.FieldByName('TELEFONO1').AsString:=Edit10.Text;
  dbCliSic.FieldByName('FAX').AsString:=Edit11.Text;
  dbCliSic.FieldByName('EMAIL').AsString:=Edit9.Text;
  dbCliSic.FieldByName('RESPONSABLE').AsString:=Edit3.Text;
  dbCliSic.FieldByName('ES_CLIENTE').AsString:='1';
end;

//================== RELLENAR CAMPOS DEL SIC ===================
procedure TFClientes.CargaSIC();
begin
  Edit2.Text:=dbCliSic.FieldByName('NOMBRE').AsString;
  Edit8.Text:=dbCliSic.FieldByName('NIF').AsString;
  Edit4.Text:=dbCliSic.FieldByName('DIRECCION').AsString;
  Edit6.Text:=dbCliSic.FieldByName('CODPOSTAL').AsString;
  Edit10.Text:=dbCliSic.FieldByName('TELEFONO1').AsString;
  Edit11.Text:=dbCliSic.FieldByName('FAX').AsString;
  Edit9.Text:=dbCliSic.FieldByName('EMAIL').AsString;
  Edit3.Text:=dbCliSic.FieldByName('RESPONSABLE').AsString;
end;

Initialization
  {$I clientes.lrs}

End.

