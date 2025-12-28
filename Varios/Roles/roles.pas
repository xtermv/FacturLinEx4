{
  Gestion LinEx FacturLinEx 2.0

  Copyright (C) 2000-2010,  Nicolas Lopez de Lerma Aymerich

  PuntoDev <info@puntodev.com>

  Collaborators:
                 Antonio Domínguez Santos (adslinex)
                 Xaime Alvarez Ares
                 Elmo Calatayud Chumbes
                 Fco. Javier Perez Vidal
                 José Belenguer
                 Eduardo Maldonado

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

unit roles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, ZConnection, ZDataset, LCLType;

type

  { TFRoles }

  TFRoles = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    CheckGroup1: TCheckGroup;
    CheckGroup10: TCheckGroup;
    CheckGroup11: TCheckGroup;
    CheckGroup12: TCheckGroup;
    CheckGroup13: TCheckGroup;
    CheckGroup2: TCheckGroup;
    CheckGroup3: TCheckGroup;
    CheckGroup4: TCheckGroup;
    CheckGroup5: TCheckGroup;
    CheckGroup6: TCheckGroup;
    CheckGroup7: TCheckGroup;
    CheckGroup8: TCheckGroup;
    CheckGroup9: TCheckGroup;
    dbRoles: TZQuery;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    BtnR6: TToggleBox;
    BtnR7: TToggleBox;
    BtnR8: TToggleBox;
    BtnR9: TToggleBox;
    BtnR10: TToggleBox;
    BtnR11: TToggleBox;
    BtnR12: TToggleBox;
    BtnR13: TToggleBox;
    BtnR1: TToggleBox;
    BtnR2: TToggleBox;
    BtnR3: TToggleBox;
    BtnR4: TToggleBox;
    BtnR5: TToggleBox;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BtnR10Change(Sender: TObject);
    procedure BtnR11Change(Sender: TObject);
    procedure BtnR12Change(Sender: TObject);
    procedure BtnR13Change(Sender: TObject);
    procedure BtnR1Change(Sender: TObject);
    procedure BtnR2Change(Sender: TObject);
    procedure BtnR3Change(Sender: TObject);
    procedure BtnR4Change(Sender: TObject);
    procedure BtnR5Change(Sender: TObject);
    procedure BtnR6Change(Sender: TObject);
    procedure BtnR7Change(Sender: TObject);
    procedure BtnR8Change(Sender: TObject);
    procedure BtnR9Change(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Llenareg();
    procedure Relleno();
    procedure LimpiaForm();

  private
    { private declarations }
  public
    { public declarations }
  end; 

 procedure ShowFormRoles;

var
  FRoles: TFRoles;
  conta: Integer;

implementation
{ TFRoles }

uses
  Global, Funciones;

//====================== CREAR EL FORMULARIO ======================
procedure ShowFormRoles;
begin
  with TFRoles.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFRoles.FormCreate(Sender: TObject);
begin
  //--------- Conectar con la bbdd
  //Conectate(dbConnect);       // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //--------- Pedidos
  dbRoles.SQL.Text:='SELECT * FROM roles'+Tienda+' ORDER BY CgoRol ASC';
  dbRoles.Active:=True;
end;

//================= CERRAR EL FORMULARIO ==========================
procedure TFRoles.BitBtn1Click(Sender: TObject);
begin
  Close();
end;
procedure TFRoles.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//======================== CREAR REGISTRO ==========================
procedure TFRoles.BitBtn2Click(Sender: TObject);
begin
  if (Edit1.Text='') or (Edit2.Text='') then exit;
  if dbRoles.Locate('CgoRol',Edit1.Text,[]) then
    begin showmessage('ESTE REGISTRO YA EXISTE NO PUEDE CREARLO DE NUEVO'); exit; end;
  dbRoles.Append;
  Llenareg();
  dbRoles.Post;
  Relleno();
end;

//======================== BORRAR REGISTRO ==========================
procedure TFRoles.BitBtn3Click(Sender: TObject);
begin
  if Edit1.Text='' then exit;
  if not dbRoles.Locate('CgoRol',Edit1.Text,[]) then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbRoles.Delete;
  Edit1.Text := '';
  LimpiaForm();
end;

//======================== MODIFICAR REGISTRO ==========================
procedure TFRoles.BitBtn4Click(Sender: TObject);
begin
  if (Edit1.Text='') or (Edit2.Text='') then exit;
  if not dbRoles.Locate('CgoRol',Edit1.Text,[]) then
    begin showmessage('ESTE REGISTRO NO EXISTE NO PUEDE MODIFICARLO'); exit; end;
  dbRoles.Edit;
  Llenareg();
  dbRoles.Post;
  Relleno();
end;

//================================= ANTERIOR ========================
procedure TFRoles.BitBtn5Click(Sender: TObject);
begin
  dbRoles.Prior;
  LimpiaForm(); Relleno();
end;

//================================= POSTERIOR ========================
procedure TFRoles.BitBtn6Click(Sender: TObject);
begin
  dbRoles.Next;
  LimpiaForm(); Relleno();
end;

//=========================== SALIR DEL CGO ROL =======================
procedure TFRoles.Edit1Enter(Sender: TObject);
begin
  LimpiaForm();
end;
procedure TFRoles.Edit1Exit(Sender: TObject);
begin
  if Edit1.Text='' then exit;
  if dbRoles.Locate('CgoRol',Edit1.Text,[]) then Relleno();

end;

//======================== ASIGNAR DATOS A EDIT ===================
procedure TFRoles.Relleno();
Var
  Conta: Integer;
  Txt:String;
begin
  Edit1.Text:=dbRoles.FieldByName('CgoRol').AsString;//------------- Cgo. Rol
  Edit2.Text:=dbRoles.FieldByName('DescriRol').AsString;//---------- Descripcion
  Label16.Caption:=Edit2.Text;
  for Conta:=1 to CheckGroup1.Items.Count do
   if copy(dbRoles.FieldByName('Tiendas').AsString,Conta,1)='1' then CheckGroup1.Checked[Conta-1]:=True else CheckGroup1.Checked[Conta-1]:=False;
  //-------------------
  for Conta:=1 to CheckGroup2.Items.Count do
   if copy(dbRoles.FieldByName('Usuarios').AsString,Conta,1)='1' then CheckGroup2.Checked[Conta-1]:=True else CheckGroup2.Checked[Conta-1]:=False;
  //-------------------
  for Conta:=1 to CheckGroup3.Items.Count do
   if copy(dbRoles.FieldByName('Departa').AsString,Conta,1)='1' then CheckGroup3.Checked[Conta-1]:=True else CheckGroup3.Checked[Conta-1]:=False;
  //-------------------
  for Conta:=1 to CheckGroup4.Items.Count do
   if copy(dbRoles.FieldByName('Familias').AsString,Conta,1)='1' then CheckGroup4.Checked[Conta-1]:=True else CheckGroup4.Checked[Conta-1]:=False;
  //-------------------
  for Conta:=1 to CheckGroup5.Items.Count do
   if copy(dbRoles.FieldByName('Articulos').AsString,Conta,1)='1' then CheckGroup5.Checked[Conta-1]:=True else CheckGroup5.Checked[Conta-1]:=False;
  //-------------------
  for Conta:=1 to CheckGroup6.Items.Count do
   if copy(dbRoles.FieldByName('Clientes').AsString,Conta,1)='1' then CheckGroup6.Checked[Conta-1]:=True else CheckGroup6.Checked[Conta-1]:=False;
  //-------------------
  for Conta:=1 to CheckGroup7.Items.Count do
   if copy(dbRoles.FieldByName('Proveed').AsString,Conta,1)='1' then CheckGroup7.Checked[Conta-1]:=True else CheckGroup7.Checked[Conta-1]:=False;
  //-------------------
  for Conta:=1 to CheckGroup8.Items.Count do
   if copy(dbRoles.FieldByName('Formapag').AsString,Conta,1)='1' then CheckGroup8.Checked[Conta-1]:=True else CheckGroup8.Checked[Conta-1]:=False;
  //-------------------
  for Conta:=1 to CheckGroup9.Items.Count do
   if copy(dbRoles.FieldByName('Rutas').AsString,Conta,1)='1' then CheckGroup9.Checked[Conta-1]:=True else CheckGroup9.Checked[Conta-1]:=False;
  //-------------------
  for Conta:=1 to CheckGroup10.Items.Count do
   if copy(dbRoles.FieldByName('Fabrica').AsString,Conta,1)='1' then CheckGroup10.Checked[Conta-1]:=True else CheckGroup10.Checked[Conta-1]:=False;
  //-------------------
  for Conta:=1 to CheckGroup11.Items.Count do
   if copy(dbRoles.FieldByName('Envases').AsString,Conta,1)='1' then CheckGroup11.Checked[Conta-1]:=True else CheckGroup11.Checked[Conta-1]:=False;
  //-------------------
  for Conta:=1 to CheckGroup12.Items.Count do
   if copy(dbRoles.FieldByName('Puestos').AsString,Conta,1)='1' then CheckGroup12.Checked[Conta-1]:=True else CheckGroup12.Checked[Conta-1]:=False;
  //-------------------
  for Conta:=1 to CheckGroup13.Items.Count do
   if copy(dbRoles.FieldByName('Produccion').AsString,Conta,1)='1' then CheckGroup13.Checked[Conta-1]:=True else CheckGroup13.Checked[Conta-1]:=False;
  //-------------------
end;

//======================== ASIGNAR DATOS A REGISTRO ===================
procedure TFRoles.Llenareg();
Var
  Conta: Integer;
  Txt:String;
begin
  dbRoles.FieldByName('CgoRol').AsString:=Edit1.Text;//------------- Cgo. Rol
  dbRoles.FieldByName('DescriRol').AsString:=Edit2.Text;//---------- Descripcion
  Txt:=''; for Conta:=0 to CheckGroup1.Items.Count-1 do if CheckGroup1.Checked[Conta]=True then Txt:=Txt+'1' else Txt:=Txt+'0';
  dbRoles.FieldByName('Tiendas').AsString:=Txt;//----------------- Tienda
  Txt:=''; for Conta:=0 to CheckGroup2.Items.Count-1 do if CheckGroup2.Checked[Conta]=True then Txt:=Txt+'1' else Txt:=Txt+'0';
  dbRoles.FieldByName('Usuarios').AsString:=Txt;//---------------- Usuarios
  Txt:=''; for Conta:=0 to CheckGroup3.Items.Count-1 do if CheckGroup3.Checked[Conta]=True then Txt:=Txt+'1' else Txt:=Txt+'0';
  dbRoles.FieldByName('Departa').AsString:=Txt;//----------------- Departamentos
  Txt:=''; for Conta:=0 to CheckGroup4.Items.Count-1 do if CheckGroup4.Checked[Conta]=True then Txt:=Txt+'1' else Txt:=Txt+'0';
  dbRoles.FieldByName('Familias').AsString:=Txt;//---------------- Familias
  Txt:=''; for Conta:=0 to CheckGroup5.Items.Count-1 do if CheckGroup5.Checked[Conta]=True then Txt:=Txt+'1' else Txt:=Txt+'0';
  dbRoles.FieldByName('Articulos').AsString:=Txt;//---------------- Articulos
  Txt:=''; for Conta:=0 to CheckGroup6.Items.Count-1 do if CheckGroup6.Checked[Conta]=True then Txt:=Txt+'1' else Txt:=Txt+'0';
  dbRoles.FieldByName('Clientes').AsString:=Txt;//---------------- Clientes
  Txt:=''; for Conta:=0 to CheckGroup7.Items.Count-1 do if CheckGroup7.Checked[Conta]=True then Txt:=Txt+'1' else Txt:=Txt+'0';
  dbRoles.FieldByName('Proveed').AsString:=Txt;//----------------- Proveedores
  Txt:=''; for Conta:=0 to CheckGroup8.Items.Count-1 do if CheckGroup8.Checked[Conta]=True then Txt:=Txt+'1' else Txt:=Txt+'0';
  dbRoles.FieldByName('Formapag').AsString:=Txt;//---------------- Formas de pagos y cobros
  Txt:=''; for Conta:=0 to CheckGroup9.Items.Count-1 do if CheckGroup9.Checked[Conta]=True then Txt:=Txt+'1' else Txt:=Txt+'0';
  dbRoles.FieldByName('Rutas').AsString:=Txt;//------------------- Rutas
  Txt:=''; for Conta:=0 to CheckGroup10.Items.Count-1 do if CheckGroup10.Checked[Conta]=True then Txt:=Txt+'1' else Txt:=Txt+'0';
  dbRoles.FieldByName('Fabrica').AsString:=Txt;//----------------- Fabricantes
  Txt:=''; for Conta:=0 to CheckGroup11.Items.Count-1 do if CheckGroup11.Checked[Conta]=True then Txt:=Txt+'1' else Txt:=Txt+'0';
  dbRoles.FieldByName('Envases').AsString:=Txt;//----------------- Envases
  Txt:=''; for Conta:=0 to CheckGroup12.Items.Count-1 do if CheckGroup12.Checked[Conta]=True then Txt:=Txt+'1' else Txt:=Txt+'0';
  dbRoles.FieldByName('Puestos').AsString:=Txt;//----------------- Puestos
  Txt:=''; for Conta:=0 to CheckGroup13.Items.Count-1 do if CheckGroup13.Checked[Conta]=True then Txt:=Txt+'1' else Txt:=Txt+'0';
  dbRoles.FieldByName('Produccion').AsString:=Txt;//---------------- Produccion
end;

//======================== ASIGNAR DATOS A EDIT ===================
procedure TFRoles.LimpiaForm();
Var
  Conta: Integer;
begin
  Edit1.Text:=''; Edit2.Text:=''; Label16.Caption:='';
  for Conta:=0 to CheckGroup1.Items.Count-1 do CheckGroup1.Checked[Conta]:=False;
  for Conta:=0 to CheckGroup2.Items.Count-1 do CheckGroup2.Checked[Conta]:=False;
  for Conta:=0 to CheckGroup3.Items.Count-1 do CheckGroup3.Checked[Conta]:=False;
  for Conta:=0 to CheckGroup4.Items.Count-1 do CheckGroup4.Checked[Conta]:=False;
  for Conta:=0 to CheckGroup5.Items.Count-1 do CheckGroup5.Checked[Conta]:=False;
  for Conta:=0 to CheckGroup6.Items.Count-1 do CheckGroup6.Checked[Conta]:=False;
  for Conta:=0 to CheckGroup7.Items.Count-1 do CheckGroup7.Checked[Conta]:=False;
  for Conta:=0 to CheckGroup8.Items.Count-1 do CheckGroup8.Checked[Conta]:=False;
  for Conta:=0 to CheckGroup9.Items.Count-1 do CheckGroup9.Checked[Conta]:=False;
  for Conta:=0 to CheckGroup10.Items.Count-1 do CheckGroup10.Checked[Conta]:=False;
  for Conta:=0 to CheckGroup11.Items.Count-1 do CheckGroup11.Checked[Conta]:=False;
  for Conta:=0 to CheckGroup12.Items.Count-1 do CheckGroup12.Checked[Conta]:=False;
  for Conta:=0 to CheckGroup13.Items.Count-1 do CheckGroup13.Checked[Conta]:=False;
end;

//================= MARCAR / DESMARCAR FICHAS ==========================
procedure TFRoles.BtnR1Change(Sender: TObject);
begin
  if BtnR1.Checked=True then
     for conta:=0 to CheckGroup1.Items.Count-1 do CheckGroup1.Checked[conta]:=True
  else
     for conta:=0 to CheckGroup1.Items.Count-1 do CheckGroup1.Checked[conta]:=False;
end;
procedure TFRoles.BtnR2Change(Sender: TObject);
begin
  if BtnR2.Checked=True then
     for conta:=0 to CheckGroup2.Items.Count-1 do CheckGroup2.Checked[conta]:=True
  else
     for conta:=0 to CheckGroup2.Items.Count-1 do CheckGroup2.Checked[conta]:=False;
end;
procedure TFRoles.BtnR3Change(Sender: TObject);
begin
  if BtnR3.Checked=True then
     for conta:=0 to CheckGroup3.Items.Count-1 do CheckGroup3.Checked[conta]:=True
  else
     for conta:=0 to CheckGroup3.Items.Count-1 do CheckGroup3.Checked[conta]:=False;
end;
procedure TFRoles.BtnR4Change(Sender: TObject);
begin
  if BtnR4.Checked=True then
     for conta:=0 to CheckGroup4.Items.Count-1 do CheckGroup4.Checked[conta]:=True
  else
     for conta:=0 to CheckGroup4.Items.Count-1 do CheckGroup4.Checked[conta]:=False;
end;
procedure TFRoles.BtnR5Change(Sender: TObject);
begin
  if BtnR5.Checked=True then
     for conta:=0 to CheckGroup5.Items.Count-1 do CheckGroup5.Checked[conta]:=True
  else
     for conta:=0 to CheckGroup5.Items.Count-1 do CheckGroup5.Checked[conta]:=False;
end;
procedure TFRoles.BtnR6Change(Sender: TObject);
begin
  if BtnR6.Checked=True then
     for conta:=0 to CheckGroup6.Items.Count-1 do CheckGroup6.Checked[conta]:=True
  else
     for conta:=0 to CheckGroup6.Items.Count-1 do CheckGroup6.Checked[conta]:=False;
end;
procedure TFRoles.BtnR7Change(Sender: TObject);
begin
  if BtnR7.Checked=True then
     for conta:=0 to CheckGroup7.Items.Count-1 do CheckGroup7.Checked[conta]:=True
  else
     for conta:=0 to CheckGroup7.Items.Count-1 do CheckGroup7.Checked[conta]:=False;
end;
procedure TFRoles.BtnR8Change(Sender: TObject);
begin
  if BtnR8.Checked=True then
     for conta:=0 to CheckGroup8.Items.Count-1 do CheckGroup8.Checked[conta]:=True
  else
     for conta:=0 to CheckGroup8.Items.Count-1 do CheckGroup8.Checked[conta]:=False;
end;
procedure TFRoles.BtnR9Change(Sender: TObject);
begin
  if BtnR9.Checked=True then
     for conta:=0 to CheckGroup9.Items.Count-1 do CheckGroup9.Checked[conta]:=True
  else
     for conta:=0 to CheckGroup9.Items.Count-1 do CheckGroup9.Checked[conta]:=False;
end;
procedure TFRoles.BtnR10Change(Sender: TObject);
begin
  if BtnR10.Checked=True then
     for conta:=0 to CheckGroup10.Items.Count-1 do CheckGroup10.Checked[conta]:=True
  else
     for conta:=0 to CheckGroup10.Items.Count-1 do CheckGroup10.Checked[conta]:=False;
end;
procedure TFRoles.BtnR11Change(Sender: TObject);
begin
  if BtnR11.Checked=True then
     for conta:=0 to CheckGroup11.Items.Count-1 do CheckGroup11.Checked[conta]:=True
  else
     for conta:=0 to CheckGroup11.Items.Count-1 do CheckGroup11.Checked[conta]:=False;
end;
procedure TFRoles.BtnR12Change(Sender: TObject);
begin
  if BtnR12.Checked=True then
     for conta:=0 to CheckGroup12.Items.Count-1 do CheckGroup12.Checked[conta]:=True
  else
     for conta:=0 to CheckGroup12.Items.Count-1 do CheckGroup12.Checked[conta]:=False;
end;
procedure TFRoles.BtnR13Change(Sender: TObject);
begin
  if BtnR13.Checked=True then
     for conta:=0 to CheckGroup13.Items.Count-1 do CheckGroup13.Checked[conta]:=True
  else
     for conta:=0 to CheckGroup13.Items.Count-1 do CheckGroup13.Checked[conta]:=False;
end;


initialization
  {$I roles.lrs}

end.

