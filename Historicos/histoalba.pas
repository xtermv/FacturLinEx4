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

unit HistoAlba;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ZConnection, ZDataset, DBGrids, db, StdCtrls, DbCtrls, LR_Class,
  LR_DBSet, LCLType, Menus, LR_E_CSV, LR_E_HTM;

type

{ TFHistAlbaran }

TFHistAlbaran = class(TForm)
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
  BitBtn25: TBitBtn;
  BitBtn3: TBitBtn;
  BitBtn4: TBitBtn;
  BitBtn5: TBitBtn;
  BitBtn6: TBitBtn;
  BitBtn24: TBitBtn;
  BitBtn8: TBitBtn;
  BitBtn9: TBitBtn;
  CheckBox1: TCheckBox;
  CheckBox2: TCheckBox;
  CheckBox4: TCheckBox;
  Datasource1: TDatasource;
  Datasource2: TDatasource;
  Datasource3: TDatasource;
  dbAlbac: TZQuery;
  dbAlbad: TZQuery;
  dbTarifas: TZQuery;
  dbTiendas: TZQuery;
  dbBusca: TZQuery;
  dbTrabajo: TZQuery;
  dbSeries: TZQuery;
  dbLista: TZQuery;
  dbhisalbac: TZQuery;
  dbhisalbad: TZQuery;
  dbClientes: TZQuery;
  dbArti: TZQuery;
  DBGrid1: TDBGrid;
  DBGrid2: TDBGrid;
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
  Edit3: TEdit;
  Edit4: TEdit;
  Edit5: TEdit;
  Edit6: TEdit;
  Edit7: TEdit;
  Edit8: TEdit;
  Edit9: TEdit;
  frCSVExport1: TfrCSVExport;
  frHTMExport1: TfrHTMExport;
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
  LabelTotal: TLabel;
  Label2: TLabel;
  Label3: TLabel;
  Label4: TLabel;
  Label5: TLabel;
  Label6: TLabel;
  Label7: TLabel;
  Label8: TLabel;
  Label9: TLabel;
  ListBox1: TListBox;
  ListBox2: TListBox;
  ListBox3: TListBox;
  Memo1: TMemo;
  MenuItem1: TMenuItem;
  MenuItem2: TMenuItem;
  Panel1: TPanel;
  dbMuestrac: TZQuery;
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
  RadioGroup1: TRadioGroup;
  RadioGroup2: TRadioGroup;
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
  procedure BitBtn25Click(Sender: TObject);
  procedure BitBtn26Click(Sender: TObject);
  procedure BitBtn2Click(Sender: TObject);
  procedure BitBtn3Click(Sender: TObject);
  procedure BitBtn4Click(Sender: TObject);
  procedure BitBtn5Click(Sender: TObject);
  procedure BitBtn6Click(Sender: TObject);
  procedure BitBtn7Click(Sender: TObject);
  procedure BitBtn8Click(Sender: TObject);
  procedure BitBtn9Click(Sender: TObject);
  procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
  procedure DBGrid1TitleClick(Column: TColumn);
  procedure DBGrid2DblClick(Sender: TObject);
  procedure DBGrid2KeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
  procedure Edit10Exit(Sender: TObject);
  procedure Edit12Exit(Sender: TObject);
  procedure Edit14Enter(Sender: TObject);
  procedure Edit14Exit(Sender: TObject);
  procedure Edit16Enter(Sender: TObject);
  procedure Edit16Exit(Sender: TObject);
  procedure Edit1Enter(Sender: TObject);
  procedure Edit1Exit(Sender: TObject);
  procedure Edit2Exit(Sender: TObject);
  procedure Edit2KeyPress(Sender: TObject; var Key: char);
  procedure Edit5Exit(Sender: TObject);
  procedure Edit6DblClick(Sender: TObject);
  procedure Edit6KeyPress(Sender: TObject; var Key: char);
  procedure Edit7Exit(Sender: TObject);
  procedure Edit7KeyPress(Sender: TObject; var Key: char);
  procedure Edit8Exit(Sender: TObject);
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
  procedure ListBox3KeyPress(Sender: TObject; var Key: char);
  procedure MenuItem1Click(Sender: TObject);
  procedure MenuItem2Click(Sender: TObject);
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
  procedure NumeroAlbaran();
  procedure RadioGroup2Click(Sender: TObject);
  procedure BuscaArticulo();
  procedure ActualizaImporte();
  procedure CargaTarifas(actualiza: integer);
  procedure MuestraTarifas();
  function VerUltimaLinea: Integer;

  private
    { private declarations }
  public
    { public declarations }
  end;

  procedure ShowFormHistoAlbaranes;
  
var
  FHistAlbaran: TFHistAlbaran;
  SALBARAN: String;
  NALBARAN: Integer;
  BASE1,BASE2,BASE3,IMPOIVA1,IMPOIVA2,IMPOIVA3,TOTAL1,TOTAL2,TOTAL3: Double;
  IRIVA1,IRIVA2,IRIVA3,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PRIVA1,PRIVA2,PRIVA3:Double;
  lMarcado: integer;  // 0 = todos, 1 = no marcado, 2=marcado

  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

implementation

uses
  Global, Funciones, busquedas, Imprimir;
  
 { TFHistAlbaran }

//=============== Crea el formulario ================
procedure ShowFormHistoAlbaranes;
begin
  with TFHistAlbaran.Create(Application) do
    begin
       ShowModal;
    end;
end;
//======================= CREAR FORMULARIO ==========================
procedure TFHistAlbaran.FormCreate(Sender: TObject);
begin
  //--------- Conectar con la bbdd e inicializar datos globales
  //Conectate(dbConect);      // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  //-- MID(HAC11,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(HAC11 USING UTF8) as ANOTAS,C1 FROM hisalbac'+Tienda+', clientes WHERE HAC0=C0 ORDER BY HAC2 ASC, HAC1 DESC, HAC3 DESC';
  dbMuestrac.Active := True;
  lMarcado:=0;
  Panel4.SendToBack; Panel4.Visible:=False;
  DBGrid2.SendToBack; DBGrid2.Visible:=False;
  //------------- Chequear ivas
  if IVA1=0 then showmessage('DEBE DEFINIR LOS TIPOS DE IVA EN LA CONFIGURACION');

  AntColun:='0';Ordenado:=False; Orden:='DESC';

end;


//============== TODAS LOS ALBARANES =====================
procedure TFHistAlbaran.RadioButton1Click(Sender: TObject);
begin
  Panel2.Visible:=False;
  Panel3.Visible:=False;
  //-- MID(HAC11,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(HAC11 USING UTF8) as ANOTAS,C1 FROM hisalbac'+Tienda+', clientes WHERE HAC0=C0 ORDER BY HAC2 ASC, HAC1 DESC, HAC3 DESC';
  dbMuestrac.Active := True;
end;


//============== ALBARANES DE UN CLIENTE ========================
procedure TFHistAlbaran.RadioButton2Click(Sender: TObject);
begin
  Panel2.Visible:=True; Panel3.Visible:=False; Edit1.SetFocus;
end;
procedure TFHistAlbaran.BitBtn3Click(Sender: TObject);
begin
  If Edit1.Text='' then Exit;
  //-- MID(HAC11,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(HAC11 USING UTF8) as ANOTAS,C1 FROM hisalbac'+Tienda+', clientes WHERE HAC0=C0 AND HAC0='+Edit1.Text+' ORDER BY HAC2 ASC, HAC1 DESC, HAC3 DESC';
  dbMuestrac.Active := True;
  If dbMuestrac.RecordCount=0 then
    begin
      Showmessage('NO HAY ALBARANES DE ESTE CLIENTE');
      exit;
    end;

end;

//=================== CGO CLIENTE FLITRADO =======================
procedure TFHistAlbaran.Edit1Enter(Sender: TObject);
begin
   Edit2.Text:='';
end;
procedure TFHistAlbaran.Edit1Exit(Sender: TObject);
begin
   if Edit1.Text='' then Exit;
   if not (EsFloat(Edit1.Text)) then begin Edit1.Text:='0'; Edit1.SetFocus; exit; end;
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit1.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then
                               Begin    // Showmessage('ESE CLIENTE NO EXISTE.');
                                 BitBtn25Click(self);
                                 Edit2.SetFocus; Exit;
                               End;
   Edit2.Text:=dbClientes.FieldByName('C1').AsString;
//   Edit1.SetFocus;
end;
//--------------- Busca Cliente -----------------------
procedure TFHistAlbaran.BitBtn25Click(Sender: TObject);
begin
   Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT C0,C1,C5 FROM clientes',['Código','Cliente','N.I.F.'],'C0');
   Edit2.SetFocus;
   Edit1Exit(self);
end;

//---------------- busca documentos por las notas ----------
procedure TFHistAlbaran.BitBtn26Click(Sender: TObject);
var
  inutil: string;
begin
  inutil:=FBusquedas.IniciaBusquedas('SELECT HAC2,HAC3,HAC1,HAC9,HAC0,C1,HAC11 FROM hisalbac'+Tienda+', clientes WHERE HAC0=C0',
                                                         ['Serie','Número','Fecha','Total','Cliente','Razón Social','Observaciones'],'AC2');
end;

//--------------- Buscar por nombre -----------------
procedure TFHistAlbaran.Edit2Exit(Sender: TObject);
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
procedure TFHistAlbaran.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then Edit2Exit(self);
  Exit;
end;


//============== ALBARANES ENTRE FECHAS ========================
procedure TFHistAlbaran.RadioButton3Click(Sender: TObject);
begin
  Panel3.Visible:=True;
  Panel2.Visible:=False;
  Edit3.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit4.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit3.SetFocus;
end;
procedure TFHistAlbaran.BitBtn4Click(Sender: TObject);
begin
  If (Edit3.Text='') or (Edit4.Text='') then Exit;
  dbMuestrac.Sql.Text:='SELECT *,C1 FROM hisalbac'+Tienda+', clientes WHERE HAC0=C0 AND HAC1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit3.Text))+'" AND HAC1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit4.Text))+'" ORDER BY HAC2 ASC, HAC1 DESC, HAC3 DESC';
  dbMuestrac.Active := True;
  If dbMuestrac.RecordCount=0 then
    begin
      Showmessage('NO HAY ALBARANES ENTRE ESAS FECHAS');
      exit;
    end;
end;

procedure TFHistAlbaran.RadioGroup2Click(Sender: TObject);
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

  if (lMarcado<>lCambio) then dbMuestrac.SQL.Text:= iniMuestrac + ' AND HAC10="'+txtMarcado+'" ' + finMuestrac;

  dbMuestrac.Active:= true;

end;


procedure TFHistAlbaran.DBGrid1TitleClick(Column: TColumn);
begin
 Colorea(Column,DBGrid1,dbMuestrac, AntColun, Orden, TituloColumn, Ordenado);
end;

//===========================================================
//===================== GESTIONAR ALBARANES ==================
//===========================================================
procedure TFHistAlbaran.BitBtn1Click(Sender: TObject);
begin
  If dbMuestrac.RecordCount=0 then Begin Showmessage('NO HAY NINGUNA ALBARAN PARA GESTIONAR'); Exit; End;
  dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+dbMuestrac.FieldByName('HAC0').AsString;
  dbClientes.Active:=True;
  If dbClientes.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL CLIENTE '+dbMuestrac.FieldByName('HAC0').AsString+' ?'); Exit; End;
  Panel4.BringToFront; Panel4.Visible:=True;
  DBGrid2.BringToFront; DBGrid2.Visible:=True;
  MostrarBotonesdd();
  LimpiaCliente();
  //-- MID(HAD6,1,150)
  dbMuestrad.SQL.Text:='SELECT *, CONVERT(HAD6 USING UTF8) As DESCRI FROM hisalbad'+Tienda+' WHERE HAD0='+dbMuestrac.FieldByName('HAC0').AsString+
                     ' AND HAD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('HAC1').AsDateTime)+'"'+
                     ' AND HAD2="'+dbMuestrac.FieldByName('HAC2').AsString+'"'+
                     ' AND HAD3='+dbMuestrac.FieldByName('HAC3').AsString;
  dbMuestrad.Active:=True;
  PintaCliente();
  Label30.Caption:=dbMuestrac.FieldByName('HAC2').AsString;//---- Serie
  Label31.Caption:=dbMuestrac.FieldByName('HAC3').AsString;//---- N. Albaran
  Label33.Caption:=dbMuestrac.FieldByName('HAC1').AsString;//---- Fecha Fact.
  LabelTotal.Caption:=FormatFloat('0.00',dbMuestrac.FieldByName('HAC9').AsFloat);
  DbGrid2.SetFocus;

end;

//--------------------- Salir de gestionar albaranes ------------
procedure TFHistAlbaran.BitBtn5Click(Sender: TObject);
var
 Posi: Integer;
 TxtQ, TxtTemp: String;
begin
  Panel7.Visible:=False;
  Panel4.SendToBack; Panel4.Visible:=False;
  DBGrid2.SendToBack; DBGrid2.Visible:=False;
  OcultarBotonesdd();
  //bhisalbad.Active:=False;
  //------------- Si el albaran no tiene lineas borrarla?

  If dbMuestrad.RecordCount=0 then
     begin
       boxstyle :=  MB_ICONQUESTION + MB_YESNO;
       If Application.MessageBox('CONFIRME EL BORRADO DEL ALBARAN COMPLETO?','FacturLinEx', boxstyle) = IDNO Then
          Exit;
       TxtTemp:=dbMuestrac.SQL.Text;
       TxtQ:='DELETE FROM hisalbac'+Tienda+' WHERE HAC0='+dbMuestrac.FieldByName('HAC0').AsString+
             ' AND HAC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('HAC1').AsDateTime)+'"'+
             ' AND HAC2="'+dbMuestrac.FieldByName('HAC2').AsString+'" AND HAC3='+dbMuestrac.FieldByName('HAC3').AsString;
       dbhisalbac.SQL.Text:=TxtQ; dbhisalbac.ExecSQL;
       //dbMuestrac.Refresh;
       dbMuestrac.Active:=False;
       dbMuestrac.Sql.Text:=TxtTemp;
       dbMuestrac.Active:=True;
       Exit;
     end;
  //------------- Actualizar cabecera albaranes
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT COUNT(*), SUM(HAD7), SUM(HAD11), SUM(HAD13) FROM hisalbad'+Tienda+' WHERE'+
                     ' HAD0='+dbMuestrac.FieldByName('HAC0').AsString+
                     ' AND HAD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('HAC1').AsDateTime)+'"'+
                     ' AND HAD2="'+dbMuestrac.FieldByName('HAC2').AsString+'"'+
                     ' AND HAD3='+dbMuestrac.FieldByName('HAC3').AsString;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then exit;
  TxtQ:='UPDATE hisalbac'+Tienda+' SET HAC4='+dbTrabajo.Fields[0].AsString+', HAC5='+dbTrabajo.Fields[1].AsString+
        ', HAC8='+dbTrabajo.Fields[2].AsString+', HAC9='+dbTrabajo.Fields[3].AsString+
        ' WHERE HAC0='+dbMuestrac.FieldByName('HAC0').AsString+
        ' AND HAC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('HAC1').AsDateTime)+'"'+
        ' AND HAC2="'+dbMuestrac.FieldByName('HAC2').AsString+'" AND HAC3='+dbMuestrac.FieldByName('HAC3').AsString;
  dbHisalbac.SQL.Clear; dbhisalbac.SQL.Text:=TxtQ; dbhisalbac.ExecSQL;
  Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;
end;

//===========================================================
//======================= CREAR LINEAS ======================
//===========================================================
procedure TFHistAlbaran.BitBtn12Click(Sender: TObject);
begin
  Panel6.BringToFront;
  Panel7.Visible:=False;
  Panel6.Visible:=True; Edit5.Enabled:=True;
  Panel1.Enabled:=False; DBGrid2.Enabled:=False;
  Limpiadd(); Edit5.SetFocus;
end;

//===========================================================
//======================= BORRAR LINEAS =====================
//===========================================================
procedure TFHistAlbaran.BitBtn14Click(Sender: TObject);
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
  dbMuestrad.Delete;
end;

//===========================================================
//======================= MODIFICAR LINEAS ==================
//===========================================================
procedure TFHistAlbaran.DBGrid2DblClick(Sender: TObject);
begin

  Exit;

  if (dbMuestrad.Active=False) or (dbMuestrad.RecordCount=0) then exit;;
  Panel7.Visible:=False;
  Panel6.BringToFront;Panel6.Visible:=True; Panel1.Enabled:=False; DBGrid2.Enabled:=False;
  label28.Caption:=' Editando línea '; //+ dbMuestrad.FieldByName('AD4').AsString;
  Edit5.Text:=dbMuestrad.FieldByName('HAD5').AsString;
  Edit5.Enabled:=False;
  Edit6.Text:=dbMuestrad.FieldByName('HAD6').AsString;
  Edit7.Text:=dbMuestrad.FieldByName('HAD7').AsString;
  Edit8.Text:=FormatFloat('0.00',dbMuestrad.FieldByName('HAD8').AsFloat);
  Edit9.Text:=FormatFloat('0.000',dbMuestrad.FieldByName('HAD9').AsFloat);
  Edit10.Text:=dbMuestrad.FieldByName('HAD10').AsString;
  Edit11.Text:=FormatFloat('0.000',dbMuestrad.FieldByName('HAD11').AsFloat);
  Edit12.Text:=dbMuestrad.FieldByName('HAD12').AsString;
  Edit13.Text:=FormatFloat('0.00',dbMuestrad.FieldByName('HAD13').AsFloat);
  Edit6.SetFocus;
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;
  CargaTarifas(0);
end;

procedure TFHistAlbaran.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key=VK_RETURN then begin Key:=0; DBGrid2DblClick(self); end;
end;

//----------------- Salir Crear / Modificar Lineas ------------------
procedure TFHistAlbaran.BitBtn6Click(Sender: TObject);
begin
  ListBox2.Visible:=False;
  Panel6.SendToBack;
  Panel6.Visible:=False;
  Panel1.Enabled:=True; DBGrid2.Enabled:=True; DBGrid2.SetFocus;
end;

procedure TFHistAlbaran.BitBtn7Click(Sender: TObject);
var
   inutil: string;
begin
  //-- MID(HAC11,1,250)
   inutil:= FBusquedas.IniciaBusquedas('SELECT concat(HAC2, HAC3) as numero, HAC1, HAC0, HAC9, CONVERT(HAC11 USING UTF8) as notas FROM hisalbac'+Tienda,
               ['Numero','Fecha','Cliente','Total','Observaciones'],'numero');
end;

//----------------- Aceptar Crear / Modificar Lineas ----------------
procedure TFHistAlbaran.BitBtn8Click(Sender: TObject);
var
 Posi: Integer;
begin
  if Edit5.Enabled=False then
   begin
    //----- Modificar Linea
//    SumarStock(dbMuestrad.FieldByName('HAD5').AsString, dbMuestrad.FieldByName('HAD7').AsString );
//    RestarEsta(dbMuestrad.FieldByName('HAD5').AsString, dbMuestrad.FieldByName('HAD7').AsString,
//              dbMuestrad.FieldByName('HAD11').AsString);

    dbMuestrad.Edit; Llenadd(); dbMuestrad.Post;

//    RestarStock(Edit5.Text,Edit7.Text);
//    SumarEsta(Edit5.Text,Edit7.Text,Edit11.Text);

    Panel6.SendToBack;
    Panel6.Visible:=False;
    Panel1.Enabled:=True; DBGrid2.Enabled:=True;
    Posi:=dbMuestrad.RecNo; dbMuestrad.Refresh; dbMuestrad.RecNo:=Posi;
    ActualizaImporte;
    DBGrid2.SetFocus;
    exit;

   end
 else
   begin
    //----- Crear linea
    dbMuestrad.Append; Llenadd(); dbMuestrad.Post;
//    RestarStock(Edit5.Text, Edit7.Text);
//    SumarEsta(Edit5.Text,Edit7.Text,Edit11.Text);
    Limpiadd(); Edit5.SetFocus;
    Posi:=dbMuestrad.RecNo; dbMuestrad.Refresh; dbMuestrad.RecNo:=Posi;
    ActualizaImporte;
   end;

end;

//===========================================================
//===================== NUEVO ALBARAN =======================
//===========================================================
procedure TFHistAlbaran.BitBtn9Click(Sender: TObject);
begin
  if (RadioButton2.Checked=False) or (Edit1.Text='') then
     begin ShowMessage('PRIMERO DEBE SELECCIONAR UN CLIENTE'); exit; end;
  if dbClientes.EOF=True then
     begin showmessage('EL CLIENTE SELECIONADO NO EXISTE'); Exit; end;
  //--- Ver la tienda activa para saber que serie usa por defecto
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin Showmessage('NO SE EN QUE TIENDA HACER EL ALBARAN'); Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); exit; end;
  dbSeries.First; ListBox1.Items.Clear;
  Panel8.Visible:=True; Panel1.Enabled:=False; //DBGrid1.Enabled:=False;
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
  ListBox1.SetFocus;
  Edit21.Text:=dbSeries.FieldByName('SF3').AsString;
  dbTiendas.Active:=False;
end;

procedure TFHistAlbaran.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then begin key:=0; BitBtn1Click(self); end;

end;

//---------------- Ver series cuando se pasa por ellas ----------------
procedure TFHistAlbaran.ListBox1Click(Sender: TObject);
begin
//  if dbSeries.Locate('SF0',trim(copy(ListBox1.Items.Strings[ListBox1.ItemIndex],1,2)),[]) then
//    Edit21.Text:=dbSeries.FieldByName('SF3').AsString;
end;

procedure TFHistAlbaran.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 // if key=VK_RETURN then begin key:=0; BitBtn19Click(self); end;
end;


//---------------- Aceptar nuevo albaran ----------------
procedure TFHistAlbaran.BitBtn19Click(Sender: TObject);
var
 iniMuestrac, finMuestrac: string;
begin
  SALBARAN:=dbSeries.FieldByName('SF0').AsString;
  if SALBARAN='' then begin showmessage('DEBE SELECCIONAR UNA SERIE PARA FACTURAR'); Exit; end;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM hisalbac'+Tienda+' WHERE HAC0='+Edit1.Text+' ORDER BY HAC0, HAC1, HAC2, HAC3';
  dbTrabajo.Active:=True;
  //if swhueco=0 then NumeroAlbaran();
  NumeroAlbaran();
  dbtrabajo.Append;
  dbtrabajo.FieldByName('HAC0').AsString:=Edit1.Text; //-------------- Cliente.
  dbtrabajo.FieldByName('HAC1').Value:=StrToDate(Edit22.Text); //----- Fecha Albaran.
  dbtrabajo.FieldByName('HAC2').Value:=SALBARAN; //------------------- Serie de la albaran.
  dbtrabajo.FieldByName('HAC3').Value:=NALBARAN; //------------------- N. Albaran.
  dbtrabajo.FieldByName('HAC4').Value:=0;
  dbtrabajo.FieldByName('HAC5').Value:=0;
  dbtrabajo.FieldByName('HAC6').Value:=0;
  dbtrabajo.FieldByName('HAC7').Value:=dbClientes.Fields[19].AsString;//-- Recargo S/N
  dbtrabajo.FieldByName('HAC8').Value:=0;//------------------------------- Imp. Sin IVA
  dbtrabajo.FieldByName('HAC9').Value:=0;//------------------------------- Imp. Con IVA
  dbtrabajo.FieldByName('HAC10').Value:='N';//---------------------------- Marcada (S/N)
  dbtrabajo.Post;

  if checkbox4.Checked then
        begin
          iniMuestrac:=dbMuestrac.SQL.Text; finMuestrac:=iniMuestrac;
          Delete(iniMuestrac, pos('WHERE', dbMuestrac.SQL.Text)+5 , length(dbMuestrac.SQL.Text));
          Delete(finMuestrac, 1, pos('WHERE',dbMuestrac.SQL.Text)+5  );
          dbMuestrac.Active:= false;
          dbMuestrac.SQL.Text:= iniMuestrac + ' HAC2="'+SALBARAN+'" AND ' + finMuestrac;
          dbMuestrac.Active:= true;
        end;

  dbMuestrac.Refresh; dbMuestrac.First;
  BitBtn20Click(BitBtn20);//--- Cerrar Panel
end;

//---------------- Cancelar nuevo albaran ----------------
procedure TFHistAlbaran.BitBtn20Click(Sender: TObject);
begin
//  Panel8.Visible:=False; Panel1.Enabled:=True; DBGrid1.Enabled:=True;
//  dbGrid1.SetFocus;
end;

//===========================================================
//================ BORRAR ALBARAN COMPLETO ==================
//===========================================================
procedure TFHistAlbaran.BitBtn10Click(Sender: TObject);
var
  TxtQ, TxtTemp: String;
begin
  If dbMuestrac.RecordCount=0 then Begin Showmessage('NO HAY NINGUN ALBARAN PARA GESTIONAR'); Exit; End;
  dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+dbMuestrac.FieldByName('AC0').AsString;
  dbClientes.Active:=True;
  If dbClientes.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL CLIENTE '+dbMuestrac.FieldByName('AC0').AsString+' ?'); Exit; End;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('CONFIRME EL BORRADO DEL ALBARAN COMPLETO?','FacturLinEx', boxstyle) = IDNO Then Exit;

  //----------------- Borrar detalles de albaranes
  TxtQ:='DELETE FROM hisalbad'+Tienda+' WHERE AD0='+dbMuestrac.FieldByName('AC0').AsString+
        ' AND AD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
        ' AND AD2="'+dbMuestrac.FieldByName('AC2').AsString+'" AND AD3='+dbMuestrac.FieldByName('AC3').AsString;
  dbhisalbad.SQL.Text:=TxtQ; dbhisalbad.ExecSQL;
  //----------------- Borrar cabeceras de albaranes
  TxtTemp:=dbMuestrac.SQL.Text;
  TxtQ:='DELETE FROM hisalbac'+Tienda+' WHERE AC0='+dbMuestrac.FieldByName('AC0').AsString+
        ' AND AC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
        ' AND AC2="'+dbMuestrac.FieldByName('AC2').AsString+'" AND AC3='+dbMuestrac.FieldByName('AC3').AsString;
  dbhisalbac.SQL.Text:=TxtQ; dbhisalbac.ExecSQL;

  //dbMuestrac.Refresh;
  dbMuestrac.Active:=False;
  dbMuestrac.Sql.Text:=TxtTemp;
  dbMuestrac.Active:=True;

end;

//===========================================================
//================= LISTADO DE ALBARANES CABECERAS ===========
//===========================================================
procedure TFHistAlbaran.BitBtn23Click(Sender: TObject);
begin
  Panel9.Visible:=True; Edit14.SetFocus;
  Edit14.Text:='1'; Edit16.Text:=ClienteVario;
  Edit18.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit19.Text:=FormatDateTime('DD/MM/YYYY',Date);
end;

//---------- Aceptar listado de albaranes cc ----------
procedure TFHistAlbaran.BitBtn21Click(Sender: TObject);
begin
  If (Edit14.Text='') or (Edit16.Text='') then Exit;
  dbBusca.Sql.Text:='SELECT *,C1 FROM albac'+Tienda+', clientes WHERE AC0=C0'+
                    ' AND AC1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit18.Text))+'"'+
                    ' AND AC1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit19.Text))+'"'+
                    ' AND AC0>='+Edit14.Text+' AND AC0<='+Edit16.Text+' ORDER BY AC2 ASC, AC1 DESC, AC3 DESC';
  dbBusca.Active := True;
  If dbBusca.RecordCount=0 then
    begin
      Showmessage('NO HAY ALBARANES ENTRE ESOS DATOS');
      exit;
    end;
  FImpresion.Imprime(dbBusca.SQL.Text, 'ListaAlbaranes','');

end;

//-------------------- Desde cliente ---------------
procedure TFHistAlbaran.Edit14Enter(Sender: TObject);
begin
   Edit15.Text:='';
end;
procedure TFHistAlbaran.Edit14Exit(Sender: TObject);
begin
   if Edit14.Text='' then Edit14.Text:='1';
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit14.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then Begin Showmessage('ESE CLIENTE NO EXISTE.'); Edit14.SetFocus; Exit; End;
   Edit15.Text:=dbClientes.FieldByName('C1').AsString;
end;

//-------------------- Hasta cliente ---------------
procedure TFHistAlbaran.Edit16Enter(Sender: TObject);
begin
   Edit17.Text:='';
end;
procedure TFHistAlbaran.Edit16Exit(Sender: TObject);
begin
   if Edit16.Text='' then Edit16.Text:=ClienteVario;
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit16.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then Begin Showmessage('ESE CLIENTE NO EXISTE.'); Edit16.SetFocus; Exit; End;
   Edit17.Text:=dbClientes.FieldByName('C1').AsString;
end;

//---------- Cerrar listado de albaranes cc ----------
procedure TFHistAlbaran.BitBtn22Click(Sender: TObject);
begin
  Panel9.Visible:=False;
end;

//===========================================================
//==================== IMPRIMIR ALBARAN =====================
//===========================================================
procedure TFHistAlbaran.BitBtn15Click(Sender: TObject);
begin
  FImpresion.Imprime(dbMuestrad, dbMuestrac, dbClientes, 'ALBARAN(H)', false, 1);
end;

//=================== OBSERVACIONES ==========================
procedure TFHistAlbaran.BitBtn16Click(Sender: TObject);
begin
  Panel7.BringToFront;
  Panel7.Visible:=True;
  Memo1.Lines.Text:=dbMuestrac.FieldByName('HAC11').AsString;
  Memo1.SetFocus;
end;
//--------------- Aceptar Observaciones --------
procedure TFHistAlbaran.BitBtn18Click(Sender: TObject);
var
 Posi: Integer;
 TxtQ: String;
begin
  TxtQ:='UPDATE hisalbac'+Tienda+' SET HAC11="'+Memo1.Lines.Text+'" WHERE HAC0='+dbMuestrac.FieldByName('HAC0').AsString+
        ' AND HAC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('HAC1').AsDateTime)+'"'+
        ' AND HAC2="'+dbMuestrac.FieldByName('HAC2').AsString+'" AND HAC3='+dbMuestrac.FieldByName('HAC3').AsString;
  dbhisalbac.SQL.Text:=TxtQ; dbhisalbac.ExecSQL;
  Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;
  Panel7.SendToBack; Panel7.Visible:=False;
end;

//--------------- Cancelar Observaciones --------
procedure TFHistAlbaran.BitBtn17Click(Sender: TObject);
begin
  Panel7.SendToBack; Panel7.Visible:=False;
end;

//==================== MARCAR ALBARANES ======================
procedure TFHistAlbaran.DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   if Button=mbLeft then exit;
   if dbMuestrac.FieldByName('AC10').AsString='S' then Marca:='N' else Marca:='S';
   TxtQ:='UPDATE hisalbac'+Tienda+' SET AC10="'+Marca+'" WHERE AC0='+dbMuestrac.FieldByName('AC0').AsString+
             ' AND AC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
        ' AND AC2="'+dbMuestrac.FieldByName('AC2').AsString+'" AND AC3='+dbMuestrac.FieldByName('AC3').AsString;
   dbhisalbac.SQL.Text:=TxtQ; dbhisalbac.ExecSQL;
   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;
end;

//=============== SALIR DEL CGO. ARTICULO =====================
procedure TFHistAlbaran.Edit5Exit(Sender: TObject);
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


procedure TFHistAlbaran.BitBtn11Click(Sender: TObject);
begin
  BuscaArticulo();
end;

//------------------ Buscar Articulos ---------------
procedure TFHistAlbaran.BuscaArticulo();
begin
  Edit5.Text:=FBusquedas.IniciaBusquedas('SELECT A0, EAN0, A1 FROM artitien'+Tienda+
            ' , eans WHERE (A0=EAN1) and (A0 LIKE "%'+Edit5.Text+'%" )', ['Código','Ean','Referencia'],'A0');
  Edit5Exit(self);
end;

procedure TFHistAlbaran.Edit6DblClick(Sender: TObject);
var
   key: char;
begin
  if Edit5.Enabled=false then exit;
  key:=#13;
  Edit6KeyPress(self, key);

end;

//------------------ Buscar Articulos ---------------
procedure TFHistAlbaran.Edit6KeyPress(Sender: TObject; var Key: char);
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

procedure TFHistAlbaran.ListBox3DblClick(Sender: TObject);
begin
  if not dbBusca.Locate('A1',ListBox3.Items.Strings[ListBox3.ItemIndex],[]) then begin Edit6.Text:=''; Exit; end;
  Edit5.Text:=dbBusca.Fields[0].AsString;
  Edit6.Text:=dbBusca.Fields[1].AsString;
//  Edit5Exit(Edit5);//---- Leer articulo
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;
  Pintadd();
  CargaTarifas(1);
  ListBox3.Visible:=False; Edit7.SetFocus;
end;

procedure TFHistAlbaran.ListBox3KeyPress(Sender: TObject; var Key: char);
begin
   if (Key=#13) then ListBox3DblClick(self);
end;

procedure TFHistAlbaran.MenuItem1Click(Sender: TObject);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   Marca:='S';
   if dbMuestrac.FieldByName('HAC10').AsString='S' then Marca:='N';
   TxtQ:='UPDATE hisalbac'+Tienda+' SET HAC10="'+Marca+'" WHERE HAC0='+dbMuestrac.FieldByName('HAC0').AsString+
             ' AND HAC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('HAC1').AsDateTime)+'"'+
        ' AND HAC2="'+dbMuestrac.FieldByName('HAC2').AsString+'" AND HAC3='+dbMuestrac.FieldByName('HAC3').AsString;
   dbhisalbac.SQL.Text:=TxtQ; dbhisalbac.ExecSQL;
   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;

end;

procedure TFHistAlbaran.MenuItem2Click(Sender: TObject);
 Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   Marca:='S';
   if dbMuestrac.FieldByName('HAC16').AsString='S' then Marca:='N';
   TxtQ:='UPDATE hisalbac'+Tienda+' SET HAC16="'+Marca+'" WHERE HAC0='+dbMuestrac.FieldByName('HAC0').AsString+
             ' AND HAC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('HAC1').AsDateTime)+'"'+
        ' AND HAC2="'+dbMuestrac.FieldByName('HAC2').AsString+'" AND HAC3='+dbMuestrac.FieldByName('HAC3').AsString;
   dbhisalbac.SQL.Text:=TxtQ; dbhisalbac.ExecSQL;
   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;


end;


//===================== SALIR DE LA CANTIDAD ======================
procedure TFHistAlbaran.Edit7Exit(Sender: TObject);
begin
  if not (EsFloat(Edit7.Text)) then begin Edit7.Text:='0';Edit7.SetFocus; exit; end;

  if (Edit7.Text='') or (Edit7.Text='0') then begin Edit11.Text:='0';Edit13.Text:='0'; Exit; end;//------ Cant.
  if (Edit9.Text='') or (Edit9.Text='0') then begin Edit11.Text:='0';Edit13.Text:='0'; Exit; end;//------ Precio

  Edit11.Text:=FormatFloat('0.000',StrToFloat(Edit7.Text)*StrToFloat(Edit9.Text));//---- Importe
  //------- Calcular importe con descuento
  if Edit10.Text<>'0' then
    begin
      Edit11.Text:=FormatFloat('0.000',StrToFloat(Edit11.Text)-(StrToFloat(Edit11.Text)*StrToFloat(Edit10.Text))/100);//---- Importe con DTO
    end;
  Edit13.Text:=FormatFloat('0.00',StrToFloat(Edit11.Text));//---- Total
  //------- Calcular Total con iva
  if (Edit12.Text<>'') and (Edit12.Text<>'0') then
    begin
      Edit13.Text:=FormatFloat('0.00',(StrToFloat(Edit11.Text)*StrToFloat(Edit12.Text) / 100)+StrToFloat(Edit11.Text))
    end;

end;

procedure TFHistAlbaran.Edit7KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) and (Edit5.Enabled=true) then Edit5.SetFocus;
end;

procedure TFHistAlbaran.Edit8Exit(Sender: TObject);
begin
  if not (EsFloat(Edit8.Text)) then begin Edit8.Text:='0'; Edit8.SetFocus; exit; end;
end;

procedure TFHistAlbaran.Edit9DblClick(Sender: TObject);
begin
  MuestraTarifas();
end;

//======================= SALIR DEL PRECIO ========================
procedure TFHistAlbaran.Edit9Exit(Sender: TObject);
begin
  if not (EsFloat(Edit9.Text)) then begin Edit9.Text:='0'; Edit9.SetFocus; exit; end;
  if Edit7.Text='' then Edit7.Text:='0'; //------ Cant.
  if Edit9.Text='' then Edit9.Text:='0'; //------ Precio
  Edit11.Text:=FormatFloat('0.000',StrToFloat(Edit7.Text)*StrToFloat(Edit9.Text));//--- Importe
  //------- Calcular importe con descuento
  if Edit10.Text<>'0' then
    begin
      Edit11.Text:=FormatFloat('0.000',StrToFloat(Edit11.Text)-(StrToFloat(Edit11.Text)*StrToFloat(Edit10.Text))/100);//---- Importe con DTO
    end;
  Edit13.Text:=FormatFloat('0.00',StrToFloat(Edit11.Text));//---- Total
  //------- Calcular Total con iva
  if (Edit12.Text<>'') and (Edit12.Text<>'0') then
    begin
      Edit13.Text:=FormatFloat('0.00',(StrToFloat(Edit11.Text)*StrToFloat(Edit12.Text) / 100)+StrToFloat(Edit11.Text))
    end;

end;

//======================= SALIR DEL DTO =============================
procedure TFHistAlbaran.Edit10Exit(Sender: TObject);
begin
  if not (EsFloat(Edit10.Text)) then begin Edit10.Text:='0';Edit10.SetFocus ; exit; end;
  if (Edit7.Text='') or (Edit7.Text='0') then begin Edit7.Text:='0'; Exit; end;//------ Cant.
  if (Edit9.Text='') or (Edit9.Text='0') then begin Edit9.Text:='0'; Exit; end;//------ Precio
  if (Edit10.Text='') or (Edit10.Text='0') then begin Edit10.Text:='0'; Exit; end;//--- Dto
  Edit11.Text:=FormatFloat('0.000',StrToFloat(Edit7.Text)*StrToFloat(Edit9.Text));//--- Importe
  //------- Calcular importe con descuento
  if Edit10.Text<>'0' then
    begin
      Edit11.Text:=FormatFloat('0.000',StrToFloat(Edit11.Text)-(StrToFloat(Edit11.Text)*StrToFloat(Edit10.Text))/100);//---- Importe con DTO
    end;
  Edit13.Text:=FormatFloat('0.00',StrToFloat(Edit11.Text));//---- Total
  //------- Calcular Total con iva
  if (Edit12.Text<>'') and (Edit12.Text<>'0') then
    begin
      Edit13.Text:=FormatFloat('0.00',(StrToFloat(Edit11.Text)*StrToFloat(Edit12.Text) / 100)+StrToFloat(Edit11.Text))
    end;

end;

//======================= SALIR DEL IVA ==============================
procedure TFHistAlbaran.Edit12Exit(Sender: TObject);
begin
  if not (EsFloat(Edit12.Text)) then begin Edit12.Text:='0'; Edit12.SetFocus; exit; end;
  if (Edit7.Text='') or (Edit7.Text='0') then begin Edit7.Text:='0'; Exit; end;//------ Cant.
  if (Edit9.Text='') or (Edit9.Text='0') then begin Edit9.Text:='0'; Exit; end;//------ Precio
  if (Edit11.Text='') or (Edit11.Text='0') then begin Edit11.Text:='0'; Exit; end;//--- Importe

  Edit13.Text:=FormatFloat('0.00',StrToFloat(Edit11.Text));//---- Total
  //------- Calcular Total con iva
  if (Edit12.Text<>'') and (Edit12.Text<>'0') then
    begin
      Edit13.Text:=FormatFloat('0.00',(StrToFloat(Edit11.Text)*StrToFloat(Edit12.Text) / 100)+StrToFloat(Edit11.Text))
    end;

end;

//==================== PINTAR DATOS DE CLIENTES ======================
procedure TFHistAlbaran.PintaCliente();
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
procedure TFHistAlbaran.LimpiaCliente();
begin
  Label4.Caption:=''; Label5.Caption:=''; Label6.Caption:='';
  Label7.Caption:=''; Label8.Caption:=''; Label9.Caption:='';
  Label10.Caption:=''; LabelTotal.Caption:='0.00';
end;
//==================== LLENAR DATOS LINEAS =======================
procedure TFHistAlbaran.Llenadd();
begin
                                 // -- Si esta creando nueva
  if Edit5.Enabled=true then
    begin
     dbMuestrad.FieldByName('HAD0').Value:=dbMuestrac.FieldByName('HAC0').Value;//---- Cliente
     dbMuestrad.FieldByName('HAD1').Value:=dbMuestrac.FieldByName('HAC1').Value;//---- Fecha
     dbMuestrad.FieldByName('HAD2').Value:=dbMuestrac.FieldByName('HAC2').Value;//---- Serie
     dbMuestrad.FieldByName('HAD3').Value:=dbMuestrac.FieldByName('HAC3').Value;//---- Numero
     dbMuestrad.FieldByName('HAD4').Value:=VerUltimaLinea; //--- N. Linea
     label28.Caption:=' Añadiendo nuevas líneas. ';
     dbMuestrad.FieldByName('HAD5').AsString:=Edit5.Text;//----- Codigo
    end;
  dbMuestrad.FieldByName('HAD6').AsString:=Edit6.Text;//-------- Descripcion
  dbMuestrad.FieldByName('HAD7').AsString:=Edit7.Text;//-------- Cantidad
  dbMuestrad.FieldByName('HAD8').AsString:=Edit8.Text;//-------- Precio con IVA
  dbMuestrad.FieldByName('HAD9').AsString:=Edit9.Text;//-------- Precio sin IVA
  dbMuestrad.FieldByName('HAD10').AsString:=Edit10.Text;//------ Dto. %
  dbMuestrad.FieldByName('HAD11').AsString:=Edit11.Text;//------ Importe sin IVA
  dbMuestrad.FieldByName('HAD12').AsString:=Edit12.Text;//------ IVA
  dbMuestrad.FieldByName('HAD13').AsString:=Edit13.Text;//------ Importe con IVA
end;

//=================== SACAR EL ULT N. DE LINEA =====================
function TFHistAlbaran.VerUltimaLinea: Integer;
begin
  VerUltimaLinea:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(HAD4) As ULTIMA FROM hisalbad'+Tienda+' WHERE HAD0='+dbMuestrac.FieldByName('HAC0').AsString+
                     ' AND HAD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('HAC1').AsDateTime)+'"'+
                     ' AND HAD2="'+dbMuestrac.FieldByName('HAC2').AsString+'"'+
                     ' AND HAD3='+dbMuestrac.FieldByName('HAC3').AsString;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLinea:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;

//======================= PINTAR DATOS LINEAS ==================
procedure TFHistAlbaran.Pintadd();
begin
  Edit6.Text:=dbArti.FieldByName('A1').AsString;//----- Descripcion
  Edit7.Text:='1';//----------------------------------- Unidades
  Edit8.Text:=dbArti.FieldByName('A2').AsString;//----- PVP
  Edit9.Text:=dbArti.FieldByName('A21').AsString;//---- Precio sin iva
  Edit10.Text:='0';//---------------------------------- Descuento
  Edit11.Text:=dbArti.FieldByName('A21').AsString;//--- Importe
  Edit12.Text:=dbArti.FieldByName('A3').AsString;//---- IVA

  Edit13.Text:=dbArti.FieldByName('A2').AsString;//---- Total

end;

//======================= LIMPIAR DATOS LINEAS ==================
procedure TFHistAlbaran.Limpiadd();
begin
  label28.Caption:='Editor de líneas ';
  Edit5.Text:=''; Edit6.Text:=''; Edit7.Text:='0';
  Edit8.Text:='0'; Edit9.Text:='0'; Edit10.Text:='0';
  Edit11.Text:='0'; Edit12.Text:='0'; Edit13.Text:='0';
end;
//======== CARGA PRECIOS Y DESCUENTOS DEL ARTICULO ==============
procedure TFHistAlbaran.CargaTarifas(actualiza: integer);
var
 TipoDescuento, TipoTarifa: integer;
begin

  dbTarifas.Active:=false;
  dbTarifas.SQL.Text:='select * from tarifas where TAR0="'+dbarti.FieldByName('A0').AsString +'"';

  if actualiza=0 then dbTarifas.SQL.Text:='select * from tarifas where TAR0="'+dbMuestrad.FieldByName('HAD5').AsString +'"';

  dbTarifas.Active:=true;

  ListBox2.Items.Clear;

  ListBox2.Items.Add('PVP        '+dbArti.FieldByName('A2').AsString + ' Euros');
  ListBox2.Items.Add('Precio     '+dbArti.FieldByName('A21').AsString + ' Euros');
  ListBox2.Items.Add('Tarifa 1   '+dbTarifas.FieldByName('TAR2').AsString + ' Euros');
  ListBox2.Items.Add('Tarifa 2   '+dbTarifas.FieldByName('TAR4').AsString + ' Euros');
  ListBox2.Items.Add('Tarifa 3   '+dbTarifas.FieldByName('TAR6').AsString + ' Euros');

  TipoDescuento:=0;
  TipoTarifa:=-1;

  TipoDescuento:= dbClientes.FieldByName('C16').Value;
  TipoTarifa:= dbClientes.FieldByName('C43').Value;
//  showmessage( dbClientes.FieldByName('C16').asstring +'  '+dbClientes.FieldByName('C43').asstring);

  if actualiza=1 then
    begin
        if TipoDescuento=1 then Edit10.Text:= dbArti.FieldByName('A7').AsString;
        if TipoDescuento=2 then Edit10.Text:= dbArti.FieldByName('A8').AsString;
        if TipoDescuento=3 then Edit10.Text:= dbArti.FieldByName('A9').AsString;
    end;

  if (actualiza=1) and (TipoTarifa<>-1) then
     begin
       if TipoTarifa=1 then Edit9.Text:=dbTarifas.FieldByName('TAR2').AsString;
       if TipoTarifa=2 then Edit9.Text:=dbTarifas.FieldByName('TAR4').AsString;
       if TipoTarifa=3 then Edit9.Text:=dbTarifas.FieldByName('TAR6').AsString;
     end;

  Edit11.Text:=FormatFloat('0.000',StrToFloat(Edit7.Text)*StrToFloat(Edit9.Text));//--- Importe
  //------- Calcular importe con descuento
  if Edit10.Text<>'0' then
    begin
      Edit11.Text:=FormatFloat('0.000',StrToFloat(Edit11.Text)-(StrToFloat(Edit11.Text)*StrToFloat(Edit10.Text))/100);//---- Importe con DTO
    end;
  Edit13.Text:=FormatFloat('0.00',StrToFloat(Edit11.Text));//---- Total
  //------- Calcular Total con iva
  if (Edit12.Text<>'') and (Edit12.Text<>'0') then
    begin
      Edit13.Text:=FormatFloat('0.00',(StrToFloat(Edit11.Text)*StrToFloat(Edit12.Text) / 100)+StrToFloat(Edit11.Text))
    end;

end;

procedure TFHistAlbaran.MuestraTarifas();
begin
   ListBox2.Visible:=true; ListBox2.SetFocus;
end;

procedure TFHistAlbaran.ListBox2DblClick(Sender: TObject);
begin
   ListBox2.Visible:= False;

   if ListBox2.ItemIndex=0 then Edit9.Text:=dbArti.FieldByName('A2').AsString;
   if ListBox2.ItemIndex=1 then Edit9.Text:=dbArti.FieldByName('A21').AsString;
   if ListBox2.ItemIndex=2 then Edit9.Text:=dbTarifas.FieldByName('TAR2').AsString;
   if ListBox2.ItemIndex=3 then Edit9.Text:=dbTarifas.FieldByName('TAR4').AsString;
   if ListBox2.ItemIndex=4 then Edit9.Text:=dbTarifas.FieldByName('TAR6').AsString;


   Edit9Exit(self);

end;

procedure TFHistAlbaran.ListBox2KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then ListBox2DblClick(self);
end;

//================= ACTUALIZA IMPORTE EN PANTALLA ===============
procedure TFHistAlbaran.ActualizaImporte();
begin
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT SUM(HAD13) FROM hisalbad'+Tienda+' WHERE'+
                     ' HAD0='+dbMuestrac.FieldByName('HAC0').AsString+
                     ' AND HAD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('HAC1').AsDateTime)+'"'+
                     ' AND HAD2="'+dbMuestrac.FieldByName('HAC2').AsString+'"'+
                     ' AND HAD3='+dbMuestrac.FieldByName('HAC3').AsString;
  dbBusca.Active:=True;

  LabelTotal.Caption:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);
end;



//================= N. DE ALBARAN ===========================
procedure TFHistAlbaran.NumeroAlbaran();
begin
  if SALBARAN='' then begin SALBARAN:='';NALBARAN:=0; Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF3=SF3+1 WHERE SF0="'+SALBARAN+'"';
  dbSeries.ExecSql;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+SALBARAN+'"';
  dbSeries.Active:=True;
  if dbSeries.Recordcount=0 then exit;
//  SALBARAN:=dbSeries.Fields[0].AsString;
  NALBARAN:=dbSeries.FieldByName('SF3').Value;
  dbSeries.Active:=False;
end;

//================  Muestra histórico de compras del cliente =========

procedure TFHistAlbaran.BitBtn24Click(Sender: TObject);
var
  inutil: string;
begin
inutil:=FBusquedas.IniciaBusquedas('SELECT HC0, HC1, HC2, HC4, HC5, HC6, HC7 FROM histoclie WHERE HC0='+dbMuestrac.FieldByName('AC0').AsString
                        , ['Cliente','Fecha','Hora','Código','Descripción','Und','Importe'],'HC1');

end;


//====================== MOSTRAR BOTONES DD ====================
procedure TFHistAlbaran.MostrarBotonesdd();
begin
  BitBtn5.Visible:=True; BitBtn12.Visible:=True;
  BitBtn13.Visible:=True; BitBtn14.Visible:=True;
  BitBtn15.Visible:=True; BitBtn16.Visible:=True;
  BitBtn12.Enabled:=False;BitBtn13.Enabled:=False;
  BitBtn16.Enabled:=False;BitBtn14.Enabled:=False;

  //-------------- cc
  BitBtn1.Visible:=False; BitBtn9.Visible:=False;
  BitBtn10.Visible:=False; BitBtn2.Visible:=False;
  BitBtn23.Visible:=False;
  BitBtn9.Enabled:=False;BitBtn10.Enabled:=False;

  //--------------- Oculta Filtro de cabeceras.
  RadioGroup2.Visible:=False;

end;

//====================== OCULTAR BOTONES DD ====================
procedure TFHistAlbaran.OcultarBotonesdd();
begin
  BitBtn5.Visible:=False; BitBtn12.Visible:=False;
  BitBtn13.Visible:=False; BitBtn14.Visible:=False;
  BitBtn15.Visible:=False; BitBtn16.Visible:=False;
  BitBtn12.Enabled:=False;BitBtn13.Enabled:=False;
  BitBtn16.Enabled:=False;BitBtn14.Enabled:=False;
  //-------------- cc
  BitBtn1.Visible:=True; BitBtn9.Visible:=True;
  BitBtn10.Visible:=True; BitBtn2.Visible:=True;
  BitBtn23.Visible:=True;
  BitBtn9.Enabled:=False;BitBtn10.Enabled:=False;

//--------------- Muestra Filtro de cabeceras.
  RadioGroup2.Visible:=True;

end;

//=================== TECLAS RAPIDAS ======================

procedure TFHistAlbaran.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

//     **********  Edición de las líneas del documento   **********

 if (key=VK_F12) and (panel6.Visible=True) and (Edit5.Enabled=True) then begin key:=0; BuscaArticulo(); end;     // Buscar artículo.
 if (key=VK_F11) and (panel6.Visible=True) and (Edit9.Focused) then begin key:=0; Edit9DblClick(self); Exit; End;     // Tarifas.
 if (key=VK_F11) and (panel6.Visible=True) and (Edit6.Focused) then begin key:=0; Edit6DblClick(self); Exit; End;
 if (key=VK_F6) and (panel6.Visible=True) then begin key:=0; Edit10.SetFocus; Exit; End;                         // Descuento
 if (key=VK_F7) and (panel6.Visible=True) then begin key:=0; Edit9.SetFocus; Exit; End;                          // Precio
 if (key=VK_F5) and (panel6.Visible=True) then begin key:=0; Edit7.SetFocus; Exit; End;                          // Cantidad
 if (key=VK_F8) and (panel6.Visible=True) then begin key:=0; BitBtn8Click(self); Exit; End;                      // Línea nueva
 if (key=VK_F10) and (panel6.Visible=True) then begin key:=0; BitBtn24Click(self); Exit; End;                    // histórico de cliente.
 if (key=VK_ESCAPE) and (panel6.Visible=True) then begin key:=0; BitBtn6Click(self) ; Exit; End;                 // finalizar entradas
 if (key=VK_RETURN) and (panel6.Visible=True) and                                  // entrada automática.
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
// if (key=VK_F2) and (dbGrid2.Visible=false) then begin key:=0; BitBtn9Click(self); Exit; End;                    // crea un pre/pro nuevo
// if (key=VK_F3) and (dbGrid2.Visible=false) then begin key:=0; BitBtn10Click(self); Exit; End;                   // borra un pre/pro
 if (key=VK_F11) and (dbGrid2.Visible=false) then begin key:=0; BitBtn23Click(self); Exit; End;                  // Listado de pre/pro's
 if (key=VK_F8 ) and (Panel9.Visible=True) then begin key:=0; BitBtn21Click(self); Exit; End;                    // ejecuta el listado
 if (key=VK_F8 ) and (Panel8.Visible=True) then begin key:=0; BitBtn19Click(self); dbGrid1.SetFocus; Exit; End;  // Acepta datos serie/numero pre/pro
 if (key=VK_ESCAPE) and (Panel9.Visible=True) then begin key:=0; BitBtn22Click(self); Exit; End;                 // Cancelar listado
 if (key=VK_ESCAPE) and (Panel8.Visible=True) then begin key:=0; BitBtn20Click(self); Exit; End;                 // Cancelar datos serie/pro.
 if (key=VK_ESCAPE) and (dbGrid2.Visible=false) then begin key:=0; BitBtn2Click(self); Exit; End;                // Salir de tarea de pre/pro
 if (key=VK_F12) and (dbGrid2.Visible=false) and (RadioButton2.Checked) then begin key:=0; BitBtn25Click(self); Exit; End;  // buscar clientes.


//     **********  Pantalla de detalles de proformas/presupuestos   **********

 if (key=VK_F2) and (dbGrid2.Visible=true) then begin key:=0; BitBtn12Click(self); Exit; End;                     // Crear líneas nuevas.
 if (key=VK_F3) and (dbGrid2.Visible=true) then begin key:=0; BitBtn14Click(self); Exit; End;                     // Borra la línea seleccionada
 if (key=VK_F4) and (dbGrid2.Visible=true) then begin key:=0; DBGrid2DblClick(self); Exit; End;                   // Editar la linea seleccionada
 if (key=VK_F11) and (dbGrid2.Visible=true) then begin key:=0; BitBtn15Click(self); Exit; End;                    // Imprime el pre/pro en uso.
// if (key=VK_F10) and (dbGrid2.Visible=true) then begin key:=0; BitBtn16Click(self); Exit; End;                    // Observaciones / notas
 if (key=VK_ESCAPE) and (panel7.Visible=True) then begin key:=0; BitBtn17Click(self); Exit; End;                  // Salir de observaciones
 if (key=VK_ESCAPE) and (dbGrid2.Visible=true) then begin key:=0; BitBtn5Click(self); Exit; End;                  // salir de la edicion de documentos.
 if (key=VK_F8) and (panel7.Visible=True) then begin key:=0; BitBtn18Click(self); Exit; End;                      // // acepta las observaciones.

end;

procedure TFHistAlbaran.FormShow(Sender: TObject);
begin
  dbGrid1.SetFocus;
end;


//====================== CERRAR FORMULARIO =====================
procedure TFHistAlbaran.BitBtn2Click(Sender: TObject);
begin
  Close();
end;
procedure TFHistAlbaran.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;


initialization

  {$I histoalba.lrs}

end.

