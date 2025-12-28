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

Unit Rutas;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType, DBGrids,
  TAGraph, TASeries, db, DbCtrls;


Type

  { TFRutas }

  TFRutas = Class(Tform)
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    DBGrid2: TDBGrid;
    dbRuta: TZQuery;
    DBGrid1: TDBGrid;
    dbRoles: TZQuery;
    dbSubRuta: TZQuery;
    dbSubRuta1: TZQuery;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure Datasource1DataChange(Sender: TObject; Field: TField);
    procedure Edit3Enter(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    Procedure Formcreate(Sender: Tobject);
    Procedure Edit1enter(Sender: Tobject);
    Procedure Edit1exit(Sender: Tobject);
    Procedure LimpiaForm();
    Procedure LimpiaForm1();
    Procedure Relleno();
    Procedure Relleno1();
    Procedure LlenaReg();
    Procedure LlenaReg1();
    Procedure RefrescaSubRuta1();
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

  procedure ShowFormRutas;
  
Var
  FRutas: TFRutas;
  cargando: Integer;

Implementation

Uses
  Global, Funciones;
  
//=============== Crea el formulario ================
procedure ShowFormRutas;
begin
  with TFRutas.Create(Application) do
    begin
       ShowModal;
    end;
end;
Procedure TFRutas.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);    // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  cargando:=1;
  dbRuta.Sql.Text:='SELECT * FROM rutas'+Tienda+' ORDER BY RUT0';
  dbRuta.Active := True;
  cargando:=0;
  if dbRuta.RecordCount<>0 then
  begin
    dbRuta.First;
    dbSubRuta1.Active:=False;
    dbSubRuta1.SQL.Text:='SELECT * FROM subrutas'+Tienda+
                        ' WHERE SRUT0='+dbRuta.FieldByName('RUT0').AsString+
                        ' ORDER BY SRUT1';
    dbSubRuta1.Active:=True;
  end;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Rutas', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Rutas', 3);//------------------ Boton Borrar
  BitBtn6.Enabled:=CheckRoles(dbRoles, CgRol, 'Rutas', 2);//------------------ Boton Modificar
  BitBtn11.Enabled:=CheckRoles(dbRoles, CgRol, 'Rutas', 3);//----------------- Boton Borrar
end;

//==================== CERRAR ======================
Procedure TFRutas.Bitbtn1click(Sender: Tobject);
Begin
  dbRuta.Active:=False;
  Close();
End;
Procedure TFRutas.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//=================== CREAR RUTAS ===================
Procedure TFRutas.Bitbtn2click(Sender: Tobject);
Begin
  Panel2.Visible:=True;
  Panel1.Enabled:=False; Panel3.Enabled:=False;
  DBGrid1.Enabled:=False;
  Edit1.Text:=''; LimpiaForm();
  Edit1.Enabled:=True; Edit1.SetFocus;
End;
//=================== BORRAR RUTAS ===================
Procedure TFRutas.Bitbtn3click(Sender: Tobject);
Begin
  if not dbRuta.Locate('RUT0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbRuta.Delete;
End;

//=================== MODIFICAR RUTAS ===================
Procedure TFRutas.Bitbtn4click(Sender: Tobject);
Begin
  Panel2.Visible:=True;
  Panel1.Enabled:=False; Panel3.Enabled:=False;
  DBGrid1.Enabled:=False;
  LimpiaForm(); Relleno();
  Edit1.Enabled:=False; Edit2.SetFocus;
End;

//=================== CODIGO DE LA RUTA ================
Procedure TFRutas.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;
Procedure TFRutas.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbRuta.Locate('RUT0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;

//=============== ACEPTAR MODIFCAR / CREAR RUTAS ================
procedure TFRutas.BitBtn7Click(Sender: TObject);
begin
  //------------- Crear o Modificar Registros --------
  if Edit1.Enabled=true then
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if dbRuta.Locate('RUT0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO YA EXISTE'); exit; end;
     dbRuta.Append;
    end
  else
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if not dbRuta.Locate('RUT0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO'); exit; end;
     dbRuta.Edit;
    end;
  LlenaReg();//---- Rellenar datos
  dbRuta.Post;
  BitBtn8Click(BitBtn8);//--- Cerrar Panel
end;

//================= CERRAR CREAR / MODIFICAR RUTAS ==============
procedure TFRutas.BitBtn8Click(Sender: TObject);
begin
  Panel1.Enabled:=True; Panel3.Enabled:=True;
  Panel2.Visible:=False; Edit1.Enabled:=True;
  DBGrid1.Enabled:=True;
end;

//==================== AL CAMBIAR DE RUTA MOSTRAR SUB RUTA ================
procedure TFRutas.Datasource1DataChange(Sender: TObject; Field: TField);
begin
  if cargando=1 then exit;
  if dbRuta.FieldByName('RUT0').AsString='' then exit;
  dbSubRuta1.Active:=False;
  dbSubRuta1.SQL.Text:='SELECT * FROM subrutas'+Tienda+
                      ' WHERE SRUT0='+dbRuta.FieldByName('RUT0').AsString+
                      ' ORDER BY SRUT1';
  dbSubRuta1.Active:=True;
end;

//===================== LIMPIAR DATOS RUTAS =======================
Procedure TFRutas.LimpiaForm();
Begin
  Edit2.Text:='';
End;

//===================== PINTAR DATOS RUTAS =======================
Procedure TFRutas.Relleno();
Begin
  if dbRuta.RecordCount=0 then exit;
  Edit1.Text:=dbRuta.FieldByName('RUT0').AsString;//-------------- Codigo
  Edit2.Text:=dbRuta.FieldByName('RUT1').AsString;//-------------- Nombre
End;

//===================== RELLENAR DATOS RUTAS =======================
Procedure TFRutas.LlenaReg();
Begin
  dbRuta.FieldByName('RUT0').AsString:=Edit1.Text;//------------- Codigo
  dbRuta.FieldByName('RUT1').AsString:=Edit2.Text;//------------- Nombre
End;

//====================================================================
//=========================== SUB RUTAS ==============================
//====================================================================

//========================= CREAR SUB RUTAS ==========================
procedure TFRutas.BitBtn5Click(Sender: TObject);
begin
  if dbRuta.RecordCount=0 then begin showmessage('PRIMERO DEBE CREAR UNA RUTA'); exit; end;
  if dbRuta.EOF then begin showmessage('PRIMERO DEBE SELECCIONAR UNA RUTA'); exit; end;
  Panel4.Visible:=True;
  Panel1.Enabled:=False; Panel3.Enabled:=False;
  Panel3.Visible:=True;
  DBGrid1.Enabled:=False; DBGrid2.Enabled:=False;
  Edit3.Text:=''; LimpiaForm1();
  Edit3.Enabled:=True; Edit3.SetFocus;
end;

//========================= BORRAR SUB RUTAS ==========================
procedure TFRutas.BitBtn6Click(Sender: TObject);
begin
  dbSubRuta.Active:=False;
  dbSubRuta.SQL.Text:='SELECT * FROM subrutas'+Tienda+
                      ' WHERE SRUT0='+dbSubRuta1.FieldByName('SRUT0').AsString+
                      ' AND SRUT1='+dbSubRuta1.FieldByName('SRUT1').AsString+
                      ' ORDER BY SRUT1';
  dbSubRuta.Active:=True;
  if dbSubRuta.RecordCount=0 then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbSubRuta.Delete;
  RefrescaSubRuta1();
end;

//========================== MODIFICAR SUB RUTAS ======================
procedure TFRutas.BitBtn11Click(Sender: TObject);
begin
  if dbSubRuta1.RecordCount=0 then begin showmessage('PRIMERO DEBE CREAR UNA SUB RUTA'); exit; end;
  if dbSubRuta1.EOF then begin showmessage('PRIMERO DEBE SELECCIONAR UNA SUB RUTA'); exit; end;
  dbSubRuta.Active:=False;
  dbSubRuta.SQL.Text:='SELECT * FROM subrutas'+Tienda+
                      ' WHERE SRUT0='+dbSubRuta1.FieldByName('SRUT0').AsString+
                      ' AND SRUT1='+dbSubRuta1.FieldByName('SRUT1').AsString;
  dbSubRuta.Active:=True;
  if dbSubRuta.RecordCount=0 then exit;
  Panel4.Visible:=True;
  Panel1.Enabled:=False; Panel3.Enabled:=False;
  Panel3.Visible:=True;
  DBGrid1.Enabled:=False; DBGrid2.Enabled:=False;
  Edit3.Text:=''; LimpiaForm1(); Relleno1();
  Edit3.Enabled:=False; Edit4.SetFocus;
end;

//=================== CODIGO DE LA SUB RUTA ================
procedure TFRutas.Edit3Enter(Sender: TObject);
begin
  Edit3.Text:='';
  LimpiaForm1();
end;
procedure TFRutas.Edit3Exit(Sender: TObject);
begin
  if Edit3.Text='' then exit;
  dbSubRuta.Active:=False;
  dbSubRuta.SQL.Text:='SELECT * FROM subrutas'+Tienda+
                      ' WHERE SRUT0='+dbRuta.FieldByName('RUT0').AsString+
                      ' AND SRUT1='+Edit3.Text+
                      ' ORDER BY SRUT1';
  dbSubRuta.Active:=True;
  if dbSubRuta.RecordCount<>0 then Relleno1() else LimpiaForm1();
end;

//=============== ACEPTAR MODIFCAR / CREAR SUB RUTAS ================
procedure TFRutas.BitBtn9Click(Sender: TObject);
begin
  //------------- Crear o Modificar Registros --------
  if Edit3.Enabled=true then
    begin
     if (Edit3.Text='') or (Edit4.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if dbSubRuta.RecordCount<>0 then
       begin ShowMessage('ESE REGISTRO YA EXISTE'); exit; end;
     dbSubRuta.Append;
    end
  else
    begin
     if (Edit3.Text='') or (Edit4.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if dbSubRuta.RecordCount=0 then
       begin ShowMessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO'); exit; end;
     dbSubRuta.Edit;
    end;
  LlenaReg1();//---- Rellenar datos
  dbSubRuta.Post;
  RefrescaSubRuta1();//-------- Resfrescar Panel Sub Rutas
  BitBtn10Click(BitBtn10);//--- Cerrar Panel
end;

//====================== CERRAR PANEL SUB RUTAS =======================
procedure TFRutas.BitBtn10Click(Sender: TObject);
begin
  Panel1.Enabled:=True; Panel3.Enabled:=True;
  Panel4.Visible:=False; Edit3.Enabled:=True;
  DBGrid1.Enabled:=True; DBGrid2.Enabled:=True;
end;

//===================== LIMPIAR DATOS SUB RUTAS =======================
Procedure TFRutas.LimpiaForm1();
Begin
  Edit4.Text:=''; Edit5.Text:=''; Edit6.Text:='';
  Edit7.Text:=''; Edit8.Text:=''; Edit9.Text:='';
End;

//===================== PINTAR DATOS SUB RUTAS =======================
Procedure TFRutas.Relleno1();
Begin
  if dbSubRuta.RecordCount=0 then exit;
  Edit3.Text:=dbSubRuta.FieldByName('SRUT1').AsString;//-------------- Codigo
  Edit4.Text:=dbSubRuta.FieldByName('SRUT2').AsString;//-------------- Nombre
  Edit5.Text:=dbSubRuta.FieldByName('SRUT3').AsString;//------------- Calle
  Edit6.Text:=dbSubRuta.FieldByName('SRUT4').AsString;//------------- Localidad
  Edit7.Text:=dbSubRuta.FieldByName('SRUT5').AsString;//------------- C. Postal
  Edit8.Text:=dbSubRuta.FieldByName('SRUT6').AsString;//------------- Provincia
  Edit9.Text:=dbSubRuta.FieldByName('SRUT7').AsString;//------------- Pais
End;

//===================== RELLENAR DATOS SUB RUTAS =======================
Procedure TFRutas.LlenaReg1();
Begin
  dbSubRuta.FieldByName('SRUT0').Value:=dbRuta.FieldByName('RUT0').Value;//---- Cgo. Ruta
  dbSubRuta.FieldByName('SRUT1').AsString:=Edit3.Text;//------------- Codigo sub ruta
  dbSubRuta.FieldByName('SRUT2').AsString:=Edit4.Text;//------------- Nombre
  dbSubRuta.FieldByName('SRUT3').AsString:=Edit5.Text;//------------- Calle
  dbSubRuta.FieldByName('SRUT4').AsString:=Edit6.Text;//------------- Localidad
  dbSubRuta.FieldByName('SRUT5').AsString:=Edit7.Text;//------------- C. Postal
  dbSubRuta.FieldByName('SRUT6').AsString:=Edit8.Text;//------------- Provincia
  dbSubRuta.FieldByName('SRUT7').AsString:=Edit9.Text;//------------- Pais
End;

//======================= REFRESCAR GRID SUB RUTAS ========================
Procedure TFRutas.RefrescaSubRuta1();
Var
  TxtTemp: String;
Begin
  TxtTemp:=dbSubRuta1.SQL.Text;
  dbSubRuta1.Active:=False;
  dbSubRuta1.SQL.Text:=TxtTemp;
  dbSubRuta1.Active:=True;
End;

Initialization
  {$I rutas.lrs}

End.

