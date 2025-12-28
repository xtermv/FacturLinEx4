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

unit Envases;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  LCLType, DBGrids, db, ZConnection, ZDataset, Buttons, ExtCtrls, StdCtrls;

type

  { TFEnvases }

  TFEnvases = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Datasource1: TDatasource;
    dbProve: TZQuery;
    DBGrid1: TDBGrid;
    dbRoles: TZQuery;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
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
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    dbEnvases: TZQuery;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure Edit14Enter(Sender: TObject);
    procedure Edit14Exit(Sender: TObject);
    procedure Edit16Exit(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit6Exit(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure PintaDatos();
    procedure LimpiaDatos();
    procedure Relleno();

  private
    { private declarations }
  public
    { public declarations }
  end;

  procedure ShowFormEnvases;

var
  FEnvases: TFEnvases;

implementation

uses
  Global, funciones;
  
{ TFEnvases }

//=============== CREAR EL FORMULARIO ================
procedure ShowFormEnvases;
begin
  with TFEnvases.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFEnvases.FormCreate(Sender: TObject);
begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.

  //------------------- Tablas ------------------
  dbEnvases.Sql.Text:='SELECT * FROM envas ORDER BY EN0';
  dbEnvases.Active := True;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Envases', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Envases', 3);//------------------ Boton Borrar
end;

//====================== CERRAR FORMULARIO =======================
procedure TFEnvases.BitBtn1Click(Sender: TObject);
begin
   Close();
end;
procedure TFEnvases.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//================== CREAR NUEVA SERIE ============
procedure TFEnvases.BitBtn2Click(Sender: TObject);
begin
  Panel1.Visible:=True;
  DBGrid1.Enabled:=False; Panel2.Enabled:=False;
  Edit1.Text:=''; LimpiaDatos();
  Edit1.Enabled:=True; Edit1.SetFocus;
end;

//================ BORRAR Envases ====================
procedure TFEnvases.BitBtn3Click(Sender: TObject);
begin
  if (dbEnvases.RecordCount=0) or (dbEnvases.EOF) then
    begin
      ShowMessage('ESA SERIE NO EXISTE, NO PUEDE BORRARLA');
      exit;
    end;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('CONFIRME EL BORRADO DE LA SERIE','FacturLinEx', boxstyle) = IDNO Then
    Exit;
  dbEnvases.Delete;
end;

//================= MODIFICAR SERIE =====================
procedure TFEnvases.DBGrid1DblClick(Sender: TObject);
begin
  Panel1.Visible:=True;
  DBGrid1.Enabled:=False; Panel2.Enabled:=False;
  LimpiaDatos(); PintaDatos();
  Edit1.Enabled:=False; Edit2.SetFocus;
end;

//================ CODIGO DE LA SERIE ===================
procedure TFEnvases.Edit1Exit(Sender: TObject);
begin
  if Edit1.Text='' then begin Edit1.SetFocus; exit; end;
  if dbEnvases.Locate('EN0',Edit1.Text,[]) then
    begin
      PintaDatos();
      ShowMessage('ESA SERIE YA EXISTE');
      LimpiaDatos(); Edit1.Text:=''; Edit1.SetFocus;
      exit;
    end
end;

//=============== ACEPTAR MODIFCAR / CREAR ================
procedure TFEnvases.BitBtn5Click(Sender: TObject);
begin
  //------------- Crear o Modificar Registros --------
  if Edit1.Enabled=true then
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if dbEnvases.Locate('EN0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO YA EXISTE'); exit; end;
     dbEnvases.Append;
    end
  else
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if not dbEnvases.Locate('EN0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO'); exit; end;
     dbEnvases.Edit;
    end;
  Relleno();//---- Rellenar datos
  dbEnvases.Post;
  BitBtn6Click(BitBtn6);//--- Cerrar Panel
end;

//================= CERRAR CREAR / MODIFICAR ==============
procedure TFEnvases.BitBtn6Click(Sender: TObject);
begin
  Panel1.Visible:=False; Edit1.Enabled:=True;
  DBGrid1.Enabled:=True; Panel2.Enabled:=True;
end;

//================ PINTAR DATOS EN EL PANEL =============
procedure TFEnvases.PintaDatos();
begin
  Edit1.Text:=dbEnvases.FieldByName('EN0').AsString;//------ Codigo
  Edit2.Text:=dbEnvases.FieldByName('EN1').AsString;//------ Nombre
  Edit3.Text:=dbEnvases.FieldByName('EN2').AsString;//------ Costo
  Edit4.Text:=dbEnvases.FieldByName('EN3').AsString;//------ Margen
  Edit5.Text:=dbEnvases.FieldByName('EN4').AsString;//------ Precio
  Edit6.Text:=dbEnvases.FieldByName('EN5').AsString;//------ Iva
  Edit7.Text:=dbEnvases.FieldByName('EN6').AsString;//------ P.V.P.
  Edit8.Text:=dbEnvases.FieldByName('EN7').AsString;//------ Stock
  Edit9.Text:=dbEnvases.FieldByName('EN8').AsString;//------ Stock Minimo
  Edit10.Text:=dbEnvases.FieldByName('EN9').AsString;//----- Stock Maximo
  Edit11.Text:=dbEnvases.FieldByName('EN10').AsString;//---- Und./ Art.
  Edit12.Text:=dbEnvases.FieldByName('EN11').AsString;//---- F. Ult. Compra
  Edit13.Text:=dbEnvases.FieldByName('EN12').AsString;//---- F. Ult. Venta
  Edit14.Text:=dbEnvases.FieldByName('EN13').AsString;//---- Ult. Provedor
  Edit14Exit(Edit14);//------ Nombre del proveedor


end;

//================ GUARDAR DATOS =============
procedure TFEnvases.Relleno();
begin
  dbEnvases.FieldByName('EN0').AsString:=Edit1.Text;//---- Codigo
  dbEnvases.FieldByName('EN1').AsString:=Edit2.Text;//---- Nombre
  dbEnvases.FieldByName('EN2').AsString:=Edit3.Text;//---- Costo
  dbEnvases.FieldByName('EN3').AsString:=Edit4.Text;//---- Margen
  dbEnvases.FieldByName('EN4').AsString:=Edit5.Text;//---- Precio
  dbEnvases.FieldByName('EN5').AsString:=Edit6.Text;//---- IVA
  dbEnvases.FieldByName('EN6').AsString:=Edit7.Text;//---- P.V.P.
  dbEnvases.FieldByName('EN7').AsString:=Edit8.Text;//---- Stock
  dbEnvases.FieldByName('EN8').AsString:=Edit9.Text;//---- Stock Minimo
  dbEnvases.FieldByName('EN9').AsString:=Edit10.Text;//---- Stock Maximo
  dbEnvases.FieldByName('EN10').AsString:=Edit11.Text;//--- Und. / Art.
  //--- F. Ult. Compra
  if Edit12.Text='' then
    dbEnvases.FieldByName('EN11').Value:=Null
  else
    dbEnvases.FieldByName('EN11').AsString:=Edit12.Text;
  //--- F. Ult. Venta
  if Edit13.Text='' then
    dbEnvases.FieldByName('EN12').Value:=Null
  else
    dbEnvases.FieldByName('EN12').AsString:=Edit13.Text;
  dbEnvases.FieldByName('EN13').AsString:=Edit14.Text;//--- Ultimo Proveedor


end;

//================ LIMPIAR DATOS DEL PANEL =============
procedure TFEnvases.LimpiaDatos();
begin
  Edit2.Text:='';
  Edit3.Text:='0'; Edit4.Text:='0'; Edit5.Text:='0';
  Edit6.Text:='0'; Edit7.Text:='0'; Edit8.Text:='0';
  Edit9.Text:='0'; Edit10.Text:='0'; Edit11.Text:='0';
  Edit12.Text:=''; Edit13.Text:=''; Edit14.Text:='';
  Edit15.Text:=''; Edit16.Text:='0';
end;

//================= SALIR DEL COSTO ====================
procedure TFEnvases.Edit3Exit(Sender: TObject);
Var
  Precio, PrecioCon : Double;
begin
  if (Edit3.Text='0') or (Edit3.Text='') then exit;
  if (Edit4.Text='0') or (Edit4.Text='') then exit;
  Precio:=(StrToFloat(Edit3.text)*StrToFloat(Edit4.text)/100)+StrToFloat(Edit3.text);// ---- Añadir Margen
  PrecioCon:=Precio;
  Edit5.Text := FormatFloat('0.000',PrecioCon);
end;

//================ SALIR DEL MARGEN ===================
procedure TFEnvases.Edit4Exit(Sender: TObject);
Var
  Precio, PrecioCon : Double;
begin
  if (Edit3.Text='0') or (Edit3.Text='') then exit;
  if (Edit4.Text='0') or (Edit4.Text='') then exit;
  Precio:=(StrToFloat(Edit3.text)*StrToFloat(Edit4.text)/100)+StrToFloat(Edit3.text);
  PrecioCon:=Precio;
  Edit5.Text := FormatFloat('0.000',PrecioCon);
end;

//============ SALIR DEL PRECIO SIN IVA ================
procedure TFEnvases.Edit5Exit(Sender: TObject);
var
  PvpSinIva, Margen, CostoCero, PrecioCon, Recargo: double;
begin
  if (Edit5.Text='') or (Edit5.Text='0') then exit;
  if (Edit3.Text <> '') and (Edit3.Text <> '0') then
    begin
      PvpSinIva := StrToFloat(Edit5.text);
      Margen := (PvpSinIva - StrToFloat(Edit3.Text)) * 100 / StrToFloat(Edit3.Text);
      Edit4.Text := FormatFloat('0.000',Margen);
    end
  else
    begin
      //------- Calcular costo cuando es 0
      if (Edit4.Text<>'') and (Edit4.Text<>'0') then
       begin
        CostoCero := (100 * StrToFloat(Edit5.text)) / (100 + StrToFloat(Edit4.Text));
        Edit3.Text:=FormatFloat('0.000',CostoCero); Edit3Exit(Edit3);
       end;
    end;
   //------ Calcular precio con iva si hay iva
   if (Edit6.Text<>'0') and (Edit6.Text<>'') then
     begin
       //PrecioCon:=(StrToFloat(Edit5.Text) * StrToFloat(Edit6.Text) / 100) +
       //            StrToFloat(Edit5.Text); //--- Sumar el IVA
       //Edit7.Text:=FormatFloat('0.00',PrecioCon);
       Recargo:=0;
       PrecioCon:=(StrToFloat(Edit5.Text)*StrToFloat(Edit4.Text)/100)+StrToFloat(Edit5.Text);//-- + Margen
       if Edit16.Text<>'0' then Recargo:=(PrecioCon*StrToFloat(Edit16.Text) / 100);//---- + Recargo
       Edit7.Text:=FormatFloat('0.00',((PrecioCon*StrToFloat(Edit6.Text) / 100)+PrecioCon)+Recargo);//---- + IVA
     end;
end;

//=================== SALIR DEL IVA ====================
procedure TFEnvases.Edit6Exit(Sender: TObject);
var
   PrecioCon, Recargo: Double;
begin
   //PrecioCon:=(StrToFloat(Edit5.Text) * StrToFloat(Edit6.Text) / 100) + StrToFloat(Edit5.Text); //--- Sumar el IVA
   //Edit7.Text:=FormatFloat('0.00',PrecioCon);

  if VersiNumero(Edit6.text)=False then Edit6.Text:='0';
  if (Edit3.Text='') or (Edit3.Text='0') then begin Edit3.Text:='0'; Exit; end;//------ Costo
  if (Edit6.Text='') or (Edit6.Text='0') then begin Edit6.Text:='0'; Exit; end;//------ IVA
  if (Edit16.Text='') or (Edit16.Text='0') then Edit16.Text:='0'; //------------------- REC.
  //---- P.V.P.
  Recargo:=0;
  PrecioCon:=(StrToFloat(Edit3.Text)*StrToFloat(Edit4.Text)/100)+StrToFloat(Edit3.Text);//-- + Margen
  if Edit16.Text<>'0' then Recargo:=(PrecioCon*StrToFloat(Edit16.Text) / 100);//---- + Recargo
  Edit7.Text:=FormatFloat('0.00',((PrecioCon*StrToFloat(Edit6.Text) / 100)+PrecioCon)+Recargo);//---- + IVA
end;

//================= SALIR DEL RECARGO ====================
procedure TFEnvases.Edit16Exit(Sender: TObject);
var
   PrecioCon, Recargo: Double;
begin
  if VersiNumero(Edit16.text)=False then Edit16.Text:='0';
  if (Edit3.Text='') or (Edit3.Text='0') then begin Edit3.Text:='0'; Exit; end;//------ Costo
  if (Edit6.Text='') or (Edit6.Text='0') then begin Edit6.Text:='0'; Exit; end;//------ IVA
  if (Edit16.Text='') or (Edit16.Text='0') then Edit16.Text:='0'; //------------------- REC.
  //---- P.V.P.
  Recargo:=0;
  PrecioCon:=(StrToFloat(Edit3.Text)*StrToFloat(Edit4.Text)/100)+StrToFloat(Edit3.Text);//-- + Margen
  if Edit16.Text<>'0' then Recargo:=(PrecioCon*StrToFloat(Edit16.Text) / 100);//---- + Recargo
  Edit7.Text:=FormatFloat('0.00',((PrecioCon*StrToFloat(Edit6.Text) / 100)+PrecioCon)+Recargo);//---- + IVA
end;



//=================== SALIR DEL PVP ======================
procedure TFEnvases.Edit7Exit(Sender: TObject);
var
   PrecioSin, Recargo: Double;
begin
   if (Edit7.Text='') or (Edit7.Text='0') then exit;
   if (Edit6.Text='') or (Edit6.Text='0') then exit;
   PrecioSin := (100 * StrToFloat(Edit7.text)) / (100 + StrToFloat(Edit6.Text));
   Edit5.Text:=FormatFloat('0.000',PrecioSin); Edit5Exit(Edit5);
end;

//================= CGO PROVEEDOR ======================
procedure TFEnvases.Edit14Enter(Sender: TObject);
begin
  Edit15.Text:='';
end;
procedure TFEnvases.Edit14Exit(Sender: TObject);
begin
  if Edit14.Text='' then exit;
  dbProve.Active:=False;
  dbProve.SQL.Text:='SELECT P0,P1 FROM proveedores WHERE P0='+Edit14.Text;
  dbProve.Active:=True;
  if dbProve.RecordCount=0 then exit;
  Edit15.Text:=dbProve.FieldByName('P1').AsString;
end;


initialization
  {$I Envases.lrs}

end.

