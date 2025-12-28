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
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit unirpedido;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, DBGrids, Buttons, StdCtrls, ZConnection, ZDataset, LCLType, ComCtrls,
  ExtCtrls;

type

  { TFUniPedi }

  TFUniPedi = class(TForm)
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    dbConnect: TZConnection;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    dbPedic: TZQuery;
    dbPedic1: TZQuery;
    dbPedid1: TZQuery;
    dbPedid: TZQuery;
    dbBusca: TZQuery;
    Label1: TLabel;
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    function VerUltimaLinea: Integer;

  private
    { private declarations }
  public
    { public declarations }
  end; 

  procedure ShowFormUniPedi();

var
  FUniPedi: TFUniPedi;

implementation

{ TFUniPedi }

uses
  Global, Funciones;

//===================== CREAR EL FORMULARIO =====================
procedure ShowFormUniPedi();
begin
  with TFUniPedi.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFUniPedi.FormCreate(Sender: TObject);
Var
  cont:Integer;
begin
  //--------- Conectar con la bbdd
  Conectate(dbConnect);
  //--------- Pedido origen
  dbPedic.SQL.Text:='SELECT * FROM pedicc'+Tienda+
                    ' ORDER BY PC0 ASC, PC1 DESC, PC2 ASC, PC3 ASC, PC4 DESC';
  dbPedic.Active:=True;
  //--------- Pedido destino
  dbPedic1.SQL.Text:='SELECT * FROM pedicc'+Tienda+
                    ' ORDER BY PC0 ASC, PC1 DESC, PC2 ASC, PC3 ASC, PC4 DESC';
  dbPedic1.Active:=True;

  //----------------- Colores del formulario y botones ------------------------
  if ColorFondo<>'' then Color:=StringToColor(ColorFondo);
    cont:=0;
  if ColorBotones<>'' then
    begin
     for cont:=0 to ComponentCount-1 do
       begin
        if (Components[cont] is TBitBtn) then
          TBitBtn(FindComponent(Components[cont].Name)).color:=StringToColor(ColorBotones);
       end;
    end;

end;

//=================== CERRAR FORMULARIO ============================
procedure TFUniPedi.BitBtn2Click(Sender: TObject);
begin
  Close();
end;
procedure TFUniPedi.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//======================= UNIR PEDIDOS ============================
procedure TFUniPedi.BitBtn3Click(Sender: TObject);
var
  Conta: Integer;
begin
  if dbPedic.RecordCount=0 then begin showmessage('NO TIENE PEDIDOS PARA UNIR'); exit; end;
  if dbPedic1.RecordCount=0 then begin showmessage('NO TIENE PEDIDOS PARA UNIR'); exit; end;
  //-------------- Chequear que los pedidos no sean los mismo (origen-destino)
  if (dbPedic.FieldByName('PC0').AsString=dbPedic1.FieldByName('PC0').AsString) and
     (dbPedic.FieldByName('PC1').AsString=dbPedic1.FieldByName('PC1').AsString) and
     (dbPedic.FieldByName('PC2').AsString=dbPedic1.FieldByName('PC2').AsString) and
     (dbPedic.FieldByName('PC3').AsString=dbPedic1.FieldByName('PC3').AsString) and
     (dbPedic.FieldByName('PC4').AsString=dbPedic1.FieldByName('PC4').AsString) then
     begin showmessage('NO PUEDE UNIR EL MISMO PEDIDO ORIGEN-DESTINO'); exit; end;
  //-------------------------------------------------------------------------------
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  if Application.MessageBox('SE UNIRA EL PEDIDO ORIGEN CON EL PEDIDO DESTINO,'+ #10 + #10 +' (ATENCION! EL PEDIDO ORIGEN SE BORRARA), CONTINUAR?','FacturLinEx', boxstyle) = IDNO Then
     Exit;
  //-------------- Pedido origen
  dbPedid.Active:=False;
  dbPedid.SQL.Text:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic.FieldByName('PC4').AsString;
  dbPedid.Active:=True;
  //-------------- Pedido destino
  dbPedid1.Active:=False;
  dbPedid1.SQL.Text:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+dbPedic1.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic1.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic1.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic1.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic1.FieldByName('PC4').AsString;
  dbPedid1.Active:=True;
  //------------- Unir pedidos
  if dbPedid.RecordCount=0 then begin showmessage('EL PEDIDO ORIGEN NO TIENE LINEAS'); exit; end;
  ProgressBar1.Position:=0; ProgressBar1.Max:=dbPedid.RecordCount;
  Panel1.Visible:=True;
  dbPedid.First;
  while not dbPedid.EOF do
    begin
      dbPedid1.Append;

      dbPedid1.FieldByName('PD0').Value:=dbPedic1.FieldByName('PC0').Value;//----- N. Tienda
      dbPedid1.FieldByName('PD1').Value:=dbPedic1.FieldByName('PC1').Value;//----- Fecha
      dbPedid1.FieldByName('PD2').Value:=dbPedic1.FieldByName('PC2').Value;//----- Proveedor
      dbPedid1.FieldByName('PD3').Value:=dbPedic1.FieldByName('PC3').Value;//----- Serie
      dbPedid1.FieldByName('PD4').Value:=dbPedic1.FieldByName('PC4').Value;//----- N. Pedido
      dbPedid1.FieldByName('PD5').Value:=VerUltimaLinea;//------- N. Linea
      for Conta:=6 to 30 do
        dbPedid1.Fields[Conta].Value:=dbPedid.Fields[Conta].Value;
      dbPedid1.Post;
      ProgressBar1.Position:=ProgressBar1.Position+1;
      dbPedid.Next;
    end;
  dbPedic1.Edit;
  dbPedic1.FieldByName('PC5').Value:=dbPedic1.FieldByName('PC5').AsInteger + dbPedic.FieldByName('PC5').AsInteger;
  dbPedic1.FieldByName('PC6').Value:=dbPedic1.FieldByName('PC6').AsInteger + dbPedic.FieldByName('PC6').AsInteger;
  dbPedic1.FieldByName('PC7').Value:=dbPedic1.FieldByName('PC7').AsFloat + dbPedic.FieldByName('PC7').AsFloat;
  dbPedic1.FieldByName('PC8').Value:=dbPedic1.FieldByName('PC8').AsFloat + dbPedic.FieldByName('PC8').AsFloat;
  dbPedic1.FieldByName('PC9').Value:=dbPedic1.FieldByName('PC9').AsFloat + dbPedic.FieldByName('PC9').AsFloat;
  dbPedic1.Post;
  //----------- Borrar pedido origen
  dbPedid.First;
  while not dbPedid.EOF do
    begin
      dbPedid.Delete;
      dbPedid.Next;
    end;
  dbPedic.Delete;
  showmessage('Proceso concluido.');
  Panel1.Visible:=False;
end;


//=================== SACAR EL ULT N. DE LINEA =====================
function TFUniPedi.VerUltimaLinea: Integer;
begin
  VerUltimaLinea:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(PD5) As ULTIMA FROM pedidd'+Tienda+' WHERE PD0='+dbPedic1.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic1.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic1.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic1.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic1.FieldByName('PC4').AsString;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLinea:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;


initialization
  {$I unirpedido.lrs}

end.

