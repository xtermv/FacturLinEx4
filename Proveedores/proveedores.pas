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

Unit Proveedores;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType, DBGrids,
  TAGraph, TASeries, db, DbCtrls, DateUtils, EditBtn;


Type

  { TFProveedores }

  TFProveedores = Class(Tform)
    Bevel1: TBevel;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    Chart1: TChart;
    Chart1AreaSeries1: TAreaSeries;
    Chart1BarSeries1: TBarSeries;
    Chart1PieSeries1: TPieSeries;
    Chart1Serie1: TLineSeries;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    DateEdit3: TDateEdit;
    DateEdit4: TDateEdit;
    dbRoles: TZQuery;
    dbCliSic: TZQuery;
    dbTrabajo: TZQuery;
    dbBusca: TZQuery;
    Edit48: TEdit;
    Edit49: TEdit;
    Edit51: TEdit;
    Label19: TLabel;
    Label25: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label65: TLabel;
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
    ListBox6: TListBox;
    ListBox7: TListBox;
    PanelNuevoPro: TPanel;
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
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit29: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit37: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Edit40: TEdit;
    Edit41: TEdit;
    Edit42: TEdit;
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
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label31: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
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
    dbProve: TZQuery;
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
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure DateEdit1Exit(Sender: TObject);
    procedure DateEdit2Exit(Sender: TObject);
    procedure DateEdit3Exit(Sender: TObject);
    procedure DateEdit4Exit(Sender: TObject);
    procedure Edit12Enter(Sender: TObject);
    procedure Edit12Exit(Sender: TObject);
    procedure Edit15Enter(Sender: TObject);
    procedure Edit15Exit(Sender: TObject);
    procedure Edit1MouseEnter(Sender: TObject);
    procedure Edit1MouseLeave(Sender: TObject);
    procedure Edit22Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    Procedure Formcreate(Sender: Tobject);
    Procedure Edit1enter(Sender: Tobject);
    Procedure Edit1exit(Sender: Tobject);
    Procedure LimpiaForm();
    procedure ListBox2DblClick(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure ListBox4Click(Sender: TObject);
    procedure ListBox5Click(Sender: TObject);
    procedure ListBox6DblClick(Sender: TObject);
    procedure ListBox7Click(Sender: TObject);
    Procedure Relleno();
    Procedure LlenaReg();
    Procedure VerTipoPago();
    Procedure VerRutas();
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

  procedure ShowFormProveedores;
  
Var
  FProveedores: TFProveedores;
  CargaGrafica, NTienda: Integer;
  s: TBarSeries;
  CodClienteSic: String;

Implementation

uses
  Global, Funciones, Busquedas;
  
//=============== CREAR EL FORMULARIO ================
procedure ShowFormProveedores;
begin
  with TFProveedores.Create(Application) do
    begin
       ShowModal;
    end;
end;
Procedure TFProveedores.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbProve.Sql.Text:='SELECT * FROM proveedores ORDER BY P0';
  dbProve.Active := True;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Proveed', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Proveed', 3);//------------------ Boton Borrar
  if CheckRoles(dbRoles, CgRol, 'Proveed', 4)=False then Tabsheet2.Destroy;//--- Estadisticas
  if CheckRoles(dbRoles, CgRol, 'Proveed', 4)=False then Tabsheet3.Destroy;//--- Graficas
  if CheckRoles(dbRoles, CgRol, 'Proveed', 5)=False then Tabsheet4.Destroy;//--- Datos de facturacion
  if CheckRoles(dbRoles, CgRol, 'Proveed', 6)=False then Tabsheet5.Destroy;//--- Datos bancarios
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
Procedure TFProveedores.Bitbtn1click(Sender: Tobject);
Begin
  Close();
End;
Procedure TFProveedores.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;
//=================== REGISTRO NUEVO ===================
Procedure TFProveedores.Bitbtn2click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if dbProve.Locate('P0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO YA EXISTE');
      exit;
    end;
   dbProve.Append; LlenaReg(); dbProve.Post;
   Label7.Caption:=dbProve.Fields[1].AsString; //--- Refrescar nombre.
   if ActivarSIC='S' then GrabarModificarSic();//------ Comprobar si se crea cliente en el SIC.
End;
//=================== BORRAR REGISTRO ===================
Procedure TFProveedores.Bitbtn3click(Sender: Tobject);
Begin
   if Edit1.Text='' then exit;
   if not dbProve.Locate('P0', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
       exit;
     end;
   CodClienteSic:=dbProve.FieldByName('P39').AsString;//---- Para leer cliente en el sic.
   if Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
       Exit;
   dbProve.Delete; Edit1.Text := ''; LimpiaForm();
   if ActivarSIC='S' then BorrarSic();//------ Comprobar si se crea cliente en el SIC.
End;

//=================== MODIFICAR ===================
Procedure TFProveedores.Bitbtn4click(Sender: Tobject);
Begin
   if (Edit1.Text='') or (dbProve.Recordcount=0) then exit;
   if not dbProve.Locate('P0,', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO!');
       exit;
     end;
   If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
   dbProve.Edit; LlenaReg(); dbProve.Post;
   Label7.Caption:=dbProve.Fields[1].AsString;//--- Refrescar nombre.
   if ActivarSIC='S' then GrabarModificarSic();//------ Comprobar si se modifica cliente en el SIC.
End;

//==================== REG. ANTERIOR ===============
Procedure TFProveedores.Bitbtn5click(Sender: Tobject);
Begin
  dbProve.Prior;
  LimpiaForm(); Relleno();
End;

//==================== REG. POSTERIOR ===============
Procedure TFProveedores.Bitbtn6click(Sender: Tobject);
Begin
   dbProve.Next;
   LimpiaForm(); Relleno();
End;

//=================== CODIGO DEL PROVEEDOR ================
Procedure TFProveedores.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;
Procedure TFProveedores.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbProve.Locate('P0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;

//================== BUSCAR PROVEEDORES ================
procedure TFProveedores.BitBtn18Click(Sender: TObject);
begin
   if Edit2.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit2.SetFocus;
     Exit;
  end;
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT P0,P1 FROM proveedores WHERE P1 LIKE "%'+Edit2.Text+'%"',
                                         ['Código','Razón Social'], 'P0');
  if ((Edit1.Text='-') or (Edit1.Text='-1')) then Edit1.Text:='' else Edit1Exit(Edit1);
end;

procedure TFProveedores.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn18Click(BitBtn8);
end;

//================== CHEQUEAR FECHAS ULTIMA VENTA/COMPRA ==================
procedure TFProveedores.DateEdit1Exit(Sender: TObject);
begin
  if not EsFechaValida(DateEdit1.text) Then ShowMessage('Formato de Fecha Invalido, debe ser DD/MM/AAAA');
end;
procedure TFProveedores.DateEdit2Exit(Sender: TObject);
begin
  if not EsFechaValida(DateEdit2.text) Then ShowMessage('Formato de Fecha Invalido, debe ser DD/MM/AAAA');
end;
//================== CHEQUEAR FECHAS HISTORICO DE COMPRAS ==================
procedure TFProveedores.DateEdit3Exit(Sender: TObject);
begin
  if not EsFechaValida(DateEdit3.text) Then ShowMessage('Formato de Fecha Invalido, debe ser DD/MM/AAAA');
end;
procedure TFProveedores.DateEdit4Exit(Sender: TObject);
begin
  if not EsFechaValida(DateEdit4.text) Then ShowMessage('Formato de Fecha Invalido, debe ser DD/MM/AAAA');
end;

//===================== LIMPIAR DATOS =======================
Procedure TFProveedores.LimpiaForm();
Begin
  Edit2.Text:=''; Edit3.Text:=''; Edit4.Text:=''; Edit5.Text:='';
  Edit6.Text:=''; Label7.Caption:='';
  Edit7.Text:=''; Edit8.Text:=''; Edit9.Text:=''; Edit10.Text:='';
  Edit11.Text:=''; Edit12.Text:=''; Edit13.Text:='';
  Edit14.Text:=''; Memo1.Lines.Text:=''; Edit15.Text:='';
  Edit16.Text:=''; Edit17.Text:=''; Edit18.Text:='';
  Edit20.Text:=''; Edit21.Text:='';
  Edit22.Text:=''; Edit29.Text:='';
  // Edit31.Text:=''; // Cambiado Por DateEdit1
  Edit32.Text:=''; Edit33.Text:='';
  //DateEdit1.Date:=Null;DateEdit2.Date:=Null;
  //DateEdit1.Date:=Date;DateEdit2.Date:=Date;
  DateEdit1.Text:=''; DateEdit2.Text:='';
  Edit34.Text:=''; Edit35.Text:='';
  Edit37.Text:=''; Edit38.Text:=''; Edit39.Text:='';
  Edit40.Text:=''; Edit41.Text:=''; Edit42.Text:='';
  // Edit43.Text:=''; Edit44.Text:='';  // CambiadoS Por DateEdit3 y DateEdit4
  Edit45.Text:='';
  DateEdit3.Date:=StartOfTheMonth(Date);DateEdit4.Date:=Date;
  Edit46.Text:=''; Edit47.Text:=''; Edit51.Text:='';
  CheckBox3.Checked:=False; CheckBox4.Checked:=False;
  CheckBox5.Checked:=False; StaticText1.Caption:='';
  StaticText2.Caption:='';

End;

//===================== PINTAR DATOS =======================
Procedure TFProveedores.Relleno();
Begin
  if dbProve.RecordCount=0 then exit;
  Label7.Caption:=dbProve.FieldByName('P1').AsString;//---------- Nombre (Arriba)
  Edit1.Text:=dbProve.FieldByName('P0').AsString;//-------------- Cgo. Proveedor
  Edit2.Text:=dbProve.FieldByName('P1').AsString;//-------------- Nombre
  Edit4.Text:=dbProve.FieldByName('P2').AsString;//-------------- Direccion
  Edit5.Text:=dbProve.FieldByName('P3').AsString;//-------------- Localidad
  Edit6.Text:=dbProve.FieldByName('P4').AsString;//-------------- C.Postal
  Edit7.Text:=dbProve.FieldByName('P5').AsString;//-------------- Provincia
  Edit8.Text:=dbProve.FieldByName('P6').AsString;//-------------- N.I.F.
  Edit9.Text:=dbProve.FieldByName('P34').AsString;//------------- E-Mail
  Edit10.Text:=dbProve.FieldByName('P7').AsString;//------------- Telef.
  Edit11.Text:=dbProve.FieldByName('P8').AsString;//------------- Fax
  Edit3.Text:=dbProve.FieldByName('P9').AsString;//-------------- Representante
  Edit51.Text:=dbProve.FieldByName('P10').AsString;//------------ Telefono Representante
  Edit12.Text:=dbProve.FieldByName('P11').AsString;//------------ Tipo de pago
  if Edit12.Text<>'' then VerTipoPago();//----------------------- Nombre tipo de pago
  Edit13.Text:=dbProve.FieldByName('P13').AsString;//------------ Mes de vacaciones
  Edit14.Text:=dbProve.FieldByName('P14').AsString;//------------ Dias de pago
  Edit15.Text:=dbProve.FieldByName('P12').AsString;//------------ Distintivo / Ruta
  if Edit15.Text<>'' then VerRutas();//-------------------------- Nombre distintivo / ruta
  Memo1.Lines.Text:=dbProve.FieldByName('P35').AsString;//------- Observaciones
  Edit16.Text:=dbProve.FieldByName('P15').AsString;//------------ Dias hasta 1º plazo
  Edit17.Text:=dbProve.FieldByName('P16').AsString;//------------ Dias entre plazos
  Edit18.Text:=dbProve.FieldByName('P17').AsString;//------------ Numero de plazos
  Edit20.Text:=dbProve.FieldByName('P18').AsString;//------------ Dto. comercial
  Edit21.Text:=dbProve.FieldByName('P19').AsString;//------------ Dto. pronto pago
  Edit22.Text:=dbProve.FieldByName('P20').AsString;//------------ Recargo equivalencia S/N
  Edit29.Text:=dbProve.FieldByName('P21').AsString;//------------ Minimo primer plazo
  //Edit31.Text:=dbProve.FieldByName('P22').AsString;//------------ Fecha ultima Venta
  //Edit50.Text:=dbProve.FieldByName('P23').AsString;//------------ Fecha ultima Compra
  DateEdit1.Date:=dbProve.FieldByName('P22').AsDateTime;//------------ Fecha ultima Venta
  DateEdit2.Date:=dbProve.FieldByName('P23').AsDateTime;//------------ Fecha ultima Compra

  Edit32.Text:=dbProve.FieldByName('P24').AsString;//------------ Agencia de transportes
  Edit33.Text:=dbProve.FieldByName('P26').AsString;//------------ Domicilio de entrega
  Edit34.Text:=dbProve.FieldByName('P27').AsString;//------------ Localidad de entrega
  Edit35.Text:=dbProve.FieldByName('P25').AsString;//------------ Portes D/P

  Edit37.Text:=dbProve.FieldByName('P28').AsString;//------------ Nombre banco / caja
  Edit38.Text:=dbProve.FieldByName('P29').AsString;//------------ N. Cuenta
  Edit39.Text:=dbProve.FieldByName('P30').AsString;//------------ Domicilio banco
  Edit40.Text:=dbProve.FieldByName('P31').AsString;//------------ Localidad banco
  Edit41.Text:=dbProve.FieldByName('P32').AsString;//------------ Cuenta de cargo
  Edit42.Text:=dbProve.FieldByName('P33').AsString;//------------ Cuenta de abono

  //-------------- Estadisticas --------------------
  RellenaEsta(FormatDateTime('YYYY',Date));//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, PP6-PP7 As BENEF FROM estaprove WHERE PP0="'+Edit1.Text+'"'+
                   ' AND PP1='+FormatDateTime('YYYY',Date)+
                   ' ORDER BY PP1 ASC, PP2 ASC';
  dbEsta.Active:=True;
  //------------------------------------------------
  CargaGrafica:=1; Graficas(); CargaGrafica:=0;//---------------- Pintar Graficas

  //-------------- Historico de compras --------------------
  //Edit43.Text:='01/'+FormatDateTime('MM/YYYY',Date);
  //Edit43.Text:=FormatDateTime(ShortDateFormat, StartOfTheMonth(Date));
  DateEdit3.Date:=StartOfTheMonth(Date);
  //Edit44.Text:=FormatDateTime('DD/MM/YYYY',Date);
  //Edit44.Text:=FormatDateTime(ShortDateFormat,Date);
  DateEdit4.Date:=Date;
  dbHisto.Active:=False;
  dbHisto.SQL.Text:='SELECT * FROM hipedidd'+Tienda+' WHERE HPD2='+Edit1.Text+
                    ' AND HPD1>="'+FormatDateTime('YYYY-MM-DD',DateEdit3.Date)+'"'+
                    ' AND HPD1<="'+FormatDateTime('YYYY-MM-DD',DateEdit4.Date)+'"'+
                    ' ORDER BY HPD1 DESC';
                    // Se modifoco para cambiar a TDateEdit
                    //' AND AP1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit43.Text))+'"'+
                    //' AND AP1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit44.Text))+'"'+
  dbHisto.Active:=True;
  //-------------- Ver si esta es la misma version que la del SIC
  CodClienteSic:=dbProve.FieldByName('P39').AsString;
  if (ActivarSIC='S') and (LeerClienteSic=true) then
    begin
      if (dbCliSic.FieldByName('ES_PROVEEDOR').AsString='1') and
         (dbProve.FieldByName('P38').AsInteger<dbCliSic.FieldByName('version').AsInteger) then
         If Application.MessageBox('EXISTE DATOS ACTUALIZADOS DE ESTE PROVEEDOR EN EL SISTEMA SIC, LOS ACTUALIZO AQUI?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
            Exit
         else
          begin
            CargaSic();
            If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
               Exit;
            dbProve.Edit; LlenaReg(); dbProve.Post;
            Label7.Caption:=dbProve.Fields[1].AsString;//--- Refrescar nombre.
            dbProve.Edit;
            dbProve.FieldByName('P38').Value:=dbCliSic.FieldByName('version').Value;//------- Control de Version
            dbProve.Post;
          end;
    end;
End;
//===================== RELLENAR DATOS =======================
Procedure TFProveedores.LlenaReg();
Begin
  dbProve.FieldByName('P0').AsString:=Edit1.Text;//-------------- Cgo. Proveedor
  dbProve.FieldByName('P1').AsString:=Edit2.Text;//-------------- Nombre
  dbProve.FieldByName('P2').AsString:=Edit4.Text;//-------------- Direccion
  dbProve.FieldByName('P3').AsString:=Edit5.Text;//-------------- Localidad
  dbProve.FieldByName('P4').AsString:=Edit6.Text;//-------------- C.Postal
  dbProve.FieldByName('P5').AsString:=Edit7.Text;//-------------- Provincia
  dbProve.FieldByName('P6').AsString:=Edit8.Text;//-------------- N.I.F.
  dbProve.FieldByName('P34').AsString:=Edit9.Text;//------------- E-Mail
  dbProve.FieldByName('P7').AsString:=Edit10.Text;//------------- Telef.
  dbProve.FieldByName('P8').AsString:=Edit11.Text;//------------- Fax
  dbProve.FieldByName('P9').AsString:=Edit3.Text;//-------------- Representante
  dbProve.FieldByName('P10').AsString:=Edit51.Text;//------------ Telef Repre.
  dbProve.FieldByName('P11').AsString:=Edit12.Text;//------------ Tipo de pago
  dbProve.FieldByName('P13').AsString:=Edit13.Text;//------------ Mes de vacaciones
  dbProve.FieldByName('P14').AsString:=Edit14.Text;//------------ Dias de pago
  dbProve.FieldByName('P12').AsString:=Edit15.Text;//------------ Distintivo / Ruta
  dbProve.FieldByName('P35').AsString:=Memo1.Lines.Text;//------- Observaciones
  dbProve.FieldByName('P15').AsString:=Edit16.Text;//------------ Dias hasta 1º plazo
  dbProve.FieldByName('P16').AsString:=Edit17.Text;//------------ Dias entre plazos
  dbProve.FieldByName('P17').AsString:=Edit18.Text;//------------ Numero de plazos
  dbProve.FieldByName('P18').AsString:=Edit20.Text;//------------ Dto. comercial
  dbProve.FieldByName('P19').AsString:=Edit21.Text;//------------ Dto. pronto pago
  dbProve.FieldByName('P20').AsString:=Edit22.Text;//------------ Recargo equivalencia S/N
  dbProve.FieldByName('P21').AsString:=Edit29.Text;//------------ Minimo primer plazo

  //----- Fecha ultima Venta
  //if Edit43.Text='' then
  if DateEdit1.Date=Null then
    dbProve.FieldByName('P22').Value:=Null
  else
    //dbProve.FieldByName('P22').AsString:=Edit31.Text;//---------- Fecha ultima Venta
    dbProve.FieldByName('P22').AsDateTime:=DateEdit1.Date;//---------- Fecha ultima Venta

  //----- Fecha ultima Compra
  // if Edit50.Text='' then
  if DateEdit2.Date=Null then
    dbProve.FieldByName('P23').Value:=Null
  else
//    dbProve.FieldByName('P23').AsString:=Edit50.Text;//---------- Fecha ultima Compra
    dbProve.FieldByName('P23').AsDateTime:=DateEdit2.Date;//---------- Fecha ultima Compra

  dbProve.FieldByName('P24').AsString:=Edit32.Text;//------------ Agencia de transportes
  dbProve.FieldByName('P26').AsString:=Edit33.Text;//------------ Domicilio de entrega
  dbProve.FieldByName('P27').AsString:=Edit34.Text;//------------ Localidad de entrega
  dbProve.FieldByName('P25').AsString:=Edit35.Text;//------------ Portes D/P

  dbProve.FieldByName('P28').AsString:=Edit37.Text;//------------ Nombre banco / caja
  dbProve.FieldByName('P29').AsString:=Edit38.Text;//------------ N. Cuenta
  dbProve.FieldByName('P30').AsString:=Edit39.Text;//------------ Domicilio banco
  dbProve.FieldByName('P31').AsString:=Edit40.Text;//------------ Localidad banco
  dbProve.FieldByName('P32').AsString:=Edit41.Text;//------------ Cuenta de cargo
  dbProve.FieldByName('P33').AsString:=Edit42.Text;//------------ Cuenta de abono

End;

//========================================================
//=================== TIPOS DE PAGOS =====================
//========================================================
procedure TFProveedores.BitBtn7Click(Sender: TObject);
begin
  dbPagos.SQL.Text:='SELECT * FROM formapago ORDER BY FPA1 ASC';
  dbPagos.Active:=True;
  if dbPagos.RecordCount=0 then exit;
  dbPagos.First; ListBox2.Items.Clear;
  while not dbPagos.EOF do
    begin
      ListBox2.Items.Add(Space(2-length(dbPagos.FieldByName('FPA0').AsString))+
                         dbPagos.FieldByName('FPA0').AsString+' '+
                         dbPagos.FieldByName('FPA1').AsString);
      dbPagos.Next;
    end;
  dbPagos.Active:=False; Panel5.Visible:=True;
end;

//------------------- VER TIPOS DE PAGO -----------------
procedure TFProveedores.Edit12Enter(Sender: TObject);
begin
  StaticText1.Caption:=''
end;
procedure TFProveedores.Edit12Exit(Sender: TObject);
begin
  if Edit12.Text<>'' then VerTipoPago();
end;
Procedure TFProveedores.VerTipoPago();
Begin
  dbPagos.Active:=False;
  dbPagos.SQL.Text:='SELECT * FROM formapago WHERE FPA0='+Edit12.Text;
  dbPagos.Active:=True;
  if dbPagos.RecordCount=0 then
   StaticText1.Caption:=''
  else
   StaticText1.Caption:=dbPagos.Fields[1].AsString;
  dbPagos.Active:=False;
End;
//------------------- SELECCIONAR TIPO DE PAGO ---------------
procedure TFProveedores.ListBox2DblClick(Sender: TObject);
begin
  Edit12.Text:=trim(copy(ListBox2.Items.Strings[ListBox2.ItemIndex],1,2));
  if Edit12.Text<>'' then Edit12Exit(Edit12);
  Panel5.Visible:=False;
end;
//--------------- Cerrar tipos de pagos / cobros -------------
procedure TFProveedores.BitBtn10Click(Sender: TObject);
begin
  Panel5.Visible:=False;
end;

//=======================================================
//================= DISTINTIVOS / RUTAS =================
//=======================================================
procedure TFProveedores.BitBtn8Click(Sender: TObject);
begin
  dbPagos.SQL.Text:='SELECT * FROM rutas'+Tienda+' ORDER BY RUT1 ASC';
  dbPagos.Active:=True;
  if dbPagos.RecordCount=0 then exit;
  dbPagos.First; ListBox6.Items.Clear;
  while not dbPagos.EOF do
    begin
      ListBox6.Items.Add(Space(7-length(dbPagos.FieldByName('RUT0').AsString))+
                         dbPagos.FieldByName('RUT0').AsString+' '+
                         dbPagos.FieldByName('RUT1').AsString);
      dbPagos.Next;
    end;
  dbPagos.Active:=False; Panel7.Visible:=True;
end;

//-------------- Seleccionar distintivos / rutas -------
procedure TFProveedores.ListBox6DblClick(Sender: TObject);
begin
  Edit15.Text:=trim(copy(ListBox6.Items.Strings[ListBox6.ItemIndex],1,7));
  if Edit15.Text<>'' then Edit15Exit(Edit15);
  Panel7.Visible:=False;
end;

//-------------- Cerrar distintivos / rutas -------
procedure TFProveedores.BitBtn16Click(Sender: TObject);
begin
  Panel7.Visible:=False;
end;

//-------------- Ver distintivos / rutas -------
procedure TFProveedores.Edit15Enter(Sender: TObject);
begin
  StaticText2.Caption:='';
end;
procedure TFProveedores.Edit15Exit(Sender: TObject);
begin
  if Edit15.Text<>'' then VerRutas();
end;

procedure TFProveedores.Edit1MouseEnter(Sender: TObject);
var
  Ultimo : Integer;
begin
  PanelNuevoPro.Visible:=True;
  //------ Ver cual es el ultimo proveedor en nuestro file
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT P0 FROM proveedores where P0<999990 ORDER BY P0 DESC';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then Ultimo:=1 else Ultimo:=dbTRabajo.FieldByName('P0').AsInteger+1;
  //------ Cargar datos en pantalla
  PanelNuevoPro.Caption:=IntToStr(Ultimo);end;

procedure TFProveedores.Edit1MouseLeave(Sender: TObject);
begin
  PanelNuevoPro.Visible:=False;
end;

Procedure TFProveedores.VerRutas();
Begin
  dbPagos.Active:=False;
  dbPagos.SQL.Text:='SELECT * FROM rutas'+Tienda+' WHERE RUT0='+Edit15.Text;
  dbPagos.Active:=True;
  if dbPagos.RecordCount=0 then
   StaticText2.Caption:=''
  else
   StaticText2.Caption:=dbPagos.Fields[1].AsString;
  dbPagos.Active:=False;
End;

//=================== CONTROLAR RECARGO EQUIVALENCIA ===============
procedure TFProveedores.Edit22Exit(Sender: TObject);
begin
  if Edit22.Text='' then Edit22.Text:='N';
  if (Edit22.Text='S') or (Edit22.Text='N') then exit;
  showmessage('Debe teclear S o N en este campo.');
  Edit22.SetFocus;
end;

//=======================================================
//============= FILTRO HIST. COMPRAS ====================
//=======================================================
//------------- Buscar codigo ------------
procedure TFProveedores.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked=True then
    Edit45.Enabled:=True else Edit45.Enabled:=False;
end;
//------------- Buscar unidades ----------
procedure TFProveedores.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked=True then
    Edit46.Enabled:=True else Edit46.Enabled:=False;
end;
//------------- Buscar importe ----------
procedure TFProveedores.CheckBox5Click(Sender: TObject);
begin
  if CheckBox5.Checked=True then
    Edit47.Enabled:=True else Edit47.Enabled:=False;
end;

//------------ APLICAR FILTRO -----------
procedure TFProveedores.BitBtn11Click(Sender: TObject);
var
  Codigo,Unidades,Importe: String;
begin
  if (Edit1.Text = '') Then
     begin
       ShowMessage('Primero debe Selecionar un Proveedor, verifique');
       exit;
     end;

  //if Edit43.Text='' then Edit43.Text:='01/'+FormatDateTime('MM/YYYY',Date);
  if DateEdit1.Date=Null then DateEdit3.Date:=StartOfTheMonth(Date);
  //if Edit44.Text='' then Edit44.Text:=FormatDateTime('DD/MM/YYYY',Date);
  if DateEdit2.Date=Null then DateEdit4.Date:=Date;
  //if StrToDate(Edit43.Text) > StrToDate(Edit44.Text) then
  if DateEdit3.Date > DateEdit4.Date then
    begin ShowMessage('LA PRIMERA FECHA NO PUEDE SER MAYOR QUE LA ULTIMA'); exit; end;
  //------- Ver si buscar por codigo
  if (CheckBox3.Checked=True) and (Edit45.Text<>'') then
    Codigo:=' AND HPD6="'+Edit45.Text+'"' else Codigo:='';
  //------- Ver si buscar por unidades
  if (CheckBox4.Checked=True) and (Edit46.Text<>'') then
    Unidades:=' AND HPD8='+Edit46.Text else Unidades:='';
  //------- Ver si buscar por importe
  if (CheckBox5.Checked=True) and (Edit47.Text<>'') then
    Importe:=' AND HPD17='+Edit47.Text else Importe:='';
  //-------------------------------------
  dbHisto.Active:=False;
  dbHisto.SQL.Text:='SELECT * FROM hipedidd'+Tienda+' WHERE HPD2='+Edit1.Text+
                    ' AND HPD1>="'+FormatDateTime('YYYY-MM-DD',DateEdit3.Date)+'"'+
                    ' AND HPD1<="'+FormatDateTime('YYYY-MM-DD',DateEdit4.Date)+'"'+
                    Codigo + Unidades + Importe +
                    ' ORDER BY HPD1 DESC';
  dbHisto.Active:=True;
end;

//============================================================
//===================== GRAFICAS =============================
//============================================================
procedure TFProveedores.Graficas();
Var
  Conta: Integer;
begin
  //-------------- Mostrar los distintos años ------------------
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT DISTINCT PP1 FROM estaprove WHERE PP0="'+Edit1.Text+'" ORDER BY PP1 DESC';
  dbGrafica.Active:=True;
  ListBox3.Items.Clear; ListBox5.Items.Clear;
  dbGrafica.First;
  while not dbGrafica.EOF do
    begin
      ListBox3.Items.Add(dbGrafica.FieldByName('PP1').AsString);
      ListBox5.Items.Add(dbGrafica.FieldByName('PP1').AsString);
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
     dbGrafica.SQL.Text:='SELECT *, PP6-PP7 As BENEF FROM estaprove WHERE PP0="'+Edit1.Text+'"'+
                         ' AND PP1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                         ' ORDER BY PP1 ASC, PP2 ASC';
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
procedure TFProveedores.ListBox3Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//------------------ Cambiar datos grafica -------------------
procedure TFProveedores.ListBox4Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//----------------- Cambiar tipo de grafica ----------------
procedure TFProveedores.ListBox7Click(Sender: TObject);
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
procedure TFProveedores.CambiarGrafica();
var
  Conta: Integer;
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox3.Items.Count=0 then exit;//----- Si no hay años
  if ListBox3.ItemIndex=-1 then ListBox3.ItemIndex:=0;
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT *, PP6-PP7 As BENEF FROM estaprove WHERE PP0="'+Edit1.Text+'"'+
                      ' AND PP1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                      ' ORDER BY PP1 ASC, PP2 ASC';
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
procedure TFProveedores.ListBox5Click(Sender: TObject);
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox5.Items.Count=0 then exit;//----- Si no hay años
  if ListBox5.ItemIndex=-1 then ListBox5.ItemIndex:=0;
  RellenaEsta(ListBox5.Items.Strings[ListBox5.ItemIndex]);//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, PP6-PP7 As BENEF FROM estaprove WHERE PP0="'+Edit1.Text+'"'+
                   ' AND PP1='+ListBox5.Items.Strings[ListBox5.ItemIndex]+
                   ' ORDER BY PP1 ASC, PP2 ASC';
  dbEsta.Active:=True;
end;

//==========================================================
//============= RELLENAR MESES QUE ESTEN A 0 ===============
//==========================================================
procedure TFProveedores.RellenaEsta(Ano: String);
var
  Conta: Integer;
  UC,IC,UV,IVP,IVC,Beneficio : Double;
begin
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT * FROM estaprove WHERE PP0="'+Edit1.Text+'"'+
                   ' AND PP1='+Ano+
                   ' ORDER BY PP1 ASC, PP2 ASC';
  dbEsta.Active:=True;
  dbEsta.First;

  //*********** IMPLEMENTACIÓN DE MUESTREO DE TOTALES
    UC:=0; IC:=0; UV:=0; IVP:=0; IVC:=0; Beneficio:=0;
    While not dbEsta.EOF do
      begin
        UC := UC + dbEsta.FieldByName('PP3').Value;
        IC := IC + dbEsta.FieldByName('PP4').Value;
        UV := UV + dbEsta.FieldByName('PP5').Value;
        IVP := IVP + dbEsta.FieldByName('PP6').Value;
        IVC := IVC + dbEsta.FieldByName('PP7').Value;
        Beneficio := Beneficio + ( dbEsta.FieldByName('PP6').Value - dbEsta.FieldByName('PP7').Value );
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
      if not dbEsta.Locate('PP2',Conta,[]) then
        begin
           dbEsta.Append;
           dbEsta.FieldByName('PP0').AsString:=Edit1.Text;
           dbEsta.FieldByName('PP1').AsString:=Ano;
           dbEsta.FieldByName('PP2').AsString:=IntToStr(Conta);
           dbEsta.Post;
        end;
    end;
end;

//============================================================================
//======================== SISTEMA DE INFORMACION COMUN ======================
//============================================================================

//============= COMPROBAR CLIENTE EN SIC ==============
procedure TFProveedores.GrabarModificarSic();
begin
   CodClienteSic:=dbProve.FieldByName('P39').AsString;
   if LeerClienteSic=False then
     begin
        If Application.MessageBox('ESTE PROVEEDOR NO EXISTE EN EL S.I.C. (SISTEMA DE INFORMACION COMUN),    LO CREAMOS?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Append;
        RellenaSIC();
        dbCliSic.FieldByName('version').Value:=1;
        dbCliSic.Post;
        dbProve.Edit;
        dbProve.FieldByName('P38').AsString:='1';//--------- Control de Version
        dbProve.FieldByName('P39').AsString:=Edit1.Text;//-- Codigo siclinex
        dbProve.Post;
     end
   else
     begin
        If Application.MessageBox('QUIERE ACTUALIZAR LOS CAMBIOS EN EL S.I.C.  (SISTEMA DE INFORMACION COMUN)?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Edit;
        dbCliSic.FieldByName('version').Value:=dbCliSic.FieldByName('version').AsInteger+1;
        RellenaSIC();
        dbCliSic.Post;
        dbProve.Edit;
        dbProve.FieldByName('P38').Value:=dbCliSic.FieldByName('version').Value;//------- Control de Version
        dbProve.Post;
     end;
end;
//============= BORRAR CLIENTE EN SIC ==============
procedure TFProveedores.BorrarSic();
begin
   if LeerClienteSic=False then exit;
     begin
        If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO EN EL S.I.C.  (SISTEMA DE INFORMACION COMUN)?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Delete;
     end;
end;

//============= LOCALIZAR CLIENTE EN SIC POR CODIGO INTERNO ==============
function TFProveedores.LeerClienteSic: Boolean;
begin
  LeerClienteSic:=False;
  //------ Buscar por codigo interno
  if dbProve.FieldByName('P39').AsString<>'' then
    begin
     dbCliSic.Active:=False;
     dbCliSic.SQL.Text:='SELECT * FROM clientes_proveedores WHERE CODIGO="'+CodClienteSic+'"'+
                        ' AND ES_PROVEEDOR=1';
     dbCliSic.Active:=True;
     if dbCliSIc.RecordCount<>0 then begin LeerClienteSic:=True; exit; end;
    end
  else
    begin
     //----- De todas maneras abro el dataset para grabar el cliente si no existe
     dbCliSic.Active:=False;
     dbCliSic.SQL.Text:='SELECT * FROM clientes_proveedores WHERE CODIGO="'+CodClienteSic+'"'+
                        ' AND ES_PROVEEDOR=1';
     dbCliSic.Active:=True;
    end;
end;

//=============== MOSTRAR PANEL DE BUSQUEDA PROVEEDORES SIC ===============
procedure TFProveedores.BitBtn15Click(Sender: TObject);
begin
  Panel6.Visible:=True;
end;

//=================== BUSCAR PROVEEDORES DEL SIC PARA IMPORTAR ============
procedure TFProveedores.BitBtn13Click(Sender: TObject);
var
  TxtQ: String;
begin
  BitBtn12.Enabled:=False; ListBox1.Items.Clear;
  if (Edit48.Text='') and (Edit49.Text='') then exit;
  TxtQ:='SELECT * FROM clientes_proveedores WHERE ES_PROVEEDOR=1 AND ';
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

//=================== IMPORTAR PROVEEDORES DEL SIC ===============
procedure TFProveedores.BitBtn12Click(Sender: TObject);
var
  Ultimo: Integer;
begin
  if ListBox1.Items.Count=0 then exit;//----- Si no hay proveedores en la lista
  if ListBox1.ItemIndex=-1 then ListBox1.ItemIndex:=0; //--- Si no hay selecionado ninguno
  dbCliSic.Locate('Nombre',ListBox1.Items.Strings[ListBox1.ItemIndex],[]);
  //----- Buscar si existe en nuestro fichero
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM proveedores WHERE P39="'+dbCliSic.FieldByName('CODIGO').AsString+'"';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    begin
       ShowMessage('ESTE PROVEEDOR DEL SIC YA EXISTE EN NUESTRO FICHERO CON EL CGO.:'+dbTrabajo.FieldByName('P0').AsString);
       Exit;
    end;
  //------ Ver cual es el ultimo proveedor en nuestro file
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT P0 FROM proveedores where P0<999990 ORDER BY P0 DESC';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then Ultimo:=1 else Ultimo:=dbTRabajo.FieldByName('P0').AsInteger+1;
  //------ Cargar datos en pantalla
  Edit1.Text:=IntToStr(Ultimo);
  LimpiaForm(); CargaSIC();
  //------ Crear proveedor en nuestro file
  if Application.MessageBox('CREAMOS EL REGISTRO EN NUESTRO FICHERO?','FacturLinEx', boxstyle) = IDYES Then
    begin
     dbProve.Append;
     LlenaReg();
     dbProve.FieldByName('P38').AsInteger:=dbCliSic.FieldByName('version').AsInteger;//- Control de Version
     dbProve.FieldByName('P39').AsString:=dbCliSic.FieldByName('CODIGO').AsString;//--- Codigo siclinex
     dbProve.Post;
     Label7.Caption:=dbProve.FieldByName('P1').AsString;//--- Refrescar nombre.
    end
  else LimpiaForm();
  //---------------------
  dbTrabajo.Active:=False; ListBox1.Items.Clear;
  BitBtn12.Enabled:=False; Panel6.Visible:=False;
  Tabsheet1.SetFocus;
end;

//============== CERRAR PANEL IMPORTAR PROVEEDORES SIC ===========
procedure TFProveedores.BitBtn14Click(Sender: TObject);
begin
  Panel6.Visible:=False; BitBtn12.Enabled:=False;
end;

//================== RELLENAR CAMPOS DEL SIC ===================
procedure TFProveedores.RellenaSIC();
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
  dbCliSic.FieldByName('ES_PROVEEDOR').AsString:='1';
end;

//================== RELLENAR CAMPOS DEL SIC ===================
procedure TFProveedores.CargaSIC();
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
  {$I proveedores.lrs}

End.

