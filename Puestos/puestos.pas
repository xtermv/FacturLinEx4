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

Unit puestos;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType, DBGrids,
  TAGraph, TASeries, db, DbCtrls;


Type
  { TFPuestos }

  TFPuestos = Class(Tform)
    Bevel2: TBevel;
    BitBtn8: TBitBtn;
    Datasource1: TDatasource;
    dbGrafica: TZQuery;
    dbBusca: TZQuery;
    dbEsta: TZQuery;
    dbRoles: TZQuery;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit7: TEdit;
    Label1: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Edit1: Tedit;
    dbPuestos: TZQuery;
    Panel1: Tpanel;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    Bitbtn4: Tbitbtn;
    Bitbtn5: Tbitbtn;
    Bitbtn6: Tbitbtn;
    Bitbtn1: Tbitbtn;
    Label7: Tlabel;
    Pagecontrol1: Tpagecontrol;
    Tabsheet1: Ttabsheet;
    Label2: Tlabel;
    Edit2: Tedit;
    //procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    //procedure Edit12Enter(Sender: TObject);
    //procedure Edit12Exit(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    Procedure Formcreate(Sender: Tobject);
    Procedure Edit1enter(Sender: Tobject);
    Procedure Edit1exit(Sender: Tobject);
    Procedure LimpiaForm();
    //procedure ListBox3Click(Sender: TObject);
    //procedure ListBox4Click(Sender: TObject);
    //procedure ListBox5Click(Sender: TObject);
    Procedure Relleno();
    Procedure LlenaReg();
    //Procedure VerSerie();
    Procedure Bitbtn1click(Sender: Tobject);
    Procedure Bitbtn6click(Sender: Tobject);
    Procedure Bitbtn5click(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    Procedure Bitbtn4click(Sender: Tobject);
    Procedure Bitbtn2click(Sender: Tobject);
    Procedure Bitbtn3click(Sender: Tobject);
    //procedure Graficas();
    //procedure CambiarGrafica();
    //procedure RellenaEsta(Ano: String);
    procedure CrearTablas();
    procedure BorrarTablas();
    
  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormPuestos;
  
Var
  FPuestos: TFPuestos;
  CargaGrafica: Integer;
  s: TBarSeries;

Implementation

Uses
  Global, Funciones, Busquedas;
  
//=============== Crea el formulario ================
procedure ShowFormPuestos;
begin
  with TFPuestos.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFPuestos.Formcreate(Sender: Tobject);
Begin
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.

  Label9.Caption:=Tienda;
  //------------------- Tablas ------------------
  dbPuestos.Sql.Text:='SELECT * FROM puestos'+tienda+' ORDER BY PT0';
  dbPuestos.Active := True;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Puestos', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Puestos', 3);//------------------ Boton Borrar

  ////------------------ CREAR GRAFICA ------------------
  //s := TBarSeries.Create(Chart1);
  //Chart1.AddSerie(s);
  //s.SeriesColor := clRed;
end;

//==================== CERRAR ======================
Procedure TFPuestos.Bitbtn1click(Sender: Tobject);
Begin
  Close();
End;
Procedure TFPuestos.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//=================== REGISTRO NUEVO ===================
Procedure TFPuestos.Bitbtn2click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if dbPuestos.Locate('PT0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO YA EXISTE');
      exit;
    end;
   dbPuestos.Append;
   LlenaReg();
   dbPuestos.Post;
   Relleno();
   CrearTablas();//------------ Crear las tablas de la tienda
End;
//=================== BORRAR REGISTRO ===================
Procedure TFPuestos.Bitbtn3click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if not dbPuestos.Locate('PT0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   //boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL PUESTO Y DE TODOS SUS DATOS?','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbPuestos.Delete;
  BorrarTablas();//------------ Borrar las tablas de la tienda
  Edit1.Text := ''; LimpiaForm();
End;

//=================== MODIFICAR ===================
Procedure TFPuestos.Bitbtn4click(Sender: Tobject);
Begin
   if (Edit1.Text='') or (dbPuestos.Recordcount=0) then exit;
   if not dbPuestos.Locate('PT0,', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO!');
       exit;
     end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
   dbPuestos.Edit;
   LlenaReg();
   dbPuestos.Post; Relleno();
End;

//=================== CODIGO DEL PUESTO ================
Procedure TFPuestos.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;
Procedure TFPuestos.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbPuestos.Locate('PT0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;
//=====================================================
//=================== BUSCAR PUESTOS ==================
//=====================================================
procedure TFPuestos.BitBtn8Click(Sender: TObject);
begin
  if Edit2.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit2.SetFocus;
     Exit;
  end;
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT PT0,PT1 FROM puestos'+tienda+' WHERE PT1 LIKE "%'+Edit2.Text+'%"',
  ['Código','Nombre'],'PT0');
  if Edit1.Text='-1' then Edit1.Text:='' else Edit1Exit(Edit1);
end;

procedure TFPuestos.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn8Click(BitBtn8);
end;

//=============== CODIGO DE LA SERIE ================
//procedure TFPuestos.Edit12Enter(Sender: TObject);
//begin
  //Label14.Caption:='';
  //Edit15.Text:='0'; Edit16.Text:='0'; Edit17.Text:='0'; Edit18.Text:='0'; Edit19.Text:='0';
//end;
//procedure TFPuestos.Edit12Exit(Sender: TObject);
//begin
  //if Edit12.Text<>'' then VerSerie();
//end;

procedure TFPuestos.Edit1Change(Sender: TObject);
var
  entrada: string;
  c: char;
begin
  if Edit1.Text='-' then Edit1.Text:='';
  if Edit1.Text <> '' then
    begin
      entrada:= Edit1.Text;
      c:=entrada[1];
      //if not (c in Mayusculas) then
      if not IsMayuscula(c) then
        begin
          ShowMessage('EL VALOR INTRODUCIDO TIENE QUE SER UNA LETRA');
          Edit1.Text:=''; Edit1.SetFocus; Exit;
        end
    end
end;

//===================== LIMPIAR DATOS =======================
Procedure TFPuestos.LimpiaForm();
Begin
  Edit2.Text:=''; {Edit3.Text:=''; Edit4.Text:=''; Edit5.Text:='';}
  {Edit6.Text:='';} Label7.Caption:=''; {Label14.Caption:='';}
  Edit7.Text:=''; {Edit8.Text:=''; Edit9.Text:=''; Edit10.Text:='';}
  {Edit11.Text:=''; Edit12.Text:='';} Edit13.Text:='';
  Edit14.Text:=''; {Memo1.Lines.Text:=''; Edit15.Text:='';}
  //Edit16.Text:=''; Edit17.Text:=''; Edit18.Text:=''; Edit19.Text:='';
  Edit20.Text:=''; Edit21.Text:='';
End;

//===================== PINTAR DATOS =======================
Procedure TFPuestos.Relleno();
Begin
  if dbPuestos.RecordCount=0 then exit;
  Label7.Caption:=dbPuestos.Fields[1].AsString;
  Edit1.Text:=dbPuestos.Fields[0].AsString;//-------------- Cgo. Tienda
  Edit2.Text:=dbPuestos.Fields[1].AsString;//-------------- Nombre
  Edit7.Text:=dbPuestos.Fields[2].AsString;//-------------- Telef.
  Edit13.Text:=dbPuestos.Fields[3].AsString;//------------ Direccion IP
  Edit14.Text:=dbPuestos.Fields[4].AsString;//------------ Puerto de conexion
  Edit20.Text:=dbPuestos.Fields[5].AsString;//------------ Usuario para comunicaciones
  Edit21.Text:=dbPuestos.Fields[6].AsString;//------------ Clave para comunicaciones
  //-------------- Estadisticas --------------------
  //RellenaEsta(FormatDateTime('YYYY',Date));//--------- Rellenar los meses que esten a 0
  //dbEsta.Active:=False;
  //dbEsta.SQL.Text:='SELECT *, TT6-TT7 As BENEF FROM estatien'+Tienda+' WHERE TT0="'+Edit1.Text+'"'+
                   //' AND TT1='+FormatDateTime('YYYY',Date)+
                   //' ORDER BY TT1 ASC, TT2 ASC';
  //dbEsta.Active:=True;
  ////------------------------------------------------
  //CargaGrafica:=1; Graficas(); CargaGrafica:=0;//---------------- Pintar Graficas
End;
//===================== RELLENAR DATOS =======================
Procedure TFPuestos.LlenaReg();
Begin
  dbPuestos.Fields[0].AsString:=Edit1.Text;//-------------- Codigo
  dbPuestos.Fields[1].AsString:=Edit2.Text;//-------------- Nombre
  dbPuestos.Fields[2].AsString:=Edit7.Text;//-------------- Telef.
  dbPuestos.Fields[3].AsString:=Edit13.Text;//------------ Direccion IP
  dbPuestos.Fields[4].AsString:=Edit14.Text;//------------ Puerto
  dbPuestos.Fields[5].AsString:=Edit20.Text;//------------ Usuario para comunicaciones
  dbPuestos.Fields[6].AsString:=Edit21.Text;//------------ Clave para comunicaciones
End;

//==================== REG. ANTERIOR ===============
Procedure TFPuestos.Bitbtn5click(Sender: Tobject);
Begin
  dbPuestos.Prior;
  LimpiaForm(); Relleno();
End;

//==================== REG. POSTERIOR ===============
Procedure TFPuestos.Bitbtn6click(Sender: Tobject);
Begin
   dbPuestos.Next;
   LimpiaForm(); Relleno();
End;
////=================== SERIES DE FACTURACION =====================
//procedure TFPuestos.BitBtn7Click(Sender: TObject);
//begin
  //ShowFormSeries();
//end;

////==================== VER SERIE FACTURACION ===============
//Procedure TFPuestos.VerSerie();
//Begin
  //dbSeries.Active:=False;
  //dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+Edit12.Text+'"';
  //dbSeries.Active:=True;
  //if dbSeries.RecordCount=0 then
   //begin
     //Label14.Caption:='';
     //Edit15.Text:='0'; Edit16.Text:='0'; Edit17.Text:='0'; Edit18.Text:='0';
     //Edit19.Text:='0';
   //end
  //else
   //begin
     //Label14.Caption:=dbSeries.Fields[1].AsString;
     //Edit15.Text:=dbSeries.Fields[2].AsString;//---- N. Facturas
     //Edit16.Text:=dbSeries.Fields[3].AsString;//---- N. Albaranes
     //Edit17.Text:=dbSeries.Fields[4].AsString;//---- N. Ticket
     //Edit18.Text:=dbSeries.Fields[6].AsString;//---- N. Presupuestos
     //Edit19.Text:=dbSeries.Fields[7].AsString;//---- N. Pedidos
   //end;
  //dbSeries.Active:=False;
//End;

//============================================================
//===================== GRAFICAS =============================
//============================================================
//procedure TFPuestos.Graficas();
//Var
  //Conta: Integer;
//begin
  ////-------------- Mostrar los distintos años ------------------
  //dbGrafica.Active:=False;
  //dbGrafica.SQL.Text:='SELECT DISTINCT TT1 FROM estatien'+Tienda+' WHERE TT0="'+Edit1.Text+'" ORDER BY TT1 DESC';
  //dbGrafica.Active:=True;
  //ListBox3.Items.Clear; ListBox5.Items.Clear;
  //dbGrafica.First;
  //while not dbGrafica.EOF do
    //begin
      //ListBox3.Items.Add(dbGrafica.FieldByName('TT1').AsString);
      //ListBox5.Items.Add(dbGrafica.FieldByName('TT1').AsString);
      //dbGrafica.Next;
    //end;
  //ListBox4.ItemIndex:=0;
  ////-------------- Mostrar las unidades compradas ------------------
  //if ListBox3.Items.Count<>0 then
    //begin
     //ListBox3.ItemIndex:=0; s.Clear;
     //dbGrafica.Active:=False;
     //dbGrafica.SQL.Text:='SELECT *, TT6-TT7 As BENEF FROM estatien'+Tienda+' WHERE TT0="'+Edit1.Text+'"'+
                         //' AND TT1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                         //' ORDER BY TT1 ASC, TT2 ASC';
     //dbGrafica.Active:=True;
     //dbGrafica.First; Chart1.Title.Text.Text:='Unidades Compradas';
     //for conta:=1 to dbGrafica.RecordCount do
       //begin
        //s.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        //dbGrafica.Next;
       //end;
    //end;
//end;
////------------------ Cambiar años grafica -------------------
//procedure TFPuestos.ListBox3Click(Sender: TObject);
//begin
  ////CambiarGrafica();
//end;
////------------------ Cambiar datos grafica -------------------
//procedure TFPuestos.ListBox4Click(Sender: TObject);
//begin
  ////CambiarGrafica();
//end;

//--------------- Cambiar Grafica -----------------
//procedure TFPuestos.CambiarGrafica();
//var
  //Conta: Integer;
//begin
  //if CargaGrafica=1 then exit;//------- Si esta cargando datos
  //if ListBox3.Items.Count=0 then exit;//----- Si no hay años
  //if ListBox3.ItemIndex=-1 then ListBox3.ItemIndex:=0;
  //dbGrafica.Active:=False;
  //dbGrafica.SQL.Text:='SELECT *, TT6-TT7 As BENEF FROM estatien'+Tienda+' WHERE TT0="'+Edit1.Text+'"'+
                      //' AND TT1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                      //' ORDER BY TT1 ASC, TT2 ASC';
  //dbGrafica.Active:=True;
  //s.Clear;
  //if ListBox4.ItemIndex=-1 then ListBox4.ItemIndex:=0;
  //dbGrafica.First; Chart1.Title.Text.Text:=ListBox4.Items.Strings[ListBox4.ItemIndex];
  //for conta:=1 to dbGrafica.RecordCount do
    //begin
     //s.AddXY(conta,dbGrafica.Fields[ListBox4.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox4.ItemIndex+3].AsFloat), clred);
     //dbGrafica.Next;
    //end;
//end;
//----------------- Cambiar estadisticas ---------------
//procedure TFPuestos.ListBox5Click(Sender: TObject);
//begin
  //if CargaGrafica=1 then exit;//------- Si esta cargando datos
  //if ListBox5.Items.Count=0 then exit;//----- Si no hay años
  //if ListBox5.ItemIndex=-1 then ListBox5.ItemIndex:=0;
  //RellenaEsta(ListBox5.Items.Strings[ListBox5.ItemIndex]);//--------- Rellenar los meses que esten a 0
  //dbEsta.Active:=False;
  //dbEsta.SQL.Text:='SELECT *, TT6-TT7 As BENEF FROM estatien'+Tienda+' WHERE TT0="'+Edit1.Text+'"'+
                   //' AND TT1='+ListBox5.Items.Strings[ListBox5.ItemIndex]+
                   //' ORDER BY TT1 ASC, TT2 ASC';
  //dbEsta.Active:=True;
//end;

////==========================================================
////============= RELLENAR MESES QUE ESTEN A 0 ===============
////==========================================================
//procedure TFPuestos.RellenaEsta(Ano: String);
//var
  //Conta: Integer;
//begin
  //dbEsta.Active:=False;
  //dbEsta.SQL.Text:='SELECT * FROM estatien'+Tienda+' WHERE TT0="'+Edit1.Text+'"'+
                   //' AND TT1='+Ano+
                   //' ORDER BY TT1 ASC, TT2 ASC';
  //dbEsta.Active:=True;
  //dbEsta.First;
  //for Conta:=1 to 12 do
    //begin
      //if not dbEsta.Locate('TT2',Conta,[]) then
        //begin
           //dbEsta.Append;
           //dbEsta.FieldByName('TT0').AsString:=Edit1.Text;
           //dbEsta.FieldByName('TT1').AsString:=Ano;
           //dbEsta.FieldByName('TT2').AsString:=IntToStr(Conta);
           //dbEsta.Post;
        //end;
    //end;
//end;

//==========================================================
//============= CREAR LAS TABLAS DEL PUESTO  ===============
//==========================================================
procedure TFPuestos.CrearTablas();
var
  Puestoacrear, TxtQuery: String;
  //Cuenta: Integer;
begin
  Puestoacrear:=Edit1.Text;//DataModule1.LFill(Edit1.Text,4,'0');
  //Memo2.Lines.Clear;
  //Memo2.Lines.LoadFromFile('/usr/share/facturlinex2/facturlinex2.sql');
  //Memo2.Lines.Text:=StringReplace(Memo2.Lines.Text,'0000',Puestoacrear,[rfReplaceAll]);
  //for cuenta:=0 to Memo2.Lines.Count-1 do
     //if (Memo2.Lines.Strings[cuenta]<>'') and (Copy(Memo2.Lines.Strings[cuenta],1,1)<>'#') then
        //begin dbBusca.SQL.Text:=Memo2.Lines.Strings[cuenta]; dbBusca.ExecSQL; end;
   //#---------------------------------- Ventas0000A ----------------------------
  TxtQuery:='CREATE TABLE IF NOT EXISTS ventas'+tienda+Puestoacrear
    +'( V0 INT(5) NOT NULL DEFAULT 0, V1 INT(5) NOT NULL DEFAULT 0,'
    +' V2 INT(5) AUTO_INCREMENT NOT NULL, V3 CHAR(13) NOT NULL, V4 CHAR(50),'
    +' V5 DOUBLE(10,3) NOT NULL DEFAULT 0.000, V6 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'
    +' V7 DOUBLE(10,3) NOT NULL DEFAULT 0.000, V8 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'
    +' V9 DOUBLE(10,3) NOT NULL DEFAULT 0.000, V10 INTEGER(3) NOT NULL DEFAULT 0,'
    +' V11 DOUBLE(10,2) NOT NULL DEFAULT 0.00, V12 INTEGER(11) NOT NULL DEFAULT 0,'
    +' V13 CHAR(1) NOT NULL DEFAULT "N", PRIMARY KEY kv (V0,V1,V2),'
    +' UNIQUE (V0,V1,V2), INDEX kv (V0,V1,V2))';
  dbBusca.Active:=False; dbBusca.SQL.Text:=TxtQuery;  dbBusca.ExecSQL;


end;

//==========================================================
//============= BORRAR LAS TABLAS DE LA TIENDA =============
//==========================================================
procedure TFPuestos.BorrarTablas();
var
  Tiendaaborrar,TxtQ: String;
begin
  Tiendaaborrar:=Edit1.Text;//DataModule1.LFill(Edit1.Text,4,'0');
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
  TxtQ:='DROP TABLE IF EXISTS ventas'+Tiendaaborrar+Edit1.Text; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS ventas'+Tiendaaborrar+'B'; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS ventas'+Tiendaaborrar+'C'; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS hisopcc'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS hisopdd'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS pedicc'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS pedidd'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS arqueos'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  //TxtQ:='DROP TABLE IF EXISTS cajas'+Tiendaaborrar; dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
end;


Initialization
  {$I puestos.lrs}

End.

