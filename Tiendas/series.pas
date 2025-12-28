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

unit Series;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, LCLType,
  DBGrids, db, ZConnection, ZDataset, Buttons, ExtCtrls, StdCtrls;

type

  { TFSeries }

  TFSeries = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Datasource1: TDatasource;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    dbSeries: TZQuery;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
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

  procedure ShowFormSeries;

var
  FSeries: TFSeries;

implementation

uses
  Global, Funciones;
  
{ TFSeries }

//=============== Crea el formulario ================
procedure ShowFormSeries;
begin
  with TFSeries.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFSeries.FormCreate(Sender: TObject);
begin
   //--------- Conectar con la bbdd e inicializar datos globales
  //Conectate(dbConect);     // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbSeries.Sql.Text:='SELECT * FROM seriesfactu ORDER BY SF0';
  dbSeries.Active := True;
end;

//====================== CERRAR FORMULARIO =======================
procedure TFSeries.BitBtn1Click(Sender: TObject);
begin
   Close();
end;
procedure TFSeries.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//================== CREAR NUEVA SERIE ============
procedure TFSeries.BitBtn2Click(Sender: TObject);
begin
  Panel1.Visible:=True;
  DBGrid1.Enabled:=False; Panel2.Enabled:=False;
  Edit1.Text:=''; LimpiaDatos();
  Edit1.Enabled:=True; Edit1.SetFocus;
end;

//================ BORRAR SERIES ====================
procedure TFSeries.BitBtn3Click(Sender: TObject);
begin
  if (dbSeries.RecordCount=0) or (dbSeries.EOF) then
    begin
      ShowMessage('ESA SERIE NO EXISTE, NO PUEDE BORRARLA');
      exit;
    end;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('CONFIRME EL BORRADO DE LA SERIE','FacturLinEx', boxstyle) = IDNO Then
    Exit;
  dbSeries.Delete;
end;

//================= MODIFICAR SERIE =====================
procedure TFSeries.DBGrid1DblClick(Sender: TObject);
begin
  Panel1.Visible:=True;
  DBGrid1.Enabled:=False; Panel2.Enabled:=False;
  LimpiaDatos(); PintaDatos();
  Edit1.Enabled:=False; Edit2.SetFocus;
end;

//================ CODIGO DE LA SERIE ===================
procedure TFSeries.Edit1Exit(Sender: TObject);
begin
  if Edit1.Enabled=False then exit;
  if Edit1.Text='' then begin Edit1.SetFocus; exit; end;
  if dbSeries.Locate('SF0',Edit1.Text,[]) then
    begin
      PintaDatos();
      ShowMessage('ESA SERIE YA EXISTE');
      LimpiaDatos(); Edit1.Text:=''; Edit1.SetFocus;
      exit;
    end
end;

//=============== ACEPTAR MODIFCAR / CREAR ================
procedure TFSeries.BitBtn5Click(Sender: TObject);
begin
  //------------- Crear o Modificar Registros --------
  if Edit1.Enabled=true then
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if dbSeries.Locate('SF0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO YA EXISTE'); exit; end;
     dbSeries.Append;
    end
  else
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if not dbSeries.Locate('SF0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO'); exit; end;
     dbSeries.Edit;
    end;
  Relleno();//---- Rellenar datos
  dbSeries.Post;
  BitBtn6Click(BitBtn6);//--- Cerrar Panel
end;

//================= CERRAR CREAR / MODIFICAR ==============
procedure TFSeries.BitBtn6Click(Sender: TObject);
begin
  Panel1.Visible:=False; Edit1.Enabled:=True;
  DBGrid1.Enabled:=True; Panel2.Enabled:=True;
end;

//================ PINTAR DATOS EN EL PANEL =============
procedure TFSeries.PintaDatos();
begin
  Edit1.Text:=dbSeries.FieldByName('SF0').AsString;//---- Codigo
  Edit2.Text:=dbSeries.FieldByName('SF1').AsString;//---- Nombre
  Edit3.Text:=dbSeries.FieldByName('SF2').AsString;//---- N.Facturas
  Edit4.Text:=dbSeries.FieldByName('SF3').AsString;//---- N.Albaranes
  Edit5.Text:=dbSeries.FieldByName('SF4').AsString;//---- N.Tickets
  Edit6.Text:=dbSeries.FieldByName('SF6').AsString;//---- N.Presupuestos
  Edit7.Text:=dbSeries.FieldByName('SF7').AsString;//---- N.Pedidos
  Edit8.Text:=dbSeries.FieldByName('SF8').AsString;//---- N.Proformas
end;

//================ PINTAR DATOS EN EL PANEL =============
procedure TFSeries.Relleno();
begin
  dbSeries.FieldByName('SF0').AsString:=Edit1.Text;//---- Codigo
  dbSeries.FieldByName('SF1').AsString:=Edit2.Text;//---- Nombre
  dbSeries.FieldByName('SF2').AsString:=Edit3.Text;//---- N.Facturas
  dbSeries.FieldByName('SF3').AsString:=Edit4.Text;//---- N.Albaranes
  dbSeries.FieldByName('SF4').AsString:=Edit5.Text;//---- N.Tickets
  dbSeries.FieldByName('SF5').AsString:='N';//----------- Especial o Normal
  dbSeries.FieldByName('SF6').AsString:=Edit6.Text;//---- N.Presupuestos
  dbSeries.FieldByName('SF7').AsString:=Edit7.Text;//---- N.Pedidos
  dbSeries.FieldByName('SF8').AsString:=Edit8.Text;//---- N.Proformas
end;

//================ LIMPIAR DATOS DEL PANEL =============
procedure TFSeries.LimpiaDatos();
begin
  Edit2.Text:='';
  Edit3.Text:='0'; Edit4.Text:='0';
  Edit5.Text:='0'; Edit6.Text:='0'; Edit7.Text:='0'; Edit8.Text:='0';
end;


initialization
  {$I series.lrs}

end.

