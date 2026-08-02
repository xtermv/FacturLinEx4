{
  Gestion LinEx FacturLinEx 2.0

  Copyright (C) 2000-2009,  Nicolas Lopez de Lerma Aymerich

  PuntoDev GNU S.L. <info@puntodev.com>

  Collaborators:
                 José Belenguer
                 Xaime Alvarez Ares
                 Elmo Calatayud Chumbes
                 Javier Perez

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

unit EtiLineales;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, EditBtn, DBGrids, LR_Class,
  LR_DBSet, ZConnection, ZDataset, LCLType;

type

  { TFEtiLineal }

  TFEtiLineal = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn9: TBitBtn;
    Combo1: TComboBox;
    Datasource1: TDatasource;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    dbCambios: TZQuery;
    dbImpre: TZQuery;
    dbArtitien: TZQuery;
    dbBusca: TZQuery;
    dbTrabajo: TZQuery;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure Combo1Exit(Sender: TObject);
    procedure Combo1KeyPress(Sender: TObject; var Key: char);
    procedure dbCambiosAfterRefresh(DataSet: TDataSet);
    procedure Edit7Enter(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
    procedure Edit7KeyPress(Sender: TObject; var Key: char);
    procedure Edit8KeyPress(Sender: TObject; var Key: char);
    procedure LimpiaReg();
    procedure LlenaReg();
    procedure CargaReg();
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure TabSheet1Hide(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);

  private
    procedure AplicarEstiloModerno;
    { private declarations }
  public
    { public declarations }
  end; 

  procedure ShowFormEtiLineal;

var
  FEtiLineal: TFEtiLineal;

implementation

{ TFEtiLineal }

uses
Busquedas, Global, Funciones;

//=============== CREAR EL FORMULARIO ================
procedure ShowFormEtiLineal;
begin
  with TFEtiLineal.Create(Application) do
    begin
       ShowModal;
    end;
end;

procedure TFEtiLineal.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dbCambios.Active:=False;
  dbArtitien.Active:=False;
  dbBusca.Active:=False;
  dbImpre.Active:=False;
  dbBusca.Active:=False;
  dbTrabajo.Active:=False;
  DBGrid1.Destroy;
  DataSource1.Destroy;
  CloseAction:=CaFree;
end;

procedure TFEtiLineal.FormCreate(Sender: TObject);
begin
  //Conectate(dbConect);  // Utilizamos datamodule1.dbConexión para toda la aplicación.
  dbCambios.Sql.Text:='SELECT * FROM cambios ORDER BY CA0';
  dbCambios.Active := True;
  if dbCambios.RecordCount>0 then Begin BitBtn9.Enabled:=True; BitBtn11.Enabled:=True end Else Begin BitBtn9.Enabled:=False; BitBtn11.Enabled:=False; end;
  PageControl1.ActivePage:=TabSheet1;
  LimpiaReg();
  AplicarEstiloModerno();
end;


procedure TFEtiLineal.AplicarEstiloModerno;
var
  LTitulo, LSubtitulo, LAyuda: TLabel;
  GBGenerar, GBPreparar: TGroupBox;
  X: Integer;
begin
  Caption := 'Etiquetas de lineal';
  Position := poScreenCenter;
  WindowState := wsMaximized;
  Color := $00F4F6F8;
  Constraints.MinWidth := 1020;
  Constraints.MinHeight := 680;

  { Cabecera y acciones de impresión }
  Panel2.Align := alTop;
  Panel2.Height := 94;
  Panel2.BevelOuter := bvNone;
  Panel2.Color := clNavy;

  LTitulo := TLabel.Create(Self);
  LTitulo.Parent := Panel2;
  LTitulo.SetBounds(22, 12, 390, 30);
  LTitulo.Caption := 'GESTIÓN DE ETIQUETAS DE LINEAL';
  LTitulo.ParentFont := False;
  LTitulo.Font.Name := 'Sans';
  LTitulo.Font.Height := -19;
  LTitulo.Font.Style := [fsBold];
  LTitulo.Font.Color := clWhite;

  LSubtitulo := TLabel.Create(Self);
  LSubtitulo.Parent := Panel2;
  LSubtitulo.SetBounds(23, 47, 420, 22);
  LSubtitulo.Caption := 'Genere, prepare, revise e imprima las etiquetas del establecimiento.';
  LSubtitulo.ParentFont := False;
  LSubtitulo.Font.Name := 'Sans';
  LSubtitulo.Font.Height := -12;
  LSubtitulo.Font.Color := clSilver;

  RadioGroup2.Parent := Panel2;
  RadioGroup2.SetBounds(430, 9, 190, 76);
  RadioGroup2.Anchors := [akTop, akRight];
  RadioGroup2.Color := clWhite;
  RadioGroup2.ParentFont := False;
  RadioGroup2.Font.Height := -12;

  X := Panel2.ClientWidth - 374;
  BitBtn9.SetBounds(X, 20, 112, 54);
  BitBtn9.Anchors := [akTop, akRight];
  BitBtn9.Layout := blGlyphLeft;
  BitBtn10.SetBounds(X + 120, 20, 112, 54);
  BitBtn10.Anchors := [akTop, akRight];
  BitBtn10.Layout := blGlyphLeft;
  BitBtn11.SetBounds(X + 240, 20, 112, 54);
  BitBtn11.Anchors := [akTop, akRight];
  BitBtn11.Layout := blGlyphLeft;

  { Área central }
  PageControl1.Align := alClient;
  PageControl1.BorderSpacing.Around := 12;
  PageControl1.ParentFont := False;
  PageControl1.Font.Name := 'Sans';
  PageControl1.Font.Height := -13;
  TabSheet1.Color := clWhite;
  TabSheet2.Color := clWhite;
  TabSheet3.Color := clWhite;

  GBGenerar := TGroupBox.Create(Self);
  GBGenerar.Parent := TabSheet1;
  GBGenerar.SetBounds(18, 18, 710, 286);
  GBGenerar.Caption := ' FILTROS PARA GENERAR ETIQUETAS ';
  GBGenerar.ParentFont := False;
  GBGenerar.Font.Name := 'Sans';
  GBGenerar.Font.Height := -13;
  GBGenerar.Font.Style := [fsBold];
  GBGenerar.Color := clWhite;

  Label1.Parent := GBGenerar; Edit1.Parent := GBGenerar; BitBtn13.Parent := GBGenerar;
  Label2.Parent := GBGenerar; Edit2.Parent := GBGenerar; BitBtn14.Parent := GBGenerar;
  Label3.Parent := GBGenerar; Edit3.Parent := GBGenerar; Edit4.Parent := GBGenerar; BitBtn15.Parent := GBGenerar;
  Label4.Parent := GBGenerar; Edit5.Parent := GBGenerar; Edit6.Parent := GBGenerar; BitBtn16.Parent := GBGenerar;
  Label5.Parent := GBGenerar; DateEdit1.Parent := GBGenerar;
  Label6.Parent := GBGenerar; DateEdit2.Parent := GBGenerar;

  Label1.SetBounds(18, 38, 112, 22); Edit1.SetBounds(138, 32, 168, 31); BitBtn13.SetBounds(312, 32, 32, 31);
  Label2.SetBounds(365, 38, 112, 22); Edit2.SetBounds(482, 32, 168, 31); BitBtn14.SetBounds(656, 32, 32, 31);
  Label3.SetBounds(18, 94, 112, 22); Edit3.SetBounds(138, 88, 82, 31); BitBtn15.SetBounds(226, 88, 32, 31); Edit4.SetBounds(264, 88, 424, 31);
  Label4.SetBounds(18, 150, 112, 22); Edit5.SetBounds(138, 144, 82, 31); BitBtn16.SetBounds(226, 144, 32, 31); Edit6.SetBounds(264, 144, 424, 31);
  Label5.SetBounds(18, 206, 118, 22); DateEdit1.SetBounds(138, 200, 130, 31);
  Label6.SetBounds(340, 206, 118, 22); DateEdit2.SetBounds(462, 200, 130, 31);

  RadioGroup1.Parent := TabSheet1;
  RadioGroup1.SetBounds(TabSheet1.ClientWidth - 246, 18, 220, 112);
  RadioGroup1.Anchors := [akTop, akRight];
  RadioGroup1.Color := clWhite;
  RadioGroup1.ParentFont := False;
  RadioGroup1.Font.Height := -13;

  LAyuda := TLabel.Create(Self);
  LAyuda.Parent := TabSheet1;
  LAyuda.SetBounds(TabSheet1.ClientWidth - 242, 148, 214, 90);
  LAyuda.Anchors := [akTop, akRight];
  LAyuda.AutoSize := False;
  LAyuda.WordWrap := True;
  LAyuda.Caption := 'Seleccione el origen de los códigos y complete únicamente los filtros que necesite.';
  LAyuda.ParentFont := False;
  LAyuda.Font.Name := 'Sans';
  LAyuda.Font.Height := -12;
  LAyuda.Font.Color := $00606060;

  GBPreparar := TGroupBox.Create(Self);
  GBPreparar.Parent := TabSheet2;
  GBPreparar.SetBounds(20, 20, 760, 284);
  GBPreparar.Caption := ' DATOS DE LA ETIQUETA ';
  GBPreparar.ParentFont := False;
  GBPreparar.Font.Name := 'Sans';
  GBPreparar.Font.Height := -13;
  GBPreparar.Font.Style := [fsBold];
  GBPreparar.Color := clWhite;

  Label7.Parent := GBPreparar; Edit7.Parent := GBPreparar;
  Label8.Parent := GBPreparar; Combo1.Parent := GBPreparar; Edit8.Parent := GBPreparar;
  Label9.Parent := GBPreparar; Edit9.Parent := GBPreparar;
  Label7.SetBounds(22, 46, 120, 22); Edit7.SetBounds(154, 40, 190, 31);
  Label8.SetBounds(22, 108, 120, 22); Combo1.SetBounds(154, 102, 560, 31); Edit8.SetBounds(154, 102, 560, 31);
  Label9.SetBounds(22, 170, 120, 22); Edit9.SetBounds(154, 164, 160, 31);

  DBGrid1.Align := alClient;
  DBGrid1.BorderSpacing.Around := 12;
  DBGrid1.Color := clWhite;
  DBGrid1.ParentFont := False;
  DBGrid1.Font.Name := 'Sans';
  DBGrid1.Font.Height := -13;

  { Barra inferior de mantenimiento y navegación }
  Panel1.Align := alBottom;
  Panel1.Height := 74;
  Panel1.BevelOuter := bvNone;
  Panel1.Color := clWhite;

  BitBtn1.SetBounds(12, 10, 112, 52); BitBtn1.Layout := blGlyphLeft;
  BitBtn2.SetBounds(132, 10, 112, 52); BitBtn2.Layout := blGlyphLeft;
  BitBtn3.SetBounds(252, 10, 112, 52); BitBtn3.Layout := blGlyphLeft;
  BitBtn4.SetBounds(372, 10, 112, 52); BitBtn4.Caption := 'Refrescar'; BitBtn4.Layout := blGlyphLeft;
  BitBtn5.SetBounds(492, 10, 112, 52); BitBtn5.Layout := blGlyphLeft;
  BitBtn6.SetBounds(612, 10, 112, 52); BitBtn6.Layout := blGlyphLeft;
  BitBtn7.SetBounds(732, 10, 112, 52); BitBtn7.Layout := blGlyphLeft;
  BitBtn8.SetBounds(Panel1.ClientWidth - 124, 10, 112, 52);
  BitBtn8.Anchors := [akTop, akRight];
  BitBtn8.Layout := blGlyphLeft;
end;

procedure TFEtiLineal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then
    Exit;

  { El selector de descripciones es el nivel interior más inmediato. ESC lo
    cancela sin aplicar el elemento que estuviera seleccionado. }
  if (PageControl1.ActivePage = TabSheet2) and Combo1.Visible and
     Combo1.Focused then
  begin
    Combo1.OnExit := nil;
    try
      Combo1.Visible := False;
      dbBusca.Active := False;
      if Edit8.CanFocus then
        Edit8.SetFocus;
    finally
      Combo1.OnExit := @Combo1Exit;
    end;
    Key := 0;
    Exit;
  end;

  { Preparar y Verificar son pantallas interiores. ESC vuelve a Generar. }
  if PageControl1.ActivePage <> TabSheet1 then
  begin
    PageControl1.ActivePage := TabSheet1;
    if Edit1.CanFocus then
      Edit1.SetFocus;
    Key := 0;
    Exit;
  end;

  { En la pantalla principal, ESC ejecuta exactamente el botón Cerrar. }
  Key := 0;
  BitBtn8Click(BitBtn8);
end;

procedure TFEtiLineal.BitBtn1Click(Sender: TObject);
begin
   if (Edit7.Text='') then Exit;
   dbTrabajo.Active:=False; dbTrabajo.Sql.Text:='SELECT * FROM cambios WHERE CA0="'+Edit7.Text+'"';
   dbTrabajo.Active:=True;
   if dbTrabajo.RecordCount<>0 then begin Showmessage('Codigo Ya Existe, para Editarlo use Boton Modificar'); exit; end;
   dbCambios.Append; LlenaReg(); dbCambios.Post;
   CargaReg();
end;

procedure TFEtiLineal.TabSheet1Hide(Sender: TObject);
begin
  // BitBtn9.Enabled:=False;
  BitBtn1.Enabled:=True; BitBtn2.Enabled:=True ;BitBtn3.Enabled:=True;
  BitBtn4.Enabled:=True; BitBtn5.Enabled:=True ;BitBtn6.Enabled:=True;
  BitBtn7.Enabled:=True;
end;

procedure TFEtiLineal.TabSheet1Show(Sender: TObject);
begin
  if dbCambios.RecordCount>0 then Begin BitBtn9.Enabled:=True; BitBtn11.Enabled:=True end Else Begin BitBtn9.Enabled:=False; BitBtn11.Enabled:=False; end;
  BitBtn1.Enabled:=False; BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  BitBtn4.Enabled:=False; BitBtn5.Enabled:=False; BitBtn6.Enabled:=False;
  BitBtn7.Enabled:=False;
end;

procedure TFEtiLineal.TabSheet2Show(Sender: TObject);
begin
  if dbCambios.RecordCount>0 then Begin CargaReg(); BitBtn9.Enabled:=True; end Else BitBtn9.Enabled:=False; // LimpiaReg();
  BitBtn1.Enabled:=True; BitBtn2.Enabled:=True ;BitBtn3.Enabled:=True;
  BitBtn4.Enabled:=True; BitBtn5.Enabled:=True ;BitBtn6.Enabled:=True;
  BitBtn7.Enabled:=True;
end;

procedure TFEtiLineal.TabSheet3Show(Sender: TObject);
begin
  dbCambios.Refresh;
  DataSource1.Dataset:= dbCambios;
  dbGrid1.DataSource := DataSource1;
  if dbCambios.RecordCount>0 Then BitBtn3.Enabled;
  BitBtn1.Enabled:=False; BitBtn2.Enabled:=False; BitBtn4.Enabled:=False;
  BitBtn5.Enabled:=False; BitBtn6.Enabled:=False; BitBtn7.Enabled:=False;
end;

procedure TFEtiLineal.LimpiaReg();
begin
  Edit8.Text := ''; Edit9.Text := '0';
  Edit1.Text := '000000000000'; Edit2.Text := 'ZZZZZZZZZZZZ';
  Edit3.Text := ''; Edit4.Text := '';
  Edit5.Text := ''; Edit6.Text := '';
  DateEdit1.Text := '01/' + FormatDateTime('MM/YYYY',Date);
  DateEdit2.Text := '31/12/' + FormatDateTime('YYYY',Date);
end;

procedure TFEtiLineal.BitBtn2Click(Sender: TObject);
begin
   if Edit7.Text='' then exit;
   if dbCambios.RecordCount=0 then exit;
   if Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx2', MB_OKCANCEL+MB_ICONINFORMATION ) = ID_CANCEL Then Exit;
   dbCambios.Edit; LlenaReg(); dbCambios.Post;
   CargaReg();
end;

procedure TFEtiLineal.BitBtn10Click(Sender: TObject);
var
  TxtQuery: String;
begin
  if RadioGroup1.ItemIndex = 0 Then
     begin
        TxtQuery:='SELECT A0,A1,A2,A4 FROM artitien'+Tienda+' WHERE A0>="'+Edit1.Text+'" AND A0<="'+Edit2.Text+'" ';
        if Trim(Edit3.Text)<>'' then TxtQuery:=TxtQuery+'AND A14='+Edit3.Text+' ';
        if Trim(Edit5.Text)<>'' then TxtQuery:=TxtQuery+'AND A35='+Edit5.Text+' ';
        if trim(DateEdit1.Text)<>'' then TxtQuery:=TxtQuery+'AND A13>="'+FormatDateTime('yy/mm/dd',StrToDate(DateEdit1.Text))+'"';
        if trim(DateEdit2.Text)<>'' then TxtQuery:=TxtQuery+' AND A13<="'+FormatDateTime('yy/mm/dd',StrToDate(DateEdit2.Text))+'"';
        // ShowMessage(TxtQuery);
     end
  else
     Begin
        TxtQuery:='SELECT a.EAN0 AS A0,a.EAN2 AS A1, b.A2, a.EAN3 AS A4 FROM eans a, artitien'+Tienda+' b WHERE a.EAN1=b.A0 AND a.EAN1>="'+Edit1.Text+'" AND a.EAN1<="'+Edit2.Text+'" ';
     end;

  dbArtitien.Active:=False;
  dbArtitien.Sql.Text:=TxtQuery;
  dbArtitien.Active:=True;
  if dbArtitien.RecordCount=0 then begin Showmessage('CON ESTA SELECCION NO ENCUENTRO ARTICULOS.'); exit; end;
  if Application.MessageBox(PChar('SE VAN A GENERAR '+IntToStr(dbArtitien.RecordCount)+' ARTICULOS, CONTINUAMOS?'),'FacturLinEx2',  MB_OKCANCEL+MB_ICONQUESTION+MB_DEFBUTTON1  ) = ID_CANCEL   Then Exit;
  dbArtitien.First;
  Screen.Cursor := crHourGlass;
  while not dbArtitien.Eof do
    begin
     dbBusca.Active:=False;
     dbBusca.SQL.Text:='SELECT * FROM cambios WHERE CA0="'+dbArtitien.Fields[0].AsString+'"';
     dbBusca.Active:=true; dbBusca.First;
     if dbBusca.RecordCount=0 then dbCambios.Append else dbCambios.Edit;
     dbCambios.Fields[0].Value:=dbArtitien.Fields[0].Value;
     dbCambios.Fields[1].Value:=dbArtitien.Fields[1].Value;
     dbCambios.Fields[2].Value:=dbArtitien.Fields[2].Value;
     dbCambios.Post;
     dbArtitien.Next;
    end;
  dbBusca.Active:=False;
  Screen.Cursor := crDefault;
  Showmessage('LA GENERACION HA TERMINADO CORRECTAMENTE.');
  dbCambios.Refresh;
  dbCambios.First;
end;

procedure TFEtiLineal.BitBtn11Click(Sender: TObject);
begin
  if dbCambios.RecordCount=0 then begin Showmessage('NO HAY ETIQUETAS PARA BORRAR'); exit; end;
  if Application.MessageBox('SE VAN A BORRAR TODAS LAS ETIQUETAS LINEALES, CONTINUAMOS?','FacturLinEx2', MB_OKCANCEL+MB_ICONQUESTION ) = ID_CANCEL  Then Exit;
  Screen.Cursor := crHourGlass;
  dbCambios.First;
  while not dbCambios.Eof do
    begin
    dbCambios.Delete;
    dbCambios.First;
  end;
  Screen.Cursor := crDefault;
  Showmessage('EL BORRADO DE ETIQUETAS HA TERMINADO CORRECTAMENTE.');
  dbCambios.Refresh;
end;

procedure TFEtiLineal.BitBtn13Click(Sender: TObject);
begin
  if Edit1.Text='' then begin ShowMessage('DEBE INGRESAR EL COMIENZO DEL TEXTO A BUSCAR'); end;
  try
  if Edit1.Text='' then begin
    Edit1.Text := FBusquedas.IniciaBusquedas('SELECT A0, A1 FROM artitien'+Tienda+' ORDER BY A1',
                                           ['Codigo', 'Descripcion' ], 'A0' );
    end
    Else
    Edit1.Text := FBusquedas.IniciaBusquedas('SELECT A0, A1 FROM artitien'+Tienda+' WHERE A0 >="'+Edit1.Text+'" ORDER BY A1',
                                           ['Codigo', 'Descripcion' ], 'A0' );
  except
        Edit1.Text := '';
        ShowMessage('No selecciono ningún Dato!');
  end;
end;

procedure TFEtiLineal.BitBtn14Click(Sender: TObject);
begin
  if Edit2.Text='' then begin ShowMessage('DEBE INGRESAR EL COMIENZO DEL TEXTO A BUSCAR'); end;
  try
  if Edit2.Text='' then begin
    Edit2.Text := FBusquedas.IniciaBusquedas('SELECT A0, A1 FROM artitien'+Tienda+' ORDER BY A1',
                                           ['Codigo', 'Descripcion' ], 'A0' );
    end
    Else
    Edit2.Text := FBusquedas.IniciaBusquedas('SELECT A0, A1 FROM artitien'+Tienda+' WHERE A0 >="'+Edit1.Text+'" ORDER BY A1',
                                           ['Codigo', 'Descripcion' ], 'A0' );
  except
        Edit3.Text := '';
        ShowMessage('No selecciono ningún Dato!');
  end;
end;

procedure TFEtiLineal.BitBtn15Click(Sender: TObject);
begin
  if Edit3.Text='' then begin ShowMessage('DEBE INGRESAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit3.Text:='0'; end;
  try
  if Edit4.Text='' then begin
     Edit3.Text := FBusquedas.IniciaBusquedas('SELECT F0, F1 FROM familias'+Tienda+
                                           ' WHERE F0 >="'+Edit3.Text+'" ORDER BY F1',
                                           ['Familia', 'Descripcion' ], 'F0' );
    end
    Else
     Edit3.Text := FBusquedas.IniciaBusquedas('SELECT F0, F1 FROM familias'+Tienda+
                                           ' WHERE F1 >="'+Edit4.Text+'" ORDER BY F1',
                                           ['Familia', 'Descripcion' ], 'F0' );
  except
        Edit3.Text := '';
        ShowMessage('No selecciono ningún Dato!');
  end;
end;

procedure TFEtiLineal.BitBtn16Click(Sender: TObject);
begin
  if Edit5.Text='' then begin ShowMessage('DEBE INGRESAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit5.Text:='0'; end;
  try
  if Edit6.Text='' then begin
     Edit5.Text := FBusquedas.IniciaBusquedas('SELECT P0, P1 FROM proveedores ORDER BY P1',
                                           ['Proveedor', 'Nombre' ], 'P0' );
     end
    Else
     Edit5.Text := FBusquedas.IniciaBusquedas('SELECT P0, P1 FROM proveedores WHERE P0>='+Edit5.Text+' ORDER BY P1',
                                           ['Proveedor', 'Nombre' ], 'P0' );
    except
        Edit5.Text := '';
        ShowMessage('No selecciono ningún Dato!');
  end;

end;

procedure TFEtiLineal.BitBtn3Click(Sender: TObject);
begin
  if TabSheet3.Showing then CargaReg();
  if Edit7.Text='' then begin ShowMessage('No Digito un Codigo de Registro para Borrar'); exit; end;
  if Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx2', MB_OKCANCEL+MB_ICONINFORMATION ) = ID_CANCEL Then Exit;
  dbTrabajo.Active:=False;
  dbTrabajo.Sql.Text:='DELETE FROM cambios WHERE CA0="'+Edit7.Text+'"';
  dbTrabajo.ExecSQL;
  dbCambios.Refresh;
  if (dbCambios.RecordCount>0) then CargaReg() else LimpiaReg();
  if TabSheet3.Showing then DBGrid1.Refresh;
end;

procedure TFEtiLineal.BitBtn4Click(Sender: TObject);
begin
   if Edit7.Text='' then exit;
   dbCambios.Locate('CA0', Edit7.Text, [loCaseInsensitive]);
   if not dbCambios.Eof then
    begin
     CargaReg();
    end
   else
    begin
     LimpiaReg();
    end;
end;

procedure TFEtiLineal.BitBtn5Click(Sender: TObject);
begin
  if not dbCambios.Bof then
     begin
       dbCambios.Prior;
       CargaReg();
    end
end;

procedure TFEtiLineal.BitBtn6Click(Sender: TObject);
begin
  if not dbCambios.Eof then
     begin
       dbCambios.Next;
       CargaReg();
    end
end;

procedure TFEtiLineal.BitBtn7Click(Sender: TObject);
begin
 if not TabSheet2.Showing then exit;
 if Edit8.Text='' then
   begin
     Showmessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR [*]=TODOS');
     Edit8.SetFocus;
     exit;
   end;
 Combo1.Clear;
 if trim(Edit2.Text)='*' then
  dbBusca.SQL.Text:='SELECT CA1,CA0 FROM cambios'
 else
  dbBusca.SQL.Text:='SELECT CA1,CA0 FROM cambios WHERE CA1 LIKE "%'+Edit8.Text+'%"';
  dbBusca.Active:=True;
 if dbBusca.RecordCount=0 then
   begin
    Showmessage('NO ENCONTRE NINGUN REGISTRO CON ESE TEXTO');
    dbBusca.Active:=False;
    Edit8.SetFocus;
    exit;
   end;
 dbBusca.First;
 while not dbBusca.Eof do
   begin
     Combo1.Items.Add(dbBusca.Fields[0].AsString);
     dbBusca.Next;
   end;
 Combo1.Visible:=True;
 Combo1.ItemIndex:=0;
 Combo1.SetFocus;
end;

procedure TFEtiLineal.BitBtn8Click(Sender: TObject);
begin
  Close();
end;

procedure TFEtiLineal.BitBtn9Click(Sender: TObject);
begin
  if (dbCambios.RecordCount=0) then begin Showmessage('NO HAY ETIQUETAS PARA IMPRIMIR'); exit; end;
  dbImpre.Active:=False; dbImpre.Sql.Text:='SELECT * FROM cambios'; dbImpre.Active:=True;
  frDBDataSet1.DataSet:=dbImpre;
  frReport1.Title:='Etiquetas de lineales';
  if RadioGroup2.ItemIndex = 0 Then frReport1.LoadFromFile(RutaReports+'EtiCambios.lrf')
   else frReport1.LoadFromFile(RutaReports+'EtiCambios3.lrf');

  frReport1.ShowReport;
end;

procedure TFEtiLineal.Combo1Exit(Sender: TObject);
begin
  dbBusca.SQL.Clear;
  dbBusca.SQL.Text:='SELECT CA1,CA0,CA2 FROM cambios WHERE CA1="'+Combo1.Text+'"';
  dbBusca.Active:=True; dbBusca.First;
  If dbBusca.RecordCount > 0 then
     begin
       Edit7.Text:=dbBusca.Fields[1].AsString;
       Edit8.Text:=dbBusca.Fields[0].AsString;
       Edit9.Text := FormatFloat('0.00',dbBusca.Fields[2].AsFloat);
     end
       else Edit1.Text:='';

  Combo1.Visible:=False;
  Edit7Exit(Edit7);
  Edit8.SetFocus;
  dbBusca.Active:=False;
end;

procedure TFEtiLineal.Combo1KeyPress(Sender: TObject; var Key: char);
begin
  if (Key = Char(VK_RETURN)) Then Begin key:=#0; Edit8.SetFocus; end;
end;

procedure TFEtiLineal.dbCambiosAfterRefresh(DataSet: TDataSet);
begin
  if DataSet.RecordCount>0 then
     Begin
        BitBtn9.Enabled:=True;
        BitBtn11.Enabled:=True;
     end
  else
     begin
        BitBtn9.Enabled:=False;
        BitBtn11.Enabled:=False;
     end;
end;

procedure TFEtiLineal.Edit7Enter(Sender: TObject);
begin
 Edit7.Text := '';
 LimpiaReg();
end;

procedure TFEtiLineal.Edit7Exit(Sender: TObject);
var
   TxtEans: String;
begin
   if Edit7.Text='' then exit;
   dbTrabajo.Active:=False; dbTrabajo.Sql.Text:='SELECT * FROM cambios WHERE CA0="'+Edit7.Text+'"';
   dbTrabajo.Active:=True;
   if dbTrabajo.RecordCount<>0 then CargaReg()
   else
    begin
     LimpiaReg();
     If Application.MessageBox('ESTA ETIQUETA NO EXISTE, QUIERE BUSCAR EL ARTICULO?','FacturLinEx2', MB_OKCANCEL+MB_ICONINFORMATION ) = ID_CANCEL Then  Exit;
     dbTrabajo.Active:=False; dbTrabajo.Sql.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit7.Text+'" OR A15="'+Edit7.Text+'" OR A16="'+Edit7.Text+'"';
     dbTrabajo.Active:=True;
     if dbTrabajo.RecordCount>0 then
       begin
        Edit8.Text := dbTrabajo.Fields[1].AsString;
        Edit9.Text := FormatFloat('0.00',dbTrabajo.Fields[2].AsFloat);
        BitBtn1.SetFocus;
       end
     else
       begin
        TxtEans:='SELECT * FROM eans WHERE EAN0="'+Edit7.Text+'"';
        dbTrabajo.Active:=False; dbTrabajo.Sql.Text:=TxtEans; dbTrabajo.Active:=True;
        if dbTrabajo.RecordCount>0 then
          begin
           TxtEans:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbTrabajo.Fields[1].AsString+'"';
           dbTrabajo.Active:=False; dbTrabajo.Sql.Text:=TxtEans; dbTrabajo.Active:=True;
           if dbTrabajo.RecordCount>0 then
            begin
              Edit8.Text := dbTrabajo.Fields[1].AsString;
              Edit9.Text := FormatFloat('0.00',dbTrabajo.Fields[2].AsFloat);
              BitBtn1.SetFocus;
              exit;
            end
           else
             begin
              Showmessage('ESTE ARTICULO NO EXISTE');
              exit;
             end;
          end
        else
         begin
           Showmessage('ESTE ARTICULO NO EXISTE');
         end;
       end;
    end;
end;

procedure TFEtiLineal.Edit7KeyPress(Sender: TObject; var Key: char);
begin
  if (Key = Char(VK_RETURN)) Then Begin key:=#0; BitBtn1.SetFocus; end;
end;

procedure TFEtiLineal.Edit8KeyPress(Sender: TObject; var Key: char);
begin
     if (Key = Char(VK_RETURN)) Then Begin key:=#0; BitBtn7Click(BitBtn7); end;
end;

procedure TFEtiLineal.LlenaReg();
begin
  dbCambios.Fields[0].Value := Edit7.Text;
  dbCambios.Fields[1].Value := Edit8.Text;
  if trim(Edit9.Text)='' then Edit9.Text:='0';
  dbCambios.Fields[2].Value := Edit9.Text;
end;

procedure TFEtiLineal.CargaReg();
begin
  Edit7.Text := dbCambios.Fields[0].AsString;
  Edit8.Text := dbCambios.Fields[1].AsString;
  Edit9.Text := FormatFloat('0.00',dbCambios.Fields[2].AsFloat);
end;

initialization
  {$I etilineales.lrs}

end.

