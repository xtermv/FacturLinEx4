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

Unit FormaPago;

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

  { TFFormaPago }

  TFFormaPago = Class(Tform)
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    Datasource1: TDatasource;
    dbFormaPa: TZQuery;
    dbRoles: TZQuery;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: Tpanel;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    Bitbtn4: Tbitbtn;
    Bitbtn1: Tbitbtn;
    Panel2: TPanel;
    PanelCabecera: TPanel;
    LabelTitulo: TLabel;
    LabelSubtitulo: TLabel;
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
        procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
Procedure Formcreate(Sender: Tobject);
    Procedure Edit1enter(Sender: Tobject);
    Procedure Edit1exit(Sender: Tobject);
    Procedure LimpiaForm();
    Procedure Relleno();
    Procedure LlenaReg();
    Procedure Bitbtn1click(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    Procedure Bitbtn4click(Sender: Tobject);
    Procedure Bitbtn2click(Sender: Tobject);
    Procedure Bitbtn3click(Sender: Tobject);
  private
    FOrdenCampo: String;
    FOrdenAscendente: Boolean;
    procedure AplicarEstiloModerno;
    procedure CentrarPanelEdicion;
    procedure AplicarContrasteSeleccion(AControl: TWinControl);
    procedure AplicarContrasteSeleccionControles(AParent: TWinControl);
    procedure OrdenarGrid(const ACampo: String; AAscendente: Boolean);
    procedure ActualizarFlechaOrden;
    function QuitarFlechaOrden(const ATexto: String): String;
  public
    { Public Declarations }
  End;

  procedure ShowFormFormaPago;
  
Var
  FFormaPago: TFFormaPago;
  CargaGrafica: Integer;
  s: TBarSeries;

Implementation

Uses
  Global, funciones;
  
//=============== Crea el formulario ================
procedure ShowFormFormaPago;
begin
  with TFFormaPago.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFFormaPago.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbFormaPa.Sql.Text:='SELECT * FROM formapago ORDER BY FPA0';
  dbFormaPa.Active := True;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Formapag', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Formapag', 3);//------------------ Boton Borrar

  FOrdenCampo:='';
  FOrdenAscendente:=True;
  AplicarEstiloModerno;
  CentrarPanelEdicion;

end;


//==================== CERRAR ======================
Procedure TFFormaPago.Bitbtn1click(Sender: Tobject);
Begin
  dbFormaPa.Active:=False;
  Close();
End;
Procedure TFFormaPago.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//=================== REGISTRO NUEVO ===================
Procedure TFFormaPago.Bitbtn2click(Sender: Tobject);
Begin
  Panel2.Visible:=True;
  Panel2.BringToFront;
  DBGrid1.Enabled:=False; Panel1.Enabled:=False;
  Edit1.Text:=''; LimpiaForm();
  Edit1.Enabled:=True; Edit1.SetFocus;
End;
//=================== BORRAR REGISTRO ===================
Procedure TFFormaPago.Bitbtn3click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if not dbFormaPa.Locate('FPA0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbFormaPa.Delete;
End;

//=================== MODIFICAR ===================
Procedure TFFormaPago.Bitbtn4click(Sender: Tobject);
Begin
  Panel2.Visible:=True;
  Panel2.BringToFront;
  DBGrid1.Enabled:=False; Panel1.Enabled:=False;
  LimpiaForm(); Relleno();
  Edit1.Enabled:=False; Edit2.SetFocus;
End;

//=================== CODIGO DE LA FP ================
Procedure TFFormaPago.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;
Procedure TFFormaPago.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbFormaPa.Locate('FPA0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;

//=============== ACEPTAR MODIFCAR / CREAR ================
procedure TFFormaPago.BitBtn7Click(Sender: TObject);
begin
  //------------- Crear o Modificar Registros --------
  if Edit1.Enabled=true then
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if dbFormaPa.Locate('FPA0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO YA EXISTE'); exit; end;
     dbFormaPa.Append;
    end
  else
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if not dbFormaPa.Locate('FPA0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO'); exit; end;
     dbFormaPa.Edit;
    end;
  LlenaReg();//---- Rellenar datos
  dbFormaPa.Post;
  BitBtn8Click(BitBtn8);//--- Cerrar Panel
end;

//================= CERRAR CREAR / MODIFICAR ==============
procedure TFFormaPago.BitBtn8Click(Sender: TObject);
begin
  Panel2.Visible:=False; Edit1.Enabled:=True;
  DBGrid1.Enabled:=True; Panel1.Enabled:=True;
  if DBGrid1.CanFocus then DBGrid1.SetFocus;
end;

//===================== LIMPIAR DATOS =======================
Procedure TFFormaPago.LimpiaForm();
Begin
  Edit2.Text:='';
End;

//===================== PINTAR DATOS =======================
Procedure TFFormaPago.Relleno();
Begin
  if dbFormaPa.RecordCount=0 then exit;
  Edit1.Text:=dbFormaPa.FieldByName('FPA0').AsString;//-------------- Cgo. forma pago
  Edit2.Text:=dbFormaPa.FieldByName('FPA1').AsString;//-------------- Nombre
End;

//===================== RELLENAR DATOS =======================
Procedure TFFormaPago.LlenaReg();
Begin
  dbFormaPa.FieldByName('FPA0').AsString:=Edit1.Text;//------------- Codigo
  dbFormaPa.FieldByName('FPA1').AsString:=Edit2.Text;//------------- Nombre
End;


procedure TFFormaPago.FormShow(Sender: TObject);
begin
  AplicarEstiloModerno;
  AplicarContrasteSeleccionControles(Self);
  CentrarPanelEdicion;
end;

procedure TFFormaPago.FormResize(Sender: TObject);
begin
  CentrarPanelEdicion;
end;

procedure TFFormaPago.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key<>VK_ESCAPE then Exit;
  Key:=0;
  if Panel2.Visible then
    BitBtn8Click(BitBtn8)
  else
    BitBtn1Click(BitBtn1);
end;

procedure TFFormaPago.AplicarEstiloModerno;
var
  I: Integer;
  Botones: array[0..5] of TBitBtn;
begin
  Color:=RGBToColor(244,247,251);
  Font.Name:='Sans';
  Font.Height:=-13;

  PanelCabecera.Caption:='';
  PanelCabecera.Color:=RGBToColor(31,78,121);
  Panel1.Caption:='';
  Panel1.Color:=RGBToColor(232,239,247);
  Panel2.Caption:='';
  Panel2.Color:=RGBToColor(247,250,253);

  LabelTitulo.Font.Color:=clWhite;
  LabelSubtitulo.Font.Color:=RGBToColor(221,235,248);
  Label1.Font.Color:=RGBToColor(24,36,48);
  Label2.Font.Color:=RGBToColor(24,36,48);

  DBGrid1.Color:=clWhite;
  DBGrid1.FixedColor:=RGBToColor(218,230,242);
  DBGrid1.Font.Color:=RGBToColor(24,36,48);
  DBGrid1.TitleFont.Color:=RGBToColor(24,36,48);
  DBGrid1.TitleFont.Style:=[fsBold];

  Edit1.Color:=clWhite;
  Edit2.Color:=clWhite;
  Edit1.Font.Color:=RGBToColor(24,36,48);
  Edit2.Font.Color:=RGBToColor(24,36,48);

  Botones[0]:=BitBtn2;
  Botones[1]:=BitBtn3;
  Botones[2]:=BitBtn4;
  Botones[3]:=BitBtn1;
  Botones[4]:=BitBtn7;
  Botones[5]:=BitBtn8;
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
  BitBtn3.Color:=RGBToColor(249,221,221);
  BitBtn4.Color:=RGBToColor(219,234,248);
  BitBtn1.Color:=RGBToColor(229,233,238);
  BitBtn7.Color:=RGBToColor(207,235,218);
  BitBtn8.Color:=RGBToColor(229,233,238);
end;

procedure TFFormaPago.CentrarPanelEdicion;
var
  ZonaSuperior, ZonaInferior: Integer;
begin
  if not Assigned(Panel2) then Exit;
  ZonaSuperior:=PanelCabecera.Height;
  ZonaInferior:=Panel1.Height;
  Panel2.Left:=(ClientWidth-Panel2.Width) div 2;
  if Panel2.Left<16 then Panel2.Left:=16;
  Panel2.Top:=ZonaSuperior+
    (ClientHeight-ZonaSuperior-ZonaInferior-Panel2.Height) div 2;
  if Panel2.Top<ZonaSuperior+16 then Panel2.Top:=ZonaSuperior+16;
end;

procedure TFFormaPago.AplicarContrasteSeleccion(AControl: TWinControl);
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

procedure TFFormaPago.AplicarContrasteSeleccionControles(AParent: TWinControl);
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

procedure TFFormaPago.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Grid: TDBGrid;
begin
  Grid:=TDBGrid(Sender);
  if gdSelected in State then
  begin
    Grid.Canvas.Brush.Color:=RGBToColor(42,86,132);
    Grid.Canvas.Font.Color:=clWhite;
  end
  else
  begin
    Grid.Canvas.Brush.Color:=clWhite;
    Grid.Canvas.Font.Color:=RGBToColor(24,36,48);
  end;
  Grid.Canvas.FillRect(Rect);
  Grid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

function TFFormaPago.QuitarFlechaOrden(const ATexto: String): String;
var
  P: SizeInt;
begin
  Result:=ATexto;
  P:=Pos(' ▲',Result);
  if P>0 then Delete(Result,P,Length(Result)-P+1);
  P:=Pos(' ▼',Result);
  if P>0 then Delete(Result,P,Length(Result)-P+1);
end;

procedure TFFormaPago.ActualizarFlechaOrden;
var
  I: Integer;
  Base: String;
begin
  for I:=0 to DBGrid1.Columns.Count-1 do
  begin
    Base:=QuitarFlechaOrden(DBGrid1.Columns[I].Title.Caption);
    if SameText(DBGrid1.Columns[I].FieldName,FOrdenCampo) then
    begin
      if FOrdenAscendente then
        DBGrid1.Columns[I].Title.Caption:=Base+' ▲'
      else
        DBGrid1.Columns[I].Title.Caption:=Base+' ▼';
    end
    else
      DBGrid1.Columns[I].Title.Caption:=Base;
  end;
end;

procedure TFFormaPago.OrdenarGrid(const ACampo: String;
  AAscendente: Boolean);
var
  SQLBase, Direccion: String;
  P: SizeInt;
begin
  if (ACampo='') or (not dbFormaPa.Active) then Exit;
  SQLBase:=Trim(dbFormaPa.SQL.Text);
  P:=Pos(' ORDER BY ',UpperCase(SQLBase));
  if P>0 then SQLBase:=Trim(Copy(SQLBase,1,P-1));
  if AAscendente then Direccion:=' ASC' else Direccion:=' DESC';

  dbFormaPa.DisableControls;
  try
    dbFormaPa.Close;
    dbFormaPa.SQL.Text:=SQLBase+' ORDER BY '+ACampo+Direccion;
    dbFormaPa.Open;
  finally
    dbFormaPa.EnableControls;
  end;
end;

procedure TFFormaPago.DBGrid1TitleClick(Column: TColumn);
begin
  if (Column=nil) or (Column.FieldName='') or (not dbFormaPa.Active) then Exit;
  if SameText(FOrdenCampo,Column.FieldName) then
    FOrdenAscendente:=not FOrdenAscendente
  else
  begin
    FOrdenCampo:=Column.FieldName;
    FOrdenAscendente:=True;
  end;
  OrdenarGrid(FOrdenCampo,FOrdenAscendente);
  ActualizarFlechaOrden;
end;


Initialization
  {$I formapago.lrs}

End.

