{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010, Nicolas Lopez de Lerma Aymerich
                           <nicolas@puntodev.com>

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

unit generarped;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  Buttons, StdCtrls, ExtCtrls, DBGrids, EditBtn, db, ZConnection, ZDataset,
  LCLType, ComCtrls;

type

  { TFGenerarPed }

  TFGenerarPed = class(TForm)
    Bevel2: TBevel;
    Bevel3: TBevel;
    BitBtn1: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn19: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn21: TBitBtn;
    BitBtn22: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn40: TBitBtn;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    DateEdit1: TDateEdit;
    DateEdit10: TDateEdit;
    DateEdit2: TDateEdit;
    DateEdit9: TDateEdit;
    dbBusca: TZQuery;
    dbConect: TZConnection;
    dbArti: TZQuery;
    dbPedid: TZQuery;
    dbTiendas: TZQuery;
    dbSeries: TZQuery;
    DBGrid3: TDBGrid;
    dbPedic: TZQuery;
    dbTrabajo: TZQuery;
    DBGrid1: TDBGrid;
    dbProve: TZQuery;
    dbFami: TZQuery;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit21: TEdit;
    Edit23: TEdit;
    Edit25: TEdit;
    Edit3: TEdit;
    Edit34: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label59: TLabel;
    Label6: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel8: TPanel;
    ProgressBar1: TProgressBar;
    RadioButton15: TRadioButton;
    RadioButton16: TRadioButton;
    RadioButton32: TRadioButton;
    RadioButton39: TRadioButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    StaticText1: TStaticText;
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn19Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure BitBtn22Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn40Click(Sender: TObject);
    procedure Datasource2DataChange(Sender: TObject; Field: TField);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit23Enter(Sender: TObject);
    procedure Edit23Exit(Sender: TObject);
    procedure Edit25KeyPress(Sender: TObject; var Key: char);
    procedure Edit3Enter(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit5Enter(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure NumeroPedido();
    procedure Llenacc();
    procedure Llenadd();
    function VerUltimaLinea: Integer;

  private
    { private declarations }
  public
    { public declarations }
  end; 

  procedure ShowFormGeneraPed;

var
  FGenerarPed: TFGenerarPed;
  SPEDIDO: String;
  NPEDIDO: Integer;

implementation

{ TFGenerarPed }

Uses
  Global, Funciones, Busquedas;

//============================= CREAR EL FORMULARIO =============================
procedure ShowFormGeneraPed;
begin
  with TFGenerarPed.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFGenerarPed.FormCreate(Sender: TObject);
begin
  //----------------- CONEXION -----------------
  Conectate(dbConect);
end;

//============================= CERRAR FORMULARIO ================================
procedure TFGenerarPed.BitBtn1Click(Sender: TObject);
begin
  Close();
end;
procedure TFGenerarPed.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//============================== CGO. PROVEEDOR ===================================
procedure TFGenerarPed.Edit1Enter(Sender: TObject);
begin
  Edit2.Text := '';
End;
procedure TFGenerarPed.Edit1Exit(Sender: TObject);
begin
  if Edit1.Text='' then exit;
  dbProve.Active:=False;
  dbProve.SQL.Text:='SELECT * FROM proveedores WHERE P0='+Edit1.Text;
  dbProve.Active:=True;
  if dbProve.RecordCount=0 then begin showmessage('ESE PROVEEDOR NO EXISTE'); Edit1.SetFocus; Exit; end;
  Edit2.Text:=dbProve.FieldByName('P1').AsString;
  Edit3.SetFocus;
end;

//============================== BUSCAR PROVEEDOR ================================
procedure TFGenerarPed.BitBtn18Click(Sender: TObject);
begin
   if Edit2.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit2.SetFocus;
     Exit;
  end;
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT P0,P1 FROM proveedores WHERE P1 LIKE "%'+Edit2.Text+'%"',
                                         ['Código','Razón Social'], 'P0');
  if ((Edit1.Text='-') or (Edit1.Text='-1')) then Edit1.Text:='' else Edit1Exit(Edit1);
end;

//========================== FAMILIA DESDE ===============================
procedure TFGenerarPed.Edit3Enter(Sender: TObject);
begin
  Edit4.Text:='';
end;
procedure TFGenerarPed.Edit3Exit(Sender: TObject);
begin
  if Edit3.Text='' then exit;
  dbFami.Active:=False;
  dbFami.SQL.Text:='SELECT * FROM familias'+tienda+' WHERE F0='+Edit3.Text;
  dbFami.Active:=True;
  if (dbFami.RecordCount=0) and (Edit3.Text='0') then begin Edit4.Text:='PRIMERA FAMILIA'; Edit5.SetFocus; exit; end;
  if dbFami.RecordCount=0 then begin showmessage('ESA FAMILIA NO EXISTE'); Edit3.SetFocus; Exit; end;
  Edit4.Text:=dbFami.FieldByName('F1').AsString;
  Edit5.SetFocus;
end;
//-------------- Buscar familia desde ----------------------
procedure TFGenerarPed.BitBtn19Click(Sender: TObject);
begin
  if Edit4.Text='' then begin
    ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
    Edit4.SetFocus;
    Exit;
 end;
 Edit3.Text:=FBusquedas.IniciaBusquedas('SELECT F0,F1 FROM familias'+Tienda+' WHERE F1 LIKE "%'+Edit4.Text+'%"',
                                        ['Código','Descripcion'], 'F0');
 if ((Edit3.Text='-') or (Edit3.Text='-1')) then Edit3.Text:='' else Edit3Exit(Edit3);
end;

//========================== FAMILIA HASTA ===============================
procedure TFGenerarPed.Edit5Enter(Sender: TObject);
begin
  Edit6.Text:='';
end;
procedure TFGenerarPed.Edit5Exit(Sender: TObject);
begin
  if Edit5.Text='' then exit;
  dbFami.Active:=False;
  dbFami.SQL.Text:='SELECT * FROM familias'+tienda+' WHERE F0='+Edit5.Text;
  dbFami.Active:=True;
  if (dbFami.RecordCount=0) and (Edit5.Text='9999') then begin Edit6.Text:='ULTIMA FAMILIA'; RadioGroup1.SetFocus; exit; end;
  if dbFami.RecordCount=0 then begin showmessage('ESA FAMILIA NO EXISTE'); RadioGroup1.SetFocus;; Exit; end;
  Edit6.Text:=dbFami.FieldByName('F1').AsString;
  RadioGroup1.SetFocus;
end;
//-------------- Buscar familia hasta ----------------------
procedure TFGenerarPed.BitBtn20Click(Sender: TObject);
begin
  if Edit5.Text='' then begin
    ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
    Edit5.SetFocus;
    Exit;
 end;
 Edit5.Text:=FBusquedas.IniciaBusquedas('SELECT F0,F1 FROM familias'+Tienda+' WHERE F1 LIKE "%'+Edit6.Text+'%"',
                                        ['Código','Descripcion'], 'F0');
 if ((Edit5.Text='-') or (Edit5.Text='-1')) then Edit5.Text:='' else Edit5Exit(Edit5);
end;
//==================== GENERAR PEDIDO =========================
procedure TFGenerarPed.BitBtn2Click(Sender: TObject);
var
  TxtQ: String;
begin
  if Edit1.Text='' then begin showmessage('DEBE ASIGNAR EL PROVEEDOR'); exit; end;
  if Edit3.Text='' then begin showmessage('DEBE ASIGNAR LA FAMILIAS DESDE'); exit; end;
  if Edit5.Text='' then begin showmessage('DEBE ASIGNAR LA FAMILIAS HASTA'); exit; end;
  RadioGroup3.Enabled:=False;
  //================ Controlar proveedores
  //---------------- De cualquier proveedor
  if RadioGroup1.ItemIndex=0 then
     TxtQ:='SELECT A0,A1,A6-A4 As UNID,A24, (A6-A4)*A24 As IMPOR FROM artitien'+Tienda+' WHERE A6<>0 AND A14>='+Edit3.Text+' AND A14<='+Edit5.Text;
  //---------------- Proveedor ultimo pedido
  if RadioGroup1.ItemIndex=1 then
     TxtQ:='SELECT A0,A1,A6-A4 As UNID,A24, (A6-A4)*A24 As IMPOR FROM artitien'+Tienda+' WHERE A6<>0 AND A14>='+Edit3.Text+' AND A14<='+Edit5.Text+
     ' AND A32='+Edit1.Text;
  //---------------- Proveedor cualquier pedido
  if RadioGroup1.ItemIndex=2 then
     TxtQ:='SELECT DISTINCT A0,A1,A6-A4 As UNID,A24, (A6-A4)*A24 As IMPOR FROM artitien'+Tienda+', ultimopedi'+Tienda+' WHERE A0=AP0 AND A6<>0 AND A14>='+Edit3.Text+' AND A14<='+Edit5.Text+
     ' AND AP2='+Edit1.Text;
  //================ Controlar minimos
  //---------------- Bajo minimos
  if RadioGroup2.ItemIndex=0 then TxtQ:=txtQ+' AND A4<=A5';
  //---------------- Bajo minimos vendidos entre fechas
  if RadioGroup2.ItemIndex=1 then
      TxtQ:=txtQ+' AND A4<=A5 AND A12>="'+FormatDatetime('YYYY/MM/DD',DateEdit1.Date)+'" AND '+
                                 'A12<="'+FormatDatetime('YYYY/MM/DD',DateEdit2.Date)+'"';
  dbTrabajo.SQL.Text:=TxtQ;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then RadioGroup3.Enabled:=True;
end;

//========================= GUARDAR PEDIDO ============================
procedure TFGenerarPed.BitBtn3Click(Sender: TObject);
begin
  if dbTrabajo.Active=False then exit;
  if dbTrabajo.RecordCount=0 then exit;
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin Showmessage('NO SE EN QUE TIENDA FACTURAR'); Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); exit; end;
  Edit23.Text:=''; Edit25.Text:=''; RadioButton39.Checked:=True;
  Edit34.Text:=''; DateEdit10.Text:='';
  DateEdit9.Date:=Date;//----- Fecha por defecto
  dbSeries.Locate('SF0', dbTiendas.Fields[11].AsString, [loCaseInsensitive]);
  Edit21.Text:=IntToStr(dbSeries.FieldByName('SF7').AsInteger+1);
  dbTiendas.Active:=False;
  Panel8.Visible:=True;
  Edit23.SetFocus;
end;

//------------------ ACEPTAR GUARDAR PEDIDO ----------------------------
procedure TFGenerarPed.BitBtn21Click(Sender: TObject);
begin
  if Edit23.Text='' then begin showmessage('DEBE PONER UN PROVEEDOR PARA EL PEDIDO'); exit; end;
  If Application.MessageBox('CREAR UN PEDIDO NUEVO CON DATOS?','FacturLinEx', boxstyle) = IDNO Then
      Exit;


  Panel8.Visible:=False;
  Panel2.Visible:=True;
  Panel2.Repaint;
  ProgressBar1.Max:=dbTrabajo.RecordCount;

  SPEDIDO:=dbSeries.FieldByName('SF0').AsString;
  dbPedic.Active:=False;
  dbPedic.SQL.Text:='SELECT * FROM pedicc'+Tienda+
                    ' ORDER BY PC0 ASC, PC1 DESC, PC2 ASC, PC3 ASC, PC4 DESC';
  dbPedic.Active:=True;
  dbPedic.Append; Llenacc(); dbPedic.Post;
  dbPedid.Active:=False;
  dbPedid.SQL.Text:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic.FieldByName('PC4').AsString;
  dbPedid.Active:=True;
  dbTrabajo.First;
  while not dbTrabajo.EOF do
     begin
       dbArti.Active:=False;
       dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbTrabajo.FieldByName('A0').AsString+'"';
       dbArti.Active:=True;
       if dbArti.RecordCount=0 then continue;
       dbPedid.Append; Llenadd(); dbPedid.Post;
       ProgressBar1.Position:=ProgressBar1.Position+1;
       ProgressBar1.Repaint;
       dbTrabajo.Next;
     end;
  NumeroPedido();//-------------- Aumentar numero de pedido

  Showmessage('PEDIDO REALIZADO CORRECTAMENTE.');
  Panel2.Visible:=False;//----- Cerrar panel nuevo pedido
end;


//--------------- Moverse por la series del pedido ---------------------
procedure TFGenerarPed.Datasource2DataChange(Sender: TObject; Field: TField);
begin
    Edit21.Text:=IntToStr(dbSeries.FieldByName('SF7').AsInteger+1);//--- Cambiar el N.Pedido
end;

//------------------- CANCELAR GUARDAR PEDIDO ---------------------
procedure TFGenerarPed.BitBtn22Click(Sender: TObject);
begin
  Panel8.Visible:=False;
end;

//---------------- Codigo Proveedor -----------------
procedure TFGenerarPed.Edit23Enter(Sender: TObject);
begin
  Edit25.Text:='';
end;
procedure TFGenerarPed.Edit23Exit(Sender: TObject);
begin
  if Edit23.Text='' then exit;
  dbProve.Active:=False;
  dbProve.SQL.Text:='SELECT P0,P1 FROM proveedores WHERE P0='+Edit23.Text;
  dbProve.Active:=True;
  if dbProve.RecordCount=0 then exit;
  Edit25.Text:=dbProve.FieldByName('P1').AsString;
  dbProve.Active:=False;
end;

//---------------- Buscar por nombre proveedor ------
procedure TFGenerarPed.Edit25KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then BitBtn40Click(BitBtn40);
end;
procedure TFGenerarPed.BitBtn40Click(Sender: TObject);
begin
  if Edit25.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit25.SetFocus; Exit; end;
  Edit23.Text := FBusquedas.IniciaBusquedas('SELECT P0, P1, P2 FROM proveedores WHERE P1 LIKE "%'+Edit25.Text+'%"',
           ['Codigo', ' Razón social ', ' Dirección ' ], 'P0' );
  if Edit23.Text<>'' then begin Edit23Exit(Edit23); end;
end;

//==================== LLENAR DATOS CABECERAS =======================
procedure TFGenerarPed.Llenacc();
begin
  dbPedic.FieldByName('PC0').AsString:=NTienda;//---------------- N. Tienda
  dbPedic.FieldByName('PC1').AsDateTime:=DateEdit9.Date;//------- Fecha
  dbPedic.FieldByName('PC2').AsString:=Edit23.Text;//------------ Proveedor
  dbPedic.FieldByName('PC3').AsString:=SPEDIDO;//---------------- Serie Pedido
  dbPedic.FieldByName('PC4').AsString:=Edit21.Text;//------------ N. Pedido
  dbPedic.FieldByName('PC5').AsInteger:=0;//--------------------- N. Lineas
  dbPedic.FieldByName('PC10').AsString:='N';//------------------- Transmitido
  dbPedic.FieldByName('PC11').AsString:='';//------------------- Tipo Transm.
  dbPedic.FieldByName('PC12').AsString:='';//------------------- Destino
  dbPedic.FieldByName('PC13').AsString:=Edit25.Text;//---------- Nombre Proveedor
  //------- Pedido / Nota Entrega / Albaran / Factura
  if RadioButton39.Checked=True then dbPedic.FieldByName('PC28').AsString:='P';
  if RadioButton32.Checked=True then dbPedic.FieldByName('PC28').AsString:='N';
  if RadioButton15.Checked=True then dbPedic.FieldByName('PC28').AsString:='A';
  if RadioButton16.Checked=True then dbPedic.FieldByName('PC28').AsString:='F';
  dbPedic.FieldByName('PC29').AsString:=Edit34.Text;//---------- N. Documento Proveedor
  dbPedic.FieldByName('PC30').AsDateTime:=DateEdit10.Date;//---- Fecha Documento Proveedor
end;

//==================== LLENAR DATOS LINEAS =======================
procedure TFGenerarPed.Llenadd();
begin
  dbPedid.FieldByName('PD0').AsString:=NTienda;//---------------- N. Tienda
  dbPedid.FieldByName('PD1').AsDateTime:=DateEdit9.Date;//------- Fecha
  dbPedid.FieldByName('PD2').AsString:=Edit23.Text;//------------ Proveedor
  dbPedid.FieldByName('PD3').AsString:=SPEDIDO;//---------------- Serie Pedido
  dbPedid.FieldByName('PD4').AsString:=Edit21.Text;//------------ N. Pedido
  dbPedid.FieldByName('PD5').Value:=VerUltimaLinea;//------- N. Linea
  dbPedid.FieldByName('PD6').AsString:=dbArti.FieldByName('A0').AsString;//-------- Codigo articulo
  dbPedid.FieldByName('PD7').AsString:=dbArti.FieldByName('A1').AsString;//-------- Descripcion
  dbPedid.FieldByName('PD8').AsString:=dbTrabajo.FieldByName('UNID').AsString;//--- Unidades
  dbPedid.FieldByName('PD9').AsString:='0';//-------------------------------------- Bonificaciones
  dbPedid.FieldByName('PD10').Value:=dbArti.FieldByName('A24').AsFloat;//---------- Precio de costo (Sin Iva y sin Recargo)
  dbPedid.FieldByName('PD11').Value:=dbArti.FieldByName('A26').AsFloat;//---------- Margen
  dbPedid.FieldByName('PD12').Value:=dbArti.FieldByName('A21').AsFloat;//---------- Precio venta(Sin Iva)
  dbPedid.FieldByName('PD13').AsString:=dbArti.FieldByName('A36').AsString;//------ Recargo de equivalencia
  dbPedid.FieldByName('PD14').Value:=dbArti.FieldByName('A3').AsString;//---------- Tipo de iva
  dbPedid.FieldByName('PD15').Value:=(dbArti.FieldByName('A24').AsFloat*dbArti.FieldByName('A3').AsFloat/100)+dbArti.FieldByName('A24').AsFloat;//--------- Precio de costo (Con Iva)
  dbPedid.FieldByName('PD16').Value:=dbArti.FieldByName('A2').AsFloat;//--------- Precio venta(Con Iva)
  dbPedid.FieldByName('PD17').Value:=dbTrabajo.FieldByName('UNID').AsFloat*((dbArti.FieldByName('A24').AsFloat*dbArti.FieldByName('A3').AsFloat/100)+dbArti.FieldByName('A24').AsFloat);//----------Importe total de costo (Con Iva)
  dbPedid.FieldByName('PD18').AsFloat:=dbTrabajo.FieldByName('UNID').AsFloat*dbArti.FieldByName('A2').AsFloat;//---- Importe total PVP (Con Iva)
  dbPedid.FieldByName('PD19').Value:=dbArti.FieldByName('A14').Value;//-- Familia
  dbPedid.FieldByName('PD20').Value:=dbArti.FieldByName('A4').Value;//----- Stock actual en el momento de pedir
  dbPedid.FieldByName('PD21').AsString:='0';//---------- Unidades vendidas de X a X año actual
  dbPedid.FieldByName('PD22').AsString:='0';//---------- Unidades vendidas de X a X año anterior
  dbPedid.FieldByName('PD23').AsString:='S';//-------------- Recibido S/N (Por defecto siempre si)
  dbPedid.FieldByName('PD24').AsString:='';//--------------- Serie de colores
  dbPedid.FieldByName('PD25').AsString:='';//--------------- Serie de tallas
  dbPedid.FieldByName('PD26').Value:=dbArti.FieldByName('A28').AsFloat;//------ Precio Tarifa
  dbPedid.FieldByName('PD27').Value:=dbArti.FieldByName('A29').AsFloat;//------ Dto Importe
  dbPedid.FieldByName('PD28').Value:=dbArti.FieldByName('A30').AsFloat;//------ Dto % 1
  dbPedid.FieldByName('PD29').Value:=dbArti.FieldByName('A31').AsFloat;//------ Dto % 2
  dbPedid.FieldByName('PD30').Value:=dbArti.FieldByName('A37').AsFloat;//------ Margen sobre PVP
end;

//=================== SACAR EL ULT N. DE LINEA =====================
function TFGenerarPed.VerUltimaLinea: Integer;
begin
  VerUltimaLinea:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(PD5) As ULTIMA FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic.FieldByName('PC4').AsString;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLinea:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;

//================= ACTIVAR ENTRE FECHAS ==================
procedure TFGenerarPed.RadioGroup2Click(Sender: TObject);
begin
  Panel1.Enabled:=False;
  if RadioGroup2.ItemIndex>0 then Panel1.Enabled:=True;
end;

//================= N. DE PEDIDO ===========================
procedure TFGenerarPed.NumeroPedido();
begin
  if SPEDIDO='' then begin SPEDIDO:='';NPEDIDO:=0; Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF7=SF7+1 WHERE SF0="'+SPEDIDO+'"';
  dbSeries.ExecSql;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+SPEDIDO+'"';
  dbSeries.Active:=True;
  if dbSeries.Recordcount=0 then exit;
//  SPEDIDO:=dbSeries.Fields[0].AsString;
  NPEDIDO:=dbSeries.Fields[7].Value;
  dbSeries.Active:=False;
end;



initialization
  {$I generarped.lrs}

end.

