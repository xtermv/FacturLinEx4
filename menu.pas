{
  Gestion LinEx FacturLinEx 2.0

  Copyright (C) 2000-2011

  Nicolas Lopez de Lerma Aymerich <nicolas@esdebian.org>

  Collaborators:
                 Antonio Domínguez Santos (adslinex)
                 Xaime Alvarez Ares
                 Elmo Calatayud Chumbes
                 Fco. Javier Perez Vidal
                 José Belenguer
                 Eduardo Maldonado
                 David Gámiz Jiménez
                 Juan Manuel Martínez Gámiz

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

Unit Menu;

{$mode Objfpc}{$H+}

Interface

Uses
  {$ifdef unix}{$ifdef UseCThreads}cthreads,{$endif}{$endif}
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, Inifiles, ZConnection, ZDataset, StdCtrls, ExtCtrls, Process, db,
  LCLType, DBGrids, Menus, FileCtrl, LR_Class, LCLIntf;
Type
   RServidorBD = record
      nombre: string[15];       // Lo que muestra el ComboBox
      soportado: boolean;       // En la actualidad ¿Esta soportado por facturlinex2?
      // Aquí podíamos añadir algún campo si fuera necesario, protocolos, parametros
   end;

  { TFMenu }

  TFMenu = Class(Tform)
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
    BitBtn30: TBitBtn;
    BitBtn31: TBitBtn;
    BitBtn32: TBitBtn;
    BitBtn33: TBitBtn;
    BitBtn34: TBitBtn;
    BitBtn35: TBitBtn;
    BitBtn36: TBitBtn;
    BitBtn37: TBitBtn;
    BitBtn40: TBitBtn;
    BitBtn44: TBitBtn;
    BitBtn45: TBitBtn;
    BitBtn46: TBitBtn;
    BitBtn47: TBitBtn;
    BitBtn48: TBitBtn;
    BitBtn49: TBitBtn;
    BitBtn50: TBitBtn;
    BitBtn51: TBitBtn;
    BitBtn52: TBitBtn;
    BitBtn53: TBitBtn;
    BitBtn54: TBitBtn;
    BitBtn55: TBitBtn;
    BitBtn56: TBitBtn;
    BitBtn57: TBitBtn;
    BitBtn58: TBitBtn;
    BitBtn59: TBitBtn;
    BitBtn60: TBitBtn;
    BitBtn61: TBitBtn;
    btnEnviarAhora: TBitBtn;
    BitBtnAbout: TBitBtn;
    BitBtnActuArti: TBitBtn;
    BitBtnActuEans: TBitBtn;
    BitBtnActuPedi: TBitBtn;
    BitBtnComun: TBitBtn;
    BitBtn38: TBitBtn;
    BitBtn39: TBitBtn;
    BitBtn41: TBitBtn;
    BitBtn42: TBitBtn;
    BitBtn43: TBitBtn;
    BitBtnEnviArti: TBitBtn;
    BitBtnEnviCli: TBitBtn;
    btnVFReenviarErrores: TBitBtn;
    ComboServidoresBD: TComboBox;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    dbPedidos: TZQuery;
    dbLlamadas: TZQuery;
    dbUsuarios: TZQuery;
    dbRoles: TZQuery;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit3: TEdit;
    FileListBox1: TFileListBox;
    frReport1: TfrReport;
    Image1: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    ImagenLogo: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
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
    Label4: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Pagecontrol1: Tpagecontrol;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    PopupMenu1: TPopupMenu;
    Shape1: TShape;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    LabelLlamada: TStaticText;
    StatusBar1: TStatusBar;
    Tabsheet1: Ttabsheet;
    TabSheet11: TTabSheet;
    TimerVF: TTimer;
    tsModulos1: TTabSheet;
    Tabsheet2: Ttabsheet;
    Bitbtn1: Tbitbtn;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    Bitbtn4: Tbitbtn;
    Bitbtn5: Tbitbtn;
    Bitbtn6: Tbitbtn;
    Tabsheet3: Ttabsheet;
    Tabsheet4: Ttabsheet;
    Tabsheet5: Ttabsheet;
    Tabsheet6: Ttabsheet;
    Tabsheet7: Ttabsheet;
    Tabsheet8: Ttabsheet;
    Tabsheet9: Ttabsheet;
    Tabsheet10: Ttabsheet;
    Bitbtn7: Tbitbtn;
    Bitbtn8: Tbitbtn;
    dbQuery: TZQuery;
    Bitbtn9: Tbitbtn;
    Timer1: TTimer;


    procedure ActualizaBBDD(Sender: TObject);
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
    procedure BitBtn44Click(Sender: TObject);
    procedure BitBtn45Click(Sender: TObject);
    procedure BitBtn46Click(Sender: TObject);
    procedure BitBtn47Click(Sender: TObject);
    procedure BitBtn48Click(Sender: TObject);
    procedure BitBtn49Click(Sender: TObject);
    procedure BitBtn52Click(Sender: TObject);
    procedure BitBtn53Click(Sender: TObject);
    procedure BitBtn54Click(Sender: TObject);
    procedure BitBtn55Click(Sender: TObject);
    procedure BitBtn56Click(Sender: TObject);
    procedure BitBtn57Click(Sender: TObject);
    procedure BitBtn58Click(Sender: TObject);
    procedure BitBtn59Click(Sender: TObject);
    procedure BitBtn60Click(Sender: TObject);
    procedure BitBtn61Click(Sender: TObject);
    procedure BitBtnActuArtiClick(Sender: TObject);
    procedure BitBtnActuPediClick(Sender: TObject);
    procedure BitBtnEnviArtiClick(Sender: TObject);
    procedure BitBtnEnviCliClick(Sender: TObject);
    procedure BitBtn38Click(Sender: TObject);
    procedure BitBtn39Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn40Click(Sender: TObject);
    procedure BitBtn41Click(Sender: TObject);
    procedure BitBtn42Click(Sender: TObject);
    procedure BitBtn43Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    Procedure Bitbtn8click(Sender: Tobject);
    Procedure Bitbtn5click(Sender: Tobject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn50Click(Sender: TObject);
    procedure BitBtnActuEansClick(Sender: TObject);
    procedure BitBtnComunClick(Sender: TObject);
    procedure BitBtnAboutClick(Sender: TObject);
    procedure btnEnviarAhoraClick(Sender: TObject);
    procedure btnVFReenviarErroresClick(Sender: TObject);
    procedure Edit26Enter(Sender: TObject);
    procedure Edit26Exit(Sender: TObject);
    procedure Edit26KeyPress(Sender: TObject; var Key: char);
    procedure Edit27KeyPress(Sender: TObject; var Key: char);
    procedure VF_EnviarPendienteAlSalir;
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    Procedure Formcreate(Sender: Tobject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    Procedure Iniciar();
    Procedure Bitbtn7click(Sender: Tobject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure CargaIconos();
    procedure ActualizamosPromociones();
    procedure Timer1Timer(Sender: TObject);
    procedure CargaModulos;
    procedure ModulosExtraClick(sender: TObject);
    // Veri*Factu Timer
    procedure TimerVFTimer(Sender: TObject);
    // Veri*Factu Servidor LOCAL para Pruebas
    procedure IniciarVerifactuLocal;
    procedure DetenerVerifactuLocal;

  Private
    { Private Declarations }
    //-------------------------------------------------
    //-- Barra de Estado Información SERVER Veri*Factu
    //-------------------------------------------------
    procedure UpdateVFStatusBar;
    function VF_GetEndpointSummary: string;
    function VF_GetQueuePending(out Pending: Integer): Boolean;


    procedure VF_ToggleMode(Sender: TObject);

  Public
    { Public Declarations }
    IniReader : TIniFile;
    Sections : TStringList;

    ModuloConfiguracion: TIniFile;
    ModuloSecciones: TstringList;

    //-- OJO, estaban declaradas en la parte Private debajo de los otros VF
    procedure VF_SetMode(const NewMode: string);

End;

Var
  FMenu: TFMenu;
  Empresa, Direccion, Localidad, Nif, Tienda, Puesto: String;
  NTienda: Integer;
  ServidoresBD: array [0..26] of RServidorBD;
  IconoLlamadas, IconoPedidos: String;
  FechaEntrada: String;

  BinarioModulos: array of string;

  function ThreadProbeOK: Boolean;
  
Implementation

uses
   Global, Tiendas, Clientes, Articulos, listatiendas, Factura, config, Ventas,
   Proveedores, Familias, Usuarios, Departamentos, FormaPago, Rutas, Fabricantes,
   Envases, listausuarios, Albaran, historicoop, gestionar, listaarticulos,
   listaclientes, listafamilias, ivaEmi, ivaReci, listaproveedores, acaja,
   listadepartamentos, actualizaarti, Creditos, entrada, Puestos, listapuestos,
   facturar, lineales, histopedi, Presupuestos, Funciones, actualizaeans,
   enviopedidos, Produccion, about, HistoAlba, FAStock, EtiEans, EtiLineales,
   CopiaSeg, ActAutArt, unirpedido, generarped, actualizapedi, envioclientes,
   envioarti, roles, promociones, facturaped, histofaprov, copiasegauto, Modelo347,
   uVeriFactu, uVeriFactuDispatcher, uVeriFactuHTTPSender, uVFServer, uVF_Sender,
   uVF_Integration, uVeriChain, uVeriChainCheck, uVF_QueueResult,
   uVF_Stub, uVFSenderAEAT, uVeriSIFForm, uFLX_Log, uFLX_Backup, uFLX_CryptoIni;

//====================================================================
// ==== CONSTANTE PARA TRABAJAR EN LA BARRA DE ESTADO VERI*FACTU =====
//====================================================================

const
  VF_DEFAULT_PORT = 8080;

//====================================================================
//======================= VERI*FACTU STATUS BAR ======================
//====================================================================
function TFMenu.VF_GetEndpointSummary: string;
var
  url: string;
begin
  // elegimos la URL según el modo actual
  if UpperCase(vfMode) = 'PRODUCCION' then
    url := vfUrlTP
  else
    url := vfUrlTLocal;

  // construimos la cadena para la barra de estado
  Result := vfMode + ' · ' + url;
end;

function TFMenu.VF_GetQueuePending(out Pending: Integer): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  Pending := -1;

  Q := TZQuery.Create(nil);
  try
    // Usa la misma conexión que ya empleas (cámbialo a tu ZConnection si prefieres)
    Q.Connection := dbQuery.Connection;

    Q.SQL.Text :=
      'SELECT COUNT(*) AS n ' +
      'FROM verifactu_queue ' +
      'WHERE estado = ''PENDIENTE''';
    Q.Open;
    Pending := Q.FieldByName('n').AsInteger;
    Result := True;
  except
    // Si la tabla no existe aún o hay error, devolvemos False
  end;
  Q.Free;
end;


// Circulitos
function VF_DotGreen: string; inline;  begin Result := '🟢'; end;
function VF_DotOrange: string; inline; begin Result := '🟠'; end;
function VF_DotRed: string; inline;    begin Result := '🔴'; end;

// Punto para el modo (PRUEBAS/PRODUCCIÓN)
function VF_ModeDot: string;
begin
  // En PRUEBAS: verde si el mock está corriendo; rojo si no
  if UpperCase(vfMode) <> 'PRODUCCION' then
  begin
    if Assigned(@VFMockServerIsRunning) and VFMockServerIsRunning then
      Exit(VF_DotGreen)
    else
      Exit(VF_DotRed);
  end;

  // En PRODUCCIÓN: verde si hay endpoint configurado; rojo si está vacío
  if (vfUrlTP <> '') then
    Result := VF_DotGreen
  else
    Result := VF_DotRed;
end;

// Punto para la cola (pendientes)
function VF_QueueDot(Pending: Integer): string;
begin
  if Pending <= 0 then Exit(VF_DotGreen);
  if Pending < 10  then Exit(VF_DotOrange);
  Result := VF_DotRed;
end;

procedure TFMenu.UpdateVFStatusBar;
var
  s: string;
  n: Integer;
  dotMode, dotQueue, colaTxt: string;
  dbName: string;
begin
  if not Assigned(StatusBar1) then Exit;

  // 1) Texto base (modo + url)
  s := VF_GetEndpointSummary;

  // 2) Punto de modo
  dotMode := VF_ModeDot;

//----------------- CONTROL DE BBDD CONECTADA --------------------
// Añade info de la base de datos conectada
  try
    dbName := dbQuery.Connection.Database;
  except
    dbName := '?';
  end;
//----------------------------------------------------------------

  // 3) Punto y texto de cola
  if VF_GetQueuePending(n) then
  begin
    dotQueue := VF_QueueDot(n);
    colaTxt  := IntToStr(n) + ' pendientes';
  end
  else
  begin
    dotQueue := VF_DotRed; // indeterminado -> rojo
    colaTxt  := '?';
  end;

  // 4) Pinta todo en la barra
  StatusBar1.SimplePanel := True;
  StatusBar1.SimpleText  := dotMode + ' ' + s + ' · ' + dotQueue + ' Cola: ' + colaTxt + ' - BBDD : ' + DBDataBase + ' - MotorBBDD : ' + MotorDB;
end;

//=================================================
//=========== PROCEDIMIENTO DE ENVIO ==============
//=================================================
// -- PASADO A UNIDAD INDEPENDIENTE uVF_Integration
//=================================================
//=================================================

procedure TFMenu.VF_SetMode(const NewMode: string);
var
  oldTimerVF: Boolean;
begin
  // 1) Pausar el timer para que no dispare envíos durante el cambio
  oldTimerVF := TimerVF.Enabled;
  TimerVF.Enabled := False;

  try
    // 2) Cambiar modo en memoria
    vfMode := UpperCase(NewMode); // admite 'PRUEBAS' o 'PRODUCCIÓN'

    // 3) Ajustar endpoints según modo (usa tus variables globales)
    if vfMode = 'PRUEBAS' then
    begin
      // Arranca mock si no está
      if Assigned(@StartVFMockServer) and not VFMockServerIsRunning then
        StartVFMockServer(VF_DEFAULT_PORT);
      // Asegura URL local activa
      // (si tienes una variable "vfEndpointActive" úsala; si no, tus llamadas ya usan vfUrlTLocal)
      // vfEndpointActive := vfUrlTLocal;
    end
    else
    begin
      // PRODUCCIÓN: detener mock si estuviera corriendo
      if Assigned(@VFMockServerIsRunning) and VFMockServerIsRunning then
        StopVFMockServer;
      // Asegura URL de producción
      // vfEndpointActive := vfUrlTP;
    end;

    // 4) Persistir en INI (opcional pero recomendable)
    if Assigned(IniReader) then
    begin
      IniReader.WriteString('VeriFactu', 'vfMode', vfMode);
      if vfMode = 'PRODUCCION' then
        begin
             IniReader.WriteString('VeriFactu', 'vfUrlTP', vfUrlTP);
             VF_ApplyMode(1);
        end
      else
        begin
             IniReader.WriteString('VeriFactu', 'vfUrlTLocal', vfUrlTLocal);
             VF_ApplyMode(0);
        end;
      IniReader.UpdateFile;
    end;

    // 5) Refrescar UI (barra de estado)
    UpdateVFStatusBar;

  finally
    // 6) Volver a dejar el timer como estaba
    TimerVF.Enabled := oldTimerVF;
  end;
end;

procedure TFMenu.VF_ToggleMode(Sender: TObject);
begin
  // Cambiar entre PRODUCCIÓN <-> PRUEBAS
  if UpperCase(vfMode) = 'PRODUCCION' then
    begin
         VF_SetMode('PRUEBAS');
    end
  else
    begin
         VF_SetMode('PRODUCCION');
    end;
end;
//====================================================================

//============================== LOCALIZAR SERIE ACTIVA ===============================
// === Obtener serie de facturación por defecto desde la BD (igual lógica que Ventas.VerSerieFacturacion) ===
function VF_GetSerieActivaFromDB(const Conn: TZConnection): string;
var
  QTiendas: TZQuery;
begin
  Result := '';

  QTiendas := TZQuery.Create(nil);
  try
    QTiendas.Connection := Conn;

    // Mismas condiciones que en Ventas.VerSerieFacturacion:
    // SELECT * FROM tiendas WHERE T0 = NTienda;
    QTiendas.SQL.Text := 'SELECT * FROM tiendas WHERE T0=' + IntToStr(NTienda);
    QTiendas.Open;

    if QTiendas.RecordCount = 0 then
    begin
      // No sabemos en qué tienda facturar
      Exit;
    end;

    // En Ventas usas: dbTiendas.Fields[11].AsString como SF0 de la serie por defecto
    // Replicamos EXACTAMENTE eso:
    if QTiendas.Fields.Count > 11 then
      Result := Trim(QTiendas.Fields[11].AsString)
    else
      Result := '';
  finally
    QTiendas.Free;
  end;
end;
//========================== FIN LOCALIZAR SERIE ACTIVA ===============================


// ——— Obtiene series distintas con actividad reciente (últimos 60 días) y/o con hash ———
procedure VF_ListSeries(const Conn: TZConnection; out Series: TStringList);
var Q: TZQuery;
begin
  Series := TStringList.Create;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;
    // Ajusta la ventana temporal si quieres (60 días). Filtramos a series con algún hash ya calculado
    Q.SQL.Text :=
      'SELECT DISTINCT serie ' +
      'FROM verifactu_queue ' +
      'WHERE (created_at >= NOW() - INTERVAL 60 DAY ' +
      '       OR updated_at >= NOW() - INTERVAL 60 DAY) ' +
      '  AND hash IS NOT NULL AND TRIM(hash)<>'''' ' +
      'ORDER BY serie';
    Q.Open;
    while not Q.EOF do
    begin
      Series.Add(Trim(Q.FieldByName('serie').AsString));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

// ——— Valida una lista de series y muestra un resumen ———
procedure VF_ValidateSeriesList(const Conn: TZConnection; const Series: TStrings);
var
  i: Integer;
  R: TVFChainCheck;
  ok, bad, total: Integer;
  msg: string;
begin
  ok := 0; bad := 0; total := 0;
  msg := '';

  for i := 0 to Series.Count-1 do
  begin
    R := VF_ValidateSerie(Conn, Series[i]);
    Inc(total);
    if R.Mismatches = 0 then
    begin
      Inc(ok);
      msg := msg + '✔ Serie ' + R.Serie + ' — OK (' + IntToStr(R.Total) + ' elementos)' + LineEnding;
    end
    else
    begin
      Inc(bad);
      msg := msg + '❗ Serie ' + R.Serie + ' — ' + IntToStr(R.Mismatches) +
                  ' discrepancia(s). Primera en nº ' + R.FirstBadNumero +
                  ' — ' + R.FirstBadMsg + LineEnding;
    end;
  end;

  if total = 0 then
    ShowMessage('No hay series con actividad/hash en el rango consultado.')
  else
    ShowMessage('Resumen validación: ' + IntToStr(ok) + ' OK / ' + IntToStr(bad) + ' con incidencias' +
                LineEnding + LineEnding + msg);
end;

//====================================================================

// === Prueba de soporte de hilos ===
type
  TProbe = class(TThread)
  protected
    procedure Execute; override;
  end;

procedure TProbe.Execute;
begin
  Sleep(1); // No hace nada; solo comprueba que los hilos funcionan
end;

function ThreadProbeOK: Boolean;
var
  T: TProbe;
begin
  Result := True;
  try
    T := TProbe.Create(True);  // si no hay soporte de hilos, fallará aquí
    try
      // nada más
    finally
      T.Free;
    end;
  except
    on E: Exception do
    begin
      Application.MessageBox(
        PChar('El binario no tiene soporte de hilos (cthreads) y no puedo iniciar VeriFactu PRUEBAS.'+LineEnding+
              'Solución: asegúrate de que cthreads está el PRIMERO en el .lpr y recompila con Clean + Build.'),
        'VeriFactu',
        MB_ICONERROR);
      Result := False;
    end;
  end;
end;


{ TFMenu }

//===================== CREAR APLICACION ==============
Procedure Tfmenu.Formcreate(Sender: Tobject);
var
  cont: integer;
Begin
   // Cargando valores en el ComboBox
   ServidoresBD[0].nombre:='ASA7';ServidoresBD[0].soportado:=FALSE;
   ServidoresBD[1].nombre:='ASA8';ServidoresBD[1].soportado:=FALSE;
   ServidoresBD[2].nombre:='ASA9';ServidoresBD[2].soportado:=FALSE;
   ServidoresBD[3].nombre:='firebird-1.0';ServidoresBD[3].soportado:=FALSE;
   ServidoresBD[4].nombre:='firebird-1.5';ServidoresBD[4].soportado:=FALSE;
   ServidoresBD[5].nombre:='firebird-2.0';ServidoresBD[5].soportado:=FALSE;
   ServidoresBD[6].nombre:='firebirdd-1.5';ServidoresBD[6].soportado:=FALSE;
   ServidoresBD[7].nombre:='firebirdd-2.0';ServidoresBD[7].soportado:=FALSE;
   ServidoresBD[8].nombre:='interbase-5';ServidoresBD[8].soportado:=FALSE;
   ServidoresBD[9].nombre:='interbase-6';ServidoresBD[9].soportado:=FALSE;
   ServidoresBD[10].nombre:='mssql';ServidoresBD[10].soportado:=FALSE;
   ServidoresBD[11].nombre:='mysql';ServidoresBD[11].soportado:=TRUE;
   ServidoresBD[12].nombre:='mysql-4.1';ServidoresBD[12].soportado:=TRUE;
   ServidoresBD[13].nombre:='mysql-5';ServidoresBD[13].soportado:=TRUE; // Si hay más ¿?
   ServidoresBD[14].nombre:='mysqld-4.1';ServidoresBD[14].soportado:=TRUE;
   ServidoresBD[15].nombre:='mysqld-5';ServidoresBD[15].soportado:=TRUE;
   ServidoresBD[16].nombre:='oracle';ServidoresBD[16].soportado:=FALSE;
   ServidoresBD[17].nombre:='oracle-9i';ServidoresBD[17].soportado:=FALSE;
   ServidoresBD[18].nombre:='postgresql';ServidoresBD[18].soportado:=FALSE;
   ServidoresBD[19].nombre:='postgresql-7';ServidoresBD[19].soportado:=FALSE;
   ServidoresBD[20].nombre:='postgresql-8';ServidoresBD[20].soportado:=FALSE;
   ServidoresBD[21].nombre:='sqlite';ServidoresBD[21].soportado:=FALSE;
   ServidoresBD[22].nombre:='sqlite-2.8';ServidoresBD[22].soportado:=FALSE;
   ServidoresBD[23].nombre:='sqlite-3';ServidoresBD[23].soportado:=FALSE;
   ServidoresBD[24].nombre:='sybase';ServidoresBD[24].soportado:=FALSE;
   //ServidoresBD[25].nombre:='';ServidoresBD[25].soportado:=FALSE;

  ComboServidoresBD.Clear; ComboServidoresBD.Text:='';
  cont:=0;
  While ServidoresBD[cont].nombre <> '' do
  begin
    ComboServidoresBD.Items.Add(ServidoresBD[cont].nombre);
    cont:=cont+1;
  end;

   ShortDateFormat:='DD/MM/YYYY';
  {$IFDEF LINUX}
     DecimalSeparator:='.';

     // Comprobamos si la aplicación es para desarrollo o en producción.
     if ExtractFilePath(ParamStr(0))='/usr/bin/' then
                begin
                   RutaIni:=GetEnvironmentVariable('HOME')+'/.facturlinex2/';
                   RutaSql:='/usr/share/facturlinex2/';
                   RutaBin:='/usr/bin/';
                   RutaIconos:=RutaSql+'Icons/';
                   RutaReports:='/usr/share/facturlinex2/Report/';
                   RutaModulos:=RutaSql+'Extras/';
                end else
                begin
                   FMenu.Caption:='FacturLinEx ( Sistema en pruebas )';
                   RutaIni:=ExtractFilePath(ParamStr(0));
                   RutaSql:=RutaIni;
                   RutaBin:=RutaIni;
                   RutaIconos:=RutaBin+'Imagenes/';
                   RutaReports:=RutaIni+'Report/';
                   RutaModulos:=RutaIni+'Extras/';
                end;

    //----------------- Carga de la variable AbrirAchivo
    //Descubrir que escritorio está utilizando el usuario
    if AbrirAchivo = '' then AbrirAchivo:=GetEnvironmentVariable('DESKTOP_SESSION')+'-open';

  {$ELSE}
     RutaIni:=ExtractFilePath(ParamStr(0));
     RutaSql:= RutaIni+'Tablas\';
     RutaIconos:=RutaIni;
     RutaBin:= RutaIni;
     RutaReports:= RutaIni+'Report\';
     RutaModulos:= RutaIni+'Extras\';
     DecimalSeparator:='.';
     if AbrirAchivo= '' then AbrirAchivo:= 'explorer.exe';
  {$ENDIF}
  if not FileExists(RutaIni+'FacturConf.ini') then
    begin
     //------------- Linex / Debian / Ubuntu -------------
     if (FileExists('/etc/debian_version')) or (FileExists('/etc/ubuntu_version')) then
       begin
         if FileExists('/usr/lib/libmysqlclient.so.10.0.0') then ComboServidoresBD.Text:='mysql';
         if FileExists('/usr/lib/libmysqlclient.so.12.0.0') then ComboServidoresBD.Text:='mysql';
         if FileExists('/usr/lib/libmysqlclient.so.14.0.0') then ComboServidoresBD.Text:='mysql-4.1';
         if FileExists('/usr/lib/libmysqlclient.so.15.0.0') then ComboServidoresBD.Text:='mysql-5';
         if FileExists('/usr/lib/libmysqlclient.so.16.0.0') then ComboServidoresBD.Text:='mysql-5';
         if FileExists('/usr/lib/libmysqlclient.so.18.0.0') then ComboServidoresBD.Text:='mysql-5';
       end;
     //------------- Red-Hat / Fedora -----------
     if FileExists('/etc/redhat-release') then
       begin
         if FileExists('/usr/lib/mysql/libmysqlclient.so.10.0.0') then ComboServidoresBD.Text:='mysql';
         if FileExists('/usr/lib/mysql/libmysqlclient.so.12.0.0') then ComboServidoresBD.Text:='mysql';
         if FileExists('/usr/lib/mysql/libmysqlclient.so.14.0.0') then ComboServidoresBD.Text:='mysql-4.1';
         if FileExists('/usr/lib/mysql/libmysqlclient.so.15.0.0') then ComboServidoresBD.Text:='mysql-5';
         if FileExists('/usr/lib/mysql/libmysqlclient.so.16.0.0') then ComboServidoresBD.Text:='mysql-5';
         if FileExists('/usr/lib/mysql/libmysqlclient.so.18.0.0') then ComboServidoresBD.Text:='mysql-5';
       end;
     Pagecontrol1.Enabled:=False;
     Panel1.Visible:=True; Panel1.Enabled:=True;
     //Edit21.SetFocus;
     Exit;
    end;

  Iniciar();

  //=============================================
  //-- VERSIÓN DE PRUEBAS POR ERROR EN ARRANQUE
  //=============================================
    if not ThreadProbeOK then
      begin
       ShowMessage('Este ejecutable no tiene soporte de hilos (falta cthreads en el .lpr).');
       Exit; // evita entrar en StartVFMockServer / envíos hasta recompilar bien
      end;

    IniciarVerifactuLocal; // aquí arrancas el mock si Modo=PRUEBAS

      //-- INICIAR SERVIDOR LOCAL VERI*FACTU
  if vfMode = 'PRUEBAS' then IniciarVerifactuLocal;

     UpdateVFStatusBar;

End;

//===================== INICIAR APLICACION ====================
Procedure Tfmenu.Iniciar();
var
  cont: Integer;
  urlSelect: String;

begin

  FechaEntrada:= FormatDateTime('DD/MM/YYYY',Date);  // guardamos fecha de entrada a la aplicación.

  IniReader := TIniFile.Create(RutaIni+'FacturConf.ini');
  Sections := TStringList.Create;

  IniReader.ReadSections( Sections );
  Empresa:=IniReader.ReadString('datos','nombre','');
  Direccion:=IniReader.ReadString('datos','direccion','');
  Localidad:=IniReader.ReadString('datos','cp','')+' - '+IniReader.ReadString('datos','poblacion','');
  Nif:=IniReader.ReadString('datos','CIF','');
  Tienda:=IniReader.ReadString('tienda','codigo','');
  if Tienda<>'' then NTienda:=StrToInt(Tienda) else NTienda:=0;
  Puesto:=IniReader.ReadString('tienda','puesto','');
  ColorFondo:=IniReader.ReadString('datos','ColorFondo','');
  ColorBotones:=IniReader.ReadString('datos','ColorBotones','');
  //----------------- Conexion -----------------
  if IniReader.ReadString('BBDD','host','')<>'' then
   begin
    datamodule1.dbConexion.HostName:=IniReader.ReadString('BBDD','host','');
    datamodule1.dbConexion.Database:=IniReader.ReadString('BBDD','database','');
    datamodule1.dbConexion.User:=IniReader.ReadString('BBDD','usuario','');
    //-- datamodule1.dbConexion.Password:=IniReader.ReadString('BBDD','passwd','');
    datamodule1.dbConexion.Password:=FLX_IniReadPassword(IniReader, 'BBDD', 'passwd', '');
    datamodule1.dbConexion.Port:=StrToInt(IniReader.ReadString('BBDD','puerto',''));
    datamodule1.dbConexion.Protocol:=IniReader.ReadString('BBDD','protocolo','');
    datamodule1.dbConexion.Connected:=True;
  //datamodule1.dbConexion.HostName='localhost' then  showmessage('SERVIDOR Trabajando en modo localhost');
    DataModule1.Mensaje('FacturLinEx','Conexión con mysql : '+ IniReader.ReadString('BBDD','host',''), 3000 , clMoneyGreen);

   end;
  //----------------- Pedidos pendientes ----------
  dbPedidos.Active:=False;
  dbPedidos.SQL.Text:='SELECT * FROM pedicc'+Tienda+' ORDER BY PC1 ASC';
  dbPedidos.Active:=True;

  //----------------- Llamadas pendientes ----------
  dbLlamadas.Active:=False;
  dbLlamadas.SQL.Text:='SELECT * FROM llamadas'+Tienda+' ORDER BY Fechallama ASC';
  dbLlamadas.Active:=True;
  //----------------- Botones de aviso de llamadas/pedidos pendientes ---------
  IconoLlamadas:='LlamadaNo.png';
  IconoPedidos:='PedidoNo.png';

  //timer1.Enabled:=True;
  CargaIconos();
  //----------------- Colores del formulario y botones ------------------------
  if ColorFondo<>'' then Color:=StringToColor(ColorFondo);
    cont:=0;
  if ColorBotones<>'' then
    begin
     for cont:=0 to ComponentCount-1 do
       begin
        if (Components[cont] is TBitBtn) then
          TBitBtn(FindComponent(Components[cont].Name)).color:=StringToColor(ColorBotones);
       end;
    end;
  Timer1.Enabled:=True;
  //-------------------------- Controlar claves de acceso y Usuario activo ---------------------
   if CgClaves='S' then
      begin
        SpeedButton1.Enabled:=False; SpeedButton2.Enabled:=False;
        PageControl1.Enabled:=False;
        Panel6.Visible:=True;
        Exit;
      end else
      begin
         dbUsuarios.SQL.Text:='SELECT * FROM usuarios'+Tienda;
         dbUsuarios.Active:=True;
         if dbUsuarios.RecordCount<> 0 then UsuarioActivo:= dbUsuarios.FieldByName('USU9').AsString
                                       else UsuarioActivo:='';
      end;

      CargaModulos();


      //===========================================================
      //=== Veri*Factu paso de datos por si no existe el .ini en ~/.config/verficatu/verifactu.ini con los datos
      //===========================================================
      VeriFactu_SetDBParams(IniReader.ReadString('BBDD','host',''), IniReader.ReadString('BBDD','puerto',''), IniReader.ReadString('BBDD','database',''), IniReader.ReadString('BBDD','usuario',''), FLX_IniReadPassword(IniReader, 'BBDD', 'passwd', ''));
      VeriFactu_EnableDualWriteJSON(True); // ya viene activado; aquí por claridad
      // Configura destino HTTP (sandbox local o tu gateway)
      { Version para PRUEBAS FIJAS
      VF_HttpConfigure(
                       'http://127.0.0.1:8787/verifactu/ingresar',   // <-- cámbialo a tu endpoint
                       '',                                           // bearer opcional
                       10000,                                        // timeout ms
                       ''                                            // cabecera extra opcional, p.ej. 'X-Tienda: 0000'
                       );
      }
      if vfMode='PRUEBAS' then urlSelect:= vfUrlTLocal else urlSelect:= vfUrlTP;       //-- FORZADO SIEMPRE A MODO PRUEBAS
      VF_HttpConfigure(
                       urlSelect,   // <-- cámbialo a tu endpoint
                       '',                                           // bearer opcional
                       180000,                                        // timeout ms
                       ''                                            // cabecera extra opcional, p.ej. 'X-Tienda: 0000'
                       );

      VF_UseHTTPSender; // ← activa el sender HTTP
      //-- ACTIVAR MODO TEST
           // VF_UseDefaultTestSender(0); // 0 = nunca falla
      TimerVF.Interval := 180000;  // 10000 son 10 s, lo he cambiado a 30
      TimerVF.Enabled := True;
      VF_SetMode(vfMode);
      UpdateVFStatusBar;

//--      vfFacturaTipo:='F1';    //-- Por defecto Factura Simplificada aunque se declara y da valor en Global.pas

end;

procedure TFMenu.TimerVFTimer(Sender: TObject);
begin
  VF_Tick(10{min lease}, 25{max por pulso});
  VF_TimerStep;  // refresca barra y si hay pendientes envía 1
  // DEBUG 1s:
  // StatusBar1.SimpleText := StatusBar1.SimpleText + '  [tick]';
  { ERA PARA COMPROBAR QUE APUNTABA A LAS DIRECCIONES REQUERIDAS, AUNQUE NO ACTUALIZA EL NÚMERO DE DOCUMENTOS EN COLA, :(
  StatusBar1.SimpleText := StatusBar1.SimpleText +
  '  | VFMode=' + VFMode +
  '  | VFUrlTLocal=' + VFUrlTLocal +
  '  | VFUrlTP=' + VFUrlTP;
  }
  UpdateVFStatusBar;
end;

procedure TFMenu.ActualizamosPromociones();
begin
  //---------------------- Revisamos las promociones -------------------
   fPromociones:=TfPromociones.Create(Application);    // Creamos el formulario para acceder a su contenido
   fPromociones.WindowState:=wsMinimized;
   fPromociones.Show;
   fPromociones.ActualizarPromociones();
   fPromociones.Free;
end;

//===========================================================
//========================= VENTAS ==========================
//===========================================================
//--------------------------- VENTAS ----------------------
procedure TFMenu.BitBtn1Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormVentas();
  Timer1Timer(nil);
end;
//-------------------------- CREDITOS ----------------------
procedure TFMenu.BitBtn38Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormCreditos('');
  Timer1Timer(nil);
end;

//--------------------------- CAJAS ----------------------
procedure TFMenu.BitBtn2Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormCaja();
  Timer1Timer(nil);
end;
//--------------------------- ALBARANES ---------------------
procedure TFMenu.BitBtn3Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormAlbaranes();
  Timer1Timer(nil);
end;

//--------------------------- FACTURAS ----------------------
procedure Tfmenu.Bitbtn5click(Sender: Tobject);
begin
  timer1.enabled:=false;
  ShowFormFacturas();
  Timer1Timer(nil);
end;

//--------------------------- FACTURAR ----------------------
procedure TFMenu.BitBtn6Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormFacturar();
  Timer1Timer(nil);
end;

//-------------------------- PRESUPUESTOS ----------------------
procedure TFMenu.BitBtn4Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormPresupuestos('PRESUPUESTO');
  Timer1Timer(nil);
end;

//--------------------------- PROFORMAS ----------------------
procedure TFMenu.BitBtn43Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormPresupuestos('PROFORMA');
  Timer1Timer(nil);
end;


//===========================================================
//======================= ARCHIVOS ==========================
//===========================================================
//--------------------------- TIENDAS -----------------------
Procedure Tfmenu.Bitbtn7click(Sender: Tobject);
Begin
  timer1.enabled:=false;
  ShowFormTiendas();
  Timer1Timer(nil);
end;
//--------------------------- USUARIOS -----------------------
procedure TFMenu.BitBtn12Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormUsuarios();
  Timer1Timer(nil);
end;
//---------------------- DEPARTAMENTOS -----------------------
procedure TFMenu.BitBtn16Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormDepartamentos();
  Timer1Timer(nil);
end;

//-------------------------- FAMILIAS -----------------------
procedure TFMenu.BitBtn15Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormFamilias();
  Timer1Timer(nil);
end;
//------------------------- ARTICULOS -----------------------
procedure TFMenu.BitBtn11Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormArticulos();
  Timer1Timer(nil);
end;
//-------------------------- CLIENTES -----------------------
procedure TFMenu.BitBtn10Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormClientes();
  Timer1Timer(nil);
end;

//----------------------- PROVEEDORES -----------------------
procedure TFMenu.BitBtn14Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormProveedores();
  Timer1Timer(nil);
end;

//------------------------ VARIOS -------------------------
procedure TFMenu.BitBtn17Click(Sender: TObject);
begin
  Panel2.Visible:=True; Pagecontrol1.Enabled:=False;
end;

//-------------------- CERRAR VARIOS ----------------------
procedure TFMenu.BitBtn20Click(Sender: TObject);
begin
  Panel2.Visible:=False; PageControl1.Enabled:=True;
end;
//------------------ FORMAS DE PAGO / COBRO ---------------
procedure TFMenu.BitBtn21Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormFormaPago();
  Timer1Timer(nil);
end;
//------------------ RUTAS DISTINTIVOS ---------------
procedure TFMenu.BitBtn22Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormRutas();
  Timer1Timer(nil);
end;
//------------------- FABRICANTES --------------------
procedure TFMenu.BitBtn23Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormFabricantes();
  Timer1Timer(nil);
end;
//------------------- ENVASES --------------------
procedure TFMenu.BitBtn24Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormEnvases();
  Timer1Timer(nil);
end;
//------------------- PUESTOS DE VENTAS --------------------
procedure TFMenu.BitBtn42Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormPuestos();
  Timer1Timer(nil);
end;
//-------------------- PRODUCCION ----------------------
procedure TFMenu.BitBtn35Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormProduccion();
  Timer1Timer(nil);
end;


//===========================================================
//========================= LISTADOS ========================
//===========================================================
//-------------------  Listado de tiendas ------------------
procedure TFMenu.BitBtn25Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormlistatiendas();
  Timer1Timer(nil);
end;
//-------------------  Listado de usuarios ------------------
procedure TFMenu.BitBtn9Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormlistausuarios();
  Timer1Timer(nil);
end;
//----------------- Listado de articulos -------------
procedure TFMenu.BitBtn28Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormlistaarticulos();
  Timer1Timer(nil);
end;
//----------------- Listado de clientes -------------
procedure TFMenu.BitBtn29Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormlistaclientes();
  Timer1Timer(nil);
end;
//----------------- Listado de departamentos -------------
procedure TFMenu.BitBtn34Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormlistadepartamentos();
  Timer1Timer(nil);
end;
//----------------- Listado de familias -------------
procedure TFMenu.BitBtn30Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormlistafamilias();
  Timer1Timer(nil);
end;
//----------------- Listado de proveedores -------------
procedure TFMenu.BitBtn31Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormlistaproveedores();
  Timer1Timer(nil);
end;
//----------------- IVA Emitido -------------
procedure TFMenu.BitBtn32Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormlistaivaEmi();
  Timer1Timer(nil);
end;
//----------------- IVA Recibido -------------
procedure TFMenu.BitBtn33Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormlistaivaReci();
  Timer1Timer(nil);
end;


//===========================================================
//======================== PEDIDOS ==========================
//===========================================================
//----------------- Gestion de pedidos ----------------------
procedure TFMenu.BitBtn27Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormPedido();
  Timer1Timer(nil);
end;
//----------------- Entrada de pedidos ----------------------
procedure TFMenu.BitBtn39Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormEntradaPedido('','','','','');
  Timer1Timer(nil);
end;
//----------------- Generar pedidos ----------------------
procedure TFMenu.BitBtn53Click(Sender: TObject);
begin
 timer1.enabled:=false;
 ShowFormGeneraPed();
 Timer1Timer(nil);
end;

//----------------- Unir pedidos ----------------------
procedure TFMenu.BitBtn52Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormUniPedi();
  Timer1Timer(nil);
end;


//===========================================================
//======================= HISTORICOS ========================
//===========================================================

//----------------- Historico de operaciones ----------------
procedure TFMenu.BitBtn26Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormHistoop();
  Timer1Timer(nil);
end;
//----------------- Historico de pedidos ----------------
procedure TFMenu.BitBtn41Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormHistoPedido();
  Timer1Timer(nil);
end;

//----------------- Historico de albaranes ----------------
procedure TFMenu.BitBtn36Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormHistoAlbaranes();
  Timer1Timer(nil);
end;

//----------------- Facturar albaranes de pedidos ----------------------
procedure TFMenu.BitBtn57Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormFacturaPedi();
  Timer1Timer(nil);
end;

//----------------- Facturas de proveedor ----------------------
procedure TFMenu.BitBtn59Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormHistoFaProv();
  Timer1Timer(nil);
end;

procedure TFMenu.BitBtn60Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormModelo347();
  Timer1Timer(nil);
end;

procedure TFMenu.BitBtn61Click(Sender: TObject);
begin
  FSIFConfig := TFSIFConfig.Create(Self);
  try
    FSIFConfig.ShowModal;
  finally
    FSIFConfig.Free;
  end;
end;


//===========================================================
//======================== ETIQUETAS ========================
//===========================================================
//----------------- Etiquetas Lineales --------------------
procedure TFMenu.BitBtn40Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormEtilineales();
  Timer1Timer(nil);
end;

//===========================================================
//===================== COMUNICACIONES ======================
//===========================================================
//----------------- Actualizar Articulos --------------------
procedure TFMenu.BitBtnActuArtiClick(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormactualizaArti();
  Timer1Timer(nil);
end;
procedure TFMenu.BitBtnActuEansClick(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormactualizaEans();
  Timer1Timer(nil);
end;
procedure TFMenu.BitBtnComunClick(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormenviopedidos();
  Timer1Timer(nil);
end;
procedure TFMenu.BitBtnActuPediClick(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormactualizaPedi();
  Timer1Timer(nil);
end;
procedure TFMenu.BitBtnEnviArtiClick(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormenvioArti();
  Timer1Timer(nil);
end;
procedure TFMenu.BitBtnEnviCliClick(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormenvioClientes();
  Timer1Timer(nil);
end;
//===========================================================
//======================= UTILIDADES ========================
//===========================================================
//---------------------- Configuracion ----------------------
procedure TFMenu.BitBtn13Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormConfig();
  Timer1Timer(nil);
end;
//---------------------- Copias de seguridad ----------------
procedure TFMenu.BitBtn37Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormCopiaSeg();
  Timer1Timer(nil);
end;
//-------------------- Actualizaciones BBDD -----------------
procedure TFMenu.ActualizaBBDD(Sender: TObject);
begin
  AProcess := TProcess.Create(nil);
  {$IFDEF LINUX}
     AProcess.CommandLine := 'gksu '+RutaSql+'FacturActBBDD';
  {$ELSE}
     AProcess.CommandLine := RutaIni+'FacturActBBDD';
  {$ENDIF}
  AProcess.Execute;
  AProcess.Free;
end;

//---------------------- ACTUALIZAR TARIFAS ----------------
procedure TFMenu.BitBtn50Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormActAutArt();
  Timer1Timer(nil);
end;

//--------------------------- ACTUALIZACION DE STOCKS ----------------------
procedure TFMenu.BitBtn44Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormStock();
  Timer1Timer(nil);
end;
//--------------------- ETIQUETAS DE BARRAS -------------------
procedure TFMenu.BitBtn45Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormEtiEans();
  Timer1Timer(nil);
end;
//--------------------- ETIQUETAS LINEALES -------------------
procedure TFMenu.BitBtn46Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormEtiLineal();
  Timer1Timer(nil);
end;

//--------------------------- LLAMADA AL DISEÑADOR DE REPORTS ----------------------
procedure TFMenu.frReport1GetValue(const ParName: String; var ParValue: Variant
  );
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
end;


procedure TFMenu.BitBtn47Click(Sender: TObject);
begin
  timer1.enabled:=false;
  showmessage('No se recomienda la edición de reports si no está seguro de lo que va ha hacer');
  showmessage('Aseguresé de tener una copia de seguridad de sus reports');
  frReport1.DesignReport;
  Timer1Timer(nil);
end;

//-------------------- Promociones en artículos ------------
procedure TFMenu.BitBtn58Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormPromociones();
  Timer1Timer(nil);
end;


//--------------------- Roles de usuarios -------------------
procedure TFMenu.BitBtn54Click(Sender: TObject);
begin
  timer1.enabled:=false;
  ShowFormRoles();
  Timer1Timer(nil);
end;


//===========================================================
//========================= AYUDA ===========================
//===========================================================
//---------------------- A cerca de ... ---------------------
procedure TFMenu.BitBtnAboutClick(Sender: TObject);
begin
  timer1.enabled:=false;
  AboutShow();
  Timer1Timer(nil);
end;

//===========================================================
//========== BOTON ENVAIR AHORA VERI*FACTU ==================
//===========================================================
procedure TFMenu.btnEnviarAhoraClick(Sender: TObject);
var
  n: Integer;
  SerieEval: string;
  Series: TStringList;
  Conn: TZConnection;
  opt: Integer;
  R: TVFChainCheck;  //-- Para Validacion de cadena uVeriChainCheck
Begin
  // Envío manual para comprobar que el dispatcher funciona
  // n := VF_DispatchAllPending(100);						// Líneas Duplicadas
  // ShowMessage('Procesadas ahora: ' + IntToStr(n));		// Líneas Duplicadas
  //== VALIDACION CADENA HASH_PREV ========
      //------------------------------------------
      //------------------------------------------
      //------------------------------------------
      // 0) Conexión (usa tu principal)
      Conn := TZConnection(dbQuery.Connection);

      // 1) Envío manual (como ya tenías)
      n := VF_DispatchAllPending(100);
      ShowMessage('Procesadas ahora: ' + IntToStr(n));

      // 2) Elegir qué validar
      opt := Application.MessageBox(
               '¿Qué deseas validar ahora?' + LineEnding +
               '  Sí = Solo serie activa (tickets/simplificada)' + LineEnding +
               '  No = Todas las series recientes con hash',
               'Validación cadena', MB_ICONQUESTION or MB_YESNOCANCEL);
      if opt = IDCANCEL then Exit;

      if opt = IDYES then
      begin
        // —— Sólo serie activa ——
        // Ajusta aquí tu variable de serie activa de tickets/simplificadas
        // Ejemplos: SERIEFACT, SERIE_TICKET, vfSerieActiva, etc.
        //---- SerieEval := VF_GetSerieActiva;               //Linea eliminada para insertar las de abajo desde la bbdd nuevas
        //---- SHOWMESSAGE(SerieEval);// <-- pon aquí la tuya real

       SerieEval := VF_GetSerieActivaFromDB(TZConnection(dbQuery.Connection));
       ShowMessage('Serie activa detectada para VeriFactu: "' + SerieEval + '"'); // traza temporal
       if Trim(SerieEval) = '' then
       begin
         ShowMessage('No se ha podido determinar la serie activa desde la BD.');
         Exit;
       end;


        if Trim(SerieEval) = '' then
        begin
          // Si no la tienes a mano, preguntamos
          SerieEval := '';
          if not InputQuery('Serie activa', 'Serie a validar (ej: F2025):', SerieEval) then Exit;
        end;

        R := VF_ValidateSerie(TZConnection(dbQuery.Connection), SerieEval);
        if R.Mismatches = 0 then
          ShowMessage('Serie ' + R.Serie + ': OK (' + IntToStr(R.Total) + ' elementos)')
        else
          ShowMessage('Serie ' + R.Serie + ': ' + IntToStr(R.Mismatches) +
                      ' discrepancia(s). Primera en nº ' + R.FirstBadNumero + ' — ' + R.FirstBadMsg);

{ //-- Eliminado para pruebas a ver si ahora localiza la serie

        R := VF_ValidateSerie(Conn, SerieEval);
        if R.Mismatches = 0 then
          ShowMessage('Serie ' + R.Serie + ': OK (' + IntToStr(R.Total) + ' elementos)')
        else
          ShowMessage('Serie ' + R.Serie + ': ' + IntToStr(R.Mismatches) +
                      ' discrepancia(s). Primera en nº ' + R.FirstBadNumero +
                      ' — ' + R.FirstBadMsg);

} //-- Eliminado para pruebas a ver si ahora localiza la serie
      end
      else
      begin
        // —— Todas las series con actividad/hash reciente ——
        VF_ListSeries(Conn, Series);
        try
          if Series.Count = 0 then
          begin
            ShowMessage('No se encontraron series con actividad reciente.');
            Exit;
          end;
          VF_ValidateSeriesList(Conn, Series);
        finally
          Series.Free;
        end;
      end;
     //------------------------------------------
     //------------------------------------------
     //------------------------------------------
        R := VF_ValidateSerie(TZConnection(dbQuery.Connection), SERIEFACT); // ajusta a tu serie
        if R.Mismatches = 0 then
          ShowMessage('Serie ' + R.Serie + ': OK (' + IntToStr(R.Total) + ' elementos)')
        else
          ShowMessage('Serie ' + R.Serie + ': ' + IntToStr(R.Mismatches) +
                      ' discrepancia(s). Primera en nº ' + R.FirstBadNumero + ' — ' + R.FirstBadMsg);
    //=======================================
end;

procedure TFMenu.btnVFReenviarErroresClick(Sender: TObject);
  var
    requeued: Integer;
    Conn: TZConnection;
  begin
    // 1) Usamos la misma conexión que ya utiliza la app
    Conn := TZConnection(dbQuery.Connection);

    // 2) Reencolar todas las líneas con estado = 'ERROR'
    requeued := VF_RequeueAllErrors(Conn);

    // 3) Informar al usuario
    if requeued > 0 then
      ShowMessage('Reencoladas ' + IntToStr(requeued) +
                  ' facturas con estado ERROR. Ahora están en PENDIENTE.')
    else
      ShowMessage('No hay facturas en estado ERROR para reencolar.');

    // 4) Refrescar barra de estado Veri*Factu (cola)
    UpdateVFStatusBar;
  end;

//===========================================================
//======== SERVIDOR LOCAL PRUEBAS VERI*FACTU ================
//===========================================================
procedure TFMenu.IniciarVerifactuLocal;
var
  VF_EnPruebas: Boolean = False;

begin
  // Lee configuración (por ejemplo FacturLinEx.ini, EN este caso YA ESTÁ EN MEMORIA) ASÍ QUE OBVIAMOS ESTA PARTE
  {
  ConfigFile := GetAppConfigFile(False);
  Ini := TIniFile.Create(ConfigFile);
  try
    Modo := UpperCase(Ini.ReadString('VeriFactu', 'Modo', 'PRODUCCION'));
  finally
    Ini.Free;
  end;
  }
  // Si estamos en modo pruebas, arranca el servidor local
  VF_EnPruebas := (vfMode = 'PRUEBAS') or (vfMode = 'TEST');

  if VF_EnPruebas then
  begin
    if not VFMockServerIsRunning then
    begin
      if StartVFMockServer(VF_DEFAULT_PORT) then
      begin
        WriteLn('Servidor VeriFactu local activo en http://127.0.0.1:' +
          IntToStr(VF_DEFAULT_PORT) + '/verifactu/test');
        ShowMessage('🟢 VeriFactu (modo PRUEBAS) activo.' + LineEnding +
          'URL: http://127.0.0.1:' + IntToStr(VF_DEFAULT_PORT) + '/verifactu/test');
      end
      else
        ShowMessage('⚠️ No se pudo iniciar el servidor VeriFactu local.');
    end;
  end
  else
  begin
    StopVFMockServer;
    WriteLn('Servidor VeriFactu local desactivado (modo producción).');
  end;
end;

//====== Detener Servidor Local Veri*Factu ============
procedure TFMenu.DetenerVerifactuLocal;
begin
  if VFMockServerIsRunning then
  begin
    StopVFMockServer;
    WriteLn('Servidor VeriFactu local detenido.');
  end;
end;

//-- Enviar Facturas pendientes al SALIR, SOLO ENVIOS, NADA DE CONTROLES
procedure TFMenu.VF_EnviarPendienteAlSalir;
var
  n: Integer;
begin
  try
    FLX_WriteLog('Menu', 'Inicio de envío VeriFactu.');
    FLX_WriteLog('VF_ExitSend', 'Inicio envío pendiente al cerrar aplicación.'); // -- Para loguear la salida
    // Envía TODO lo pendiente (ajusta el límite a lo que uses en tu proyecto)
    n := VF_DispatchAllPending(1000);  // o 0 si en tu implementación significa "sin límite"

    FLX_WriteLog('VF_ExitSend',
      'Facturas enviadas: ' + IntToStr(n));  //-- Logueo número de facturas enviadas

    // Si quieres que sea totalmente silencioso, comenta este bloque:
    //if n > 0 then
    //  ShowMessage('Se han enviado ' + IntToStr(n) +
    //              ' factura(s) Veri*Factu pendiente(s) a Hacienda.');
  except
    on E: Exception do
    begin
      // Aquí puedes registrar en log y/o notificar algo muy simple
      FLX_WriteLog('VF_ExitSend',
        'ERROR enviando pendientes: ' + E.ClassName + ' - ' + E.Message); //-- Logueo en caso de error
      FLX_WriteLog('Menu', 'Fin de envío VeriFactu.');
      ShowMessage('Error enviando facturas Veri*Factu antes de salir: ' + E.Message);
      // Si prefieres que, aunque falle, la app se cierre igual, no hagas "Abort" ni "Exit" aquí
    end;
  end;
end;


//=================== CERRAR APLICACION ==================
Procedure Tfmenu.Bitbtn8click(Sender: Tobject);
Begin
    // Si quieres pedir confirmación:
  if MessageDlg(
       '¿Quieres enviar ahora a Hacienda las facturas Veri*Factu pendientes antes de salir?',
       mtConfirmation, [mbYes, mbNo], 0
     ) = mrYes then
  begin
    VF_EnviarPendienteAlSalir;
  end;
  Close();
End;
Procedure Tfmenu.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Var
    CopiaSeguridad: TProcess;
    Fecha, HomeDir, DBName: string;
    Txt: string;
Begin
    {$IFDEF LINUX}
    if bbddauto='-1' then
      begin
        ShowMessage('Voy a iniciar la copia de seguridad, esto puede tardar un tiempo, por favor ESPERE, le avisaremos al finalizar');

        if not FLX_RunBackup(
          IniReader.ReadString('BBDD','database',''),
          RutaIni,
          Txt
        ) then
            ShowMessage('ERROR: la copia no se pudo ejecutar. Revisa permisos sudo y el log BACKUP.')
      else
            ShowMessage('La copia ha finalizado, GRACIAS.');
      end;
    {$ENDIF}
   //-- Detener Servidor Veri*Factu LOCAL Pruebas
  if vfMode='PRUEBAS' then DetenerVerifactuLocal;

  // 1) Desactiva timers que llamen a VeriFactu (evita peticiones durante el cierre)
  TimerVF.Enabled := False;
  Timer1.Enabled  := False;   // si aplica
  // 2) Detén cualquier dispatcher/worker tuyo (si tienes hilos propios)
  // DetenerVerifactuDispatcher;  // <-- si existe

  // 3) Ahora para el mock y espera a que cierre
  DetenerVerifactuLocal; // dentro llama a StopVFMockServer (con WaitFor)

  // 4) Continúa con el cierre habitual


  CloseAction:= CaFree;
End;

//===============================================================
//===================== LLAMADAS PENDIENTES =====================
//===============================================================
//----------------- Mostrar / Ocultar Panel -----------------
procedure TFMenu.SpeedButton1Click(Sender: TObject);
begin
   if Panel3.Visible=False then
    Panel3.Visible:=true
  else
    Panel3.Visible:=False;
end;

//----------------- Nueva Llamada ----------------
procedure TFMenu.MenuItem1Click(Sender: TObject);
begin
  LabelLlamada.Caption:='NUEVA LLAMADA / CORREO';
  Panel5.Visible:=True;
  Edit1.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit2.Text:=FormatDateTime('HH:MM:SS',Time);
  Edit3.Text:='';
  Edit3.SetFocus;
end;
//----------------- Borrar llamada ---------------
procedure TFMenu.MenuItem2Click(Sender: TObject);
begin
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   if Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  if dbLlamadas.RecordCount=0 then exit;
  dbLlamadas.Delete;
end;
//----------------- Editar llamada ---------------
procedure TFMenu.MenuItem3Click(Sender: TObject);
begin
  if dbLlamadas.RecordCount=0 then exit;
  LabelLlamada.Caption:='EDITAR LLAMADA / CORREO';
  Edit1.Text:=dbLlamadas.FieldByName('Fechallama').AsString;
  Edit2.Text:=dbLlamadas.FieldByName('Horallama').AsString;
  //dbLlamadas.FieldByName('Usuariollama').Value:=1;
  Edit3.Text:=dbLlamadas.FieldByName('Textollama').AsString;
  Panel5.Visible:=True; Edit3.SetFocus;
end;

//----------------- Editar / Nueva llamada --------
procedure TFMenu.BitBtn48Click(Sender: TObject);
begin
  if Edit1.Text='' then begin showmessage('DEBE RELLENAR LA FECHA'); exit; end;
  if Edit2.Text='' then begin showmessage('DEBE RELLENAR LA HORA'); exit; end;
  if Edit3.Text='' then begin showmessage('DEBE RELLENAR EL TEXTO'); exit; end;
  if LabelLlamada.Caption='NUEVA LLAMADA / CORREO' then
    dbLlamadas.Append else dbLlamadas.Edit;
  dbLlamadas.FieldByName('Fechallama').Value:=StrToDate(Edit1.Text);
  dbLlamadas.FieldByName('Horallama').Value:=StrToTime(Edit2.Text);
  dbLlamadas.FieldByName('Usuariollama').Value:=1;
  dbLlamadas.FieldByName('Textollama').Value:=Edit3.Text;
  dbLlamadas.Post;

  BitBtn49Click(self);

end;

//---------------- Cerrar panel llamadas pendientes
procedure TFMenu.BitBtn49Click(Sender: TObject);
begin
  Panel5.Visible:=False;
end;

//===============================================================
//====================== PEDIDOS PENDIENTES =====================
//===============================================================
//----------------- Mostrar / Ocultar Panel -----------------
procedure TFMenu.SpeedButton2Click(Sender: TObject);
begin
    if Panel4.Visible=False then
    Panel4.Visible:=true
  else
    Panel4.Visible:=False;
end;

//=================== CAMBIAR ICONOS DE AVISO LLAMADAS/PEDIDOS =================
procedure TFMenu.CargaIconos();
var
  Png: TPortableNetworkGraphic;
  Imagen: string;
begin
  Png := TPortableNetworkGraphic.Create;

  try
   Imagen:='LlamadaNo.png';
   if datamodule1.dbConexion.Connected then
     if (dbllamadas.RecordCount<>0) then Imagen:='LlamadaSi.png';

     if (IconoLlamadas <> Imagen) then
       if FileExists(RutaIconos+Imagen) then
        begin
           Png.LoadFromFile(RutaIconos+Imagen);
           Speedbutton1.Glyph.Assign(Png);
           IconoLlamadas:= Imagen;
        end;

     Imagen:='PedidosNo.png';
     if datamodule1.dbConexion.Connected then
       if (dbpedidos.RecordCount<>0) then Imagen:='PedidosSi.png';
     if (IconoPedidos <> Imagen) then
         if FileExists(RutaIconos+Imagen) then
           begin
             Png.LoadFromFile(RutaIconos+Imagen);
             Speedbutton2.Glyph.Assign(Png);
             IconoPedidos:= Imagen;
           end;
  finally
    Png.Free;
  end;
end;
//=================== CHEQUEAR SI HAY AVISO DE LLAMADAS/PEDIDOS =================
procedure TFMenu.Timer1Timer(Sender: TObject);
var
  HoraInicioCopia, HoraFinCopia, HoraActual: TDateTime;
  FicheroCopia: String;
begin
 Timer1.enabled:=False;
 if datamodule1.dbConexion.Connected then begin 
    dbllamadas.Refresh; dbpedidos.Refresh;
 end;
  CargaIconos();

  // Comprobamos si cambió el día.
  if FechaEntrada <> FormatDateTime('DD/MM/YYYY',Date) then
   begin
      ActualizamosPromociones;
      FechaEntrada:=FormatDateTime('DD/MM/YYYY',Date);
   end;

  // Proceso de Copia de Seguridad Automatica
  if global.Copia1Activada='SI' then begin

     HoraInicioCopia:=ComposeDateTime(now(),EncodeTime(StrToInt(global.Copia1InicioHora),StrToInt(global.Copia1InicioMinutos),0,0));
     HoraFinCopia:=ComposeDateTime(now(),EncodeTime(StrToInt(global.Copia1FinHora),StrToInt(global.Copia1FinMinutos),0,0));
     HoraActual:=now();

     if ((HoraInicioCopia<=HoraActual) and (HoraActual<=HoraFinCopia)) then begin
        // La Copia 1 está activada y la hora de ejecución es correcta
        FicheroCopia:=global.Copia1Destino+'/'+global.DBDataBase+'_'+FormatDateTime('yyyymmdd',now)+'_A.sql';
        if FileExists(FicheroCopia) then abort;  // La Copia 1 de hoy ya está hecha
        if not DirectoryExists(global.Copia1Destino) then begin showmessage('No existe el destino para la copia de seguridad 1'+ #13 +
                                                                            'Se cancela el proceso de generación'); abort; end;

        PageControl1.Enabled:=False;  // Deshabilitamos el sistema mientras hacermos la copia de seguridad

        fCopiaSegAuto:=TFCopiaSegAuto.Create(Application);
        fCopiaSegAuto.GenerarSQL(FicheroCopia);  // Se genera el fichero sql de copia de seguridad

        PageControl1.Enabled:=True;  // habilitamos el sistema.

     end;
  end;

  if global.Copia2Activada='SI' then begin

     HoraInicioCopia:=ComposeDateTime(now(),EncodeTime(StrToInt(global.Copia2InicioHora),StrToInt(global.Copia2InicioMinutos),0,0));
     HoraFinCopia:=ComposeDateTime(now(),EncodeTime(StrToInt(global.Copia2FinHora),StrToInt(global.Copia2FinMinutos),0,0));
     HoraActual:=now();

     if ((HoraInicioCopia<=HoraActual) and (HoraActual<=HoraFinCopia)) then begin
        // La Copia 2 está activada y la hora de ejecución es correcta
        FicheroCopia:=global.Copia2Destino+'/'+global.DBDataBase+'_'+FormatDateTime('yyyymmdd',now)+'_B.sql';
        if FileExists(FicheroCopia) then abort;  // La Copia 2 de hoy ya está hecha
        if not DirectoryExists(global.Copia2Destino) then begin showmessage('No existe el destino para la copia de seguridad 2'+ #13 +
                                                                            'Se cancela la generación del proceso'); abort; end;

        PageControl1.Enabled:=False;  // Deshabilitamos el sistema mientras hacermos la copia de seguridad

        fCopiaSegAuto:=TFCopiaSegAuto.Create(Application);
        fCopiaSegAuto.GenerarSQL(FicheroCopia);  // Se genera el fichero sql de copia de seguridad

        PageControl1.Enabled:=True;  // habilitamos el sistema

     end;
  end;

  if global.Copia3Activada='SI' then begin

     HoraInicioCopia:=ComposeDateTime(now(),EncodeTime(StrToInt(global.Copia3InicioHora),StrToInt(global.Copia3InicioMinutos),0,0));
     HoraFinCopia:=ComposeDateTime(now(),EncodeTime(StrToInt(global.Copia3FinHora),StrToInt(global.Copia3FinMinutos),0,0));
     HoraActual:=now();

     if ((HoraInicioCopia<=HoraActual) and (HoraActual<=HoraFinCopia)) then begin
        // La Copia 3 está activada y la hora de ejecución es correcta
        FicheroCopia:=global.Copia3Destino+'/'+global.DBDataBase+'_'+FormatDateTime('yyyymmdd',now)+'_C.sql';
        if FileExists(FicheroCopia) then abort;  // La Copia 3 de hoy ya está hecha
        if not DirectoryExists(global.Copia3Destino) then begin showmessage('No existe el destino para la copia de seguridad 3'+ #13 +
                                                                        'Se cancela la generación del proceso'); abort; end;

        PageControl1.Enabled:=False;  // Deshabilitamos el sistema mientras hacermos la copia de seguridad

        fCopiaSegAuto:=TFCopiaSegAuto.Create(Application);
        fCopiaSegAuto.GenerarSQL(FicheroCopia);  // Se genera el fichero sql de copia de seguridad

        PageControl1.Enabled:=True;  // habilitamos el sistema

     end;
  end;

  Timer1.Enabled:=True;

end;


//===============================================================
//=================== INICIAR POR PRIMERA VEZ ===================
//===============================================================
//------------ Aceptar panel de configuracion y guardar ------------
procedure TFMenu.BitBtn19Click(Sender: TObject);
var
  Txt: String;
  F: TextFile;
  FicheroSql: String;
begin
  //Comprueba que el protocolo escogido en el Combo esté soportado
  if not ServidoresBD[ComboServidoresBD.ItemIndex].soportado then
  begin
    ShowMessage('Actualmente este protocolo no está soportado. Solicite más información en la página del proyecto. Gracias');
    exit;
  end;

  //----------------- Crear BBDD -------
  //------- Con este código evitamos saber donde esta mysql instalado
  datamodule1.dbConexion.HostName:=Edit21.Text;
  datamodule1.dbConexion.User:=Edit22.Text;
  datamodule1.dbConexion.Password:=Edit23.Text;
  datamodule1.dbConexion.Port:=StrToInt(Edit25.Text);
  datamodule1.dbConexion.Protocol:=ComboServidoresBD.Text;
  try
    datamodule1.dbConexion.Connect;
  except
    on e:exception do begin
       begin ShowMessage('¡¡¡ ERROR - CONTACTE CON SOPORTE !!!'+#13+e.message); exit; end;
    end;        // A partir de aquí tiene conexión con el servidor, si no la hubiera, vuelve a la pantalla de inicio
  end;
  if ExisteDB(datamodule1.dbConexion, Edit24.Text) then  //Si existe la BD
    begin     // Pregunta si la quiere usar . Si SI pasa a guardar los datos de config (linea 568)
      If Application.MessageBox('¿DESEA UTILIZAR LA BASE DE DATOS EXISTENTE?','FacturLinEx', boxstyle) = IDNO Then
      Exit;  // Si no, vuelve a la pantalla de inicio
    end
  else       // Si no existe la BD, la intenta crear. Si todo es correcto,
    begin    //acude al script facturlinex2.sql para crear las tablas
      dbQuery.SQL.Text:='CREATE DATABASE '+Edit24.Text;
      try
        dbQuery.ExecSQL;
      except
        on e:exception do begin
           begin ShowMessage('¡¡¡ ERROR - CONTACTE CON SOPORTE !!!'+#13+e.message); exit; end;
        end;
    end;
    //----------------- Crear Tablas -------
    datamodule1.dbConexion.Disconnect;
    datamodule1.dbConexion.Database:=Edit24.Text;
    datamodule1.dbConexion.Connected:=True;
    FicheroSql:= RutaSql+'facturlinex2.sql';
    AssignFile(F,FicheroSql);
    Reset(F);
    while not EOF(F) do
      begin
       Readln(F,Txt);
       if (Txt<>'') and (copy(Txt,1,1)<>'#') then
         begin
           //No hay duda de que es la primera vez que se ejecuta, por lo que no
           // hay miedo de cambiar directamente las XXXX por 0000, así que ...
           Txt:=StringReplace(Txt,'XXXX','0000',[rfReplaceAll]);
           dbQuery.SQL.Text:=Txt;
           dbQuery.ExecSQL; end;
      end;
  end;
  datamodule1.dbConexion.Disconnect;
  //--------------- Guardar datos en el config ---------------
  if not directoryExists(RutaIni) then mkdir(RutaIni);

  IniReader := TIniFile.Create(RutaIni+'FacturConf.ini');
  Sections := TStringList.Create;

  //---------- Sección Empresa ---------
  IniReader.WriteString('datos','nombre','PUNTODEV GNU S.L.');
  IniReader.WriteString('datos','direccion','ARTURO BAREA, 4 - 1 B');
  IniReader.WriteString('datos','poblacion','BADAJOZ');
  IniReader.WriteString('datos','cp','06011');
  IniReader.WriteString('datos','provincia','BADAJOZ');
  IniReader.WriteString('datos','CIF','B06XXXXXX');
  IniReader.WriteString('datos','telefono','924-224066');
  IniReader.WriteString('datos','fax','924-263006');
  IniReader.WriteString('datos','mail','info@puntodev.com');
  //----------- Seccion BBDD -----------
  IniReader.WriteString('BBDD','host',Edit21.Text);
  IniReader.WriteString('BBDD','usuario',Edit22.Text);
  //-- IniReader.WriteString('BBDD','passwd',Edit23.Text);
  FLX_IniWritePassword(IniReader, 'BBDD', 'passwd', Edit23.Text);
  IniReader.WriteString('BBDD','database',Edit24.Text);
  IniReader.WriteString('BBDD','puerto',Edit25.Text);
  IniReader.WriteString('BBDD','protocolo',ComboServidoresBD.Text);
  //----------- Seccion Tienda Activa
  IniReader.WriteString('tienda','codigo','0000');
  IniReader.WriteString('tienda','puesto','A');
  //----------- Seccion SicLinEx -----------
  IniReader.WriteString('BBDD','ActivarSIC','N');
  IniReader.WriteString('BBDD','SIChost','localhost');
  IniReader.WriteString('BBDD','SICusuario','root');
  IniReader.WriteString('BBDD','SICpasswd','');
  IniReader.WriteString('BBDD','SICdatabase','sicLinex');
  IniReader.WriteString('BBDD','SICpuerto','3306');
  IniReader.WriteString('BBDD','SICprotocolo','mysql-5');
  //----------- IVAS
  IniReader.WriteString('Programa','IVA1','18');
  IniReader.WriteString('Programa','IVA2','7');
  IniReader.WriteString('Programa','IVA3','4');
  IniReader.WriteString('Programa','RIVA1','4');
  IniReader.WriteString('Programa','RIVA2','1');
  IniReader.WriteString('Programa','RIVA3','0.5');

  //---------- Sección Tickets ---------
  IniReader.WriteString('tickets','HoraEnTicket','S');
  IniReader.WriteString('tickets','SacaVende','S');
  IniReader.WriteString('tickets','DesgloIva','N');
  IniReader.WriteString('tickets','SacaIva','S');

  //---------- Sección Puntos ---------
  IniReader.WriteString('Puntos','Activar_Puntos','N');
  IniReader.WriteString('Puntos','Activar_Productos','N');
  IniReader.WriteString('Puntos','Porcentaje','0');
  IniReader.WriteString('Puntos','Extra','0');
  IniReader.WriteString('Puntos','Especial','0');

  //---------- Sección de Configuración General ----------
  IniReader.WriteString('CGeneral','Idioma','ESP');
  IniReader.WriteString('CGeneral','Cod_apertura_cajon','000');
  IniReader.WriteString('CGeneral','Cod_balanza','0000000000000');
  IniReader.WriteString('CGeneral','Tarjetas_Varios','N');
  IniReader.WriteString('CGeneral','Precio_IVA_Inc','N');
  IniReader.WriteString('CGeneral','Benficio_Caja','N');
  IniReader.WriteString('CGeneral','Forzar_Albaranes','N');
  IniReader.WriteString('CGeneral','Permitir_Fras_Credito','N');
  IniReader.WriteString('CGeneral','Borra_Albaran_Facturado','N');
  IniReader.WriteString('CGeneral','Mostrar_Oferta','N');
  IniReader.WriteString('CGeneral','Controlar_Horas','N');
  IniReader.WriteString('CGeneral','Activar_Lotes','N');
  IniReader.WriteString('CGeneral','Activar_Envases','N');
  IniReader.WriteString('CGeneral','Agrupar_Envases','N');
  IniReader.WriteString('CGeneral','Avisar_Stock_0','N');
  IniReader.WriteString('CGeneral','Imprimir_Dto','N');
  IniReader.WriteString('CGeneral','Visualiar_antes_imprimir','N');
  IniReader.WriteString('CGeneral','Imprimir_Ticket','Ticketera');
  IniReader.WriteString('CGeneral','Imprimir_Ticket_Regalo','N');
  IniReader.WriteString('CGeneral','Previsualizar_Albaran_Ventas','N');
  IniReader.WriteString('CGeneral','Imprimir_Albaranes','Impresora');
  IniReader.WriteString('CGeneral','Previsualizar_Facturas_Ventas','N');
  IniReader.WriteString('CGeneral','Imprimir_Facturas','Impresora');
  IniReader.WriteString('CGeneral','Importe_Letras_Facturas','N');
  IniReader.WriteString('CGeneral','Tiempo_Visualizar_Aviso','SIEMPRE');
  IniReader.WriteString('CGeneral','PedirUsuario','N');
  IniReader.WriteString('CGeneral','Stock_suficiente','N');
  IniReader.WriteString('CGeneral','Moneda','Euros');
  IniReader.WriteString('CGeneral','CgClienteVario','999999');


  //---- Escribir IniFile
  IniReader.UpdateFile;
  Panel1.Visible:=False; Pagecontrol1.Enabled:=True;

  //----------------- Refrescar datos del datamodule
  Global.Tienda:='0000';
  Global.VeTienda:='0000';
  Global.NTienda:='0';
  Global.Puesto:='A';
  Global.Empresa:='PUNTODEV GNU S.L.';
  Global.Direccion:='ARTURO BAREA, 4 - 3.B';
  Global.Localidad:='BADAJOZ';
  Global.Nif:='B06XXXXXX';
  Global.CP:='06011';
  Global.DBHost:=Edit21.Text;
  Global.DBUsuario:=Edit22.Text;
  Global.DBPasswd:=Edit23.Text;
  Global.DBDataBase:=Edit24.Text;
  Global.DBPuerto:=Edit25.Text;
  Global.DBProtocolo:=ComboServidoresBD.Text;
  Global.ActivarSIC:='N';
  Global.SICHost:='localhost';
  Global.SICDataBase:='sicLinex';
  Global.SICUsuario:='root';
  Global.SICPasswd:='';
  Global.SICPuerto:='3306';
  Global.SICProtocolo:='mysql-5';
  Global.IVA1:=18;Global.IVA2:=7;Global.IVA3:=4;
  Global.RIVA1:=4;Global.RIVA2:=1;Global.RIVA3:=0.5;
  Global.APuntos:='N';
  Global.AProductos:='N';
  Global.Porcentaje:='0';
  Global.Extra:='0';
  Global.Especial:='0';

  //------------- Iniciar normalmente --------
  Iniciar();

end;

//------------ Cerrar panel de configuracion y salir ------------
procedure TFMenu.BitBtn18Click(Sender: TObject);
begin
  Close();
end;

procedure TFMenu.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin

  if (ssAlt in Shift) = False then exit;
  case key of
    VK_1:  PageControl1.ActivePage:= TabSheet1;
    VK_2:  PageControl1.ActivePage:= TabSheet2;
    VK_3:  PageControl1.ActivePage:= TabSheet3;
    VK_4:  PageControl1.ActivePage:= TabSheet4;
    VK_5:  PageControl1.ActivePage:= TabSheet5;
    VK_6:  PageControl1.ActivePage:= TabSheet6;
    VK_7:  PageControl1.ActivePage:= TabSheet7;
    VK_8:  PageControl1.ActivePage:= TabSheet9;
    VK_9:  PageControl1.ActivePage:= TabSheet8;
    VK_0:  PageControl1.ActivePage:= TabSheet10;
  end;
end;

procedure TFMenu.FormShow(Sender: TObject);
begin

 if (LogoEmpresa = '') then exit;
 ImagenLogo.Picture.Clear;
 if FileExists(LogoEmpresa) then ImagenLogo.Picture.LoadFromFile(LogoEmpresa);
 ActualizamosPromociones();

//=========================================================================
//============ AQUI SE REALIZAN LAS LLAMADAS PARA ENVIO  ==================
//=========================================================================
 // Pasa TU conexión actual (aunque esté tipada como abstracta)
  VF_SetConnectionObj(dbQuery.Connection);
  VF_BindUI(@UpdateVFStatusBar, @VF_GetQueuePending);
//=========================================================================
end;

//============================================================================
//============================ USUARIO Y CLAVE DE ACCESO =====================
//============================================================================
//------------------- Aceptar usuario y clave
procedure TFMenu.BitBtn55Click(Sender: TObject);
begin
  if Edit27.Text='' then exit;
  if dbUsuarios.Active=False then exit;
  if dbUsuarios.RecordCount=0 then exit;
  if (Copy(Edit27.Text, 1, 8) <>dbUsuarios.FieldByName('USU10').AsString) then
    begin
       showmessage('ERROR EN EL ACCESO A LA APLICACION.');
       Edit26.SetFocus;
       exit;
    end;
  UsuarioActivo:=Edit26.Text;    // Guardamos el usuario por defecto.
  Panel6.Visible:=False;
  Pagecontrol1.Enabled:=True;
  SpeedButton1.Enabled:=True; SpeedButton2.Enabled:=True;
  CgRol:=dbUsuarios.FieldByName('USU11').AsString;//--------- Rol del usuario

  BitBtn7.Enabled:=CheckRoles(dbRoles, CgRol, 'Tiendas', 1);//------ Rol Ficha Tiendas
  BitBtn12.Enabled:=CheckRoles(dbRoles, CgRol, 'Usuarios', 1);//---- Rol Ficha Usuarios
  BitBtn16.Enabled:=CheckRoles(dbRoles, CgRol, 'Departa', 1);//----- Rol Ficha Departamentos
  BitBtn15.Enabled:=CheckRoles(dbRoles, CgRol, 'Familias', 1);//---- Rol Ficha Familias
  BitBtn11.Enabled:=CheckRoles(dbRoles, CgRol, 'Articulos', 1);//--- Rol Ficha Articulos
  BitBtn10.Enabled:=CheckRoles(dbRoles, CgRol, 'Clientes', 1);//---- Rol Ficha Clientes
  BitBtn14.Enabled:=CheckRoles(dbRoles, CgRol, 'Proveed', 1);//----- Rol Ficha Proveedores
  BitBtn21.Enabled:=CheckRoles(dbRoles, CgRol, 'Formapag', 1);//---- Rol Ficha F. Pagos / Cobros
  BitBtn22.Enabled:=CheckRoles(dbRoles, CgRol, 'Rutas', 1);//------- Rol Ficha Rutas
  BitBtn23.Enabled:=CheckRoles(dbRoles, CgRol, 'Fabrica', 1);//----- Rol Ficha Fabricantes
  BitBtn24.Enabled:=CheckRoles(dbRoles, CgRol, 'Envases', 1);//----- Rol Ficha Envases
  BitBtn42.Enabled:=CheckRoles(dbRoles, CgRol, 'Puestos', 1);//----- Rol Ficha Puestos
  BitBtn35.Enabled:=CheckRoles(dbRoles, CgRol, 'Produccion', 1);//-- Rol Ficha Produccion
end;

//------------------- Cerrar panel usuario y clave
procedure TFMenu.BitBtn56Click(Sender: TObject);
begin
  Close();
end;

//========================= USUARIO ==========================
procedure TFMenu.Edit26Enter(Sender: TObject);
begin
   Edit26.Text:=''; Edit27.Text:='';
end;
procedure TFMenu.Edit26Exit(Sender: TObject);
begin
   if Edit26.Text='' then exit;
   dbUsuarios.SQL.Text:='SELECT * FROM usuarios'+Tienda+' WHERE USU9="'+Edit26.Text+'"';
   dbUsuarios.Active:=True;
   if dbUsuarios.RecordCount=0 then exit;
end;
procedure TFMenu.Edit26KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then Edit27.SetFocus;
end;

procedure TFMenu.Edit27KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then BitBtn55Click(BitBtn55);

end;


// ====================================================================
// ================ CARGADOR DE LOS MODULOS EXTERNOS ==================
// ====================================================================

procedure TFMenu.CargaModulos();
var
 Boton: TBitBtn;
 izq,sup,contModulos: integer;
 Png: TPortableNetworkGraphic;
 Imagen: string;

begin

  if Not(DirectoryExists( RutaModulos )) then begin mkdir(RutaModulos); exit; end;

  with FileListBox1 do
    begin
     Directory:=RutaModulos;
     Mask:='*.cfg';
    end;

  SetLength(BinarioModulos, FileListBox1.Items.Count);

  izq:= 8;sup:= 8;

  for contModulos:=0 to FileListBox1.Items.Count-1 do
   begin

     ModuloConfiguracion := TIniFile.Create(RutaModulos+FileListBox1.Items[contModulos]);
     ModuloSecciones := TStringList.Create;

     ModuloConfiguracion.ReadSections( ModuloSecciones );

     DataModule1.Mensaje('FacturLinEx','Cargando módulo extra '+
                         ModuloConfiguracion.ReadString('Modulo','nombre',''), 1500 , clSilver);

     Boton := TBitBtn.Create(tsModulos1);
     With Boton do
       begin
         Parent := tsModulos1;
         Name := 'modulo'+IntToStr(contModulos);
         ShowHint := True;
         Hint := ModuloConfiguracion.ReadString('Modulo','descripcion','');
         AutoSize:=False;
         Layout:=blGlyphTop;
         Caption := ModuloConfiguracion.ReadString('Modulo','nombre','');
         Enabled:= true;
         Left := izq; // Posicion Izquierda
         Top := sup; // Posicion Arriba
         Width := 80; // Ancho del boton
         Height := 80; // Alto del boton
         Font.Size:=12;
         Setbounds(Left,Top,Width,Height);
         Png := TPortableNetworkGraphic.Create;

         try
           Imagen:=RutaIconos+'Extras.png';
           if FileExists(RutaIconos+ModuloConfiguracion.ReadString('Modulo','icono','')) then
               Imagen:=RutaIconos+ModuloConfiguracion.ReadString('Modulo','icono','');
           Png.LoadFromFile(Imagen);
           Glyph.Assign(Png);
         finally
           Png.Free;
         end;

         OnClick := @ModulosExtraClick;
         Repaint;
       end;

       izq:= izq + 90;
       if izq>1080 then DataModule1.Mensaje('Información','Superado el número máximo de módulos', 3000 , clRed);

       BinarioModulos[contModulos]:= ModuloConfiguracion.ReadString('Modulo','ejecutable','');
   end;

end;

procedure TFMenu.ModulosExtraClick(Sender: TObject);
var
  nomBoton: string;
  numBoton: integer;
  Proceso: TProcess;
  Salida: TStringList;
begin

  // Definición de "proceso" como una variable de tipo "TProcess"
  // También añadimos un TStringList para almacenar los datos
  // leídos desde la salida del programa.

  nomBoton := tBitBtn(sender).Name;
  delete(nomBoton, 1, length(nomBoton)-1);
  numBoton := StrToInt(nomBoton);

  if  ( not (FileExists(BinarioModulos[numBoton]))) and
      ( not (FileExists(RutaModulos+BinarioModulos[numBoton])))  then
    if Application.MessageBox(PChar(' No encuentro el archivo ejecutable :'+ #13 + #13 +
              '       '+ BinarioModulos[numBoton]+ #13 + #13 +
              ' Continuar de todos modos la ejecución ?'), 'FacturLinEx',
              MB_ICONQUESTION + MB_YESNO) <> idYes then Exit;

  Salida := TStringList.Create;
  Proceso := TProcess.Create(nil);

  Proceso.CommandLine := BinarioModulos[numBoton];
  Proceso.Options := Proceso.Options + [poWaitOnExit, poUsePipes];
  proceso.Execute;

  // Ahora leemos la salida del programa que acabamos de ejecutar
  // dentro de TStringList.
  Salida.LoadFromStream(Proceso.Output);
  Salida.SaveToFile('Modulo_'+tBitBtn(sender).Name+'.txt');

  // Ahora que hemos guardado el archivo podemos liberar la memoria
  // TStringList y TProcess.
  Salida.Free;
  Proceso.Free;
end;

Initialization
  {$I menu.lrs}

End.

