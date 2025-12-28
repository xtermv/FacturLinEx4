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

unit gestionar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ZConnection, ZDataset, DBGrids, db, StdCtrls, DbCtrls, LR_Class,
  LR_DBSet, LCLType, CheckLst, EditBtn, lr_e_pdf, Process, Grids, Menus,
  ExtDlgs, MaskEdit, Spin;

type

  { TFPedido }

  TFPedido = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
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
    BitBtn24: TBitBtn;
    BitBtn25: TBitBtn;
    BitBtn26: TBitBtn;
    BitBtn27: TBitBtn;
    BitBtn28: TBitBtn;
    BitBtn29: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn30: TBitBtn;
    BitBtn31: TBitBtn;
    BitBtn32: TBitBtn;
    BitBtn33: TBitBtn;
    BitBtn34: TBitBtn;
    BitBtn35: TBitBtn;
    BitBtn36: TBitBtn;
    BitBtn37: TBitBtn;
    BitBtn38: TBitBtn;
    BitBtn39: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn40: TBitBtn;
    BitBtn41: TBitBtn;
    BitBtn42: TBitBtn;
    BitBtn43: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtnImportar: TBitBtn;
    Button1: TButton;
    cbPrecioEan: TCheckBox;
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
    dbConnectR: TZConnection;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    dbTrabajoR: TZQuery;
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
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit2: TEdit;
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
    EdFicheroPdf: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    Edit37: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    frTNPDFExport1: TfrTNPDFExport;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
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
    Label49: TLabel;
    Label5: TLabel;
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
    Label69: TLabel;
    Label7: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    lbPdf: TLabel;
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
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    PopupMenu1: TPopupMenu;
    RadioButton1: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    RadioButton14: TRadioButton;
    RadioButton15: TRadioButton;
    RadioButton16: TRadioButton;
    RadioButton17: TRadioButton;
    RadioButton18: TRadioButton;
    RadioButton19: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton20: TRadioButton;
    RadioButton21: TRadioButton;
    RadioButton22: TRadioButton;
    RadioButton23: TRadioButton;
    RadioButton24: TRadioButton;
    RadioButton25: TRadioButton;
    RadioButton26: TRadioButton;
    RadioButton27: TRadioButton;
    RadioButton28: TRadioButton;
    RadioButton29: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton30: TRadioButton;
    RadioButton31: TRadioButton;
    RadioButton32: TRadioButton;
    RadioButton33: TRadioButton;
    RadioButton34: TRadioButton;
    RadioButton35: TRadioButton;
    RadioButton36: TRadioButton;
    RadioButton37: TRadioButton;
    RadioButton38: TRadioButton;
    RadioButton39: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton40: TRadioButton;
    RadioButton41: TRadioButton;
    RadioButton42: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    RadioGroup4: TRadioGroup;
    RadioGroup5: TRadioGroup;
    SaveDialog1: TSaveDialog;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    dbEan: TZQuery;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
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
    procedure BitBtn24Click(Sender: TObject);
    procedure BitBtn25Click(Sender: TObject);
    procedure BitBtn26Click(Sender: TObject);
    procedure BitBtn27Click(Sender: TObject);
    procedure BitBtn28Click(Sender: TObject);
    procedure BitBtn29Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn30Click(Sender: TObject);
    procedure BitBtn31Click(Sender: TObject);
    procedure BitBtn32Click(Sender: TObject);
    procedure BitBtn33Click(Sender: TObject);
    procedure BitBtn34Click(Sender: TObject);
    procedure BitBtn35Click(Sender: TObject);
    procedure BitBtn36Click(Sender: TObject);
    procedure BitBtn37Click(Sender: TObject);
    procedure BitBtn38Click(Sender: TObject);
    procedure BitBtn39Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn40Click(Sender: TObject);
    procedure BitBtn41Click(Sender: TObject);
    procedure BitBtn42Click(Sender: TObject);
    procedure BitBtn43Click(Sender: TObject);
    procedure BitBtnImportarClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure Datasource1DataChange(Sender: TObject; Field: TField);
    procedure Datasource3DataChange(Sender: TObject; Field: TField);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure DBGrid2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure Edit11Exit(Sender: TObject);
    procedure Edit12Exit(Sender: TObject);
    procedure Edit14Enter(Sender: TObject);
    procedure Edit14Exit(Sender: TObject);
    procedure Edit16Enter(Sender: TObject);
    procedure Edit16Exit(Sender: TObject);
    procedure Edit18Exit(Sender: TObject);
    procedure Edit19Exit(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit22Exit(Sender: TObject);
    procedure Edit23Enter(Sender: TObject);
    procedure Edit23Exit(Sender: TObject);
    procedure Edit24Exit(Sender: TObject);
    procedure Edit25KeyPress(Sender: TObject; var Key: char);
    procedure Edit26Exit(Sender: TObject);
    procedure Edit27Exit(Sender: TObject);
    procedure Edit28Exit(Sender: TObject);
    procedure Edit29Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit30Exit(Sender: TObject);
    procedure Edit31Exit(Sender: TObject);
    procedure Edit32Enter(Sender: TObject);
    procedure Edit32Exit(Sender: TObject);
    procedure Edit33KeyPress(Sender: TObject; var Key: char);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit6KeyPress(Sender: TObject; var Key: char);
    procedure Edit7Exit(Sender: TObject);
    procedure Edit8Exit(Sender: TObject);
    procedure Edit9Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure Panel15Click(Sender: TObject);
    procedure RadioButton19Change(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton25Change(Sender: TObject);
    procedure RadioButton28Click(Sender: TObject);
    procedure RadioButton29Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton30Click(Sender: TObject);
    procedure RadioButton31Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure MostrarBotonesdd();
    procedure OcultarBotonesdd();
    procedure LimpiaProveedor();
    procedure PintaProveedor();
    procedure Llenadd();
    procedure Llenacc();
    procedure Pintadd();
    procedure Limpiadd();
    procedure PintarTotalGeneral();
    procedure PintarTotalVencimientos();
    procedure NumeroPedido();
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure RadioButton40Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    function LeerArticulo: Boolean;
    function LeerAuxiliar: Boolean;
    function VerUltimaLinea: Integer;
    procedure ModificaTarifaCompra();
    procedure CrearArticulo();
    procedure CrearEan();
    procedure ImprimirPedido();
    procedure EtiquetasBarras();
    procedure SumaPendientes(CodiPen, UniPen: String);
    procedure VerRecargo();
    procedure CargaValorEntrada(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

  procedure ShowFormPedido;

var
  FPedido: TFPedido;
  SPEDIDO,TIPOPEDIDO,NOMBREPEDIDO,LETRAPEDIDO: String;
  SwCrea, NPEDIDO, Pdf: Integer;
  BASE1,BASE2,BASE3,IMPOIVA1,IMPOIVA2,IMPOIVA3,TOTAL1,TOTAL2,TOTAL3: Double;
  IRIVA1,IRIVA2,IRIVA3,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PRIVA1,PRIVA2,PRIVA3:Double;
  ValorEntrada: String;
  //-- ORDENACION DE COLUMNAS PEDIDOS
  sOrden : String;

implementation

{ TFPedido }

uses
  Global, Funciones, Busquedas, entrada, Importar;

//=============== CREAR EL FORMULARIO ================
procedure ShowFormPedido;
begin
  with TFPedido.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFPedido.FormCreate(Sender: TObject);
begin
  //--------- Conectar con la bbdd
  //Conectate(dbConnect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //--------- Pedidos
  dbPedic.SQL.Text:='SELECT * FROM pedicc'+Tienda+
                    ' ORDER BY PC0 ASC, PC1 DESC, PC2 ASC, PC3 ASC, PC4 DESC';
  dbPedic.Active:=True;
  Panel4.SendToBack; Panel4.Visible:=False;
  DBGrid2.SendToBack; DBGrid2.Visible:=False;
  //------------- Chequear ivas
  if IVA1=0 then showmessage('DEBE DEFINIR LOS TIPOS DE IVA EN LA CONFIGURACION');
  TIPOPEDIDO:=''; NOMBREPEDIDO:='PEDIDOS/NOTAS/ALB./FACT.'; LETRAPEDIDO:='LOS';
  Panel4.Align:=AlClient;
  //-- ORDENAR COLUMNAS PEDIDOS
  sOrden:='DESC';
end;

procedure TFPedido.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//     **********  Edición de las líneas del documento   **********


 if (key=VK_F8) and (panel6.Visible=True) then begin key:=0; BitBtn8Click(self); Exit; End;                      // Línea nueva
 if (key=VK_ESCAPE) and (panel6.Visible=True) then begin key:=0; BitBtn6Click(self) ; Exit; End;                 // finalizar entradas

//     **********  Pantalla cabeceras de Pedidos   **********

                                                                                                               // Entra en selección de clientes.
 if (key=VK_F1) and (dbGrid2.Visible=false) then begin key:=0; BitBtn1Click(self); Exit; End;                    // entra en edición
 if (key=VK_F2) and (dbGrid2.Visible=false) then begin key:=0; BitBtn9Click(self); Exit; End;                    // crea un nuevo pedido
 if (key=VK_F3) and (dbGrid2.Visible=false) then begin key:=0; BitBtn10Click(self); Exit; End;                   // borra un pedido
 if (key=VK_F11) and (dbGrid2.Visible=false) then begin key:=0; BitBtn23Click(self); Exit; End;                  // Listado de pedidos
 if (key=VK_F10) and (dbGrid2.Visible=false) then begin key:=0; BitBtn16Click(self); Exit; End;                  // Observaciones
 if (key=VK_F8) and (panel7.Visible=true) then begin key:=0; BitBtn18Click(self); Exit; End;                     // Aceptar Observaciones
 if (key=VK_ESCAPE) and (panel7.Visible=true) then begin key:=0; BitBtn17Click(self); Exit; End;                // Salir de observaciones
 if (key=VK_F8) and (panel8.Visible=true) then begin key:=0; BitBtn19Click(self); Exit; End;                     // Aceptar pedido nuevo
 if (key=VK_ESCAPE) and (panel8.Visible=true) then begin key:=0; BitBtn20Click(self); Exit; End;                // Salir de entrada pedido nuevo
 if (key=VK_F8) and (panel9.Visible=true) then begin key:=0; BitBtn21Click(self); Exit; End;                    // Aceptar Listado
 if (key=VK_ESCAPE) and (panel9.Visible=true) then begin key:=0; BitBtn22Click(self); Exit; End;                // Salir de Listado nuevo
 if (key=VK_ESCAPE) and (dbGrid2.Visible=false) then begin key:=0; BitBtn2Click(self); Exit; End;                // Salir de tarea de pedidos

//     **********  Pantalla de detalles   **********

 if (key=VK_F2) and (dbGrid2.Visible=true) then begin key:=0; BitBtn12Click(self); Exit; End;                     // Crear líneas nuevas.
 if (key=VK_F3) and (dbGrid2.Visible=true) then begin key:=0; BitBtn14Click(self); Exit; End;                     // Borra la línea seleccionada
 if (key=VK_F4) and (dbGrid2.Visible=true) then begin key:=0; BitBtn13Click(self); Exit; End;                   // Editar la linea seleccionada
 if (key=VK_F11) and (dbGrid2.Visible=true) then begin key:=0; BitBtn15Click(self); Exit; End;                    // Imprime el pre/pro en uso.
 if (key=VK_ESCAPE) and (dbGrid2.Visible=true) then begin key:=0; BitBtn5Click(self); Exit; End;                  // salir de la edicion de documentos.

end;

//==================== CERRAR PEDIDOS =====================
procedure TFPedido.BitBtn2Click(Sender: TObject);
begin
  dbPedic.Active:=False;
  Close();
end;
procedure TFPedido.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//==========================================================================
//======================= FILTROS PARA LOS PEDIDOS =========================
//==========================================================================
//----------------- Todos los pedidos ---------------
procedure TFPedido.RadioButton28Click(Sender: TObject);
begin
  TIPOPEDIDO:=''; NOMBREPEDIDO:='PEDIDOS/NOTAS/ALB./FACT.'; LETRAPEDIDO:='LOS';
  if RadioButton1.Checked=true then RadioButton1Click(RadioButton1);
  if RadioButton2.Checked=true then BitBtn3Click(BitBtn3);
  if RadioButton3.Checked=true then BitBtn4Click(BitBtn4);
end;
//----------------- Pedidos normales ---------------
procedure TFPedido.RadioButton29Click(Sender: TObject);
begin
  TIPOPEDIDO:='P'; NOMBREPEDIDO:='PEDIDOS'; LETRAPEDIDO:='LOS';
  if RadioButton1.Checked=true then RadioButton1Click(RadioButton1);
  if RadioButton2.Checked=true then BitBtn3Click(BitBtn3);
  if RadioButton3.Checked=true then BitBtn4Click(BitBtn4);
end;

//----------------- Notas de entregas ---------------
procedure TFPedido.RadioButton30Click(Sender: TObject);
begin
  TIPOPEDIDO:='N'; NOMBREPEDIDO:='NOTAS DE ENTREGAS'; LETRAPEDIDO:='LAS';
  if RadioButton1.Checked=true then RadioButton1Click(RadioButton1);
  if RadioButton2.Checked=true then BitBtn3Click(BitBtn3);
  if RadioButton3.Checked=true then BitBtn4Click(BitBtn4);
end;
//----------------- Albaranes ---------------
procedure TFPedido.RadioButton31Click(Sender: TObject);
begin
  TIPOPEDIDO:='A'; NOMBREPEDIDO:='ALBARANES'; LETRAPEDIDO:='LOS';
  if RadioButton1.Checked=true then RadioButton1Click(RadioButton1);
  if RadioButton2.Checked=true then BitBtn3Click(BitBtn3);
  if RadioButton3.Checked=true then BitBtn4Click(BitBtn4);
end;
//----------------- Facturas ---------------
procedure TFPedido.RadioButton40Click(Sender: TObject);
begin
  TIPOPEDIDO:='F'; NOMBREPEDIDO:='FACTURAS'; LETRAPEDIDO:='LAS';
  if RadioButton1.Checked=true then RadioButton1Click(RadioButton1);
  if RadioButton2.Checked=true then BitBtn3Click(BitBtn3);
  if RadioButton3.Checked=true then BitBtn4Click(BitBtn4);
end;

//============== TODOS LOS PEDIDOS POR FECHAS =====================
procedure TFPedido.RadioButton1Click(Sender: TObject);
begin
  Panel2.Visible:=False; Panel3.Visible:=False;
  dbPedic.Active:=False;
  dbPedic.SQL.Text:='SELECT * FROM pedicc'+Tienda;
  if TIPOPEDIDO<>'' then dbPedic.SQL.Text:=dbPedic.SQL.Text+' WHERE PC28="'+TIPOPEDIDO+'"';
  dbPedic.SQL.Text:=dbPedic.SQL.Text+' ORDER BY PC0 ASC, PC1 DESC, PC2 ASC, PC3 ASC, PC4 DESC';
  dbPedic.Active:=True; DBGrid1.Enabled:=True;
  StaticText5.Caption:='TODOS '+LETRAPEDIDO+' '+NOMBREPEDIDO+' ORDENADOS POR FECHAS';
end;

//============== PEDIDOS DE UN PROVEEDOR ========================
procedure TFPedido.RadioButton2Click(Sender: TObject);
begin
  Panel2.Visible:=True; Panel3.Visible:=False; Edit1.SetFocus;
  DBGrid1.Enabled:=False; Edit1.SetFocus;
end;

procedure TFPedido.BitBtn3Click(Sender: TObject);
begin
  If Edit1.Text='' then Exit;
  dbPedic.Sql.Text:='SELECT * FROM pedicc'+Tienda+' WHERE PC2='+Edit1.Text;
  if TIPOPEDIDO<>'' then dbPedic.SQL.Text:=dbPedic.SQL.Text+' AND PC28="'+TIPOPEDIDO+'"';
  dbPedic.SQL.Text:=dbPedic.SQL.Text+' ORDER BY PC0 ASC, PC1 DESC, PC2 ASC, PC3 ASC, PC4 DESC';
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
procedure TFPedido.Edit1Enter(Sender: TObject);
begin
   Edit2.Text:='';
end;
procedure TFPedido.Edit1Exit(Sender: TObject);
begin
   If Edit1.Text='' then Exit;
   dbProve.SQL.Text:='SELECT * FROM proveedores WHERE P0='+Edit1.Text;
   dbProve.Active:=True;
   If dbProve.RecordCount=0 then Begin Showmessage('ESE PROVEEDOR NO EXISTE.'); Edit2.SetFocus; Exit; End;
   Edit2.Text:=dbProve.FieldByName('P1').AsString;
end;
//---------------- Buscar por nombre
procedure TFPedido.BitBtn7Click(Sender: TObject);
begin
  if Edit2.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit2.SetFocus; Exit; end;
  Edit1.Text := FBusquedas.IniciaBusquedas('SELECT P0, P1, P2 FROM proveedores WHERE P1 LIKE "'+Edit2.Text+'%"',
           ['Codigo', ' Razón social ', ' Dirección ' ], 'P0' );

  if Edit1.Text<>'' then begin Edit1Exit(Edit1); end;
end;
procedure TFPedido.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then BitBtn7Click(BitBtn7);
end;

//============== PEDIDOS ENTRE FECHAS ========================
procedure TFPedido.RadioButton3Click(Sender: TObject);
begin
  Panel3.Visible:=True; Panel2.Visible:=False;
  DateEdit1.Date:=Date; DateEdit2.Date:=Date;
  DBGrid1.Enabled:=False; DateEdit1.SetFocus;
end;
procedure TFPedido.BitBtn4Click(Sender: TObject);
begin
  If (DateEdit1.Date>DateEdit2.Date) then begin showmessage('LA PRIMERA FECHA ES MAYOR QUE LA SEGUNDA'); exit; end;
  dbPedic.Sql.Text:='SELECT * FROM pedicc'+Tienda+' WHERE PC1>="'+
                    FormatDateTime('YYYY/MM/DD',DateEdit1.Date)+'" AND PC1<="'+
                    FormatDateTime('YYYY/MM/DD',DateEdit2.Date)+'"';
  if TIPOPEDIDO<>'' then dbPedic.SQL.Text:=dbPedic.SQL.Text+' AND PC28="'+TIPOPEDIDO+'"';
  dbPedic.SQL.Text:=dbPedic.SQL.Text+' ORDER BY PC0 ASC, PC1 DESC, PC2 ASC, PC3 ASC, PC4 DESC';
  dbPedic.Active := True;
  StaticText5.Caption:=NOMBREPEDIDO+'PEDIDOS DESDE: '+DateEdit1.Text+' HASTA: '+DateEdit2.Text;
  If dbPedic.RecordCount=0 then
    begin
      //Showmessage('NO HAY PEDIDOS ENTRE ESAS FECHAS');
      Panel3.Visible:=False; DBGrid1.Enabled:=True; exit;
    end;
  Panel3.Visible:=False; DBGrid1.Enabled:=True;
end;

//============= MOSTRAR DATOS DEL PEDIDO AL MOVERSE POR EL GRID ========
procedure TFPedido.Datasource1DataChange(Sender: TObject; Field: TField);
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
procedure TFPedido.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if dbPedic.FieldByName('PC15').AsString<>'' then
   begin
     DBGrid1.Canvas.Font.Color := clBlue;
     //DBGrid2.Canvas.Brush.Color := $00CDDAF1;
     DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
   end;
end;

procedure TFPedido.DBGrid2DblClick(Sender: TObject);
begin
  BitBtn13Click(Self);
end;

//=================================================================
//====================== PEDIDO NUEVO =============================
//=================================================================

//================= Importar pedidos de fichero externo ==========
procedure TFPedido.BitBtnImportarClick(Sender: TObject);
begin

  //ShowformImportar;
  FImportar.IniciaImportar(dbPedid, dbPedic);
end;

procedure TFPedido.BitBtn9Click(Sender: TObject);
begin
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
  dbTiendas.Active:=False; BitBtn23.BringToFront;
  Panel8.Visible:=True;
  Panel1.Enabled:=False; DBGrid1.Enabled:=False;
  Edit23.SetFocus;
end;

//--------------- Moverse por la series del pedido ---------------------
procedure TFPedido.Datasource3DataChange(Sender: TObject; Field: TField);
begin
  Edit21.Text:=IntToStr(dbSeries.FieldByName('SF7').AsInteger+1);//--- Cambiar el N.Pedido
end;


//--------------- Aceptar nuevo pedido -----------------
procedure TFPedido.BitBtn19Click(Sender: TObject);
begin
  if Edit23.Text='' then begin showmessage('DEBE PONER UN PROVEEDOR PARA EL PEDIDO'); exit; end;
  If Application.MessageBox('CREAR UN PEDIDO NUEVO CON DATOS?','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  SPEDIDO:=dbSeries.FieldByName('SF0').AsString;
  dbPedic.Append; Llenacc(); dbPedic.Post;
  NumeroPedido();//-------------- Aumentar numero de pedido
  BitBtn20Click(BitBtn20);//----- Cerrar panel nuevo pedido
  BitBtn1Click(BitBtn1);//------- Gestionar el pedido
end;

//---------------- Cancelar nuevo pedido ----------------
procedure TFPedido.BitBtn20Click(Sender: TObject);
begin
  Panel8.Visible:=False;
  Panel1.Enabled:=True; DBGrid1.Enabled:=True;
end;

//---------------- Codigo Proveedor -----------------
procedure TFPedido.Edit23Enter(Sender: TObject);
begin
  Edit25.Text:='';
end;
procedure TFPedido.Edit23Exit(Sender: TObject);
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
procedure TFPedido.Edit25KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then BitBtn40Click(BitBtn40);
end;
procedure TFPedido.BitBtn40Click(Sender: TObject);
begin
  if Edit25.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit25.SetFocus; Exit; end;
  Edit23.Text := FBusquedas.IniciaBusquedas('SELECT P0, P1, P2 FROM proveedores WHERE P1 LIKE "%'+Edit25.Text+'%"',
           ['Codigo', ' Razón social ', ' Dirección ' ], 'P0' );
  if Edit23.Text<>'' then begin Edit23Exit(Edit23); end;
end;

//=================================================================
//====================== BORRAR PEDIDO ============================
//=================================================================
procedure TFPedido.BitBtn10Click(Sender: TObject);
begin
  If dbPedic.RecordCount=0 then Begin Showmessage('NO HAY NINGUN FACTURA PARA BORRAR'); Exit; End;
  dbProve.SQL.Text:='SELECT * FROM proveedores WHERE P0='+dbPedic.FieldByName('PC2').AsString;
  dbProve.Active:=True;
  If dbProve.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL PROVEEDOR '+dbPedic.FieldByName('PC0').AsString+' ?'); Exit; End;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('CONFIRME EL BORRADO DEL PEDIDO?','FacturLinEx', boxstyle) = IDNO Then Exit;
  //-------- Restar unidades pendientes de la ficha del articulo ---------
  dbPedid.SQL.Text:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic.FieldByName('PC4').AsString;
  dbPedid.Active:=True;
  dbPedid.First;
  while not dbPedid.EOF do
    begin
      SumaPendientes(dbPedid.FieldByName('PD6').AsString,
             FloatToStr(dbPedid.FieldByName('PD8').AsFloat*-1));//----- Restar unidades pendientes
      dbPedid.Next;
    end;
  dbPedid.Active:=False;
  //-------- Borrar Pedido
  dbTrabajo.SQL.Text:='DELETE FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic.FieldByName('PC4').AsString;
  dbTrabajo.ExecSQL;//-- Borrar lineas del pedido
  dbPedic.Delete;//----- Borrar cabecera del pedidos
end;

//==================================================================
//===================== GESTIONAR PEDIDOS ==========================
//==================================================================
procedure TFPedido.BitBtn1Click(Sender: TObject);
begin
  If dbPedic.RecordCount=0 then Begin Showmessage('NO HAY NINGUN PEDIDO PARA GESTIONAR'); Exit; End;
  dbProve.SQL.Text:='SELECT * FROM proveedores WHERE P0='+dbPedic.FieldByName('PC2').AsString;
  dbProve.Active:=True;
  If dbProve.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL PROVEEDOR '+dbPedic.FieldByName('PC2').AsString+' ?'); Exit; End;
  Panel4.BringToFront; Panel4.Visible:=True;
  DBGrid2.BringToFront; DBGrid2.Visible:=True;
  MostrarBotonesdd();
  LimpiaProveedor();
  dbPedid.SQL.Text:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic.FieldByName('PC4').AsString;
  dbPedid.Active:=True;
  PintaProveedor();
  Label48.Caption:=dbPedic.FieldByName('PC3').AsString;//---- Serie
  Label31.Caption:=dbPedic.FieldByName('PC4').AsString;//---- N. Pedido
  Label33.Caption:=dbPedic.FieldByName('PC1').AsString;//---- Fecha Pedido
  LabelTotal.Caption:=FormatFloat('###,###,##0.000',dbPedic.FieldByName('PC8').AsFloat);
  dbGrid2.SetFocus;
end;

//=================== CREAR LINEAS DE PEDIDO ========================
procedure TFPedido.BitBtn12Click(Sender: TObject);
begin
  Panel7.Visible:=False;
  Panel6.Visible:=True; Edit5.Enabled:=True; Edit38.Enabled:=True;
  Panel1.Enabled:=False; DBGrid2.Enabled:=False;
  Limpiadd(); Edit5.SetFocus;
end;

//================== BORRAR LINEAS =====================
procedure TFPedido.BitBtn14Click(Sender: TObject);
begin
  Panel7.Visible:=False;
  if dbpedid.Eof=True then
    begin
      Showmessage('ESA LINEA NO EXISTE, NO PUEDE BORRARLA');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DE LA LINEA?','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  SumaPendientes(dbPedid.FieldByName('PD6').AsString,
                 FloatToStr(dbPedid.FieldByName('PD8').AsFloat*-1));//----- Restar unidades pendientes
  dbPedid.Delete;
end;

//=================== MODIFICAR LINEAS DE PEDIDO ========================
procedure TFPedido.BitBtn13Click(Sender: TObject);
begin
  Panel7.Visible:=False;
  if (dbPedid.Active=False) or (dbPedid.RecordCount=0) then exit;;
  Panel6.Visible:=True; Panel1.Enabled:=False; DBGrid2.Enabled:=False;
  Edit5.Text:=dbPedid.FieldByName('PD6').AsString;//------ Codigo
  Edit5.Enabled:=False; Edit38.Enabled:=False;
  //--- Leerr Articulo
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount=0 then showmessage('SE HA BORRADO LA FICHA DE ESTE ARTICULO?');
  //-----------------
  Edit6.Text:=dbPedid.FieldByName('PD7').AsString;//------ Descripcion
  Edit7.Text:=dbPedid.FieldByName('PD8').AsString;//------ Unidades
  Edit39.Text:=dbPedid.FieldByName('PD8B').AsString;//------ Unidades bonificadas
  Edit8.Text:=FormatFloat('0.00000',dbPedid.FieldByName('PD10').AsFloat);//-- Costo
//  Edit31.Text:=FormatFloat('0.000',dbPedid.FieldByName('PD12').AsFloat);//- Precio venta(Sin Iva)
  Edit18.Text:=dbPedid.FieldByName('PD13').AsString;//--------------------- % Recargo
  Edit9.Text:=dbPedid.FieldByName('PD14').AsString;//---------------------- Iva
  Edit10.Text:=FormatFloat('0.00000',dbPedid.FieldByName('PD15').AsFloat);//- Precio de costo (Con Iva)
  Edit11.Text:=FormatFloat('0.000',dbPedid.FieldByName('PD11').AsFloat);//- Margen
  Edit37.Text:=FormatFloat('0.000',dbPedid.FieldByName('PD30').AsFloat);//- Margen sobre PVP
  Edit12.Text:=FormatFloat('0.00',dbPedid.FieldByName('PD16').AsFloat);//-- Precio PVP
  Edit13.Text:=FormatFloat('0.0000',dbPedid.FieldByName('PD17').AsFloat);//-- Imp. Linea Costo + Impuestos
  Edit19.Text:=FormatFloat('0.000',dbPedid.FieldByName('PD26').AsFloat);//- P.Tarifa
  Edit22.Text:=FormatFloat('0.000',dbPedid.FieldByName('PD27').AsFloat);//- Dto. Importe
  Edit27.Text:=FormatFloat('0.000',dbPedid.FieldByName('PD28').AsFloat);//- Dto % 1
  Edit29.Text:=FormatFloat('0.000',dbPedid.FieldByName('PD29').AsFloat);//- Dto % 2
  Edit31.Text:=FormatFloat('0.00000',dbPedid.FieldByName('PD12').AsFloat);//- Precio venta(Sin Iva)
  //-- Seleccionamos la familia de donde corresponde
  //-- Edit32.Text:=dbArti.FieldByName('A14').AsString;//----------------------- Familia
  Edit32.Text:=dbPedid.FieldByName('PD19').AsString;
  Edit32Exit(Edit32);//---------------------------------------------------- Nombre Familia
  Edit7.SetFocus;
end;

//----------------- Salir Crear / Modificar Lineas ------------------
procedure TFPedido.BitBtn6Click(Sender: TObject);
begin
  Panel6.Visible:=False;
  Panel1.Enabled:=True; DBGrid2.Enabled:=True;
end;

//----------------- Aceptar Crear / Modificar Lineas ----------------
procedure TFPedido.BitBtn8Click(Sender: TObject);
begin
  if Edit5.Text='' then Exit;;
  if Edit5.Enabled=False then
   begin
    //----- Modificar Linea
    SumaPendientes(dbPedid.FieldByName('PD6').AsString,
                   FloatToStr(dbPedid.FieldByName('PD8').AsFloat*-1));//----- Restar unidades pendientes
    dbPedid.Edit; Llenadd(); dbPedid.Post;
    SumaPendientes(dbPedid.FieldByName('PD6').AsString,Edit7.Text);//----- Sumar unidades pendientes
   end
  else
   begin
    //----- Crear linea
    if SwCrea=1 then begin CrearArticulo(); SwCrea:=0; end;
    //---------- Creamos un nuevo registro EAN
    if Edit38.Text<>'' then CrearEan();

    dbPedid.Append; Llenadd(); dbPedid.Post;
    SumaPendientes(Edit5.Text,Edit7.Text);//----- Sumar unidades pendientes
   end;

  //ModificaTarifaCompra();//----- Tarifa de compras en la ficha del articulo

  PintarTotalGeneral();
  Panel6.Visible:=False;
  Panel1.Enabled:=True; DBGrid2.Enabled:=True;
//-- Por Jose, para que se cierre la ventana tras modificación
  if Edit5.Enabled=False then BitBtn6Click(self) else BitBtn12Click(BitBtn12);
end;

//=================== MARCAR LINEAS DE PEDIDO ========================
procedure TFPedido.BitBtn37Click(Sender: TObject);
begin
  if dbPedid.RecordCount=0 then exit;
  if dbPedid.FieldByName('PD23').AsString='S' then
    begin
     dbPedid.Edit; dbPedid.FieldByName('PD23').AsString:='N'; dbPedid.Post;
    end
  else
    begin
     dbPedid.Edit; dbPedid.FieldByName('PD23').AsString:='S'; dbPedid.Post;
    end
end;
procedure TFPedido.DBGrid2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then exit else BitBtn37Click(BitBtn37);
end;

procedure TFPedido.DBGrid2TitleClick(Column: TColumn);
var
  corden: string;
begin
//--  Colorea(Column,DBGrid2,dbPedid, AntColun, Orden, TituloColumn, Ordenado);
  DBGrid2.Enabled:=False;
  corden:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.FieldByName('PC0').AsString+
                       ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
                       ' AND PD2='+dbPedic.FieldByName('PC2').AsString+
                       ' AND PD3="'+dbPedic.FieldByName('PC3').AsString+'"'+
                       ' AND PD4='+dbPedic.FieldByName('PC4').AsString+
                       ' ORDER BY '+Column.FieldName+' '+sOrden;
  if sOrden='DESC' then sOrden:='ASC' else sOrden:='DESC';
  dbPedid.Sql.Text:=corden; dbPedid.Active:=True;
  dbPedid.Refresh; DBGrid2.Refresh;
  DBGrid2.Enabled:=True;
end;

//---------------- PINTAR LINEAS MARCADAS EN ROJO ----------------
procedure TFPedido.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if dbPedid.FieldByName('PD23').AsString='N' then
    begin
      DBGrid2.Canvas.Font.Color := clRed;
      //DBGrid2.Canvas.Brush.Color := $00CDDAF1;
      DBGrid2.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
end;

procedure TFPedido.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then begin Key:=0; BitBtn13Click(self); end;
end;

//======================== DATOS DOCUMENTO PROVEEDOR =======================
procedure TFPedido.MenuItem2Click(Sender: TObject);
begin
  Edit35.Text:=''; DateEdit11.Clear;
  if (dbPedic.FieldByName('PC28').AsString='P') or (dbPedic.FieldByName('PC28').AsString='') then
      RadioButton41.Checked:=True;//- Pedido
  if dbPedic.FieldByName('PC28').AsString='N' then RadioButton42.Checked:=True;//- Nota
  if dbPedic.FieldByName('PC28').AsString='A' then RadioButton17.Checked:=True;//- Albaran
  if dbPedic.FieldByName('PC28').AsString='F' then RadioButton18.Checked:=True;//- Factura del proveedor
  Edit35.Text:=dbPedic.FieldByName('PC29').AsString;//------------- Numero Documento Proveedor
  if dbPedic.FieldByName('PC30').AsString<>'' then
     DateEdit11.Date:=dbPedic.FieldByName('PC30').AsDateTime;//---- Fecha Documento Proveedor
  Panel16.Visible:=True;
end;

//-------------- Salir doc. proveedor ---------
procedure TFPedido.BitBtn38Click(Sender: TObject);
begin
  Panel16.Visible:=False;
end;
//-------------- Modificar doc. proveedor ---------
procedure TFPedido.BitBtn39Click(Sender: TObject);
begin
  If Application.MessageBox('MODIFICAR LOS DATOS DEL DOCUMENTO DEL PROVEEDOR?','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbPedic.Edit;
  //------- Albaran o Factura
  if RadioButton41.Checked=True then dbPedic.FieldByName('PC28').AsString:='P';
  if RadioButton42.Checked=True then dbPedic.FieldByName('PC28').AsString:='N';
  if RadioButton17.Checked=True then dbPedic.FieldByName('PC28').AsString:='A';
  if RadioButton18.Checked=True then dbPedic.FieldByName('PC28').AsString:='F';
  dbPedic.FieldByName('PC29').AsString:=Edit35.Text;//---------- N. Documento Proveedor
  dbPedic.FieldByName('PC30').AsDateTime:=DateEdit11.Date;//---- Fecha Documento Proveedor
  dbPedic.Post;
  BitBtn38Click(BitBtn38);
end;


//==================== LLENAR DATOS CABECERAS =======================
procedure TFPedido.Llenacc();
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
procedure TFPedido.Llenadd();
begin
  // -- Si esta creando nueva
  if Edit5.Enabled=true then
    begin
     dbPedid.FieldByName('PD0').Value:=dbPedic.FieldByName('PC0').Value;//----- N. Tienda
     dbPedid.FieldByName('PD1').Value:=dbPedic.FieldByName('PC1').Value;//----- Fecha
     dbPedid.FieldByName('PD2').Value:=dbPedic.FieldByName('PC2').Value;//----- Proveedor
     dbPedid.FieldByName('PD3').Value:=dbPedic.FieldByName('PC3').Value;//----- Serie
     dbPedid.FieldByName('PD4').Value:=dbPedic.FieldByName('PC4').Value;//----- N. Pedido
     dbPedid.FieldByName('PD5').Value:=VerUltimaLinea;//------- N. Linea
     dbPedid.FieldByName('PD6').AsString:=Edit5.Text;//-------- Codigo articulo
    end;
  dbPedid.FieldByName('PD7').AsString:=Edit6.Text;//----------- Descripcion
  dbPedid.FieldByName('PD8').AsString:=Edit7.Text;//----------- Unidades
  dbPedid.FieldByName('PD8B').AsString:=Edit39.Text;//----------- Unidades Bonificadas
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

  //---- Se coje la familia del fichero de articulos o de los pedidos
  if Edit5.Enabled=True then
    begin
     //-- showmessage('Ojo es nuevo');
     dbPedid.FieldByName('PD19').Value:=dbArti.FieldByName('A14').Value; //-- Familia
    end
  else
    begin
     //-- showmessage('Modificado con familia - '+Edit32.Text);
     dbPedid.FieldByName('PD19').Value:=Edit32.Text;//-- Familia
    end;

  //---- Si crea la linea poner los datos de las ventas
  if Edit5.Enabled=True then
    begin
      dbPedid.FieldByName('PD20').Value:=dbArti.FieldByName('A4').Value;//----- Stock actual en el momento de pedir

      dbPedid.FieldByName('PD21').AsString:='0';//---------- Unidades vendidas de X a X año actual
      dbPedid.FieldByName('PD22').AsString:='0';//---------- Unidades vendidas de X a X año anterior
    end;

  dbPedid.FieldByName('PD23').AsString:='S';//-------------- Recibido S/N (Por defecto siempre si)
  dbPedid.FieldByName('PD24').AsString:='';//--------------- Serie de colores
  dbPedid.FieldByName('PD25').AsString:='';//--------------- Serie de tallas
  dbPedid.FieldByName('PD26').Value:=Edit19.Text;//--------- Precio Tarifa
  dbPedid.FieldByName('PD27').AsString:=Edit22.Text;//------ Dto Importe
  dbPedid.FieldByName('PD28').AsString:=Edit27.Text;//------ Dto % 1
  dbPedid.FieldByName('PD29').AsString:=Edit29.Text;//------ Dto % 2
  dbPedid.FieldByName('PD30').AsString:=Edit37.Text;//------ Margen sobre PVP


end;

//=================== SACAR EL ULT N. DE LINEA =====================
function TFPedido.VerUltimaLinea: Integer;
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

//======================= PINTAR DATOS LINEAS ==================
procedure TFPedido.Pintadd();
begin
  Edit5.Text:=dbArti.FieldByName('A0').AsString;//------ Codigo
  Edit6.Text:=dbArti.FieldByName('A1').AsString;//-------- Descripcion
  Edit7.Text:='1';//-------------------------------------- Unidades
  Edit39.Text:='0';//-------------------------------------- Unidades Bonificadas
  Edit8.Text:=FormatFloat('0.000',dbArti.FieldByName('A24').AsFloat);//---- Costo
  Edit9.Text:=dbArti.FieldByName('A3').AsString;//-------- Iva
  Edit18.Text:= dbArti.FieldByName('A36').AsString;//--------- Recargo de equivalencia
  Edit10.Text:=FormatFloat('0.000',(dbArti.FieldByName('A24').AsFloat*dbArti.FieldByName('A3').AsFloat/100)+dbArti.FieldByName('A24').AsFloat);//---------- Precio de costo (Con Iva)
  Edit11.Text:=FormatFloat('0.000',dbArti.FieldByName('A26').AsFloat);//--- Margen
  Edit37.Text:=FormatFloat('0.000',dbArti.FieldByName('A37').AsFloat);//--- Margen sobre PVP
  Edit12.Text:=FormatFloat('0.00',dbArti.FieldByName('A2').AsFloat);//----- Precio PVP
  Edit13.Text:=Edit10.Text;//-- Imp. Linea Costo + Impuestos
  Edit19.Text:=FormatFloat('0.000',dbArti.FieldByName('A28').AsFloat);//--- P.Tarifa
  Edit22.Text:=FormatFloat('0.000',dbArti.FieldByName('A29').AsFloat);//--- Dto. Importe
  Edit27.Text:=FormatFloat('0.000',dbArti.FieldByName('A30').AsFloat);//--- Dto % 1
  Edit29.Text:=FormatFloat('0.000',dbArti.FieldByName('A31').AsFloat);//--- Dto % 2
  Edit31.Text:=FormatFloat('0.000',dbArti.FieldByName('A21').AsFloat);//- Precio venta(Sin Iva)
  Edit32.Text:=dbArti.FieldByName('A14').AsString;//----------------------- Familia
  Edit38.Text:='';//------------------------------------------------------- Borramos EAN
  Edit32Exit(Edit32);//---------------------------------------------------- Nombre Familia
end;

//======================= LIMPIAR DATOS LINEAS ==================
procedure TFPedido.Limpiadd();
begin
  Edit5.Text:=''; Edit6.Text:=''; Edit7.Text:='0'; Edit39.Text:='0';
  Edit8.Text:='0'; Edit9.Text:='0'; Edit10.Text:='0';
  Edit11.Text:='0'; Edit12.Text:='0'; Edit13.Text:='0'; Edit18.Text:='0';
  Edit19.Text:='0'; Edit22.Text:='0'; Edit27.Text:='0'; Edit29.Text:='0';
  Edit31.Text:='0'; Edit32.Text:='0'; Edit33.Text:='0'; Edit37.Text:='0';
end;

//================== MODIFICAR TARIFA DE COMPRA =================
procedure TFPedido.ModificaTarifaCompra();
begin
  if (dbArti.RecordCount=0) or (dbArti.EOF) then exit;
  dbArti.Edit;
  dbArti.FieldByName('A28').AsString:=Edit19.Text;//--- P.Tarifa
  dbArti.FieldByName('A29').AsString:=Edit22.Text;//--- Dto. Importe
  dbArti.FieldByName('A30').AsString:=Edit27.Text;//--- Dto % 1
  dbArti.FieldByName('A31').AsString:=Edit29.Text;//--- Dto % 2
  dbArti.Post;
end;

//=============== SALIR DEL CGO. ARTICULO =====================
procedure TFPedido.Edit5Exit(Sender: TObject);
begin
  if (Edit5.Enabled=False) or (Edit5.Text='') then exit;
  if LeerArticulo=False then
     if LeerAuxiliar=False then
        begin
          Beep; boxstyle :=  MB_ICONQUESTION + MB_YESNO;
          if Application.MessageBox('ESTE ARTICULO NO EXISTE, LO CREAMOS AHORA?','FacturLinEx', boxstyle) = IDNO Then
             begin Edit5.SetFocus; SwCrea:=0; Exit; end;
          SwCrea:=1;//----- Crear Articulo.
        end;
end;
//------------------ Buscar Articulos ---------------
procedure TFPedido.BitBtn24Click(Sender: TObject);
begin
  if (Edit5.Enabled=False) then
     begin showmessage('NO PUEDE BUSCAR UN ARTICULO NUEVO, ESTA MODIFICANDO'); exit; end;
  if Edit6.Text='' then
     begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit6.SetFocus; Exit; end;

  Edit5.Text := FBusquedas.IniciaBusquedas('SELECT A0, A1, A2, A4 FROM artitien'+Tienda+' WHERE A1 LIKE "'+Edit6.Text+'%"',
           ['codigo', ' Descripción ', ' Precio ', ' Stock ' ], 'A0' );

  if Edit5.Text<>'' then begin Edit5Exit(Edit5); Edit7.SetFocus; end;
end;
procedure TFPedido.Edit6KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn24Click(BitBtn24);
end;

//==================== SALIR DEL PRECIO DE TARIFA ====================
procedure TFPedido.Edit19Exit(Sender: TObject);
Var
  MenosEuros: Double;
begin
  if VersiNumero(Edit19.text)=False then Edit19.Text:='0';
  if Edit19.Text='' then Edit19.Text:='0';
  MenosEuros:=StrToFloat(Edit19.Text);
  if Edit22.Text<>'0' then MenosEuros := StrtoFloat(Edit19.Text)-StrtoFloat(Edit22.Text);
  if Edit27.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit27.Text) / 100);
  if Edit29.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit29.Text) / 100);
  if MenosEuros<>0 then Edit8.Text := FormatFloat('0.000',MenosEuros);//-- Costo
end;

//==================== SALIR DEL DTO EN IMPORTE ====================
procedure TFPedido.Edit22Exit(Sender: TObject);
var
  MenosEuros: Double;
begin
  if VersiNumero(Edit22.text)=False then Edit22.Text:='0';
  if Edit19.Text='' then Edit19.Text:='0';
  if Edit22.Text='' then Edit22.Text:='0';
  MenosEuros := StrtoFloat(Edit19.Text)-StrtoFloat(Edit22.Text);
  if Edit27.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit27.Text) / 100);
  if Edit29.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit29.Text) / 100);
  if MenosEuros<>0 then Edit8.Text := FormatFloat('0.000',MenosEuros);//-- Costo
end;

//==================== SALIR DEL DTO % 1 ====================
procedure TFPedido.Edit27Exit(Sender: TObject);
Var
  MenosEuros: Double;
begin
  if VersiNumero(Edit27.text)=False then Edit27.Text:='0';
  if Edit19.Text='' then Edit19.Text:='0';
  if Edit27.Text='' then Edit27.Text:='0';
  MenosEuros:=StrToFloat(Edit19.Text);
  if Edit22.Text<>'0' then MenosEuros := StrtoFloat(Edit19.Text)-StrtoFloat(Edit22.Text);
  if Edit27.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit27.Text) / 100);
  if Edit29.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit29.Text) / 100);
  if MenosEuros<>0 then Edit8.Text := FormatFloat('0.000',MenosEuros);
end;

//==================== SALIR DEL DTO % 2 ====================
procedure TFPedido.Edit29Exit(Sender: TObject);
Var
  MenosEuros: Double;
begin
  if VersiNumero(Edit29.text)=False then Edit29.Text:='0';
  if Edit19.Text='' then Edit19.Text:='0';
  if Edit29.Text='' then Edit29.Text:='0';
  MenosEuros:=StrToFloat(Edit19.Text);
  if Edit22.Text<>'0' then MenosEuros := StrtoFloat(Edit19.Text)-StrtoFloat(Edit22.Text);
  if Edit27.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit27.Text) / 100);
  if Edit29.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit29.Text) / 100);
  if MenosEuros<>0 then Edit8.Text := FormatFloat('0.000',MenosEuros);
end;

//===================== SALIR DE LA CANTIDAD ======================
procedure TFPedido.Edit7Exit(Sender: TObject);
begin
  if Edit7.Text=ValorEntrada then exit;
  if VersiNumero(Edit7.text)=False then Edit7.Text:='0';
  Edit13.Text:=FormatFloat('0.000',StrToFloat(Edit7.Text)*StrToFloat(Edit10.Text));//--- Importe
end;

//===================== SALIR DEL COSTO ======================
procedure TFPedido.Edit8Exit(Sender: TObject);
var
  PrecioSin, PrecioCon, Recargo, RecargoCosto, MargenSPvpP, Margen, PvcImpuestos : Double;
begin
  if Edit8.Text=ValorEntrada then exit;
  if VersiNumero(Edit8.text)=False then Edit8.Text:='0';

  if (Edit18.Text='') or (Edit18.Text='0') then Edit18.Text:='0';
  if (Edit9.Text='') or (Edit9.Text='0') then Edit9.Text:='0';

//  RecargoCosto:= (StrToFloat(Edit8.Text)*StrToInt(Edit18.Text) / 100);//- Recargo

 //---- Importe linea Costo + impuestos
  Edit10.Text:=FormatFloat('0.00000',(StrToFloat(Edit8.Text)*(1 + StrToFloat(Edit9.Text)/100)));

  Edit13.Text:=FormatFloat('0.00000',StrToFloat(Edit7.Text)*StrToFloat(Edit10.Text));//--- Importe

 //---- P.V.P. si hay margen.
  if (StrToFloat(Edit11.text)<>0) and (StrToFloat(Edit8.text)<>0) then
    begin
      PrecioSin:=(StrToFloat(Edit8.text)*(1+(StrToFloat(Edit11.text)/100)));//-- + Margen
      PrecioCon:= PrecioSin*(1 + (StrToFloat(Edit9.Text)/100));//------------------ + IVA
      Edit31.Text:=FormatFloat('0.00000',PrecioSin);//---- PVP sin IVA
      Edit12.Text:=FormatFloat('0.000',PrecioCon);//---- PVP
    end;

  //--- Calculamos MARGEN si hay PVP
   if (StrToFloat(Edit12.text)<>0) and (StrToFloat(Edit8.text)<>0) then
     begin
       PvcImpuestos:=StrToFloat(Edit8.text)* (1+ (StrToFloat(Edit9.text)+StrToFloat(Edit18.Text))/100);
       Margen:= ((StrToFloat(Edit12.Text) - PvcImpuestos) * 100) / PvcImpuestos;
       MargenSPvpP:=((PvcImpuestos / StrToFloat(Edit12.text)) -1 ) * (-100);
       Edit11.Text := FormatFloat('0.000',Margen); //-------- Margen Normal
       Edit37.Text := FormatFloat('0.000',MargenSPvpP);  //-- Margen Sobre el PVP
     end;
end;

//===================== SALIR DEL IVA ======================
procedure TFPedido.Edit9Exit(Sender: TObject);
var
  PrecioCon, RecargoCosto, Margen,MargenSPvpP,PvcImpuestos: Double;
begin
  if Edit9.Text = ValorEntrada then exit;
  if VersiNumero(Edit9.text)=False then Edit9.Text:='0';

  //---- P.V.P.
  PrecioCon:=StrToFloat(Edit31.Text)*(1+(StrToFloat(Edit9.Text)/100));
  Edit12.Text:=FormatFloat('0.000',PrecioCon);//---- Pvp

  //---- Importe linea Costo + impuestos
  RecargoCosto:=(StrToFloat(Edit8.Text)*StrToFloat(Edit18.Text) / 100);//- Recargo
  Edit10.Text:=FormatFloat('0.00000',(StrToFloat(Edit8.Text)*(1+ (StrToFloat(Edit9.Text)/ 100)) + RecargoCosto));
  Edit13.Text:=FormatFloat('0.00000',StrToFloat(Edit7.Text)*StrToFloat(Edit10.Text));//--- Importe

  //---- Margenes
  if StrToFloat(Edit8.text)=0 then
  begin
    if StrToFloat(Edit10.text)=0 then
      begin
         Edit11.text:='0';
         Edit37.text:='0';
         exit;
      end
   else
      begin
         Edit8.text:=FloatToStr(StrToFloat(Edit10.text)/ (1+((StrToFloat(Edit9.text) + StrToFloat(Edit18.Text))/100)));
      end;
  end;

  PvcImpuestos:=StrToFloat(Edit8.text)* (1+ ((StrToFloat(Edit9.text) + StrToFloat(Edit18.Text))/100));
  Margen:= ((StrToFloat(Edit12.Text) - PvcImpuestos) * 100) / PvcImpuestos;
  MargenSPvpP:=((PvcImpuestos / StrToFloat(Edit12.text)) -1 ) * (-100);

  Edit11.Text := FormatFloat('0.000',Margen); //-------- Margen Normal
  Edit37.Text := FormatFloat('0.000',MargenSPvpP);  //-- Margen Sobre el PVP
end;

//===================== SALIR DEL RECARGO =====================
procedure TFPedido.Edit18Exit(Sender: TObject);
var
  PrecioCon, Recargo, RecargoCosto, Margen,MargenSPvpP,PvcImpuestos: Double;
begin
  if Edit18.Text=ValorEntrada then exit;
  if VersiNumero(Edit18.text)=False then Edit18.Text:='0';

  //---- P.V.P.
  PrecioCon:=StrToFloat(Edit31.Text)*(1+(StrToFloat(Edit9.Text)/100));
  Edit12.Text:=FormatFloat('0.000',PrecioCon);//---- Pvp

  //---- Importe linea Costo + impuestos
  RecargoCosto:=(StrToFloat(Edit8.Text)*StrToFloat(Edit18.Text) / 100);//- Recargo
  Edit10.Text:=FormatFloat('0.00000',(StrToFloat(Edit8.Text)*(1+ (StrToFloat(Edit9.Text)/ 100)) + RecargoCosto));
  Edit13.Text:=FormatFloat('0.00000',StrToFloat(Edit7.Text)*StrToFloat(Edit10.Text));//--- Importe

  //---- Margenes
  if StrToFloat(Edit8.text)=0 then
  begin
    if StrToFloat(Edit10.text)=0 then
      begin
         Edit11.text:='0';
         Edit37.text:='0';
         exit;
      end
   else
      begin
         Edit8.text:=FloatToStr(StrToFloat(Edit10.text)/ (1+((StrToFloat(Edit9.text) + StrToFloat(Edit18.Text))/100)));
      end;
  end;

  PvcImpuestos:=StrToFloat(Edit8.text)* (1+ ((StrToFloat(Edit9.text) + StrToFloat(Edit18.Text))/100));
  Margen:= ((StrToFloat(Edit12.Text) - PvcImpuestos) * 100) / PvcImpuestos;
  MargenSPvpP:=((PvcImpuestos / StrToFloat(Edit12.text)) -1 ) * (-100);

  Edit11.Text := FormatFloat('0.000',Margen); //-------- Margen Normal
  Edit37.Text := FormatFloat('0.000',MargenSPvpP);  //-- Margen Sobre el PVP
end;

//===================== SALIR DEL MARGEN ======================
procedure TFPedido.Edit11Exit(Sender: TObject);
var
  PrecioCon, PrecioSin, Recargo, MargenSPvpP, PvcImpuestos: Double;
begin
  if Edit11.Text=ValorEntrada then exit;
  if (VersiNumero(Edit11.text)=False) or (StrToFloat(Edit11.Text)=0) then begin Edit11.Text:='0'; Exit; end;
  if (Edit8.Text='') or (StrToFloat(Edit8.Text)=0) then begin Edit8.Text:='0'; Exit; end;//------- Costo
  if (Edit9.Text='') or (Edit9.Text='0') then Edit9.Text:='0';//------------------------ IVA
  if (Edit18.Text='') or (Edit18.Text='0') then Edit18.Text:='0';

  //---- P.V.P.
  Recargo:=0; PrecioCon:=0;
  PrecioCon:=StrToFloat(Edit10.Text) * ( 1 + (StrToFloat(Edit11.Text)/100));
  PrecioSin:=PrecioCon / (1 + (StrToFloat(Edit9.Text)/100));
  Edit31.Text:=FormatFloat('0.00000', PrecioSin);//-------- Precio sin iva
  Edit12.Text:=FormatFloat('0.00000', PrecioCon);//------- Pvp

  //--- Margen sobre PVP
  PvcImpuestos:=StrToFloat(Edit8.text)* (1+ ((StrToFloat(Edit9.text) + StrToFloat(Edit18.Text))/100));
  MargenSPvpP:=((PvcImpuestos / StrToFloat(Edit12.text)) -1 ) * (-100);
  Edit37.Text:=FormatFloat('0.000', MargenSPvpP);

end;

//===================== SALIR DEL PRECIO SIN IVA (COSTO+MARGEN) ======================
procedure TFPedido.Edit31Exit(Sender: TObject);
var
  PvpSinIva, Margen, MargenSPvpP, CostoCero, PrecioCon: double;
  PvcImpuestos : double;
begin
  if Edit31.Text=ValorEntrada then exit;
  if VersiNumero(Edit31.text)=False then Edit31.Text:='0';

  PrecioCon:= StrToFloat(edit31.Text) * (1 + (StrToFloat(Edit9.Text)/100));
  Edit12.Text:= FormatFloat('0.000', PrecioCon);
//---  Edit12.SetFocus; Edit12Exit(Self);
//---------------------------------------
//-- SUSTITUYE LA LINEA SUPERIOR PARA EVITAR EL DESELECT
//---------------------------------------
//---------- Calcular precio sin iva
  PvpSinIva := (StrToFloat(Edit12.text) / (1 + (StrToFloat(Edit9.Text)/100)));
  Edit31.Text:=FormatFloat('0.00000',PvpSinIva);
  //---------- Calcular márgenes.
  if StrToFloat(Edit8.text)=0 then
   begin
     if StrToFloat(Edit10.text)=0 then
       begin
          Edit11.text:='0';
          Edit37.text:='0';
          exit;
       end
    else
       begin
          Edit8.text:=FloatToStr(StrToFloat(Edit10.text)/ (1+((StrToFloat(Edit9.text) + StrToFloat(Edit18.Text))/100)));
       end;
   end;

   PvcImpuestos:=StrToFloat(Edit8.text)* (1+ ((StrToFloat(Edit9.text) + StrToFloat(Edit18.Text))/100));
   Margen:= ((StrToFloat(Edit12.Text) - PvcImpuestos) * 100) / PvcImpuestos;
   MargenSPvpP:=((PvcImpuestos / StrToFloat(Edit12.text)) -1 ) * (-100);

   Edit11.Text := FormatFloat('0.000',Margen); //-------- Margen Normal
   Edit37.Text := FormatFloat('0.000',MargenSPvpP);  //-- Margen Sobre el PVP

end;

//===================== SALIR DEL PVP ======================
procedure TFPedido.Edit12Exit(Sender: TObject);
var
  PvpSinIVA, Margen,MargenSPvpP,PvcImpuestos : Double;
begin
  if Edit12.Text=ValorEntrada then exit;
  if VersiNumero(Edit12.text)=False then Edit12.Text:='0';

  if (StrToFloat(Edit12.text)=0) or (Edit12.text='') then
   begin
     Edit31.Text:='0';
     Edit11.text:='0';
     Edit37.text:='0';
     exit;
   end;

  //---------- Calcular precio sin iva
  PvpSinIva := (StrToFloat(Edit12.text) / (1 + (StrToFloat(Edit9.Text)/100)));
  Edit31.Text:=FormatFloat('0.00000',PvpSinIva);

  //---------- Calcular márgenes.
  if StrToFloat(Edit8.text)=0 then
  begin
    if StrToFloat(Edit10.text)=0 then
      begin
         Edit11.text:='0';
         Edit37.text:='0';
         exit;
      end
   else
      begin
         Edit8.text:=FloatToStr(StrToFloat(Edit10.text)/ (1+((StrToFloat(Edit9.text) + StrToFloat(Edit18.Text))/100)));
      end;
  end;

  PvcImpuestos:=StrToFloat(Edit8.text)* (1+ ((StrToFloat(Edit9.text) + StrToFloat(Edit18.Text))/100));
  Margen:= ((StrToFloat(Edit12.Text) - PvcImpuestos) * 100) / PvcImpuestos;
  MargenSPvpP:=((PvcImpuestos / StrToFloat(Edit12.text)) -1 ) * (-100);

  Edit11.Text := FormatFloat('0.000',Margen); //-------- Margen Normal
  Edit37.Text := FormatFloat('0.000',MargenSPvpP);  //-- Margen Sobre el PVP

end;


procedure TFPedido.CargaValorEntrada(Sender: TObject);
begin
  ValorEntrada:= Self.Text;
end;

//================== FAMILIA DEL ARTICULO ================
procedure TFPedido.Edit32Enter(Sender: TObject);
begin
  Edit33.Text:='';
end;
procedure TFPedido.Edit32Exit(Sender: TObject);
begin
  if Edit32.Text='' then exit;
  if Edit32.Text='0' then exit;
  dbBusca.SQL.Text:='SELECT * FROM familias'+Tienda+' WHERE F0='+Edit32.Text;
  dbBusca.Active:=True;
  If dbBusca.RecordCount=0 then Begin Showmessage('ESA FAMILIA NO EXISTE.'); Edit32.SetFocus; Exit; End;
  Edit33.Text:=dbBusca.FieldByName('F1').AsString;
end;
//---------------- Buscar Familia ------------------
procedure TFPedido.BitBtn28Click(Sender: TObject);
begin
  if Edit33.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit33.SetFocus; Exit; end;
  Edit32.Text := FBusquedas.IniciaBusquedas('SELECT F0, F1, F2 FROM familias'+Tienda+' WHERE F1 LIKE "%'+Edit33.Text+'%"',
           ['Codigo', ' Descripción ', ' Departamento ' ], 'F0' );
  if Edit32.Text<>'' then begin Edit32Exit(Edit32); end;
end;
procedure TFPedido.Edit33KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn28Click(BitBtn28);
end;

//====================================================================
//===================== LISTADO DE PEDIDOS CABECERAS =================
//====================================================================
procedure TFPedido.BitBtn23Click(Sender: TObject);
begin
  Panel9.Visible:=True; Panel9.BringToFront;
  DateEdit7.Date:=StrToDate('01'+FormatDateTime('/MM/YYYY',Date));
  DateEdit8.Date:=Date; Edit14.SetFocus;
end;

//-------------- Primer proveedor -----------------
procedure TFPedido.Edit14Enter(Sender: TObject);
begin
   Edit15.Text:='';
end;
procedure TFPedido.Edit14Exit(Sender: TObject);
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
procedure TFPedido.Edit16Enter(Sender: TObject);
begin
   Edit17.Text:='';
end;
procedure TFPedido.Edit16Exit(Sender: TObject);
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
procedure TFPedido.BitBtn21Click(Sender: TObject);
begin
  If (Edit14.Text='') or (Edit16.Text='') then Exit;
  dbBusca.Sql.Text:='SELECT *,P1 FROM pedicc'+Tienda+', proveedores WHERE PC2=P0'+
                    ' AND PC1>="'+FormatDateTime('YYYY/MM/DD',DateEdit7.Date)+'"'+
                    ' AND PC1<="'+FormatDateTime('YYYY/MM/DD',DateEdit8.Date)+'"'+
                    ' AND PC2>='+Edit14.Text+' AND PC2<='+Edit16.Text+' ORDER BY PC2 ASC, PC1 DESC, PC3 DESC';
  dbBusca.Active := True;
  If dbBusca.RecordCount=0 then
    begin
      Showmessage('NO HAY PEDIDOS ENTRE ESOS DATOS');
      exit;
    end;
  frDBDataSet1.DataSet:=dbBusca;
  frReport1.LoadFromFile(RutaReports+'ListaPedidos.lrf');
   frReport1.ShowReport;

end;

//--------------- Cerrar listado de pedidos -------------------
procedure TFPedido.BitBtn22Click(Sender: TObject);
begin
  Panel9.Visible:=False; Panel9.SendToBack;
end;

//================================================================
//======================= OBSERVACIONES ==========================
//================================================================
procedure TFPedido.BitBtn16Click(Sender: TObject);
begin
  Panel7.Visible:=True;
  Memo1.Lines.Text:=dbPedic.FieldByName('PC31').AsString;
  Memo1.SetFocus;
end;
//--------------- Aceptar Observaciones --------
procedure TFPedido.BitBtn18Click(Sender: TObject);
begin
  dbPedic.Edit;
  dbPedic.FieldByName('PC31').AsString:=Memo1.Lines.Text;
  dbPedic.Post;
  Panel7.Visible:=False;
end;

//--------------- Cancelar Observaciones --------
procedure TFPedido.BitBtn17Click(Sender: TObject);
begin
  Panel7.Visible:=False;
end;


//=======================================================================
//========================= VENCIMIENTOS ================================
//=======================================================================
procedure TFPedido.BitBtn26Click(Sender: TObject);
begin
  Panel11.Visible:=True; DateEdit3.Clear; DateEdit4.Clear;
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
end;

//----------------- Importe 1 ------------
procedure TFPedido.Edit24Exit(Sender: TObject);
begin
  if Edit24.Text='' then Edit24.Text:='0.00';
  PintarTotalVencimientos();
end;

//----------------- Importe 2 ------------
procedure TFPedido.Edit26Exit(Sender: TObject);
begin
  if Edit26.Text='' then Edit26.Text:='0.00';
  PintarTotalVencimientos();
end;

//----------------- Importe 3 ------------
procedure TFPedido.Edit28Exit(Sender: TObject);
begin
  if Edit28.Text='' then Edit28.Text:='0.00';
  PintarTotalVencimientos();
end;

//----------------- Importe 4 ------------
procedure TFPedido.Edit30Exit(Sender: TObject);
begin
  if Edit30.Text='' then Edit30.Text:='0.00';
  PintarTotalVencimientos();
end;

//---------------- Totales vencimientos ------------
procedure TFPedido.PintarTotalVencimientos();
begin
  //------------ Suma de vencimientos
  Label46.Caption:=FormatFloat('0.00',StrToFloat(Edit24.Text)+StrToFloat(Edit26.Text)+
                                   StrToFloat(Edit28.Text)+
                                   StrToFloat(Edit30.Text));
  //------ Total Pedido costo+impuestos-suma de vencimientos
  Label47.Caption:=FormatFloat('0.00',dbPedic.FieldByName('PC8').AsFloat-StrToFloat(Label46.Caption));
end;

//========================= SALIR DE VENCIMIENTOS ======================
procedure TFPedido.BitBtn29Click(Sender: TObject);
begin
  Panel11.Visible:=False;
end;

//======================= ACEPTAR DE VENCIMIENTOS ======================
procedure TFPedido.BitBtn30Click(Sender: TObject);
begin
  dbPedic.Edit;
  //--------------- Venc. 1
  if StrToFloat(Edit24.Text)=0 then
    dbPedic.FieldByName('PC20').Value:=Null
  else
    dbPedic.FieldByName('PC20').Value:=DateEdit3.Date;
  dbPedic.FieldByName('PC21').AsString:=Edit24.Text;
  //--------------- Venc. 2
  if StrToFloat(Edit26.Text)=0 then
    dbPedic.FieldByName('PC22').Value:=Null
  else
    dbPedic.FieldByName('PC22').Value:=DateEdit4.Date;
  dbPedic.FieldByName('PC23').AsString:=Edit26.Text;
  //--------------- Venc. 3
  if StrToFloat(Edit28.Text)=0 then
    dbPedic.FieldByName('PC24').Value:=Null
  else
    dbPedic.FieldByName('PC24').Value:=DateEdit5.Date;
  dbPedic.FieldByName('PC25').AsString:=Edit28.Text;
  //--------------- Venc. 4
  if StrToFloat(Edit30.Text)=0 then
    dbPedic.FieldByName('PC26').Value:=Null
  else
    dbPedic.FieldByName('PC26').Value:=DateEdit6.Date;
  dbPedic.FieldByName('PC27').AsString:=Edit30.Text;
  dbPedic.Post; Panel11.Visible:=False;
end;

//======================= SALIR DE GESTIONAR PEDIDOS =====================
procedure TFPedido.BitBtn5Click(Sender: TObject);
var
 Posi: Integer;
 TxtQ: String;
begin
  Panel7.Visible:=False;
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
  dbTrabajo.SQL.Text:='SELECT COUNT(*), SUM(PD8), sum(PD8B), SUM(PD8*PD10), SUM(PD17), SUM(PD18) FROM pedidd'+Tienda+' WHERE'+
                     ' PD0='+dbPedic.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic.FieldByName('PC4').AsString;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then exit;
  TxtQ:='UPDATE pedicc'+Tienda+' SET PC5='+dbTrabajo.Fields[0].AsString+', PC6='+dbTrabajo.Fields[1].AsString+
        ', PC6B='+dbTrabajo.Fields[2].AsString+', PC7='+dbTrabajo.Fields[3].AsString+', PC8='+dbTrabajo.Fields[4].AsString+
        ', PC9='+dbTrabajo.Fields[5].AsString+
        ' WHERE PC0='+dbPedic.FieldByName('PC0').AsString+
        ' AND PC1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
        ' AND PC2='+dbPedic.FieldByName('PC2').AsString+
        ' AND PC3="'+dbPedic.FieldByName('PC3').AsString+'"'+
        ' AND PC4='+dbPedic.FieldByName('PC4').AsString;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  Posi:=dbPedic.RecNo; dbPedic.Refresh; dbPedic.RecNo:=Posi;
end;

//================== PINTAR TOTAL GENERAL ===============
procedure TFPedido.PintarTotalGeneral();
begin
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT SUM(PD17) FROM pedidd'+Tienda+' WHERE'+
                     ' PD0='+dbPedic.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic.FieldByName('PC4').AsString;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then LabelTotal.Caption:='0.00'
  else LabelTotal.Caption:=FormatFloat('0.00',dbTrabajo.Fields[0].AsFloat);
  dbTrabajo.Active:=False;
end;

//====================== MOSTRAR BOTONES DD ====================
procedure TFPedido.MostrarBotonesdd();
begin
  BitBtn5.Visible:=True; BitBtn12.Visible:=True;
  BitBtn13.Visible:=True; BitBtn14.Visible:=True;
  BitBtn15.Visible:=True; BitBtn11.Visible:=True; BitBtn37.Visible:=True;
  //-------------- cc
  BitBtn1.Visible:=False; BitBtn9.Visible:=False;
  BitBtn10.Visible:=False; BitBtn16.Visible:=False;
  BitBtn2.Visible:=False; BitBtn23.Visible:=False;
  BitBtn25.Visible:=False; BitBtn26.Visible:=False;
  BitBtn43.Visible:=False;
end;

//====================== OCULTAR BOTONES DD ====================
procedure TFPedido.OcultarBotonesdd();
begin
  BitBtn5.Visible:=False; BitBtn12.Visible:=False;
  BitBtn13.Visible:=False; BitBtn14.Visible:=False;
  BitBtn15.Visible:=False; BitBtn11.Visible:=False; BitBtn37.Visible:=False;
  //-------------- cc
  BitBtn1.Visible:=True; BitBtn9.Visible:=True;
  BitBtn10.Visible:=True; BitBtn16.Visible:=True;
  BitBtn2.Visible:=True; BitBtn23.Visible:=True;
  BitBtn25.Visible:=True; BitBtn26.Visible:=True;
  BitBtn43.Visible:=True;
end;

//==================== PINTAR DATOS DE CLIENTES ======================
procedure TFPedido.PintaProveedor();
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
procedure TFPedido.LimpiaProveedor();
begin
  Label4.Caption:=''; Label5.Caption:=''; Label6.Caption:='';
  Label7.Caption:=''; Label8.Caption:=''; Label9.Caption:='';
  Label10.Caption:=''; LabelTotal.Caption:='0.00';
end;

//================= N. DE PEDIDO ===========================
procedure TFPedido.NumeroPedido();
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
procedure TFPedido.BitBtn15Click(Sender: TObject);
var
  NombrePDF: string;
begin

  if DirectoryExists(RutaPdf) then
         NombrePDF:= RutaPdf+'/Ped'+'-'+dbPedic.FieldByName('PC3').AsString
                   +'-'+dbPedic.FieldByName('PC4').AsString+'.pdf' else
         NombrePDF:= RutaIni+'Ped'+'-'+dbPedic.FieldByName('PC3').AsString
                   +'-'+dbPedic.FieldByName('PC4').AsString+'.pdf';


  EdFicheroPdf.Text:=NombrePDF;

  Panel13.Visible:=True;
end;
//----------------- ACEPTAR IMPRIMIR LISTADO --------------------
procedure TFPedido.BitBtn32Click(Sender: TObject);
begin
  Pdf:=0; ImprimirPedido();
end;
//----------------- ACEPTAR IMPRIMIR PDF --------------------
procedure TFPedido.BitBtn36Click(Sender: TObject);
begin
  Pdf:=1; ImprimirPedido();
end;

//----------------- CANCELAR IMPRIMIR --------------------
procedure TFPedido.BitBtn33Click(Sender: TObject);
begin
  Panel13.Visible:=False;
end;

//----------------- IMPRIMIR PEDIDO -----------------------
procedure TFPedido.ImprimirPedido();
var
  TxtQ: String;
begin
  //---- Consulta para el listado
  TxtQ:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic.FieldByName('PC4').AsString;
  if RadioButton22.Checked=True then TxtQ:=TxtQ+' AND PD23="S"';//----- Solo las lineas marcadas
  if RadioButton26.Checked=True then TxtQ:=TxtQ+' AND PD23<>"S"';//---- Solo las lineas NO marcadas
  dbBusca.SQL.Text:=TxtQ;
  dbBusca.Active:=True;

  if RadioButton19.Checked=True Then begin EtiquetasBarras(); exit; end;//------------ Cgo. de barras

  frDBDataSet1.DataSet:=dbBusca;
  IMPOIVA1:=0; BASE1:=0; TOTAL1:=0; IRIVA1:=0; PIVA1:=0; PRIVA1:=0;
  IMPOIVA2:=0; BASE2:=0; TOTAL2:=0; IRIVA2:=0; PIVA2:=0; PRIVA2:=0;
  IMPOIVA3:=0; BASE3:=0; TOTAL3:=0; IRIVA3:=0; PIVA3:=0; PRIVA3:=0;
  //--------------- Sacar distintos ivas ------------------
    TxtQ:='SELECT DISTINCT(PD14), (SUM(PD15*PD8)-SUM(PD10*PD8)) As Ivas, '+
          'SUM(PD10*PD8) As Bases, SUM(PD17) As Totales, SUM(PD13) As Recargos '+
        'FROM pedidd'+Tienda+
        ' WHERE PD0='+dbPedic.Fields[0].AsString+
        ' AND PD1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND PD2='+dbPedic.Fields[2].AsString+
        ' AND PD3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND PD4='+dbPedic.Fields[4].AsString;
  if RadioButton22.Checked=True then TxtQ:=TxtQ+' AND PD23="S"';//----- Solo las lineas marcadas
  if RadioButton26.Checked=True then TxtQ:=TxtQ+' AND PD23<>"S"';//---- Solo las lineas NO marcadas
  TxtQ:=TxtQ+' GROUP BY PD14 ORDER BY PD14 ASC';

  dbTrabajo.Active:=False; dbTrabajo.Sql.Text:=TxtQ; dbTrabajo.Active:=True;
  dbTrabajo.First;
  //------------------------ Primer tipo de iva
  if dbTrabajo.Eof=False then
   begin
    PIVA1:=dbTrabajo.Fields[0].AsInteger;
//    IMPOIVA1:=dbTrabajo.Fields[1].AsFloat;
//    BASE1:=dbTrabajo.Fields[2].AsFloat;
    TOTAL1:=dbTrabajo.Fields[3].AsFloat;
    BASE1:=TOTAL1/(1+(dbTrabajo.Fields[0].AsInteger/100));
    IMPOIVA1:=BASE1*(dbTrabajo.Fields[0].AsInteger/100);

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
//    IMPOIVA2:=dbTrabajo.Fields[1].AsFloat;
//    BASE2:=dbTrabajo.Fields[2].AsFloat;
    TOTAL2:=dbTrabajo.Fields[3].AsFloat;
    BASE2:=TOTAL2/(1+(dbTrabajo.Fields[0].AsInteger/100));
    IMPOIVA2:=BASE2*(dbTrabajo.Fields[0].AsInteger/100);

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
//    IMPOIVA3:=dbTrabajo.Fields[1].AsFloat;
//    BASE3:=dbTrabajo.Fields[2].AsFloat;
    TOTAL3:=dbTrabajo.Fields[3].AsFloat;
    BASE3:=TOTAL3/(1+(dbTrabajo.Fields[0].AsInteger/100));
    IMPOIVA3:=BASE3*(dbTrabajo.Fields[0].AsInteger/100);

    //---------------- Recargo
    if dbTrabajo.Fields[4].AsFloat<>0 then
      begin
       VerRecargo();
       PRIVA3:=RECARGO;
       IRIVA3:=dbTrabajo.Fields[2].AsFloat-((dbTrabajo.Fields[2].AsFloat*100)/(RECARGO+100));
       TOTAL3:=dbTrabajo.Fields[3].AsFloat+dbTrabajo.Fields[2].AsFloat-((dbTrabajo.Fields[2].AsFloat*100)/(RECARGO+100));
      end;
   end;

   if RadioButton6.Checked=True then
      frReport1.LoadFromFile(RutaReports+'Pedido.lrf');
   if RadioButton7.Checked=True then
      frReport1.LoadFromFile(RutaReports+'PedidoSinPvp.lrf');
   if RadioButton8.Checked=True then
      frReport1.LoadFromFile(RutaReports+'PedidoUnidades.lrf');
   if RadioButton20.Checked=True then
      frReport1.LoadFromFile(RutaReports+'EtiLineales.lrf');

    //--------------------------------
    if Pdf=0 then
      frReport1.ShowReport
    else
      if frReport1.PrepareReport then
        begin
         if not FileExists(VisorPdf) then
            begin ShowMessage('DEBE DEFINIR UN VISOR PDF EN LA CONFIGURACION'); exit; end;

         frReport1.ExportTo(TFrTNPDFExportFilter, EdFicheroPdf.Text);
         AProcess := TProcess.Create(nil);
         AProcess.CommandLine := VisorPdf+' '+EdFicheroPdf.Text;
         AProcess.Execute;
         AProcess.Destroy;
        end;

  dbBusca.Active:=False;
end;

//================ TIPOS DE RECARGO =====================
procedure TFPedido.VerRecargo();
begin
   RECARGO:=RIVA1;
   if dbTrabajo.Fields[0].AsFloat=IVA1 then RECARGO:=RIVA1;
   if dbTrabajo.Fields[0].AsFloat=IVA2 then RECARGO:=RIVA2;
   if dbTrabajo.Fields[0].AsFloat=IVA3 then RECARGO:=RIVA3;
end;

//================= PASAR PARAMETROS AL REPORT ===============
procedure TFPedido.frReport1GetValue(const ParName: String;
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

  if ParName='FECHA' then ParValue := dbPedic.FieldByName('PC1').AsString;
  if ParName='SERIE' then ParValue := dbPedic.FieldByName('PC3').AsString;
  if ParName='NUMERO' then ParValue := dbPedic.FieldByName('PC4').AsString;
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
  if ParName='OBSERVACIONES' then ParValue := dbPedic.FieldByName('PC31').AsString;

  if ParName='FECHAV1' then ParValue:=dbPedic.FieldByName('PC20').AsString;
  if ParName='IMPOV1' then if dbPedic.FieldByName('PC21').AsString<>'0' then ParValue:=dbPedic.FieldByName('PC21').AsString else ParValue:='';
  if ParName='FECHAV2' then ParValue:=dbPedic.FieldByName('PC22').AsString;
  if ParName='IMPOV2' then if dbPedic.FieldByName('PC23').AsString<>'0' then ParValue:=dbPedic.FieldByName('PC23').AsString else ParValue:='';
  if ParName='FECHAV3' then ParValue:=dbPedic.FieldByName('PC24').AsString;
  if ParName='IMPOV3' then if dbPedic.FieldByName('PC25').AsString<>'0' then ParValue:=dbPedic.FieldByName('PC25').AsString else ParValue:='';
  if ParName='FECHAV4' then ParValue:=dbPedic.FieldByName('PC26').AsString;
  if ParName='IMPOV4' then if dbPedic.FieldByName('PC27').AsString<>'0' then ParValue:=dbPedic.FieldByName('PC27').AsString else ParValue:='';
end;

//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFPedido.frReport1EnterRect(Memo: TStringList; View: TfrView);
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
procedure TFPedido.RadioButton19Change(Sender: TObject);
begin
   if RadioButton19.Checked=True then Panel17.Enabled:=True else Panel17.Enabled:=False;
end;

//--------- Cantidad de etiquetas manual ------
procedure TFPedido.RadioButton25Change(Sender: TObject);
begin
   if RadioButton25.Checked=True then Edit36.Visible:=True else Edit36.Visible:=False;
end;

//-------------- Grabar etiquetas en file txt ----------------
procedure TFPedido.EtiquetasBarras();
var
  F: TextFile;
  Conta, Cantidad: Integer;
begin
  dbBusca.First; Cantidad:=1;
  SaveDialog1.FileName:=RutaIni + 'etieans.txt';
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

//============================================================
//==================== COMUNICACIONES ========================
//============================================================
procedure TFPedido.BitBtn25Click(Sender: TObject);
begin
  Panel12.Visible:=True;
  DbGrid4.Visible:=True; DbGrid4.BringToFront;
  dbTiendas.Active:=False;
  dbTiendas.SQL.Text:='SELECT * FROM tiendas WHERE T0<>'+NTienda+' ORDER BY T0';
  dbTiendas.Active:=True;
end;

//------------------- Transmitir a tiendas ---------------
procedure TFPedido.RadioButton4Click(Sender: TObject);
begin
  if RadioButton4.Checked=False then exit;
  DbGrid4.Visible:=True; DbGrid4.BringToFront;
  Datasource4.DataSet:=dbTiendas;
  dbTiendas.Active:=False;
  dbTiendas.SQL.Text:='SELECT * FROM tiendas WHERE T0<>'+NTienda+' ORDER BY T0';
  dbTiendas.Active:=True;
end;

//------------------- Transmitir a proveedores ---------------
procedure TFPedido.RadioButton5Click(Sender: TObject);
begin
  if RadioButton5.Checked=False then exit;
  DbGrid5.Visible:=True; DbGrid5.BringToFront;
  Datasource4.DataSet:=dbProve;
  dbProve.Active:=False;
  dbProve.SQL.Text:='SELECT * FROM proveedores ORDER BY P0';
  dbProve.Active:=True;
  dbProve.Locate('P0',dbPedic.FieldByName('PC2').AsString,[]);
end;

//-------------------- Iniciar comunicaciones ------------------------
procedure TFPedido.BitBtn27Click(Sender: TObject);
var
 Conta: Integer;
begin
  //------------------------------------------------
  //------------------ Tienda/Almacen --------------
  //------------------------------------------------
  if RadioButton4.Checked=True then
    begin
      if dbPedic.RecordCount=0 then Begin Showmessage('NO HAY NINGUN PEDIDO PARA GESTIONAR'); Exit; End;
      dbProve.SQL.Text:='SELECT * FROM proveedores WHERE P0='+dbPedic.FieldByName('PC2').AsString;
      dbProve.Active:=True;
      if dbProve.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL PROVEEDOR '+dbPedic.FieldByName('PC2').AsString+' ?'); Exit; End;
      if dbTiendas.RecordCount=0 then exit;
      if dbTiendas.FieldByName('T12').AsString='' then
       begin showmessage('La Tienda destino no tiene ip asignado'); exit; end;
      if dbTiendas.FieldByName('T13').AsString='' then
       begin showmessage('La Tienda destino no tiene puerto de conexión asignado'); exit; end;
      if dbTiendas.FieldByName('T14').AsString='' then
       begin showmessage('La Tienda destino no usuario de acceso asignado'); exit; end;
      dbConnectR.Database:=dbTiendas.FieldByName('T12').AsString;
      dbConnectR.HostName:=dbTiendas.FieldByName('T13').AsString;
      dbConnectR.Port:=dbTiendas.FieldByName('T14').AsInteger;
      dbConnectR.User:=dbTiendas.FieldByName('T15').AsString;
      dbConnectR.Password:=dbTiendas.FieldByName('T16').AsString;
      dbConnectR.Protocol:=dbTiendas.FieldByName('T17').AsString;
      try
       dbConnectR.Connected:=True;
      except
       showmessage('No he podido conectar con la tienda, revise los datos de conexión y la red');
       exit;
      end;
      //---------- Seleccionar Detalles de pedidos a trasnmitir
      dbPedid.SQL.Text:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic.FieldByName('PC4').AsString;
      dbPedid.Active:=True;
      //---------- Cabeceras
      dbTrabajoR.SQL.Text:='SELECT * FROM pedicc'+Tienda+' WHERE PC0='+NTienda+
                     ' AND PC1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PC2='+dbPedic.FieldByName('PC2').AsString+
                     ' AND PC3="'+dbPedic.FieldByName('PC3').AsString+'"'+
                     ' AND PC4='+dbPedic.FieldByName('PC4').AsString;
      dbTrabajoR.Active:=True;
      if dbTrabajoR.RecordCount<>0 then begin showmessage('El pedido existe'); exit; end;
      dbTrabajoR.Append;
      dbTrabajoR.Fields[0].AsString:=NTienda;//------- Tienda que transmite
      for Conta:=1 to 31 do dbTrabajoR.Fields[Conta].Value:=dbPedic.Fields[Conta].Value;
      dbTrabajoR.Post;
      //------------------ Detalles
      dbTrabajoR.SQL.Text:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+NTienda+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic.FieldByName('PC4').AsString;
      dbTrabajoR.Active:=True;
      if dbTrabajoR.RecordCount<>0 then begin showmessage('El pedido existe'); exit; end;
      dbPedid.First;
      while not dbPedid.EOF do
        begin
          dbTrabajoR.Append;
          dbTrabajoR.Fields[0].AsString:=NTienda;//------- Tienda que transmite
          for Conta:=1 to 25 do dbTrabajoR.Fields[Conta].Value:=dbPedid.Fields[Conta].Value;
          dbTrabajoR.Post;
          dbPedid.Next;
        end;
      //---------------- Modificar pedido como trasnmitido
      dbPedic.Edit;
      dbPedic.FieldByName('PC10').AsString:='S';//---------- Trasmitido
      dbPedic.FieldByName('PC11').AsString:='T';//---------- Destino T=Tienda/P=Prov.
      dbPedic.FieldByName('PC12').AsString:=dbTiendas.FieldByName('T1').AsString;//-- Descripción.
      dbPedic.Post;
      BitBtn31Click(BitBtn31);//--- Cerrar comunicaciones
      Showmessage('PEDIDO TRASMITIDO CORRECTAMENTE');
    end;
  //------------- Trasmitir a proveedores ----------
  if RadioButton5.Checked=True then
    begin
      Panel19.Visible:=True; Panel19.BringToFront;
      StaticText6.Caption:=dbProve.FieldByName('P0').AsString;//Codigo
      StaticText7.Caption:=dbProve.FieldByName('P1').AsString;//Nombre
      StaticText8.Caption:=dbProve.FieldByName('P8').AsString;//Fax
      StaticText9.Caption:=dbProve.FieldByName('P34').AsString;//Email
    end;
end;

//------------------------------------------------
//------------- Trasmitir a proveedores ----------
//------------------------------------------------
procedure TFPedido.BitBtn41Click(Sender: TObject);
begin
  //----------- Pedido normal --------------
  if RadioButton33.Checked=True then
    begin
      //----------- Listado con precios pvp
      if RadioButton36.Checked=True then
        begin Pdf:=1; RadioButton6.Checked:=True; ImprimirPedido(); end;
      //----------- Listado con precios de costo
      if RadioButton37.Checked=True then
        begin Pdf:=1; RadioButton7.Checked:=True; ImprimirPedido(); end;
      //----------- Listado con unidades
      if RadioButton38.Checked=True then
        begin Pdf:=1; RadioButton8.Checked:=True; ImprimirPedido(); end;
    end;
  //---------------- Modificar pedido como trasnmitido
  dbPedic.Edit;
  dbPedic.FieldByName('PC10').AsString:='S';//---------- Trasmitido
  dbPedic.FieldByName('PC11').AsString:='P';//---------- Destino T=Tienda/P=Prov.
  dbPedic.FieldByName('PC12').AsString:=dbProve.FieldByName('P1').AsString;//-- Descripción.
  dbPedic.Post; Panel19.Visible:=False;
  BitBtn31Click(BitBtn31);//--- Cerrar comunicaciones
  Showmessage('PEDIDO TRASMITIDO CORRECTAMENTE');
end;


//-------------- Cerrar trans. prove. ------------------
procedure TFPedido.BitBtn42Click(Sender: TObject);
begin
  Panel19.Visible:=False;
end;

//================ DAR ENTRADA AL PEDIDO =====================
procedure TFPedido.BitBtn43Click(Sender: TObject);
begin
  if dbpedic.RecordCount=0 then exit;
  ShowFormEntradaPedido(dbPedic.FieldByName('PC0').AsString,dbPedic.FieldByName('PC1').AsString,
                        dbPedic.FieldByName('PC2').AsString,dbPedic.FieldByName('PC3').AsString,
                        dbPedic.FieldByName('PC4').AsString);
  dbpedic.Refresh;
end;


//-------------------- Ver Destino de La trasmisión ------------------------
procedure TFPedido.MenuItem1Click(Sender: TObject);
begin
  StaticText1.Caption:=''; StaticText2.Caption:='';
  StaticText3.Caption:=''; StaticText4.Caption:='';
  StaticText1.Caption:=dbpedic.FieldByName('PC10').AsString;//----- Trasmitido S/N
  StaticText2.Caption:=dbpedic.FieldByName('PC11').AsString;//----- Tipo de Trasmision
  if StaticText2.Caption='P' then StaticText4.Caption:='Proveedores';
  if StaticText2.Caption='T' then StaticText4.Caption:='Tiendas';
  StaticText3.Caption:=dbpedic.FieldByName('PC12').AsString;//----- Destino Trasmision
  Panel15.Visible:=True;
end;
procedure TFPedido.Panel15Click(Sender: TObject);
begin
  Panel15.Visible:=False;
end;


//-------------------- Cerrar comunicaciones ------------------------
procedure TFPedido.BitBtn31Click(Sender: TObject);
begin
  Panel12.Visible:=False;
  dbTiendas.Active:=False;
end;

//============= LOCALIZAR ARTICULOS POR CODIGO =====================
function TFPedido.LeerArticulo: Boolean;
begin
  LeerArticulo:=False;
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount<>0 then
    begin LeerArticulo:=True; Pintadd(); end
  else LeerArticulo:=False;
end;
//============= LOCALIZAR ARTICULOS POR CGO AUXILIAR =====================
function TFPedido.LeerAuxiliar: Boolean;
begin
  LeerAuxiliar:=False;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM eans WHERE EAN0="'+Edit5.Text+'"';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then exit;
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbTrabajo.FieldByName('EAN1').AsString+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount=0 then exit;
  Pintadd();
  Edit6.Text:=dbTrabajo.FieldByName('EAN2').AsString;//----- Descripcion del auxiliar
  Edit7.Text:=dbTrabajo.FieldByName('EAN3').AsString;//----- Unidades del auxiliar

  { TODO : falta poner el importe del auxiliar o la cantidad por el importe unitario? }

  LeerAuxiliar:=True;
end;

//================ CREAR ARTICULOS ======================
procedure TFPedido.CrearArticulo();
var
  Conta: Integer;
  ANO: String;
begin
  dbArti.Append;
  dbArti.FieldByName('A0').AsString:=Edit5.Text;//-------------- Código
  dbArti.FieldByName('A1').AsString:=Edit6.Text;//-------------- Nombre
  dbArti.FieldByName('A21').AsString:=Edit31.Text;//------------ Precio
  dbArti.FieldByName('A3').AsString:=Edit9.Text;//-------------- Iva
  dbArti.FieldByName('A36').AsString:=Edit18.Text;//-------------- Recargo
  dbArti.FieldByName('A2').AsString:=Edit12.Text;//------------- P.V.P.
  dbArti.FieldByName('A14').AsString:=Edit32.Text;//------------ Familia
  dbArti.FieldByName('A24').AsString:=Edit8.Text;//------- Costo
  dbArti.FieldByName('A25').AsString:=Edit8.Text;//------- Costo Medio
  dbArti.FieldByName('A26').AsString:=Edit11.Text;//------- Margen
  dbArti.FieldByName('A37').AsString:=Edit37.Text;//------- Margen sobre Venta
  dbArti.FieldByName('A28').AsString:=Edit19.Text;//------- Precio tarifa
  dbArti.FieldByName('A29').AsString:=Edit22.Text;//------- Descuento en importe
  dbArti.FieldByName('A30').AsString:=Edit27.Text;//------- % Descuento 1
  dbArti.FieldByName('A31').AsString:=Edit29.Text;//------- % Descuento 2
  dbArti.FieldByName('A32').AsString:=dbProve.FieldByName('P0').AsString;//--- Ultimo proveedor
  dbArti.Post;

  //--------- Estadistica
  ANO:=FormatDateTime('YYYY',Date);
  for conta:=1 to 12 do
    begin
     dbTrabajo.SQL.Text:='INSERT IGNORE INTO estaarti'+Tienda+' (TA0,TA1,TA2,TA3,TA4,TA5,TA6,TA7) '+
                      'VALUES ("'+Edit5.Text+'",'+ANO+','+IntToStr(Conta)+',0,0,0,0,0)';
     dbTrabajo.ExecSQL;
    end;

end;

//================== NUEVO EAN DE ARTICULO NUEVO ===================
procedure TFPedido.CrearEan();
begin
  dbEan.Active:=False;
  dbEan.SQL.Text:='SELECT * FROM eans WHERE EAN0="'+Edit38.Text+'"';
  dbEan.Active:=True;
  if dbEan.RecordCount=0 then
    begin
      dbEan.Append;
      dbEan.FieldByName('EAN0').AsString:=Edit38.Text;//-------- Ean
      dbEan.FieldByName('EAN1').AsString:=Edit5.Text;//----------Código
      dbEan.FieldByName('EAN2').AsString:=Edit6.Text;//----------descripción
      dbEan.FieldByName('EAN3').AsString:='1';//-----------------Unidades
      if cbPrecioEan.Checked then
          dbEan.FieldByName('EAN4').AsString:=Edit12.Text
                             else
          dbEan.FieldByName('EAN4').AsString:='0';//---------Precio
      dbEan.FieldByName('EAN5').AsString:='1';//-----------------Unidades a descontar
      dbEan.Post;

    end else
      ShowMessage('   Ya existe ese valor :' + #13 + #13 +
                   ' Código :      ' + dbEan.FieldByName('ean1').AsString + #13 +
                   ' Descripción : ' + dbEan.FieldByName('ean2').AsString + #13 + #13 +
                   'No se crea ningún registro nuevo en la tabla de EAN');

    Edit38.Text:='';
end;


//================== UNIDADES PENDIENTES EN PEDIDOS ================
procedure TFPedido.SumaPendientes(CodiPen, UniPen: String);
begin
  dbTrabajo.SQL.Text:='UPDATE artitien'+Tienda+' SET A11=A11+'+UniPen+
                      ' WHERE A0="'+CodiPen+'"';
  dbTrabajo.ExecSQL;
end;

//==================================================================
//========================= UTILIDADES =============================
//==================================================================
procedure TFPedido.BitBtn11Click(Sender: TObject);
begin
  Panel14.Visible:=True;
end;

//----------------- Aceptar Utilidades --------------
procedure TFPedido.BitBtn34Click(Sender: TObject);
begin
  //------------------ Multiplicar unidades * -1
  if RadioButton9.Checked=True then
    begin
      dbPedid.First;
      while not dbPedid.EOF do
        begin
          if (RadioButton14.Checked=True) and (dbPedid.FieldByName('PD23').AsString='N') then begin dbPedid.Next; continue; end;
          if (RadioButton27.Checked=True) and (dbPedid.FieldByName('PD23').AsString='S') then begin dbPedid.Next; continue; end;
          dbPedid.Edit;
          dbPedid.FieldByName('PD8').Value:=dbPedid.FieldByName('PD8').AsFloat*-1;//--Unidades
          dbPedid.FieldByName('PD8B').Value:=dbPedid.FieldByName('PD8B').AsFloat*-1;//--Unidades Bonificadas
          dbPedid.FieldByName('PD17').Value:=dbPedid.FieldByName('PD17').AsFloat*-1;//-Importe
          dbPedid.FieldByName('PD18').Value:=dbPedid.FieldByName('PD18').AsFloat*-1;//-Importe PVP
          dbPedid.Post;
          dbPedid.Next;
        end;
    end;
  //------------------ Poner unidades a 0
  if RadioButton10.Checked=True then
    begin
      dbPedid.First;
      while not dbPedid.EOF do
        begin
          if (RadioButton14.Checked=True) and (dbPedid.FieldByName('PD23').AsString='N') then begin dbPedid.Next; continue; end;
          if (RadioButton27.Checked=True) and (dbPedid.FieldByName('PD23').AsString='S') then begin dbPedid.Next; continue; end;
          dbPedid.Edit;
          dbPedid.FieldByName('PD8').Value:=0;//--Unidades
          dbPedid.FieldByName('PD8B').Value:=0;//--Unidades bonificadas
          dbPedid.FieldByName('PD17').Value:=0;//-Importe
          dbPedid.FieldByName('PD18').Value:=0;//-Importe PVP
          dbPedid.Post;
          dbPedid.Next;
        end;
    end;
  //------------------ Actualizar articulos con estos precios
  if RadioButton11.Checked=True then
    begin
      dbPedid.First;
      while not dbPedid.EOF do
        begin
          if (RadioButton14.Checked=True) and (dbPedid.FieldByName('PD23').AsString='N') then begin dbPedid.Next; continue; end;
          if (RadioButton27.Checked=True) and (dbPedid.FieldByName('PD23').AsString='S') then begin dbPedid.Next; continue; end;
          dbArti.Sql.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbPedid.FieldByName('PD6').AsString+'"';
          dbArti.Active:=True;
          if dbArti.RecordCount=0 then begin showmessage('SE HA BORRADO EL ARTICULO '+dbPedid.FieldByName('PD7').AsString); continue; end;
          dbArti.Edit;
          dbArti.FieldByName('A2').Value:=dbPedid.FieldByName('PD16').AsFloat;//--Pvp.
          dbArti.FieldByName('A3').Value:=dbPedid.FieldByName('PD14').AsFloat;//--Iva.
          dbArti.FieldByName('A36').Value:=dbPedid.FieldByName('PD13').AsFloat;//--Recargo de equivalencia.
          dbArti.FieldByName('A21').Value:=dbPedid.FieldByName('PD12').AsFloat;//--Precio sin iva.
          if dbPedid.FieldByName('PD10').AsFloat <> 0 then dbArti.FieldByName('A24').Value:=dbPedid.FieldByName('PD10').AsFloat;//--Costo.
          dbArti.FieldByName('A26').Value:=dbPedid.FieldByName('PD11').AsFloat;//--Margen.
          dbArti.Post;
          dbPedid.Next;
        end;
    end;
  //------------------ Actualizar articulos con estos Stocks
  if RadioButton12.Checked=True then
    begin
      dbPedid.First;
      while not dbPedid.EOF do
        begin
          if (RadioButton14.Checked=True) and (dbPedid.FieldByName('PD23').AsString='N') then begin dbPedid.Next; continue; end;
          if (RadioButton27.Checked=True) and (dbPedid.FieldByName('PD23').AsString='S') then begin dbPedid.Next; continue; end;
          dbArti.Sql.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbPedid.FieldByName('PD6').AsString+'"';
          dbArti.Active:=True;
          if dbArti.RecordCount=0 then begin showmessage('SE HA BORRADO EL ARTICULO '+dbPedid.FieldByName('PD7').AsString); continue; end;
          dbArti.Edit;
//-- INCREMENTAMOS EL STOCK CON LAS UNITADES MÁS LAS UNIDADES BONIFICADAS --- JOSE ---
          dbArti.FieldByName('A4').Value:=(dbPedid.FieldByName('PD8').AsFloat+dbPedid.FieldByName('PD8B').AsFloat);//--Unidades.
          dbArti.Post;
          dbPedid.Next;
        end;
    end;

end;

//----------------- Cerrar Utilidades --------------
procedure TFPedido.BitBtn35Click(Sender: TObject);
begin
  Panel14.Visible:=False;
end;


initialization
  {$I gestionar.lrs}

end.
