{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2011

  Nicolas Lopez de Lerma Aymerich <nicolas@esdebian.org>

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

unit histofaprov;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ZConnection, ZDataset, DBGrids, db, StdCtrls, DbCtrls, LR_Class,
  LR_DBSet, LCLType, LCLIntf, CheckLst, EditBtn, lr_e_pdf, Process, Grids,
  Menus, Types;

type

  { TFHistofaprov }

  TFHistofaprov = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn17: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn19: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn21: TBitBtn;
    BitBtn22: TBitBtn;
    BitBtn23: TBitBtn;
    BitBtn26: TBitBtn;
    BitBtn29: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn30: TBitBtn;
    BitBtn32: TBitBtn;
    BitBtn33: TBitBtn;
    BitBtn36: TBitBtn;
    BitBtn38: TBitBtn;
    BitBtn39: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn40: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn9: TBitBtn;
    Button1: TButton;
    CheckListBox1: TCheckListBox;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    Datasource3: TDatasource;
    Datasource4: TDatasource;
    DateEdit1: TDateEdit;
    DateEdit10: TDateEdit;
    DateEdit11: TDateEdit;
    DateEdit2: TDateEdit;
    DateEdit3: TDateEdit;
    DateEdit4: TDateEdit;
    DateEdit5: TDateEdit;
    DateEdit6: TDateEdit;
    DateEdit7: TDateEdit;
    DateEdit8: TDateEdit;
    DateEdit9: TDateEdit;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    dbSeries: TZQuery;
    dbTiendas: TZQuery;
    dbTrabajo: TZQuery;
    DBGrid1: TDBGrid;
    dbPedic: TZQuery;
    dbPedid: TZQuery;
    dbProve: TZQuery;
    dbBusca: TZQuery;
    dbArti: TZQuery;
    Edit1: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit2: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit28: TEdit;
    Edit30: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    frTNPDFExport1: TfrTNPDFExport;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
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
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label4: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label5: TLabel;
    Label57: TLabel;
    Label59: TLabel;
    Label6: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LabelCliente: TLabel;
    LabelCliente1: TLabel;
    LabelCliente2: TLabel;
    LabelCliente3: TLabel;
    LabelTotal: TLabel;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel13: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    PopupMenu1: TPopupMenu;
    RadioButton1: TRadioButton;
    RadioButton15: TRadioButton;
    RadioButton16: TRadioButton;
    RadioButton19: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton20: TRadioButton;
    RadioButton21: TRadioButton;
    RadioButton22: TRadioButton;
    RadioButton23: TRadioButton;
    RadioButton24: TRadioButton;
    RadioButton25: TRadioButton;
    RadioButton26: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton32: TRadioButton;
    RadioButton35: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioGroup2: TRadioGroup;
    SaveDialog1: TSaveDialog;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn17Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn19Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure BitBtn22Click(Sender: TObject);
    procedure BitBtn23Click(Sender: TObject);
    procedure BitBtn26Click(Sender: TObject);
    procedure BitBtn29Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn30Click(Sender: TObject);
    procedure BitBtn32Click(Sender: TObject);
    procedure BitBtn33Click(Sender: TObject);
    procedure BitBtn36Click(Sender: TObject);
    procedure BitBtn38Click(Sender: TObject);
    procedure BitBtn39Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn40Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure Datasource1DataChange(Sender: TObject; Field: TField);
    procedure Datasource3DataChange(Sender: TObject; Field: TField);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Edit14Enter(Sender: TObject);
    procedure Edit14Exit(Sender: TObject);
    procedure Edit16Enter(Sender: TObject);
    procedure Edit16Exit(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit23Enter(Sender: TObject);
    procedure Edit23Exit(Sender: TObject);
    procedure Edit24Exit(Sender: TObject);
    procedure Edit25KeyPress(Sender: TObject; var Key: char);
    procedure Edit26Exit(Sender: TObject);
    procedure Edit28Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit30Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGrid3TitleClick(Column: TColumn);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure Panel15Click(Sender: TObject);
    procedure RadioButton19Change(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton25Change(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure MostrarBotonesdd();
    procedure OcultarBotonesdd();
    procedure LimpiaProveedor();
    procedure PintaProveedor();
    procedure Llenadd();
    procedure Llenacc();
    procedure PintarTotalGeneral();
    procedure PintarTotalVencimientos();
    procedure NumeroPedido();
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure ImprimirPedido();
    procedure EtiquetasBarras();
    procedure SumaPendientes(CodiPen, UniPen: String);
    procedure VerRecargo();
    procedure ActuHistocc();
    procedure ActuHistodd();

  private
    FPanelCabecera: TPanel;
    FPanelFiltros: TPanel;
    FLabelCabTitulo: TLabel;
    FLabelCabSubtitulo: TLabel;
    FOrdenCampo1: String;
    FOrdenCampo2: String;
    FOrdenCampo3: String;
    FOrdenAsc1: Boolean;
    FOrdenAsc2: Boolean;
    FOrdenAsc3: Boolean;
    FPanelArrastre: TPanel;
    FArrastrando: Boolean;
    FInicioArrastre: TPoint;
    FBtnGuardarPDF: TBitBtn;
    FBtnPrevisualizarPDF: TBitBtn;
    FBtnImprimirPDF: TBitBtn;
    FBtnExportarCSV: TBitBtn;
    procedure AplicarDisenoModerno;
    procedure ConfigurarBoton(ABoton: TBitBtn; const ACaption, AHint: String;
      AColor: TColor);
    procedure ConfigurarGrid(AGrid: TDBGrid);
    procedure ConfigurarControlesRecursivo(AParent: TWinControl);
    procedure AplicarContrasteSeleccion(AControl: TWinControl);
    procedure AplicarContrasteSeleccionControles(AParent: TWinControl);
    procedure RecolocarControles;
    procedure RecolocarBarraAcciones;
    procedure RecolocarPanelesAuxiliares;
    procedure AjustarPanelEnParent(APanel: TPanel);
    procedure PrepararPanelAuxiliar(APanel: TPanel; const ATitulo: String;
      AColor: TColor; AMinWidth, AMinHeight: Integer);
    procedure PanelCabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanelCabMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure PanelCabMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OrdenarConsulta(AQuery: TZQuery; AGrid: TDBGrid;
      AColumn: TColumn; var ACampo: String; var AAscendente: Boolean);
    procedure ActualizarFlechaOrdenacion(AGrid: TDBGrid; AColumn: TColumn;
      AAscendente: Boolean);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    function GridExportacionActual: TDBGrid;
    function TituloExportacionActual: String;
    procedure PrepararCabeceraExportacion(ACabecera: TStrings);
    function GenerarPDFTemporal(out AFileName: String): Boolean;
    procedure GuardarPDFClick(Sender: TObject);
    procedure PrevisualizarPDFClick(Sender: TObject);
    procedure ImprimirPDFClick(Sender: TObject);
    procedure ExportarCSVClick(Sender: TObject);
    procedure FormularioKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormularioResize(Sender: TObject);
  public
    { public declarations }
  end;

  procedure ShowFormHistoFaProv;

var
  FHistofaprov: TFHistofaprov;
  SPEDIDO,TIPOPEDIDO,NOMBREPEDIDO,LETRAPEDIDO: String;
  SwCrea, NPEDIDO, Pdf: Integer;
  BASE1,BASE2,BASE3,IMPOIVA1,IMPOIVA2,IMPOIVA3,TOTAL1,TOTAL2,TOTAL3: Double;
  IRIVA1,IRIVA2,IRIVA3,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PRIVA1,PRIVA2,PRIVA3:Double;

implementation

{ TFHistofaprov }

uses
  Global, Funciones, Busquedas, uFLXExportGrid
  {$IFDEF LCLGTK2}, gtk2, gdk2, glib2{$ENDIF};

//=============== CREAR EL FORMULARIO ================
procedure ShowFormHistoFaProv;
begin
  with TFHistofaprov.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFHistofaprov.FormCreate(Sender: TObject);
begin
  dbPedic.SQL.Text := 'SELECT * FROM hipedifacc' + Tienda +
    ' ORDER BY HPC0 ASC, HPC1 DESC, HPC2 ASC, HPC3 ASC, HPC4 DESC';
  dbPedic.Active := True;
  Panel4.SendToBack;
  Panel4.Visible := False;
  DBGrid2.SendToBack;
  DBGrid2.Visible := False;

  if IVA1 = 0 then
    ShowMessage('DEBE DEFINIR LOS TIPOS DE IVA EN LA CONFIGURACIÓN');

  TIPOPEDIDO := '';
  NOMBREPEDIDO := 'FACTURAS';
  LETRAPEDIDO := 'LAS';
  Panel4.Align := alClient;

  AplicarDisenoModerno;
  // La impresión original solo corresponde a la vista de líneas.
  // Se fuerza el estado inicial para evitar que aparezca en la pantalla principal.
  OcultarBotonesdd;
end;

//==================== CERRAR PEDIDOS =====================
procedure TFHistofaprov.BitBtn2Click(Sender: TObject);
begin
  dbPedic.Active:=False;
  Close();
end;
procedure TFHistofaprov.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//============== TODOS LOS PEDIDOS POR FECHAS =====================
procedure TFHistofaprov.RadioButton1Click(Sender: TObject);
begin
  Panel2.Visible:=False; Panel3.Visible:=False;
  dbPedic.Active:=False;
  dbPedic.SQL.Text:='SELECT * FROM hipedifacc'+Tienda;
  if TIPOPEDIDO<>'' then dbPedic.SQL.Text:=dbPedic.SQL.Text+' WHERE HPC28="'+TIPOPEDIDO+'"';
  dbPedic.SQL.Text:=dbPedic.SQL.Text+' ORDER BY HPC0 ASC, HPC1 DESC, HPC2 ASC, HPC3 ASC, HPC4 DESC';
  dbPedic.Active:=True; DBGrid1.Enabled:=True;
  StaticText5.Caption:='TODAS '+LETRAPEDIDO+' '+NOMBREPEDIDO+' ORDENADAS POR FECHAS';
end;

//============== PEDIDOS DE UN PROVEEDOR ========================
procedure TFHistofaprov.RadioButton2Click(Sender: TObject);
begin
  Panel2.Visible:=True; Panel3.Visible:=False; Edit1.SetFocus;
  DBGrid1.Enabled:=False; Edit1.SetFocus;
end;

procedure TFHistofaprov.BitBtn3Click(Sender: TObject);
begin
  If Edit1.Text='' then Exit;
  dbPedic.Sql.Text:='SELECT * FROM hipedifacc'+Tienda+' WHERE HPC2='+Edit1.Text;
  if TIPOPEDIDO<>'' then dbPedic.SQL.Text:=dbPedic.SQL.Text+' AND HPC28="'+TIPOPEDIDO+'"';
  dbPedic.SQL.Text:=dbPedic.SQL.Text+' ORDER BY HPC0 ASC, HPC1 DESC, HPC2 ASC, HPC3 ASC, HPC4 DESC';
  dbPedic.Active := True;
  StaticText5.Caption:=NOMBREPEDIDO+' DEL PROVEEDOR: '+Edit1.Text+' '+Edit2.Text;
  If dbPedic.RecordCount=0 then
    begin
      //Showmessage('NO HAY PEDIDOS DE ESTE PROVEEDOR');
      Panel2.Visible:=False; exit;
    end;
  Panel2.Visible:=False;  DBGrid1.Enabled:=True;
end;

//=================== CGO PROVEEDOR FILTRADO =======================
procedure TFHistofaprov.Edit1Enter(Sender: TObject);
begin
   Edit2.Text:='';
end;
procedure TFHistofaprov.Edit1Exit(Sender: TObject);
begin
   If Edit1.Text='' then Exit;
   dbProve.SQL.Text:='SELECT * FROM proveedores WHERE P0='+Edit1.Text;
   dbProve.Active:=True;
   If dbProve.RecordCount=0 then Begin Showmessage('ESE PROVEEDOR NO EXISTE.'); Edit2.SetFocus; Exit; End;
   Edit2.Text:=dbProve.FieldByName('P1').AsString;
end;
//---------------- Buscar por nombre
procedure TFHistofaprov.BitBtn7Click(Sender: TObject);
begin
  if Edit2.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit2.SetFocus; Exit; end;
  Edit1.Text := FBusquedas.IniciaBusquedas('SELECT P0, P1, P2 FROM proveedores WHERE P1 LIKE "'+Edit2.Text+'%"',
           ['Codigo', ' Razón social ', ' Dirección ' ], 'P0' );

  if Edit1.Text<>'' then begin Edit1Exit(Edit1); end;
end;
procedure TFHistofaprov.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then BitBtn7Click(BitBtn7);
end;

//============== PEDIDOS ENTRE FECHAS ========================
procedure TFHistofaprov.RadioButton3Click(Sender: TObject);
begin
  Panel3.Visible:=True; Panel2.Visible:=False;
  DateEdit1.Date:=Date; DateEdit2.Date:=Date;
  DBGrid1.Enabled:=False; DateEdit1.SetFocus;
end;
procedure TFHistofaprov.BitBtn4Click(Sender: TObject);
begin
  If (DateEdit1.Date>DateEdit2.Date) then begin showmessage('LA PRIMERA FECHA ES MAYOR QUE LA SEGUNDA'); exit; end;
  dbPedic.Sql.Text:='SELECT * FROM hipedifacc'+Tienda+' WHERE HPC1>="'+
                    FormatDateTime('YYYY/MM/DD',DateEdit1.Date)+'" AND HPC1<="'+
                    FormatDateTime('YYYY/MM/DD',DateEdit2.Date)+'"';
  if TIPOPEDIDO<>'' then dbPedic.SQL.Text:=dbPedic.SQL.Text+' AND HPC28="'+TIPOPEDIDO+'"';
  dbPedic.SQL.Text:=dbPedic.SQL.Text+' ORDER BY HPC0 ASC, HPC1 DESC, HPC2 ASC, HPC3 ASC, HPC4 DESC';
  dbPedic.Active := True;
  StaticText5.Caption:=NOMBREPEDIDO+'FACTURAS DESDE: '+DateEdit1.Text+' HASTA: '+DateEdit2.Text;
  If dbPedic.RecordCount=0 then
    begin
      //Showmessage('NO HAY PEDIDOS ENTRE ESAS FECHAS');
      Panel3.Visible:=False; DBGrid1.Enabled:=True; exit;
    end;
  Panel3.Visible:=False; DBGrid1.Enabled:=True;
end;

//============= MOSTRAR DATOS DEL PEDIDO AL MOVERSE POR EL GRID ========
procedure TFHistofaprov.Datasource1DataChange(Sender: TObject; Field: TField);
begin
  Panel10.Visible:=False;
  LabelCliente.Caption:=''; LabelCliente1.Caption:='';
  LabelCliente2.Caption:=''; LabelCliente3.Caption:='';
  if dbPedic.FieldByName('HPC15').AsString='' then exit;
  LabelCliente1.Caption:=dbPedic.FieldByName('HPC14').AsString;//---- Codigo cliente
  LabelCliente.Caption:=dbPedic.FieldByName('HPC15').AsString;//----- Nombre cliente
  LabelCliente2.Caption:=dbPedic.FieldByName('HPC16').AsString;//---- Telefono cliente
  LabelCliente3.Caption:=dbPedic.FieldByName('HPC18').AsString;//---- Importe entregado
  Panel10.Visible:=True;
end;
//------------ Pintar Linea en azul si es pedido de clientes ----
procedure TFHistofaprov.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  GridDrawColumnCell(Sender, Rect, DataCol, Column, State);
end;



//=================================================================
//====================== RECUPERAR PEDIDO =========================
//=================================================================
procedure TFHistofaprov.BitBtn9Click(Sender: TObject);
begin
  if dbPedic.RecordCount=0 then
     begin ShowMessage('NO TIENE PEDIDOS PARA RECUPERAR.'); exit; end;
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin Showmessage('NO SE EN QUE TIENDA FACTURAR'); Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); exit; end;
  DateEdit9.Date:=Date;//----- Fecha por defecto
  dbSeries.Locate('SF0', dbTiendas.Fields[11].AsString, [loCaseInsensitive]);
  //---------- Recuperar datos del pedido
  Edit21.Text:=IntToStr(dbSeries.FieldByName('SF7').AsInteger+1);//-- N. Pedido
  Edit23.Text:=dbPedic.FieldByName('HPC2').AsString;//---- Proveedor
  if dbPedic.FieldByName('HPC28').AsString='P' then RadioButton35.Checked:=True;
  if dbPedic.FieldByName('HPC28').AsString='N' then RadioButton32.Checked:=True;
  if dbPedic.FieldByName('HPC28').AsString='A' then RadioButton15.Checked:=True;
  if dbPedic.FieldByName('HPC28').AsString='F' then RadioButton16.Checked:=True;
  Edit34.Text:=dbPedic.FieldByName('HPC29').AsString;//---- N. Documento
  DateEdit10.Text:=dbPedic.FieldByName('HPC30').AsString;//-- Fecha doc.
  //------------------- Seleccionar detalles
  dbPedid.SQL.Text:='SELECT * FROM hipedifadd'+Tienda+' WHERE HPD0='+dbPedic.FieldByName('HPC0').AsString+
                     ' AND HPD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('HPC1').AsDateTime)+'"'+
                     ' AND HPD2='+dbPedic.FieldByName('HPC2').AsString+
                     ' AND HPD3="'+dbPedic.FieldByName('HPC3').AsString+'"'+
                     ' AND HPD4='+dbPedic.FieldByName('HPC4').AsString;
  dbPedid.Active:=True;
  //----------------------------
  dbTiendas.Active:=False; BitBtn23.BringToFront;
  Panel8.Visible:=True;
  Panel1.Enabled:=False; DBGrid1.Enabled:=False;
  Edit23.SetFocus;
end;

//--------------- Moverse por la series del pedido ---------------------
procedure TFHistofaprov.Datasource3DataChange(Sender: TObject; Field: TField);
begin
  Edit21.Text:=IntToStr(dbSeries.FieldByName('SF7').AsInteger+1);//--- Cambiar el N.Pedido
end;


//--------------- Aceptar nuevo pedido -----------------
procedure TFHistofaprov.BitBtn19Click(Sender: TObject);
begin
  if Edit23.Text='' then begin showmessage('DEBE PONER UN PROVEEDOR PARA EL PEDIDO'); exit; end;
  If Application.MessageBox('RECUPERAR ESTE PEDIDO CREANDO UNO NUEVO CON ESTOS DATOS?','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  SPEDIDO:=dbSeries.FieldByName('SF0').AsString;
  NumeroPedido();//-------------- Aumentar numero de pedido
  BitBtn20Click(BitBtn20);//----- Cerrar panel nuevo pedido
  ActuHistocc();//--------- Cabecera de pedidos
  ActuHistodd();//--------- Detalle de pedidos
  ShowMessage('PEDIDO RECUPERADO CORRECTAMENTE');
end;

//---------------- Cancelar nuevo pedido ----------------
procedure TFHistofaprov.BitBtn20Click(Sender: TObject);
begin
  Panel8.Visible:=False;
  Panel1.Enabled:=True; DBGrid1.Enabled:=True;
end;

//---------------- Codigo Proveedor -----------------
procedure TFHistofaprov.Edit23Enter(Sender: TObject);
begin
  Edit25.Text:='';
end;
procedure TFHistofaprov.Edit23Exit(Sender: TObject);
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
procedure TFHistofaprov.Edit25KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then BitBtn40Click(BitBtn40);
end;
procedure TFHistofaprov.BitBtn40Click(Sender: TObject);
begin
  if Edit25.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit25.SetFocus; Exit; end;
  Edit23.Text := FBusquedas.IniciaBusquedas('SELECT P0, P1, P2 FROM proveedores WHERE P1 LIKE "'+Edit25.Text+'%"',
           ['Codigo', ' Razón social ', ' Dirección ' ], 'P0' );
  if Edit23.Text<>'' then begin Edit23Exit(Edit23); end;
end;

//------------------- Historico de pedidos cabeceras
procedure TFHistofaprov.ActuHistocc();
var
  TxtQ: String;
  Conta: Integer;
begin
  TxtQ:='SELECT * FROM pedicc'+Tienda+' WHERE PC0='+dbPedic.Fields[0].AsString+
        ' AND PC1="'+FormatDateTime('yyyy/mm/dd',DateEdit9.Date)+'"'+
        ' AND PC2='+Edit23.Text+
        ' AND PC3="'+SPEDIDO+'"'+
        ' AND PC4='+Edit21.Text;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then begin showmessage('ESE PEDIDO YA EXISTE'); end;
  dbTrabajo.Append;
  dbTrabajo.FieldByName('PC0').Value:=dbPedic.Fields[0].Value;//---- Tienda
  dbTrabajo.FieldByName('PC1').AsDateTime:=DateEdit9.Date;//-------- Fecha
  dbTrabajo.FieldByName('PC2').AsString:=Edit23.Text;//------------- Prov.
  dbTrabajo.FieldByName('PC3').AsString:=SPEDIDO;//----------------- Serie
  dbTrabajo.FieldByName('PC4').AsString:=Edit21.Text;//------------- N.Pedido
  for conta:=5 to 31 do
    dbTrabajo.Fields[Conta].Value:=dbPedic.Fields[Conta].Value;
  dbTrabajo.FieldByName('PC32').AsString:=dbPedic.Fields[45].AsString;
  dbTrabajo.Post;
end;

//------------------- Historico de pedidos detalles
procedure TFHistofaprov.ActuHistodd();
var
  TxtQ: String;
  Conta: Integer;
begin
  TxtQ:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.Fields[0].AsString+
        ' AND PD1="'+FormatDateTime('yyyy/mm/dd',DateEdit9.Date)+'"'+
        ' AND PD2='+Edit23.Text+
        ' AND PD3="'+SPEDIDO+'"'+
        ' AND PD4='+Edit21.Text;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then begin showmessage('ESE PEDIDO YA EXISTE'); end;
  dbPedid.First;
  while not dbPedid.EOF do
    begin
      dbTrabajo.Append;
      dbTrabajo.FieldByName('PD0').Value:=dbPedic.Fields[0].Value;//---- Tienda
      dbTrabajo.FieldByName('PD1').AsDateTime:=DateEdit9.Date;//-------- Fecha
      dbTrabajo.FieldByName('PD2').AsString:=Edit23.Text;//------------- Prov.
      dbTrabajo.FieldByName('PD3').AsString:=SPEDIDO;//----------------- Serie
      dbTrabajo.FieldByName('PD4').AsString:=Edit21.Text;//------------- N.Pedido
      for conta:=5 to 25 do
        dbTrabajo.Fields[Conta].Value:=dbPedid.Fields[Conta].Value;
      dbTrabajo.Post;
      dbPedid.Next;
    end;
end;

//=================================================================
//====================== BORRAR PEDIDO ============================
//=================================================================
procedure TFHistofaprov.BitBtn10Click(Sender: TObject);
begin
  If dbPedic.RecordCount=0 then Begin Showmessage('NO HAY NINGUN FACTURA PARA BORRAR'); Exit; End;
  dbProve.SQL.Text:='SELECT * FROM proveedores WHERE P0='+dbPedic.FieldByName('HPC2').AsString;
  dbProve.Active:=True;
  If dbProve.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL PROVEEDOR '+dbPedic.FieldByName('HPC0').AsString+' ?'); Exit; End;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('CONFIRME EL BORRADO DEL PEDIDO?','FacturLinEx', boxstyle) = IDNO Then Exit;
  //-------- Restar unidades pendientes de la ficha del articulo ---------
  dbPedid.SQL.Text:='SELECT * FROM hipedifadd'+Tienda+' WHERE HPD0='+dbPedic.FieldByName('HPC0').AsString+
                     ' AND HPD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('HPC1').AsDateTime)+'"'+
                     ' AND HPD2='+dbPedic.FieldByName('HPC2').AsString+
                     ' AND HPD3="'+dbPedic.FieldByName('HPC3').AsString+'"'+
                     ' AND HPD4='+dbPedic.FieldByName('HPC4').AsString;
  dbPedid.Active:=True;
  dbPedid.First;
  while not dbPedid.EOF do
    begin
      SumaPendientes(dbPedid.FieldByName('HPD6').AsString,
             FloatToStr(dbPedid.FieldByName('HPD8').AsFloat*-1));//----- Restar unidades pendientes
      dbPedid.Next;
    end;
  dbPedid.Active:=False;
  //-------- Borrar Pedido
  dbTrabajo.SQL.Text:='DELETE FROM hipedifadd'+Tienda+' WHERE HPD0='+dbPedic.FieldByName('HPC0').AsString+
                     ' AND HPD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('HPC1').AsDateTime)+'"'+
                     ' AND HPD2='+dbPedic.FieldByName('HPC2').AsString+
                     ' AND HPD3="'+dbPedic.FieldByName('HPC3').AsString+'"'+
                     ' AND HPD4='+dbPedic.FieldByName('HPC4').AsString;
  dbTrabajo.ExecSQL;//-- Borrar lineas del pedido
  dbPedic.Delete;//----- Borrar cabecera del pedidos
end;

//==================================================================
//===================== GESTIONAR PEDIDOS ==========================
//==================================================================
procedure TFHistofaprov.BitBtn1Click(Sender: TObject);
begin
  If dbPedic.RecordCount=0 then Begin Showmessage('NO HAY NINGUN PEDIDO PARA GESTIONAR'); Exit; End;
  dbProve.SQL.Text:='SELECT * FROM proveedores WHERE P0='+dbPedic.FieldByName('HPC2').AsString;
  dbProve.Active:=True;
  If dbProve.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL PROVEEDOR '+dbPedic.FieldByName('HPC2').AsString+' ?'); Exit; End;
  Panel4.BringToFront; Panel4.Visible:=True;
  DBGrid2.BringToFront; DBGrid2.Visible:=True;
  MostrarBotonesdd();
  LimpiaProveedor();
  dbPedid.SQL.Text:='SELECT * FROM hipedifadd'+Tienda+' WHERE HPD0='+dbPedic.FieldByName('HPC0').AsString+
                     ' AND HPD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('HPC1').AsDateTime)+'"'+
                     ' AND HPD2='+dbPedic.FieldByName('HPC2').AsString+
                     ' AND HPD3="'+dbPedic.FieldByName('HPC3').AsString+'"'+
                     ' AND HPD4='+dbPedic.FieldByName('HPC4').AsString;
  dbPedid.Active:=True;
  PintaProveedor();
  Label48.Caption:=dbPedic.FieldByName('HPC3').AsString;//---- Serie
  Label31.Caption:=dbPedic.FieldByName('HPC4').AsString;//---- N. Pedido
  Label33.Caption:=dbPedic.FieldByName('HPC1').AsString;//---- Fecha Pedido
  LabelTotal.Caption:=FormatFloat('###,###,##0.00',dbPedic.FieldByName('HPC8').AsFloat);
end;

//---------------- PINTAR LINEAS RECIBIDAS EN ROJO ----------------
procedure TFHistofaprov.DBGrid2DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  GridDrawColumnCell(Sender, Rect, DataCol, Column, State);
end;

//===================== MARCAR DESMARCAR LINEAS ============================
procedure TFHistofaprov.MenuItem3Click(Sender: TObject);
var
  Marca: String;
begin
  Marca:='S';
  if dbPedic.FieldByName('HPC46').AsString='S' then Marca:='N';
  dbPedic.Edit; dbPedic.FieldByName('HPC46').AsString:=Marca; dbPedic.Post;
end;

//======================== DATOS DOCUMENTO PROVEEDOR =======================
procedure TFHistofaprov.MenuItem2Click(Sender: TObject);
begin
  Panel16.Visible:=True;
  Edit35.Text:=''; DateEdit11.Clear;
  Edit35.Text:=dbPedic.FieldByName('HPC29').AsString;//------------- Numero Documento Proveedor
  if dbPedic.FieldByName('HPC30').AsString<>'' then
     DateEdit11.Date:=dbPedic.FieldByName('HPC30').AsDateTime;//---- Fecha Documento Proveedor

end;

//-------------- Salir doc. proveedor ---------
procedure TFHistofaprov.BitBtn38Click(Sender: TObject);
begin
  Panel16.Visible:=False;
end;
//-------------- Modificar doc. proveedor ---------
procedure TFHistofaprov.BitBtn39Click(Sender: TObject);
begin
  If Application.MessageBox('MODIFICAR LOS DATOS DEL DOCUMENTO DEL PROVEEDOR?','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbPedic.Edit;
  //------- Albaran o Factura
  dbPedic.FieldByName('HPC29').AsString:=Edit35.Text;//---------- N. Documento Proveedor
  dbPedic.FieldByName('HPC30').AsDateTime:=DateEdit11.Date;//---- Fecha Documento Proveedor
  dbPedic.Post;
  BitBtn38Click(BitBtn38);
end;


//==================== LLENAR DATOS CABECERAS =======================
procedure TFHistofaprov.Llenacc();
begin
  dbPedic.FieldByName('HPC0').AsString:=NTienda;//---------------- N. Tienda
  dbPedic.FieldByName('HPC1').AsDateTime:=DateEdit9.Date;//------- Fecha
  dbPedic.FieldByName('HPC2').AsString:=Edit23.Text;//------------ Proveedor
  dbPedic.FieldByName('HPC3').AsString:=SPEDIDO;//---------------- Serie Pedido
  dbPedic.FieldByName('HPC4').AsString:=Edit21.Text;//------------ N. Pedido
  dbPedic.FieldByName('HPC5').AsInteger:=0;//--------------------- N. Lineas
  dbPedic.FieldByName('HPC10').AsString:='N';//------------------- Transmitido
  dbPedic.FieldByName('HPC11').AsString:='';//------------------- Tipo Transm.
  dbPedic.FieldByName('HPC12').AsString:='';//------------------- Destino
  dbPedic.FieldByName('HPC13').AsString:=Edit25.Text;//---------- Nombre Proveedor
  //------- Pedido, Nota, Albaran o Factura
  if RadioButton35.Checked=True then dbPedic.FieldByName('HPC28').AsString:='P';
  if RadioButton32.Checked=True then dbPedic.FieldByName('HPC28').AsString:='N';
  if RadioButton15.Checked=True then dbPedic.FieldByName('HPC28').AsString:='A';
  if RadioButton16.Checked=True then dbPedic.FieldByName('HPC28').AsString:='F';

  dbPedic.FieldByName('HPC29').AsString:=Edit34.Text;//---------- N. Documento Proveedor
  dbPedic.FieldByName('HPC30').AsDateTime:=DateEdit10.Date;//---- Fecha Documento Proveedor
end;


//==================== LLENAR DATOS LINEAS =======================
procedure TFHistofaprov.Llenadd();
begin
{  // -- Si esta creando nueva
  if Edit5.Enabled=true then
    begin
     dbPedid.FieldByName('PD0').Value:=dbPedic.FieldByName('PC0').Value;//----- N. Tienda
     dbPedid.FieldByName('PD1').Value:=dbPedic.FieldByName('PC1').Value;//----- Fecha
     dbPedid.FieldByName('PD2').Value:=dbPedic.FieldByName('PC2').Value;//----- Proveedor
     dbPedid.FieldByName('PD3').Value:=dbPedic.FieldByName('PC3').Value;//----- Serie
     dbPedid.FieldByName('PD4').Value:=dbPedic.FieldByName('PC4').Value;//----- N. Pedido
     //dbPedid.FieldByName('PD5').Value:=0;//------- N. Linea
     dbPedid.FieldByName('PD6').AsString:=Edit5.Text;//-------- Codigo articulo
    end;
  dbPedid.FieldByName('PD7').AsString:=Edit6.Text;//----------- Descripcion
  dbPedid.FieldByName('PD8').AsString:=Edit7.Text;//----------- Unidades
  dbPedid.FieldByName('PD9').AsString:='0';//------------------ Bonificaciones
  dbPedid.FieldByName('PD10').AsString:=Edit8.Text;//---------- Precio de costo (Sin Iva y sin Recargo)
  dbPedid.FieldByName('PD11').AsString:=Edit11.Text;//--------- Margen
  dbPedid.FieldByName('PD12').AsString:=Edit31.Text;//--------- Precio venta(Sin Iva)

  dbPedid.FieldByName('PD13').AsString:=Edit18.Text;//--------- Recargo de equivalencia

  dbPedid.FieldByName('PD14').Value:=Edit9.Text;//------------- Tipo de iva
  dbPedid.FieldByName('PD15').AsString:=Edit10.Text;//--------- Precio de costo (Con Iva)
  dbPedid.FieldByName('PD16').AsString:=Edit12.Text;//--------- Precio venta(Con Iva)
  dbPedid.FieldByName('PD17').AsString:=Edit13.Text;//----------Importe total de costo (Con Iva)
  dbPedid.FieldByName('PD18').AsFloat:=StrToFloat(Edit7.Text)*StrToFloat(Edit12.Text);//---- Importe total PVP (Con Iva)
  dbPedid.FieldByName('PD19').Value:=dbArti.FieldByName('A14').Value;//-- Familia
  //---- Si crea la linea poner los datos de las ventas
  if Edit5.Enabled=True then
    begin
      dbPedid.FieldByName('PD20').Value:=dbArti.FieldByName('A4').Value;//----- Stock actual en el momento de pedir

      dbPedid.FieldByName('PD21').AsString:='0';//---------- Unidades vendidas de X a X año actual
      dbPedid.FieldByName('PD22').AsString:='0';//---------- Unidades vendidas de X a X año anterior
    end;

  dbPedid.FieldByName('PD23').AsString:='S';//--------- Recibido S/N (Por defecto siempre si)
  dbPedid.FieldByName('PD24').AsString:='';//---------- Serie de colores
  dbPedid.FieldByName('PD25').AsString:='';//---------- Serie de tallas

  dbPedid.FieldByName('PD26').Value:=Edit19.Text;//------ Precio Tarifa
  dbPedid.FieldByName('PD27').AsString:=Edit22.Text;//--- Dto Importe
  dbPedid.FieldByName('PD28').AsString:=Edit27.Text;//--- Dto % 1
  dbPedid.FieldByName('PD29').AsString:=Edit29.Text;//----Dto % 2
  }
end;

//====================================================================
//===================== LISTADO DE PEDIDOS CABECERAS =================
//====================================================================
procedure TFHistofaprov.BitBtn23Click(Sender: TObject);
begin
  Panel9.Visible:=True; Panel9.BringToFront;
  DateEdit7.Date:=StrToDate('01'+FormatDateTime('/MM/YYYY',Date));
  DateEdit8.Date:=Date; Edit14.SetFocus;
end;

//-------------- Primer proveedor -----------------
procedure TFHistofaprov.Edit14Enter(Sender: TObject);
begin
   Edit15.Text:='';
end;
procedure TFHistofaprov.Edit14Exit(Sender: TObject);
begin
   if Edit14.Text='' then Edit14.Text:='1';
   dbProve.Active:=False;
   dbProve.SQL.Text:='SELECT P0,P1 FROM proveedores WHERE P0='+Edit14.Text;
   dbProve.Active:=True;
   if dbProve.RecordCount=0 then exit;
   Edit15.Text:=dbProve.FieldByName('P1').AsString;
   dbProve.Active:=False;
end;
//-------------- Ultimo proveedor -----------------
procedure TFHistofaprov.Edit16Enter(Sender: TObject);
begin
   Edit17.Text:='';
end;
procedure TFHistofaprov.Edit16Exit(Sender: TObject);
begin
   if (Edit16.Text='') or (Edit16.Text=ClienteVario) then begin Edit16.Text:=ClienteVario; exit; end;
   dbProve.Active:=False;
   dbProve.SQL.Text:='SELECT P0,P1 FROM proveedores WHERE P0='+Edit16.Text;
   dbProve.Active:=True;
   if dbProve.RecordCount=0 then exit;
   Edit17.Text:=dbProve.FieldByName('P1').AsString;
   dbProve.Active:=False;
end;

//--------------- Aceptar listado de pedidos -------------------
procedure TFHistofaprov.BitBtn21Click(Sender: TObject);
begin
  If (Edit14.Text='') or (Edit16.Text='') then Exit;
  dbBusca.Sql.Text:='SELECT *,P1 FROM hipedifacc'+Tienda+', proveedores WHERE HPC2=P0'+
                    ' AND HPC1>="'+FormatDateTime('YYYY/MM/DD',DateEdit7.Date)+'"'+
                    ' AND HPC1<="'+FormatDateTime('YYYY/MM/DD',DateEdit8.Date)+'"'+
                    ' AND HPC2>='+Edit14.Text+' AND HPC2<='+Edit16.Text+' ORDER BY HPC2 ASC, HPC1 DESC, HPC3 DESC';
  dbBusca.Active := True;
  If dbBusca.RecordCount=0 then
    begin
      Showmessage('NO HAY PEDIDOS ENTRE ESOS DATOS');
      exit;
    end;
  frDBDataSet1.DataSet:=dbBusca;
  frReport1.LoadFromFile(RutaReports+'HiListaPedidos.lrf');
  frReport1.ShowReport;
end;

//--------------- Cerrar listado de pedidos -------------------
procedure TFHistofaprov.BitBtn22Click(Sender: TObject);
begin
  Panel9.Visible:=False; Panel9.SendToBack;
end;

//================================================================
//======================= OBSERVACIONES ==========================
//================================================================
procedure TFHistofaprov.BitBtn16Click(Sender: TObject);
begin
  Panel7.Visible:=True;
  Memo1.Lines.Text:=dbPedic.FieldByName('HPC31').AsString;
  Memo1.SetFocus;
end;
//--------------- Aceptar Observaciones --------
procedure TFHistofaprov.BitBtn18Click(Sender: TObject);
begin
  dbPedic.Edit;
  dbPedic.FieldByName('HPC31').AsString:=Memo1.Lines.Text;
  dbPedic.Post;
  Panel7.Visible:=False;
end;

//--------------- Cancelar Observaciones --------
procedure TFHistofaprov.BitBtn17Click(Sender: TObject);
begin
  Panel7.Visible:=False;
end;


//=======================================================================
//========================= VENCIMIENTOS ================================
//=======================================================================
procedure TFHistofaprov.BitBtn26Click(Sender: TObject);
begin
  Panel11.Visible:=True; DateEdit3.Clear; DateEdit4.Clear;
  DateEdit5.Clear; DateEdit6.Clear;
  Label46.Caption:='0.00'; Label47.Caption:=FormatFloat('0.00',dbPedic.FieldByName('HPC8').AsFloat);
  if dbPedic.FieldByName('HPC20').AsString<>'' then
     DateEdit3.Date:=dbPedic.FieldByName('HPC20').AsDateTime;
  Edit24.Text:=FormatFloat('0.00',dbPedic.FieldByName('HPC21').AsFloat);
  if dbPedic.FieldByName('HPC22').AsString<>'' then
     DateEdit4.Date:=dbPedic.FieldByName('HPC22').AsDateTime;
  Edit26.Text:=FormatFloat('0.00',dbPedic.FieldByName('HPC23').AsFloat);
  if dbPedic.FieldByName('HPC24').AsString<>'' then
     DateEdit5.Date:=dbPedic.FieldByName('HPC24').AsDateTime;
  Edit28.Text:=FormatFloat('0.00',dbPedic.FieldByName('HPC25').AsFloat);
  if dbPedic.FieldByName('HPC26').AsString<>'' then
     DateEdit6.Date:=dbPedic.FieldByName('HPC26').AsDateTime;
  Edit30.Text:=FormatFloat('0.00',dbPedic.FieldByName('HPC27').AsFloat);
  //------------ Suma de vencimientos
  Label46.Caption:=FormatFloat('0.00',dbPedic.FieldByName('HPC21').AsFloat+
                                   dbPedic.FieldByName('HPC23').AsFloat+
                                   dbPedic.FieldByName('HPC25').AsFloat+
                                   dbPedic.FieldByName('HPC27').AsFloat);
  //------ Total Pedido costo+impuestos-suma de vencimientos
  Label47.Caption:=FormatFloat('0.00',dbPedic.FieldByName('HPC8').AsFloat-StrToFloat(Label46.Caption));
end;

//----------------- Importe 1 ------------
procedure TFHistofaprov.Edit24Exit(Sender: TObject);
begin
  if Edit24.Text='' then Edit24.Text:='0.00';
  PintarTotalVencimientos();
end;

//----------------- Importe 2 ------------
procedure TFHistofaprov.Edit26Exit(Sender: TObject);
begin
  if Edit26.Text='' then Edit26.Text:='0.00';
  PintarTotalVencimientos();
end;

//----------------- Importe 3 ------------
procedure TFHistofaprov.Edit28Exit(Sender: TObject);
begin
  if Edit28.Text='' then Edit28.Text:='0.00';
  PintarTotalVencimientos();
end;

//----------------- Importe 4 ------------
procedure TFHistofaprov.Edit30Exit(Sender: TObject);
begin
  if Edit30.Text='' then Edit30.Text:='0.00';
  PintarTotalVencimientos();
end;

//---------------- Totales vencimientos ------------
procedure TFHistofaprov.PintarTotalVencimientos();
begin
  //------------ Suma de vencimientos
  Label46.Caption:=FormatFloat('0.00',StrToFloat(Edit24.Text)+StrToFloat(Edit26.Text)+
                                   StrToFloat(Edit28.Text)+
                                   StrToFloat(Edit30.Text));
  //------ Total Pedido costo+impuestos-suma de vencimientos
  Label47.Caption:=FormatFloat('0.00',dbPedic.FieldByName('HPC8').AsFloat-StrToFloat(Label46.Caption));
end;

//========================= SALIR DE VENCIMIENTOS ======================
procedure TFHistofaprov.BitBtn29Click(Sender: TObject);
begin
  Panel11.Visible:=False;
end;

//======================= ACEPTAR DE VENCIMIENTOS ======================
procedure TFHistofaprov.BitBtn30Click(Sender: TObject);
begin
  dbPedic.Edit;
  //--------------- Venc. 1
  if StrToFloat(Edit24.Text)=0 then
    dbPedic.FieldByName('HPC20').Value:=Null
  else
    dbPedic.FieldByName('HPC20').Value:=DateEdit3.Date;
  dbPedic.FieldByName('HPC21').AsString:=Edit24.Text;
  //--------------- Venc. 2
  if StrToFloat(Edit26.Text)=0 then
    dbPedic.FieldByName('HPC22').Value:=Null
  else
    dbPedic.FieldByName('HPC22').Value:=DateEdit4.Date;
  dbPedic.FieldByName('HPC23').AsString:=Edit26.Text;
  //--------------- Venc. 3
  if StrToFloat(Edit28.Text)=0 then
    dbPedic.FieldByName('HPC24').Value:=Null
  else
    dbPedic.FieldByName('HPC24').Value:=DateEdit5.Date;
  dbPedic.FieldByName('HPC25').AsString:=Edit28.Text;
  //--------------- Venc. 4
  if StrToFloat(Edit30.Text)=0 then
    dbPedic.FieldByName('HPC26').Value:=Null
  else
    dbPedic.FieldByName('HPC26').Value:=DateEdit6.Date;
  dbPedic.FieldByName('HPC27').AsString:=Edit30.Text;
  dbPedic.Post; Panel11.Visible:=False;
end;

//======================= SALIR DE GESTIONAR PEDIDOS =====================
procedure TFHistofaprov.BitBtn5Click(Sender: TObject);
var
 Posi: Integer;
 TxtQ: String;
begin
  Panel7.Visible:=False;
  Panel13.Visible:=False;
  Panel4.SendToBack; Panel4.Visible:=False;
  DBGrid2.SendToBack; DBGrid2.Visible:=False;
  OcultarBotonesdd();
  //------------- Si el pedido no tiene lineas borrarlo?
  If dbPedid.RecordCount=0 then
     begin
       boxstyle :=  MB_ICONQUESTION + MB_YESNO;
       If Application.MessageBox('CONFIRME EL BORRADO DEL PEDIDO COMPLETO?','FacturLinEx', boxstyle) = IDNO Then
          Exit;
       dbPedic.Delete;
       Exit;
     end;
  //------------- Actualizar cabecera pedidos
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT COUNT(*), SUM(HPD8), SUM(HPD8*HPD10), SUM(HPD17), SUM(HPD18) FROM hipedifadd'+Tienda+' WHERE'+
                     ' HPD0='+dbPedic.FieldByName('HPC0').AsString+
                     ' AND HPD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('HPC1').AsDateTime)+'"'+
                     ' AND HPD2='+dbPedic.FieldByName('HPC2').AsString+
                     ' AND HPD3="'+dbPedic.FieldByName('HPC3').AsString+'"'+
                     ' AND HPD4='+dbPedic.FieldByName('HPC4').AsString;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then exit;
  TxtQ:='UPDATE hipedifacc'+Tienda+' SET HPC5='+dbTrabajo.Fields[0].AsString+', HPC6='+dbTrabajo.Fields[1].AsString+
        ', HPC7='+dbTrabajo.Fields[2].AsString+', HPC8='+dbTrabajo.Fields[3].AsString+
        ', HPC9='+dbTrabajo.Fields[4].AsString+
        ' WHERE HPC0='+dbPedic.FieldByName('HPC0').AsString+
        ' AND HPC1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('HPC1').AsDateTime)+'"'+
        ' AND HPC2='+dbPedic.FieldByName('HPC2').AsString+
        ' AND HPC3="'+dbPedic.FieldByName('HPC3').AsString+'"'+
        ' AND HPC4='+dbPedic.FieldByName('HPC4').AsString;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  Posi:=dbPedic.RecNo; dbPedic.Refresh; dbPedic.RecNo:=Posi;
end;

//================== PINTAR TOTAL GENERAL ===============
procedure TFHistofaprov.PintarTotalGeneral();
begin
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT SUM(HPD17) FROM hipedifadd'+Tienda+' WHERE'+
                     ' HPD0='+dbPedic.FieldByName('HPC0').AsString+
                     ' AND HPD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('HPC1').AsDateTime)+'"'+
                     ' AND HPD2='+dbPedic.FieldByName('HPC2').AsString+
                     ' AND HPD3="'+dbPedic.FieldByName('HPC3').AsString+'"'+
                     ' AND HPD4='+dbPedic.FieldByName('HPC4').AsString;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then LabelTotal.Caption:='0.00'
  else LabelTotal.Caption:=FormatFloat('0.00',dbTrabajo.Fields[0].AsFloat);
  dbTrabajo.Active:=False;
end;

//====================== MOSTRAR BOTONES DD ====================
procedure TFHistofaprov.MostrarBotonesdd();
begin
  BitBtn5.Visible := True;
  BitBtn15.Visible := True;
  BitBtn1.Visible := False;
  BitBtn9.Visible := False;
  BitBtn10.Visible := False;
  BitBtn16.Visible := False;
  BitBtn2.Visible := False;
  BitBtn23.Visible := False;
  BitBtn26.Visible := False;
  RecolocarBarraAcciones;
end;

//====================== OCULTAR BOTONES DD ====================
procedure TFHistofaprov.OcultarBotonesdd();
begin
  BitBtn5.Visible := False;
  BitBtn15.Visible := False;
  BitBtn1.Visible := True;
  BitBtn9.Visible := True;
  BitBtn10.Visible := True;
  BitBtn16.Visible := True;
  BitBtn2.Visible := True;
  BitBtn23.Visible := True;
  BitBtn26.Visible := True;
  RecolocarBarraAcciones;
end;

//==================== PINTAR DATOS DE CLIENTES ======================
procedure TFHistofaprov.PintaProveedor();
begin
  Label4.Caption:=dbProve.FieldByName('P1').AsString;
  Label5.Caption:=dbProve.FieldByName('P2').AsString;
  Label6.Caption:=dbProve.FieldByName('P4').AsString;
  Label7.Caption:=dbProve.FieldByName('P3').AsString;
  Label8.Caption:=dbProve.FieldByName('P5').AsString;
  Label9.Caption:=dbProve.FieldByName('P6').AsString;
  Label10.Caption:=dbProve.FieldByName('P7').AsString;
end;
//==================== LIMPIAR DATOS DE CLIENTES ======================
procedure TFHistofaprov.LimpiaProveedor();
begin
  Label4.Caption:=''; Label5.Caption:=''; Label6.Caption:='';
  Label7.Caption:=''; Label8.Caption:=''; Label9.Caption:='';
  Label10.Caption:=''; LabelTotal.Caption:='0.00';
end;

//================= N. DE PEDIDO ===========================
procedure TFHistofaprov.NumeroPedido();
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

//======================= IMPRIMIR PEDIDO ==========================
procedure TFHistofaprov.BitBtn15Click(Sender: TObject);
var
  AreaTop, AreaHeight: Integer;
begin
  // Panel13 era hijo de Panel4 y por ello quedaba recortado dentro de la
  // vista de líneas. Al hacerlo hijo del formulario puede mostrarse completo
  // y desplazarse por toda la ventana.
  if Panel13.Parent <> Self then
    Panel13.Parent := Self;
  Panel13.Align := alNone;
  Panel13.Anchors := [];
  Panel13.Tag := 0;

  AreaTop := 0;
  if Assigned(FPanelCabecera) then
    AreaTop := FPanelCabecera.Height;
  AreaHeight := ClientHeight - AreaTop - Panel1.Height;
  if AreaHeight < Panel13.Height then
    AreaHeight := ClientHeight;

  Panel13.Left := (ClientWidth - Panel13.Width) div 2;
  Panel13.Top := AreaTop + (AreaHeight - Panel13.Height) div 2;
  if Panel13.Left < 0 then Panel13.Left := 0;
  if Panel13.Top < 0 then Panel13.Top := 0;

  Panel13.Visible := True;
  Panel13.BringToFront;
end;
//----------------- ACEPTAR IMPRIMIR LISTADO --------------------
procedure TFHistofaprov.BitBtn32Click(Sender: TObject);
begin
  Pdf:=0; ImprimirPedido();
end;
//----------------- ACEPTAR IMPRIMIR PDF --------------------
procedure TFHistofaprov.BitBtn36Click(Sender: TObject);
begin
  Pdf:=1; ImprimirPedido();
end;

//----------------- CANCELAR IMPRIMIR --------------------
procedure TFHistofaprov.BitBtn33Click(Sender: TObject);
begin
  Panel13.Visible:=False;
end;

//----------------- IMPRIMIR PEDIDO -----------------------
procedure TFHistofaprov.ImprimirPedido();
var
  TxtQ: String;
  ArchivoPdfTemporal: String;
begin
  //---- Consulta para el listado
  TxtQ:='SELECT * FROM hipedifadd'+Tienda+' WHERE HPD0='+dbPedic.FieldByName('HPC0').AsString+
                     ' AND HPD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('HPC1').AsDateTime)+'"'+
                     ' AND HPD2='+dbPedic.FieldByName('HPC2').AsString+
                     ' AND HPD3="'+dbPedic.FieldByName('HPC3').AsString+'"'+
                     ' AND HPD4='+dbPedic.FieldByName('HPC4').AsString;
  if RadioButton22.Checked=True then TxtQ:=TxtQ+' AND HPD23="S"';//----- Solo las lineas marcadas
  if RadioButton26.Checked=True then TxtQ:=TxtQ+' AND HPD23<>"S"';//---- Solo las lineas NO marcadas
  dbBusca.SQL.Text:=TxtQ;
  dbBusca.Active:=True;

  if RadioButton19.Checked=True Then begin EtiquetasBarras(); exit; end;//------------ Cgo. de barras

  frDBDataSet1.DataSet:=dbBusca;
  IMPOIVA1:=0; BASE1:=0; TOTAL1:=0; IRIVA1:=0; PIVA1:=0; PRIVA1:=0;
  IMPOIVA2:=0; BASE2:=0; TOTAL2:=0; IRIVA2:=0; PIVA2:=0; PRIVA2:=0;
  IMPOIVA3:=0; BASE3:=0; TOTAL3:=0; IRIVA3:=0; PIVA3:=0; PRIVA3:=0;
  //--------------- Sacar distintos ivas ------------------
    TxtQ:='SELECT DISTINCT(HPD14), (SUM(HPD15*HPD8)-SUM(HPD10*HPD8)) As Ivas, '+
          'SUM(HPD10*HPD8) As Bases, SUM(HPD17) As Totales, SUM(HPD13) As Recargos '+
        'FROM hipedifadd'+Tienda+
        ' WHERE HPD0='+dbPedic.Fields[0].AsString+
        ' AND HPD1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND HPD2='+dbPedic.Fields[2].AsString+
        ' AND HPD3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND HPD4='+dbPedic.Fields[4].AsString;
  if RadioButton22.Checked=True then TxtQ:=TxtQ+' AND HPD23="S"';//----- Solo las lineas marcadas
  if RadioButton26.Checked=True then TxtQ:=TxtQ+' AND HPD23<>"S"';//---- Solo las lineas NO marcadas
  TxtQ:=TxtQ+' GROUP BY HPD14 ORDER BY HPD14 ASC';

  dbTrabajo.Active:=False; dbTrabajo.Sql.Text:=TxtQ; dbTrabajo.Active:=True;
  dbTrabajo.First;
  //------------------------ Primer tipo de iva
  if dbTrabajo.Eof=False then
   begin
    PIVA1:=dbTrabajo.Fields[0].AsInteger;
    IMPOIVA1:=dbTrabajo.Fields[1].AsFloat;
    BASE1:=dbTrabajo.Fields[2].AsFloat;
    TOTAL1:=dbTrabajo.Fields[3].AsFloat;
    //---------------- Recargo
    if dbTrabajo.Fields[4].AsFloat<>0 then
      begin
       VerRecargo();
       PRIVA1:=RECARGO;
       IRIVA1:=dbTrabajo.Fields[2].AsFloat-((dbTrabajo.Fields[2].AsFloat*100)/(RECARGO+100));
       TOTAL1:=dbTrabajo.Fields[3].AsFloat+dbTrabajo.Fields[2].AsFloat-((dbTrabajo.Fields[2].AsFloat*100)/(RECARGO+100));
      end;
   end;
  dbTrabajo.Next;
  //------------------------ Segundo tipo de iva
  if dbTrabajo.Eof=False then
   begin
    PIVA2:=dbTrabajo.Fields[0].AsInteger;
    IMPOIVA2:=dbTrabajo.Fields[1].AsFloat;
    BASE2:=dbTrabajo.Fields[2].AsFloat;
    TOTAL2:=dbTrabajo.Fields[3].AsFloat;
    //---------------- Recargo
    if dbTrabajo.Fields[4].AsFloat<>0 then
      begin
       VerRecargo();
       PRIVA2:=RECARGO;
       IRIVA2:=dbTrabajo.Fields[2].AsFloat-((dbTrabajo.Fields[2].AsFloat*100)/(RECARGO+100));
       TOTAL2:=dbTrabajo.Fields[3].AsFloat+dbTrabajo.Fields[2].AsFloat-((dbTrabajo.Fields[2].AsFloat*100)/(RECARGO+100));
      end;
   end;
  dbTrabajo.Next;
  //------------------------ Tercer tipo de iva
  if dbTrabajo.Eof=False then
   begin
    PIVA3:=dbTrabajo.Fields[0].AsInteger;
    IMPOIVA3:=dbTrabajo.Fields[1].AsFloat;
    BASE3:=dbTrabajo.Fields[2].AsFloat;
    TOTAL3:=dbTrabajo.Fields[3].AsFloat;
    //---------------- Recargo
    if dbTrabajo.Fields[4].AsFloat<>0 then
      begin
       VerRecargo();
       PRIVA3:=RECARGO;
       IRIVA3:=dbTrabajo.Fields[2].AsFloat-((dbTrabajo.Fields[2].AsFloat*100)/(RECARGO+100));
       TOTAL3:=dbTrabajo.Fields[3].AsFloat+dbTrabajo.Fields[2].AsFloat-((dbTrabajo.Fields[2].AsFloat*100)/(RECARGO+100));
      end;
   end;
  {$IFDEF LINUX}
    if RadioButton6.Checked=True then
      frReport1.LoadFromFile('/usr/share/facturlinex2/Report/HiPedido.lrf');
    if RadioButton7.Checked=True then
      frReport1.LoadFromFile('/usr/share/facturlinex2/Report/HiPedidoSinPvp.lrf');
    if RadioButton8.Checked=True then
      frReport1.LoadFromFile('/usr/share/facturlinex2/Report/HiPedidoUnidades.lrf');
    if RadioButton20.Checked=True then
      frReport1.LoadFromFile('/usr/share/facturlinex2/Report/EtiLineales.lrf');

    //--------------------------------
    if Pdf=0 then
      frReport1.ShowReport
    else
      if frReport1.PrepareReport then
        begin
         // La previsualización debe usar una ruta temporal escribible.
         // Si RutaPdf está vacía, concatenarla generaba '/Pedido.pdf' y
         // Linux rechazaba la creación por falta de permisos.
         ArchivoPdfTemporal := IncludeTrailingPathDelimiter(GetTempDir(False)) +
           'FacturLinEx_Pedido.pdf';
         frReport1.ExportTo(TFrTNPDFExportFilter, ArchivoPdfTemporal);
         AProcess := TProcess.Create(nil);
         AProcess.CommandLine := VisorPdf+' '+ArchivoPdfTemporal;
         AProcess.Execute;
        end;
  {$ELSE}
    if RadioButton6.Checked=True then
      frReport1.LoadFromFile(RutaReports+'HiPedido.lrf');
    if RadioButton7.Checked=True then
      frReport1.LoadFromFile(RutaReports+'HiPedidoSinPvp.lrf');
    if RadioButton8.Checked=True then
      frReport1.LoadFromFile(RutaReports+'HiPedidoUnidades.lrf');
    if RadioButton20.Checked=True then
      frReport1.LoadFromFile(RutaReports+'EtiLineales.lrf');
    //------------------------
    if Pdf=0 then
      frReport1.ShowReport
    else
      if frReport1.PrepareReport then
        begin
         if not FileExists(VisorPdf) then
            begin ShowMessage('DEBE DEFINIR UN VISOR PDF EN LA CONFIGURACION'); exit; end;
         if not DirectoryExists(RutaPdf) then
            begin ShowMessage('DEBE DEFINIR UNA CARPETA PARA CREAR LOS DOCUMENTOS PDF'); exit; end;
         frReport1.ExportTo(TFrTNPDFExportFilter, RutaPdf+'\Pedido.pdf');
         AProcess := TProcess.Create(nil);
         AProcess.CommandLine := VisorPdf+' '+RutaPdf+'\Pedido.pdf';
         AProcess.Execute;
         AProcess.Destroy;
        end;
  {$ENDIF}
  dbBusca.Active:=False;
end;

//================ TIPOS DE RECARGO =====================
procedure TFHistofaprov.VerRecargo();
begin
   RECARGO:=RIVA1;
   if dbTrabajo.Fields[0].AsFloat=IVA1 then RECARGO:=RIVA1;
   if dbTrabajo.Fields[0].AsFloat=IVA2 then RECARGO:=RIVA2;
   if dbTrabajo.Fields[0].AsFloat=IVA3 then RECARGO:=RIVA3;
end;

//================= PASAR PARAMETROS AL REPORT ===============
procedure TFHistofaprov.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
    if ParName ='EMPRESA' then ParValue := Empresa;
  if ParName='DIRECCION' then ParValue := Direccion;
  if ParName='LOCALIDAD' then ParValue := Localidad;
  if ParName='PROVINCIA' then ParValue := Provincia;
  if ParName='NIF' then ParValue := Nif;
  if ParName='TELEFONO' then ParValue := Telefono;
  if ParName='FAX' then ParValue := Fax;
  if ParName='EMAIL' then ParValue := EMail;
  if ParName='CP' then ParValue := CP;
  //if ParName='TITULO' then ParValue := TituloGrid;

  if ParName='CCLIENTE' then ParValue := dbProve.FieldByName('P1').AsString;
  if ParName='CDIRECCION' then ParValue := dbProve.FieldByName('P2').AsString;
  if ParName='CLOCALIDAD' then ParValue := dbProve.FieldByName('P3').AsString;
  if ParName='CCIF' then ParValue := dbProve.FieldByName('P6').AsString;
  if ParName='CCP' then ParValue := dbProve.FieldByName('P4').AsString;
  if ParName='CPROVINCIA' then ParValue := dbProve.FieldByName('P5').AsString;

  if ParName='FECHA' then ParValue := dbPedic.FieldByName('HPC1').AsString;
  if ParName='SERIE' then ParValue := dbPedic.FieldByName('HPC3').AsString;
  if ParName='NUMERO' then ParValue := dbPedic.FieldByName('HPC4').AsString;
  if ParName='BASE1' then if BASE1<>0 then ParValue:=FormatFloat('0.000',BASE1) else ParValue:='';
  if ParName='PIVA1' then if PIVA1<>0 then ParValue:=FormatFloat('0',PIVA1) else ParValue:='';
  if ParName='IMPOIVA1' then if IMPOIVA1<>0 then ParValue:=FormatFloat('0.000',IMPOIVA1) else  ParValue:='';
  if ParName='TOTAL1' then if TOTAL1<>0 then ParValue := FormatFloat('0.00',TOTAL1) else  ParValue:='';
  if ParName='PRIVA1' then if PRIVA1<>0 then ParValue := FormatFloat('0',PRIVA1) else  ParValue:='';
  if ParName='IRIVA1' then if IRIVA1<>0 then ParValue := FormatFloat('0.00',IRIVA1) else  ParValue:='';
  if ParName='BASE2' then if BASE2<>0 then ParValue:=FormatFloat('0.000',BASE2) else ParValue:='';
  if ParName='PIVA2' then if PIVA2<>0 then ParValue:=FormatFloat('0',PIVA2) else ParValue:='';
  if ParName='IMPOIVA2' then if IMPOIVA2<>0 then ParValue:=FormatFloat('0.000',IMPOIVA2) else  ParValue:='';
  if ParName='TOTAL2' then if TOTAL2<>0 then ParValue := FormatFloat('0.00',TOTAL2) else  ParValue:='';
  if ParName='PRIVA2' then if PRIVA2<>0 then ParValue := FormatFloat('0',PRIVA2) else  ParValue:='';
  if ParName='IRIVA2' then if IRIVA2<>0 then ParValue := FormatFloat('0.00',IRIVA2) else  ParValue:='';
  if ParName='BASE3' then if BASE3<>0 then ParValue:=FormatFloat('0.000',BASE3) else ParValue:='';
  if ParName='PIVA3' then if PIVA3<>0 then ParValue:=FormatFloat('0',PIVA3) else ParValue:='';
  if ParName='IMPOIVA3' then if IMPOIVA3<>0 then ParValue:=FormatFloat('0.000',IMPOIVA3) else  ParValue:='';
  if ParName='TOTAL3' then if TOTAL3<>0 then ParValue := FormatFloat('0.00',TOTAL3) else  ParValue:='';
  if ParName='PRIVA3' then if PRIVA3<>0 then ParValue := FormatFloat('0',PRIVA3) else  ParValue:='';
  if ParName='IRIVA3' then if IRIVA3<>0 then ParValue := FormatFloat('0.00',IRIVA3) else  ParValue:='';
  if ParName='TOTALGENERAL' then if TOTAL1+TOTAL2+TOTAL3<>0 then ParValue := FormatFloat('0.00',TOTAL1+TOTAL2+TOTAL3) else  ParValue:='';
  if ParName='OBSERVACIONES' then ParValue := dbPedic.FieldByName('HPC31').AsString;

  if ParName='FECHAV1' then ParValue:=dbPedic.FieldByName('HPC20').AsString;
  if ParName='IMPOV1' then if dbPedic.FieldByName('HPC21').AsString<>'0' then ParValue:=dbPedic.FieldByName('HPC21').AsString else ParValue:='';
  if ParName='FECHAV2' then ParValue:=dbPedic.FieldByName('HPC22').AsString;
  if ParName='IMPOV2' then if dbPedic.FieldByName('HPC23').AsString<>'0' then ParValue:=dbPedic.FieldByName('HPC23').AsString else ParValue:='';
  if ParName='FECHAV3' then ParValue:=dbPedic.FieldByName('HPC24').AsString;
  if ParName='IMPOV3' then if dbPedic.FieldByName('HPC25').AsString<>'0' then ParValue:=dbPedic.FieldByName('HPC25').AsString else ParValue:='';
  if ParName='FECHAV4' then ParValue:=dbPedic.FieldByName('HPC26').AsString;
  if ParName='IMPOV4' then if dbPedic.FieldByName('HPC27').AsString<>'0' then ParValue:=dbPedic.FieldByName('HPC27').AsString else ParValue:='';
end;

//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFHistofaprov.frReport1EnterRect(Memo: TStringList; View: TfrView);
var
  vImage: TImage;
begin
  if assigned( View ) and
     (View.Name = 'Picture1') and
     (View is TfrPictureView)
  then
    try
      vImage := TImage.Create( nil );
      try
         TfrPictureView(View).Picture.Clear;
         TfrPictureView(View).Picture.LoadFromFile(LogoEmpresa);
      finally
        FreeAndNil(vImage);
      end;
    except
      TfrPictureView(View).Picture.Clear;
    end;
end;

//============================================================
//==================== ETIQUETAS DE BARRAS ===================
//============================================================
//---------- Activar / Desactivar Etiquetas de barras --------
procedure TFHistofaprov.RadioButton19Change(Sender: TObject);
begin
   if RadioButton19.Checked=True then Panel17.Enabled:=True else Panel17.Enabled:=False;
end;

//--------- Cantidad de etiquetas manual ------
procedure TFHistofaprov.RadioButton25Change(Sender: TObject);
begin
   if RadioButton25.Checked=True then Edit36.Visible:=True else Edit36.Visible:=False;
end;

//-------------- Grabar etiquetas en file txt ----------------
procedure TFHistofaprov.EtiquetasBarras();
var
  F: TextFile;
  Conta, Cantidad: Integer;
begin
  dbBusca.First; Cantidad:=1;
  SaveDialog1.FileName:=RutaSql + 'etieans.txt';
  AssignFile(F, SaveDialog1.FileName);
  Rewrite(F);
  if RadioButton23.Checked=True then Cantidad:=1;//----------------------------- Una por codigo
  if RadioButton25.Checked=True then Cantidad:=StrToInt(Edit36.Text);//--------- Manual
  while not dbBusca.Eof do
   begin
     if RadioButton24.Checked=True then Cantidad:=dbBusca.fields[8].AsInteger;//--- Segun stock
     for Conta:=1 to Cantidad do
        Writeln(F, dbBusca.Fields[6].AsString+':'+dbBusca.Fields[7].AsString+':'+dbBusca.Fields[16].AsString);
     dbBusca.Next;
   end;
  CloseFile(F);
  dbBusca.Active:=False;
  ShowMessage('ETIQUETAS GENERADAS CORRECTAMENTE!');
  AProcess := TProcess.Create(nil);
  AProcess.CommandLine := '/usr/bin/glabels /usr/share/facturlinex2/etibarras.glabels';
  AProcess.Execute;
  AProcess.Destroy;
  Panel13.Visible:=False;
end;


//-------------------- Ver Destino de La trasmisión ------------------------
procedure TFHistofaprov.MenuItem1Click(Sender: TObject);
begin
  StaticText1.Caption:=''; StaticText2.Caption:='';
  StaticText3.Caption:=''; StaticText4.Caption:='';
  StaticText1.Caption:=dbpedic.FieldByName('HPC10').AsString;//----- Trasmitido S/N
  StaticText2.Caption:=dbpedic.FieldByName('HPC11').AsString;//----- Tipo de Trasmision
  if StaticText2.Caption='P' then StaticText4.Caption:='Proveedores';
  if StaticText2.Caption='T' then StaticText4.Caption:='Tiendas';
  StaticText3.Caption:=dbpedic.FieldByName('HPC12').AsString;//----- Destino Trasmision
  Panel15.Visible:=True;
end;
procedure TFHistofaprov.Panel15Click(Sender: TObject);
begin
  Panel15.Visible:=False;
end;

//================== UNIDADES PENDIENTES EN PEDIDOS ================
procedure TFHistofaprov.SumaPendientes(CodiPen, UniPen: String);
begin
  dbTrabajo.SQL.Text:='UPDATE artitien'+Tienda+' SET A11=A11+'+UniPen+
                      ' WHERE A0="'+CodiPen+'"';
  dbTrabajo.ExecSQL;
end;




procedure TFHistofaprov.FormShow(Sender: TObject);
begin
  AplicarContrasteSeleccionControles(Self);
  RecolocarControles;
end;

procedure TFHistofaprov.ConfigurarBoton(ABoton: TBitBtn;
  const ACaption, AHint: String; AColor: TColor);
begin
  if not Assigned(ABoton) then Exit;
  ABoton.Caption := ACaption;
  ABoton.Hint := AHint;
  ABoton.ShowHint := True;
  ABoton.Color := AColor;
  ABoton.Font.Name := 'Sans';
  ABoton.Font.Height := -13;
  ABoton.Font.Color := RGBToColor(24, 36, 48);
  ABoton.Font.Style := [fsBold];
  ABoton.Glyph.Clear;
  ABoton.Layout := blGlyphLeft;
  ABoton.Margin := 8;
  ABoton.Spacing := 8;
  ABoton.Visible := True;
  ABoton.BringToFront;
end;

procedure TFHistofaprov.ConfigurarGrid(AGrid: TDBGrid);
begin
  if not Assigned(AGrid) then Exit;
  AGrid.Color := clWhite;
  AGrid.FixedColor := RGBToColor(224, 235, 244);
  AGrid.Font.Name := 'Sans';
  AGrid.Font.Height := -13;
  AGrid.Font.Color := RGBToColor(20, 30, 40);
  AGrid.TitleFont.Name := 'Sans';
  AGrid.TitleFont.Height := -13;
  AGrid.TitleFont.Color := RGBToColor(24, 52, 78);
  AGrid.TitleFont.Style := [fsBold];
  AGrid.Options := AGrid.Options + [dgTitles, dgIndicator, dgColumnResize,
    dgColumnMove, dgColLines, dgRowLines, dgRowSelect,
    dgAlwaysShowSelection];
  AGrid.OnDrawColumnCell := @GridDrawColumnCell;
end;

procedure TFHistofaprov.ConfigurarControlesRecursivo(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I := 0 to AParent.ControlCount - 1 do
  begin
    C := AParent.Controls[I];
    if Pos('FLX', C.Name) = 1 then
    begin
      { Los controles dinámicos conservan su estilo específico. }
    end
    else if C is TLabel then
    begin
      TLabel(C).ParentColor := True;
      TLabel(C).Transparent := True;
      TLabel(C).Font.Name := 'Sans';
      TLabel(C).Font.Height := -13;
      TLabel(C).Font.Color := RGBToColor(24, 36, 48);
    end
    else if C is TRadioButton then
    begin
      TRadioButton(C).ParentColor := True;
      TRadioButton(C).Font.Name := 'Sans';
      TRadioButton(C).Font.Height := -13;
      TRadioButton(C).Font.Color := RGBToColor(24, 36, 48);
    end
    else if C is TCheckBox then
    begin
      TCheckBox(C).ParentColor := True;
      TCheckBox(C).Font.Name := 'Sans';
      TCheckBox(C).Font.Height := -13;
      TCheckBox(C).Font.Color := RGBToColor(24, 36, 48);
    end
    else if C is TCustomEdit then
    begin
      TCustomEdit(C).Color := clWhite;
      TCustomEdit(C).Font.Name := 'Sans';
      TCustomEdit(C).Font.Height := -13;
      TCustomEdit(C).Font.Color := RGBToColor(16, 24, 32);
    end
    else if C is TMemo then
    begin
      TMemo(C).Color := clWhite;
      TMemo(C).Font.Name := 'Sans';
      TMemo(C).Font.Height := -13;
      TMemo(C).Font.Color := RGBToColor(16, 24, 32);
    end
    else if C is TCheckListBox then
    begin
      TCheckListBox(C).Color := clWhite;
      TCheckListBox(C).Font.Name := 'Sans';
      TCheckListBox(C).Font.Height := -13;
      TCheckListBox(C).Font.Color := RGBToColor(16, 24, 32);
    end
    else if C is TStaticText then
    begin
      TStaticText(C).Color := clWhite;
      TStaticText(C).Font.Name := 'Sans';
      TStaticText(C).Font.Height := -13;
      TStaticText(C).Font.Color := RGBToColor(16, 24, 32);
    end
    else if C is TBitBtn then
    begin
      TBitBtn(C).Font.Name := 'Sans';
      TBitBtn(C).Font.Height := -13;
      TBitBtn(C).Font.Color := RGBToColor(24, 36, 48);
      TBitBtn(C).Font.Style := [fsBold];
      TBitBtn(C).Color := RGBToColor(205, 225, 242);
    end
    else if C is TPanel then
    begin
      TPanel(C).Caption := '';
      TPanel(C).BevelOuter := bvNone;
    end;
    if C is TWinControl then
      ConfigurarControlesRecursivo(TWinControl(C));
  end;
end;

procedure TFHistofaprov.AplicarContrasteSeleccion(AControl: TWinControl);
{$IFDEF LCLGTK2}
var
  FondoNormal, TextoNormal, FondoSeleccion, TextoSeleccion: TGdkColor;
  Widget: PGtkWidget;
{$ENDIF}
begin
  if not Assigned(AControl) then Exit;
  AControl.HandleNeeded;
  {$IFDEF LCLGTK2}
  Widget := PGtkWidget(AControl.Handle);
  if Assigned(Widget) then
  begin
    gdk_color_parse(PChar('#FFFFFF'), @FondoNormal);
    gdk_color_parse(PChar('#101820'), @TextoNormal);
    gtk_widget_modify_base(Widget, GTK_STATE_NORMAL, @FondoNormal);
    gtk_widget_modify_text(Widget, GTK_STATE_NORMAL, @TextoNormal);
    gdk_color_parse(PChar('#2A5684'), @FondoSeleccion);
    gdk_color_parse(PChar('#FFFFFF'), @TextoSeleccion);
    gtk_widget_modify_base(Widget, GTK_STATE_SELECTED, @FondoSeleccion);
    gtk_widget_modify_text(Widget, GTK_STATE_SELECTED, @TextoSeleccion);
  end;
  {$ENDIF}
end;

procedure TFHistofaprov.AplicarContrasteSeleccionControles(
  AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I := 0 to AParent.ControlCount - 1 do
  begin
    C := AParent.Controls[I];
    if (C is TCustomEdit) or (C is TMemo) or
       (C is TCheckListBox) then
      AplicarContrasteSeleccion(TWinControl(C));
    if C is TWinControl then
      AplicarContrasteSeleccionControles(TWinControl(C));
  end;
end;

procedure TFHistofaprov.PrepararPanelAuxiliar(APanel: TPanel;
  const ATitulo: String; AColor: TColor; AMinWidth, AMinHeight: Integer);
var
  I, AlturaOriginal: Integer;
  Cabecera: TPanel;
begin
  if not Assigned(APanel) then Exit;
  APanel.Caption := '';
  APanel.BevelOuter := bvNone;
  APanel.Color := AColor;
  APanel.Tag := 0;

  AlturaOriginal := APanel.Height;
  if APanel.Width < AMinWidth then APanel.Width := AMinWidth;
  if APanel.Height < AMinHeight then APanel.Height := AMinHeight;
  if APanel.Height < AlturaOriginal + 38 then
    APanel.Height := AlturaOriginal + 38;

  for I := 0 to APanel.ControlCount - 1 do
    APanel.Controls[I].Top := APanel.Controls[I].Top + 38;

  Cabecera := TPanel.Create(APanel);
  Cabecera.Name := 'FLXCab_' + APanel.Name;
  Cabecera.Parent := APanel;
  Cabecera.Align := alTop;
  Cabecera.Height := 38;
  Cabecera.Caption := ATitulo;
  Cabecera.BevelOuter := bvNone;
  Cabecera.Color := RGBToColor(49, 91, 130);
  Cabecera.Font.Name := 'Sans';
  Cabecera.Font.Height := -14;
  Cabecera.Font.Color := clWhite;
  Cabecera.Font.Style := [fsBold];
  Cabecera.Cursor := crSizeAll;
  Cabecera.OnMouseDown := @PanelCabMouseDown;
  Cabecera.OnMouseMove := @PanelCabMouseMove;
  Cabecera.OnMouseUp := @PanelCabMouseUp;
  Cabecera.BringToFront;
end;

procedure TFHistofaprov.PanelCabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button <> mbLeft) or not (Sender is TControl) then Exit;
  if not (TControl(Sender).Parent is TPanel) then Exit;
  FPanelArrastre := TPanel(TControl(Sender).Parent);
  FInicioArrastre := Point(X, Y);
  FArrastrando := True;
  SetCapture(TWinControl(Sender).Handle);
end;

procedure TFHistofaprov.PanelCabMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  NuevoLeft, NuevoTop: Integer;
begin
  if not FArrastrando or not Assigned(FPanelArrastre) then Exit;
  GetCursorPos(P);
  P := FPanelArrastre.Parent.ScreenToClient(P);
  NuevoLeft := P.X - FInicioArrastre.X;
  NuevoTop := P.Y - FInicioArrastre.Y;
  if NuevoLeft < 0 then NuevoLeft := 0;
  if NuevoTop < 0 then NuevoTop := 0;
  if NuevoLeft + FPanelArrastre.Width > FPanelArrastre.Parent.ClientWidth then
    NuevoLeft := FPanelArrastre.Parent.ClientWidth - FPanelArrastre.Width;
  if NuevoTop + FPanelArrastre.Height > FPanelArrastre.Parent.ClientHeight then
    NuevoTop := FPanelArrastre.Parent.ClientHeight - FPanelArrastre.Height;
  if NuevoLeft < 0 then NuevoLeft := 0;
  if NuevoTop < 0 then NuevoTop := 0;
  FPanelArrastre.SetBounds(NuevoLeft, NuevoTop,
    FPanelArrastre.Width, FPanelArrastre.Height);
  FPanelArrastre.Tag := 1;
end;

procedure TFHistofaprov.PanelCabMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then Exit;
  FArrastrando := False;
  FPanelArrastre := nil;
  ReleaseCapture;
end;

procedure TFHistofaprov.AjustarPanelEnParent(APanel: TPanel);
var
  L, T: Integer;
begin
  if not Assigned(APanel) or not Assigned(APanel.Parent) then Exit;
  if APanel.Tag = 0 then
  begin
    L := (APanel.Parent.ClientWidth - APanel.Width) div 2;
    T := (APanel.Parent.ClientHeight - APanel.Height) div 2;
  end
  else
  begin
    L := APanel.Left;
    T := APanel.Top;
  end;
  if L < 0 then L := 0;
  if T < 0 then T := 0;
  if L + APanel.Width > APanel.Parent.ClientWidth then
    L := APanel.Parent.ClientWidth - APanel.Width;
  if T + APanel.Height > APanel.Parent.ClientHeight then
    T := APanel.Parent.ClientHeight - APanel.Height;
  if L < 0 then L := 0;
  if T < 0 then T := 0;
  APanel.Left := L;
  APanel.Top := T;
end;

procedure TFHistofaprov.RecolocarPanelesAuxiliares;
begin
  AjustarPanelEnParent(Panel7);
  AjustarPanelEnParent(Panel8);
  AjustarPanelEnParent(Panel9);
  AjustarPanelEnParent(Panel11);
  AjustarPanelEnParent(Panel13);
  AjustarPanelEnParent(Panel15);
  AjustarPanelEnParent(Panel16);
end;

procedure TFHistofaprov.RecolocarBarraAcciones;
var
  Botones: array[0..12] of TBitBtn;
  Visibles: array[0..12] of TBitBtn;
  I, N, Separacion, BotonW, TotalW, X: Integer;
begin
  if not Assigned(Panel1) then Exit;
  Botones[0] := BitBtn1;
  Botones[1] := BitBtn9;
  Botones[2] := BitBtn10;
  Botones[3] := BitBtn23;
  Botones[4] := BitBtn16;
  Botones[5] := BitBtn26;
  Botones[6] := FBtnGuardarPDF;
  Botones[7] := FBtnPrevisualizarPDF;
  Botones[8] := FBtnImprimirPDF;
  Botones[9] := FBtnExportarCSV;
  Botones[10] := BitBtn2;
  Botones[11] := BitBtn15;
  Botones[12] := BitBtn5;

  N := 0;
  for I := Low(Botones) to High(Botones) do
    if Assigned(Botones[I]) and Botones[I].Visible then
    begin
      Visibles[N] := Botones[I];
      Inc(N);
    end;
  if N = 0 then Exit;

  if N > 8 then Separacion := 6 else Separacion := 10;
  BotonW := (Panel1.ClientWidth - 24 - ((N - 1) * Separacion)) div N;
  if N > 8 then
  begin
    if BotonW > 112 then BotonW := 112;
    if BotonW < 82 then BotonW := 82;
  end
  else
  begin
    if BotonW > 155 then BotonW := 155;
    if BotonW < 105 then BotonW := 105;
  end;
  TotalW := (N * BotonW) + ((N - 1) * Separacion);
  X := (Panel1.ClientWidth - TotalW) div 2;
  if X < 6 then X := 6;

  for I := 0 to N - 1 do
  begin
    Visibles[I].SetBounds(X + I * (BotonW + Separacion), 12,
      BotonW, 50);
    if BotonW < 94 then
      Visibles[I].Font.Height := -10
    else if BotonW < 116 then
      Visibles[I].Font.Height := -11
    else
      Visibles[I].Font.Height := -13;
    Visibles[I].BringToFront;
  end;
end;

procedure TFHistofaprov.RecolocarControles;
var
  W, H, FiltroW, BtnX: Integer;
begin
  if not Assigned(FPanelCabecera) or not Assigned(FPanelFiltros) then Exit;

  W := ClientWidth;
  H := ClientHeight;
  FPanelCabecera.Height := 82;
  FLabelCabTitulo.SetBounds(24, 14, W - 48, 32);
  FLabelCabSubtitulo.SetBounds(26, 49, W - 52, 23);
  Panel1.Height := 76;

  FPanelFiltros.Height := 132;
  RadioButton1.SetBounds(20, 14, 220, 26);
  RadioButton2.SetBounds(20, 51, 210, 26);
  RadioButton3.SetBounds(20, 88, 190, 26);
  StaticText5.SetBounds(255, 10, FPanelFiltros.ClientWidth - 275, 28);

  FiltroW := FPanelFiltros.ClientWidth - 270;
  if FiltroW < 620 then FiltroW := 620;

  Panel2.SetBounds(248, 42, FiltroW, 78);
  Label1.SetBounds(12, 12, 105, 22);
  Edit1.SetBounds(120, 8, 105, 32);
  Edit2.SetBounds(235, 8, Panel2.ClientWidth - 410, 32);
  BitBtn7.SetBounds(Panel2.ClientWidth - 165, 8, 42, 32);
  BitBtn3.SetBounds(Panel2.ClientWidth - 115, 8, 105, 32);

  Panel3.SetBounds(248, 76, FiltroW, 46);
  Label2.SetBounds(12, 12, 85, 22);
  DateEdit1.SetBounds(98, 7, 150, 32);
  Label3.SetBounds(265, 12, 85, 22);
  DateEdit2.SetBounds(350, 7, 150, 32);
  BtnX := Panel3.ClientWidth - 120;
  if BtnX < 515 then BtnX := 515;
  BitBtn4.SetBounds(BtnX, 7, 110, 32);

  DBGrid1.Align := alNone;
  DBGrid1.SetBounds(16, 146, Panel5.ClientWidth - 32,
    Panel5.ClientHeight - 162);

  Bevel1.SetBounds(16, 16, 445, 132);
  Label4.SetBounds(28, 27, 420, 20);
  Label5.SetBounds(28, 51, 420, 20);
  Label6.SetBounds(28, 75, 70, 20);
  Label7.SetBounds(105, 75, 340, 20);
  Label8.SetBounds(28, 99, 420, 20);
  Label9.SetBounds(28, 123, 185, 20);
  Label10.SetBounds(235, 123, 210, 20);

  LabelTotal.SetBounds(Panel4.ClientWidth - 250, 19, 220, 54);
  Label29.SetBounds(Panel4.ClientWidth - 555, 91, 95, 22);
  Label48.SetBounds(Panel4.ClientWidth - 455, 91, 45, 22);
  Label31.SetBounds(Panel4.ClientWidth - 405, 91, 100, 22);
  Label32.SetBounds(Panel4.ClientWidth - 555, 123, 95, 22);
  Label33.SetBounds(Panel4.ClientWidth - 455, 123, 160, 22);

  DBGrid2.Align := alNone;
  DBGrid2.SetBounds(16, 164, Panel4.ClientWidth - 32,
    Panel4.ClientHeight - 180);
  Edit20.Visible := False;

  Panel7.SetBounds(Panel7.Left, Panel7.Top, 760, 230);
  Memo1.SetBounds(16, 56, Panel7.ClientWidth - 32, 108);
  BitBtn18.SetBounds(16, Panel7.ClientHeight - 50, 120, 36);
  BitBtn17.SetBounds(Panel7.ClientWidth - 136,
    Panel7.ClientHeight - 50, 120, 36);

  Panel9.SetBounds(Panel9.Left, Panel9.Top, 700, 300);
  Label21.SetBounds(18, 59, 120, 22);
  Edit14.SetBounds(145, 54, 105, 32);
  Edit15.SetBounds(260, 54, Panel9.ClientWidth - 278, 32);
  Label22.SetBounds(18, 101, 120, 22);
  Edit16.SetBounds(145, 96, 105, 32);
  Edit17.SetBounds(260, 96, Panel9.ClientWidth - 278, 32);
  Label23.SetBounds(18, 151, 100, 22);
  DateEdit7.SetBounds(145, 146, 150, 32);
  Label24.SetBounds(330, 151, 100, 22);
  DateEdit8.SetBounds(435, 146, 150, 32);
  BitBtn21.SetBounds(18, Panel9.ClientHeight - 50, 140, 36);
  BitBtn22.SetBounds(Panel9.ClientWidth - 158,
    Panel9.ClientHeight - 50, 140, 36);

  Panel11.SetBounds(Panel11.Left, Panel11.Top, 410, 365);
  Label36.SetBounds(70, 58, 60, 22);
  Label37.SetBounds(270, 58, 70, 22);
  Label38.SetBounds(18, 92, 25, 22);
  Label39.SetBounds(18, 132, 25, 22);
  Label40.SetBounds(18, 172, 25, 22);
  Label41.SetBounds(18, 212, 25, 22);
  DateEdit3.SetBounds(50, 86, 150, 32);
  DateEdit4.SetBounds(50, 126, 150, 32);
  DateEdit5.SetBounds(50, 166, 150, 32);
  DateEdit6.SetBounds(50, 206, 150, 32);
  Edit24.SetBounds(235, 86, 145, 32);
  Edit26.SetBounds(235, 126, 145, 32);
  Edit28.SetBounds(235, 166, 145, 32);
  Edit30.SetBounds(235, 206, 145, 32);
  Label44.SetBounds(190, 249, 55, 22);
  Label46.SetBounds(260, 249, 120, 22);
  Label45.SetBounds(190, 278, 55, 22);
  Label47.SetBounds(260, 278, 120, 22);
  BitBtn30.SetBounds(18, Panel11.ClientHeight - 50, 120, 36);
  BitBtn29.SetBounds(Panel11.ClientWidth - 138,
    Panel11.ClientHeight - 50, 120, 36);

  Panel8.SetBounds(Panel8.Left, Panel8.Top, 720, 520);
  DBGrid3.SetBounds(16, 54, Panel8.ClientWidth - 32, 165);
  Label26.SetBounds(20, 237, 80, 22);
  Edit21.SetBounds(105, 232, 105, 32);
  Label27.SetBounds(245, 237, 105, 22);
  DateEdit9.SetBounds(355, 232, 150, 32);
  Label28.SetBounds(20, 279, 80, 22);
  Edit23.SetBounds(105, 274, 105, 32);
  Edit25.SetBounds(220, 274, Panel8.ClientWidth - 285, 32);
  BitBtn40.SetBounds(Panel8.ClientWidth - 55, 274, 42, 32);
  Label61.SetBounds(300, 320, 200, 24);
  RadioButton35.SetBounds(35, 330, 120, 27);
  RadioButton32.SetBounds(35, 362, 140, 27);
  RadioButton15.SetBounds(35, 394, 120, 27);
  RadioButton16.SetBounds(35, 426, 120, 27);
  Label59.SetBounds(300, 358, 155, 22);
  Edit34.SetBounds(465, 353, 180, 32);
  Label60.SetBounds(300, 403, 155, 22);
  DateEdit10.SetBounds(465, 398, 180, 32);
  BitBtn19.SetBounds(16, Panel8.ClientHeight - 50, 130, 36);
  BitBtn20.SetBounds(Panel8.ClientWidth - 146,
    Panel8.ClientHeight - 50, 130, 36);

  Panel13.SetBounds(Panel13.Left, Panel13.Top, 560, 400);
  RadioButton6.SetBounds(20, 58, 230, 27);
  RadioButton7.SetBounds(20, 96, 250, 27);
  RadioButton8.SetBounds(20, 134, 240, 27);
  RadioButton20.SetBounds(20, 172, 225, 27);
  RadioButton19.SetBounds(300, 58, 230, 27);
  Panel17.SetBounds(300, 100, 235, 130);
  RadioGroup2.SetBounds(20, 235, Panel13.ClientWidth - 40, 64);
  BitBtn32.SetBounds(18, Panel13.ClientHeight - 50, 145, 36);
  BitBtn36.SetBounds((Panel13.ClientWidth - 145) div 2,
    Panel13.ClientHeight - 50, 145, 36);
  BitBtn33.SetBounds(Panel13.ClientWidth - 163,
    Panel13.ClientHeight - 50, 145, 36);

  Panel15.SetBounds(Panel15.Left, Panel15.Top, 560, 250);
  Label63.SetBounds(25, 70, 130, 24);
  StaticText1.SetBounds(175, 67, 70, 30);
  Label64.SetBounds(25, 112, 140, 24);
  StaticText2.SetBounds(175, 109, 60, 30);
  StaticText4.SetBounds(245, 109, 150, 30);
  Label65.SetBounds(25, 154, 140, 24);
  StaticText3.SetBounds(175, 151, Panel15.ClientWidth - 200, 30);
  Button1.SetBounds(Panel15.ClientWidth - 48, 47, 34, 30);

  Panel16.SetBounds(Panel16.Left, Panel16.Top, 500, 280);
  Label66.SetBounds(30, 78, 155, 22);
  Edit35.SetBounds(210, 73, 240, 32);
  Label68.SetBounds(30, 126, 180, 22);
  DateEdit11.SetBounds(210, 121, 180, 32);
  BitBtn39.SetBounds(18, Panel16.ClientHeight - 50, 130, 36);
  BitBtn38.SetBounds(Panel16.ClientWidth - 148,
    Panel16.ClientHeight - 50, 130, 36);

  RecolocarBarraAcciones;
  RecolocarPanelesAuxiliares;
  FPanelCabecera.BringToFront;
  Panel1.BringToFront;
end;

procedure TFHistofaprov.AplicarDisenoModerno;
begin
  Caption := 'Histórico de facturas y documentos de proveedor';
  Color := RGBToColor(239, 244, 248);
  WindowState := wsMaximized;
  Constraints.MinWidth := 1120;
  Constraints.MinHeight := 720;
  KeyPreview := True;
  OnKeyDown := @FormularioKeyDown;
  OnResize := @FormularioResize;
  OnShow := @FormShow;

  FPanelCabecera := TPanel.Create(Self);
  FPanelCabecera.Name := 'FLXPanelCabecera';
  FPanelCabecera.Parent := Self;
  FPanelCabecera.Align := alTop;
  FPanelCabecera.Height := 82;
  FPanelCabecera.Caption := '';
  FPanelCabecera.BevelOuter := bvNone;
  FPanelCabecera.Color := RGBToColor(41, 78, 113);

  FLabelCabTitulo := TLabel.Create(FPanelCabecera);
  FLabelCabTitulo.Name := 'FLXLabelCabTitulo';
  FLabelCabTitulo.Parent := FPanelCabecera;
  FLabelCabTitulo.Caption := 'HISTÓRICO DE DOCUMENTOS DE PROVEEDOR';
  FLabelCabTitulo.Transparent := True;
  FLabelCabTitulo.Font.Name := 'Sans';
  FLabelCabTitulo.Font.Height := -22;
  FLabelCabTitulo.Font.Style := [fsBold];
  FLabelCabTitulo.Font.Color := clWhite;

  FLabelCabSubtitulo := TLabel.Create(FPanelCabecera);
  FLabelCabSubtitulo.Name := 'FLXLabelCabSubtitulo';
  FLabelCabSubtitulo.Parent := FPanelCabecera;
  FLabelCabSubtitulo.Caption :=
    'Consulta, revisa y exporta documentos históricos sin perder los informes originales.';
  FLabelCabSubtitulo.Transparent := True;
  FLabelCabSubtitulo.Font.Name := 'Sans';
  FLabelCabSubtitulo.Font.Height := -13;
  FLabelCabSubtitulo.Font.Color := RGBToColor(218, 232, 244);

  Panel5.Color := RGBToColor(239, 244, 248);
  Panel5.Caption := '';
  Panel5.BevelOuter := bvNone;

  FPanelFiltros := TPanel.Create(Panel5);
  FPanelFiltros.Name := 'FLXPanelFiltros';
  FPanelFiltros.Parent := Panel5;
  FPanelFiltros.Align := alTop;
  FPanelFiltros.Height := 132;
  FPanelFiltros.Caption := '';
  FPanelFiltros.BevelOuter := bvNone;
  FPanelFiltros.Color := RGBToColor(225, 237, 246);

  RadioButton1.Parent := FPanelFiltros;
  RadioButton2.Parent := FPanelFiltros;
  RadioButton3.Parent := FPanelFiltros;
  Panel2.Parent := FPanelFiltros;
  Panel3.Parent := FPanelFiltros;
  StaticText5.Parent := FPanelFiltros;

  StaticText5.Alignment := taCenter;
  StaticText5.BorderStyle := sbsSingle;
  StaticText5.Color := RGBToColor(245, 249, 252);
  StaticText5.Font.Name := 'Sans';
  StaticText5.Font.Height := -13;
  StaticText5.Font.Style := [fsBold];
  StaticText5.Font.Color := RGBToColor(37, 73, 108);

  Panel2.Caption := '';
  Panel2.BevelOuter := bvNone;
  Panel2.Color := RGBToColor(238, 246, 251);
  Panel3.Caption := '';
  Panel3.BevelOuter := bvNone;
  Panel3.Color := RGBToColor(238, 246, 251);

  Panel1.Caption := '';
  Panel1.BevelOuter := bvNone;
  Panel1.Color := RGBToColor(222, 233, 242);
  Panel1.Height := 76;

  Panel4.Caption := '';
  Panel4.BevelOuter := bvNone;
  Panel4.Color := RGBToColor(239, 244, 248);

  ConfigurarControlesRecursivo(Self);

  ConfigurarBoton(BitBtn1, 'Ver líneas',
    'Abrir las líneas del documento seleccionado',
    RGBToColor(180, 215, 240));
  ConfigurarBoton(BitBtn9, 'Recuperar',
    'Recuperar el documento como un pedido nuevo',
    RGBToColor(190, 224, 196));
  ConfigurarBoton(BitBtn10, 'Eliminar',
    'Eliminar el documento histórico seleccionado',
    RGBToColor(238, 190, 190));
  ConfigurarBoton(BitBtn23, 'Informe orig.',
    'Abrir el informe original por proveedor y fechas',
    RGBToColor(204, 220, 242));
  ConfigurarBoton(BitBtn16, 'Observaciones',
    'Consultar o modificar las observaciones',
    RGBToColor(233, 218, 180));
  ConfigurarBoton(BitBtn26, 'Vencimientos',
    'Consultar o modificar los vencimientos',
    RGBToColor(218, 224, 244));
  ConfigurarBoton(BitBtn2, 'Cerrar',
    'Cerrar el histórico de proveedores',
    RGBToColor(238, 190, 190));
  ConfigurarBoton(BitBtn5, 'Volver',
    'Volver a la lista de documentos',
    RGBToColor(238, 205, 170));
  ConfigurarBoton(BitBtn15, 'Impresión original',
    'Abrir las opciones originales de impresión del documento',
    RGBToColor(184, 218, 244));

  FBtnGuardarPDF := TBitBtn.Create(Panel1);
  FBtnGuardarPDF.Name := 'FLXBtnGuardarPDF';
  FBtnGuardarPDF.Parent := Panel1;
  FBtnGuardarPDF.OnClick := @GuardarPDFClick;
  ConfigurarBoton(FBtnGuardarPDF, 'Guardar PDF',
    'Guardar el grid visible en un nuevo documento PDF',
    RGBToColor(190, 224, 196));

  FBtnPrevisualizarPDF := TBitBtn.Create(Panel1);
  FBtnPrevisualizarPDF.Name := 'FLXBtnPrevisualizarPDF';
  FBtnPrevisualizarPDF.Parent := Panel1;
  FBtnPrevisualizarPDF.OnClick := @PrevisualizarPDFClick;
  ConfigurarBoton(FBtnPrevisualizarPDF, 'Vista PDF',
    'Generar un PDF temporal y abrirlo en el visor predeterminado',
    RGBToColor(205, 225, 242));

  FBtnImprimirPDF := TBitBtn.Create(Panel1);
  FBtnImprimirPDF.Name := 'FLXBtnImprimirPDF';
  FBtnImprimirPDF.Parent := Panel1;
  FBtnImprimirPDF.OnClick := @ImprimirPDFClick;
  ConfigurarBoton(FBtnImprimirPDF, 'Imprimir PDF',
    'Generar el nuevo PDF y enviarlo a la impresora predeterminada',
    RGBToColor(205, 225, 242));

  FBtnExportarCSV := TBitBtn.Create(Panel1);
  FBtnExportarCSV.Name := 'FLXBtnExportarCSV';
  FBtnExportarCSV.Parent := Panel1;
  FBtnExportarCSV.OnClick := @ExportarCSVClick;
  ConfigurarBoton(FBtnExportarCSV, 'Exportar CSV',
    'Exportar todas las filas y columnas visibles a CSV UTF-8',
    RGBToColor(233, 218, 180));

  ConfigurarBoton(BitBtn3, 'Aplicar',
    'Aplicar el filtro por proveedor',
    RGBToColor(174, 216, 184));
  ConfigurarBoton(BitBtn4, 'Aplicar',
    'Aplicar el filtro entre fechas',
    RGBToColor(174, 216, 184));
  ConfigurarBoton(BitBtn7, '...',
    'Buscar proveedor por nombre',
    RGBToColor(184, 218, 244));
  ConfigurarBoton(BitBtn40, '...',
    'Buscar proveedor por nombre',
    RGBToColor(184, 218, 244));

  ConfigurarBoton(BitBtn17, 'Cerrar', 'Cerrar las observaciones',
    RGBToColor(238, 190, 190));
  ConfigurarBoton(BitBtn18, 'Guardar', 'Guardar las observaciones',
    RGBToColor(174, 216, 184));
  ConfigurarBoton(BitBtn21, 'Generar informe', 'Abrir el informe original',
    RGBToColor(174, 216, 184));
  ConfigurarBoton(BitBtn22, 'Cancelar', 'Cerrar sin generar el informe',
    RGBToColor(238, 190, 190));
  ConfigurarBoton(BitBtn29, 'Cerrar', 'Cerrar los vencimientos',
    RGBToColor(238, 190, 190));
  ConfigurarBoton(BitBtn30, 'Guardar', 'Guardar los vencimientos',
    RGBToColor(174, 216, 184));
  ConfigurarBoton(BitBtn19, 'Recuperar pedido', 'Crear el nuevo pedido',
    RGBToColor(174, 216, 184));
  ConfigurarBoton(BitBtn20, 'Cancelar', 'Cancelar la recuperación',
    RGBToColor(238, 190, 190));
  ConfigurarBoton(BitBtn32, 'Informe original',
    'Abrir el informe original seleccionado',
    RGBToColor(184, 218, 244));
  ConfigurarBoton(BitBtn36, 'Previsualizar PDF',
    'Generar y abrir el PDF con el visor configurado',
    RGBToColor(205, 225, 242));
  ConfigurarBoton(BitBtn33, 'Cerrar', 'Cerrar las opciones de impresión',
    RGBToColor(238, 190, 190));
  ConfigurarBoton(BitBtn38, 'Cerrar', 'Cerrar los datos del documento',
    RGBToColor(238, 190, 190));
  ConfigurarBoton(BitBtn39, 'Guardar', 'Guardar los datos del documento',
    RGBToColor(174, 216, 184));

  ConfigurarGrid(DBGrid1);
  ConfigurarGrid(DBGrid2);
  ConfigurarGrid(DBGrid3);
  DBGrid1.OnTitleClick := @DBGrid1TitleClick;
  DBGrid2.OnTitleClick := @DBGrid2TitleClick;
  DBGrid3.OnTitleClick := @DBGrid3TitleClick;

  LabelTotal.Font.Name := 'Sans';
  LabelTotal.Font.Height := -27;
  LabelTotal.Font.Style := [fsBold];
  LabelTotal.Font.Color := RGBToColor(34, 99, 67);
  LabelTotal.Alignment := taRightJustify;

  PrepararPanelAuxiliar(Panel7, 'OBSERVACIONES',
    RGBToColor(245, 240, 221), 760, 230);
  PrepararPanelAuxiliar(Panel8, 'RECUPERAR COMO PEDIDO NUEVO',
    RGBToColor(229, 240, 248), 720, 520);
  PrepararPanelAuxiliar(Panel9, 'LISTADO DE DOCUMENTOS',
    RGBToColor(229, 240, 248), 700, 300);
  PrepararPanelAuxiliar(Panel11, 'VENCIMIENTOS',
    RGBToColor(242, 237, 222), 410, 365);
  PrepararPanelAuxiliar(Panel13, 'OPCIONES DE IMPRESIÓN',
    RGBToColor(229, 240, 248), 560, 400);
  // Debe flotar sobre el formulario completo, no quedar limitado por Panel4.
  Panel13.Parent := Self;
  Panel13.Align := alNone;
  Panel13.Anchors := [];
  Panel13.Visible := False;
  PrepararPanelAuxiliar(Panel15, 'DESTINO DE LA TRANSMISIÓN',
    RGBToColor(235, 240, 246), 560, 250);
  PrepararPanelAuxiliar(Panel16, 'DATOS DEL DOCUMENTO DEL PROVEEDOR',
    RGBToColor(239, 236, 221), 500, 280);

  Label20.Visible := False;
  Label25.Visible := False;
  Label35.Visible := False;
  Label57.Visible := False;
  Label62.Visible := False;
  Label67.Visible := False;

  FOrdenCampo1 := '';
  FOrdenCampo2 := '';
  FOrdenCampo3 := '';
  FOrdenAsc1 := True;
  FOrdenAsc2 := True;
  FOrdenAsc3 := True;
  FArrastrando := False;
  FPanelArrastre := nil;

  RecolocarControles;
  FPanelCabecera.BringToFront;
  Panel1.BringToFront;
end;

procedure TFHistofaprov.OrdenarConsulta(AQuery: TZQuery; AGrid: TDBGrid;
  AColumn: TColumn; var ACampo: String; var AAscendente: Boolean);
var
  Campo, SQLBase, Direccion: String;
  P: Integer;
begin
  if not Assigned(AQuery) or not Assigned(AGrid) or
     not Assigned(AColumn) then Exit;
  Campo := AColumn.FieldName;
  if Campo = '' then Exit;

  if SameText(ACampo, Campo) then
    AAscendente := not AAscendente
  else
  begin
    ACampo := Campo;
    AAscendente := True;
  end;

  SQLBase := Trim(AQuery.SQL.Text);
  P := Pos('ORDER BY', UpperCase(SQLBase));
  if P > 0 then SQLBase := Trim(Copy(SQLBase, 1, P - 1));
  if AAscendente then Direccion := ' ASC' else Direccion := ' DESC';

  AQuery.DisableControls;
  try
    AQuery.Close;
    AQuery.SQL.Text := SQLBase + ' ORDER BY ' + Campo + Direccion;
    AQuery.Open;
  finally
    AQuery.EnableControls;
  end;
  ActualizarFlechaOrdenacion(AGrid, AColumn, AAscendente);
end;

procedure TFHistofaprov.ActualizarFlechaOrdenacion(AGrid: TDBGrid;
  AColumn: TColumn; AAscendente: Boolean);
var
  I: Integer;
  Texto: String;
begin
  if not Assigned(AGrid) or not Assigned(AColumn) then Exit;
  for I := 0 to AGrid.Columns.Count - 1 do
  begin
    Texto := AGrid.Columns[I].Title.Caption;
    Texto := StringReplace(Texto, ' ▲', '', [rfReplaceAll]);
    Texto := StringReplace(Texto, ' ▼', '', [rfReplaceAll]);
    AGrid.Columns[I].Title.Caption := Texto;
  end;
  if AAscendente then
    AColumn.Title.Caption := AColumn.Title.Caption + ' ▲'
  else
    AColumn.Title.Caption := AColumn.Title.Caption + ' ▼';
end;

procedure TFHistofaprov.DBGrid1TitleClick(Column: TColumn);
begin
  OrdenarConsulta(dbPedic, DBGrid1, Column, FOrdenCampo1, FOrdenAsc1);
end;

procedure TFHistofaprov.DBGrid2TitleClick(Column: TColumn);
begin
  OrdenarConsulta(dbPedid, DBGrid2, Column, FOrdenCampo2, FOrdenAsc2);
end;

procedure TFHistofaprov.DBGrid3TitleClick(Column: TColumn);
begin
  OrdenarConsulta(dbSeries, DBGrid3, Column, FOrdenCampo3, FOrdenAsc3);
end;

procedure TFHistofaprov.DBGrid3DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  GridDrawColumnCell(Sender, Rect, DataCol, Column, State);
end;

procedure TFHistofaprov.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Grid: TDBGrid;
begin
  if not (Sender is TDBGrid) then Exit;
  Grid := TDBGrid(Sender);
  if gdSelected in State then
  begin
    Grid.Canvas.Brush.Color := RGBToColor(42, 86, 132);
    Grid.Canvas.Font.Color := clWhite;
  end
  else
  begin
    Grid.Canvas.Brush.Color := clWhite;
    Grid.Canvas.Font.Color := RGBToColor(20, 30, 40);
    if (Grid = DBGrid1) and dbPedic.Active and
       (not dbPedic.IsEmpty) and
       (dbPedic.FieldByName('HPC15').AsString <> '') then
      Grid.Canvas.Font.Color := RGBToColor(35, 92, 155)
    else if (Grid = DBGrid2) and dbPedid.Active and
            (not dbPedid.IsEmpty) and
            (dbPedid.FieldByName('HPD23').AsString = 'N') then
      Grid.Canvas.Font.Color := RGBToColor(180, 38, 38);
  end;
  Grid.Canvas.FillRect(Rect);
  Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

function TFHistofaprov.GridExportacionActual: TDBGrid;
begin
  Result := nil;
  if Panel4.Visible and DBGrid2.Visible then
    Result := DBGrid2
  else if DBGrid1.Visible then
    Result := DBGrid1;
end;

function TFHistofaprov.TituloExportacionActual: String;
begin
  if Panel4.Visible and DBGrid2.Visible then
    Result := 'LÍNEAS DEL DOCUMENTO DE PROVEEDOR'
  else
    Result := 'HISTÓRICO DE DOCUMENTOS DE PROVEEDOR';
end;

procedure TFHistofaprov.PrepararCabeceraExportacion(ACabecera: TStrings);
var
  Grid: TDBGrid;
  TipoFiltro, SerieNumero: String;
begin
  if not Assigned(ACabecera) then Exit;
  ACabecera.Clear;
  if Empresa <> '' then
    ACabecera.Add('Empresa: ' + Empresa);

  Grid := GridExportacionActual;
  if Grid = DBGrid2 then
  begin
    if dbPedic.Active and (not dbPedic.IsEmpty) then
    begin
      SerieNumero := Trim(dbPedic.FieldByName('HPC3').AsString + ' ' +
        dbPedic.FieldByName('HPC4').AsString);
      ACabecera.Add('Proveedor: ' + dbPedic.FieldByName('HPC2').AsString +
        ' - ' + dbPedic.FieldByName('HPC13').AsString);
      ACabecera.Add('Documento: ' + SerieNumero + '; fecha: ' +
        FormatDateTime('dd/mm/yyyy', dbPedic.FieldByName('HPC1').AsDateTime));
      ACabecera.Add('Total: ' +
        FormatFloat('###,###,##0.00', dbPedic.FieldByName('HPC8').AsFloat));
    end;
  end
  else
  begin
    if RadioButton2.Checked then
      TipoFiltro := 'Proveedor: ' + Edit1.Text + ' - ' + Edit2.Text
    else if RadioButton3.Checked then
      TipoFiltro := 'Fechas: ' + DateEdit1.Text + ' a ' + DateEdit2.Text
    else
      TipoFiltro := 'Todos los documentos ordenados por fecha';
    ACabecera.Add('Filtro: ' + TipoFiltro);
  end;

  if Assigned(Grid) and Assigned(Grid.DataSource) and
     Assigned(Grid.DataSource.DataSet) and Grid.DataSource.DataSet.Active then
    ACabecera.Add('Registros: ' + IntToStr(Grid.DataSource.DataSet.RecordCount));
  ACabecera.Add('Generado: ' + FormatDateTime('dd/mm/yyyy hh:nn', Now));
end;

function TFHistofaprov.GenerarPDFTemporal(out AFileName: String): Boolean;
var
  Grid: TDBGrid;
  Cabecera: TStringList;
begin
  Result := False;
  AFileName := '';
  Grid := GridExportacionActual;
  if not Assigned(Grid) then
  begin
    ShowMessage('No hay ningún grid visible para generar el PDF.');
    Exit;
  end;
  if (Grid.DataSource = nil) or (Grid.DataSource.DataSet = nil) or
     (not Grid.DataSource.DataSet.Active) then
  begin
    ShowMessage('El listado visible no tiene datos abiertos.');
    Exit;
  end;

  AFileName := IncludeTrailingPathDelimiter(GetTempDir(False)) +
    'facturlinex_historico_proveedor_' +
    FormatDateTime('yyyymmdd_hhnnss_zzz', Now) + '.pdf';
  Cabecera := TStringList.Create;
  try
    PrepararCabeceraExportacion(Cabecera);
    try
      ExportarGridAPDF(Grid, AFileName, TituloExportacionActual, Cabecera);
      Result := True;
    except
      on E: Exception do
        ShowMessage('No se pudo generar el PDF: ' + E.Message);
    end;
  finally
    Cabecera.Free;
  end;
end;

procedure TFHistofaprov.GuardarPDFClick(Sender: TObject);
var
  Dialogo: TSaveDialog;
  Grid: TDBGrid;
  Cabecera: TStringList;
  NombreBase: String;
begin
  Grid := GridExportacionActual;
  if not Assigned(Grid) then
  begin
    ShowMessage('No hay ningún grid visible para guardar.');
    Exit;
  end;
  if (Grid.DataSource = nil) or (Grid.DataSource.DataSet = nil) or
     (not Grid.DataSource.DataSet.Active) then
  begin
    ShowMessage('El listado visible no tiene datos abiertos.');
    Exit;
  end;

  if Grid = DBGrid2 then
    NombreBase := 'Lineas_documento_proveedor_'
  else
    NombreBase := 'Historico_documentos_proveedor_';

  Dialogo := TSaveDialog.Create(Self);
  Cabecera := TStringList.Create;
  try
    Dialogo.Title := 'Guardar histórico de proveedor en PDF';
    Dialogo.Filter := 'Documento PDF (*.pdf)|*.pdf';
    Dialogo.DefaultExt := 'pdf';
    Dialogo.FileName := NombreBase + FormatDateTime('yyyymmdd', Date) + '.pdf';
    Dialogo.Options := Dialogo.Options + [ofOverwritePrompt];
    if not Dialogo.Execute then Exit;
    PrepararCabeceraExportacion(Cabecera);
    try
      ExportarGridAPDF(Grid, Dialogo.FileName, TituloExportacionActual,
        Cabecera);
      ShowMessage('PDF guardado correctamente en:' + LineEnding +
        Dialogo.FileName);
    except
      on E: Exception do
        ShowMessage('No se pudo guardar el PDF: ' + E.Message);
    end;
  finally
    Cabecera.Free;
    Dialogo.Free;
  end;
end;

procedure TFHistofaprov.PrevisualizarPDFClick(Sender: TObject);
var
  Archivo, Mensaje: String;
begin
  if not GenerarPDFTemporal(Archivo) then Exit;
  if not PrevisualizarPDFPredeterminado(Archivo, Mensaje) then
    ShowMessage(Mensaje);
end;

procedure TFHistofaprov.ImprimirPDFClick(Sender: TObject);
var
  Archivo, Mensaje: String;
begin
  if not GenerarPDFTemporal(Archivo) then Exit;
  ImprimirPDFPredeterminado(Archivo, Mensaje);
  ShowMessage(Mensaje);
end;

procedure TFHistofaprov.ExportarCSVClick(Sender: TObject);
var
  Dialogo: TSaveDialog;
  Grid: TDBGrid;
  NombreBase: String;
begin
  Grid := GridExportacionActual;
  if not Assigned(Grid) then
  begin
    ShowMessage('No hay ningún grid visible para exportar.');
    Exit;
  end;
  if (Grid.DataSource = nil) or (Grid.DataSource.DataSet = nil) or
     (not Grid.DataSource.DataSet.Active) then
  begin
    ShowMessage('El listado visible no tiene datos abiertos.');
    Exit;
  end;

  if Grid = DBGrid2 then
    NombreBase := 'Lineas_documento_proveedor_'
  else
    NombreBase := 'Historico_documentos_proveedor_';

  Dialogo := TSaveDialog.Create(Self);
  try
    Dialogo.Title := 'Exportar histórico de proveedor a CSV';
    Dialogo.Filter := 'Archivo CSV (*.csv)|*.csv';
    Dialogo.DefaultExt := 'csv';
    Dialogo.FileName := NombreBase + FormatDateTime('yyyymmdd', Date) + '.csv';
    Dialogo.Options := Dialogo.Options + [ofOverwritePrompt];
    if not Dialogo.Execute then Exit;
    try
      ExportarGridACSV(Grid, Dialogo.FileName);
      ShowMessage('CSV guardado correctamente en:' + LineEnding +
        Dialogo.FileName);
    except
      on E: Exception do
        ShowMessage('No se pudo exportar el CSV: ' + E.Message);
    end;
  finally
    Dialogo.Free;
  end;
end;

procedure TFHistofaprov.FormularioKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then Exit;
  Key := 0;

  if Panel7.Visible then
    BitBtn17Click(BitBtn17)
  else if Panel8.Visible then
    BitBtn20Click(BitBtn20)
  else if Panel9.Visible then
    BitBtn22Click(BitBtn22)
  else if Panel11.Visible then
    BitBtn29Click(BitBtn29)
  else if Panel13.Visible then
    BitBtn33Click(BitBtn33)
  else if Panel15.Visible then
    Panel15Click(Panel15)
  else if Panel16.Visible then
    BitBtn38Click(BitBtn38)
  else if Panel2.Visible or Panel3.Visible then
  begin
    RadioButton1.Checked := True;
    RadioButton1Click(RadioButton1);
  end
  else if Panel4.Visible then
    BitBtn5Click(BitBtn5)
  else
    BitBtn2Click(BitBtn2);
end;

procedure TFHistofaprov.FormularioResize(Sender: TObject);
begin
  RecolocarControles;
end;

initialization
  {$I histofaprov.lrs}

end.
