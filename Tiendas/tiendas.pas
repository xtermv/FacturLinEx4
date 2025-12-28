{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2009, Nicolas Lopez de Lerma Aymerich
  
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
Unit Tiendas;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType, DBGrids,
  TAGraph, TASeries, db, DbCtrls;


Type

  { TFTiendas }

  TFTiendas = Class(Tform)
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    Button2: TButton;
    Chart1: TChart;
    Chart1AreaSeries1: TAreaSeries;
    Chart1BarSeries1: TBarSeries;
    Chart1PieSeries1: TPieSeries;
    Chart1Serie1: TLineSeries;
    Combo2: TComboBox;
    Datasource1: TDatasource;
    dbBorrado: TZQuery;
    dbRoles: TZQuery;
    dbConectR: TZConnection;
    dbGrafica: TZQuery;
    dbBusca: TZQuery;
    dbSeries: TZQuery;
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
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
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
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label57: TLabel;
    Label65: TLabel;
    Label68: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbBeneficio: TLabel;
    lbIC: TLabel;
    lbIVC: TLabel;
    lbIVP: TLabel;
    lbUC: TLabel;
    lbUV: TLabel;
    ListBox3: TListBox;
    ListBox4: TListBox;
    ListBox5: TListBox;
    ListBox6: TListBox;
    Memo1: TMemo;
    Edit1: Tedit;
    dbTiendas: TZQuery;
    Memo2: TMemo;
    Panel1: Tpanel;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    Bitbtn4: Tbitbtn;
    Bitbtn5: Tbitbtn;
    Bitbtn6: Tbitbtn;
    Bitbtn1: Tbitbtn;
    Label7: Tlabel;
    Pagecontrol1: Tpagecontrol;
    Panel3: TPanel;
    Tabsheet1: Ttabsheet;
    Tabsheet2: Ttabsheet;
    Tabsheet3: Ttabsheet;
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
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit12Enter(Sender: TObject);
    procedure Edit12Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    Procedure Formcreate(Sender: Tobject);
    Procedure Edit1enter(Sender: Tobject);
    Procedure Edit1exit(Sender: Tobject);
    Procedure LimpiaForm();
    procedure ListBox3Click(Sender: TObject);
    procedure ListBox4Click(Sender: TObject);
    procedure ListBox5Click(Sender: TObject);
    procedure ListBox6Click(Sender: TObject);
    Procedure Relleno();
    Procedure LlenaReg();
    Procedure VerSerie();
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
    procedure CrearTablas();
    procedure BorrarTablas();
    
  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormTiendas;
  
Var
  FTiendas: TFTiendas;
  CargaGrafica: Integer;
  s: TBarSeries;

Implementation

Uses
  Global, Series, Funciones, Busquedas;
  
//=============== Crea el formulario ================
procedure ShowFormTiendas;
begin
  with TFTiendas.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure Tftiendas.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);     // Utilizamos datamodule1.dbConexión para toda la aplicación.

  //------------------- Tablas ------------------
  dbTiendas.Sql.Text:='SELECT * FROM tiendas ORDER BY T0';
  dbTiendas.Active := True;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Tiendas', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Tiendas', 3);//------------------ Boton Borrar
  if CheckRoles(dbRoles, CgRol, 'Tiendas', 4)=False then Tabsheet2.Destroy;//--- Estadisticas
  if CheckRoles(dbRoles, CgRol, 'Tiendas', 4)=False then Tabsheet3.Destroy;//--- Graficas
end;

//==================== CERRAR ======================
Procedure Tftiendas.Bitbtn1click(Sender: Tobject);
Begin
  dbTiendas.Active:=False;
  Close();
End;
Procedure Tftiendas.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//=================== REGISTRO NUEVO ===================
Procedure Tftiendas.Bitbtn2click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if dbTiendas.Locate('T0', Edit1.Text, []) then
    begin
      DataModule1.Mensaje('ERROR','Ese registro ya existe', 3000 , clRed);
//      Showmessage('ESE REGISTRO YA EXISTE');
      exit;
    end;
   dbTiendas.Append;
   LlenaReg();
   dbTiendas.Post; Relleno();
   CrearTablas();//------------ Crear las tablas de la tienda
End;
//=================== BORRAR REGISTRO ===================
Procedure Tftiendas.Bitbtn3click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if dbTiendas.RecordCount<2 then begin
                                    DataModule1.Mensaje('ERROR','No se pueden eliminar todas las tiendas', 5000 , clRed);
                                    exit;
                                   end;

  if not dbTiendas.Locate('T0', Edit1.Text, []) then
    begin
      DataModule1.Mensaje('ERROR','No existe ese registro, no se puede borrar !', 3000 , clRed);
        //Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   //boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DE LA TIENDA Y DE TODOS SUS DATOS?','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbTiendas.Delete;
  BorrarTablas();//------------ Borrar las tablas de la tienda
  Edit1.Text := ''; LimpiaForm();
End;

//=================== MODIFICAR ===================
Procedure Tftiendas.Bitbtn4click(Sender: Tobject);
Begin
   if (Edit1.Text='') or (dbTiendas.Recordcount=0) then exit;
   if not dbTiendas.Locate('T0,', Edit1.Text, []) then
     begin
       DataModule1.Mensaje('ERROR','No existe ese registro, no se puede modificar !', 3000 , clRed);
//       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO!');
       exit;
     end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
   dbTiendas.Edit;
   LlenaReg();
   dbTiendas.Post; Relleno();
End;

//=================== CODIGO DE LA TIENDA ================
Procedure Tftiendas.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;
Procedure Tftiendas.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbTiendas.Locate('T0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;
//=====================================================
//=================== BUSCAR TIENDAS ==================
//=====================================================
procedure TFTiendas.BitBtn8Click(Sender: TObject);
begin
  if Edit2.Text='' then begin
     DataModule1.Mensaje('INFORMACION','Debe teclear el texto a buscar', 3000 , clSkyBlue);
//     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit2.SetFocus;
     Exit;
  end;
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT T0,T1 FROM tiendas WHERE T1 LIKE "%'+Edit2.Text+'%"',
                                         ['Código','Nombre'],'T0');
  if Edit1.Text='-1' then Edit1.Text:='' else Edit1Exit(Edit1);
end;

procedure TFTiendas.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then BitBtn8Click(BitBtn8);
end;

//=============== CODIGO DE LA SERIE ================
procedure TFTiendas.Edit12Enter(Sender: TObject);
begin
  Label14.Caption:='';
  Edit15.Text:='0'; Edit16.Text:='0'; Edit17.Text:='0'; Edit18.Text:='0'; Edit19.Text:='0';
end;
procedure TFTiendas.Edit12Exit(Sender: TObject);
begin
  if Edit12.Text<>'' then VerSerie();
end;

//===================== LIMPIAR DATOS =======================
Procedure Tftiendas.LimpiaForm();
Begin
  Edit2.Text:=''; Edit3.Text:=''; Edit4.Text:=''; Edit5.Text:='';
  Edit6.Text:=''; Label7.Caption:=''; Label14.Caption:='';
  Edit7.Text:=''; Edit8.Text:=''; Edit9.Text:=''; Edit10.Text:='';
  Edit11.Text:=''; Edit12.Text:=''; Edit13.Text:=''; Edit22.Text:='';
  Edit14.Text:=''; Memo1.Lines.Text:=''; Edit15.Text:='';
  Edit16.Text:=''; Edit17.Text:=''; Edit18.Text:=''; Edit19.Text:='';
  Edit20.Text:=''; Edit21.Text:=''; Edit23.Text:='';Combo2.Text:='';
  Edit22.Enabled:=True; Edit13.Enabled:=True; Edit14.Enabled:=True;
  Edit20.Enabled:=True; Edit21.Enabled:=True; Combo2.Enabled:=True;
  Button2.Enabled:=True;
End;

//===================== PINTAR DATOS =======================
Procedure Tftiendas.Relleno();
Begin
  if dbTiendas.RecordCount=0 then exit;
  Label7.Caption:=dbTiendas.Fields[1].AsString;
  Edit1.Text:=dbTiendas.Fields[0].AsString;//-------------- Cgo. Tienda
  Edit2.Text:=dbTiendas.Fields[1].AsString;//-------------- Nombre
  Edit3.Text:=dbTiendas.Fields[2].AsString;//-------------- Direccion
  Edit4.Text:=dbTiendas.Fields[3].AsString;//-------------- Localidad
  Edit5.Text:=dbTiendas.Fields[4].AsString;//-------------- C.Postal
  Edit6.Text:=dbTiendas.Fields[5].AsString;//-------------- Provincia
  Edit7.Text:=dbTiendas.Fields[6].AsString;//-------------- Telef.
  Edit8.Text:=dbTiendas.Fields[7].AsString;//-------------- Fax
  Edit9.Text:=dbTiendas.Fields[8].AsString;//-------------- CIF
  Edit10.Text:=dbTiendas.Fields[9].AsString;//------------- F.Ult.Venta
  Edit11.Text:=dbTiendas.Fields[10].AsString;//------------ F.Ult.Compra
  Edit12.Text:=dbTiendas.Fields[11].AsString;//------------ Serie Facturacion
  VerSerie();//-------------------------------------------- Nombre Serie Fact.
  Edit22.Text:=dbTiendas.Fields[12].AsString;//------------ Nombre BBDD
  Edit13.Text:=dbTiendas.Fields[13].AsString;//------------ Direccion IP
  Edit14.Text:=dbTiendas.Fields[14].AsString;//------------ Puerto de conexion
  Edit20.Text:=dbTiendas.Fields[15].AsString;//------------ Usuario para comunicaciones
  Edit21.Text:=dbTiendas.Fields[16].AsString;//------------ Clave para comunicaciones
  Combo2.Text:=dbTiendas.Fields[17].AsString;//------------ Protocolo para comunicaciones
  Memo1.Lines.Text:=dbTiendas.Fields[18].AsString;//------- Observaciones
  //-------------- Estadisticas --------------------
  RellenaEsta(FormatDateTime('YYYY',Date));//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, TT6-TT7 As BENEF FROM estatien'+Tienda+' WHERE TT0="'+Edit1.Text+'"'+
                   ' AND TT1='+FormatDateTime('YYYY',Date)+
                   ' ORDER BY TT1 ASC, TT2 ASC';
  dbEsta.Active:=True;
  //------------------------------------------------
  CargaGrafica:=1; Graficas(); CargaGrafica:=0;//-------------- Pintar Graficas
  //------------ Desactivar BBDD Comunicaciones si es tienda activa
  if Edit1.Text=NTienda then
   begin
     Edit22.Enabled:=False; Edit13.Enabled:=False; Edit14.Enabled:=False;
     Edit20.Enabled:=False; Edit21.Enabled:=False; Combo2.Enabled:=False;
     Button2.Enabled:=False;
   end;
End;
//===================== RELLENAR DATOS =======================
Procedure Tftiendas.LlenaReg();
Begin
  dbTiendas.Fields[0].AsString:=Edit1.Text;//-------------- Codigo
  dbTiendas.Fields[1].AsString:=Edit2.Text;//-------------- Nombre
  dbTiendas.Fields[2].AsString:=Edit3.Text;//-------------- Direccion
  dbTiendas.Fields[3].AsString:=Edit4.Text;//-------------- Localidad
  dbTiendas.Fields[4].AsString:=Edit5.Text;//-------------- C. Postal
  dbTiendas.Fields[5].AsString:=Edit6.Text;//-------------- Provincia
  dbTiendas.Fields[6].AsString:=Edit7.Text;//-------------- Telef.
  dbTiendas.Fields[7].AsString:=Edit8.Text;//-------------- Fax
  dbTiendas.Fields[8].AsString:=Edit9.Text;//-------------- CIF
  //------ Fecha Ultima Venta
  if Edit10.Text='' then
    dbTiendas.Fields[9].Value:=Null
  else
    dbTiendas.Fields[9].AsString:=Edit10.Text;//------------- F. Ult. Venta
  //------ Fecha Ultima Compra
  if Edit11.Text='' then
    dbTiendas.Fields[10].Value:=Null
  else
    dbTiendas.Fields[10].AsString:=Edit11.Text;//------------- F. Ult. Compra
  dbTiendas.Fields[11].AsString:=Edit12.Text;//------------ Serie Fac.
  dbTiendas.Fields[12].AsString:=Edit22.Text;//------------ Nombre BBDD
  dbTiendas.Fields[13].AsString:=Edit13.Text;//------------ Direccion IP
  dbTiendas.Fields[14].AsString:=Edit14.Text;//------------ Puerto
  dbTiendas.Fields[15].AsString:=Edit20.Text;//------------ Usuario para comunicaciones
  dbTiendas.Fields[16].AsString:=Edit21.Text;//------------ Clave para comunicaciones
  dbTiendas.Fields[17].AsString:=Combo2.Text;//------------ Protocolo para comunicaciones
  dbTiendas.Fields[18].AsString:=Memo1.Lines.Text;//------- Observaciones
End;

//==================== REG. ANTERIOR ===============
Procedure Tftiendas.Bitbtn5click(Sender: Tobject);
Begin
  dbTiendas.Prior;
  LimpiaForm(); Relleno();
End;

//==================== REG. POSTERIOR ===============
Procedure Tftiendas.Bitbtn6click(Sender: Tobject);
Begin
   dbTiendas.Next;
   LimpiaForm(); Relleno();
End;
//=================== SERIES DE FACTURACION =====================
procedure TFTiendas.BitBtn7Click(Sender: TObject);
begin
  ShowFormSeries();
end;

//==================== VER SERIE FACTURACION ===============
Procedure Tftiendas.VerSerie();
Begin
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+Edit12.Text+'"';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then
   begin
     Label14.Caption:='';
     Edit15.Text:='0'; Edit16.Text:='0'; Edit17.Text:='0'; Edit18.Text:='0';
     Edit19.Text:='0'; Edit23.Text:='0';
   end
  else
   begin
     Label14.Caption:=dbSeries.Fields[1].AsString;
     Edit15.Text:=dbSeries.Fields[2].AsString;//---- N. Facturas
     Edit16.Text:=dbSeries.Fields[3].AsString;//---- N. Albaranes
     Edit17.Text:=dbSeries.Fields[4].AsString;//---- N. Ticket
     Edit18.Text:=dbSeries.Fields[6].AsString;//---- N. Presupuestos
     Edit19.Text:=dbSeries.Fields[7].AsString;//---- N. Pedidos
     Edit23.Text:=dbSeries.Fields[8].AsString;//---- N. Proforma
   end;
  dbSeries.Active:=False;
End;

//============================================================
//===================== GRAFICAS =============================
//============================================================
procedure Tftiendas.Graficas();
Var
  Conta: Integer;
begin
  //-------------- Mostrar los distintos años ------------------
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT DISTINCT TT1 FROM estatien'+Tienda+' WHERE TT0="'+Edit1.Text+'" ORDER BY TT1 DESC';
  dbGrafica.Active:=True;
  ListBox3.Items.Clear; ListBox5.Items.Clear;
  dbGrafica.First;
  while not dbGrafica.EOF do
    begin
      ListBox3.Items.Add(dbGrafica.FieldByName('TT1').AsString);
      ListBox5.Items.Add(dbGrafica.FieldByName('TT1').AsString);
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
     dbGrafica.SQL.Text:='SELECT *, TT6-TT7 As BENEF FROM estatien'+Tienda+' WHERE TT0="'+Edit1.Text+'"'+
                         ' AND TT1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                         ' ORDER BY TT1 ASC, TT2 ASC';
     dbGrafica.Active:=True; ListBox6.ItemIndex:=0;
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
procedure TFTiendas.ListBox3Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//------------------ Cambiar datos grafica -------------------
procedure TFTiendas.ListBox4Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//----------------- Cambiar tipo de grafica ----------------
procedure TFTiendas.ListBox6Click(Sender: TObject);
begin
 Chart1Serie1.Active:=False; Chart1AreaSeries1.Active:=False;
 Chart1BarSeries1.Active:=False; Chart1PieSeries1.Active:=False;
 case ListBox6.ItemIndex of
   0: Chart1Serie1.Active:=True;
   1: Chart1BarSeries1.Active:=True;
   2: Chart1AreaSeries1.Active:=True;
   3: Chart1PieSeries1.Active:=True;
 end;
end;

//--------------- Cambiar Grafica -----------------
procedure TFTiendas.CambiarGrafica();
var
  Conta: Integer;
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox3.Items.Count=0 then exit;//----- Si no hay años
  if ListBox3.ItemIndex=-1 then ListBox3.ItemIndex:=0;
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT *, TT6-TT7 As BENEF FROM estatien'+Tienda+' WHERE TT0="'+Edit1.Text+'"'+
                      ' AND TT1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                      ' ORDER BY TT1 ASC, TT2 ASC';
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
procedure TFTiendas.ListBox5Click(Sender: TObject);
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox5.Items.Count=0 then exit;//----- Si no hay años
  if ListBox5.ItemIndex=-1 then ListBox5.ItemIndex:=0;
  RellenaEsta(ListBox5.Items.Strings[ListBox5.ItemIndex]);//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, TT6-TT7 As BENEF FROM estatien'+Tienda+' WHERE TT0="'+Edit1.Text+'"'+
                   ' AND TT1='+ListBox5.Items.Strings[ListBox5.ItemIndex]+
                   ' ORDER BY TT1 ASC, TT2 ASC';
  dbEsta.Active:=True;
end;


//==========================================================
//============= RELLENAR MESES QUE ESTEN A 0 ===============
//==========================================================
procedure TFTiendas.RellenaEsta(Ano: String);
var
  Conta: Integer;
  UC,IC,UV,IVP,IVC,Beneficio : Double;
begin
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT * FROM estatien'+Tienda+' WHERE TT0="'+Edit1.Text+'"'+
                   ' AND TT1='+Ano+
                   ' ORDER BY TT1 ASC, TT2 ASC';
  dbEsta.Active:=True;
  dbEsta.First;

  //*********** IMPLEMENTACIÓN DE MUESTREO DE TOTALES
    UC:=0; IC:=0; UV:=0; IVP:=0; IVC:=0; Beneficio:=0;
    While not dbEsta.EOF do
      begin
        UC := UC + dbEsta.FieldByName('TT3').Value;
        IC := IC + dbEsta.FieldByName('TT4').Value;
        UV := UV + dbEsta.FieldByName('TT5').Value;
        IVP := IVP + dbEsta.FieldByName('TT6').Value;
        IVC := IVC + dbEsta.FieldByName('TT7').Value;
        Beneficio := Beneficio + ( dbEsta.FieldByName('TT6').Value - dbEsta.FieldByName('TT7').Value );
        dbEsta.Next;
      end;

    lbUC.Caption := FormatFloat('#,###,##0.00',UC);
    lbIC.Caption := FormatFloat('#,###,##0.00',IC);
    lbUV.Caption := FormatFloat('#,###,##0.00',UV);
    lbIVP.Caption := FormatFloat('#,###,##0.00',IVP);
    lbIVC.Caption := FormatFloat('#,###,##0.00',IVC);
    lbBeneficio.Caption := FormatFloat('#,###,##0.00',Beneficio);

    dbEsta.First;
  //*********** FIN IMPLEMENTACIÓN DE MUESTREO DE TOTALES

  for Conta:=1 to 12 do
    begin
      if not dbEsta.Locate('TT2',Conta,[]) then
        begin
           dbEsta.Append;
           dbEsta.FieldByName('TT0').AsString:=Edit1.Text;
           dbEsta.FieldByName('TT1').AsString:=Ano;
           dbEsta.FieldByName('TT2').AsString:=IntToStr(Conta);
           dbEsta.Post;
        end;
    end;
end;

//==========================================================
//=========== COMPROBAR CONEXION TIENDA REMOTA =============
//==========================================================
procedure TFTiendas.Button2Click(Sender: TObject);
begin
  Button2.cursor := crSQLWait;
  dbConectR.Connected:=False;
  dbConectR.HostName:=Edit13.Text;
  dbConectR.User:=Edit20.Text;
  dbConectR.Password:=Edit21.Text;
  dbConectR.Database:=Edit22.Text;
  dbConectR.Port:=StrToInt(Edit14.Text);
  dbConectR.Protocol:=Combo2.Text;
  try
    dbConectR.Connected:=True;
    DataModule1.Mensaje('CONFIRMACION','La conexión fue realizada con éxito', 3000 , clSkyBlue);
//    ShowMessage('Conexion realizada con exito');
    Button2.Cursor := crDefault;
    dbConectR.Connected:=False;
  except
    DataModule1.Mensaje('ERROR','La conexión NO tuvo éxito, revise los datos !', 3000 , clRed);
//    ShowMessage('La conexion NO tuvo exito, revise los datos!');
    Button2.Cursor := crDefault;
  end;
end;

//==========================================================
//============= CREAR LAS TABLAS DE LA TIENDA ==============
//==========================================================
procedure TFTiendas.CrearTablas();
var
  Tiendaacrear: String;
  Cuenta: Integer;
begin
  Tiendaacrear:=DataModule1.LFill(Edit1.Text,4,'0');
  Memo2.Lines.Clear;
  Memo2.Lines.LoadFromFile(RutaSql+'facturlinex2.sql');
  Memo2.Lines.Text:=StringReplace(Memo2.Lines.Text,'XXXX',Tiendaacrear,[rfReplaceAll]);
  for cuenta:=0 to Memo2.Lines.Count-1 do
     if (Memo2.Lines.Strings[cuenta]<>'') and (Copy(Memo2.Lines.Strings[cuenta],1,1)<>'#') then
        begin dbBusca.SQL.Text:=Memo2.Lines.Strings[cuenta]; dbBusca.ExecSQL; end;

end;

//==========================================================
//============= BORRAR LAS TABLAS DE LA TIENDA =============
//==========================================================
procedure TFTiendas.BorrarTablas();
var
  Tiendaaborrar,TxtQ, TxtQ2: String;
begin
  Tiendaaborrar:=DataModule1.LFill(Edit1.Text,4,'0');
  //Buscamos todas las tablas (nombres de las tablas) done aparezca Tiendaaborrar
  TxtQ:='show tables LIKE "%'+Tiendaaborrar+'%"';dbBusca.SQL.Text:=TxtQ; dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then
    begin
     DataModule1.Mensaje('ERROR','No existen tablas de esa tienda', 3000 , clRed);
//     ShowMessage('NO HAY NINGUNA TABLA DE ESA TIENDA');
      dbBusca.Active:=False; Exit;
    end;
  dbBusca.First;
  // Mientras haya tablas de esa tienda, eliminalas una a una
  While not dbBusca.EOF do
    begin
      TxtQ2:='DROP TABLE IF EXISTS '+dbBusca.Fields[0].AsString;
      dbBorrado.SQL.Text:=TxtQ2; dbBorrado.ExecSQL;
      //WriteLn('DROP TABLE IF EXIST '+dbBusca.Fields[0].AsString);
      dbBusca.Next;
    end;
  //TxtQ:='DROP TABLE IF EXISTS artitien'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS albac'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS albad'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS departamentos'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS estaarti'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS estadepa'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS estafami'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS estatien'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS estausu'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS factuc'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS factud'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS facturect'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS familias'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS ultimopedi'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS ultimopedi'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS usuarios'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS ventas'+Tiendaaborrar+'A'; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS ventas'+Tiendaaborrar+'B'; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS ventas'+Tiendaaborrar+'C'; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS hisopcc'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS hisopdd'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS pedicc'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS pedidd'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS arqueos'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS cajas'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS puestos'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
end;


Initialization
  {$I tiendas.lrs}

End.

