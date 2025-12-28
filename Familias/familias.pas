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

Unit Familias;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType, DBGrids,
  TAGraph, TASeries, db, DbCtrls;


Type

  { TFFamilias }

  TFFamilias = Class(Tform)
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    Chart1: TChart;
    Chart1AreaSeries1: TAreaSeries;
    Chart1BarSeries1: TBarSeries;
    Chart1PieSeries1: TPieSeries;
    Chart1Serie1: TLineSeries;
    Datasource1: TDatasource;
    dbRoles: TZQuery;
    dbGrafica: TZQuery;
    dbBusca: TZQuery;
    DBGrid1: TDBGrid;
    dbEsta: TZQuery;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label17: TLabel;
    Label4: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label5: TLabel;
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
    dbFamilias: TZQuery;
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
    Edit2: Tedit;
    Edit3: Tedit;
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit3Enter(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: char);
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
    procedure VerDepartamento();
    
  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormFamilias;
  
Var
  FFamilias: TFFamilias;
  CargaGrafica: Integer;
  s: TBarSeries;

Implementation

Uses
  Global, Funciones, Busquedas;
  
//=============== Crea el formulario ================
procedure ShowFormFamilias;
begin
  with TFFamilias.Create(Application) do
    begin
       ShowModal;
    end;
end;
Procedure TFFamilias.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);    // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbFamilias.Sql.Text:='SELECT * FROM familias'+Tienda+' ORDER BY F0';
  dbFamilias.Active := True;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Familias', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Familias', 3);//------------------ Boton Borrar
  if CheckRoles(dbRoles, CgRol, 'Familias', 4)=False then Tabsheet2.Destroy;//--- Estadisticas
  if CheckRoles(dbRoles, CgRol, 'Familias', 4)=False then Tabsheet3.Destroy;//--- Graficas
end;

//==================== CERRAR ======================
Procedure TFFamilias.Bitbtn1click(Sender: Tobject);
Begin
  dbFamilias.Active:=False; dbEsta.Active:=False;
  dbGrafica.Active:=False;
  Close();
End;
Procedure TFFamilias.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//=================== REGISTRO NUEVO ===================
Procedure TFFamilias.Bitbtn2click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if dbFamilias.Locate('F0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO YA EXISTE');
      exit;
    end;
   dbFamilias.Append;
   LlenaReg();
   dbFamilias.Post;
   Label7.Caption:=dbFamilias.FieldByName('F1').AsString;
End;
//=================== BORRAR REGISTRO ===================
Procedure TFFamilias.Bitbtn3click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if not dbFamilias.Locate('F0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbFamilias.Delete;
  Edit1.Text := '';
  LimpiaForm();
End;

//=================== MODIFICAR ===================
Procedure TFFamilias.Bitbtn4click(Sender: Tobject);
Begin
   if (Edit1.Text='') or (dbFamilias.Recordcount=0) then exit;
   if not dbFamilias.Locate('F0,', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO!');
       exit;
     end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
   dbFamilias.Edit;
   LlenaReg();
   dbFamilias.Post;
End;

//=================== CODIGO DE LA FAMILIA ================
Procedure TFFamilias.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;
Procedure TFFamilias.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbFamilias.Locate('F0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;
//=====================================================
//================== BUSCAR FAMILIAS ==================
//=====================================================
procedure TFFamilias.BitBtn8Click(Sender: TObject);
begin
  if Edit2.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit2.SetFocus;
     Exit;
  end;
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT F0,F1 FROM familias'+tienda+' WHERE F1 LIKE "%'+Edit2.Text+'%"',
                                         ['Código','Nombre'], 'F0');
  if Edit1.Text='-1' then Edit1.Text:='' else Edit1Exit(Edit1);
end;

procedure TFFamilias.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn8Click(BitBtn8);
end;

//===================== LIMPIAR DATOS =======================
Procedure TFFamilias.LimpiaForm();
Begin
  Edit2.Text:=''; Edit3.Text:=''; Label7.Caption:='';
  Edit10.Text:=''; Edit11.Text:=''; Memo1.Lines.Text:='';
  Edit4.Text:='';
End;

//===================== PINTAR DATOS =======================
Procedure TFFamilias.Relleno();
Begin
  if dbFamilias.RecordCount=0 then exit;
  Label7.Caption:=dbFamilias.FieldByName('F1').AsString;
  Edit1.Text:=dbFamilias.FieldByName('F0').AsString;//-------------- Cgo. Familia
  Edit2.Text:=dbFamilias.FieldByName('F1').AsString;//-------------- Nombre
  Edit3.Text:=dbFamilias.FieldByName('F2').AsString;//-------------- Departamento
  if (Edit3.Text<>'0') and (Edit3.Text<>'') then VerDepartamento();//- Nombre Departam.
  Edit10.Text:=dbFamilias.FieldByName('F3').AsString;//------------- F.Ult.Venta
  Edit11.Text:=dbFamilias.FieldByName('F4').AsString;//------------- F.Ult.Compra
  Memo1.Lines.Text:=dbFamilias.FieldByName('F5').AsString;//-------- Observaciones
  //-------------- Estadisticas --------------------
  RellenaEsta(FormatDateTime('YYYY',Date));//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, FF6-FF7 As BENEF FROM estafami'+Tienda+' WHERE FF0="'+Edit1.Text+'"'+
                   ' AND FF1='+FormatDateTime('YYYY',Date)+
                   ' ORDER BY FF1 ASC, FF2 ASC';
  dbEsta.Active:=True;
  //------------------------------------------------
  CargaGrafica:=1; Graficas(); CargaGrafica:=0;//---------------- Pintar Graficas
End;
//===================== RELLENAR DATOS =======================
Procedure TFFamilias.LlenaReg();
Begin
  dbFamilias.FieldByName('F0').AsString:=Edit1.Text;//------------- Codigo
  dbFamilias.FieldByName('F1').AsString:=Edit2.Text;//------------- Nombre
  dbFamilias.FieldByName('F2').AsString:=Edit3.Text;//------------- Departamento
  //------ Fecha Ultima Venta
  if Edit10.Text='' then
    dbFamilias.FieldByName('F3').Value:=Null
  else
    dbFamilias.FieldByName('F3').AsString:=Edit10.Text;
  //------ Fecha Ultima Compra
  if Edit11.Text='' then
    dbFamilias.FieldByName('F4').Value:=Null
  else
    dbFamilias.FieldByName('F4').AsString:=Edit11.Text;
  dbFamilias.FieldByName('F5').AsString:=Memo1.Lines.Text;//------- Observaciones
End;

//==================== REG. ANTERIOR ===============
Procedure TFFamilias.Bitbtn5click(Sender: Tobject);
Begin
  dbFamilias.Prior;
  LimpiaForm(); Relleno();
End;

//==================== REG. POSTERIOR ===============
Procedure TFFamilias.Bitbtn6click(Sender: Tobject);
Begin
   dbFamilias.Next;
   LimpiaForm(); Relleno();
End;

//============================================================
//===================== GRAFICAS =============================
//============================================================
procedure TFFamilias.Graficas();
Var
  Conta: Integer;
begin
  //-------------- Mostrar los distintos años ------------------
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT DISTINCT FF1 FROM estafami'+Tienda+' WHERE FF0="'+Edit1.Text+'" ORDER BY FF1 DESC';
  dbGrafica.Active:=True;
  ListBox3.Items.Clear; ListBox5.Items.Clear;
  dbGrafica.First;
  while not dbGrafica.EOF do
    begin
      ListBox3.Items.Add(dbGrafica.FieldByName('FF1').AsString);
      ListBox5.Items.Add(dbGrafica.FieldByName('FF1').AsString);
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
     dbGrafica.SQL.Text:='SELECT *, FF6-FF7 As BENEF FROM estafami'+Tienda+' WHERE FF0="'+Edit1.Text+'"'+
                         ' AND FF1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                         ' ORDER BY FF1 ASC, FF2 ASC';
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
procedure TFFamilias.ListBox3Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//------------------ Cambiar datos grafica -------------------
procedure TFFamilias.ListBox4Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//----------------- Cambiar tipo de grafica ----------------
procedure TFFamilias.ListBox6Click(Sender: TObject);
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
procedure TFFamilias.CambiarGrafica();
var
  Conta: Integer;
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox3.Items.Count=0 then exit;//----- Si no hay años
  if ListBox3.ItemIndex=-1 then ListBox3.ItemIndex:=0;
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT *, FF6-FF7 As BENEF FROM estafami'+Tienda+' WHERE FF0="'+Edit1.Text+'"'+
                      ' AND FF1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                      ' ORDER BY FF1 ASC, FF2 ASC';
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
procedure TFFamilias.ListBox5Click(Sender: TObject);
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox5.Items.Count=0 then exit;//----- Si no hay años
  if ListBox5.ItemIndex=-1 then ListBox5.ItemIndex:=0;
  RellenaEsta(ListBox5.Items.Strings[ListBox5.ItemIndex]);//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, FF6-FF7 As BENEF FROM estafami'+Tienda+' WHERE FF0="'+Edit1.Text+'"'+
                   ' AND FF1='+ListBox5.Items.Strings[ListBox5.ItemIndex]+
                   ' ORDER BY FF1 ASC, FF2 ASC';
  dbEsta.Active:=True;
end;


//==========================================================
//============= RELLENAR MESES QUE ESTEN A 0 ===============
//==========================================================
procedure TFFamilias.RellenaEsta(Ano: String);
var
  Conta: Integer;
  UC,IC,UV,IVP,IVC,Beneficio : Double;
begin
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT * FROM estafami'+Tienda+' WHERE FF0="'+Edit1.Text+'"'+
                   ' AND FF1='+Ano+
                   ' ORDER BY FF1 ASC, FF2 ASC';
  dbEsta.Active:=True;
  dbEsta.First;

    //*********** IMPLEMENTACIÓN DE MUESTREO DE TOTALES
      UC:=0; IC:=0; UV:=0; IVP:=0; IVC:=0; Beneficio:=0;
      While not dbEsta.EOF do
        begin
          UC := UC + dbEsta.FieldByName('FF3').Value;
          IC := IC + dbEsta.FieldByName('FF4').Value;
          UV := UV + dbEsta.FieldByName('FF5').Value;
          IVP := IVP + dbEsta.FieldByName('FF6').Value;
          IVC := IVC + dbEsta.FieldByName('FF7').Value;
          Beneficio := Beneficio + ( dbEsta.FieldByName('FF6').Value - dbEsta.FieldByName('FF7').Value );
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
      if not dbEsta.Locate('FF2',Conta,[]) then
        begin
           dbEsta.Append;
           dbEsta.FieldByName('FF0').AsString:=Edit1.Text;
           dbEsta.FieldByName('FF1').AsString:=Ano;
           dbEsta.FieldByName('FF2').AsString:=IntToStr(Conta);
           dbEsta.Post;
        end;
    end;
end;

//================ CODIGO DEPARTAMENTO =====================
procedure TFFamilias.Edit3Enter(Sender: TObject);
begin
  Edit4.Text:='';
end;
procedure TFFamilias.Edit3Exit(Sender: TObject);
begin
  if Edit3.Text<>'' then VerDepartamento();
end;

//=============== BUSCAR DEPARTAMENTOS =====================
procedure TFFamilias.BitBtn7Click(Sender: TObject);
begin
  if Edit4.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit4.SetFocus;
     Exit;
  End;
  Edit3.Text:=FBusquedas.IniciaBusquedas('SELECT D0,D1 FROM departamentos'+tienda+' WHERE D1 LIKE "%'+Edit4.Text+'%"',
                                         ['Código','Nombre'], 'D0');
  if Edit3.Text='-1' then Edit3.Text:='' else Edit3Exit(Edit3);
end;

procedure TFFamilias.Edit4KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn7Click(BitBtn7);
end;

//================ PINTAR NOMBRE DEPARTAMENTO ==============
procedure TFFamilias.VerDepartamento();
begin
  Edit4.Text:='';
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT * FROM departamentos'+Tienda+' WHERE D0='+Edit3.Text;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  Edit4.Text:=dbBusca.FieldByName('D1').AsString;
end;


Initialization
  {$I familias.lrs}

End.

