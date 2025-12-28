{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2011, Nicolas Lopez de Lerma Aymerich
                           <nicolas@puntodev.com>

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

unit articulos;

{$mode objfpc}{$H+}

interface

uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType, DBGrids,
  TAGraph, TASeries, LR_Class, LR_DBSet, db, DbCtrls, ExtDlgs, Types;

type

  { TFArticulos }

  TFArticulos = class(TForm)
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
    btnClonar: TBitBtn;
    BitBtn21: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    Chart1: TChart;
    Chart1AreaSeries1: TAreaSeries;
    Chart1BarSeries1: TBarSeries;
    Chart1PieSeries1: TPieSeries;
    Chart1Serie1: TLineSeries;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    Datasource3: TDatasource;
    dbArti: TZQuery;
    dbCliSic: TZQuery;
    dbTrabajo: TZQuery;
    DBGrid3: TDBGrid;
    dbpedido: TZQuery;
    DBGrid2: TDBGrid;
    dbEans: TZQuery;
    dbTarifa: TZQuery;
    dbEsta: TZQuery;
    dbBusca: TZQuery;
    DBGrid1: TDBGrid;
    dbFami: TZQuery;
    dbgrafica: TZQuery;
    dbRoles: TZQuery;
    Edit1: TEdit;
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
    Edit43: TEdit;
    Edit44: TEdit;
    Edit45: TEdit;
    Edit46: TEdit;
    Edit47: TEdit;
    Edit48: TEdit;
    Edit49: TEdit;
    Edit5: TEdit;
    Edit50: TEdit;
    Edit51: TEdit;
    Edit52: TEdit;
    Edit53: TEdit;
    Edit54: TEdit;
    Edit55: TEdit;
    Edit56: TEdit;
    Edit57: TEdit;
    Edit58: TEdit;
    Edit59: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label65: TLabel;
    Label68: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    lbBeneficio: TLabel;
    lbIVP: TLabel;
    lbIVC: TLabel;
    lbUV: TLabel;
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
    lbUC: TLabel;
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
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    LabelPrecio: TLabel;
    LabelMax: TLabel;
    LabelMin: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox3: TListBox;
    ListBox4: TListBox;
    ListBox5: TListBox;
    ListBox6: TListBox;
    ListBox9: TListBox;
    Memo1: TMemo;
    OpenPictureDialog1: TOpenPictureDialog;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    ProgressBar1: TProgressBar;
    SicConnect: TZConnection;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    dbClonar: TZQuery;
    lbIC: TLabel;
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
    procedure btnClonarClick(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure Edit16Exit(Sender: TObject);
    procedure Edit17Enter(Sender: TObject);
    procedure Edit17Exit(Sender: TObject);
    procedure Edit18KeyPress(Sender: TObject; var Key: char);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure Edit20Enter(Sender: TObject);
    procedure Edit20Exit(Sender: TObject);
    procedure Edit21KeyPress(Sender: TObject; var Key: char);
    procedure Edit22Enter(Sender: TObject);
    procedure Edit22Exit(Sender: TObject);
    procedure Edit23KeyPress(Sender: TObject; var Key: char);
    procedure Edit24Exit(Sender: TObject);
    procedure Edit26Exit(Sender: TObject);
    procedure Edit27Exit(Sender: TObject);
    procedure Edit28Exit(Sender: TObject);
    procedure Edit29Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit30Exit(Sender: TObject);
    procedure Edit31Exit(Sender: TObject);
    procedure Edit32Exit(Sender: TObject);
    procedure Edit33Exit(Sender: TObject);
    procedure Edit34Exit(Sender: TObject);
    procedure Edit35Exit(Sender: TObject);
    procedure Edit37Exit(Sender: TObject);
    procedure Edit38Exit(Sender: TObject);
    procedure Edit39Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit40Exit(Sender: TObject);
    procedure Edit41Enter(Sender: TObject);
    procedure Edit41Exit(Sender: TObject);
    procedure Edit42KeyPress(Sender: TObject; var Key: char);
    procedure Edit43Exit(Sender: TObject);
    procedure Edit44Exit(Sender: TObject);
    procedure Edit45Exit(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure Edit51Enter(Sender: TObject);
    procedure Edit51Exit(Sender: TObject);
    procedure Edit56Change(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure ListBox4Click(Sender: TObject);
    procedure ListBox5Click(Sender: TObject);
    procedure ListBox9Click(Sender: TObject);
    procedure LlenaReg();
    procedure LlenaEans();
    procedure PintaEans();
    procedure Relleno();
    procedure LimpiaForm();
    procedure LimpiaAuxiliares();
    procedure BarraStock();
    procedure PintaTarifa();
    procedure GuardaTarifa();
    procedure CreaEstadistica();
    procedure Graficas();
    procedure RellenaEsta(Ano: String);
    procedure CambiarGrafica();
    procedure ActivarCgoAux();
    procedure DesactivarCgoAux();
    procedure GrabarModificarSic();
    procedure RellenaSIC();
    procedure BorrarSic();
    function LeerArtiSic: Boolean;
    procedure CargaSIC();


  private
    { private declarations }
  public
    { public declarations }
  end;

  procedure ShowFormArticulos;

var
  FArticulos: TFArticulos;
  CargaGrafica,NTienda: Integer;
  s: TBarSeries;
  CodArtiSic: String;

implementation

uses
  Global, Funciones, Busquedas;

{ TFArticulos }

//=============== Crea el formulario ================
procedure ShowFormArticulos;
begin
  with TFArticulos.Create(Application) do
    begin
       ShowModal;
    end;
end;

procedure TFArticulos.FormCreate(Sender: TObject);
begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);      // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbArti.Sql.Text:='SELECT * FROM artitien'+Tienda+' ORDER BY A0';
  dbArti.Active := True;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Articulos', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Articulos', 3);//------------------ Boton Borrar
  if CheckRoles(dbRoles, CgRol, 'Articulos', 4)=False then Tabsheet3.Destroy;//--- Estadisticas
  if CheckRoles(dbRoles, CgRol, 'Articulos', 4)=False then Tabsheet5.Destroy;//--- Graficas
  if CheckRoles(dbRoles, CgRol, 'Articulos', 5)=False then Tabsheet4.Destroy;//--- Costos
  //---------------- CONEXION SIC -----------------
  if ActivarSIC='S' then
   begin
    SicConnect.HostName:=SICHost;
    SicConnect.Database:=SICDataBase;
    SicConnect.User:=SICUsuario;
    SicConnect.Password:=SICPasswd;
    SicConnect.Port:=StrToInt(SICPuerto);
    SicConnect.Protocol:=SICProtocolo;
    SicConnect.Connected:=True;
    BitBtn15.Visible:=True;
   end;
  //------------- CONFIGURACION CHECKBOX -------------
  {$IFDEF LINUX}
     CheckBox1.Checked := True;
  {$ELSE}
     CheckBox1.Checked := False;
     CheckBox1.Enabled := False;
     CheckBox1.Visible := False;
  {$ENDIF}
  LimpiaForm();// Inicializar los edit del formulario
end;

//================ CERRAR FORMULARIO ================
procedure TFArticulos.BitBtn1Click(Sender: TObject);
begin
  dbEans.Active:=False; dbTrabajo.Active:=False; dbArti.Active:=False;
  dbBusca.Active:=False; dbEsta.Active:=False; dbFami.Active:=False;
  dbgrafica.Active:=False; dbpedido.Active:=False; dbTarifa.Active:=False;
  Close();
end;

procedure TFArticulos.btnClonarClick(Sender: TObject);
var
  busqueda: string;
begin
  // Procedimiento para clonar registros de artículos
  busqueda := InputBox('FacturLinEx 2','Introducir ARTICULO','');
  if not (busqueda = '') then begin
     if dbClonar.Active=True then dbClonar.Active:=False;
     dbClonar.SQL.Clear;
     dbClonar.SQL.Add('SELECT * FROM artitien'+Tienda+' WHERE A0='''+busqueda+'''');
     dbClonar.Open;
     if dbClonar.RecordCount>0 then begin
        Edit2.Text:=dbClonar.FieldByName('A1').AsString;//-------------- Nombre
        Edit3.Text:=dbClonar.FieldByName('A21').AsString;//------------- Precio sin Iva
        Edit4.Text:=dbClonar.FieldByName('A3').AsString;//-------------- Iva
        Edit5.Text:=dbClonar.FieldByName('A2').AsString;//-------------- P.V.P.

        Edit7.Text:=dbClonar.FieldByName('A5').AsString;//-------------- Stock Minimo
        Edit8.Text:=dbClonar.FieldByName('A6').AsString;//-------------- Stock Maximo

        Edit9.Text:=dbClonar.FieldByName('A7').AsString;//-------------- Descuento 1
        Edit10.Text:=dbClonar.FieldByName('A8').AsString;//------------- Descuento 2
        Edit11.Text:=dbClonar.FieldByName('A9').AsString;//------------- Descuento 3

        Edit20.Text:=dbClonar.FieldByName('A14').AsString;//------------ Familia
        Memo1.Lines.Text:=dbClonar.FieldByName('A17').AsString;//------- Observaciones
        Edit17.Text:=dbClonar.FieldByName('A20').AsString;//------------ Autor / Fabricante
        Edit19.Text:=dbClonar.FieldByName('A23').AsString;//------------ Ubicacion
     end;
     dbClonar.Close;
  end;
end;

procedure TFArticulos.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//=================== REGISTRO NUEVO ===================
procedure TFArticulos.BitBtn2Click(Sender: TObject);
begin
  btnClonar.Enabled:=False;
  if Edit1.Text='' then exit;
  if dbArti.Locate('A0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO YA EXISTE');
      exit;
    end;
   dbArti.Append; LlenaReg(); dbArti.Post;//---- Datos Articulos
   CreaEstadistica();//------------------------- Crear estadisticas vacias
   GuardaTarifa();//---------------------------- Crear Tarifa de precios
   Label2.Caption:=dbArti.FieldByName('A1').AsString;
   if ActivarSIC='S' then GrabarModificarSic();//------ Comprobar si se crea cliente en el SIC.
   ActivarCgoAux();//----------- Activar Codigos Auxiliares
end;

//=================== BORRAR REGISTRO ===================
procedure TFArticulos.BitBtn3Click(Sender: TObject);
begin
  if Edit1.Text='' then exit;
  if not dbArti.Locate('A0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
  Application.MessageBox(' OJO, va ha BORRAR TOTALMENTE EL ARTÍCULO, CON TODOS SUS EANS Y CONTENIDO'+ sLineBreak +'SI PROSIGUE EN EL SIGUIENTE PASO','AVISO !!!!!!!', MB_ICONEXCLAMATION);
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  //------ Borrar Estadisticas
  dbEsta.SQL.Text:='SELECT * FROM estaarti'+Tienda+' WHERE TA0="'+Edit1.Text+'"';
  dbEsta.Active:=True;
  if dbEsta.RecordCount<>0 then dbEsta.Delete;
  //------ Borrar Tarifa
  dbTarifa.Active:=False;
  dbTarifa.Sql.Text:='SELECT * FROM tarifas WHERE TAR0="'+Edit1.Text+'"';
  dbTarifa.Active:=True;
  if dbTarifa.RecordCount<>0 then dbTarifa.Delete;
  //------ Borrar Cgos. Auxiliares
  dbEans.Active:=False;
  dbEans.Sql.Text:='DELETE FROM eans WHERE EAN1="'+Edit1.Text+'"';
  dbEans.ExecSQL;
  //------ Historico de compra
  dbPedido.Active:=False;
  dbPedido.Sql.Text:='DELETE FROM ultimopedi'+Tienda+' WHERE AP0="'+Edit1.Text+'"';
  dbPedido.ExecSQL;
  //-----------------------
  CodArtiSic:=dbArti.FieldByName('A34').AsString;//---- Para leer articulo en el sic.
  dbArti.Delete;//---- Borrar articulo
  if ActivarSIC='S' then BorrarSic();//------ Comprobar si se crea cliente en el SIC.
  Edit1.Text := ''; LimpiaForm();
end;

//=================== MODIFICAR ===================
procedure TFArticulos.BitBtn4Click(Sender: TObject);
begin
   if (Edit1.Text='') or (dbArti.Recordcount=0) then exit;
   if not dbArti.Locate('A0,', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO!');
       exit;
     end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
   dbArti.Edit; LlenaReg(); dbArti.Post;
   GuardaTarifa();//------- Modificar Tarifa de precios
   Label2.Caption:=dbArti.FieldByName('A1').AsString;
   if ActivarSIC='S' then GrabarModificarSic();//------ Comprobar si se modifica cliente en el SIC.
end;

//==================== BUSCAR REGISTRO  =======
procedure TFArticulos.BitBtn21Click(Sender: TObject);
begin
 if Edit2.Text='' then
  begin
   ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
   Edit2.SetFocus;
   Exit;
  end;
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT A0, A1 FROM artitien'+Tienda+
                  ' WHERE A1 LIKE "%'+Edit2.Text+'%"', ['Código','Referencia'],'A0');
  if Edit1.Text='-1' then Edit1.Text:='' else Edit1Exit(Edit1);
end;

//==================== REG. ANTERIOR ===============
procedure TFArticulos.BitBtn5Click(Sender: TObject);
begin
  dbArti.Prior;
  LimpiaForm(); Relleno();
end;

//==================== REG. POSTERIOR ===============
procedure TFArticulos.BitBtn6Click(Sender: TObject);
begin
  dbArti.Next;
  LimpiaForm(); Relleno();
end;

//=============== SALIR DEL PRECIO SIN IVA ==============
procedure TFArticulos.Edit3Exit(Sender: TObject);
var
  PrecioCon: double;
begin
//  Edit3.Text:=Edit27.Text;
  if (Edit3.Text='') or (Edit3.Text='0') then exit;
  if (Edit4.Text<>'0') and (Edit4.Text<>'') then
     begin
       PrecioCon:=(StrToFloat(Edit3.Text) * StrToFloat(Edit4.Text) / 100) +
                   StrToFloat(Edit3.Text); //--- Sumar el IVA
       Edit5.Text:=FormatFloat('0.00',PrecioCon);
       //Edit4.Text:=Edit28.Text; Edit5.Text:=Edit29.Text;
       LabelPrecio.Caption:=Edit5.Text;
     end;
end;

//=============== SALIR DEL IVA ===================
procedure TFArticulos.Edit4Exit(Sender: TObject);
var
   PrecioCon: Double;
begin
   if (Edit3.Text='') or (Edit3.Text='0') then exit;
   if (Edit4.Text='') or (Edit4.Text='0') then exit;
   PrecioCon:=(StrToFloat(Edit3.Text) * StrToFloat(Edit4.Text) / 100) + StrToFloat(Edit3.Text); //--- Sumar el IVA
   Edit5.Text:=FormatFloat('0.00',PrecioCon);
   //Edit4.Text:=Edit28.Text; Edit5.Text:=Edit29.Text;
   LabelPrecio.Caption:=Edit5.Text;
   Edit28.Text:=Edit4.Text;
   Edit28Exit(Edit28);
   Edit29Exit(Edit29);
end;

//================ SALIR DEL PVP ==================
procedure TFArticulos.Edit5Exit(Sender: TObject);
var
   PrecioSin: Double;
begin
   if (Edit5.Text='') or (Edit5.Text='0') then exit;
   if (Edit4.Text='') or (Edit4.Text='0') then exit;
   PrecioSin := (100 * StrToFloat(Edit5.text)) / (100 + StrToFloat(Edit4.Text));
   Edit3.Text:=FormatFloat('0.000',PrecioSin); Edit3Exit(Edit3);
   //Edit5.Text:=Edit29.Text;
   LabelPrecio.Caption:=Edit5.Text;
   Edit29.Text:=Edit5.Text;
   Edit29Exit(Edit29);
end;

//=============== SALIR DEL PRECIO TARIFA ====================
procedure TFArticulos.Edit37Exit(Sender: TObject);
Var
  MenosEuros: Double;
begin
  if Edit1.Text='' then exit;
  if Edit37.Text='' then Edit37.Text:='0';
  MenosEuros:=StrToFloat(Edit37.Text);
  if Edit38.Text<>'0' then MenosEuros := StrtoFloat(Edit37.Text)-StrtoFloat(Edit38.Text);
  if Edit39.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit39.Text) / 100);
  if Edit40.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit40.Text) / 100);
  if MenosEuros<>0 then Edit24.Text := FormatFloat('0.000',MenosEuros);//-- Costo
end;

//=============== SALIR DEL DTO. IMPORTE ====================
procedure TFArticulos.Edit38Exit(Sender: TObject);
var
  MenosEuros: Double;
begin
  if Edit37.Text='' then Edit37.Text:='0';
  if Edit38.Text='' then Edit38.Text:='0';
  MenosEuros := StrtoFloat(Edit37.Text)-StrtoFloat(Edit38.Text);
  if Edit39.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit39.Text) / 100);
  if Edit40.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit40.Text) / 100);
  if MenosEuros<>0 then Edit24.Text := FormatFloat('0.000',MenosEuros);//-- Costo
end;

//=============== SALIR DEL DTO. % 1 ====================
procedure TFArticulos.Edit39Exit(Sender: TObject);
Var
  MenosEuros: Double;
begin
  if Edit37.Text='' then Edit37.Text:='0';
  if Edit38.Text='' then Edit38.Text:='0';
  if Edit39.Text='' then Edit39.Text:='0';
  MenosEuros:=StrToFloat(Edit37.Text);
  if Edit38.Text<>'0' then MenosEuros := StrtoFloat(Edit37.Text)-StrtoFloat(Edit38.Text);
  if Edit39.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit39.Text) / 100);
  if Edit40.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit40.Text) / 100);
  if MenosEuros<>0 then Edit24.Text := FormatFloat('0.000',MenosEuros);
end;

//=============== SALIR DEL DTO. % 2 ====================
procedure TFArticulos.Edit40Exit(Sender: TObject);
Var
  MenosEuros: Double;
begin
  if Edit37.Text='' then Edit37.Text:='0';
  if Edit38.Text='' then Edit38.Text:='0';
  if Edit39.Text='' then Edit39.Text:='0';
  if Edit40.Text='' then Edit40.Text:='0';
  MenosEuros:=StrToFloat(Edit37.Text);
  if Edit38.Text<>'0' then MenosEuros := StrtoFloat(Edit37.Text)-StrtoFloat(Edit38.Text);
  if Edit39.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit39.Text) / 100);
  if Edit40.Text<>'0' then MenosEuros := MenosEuros - (MenosEuros * StrToFloat(Edit40.Text) / 100);
  if MenosEuros<>0 then Edit24.Text := FormatFloat('0.000',MenosEuros);
end;

//=============== SALIR DEL COSTO ====================
procedure TFArticulos.Edit24Exit(Sender: TObject);
Var
  Precio, PrecioCon : Double;
begin
  if (StrToFloat(Edit24.Text)=0) or (Edit24.Text='') then exit;
  if (StrToFloat(Edit26.Text)=0) or (Edit26.Text='') then exit;
  Precio:=(StrToFloat(Edit24.text)*StrToFloat(Edit26.text)/100)+StrToFloat(Edit24.text);// ---- Añadir Margen
  PrecioCon:=Precio;
  Edit27.Text := FormatFloat('0.000',PrecioCon);
  Edit3.Text:=Edit27.Text;//--- Precio en la ficha principal
end;

//=============== SALIR DEL MARGEN (ALMACEN) ====================
procedure TFArticulos.Edit26Exit(Sender: TObject);
Var
  Precio, PrecioCon : Double;
begin
  if (StrToFloat(Edit24.Text)=0) or (Edit24.Text='') then exit;
  if (StrToFloat(Edit26.Text)=0) or (Edit26.Text='') then exit;
  Precio:=(StrToFloat(Edit24.text)*StrToFloat(Edit26.text)/100)+StrToFloat(Edit24.text);
  PrecioCon:=Precio;
  Edit27.Text := FormatFloat('0.000',PrecioCon);
  Edit3.Text := Edit27.Text;
end;

//============== SALIR DEL PRECION SIN IVA ===========
procedure TFArticulos.Edit27Exit(Sender: TObject);
var
  PvpConIva, PvpSinIva, Margen, MargenSPvp, CosteSinIva, CosteConIva, CostoCero, PrecioCon: double;
  IvaArt, REArt: double;
begin
  Edit3.Text:=Edit27.Text;
  if (Edit27.Text='') or (StrToFloat(Edit27.Text)=0) then exit;
  //---------- Calcular margen sobre el pvp y margen normal
  if (Edit24.Text <> '') and (StrToFloat(Edit24.Text)<>0) then
    begin
{
      PvpSinIva := StrToFloat(Edit27.text);
      Margen := (PvpSinIva - StrToFloat(Edit24.Text)) * 100 / StrToFloat(Edit24.Text);
}

      CosteSinIva := StrToFloat(Edit24.Text);
      PvpConIva := StrToFloat(Edit29.text);
      IvaArt := StrToFloat(Edit28.Text);
      REArt :=StrToFloat(Edit58.Text);
      CosteConIva := CosteSinIva * (1 + ((IvaArt + REArt) / 100 ));
      Margen := ((PvpConIva - CosteConIva) * 100) / CosteConIva;
      Edit26.Text := FormatFloat('0.000',Margen);  //-- Margen Normal
      MargenSPvp := ((CosteConIva / PvpConIva) -1 ) * (-100);
      Edit59.Text := FormatFloat('0.000',MargenSPvp);  //-- Margen Sobre el PVP
    end
  else
    begin
      //------- Calcular costo cuando es 0
      if (Edit26.Text<>'') and (StrToFloat(Edit26.Text)<>0) then
       begin
        CostoCero := (100 * StrToFloat(Edit27.text)) / (100 + StrToFloat(Edit26.Text));
        Edit24.Text:=FormatFloat('0.000',CostoCero); Edit24Exit(Edit24);
       end;
    end;
   //------ Calcular precio con iva si hay iva ---------
   if (StrToFloat(Edit28.Text)<>0) and (Edit28.Text<>'') then
     begin
       PrecioCon:=(StrToFloat(Edit27.Text) * (StrToFloat(Edit28.Text)+StrToFloat(Edit58.Text)) / 100) +
                   StrToFloat(Edit27.Text); //--- Sumar el IVA
       Edit29.Text:=FormatFloat('0.00',PrecioCon);
       Edit4.Text:=Edit28.Text; Edit5.Text:=Edit29.Text; LabelPrecio.Caption:=Edit5.Text;
     end;
end;

//==================== SALIR DEL IVA (ALMACEN) =================
procedure TFArticulos.Edit28Exit(Sender: TObject);
var
   PrecioCon: Double;
begin
   if (Edit27.Text='') or (StrToFloat(Edit27.Text)=0) then exit;
   if (Edit28.Text='') or (StrToFloat(Edit28.Text)=0) then exit;
   PrecioCon:=(StrToFloat(Edit27.Text) * (StrToFloat(Edit28.Text)+StrToFloat(Edit58.Text)) / 100) + StrToFloat(Edit27.Text); //--- Sumar el IVA
   Edit29.Text:=FormatFloat('0.00',PrecioCon);
   Edit4.Text:=Edit28.Text; Edit5.Text:=Edit29.Text; LabelPrecio.Caption:=Edit5.Text;
end;

//==================== SALIR DEL PVP (ALMACEN) =================
procedure TFArticulos.Edit29Exit(Sender: TObject);
var
   PrecioSin: Double;
begin
   if (Edit29.Text='') or (StrToFloat(Edit29.Text)=0) then exit;
   if (Edit28.Text='') or (StrToFloat(Edit28.Text)=0) then exit;
   PrecioSin := (100 * StrToFloat(Edit29.text)) / (100 + StrToFloat(Edit28.Text) + StrToFloat(Edit58.Text));
   Edit27.Text:=FormatFloat('0.000',PrecioSin); Edit27Exit(Edit27);
   Edit5.Text:=Edit29.Text;  LabelPrecio.Caption:=Edit5.Text;
end;

//================= CODIGO ARTICULO ================
procedure TFArticulos.Edit1Enter(Sender: TObject);
begin
 Edit1.Text := '';
 Edit51.Text:='';
 LimpiaForm();
 btnClonar.Enabled:=False;
end;
procedure TFArticulos.Edit1Exit(Sender: TObject);
begin
  if Edit1.Text='' then begin
     exit;
  end;
  if dbArti.Locate('A0', Edit1.Text, []) then begin  Relleno();  exit;  end;
  //------------------- Buscar por eans
  dbEans.Active:=False;
  dbEans.SQL.Text:='SELECT * FROM eans WHERE EAN0="'+ Edit1.Text +'"';
  dbEans.Active:=True;
  if dbEans.RecordCount<>0 then
    if dbArti.Locate('A0', dbEans.FieldByName('EAN1').Value, []) then begin Relleno(); exit; end;
  //--------------------
//--  LimpiaForm(); Con esto se permite clonar articulos
  btnClonar.Enabled:=True;
end;

procedure TFArticulos.Edit1KeyPress(Sender: TObject; var Key: char);
begin
//--  if (key=#13) then Edit2.SetFocus; Cambia el foco para buscar
  if (key=#13) then Edit1Exit(Edit1);
  if (key=#8) then
     begin
        Edit6.Text:='0';
     end;
end;

//=================== BUSCAR ARTICULOS =================
procedure TFArticulos.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn21Click(Self);
end;

//================ CODIGO DE FAMILIA ===============
procedure TFArticulos.Edit20Enter(Sender: TObject);
begin
  Edit21.Text:='';
end;
procedure TFArticulos.Edit20Exit(Sender: TObject);
begin
  if Edit20.Text='' then exit;
  Edit21.text:= devuelvevalor('SELECT * FROM familias'+Tienda+' WHERE F0='+Edit20.Text,dbBusca,Edit20.text,'F1');
end;

//================ BUSCAR FAMILIAS ====================
procedure TFArticulos.BitBtn11Click(Sender: TObject);
begin
  if Edit21.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit21.SetFocus;
     Exit;
  end;
  Edit20.Text:=FBusquedas.IniciaBusquedas('SELECT F0,F1 FROM familias'+Tienda+' WHERE F1 LIKE "%'+Edit21.Text+'%"',['Código','Nombre'],'F0');
  if Edit20.Text='-1' then Edit20.Text:='' else Edit20Exit(Edit20);
end;

procedure TFArticulos.Edit21KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn11Click(BitBtn11);
end;

//================ CODIGO DE AUTOR FABRICANTE ===============
procedure TFArticulos.Edit17Enter(Sender: TObject);
begin
  Edit18.Text:='';
end;
procedure TFArticulos.Edit17Exit(Sender: TObject);
begin
  if Edit17.Text='' then exit;
  Edit18.text:= devuelvevalor('SELECT * FROM autofabri WHERE AUT0='+Edit17.Text,dbBusca,Edit17.text,'AUT1');
end;

//================ BUSCAR AUTOR / FABRICANTE ============
procedure TFArticulos.BitBtn10Click(Sender: TObject);
begin
  if Edit18.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit18.SetFocus;
     Exit;
  end;
  Edit17.Text:=FBusquedas.IniciaBusquedas('SELECT AUT0,AUT1 FROM autofabri WHERE AUT1 LIKE "%'+Edit18.Text+'%"',['Código','Nombre'],'AUT0');
  if Edit17.Text='-1' then Edit17.Text:='' else Edit17Exit(Edit1);
end;

procedure TFArticulos.Edit18KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn10Click(BitBtn10);
end;

//================== CODIGO PROVEEDOR ================
procedure TFArticulos.Edit41Enter(Sender: TObject);
begin
  Edit42.Text:='';
end;
procedure TFArticulos.Edit41Exit(Sender: TObject);
begin
  if Edit41.Text='' then exit;
  Edit42.text:= devuelvevalor('SELECT P0,P1 FROM proveedores WHERE P0='+Edit41.Text,dbBusca,Edit41.text,'P1');
end;

//================= BUSCAR PROVEEDORES ==============
procedure TFArticulos.BitBtn19Click(Sender: TObject);
begin
  if Edit42.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit42.SetFocus;
     Exit;
  end;
  Edit41.Text:=FBusquedas.IniciaBusquedas('SELECT P0,P1 FROM proveedores WHERE P1 LIKE "%'+Edit42.Text+'%"',['Código','Nombre'],'P0');
  if Edit41.Text='-1' then Edit41.Text:='' else Edit41Exit(Edit41);
end;

procedure TFArticulos.Edit42KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn19Click(BitBtn19);
end;

//===================== BUSQUEDA DE ENVASES =====================
procedure TFArticulos.BitBtn13Click(Sender: TObject);
begin
  if Edit23.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit23.SetFocus;
     Exit;
  end;
  Edit22.Text:=FBusquedas.IniciaBusquedas('SELECT EN0,EN1 FROM envas WHERE EN1 LIKE "%'+Edit23.Text+'%"',['Código','Nombre'],'EN0');
  if Edit22.Text='-1' then Edit22.Text:='' else Edit22Exit(Edit22);
end;

procedure TFArticulos.Edit23KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn13Click(BitBtn13);
end;

//=================== CODIGO ENVASE ==================
procedure TFArticulos.Edit22Enter(Sender: TObject);
begin
  Edit23.Text:='';
end;
procedure TFArticulos.Edit22Exit(Sender: TObject);
begin
  if Edit22.Text='' then exit;
  Edit23.text:= devuelvevalor('SELECT EN0,EN1 FROM envas WHERE EN0="'+Edit22.Text+'"',dbBusca,Edit22.text,'EN1');
end;

//==================== IMAGEN =======================
procedure TFArticulos.Edit16Exit(Sender: TObject);
begin
  if Edit16.Text='' then
    begin
      Image1.Picture:=Nil; Image1.Refresh;
      exit;
    end;
  if RutaImagenes='' then begin showmessage('PRIMERO DEBE DEFINIR LA CARPETA DE LAS IMAGENES EN CONFIGURACION->PROG.EXTERNOS'); exit; end;
  if not DirectoryExists(RutaImagenes) then begin showmessage('LA CARPETA DE LAS IMAGENES NO EXISTE, REVISE CONFIGURACION->PROG.EXTERNOS'); exit; end;
  if FileExists(RutaImagenes+Edit16.Text) then
    Image1.Picture.LoadFromFile(RutaImagenes+Edit16.Text)
  else
    begin
     Image1.Picture:=Nil; Image1.Refresh;
    end;
end;
procedure TFArticulos.BitBtn12Click(Sender: TObject);
begin
  if RutaImagenes='' then begin showmessage('PRIMERO DEBE DEFINIR LA CARPETA DE LAS IMAGENES EN CONFIGURACION->PROG.EXTERNOS'); exit; end;
  if not DirectoryExists(RutaImagenes) then begin showmessage('LA CARPETA DE LAS IMAGENES NO EXISTE, REVISE CONFIGURACION->PROG.EXTERNOS'); exit; end;
  OpenPictureDialog1.InitialDir:=RutaImagenes;
  if OpenPictureDialog1.Execute then
   begin
     if RutaImagenes<>Copy(OpenPictureDialog1.FileName,1,Length(RutaImagenes)) then
         begin showmessage('NO PUEDE CARGAR IMAGENES DE OTRA CARPETA DISTINTA A LA SELECCIONADA EN LA CONFIGURACION'); exit; end;
     Edit16.Text:=StringReplace(OpenPictureDialog1.FileName,RutaImagenes,'',[rfReplaceAll]);
     if FileExists(OpenPictureDialog1.FileName) then
       Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName)
   end;
end;

//===================== LIMPIAR DATOS =======================
Procedure TFArticulos.LimpiaForm();
Begin
  Edit2.Text:=''; Edit3.Text:=''; Edit4.Text:=''; Edit5.Text:='';
  Edit6.Text:=''; Label2.Caption:=''; LabelPrecio.Caption:='';
  Edit7.Text:=''; Edit8.Text:=''; Edit9.Text:=''; Edit10.Text:='';
  Edit11.Text:=''; Edit12.Text:=''; Edit13.Text:='';
  Edit14.Text:=''; Memo1.Lines.Text:=''; Edit15.Text:='';
  Edit16.Text:=''; Edit17.Text:=''; Edit18.Text:='';
  Edit19.Text:=''; Edit20.Text:=''; Edit21.Text:=''; Edit22.Text:='';
  Image1.Picture:=Nil;
  Edit23.Text:=''; Edit24.Text:='0'; Edit25.Text:='0'; Edit26.Text:='0';
  Edit27.Text:='0'; Edit28.Text:='0'; Edit29.Text:='0'; Edit30.Text:='0';
  Edit31.Text:='0'; Edit32.Text:='0'; Edit33.Text:='0'; Edit34.Text:='0';
  Edit35.Text:='0'; Edit36.Text:=''; Edit37.Text:='0'; Edit38.Text:='0';
  Edit39.Text:='0'; Edit40.Text:='0'; Edit41.Text:=''; Edit42.Text:='';
  Edit43.Text:='0'; Edit44.Text:='0'; Edit45.Text:='0'; Edit46.Text:='';
  Edit47.Text:=''; Edit48.Text:=''; Edit49.Text:=''; Edit50.Text:='';
  Edit51.Text:=''; Edit52.Text:=''; Edit53.Text:=''; Edit54.Text:='';
  Edit55.Text:=''; Edit56.Text:='0'; Edit59.Text:='0';
  Edit58.Text:='0';
  ProgressBar1.Min:=0;ProgressBar1.Max:=1;ProgressBar1.Position:=0;
  CheckBox3.Checked:=False; CheckBox4.Checked:=False; CheckBox5.Checked:=False;
  DesactivarCgoAux();//----------- Activar Codigos Auxiliares
End;

//===================== PINTAR DATOS =======================
Procedure TFArticulos.Relleno();
Begin
  if dbArti.RecordCount=0 then exit;
  Label2.Caption:=dbArti.FieldByName('A1').AsString;
  Edit1.Text:=dbArti.FieldByName('A0').AsString;//-------------- Cgo.
  Edit2.Text:=dbArti.FieldByName('A1').AsString;//-------------- Nombre
  Edit3.Text:=dbArti.FieldByName('A21').AsString;//------------- Precio sin Iva
  Edit4.Text:=dbArti.FieldByName('A3').AsString;//-------------- Iva
  Edit5.Text:=dbArti.FieldByName('A2').AsString;//-------------- P.V.P.
  LabelPrecio.Caption:=Edit5.Text;

  Edit6.Text:=dbArti.FieldByName('A4').AsString;//-------------- Stock Actual
  Edit7.Text:=dbArti.FieldByName('A5').AsString;//-------------- Stock Minimo
  Edit8.Text:=dbArti.FieldByName('A6').AsString;//-------------- Stock Maximo

  Edit9.Text:=dbArti.FieldByName('A7').AsString;//-------------- Descuento 1
  Edit10.Text:=dbArti.FieldByName('A8').AsString;//------------- Descuento 2
  Edit11.Text:=dbArti.FieldByName('A9').AsString;//------------- Descuento 3

  Edit12.Text:=dbArti.FieldByName('A10').AsString;//------------ Minimo a pedir
  Edit13.Text:=dbArti.FieldByName('A11').AsString;//------------ Pendientes en pedidos
  Edit14.Text:=dbArti.FieldByName('A12').AsString;//------------ Fecha Ult. Venta
  Edit15.Text:=dbArti.FieldByName('A13').AsString;//------------ Fecha Ult. Pedido
  Edit20.Text:=dbArti.FieldByName('A14').AsString;//------------ Familia
  Edit20Exit(Edit20);//----------------------------------------- Consultar familia
  Edit16.Text:=dbArti.FieldByName('A16').AsString;//------------ Imagen
  if dbArti.FieldByName('A38').AsString='Y' then  //------------ Publicar en tienda virtual
    CheckBox1.Checked := True
  else
    CheckBox1.Checked := False;

if (Edit16.Text<>'') and (FileExists(RutaImagenes+Edit16.Text)) then
    Image1.Picture.LoadFromFile(RutaImagenes+Edit16.Text);
  Memo1.Lines.Text:=dbArti.FieldByName('A17').AsString;//------- Observaciones
  Edit22.Text:=dbArti.FieldByName('A19').AsString;//------------ Cgo. Envase
  Edit22Exit(Edit22);//----------------------------------------- Consultar Envase
  Edit17.Text:=dbArti.FieldByName('A20').AsString;//------------ Autor / Fabricante
  Edit17Exit(Edit17);//----------------------------------------- Consultar Autor/Fabri.
  Edit19.Text:=dbArti.FieldByName('A23').AsString;//------------ Ubicacion

  Edit24.Text:=FormatFloat('0.000',dbArti.FieldByName('A24').AsFloat);//------- Costo
  Edit25.Text:=FormatFloat('0.000',dbArti.FieldByName('A25').AsFloat);//------- Costo medio
  Edit26.Text:=FormatFloat('0.000',dbArti.FieldByName('A26').AsFloat);//------- Margen de venta
  Edit59.Text:=FormatFloat('0.000',dbArti.FieldByName('A37').AsFloat);//-------- Margen Sobre la Venta, PVP
  Edit27.Text:=FormatFloat('0.000',dbArti.FieldByName('A21').AsFloat);//------- Precio sin iva
  Edit28.Text:=dbArti.FieldByName('A3').AsString;//-------- Iva
  Edit58.Text:=dbArti.FieldByName('A36').AsString;//-------- RE
  Edit29.Text:=FormatFloat('0.00',dbArti.FieldByName('A2').AsFloat);//-------- P.V.P.
  Edit36.Text:=dbArti.FieldByName('A27').AsString;//------- Unidades caja
  Edit37.Text:=FormatFloat('0.000',dbArti.FieldByName('A28').AsFloat);//------- Precio tarifa
  Edit38.Text:=FormatFloat('0.000',dbArti.FieldByName('A29').AsFloat);//------- Descuento en importe
  Edit39.Text:=FormatFloat('0.00',dbArti.FieldByName('A30').AsFloat);//------- % Descuento 1
  Edit40.Text:=FormatFloat('0.00',dbArti.FieldByName('A31').AsFloat);//------- % Descuento 2
  Edit41.Text:=dbArti.FieldByName('A32').AsString;//------ Ultimo proveedor
  Edit41Exit(Edit41); //----------------------------------- Consultar Proveedor

  Edit56.Text:=dbArti.FieldByName('A35').AsString;//------------ Activado sistema de puntos para el articulo

  //-------------- Estadisticas --------------------
  RellenaEsta(FormatDateTime('YYYY',Date));//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, TA6-TA7 As BENEF FROM estaarti'+Tienda+' WHERE TA0="'+Edit1.Text+'"'+
                   ' AND TA1='+FormatDateTime('YYYY',Date)+
                   ' ORDER BY TA1 ASC, TA2 ASC';
  dbEsta.Active:=True;
  //-------------- Codigo auxiliares --------------------
  dbEans.Active:=False;
  dbEans.SQL.Text:='SELECT * from eans where EAN1="'+Edit1.Text+'"';
  dbEans.Active:=True;
  //------------------------------------------------
  CargaGrafica:=1; Graficas(); CargaGrafica:=0;//---------------- Pintar Graficas
  BarraStock();//-------------- Pintar Barra de Stock
  PintaTarifa();//------------- Pintar Precios de Tarifas
  ActivarCgoAux();//----------- Activar Codigos Auxiliares
  //-------------- Hist. de compras -----------------
  Edit46.Text:='01/01/'+FormatDateTime('YYYY',Date);
  Edit47.Text:=FormatDateTime('DD/MM/YYYY',Date);
  dbPedido.Active:=False;
  dbPedido.SQL.Text:='SELECT AP0,AP1,AP2,AP3,AP4,P0,P1 FROM ultimopedi'+Tienda+
                     ', proveedores WHERE AP2=P0 AND AP0="'+Edit1.Text+'"'+
                     ' AND AP1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit46.Text))+'"'+
                     ' AND AP1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit47.Text))+'"'+
                     ' ORDER BY AP1 DESC';
  dbPedido.Active:=True;
  //-------------- Ver si esta es la misma version que la del SIC
  CodArtiSic:=dbArti.FieldByName('A34').AsString;
  if (ActivarSIC='S') and (LeerArtiSic=true) then
    begin
      if (dbArti.FieldByName('A33').AsInteger<dbCliSic.FieldByName('version').AsInteger) then
         If Application.MessageBox('EXISTE DATOS ACTUALIZADOS DE ESTE ARTICULO EN EL SISTEMA SIC, LOS ACTUALIZO AQUI?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
            Exit
         else
          begin
            CargaSic();
            If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
               Exit;
            dbArti.Edit; LlenaReg(); dbArti.Post;
            Label7.Caption:=dbArti.Fields[1].AsString;//--- Refrescar nombre.
            dbArti.Edit;
            dbArti.FieldByName('A33').Value:=dbCliSic.FieldByName('version').Value;//------- Control de Version
            dbArti.Post;
          end;
    end;
  //------------------------------------------------
end;
//===================== RELLENAR DATOS =======================
Procedure TFArticulos.LlenaReg();
Begin
  dbArti.FieldByName('A0').AsString:=Edit1.Text;//-------------- Cgo.
  dbArti.FieldByName('A1').AsString:=Edit2.Text;//-------------- Nombre
  dbArti.FieldByName('A21').AsString:=Edit3.Text;//------------- Precio
  dbArti.FieldByName('A3').AsString:=Edit4.Text;//-------------- Iva
  dbArti.FieldByName('A2').AsString:=Edit5.Text;//-------------- P.V.P.

  dbArti.FieldByName('A4').AsString:=Edit6.Text;//-------------- Stock Actual
  dbArti.FieldByName('A5').AsString:=Edit7.Text;//-------------- Stock Minimo
  dbArti.FieldByName('A6').AsString:=Edit8.Text;//-------------- Stock Maximo
  dbArti.FieldByName('A7').AsString:=Edit9.Text;//-------------- Descuento 1
  dbArti.FieldByName('A8').AsString:=Edit10.Text;//------------- Descuento 2
  dbArti.FieldByName('A9').AsString:=Edit11.Text;//------------- Descuento 3
  dbArti.FieldByName('A10').AsString:=Edit12.Text;//------------ Minimo a pedir
  dbArti.FieldByName('A11').AsString:=Edit13.Text;//------------ Pendientes en pedidos
  //------ Fecha Ultima Venta
  if Edit14.Text='' then
    dbArti.FieldByName('A12').Value:=Null
  else
    dbArti.FieldByName('A12').AsString:=Edit14.Text;
  //------------ Fecha Ult. Pedido
  if Edit15.Text='' then
    dbArti.FieldByName('A13').Value:=Null
  else
    dbArti.FieldByName('A13').AsString:=Edit15.Text;

  dbArti.FieldByName('A14').AsString:=Edit20.Text;//------------ Familia

  //dbArti.FieldByName('A15').AsString:=;//------------ Serie

  dbArti.FieldByName('A16').AsString:=Edit16.Text;//------------ Imagen
  dbArti.FieldByName('A17').AsString:=Memo1.Lines.Text;//------- Observaciones

  //dbArti.FieldByName('A18').AsString:=;//------------ Modelo

  dbArti.FieldByName('A19').AsString:=Edit22.Text;//------------ Cgo. Envase
  dbArti.FieldByName('A20').AsString:=Edit17.Text;//------------ Autor / Fabricante
  //dbArti.FieldByName('A22').AsString:='';//------- Marcado N=no, P=No pedir, B=Borrar.
  dbArti.FieldByName('A23').AsString:=Edit19.Text;//------------ Ubicacion
  dbArti.FieldByName('A24').AsString:=Edit24.Text;//------- Costo
  if StrToFloat(Edit25.Text)=0 then Edit25.Text:=Edit24.Text;//--- Si precio medio 0 se pone igual que costo
  dbArti.FieldByName('A25').AsString:=Edit25.Text;//------- Costo Medio
  dbArti.FieldByName('A26').AsString:=Edit26.Text;//------- Margen
  dbArti.FieldByName('A27').AsString:=Edit36.Text;//------- Unidades caja
  dbArti.FieldByName('A28').AsString:=Edit37.Text;//------- Precio tarifa
  dbArti.FieldByName('A29').AsString:=Edit38.Text;//------- Descuento en importe
  dbArti.FieldByName('A30').AsString:=Edit39.Text;//------- % Descuento 1
  dbArti.FieldByName('A31').AsString:=Edit40.Text;//------- % Descuento 2
  dbArti.FieldByName('A32').AsString:=Edit41.Text;//------- Ultimo proveedor
  //dbArti.FieldByName('A33').AsInteger:=dbCliSic.FieldByName('version').AsInteger;//- Control de Version
  //dbArti.FieldByName('A34').AsString:=dbCliSic.FieldByName('CODIGO').AsString;//--- Codigo siclinex

  dbArti.FieldByName('A35').AsString:=Edit56.Text;//------- Activar sistema de puntos para el articulo
  dbArti.FieldByName('A36').AsString:=Edit58.Text;//------- RECARGO DE EQUIVALENCIA
  dbArti.FieldByName('A37').AsString:=Edit59.Text;//------- Margen sobre el PVP
  //------------------------------------------------Publicar en tienda virtual
  If CheckBox1.Checked Then
    dbArti.FieldByName('A38').AsString:='Y'
  else
    dbArti.FieldByName('A38').AsString:='N';
end;


//============================================================
//===================== GRAFICAS =============================
//============================================================
procedure TFArticulos.Graficas();
Var
  Conta: Integer;
begin
  //-------------- Mostrar los distintos años ------------------
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT DISTINCT TA1 FROM estaarti'+Tienda+' WHERE TA0="'+Edit1.Text+'" ORDER BY TA1 DESC';
  dbGrafica.Active:=True;
  ListBox3.Items.Clear; ListBox5.Items.Clear;
  dbGrafica.First;
  while not dbGrafica.EOF do
    begin
      ListBox3.Items.Add(dbGrafica.FieldByName('TA1').AsString);
      ListBox5.Items.Add(dbGrafica.FieldByName('TA1').AsString);
      dbGrafica.Next;
    end;
  ListBox4.ItemIndex:=0;
  //-------------- Mostrar las unidades compradas ------------------
  if ListBox3.Items.Count<>0 then
    begin
     ListBox3.ItemIndex:=0;
     Chart1Serie1.Clear; Chart1AreaSeries1.Clear;
     Chart1BarSeries1.Clear; Chart1PieSeries1.Clear;
     dbGrafica.Active:=False;
     dbGrafica.SQL.Text:='SELECT *, TA6-TA7 As BENEF FROM estaarti'+Tienda+' WHERE TA0="'+Edit1.Text+'"'+
                         ' AND TA1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                         ' ORDER BY TA1 ASC, TA2 ASC';
     dbGrafica.Active:=True; ListBox9.ItemIndex:=0;
     dbGrafica.First; Chart1.Title.Text.Text:='Unidades Compradas';
     for conta:=1 to dbGrafica.RecordCount do
       begin
        Chart1Serie1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        Chart1AreaSeries1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        Chart1BarSeries1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        Chart1PieSeries1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        dbGrafica.Next;
       end;
    end;
end;
//------------------ Cambiar años grafica -------------------
procedure TFArticulos.ListBox3Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//------------------ Cambiar datos grafica -------------------
procedure TFArticulos.ListBox4Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//----------------- Cambiar tipo de grafica ----------------
procedure TFArticulos.ListBox9Click(Sender: TObject);
begin
 Chart1Serie1.Active:=False; Chart1AreaSeries1.Active:=False;
 Chart1BarSeries1.Active:=False; Chart1PieSeries1.Active:=False;
 case ListBox9.ItemIndex of
   0: Chart1Serie1.Active:=True;
   1: Chart1BarSeries1.Active:=True;
   2: Chart1AreaSeries1.Active:=True;
   3: Chart1PieSeries1.Active:=True;
 end;
end;
//--------------- Cambiar Grafica -----------------
procedure TFArticulos.CambiarGrafica();
var
  Conta: Integer;
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox3.Items.Count=0 then exit;//----- Si no hay años
  if ListBox3.ItemIndex=-1 then ListBox3.ItemIndex:=0;
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT *, TA6-TA7 As BENEF FROM estaarti'+Tienda+' WHERE TA0="'+Edit1.Text+'"'+
                      ' AND TA1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                      ' ORDER BY TA1 ASC, TA2 ASC';
  dbGrafica.Active:=True;
  Chart1Serie1.Clear; Chart1AreaSeries1.Clear;
  Chart1BarSeries1.Clear; Chart1PieSeries1.Clear;
  if ListBox4.ItemIndex=-1 then ListBox4.ItemIndex:=0;
  dbGrafica.First; Chart1.Title.Text.Text:=ListBox4.Items.Strings[ListBox4.ItemIndex];
  for conta:=1 to dbGrafica.RecordCount do
    begin
     Chart1Serie1.AddXY(conta,dbGrafica.Fields[ListBox4.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox4.ItemIndex+3].AsFloat), clred);
     Chart1AreaSeries1.AddXY(conta,dbGrafica.Fields[ListBox4.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox4.ItemIndex+3].AsFloat), clred);
     Chart1BarSeries1.AddXY(conta,dbGrafica.Fields[ListBox4.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox4.ItemIndex+3].AsFloat), clred);
     Chart1PieSeries1.AddXY(conta,dbGrafica.Fields[ListBox4.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox4.ItemIndex+3].AsFloat), clred);
     dbGrafica.Next;
    end;
end;
//----------------- Cambiar estadisticas ---------------
procedure TFArticulos.ListBox5Click(Sender: TObject);
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox5.Items.Count=0 then exit;//----- Si no hay años
  if ListBox5.ItemIndex=-1 then ListBox5.ItemIndex:=0;
  RellenaEsta(ListBox5.Items.Strings[ListBox5.ItemIndex]);//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, TA6-TA7 As BENEF FROM estaarti'+Tienda+' WHERE TA0="'+Edit1.Text+'"'+
                   ' AND TA1='+ListBox5.Items.Strings[ListBox5.ItemIndex]+
                   ' ORDER BY TA1 ASC, TA2 ASC';
  dbEsta.Active:=True;
end;


//=================== RELLENAR ESTADISTICAS VACIAS ============
procedure TFArticulos.CreaEstadistica();
var
  Conta: Integer;
  ANO: String;
begin
  ANO:=FormatDateTime('YYYY',Date);
  for conta:=1 to 12 do
    begin
     dbEsta.SQL.Text:='INSERT IGNORE INTO estaarti'+Tienda+' (TA0,TA1,TA2,TA3,TA4,TA5,TA6,TA7) '+
                      'VALUES ("'+Edit1.Text+'",'+ANO+','+IntToStr(Conta)+',0,0,0,0,0)';
     dbEsta.ExecSQL;
    end;
end;

//=================== PINTAR BARRA DE STOCK ===================
procedure TFArticulos.BarraStock();
begin
  ProgressBar1.Position:=0; ProgressBar1.Color:=clDefault;
  LabelMax.Caption:='Max'; LabelMin.Caption:='Min';
  if (dbArti.FieldByName('A5').AsFloat=0) and (dbArti.FieldByName('A6').AsFloat=0) then exit;
  if dbArti.FieldByName('A5').AsFloat < dbArti.FieldByName('A6').AsFloat then
    if dbArti.FieldByName('A4').AsFloat > dbArti.FieldByName('A5').AsFloat then
     begin
      ProgressBar1.Color:=clBlue;
      LabelMin.Caption:=dbArti.FieldByName('A5').AsString;
      LabelMax.Caption:=dbArti.FieldByName('A6').AsString;
      ProgressBar1.Min:=dbArti.FieldByName('A5').AsInteger;
      ProgressBar1.Max:=dbArti.FieldByName('A6').AsInteger;
      ProgressBar1.Position:=dbArti.FieldByName('A4').AsInteger;
     end
    else
     begin
      ProgressBar1.Color:=clRed;
      LabelMin.Caption:=dbArti.FieldByName('A4').AsString;
      LabelMax.Caption:=dbArti.FieldByName('A6').AsString;
      ProgressBar1.Min:=dbArti.FieldByName('A4').AsInteger-dbArti.FieldByName('A6').AsInteger;
      ProgressBar1.Max:=dbArti.FieldByName('A6').AsInteger;
      ProgressBar1.Position:=dbArti.FieldByName('A4').AsInteger;
     end;
end;

//=====================================================
//====================== TARIFAS ======================
//=====================================================
//----- Margen sobre costo Tar. 1 ---------------
procedure TFArticulos.Edit30Exit(Sender: TObject);
Var
  Precio, PrecioCon : Double;
begin
  if (StrToFloat(Edit24.Text)=0) or (Edit24.Text='') then exit;
  if (StrToFloat(Edit30.Text)=0) or (Edit30.Text='') then exit;
  Precio:=(StrToFloat(Edit24.text)*StrToFloat(Edit30.text)/100)+StrToFloat(Edit24.text);
  PrecioCon:=Precio;
  Edit31.Text := FormatFloat('0.000',PrecioCon);
end;
//----- Precio sin iva Tar. 1 ---------------
procedure TFArticulos.Edit31Exit(Sender: TObject);
var
  PvpSinIva, Margen, PrecioCon: double;
begin
  if (Edit31.Text='') or (StrToFloat(Edit31.Text)=0) then exit;
  if (Edit24.Text <> '') and (StrToFloat(Edit24.Text)<> 0) then
    begin
      PvpSinIva := StrToFloat(Edit31.text);
      if StrToFloat(Edit24.Text) <> 0 then begin
         Margen := (PvpSinIva - StrToFloat(Edit24.Text)) * 100 / StrToFloat(Edit24.Text);
         Edit30.Text := FormatFloat('0.000',Margen);
      end;
    end;
  //------ Calcular precio con iva si hay iva Tar 1
  if (StrToFloat(Edit28.Text)=0) or (Edit28.Text='') then exit;
  PrecioCon:=(StrToFloat(Edit31.Text) * StrToFloat(Edit28.Text) / 100) + StrToFloat(Edit31.Text); //--- Sumar el IVA
  Edit43.Text:=FormatFloat('0.00',PrecioCon);
end;
//----- Precio con iva Tar. 1 ---------------
procedure TFArticulos.Edit43Exit(Sender: TObject);
var
   PrecioSin: Double;
begin
   if (Edit43.Text='') or (StrToFloat(Edit43.Text)=0) then exit;
   if (Edit28.Text='') or (StrToFloat(Edit28.Text)=0) then exit;
   PrecioSin := (100 * StrToFloat(Edit43.text)) / (100 + StrToFloat(Edit28.Text));
   Edit31.Text:=FormatFloat('0.000',PrecioSin); Edit31Exit(Edit31);
end;

//----- Margen sobre costo Tar. 2 ---------------
procedure TFArticulos.Edit32Exit(Sender: TObject);
Var
  Precio, PrecioCon : Double;
begin
  if (StrToFloat(Edit24.Text)=0) or (Edit24.Text='') then exit;
  if (StrToFloat(Edit32.Text)=0) or (Edit32.Text='') then exit;
  Precio:=(StrToFloat(Edit24.text)*StrToFloat(Edit32.text)/100)+StrToFloat(Edit24.text);
  PrecioCon:=Precio;
  Edit33.Text := FormatFloat('0.000',PrecioCon);
end;
//----- Precio sin iva Tar. 2 ---------------
procedure TFArticulos.Edit33Exit(Sender: TObject);
var
  PvpSinIva, Margen, PrecioCon: double;
begin
  if (Edit33.Text='') or (StrToFloat(Edit33.Text)=0) then exit;
  if (Edit24.Text <> '') and (StrToFloat(Edit24.Text)<>0) then
    begin
      PvpSinIva := StrToFloat(Edit33.text);
      Margen := (PvpSinIva - StrToFloat(Edit24.Text)) * 100 / StrToFloat(Edit24.Text);
      Edit32.Text := FormatFloat('0.000',Margen);
    end;
  //------ Calcular precio con iva si hay iva Tar 1
  if (StrToFloat(Edit28.Text)=0) or (Edit28.Text='') then exit;
  PrecioCon:=(StrToFloat(Edit33.Text) * StrToFloat(Edit28.Text) / 100) + StrToFloat(Edit33.Text); //--- Sumar el IVA
  Edit44.Text:=FormatFloat('0.00',PrecioCon);
end;
//----- Precio con iva Tar. 2 ---------------
procedure TFArticulos.Edit44Exit(Sender: TObject);
var
   PrecioSin: Double;
begin
   if (Edit44.Text='') or (StrToFloat(Edit44.Text)=0) then exit;
   if (Edit28.Text='') or (StrToFloat(Edit28.Text)=0) then exit;
   PrecioSin := (100 * StrToFloat(Edit44.text)) / (100 + StrToFloat(Edit28.Text));
   Edit33.Text:=FormatFloat('0.000',PrecioSin); Edit33Exit(Edit33);
end;

//----- Margen sobre costo Tar. 3 ---------------
procedure TFArticulos.Edit34Exit(Sender: TObject);
Var
  Precio, PrecioCon : Double;
begin
  if (StrToFloat(Edit24.Text)=0) or (Edit24.Text='') then exit;
  if (StrToFloat(Edit34.Text)=0) or (Edit34.Text='') then exit;
  Precio:=(StrToFloat(Edit24.text)*StrToFloat(Edit34.text)/100)+StrToFloat(Edit24.text);
  PrecioCon:=Precio;
  Edit35.Text := FormatFloat('0.000',PrecioCon);
end;
//----- Precio sin iva Tar. 3 ---------------
procedure TFArticulos.Edit35Exit(Sender: TObject);
var
  PvpSinIva, Margen, PrecioCon: double;
begin
  if (Edit35.Text='') or (StrToFloat(Edit35.Text)=0) then exit;
  if (Edit24.Text <> '') and (StrToFloat(Edit24.Text)<>0) then
    begin
      PvpSinIva := StrToFloat(Edit35.text);
      Margen := (PvpSinIva - StrToFloat(Edit24.Text)) * 100 / StrToFloat(Edit24.Text);
      Edit34.Text := FormatFloat('0.000',Margen);
    end;
  //------ Calcular precio con iva si hay iva Tar 1
  if (StrToFloat(Edit28.Text)=0) or (Edit28.Text='') then exit;
  PrecioCon:=(StrToFloat(Edit35.Text) * StrToFloat(Edit28.Text) / 100) + StrToFloat(Edit35.Text); //--- Sumar el IVA
  Edit45.Text:=FormatFloat('0.00',PrecioCon);
end;

//----- Precio con iva Tar. 3 ---------------
procedure TFArticulos.Edit45Exit(Sender: TObject);
var
   PrecioSin: Double;
begin
   if (Edit45.Text='') or (StrToFloat(Edit45.Text)=0) then exit;
   if (Edit28.Text='') or (StrToFloat(Edit28.Text)=0) then exit;
   PrecioSin := (100 * StrToFloat(Edit45.text)) / (100 + StrToFloat(Edit28.Text));
   Edit35.Text:=FormatFloat('0.000',PrecioSin); Edit35Exit(Edit35);
end;

//===================== PINTAR TARIFAS =====================
procedure TFArticulos.PintaTarifa();
begin
 StaticText1.Caption:=Edit28.Text+'% ';
 StaticText2.Caption:=Edit28.Text+'% ';
 StaticText3.Caption:=Edit28.Text+'% ';
 dbTarifa.Active:=False;
 dbTarifa.Sql.Text:='SELECT * FROM tarifas WHERE TAR0="'+Edit1.Text+'"';
 dbTarifa.Active:=True;
 if dbTarifa.RecordCount<>0 then
   begin
    Edit30.Text:=FormatFloat('0.000',dbTarifa.FieldByName('TAR1').AsFloat);//---- %Margen 1
    Edit31.Text:=FormatFloat('0.000',dbTarifa.FieldByName('TAR2').AsFloat);//----- Precio Tarifa 1
    Edit32.Text:=FormatFloat('0.000',dbTarifa.FieldByName('TAR3').AsFloat);//---- %Margen 2
    Edit33.Text:=FormatFloat('0.000',dbTarifa.FieldByName('TAR4').AsFloat);//----- Precio Tarifa 2
    Edit34.Text:=FormatFloat('0.000',dbTarifa.FieldByName('TAR5').AsFloat);//---- %Margen 3
    Edit35.Text:=FormatFloat('0.000',dbTarifa.FieldByName('TAR6').AsFloat);//----- Precio Tarifa 3
    Edit43.Text:=FormatFloat('0.00',dbTarifa.FieldByName('TAR7').AsFloat);//------ P.V.P. Tarifa 1
    Edit44.Text:=FormatFloat('0.00',dbTarifa.FieldByName('TAR8').AsFloat);//------ P.V.P. Tarifa 2
    Edit45.Text:=FormatFloat('0.00',dbTarifa.FieldByName('TAR9').AsFloat);//------ P.V.P. Tarifa 3
   end
 else
   begin
    Edit30.Text:='0'; Edit31.Text:='0'; Edit32.Text:='0'; Edit33.Text:='0';
    Edit34.Text:='0'; Edit35.Text:='0'; Edit43.Text:='0'; Edit44.Text:='0';
    Edit45.Text:='0';
   end;
end;

//====================== GUARDAR TARIFAS =======================
Procedure TFArticulos.GuardaTarifa();
begin
  dbTarifa.Active:=False;
  dbTarifa.Sql.Text:='SELECT * FROM tarifas WHERE TAR0="'+Edit1.Text+'"';
  dbTarifa.Active:=True;
  if dbTarifa.RecordCount=0 then
    begin
      dbTarifa.Append;
      dbTarifa.FieldByName('TAR0').AsString:=Edit1.Text;//---------------- Código.
      dbTarifa.FieldByName('TAR1').AsFloat:=StrToFloat(Edit30.Text);//---- %Margen 1.
      dbTarifa.FieldByName('TAR2').AsFloat:=StrToFloat(Edit31.Text);//---- Precio Tarifa 1.
      dbTarifa.FieldByName('TAR3').AsFloat:=StrToFloat(Edit32.Text);//---- %Margen 2.
      dbTarifa.FieldByName('TAR4').AsFloat:=StrToFloat(Edit33.Text);//---- Precio Tarifa 2.
      dbTarifa.FieldByName('TAR5').AsFloat:=StrToFloat(Edit34.Text);//---- %Margen 3.
      dbTarifa.FieldByName('TAR6').AsFloat:=StrToFloat(Edit35.Text);//---- Precio Tarifa 3.
      dbTarifa.FieldByName('TAR7').AsFloat:=StrToFloat(Edit43.Text);//---- PVP Tarifa 1.
      dbTarifa.FieldByName('TAR8').AsFloat:=StrToFloat(Edit44.Text);//---- PVP Tarifa 2.
      dbTarifa.FieldByName('TAR9').AsFloat:=StrToFloat(Edit45.Text);//---- PVP Tarifa 3.
      dbTarifa.Post;
    end
  else
    begin
      dbTarifa.Edit;
      dbTarifa.FieldByName('TAR1').AsFloat:=StrToFloat(Edit30.Text);//---- %Margen 1.
      dbTarifa.FieldByName('TAR2').AsFloat:=StrToFloat(Edit31.Text);//---- Precio Tarifa 1.
      dbTarifa.FieldByName('TAR3').AsFloat:=StrToFloat(Edit32.Text);//---- %Margen 2.
      dbTarifa.FieldByName('TAR4').AsFloat:=StrToFloat(Edit33.Text);//---- Precio Tarifa 2.
      dbTarifa.FieldByName('TAR5').AsFloat:=StrToFloat(Edit34.Text);//---- %Margen 3.
      dbTarifa.FieldByName('TAR6').AsFloat:=StrToFloat(Edit35.Text);//---- Precio Tarifa 3.
      dbTarifa.FieldByName('TAR7').AsFloat:=StrToFloat(Edit43.Text);//---- PVP Tarifa 1.
      dbTarifa.FieldByName('TAR8').AsFloat:=StrToFloat(Edit44.Text);//---- PVP Tarifa 2.
      dbTarifa.FieldByName('TAR9').AsFloat:=StrToFloat(Edit45.Text);//---- PVP Tarifa 3.
      dbTarifa.Post;
    end;
end;
//==========================================================
//============= RELLENAR MESES QUE ESTEN A 0 ===============
//==========================================================
procedure TFArticulos.RellenaEsta(Ano: String);
var
  Conta: Integer;
  UC,IC,UV,IVP,IVC,Beneficio : Double;
begin
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT * FROM estaarti'+Tienda+' WHERE TA0="'+Edit1.Text+'"'+
                   ' AND TA1='+Ano+' ORDER BY TA1 ASC, TA2 ASC';
  dbEsta.Active:=True;
  dbEsta.First;

//*********** IMPLEMENTACIÓN DE MUESTREO DE TOTALES
  UC:=0; IC:=0; UV:=0; IVP:=0; IVC:=0; Beneficio:=0;
  While not dbEsta.EOF do
    begin
      UC := UC + dbEsta.FieldByName('TA3').Value;
      IC := IC + dbEsta.FieldByName('TA4').Value;
      UV := UV + dbEsta.FieldByName('TA5').Value;
      IVP := IVP + dbEsta.FieldByName('TA6').Value;
      IVC := IVC + dbEsta.FieldByName('TA7').Value;
      Beneficio := Beneficio + ( dbEsta.FieldByName('TA6').Value - dbEsta.FieldByName('TA7').Value );
      dbEsta.Next;
    end;

  lbUC.Caption := FormatFloat('#0.00',UC);
  lbIC.Caption := FormatFloat('#0.00',IC);
  lbUV.Caption := FormatFloat('#0.00',UV);
  lbIVP.Caption := FormatFloat('#0.00',IVP);
  lbIVC.Caption := FormatFloat('#0.00',IVC);
  lbBeneficio.Caption := FormatFloat('#0.00',Beneficio);

  dbEsta.First;
//*********** FIN IMPLEMENTACIÓN DE MUESTREO DE TOTALES

  for Conta:=1 to 12 do
    begin
      if not dbEsta.Locate('TA2',Conta,[]) then
        begin
           dbEsta.Append;
           dbEsta.FieldByName('TA0').AsString:=Edit1.Text;
           dbEsta.FieldByName('TA1').AsString:=Ano;
           dbEsta.FieldByName('TA2').AsString:=IntToStr(Conta);
           dbEsta.Post;
        end;
    end;
end;

//============================================================
//===================== HIST. COMPRAS ========================
//============================================================
//------------- Buscar codigo ------------
procedure TFArticulos.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked=True then
    Edit48.Enabled:=True else Edit48.Enabled:=False;
end;
//------------- Buscar unidades ----------
procedure TFArticulos.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked=True then
    Edit49.Enabled:=True else Edit49.Enabled:=False;
end;
//------------- Buscar importe ----------
procedure TFArticulos.CheckBox5Click(Sender: TObject);
begin
  if CheckBox5.Checked=True then
    Edit50.Enabled:=True else Edit50.Enabled:=False;
end;


//------------ APLICAR FILTRO -----------
procedure TFArticulos.BitBtn14Click(Sender: TObject);
var
  Codigo,Unidades,Importe: String;
begin
  if Edit46.Text='' then Edit46.Text:='01/'+FormatDateTime('MM/YYYY',Date);
  if Edit47.Text='' then Edit47.Text:=FormatDateTime('DD/MM/YYYY',Date);
  if StrToDate(Edit46.Text) > StrToDate(Edit47.Text) then
    begin ShowMessage('LA PRIMERA FECHA NO PUEDE SER MAYOR QUE LA ULTIMA'); exit; end;
  //------- Ver si buscar por codigo
  if (CheckBox3.Checked=True) and (Edit48.Text<>'') then
    Codigo:=' AND AP2='+Edit48.Text else Codigo:='';
  //------- Ver si buscar por unidades
  if (CheckBox4.Checked=True) and (Edit49.Text<>'') then
    Unidades:=' AND AP3='+Edit49.Text else Unidades:='';
  //------- Ver si buscar por importe
  if (CheckBox5.Checked=True) and (Edit50.Text<>'') then
    Importe:=' AND AP4='+Edit50.Text else Importe:='';
  //-------------------------------------
  dbPedido.Active:=False;
  dbPedido.SQL.Text:='SELECT AP0,AP1,AP2,AP3,AP4,P0,P1 FROM ultimopedi'+Tienda+
                     ', proveedores WHERE AP2=P0 AND AP0="'+Edit1.Text+'"'+
                     ' AND AP1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit46.Text))+'"'+
                     ' AND AP1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit47.Text))+'"'+
                     Codigo + Unidades + Importe +
                     ' ORDER BY AP1 DESC';
  dbPedido.Active:=True;
end;

//========================================================
//================== CODIGOS AUXILIARES ==================
//========================================================
//---------------- Activar Cgo. Auxiliares ---------------
procedure TFArticulos.ActivarCgoAux();
begin
  Edit51.Enabled:=True; Edit52.Enabled:=True; Edit53.Enabled:=True;
  Edit54.Enabled:=True; Edit55.Enabled:=True; DBGrid3.Enabled:=True;
  BitBtn7.Enabled:=True; BitBtn8.Enabled:=True; BitBtn9.Enabled:=True;
end;
//---------------- Desactivar Cgo. Auxiliares ---------------
procedure TFArticulos.DesactivarCgoAux();
begin
  Edit51.Enabled:=False; Edit52.Enabled:=False; Edit53.Enabled:=False;
  Edit54.Enabled:=False; Edit55.Enabled:=False; DBGrid3.Enabled:=False;
  BitBtn7.Enabled:=False; BitBtn8.Enabled:=False; BitBtn9.Enabled:=False;
end;

//------------- Crear nuevo codigo auxiliar -------------
procedure TFArticulos.BitBtn7Click(Sender: TObject);
begin
  if Edit51.Text='' then begin showmessage('DEBE TECLEAR EL CODIGO AUXILIAR A CREAR'); exit; end;
  if Edit52.Text='' then begin showmessage('DEBE TECLEAR LA DESCRIPCION DEL AUXILIAR A CREAR'); exit; end;
  if Edit53.Text='' then begin showmessage('DEBE TECLEAR AL MENOS UNA UNIDAD EL CODIGO AUXILIAR A CREAR'); exit; end;
  dbTrabajo.Active:=False;          // Comprobamos si ya existe otro código auxiliar igual
  dbTrabajo.SQL.Text:='SELECT * FROM eans WHERE EAN0="'+Edit51.Text+'"';
  dbTrabajo.Active:=True;
  if dbTrabajo.Locate('EAN0', Edit51.Text, []) then
    begin
      Showmessage('ESE CODIGO AUXILIAR YA ESTA ASOCIADO AL ARTICULO '+ #13+#13+
                 '( '+dbTrabajo.FieldByName('EAN1').AsString+' )  '+dbTrabajo.FieldByName('EAN2').AsString);
      dbTrabajo.Active:=False;
      Edit51.SetFocus;
      exit;
    end;
//  ShowMessage('LOCATE 1 FINALIZADO');
  dbTrabajo.Active:=False;          // Comprobamos si ya existe un código principal igual
  dbTrabajo.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit51.Text+'" ORDER BY A0';
  dbTrabajo.Active:=True;
  if dbTrabajo.Locate('A0', Edit51.Text, []) then
    begin
      Showmessage('EXISTE UN ARTICULO CON ESE CODIGO COMO PRINCIPAL '+ #13+#13 + dbTrabajo.FieldByName('A1').AsString);
      dbTrabajo.Active:=False;
      Edit51.SetFocus;
      exit;
    end;
//  ShowMessage('LOCATE 2 FINALIZADO');

   dbTrabajo.Active:=False;
   dbEans.Append; LlenaEans(); dbEans.Post;//---- Grabar cgos. auxiliares
   LimpiaAuxiliares();
   Edit51.SetFocus;
end;

//---------------- Borrar codigo auxiliar ----------------
procedure TFArticulos.BitBtn8Click(Sender: TObject);
begin
  if Edit51.Text='' then begin showmessage('DEBE INDICAR EL CODIGO AUXILIAR A BORRAR'); exit; end;
  if not dbEans.Locate('EAN0', Edit51.Text, []) then
    begin
      Showmessage('ESE CODIGO AUXILIAR NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL CODIGO AUXILIAR?','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbEans.Delete; //---- Borrar codigo auxiliar
  LimpiaAuxiliares();
  Edit51.SetFocus;
end;

//---------------- Modificar codigo auxiliar ----------------
procedure TFArticulos.BitBtn9Click(Sender: TObject);
begin
  if dbArti.RecordCount=0 then exit;//---- Si no hay articulo consultado
  if Edit51.Text='' then begin showmessage('DEBE TECLEAR EL CODIGO AUXILIAR A CREAR'); exit; end;
  if Edit52.Text='' then begin showmessage('DEBE TECLEAR LA DESCRIPCION DEL AUXILIAR A CREAR'); exit; end;
  if Edit53.Text='' then begin showmessage('DEBE TECLEAR AL MENOS UNA UNIDAD EL CODIGO AUXILIAR A CREAR'); exit; end;
  if not dbEans.Locate('EAN0', Edit51.Text, []) then
    begin
      Showmessage('ESE CODIGO AUXILIAR NO EXISTE, NO PUEDE MODIFICARLO!');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
   dbEans.Edit; LlenaEans(); dbEans.Post;//---- Grabar cgos. auxiliares
   LimpiaAuxiliares();
   Edit51.SetFocus;
end;

//------------------ Salir del codigo auxiliar ------------
procedure TFArticulos.Edit51Enter(Sender: TObject);
begin
  LimpiaAuxiliares();
end;
procedure TFArticulos.Edit51Exit(Sender: TObject);
begin
  if Edit51.Text='' then exit;
  if dbEans.Locate('EAN0', Edit51.Text, []) then
    PintaEans() else Edit52.Text:=Edit2.Text;

end;

procedure TFArticulos.Edit56Change(Sender: TObject);
begin
  Edit56.Text:=UpperCase(Edit56.Text);
end;

//------------ Seleccionar codigos aux. con dloble click ---------
procedure TFArticulos.DBGrid3DblClick(Sender: TObject);
begin
  if Edit1.Text='' then exit;//---- Si no hay articulo consultado
  if (dbEans.RecordCount=0) or (dbEans.eof) then exit;//---- Si no codigos auxiliares
  PintaEans();
end;

//----------------- Grabar los cgos. auxiliares -----------
procedure TFArticulos.LlenaEans();
begin
   dbEans.FieldByName('EAN0').Value:=Edit51.Text;//------- Cgo. auxiliar.
   dbEans.FieldByName('EAN1').Value:=Edit1.Text;//-------- Cgo. articulo principal.
   dbEans.FieldByName('EAN2').Value:=Edit52.Text;//------- Descripcion
   dbEans.FieldByName('EAN3').AsString:=Edit53.Text;//---- Unidades.
   if Edit54.Text='' then Edit54.Text:='0';
   dbEans.FieldByName('EAN4').AsString:=Edit54.Text;//---- Importe.
   if Edit55.Text='' then Edit53.Text;
   dbEans.FieldByName('EAN5').AsString:=Edit55.Text;//---- Unidades a descontar del cgo. principal.
end;

//----------------- Pintar los cgos. auxiliares -----------
procedure TFArticulos.PintaEans();
begin
   Edit51.Text:=dbEans.FieldByName('EAN0').AsString;//------- Cgo. auxiliar.
   Edit52.Text:=dbEans.FieldByName('EAN2').AsString;//------- Descripcion
   Edit53.Text:=dbEans.FieldByName('EAN3').AsString;//---- Unidades.
   Edit54.Text:=dbEans.FieldByName('EAN4').AsString;//---- Importe.
   Edit55.Text:=dbEans.FieldByName('EAN5').AsString;//---- Unidades a descontar del cgo. principal.
end;

//===================== LIMPIAR DATOS =======================
Procedure TFArticulos.LimpiaAuxiliares();
Begin
//--  Edit51.Text:='';
  Edit52.Text:=''; Edit53.Text:='1';
  Edit54.Text:='0'; Edit55.Text:='1';
End;

//============================================================================
//======================== SISTEMA DE INFORMACION COMUN ======================
//============================================================================
//---------------- Mostrar panel articulos SIC --------
procedure TFArticulos.BitBtn15Click(Sender: TObject);
begin
  Panel8.Visible:=True;
end;

//---------------- Cerrar panel articulos SIC --------
procedure TFArticulos.BitBtn18Click(Sender: TObject);
begin
  Panel8.Visible:=False;
end;

//---------------- COMPROBAR ARTICULO EN SIC ----------
procedure TFArticulos.GrabarModificarSic();
begin
   CodArtiSic:=dbArti.FieldByName('A34').AsString;
   if LeerArtiSic=False then
     begin
        If Application.MessageBox('ESTE ARTICULO NO EXISTE EN EL S.I.C. (SISTEMA DE INFORMACION COMUN),    LO CREAMOS?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Append;
        RellenaSIC();
        dbCliSic.FieldByName('version').Value:=1;
        dbCliSic.Post;
        dbArti.Edit;
        dbArti.FieldByName('A33').AsString:='1';//--------- Control de Version
        dbArti.FieldByName('A34').AsString:=Edit1.Text;//-- Codigo siclinex
        dbArti.Post;
     end
   else
     begin
        If Application.MessageBox('QUIERE ACTUALIZAR LOS CAMBIOS EN EL S.I.C.  (SISTEMA DE INFORMACION COMUN)?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Edit;
        dbCliSic.FieldByName('version').Value:=dbCliSic.FieldByName('version').AsInteger+1;
        RellenaSIC();
        dbCliSic.Post;
        dbArti.Edit;
        dbArti.FieldByName('A33').Value:=dbCliSic.FieldByName('version').Value;//------- Control de Version
        dbArti.Post;
     end;
end;

//--------------- Borrar articulos en SIC --------------
procedure TFArticulos.BorrarSic();
begin
   if LeerArtiSic=False then exit;
     begin
        If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO EN EL S.I.C.  (SISTEMA DE INFORMACION COMUN)?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Delete;
     end;
end;

//----------- Localizar articulos en el SIC por codigo interno ---------------
function TFArticulos.LeerArtiSic: Boolean;
begin
  LeerArtiSic:=False;
  //------ Buscar por codigo interno
  if dbArti.FieldByName('A34').AsString<>'' then
    begin
     dbCliSic.Active:=False;
     dbCliSic.SQL.Text:='SELECT * FROM articulos WHERE CODIGO="'+CodArtiSic+'"';
     dbCliSic.Active:=True;
     if dbCliSIc.RecordCount<>0 then begin LeerArtiSic:=True; exit; end;
    end
  else
    begin
     //----- De todas maneras abro el dataset para grabar el cliente si no existe
     dbCliSic.Active:=False;
     dbCliSic.SQL.Text:='SELECT * FROM articulos WHERE CODIGO="'+CodArtiSic+'"';
     dbCliSic.Active:=True;
    end;
end;

//------------- Buscar articulos del SIC para importar ------------
procedure TFArticulos.BitBtn17Click(Sender: TObject);
var
  TxtQ: String;
begin
  BitBtn16.Enabled:=False; ListBox6.Items.Clear;
  if Edit57.Text='' then exit;
  TxtQ:='SELECT * FROM articulos WHERE ';
  if Edit57.Text<>'' then TxtQ:=TxtQ+'NOMBRE LIKE "'+Edit57.Text+'%"';
  dbCliSic.Active:=False;
  dbCliSic.SQL.Text:=TxtQ;
  dbCliSic.Active:=True;
  if dbCliSIc.RecordCount=0 then begin showmessage('NO EXISTEN DATOS CON ESE FILTRO.'); exit; end;
  dbCliSic.First;
  while not dbCliSic.EOF do
    begin
      ListBox6.Items.Add(dbCliSic.FieldByName('NOMBRE').AsString);
      dbCliSic.Next;
    end;
  ListBox6.ItemIndex:=0;
  BitBtn16.Enabled:=True;
end;

//-------------- Importar articulos desde el SIC ----------------
procedure TFArticulos.BitBtn16Click(Sender: TObject);
begin
  if ListBox6.Items.Count=0 then exit;//----- Si no hay articulos en la lista
  if ListBox6.ItemIndex=-1 then ListBox6.ItemIndex:=0; //--- Si no hay selecionado ninguno
  dbCliSic.Locate('NOMBRE',ListBox6.Items.Strings[ListBox6.ItemIndex],[]);
  //----- Buscar si existe en nuestro fichero
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A34="'+dbCliSic.FieldByName('CODIGO').AsString+'"';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    begin
       ShowMessage('ESTE ARTICULO DEL SIC YA EXISTE EN NUESTRO FICHERO CON EL CGO.:'+dbTrabajo.FieldByName('A0').AsString);
       Exit;
    end;
  dbTrabajo.Active:=False;
  //------ Cargar datos en pantalla
  LimpiaForm(); LimpiaAuxiliares();
  Edit1.Text:=dbCliSic.FieldByName('CODIGO').AsString; CargaSIC();
  //------ Crear articulo en nuestro file
  if Application.MessageBox('CREAMOS EL REGISTRO EN NUESTRO FICHERO?','FacturLinEx', boxstyle) = IDYES Then
    begin
     dbArti.Append;
     LlenaReg();
     dbArti.FieldByName('A33').AsInteger:=dbCliSic.FieldByName('version').AsInteger;//- Control de Version
     dbArti.FieldByName('A34').AsString:=dbCliSic.FieldByName('CODIGO').AsString;//--- Codigo siclinex
     dbArti.Post;
     Label7.Caption:=dbArti.FieldByName('A1').AsString;//--- Refrescar nombre.
    end
  else LimpiaForm();
  //---------------------
  ListBox6.Items.Clear;
  BitBtn16.Enabled:=False; Panel8.Visible:=False;
  Edit2.SetFocus;
end;

//================== RELLENAR CAMPOS DEL SIC ===================
procedure TFArticulos.RellenaSIC();
begin
  dbCliSic.FieldByName('NOMBRE').AsString:=Edit2.Text;
  dbCliSic.FieldByName('DESCRIPCION').AsString:=Memo1.Lines.Text;
end;

//================== RELLENAR CAMPOS DEL SIC ===================
procedure TFArticulos.CargaSIC();
begin
  Edit2.Text:=dbCliSic.FieldByName('NOMBRE').AsString;
  Memo1.Lines.Text:=dbCliSic.FieldByName('DESCRIPCION').AsString;
end;


initialization
  {$I articulos.lrs}
end.

