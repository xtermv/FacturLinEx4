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

unit facturar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  Buttons, ZConnection, StdCtrls, ZDataset, ExtDlgs, EditBtn, DBGrids, ExtCtrls,
  db, LCLType, ComCtrls, LR_Class, LR_DBSet, dateutils, ZClasses,
  ZAbstractConnection, ZAbstractRODataset, ZExceptions, ZAbstractDataset; //-- Control de errores de la uniad ZEOS

type

  { TFFacturar }

  TFFacturar = class(TForm)
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn23: TBitBtn;
    BitBtn3: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CalendarDialog1: TCalendarDialog;
    CheckBox1: TCheckBox;
    ChkBoxVisualiza: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox4: TComboBox;
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
    Edit2: TEdit;
    Edit21: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
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
    Label2: TLabel;
    Label3: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label4: TLabel;
    dbClientes: TZQuery;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
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
    dbIva: TZQuery;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn23Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: char);
    procedure Edit4KeyPress(Sender: TObject; var Key: char);
    procedure Edit5Enter(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit6KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure NumeroFactura();
    procedure ActuFactuc();
    procedure ActuFactud();
    procedure ActuHisopcc();
    procedure ActuHisopdd();
    procedure Imprimir();
    procedure ActuFactuVen();
    procedure VerVencimientos();
    procedure PasaAlbaHistorico();
    procedure PasaAlbaHistoricoD();//-- Hist. Albaranes
    function VerUltimaLinea: Integer;
    Procedure ActualizaIva();

  private
    { private declarations }
  public
    { public declarations }
  end; 

  procedure ShowFormFacturar();

var
  FFacturar: TFFacturar;
  SFACTURA,SerieABorrar: String;
  NFACTURA: Integer;
  BASE1,BASE2,BASE3,IMPOIVA1,IMPOIVA2,IMPOIVA3,TOTAL1,TOTAL2,TOTAL3: Double;
  IRIVA1,IRIVA2,IRIVA3,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PRIVA1,PRIVA2,PRIVA3:Double;
  Fecha, Hora: TDateTime;
  NLinea, AntCliente: Integer;
  FECHAPAGO1,FECHAPAGO2,FECHAPAGO3,FECHAPAGO4: String;
  IMPOPAGO1,IMPOPAGO2,IMPOPAGO3,IMPOPAGO4: String;

implementation

uses
  Global, Funciones, Busquedas, Imprimir, uFLX_FacturaPDF, uFLX_EmailPDF, uFLX_Log, uVeriFactu, uVeriHash;

{ TFFacturar }

//====================== CREAR FORMULARIO =======================
procedure ShowFormFacturar();
begin
  with TFFacturar.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFFacturar.FormCreate(Sender: TObject);
begin

  //--------- Conectar con la bbdd e inicializar datos globales
  //  Conectate(dbConnect);             // Utilizamos datamodule1.dbConexion para toda la aplicacición.

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
  if dbSeries.RecordCount=0 then begin ShowMessage('NO HAY SERIES DE FACTURACION'); Close(); end;
  if not dbSeries.Locate('SF0',dbTiendas.FieldByName('T11').AsString,[]) then
     begin ShowMessage('NO HAY SERIE DE FACTURACION ACTIVA?'); Close(); end;
  ComboBox4.ItemIndex:=ComboBox4.Items.IndexOf(dbSeries.FieldByName('SF1').AsString);
end;

//====================== CERRAR FORMULARIO =======================
procedure TFFacturar.BitBtn1Click(Sender: TObject);
begin
  Close();
end;
procedure TFFacturar.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//=================================================================
//====================== APLICAR FILTROS ==========================
//=================================================================
procedure TFFacturar.BitBtn2Click(Sender: TObject);
var
  TxtQ: String;
begin
  { TODO 1 -oNicolas -cFacturar : Hay que ver la suma de los albaranes y comprobar el minimo a facturar
  }
  if (Edit1.Text='') or (Edit2.Text='') then exit;
  if ComboBox4.Text='' then exit;
  SerieABorrar:='TODAS LAS SERIES';// Me quedo con la serie para borrar albaranes facturados
  if ComboBox4.Text<>'TODAS LAS SERIES' then
    begin
     if not dbSeries.Locate('SF1',ComboBox4.Text,[]) then
       begin showmessage('La serie activa no existe.'); exit; end;
     SerieABorrar:=dbSeries.FieldByName('SF0').AsString;// Me quedo con la serie para borrar albaranes facturados
    end;
  //------------- Albaranes
  TxtQ:='SELECT *,CONVERT(AC11 USING UTF8) as ANOTAS,C1,C5 FROM albac'+Tienda+',clientes'+             //MID(AC11,1,250) as ANOTAS
        ' WHERE AC0=C0 AND AC0>='+Edit1.Text+' AND AC0<='+Edit2.Text+
        ' AND AC1>="'+FormatDateTime('yyyy-mm-dd',StrToDate(Edit7.Text))+'"'+
        ' AND AC1<="'+FormatDateTime('yyyy-mm-dd',StrToDate(Edit8.Text))+'"';
  if ComboBox4.Text<>'TODAS LAS SERIES' then TxtQ:=TxtQ+' AND AC2="'+dbSeries.FieldByName('SF0').AsString+'"';
  if Edit5.Text<>'' then TxtQ:=TxtQ+' AND C10='+Edit5.Text;
  if RadioButton2.Checked then TxtQ:=TxtQ+' AND AC10="S"';//---- Los marcados
  if RadioButton3.Checked then TxtQ:=TxtQ+' AND AC10="N"';//---- Sin Marcar
  TxtQ:=TxtQ+' ORDER BY AC0,AC1';
  dbAlbacc.Active:=False; dbAlbacc.Sql.Text:=TxtQ; dbAlbacc.Active:=True;
  dbAlbacc.First;
  //------------- Facturas a realizar
  TxtQ:='SELECT AC0,COUNT(AC3),SUM(AC4),SUM(AC4),SUM(AC5),SUM(AC8),SUM(AC9),C1 FROM albac'+Tienda+',clientes'+
        ' WHERE AC0=C0 AND AC0>='+Edit1.Text+' AND AC0<='+Edit2.Text+
        ' AND AC1>="'+FormatDateTime('yyyy-mm-dd',StrToDate(Edit7.Text))+'"'+
        ' AND AC1<="'+FormatDateTime('yyyy-mm-dd',StrToDate(Edit8.Text))+'"';
  if ComboBox4.Text<>'TODAS LAS SERIES' then TxtQ:=TxtQ+' AND AC2="'+dbSeries.FieldByName('SF0').AsString+'"';
  if Edit5.Text<>'' then TxtQ:=TxtQ+' AND C10='+Edit5.Text;
  if RadioButton2.Checked then TxtQ:=TxtQ+' AND AC10="S"';//---- Los marcados
  if RadioButton3.Checked then TxtQ:=TxtQ+' AND AC10="N"';//---- Sin Marcar
  TxtQ:=TxtQ+' GROUP BY AC0 ORDER BY AC0';
  dbMuestraf.Active:=False; dbMuestraf.Sql.Text:=TxtQ; dbMuestraf.Active:=True;
  dbMuestraf.First;
  //------------------- Sumas
  TxtQ:='SELECT SUM(AC4),SUM(AC5),SUM(AC8),SUM(AC9) FROM albac'+Tienda+',clientes'+
        ' WHERE AC0=C0 AND AC0>='+Edit1.Text+' AND AC0<='+Edit2.Text+
        ' AND AC1>="'+FormatDateTime('yyyy-mm-dd',StrToDate(Edit7.Text))+'"'+
        ' AND AC1<="'+FormatDateTime('yyyy-mm-dd',StrToDate(Edit8.Text))+'"';
  if ComboBox4.Text<>'TODAS LAS SERIES' then TxtQ:=TxtQ+' AND AC2="'+dbSeries.FieldByName('SF0').AsString+'"';
  if Edit5.Text<>'' then TxtQ:=TxtQ+' AND C10='+Edit5.Text;
  if RadioButton2.Checked then TxtQ:=TxtQ+' AND AC10="S"';//---- Los marcados
  if RadioButton3.Checked then TxtQ:=TxtQ+' AND AC10="N"';//---- Sin Marcar
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
procedure TFFacturar.BitBtn3Click(Sender: TObject);
var
  TxtQ: String;
begin
  if dbAlbacc.Active=False then exit;
  if dbAlbacc.RecordCount=0 then exit;
  TxtQ:='SE FACTURARAN '+StaticText4.Caption+' ALBARANES, CONTINUAR?';
  if Application.MessageBox(PChar(TxtQ),'FacturLinEx', boxstyle) = IDNO Then Exit;
  //--- Ver la tienda activa para saber que serie usa por defecto
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin Showmessage('NO SE EN QUE TIENDA FACTURAR'); Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" AND SF0 LIKE "%'+copy(FormatDateTime('YYYY',(now)),3,2)+'%" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then
    begin
      CheckBox1.Enabled:=True;
      dbSeries.Active:=False;
      dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
      dbSeries.Active:=True;
    end;
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); exit; end;
  dbSeries.First; ListBox1.Items.Clear;
  Label33.Caption:='N. Factura';  Label34.Caption:='Fecha Factura';
  DateEdit1.Date:=Date;
  while not dbSeries.EOF do
    begin
     ListBox1.Items.Add(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
     dbSeries.Next;
    end;
  dbSeries.Locate('SF0', dbTiendas.Fields[11].AsString, [loCaseInsensitive]);
  ListBox1.ItemIndex:= ListBox1.Items.IndexOf(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
  Edit21.Text:=IntToStr(dbSeries.FieldByName('SF2').AsInteger+1);
  dbTiendas.Active:=False; Panel8.Visible:=True; ListBox1.SetFocus;
  PageControl1.Enabled:=False; BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
end;

//======================== ACEPTAR FACTURAR =====================
procedure TFFacturar.BitBtn23Click(Sender: TObject);
var
  TxtQ: String;
  ok: boolean;
  pdf, Err: string;
begin
  label16.Enabled:=True; ProgressBar1.Enabled:=True; ProgressBar1.Max:=dbAlbacc.RecordCount;
  SFACTURA:=dbSeries.FieldByName('SF0').AsString;
  if SFACTURA='' then begin showmessage('DEBE SELECCIONAR UNA SERIE PARA FACTURAR'); Exit; end;
  vfTipoFactura:='F1';
  Hora:=Time; NumeroFactura(); NLinea:=1;
  dbAlbacc.First; AntCliente:=dbAlbacc.Fields[0].Value;
  While not dbAlbacc.Eof do
   begin
      ProgressBar1.Position:= dbAlbacc.RecNo;
      Application.ProcessMessages;
      //---------- Si el cliente cambia, sacar nuevo n. factura.
      if AntCliente<>dbAlbacc.Fields[0].Value then
        begin
          Imprimir();
          //showmessage(IncludeTrailingPathDelimiter(RutaPdf) + 'QR.png');
          //==================================================
          //-- Inserción de la llamada a generación de PDF
          ok := FLX_GenerateInvoicePDF_FromDB(
                                              tienda,          // tienda
                                              SFACTURA,        // serie
                                              NFACTURA,        // número
                                              Fecha,           // fecha
                                              IntToStr(AntCliente),      // puede ser '' si es simplificada
                                              IncludeTrailingPathDelimiter(RutaIni) + 'QR.png',      // fichero QR (ya lo guardas ahí)
                                              IncludeTrailingPathDelimiter(RutaIni) + 'barcode.png', // ejemplo para barcode, o el que uses
                                              pdf
                                              );
          //-- ShowMessage('El fichero se creará en : ' + RutaPdf);

          if not ok then
            ShowMessage('Error al generar PDF')
          else
              begin
               if dbClientes.FieldByName('C55').AsBoolean then
                begin 
                  //==================================================
                  //=============== Envio Pdf por e-mail =============
                  //==================================================
                  try
                  Ok := FLX_SendFacturaPDFMail(
                                              dbClientes.FieldByName('C40').AsString,
                                              CorreoCopia,
                                              ('Factura Mes Actual / Cliente # '+ dbClientes.FieldByName('C0').AsString),
                                              (' Documento que contendra LOPD y Otros como el cuerpo'),
                                              pdf,
                                              Err
                                              );
                  except
                    on E: Exception do
                    begin
                       FLX_WriteLog('EMAIL', 'Error al conectar al servidor SMTP: ' + E.Message);
                    end;
                  end;
                end;
                  //==================================================
                  //============FIN Envio Pdf por e-mail =============
                  //==================================================
              end;
          //-- Fin Inserción de la llamada a generación de PDF
          //==================================================
          // =================================================
          // === Veri*Factu: Encolar factura (DB/Archivos) ===
          // =================================================
          try
            VeriFactu_QueueFactura(
              SFACTURA,
              NFACTURA,
              DateEdit1.Date,
              Hora,
              // *** IMPORTANTE: TotalConIVA = FC9 (cabecera factura) ***
              dbFactuc.FieldByName('FC9').AsFloat
            );
          except
                on E: Exception do
                 begin
                   Writeln('ERROR CAPTURADO: ' + E.Message);
                 end;
          end;
          // =================================================
          //-- Fin del encolado queue de Veri*Factu
          // =================================================

          AntCliente:=dbAlbacc.Fields[0].Value;
          NumeroFactura();
          Hora:=Time;
          NLinea:=1;
        end;
      TxtQ:='SELECT * FROM albad'+Tienda+' WHERE AD0='+dbAlbacc.Fields[0].AsString+
            ' AND AD1="'+FormatDateTime('yyyy-mm-dd',dbAlbacc.Fields[1].asDateTime)+'"'+
            ' AND AD2="'+dbAlbacc.Fields[2].AsString+'" AND AD3='+dbAlbacc.Fields[3].AsString+
            ' ORDER BY AD4';
      dbAlbadd.Active:=False; dbAlbadd.Sql.Text:=TxtQ;
      dbAlbadd.Active := True; dbAlbadd.First;
      while not dbAlbadd.Eof do
        begin
           ActuFactud();//---------- Detalles
           ActualizaIva(); //------- Actualiza los datos en el fichero de IVAS
           ActuHisopdd();//--------- Hist.Op. Detalles
           PasaAlbaHistoricoD();//-- Hist. Albaranes
           dbAlbadd.Next;
        end;
      ActuFactuc(); //------------- Cabeceras
      ActuHisopcc();//------------- Hist.Op. Cabeceras
      PasaAlbaHistorico();//------- Hist. Albaranes
      //------ Pend. de Facturar
      dbClientes.Active:=False;
      dbClientes.Sql.Text:='UPDATE clientes SET C20=C20-'+dbAlbacc.Fields[9].AsString+' WHERE C0='+dbAlbacc.Fields[0].AsString;
      try
        dbClientes.ExecSql;
      except
        on EDB: EDatabaseError do
        begin
          Showmessage('Error : ' + EDB.Message);
        end;
      end;
      dbClientes.Active:=False;
      dbAlbacc.Next;
   end;
  ProgressBar1.Position:=0;label16.Enabled:=False; ProgressBar1.Enabled:=False;
  Imprimir();

  //==================================================
  //-- ULTIMA VEZ O SI SOLO ES UNO (SE REPITE EN DOS PUNTOS )
  //-- Inserción de la llamada a generación de PDF
  ok := FLX_GenerateInvoicePDF_FromDB(
                                      tienda,          // tienda
                                      SFACTURA,        // serie
                                      NFACTURA,        // número
                                      Fecha,           // fecha
                                      IntToStr(AntCliente),      // puede ser '' si es simplificada
                                      IncludeTrailingPathDelimiter(RutaIni) + 'QR.png',      // fichero QR (ya lo guardas ahí)
                                      IncludeTrailingPathDelimiter(RutaIni) + 'barcode.png', // ejemplo para barcode, o el que uses
                                      pdf
                                      );
  // ShowMessage('El fichero se creará en : ' + RutaPdf);
  // =========================================================
  // === Veri*Factu: Encolar PRIMERA factura (DB/Archivos) ===
  // =========================================================
  try
    VeriFactu_QueueFactura(
                           SFACTURA,
                           NFACTURA,
                           DateEdit1.Date,
                           Hora,
                           // *** IMPORTANTE: TotalConIVA = FC9 (cabecera factura) ***
                           dbFactuc.FieldByName('FC9').AsFloat
                          );
  except
        on E: Exception do
         begin
           Writeln('ERROR CAPTURADO: ' + E.Message);
         end;
  end;
  // =================================================
  //-- Fin del encolado queue de Veri*Factu
  // =================================================

  if not ok then
    ShowMessage('Error al generar PDF')
  else
      begin
           //==================================================
           //=============== Envio Pdf por e-mail =============
           //==================================================
         if dbClientes.FieldByName('C55').AsBoolean then
          begin 
           try
             Ok := FLX_SendFacturaPDFMail(
                                          dbClientes.FieldByName('C40').AsString,
                                          CorreoCopia,
                                          ('Factura Mes Actual / Cliente # '+ dbClientes.FieldByName('C0').AsString),
                                          (' Documento que contendra LOPD y Otros como el cuerpo'),
                                          pdf,
                                          Err
                                          );
           except
             on E: Exception do
               begin
                  FLX_WriteLog('EMAIL', 'Error al conectar al servidor SMTP: ' + E.Message);
               end;
             end;
   {          if Ok then
                 //-- DataModule1.Mensaje('Información', 'Correo enviado correctamente', 2000, clGreen)
             else
                 //-- ShowMessage('Error al enviar correo: ' + Err);
                 FLX_WriteLog('EMAIL', 'Error al conectar al servidor SMTP: ' + ErrorText);
             end;
   }          //==================================================
             //============FIN Envio Pdf por e-mail =============
             //==================================================
          end;
        end;
    //-- Fin Inserción de la llamada a generación de PDF
    //==================================================

  //------------------- Borrar albaranes facturados
  //------------- Detalles
  dbAlbacc.First; AntCliente:=dbAlbacc.Fields[0].Value;
  While not dbAlbacc.Eof do
   begin
      TxtQ:='DELETE FROM albad'+Tienda+' WHERE AD0='+dbAlbacc.Fields[0].AsString+
            ' AND AD1="'+FormatDateTime('yyyy-mm-dd',dbAlbacc.Fields[1].asDateTime)+'"'+
            ' AND AD2="'+dbAlbacc.Fields[2].AsString+'" AND AD3='+dbAlbacc.Fields[3].AsString;
            dbTrabajo.SQL.Text:=TxtQ; 
      try
        dbTrabajo.ExecSQL;
      except
        on EDB: EDatabaseError do
        begin
          Showmessage('Error : ' + EDB.Message);
        end;
      end;
      dbAlbacc.Next;
   end;
  //------------- Cabeceras
  label16.Enabled:=True; ProgressBar1.Enabled:=True; ProgressBar1.Max:=dbAlbacc.RecordCount;
  dbAlbacc.First;
  While not dbAlbacc.Eof do
   begin
      ProgressBar1.Position:= dbAlbacc.RecNo;
      TxtQ:='DELETE FROM albac'+Tienda+' WHERE AC0='+dbAlbacc.Fields[0].AsString+
        ' AND AC1="'+FormatDateTime('yyyy-mm-dd',dbAlbacc.Fields[1].asDateTime)+'"'+
        ' AND AC2="'+dbAlbacc.Fields[2].AsString+'" AND AC3='+dbAlbacc.Fields[3].AsString;
        dbTrabajo.SQL.Text:=TxtQ; 
      try
        dbTrabajo.ExecSQL;
      except
        on EDB: EDatabaseError do
        begin
          Showmessage('Error : ' + EDB.Message);
        end;
      end;
    dbAlbacc.Next;
   end;
   ProgressBar1.Position:=0;label16.Enabled:=False; ProgressBar1.Enabled:=False;

  DataModule1.Mensaje('Información','La facturación ha sido CORRECTA ', 3000 , clGreen);
  
  vfTipoFactura:='F2'; //-- Devolvemos la variable GLOBAL a F2 - Factura Simplificada

  Close();

end;

//======================== MOVERSE POR LAS SERIES ==============================
procedure TFFacturar.ListBox1Click(Sender: TObject);
begin
  if dbSeries.Locate('SF0',trim(copy(ListBox1.Items.Strings[ListBox1.ItemIndex],1,3)),[]) then
     Edit21.Text:=IntToStr(dbSeries.FieldByName('SF2').AsInteger+1);
end;

//======================== CANCELAR FACTURAR =====================
procedure TFFacturar.BitBtn20Click(Sender: TObject);
begin
  Panel8.Visible:=False;
  PageControl1.Enabled:=True; BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
end;


//======================= CABECERA DE FACTURAS ========================
procedure TFFacturar.ActuFactuc();
var
  TxtQ: String;
begin
  dbFactuc.Active:=False;
  TxtQ:='SELECT * FROM factuc'+Tienda+' WHERE FC0='+dbAlbacc.FieldByName('AC0').AsString+
        ' AND FC1="'+FormatDateTime('yyyy-mm-dd',DateEdit1.Date)+
        '" AND FC2="'+SFACTURA+'" AND FC3='+IntToStr(NFACTURA);
  dbFactuc.Sql.Text:=TxtQ; dbFactuc.Active:=True; dbFactuc.First;
  if dbFactuc.Recordcount=0 then
    begin
     dbFactuc.append;
     dbFactuc.FieldByName('FC0').Value:=dbAlbacc.FieldByName('AC0').Value;//----- Cgo. Cliente
     dbFactuc.FieldByName('FC1').AsString:=FormatDateTime('dd/mm/yyyy',DateEdit1.Date);//-- Fecha Factura
     dbFactuc.FieldByName('FC2').Value:=SFACTURA;//------------------------------- Serie Factura.
     dbFactuc.FieldByName('FC3').Value:=NFACTURA;//------------------------------- N. Factura.án
     dbFactuc.FieldByName('FC4').Value:=NLinea-1;//------------------------------- Nº Lineas
     dbFactuc.FieldByName('FC5').Value:=dbAlbacc.FieldByName('AC5').AsFloat;//---- Nº Articulos.
     dbFactuc.FieldByName('FC6').Value:=dbAlbacc.FieldByName('AC6').AsFloat;//---- Dto. Pronto Pago
     dbFactuc.FieldByName('FC7').Value:=dbAlbacc.FieldByName('AC7').AsString;//--- Recargo Equivalencia.
     dbFactuc.FieldByName('FC8').Value:=dbAlbacc.FieldByName('AC8').AsFloat;//---- Importe sin IVA
     dbFactuc.FieldByName('FC9').Value:=dbAlbacc.FieldByName('AC9').AsFloat;//---- Importe con IVA
     dbFactuc.FieldByName('FC10').Value:='N';//----------------------------------- Marcado S/N.
     dbFactuc.FieldByName('FC23').Value:='N';//----------------------------------- Pagado S/N.
     dbFactuc.FieldByName('FC24').Value:=dbAlbacc.FieldByName('C5').AsString;//-------------------- CIF
     if dbAlbacc.FieldByName('AC11').AsString<>null then dbFactuc.FieldByName('FC19').Value:=Memo1.Text+#13+#10+dbAlbacc.FieldByName('AC11').AsString else dbFactuc.FieldByName('FC19').Value:=Memo1.Text;//---------------------------- Observaciones
    end
  else
    begin
     dbFactuc.edit;
     dbFactuc.FieldByName('FC4').Value:=NLinea-1; //----------------------- Nº Lineas
     dbFactuc.FieldByName('FC5').Value:=dbFactuc.FieldByName('FC5').AsFloat+dbAlbacc.FieldByName('AC5').AsFloat;//---- Nº Articulos.
     dbFactuc.FieldByName('FC8').Value:=dbFactuc.FieldByName('FC8').AsFloat + dbAlbacc.FieldByName('AC8').AsFloat;//-- Importe sin IVA
     dbFactuc.FieldByName('FC9').Value:=dbFactuc.FieldByName('FC9').AsFloat + dbAlbacc.FieldByName('AC9').AsFloat;//-- Importe con IVA
    end;
    try
      dbFactuc.Post;
    except
      on EDB: EDatabaseError do
      begin
       Showmessage('Error : ' + EDB.Message);
      end;
    end;
end;

//======================= DETALLES DE FACTURAS ========================
procedure TFFacturar.ActuFactud();
var
  TxtQ: String;
  Conta: Integer;
begin
  dbFactud.Active:=False;
  TxtQ:='SELECT * FROM factud'+Tienda+' WHERE FD0='+dbAlbadd.Fields[0].AsString+
        ' AND FD1="'+FormatDateTime('yyyy-mm-dd',DateEdit1.Date)+'" AND FD2="'+SFACTURA+'"'+
        ' AND FD3='+IntToStr(NFACTURA);
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
           ' - '+LeftStr(dbAlbacc.FieldByName('AC11').AsString, 50);

  dbFactud.Fields[17].Value:=dbAlbadd.Fields[17].Value;//-------------- precio tarifa.
  try
    dbFactud.Post;
  except
    on EDB: EDatabaseError do
    begin
     Showmessage('Error : ' + EDB.Message);
    end;
  end;
  NLinea:=NLinea+1;
end;


//--------------------------------------------------------
//================== GRABAR IVA DE VENTAS ================
//--------------------------------------------------------

Procedure TFFacturar.ActualizaIva();
var
  TxtQ, Departa: String;
  Base, Iva, TIva : String;
begin
  //-- showmessage(TIPOOPER);
  //-- IF TIPOOPER='FA' then showmessage('OJO, UNA FACTURA');
  //-- if TIPOOPER='AL' then exit;
  //------------------- Control de Iva    (Id,Fecha, Hora,TIPOOPER,Puesto,Cliente,Operacion;Serie Factura, Base, iva, tipo de iva, total)

  TIva:=dbFactud.FieldByName('FD12').AsString;
  Base:=FloatToStr(StrToFloat(dbFactud.FieldByName('FD13').AsString)/(1+(StrToFloat(dbFactud.FieldByName('FD12').AsString)/100)));
  Iva:=FloatToStr(StrToFloat(Base)*(StrToFloat(TIva)/100));
  TxtQ:='INSERT INTO iva'+Tienda+' (Fecha,Hora,TipoOP,Puesto,Cliente,Operacion,Serie,Base,Iva,TIva,Total) VALUES ("'+FormatDateTime('yyyy-mm-dd',DateEdit1.Date)+'",'+
        '"'+FormatDateTime('HH:MM:SS',Hora)+'","FM","X","'+dbFactud.FieldByName('FD0').AsString+'",'+IntToStr(NFACTURA)+',"'+SFACTURA+
        '",'+Base+','+Iva+','+dbFactud.FieldByName('FD12').AsString+','+dbFactud.FieldByName('FD13').AsString+')';
{
  case QuestionDlg ('Actualizando Datos de IVA','Si has llegado aquí, se van ha almacenar los datos del iva',mtCustom,[mrYes,'Si', mrNo, 'No', mrCancel,'Cancelar'],'La ayuda') of
        mrYes: showmessage(TxtQ);
        mrNo:  QuestionDlg ('Se van ha almacenar igual los datos de IVA',TxtQ,mtCustom,[mrOK,'Exacto'],'');
        mrCancel: exit;
  end;
}
  //-- showmessage(TxtQ);
  dbIva.SQL.Text:=TxtQ;
  try
    dbIva.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado al insertar IVA : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
end;


//=================== SACAR EL ULT N. DE LINEA =====================
function TFFacturar.VerUltimaLinea: Integer;
begin
  VerUltimaLinea:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(FD4) As ULTIMA FROM factud'+Tienda+' WHERE FD0='+dbAlbadd.Fields[0].AsString+
                    ' AND FD1="'+FormatDateTime('yyyy-mm-dd',DateEdit1.Date)+'" AND FD2="'+SFACTURA+'"'+
                    ' AND FD3='+IntToStr(NFACTURA);
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLinea:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;

//===================== Facturas Cab Vencimientos =======================
procedure TFFacturar.ActuFactuVen();
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
  try
    dbFactuc.Post;
  except
    on EDB: EDatabaseError do
    begin
     Showmessage('Error : ' + EDB.Message);
    end;
  end;
end;


//======================= Hist. Operaciones Cab =====================
procedure TFFacturar.ActuHisopcc();
var
  TxtQ: String;
begin

{ TODO: Falta asignar el numero de usuario que cierra la operacion }

  dbHisopcc.Active:=False;
  TxtQ:='SELECT * FROM hisopcc'+Tienda+' WHERE HO0="'+FormatDateTime('yyyy-mm-dd',DateEdit1.Date)+'"'+
        ' AND HO1="'+FormatDateTime('HH:MM:SS',Hora)+'" AND HO2="'+Puesto+'"'+
        ' AND HO3='+IntToStr(NFACTURA)+' AND HO4="'+SFACTURA+'" AND HO5="FA"';
  dbHisopcc.Sql.Text:=TxtQ; dbHisopcc.Active := True; dbHisopcc.First;
  if dbHisopcc.Recordcount=0 then
   begin
    dbHisopcc.append;
    dbHisopcc.FieldByName('HO0').AsString:=FormatDateTime('DD/MM/YYYY',DateEdit1.Date);//-- Fecha
    dbHisopcc.FieldByName('HO1').AsString:=FormatDateTime('HH:MM:SS',Hora);//-- Hora
    dbHisopcc.FieldByName('HO2').Value:=Puesto;//--- Puesto
    dbHisopcc.FieldByName('HO3').Value:=NFACTURA;//- N.Factura
    dbHisopcc.FieldByName('HO4').Value:=SFACTURA;//- Serie Factura
    dbHisopcc.FieldByName('HO5').Value:='FA';//----- Tipo opeacion
    dbHisopcc.FieldByName('HO6').Value:='FACTURADO';//------- Tipo de pago.
    dbHisopcc.FieldByName('HO7').Value:=1;//----------------- Usuario
    dbHisopcc.FieldByName('HO8').Value:=dbAlbacc.FieldByName('AC0').Value;//----- Cgo. Cliente
    dbHisopcc.FieldByName('HO9').Value:=dbAlbacc.FieldByName('AC9').AsFloat;//--- Importe total
    dbHisopcc.FieldByName('HO10').Value:=0;//-- % Dto.
    dbHisopcc.FieldByName('HO11').Value:=dbAlbacc.FieldByName('AC9').AsFloat;//-- Importe total con Dto.
    dbHisopcc.FieldByName('HO12').Value:=dbAlbacc.FieldByName('AC9').AsFloat;//-- Entrega
    dbHisopcc.FieldByName('HO13').Value:=0;//-- Cambio
    dbHisopcc.FieldByName('HO14').Value:=0;//-- Entrega Tarjeta
    dbHisopcc.FieldByName('HO15').Value:='N';//-- Marcada S/N
    dbHisopcc.FieldByName('HO19').Value:=dbAlbacc.FieldByName('C5').AsString;//------------ CIF
   end
  else
   begin
    dbHisopcc.Edit;
    dbHisopcc.FieldByName('HO9').Value:=dbHisopcc.FieldByName('HO9').AsFloat+dbAlbacc.FieldByName('AC9').AsFloat;//--- Importe total
    dbHisopcc.FieldByName('HO11').Value:=dbHisopcc.FieldByName('HO11').AsFloat+dbAlbacc.FieldByName('AC9').AsFloat;//-- Importe total con Dto.
    dbHisopcc.FieldByName('HO12').Value:=dbHisopcc.FieldByName('HO12').AsFloat+dbAlbacc.FieldByName('AC9').AsFloat;//-- Entrega
    end;
   try
     dbHisopcc.Post;
   except
     on EDB: EDatabaseError do
     begin
      Showmessage('Error : ' + EDB.Message);
     end;
   end;
  dbHisopcc.Active:=False;
end;

//======================= Hist. Operaciones Det =====================
procedure TFFacturar.ActuHisopdd();
var
  TxtQ: String;
begin
  //------------------- Historico de operaciones detalles
  TxtQ:='INSERT INTO hisopdd'+Tienda+' (HOD0,HOD1,HOD2,HOD3,HOD4,HOD5,HOD6,HOD7,HOD8,HOD9,HOD10,HOD11'+
        ',HOD12,HOD13,HOD14,HOD15,HOD16, HOD22) VALUES ("'+FormatDateTime('yyyy-mm-dd',DateEdit1.Date)+'",'+
        '"'+FormatDateTime('HH:MM:SS',Hora)+'","'+Puesto+'",'+IntToStr(NFACTURA)+',"'+SFACTURA+
        '",'+IntToStr(NLinea)+',"'+
        dbAlbadd.FieldByName('AD5').AsString+'","'+dbAlbadd.FieldByName('AD6').AsString+'",'+
        dbAlbadd.FieldByName('AD7').AsString+','+dbAlbadd.FieldByName('AD8').AsString+','+
        dbAlbadd.FieldByName('AD9').AsString+','+dbAlbadd.FieldByName('AD10').AsString+','+
        dbAlbadd.FieldByName('AD11').AsString+','+dbAlbadd.FieldByName('AD12').AsString+','+
        dbAlbadd.FieldByName('AD13').AsString+',"","'+dbAlbadd.FieldByName('AD15').AsString+'",'+
        dbAlbadd.FieldByName('AD17').AsString+')';
  //--   showmessage(TxtQ);
  dbHisopdd.SQL.Text:=TxtQ;
    try
    dbHisopdd.ExecSQL;
  except
    // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado al insertar Hisopdd : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
end;

//----------------------- Pasar los albaranes al Histórico Cab ----------------
procedure TFFacturar.PasaAlbaHistorico();
var
  TxtQ: String;
begin
{  TxtQ:='INSERT INTO hisalbac'+Tienda+' SELECT *,'+dbAlbacc.FieldByName('AC0').AsString+
        ',"'+FormatDateTime('yyyy-mm-dd',dbAlbacc.FieldByName('AC1').AsDateTime)+
        '","'+SFACTURA+'",'+IntToStr(NFACTURA)+
        ' FROM albac'+Tienda+' WHERE AC0='+dbAlbacc.FieldByName('AC0').AsString+
        ' AND AC1="'+FormatDateTime('yyyy-mm-dd',dbAlbacc.FieldByName('AC1').AsDateTime)+'"'+
        ' AND AC2="'+dbAlbacc.FieldByName('AC2').AsString+'"'+
        ' AND AC3='+dbAlbacc.FieldByName('AC3').AsString;}

  TxtQ:='INSERT INTO hisalbac'+Tienda+' SELECT ' +
        dbAlbacc.FieldByName('AC0').AsString +',"'+
        FormatDateTime('yyyy-mm-dd',dbAlbacc.FieldByName('AC1').AsDateTime)+ '","'+
        dbAlbacc.FieldByName('AC2').AsString + '",'+
        dbAlbacc.FieldByName('AC3').AsString + ','+
        dbAlbacc.FieldByName('AC4').AsString + ','+
        dbAlbacc.FieldByName('AC5').AsString + ','+
        dbAlbacc.FieldByName('AC6').AsString + ',"'+
        dbAlbacc.FieldByName('AC7').AsString + '",'+
        dbAlbacc.FieldByName('AC8').AsString + ','+
        dbAlbacc.FieldByName('AC9').AsString + ',"'+
        dbAlbacc.FieldByName('AC10').AsString+ '","'+
        dbAlbacc.FieldByName('AC11').AsString+
        '",'+dbAlbacc.FieldByName('AC0').AsString+
        ',"'+FormatDateTime('yyyy-mm-dd',dbAlbacc.FieldByName('AC1').AsDateTime)+
        '","'+SFACTURA+'",'+IntToStr(NFACTURA)+ ',"'+ dbAlbacc.FieldByName('AC12').AsString+ '" '+
        ' FROM albac'+Tienda+' WHERE AC0='+dbAlbacc.FieldByName('AC0').AsString+
        ' AND AC1="'+FormatDateTime('yyyy-mm-dd',dbAlbacc.FieldByName('AC1').AsDateTime)+'"'+
        ' AND AC2="'+dbAlbacc.FieldByName('AC2').AsString+'"'+
        ' AND AC3='+dbAlbacc.FieldByName('AC3').AsString;
  //--  showmessage(TxtQ);
  dbTrabajo.SQL.Text:=TxtQ;
  try
    dbTrabajo.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado al insertar Hisalbac : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
end;

//------------------- Pasar los albaranes al historico Det ---------------------
procedure TFFacturar.PasaAlbaHistoricoD();
var
  TxtQ: String;
begin
  TxtQ:='INSERT INTO hisalbad'+Tienda+' SELECT * FROM albad'+Tienda+
        ' WHERE AD0='+dbAlbadd.FieldByName('AD0').AsString+
        ' AND AD1="'+FormatDateTime('yyyy-mm-dd',dbAlbadd.FieldByName('AD1').AsDateTime)+'"'+
        ' AND AD2="'+dbAlbadd.FieldByName('AD2').AsString+'"'+
        ' AND AD3='+dbAlbadd.FieldByName('AD3').AsString+
        ' AND AD4='+dbAlbadd.FieldByName('AD4').AsString;
    //--  showmessage(TxtQ);
  dbTrabajo.SQL.Text:=TxtQ;
  try
    dbTrabajo.ExecSQL;
  except
    // Capturamos el error específico de la capa de datos
     on EDB: EZSQLException do
     begin
       // El mensaje de EDB contendrá el mensaje de error de MariaDB
       ShowMessage('Error de Base de Datos Inesperado al insertar Hisalbad : ' + EDB.Message);
       // La aplicación sigue desde aquí.
     end;
  end;
end;

//====================== PRIMER CLIENTE =======================
procedure TFFacturar.Edit1Enter(Sender: TObject);
begin
  Edit3.Text:='';
end;
procedure TFFacturar.Edit1Exit(Sender: TObject);
begin
  if Edit1.Text='' then Edit1.Text:='1';
  dbClientes.Active:=False;
  dbClientes.SQL.Text:='SELECT C0,C1,C5 FROM clientes where C0='+Edit1.Text;
  dbClientes.Active:=True;
  if dbClientes.RecordCount=0 then begin Edit3.Text:=''; exit; end;
  Edit3.Text:=dbClientes.FieldByName('C1').AsString;
end;
//======================== BUSCAR PRIMER CLIENTE =========================
procedure TFFacturar.Button1Click(Sender: TObject);
begin
  if Edit3.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit3.SetFocus; Exit; end;
  Edit1.Text := FBusquedas.IniciaBusquedas('SELECT C0, C1, C2 FROM clientes WHERE C1 LIKE "'+Edit3.Text+'%"',
           ['Codigo', ' Razón social ', ' Dirección ' ], 'C0' );
  if Edit1.Text<>'' then begin Edit1Exit(Edit1); end;
end;
procedure TFFacturar.Edit3KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then Button1Click(Button1);
end;

//====================== ULTIMO CLIENTE =======================
procedure TFFacturar.Edit2Enter(Sender: TObject);
begin
  Edit4.Text:='';
end;
procedure TFFacturar.Edit2Exit(Sender: TObject);
begin
  if Edit2.Text='' then Edit2.Text:='999998';
  dbClientes.Active:=False;
  dbClientes.SQL.Text:='SELECT C0,C1,C5 FROM clientes where C0='+Edit2.Text;
  dbClientes.Active:=True;
  if dbClientes.RecordCount=0 then begin Edit4.Text:=''; exit; end;
  Edit4.Text:=dbClientes.FieldByName('C1').AsString;
end;
//======================== BUSCAR ULTIMO CLIENTE =========================
procedure TFFacturar.Button2Click(Sender: TObject);
begin
  if Edit4.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit4.SetFocus; Exit; end;
  Edit2.Text := FBusquedas.IniciaBusquedas('SELECT C0, C1, C2 FROM clientes WHERE C1 LIKE "'+Edit4.Text+'%"',
           ['Codigo', ' Razón social ', ' Dirección ' ], 'C0' );
  if Edit2.Text<>'' then begin Edit2Exit(Edit2); end;
end;
procedure TFFacturar.Edit4KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then Button2Click(Button2);
end;

//========================= RUTA A FACTURAR ==================
procedure TFFacturar.Edit5Enter(Sender: TObject);
begin
  Edit6.Text:='';
end;
procedure TFFacturar.Edit5Exit(Sender: TObject);
begin
  if Edit5.Text='' then exit;
  dbRutas.Active:=False;
  dbRutas.SQL.Text:='SELECT RUT0,RUT1 FROM rutas'+Tienda+' where RUT0='+Edit5.Text;
  dbRutas.Active:=True;
  if dbRutas.RecordCount=0 then begin Edit6.Text:=''; exit; end;
  Edit6.Text:=dbRutas.FieldByName('RUT1').AsString;
end;
//====================== BUSCAR RUTAS =============================
 procedure TFFacturar.Button5Click(Sender: TObject);
begin
  if Edit6.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit6.SetFocus; Exit; end;
  Edit5.Text := FBusquedas.IniciaBusquedas('SELECT RUT0, RUT1 FROM rutas'+Tienda+' WHERE RUT1 LIKE "'+Edit6.Text+'%"',
           ['Codigo', ' Descripcion ' ], 'RUT0' );
  if Edit5.Text<>'' then begin Edit5Exit(Edit5); end;
end;

procedure TFFacturar.CheckBox1Click(Sender: TObject);
begin
  dbTiendas.Active:=True; Panel8.Visible:=False;
  PageControl1.Enabled:=True; BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
  if CheckBox1.Checked then
    begin
      dbSeries.Active:=False;
      dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
      dbSeries.Active:=True;
    end
  else
    begin
      dbSeries.Active:=False;
      dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E"  AND SF0 LIKE "%'+copy(FormatDateTime('YYYY',(now)),3,2)+'%" ORDER BY SF0';
      dbSeries.Active:=True;
    end;
   if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); exit; end;
   dbSeries.First; ListBox1.Items.Clear;
    Label33.Caption:='N. Factura';  Label34.Caption:='Fecha Factura';
    DateEdit1.Date:=Date;
    while not dbSeries.EOF do
      begin
       ListBox1.Items.Add(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                          dbSeries.FieldByName('SF1').AsString);
       dbSeries.Next;
      end;
    dbSeries.Locate('SF0', dbTiendas.Fields[11].AsString, [loCaseInsensitive]);
    ListBox1.ItemIndex:= ListBox1.Items.IndexOf(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                          dbSeries.FieldByName('SF1').AsString);
    Edit21.Text:=IntToStr(dbSeries.FieldByName('SF2').AsInteger+1);
    dbTiendas.Active:=False; Panel8.Visible:=True; ListBox1.SetFocus;
    PageControl1.Enabled:=False; BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
end;

procedure TFFacturar.Edit6KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then Button5Click(Button5);
end;


//====================== PRIMERA FECHA ============================
procedure TFFacturar.Button3Click(Sender: TObject);
begin
  if Edit7.Text<>'' then CalendarDialog1.Date:=StrToDate(Edit7.Text);
  if CalendarDialog1.Execute then Edit7.Text:=FormatDateTime('DD/MM/YYYY',CalendarDialog1.Date);

end;

//====================== ULTIMA FECHA ============================
procedure TFFacturar.Button4Click(Sender: TObject);
begin
  if Edit8.Text<>'' then CalendarDialog1.Date:=StrToDate(Edit8.Text);
  if CalendarDialog1.Execute then Edit8.Text:=FormatDateTime('DD/MM/YYYY',CalendarDialog1.Date);
end;

//================= N. DE FACTURA ===========================
procedure TFFacturar.NumeroFactura();
begin
  if SFACTURA='' then begin SFACTURA:='';NFACTURA:=0; Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF2=SF2+1 WHERE SF0="'+SFACTURA+'"';
  try
    dbSeries.ExecSQL;
  except
    on EDB: EDatabaseError do
    begin
      Showmessage('Error : ' + EDB.Message);
    end;
  end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+SFACTURA+'"';
  dbSeries.Active:=True;
  if dbSeries.Recordcount=0 then exit;
  NFACTURA:=dbSeries.Fields[2].AsInteger;
  dbSeries.Active:=False;
end;

//==============================================================
//==================== IMPRIMIR FACTURA ========================
//==============================================================
procedure TFFacturar.Imprimir();
var
  EstadoImpresion: integer;
  TxtQ: String;
  Directo: boolean;

begin

  dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+IntToStr(AntCliente);
  dbClientes.Active:=True;
  VerVencimientos();//---------------- Ver si tiene vencimientos

  //TODO: Falta el pie de las facturas
{
  //----------- Pie de factura --------------------------
  //-------- Forma de pago
  if dbCliFac.Fields[9].AsInteger<>0 then
    begin
      dbFormaPago.Active:=False;
      dbFormaPago.SQL.Text:='SELECT * FROM formapago WHERE FPA0='+dbCliFac.Fields[9].AsString;
      dbFormaPago.Active:=True;
      if dbFormaPago.RecordCount=0 then TextoPie:='' else TextoPie:=dbFormaPago.Fields[1].AsString;
    end;
  //-------- Pago por banco/Caja
  if dbCliFac.Fields[42].AsInteger<>0 then
    begin
      TextoPie:=TextoPie+' '+dbCliFac.Fields[30].AsString+'  CC.:'+dbCliFac.Fields[31].AsString;
    end;
  CLXReport1.Report.Params.ParamByName('PIE').Value:=TextoPie;
  //----------- Traspaso a contabilidad ---------------------------------
}

  //--- COMPROBADO QUE DIRECTO TOMA EL VALOR QUE CORRESPONDE, POR DEFECTO EN FACTURAR TRUE
  Directo:= ChkBoxVisualiza.Checked;

  EstadoImpresion:= FImpresion.Imprime(dbFactud, dbFactuc, dbClientes, 'FACTURA', Directo, 1);

  if (EstadoImpresion=1) then             // La factura fue impresa.
     begin
        TxtQ:='UPDATE factuc'+Tienda+' SET FC25="S" WHERE FC0='+dbFactuc.FieldByName('FC0').AsString+
             ' AND FC1="'+FormatDateTime('yyyy-mm-dd',dbFactuc.FieldByName('FC1').AsDateTime)+'"'+
             ' AND FC2="'+dbFactuc.FieldByName('FC2').AsString+'" AND FC3='+dbFactuc.FieldByName('FC3').AsString;

         dbTrabajo.SQL.Text:=TxtQ; 
         try
           dbTrabajo.ExecSQL;
         except
           on EDB: EDatabaseError do
           begin
             Showmessage('Error : ' + EDB.Message);
           end;
         end;
     end;

   if (EstadoImpresion=2) then            // La factura fue enviada por email.
     begin
        TxtQ:='UPDATE factuc'+Tienda+' SET FC26="S" WHERE FC0='+dbFactuc.FieldByName('FC0').AsString+
             ' AND FC1="'+FormatDateTime('yyyy-mm-dd',dbFactuc.FieldByName('FC1').AsDateTime)+'"'+
             ' AND FC2="'+dbFactuc.FieldByName('FC2').AsString+'" AND FC3='+dbFactuc.FieldByName('FC3').AsString;

         dbTrabajo.SQL.Text:=TxtQ; 
         try
           dbTrabajo.ExecSQL;
         except
           on EDB: EDatabaseError do
           begin
             Showmessage('Error : ' + EDB.Message);
           end;
         end;
     end;

   if (EstadoImpresion=3) then            // La factura fue impresa y enviada.
      begin
         TxtQ:='UPDATE factuc'+Tienda+' SET FC25="S", FC26="S" WHERE FC0='+dbFactuc.FieldByName('FC0').AsString+
              ' AND FC1="'+FormatDateTime('yyyy-mm-dd',dbFactuc.FieldByName('FC1').AsDateTime)+'"'+
              ' AND FC2="'+dbFactuc.FieldByName('FC2').AsString+'" AND FC3='+dbFactuc.FieldByName('FC3').AsString;

        dbTrabajo.SQL.Text:=TxtQ; 
        try
          dbTrabajo.ExecSQL;
        except
          on EDB: EDatabaseError do
          begin
            Showmessage('Error : ' + EDB.Message);
          end;
        end;
      end;
end;

//================== VENCIMIENTOS =======================
procedure TFFacturar.VerVencimientos();//---------------- Ver si tiene vencimientos
var
  TotalFact: Double;
  Plazos: Integer;
  Dias: TDateTime;
begin
  TotalFact:=dbFactuc.FieldByName('FC9').AsFloat;
  //----------- Plazos de pagos (Vencimientos) --------------------------
  if (TotalFact>dbClientes.Fields[24].AsFloat) And (dbClientes.Fields[13].AsInteger>0) then
    begin
      Plazos:=dbClientes.Fields[15].AsInteger; if Plazos=0 then Plazos:=1;
      Dias:=DateEdit1.Date+dbClientes.Fields[13].AsInteger;
      FECHAPAGO1:=FormatDateTime('DD/MM/YYYY',Dias);
      IMPOPAGO1:=FormatFloat('0.000',TotalFact/Plazos);
      //------------------- Segundo Plazo
      if Plazos>1 then
        begin
          Dias:=Dias+dbClientes.Fields[14].AsInteger;
          FECHAPAGO2:=FormatDateTime('DD/MM/YYYY',Dias);
          IMPOPAGO2:=FormatFloat('0.000',TotalFact/Plazos);
        end;
      //------------------- Tercer Plazo
      if Plazos>2 then
        begin
          Dias:=Dias+dbCliEntes.Fields[14].AsInteger;
          FECHAPAGO3:=FormatDateTime('DD/MM/YYYY',Dias);
          IMPOPAGO3:=FormatFloat('0.000',TotalFact/Plazos);
        end;
      //------------------- Cuarto Plazo
      if Plazos>3 then
        begin
          Dias:=Dias+dbClientes.Fields[14].AsInteger;
          FECHAPAGO4:=FormatDateTime('DD/MM/YYYY',Dias);
          IMPOPAGO4:=FormatFloat('0.000',TotalFact/Plazos);
        end;
      ActuFactuVen(); //---------------- Actualizar Vencimientos en factura.
    end;
end;


initialization
  {$I facturar.lrs}

end.
