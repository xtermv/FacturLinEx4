{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2011

  Nicolas Lopez de Lerma Aymerich <nicolas@esdebian.org>

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

Unit Departamentos;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType, DBGrids,
  TAGraph, TASeries, db, DbCtrls;


Type

  { TFDepartamentos }

  TFDepartamentos = Class(Tform)
    BitBtn8: TBitBtn;
    Chart1: TChart;
    Chart1AreaSeries1: TAreaSeries;
    Chart1BarSeries1: TBarSeries;
    Chart1PieSeries1: TPieSeries;
    Chart1Serie1: TLineSeries;
    Datasource1: TDatasource;
    dbGrafica: TZQuery;
    dbBusca: TZQuery;
    DBGrid1: TDBGrid;
    dbEsta: TZQuery;
    dbRoles: TZQuery;
    Edit10: TEdit;
    Edit11: TEdit;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label17: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label57: TLabel;
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
    ListBox3: TListBox;
    ListBox4: TListBox;
    ListBox5: TListBox;
    ListBox6: TListBox;
    Memo1: TMemo;
    Edit1: Tedit;
    dbDepartamentos: TZQuery;
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
    Edit2: Tedit;
    procedure BitBtn8Click(Sender: TObject);
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

    
  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormDepartamentos;
  
Var
  FDepartamentos: TFDepartamentos;
  CargaGrafica: Integer;
  s: TBarSeries;

Implementation

Uses
  Global, Funciones, Busquedas;
  
//=============== Crea el formulario ================
procedure ShowFormDepartamentos;
begin
  with TFDepartamentos.Create(Application) do
    begin
       ShowModal;
    end;
end;
Procedure TFDepartamentos.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbDepartamentos.Sql.Text:='SELECT * FROM departamentos'+Tienda+' ORDER BY D0';
  dbDepartamentos.Active := True;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Departa', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Departa', 3);//------------------ Boton Borrar
  if CheckRoles(dbRoles, CgRol, 'Departa', 4)=False then Tabsheet2.Destroy;//--- Estadisticas
  if CheckRoles(dbRoles, CgRol, 'Departa', 4)=False then Tabsheet3.Destroy;//--- Graficas
end;

//==================== CERRAR ======================
Procedure TFDepartamentos.Bitbtn1click(Sender: Tobject);
Begin
  dbDepartamentos.Active:=False; dbEsta.Active:=False;
  dbGrafica.Active:=False;
  Close();
End;
Procedure TFDepartamentos.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//=================== REGISTRO NUEVO ===================
Procedure TFDepartamentos.Bitbtn2click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if dbDepartamentos.Locate('D0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO YA EXISTE');
      exit;
    end;
   dbDepartamentos.Append;
   LlenaReg();
   dbDepartamentos.Post;
   Label7.Caption:=dbDepartamentos.FieldByName('D1').AsString;
End;
//=================== BORRAR REGISTRO ===================
Procedure TFDepartamentos.Bitbtn3click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if not dbDepartamentos.Locate('D0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbDepartamentos.Delete;
  Edit1.Text := '';
  LimpiaForm();
End;

//=================== MODIFICAR ===================
Procedure TFDepartamentos.Bitbtn4click(Sender: Tobject);
Begin
   if (Edit1.Text='') or (dbDepartamentos.Recordcount=0) then exit;
   if not dbDepartamentos.Locate('D0,', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO!');
       exit;
     end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
   dbDepartamentos.Edit;
   LlenaReg();
   dbDepartamentos.Post;
End;

//=================== CODIGO DE LA DEPARTAMENTO ================
Procedure TFDepartamentos.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;
Procedure TFDepartamentos.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbDepartamentos.Locate('D0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;
//=====================================================
//================== BUSCAR DEPARTAMENTO ==================
//=====================================================
procedure TFDepartamentos.BitBtn8Click(Sender: TObject);
begin
  if Edit2.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit2.SetFocus;
     Exit;
  end;
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT D0,D1 FROM departamentos'+tienda+' WHERE D1 LIKE "%'+Edit2.Text+'%"',
                                         ['Código','Nombre'],'D0');
  if Edit1.Text='-1' then Edit1.Text:='' else Edit1Exit(Edit1);
end;

procedure TFDepartamentos.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn8Click(BitBtn8);
end;

//===================== LIMPIAR DATOS =======================
Procedure TFDepartamentos.LimpiaForm();
Begin
  Edit2.Text:=''; Label7.Caption:='';
  Edit10.Text:=''; Edit11.Text:=''; Memo1.Lines.Text:='';
End;

//===================== PINTAR DATOS =======================
Procedure TFDepartamentos.Relleno();
Begin
  if dbDepartamentos.RecordCount=0 then exit;
  Label7.Caption:=dbDepartamentos.FieldByName('D1').AsString;
  Edit1.Text:=dbDepartamentos.FieldByName('D0').AsString;//-------------- Cgo. departamento
  Edit2.Text:=dbDepartamentos.FieldByName('D1').AsString;//-------------- Nombre
  Edit10.Text:=dbDepartamentos.FieldByName('D2').AsString;//------------- F.Ult.Venta
  Edit11.Text:=dbDepartamentos.FieldByName('D3').AsString;//------------- F.Ult.Compra
  Memo1.Lines.Text:=dbDepartamentos.FieldByName('D4').AsString;//-------- Observaciones
  //-------------- Estadisticas --------------------
  RellenaEsta(FormatDateTime('YYYY',Date));//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, DD6-DD7 As BENEF FROM estadepa'+Tienda+' WHERE DD0="'+Edit1.Text+'"'+
                   ' AND DD1='+FormatDateTime('YYYY',Date)+
                   ' ORDER BY DD1 ASC, DD2 ASC';
  dbEsta.Active:=True;
  //------------------------------------------------
  CargaGrafica:=1; Graficas(); CargaGrafica:=0;//---------------- Pintar Graficas
End;
//===================== RELLENAR DATOS =======================
Procedure TFDepartamentos.LlenaReg();
Begin
  dbDepartamentos.FieldByName('D0').AsString:=Edit1.Text;//------------- Codigo
  dbDepartamentos.FieldByName('D1').AsString:=Edit2.Text;//------------- Nombre
  //------ Fecha Ultima Venta
  if Edit10.Text='' then
    dbDepartamentos.FieldByName('D2').Value:=Null
  else
    dbDepartamentos.FieldByName('D2').AsString:=Edit10.Text;
  //------ Fecha Ultima Compra
  if Edit11.Text='' then
    dbDepartamentos.FieldByName('D3').Value:=Null
  else
    dbDepartamentos.FieldByName('D3').AsString:=Edit11.Text;
  dbDepartamentos.FieldByName('D4').AsString:=Memo1.Lines.Text;//------- Observaciones
End;

//==================== REG. ANTERIOR ===============
Procedure TFDepartamentos.Bitbtn5click(Sender: Tobject);
Begin
  dbDepartamentos.Prior;
  LimpiaForm(); Relleno();
End;

//==================== REG. POSTERIOR ===============
Procedure TFDepartamentos.Bitbtn6click(Sender: Tobject);
Begin
   dbDepartamentos.Next;
   LimpiaForm(); Relleno();
End;

//============================================================
//===================== GRAFICAS =============================
//============================================================
procedure TFDepartamentos.Graficas();
Var
  Conta: Integer;
begin
  //-------------- Mostrar los distintos años ------------------
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT DISTINCT DD1 FROM estadepa'+Tienda+' WHERE DD0="'+Edit1.Text+'" ORDER BY DD1 DESC';
  dbGrafica.Active:=True;
  ListBox3.Items.Clear; ListBox5.Items.Clear;
  dbGrafica.First;
  while not dbGrafica.EOF do
    begin
      ListBox3.Items.Add(dbGrafica.FieldByName('DD1').AsString);
      ListBox5.Items.Add(dbGrafica.FieldByName('DD1').AsString);
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
     dbGrafica.SQL.Text:='SELECT *, DD6-DD7 As BENEF FROM estadepa'+Tienda+' WHERE DD0="'+Edit1.Text+'"'+
                         ' AND DD1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                         ' ORDER BY DD1 ASC, DD2 ASC';
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
procedure TFDepartamentos.ListBox3Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//------------------ Cambiar datos grafica -------------------
procedure TFDepartamentos.ListBox4Click(Sender: TObject);
begin
  CambiarGrafica();
end;

//----------------- Cambiar tipo de grafica ----------------
procedure TFDepartamentos.ListBox6Click(Sender: TObject);
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
procedure TFDepartamentos.CambiarGrafica();
var
  Conta: Integer;
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox3.Items.Count=0 then exit;//----- Si no hay años
  if ListBox3.ItemIndex=-1 then ListBox3.ItemIndex:=0;
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT *, DD6-DD7 As BENEF FROM estadepa'+Tienda+' WHERE DD0="'+Edit1.Text+'"'+
                      ' AND DD1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                      ' ORDER BY DD1 ASC, DD2 ASC';
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
procedure TFDepartamentos.ListBox5Click(Sender: TObject);
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox5.Items.Count=0 then exit;//----- Si no hay años
  if ListBox5.ItemIndex=-1 then ListBox5.ItemIndex:=0;
  RellenaEsta(ListBox5.Items.Strings[ListBox5.ItemIndex]);//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, DD6-DD7 As BENEF FROM estadepa'+Tienda+' WHERE DD0="'+Edit1.Text+'"'+
                   ' AND DD1='+ListBox5.Items.Strings[ListBox5.ItemIndex]+
                   ' ORDER BY DD1 ASC, DD2 ASC';
  dbEsta.Active:=True;
end;

//==========================================================
//============= RELLENAR MESES QUE ESTEN A 0 ===============
//==========================================================
procedure TFDepartamentos.RellenaEsta(Ano: String);
var
  Conta: Integer;
  UC,IC,UV,IVP,IVC,Beneficio : Double;
begin
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT * FROM estadepa'+Tienda+' WHERE DD0="'+Edit1.Text+'"'+
                   ' AND DD1='+Ano+
                   ' ORDER BY DD1 ASC, DD2 ASC';
  dbEsta.Active:=True;
  dbEsta.First;

  //*********** IMPLEMENTACIÓN DE MUESTREO DE TOTALES
    UC:=0; IC:=0; UV:=0; IVP:=0; IVC:=0; Beneficio:=0;
    While not dbEsta.EOF do
      begin
        UC := UC + dbEsta.FieldByName('DD3').Value;
        IC := IC + dbEsta.FieldByName('DD4').Value;
        UV := UV + dbEsta.FieldByName('DD5').Value;
        IVP := IVP + dbEsta.FieldByName('DD6').Value;
        IVC := IVC + dbEsta.FieldByName('DD7').Value;
        Beneficio := Beneficio + ( dbEsta.FieldByName('DD6').Value - dbEsta.FieldByName('DD7').Value );
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
      if not dbEsta.Locate('DD2',Conta,[]) then
        begin
           dbEsta.Append;
           dbEsta.FieldByName('DD0').AsString:=Edit1.Text;
           dbEsta.FieldByName('DD1').AsString:=Ano;
           dbEsta.FieldByName('DD2').AsString:=IntToStr(Conta);
           dbEsta.Post;
        end;
    end;
end;



Initialization
  {$I departamentos.lrs}

End.

