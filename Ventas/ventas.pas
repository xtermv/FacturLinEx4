{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2011
  Nicolas Lopez de Lerma Aymerich <nicolas@puntodev.com>

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

unit Ventas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  ZConnection, ExtCtrls, StdCtrls, DBGrids, Buttons, ZDataset, db,
  LCLType, Grids, LR_Class, LR_DBSet, EditBtn, ComCtrls, LCLIntf,
  ubarcodes, ZClasses, ZAbstractConnection, ZAbstractRODataset, 
  ZExceptions, ZAbstractDataset; //-- Control de errores de la uniad ZEOS; //-- Esta última libería controla el GetKeyState para saber si pulsé el ctrl

type

  { TFVentas }

  TFVentas = class(TForm)
    BarcodeQR1: TBarcodeQR;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
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
    btHistoricos: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    btCodigo: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    cbHistoricos: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ChBoxRegalo: TCheckBox;
    cbImprimir: TCheckBox;
    cbImpresionDirecta: TCheckBox;
    cbCorreoElectronico: TCheckBox;
    Combo1: TComboBox;
    Combo2: TComboBox;
    Combo4: TComboBox;
    Combo5: TComboBox;
    Combo6: TComboBox;
    cbUsuario: TComboBox;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    Datasource3: TDatasource;
    Datasource4: TDatasource;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    dbArti: TZQuery;
    dbUsu: TZQuery;
    dbImprimir: TZQuery;
    dbCajas: TZQuery;
    dbBusca: TZQuery;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    dbHiPedid: TZQuery;
    dbPedi: TZQuery;
    DBGrid2: TDBGrid;
    dbHiPedic: TZQuery;
    dbPedid: TZQuery;
    dbTickets: TZQuery;
    dbMuestrad: TZQuery;
    dbTiendas: TZQuery;
    dbSeries: TZQuery;
    dbTrabajo: TZQuery;
    dbVentas: TZQuery;
    DBGrid1: TDBGrid;
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
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    Edit37: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Edit4: TEdit;
    Edit40: TEdit;
    Edit41: TEdit;
    Edit42: TEdit;
    edNumeroCopias: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frDBDataSet2: TfrDBDataSet;
    frReport1: TfrReport;
    frReport2: TfrReport;
    frReport3: TfrReport;
    Image1: TImage;
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
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label8: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    lbNumeroCopias: TLabel;
    lbUsuario: TLabel;
    Label9: TLabel;
    lbHistorico: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Memo1: TMemo;
    Memo2: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    botones: TPanel;
    botolineas: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    PanelBuscaArticulos: TPanel;
    PanelAvisoVario: TPanel;
    PanelAvisoClienteVario: TPanel;
    PanelCredito: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    PanelNotas: TPanel;
    PanelCodigoVario: TPanel;
    PanelNuevoCli: TPanel;
    pnUsuario1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton9: TRadioButton;
    StaticText1: TStaticText;
    dbClientes: TZQuery;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    dbPuntos: TZQuery;
    Timer1: TTimer;
    dbIva: TZQuery;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn10Enter(Sender: TObject);
    procedure BitBtn10Exit(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn11Enter(Sender: TObject);
    procedure BitBtn11Exit(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn12Enter(Sender: TObject);
    procedure BitBtn12Exit(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn13Enter(Sender: TObject);
    procedure BitBtn13Exit(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject; lDirecto: boolean);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn17Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn19Click(Sender: TObject);
    procedure BitBtn19Enter(Sender: TObject);
    procedure BitBtn19Exit(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure BitBtn22Click(Sender: TObject);
    procedure BitBtn23Click(Sender: TObject);
    procedure BitBtn23Enter(Sender: TObject);
    procedure BitBtn23Exit(Sender: TObject);
    procedure BitBtn24Click(Sender: TObject);
    procedure BitBtn25Click(Sender: TObject);
    procedure BitBtn26Click(Sender: TObject);
    procedure BitBtn27Click(Sender: TObject);
    procedure BitBtn28Click(Sender: TObject);
    procedure BitBtn29Click(Sender: TObject);
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
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn9Enter(Sender: TObject);
    procedure BitBtn9Exit(Sender: TObject);
    procedure btCodigoClick(Sender: TObject);
    procedure btHistoricosClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cbUsuarioChange(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure Combo1Click(Sender: TObject);
    procedure Combo1KeyPress(Sender: TObject; var Key: char);
    procedure Combo2Change(Sender: TObject);
    procedure Combo4Click(Sender: TObject);
    procedure Combo4KeyPress(Sender: TObject; var Key: char);
    procedure Combo5Change(Sender: TObject);
    procedure Combo6Change(Sender: TObject);
    procedure Datasource1DataChange(Sender: TObject; Field: TField);
    procedure Datasource2DataChange(Sender: TObject; Field: TField);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure DBGrid5DblClick(Sender: TObject);
    procedure Edit10Exit(Sender: TObject);
    procedure Edit11Exit(Sender: TObject);
    procedure Edit11KeyPress(Sender: TObject; var Key: char);
    procedure Edit12Exit(Sender: TObject);
    procedure Edit13Exit(Sender: TObject);
    procedure Edit14Exit(Sender: TObject);
    procedure Edit15Exit(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1MouseEnter(Sender: TObject);
    procedure Edit1MouseLeave(Sender: TObject);
    procedure Edit24Enter(Sender: TObject);
    procedure Edit24Exit(Sender: TObject);
    procedure Edit27Exit(Sender: TObject);
    procedure Edit28KeyPress(Sender: TObject; var Key: char);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit3Enter(Sender: TObject);
    procedure Edit3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit3KeyPress(Sender: TObject; var Key: char);
    procedure Edit41Exit(Sender: TObject);
    procedure Edit41KeyPress(Sender: TObject; var Key: char);
    procedure Edit42Exit(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: char);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit5KeyPress(Sender: TObject; var Key: char);
    procedure Edit6Exit(Sender: TObject);
    procedure Edit6KeyPress(Sender: TObject; var Key: char);
    procedure Edit7DblClick(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
    procedure Edit8Exit(Sender: TObject);
    procedure Edit8KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frReport2GetValue(const ParName: String; var ParValue: Variant);
    procedure frReport3GetValue(const ParName: String; var ParValue: Variant);
    procedure LimpiaEntrada();
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure ListBox2KeyPress(Sender: TObject; var Key: char);
    procedure ListBox3DblClick(Sender: TObject);
    procedure ListBox3KeyPress(Sender: TObject; var Key: char);
    procedure PintaEntrada();
    procedure GrabaEntrada();
    procedure RadioButton10Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton9Click(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure Timer1StopTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure VerImporteEntra();
    procedure VerDtoEntra();
    procedure VerTotalEntra();
    procedure PintarTotalGeneral();
    procedure Bloquear();
    procedure Desbloquear();
    function LeerArticulo: Boolean;
    function LeerAuxiliar: Boolean;
    procedure ActualizaDatos();
    procedure ActualizaHisto();
    procedure VerSerieFacturacion();
    procedure NumeroTicket();
    procedure NumeroFactura();
    procedure NumeroAlbaran();
    procedure NumeroPedido();
    procedure NumeroPresupuesto();
    procedure NumeroProforma();
    procedure CargarTotales();
    procedure VerRecargo();
    procedure RefrescaTicketsAbiertos();
    procedure CambiarTicket();
    procedure Cajon();
    procedure Corte();
    procedure CabeceraTicket();
    procedure PieTicket();
    procedure ImpreTicket(regalo: boolean);
    procedure TotalTicket(n1,n2,n3,ti1,ti2,ti3,i1,i2,i3: Double);
    procedure RellenaPedicc();
    procedure RellenaPedidd();
    procedure RellenaPreProcc();
    procedure RellenaPreProdd();
    procedure ImprimirPresupuesto();
    function VerSiApuntarCredito: Boolean;
    procedure ApuntaCredito();
    procedure VerSiTieneCredito();
    procedure CajaTarjetas();
    procedure CajaPuntos();
    procedure Actualizapedido();
    Procedure Actualizaprepro();
    function VerUltimaLineaA: Integer;
    function VerUltimaLineaF: Integer;
    function VerUltimaLineaP: Integer;
    function VerUltimaLineaPP: Integer;
    function VerUltimaLineaV: Integer;
    procedure VerTarifas();
    procedure ButtonUsuClick(Sender: TObject);
    procedure CargaUsuarios();
    procedure MuestraTarifas();
    procedure CargaValoresTotalizar();
    function HayStock: boolean;
    function ClienteDuplicado(): string;
    function VerUltimoCliente: string;
    Procedure ActualizaIva();
    Procedure ImprimeQRTicket();

    Procedure KeyLogB();

  private
    { private declarations }
  public
    { public declarations }
  end;

  const

    ImpresoraTicket = '/dev/usb/lp0';
    GS = #29;
    ESC = #27;

  procedure ShowFormVentas;

var
  FVentas: TFVentas;
  FechaVenta,HoraVenta: TDateTime;
  Llenando, modificando: Integer;
  SERIEFACT,TICKET,TIPOOPER,DESCRIOPER: String;
  NOPERACION: Integer;
  PrintText: TextFile;
  BASE1,BASE2,BASE3,IMPOIVA1,IMPOIVA2,IMPOIVA3,TOTAL1,TOTAL2,TOTAL3: Double;
  IRIVA1,IRIVA2,IRIVA3,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PRIVA1,PRIVA2,PRIVA3:Double;
  OperacionRecuperada,ClaveRecuperada: String;
  TablaPreProc, TablaPreProd: String;
  Impreso: array [1..2] of string;
  TPuntos, CalPuntos, Tempocaso: String;
  TituloGrid: String;
  Segundos: Integer;     // Contador para el temporizador de los avisos.
  BuscaEan: Boolean;
  Dispensador: String;
  btnUsuarioActivo: TBitBtn;
  txtQR, DirectorioQR: String;
  NombrePDF: String;

  //-- Nueva Función para Identificar la serie activa
  function VF_GetSerieActiva: string;
  //-------------------------------------------------

implementation
// === [Paso 1] Utilidades de registro y manejo de errores (no intrusivas) ===
uses
  Global, Funciones, creditos, Busquedas, Imprimir, uVeriFactu, uVeriHash, uFLX_Log, uFLX_Sound;

{ TFVentas }


// --- Medición simple de tiempos (para detectar cuellos de botella al totalizar) ---
// No altera la lógica: solo escribe marcas en el log si uFLX_Log está disponible.
function VF_TickMS: QWord; inline;
begin
  Result := GetTickCount64;
end;

procedure VF_LogPerf(const Step: string; const T0: QWord);
begin
  try
    FLX_WriteLog('VENTAS', Step + ' | ' + IntToStr(VF_TickMS - T0) + ' ms');
  except
    // No bloquear la venta si falla el log
  end;
end;

procedure VF_LogInfo(const Msg: string);
begin
  try
    FLX_WriteLog('VENTAS', Msg);
  except
  end;
end;

procedure LogErrorToFile(const AMsg: string);
var
  F: TextFile;
  FN: string;
begin
  try
    FN := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'ventas_error.log';
    AssignFile(F, FN);
    if FileExists(FN) then Append(F) else Rewrite(F);
    Writeln(F, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' | ' + AMsg);
    CloseFile(F);
  except
    // no levantar excepciones en logging
  end;
end;

procedure HandleDBError(const E: Exception; const AContext: string);
begin
  LogErrorToFile('[DBERROR] ' + AContext + ' | ' + E.ClassName + ': ' + E.Message);
  try
    Application.MessageBox(PChar('Se ha producido un error en base de datos.'#10#13 +
      'Contexto: ' + AContext + #10#13 +
      'Detalle: ' + E.Message),
      'Error', MB_ICONERROR or MB_OK);
  except
    // evita reentradas si no hay UI activa
  end;
end;
// === [Fin utilidades Paso 1] ===

//================ PROCEDIMIENTO DE SERIES FACTURACION ===============
function VF_GetSerieActiva: string;
begin
  // Si no hay serie cargada, pedimos a Ventas que la calcule
  if Trim(SERIEFACT) = '' then
  begin
    if Assigned(FVentas) then
      FVentas.VerSerieFacturacion
    else
      Exit(''); // por seguridad, si no está creado el formulario
  end;

  Result := SERIEFACT;
end;
//================ FIN PROCEDIMIENTO DE SERIES FACTURACION ============




//=============== CREAR EL FORMULARIO ================
procedure ShowFormVentas;
begin
  Impreso[1]:=RutaReports+'Documentos.lrf';
  Impreso[2]:=RutaReports+'Documentos.lrf';
  with TFVentas.Create(Application) do
    begin
      ShowModal;
      //** ShowOnTop;
    end;
end;
procedure TFVentas.FormCreate(Sender: TObject);
var
  T1: QWord;
begin
  //--------- Conectar con la bbdd e inicializar datos globales
  //Conectate(dbConnect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //--------- Cargar Tabla de usuarios -------------
  dbUsu.Active:=False;
  dbUsu.Sql.Text:='SELECT * FROM usuarios'+Tienda+' ORDER BY USU1';
  dbUsu.Active:=True;
  if dbUsu.RecordCount=0 then
   begin
     DataModule1.Mensaje('Información','No hay usuarios creados', 3000 , clGray);
//     ShowMessage('NO TIENE USUARIOS CREADOS, PRIMERO DEBE CREARLOS');
     Close;
     exit;
   end;
  CargaUsuarios();
  //--------- Tickets abiertos
  Llenando:=1;
  dbTickets.Active:=False;
  dbTickets.SQL.Text:='SELECT DISTINCT(V1) As TI0, SUM(V11) As TI1 FROM ventas'+Tienda+Puesto+
                      ' WHERE V0=0 GROUP BY V1';
  dbTickets.Active:=True; TICKET:='1';
  if dbTickets.RecordCount<>0 then begin dbTickets.First; TICKET:=dbTickets.Fields[0].AsString; end;
  LLenando:=0; OperacionRecuperada:='N';
  //--------- Tabla de ventas
  dbVentas.Active:=False;
  dbVentas.SQL.Text:='SELECT * FROM ventas'+Tienda+Puesto+' WHERE V0=0 AND V1='+TICKET;
  dbVentas.Active:=True;
  //--------- Ver si hay lineas de venta de algun cliente para seleccionarlo
  if dbVentas.RecordCount<>0 then
    begin
      PintarTotalGeneral();
      if dbVentas.FieldByName('V12').AsInteger<>0 then
        Edit1.Text:=dbVentas.FieldByName('V12').AsString
      else
        Edit1.Text:=ClienteVario;
    end;
  Edit1Exit(Edit1);//----- Consultar cliente

   //Inicializamos QR

  T1 := VF_TickMS;
  T1 := VF_TickMS;
  VerSerieFacturacion();//---- Ver la serie de facturacion por def
  VF_LogPerf('TOTALIZAR: VerSerieFacturacion', T1);
  VF_LogPerf('TOTALIZAR: VerSerieFacturacion', T1);
  NumeroTicket();//----------- Cargar número de ticket de la tabla de series

  txtQR:=vfUrl+'nif='+NIF+'&'+'numserie=FS-'+SERIEFACT+'-'+IntToStr(NOPERACION+1)+'&fecha='+FormatDateTime('dd-mm-yyyy',date);
  BarcodeQR1.Text:=txtQR+'&importe=0.00';

end;

//============ CERRAR FORMULARIO Y LIBERAR MEMORIA =============
procedure TFVentas.BitBtn7Click(Sender: TObject);
begin
  Close();
end;
procedure TFVentas.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//=============== CONSULTAR CLIENTE ==================

function TFVentas.VerUltimoCliente: string;
var
  Nuevocl : integer;
begin
  dbTrabajo.Active:=False;
  dbTrabajo.Sql.Text:='SELECT * FROM clientes WHERE C0<"'+IntToStr(StrToInt(ClienteVario)-9)+'" ORDER BY C0 DESC LIMIT 1';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then Nuevocl:=1 else Nuevocl:=StrToInt(dbTrabajo.FieldByName('C0').AsString)+1;
  Result:=IntToStr(Nuevocl);

end;

procedure TFVentas.Edit1MouseEnter(Sender: TObject);
begin
  if (Edit1.Text<>'') and (Edit1.Text<>ClienteVario) then Exit;
  if (Edit1.Text='') then begin Edit1.Text:=''; Edit2.Text:=''; end;
  PanelCredito.Visible:=False;
  Label60.Caption:=VerUltimoCliente;
  PanelNuevoCli.Visible:=True;

end;

procedure TFVentas.Edit1MouseLeave(Sender: TObject);
begin
   PanelNuevoCli.Visible:=False;
end;

procedure TFVentas.btCodigoClick(Sender: TObject);
begin
   Edit1.Text:=VerUltimoCliente; Edit1.SetFocus;
end;


//**************************************************************************
//**   Busca precios del artículo en el histórico de clientes/ Artículos  **
//**************************************************************************

procedure TFVentas.btHistoricosClick(Sender: TObject);
var
  inutil: string;
  codigo: string;
begin

 if edit3.TEXT<>'' then
   codigo := edit3.Text
   else begin
     showmessage('Falta código de artículo ');
     exit;
   end;

 case cbHistoricos.ItemIndex of
      0:inutil:=FBusquedas.IniciaBusquedas('SELECT HC0, HC1, HC8, HC9, HC4, CONVERT(HC5 USING UTF8), HC6, (HC7/HC6) as Precio FROM histoclie WHERE HC0='+Edit1.Text
                        , ['Cliente','Fecha','Serie','Número','Código','Descripción','Und','Precio'],'HC1');

       1:inutil:=FBusquedas.IniciaBusquedas('SELECT HOD6, CONVERT(HOD7 USING UTF8), HOD8, HOD9,HOD11,HOD4, HOD3 FROM hisopdd'+Tienda+
               ' WHERE HOD6="'+codigo+'"', ['CODIGO','DESCRIPCION','CANTIDAD','PRECIO','DCT%','SERIE','NUMERO'],'HOD6');

      2:inutil:=FBusquedas.IniciaBusquedas('SELECT HC0, HC1, HC8, HC9, HC4, CONVERT(HC5 USING UTF8), HC6, (HC7/HC6) as Precio FROM histoclie '+
               ' WHERE HC0='+ Edit1.Text + ' and HC4="' + codigo + '"', ['Cliente','Fecha','Serie','Número','Código','Descripción','Und','Precio'],'HC1');

 end;

 Edit8.SetFocus;

end;


procedure TFVentas.Edit1Exit(Sender: TObject);
begin
  PanelCredito.Visible:=False; PanelNuevoCli.Visible:=False; panelNotas.Visible:=False;
  if Edit1.Text='' then Edit1.Text:=ClienteVario; //------- Clientes varios
  dbClientes.Active:=False;
  dbClientes.SQl.Text:='SELECT * FROM clientes WHERE C0='+Edit1.Text;
  dbClientes.Active:=True;
  if dbClientes.RecordCount=0 then
   begin
     if Edit1.Text=ClienteVario then            // Se crea el Cliente Vario .
       begin
         Segundos:=0;
         Timer1.Enabled:=True;
         PanelAvisoClienteVario.Visible:=True;
         Edit29.Text:='Cliente Venta Contado'; Edit31.Text:=''; Edit32.Text:='';
         Edit37.Text:=''; Edit38.Text:=''; Edit39.Text:=''; Edit40.Text:='';
         BitBtn33Click(self);
         Exit
       end;

     if Application.MessageBox('ESE CLIENTE NO EXISTE, QUIERE CREARLO?','FacturLinEx2', boxstyle) = IDNO Then
       begin Edit1.SetFocus; Exit; end;
     Edit29.Text:=''; Edit31.Text:=''; Edit32.Text:='';
     Edit37.Text:=''; Edit38.Text:=''; Edit39.Text:=''; Edit40.Text:='';
     Panel11.Visible:=True;
     //------------- Deshabilito controles para dar de alta
     Panel3.Enabled:=False; DBGrid1.Enabled:=False;
     Panel5.Enabled:=False; Panel1.Enabled:=False;
     BitBtn8.Enabled:=False; BitBtn15.Enabled:=False; BitBtn16.Enabled:=False;
     BitBtn17.Enabled:=False; BitBtn18.Enabled:=False;
     BitBtn21.Enabled:=False; BitBtn22.Enabled:=False;
     Edit29.SetFocus; exit;
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
  //------------------ Si esta activo el panel de pedidos
  if Panel9.Visible=True then
    begin
     Edit17.Text:=dbClientes.FieldByName('C1').AsString;//----- Nombre del cliente.
     Edit18.Text:=dbClientes.FieldByName('C6').AsString;//----- Telefono del cliente.
    end;
  VerSiTieneCredito();//----------- Pintar en credito pendiente
  if (dbClientes.FieldByName('C51').AsString <> '') then   // Pintamos panel de observaciones.
     begin
       memo2.Lines.Clear;
       memo2.Lines.Append(dbClientes.FieldByName('C51').AsString);
       if (TiempoAvisoCliente > 0) then
           begin
              Segundos:=0;
              Timer1.Enabled:=True;
           end;
       panelNotas.Visible:=True;
     end;
//--  Edit3.SetFocus;
end;

procedure TFVentas.Button2Click(Sender: TObject);
begin
     PanelNotas.Visible:=False;
end;

procedure TFVentas.Timer1StopTimer(Sender: TObject);
begin
   Timer1.Enabled:=False;
   if (PanelNotas.Visible=true) then Button2Click(Self);
   if (PanelAvisoVario.Visible=True) then PanelAvisoVario.Visible:=False;
   if (PanelAvisoClienteVario.Visible=True) then PanelAvisoClienteVario.Visible:=False;
end;

procedure TFVentas.Timer1Timer(Sender: TObject);
begin
  segundos:= segundos + 1;
  if (segundos = 5) and (PanelAvisoVario.Visible=True) then Timer1.Enabled:=False;
  if (segundos = 5) and (PanelAvisoClienteVario.Visible=True) then Timer1.Enabled:=False;
  if (segundos = TiempoAvisoCliente) and (PanelNotas.Visible=True) then Timer1.Enabled:=False;
end;


//====================== BUSCAR CLIENTES ======================
procedure TFVentas.BitBtn1Click(Sender: TObject);
begin
  if Edit2.Text='' then begin      DataModule1.Mensaje('Información','Teclear texto a buscar', 2000 , clGray);  Edit2.SetFocus; Exit; end;
  Combo1.Clear; Combo1.Text:='';
  dbBusca.SQL.Text:='SELECT C0,C1 FROM clientes WHERE C1 LIKE "'+Edit2.Text+'%"'; dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then
    begin
      DataModule1.Mensaje('Información','No hay clientes con ese comienzo', 2000 , clGray);
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
procedure TFVentas.Combo1Click(Sender: TObject);
begin
  if Combo1.Text='' then begin Combo1.Visible:=False; Edit2.SetFocus; exit; end;
  if not dbBusca.Locate('C1',Combo1.Text,[]) then begin Edit2.Text:=''; Exit; end;
  Edit1.Text:=dbBusca.Fields[0].AsString;
  Edit2.Text:=dbBusca.Fields[1].AsString;
  Edit1Exit(Edit1);//---- Leer cliente
  Combo1.Visible:=False; Edit3.SetFocus;
end;
procedure TFVentas.Combo1KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then Combo1Click(Combo1);
end;

//=================== CGO. ARTICULO ==================
procedure TFVentas.Edit3Enter(Sender: TObject);
begin
  if (Edit5.Text='0') and (Edit6.Text='0') then LimpiaEntrada();
  BitBtn4.Enabled:=False;
end;

//-------- Si sale con TAB solo pinto articulo
procedure TFVentas.Edit3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_TAB then
    begin
      if Edit3.Text='' then exit;//---- Si no hay articulo
      if LeerArticulo=False then
        if LeerAuxiliar=False then
           begin FLX_Beep(skError);      DataModule1.Mensaje('Información','No existe ese artículo', 1500 , clGray); Edit3.SetFocus; exit; end;
      VerTarifas();
    end;
  if key=VK_ESCAPE then BitBtn7Click(Self);
end;
//-------- Si sale con ENTER pinto articulo y grabo linea
procedure TFVentas.Edit3KeyPress(Sender: TObject; var Key: char);
var
  textoaprobacion:string;
begin
  textoaprobacion:='';
  if (Key=#13) and (edit3.Text='') then
  begin
    dbBusca.Active:=False;dbBusca.SQL.Text:='SELECT A0,A1,A3,A2 FROM artitien'+Tienda+' WHERE A0="9999999999999"'; dbBusca.Active:=True;
     if dbBusca.RecordCount=0 then
        begin
           segundos:=0;
           Timer1.Enabled:=True;
           PanelAvisoVario.Visible:=True;
           dbBusca.Active:=False;
           Exit;
        end;
    Edit3.Text:='9999999999999';
    PanelCodigoVario.Visible:=True;
    if StrTofloat(Edit5.Text)=0 then Edit5.Text:='1';                                  // Cantidad.
    Edit41.Text:=dbBusca.FieldByName('A1').AsString;  // Descripción.
    Edit41.SetFocus;
    Edit10.Text:=dbBusca.FieldByName('A3').AsString;  // IVA.
    if StrTofloat(Edit6.Text)=0 then Edit6.Text:= dbBusca.FieldByName('A2').AsString;  // Precio.
    Edit6Exit(self);                                  // Actualizamos precios.
    dbBusca.Active:=False;
    Exit;
  end;

  if Key=#13 then
    begin
      if LeerArticulo=False then
        if LeerAuxiliar=False then
           begin
             FLX_Beep(skError);
             while UpperCase(textoaprobacion)<>'C' do
               begin
                    textoaprobacion:=InputBox('Información - No existe ese artículo','Pulse C para aceptar y continuar','');
               end;
             if UpperCase(textoaprobacion)='C' then Edit3.Text:='';
             Edit3.SetFocus;
             exit;
           end;
      BitBtn14Click(BitBtn14);//------- Grabar linea de ventas
      Edit3.SetFocus;
    end;
end;

procedure TFVentas.Edit41Exit(Sender: TObject);
var
  Tecla: char;
begin
  tecla:=#13;
  Edit41KeyPress(self, tecla);
end;

procedure TFVentas.Edit41KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then
    begin
      PanelCodigoVario.Visible:=False;
      Edit4.Text:= Edit41.Text;
      BitBtn14.SetFocus;
    end;
end;

procedure TFVentas.BitBtn40Click(Sender: TObject);
begin
  if Label12.Caption='CODIGO ART.' then
     begin
       label12.Color:= clMoneyGreen;
       label12.Caption:= 'CODIGO LOTE';
     end else
     begin
       label12.Color:= clBtnFace;
       label12.Caption:= 'CODIGO ART.';
     end;
end;

procedure TFVentas.BitBtn41Click(Sender: TObject);
begin
  if Label13.Caption='DESCRIPCION ARTICULO' then
     begin
       label13.Color:= clMoneyGreen;
       label13.Caption:= 'DESCRIPCION EAN';
     end else
     begin
       label13.Color:= clBtnFace;
       label13.Caption:= 'DESCRIPCION ARTICULO';
     end;
  Edit4.SetFocus;
end;



//================= NUEVA LINEA DE VENTA =============
procedure TFVentas.BitBtn14Click(Sender: TObject);
begin
  if (Edit3.Text='') or (Edit4.Text='') then exit;//---- Si no hay articulo o unidades
  HayStock;//---- Comprobamos si hay stock suficiente.
  Modificando:=0;
  dbVentas.Append; GrabaEntrada(); 

  try
    dbVentas.Post; //----- Grabar datos.
  except
    on EDB: EDatabaseError do
    begin
     Showmessage('Error : ' + EDB.Message);
    end;
  end;

  LimpiaEntrada();//----- Limpiar la entrada de datos
  PintarTotalGeneral();//----- Pintar Total general
  RefrescaTicketsAbiertos();//----- Refrescar total tickets abiertos
  Edit3.SetFocus;
end;

//================= BORRAR LINEAS DE VENTA =============
procedure TFVentas.BitBtn3Click(Sender: TObject);
begin
  if (dbVentas.RecordCount=0) or (dbVentas.Eof) then exit;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('CONFIRME EL BORRADO DE LA LINEA','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  KeyLogB();
  dbVentas.Delete;
  LimpiaEntrada();//----- Limpiar la entrada de datos
  PintarTotalGeneral();//----- Pintar Total general
  RefrescaTicketsAbiertos();//----- Refrescar total tickets abiertos
  Edit3.SetFocus;
end;

//================= KeyLog en Ventas - Control de borrado de lineas =========== Jose
procedure TFVentas.KeyLogB();
var
 F : TextFile;
 fichero : string;
begin
 fichero:='';
 if FileExists(RutaIni+'BorraDatos_'+FormatDateTime('YYYYMM',(Date-93))+'.txt' ) then
   begin
     //-- borrado del fichero de hace 63 días
     fichero:=(RutaIni+'BorraDatos_'+FormatDateTime('YYYYMM',(Date-93))+'.txt' );
     DeleteFile(fichero);
   end;
 AssignFile( F, RutaIni + 'BorraDatos_'+FormatDateTime('YYYYMM',Date)+'.txt' );
 if FileExists(RutaIni+'BorraDatos_'+FormatDateTime('YYYYMM',(Date))+'.txt' ) then Append(F) else Rewrite( F );
 WriteLn( F, '#------------- Linea Borrada ------------');
 WriteLn( F, 'CAJA : ' + Puesto +' - Dia : ' + FormatDateTime('YYYYMMDD',(Date)) + ' - Hora : ' + FormatDateTime('HH:MM:SS',(time)) );
 WriteLn( F, ' Venta : ' + dbVentas.FieldByName('V1').Text + ' Codigo : ' + dbVentas.FieldByName('V3').Text + ' Descripcion : ' + dbVentas.FieldByName('V4').Text + ' Cantidad : ' + dbVentas.FieldByName('V5').Text + ' Precio : ' + dbVentas.FieldByName('V6').Text + ' Total-Linea : ' + dbVentas.FieldByName('V11').Text + ' Cliente : ' + dbVentas.FieldByName('V12').Text + ' Fecha : ' + dbVentas.FieldByName('V14').Text + ' Hora : ' + dbVentas.FieldByName('V15').Text);
 CloseFile( F );
end;


//================= MODIFICAR LINEAS DE VENTA =============
procedure TFVentas.BitBtn4Click(Sender: TObject);
begin
  if (dbVentas.RecordCount=0) or (dbVentas.Eof) then exit;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('CONFIRME LA MODIFICACION DE LA LINEA','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  Modificando:=1;
  dbVentas.Edit; GrabaEntrada(); 
  
  try
    dbVentas.Post; //----- Grabar datos.
  except
    on EDB: EDatabaseError do
    begin
     Showmessage('Error : ' + EDB.Message);
    end;
  end;
  
  LimpiaEntrada();//----- Limpiar la entrada de datos
  PintarTotalGeneral();//----- Pintar Total general
  RefrescaTicketsAbiertos();//----- Refrescar total tickets abiertos
  Edit3.SetFocus;
end;

procedure TFVentas.BitBtn5Click(Sender: TObject);
begin
  if Edit4.Text='' then begin DataModule1.Mensaje('Información','Teclee artículo a buscar', 2000 , clGray); Edit4.SetFocus; Exit; end;
  BuscaEan:=False;
  ListBox3.Items.Clear;
  dbBusca.SQL.Text:='SELECT A0,A1,A2 FROM artitien'+Tienda+' WHERE A1 LIKE "%'+Edit4.Text+'%" ORDER BY A1';
  if label13.Caption='DESCRIPCION EAN' THEN
    begin
       dbBusca.SQL.Text:='SELECT * FROM eans WHERE EAN2 LIKE "%'+Edit4.Text+'%" ORDER BY EAN2';
       label13.Color:= clBtnFace;
       label13.Caption:='DESCRIPCION ARTICULO';
       BuscaEan:=True;
    end;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then
    begin
      DataModule1.Mensaje('Información','No hay artículos con ese concepto', 1500 , clGray);
//      ShowMessage('NO HAY ARTÍCULOS QUE CONTENGAN ESE CONCEPTO');
      dbBusca.Active:=False; Edit4.SetFocus; Exit;
    end;
  dbBusca.First;
  While not dbBusca.EOF do
    begin
      if (BuscaEan=True) then ListBox3.Items.Add(dbBusca.FieldByName('EAN2').AsString)
                       else ListBox3.Items.Add(dbBusca.FieldByName('A1').AsString);
      dbBusca.Next;
    end;
  PanelBuscaArticulos.Visible:=True;
//  ListBox3.Visible:=True; ListBox3.BringToFront;
  ListBox3.ItemIndex:=0; ListBox3.SetFocus;

end;

procedure TFVentas.ListBox3DblClick(Sender: TObject);
begin
  if (BuscaEan=True) then
    begin
      if not dbBusca.Locate('EAN2',ListBox3.Items.Strings[ListBox3.ItemIndex],[]) then begin Edit4.Text:=''; Exit; end;
      Edit3.Text:=dbBusca.Fieldbyname('EAN0').AsString;
      Edit4.Text:=dbBusca.FieldByName('EAN3').AsString;
      if LeerAuxiliar=False then
          begin
            PanelBuscaArticulos.Visible:=False;
            Edit4.SetFocus;
            exit;
          end;
    end else
    begin
      if not dbBusca.Locate('A1',ListBox3.Items.Strings[ListBox3.ItemIndex],[]) then begin Edit4.Text:=''; Exit; end;
      Edit3.Text:=dbBusca.Fields[0].AsString;
      Edit4.Text:=dbBusca.Fields[1].AsString;
      if Edit6.Text='0' then Edit6.Text:=dbBusca.Fields[2].AsString;
      dbArti.Active:=False;
      dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit3.Text+'"';
      dbArti.Active:=True;
      VerTarifas();
      if LeerArticulo=False then
        begin
          PanelBuscaArticulos.Visible:=False;
          Edit4.SetFocus;
          exit;
        end;
    end;

    PanelBuscaArticulos.Visible:=False;
  BitBtn14.SetFocus;
end;

procedure TFVentas.ListBox3KeyPress(Sender: TObject; var Key: char);
begin
  if key=#27 then
    begin
      PanelBuscaArticulos.Visible:=False;
      Edit4.SetFocus;
      exit;
    end;
   if (Key=#13) then begin Key:=#0; ListBox3DblClick(self); End;
end;

//================= BUSCAR ARTICULOS =============
procedure TFVentas.Edit4KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then BitBtn5Click(BitBtn5);
  if key=#27 then
    begin
      LimpiaEntrada();
      Edit3.SetFocus;
    end;
end;


//=====================================================================
//================ CONTROLAR LOS EDIT DE ENTRADA ======================
//=====================================================================
//================ SALIR DE LAS UNIDADES ===========

//  comprobamos si existen unidades suficientes para la venta actual.
function TFVentas.HayStock: boolean;
begin

  if RoturaStock='N' then exit;

  result:= true;

  if Edit3.Text='9999999999999' then exit;
  if (StrToFloat(Edit5.Text)> dbArti.FieldByName('A4').Value) then
      begin
          DataModule1.Mensaje('AVISO','No existe stock suficiente !!', 2000 ,clGray );
          result:=false;
      end;

end;

procedure TFVentas.Edit5Exit(Sender: TObject);
begin
  if not (EsFloat(Edit5.Text)) then begin Edit5.Text:='0';Edit5.SetFocus; exit; end;
  if HayStock=false then label40.Font.Color:=clRed;//------- No hay unidades suficientes.

  VerImporteEntra(); VerTotalEntra();
end;
//----------- Si introduce unidades antes que el codigo y pulsa ENTER (F5)
procedure TFVentas.Edit5KeyPress(Sender: TObject; var Key: char);
var
  AntEdit5: String;
  AntEdit6: String;
begin
  if Key<>#13 then exit;
  if not (EsFloat(Edit5.Text)) then begin Edit5.Text:='0';Edit5.SetFocus; exit; end;
  if Edit5.Text='0' then begin Edit3.SetFocus; exit; end;
  AntEdit5:=Edit5.Text;
  AntEdit6:=Edit6.Text;
  Edit3.SetFocus; Edit5.Text:=AntEdit5; Edit6.Text:=AntEdit6;
end;

//================== SALIR DEL PVP ==============
procedure TFVentas.Edit6Exit(Sender: TObject);
var
  PrecioSin: Double;
begin
   if not (EsFloat(Edit6.Text)) then begin Edit6.Text:='0';Edit6.SetFocus; exit; end;
   PrecioSin := (100 * StrToFloat(Edit6.text)) / (100 + StrToFloat(Edit10.Text));
   Edit7.Text:=FormatFloat('0.000',PrecioSin);
   Edit7Exit(Self);
 end;

//----------- Si se modifica la linea y pulsa ENTER (F6)
procedure TFVentas.Edit6KeyPress(Sender: TObject; var Key: char);
var
  AntEdit5: String;
  AntEdit6: String;
begin
  if Key<>#13 then exit;
  if not (EsFloat(Edit6.Text)) then begin Edit6.Text:='0';Edit6.SetFocus; exit; end;
  if Edit6.Text='0' then begin Edit3.SetFocus; exit; end;
  AntEdit5:=Edit5.Text;
  AntEdit6:=Edit6.Text;
  Edit3.SetFocus; Edit5.Text:=AntEdit5; Edit6.Text:=AntEdit6;
end;

procedure TFVentas.Edit7DblClick(Sender: TObject);
begin
  if ListBox2.Items.Count=0 then showmessage('No hay tarifas que mostrar')
  else MuestraTarifas();
end;

//================== SALIR DEL PRECIO ==============
procedure TFVentas.Edit7Exit(Sender: TObject);
var
  PrecioCon: Double;
begin
  if not (EsFloat(Edit7.Text)) then begin Edit7.Text:='0';Edit7.SetFocus; exit; end;
  //----- Calcular precio con iva por si ha cambiado
  if (Edit10.Text<>'') and (Edit10.Text<>'0') then
    begin
     PrecioCon:=(StrToFloat(Edit7.Text) * StrToFloat(Edit10.Text) / 100) +
              StrToFloat(Edit7.Text); //--- Sumar el IVA
     Edit6.Text:=FormatFloat('0.00',PrecioCon);
    end;
  //---- Calcular importe y total
  VerImporteEntra(); VerTotalEntra();
end;

//================== SALIR DEL DESCUENTO ==============
procedure TFVentas.Edit8Exit(Sender: TObject);
begin
  if not (EsFloat(Edit8.Text)) then begin Edit8.Text:='0';Edit8.SetFocus; exit; end;

//  if Edit8.Text='' then Edit8.Text:='0';


  //---- Calcular importe y total
  VerImporteEntra(); VerTotalEntra();
end;

//======================= SALIR DEL IVA ================
procedure TFVentas.Edit10Exit(Sender: TObject);
begin
  if not (EsFloat(Edit10.Text)) then begin Edit10.Text:='0';Edit10.SetFocus; exit; end;
  Edit7.Text:=FloatToStr(StrToFloat(Edit6.Text)/(1+(StrToFloat(Edit10.Text)/100)));
  Edit7.Text:=FormatFloat('0.000',StrToFloat(Edit7.Text));
end;

//----------- Si se modifica la linea y pulsa ENTER (F11)
procedure TFVentas.Edit8KeyPress(Sender: TObject; var Key: char);
begin
  if Key<>#13 then exit;
  if Edit8.Text='0' then begin Edit3.SetFocus; exit; end;
  if BitBtn4.Enabled then BitBtn4.SetFocus else Edit3.SetFocus;
end;

//================== SALIR DEL TOTAL =================
procedure TFVentas.Edit11Exit(Sender: TObject);
begin
  if not (EsFloat(Edit11.Text)) then begin Edit11.Text:='0';Edit11.SetFocus; exit; end;
  //---- Calcular importe y el descuento Con esta linea, siempre que tenga iva puesto, calcula el importe y el descuento
  if (Edit10.Text='0') or (Edit7.Text='0') then exit; // Si no existe IVA o Dto, Salimos para que no de error de calculos
  VerDtoEntra();
end;
//----------- Si se modifica la linea y pulsa ENTER (F7)
procedure TFVentas.Edit11KeyPress(Sender: TObject; var Key: char);
begin
  if Key<>#13 then exit;
  if Edit11.Text='0' then begin Edit3.SetFocus; exit; end;
  if BitBtn4.Enabled then BitBtn4.SetFocus else Edit3.SetFocus;
end;

//============================================================
//================== TOTALIZAR VENTAS ========================
//============================================================
procedure TFVentas.BitBtn8Click(Sender: TObject);
begin
  if dbVentas.RecordCount=0 then exit;

  if ( CgPrFraV = 'S' ) or ( CgPrAlbV = 'S' ) then                //--- Cargamos valores para la impresion al totalizar.
     begin
       cbImprimir.Checked:= True;
       cbImpresionDirecta.Checked:=False;
     end
     else
     begin
       cbImprimir.checked:= True;
       cbImpresionDirecta.Checked:=True;
     end;

    cbCorreoElectronico.Checked:=dbClientes.FieldByName('C55').AsBoolean;

    edNumeroCopias.Text:=dbClientes.FieldByName('C8').AsString; if edNumeroCopias.Text='0' then edNumeroCopias.Text:='1';

  Combo2.ItemIndex:=0; // Inicializamos forma de pago a contado.

  chBoxRegalo.Checked:= false;                                                          //-- Checkbox anulado, si lo quiere, se activa
  if TicketRegalo='S' then ChBoxRegalo.Visible:=True else ChBoxRegalo.Visible:=False;   //-- Si está activada la opción, se muestra el checbox

  Label32.Font.Color:=clWindowText; Label32.Caption:='CAMBIO';
  Edit16.Font.Color:=clWindowText;
  CargaValoresTotalizar();
  Label32.Top:=254; Edit16.Top:=243;
  Label81.Visible:=False; Edit42.Visible:=False;
  Label31.Caption:='ENTREGA';
  Panel4.Visible:=True;

 if PedirSiempreUsuario='N' then cajon();  // Abrimos cajón al totalizar

 if PedirSiempreUsuario='S' then
   begin
        Panel12.Visible:=True;
        BitBtn9.Enabled:=False;
        BitBtn10.Enabled:=False;
        BitBtn11.Enabled:=False;
        BitBtn12.Enabled:=False;
        BitBtn13.Enabled:=False;
   end;

  Bloquear();//------- Bloquear controles
  if PedirSiempreUsuario='S' then btnUsuarioActivo.SetFocus else Edit15.SetFocus;
end;


//---------------- Cargamos valores para totalizar -------------
procedure TFVentas.CargaValoresTotalizar();
begin
  Edit12.Text:=StaticText1.Caption;//----- Importe
  Edit13.Text:='0.00';//------------------ Dto.
  Edit14.Text:=StaticText1.Caption;//----- Total
  Edit15.Text:=StaticText1.Caption;//----- Entrega
  Edit42.Text:='0.00';//------------------ Contado / Puntos
  Edit16.Text:='0.00';//------------------ Cambio
end;

//---------------- Cerrar totalizar -----------------
procedure TFVentas.BitBtn9Click(Sender: TObject);
begin
  Desbloquear();//----- Desbloquear controles
  Panel4.Visible:=False;
end;

//----------------- Tipo de pago -----------------
procedure TFVentas.Combo2Change(Sender: TObject);
begin
  Edit15.Enabled:=True;
  Edit12.Text:=StaticText1.Caption;//----- Importe
  Edit14.Text:=StaticText1.Caption;//----- Total
  Edit15.Text:=StaticText1.Caption;//----- Entrega
  Edit16.Text:='0.00';//----- Cambio
  Edit14Exit(Edit14);
  Edit42.Text:='0.00';//---- Entrega CONTADO en TARJETAS+CONTADO
  //---------- Posicion original ------------
  Label32.Top:=254; Edit16.Top:=243;
  Label81.Visible:=False; Edit42.Visible:=False;
  Label31.Caption:='ENTREGA'; Label81.Caption:='CONTADO';
  //---------- Tarjeta + contado ------------
  if Combo2.Text='TARJETA+CONTADO' then
    begin
      Label32.Top:=312; Edit16.Top:=304;
      Label81.Visible:=True; Edit42.Visible:=True;
      Label31.Caption:='TARJETA';
    end;
  //---------- Puntos acumulados ------------
  if Combo2.Text='PUNTOS ACUMULADOS' then
    begin
      if APuntos<>'S' then begin DataModule1.Mensaje('Información','Los puntos están desactivados', 2000 , clGray); Combo2.Text:='CONTADO'; exit; end;
      if dbClientes.FieldByName('C49').AsString<>'S' then begin DataModule1.Mensaje('Información','Este cliente no tiene los puntos activados', 2000 , clGray); Combo2.Text:='CONTADO'; exit; end;
      if dbClientes.FieldByName('C50').AsFloat<=0 then begin DataModule1.Mensaje('Información','Este cliente no tiene los puntos acumulados', 2000 , clGray); Combo2.Text:='CONTADO'; exit; end;
      Label32.Top:=312; Edit16.Top:=304;
      Label81.Visible:=True; Edit42.Visible:=True;
      Label81.Caption:='PUNTOS';
      // --- Saldo en puntos
      if dbClientes.FieldByName('C50').AsFloat < StrToFloat(Edit15.Text) then
        Edit42.Text:=FormatFloat('0.00',dbClientes.FieldByName('C50').AsFloat)
      else
        Edit42.Text:=Edit14.Text;
      Edit14.Text:=FloatToStr(StrToFloat(Edit14.Text)-StrToFloat(Edit42.Text));
      Edit14Exit(Edit14);
    end;
  If ((StrToFloat(Edit14.Text)=0) and (StrToFloat(Edit12.Text)>0)) then Edit15.Enabled:=false else Edit15.Enabled:=true;
    Edit13.SetFocus; // Nos posicionamos es el descuento.
end;

//========================================================
//================== TOTALIZAR SIN TICKET ================
//========================================================
procedure TFVentas.BitBtn10Click(Sender: TObject);
var
  T0, T1: QWord;
begin
  T0 := VF_TickMS;
  VF_LogInfo('TOTALIZAR: BitBtn10Click START');


	vfTipoFactura:='F2';  //-- Definimos TipoFactura Veri*Factu como F2 - Factura Simplificada

  if (Combo2.Text='TARJETA+CONTADO') or (Combo2.Text='PUNTOS ACUMULADOS') then
     if StrToFloat(Edit16.Text)<0 then begin DataModule1.Mensaje('Información','No puede entregar menos del total', 2000 , clGray); exit; end; //----- Si este tipo e pago, no credito

  if StrToFloat(Edit16.Text)<0 then if not VersiapuntarCredito then exit;//--- Si se apunta a credito o no

   //-- Si el resultado de la venta es negativo, preguntar si vale o efectivo
  if StrToFloat(Edit14.Text)<0 then
    begin
    end;

  FechaVenta:=Date; HoraVenta:=Time;//---- Fecha y hora para grabar los datos
  VerSerieFacturacion();//---- Ver la serie de facturacion por defecto
  NumeroTicket();//----------- Ver el numero de ticket que corresponde
  dbVentas.First; DESCRIOPER:='';
  TIPOOPER:='NS';//----------- Tipo de operacion (Normal Sin ticket)
  while not dbVentas.EOF do
    begin
      T1 := VF_TickMS;
  T1 := VF_TickMS;
  ActualizaDatos();
  VF_LogPerf('TOTALIZAR: ActualizaDatos', T1);
  VF_LogPerf('TOTALIZAR: ActualizaDatos', T1);
      T1 := VF_TickMS;
  T1 := VF_TickMS;
  ActualizaIva();
  VF_LogPerf('TOTALIZAR: ActualizaIva', T1);
  VF_LogPerf('TOTALIZAR: ActualizaIva', T1);
      dbVentas.Next;
    end;
    
  // =================================================
  // === Veri*Factu: Encolar factura (DB/Archivos) ===
  // =================================================
  try
    T1 := VF_TickMS;
    T1 := VF_TickMS;
    VeriFactu_QueueFactura(
      'FS-' + SERIEFACT,
      NOPERACION,
      Date,
      HoraVenta,
      StrToFloat(Edit14.Text)
    );
    VF_LogPerf('TOTALIZAR: VeriFactu_QueueFactura', T1);
  except
        on E: Exception do
         begin
           Writeln('ERROR CAPTURADO: ' + E.Message);
         end;
  end;
  // =================================================

  T1 := VF_TickMS;
  T1 := VF_TickMS;
  ActualizaHisto();//--------- Actualizar Hist. Operaciones Cabeceras
  VF_LogPerf('TOTALIZAR: ActualizaHisto', T1);
  VF_LogPerf('TOTALIZAR: ActualizaHisto', T1);
//  if Combo2.Text='TARJETA+CONTADO' then CajaTarjetas();//----- Apuntar tarjetas a las cajas
//  showmessage(IntToStr(Combo2.ItemIndex));
  if ( Combo2.ItemIndex < 7 ) and ( Combo2.ItemIndex > 0 ) then CajaTarjetas(); //----- Apuntar tarjetas a las cajas
  if Combo2.Text='PUNTOS ACUMULADOS' then CajaPuntos();//----- Apuntar puntos a las cajas
  if (StrToFloat(Edit16.Text)<0) then ApuntaCredito();//-------- Apuntar a credito
  if OperacionRecuperada='P' then
    begin
      T1 := VF_TickMS;
      Actualizapedido();//--- Actualizar pedido
      VF_LogPerf('TOTALIZAR: Actualizapedido', T1);
    end;
  if OperacionRecuperada='PRE' then
    begin
      T1 := VF_TickMS;
      Actualizaprepro();//- Actualizar presup./profoema
      VF_LogPerf('TOTALIZAR: Actualizaprepro', T1);
    end;
  BitBtn9Click(BitBtn9);//----- Ocultar panel totalizar
  BitBtn15Click(BitBtn15, false);//--- Borrar todas las lineas de venta
  dbVentas.Refresh; Edit1.Text:=ClienteVario; Edit1Exit(Edit1);
  PintarTotalGeneral();
  RefrescaTicketsAbiertos();
  if dbVentas.RecordCount<>0 then CambiarTicket();
  OperacionRecuperada:='N'; Edit3.SetFocus;
  BitBtn24Click(BitBtn24);
  VF_LogPerf('TOTALIZAR: BitBtn10Click END', T0);
end;

procedure TFVentas.BitBtn9Enter(Sender: TObject);
begin
 BitBtn9.Font.Color:=clRed;
end;

procedure TFVentas.BitBtn9Exit(Sender: TObject);
begin
 BitBtn9.Font.Color:=clDefault;
end;

procedure TFVentas.BitBtn10Enter(Sender: TObject);
begin
  BitBtn10.Font.Color:=clRed;
end;

procedure TFVentas.BitBtn10Exit(Sender: TObject);
begin
 BitBtn10.Font.Color:=clDefault;
end;


procedure TFVentas.BitBtn11Enter(Sender: TObject);
begin
 BitBtn11.Font.Color:=clRed;
end;

procedure TFVentas.BitBtn11Exit(Sender: TObject);
begin
 BitBtn11.Font.Color:=clDefault;
end;

procedure TFVentas.BitBtn12Enter(Sender: TObject);
begin
 BitBtn12.Font.Color:=clRed;
end;

procedure TFVentas.BitBtn12Exit(Sender: TObject);
begin
 BitBtn12.Font.Color:=clDefault;
end;

procedure TFVentas.BitBtn13Enter(Sender: TObject);
begin
 BitBtn13.Font.Color:=clRed;
end;

procedure TFVentas.BitBtn13Exit(Sender: TObject);
begin
 BitBtn13.Font.Color:=clDefault;
end;

procedure TFVentas.BitBtn19Enter(Sender: TObject);
begin
 BitBtn19.Font.Color:=clGreen;
end;

procedure TFVentas.BitBtn19Exit(Sender: TObject);
begin
 BitBtn19.Font.Color:=clDefault;
end;

procedure TFVentas.BitBtn23Enter(Sender: TObject);
begin
 BitBtn23.Font.Color:=clRed;
end;

procedure TFVentas.BitBtn23Exit(Sender: TObject);
begin
 BitBtn23.Font.Color:=clDefault;
end;


//========================================================
//================== TOTALIZAR CON TICKET ================
//========================================================
procedure TFVentas.BitBtn11Click(Sender: TObject);
var
  T0, T1: QWord;
begin
  T0 := VF_TickMS;
  VF_LogInfo('TOTALIZAR: BitBtn11Click START');


  vfTipoFactura:='F2';  //-- Definimos TipoFactura Veri*Factu como F2 - Factura Simplificada

  if StrToFloat(Edit16.Text)<0 then if not VersiapuntarCredito then exit;//--- Si se apunta a credito o no
  FechaVenta:=Date; HoraVenta:=Time;//---- Fecha y hora para grabar los datos
  VerSerieFacturacion();//---- Ver la serie de facturacion por defecto
  NumeroTicket();//----------- Ver el numero de ticket que corresponde

  DirectorioQR:='';

  if DirectoryExists(RutaPdf) then DirectorioQR:=RutaPdf+'/QR.png'
                              else DirectorioQR:= RutaIni+'/QR.png';

  if FileExists(DirectorioQR) then DeleteFile(DirectorioQR);
                                                                // Creamos el fichero QR para incluir en el report.

  BarcodeQR1.SaveToFile(DirectorioQR, TPortableNetworkGraphic);

  ImpreTicket(false);//------------ Imprimir Ticket();

  if ChBoxRegalo.Checked then ImpreTicket(true); //------------ Imprime ticket regalo.

  dbVentas.First; DESCRIOPER:='';
  TIPOOPER:='NT';//----------- Tipo de operacion (Normal Con ticket)
  while not dbVentas.EOF do
    begin
      ActualizaDatos();
      ActualizaIva();
      dbVentas.Next;
    end;
    
  // =================================================
  // === Veri*Factu: Encolar factura (DB/Archivos) ===
  // =================================================
  try
    VeriFactu_QueueFactura(
      'FS-' + SERIEFACT,
      NOPERACION,
      Date,
      HoraVenta,
      StrToFloat(Edit14.Text)
    );
    VF_LogPerf('TOTALIZAR: VeriFactu_QueueFactura', T1);
  except
        on E: Exception do
         begin
           Writeln('ERROR CAPTURADO: ' + E.Message);
         end;
  end;
  // =================================================

  ActualizaHisto();//--------- Actualizar Hist. Operaciones Cabeceras
  if ( Combo2.ItemIndex < 7 ) and ( Combo2.ItemIndex > 0 ) then CajaTarjetas(); //----- Apuntar tarjetas a las cajas
  if Combo2.Text='PUNTOS ACUMULADOS' then CajaPuntos();//----- Apuntar puntos a las cajas
  if StrToFloat(Edit16.Text)<0 then ApuntaCredito();//--- Apuntar a credito
  if OperacionRecuperada='P' then
    begin
      T1 := VF_TickMS;
      Actualizapedido();//--- Actualizar pedido
      VF_LogPerf('TOTALIZAR: Actualizapedido', T1);
    end;
  if OperacionRecuperada='PRE' then
    begin
      T1 := VF_TickMS;
      Actualizaprepro();//- Actualizar presup./profoema
      VF_LogPerf('TOTALIZAR: Actualizaprepro', T1);
    end;
  BitBtn9Click(BitBtn9);//---- Ocultar panel totalizar
  BitBtn15Click(BitBtn15, false);//-- Borrar todas las lineas de venta
  dbVentas.Refresh; Edit1.Text:=ClienteVario; Edit1Exit(Edit1);
  PintarTotalGeneral();
  RefrescaTicketsAbiertos();
  if dbVentas.RecordCount<>0 then CambiarTicket();
  OperacionRecuperada:='N'; Edit3.SetFocus;
  BitBtn24Click(BitBtn24);
  VF_LogPerf('TOTALIZAR: BitBtn11Click END', T0);
end;

//========================================================
//================= TOTALIZAR CON ALBARAN ================
//========================================================
procedure TFVentas.BitBtn12Click(Sender: TObject);
begin
  if Edit1.Text=ClienteVario then begin DataModule1.Mensaje('Información','No puede hacer albarán a clientes varios', 2000 , clGray); exit; end;
  if CgForzAl='S' then
    begin
         //ShowMessage('El valor de CgForzAl es : '+CgForzAl);
         Edit15.SetFocus;
         Edit15.Text:='0';
         //ShowMessage('Valor de Edit16 es: '+Edit16.Text);
         Edit16.SetFocus;
         //ShowMessage('Valor de Edit16 es: '+Edit16.Text);
    end;
  if (StrToFloat(Edit16.Text)<0) or (CgForzAl='S') then if not VersiapuntarCredito then exit;//--- Si se apunta a credito o no
  //--- Ver la tienda activa para saber que serie usa por defecto
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin DataModule1.Mensaje('Información','No sé en que tienda facturar', 2000 , clGray); Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" and SF0 like "%'+copy(FormatDateTime('YYYY',(now)),3,2)+'%" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin DataModule1.Mensaje('Información','Falta serie de facturación', 2000 , clGray) ; exit; end;
  dbSeries.First; ListBox1.Items.Clear;
  Label33.Caption:='N. Albaran';  Label34.Caption:='Fecha Albaran';
  Edit22.Text:=FormatDateTime('DD/MM/YYYY',Date);
  while not dbSeries.EOF do
    begin
     ListBox1.Items.Add(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
     dbSeries.Next;
    end;
  dbSeries.Locate('SF0', dbTiendas.Fields[11].AsString, [loCaseInsensitive]);
  ListBox1.ItemIndex:= ListBox1.Items.IndexOf(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
  Edit21.Text:=IntToStr(dbSeries.FieldByName('SF3').AsInteger+1);

  Panel14.Visible:=True;
  Panel15.Visible:=False;
  BitBtn19.SendToBack; BitBtn19.Enabled:=False; BitBtn23.Enabled:=True;
  dbTiendas.Active:=False; BitBtn23.BringToFront;
  Panel8.Visible:=True; Panel4.Enabled:=False;
  Panel1.Enabled:=False;
//-- PRUEBA DE COPIA MEMO CLIENTES
  if dbClientes.FieldByName('C56').AsBoolean then
    begin
      Memo1.Text:=dbClientes.FieldByName('C36').AsString;
    end
  else
    begin
      Memo1.Text:='';
    end;
  BitBtn23.SetFocus;
end;

//---------------- Aceptar nuevo albaran ----------------
procedure TFVentas.BitBtn23Click(Sender: TObject);
var
  TxtQ: String;
  TotArti, TotPrecio: Double;
  EstadoImpresion: integer;

begin
  FechaVenta:=Date; HoraVenta:=Time;//---- Fecha y hora para grabar los datos
  SERIEFACT:=dbSeries.FieldByName('SF0').AsString;
  if SERIEFACT='' then begin DataModule1.Mensaje('Información','Se necesita seleccionar SERIE a facturar', 2000 , clGray); Exit; end;
  BitBtn20Click(BitBtn20);//--- Ocultar panel series de albaranes
  NumeroAlbaran();
  dbMuestrad.Active:=False;
  dbMuestrad.SQL.Text:='SELECT * FROM albad'+Tienda+' WHERE AD0='+Edit1.Text+
  ' AND AD1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'" AND AD2="'+SERIEFACT+'"'+
  ' AND AD3='+IntToStr(NOPERACION);
  dbMuestrad.Active:=True;
  dbVentas.First; TotArti:=0; TotPrecio:=0; DESCRIOPER:='';
  while not dbVentas.EOF do
    begin
      ActualizaDatos();
      TotArti:=TotArti+dbVentas.FieldByName('V5').AsFloat;//-- Acumular unidades
      TotPrecio:=TotPrecio+dbVentas.FieldByName('V7').AsFloat;//-- Acumular Precio
      //--- Detalle del albaran
      dbMuestrad.Append;
      dbMuestrad.FieldByName('AD0').AsString:=Edit1.Text;//----------- Cliente.
      dbMuestrad.FieldByName('AD1').Value:=StrToDate(Edit22.Text);//-- Fecha albaran.
      dbMuestrad.FieldByName('AD2').Value:=SERIEFACT;//---------------- Serie del albaran.
      dbMuestrad.FieldByName('AD3').Value:=NOPERACION;//--------------- N. Albaran.
      dbMuestrad.FieldByName('AD4').Value:=VerUltimaLineaA;//----------- N. Linea
      dbMuestrad.FieldByName('AD5').AsString:=dbVentas.FieldByName('V3').AsString;//--- C. Articulo
      dbMuestrad.FieldByName('AD6').AsString:=dbVentas.FieldByName('V4').AsString;//--- Descripcion
      dbMuestrad.FieldByName('AD7').Value:=dbVentas.FieldByName('V5').Value;//--------- Unidades
      dbMuestrad.FieldByName('AD8').Value:=dbVentas.FieldByName('V6').Value;//--------- P.V.P.
      dbMuestrad.FieldByName('AD9').Value:=dbVentas.FieldByName('V7').Value;//--------- Precio
      dbMuestrad.FieldByName('AD10').Value:=dbVentas.FieldByName('V8').Value;//-------- Dto.
      dbMuestrad.FieldByName('AD11').Value:=dbVentas.FieldByName('V9').Value;//-------- Importe
      dbMuestrad.FieldByName('AD12').Value:=dbVentas.FieldByName('V10').Value;//------- IVA
      dbMuestrad.FieldByName('AD13').Value:=dbVentas.FieldByName('V11').Value;//------- Total
      //dbMuestrad.FieldByName('AD14').Value:='';//-------- Cgo. Talla/Color
      dbMuestrad.FieldByName('AD15').Value:='A';//------- Tipo de linea
      //dbMuestrad.FieldByName('AD16').Value:='';//-------- Observaciones del albaran
      
      try
        dbMuestrad.Post;
      except
        on EDB: EDatabaseError do
        begin
         Showmessage('Error : ' + EDB.Message);
        end;
      end;
      
      dbVentas.Next;
    end;
  dbTrabajo.Active:=False;
  //------------ Cabecera del albaran
  dbTrabajo.SQL.Text:='SELECT * FROM albac'+Tienda+' WHERE AC0='+Edit1.Text+
  ' AND AC1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'"'+
  ' AND AC2="'+SERIEFACT+'" AND AC3='+IntToStr(NOPERACION);
  dbTrabajo.Active:=True;
  dbtrabajo.Append;
  dbtrabajo.FieldByName('AC0').AsString:=Edit1.Text; //-------------- Cliente.
  dbtrabajo.FieldByName('AC1').Value:=StrToDate(Edit22.Text); //----- Fecha Albaran
  dbtrabajo.FieldByName('AC2').Value:=SERIEFACT; //------------------- Serie del albaran.
  dbtrabajo.FieldByName('AC3').Value:=NOPERACION; //------------------- N. Albaran.
  dbtrabajo.FieldByName('AC4').Value:=dbMuestrad.RecordCount;//------ N. Lineas
  dbtrabajo.FieldByName('AC5').Value:=TotArti;//--------------------- N. Articulos
  dbtrabajo.FieldByName('AC6').Value:=0;//----------------- Dto. pronto pago
  dbtrabajo.FieldByName('AC7').Value:=dbClientes.Fields[19].AsString;//-- Recargo S/N
  dbtrabajo.FieldByName('AC8').Value:=TotPrecio;//-------------------- Imp. Sin IVA
  dbtrabajo.FieldByName('AC9').Value:=StrToFloat(Edit14.Text);//------ Imp. Con IVA
  dbtrabajo.FieldByName('AC10').Value:='N';//------------------------- Marcado (S/N)
  dbtrabajo.FieldByName('AC11').Value:=Memo1.Lines.Text;//------------ Observaciones
  try
    dbtrabajo.Post;
  except
    on EDB: EDatabaseError do
    begin
      Showmessage('Error : ' + EDB.Message);
    end;
  end;

  //-------------------
  TIPOOPER:='AL';//----------- Tipo de operacion (Normal Sin ticket)
  ActualizaHisto();//--------- Actualizar Hist. Operaciones Cabeceras
  if ( Combo2.ItemIndex < 7 ) and ( Combo2.ItemIndex > 0 ) and ( CgForzAl='N') then CajaTarjetas(); //----- Apuntar tarjetas a las cajas
  if Combo2.Text='PUNTOS ACUMULADOS' then CajaPuntos();//----- Apuntar puntos a las cajas
  if (StrToFloat(Edit16.Text)<0) or (CgForzAl='S') then ApuntaCredito();//--- Apuntar a credito
  if OperacionRecuperada='P' then Actualizapedido();//--- Actualizar pedido
  if OperacionRecuperada='PRE' then Actualizaprepro();//- Actualizar presup./profoema

     // Recargamos las consultas para imprimir.
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM albac'+Tienda+' WHERE AC0='+Edit1.Text+
  ' AND AC1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'"'+
  ' AND AC2="'+SERIEFACT+'" AND AC3='+IntToStr(NOPERACION);
  dbTrabajo.Active:=True;
  dbMuestrad.Active:=False;
  dbMuestrad.SQL.Text:='SELECT * FROM albad'+Tienda+' WHERE AD0='+Edit1.Text+
  ' AND AD1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'" AND AD2="'+SERIEFACT+'"'+
  ' AND AD3='+IntToStr(NOPERACION);
  dbMuestrad.Active:=True;

  if (cbImprimir.Checked) then
    begin
      EstadoImpresion:=FImpresion.Imprime(dbMuestrad, dbTrabajo, dbClientes, 'ALBARAN', cbImpresionDirecta.Checked, StrToInt(edNumeroCopias.Text));

      TxtQ:='';

      if EstadoImpresion=1 then TxtQ:='UPDATE albac'+Tienda+' SET AC13="S" WHERE AC0='+Edit1.Text+                  //Imprimido
                               ' AND AC1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'"'+
                               ' AND AC2="'+SERIEFACT+'" AND AC3='+IntToStr(NOPERACION);

      if EstadoImpresion=2 then TxtQ:='UPDATE albac'+Tienda+' SET AC14="S" WHERE AC0='+Edit1.Text+                  //Email
                               ' AND AC1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'"'+
                               ' AND AC2="'+SERIEFACT+'" AND AC3='+IntToStr(NOPERACION);

      if EstadoImpresion=3 then TxtQ:='UPDATE albac'+Tienda+' SET AC13="S", SET AC14="S" WHERE AC0='+Edit1.Text+                  //Imprimido + email
                               ' AND AC1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'"'+
                               ' AND AC2="'+SERIEFACT+'" AND AC3='+IntToStr(NOPERACION);

      if (TxtQ<>'') then
        begin
            dbTrabajo.SQL.Text:= TxtQ;
          try
            dbTrabajo.ExecSQL;
          except
            on EDB: EZSQLException do showmessage( 'Error al actualizar tabla de cabeceras de Albaranes : '+ EDB.Message);
          end;

        end;

    end;

  BitBtn9Click(BitBtn9);//----- Ocultar panel totalizar
  BitBtn15Click(BitBtn15, false);//--- Borrar todas las lineas de venta
  dbVentas.Refresh; Edit1.Text:=ClienteVario; Edit1Exit(Edit1);
  PintarTotalGeneral(); RefrescaTicketsAbiertos();
  if dbVentas.RecordCount<>0 then CambiarTicket();
  OperacionRecuperada:='N'; Edit3.SetFocus;
  BitBtn24Click(BitBtn24);

end;

//=================== SACAR EL ULT N. DE LINEA =====================
function TFVentas.VerUltimaLineaA: Integer;
begin
  VerUltimaLineaA:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(AD4) As ULTIMA FROM albad'+Tienda+' WHERE AD0='+Edit1.Text+
  ' AND AD1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'" AND AD2="'+SERIEFACT+'"'+
  ' AND AD3='+IntToStr(NOPERACION);
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLineaA:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;

//========================================================
//================= TOTALIZAR CON FACTURA ================
//========================================================
procedure TFVentas.BitBtn13Click(Sender: TObject);
begin

  vfTipoFactura:='F1';  //-- Definimos TipoFactura Veri*Factu como F1 - Factura Completa

  if Edit1.Text=ClienteVario then begin DataModule1.Mensaje('Información','No se puede hacer factura a clientes varios', 2000 , clGray); exit; end;
  if StrToFloat(Edit16.Text)<0 then if not VersiapuntarCredito then exit;//--- Si se apunta a credito o no
  //--- Ver la tienda activa para saber que serie usa por defecto
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin DataModule1.Mensaje('Información','No sé en qué tienda facturar', 2000 , clGray);Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" and SF0 like "%'+copy(FormatDateTime('YYYY',(now)),3,2)+'%" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin DataModule1.Mensaje('Información','Falta serie de facturación', 2000 , clGray); exit; end;
  dbSeries.First; ListBox1.Items.Clear;
  Label33.Caption:='N. Factura';  Label34.Caption:='Fecha Factura';
  Edit22.Text:=FormatDateTime('DD/MM/YYYY',Date);
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
  Panel14.Visible:=False;
  Panel15.Visible:=True;

  BitBtn23.SendToBack; BitBtn23.Enabled:=False; BitBtn19.Enabled:=True;
  dbTiendas.Active:=False; BitBtn19.BringToFront;
  Panel8.Visible:=True; Panel4.Enabled:=False;
  Panel1.Enabled:=False; BitBtn19.SetFocus;
end;

//---------------- Aceptar nueva factura ----------------
procedure TFVentas.BitBtn19Click(Sender: TObject);
var
  TxtQ: String;
  TotArti, TotPrecio: Double;
  EstadoImpresion: integer;

begin
  FechaVenta:=Date; HoraVenta:=Time;//---- Fecha y hora para grabar los datos
  SERIEFACT:=dbSeries.FieldByName('SF0').AsString;
  if SERIEFACT='' then begin DataModule1.Mensaje('Información','Seleccionar SERIE de facturación', 2000 , clGray); Exit; end;
  BitBtn20Click(BitBtn20);//--- Ocultar panel series de facturas
  NumeroFactura();
  dbMuestrad.Active:=False;
  dbMuestrad.SQL.Text:='SELECT * FROM factud'+Tienda+' WHERE FD0='+Edit1.Text+
  ' AND FD1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'" AND FD2="'+SERIEFACT+'"'+
  ' AND FD3='+IntToStr(NOPERACION);
  dbMuestrad.Active:=True;
  dbVentas.First; TotArti:=0; TotPrecio:=0; DESCRIOPER:='';
  TIPOOPER:='FA';//----------- Tipo de operacion (Normal Sin ticket)
  while not dbVentas.EOF do
    begin
      ActualizaDatos();
      ActualizaIva();
      TotArti:=TotArti+dbVentas.FieldByName('V5').AsFloat;//-- Acumular unidades
      TotPrecio:=TotPrecio+dbVentas.FieldByName('V7').AsFloat;//-- Acumular Precio
      dbMuestrad.Append;
      dbMuestrad.FieldByName('FD0').AsString:=Edit1.Text;//----------- Cliente.
      dbMuestrad.FieldByName('FD1').Value:=StrToDate(Edit22.Text);//-- Fecha Factura.
      dbMuestrad.FieldByName('FD2').Value:=SERIEFACT;//---------------- Serie de la factura.
      dbMuestrad.FieldByName('FD3').Value:=NOPERACION;//---------------- N. Factura.
      dbMuestrad.FieldByName('FD4').Value:=VerUltimaLineaF;//------------ N. Linea
      dbMuestrad.FieldByName('FD5').AsString:=dbVentas.FieldByName('V3').AsString;//--- C. Articulo
      dbMuestrad.FieldByName('FD6').AsString:=dbVentas.FieldByName('V4').AsString;//--- Descripcion
      dbMuestrad.FieldByName('FD7').Value:=dbVentas.FieldByName('V5').Value;//--------- Unidades
      dbMuestrad.FieldByName('FD8').Value:=dbVentas.FieldByName('V6').Value;//--------- P.V.P.
      dbMuestrad.FieldByName('FD9').Value:=dbVentas.FieldByName('V7').Value;//--------- Precio
      dbMuestrad.FieldByName('FD10').Value:=dbVentas.FieldByName('V8').Value;//-------- Dto.
      dbMuestrad.FieldByName('FD11').Value:=dbVentas.FieldByName('V9').Value;//-------- Importe
      dbMuestrad.FieldByName('FD12').Value:=dbVentas.FieldByName('V10').Value;//------- IVA
      dbMuestrad.FieldByName('FD13').Value:=dbVentas.FieldByName('V11').Value;//------- Total
      //dbMuestrad.FieldByName('FD14').Value:='';//-------- Cgo. Talla/Color
      dbMuestrad.FieldByName('FD15').Value:='A';//------- Tipo de linea
      //dbMuestrad.FieldByName('FD16').Value:='';//-------- Observaciones del albaran
      try
        dbMuestrad.Post;
      except
        on EDB: EDatabaseError do
        begin
          Showmessage('Error : ' + EDB.Message);
        end;
      end;
      dbVentas.Next;
    end;
  dbTrabajo.Active:=False;
  //--------------- Cabecera de Factura
  dbTrabajo.SQL.Text:='SELECT * FROM factuc'+Tienda+' WHERE FC0='+Edit1.Text+
  ' AND FC1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'"'+
  ' AND FC2="'+SERIEFACT+'" AND FC3='+IntToStr(NOPERACION);
  dbTrabajo.Active:=True;
  dbtrabajo.Append;
  dbtrabajo.FieldByName('FC0').AsString:=Edit1.Text; //-------------- Cliente.
  dbtrabajo.FieldByName('FC1').Value:=StrToDate(Edit22.Text); //----- Fecha Factura.
  dbtrabajo.FieldByName('FC2').Value:=SERIEFACT; //------------------- Serie de la factura.
  dbtrabajo.FieldByName('FC3').Value:=NOPERACION; //------------------- N. Factura.
  dbtrabajo.FieldByName('FC4').Value:=dbMuestrad.RecordCount;//------ N. Lineas
  dbtrabajo.FieldByName('FC5').Value:=ToTArti;//--------------------- N. Articulos
  dbtrabajo.FieldByName('FC6').Value:=0;//--------------------------- Dto. pronto pago
  dbtrabajo.FieldByName('FC7').Value:=dbClientes.Fields[19].AsString;//-- Recargo S/N
  dbtrabajo.FieldByName('FC8').Value:=TotPrecio;//------------------- Imp. Sin IVA
  dbtrabajo.FieldByName('FC9').Value:=StrToFloat(Edit14.Text);//----- Imp. Con IVA
  dbtrabajo.FieldByName('FC10').Value:='N';//------------------------ Marcada (S/N)
  dbtrabajo.FieldByName('FC19').Value:=Memo1.Lines.Text;//----------- Observaciones
  dbtrabajo.FieldByName('FC20').Value:='N';//------------------------ Fact. Rectif. (S/N)
  dbtrabajo.FieldByName('FC24').Value:=Label21.Caption;//------------- CIF
  try
    dbtrabajo.Post;
  except
    on EDB: EDatabaseError do
    begin
      Showmessage('Error : ' + EDB.Message);
    end;
  end;

  // =================================================
  // === Veri*Factu: Encolar factura (DB/Archivos) ===
  // =================================================
  try
    VeriFactu_QueueFactura(
      SERIEFACT,
      NOPERACION,
      StrToDate(Edit22.Text),
      HoraVenta,
      StrToFloat(Edit14.Text)
    );
  except
  end;
  // =================================================

  //----------------------
  ActualizaHisto();//--------- Actualizar Hist. Operaciones Cabeceras
//  if Combo2.Text='TARJETA+CONTADO' then CajaTarjetas();//----- Apuntar tarjetas a las cajas
  if ( Combo2.ItemIndex < 7 ) and ( Combo2.ItemIndex > 0 ) then CajaTarjetas(); //----- Apuntar tarjetas a las cajas
  if Combo2.Text='PUNTOS ACUMULADOS' then CajaPuntos();//----- Apuntar puntos a las cajas
  if StrToFloat(Edit16.Text)<0 then ApuntaCredito();//--- Apuntar a credito
  if OperacionRecuperada='P' then Actualizapedido();//--- Actualizar pedido
  if OperacionRecuperada='PRE' then Actualizaprepro();//- Actualizar presup./profoema

   // Recargamos las consultas para imprimir.
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM factuc'+Tienda+' WHERE FC0='+Edit1.Text+
  ' AND FC1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'"'+
  ' AND FC2="'+SERIEFACT+'" AND FC3='+IntToStr(NOPERACION);
  dbTrabajo.Active:=True;
  dbMuestrad.Active:=False;
  dbMuestrad.SQL.Text:='SELECT * FROM factud'+Tienda+' WHERE FD0='+Edit1.Text+
  ' AND FD1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'" AND FD2="'+SERIEFACT+'"'+
  ' AND FD3='+IntToStr(NOPERACION);
  dbMuestrad.Active:=True;

   if (cbImprimir.Checked) then
    begin
      EstadoImpresion:=FImpresion.Imprime(dbMuestrad, dbTrabajo, dbClientes, 'FACTURA', cbImpresionDirecta.Checked, StrToInt(edNumeroCopias.Text));

      TxtQ:='';

      if EstadoImpresion=1 then TxtQ:='UPDATE factuc'+Tienda+' SET FC25="S" WHERE FC0='+Edit1.Text+                  //Imprimido
                               ' AND FC1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'"'+
                               ' AND FC2="'+SERIEFACT+'" AND FC3='+IntToStr(NOPERACION);

      if EstadoImpresion=2 then TxtQ:='UPDATE factuc'+Tienda+' SET FC26="S" WHERE FC0='+Edit1.Text+                  //Email
                               ' AND FC1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'"'+
                               ' AND FC2="'+SERIEFACT+'" AND FC3='+IntToStr(NOPERACION);

      if EstadoImpresion=3 then TxtQ:='UPDATE factuc'+Tienda+' SET FC25="S", SET FC26="S" WHERE FC0='+Edit1.Text+                  //Imprimido + email
                               ' AND FC1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'"'+
                               ' AND FC2="'+SERIEFACT+'" AND FC3='+IntToStr(NOPERACION);

      if (TxtQ<>'') then
        begin
            dbTrabajo.SQL.Text:= TxtQ;
          try
            dbTrabajo.ExecSQL;
          except
            on EDB: EZSQLException do showmessage( 'Error al actualizar tabla de cabeceras de Facturas ( Imprimido ) : '+ EDB.Message);
          end;

        end;

    end;

   // Factura PAGADA si el total = entrega + contado - cambio y no hay crédito.

  if ( StrToFloat(Edit14.Text) = StrToFloat(Edit15.Text) + StrToFloat(Edit42.Text) - StrToFloat(Edit16.Text) )
       and ( StrToFloat(Edit16.Text) >= 0 ) then
     begin
        TxtQ:='UPDATE factuc'+Tienda+' SET FC23="S" WHERE FC0='+Edit1.Text+                               //Pagado
                            ' AND FC1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'"'+
                            ' AND FC2="'+SERIEFACT+'" AND FC3='+IntToStr(NOPERACION);
        dbTrabajo.SQL.Text:= TxtQ;
        try
           dbTrabajo.ExecSQL;
        except
           on EDB: EZSQLException do showmessage( 'Error al actualizar tabla de cabeceras de Facturas ( Pago ) : '+ EDB.Message);
        end;

     end;

  BitBtn9Click(BitBtn9);//----- Ocultar panel totalizar
  BitBtn15Click(BitBtn15, false);//--- Borrar todas las lineas de venta
  dbVentas.Refresh; Edit1.Text:=ClienteVario; Edit1Exit(Edit1);
  PintarTotalGeneral(); RefrescaTicketsAbiertos();
  if dbVentas.RecordCount<>0 then CambiarTicket();
  OperacionRecuperada:='N'; Edit3.SetFocus;
  BitBtn24Click(BitBtn24);
end;

//=================== SACAR EL ULT N. DE LINEA =====================
function TFVentas.VerUltimaLineaF: Integer;
begin
  VerUltimaLineaF:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(FD4) As ULTIMA FROM factud'+Tienda+' WHERE FD0='+Edit1.Text+
  ' AND FD1="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit22.Text))+'" AND FD2="'+SERIEFACT+'"'+
  ' AND FD3='+IntToStr(NOPERACION);
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLineaF:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;

//---------------- Cancelar nueva factura ----------------
procedure TFVentas.BitBtn20Click(Sender: TObject);
begin
  Panel8.Visible:=False; Panel4.Enabled:=True;
  Panel1.Enabled:=True;
end;


//=====================================================================
//==================== CARGAR TOTALES PARA IMPRESION ==================
//=====================================================================
procedure TFVentas.CargarTotales();
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

//=============== Pasar parametros a los reports de facturas / albaranes =======
procedure TFVentas.frReport1GetValue(const ParName: String;
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

  if ParName='REGISTRO' then ParValue := REGISTRO;
  if ParName='CCODIGO' then ParValue := dbClientes.FieldByName('C0').AsString;

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
procedure TFVentas.frReport1EnterRect(Memo: TStringList; View: TfrView);
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

//----------- Pasar parametros al report de tickets ------
procedure TFVentas.frReport2GetValue(const ParName: String;
  var ParValue: Variant);
begin
  if ParName='EMPRESA' then ParValue := Empresa;
  if ParName='DIRECCION' then ParValue := Direccion;
  if ParName='LOCALIDAD' then ParValue := Localidad;
  if ParName='CP' then ParValue := CP;
  if ParName='PROVINCIA' then ParValue := Provincia;
  if ParName='CIF' then ParValue := Nif;
  if ParName='CCLIENTE' then ParValue := dbClientes.FieldByName('C1').AsString;
  if ParName='CDIRECCION' then ParValue := dbClientes.FieldByName('C3').AsString;
  if ParName='CLOCALIDAD' then ParValue := dbClientes.FieldByName('C4').AsString;
  if ParName='CCIF' then ParValue := dbClientes.FieldByName('C5').AsString;
  if ParName='CCP' then ParValue := dbClientes.FieldByName('C37').AsString;
  if ParName='CPROVINCIA' then ParValue := dbClientes.FieldByName('C38').AsString;
  if ParName='TOTAL' then ParValue := StaticText1.Caption;
end;

//=================== BOTON LOPD ================
procedure TFVentas.frReport3GetValue(const ParName: String;
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
   if ParName='CCODIGO' then ParValue := Edit1.Text;
   if ParName='CNOMBRE' then ParValue := Edit29.Text;
   if ParName='CDOMICILIO' then ParValue := Edit31.Text;
   if ParName='CLOCALIDAD' then ParValue := Edit32.Text;
   if ParName='CCP' then ParValue := Edit37.Text;
   if ParName='CPROVINCIA' then ParValue := Edit38.Text;
   if ParName='CNIF' then ParValue := Edit39.Text;
   if ParName='CTELEFONO' then ParValue := Edit40.Text;
end;


procedure TFVentas.BitBtn39Click(Sender: TObject);
begin
     TituloGrid:='LOPD - Toma de datos de Cliente';
     frReport3.LoadFromFile(RutaReports+'LopdNClientes.lrf');
     frReport3.ShowReport;
end;

//===========================================================
//================= ACTUALIZAR DATOS ========================
//===========================================================

//--------------------------------------------------------
//================== GRABAR IVA DE VENTAS ================
//--------------------------------------------------------

Procedure TFVentas.ActualizaIva();
var
  TxtQ, Departa: String;
  Base, Iva, TIva : String;
begin
  //-- showmessage(TIPOOPER);
  //-- IF TIPOOPER='FA' then showmessage('OJO, UNA FACTURA');
  if TIPOOPER='AL' then exit;
  //------------------- Control de Iva    (Id,Fecha, Hora,TIPOOPER,Puesto,Cliente,Operacion;Serie Factura, Base, iva, tipo de iva, total)

  TIva:=dbVentas.FieldByName('V10').AsString;
  Base:=FloatToStr(StrToFloat(dbVentas.FieldByName('V11').AsString)/(1+(StrToFloat(dbVentas.FieldByName('V10').AsString)/100)));
  Iva:=FloatToStr(StrToFloat(Base)*(StrToFloat(TIva)/100));
  TxtQ:='INSERT INTO iva'+Tienda+' (Fecha,Hora,TipoOP,Puesto,Cliente,Operacion,Serie,Base,Iva,TIva,Total) VALUES ("'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'",'+
        '"'+FormatDateTime('HH:MM:SS',HoraVenta)+'","'+TIPOOPER+'","'+Puesto+'","'+dbVentas.FieldByName('V12').AsString+'",'+IntToStr(NOPERACION)+',"'+SERIEFACT+
        '",'+Base+','+Iva+','+dbVentas.FieldByName('V10').AsString+','+dbVentas.FieldByName('V11').AsString+')';
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


procedure TFVentas.ActualizaDatos();
var
  Codigo, TxtQ, Departa: String;
  Cantidad, Costo, Precio: String;
begin
  Codigo:=dbVentas.FieldByName('V3').AsString;//-------- Cgo Articulo
  Cantidad:=dbVentas.FieldByName('V5').AsString;//------ Unidades
  Precio:=dbVentas.FieldByName('V9').AsString;//-------- Importe de la linea sin iva
  DESCRIOPER:=DESCRIOPER+Copy(dbVentas.FieldByName('V4').AsString,1,15)+', ';//---- Descripcion del ticket

   // Comprobamos si el código es un auxiliar o un código de artículo.
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Codigo+'"';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then
    begin
       dbTrabajo.Active:=False;
       dbTrabajo.SQL.Text:='SELECT * FROM eans WHERE EAN0="'+Codigo+'"';
       dbTrabajo.Active:=True;
       if (dbTrabajo.RecordCount<>0) then Codigo:=dbTrabajo.FieldByName('EAN1').AsString;
    end;

  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Codigo+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount=0 then Costo:='0' else Costo:=dbArti.FieldByName('A24').AsString;
  Costo:=FloatToStr(StrToFloat(Cantidad)*StrToFloat(Costo));//--- Costo de la linea sin iva.
  //---------------------------------------------------------------
  //---------------------------------------------------------------
  //---------------------------------------------------------------
  //------------------- Articulos
  TxtQ:='UPDATE artitien'+Tienda+' SET A12="'+FormatDateTime('YYYY/MM/DD',Date)+'"'+
        ', A4=A4-('+Cantidad+') WHERE A0="'+Codigo+'"';
  dbTrabajo.SQL.Text:=TxtQ;
  try
    dbTrabajo.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado al actualizar Articulos : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
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
  dbTrabajo.SQL.Text:=TxtQ;
  try
    dbTrabajo.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado al actualizar Estadisticas Articulos : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
  //------------------- Clientes, si hay credito grabar "pendiente de facturar"
  //-- ACTUALIZAR CREDITOS EN CUENTA DE CLIENTE
  if (StrToFloat(Edit16.Text)<0) then
    begin
     TxtQ:='UPDATE clientes SET C20=C20+('+Edit16.Text+') WHERE C0="'+Edit1.Text+'"';
     dbTrabajo.SQL.Text:=TxtQ;
     try
       dbTrabajo.ExecSQL;
     except
      // Capturamos el error específico de la capa de datos
       on EDB: EZSQLException do
       begin
         // El mensaje de EDB contendrá el mensaje de error de MariaDB
         ShowMessage('Error de Base de Datos Inesperado al actualizar Clientes : ' + EDB.Message);
         // La aplicación sigue desde aquí.
       end;
     end;
    end;
  //------------------- Estadistica de Clientes
  dbTrabajo.SQL.Text:='SELECT * from estaclie WHERE CC0="'+Edit1.Text+'"'+
                     ' AND CC1='+FormatDateTime('YYYY',Date)+' AND CC2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estaclie SET CC5=CC5+'+Cantidad+
          ', CC6=CC6+'+Precio+', CC7=CC7+'+Costo+' WHERE CC0="'+Edit1.Text+'"'+
          ' AND CC1='+FormatDateTime('YYYY',Date)+' AND CC2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estaclie (CC0,CC1,CC2,CC5,CC6,CC7) VALUES ("'+
          Edit1.Text+'",'+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+Cantidad+','+Precio+','+Costo+')';
  dbTrabajo.SQL.Text:=TxtQ;
  try
    dbTrabajo.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado al Insertar Estadisticas de Clientes : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
  //------------------- Historico de compras de clientes
  TxtQ:='INSERT INTO histoclie (HC0,HC1,HC2,HC3,HC4,HC5,HC6,HC7,HC8,HC9) VALUES ("'+
        Edit1.Text+'","'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'","'+
        FormatDateTime('HH:MM:SS',HoraVenta)+'",'+dbVentas.FieldByName('V2').AsString+
        ',"'+Codigo+'","'+dbVentas.FieldByName('V4').AsString+
        '",'+Cantidad+','+dbVentas.FieldByName('V11').AsString+',"VN",'+
        dbVentas.FieldByName('V1').AsString+')';
  dbTrabajo.SQL.Text:=TxtQ;
  try
    dbTrabajo.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado al Insertar Historial de Clientes : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
  //------------------- Tiendas
  TxtQ:='UPDATE tiendas SET T9="'+FormatDateTime('YYYY/MM/DD',Date)+'" WHERE T0='+NTienda;
  dbTrabajo.SQL.Text:=TxtQ;
  try
    dbTrabajo.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado al actualizar Tiendas : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
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
  dbTrabajo.SQL.Text:=TxtQ;
  try
    dbTrabajo.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado al actualizar Estadiscicas de Tiendas : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
  //------------------- Estadistica de usuarios
  dbTrabajo.SQL.Text:='SELECT * from estausu'+Tienda+' WHERE TUSU0='+Dispensador+
                      ' AND TUSU1='+FormatDateTime('YYYY',Date)+' AND TUSU2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estausu'+Tienda+' SET TUSU5=TUSU5+'+Cantidad+
          ', TUSU6=TUSU6+'+Precio+', TUSU7=TUSU7+'+Costo+' WHERE TUSU0='+Dispensador+
          ' AND TUSU1='+FormatDateTime('YYYY',Date)+' AND TUSU2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estausu'+Tienda+' (TUSU0,TUSU1,TUSU2,TUSU5,TUSU6,TUSU7) VALUES ('+Dispensador+
          ','+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+Cantidad+','+Precio+','+Costo+')';
  dbTrabajo.SQL.Text:=TxtQ;
  try
    dbTrabajo.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado al actualizar Estadisticas Usuarios : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
  //------------------- Historico de operaciones detalles
  TxtQ:='INSERT INTO hisopdd'+Tienda+' (HOD0,HOD1,HOD2,HOD3,HOD4,HOD5,HOD6,HOD7,HOD8,HOD9,HOD10,HOD11'+
        ',HOD12,HOD13,HOD14,HOD15,HOD16) VALUES ("'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'",'+
        '"'+FormatDateTime('HH:MM:SS',HoraVenta)+'","'+Puesto+'",'+IntToStr(NOPERACION)+',"'+SERIEFACT+
        '",'+dbVentas.FieldByName('V2').AsString+',"'+
        Codigo+'","'+dbVentas.FieldByName('V4').AsString+'",'+Cantidad+','+
        dbVentas.FieldByName('V6').AsString+','+dbVentas.FieldByName('V7').AsString+','+
        dbVentas.FieldByName('V8').AsString+','+dbVentas.FieldByName('V9').AsString+','+
        dbVentas.FieldByName('V10').AsString+','+dbVentas.FieldByName('V11').AsString+',"","A")';
//TODO: Hay que poner tipo de linea ¿A=Articulo, L=Lote, etc?
  dbTrabajo.SQL.Text:=TxtQ;
  try
    dbTrabajo.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado al Insertar Lineas de Historicos OP : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
  //------------------- Detalle de Puntos --------------- (TPuntos,CalPuntos),Tempocaso:String;
if Combo2.Text='PUNTOS ACUMULADOS' then
else
Begin
If StrToFloat(Edit16.Text)<0 then
else
 Begin
//--- CONTROL      TxtQ:='SELECT * from clientes WHERE C0="'+Edit1.Text+'"';
//--- CONTROL      dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  If ((Global.APuntos='S') and (dbClientes.FieldByName('C49').AsString='S')) then
   begin
    Tempocaso := dbArti.FieldByName('A35').AsString;
    if Tempocaso='' then TempoCaso:='0';
    if Tempocaso<>'0' then
     begin
       case StrToInt(Tempocaso) of
        1: TPuntos:= FloatToStr( StrToFloat( dbVentas.FieldByName('V11').AsString ) * ( StrToFloat( Global.Porcentaje ) / 100) );
        2: TPuntos:= FloatToStr( StrToFloat( dbVentas.FieldByName('V11').AsString ) * ( StrToFloat( Global.Porcentaje ) / 100) + ( StrToFloat( dbVentas.FieldByName('V11').AsString ) * ( StrToFloat( Global.Extra ) / 100 ) ) );
        3: TPuntos:= FloatToStr( ( StrToFloat( dbVentas.FieldByName('V11').AsString ) * ( StrToFloat( Global.Porcentaje ) / 100) ) + ( StrToFloat( dbVentas.FieldByName('V11').AsString ) * ( StrToFloat( Global.Extra ) / 100 ) ) +  StrToFloat( Global.Especial ) );
        4: TPuntos:= Global.Especial;
        else TPuntos:='0';
       end;
//--- CONTROL       showmessage(TPuntos);
       if StrToFloat(dbVentas.FieldByName('V2').AsString)>1 then
        Begin
            CalPuntos:= FloatToStr( StrToFloat( CalPuntos ) + StrToFloat( TPuntos ) );
        end
       else
        Begin
             CalPuntos:= FloatToStr( StrToFloat( dbClientes.FieldByName('C50').AsString ) + StrToFloat( TPuntos ) );
        end;
//--- CONTROL       showmessage(CalPuntos);
       TxtQ:='INSERT INTO puntos (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10) VALUES ("'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'",'+
             '"'+FormatDateTime('HH:MM:SS',HoraVenta)+'","'+Puesto+'","'+dbVentas.FieldByName('V12').AsString+
             '","'+IntToStr(NOPERACION)+'","'+dbVentas.FieldByName('V2').AsString+'","'+Codigo+
             '","'+dbVentas.FieldByName('V4').AsString+'","'+dbArti.FieldByName('A35').AsString+'","'+
             TPuntos+'","'+CalPuntos+'")';
     //TODO: Hay que poner tipo de linea ¿A=Articulo, L=Lote, etc?
//--- CONTROL       showmessage(TxtQ);
       dbTrabajo.SQL.Text:=TxtQ;
       try
         dbTrabajo.ExecSQL;
       except
        // Capturamos el error específico de la capa de datos
         on EDB: EZSQLException do
         begin
           // El mensaje de EDB contendrá el mensaje de error de MariaDB
           ShowMessage('Error de Base de Datos Inesperado al Insertar Puntos : ' + EDB.Message);
           // La aplicación sigue desde aquí.
         end;
       end;
       TxtQ:='UPDATE clientes SET C50=' + CalPuntos +' WHERE C0="'+Edit1.Text+'"';
       dbTrabajo.SQL.Text:=TxtQ;
       try
          dbTrabajo.ExecSQL;
       except
        // Capturamos el error específico de la capa de datos
         on EDB: EZSQLException do
         begin
           // El mensaje de EDB contendrá el mensaje de error de MariaDB
           ShowMessage('Error de Base de Datos Inesperado al actualizar Clientes : ' + EDB.Message);
           // La aplicación sigue desde aquí.
         end;
       end;
     end;
   end;
 end;
 end;

  //------------------- Proveedores
  if dbArti.FieldByName('A32').AsString<>'' then
    begin
     dbTrabajo.SQL.Text:='SELECT * from proveedores WHERE P0='+dbArti.FieldByName('A32').AsString;
     dbTrabajo.Active:=True;
     if dbTrabajo.RecordCount<>0 then
       begin
         TxtQ:='UPDATE proveedores SET P22="'+FormatDateTime('YYYY/MM/DD',Date)+
               '" WHERE P0='+dbArti.FieldByName('A32').AsString;
         dbTrabajo.SQL.Text:=TxtQ;
         try
           dbTrabajo.ExecSQL;
         except
          // Capturamos el error específico de la capa de datos
           on EDB: EZSQLException do
           begin
             // El mensaje de EDB contendrá el mensaje de error de MariaDB
             ShowMessage('Error de Base de Datos Inesperado al actualizar Proveedores : ' + EDB.Message);
             // La aplicación sigue desde aquí.
           end;
         end;
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
         dbTrabajo.SQL.Text:=TxtQ;
         try
           dbTrabajo.ExecSQL;
         except
          // Capturamos el error específico de la capa de datos
           on EDB: EZSQLException do
           begin
             // El mensaje de EDB contendrá el mensaje de error de MariaDB
             ShowMessage('Error de Base de Datos Inesperado al actualizar Estadisticas Proveedores : ' + EDB.Message);
             // La aplicación sigue desde aquí.
           end;
         end;
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
          dbTrabajo.SQL.Text:=TxtQ;
          try
            dbTrabajo.ExecSQL;
          except
           // Capturamos el error específico de la capa de datos
            on EDB: EZSQLException do
            begin
              // El mensaje de EDB contendrá el mensaje de error de MariaDB
              ShowMessage('Error de Base de Datos Inesperado al actualizar Familias : ' + EDB.Message);
              // La aplicación sigue desde aquí.
            end;
          end;
          //------ Departamentos
          if Departa<>'' then
            begin
              dbTrabajo.SQL.Text:='SELECT * from departamentos'+Tienda+' WHERE D0='+Departa;
              dbTrabajo.Active:=True;
              if dbTrabajo.RecordCount<>0 then
                 begin
                   TxtQ:='UPDATE departamentos'+Tienda+' SET D2="'+FormatDateTime('YYYY/MM/DD',Date)+
                      '" WHERE D0='+Departa;
                   dbTrabajo.SQL.Text:=TxtQ;
                   try
                     dbTrabajo.ExecSQL;
                   except
                    // Capturamos el error específico de la capa de datos
                     on EDB: EZSQLException do
                     begin
                       // El mensaje de EDB contendrá el mensaje de error de MariaDB
                       ShowMessage('Error de Base de Datos Inesperado al actualizar Departamentos : ' + EDB.Message);
                       // La aplicación sigue desde aquí.
                     end;
                   end;
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
          dbTrabajo.SQL.Text:=TxtQ;
          try
            dbTrabajo.ExecSQL;
          except
           // Capturamos el error específico de la capa de datos
            on EDB: EZSQLException do
            begin
              // El mensaje de EDB contendrá el mensaje de error de MariaDB
              ShowMessage('Error de Base de Datos Inesperado Estadisticas Familias : ' + EDB.Message);
              // La aplicación sigue desde aquí.
            end;
          end;
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
             dbTrabajo.SQL.Text:=TxtQ;
             try
               dbTrabajo.ExecSQL;
             except
              // Capturamos el error específico de la capa de datos
               on EDB: EZSQLException do
               begin
                 // El mensaje de EDB contendrá el mensaje de error de MariaDB
                 ShowMessage('Error de Base de Datos Inesperado Estadisticas Departamentos : ' + EDB.Message);
                 // La aplicación sigue desde aquí.
               end;
             end;
            end;
        end;
    end;
  //====================== GRABAR CAJAS DIARIAS ==================
  TxtQ:='SELECT * FROM cajas'+Tienda+' WHERE CA0="'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'"'+
        ' AND CA1="'+Dispensador+'" AND CA2="'+Puesto+'"'+
        ' AND CA3='+dbArti.FieldByName('A14').AsString;
  dbCajas.Active:=False; dbCajas.Sql.Text:=TxtQ; dbCajas.Active := True;
  if dbCajas.Recordcount=0 then dbCajas.Append else dbCajas.edit;
  dbCajas.FieldByName('CA0').AsString := FormatDateTime('DD/MM/YY',FechaVenta); //-- Fecha Caja
  dbCajas.FieldByName('CA1').AsString := Dispensador; //---------------------------- Dispensador
  dbCajas.FieldByName('CA2').AsString := Puesto; //--------------------------------- Puesto
  dbCajas.FieldByName('CA3').AsString := dbArti.FieldByName('A14').AsString; //----- Familia
  //----- Vendidas ó Und. Devueltas----------
  if dbVentas.FieldByName('V5').AsFloat>=0 then
     begin
       dbCajas.FieldByName('CA4').Value:=dbCajas.FieldByName('CA4').AsFloat+
                                         dbVentas.FieldByName('V5').AsFloat; //--- Und. Vend.
       dbCajas.FieldByName('CA5').Value:=dbCajas.FieldByName('CA5').AsFloat+
                                         dbVentas.FieldByName('V11').AsFloat;//--- Imp. Vend.
     end
  else
     begin
       dbCajas.FieldByName('CA6').Value:=dbCajas.FieldByName('CA6').AsFloat+
                                         dbVentas.FieldByName('V5').AsFloat; //--- Und. Devueltas
       dbCajas.FieldByName('CA7').Value:=dbCajas.FieldByName('CA7').AsFloat+
                                         dbVentas.FieldByName('V11').AsFloat;//--- Imp. Devueltas
     end;
  dbCajas.FieldByName('CA8').Value := dbCajas.FieldByName('CA8').AsFloat + StrToFloat(Costo);// --- Imp. Vendido al Costo
  //------------------ Beneficio
  dbCajas.FieldByName('CA15').Value := dbCajas.FieldByName('CA5').AsFloat + dbCajas.FieldByName('CA7').AsFloat - dbCajas.FieldByName('CA8').AsFloat; //---- Beneficio
  //------------------ Descuentos en lineas
  //dbCajas.Filds[24].Value := dbCajas.Fields[24].AsFloat + (dbVentas.Fields[6].AsFloat*dbVentas.Fields[7].AsFloat)-dbVentas.Fields[9].AsFloat; //---- Descuento en lineas.
  try
    dbCajas.Post;
  except
    on EDB: EDatabaseError do
    begin
      Showmessage('Error : ' + EDB.Message);
    end;
  end;

  //---------------------------------
  dbArti.Active:=False;
end;

//=================== GRABAR HIST. OPER. CABECERAS ================
procedure TFVentas.ActualizaHisto();
var
  TxtQ, IMPO1, IMPO2: String;
begin
  //-------------------------------------------------
  TxtQ:='INSERT INTO hisopcc'+Tienda+' (HO0,HO1,HO2,HO3,HO4,HO5,HO6,HO7,HO8,HO9,HO10,HO11'+
        ',HO12,HO13,HO14,HO15,HO19) VALUES ("'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'",'+
        '"'+FormatDateTime('HH:MM:SS',HoraVenta)+'","'+Puesto+'",'+IntToStr(NOPERACION)+',"'+SERIEFACT+'"'+
        ',"'+TIPOOPER+'","'+Copy(Combo2.Text,1,10)+'",'+Dispensador+','+Edit1.Text+','+
        Edit12.Text+','+Edit13.Text+','+Edit14.Text+','+
        Edit15.Text+','+Edit16.Text+','+Edit42.Text+',"N","'+Label21.Caption+'")';
  dbTrabajo.SQL.Text:=TxtQ;
  try
    dbTrabajo.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado Cabeceras de Historicos : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
end;

//=====================================================================
//========================== CREDITOS =================================
//=====================================================================
procedure TFVentas.ApuntaCredito();
var
  TxtQ, Debe, Haber: String;
begin
{ Edit14--- Total
  Edit15--- Entrega
  Edit16--- Cambio}
  //----------------- Si el total es positivo
  if StrToFloat(Edit14.Text)>0 then
    begin
     Debe:=FloatToStr(StrToFloat(Edit16.Text)*-1);
     Haber:='0';
    end
  else
    begin
     Debe:='0';
     Haber:=Edit16.Text;
    end;
  //------------------- Creditos cabeceras
  TxtQ:='INSERT INTO creditos'+Tienda+' (CRE0,CRE1,CRE2,CRE3,CRE4,CRE5,CRE6,CRE7,CRE8,CRE9,CRE10,CRE11,CRE12,'+
        'CRE13,CRE14,CRE15,CRE16,CRE17,CRE18,CRE21) '+
        'VALUES ('+Edit1.Text+',"'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'",'+
        '"'+FormatDateTime('HH:MM:SS',HoraVenta)+'","'+TIPOOPER+'","'+SERIEFACT+'",'+IntToStr(NOPERACION)+
        ',"'+Copy(DESCRIOPER,1,100)+'",'+Debe+','+Haber+',"N",'+Dispensador+',"'+Puesto+'","'+Copy(Combo2.Text,1,10)+'"'+
        ','+Edit12.Text+','+Edit13.Text+','+Edit14.Text+','+
        Edit15.Text+','+Edit16.Text+',0,"'+Memo1.Lines.Text+'")';
  dbTrabajo.SQL.Text:=TxtQ;
  try
    dbTrabajo.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado Insertando Creditos : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
  //------------------- Creditos detalles
  dbVentas.First;
  while not dbVentas.EOF do
    begin
      TxtQ:='INSERT INTO creditosdd'+Tienda+' (CRED0,CRED1,CRED2,CRED3,CRED4,CRED5,CRED6,CRED7,CRED8,CRED9,CRED10,CRED11'+
        ',CRED12,CRED13,CRED14,CRED15,CRED16,CRED17) VALUES ('+Edit1.Text+',"'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'",'+
        '"'+FormatDateTime('HH:MM:SS',HoraVenta)+'","'+SERIEFACT+'",'+IntToStr(NOPERACION)+
        ','+dbVentas.FieldByName('V2').AsString+',"'+
        dbVentas.FieldByName('V3').AsString+'","'+dbVentas.FieldByName('V4').AsString+'",'+
        dbVentas.FieldByName('V5').AsString+','+dbVentas.FieldByName('V6').AsString+','+
        dbVentas.FieldByName('V7').AsString+','+dbVentas.FieldByName('V8').AsString+','+
        dbVentas.FieldByName('V9').AsString+','+dbVentas.FieldByName('V10').AsString+','+
        dbVentas.FieldByName('V11').AsString+',"","A","N")';
//TODO: Hay que poner tipo de linea ¿A=Articulo, L=Lote, etc?
      dbTrabajo.SQL.Text:=TxtQ;
      try
        dbTrabajo.ExecSQL;
      except
       // Capturamos el error específico de la capa de datos
        on EDB: EZSQLException do
        begin
          // El mensaje de EDB contendrá el mensaje de error de MariaDB
          ShowMessage('Error de Base de Datos Inesperado Insertando Detalles Creditos : ' + EDB.Message);
          // La aplicación sigue desde aquí.
        end;
      end;
      dbVentas.Next;
    end;

  //====================== GRABAR CAJAS DIARIAS ==================
  TxtQ:='SELECT * FROM cajas'+Tienda+' WHERE CA0="'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'"'+
        ' AND CA1='+Dispensador+' AND CA2="'+Puesto+'"'+' AND CA3=9999';
  dbCajas.Active:=False; dbCajas.Sql.Text:=TxtQ; dbCajas.Active := True;
  if dbCajas.Recordcount=0 then dbCajas.Append else dbCajas.edit;
  dbCajas.FieldByName('CA0').AsString := FormatDateTime('DD/MM/YY',FechaVenta); //---- Fecha Caja
  dbCajas.FieldByName('CA1').AsString := Dispensador; //------------ Usuario/Vendedor
  dbCajas.FieldByName('CA2').AsString := Puesto; //--------- Puesto
  dbCajas.FieldByName('CA3').AsString := '9999'; //--------- Familia
  //----- Importe credito ----------
  if TIPOOPER='AL' then dbCajas.FieldByName('CA11').Value := dbCajas.FieldByName('CA11').AsFloat+1;
  dbCajas.FieldByName('CA20').Value := dbCajas.FieldByName('CA20').AsFloat + StrToFloat(Debe);// --- Imp. creditos
  try
    dbCajas.Post;
  except
    on EDB: EDatabaseError do
    begin
      Showmessage('Error : ' + EDB.Message);
    end;
  end;
end;

//---------------- PINTAR EL CREDITO PENDIENTE ------------------
procedure TFVentas.VerSiTieneCredito();
begin
  Label55.Caption:='0.00';
  dbTrabajo.SQL.Text:='SELECT SUM(CRE7)-SUM(CRE8) FROM creditos'+Tienda+' WHERE CRE0='+Edit1.Text;
  dbTrabajo.Active:=True;
  if (dbTrabajo.RecordCount=0) or (dbTrabajo.Fields[0].AsFloat=0) then
     begin dbTrabajo.Active:=False; exit; end;
  if dbTrabajo.Fields[0].AsFloat<0 then Label56.Caption:='Saldo a su favor'
  else Label56.Caption:='Crédito pendiente';
  Label55.Caption:=FormatFloat('0.00',dbTrabajo.Fields[0].AsFloat);
  PanelCredito.Visible:=True; dbTrabajo.Active:=False;
end;
procedure TFVentas.Button1Click(Sender: TObject);
begin
  PanelCredito.Visible:=False;
end;

//==================== GRABAR CAJAS SI HAY PAGO TARJETA =======================
procedure TFVentas.CajaTarjetas();
var
  TxtQ: String;
begin
  //====================== GRABAR CAJAS DIARIAS ==================
  TxtQ:='SELECT * FROM cajas'+Tienda+' WHERE CA0="'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'"'+
        ' AND CA1='+Dispensador+' AND CA2="'+Puesto+'"'+' AND CA3=9999';
  dbCajas.Active:=False; dbCajas.Sql.Text:=TxtQ; dbCajas.Active := True;
  if dbCajas.Recordcount=0 then dbCajas.Append else dbCajas.edit;
  dbCajas.FieldByName('CA0').AsString := FormatDateTime('DD/MM/YY',FechaVenta); //---- Fecha Caja
  dbCajas.FieldByName('CA1').AsString := Dispensador; //------------ Usuario/Vendedor
  dbCajas.FieldByName('CA2').AsString := Puesto; //--------- Puesto
  dbCajas.FieldByName('CA3').AsString := '9999'; //--------- Familia
  //----- Importe credito ----------
  dbCajas.FieldByName('CA13').Value := dbCajas.FieldByName('CA13').AsFloat + 1;// --- N. Tarjetas
  if (Combo2.Text='TARJETA+CONTADO') or (Combo2.Text='PUNTOS ACUMULADOS') then
    begin
      //--- MARCADOR TARJETAS + CONTADO -- AJUSTES DE CAJA
      dbCajas.FieldByName('CA14').Value := dbCajas.FieldByName('CA14').AsFloat + StrToFloat(Edit15.Text);// --- Imp. Tarjetas
    end
  else
    begin
      dbCajas.FieldByName('CA14').Value := dbCajas.FieldByName('CA14').AsFloat + StrToFloat(Edit14.Text);// --- Imp. Tarjetas
    end;
  try
    dbCajas.Post;
  except
    on EDB: EDatabaseError do
    begin
      Showmessage('Error : ' + EDB.Message);
    end;
  end;
end;

//==================== GRABAR CAJAS SI HAY PAGO PUNTOS =======================
procedure TFVentas.CajaPuntos();
var
  TxtQ: String;
begin
  //====================== GRABAR CAJAS DIARIAS ==================
  TxtQ:='SELECT * FROM cajas'+Tienda+' WHERE CA0="'+FormatDateTime('YYYY/MM/DD',FechaVenta)+'"'+
        ' AND CA1='+Dispensador+' AND CA2="'+Puesto+'"'+' AND CA3=9999';
  dbCajas.Active:=False; dbCajas.Sql.Text:=TxtQ; dbCajas.Active := True;
  if dbCajas.Recordcount=0 then dbCajas.Append else dbCajas.edit;
  dbCajas.FieldByName('CA0').AsString := FormatDateTime('DD/MM/YY',FechaVenta); //---- Fecha Caja
  dbCajas.FieldByName('CA1').AsString := Dispensador; //------------ Usuario/Vendedor
  dbCajas.FieldByName('CA2').AsString := Puesto; //--------- Puesto
  dbCajas.FieldByName('CA3').AsString := '9999'; //--------- Familia
  dbCajas.FieldByName('CA27').Value := dbCajas.FieldByName('CA27').AsFloat + StrToFloat(Edit42.Text);// --- Imp. Puntos
  try
    dbCajas.Post;
  except
    on EDB: EDatabaseError do
    begin
      Showmessage('Error : ' + EDB.Message);
    end;
  end;
  //------------------ Restar puntos de fidelizacion ---------------------
  dbClientes.Edit;
  dbClientes.FieldByName('C50').AsFloat:=dbClientes.FieldByName('C50').AsFloat-StrToFloat(Edit42.Text);
  try
    dbClientes.Post;
  except
    on EDB: EDatabaseError do
    begin
      Showmessage('Error : ' + EDB.Message);
    end;
  end;
end;

//=====================================================================
//==================== IMPRIMIR VENTA ACTUAL ==========================
//=====================================================================
procedure TFVentas.BitBtn18Click(Sender: TObject);
begin
  if dbVentas.RecordCount=0 then exit;
  Panel6.Visible:=True;
  Bloquear();//------- Bloquear controles
end;
//----------------- Cancelar imprimir ---------------------
procedure TFVentas.BitBtn26Click(Sender: TObject);
begin
  Panel6.Visible:=False;
  DesBloquear();//------- Desbloquear controles
end;
//----------------- Aceptar imprimir ----------------------
procedure TFVentas.BitBtn25Click(Sender: TObject);
var
  Total: Double;
  Texto: String;
begin
  //--------------- Ticketera
  Total:=0;
  if RadioButton1.Checked=True then;
    begin
     AssignFile(PrintText, DevTicket); //añadido por javi para quitar opendialog
     Rewrite(PrintText);
     CabeceraTicket();

     dbVentas.First;
     while not dbVentas.Eof do
       begin
         Texto:=Copy(dbVentas.Fields[4].AsString+'                    ',1,18)+' ';
         Texto:=Texto + DataModule1.LFill(FormatFloat('##0.00',dbVentas.Fields[5].AsFloat),6,' ') + ' ';
         Texto:=Texto + DataModule1.LFill(FormatFloat('##0.00',dbVentas.Fields[6].AsFloat),6,' ') + ' ';
         Texto:=Texto + DataModule1.LFill(FormatFloat('###0.00',dbVentas.Fields[11].AsFloat),7,' ');
         Total:=Total+dbVentas.Fields[11].AsFloat;
         Writeln(PrintText, Texto);
         dbVentas.Next;
        end;
     Texto:='                                  =======';
     Writeln(PrintText, Texto);
     Texto:=DataModule1.LFill(FormatFloat('###0.00',Total),40,' ');
     Writeln(PrintText, Texto);


      if trim(NegroD)<>'' then
      try
         WriteLn(PrintText, PNegroD);
       except
         raise;
      end;


     Texto:='  --- Info.PRT. --- ';
     Writeln(PrintText, Texto);
     Texto:='  --- ---- ---- --- ';
     Writeln(PrintText, Texto);
     Texto:='- T I C K E T   I N F O R M A T I V O -';
     Writeln(PrintText, Texto);
     Texto:='  --- ---- ---- --- ';
     Writeln(PrintText, Texto);


      if trim(Negro)<>'' then
      try
         WriteLn(PrintText, PNegro);
       except
         raise;
      end;



     PieTicket();
     Corte();
     CloseFile(PrintText);
    end;
  //--------------- Impresora
  if RadioButton2.Checked=True then
    begin
      frDBDataSet2.DataSet:=dbVentas;
      frReport2.LoadFromFile(RutaReports+'Ticket.lrf');
      frReport2.ShowReport;
    end;
end;

//=====================================================================
//================= BORRAR TODAS LAS LINEAS DE VENTAS =================
//=====================================================================
procedure TFVentas.BitBtn15Click(Sender: TObject; lDirecto: boolean);
var
 F : TextFile;
 fichero : string;
 textoaprobacion : string;
 codigo13,descrip50,canti3,precio6, total6 : string;
begin
//============================= KeyLog de Borrado de Ventas ===============================
//-- textoaprobación,codigo13 y descrip50, canti3,precio6,total6 añadidos por el keyloger
 codigo13:='';
 descrip50:='';
 canti3:='';
 precio6:='';
 total6:='';
  if ( lDirecto <> False ) then
    begin
         FLX_Beep(skOk);
         textoaprobacion:=InputBox('Autorizacion para la Eliminacion de Venta completa','Anote el motivo del borrado y pulse ACEPTAR o ENTER','');
         fichero:='';
         if FileExists(RutaIni+'BorraDatos_'+FormatDateTime('YYYYMM',(Date-63))+'.txt' ) then
            begin
               //-- borrado del fichero de hace 63 días
               fichero:=(RutaIni+'BorraDatos_'+FormatDateTime('YYYYMM',(Date-63))+'.txt' );
               DeleteFile(fichero);
            end;
 edit3.SetFocus;
    end;
//============================= KeyLog de Borrado de Ventas ===============================
  if ( lDirecto <> False ) then
    begin
       boxstyle :=  MB_ICONQUESTION + MB_YESNO;
       if Application.MessageBox('¿ BORRAR TODA LA VENTA ?','FacturLinEx', boxstyle) = IDNO Then
            begin
              Edit3.SetFocus;
              Exit;
            end;
    end;

  if dbVentas.RecordCount=0 then exit;
//============================= KeyLog de Borrado de Ventas ===============================
  if ( lDirecto <> False ) then
    begin
         dbTrabajo.Active:=False;
         dbTrabajo.SQL.Text:='SELECT * FROM ventas'+Tienda+Puesto+' WHERE V0=0 AND V1='+TICKET;
         dbTrabajo.Active:=True;
         dbTrabajo.First;
         AssignFile( F, RutaIni + 'BorraDatos_'+FormatDateTime('YYYYMM',Date)+'.txt' );
         if FileExists(RutaIni+'BorraDatos_'+FormatDateTime('YYYYMM',(Date))+'.txt' ) then Append(F) else Rewrite( F );
         WriteLn( F, '#============== VENTA COMPLETA Borrada ================');
         WriteLn( F, '#= AUTORIZACION - '+textoaprobacion);
         WriteLn( F, 'CAJA : ' + Puesto +' - Dia : ' + FormatDateTime('YYYYMMDD',(Date)) + ' - Hora : ' + FormatDateTime('HH:MM:SS',(time)) + ' Cliente : ' + dbTrabajo.FieldByName('V12').Text );
         while not dbTrabajo.EOF do
           begin
             codigo13:=dbTrabajo.FieldByName('V3').Text;
             while Length(codigo13)<14 do codigo13 := codigo13+' ';
             descrip50:=dbTrabajo.FieldByName('V4').Text;
             while Length(descrip50)<51 do descrip50 := descrip50+' ';
             canti3:=dbTrabajo.FieldByName('V5').Text;
             while Length(canti3)<4 do canti3 := ' '+canti3;
             precio6:=FormatFloat('#0.00',dbTrabajo.FieldByName('V6').value);
             while Length(precio6)<7 do precio6 := ' '+precio6;
             total6:=FormatFloat('#0.00',dbTrabajo.FieldByName('V11').value);
             while Length(total6)<7 do total6 := ' '+total6;
             WriteLn( F, ' Venta : ' + dbTrabajo.FieldByName('V1').Text + ' Codigo : ' + codigo13 + ' Descripcion : ' + descrip50 + ' Cantidad : ' + canti3 + ' Precio : ' + precio6 );
             WriteLn( F, ' Total-Linea : ' + total6 + ' Fecha : ' + dbTrabajo.FieldByName('V14').Text + ' Hora : ' + dbTrabajo.FieldByName('V15').Text);
             dbTrabajo.Next;
           end;
         CloseFile( F );
    end;
//============================= KeyLog de Borrado de Ventas ===============================
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='DELETE FROM ventas'+Tienda+Puesto+' WHERE V0=0 AND V1='+TICKET;
  try
    dbTrabajo.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado Eliminando/Limpiando VENTAS : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
  dbVentas.Refresh;
  PintarTotalGeneral();
  RefrescaTicketsAbiertos();
  BitBtn24Click(BitBtn24);
end;

procedure TFVentas.BitBtn16Click(Sender: TObject);
begin
  ShowFormCreditos(Edit1.Text);
end;

//=====================================================================
//=============== CONTROLAR LOS EDIT DE TOTALIZAR =====================
//=====================================================================

//=================== SALIR DEL IMPORTE TOTAL =====================
procedure TFVentas.Edit12Exit(Sender: TObject);
begin
  if (Edit12.Text='') then begin Edit12.Text:='0.00'; exit; end;
  if (Edit13.Text='') or (Edit13.Text='0.00') then
    begin Edit14.Text:=Edit12.Text; Edit15.Text:=Edit12.Text; Exit; end;
  Edit13.Text:=FormatFloat('0.00',StrToFloat(Edit13.Text));
  Edit14.Text := FormatFloat('0.00',(StrToFloat(Edit12.Text) - (StrToFloat(Edit12.Text) * StrToFloat(Edit13.Text)) / 100 ));
  Edit15.Text:=Edit14.Text;
end;

//================= SALIR DEL DESCUENTO TOTAL =========================
procedure TFVentas.Edit13Exit(Sender: TObject);
begin
  if (Edit12.Text='') then begin Edit12.Text:='0.00'; exit; end;
  if (Edit13.Text='') or (Edit13.Text='0.00') then
    begin Edit14.Text:=Edit12.Text; Edit15.Text:=Edit12.Text; Exit; end;
  Edit13.Text:=FormatFloat('0.00',StrToFloat(Edit13.Text));
  Edit14.Text := FormatFloat('0.00',(StrToFloat(Edit12.Text) - (StrToFloat(Edit12.Text) * StrToFloat(Edit13.Text)) / 100 ));
  Edit15.Text:=Edit14.Text;
end;

//=================== SALIR DEL IMPORTE TOTAL + DTO =====================
procedure TFVentas.Edit14Exit(Sender: TObject);
var
  Pvp, Margen: Double;
begin
  if (Edit14.Text='') or (Edit14.Text='0') then If (Edit12.Text='') or (Edit12.Text='0') then exit;
  //---------- Calcular %dto sobre el pvp
  if (Edit12.Text <> '') and (Edit12.Text <> '0') then
    begin
      Pvp := StrToFloat(StaticText1.Caption);
      Margen := ((Pvp-StrToFloat(Edit14.Text)) * 100 / Pvp);
      if Pvp=0 then DataModule1.Mensaje('Información','El importe a pagar es cero', 1500 , clGray)
               else Edit13.Text := FormatFloat('0.00',Margen);
    end;
  Edit15.Text:=Edit14.Text;
end;

//================= SALIR DEL IMPORTE QUE ENTREGA ==================
procedure TFVentas.Edit15Exit(Sender: TObject);
begin
  if Edit14.Text='' then Edit14.Text:='0';
  if Edit15.Text='' then Edit15.Text:='0';

  if ((StrToFloat(Edit14.Text)=0) and (StrToFloat(Edit12.Text)>0)) then exit;

  Edit16.Text:=FormatFloat('0.00',StrToFloat(Edit15.Text)+StrToFloat(Edit42.Text)-StrToFloat(Edit14.Text));
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

//================ ENTREGA CONTADO ================
procedure TFVentas.Edit42Exit(Sender: TObject);
begin
  if Edit14.Text='' then Edit14.Text:='0';
  if Edit15.Text='' then Edit15.Text:='0';
  if Edit42.Text='' then Edit42.Text:='0';

  if ((StrToFloat(Edit14.Text)=0) and (StrToFloat(Edit12.Text)>0)) then exit;

  Edit16.Text:=FormatFloat('0.00',(StrToFloat(Edit15.Text)+StrToFloat(Edit42.Text))-StrToFloat(Edit14.Text));
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

//============ PINTAR ENTRADA DE DATOS ===========
procedure TFVentas.PintaEntrada();
begin
  Edit3.Text:=dbArti.FieldByName('A0').AsString;//----------------- Codigo
  Edit4.Text:=dbArti.FieldByName('A1').AsString;//----------------- Descripcion
  if (Edit5.Text='') or (Edit5.Text='0') then Edit5.Text:='1';//--- Unidades
  if (Edit6.Text='') or (Edit6.Text='0') then Edit6.Text:=dbArti.FieldByName('A2').AsString;//------------ P.V.P.
  if (Edit7.Text='') or (Edit7.Text='0') then Edit7.Text:=dbArti.FieldByName('A21').AsString;//----------- Precio
  //-----------Ver si se aplica algún precio de tarifa al cliente
  if (dbClientes.FieldByName('C43').AsInteger<>0) and (ListBox2.Items.Count=0) then VerTarifas(); // Cargamos tarifas si es primera vez
  //------------ Iva
  if (Edit10.Text='') or (Edit10.Text='0') then Edit10.Text:=dbArti.FieldByName('A3').AsString;//--------- IVA
  Edit6Exit(self);// Actualizamos precio a partir de PVP.
  //-----------Si tiene descuentos de la ficha de clientes
  if dbClientes.FieldByName('C16').AsInteger<>0 then                      //-- Descuento según tipo descuento en ficha cliente
    begin
      if dbClientes.FieldByName('C16').AsInteger=1 then Edit8.Text:=dbArti.FieldByName('A7').AsString;
      if dbClientes.FieldByName('C16').AsInteger=2 then Edit8.Text:=dbArti.FieldByName('A8').AsString;
      if dbClientes.FieldByName('C16').AsInteger=3 then Edit8.Text:=dbArti.FieldByName('A9').AsString;
    end;
  if dbClientes.FieldByName('C17').AsFloat<>0 then Edit8.Text:=dbClientes.FieldByName('C17').AsString;//-- Dto Ficha cliente
  if (Edit8.Text='') then Edit8.Text:='0';//------- Descuento
  if (Edit9.Text='') then Edit9.Text:='0';//------- Importe
  VerImporteEntra(); //-------- Calcular datos con este importe
  //------------ Total de la linea
  if (Edit11.Text='0') then Edit11.Text:='0';
  VerTotalEntra();//----------- Calcular total de la linea
  //------------- Pintar datos extras del articulo
  Label40.Caption:=dbArti.FieldByName('A4').AsString;//------------- Stock Actual
  Label41.Caption:=dbArti.FieldByName('A5').AsString;//------------- Stock Minimo
  Label43.Caption:=dbArti.FieldByName('A6').AsString;//------------- Stock Maximo
end;

//============ DOBLE CLICK EN EL GRID DE VENTAS ===========
procedure TFVentas.DBGrid1DblClick(Sender: TObject);
begin
  if dbVentas.RecordCount=0 then exit;
  Edit3.Text:=dbVentas.FieldByName('V3').AsString;//----------------- Codigo
  Edit4.Text:=dbVentas.FieldByName('V4').AsString;//----------------- Descripcion
  Edit5.Text:=dbVentas.FieldByName('V5').AsString;//----------------- Unidades
  Edit6.Text:=dbVentas.FieldByName('V6').AsString;//----------------- P.V.P.
  Edit7.Text:=dbVentas.FieldByName('V7').AsString;//----------------- Precio
  Edit8.Text:=dbVentas.FieldByName('V8').AsString;//----------------- Descuento
  Edit9.Text:=dbVentas.FieldByName('V9').AsString;//----------------- Importe
  Edit10.Text:=dbVentas.FieldByName('V10').AsString;//--------------- Iva
  Edit11.Text:=dbVentas.FieldByName('V11').AsString;//--------------- Total Linea

  Edit4.SetFocus;
  BitBtn4.Enabled:=True;
end;
//================= VER STOCK AL PASAR POR LAS LINEAS ================
procedure TFVentas.Datasource1DataChange(Sender: TObject; Field: TField);
begin
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbVentas.FieldByName('V3').AsString+'"';
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  Label40.Caption:=dbBusca.FieldByName('A4').AsString;//------------- Stock Actual
  Label41.Caption:=dbBusca.FieldByName('A5').AsString;//------------- Stock Minimo
  Label43.Caption:=dbBusca.FieldByName('A6').AsString;//------------- Stock Maximo
end;


//============ GRABAR ENTRADA DE DATOS ===========
procedure TFVentas.GrabaEntrada();
begin
  if modificando=0 then
    begin
     dbVentas.FieldByName('V0').AsString:='0';//------------------------ N. Ticket
     dbVentas.FieldByName('V1').AsString:=TICKET;//--------------------- Cgo. Vendedor
     dbVentas.FieldByName('V2').AsInteger:=VerUltimaLineaV;//----------- N. Linea
    end;
  dbVentas.FieldByName('V3').AsString:=Edit3.Text;//----------------- Codigo
  dbVentas.FieldByName('V4').AsString:=Edit4.Text;//----------------- Descripcion
  dbVentas.FieldByName('V5').AsString:=Edit5.Text;//----------------- Unidades
  dbVentas.FieldByName('V6').AsString:=Edit6.Text;//----------------- P.V.P.
  dbVentas.FieldByName('V7').AsString:=Edit7.Text;//----------------- Precio
  dbVentas.FieldByName('V8').AsString:=Edit8.Text;//----------------- Descuento
  dbVentas.FieldByName('V9').AsString:=Edit9.Text;//----------------- Importe
  dbVentas.FieldByName('V10').AsString:=Edit10.Text;//--------------- Iva
  dbVentas.FieldByName('V11').AsString:=Edit11.Text;//--------------- Total Linea
  dbVentas.FieldByName('V12').AsString:=Edit1.Text;//---------------- Cgo. Cliente
  //-- ShowMessage(DateToStr(Date));
  dbVentas.FieldByName('V14').AsDateTime:=Date();//-------------------- Fecha de grabación de la línea
  //-- ShowMessage(TimeToStr(Time));
  dbVentas.FieldByName('V15').AsDateTime:=Time();//-------------------- Hora de grabación de la línea
end;

//=================== SACAR EL ULT N. DE LINEA VENTAS =====================
function TFVentas.VerUltimaLineaV: Integer;
begin
  VerUltimaLineaV:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(V2) As ULTIMA FROM ventas'+Tienda+Puesto+' WHERE '+
                    'V0=0 AND V1='+TICKET;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLineaV:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;


//===================== CALCULAR IMPORTE DE LA LINEA ==============
procedure TFVentas.VerImporteEntra();
begin
 if StrToFloat(Edit8.Text)<>0 then
  begin
    //-------------- Si hay Dto. lo aplico
    Edit9.Text := FloatToStr(StrToFloat(Edit5.Text) * StrToFloat(Edit7.Text));
    Edit9.Text := FloatToStr(StrToFloat(Edit9.Text)*(1-StrToFloat(Edit8.Text)/100));
    Edit9.Text := FormatFloat('0.00',StrToFloat(Edit9.Text));

  end
 else
  begin
    //-------------- Si no hay Dto. unidades * Precio
    Edit9.Text := FloatToStr(StrToFloat(Edit5.Text) * StrToFloat(Edit7.Text));
    Edit9.Text := FormatFloat('0.00',StrToFloat(Edit9.Text));
  end;
end;

//===================== CALCULAR DESCUENTO DE LA LINEA ==============
procedure TFVentas.VerDtoEntra();
begin
 if StrToFloat(Edit11.Text)<>0 then
  begin
    //-------------- Si existe un importe superior a 0

    // ----  Para variar el Precio del Articulo con y sin IVA en función del total
{
    Edit6.Text := FloatToStr(StrToFloat(Edit11.Text) / StrToFloat(Edit5.Text));
    Edit7.Text := FloatToStr(StrToFloat(Edit6.Text) / ((StrToFloat(Edit10.Text) / 100) + 1));
    Edit6.Text := FormatFloat('0.000',StrToFloat(Edit6.Text));
    Edit7.Text := FormatFloat('0.000',StrToFloat(Edit7.Text));
}

    Edit8.Text:= FloatToStr((1-StrToFloat(Edit11.Text)/(StrToFloat(Edit5.Text)*StrToFloat(Edit6.Text)))*100);
    Edit9.Text:= FloatToStr(StrToFloat(Edit11.Text)/(1 + StrToFloat(Edit10.Text)/100 ));
    Edit8.Text := FormatFloat('0.00',StrToFloat(Edit8.Text));
    Edit9.Text := FormatFloat('0.000',StrToFloat(Edit9.Text));

    VerImporteEntra(); VerTotalEntra();
  end
end;

//===================== CALCULAR TOTAL DE LA LINEA ==============
procedure TFVentas.VerTotalEntra();
 var
  PrecioConIva: double;
begin
  //------------- Si no hay dto, se calcula unid. * pvp y listo
  if (Edit8.Text='') or (StrToFloat(Edit8.Text)=0) then
    begin
        Edit11.Text:=FormatFloat('0.00',StrToFloat(Edit5.Text)*StrToFloat(Edit6.Text));
        Exit;
    end;
  Edit11.Text:=Edit9.Text;
  if (Edit10.Text='') or (StrToFloat(Edit10.Text)=0) then exit; //---- si el iva es 0 salir
  PrecioConIva:=StrToFloat(Edit9.Text) * (1+(StrToFloat(Edit10.Text) / 100)); //--- Sumar el IVA
  Edit11.Text:=FormatFloat('0.00',PrecioConIva);
end;

//============= LOCALIZAR ARTICULOS POR CODIGO =====================
function TFVentas.LeerArticulo: Boolean;
begin
  LeerArticulo:=False;
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit3.Text+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount<>0 then
    begin LeerArticulo:=True; PintaEntrada(); end
  else LeerArticulo:=False;
end;
//============= LOCALIZAR ARTICULOS POR CGO AUXILIAR =====================
function TFVentas.LeerAuxiliar: Boolean;
begin
  LeerAuxiliar:=False;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM eans WHERE EAN0="'+Edit3.Text+'"';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then exit;
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbTrabajo.FieldByName('EAN1').AsString+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount=0 then exit;
  PintaEntrada();//----- Pintar los datos del articulo.
  Edit3.Text:=dbTrabajo.FieldByName('EAN0').AsString;//----- código
  Edit4.Text:=dbTrabajo.FieldByName('EAN2').AsString;//----- Descripcion
  IF (Edit5.Text='1') or (Edit5.Text='0') then Edit5.Text:=dbTrabajo.FieldByName('EAN3').AsString;//----- Unidades del auxiliar

  { TODO : ventas falta poner el importe del auxiliar o la cantidad por el importe unitario?
 }
  if (dbTrabajo.FieldByName('EAN4').AsString<>'0') then Edit6.Text:=dbTrabajo.FieldByName('EAN4').AsString;//----- Precio Unitario Ean
  Edit6Exit(self);    // Actualizamos precios.

  LeerAuxiliar:=True;
end;

//============= VER SI HAY TARIFAS ACTIVAS PARA ESTE ARTICULO  ==============
procedure TFVentas.VerTarifas();
begin
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM tarifas WHERE TAR0="'+dbArti.FieldByName('A0').AsString+'"';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    begin
      //WriteLn('Hola');
      ListBox2.Items.Clear;

      ListBox2.Items.Add('PVP        '+dbArti.FieldByName('A2').AsString + ' Euros');
      ListBox2.Items.Add('Precio     '+dbArti.FieldByName('A21').AsString + ' Euros');
      ListBox2.Items.Add('Tarifa 1   '+dbTrabajo.FieldByName('TAR2').AsString + ' Euros');
      ListBox2.Items.Add('Tarifa 2   '+dbTrabajo.FieldByName('TAR4').AsString + ' Euros');
      ListBox2.Items.Add('Tarifa 3   '+dbTrabajo.FieldByName('TAR6').AsString + ' Euros');
       //------------------ Tarifa 1
       if (dbClientes.FieldByName('C43').AsInteger=1) and (dbTrabajo.FieldByName('TAR7').AsFloat<>0) then
         begin
            Edit6.Text:=dbTrabajo.FieldByName('TAR7').AsString;//------------ P.V.P.
            Edit7.Text:=dbTrabajo.FieldByName('TAR2').AsString;//----------- Precio
         end;
       //------------------ Tarifa 2
       if (dbClientes.FieldByName('C43').AsInteger=2) and (dbTrabajo.FieldByName('TAR8').AsFloat<>0) then
         begin
           Edit6.Text:=dbTrabajo.FieldByName('TAR8').AsString;//------------ P.V.P.
           Edit7.Text:=dbTrabajo.FieldByName('TAR4').AsString;//----------- Precio
         end;
       //------------------ Tarifa 3
       if (dbClientes.FieldByName('C43').AsInteger=3) and (dbTrabajo.FieldByName('TAR9').AsFloat<>0) then
         begin
           Edit6.Text:=dbTrabajo.FieldByName('TAR9').AsString;//------------ P.V.P.
           Edit7.Text:=dbTrabajo.FieldByName('TAR6').AsString;//----------- Precio
         end;
    end;
end;

//=========== PREGUNTAR SI SE APUNTA A CREDITO LA OPERACION ===================
function TFVentas.VerSiApuntarCredito: Boolean;
var
  Texto: PChar;
begin
  VerSiApuntarCredito:=False;
  if Edit1.Text=ClienteVario then begin DataModule1.Mensaje('Información','No se pueden apuntar créditos a clientes varios', 2000 , clGray); exit; end;
  Texto:=PChar('SE APUNTARA EN SU CUENTA DE CREDITO '+Edit16.Text+'?');
  if Application.MessageBox(Texto,'FacturLinEx', boxstyle) = IDNO Then
    VerSiApuntarCredito:=False
  else
    VerSiApuntarCredito:=True;
end;

//================== LIMPIAR ENTRADA DE DATOS ===========
procedure TFVentas.LimpiaEntrada();
begin
  Edit3.Text:='';Edit4.Text:='';Edit5.Text:='0';Edit6.Text:='0';Edit7.Text:='0';
  Edit8.Text:='0';Edit9.Text:='0';Edit10.Text:='0';Edit11.Text:='0';

  label40.Caption:=''; label41.Caption:=''; label43.Caption:='';
  label40.font.color:=clDefault;

  ListBox2.Items.Clear;
end;

//================== PINTAR TOTAL GENERAL ===============
procedure TFVentas.PintarTotalGeneral();
begin
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT SUM(V11) FROM ventas'+Tienda+Puesto+' WHERE '+
                      'V0=0 AND V1='+TICKET;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then StaticText1.Caption:='0.00'
  else StaticText1.Caption:=FormatFloat('0.00',dbTrabajo.Fields[0].AsFloat);
  dbTrabajo.Active:=False;

  //Actualizamos QR de veri*factu

   BarcodeQR1.Text:=txtQR+'&importe='+StaticText1.Caption;

end;

//====================== MARCAR/DESMARCAR LINEAS ==================
procedure TFVentas.BitBtn6Click(Sender: TObject);
begin
  if dbVentas.RecordCount=0 then exit;
  if dbVentas.FieldByName('V13').AsString='S' then
    begin
     dbVentas.Edit; dbVentas.FieldByName('V13').AsString:='N'; 
    end
  else
    begin
     dbVentas.Edit; dbVentas.FieldByName('V13').AsString:='S'; 
    end;
  try
    dbVentas.Post;
  except
    on EDB: EDatabaseError do
    begin
      Showmessage('Error : ' + EDB.Message);
    end;
  end;
end;

//---------------- PINTAR LINEAS MARCADAS EN ROJO ----------------
procedure TFVentas.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  G: TDBGrid;
  DS: TDataSet;
  S: string;
begin
  G := TDBGrid(Sender);
  DS := nil;
  if (G.DataSource <> nil) then
    DS := G.DataSource.DataSet;

  // 1) Colores base (primero)
  if (gdSelected in State) then
  begin
    G.Canvas.Brush.Color := clInfoBK;
    G.Canvas.Font.Color := clBlack;
  end
  else
  begin
    G.Canvas.Brush.Color := clWhite;
    G.Canvas.Font.Color := clBlack;
  end;

  // 2) Si está marcada en rojo, SOLO cambiamos el color de fuente
  if (DS <> nil) and (not DS.IsEmpty) then
    if DS.FieldByName('V13').AsString = 'S' then
      G.Canvas.Font.Color := clRed;

  // 3) Pintamos el fondo SIEMPRE
  G.Canvas.FillRect(Rect);

  // 4) Columna de "número de línea"
  if Column.Index = 0 then
  begin
    if (DS <> nil) and (not DS.IsEmpty) then
      S := IntToStr(DS.RecNo)
    else
      S := '';
    G.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
    Exit; // IMPORTANTÍSIMO: no pintes por defecto encima
  end;

  // 5) Resto de columnas: dibujo estándar (una sola vez)
  G.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

//=================== SELECCIONAR SERIE DE FACTURACION POR DEFECTO ============
procedure TFVentas.VerSerieFacturacion();
begin
  //--- Ver la tienda activa para saber que serie usa por defecto
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin DataModule1.Mensaje('Información','No sé en qué tienda facturar', 2000 , clGray); Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin DataModule1.Mensaje('Información','Crear SERIE de facturación', 2000 , clGray); exit; end;
  dbSeries.Locate('SF0', dbTiendas.Fields[11].AsString, [loCaseInsensitive]);
  SERIEFACT:=dbSeries.FieldByName('SF0').AsString;
  dbTiendas.Active:=False; dbSeries.Active:=False;
end;

//================= N. DE TICKET ===========================
procedure TFVentas.NumeroTicket();
begin
  if SERIEFACT='' then begin SERIEFACT:='';NOPERACION:=0; Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF4=SF4+1 WHERE SF0="'+SERIEFACT+'"';
  try
    dbSeries.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado Actualizando Series FraS : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+SERIEFACT+'"';
  dbSeries.Active:=True;
  if dbSeries.Recordcount=0 then exit;
  NOPERACION:=dbSeries.Fields[4].AsInteger;
  dbSeries.Active:=False;
end;

//================= N. DE FACTURA ===========================
procedure TFVentas.NumeroFactura();
begin
  if SERIEFACT='' then begin SERIEFACT:='';NOPERACION:=0; Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF2=SF2+1 WHERE SF0="'+SERIEFACT+'"';
  try
    dbSeries.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado Actualizando Series Fra : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+SERIEFACT+'"';
  dbSeries.Active:=True;
  if dbSeries.Recordcount=0 then exit;
  NOPERACION:=dbSeries.Fields[2].AsInteger;
  dbSeries.Active:=False;
end;

//================= N. DE ALBARAN ===========================
procedure TFVentas.NumeroAlbaran();
begin
  if SERIEFACT='' then begin SERIEFACT:='';NOPERACION:=0; Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF3=SF3+1 WHERE SF0="'+SERIEFACT+'"';
  try
    dbSeries.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado Actualizando Series Alb : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+SERIEFACT+'"';
  dbSeries.Active:=True;
  if dbSeries.Recordcount=0 then exit;
  NOPERACION:=dbSeries.Fields[3].AsInteger;
  dbSeries.Active:=False;
end;

//================= N. DE PEDIDO ===========================
procedure TFVentas.NumeroPedido();
begin
  if trim(copy(Combo5.Items.Strings[Combo5.ItemIndex],1,3))='' then Exit;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF7=SF7+1 WHERE SF0="'+trim(copy(Combo5.Items.Strings[Combo5.ItemIndex],1,3))+'"';
  try
    dbSeries.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado Actualizando Series Pedido : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
  dbSeries.Active:=False;
end;

//================= N. DE PRESUPUESTO ===========================
procedure TFVentas.NumeroPresupuesto();
begin
  if trim(copy(Combo6.Items.Strings[Combo6.ItemIndex],1,3))='' then Exit;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF6=SF6+1 WHERE SF0="'+
                     trim(copy(Combo6.Items.Strings[Combo6.ItemIndex],1,3))+'"';
  try
    dbSeries.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado Actualizando Series Presup : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
  dbSeries.Active:=False;
end;
//================= N. DE PROFORMA ===========================
procedure TFVentas.NumeroProforma();
begin
  if trim(copy(Combo6.Items.Strings[Combo6.ItemIndex],1,3))='' then Exit;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF8=SF8+1 WHERE SF0="'+
                      trim(copy(Combo6.Items.Strings[Combo6.ItemIndex],1,3))+'"';
  try
    dbSeries.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado Actualizando Series Proforma : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
  dbSeries.Active:=False;
end;

//================ TIPOS DE RECARGO =====================
procedure TFVentas.VerRecargo();
begin
   RECARGO:=RIVA1;
   if dbTrabajo.Fields[0].AsFloat=IVA1 then RECARGO:=RIVA1;
   if dbTrabajo.Fields[0].AsFloat=IVA2 then RECARGO:=RIVA2;
   if dbTrabajo.Fields[0].AsFloat=IVA3 then RECARGO:=RIVA3;
end;

//================== BLOQUEAR CONTROLES =============
procedure TFVentas.Bloquear();
begin
  dbGrid1.Enabled:=False; BitBtn8.Enabled:=False; BitBtn7.Enabled:=False;
  BitBtn3.Enabled:=False; BitBtn4.Enabled:=False; BitBtn5.Enabled:=False;
  BitBtn6.Enabled:=False; BitBtn14.Enabled:=False; BitBtn15.Enabled:=False;
  BitBtn16.Enabled:=False; BitBtn17.Enabled:=False; BitBtn18.Enabled:=False;
  BitBtn21.Enabled:=False; BitBtn22.Enabled:=False; Panel5.Enabled:=False;
  Edit3.Enabled:=False; Edit4.Enabled:=False; Edit5.Enabled:=False;
  Edit6.Enabled:=False; Edit7.Enabled:=False; Edit8.Enabled:=False;
  Edit9.Enabled:=False; Edit10.Enabled:=False; Edit11.Enabled:=False;
end;

//================== BLOQUEAR CONTROLES =============
procedure TFVentas.DesBloquear();
begin
  dbGrid1.Enabled:=True; BitBtn8.Enabled:=True; BitBtn7.Enabled:=True;
  BitBtn3.Enabled:=True; BitBtn4.Enabled:=True; BitBtn5.Enabled:=True;
  BitBtn6.Enabled:=True; BitBtn14.Enabled:=True; BitBtn15.Enabled:=True;
  BitBtn16.Enabled:=True; BitBtn17.Enabled:=True; BitBtn18.Enabled:=True;
  BitBtn21.Enabled:=True; BitBtn22.Enabled:=True; Panel5.Enabled:=True;
  Edit3.Enabled:=True; Edit4.Enabled:=True; Edit5.Enabled:=True;
  Edit6.Enabled:=True; Edit7.Enabled:=True; Edit8.Enabled:=True;
  Edit9.Enabled:=True; Edit10.Enabled:=True; Edit11.Enabled:=True;
  Edit15.Enabled:=True;
end;

//================ Ver series de facturacion cuando se pasa por ellas =========
procedure TFVentas.ListBox1Click(Sender: TObject);
begin
  if Label33.Caption='N. Factura' then
    begin
      if dbSeries.Locate('SF0',trim(copy(ListBox1.Items.Strings[ListBox1.ItemIndex],1,3)),[]) then
        Edit21.Text:=IntToStr(dbSeries.FieldByName('SF2').AsInteger+1);
    end
  else
    begin
      if dbSeries.Locate('SF0',trim(copy(ListBox1.Items.Strings[ListBox1.ItemIndex],1,3)),[]) then
        Edit21.Text:=IntToStr(dbSeries.FieldByName('SF3').AsInteger+1);
    end
end;

//======================= MOSTRAR LAS DISTINTAS TARIFAS ======================
procedure TFVentas.MuestraTarifas();
begin
   ListBox2.Visible:=true;  ListBox2.SetFocus;
end;
procedure TFVentas.ListBox2DblClick(Sender: TObject);
begin
   ListBox2.Visible:= False;
   if ListBox2.ItemIndex=0 then Edit7.Text:=dbArti.FieldByName('A2').AsString;
   if ListBox2.ItemIndex=1 then Edit7.Text:=dbArti.FieldByName('A21').AsString;
   if ListBox2.ItemIndex=2 then Edit7.Text:=dbTrabajo.FieldByName('TAR2').AsString;
   if ListBox2.ItemIndex=3 then Edit7.Text:=dbTrabajo.FieldByName('TAR4').AsString;
   if ListBox2.ItemIndex=4 then Edit7.Text:=dbTrabajo.FieldByName('TAR6').AsString;
   Edit7Exit(self);
end;

procedure TFVentas.ListBox2KeyPress(Sender: TObject; var Key: char);
begin
   if (Key=#13) then begin ; Key:=#0; ListBox2DblClick(self); end;
end;

//=========================================================================
//=================== CAMBIAR ENTRE TICKETS ABIERTOS ======================
//=========================================================================
//--------------- Cambiar en el grid de tickets abiertos -----------------
procedure TFVentas.Datasource2DataChange(Sender: TObject; Field: TField);
begin
  if Llenando=0 then CambiarTicket();//--- Si no se esta llenado el grid
end;
//---------------- CAMBIAR ENTRE TICKETS ABIERTOS ----------------------
procedure TFVentas.CambiarTicket();
begin
  TICKET:=dbTickets.Fields[0].AsString;
  //--------- Tabla de ventas
  dbVentas.Active:=False;
  dbVentas.SQL.Text:='SELECT * FROM ventas'+Tienda+Puesto+' WHERE V0=0 AND V1='+TICKET;
  dbVentas.Active:=True;
  //--------- Ver si hay lineas de venta de algun cliente para seleccionarlo
  if dbVentas.RecordCount<>0 then
    begin
      if dbVentas.FieldByName('V12').AsInteger<>0 then
        Edit1.Text:=dbVentas.FieldByName('V12').AsString
      else
        Edit1.Text:=ClienteVario;
    end;
  Edit1Exit(Edit1); PintarTotalGeneral(); Edit3.SetFocus;
end;
//----------------- SI SALE DEl TICKET NUEVO SIN LINEAS ---------
procedure TFVentas.DBGrid2CellClick(Column: TColumn);
begin
  if dbVentas.RecordCount=0 then RefrescaTicketsAbiertos();
end;

//----------------- REFRESCAR TICKETS APARCADOS ------------------
procedure TFVentas.RefrescaTicketsAbiertos();
begin
  Llenando:=1;
  dbTickets.Refresh;
  if dbTickets.RecordCount=0 then begin TICKET:='1'; exit; end;
  if not dbTickets.Locate('TI0',TICKET,[]) then CambiarTicket();
  Llenando:=0;
end;
//-------------------- APARCAR TICKET -----------------------
procedure TFVentas.BitBtn24Click(Sender: TObject);
begin
  if dbVentas.RecordCount=0 then begin Edit3.SetFocus; exit; end;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT DISTINCT(V1) FROM ventas'+Tienda+Puesto+
                      ' WHERE V0=0 ORDER BY V1 DESC LIMIT 1';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then TICKET:='1'
  else TICKET:=IntToStr(dbTrabajo.Fields[0].AsInteger+1);
  //--------- Tabla de ventas
  dbVentas.Active:=False;
  dbVentas.SQL.Text:='SELECT * FROM ventas'+Tienda+Puesto+' WHERE V0=0 AND V1='+TICKET;
  dbVentas.Active:=True;
  Edit1.Text:=ClienteVario; Edit1Exit(Edit1);
  PintarTotalGeneral(); Edit3.SetFocus;
end;

//=====================================================================
//==================== IMPRIMIR TICKETS ===============================
//=====================================================================
procedure TFVentas.ImpreTicket(regalo: boolean);
var
  Precio, SubTotal: Double;
  Texto: String;
  b1,b2,b3,tiva1,tiva2,tiva3,iiva1,iiva2,iiva3: Double;
  LeyendaCabeceraQR, leyendaPieQR: string;

begin
     b1:=0;
     b2:=0;
     b3:=0;
     tiva1:=0;
     tiva2:=0;
     tiva3:=0;
     iiva1:=0;
     iiva2:=0;
     iiva3:=0;

   if UpperCase(vfMode) = 'PRODUCCION' then
     begin
      LeyendaCabeceraQR := ' QR Tributario : ';
      LeyendaPieQR := ' VERI*FACTU ';
     end else
     begin
      LeyendaCabeceraQR := LeyendaSuperiorQR;
      LeyendaPieQR := LeyendaInferiorQR;
     end;

  AssignFile(PrintText, DevTicket);
  Rewrite(PrintText);
  Write(PrintText, #27#97#1); // Centrar
  Writeln(PrintText,LeyendaCabeceraQR);
  Write(PrintText, #27#97#0); // Volver a izquierda

  CloseFile(PrintText);

  ImprimeQRTicket();

  AssignFile(PrintText, DevTicket); //Añadido por javi para quitar opendialog
  Rewrite(PrintText);

  Write(PrintText, #27#97#1); // Centrar
  Writeln(PrintText,LeyendaPieQR);
  Write(PrintText, #27#97#0); // Volver a izquierda

  if ChBoxRegalo.Checked then
    begin
     Writeln(PrintText, '');Writeln(PrintText, ''); Writeln(PrintText, '');
    end;

  CabeceraTicket();
  dbVentas.First;
  while not dbVentas.Eof do
    begin
      if (tiva1=0) then tiva1:=dbVentas.FieldByName('V10').AsInteger;
      if ((tiva2=0) and (tiva1<>dbVentas.FieldByName('V10').AsInteger)) then tiva2:=dbVentas.FieldByName('V10').AsInteger;
      if ((tiva3=0) and (tiva1<>dbVentas.FieldByName('V10').AsInteger) and (tiva2<>dbVentas.FieldByName('V10').AsInteger)) then tiva3:=dbVentas.FieldByName('V10').AsInteger;

      if tiva1=dbVentas.FieldByName('V10').AsInteger then
        begin
          b1:=b1+((dbVentas.Fields[11].AsFloat)/(1+(dbVentas.FieldByName('V10').AsInteger/100)));
          iiva1:=iiva1+((dbVentas.Fields[11].AsFloat)-(dbVentas.Fields[11].AsFloat/(1+(dbVentas.FieldByName('V10').AsInteger/100))))
        end;
      if tiva2=dbVentas.FieldByName('V10').AsInteger then
        begin
          b2:=b2+((dbVentas.Fields[11].AsFloat)/(1+(dbVentas.FieldByName('V10').AsInteger/100)));
          iiva2:=iiva2+((dbVentas.Fields[11].AsFloat)-(dbVentas.Fields[11].AsFloat/(1+(dbVentas.FieldByName('V10').AsInteger/100))))
        end;
      if tiva3=dbVentas.FieldByName('V10').AsInteger then
        begin
          b3:=b3+((dbVentas.Fields[11].AsFloat)/(1+(dbVentas.FieldByName('V10').AsInteger/100)));
          iiva3:=iiva3+((dbVentas.Fields[11].AsFloat)-(dbVentas.Fields[11].AsFloat/(1+(dbVentas.FieldByName('V10').AsInteger/100))))
        end;

       if DesgloIva='S' then
           begin
            Precio:=dbVentas.Fields[7].AsFloat;
            SubTotal:=dbVentas.Fields[9].AsFloat;
           end else
           begin
            Precio:=dbVentas.Fields[6].AsFloat;
            SubTotal:=dbVentas.Fields[11].AsFloat;
           end;
      //--- Línea con código de artículo
      if CgoEnTicket='S' then Texto:=Copy(dbVentas.Fields[3].AsString+'                    ',1,18)+' '
                         else Texto:=Copy(dbVentas.Fields[4].AsString+'                    ',1,18)+' ';

      Texto:=Texto + DataModule1.LFill(FormatFloat('##0.00',dbVentas.Fields[5].AsFloat),6,' ') + ' ';

      if regalo= false  then
        begin
          Texto:=Texto + DataModule1.LFill(FormatFloat('##0.00',Precio),6,' ') + ' ';
          Texto:=Texto + DataModule1.LFill(FormatFloat('###0.00',SubTotal),7,' ');

        end;

      //--- Cgo Articulo en ticket (Ojo! se imprimen dos lineas por articulo)
      if CgoEnTicket='S' then
        begin
          Writeln(PrintText, Texto);
          Writeln(PrintText, Copy(dbVentas.Fields[4].AsString+'                                        ',1,40));

        end else
          Writeln(PrintText, Texto);

      dbVentas.Next;
     end;

  if regalo= false then TotalTicket(b1,b2,b3,tiva1,tiva2,tiva3,iiva1,iiva2,iiva3)
                   else
                    begin
                      Writeln(PrintText, '');
                      Writeln(PrintText, ' *** TICKET REGALO *** ');
                      Writeln(PrintText, '');
                    end;

  PieTicket();

  Corte();
  CloseFile(PrintText);
end;


//=============== QR DEL TICKET =========================================
Procedure TFVentas.ImprimeQRTicket();
var
  Ticketera: TLCLHandle;
  S: RawByteString;
  LeyendaTextoQR: string;

begin

   if UpperCase(vfMode) = 'PRODUCCION' then
        LeyendaTextoQR := BarcodeQR1.Text
   else
        LeyendaTextoQR := TextoCodigoQR;

  try

   S := ESC + '@'; // Resetear impresora

   // Establecer el modo de almacenamiento de QR
   S += GS + '(k' + #4#0 + #49#65#50#0;

   // Definir contenido del QR
   S += GS + '(k';
   S += Char(Length(LeyendaTextoQR) + 3);
   S += #0;
   S += #49#80#48;
   S += LeyendaTextoQR;

   //Centrar QR
   S += ESC + 'a' + #1;

   // Definir tamaño QR a 30x30 mm
   S += GS + '(k' + #3#0 + #49#67#8;       // #5

   // Imprimir el QR
   S += GS + '(k' + #3#0 + #49#81#48;

   // Saltos de línea para asegurar el corte o avance
   //S += #10;

   Ticketera := FileCreate(ImpresoraTicket);
   if Ticketera = feInvalidHandle then
    raise Exception.Create('No se puede abrir la impresora en: ' + ImpresoraTicket);

   FileWrite(Ticketera, Pointer(S)^, Length(S));
   FileClose(Ticketera);

  except
    on E: Exception do
      WriteLn('Error: ', E.Message);
  end;


end;


//============== CABECERA DEL TICKETC ===================================
procedure TFVentas.CabeceraTicket();
var
  hora: String;
begin

  if trim(DevLogo)<>'' then
  try
     WriteLn(PrintText, PDevLogo);
   except
     raise;
  end;

  if trim(NegroD)<>'' then
  try
     WriteLn(PrintText, PNegroD);
   except
     raise;
  end;

  if Trim(LCTI1)<>'' then Writeln(PrintText, LCTI1);
  if Trim(LCTI2)<>'' then Writeln(PrintText, LCTI2);
  if Trim(LCTI3)<>'' then Writeln(PrintText, LCTI3);
  if Trim(LCTI4)<>'' then Writeln(PrintText, LCTI4);

  Writeln(PrintText, ' ');
  if HoraEnTicket='S' then hora:='   Hora.:'+FormatDateTime('hh:mm:ss',HoraVenta);

  if trim(Negro)<>'' then
  try
     WriteLn(PrintText, PNegro);
   except
     raise;
  end;

  //..Inserción de Prueba de Jose para QR
  try
    PrintQR(vfUrl+'nif='+NIF+'&'+'numserie='+'Serie FS-'+SERIEFACT+'-'+DataModule1.LFill(FormatFloat('#######',NOPERACION),7,' ')
                               +'&fecha='+FormatDateTime('dd-mm-yyyy',FechaVenta)
                               +'&importe='+DataModule1.LFill( FormatFloat('0.00',StrToFloat(Edit14.Text)),10,' '));
    WriteLn('QR enviado correctamente.');
  except
    on E: Exception do
      WriteLn('Error: ', E.Message);
  end;
  //..Inserción de Prueba de Jose para QR


  Writeln(PrintText, 'F A C T U R A   S I M P L I F I C A D A');
  Writeln(PrintText, '_______________________________________');
  Writeln(PrintText, 'N.FRA.SIMP:'+'FS-'+SERIEFACT+'-'+DataModule1.LFill(FormatFloat('#######',NOPERACION),7,' '));

  Writeln(PrintText, ' ');
  if Edit1.Text<>'999999' then Writeln(PrintText, 'CLIENTE : '+Edit1.Text+' '+Edit2.Text);
  if Edit1.Text<>'999999' then Writeln(PrintText, ' ');
  Writeln(PrintText, 'Forma de PAGO : '+Combo2.Text);
  Writeln(PrintText, 'Fecha.: '+FormatDateTime('dd/mm/yyyy',FechaVenta)+hora);
  Writeln(PrintText, ' ');
  Writeln(PrintText, 'ARTICULO              UND PRECIO   TOTAL');
  Writeln(PrintText, '========================================');
end;

//====================== PIE DEL TICKET =============================
procedure TFVentas.TotalTicket(n1,n2,n3,ti1,ti2,ti3,i1,i2,i3: Double);
Var
  Texto1,Texto2,Texto3,Texto4: String;
  Neto, Impuestos, TipoI: Double;
  Descuento: Double;
begin
  if SacaIva='S' then
    begin
         Writeln(PrintText, ' ');
         Writeln(PrintText, '                               ---------');
    end;

  Descuento:=0;

  if (Edit13.Text<>'') and (StrToFloat(Edit13.Text)<>0) then
     Descuento:=StrToFloat(Edit12.Text)-StrToFloat(Edit14.Text);
  //---------------------- Desglose de Iva en ticket
  if SacaIva='N' then
    begin
      Writeln(PrintText, ' ');
      Writeln(PrintText, '   Base      Tipo       Iva             ');
      Writeln(PrintText, '----------------------------------------');
//--------- IMPLEMENTADO POR JOSE PARA CONTROLAR EL MULTI-IVA
      IF ti1<>0 then
        begin
           Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',n1),10,' '));
           Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',ti1),10,' '));
           Writeln(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',i1),10,' '));
        end;
      IF ti2<>0 then
        begin
           Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',n2),10,' '));
           Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',ti2),10,' '));
           Writeln(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',i2),10,' '));
        end;
      IF ti3<>0 then
        begin
           Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',n3),10,' '));
           Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',ti3),10,' '));
           Writeln(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',i3),10,' '));
        end;

      Writeln(PrintText, '----------------------------------------');
      Writeln(PrintText, ' ');
   end;

  //---------------- Descuento
  if Descuento<>0 then
    begin
     Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(Edit12.Text)),10,' ');
     Texto3:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(Edit14.Text)),10,' ');
     if CgPrDto='S' then
       begin
          Texto2:= DataModule1.LFill( FormatFloat('######0.00',Descuento),10,' ');
          Writeln(PrintText, '                    SUBTOTAL  '+Texto1);
          Writeln(PrintText, '                    DCTO.   - '+Texto2);
          Writeln(PrintText, '                               ---------');
        end
        else
        begin
          Texto2:=DataModule1.LFill( FormatFloat('##0.00',StrToFloat(Edit13.Text)),6,' ');
          Writeln(PrintText, 'TOTAL:'+Texto1+'-'+Texto2+' %Dto ='+Texto3);
        end;
    end ;

  Writeln(PrintText, '             SUMA TOT.FRA.    '+DataModule1.LFill( FormatFloat('######0.00',StrToFloat(Edit14.Text)),10,' '));    ;
  Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(Edit15.Text)),10,' ');
  Writeln(PrintText, '                    ENTREGA   '+Texto1);
  Texto4:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(Edit16.Text)),10,' ');
  if StrToFloat(Edit16.Text)>=0 then
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

procedure TFVentas.PieTicket();
var
   Conta: Integer;
begin

   if SacaVende<>'N' then
    begin
      dbUsu.Locate('USU0', Dispensador , [loCaseInsensitive]);
      Writeln(PrintText, 'LE ATENDIO.: '+ copy(dbUsu.FieldByName('USU9').AsString, 1, 35));
    end;

  //----------------------------------------------------------------
  if Trim(LPTI1)<>'' then Writeln(PrintText, LPTI1);
  if Trim(LPTI2)<>'' then Writeln(PrintText, LPTI2);
  if Trim(LPTI3)<>'' then Writeln(PrintText, LPTI3);

  for Conta:=1 to StrToInt(LiFinTick) do Writeln(PrintText, ' ');
end;

//===================== ABRIR CAJON ===================
procedure TFVentas.BitBtn17Click(Sender: TObject);
var
  F : TextFile;
  fichero : string;
  textoseguro: string;
begin
  textoseguro:='';
  textoseguro:=InputBox('Codigo de Seguridad','Necesita el codigo de seguridad, insertelo y acepte','');
  if textoseguro=CgSegCajon then Cajon();
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
    WriteLn( F, '#= AUTORIZACION - '+textoseguro);
    WriteLn( F, 'CAJA : ' + Puesto +' - Dia : ' + FormatDateTime('YYYYMMDD',(Date)) + ' - Hora : ' + FormatDateTime('HH:MM:SS',(time)) );
    CloseFile( F );
//============================= KeyLog de Apertura CAJON ===============================
    edit3.SetFocus;
end;
procedure TFVentas.Cajon();
begin
  if trim(CgoCajon)='' then exit;
  try

   AssignFile(PrintText, DevTicket);

//-- TEST COMPROBACIÓN ERROR CAJON
//   showmessage(DevTicket);
//-- FIN TEST COMPROBACIÓN ERROR CAJON

   Rewrite(PrintText);

//   SHOWMESSAGE('PASADO REWRITE');

   WriteLn(PrintText, PCgoCajon);

//   SHOWMESSAGE('PASADO WRITELN');

   CloseFile(PrintText);

//   SHOWMESSAGE('PASADO CLOSEFILE');


   //TODO: Falta solucionar la impresion en cola

(*    //------ Imprimir en cola
    if CmdTicket<>'' then
      begin
       TxtCmd:=PChar(String(CmdTicket+' '+DevTicket));
       libc.system(TxtCmd);
      end;
*)
  except
   on E:Exception do
     begin
       ShowMessage('El error provocado en inserción ha sido: '+E.Message);
     end;
  end;
end;

//================== CORTE DE PAPEL ===================
procedure TFVentas.Corte();
begin
  if trim(CgoCorte)='' then exit;
  WriteLn(PrintText, PCgoCorte);
end;

//=====================================================================
//========================== PEDIDOS ==================================
//=====================================================================
procedure TFVentas.BitBtn21Click(Sender: TObject);
begin
  TabSheet1.Show;
  Bloquear();//------- Bloquear controles
  Panel9.Visible:=True;
  Edit17.Text:=dbClientes.FieldByName('C1').AsString;//----- Nombre del cliente.
  Edit18.Text:=dbClientes.FieldByName('C6').AsString;//----- Telefono del cliente.
  Edit19.Text:=StaticText1.Caption;//----- Total
  Edit20.Text:='0.00';//------------------ Entrega
  Edit23.Text:=StaticText1.Caption;//----- Resto
  //----- Seleccionar el cliente en pedidos si no es 999999 (Clientes varios)
  if Edit1.Text=ClienteVario then CheckBox2.Checked:=False else CheckBox2.Checked:=True;
  CheckBox2Change(CheckBox2);
  //--- Ver la tienda activa para saber que serie usa por defecto
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin DataModule1.Mensaje('Información','No sé en qué tienda facturar', 2000 , clGray); Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin DataModule1.Mensaje('Información','Debe crear SERIE de facturación', 2000 , clGray); exit; end;
  dbSeries.First; Combo5.Items.Clear;
  while not dbSeries.EOF do
    begin
     Combo5.Items.Add(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
     dbSeries.Next;
    end;
  dbSeries.Locate('SF0', dbTiendas.Fields[11].AsString, [loCaseInsensitive]);
  Combo5.ItemIndex:= Combo5.Items.IndexOf(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
  Edit26.Text:=IntToStr(dbSeries.FieldByName('SF7').AsInteger+1);
  dbTiendas.Active:=False;
  //-------------------------- Pedidos
  dbPedi.Active:=False;
  dbPedi.SQL.Text:='SELECT * FROM pedicc'+Tienda+' ORDER BY PC0 ASC, PC1 DESC, PC2 ASC, PC3 ASC, PC4 DESC';
  dbPedi.Active:=True;
  //-------------------------- Hist. de pedidos
  dbHiPedic.Active:=False;
  dbHiPedic.SQL.Text:='SELECT * FROM hipedicc'+Tienda+' WHERE HPC14<>0 AND HPC39="SV"'+
                      ' ORDER BY HPC0 ASC, HPC1 DESC, HPC2 ASC, HPC3 ASC, HPC4 DESC';
  dbHiPedic.Active:=True;

  DateEdit1.Date:=Date;
  //if CheckBox2.Checked=True then Edit20.SetFocus else Edit24.SetFocus;
end;

//----------------- Cambiar N.Pedido al moverse por el combo -------------
procedure TFVentas.Combo5Change(Sender: TObject);
begin
  if dbSeries.Locate('SF0',trim(copy(Combo5.Items.Strings[Combo5.ItemIndex],1,3)),[]) then
     Edit26.Text:=IntToStr(dbSeries.FieldByName('SF7').AsInteger+1);
end;

//----------------- Salir de crear pedidos ----------------
procedure TFVentas.BitBtn28Click(Sender: TObject);
begin
  dbHipedic.Active:=False; dbHipedid.Active:=False;
  Panel9.Visible:=False;
  Desbloquear();
end;

//----------------- Activar / desactivar Cliente para pedido ----------
procedure TFVentas.CheckBox2Change(Sender: TObject);
begin
  if CheckBox2.Checked=True then
    begin
      Edit17.Enabled:=True; Edit18.Enabled:=True; Edit19.Enabled:=True;
      Edit20.Enabled:=True; Edit23.Enabled:=True;
    end
  else
    begin
      Edit17.Enabled:=False; Edit18.Enabled:=False; Edit19.Enabled:=False;
      Edit20.Enabled:=False; Edit23.Enabled:=False;
    end;
end;

//------------ DOBLE CLICK EN PEDIDO -> MOSTRAR DATOS DEL PEDIDO -------------
procedure TFVentas.DBGrid3DblClick(Sender: TObject);
begin
  if dbPedi.RecordCount=0 then exit;
  DateEdit1.Date:=dbPedi.FieldByName('PC1').AsDateTime;
  if dbSeries.Locate('SF0',dbPedi.FieldByName('PC3').AsString,[]) then
     Combo5.ItemIndex:= Combo5.Items.IndexOf(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);//--- Serie Pedido
  Edit26.Text:=dbPedi.FieldByName('PC4').AsString;//---- N. Pedido
  Edit24.Text:=dbPedi.FieldByName('PC2').AsString;//---- Cgo Proveedor
  Edit24Exit(Edit24);
  Edit17.Text:=dbPedi.FieldByName('PC15').AsString;//--- Nombre cliente
  Edit18.Text:=dbPedi.FieldByName('PC16').AsString;//--- Telefono cliente
  Edit19.Text:=dbPedi.FieldByName('PC17').AsString;//--- Total
  Edit20.Text:=dbPedi.FieldByName('PC18').AsString;//--- Entrega
  Edit23.Text:=dbPedi.FieldByName('PC19').AsString;//--- Cambio
  //----- Seleccionar el cliente en pedidos si no es 999999 (Clientes varios)
  if Edit17.Text='' then CheckBox2.Checked:=False else CheckBox2.Checked:=True;
  CheckBox2Change(CheckBox2);
  //-----------------
end;

//---------------- Proveedor para el pedido -------------
procedure TFVentas.Edit24Enter(Sender: TObject);
begin
  Edit25.Text:='';
end;
procedure TFVentas.Edit24Exit(Sender: TObject);
begin
  if edit24.Text='' then exit;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT * FROM proveedores WHERE P0='+Edit24.Text;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then begin DataModule1.Mensaje('Información','No existe ese proveedor', 2000 , clGray); exit; end;
  Edit25.Text:=dbBusca.FieldByName('P1').AsString;
  dbBusca.Active:=False;
  BitBtn27.SetFocus;
end;

//------------------- Buscar Proveedor ------------
procedure TFVentas.BitBtn29Click(Sender: TObject);
begin
  if Edit25.Text='' then begin DataModule1.Mensaje('Información','Teclear comienzo de texto a buscar', 2000 , clGray); Edit25.SetFocus; Exit; end;
  Combo4.Clear; Combo4.Text:='';
  dbBusca.SQL.Text:='SELECT P0,P1 FROM proveedores WHERE P1 LIKE "'+Edit25.Text+'%"'; dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then
    begin
      DataModule1.Mensaje('Información','No hay ningún proveedor con ese comienzo', 2000 , clGray);
      dbBusca.Active:=False; Edit25.SetFocus; Exit;
    end;
  dbBusca.First;
  While not dbBusca.EOF do
    begin
      Combo4.Items.Add(dbBusca.FieldByName('P1').AsString);
      dbBusca.Next;
    end;
  Combo4.Visible:=True; Combo4.ItemIndex:=0; Combo4.SetFocus;
end;
procedure TFVentas.Combo4Click(Sender: TObject);
begin
  if Combo4.Text='' then begin Combo4.Visible:=False; Edit25.SetFocus; exit; end;
  if not dbBusca.Locate('P1',Combo4.Text,[]) then begin Edit25.Text:=''; Exit; end;
  Edit24.Text:=dbBusca.Fields[0].AsString;
  Edit25.Text:=dbBusca.Fields[1].AsString;
  Edit24Exit(Edit24);//---- Leer proveedor
  Combo4.Visible:=False; Edit25.SetFocus;
end;
procedure TFVentas.Combo4KeyPress(Sender: TObject; var Key: char);
begin
  if key=#13 then Combo4Click(Combo4);
end;

//----------------- Aceptar crear pedido ----------------
procedure TFVentas.BitBtn27Click(Sender: TObject);
begin
  if Edit24.Text='' then begin DataModule1.Mensaje('Información','Falta proveedor en el pedido', 2000 , clGray); exit; end;
  if dbVentas.RecordCount=0 then begin DataModule1.Mensaje('Información','No hay líneas para pedidos', 2000 , clGray); exit; end;
  If Application.MessageBox('CREAR UN PEDIDO NUEVO CON ESTAS LINEAS?','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM pedicc'+Tienda+' WHERE PC0='+NTienda+
                      ' AND PC1="'+FormatDateTime('YYYY-MM-DD',DateEdit1.Date)+'"'+
                      ' AND PC2='+Edit24.Text+
                      ' AND PC3="'+trim(copy(Combo5.Items.Strings[Combo5.ItemIndex],1,3))+'"'+
                      ' AND PC4='+Edit26.Text;
  dbTrabajo.Active:=True;
  dbTrabajo.Append; RellenaPedicc(); 
  try
    dbTrabajo.Post;
  except
    on EDB: EDatabaseError do
    begin
      Showmessage('Error : ' + EDB.Message);
    end;
  end;
  NumeroPedido();//------------ Aumentar N.Pedido.
  dbPedid.Active:=False;
  dbPedid.SQL.Text:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+NTienda+
                      ' AND PD1="'+FormatDateTime('YYYY-MM-DD',DateEdit1.Date)+'"'+
                      ' AND PD2='+Edit24.Text+
                      ' AND PD3="'+trim(copy(Combo5.Items.Strings[Combo5.ItemIndex],1,3))+'"'+
                      ' AND PD4='+Edit26.Text;
  dbPedid.Active:=True;
  dbVentas.First;
  while not dbVentas.EOF do
    begin
      dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbVentas.FieldByName('V3').AsString+'"';
      dbArti.Active:=True;
      dbPedid.Append; RellenaPedidd(); 
      try
        dbPedid.Post;
      except
        on EDB: EDatabaseError do
        begin
          Showmessage('Error : ' + EDB.Message);
        end;
      end;
      dbVentas.Next;
    end;
  dbTrabajo.Active:=False; dbPedid.Active:=False; dbPedi.Active:=False;
  BitBtn28Click(BitBtn28);//----- Cerrar pedidos
  BitBtn15Click(BitBtn15, false);//--- Borrar todas las lineas de venta
  dbVentas.Refresh; Edit1.Text:=ClienteVario; Edit1Exit(Edit1);
  PintarTotalGeneral();
  RefrescaTicketsAbiertos();
  Edit3.SetFocus;
end;
//----------------- Aceptar añadir al pedido ----------------
procedure TFVentas.BitBtn30Click(Sender: TObject);
begin
  if dbVentas.RecordCount=0 then begin DataModule1.Mensaje('Información','No hay líneas para crear pedidos', 2000 , clGray); exit; end;
  if dbPedi.RecordCount=0 then begin DataModule1.Mensaje('Información','No hay pedidos creados', 2000 , clGray); exit; end;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('AÑADIR ESTA LINEAS AL PEDIDO SELECCIONADO?','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  DateEdit1.Date:=dbPedi.FieldByName('PC1').AsDateTime;
  Edit24.Text:=dbPedi.FieldByName('PC2').AsString;
  Edit24Exit(Edit24);
  if dbSeries.Locate('SF0',dbPedi.FieldByName('PC3').AsString,[]) then
     Combo5.ItemIndex:= Combo5.Items.IndexOf(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
  Edit26.Text:=dbPedi.FieldByName('PC4').AsString;//----- N. Pedido
  if Edit24.Text='' then begin DataModule1.Mensaje('Información','Falta proveedor para el pedido', 2000 , clGray); exit; end;
  //----------- Cabeceras
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM pedicc'+Tienda+' WHERE PC0='+NTienda+
                      ' AND PC1="'+FormatDateTime('YYYY-MM-DD',DateEdit1.Date)+'"'+
                      ' AND PC2='+Edit24.Text+
                      ' AND PC3="'+trim(copy(Combo5.Items.Strings[Combo5.ItemIndex],1,3))+'"'+
                      ' AND PC4='+Edit26.Text;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then begin DataModule1.Mensaje('Información','No existe el pedido seleccionado', 2000 , clGray); exit; end;
  if dbTrabajo.FieldByName('PC14').AsString<>Edit1.Text then
    if Application.MessageBox('EL CLIENTE DEL PEDIDO ES DISTINTO AL SELECCIONADO, CONTINUAR?','FacturLinEx', boxstyle) = IDNO Then
       Exit;
  dbTrabajo.Edit;
  dbTrabajo.FieldByName('PC5').AsInteger:=dbTrabajo.FieldByName('PC5').AsInteger+ dbVentas.RecordCount;//-- N. Lineas
  dbTrabajo.FieldByName('PC9').AsFloat:=dbTrabajo.FieldByName('PC9').AsFloat+StrToFloat(StaticText1.Caption);//---- Importe
  dbTrabajo.FieldByName('PC17').AsFloat:=dbTrabajo.FieldByName('PC17').AsFloat+StrToFloat(Edit19.Text);//---------- Total
  dbTrabajo.FieldByName('PC18').AsFloat:=dbTrabajo.FieldByName('PC18').AsFloat+StrToFloat(Edit20.Text);//---------- Entrega
  dbTrabajo.FieldByName('PC19').AsFloat:=dbTrabajo.FieldByName('PC19').AsFloat+StrToFloat(Edit23.Text);//---------- Resto
  try
    dbTrabajo.Post;
  except
    on EDB: EDatabaseError do
    begin
      Showmessage('Error : ' + EDB.Message);
    end;
  end;
  dbTrabajo.Active:=False;
  //------------ Detalles
  dbPedid.Active:=False;
  dbPedid.SQL.Text:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+NTienda+
                      ' AND PD1="'+FormatDateTime('YYYY-MM-DD',DateEdit1.Date)+'"'+
                      ' AND PD2='+Edit24.Text+
                      ' AND PD3="'+trim(copy(Combo5.Items.Strings[Combo5.ItemIndex],1,3))+'"'+
                      ' AND PD4='+Edit26.Text;
  dbPedid.Active:=True;
  dbVentas.First;
  while not dbVentas.EOF do
    begin
      dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbVentas.FieldByName('V3').AsString+'"';
      dbArti.Active:=True;
      dbPedid.Append; RellenaPedidd(); 
      try
        dbPedid.Post;
      except
        on EDB: EDatabaseError do
        begin
          Showmessage('Error : ' + EDB.Message);
        end;
      end;
      dbVentas.Next;
    end;
  dbTrabajo.Active:=False; dbPedid.Active:=False; dbPedi.Active:=False;
  BitBtn28Click(BitBtn28);//----- Cerrar pedidos
  BitBtn15Click(BitBtn15, false);//--- Borrar todas las lineas de venta
  dbVentas.Refresh; Edit1.Text:=ClienteVario; Edit1Exit(Edit1);
  PintarTotalGeneral();
  RefrescaTicketsAbiertos();
  Edit3.SetFocus;
end;

//------------------- Cabecera de pedidos ---------------
procedure TFVentas.RellenaPedicc();
begin
  dbTrabajo.FieldByName('PC0').AsString:=NTienda;//---------------- N. Tienda
  dbTrabajo.FieldByName('PC1').AsDateTime:=DateEdit1.Date;//------- Fecha
  dbTrabajo.FieldByName('PC2').AsString:=Edit24.Text;//------------ Proveedor
  dbTrabajo.FieldByName('PC3').AsString:=trim(copy(Combo5.Items.Strings[Combo5.ItemIndex],1,3));// Serie Pedido
  dbTrabajo.FieldByName('PC4').AsString:=Edit26.Text;//------------ N. Pedido
  dbTrabajo.FieldByName('PC5').AsInteger:=dbVentas.RecordCount;//-- N. Lineas
{ TODO : Falta ponerle los costos al pedido }
  dbTrabajo.FieldByName('PC8').AsString:=StaticText1.Caption;//---- Importe Costo
  dbTrabajo.FieldByName('PC9').AsString:=StaticText1.Caption;//---- Importe PVP

  dbTrabajo.FieldByName('PC10').AsString:='N';//------------------- Transmitido
  dbTrabajo.FieldByName('PC11').AsString:='';//-------------------- Tipo Transm.
  dbTrabajo.FieldByName('PC12').AsString:='';//-------------------- Destino
  dbTrabajo.FieldByName('PC13').AsString:=Edit25.Text;//----------- Nombre Proveedor
  if CheckBox2.Checked=True then
    begin
     dbTrabajo.FieldByName('PC14').AsString:=Edit1.Text;//----------- Cgo. Cliente
     dbTrabajo.FieldByName('PC15').AsString:=Edit17.Text;//---------- Nombre Cliente
     dbTrabajo.FieldByName('PC16').AsString:=Edit18.Text;//---------- Telefono Cliente
     dbTrabajo.FieldByName('PC17').AsString:=Edit19.Text;//---------- Total
     dbTrabajo.FieldByName('PC18').AsString:=Edit20.Text;//---------- Entrega
     dbTrabajo.FieldByName('PC19').AsString:=Edit23.Text;//---------- Resto
    end;
  dbTrabajo.FieldByName('PC28').AsString:='P';//---------- Pedido
end;

//------------------- Detalle de pedidos ---------------
procedure TFVentas.RellenaPedidd();
begin
  dbPedid.FieldByName('PD0').AsString:=NTienda;//---------------- N. Tienda
  dbPedid.FieldByName('PD1').AsDateTime:=DateEdit1.Date;//------- Fecha
  dbPedid.FieldByName('PD2').AsString:=Edit24.Text;//------------ Proveedor
  dbPedid.FieldByName('PD3').AsString:=trim(copy(Combo5.Items.Strings[Combo5.ItemIndex],1,3));//- Serie Pedido
  dbPedid.FieldByName('PD4').AsString:=Edit26.Text;//------------ N. Pedido
  dbPedid.FieldByName('PD5').AsInteger:=VerUltimaLineaP;//------- N. Linea
  dbPedid.FieldByName('PD6').Value:=dbVentas.FieldByName('V3').Value;//---- Codigo articulo
  dbPedid.FieldByName('PD7').Value:=dbVentas.FieldByName('V4').Value;//---- Descripcion
  dbPedid.FieldByName('PD8').Value:=dbVentas.FieldByName('V5').Value;//---- Unidades
  dbPedid.FieldByName('PD9').AsString:='0';//------------------------------ Bonificaciones
  dbPedid.FieldByName('PD10').Value:=dbArti.FieldByName('A24').AsFloat;//---- Precio de costo (Sin Iva)
  dbPedid.FieldByName('PD11').Value:=dbArti.FieldByName('A26').AsFloat;//---- Margen
  dbPedid.FieldByName('PD12').AsString:=dbVentas.FieldByName('V7').Value;//-- Precio venta(Sin Iva)
  dbPedid.FieldByName('PD13').AsString:='0';//------------------------------- Recargo de equivalencia
  dbPedid.FieldByName('PD14').Value:=dbVentas.FieldByName('V10').Value;//---- Tipo de iva
  dbPedid.FieldByName('PD15').Value:=(dbArti.FieldByName('A24').AsFloat*dbVentas.FieldByName('V10').Value/100)+dbArti.FieldByName('A24').AsFloat;//---------- Precio de costo (Con Iva)
  dbPedid.FieldByName('PD16').AsString:=dbVentas.FieldByName('V6').Value;//-- Precio venta(Con Iva+Recarg)
  //-- Importe total de costo (Con Iva)
  dbPedid.FieldByName('PD17').AsString:=dbVentas.FieldByName('V5').Value*
                                       ((dbArti.FieldByName('A24').AsFloat*
                                        dbVentas.FieldByName('V10').Value/100)
                                        +dbArti.FieldByName('A24').AsFloat);
  //------------------------------------
  dbPedid.FieldByName('PD18').Value:=dbVentas.FieldByName('V11').Value;//---- Importe PVP (Con Iva)
  dbPedid.FieldByName('PD19').AsString:=dbArti.FieldByName('A14').AsString;//- Familia
  dbPedid.FieldByName('PD20').AsString:=dbArti.FieldByName('A4').AsString;//-- Stock actual en el momento de pedir

  dbPedid.FieldByName('PD21').AsString:='0';//---------- Unidades vendidas de X a X año actual
  dbPedid.FieldByName('PD22').AsString:='0';//---------- Unidades vendidas de X a X año anterior

  dbPedid.FieldByName('PD23').AsString:='S';//---------- Recibido S/N
  dbPedid.FieldByName('PD24').AsString:='';//----------- Serie de colores
  dbPedid.FieldByName('PD25').AsString:='';//----------- Serie de tallas
end;

//=================== SACAR EL ULT N. DE LINEA =====================
function TFVentas.VerUltimaLineaP: Integer;
begin
  VerUltimaLineaP:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(PD5) As ULTIMA FROM pedidd'+Tienda+' WHERE PD0='+NTienda+
                      ' AND PD1="'+FormatDateTime('YYYY-MM-DD',DateEdit1.Date)+'"'+
                      ' AND PD2='+Edit24.Text+
                      ' AND PD3="'+trim(copy(Combo5.Items.Strings[Combo5.ItemIndex],1,3))+'"'+
                      ' AND PD4='+Edit26.Text;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLineaP:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;

//------------------------------------------------
//--------------- Recuperar pedido ---------------
//------------------------------------------------
procedure TFVentas.BitBtn31Click(Sender: TObject);
begin
 if (dbHiPedic.RecordCount=0) or (dbHiPedic.Eof) then begin DataModule1.Mensaje('Información','No hay pedidos a recuperar', 2000 , clGray); exit; end;
 if dbVentas.RecordCount<>0 then
   if Application.MessageBox('ESTA PANTALLA DE VENTAS YA TIENE LINEAS, CONTINUAR?','FacturLinEx', boxstyle) = IDNO then exit;
 dbHipedid.Active:=False;
 dbHipedid.SQL.Text:='SELECT * FROM hipedidd'+Tienda+' WHERE '+
   'HPD0='+dbHipedic.FieldByName('HPC0').AsString+
   ' AND HPD1="'+FormatDateTime('YYYY-MM-DD',dbHipedic.FieldByName('HPC1').AsDateTime)+'"'+
   ' AND HPD2='+dbHipedic.FieldByName('HPC2').AsString+
   ' AND HPD3="'+dbHipedic.FieldByName('HPC3').AsString+'"'+
   ' AND HPD4='+dbHipedic.FieldByName('HPC4').AsString;
 dbHipedid.Active:=True;
 if dbHipedid.RecordCount=0 then begin DataModule1.Mensaje('Información','Ese pedido no tiene líneas', 2000 , clGray); Exit; end;
 if Application.MessageBox('SE RECUPERARA EL PEDIDO SELECCIONADO, CONTINUAR?','FacturLinEx', boxstyle) = IDNO then exit;
 dbHipedid.First;
 while not dbHiPedid.EOF do
  begin
    dbVentas.Append;
    dbVentas.FieldByName('V0').AsString:='0';//------------------------ N. Ticket
    dbVentas.FieldByName('V1').AsString:=TICKET;//--------------------- Cgo. Vendedor
    dbVentas.FieldByName('V2').AsInteger:=VerUltimaLineaV;//------------------------ N. Linea
    dbVentas.FieldByName('V3').Value:=dbHipedid.FieldByName('HPD6').Value;//-- Codigo
    dbVentas.FieldByName('V4').Value:=dbHipedid.FieldByName('HPD7').Value;//-- Descripción
    dbVentas.FieldByName('V5').Value:=dbHipedid.FieldByName('HPD8').Value;//-- Unidades
    dbVentas.FieldByName('V6').Value:=dbHipedid.FieldByName('HPD16').Value;//- P.V.P.
    dbVentas.FieldByName('V7').Value:=dbHipedid.FieldByName('HPD12').Value;//- Precio
    dbVentas.FieldByName('V8').AsString:='0';//------------------------------- Descuento
    dbVentas.FieldByName('V9').Value:=dbHipedid.FieldByName('HPD17').Value;//- Importe
    dbVentas.FieldByName('V10').Value:=dbHipedid.FieldByName('HPD14').Value;//-Iva
    dbVentas.FieldByName('V11').Value:=dbHipedid.FieldByName('HPD18').Value;//-Total Linea
    dbVentas.FieldByName('V12').Value:=dbHipedic.FieldByName('HPC14').Value;//-Cgo. Cliente
    dbVentas.FieldByName('V14').AsDateTime:=Date;//---------------------------- Fecha actual
    dbVentas.FieldByName('V15').AsDateTime:=Time;//---------------------------- Hora Actual
    try
      dbVentas.Post;
    except
      on EDB: EDatabaseError do
      begin
        Showmessage('Error : ' + EDB.Message);
      end;
    end;
    dbHipedid.Next;
  end;
 //---------- Marcar pedido como solo recuperado y poner marca
 dbHipedic.Edit;
 dbHipedic.FieldByName('HPC39').AsString:='S';
 try
  dbHipedic.Post;
 except
   on EDB: EDatabaseError do
   begin
     Showmessage('Error : ' + EDB.Message);
   end;
 end;
 OperacionRecuperada:='P';
 ClaveRecuperada:='HPC0='+dbHipedic.FieldByName('HPC0').AsString+
   ' AND HPC1="'+FormatDateTime('YYYY-MM-DD',dbHipedic.FieldByName('HPC1').AsDateTime)+'"'+
   ' AND HPC2='+dbHipedic.FieldByName('HPC2').AsString+
   ' AND HPC3="'+dbHipedic.FieldByName('HPC3').AsString+'"'+
   ' AND HPC4='+dbHipedic.FieldByName('HPC4').AsString;
 //--------------------------------------
 Edit1.Text:=dbHipedic.FieldByName('HPC14').AsString; Edit1Exit(Edit1);
 BitBtn28Click(BitBtn28);//---- Ocultar panel
 PintarTotalGeneral();//------- Pintar total
 RefrescaTicketsAbiertos();//----- Refrescar total tickets abiertos
 DataModule1.Mensaje('Información','Pedido recuperado correctamente', 2000 , clGray);
end;

//---------------- Actualizar datos del pedido al -------------
//---------------- totalizar la operacion en ventas -----------
procedure TFVentas.Actualizapedido();
begin
 dbHipedic.Active:=False;
 dbHipedic.SQL.Text:='SELECT * FROM hipedicc'+Tienda+' WHERE '+ClaveRecuperada;
 dbHipedic.Active:=True;
 dbHipedic.Edit;
 dbHipedic.FieldByName('HPC39').AsString:=TIPOOPER;//---- Tipo de operacion
 dbHipedic.FieldByName('HPC40').Value:=FechaVenta;//----- Fecha operación
 dbHipedic.FieldByName('HPC41').AsString:=SERIEFACT;//--- Serie
 dbHipedic.FieldByName('HPC42').Value:=NOPERACION;//----- Numero
 try
  dbHipedic.Post;
 except
   on EDB: EDatabaseError do
   begin
     Showmessage('Error : ' + EDB.Message);
   end;
 end;
 dbHipedic.Active:=False; dbHipedid.Active:=False;
end;

//-------------- Cliente de pedidos a recuperar --------
procedure TFVentas.Edit27Exit(Sender: TObject);
begin
  if Edit27.Text='' then exit;
  dbClientes.Active:=False;
  dbClientes.SQl.Text:='SELECT * FROM clientes WHERE C0='+Edit27.Text;
  dbClientes.Active:=True;
  if dbClientes.RecordCount=0 then
   begin
     DataModule1.Mensaje('Información','No existe ese cliente', 2000 , clGray); Edit1.SetFocus; Exit;
   end;
  Edit28.Text:=dbClientes.FieldByName('C1').AsString;//----- Nombre
  //-------------------------- Hist. de pedidos
  dbHiPedic.Active:=False;
  dbHiPedic.SQL.Text:='SELECT * FROM hipedicc'+Tienda+' WHERE HPC14='+Edit27.Text+
                      ' AND HPC39="SV"'+
                      ' ORDER BY HPC0 ASC, HPC1 DESC, HPC2 ASC, HPC3 ASC, HPC4 DESC';
  dbHiPedic.Active:=True;
  DBGrid4.SetFocus;
end;

//--------- Buscar cliente a recuperar --------
procedure TFVentas.BitBtn32Click(Sender: TObject);
begin
  if Edit28.Text='' then begin DataModule1.Mensaje('Información','Debe teclear comienzo de texto a buscar', 2000 , clGray); Edit28.SetFocus; Exit; end;
  Edit27.Text := FBusquedas.IniciaBusquedas('SELECT C0, C1, C2 FROM clientes WHERE C1 LIKE "'+Edit28.Text+'%"',
           ['Codigo', ' Razón social ', ' Dirección ' ], 'C0' );
  if Edit27.Text<>'' then begin Edit27Exit(Edit27); end;
end;
procedure TFVentas.Edit28KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then BitBtn32Click(BitBtn32);
end;

procedure TFVentas.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if Key = Char(VK_RETURN) then BitBtn1.Click;
end;

//--------------- Mostrar crear/añadir pedidos -------------------
procedure TFVentas.TabSheet1Show(Sender: TObject);
begin
  BitBtn27.Enabled:=True; BitBtn30.Enabled:=True;
  BitBtn31.Enabled:=False;
  Label45.Caption:='REALIZAR PEDIDO DE LA VENTA ACTUAL';
end;

//--------------- Mostrar recuperar pedidos -------------------
procedure TFVentas.TabSheet2Show(Sender: TObject);
begin
  BitBtn27.Enabled:=False; BitBtn30.Enabled:=False;
  BitBtn31.Enabled:=True;
  Label45.Caption:='RECUPERAR EL PEDIDO DE UN CLIENTE';
end;


//---------- Todos los pedidos de clientes
procedure TFVentas.RadioButton3Click(Sender: TObject);
begin
 Edit27.Visible:=False; Edit28.Visible:=False; BitBtn32.Visible:=False;
 Label1.Visible:=False; Label57.Visible:=False;
 //-------------------------- Hist. de pedidos
 dbHiPedic.Active:=False;
 dbHiPedic.SQL.Text:='SELECT * FROM hipedicc'+Tienda+' WHERE HPC14<>0'+
                     ' ORDER BY HPC0 ASC, HPC1 DESC, HPC2 ASC, HPC3 ASC, HPC4 DESC';
 dbHiPedic.Active:=True;
end;
//---------- Pedidos de un cliente
procedure TFVentas.RadioButton4Click(Sender: TObject);
begin
 Edit27.Visible:=True; Edit28.Visible:=True; BitBtn32.Visible:=True;
 Label1.Visible:=True; Label57.Visible:=True;
 Edit27.Text:=''; Edit28.Text:=''; Edit27.SetFocus;
end;
//---------- Todos los pedidos de clientes despachados
procedure TFVentas.RadioButton5Click(Sender: TObject);
begin
 Edit27.Visible:=False; Edit28.Visible:=False; BitBtn32.Visible:=False;
 Label1.Visible:=False; Label57.Visible:=False;
 //-------------------------- Hist. de pedidos
 dbHiPedic.Active:=False;
 dbHiPedic.SQL.Text:='SELECT * FROM hipedicc'+Tienda+' WHERE HPC14<>0 AND HPC39<>"SV"'+
                     ' ORDER BY HPC0 ASC, HPC1 DESC, HPC2 ASC, HPC3 ASC, HPC4 DESC';
 dbHiPedic.Active:=True;
end;


//===================================================================
//==================== PRESUPUESTOS PROFORMAS =======================
//===================================================================
procedure TFVentas.BitBtn22Click(Sender: TObject);
begin
  RadioButton9.Checked:=True;
  Bloquear();//------- Bloquear controles
  //--- Ver si se pueden crear las lineas de la venta como pre/pro o no
  if dbVentas.RecordCount=0 then begin BitBtn35.Enabled:=False; BitBtn37.Enabled:=False; end
     else begin BitBtn35.Enabled:=True; BitBtn37.Enabled:=True; end;
  //--------------
  Panel10.Visible:=True;
  Edit34.Text:=dbClientes.FieldByName('C0').AsString;//----- Cgo Cliente
  Edit33.Text:=dbClientes.FieldByName('C1').AsString;//----- Nombre del cliente.
  Edit36.Text:=dbClientes.FieldByName('C3').AsString;//----- Dirección cliente
  Edit30.Text:=dbClientes.FieldByName('C6').AsString;//----- Telefono del cliente.
  //--- Ver la tienda activa para saber que serie usa por defecto
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin DataModule1.Mensaje('Información','No sé en qué tienda facturar', 2000 , clGray); Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin DataModule1.Mensaje('Información','Debe crear SERIE de facturación', 2000 , clGray); exit; end;
  dbSeries.First; Combo6.Items.Clear;
  while not dbSeries.EOF do
    begin
     Combo6.Items.Add(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
     dbSeries.Next;
    end;
  dbSeries.Locate('SF0', dbTiendas.Fields[11].AsString, [loCaseInsensitive]);
  Combo6.ItemIndex:= Combo6.Items.IndexOf(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
  Edit35.Text:=IntToStr(dbSeries.FieldByName('SF6').AsInteger+1);
  dbTiendas.Active:=False;
  //-------------------------- Presupuestos sin servir
  dbPedi.Active:=False;
  dbPedi.SQL.Text:='SELECT * FROM presuc'+Tienda+', clientes'+
                   ' WHERE PRC0=C0 AND PRC12="SV"'+
                   ' ORDER BY PRC0 ASC, PRC1 DESC, PRC2 ASC, PRC3 ASC';
  dbPedi.Active:=True;
  DateEdit2.Date:=Date;
end;

//----------------- Cambiar N.Pre/Pro al moverse por el combo -------------
procedure TFVentas.Combo6Change(Sender: TObject);
begin
  if dbSeries.Locate('SF0',trim(copy(Combo6.Items.Strings[Combo6.ItemIndex],1,3)),[]) then
    if Radiobutton9.Checked=True then
      Edit26.Text:=IntToStr(dbSeries.FieldByName('SF6').AsInteger+1);//--- N.Presp.
    if Radiobutton10.Checked=True then
      Edit26.Text:=IntToStr(dbSeries.FieldByName('SF8').AsInteger+1);//--- N.Porfor.
end;

//---------------- Salir de Presupuesto / proforma ---------------
procedure TFVentas.BitBtn36Click(Sender: TObject);
begin
  dbHipedic.Active:=False; dbHipedid.Active:=False;
  Panel10.Visible:=False;
  Desbloquear();
end;

//------------------ Seleccionar cliente de la venta --------------
procedure TFVentas.CheckBox3Change(Sender: TObject);
begin
  if CheckBox3.Checked=true then
    begin
     Edit34.Text:=dbClientes.FieldByName('C0').AsString;//----- Cgo Cliente
     Edit33.Text:=dbClientes.FieldByName('C1').AsString;//----- Nombre del cliente.
     Edit36.Text:=dbClientes.FieldByName('C3').AsString;//----- Dirección cliente
     Edit30.Text:=dbClientes.FieldByName('C6').AsString;//----- Telefono del cliente.
    end;
end;

//--------------------------------------------------------
//----------------- Cambiar entre pre/pro ----------------
//--------------------------------------------------------
//---------------- Presupuesto
procedure TFVentas.RadioButton9Click(Sender: TObject);
begin
  Label63.Caption:='PRESUPUESTOS ACTUALES';
  Label65.Caption:='FECHA PRESUP.';
  Label67.Caption:='N. PRESUP.';
  BitBtn35.Caption:='Nuevo presup.';
  BitBtn37.Caption:='Añadir al presup.';
  BitBtn38.Caption:='Recuperar presup.';
  //-------------------------- Presupuestos sin servir
  dbPedi.Active:=False;
  dbPedi.SQL.Text:='SELECT * FROM presuc'+Tienda+', clientes'+
                   ' WHERE PRC0=C0 AND PRC12="SV"'+
                   ' ORDER BY PRC0 ASC, PRC1 DESC, PRC2 ASC, PRC3 ASC';
  dbPedi.Active:=True;
  //----------------- N. presupuesto
  if dbSeries.Locate('SF0',trim(copy(Combo6.Items.Strings[Combo6.ItemIndex],1,3)),[]) then
      Edit26.Text:=IntToStr(dbSeries.FieldByName('SF6').AsInteger+1);//--- N.Presp.
end;

//---------------- Proforma
procedure TFVentas.RadioButton10Click(Sender: TObject);
begin
  Label63.Caption:='PROFORMAS ACTUALES';
  Label65.Caption:='FECHA PROFOR.';
  Label67.Caption:='N. PROFOR.';
  BitBtn35.Caption:='Nueva profor.';
  BitBtn37.Caption:='Añadir a la profor.';
  BitBtn38.Caption:='Recuperar profor.';
  //-------------------------- Proformas sin servir
  dbPedi.Active:=False;
  dbPedi.SQL.Text:='SELECT * FROM proforc'+Tienda+', clientes'+
                   ' WHERE PRC0=C0 AND PRC12="SV"'+
                   ' ORDER BY PRC0 ASC, PRC1 DESC, PRC2 ASC, PRC3 ASC';
  dbPedi.Active:=True;
  //----------------- N. proforma
  if dbSeries.Locate('SF0',trim(copy(Combo6.Items.Strings[Combo6.ItemIndex],1,3)),[]) then
      Edit26.Text:=IntToStr(dbSeries.FieldByName('SF8').AsInteger+1);//--- N.Porfor.
end;

//------------ DOBLE CLICK EN PRE/PRO -> MOSTRAR DATOS DEL PRE/PRO -------------
procedure TFVentas.DBGrid5DblClick(Sender: TObject);
begin
  if dbPedi.RecordCount=0 then exit;
  DateEdit2.Date:=dbPedi.FieldByName('PRC1').AsDateTime;
  if dbSeries.Locate('SF0',dbPedi.FieldByName('PRC2').AsString,[]) then
     Combo6.ItemIndex:= Combo6.Items.IndexOf(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);//--- Serie Pedido
  Edit35.Text:=dbPedi.FieldByName('PRC3').AsString;//---- N. Pre/Pro

  Edit34.Text:=dbPedi.FieldByName('PRC0').AsString;//---- Cgo Cliente
  Edit33.Text:=dbPedi.FieldByName('C1').AsString;//----- Nombre cliente
  Edit36.Text:=dbPedi.FieldByName('C3').AsString;//----- Dirección cliente
  Edit30.Text:=dbPedi.FieldByName('C6').AsString;//----- Telefono del cliente.
  CheckBox3.Checked:=False;
end;


//------------------------- CREAR NUEVO PRE/PRO -----------------------
procedure TFVentas.BitBtn35Click(Sender: TObject);
begin
  if dbVentas.RecordCount=0 then begin DataModule1.Mensaje('Información','No hay líneas para crear presupuestos o proformas', 2000 , clGray); exit; end;
  If Application.MessageBox('CREAR UN NUEVO PRESUPUESTO/PROFORMA CON ESTAS LINEAS?','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  //--------- Distinguir entre pre/pro
  if RadioButton9.Checked=true then begin TablaPreProc:='presuc'; TablaPreProd:='presud'; end
  else begin TablaPreProc:='proforc'; TablaPreProd:='proford'; end;
  //---------------- Seleccionar cabeceras de pre/pro
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM '+TablaPreProc+Tienda+' WHERE PRC0='+Edit34.Text+
                      ' AND PRC1="'+FormatDateTime('YYYY-MM-DD',DateEdit2.Date)+'"'+
                      ' AND PRC2="'+trim(copy(Combo6.Items.Strings[Combo6.ItemIndex],1,3))+'"'+
                      ' AND PRC3='+Edit35.Text;
  dbTrabajo.Active:=True;
  dbTrabajo.Append; RellenaPreProcc(); 
   try
     dbTrabajo.Post;
   except
     on EDB: EDatabaseError do
     begin
       Showmessage('Error : ' + EDB.Message);
     end;
   end;
  //------------ Aumentar N. Pre/Pro
  if TablaPreProc='presuc' then NumeroPresupuesto() else NumeroProforma();
  //---------------- Seleccionar detalles de pre/pro
  dbPedid.Active:=False;
  dbPedid.SQL.Text:='SELECT * FROM '+TablaPreProd+Tienda+' WHERE PRD0='+Edit34.Text+
                      ' AND PRD1="'+FormatDateTime('YYYY-MM-DD',DateEdit2.Date)+'"'+
                      ' AND PRD2="'+trim(copy(Combo6.Items.Strings[Combo6.ItemIndex],1,3))+'"'+
                      ' AND PRD3='+Edit35.Text;
  dbPedid.Active:=True;

  //---- Recorremos las ventas grabando las lineas de dettalles
  dbVentas.First;
  while not dbVentas.EOF do
    begin
      dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbVentas.FieldByName('V3').AsString+'"';
      dbArti.Active:=True;
      dbPedid.Append; RellenaPreProdd(); 
      
      try
        dbPedid.Post;
      except
        on EDB: EDatabaseError do
        begin
          Showmessage('Error : ' + EDB.Message);
        end;
      end;
      dbVentas.Next;
    end;
  If Application.MessageBox('QUIERE IMPRIMIR EL PRESUPUESTO/PROFORMA GENERADO?','FacturLinEx', boxstyle) = IDYes Then
     ImprimirPresupuesto();
  dbTrabajo.Active:=False; dbPedid.Active:=False; dbPedi.Active:=False;
  BitBtn36Click(BitBtn36);//----- Cerrar pre/pro
  BitBtn15Click(BitBtn15, false);//--- Borrar todas las lineas de venta
  dbVentas.Refresh; Edit1.Text:=ClienteVario; Edit1Exit(Edit1);
  PintarTotalGeneral();
  RefrescaTicketsAbiertos();
  Edit3.SetFocus;
end;

//------------------------- AÑADIR A UN PRE/PRO -----------------------
procedure TFVentas.BitBtn37Click(Sender: TObject);
begin
  if dbVentas.RecordCount=0 then begin DataModule1.Mensaje('Información','No hay líneas para crear presupuestos o proformas', 2000 , clGray); exit; end;
  if dbPedi.RecordCount=0 then begin DataModule1.Mensaje('Información','No hay presupuestos o proformas creados', 2000 , clGray); exit; end;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('AÑADIR ESTA LINEAS AL PRE/PRO SELECCIONADO?','FacturLinEx2', boxstyle) = IDNO Then
      Exit;
  DateEdit2.Date:=dbPedi.FieldByName('PRC1').AsDateTime;
  Edit34.Text:=dbPedi.FieldByName('PRC0').AsString;
  ////////Edit34Exit(Edit24);
  if dbSeries.Locate('SF0',dbPedi.FieldByName('PRC2').AsString,[]) then
     Combo6.ItemIndex:= Combo6.Items.IndexOf(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
  Edit35.Text:=dbPedi.FieldByName('PRC3').AsString;//----- N. Pedido
  if Edit34.Text='' then begin DataModule1.Mensaje('Información','Falta cliente para presupuesto o proforma', 2000 , clGray); exit; end;
  //--------- Distinguir entre pre/pro
  if RadioButton9.Checked=true then begin TablaPreProc:='presuc'; TablaPreProd:='presud'; end
  else begin TablaPreProc:='proforc'; TablaPreProd:='proford'; end;
  //----------- Cabeceras
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM '+TablaPreProc+Tienda+' WHERE PRC0='+Edit34.Text+
                      ' AND PRC1="'+FormatDateTime('YYYY-MM-DD',DateEdit2.Date)+'"'+
                      ' AND PRC2="'+trim(copy(Combo6.Items.Strings[Combo6.ItemIndex],1,3))+'"'+
                      ' AND PRC3='+Edit35.Text;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then begin DataModule1.Mensaje('Información','El presupuesto / proforma seleccionado no existe', 2000 , clGray); exit; end;

  if dbTrabajo.FieldByName('PRC0').AsString<>Edit34.Text then
    if Application.MessageBox('EL CLIENTE DEL PRE/PRO ES DISTINTO AL SELECCIONADO, CONTINUAR?','FacturLinEx2', boxstyle) = IDNO Then
       Exit;
  dbTrabajo.Edit;
  dbTrabajo.FieldByName('PRC4').AsInteger:=dbTrabajo.FieldByName('PRC4').AsInteger+dbVentas.RecordCount;//-- N. Lineas
  dbTrabajo.FieldByName('PRC5').AsInteger:=dbTrabajo.FieldByName('PRC5').AsInteger+dbVentas.RecordCount;//-- N. Articulos
  dbTrabajo.FieldByName('PRC6').Value:=dbClientes.FieldByName('C18').Value;//--- Dto. Pronto Pago
  dbTrabajo.FieldByName('PRC7').AsString:=dbClientes.FieldByName('C19').AsString;//--- Recargo Equivalencia
  dbTrabajo.FieldByName('PRC8').AsFloat:=dbTrabajo.FieldByName('PRC8').AsFloat+StrToFloat(StaticText1.Caption);//---- Importe Sin Iva
  dbTrabajo.FieldByName('PRC9').AsFloat:=dbTrabajo.FieldByName('PRC9').AsFloat+StrToFloat(StaticText1.Caption);//---- Importe Con Iva
  try
    dbTrabajo.Post;
  except
    on EDB: EDatabaseError do
    begin
      Showmessage('Error : ' + EDB.Message);
    end;
  end;
  dbTrabajo.Active:=False;
  //------------ Detalles
  dbPedid.Active:=False;
  dbPedid.SQL.Text:='SELECT * FROM '+TablaPreProd+Tienda+' WHERE PRD0='+Edit34.Text+
                      ' AND PRD1="'+FormatDateTime('YYYY-MM-DD',DateEdit2.Date)+'"'+
                      ' AND PRD2="'+trim(copy(Combo6.Items.Strings[Combo6.ItemIndex],1,3))+'"'+
                      ' AND PRD3='+Edit35.Text;
  dbPedid.Active:=True;
  dbVentas.First;
  while not dbVentas.EOF do
    begin
      dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbVentas.FieldByName('V3').AsString+'"';
      dbArti.Active:=True;
      dbPedid.Append; RellenaPreProdd(); 
      try
        dbPedid.Post;
      except
        on EDB: EDatabaseError do
        begin
          Showmessage('Error : ' + EDB.Message);
        end;
      end;
      dbVentas.Next;
    end;
  If Application.MessageBox('QUIERE IMPRIMIR EL PRESUPUESTO/PROFORMA GENERADO?','FacturLinEx', boxstyle) = IDYes Then
     ImprimirPresupuesto();
  dbTrabajo.Active:=False; dbPedid.Active:=False; dbPedi.Active:=False;
  BitBtn36Click(BitBtn36);//----- Cerrar pre/pro
  BitBtn15Click(BitBtn15, false);//--- Borrar todas las lineas de venta
  dbVentas.Refresh; Edit1.Text:=ClienteVario; Edit1Exit(Edit1);
  PintarTotalGeneral();
  RefrescaTicketsAbiertos();
  Edit3.SetFocus;
end;

//------------------------- RECUPERAR UN PRE/PRO -----------------------
procedure TFVentas.BitBtn38Click(Sender: TObject);
var
  Texto: string;
begin
 //--------- Distinguir entre pre/pro
 if RadioButton9.Checked=true then
    begin TablaPreProc:='presuc'; TablaPreProd:='presud'; Texto:='PRESUPUESTOS'; end
 else
    begin TablaPreProc:='proforc'; TablaPreProd:='proford'; Texto:='PROFORMAS'; end;
 //-------------------------------
 if (dbPedi.RecordCount=0) or (dbPedi.Eof) then begin DataModule1.Mensaje('Información','No hay '+ texto + ' a recuperar', 2000 , clGray); exit; end;
 if dbVentas.RecordCount<>0 then
   if Application.MessageBox('ESTA PANTALLA DE VENTAS YA TIENE LINEAS, CONTINUAR?','FacturLinEx2', boxstyle) = IDNO then exit;
 dbpedid.Active:=False;
 dbpedid.SQL.Text:='SELECT * FROM '+TablaPreProd+Tienda+' WHERE '+
   'PRD0='+dbpedi.FieldByName('PRC0').AsString+
   ' AND PRD1="'+FormatDateTime('YYYY-MM-DD',dbpedi.FieldByName('PRC1').AsDateTime)+'"'+
   ' AND PRD2="'+dbpedi.FieldByName('PRC2').AsString+'"'+
   ' AND PRD3='+dbpedi.FieldByName('PRC3').AsString;
 dbpedid.Active:=True;
 if dbpedid.RecordCount=0 then begin DataModule1.Mensaje('Información','Este ' +Texto +' no tiene líneas', 2000 , clGray); Exit; end;
 if Application.MessageBox('SE RECUPERARA EL REGISTRO SELECCIONADO, CONTINUAR?','FacturLinEx2', boxstyle) = IDNO then exit;
 dbpedid.First;
 while not dbPedid.EOF do
  begin
    dbVentas.Append;
    dbVentas.FieldByName('V0').AsString:='0';//------------------------ N. Ticket
    dbVentas.FieldByName('V1').AsString:=TICKET;//--------------------- Cgo. Vendedor
    dbVentas.FieldByName('V2').AsString:=dbpedid.FieldByName('PRD4').Value;;//------------------------ N. Linea
    dbVentas.FieldByName('V3').Value:=dbpedid.FieldByName('PRD5').Value;//-- Codigo
    dbVentas.FieldByName('V4').Value:=LeftStr(dbpedid.FieldByName('PRD6').Value, 50);//-- Descripción
    dbVentas.FieldByName('V5').Value:=dbpedid.FieldByName('PRD7').Value;//-- Unidades
    dbVentas.FieldByName('V6').Value:=dbpedid.FieldByName('PRD8').Value;//- P.V.P.
    dbVentas.FieldByName('V7').Value:=dbpedid.FieldByName('PRD9').Value;//- Precio
    dbVentas.FieldByName('V8').Value:=dbPedid.FieldByName('PRD10').Value;//- Descuento
    dbVentas.FieldByName('V9').Value:=dbpedid.FieldByName('PRD11').Value;//- Importe
    dbVentas.FieldByName('V10').Value:=dbpedid.FieldByName('PRD12').Value;//-Iva
    dbVentas.FieldByName('V11').Value:=dbpedid.FieldByName('PRD13').Value;//-Total Linea
    dbVentas.FieldByName('V12').Value:=dbpedid.FieldByName('PRD0').Value;//-Cgo. Cliente
    dbVentas.FieldByName('V14').AsDateTime:=Date;//---------------------------- Fecha actual
    dbVentas.FieldByName('V15').AsDateTime:=Time;//---------------------------- Hora Actual
    
    try
      dbVentas.Post;
    except
      on EDB: EDatabaseError do
      begin
        Showmessage('Error : ' + EDB.Message);
      end;
    end;
    dbpedid.Next;
  end;
 //---------- Marcar como solo recuperado y poner marca
 OperacionRecuperada:='PRE';
 ClaveRecuperada:='PRC0='+dbpedi.FieldByName('PRC0').AsString+
   ' AND PRC1="'+FormatDateTime('YYYY-MM-DD',dbpedi.FieldByName('PRC1').AsDateTime)+'"'+
   ' AND PRC2="'+dbpedi.FieldByName('PRC2').AsString+'"'+
   ' AND PRC3="'+dbpedi.FieldByName('PRC3').AsString+'"';
 dbpedi.Active:=False;
 dbpedi.SQL.Text:='SELECT * FROM '+TablaPreProc+Tienda+' WHERE '+ClaveRecuperada;
 dbpedi.Active:=True;
 dbpedi.Edit;
 dbpedi.FieldByName('PRC12').AsString:='S';
 try
   dbpedi.Post;
 except
   on EDB: EDatabaseError do
   begin
     Showmessage('Error : ' + EDB.Message);
   end;
 end;
 //--------------------------------------
 Edit1.Text:=dbpedi.FieldByName('PRC0').AsString; Edit1Exit(Edit1);
 BitBtn36Click(BitBtn36);//---- Ocultar panel
 PintarTotalGeneral();//------- Pintar total
 RefrescaTicketsAbiertos();//----- Refrescar total tickets abiertos
 DataModule1.Mensaje('Información',Texto +' recuperado correctamente', 2000 , clGray);
end;

//---------------- Actualizar datos del pre/pro al -------------
//---------------- totalizar la operacion en ventas -----------
procedure TFVentas.Actualizaprepro();
begin
 dbpedi.Active:=False;
 dbpedi.SQL.Text:='SELECT * FROM '+TablaPreProc+Tienda+' WHERE '+ClaveRecuperada;
 dbpedi.Active:=True;
 dbpedi.Edit;
 dbpedi.FieldByName('PRC12').AsString:=TIPOOPER;//---- Tipo de operacion
 dbpedi.FieldByName('PRC13').Value:=FechaVenta;//----- Fecha operación
 dbpedi.FieldByName('PRC14').AsString:=SERIEFACT;//--- Serie
 dbpedi.FieldByName('PRC15').Value:=NOPERACION;//----- Numero
 try
   dbpedi.Post;
 except
   on EDB: EDatabaseError do
   begin
     Showmessage('Error : ' + EDB.Message);
   end;
 end;
 dbpedi.Active:=False; dbpedid.Active:=False;
end;


//------------------- Cabecera de pre/pro ---------------
procedure TFVentas.RellenaPreProcc();
begin
  dbTrabajo.FieldByName('PRC0').AsString:=Edit34.Text;//------------ Cliente
  dbTrabajo.FieldByName('PRC1').AsDateTime:=DateEdit2.Date;//------- Fecha
  dbTrabajo.FieldByName('PRC2').AsString:=trim(copy(Combo6.Items.Strings[Combo6.ItemIndex],1,3));// Serie Pre/Pro
  dbTrabajo.FieldByName('PRC3').AsString:=Edit35.Text;//------------ N. Pre/Pro
  dbTrabajo.FieldByName('PRC4').AsInteger:=dbVentas.RecordCount;//-- N. Lineas
  dbTrabajo.FieldByName('PRC5').AsInteger:=dbVentas.RecordCount;//-- N. Articulos
  dbTrabajo.FieldByName('PRC6').Value:=dbClientes.FieldByName('C18').Value;//--- Dto. Pronto Pago
  dbTrabajo.FieldByName('PRC7').AsString:=dbClientes.FieldByName('C19').AsString;//--- Recargo Equivalencia
  dbTrabajo.FieldByName('PRC8').AsString:=StaticText1.Caption;//---- Importe Sin Iva
  dbTrabajo.FieldByName('PRC9').AsString:=StaticText1.Caption;//---- Importe Con Iva
  dbTrabajo.FieldByName('PRC10').AsString:='N';//------------------- Marcado S/N
end;

//------------------- Detalle de pre/pro ---------------
procedure TFVentas.RellenaPreProdd();
begin
  dbPedid.FieldByName('PRD0').AsString:=Edit34.Text;//------------ Cliente
  dbPedid.FieldByName('PRD1').AsDateTime:=DateEdit2.Date;//------- Fecha
  dbPedid.FieldByName('PRD2').AsString:=trim(copy(Combo6.Items.Strings[Combo6.ItemIndex],1,3));//- Serie
  dbPedid.FieldByName('PRD3').AsString:=Edit35.Text;//------------ N. Pre/pro
  dbPedid.FieldByName('PRD4').AsInteger:=VerUltimaLineaPP;//--------------------- N. Linea
  dbPedid.FieldByName('PRD5').Value:=dbVentas.FieldByName('V3').Value;//---- Codigo articulo
  dbPedid.FieldByName('PRD6').Value:=dbVentas.FieldByName('V4').Value;//---- Descripcion
  dbPedid.FieldByName('PRD7').Value:=dbVentas.FieldByName('V5').Value;//---- Unidades
  dbPedid.FieldByName('PRD8').Value:=dbVentas.FieldByName('V6').AsString;//- P.V.P.
  dbPedid.FieldByName('PRD9').Value:=dbVentas.FieldByName('V7').AsString;//- Precio
  dbPedid.FieldByName('PRD10').Value:=dbVentas.FieldByName('V8').AsString;//-Descuento
  dbPedid.FieldByName('PRD11').Value:=dbVentas.FieldByName('V9').AsString;//-Importe
  dbPedid.FieldByName('PRD12').Value:=dbVentas.FieldByName('V10').AsString;//-Iva
  dbPedid.FieldByName('PRD13').Value:=dbVentas.FieldByName('V11').AsString;//-Total Linea
end;

//=================== SACAR EL ULT N. DE LINEA =====================
function TFVentas.VerUltimaLineaPP: Integer;
begin
  VerUltimaLineaPP:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(PRD4) As ULTIMA FROM '+TablaPreProd+Tienda+' WHERE PRD0='+Edit34.Text+
                      ' AND PRD1="'+FormatDateTime('YYYY-MM-DD',DateEdit2.Date)+'"'+
                      ' AND PRD2="'+trim(copy(Combo6.Items.Strings[Combo6.ItemIndex],1,3))+'"'+
                      ' AND PRD3='+Edit35.Text;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLineaPP:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;

//============= IMPRIMIR PRESUPUESTO / PROFORMA ===============
procedure TFVentas.ImprimirPresupuesto();
var
 // TipoDocumento: String;
  TxtQ: String;
  Numero: Integer;
begin

  frDBDataSet1.DataSet:=dbMuestrad;
  IMPOIVA1:=0; BASE1:=0; TOTAL1:=0; IRIVA1:=0; PIVA1:=0; PRIVA1:=0;
  IMPOIVA2:=0; BASE2:=0; TOTAL2:=0; IRIVA2:=0; PIVA2:=0; PRIVA2:=0;
  IMPOIVA3:=0; BASE3:=0; TOTAL3:=0; IRIVA3:=0; PIVA3:=0; PRIVA3:=0;
    //--------------- Sacar distintos ivas ------------------
  TxtQ:='SELECT DISTINCT(PRD12), (SUM(PRD13-PRD11)) As Ivas, '+
        'SUM(PRD11) As Bases, SUM(PRD13) As Totales, '+
        'SUM(PRD10) As Dtos, (((SUM(PRD11)*SUM(PRD10)) / 100)) As ImpoDtos FROM '+TablaPreProd+Tienda+
        ' WHERE PRD0='+dbPedi.Fields[0].AsString+
        ' AND PRD1="'+FormatDateTime('yyyy/mm/dd',dbPedi.Fields[1].asDateTime)+'"'+
        ' AND PRD2="'+dbPedi.Fields[2].AsString+'"'+
        ' AND PRD3='+dbPedi.Fields[3].AsString+' GROUP BY PRD12 ORDER BY PRD12 ASC';
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
   dbMuestrad.SQL.Text:=dbPedid.SQL.Text;
   dbMuestrad.Active:=True;
   if RadioButton9.Checked=true then Numero:=1 else Numero:=2;
   frReport1.LoadFromFile(Impreso[Numero]);
   frReport1.ShowReport;
end;

//=============================================================
//======================= CREAR NUEVO CLIENTE =================
//=============================================================

//------ Aceptar crear nuevo cliente
procedure TFVentas.BitBtn33Click(Sender: TObject);
begin

  if Edit29.Text='' then
    begin
       DataModule1.Mensaje('Información','Falta la Razón social', 2000 , clGray);
       Edit29.SetFocus;
       Exit;
    end;

   if ClienteDuplicado<>'' then
    if Application.MessageBox('Grabar cliente','FacturLinEx', boxstyle) = IDNO then
         begin
           BitBtn34Click(Self);
           Edit1.SetFocus;
           exit;
         end;

  dbClientes.Append;
  dbClientes.FieldByName('C0').AsString:=Edit1.Text;//---- Codigo
  dbClientes.FieldByName('C1').AsString:=Edit29.Text;//--- Nombre
  dbClientes.FieldByName('C3').AsString:=Edit31.Text;//--- Direccion
  dbClientes.FieldByName('C4').AsString:=Edit32.Text;//--- Localidad
  dbClientes.FieldByName('C37').AsString:=Edit37.Text;//--- C. Postal
  dbClientes.FieldByName('C38').AsString:=Edit38.Text;//--- Provincia
  dbClientes.FieldByName('C5').AsString:=Edit39.Text;//--- NIF/CIF
  dbClientes.FieldByName('C6').AsString:=Edit40.Text;//--- Telefono
  try
    dbClientes.Post;
  except
    on EDB: EDatabaseError do
    begin
      Showmessage('Error : ' + EDB.Message);
    end;
  end;
  Panel11.Visible:=False;
  Edit1Exit(Edit1);//-- Consultar de nuevo el cliente
  Panel3.Enabled:=True; DBGrid1.Enabled:=True;
  Panel5.Enabled:=True; Panel1.Enabled:=True;
  BitBtn8.Enabled:=True; BitBtn15.Enabled:=True; BitBtn16.Enabled:=True;
  BitBtn17.Enabled:=True; BitBtn18.Enabled:=True;
  BitBtn21.Enabled:=True; BitBtn22.Enabled:=True;
end;

function TFVentas.ClienteDuplicado(): string;
var
  txtQuery: string;
  Duplicado: string;
begin
 Duplicado:='';

 if Edit29.Text<>'' then
   begin
     txtQuery:='SELECT * FROM clientes WHERE C1="'+Edit29.Text+'"';
     dbBusca.Active:=False; dbBusca.Sql.Text:=txtQuery; dbBusca.Active:=True;
     if (dbBusca.RecordCount>0) then Duplicado:=' RAZON SOCIAL,';
   end;

 if Edit39.Text<>'' then
   begin
     txtQuery:='SELECT * FROM clientes WHERE C5="'+Edit39.Text+'"';
     dbBusca.Active:=False; dbBusca.Sql.Text:=txtQuery; dbBusca.Active:=True;
     if (dbBusca.RecordCount>0) then Duplicado:= Duplicado +' CIF/NIF,';
   end;

 Result:= Duplicado;
 if Duplicado='' then exit;

 DataModule1.Mensaje('Información','Duplicidad en'+Duplicado+' Cliente :' +
                        dbBusca.FieldByName('C0').AsString+' ', 2000 , clGray);

end;

//------ Salir de crear nuevo cliente
procedure TFVentas.BitBtn34Click(Sender: TObject);
begin
  Panel11.Visible:=False;
  Panel3.Enabled:=True; DBGrid1.Enabled:=True;
  Panel5.Enabled:=True; Panel1.Enabled:=True;
  BitBtn8.Enabled:=True; BitBtn15.Enabled:=True; BitBtn16.Enabled:=True;
  BitBtn17.Enabled:=True; BitBtn18.Enabled:=True;
  BitBtn21.Enabled:=True; BitBtn22.Enabled:=True;
end;

//========================================================
//===================== USUARIOS =========================
//========================================================
//================== CARGAR PESTAÑAS ===============
procedure TFVentas.CargaUsuarios();
var
  Boton: TBitBtn;
  i,j,z,m: integer;
  nIndex: integer;
  MaxHorizontal: integer;

  begin
  try
   //------- Crear botones -----------
   j := 10; z := 25; m := 0; i := 1;
   nIndex:=0;
   dispensador:='1';

   MaxHorizontal:= Panel12.Height - Panel12.Left;

   dbUsu.First;
   while not dbUsu.Eof do
     begin
       Boton := TBitBtn.Create(Panel12);
       With Boton do
         begin
           Parent := Panel12;
           Name := 'BU' + inttostr(m+1);
           ShowHint := True;
           AutoSize:=False;
           Layout:=blGlyphTop;
           Caption := dbUsu.Fields[9].AsString;
           Enabled:= true;
           Left := j; // Posicion Izquierda
           Top := z; // Posicion Arriba
           Width := 80; // Ancho del boton
           Height := 80; // Alto del boton
           Font.Size:=8;
           Setbounds(Left,Top,Width,Height);
           if dbUsu.Fields[13].AsString<>'' then
            if FileExists(dbUsu.Fields[13].AsString) then
              Glyph.LoadFromFile(dbUsu.Fields[13].AsString);
           OnClick := @ButtonUsuClick;
           Repaint;
         end;
       m := m + 1; i := i + 1;
       j := j + 90;

       //       if i=6 then begin z := z + 85; j := 10; i := 1; end;

        if j > (MaxHorizontal-20) then begin z := z + 85; j := 10; i := 1; end;  // Comprobamos si salimos del panel.

       //  Cargamos combobox con los usuarios disponibles.
       cbUsuario.Items.Add(dbUsu.Fields[9].AsString);
       if dbUsu.Fields[9].AsString = UsuarioActivo then
          begin
              cbUsuario.ItemIndex:=nIndex;
              Dispensador:=dbUsu.Fields[0].AsString;
              btnUsuarioActivo:= boton;      // Asignamos el botón del usuario activo.
          end;
       inc(nIndex);

       dbUsu.Next;

     end;
  except
  end;

end;

//=============== PULSANDO BOTON DE USUARIO =============
procedure TFVentas.ButtonUsuClick(Sender: TObject);
begin
  if dbUsu.Locate('USU9', TbitBtn(Sender).Caption, [loCaseInsensitive]) then
     Dispensador:=dbUsu.Fields[0].AsString else Dispensador:='1';
  Panel12.Visible:=False; Panel12.SendToBack;
  BitBtn9.Enabled:=True;
  BitBtn10.Enabled:=True;
  BitBtn11.Enabled:=True;
  BitBtn12.Enabled:=True;
  BitBtn13.Enabled:=True;
  if PedirSiempreUsuario='S' then cajon();
  BitBtn9.SetFocus; Edit16.SetFocus; Edit15.SetFocus;
end;

procedure TFVentas.cbUsuarioChange(Sender: TObject);
begin
   if dbUsu.Locate('USU9', cbUsuario.text , [loCaseInsensitive]) then
     Dispensador:=dbUsu.Fields[0].AsString;

end;



//=============================================================
//==================== TECLAS RAPIDAS =========================
//=============================================================
procedure TFVentas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //------------- Cambiar entre tickets aparcados de F1 a F4
  if (dbTickets.RecordCount<>0) and (panel4.Visible=False) then
    begin
      if key=VK_F1 then begin dbTickets.RecNo:=1; Edit3.SetFocus; exit; end;
      if key=VK_F2 then if dbTickets.RecordCount>=2 then begin dbTickets.RecNo:=2; Edit3.SetFocus; exit; end
         else begin BitBtn24Click(BitBtn24); exit; end;
      if key=VK_F3 then if dbTickets.RecordCount>=3 then begin dbTickets.RecNo:=3; Edit3.SetFocus; exit; end
         else begin BitBtn24Click(BitBtn24); exit; end;
      if key=VK_F4 then if dbTickets.RecordCount>=4 then begin dbTickets.RecNo:=4; Edit3.SetFocus; exit; end
         else begin BitBtn24Click(BitBtn24); exit; end;
    end;
  //------------- Seleccion de Usuario en la venta F1 a F4  --- INICIO
  if (panel4.Visible=True) then
    begin
      if key=VK_F1 then
        begin
             //-- Pruebas de Jose -- if GetKeyState(VK_CONTROL) < 0 then showmessage('Ole, se pulsó la tecla con CTRL'); // se presionó CONTROL
             exit;
        end;
      if key=VK_F2 then begin exit; end;
      if key=VK_F3 then begin exit; end;
      if key=VK_F4 then begin exit; end;
    end;
  //------------- Seleccion de Usuario en la venta F1 a F4  --- FIN
  if key=VK_F5 then begin Edit5.SetFocus; exit; end;//----- Ir a las unidades

  if key=VK_F6 then begin Edit6.SetFocus; exit; end;//----- Ir al precio

  if key=VK_F7 then begin Edit11.SetFocus; exit; end;//----- Ir al TOTAL por tema VALES

  if key=VK_F11 then begin Edit8.SetFocus; exit; end;//----- Ir al DESCUENTO

  //------------ Totalizar Operacion / Sin ticket ------------------
  if key=VK_F8 then

    if BitBtn8.Enabled=true then begin BitBtn8Click(BitBtn8); key:=0; exit; end
  // OJO, solo valido con el begin inicial   end
    else
        begin
          if BitBtn10.Enabled=true then begin BitBtn10Click(BitBtn10); key:= 0; exit; end;
        end;
  //------------ Totalizar con ticket ------------------
  if key=VK_F9 then
    begin
      if BitBtn9.Enabled=true and Panel4.Visible=True then
        begin
           if PedirSiempreUsuario='S' then Panel12.Visible:=True;
           if BitBtn11.Enabled=True then begin BitBtn11Click(BitBtn11); key:=0; exit; end;
        end;

    end;

  if (key=VK_F10) and (Panel4.Visible=True) then begin BitBtn12Click(BitBtn12); key:=0; exit; end; // Albaranes
  if (key=VK_F11) and (Panel4.Visible=True) then begin BitBtn13Click(BitBtn13); key:=0; exit; end; //Facturas
  if (key=VK_ESCAPE) and (Panel4.Visible=True) then begin BitBtn9Click(BitBtn9); key:=0; exit; end;   // Salir

  //-------------- Activar cambio de usuario ------------------
  if key=VK_F12 then begin key:=0; cbUsuario.SetFocus; cbUsuario.DroppedDown:=true; end;

  //-------------- ESC para salir de ventas -------------------
   if (key=VK_ESCAPE) and (Panel4.Visible=False) then begin BitBtn7Click(BitBtn7); key:=0; exit; end;   // Salir de ventas.


  //-------------- Control en totalizar de la impresion directa / email -----------------


   if ssCtrl in Shift then // Verifica si la tecla Ctrl está presionada
   begin

     if (key=VK_C) and (panel4.Visible=True) then
     begin
       edNumeroCopias.SetFocus;                                                   // Editamos valor en número copias
       key:=0;
       exit;
     end;

     if (key=VK_N) and (panel4.Visible=True) then
     begin
        Edit15.SetFocus;                                                        // Editamos valor Entega
        key:=0;
        exit;
     end;

     if (key=VK_E) and (panel4.Visible=True) then
     begin
         if (cbCorreoElectronico.Checked=False) then cbCorreoElectronico.Checked:=True
                                                else cbCorreoElectronico.Checked:=False;
         key:=0;
         exit;                                                                                                   //Cambiamos valor check correos.
     end;

     if (key=VK_I) and (panel4.Visible=True) then
     begin
         if (cbImprimir.Checked=False) then cbImprimir.Checked:=True
                                       else cbImprimir.Checked:=False;                                          //Cambiamos valor Imprimir.
         key:=0;
         exit;
     end;

     if (key=VK_D) and (panel4.Visible=True) then
     begin
         if (cbImpresionDirecta.Checked=False) then cbImpresionDirecta.Checked:=True
                                               else cbImpresionDirecta.Checked:=False;  //Cambiamos valor Impresión directa
         key:=0;
         exit;
     end;


   end;
end;

procedure TFVentas.FormShow(Sender: TObject);
begin
  Edit3.SetFocus;

  BitBtn24Click(BitBtn24);

end;

initialization
  {$I ventas.lrs}

end.

