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

unit creditos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ZConnection, ZDataset, db, DBGrids, Buttons, ExtCtrls, StdCtrls, LCLType,
  Grids, LR_Class, LR_DBSet;

type

  { TFCreditos }

  TFCreditos = class(TForm)
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
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Combo1: TComboBox;
    Combo2: TComboBox;
    Combo3: TComboBox;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    dbAlbad: TZQuery;
    dbCreditosdd: TZQuery;
    dbCreditosBorrado: TZQuery;
    dbImprimir: TZQuery;
    dbUsu: TZQuery;
    DBGrid2: TDBGrid;
    dbHistocc: TZQuery;
    dbTrabajo: TZQuery;
    dbSeries: TZQuery;
    dbTiendas: TZQuery;
    dbTotales: TZQuery;
    dbCreditos: TZQuery;
    dbClientes: TZQuery;
    dbBusca: TZQuery;
    DBGrid1: TDBGrid;
    dbHistodd: TZQuery;
    dbCajas: TZQuery;
    dbAlbac: TZQuery;
    Edit1: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit2: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    frDBDataSet2: TfrDBDataSet;
    frReport2: TfrReport;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
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
    Label4: TLabel;
    Label5: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    LabelDebe: TLabel;
    Label56: TLabel;
    LabelHaber: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LabelSaldo: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel8: TPanel;
    PanelCredito: TPanel;
    RadioGroup1: TRadioGroup;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    StaticText14: TStaticText;
    StaticText15: TStaticText;
    StaticText16: TStaticText;
    StaticText17: TStaticText;
    StaticText18: TStaticText;
    StaticText19: TStaticText;
    StaticText2: TStaticText;
    StaticText20: TStaticText;
    StaticText21: TStaticText;
    StaticText22: TStaticText;
    StaticText23: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn17Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn22Click(Sender: TObject);
    procedure BitBtn23Click(Sender: TObject);
    procedure BitBtn24Click(Sender: TObject);
    procedure BitBtn25Click(Sender: TObject);
    procedure BitBtn26Click(Sender: TObject);
    procedure BitBtn29Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Combo1Click(Sender: TObject);
    procedure Combo1KeyPress(Sender: TObject; var Key: char);
    procedure Combo3Change(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Edit13Exit(Sender: TObject);
    procedure Edit14Exit(Sender: TObject);
    procedure Edit15Exit(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure frReport2EnterRect(Memo: TStringList; View: TfrView);
    procedure frReport2GetValue(const ParName: String; var ParValue: Variant);
    procedure ListBox1Click(Sender: TObject);
    procedure PintarTotal();
    procedure LimpiaDatos();
    procedure RadioGroup1Click(Sender: TObject);
    procedure VisualizaTicket();
    procedure RecuperaEntrega();
    procedure RecuperaTicket();
    procedure RecuperaAlbaran();
    procedure RecuperaFactura();
    procedure TotalizaTicket();
    procedure ActuCliente(Importe:Double);
    procedure VerSerieFacturacion();
    procedure NumeroTicket();
    procedure NumeroFactura();
    procedure NumeroAlbaran();
    procedure HistoricoEntregas();
    procedure HistoricoCabeceras();
    procedure ActualizaCajas();
    procedure ActualizaDatos();
    procedure BorrarLineas();
//    procedure ImpreTicket();
    procedure CabeceraTicket();
    procedure PieTicket();
    procedure TotalTicket();
    procedure Cajon();
    procedure Corte();
    procedure SeleccionaLineas(Marca:String);
    function CheckLineas() :Boolean;
    function VerUltimaLineaHisto: Integer;
    function VerUltimaLineaAlba: Integer;
    procedure CargarTotales();
    procedure VerRecargo();

  private
    { private declarations }
  public
    { public declarations }
  end; 

  procedure ShowFormCreditos(Codigo: String);

var
  FCreditos: TFCreditos;
  PasaCodigo: String;
  PrintText: TextFile;
  FechaVenta,HoraVenta: TDateTime;
  SERIEFACT,TIPOOPER: String;
  NOPERACION,SwCajaEntrega: Integer;
  ImprimirTicket: Boolean;
  BASE1,BASE2,BASE3,IMPOIVA1,IMPOIVA2,IMPOIVA3,TOTAL1,TOTAL2,TOTAL3: Double;
  IRIVA1,IRIVA2,IRIVA3,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PRIVA1,PRIVA2,PRIVA3:Double;



implementation

uses
  Global, Funciones, Busquedas;

{ TFCreditos }

//====================== CREAR EL FORMULARIO ===================
procedure ShowFormCreditos(Codigo: String);
begin
  PasaCodigo:=Codigo;
  with TFCreditos.Create(Application) do ShowModal();
end;
procedure TFCreditos.FormCreate(Sender: TObject);
begin
  ShortDateFormat:='DD/MM/YYYY';
  {$IFDEF LINUX}
     DecimalSeparator:='.';
  {$ELSE}
     DecimalSeparator:=',';
  {$ENDIF}
  //--------- Conectar con la bbdd
  //Conectate(dbConnect);      // Utilizamos datamodule1.dbConexión para toda la aplicación.
  Edit1.Text:=PasaCodigo;//------- Pasar el cliente desde la venta
  Edit1Exit(Edit1);//------------- Consultar cliente
end;

//=================== CERRAR FORMULARIO ====================
procedure TFCreditos.BitBtn7Click(Sender: TObject);
begin
  dbCreditos.Active:=False;
  Close();
end;
procedure TFCreditos.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

//========================================================
//================== SALDAR LINEAS =======================
//========================================================
procedure TFCreditos.BitBtn8Click(Sender: TObject);
begin
  if dbCreditos.RecordCount=0 then exit;

  SeleccionaLineas('Todas');//======== Seleccionar todas las lineas

  //-- Linea de CONTROL a BORRAR - JOSE
  //-- showmessage('Entrada en SALDAR');

  Panel1.Enabled:=False;Panel2.Enabled:=False;DBGrid1.Enabled:=False;
  Panel4.Visible:=True;
  Edit15.SetFocus;
end;

//===================== CANCELAR SALDAR ==================
procedure TFCreditos.BitBtn9Click(Sender: TObject);
begin
  Panel4.Visible:=False;
  Panel1.Enabled:=True;Panel2.Enabled:=True;DBGrid1.Enabled:=True;
end;

procedure TFCreditos.Button1Click(Sender: TObject);
var
  Precio, SubTotal: Double;
  Texto, Texto2, Texto3, hora, FPago, Pendiente: String;
begin
  AssignFile(PrintText, DevTicket);
  Rewrite(PrintText);

  Precio:=StrToFloat(Edit3.Text);
  SubTotal:=StrToFloat(Edit4.Text);
  if CheckBox2.Checked then
    Pendiente:='Pendiente Cta : ' + LabelSaldo.Caption+' a Fecha : ' + DateToStr(Date)
  else Pendiente:='';
  FPago:=Combo3.Caption;

//**  CabeceraTicket();
//********** CABECERA ********************
  if Trim(LCTI1)<>'' then Writeln(PrintText, LCTI1);
  if Trim(LCTI2)<>'' then Writeln(PrintText, LCTI2);
  if Trim(LCTI3)<>'' then Writeln(PrintText, LCTI3);
  if Trim(LCTI4)<>'' then Writeln(PrintText, LCTI4);
  Writeln(PrintText, ' ');
  if HoraEnTicket='S' then hora:='   Hora.:'+FormatDateTime('HH:MM:SS',dbCreditos.FieldByName('CRE2').AsDateTime);
  Writeln(PrintText, 'F A C T U R A   S I M P L I F I C A D A');
  Writeln(PrintText, '_______________________________________');
  Writeln(PrintText, 'N.TICKET.:'+DataModule1.LFill(FormatFloat('#######',dbCreditos.FieldByName('CRE5').Asfloat),7,' '));

  Writeln(PrintText, ' ');
  if Edit1.Text<>'999999' then Writeln(PrintText, 'CLIENTE : '+Edit2.Text);
  if Edit1.Text<>'999999' then Writeln(PrintText, ' ');
  Writeln(PrintText, 'Forma de PAGO : '+FPago);
  Writeln(PrintText, 'Fecha.: '+FormatDateTime('DD/MM/YYYY',dbCreditos.FieldByName('CRE1').AsDateTime)+hora);
  Writeln(PrintText, ' ');
  Writeln(PrintText, '========================================');
//******** FIN CABECERA ******************

  //--- Línea con código de artículo
  Texto:=Edit6.Text+ ' ';

  Texto2:='Importe   : ' + DataModule1.LFill(FormatFloat('##0.00',Precio),6,' ') + ' ';
  Texto3:='Entregado : ' + DataModule1.LFill(FormatFloat('###0.00',SubTotal),7,' ');

  Writeln(PrintText, Texto);
  Writeln(PrintText, Texto2);
  Writeln(PrintText, Texto3);
  Writeln(PrintText, Copy(Memo1.Lines.Text+'                                        ',1,40));
  Writeln(PrintText, Pendiente);

  PieTicket();
  Corte();
  CloseFile(PrintText);
end;

//==================== TOTALIZAR SIN TICKET ==================
procedure TFCreditos.BitBtn10Click(Sender: TObject);
begin


  //-- Linea de CONTROL a BORRAR - JOSE
  //-- Showmessage('Totalizar SIN TICKET');


  ImprimirTicket:=False; TotalizaTicket();
end;
//==================== TOTALIZAR CON TICKET ==================
procedure TFCreditos.BitBtn11Click(Sender: TObject);
begin
  ImprimirTicket:=True; TotalizaTicket();
end;

//=================== TOTALIZAR CON/SIN TICKET ==============
procedure TFCreditos.TotalizaTicket();
begin


  //-- Linea de CONTROL a BORRAR - JOSE
  //-- showmessage('Entrada en TOTALIZAR SIN TICKET');


  if StrToFloat(Edit16.Text)<0 then
   begin showmessage('NO PUEDE ENTREGAR MENOS DEL TOTAL, PARA ESTO REALICE UNA ENTREGA'); exit; end;
  FechaVenta:=Date; HoraVenta:=Time;//---- Fecha y hora para grabar los datos
  VerSerieFacturacion();//---- Ver la serie de facturacion por defecto
  NumeroTicket();//----------- Ver el numero de ticket que corresponde
  if ImprimirTicket=True then BitBtn26Click(Self);//------------ Imprimir Ticket();
  dbCreditos.First;
  while not dbCreditos.EOF do
    begin
      if CheckLineas=False then begin dbCreditos.Next; Continue; end;//--- Ver tipo de marca de la linea


        //-- Linea de CONTROL a BORRAR - JOSE
        //-- showmessage('VAMOS A ACTUALIZAR DATOS');


      ActualizaDatos();
      dbCreditos.Next;
    end;
  TIPOOPER:='CO';//---------------------- Tipo de operacion (Normal Sin ticket)
  HistoricoCabeceras();//---------------- Actualizar Hist. Operaciones Cabeceras
  SwCajaEntrega:=0; ActualizaCajas();//-- Actualizar cajas diarias
  BitBtn9Click(BitBtn9);//--------------- Ocultar panel totalizar
  BorrarLineas();//---------------------- Borrar todas las lineas de credito
  dbCreditos.Refresh;
  PintarTotal();
end;


//===================== TOTALIZAR CON ALBARAN ==================
procedure TFCreditos.BitBtn12Click(Sender: TObject);
begin
  if Edit1.Text=ClienteVario then begin showmessage('NO PUEDE HACER UN ALBARAN A CLIENTES VARIOS'); exit; end;
  if StrToFloat(Edit16.Text)<0 then
   begin showmessage('NO PUEDE ENTREGAR MENOS DEL TOTAL, PARA ESTO REALICE UNA ENTREGA'); exit; end;
  showmessage('SOLO SE INCLUIRAN EN EL ALBARAN LOS TICKETS Y LAS ENTREGAS DE ESTE CLIENTE.');
  //--- Ver la tienda activa para saber que serie usa por defecto
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin Showmessage('NO SE EN QUE TIENDA FACTURAR'); Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); exit; end;
  dbSeries.First; ListBox1.Items.Clear;
  Label33.Caption:='N. Albaran';  Label34.Caption:='Fecha Albaran';
  Edit22.Text:=FormatDateTime('DD/MM/YYYY',Date);
  while not dbSeries.EOF do
    begin
     ListBox1.Items.Add(Space(2-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
     dbSeries.Next;
    end;
  dbSeries.Locate('SF0', dbTiendas.Fields[11].AsString, [loCaseInsensitive]);
  ListBox1.ItemIndex:= ListBox1.Items.IndexOf(Space(2-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
  Edit21.Text:=IntToStr(dbSeries.FieldByName('SF3').AsInteger+1);
  dbTiendas.Active:=False; BitBtn23.BringToFront;
  Panel8.Visible:=True; Panel4.Enabled:=False;
  Panel1.Enabled:=False; BitBtn19.SetFocus;
end;

//========================== CANCELAR ALBARAN / FACTURA ===========================
procedure TFCreditos.BitBtn24Click(Sender: TObject);
begin
  Panel8.Visible:=False; Panel4.Enabled:=True; Panel1.Enabled:=True;
end;

//========================== ACEPTAR ALBARAN ===========================
procedure TFCreditos.BitBtn25Click(Sender: TObject);
var
  TxtQ: String;
  TotArti, TotPrecio: Double;
begin
  FechaVenta:=Date; HoraVenta:=Time;//---- Fecha y hora para grabar los datos
  SERIEFACT:=dbSeries.FieldByName('SF0').AsString;
  if SERIEFACT='' then begin showmessage('DEBE SELECCIONAR UNA SERIE PARA FACTURAR'); Exit; end;
  BitBtn24Click(BitBtn24);//--- Ocultar panel series de albaranes
  //if swhueco=0 then NumeroAlbaran();
  NumeroAlbaran();
  dbAlbad.Active:=False;
  dbalbad.SQL.Text:='SELECT * FROM albad'+Tienda+' WHERE AD0='+Edit1.Text+
  ' AND AD1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'" AND AD2="'+SERIEFACT+'"'+
  ' AND AD3='+IntToStr(NOPERACION);
  dbAlbad.Active:=True;
  dbCreditos.First; TotArti:=0; TotPrecio:=0;
  while not dbCreditos.EOF do
    begin
      if CheckLineas=False then begin dbCreditos.Next; Continue; end;//--- Ver tipo de marca de la linea


      { TODO 1 -oNicolas -ccreditos : Hay que ver el total cuando se generá un albarán, pues puede haber lineas de albaranes y facturas en el credito. }

      if (dbCreditos.FieldByName('CRE3').AsString='AL') or (dbCreditos.FieldByName('CRE3').AsString='FA') then
         begin dbCreditos.Next; Continue; end;//--- Todas menos albaranes y facturas.


      ActualizaDatos();
      //---------------- Recorrer detalles
      //-- MID(CRED7,1,50)
      TxtQ:='SELECT *, CONVERT(CRED7 USING UTF8) As DESCRI FROM creditosdd'+Tienda+' WHERE '+
            ' CRED0='+dbCreditos.FieldByName('CRE0').AsString+
            ' AND CRED1="'+FormatDateTime('YYYY/MM/DD',dbCreditos.FieldByName('CRE1').AsDateTime)+'"'+
            ' AND CRED2="'+FormatDateTime('HH:MM:SS',dbCreditos.FieldByName('CRE2').AsDateTime)+'"'+
            ' AND CRED3="'+dbCreditos.FieldByName('CRE4').AsString+'"'+
            ' AND CRED4='+dbCreditos.FieldByName('CRE5').AsString;
      dbCreditosdd.Active:=False; dbCreditosdd.SQL.Text:=TxtQ; dbCreditosdd.Active:=True;
      dbCreditosdd.First; TotArti:=0; TotPrecio:=0;
      while not dbCreditosdd.EOF do
        begin
          TotArti:=TotArti+dbCreditosdd.FieldByName('CRED8').AsFloat;//------- Acumular unidades
          TotPrecio:=TotPrecio+dbCreditosdd.FieldByName('CRED10').AsFloat;//-- Acumular Precios sin iva
          //--- Detalle del albaran
          dbAlbad.Append;
          dbAlbad.FieldByName('AD0').AsString:=Edit1.Text;//------------ Cliente.
          dbAlbad.FieldByName('AD1').Value:=StrToDate(Edit22.Text);//--- Fecha albaran.
          dbAlbad.FieldByName('AD2').Value:=SERIEFACT;//---------------- Serie del albaran.
          dbAlbad.FieldByName('AD3').Value:=NOPERACION;//--------------- N. Albaran.
          dbAlbad.FieldByName('AD4').Value:=IntToStr(VerUltimaLineaAlba);//------------- N. Linea
          dbAlbad.FieldByName('AD5').AsString:=dbCreditosdd.FieldByName('CRED6').AsString;//--- C. Articulo
          dbAlbad.FieldByName('AD6').AsString:=dbCreditosdd.FieldByName('CRED7').AsString;//--- Descripcion
          dbAlbad.FieldByName('AD7').Value:=dbCreditosdd.FieldByName('CRED8').Value;//--------- Unidades
          dbAlbad.FieldByName('AD8').Value:=dbCreditosdd.FieldByName('CRED9').Value;//--------- P.V.P.
          dbAlbad.FieldByName('AD9').Value:=dbCreditosdd.FieldByName('CRED10').Value;//-------- Precio
          dbAlbad.FieldByName('AD10').Value:=dbCreditosdd.FieldByName('CRED11').Value;//------- Dto.
          dbAlbad.FieldByName('AD11').Value:=dbCreditosdd.FieldByName('CRED12').Value;//------- Importe
          dbAlbad.FieldByName('AD12').Value:=dbCreditosdd.FieldByName('CRED13').Value;//------- IVA
          dbAlbad.FieldByName('AD13').Value:=dbCreditosdd.FieldByName('CRED14').Value;//------- Total
          dbAlbad.FieldByName('AD14').Value:=dbCreditosdd.FieldByName('CRED15').Value;//------- Cgo. Talla/Color
          dbAlbad.FieldByName('AD15').Value:=dbCreditosdd.FieldByName('CRED16').Value;//------- Tipo de linea
          dbAlbad.FieldByName('AD16').Value:='';//-------- Observaciones del albaran
          dbAlbad.Post;
          dbCreditosdd.Next;
        end;
      dbCreditos.Next;
    end;
  dbTrabajo.Active:=False;
  //------------ Cabecera del albaran
  dbTrabajo.SQL.Text:='SELECT * FROM albac'+Tienda+' WHERE AC0='+Edit1.Text+
  ' AND AC1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'"'+
  ' AND AC2="'+SERIEFACT+'" AND AC3='+IntToStr(NOPERACION);
  dbTrabajo.Active:=True;
  dbtrabajo.Append;
  dbtrabajo.FieldByName('AC0').AsString:=Edit1.Text; //--------------- Cliente.
  dbtrabajo.FieldByName('AC1').Value:=StrToDate(Edit22.Text); //------ Fecha Albaran
  dbtrabajo.FieldByName('AC2').Value:=SERIEFACT; //------------------- Serie del albaran.
  dbtrabajo.FieldByName('AC3').Value:=NOPERACION; //------------------ N. Albaran.
  dbtrabajo.FieldByName('AC4').Value:=dbAlbad.RecordCount;//---------- N. Lineas
  dbtrabajo.FieldByName('AC5').Value:=TotArti;//---------------------- N. Articulos
  dbtrabajo.FieldByName('AC6').Value:=0;//---------------------------- Dto. pronto pago
  dbtrabajo.FieldByName('AC7').Value:=dbClientes.Fields[19].AsString;//-- Recargo S/N
  dbtrabajo.FieldByName('AC8').Value:=TotPrecio;//-------------------- Imp. Sin IVA
  dbtrabajo.FieldByName('AC9').Value:=StrToFloat(Edit14.Text);//------ Imp. Con IVA
  dbtrabajo.FieldByName('AC10').Value:='N';//------------------------- Marcado (S/N)
  dbtrabajo.FieldByName('AC11').Value:=Memo2.Lines.Text;//------------ Observaciones
  dbtrabajo.FieldByName('AC10').Value:='S';//------------------------- Pagado (S/N)
  dbtrabajo.Post;
  //-------------------
  TIPOOPER:='AL';//----------- Tipo de operacion (Albaran)
  HistoricoCabeceras();//---------------- Actualizar Hist. Operaciones Cabeceras
  SwCajaEntrega:=0; ActualizaCajas();//-- Actualizar cajas diarias
  //------------------------ Imprimir albaran
  frDBDataSet2.DataSet:=dbImprimir;
  IMPOIVA1:=0; BASE1:=0; TOTAL1:=0; IRIVA1:=0; PIVA1:=0; PRIVA1:=0;
  IMPOIVA2:=0; BASE2:=0; TOTAL2:=0; IRIVA2:=0; PIVA2:=0; PRIVA2:=0;
  IMPOIVA3:=0; BASE3:=0; TOTAL3:=0; IRIVA3:=0; PIVA3:=0; PRIVA3:=0;
    //--------------- Sacar distintos ivas ------------------
  TxtQ:='SELECT DISTINCT(AD12), (SUM(AD13-AD11)) As Ivas, '+
        'SUM(AD11) As Bases, SUM(AD13) As Totales, '+
        'SUM(AD10) As Dtos, (((SUM(AD11)*SUM(AD10)) / 100)) As ImpoDtos FROM albad'+Tienda+
        ' WHERE AD0='+Edit1.Text+
        ' AND AD1="'+FormatDateTime('yyyy/mm/dd',StrToDate(Edit22.Text))+'"'+
        ' AND AD2="'+SERIEFACT+'"'+
        ' AND AD3='+IntToStr(NOPERACION)+' GROUP BY AD12 ORDER BY AD12 ASC';
  dbTrabajo.Active:=False; dbTrabajo.Sql.Text:=TxtQ; dbTrabajo.Active:=True;
  CargarTotales();//-------- Carga los totales en la variables de impresion

  //------------------ Cargar Tabla para imprimir -------------------
  dbImprimir.Active:=False;
  dbImprimir.SQL.Text:='SELECT AD5 As IMP5,AD6 As IMP6, AD7 As IMP7, AD8 As IMP8, AD9 As IMP9,'+
  ' AD10 As IMP10, AD11 As IMP11, AD12 As IMP12, AD13 As IMP13 FROM albad'+Tienda+' WHERE AD0='+Edit1.Text+
  ' AND AD1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'" AND AD2="'+SERIEFACT+'"'+
  ' AND AD3='+IntToStr(NOPERACION);
  dbImprimir.Active:=True;

  frDBDataSet2.DataSet:=dbImprimir;
  frReport2.LoadFromFile(RutaReports+'Albaran.lrf');
  frReport2.ShowReport;
  BitBtn9Click(BitBtn9);//--------------- Ocultar panel totalizar

{ DESCONOZCO EL MOTIVO POR EL QUE SE BORRAN LAS LÍNEAS DE CRÉDITO AL ACEPTAR UN ALABRÁN, ESTA PENDIENTE DE COMPROBAR

  BorrarLineas();//---------------------- Borrar todas las lineas de credito
}

  dbCreditos.Refresh;
  PintarTotal();
end;


//=====================================================================
//==================== IMPRIMIR TICKETS ===============================
//=====================================================================
procedure TFCreditos.BitBtn26Click(Sender: TObject);
var
  Precio, SubTotal: Double;
  Texto: String;
begin
  AssignFile(PrintText, DevTicket);
  Rewrite(PrintText);

  CabeceraTicket();
  dbCreditosdd.First;
  while not dbCreditosdd.Eof do
    begin
      if DesgloIva='S' then
           begin
            Precio:=dbCreditosdd.Fields[10].AsFloat;
            SubTotal:=dbCreditosdd.Fields[12].AsFloat;
           end else
           begin
            Precio:=dbCreditosdd.Fields[9].AsFloat;
            SubTotal:=dbCreditosdd.Fields[14].AsFloat;
           end;
      //--- Línea con código de artículo
      if CgoEnTicket='S' then Texto:=Copy(dbCreditosdd.Fields[6].AsString+'                    ',1,18)+' '
                         else Texto:=Copy(dbCreditosdd.Fields[7].AsString+'                    ',1,18)+' ';

      Texto:=Texto + DataModule1.LFill(FormatFloat('##0.00',dbCreditosdd.Fields[8].AsFloat),6,' ') + ' ';

      Texto:=Texto + DataModule1.LFill(FormatFloat('##0.00',Precio),6,' ') + ' ';
      Texto:=Texto + DataModule1.LFill(FormatFloat('###0.00',SubTotal),7,' ');

      //--- Cgo Articulo en ticket (Ojo! se imprimen dos lineas por articulo)
      if CgoEnTicket='S' then
        begin
          Writeln(PrintText, Texto);
          Writeln(PrintText, Copy(dbCreditosdd.Fields[7].AsString+'                                        ',1,40));

        end else
          Writeln(PrintText, Texto);

      dbCreditosdd.Next;
    end;

  TotalTicket();
  PieTicket();
  Corte();
  CloseFile(PrintText);
end;


//============== CABECERA DEL TICKETC ===================================
procedure TFCreditos.CabeceraTicket();
var
  hora: String;
begin

  if Trim(LCTI1)<>'' then Writeln(PrintText, LCTI1);
  if Trim(LCTI2)<>'' then Writeln(PrintText, LCTI2);
  if Trim(LCTI3)<>'' then Writeln(PrintText, LCTI3);
  if Trim(LCTI4)<>'' then Writeln(PrintText, LCTI4);
  Writeln(PrintText, ' ');
  if HoraEnTicket='S' then hora:='   Hora.:'+FormatDateTime('HH:MM:SS',dbCreditos.FieldByName('CRE2').AsDateTime);
  Writeln(PrintText, 'F A C T U R A   S I M P L I F I C A D A');
  Writeln(PrintText, '_______________________________________');
  Writeln(PrintText, 'N.FRA.SIMP. (CRE).:'+DataModule1.LFill(FormatFloat('#######',dbCreditos.FieldByName('CRE5').Asfloat),7,' '));

  Writeln(PrintText, ' ');
  if Edit1.Text<>'999999' then Writeln(PrintText, 'CLIENTE : '+Edit2.Text);
  if Edit1.Text<>'999999' then Writeln(PrintText, ' ');
  Writeln(PrintText, 'Forma de PAGO : '+dbCreditos.FieldByName('CRE12').AsString);
  Writeln(PrintText, 'Fecha.: '+FormatDateTime('DD/MM/YYYY',dbCreditos.FieldByName('CRE1').AsDateTime)+hora);
  Writeln(PrintText, ' ');
  Writeln(PrintText, 'ARTICULO              UND PRECIO   TOTAL');
  Writeln(PrintText, '========================================');
end;

//====================== PIE DEL TICKET =============================
procedure TFCreditos.TotalTicket();
Var
  Texto1,Texto2,Texto3,Texto4: String;
  Neto, Impuestos: Double;
  Descuento: Double;
  Cambio: Double;
begin
  Writeln(PrintText, ' ');
  Writeln(PrintText, '                               ---------');

  Descuento:=0;
  Neto:= dbCreditos.FieldByName('CRE15').AsFloat/(1+(dbCreditosdd.Fields[13].AsInteger/100));
  Impuestos:=dbCreditos.FieldByName('CRE15').AsFloat-Neto;
  if (dbCreditos.FieldByName('CRE14').AsFloat<>0) then
     Descuento:=dbCreditos.FieldByName('CRE13').AsFloat-dbCreditos.FieldByName('CRE15').AsFloat;
  //---------------------- Desglose de Iva en ticket
  if SacaIva='N' then
    begin
      Writeln(PrintText, '                    NETO      '+DataModule1.LFill( FormatFloat('######0.00',Neto),10,' '));
      Writeln(PrintText, '                    IVA       '+DataModule1.LFill( FormatFloat('######0.00',Impuestos),10,' '));
      Writeln(PrintText, ' ');
    end;

  //---------------- Descuento
  if Descuento<>0 then
    begin
     Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(FormatFloat('0.00',dbCreditos.FieldByName('CRE13').AsFloat))),10,' ');
     Texto3:=DataModule1.LFill( FormatFloat('######0.00',dbCreditos.FieldByName('CRE15').AsFloat),10,' ');
     if CgPrDto='S' then
       begin
          Texto2:= DataModule1.LFill( FormatFloat('######0.00',Descuento),10,' ');
          Writeln(PrintText, '                    SUBTOTAL  '+Texto1);
          Writeln(PrintText, '                    DCTO.   - '+Texto2);
          Writeln(PrintText, '                               ---------');
        //  Writeln(PrintText, '                    TOTAL     '+Texto3);
        end
        else
        begin
          Texto2:=DataModule1.LFill( FormatFloat('##0.00',dbCreditos.FieldByName('CRE14').AsFloat),6,' ');
          Writeln(PrintText, 'TOTAL:'+Texto1+'-'+Texto2+' %Dto ='+Texto3);
        end;
    end ;

  Writeln(PrintText, '               SUMA TICKET    '+DataModule1.LFill( FormatFloat('######0.00',dbCreditos.FieldByName('CRE15').AsFloat),10,' '));    ;
  Texto1:=DataModule1.LFill( FormatFloat('######0.00',dbCreditos.FieldByName('CRE16').AsFloat),10,' ');
  Writeln(PrintText, '                    ENTREGA   '+Texto1);

  Cambio:=dbCreditos.FieldByName('CRE16').AsFloat-dbCreditos.FieldByName('CRE15').AsFloat;
  Texto4:=DataModule1.LFill( FormatFloat('######0.00',Cambio),10,' ');

  if (Cambio>=0) then
    Writeln(PrintText, '                    CAMBIO    '+Texto4)
  else
    Writeln(PrintText, '                    CREDITO   '+Texto4);
  Writeln(PrintText, ' ');
  //----------------- Sacar iva uncluido en el ticket o no --------------
  if SacaIva<>'N' then
    begin
     Writeln(PrintText, '            * IVA INCLUIDO *            ');
     Writeln(PrintText, ' ');
    end;


 end;

  //================= Sacar vendedor en el ticket o no ===================

procedure TFCreditos.PieTicket();
var
   Conta: Integer;
begin

   if SacaVende<>'N' then Writeln(PrintText, 'LE ATENDIO.: '+ copy(StaticText12.Caption,1,35));

  //----------------------------------------------------------------
  if Trim(LPTI1)<>'' then Writeln(PrintText, LPTI1);
  if Trim(LPTI2)<>'' then Writeln(PrintText, LPTI2);
  if Trim(LPTI3)<>'' then Writeln(PrintText, LPTI3);

  for Conta:=1 to StrToInt(LiFinTick) do Writeln(PrintText, ' ');
end;

//================== CORTE DE PAPEL ===================
procedure TFCreditos.Corte();
begin
  if trim(CgoCorte)='' then exit;
  WriteLn(PrintText, PCgoCorte);
end;


//==============================================================
//===================== ACTUALIZAR AL SALDAR ===================
//==============================================================
procedure TFCreditos.ActualizaDatos();
var
  TxtQ,Importe: String;
begin


    //-- Linea de CONTROL a BORRAR - JOSE
    //-- showmessage('Entrada en ACTUALIZAR DATOS');


  Importe:=FloatToStr(dbCreditos.FieldByName('CRE7').AsFloat-dbCreditos.FieldByName('CRE8').AsFloat);
  //------------------- Clientes, restar "credito pendiente"
  TxtQ:='UPDATE clientes SET C20=C20-'+Edit14.Text+' WHERE C0="'+Edit1.Text+'"';

  //-- Linea de CONTROL a BORRAR - JOSE
  //-- showmessage(TxtQ);

  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;

  //------------------- Historico de operaciones detalles
  TxtQ:='INSERT INTO hisopdd'+Tienda+' (HOD0,HOD1,HOD2,HOD3,HOD4,HOD5,HOD6,HOD7,HOD8,HOD9,HOD10,HOD11'+
        ',HOD12,HOD13,HOD14,HOD15,HOD16,HOD17,HOD18,HOD19,HOD20,HOD21) VALUES ("'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'",'+
        '"'+FormatDateTime('HH:MM:SS',HoraVenta)+'","'+Puesto+'",'+IntToStr(NOPERACION)+
        ',"'+SERIEFACT+'",'+IntToStr(VerUltimaLineaHisto)+',"'+dbCreditos.FieldByName('CRE3').AsString+'",'+
        '"'+dbCreditos.FieldByName('CRE6').AsString+'",1,'+Importe+','+'0,0,'+Importe+','+
        '0,'+Importe+',"","A","'+FormatDateTime('YYYY/MM/DD',dbCreditos.FieldByName('CRE1').Value)+'",'+
        '"'+FormatDateTime('HH:MM:SS',dbCreditos.FieldByName('CRE2').Value)+'",'+
        '"'+dbCreditos.FieldByName('CRE11').AsString+'",'+
        dbCreditos.FieldByName('CRE5').AsString+',"'+
        dbCreditos.FieldByName('CRE4').AsString+'")';

  //-- Linea de CONTROL a BORRAR - JOSE
  //-- showmessage(TxtQ);

  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;

end;

//=================== GRABAR HIST. OPER. CABECERAS ================
procedure TFCreditos.HistoricoCabeceras();
var
  TxtQ: String;
begin
  TxtQ:='INSERT INTO hisopcc'+Tienda+' (HO0,HO1,HO2,HO3,HO4,HO5,HO6,HO7,HO8,HO9,HO10,HO11'+
        ',HO12,HO13,HO14,HO15) VALUES ("'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'",'+
        '"'+FormatDateTime('HH:MM:SS',HoraVenta)+'","'+Puesto+'",'+IntToStr(NOPERACION)+',"'+SERIEFACT+'"'+
        ',"'+TIPOOPER+'","'+Copy(Combo2.Text,1,10)+'",1,'+Edit1.Text+','+
        Edit12.Text+','+Edit13.Text+','+Edit14.Text+','+
        Edit15.Text+','+Edit16.Text+',0,"N")';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;

  //TODO: Falta asignar el numero de usuario que cierra la operacion

end;

//=================== BORRAR TODAS LAS LINEAS ================
procedure TFCreditos.BorrarLineas();
var
  AuxFecha, TxtQ: String;
  tmpMarcado: string;
begin
  AuxFecha:='';

  if RadioGroup1.ItemIndex=1 then tmpMarcado:=' AND CRE9="S"';
  if RadioGroup1.ItemIndex=2 then tmpMarcado:=' AND CRE9<>"S"';

  dbCreditosBorrado.Active:=False;
  dbCreditosBorrado.SQL.Text:='SELECT * FROM creditos'+Tienda+' WHERE CRE0='+Edit1.Text+tmpMarcado;
  dbCreditosBorrado.Active:=True;

  dbCreditosBorrado.First;

 while not dbCreditosBorrado.eof do
    begin
      AuxFecha:=dbCreditosBorrado.FieldByName('CRE1').AsString;
//--      showmessage(AuxFecha);
                           // Borra detalles del crédito.
      TxtQ:='DELETE FROM creditosdd'+Tienda+' WHERE CRED0='+dbCreditosBorrado.FieldByName('CRE0').AsString+
                                              ' AND CRED1="'+FormatDateTime('YYYY/MM/DD',StrtoDate(AuxFecha))+'" '+
                                              ' AND CRED3="'+dbCreditosBorrado.FieldByName('CRE4').AsString+'" '+
                                              ' AND CRED4="'+dbCreditosBorrado.FieldByName('CRE5').AsString+'"';

      //-- Comprobación de Borrado de lineas de crédito
//--      SHOWMESSAGE(TxtQ);

      dbTrabajo.SQL.Text:=TxtQ;
      dbTrabajo.ExecSQL;

      dbCreditosBorrado.Next;

    end ;

                        //  Borra Cabeceras
  TxtQ:='DELETE FROM creditos'+Tienda+' WHERE CRE0='+Edit1.Text+tmpMarcado;

  //-- Comprobación de Borrado de lineas de crédito
//--  SHOWMESSAGE(TxtQ);

  dbTrabajo.SQL.Text:=TxtQ;
  dbTrabajo.ExecSQL;

end;


//========================================================
//================== ENTREGAS / VALES ====================
//========================================================
procedure TFCreditos.BitBtn16Click(Sender: TObject);
begin
  Label11.Caption:='ENTREGAS A CUENTA € / VALES';
  BitBtn24.Caption:='Cancelar';
  Edit3.Enabled:=True; Edit4.Enabled:=True; Edit6.Enabled:=True;
  Panel3.Visible:=True; Edit3.Text:='0.00';
  Edit4.Text:='0.00'; Edit5.Text:='0.00';
  Edit6.Text:='ENTREGA A CUENTA'; Edit3.SetFocus;
end;

//--------------- ACEPTAR ENTREGA -----------------
procedure TFCreditos.BitBtn23Click(Sender: TObject);
Var
  TxtQ, TxtQ1, Debe, Haber: String;
begin
  if (Edit3.Text='0.00') or (Edit3.Text='') then exit;
  if (Edit4.Text='0.00') or (Edit4.Text='') then exit;
  if StrToFloat(Edit4.Text)<StrToFloat(Edit3.Text) then
    begin showmessage('NO PUEDE ENTREGAR MENOS QUE EL TOTAL'); Edit4.SetFocus; exit; end;
  FechaVenta:=Date; HoraVenta:=Time;//---- Fecha y hora para grabar los datos
  VerSerieFacturacion();//---- Ver la serie de facturacion por defecto
  NumeroTicket();//----------- Ver el numero de ticket que corresponde
  Debe:='0';
  Haber:=Edit3.Text;
  if Copy(Label11.Caption,1,8)<>'DESGLOSE' then
    begin

     //--  MUCHO OJO, HAY QUE CMBIAR EL COPY POR PUESTO DE TRABAJO.

{
     TxtQ:='INSERT INTO creditos'+Tienda+' (CRE0,CRE1,CRE2,CRE3,CRE4,CRE5,CRE6,CRE7,CRE8,CRE9,CRE10,CRE11,CRE21) '+
           'VALUES ('+Edit1.Text+',"'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'",'+
           '"'+FormatDateTime('HH:MM:SS',HoraVenta)+'","EN","'+SERIEFACT+'",'+IntToStr(NOPERACION)+
           ',"'+Edit6.Text+'",'+Debe+','+Haber+',"N",0,"'+Copy(Memo1.Lines.Text, 1, 49)+'","'+Memo1.Lines.Text+'")';
      }
     TxtQ:='INSERT INTO creditos'+Tienda+' (CRE0,CRE1,CRE2,CRE3,CRE4,CRE5,CRE6,CRE7,CRE8,CRE9,CRE10,CRE11,CRE21) '+
            'VALUES ('+Edit1.Text+',"'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'",'+
            '"'+FormatDateTime('HH:MM:SS',HoraVenta)+'","EN","'+SERIEFACT+'",'+IntToStr(NOPERACION)+
            ',"'+Edit6.Text+'",'+Debe+','+Haber+',"N",0,"'+Puesto+'","'+Memo1.Lines.Text+'")';
      TxtQ1:='INSERT INTO creditosdd'+Tienda+' (CRED0,CRED1,CRED2,CRED3,CRED4,CRED5,CRED6,CRED7,CRED8,CRED9,CRED10,'+
             'CRED11,CRED12,CRED13,CRED14,CRED15,CRED16,CRED17) '+
             'VALUES ('+Edit1.Text+',"'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'",'+
             '"'+FormatDateTime('HH:MM:SS',HoraVenta)+'","'+SERIEFACT+'",'+IntToStr(NOPERACION)+
             ',1,"ENTREGA","'+Edit6.Text+'",1,'+Haber+','+Haber+',0,'+Haber+',0,'+Haber+',"","A","N")';
    end
  else
    begin
      ActuCliente(dbCreditos.FieldByName('CRE8').AsFloat*-1);//---------- Actualizar ficha del cliente
      TxtQ:='UPDATE creditos'+Tienda+' SET CRE6="'+Edit6.Text+
            '",CRE7='+Debe+',CRE8='+Haber+',CRE11="'+Memo1.Lines.Text+'"'+
            ' WHERE CRE0='+Edit1.Text+
            ' AND CRE1="'+FormatDateTime('YYYY/MM/DD',dbCreditos.FieldByName('CRE1').AsDateTime)+'"'+
            ' AND CRE2="'+FormatDateTime('HH:MM:SS',dbCreditos.FieldByName('CRE2').AsDateTime)+'"'+
            ' AND CRE3="EN" AND CRE4="'+dbCreditos.FieldByName('CRE4').AsString+'"'+
            ' AND CRE5='+dbCreditos.FieldByName('CRE5').AsString;
      TxtQ1:='UPDATE creditosdd'+Tienda+' SET CRED7="'+Edit6.Text+
            '",CRED9='+Haber+',CRED10='+Haber+',CRED12='+Haber+', CRED14='+Haber+
            ' WHERE CRED0='+Edit1.Text+
            ' AND CRED1="'+FormatDateTime('YYYY/MM/DD',dbCreditos.FieldByName('CRE1').AsDateTime)+'"'+
            ' AND CRED2="'+FormatDateTime('HH:MM:SS',dbCreditos.FieldByName('CRE2').AsDateTime)+'"'+
            ' AND CRED3="'+dbCreditos.FieldByName('CRE4').AsString+'"'+
            ' AND CRED4='+dbCreditos.FieldByName('CRE5').AsString+' AND CRED5=1';
    end;
  dbBusca.SQL.Text:=TxtQ; dbBusca.ExecSQL;
  dbBusca.SQL.Text:=TxtQ1; dbBusca.ExecSQL;
  PintarTotal();
  dbCreditos.Refresh;
  TIPOOPER:='EN';//----------- Tipo de operacion (Entrega a cuenta/Vale)
    if Copy(Label11.Caption,1,8)<>'DESGLOSE' then
      BEGIN
       ActuCliente(StrToFloat(Haber));//------------ Actualizar ficha del cliente
       HistoricoEntregas();//--------- Actualizar Hist. Operaciones Cabeceras
       SwCajaEntrega:=1;
       ActualizaCajas();//--------- Actualizar cajas diarias
      end
    else
      BEGIN
       Showmessage('Los cambios en Importe, NO SE REFLEJARÁN EN CAJAS');
      end;
  //TODO: Falta asignar el numero de usuario que cierra la operacion
  Panel3.Visible:=False;
//--  ImpreTicket(); //-- No está implementada la Impresión, e imprime un listado de las deudas
end;

//------------------ VISUALIZAR ENTREGA ------------
procedure TFCreditos.RecuperaEntrega();
begin
  Panel3.Visible:=True; Label11.Caption:='DESGLOSE DE ENTREGAS A CUENTA € / VALES';
  BitBtn24.Caption:='Cerrar';
  Edit3.Enabled:=False; Edit4.Enabled:=False; Edit6.Enabled:=False;
  Edit3.Text:=FormatFloat('0.00',dbCreditos.FieldByName('CRE8').AsFloat);
  Edit4.Text:=Edit3.Text; Edit5.Text:='0.00';
  Edit6.Text:=dbCreditos.FieldByName('CRE6').AsString;
  Memo1.Lines.Text:=dbCreditos.FieldByName('CRE11').AsString+' - '+dbCreditos.FieldByName('CRE21').AsString;
  Memo1.SetFocus;
end;

//-------------- IMPORTE ENTREGA ------------------
procedure TFCreditos.Edit3Exit(Sender: TObject);
begin
  if Edit4.Text='0.00' then Edit4.Text:=Edit3.Text;
end;
//-------------- CANTIDAD QUE ENTREGA ------------------
procedure TFCreditos.Edit4Exit(Sender: TObject);
begin
  if (Edit3.Text='0.00') or (Edit3.Text='') then exit;
  if (Edit4.Text='0.00') or (Edit4.Text='') then exit;
  if StrToFloat(Edit4.Text)<StrToFloat(Edit3.Text) then
    begin showmessage('NO PUEDE ENTREGAR MENOS QUE EL TOTAL'); Edit4.SetFocus; exit; end;
  Edit5.Text:=FormatFloat('0.00',StrToFloat(Edit4.Text)-StrToFloat(Edit3.Text));
end;

//---------------- CERRAR ENTREGAS ---------------
procedure TFCreditos.BitBtn20Click(Sender: TObject);
begin
  Panel3.Visible:=False;
end;


//====================================================================
//=========================== TICKETS ================================
//====================================================================
procedure TFCreditos.RecuperaTicket();
begin
  StaticText15.Caption:='DESGLOSE DEL TICKET';
  StaticText13.Caption:='N.TICKET';
  VisualizaTicket();
end;

//====================================================================
//=========================== ALBARANES ==============================
//====================================================================
procedure TFCreditos.RecuperaAlbaran();
begin
  StaticText15.Caption:='DESGLOSE DEL ALBARAN';
  StaticText13.Caption:='N.ALBARAN';
  VisualizaTicket();
end;

//====================================================================
//=========================== ALBARANES ==============================
//====================================================================
procedure TFCreditos.RecuperaFactura();
begin
  StaticText15.Caption:='DESGLOSE DE LA FACTURA';
  StaticText13.Caption:='N.FACTURA';
  VisualizaTicket();
end;

//============== VISUALIZAR TICKET/ALBARAN/FACTURA ==========
procedure TFCreditos.VisualizaTicket();
var
  TxtQ: String;
begin
  StaticText9.Caption:=FormatDateTime('DD/MM/YYYY',dbCreditos.FieldByName('CRE1').AsDateTime);//---Fecha
  StaticText10.Caption:=FormatDateTime('HH:MM:SS',dbCreditos.FieldByName('CRE2').AsDateTime);//--Hora
  //--------------- N. Ticket
  StaticText14.Caption:=dbCreditos.FieldByName('CRE4').AsString+'/'+dbCreditos.FieldByName('CRE5').AsString;
  //--------------- Vendedor de la operacion
  dbUsu.Active:=False;
  dbUsu.SQL.Text:='SELECT USU0, USU1, USU9 FROM usuarios'+Tienda+' WHERE USU0='+
                   dbCreditos.FieldByName('CRE10').AsString;
  dbUsu.Active:=True;
  if dbUsu.RecordCount=0 then StaticText12.Caption:='' else StaticText12.Caption:=dbUsu.FieldByName('USU9').AsString;
  dbUsu.Active:=False;
  //--------------------
  StaticText4.Caption:=FormatFloat('0.00',dbCreditos.FieldByName('CRE13').AsFloat);//---Importe
  StaticText21.Caption:=FormatFloat('0.00',dbCreditos.FieldByName('CRE14').AsFloat);//---Dto.
  StaticText23.Caption:=FormatFloat('0.00',dbCreditos.FieldByName('CRE15').AsFloat);//---Total
  StaticText5.Caption:=FormatFloat('0.00',dbCreditos.FieldByName('CRE16').AsFloat);//--Entrega
  StaticText6.Caption:=FormatFloat('0.00',dbCreditos.FieldByName('CRE17').AsFloat);//--Cambio
  StaticText17.Caption:=dbCreditos.FieldByName('CRE11').AsString;//--Puesto de venta
  StaticText19.Caption:=dbCreditos.FieldByName('CRE12').AsString;//--Tipo de pago

  //------------ Cargar detalle del credito
  //-- MID(CRED7,1,50)
  TxtQ:='SELECT *, CONVERT(CRED7 USING UTF8) As DESCRI FROM creditosdd'+Tienda+' WHERE '+
        ' CRED0='+dbCreditos.FieldByName('CRE0').AsString+
        ' AND CRED1="'+FormatDateTime('YYYY-MM-DD',dbCreditos.FieldByName('CRE1').AsDateTime)+'"'+
        ' AND CRED2="'+FormatDateTime('HH:MM:SS',dbCreditos.FieldByName('CRE2').AsDateTime)+'"'+
        ' AND CRED3="'+dbCreditos.FieldByName('CRE4').AsString+'"'+
        ' AND CRED4='+dbCreditos.FieldByName('CRE5').AsString;
  dbCreditosdd.Active:=False; dbCreditosdd.SQL.Text:=TxtQ; dbCreditosdd.Active:=True;
  Panel5.Visible:=True;
end;

//================= CERRAR PANEL TICKETS ====================
procedure TFCreditos.BitBtn14Click(Sender: TObject);
begin
  Panel5.Visible:=False;
end;

//======================== CLIENTE =======================
procedure TFCreditos.Edit1Enter(Sender: TObject);
begin
  Edit1.Text:=''; LimpiaDatos();
end;
procedure TFCreditos.Edit1Exit(Sender: TObject);
begin
  if Edit1.Text='' then Edit1.Text:=ClienteVario; //------- Clientes varios
  dbClientes.Active:=False;
  dbClientes.SQl.Text:='SELECT * FROM clientes WHERE C0='+Edit1.Text;
  dbClientes.Active:=True;
  if dbClientes.RecordCount=0 then
   begin
     showmessage('ESE CLIENTE NO EXISTE.'); Edit1.SetFocus; Exit;
   end;
  Edit2.Text:=dbClientes.FieldByName('C1').AsString;//----- Nombre
  Label2.Caption:=dbClientes.FieldByName('C3').AsString;//----- Direccion
  Label4.Caption:=dbClientes.FieldByName('C4').AsString;//----- Localidad
  Label3.Caption:=dbClientes.FieldByName('C37').AsString;//---- C.P.
  Label5.Caption:=dbClientes.FieldByName('C38').AsString;//---- Provincia
  Label21.Caption:=dbClientes.FieldByName('C5').AsString;//---- N.I.F. / C.I.F.
  Label22.Caption:=dbClientes.FieldByName('C6').AsString;//---- Telefonos
  //--- Recargo Equiv.
  if dbClientes.FieldByName('C19').AsString='S' then
    begin CheckBox1.Checked:=True; CheckBox1.Font.Color:=clRed; end
  else
    begin CheckBox1.Checked:=False; CheckBox1.Font.Color:=clWindowText; end;
  Label24.Caption:=dbClientes.FieldByName('C16').AsString;//--- Tipo de descuento
  Label25.Caption:=dbClientes.FieldByName('C18').AsString;//--- Dto. Pronto pago
  Label26.Caption:=dbClientes.FieldByName('C17').AsString;//--- Dto. Comercial
  PintarTotal();
  //--------- Creditos
  dbCreditos.SQL.Text:='SELECT * FROM creditos'+Tienda+' WHERE CRE0='+Edit1.Text+
                       ' ORDER BY CRE1 DESC, CRE2 DESC';
  dbCreditos.Active:=True;
end;

procedure TFCreditos.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then BitBtn1.Click;
end;

//------------------- BUSCAR CLIENTE -------------------
procedure TFCreditos.BitBtn1Click(Sender: TObject);
var
  TxtQ: String;
begin
  if Edit2.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit2.SetFocus; Exit; end;
  TxtQ:='SELECT C0,C1 FROM clientes WHERE C1 LIKE "'+Edit2.Text+'%"';

  Combo1.Clear; Combo1.Text:='';
  dbBusca.SQL.Text:='SELECT C0,C1 FROM clientes WHERE C1 LIKE "'+Edit2.Text+'%"'; dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then
    begin
      ShowMessage('NO HAY NADA QUE COMIENZE POR ESE TEXTO');
      dbBusca.Active:=False; Edit2.SetFocus; Exit;
    end;
  dbBusca.First;
  While not dbBusca.EOF do
    begin
      Combo1.Items.Add(dbBusca.FieldByName('C1').AsString);
      dbBusca.Next;
    end;
  Combo1.Visible:=True; Combo1.ItemIndex:=0; Combo1.SetFocus;
end;
procedure TFCreditos.Combo1Click(Sender: TObject);
begin
  if Combo1.Text='' then begin Combo1.Visible:=False; Edit2.SetFocus; exit; end;
  if not dbBusca.Locate('C1',Combo1.Text,[]) then begin Edit2.Text:=''; Exit; end;
  Edit1.Text:=dbBusca.Fields[0].AsString;
  Edit2.Text:=dbBusca.Fields[1].AsString;
  Edit1Exit(Edit1);//---- Leer cliente
  Combo1.Visible:=False; Edit2.SetFocus;
end;
procedure TFCreditos.Combo1KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then Combo1Click(Combo1);
end;

procedure TFCreditos.Combo3Change(Sender: TObject);
begin
  Edit3.SetFocus;
end;

//===================== MARCAR / DESMARCAR CABECERAS ==================
procedure TFCreditos.BitBtn22Click(Sender: TObject);
begin
  if dbCreditos.Active=False then exit;
  if dbCreditos.RecordCount=0 then exit;
  if dbCreditos.FieldByName('CRE9').AsString='S' then
    begin
     dbCreditos.Edit; dbCreditos.FieldByName('CRE9').AsString:='N'; dbCreditos.Post;
    end
  else
    begin
     dbCreditos.Edit; dbCreditos.FieldByName('CRE9').AsString:='S'; dbCreditos.Post;
    end
end;
procedure TFCreditos.DBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then exit else BitBtn22Click(BitBtn22);
end;

//===================== MARCAR / DESMARCAR DETALLES ==================
procedure TFCreditos.BitBtn29Click(Sender: TObject);
begin
  if dbCreditosdd.Active=False then exit;
  if dbCreditosdd.RecordCount=0 then exit;
  if dbCreditosdd.FieldByName('CRED17').AsString='S' then
    begin
     dbCreditosdd.Edit; dbCreditosdd.FieldByName('CRED17').AsString:='N'; dbCreditosdd.Post;
    end
  else
    begin
     dbCreditosdd.Edit; dbCreditosdd.FieldByName('CRED17').AsString:='S'; dbCreditosdd.Post;
    end
end;
procedure TFCreditos.DBGrid2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then exit else BitBtn29Click(BitBtn29);
end;


//---------------- PINTAR LINEAS MARCADAS EN ROJO ----------------
procedure TFCreditos.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if dbCreditos.FieldByName('CRE9').AsString='S' then
    begin
      DBGrid1.Canvas.Font.Color := clRed;
      //DBGrid2.Canvas.Brush.Color := $00CDDAF1;
      DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
end;
procedure TFCreditos.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if dbCreditosdd.FieldByName('CRED17').AsString='S' then
    begin
      DBGrid2.Canvas.Font.Color := clRed;
      //DBGrid2.Canvas.Brush.Color := $00CDDAF1;
      DBGrid2.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
end;

//======================== DOBLE CLICK EN GRID DE CREDITOS ==================
procedure TFCreditos.DBGrid1DblClick(Sender: TObject);
begin
  if dbCreditos.FieldByName('CRE3').AsString='EN' then RecuperaEntrega();
  if (dbCreditos.FieldByName('CRE3').AsString='NS') or
     (dbCreditos.FieldByName('CRE3').AsString='NT') then RecuperaTicket();
  if dbCreditos.FieldByName('CRE3').AsString='AL' then RecuperaAlbaran();
  if dbCreditos.FieldByName('CRE3').AsString='FA' then RecuperaFactura();
end;

//======================= MOVERSE POR LA SERIES =======================
procedure TFCreditos.ListBox1Click(Sender: TObject);
begin
  if Label33.Caption='N. Factura' then
    begin
      if dbSeries.Locate('SF0',trim(copy(ListBox1.Items.Strings[ListBox1.ItemIndex],1,2)),[]) then
        Edit21.Text:=IntToStr(dbSeries.FieldByName('SF2').AsInteger+1);
    end
  else
    begin
      if dbSeries.Locate('SF0',trim(copy(ListBox1.Items.Strings[ListBox1.ItemIndex],1,2)),[]) then
        Edit21.Text:=IntToStr(dbSeries.FieldByName('SF3').AsInteger+1);
    end
end;


//===================== ACTUALIZAR CAJAS ==========================
procedure TFCreditos.ActualizaCajas();
var
  TxtQ: String;
begin
{ TODO 1 -oNicolas -cCajas : Hay que poner el vendedor que totaliza la operacion en CA1 }
  TxtQ:='SELECT * FROM cajas'+Tienda+' WHERE CA0="'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'"'+
        ' AND CA1=1'+' AND CA2="'+Puesto+'"'+' AND CA3=9999';
  dbCajas.Active:=False; dbCajas.Sql.Text:=TxtQ; dbCajas.Active := True;
  if dbCajas.Recordcount=0 then dbCajas.Append else dbCajas.edit;
  dbCajas.FieldByName('CA0').AsString:= FormatDateTime('DD/MM/YY',FechaVenta); //---- Fecha Caja
  dbCajas.FieldByName('CA1').AsString:='1'; //------------ Dispensador
  dbCajas.FieldByName('CA2').AsString:=Puesto; //--------- Puesto
  dbCajas.FieldByName('CA3').AsString:='9999'; //--------- Familia

  if SwCajaEntrega=1 then
  dbCajas.FieldByName('CA22').Value:=dbCajas.FieldByName('CA22').AsFloat + StrToFloat(Edit3.Text);

  if ( Combo3.ItemIndex=0 ) then  //---- ES PAGO CONTADO
    begin
      //----- Entregas a cuenta o cobro de deudas
      //-- showmessage('CONTADO');
      { SI NO SE PONEN ESTAS LINEAS, DESCUADRA LA CAJA)
      if SwCajaEntrega=1 then
       dbCajas.FieldByName('CA22').Value:=dbCajas.FieldByName('CA22').AsFloat + StrToFloat(Edit3.Text)
      }
       If SwCajaEntrega=1 then SwCajaEntrega:=1
      else
        //-- OJO, ESTA LINEA GENERA EL PAGO NEGATIVO EN CASO DE DARTE UN IMPORTE MÁS GRANDE AL QUE HAY QUE ABONAR
        //-- dbCajas.FieldByName('CA21').Value:=dbCajas.FieldByName('CA21').AsFloat + StrToFloat(Edit14.Text);
        //-- REASIGNADA
        dbCajas.FieldByName('CA21').Value:=dbCajas.FieldByName('CA21').AsFloat + StrToFloat(Edit3.Text);
    end;

  if ( Combo3.ItemIndex < 5 ) and ( Combo3.ItemIndex > 0 ) then  //----- Apuntar tarjetas a las cajas
   begin
     //-- showmessage('TARJETA');     //----- Importe credito ----------
     dbCajas.FieldByName('CA13').Value := dbCajas.FieldByName('CA13').AsFloat + 1;// --- N. Tarjetas
     dbCajas.FieldByName('CA14').Value := dbCajas.FieldByName('CA14').AsFloat + StrToFloat(Edit3.Text);// --- Imp. Tarjetas
   end;

  if Combo3.Text='TALON' then //----- Aun no se dispone de control de Talones
   begin
    //-- showmessage('TALON');
    dbCajas.FieldByName('CA13').Value := dbCajas.FieldByName('CA13').AsFloat + 1;// --- N. Tarjetas
    dbCajas.FieldByName('CA14').Value := dbCajas.FieldByName('CA14').AsFloat + StrToFloat(Edit3.Text);// --- Imp. Tarjetas
   end;

  dbCajas.Post;
end;

//=================== ENTREGAS HIST. OPER. CABECERAS ================
procedure TFCreditos.HistoricoEntregas();
var
  TxtQ: String;
begin

  //TODO: Hay que poner lo que sea para modificar el historico.
  if Copy(Label11.Caption,1,8)='DESGLOSE' then begin showmessage('Sale'); exit; end;


  TxtQ:='INSERT INTO hisopcc'+Tienda+' (HO0,HO1,HO2,HO3,HO4,HO5,HO6,HO7,HO8,HO9,HO10,HO11'+
        ',HO12,HO13,HO14,HO15) VALUES ("'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'",'+
        '"'+FormatDateTime('HH:MM:SS',HoraVenta)+'","'+Puesto+'",'+IntToStr(NOPERACION)+',"'+SERIEFACT+'"'+
        ',"'+TIPOOPER+'","'+'CONTADO'+'",1,'+Edit1.Text+','+
        Edit3.Text+',0,'+Edit3.Text+','+
        Edit4.Text+','+Edit5.Text+',0,"N")';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Historico de operaciones detalles
  TxtQ:='INSERT INTO hisopdd'+Tienda+' (HOD0,HOD1,HOD2,HOD3,HOD4,HOD5,HOD6,HOD7,HOD8,HOD9,HOD10,HOD11'+
        ',HOD12,HOD13,HOD14,HOD15,HOD16) VALUES ("'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'",'+
        '"'+FormatDateTime('HH:MM:SS',HoraVenta)+'","'+Puesto+'",'+IntToStr(NOPERACION)+',"'+SERIEFACT+'",0,"'+
        'ENTREGA","'+Edit6.Text+'",1,'+Edit3.Text+',0,0,0,0,'+Edit3.Text+',"","A")';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;

  //TODO: Falta asignar el numero de usuario que cierra la operacion

end;

//======================== ACTUALIZAR FICHA DEL CLIENTE =======================
procedure TFCreditos.ActuCliente(Importe:Double);
begin
  //-------------------- Actualizar Ficha del cliente
  dbClientes.Edit;
  dbClientes.FieldByName('C21').Value:=dbClientes.FieldByName('C21').AsFloat+Importe;// Entregas
  if Copy(Label11.Caption,1,8)<>'DESGLOSE' then
    begin
     dbClientes.FieldByName('C44').Value:=Date;//-------------------------- Fecha Ult Entega
     dbClientes.FieldByName('C45').Value:=Importe;//----------------------- Imp. Ult. Entrega
    end
  else
    begin
     if dbClientes.FieldByName('C44').Value=FechaVenta then
       dbClientes.FieldByName('C45').Value:=Importe;//-- Si es la ultima entrega Imp. Ult. Entrega
    end;
  dbClientes.Post;
end;

//=====================================================================
//=============== CONTROLAR LOS EDIT DE TOTALIZAR =====================
//=====================================================================
//==================== SALIR DEL DTO FINAL ==============
procedure TFCreditos.Edit13Exit(Sender: TObject);
begin
  if (Edit12.Text='') then begin Edit12.Text:='0.00'; exit; end;
  if (Edit13.Text='') or (Edit13.Text='0.00') then
    begin Edit14.Text:=Edit12.Text; Edit15.Text:=Edit12.Text; Exit; end;
  Edit13.Text:=FormatFloat('0.00',StrToFloat(Edit13.Text));
  Edit14.Text := FormatFloat('0.00',(StrToFloat(Edit12.Text) - (StrToFloat(Edit12.Text) * StrToFloat(Edit13.Text)) / 100 ));
  Edit15.Text:=Edit14.Text;
end;

//=================== SALIR DEL IMPORTE TOTAL + DTO =====================
procedure TFCreditos.Edit14Exit(Sender: TObject);
var
  Pvp, Margen: Double;
begin
  if (Edit14.Text='') or (Edit14.Text='0') then exit;
  //---------- Calcular %dto sobre el pvp
  if (Edit12.Text <> '') and (Edit12.Text <> '0') then
    begin
      Pvp := StrToFloat(StaticText1.Caption);
      Margen := ((Pvp-StrToFloat(Edit14.Text)) * 100 / Pvp);
      Edit13.Text := FormatFloat('0.00',Margen);
    end;
  Edit15.Text:=Edit14.Text;
end;


//=================== SALIR DEL IMPORTE QUE ENTREGA ================
procedure TFCreditos.Edit15Exit(Sender: TObject);
begin
  if Edit15.Text='' then Edit15.Text:='0';
  Edit16.Text:=FormatFloat('0.00',StrToFloat(Edit15.Text)-StrToFloat(Edit14.Text));
  if StrToFloat(Edit16.Text)<0 then
    begin
      Label32.Font.Color:=clRed;
      Label32.Caption:='CREDITO';
      Edit16.Font.Color:=clRed;
    end
  else
    begin
      Label32.Font.Color:=clWindowText;
      Label32.Caption:='CAMBIO';
      Edit16.Font.Color:=clWindowText;
    end;
end;

//==================== PINTAR TOTALES ====================
procedure TFCreditos.PintarTotal();
begin
  LabelDebe.Caption:='0.00'; LabelHaber.Caption:='0.00';
  LabelSaldo.Caption:='0.00'; LabelSaldo.Font.Color:=clWindowText;
  dbTotales.SQL.Text:='SELECT SUM(CRE7),SUM(CRE8) FROM creditos'+Tienda+' WHERE CRE0='+Edit1.Text;
  dbTotales.Active:=True;
  if (dbTotales.RecordCount=0) then begin dbTotales.Active:=False; exit; end;
  LabelDebe.Caption:=FormatFloat('0.00',dbTotales.Fields[0].AsFloat);
  LabelHaber.Caption:=FormatFloat('0.00',dbTotales.Fields[1].AsFloat);
  LabelSaldo.Caption:=FormatFloat('0.00',dbTotales.Fields[0].AsFloat-dbTotales.Fields[1].AsFloat);
  if StrToFloat(LabelSaldo.Caption)>0 then LabelSaldo.Font.Color:=clRed;
  if StrToFloat(LabelSaldo.Caption)<0 then LabelSaldo.Font.Color:=clBlue;
  dbTotales.Active:=False;
end;

//====================== LIMPIA DATOS =====================
procedure TFCreditos.LimpiaDatos();
begin
  LabelDebe.Caption:='0.00'; LabelHaber.Caption:='0.00';
  LabelSaldo.Caption:='0.00'; LabelSaldo.Font.Color:=clWindowText;
  Edit2.Text:=''; Label2.Caption:=''; Label4.Caption:='';
  Label3.Caption:='';  Label5.Caption:=''; Label21.Caption:='';
  Label22.Caption:=''; CheckBox1.Checked:=False;
  CheckBox1.Font.Color:=clWindowText;
  Label24.Caption:=''; Label25.Caption:=''; Label26.Caption:='';
  dbCreditos.Active:=False;
end;

//======== LINEAS A SALDAR (Todas/Marcadas/Sin Marcar) ===============
procedure TFCreditos.RadioGroup1Click(Sender: TObject);
begin
   if RadioGroup1.ItemIndex=0 then SeleccionaLineas('Todas');
   if RadioGroup1.ItemIndex=1 then SeleccionaLineas('Marcadas');
   if RadioGroup1.ItemIndex=2 then SeleccionaLineas('Sin Marcar');

end;
procedure TFCreditos.SeleccionaLineas(Marca:String);
var
  TxtQ: String;
begin
  TxtQ:='SELECT SUM(CRE7),SUM(CRE8) FROM creditos'+Tienda+' WHERE CRE0='+Edit1.Text;
  if Marca='Marcadas' then TxtQ:=TxtQ+' AND CRE9="S"';
  if Marca='Sin Marcar' then TxtQ:=TxtQ+' AND CRE9<>"S"';
  dbTotales.SQL.Text:=TxtQ;
  dbTotales.Active:=True;
  Label32.Font.Color:=clWindowText; Label32.Caption:='CAMBIO';
  Edit16.Font.Color:=clWindowText;
  //----- Importe
  Edit12.Text:=FormatFloat('0.00',dbTotales.Fields[0].AsFloat-dbTotales.Fields[1].AsFloat);
  Edit13.Text:='0.00';//------------------ Dto.
  Edit14.Text:=Edit12.Text;//----- Total
  Edit15.Text:=Edit12.Text;//----- Entrega
  Edit16.Text:='0.00';//---------- Cambio
  dbTotales.Active:=False;
end;

//================ CHEQUEAR LINEAS PARA SALDAR (TOD/MARC/SIN MAR) =============
function TFCreditos.CheckLineas(): Boolean;
begin
   Result:=False;
   //----- Saldar todas
   if (RadioGroup1.ItemIndex=0) then Result:=True;
   //----- Saldar las marcadas
   if (RadioGroup1.ItemIndex=1) and (dbCreditos.FieldByName('CRE9').AsString='S') then Result:=True;
   //----- Saldar las sin marcar
   if (RadioGroup1.ItemIndex=2) and (dbCreditos.FieldByName('CRE9').AsString<>'S') then Result:=True;
end;


//=================== SELECCIONAR SERIE DE FACTURACION POR DEFECTO ============
procedure TFCreditos.VerSerieFacturacion();
begin
  //--- Ver la tienda activa para saber que serie usa por defecto
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin Showmessage('NO SE EN QUE TIENDA FACTURAR'); Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); exit; end;
  dbSeries.Locate('SF0', dbTiendas.Fields[11].AsString, [loCaseInsensitive]);
  SERIEFACT:=dbSeries.FieldByName('SF0').AsString;
  dbTiendas.Active:=False; dbSeries.Active:=False;
end;

//================= N. DE TICKET ===========================
procedure TFCreditos.NumeroTicket();
begin
  if SERIEFACT='' then begin SERIEFACT:='';NOPERACION:=0; Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF4=SF4+1 WHERE SF0="'+SERIEFACT+'"';
  dbSeries.ExecSql;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+SERIEFACT+'"';
  dbSeries.Active:=True;
  if dbSeries.Recordcount=0 then exit;
  NOPERACION:=dbSeries.Fields[4].AsInteger;
  dbSeries.Active:=False;
end;

//================= N. DE ALBARAN ===========================
procedure TFCreditos.NumeroAlbaran();
begin
  if SERIEFACT='' then begin SERIEFACT:='';NOPERACION:=0; Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF3=SF3+1 WHERE SF0="'+SERIEFACT+'"';
  dbSeries.ExecSql;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+SERIEFACT+'"';
  dbSeries.Active:=True;
  if dbSeries.Recordcount=0 then exit;
  NOPERACION:=dbSeries.Fields[3].AsInteger;
  dbSeries.Active:=False;
end;

//================= N. DE FACTURA ===========================
procedure TFCreditos.NumeroFactura();
begin
  if SERIEFACT='' then begin SERIEFACT:='';NOPERACION:=0; Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF2=SF2+1 WHERE SF0="'+SERIEFACT+'"';
  dbSeries.ExecSql;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+SERIEFACT+'"';
  dbSeries.Active:=True;
  if dbSeries.Recordcount=0 then exit;
  NOPERACION:=dbSeries.Fields[2].AsInteger;
  dbSeries.Active:=False;
end;

//================= SACAR EL ULT N. DE LINEA HIST. OPERACIONES ================
function TFCreditos.VerUltimaLineaHisto: Integer;
begin
  VerUltimaLineaHisto:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(HOD5) As ULTIMA FROM hisopdd'+Tienda+
                    ' WHERE HOD0="'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'"'+
                    ' AND HOD1="'+FormatDateTime('HH:MM:SS',HoraVenta)+'"'+
                    ' AND HOD2="'+Puesto+'"'+
                    ' AND HOD3='+IntToStr(NOPERACION)+' AND HOD4="'+SERIEFACT+'"';
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLineaHisto:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;

//================= SACAR EL ULT N. DE LINEA HIST. OPERACIONES ================
function TFCreditos.VerUltimaLineaAlba: Integer;
begin
  VerUltimaLineaAlba:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(AD4) As ULTIMA FROM albad'+Tienda+' WHERE AD0='+Edit1.Text+
                    ' AND AD1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'" AND AD2="'+SERIEFACT+'"'+
                    ' AND AD3='+IntToStr(NOPERACION);
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLineaAlba:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;


//=====================================================================
//==================== CARGAR TOTALES PARA IMPRESION ==================
//=====================================================================
procedure TFCreditos.CargarTotales();
begin
  dbTrabajo.First;
  //------------------------ Primer tipo de iva
  if dbTrabajo.Eof=False then
   begin
    PIVA1:=dbTrabajo.Fields[0].AsInteger;
    IMPOIVA1:=dbTrabajo.Fields[1].AsFloat;
    BASE1:=dbTrabajo.Fields[2].AsFloat;
    TOTAL1:=dbTrabajo.Fields[3].AsFloat;
    //---------------- Recargo
    if dbClientes.FieldByName('C19').AsString='S' then
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
    if dbClientes.FieldByName('C19').AsString='S' then
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
    if dbClientes.FieldByName('C19').AsString='S' then
      begin
       VerRecargo();
       PRIVA3:=RECARGO;
       IRIVA3:=dbTrabajo.Fields[2].AsFloat-((dbTrabajo.Fields[2].AsFloat*100)/(RECARGO+100));
       TOTAL3:=dbTrabajo.Fields[3].AsFloat+dbTrabajo.Fields[2].AsFloat-((dbTrabajo.Fields[2].AsFloat*100)/(RECARGO+100));
      end;
   end;
end;

//================ TIPOS DE RECARGO =====================
procedure TFCreditos.VerRecargo();
begin
   RECARGO:=RIVA1;
   if dbTrabajo.Fields[0].AsFloat=IVA1 then RECARGO:=RIVA1;
   if dbTrabajo.Fields[0].AsFloat=IVA2 then RECARGO:=RIVA2;
   if dbTrabajo.Fields[0].AsFloat=IVA3 then RECARGO:=RIVA3;
end;

{

//=====================================================================
//==================== IMPRIMIR TICKETS ===============================
//=====================================================================
procedure TFCreditos.ImpreTicket();
var
  Texto: String;
begin
//  OpenDialog1.FileName:=DevTicket;  //cambiaddo por javi para quitar opendialog
// AssignFile(PrintText, OpenDialog1.FileName); //cambiado por javi para quitar opendialog
  AssignFile(PrintText, DevTicket); //añadido por javi para quitar opendialog
  Rewrite(PrintText);
  CabeceraTicket();
  dbCreditos.First;
  while not dbCreditos.Eof do
    begin
      //  Writeln(PrintText, '  FECHA    TI N.OPER.      DEBE    HABER');
      //  Writeln(PrintText, '========================================');
      //                      12/12/1234 TI S1234567 12345.12 12345.12
      if CheckLineas=False then begin dbCreditos.Next; Continue; end;//--- Ver tipo de marca de la linea
      Texto:=FormatDateTime('DD/MM/YYYY',dbCreditos.FieldByName('CRE1').AsDateTime)+' '+
      dbCreditos.FieldByName('CRE3').AsString+' '+
      DataModule1.LFill(dbCreditos.FieldByName('CRE4').AsString+
                        dbCreditos.FieldByName('CRE5').AsString,8,' ') + ' '+
      DataModule1.LFill(FormatFloat('##0.00',dbCreditos.FieldByName('CRE7').AsFloat),8,' ') + ' '+
      DataModule1.LFill(FormatFloat('##0.00',dbCreditos.FieldByName('CRE8').AsFloat),8,' ');
      Writeln(PrintText, Texto);
      dbCreditos.Next;
     end;
  PieTicket();
  Corte();
  CloseFile(PrintText);

  //TODO: Falta solucionar la impresion en cola

(*    //------ Imprimir en cola
    if CmdTicket<>'' then
      begin
       TxtCmd:=PChar(String(CmdTicket+' '+DevTicket));
       libc.system(TxtCmd);
      end;
*)

end;


//============== CABECERA DEL TICKETC ===================================
procedure TFCreditos.CabeceraTicket();
begin
  if Trim(LCTI1)<>'' then Writeln(PrintText, LCTI1);
  if Trim(LCTI2)<>'' then Writeln(PrintText, LCTI2);
  if Trim(LCTI3)<>'' then Writeln(PrintText, LCTI3);
  if Trim(LCTI4)<>'' then Writeln(PrintText, LCTI4);
  Writeln(PrintText, ' ');

  Writeln(PrintText, 'N.TICKET.: '+SERIEFACT+'/'+DataModule1.LFill(FormatFloat('#######',NOPERACION),7,' '));

  Writeln(PrintText, ' ');
  Writeln(PrintText, 'Fecha.: '+FormatDateTime('dd/mm/yyyy',FechaVenta)+'   Hora.:'+FormatDateTime('hh:mm:ss',HoraVenta));
  Writeln(PrintText, ' ');
  Writeln(PrintText, '  FECHA    TI N.OPER.      DEBE    HABER');
  Writeln(PrintText, '========================================');
//                    12/12/1234 TI S1234567 12345.12 12345.12
end;

//====================== PIE DEL TICKETC =============================
procedure TFCreditos.PieTicket();
Var
  Texto1,Texto2,Texto3: String;
  Conta: Integer;
begin
  Writeln(PrintText, ' ');
  Writeln(PrintText, '                               ---------');
  //---------------- Descuento
  if (Edit13.Text<>'') and (StrToFloat(Edit13.Text)<>0) then
    begin
     Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(Edit12.Text)),10,' ');
     Texto3:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(Edit14.Text)),10,' ');
     Texto2:=DataModule1.LFill( FormatFloat('##0.00',StrToFloat(Edit13.Text)),6,' ');
     Writeln(PrintText, 'TOTAL:'+Texto1+'-'+Texto2+'% Dto ='+Texto3);
    end
  else
    begin
     Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(Edit14.Text)),10,' ');
     Writeln(PrintText, '                    TOTAL     '+Texto1);
    end;
  Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(Edit15.Text)),10,' ');
  Writeln(PrintText, '                    ENTREGA   '+Texto1);
  Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(Edit16.Text)),10,' ');
  if StrToFloat(Edit16.Text)>=0 then
    Writeln(PrintText, '                    CAMBIO    '+Texto1)
  else
    Writeln(PrintText, '                    CREDITO   '+Texto1);
  Writeln(PrintText, ' ');
  //----------------- Sacar iva uncluido en el ticket o no --------------
  if SacaIva<>'N' then
    begin
     Writeln(PrintText, '            * IVA INCLUIDO *            ');
     Writeln(PrintText, ' ');
    end;

  //TODO: Falta una cola con el credito pendiente

  //----------------- Sacar vendedor en el ticket o no --------------
  if SacaVende<>'N' then Writeln(PrintText, 'LE ATENDIO.: '+ copy(StaticText12.Caption,1,35));

  //----------------------------------------------------------------
  if Trim(LPTI1)<>'' then Writeln(PrintText, LPTI1);
  if Trim(LPTI2)<>'' then Writeln(PrintText, LPTI2);
  if Trim(LPTI3)<>'' then Writeln(PrintText, LPTI3);
  for Conta:=1 to StrToInt(LiFinTick) do Writeln(PrintText, ' ');
end;

}

//===================== ABRIR CAJON ===================
procedure TFCreditos.BitBtn17Click(Sender: TObject);
var
  F : TextFile;
  fichero : string;
begin
//============================= KeyLog de Apertura CAJON ===============================
//-- textoaprobación,codigo13 y descrip50, canti3,precio6,total6 añadidos por el keyloger
     fichero:='';
     if FileExists(RutaIni+'Cajon_'+FormatDateTime('YYYYMM',(Date-63))+'.txt' ) then
       begin
         //-- borrado del fichero de hace 63 días
         fichero:=(RutaIni+'Cajon_'+FormatDateTime('YYYYMM',(Date-63))+'.txt' );
         DeleteFile(fichero);
       end;
      AssignFile( F, RutaIni + 'Cajon_'+FormatDateTime('YYYYMM',Date)+'.txt' );
      if FileExists(RutaIni+'Cajon_'+FormatDateTime('YYYYMM',(Date))+'.txt' ) then Append(F) else Rewrite( F );
      WriteLn( F, '#============== APERTURA DE CAJON SIN VENTA ================');
      WriteLn( F, '#= AUTORIZACION - DESDE CREDITOS SIN AUTORIZACION');
      WriteLn( F, 'CAJA : ' + Puesto +' - Dia : ' + FormatDateTime('YYYYMMDD',(Date)) + ' - Hora : ' + FormatDateTime('HH:MM:SS',(time)) );
      CloseFile( F );
//============================= KeyLog de Apertura CAJON ===============================
  Cajon();
end;

procedure TFCreditos.BitBtn18Click(Sender: TObject);
begin
  //-- No implementado en impresora ni correcto ticket
  BitBtn26Click(Self);
end;

procedure TFCreditos.Cajon();
begin
  if trim(CgoCajon)='' then exit;
  try
//   OpenDialog1.FileName:=DevTicket; //cambiado por javi para quitar opendialog1
//   AssignFile(PrintText, OpenDialog1.FileName); //cambiado por javi para quitar opendialog1
   AssignFile(PrintText, DevTicket); //añadido por javi para quitar opendialog1
   Rewrite(PrintText);
   WriteLn(PrintText, PCgoCajon);
   CloseFile(PrintText);

//TODO: Falta solucionar la impresion en cola
(*    //------ Imprimir en cola
    if CmdTicket<>'' then
      begin
       TxtCmd:=PChar(String(CmdTicket+' '+DevTicket));
       libc.system(TxtCmd);
      end;
*)
  except
   ShowMessage('NO PUEDE ABRIR EL CAJON, REVISE LA TIQUETERA');
  end;
end;

//================== CORTE DE PAPEL ===================
//procedure TFCreditos.Corte();
//begin
//  if trim(CgoCorte)='' then exit;
//  WriteLn(PrintText, PCgoCorte);
//end;

//=============== Pasar parametros a los reports de facturas / albaranes =======
procedure TFCreditos.frReport2GetValue(const ParName: String;
  var ParValue: Variant);
begin
  if ParName='EMPRESA' then ParValue := Empresa;
  if ParName='DIRECCION' then ParValue := Direccion;
  if ParName='LOCALIDAD' then ParValue := Localidad;
  if ParName='CP' then ParValue := CP;

  if ParName='PROVINCIA' then ParValue := Provincia;
  if ParName='NIF' then ParValue := Nif;
  if ParName='TELEFONO' then ParValue := Telefono;
  if ParName='FAX' then ParValue := Fax;
  if ParName='EMAIL' then ParValue := EMail;

  if ParName='CCLIENTE' then ParValue := dbClientes.FieldByName('C1').AsString;
  if ParName='CDIRECCION' then ParValue := dbClientes.FieldByName('C3').AsString;
  if ParName='CLOCALIDAD' then ParValue := dbClientes.FieldByName('C4').AsString;
  if ParName='CCIF' then ParValue := dbClientes.FieldByName('C5').AsString;
  if ParName='CCP' then ParValue := dbClientes.FieldByName('C37').AsString;
  if ParName='CPROVINCIA' then ParValue := dbClientes.FieldByName('C38').AsString;
  if ParName='FECHA' then ParValue := Edit22.Text;

  if ParName='SERIE' then ParValue := SERIEFACT;
  if ParName='NUMERO' then ParValue := IntToStr(NOPERACION);

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
  if ParName='OBSERVACIONES' then ParValue := Memo1.Lines.Text;
end;

//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFCreditos.frReport2EnterRect(Memo: TStringList; View: TfrView);
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


initialization
  {$I creditos.lrs}

end.

