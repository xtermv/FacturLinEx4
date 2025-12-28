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

Unit Fabricantes;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType, DBGrids,
  TAGraph, TASeries, db, DbCtrls;

Type

  { TFFabricantes }

  TFFabricantes = Class(Tform)
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    Datasource1: TDatasource;
    dbFormaPa: TZQuery;
    dbRoles: TZQuery;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: Tpanel;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    Bitbtn4: Tbitbtn;
    Bitbtn1: Tbitbtn;
    Panel2: TPanel;
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    Procedure Formcreate(Sender: Tobject);
    Procedure Edit1enter(Sender: Tobject);
    Procedure Edit1exit(Sender: Tobject);
    Procedure LimpiaForm();
    Procedure Relleno();
    Procedure LlenaReg();
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

  procedure ShowFormFabricantes;
  
Var
  FFabricantes: TFFabricantes;
  CargaGrafica: Integer;
  s: TBarSeries;

Implementation

Uses
  Global, funciones;
  
//=============== Crea el formulario ================
procedure ShowFormFabricantes;
begin
  with TFFabricantes.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFFabricantes.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);    // Utilizamos datamodule1.dbConexión para toda la aplicación.

  //------------------- Tablas ------------------
  dbFormaPa.Sql.Text:='SELECT * FROM autofabri ORDER BY AUT0';
  dbFormaPa.Active := True;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Fabrica', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Fabrica', 3);//------------------ Boton Borrar
 end;


//==================== CERRAR ======================
Procedure TFFabricantes.Bitbtn1click(Sender: Tobject);
Begin
  dbFormaPa.Active:=False;
  Close();
End;
Procedure TFFabricantes.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//=================== REGISTRO NUEVO ===================
Procedure TFFabricantes.Bitbtn2click(Sender: Tobject);
Begin
  Panel2.Visible:=True;
  DBGrid1.Enabled:=False; Panel1.Enabled:=False;
  Edit1.Text:=''; LimpiaForm();
  Edit1.Enabled:=True; Edit1.SetFocus;
End;
//=================== BORRAR REGISTRO ===================
Procedure TFFabricantes.Bitbtn3click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if not dbFormaPa.Locate('AUT0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbFormaPa.Delete;
End;

//=================== MODIFICAR ===================
Procedure TFFabricantes.Bitbtn4click(Sender: Tobject);
Begin
  Panel2.Visible:=True;
  DBGrid1.Enabled:=False; Panel1.Enabled:=False;
  LimpiaForm(); Relleno();
  Edit1.Enabled:=False; Edit2.SetFocus;
End;

//=================== CODIGO DE LA FP ================
Procedure TFFabricantes.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := ''; LimpiaForm();
End;
Procedure TFFabricantes.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbFormaPa.Locate('AUT0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;

//=============== ACEPTAR MODIFCAR / CREAR ================
procedure TFFabricantes.BitBtn7Click(Sender: TObject);
begin
  //------------- Crear o Modificar Registros --------
  if Edit1.Enabled=true then
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if dbFormaPa.Locate('AUT0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO YA EXISTE'); exit; end;
     dbFormaPa.Append;
    end
  else
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if not dbFormaPa.Locate('AUT0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO'); exit; end;
     dbFormaPa.Edit;
    end;
  LlenaReg();//---- Rellenar datos
  dbFormaPa.Post;
  BitBtn8Click(BitBtn8);//--- Cerrar Panel
end;

//================= CERRAR CREAR / MODIFICAR ==============
procedure TFFabricantes.BitBtn8Click(Sender: TObject);
begin
  Panel2.Visible:=False; Edit1.Enabled:=True;
  DBGrid1.Enabled:=True; Panel1.Enabled:=True;
end;

//===================== LIMPIAR DATOS =======================
Procedure TFFabricantes.LimpiaForm();
Begin
  Edit2.Text:='';
End;

//===================== PINTAR DATOS =======================
Procedure TFFabricantes.Relleno();
Begin
  if dbFormaPa.RecordCount=0 then exit;
  Edit1.Text:=dbFormaPa.FieldByName('AUT0').AsString;//-------------- Cgo. forma pago
  Edit2.Text:=dbFormaPa.FieldByName('AUT1').AsString;//-------------- Nombre
End;

//===================== RELLENAR DATOS =======================
Procedure TFFabricantes.LlenaReg();
Begin
  dbFormaPa.FieldByName('AUT0').AsString:=Edit1.Text;//------------- Codigo
  dbFormaPa.FieldByName('AUT1').AsString:=Edit2.Text;//------------- Nombre
End;

Initialization
  {$I fabricantes.lrs}

End.

