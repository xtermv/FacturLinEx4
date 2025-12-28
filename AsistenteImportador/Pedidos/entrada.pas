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

unit entrada;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ZDataset, db, ZConnection, DBGrids, Grids, ExtCtrls, StdCtrls, Buttons,
  EditBtn, LCLType, ComCtrls, variants;

type

  { TFEntrada }

  TFEntrada = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    BitBtn2: TBitBtn;
    BitBtn29: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn30: TBitBtn;
    BitBtn31: TBitBtn;
    CheckBox1: TCheckBox;
    Datasource1: TDatasource;
    DateEdit10: TDateEdit;
    DateEdit3: TDateEdit;
    DateEdit4: TDateEdit;
    DateEdit5: TDateEdit;
    DateEdit6: TDateEdit;
    dbTrabajo: TZQuery;
    dbConnect: TZConnection;
    DBGrid1: TDBGrid;
    dbPedic: TZQuery;
    dbPedid: TZQuery;
    dbTotales: TZQuery;
    dbArti: TZQuery;
    dbProve: TZQuery;
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
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    EditOtrosGastos: TEdit;
    Label30: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label86: TLabel;
    LabelCliente: TLabel;
    LabelCliente1: TLabel;
    LabelCliente2: TLabel;
    LabelCliente3: TLabel;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    ProgressBar1: TProgressBar;
    RadioButton15: TRadioButton;
    RadioButton16: TRadioButton;
    RadioButton17: TRadioButton;
    RadioButton18: TRadioButton;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    StaticText14: TStaticText;
    StaticText15: TStaticText;
    StaticText16: TStaticText;
    StaticText17: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    procedure BitBtn29Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn30Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure Datasource1DataChange(Sender: TObject; Field: TField);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Edit24Exit(Sender: TObject);
    procedure EditOtrosGastosExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure PintarTotalVencimientos();
    procedure PintaLineas();
    procedure ActuArticulos();
    procedure ActuEstaArti();
    procedure LeerDatosArticulo();
    procedure ActuUltimoPedi();
    procedure ActuTiendas();
    procedure ActuDeparta();
    procedure ActuFamilia();
    procedure ActuProveedor();
    procedure ActuEstaProveedor();
    procedure ActuEstaTiendas();
    procedure ActuHistocc();
    procedure ActuHistodd();
    procedure BorrarPedido();
    procedure VerVencimientos();

  private
    { private declarations }
  public
    { public declarations }
  end; 

  procedure ShowFormEntradaPedido(PaTienda,PaFecha,PaProveedor,PaSerie,PaNPedido:String);

var
  FEntrada: TFEntrada;
  PreciohaCambiado: Boolean;
  Codigo, Departa: String;
  Cantidad, Costo, Precio: String;

  //---------- Para saber si viene un pedido ya preseleccionado.
  PasaPD0: Integer;
  PasaPD1: TDateTime;
  PasaPD2: Integer;
  PasaPD3: String;
  PasaPD4: Integer;
  // Control para mantener la actualizacion en todas las lineas del pedido.
  MantenerSeleccion, SeleccionAutomatica: boolean;
  cbDescripcionF, cbCostoF, cbMargenF, cbIvaF, cbRecF, cbPrecioF, cbPvpF: boolean;
  cbDescripcionP, cbCostoP, cbMargenP, cbIvaP, cbRecP, cbPrecioP, cbPvpP: boolean;

implementation

{ TFEntrada }

uses
  Global, Funciones, CambiPrecio;

//===================== CREAR EL FORMULARIO =====================
procedure ShowFormEntradaPedido(PaTienda,PaFecha,PaProveedor,PaSerie,PaNPedido:String);
begin
  if PaTienda<>'' then PasaPD0:=StrToInt(PaTienda);
  if PaFecha<>'' then PasaPD1:=StrToDate(PaFecha);
  if PaProveedor<>'' then PasaPD2:=StrToInt(PaProveedor);
  if PaSerie<>'' then PasaPD3:=PaSerie;
  if PaNPedido<>'' then PasaPD4:=StrToInt(PaNPedido);

  MantenerSeleccion:=False; SeleccionAutomatica:= False;

  with TFEntrada.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFEntrada.FormCreate(Sender: TObject);
begin
  //--------- Conectar con la bbdd
  Conectate(dbConnect);
  //--------- Pedidos
  dbPedic.SQL.Text:='SELECT * FROM pedicc'+Tienda+
                    ' ORDER BY PC0 ASC, PC1 DESC, PC2 ASC, PC3 ASC, PC4 DESC';
  dbPedic.Active:=True;
  if dbPedic.RecordCount=0 then exit;
  //------------ Cargar pedido seleccionado si viene de gestionar
  if PasaPD2<>0 then
    begin
     if dbPedic.Locate('PC0,PC1,PC2,PC3,PC4',VarArrayof([PasaPD0,PasaPD1,PasaPD2,PasaPD3,PasaPD4]),[locaseinsensitive]) then
       BitBtn3Click(BitBtn3);
    end;

end;

//===================== CERRAR FORMULARIO =======================
procedure TFEntrada.BitBtn2Click(Sender: TObject);
begin
  dbPedic.Active:=False;
  dbPedid.Active:=False;
  dbTotales.Active:=False;
  dbArti.Active:=False;
  dbProve.Active:=False;
  dbTrabajo.Active:=False;
  dbConnect.Connected:=False;
  Close();
end;
procedure TFEntrada.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//=================== ENTRADA DE PEDIDOS ===================
procedure TFEntrada.BitBtn3Click(Sender: TObject);
var
  TxtQ: String;
  Dias: TDateTime;
begin
  if dbpedic.RecordCount=0 then exit;
  Panel11.Visible:=True; DBGrid1.Enabled:=False;
  BitBtn3.Enabled:=False; BitBtn2.Enabled:=False;
  Label50.Caption:=FloatToStr(IVA1)+'%'; Edit25.Text:='0.00'; Edit32.Text:='0.00';
  Label51.Caption:=FloatToStr(IVA2)+'%'; Edit27.Text:='0.00'; Edit33.Text:='0.00';
  Label52.Caption:=FloatToStr(IVA3)+'%'; Edit29.Text:='0.00'; Edit35.Text:='0.00';
  Label53.Caption:='0%'; Edit31.Text:='0.00'; Edit36.Text:='0.00';
  StaticText1.Caption:='0.00'; StaticText2.Caption:='0.00';
  //--------------- Datos del pedido ----------
  Label65.Caption:=dbPedic.FieldByName('PC3').AsString+' - '+dbPedic.FieldByName('PC4').AsString;
  Label66.Caption:=FormatDateTime('DD/MM/YYYY',dbPedic.FieldByName('PC1').AsDateTime);
  Label67.Caption:=dbPedic.FieldByName('PC2').AsString+' - '+dbPedic.FieldByName('PC13').AsString;
  //--------------- Datos documento proveedor ----------
  Edit34.Text:=''; DateEdit10.Clear;
  if (dbPedic.FieldByName('PC28').AsString='P') or (dbPedic.FieldByName('PC28').AsString='') then
     RadioButton17.Checked:=True;//- Pedido del proveedor
  if dbPedic.FieldByName('PC28').AsString='N' then
     RadioButton18.Checked:=True;//- Nota del proveedor
  if dbPedic.FieldByName('PC28').AsString='A' then
     RadioButton15.Checked:=True;//- Albaran del proveedor
  if dbPedic.FieldByName('PC28').AsString='F' then
     RadioButton16.Checked:=True;//- Factura del proveedor

  Edit34.Text:=dbPedic.FieldByName('PC29').AsString;//------------- Numero Documento Proveedor
  if dbPedic.FieldByName('PC30').AsString<>'' then
     DateEdit10.Date:=dbPedic.FieldByName('PC30').AsDateTime;//---- Fecha Documento Proveedor
  //------------------ Totales ----------------
  TxtQ:='SELECT DISTINCT(PD14) As TipoIva, (SUM(PD15*PD8)-SUM(PD10*PD8)) As Ivas, '+
        'SUM(PD10*PD8) As Bases, SUM(PD17) As Totales '+
        'FROM pedidd'+Tienda+
        ' WHERE PD0='+dbPedic.Fields[0].AsString+
        ' AND PD1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND PD2='+dbPedic.Fields[2].AsString+
        ' AND PD3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND PD4='+dbPedic.Fields[4].AsString;
  TxtQ:=TxtQ+' GROUP BY PD14 ORDER BY PD14 ASC';
  dbTotales.SQL.Text:=TxtQ; dbTotales.Active:=True;
  if dbTotales.RecordCount<>0 then
    begin
      if dbTotales.Locate('TipoIva',IVA1,[]) then
        begin
          Edit25.Text:=FormatFloat('0.00',dbTotales.Fields[2].AsFloat);//-------------- Base Imp.
          Edit32.Text:=FormatFloat('0.00',dbTotales.Fields[1].AsFloat);//-------------- Imp. Iva
        end;
      if dbTotales.Locate('TipoIva',IVA2,[]) then
        begin
          Edit27.Text:=FormatFloat('0.00',dbTotales.Fields[2].AsFloat);//-------------- Base Imp.
          Edit33.Text:=FormatFloat('0.00',dbTotales.Fields[1].AsFloat);//-------------- Imp. Iva
        end;
      if dbTotales.Locate('TipoIva',IVA3,[]) then
        begin
          Edit29.Text:=FormatFloat('0.00',dbTotales.Fields[2].AsFloat);//-------------- Base Imp.
          Edit35.Text:=FormatFloat('0.00',dbTotales.Fields[1].AsFloat);//-------------- Imp. Iva
        end;
      if dbTotales.Locate('TipoIva',0,[]) then
        begin
          Edit31.Text:=FormatFloat('0.00',dbTotales.Fields[2].AsFloat);//-------------- Base Imp.
          Edit36.Text:=FormatFloat('0.00',dbTotales.Fields[1].AsFloat);//-------------- Imp. Iva
        end;
    end;
  StaticText1.Caption:=FormatFloat('0.00',StrToFloat(Edit25.Text)+
                                          StrToFloat(Edit27.Text)+
                                          StrToFloat(Edit29.Text)+
                                          StrToFloat(Edit31.Text));
  StaticText2.Caption:=FormatFloat('0.00',StrToFloat(Edit32.Text)+
                                          StrToFloat(Edit33.Text)+
                                          StrToFloat(Edit35.Text)+
                                          StrToFloat(Edit36.Text));
  //---------------- Vencimientos -------------
  DateEdit3.Clear; DateEdit4.Clear;
  DateEdit5.Clear; DateEdit6.Clear;
  Label46.Caption:='0.00'; Label47.Caption:=FormatFloat('0.00',dbPedic.FieldByName('PC8').AsFloat);
  if dbPedic.FieldByName('PC20').AsString<>'' then
     DateEdit3.Date:=dbPedic.FieldByName('PC20').AsDateTime;
  Edit24.Text:=FormatFloat('0.00',dbPedic.FieldByName('PC21').AsFloat);
  if dbPedic.FieldByName('PC22').AsString<>'' then
     DateEdit4.Date:=dbPedic.FieldByName('PC22').AsDateTime;
  Edit26.Text:=FormatFloat('0.00',dbPedic.FieldByName('PC23').AsFloat);
  if dbPedic.FieldByName('PC24').AsString<>'' then
     DateEdit5.Date:=dbPedic.FieldByName('PC24').AsDateTime;
  Edit28.Text:=FormatFloat('0.00',dbPedic.FieldByName('PC25').AsFloat);
  if dbPedic.FieldByName('PC26').AsString<>'' then
     DateEdit6.Date:=dbPedic.FieldByName('PC26').AsDateTime;
  Edit30.Text:=FormatFloat('0.00',dbPedic.FieldByName('PC27').AsFloat);
  //------------ Suma de vencimientos
  Label46.Caption:=FormatFloat('0.00',dbPedic.FieldByName('PC21').AsFloat+
                                   dbPedic.FieldByName('PC23').AsFloat+
                                   dbPedic.FieldByName('PC25').AsFloat+
                                   dbPedic.FieldByName('PC27').AsFloat);
  //------ Total Pedido costo+impuestos-suma de vencimientos
  Label47.Caption:=FormatFloat('0.00',dbPedic.FieldByName('PC8').AsFloat-StrToFloat(Label46.Caption));

    //------------ Si no hay vencimientos ver los del proveedor
  if (DateEdit3.Text='') and (DateEdit4.Text='') and (DateEdit5.Text='') and (DateEdit6.Text='') then
    begin
      dbProve.Active:=False;
      dbProve.Sql.Text:='SELECT * FROM proveedores where P0='+dbPedic.FieldByName('PC2').AsString;
      dbProve.Active:=True;
      if dbProve.RecordCount=0 then begin showmessage('NO EXISTE ESE PROVEEDOR???'); exit; end;
      if dbProve.FieldByName('P15').AsInteger<>0 then VerVencimientos();
    end;
end;

//--------------- Aceptar entrada de pedido ----------------
procedure TFEntrada.BitBtn30Click(Sender: TObject);
var
  TxtQ: String;
begin
  ProgressBar1.Position:=0; ProgressBar1.Caption:='0';
  if Application.MessageBox('DAR ENTRADA AL PEDIDO SELECCIONADO?','FacturLinEx', boxstyle) = IDNO Then
      begin
        Panel1.Visible:=False; Panel11.Visible:=False;
        DBGrid1.Enabled:=True; exit;
      end;
  Panel11.Visible:=False; DBGrid1.Repaint;
  TxtQ:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.Fields[0].AsString+
        ' AND PD1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND PD2='+dbPedic.Fields[2].AsString+
        ' AND PD3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND PD4='+dbPedic.Fields[4].AsString+
        ' AND PD23="S"';//------------------Solo las lineas recibidas
  dbPedid.SQL.Text:=TxtQ; dbPedid.Active:=True;
  if dbPedid.RecordCount=0 then
     begin
       showmessage('ESTE PEDIDO NO TIENE LINEAS PARA ACEPTAR!');
       Panel1.Visible:=False; Panel11.Visible:=False;
       DBGrid1.Enabled:=True; exit;
     end;

  Panel1.Visible:=True; Panel1.Repaint;
  DBGrid1.Enabled:=False;

  dbPedid.First; ProgressBar1.Max:=dbPedid.RecordCount;
  while not dbPedid.EOF do
    begin
      dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbPedid.FieldByName('PD6').AsString+'"';
      dbArti.Active:=True;
      if dbArti.RecordCount=0 then begin showmessage('algo'); end; { TODO 1 -onicolas -cPedidos : Hay que ver si no existe el articulo, debe existir!
 }

      PreciohaCambiado:=False; PintaLineas();//------------ Pintar las lineas conforme se acepta el pedido
      if PreciohaCambiado=True then
         begin
         //ShowCambioPrecio(Tienda,Proveedor,Numero,Linea: Integer; Fecha: TdateTime; Codigo,Serie: string);

           ShowCambioPrecio(dbPedid.FieldByName('PD0').Value,
                            dbPedid.FieldByName('PD2').Value,
                            dbPedid.FieldByName('PD4').Value,
                            dbPedid.FieldByName('PD5').Value,
                            dbPedid.FieldByName('PD1').Value,
                            dbPedid.FieldByName('PD6').Value,
                            dbPedid.FieldByName('PD3').Value);
         end;

      LeerDatosArticulo();//------ Consultar los nuevos datos del articulo que vienen de cambio
      ActuArticulos();//---------- Actualizar Articulos
      ActuEstaArti();//----------- Estadistica de articulos
      ActuUltimoPedi();//--------- Ultimo pedido
      ActuEstaTiendas();//-------- Estadistica de Tienda
      ActuFamilia();//------------ Familias y estadistica
      ActuDeparta();//------------ Departamentos y estadistica
      ActuEstaProveedor();//------ Estadistica de Proveedor

      dbPedid.Next;
      ProgressBar1.Position:=ProgressBar1.Position+1;
      ProgressBar1.Caption:=IntToStr(ProgressBar1.Position); ProgressBar1.Repaint;
    end;
  ActuProveedor();//---------- Proveedor
  ActuTiendas();//------------ Tienda
  ActuHistocc();//------------ Hist. pedidos cabeceras
  ActuHistodd();//------------ Hist. pedidos detalles
  BorrarPedido();//----------- Borrar pedido
  Showmessage('PEDIDO ACEPTADO CORRECTAMENTE!');
  Panel1.Visible:=False; DBGrid1.Enabled:=True;
  BitBtn3.Enabled:=True; BitBtn2.Enabled:=True;
end;

//--------------- Salir entrada de pedidos -----------------
procedure TFEntrada.BitBtn29Click(Sender: TObject);
begin
  Panel11.Visible:=False; DBGrid1.Enabled:=True;
  BitBtn3.Enabled:=True; BitBtn2.Enabled:=True;
end;

//=============================================================================
//======================== ACTUALIZAR LINEAS ==================================
//=============================================================================
//---------------- Articulos (ya esta seleccionado el articulo)
procedure TFEntrada.ActuArticulos();
begin
 dbArti.Edit;
 dbArti.FieldByName('A4').Value:=dbArti.FieldByName('A4').AsFloat+
                                 dbPedid.FieldByName('PD8').AsFloat;//----- Sumar Stock
 dbArti.FieldByName('A11').Value:=dbArti.FieldByName('A11').AsFloat-
                                 dbPedid.FieldByName('PD8').AsFloat;//----- Restar Und. Pendientes
 dbArti.FieldByName('A13').Value:=dbPedic.FieldByName('PC1').Value;//------ Fecha Ult. Compra
 dbArti.FieldByName('A28').Value:=dbPedid.FieldByName('PD26').AsFloat;//--- Precio Tarifa
 dbArti.FieldByName('A29').Value:=dbPedid.FieldByName('PD27').AsFloat;//--- Dto. Importe
 dbArti.FieldByName('A30').Value:=dbPedid.FieldByName('PD28').AsFloat;//--- Dto %1
 dbArti.FieldByName('A31').Value:=dbPedid.FieldByName('PD29').AsFloat;//--- Dto %2
 dbArti.FieldByName('A32').Value:=dbPedic.FieldByName('PC2').Value;//------ Cgo. ultimo proveedor
 dbArti.FieldByName('A37').Value:=dbPedid.FieldByName('PD30').AsFloat;//--- Margen sobre PVP
 dbArti.Post;
end;
//---------------- Estadistica de articulos
procedure TFEntrada.ActuEstaArti();
var
  TxtQ: String;
begin
  dbTrabajo.SQL.Text:='SELECT * from estaarti'+Tienda+' WHERE TA0="'+Codigo+'"'+
                     ' AND TA1='+FormatDateTime('YYYY',Date)+' AND TA2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estaarti'+Tienda+' SET TA3=TA3+'+Cantidad+
          ', TA4=TA4+'+Costo+' WHERE TA0="'+Codigo+'"'+
          ' AND TA1='+FormatDateTime('YYYY',Date)+' AND TA2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estaarti'+Tienda+' (TA0,TA1,TA2,TA3,TA4) VALUES ("'+
          Codigo+'",'+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+Cantidad+','+Costo+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
end;
//---------------- Ultimo pedido
procedure TFEntrada.ActuUltimoPedi();
var
  TxtQ: String;
begin
  dbTrabajo.SQL.Text:='SELECT * from ultimopedi'+Tienda+' WHERE AP0="'+Codigo+'"'+
                     ' AND AP1="'+FormatDateTime('YYYY/MM/DD',dbPedid.FieldByName('PD1').Value)+'"';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE ultimopedi'+Tienda+' SET AP3='+Cantidad+
          ', AP4='+dbPedid.FieldByName('PD10').AsString+' WHERE AP0="'+Codigo+'"'+
          ' AND AP1="'+FormatDateTime('YYYY/MM/DD',dbPedid.FieldByName('PD1').Value)+'"'
  else
    TxtQ:='INSERT INTO ultimopedi'+Tienda+' (AP0,AP1,AP2,AP3,AP4) VALUES ("'+
          Codigo+'","'+FormatDateTime('YYYY/MM/DD',dbPedid.FieldByName('PD1').Value)+'",'+
          dbPedid.FieldByName('PD2').AsString+','+Cantidad+','+
          dbPedid.FieldByName('PD10').AsString+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
end;

//---------------- Tienda y estadisticas tienda
procedure TFEntrada.ActuTiendas();
var
  TxtQ: String;
begin
  dbTrabajo.SQL.Text:='SELECT * from tiendas WHERE T0='+NTienda;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
   begin
    TxtQ:='UPDATE tiendas SET T10="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').Value)+'"'+
          ' WHERE T0='+NTienda;
    dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
   end;
end;
//---------------- Estadistica de tienda
procedure TFEntrada.ActuEstaTiendas();
var
  TxtQ: String;
begin
  dbTrabajo.SQL.Text:='SELECT * from estatien'+Tienda+' WHERE TT0='+NTienda+
                     ' AND TT1='+FormatDateTime('YYYY',Date)+' AND TT2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estatien'+Tienda+' SET TT3=TT3+'+Cantidad+
          ', TT4=TT4+'+Costo+' WHERE TT0='+NTienda+
          ' AND TT1='+FormatDateTime('YYYY',Date)+' AND TT2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estatien'+Tienda+' (TT0,TT1,TT2,TT3,TT4) VALUES ('+
          NTienda+','+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+Cantidad+','+Costo+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
end;

//---------------- Familias y estadisticas
procedure TFEntrada.ActuFamilia();
var
  TxtQ: String;
begin
  dbTrabajo.SQL.Text:='SELECT * from familias'+Tienda+' WHERE F0='+dbArti.FieldByName('A14').AsString;
  dbTrabajo.Active:=True; Departa:='';
  if dbTrabajo.RecordCount<>0 then
   begin
    Departa:=dbTrabajo.FieldByName('F2').AsString;//---- Guardo el departamento
    TxtQ:='UPDATE familias'+Tienda+' SET F4="'+FormatDateTime('YYYY/MM/DD',dbPedid.FieldByName('PD1').Value)+'"'+
          ' WHERE F0='+dbArti.FieldByName('A14').AsString;
    dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
   end;
  //---------- estadistica
  dbTrabajo.SQL.Text:='SELECT * from estafami'+Tienda+' WHERE FF0='+dbArti.FieldByName('A14').AsString+
                     ' AND FF1='+FormatDateTime('YYYY',Date)+' AND FF2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estafami'+Tienda+' SET FF3=FF3+'+Cantidad+
          ', FF4=FF4+'+Costo+' WHERE FF0='+dbArti.FieldByName('A14').AsString+
          ' AND FF1='+FormatDateTime('YYYY',Date)+' AND FF2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estafami'+Tienda+' (FF0,FF1,FF2,FF3,FF4) VALUES ('+
          dbArti.FieldByName('A14').AsString+','+FormatDateTime('YYYY',Date)+','+
          FormatDateTime('MM',Date)+','+Cantidad+','+Costo+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
end;

//---------------- Departamentos y estadisticas
procedure TFEntrada.ActuDeparta();
var
  TxtQ: String;
begin
  if Departa='' then exit;
  dbTrabajo.SQL.Text:='SELECT * from departamentos'+Tienda+' WHERE D0='+Departa;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
   begin
    TxtQ:='UPDATE departamentos'+Tienda+' SET D3="'+FormatDateTime('YYYY/MM/DD',dbPedid.FieldByName('PD1').Value)+'"'+
          ' WHERE D0='+Departa;
    dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
   end;
  //---------- estadistica
  dbTrabajo.SQL.Text:='SELECT * from estadepa'+Tienda+' WHERE DD0='+Departa+
                     ' AND DD1='+FormatDateTime('YYYY',Date)+' AND DD2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estadepa'+Tienda+' SET DD3=DD3+'+Cantidad+
          ', DD4=DD4+'+Costo+' WHERE DD0='+Departa+
          ' AND DD1='+FormatDateTime('YYYY',Date)+' AND DD2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estadepa'+Tienda+' (DD0,DD1,DD2,DD3,DD4) VALUES ('+
          Departa+','+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+Cantidad+','+Costo+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
end;

//---------------- Proveedor
procedure TFEntrada.ActuProveedor();
var
  TxtQ: String;
begin
  dbTrabajo.SQL.Text:='SELECT * from proveedores WHERE P0='+dbPedic.FieldByName('PC2').AsString;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
   begin
    TxtQ:='UPDATE proveedores SET P23="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').Value)+'"'+
          ' WHERE P0='+dbPedic.FieldByName('PC2').AsString;
    dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
   end;
end;
//---------------- Proveedor Estadisticas
procedure TFEntrada.ActuEstaProveedor();
var
  TxtQ: String;
begin
  dbTrabajo.SQL.Text:='SELECT * from estaprove WHERE PP0='+dbPedid.FieldByName('PD2').AsString+
                     ' AND PP1='+FormatDateTime('YYYY',Date)+' AND PP2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estaprove SET PP3=PP3+'+Cantidad+
          ', PP4=PP4+'+Costo+' WHERE PP0='+dbPedid.FieldByName('PD2').AsString+
          ' AND PP1='+FormatDateTime('YYYY',Date)+' AND PP2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estaprove (PP0,PP1,PP2,PP3,PP4) VALUES ('+
          dbPedid.FieldByName('PD2').AsString+','+FormatDateTime('YYYY',Date)+','+
          FormatDateTime('MM',Date)+','+Cantidad+','+Costo+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
end;

//------------------- Historico de pedidos cabeceras
procedure TFEntrada.ActuHistocc();
var
  TxtQ: String;
  Conta: Integer;
begin
  TxtQ:='SELECT * FROM hipedicc'+Tienda+' WHERE HPC0='+dbPedic.Fields[0].AsString+
        ' AND HPC1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND HPC2='+dbPedic.Fields[2].AsString+
        ' AND HPC3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND HPC4='+dbPedic.Fields[4].AsString;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then begin showmessage('ESE PEDIDO YA EXISTE EN EL HISTORICO'); end;
  dbTrabajo.Append;
  for conta:=0 to 27 do
    dbTrabajo.Fields[Conta].Value:=dbPedic.Fields[Conta].Value;
  //------- Vencimientos
  dbTrabajo.FieldByName('HPC20').Value:=DateEdit3.Date;//------- Fecha 1 Vencimiento
  dbTrabajo.FieldByName('HPC21').AsString:=Edit24.text;//------- Importe 1 Vencimiento
  dbTrabajo.FieldByName('HPC22').Value:=DateEdit4.Date;//------- Fecha 2 Vencimiento
  dbTrabajo.FieldByName('HPC23').AsString:=Edit26.text;//------- Importe 2 Vencimiento
  dbTrabajo.FieldByName('HPC24').Value:=DateEdit5.Date;//------- Fecha 3 Vencimiento
  dbTrabajo.FieldByName('HPC25').AsString:=Edit28.text;//------- Importe 3 Vencimiento
  dbTrabajo.FieldByName('HPC26').Value:=DateEdit6.Date;//------- Fecha 3 Vencimiento
  dbTrabajo.FieldByName('HPC27').AsString:=Edit30.text;//------- Importe 3 Vencimiento
  //---- Tipo documento prov.
  if RadioButton17.Checked=true then
   dbTrabajo.FieldByName('HPC28').AsString:='P';//--- Pedido
  if RadioButton18.Checked=true then
   dbTrabajo.FieldByName('HPC28').AsString:='N';//--- Nota
  if RadioButton15.Checked=true then
   dbTrabajo.FieldByName('HPC28').AsString:='A';//--- Albaran
  if RadioButton16.Checked=true then
   dbTrabajo.FieldByName('HPC28').AsString:='F';//--- Factura
  dbTrabajo.FieldByName('HPC29').AsString:=Edit34.Text;//---- N.Documento
  dbTrabajo.FieldByName('HPC30').Value:=DateEdit10.Date;//--- Fecha
  dbTrabajo.FieldByName('HPC31').AsString:=Edit25.Text;//---- Base Imp. 1
  dbTrabajo.FieldByName('HPC32').AsString:=Edit32.Text;//---- Importe IVA 1
  dbTrabajo.FieldByName('HPC33').AsString:=Edit27.Text;//---- Base Imp. 2
  dbTrabajo.FieldByName('HPC34').AsString:=Edit33.Text;//---- Importe IVA 2
  dbTrabajo.FieldByName('HPC35').AsString:=Edit29.Text;//---- Base Imp. 3
  dbTrabajo.FieldByName('HPC36').AsString:=Edit35.Text;//---- Importe IVA 3
  dbTrabajo.FieldByName('HPC37').AsString:=Edit31.Text;//---- Base Imp. 4
  dbTrabajo.FieldByName('HPC38').AsString:=Edit36.Text;//---- Importe IVA 4
  dbTrabajo.FieldByName('HPC43').Value:=dbPedic.FieldByName('PC31').Value;//- Observaciones
  dbTrabajo.FieldByName('HPC44').AsString:=EditOtrosGastos.Text;//---- Importe otros gastos
  dbTrabajo.FieldByName('HPC45').AsString:=dbPedic.Fields[32].AsString;//---- Codigo pedido Tienda Virtual
  dbTrabajo.Post;
end;

//------------------- Historico de pedidos detalles
procedure TFEntrada.ActuHistodd();
var
  TxtQ: String;
  Conta: Integer;
begin
  TxtQ:='SELECT * FROM hipedidd'+Tienda+' WHERE HPD0='+dbPedic.Fields[0].AsString+
        ' AND HPD1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND HPD2='+dbPedic.Fields[2].AsString+
        ' AND HPD3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND HPD4='+dbPedic.Fields[4].AsString;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then begin showmessage('ESE PEDIDO YA EXISTE EN EL HISTORICO'); end;
  dbPedid.First;
  while not dbPedid.EOF do
    begin
      dbTrabajo.Append;
      for conta:=0 to 30 do
        dbTrabajo.Fields[Conta].Value:=dbPedid.Fields[Conta].Value;
      dbTrabajo.Post;
      dbPedid.Next;
    end;
end;

//====================== BORRAR PEDIDO ACEPTADO ========================
procedure TFEntrada.BorrarPedido();
var
  TxtQ: String;
begin
  //-------------- Cabeceras
  TxtQ:='DELETE FROM pedicc'+Tienda+' WHERE PC0='+dbPedic.Fields[0].AsString+
        ' AND PC1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND PC2='+dbPedic.Fields[2].AsString+
        ' AND PC3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND PC4='+dbPedic.Fields[4].AsString;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //-------------- Detalles
  TxtQ:='DELETE FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.Fields[0].AsString+
        ' AND PD1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND PD2='+dbPedic.Fields[2].AsString+
        ' AND PD3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND PD4='+dbPedic.Fields[4].AsString;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  dbPedic.Refresh;
end;

//===================================================================================
//==================== Consultar los nuevos datos del articulo que vienen de cambio
procedure TFEntrada.LeerDatosArticulo();
begin
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbPedid.FieldByName('PD6').AsString+'"';
  dbArti.Active:=True;
  Codigo:=dbPedid.FieldByName('PD6').AsString;//-------- Cgo Articulo
  Cantidad:=dbPedid.FieldByName('PD8').AsString;//------ Unidades
  Precio:=FloatToStr(StrToFloat(Cantidad)*dbArti.FieldByName('A21').AsFloat);//-- Importe de la linea sin iva
  Costo:=FloatToStr(StrToFloat(Cantidad)*dbArti.FieldByName('A24').AsFloat);//--- Costo de la linea sin iva.
end;


//======================= PINTAR LINEAS DEL PEDIDO AL ACEPTARLAS ==============
procedure TFEntrada.PintaLineas();
begin
  StaticText12.Font.Color:=clBlack; StaticText13.Font.Color:=clBlack;
  StaticText14.Font.Color:=clBlack; StaticText15.Font.Color:=clBlack;
  StaticText16.Font.Color:=clBlack; StaticText17.Font.Color:=clBlack;
  StaticText12.Repaint; StaticText13.Repaint; StaticText14.Repaint;
  StaticText15.Repaint; StaticText16.Repaint; StaticText17.Repaint;
  //-----------------------
  StaticText3.Caption:=dbPedid.FieldByName('PD6').AsString;//---- Código
  StaticText3.Repaint;
  StaticText4.Caption:=dbPedid.FieldByName('PD7').AsString;//---- Descripcion
  if StaticText4.Caption<> dbArti.FieldByName('A1').AsString then
    begin StaticText4.Color:=$00C5C5F7; PreciohaCambiado:=True; end;;
  StaticText4.Repaint;
  StaticText5.Caption:=FormatFloat('0.00',dbPedid.FieldByName('PD8').AsFloat);//---- Unidades
  StaticText5.Repaint;
  //-----------------------
  StaticText6.Caption:=FormatFloat('0.00',dbPedid.FieldByName('PD10').AsFloat);//---- Costo Pedido
  StaticText12.Caption:=FormatFloat('0.00',dbArti.FieldByName('A24').AsFloat);//----- Costo Articulo
  if (StaticText6.Caption<>StaticText12.Caption) or (StaticText6.Caption='0.00') then
     begin StaticText12.Color:=$00C5C5F7; PreciohaCambiado:=True; end;
  StaticText6.Repaint; StaticText12.Repaint;

  StaticText7.Caption:=FormatFloat('0.00',dbPedid.FieldByName('PD11').AsFloat);//---- Margen Pedido
  StaticText13.Caption:=FormatFloat('0.00',dbArti.FieldByName('A26').AsFloat);//----- Margen Articulo
  if StaticText7.Caption<>StaticText13.Caption then
     begin StaticText13.Color:=$00C5C5F7; PreciohaCambiado:=True; end;
  StaticText7.Repaint; StaticText13.Repaint;

  StaticText8.Caption:=FormatFloat('0.00',dbPedid.FieldByName('PD12').AsFloat);//---- Precio Pedido
  StaticText14.Caption:=FormatFloat('0.00',dbArti.FieldByName('A21').AsFloat);//----- Precio Articulo
  if StaticText8.Caption<>StaticText14.Caption then
     begin StaticText14.Color:=$00C5C5F7; PreciohaCambiado:=True; end;
  StaticText8.Repaint; StaticText14.Repaint;

  StaticText9.Caption:=IntToStr(dbPedid.FieldByName('PD14').AsInteger);//---- % Iva Pedido
  StaticText15.Caption:=IntToStr(dbArti.FieldByName('A3').AsInteger);//------ % Iva Articulo
  if StaticText9.Caption<>StaticText15.Caption then
     begin StaticText15.Color:=$00C5C5F7; PreciohaCambiado:=True; end;
  StaticText9.Repaint; StaticText15.Repaint;

  StaticText10.Caption:=IntToStr(dbPedid.FieldByName('PD13').AsInteger);//---- % Rec Pedido
  StaticText16.Caption:=IntToStr(dbArti.FieldByName('A36').AsInteger);//------- % Rec Articulo
  if StaticText10.Caption<>StaticText16.Caption then
     begin StaticText16.Color:=$00C5C5F7; PreciohaCambiado:=True; end;
  StaticText10.Repaint; StaticText16.Repaint;


  StaticText11.Caption:=FormatFloat('0.00',dbPedid.FieldByName('PD16').AsFloat);//---- P.V.P. Pedido
  StaticText17.Caption:=FormatFloat('0.00',dbArti.FieldByName('A2').AsFloat);//------- P.V.P. Articulo
  if StaticText11.Caption<>StaticText17.Caption then
     begin StaticText17.Color:=$00C5C5F7; PreciohaCambiado:=True; end;
  StaticText11.Repaint; StaticText17.Repaint;

end;


//============= MOSTRAR DATOS DEL PEDIDO AL MOVERSE POR EL GRID ========
procedure TFEntrada.Datasource1DataChange(Sender: TObject; Field: TField);
begin
  Panel10.Visible:=False;
  LabelCliente.Caption:=''; LabelCliente1.Caption:='';
  LabelCliente2.Caption:=''; LabelCliente3.Caption:='';
  if dbPedic.FieldByName('PC15').AsString='' then exit;
  LabelCliente1.Caption:=dbPedic.FieldByName('PC14').AsString;//---- Codigo cliente
  LabelCliente.Caption:=dbPedic.FieldByName('PC15').AsString;//----- Nombre cliente
  LabelCliente2.Caption:=dbPedic.FieldByName('PC16').AsString;//---- Telefono cliente
  LabelCliente3.Caption:=dbPedic.FieldByName('PC18').AsString;//---- Importe entregado
  Panel10.Visible:=True;
end;

//------------ Pintar Linea en azul si es pedido de clientes ----
procedure TFEntrada.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if dbPedic.FieldByName('PC15').AsString<>'' then
   begin
     DBGrid1.Canvas.Font.Color := clBlue;
     DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
   end;
end;

//========================== TOTALES VENCIMIENTOS =====================
//----------------- Salir de los importes ----------
procedure TFEntrada.Edit24Exit(Sender: TObject);
begin
   if Edit24.Text='' then Edit24.Text:='0.00';
   if Edit26.Text='' then Edit26.Text:='0.00';
   if Edit28.Text='' then Edit28.Text:='0.00';
   if Edit30.Text='' then Edit30.Text:='0.00';
   if VersiNumero(Edit24.Text)=False then
     begin showmessage('1º IMPORTE ERRONEO'); exit; Edit24.SetFocus; end;
   if VersiNumero(Edit26.Text)=False then
     begin showmessage('2º IMPORTE ERRONEO'); exit; Edit26.SetFocus; end;
   if VersiNumero(Edit28.Text)=False then
     begin showmessage('3º IMPORTE ERRONEO'); exit; Edit28.SetFocus; end;
   if VersiNumero(Edit30.Text)=False then
     begin showmessage('4º IMPORTE ERRONEO'); exit; Edit30.SetFocus; end;
   PintarTotalVencimientos();
end;

//---------------- Totales vencimientos ------------
procedure TFEntrada.PintarTotalVencimientos();
begin
  //------------ Suma de vencimientos
  Label46.Caption:=FormatFloat('0.00',StrToFloat(Edit24.Text)+StrToFloat(Edit26.Text)+
                                   StrToFloat(Edit28.Text)+
                                   StrToFloat(Edit30.Text));
  //------ Total Pedido costo+impuestos-suma de vencimientos
  if checkbox1.Checked=true then
    Label47.Caption:=FormatFloat('0.00',dbPedic.FieldByName('PC8').AsFloat+StrToFloat(EditOtrosGastos.Text)-StrToFloat(Label46.Caption))
  else
    Label47.Caption:=FormatFloat('0.00',dbPedic.FieldByName('PC8').AsFloat-StrToFloat(Label46.Caption));
end;

//================== CALCULAR LOS VENCIMIENTOS =======================
procedure TFEntrada.VerVencimientos();//---------------- Ver si tiene vencimientos
var
  TotalFact: Double;
  Plazos: Integer;
  Dias: TDateTime;
begin
  //-------------- El total del pedido mas los gastos si los hay
  if checkbox1.Checked=true then
     TotalFact:=dbPedic.FieldByName('PC8').AsFloat+StrToFloat(EditOtrosGastos.Text)
  else
    TotalFact:=dbPedic.FieldByName('PC8').AsFloat;
  //----------- Plazos de pagos (Vencimientos) --------------------------
  if (TotalFact>dbProve.FieldByName('P21').AsFloat) And (dbProve.FieldByName('P15').AsInteger>0) then
    begin
      Plazos:=dbProve.FieldByName('P17').AsInteger; if Plazos=0 then Plazos:=1;
      Dias:=DateEdit10.Date+dbProve.FieldByName('P15').AsInteger;
      DateEdit3.Text:=FormatDateTime('DD/MM/YYYY',Dias);
      Edit24.Text:=FormatFloat('0.00',TotalFact/Plazos);
      //------------------- Segundo Plazo
      if Plazos>1 then
        begin
          Dias:=Dias+dbProve.FieldByName('P16').AsInteger;
          DateEdit4.Text:=FormatDateTime('DD/MM/YYYY',Dias);
          Edit26.Text:=FormatFloat('0.00',TotalFact/Plazos);
        end;
      //------------------- Tercer Plazo
      if Plazos>2 then
        begin
          Dias:=Dias+dbProve.FieldByName('P16').AsInteger;
          DateEdit5.Text:=FormatDateTime('DD/MM/YYYY',Dias);
          Edit28.Text:=FormatFloat('0.00',TotalFact/Plazos);
        end;
      //------------------- Cuarto Plazo
      if Plazos>3 then
        begin
          Dias:=Dias+dbProve.FieldByName('P16').AsInteger;
          DateEdit6.Text:=FormatDateTime('DD/MM/YYYY',Dias);
          Edit30.Text:=FormatFloat('0.00',TotalFact/Plazos);
        end;
    end;
end;
//=======================================================================
//================ TRANSPORTES / GASTOS VARIOS ==========================
//=======================================================================
procedure TFEntrada.EditOtrosGastosExit(Sender: TObject);
begin
   if EditOtrosGastos.Text='' then EditOtrosGastos.Text:='0.00';
end;

//================ AÑADIR GASTOS A LOS VENCIMIENTOS ======================
procedure TFEntrada.CheckBox1Change(Sender: TObject);
begin
  VerVencimientos();
  PintarTotalVencimientos();
end;

initialization
  {$I entrada.lrs}

end.

