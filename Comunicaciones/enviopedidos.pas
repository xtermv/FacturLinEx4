{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2008,

  Nicolas Lopez de Lerma Aymerich
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

Unit enviopedidos;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_Class, ExtDlgs, EditBtn, lr_e_pdf, Grids;

Type

  { TFEnvioPedidos }

  TFEnvioPedidos = Class(Tform)
    BitBtnEnviar2: TBitBtn;
    BitBtnSalir2: TBitBtn;
    DataSource1: TDatasource;
    dbAlmacen: TZQuery;
    dbAlmacenR: TZQuery;
    dbArtitien: TZQuery;
    dbArtitienR: TZQuery;
    dbConectR: TZConnection;
    dbEans: TZQuery;
    dbEansR: TZQuery;
    dbFami: TZQuery;
    dbFamiR: TZQuery;
    DBGrid1: TDBGrid;
    dbPedicc: TZQuery;
    dbPediccR: TZQuery;
    dbPedidd: TZQuery;
    dbPediddR: TZQuery;
    dbPedita: TZQuery;
    dbPeditaR: TZQuery;
    dbProve: TZQuery;
    dbProveR: TZQuery;
    dbTiendas: TZQuery;
    dbTrabajo: TZQuery;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    LabelTituloDBGrid: TLabel;
    LabelTituloDBGrid1: TLabel;
    PanelBotonera: TPanel;
    BitBtnEnviar: TBitBtn;
    BitBtnCerrar: TBitBtn;
    Panel2: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton9: TRadioButton;

    procedure BitBtnEnviarClick(Sender: TObject);
    procedure BitBtnEnviar2Click(Sender: TObject);
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure BitBtnSalir2Click(Sender: TObject);
    procedure DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    procedure RadioButton10Click(Sender: TObject);
    procedure RadioButton11Click(Sender: TObject);

    //procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    //procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    procedure OcultarBDGrid();
    procedure DimensionarColocarBDGrid();

    procedure EnviaCabecera();
    procedure EnviaDetalles();
    procedure ConfirmaEnvio();
    procedure GrabaArticuloRemoto();
    //procedure EviaUniColorTalla();
    //procedure GrabaAlmacenRemoto();
    procedure GrabaProveedor();
    procedure GrabaFamilia();
    procedure GrabaEans();
    procedure EnvioFallido();
    procedure PanelPedidosPendientes(Mensaje  : PChar);
    procedure RadioButton9Click(Sender: TObject);

    //procedure EscogeNombreComboCambiable(TxtCampo: String; ComboCambiableNombre: TComboBox;  dbCambiable: TZQuery; EditCambiableNombre: TEdit; StaticTextCambiableNombre: TStaticText);
  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormenviopedidos;
  
Var
  FEnvioPedidos: TFEnvioPedidos;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

  TiendaDestino: String;
  Modulo1: String;
  Mensa: String;

  ResultadoEnvio: Boolean;

Implementation

uses
  Global, Funciones;

//=============== Crea el formulario ================
procedure ShowFormenviopedidos;
begin
  with TFEnvioPedidos.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFEnvioPedidos.Formcreate(Sender: Tobject);
Begin
  ResultadoEnvio:=True;
  // Selecciono (en dbPedicc) los pedidos de la tabla pedicc de la tienda activa (mi tienda)
  // para enviar al proveedor PC11=P
  dbPedicc.Active:=False;
  dbPedicc.Sql.Text:='SELECT * FROM pedicc'+Tienda+' WHERE PC11="P" ORDER BY PC1,PC2,PC3';
  dbPedicc.Active := True;

  //DbGrid1.Enabled:=False;
  if dbPedicc.RecordCount<>0 then PanelPedidosPendientes('TIENE PEDIDOS PENDIENTES DE ENVIAR, ¿DESEA VERLOS?');


  //FMensaje.Refresh;
  //FMensaje.ProgressBar1.Max:=dbPedicc.RecordCount;
  //FMensaje.Close;

   //Ocultamos todos los DBGrid
   DimensionarColocarBDGrid();
   OcultarBDGrid();
  
End;

//==================== CERRAR ======================
procedure TFEnvioPedidos.BitBtnCerrarClick(Sender: TObject);
begin
  dbPedicc.Active:=False;

  Close();
end;

procedure TFEnvioPedidos.BitBtnSalir2Click(Sender: TObject);
begin
  RadioButton9.Checked:=True;
  Panel2.Visible:=False;
  PanelBotonera.Enabled:=True;
  OcultarBDGrid();
  //DbGrid1.Enabled:=True;
  //DbGrid1.SetFocus;
end;

// Con el Botón derecho Marco o Desmarco el pedido para enviar
procedure TFEnvioPedidos.DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then exit;
  if (dbPedicc.RecordCount<>0) and (dbPedicc.Eof=False) Then
     begin
      if (dbPedicc.Fields[10].AsString='') or (dbPedicc.Fields[10].AsString='N') then
        begin
         dbPedicc.Edit;
         dbPedicc.Fields[10].AsString:='S';
         dbPedicc.Post;
        end
      else
        begin
         dbPedicc.Edit;
         dbPedicc.Fields[10].AsString:='N';
         dbPedicc.Post;
        end;
     end;
end;

procedure TFEnvioPedidos.BitBtnEnviarClick(Sender: TObject);
begin //Enviar, del panel de abajo (PanelBotonera)
  if dbPedicc.RecordCount=0 then begin ShowMessage('NO TIENE PEDIDOS PARA TRANSMITIR'); exit; end;
  Panel2.Visible:=True; DbGrid1.Enabled:=False; PanelBotonera.Enabled:=False;
  RadioButton9.SetFocus;
end;


//Boton enviar del panel2, el que realmente ejecuta la acción
procedure TFEnvioPedidos.BitBtnEnviar2Click(Sender: TObject);
var
 TxtQuery: String;
begin
  if Application.MessageBox('CONFIRME LA TRANSMISION DE LOS PEDIDOS','FacturLinEx', boxstyle) = IDNO Then Exit;
  dbPedicc.First;
  while not dbPedicc.Eof do
    begin                   // Para cada pedido ...
      //En el campo PC12 esta el código de la tienda donde hay que transmitir el pedido
      if dbPedicc.Fields[12].AsString='' then   //Me aseguro de que el pedido tenga una tienda de destino
        begin
          WriteLn('pedido sin destino');
          TxtQuery:='SELECT * FROM tiendas WHERE T0=9999 AND T1="SIN DESTINO"';
        end
      else
        begin
          TxtQuery:='SELECT * FROM tiendas WHERE T0='+dbPedicc.Fields[12].AsString;
        end;
          dbTiendas.Active:=False;
          dbTiendas.SQL.Text:=TxtQuery;
          WriteLn(TxtQuery);
          dbTiendas.Active:=True; //He seleccionado los datos de la tienda
      //Si la direccion IP de la tienda contiene algo distinto de localhost (no estoy muy de acuerdo con esto)
      //if (dbTiendas.RecordCount<>0) And (dbTiendas.Fields[13].AsString<>'') And (dbTiendas.Fields[13].AsString<>'localhost') then
      //Debiera ser si la tienda es distinta de la nuestra. Muy raro pero pudiera haber dos tiendas en la misma máquina
      if (dbTiendas.RecordCount<>0) And (DataModule1.LFill(dbTiendas.Fields[0].AsString,4,'0')<>Tienda) then
        begin                       //And (dbTiendas.Fields[13].AsString<>'')
          TiendaDestino:=DataModule1.LFill(dbTiendas.Fields[0].AsString,4,'0');
          WriteLn('Intentando la conexión con la tienda '+TiendaDestino);
          try
            //Comunicación con la tienda Remota    (dbConectR)
            // Los parametros de la conexión se extraen de la tabla Tiendas
            dbConectR.Connected:=False;
            dbConectR.HostName:=dbTiendas.Fields[13].AsString;
            dbConectR.Database:=dbTiendas.Fields[12].AsString;
            dbConectR.User:=dbTiendas.Fields[15].AsString;
            dbConectR.Password:=dbTiendas.Fields[16].AsString;
            dbConectR.Port:=dbTiendas.Fields[14].AsInteger;
            dbConectR.Protocol:=dbTiendas.Fields[17].AsString;

            WriteLn('dbConectR.HostName:='+dbTiendas.Fields[13].AsString);
            WriteLn('dbConectR.Database:='+dbTiendas.Fields[12].AsString);
            WriteLn('dbConectR.User:='+dbTiendas.Fields[15].AsString);
            WriteLn('dbConectR.Password:='+dbTiendas.Fields[16].AsString);
            WriteLn(dbTiendas.Fields[14].AsInteger);
            WriteLn('dbConectR.Protocol:='+dbTiendas.Fields[17].AsString);
          except
                WriteLn('Faltan parametros de la tienda '+TiendaDestino);
                //Faltan datos de la tienda
                EnvioFallido();
          end;
          try
            dbConectR.Connected:=True;
            GrabaProveedor();
            EnviaCabecera();
            EnviaDetalles();
            //Pendiente del módulo de tallas
            {if Modulo1='S' then
              begin
                EviaUniColorTalla();
              end;}
            ConfirmaEnvio();
            dbConectR.Connected:=False;
          except
                WriteLn('Fallo en la conexion a la tienda '+TiendaDestino);
                //Aquí deberiamos recoger los pedidos no enviados
                EnvioFallido();
          end;
        end
      else
          EnvioFallido();
      dbPedicc.Next;
    end;
  if Not ResultadoEnvio then PanelPedidosPendientes('POR ALGÚN MOTIVO, HUBO PEDIDOS QUE NO SE TRANSMITIERON, ¿DESEA VERLOS?');
  //FMensaje.Close;
end;

procedure TFEnvioPedidos.EnviaCabecera();
var
  ContaFo: Integer;
begin
  dbPedidd.Active:=False;
  dbPedidd.Sql.Text:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+dbPedicc.Fields[0].AsString+' AND PD1="'+FormatDateTime('yyyy-mm-dd',dbPedicc.Fields[1].asDateTime)+'" AND PD2='+dbPedicc.Fields[2].AsString+' AND PD3='+dbPedicc.Fields[3].AsString+' ORDER BY PD16, PD6';
  dbPedidd.Active:=True;
  if dbPedidd.RecordCount=0 then exit;
  dbPediccR.Active:=False;
  dbPediccR.Sql.Text:='SELECT * FROM pedicc'+TiendaDestino+' WHERE PC0='+Tienda+' And PC1="'+FormatDateTime('yyyy-mm-dd',dbpedicc.Fields[1].value)+'" And PC2='+dbpedicc.Fields[2].asString+' And PC3='+dbpedicc.Fields[3].asString;
  dbPediccR.Active := True;
  dbPediccR.Append;
  for ContaFo:=0 to 2 do
    dbPediccR.Fields[ContaFo].Value:=dbPedicc.Fields[ContaFo].Value;
  for ContaFo:=4 to 9 do  // No creo que el campo Transmitido PC10 haya que mandarlo
    dbPediccR.Fields[ContaFo].Value:=dbPedicc.Fields[ContaFo].Value;
  dbPediccR.Post;
end;

// Recoge un aviso de que se trató de enviar algún pedido pero por algún motivo fallo
procedure TFEnvioPedidos.EnvioFallido();
begin
  ResultadoEnvio:=False;
  // Aquí se podrían implementar más acciones para los envios enviados pero fallidos
end;
procedure TFEnvioPedidos.EnviaDetalles();
var
  ContaFo: Integer;
begin
  dbPediddR.Active:= False;
  dbPediddR.Sql.Text:='SELECT * FROM pedidd'+TiendaDestino+' WHERE PD0='+Tienda+' And PD1="'+FormatDateTime('yyyy-mm-dd',dbpedicc.Fields[1].value)+'" And PD2='+dbpedicc.Fields[2].asString+' And PD3='+dbpediccR.Fields[3].asString;
  dbPediddR.Active := True;
  dbPedidd.First;
  while not dbpedidd.Eof do
   begin
     dbPediddR.Append;
     for ContaFo:=0 to 2 do
        dbPediddR.Fields[ContaFo].Value:=dbPedidd.Fields[ContaFo].Value;
     dbPediddR.Fields[3].Value:=dbPediccR.Fields[3].Value;
     for ContaFo:=4 to 25 do  // Completo hasta el final de pedidd => 25
        dbPediddR.Fields[ContaFo].Value:=dbPedidd.Fields[ContaFo].Value;
     dbPediddR.Post;
     GrabaArticuloRemoto(); //---------- Ver si existe el artículo en tienda remota
     if dbArtitien.RecordCount<>0 then
       begin
        GrabaFamilia(); //------------------- Ver si existe familia remota
       end;
     dbPedidd.Next;
   end;
end;

//procedure TFEnvioPedidos.EviaUniColorTalla();
//var
  //Txt: String;
  //ContaFo: Integer;
//begin
  //Txt:='SELECT * FROM peditalla'+Tienda+' WHERE PT0='+dbPedicc.Fields[0].AsString+' AND ';
  //Txt:=Txt+'PT1="'+FormatDateTime('yyyy-mm-dd',dbPedicc.Fields[1].asDateTime)+'" AND ';
  //Txt:=Txt+'PT2='+dbPedicc.Fields[2].AsString+' AND PT3='+dbPedicc.Fields[3].AsString;
  //Txt:=Txt+' AND PT7<>0';
  //dbPediTa.Active:=False; dbPediTa.Sql.Text:=Txt; dbPediTa.Active:=True;
  //Txt:='SELECT * FROM peditalla'+TiendaDestino+' WHERE PT0='+Tienda+' AND ';
  //Txt:=Txt+'PT1="'+FormatDateTime('yyyy-mm-dd',dbPedicc.Fields[1].asDateTime)+'" AND ';
  //Txt:=Txt+'PT2='+dbPedicc.Fields[2].AsString+' AND PT3='+dbPediccR.Fields[3].AsString;
  //dbPediTaR.Active:= False; dbPediTaR.Sql.Text:=Txt; dbPediTaR.Active := True;
  //dbPediTa.First;
  //while not dbpediTa.Eof do
   //begin
     //dbPediTaR.Append;
     //for ContaFo:=0 to 2 do
        //dbPediTaR.Fields[ContaFo].Value:=dbPediTa.Fields[ContaFo].Value;
     //dbPediTaR.Fields[3].Value:=dbPediccR.Fields[3].Value;
     //for ContaFo:=4 to 11 do
        //dbPediTaR.Fields[ContaFo].Value:=dbPediTa.Fields[ContaFo].Value;
     //dbPediTaR.Post;
     //dbPediTa.Next;
   //end;
//end;
procedure TFEnvioPedidos.ConfirmaEnvio();
begin
  dbPedicc.Edit;
  dbpedicc.Fields[10].AsString:='S';
  dbpedicc.Fields[12].AsString:=IntToStr(StrToInt(TiendaDestino));
  dbPedicc.Post;
  WriteLn('ConfirmaEnvio(). Envio realizado al destino '+dbpedicc.Fields[12].AsString);
end;
procedure TFEnvioPedidos.GrabaArticuloRemoto();
var
  ContaNu: Integer;
begin
  dbArtitien.Active:=False;
  dbArtitien.Sql.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbPedidd.Fields[6].AsString+'"';
  dbArtitien.Active:=True;
  if dbArtitien.RecordCount=0 then exit; //Si el articulo no existe en mi tienda, fuera
  dbArtitienR.Active:=False;
  dbArtitienR.Sql.Text:='SELECT * FROM artitien'+TiendaDestino+' WHERE A0="'+dbPedidd.Fields[6].AsString+'"';
  dbArtitienR.Active:=True;
  if dbArtitienR.RecordCount<>0 then exit; //Si el articulo ya existe en la tienda Remota, fuera
  dbArtitienR.Append;                      //como no existe lo añado
  for ContaNu:=0 to 3 do
    dbArtitienR.Fields[ContaNu].Value:=dbArtitien.Fields[ContaNu].Value;
    dbArtitienR.Fields[4].Value:=0.00;
    dbArtitienR.Fields[5].Value:=0.00;
    dbArtitienR.Fields[6].Value:=0.00;
  for ContaNu:=7 to 10 do
    dbArtitienR.Fields[ContaNu].Value:=dbArtitien.Fields[ContaNu].Value;
  //Unidades pendientes A11 en la tienda Remota = Unid Pendi en la Tienda Remota mas las unidades pedidad PD8
  dbArtitienR.Fields[11].Value:=dbArtitienR.Fields[11].AsFloat+dbPedidd.Fields[8].AsFloat;
  for ContaNu:=14 to 21 do
    dbArtitienR.Fields[ContaNu].Value:=dbArtitien.Fields[ContaNu].Value;
  //Añado los campos hasta el final de cada artículo
  dbArtitienR.Fields[22].Value:='N';
  for ContaNu:=23 to 34 do
    dbArtitienR.Fields[ContaNu].Value:=dbArtitien.Fields[ContaNu].Value;
  dbArtitienR.Post;
  //GrabaAlmacenRemoto();
  GrabaEans();
end;
// Este método no debe existir. La tabla artialmacen ya no existe

//procedure TFEnvioPedidos.GrabaAlmacenRemoto();
//var
  //ContaNu: Integer;
//begin
  //dbAlmacenR.Active:=False;
  //dbAlmacenR.Sql.Text:='SELECT * FROM artialmacen WHERE AA0="'+dbPedidd.Fields[4].AsString+'"';
  //dbAlmacenR.Active:=True;
  //if dbAlmacenR.RecordCount<>0 then exit;
  //dbAlmacen.Active:=False;
  //dbAlmacen.Sql.Text:='SELECT * FROM artialmacen WHERE AA0="'+dbPedidd.Fields[4].AsString+'"';
  //dbAlmacen.Active:=True;
  //if dbAlmacen.RecordCount=0 then exit;
  //dbAlmacenR.Append;
  //for ContaNu:=0 to 10 do
    //dbAlmacenR.Fields[ContaNu].Value:=dbAlmacen.Fields[ContaNu].Value;
  //dbAlmacenR.Post;
//end;
procedure TFEnvioPedidos.GrabaEans();
var
  ContaNu: Integer;
begin
  dbEans.Active:=False;
  dbEans.Sql.Text:='SELECT * FROM eans WHERE EAN1="'+dbArtitien.Fields[0].AsString+'"';
  dbEans.Active:=True;
  if dbEans.RecordCount=0 then exit else dbEans.First;
  while not dbEans.Eof do
    begin
     dbEansR.Active:=False;
     dbEansR.Sql.Text:='SELECT * FROM eans WHERE EAN0="'+dbEans.Fields[0].AsString+'" AND EAN1="'+dbEans.Fields[1].AsString+'"';
     dbEansR.Active:=True;
     if dbEans.RecordCount=0 then
      begin
        dbEansR.Append;
        for ContaNu:=0 to 5 do
          dbEansR.Fields[ContaNu].Value:=dbEans.Fields[ContaNu].Value;
        dbEansR.Post;
      end;
     dbEans.Next;
    end;
end;


procedure TFEnvioPedidos.GrabaProveedor();
var
  ContaNu: Integer;
begin
  WriteLn('Por aquí GrabaProveedor()');
  dbProveR.Active:=False;
  dbProveR.Sql.Text:='SELECT * FROM proveedores WHERE P0='+dbPedicc.Fields[2].AsString;
  //WriteLn('GrabaProveedor()R SELECT * FROM proveedores WHERE P0='+dbPedicc.Fields[2].AsString);
  dbProveR.Active:=True;
  if dbProveR.RecordCount<>0 then exit; //El proveedor existe en la tienda desteino y no hay que grabarlo
  dbProve.Active:=False;
  dbProve.Sql.Text:='SELECT * FROM proveedores WHERE P0='+dbPedicc.Fields[2].AsString;
  //WriteLn('GrabaProveedor() SELECT * FROM proveedores WHERE P0='+dbPedicc.Fields[2].AsString);
  dbProve.Active:=True;
  if dbProve.RecordCount=0 then exit; //No existe ese proveedor en mi tienda y no hay nada que grabar
  dbProveR.Append;
  //for ContaNu:=0 to 21 do   //Si esto son los campos de proveedores => 39
  for ContaNu:=0 to 39 do
    dbProveR.Fields[ContaNu].Value:=dbProve.Fields[ContaNu].Value;
  dbProveR.Post;
  //WriteLn('Por aquí GrabaProveedor() FIN');
end;
procedure TFEnvioPedidos.GrabaFamilia();
var
  ContaNu: Integer;
begin
  WriteLn('Por aquí GrabaFamilia() ');
  dbFamiR.Active:=False;
  dbFamiR.Sql.Text:='SELECT * FROM familias'+TiendaDestino+' WHERE F0='+dbArtitien.Fields[14].AsString;
  WriteLn('SELECT * FROM familias'+TiendaDestino+' WHERE F0='+dbArtitien.Fields[14].AsString);
  dbFamiR.Active:=True;
  if dbFamiR.RecordCount<>0 then exit;
  dbFami.Active:=False;
  dbFami.Sql.Text:='SELECT * FROM familias'+Tienda+' WHERE F0='+dbArtitien.Fields[14].AsString;
  WriteLn('SELECT * FROM familias'+Tienda+' WHERE F0='+dbArtitien.Fields[14].AsString);
  dbFami.Active:=True;
  if dbFami.RecordCount=0 then exit;
  dbFamiR.Append;
  for ContaNu:=0 to 5 do
    dbFamiR.Fields[ContaNu].Value:=dbFami.Fields[ContaNu].Value;
  dbFamiR.Post;
end;

// Enviar todos lo pedidos
procedure TFEnvioPedidos.RadioButton9Click(Sender: TObject);
begin
  if RadioButton9.Checked=True then
    begin
     dbPedicc.Active:=False;
     dbPedicc.Sql.Text:='SELECT * FROM pedicc'+Tienda+' WHERE PC11="P" ORDER BY PC1,PC2,PC3';
     dbPedicc.Active := True;
    end;
end;
// Enviar todos lo pedidos Marcados PC10=S
procedure TFEnvioPedidos.RadioButton10Click(Sender: TObject);
begin
  if RadioButton10.Checked=True then
    begin
     dbPedicc.Active:=False;
     dbPedicc.Sql.Text:='SELECT * FROM pedicc'+Tienda+' WHERE PC11="P" AND PC10="S" ORDER BY PC1,PC2,PC3';
     dbPedicc.Active := True;
    end;
end;
// Enviar todos los pedidos Sin Marcar PC10<>S
procedure TFEnvioPedidos.RadioButton11Click(Sender: TObject);
begin
  if RadioButton11.Checked=True then
    begin
     dbPedicc.Active:=False;
     dbPedicc.Sql.Text:='SELECT * FROM pedicc'+Tienda+' WHERE PC11="P" AND PC10<>"S" ORDER BY PC1,PC2,PC3';
     dbPedicc.Active := True;
    end;
end;
// Mostrar la grid de Pedidos Pendientes
procedure TFEnvioPedidos.PanelPedidosPendientes(Mensaje: PChar);
begin
   if Application.MessageBox(Mensaje,'FacturLinEx', boxstyle) = IDNO Then
     Exit
   else
     begin
        dbPedicc.Active:=False;
        dbPedicc.Sql.Text:='SELECT * FROM pedicc'+Tienda+' WHERE PC11="P" ORDER BY PC1,PC2,PC3';
        dbPedicc.Active := True;
        DBGrid1.BringToFront; DBGrid1.Visible:=True;
        Exit;
     end;
 end;

//======================= OCULTA TODOS LOS DBGird y su Titulo
procedure TFEnvioPedidos.OcultarBDGrid();
  begin
    DBGrid1.Visible:=False;

    LabelTituloDBGrid.Caption:='';
    DimensionarColocarBDGrid();
  end;
//======================= DIMENSIONA LOS DBGrid
// Los DBGrid estan "minimizados" (50x50) para poder trabajar en el resto del
// formulario, con esta funcion los adapto al Panel donde se encuentran
procedure TFEnvioPedidos.DimensionarColocarBDGrid();
  begin
    //DBGrid2.Align:=alClient;
    //DBGrid2.Height:=380;
    //DBGrid2.Width:=910;
    //DBGrid2.Left:=55;
    //DBGrid2.Top:=40;
  end;

Procedure TFEnvioPedidos.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;


Initialization
  {$I enviopedidos.lrs}

End.

