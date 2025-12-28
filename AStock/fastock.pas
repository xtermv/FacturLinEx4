unit FAStock;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ZDataset, ZConnection, ComCtrls, LCLType, DBGrids,
  db, DbCtrls, EditBtn, LR_DBSet, LR_Class, ExtDlgs, Process;

type

  { TFastock }

  TFastock = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Datasource1: TDatasource;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    dbAStock: TZQuery;
    dbHiststock: TZQuery;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit5KeyPress(Sender: TObject; var Key: char);
    procedure Edit6Exit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Limpiar();

    function compruebatecla(key: char):char;

  private
    { private declarations }
  public
    { public declarations }
  end;

  Procedure ShowFormStock;

var
  stock: TFastock;
  Inicio: Boolean;
  sOrden: string;

implementation

uses
  Global, Funciones, Busquedas;

{ TFastock }

//=============== Crea el formulario ================
procedure ShowFormStock;
begin
  with TFastock.Create(Application) do
    begin
       ShowModal;
       Inicio:=True;
    end;
end;

procedure TFastock.FormActivate(Sender: TObject);
begin
    if Inicio then
     Begin
          Edit1.SetFocus;
          Inicio:=False;
     End;
end;

procedure TFastock.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := CaFree;
end;

procedure TFastock.FormShow(Sender: TObject);
begin
    if Inicio then
     Begin
          Edit1.SetFocus;
          Inicio:=False;
     End;
end;

Procedure TFastock.Formcreate(Sender: Tobject);
Begin
  ShortDateFormat:='DD/MM/YYYY';
  {$IFDEF LINUX}
     DecimalSeparator:='.';
  {$ELSE}
     DecimalSeparator:=',';
  {$ENDIF}
  //----------------- CONEXION -----------------
  //Conectate(dbConect);     // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbAStock.Sql.Text := 'SELECT * FROM artitien'+Tienda+'';
  dbAStock.Active := True;
  dbHiststock.SQL.Text := 'SELECT * FROM histstock'+Tienda+'';
  dbHiststock.Active := True;
  sOrden:='DESC';
end;

procedure TFastock.Edit1KeyPress(Sender: TObject; var Key: char);
begin
     key:=compruebatecla(key); // -- Las funciones OnKeyPress de todos los campos Edit, estan asociados a este mismo procedimiento, no siendo necesario crear un procedimiento por cada campo
end;

procedure TFastock.Edit2KeyPress(Sender: TObject; var Key: char);
begin
      if ( key = Char(VK_RETURN) ) then // -- En caso de pulsar enter, pasa al siguiente campo
         begin
              key:=#0;
              if Edit2.Text='' then
               begin
                    showmessage('Debe escribir texto a buscar');
                    Exit;
               end;
              Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT A0,A1 FROM artitien'+Tienda+' WHERE A1 LIKE "%'+Edit2.Text+'%"',['Código','Descripción'],'A0');
              if Edit1.Text<>'' then Edit1Exit(Edit1);
         end;
end;

procedure TFastock.Edit5Exit(Sender: TObject);
begin
  Edit6.SetFocus;
end;

procedure TFastock.Edit5KeyPress(Sender: TObject; var Key: char);
begin
     // -- Solo permite la insercion de numeros y la pulsacion de enter o teclas especiales -------
      if ( StrScan('0123456789',Key) <> nil ) or ( Key = Char(VK_BACK) )
           or  ( Key = Char(VK_TAB) )  or  ( Key = Char(VK_RETURN) ) or  ( Key = Char(VK_UP) )
           or  ( Key = Char(VK_DOWN) ) then
      else
          begin
               Key := #0;
          end;
       if ( key = Char(VK_RETURN) ) then // -- En caso de pulsar enter, pasa al siguiente campo
         begin
              key:=#0;
              BitBtn1.SetFocus;
         end;
      if ( key = Char(VK_UP) ) then // -- Si pulsamos la flecha arriba, vuelve al campo anterior
         begin
              key:=#0;
              SelectNext(activecontrol,false,true);
         end;
      if ( key = Char(VK_DOWN) ) then // -- Si pulsamos la flecha abajo, pasa al campo siguiente
         begin
              key:=#0;
              SelectNext(activecontrol,true,true);
         end;
end;

procedure TFastock.Edit6Exit(Sender: TObject);
begin
    BitBtn1.SetFocus;
end;

procedure TFastock.Edit1Exit(Sender: TObject);
Var
   temporal:string;
begin

  dbAStock.Active := False;
  dbAStock.Sql.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit1.Text+'"';
  dbAStock.Active := True;

  if dbAStock.RecordCount=0 then
     begin
          dbAStock.Active := False;
          dbAStock.Sql.Text:='SELECT EAN0,EAN1 FROM eans WHERE EAN0="'+Edit1.Text+'"';
          dbAStock.Active := True;
          temporal:=dbAStock.FieldByName('EAN1').AsString;
          dbAStock.Active := False;
          dbAStock.Sql.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+temporal+'"';
          dbAStock.Active := True;
     end;

  if dbAStock.RecordCount=0 then exit;

  Edit2.Text:=dbAStock.FieldByName('A1').AsString;//---------------- Descripción
  Edit3.Text:=dbAStock.FieldByName('A4').AsString;//---------------- Stock Actual
  Edit4.Text:=dbAStock.FieldByName('A5').AsString;//---------------- Stock Minimo
  Edit5.Text:=dbAStock.FieldByName('A6').AsString;//---------------- Stock Maximo

end;

procedure TFastock.BitBtn1Click(Sender: TObject);
begin
  dbHiststock.Append;
  dbHiststock.FieldByName('fecha').AsDateTime:=Date;
  dbHiststock.FieldByName('hora').AsDateTime:=Time;
  dbHiststock.FieldByName('codigo').AsString:=dbAStock.FieldByName('A0').AsString;
  dbHiststock.FieldByName('puesto').AsString:=Puesto;
  dbHiststock.FieldByName('descripcion').AsString:=dbAStock.FieldByName('A1').AsString;
  dbHiststock.FieldByName('stock').AsString:=dbAStock.FieldByName('A4').AsString;
  dbHiststock.FieldByName('stockmin').AsString:=dbAStock.FieldByName('A5').AsString;
  dbHiststock.FieldByName('stockmax').AsString:=dbAStock.FieldByName('A6').AsString;
  dbHiststock.FieldByName('newstock').AsString:=Edit3.Text;
  dbHiststock.FieldByName('newmin').AsString:=Edit4.Text;
  dbHiststock.FieldByName('newmax').AsString:=Edit5.Text;
  dbHiststock.FieldByName('motivo').AsString:=Edit6.Text;
  dbHiststock.Post;
  dbAstock.Edit;
  dbAStock.FieldByName('A1').AsString:=Edit2.Text;//---------------- Descripción
  dbAStock.FieldByName('A4').AsString:=Edit3.Text;//---------------- Stock Actual (Nuevo)
  dbAStock.FieldByName('A5').AsString:=Edit4.Text;//---------------- Stock Minimo (Nuevo)
  dbAStock.FieldByName('A6').AsString:=Edit5.Text;//---------------- Stock Maximo (Nuevo)
  dbAStock.Post;
  ShowMessage('CAMBIOS ALMACENADOS CORRECTAMENTE');
  Limpiar();
  Edit1.SetFocus;
end;

procedure TFastock.BitBtn2Click(Sender: TObject);
begin
  if DBGrid1.Visible=True then DBGrid1.Visible:=False else DBGrid1.Visible:=True;
  if Edit1.Text='' then dbHiststock.SQL.Text:='SELECT * FROM histstock'+Tienda+''
  else dbHiststock.SQL.Text:='SELECT * FROM histstock'+Tienda+' WHERE codigo="'+Edit1.Text+'"';
  dbHiststock.Active:=True;
end;

procedure TFastock.DBGrid1TitleClick(Column: TColumn);
var
  corden: string;
begin
//--  Colorea(Column,DBGrid2,dbPedid, AntColun, Orden, TituloColumn, Ordenado);
  DBGrid1.Enabled:=False;
  if Edit1.Text='' then corden:='SELECT * FROM histstock'+Tienda+''
    else corden:='SELECT * FROM histstock'+Tienda+' WHERE codigo="'+Edit1.Text+'" ORDER BY '+Column.FieldName+' '+sOrden;
  if sOrden='DESC' then sOrden:='ASC' else sOrden:='DESC';
  dbHiststock.Sql.Text:=corden; dbHiststock.Active:=True;
  dbHiststock.Refresh; DBGrid1.Refresh;
  DBGrid1.Enabled:=True;
end;

//================== INSERCION SOLO DE NUMEROS JUNTO A CONTROL TECLAS PULSADAS  ====================
function TFastock.compruebatecla(key:char):char;
begin
      // -- Solo permite la insercion de numeros y la pulsacion de enter o teclas especiales -------
      if ( StrScan('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',Key) <> nil ) or ( Key = Char(VK_BACK) )
           or  ( Key = Char(VK_TAB) )  or  ( Key = Char(VK_RETURN) ) or  ( Key = Char(VK_UP) )
           or  ( Key = Char(VK_DOWN) ) then
      else
          begin
               Key := #0;
          end;
      if ( key = Char(VK_RETURN) ) then // -- En caso de pulsar enter, pasa al siguiente campo
         begin
              key:=#0;
              SelectNext(activecontrol,true,true);
         end;
      if ( key = Char(VK_UP) ) then // -- Si pulsamos la flecha arriba, vuelve al campo anterior
         begin
              key:=#0;
              SelectNext(activecontrol,false,true);
         end;
      if ( key = Char(VK_DOWN) ) then // -- Si pulsamos la flecha abajo, pasa al campo siguiente
         begin
              key:=#0;
              SelectNext(activecontrol,true,true);
         end;
      compruebatecla:=(key);
end;

procedure TFastock.LImpiar();
Begin
     Edit1.Text:='';Edit2.Text:='';Edit3.Text:='';Edit4.Text:='';Edit5.Text:='';Edit6.Text:='';
     Edit1.SetFocus;
end;

//==================== CERRAR ======================
procedure TFastock.BitBtn3Click(Sender: TObject);
Begin
  BitBtn2.Click;
  dbAStock.Active:=False;
  Close();
End;

initialization
  {$I fastock.lrs}

end.

