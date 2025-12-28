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

unit Factura;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ZConnection, ZDataset, DBGrids, db, StdCtrls, DbCtrls, LR_Class,
  LR_DBSet, LCLType, CheckLst, Menus, LR_E_CSV, LR_E_HTM, LR_DSet;

type

{ TFFacturas }

TFFacturas = class(TForm)
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
  BitBtn24: TBitBtn;
  BitBtn25: TBitBtn;
  BitBtn26: TBitBtn;
  BitBtn28: TBitBtn;
  BitBtn29: TBitBtn;
  BitBtn3: TBitBtn;
  BitBtn30: TBitBtn;
  BitBtn31: TBitBtn;
  BitBtn32: TBitBtn;
  BitBtn33: TBitBtn;
  BitBtn34: TBitBtn;
  BitBtn4: TBitBtn;
  BitBtn5: TBitBtn;
  BitBtn6: TBitBtn;
  BitBtn8: TBitBtn;
  BitBtn9: TBitBtn;
  btRecibosAceptar: TBitBtn;
  btRecibosCancelar: TBitBtn;
  cbHistoricos: TComboBox;
  CheckBox1: TCheckBox;
  CheckBox2: TCheckBox;
  ChboxMarcadas: TCheckBox;
  CheckBox4: TCheckBox;
  CheckListBox1: TCheckListBox;
  CheckListBox2: TCheckListBox;
  ComboBox1: TComboBox;
  cbSerieListado: TComboBox;
  Datasource1: TDatasource;
  Datasource2: TDatasource;
  Datasource3: TDatasource;
  DBGrid1: TDBGrid;
  DBGrid2: TDBGrid;
  dbHisopcc: TZQuery;
  dbHisopdd: TZQuery;
  dbTarifas: TZQuery;
  dbTiendas: TZQuery;
  dbBusca: TZQuery;
  dbTrabajo: TZQuery;
  dbSeries: TZQuery;
  dbLista: TZQuery;
  dbFactuc: TZQuery;
  dbFactud: TZQuery;
  dbClientes: TZQuery;
  dbArti: TZQuery;
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
  Edit3: TEdit;
  Edit30: TEdit;
  Edit31: TEdit;
  Edit4: TEdit;
  Edit5: TEdit;
  Edit6: TEdit;
  Edit7: TEdit;
  Edit8: TEdit;
  Edit9: TEdit;
  edRecibos: TEdit;
  frDBDataSet1: TfrDBDataSet;
  frReport1: TfrReport;
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
  Label37: TLabel;
  Label38: TLabel;
  Label39: TLabel;
  Label40: TLabel;
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
  lbListaRecibos: TLabel;
  lbRecibos: TLabel;
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
  Panel10: TPanel;
  Panel11: TPanel;
  Panel12: TPanel;
  Panel2: TPanel;
  Panel3: TPanel;
  Panel4: TPanel;
  Panel5: TPanel;
  Panel6: TPanel;
  Panel7: TPanel;
  Panel8: TPanel;
  Panel9: TPanel;
  panelRecibos: TPanel;
  PopupMenu1: TPopupMenu;
  RadioButton1: TRadioButton;
  RadioButton2: TRadioButton;
  RadioButton3: TRadioButton;
  RadioGroup1: TRadioGroup;
  RadioGroup2: TRadioGroup;
  procedure btRecibosAceptarClick(Sender: TObject);
  procedure btRecibosCancelarClick(Sender: TObject);
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
  procedure BitBtn24Click(Sender: TObject);
  procedure BitBtn26Click(Sender: TObject);
  procedure BitBtn27Click(Sender: TObject);
  procedure HistCliente(Sender: TObject);
  procedure BitBtn28Click(Sender: TObject);
  procedure BitBtn29Click(Sender: TObject);
  procedure BitBtn2Click(Sender: TObject);
  procedure BitBtn30Click(Sender: TObject);
  procedure BitBtn31Click(Sender: TObject);
  procedure BitBtn3Click(Sender: TObject);
  procedure BitBtn4Click(Sender: TObject);
  procedure BitBtn5Click(Sender: TObject);
  procedure BitBtn6Click(Sender: TObject);
  procedure BitBtn8Click(Sender: TObject);
  procedure BitBtn9Click(Sender: TObject);
  procedure CheckListBox1ItemClick(Sender: TObject; Index: integer);
  procedure CheckListBox1KeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
  procedure ComboBox1Change(Sender: TObject);
  procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure DBGrid1TitleClick(Column: TColumn);
  procedure DBGrid2DblClick(Sender: TObject);
  procedure DBGrid2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure Edit10Enter(Sender: TObject);
  procedure Edit10Exit(Sender: TObject);
  procedure Edit2Exit(Sender: TObject);
  procedure Edit12Enter(Sender: TObject);
  procedure Edit12Exit(Sender: TObject);
  procedure Edit14Enter(Sender: TObject);
  procedure Edit14Exit(Sender: TObject);
  procedure Edit16Enter(Sender: TObject);
  procedure Edit16Exit(Sender: TObject);
  procedure Edit1Enter(Sender: TObject);
  procedure Edit1Exit(Sender: TObject);
  procedure Edit2KeyPress(Sender: TObject; var Key: char);
  procedure Edit31Exit(Sender: TObject);
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
  procedure NumeroFactura();
  procedure RadioGroup2Click(Sender: TObject);
  procedure RestarStock(Codigo, Cantidad: String);
  procedure SumarStock(Codigo, Cantidad: String);
  procedure RestarEsta(Codigo, Cantidad, Precio: String);
  procedure SumarEsta(Codigo, Cantidad, Precio: String);
  function VerUltimaLinea: Integer;
  procedure CargaSeries();
  procedure ActualizaImporte();
  procedure CargaTarifas(actualiza: integer);
  procedure MuestraTarifas();
  procedure BuscaArticulo();
  procedure FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  procedure ActuHisopcc(Modo: integer);
  procedure ActuHisopdd();
  procedure ActuHistoclie(Modo: integer);
  procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
  procedure CargaValores();
  procedure CargaVariables();
  procedure ActivaPrecios();
  procedure EntraEnEdit(Sender: TObject);
  function HayStock: boolean;

  private
    { private declarations }
  public
    { public declarations }
  end;

  procedure ShowFormFacturas;
  
var
  FFacturas: TFFacturas;
  SFACTURA: String;
  NFACTURA: Integer;
  lMarcado: integer;  // 0 = todos, 1 = no marcado, 2=marcado
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;
  hora: TDateTime;
  FacturasPagadas: string;

  ValorInicial: String;   // Valor de entrada de un edit para controlar si cambió al salir.
  EstadoImpresion: integer;

implementation

uses
  Global, Funciones, Busquedas, Imprimir, calculos;
  
 { TFFacturas }

//=============== Crea el formulario ================
procedure ShowFormFacturas;
begin
  with TFFacturas.Create(Application) do
    begin
       ShowModal;
    end;
end;
//======================= CREAR FORMULARIO ==========================
procedure TFFacturas.FormCreate(Sender: TObject);
begin
  //--------- Conectar con la bbdd e inicializar datos globales
  // Conectate(dbConect);                      // Utilizamos datamodule1.dbconexion para toda la aplicación.
  //------------------- Tablas ------------------
  //-- MID(FC19,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(FC19 USING UTF8) as FNOTAS,C1 FROM factuc'+Tienda+', clientes WHERE FC0=C0 ORDER BY FC2 ASC, FC1 DESC, FC3 DESC';
  dbMuestrac.Active := True;
  //-------------------- Tiendas
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin Showmessage('NO SE EN QUE TIENDA HACER EL ALBARAN'); Close(); end;
  //------------- Chequear ivas
  if IVA1=0 then showmessage('DEBE DEFINIR LOS TIPOS DE IVA EN LA CONFIGURACION');
  //------------- Cargar Series
  CargaSeries();//----- Cargar Series de facturacion
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); Close(); end;

  //------------- Sólo documentos de la serie activa
  ComboBox1.Text:=Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString;
  ComboBox1Change(self);


  //-------------------
  lMarcado:=0;
  Panel4.SendToBack; Panel4.Visible:=False;
  DBGrid2.SendToBack; DBGrid2.Visible:=False;
  AntColun:='0';Ordenado:=False; Orden:='DESC';
end;

//============== TODAS LAS FACTURAS =====================
procedure TFFacturas.RadioButton1Click(Sender: TObject);
begin
  Panel2.Visible:=False;
  Panel3.Visible:=False;
  //-- MID(FC19,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(FC19 USING UTF8) as FNOTAS,C1 FROM factuc'+Tienda+', clientes WHERE FC0=C0 ORDER BY FC2 ASC, FC1 DESC, FC3 DESC';
  dbMuestrac.Active := True;
end;

//============== FACTURAS DE UN CLIENTE ========================
procedure TFFacturas.RadioButton2Click(Sender: TObject);
begin
  Panel2.Visible:=True; Panel3.Visible:=False; Edit1.SetFocus;
end;
procedure TFFacturas.BitBtn3Click(Sender: TObject);
begin
  If Edit1.Text='' then Exit;
  //-- MID(FC19,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(FC19 USING UTF8) as FNOTAS,C1 FROM factuc'+Tienda+', clientes WHERE FC0=C0 AND FC0='+Edit1.Text+' ORDER BY FC2 ASC, FC1 DESC, FC3 DESC';
  dbMuestrac.Active := True;
  If dbMuestrac.RecordCount=0 then
    begin
      Showmessage('NO HAY FACTURAS DE ESTE CLIENTE');
      exit;
    end;
end;

//=================== CGO CLIENTE FLITRADO =======================
procedure TFFacturas.Edit1Enter(Sender: TObject);
begin
   Edit2.Text:='';
end;
procedure TFFacturas.Edit1Exit(Sender: TObject);
begin
   if Edit1.Text='' then Exit;
   if not (EsFloat(Edit1.Text)) then begin Edit1.Text:='0'; Edit1.SetFocus; exit; end;
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit1.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then
                               Begin    // Showmessage('ESE CLIENTE NO EXISTE.');
                                 BitBtn31Click(self);
                                 Edit2.SetFocus; Exit;
                               End;
   Edit2.Text:=dbClientes.FieldByName('C1').AsString;
   BitBtn3.Click;
//   Edit1.SetFocus;
end;
//--------------- Busca Cliente -----------------------
procedure TFFacturas.BitBtn31Click(Sender: TObject);
begin
   Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT C0,C1,C5 FROM clientes',['Código','Cliente','N.I.F.'],'C0');
   Edit2.SetFocus;
   Edit1Exit(self);
end;


//--------------- Buscar por nombre -----------------
procedure TFFacturas.Edit2Exit(Sender: TObject);
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
procedure TFFacturas.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then Edit2Exit(self);
  Exit;
end;

//============== FACTURAS ENTRE FECHAS ========================
procedure TFFacturas.RadioButton3Click(Sender: TObject);
begin
  Panel3.Visible:=True; Panel2.Visible:=False;
  Edit3.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit4.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit3.SetFocus;
end;
procedure TFFacturas.BitBtn4Click(Sender: TObject);
begin
  If (Edit3.Text='') or (Edit4.Text='') then Exit;
  //-- MID(FC19,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(FC19 USING UTF8) as FNOTAS,C1 FROM factuc'+Tienda+', clientes WHERE FC0=C0 AND FC1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit3.Text))+'" AND FC1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit4.Text))+'" ORDER BY FC2 ASC, FC1 DESC, FC3 DESC';
  dbMuestrac.Active := True;
  If dbMuestrac.RecordCount=0 then
    begin
      Showmessage('NO HAY FACTURAS ENTRE ESAS FECHAS');
      exit;
    end;
end;

//===================== TIPOS DE DOCUMENTOS =================
procedure TFFacturas.RadioGroup2Click(Sender: TObject);
var
  iniMuestrac, finMuestrac: string;
  txtMarcado: string;
  lCambio: integer;        //lCambio copia a lMarcado cuando entra en la función.
begin
  lCambio:= lMarcado;
  iniMuestrac:=dbMuestrac.SQL.Text; finMuestrac:=iniMuestrac;

  if (lMarcado<>0) then
    begin
       Delete(iniMuestrac, pos('ORDER', dbMuestrac.SQL.Text)-14 , length(dbMuestrac.SQL.Text));
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

  if (lMarcado<>lCambio) then dbMuestrac.SQL.Text:= iniMuestrac + ' AND FC10="'+txtMarcado+'" ' + finMuestrac;
  dbMuestrac.Active:= true;
end;

//===========================================================
//===================== GESTIONAR FACTURAS ==================
//===========================================================
procedure TFFacturas.BitBtn1Click(Sender: TObject);
begin
  If dbMuestrac.RecordCount=0 then Begin Showmessage('NO HAY NINGUNA FACTURA PARA GESTIONAR'); Exit; End;
  dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+dbMuestrac.FieldByName('FC0').AsString;
  dbClientes.Active:=True;
  If dbClientes.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL CLIENTE '+dbMuestrac.FieldByName('FC0').AsString+' ?'); Exit; End;
  Panel4.BringToFront; Panel4.Visible:=True;
  DBGrid2.BringToFront; DBGrid2.Visible:=True;
  MostrarBotonesdd();
  LimpiaCliente();
  //-- MID(FD6,1,150)
  dbMuestrad.SQL.Text:='SELECT *, CONVERT(FD6 USING UTF8) As DESCRI FROM factud'+Tienda+' WHERE FD0='+dbMuestrac.FieldByName('FC0').AsString+
                     ' AND FD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
                     ' AND FD2="'+dbMuestrac.FieldByName('FC2').AsString+'"'+
                     ' AND FD3='+dbMuestrac.FieldByName('FC3').AsString;
  dbMuestrad.Active:=True;
  PintaCliente();
  Label30.Caption:=dbMuestrac.FieldByName('FC2').AsString;//---- Serie
  Label31.Caption:=dbMuestrac.FieldByName('FC3').AsString;//---- N. Factura
  Label33.Caption:=dbMuestrac.FieldByName('FC1').AsString;//---- Fecha Fact.
  LabelTotal.Caption:=FormatFloat('0.00',dbMuestrac.FieldByName('FC9').AsFloat);
  dbGrid2.SetFocus;

end;
//--------------------- Salir de gestionar facturas ------------
procedure TFFacturas.BitBtn5Click(Sender: TObject);
var
 Posi: Integer;
 TxtQ, TxtTemp: String;
begin
  Panel7.Visible:=False;
  Panel4.SendToBack; Panel4.Visible:=False;
  DBGrid2.SendToBack; DBGrid2.Visible:=False;
  OcultarBotonesdd();
  dbFactud.Active:=False;
  //------------- Si la factura no tiene lineas borrarla?
  If dbMuestrad.RecordCount=0 then
     begin
       boxstyle :=  MB_ICONQUESTION + MB_YESNO;
       If Application.MessageBox('CONFIRME EL BORRADO DE LA FACTURA COMPLETA?','FacturLinEx', boxstyle) = IDNO Then
          Exit;

       ActuHisopcc(2);

       TxtTemp:=dbMuestrac.SQL.Text;
       TxtQ:='DELETE FROM factuc'+Tienda+' WHERE FC0='+dbMuestrac.FieldByName('FC0').AsString+
             ' AND FC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
             ' AND FC2="'+dbMuestrac.FieldByName('FC2').AsString+'" AND FC3='+dbMuestrac.FieldByName('FC3').AsString;
       dbFactuc.SQL.Text:=TxtQ; dbFactuc.ExecSQL;
       //dbMuestrac.Refresh;
       dbMuestrac.Active:=False;
       dbMuestrac.Sql.Text:=TxtTemp;
       dbMuestrac.Active:=True;
       DBGrid1.SetFocus;
       Exit;
     end;
  //------------- Actualizar cabecera facturas
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT COUNT(*), SUM(FD7), SUM(FD11), SUM(FD13) FROM factud'+Tienda+' WHERE'+
                     ' FD0='+dbMuestrac.FieldByName('FC0').AsString+
                     ' AND FD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
                     ' AND FD2="'+dbMuestrac.FieldByName('FC2').AsString+'"'+
                     ' AND FD3='+dbMuestrac.FieldByName('FC3').AsString;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then exit;
  TxtQ:='UPDATE factuc'+Tienda+' SET FC4='+dbTrabajo.Fields[0].AsString+', FC5='+dbTrabajo.Fields[1].AsString+
        ', FC8='+dbTrabajo.Fields[2].AsString+', FC9='+dbTrabajo.Fields[3].AsString+
        ' WHERE FC0='+dbMuestrac.FieldByName('FC0').AsString+
        ' AND FC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
        ' AND FC2="'+dbMuestrac.FieldByName('FC2').AsString+'" AND FC3='+dbMuestrac.FieldByName('FC3').AsString;
  dbFactuc.SQL.Text:=TxtQ; dbFactuc.ExecSQL;
  Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;

  DBGrid1.SetFocus;

end;

//===========================================================
//======================= CREAR LINEAS ======================
//===========================================================
procedure TFFacturas.BitBtn12Click(Sender: TObject);
begin
  Panel6.BringToFront;
  Panel7.Visible:=False; DBGrid1.Enabled:= False;
  Panel6.Visible:=True; Edit5.Enabled:=True;
  Panel1.Enabled:=False; DBGrid2.Enabled:=False;
  Limpiadd(); Edit5.SetFocus;
end;

//===========================================================
//======================= BORRAR LINEAS =====================
//===========================================================
procedure TFFacturas.BitBtn14Click(Sender: TObject);
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
  SumarStock(dbMuestrad.FieldByName('FD5').AsString, dbMuestrad.FieldByName('FD7').AsString );

  RestarEsta(dbMuestrad.FieldByName('FD5').AsString, dbMuestrad.FieldByName('FD7').AsString,
            dbMuestrad.FieldByName('FD11').AsString);

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
procedure TFFacturas.DBGrid2DblClick(Sender: TObject);
begin
  if (dbMuestrad.Active=False) or (dbMuestrad.RecordCount=0) then exit;

  ActivaPrecios();

  Panel7.Visible:=False;
  Panel6.BringToFront;Panel6.Visible:=True; Panel1.Enabled:=False; DBGrid2.Enabled:=False;
  label42.Caption:=' Editando línea ';
  Edit5.Text:=dbMuestrad.FieldByName('FD5').AsString;
  Edit5.Enabled:=False;
  Edit6.Text:=dbMuestrad.FieldByName('FD6').AsString;

  CantidadLinea:=dbMuestrad.FieldByName('FD7').AsFloat;
  PrecioConIva:=dbMuestrad.FieldByName('FD8').AsFloat;
  PrecioSinIva:=dbMuestrad.FieldByName('FD9').AsFloat;
  DescuentoLinea:=dbMuestrad.FieldByName('FD10').AsFloat;
  TotalSinIvaLinea:=dbMuestrad.FieldByName('FD11').AsFloat;
  IvaLinea:=dbMuestrad.FieldByName('FD12').AsFloat;
  TotalLinea:=dbMuestrad.FieldByName('FD13').AsFloat;

  CargaValores();

  Edit31.Text:=FormatFloat('0.00',dbMuestrad.FieldByName('FD17').AsFloat);
  Edit6.SetFocus;
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;
  CargaTarifas(0);
end;

procedure TFFacturas.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then begin Key:=0; DBGrid2DblClick(self); end;
end;

//----------------- Salir Crear / Modificar Lineas ------------------
procedure TFFacturas.BitBtn6Click(Sender: TObject);
begin
  Panel6.Visible:=False; DBGrid1.Enabled:= true;
  Panel1.Enabled:=True; DBGrid2.Enabled:=True; DBGrid2.SetFocus;
end;

//----------------- Aceptar Crear / Modificar Lineas ----------------
procedure TFFacturas.BitBtn8Click(Sender: TObject);
var
 Posi: Integer;
begin

  HayStock;

  ActivaPrecios();

  if Edit5.Enabled=False then
   begin
    //----- Modificar Linea
    SumarStock(dbMuestrad.FieldByName('FD5').AsString, dbMuestrad.FieldByName('FD7').AsString );
    RestarEsta(dbMuestrad.FieldByName('FD5').AsString, dbMuestrad.FieldByName('FD7').AsString,
              dbMuestrad.FieldByName('FD11').AsString);

    dbMuestrad.Edit; Llenadd(); dbMuestrad.Post;

    RestarStock(Edit5.Text,Edit7.Text);
    SumarEsta(Edit5.Text,Edit7.Text,Edit11.Text);

//    Panel6.SendToBack;
    Panel6.Visible:=False; DBGrid1.Enabled:= True;
    Panel1.Enabled:=True; DBGrid2.Enabled:=True;
    Posi:=dbMuestrad.RecNo; dbMuestrad.Refresh; dbMuestrad.RecNo:=Posi;
    ActualizaImporte;
    DBGrid2.SetFocus;
    //exit;
    ActuHistoclie(0);         // Actualiza histórico de clientes.
    ActuHisopcc(0);         // Actualiza histórico de operaciones.
   end
 else
   begin
    //----- Crear linea
    dbMuestrad.Append; Llenadd(); dbMuestrad.Post;
    RestarStock(Edit5.Text, Edit7.Text);
    SumarEsta(Edit5.Text,Edit7.Text,Edit11.Text);
    Limpiadd(); Edit5.SetFocus;
    Posi:=dbMuestrad.RecNo; dbMuestrad.Refresh; dbMuestrad.RecNo:=Posi;
    ActualizaImporte;
    ActuHistoclie(0);         // Actualiza histórico de clientes.
    ActuHisopcc(0);         // Actualiza histórico de operaciones.
   end;

end;

//===========================================================
//===================== NUEVA FACTURA =======================
//===========================================================
procedure TFFacturas.BitBtn9Click(Sender: TObject);
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
end;

//---------------- Ver series cuando se pasa por ellas ----------------
procedure TFFacturas.ListBox1Click(Sender: TObject);
begin
  if dbSeries.Locate('SF0',trim(copy(ListBox1.Items.Strings[ListBox1.ItemIndex],1,3)),[]) then
    Edit21.Text:=dbSeries.FieldByName('SF2').AsString;
end;

procedure TFFacturas.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key=VK_RETURN then begin key:=0; BitBtn19Click(self); end;
end;


//---------------- En el combo de cabecera
procedure TFFacturas.ComboBox1Change(Sender: TObject);
var
  SerieAVer,TxtQ: String;
begin
  //-- MID(FC19,1,250)
  SerieAVer:=  trim(copy(ComboBox1.Text,1,3));
  if ComboBox1.Text='TODAS LAS SERIES' then
     TxtQ:='SELECT *,CONVERT(FC19 USING UTF8) as FNOTAS,C1 FROM factuc'+Tienda+
           ', clientes WHERE FC0=C0 ORDER BY FC2 ASC, FC1 DESC, FC3 DESC'
  else
     TxtQ:='SELECT *,CONVERT(FC19 USING UTF8) as FNOTAS,C1 FROM factuc'+Tienda+
           ', clientes WHERE FC0=C0 AND FC2="'+SerieAVer+'" ORDER BY FC2 ASC, FC1 DESC, FC3 DESC';
  dbMuestrac.Active := False;
  dbMuestrac.Sql.Text:=TxtQ;
  dbMuestrac.Active := True;
end;

procedure TFFacturas.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then begin key:=0; BitBtn1Click(self); end;
end;

//---------------- Aceptar nueva factura ----------------
procedure TFFacturas.BitBtn19Click(Sender: TObject);
var
 iniMuestrac, finMuestrac: string;
 inicioSerie, finalSerie: integer;
begin
  SFACTURA:=dbSeries.FieldByName('SF0').AsString;
  if SFACTURA='' then begin showmessage('DEBE SELECCIONAR UNA SERIE PARA FACTURAR'); Exit; end;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM factuc'+Tienda+' WHERE FC0='+Edit1.Text+' ORDER BY FC0, FC1, FC2, FC3';
//  showmessage(dbTrabajo.SQL.Text);
  dbTrabajo.Active:=True;
  //if swhueco=0 then NumeroFactura();
  NumeroFactura();
  dbtrabajo.Append;
  dbtrabajo.FieldByName('FC0').AsString:=Edit1.Text; //-------------- Cliente.
  dbtrabajo.FieldByName('FC1').Value:=StrToDate(Edit22.Text); //----- Fecha Factura.
  dbtrabajo.FieldByName('FC2').Value:=SFACTURA; //------------------- Serie de la factura.
  dbtrabajo.FieldByName('FC3').Value:=NFACTURA; //------------------- N. Factura.
  dbtrabajo.FieldByName('FC4').Value:=0;
  dbtrabajo.FieldByName('FC5').Value:=0;
  dbtrabajo.FieldByName('FC6').Value:=dbClientes.Fields[18].AsString;//-- Descuento PP. cliente
  dbtrabajo.FieldByName('FC7').Value:=dbClientes.Fields[19].AsString;//-- Recargo S/N
  dbtrabajo.FieldByName('FC8').Value:=0;//------------------------------- Imp. Sin IVA
  dbtrabajo.FieldByName('FC9').Value:=0;//------------------------------- Imp. Con IVA
  dbtrabajo.FieldByName('FC10').Value:='N';//---------------------------- Marcada (S/N)
  dbtrabajo.FieldByName('FC20').Value:='N';//---------------------------- Fact. Rectif. (S/N)
  dbtrabajo.FieldByName('FC23').Value:='N';//---------------------------- Fact. Pagado/ Impagado
  dbtrabajo.FieldByName('FC24').Value:=dbClientes.FieldByName('C5').AsString;//---- NIF cliente

  dbtrabajo.Post;

  if checkbox4.Checked then
        begin
          iniMuestrac:=dbMuestrac.SQL.Text; finMuestrac:=iniMuestrac;
          Delete(iniMuestrac, pos('WHERE', dbMuestrac.SQL.Text)+5 , length(dbMuestrac.SQL.Text));
          Delete(finMuestrac, 1, pos('WHERE',dbMuestrac.SQL.Text)+5  );

          inicioSerie:= pos('FC2="', finMuestrac);  //Eliminamos la serie anterior si la hubiese.
          if inicioSerie <> 0 then
           begin
            finalSerie:=pos(' ', finMuestrac);
            delete(finMuestrac, inicioSerie, finalSerie-inicioSerie+5);
           end;

          dbMuestrac.Active:= false;
          dbMuestrac.SQL.Text:= iniMuestrac + ' FC2="'+SFACTURA+'" AND ' + finMuestrac;
          dbMuestrac.Active:= true;
        end;

  dbMuestrac.Refresh;
  BitBtn20Click(BitBtn20);//--- Cerrar Panel
end;

//---------------- Cancelar nueva factura ----------------
procedure TFFacturas.BitBtn20Click(Sender: TObject);
begin
  Panel8.Visible:=False; Panel1.Enabled:=True; DBGrid1.Enabled:=True;
  dbGrid1.SetFocus;
end;

//===========================================================
//================ BORRAR FACTURA COMPLETA ==================
//===========================================================
procedure TFFacturas.BitBtn10Click(Sender: TObject);
var
  TxtQ, TxtTemp: String;
begin
  If dbMuestrac.RecordCount=0 then Begin Showmessage('NO HAY NINGUNA FACTURA PARA GESTIONAR'); Exit; End;
  dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+dbMuestrac.FieldByName('FC0').AsString;
  dbClientes.Active:=True;
  If dbClientes.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL CLIENTE '+dbMuestrac.FieldByName('FC0').AsString+' ?'); Exit; End;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('CONFIRME EL BORRADO DE LA FACTURA COMPLETA?','FacturLinEx', boxstyle) = IDNO Then Exit;

  //-- MID(FD6,1,150)
  dbMuestrad.SQL.Text:='SELECT *, CONVERT(FD6 USING UTF8) As DESCRI FROM factud'+Tienda+' WHERE FD0='+dbMuestrac.FieldByName('FC0').AsString+
                     ' AND FD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
                     ' AND FD2="'+dbMuestrac.FieldByName('FC2').AsString+'"'+
                     ' AND FD3='+dbMuestrac.FieldByName('FC3').AsString;
  dbMuestrad.Active:=True;
  if dbMuestrad.RecordCount<>0 then
    begin
      while not dbMuestrad.EOF do
        begin
          //------ Sumar las cantidades al stock
          SumarStock(dbMuestrad.FieldByName('FD5').AsString, dbMuestrad.FieldByName('FD7').AsString );
          RestarEsta(dbMuestrad.FieldByName('FD5').AsString, dbMuestrad.FieldByName('FD7').AsString,
            dbMuestrad.FieldByName('FD11').AsString);

          ActuHistoClie(1);
          ActualizaImporte();
          ActuHisopcc(1);

          dbMuestrad.Next;
        end;
    end;
  //----------------- Borrar detalles de facturas
  TxtQ:='DELETE FROM factud'+Tienda+' WHERE FD0='+dbMuestrac.FieldByName('FC0').AsString+
        ' AND FD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
        ' AND FD2="'+dbMuestrac.FieldByName('FC2').AsString+'" AND FD3='+dbMuestrac.FieldByName('FC3').AsString;
  dbFactud.SQL.Text:=TxtQ; dbFactud.ExecSQL;
  //----------------- Borrar cabeceras de facturas
  ActuHisopcc(2);
  TxtTemp:=dbMuestrac.SQL.Text;
  TxtQ:='DELETE FROM factuc'+Tienda+' WHERE FC0='+dbMuestrac.FieldByName('FC0').AsString+
        ' AND FC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
        ' AND FC2="'+dbMuestrac.FieldByName('FC2').AsString+'" AND FC3='+dbMuestrac.FieldByName('FC3').AsString;
  dbFactuc.SQL.Text:=TxtQ; dbFactuc.ExecSQL;

  //dbMuestrac.Refresh;
  dbMuestrac.Active:=False;
  dbMuestrac.Sql.Text:=TxtTemp;
  dbMuestrac.Active:=True;
end;

procedure TFFacturas.BitBtn11Click(Sender: TObject);
begin

end;



//===========================================================
//=================== RECTIFICATIVAS ========================
//===========================================================
procedure TFFacturas.BitBtn27Click(Sender: TObject);
begin
  dbTrabajo.SQL.Text:='SELECT FC0,FC1,FC2,FC3,FC20 FROM factuc'+Tienda+
                      ' WHERE FC0='+dbMuestrac.FieldByName('FC0').AsString+
                      ' AND Concat(FC1,FC2,FC3)<>"'+
                      FormatDateTime('YYYY-MM-DD',dbMuestrac.FieldByName('FC1').AsDateTime)+
                      dbMuestrac.FieldByName('FC2').AsString+
                      dbMuestrac.FieldByName('FC3').AsString+
                      '" ORDER BY FC2 ASC, FC1 DESC, FC3 DESC';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then
    begin
      ShowMessage('ESTE CLIENTE NO TIENE FACTURAS PARA RECTIFICAR');
      exit;
    end;
  Panel10.Visible:=True;
  dbTrabajo.First; CheckListBox1.Items.Clear;
  while not dbTrabajo.EOF do
    begin
      CheckListBox1.Items.Add(dbTrabajo.FieldByName('FC1').AsString+'  '+
                              Space(3-Length(dbTrabajo.FieldByName('FC2').AsString))+
                              dbTrabajo.FieldByName('FC2').AsString+'-'+
                              dbTrabajo.FieldByName('FC3').AsString);
      //------ Si estaba marcada antes ver dependencias
      if dbMuestrac.FieldByName('FC20').AsString='S' then
        begin
         dbLista.SQL.Text:='SELECT * FROM facturect'+Tienda+' WHERE FR0='+
                        dbTrabajo.FieldByName('FC0').AsString+' AND '+
                        'FR4="'+FormatDateTime('YYYY/MM/DD',dbTrabajo.FieldByName('FC1').AsDateTime)+'"'+
                        ' AND FR5="'+dbTrabajo.FieldByName('FC2').AsString+'"'+
                        ' AND FR6='+dbTrabajo.FieldByName('FC3').AsString;
         dbLista.Active:=True;
         if dbLista.RecordCount<>0 then
           begin
              CheckListBox1.Checked[CheckListBox1.Items.IndexOf(
                 dbTrabajo.FieldByName('FC1').AsString+'  '+
                 Space(3-Length(dbTrabajo.FieldByName('FC2').AsString))+
                 dbTrabajo.FieldByName('FC2').AsString+'-'+
                 dbTrabajo.FieldByName('FC3').AsString)]:=True;
           end;
        end;
      dbTrabajo.Next;
    end;
end;

//-------------- Asignar rectificativas ---------------
procedure TFFacturas.CheckListBox1ItemClick(Sender: TObject; Index: integer);
begin
  if CheckListBox1.Checked[Index]=True then
    begin
      dbLista.SQL.Text:='INSERT IGNORE INTO facturect'+Tienda+' (FR0,FR1,FR2,FR3,FR4,FR5,FR6) Values '+
        '('+dbMuestrac.FieldByName('FC0').AsString+','+
        '"'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'",'+
        '"'+dbMuestrac.FieldByName('FC2').AsString+'",'+
        dbMuestrac.FieldByName('FC3').AsString+','+
        '"'+FormatDateTime('YYYY/MM/DD',StrToDate(Copy(CheckListBox1.Items.Strings[Index],1,10)))+'",'+
        '"'+Trim(Copy(CheckListBox1.Items.Strings[Index],13,2))+'",'+
        Copy(CheckListBox1.Items.Strings[Index],16,Length(CheckListBox1.Items.Strings[Index]))+')';
      dbLista.ExecSQL;
    end
  else
    begin
      dbLista.SQL.Text:='DELETE FROM facturect'+Tienda+' WHERE FR0='+
        dbMuestrac.FieldByName('FC0').AsString+' AND '+
        'FR1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'" AND '+
        'FR2="'+dbMuestrac.FieldByName('FC2').AsString+'" AND '+
        'FR3='+dbMuestrac.FieldByName('FC3').AsString+' AND '+
        'FR4="'+FormatDateTime('YYYY/MM/DD',StrToDate(Copy(CheckListBox1.Items.Strings[Index],1,10)))+'" AND '+
        'FR5="'+Trim(Copy(CheckListBox1.Items.Strings[Index],13,2))+'" AND '+
        'FR6='+Copy(CheckListBox1.Items.Strings[Index],16,Length(CheckListBox1.Items.Strings[Index]));
      dbLista.ExecSQL;
    end
end;

procedure TFFacturas.CheckListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then begin key:=0; BitBtn19Click(self); end;
end;

//--------------- Salir rectificativas ----------------
procedure TFFacturas.BitBtn28Click(Sender: TObject);
var
  Conta, Posi: Integer;
  TxtQ,Marca: String;
begin
  Panel10.Visible:=False;
  Marca:='N';
  for Conta:=0 to CheckListBox1.Items.Count-1 do
      if CheckListBox1.Checked[Conta]=True then Marca:='S';
  TxtQ:='UPDATE factuc'+Tienda+' SET FC20="'+Marca+'" WHERE FC0='+dbMuestrac.FieldByName('FC0').AsString+
        ' AND FC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
        ' AND FC2="'+dbMuestrac.FieldByName('FC2').AsString+'" AND FC3='+dbMuestrac.FieldByName('FC3').AsString;
  dbFactuc.SQL.Text:=TxtQ; dbFactuc.ExecSQL;
  Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;
end;


//=================================================================
//========================= VENCIMIENTOS ==========================
//=================================================================
procedure TFFacturas.BitBtn26Click(Sender: TObject);
begin
  Panel11.Visible:=True; Edit23.Text:=''; Edit25.Text:='';
  Edit27.Text:=''; Edit29.Text:='';
  if dbMuestrac.FieldByName('FC11').AsString<>'' then
     Edit23.Text:=FormatDateTime('DD/MM/YYYY',dbMuestrac.FieldByName('FC11').AsDateTime);
  Edit24.Text:=FormatFloat('0.00',dbMuestrac.FieldByName('FC12').AsFloat);
  if dbMuestrac.FieldByName('FC13').AsString<>'' then
     Edit25.Text:=FormatDateTime('DD/MM/YYYY',dbMuestrac.FieldByName('FC13').AsDateTime);
  Edit26.Text:=FormatFloat('0.00',dbMuestrac.FieldByName('FC14').AsFloat);
  if dbMuestrac.FieldByName('FC15').AsString<>'' then
     Edit27.Text:=FormatDateTime('DD/MM/YYYY',dbMuestrac.FieldByName('FC15').AsDateTime);
  Edit28.Text:=FormatFloat('0.00',dbMuestrac.FieldByName('FC16').AsFloat);
  if dbMuestrac.FieldByName('FC17').AsString<>'' then
     Edit29.Text:=FormatDateTime('DD/MM/YYYY',dbMuestrac.FieldByName('FC17').AsDateTime);
  Edit30.Text:=FormatFloat('0.00',dbMuestrac.FieldByName('FC18').AsFloat);

end;

//------------------- Aceptar vencimientos ----------------
procedure TFFacturas.BitBtn30Click(Sender: TObject);
var
  TxtQ: String;
  Posi: Integer;
begin
  TxtQ:='UPDATE factuc'+Tienda+' SET FC12='+Edit24.Text+',FC14='+Edit26.Text+
        ',FC16='+Edit28.Text+',FC18='+Edit30.Text;
  if Edit23.Text<>'' then TxtQ:=TxtQ+ ',FC11="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit23.Text))+'"';
  if Edit25.Text<>'' then TxtQ:=TxtQ+ ',FC13="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit25.Text))+'"';
  if Edit27.Text<>'' then TxtQ:=TxtQ+ ',FC15="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit27.Text))+'"';
  if Edit29.Text<>'' then TxtQ:=TxtQ+ ',FC17="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit29.Text))+'"';
  TxtQ:=TxtQ+' WHERE FC0='+dbMuestrac.FieldByName('FC0').AsString+
             ' AND FC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
             ' AND FC2="'+dbMuestrac.FieldByName('FC2').AsString+
             '" AND FC3='+dbMuestrac.FieldByName('FC3').AsString;
  dbFactuc.SQL.Text:=TxtQ; dbFactuc.ExecSQL;
  Panel11.Visible:=False;
  Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;
end;


//------------------- Cerrar vencimientos ----------------
procedure TFFacturas.BitBtn29Click(Sender: TObject);
begin
  Panel11.Visible:=False;
end;

//===========================================================
//================= LISTADO DE FACTURAS CABECERAS ===========
//===========================================================
procedure TFFacturas.BitBtn23Click(Sender: TObject);
begin
  Panel9.Visible:=True; Edit14.SetFocus;
  Edit14.Text:='1'; Edit16.Text:=ClienteVario;
  Edit18.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit19.Text:=FormatDateTime('DD/MM/YYYY',Date);
end;


//---------- Aceptar listado de facturas cc ----------
procedure TFFacturas.BitBtn21Click(Sender: TObject);
var
  SerieAVer, filtroSerie: String;
begin

  if (Edit14.Text='') or (Edit16.Text='') then Exit;

  SerieAVer:=  trim(copy(cbSerieListado.Text,1,3));

  if cbSerieListado.Text='TODAS LAS SERIES' then filtroSerie:=''
   else filtroSerie:=' AND FC2="'+SerieAVer+'" ';

  dbBusca.Sql.Text:='SELECT *,C1,C5 FROM factuc'+Tienda+', clientes WHERE FC0=C0'+
                    ' AND FC1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit18.Text))+'"'+
                    ' AND FC1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit19.Text))+'"'+
                    ' AND FC0>='+Edit14.Text+' AND FC0<='+Edit16.Text+
                    filtroSerie;

  if ChboxMarcadas.Checked then dbBusca.SQL.Text:=dbBusca.SQL.Text+ ' AND FC10="S"';

  dbBusca.Sql.Text:=dbBusca.Sql.Text +' ORDER BY FC2 ASC, FC1 ASC, FC3 ASC';

  dbBusca.Active := True;

  If dbBusca.RecordCount=0 then
    begin
      Showmessage('NO HAY FACTURAS ENTRE ESOS DATOS');
      exit;
    end;
  FImpresion.Imprime(dbBusca.SQL.Text, 'ListaFacturas', '');

end;

//-------------------- Desde cliente ---------------
procedure TFFacturas.Edit14Enter(Sender: TObject);
begin
   Edit15.Text:='';
end;
procedure TFFacturas.Edit14Exit(Sender: TObject);
begin
   if Edit14.Text='' then Edit14.Text:='1';
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit14.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then Begin Showmessage('ESE CLIENTE NO EXISTE.'); Edit14.SetFocus; Exit; End;
   Edit15.Text:=dbClientes.FieldByName('C1').AsString;
end;

//-------------------- Hasta cliente ---------------
procedure TFFacturas.Edit16Enter(Sender: TObject);
begin
   Edit17.Text:='';
end;
procedure TFFacturas.Edit16Exit(Sender: TObject);
begin
   if Edit16.Text='' then Edit16.Text:='99999999';
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit16.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then Begin Showmessage('ESE CLIENTE NO EXISTE.'); Edit16.SetFocus; Exit; End;
   Edit17.Text:=dbClientes.FieldByName('C1').AsString;
end;

//---------- Cerrar listado de facturas cc ----------
procedure TFFacturas.BitBtn22Click(Sender: TObject);
begin
  Panel9.Visible:=False;
end;


//===========================================================
//==================== IMPRIMIR FACTURA =====================
//===========================================================
procedure TFFacturas.BitBtn15Click(Sender: TObject);
begin

 EstadoImpresion:= FImpresion.Imprime(dbMuestrad, dbMuestrac, dbClientes, 'FACTURA',false, 1);

 if (EstadoImpresion=1) then MenuItem4Click(Self);

 if (EstadoImpresion=2) then MenuItem5Click(Self);

 if (EstadoImpresion=3) then
       begin
         MenuItem4Click(Self); EstadoImpresion:=2;
         MenuItem5Click(Self);
       end;
end;

//=================== OBSERVACIONES ==========================
procedure TFFacturas.BitBtn16Click(Sender: TObject);
begin
  Panel7.BringToFront;
  Panel7.Visible:=True;
  Memo1.Lines.Text:=dbMuestrac.FieldByName('FC19').AsString;
  Memo1.SetFocus;
end;
//--------------- Aceptar Observaciones --------
procedure TFFacturas.BitBtn18Click(Sender: TObject);
var
 Posi: Integer;
 TxtQ: String;
begin
  TxtQ:='UPDATE factuc'+Tienda +' SET FC19="'+Memo1.Lines.Text+'" WHERE FC0='+dbMuestrac.FieldByName('FC0').AsString+
        ' AND FC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
        ' AND FC2="'+dbMuestrac.FieldByName('FC2').AsString+'" AND FC3='+dbMuestrac.FieldByName('FC3').AsString;
//  showmessage(TxtQ);
  dbFactuc.SQL.Text:=TxtQ; dbFactuc.ExecSQL;
  Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;
  Panel7.SendToBack;Panel7.Visible:=False; dbGrid2.SetFocus;
end;

//--------------- Cancelar Observaciones --------
procedure TFFacturas.BitBtn17Click(Sender: TObject);
begin
  Panel7.SendToBack;Panel7.Visible:=False;dbGrid2.SetFocus;
end;


//==================== ORDENAR AL PULSAR EN EL TITULO =======================
procedure TFFacturas.DBGrid1TitleClick(Column: TColumn);
begin
   Colorea(Column,DBGrid1,dbMuestrac, AntColun, Orden, TituloColumn, Ordenado);
end;


//=============== SALIR DEL CGO. ARTICULO =====================
procedure TFFacturas.Edit5Exit(Sender: TObject);
var
  codigotmp: String;
begin
  if (Edit5.Enabled=False) or (Edit5.Text='') then exit;
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount=0 then
   begin
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
      end
     else
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


procedure TFFacturas.BitBtn24Click(Sender: TObject);
begin
  BuscaArticulo();
end;

//------------------ Buscar Articulos ---------------
procedure TFFacturas.BuscaArticulo();
begin
  Edit5.Text:=FBusquedas.IniciaBusquedas('SELECT A0, EAN0, A1 FROM artitien'+Tienda+
            ' , eans WHERE (A0=EAN1) and (A0 LIKE "%'+Edit5.Text+'%" )', ['Código','Ean','Referencia'],'A0');
  Edit5Exit(self);
end;

procedure TFFacturas.Edit6DblClick(Sender: TObject);
var
   key: char;
begin
  if Edit5.Enabled=false then exit;
  key:=#13;
  Edit6KeyPress(self, key);

end;

//------------------ Buscar Articulos ---------------
procedure TFFacturas.Edit6KeyPress(Sender: TObject; var Key: char);
begin
  if (Key<>#13) or (edit5.Enabled=false) then Exit;
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

procedure TFFacturas.ListBox3DblClick(Sender: TObject);
begin
  if not dbBusca.Locate('A1',ListBox3.Items.Strings[ListBox3.ItemIndex],[]) then begin Edit6.Text:=''; Exit; end;
  Edit5.Text:=dbBusca.Fields[0].AsString;
  Edit6.Text:=dbBusca.Fields[1].AsString;
//  Edit5Exit(Edit5);//---- Lee articulo
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;
  Pintadd();
  CargaTarifas(1);
  ListBox3.Visible:=False; Edit7.SetFocus;
end;

procedure TFFacturas.ListBox3Exit(Sender: TObject);
begin
   ListBox3.Visible:=False;
end;

procedure TFFacturas.ListBox3KeyPress(Sender: TObject; var Key: char);
begin
   if (Key=#13) then ListBox3DblClick(self);
end;

procedure TFFacturas.MenuItem1Click(Sender: TObject);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   Marca:='S';
   if dbMuestrac.FieldByName('FC10').AsString='S' then Marca:='N';
   TxtQ:='UPDATE factuc'+Tienda+' SET FC10="'+Marca+'" WHERE FC0='+dbMuestrac.FieldByName('FC0').AsString+
             ' AND FC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
        ' AND FC2="'+dbMuestrac.FieldByName('FC2').AsString+'" AND FC3='+dbMuestrac.FieldByName('FC3').AsString;
   dbFactuc.SQL.Text:=TxtQ; dbFactuc.ExecSQL;
   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;

end;

procedure TFFacturas.MenuItem2Click(Sender: TObject);
 Var
  TxtQ, Marca, Basura: String;
  Posi: Integer;
  contador: Integer;
begin
   FacturasPagadas:='';

   For contador:= 0 to DBGrid1.SelectedRows.Count-1 do
   begin
     dbMuestrac.GotoBookmark(pointer(DBGrid1.SelectedRows.Items[contador]));

     Marca:='S';

     if dbMuestrac.FieldByName('FC23').AsString='S' then  Marca:='N'
      else FacturasPagadas:= FacturasPagadas + '  ' + dbMuestrac.FieldByName('FC2').AsString +
                           '-'+dbMuestrac.FieldByName('FC3').AsString;

     TxtQ:='UPDATE factuc'+Tienda+' SET FC23="'+Marca+'" WHERE FC0='+dbMuestrac.FieldByName('FC0').AsString+
             ' AND FC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
        ' AND FC2="'+dbMuestrac.FieldByName('FC2').AsString+'" AND FC3='+dbMuestrac.FieldByName('FC3').AsString;
     dbFactuc.SQL.Text:=TxtQ; dbFactuc.ExecSQL;
   end;

   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;

   // Impresión del recibo de pago.

   if (FacturasPagadas<>'') then
     begin
      edRecibos.Text:=FacturasPagadas;
      panelRecibos.Visible:=True;
      edRecibos.SetFocus;
     end;

end;

procedure TFFacturas.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
   if ParName='EMPRESA' then ParValue := Empresa;
   if ParName='DIRECCION' then ParValue := Direccion;
   if ParName='LOCALIDAD' then ParValue := Localidad;
   if ParName='PROVINCIA' then ParValue := Provincia;
   if ParName='NIF' then ParValue := Nif;
   if ParName='TELEFONO' then ParValue := Telefono;
   if ParName='FAX' then ParValue := Fax;
   if ParName='EMAIL' then ParValue := EMail;
   if ParName='CP' then ParValue := CP;
   if ParName='TITULO' then ParValue := TituloGrid;
   if ParName='REGISTRO' then ParValue := REGISTRO;
end;


//===================== JUSTIFICANTES DE PAGO ====================

procedure TFFacturas.btRecibosCancelarClick(Sender: TObject);
begin
  panelRecibos.Visible:= False;
  Exit;
end;

procedure TFFacturas.btRecibosAceptarClick(Sender: TObject);
begin
  FacturasPagadas:= edRecibos.Text;
  panelRecibos.Visible:=False;
  showmessage('Se iniciaría el proceso de impresión del justificante con ' + #13 +
               'las facturas  : '+ FacturasPagadas);
  // frReport1.LoadFromFile(RutaReports+'.lrf');
  // frReport1.ShowReport;
  Exit;
end;


procedure TFFacturas.MenuItem3Click(Sender: TObject);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   Marca:='S';
   if dbMuestrac.FieldByName('FC20').AsString='S' then Marca:='N';
   TxtQ:='UPDATE factuc'+Tienda+' SET FC20="'+Marca+'" WHERE FC0='+dbMuestrac.FieldByName('FC0').AsString+
             ' AND FC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
        ' AND FC2="'+dbMuestrac.FieldByName('FC2').AsString+'" AND FC3='+dbMuestrac.FieldByName('FC3').AsString;
   dbFactuc.SQL.Text:=TxtQ; dbFactuc.ExecSQL;
   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;

end;

procedure TFFacturas.MenuItem4Click(Sender: TObject);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   Marca:='S';
   if (dbMuestrac.FieldByName('FC25').AsString='S') and (EstadoImpresion=0) then Marca:='N';
   TxtQ:='UPDATE factuc'+Tienda+' SET FC25="'+Marca+'" WHERE FC0='+dbMuestrac.FieldByName('FC0').AsString+
             ' AND FC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
        ' AND FC2="'+dbMuestrac.FieldByName('FC2').AsString+'" AND FC3='+dbMuestrac.FieldByName('FC3').AsString;
   dbFactuc.SQL.Text:=TxtQ; dbFactuc.ExecSQL;

   EstadoImpresion:=0;

   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;


end;

procedure TFFacturas.MenuItem5Click(Sender: TObject);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   Marca:='S';
   if (dbMuestrac.FieldByName('FC26').AsString='S') and (EstadoImpresion=0) then Marca:='N';
   TxtQ:='UPDATE factuc'+Tienda+' SET FC26="'+Marca+'" WHERE FC0='+dbMuestrac.FieldByName('FC0').AsString+
             ' AND FC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
        ' AND FC2="'+dbMuestrac.FieldByName('FC2').AsString+'" AND FC3='+dbMuestrac.FieldByName('FC3').AsString;
   dbFactuc.SQL.Text:=TxtQ; dbFactuc.ExecSQL;

   EstadoImpresion:=0;

   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;


end;


procedure TFFacturas.EntraEnEdit(Sender: TObject);
begin
  ValorInicial:= TEdit(ActiveControl).Text;

end;

//===================== CARGA VALORES EN LOS EDIT =====
procedure TFFacturas.CargaValores();
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
procedure TFFacturas.CargaVariables();
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
procedure TFFacturas.ActivaPrecios();
begin
  Edit8.Color:=clWindow;
  Edit9.Color:=clWindow;
  Edit8.Enabled:=True;
  Edit9.Enabled:=True;
  lbActivarPrecios.Visible:=False;
end;

//===================== ENTRAR/SALIR DE LA CANTIDAD ======================

function TFFacturas.HayStock: boolean;
begin

  if RoturaStock='N' then exit;

  result:= true;

  if (StrToFloat(Edit7.Text)> dbArti.FieldByName('A4').Value) then
      begin
        DataModule1.Mensaje('AVISO','No existe stock suficiente, sólo hay '+
                          dbArti.FieldByName('A4').AsString+ ' unidades', 3000 ,clGray);
        result:=false;
      end;

end;

procedure TFFacturas.Edit7Enter(Sender: TObject);
begin
  Edit7.Text:= FormatFloat(MascaraDecimales,CantidadLinea);
end;

procedure TFFacturas.Edit7Exit(Sender: TObject);
begin
  if not (EsFloat(Edit7.Text)) then begin Edit7.Text:='0';Edit7.SetFocus; exit; end;

  HayStock;

  CantidadLinea:= StrToFloat(Edit7.Text);
  SalirCantidad(self);

  CargaValores();
end;

procedure TFFacturas.Edit7KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) and (Edit5.Enabled=true) then Edit5.SetFocus;
end;


//======================= SALIR DE TARIFA ==================

procedure TFFacturas.Edit31Exit(Sender: TObject);
begin
   if not (EsFloat(Edit31.Text)) then begin Edit31.Text:='0'; Edit31.SetFocus; exit; end;
end;


//======================= ENTRAR/SALIR DEL PRECIO ==================

procedure TFFacturas.Edit8Enter(Sender: TObject);
begin
   Edit8.Text:= FormatFloat(MascaraDecimales,PrecioConIva);
   EntraEnEdit(self);
   Edit8.SetFocus;
end;

procedure TFFacturas.Edit8Exit(Sender: TObject);
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

procedure TFFacturas.Edit9DblClick(Sender: TObject);
begin
  MuestraTarifas();
end;

//======================= ENTRAR/SALIR DEL PRECIO SIN IVA ====================
procedure TFFacturas.Edit9Enter(Sender: TObject);
begin
   Edit9.Text:= FormatFloat(MascaraDecimales,PrecioSinIva);
   EntraEnEdit(self);
   Edit9.SetFocus;
end;

procedure TFFacturas.Edit9Exit(Sender: TObject);
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
procedure TFFacturas.Edit10Enter(Sender: TObject);
begin
   Edit10.Text:= FormatFloat('0.##',DescuentoLinea);
end;

procedure TFFacturas.Edit10Exit(Sender: TObject);
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
procedure TFFacturas.Edit12Enter(Sender: TObject);
begin
  Edit12.Text:= FormatFloat('0.##',IvaLinea);
end;

procedure TFFacturas.Edit12Exit(Sender: TObject);
begin
  if not (EsFloat(Edit12.Text)) then begin Edit12.Text:='0'; Edit12.SetFocus; exit; end;
 // if (Edit7.Text='') or (Edit7.Text='0') then begin Edit7.Text:='0'; Exit; end;//------ Cant.
 // if (Edit8.Text='') or (Edit8.Text='0') then begin Edit8.Text:='0'; Exit; end;//------ Precio
 // if (Edit11.Text='') or (Edit11.Text='0') then begin Edit11.Text:='0'; Exit; end;//--- Importe

  IvaLinea:= StrToFloat(Edit12.Text);

  SalirIva(self);

  CargaValores()

end;


//================  Muestra histórico de compras del cliente =========
procedure TFFacturas.HistCliente(Sender: TObject);
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
       0:inutil:=FBusquedas.IniciaBusquedas('SELECT HC0, HC1, HC8, HC9, HC4, CONVERT(HC5 USING UTF8), HC6, (HC7/HC6) as Precio FROM histoclie WHERE HC0='+dbMuestrac.FieldByName('FC0').AsString
                        , ['Cliente','Fecha','Serie','Número','Código','Descripción','Und','Precio'],'HC1');

       1:inutil:=FBusquedas.IniciaBusquedas('SELECT HOD6, CONVERT(HOD7 USING UTF8), HOD8, HOD9,HOD11,HOD4, HOD3 FROM hisopdd'+Tienda+
               ' WHERE HOD6="'+codigo+'"', ['CODIGO','DESCRIPCION','CANTIDAD','PRECIO','DCT%','SERIE','NUMERO'],'HOD6');

       2:inutil:=FBusquedas.IniciaBusquedas('SELECT HC0, HC1, HC8, HC9, HC4, CONVERT(HC5 USING UTF8), HC6, (HC7/HC6) as Precio FROM histoclie '+
                ' WHERE HC0='+dbMuestrac.FieldByName('FC0').AsString + ' and HC4="' + codigo + '"', ['Cliente','Fecha','Serie','Número','Código','Descripción','Und','Precio'],'HC1');

 end;

 Edit8.SetFocus;

end;

//==================== PINTAR DATOS DE CLIENTES ======================
procedure TFFacturas.PintaCliente();
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
procedure TFFacturas.LimpiaCliente();
begin
  Label4.Caption:=''; Label5.Caption:=''; Label6.Caption:='';
  Label7.Caption:=''; Label8.Caption:=''; Label9.Caption:='';
  Label10.Caption:=''; LabelTotal.Caption:='0.00';
end;
//==================== LLENAR DATOS LINEAS =======================
procedure TFFacturas.Llenadd();
begin
  // -- Si esta creando nueva
  if Edit5.Enabled=true then
    begin
     dbMuestrad.FieldByName('FD0').Value:=dbMuestrac.FieldByName('FC0').Value;//---- Cliente
     dbMuestrad.FieldByName('FD1').Value:=dbMuestrac.FieldByName('FC1').Value;//---- Fecha
     dbMuestrad.FieldByName('FD2').Value:=dbMuestrac.FieldByName('FC2').Value;//---- Serie
     dbMuestrad.FieldByName('FD3').Value:=dbMuestrac.FieldByName('FC3').Value;//---- Numero
     dbMuestrad.FieldByName('FD4').Value:=VerUltimaLinea;//---- N. Linea
     label42.Caption:=' Añadiendo nuevas líneas. ';
     dbMuestrad.FieldByName('FD5').AsString:=Edit5.Text;//----- Codigo
    end;
  dbMuestrad.FieldByName('FD6').AsString:=Edit6.Text;//-------- Descripcion

  dbMuestrad.FieldByName('FD7').AsFloat:=CantidadLinea;//-------- Cantidad
  dbMuestrad.FieldByName('FD8').AsFloat:=PrecioConIva;//-------- Precio con IVA
  dbMuestrad.FieldByName('FD9').AsFloat:=PrecioSinIva;//-------- Precio sin IVA
  dbMuestrad.FieldByName('FD10').AsFloat:=DescuentoLinea;//------ Dto. %
  dbMuestrad.FieldByName('FD11').AsFloat:=TotalSinIvaLinea;//------ Importe sin IVA
  dbMuestrad.FieldByName('FD12').AsFloat:=IvaLinea;//------ IVA
  dbMuestrad.FieldByName('FD13').AsFloat:=TotalLinea;//------ Importe con IVA
  dbMuestrad.FieldByName('FD17').AsString:=Edit23.Text;//------ Precio Tarifa.

end;

//=================== SACAR EL ULT N. DE LINEA =====================
function TFFacturas.VerUltimaLinea: Integer;
begin
  VerUltimaLinea:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(FD4) As ULTIMA FROM factud'+Tienda+' WHERE FD0='+dbMuestrac.FieldByName('FC0').AsString+
                     ' AND FD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
                     ' AND FD2="'+dbMuestrac.FieldByName('FC2').AsString+'"'+
                     ' AND FD3='+dbMuestrac.FieldByName('FC3').AsString;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLinea:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;

//======================= PINTAR DATOS LINEAS ==================
procedure TFFacturas.Pintadd();
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
  Edit31.Text:= FormatFloat('0.###',PrecioConIva);//---- Precio Tarifa.

  CargaValores()

end;

//======================= LIMPIAR DATOS LINEAS ==================
procedure TFFacturas.Limpiadd();
begin
  Edit5.Text:=''; Edit6.Text:=''; Edit7.Text:='0';
  Edit8.Text:='0'; Edit9.Text:='0'; Edit10.Text:='0';
  Edit11.Text:='0'; Edit12.Text:='0'; Edit13.Text:='0';
  Edit31.Text:='0';  ListBox2.Items.Clear;
  TotalLinea:= 0;
  CantidadLinea:= 0;
  PrecioConIva:= 0;
  PrecioSinIva:= 0;
  IvaLinea:= 0;
  DescuentoLinea:= 0;
  TotalSinIvaLinea:= 0;
  ActivaPrecios();
end;

//================= N. DE FACTURA ===========================
procedure TFFacturas.NumeroFactura();
begin
  if SFACTURA='' then begin SFACTURA:='';NFACTURA:=0; Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF2=SF2+1 WHERE SF0="'+SFACTURA+'"';
  dbSeries.ExecSql;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+SFACTURA+'"';
  dbSeries.Active:=True;
  if dbSeries.Recordcount=0 then exit;
//  SFACTURA:=dbSeries.Fields[0].AsString;
  NFACTURA:=dbSeries.Fields[2].Value;
  dbSeries.Active:=False;
end;


//======================== RESTAR STOCK =======================
procedure TFFacturas.RestarStock(Codigo, Cantidad: String);
begin
  dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A4=A4-'+Cantidad+' WHERE A0="'+Codigo+'"';
  dbArti.ExecSQL;
end;
//======================== SUMAR STOCK =======================
procedure TFFacturas.SumarStock(Codigo, Cantidad: String);
begin
  dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A4=A4+'+Cantidad+' WHERE A0="'+Codigo+'"';
  dbArti.ExecSQL;
end;

//======================== RESTAR ESTADISTICAS =======================
procedure TFFacturas.RestarEsta(Codigo, Cantidad, Precio: String);
var
  Departa, TxtQ, Costo: String;
begin
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Codigo+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount=0 then Costo:='0' else Costo:=dbArti.FieldByName('A24').AsString;
  Costo:=FloatToStr(StrToFloat(Cantidad)*StrToFloat(Costo));
  //------------------- Articulos
  TxtQ:='UPDATE artitien'+Tienda+' SET A12="'+FormatDateTime('YYYY/MM/DD',Date)+'" WHERE A0="'+Codigo+'"';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Estadistica de articulos
  dbTrabajo.SQL.Text:='SELECT * from estaarti'+Tienda+' WHERE TA0="'+Codigo+'"'+
                     ' AND TA1='+FormatDateTime('YYYY',Date)+' AND TA2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estaarti'+Tienda+' SET TA5=TA5-'+Cantidad+
          ', TA6=TA6-'+Precio+', TA7=TA7-'+Costo+' WHERE TA0="'+Codigo+'"'+
          ' AND TA1='+FormatDateTime('YYYY',Date)+' AND TA2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estaarti'+Tienda+' (TA0,TA1,TA2,TA5,TA6,TA7) VALUES ("'+
          Codigo+'",'+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+FloatToStr(StrToFloat(Cantidad)*-1)+','+FloatToStr(StrToFloat(Precio)*-1)+
          ','+FloatToStr(StrToFloat(Costo)*-1)+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Estadistica de clientes
  dbTrabajo.SQL.Text:='SELECT * from estaclie WHERE CC0='+dbMuestrac.FieldByName('FC0').AsString+
                     ' AND CC1='+FormatDateTime('YYYY',Date)+' AND CC2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estaclie SET CC5=CC5-'+Cantidad+
          ', CC6=CC6-'+Precio+', CC7=CC7-'+Costo+' WHERE CC0="'+dbMuestrac.FieldByName('FC0').AsString+'"'+
          ' AND CC1='+FormatDateTime('YYYY',Date)+' AND CC2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estaclie (CC0,CC1,CC2,CC5,CC6,CC7) VALUES ("'+
          dbMuestrac.FieldByName('FC0').AsString+'",'+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+FloatToStr(StrToFloat(Cantidad)*-1)+','+FloatToStr(StrToFloat(Precio)*-1)+
          ','+FloatToStr(StrToFloat(Costo)*-1)+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Tiendas
  TxtQ:='UPDATE tiendas SET T9="'+FormatDateTime('YYYY/MM/DD',Date)+'" WHERE T0='+NTienda;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Estadistica de tiendas
  dbTrabajo.SQL.Text:='SELECT * from estatien'+Tienda+' WHERE TT0='+NTienda+
                     ' AND TT1='+FormatDateTime('YYYY',Date)+' AND TT2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estatien'+Tienda+' SET TT5=TT5-'+Cantidad+
          ', TT6=TT6-'+Precio+', TT7=TT7-'+Costo+' WHERE TT0='+NTienda+
          ' AND TT1='+FormatDateTime('YYYY',Date)+' AND TT2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estatien'+Tienda+' (TT0,TT1,TT2,TT5,TT6,TT7) VALUES ('+
          NTienda+','+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+FloatToStr(StrToFloat(Cantidad)*-1)+','+FloatToStr(StrToFloat(Precio)*-1)+
          ','+FloatToStr(StrToFloat(Costo)*-1)+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;

  //TODO: Falta estadistica de usuarios y historico de compras de clientes

  //------------------- Proveedores
  if dbArti.FieldByName('A32').AsString<>'' then
    begin
     dbTrabajo.SQL.Text:='SELECT * from proveedores WHERE P0='+dbArti.FieldByName('A32').AsString;
     dbTrabajo.Active:=True;
     if dbTrabajo.RecordCount<>0 then
       begin
         TxtQ:='UPDATE proveedores SET P22="'+FormatDateTime('YYYY/MM/DD',Date)+
               '" WHERE P0='+dbArti.FieldByName('A32').AsString;
         dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
         //------------------- Estadistica de proveedores
         dbTrabajo.SQL.Text:='SELECT * from estaprove WHERE PP0='+dbArti.FieldByName('A32').AsString+
                             ' AND PP1='+FormatDateTime('YYYY',Date)+' AND PP2='+FormatDateTime('MM',Date);
         dbTrabajo.Active:=True;
         if dbTrabajo.RecordCount<>0 then
           TxtQ:='UPDATE estaprove SET PP5=PP5-'+Cantidad+
                 ', PP6=PP6-'+Precio+', PP7=PP7-'+Costo+' WHERE PP0='+dbArti.FieldByName('A32').AsString+
                 ' AND PP1='+FormatDateTime('YYYY',Date)+' AND PP2='+FormatDateTime('MM',Date)
         else
           TxtQ:='INSERT INTO estaprove (PP0,PP1,PP2,PP5,PP6,PP7) VALUES ('+dbArti.FieldByName('A32').AsString+
                 ','+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
                 ','+FloatToStr(StrToFloat(Cantidad)*-1)+','+FloatToStr(StrToFloat(Precio)*-1)+
                 ','+FloatToStr(StrToFloat(Costo)*-1)+')';
         dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
       end;
    end;
  //------------------- Familias
  if dbArti.FieldByName('A14').AsString<>'' then
    begin
     dbTrabajo.SQL.Text:='SELECT * from familias'+Tienda+' WHERE F0='+dbArti.FieldByName('A14').AsString;
     dbTrabajo.Active:=True;
     if dbTrabajo.RecordCount<>0 then
        begin
          Departa:=dbTrabajo.FieldByName('F2').AsString;
          TxtQ:='UPDATE familias'+Tienda+' SET F3="'+FormatDateTime('YYYY/MM/DD',Date)+
                '" WHERE F0='+dbArti.FieldByName('A14').AsString;
          dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
          //------ Departamentos
          if Departa<>'' then
            begin
              dbTrabajo.SQL.Text:='SELECT * from departamentos'+Tienda+' WHERE D0='+Departa;
              dbTrabajo.Active:=True;
              if dbTrabajo.RecordCount<>0 then
                 begin
                   TxtQ:='UPDATE departamentos'+Tienda+' SET D2="'+FormatDateTime('YYYY/MM/DD',Date)+
                      '" WHERE D0='+Departa;
                   dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
                 end;
            end;

          //-----------------Estadisticas Familia
          dbTrabajo.SQL.Text:='SELECT * from estafami'+Tienda+' WHERE FF0='+dbArti.FieldByName('A14').AsString+
                              ' AND FF1='+FormatDateTime('YYYY',Date)+' AND FF2='+FormatDateTime('MM',Date);
          dbTrabajo.Active:=True;
          if dbTrabajo.RecordCount<>0 then
            TxtQ:='UPDATE estafami'+Tienda+' SET FF5=FF5-'+Cantidad+
                  ', FF6=FF6-'+Precio+', FF7=FF7-'+Costo+' WHERE FF0='+dbArti.FieldByName('A14').AsString+
                  ' AND FF1='+FormatDateTime('YYYY',Date)+' AND FF2='+FormatDateTime('MM',Date)
          else
            TxtQ:='INSERT INTO estafami'+Tienda+' (FF0,FF1,FF2,FF5,FF6,FF7) VALUES ('+
                  dbArti.FieldByName('A14').AsString+','+FormatDateTime('YYYY',Date)+','+
                  FormatDateTime('MM',Date)+','+FloatToStr(StrToFloat(Cantidad)*-1)+','+
                  FloatToStr(StrToFloat(Precio)*-1)+','+FloatToStr(StrToFloat(Costo)*-1)+')';
          dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
          //-----------------Estadisticas Departamentos
          if Departa<>'' then
            begin
             dbTrabajo.SQL.Text:='SELECT * from estadepa'+Tienda+' WHERE DD0='+Departa+
                                 ' AND DD1='+FormatDateTime('YYYY',Date)+' AND DD2='+FormatDateTime('MM',Date);
             dbTrabajo.Active:=True;
             if dbTrabajo.RecordCount<>0 then
               TxtQ:='UPDATE estadepa'+Tienda+' SET DD5=DD5-'+Cantidad+
                     ', DD6=DD6-'+Precio+', DD7=DD7-'+Costo+' WHERE DD0='+Departa+
                     ' AND DD1='+FormatDateTime('YYYY',Date)+' AND DD2='+FormatDateTime('MM',Date)
             else
               TxtQ:='INSERT INTO estadepa'+Tienda+' (DD0,DD1,DD2,DD5,DD6,DD7) VALUES ('+
                     Departa+','+FormatDateTime('YYYY',Date)+','+
                     FormatDateTime('MM',Date)+','+FloatToStr(StrToFloat(Cantidad)*-1)+','+
                     FloatToStr(StrToFloat(Precio)*-1)+','+FloatToStr(StrToFloat(Costo)*-1)+')';
             dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
            end;
        end;
    end;
  dbArti.Active:=False;
end;

//======================== SUMAR ESTADISTICAS =======================
procedure TFFacturas.SumarEsta(Codigo, Cantidad, Precio: String);
var
  Departa, TxtQ, Costo: String;
begin
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Codigo+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount=0 then Costo:='0' else Costo:=dbArti.FieldByName('A24').AsString;
  Costo:=FloatToStr(StrToFloat(Cantidad)*StrToFloat(Costo));
  //------------------- Articulos
  TxtQ:='UPDATE artitien'+Tienda+' SET A12="'+FormatDateTime('YYYY/MM/DD',Date)+'" WHERE A0="'+Codigo+'"';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Estadistica de articulos
  dbTrabajo.SQL.Text:='SELECT * from estaarti'+Tienda+' WHERE TA0="'+Codigo+'"'+
                     ' AND TA1='+FormatDateTime('YYYY',Date)+' AND TA2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estaarti'+Tienda+' SET TA5=TA5+'+Cantidad+
          ', TA6=TA6+'+Precio+', TA7=TA7+'+Costo+' WHERE TA0="'+Codigo+'"'+
          ' AND TA1='+FormatDateTime('YYYY',Date)+' AND TA2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estaarti'+Tienda+' (TA0,TA1,TA2,TA5,TA6,TA7) VALUES ("'+
          Codigo+'",'+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+Cantidad+','+Precio+','+Costo+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Clientes
  dbTrabajo.SQL.Text:='SELECT * from estaclie WHERE CC0="'+dbMuestrac.FieldByName('FC0').AsString+'"'+
                     ' AND CC1='+FormatDateTime('YYYY',Date)+' AND CC2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estaclie SET CC5=CC5+'+Cantidad+
          ', CC6=CC6+'+Precio+', CC7=CC7+'+Costo+' WHERE CC0="'+dbMuestrac.FieldByName('FC0').AsString+'"'+
          ' AND CC1='+FormatDateTime('YYYY',Date)+' AND CC2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estaclie (CC0,CC1,CC2,CC5,CC6,CC7) VALUES ("'+
          dbMuestrac.FieldByName('FC0').AsString+'",'+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+Cantidad+','+Precio+','+Costo+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Tiendas
  TxtQ:='UPDATE tiendas SET T9="'+FormatDateTime('YYYY/MM/DD',Date)+'" WHERE T0='+NTienda;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Estadistica de tiendas
  dbTrabajo.SQL.Text:='SELECT * from estatien'+Tienda+' WHERE TT0='+NTienda+
                     ' AND TT1='+FormatDateTime('YYYY',Date)+' AND TT2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estatien'+Tienda+' SET TT5=TT5+'+Cantidad+
          ', TT6=TT6+'+Precio+', TT7=TT7+'+Costo+' WHERE TT0='+NTienda+
          ' AND TT1='+FormatDateTime('YYYY',Date)+' AND TT2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estatien'+Tienda+' (TT0,TT1,TT2,TT5,TT6,TT7) VALUES ('+
          NTienda+','+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+Cantidad+','+Precio+','+Costo+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;

  //TODO: Falta estadistica de usuarios y historico de compras de clientes

  //------------------- Proveedores
  if dbArti.FieldByName('A32').AsString<>'' then
    begin
     dbTrabajo.SQL.Text:='SELECT * from proveedores WHERE P0='+dbArti.FieldByName('A32').AsString;
     dbTrabajo.Active:=True;
     if dbTrabajo.RecordCount<>0 then
       begin
         TxtQ:='UPDATE proveedores SET P22="'+FormatDateTime('YYYY/MM/DD',Date)+
               '" WHERE P0='+dbArti.FieldByName('A32').AsString;
         dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
         //------------------- Estadistica de proveedores
         dbTrabajo.SQL.Text:='SELECT * from estaprove WHERE PP0='+dbArti.FieldByName('A32').AsString+
                             ' AND PP1='+FormatDateTime('YYYY',Date)+' AND PP2='+FormatDateTime('MM',Date);
         dbTrabajo.Active:=True;
         if dbTrabajo.RecordCount<>0 then
           TxtQ:='UPDATE estaprove SET PP5=PP5+'+Cantidad+
                 ', PP6=PP6+'+Precio+', PP7=PP7+'+Costo+' WHERE PP0='+dbArti.FieldByName('A32').AsString+
                 ' AND PP1='+FormatDateTime('YYYY',Date)+' AND PP2='+FormatDateTime('MM',Date)
         else
           TxtQ:='INSERT INTO estaprove (PP0,PP1,PP2,PP5,PP6,PP7) VALUES ('+dbArti.FieldByName('A32').AsString+
                 ','+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
                 ','+Cantidad+','+Precio+','+Costo+')';
         dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
       end;
    end;
  //------------------- Familias
  if dbArti.FieldByName('A14').AsString<>'' then
    begin
     dbTrabajo.SQL.Text:='SELECT * from familias'+Tienda+' WHERE F0='+dbArti.FieldByName('A14').AsString;
     dbTrabajo.Active:=True;
     if dbTrabajo.RecordCount<>0 then
        begin
          Departa:=dbTrabajo.FieldByName('F2').AsString;
          TxtQ:='UPDATE familias'+Tienda+' SET F3="'+FormatDateTime('YYYY/MM/DD',Date)+
                '" WHERE F0='+dbArti.FieldByName('A14').AsString;
          dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
          //------ Departamentos
          if Departa<>'' then
            begin
              dbTrabajo.SQL.Text:='SELECT * from departamentos'+Tienda+' WHERE D0='+Departa;
              dbTrabajo.Active:=True;
              if dbTrabajo.RecordCount<>0 then
                 begin
                   TxtQ:='UPDATE departamentos'+Tienda+' SET D2="'+FormatDateTime('YYYY/MM/DD',Date)+
                      '" WHERE D0='+Departa;
                   dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
                 end;
            end;
          //-----------------Estadisticas Familia
          dbTrabajo.SQL.Text:='SELECT * from estafami'+Tienda+' WHERE FF0='+dbArti.FieldByName('A14').AsString+
                              ' AND FF1='+FormatDateTime('YYYY',Date)+' AND FF2='+FormatDateTime('MM',Date);
          dbTrabajo.Active:=True;
          if dbTrabajo.RecordCount<>0 then
            TxtQ:='UPDATE estafami'+Tienda+' SET FF5=FF5+'+Cantidad+
                  ', FF6=FF6+'+Precio+', FF7=FF7+'+Costo+' WHERE FF0='+dbArti.FieldByName('A14').AsString+
                  ' AND FF1='+FormatDateTime('YYYY',Date)+' AND FF2='+FormatDateTime('MM',Date)
          else

            TxtQ:='INSERT INTO estafami'+Tienda+' (FF0,FF1,FF2,FF5,FF6,FF7) VALUES ('+
                  dbArti.FieldByName('A14').AsString+','+FormatDateTime('YYYY',Date)+','+
                  FormatDateTime('MM',Date)+','+Cantidad+','+Precio+','+Costo+')';
          dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
          //-----------------Estadisticas Departamentos
          if Departa<>'' then
            begin
             dbTrabajo.SQL.Text:='SELECT * from estadepa'+Tienda+' WHERE DD0='+Departa+
                                 ' AND DD1='+FormatDateTime('YYYY',Date)+' AND DD2='+FormatDateTime('MM',Date);
             dbTrabajo.Active:=True;
             if dbTrabajo.RecordCount<>0 then
               TxtQ:='UPDATE estadepa'+Tienda+' SET DD5=DD5+'+Cantidad+
                     ', DD6=DD6+'+Precio+', DD7=DD7+'+Costo+' WHERE DD0='+Departa+
                     ' AND DD1='+FormatDateTime('YYYY',Date)+' AND DD2='+FormatDateTime('MM',Date)
             else
               TxtQ:='INSERT INTO estadepa'+Tienda+' (DD0,DD1,DD2,DD5,DD6,DD7) VALUES ('+
                     Departa+','+FormatDateTime('YYYY',Date)+','+
                     FormatDateTime('MM',Date)+','+Cantidad+','+Precio+','+Costo+')';
             dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
            end;
        end;
    end;
  dbArti.Active:=False;
end;


//======================= Hist. Operaciones Cab =====================
procedure TFFacturas.ActuHisopcc(Modo: integer);   // Modo=1 -> Linea borrada
var
  TxtQ: String;
begin

{ TODO: Falta asignar el numero de usuario que cierra la operacion }

  dbHisopcc.Active:=False;
  TxtQ:='SELECT * FROM hisopcc'+Tienda+' WHERE HO0="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
        ' AND HO2="'+Puesto+'"'+
        ' AND HO3='+dbMuestrac.FieldByName('FC3').AsString+
        ' AND HO4="'+dbMuestrac.FieldByName('FC2').AsString+
        '" AND HO5="FA"';
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
           dbHisopcc.FieldByName('HO18').Value:=dbMuestrac.FieldByName('FC19').Value; //--Observaciones.
           dbHisopcc.Post;
        end;
      dbHisopdd.Active:=False;
      TxtQ:='SELECT * FROM hisopdd'+Tienda+' WHERE HOD0="'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('FD1').AsDateTime)+'"'+
            ' AND HOD2="'+Puesto+'"'+
            ' AND HOD3='+dbMuestrad.FieldByName('FD3').AsString+
            ' AND HOD4="'+dbMuestrad.FieldByName('FD2').AsString+
            '" AND HOD5='+dbMuestrad.FieldByName('FD4').AsString+' AND HOD23=0';

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

   dbHisopcc.FieldByName('HO0').AsString:=dbMuestrac.FieldByName('FC1').AsString; //FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime);//-- Fecha
   dbHisopcc.FieldByName('HO1').AsString:=FormatDateTime('HH:MM:SS',Time);//-- Hora
   dbHisopcc.FieldByName('HO2').Value:=Puesto;//--- Puesto
   dbHisopcc.FieldByName('HO3').Value:=dbMuestrac.FieldByName('FC3').Value;//- N.Albarán
   dbHisopcc.FieldByName('HO4').Value:=dbMuestrac.FieldByName('FC2').Value;//- Serie Albarán.
   dbHisopcc.FieldByName('HO5').Value:='FA';//----- Tipo operacion
   dbHisopcc.FieldByName('HO6').Value:='FACTURADO';//------- Tipo de pago.
   dbHisopcc.FieldByName('HO7').Value:=1;//----------------- Usuario
   dbHisopcc.FieldByName('HO8').Value:=dbMuestrac.FieldByName('FC0').Value;//----- Cgo. Cliente
   dbHisopcc.FieldByName('HO9').Value:=dbMuestrac.FieldByName('FC9').AsFloat;//--- Importe total
   dbHisopcc.FieldByName('HO10').Value:=0;//-- % Dto.
   dbHisopcc.FieldByName('HO11').Value:=dbMuestrac.FieldByName('FC9').AsFloat;//-- Importe total con Dto.
   dbHisopcc.FieldByName('HO12').Value:=dbMuestrac.FieldByName('FC9').AsFloat;//-- Entrega
   dbHisopcc.FieldByName('HO13').Value:=0;//-- Cambio
   dbHisopcc.FieldByName('HO14').Value:=0;//-- Entrega Tarjeta
   dbHisopcc.FieldByName('HO15').Value:='N';//-- Marcada S/N
   dbHisopcc.FieldByName('HO16').Value:='N';//-- Estado del documento Normal.
   dbHisopcc.FieldByName('HO18').Value:=dbMuestrac.FieldByName('FC19').Value; //--Observaciones.
   dbHisopcc.FieldByName('HO19').Value:=dbMuestrac.FieldByName('FC24').AsString;//--- CIF;

   dbHisopcc.Post; dbHisopcc.Active:=False;
   Hora:= Time;

   ActuHisopdd();


end;

//======================= Hist. Operaciones Det =====================
procedure TFFacturas.ActuHisopdd();
var
  TxtQ: String;
begin
  //------------------- Historico de operaciones detalles
  dbHisopdd.Active:=False;
  TxtQ:='INSERT INTO hisopdd'+Tienda+' (HOD0,HOD1,HOD2,HOD3,HOD4,HOD5,HOD6,HOD7,HOD8,HOD9,HOD10,HOD11'+
        ',HOD12,HOD13,HOD14,HOD15,HOD16, HOD22) VALUES ("'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('FD1').AsDateTime)+'",'+
        '"'+FormatDateTime('HH:MM:SS',Hora)+'","'+Puesto+'",'+dbMuestrad.FieldByName('FD3').AsString+',"'+
        dbMuestrad.FieldByName('FD2').AsString+'",'+dbMuestrad.FieldByName('FD4').AsString+',"'+
        dbMuestrad.FieldByName('FD5').AsString+'","'+dbMuestrad.FieldByName('FD6').AsString+'",'+
        dbMuestrad.FieldByName('FD7').AsString+','+dbMuestrad.FieldByName('FD8').AsString+','+
        dbMuestrad.FieldByName('FD9').AsString+','+dbMuestrad.FieldByName('FD10').AsString+','+
        dbMuestrad.FieldByName('FD11').AsString+','+dbMuestrad.FieldByName('FD12').AsString+','+
        dbMuestrad.FieldByName('FD13').AsString+',"","'+dbMuestrad.FieldByName('FD15').AsString+'",'+
        dbMuestrad.FieldByName('FD17').AsString+')';
  dbHisopdd.SQL.Text:=TxtQ; dbHisopdd.ExecSQL;
end;


procedure TFFacturas.ActuHistoclie(Modo: integer);  //Modo=1 borrar línea.
var
   TxtQ: string;
begin
  //------------------- Histórico de compras de clientes
  dbTrabajo.Active:=False;
  TxtQ:='SELECT * FROM histoclie WHERE HC0="'+dbMuestrad.FieldByName('FD0').AsString+
        '" AND HC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('FD1').AsDateTime)+
        '" AND HC3="'+dbMuestrad.FieldByName('FD4').AsString+
        '" AND HC8="'+dbMuestrad.FieldByName('FD2').AsString+
        '" AND HC9='+dbMuestrad.FieldByName('FD3').AsString;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.Active:=True;

  if (dbTrabajo.RecordCount=0) then
      begin
         if Modo=1 then exit;
         TxtQ:='INSERT INTO histoclie (HC0,HC1,HC2,HC3,HC4,HC5,HC6,HC7,HC8,HC9) VALUES ("'+
         dbMuestrac.FieldByName('FC0').AsString+'","'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('FD1').AsDateTime)+'","'+
         FormatDateTime('HH:MM:SS',Time)+'",'+dbMuestrad.FieldByName('FD4').AsString+
         ',"'+dbMuestrad.FieldByName('FD5').AsString+'","'+dbMuestrad.FieldByName('FD6').AsString+
         '",'+dbMuestrad.FieldByName('FD7').AsString+','+dbMuestrad.FieldByName('FD13').AsString+',"'+
         dbMuestrad.FieldByName('FD2').AsString+'",'+dbMuestrad.FieldByName('FD3').AsString+')';
         dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
         Exit
      end;

  if Modo=1 then begin dbTrabajo.Delete; Exit; end;

  dbTrabajo.Edit;
  dbTrabajo.FieldByName('HC4').AsString:=dbMuestrad.FieldByName('FD5').AsString;
  dbTrabajo.FieldByName('HC5').AsString:=dbMuestrad.FieldByName('FD6').AsString;
  dbTrabajo.FieldByName('HC6').Value:=dbMuestrad.FieldByName('FD7').AsFloat;
  dbTrabajo.FieldByName('HC7').Value:=dbMuestrad.FieldByName('FD13').AsFloat;
  dbTrabajo.Post;

end;

//======== CARGA PRECIOS Y DESCUENTOS DEL ARTICULO ==============
procedure TFFacturas.CargaTarifas(actualiza: integer);
begin

  dbTarifas.Active:=false;
  dbTarifas.SQL.Text:='select * from tarifas where TAR0="'+dbarti.FieldByName('A0').AsString +'"';

  if actualiza=0 then dbTarifas.SQL.Text:='select * from tarifas where TAR0="'+dbMuestrad.FieldByName('FD5').AsString +'"';

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

//======================= MOSTRAR LAS DISTINTAS TARIFAS ======================
procedure TFFacturas.MuestraTarifas();
begin
   ListBox2.Visible:=true; ListBox2.SetFocus;
end;
procedure TFFacturas.ListBox2DblClick(Sender: TObject);
begin
   ListBox2.Visible:= False;
   if ListBox2.ItemIndex=0 then Edit9.Text:=dbArti.FieldByName('A2').AsString;
   if ListBox2.ItemIndex=1 then Edit9.Text:=dbArti.FieldByName('A21').AsString;
   if ListBox2.ItemIndex=2 then Edit9.Text:=dbTarifas.FieldByName('TAR2').AsString;
   if ListBox2.ItemIndex=3 then Edit9.Text:=dbTarifas.FieldByName('TAR4').AsString;
   if ListBox2.ItemIndex=4 then Edit9.Text:=dbTarifas.FieldByName('TAR6').AsString;
   Edit9Exit(self);
end;

procedure TFFacturas.ListBox2KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then ListBox2DblClick(self);
end;

//================= ACTUALIZA IMPORTE EN PANTALLA ===============
procedure TFFacturas.ActualizaImporte();
begin
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT SUM(FD13) FROM factud'+Tienda+' WHERE'+
                     ' FD0='+dbMuestrac.FieldByName('FC0').AsString+
                     ' AND FD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('FC1').AsDateTime)+'"'+
                     ' AND FD2="'+dbMuestrac.FieldByName('FC2').AsString+'"'+
                     ' AND FD3='+dbMuestrac.FieldByName('FC3').AsString;
  dbBusca.Active:=True;

  LabelTotal.Caption:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);
end;



//======================= CARGAR SERIES DE FACTURACION ========================
procedure TFFacturas.CargaSeries();
var
   contador: integer;
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

  cbSerieListado.Items.Clear;
  for contador:=0 to ComboBox1.Items.Count-1 do
    begin
     ComboBox1.ItemIndex:=contador;
     cbSerieListado.Items.Add(ComboBox1.Text);
    end;

  ComboBox1.ItemIndex:=0;
  cbSerieListado.ItemIndex:=0;

end;

//====================== MOSTRAR BOTONES DD ====================
procedure TFFacturas.MostrarBotonesdd();
begin
  BitBtn5.Visible:=True; BitBtn12.Visible:=True;
  BitBtn13.Visible:=True; BitBtn14.Visible:=True;
  BitBtn15.Visible:=True; BitBtn16.Visible:=True;
  //-------------- cc
  BitBtn1.Visible:=False; BitBtn9.Visible:=False;
  BitBtn10.Visible:=False; BitBtn11.Visible:=False;
  BitBtn2.Visible:=False; BitBtn23.Visible:=False;
  BitBtn25.Visible:=False; BitBtn26.Visible:=False;
end;

//====================== OCULTAR BOTONES DD ====================
procedure TFFacturas.OcultarBotonesdd();
begin
  BitBtn5.Visible:=False; BitBtn12.Visible:=False;
  BitBtn13.Visible:=False; BitBtn14.Visible:=False;
  BitBtn15.Visible:=False; BitBtn16.Visible:=False;
  //-------------- cc
  BitBtn1.Visible:=True; BitBtn9.Visible:=True;
  BitBtn10.Visible:=True; BitBtn11.Visible:=True;
  BitBtn2.Visible:=True; BitBtn23.Visible:=True;
  BitBtn25.Visible:=True; BitBtn26.Visible:=True;
end;

//=================== TECLAS RAPIDAS ======================

procedure TFFacturas.FormKeyDown(Sender: TObject; var Key: Word;
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
 if (key=VK_F10) and (panel6.Visible=True) then begin key:=0; BitBtn24Click(self); Exit; End;                    // histórico de cliente.
 if (key=VK_ESCAPE) and (panel6.Visible=True) then begin key:=0; BitBtn6Click(self) ; Exit; End;                 // finalizar entradas
 if (key=VK_RETURN) and (panel6.Visible=True)  and                                   // entrada automática.
                       (Edit5.Focused) then begin key:=0; Edit5Exit(self); BitBtn8Click(self) ; Exit; End;

//     **********  Pantalla cabeceras de albaranes   **********

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
      End;                                                                                                                    // Entra en selección de clientes.
 if (key=VK_F1) and (dbGrid2.Visible=false) then begin key:=0; BitBtn1Click(self); Exit; End;                    // entra en edición del pre/pro
 if (key=VK_F2) and (dbGrid2.Visible=false) then begin key:=0; BitBtn9Click(self); Exit; End;                    // crea un pre/pro nuevo
 if (key=VK_F3) and (dbGrid2.Visible=false) then begin key:=0; BitBtn10Click(self); Exit; End;                   // borra un pre/pro
 if (key=VK_F11) and (dbGrid2.Visible=false) then begin key:=0; BitBtn23Click(self); Exit; End;                  // Listado de pre/pro's
 if (key=VK_F8 ) and (Panel9.Visible=True) then begin key:=0; BitBtn21Click(self); Exit; End;                    // ejecuta el listado
 if (key=VK_F8 ) and (Panel8.Visible=True) then begin key:=0; BitBtn19Click(self); dbGrid1.SetFocus; Exit; End;  // Acepta datos serie/numero pre/pro
 if (key=VK_ESCAPE) and (Panel9.Visible=True) then begin key:=0; BitBtn22Click(self); Exit; End;                 // Cancelar listado
 if (key=VK_ESCAPE) and (Panel8.Visible=True) then begin key:=0; BitBtn20Click(self); Exit; End;                 // Cancelar datos serie/pro.
 if (key=VK_ESCAPE) and (dbGrid2.Visible=false) then begin key:=0; BitBtn2Click(self); Exit; End;                // Salir de tarea de pre/pro
 if (key=VK_F12) and (dbGrid2.Visible=false) and (RadioButton2.Checked) then begin key:=0; BitBtn31Click(self); Exit; End;  // buscar clientes.


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

//====================== CERRAR FORMULARIO =====================
procedure TFFacturas.BitBtn2Click(Sender: TObject);
begin
  Close();
end;
procedure TFFacturas.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;


initialization

  {$I factura.lrs}

end.

