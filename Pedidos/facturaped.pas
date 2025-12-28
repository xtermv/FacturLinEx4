{
  Gestion LinEx FacturLinEx-2

  Copyright (C) 2000-2011

  Nicolas Lopez de Lerma Aymerich <nicolas@esdebian.org>

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

unit facturaped;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  Buttons, ZConnection, StdCtrls, ZDataset, ExtDlgs, EditBtn, DBGrids, ExtCtrls,
  db, LCLType, ComCtrls, LR_Class, LR_DBSet, dateutils;

type

  { TFFacturaped }

  TFFacturaped = class(TForm)
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn23: TBitBtn;
    BitBtn3: TBitBtn;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    CalendarDialog1: TCalendarDialog;
    ComboBox1: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    DateEdit1: TDateEdit;
    dbMuestrad: TZQuery;
    dbFactud: TZQuery;
    dbFactuc: TZQuery;
    dbHisopdd: TZQuery;
    dbBusca: TZQuery;
    dbTrabajo: TZQuery;
    dbMuestraf: TZQuery;
    dbAlbadd: TZQuery;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    dbHisopcc: TZQuery;
    dbSumas: TZQuery;
    dbAlbacc: TZQuery;
    dbTiendas: TZQuery;
    dbSeries: TZQuery;
    dbRutas: TZQuery;
    Edit1: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit3: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
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
    Label3: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label4: TLabel;
    dbProveedores: TZQuery;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel8: TPanel;
    ProgressBar1: TProgressBar;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn23Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ActuFactuc();
    procedure ActuFactud();
    procedure ActuFactuVen();
    procedure VerVencimientos();
    function VerUltimaLinea: Integer;

  private
    { private declarations }
  public
    { public declarations }
  end; 

  procedure ShowFormFacturaPedi();

var
  FFacturaped: TFFacturaped;
  SFACTURA,NFACTURA: String;
  BASE1,BASE2,BASE3,IMPOIVA1,IMPOIVA2,IMPOIVA3,TOTAL1,TOTAL2,TOTAL3: Double;
  IRIVA1,IRIVA2,IRIVA3,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PRIVA1,PRIVA2,PRIVA3:Double;
  Fecha, Hora: TDateTime;
  NLinea: Integer;
  FECHAPAGO1,FECHAPAGO2,FECHAPAGO3,FECHAPAGO4: String;
  IMPOPAGO1,IMPOPAGO2,IMPOPAGO3,IMPOPAGO4: String;

implementation

uses
  Global, Funciones, Busquedas;

{ TFFacturaped }

//====================== CREAR FORMULARIO =======================
procedure ShowFormFacturaPedi();
begin
  with TFFacturaped.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFFacturaped.FormCreate(Sender: TObject);
begin
  //--------- Conectar con la bbdd e inicializar datos globales
  //Conectate(dbConnect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------------
  Edit7.Text:='01/'+FormatDateTime('MM/YYYY',Date);
  Edit8.Text:=FormatDateTime('DD/MM/YYYY',Date);
  //---------------- Rellenar ComboBox fijos -----------
  RellenaComboBoxCambiableNombre('SELECT T1 FROM tiendas', dbTiendas, ComboBox1);
  RellenaComboBoxCambiableNombre('SELECT SF1 FROM seriesfactu', dbSeries, ComboBox4);
  ComboBox4.Items.Add('TODAS LAS SERIES');
  //------------------- Tienda activa ---------------
  dbTiendas.Active:=False;
  dbTiendas.SQL.Text:='SELECT * FROM tiendas';
  dbTiendas.Active:=True;
  if dbTiendas.RecordCount=0 then begin ShowMessage('NO HAY TIENDAS'); Close(); end;
  if not dbTiendas.Locate('T0',Tienda,[]) then
     begin ShowMessage('LA TIENDA ACTIVA NO EXISTE?'); Close(); end;
  ComboBox1.ItemIndex:=ComboBox1.Items.IndexOf(dbTiendas.FieldByName('T1').AsString);
  //------------------- Serie activa ---------------
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin ShowMessage('NO HAY SERIES DE PEDIDOS'); Close(); end;
  if not dbSeries.Locate('SF0',dbTiendas.FieldByName('T11').AsString,[]) then
     begin ShowMessage('NO HAY SERIE DE PEDIDOS ACTIVA?'); Close(); end;
  ComboBox4.ItemIndex:=ComboBox4.Items.IndexOf(dbSeries.FieldByName('SF1').AsString);
end;

//====================== CERRAR FORMULARIO =======================
procedure TFFacturaped.BitBtn1Click(Sender: TObject);
begin
  Close();
end;
procedure TFFacturaped.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//=================================================================
//====================== APLICAR FILTROS ==========================
//=================================================================
procedure TFFacturaped.BitBtn2Click(Sender: TObject);
var
  TxtQ: String;
begin
  if (Edit1.Text='') then exit;
  if ComboBox4.Text='' then exit;
  if ComboBox4.Text<>'TODAS LAS SERIES' then
    begin
     if not dbSeries.Locate('SF1',ComboBox4.Text,[]) then
       begin showmessage('La serie activa no existe.'); exit; end;
    end;
  //------------- Albaranes
  TxtQ:='SELECT *,MID(HPC43,1,250) as ANOTAS FROM hipedicc'+Tienda+
        ' WHERE HPC2='+Edit1.Text+
        ' AND HPC1>="'+FormatDateTime('yyyy/mm/dd',StrToDate(Edit7.Text))+'"'+
        ' AND HPC1<="'+FormatDateTime('yyyy/mm/dd',StrToDate(Edit8.Text))+'"';
  if ComboBox4.Text<>'TODAS LAS SERIES' then TxtQ:=TxtQ+' AND HPC3="'+dbSeries.FieldByName('SF0').AsString+'"';
  if ComboBox5.Text<>'' then TxtQ:=TxtQ+' AND HPC28="'+Copy(ComboBox5.Text,1,1)+'"';//-------------- Tipo Doc proveedor
  if RadioButton2.Checked then TxtQ:=TxtQ+' AND HPC46="S"';//---- Los marcados
  if RadioButton3.Checked then TxtQ:=TxtQ+' AND HPC46="N"';//---- Sin Marcar
  TxtQ:=TxtQ+' ORDER BY HPC2,HPC1';
  dbAlbacc.Active:=False; dbAlbacc.Sql.Text:=TxtQ; dbAlbacc.Active:=True;
  dbAlbacc.First;
  //------------- Facturas a realizar
  TxtQ:='SELECT HPC2,COUNT(HPC4),SUM(HPC5),SUM(HPC6),SUM(HPC7),SUM(HPC8),SUM(HPC9),HPC13 FROM hipedicc'+Tienda+
        ' WHERE HPC2='+Edit1.Text+
        ' AND HPC1>="'+FormatDateTime('yyyy/mm/dd',StrToDate(Edit7.Text))+'"'+
        ' AND HPC1<="'+FormatDateTime('yyyy/mm/dd',StrToDate(Edit8.Text))+'"';
  if ComboBox4.Text<>'TODAS LAS SERIES' then TxtQ:=TxtQ+' AND HPC3="'+dbSeries.FieldByName('SF0').AsString+'"';
  if ComboBox5.Text<>'' then TxtQ:=TxtQ+' AND HPC28="'+Copy(ComboBox5.Text,1,1)+'"';//-------------- Tipo Doc proveedor
  if RadioButton2.Checked then TxtQ:=TxtQ+' AND HPC46="S"';//---- Los marcados
  if RadioButton3.Checked then TxtQ:=TxtQ+' AND HPC46="N"';//---- Sin Marcar
  TxtQ:=TxtQ+' GROUP BY HPC2 ORDER BY HPC2';
  dbMuestraf.Active:=False; dbMuestraf.Sql.Text:=TxtQ; dbMuestraf.Active:=True;
  dbMuestraf.First;
  //------------------- Sumas
  TxtQ:='SELECT SUM(HPC5),SUM(HPC6),SUM(HPC7),SUM(HPC8) FROM hipedicc'+Tienda+
        ' WHERE HPC2='+Edit1.Text+
        ' AND HPC1>="'+FormatDateTime('yyyy/mm/dd',StrToDate(Edit7.Text))+'"'+
        ' AND HPC1<="'+FormatDateTime('yyyy/mm/dd',StrToDate(Edit8.Text))+'"';
  if ComboBox4.Text<>'TODAS LAS SERIES' then TxtQ:=TxtQ+' AND HPC3="'+dbSeries.FieldByName('SF0').AsString+'"';
  if ComboBox5.Text<>'' then TxtQ:=TxtQ+' AND HPC28="'+Copy(ComboBox5.Text,1,1)+'"';//-------------- Tipo Doc proveedor
  if RadioButton2.Checked then TxtQ:=TxtQ+' AND HPC46="S"';//---- Los marcados
  if RadioButton3.Checked then TxtQ:=TxtQ+' AND HPC46="N"';//---- Sin Marcar
  dbSumas.Active:=False; dbSumas.Sql.Text:=TxtQ; dbSumas.Active:=True;
  dbSumas.First;
  StaticText4.Caption:=IntToStr(dbAlbacc.RecordCount);//-------- N. Albaranes.
  StaticText5.Caption:=IntToStr(dbMuestraf.RecordCount);//-------- N. Facturas
  StaticText2.Caption:=dbSumas.Fields[0].AsString;//--------- N. Lineas.
  StaticText3.Caption:=FormatFloat('0.00',dbSumas.Fields[1].AsFloat);//--------- N. Articulos.
  StaticText7.Caption:=FormatFloat('0.00',dbSumas.Fields[2].AsFloat);//--------- Importe
  StaticText8.Caption:=FormatFloat('0.00',dbSumas.Fields[3].AsFloat);//--------- Importe + impuestos
  dbSumas.Active:=False;
  if dbAlbacc.RecordCount>0 then BitBtn3.Enabled:=True;
end;



//=================================================================
//======================= FACTURAR ALBARANES ======================
//=================================================================
procedure TFFacturaped.BitBtn3Click(Sender: TObject);
var
  TxtQ: String;
begin
  if dbAlbacc.Active=False then exit;
  if dbAlbacc.RecordCount=0 then exit;
  TxtQ:='SE FACTURARAN '+StaticText4.Caption+' ALBARANES, CONTINUAR?';
  if Application.MessageBox(PChar(TxtQ),'FacturLinEx', boxstyle) = IDNO Then Exit;
  Label33.Caption:='N. Factura';  Label34.Caption:='Fecha Factura';
  DateEdit1.Date:=Date; Edit21.Text:='';
  Panel8.Visible:=True;
  PageControl1.Enabled:=False; BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
end;

//======================== ACEPTAR FACTURAR =====================
procedure TFFacturaped.BitBtn23Click(Sender: TObject);
var
  TxtQ: String;
begin
  label16.Enabled:=True; ProgressBar1.Enabled:=True; ProgressBar1.Max:=dbAlbacc.RecordCount;

  SFACTURA:=Edit22.Text;
  NFACTURA:=Edit21.Text;
  if SFACTURA='' then begin showmessage('DEBE PONER UNA SERIE PARA FACTURAR'); Exit; end;
  if NFACTURA='' then begin showmessage('DEBE PONER UN NUMERO DE FACTURA PARA FACTURAR'); Exit; end;
  Hora:=Time; NLinea:=1;
  dbAlbacc.First;
  While not dbAlbacc.Eof do
   begin
      ProgressBar1.Position:= dbAlbacc.RecNo;
      Application.ProcessMessages;
      TxtQ:='SELECT * FROM hipedidd'+Tienda+' WHERE HPD0='+dbAlbacc.Fields[0].AsString+
            ' AND HPD1="'+FormatDateTime('yyyy/mm/dd',dbAlbacc.Fields[1].asDateTime)+'"'+
            ' AND HPD2='+dbAlbacc.Fields[2].AsString+' AND HPD3="'+dbAlbacc.Fields[3].AsString+'"'+
            ' AND HPD4='+dbAlbacc.Fields[4].AsString+' ORDER BY HPD5';
      dbAlbadd.Active:=False; dbAlbadd.Sql.Text:=TxtQ;
      dbAlbadd.Active := True; dbAlbadd.First;
      while not dbAlbadd.Eof do
        begin
           ActuFactud();//---------- Detalles
           dbAlbadd.Next;
        end;
      ActuFactuc(); //------------- Cabeceras
      dbAlbacc.Next;
   end;
  ProgressBar1.Position:=0;label16.Enabled:=False; ProgressBar1.Enabled:=False;
  //------------------- Marcar pedidos/albarenes/Notas como facturados
  dbAlbacc.First;
  While not dbAlbacc.Eof do
   begin
      dbAlbacc.Edit;
      dbAlbacc.FieldByName('HPC47').AsString:='S';
      dbAlbacc.Post;
      dbAlbacc.Next;
   end;
 Close();
end;

//======================== CANCELAR FACTURAR =====================
procedure TFFacturaped.BitBtn20Click(Sender: TObject);
begin
  Panel8.Visible:=False;
  PageControl1.Enabled:=True; BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
end;


//======================= CABECERA DE FACTURAS ========================
procedure TFFacturaped.ActuFactuc();
var
  TxtQ: String;
begin
  dbFactuc.Active:=False;
  TxtQ:='SELECT * FROM hipedifacc'+Tienda+' WHERE FC0='+dbAlbacc.FieldByName('AC0').AsString+
        ' AND FC1="'+FormatDateTime('YYYY/MM/DD',DateEdit1.Date)+
        '" AND FC2="'+SFACTURA+'" AND FC3="'+NFACTURA+'"';
  dbFactuc.Sql.Text:=TxtQ; dbFactuc.Active:=True; dbFactuc.First;
  if dbFactuc.Recordcount=0 then
    begin
     dbFactuc.append;
 {
     Tienda............................................................................	INT(4)			HPC0
     Fecha.............................................................................	DATE			HPC1
     Proveedor......................................................................	INT(11)		        HPC2
     Serie Pedido.................................................................	CHAR(3)		        HPC3
     Nº Pedido......................................................................	INT(5)			HPC4
     Nº de líneas......................................................................	INT(6)	 		HPC5
     Nº Artículos......................................................................	INT(7)			HPC6


     Tienda............................................................................	INT(4)			HPC0
     Fecha.............................................................................	DATE			HPC1
     Proveedor......................................................................	INT(11)		HPC2
     Serie Factura.................................................................	CHAR(5)		HPC3
     Nº Factura......................................................................	CHAR(15)		HPC4
     Nº de líneas......................................................................	INT(6)	 		HPC5
     Nº Artículos......................................................................	INT(7)			HPC6
  }


     dbFactuc.FieldByName('HPC0').Value:=dbAlbacc.FieldByName('HPC0').Value;//----- Tienda
     dbFactuc.FieldByName('HPC1').AsString:=FormatDateTime('dd/mm/yyyy',DateEdit1.Date);//-- Fecha Factura
     dbFactuc.FieldByName('HPC2').Value:=dbAlbacc.FieldByName('HPC2').Value;//----- Proveedor

     dbFactuc.FieldByName('HPC2').Value:=SFACTURA;//------------------------------- Serie Factura.
     dbFactuc.FieldByName('HPC3').Value:=NFACTURA;//------------------------------- N. Factura.án
     dbFactuc.FieldByName('HPC4').Value:=NLinea-1;//------------------------------- Nº Lineas
     dbFactuc.FieldByName('HPC5').Value:=dbAlbacc.FieldByName('AC5').AsFloat;//---- Nº Articulos.
     dbFactuc.FieldByName('HPC6').Value:=dbAlbacc.FieldByName('AC6').AsFloat;//---- Dto. Pronto Pago
     dbFactuc.FieldByName('HPC7').Value:=dbAlbacc.FieldByName('AC7').AsString;//--- Recargo Equivalencia.
     dbFactuc.FieldByName('HPC8').Value:=dbAlbacc.FieldByName('AC8').AsFloat;//---- Importe sin IVA
     dbFactuc.FieldByName('HPC9').Value:=dbAlbacc.FieldByName('AC9').AsFloat;//---- Importe con IVA
     dbFactuc.FieldByName('HPC10').Value:='N';//----------------------------------- Marcado S/N.
     dbFactuc.FieldByName('HPC23').Value:='N';//----------------------------------- Pagado S/N.
    end
  else
    begin
     dbFactuc.edit;
     dbFactuc.FieldByName('FC4').Value:=NLinea-1; //----------------------- Nº Lineas
     dbFactuc.FieldByName('FC5').Value:=dbFactuc.FieldByName('FC5').AsFloat+dbAlbacc.FieldByName('AC5').AsFloat;//---- Nº Articulos.
     dbFactuc.FieldByName('FC8').Value:=dbFactuc.FieldByName('FC8').AsFloat + dbAlbacc.FieldByName('AC8').AsFloat;//-- Importe sin IVA
     dbFactuc.FieldByName('FC9').Value:=dbFactuc.FieldByName('FC9').AsFloat + dbAlbacc.FieldByName('AC9').AsFloat;//-- Importe con IVA
    end;
  dbFactuc.Post;
end;

//======================= DETALLES DE FACTURAS ========================
procedure TFFacturaped.ActuFactud();
var
  TxtQ: String;
  Conta: Integer;
begin
  dbFactud.Active:=False;
  TxtQ:='SELECT * FROM hipedifadd'+Tienda+' WHERE FD0='+dbAlbadd.Fields[0].AsString+
        ' AND FD1="'+FormatDateTime('YYYY/MM/DD',DateEdit1.Date)+'" AND FD2="'+SFACTURA+'"'+
        ' AND FD3="'+NFACTURA+'"';
  dbFactud.Sql.Text:=TxtQ; dbFactud.Active:=True;
  dbFactud.append;
  dbFactud.FieldByName('FD0').Value:=dbAlbadd.FieldByName('AD0').Value;//--------------- Cgo. Cliente
  dbFactud.FieldByName('FD1').AsString:=FormatDateTime('dd/mm/yyyy',DateEdit1.Date);//-- Fecha Factura
  dbFactud.FieldByName('FD2').Value:=SFACTURA; //------------------- Serie Factura
  dbFactud.FieldByName('FD3').Value:=NFACTURA; //------------------- N. Factura
  dbFactud.FieldByName('FD4').Value:=VerUltimaLinea;//-------------- Nº Linea
  for conta:=5 to 15 do
    dbFactud.Fields[Conta].Value:=dbAlbadd.Fields[Conta].Value;
  //-------- Observaciones y N. Albaran.
  dbFactud.FieldByName('FD16').Value:='Albaran.: '+
           dbAlbadd.Fields[2].AsString+'/'+dbAlbadd.Fields[3].AsString+
           ' - '+FormatDateTime('dd/mm/yyyy',dbAlbadd.Fields[1].AsDateTime)+
           ' - '+dbAlbacc.FieldByName('AC11').AsString;

  dbFactud.Fields[17].Value:=dbAlbadd.Fields[17].Value;//-------------- precio tarifa.
  dbFactud.Post;
  NLinea:=NLinea+1;
end;

//=================== SACAR EL ULT N. DE LINEA =====================
function TFFacturaped.VerUltimaLinea: Integer;
begin
  VerUltimaLinea:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(FD4) As ULTIMA FROM factud'+Tienda+' WHERE FD0='+dbAlbadd.Fields[0].AsString+
                    ' AND FD1="'+FormatDateTime('YYYY/MM/DD',DateEdit1.Date)+'" AND FD2="'+SFACTURA+'"'+
                    ' AND FD3="'+NFACTURA+'"';
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLinea:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;

//===================== Facturas Cab Vencimientos =======================
procedure TFFacturaped.ActuFactuVen();
begin
  if FECHAPAGO1='' then Exit;
  dbFactuc.Edit;
  dbFactuc.FieldByName('FC11').AsString:=FECHAPAGO1;
  dbFactuc.FieldByName('FC12').AsString:=IMPOPAGO1;
  if FECHAPAGO2<>'' then
   begin
    dbFactuc.FieldByName('FC13').AsString:=FECHAPAGO2;
    dbFactuc.FieldByName('FC14').AsString:=IMPOPAGO2;
   end;
  if FECHAPAGO3<>'' then
   begin
    dbFactuc.FieldByName('FC15').AsString:=FECHAPAGO3;
    dbFactuc.FieldByName('FC16').AsString:=IMPOPAGO3;
   end;
  if FECHAPAGO4<>'' then
   begin
    dbFactuc.FieldByName('FC17').AsString:=FECHAPAGO3;
    dbFactuc.FieldByName('FC18').AsString:=IMPOPAGO3;
   end;
  dbFactuc.Post;
end;


//====================== PRIMER PROVEEDOR =======================
procedure TFFacturaped.Edit1Enter(Sender: TObject);
begin
  Edit3.Text:='';
end;
procedure TFFacturaped.Edit1Exit(Sender: TObject);
begin
  if Edit1.Text='' then Edit1.Text:='1';
  dbProveedores.Active:=False;
  dbProveedores.SQL.Text:='SELECT P0,P1 FROM proveedores where P0='+Edit1.Text;
  dbProveedores.Active:=True;
  if dbProveedores.RecordCount=0 then begin Edit3.Text:=''; exit; end;
  Edit3.Text:=dbProveedores.FieldByName('P1').AsString;
end;
//======================== BUSCAR PRIMER PROVEEDOR =========================
procedure TFFacturaped.Button1Click(Sender: TObject);
begin
  if Edit3.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit3.SetFocus; Exit; end;
  Edit1.Text := FBusquedas.IniciaBusquedas('SELECT P0, P1, P2 FROM proveedores WHERE P1 LIKE "'+Edit3.Text+'%"',
           ['Codigo', ' Razón social ', ' Dirección ' ], 'P0' );
  if Edit1.Text<>'' then begin Edit1Exit(Edit1); end;
end;
procedure TFFacturaped.Edit3KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then Button1Click(Button1);
end;


//====================== PRIMERA FECHA ============================
procedure TFFacturaped.Button3Click(Sender: TObject);
begin
  if Edit7.Text<>'' then CalendarDialog1.Date:=StrToDate(Edit7.Text);
  if CalendarDialog1.Execute then Edit7.Text:=FormatDateTime('DD/MM/YYYY',CalendarDialog1.Date);

end;

//====================== ULTIMA FECHA ============================
procedure TFFacturaped.Button4Click(Sender: TObject);
begin
  if Edit8.Text<>'' then CalendarDialog1.Date:=StrToDate(Edit8.Text);
  if CalendarDialog1.Execute then Edit8.Text:=FormatDateTime('DD/MM/YYYY',CalendarDialog1.Date);
end;


//================== VENCIMIENTOS =======================
procedure TFFacturaped.VerVencimientos();//---------------- Ver si tiene vencimientos
var
  TotalFact: Double;
  Plazos: Integer;
  Dias: TDateTime;
begin
  TotalFact:=dbFactuc.FieldByName('FC9').AsFloat;
  //----------- Plazos de pagos (Vencimientos) --------------------------
  if (TotalFact>dbProveedores.Fields[24].AsFloat) And (dbProveedores.Fields[13].AsInteger>0) then
    begin
      Plazos:=dbProveedores.Fields[15].AsInteger; if Plazos=0 then Plazos:=1;
      Dias:=DateEdit1.Date+dbProveedores.Fields[13].AsInteger;
      FECHAPAGO1:=FormatDateTime('DD/MM/YYYY',Dias);
      IMPOPAGO1:=FormatFloat('0.000',TotalFact/Plazos);
      //------------------- Segundo Plazo
      if Plazos>1 then
        begin
          Dias:=Dias+dbProveedores.Fields[14].AsInteger;
          FECHAPAGO2:=FormatDateTime('DD/MM/YYYY',Dias);
          IMPOPAGO2:=FormatFloat('0.000',TotalFact/Plazos);
        end;
      //------------------- Tercer Plazo
      if Plazos>2 then
        begin
          Dias:=Dias+dbProveedores.Fields[14].AsInteger;
          FECHAPAGO3:=FormatDateTime('DD/MM/YYYY',Dias);
          IMPOPAGO3:=FormatFloat('0.000',TotalFact/Plazos);
        end;
      //------------------- Cuarto Plazo
      if Plazos>3 then
        begin
          Dias:=Dias+dbProveedores.Fields[14].AsInteger;
          FECHAPAGO4:=FormatDateTime('DD/MM/YYYY',Dias);
          IMPOPAGO4:=FormatFloat('0.000',TotalFact/Plazos);
        end;
      ActuFactuVen(); //---------------- Actualizar Vencimientos en factura.
    end;
end;


initialization
  {$I facturaped.lrs}

end.

