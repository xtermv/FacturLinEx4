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
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit Presupuestos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ZConnection, ZDataset, DBGrids, db, StdCtrls, DbCtrls, LR_Class,
  LR_DBSet, LCLType, Menus, Grids;

type

{ TFPresupuesto }

TFPresupuesto = class(TForm)
  Bevel1: TBevel;
  Bevel2: TBevel;
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
  BitBtn3: TBitBtn;
  BitBtn34: TBitBtn;
  BitBtn4: TBitBtn;
  BitBtn5: TBitBtn;
  BitBtn6: TBitBtn;
  BitBtn7: TBitBtn;
  BitBtn8: TBitBtn;
  BitBtn9: TBitBtn;
  Button1: TButton;
  cbHistoricos: TComboBox;
  CheckBox1: TCheckBox;
  CheckBox2: TCheckBox;
  CheckBox4: TCheckBox;
  ComboBox1: TComboBox;
  Datasource1: TDatasource;
  Datasource2: TDatasource;
  Datasource3: TDatasource;
  DBGrid2: TDBGrid;
  dbHisopcc: TZQuery;
  dbHisopdd: TZQuery;
  dbTarifas: TZQuery;
  dbTiendas: TZQuery;
  dbBusca: TZQuery;
  dbTrabajo: TZQuery;
  dbSeries: TZQuery;
  dbLista: TZQuery;
  dbDocuc: TZQuery;
  dbDocud: TZQuery;
  dbClientes: TZQuery;
  dbArti: TZQuery;
  DBGrid1: TDBGrid;
  dbMuestrad: TZQuery;
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
  Edit21: TEdit;
  Edit22: TEdit;
  Edit23: TEdit;
  Edit26: TEdit;
  Edit27: TEdit;
  Edit28: TEdit;
  Edit29: TEdit;
  Edit3: TEdit;
  Edit4: TEdit;
  Edit5: TEdit;
  Edit6: TEdit;
  Edit7: TEdit;
  Edit8: TEdit;
  Edit9: TEdit;
  frDBDataSet1: TfrDBDataSet;
  frReport1: TfrReport;
  GroupBox1: TGroupBox;
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
  Label33: TLabel;
  Label34: TLabel;
  Label35: TLabel;
  Label36: TLabel;
  Label41: TLabel;
  Label42: TLabel;
  Label43: TLabel;
  Label44: TLabel;
  Label45: TLabel;
  LabelTotal: TLabel;
  Label2: TLabel;
  Label3: TLabel;
  Label4: TLabel;
  Label5: TLabel;
  Label6: TLabel;
  Label7: TLabel;
  Label8: TLabel;
  Label9: TLabel;
  lbActivarPrecios: TLabel;
  lbHistoricos: TLabel;
  ListBox1: TListBox;
  ListBox2: TListBox;
  ListBox3: TListBox;
  Memo1: TMemo;
  MenuItem1: TMenuItem;
  MenuItem2: TMenuItem;
  MenuItem3: TMenuItem;
  MenuItem4: TMenuItem;
  MenuItem5: TMenuItem;
  Panel1: TPanel;
  dbMuestrac: TZQuery;
  Panel11: TPanel;
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
  RadioButton2: TRadioButton;
  RadioButton3: TRadioButton;
  RadioButton4: TRadioButton;
  RadioButton5: TRadioButton;
  RadioButton6: TRadioButton;
  RadioGroup2: TRadioGroup;
  StaticText1: TStaticText;
  procedure BitBtn10Click(Sender: TObject);
  procedure BitBtn11Click(Sender: TObject);
  procedure BitBtn12Click(Sender: TObject);
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
  procedure BitBtn2Click(Sender: TObject);
  procedure BitBtn3Click(Sender: TObject);
  procedure BitBtn4Click(Sender: TObject);
  procedure BitBtn5Click(Sender: TObject);
  procedure BitBtn6Click(Sender: TObject);
  procedure BitBtn7Click(Sender: TObject);
  procedure BitBtn8Click(Sender: TObject);
  procedure BitBtn9Click(Sender: TObject);
  procedure Button1Click(Sender: TObject);
  procedure ComboBox1Change(Sender: TObject);
  procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
    DataCol: Integer; Column: TColumn; State: TGridDrawState);
  procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
  procedure DBGrid1TitleClick(Column: TColumn);
  procedure DBGrid2DblClick(Sender: TObject);
  procedure DBGrid2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure Edit10Enter(Sender: TObject);
  procedure Edit10Exit(Sender: TObject);
  procedure Edit12Enter(Sender: TObject);
  procedure Edit12Exit(Sender: TObject);
  procedure Edit14Enter(Sender: TObject);
  procedure Edit14Exit(Sender: TObject);
  procedure Edit16Enter(Sender: TObject);
  procedure Edit16Exit(Sender: TObject);
  procedure Edit1Enter(Sender: TObject);
  procedure Edit1Exit(Sender: TObject);
  procedure Edit23Exit(Sender: TObject);
  procedure Edit2Exit(Sender: TObject);
  procedure Edit2KeyPress(Sender: TObject; var Key: char);
  procedure Edit5Exit(Sender: TObject);
  procedure Edit6DblClick(Sender: TObject);
  procedure Edit6KeyPress(Sender: TObject; var Key: char);
  procedure Edit7Enter(Sender: TObject);
  procedure Edit7Exit(Sender: TObject);
  procedure Edit7KeyPress(Sender: TObject; var Key: char);
  procedure Edit8Enter(Sender: TObject);
  procedure Edit8Exit(Sender: TObject);
  procedure Edit9Enter(Sender: TObject);
  procedure Edit9DblClick(Sender: TObject);
  procedure Edit9Exit(Sender: TObject);
  procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  procedure FormCreate(Sender: TObject);
  procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure FormShow(Sender: TObject);
  procedure ListBox1Click(Sender: TObject);
  procedure ListBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure ListBox2DblClick(Sender: TObject);
  procedure ListBox2KeyPress(Sender: TObject; var Key: char);
  procedure ListBox3DblClick(Sender: TObject);
  procedure ListBox3Exit(Sender: TObject);
  procedure ListBox3KeyPress(Sender: TObject; var Key: char);
  procedure MenuItem1Click(Sender: TObject);
  procedure MenuItem2Click(Sender: TObject);
  procedure MenuItem3Click(Sender: TObject);
  procedure MenuItem4Click(Sender: TObject);
  procedure MenuItem5Click(Sender: TObject);
  procedure RadioButton1Click(Sender: TObject);
  procedure RadioButton2Click(Sender: TObject);
  procedure RadioButton3Click(Sender: TObject);
   procedure PintaCliente();
  procedure LimpiaCliente();
  procedure Llenadd();
  procedure Limpiadd();
  procedure Pintadd();
  procedure MostrarBotonesdd();
  procedure OcultarBotonesdd();
  procedure NumeroPresupuesto();
  procedure RadioButton4Click(Sender: TObject);
  procedure RadioButton5Click(Sender: TObject);
  procedure RadioButton6Click(Sender: TObject);
  procedure RadioGroup2Click(Sender: TObject);
  procedure BuscaArticulo();
  procedure ActualizaImporte();
  procedure CargaTarifas(actualiza: integer);
  procedure MuestraTarifas();
  function VerUltimaLinea: Integer;
  procedure CargaSeries();
  procedure ActuHisopcc(Modo: integer);
  procedure ActuHisopdd();
  procedure ActuHistoclie(Modo: integer);
  procedure HistCliente(Sender: TObject);
  procedure CargaValores();
  procedure CargaVariables();
  procedure ActivaPrecios();
  procedure EntraEnEdit(Sender: TObject);
  //-- Creación del procedimiento en 3 partes - parte 1 - definicion
  procedure GridSelectionLight(Sender: TObject; const Rect: TRect;
         DataCol: Integer; Column: TColumn; State: TGridDrawState);


  private
    { private declarations }
  public
    { public declarations }
  end;

  procedure ShowFormPresupuestos(TipoDocumento: string);
  
var
  FPresupuesto: TFPresupuesto;
  SPresupuesto: String;
  NPresupuesto: Integer;

  Tabla: integer;
  Filtro: String;
  Filtro1Txt: string=' Listado de todos los documentos';
  TablaCabecera: array [1..2] of string= ('proforc', 'presuc');
  TablaDetalle: array [1..2] of string= ('proford', 'presud');
  Documento: array [1..2] of string= ('PROFORMA', 'PRESUPUESTO');
  ListaImpreso: array [1..4] of string;
  Impreso: array [1..4] of string;

  lMarcado: integer;  // 0 = todos, 1 = no marcado, 2=marcado

  hora: TDateTime;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

  ValorInicial: String;   // Valor de entrada de un edit para controlar si cambió al salir.

  EstadoImpresion: integer;

implementation

uses
  Global, Funciones, Busquedas, Imprimir, calculos;
  
 { TFPresupuesto }
//=============== Crea el formulario ================
procedure ShowFormPresupuestos(TipoDocumento: string);
begin
  ListaImpreso[1]:='/usr/share/facturlinex2/Report/ListaProformas.lrf';
  ListaImpreso[2]:='/usr/share/facturlinex2/Report/ListaPresupuestos.lrf';
  ListaImpreso[3]:=RutaReports+'ListaProformas.lrf';
  ListaImpreso[4]:=RutaReports+'ListaPresupuestos.lrf';
  Tabla:=2;
  if TipoDocumento='PROFORMA' then Tabla:=1;
  with TFPresupuesto.Create(Application) do
    begin
       ShowModal;
    end;
end;

//=================== CONTROL DE COLOR LINEA SELECCIONADA ===========
//-- Creación del procedimiento en 3 partes - parte 2 - procedimiento
procedure TFPresupuesto.GridSelectionLight(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  G: TDBGrid;
begin
  G := TDBGrid(Sender);

  // Solo cambiamos la fila seleccionada
  if (gdSelected in State) then
  begin
    G.Canvas.Brush.Color := clInfoBK;
    G.Canvas.Font.Color := clBlack;
    G.Canvas.FillRect(Rect);
    G.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end
  else
  begin
    // Para el resto, dejamos el comportamiento normal (tema/colores por defecto)
    G.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

//======================= CREAR FORMULARIO ==========================
procedure TFPresupuesto.FormCreate(Sender: TObject);
Var
  i: Integer;
begin
  ShortDateFormat:='DD/MM/YYYY';

  //-- Cambiamos el color por defecto de la linea seleccionada
  //-- Creación del procedimiento en 3 partes - parte 3 - Todos los DBGrid del Form en estas 3 líneas
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TDBGrid then
      TDBGrid(Components[i]).OnDrawColumnCell := @GridSelectionLight;

  // Conectate(dbConect);            // Utilizamos datamodule1.dbConexion para toda la aplicación.

  //------------------- Tablas ------------------
  //-- MID(PRC11,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(PRC11 USING UTF8) as PRNOTAS,C1 FROM '+TablaCabecera[Tabla]+Tienda+', clientes WHERE PRC0=C0 ORDER BY PRC2 ASC, PRC1 DESC, PRC3 DESC';
  dbMuestrac.Active := True;
  Panel4.SendToBack; Panel4.Visible:=False;
  DBGrid2.SendToBack; DBGrid2.Visible:=False;
  //------------- Chequear ivas
  if IVA1=0 then showmessage('DEBE DEFINIR LOS TIPOS DE IVA EN LA CONFIGURACION');
  //------------ Configuro etiquetas presupuestos/proformas ------
  self.Caption:= Documento[Tabla] + ' de clientes ';
  label29.Caption:= Documento[Tabla];
  label25.Caption:= 'LISTADO DE '+Documento[Tabla];
  label26.Caption:='N.'+Documento[Tabla];
  label27.Caption:='Fecha '+Documento[Tabla];
  label29.Caption:=Documento[Tabla];
  label32.Caption:='FECHA '+Documento[Tabla];
  Filtro:='';
  if Tabla=1 then GroupBox1.Caption:=' Proformas  ' else GroupBox1.Caption:=' Presupuestos  ';
  StaticText1.Caption:= Filtro1Txt+' ordenados por fechas';
  //-------------------- Tiendas
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin Showmessage('NO SE EN QUE TIENDA HACER EL ALBARAN'); Close(); end;
  //------------- Cargar Series
  CargaSeries();//----- Cargar Series de facturacion
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); Close(); end;

  //------------- Sólo documentos de la serie activa
  ComboBox1.Text:=Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                         dbSeries.FieldByName('SF1').AsString;
  ComboBox1Change(self);

  AntColun:='0';Ordenado:=False; Orden:='DESC';


end;

//=============  FILTRADO DE DOCUMENTOS A VER ===============

procedure TFPresupuesto.RadioButton4Click(Sender: TObject);
begin
  Filtro:='';
  Filtro1Txt:=' Listado de todos los documentos';
  if RadioButton1.Checked then RadioButton1Click(self);
  if RadioButton2.Checked then RadioButton2Click(self);
  if RadioButton3.Checked then RadioButton3Click(self);
end;

procedure TFPresupuesto.RadioButton5Click(Sender: TObject);
begin
  Filtro:=' AND PRC12<>"SV" AND PRC12<>"" ';
  Filtro1Txt:=' Documentos recuperados';
  if RadioButton1.Checked then RadioButton1Click(self);
  if RadioButton2.Checked then RadioButton2Click(self);
  if RadioButton3.Checked then RadioButton3Click(self);
end;

procedure TFPresupuesto.RadioButton6Click(Sender: TObject);
begin
  Filtro:=' AND (PRC12="SV" OR PRC12="") ';
  Filtro1Txt:=' Documentos pendientes de recuperar';
  if RadioButton1.Checked then RadioButton1Click(self);
  if RadioButton2.Checked then RadioButton2Click(self);
  if RadioButton3.Checked then RadioButton3Click(self);
end;

//============== TODO LOS PRESUPUESTOS =====================
procedure TFPresupuesto.RadioButton1Click(Sender: TObject);
begin
  Panel2.Visible:=False;
  Panel3.Visible:=False;
  //-- MID(PRC11,1,250)
  dbMuestrac.Sql.Text:='SELECT *, CONVERT(PRC11 USING UTF8) as PRNOTAS,C1 FROM '+TablaCabecera[Tabla]+Tienda+', clientes WHERE PRC0=C0 '+Filtro+'ORDER BY PRC2 ASC, PRC1 DESC, PRC3 DESC';
  dbMuestrac.Active := True;
  DBGrid1.SetFocus;
  StaticText1.Caption:= Filtro1Txt+' ordenados por fechas';
end;

//============== PESUPUESTOS DE UN CLIENTE ========================
procedure TFPresupuesto.RadioButton2Click(Sender: TObject);
begin
  Panel2.Visible:=True; Panel3.Visible:=False; Edit1.SetFocus;
  StaticText1.Caption:= Filtro1Txt+' de un cliente ordenados por fechas';
end;
procedure TFPresupuesto.BitBtn3Click(Sender: TObject);
begin
  If Edit1.Text='' then Exit;
  //-- MID(PRC11,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(PRC11 USING UTF8) as PRNOTAS,C1 FROM '+TablaCabecera[Tabla]+Tienda+', clientes WHERE PRC0=C0 AND PRC0='+Edit1.Text+ Filtro+ ' ORDER BY PRC2 ASC, PRC1 DESC, PRC3 DESC';
  dbMuestrac.Active := True;
  If dbMuestrac.RecordCount=0 then
    begin
      Showmessage('NO HAY '+Documento[Tabla]+' ES DE ESTE CLIENTE');
      exit;
    end;

end;
//=================== CGO CLIENTE FLITRADO =======================
procedure TFPresupuesto.Edit1Enter(Sender: TObject);
begin
   Edit2.Text:='';
end;
procedure TFPresupuesto.Edit1Exit(Sender: TObject);
begin
   if Edit1.Text='' then Exit;
   if not (EsFloat(Edit1.Text)) then begin Edit1.Text:='0'; Edit1.SetFocus; exit; end;
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit1.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then
                               Begin    // Showmessage('ESE CLIENTE NO EXISTE.');
                                 BitBtn7Click(self);
                                 Edit2.SetFocus; Exit;
                               End;
   Edit2.Text:=dbClientes.FieldByName('C1').AsString;

   BitBtn3Click(self);    // Sólo pre/pro del cliente.

//   Edit1.SetFocus;
end;

//--------------- Busca Cliente -----------------------
procedure TFPresupuesto.BitBtn7Click(Sender: TObject);
begin
   Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT C0,C1,C5 FROM clientes',['Código','Cliente','N.I.F.'],'C0');
   Edit2.SetFocus;
   Edit1Exit(self);
end;
//--------------- Buscar por nombre -----------------
procedure TFPresupuesto.Edit2Exit(Sender: TObject);
begin
  if Edit2.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit2.SetFocus; Exit; end;
  dbBusca.SQL.Text:='SELECT C0,C1 FROM clientes WHERE C1="'+Edit2.Text+'"'; dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then
                             begin
                               Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT C0,C1,C5 FROM clientes WHERE C1 LIKE "'+Edit2.Text+'%"',
                                                         ['Código', 'Cliente', 'N.I.F.'],'C0');
                               Edit1Exit(self);
                               Exit;
                              end;
  Edit1.Text:=dbBusca.FieldByName('C0').AsString;
  Edit1Exit(self);
end;
//---------------- Buscar por nombre ------------------
procedure TFPresupuesto.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then Edit2Exit(self);
  Exit;
end;

//============== PESUPUESTOS ENTRE FECHAS ========================
procedure TFPresupuesto.RadioButton3Click(Sender: TObject);
begin
  Panel3.Visible:=True;
  Panel2.Visible:=False;
  Edit3.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit4.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit3.SetFocus;
  StaticText1.Caption:= Filtro1Txt+' entre fechas y ordenados por fechas';
end;
procedure TFPresupuesto.BitBtn4Click(Sender: TObject);
begin
  If (Edit3.Text='') or (Edit4.Text='') then Exit;
  dbMuestrac.Sql.Text:='SELECT *,C1 FROM '+TablaCabecera[Tabla]+Tienda+', clientes WHERE PRC0=C0 AND PRC1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit3.Text))+'" AND PRC1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit4.Text))+ Filtro+'" ORDER BY PRC2 ASC, PRC1 DESC, PRC3 DESC';
  dbMuestrac.Active := True;
  If dbMuestrac.RecordCount=0 then
    begin
      Showmessage('NO HAY '+ Documento[Tabla] +' ENTRE ESAS FECHAS');
      exit;
    end;
end;

procedure TFPresupuesto.RadioGroup2Click(Sender: TObject);
var
  iniMuestrac, finMuestrac: string;
  txtMarcado: string;
  lCambio: integer;        //lCambio copia a lMarcado cuando entra en la función.
begin
 lCambio:= lMarcado;
  iniMuestrac:=dbMuestrac.SQL.Text; finMuestrac:=iniMuestrac;

  if (lMarcado<>0) then
    begin
       Delete(iniMuestrac, pos('ORDER', dbMuestrac.SQL.Text)-15 , length(dbMuestrac.SQL.Text));
       Delete(finMuestrac, 1, pos('ORDER',dbMuestrac.SQL.Text)-1  );
    end else
    begin
       Delete(iniMuestrac, pos('ORDER', dbMuestrac.SQL.Text)-1 , length(dbMuestrac.SQL.Text));
       Delete(finMuestrac, 1, pos('ORDER',dbMuestrac.SQL.Text)-1 );
    end;

  if (RadioGroup2.ItemIndex=0) and ( lMarcado <>0 ) then
    begin
       dbMuestrac.Active:= false;
       dbMuestrac.SQL.Text:= iniMuestrac +' '+ finMuestrac;
       dbMuestrac.Active:=true;
       lMarcado:=0;
       Exit;
    end;

  dbMuestrac.Active:=false;
  if (RadioGroup2.ItemIndex=1) and (lMarcado<>1) then begin txtMarcado:='S'; lMarcado:=1; end;
  if (RadioGroup2.ItemIndex=2) and (lMarcado<>2) then begin txtMarcado:='N'; lMarcado:=2; end;
  if (lMarcado<>lCambio) then dbMuestrac.SQL.Text:= iniMuestrac + ' AND PRC10="'+txtMarcado+'" ' + finMuestrac;
  dbMuestrac.Active:= true;
end;

//================ ORDENAR EL GRID ==================
procedure TFPresupuesto.DBGrid1TitleClick(Column: TColumn);
begin
 Colorea(Column,DBGrid1,dbMuestrac, AntColun, Orden, TituloColumn, Ordenado);
end;

//===========================================================
//===================== GESTIONAR PRESUPUESTOS===============
//===========================================================
procedure TFPresupuesto.BitBtn1Click(Sender: TObject);
begin
  If dbMuestrac.RecordCount=0 then Begin Showmessage('NO HAY NINGUN '+ Documento[Tabla] +' PARA GESTIONAR'); Exit; End;
  dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+dbMuestrac.FieldByName('PRC0').AsString;
  dbClientes.Active:=True;
  If dbClientes.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL CLIENTE '+dbMuestrac.FieldByName('PRC0').AsString+' ?'); Exit; End;
  Panel4.BringToFront; Panel4.Visible:=True;
  DBGrid2.BringToFront; DBGrid2.Visible:=True;
  MostrarBotonesdd();
  LimpiaCliente();
  //-- PRUEBA DE CONVERT SIN QUITAR EL MID
  dbMuestrad.SQL.Text:='SELECT *, CONVERT(MID(PRD6,1,150) USING UTF8) As DESCRI FROM '+TablaDetalle[Tabla]+Tienda+' WHERE PRD0='+dbMuestrac.FieldByName('PRC0').AsString+
                     ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
                     ' AND PRD2="'+dbMuestrac.FieldByName('PRC2').AsString+'"'+
                     ' AND PRD3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbMuestrad.Active:=True;
  PintaCliente();
  Label30.Caption:=dbMuestrac.FieldByName('PRC2').AsString;//---- Serie
  Label31.Caption:=dbMuestrac.FieldByName('PRC3').AsString;//---- N. documento
  Label33.Caption:=dbMuestrac.FieldByName('PRC1').AsString;//---- Fecha Fact.
  LabelTotal.Caption:=FormatFloat('0.00',dbMuestrac.FieldByName('PRC9').AsFloat);
  DbGrid2.SetFocus;

end;

//--------------------- Salir de gestionar Presupuestos ------------
procedure TFPresupuesto.BitBtn5Click(Sender: TObject);
var
 Posi: Integer;
 TxtQ: String;
begin
  Panel7.Visible:=False;
  Panel4.SendToBack; Panel4.Visible:=False;
  DBGrid2.SendToBack; DBGrid2.Visible:=False;
  OcultarBotonesdd();
  dbDocud.Active:=False;
  //------------- Si el Presupuesto no tiene lineas borrarla?
  If dbMuestrad.RecordCount=0 then
     begin
       boxstyle :=  MB_ICONQUESTION + MB_YESNO;
       If Application.MessageBox('CONFIRME EL BORRADO DEL DOCUMENTO COMPLETO?','FacturLinEx', boxstyle) = IDNO Then
          Exit;

       ActuHisopcc(2);

       TxtQ:='DELETE FROM '+TablaCabecera[Tabla]+Tienda+' WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
             ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
             ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
       dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;
       dbMuestrac.Refresh;
       DBGrid1.SetFocus;
       Exit;
     end;
  //------------- Actualizar cabecera Presupuestos
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT COUNT(*), SUM(PRD7), SUM(PRD11), SUM(PRD13) FROM '+TablaDetalle[Tabla]+Tienda+' WHERE'+
                     ' PRD0='+dbMuestrac.FieldByName('PRC0').AsString+
                     ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
                     ' AND PRD2="'+dbMuestrac.FieldByName('PRC2').AsString+'"'+
                     ' AND PRD3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then exit;
  TxtQ:='UPDATE '+TablaCabecera[Tabla]+Tienda+' SET PRC4='+dbTrabajo.Fields[0].AsString+', PRC5="'+dbTrabajo.Fields[1].AsString+
        '", PRC8="'+dbTrabajo.Fields[2].AsString+'", PRC9="'+dbTrabajo.Fields[3].AsString+
        '" WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
        ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;
  Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;

  DBGrid1.SetFocus;
end;

//===========================================================
//======================= CREAR LINEAS ======================
//===========================================================
procedure TFPresupuesto.BitBtn12Click(Sender: TObject);
begin
  Panel6.BringToFront;
  Panel7.Visible:=False;
  Panel6.Visible:=True; Edit5.Enabled:=True;
  Panel1.Enabled:=False; DBGrid2.Enabled:=False; DBGrid1.Enabled:= False;
  Limpiadd(); Edit5.SetFocus;
end;

//===========================================================
//======================= BORRAR LINEAS =====================
//===========================================================
procedure TFPresupuesto.BitBtn14Click(Sender: TObject);
begin
  Panel7.Visible:=False;
  if dbMuestrad.Eof=True then
    begin
      Showmessage('ESA LINEA NO EXISTE, NO PUEDE BORRARLA');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DE LA LINEA?','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  ActuHistoclie(1);     // Lo ponemos en modo borrado.
  ActuHisopcc(1);        // Activamos el modo borrado.
  dbMuestrad.Delete;
  ActualizaImporte();
  dbHisopcc.Active:=True;
  dbHisopcc.Edit;                        // Actualizamos Cabecera de históricos.
  dbHisopcc.FieldByName('HO9').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//--- Importe total
  dbHisopcc.FieldByName('HO11').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//-- Importe total con Dto.
  dbHisopcc.FieldByName('HO12').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//-- Entrega
  dbHisopcc.Post; dbHisopcc.Active:=False;
end;

//===========================================================
//======================= MODIFICAR LINEAS ==================
//===========================================================
procedure TFPresupuesto.DBGrid2DblClick(Sender: TObject);
begin
  if (dbMuestrad.Active=False) or (dbMuestrad.RecordCount=0) then exit;

  ActivaPrecios();

  Panel7.Visible:=False;
  Panel6.BringToFront;Panel6.Visible:=True; Panel1.Enabled:=False; DBGrid2.Enabled:=False;
  label28.Caption:=' Editando línea '; //+dbMuestrad.FieldByName('PRD4').AsString;
  Edit5.Text:=dbMuestrad.FieldByName('PRD5').AsString;
  Edit5.Enabled:=False;
  Edit6.Text:=dbMuestrad.FieldByName('PRD6').AsString;

  CantidadLinea:=dbMuestrad.FieldByName('PRD7').AsFloat;
  PrecioConIva:=dbMuestrad.FieldByName('PRD8').AsFloat;
  PrecioSinIva:=dbMuestrad.FieldByName('PRD9').AsFloat;
  DescuentoLinea:=dbMuestrad.FieldByName('PRD10').AsFloat;
  TotalSinIvaLinea:=dbMuestrad.FieldByName('PRD11').AsFloat;
  IvaLinea:=dbMuestrad.FieldByName('PRD12').AsFloat;
  TotalLinea:=dbMuestrad.FieldByName('PRD13').AsFloat;

  CargaValores();

  Edit23.Text:=FormatFloat('0.00',dbMuestrad.FieldByName('PRD17').AsFloat);
  Edit6.SetFocus;
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;
  CargaTarifas(0);
end;

procedure TFPresupuesto.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then begin Key:=0; DBGrid2DblClick(self); end;
end;


//----------------- Salir Crear / Modificar Lineas ------------------
procedure TFPresupuesto.BitBtn6Click(Sender: TObject);
begin
  ListBox2.Visible:=False;
  Panel6.SendToBack;
  Panel6.Visible:=False;DBGrid1.Enabled:= True;
  Panel1.Enabled:=True; DBGrid2.Enabled:=True; DBGrid2.SetFocus;
end;

//----------------- Aceptar Crear / Modificar Lineas ----------------
procedure TFPresupuesto.BitBtn8Click(Sender: TObject);
var
  posi: integer;
begin

  ActivaPrecios();

  if Edit5.Enabled=False then
   begin
     dbMuestrad.Edit; Llenadd(); dbMuestrad.Post;
     Panel6.SendToBack;
     Panel6.Visible:=False; DBGrid1.Enabled:= true;
     Panel1.Enabled:=True; DBGrid2.Enabled:=True;
     Posi:=dbMuestrad.RecNo; dbMuestrad.Refresh; dbMuestrad.RecNo:=Posi;
     ActualizaImporte;
     DBGrid2.SetFocus;
    ActuHistoclie(0);         // Actualiza histórico de clientes.
    ActuHisopcc(0);         // Actualiza histórico de operaciones.
   end
  else
   begin
    //----- Crear linea
    dbMuestrad.Append; Llenadd(); dbMuestrad.Post;
    Limpiadd(); Edit5.SetFocus;
    Posi:=dbMuestrad.RecNo; dbMuestrad.Refresh; dbMuestrad.RecNo:=Posi;
    ActualizaImporte;
    ActuHistoclie(0);         // Actualiza histórico de clientes.
    ActuHisopcc(0);         // Actualiza histórico de operaciones.
   end;
end;

//===========================================================
//===================== NUEVO Presupuesto =======================
//===========================================================
procedure TFPresupuesto.BitBtn9Click(Sender: TObject);
begin
  if (RadioButton2.Checked=False) or (Edit1.Text='') then
     begin ShowMessage('PRIMERO DEBE SELECCIONAR UN CLIENTE'); exit; end;
  if dbClientes.EOF=True then
     begin showmessage('EL CLIENTE SELECIONADO NO EXISTE'); Exit; end;

  CargaSeries();//----- Cargar Series de facturacion
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); exit; end;

  Panel8.Visible:=True; Panel1.Enabled:=False; //DBGrid1.Enabled:=False;
  Edit22.Text:=FormatDateTime('DD/MM/YYYY',Date);
  ListBox1.SetFocus;
  Edit21.Text:=dbSeries.FieldByName('SF3').AsString;
  ListBox1.SetFocus;
  if Tabla=1 then Edit21.Text:=dbSeries.FieldByName('SF8').AsString
             else Edit21.Text:=dbSeries.FieldByName('SF6').AsString;
end;

//---------------- Ver series cuando se pasa por ellas ----------------
procedure TFPresupuesto.ListBox1Click(Sender: TObject);
begin
  if dbSeries.Locate('SF0',trim(copy(ListBox1.Items.Strings[ListBox1.ItemIndex],1,3)),[]) then
      if Tabla=1 then Edit21.Text:=dbSeries.FieldByName('SF8').AsString
             else Edit21.Text:=dbSeries.FieldByName('SF6').AsString;
end;

procedure TFPresupuesto.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then begin key:=0; BitBtn19Click(self); end;
end;

//---------------- En el combo de cabecera
procedure TFPresupuesto.ComboBox1Change(Sender: TObject);
var
  SerieAVer,TxtQ: String;
begin
  //-- PRUEBAS CONVERT SIN QUITAR EL MID
  SerieAVer:=  trim(copy(ComboBox1.Text,1,3));
  if ComboBox1.Text='TODAS LAS SERIES' then
     TxtQ:='SELECT *, CONVERT(MID(PRC11,1,250) USING UTF8) as PRNOTAS,C1 FROM '+TablaCabecera[Tabla]+Tienda+
           ', clientes WHERE PRC0=C0 '+Filtro+'ORDER BY PRC2 ASC, PRC1 DESC, PRC3 DESC'
  else
     TxtQ:='SELECT *, CONVERT(MID(PRC11,1,250) USING UTF8) as PRNOTAS,C1 FROM '+TablaCabecera[Tabla]+Tienda+
           ', clientes WHERE PRC0=C0 AND PRC2="'+SerieAVer+'" '+Filtro+'ORDER BY PRC2 ASC, PRC1 DESC, PRC3 DESC';
  dbMuestrac.Active := False;
  dbMuestrac.Sql.Text:=TxtQ;
  dbMuestrac.Active := True;
end;

//============================== MARCAR DESMARCAR ==================
procedure TFPresupuesto.MenuItem1Click(Sender: TObject);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   if dbMuestrac.FieldByName('PRC10').AsString='S' then Marca:='N' else Marca:='S';
   TxtQ:='UPDATE '+TablaCabecera[Tabla]+Tienda+' SET PRC10="'+Marca+'" WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
             ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
   dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;
   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;
end;

procedure TFPresupuesto.MenuItem2Click(Sender: TObject);
begin
  Edit26.Text:=dbMuestrac.FieldByName('PRC12').AsString;
  if (Edit26.Text='SV') or (Edit26.Text='') then begin showmessage('Documento pendiente de recuperar'); exit; end;
  if Edit26.Text='NS' then Edit26.Text:='Venta';
  if Edit26.Text='NT' then Edit26.Text:='Ticket';
  if Edit26.Text='AL' then Edit26.Text:='Albarán';
  if Edit26.Text='FA' then Edit26.Text:='Factura';
  Edit27.Text:=dbMuestrac.FieldByName('PRC13').AsString;
  Edit28.Text:=dbMuestrac.FieldByName('PRC14').AsString;
  Edit29.Text:=dbMuestrac.FieldByName('PRC15').AsString;
  Panel11.Visible:=True;
end;

procedure TFPresupuesto.MenuItem3Click(Sender: TObject);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   Marca:='S';
   if dbMuestrac.FieldByName('PRC16').AsString='S' then Marca:='N';
   TxtQ:='UPDATE '+TablaCabecera[Tabla]+Tienda+' SET PRC16="'+Marca+'" WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
             ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
   dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;
   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;

end;

procedure TFPresupuesto.MenuItem4Click(Sender: TObject);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   Marca:='S';
   if (dbMuestrac.FieldByName('PRC17').AsString='S') and (EstadoImpresion=0) then Marca:='N';
   TxtQ:='UPDATE '+TablaCabecera[Tabla]+Tienda+' SET PRC17="'+Marca+'" WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
             ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
   dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;

   EstadoImpresion:=0;

   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;


end;

procedure TFPresupuesto.MenuItem5Click(Sender: TObject);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   Marca:='S';
   if (dbMuestrac.FieldByName('PRC18').AsString='S') and (EstadoImpresion=0) then Marca:='N';
   TxtQ:='UPDATE '+TablaCabecera[Tabla]+Tienda+' SET PRC18="'+Marca+'" WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
             ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
   dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;

   EstadoImpresion:=0;

   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;


end;

procedure TFPresupuesto.Button1Click(Sender: TObject);
begin
  Panel11.Visible:=False;
end;

procedure TFPresupuesto.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (dbMuestrac.FieldByName('PRC12').AsString<>'SV') and (dbMuestrac.FieldByName('PRC12').AsString<>'') then
     begin
       DBGrid1.Canvas.Font.Color := clBlue;
       DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
     end;
end;

procedure TFPresupuesto.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then begin key:=0; BitBtn1Click(self); end;
end;

//---------------- Aceptar nuevo Presupuesto ----------------
procedure TFPresupuesto.BitBtn19Click(Sender: TObject);
var
 iniMuestrac, finMuestrac: string;
 inicioSerie, finalSerie: integer;
begin
  SPresupuesto:=dbSeries.FieldByName('SF0').AsString;
  if SPresupuesto='' then begin showmessage('DEBE SELECCIONAR UNA SERIE PARA FACTURAR'); Exit; end;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM '+TablaCabecera[Tabla]+Tienda+' WHERE PRC0='+Edit1.Text+' ORDER BY PRC0, PRC1, PRC2, PRC3';
  dbTrabajo.Active:=True;
  //if swhueco=0 then NumeroPresupuesto();
  NumeroPresupuesto();
  dbtrabajo.Append;
  dbtrabajo.FieldByName('PRC0').AsString:=Edit1.Text; //-------------- Cliente.
  dbtrabajo.FieldByName('PRC1').Value:=StrToDate(Edit22.Text); //----- Fecha Presupuesto.
  dbtrabajo.FieldByName('PRC2').Value:=SPresupuesto; //------------------- Serie de la Presupuesto.
  dbtrabajo.FieldByName('PRC3').Value:=NPresupuesto; //------------------- N. Presupuesto.
  dbtrabajo.FieldByName('PRC4').Value:=0;
  dbtrabajo.FieldByName('PRC5').Value:=0;
  dbtrabajo.FieldByName('PRC6').Value:=0;
  dbtrabajo.FieldByName('PRC7').Value:=dbClientes.Fields[19].AsString;//-- Recargo S/N
  dbtrabajo.FieldByName('PRC8').Value:=0;//------------------------------- Imp. Sin IVA
  dbtrabajo.FieldByName('PRC9').Value:=0;//------------------------------- Imp. Con IVA
  dbtrabajo.FieldByName('PRC10').Value:='N';//---------------------------- Marcada (S/N)
  dbtrabajo.Post;

  if checkbox4.Checked then
        begin
          iniMuestrac:=dbMuestrac.SQL.Text; finMuestrac:=iniMuestrac;
          Delete(iniMuestrac, pos('WHERE', dbMuestrac.SQL.Text)+5 , length(dbMuestrac.SQL.Text));
          Delete(finMuestrac, 1, pos('WHERE',dbMuestrac.SQL.Text)+5  );

          inicioSerie:= pos('PRC2="', finMuestrac);  //Eliminamos la serie anterior si la hubiese.
          if inicioSerie <> 0 then
           begin
            finalSerie:=pos(' ', finMuestrac);
            delete(finMuestrac, inicioSerie, finalSerie-inicioSerie+5);
           end;

          dbMuestrac.Active:= false;
          dbMuestrac.SQL.Text:= iniMuestrac + ' PRC2="'+SPresupuesto+'" AND ' + finMuestrac;
          dbMuestrac.Active:= true;
        end;

  dbMuestrac.Refresh; dbMuestrac.First;
  BitBtn20Click(BitBtn20);//--- Cerrar Panel
end;

//---------------- Cancelar nueva Presupuesto ----------------
procedure TFPresupuesto.BitBtn20Click(Sender: TObject);
begin
  Panel8.Visible:=False; Panel1.Enabled:=True; DBGrid1.Enabled:=True;
  DBGrid1.SetFocus;
end;

//===========================================================
//================ BORRAR Presupuesto COMPLETO ==================
//===========================================================
procedure TFPresupuesto.BitBtn10Click(Sender: TObject);
var
  TxtQ: String;
  TxtTmp: String;
begin
  If dbMuestrac.RecordCount=0 then Begin Showmessage('NO HAY NINGUN '+Documento[Tabla]+' PARA GESTIONAR'); Exit; End;
  dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+dbMuestrac.FieldByName('PRC0').AsString;
  dbClientes.Active:=True;
  If dbClientes.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL CLIENTE '+dbMuestrac.FieldByName('PRC0').AsString+' ?'); Exit; End;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('CONFIRME EL BORRADO DEL DOCUMENTO COMPLETO?','FacturLinEx', boxstyle) = IDNO Then Exit;

  //-- PRUEBAS DE CONVERT SIN QUITAR EL MID
  dbMuestrad.SQL.Text:='SELECT *, CONVERT(MID(PRD6,1,150) USING UTF8) As DESCRI FROM '+TablaDetalle[Tabla]+Tienda+' WHERE PRD0='+dbMuestrac.FieldByName('PRC0').AsString+
                     ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
                     ' AND PRD2="'+dbMuestrac.FieldByName('PRC2').AsString+'"'+
                     ' AND PRD3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbMuestrad.Active:=True;
  if dbMuestrad.RecordCount<>0 then
    begin
      while not dbMuestrad.EOF do
        begin
          ActuHistoClie(1);
          ActualizaImporte();
          ActuHisopcc(1);

          dbMuestrad.Next;
        end;
    end;
  //----------------- Borrar detalles de Presupuestos
  TxtQ:='DELETE FROM '+TablaDetalle[Tabla]+Tienda+' WHERE PRD0='+dbMuestrac.FieldByName('PRC0').AsString+
        ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRD2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRD3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbDocud.SQL.Text:=TxtQ; dbDocud.ExecSQL;
    //----------------- Borrar cabeceras de Presupuestos
  ActuHisopcc(2);
  TxtTmp:= dbMuestrac.Sql.Text;
  TxtQ:='DELETE FROM '+TablaCabecera[Tabla]+Tienda+' WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
        ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;

//  dbMuestrac.Refresh;
  dbMuestrac.Active:=False;
  dbMuestrac.Sql.Text:=TxtTmp;
  dbMuestrac.Active:=true;

end;


//===========================================================
//================= LISTADO DE Presupuestos CABECERAS ===========
//===========================================================
procedure TFPresupuesto.BitBtn23Click(Sender: TObject);
begin
  Panel9.Visible:=True; Edit14.SetFocus;
  Edit14.Text:='1'; Edit16.Text:=ClienteVario;
  Edit18.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit19.Text:=FormatDateTime('DD/MM/YYYY',Date);
end;

//---------- Aceptar listado de Presupuestos cc ----------
procedure TFPresupuesto.BitBtn21Click(Sender: TObject);
begin
  If (Edit14.Text='') or (Edit16.Text='') then Exit;
  dbBusca.Sql.Text:='SELECT *,C1 FROM '+TablaCabecera[Tabla]+Tienda+', clientes WHERE PRC0=C0'+
                    ' AND PRC1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit18.Text))+'"'+
                    ' AND PRC1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit19.Text))+'"'+
                    ' AND PRC0>='+Edit14.Text+' AND PRC0<='+Edit16.Text+' ORDER BY PRC2 ASC, PRC1 DESC, PRC3 DESC';
  dbBusca.Active := True;
  If dbBusca.RecordCount=0 then
    begin
      Showmessage('NO HAY '+Documento[Tabla]+' ENTRE ESOS DATOS');
      exit;
    end;
  if Tabla=1 then FImpresion.Imprime(dbBusca.SQL.Text, 'ListaProformas','')
             else FImpresion.Imprime(dbBusca.SQL.Text, 'ListaPresupuestos','')
end;

//-------------------- Desde cliente ---------------
procedure TFPresupuesto.Edit14Enter(Sender: TObject);
begin
   Edit15.Text:='';
end;
procedure TFPresupuesto.Edit14Exit(Sender: TObject);
begin
   if Edit14.Text='' then Edit14.Text:='1';
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit14.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then Begin Showmessage('ESE CLIENTE NO EXISTE.'); Edit14.SetFocus; Exit; End;
   Edit15.Text:=dbClientes.FieldByName('C1').AsString;
end;

//-------------------- Hasta cliente ---------------
procedure TFPresupuesto.Edit16Enter(Sender: TObject);
begin
   Edit17.Text:='';
end;
procedure TFPresupuesto.Edit16Exit(Sender: TObject);
begin
   if Edit16.Text='' then Edit16.Text:=ClienteVario;
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit16.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then Begin Showmessage('ESE CLIENTE NO EXISTE.'); Edit16.SetFocus; Exit; End;
   Edit17.Text:=dbClientes.FieldByName('C1').AsString;
end;


//---------- Cerrar listado de Presupuestoes cc ----------
procedure TFPresupuesto.BitBtn22Click(Sender: TObject);
begin
  Panel9.Visible:=False;
end;

//===========================================================
//==================== IMPRIMIR Presupuesto =====================
//===========================================================

procedure TFPresupuesto.BitBtn15Click(Sender: TObject);
begin

 EstadoImpresion:= FImpresion.Imprime(dbMuestrad, dbMuestrac, dbClientes, Documento[Tabla], false, 1);

 if (EstadoImpresion=1) then MenuItem4Click(Self);

 if (EstadoImpresion=2) then MenuItem5Click(Self);

 if (EstadoImpresion=3) then
       begin
         MenuItem4Click(Self); EstadoImpresion:=2;
         MenuItem5Click(Self);
       end;

end;

//=================== OBSERVACIONES ==========================
procedure TFPresupuesto.BitBtn16Click(Sender: TObject);
begin
  Panel7.BringToFront;
  Panel7.Visible:=True;
  Memo1.Lines.Text:=dbMuestrac.FieldByName('PRC11').AsString;
  Memo1.SetFocus;
end;
//--------------- Aceptar Observaciones --------
procedure TFPresupuesto.BitBtn18Click(Sender: TObject);
var
 Posi: Integer;
 TxtQ: String;
begin
  TxtQ:='UPDATE '+TablaCabecera[Tabla]+Tienda+' SET PRC11="'+Memo1.Lines.Text+'" WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
        ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;
  Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;
  Panel7.SendToBack;
  Panel7.Visible:=False;
  dbGrid2.SetFocus;
end;

//--------------- Cancelar Observaciones --------
procedure TFPresupuesto.BitBtn17Click(Sender: TObject);
begin
  Panel7.SendToBack;
  Panel7.Visible:=False;
  dbGrid2.SetFocus;
end;

//==================== MARCAR PresupuestoES ======================
procedure TFPresupuesto.DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   exit;
   if Button=mbLeft then exit;
   if dbMuestrac.FieldByName('PRC10').AsString='S' then Marca:='N' else Marca:='S';
   TxtQ:='UPDATE '+TablaCabecera[Tabla]+Tienda+' SET PRC10="'+Marca+'" WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
             ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
   dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;
   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;
end;

//=============== SALIR DEL CGO. ARTICULO =====================
procedure TFPresupuesto.Edit5Exit(Sender: TObject);
var
  codigotmp: String;
begin
  if (Edit5.Enabled=False) or (Edit5.Text='') then exit;
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount=0 then begin
                                dbBusca.Active:=False;
                                dbBusca.SQL.Text:='SELECT EAN0, EAN1 FROM eans WHERE EAN0="'+Edit5.Text+'"';
                                dbBusca.Active:=True;
                                if dbBusca.RecordCount=0 then
                                                 begin
                                                   codigotmp:='';
                                                   codigotmp:=FBusquedas.IniciaBusquedas('SELECT A0, EAN0, A1 FROM artitien'+Tienda+
                                                             ', eans WHERE (EAN1=A0) and (A0 LIKE "%'+Edit5.Text+'%")', ['Código','Ean','Referencia'],'A0');
                                                   if codigotmp='-1' then begin Edit5.SetFocus; exit; end;
                                                   Edit5.Text:=codigotmp;
                                                   dbArti.Active:=False;
                                                   dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+edit5.Text+'"';
                                                   dbArti.Active:=True;

                                                 end else
                                                 begin
                                                     Edit5.Text:=dbBusca.FieldByName('EAN1').AsString;
                                                     dbArti.Active:=False;
                                                     dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
                                                     dbArti.Active:=True;
                                                 end;
                               end;

  Edit6.SetFocus;
  Pintadd();
  CargaTarifas(1);
end;

procedure TFPresupuesto.BitBtn11Click(Sender: TObject);
begin
  BuscaArticulo();
end;


//------------------ Buscar Articulos ---------------
procedure TFPresupuesto.BuscaArticulo();
begin
  Edit5.Text:=FBusquedas.IniciaBusquedas('SELECT A0, EAN0, A1 FROM artitien'+Tienda+
            ' , eans WHERE (A0=EAN1) and (A0 LIKE "%'+Edit5.Text+'%" )', ['Código','Ean','Referencia'],'A0');
  Edit5Exit(self);
end;

procedure TFPresupuesto.Edit6DblClick(Sender: TObject);
var
   key: char;
begin
  if Edit5.Enabled=false then exit;
  key:=#13;
  Edit6KeyPress(self, key);
end;

procedure TFPresupuesto.Edit6KeyPress(Sender: TObject; var Key: char);
begin
  if (Key<>#13) or (Edit5.Enabled=false) then Exit;
  if Edit6.Text='' then begin ShowMessage('TECLEE EL ARTÍCULO A BUSCAR'); Edit6.SetFocus; Exit; end;
  ListBox3.Items.Clear;
  dbBusca.SQL.Text:='SELECT A0,A1 FROM artitien'+Tienda+' WHERE A1 LIKE "%'+Edit6.Text+'%"'; dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then
    begin
      ShowMessage('NO HAY ARTÍCULOS QUE CONTENGAN ESE CONCEPTO');
      dbBusca.Active:=False; Edit6.SetFocus; Exit;
    end;
  dbBusca.First;
  While not dbBusca.EOF do
    begin
      ListBox3.Items.Add(dbBusca.FieldByName('A1').AsString);
      dbBusca.Next;
    end;
  ListBox3.Visible:=True; ListBox3.ItemIndex:=0; ListBox3.SetFocus;
end;

procedure TFPresupuesto.ListBox3DblClick(Sender: TObject);
begin
  if not dbBusca.Locate('A1',ListBox3.Items.Strings[ListBox3.ItemIndex],[]) then begin Edit6.Text:=''; Exit; end;
  Edit5.Text:=dbBusca.Fields[0].AsString;
  Edit6.Text:=dbBusca.Fields[1].AsString;
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;
  Pintadd();
  CargaTarifas(1);
  ListBox3.Visible:=False; Edit7.SetFocus;
end;

procedure TFPresupuesto.ListBox3Exit(Sender: TObject);
begin
  ListBox3.Visible:=False;
end;

procedure TFPresupuesto.ListBox3KeyPress(Sender: TObject; var Key: char);
begin
   if (Key=#13) then ListBox3DblClick(self);
end;

procedure TFPresupuesto.EntraEnEdit(Sender: TObject);
begin
  ValorInicial:= TEdit(ActiveControl).Text;

end;

//===================== CARGA VALORES EN LOS EDIT =====
procedure TFPresupuesto.CargaValores();
begin
 Edit13.Text:= FormatFloat('0.##',TotalLinea);
 Edit7.Text:= FormatFloat('0.###',CantidadLinea);
 Edit8.Text:= FormatFloat('0.###',PrecioConIva);
 Edit9.Text:= FormatFloat('0.###',PrecioSinIva);
 Edit12.Text:= FormatFloat('0.##',IvaLinea);
 Edit10.Text:= FormatFloat('0.##',DescuentoLinea);
 Edit11.Text:= FormatFloat('0.##',TotalSinIvaLinea);
end;

//===================== CARGA VALORES EN LAS VARIABLES =====
procedure TFPresupuesto.CargaVariables();
begin
 TotalLinea:= StrToFloat(Edit13.Text);
 CantidadLinea:= StrToFloat(Edit7.Text);
 PrecioConIva:= StrToFloat(Edit8.Text);
 PrecioSinIva:= StrToFloat(Edit9.Text);
 IvaLinea:= StrToFloat(Edit12.Text);
 DescuentoLinea:= StrToFloat(Edit10.Text);
 TotalSinIvaLinea:= StrToFloat(Edit11.Text);
end;

//==================== REACTIVA LA ENTRADA DE LOS PRECIOS =========
procedure TFPresupuesto.ActivaPrecios();
begin
  Edit8.Color:=clWindow;
  Edit9.Color:=clWindow;
  Edit8.Enabled:=True;
  Edit9.Enabled:=True;
  lbActivarPrecios.Visible:=False;
end;

//===================== ENTRAR/SALIR DE LA CANTIDAD ======================

procedure TFPresupuesto.Edit7Enter(Sender: TObject);
begin
  Edit7.Text:= FormatFloat(MascaraDecimales,CantidadLinea);
end;

procedure TFPresupuesto.Edit7Exit(Sender: TObject);
begin
  if not (EsFloat(Edit7.Text)) then begin Edit7.Text:='0';Edit7.SetFocus; exit; end;

//  if (Edit7.Text='') or (Edit7.Text='0') then begin Edit13.Text:='0';Edit11.Text:='0'; Exit; end;//------ Cant.
//  if (Edit8.Text='') or (Edit8.Text='0') then begin Edit13.Text:='0';Edit11.Text:='0'; Exit; end;//------ Precio

  CantidadLinea:= StrToFloat(Edit7.Text);

  SalirCantidad(self);

  CargaValores()

end;

procedure TFPresupuesto.Edit7KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) and (Edit5.Enabled=true) then Edit5.SetFocus;
end;


//======================= SALIR DE TARIFA ==================

procedure TFPresupuesto.Edit23Exit(Sender: TObject);
begin
   if not (EsFloat(Edit23.Text)) then begin Edit23.Text:='0'; Edit23.SetFocus; exit; end;
end;


//======================= ENTRAR/SALIR DEL PRECIO ==================

procedure TFPresupuesto.Edit8Enter(Sender: TObject);
begin
   Edit8.Text:= FormatFloat(MascaraDecimales,PrecioConIva);
   EntraEnEdit(self);
   Edit8.SetFocus;
end;

procedure TFPresupuesto.Edit8Exit(Sender: TObject);
begin
  if not (EsFloat(Edit8.Text)) then begin Edit8.Text:='0'; Edit8.SetFocus; exit; end;

  if (Edit8.Text<>ValorInicial) and (Edit9.Enabled=True) then
    begin
     Edit9.Color:=clSilver;
     Edit9.Enabled:=False;
     Edit10.SetFocus;
     lbActivarPrecios.Visible:=True;
    End;

  PrecioConIva:= StrToFloat(Edit8.Text);

  SalirPrecio(self);

  CargaValores()

end;

procedure TFPresupuesto.Edit9DblClick(Sender: TObject);
begin
  MuestraTarifas();
end;

//======================= ENTRAR/SALIR DEL PRECIO SIN IVA ====================
procedure TFPresupuesto.Edit9Enter(Sender: TObject);
begin
   Edit9.Text:= FormatFloat(MascaraDecimales,PrecioSinIva);
   EntraEnEdit(self);
   Edit9.SetFocus;
end;

procedure TFPresupuesto.Edit9Exit(Sender: TObject);
begin
  if not Edit9.Enabled then exit;
  if not (EsFloat(Edit9.Text)) then
   begin
    Edit9.Text:=FormatFloat(MascaraDecimales,PrecioSinIva);
    Edit9.SetFocus;
    exit;
   end;
  if Edit7.Text='' then Edit7.Text:='0'; //------ Cant.
  if Edit9.Text='' then Edit9.Text:='0'; //------ Precio

  if (Edit9.Text<>ValorInicial) and (Edit8.Enabled=True) then
   begin
    Edit8.Color:=clSilver;
    Edit8.enabled:=False;
    lbActivarPrecios.Visible:=True;
   End;

  PrecioSinIva:= StrToFloat(Edit9.Text);

  SalirPrecioSinIva(self);

  CargaValores()

end;

//======================= ENTRAR/SALIR DEL DTO =============================
procedure TFPresupuesto.Edit10Enter(Sender: TObject);
begin
   Edit10.Text:= FormatFloat('0.##',DescuentoLinea);
end;

procedure TFPresupuesto.Edit10Exit(Sender: TObject);
begin
  if not (EsFloat(Edit10.Text)) then begin Edit10.Text:='0';Edit10.SetFocus ; exit; end;
  if (Edit7.Text='') or (Edit7.Text='0') then begin Edit7.Text:='0'; Exit; end;//------ Cant.
  if (Edit9.Text='') or (Edit9.Text='0') then begin Edit9.Text:='0'; Exit; end;//------ Precio
  if (Edit10.Text='') or (Edit10.Text='0') then begin Edit10.Text:='0'; Exit; end;//--- Dto

  DescuentoLinea:= StrToFloat(Edit10.Text);

  SalirDescuento(self);

  CargaValores()

end;


//======================= ENTRAR/SALIR DEL IVA ==============================
procedure TFPresupuesto.Edit12Enter(Sender: TObject);
begin
  Edit11.Text:= FormatFloat('0.##',IvaLinea);
end;

procedure TFPresupuesto.Edit12Exit(Sender: TObject);
begin
  if not (EsFloat(Edit12.Text)) then begin Edit12.Text:='0'; Edit12.SetFocus; exit; end;
//  if (Edit7.Text='') or (Edit7.Text='0') then begin Edit7.Text:='0'; Exit; end;//------ Cant.
//  if (Edit8.Text='') or (Edit8.Text='0') then begin Edit8.Text:='0'; Exit; end;//------ Precio
//  if (Edit11.Text='') or (Edit11.Text='0') then begin Edit11.Text:='0'; Exit; end;//--- Importe

  IvaLinea:= StrToFloat(Edit12.Text);

  SalirIva(self);

  CargaValores()

end;

//================  Muestra histórico de compras del cliente =========
procedure TFPresupuesto.HistCliente(Sender: TObject);
var
  inutil: string;
  codigo: string;
begin

  if (Edit5.Enabled=False) then
   begin
     Edit5.Enabled:=True;
     codigo:=Edit5.Text;
     Edit5.Enabled:=False;
   end else
     codigo:= Edit5.Text;

 //-- MID(HC5,1,50) Y MID(HOD7,1,50)
 case cbHistoricos.ItemIndex of
       0:inutil:=FBusquedas.IniciaBusquedas('SELECT HC0, HC1, HC8, HC9, HC4, CONVERT(HC5 USING UTF8), HC6, (HC7/HC6) as Precio FROM histoclie WHERE HC0='+dbMuestrac.FieldByName('PRC0').AsString
                        , ['Cliente','Fecha','Serie','Número','Código','Descripción','Und','Precio'],'HC1');

       1:inutil:=FBusquedas.IniciaBusquedas('SELECT HOD6, CONVERT(HOD7 USING UTF8), HOD8, HOD9,HOD11,HOD4, HOD3 FROM hisopdd'+Tienda+
               ' WHERE HOD6="'+codigo+'"', ['CODIGO','DESCRIPCION','CANTIDAD','PRECIO','DCT%','SERIE','NUMERO'],'HOD6');

       2:inutil:=FBusquedas.IniciaBusquedas('SELECT HC0, HC1, HC8, HC9, HC4, CONVERT(HC5 USING UTF8), HC6, (HC7/HC6) as Precio FROM histoclie '+
                ' WHERE HC0='+dbMuestrac.FieldByName('PRC0').AsString + ' and HC4="' + codigo + '"', ['Cliente','Fecha','Serie','Número','Código','Descripción','Und','Precio'],'HC1');

 end;

 Edit8.SetFocus;

end;

//==================== PINTAR DATOS DE CLIENTES ======================
procedure TFPresupuesto.PintaCliente();
begin
  Label4.Caption:=dbClientes.FieldByName('C1').AsString;
  Label5.Caption:=dbClientes.FieldByName('C3').AsString;
  Label6.Caption:=dbClientes.FieldByName('C37').AsString;
  Label7.Caption:=dbClientes.FieldByName('C4').AsString;
  Label8.Caption:=dbClientes.FieldByName('C38').AsString;
  Label9.Caption:=dbClientes.FieldByName('C5').AsString;
  Label10.Caption:=dbClientes.FieldByName('C6').AsString;
  //------------- Recargo de equivalencia
  if dbClientes.FieldByName('C19').AsString='S' then
    CheckBox1.Checked:=True else CheckBox1.Checked:=False;
  
end;
//==================== LIMPIAR DATOS DE CLIENTES ======================
procedure TFPresupuesto.LimpiaCliente();
begin
  Label4.Caption:=''; Label5.Caption:=''; Label6.Caption:='';
  Label7.Caption:=''; Label8.Caption:=''; Label9.Caption:='';
  Label10.Caption:=''; LabelTotal.Caption:='0.00';

end;
//==================== LLENAR DATOS LINEAS =======================
procedure TFPresupuesto.Llenadd();
begin
  if Edit5.Enabled=true then
    begin
     dbMuestrad.FieldByName('PRD0').Value:=dbMuestrac.FieldByName('PRC0').Value;//---- Cliente
     dbMuestrad.FieldByName('PRD1').Value:=dbMuestrac.FieldByName('PRC1').Value;//---- Fecha
     dbMuestrad.FieldByName('PRD2').Value:=dbMuestrac.FieldByName('PRC2').Value;//---- Serie
     dbMuestrad.FieldByName('PRD3').Value:=dbMuestrac.FieldByName('PRC3').Value;//---- Numero
     dbMuestrad.FieldByName('PRD4').Value:=VerUltimaLinea;//-------------------------- Numero de linea
     label28.Caption:=' Añadiendo nuevas líneas. ';
     dbMuestrad.FieldByName('PRD5').AsString:=Edit5.Text;//----- Codigo
    end;
  dbMuestrad.FieldByName('PRD6').AsString:=Edit6.Text;//-------- Descripcion

  dbMuestrad.FieldByName('PRD7').AsFloat:=CantidadLinea;//-------- Cantidad
  dbMuestrad.FieldByName('PRD8').AsFloat:=PrecioConIva;//-------- Precio con IVA
  dbMuestrad.FieldByName('PRD9').AsFloat:=PrecioSinIva;//-------- Precio sin IVA
  dbMuestrad.FieldByName('PRD10').AsFloat:=DescuentoLinea;//------ Dto. %
  dbMuestrad.FieldByName('PRD11').AsFloat:=TotalSinIvaLinea;//------ Importe sin IVA
  dbMuestrad.FieldByName('PRD12').AsFloat:=IvaLinea;//------ IVA
  dbMuestrad.FieldByName('PRD13').AsFloat:=TotalLinea;//------ Importe con IVA
  dbMuestrad.FieldByName('PRD17').AsString:=Edit23.Text;//------ Precio Tarifa.

end;

//======================= PINTAR DATOS LINEAS ==================
procedure TFPresupuesto.Pintadd();
begin

  CantidadLinea:=1;

  PrecioConIva:=dbArti.FieldByName('A2').AsFloat;//----- PVP

  IvaLinea:=dbArti.FieldByName('A3').AsFloat;//---- IVA

  PrecioSinIva:=PrecioConIva/(1+IvaLinea/100);

  //-----------Ver si se aplica algún precio de tarifa al cliente
  if (dbClientes.FieldByName('C43').AsInteger<>0) and (ListBox2.Items.Count=0) then CargaTarifas(1); // Cargamos tarifas si es primera vez

  //-----------Si tiene descuentos de la ficha de clientes
  DescuentoLinea:=0;
  if dbClientes.FieldByName('C16').AsInteger<>0 then                      //-- Descuento según tipo descuento en ficha cliente
    begin
      if dbClientes.FieldByName('C16').AsInteger=1 then DescuentoLinea:=dbArti.FieldByName('A7').AsFloat;
      if dbClientes.FieldByName('C16').AsInteger=2 then DescuentoLinea:=dbArti.FieldByName('A8').AsFloat;
      if dbClientes.FieldByName('C16').AsInteger=3 then DescuentoLinea:=dbArti.FieldByName('A9').AsFloat;
    end;
  if dbClientes.FieldByName('C17').AsFloat<>0 then DescuentoLinea:=dbClientes.FieldByName('C17').AsFloat;//-- Dto Ficha cliente

  TotalLinea:=PrecioConIva;
  TotalSinIvaLinea:=PrecioSinIva;

  Edit6.Text:=dbArti.FieldByName('A1').AsString;//----- Descripcion
  Edit23.Text:= FormatFloat('0.###',PrecioConIva);//---- Precio Tarifa.

  CargaValores()
end;

//======================= LIMPIAR DATOS LINEAS ==================
procedure TFPresupuesto.Limpiadd();
begin
  label28.Caption:='Editor de líneas ';
  Edit5.Text:=''; Edit6.Text:=''; Edit7.Text:='0';
  Edit8.Text:='0'; Edit9.Text:='0'; Edit10.Text:='0';
  Edit11.Text:='0'; Edit12.Text:='0'; Edit13.Text:='0';
  Edit23.Text:='0';  ListBox2.Items.Clear;
  TotalLinea:= 0;
  CantidadLinea:= 0;
  PrecioConIva:= 0;
  PrecioSinIva:= 0;
  IvaLinea:= 0;
  DescuentoLinea:= 0;
  TotalSinIvaLinea:= 0;
  ActivaPrecios();
end;

//======== CARGA PRECIOS Y DESCUENTOS DEL ARTICULO ==============
procedure TFPresupuesto.CargaTarifas(actualiza: integer);
begin

  dbTarifas.Active:=false;
  dbTarifas.SQL.Text:='select * from tarifas where TAR0="'+dbarti.FieldByName('A0').AsString +'"';

  if actualiza=0 then dbTarifas.SQL.Text:='select * from tarifas where TAR0="'+dbMuestrad.FieldByName('PRD5').AsString +'"';

  dbTarifas.Active:=true;

  ListBox2.Items.Clear;

  ListBox2.Items.Add('PVP        '+dbArti.FieldByName('A2').AsString + ' Euros');
  ListBox2.Items.Add('Precio     '+dbArti.FieldByName('A21').AsString + ' Euros');
  ListBox2.Items.Add('Tarifa 1   '+dbTarifas.FieldByName('TAR2').AsString + ' Euros');
  ListBox2.Items.Add('Tarifa 2   '+dbTarifas.FieldByName('TAR4').AsString + ' Euros');
  ListBox2.Items.Add('Tarifa 3   '+dbTarifas.FieldByName('TAR6').AsString + ' Euros');

  if actualiza=0 then exit;  // --- Si es una edicion de linea no se cargan los valores en las variables.

  //------------------ Tarifa 1
  if (dbClientes.FieldByName('C43').AsInteger=1) and (dbTarifas.FieldByName('TAR7').AsFloat<>0) then
         begin
            PrecioConIva:=dbTarifas.FieldByName('TAR7').AsFloat;//------------ P.V.P.
            PrecioSinIva:=dbTarifas.FieldByName('TAR2').AsFloat;//----------- Precio
         end;
   //------------------ Tarifa 2
   if (dbClientes.FieldByName('C43').AsInteger=2) and (dbTarifas.FieldByName('TAR8').AsFloat<>0) then
         begin
           PrecioConIva:=dbTarifas.FieldByName('TAR8').AsFloat;//------------ P.V.P.
           PrecioSinIva:=dbTarifas.FieldByName('TAR4').AsFloat;//----------- Precio
         end;
    //------------------ Tarifa 3
    if (dbClientes.FieldByName('C43').AsInteger=3) and (dbTarifas.FieldByName('TAR9').AsFloat<>0) then
         begin
          PrecioConIva:=dbTarifas.FieldByName('TAR9').AsFloat;//------------ P.V.P.
          PrecioSinIva:=dbTarifas.FieldByName('TAR6').AsFloat;//----------- Precio
         end;

end;

procedure TFPresupuesto.MuestraTarifas();
begin
   ListBox2.Visible:=true; ListBox2.SetFocus;
end;

procedure TFPresupuesto.ListBox2DblClick(Sender: TObject);
begin
   ListBox2.Visible:= False;

   if ListBox2.ItemIndex=0 then Edit9.Text:=dbArti.FieldByName('A2').AsString;
   if ListBox2.ItemIndex=1 then Edit9.Text:=dbArti.FieldByName('A21').AsString;
   if ListBox2.ItemIndex=2 then Edit9.Text:=dbTarifas.FieldByName('TAR2').AsString;
   if ListBox2.ItemIndex=3 then Edit9.Text:=dbTarifas.FieldByName('TAR4').AsString;
   if ListBox2.ItemIndex=4 then Edit9.Text:=dbTarifas.FieldByName('TAR6').AsString;

   Edit9Exit(self);

end;

procedure TFPresupuesto.ListBox2KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then ListBox2DblClick(self);
end;

//================= ACTUALIZA IMPORTE EN PANTALLA ===============
procedure TFPresupuesto.ActualizaImporte();
begin
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT SUM(PRD13) FROM '+TablaDetalle[Tabla]+Tienda+' WHERE'+
                     ' PRD0='+dbMuestrac.FieldByName('PRC0').AsString+
                     ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
                     ' AND PRD2="'+dbMuestrac.FieldByName('PRC2').AsString+'"'+
                     ' AND PRD3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbBusca.Active:=True;

  LabelTotal.Caption:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);
end;

//================= N. DE Presupuesto ===========================
procedure TFPresupuesto.NumeroPresupuesto();
begin
  if SPresupuesto='' then begin SPresupuesto:='';NPresupuesto:=0; Exit; end;
  dbSeries.Active:=False;
  if Tabla=1 then dbSeries.SQL.Text:='UPDATE seriesfactu SET SF8=SF8+1 WHERE SF0="'+SPresupuesto+'"'
             else dbSeries.SQL.Text:='UPDATE seriesfactu SET SF6=SF6+1 WHERE SF0="'+SPresupuesto+'"';
  dbSeries.ExecSql;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+SPresupuesto+'"';
  dbSeries.Active:=True;
  if dbSeries.Recordcount=0 then exit;
//  SPresupuesto:=dbSeries.Fields[0].AsString;
  if Tabla=1 then NPresupuesto:=dbSeries.FieldByName('SF8').Value
             else NPresupuesto:=dbSeries.FieldByName('SF6').Value;
  dbSeries.Active:=False;
end;


//======================= CARGAR SERIES DE FACTURACION ========================
procedure TFPresupuesto.CargaSeries();
begin
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); exit; end;
  dbSeries.First; ListBox1.Items.Clear;
  ComboBox1.Items.Clear; ComboBox1.Items.Add('TODAS LAS SERIES');
  while not dbSeries.EOF do
    begin
     ListBox1.Items.Add(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
     ComboBox1.Items.Add(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
     dbSeries.Next;
    end;
  dbSeries.Locate('SF0', dbTiendas.Fields[11].AsString, [loCaseInsensitive]);
  ListBox1.ItemIndex:= ListBox1.Items.IndexOf(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);

  ComboBox1.ItemIndex:=0;
end;

//====================== MOSTRAR BOTONES DD ====================
procedure TFPresupuesto.MostrarBotonesdd();
begin
  BitBtn5.Visible:=True; BitBtn12.Visible:=True;
  BitBtn13.Visible:=True; BitBtn14.Visible:=True;
  BitBtn15.Visible:=True; BitBtn16.Visible:=True;
  //-------------- cc
  BitBtn1.Visible:=False; BitBtn9.Visible:=False;
  BitBtn10.Visible:=False; BitBtn2.Visible:=False;
  BitBtn23.Visible:=False;

  //--------------- Oculta Filtro de cabeceras.
  RadioGroup2.Visible:=False;

end;

//====================== OCULTAR BOTONES DD ====================
procedure TFPresupuesto.OcultarBotonesdd();
begin
  BitBtn5.Visible:=False; BitBtn12.Visible:=False;
  BitBtn13.Visible:=False; BitBtn14.Visible:=False;
  BitBtn15.Visible:=False; BitBtn16.Visible:=False;
  //-------------- cc
  BitBtn1.Visible:=True; BitBtn9.Visible:=True;
  BitBtn10.Visible:=True; BitBtn2.Visible:=True;
  BitBtn23.Visible:=True;

  //--------------- Muestra Filtro de cabeceras.
  RadioGroup2.Visible:=True;

end;

//======================= Hist. Operaciones Cab =====================
procedure TFPresupuesto.ActuHisopcc(Modo: integer);   // Modo=1 -> Linea borrada
var
  TxtQ: String;
  PrePro: String;
begin

{ TODO: Falta asignar el numero de usuario que cierra la operacion }

  if Tabla=1 then PrePro:='PO' else PrePro:='PR';

  dbHisopcc.Active:=False;
  TxtQ:='SELECT * FROM hisopcc'+Tienda+' WHERE HO0="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND HO2="'+Puesto+'"'+
        ' AND HO3='+dbMuestrac.FieldByName('PRC3').AsString+
        ' AND HO4="'+dbMuestrac.FieldByName('PRC2').AsString+
        '" AND HO5="'+PrePro+'"';
  dbHisopcc.Sql.Text:=TxtQ; dbHisopcc.Active := True;
  if (dbHisopcc.Recordcount=0) and (Modo=2) then exit;   // No existe histórico de esta cabecera y entramos en modo borrado.
  if (dbHisopcc.Recordcount<>0) and (Modo=2) then        // Marcamos cabecera como borrada.
     begin
      dbHisopcc.Edit;
      dbHisopcc.FieldByName('HO16').Value:='A';
      dbHisopcc.Post;
      Exit;
     End;

  if (dbHisopcc.Recordcount<>0) then      // Ya existe histórico,
    begin
      if Modo<>1 then
        begin
          dbHisopcc.Edit;
          dbHisopcc.FieldByName('HO9').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//--- Importe total
          dbHisopcc.FieldByName('HO11').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//-- Importe total con Dto.
          dbHisopcc.FieldByName('HO12').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//-- Entrega
          dbHisopcc.FieldByName('HO18').Value:=dbMuestrac.FieldByName('PRC11').Value; //--Observaciones.
          dbHisopcc.Post;
        end;
      dbHisopdd.Active:=False;
      TxtQ:='SELECT * FROM hisopdd'+Tienda+' WHERE HOD0="'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('PRD1').AsDateTime)+'"'+
            ' AND HOD2="'+Puesto+'"'+
            ' AND HOD3='+dbMuestrad.FieldByName('PRD3').AsString+
            ' AND HOD4="'+dbMuestrad.FieldByName('PRD2').AsString+
            '" AND HOD5='+dbMuestrad.FieldByName('PRD4').AsString+' AND HOD23=0';

      dbHisopdd.Sql.Text:=TxtQ; dbHisopdd.Active := True;

      Hora:=dbHisopcc.FieldByName('HO1').AsDateTime;

      if (dbHisopdd.RecordCount<>0) then        // Es una modificación, añadimos anotación.
         begin
            if Modo=1 then
               begin
                dbHisopdd.Edit;
                dbHisopdd.FieldByName('HOD7').Value:='(BORRADA) '+dbHisopdd.FieldByName('HOD7').AsString;
                dbHisopdd.FieldByName('HOD17').Value:= dbHisopdd.FieldByName('HOD0').Value;
                dbHisopdd.FieldByName('HOD18').Value:= dbHisopdd.FieldByName('HOD1').Value;
                dbHisopdd.FieldByName('HOD19').Value:= dbHisopdd.FieldByName('HOD2').Value;
                dbHisopdd.FieldByName('HOD20').Value:= dbHisopdd.FieldByName('HOD3').Value;
                dbHisopdd.FieldByName('HOD21').Value:= dbHisopdd.FieldByName('HOD4').Value;
                dbHisopdd.FieldByName('HOD23').Value:= dbHisopdd.FieldByName('HOD5').Value;
                dbHisopdd.FieldByName('HOD1').Value:=  FormatDateTime('HH:MM:SS',Time);
                dbHisopdd.Post;
                Exit;
               end;
            dbHisopdd.Edit;
            dbHisopdd.FieldByName('HOD17').Value:= dbHisopdd.FieldByName('HOD0').Value;
            dbHisopdd.FieldByName('HOD18').Value:= dbHisopdd.FieldByName('HOD1').Value;
            dbHisopdd.FieldByName('HOD19').Value:= dbHisopdd.FieldByName('HOD2').Value;
            dbHisopdd.FieldByName('HOD20').Value:= dbHisopdd.FieldByName('HOD3').Value;
            dbHisopdd.FieldByName('HOD21').Value:= dbHisopdd.FieldByName('HOD4').Value;
            dbHisopdd.FieldByName('HOD23').Value:= dbHisopdd.FieldByName('HOD5').Value;
            dbHisopdd.FieldByName('HOD1').Value:=  FormatDateTime('HH:MM:SS',Time);     // Hora en que se hace la modificación
            Hora:= dbHisopdd.FieldByName('HOD18').Value;
            dbHisopdd.Post;
         end;
      ActuHisopdd();
      Exit;
   end;

   dbHisopcc.append;

   dbHisopcc.FieldByName('HO0').AsString:=dbMuestrac.FieldByName('PRC1').AsString; //FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime);//-- Fecha
   dbHisopcc.FieldByName('HO1').AsString:=FormatDateTime('HH:MM:SS',Time);//-- Hora
   dbHisopcc.FieldByName('HO2').Value:=Puesto;//--- Puesto
   dbHisopcc.FieldByName('HO3').Value:=dbMuestrac.FieldByName('PRC3').Value;//- N.PRE/PRO
   dbHisopcc.FieldByName('HO4').Value:=dbMuestrac.FieldByName('PRC2').Value;//- Serie PRE/PRO.
   dbHisopcc.FieldByName('HO5').Value:=PrePro;//----- Tipo operacion
   dbHisopcc.FieldByName('HO6').Value:='FACTURADO';//------- Tipo de pago.
   dbHisopcc.FieldByName('HO7').Value:=1;//----------------- Usuario
   dbHisopcc.FieldByName('HO8').Value:=dbMuestrac.FieldByName('PRC0').Value;//----- Cgo. Cliente
   dbHisopcc.FieldByName('HO9').Value:=dbMuestrac.FieldByName('PRC9').AsFloat;//--- Importe total
   dbHisopcc.FieldByName('HO10').Value:=0;//-- % Dto.
   dbHisopcc.FieldByName('HO11').Value:=dbMuestrac.FieldByName('PRC9').AsFloat;//-- Importe total con Dto.
   dbHisopcc.FieldByName('HO12').Value:=dbMuestrac.FieldByName('PRC9').AsFloat;//-- Entrega
   dbHisopcc.FieldByName('HO13').Value:=0;//-- Cambio
   dbHisopcc.FieldByName('HO14').Value:=0;//-- Entrega Tarjeta
   dbHisopcc.FieldByName('HO15').Value:='N';//-- Marcada S/N
   dbHisopcc.FieldByName('HO16').Value:='N';//-- Estado del documento Normal.
   dbHisopcc.FieldByName('HO18').Value:=dbMuestrac.FieldByName('PRC11').Value; //--Observaciones.

   dbHisopcc.Post; dbHisopcc.Active:=False;
   Hora:= Time;

   ActuHisopdd();


end;

//======================= Hist. Operaciones Det =====================
procedure TFPresupuesto.ActuHisopdd();
var
  TxtQ: String;
begin
  //------------------- Historico de operaciones detalles
  dbHisopdd.Active:=False;
  TxtQ:='INSERT INTO hisopdd'+Tienda+' (HOD0,HOD1,HOD2,HOD3,HOD4,HOD5,HOD6,HOD7,HOD8,HOD9,HOD10,HOD11'+
        ',HOD12,HOD13,HOD14,HOD15,HOD16, HOD22) VALUES ("'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('PRD1').AsDateTime)+'",'+
        '"'+FormatDateTime('HH:MM:SS',Hora)+'","'+Puesto+'",'+dbMuestrad.FieldByName('PRD3').AsString+',"'+
        dbMuestrad.FieldByName('PRD2').AsString+'",'+dbMuestrad.FieldByName('PRD4').AsString+',"'+
        dbMuestrad.FieldByName('PRD5').AsString+'","'+dbMuestrad.FieldByName('PRD6').AsString+'",'+
        dbMuestrad.FieldByName('PRD7').AsString+','+dbMuestrad.FieldByName('PRD8').AsString+','+
        dbMuestrad.FieldByName('PRD9').AsString+','+dbMuestrad.FieldByName('PRD10').AsString+','+
        dbMuestrad.FieldByName('PRD11').AsString+','+dbMuestrad.FieldByName('PRD12').AsString+','+
        dbMuestrad.FieldByName('PRD13').AsString+',"","'+dbMuestrad.FieldByName('PRD15').AsString+'",'+
        dbMuestrad.FieldByName('PRD17').AsString+')';
  dbHisopdd.SQL.Text:=TxtQ; dbHisopdd.ExecSQL;
end;


procedure TFPresupuesto.ActuHistoclie(Modo: integer);  //Modo=1 borrar línea.
var
   TxtQ: string;
begin
  //------------------- Histórico de compras de clientes
  dbTrabajo.Active:=False;
  TxtQ:='SELECT * FROM histoclie WHERE HC0="'+dbMuestrad.FieldByName('PRD0').AsString+
        '" AND HC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('PRD1').AsDateTime)+
        '" AND HC3="'+dbMuestrad.FieldByName('PRD4').AsString+
        '" AND HC8="'+dbMuestrad.FieldByName('PRD2').AsString+
        '" AND HC9='+dbMuestrad.FieldByName('PRD3').AsString;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.Active:=True;

  if (dbTrabajo.RecordCount=0) then
      begin
         if Modo=1 then exit;
         TxtQ:='INSERT INTO histoclie (HC0,HC1,HC2,HC3,HC4,HC5,HC6,HC7,HC8,HC9) VALUES ("'+
         dbMuestrac.FieldByName('PRC0').AsString+'","'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('PRD1').AsDateTime)+'","'+
         FormatDateTime('HH:MM:SS',Time)+'",'+dbMuestrad.FieldByName('PRD4').AsString+
         ',"'+dbMuestrad.FieldByName('PRD5').AsString+'","'+dbMuestrad.FieldByName('PRD6').AsString+
         '",'+dbMuestrad.FieldByName('PRD7').AsString+','+dbMuestrad.FieldByName('PRD13').AsString+',"'+
         dbMuestrad.FieldByName('PRD2').AsString+'",'+dbMuestrad.FieldByName('PRD3').AsString+')';
         dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
         Exit
      end;

  if Modo=1 then begin dbTrabajo.Delete; Exit; end;

  dbTrabajo.Edit;
  dbTrabajo.FieldByName('HC4').AsString:=dbMuestrad.FieldByName('PRD5').AsString;
  dbTrabajo.FieldByName('HC5').AsString:=dbMuestrad.FieldByName('PRD6').AsString;
  dbTrabajo.FieldByName('HC6').Value:=dbMuestrad.FieldByName('PRD7').AsFloat;
  dbTrabajo.FieldByName('HC7').Value:=dbMuestrad.FieldByName('PRD13').AsFloat;
  dbTrabajo.Post;

end;

//====================== CERRAR FORMULARIO =====================
procedure TFPresupuesto.BitBtn2Click(Sender: TObject);
begin
  Close();
end;
procedure TFPresupuesto.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//=================== TECLAS RAPIDAS ======================

procedure TFPresupuesto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

//     **********  Edición de las líneas del documento   **********

 if (key=VK_F1) and (panel6.Visible=True) and (lbActivarPrecios.Visible=True) then begin Key:=0;ActivaPrecios(); end;  // Activa entrada de precios
 if (key=VK_F12) and (panel6.Visible=True) and (Edit5.Enabled=True) then begin key:=0; BuscaArticulo(); end;     // Buscar artículo.
 if (key=VK_F11) and (panel6.Visible=True) and (Edit9.Focused) then begin key:=0; Edit9DblClick(self); Exit; End;     // Tarifas.
 if (key=VK_F11) and (panel6.Visible=True) and (Edit6.Focused) then begin key:=0; Edit6DblClick(self); Exit; End;
 if (key=VK_F6) and (panel6.Visible=True) then begin key:=0; Edit10.SetFocus; Exit; End;                         // Descuento
 if (key=VK_F7) and (panel6.Visible=True) then begin key:=0; Edit9.SetFocus; Exit; End;                          // Precio
 if (key=VK_F5) and (panel6.Visible=True) then begin key:=0; Edit7.SetFocus; Exit; End;                          // Cantidad
 if (key=VK_F8) and (panel6.Visible=True) then begin key:=0; BitBtn8Click(self); Exit; End;                      // Línea nueva
 //if (key=VK_F10) and (panel6.Visible=True) then begin key:=0; BitBtn24Click(self); Exit; End;                    // histórico de cliente.
 if (key=VK_ESCAPE) and (panel6.Visible=True) then begin key:=0; BitBtn6Click(self) ; Exit; End;                 // finalizar entradas
 if (key=VK_RETURN) and (panel6.Visible=True) and                                  // entrada automática.
                       (Edit5.Focused) then begin key:=0; Edit5Exit(self); BitBtn8Click(self) ; Exit; End;

//     **********  Pantalla cabeceras de presupuestos/proformas   **********


 if (key=VK_C) and (dbGrid2.Visible=false) and (Panel2.Visible=false) then
      begin
        key:=0;
        RadioButton2.Checked:=True;
        RadioButton2Click(self);
        Exit;
      End;
 if (key=VK_T) and (dbGrid2.Visible=false) and (Panel2.Visible=false) then
      begin
        key:=0;
        RadioButton1.Checked:=True;
        RadioButton1Click(self);
        Exit;
      End;
 if (key=VK_F) and (dbGrid2.Visible=false) and (Panel2.Visible=false) then
      begin
        key:=0;
        RadioButton3.Checked:=True;
        RadioButton3Click(self);
        Exit;
      End;
 if (key=VK_F1) and (dbGrid2.Visible=false) then begin key:=0; BitBtn1Click(self); Exit; End;                    // entra en edición del pre/pro
 if (key=VK_F2) and (dbGrid2.Visible=false) then begin key:=0; BitBtn9Click(self); Exit; End;                    // crea un pre/pro nuevo
 if (key=VK_F3) and (dbGrid2.Visible=false) then begin key:=0; BitBtn10Click(self); Exit; End;                   // borra un pre/pro
 if (key=VK_F11) and (dbGrid2.Visible=false) then begin key:=0; BitBtn23Click(self); Exit; End;                  // Listado de pre/pro's
 if (key=VK_F8 ) and (Panel9.Visible=True) then begin key:=0; BitBtn21Click(self); Exit; End;                    // ejecuta el listado
 if (key=VK_F8 ) and (Panel8.Visible=True) then begin key:=0; BitBtn19Click(self); dbGrid1.SetFocus; Exit; End;  // Acepta datos serie/numero pre/pro
 if (key=VK_ESCAPE) and (Panel9.Visible=True) then begin key:=0; BitBtn22Click(self); Exit; End;                 // Cancelar listado
 if (key=VK_ESCAPE) and (Panel8.Visible=True) then begin key:=0; BitBtn20Click(self); Exit; End;                 // Cancelar datos serie/pro.
 if (key=VK_ESCAPE) and (dbGrid2.Visible=false) then begin key:=0; BitBtn2Click(self); Exit; End;                // Salir de tarea de pre/pro
 if (key=VK_F12) and (dbGrid2.Visible=false) and (RadioButton2.Checked) then begin key:=0; BitBtn7Click(self); Exit; End;  // buscar clientes.

//     **********  Pantalla de detalles de proformas/presupuestos   **********

 if (key=VK_F2) and (dbGrid2.Visible=true) then begin key:=0; BitBtn12Click(self); Exit; End;                     // Crear líneas nuevas.
 if (key=VK_F3) and (dbGrid2.Visible=true) then begin key:=0; BitBtn14Click(self); Exit; End;                     // Borra la línea seleccionada
 if (key=VK_F4) and (dbGrid2.Visible=true) then begin key:=0; DBGrid2DblClick(self); Exit; End;                   // Editar la linea seleccionada
 if (key=VK_F11) and (dbGrid2.Visible=true) then begin key:=0; BitBtn15Click(self); Exit; End;                    // Imprime el pre/pro en uso.
 if (key=VK_F10) and (dbGrid2.Visible=true) then begin key:=0; BitBtn16Click(self); Exit; End;                    // Observaciones / notas
 if (key=VK_ESCAPE) and (panel7.Visible=True) then begin key:=0; BitBtn17Click(self); Exit; End;                  // Salir de observaciones
 if (key=VK_ESCAPE) and (dbGrid2.Visible=true) then begin key:=0; BitBtn5Click(self); Exit; End;                  // salir de la edicion de documentos.
 if (key=VK_F8) and (panel7.Visible=True) then begin key:=0; BitBtn18Click(self); Exit; End;                      // // acepta las observaciones.

end;

procedure TFPresupuesto.FormShow(Sender: TObject);
begin
  dbGrid1.SetFocus;
end;

//=================== SACAR EL ULT N. DE LINEA =====================
function TFPresupuesto.VerUltimaLinea: Integer;
begin
  VerUltimaLinea:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(PRD4) As ULTIMA FROM '+TablaDetalle[Tabla]+Tienda+' WHERE'+
                    ' PRD0='+dbMuestrac.FieldByName('PRC0').AsString+
                    ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
                    ' AND PRD2="'+dbMuestrac.FieldByName('PRC2').AsString+'"'+
                    ' AND PRD3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLinea:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;


initialization

  {$I presupuestos.lrs}

end.

