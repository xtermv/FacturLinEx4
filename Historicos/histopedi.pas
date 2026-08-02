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

unit histopedi;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  Classes, SysUtils, StrUtils, Math, Variants, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ZConnection, ZDataset, DBGrids, db, StdCtrls, DbCtrls, LR_Class,
  LR_DBSet, LCLType, CheckLst, EditBtn, lr_e_pdf, Process, Grids, Menus,
  ExtDlgs;

type

  { TFHistopedi }

  TFHistopedi = class(TForm)
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
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
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
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure Panel15Click(Sender: TObject);
    procedure RadioButton19Change(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton25Change(Sender: TObject);
    procedure RadioButton28Click(Sender: TObject);
    procedure RadioButton29Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton30Click(Sender: TObject);
    procedure RadioButton31Click(Sender: TObject);
    procedure RadioButton33Click(Sender: TObject);
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
    { Búsqueda de artículos en los pedidos de un proveedor }
    FBtnBuscarArticuloPedidos: TButton;
    FPanelBuscaArticulo: TPanel;
    FPanelBuscaCabecera: TPanel;
    FPanelBuscaAcciones: TPanel;
    FPanelBuscaPie: TPanel;
    FBtnEjecutarBuscaArticulo: TButton;
    FBtnCerrarBuscaArticulo: TButton;
    FBtnBuscaProveedor: TButton;
    FBtnBuscaArticuloNombre: TButton;
    FEditBuscaProveedor: TEdit;
    FEditBuscaProveedorNombre: TEdit;
    FEditBuscaArticulo: TEdit;
    FEditBuscaArticuloNombre: TEdit;
    FGridBuscaArticulo: TDBGrid;
    FQueryBuscaArticulo: TZQuery;
    FDataSourceBuscaArticulo: TDataSource;
    FLabelResumenBuscaArticulo: TLabel;
    FLabelTituloBuscaArticulo: TLabel;
    FProveedorBuscaArticulo: String;
    FArticuloBusca: String;
    FOrdenBuscaArticulo: String;
    FOrdenBuscaDesc: Boolean;
    FOrdenGridPrincipal: String;
    FOrdenGridPrincipalDesc: Boolean;
    FOrdenGridLineas: String;
    FOrdenGridLineasDesc: Boolean;
    procedure CrearBusquedaArticulo;
    procedure AbrirBusquedaArticulo(Sender: TObject);
    procedure CerrarBusquedaArticulo(Sender: TObject);
    procedure EjecutarBusquedaArticulo(Sender: TObject);
    procedure BuscarProveedorDesdePanel(Sender: TObject);
    procedure BuscaProveedorCodigoExit(Sender: TObject);
    procedure BuscaProveedorCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure BuscaProveedorNombreKeyPress(Sender: TObject; var Key: Char);
    function CargarProveedorBusqueda(const ACodigo: String;
      AMostrarError: Boolean=True): Boolean;
    procedure BuscarArticuloPorNombre(Sender: TObject);
    procedure BuscaArticuloCodigoExit(Sender: TObject);
    procedure BuscaArticuloCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure BuscaArticuloNombreKeyPress(Sender: TObject; var Key: Char);
    procedure GridBuscaArticuloDblClick(Sender: TObject);
    procedure GridBuscaArticuloTitleClick(Column: TColumn);
    procedure CargarConsultaBuscaArticulo;
    procedure ActualizarTitulosBuscaArticulo;
    procedure AplicarDisenoModerno;
    procedure AjustarDisenoModerno;
    procedure FormShowModerno(Sender: TObject);
    procedure FormResizeModerno(Sender: TObject);
    procedure AplicarSeleccionModerna(AControl: TWinControl);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure OrdenarQueryDesdeGrid(AQuery: TZQuery; AGrid: TDBGrid;
      const ACampo: String; var AOrden: String; var ADesc: Boolean);
    procedure ActualizarFlechasGrid(AGrid: TDBGrid; const AOrden: String;
      ADesc: Boolean);
  public
    { public declarations }
  end;

  procedure ShowFormHistoPedido;

var
  FHistopedi: TFHistopedi;
  SPEDIDO,TIPOPEDIDO,NOMBREPEDIDO,LETRAPEDIDO: String;
  SwCrea, NPEDIDO, Pdf: Integer;
  BASE1,BASE2,BASE3,IMPOIVA1,IMPOIVA2,IMPOIVA3,TOTAL1,TOTAL2,TOTAL3: Double;
  IRIVA1,IRIVA2,IRIVA3,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PRIVA1,PRIVA2,PRIVA3:Double;

implementation

{ TFHistopedi }

uses
  Global, Funciones, Busquedas
  {$IFDEF LCLGTK2}, Gtk2, Gdk2{$ENDIF};

//=============== CREAR EL FORMULARIO ================
procedure ShowFormHistoPedido;
begin
  with TFHistopedi.Create(Application) do
    begin
       ShowModal;
    end;
end;

//==========================================================================
//========== BUSCAR UN ARTICULO EN LOS PEDIDOS DE UN PROVEEDOR ============
//==========================================================================
procedure TFHistopedi.CrearBusquedaArticulo;
var
  Lbl: TLabel;
  Col: TColumn;
begin
  // Botón integrado en el filtro actual de proveedor.
  FBtnBuscarArticuloPedidos:=TButton.Create(Self);
  FBtnBuscarArticuloPedidos.Parent:=Panel2;
  FBtnBuscarArticuloPedidos.Left:=8;
  FBtnBuscarArticuloPedidos.Top:=56;
  FBtnBuscarArticuloPedidos.Width:=330;
  FBtnBuscarArticuloPedidos.Height:=32;
  FBtnBuscarArticuloPedidos.Caption:='Buscar artículo en pedidos del proveedor';
  FBtnBuscarArticuloPedidos.Hint:='Localiza un artículo en todos los pedidos del proveedor seleccionado';
  FBtnBuscarArticuloPedidos.ShowHint:=True;
  FBtnBuscarArticuloPedidos.Font.Style:=[fsBold];
  FBtnBuscarArticuloPedidos.OnClick:=@AbrirBusquedaArticulo;
  FBtnBuscarArticuloPedidos.TabOrder:=4;

  FPanelBuscaArticulo:=TPanel.Create(Self);
  // Se crea directamente sobre el formulario para tapar también la barra
  // inferior. Con alNone puede superponerse a los paneles alineados existentes.
  FPanelBuscaArticulo.Parent:=Self;
  FPanelBuscaArticulo.Align:=alNone;
  FPanelBuscaArticulo.SetBounds(0,0,ClientWidth,ClientHeight);
  FPanelBuscaArticulo.Anchors:=[akTop,akLeft,akRight,akBottom];
  FPanelBuscaArticulo.Caption:='';
  FPanelBuscaArticulo.BevelOuter:=bvNone;
  FPanelBuscaArticulo.Color:=RGBToColor(241,245,247);
  FPanelBuscaArticulo.Visible:=False;

  FPanelBuscaCabecera:=TPanel.Create(Self);
  FPanelBuscaCabecera.Parent:=FPanelBuscaArticulo;
  FPanelBuscaCabecera.Align:=alTop;
  FPanelBuscaCabecera.Height:=154;
  FPanelBuscaCabecera.Caption:='';
  FPanelBuscaCabecera.BevelOuter:=bvNone;
  FPanelBuscaCabecera.Color:=RGBToColor(226,238,242);

  FLabelTituloBuscaArticulo:=TLabel.Create(Self);
  FLabelTituloBuscaArticulo.Parent:=FPanelBuscaCabecera;
  FLabelTituloBuscaArticulo.SetBounds(0,0,FPanelBuscaCabecera.ClientWidth,34);
  FLabelTituloBuscaArticulo.Anchors:=[akTop,akLeft,akRight];
  FLabelTituloBuscaArticulo.AutoSize:=False;
  FLabelTituloBuscaArticulo.Alignment:=taCenter;
  FLabelTituloBuscaArticulo.Layout:=tlCenter;
  FLabelTituloBuscaArticulo.Transparent:=False;
  FLabelTituloBuscaArticulo.ParentColor:=False;
  FLabelTituloBuscaArticulo.Color:=RGBToColor(18,76,91);
  FLabelTituloBuscaArticulo.Caption:='BÚSQUEDA DE ARTÍCULOS EN PEDIDOS DEL PROVEEDOR';
  FLabelTituloBuscaArticulo.Font.Height:=-16;
  FLabelTituloBuscaArticulo.Font.Style:=[fsBold];
  FLabelTituloBuscaArticulo.Font.Color:=clWhite;

  Lbl:=TLabel.Create(Self);
  Lbl.Parent:=FPanelBuscaCabecera;
  Lbl.Left:=16;
  Lbl.Top:=44;
  Lbl.Caption:='Proveedor';

  FEditBuscaProveedor:=TEdit.Create(Self);
  FEditBuscaProveedor.Parent:=FPanelBuscaCabecera;
  FEditBuscaProveedor.Left:=92;
  FEditBuscaProveedor.Top:=39;
  FEditBuscaProveedor.Width:=90;
  FEditBuscaProveedor.Height:=29;
  FEditBuscaProveedor.ReadOnly:=False;
  FEditBuscaProveedor.TabStop:=True;
  FEditBuscaProveedor.CharCase:=ecUppercase;
  FEditBuscaProveedor.Hint:='Puede cambiar el proveedor sin cerrar esta búsqueda.';
  FEditBuscaProveedor.ShowHint:=True;
  FEditBuscaProveedor.OnExit:=@BuscaProveedorCodigoExit;
  FEditBuscaProveedor.OnKeyPress:=@BuscaProveedorCodigoKeyPress;

  FEditBuscaProveedorNombre:=TEdit.Create(Self);
  FEditBuscaProveedorNombre.Parent:=FPanelBuscaCabecera;
  FEditBuscaProveedorNombre.Left:=190;
  FEditBuscaProveedorNombre.Top:=39;
  FEditBuscaProveedorNombre.Width:=390;
  FEditBuscaProveedorNombre.Height:=29;
  FEditBuscaProveedorNombre.ReadOnly:=False;
  FEditBuscaProveedorNombre.TabStop:=True;
  FEditBuscaProveedorNombre.CharCase:=ecUppercase;
  FEditBuscaProveedorNombre.Hint:='Escriba el comienzo del nombre y pulse Enter o el botón ...';
  FEditBuscaProveedorNombre.ShowHint:=True;
  FEditBuscaProveedorNombre.OnKeyPress:=@BuscaProveedorNombreKeyPress;

  FBtnBuscaProveedor:=TButton.Create(Self);
  FBtnBuscaProveedor.Parent:=FPanelBuscaCabecera;
  FBtnBuscaProveedor.Left:=574;
  FBtnBuscaProveedor.Top:=39;
  FBtnBuscaProveedor.Width:=136;
  FBtnBuscaProveedor.Height:=29;
  FBtnBuscaProveedor.Caption:='Cambiar proveedor...';
  FBtnBuscaProveedor.Hint:='Buscar y cambiar de proveedor';
  FBtnBuscaProveedor.ShowHint:=True;
  FBtnBuscaProveedor.Font.Style:=[fsBold];
  FBtnBuscaProveedor.OnClick:=@BuscarProveedorDesdePanel;

  Lbl:=TLabel.Create(Self);
  Lbl.Parent:=FPanelBuscaCabecera;
  Lbl.Left:=16;
  Lbl.Top:=85;
  Lbl.Caption:='Artículo';

  FEditBuscaArticulo:=TEdit.Create(Self);
  FEditBuscaArticulo.Parent:=FPanelBuscaCabecera;
  FEditBuscaArticulo.Left:=92;
  FEditBuscaArticulo.Top:=79;
  FEditBuscaArticulo.Width:=128;
  FEditBuscaArticulo.Height:=29;
  FEditBuscaArticulo.CharCase:=ecUppercase;
  FEditBuscaArticulo.OnExit:=@BuscaArticuloCodigoExit;
  FEditBuscaArticulo.OnKeyPress:=@BuscaArticuloCodigoKeyPress;

  FEditBuscaArticuloNombre:=TEdit.Create(Self);
  FEditBuscaArticuloNombre.Parent:=FPanelBuscaCabecera;
  FEditBuscaArticuloNombre.Left:=228;
  FEditBuscaArticuloNombre.Top:=79;
  FEditBuscaArticuloNombre.Width:=392;
  FEditBuscaArticuloNombre.Height:=29;
  FEditBuscaArticuloNombre.CharCase:=ecUppercase;
  FEditBuscaArticuloNombre.Hint:='Teclea el comienzo de la descripción y pulsa Enter o el botón ...';
  FEditBuscaArticuloNombre.ShowHint:=True;
  FEditBuscaArticuloNombre.OnKeyPress:=@BuscaArticuloNombreKeyPress;

  FBtnBuscaArticuloNombre:=TButton.Create(Self);
  FBtnBuscaArticuloNombre.Parent:=FPanelBuscaCabecera;
  FBtnBuscaArticuloNombre.Left:=628;
  FBtnBuscaArticuloNombre.Top:=79;
  FBtnBuscaArticuloNombre.Width:=34;
  FBtnBuscaArticuloNombre.Height:=29;
  FBtnBuscaArticuloNombre.Caption:='...';
  FBtnBuscaArticuloNombre.Hint:='Buscar artículo por descripción';
  FBtnBuscaArticuloNombre.ShowHint:=True;
  FBtnBuscaArticuloNombre.Font.Style:=[fsBold];
  FBtnBuscaArticuloNombre.OnClick:=@BuscarArticuloPorNombre;

  // Zona fija de acciones: evita calcular posiciones antes de que el panel
  // tenga su ancho definitivo y garantiza que Buscar y Cerrar no se solapen.
  FPanelBuscaAcciones:=TPanel.Create(Self);
  FPanelBuscaAcciones.Parent:=FPanelBuscaCabecera;
  FPanelBuscaAcciones.Align:=alRight;
  FPanelBuscaAcciones.Width:=292;
  FPanelBuscaAcciones.Caption:='';
  FPanelBuscaAcciones.BevelOuter:=bvNone;
  FPanelBuscaAcciones.Color:=FPanelBuscaCabecera.Color;

  FBtnEjecutarBuscaArticulo:=TButton.Create(Self);
  FBtnEjecutarBuscaArticulo.Parent:=FPanelBuscaAcciones;
  FBtnEjecutarBuscaArticulo.Left:=8;
  FBtnEjecutarBuscaArticulo.Top:=39;
  FBtnEjecutarBuscaArticulo.Width:=134;
  FBtnEjecutarBuscaArticulo.Height:=36;
  FBtnEjecutarBuscaArticulo.Caption:='Buscar artículo';
  FBtnEjecutarBuscaArticulo.Font.Style:=[fsBold];
  FBtnEjecutarBuscaArticulo.Default:=True;
  FBtnEjecutarBuscaArticulo.OnClick:=@EjecutarBusquedaArticulo;

  FBtnCerrarBuscaArticulo:=TButton.Create(Self);
  FBtnCerrarBuscaArticulo.Parent:=FPanelBuscaAcciones;
  FBtnCerrarBuscaArticulo.Left:=150;
  FBtnCerrarBuscaArticulo.Top:=39;
  FBtnCerrarBuscaArticulo.Width:=134;
  FBtnCerrarBuscaArticulo.Height:=36;
  FBtnCerrarBuscaArticulo.Caption:='Cerrar búsqueda';
  FBtnCerrarBuscaArticulo.Cancel:=True;
  FBtnCerrarBuscaArticulo.OnClick:=@CerrarBusquedaArticulo;

  FPanelBuscaPie:=TPanel.Create(Self);
  FPanelBuscaPie.Parent:=FPanelBuscaArticulo;
  FPanelBuscaPie.Align:=alBottom;
  FPanelBuscaPie.Height:=40;
  FPanelBuscaPie.Caption:='';
  FPanelBuscaPie.BevelOuter:=bvNone;
  FPanelBuscaPie.Color:=RGBToColor(18,76,91);

  FLabelResumenBuscaArticulo:=TLabel.Create(Self);
  FLabelResumenBuscaArticulo.Parent:=FPanelBuscaPie;
  FLabelResumenBuscaArticulo.Left:=16;
  FLabelResumenBuscaArticulo.Top:=10;
  FLabelResumenBuscaArticulo.Caption:='Seleccione un artículo y pulse Buscar.';
  FLabelResumenBuscaArticulo.Font.Style:=[fsBold];
  FLabelResumenBuscaArticulo.Font.Color:=clWhite;

  FQueryBuscaArticulo:=TZQuery.Create(Self);
  FQueryBuscaArticulo.Connection:=dbPedic.Connection;

  FDataSourceBuscaArticulo:=TDataSource.Create(Self);
  FDataSourceBuscaArticulo.DataSet:=FQueryBuscaArticulo;

  FGridBuscaArticulo:=TDBGrid.Create(Self);
  FGridBuscaArticulo.Parent:=FPanelBuscaArticulo;
  FGridBuscaArticulo.Align:=alClient;
  FGridBuscaArticulo.DataSource:=FDataSourceBuscaArticulo;
  FGridBuscaArticulo.ReadOnly:=True;
  FGridBuscaArticulo.Options:=[dgTitles,dgIndicator,dgColumnResize,dgColumnMove,
    dgColLines,dgRowLines,dgTabs,dgRowSelect,dgAlwaysShowSelection,dgDisplayMemoText];
  FGridBuscaArticulo.Scrollbars:=ssAutoBoth;
  FGridBuscaArticulo.OnDblClick:=@GridBuscaArticuloDblClick;
  FGridBuscaArticulo.OnTitleClick:=@GridBuscaArticuloTitleClick;
  FGridBuscaArticulo.Hint:='Doble clic para abrir el pedido. Pulse una cabecera para ordenar.';
  FGridBuscaArticulo.ShowHint:=True;

  Col:=FGridBuscaArticulo.Columns.Add;
  Col.FieldName:='FECHA';
  Col.Title.Caption:='FECHA';
  Col.Width:=90;
  Col.Alignment:=taCenter;
  Col.Title.Alignment:=taCenter;

  Col:=FGridBuscaArticulo.Columns.Add;
  Col.FieldName:='SERIE';
  Col.Title.Caption:='SERIE';
  Col.Width:=58;
  Col.Alignment:=taCenter;
  Col.Title.Alignment:=taCenter;

  Col:=FGridBuscaArticulo.Columns.Add;
  Col.FieldName:='PEDIDO';
  Col.Title.Caption:='Nº PEDIDO';
  Col.Width:=86;
  Col.Alignment:=taRightJustify;
  Col.Title.Alignment:=taRightJustify;

  Col:=FGridBuscaArticulo.Columns.Add;
  Col.FieldName:='CODIGO';
  Col.Title.Caption:='CÓDIGO';
  Col.Width:=110;

  Col:=FGridBuscaArticulo.Columns.Add;
  Col.FieldName:='DESCRIPCION';
  Col.Title.Caption:='DESCRIPCIÓN';
  Col.Width:=330;

  Col:=FGridBuscaArticulo.Columns.Add;
  Col.FieldName:='CANTIDAD';
  Col.Title.Caption:='CANTIDAD';
  Col.Width:=90;
  Col.Alignment:=taRightJustify;
  Col.Title.Alignment:=taRightJustify;
  Col.DisplayFormat:='###,###,##0.###';

  Col:=FGridBuscaArticulo.Columns.Add;
  Col.FieldName:='PRECIO';
  Col.Title.Caption:='PRECIO COMPRA';
  Col.Width:=105;
  Col.Alignment:=taRightJustify;
  Col.Title.Alignment:=taRightJustify;
  Col.DisplayFormat:='###,###,##0.0000';

  Col:=FGridBuscaArticulo.Columns.Add;
  Col.FieldName:='IMPORTE';
  Col.Title.Caption:='IMPORTE';
  Col.Width:=100;
  Col.Alignment:=taRightJustify;
  Col.Title.Alignment:=taRightJustify;
  Col.DisplayFormat:='###,###,##0.00';

  FOrdenBuscaArticulo:='FECHA';
  FOrdenBuscaDesc:=True;
  ActualizarTitulosBuscaArticulo;
end;

procedure TFHistopedi.AbrirBusquedaArticulo(Sender: TObject);
begin
  if Trim(Edit1.Text)='' then
    begin
      ShowMessage('DEBE INDICAR PRIMERO EL PROVEEDOR.');
      Edit1.SetFocus;
      Exit;
    end;

  if not CargarProveedorBusqueda(Trim(Edit1.Text),True) then
    begin
      Edit1.SetFocus;
      Exit;
    end;

  Panel2.Visible:=False;
  DBGrid1.Enabled:=True;
  FQueryBuscaArticulo.Close;
  FArticuloBusca:='';
  FEditBuscaArticulo.Clear;
  FEditBuscaArticuloNombre.Clear;
  FLabelResumenBuscaArticulo.Caption:=
    'Puede cambiar de proveedor arriba. Seleccione un artículo y pulse Buscar.';
  FOrdenBuscaArticulo:='FECHA';
  FOrdenBuscaDesc:=True;
  ActualizarTitulosBuscaArticulo;
  FPanelBuscaArticulo.Visible:=True;
  FPanelBuscaArticulo.BringToFront;
  AjustarDisenoModerno;
  AplicarSeleccionModerna(FPanelBuscaArticulo);
  FEditBuscaArticulo.SetFocus;
end;

procedure TFHistopedi.CerrarBusquedaArticulo(Sender: TObject);
begin
  if Assigned(FQueryBuscaArticulo) then FQueryBuscaArticulo.Close;
  if Assigned(FPanelBuscaArticulo) then FPanelBuscaArticulo.Visible:=False;
  DBGrid1.Enabled:=True;
  if DBGrid1.CanFocus then DBGrid1.SetFocus;
end;


function TFHistopedi.CargarProveedorBusqueda(const ACodigo: String;
  AMostrarError: Boolean): Boolean;
var
  Codigo: String;
begin
  Result:=False;
  Codigo:=Trim(ACodigo);
  if Codigo='' then
    begin
      FEditBuscaProveedorNombre.Clear;
      Exit;
    end;

  dbProve.Close;
  dbProve.SQL.Text:='SELECT P0, P1 FROM proveedores WHERE P0='+QuotedStr(Codigo);
  dbProve.Open;
  if dbProve.RecordCount=0 then
    begin
      FEditBuscaProveedorNombre.Clear;
      if AMostrarError then
        ShowMessage('ESE PROVEEDOR NO EXISTE.');
      Exit;
    end;

  FProveedorBuscaArticulo:=dbProve.FieldByName('P0').AsString;
  FEditBuscaProveedor.Text:=FProveedorBuscaArticulo;
  FEditBuscaProveedorNombre.Text:=dbProve.FieldByName('P1').AsString;
  Edit1.Text:=FProveedorBuscaArticulo;
  Edit2.Text:=FEditBuscaProveedorNombre.Text;

  // Mantener la cabecera principal sincronizada permite abrir con doble clic
  // cualquier pedido del nuevo proveedor sin abandonar esta pantalla.
  dbPedic.Close;
  dbPedic.SQL.Text:='SELECT * FROM hipedicc'+Tienda+
    ' WHERE HPC2='+QuotedStr(FProveedorBuscaArticulo);
  if TIPOPEDIDO<>'' then
    dbPedic.SQL.Text:=dbPedic.SQL.Text+' AND HPC28='+QuotedStr(TIPOPEDIDO);
  dbPedic.SQL.Text:=dbPedic.SQL.Text+
    ' ORDER BY HPC0 ASC, HPC1 DESC, HPC2 ASC, HPC3 ASC, HPC4 DESC';
  dbPedic.Open;
  FOrdenGridPrincipal:='HPC1';
  FOrdenGridPrincipalDesc:=True;
  ActualizarFlechasGrid(DBGrid1,FOrdenGridPrincipal,FOrdenGridPrincipalDesc);
  StaticText5.Caption:=NOMBREPEDIDO+' DEL PROVEEDOR: '+
    FProveedorBuscaArticulo+' '+FEditBuscaProveedorNombre.Text;

  if Assigned(FQueryBuscaArticulo) then
    begin
      if (FArticuloBusca<>'') and FPanelBuscaArticulo.Visible then
        CargarConsultaBuscaArticulo
      else
        begin
          FQueryBuscaArticulo.Close;
          FLabelResumenBuscaArticulo.Caption:=
            'Proveedor cambiado. Seleccione un artículo y pulse Buscar.';
        end;
    end;
  Result:=True;
end;

procedure TFHistopedi.BuscaProveedorCodigoExit(Sender: TObject);
begin
  if Trim(FEditBuscaProveedor.Text)='' then
    begin
      FEditBuscaProveedorNombre.Clear;
      Exit;
    end;
  CargarProveedorBusqueda(FEditBuscaProveedor.Text,True);
end;

procedure TFHistopedi.BuscaProveedorCodigoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    begin
      Key:=#0;
      if CargarProveedorBusqueda(FEditBuscaProveedor.Text,True) then
        FEditBuscaArticulo.SetFocus
      else
        FEditBuscaProveedor.SetFocus;
    end;
end;

procedure TFHistopedi.BuscaProveedorNombreKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    begin
      Key:=#0;
      BuscarProveedorDesdePanel(Sender);
    end;
end;

procedure TFHistopedi.BuscarProveedorDesdePanel(Sender: TObject);
var
  TextoBusca, Consulta, CodigoAnterior, NombreAnterior, CodigoElegido: String;
begin
  CodigoAnterior:=FEditBuscaProveedor.Text;
  NombreAnterior:=FEditBuscaProveedorNombre.Text;
  TextoBusca:=Trim(FEditBuscaProveedorNombre.Text);
  TextoBusca:=StringReplace(TextoBusca,'"','',[rfReplaceAll]);

  Consulta:='SELECT P0, P1, P2 FROM proveedores';
  if TextoBusca<>'' then
    Consulta:=Consulta+' WHERE P1 LIKE "'+TextoBusca+'%"';
  Consulta:=Consulta+' ORDER BY P1';

  CodigoElegido:=FBusquedas.IniciaBusquedas(
    Consulta,['Código','Razón social','Dirección'],'P0');

  if CodigoElegido<>'' then
    begin
      FEditBuscaProveedor.Text:=CodigoElegido;
      if CargarProveedorBusqueda(CodigoElegido,True) then
        FEditBuscaArticulo.SetFocus;
    end
  else
    begin
      FEditBuscaProveedor.Text:=CodigoAnterior;
      FEditBuscaProveedorNombre.Text:=NombreAnterior;
      FEditBuscaProveedorNombre.SetFocus;
    end;
end;

procedure TFHistopedi.BuscaArticuloCodigoExit(Sender: TObject);
begin
  if Trim(FEditBuscaArticulo.Text)='' then Exit;
  dbArti.Close;
  dbArti.SQL.Text:='SELECT A0, A1 FROM artitien'+Tienda+
    ' WHERE A0='+QuotedStr(Trim(FEditBuscaArticulo.Text));
  dbArti.Open;
  if dbArti.RecordCount=0 then
    begin
      FEditBuscaArticuloNombre.Clear;
      Exit;
    end;
  FEditBuscaArticulo.Text:=dbArti.FieldByName('A0').AsString;
  FEditBuscaArticuloNombre.Text:=dbArti.FieldByName('A1').AsString;
end;

procedure TFHistopedi.BuscaArticuloCodigoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    begin
      Key:=#0;
      EjecutarBusquedaArticulo(Sender);
    end;
end;

procedure TFHistopedi.BuscaArticuloNombreKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    begin
      Key:=#0;
      BuscarArticuloPorNombre(Sender);
    end;
end;

procedure TFHistopedi.BuscarArticuloPorNombre(Sender: TObject);
var
  TextoBusca: String;
begin
  TextoBusca:=Trim(FEditBuscaArticuloNombre.Text);
  if TextoBusca='' then
    begin
      ShowMessage('TECLEE EL COMIENZO DE LA DESCRIPCIÓN A BUSCAR.');
      FEditBuscaArticuloNombre.SetFocus;
      Exit;
    end;

  TextoBusca:=StringReplace(TextoBusca,'"','',[rfReplaceAll]);
  FEditBuscaArticulo.Text:=FBusquedas.IniciaBusquedas(
    'SELECT A0, A1, A24 FROM artitien'+Tienda+
    ' WHERE A1 LIKE "'+TextoBusca+'%" ORDER BY A1',
    ['Código','Descripción','Precio costo'],'A0');

  if FEditBuscaArticulo.Text<>'' then
    begin
      BuscaArticuloCodigoExit(FEditBuscaArticulo);
      FEditBuscaArticulo.SetFocus;
    end;
end;

procedure TFHistopedi.EjecutarBusquedaArticulo(Sender: TObject);
begin
  if Trim(FEditBuscaArticulo.Text)='' then
    begin
      ShowMessage('DEBE INDICAR EL ARTÍCULO A BUSCAR.');
      FEditBuscaArticulo.SetFocus;
      Exit;
    end;

  dbArti.Close;
  dbArti.SQL.Text:='SELECT A0, A1 FROM artitien'+Tienda+
    ' WHERE A0='+QuotedStr(Trim(FEditBuscaArticulo.Text));
  dbArti.Open;
  if dbArti.RecordCount=0 then
    begin
      ShowMessage('ESE ARTÍCULO NO EXISTE.');
      FEditBuscaArticulo.SetFocus;
      Exit;
    end;

  FArticuloBusca:=dbArti.FieldByName('A0').AsString;
  FEditBuscaArticulo.Text:=FArticuloBusca;
  FEditBuscaArticuloNombre.Text:=dbArti.FieldByName('A1').AsString;
  FOrdenBuscaArticulo:='FECHA';
  FOrdenBuscaDesc:=True;
  CargarConsultaBuscaArticulo;
end;

procedure TFHistopedi.CargarConsultaBuscaArticulo;
var
  CantidadTotal: Double;
  NumLineas: Integer;
  Pedidos: TStringList;
  ClavePedido: String;
begin
  FQueryBuscaArticulo.Close;
  FQueryBuscaArticulo.SQL.Text:=
    'SELECT C.HPC0 AS TIENDA, C.HPC1 AS FECHA, C.HPC2 AS PROVEEDOR, '+
    'C.HPC3 AS SERIE, C.HPC4 AS PEDIDO, D.HPD6 AS CODIGO, '+
    'D.HPD7 AS DESCRIPCION, D.HPD8 AS CANTIDAD, '+
    'D.HPD10 AS PRECIO, D.HPD17 AS IMPORTE '+
    'FROM hipedicc'+Tienda+' C INNER JOIN hipedidd'+Tienda+' D ON '+
    'D.HPD0=C.HPC0 AND D.HPD1=C.HPC1 AND D.HPD2=C.HPC2 AND '+
    'D.HPD3=C.HPC3 AND D.HPD4=C.HPC4 '+
    'WHERE C.HPC2='+QuotedStr(FProveedorBuscaArticulo)+
    ' AND D.HPD6='+QuotedStr(FArticuloBusca);
  if TIPOPEDIDO<>'' then
    FQueryBuscaArticulo.SQL.Text:=FQueryBuscaArticulo.SQL.Text+
      ' AND C.HPC28='+QuotedStr(TIPOPEDIDO);
  FQueryBuscaArticulo.SQL.Text:=FQueryBuscaArticulo.SQL.Text+
    ' ORDER BY '+FOrdenBuscaArticulo;
  if FOrdenBuscaDesc then
    FQueryBuscaArticulo.SQL.Text:=FQueryBuscaArticulo.SQL.Text+' DESC'
  else
    FQueryBuscaArticulo.SQL.Text:=FQueryBuscaArticulo.SQL.Text+' ASC';
  if FOrdenBuscaArticulo<>'FECHA' then
    FQueryBuscaArticulo.SQL.Text:=FQueryBuscaArticulo.SQL.Text+', FECHA DESC';
  FQueryBuscaArticulo.Open;

  CantidadTotal:=0;
  NumLineas:=0;
  Pedidos:=TStringList.Create;
  try
    Pedidos.Sorted:=True;
    Pedidos.Duplicates:=dupIgnore;
    FQueryBuscaArticulo.DisableControls;
    try
      FQueryBuscaArticulo.First;
      while not FQueryBuscaArticulo.EOF do
        begin
          Inc(NumLineas);
          CantidadTotal:=CantidadTotal+
            FQueryBuscaArticulo.FieldByName('CANTIDAD').AsFloat;
          ClavePedido:=FQueryBuscaArticulo.FieldByName('TIENDA').AsString+'|'+
            FormatDateTime('yyyymmdd',FQueryBuscaArticulo.FieldByName('FECHA').AsDateTime)+'|'+
            FQueryBuscaArticulo.FieldByName('SERIE').AsString+'|'+
            FQueryBuscaArticulo.FieldByName('PEDIDO').AsString;
          Pedidos.Add(ClavePedido);
          FQueryBuscaArticulo.Next;
        end;
      FQueryBuscaArticulo.First;
    finally
      FQueryBuscaArticulo.EnableControls;
    end;

    if NumLineas=0 then
      FLabelResumenBuscaArticulo.Caption:=
        'El artículo no aparece en ningún pedido de este proveedor.'
    else
      FLabelResumenBuscaArticulo.Caption:=Format(
        'Pedidos encontrados: %d   Líneas: %d   Cantidad total: %s',
        [Pedidos.Count,NumLineas,FormatFloat('###,###,##0.###',CantidadTotal)]);
  finally
    Pedidos.Free;
  end;
  ActualizarTitulosBuscaArticulo;
end;

procedure TFHistopedi.GridBuscaArticuloTitleClick(Column: TColumn);
begin
  if FArticuloBusca='' then Exit;
  if (Column=nil) or (Column.FieldName='') then Exit;
  if not (SameText(Column.FieldName,'FECHA') or
          SameText(Column.FieldName,'SERIE') or
          SameText(Column.FieldName,'PEDIDO') or
          SameText(Column.FieldName,'CODIGO') or
          SameText(Column.FieldName,'DESCRIPCION') or
          SameText(Column.FieldName,'CANTIDAD') or
          SameText(Column.FieldName,'PRECIO') or
          SameText(Column.FieldName,'IMPORTE')) then Exit;

  if SameText(FOrdenBuscaArticulo,Column.FieldName) then
    FOrdenBuscaDesc:=not FOrdenBuscaDesc
  else
    begin
      FOrdenBuscaArticulo:=Column.FieldName;
      FOrdenBuscaDesc:=SameText(Column.FieldName,'FECHA');
    end;
  CargarConsultaBuscaArticulo;
end;

procedure TFHistopedi.ActualizarTitulosBuscaArticulo;
var
  I: Integer;
  BaseTitulo, Flecha: String;
begin
  if not Assigned(FGridBuscaArticulo) then Exit;
  for I:=0 to FGridBuscaArticulo.Columns.Count-1 do
    begin
      if SameText(FGridBuscaArticulo.Columns[I].FieldName,'FECHA') then
        BaseTitulo:='FECHA'
      else if SameText(FGridBuscaArticulo.Columns[I].FieldName,'SERIE') then
        BaseTitulo:='SERIE'
      else if SameText(FGridBuscaArticulo.Columns[I].FieldName,'PEDIDO') then
        BaseTitulo:='Nº PEDIDO'
      else if SameText(FGridBuscaArticulo.Columns[I].FieldName,'CODIGO') then
        BaseTitulo:='CÓDIGO'
      else if SameText(FGridBuscaArticulo.Columns[I].FieldName,'DESCRIPCION') then
        BaseTitulo:='DESCRIPCIÓN'
      else if SameText(FGridBuscaArticulo.Columns[I].FieldName,'CANTIDAD') then
        BaseTitulo:='CANTIDAD'
      else if SameText(FGridBuscaArticulo.Columns[I].FieldName,'PRECIO') then
        BaseTitulo:='PRECIO COMPRA'
      else if SameText(FGridBuscaArticulo.Columns[I].FieldName,'IMPORTE') then
        BaseTitulo:='IMPORTE'
      else
        BaseTitulo:=FGridBuscaArticulo.Columns[I].Title.Caption;
      Flecha:='';
      if SameText(FGridBuscaArticulo.Columns[I].FieldName,FOrdenBuscaArticulo) then
        if FOrdenBuscaDesc then Flecha:=' ▼' else Flecha:=' ▲';
      FGridBuscaArticulo.Columns[I].Title.Caption:=BaseTitulo+Flecha;
    end;
end;

procedure TFHistopedi.GridBuscaArticuloDblClick(Sender: TObject);
var
  Vals: Variant;
  TiendaPedido, ProveedorPedido, SeriePedido, NumeroPedidoSel: String;
  FechaPedido: TDateTime;
begin
  if (not FQueryBuscaArticulo.Active) or (FQueryBuscaArticulo.RecordCount=0) then Exit;

  TiendaPedido:=FQueryBuscaArticulo.FieldByName('TIENDA').AsString;
  FechaPedido:=FQueryBuscaArticulo.FieldByName('FECHA').AsDateTime;
  ProveedorPedido:=FQueryBuscaArticulo.FieldByName('PROVEEDOR').AsString;
  SeriePedido:=FQueryBuscaArticulo.FieldByName('SERIE').AsString;
  NumeroPedidoSel:=FQueryBuscaArticulo.FieldByName('PEDIDO').AsString;
  Vals:=VarArrayOf([TiendaPedido,FechaPedido,ProveedorPedido,SeriePedido,NumeroPedidoSel]);

  if not dbPedic.Locate('HPC0;HPC1;HPC2;HPC3;HPC4',Vals,[]) then
    begin
      // Respaldo para instalaciones en las que Locate compara la fecha
      // con un formato distinto al devuelto por MariaDB.
      dbPedic.Close;
      dbPedic.SQL.Text:='SELECT * FROM hipedicc'+Tienda+
        ' WHERE HPC0='+QuotedStr(TiendaPedido)+
        ' AND HPC1="'+FormatDateTime('yyyy/mm/dd',FechaPedido)+'"'+
        ' AND HPC2='+QuotedStr(ProveedorPedido)+
        ' AND HPC3='+QuotedStr(SeriePedido)+
        ' AND HPC4='+QuotedStr(NumeroPedidoSel);
      dbPedic.Open;
    end;

  if dbPedic.RecordCount=0 then
    begin
      ShowMessage('NO SE HA PODIDO LOCALIZAR EL PEDIDO SELECCIONADO.');
      Exit;
    end;
  BitBtn1Click(FGridBuscaArticulo);
end;


procedure TFHistopedi.ActualizarFlechasGrid(AGrid: TDBGrid;
  const AOrden: String; ADesc: Boolean);
var
  I: Integer;
  Titulo: String;
begin
  if not Assigned(AGrid) then Exit;
  for I:=0 to AGrid.Columns.Count-1 do
    begin
      Titulo:=AGrid.Columns[I].Title.Caption;
      Titulo:=StringReplace(Titulo,' ▲','',[rfReplaceAll]);
      Titulo:=StringReplace(Titulo,' ▼','',[rfReplaceAll]);
      if SameText(AGrid.Columns[I].FieldName,AOrden) then
        if ADesc then
          Titulo:=Titulo+' ▼'
        else
          Titulo:=Titulo+' ▲';
      AGrid.Columns[I].Title.Caption:=Titulo;
    end;
end;

procedure TFHistopedi.OrdenarQueryDesdeGrid(AQuery: TZQuery; AGrid: TDBGrid;
  const ACampo: String; var AOrden: String; var ADesc: Boolean);
var
  SQLActual, SQLMayus: String;
  P: SizeInt;
begin
  if (not Assigned(AQuery)) or (not Assigned(AGrid)) or
     (Trim(ACampo)='') then Exit;

  if SameText(AOrden,ACampo) then
    ADesc:=not ADesc
  else
    begin
      AOrden:=ACampo;
      ADesc:=SameText(ACampo,'HPC1') or SameText(ACampo,'HPD1') or
             SameText(ACampo,'FECHA');
    end;

  SQLActual:=Trim(AQuery.SQL.Text);
  SQLMayus:=UpperCase(SQLActual);
  P:=RPos(' ORDER BY ',SQLMayus);
  if P>0 then
    Delete(SQLActual,P,Length(SQLActual)-P+1);

  AQuery.Close;
  AQuery.SQL.Text:=SQLActual+' ORDER BY '+ACampo;
  if ADesc then
    AQuery.SQL.Text:=AQuery.SQL.Text+' DESC'
  else
    AQuery.SQL.Text:=AQuery.SQL.Text+' ASC';
  AQuery.Open;
  ActualizarFlechasGrid(AGrid,AOrden,ADesc);
end;

procedure TFHistopedi.DBGrid1TitleClick(Column: TColumn);
begin
  if (Column=nil) or (Column.FieldName='') then Exit;
  OrdenarQueryDesdeGrid(dbPedic,DBGrid1,Column.FieldName,
    FOrdenGridPrincipal,FOrdenGridPrincipalDesc);
end;

procedure TFHistopedi.DBGrid2TitleClick(Column: TColumn);
begin
  if (Column=nil) or (Column.FieldName='') then Exit;
  OrdenarQueryDesdeGrid(dbPedid,DBGrid2,Column.FieldName,
    FOrdenGridLineas,FOrdenGridLineasDesc);
end;

procedure TFHistopedi.AplicarSeleccionModerna(AControl: TWinControl);
var
  I: Integer;
{$IFDEF LCLGTK2}
  ColorSeleccion, ColorTexto: TGdkColor;
{$ENDIF}
begin
{$IFDEF LCLGTK2}
  if AControl.HandleAllocated and
     ((AControl is TCustomEdit) or (AControl is TCustomMemo) or
      (AControl is TCustomComboBox) or (AControl is TDBGrid)) then
    begin
      ColorSeleccion.pixel:=0;
      ColorSeleccion.red:=8481;
      ColorSeleccion.green:=27242;
      ColorSeleccion.blue:=47288;
      ColorTexto.pixel:=0;
      ColorTexto.red:=65535;
      ColorTexto.green:=65535;
      ColorTexto.blue:=65535;
      gtk_widget_modify_base(PGtkWidget(AControl.Handle),
        GTK_STATE_SELECTED,@ColorSeleccion);
      gtk_widget_modify_text(PGtkWidget(AControl.Handle),
        GTK_STATE_SELECTED,@ColorTexto);
    end;
{$ENDIF}
  for I:=0 to AControl.ControlCount-1 do
    if AControl.Controls[I] is TWinControl then
      AplicarSeleccionModerna(TWinControl(AControl.Controls[I]));
end;

procedure TFHistopedi.AplicarDisenoModerno;
var
  I: Integer;
  CFondo, CPanel, CPanelAzul, CPrimario, CPrimarioOscuro,
  CTexto, CTextoSuave, CTeal, CVerde, CAmbar, CRojo, CGris: TColor;

  procedure PrepararPanel(APanel: TPanel; AColor: TColor);
  begin
    if not Assigned(APanel) then Exit;
    APanel.Caption:='';
    APanel.ParentColor:=False;
    APanel.Color:=AColor;
    APanel.BevelOuter:=bvNone;
  end;

  procedure PrepararBoton(ABoton: TButtonControl);
  begin
    if not Assigned(ABoton) then Exit;
    // TButtonControl no publica ParentFont en todas las versiones de LCL.
    ABoton.Font.Name:='Sans';
    ABoton.Font.Height:=-12;
    ABoton.Font.Style:=[fsBold];
  end;

  procedure EstilarBoton(ABoton: TButtonControl; AColor: TColor;
    ATextoClaro: Boolean=True);
  begin
    if not Assigned(ABoton) then Exit;
    PrepararBoton(ABoton);
    if ABoton is TBitBtn then
      TBitBtn(ABoton).Color:=AColor
    else if ABoton is TButton then
      TButton(ABoton).Color:=AColor;
    if ATextoClaro then
      ABoton.Font.Color:=clWhite
    else
      ABoton.Font.Color:=CTexto;
  end;

  procedure EstilarGrid(AGrid: TDBGrid);
  begin
    if not Assigned(AGrid) then Exit;
    AGrid.ParentFont:=False;
    AGrid.Font.Name:='Sans';
    AGrid.Font.Height:=-12;
    AGrid.Font.Color:=CTexto;
    AGrid.Color:=clWhite;
    AGrid.FixedColor:=CPrimario;
    AGrid.TitleFont.Name:='Sans';
    AGrid.TitleFont.Height:=-11;
    AGrid.TitleFont.Style:=[fsBold];
    AGrid.TitleFont.Color:=clWhite;
    AGrid.GridLineColor:=RGBToColor(203,213,225);
    AGrid.AlternateColor:=RGBToColor(248,250,252);
    AGrid.SelectedColor:=RGBToColor(31,103,181);
    AGrid.DefaultRowHeight:=27;
  end;

begin
  // Paleta común de los formularios modernizados de FacturLinEx.
  CFondo:=RGBToColor(241,245,247);
  CPanel:=RGBToColor(235,241,243);
  CPanelAzul:=RGBToColor(226,238,242);
  CPrimario:=RGBToColor(18,76,91);
  CPrimarioOscuro:=RGBToColor(6,55,86);
  CTexto:=RGBToColor(30,41,59);
  CTextoSuave:=RGBToColor(71,85,105);
  CTeal:=RGBToColor(14,116,144);
  CVerde:=RGBToColor(5,150,105);
  CAmbar:=RGBToColor(217,119,6);
  CRojo:=RGBToColor(220,38,38);
  CGris:=RGBToColor(71,85,105);

  ParentColor:=False;
  Color:=CFondo;
  ParentFont:=False;
  Font.Name:='Sans';
  Font.Height:=-12;
  Font.Color:=CTexto;

  // Fondo general y tarjetas auxiliares discretas.
  PrepararPanel(Panel5,CFondo);
  PrepararPanel(Panel1,CPrimarioOscuro);
  PrepararPanel(Panel2,CPanelAzul);
  PrepararPanel(Panel3,RGBToColor(255,251,235));
  PrepararPanel(Panel10,CPanel);
  PrepararPanel(Panel4,CFondo);
  PrepararPanel(Panel7,CPanelAzul);
  PrepararPanel(Panel8,RGBToColor(236,253,245));
  PrepararPanel(Panel9,RGBToColor(255,251,235));
  PrepararPanel(Panel11,CPanelAzul);
  PrepararPanel(Panel13,CPanel);
  PrepararPanel(Panel15,CPanel);
  PrepararPanel(Panel16,CPanelAzul);
  PrepararPanel(Panel17,CPanel);

  Panel1.Height:=68;
  RadioGroup3.Caption:='TIPO DE DOCUMENTO';
  RadioGroup3.ParentColor:=False;
  RadioGroup3.Color:=CPanelAzul;
  RadioGroup3.ParentFont:=False;
  RadioGroup3.Font.Name:='Sans';
  RadioGroup3.Font.Style:=[fsBold];
  RadioGroup3.Font.Color:=CTexto;

  StaticText5.BorderStyle:=sbsNone;
  StaticText5.ParentColor:=False;
  StaticText5.Color:=CPrimario;
  StaticText5.Font.Color:=clWhite;
  StaticText5.Font.Height:=-15;
  StaticText5.Font.Style:=[fsBold];

  // Tipografía y campos homogéneos.
  for I:=0 to ComponentCount-1 do
    begin
      if Components[I] is TBitBtn then
        PrepararBoton(TBitBtn(Components[I]))
      else if Components[I] is TButton then
        PrepararBoton(TButton(Components[I]))
      else if Components[I] is TLabel then
        begin
          TLabel(Components[I]).ParentFont:=False;
          TLabel(Components[I]).Font.Name:='Sans';
          TLabel(Components[I]).Font.Color:=CTexto;
        end
      else if Components[I] is TRadioButton then
        begin
          TRadioButton(Components[I]).ParentFont:=False;
          TRadioButton(Components[I]).Font.Name:='Sans';
          TRadioButton(Components[I]).Font.Color:=CTexto;
        end
      else if Components[I] is TCheckBox then
        begin
          TCheckBox(Components[I]).ParentFont:=False;
          TCheckBox(Components[I]).Font.Name:='Sans';
          TCheckBox(Components[I]).Font.Color:=CTexto;
        end
      else if Components[I] is TCustomEdit then
        begin
          // TCustomEdit no publica ParentFont en Lazarus/FPC 3.2.2.
          TCustomEdit(Components[I]).Font.Name:='Sans';
          TCustomEdit(Components[I]).Font.Color:=CTexto;
          TCustomEdit(Components[I]).Color:=clWhite;
        end
      else if Components[I] is TComboBox then
        begin
          TComboBox(Components[I]).ParentFont:=False;
          TComboBox(Components[I]).Font.Name:='Sans';
          TComboBox(Components[I]).Font.Color:=CTexto;
          TComboBox(Components[I]).Color:=clWhite;
        end;
    end;

  // La cabecera dinámica se repone después del estilo genérico de labels.
  if Assigned(FLabelTituloBuscaArticulo) then
    begin
      FLabelTituloBuscaArticulo.ParentColor:=False;
      FLabelTituloBuscaArticulo.Transparent:=False;
      FLabelTituloBuscaArticulo.Color:=CPrimario;
      FLabelTituloBuscaArticulo.Font.Color:=clWhite;
      FLabelTituloBuscaArticulo.Font.Height:=-16;
      FLabelTituloBuscaArticulo.Font.Style:=[fsBold];
      FLabelTituloBuscaArticulo.BringToFront;
    end;

  EstilarGrid(DBGrid1);
  DBGrid1.OnTitleClick:=@DBGrid1TitleClick;
  DBGrid1.Hint:='Doble clic para ver las líneas. Pulse una cabecera para ordenar.';
  DBGrid1.ShowHint:=True;

  EstilarGrid(DBGrid2);
  DBGrid2.OnTitleClick:=@DBGrid2TitleClick;
  DBGrid2.Hint:='Pulse una cabecera para ordenar las líneas.';
  DBGrid2.ShowHint:=True;

  if Assigned(FGridBuscaArticulo) then
    EstilarGrid(FGridBuscaArticulo);

  FOrdenGridPrincipal:='HPC1';
  FOrdenGridPrincipalDesc:=True;
  FOrdenGridLineas:='';
  FOrdenGridLineasDesc:=False;
  ActualizarFlechasGrid(DBGrid1,FOrdenGridPrincipal,FOrdenGridPrincipalDesc);

  BitBtn1.Caption:='Ver líneas';
  BitBtn9.Caption:='Recuperar';
  BitBtn16.Caption:='Observaciones';
  BitBtn26.Caption:='Vencimientos';
  BitBtn2.Caption:='Cerrar';
  BitBtn5.Caption:='Volver';
  BitBtn15.Caption:='Imprimir';

  // Jerarquía cromática igual al resto: verde aceptar, azul acciones,
  // ámbar operaciones especiales y rojo cancelar/borrar/salir.
  EstilarBoton(BitBtn1,CTeal);
  EstilarBoton(BitBtn9,CVerde);
  EstilarBoton(BitBtn10,CRojo);
  EstilarBoton(BitBtn16,CTeal);
  EstilarBoton(BitBtn23,CTeal);
  EstilarBoton(BitBtn26,CAmbar);
  EstilarBoton(BitBtn15,CTeal);
  EstilarBoton(BitBtn2,CRojo);
  EstilarBoton(BitBtn5,CGris);

  EstilarBoton(BitBtn3,CVerde);
  EstilarBoton(BitBtn4,CVerde);
  EstilarBoton(BitBtn7,CPrimario);
  EstilarBoton(BitBtn18,CVerde);
  EstilarBoton(BitBtn19,CVerde);
  EstilarBoton(BitBtn21,CVerde);
  EstilarBoton(BitBtn30,CVerde);
  EstilarBoton(BitBtn39,CVerde);
  EstilarBoton(BitBtn17,CGris);
  EstilarBoton(BitBtn20,CRojo);
  EstilarBoton(BitBtn22,CRojo);
  EstilarBoton(BitBtn29,CGris);
  EstilarBoton(BitBtn33,CGris);
  EstilarBoton(BitBtn38,CGris);
  EstilarBoton(BitBtn32,CTeal);
  EstilarBoton(BitBtn36,CTeal);

  if Assigned(FPanelBuscaArticulo) then
    begin
      FPanelBuscaArticulo.ParentColor:=False;
      FPanelBuscaArticulo.Color:=CFondo;
    end;
  if Assigned(FPanelBuscaCabecera) then
    begin
      FPanelBuscaCabecera.ParentColor:=False;
      FPanelBuscaCabecera.Color:=CPanelAzul;
    end;
  if Assigned(FPanelBuscaAcciones) then
    begin
      FPanelBuscaAcciones.ParentColor:=False;
      FPanelBuscaAcciones.Color:=CPanelAzul;
    end;
  if Assigned(FPanelBuscaPie) then
    begin
      FPanelBuscaPie.ParentColor:=False;
      FPanelBuscaPie.Color:=CPrimario;
    end;
  if Assigned(FLabelResumenBuscaArticulo) then
    FLabelResumenBuscaArticulo.Font.Color:=clWhite;

  EstilarBoton(FBtnBuscarArticuloPedidos,CTeal);
  EstilarBoton(FBtnBuscaProveedor,CTeal);
  EstilarBoton(FBtnBuscaArticuloNombre,CPrimario);
  EstilarBoton(FBtnEjecutarBuscaArticulo,CVerde);
  EstilarBoton(FBtnCerrarBuscaArticulo,CRojo);

  OnShow:=@FormShowModerno;
  OnResize:=@FormResizeModerno;
  AjustarDisenoModerno;
end;

procedure TFHistopedi.AjustarDisenoModerno;
var
  W, H, AnchoPanelFiltro, DerechaCampos: Integer;

  procedure CentrarPanel(APanel: TPanel);
  begin
    if (not Assigned(APanel)) or (APanel.Parent<>Panel5) then Exit;
    APanel.Left:=(Panel5.ClientWidth-APanel.Width) div 2;
    APanel.Top:=(Panel5.ClientHeight-APanel.Height) div 2;
    if APanel.Left<12 then APanel.Left:=12;
    if APanel.Top<12 then APanel.Top:=12;
  end;

begin
  if not Assigned(Panel5) then Exit;
  W:=Panel5.ClientWidth;
  H:=Panel5.ClientHeight;
  if (W<300) or (H<200) then Exit;

  RadioGroup3.SetBounds(12,8,158,120);
  RadioButton1.Left:=184; RadioButton1.Top:=17;
  RadioButton2.Left:=184; RadioButton2.Top:=50;
  RadioButton3.Left:=184; RadioButton3.Top:=83;

  StaticText5.SetBounds(390,12,Max(250,W-402),32);
  StaticText5.Anchors:=[akTop,akLeft,akRight];

  AnchoPanelFiltro:=Max(620,W-402);
  Panel2.SetBounds(390,8,AnchoPanelFiltro,116);
  Panel2.Anchors:=[akTop,akLeft,akRight];
  BitBtn3.Left:=Panel2.ClientWidth-BitBtn3.Width-8;
  BitBtn7.Left:=Panel2.ClientWidth-BitBtn7.Width-8;
  Edit2.Width:=Max(150,BitBtn7.Left-Edit2.Left-8);
  if Assigned(FBtnBuscarArticuloPedidos) then
    begin
      FBtnBuscarArticuloPedidos.Left:=8;
      FBtnBuscarArticuloPedidos.Top:=64;
      FBtnBuscarArticuloPedidos.Width:=Min(360,Panel2.ClientWidth-BitBtn3.Width-32);
    end;

  Panel3.Left:=W-Panel3.Width-12;
  Panel3.Top:=12;
  Panel3.Anchors:=[akTop,akRight];

  Panel10.Left:=W-Panel10.Width-12;
  Panel10.Top:=48;
  Panel10.Anchors:=[akTop,akRight];

  DBGrid1.SetBounds(12,136,Max(200,W-24),Max(100,H-148));
  DBGrid1.Anchors:=[akTop,akLeft,akRight,akBottom];

  if Assigned(Panel1) then
    begin
      BitBtn1.SetBounds(16,11,108,44);
      BitBtn9.SetBounds(132,11,108,44);
      BitBtn10.SetBounds(248,11,108,44);
      BitBtn23.SetBounds(364,11,108,44);
      BitBtn16.SetBounds(480,11,116,44);
      BitBtn26.SetBounds(604,11,116,44);
      BitBtn2.SetBounds(Panel1.ClientWidth-124,11,108,44);
      BitBtn2.Anchors:=[akTop,akRight];
      BitBtn15.SetBounds(16,11,108,44);
      BitBtn5.SetBounds(Panel1.ClientWidth-124,11,108,44);
      BitBtn5.Anchors:=[akTop,akRight];
    end;

  if Assigned(Panel4) then
    begin
      DBGrid2.SetBounds(12,176,Max(200,Panel4.ClientWidth-24),
        Max(100,Panel4.ClientHeight-188));
      DBGrid2.Anchors:=[akTop,akLeft,akRight,akBottom];
      Panel13.Left:=Panel4.ClientWidth-Panel13.Width-16;
      Panel13.Top:=Panel4.ClientHeight-Panel13.Height-16;
    end;

  CentrarPanel(Panel7);
  CentrarPanel(Panel8);
  CentrarPanel(Panel9);
  CentrarPanel(Panel11);
  CentrarPanel(Panel15);
  CentrarPanel(Panel16);

  if Assigned(FPanelBuscaArticulo) then
    begin
      FPanelBuscaArticulo.SetBounds(0,0,ClientWidth,ClientHeight);
      if Assigned(FPanelBuscaCabecera) and Assigned(FPanelBuscaAcciones) then
        begin
          DerechaCampos:=FPanelBuscaCabecera.ClientWidth-
            FPanelBuscaAcciones.Width-12;
          if DerechaCampos>500 then
            begin
              FBtnBuscaProveedor.Left:=DerechaCampos-FBtnBuscaProveedor.Width;
              FEditBuscaProveedorNombre.Width:=
                Max(180,FBtnBuscaProveedor.Left-FEditBuscaProveedorNombre.Left-8);
              FBtnBuscaArticuloNombre.Left:=DerechaCampos-34;
              FEditBuscaArticuloNombre.Width:=
                Max(180,FBtnBuscaArticuloNombre.Left-FEditBuscaArticuloNombre.Left-8);
            end;
        end;
      if FPanelBuscaArticulo.Visible then
        FPanelBuscaArticulo.BringToFront;
    end;
end;

procedure TFHistopedi.FormShowModerno(Sender: TObject);
begin
  AjustarDisenoModerno;
  AplicarSeleccionModerna(Self);
  if (not FPanelBuscaArticulo.Visible) and DBGrid1.CanFocus then
    DBGrid1.SetFocus;
end;

procedure TFHistopedi.FormResizeModerno(Sender: TObject);
begin
  AjustarDisenoModerno;
end;

procedure TFHistopedi.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key<>VK_ESCAPE then Exit;
  Key:=0;

  // En la vista de líneas, ESC vuelve primero al nivel anterior. Si la vista
  // fue abierta desde la búsqueda, ésta permanece disponible detrás.
  if Panel4.Visible then
    begin
      BitBtn5Click(Sender);
      if Assigned(FPanelBuscaArticulo) and FPanelBuscaArticulo.Visible then
        FPanelBuscaArticulo.BringToFront;
      Exit;
    end;

  if Assigned(FPanelBuscaArticulo) and FPanelBuscaArticulo.Visible then
    begin
      CerrarBusquedaArticulo(Sender);
      Exit;
    end;

  if Panel7.Visible then begin BitBtn17Click(Sender); Exit; end;
  if Panel8.Visible then begin BitBtn20Click(Sender); Exit; end;
  if Panel9.Visible then begin BitBtn22Click(Sender); Exit; end;
  if Panel11.Visible then begin BitBtn29Click(Sender); Exit; end;
  if Panel13.Visible then begin BitBtn33Click(Sender); Exit; end;
  if Panel15.Visible then begin Panel15Click(Sender); Exit; end;
  if Panel16.Visible then begin BitBtn38Click(Sender); Exit; end;

  if Panel2.Visible or Panel3.Visible then
    begin
      Panel2.Visible:=False;
      Panel3.Visible:=False;
      DBGrid1.Enabled:=True;
      if DBGrid1.CanFocus then DBGrid1.SetFocus;
      Exit;
    end;

  BitBtn2Click(Sender);
end;

procedure TFHistopedi.FormCreate(Sender: TObject);
begin
  OnKeyDown:=@FormKeyDown;
  CrearBusquedaArticulo;
  //--------- Conectar con la bbdd
  //Conectate(dbConnect);     // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //--------- Pedidos
  dbPedic.SQL.Text:='SELECT * FROM hipedicc'+Tienda+
                    ' ORDER BY HPC0 ASC, HPC1 DESC, HPC2 ASC, HPC3 ASC, HPC4 DESC';
  dbPedic.Active:=True;
  Panel4.SendToBack; Panel4.Visible:=False;
  DBGrid2.SendToBack; DBGrid2.Visible:=False;
  //------------- Chequear ivas
  if IVA1=0 then showmessage('DEBE DEFINIR LOS TIPOS DE IVA EN LA CONFIGURACION');
  TIPOPEDIDO:=''; NOMBREPEDIDO:='PEDIDOS/NOTAS/ALB./FACT.'; LETRAPEDIDO:='LOS';
  Panel4.Align:=AlClient;
  AplicarDisenoModerno;
end;

//==================== CERRAR PEDIDOS =====================
procedure TFHistopedi.BitBtn2Click(Sender: TObject);
begin
  dbPedic.Active:=False;
  Close();
end;
procedure TFHistopedi.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//==========================================================================
//======================= FILTROS PARA LOS PEDIDOS =========================
//==========================================================================
//----------------- Todos los pedidos ---------------
procedure TFHistopedi.RadioButton28Click(Sender: TObject);
begin
  TIPOPEDIDO:=''; NOMBREPEDIDO:='PEDIDOS/NOTAS/ALB./FACT.'; LETRAPEDIDO:='LOS';
  if RadioButton1.Checked=true then RadioButton1Click(RadioButton1);
  if RadioButton2.Checked=true then BitBtn3Click(BitBtn3);
  if RadioButton3.Checked=true then BitBtn4Click(BitBtn4);
end;
//----------------- Pedidos ---------------
procedure TFHistopedi.RadioButton29Click(Sender: TObject);
begin
  TIPOPEDIDO:='P'; NOMBREPEDIDO:='PEDIDOS'; LETRAPEDIDO:='LOS';
  if RadioButton1.Checked=true then RadioButton1Click(RadioButton1);
  if RadioButton2.Checked=true then BitBtn3Click(BitBtn3);
  if RadioButton3.Checked=true then BitBtn4Click(BitBtn4);
end;
//----------------- Notas de entregas ---------------
procedure TFHistopedi.RadioButton30Click(Sender: TObject);
begin
  TIPOPEDIDO:='N'; NOMBREPEDIDO:='NOTAS DE ENTREGAS'; LETRAPEDIDO:='LAS';
  if RadioButton1.Checked=true then RadioButton1Click(RadioButton1);
  if RadioButton2.Checked=true then BitBtn3Click(BitBtn3);
  if RadioButton3.Checked=true then BitBtn4Click(BitBtn4);
end;
//----------------- Albaranes ---------------
procedure TFHistopedi.RadioButton31Click(Sender: TObject);
begin
  TIPOPEDIDO:='A'; NOMBREPEDIDO:='ALBARANES'; LETRAPEDIDO:='LOS';
  if RadioButton1.Checked=true then RadioButton1Click(RadioButton1);
  if RadioButton2.Checked=true then BitBtn3Click(BitBtn3);
  if RadioButton3.Checked=true then BitBtn4Click(BitBtn4);
end;
//----------------- Facturas ---------------
procedure TFHistopedi.RadioButton33Click(Sender: TObject);
begin
  TIPOPEDIDO:='F'; NOMBREPEDIDO:='FACTURAS'; LETRAPEDIDO:='LAS';
  if RadioButton1.Checked=true then RadioButton1Click(RadioButton1);
  if RadioButton2.Checked=true then BitBtn3Click(BitBtn3);
  if RadioButton3.Checked=true then BitBtn4Click(BitBtn4);
end;

//============== TODOS LOS PEDIDOS POR FECHAS =====================
procedure TFHistopedi.RadioButton1Click(Sender: TObject);
begin
  Panel2.Visible:=False; Panel3.Visible:=False;
  dbPedic.Active:=False;
  dbPedic.SQL.Text:='SELECT * FROM hipedicc'+Tienda;
  if TIPOPEDIDO<>'' then dbPedic.SQL.Text:=dbPedic.SQL.Text+' WHERE HPC28="'+TIPOPEDIDO+'"';
  dbPedic.SQL.Text:=dbPedic.SQL.Text+' ORDER BY HPC0 ASC, HPC1 DESC, HPC2 ASC, HPC3 ASC, HPC4 DESC';
  dbPedic.Active:=True; DBGrid1.Enabled:=True;
  FOrdenGridPrincipal:='HPC1'; FOrdenGridPrincipalDesc:=True;
  ActualizarFlechasGrid(DBGrid1,FOrdenGridPrincipal,FOrdenGridPrincipalDesc);
  StaticText5.Caption:='TODOS '+LETRAPEDIDO+' '+NOMBREPEDIDO+' ORDENADOS POR FECHAS';
end;

//============== PEDIDOS DE UN PROVEEDOR ========================
procedure TFHistopedi.RadioButton2Click(Sender: TObject);
begin
  Panel2.Visible:=True; Panel3.Visible:=False; Edit1.SetFocus;
  DBGrid1.Enabled:=False; Edit1.SetFocus;
end;

procedure TFHistopedi.BitBtn3Click(Sender: TObject);
begin
  If Edit1.Text='' then Exit;
  dbPedic.Sql.Text:='SELECT * FROM hipedicc'+Tienda+' WHERE HPC2='+Edit1.Text;
  if TIPOPEDIDO<>'' then dbPedic.SQL.Text:=dbPedic.SQL.Text+' AND HPC28="'+TIPOPEDIDO+'"';
  dbPedic.SQL.Text:=dbPedic.SQL.Text+' ORDER BY HPC0 ASC, HPC1 DESC, HPC2 ASC, HPC3 ASC, HPC4 DESC';
  dbPedic.Active := True;
  FOrdenGridPrincipal:='HPC1'; FOrdenGridPrincipalDesc:=True;
  ActualizarFlechasGrid(DBGrid1,FOrdenGridPrincipal,FOrdenGridPrincipalDesc);
  StaticText5.Caption:=NOMBREPEDIDO+' DEL PROVEEDOR: '+Edit1.Text+' '+Edit2.Text;
  If dbPedic.RecordCount=0 then
    begin
      //Showmessage('NO HAY PEDIDOS DE ESTE PROVEEDOR');
      Panel2.Visible:=False; exit;
    end;
  Panel2.Visible:=False;  DBGrid1.Enabled:=True;
end;

//=================== CGO PROVEEDOR FILTRADO =======================
procedure TFHistopedi.Edit1Enter(Sender: TObject);
begin
   Edit2.Text:='';
end;
procedure TFHistopedi.Edit1Exit(Sender: TObject);
begin
   If Edit1.Text='' then Exit;
   dbProve.SQL.Text:='SELECT * FROM proveedores WHERE P0='+Edit1.Text;
   dbProve.Active:=True;
   If dbProve.RecordCount=0 then Begin Showmessage('ESE PROVEEDOR NO EXISTE.'); Edit2.SetFocus; Exit; End;
   Edit2.Text:=dbProve.FieldByName('P1').AsString;
end;
//---------------- Buscar por nombre
procedure TFHistopedi.BitBtn7Click(Sender: TObject);
begin
  if Edit2.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit2.SetFocus; Exit; end;
  Edit1.Text := FBusquedas.IniciaBusquedas('SELECT P0, P1, P2 FROM proveedores WHERE P1 LIKE "'+Edit2.Text+'%"',
           ['Codigo', ' Razón social ', ' Dirección ' ], 'P0' );

  if Edit1.Text<>'' then begin Edit1Exit(Edit1); end;
end;
procedure TFHistopedi.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then BitBtn7Click(BitBtn7);
end;

//============== PEDIDOS ENTRE FECHAS ========================
procedure TFHistopedi.RadioButton3Click(Sender: TObject);
begin
  Panel3.Visible:=True; Panel2.Visible:=False;
  DateEdit1.Date:=Date; DateEdit2.Date:=Date;
  DBGrid1.Enabled:=False; DateEdit1.SetFocus;
end;
procedure TFHistopedi.BitBtn4Click(Sender: TObject);
begin
  If (DateEdit1.Date>DateEdit2.Date) then begin showmessage('LA PRIMERA FECHA ES MAYOR QUE LA SEGUNDA'); exit; end;
  dbPedic.Sql.Text:='SELECT * FROM hipedicc'+Tienda+' WHERE HPC1>="'+
                    FormatDateTime('YYYY/MM/DD',DateEdit1.Date)+'" AND HPC1<="'+
                    FormatDateTime('YYYY/MM/DD',DateEdit2.Date)+'"';
  if TIPOPEDIDO<>'' then dbPedic.SQL.Text:=dbPedic.SQL.Text+' AND HPC28="'+TIPOPEDIDO+'"';
  dbPedic.SQL.Text:=dbPedic.SQL.Text+' ORDER BY HPC0 ASC, HPC1 DESC, HPC2 ASC, HPC3 ASC, HPC4 DESC';
  dbPedic.Active := True;
  FOrdenGridPrincipal:='HPC1'; FOrdenGridPrincipalDesc:=True;
  ActualizarFlechasGrid(DBGrid1,FOrdenGridPrincipal,FOrdenGridPrincipalDesc);
  StaticText5.Caption:=NOMBREPEDIDO+'PEDIDOS DESDE: '+DateEdit1.Text+' HASTA: '+DateEdit2.Text;
  If dbPedic.RecordCount=0 then
    begin
      //Showmessage('NO HAY PEDIDOS ENTRE ESAS FECHAS');
      Panel3.Visible:=False; DBGrid1.Enabled:=True; exit;
    end;
  Panel3.Visible:=False; DBGrid1.Enabled:=True;
end;

//============= MOSTRAR DATOS DEL PEDIDO AL MOVERSE POR EL GRID ========
procedure TFHistopedi.Datasource1DataChange(Sender: TObject; Field: TField);
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
procedure TFHistopedi.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if gdSelected in State then
    DBGrid1.Canvas.Font.Color:=clWhite
  else if dbPedic.FieldByName('HPC15').AsString<>'' then
    DBGrid1.Canvas.Font.Color:=RGBToColor(37,99,235)
  else
    DBGrid1.Canvas.Font.Color:=RGBToColor(30,41,59);
  DBGrid1.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;



//=================================================================
//====================== RECUPERAR PEDIDO =========================
//=================================================================
procedure TFHistopedi.BitBtn9Click(Sender: TObject);
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
  dbPedid.SQL.Text:='SELECT * FROM hipedidd'+Tienda+' WHERE HPD0='+dbPedic.FieldByName('HPC0').AsString+
                     ' AND HPD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('HPC1').AsDateTime)+'"'+
                     ' AND HPD2='+dbPedic.FieldByName('HPC2').AsString+
                     ' AND HPD3="'+dbPedic.FieldByName('HPC3').AsString+'"'+
                     ' AND HPD4='+dbPedic.FieldByName('HPC4').AsString;
  dbPedid.Active:=True;
  FOrdenGridLineas:='';
  FOrdenGridLineasDesc:=False;
  ActualizarFlechasGrid(DBGrid2,FOrdenGridLineas,FOrdenGridLineasDesc);
  //----------------------------
  dbTiendas.Active:=False; BitBtn23.BringToFront;
  Panel8.Visible:=True;
  Panel1.Enabled:=False; DBGrid1.Enabled:=False;
  Edit23.SetFocus;
end;

//--------------- Moverse por la series del pedido ---------------------
procedure TFHistopedi.Datasource3DataChange(Sender: TObject; Field: TField);
begin
  Edit21.Text:=IntToStr(dbSeries.FieldByName('SF7').AsInteger+1);//--- Cambiar el N.Pedido
end;


//--------------- Aceptar nuevo pedido -----------------
procedure TFHistopedi.BitBtn19Click(Sender: TObject);
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
procedure TFHistopedi.BitBtn20Click(Sender: TObject);
begin
  Panel8.Visible:=False;
  Panel1.Enabled:=True; DBGrid1.Enabled:=True;
end;

//---------------- Codigo Proveedor -----------------
procedure TFHistopedi.Edit23Enter(Sender: TObject);
begin
  Edit25.Text:='';
end;
procedure TFHistopedi.Edit23Exit(Sender: TObject);
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
procedure TFHistopedi.Edit25KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then BitBtn40Click(BitBtn40);
end;
procedure TFHistopedi.BitBtn40Click(Sender: TObject);
begin
  if Edit25.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit25.SetFocus; Exit; end;
  Edit23.Text := FBusquedas.IniciaBusquedas('SELECT P0, P1, P2 FROM proveedores WHERE P1 LIKE "'+Edit25.Text+'%"',
           ['Codigo', ' Razón social ', ' Dirección ' ], 'P0' );
  if Edit23.Text<>'' then begin Edit23Exit(Edit23); end;
end;

//------------------- Historico de pedidos cabeceras
procedure TFHistopedi.ActuHistocc();
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
procedure TFHistopedi.ActuHistodd();
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
procedure TFHistopedi.BitBtn10Click(Sender: TObject);
begin
  If dbPedic.RecordCount=0 then Begin Showmessage('NO HAY NINGUN FACTURA PARA BORRAR'); Exit; End;
  dbProve.SQL.Text:='SELECT * FROM proveedores WHERE P0='+dbPedic.FieldByName('HPC2').AsString;
  dbProve.Active:=True;
  If dbProve.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL PROVEEDOR '+dbPedic.FieldByName('HPC0').AsString+' ?'); Exit; End;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('CONFIRME EL BORRADO DEL PEDIDO?','FacturLinEx', boxstyle) = IDNO Then Exit;
  //-------- Restar unidades pendientes de la ficha del articulo ---------
  dbPedid.SQL.Text:='SELECT * FROM hipedidd'+Tienda+' WHERE HPD0='+dbPedic.FieldByName('HPC0').AsString+
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
  dbTrabajo.SQL.Text:='DELETE FROM hipedidd'+Tienda+' WHERE HPD0='+dbPedic.FieldByName('HPC0').AsString+
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
procedure TFHistopedi.BitBtn1Click(Sender: TObject);
begin
  If dbPedic.RecordCount=0 then Begin Showmessage('NO HAY NINGUN PEDIDO PARA GESTIONAR'); Exit; End;
  dbProve.SQL.Text:='SELECT * FROM proveedores WHERE P0='+dbPedic.FieldByName('HPC2').AsString;
  dbProve.Active:=True;
  If dbProve.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL PROVEEDOR '+dbPedic.FieldByName('HPC2').AsString+' ?'); Exit; End;
  Panel4.BringToFront; Panel4.Visible:=True;
  DBGrid2.BringToFront; DBGrid2.Visible:=True;
  MostrarBotonesdd();
  LimpiaProveedor();
  dbPedid.SQL.Text:='SELECT * FROM hipedidd'+Tienda+' WHERE HPD0='+dbPedic.FieldByName('HPC0').AsString+
                     ' AND HPD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('HPC1').AsDateTime)+'"'+
                     ' AND HPD2='+dbPedic.FieldByName('HPC2').AsString+
                     ' AND HPD3="'+dbPedic.FieldByName('HPC3').AsString+'"'+
                     ' AND HPD4='+dbPedic.FieldByName('HPC4').AsString;
  dbPedid.Active:=True;
  FOrdenGridLineas:='';
  FOrdenGridLineasDesc:=False;
  ActualizarFlechasGrid(DBGrid2,FOrdenGridLineas,FOrdenGridLineasDesc);
  PintaProveedor();
  Label48.Caption:=dbPedic.FieldByName('HPC3').AsString;//---- Serie
  Label31.Caption:=dbPedic.FieldByName('HPC4').AsString;//---- N. Pedido
  Label33.Caption:=dbPedic.FieldByName('HPC1').AsString;//---- Fecha Pedido
  LabelTotal.Caption:=FormatFloat('###,###,##0.00',dbPedic.FieldByName('HPC8').AsFloat);
end;

//---------------- PINTAR LINEAS RECIBIDAS EN ROJO ----------------
procedure TFHistopedi.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if gdSelected in State then
    DBGrid2.Canvas.Font.Color:=clWhite
  else if dbPedid.FieldByName('HPD23').AsString='N' then
    DBGrid2.Canvas.Font.Color:=RGBToColor(220,38,38)
  else
    DBGrid2.Canvas.Font.Color:=RGBToColor(30,41,59);
  DBGrid2.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

//===================== MARCAR DESMARCAR LINEAS ============================
procedure TFHistopedi.MenuItem3Click(Sender: TObject);
var
  Marca: String;
begin
  Marca:='S';
  if dbPedic.FieldByName('HPC46').AsString='S' then Marca:='N';
  dbPedic.Edit; dbPedic.FieldByName('HPC46').AsString:=Marca; dbPedic.Post;
end;

//======================== DATOS DOCUMENTO PROVEEDOR =======================
procedure TFHistopedi.MenuItem2Click(Sender: TObject);
begin
  Panel16.Visible:=True;
  Edit35.Text:=''; DateEdit11.Clear;
  if (dbPedic.FieldByName('HPC28').AsString='P') or (dbPedic.FieldByName('HPC28').AsString='') then
      RadioButton34.Checked:=True;//- Pedido
  if dbPedic.FieldByName('HPC28').AsString='N' then RadioButton27.Checked:=True;//- Nota
  if dbPedic.FieldByName('HPC28').AsString='A' then RadioButton17.Checked:=True;//- Albaran
  if dbPedic.FieldByName('HPC28').AsString='F' then RadioButton18.Checked:=True;//- Factura del proveedor

  Edit35.Text:=dbPedic.FieldByName('HPC29').AsString;//------------- Numero Documento Proveedor
  if dbPedic.FieldByName('HPC30').AsString<>'' then
     DateEdit11.Date:=dbPedic.FieldByName('HPC30').AsDateTime;//---- Fecha Documento Proveedor

end;

//-------------- Salir doc. proveedor ---------
procedure TFHistopedi.BitBtn38Click(Sender: TObject);
begin
  Panel16.Visible:=False;
end;
//-------------- Modificar doc. proveedor ---------
procedure TFHistopedi.BitBtn39Click(Sender: TObject);
begin
  If Application.MessageBox('MODIFICAR LOS DATOS DEL DOCUMENTO DEL PROVEEDOR?','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbPedic.Edit;
  //------- Albaran o Factura
  if RadioButton34.Checked=True then dbPedic.FieldByName('HPC28').AsString:='P';
  if RadioButton27.Checked=True then dbPedic.FieldByName('HPC28').AsString:='N';
  if RadioButton17.Checked=True then dbPedic.FieldByName('HPC28').AsString:='A';
  if RadioButton18.Checked=True then dbPedic.FieldByName('HPC28').AsString:='F';
  dbPedic.FieldByName('HPC29').AsString:=Edit35.Text;//---------- N. Documento Proveedor
  dbPedic.FieldByName('HPC30').AsDateTime:=DateEdit11.Date;//---- Fecha Documento Proveedor
  dbPedic.Post;
  BitBtn38Click(BitBtn38);
end;


//==================== LLENAR DATOS CABECERAS =======================
procedure TFHistopedi.Llenacc();
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
procedure TFHistopedi.Llenadd();
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
procedure TFHistopedi.BitBtn23Click(Sender: TObject);
begin
  Panel9.Visible:=True; Panel9.BringToFront;
  DateEdit7.Date:=StrToDate('01'+FormatDateTime('/MM/YYYY',Date));
  DateEdit8.Date:=Date; Edit14.SetFocus;
end;

//-------------- Primer proveedor -----------------
procedure TFHistopedi.Edit14Enter(Sender: TObject);
begin
   Edit15.Text:='';
end;
procedure TFHistopedi.Edit14Exit(Sender: TObject);
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
procedure TFHistopedi.Edit16Enter(Sender: TObject);
begin
   Edit17.Text:='';
end;
procedure TFHistopedi.Edit16Exit(Sender: TObject);
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
procedure TFHistopedi.BitBtn21Click(Sender: TObject);
begin
  If (Edit14.Text='') or (Edit16.Text='') then Exit;
  dbBusca.Sql.Text:='SELECT *,P1 FROM hipedicc'+Tienda+', proveedores WHERE HPC2=P0'+
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
  //frReport1.DesignReport;
end;

//--------------- Cerrar listado de pedidos -------------------
procedure TFHistopedi.BitBtn22Click(Sender: TObject);
begin
  Panel9.Visible:=False; Panel9.SendToBack;
end;

//================================================================
//======================= OBSERVACIONES ==========================
//================================================================
procedure TFHistopedi.BitBtn16Click(Sender: TObject);
begin
  Panel7.Visible:=True;
  Memo1.Lines.Text:=dbPedic.FieldByName('HPC31').AsString;
  Memo1.SetFocus;
end;
//--------------- Aceptar Observaciones --------
procedure TFHistopedi.BitBtn18Click(Sender: TObject);
begin
  dbPedic.Edit;
  dbPedic.FieldByName('HPC31').AsString:=Memo1.Lines.Text;
  dbPedic.Post;
  Panel7.Visible:=False;
end;

//--------------- Cancelar Observaciones --------
procedure TFHistopedi.BitBtn17Click(Sender: TObject);
begin
  Panel7.Visible:=False;
end;


//=======================================================================
//========================= VENCIMIENTOS ================================
//=======================================================================
procedure TFHistopedi.BitBtn26Click(Sender: TObject);
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
procedure TFHistopedi.Edit24Exit(Sender: TObject);
begin
  if Edit24.Text='' then Edit24.Text:='0.00';
  PintarTotalVencimientos();
end;

//----------------- Importe 2 ------------
procedure TFHistopedi.Edit26Exit(Sender: TObject);
begin
  if Edit26.Text='' then Edit26.Text:='0.00';
  PintarTotalVencimientos();
end;

//----------------- Importe 3 ------------
procedure TFHistopedi.Edit28Exit(Sender: TObject);
begin
  if Edit28.Text='' then Edit28.Text:='0.00';
  PintarTotalVencimientos();
end;

//----------------- Importe 4 ------------
procedure TFHistopedi.Edit30Exit(Sender: TObject);
begin
  if Edit30.Text='' then Edit30.Text:='0.00';
  PintarTotalVencimientos();
end;

//---------------- Totales vencimientos ------------
procedure TFHistopedi.PintarTotalVencimientos();
begin
  //------------ Suma de vencimientos
  Label46.Caption:=FormatFloat('0.00',StrToFloat(Edit24.Text)+StrToFloat(Edit26.Text)+
                                   StrToFloat(Edit28.Text)+
                                   StrToFloat(Edit30.Text));
  //------ Total Pedido costo+impuestos-suma de vencimientos
  Label47.Caption:=FormatFloat('0.00',dbPedic.FieldByName('HPC8').AsFloat-StrToFloat(Label46.Caption));
end;

//========================= SALIR DE VENCIMIENTOS ======================
procedure TFHistopedi.BitBtn29Click(Sender: TObject);
begin
  Panel11.Visible:=False;
end;

//======================= ACEPTAR DE VENCIMIENTOS ======================
procedure TFHistopedi.BitBtn30Click(Sender: TObject);
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
procedure TFHistopedi.BitBtn5Click(Sender: TObject);
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
  dbTrabajo.SQL.Text:='SELECT COUNT(*), SUM(HPD8), SUM(HPD8*HPD10), SUM(HPD17), SUM(HPD18) FROM hipedidd'+Tienda+' WHERE'+
                     ' HPD0='+dbPedic.FieldByName('HPC0').AsString+
                     ' AND HPD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('HPC1').AsDateTime)+'"'+
                     ' AND HPD2='+dbPedic.FieldByName('HPC2').AsString+
                     ' AND HPD3="'+dbPedic.FieldByName('HPC3').AsString+'"'+
                     ' AND HPD4='+dbPedic.FieldByName('HPC4').AsString;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then exit;
  TxtQ:='UPDATE hipedicc'+Tienda+' SET HPC5='+dbTrabajo.Fields[0].AsString+', HPC6='+dbTrabajo.Fields[1].AsString+
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
procedure TFHistopedi.PintarTotalGeneral();
begin
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT SUM(HPD17) FROM hipedidd'+Tienda+' WHERE'+
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
procedure TFHistopedi.MostrarBotonesdd();
begin
  BitBtn5.Visible:=True; BitBtn15.Visible:=True;
  //-------------- cc
  BitBtn1.Visible:=False; BitBtn9.Visible:=False;
  BitBtn10.Visible:=False; BitBtn16.Visible:=False;
  BitBtn2.Visible:=False; BitBtn23.Visible:=False;
  BitBtn26.Visible:=False;
end;

//====================== OCULTAR BOTONES DD ====================
procedure TFHistopedi.OcultarBotonesdd();
begin
  BitBtn5.Visible:=False; BitBtn15.Visible:=False;
  //-------------- cc
  BitBtn1.Visible:=True; BitBtn9.Visible:=True;
  BitBtn10.Visible:=True; BitBtn16.Visible:=True;
  BitBtn2.Visible:=True; BitBtn23.Visible:=True;
  BitBtn26.Visible:=True;
end;

//==================== PINTAR DATOS DE CLIENTES ======================
procedure TFHistopedi.PintaProveedor();
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
procedure TFHistopedi.LimpiaProveedor();
begin
  Label4.Caption:=''; Label5.Caption:=''; Label6.Caption:='';
  Label7.Caption:=''; Label8.Caption:=''; Label9.Caption:='';
  Label10.Caption:=''; LabelTotal.Caption:='0.00';
end;

//================= N. DE PEDIDO ===========================
procedure TFHistopedi.NumeroPedido();
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
procedure TFHistopedi.BitBtn15Click(Sender: TObject);
begin
  Panel13.Visible:=True;
end;
//----------------- ACEPTAR IMPRIMIR LISTADO --------------------
procedure TFHistopedi.BitBtn32Click(Sender: TObject);
begin
  Pdf:=0; ImprimirPedido();
end;
//----------------- ACEPTAR IMPRIMIR PDF --------------------
procedure TFHistopedi.BitBtn36Click(Sender: TObject);
begin
  Pdf:=1; ImprimirPedido();
end;

//----------------- CANCELAR IMPRIMIR --------------------
procedure TFHistopedi.BitBtn33Click(Sender: TObject);
begin
  Panel13.Visible:=False;
end;

//----------------- IMPRIMIR PEDIDO -----------------------
procedure TFHistopedi.ImprimirPedido();
var
  TxtQ: String;
begin
  //---- Consulta para el listado
  TxtQ:='SELECT * FROM hipedidd'+Tienda+' WHERE HPD0='+dbPedic.FieldByName('HPC0').AsString+
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
        'FROM hipedidd'+Tienda+
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
         frReport1.ExportTo(TFrTNPDFExportFilter, RutaPdf+'/Pedido.pdf');
         AProcess := TProcess.Create(nil);
         AProcess.CommandLine := VisorPdf+' '+RutaPdf+'/Pedido.pdf';
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
procedure TFHistopedi.VerRecargo();
begin
   RECARGO:=RIVA1;
   if dbTrabajo.Fields[0].AsFloat=IVA1 then RECARGO:=RIVA1;
   if dbTrabajo.Fields[0].AsFloat=IVA2 then RECARGO:=RIVA2;
   if dbTrabajo.Fields[0].AsFloat=IVA3 then RECARGO:=RIVA3;
end;

//================= PASAR PARAMETROS AL REPORT ===============
procedure TFHistopedi.frReport1GetValue(const ParName: String;
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
procedure TFHistopedi.frReport1EnterRect(Memo: TStringList; View: TfrView);
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
procedure TFHistopedi.RadioButton19Change(Sender: TObject);
begin
   if RadioButton19.Checked=True then Panel17.Enabled:=True else Panel17.Enabled:=False;
end;

//--------- Cantidad de etiquetas manual ------
procedure TFHistopedi.RadioButton25Change(Sender: TObject);
begin
   if RadioButton25.Checked=True then Edit36.Visible:=True else Edit36.Visible:=False;
end;

//-------------- Grabar etiquetas en file txt ----------------
procedure TFHistopedi.EtiquetasBarras();
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


//-------------------- Ver Destino de La trasmisión ------------------------
procedure TFHistopedi.MenuItem1Click(Sender: TObject);
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
procedure TFHistopedi.Panel15Click(Sender: TObject);
begin
  Panel15.Visible:=False;
end;

//================== UNIDADES PENDIENTES EN PEDIDOS ================
procedure TFHistopedi.SumaPendientes(CodiPen, UniPen: String);
begin
  dbTrabajo.SQL.Text:='UPDATE artitien'+Tienda+' SET A11=A11+'+UniPen+
                      ' WHERE A0="'+CodiPen+'"';
  dbTrabajo.ExecSQL;
  dbTrabajo.SQL.Text:='UPDATE artitien'+Tienda+' SET A4=A4+'+UniPen+
                      ' WHERE A0="'+CodiPen+'"';
  dbTrabajo.ExecSQL;
end;


initialization
  {$I histopedi.lrs}

end.
