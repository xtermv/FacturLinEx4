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
  Buttons, StdCtrls, ExtCtrls, DBGrids, Grids, EditBtn, db, ZConnection, ZDataset,
  LCLType, LCLIntf, ComCtrls
  {$IFDEF LCLGTK2}
  , gtk2, gdk2
  {$ENDIF}
  ;

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
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid3TitleClick(Column: TColumn);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure RadioGroup2Click(Sender: TObject);
    procedure NumeroPedido();
    procedure Llenacc();
    procedure Llenadd();
    function VerUltimaLinea: Integer;

  private
    { Estado visual de la modernización }
    FOrdenGrid1: String;
    FOrdenGrid3: String;
    FPanelCabecera: TPanel;
    FLabelTitulo: TLabel;
    FLabelSubtitulo: TLabel;
    FPanelFiltros: TPanel;
    FLabelFiltros: TLabel;
    FPanelPie: TPanel;
    FLabelPanelPedido: TLabel;
    FMoviendoPanel8: Boolean;
    FPanel8MovidoPorUsuario: Boolean;
    FPanel8DragOffset: TPoint;

    procedure CrearEstructuraModerna;
    procedure AplicarEstiloModerno;
    procedure RecolocarControles;
    procedure ConfigurarGridModerno(AGrid: TDBGrid);
    procedure DibujarCeldaGrid(AGrid: TDBGrid; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure AplicarOrdenGrid(AGrid: TDBGrid; AQuery: TZQuery;
      Column: TColumn; var AOrden: String);
    procedure MarcarColumnaOrdenada(AGrid: TDBGrid; Column: TColumn;
      const AOrden: String);
    procedure AplicarContrasteSeleccion(AEditControl: TWinControl);
    procedure AplicarContrasteSeleccionControles(AParent: TWinControl);
    procedure CentrarPanel(APanel: TPanel);
    procedure LimitarPanel8AlAreaVisible;
    procedure Panel8DragMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel8DragMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Panel8DragMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
  FOrdenGrid1:='ASC';
  FOrdenGrid3:='ASC';
  FPanelCabecera:=nil;
  FLabelTitulo:=nil;
  FLabelSubtitulo:=nil;
  FPanelFiltros:=nil;
  FLabelFiltros:=nil;
  FPanelPie:=nil;
  FLabelPanelPedido:=nil;
  FMoviendoPanel8:=False;
  FPanel8MovidoPorUsuario:=False;

  KeyPreview:=True;
  OnShow:=@FormShow;
  OnResize:=@FormResize;
  OnKeyDown:=@FormKeyDown;
  DBGrid1.OnTitleClick:=@DBGrid1TitleClick;
  DBGrid3.OnTitleClick:=@DBGrid3TitleClick;
  DBGrid1.OnDrawColumnCell:=@DBGrid1DrawColumnCell;
  DBGrid3.OnDrawColumnCell:=@DBGrid3DrawColumnCell;

  Constraints.MinWidth:=1050;
  Constraints.MinHeight:=720;
  Position:=poScreenCenter;
  WindowState:=wsMaximized;

  CrearEstructuraModerna;
  AplicarEstiloModerno;
  RecolocarControles;

  //----------------- CONEXION -----------------
  Conectate(dbConect);
  ActiveControl:=Edit1;
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
  if Edit3.Text='' then begin showmessage('DEBE ASIGNAR LA FAMILIA DESDE'); exit; end;
  if Edit5.Text='' then begin showmessage('DEBE ASIGNAR LA FAMILIA HASTA'); exit; end;
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
  RadioGroup3.Enabled:=dbTrabajo.RecordCount<>0;
  BitBtn3.Enabled:=dbTrabajo.RecordCount<>0;
  if dbTrabajo.RecordCount=0 then
    StaticText1.Caption:='  RESULTADO · No hay artículos que cumplan los filtros seleccionados'
  else
    StaticText1.Caption:=Format('  RESULTADO · %d artículos propuestos para pedir',
      [dbTrabajo.RecordCount]);
  DBGrid1.Invalidate;
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
  FPanel8MovidoPorUsuario:=False;
  Panel8.Visible:=True;
  RecolocarControles;
  Panel8.BringToFront;
  AplicarContrasteSeleccionControles(Panel8);
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
  { El panel y sus labels permanecen visibles. Solo se activan o
    desactivan los campos de fecha según el criterio seleccionado. }
  Panel1.Enabled:=True;
  DateEdit1.Enabled:=RadioGroup2.ItemIndex>0;
  DateEdit2.Enabled:=RadioGroup2.ItemIndex>0;
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



//================ MODERNIZACIÓN VISUAL Y PRODUCTIVA =================
procedure TFGenerarPed.CrearEstructuraModerna;
begin
  FPanelCabecera:=TPanel.Create(Self);
  FPanelCabecera.Parent:=Self;
  FPanelCabecera.Caption:='';
  FPanelCabecera.BevelOuter:=bvNone;
  FPanelCabecera.Color:=RGBToColor(42,86,132);

  FLabelTitulo:=TLabel.Create(FPanelCabecera);
  FLabelTitulo.Parent:=FPanelCabecera;
  FLabelTitulo.AutoSize:=False;
  FLabelTitulo.Caption:='GENERACIÓN AUTOMÁTICA DE PEDIDOS';
  FLabelTitulo.ParentColor:=True;
  FLabelTitulo.Font.Name:='Sans';
  FLabelTitulo.Font.Height:=-20;
  FLabelTitulo.Font.Style:=[fsBold];
  FLabelTitulo.Font.Color:=clWhite;
  FLabelTitulo.Layout:=tlCenter;

  FLabelSubtitulo:=TLabel.Create(FPanelCabecera);
  FLabelSubtitulo.Parent:=FPanelCabecera;
  FLabelSubtitulo.AutoSize:=False;
  FLabelSubtitulo.Caption:=
    'Seleccione proveedor y familias, calcule la propuesta y revise las líneas antes de crear el pedido.';
  FLabelSubtitulo.ParentColor:=True;
  FLabelSubtitulo.Font.Name:='Sans';
  FLabelSubtitulo.Font.Height:=-12;
  FLabelSubtitulo.Font.Color:=RGBToColor(220,234,246);
  FLabelSubtitulo.Layout:=tlCenter;

  FPanelFiltros:=TPanel.Create(Self);
  FPanelFiltros.Parent:=Self;
  FPanelFiltros.Caption:='';
  FPanelFiltros.BevelOuter:=bvNone;
  FPanelFiltros.Color:=RGBToColor(248,251,254);

  { Los controles del filtro deben ser hijos reales del panel. En GTK,
    un TPanel superpuesto puede ocultar labels y botones hermanos aunque
    se use SendToBack. }
  Label1.Parent:=FPanelFiltros;
  Edit1.Parent:=FPanelFiltros;
  Edit2.Parent:=FPanelFiltros;
  BitBtn18.Parent:=FPanelFiltros;
  Label2.Parent:=FPanelFiltros;
  Edit3.Parent:=FPanelFiltros;
  Edit4.Parent:=FPanelFiltros;
  BitBtn19.Parent:=FPanelFiltros;
  Label3.Parent:=FPanelFiltros;
  Edit5.Parent:=FPanelFiltros;
  Edit6.Parent:=FPanelFiltros;
  BitBtn20.Parent:=FPanelFiltros;

  FLabelFiltros:=TLabel.Create(FPanelFiltros);
  FLabelFiltros.Parent:=FPanelFiltros;
  FLabelFiltros.AutoSize:=False;
  FLabelFiltros.Caption:='DATOS PRINCIPALES DEL FILTRO';
  FLabelFiltros.ParentColor:=True;
  FLabelFiltros.Font.Name:='Sans';
  FLabelFiltros.Font.Height:=-13;
  FLabelFiltros.Font.Style:=[fsBold];
  FLabelFiltros.Font.Color:=RGBToColor(35,68,100);

  FPanelPie:=TPanel.Create(Self);
  FPanelPie.Parent:=Self;
  FPanelPie.Caption:='';
  FPanelPie.BevelOuter:=bvNone;
  FPanelPie.Color:=RGBToColor(232,239,246);

  { Los botones inferiores también son hijos del pie para asegurar su
    visibilidad en GTK y evitar que el panel los tape. }
  BitBtn2.Parent:=FPanelPie;
  BitBtn3.Parent:=FPanelPie;
  BitBtn1.Parent:=FPanelPie;

  FLabelPanelPedido:=TLabel.Create(Panel8);
  FLabelPanelPedido.Parent:=Panel8;
  FLabelPanelPedido.AutoSize:=False;
  FLabelPanelPedido.Caption:='CREAR PEDIDO CON LA PROPUESTA CALCULADA';
  FLabelPanelPedido.Color:=RGBToColor(42,86,132);
  FLabelPanelPedido.ParentColor:=False;
  FLabelPanelPedido.Font.Name:='Sans';
  FLabelPanelPedido.Font.Height:=-15;
  FLabelPanelPedido.Font.Style:=[fsBold];
  FLabelPanelPedido.Font.Color:=clWhite;
  FLabelPanelPedido.Layout:=tlCenter;
  FLabelPanelPedido.Cursor:=crSizeAll;
  FLabelPanelPedido.Hint:='Arrastre esta cabecera para mover el panel';
  FLabelPanelPedido.ShowHint:=True;
  FLabelPanelPedido.OnMouseDown:=@Panel8DragMouseDown;
  FLabelPanelPedido.OnMouseMove:=@Panel8DragMouseMove;
  FLabelPanelPedido.OnMouseUp:=@Panel8DragMouseUp;
  Panel8.OnMouseMove:=@Panel8DragMouseMove;
  Panel8.OnMouseUp:=@Panel8DragMouseUp;
end;

procedure TFGenerarPed.AplicarEstiloModerno;
var
  CNormal, CAzul, CVerde, CGris, CTexto, CBusqueda: TColor;

  procedure EstiloLabel(ALabel: TLabel);
  begin
    if not Assigned(ALabel) then Exit;
    ALabel.ParentFont:=False;
    ALabel.ParentColor:=True;
    ALabel.Font.Name:='Sans';
    ALabel.Font.Height:=-13;
    ALabel.Font.Color:=CTexto;
    ALabel.Layout:=tlCenter;
  end;

  procedure EstiloEdit(AEdit: TEdit);
  begin
    if not Assigned(AEdit) then Exit;
    AEdit.Font.Name:='Sans';
    AEdit.Font.Height:=-13;
    AEdit.Font.Color:=RGBToColor(16,24,32);
    AEdit.Color:=clWhite;
  end;

  procedure EstiloFecha(AFecha: TDateEdit);
  begin
    if not Assigned(AFecha) then Exit;
    AFecha.Font.Name:='Sans';
    AFecha.Font.Height:=-13;
    AFecha.Font.Color:=RGBToColor(16,24,32);
    AFecha.Color:=clWhite;
  end;

  procedure EstiloBoton(ABoton: TBitBtn; AColor, AColorTexto: TColor);
  begin
    if not Assigned(ABoton) then Exit;
    ABoton.ParentFont:=False;
    ABoton.Visible:=True;
    ABoton.Font.Name:='Sans';
    ABoton.Font.Height:=-13;
    ABoton.Font.Style:=[fsBold];
    ABoton.Font.Color:=AColorTexto;
    ABoton.Color:=AColor;
    ABoton.Layout:=blGlyphLeft;
    ABoton.Spacing:=8;
    ABoton.BringToFront;
  end;

begin
  CNormal:=RGBToColor(248,251,254);
  CAzul:=RGBToColor(218,234,248);
  CVerde:=RGBToColor(218,241,228);
  CGris:=RGBToColor(232,236,240);
  CTexto:=RGBToColor(35,52,70);
  CBusqueda:=RGBToColor(205,228,246);

  Caption:='FacturLinEx · Generación automática de pedidos';
  Color:=RGBToColor(241,246,251);
  Font.Name:='Sans';
  Font.Color:=CTexto;

  Label1.Caption:='Proveedor';
  Label2.Caption:='Familia desde';
  Label3.Caption:='Familia hasta';
  EstiloLabel(Label1);
  EstiloLabel(Label2);
  EstiloLabel(Label3);
  EstiloLabel(Label4);
  EstiloLabel(Label5);

  EstiloEdit(Edit1);
  EstiloEdit(Edit2);
  EstiloEdit(Edit3);
  EstiloEdit(Edit4);
  EstiloEdit(Edit5);
  EstiloEdit(Edit6);
  EstiloFecha(DateEdit1);
  EstiloFecha(DateEdit2);
  EstiloEdit(Edit21);
  EstiloEdit(Edit23);
  EstiloEdit(Edit25);
  EstiloFecha(DateEdit9);
  EstiloEdit(Edit34);
  EstiloFecha(DateEdit10);

  BitBtn18.Caption:='...';
  BitBtn18.Hint:='Buscar proveedor por nombre';
  BitBtn18.ShowHint:=True;
  BitBtn19.Caption:='...';
  BitBtn19.Hint:='Buscar familia inicial';
  BitBtn19.ShowHint:=True;
  BitBtn20.Caption:='...';
  BitBtn20.Hint:='Buscar familia final';
  BitBtn20.ShowHint:=True;
  BitBtn40.Caption:='...';
  BitBtn40.Hint:='Buscar proveedor por nombre';
  BitBtn40.ShowHint:=True;
  EstiloBoton(BitBtn18,CBusqueda,RGBToColor(24,67,103));
  EstiloBoton(BitBtn19,CBusqueda,RGBToColor(24,67,103));
  EstiloBoton(BitBtn20,CBusqueda,RGBToColor(24,67,103));
  EstiloBoton(BitBtn40,CBusqueda,RGBToColor(24,67,103));

  BitBtn2.Caption:='Calcular propuesta';
  BitBtn2.Hint:='Aplica los filtros y calcula los artículos y unidades sugeridas';
  BitBtn2.ShowHint:=True;
  EstiloBoton(BitBtn2,CAzul,RGBToColor(28,73,112));

  BitBtn3.Caption:='Crear pedido';
  BitBtn3.Hint:='Revisa los datos finales y crea un pedido con las líneas propuestas';
  BitBtn3.ShowHint:=True;
  BitBtn3.Enabled:=False;
  EstiloBoton(BitBtn3,CVerde,RGBToColor(26,91,62));

  BitBtn1.Caption:='Cerrar';
  BitBtn1.Hint:='Cerrar sin crear ningún pedido';
  BitBtn1.ShowHint:=True;
  EstiloBoton(BitBtn1,CGris,RGBToColor(52,62,72));

  RadioGroup1.Caption:='1. Artículos a considerar';
  RadioGroup1.ParentFont:=False;
  RadioGroup1.Font.Name:='Sans';
  RadioGroup1.Font.Height:=-12;
  RadioGroup1.Font.Color:=CTexto;
  RadioGroup1.Color:=RGBToColor(232,242,251);
  RadioGroup1.ParentColor:=False;

  RadioGroup2.Caption:='2. Condición de reposición';
  RadioGroup2.ParentFont:=False;
  RadioGroup2.Font.Name:='Sans';
  RadioGroup2.Font.Height:=-12;
  RadioGroup2.Font.Color:=CTexto;
  RadioGroup2.Color:=RGBToColor(232,246,237);
  RadioGroup2.ParentColor:=False;

  RadioGroup3.Caption:='Ajuste de unidades';
  RadioGroup3.ParentFont:=False;
  RadioGroup3.Font.Name:='Sans';
  RadioGroup3.Font.Height:=-12;
  RadioGroup3.Font.Color:=CTexto;

  Panel1.Caption:='';
  Panel1.BevelOuter:=bvNone;
  Panel1.Color:=RGBToColor(255,246,224);
  Panel1.ParentColor:=False;
  Label4.Caption:='Desde fecha';
  Label5.Caption:='Hasta fecha';
  Panel1.Enabled:=True;
  DateEdit1.Enabled:=RadioGroup2.ItemIndex>0;
  DateEdit2.Enabled:=RadioGroup2.ItemIndex>0;

  StaticText1.ParentFont:=False;
  StaticText1.Font.Name:='Sans';
  StaticText1.Font.Height:=-14;
  StaticText1.Font.Style:=[fsBold];
  StaticText1.Font.Color:=clWhite;
  StaticText1.Color:=RGBToColor(42,86,132);
  StaticText1.BorderStyle:=sbsNone;
  StaticText1.Alignment:=taLeftJustify;
  StaticText1.Caption:='  RESULTADO · Calcule una propuesta para mostrar los artículos';

  ConfigurarGridModerno(DBGrid1);
  ConfigurarGridModerno(DBGrid3);

  Panel8.Caption:='';
  Panel8.BevelOuter:=bvNone;
  Panel8.Color:=RGBToColor(244,249,253);
  Panel8.ParentColor:=False;
  Bevel2.Style:=bsLowered;
  Bevel3.Style:=bsLowered;
  Label26.Caption:='N.º pedido';
  Label27.Caption:='Fecha del pedido';
  Label28.Caption:='Proveedor';
  Label59.Caption:='N.º documento';
  Label60.Caption:='Fecha documento';
  Label61.Caption:='TIPO Y DOCUMENTO DEL PROVEEDOR';
  EstiloLabel(Label26);
  EstiloLabel(Label27);
  EstiloLabel(Label28);
  EstiloLabel(Label59);
  EstiloLabel(Label60);
  EstiloLabel(Label61);
  Label61.Font.Style:=[fsBold];
  Label61.Font.Color:=RGBToColor(35,68,100);

  RadioButton39.Caption:='Pedido';
  RadioButton32.Caption:='Nota de entrega';
  RadioButton15.Caption:='Albarán';
  RadioButton16.Caption:='Factura';
  RadioButton39.ParentFont:=False;
  RadioButton32.ParentFont:=False;
  RadioButton15.ParentFont:=False;
  RadioButton16.ParentFont:=False;
  RadioButton39.ParentColor:=True;
  RadioButton32.ParentColor:=True;
  RadioButton15.ParentColor:=True;
  RadioButton16.ParentColor:=True;
  RadioButton39.Font.Name:='Sans';
  RadioButton32.Font.Name:='Sans';
  RadioButton15.Font.Name:='Sans';
  RadioButton16.Font.Name:='Sans';
  RadioButton39.Font.Height:=-13;
  RadioButton32.Font.Height:=-13;
  RadioButton15.Font.Height:=-13;
  RadioButton16.Font.Height:=-13;
  RadioButton39.Font.Color:=CTexto;
  RadioButton32.Font.Color:=CTexto;
  RadioButton15.Font.Color:=CTexto;
  RadioButton16.Font.Color:=CTexto;

  BitBtn21.Caption:='Crear pedido';
  BitBtn21.Hint:='Confirma y guarda el nuevo pedido';
  BitBtn21.ShowHint:=True;
  EstiloBoton(BitBtn21,CVerde,RGBToColor(26,91,62));
  BitBtn22.Caption:='Cancelar';
  BitBtn22.Hint:='Cerrar este panel sin crear el pedido';
  BitBtn22.ShowHint:=True;
  EstiloBoton(BitBtn22,CGris,RGBToColor(52,62,72));

  Panel2.Caption:='';
  Panel2.BevelOuter:=bvNone;
  Panel2.Color:=RGBToColor(239,246,252);
  Label6.Caption:='Procesando líneas del pedido...';
  EstiloLabel(Label6);
  Label6.ParentColor:=True;
  Label6.Font.Style:=[fsBold];
  Label6.Font.Color:=RGBToColor(35,68,100);

  AplicarContrasteSeleccionControles(Self);
  FPanelFiltros.Color:=CNormal;

  { Refuerzo final de visibilidad para temas GTK oscuros o personalizados. }
  Label1.ParentColor:=True;
  Label2.ParentColor:=True;
  Label3.ParentColor:=True;
  Label4.ParentColor:=True;
  Label5.ParentColor:=True;
  Label6.ParentColor:=True;
  Label26.ParentColor:=True;
  Label27.ParentColor:=True;
  Label28.ParentColor:=True;
  Label59.ParentColor:=True;
  Label60.ParentColor:=True;
  Label61.ParentColor:=True;
  BitBtn1.Visible:=True;
  BitBtn2.Visible:=True;
  BitBtn3.Visible:=True;
  BitBtn18.Visible:=True;
  BitBtn19.Visible:=True;
  BitBtn20.Visible:=True;
  BitBtn21.Visible:=True;
  BitBtn22.Visible:=True;
  BitBtn40.Visible:=True;
end;

procedure TFGenerarPed.ConfigurarGridModerno(AGrid: TDBGrid);
begin
  if not Assigned(AGrid) then Exit;
  AGrid.ParentFont:=False;
  AGrid.Font.Name:='Sans';
  AGrid.Font.Height:=-13;
  AGrid.Font.Color:=clWindowText;
  AGrid.Color:=clWindow;
  AGrid.FixedColor:=RGBToColor(225,235,245);
  AGrid.TitleFont.Name:='Sans';
  AGrid.TitleFont.Height:=-13;
  AGrid.TitleFont.Style:=[fsBold];
  AGrid.TitleFont.Color:=RGBToColor(30,57,82);
  AGrid.Options:=AGrid.Options+[dgTitles,dgIndicator,dgColumnResize,
    dgColumnMove,dgColLines,dgRowLines,dgRowSelect,dgAlwaysShowSelection];
  AGrid.ScrollBars:=ssAutoBoth;
end;

procedure TFGenerarPed.RecolocarControles;
var
  Margen, CabeceraH, FiltroTop, FiltroH, CriteriosTop, CriteriosH: Integer;
  ResultadoTop, PieH, GridTop, GridH, ColW, Espacio, X1, X2, X3: Integer;
begin
  if not Assigned(FPanelCabecera) then Exit;

  Margen:=18;
  CabeceraH:=78;
  FiltroTop:=CabeceraH+14;
  FiltroH:=154;
  CriteriosTop:=FiltroTop+FiltroH+12;
  CriteriosH:=116;
  PieH:=78;

  FPanelCabecera.SetBounds(0,0,ClientWidth,CabeceraH);
  FLabelTitulo.SetBounds(Margen,10,ClientWidth-(Margen*2),32);
  FLabelSubtitulo.SetBounds(Margen,43,ClientWidth-(Margen*2),24);
  FPanelCabecera.BringToFront;

  FPanelFiltros.SetBounds(Margen,FiltroTop,ClientWidth-(Margen*2),FiltroH);
  FLabelFiltros.SetBounds(14,8,FPanelFiltros.ClientWidth-28,24);
  FPanelFiltros.BringToFront;

  Label1.SetBounds(18,38,112,30);
  Edit1.SetBounds(138,38,110,30);
  Edit2.SetBounds(258,38,FPanelFiltros.ClientWidth-316,30);
  BitBtn18.SetBounds(FPanelFiltros.ClientWidth-44,38,34,30);

  Label2.SetBounds(18,76,112,30);
  Edit3.SetBounds(138,76,110,30);
  Edit4.SetBounds(258,76,FPanelFiltros.ClientWidth-316,30);
  BitBtn19.SetBounds(FPanelFiltros.ClientWidth-44,76,34,30);

  Label3.SetBounds(18,114,112,30);
  Edit5.SetBounds(138,114,110,30);
  Edit6.SetBounds(258,114,FPanelFiltros.ClientWidth-316,30);
  BitBtn20.SetBounds(FPanelFiltros.ClientWidth-44,114,34,30);

  Label1.BringToFront; Edit1.BringToFront; Edit2.BringToFront; BitBtn18.BringToFront;
  Label2.BringToFront; Edit3.BringToFront; Edit4.BringToFront; BitBtn19.BringToFront;
  Label3.BringToFront; Edit5.BringToFront; Edit6.BringToFront; BitBtn20.BringToFront;

  Espacio:=ClientWidth-(Margen*2);
  ColW:=(Espacio-24) div 3;
  X1:=Margen;
  X2:=X1+ColW+12;
  X3:=X2+ColW+12;
  RadioGroup1.SetBounds(X1,CriteriosTop,ColW,CriteriosH);
  RadioGroup2.SetBounds(X2,CriteriosTop,ColW,CriteriosH);
  Panel1.SetBounds(X3,CriteriosTop,ColW,CriteriosH);
  Label4.SetBounds(14,18,100,30);
  DateEdit1.SetBounds(118,18,Panel1.ClientWidth-132,30);
  Label5.SetBounds(14,62,100,30);
  DateEdit2.SetBounds(118,62,Panel1.ClientWidth-132,30);
  RadioGroup3.SetBounds(X3,CriteriosTop,ColW,CriteriosH);

  ResultadoTop:=CriteriosTop+CriteriosH+14;
  StaticText1.SetBounds(Margen,ResultadoTop,ClientWidth-(Margen*2),34);
  GridTop:=ResultadoTop+40;
  GridH:=ClientHeight-PieH-GridTop-12;
  if GridH<150 then GridH:=150;
  DBGrid1.SetBounds(Margen,GridTop,ClientWidth-(Margen*2),GridH);

  FPanelPie.SetBounds(0,ClientHeight-PieH,ClientWidth,PieH);
  BitBtn2.SetBounds(Margen,16,220,46);
  BitBtn3.SetBounds(Margen+234,16,200,46);
  BitBtn1.SetBounds(FPanelPie.ClientWidth-Margen-170,16,170,46);
  BitBtn2.BringToFront;
  BitBtn3.BringToFront;
  BitBtn1.BringToFront;

  Panel8.SetBounds(Panel8.Left,Panel8.Top,720,520);
  FLabelPanelPedido.SetBounds(0,0,Panel8.ClientWidth,42);
  DBGrid3.SetBounds(18,56,Panel8.ClientWidth-36,132);

  Bevel2.SetBounds(18,202,Panel8.ClientWidth-36,118);
  Label26.SetBounds(34,216,96,30);
  Edit21.SetBounds(134,216,120,30);
  Label27.SetBounds(302,216,118,30);
  DateEdit9.SetBounds(424,216,170,30);
  Label28.SetBounds(34,262,96,30);
  Edit23.SetBounds(134,262,110,30);
  Edit25.SetBounds(252,262,Panel8.ClientWidth-252-64,30);
  BitBtn40.SetBounds(Panel8.ClientWidth-52,262,34,30);

  Bevel3.SetBounds(18,336,Panel8.ClientWidth-36,116);
  Label61.SetBounds(34,326,310,28);
  RadioButton39.SetBounds(34,362,92,24);
  RadioButton32.SetBounds(136,362,142,24);
  RadioButton15.SetBounds(288,362,90,24);
  RadioButton16.SetBounds(388,362,90,24);
  Label59.SetBounds(34,406,108,30);
  Edit34.SetBounds(146,406,150,30);
  Label60.SetBounds(326,406,134,30);
  DateEdit10.SetBounds(464,406,190,30);

  BitBtn21.SetBounds(Panel8.ClientWidth-316,468,140,38);
  BitBtn22.SetBounds(Panel8.ClientWidth-162,468,144,38);

  Panel2.SetBounds(Panel2.Left,Panel2.Top,480,112);
  Label6.SetBounds(20,16,Panel2.ClientWidth-40,28);
  ProgressBar1.SetBounds(20,58,Panel2.ClientWidth-40,24);

  if not FPanel8MovidoPorUsuario then
    CentrarPanel(Panel8)
  else
    LimitarPanel8AlAreaVisible;
  CentrarPanel(Panel2);

  if Panel8.Visible then Panel8.BringToFront;
  if Panel2.Visible then Panel2.BringToFront;
end;

procedure TFGenerarPed.FormShow(Sender: TObject);
begin
  AplicarContrasteSeleccionControles(Self);
  RecolocarControles;
  if Panel8.Visible then
  begin
    Panel8.BringToFront;
    if Edit23.CanFocus then Edit23.SetFocus;
  end
  else if Edit1.CanFocus then
    Edit1.SetFocus;
end;

procedure TFGenerarPed.FormResize(Sender: TObject);
begin
  RecolocarControles;
end;

procedure TFGenerarPed.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key<>VK_ESCAPE then Exit;

  if Panel2.Visible then
  begin
    Key:=0;
    Exit;
  end;

  if Panel8.Visible then
  begin
    Key:=0;
    BitBtn22Click(Self);
    Exit;
  end;

  Key:=0;
  BitBtn1Click(Self);
end;

procedure TFGenerarPed.CentrarPanel(APanel: TPanel);
var
  W, H: Integer;
begin
  if (not Assigned(APanel)) or (not (APanel.Parent is TWinControl)) then Exit;
  W:=TWinControl(APanel.Parent).ClientWidth;
  H:=TWinControl(APanel.Parent).ClientHeight;
  APanel.Left:=(W-APanel.Width) div 2;
  APanel.Top:=(H-APanel.Height) div 2;
  if APanel.Left<4 then APanel.Left:=4;
  if APanel.Top<4 then APanel.Top:=4;
end;

procedure TFGenerarPed.DibujarCeldaGrid(AGrid: TDBGrid; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  S: String;
  X, Y, AnchoTexto: Integer;
begin
  if gdSelected in State then
  begin
    AGrid.Canvas.Brush.Color:=RGBToColor(42,86,132);
    AGrid.Canvas.Font.Color:=clWhite;
    AGrid.Canvas.FillRect(Rect);

    if (Column<>nil) and (Column.Field<>nil) then
      S:=Column.Field.DisplayText
    else
      S:='';

    AnchoTexto:=AGrid.Canvas.TextWidth(S);
    X:=Rect.Left+4;
    if Column<>nil then
      case Column.Alignment of
        taCenter:
          X:=Rect.Left+((Rect.Right-Rect.Left-AnchoTexto) div 2);
        taRightJustify:
          X:=Rect.Right-AnchoTexto-4;
      end;
    Y:=Rect.Top+((Rect.Bottom-Rect.Top-AGrid.Canvas.TextHeight(S)) div 2);
    AGrid.Canvas.TextRect(Rect,X,Y,S);
    Exit;
  end;

  AGrid.Canvas.Brush.Color:=clWindow;
  AGrid.Canvas.Font.Color:=clWindowText;
  AGrid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TFGenerarPed.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  DibujarCeldaGrid(DBGrid1,Rect,DataCol,Column,State);
end;

procedure TFGenerarPed.DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  DibujarCeldaGrid(DBGrid3,Rect,DataCol,Column,State);
end;

procedure TFGenerarPed.MarcarColumnaOrdenada(AGrid: TDBGrid; Column: TColumn;
  const AOrden: String);
var
  I: Integer;
  S: String;
begin
  if not Assigned(AGrid) then Exit;
  for I:=0 to AGrid.Columns.Count-1 do
  begin
    S:=AGrid.Columns[I].Title.Caption;
    S:=StringReplace(S,' ▲','',[rfReplaceAll]);
    S:=StringReplace(S,' ▼','',[rfReplaceAll]);
    AGrid.Columns[I].Title.Caption:=S;
  end;

  if not Assigned(Column) then Exit;
  if SameText(AOrden,'ASC') then
    Column.Title.Caption:=Column.Title.Caption+' ▲'
  else
    Column.Title.Caption:=Column.Title.Caption+' ▼';
end;

procedure TFGenerarPed.AplicarOrdenGrid(AGrid: TDBGrid; AQuery: TZQuery;
  Column: TColumn; var AOrden: String);
var
  SQLBase, SQLMayus, OrdenUsado, CampoClave: String;
  P: Integer;
  ValorClave: Variant;
  TieneClave: Boolean;
begin
  if (not Assigned(AGrid)) or (not Assigned(AQuery)) or
     (not Assigned(Column)) or (Column.FieldName='') or
     (not AQuery.Active) then Exit;

  CampoClave:='';
  if AQuery=dbTrabajo then CampoClave:='A0';
  if AQuery=dbSeries then CampoClave:='SF0';
  TieneClave:=(CampoClave<>'') and (AQuery.RecordCount>0);
  if TieneClave then ValorClave:=AQuery.FieldByName(CampoClave).Value;

  AGrid.Enabled:=False;
  AQuery.DisableControls;
  try
    SQLBase:=Trim(AQuery.SQL.Text);
    SQLMayus:=UpperCase(SQLBase);
    P:=Pos(' ORDER BY ',SQLMayus);
    if P>0 then SQLBase:=Trim(Copy(SQLBase,1,P-1));

    OrdenUsado:=AOrden;
    AQuery.Close;
    AQuery.SQL.Text:=SQLBase+' ORDER BY '+Column.FieldName+' '+OrdenUsado;
    AQuery.Open;

    if TieneClave then AQuery.Locate(CampoClave,ValorClave,[]);
    MarcarColumnaOrdenada(AGrid,Column,OrdenUsado);
    if SameText(AOrden,'ASC') then AOrden:='DESC' else AOrden:='ASC';
  finally
    AQuery.EnableControls;
    AGrid.Enabled:=True;
    AGrid.Invalidate;
  end;
end;

procedure TFGenerarPed.DBGrid1TitleClick(Column: TColumn);
begin
  AplicarOrdenGrid(DBGrid1,dbTrabajo,Column,FOrdenGrid1);
end;

procedure TFGenerarPed.DBGrid3TitleClick(Column: TColumn);
begin
  AplicarOrdenGrid(DBGrid3,dbSeries,Column,FOrdenGrid3);
end;

procedure TFGenerarPed.AplicarContrasteSeleccion(AEditControl: TWinControl);
{$IFDEF LCLGTK2}
var
  FondoNormal, TextoNormal, FondoSeleccion, TextoSeleccion: TGdkColor;
  Widget: PGtkWidget;
{$ENDIF}
begin
  if not Assigned(AEditControl) then Exit;
  AEditControl.HandleNeeded;

  {$IFDEF LCLGTK2}
  Widget:=PGtkWidget(AEditControl.Handle);
  if Assigned(Widget) then
  begin
    gdk_color_parse(PChar('#FFFFFF'),@FondoNormal);
    gdk_color_parse(PChar('#101820'),@TextoNormal);
    gtk_widget_modify_base(Widget,GTK_STATE_NORMAL,@FondoNormal);
    gtk_widget_modify_text(Widget,GTK_STATE_NORMAL,@TextoNormal);

    gdk_color_parse(PChar('#2A5684'),@FondoSeleccion);
    gdk_color_parse(PChar('#FFFFFF'),@TextoSeleccion);
    gtk_widget_modify_base(Widget,GTK_STATE_SELECTED,@FondoSeleccion);
    gtk_widget_modify_text(Widget,GTK_STATE_SELECTED,@TextoSeleccion);
  end;
  {$ENDIF}
end;

procedure TFGenerarPed.AplicarContrasteSeleccionControles(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I:=0 to AParent.ControlCount-1 do
  begin
    C:=AParent.Controls[I];
    if C is TCustomEdit then
      AplicarContrasteSeleccion(TWinControl(C));
    if C is TWinControl then
      AplicarContrasteSeleccionControles(TWinControl(C));
  end;
end;

procedure TFGenerarPed.LimitarPanel8AlAreaVisible;
var
  MaxLeft, MaxTop: Integer;
begin
  if (not Assigned(Panel8)) or (not (Panel8.Parent is TWinControl)) then Exit;
  MaxLeft:=TWinControl(Panel8.Parent).ClientWidth-Panel8.Width;
  MaxTop:=TWinControl(Panel8.Parent).ClientHeight-Panel8.Height;
  if MaxLeft<0 then MaxLeft:=0;
  if MaxTop<0 then MaxTop:=0;
  if Panel8.Left<0 then Panel8.Left:=0;
  if Panel8.Top<0 then Panel8.Top:=0;
  if Panel8.Left>MaxLeft then Panel8.Left:=MaxLeft;
  if Panel8.Top>MaxTop then Panel8.Top:=MaxTop;
end;

procedure TFGenerarPed.Panel8DragMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P, OrigenPanel: TPoint;
begin
  if Button<>mbLeft then Exit;
  if not (Sender is TControl) then Exit;
  P:=TControl(Sender).ClientToScreen(Point(X,Y));
  OrigenPanel:=Panel8.ClientToScreen(Point(0,0));
  FPanel8DragOffset:=Point(P.X-OrigenPanel.X,P.Y-OrigenPanel.Y);
  FMoviendoPanel8:=True;
  FPanel8MovidoPorUsuario:=True;
  SetCapture(Panel8.Handle);
end;

procedure TFGenerarPed.Panel8DragMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  P, OrigenPadre: TPoint;
begin
  if (not FMoviendoPanel8) or (not (Sender is TControl)) then Exit;
  P:=TControl(Sender).ClientToScreen(Point(X,Y));
  OrigenPadre:=TWinControl(Panel8.Parent).ClientToScreen(Point(0,0));
  Panel8.Left:=P.X-FPanel8DragOffset.X-OrigenPadre.X;
  Panel8.Top:=P.Y-FPanel8DragOffset.Y-OrigenPadre.Y;
  LimitarPanel8AlAreaVisible;
end;

procedure TFGenerarPed.Panel8DragMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button<>mbLeft then Exit;
  FMoviendoPanel8:=False;
  ReleaseCapture;
  LimitarPanel8AlAreaVisible;
end;


initialization
  {$I generarped.lrs}

end.

