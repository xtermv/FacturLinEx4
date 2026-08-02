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

Unit Rutas;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType, DBGrids,
  TAGraph, TASeries, db, DbCtrls, Grids
  {$IFDEF LCLGTK2}
  , gtk2, gdk2
  {$ENDIF};


Type

  { TFRutas }

  TFRutas = Class(Tform)
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    DBGrid2: TDBGrid;
    dbRuta: TZQuery;
    DBGrid1: TDBGrid;
    dbRoles: TZQuery;
    dbSubRuta: TZQuery;
    dbSubRuta1: TZQuery;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    PanelCabecera: TPanel;
    PanelPie: TPanel;
    LabelTitulo: TLabel;
    LabelSubtitulo: TLabel;
    LabelPanelRuta: TLabel;
    LabelPanelSubRuta: TLabel;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure Datasource1DataChange(Sender: TObject; Field: TField);
    procedure Edit3Enter(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    Procedure Formcreate(Sender: Tobject);
    Procedure Edit1enter(Sender: Tobject);
    Procedure Edit1exit(Sender: Tobject);
    Procedure LimpiaForm();
    Procedure LimpiaForm1();
    Procedure Relleno();
    Procedure Relleno1();
    Procedure LlenaReg();
    Procedure LlenaReg1();
    Procedure RefrescaSubRuta1();
    Procedure Bitbtn1click(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    Procedure Bitbtn4click(Sender: Tobject);
    Procedure Bitbtn2click(Sender: Tobject);
    Procedure Bitbtn3click(Sender: Tobject);
  private
    FOrdenRutaCampo: String;
    FOrdenRutaAscendente: Boolean;
    FOrdenSubRutaCampo: String;
    FOrdenSubRutaAscendente: Boolean;
    procedure AplicarEstiloModerno;
    procedure CentrarPanelesEdicion;
    procedure AplicarContrasteSeleccion(AControl: TWinControl);
    procedure AplicarContrasteSeleccionControles(AParent: TWinControl);
    procedure DibujarCeldaGrid(AGrid: TDBGrid; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure OrdenarConsulta(AQuery: TZQuery; const ACampo: String;
      AAscendente: Boolean);
    procedure ActualizarFlechasRuta;
    procedure ActualizarFlechasSubRuta;
    function QuitarFlechaOrden(const ATexto: String): String;
  public
    { Public Declarations }
  End;

  procedure ShowFormRutas;
  
Var
  FRutas: TFRutas;
  cargando: Integer;

Implementation

Uses
  Global, Funciones;
  
//=============== Crea el formulario ================
procedure ShowFormRutas;
begin
  with TFRutas.Create(Application) do
    begin
       ShowModal;
    end;
end;
Procedure TFRutas.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);    // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  cargando:=1;
  dbRuta.Sql.Text:='SELECT * FROM rutas'+Tienda+' ORDER BY RUT0';
  dbRuta.Active := True;
  cargando:=0;
  if dbRuta.RecordCount<>0 then
  begin
    dbRuta.First;
    dbSubRuta1.Active:=False;
    dbSubRuta1.SQL.Text:='SELECT * FROM subrutas'+Tienda+
                        ' WHERE SRUT0='+dbRuta.FieldByName('RUT0').AsString+
                        ' ORDER BY SRUT1';
    dbSubRuta1.Active:=True;
  end;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Rutas', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Rutas', 3);//------------------ Boton Borrar
  BitBtn6.Enabled:=CheckRoles(dbRoles, CgRol, 'Rutas', 2);//------------------ Boton Modificar
  BitBtn11.Enabled:=CheckRoles(dbRoles, CgRol, 'Rutas', 3);//----------------- Boton Borrar
  FOrdenRutaCampo:='';
  FOrdenRutaAscendente:=True;
  FOrdenSubRutaCampo:='';
  FOrdenSubRutaAscendente:=True;
  AplicarEstiloModerno;
  CentrarPanelesEdicion;

end;

//==================== CERRAR ======================
Procedure TFRutas.Bitbtn1click(Sender: Tobject);
Begin
  dbRuta.Active:=False;
  Close();
End;
Procedure TFRutas.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//=================== CREAR RUTAS ===================
Procedure TFRutas.Bitbtn2click(Sender: Tobject);
Begin
  Panel2.Visible:=True;
  Panel2.BringToFront;
  Panel1.Enabled:=False; Panel3.Enabled:=False;
  DBGrid1.Enabled:=False;
  Edit1.Text:=''; LimpiaForm();
  Edit1.Enabled:=True; Edit1.SetFocus;
End;
//=================== BORRAR RUTAS ===================
Procedure TFRutas.Bitbtn3click(Sender: Tobject);
Begin
  if not dbRuta.Locate('RUT0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbRuta.Delete;
End;

//=================== MODIFICAR RUTAS ===================
Procedure TFRutas.Bitbtn4click(Sender: Tobject);
Begin
  Panel2.Visible:=True;
  Panel2.BringToFront;
  Panel1.Enabled:=False; Panel3.Enabled:=False;
  DBGrid1.Enabled:=False;
  LimpiaForm(); Relleno();
  Edit1.Enabled:=False; Edit2.SetFocus;
End;

//=================== CODIGO DE LA RUTA ================
Procedure TFRutas.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;
Procedure TFRutas.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbRuta.Locate('RUT0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;

//=============== ACEPTAR MODIFCAR / CREAR RUTAS ================
procedure TFRutas.BitBtn7Click(Sender: TObject);
begin
  //------------- Crear o Modificar Registros --------
  if Edit1.Enabled=true then
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if dbRuta.Locate('RUT0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO YA EXISTE'); exit; end;
     dbRuta.Append;
    end
  else
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if not dbRuta.Locate('RUT0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO'); exit; end;
     dbRuta.Edit;
    end;
  LlenaReg();//---- Rellenar datos
  dbRuta.Post;
  BitBtn8Click(BitBtn8);//--- Cerrar Panel
end;

//================= CERRAR CREAR / MODIFICAR RUTAS ==============
procedure TFRutas.BitBtn8Click(Sender: TObject);
begin
  Panel1.Enabled:=True; Panel3.Enabled:=True;
  Panel2.Visible:=False; Edit1.Enabled:=True;
  DBGrid1.Enabled:=True;
end;

//==================== AL CAMBIAR DE RUTA MOSTRAR SUB RUTA ================
procedure TFRutas.Datasource1DataChange(Sender: TObject; Field: TField);
begin
  if cargando=1 then exit;
  if dbRuta.FieldByName('RUT0').AsString='' then exit;
  dbSubRuta1.Active:=False;
  dbSubRuta1.SQL.Text:='SELECT * FROM subrutas'+Tienda+
                      ' WHERE SRUT0='+dbRuta.FieldByName('RUT0').AsString+
                      ' ORDER BY SRUT1';
  dbSubRuta1.Active:=True;
  FOrdenSubRutaCampo:='';
  FOrdenSubRutaAscendente:=True;
  ActualizarFlechasSubRuta;

end;

//===================== LIMPIAR DATOS RUTAS =======================
Procedure TFRutas.LimpiaForm();
Begin
  Edit2.Text:='';
End;

//===================== PINTAR DATOS RUTAS =======================
Procedure TFRutas.Relleno();
Begin
  if dbRuta.RecordCount=0 then exit;
  Edit1.Text:=dbRuta.FieldByName('RUT0').AsString;//-------------- Codigo
  Edit2.Text:=dbRuta.FieldByName('RUT1').AsString;//-------------- Nombre
End;

//===================== RELLENAR DATOS RUTAS =======================
Procedure TFRutas.LlenaReg();
Begin
  dbRuta.FieldByName('RUT0').AsString:=Edit1.Text;//------------- Codigo
  dbRuta.FieldByName('RUT1').AsString:=Edit2.Text;//------------- Nombre
End;

//====================================================================
//=========================== SUB RUTAS ==============================
//====================================================================

//========================= CREAR SUB RUTAS ==========================
procedure TFRutas.BitBtn5Click(Sender: TObject);
begin
  if dbRuta.RecordCount=0 then begin showmessage('PRIMERO DEBE CREAR UNA RUTA'); exit; end;
  if dbRuta.EOF then begin showmessage('PRIMERO DEBE SELECCIONAR UNA RUTA'); exit; end;
  Panel4.Visible:=True;
  Panel4.BringToFront;
  Panel1.Enabled:=False; Panel3.Enabled:=False;
  Panel3.Visible:=True;
  DBGrid1.Enabled:=False; DBGrid2.Enabled:=False;
  Edit3.Text:=''; LimpiaForm1();
  Edit3.Enabled:=True; Edit3.SetFocus;
end;

//========================= BORRAR SUB RUTAS ==========================
procedure TFRutas.BitBtn6Click(Sender: TObject);
begin
  dbSubRuta.Active:=False;
  dbSubRuta.SQL.Text:='SELECT * FROM subrutas'+Tienda+
                      ' WHERE SRUT0='+dbSubRuta1.FieldByName('SRUT0').AsString+
                      ' AND SRUT1='+dbSubRuta1.FieldByName('SRUT1').AsString+
                      ' ORDER BY SRUT1';
  dbSubRuta.Active:=True;
  if dbSubRuta.RecordCount=0 then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbSubRuta.Delete;
  RefrescaSubRuta1();
end;

//========================== MODIFICAR SUB RUTAS ======================
procedure TFRutas.BitBtn11Click(Sender: TObject);
begin
  if dbSubRuta1.RecordCount=0 then begin showmessage('PRIMERO DEBE CREAR UNA SUB RUTA'); exit; end;
  if dbSubRuta1.EOF then begin showmessage('PRIMERO DEBE SELECCIONAR UNA SUB RUTA'); exit; end;
  dbSubRuta.Active:=False;
  dbSubRuta.SQL.Text:='SELECT * FROM subrutas'+Tienda+
                      ' WHERE SRUT0='+dbSubRuta1.FieldByName('SRUT0').AsString+
                      ' AND SRUT1='+dbSubRuta1.FieldByName('SRUT1').AsString;
  dbSubRuta.Active:=True;
  if dbSubRuta.RecordCount=0 then exit;
  Panel4.Visible:=True;
  Panel4.BringToFront;
  Panel1.Enabled:=False; Panel3.Enabled:=False;
  Panel3.Visible:=True;
  DBGrid1.Enabled:=False; DBGrid2.Enabled:=False;
  Edit3.Text:=''; LimpiaForm1(); Relleno1();
  Edit3.Enabled:=False; Edit4.SetFocus;
end;

//=================== CODIGO DE LA SUB RUTA ================
procedure TFRutas.Edit3Enter(Sender: TObject);
begin
  Edit3.Text:='';
  LimpiaForm1();
end;
procedure TFRutas.Edit3Exit(Sender: TObject);
begin
  if Edit3.Text='' then exit;
  dbSubRuta.Active:=False;
  dbSubRuta.SQL.Text:='SELECT * FROM subrutas'+Tienda+
                      ' WHERE SRUT0='+dbRuta.FieldByName('RUT0').AsString+
                      ' AND SRUT1='+Edit3.Text+
                      ' ORDER BY SRUT1';
  dbSubRuta.Active:=True;
  if dbSubRuta.RecordCount<>0 then Relleno1() else LimpiaForm1();
end;

//=============== ACEPTAR MODIFCAR / CREAR SUB RUTAS ================
procedure TFRutas.BitBtn9Click(Sender: TObject);
begin
  //------------- Crear o Modificar Registros --------
  if Edit3.Enabled=true then
    begin
     if (Edit3.Text='') or (Edit4.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if dbSubRuta.RecordCount<>0 then
       begin ShowMessage('ESE REGISTRO YA EXISTE'); exit; end;
     dbSubRuta.Append;
    end
  else
    begin
     if (Edit3.Text='') or (Edit4.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if dbSubRuta.RecordCount=0 then
       begin ShowMessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO'); exit; end;
     dbSubRuta.Edit;
    end;
  LlenaReg1();//---- Rellenar datos
  dbSubRuta.Post;
  RefrescaSubRuta1();//-------- Resfrescar Panel Sub Rutas
  BitBtn10Click(BitBtn10);//--- Cerrar Panel
end;

//====================== CERRAR PANEL SUB RUTAS =======================
procedure TFRutas.BitBtn10Click(Sender: TObject);
begin
  Panel1.Enabled:=True; Panel3.Enabled:=True;
  Panel4.Visible:=False; Edit3.Enabled:=True;
  DBGrid1.Enabled:=True; DBGrid2.Enabled:=True;
end;

//===================== LIMPIAR DATOS SUB RUTAS =======================
Procedure TFRutas.LimpiaForm1();
Begin
  Edit4.Text:=''; Edit5.Text:=''; Edit6.Text:='';
  Edit7.Text:=''; Edit8.Text:=''; Edit9.Text:='';
End;

//===================== PINTAR DATOS SUB RUTAS =======================
Procedure TFRutas.Relleno1();
Begin
  if dbSubRuta.RecordCount=0 then exit;
  Edit3.Text:=dbSubRuta.FieldByName('SRUT1').AsString;//-------------- Codigo
  Edit4.Text:=dbSubRuta.FieldByName('SRUT2').AsString;//-------------- Nombre
  Edit5.Text:=dbSubRuta.FieldByName('SRUT3').AsString;//------------- Calle
  Edit6.Text:=dbSubRuta.FieldByName('SRUT4').AsString;//------------- Localidad
  Edit7.Text:=dbSubRuta.FieldByName('SRUT5').AsString;//------------- C. Postal
  Edit8.Text:=dbSubRuta.FieldByName('SRUT6').AsString;//------------- Provincia
  Edit9.Text:=dbSubRuta.FieldByName('SRUT7').AsString;//------------- Pais
End;

//===================== RELLENAR DATOS SUB RUTAS =======================
Procedure TFRutas.LlenaReg1();
Begin
  dbSubRuta.FieldByName('SRUT0').Value:=dbRuta.FieldByName('RUT0').Value;//---- Cgo. Ruta
  dbSubRuta.FieldByName('SRUT1').AsString:=Edit3.Text;//------------- Codigo sub ruta
  dbSubRuta.FieldByName('SRUT2').AsString:=Edit4.Text;//------------- Nombre
  dbSubRuta.FieldByName('SRUT3').AsString:=Edit5.Text;//------------- Calle
  dbSubRuta.FieldByName('SRUT4').AsString:=Edit6.Text;//------------- Localidad
  dbSubRuta.FieldByName('SRUT5').AsString:=Edit7.Text;//------------- C. Postal
  dbSubRuta.FieldByName('SRUT6').AsString:=Edit8.Text;//------------- Provincia
  dbSubRuta.FieldByName('SRUT7').AsString:=Edit9.Text;//------------- Pais
End;

//======================= REFRESCAR GRID SUB RUTAS ========================
Procedure TFRutas.RefrescaSubRuta1();
Var
  TxtTemp: String;
Begin
  TxtTemp:=dbSubRuta1.SQL.Text;
  dbSubRuta1.Active:=False;
  dbSubRuta1.SQL.Text:=TxtTemp;
  dbSubRuta1.Active:=True;
End;


procedure TFRutas.FormShow(Sender: TObject);
begin
  AplicarEstiloModerno;
  AplicarContrasteSeleccionControles(Self);
  CentrarPanelesEdicion;
end;

procedure TFRutas.FormResize(Sender: TObject);
begin
  CentrarPanelesEdicion;
end;

procedure TFRutas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key<>VK_ESCAPE then Exit;
  Key:=0;
  if Panel4.Visible then
    BitBtn10Click(BitBtn10)
  else if Panel2.Visible then
    BitBtn8Click(BitBtn8)
  else
    BitBtn1Click(BitBtn1);
end;

procedure TFRutas.AplicarEstiloModerno;
var
  I: Integer;
  Botones: array[0..10] of TBitBtn;
begin
  Color:=RGBToColor(244,247,251);
  Font.Name:='Sans';
  Font.Height:=-13;

  PanelCabecera.Caption:='';
  PanelCabecera.Color:=RGBToColor(31,78,121);
  PanelPie.Caption:='';
  PanelPie.Color:=RGBToColor(232,239,247);
  Panel1.Caption:='';
  Panel1.Color:=RGBToColor(239,245,251);
  Panel3.Caption:='';
  Panel3.Color:=RGBToColor(239,245,251);
  Panel2.Caption:='';
  Panel2.Color:=RGBToColor(247,250,253);
  Panel4.Caption:='';
  Panel4.Color:=RGBToColor(247,250,253);

  LabelTitulo.Font.Color:=clWhite;
  LabelSubtitulo.Font.Color:=RGBToColor(221,235,248);
  LabelPanelRuta.Font.Color:=RGBToColor(24,36,48);
  LabelPanelSubRuta.Font.Color:=RGBToColor(24,36,48);

  StaticText2.Color:=RGBToColor(218,230,242);
  StaticText3.Color:=RGBToColor(218,230,242);
  StaticText2.Font.Color:=RGBToColor(24,36,48);
  StaticText3.Font.Color:=RGBToColor(24,36,48);
  StaticText1.Color:=RGBToColor(218,230,242);
  StaticText1.Font.Color:=RGBToColor(24,36,48);

  DBGrid1.Color:=clWhite;
  DBGrid2.Color:=clWhite;
  DBGrid1.FixedColor:=RGBToColor(218,230,242);
  DBGrid2.FixedColor:=RGBToColor(218,230,242);
  DBGrid1.Font.Color:=RGBToColor(24,36,48);
  DBGrid2.Font.Color:=RGBToColor(24,36,48);
  DBGrid1.TitleFont.Color:=RGBToColor(24,36,48);
  DBGrid2.TitleFont.Color:=RGBToColor(24,36,48);
  DBGrid1.TitleFont.Style:=[fsBold];
  DBGrid2.TitleFont.Style:=[fsBold];

  for I:=0 to 8 do
    TEdit(FindComponent('Edit'+IntToStr(I+1))).Color:=clWhite;

  Botones[0]:=BitBtn1;
  Botones[1]:=BitBtn2;
  Botones[2]:=BitBtn3;
  Botones[3]:=BitBtn4;
  Botones[4]:=BitBtn5;
  Botones[5]:=BitBtn6;
  Botones[6]:=BitBtn7;
  Botones[7]:=BitBtn8;
  Botones[8]:=BitBtn9;
  Botones[9]:=BitBtn10;
  Botones[10]:=BitBtn11;
  for I:=Low(Botones) to High(Botones) do
  begin
    Botones[I].Font.Name:='Sans';
    Botones[I].Font.Height:=-13;
    Botones[I].Font.Style:=[fsBold];
    Botones[I].Font.Color:=RGBToColor(24,36,48);
    Botones[I].Visible:=True;
    Botones[I].BringToFront;
  end;

  BitBtn2.Color:=RGBToColor(215,236,224);
  BitBtn5.Color:=RGBToColor(215,236,224);
  BitBtn3.Color:=RGBToColor(249,221,221);
  BitBtn6.Color:=RGBToColor(249,221,221);
  BitBtn4.Color:=RGBToColor(219,234,248);
  BitBtn11.Color:=RGBToColor(219,234,248);
  BitBtn7.Color:=RGBToColor(207,235,218);
  BitBtn9.Color:=RGBToColor(207,235,218);
  BitBtn8.Color:=RGBToColor(229,233,238);
  BitBtn10.Color:=RGBToColor(229,233,238);
  BitBtn1.Color:=RGBToColor(229,233,238);
end;

procedure TFRutas.CentrarPanelesEdicion;
var
  L, T, ZonaTop, ZonaBottom: Integer;
begin
  ZonaTop:=PanelCabecera.Height;
  ZonaBottom:=PanelPie.Height;

  L:=(ClientWidth-Panel2.Width) div 2;
  if L<16 then L:=16;
  T:=ZonaTop+(ClientHeight-ZonaTop-ZonaBottom-Panel2.Height) div 2;
  if T<ZonaTop+16 then T:=ZonaTop+16;
  Panel2.Left:=L;
  Panel2.Top:=T;

  L:=(ClientWidth-Panel4.Width) div 2;
  if L<16 then L:=16;
  T:=ZonaTop+(ClientHeight-ZonaTop-ZonaBottom-Panel4.Height) div 2;
  if T<ZonaTop+16 then T:=ZonaTop+16;
  Panel4.Left:=L;
  Panel4.Top:=T;
end;

procedure TFRutas.AplicarContrasteSeleccion(AControl: TWinControl);
{$IFDEF LCLGTK2}
var
  FondoNormal, TextoNormal, FondoSeleccion, TextoSeleccion: TGdkColor;
  Widget: PGtkWidget;
{$ENDIF}
begin
  if not Assigned(AControl) then Exit;
  AControl.HandleNeeded;
  {$IFDEF LCLGTK2}
  Widget:=PGtkWidget(AControl.Handle);
  if Assigned(Widget) then
  begin
    gdk_color_parse(PChar('#FFFFFF'),@FondoNormal);
    gdk_color_parse(PChar('#182430'),@TextoNormal);
    gtk_widget_modify_base(Widget,GTK_STATE_NORMAL,@FondoNormal);
    gtk_widget_modify_text(Widget,GTK_STATE_NORMAL,@TextoNormal);
    gdk_color_parse(PChar('#2A5684'),@FondoSeleccion);
    gdk_color_parse(PChar('#FFFFFF'),@TextoSeleccion);
    gtk_widget_modify_base(Widget,GTK_STATE_SELECTED,@FondoSeleccion);
    gtk_widget_modify_text(Widget,GTK_STATE_SELECTED,@TextoSeleccion);
  end;
  {$ENDIF}
end;

procedure TFRutas.AplicarContrasteSeleccionControles(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I:=0 to AParent.ControlCount-1 do
  begin
    C:=AParent.Controls[I];
    if C is TCustomEdit then
      AplicarContrasteSeleccion(TWinControl(C));
    if C is TWinControl then
      AplicarContrasteSeleccionControles(TWinControl(C));
  end;
end;

procedure TFRutas.DibujarCeldaGrid(AGrid: TDBGrid; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if gdSelected in State then
  begin
    AGrid.Canvas.Brush.Color:=RGBToColor(42,86,132);
    AGrid.Canvas.Font.Color:=clWhite;
  end
  else
  begin
    AGrid.Canvas.Brush.Color:=clWhite;
    AGrid.Canvas.Font.Color:=RGBToColor(24,36,48);
  end;
  AGrid.Canvas.FillRect(Rect);
  AGrid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TFRutas.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  DibujarCeldaGrid(TDBGrid(Sender),Rect,DataCol,Column,State);
end;

procedure TFRutas.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  DibujarCeldaGrid(TDBGrid(Sender),Rect,DataCol,Column,State);
end;

function TFRutas.QuitarFlechaOrden(const ATexto: String): String;
var
  P: SizeInt;
begin
  Result:=ATexto;
  P:=Pos(' ▲',Result);
  if P>0 then Delete(Result,P,Length(Result)-P+1);
  P:=Pos(' ▼',Result);
  if P>0 then Delete(Result,P,Length(Result)-P+1);
end;

procedure TFRutas.OrdenarConsulta(AQuery: TZQuery; const ACampo: String;
  AAscendente: Boolean);
var
  SQLBase, Direccion: String;
  P: SizeInt;
begin
  if (AQuery=nil) or (ACampo='') or (not AQuery.Active) then Exit;
  SQLBase:=Trim(AQuery.SQL.Text);
  P:=Pos(' ORDER BY ',UpperCase(SQLBase));
  if P>0 then SQLBase:=Trim(Copy(SQLBase,1,P-1));
  if AAscendente then Direccion:=' ASC' else Direccion:=' DESC';

  AQuery.DisableControls;
  try
    AQuery.Close;
    AQuery.SQL.Text:=SQLBase+' ORDER BY '+ACampo+Direccion;
    AQuery.Open;
  finally
    AQuery.EnableControls;
  end;
end;

procedure TFRutas.ActualizarFlechasRuta;
var
  I: Integer;
  Base: String;
begin
  for I:=0 to DBGrid1.Columns.Count-1 do
  begin
    Base:=QuitarFlechaOrden(DBGrid1.Columns[I].Title.Caption);
    if SameText(DBGrid1.Columns[I].FieldName,FOrdenRutaCampo) then
    begin
      if FOrdenRutaAscendente then
        DBGrid1.Columns[I].Title.Caption:=Base+' ▲'
      else
        DBGrid1.Columns[I].Title.Caption:=Base+' ▼';
    end
    else
      DBGrid1.Columns[I].Title.Caption:=Base;
  end;
end;

procedure TFRutas.ActualizarFlechasSubRuta;
var
  I: Integer;
  Base: String;
begin
  for I:=0 to DBGrid2.Columns.Count-1 do
  begin
    Base:=QuitarFlechaOrden(DBGrid2.Columns[I].Title.Caption);
    if SameText(DBGrid2.Columns[I].FieldName,FOrdenSubRutaCampo) then
    begin
      if FOrdenSubRutaAscendente then
        DBGrid2.Columns[I].Title.Caption:=Base+' ▲'
      else
        DBGrid2.Columns[I].Title.Caption:=Base+' ▼';
    end
    else
      DBGrid2.Columns[I].Title.Caption:=Base;
  end;
end;

procedure TFRutas.DBGrid1TitleClick(Column: TColumn);
begin
  if (Column=nil) or (Column.FieldName='') or (not dbRuta.Active) then Exit;
  if SameText(FOrdenRutaCampo,Column.FieldName) then
    FOrdenRutaAscendente:=not FOrdenRutaAscendente
  else
  begin
    FOrdenRutaCampo:=Column.FieldName;
    FOrdenRutaAscendente:=True;
  end;
  OrdenarConsulta(dbRuta,FOrdenRutaCampo,FOrdenRutaAscendente);
  ActualizarFlechasRuta;
end;

procedure TFRutas.DBGrid2TitleClick(Column: TColumn);
begin
  if (Column=nil) or (Column.FieldName='') or (not dbSubRuta1.Active) then Exit;
  if SameText(FOrdenSubRutaCampo,Column.FieldName) then
    FOrdenSubRutaAscendente:=not FOrdenSubRutaAscendente
  else
  begin
    FOrdenSubRutaCampo:=Column.FieldName;
    FOrdenSubRutaAscendente:=True;
  end;
  OrdenarConsulta(dbSubRuta1,FOrdenSubRutaCampo,FOrdenSubRutaAscendente);
  ActualizarFlechasSubRuta;
end;


Initialization
  {$I rutas.lrs}

End.

