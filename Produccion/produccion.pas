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

Unit Produccion;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType, DBGrids,
  TAGraph, TASeries, db, DbCtrls, variants;


Type

  { TFProduccion }

  TFProduccion = Class(Tform)
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    dbRoles: TZQuery;
    dbSumas: TZQuery;
    dblotescc: TZQuery;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    dblotesdd: TZQuery;
    dbArti: TZQuery;
    dbTrabajo: TZQuery;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: Tpanel;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    Bitbtn4: Tbitbtn;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure Datasource1DataChange(Sender: TObject; Field: TField);
    procedure Edit10Exit(Sender: TObject);
    procedure Edit11Exit(Sender: TObject);
    procedure Edit3Enter(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
    procedure Edit8Exit(Sender: TObject);
    procedure Edit9Exit(Sender: TObject);
    Procedure Formcreate(Sender: Tobject);
    Procedure Edit1enter(Sender: Tobject);
    Procedure Edit1exit(Sender: Tobject);
    Procedure LimpiaForm();
    Procedure LimpiaForm1();
    Procedure Relleno();
    Procedure Relleno1();
    Procedure RellenoA1();
    Procedure LlenaReg();
    Procedure LlenaReg1();
    Procedure Recalculacc();
    Procedure Bitbtn1click(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    Procedure Bitbtn4click(Sender: Tobject);
    Procedure Bitbtn2click(Sender: Tobject);
    Procedure Bitbtn3click(Sender: Tobject);

  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormProduccion;
  
Var
  FProduccion: TFProduccion;
  CargaGrafica: Integer;
  Campo: Array [1..2] of variant;
  cargando: Integer;

Implementation

Uses
  Global, Funciones;
  
//=============== Crea el formulario ================
procedure ShowFormProduccion;
begin
  with TFProduccion.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFProduccion.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Produccion', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Produccion', 3);//------------------ Boton Borrar
  BitBtn9.Enabled:=CheckRoles(dbRoles, CgRol, 'Produccion', 2);//------------------ Boton Modificar
  BitBtn6.Enabled:=CheckRoles(dbRoles, CgRol, 'Produccion', 3);//------------------ Boton Borrar
  //------------------- Tablas ------------------
  cargando:=1;
  dblotescc.Sql.Text:='SELECT * FROM lotescc'+Tienda+' ORDER BY PROC0';
  dblotescc.Active := True;
  cargando:=0;
  if dbLotescc.RecordCount=0 then
    begin
      dbLotesdd.Active:=False;
      dbLotesdd.SQL.Text:='SELECT * from lotesdd'+Tienda;
      dbLotesdd.Active:=True;
      exit;
    end;
  dbLotescc.First;
  dbLotesdd.Active:=False;
  dbLotesdd.SQL.Text:='SELECT * from lotesdd'+Tienda+' WHERE PROD0='+dbLotescc.FieldByName('PROC0').AsString;
  dbLotesdd.Active:=True;
end;


//==================== CERRAR ======================
Procedure TFProduccion.Bitbtn1click(Sender: Tobject);
Begin
  dblotescc.Active:=False;
  Close();
End;
Procedure TFProduccion.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//=================== REGISTRO NUEVO CC ===================
Procedure TFProduccion.Bitbtn2click(Sender: Tobject);
begin
  Panel2.Visible:=True;
  DBGrid1.Enabled:=False; Panel1.Enabled:=False;
  Edit1.Text:=''; LimpiaForm();
  Edit1.Enabled:=True; Edit1.SetFocus;
end;

//=================== REGISTRO NUEVO DD ===================
procedure TFProduccion.BitBtn5Click(Sender: TObject);
begin
  Panel4.Visible:=True;
  DBGrid2.Enabled:=False; Panel3.Enabled:=False;
  Edit3.Text:=''; LimpiaForm1();
  Edit3.Enabled:=True; Edit3.SetFocus;
end;

//=================== BORRAR REGISTRO CC ===================
Procedure TFProduccion.Bitbtn3click(Sender: Tobject);
begin
  if (dblotescc.RecordCount=0) or (dblotescc.EOF) then exit;
  {if not dblotescc.Locate('PROC0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;}
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='DELETE FROM lotesdd'+Tienda+' WHERE PROD0='+dbLotescc.FieldByName('PROC0').AsString;
  dbTrabajo.ExecSQL;
  dblotescc.Delete;
  //----------------- Si no hay mas lotescc
  if dbLotescc.RecordCount=0 then
    begin
      dbLotesdd.Active:=False;
      dbLotesdd.SQL.Text:='SELECT * from lotesdd'+Tienda;
      dbLotesdd.Active:=True;
      exit;
    end;
end;
//=================== BORRAR REGISTRO DD ===================
procedure TFProduccion.BitBtn6Click(Sender: TObject);
begin
  if (dblotesdd.RecordCount=0) or (dblotesdd.EOF) then exit;
  {if not dblotesdd.Locate('PROD0,PROD1',VarArrayof([dblotescc.FieldByName('PROC0').AsString,Edit3.Text]),[locaseinsensitive]) then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;}
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dblotesdd.Delete;
end;

//=================== MODIFICAR CC ===================
Procedure TFProduccion.Bitbtn4click(Sender: Tobject);
Begin
  Panel2.Visible:=True;
  DBGrid1.Enabled:=False; Panel1.Enabled:=False;
  LimpiaForm(); Relleno();
  Edit1.Enabled:=False; Edit2.SetFocus;
End;

//=================== MODIFICAR DD ===================
procedure TFProduccion.BitBtn9Click(Sender: TObject);
begin
  Panel4.Visible:=True;
  DBGrid2.Enabled:=False; Panel3.Enabled:=False;
  LimpiaForm1(); Relleno1();
  Edit3.Enabled:=False; Edit4.SetFocus;
end;

//=================== AL CAMBIAR DE LOTE CC =============
procedure TFProduccion.Datasource1DataChange(Sender: TObject; Field: TField);
begin
  if cargando=1 then exit;
  if dblotescc.RecordCount=0 then exit;
  dbLotesdd.Active:=False;
  dbLotesdd.SQL.Text:='SELECT * from lotesdd'+Tienda+' WHERE PROD0='+dbLotescc.FieldByName('PROC0').AsString;
  dbLotesdd.Active:=True;
end;

//=================== CODIGO DEL LOTE CC ================
Procedure TFProduccion.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;
Procedure TFProduccion.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dblotescc.Locate('PROC0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;

//=================== CODIGO DEL LOTE DD ================
procedure TFProduccion.Edit3Enter(Sender: TObject);
begin
 Edit3.Text := '';
 LimpiaForm1();
end;
procedure TFProduccion.Edit3Exit(Sender: TObject);
begin
  if Edit3.Text='' then exit;
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit3.Text+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount<>0 then
     RellenoA1() else LimpiaForm1();
end;

//=================== COSTO DEL LOTE ================
procedure TFProduccion.Edit7Exit(Sender: TObject);
Var
  Precio, PrecioCon : Double;
begin
  if (Edit7.Text='0') or (Edit7.Text='') then begin Edit7.Text:='0'; exit; end;
  if (Edit8.Text='0') or (Edit8.Text='') then begin Edit8.Text:='0'; exit; end;
  Precio:=(StrToFloat(Edit7.text)*StrToFloat(Edit8.text)/100)+StrToFloat(Edit7.text);// ---- Añadir Margen
  PrecioCon:=Precio;
  Edit9.Text := FormatFloat('0.000',PrecioCon);
end;

//=================== MARGEN DEL LOTE ================
procedure TFProduccion.Edit8Exit(Sender: TObject);
Var
  Precio, PrecioCon : Double;
begin
  if (Edit7.Text='0') or (Edit7.Text='') then begin Edit7.Text:='0'; exit; end;
  if (Edit8.Text='0') or (Edit8.Text='') then begin Edit8.Text:='0'; exit; end;
  Precio:=(StrToFloat(Edit7.text)*StrToFloat(Edit8.text)/100)+StrToFloat(Edit7.text);// ---- Añadir Margen
  PrecioCon:=Precio;
  Edit9.Text := FormatFloat('0.000',PrecioCon);
end;

//=================== PRECIO DEL LOTE ================
procedure TFProduccion.Edit9Exit(Sender: TObject);
var
  PvpSinIva, Margen, CostoCero, PrecioCon: double;
begin
  if (Edit9.Text='') or (Edit9.Text='0') then exit;
  //---------- Calcular margen sobre el pvp
  if (Edit7.Text <> '') and (Edit7.Text <> '0') then
    begin
      PvpSinIva := StrToFloat(Edit9.text);
      Margen := (PvpSinIva - StrToFloat(Edit7.Text)) * 100 / StrToFloat(Edit7.Text);
      Edit8.Text := FormatFloat('0.000',Margen);
    end
  else
    begin
      //------- Calcular costo cuando es 0
      if (Edit8.Text<>'') and (Edit8.Text<>'0') then
       begin
        CostoCero := (100 * StrToFloat(Edit9.text)) / (100 + StrToFloat(Edit8.Text));
        Edit7.Text:=FormatFloat('0.000',CostoCero); Edit7Exit(Edit7);
       end;
    end;
   //------ Calcular precio con iva si hay iva ---------
   if (Edit10.Text<>'0') and (Edit10.Text<>'') then
     begin
       PrecioCon:=(StrToFloat(Edit9.Text) * StrToFloat(Edit10.Text) / 100) +
                   StrToFloat(Edit9.Text); //--- Sumar el IVA
       Edit11.Text:=FormatFloat('0.00',PrecioCon);
     end;
end;

//=================== IVA DEL LOTE ================
procedure TFProduccion.Edit10Exit(Sender: TObject);
var
   PrecioCon: Double;
begin
   if (Edit9.Text='') or (Edit9.Text='0') then exit;
   if (Edit10.Text='') or (Edit10.Text='0') then exit;
   PrecioCon:=(StrToFloat(Edit9.Text) * StrToFloat(Edit10.Text) / 100) + StrToFloat(Edit9.Text); //--- Sumar el IVA
   Edit11.Text:=FormatFloat('0.00',PrecioCon);
end;

//=================== PVP DEL LOTE ================
procedure TFProduccion.Edit11Exit(Sender: TObject);
var
   PrecioSin: Double;
begin
   if (Edit11.Text='') or (Edit11.Text='0') then exit;
   if (Edit10.Text='') or (Edit10.Text='0') then exit;
   PrecioSin := (100 * StrToFloat(Edit11.text)) / (100 + StrToFloat(Edit10.Text));
   Edit9.Text:=FormatFloat('0.000',PrecioSin); Edit9Exit(Edit9);
end;

//=============== ACEPTAR MODIFICAR / CREAR CC ================
procedure TFProduccion.BitBtn7Click(Sender: TObject);
begin
  //------------- Crear o Modificar Registros --------
  if Edit1.Enabled=true then
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;

     if dblotescc.Locate('PROC0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO YA EXISTE'); exit; end;

//     showmessage(dblotescc.SQL.Text);

     dblotescc.Append;



    end
  else
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if not dblotescc.Locate('PROC0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO'); exit; end;
     dblotescc.Edit;
    end;



  LlenaReg();//---- Rellenar datos
  dblotescc.Post;
  BitBtn8Click(BitBtn8);//--- Cerrar Panel
end;

//=============== ACEPTAR MODIFCAR / CREAR DD ================
procedure TFProduccion.BitBtn10Click(Sender: TObject);
begin
  //------------- Crear o Modificar Registros --------
  if Edit3.Enabled=true then
    begin
     if (Edit3.Text='') or (Edit4.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if dblotesdd.Locate('PROD0,PROD1',VarArrayof([dblotescc.FieldByName('PROC0').AsString,Edit3.Text]),[locaseinsensitive]) then
       begin ShowMessage('ESE REGISTRO YA EXISTE'); exit; end;
     dblotesdd.Append;
    end
  else
    begin
     if (Edit3.Text='') or (Edit4.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if not dblotesdd.Locate('PROD0,PROD1',VarArrayof([dblotescc.FieldByName('PROC0').AsString,Edit3.Text]),[locaseinsensitive]) then
       begin ShowMessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO'); exit; end;
     dblotesdd.Edit;
    end;
  LlenaReg1();//---- Rellenar datos
  dblotesdd.Post;
  Recalculacc();//----------- Recalcular totales
  BitBtn11Click(BitBtn11);//--- Cerrar Panel
end;

//================= CERRAR CREAR / MODIFICAR CC ==============
procedure TFProduccion.BitBtn8Click(Sender: TObject);
begin
  Panel2.Visible:=False; Edit1.Enabled:=True;
  DBGrid1.Enabled:=True; Panel1.Enabled:=True;
end;

//================= CERRAR CREAR / MODIFICAR DD ==============
procedure TFProduccion.BitBtn11Click(Sender: TObject);
begin
  Panel4.Visible:=False; Edit3.Enabled:=True;
  DBGrid2.Enabled:=True; Panel3.Enabled:=True;
end;

//===================== LIMPIAR DATOS =======================
Procedure TFProduccion.LimpiaForm();
Begin
  Edit2.Text:=''; Edit7.Text:='0'; Edit8.Text:='0'; Edit9.Text:='0';
  Edit10.Text:='0'; Edit11.Text:='0';
End;
Procedure TFProduccion.LimpiaForm1();
Begin
  Edit4.Text:=''; Edit5.Text:='0'; Edit6.Text:='0';
End;


//===================== PINTAR DATOS =======================
Procedure TFProduccion.Relleno();
Begin
  if dblotescc.RecordCount=0 then exit;
  Edit1.Text:=dblotescc.FieldByName('PROC0').AsString;//-------------- Cgo. lote
  Edit2.Text:=dblotescc.FieldByName('PROC1').AsString;//-------------- Nombre
  Edit7.Text:=dblotescc.FieldByName('PROC2').AsString;//-------------- Costo
  Edit8.Text:=dblotescc.FieldByName('PROC3').AsString;//-------------- Nombre
  Edit9.Text:=dblotescc.FieldByName('PROC4').AsString;//-------------- Nombre
  Edit10.Text:=dblotescc.FieldByName('PROC5').AsString;//------------- Nombre
  Edit11.Text:=dblotescc.FieldByName('PROC6').AsString;//------------- Nombre
End;
Procedure TFProduccion.Relleno1();
Begin
  if dblotesdd.RecordCount=0 then exit;
  Edit3.Text:=dblotesdd.FieldByName('PROD1').AsString;//------- Cgo. lote
  Edit4.Text:=dblotesdd.FieldByName('PROD2').AsString;//------- Nombre
  Edit5.Text:=dblotesdd.FieldByName('PROD3').AsString;//-------------- Unidades
  Edit6.Text:=dblotesdd.FieldByName('PROD4').AsString;//------------- Costo
End;
Procedure TFProduccion.RellenoA1();
Begin
  if dbarti.RecordCount=0 then exit;
  Edit3.Text:=dbArti.FieldByName('A0').AsString;//-------------- Cgo. lote
  Edit4.Text:=dbArti.FieldByName('A1').AsString;//------- Nombre
  Edit5.Text:='1'; //dbArti.FieldByName('A2').AsString;//-------------- Unidades
  Edit6.Text:=dbArti.FieldByName('A24').AsString;//------------- Costo
End;

//===================== RELLENAR DATOS =======================
Procedure TFProduccion.LlenaReg();
Begin
  dblotescc.FieldByName('PROC0').AsString:=Edit1.Text;//------------- Codigo
  dblotescc.FieldByName('PROC1').AsString:=Edit2.Text;//------------- Nombre
  dblotescc.FieldByName('PROC2').AsString:=Edit7.Text;//------------- Costo
  dblotescc.FieldByName('PROC3').AsString:=Edit8.Text;//------------- Margen
  dblotescc.FieldByName('PROC4').AsString:=Edit9.Text;//------------- Precio
  dblotescc.FieldByName('PROC5').AsString:=Edit10.Text;//------------ Iva
  dblotescc.FieldByName('PROC6').AsString:=Edit11.Text;//------------ PVP
End;
Procedure TFProduccion.LlenaReg1();
begin
  dblotesdd.FieldByName('PROD0').AsString:=dblotescc.FieldByName('PROC0').AsString;//- Codigo
  dblotesdd.FieldByName('PROD1').AsString:=Edit3.Text;//------------- Cgo. Articulo
  dblotesdd.FieldByName('PROD2').AsString:=Edit4.Text;//------------- Nombre
  dblotesdd.FieldByName('PROD3').AsString:=Edit5.Text;//------------- Unid.
  dblotesdd.FieldByName('PROD4').AsString:=Edit6.Text;//------------- Costo
end;

//======================== CALCULAR TOTAL LOTE =================
Procedure TFProduccion.Recalculacc();
begin
  if dblotescc.RecordCount=0 then exit;;
  dbSumas.Active:=False;
  dbSumas.SQL.Text:='SELECT SUM(PROD4) As SumaDD from lotesdd'+Tienda+' WHERE PROD0='+dbLotescc.FieldByName('PROC0').AsString;
  dbSumas.Active:=True;

  dblotescc.Edit;
  dblotescc.FieldByName('PROC2').Value:=dbSumas.FieldByName('SumaDD').AsFloat;
  dbLotescc.Post;

end;

Initialization
  {$I produccion.lrs}

End.

