{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2008,

  Nicolas Lopez de Lerma Aymerich
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

Unit listatiendas;

{$mode Objfpc}{$H+}
{$codepage utf8}

Interface

Uses
  Classes, Sysutils, Math, StrUtils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class, ExtDlgs, EditBtn;

Type

  { TFLTiendas }

  TFLTiendas = Class(Tform)
    BitBtnCambiable: TBitBtn;
    ComboCambiableNombre: TComboBox;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    dbCambiable: TZQuery;
    DBGrid5: TDBGrid;
    DBGrid6: TDBGrid;
    Edit1: TEdit;
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
    Bevel1: TBevel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    dbAnos: TZQuery;
    Edit4: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    EditCambiableCodigo: TEdit;
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
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    LabelCambiable: TLabel;
    LabelTituloDBGrid: TLabel;
    ListBoxAnos: TListBox;
    ListBoxAnos2: TListBox;
    ListBoxAnos3: TListBox;
    ListBoxAnos4: TListBox;
    ListBoxAnos5: TListBox;
    ListBoxAnos6: TListBox;
    ListBoxAnos7: TListBox;
    ListBoxAnos8: TListBox;
    Panel1: Tpanel;
    Bitbtn1: Tbitbtn;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    BitBtn4: TBitBtn;
    Datasource1: TDatasource;
    dbQuery: TZQuery;
    PanelCambiable: TPanel;
    PanelDesdeHasta: TPanel;
    PanelFechaDesdeHasta: TPanel;
    PanelSelectAno: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton1: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    dbCambiableComboBox: TZQuery;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    StaticTextCambiableNombre: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtnCambiableClick(Sender: TObject);
    procedure ComboCambiableNombreClick(Sender: TObject);
    procedure ComboCambiableNombreKeyPress(Sender: TObject; var Key: char);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGrid3TitleClick(Column: TColumn);
    procedure DBGrid4TitleClick(Column: TColumn);
    procedure DBGrid5TitleClick(Column: TColumn);
    procedure DBGrid6TitleClick(Column: TColumn);
    procedure EditCambiableCodigoEnter(Sender: TObject);

    procedure EditCambiableCodigoExit(Sender: TObject);

    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    //procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
    procedure OcultarBDGrid();
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    //procedure RellenaListBoxAnos(TxtQuery: String);
    procedure DBGrid1TitleClick(Column: TColumn);
    //procedure BlancoGrid(Grid: TDBGrid);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);

    procedure DimensionarColocarBDGrid();
    procedure RadioButton5Change(Sender: TObject);
    procedure RadioButton6Change(Sender: TObject);

  Private
    FHeaderSubtitle: TLabel;
    FOptionsPanel: TPanel;
    FOptionsTitle: TLabel;
    FMainPanel: TPanel;
    FFilterArea: TPanel;
    FGridHost: TPanel;
    FFilterTitle: TLabel;
    FBtnCambiableVisual: TPanel;
    function CrearPanelVisual(AParent: TWinControl; AColor: TColor): TPanel;
    function CrearTituloVisual(AParent: TWinControl; const ACaption: string): TLabel;
    procedure EstilarBoton(ABoton: TBitBtn; AColor: TColor; ATextoClaro: Boolean);
    procedure PrepararBotonVisual(APanel: TPanel; AOnClick: TNotifyEvent;
      const ACaption, AHint: string; AColor: TColor);
    procedure BotonVisualKeyPress(Sender: TObject; var Key: char);
    procedure AplicarEstiloModerno;
    procedure RecolocarControles(Sender: TObject);
    procedure ActualizarFlechaGrid(AGrid: TDBGrid);
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormlistatiendas;
  
Var
  FLTiendas: TFLTiendas;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

uses
  Global, Funciones;


//============================================================================
//====================== DISEÑO MODERNO Y ADAPTABLE ==========================
//============================================================================
function TFLTiendas.CrearPanelVisual(AParent: TWinControl;
  AColor: TColor): TPanel;
begin
  Result := TPanel.Create(Self);
  Result.Parent := AParent;
  Result.Caption := '';
  Result.BevelOuter := bvNone;
  Result.BevelInner := bvNone;
  Result.ParentColor := False;
  Result.Color := AColor;
  Result.TabStop := False;
end;

function TFLTiendas.CrearTituloVisual(AParent: TWinControl;
  const ACaption: string): TLabel;
begin
  Result := TLabel.Create(AParent);
  Result.Parent := AParent;
  Result.AutoSize := False;
  Result.Caption := ACaption;
  Result.Transparent := True;
  Result.Layout := tlCenter;
  Result.ParentFont := False;
  Result.Font.Name := 'Sans';
  Result.Font.Height := -13;
  Result.Font.Style := [fsBold];
  Result.Font.Color := RGBToColor(36, 76, 94);
end;

procedure TFLTiendas.EstilarBoton(ABoton: TBitBtn;
  AColor: TColor; ATextoClaro: Boolean);
begin
  if not Assigned(ABoton) then Exit;
  ABoton.ParentFont := False;
  ABoton.Font.Name := 'Sans';
  ABoton.Font.Height := -12;
  ABoton.Font.Style := [fsBold];
  ABoton.Color := AColor;
  if ATextoClaro then ABoton.Font.Color := clWhite
  else ABoton.Font.Color := RGBToColor(30, 41, 59);
end;

procedure TFLTiendas.PrepararBotonVisual(APanel: TPanel;
  AOnClick: TNotifyEvent; const ACaption, AHint: string; AColor: TColor);
var
  LTexto: TLabel;
begin
  APanel.Caption := '';
  APanel.BevelOuter := bvRaised;
  APanel.BorderWidth := 2;
  APanel.ParentColor := False;
  APanel.Color := AColor;
  APanel.Cursor := crHandPoint;
  APanel.Hint := AHint;
  APanel.ShowHint := True;
  APanel.OnClick := AOnClick;
  APanel.OnKeyPress := @BotonVisualKeyPress;
  APanel.TabStop := True;
  LTexto := TLabel.Create(APanel);
  LTexto.Parent := APanel;
  LTexto.Align := alClient;
  LTexto.Alignment := taCenter;
  LTexto.Layout := tlCenter;
  LTexto.AutoSize := False;
  LTexto.Transparent := False;
  LTexto.Color := AColor;
  LTexto.ParentColor := False;
  LTexto.Font.Name := 'Sans';
  LTexto.Font.Height := -12;
  LTexto.Font.Style := [fsBold];
  LTexto.Font.Color := clWhite;
  LTexto.Caption := ACaption;
  LTexto.Cursor := crHandPoint;
  LTexto.OnClick := AOnClick;
end;

procedure TFLTiendas.BotonVisualKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = #13) or (Key = #32) then
  begin
    if (Sender is TPanel) and Assigned(TPanel(Sender).OnClick) then
      TPanel(Sender).OnClick(Sender);
    Key := #0;
  end;
end;

procedure TFLTiendas.ActualizarFlechaGrid(AGrid: TDBGrid);
var
  I: Integer;
  Titulo: string;
begin
  if not Assigned(AGrid) then Exit;
  for I := 0 to AGrid.Columns.Count - 1 do
  begin
    Titulo := AGrid.Columns[I].Title.Caption;
    Titulo := StringReplace(Titulo, ' ▲', '', [rfReplaceAll]);
    Titulo := StringReplace(Titulo, ' ▼', '', [rfReplaceAll]);
    if SameText(AGrid.Columns[I].FieldName, TituloColumn) then
      if SameText(Orden, 'DESC') then Titulo := Titulo + ' ▼'
      else Titulo := Titulo + ' ▲';
    AGrid.Columns[I].Title.Caption := Titulo;
  end;
end;

procedure TFLTiendas.AplicarEstiloModerno;
var
  I: Integer;
  C: TComponent;
  G: TDBGrid;
begin
  Caption := 'FacturLinEx · Listados de tiendas';
  Color := RGBToColor(241, 245, 247);
  Font.Name := 'Sans';
  Font.Height := -12;
  Constraints.MinWidth := 1120;
  Constraints.MinHeight := 720;
  WindowState := wsMaximized;

  PanelTituloGrid.Height := 78;
  PanelTituloGrid.Caption := '';
  PanelTituloGrid.BevelOuter := bvNone;
  PanelTituloGrid.ParentColor := False;
  PanelTituloGrid.Color := RGBToColor(18, 76, 91);
  LabelTituloDBGrid.Parent := PanelTituloGrid;
  LabelTituloDBGrid.Font.Name := 'Sans';
  LabelTituloDBGrid.Font.Height := -18;
  LabelTituloDBGrid.Font.Style := [fsBold];
  LabelTituloDBGrid.Font.Color := clWhite;
  LabelTituloDBGrid.Caption := 'LISTADOS DE TIENDAS';
  FHeaderSubtitle := CrearTituloVisual(PanelTituloGrid,
    'Consultas, comparativas e informes de tiendas y puestos');
  FHeaderSubtitle.Font.Height := -11;
  FHeaderSubtitle.Font.Style := [];
  FHeaderSubtitle.Font.Color := RGBToColor(205, 232, 237);

  Panel1.Height := 72;
  Panel1.Caption := '';
  Panel1.BevelOuter := bvNone;
  Panel1.ParentColor := False;
  Panel1.Color := RGBToColor(225, 233, 236);

  FOptionsPanel := CrearPanelVisual(Self, RGBToColor(230, 241, 234));
  FOptionsPanel.Align := alRight;
  FOptionsPanel.Width := 330;
  FOptionsTitle := CrearTituloVisual(FOptionsPanel, 'TIPOS DE LISTADO');
  FOptionsTitle.Font.Height := -15;
  Label5.Visible := False;

  RadioButton1.Parent := FOptionsPanel;
  RadioButton2.Parent := FOptionsPanel;
  RadioButton3.Parent := FOptionsPanel;
  RadioButton4.Parent := FOptionsPanel;
  RadioButton5.Parent := FOptionsPanel;
  RadioButton6.Parent := FOptionsPanel;

  FMainPanel := CrearPanelVisual(Self, RGBToColor(241, 245, 247));
  FMainPanel.Align := alClient;
  FMainPanel.SendToBack;
  PanelTituloGrid.BringToFront;
  Panel1.BringToFront;
  FOptionsPanel.BringToFront;
  FFilterArea := CrearPanelVisual(FMainPanel, RGBToColor(232, 239, 242));
  FFilterArea.Align := alTop;
  FFilterArea.Height := 270;
  FGridHost := CrearPanelVisual(FMainPanel, RGBToColor(241, 245, 247));
  FGridHost.Align := alClient;
  FFilterArea.BringToFront;
  FFilterTitle := CrearTituloVisual(FFilterArea, 'FILTROS DEL LISTADO');
  FFilterTitle.Font.Height := -14;

  PanelDesdeHasta.Parent := FFilterArea;
  PanelSelectAno.Parent := FFilterArea;
  PanelFechaDesdeHasta.Parent := FFilterArea;
  PanelCambiable.Parent := FFilterArea;

  PanelDesdeHasta.Caption := '';
  PanelDesdeHasta.BevelOuter := bvNone;
  PanelDesdeHasta.ParentColor := False;
  PanelDesdeHasta.Color := RGBToColor(226, 238, 242);
  PanelSelectAno.Caption := '';
  PanelSelectAno.BevelOuter := bvNone;
  PanelSelectAno.ParentColor := False;
  PanelSelectAno.Color := RGBToColor(250, 244, 226);
  PanelFechaDesdeHasta.Caption := '';
  PanelFechaDesdeHasta.BevelOuter := bvNone;
  PanelFechaDesdeHasta.ParentColor := False;
  PanelFechaDesdeHasta.Color := RGBToColor(239, 235, 247);
  PanelCambiable.Caption := '';
  PanelCambiable.BevelOuter := bvNone;
  PanelCambiable.ParentColor := False;
  PanelCambiable.Color := RGBToColor(231, 243, 234);

  FBtnCambiableVisual := TPanel.Create(Self);
  FBtnCambiableVisual.Parent := PanelCambiable;
  PrepararBotonVisual(FBtnCambiableVisual, @BitBtnCambiableClick, '...',
    'Buscar tienda', RGBToColor(23, 96, 116));
  FBtnCambiableVisual.TabOrder := BitBtnCambiable.TabOrder;
  BitBtnCambiable.Visible := False;

  for I := 1 to 6 do
  begin
    G := TDBGrid(FindComponent('DBGrid' + IntToStr(I)));
    if Assigned(G) then
    begin
      G.Parent := FGridHost;
      G.Align := alClient;
      G.DefaultRowHeight := 27;
      G.Font.Name := 'Sans';
      G.Font.Height := -11;
      G.TitleFont.Name := 'Sans';
      G.TitleFont.Style := [fsBold];
      G.FixedColor := RGBToColor(211, 225, 231);
      G.Color := clWhite;
    end;
  end;

  Label1.Caption := 'Último código';
  Label2.Caption := 'Primer código';
  Label3.Caption := 'Primer nombre';
  Label4.Caption := 'Último nombre';
  Label6.Caption := 'Seleccione el año';
  Label7.Caption := 'Desde el mes';
  Label8.Caption := 'Hasta el mes';
  Label10.Caption := 'Primera fecha';
  Label11.Caption := 'Última fecha';
  RadioButton4.Caption := 'Estadísticas de compras y ventas';

  for I := 0 to ComponentCount - 1 do
  begin
    C := Components[I];
    if C is TLabel then
    begin
      TLabel(C).ParentFont := False;
      TLabel(C).Font.Name := 'Sans';
      if TLabel(C).Font.Height > -11 then TLabel(C).Font.Height := -11;
      if (C <> LabelTituloDBGrid) and (C <> FHeaderSubtitle) then
        TLabel(C).Font.Color := RGBToColor(37, 52, 61);
    end
    else if C is TEdit then
    begin
      TEdit(C).ParentFont := False;
      TEdit(C).Font.Name := 'Sans';
      TEdit(C).Font.Height := -12;
    end
    else if C is TRadioButton then
    begin
      TRadioButton(C).ParentFont := False;
      TRadioButton(C).Font.Name := 'Sans';
      TRadioButton(C).Font.Height := -12;
      TRadioButton(C).Font.Color := RGBToColor(37, 52, 61);
      TRadioButton(C).ParentColor := False;
      TRadioButton(C).Color := FOptionsPanel.Color;
    end;
  end;

  EstilarBoton(BitBtn1, RGBToColor(23, 96, 116), True);
  EstilarBoton(BitBtn2, RGBToColor(91, 118, 132), True);
  EstilarBoton(BitBtn3, RGBToColor(191, 139, 48), True);
  EstilarBoton(BitBtn4, RGBToColor(73, 83, 91), True);
  BitBtn1.Caption := 'Visualizar';
  BitBtn2.Caption := 'Imprimir';
  BitBtn3.Caption := 'Nueva selección';

  OnResize := @RecolocarControles;
  RecolocarControles(Self);
end;

procedure TFLTiendas.RecolocarControles(Sender: TObject);
var
  W, X, Y, FieldX, FieldW: Integer;
begin
  LabelTituloDBGrid.SetBounds(22, 10, PanelTituloGrid.ClientWidth - 44, 30);
  FHeaderSubtitle.SetBounds(24, 43, PanelTituloGrid.ClientWidth - 48, 22);

  FOptionsTitle.SetBounds(18, 20, FOptionsPanel.ClientWidth - 36, 30);
  RadioButton1.SetBounds(24, 72, FOptionsPanel.ClientWidth - 48, 32);
  RadioButton2.SetBounds(24, 116, FOptionsPanel.ClientWidth - 48, 32);
  RadioButton3.SetBounds(24, 160, FOptionsPanel.ClientWidth - 48, 32);
  RadioButton4.SetBounds(24, 204, FOptionsPanel.ClientWidth - 48, 42);
  RadioButton5.SetBounds(24, 258, FOptionsPanel.ClientWidth - 48, 32);
  RadioButton6.SetBounds(24, 302, FOptionsPanel.ClientWidth - 48, 32);

  FFilterTitle.SetBounds(22, 10, FFilterArea.ClientWidth - 44, 28);
  W := FFilterArea.ClientWidth - 44;
  PanelDesdeHasta.SetBounds(22, 48, W, 202);
  PanelFechaDesdeHasta.SetBounds(22, 48, W, 118);
  PanelCambiable.SetBounds(22, 48, W, 62);
  PanelSelectAno.SetBounds(22, 120, W, 130);

  X := 24;
  FieldX := 158;
  FieldW := Max(200, PanelDesdeHasta.ClientWidth - FieldX - 26);
  Label2.SetBounds(X, 24, 120, 22); Edit1.SetBounds(FieldX, 20, 94, 30);
  Label1.SetBounds(X, 68, 120, 22); Edit2.SetBounds(FieldX, 64, 94, 30);
  Label3.SetBounds(X, 112, 120, 22); Edit3.SetBounds(FieldX, 108, FieldW, 30);
  Label4.SetBounds(X, 156, 120, 22); Edit4.SetBounds(FieldX, 152, FieldW, 30);

  LabelCambiable.SetBounds(18, 20, 110, 22);
  EditCambiableCodigo.SetBounds(132, 15, 110, 31);
  FBtnCambiableVisual.SetBounds(250, 15, 34, 31);
  StaticTextCambiableNombre.SetBounds(294, 15,
    Max(180, PanelCambiable.ClientWidth - 314), 31);
  ComboCambiableNombre.SetBounds(294, 15,
    Max(180, PanelCambiable.ClientWidth - 314), 31);

  Label6.SetBounds(18, 12, 128, 22);
  ListBoxAnos.SetBounds(150, 10, 100, 104);
  Label7.SetBounds(282, 24, 100, 22); Edit7.SetBounds(386, 19, 64, 30);
  Label8.SetBounds(480, 24, 100, 22); Edit8.SetBounds(584, 19, 64, 30);

  Label10.SetBounds(24, 24, 112, 22); DateEdit1.SetBounds(144, 19, 140, 31);
  Label11.SetBounds(320, 24, 112, 22); DateEdit2.SetBounds(440, 19, 140, 31);

  BitBtn1.SetBounds(18, 14, 138, 44);
  BitBtn2.SetBounds(170, 14, 138, 44);
  BitBtn3.SetBounds(322, 14, 156, 44);
  BitBtn4.SetBounds(Panel1.ClientWidth - 156, 14, 138, 44);

  FBtnCambiableVisual.BringToFront;
end;


//=============== Crea el formulario ================
procedure ShowFormlistatiendas;
begin
  with TFLTiendas.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLTiendas.Formcreate(Sender: Tobject);
Begin
  //Conectate(dbConect);    // Utilizamos datamodule1.dbConexión para toda la aplicación.

  //---------------------Paneles visibles por defecto, los de RadioButton1Change
  PanelSelectAno.Visible:=False;
  PanelFechaDesdeHasta.Visible:=False;
  PanelDesdeHasta.Visible:=True;
  PanelCambiable.Visible:=False;
  EditCambiableCodigo.Text:=Tienda;

  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;

  //Dimensionamos, colocamos y cocultamos todos los DBGrid
  DimensionarColocarBDGrid();
  OcultarBDGrid();
  AplicarEstiloModerno;

End;

//==================== CERRAR ======================
procedure TFLTiendas.BitBtn4Click(Sender: TObject);
begin
  dbQuery.Active:=False;
  Close();
end;

//==================== VISUALIZAR ===================
procedure TFLTiendas.BitBtn1Click(Sender: TObject);
Var
  TxtQuery: String;
begin
  AntColun:='0';Ordenado:=False;
  BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
  if PanelCambiable.IsVisible then
    begin
      if EditCambiableCodigo.Text<>'' then Tienda:=DataModule1.LFill(EditCambiableCodigo.Text,4,'0')
      else
       begin
        EditCambiableCodigo.Text:= Tienda;
        EditCambiableCodigoExit(EditCambiableCodigo);
       end;
   end;
  //-------------------------- DATOS PRINCIPALES
  if RadioButton1.Checked=True then
    begin
     TituloGrid:='LISTADO DE DATOS PRINCIPALES';
     TxtQuery:='SELECT * FROM tiendas WHERE';
     if Edit1.Text<>'' then
       TxtQuery:=TxtQuery + ' T0>='+Edit1.Text+' AND';
     if Edit2.Text<>'' then
       TxtQuery:=TxtQuery + ' T0<='+Edit2.Text+' AND';
     TxtQuery:=TxtQuery + ' MID(T1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(T1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY T0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
    end;
 //--------------------------_ LISTADO DE COMPRAS
  if RadioButton2.Checked=True then
    begin
     if dbAnos.RecordCount=0 then begin showmessage('NO HAY DATOS PARA VISUALIZAR'); exit; end;
     TituloGrid:='LISTADO DE COMPRAS DE LA TIENDA';
     TxtQuery:='SELECT TT0, TT1, TT2, TT3, TT4'+
     ' FROM estatien'+Tienda+', tiendas WHERE TT0='+EditCambiableCodigo.Text +
     ' AND TT1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+
     ' AND TT2>='+Edit7.Text+' AND TT2<='+Edit8.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY TT0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbCambiable.RecordCount<>0 then TituloGrid:= TituloGrid +' "'+StaticTextCambiableNombre.Caption+'"';
     if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     DBGrid2.BringToFront; DBGrid2.Visible:=True;
    end;
  //--------------------------_ LISTADO DE VENTAS

  if RadioButton3.Checked=True then
    begin
     if dbAnos.RecordCount=0 then begin showmessage('NO HAY DATOS PARA VISUALIZAR'); exit; end;
     TituloGrid:='LISTADO DE VENTAS DE LA TIENDA';
     TxtQuery:='SELECT *, TT6-TT7 As BENE'+
     ' FROM estatien'+Tienda+
     ' WHERE TT0='+EditCambiableCodigo.Text +
     ' AND TT1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+
     ' AND TT2>='+Edit7.Text+' AND TT2<='+Edit8.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY TT0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbCambiable.RecordCount<>0 then TituloGrid:= TituloGrid +' "'+StaticTextCambiableNombre.Caption+'"';
     if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     DBGrid3.BringToFront; DBGrid3.Visible:=True;
    end;
  //-------------------------- ESTADISTICA DE COMPRAS VENTAS Y BENEFICIOS
  if RadioButton4.Checked=True then
    begin
     if dbAnos.RecordCount=0 then begin showmessage('NO HAY DATOS PARA VISUALIZAR'); exit; end;
     TituloGrid:='LISTADO DE ESTADISTICA DE COMPRAS, VENTAS Y BENEFICIOS';
     TxtQuery:='SELECT T0,T1,SUM(TT3) AS UnidComp,SUM(TT4) AS ImpCompCost,SUM(TT5) AS UniVend,SUM(TT6) AS ImpVPrecio,SUM(TT7) AS ImpVCost,SUM(TT6-TT7) AS BENEF '+
     'FROM tiendas,estatien'+Tienda+
     ' WHERE T0='+EditCambiableCodigo.Text +
     //' WHERE T0>='+Edit1.Text+' AND T0<='+Edit2.Text+
     //' AND MID(T1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
     //'" AND MID(T1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"'+
     ' AND TT1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+' AND TT2>='+
     Edit7.Text+' AND TT2<='+Edit8.Text+' AND T0=TT0 GROUP BY T0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY T0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     DBGrid4.BringToFront; DBGrid4.Visible:=True;
    end;
     //-------------------------- VENTAS POR FECHAS DESDE hisopccXXXX
  if RadioButton5.Checked=True then
    begin
     TituloGrid:='LISTADO DE VENTAS POR FECHAS DE LA TIENDA ACTIVA';
     TxtQuery := 'SELECT HO0, SUM(HO9) As ImpoTotal, SUM(HO11) As ImpoTotalDes, SUM(HO12) As Entrega, SUM(HO13) As Cambio, SUM(HO14) As EntregaTarj';
     //TxtQuery := TxtQuery + ', TT0'
     TxtQuery := TxtQuery + ' FROM hisopcc'+Tienda;
     TxtQuery := TxtQuery + ' WHERE HO0 >="'+FormatDateTime('YYYY/MM/DD',DateEdit1.Date)+'"';
     TxtQuery := TxtQuery + ' AND HO0 <="'+FormatDateTime('YYYY/MM/DD',DateEdit2.Date)+'"';
     TxtQuery := TxtQuery + ' GROUP BY HO0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid5.BringToFront; DBGrid5.Visible:=True;
    end;
  if RadioButton6.Checked=True then
    begin
     TituloGrid:='LISTADO DE PUESTOS DE LA TIENDA ACTIVA';
     TxtQuery := 'select PT0, PT1, PT2, PT3, PT4 ';
     TxtQuery := TxtQuery + 'FROM puestos'+Tienda;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY PT0, PT1';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid6.BringToFront; DBGrid6.Visible:=True;
    end;
   //PanelSelectAno.Visible:=False;
   //PanelDesdeHasta.Visible:=False;
   LabelTituloDBGrid.Caption:=TituloGrid;
   //WriteLn(TxtQuery);
end;

//==================== SELECCIONAR ===================
procedure TFLTiendas.BitBtn3Click(Sender: TObject);
begin
  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
end;

//==================== IMPRIMIR ===================
procedure TFLTiendas.BitBtn2Click(Sender: TObject);
begin
  //-------------------------- Datos Principales
  if RadioButton1.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoTiendasDatos.lrf');
     frReport1.ShowReport;
    end;
 //--------------------------_ LISTADO DE COMPRAS
  if RadioButton2.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoTiendasCompras.lrf');
     frReport1.ShowReport;
    end;
  //--------------------------_ LISTADO DE VENTAS

  if RadioButton3.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoTiendasVentas.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Estadisticas de compras, ventas y beneficios
  if RadioButton4.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoTiendasEstad.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- VENTAS POR FECHAS DESDE hisopccXXXX
  if RadioButton5.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoTiendasVenFech.lrf');
     frReport1.ShowReport;
    end;
  //------------------------- LISTADO DE PUESTOS DE LA TIENDA ACTIVA
  if RadioButton6.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoTiendasPuestos.lrf');
     frReport1.ShowReport;
    end;
end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLTiendas.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  if ParName ='EMPRESA' then ParValue := Empresa;
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
//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFLTiendas.frReport1EnterRect(Memo: TStringList; View: TfrView);
var
  vImage: TImage;
begin
  frReport1.Title:=TituloGrid;
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


//===============================================================
//==================== OPCIONES DE LISTADOS =========================
//===============================================================

procedure TFLTiendas.RadioButton1Change(Sender: TObject);
begin
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelDesdeHasta.Visible:=True;
   PanelCambiable.Visible:=False;
   OcultarBDGrid();
   EditCambiableCodigo.Text:='';
   StaticTextCambiableNombre.Caption:='';
end;

procedure TFLTiendas.RadioButton2Change(Sender: TObject);
begin
   if RadioButton2.Checked=True then
     begin
       RellenaListBoxAnos('SELECT DISTINCT(TT1) FROM estatien'+Tienda,dbAnos, PanelSelectAno, ListBoxAnos);
       RellenaPanelCambiableN('SELECT T1 FROM tiendas WHERE T0="'+EditCambiableCodigo.Text+'"',dbCambiable, StaticTextCambiableNombre);
     end;
   PanelDesdeHasta.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiable.Visible:=True;
   LabelCambiable.Caption:='Tienda';
   OcultarBDGrid();
   EditCambiableCodigo.Text:='';
   StaticTextCambiableNombre.Caption:='';
end;

procedure TFLTiendas.RadioButton3Change(Sender: TObject);
begin
   if RadioButton3.Checked=True then
     begin
       RellenaListBoxAnos('SELECT DISTINCT(TT1) FROM estatien'+Tienda,dbAnos, PanelSelectAno, ListBoxAnos);
       RellenaPanelCambiableN('SELECT T1 FROM tiendas WHERE T0="'+EditCambiableCodigo.Text+'"',dbCambiable, StaticTextCambiableNombre);
     end;
   PanelDesdeHasta.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiable.Visible:=True;
   LabelCambiable.Caption:='Tienda';
   OcultarBDGrid();
   EditCambiableCodigo.Text:='';
   StaticTextCambiableNombre.Caption:='';
end;
//---------- Estadisticas de tiendas
procedure TFLTiendas.RadioButton4Change(Sender: TObject);
begin
   if RadioButton4.Checked=True then
     begin
       RellenaListBoxAnos('SELECT DISTINCT(TT1) FROM estatien'+Tienda,dbAnos, PanelSelectAno, ListBoxAnos);
       RellenaPanelCambiableN('SELECT T1 FROM tiendas WHERE T0="'+EditCambiableCodigo.Text+'"',dbCambiable, StaticTextCambiableNombre);
     end;
   PanelDesdeHasta.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiable.Visible:=True;
   LabelCambiable.Caption:='Tienda';
   OcultarBDGrid();
   EditCambiableCodigo.Text:='';
   StaticTextCambiableNombre.Caption:='';
end;


procedure TFLTiendas.RadioButton5Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=False;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiable.Visible:=False;
   //LabelCambiable.Caption:='Tienda';
   OcultarBDGrid();
end;

procedure TFLTiendas.RadioButton6Change(Sender: TObject);
begin
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelDesdeHasta.Visible:=False;
   PanelCambiable.Visible:=False;
   OcultarBDGrid();
   EditCambiableCodigo.Text:='';
   StaticTextCambiableNombre.Caption:='';
end;

// ====================== Redimensiona y Coloca Todos los DBGrid
procedure TFLTiendas.DimensionarColocarBDGrid();
  begin
    DBGrid1.Align:=alClient;
    DBGrid2.Align:=alClient;
    DBGrid3.Align:=alClient;
    DBGrid4.Align:=alClient;
    DBGrid5.Align:=alClient;
    DBGrid6.Align:=alClient;
    //DBGrid7.Align:=alClient;
  end;


//======================= OCULTA TODOS LOS DBGird
procedure TFLTiendas.OcultarBDGrid();
  begin
    LabelTituloDBGrid.Caption:='SELECCIONE LOS FILTROS Y PULSE VISUALIZAR';
    DBGrid1.Visible:=False; DBGrid2.Visible:=False;
    DBGrid3.Visible:=False; DBGrid4.Visible:=False;
    DBGrid5.Visible:=False; DBGrid6.Visible:=False;
  end;

//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLTiendas.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaGrid(DBGrid1);
end;
procedure TFLTiendas.DBGrid2TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid2,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaGrid(DBGrid2);
end;
procedure TFLTiendas.DBGrid3TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid3,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaGrid(DBGrid3);
end;
procedure TFLTiendas.DBGrid4TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid4,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaGrid(DBGrid4);
end;
procedure TFLTiendas.DBGrid5TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid5,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaGrid(DBGrid5);
end;
procedure TFLTiendas.DBGrid6TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid6,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaGrid(DBGrid6);
end;

//========= Boton de busqueda del panel cambiable y seleccion del nombre elejido
procedure TFLTiendas.BitBtnCambiableClick(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT T0, T1 FROM tiendas ORDER BY T1';
  CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre, dbCambiable, LabelCambiable);
end;

procedure TFLTiendas.ComboCambiableNombreClick(Sender: TObject);
var TxtCampo: string;
begin
  TxtCampo:='T1';
  EscogeNombreComboCambiable( TxtCampo, ComboCambiableNombre, dbCambiable, EditCambiableCodigo, StaticTextCambiableNombre)
end;

procedure TFLTiendas.ComboCambiableNombreKeyPress(Sender: TObject; var Key: char
  );
begin
  if key=#13 then ComboCambiableNombreClick(ComboCambiableNombre);
end;

//======================= Despues de introducir un codigo, al salir, si existe,
//======================= completa el StaticText con el nombre oportuno
procedure TFLTiendas.EditCambiableCodigoExit(Sender: TObject);
var
 TxtQuery: String;
begin
  if LabelCambiable.Caption='Tienda' then
    TxtQuery:='SELECT T1 FROM tiendas WHERE T0="'+EditCambiableCodigo.Text+'"';

  if EditCambiableCodigo.Text<>'' then
    begin
      RellenaPanelCambiableN(TxtQuery, dbCambiable, StaticTextCambiableNombre);
      if dbCambiable.RecordCount=0 then
       begin
         Showmessage('NO HAY '+LabelCambiable.Caption+' CON ESE CODIGO');
         EditCambiableCodigo.Text:='';
         exit;
       end;
   end;
end;

procedure TFLTiendas.EditCambiableCodigoEnter(Sender: TObject);
begin
  StaticTextCambiableNombre.Caption:='';
end;

Procedure TFLTiendas.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

Initialization
  {$I listatiendas.lrs}

End.

