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
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

Unit Familias;

{$mode Objfpc}{$H+}
{$codepage utf8}

Interface

Uses
  Classes, Sysutils, Math, StrUtils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType, DBGrids,
  TAGraph, TASeries, db, DbCtrls;


Type

  { TFFamilias }

  TFFamilias = Class(Tform)
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    Chart1: TChart;
    Chart1AreaSeries1: TAreaSeries;
    Chart1BarSeries1: TBarSeries;
    Chart1PieSeries1: TPieSeries;
    Chart1Serie1: TLineSeries;
    Datasource1: TDatasource;
    dbRoles: TZQuery;
    dbGrafica: TZQuery;
    dbBusca: TZQuery;
    DBGrid1: TDBGrid;
    dbEsta: TZQuery;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label17: TLabel;
    Label4: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label5: TLabel;
    Label57: TLabel;
    Label65: TLabel;
    Label68: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    lbBeneficio: TLabel;
    lbIC: TLabel;
    lbIVC: TLabel;
    lbIVP: TLabel;
    lbUC: TLabel;
    lbUV: TLabel;
    ListBox3: TListBox;
    ListBox4: TListBox;
    ListBox5: TListBox;
    ListBox6: TListBox;
    Memo1: TMemo;
    Edit1: Tedit;
    dbFamilias: TZQuery;
    Panel1: Tpanel;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    Bitbtn4: Tbitbtn;
    Bitbtn5: Tbitbtn;
    Bitbtn6: Tbitbtn;
    Bitbtn1: Tbitbtn;
    Label7: Tlabel;
    Pagecontrol1: Tpagecontrol;
    Panel3: TPanel;
    Tabsheet1: Ttabsheet;
    Tabsheet2: Ttabsheet;
    Tabsheet3: Ttabsheet;
    Label2: Tlabel;
    Label3: Tlabel;
    Edit2: Tedit;
    Edit3: Tedit;
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit3Enter(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: char);
    Procedure Formcreate(Sender: Tobject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    Procedure Edit1enter(Sender: Tobject);
    Procedure Edit1exit(Sender: Tobject);
    Procedure LimpiaForm();
    procedure ListBox3Click(Sender: TObject);
    procedure ListBox4Click(Sender: TObject);
    procedure ListBox5Click(Sender: TObject);
    procedure ListBox6Click(Sender: TObject);
    Procedure Relleno();
    Procedure LlenaReg();
    Procedure Bitbtn1click(Sender: Tobject);
    Procedure Bitbtn6click(Sender: Tobject);
    Procedure Bitbtn5click(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    Procedure Bitbtn4click(Sender: Tobject);
    Procedure Bitbtn2click(Sender: Tobject);
    Procedure Bitbtn3click(Sender: Tobject);
    procedure Graficas();
    procedure CambiarGrafica();
    procedure RellenaEsta(Ano: String);
    procedure VerDepartamento();
    
  Private
    { Capa visual moderna: no altera consultas ni tratamiento de datos. }
    FHeaderBar: TPanel;
    FHeaderTitle: TLabel;
    FHeaderSubtitle: TLabel;
    FCardGeneral: TShape;
    FCardActivity: TShape;
    FCardNotes: TShape;
    FTitleGeneral: TLabel;
    FTitleActivity: TLabel;
    FTitleNotes: TLabel;
    FStatsSummaryPanel: TPanel;
    FGraphSidePanel: TPanel;
    FOrdenGridCampo: string;
    FOrdenGridDireccion: string;
    function CrearPanelVisual(AParent: TWinControl; AColor: TColor): TPanel;
    function CrearTarjetaVisual(AParent: TWinControl; AColor: TColor): TShape;
    function CrearTituloVisual(AParent: TWinControl; const ACaption: string): TLabel;
    procedure EstilarBoton(ABoton: TBitBtn; AColor: TColor; ATextoClaro: Boolean);
    procedure AplicarEstiloModerno;
    procedure RecolocarControles(Sender: TObject);
    function SQLSinOrden(const ASQL: string): string;
    procedure ActualizarFlechaGrid(AGrid: TDBGrid; const ACampo, ADireccion: string);
    procedure DBGrid1TitleClick(Column: TColumn);
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormFamilias;
  
Var
  FFamilias: TFFamilias;
  CargaGrafica: Integer;
  s: TBarSeries;

Implementation

Uses
  Global, Funciones, Busquedas;

//============================================================================
//====================== DISEÑO MODERNO Y ADAPTABLE ==========================
//============================================================================
function TFFamilias.CrearPanelVisual(AParent: TWinControl;
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

function TFFamilias.CrearTarjetaVisual(AParent: TWinControl;
  AColor: TColor): TShape;
begin
  Result := TShape.Create(Self);
  Result.Parent := AParent;
  Result.Shape := stRectangle;
  Result.Brush.Style := bsSolid;
  Result.Brush.Color := AColor;
  Result.Pen.Style := psSolid;
  Result.Pen.Color := RGBToColor(207, 219, 224);
  Result.Pen.Width := 1;
  Result.SendToBack;
end;

function TFFamilias.CrearTituloVisual(AParent: TWinControl;
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

procedure TFFamilias.EstilarBoton(ABoton: TBitBtn;
  AColor: TColor; ATextoClaro: Boolean);
begin
  if not Assigned(ABoton) then Exit;
  ABoton.ParentFont := False;
  ABoton.Font.Name := 'Sans';
  ABoton.Font.Height := -12;
  ABoton.Font.Style := [fsBold];
  ABoton.Color := AColor;
  ABoton.ShowHint := True;
  if ATextoClaro then
    ABoton.Font.Color := clWhite
  else
    ABoton.Font.Color := RGBToColor(30, 41, 59);
end;

function TFFamilias.SQLSinOrden(const ASQL: string): string;
var
  P: SizeInt;
begin
  Result := Trim(ASQL);
  P := RPos(' ORDER BY ', UpperCase(Result));
  if P > 0 then Result := Trim(Copy(Result, 1, P - 1));
  if (Result <> '') and (Result[Length(Result)] = ';') then
    Delete(Result, Length(Result), 1);
end;

procedure TFFamilias.ActualizarFlechaGrid(AGrid: TDBGrid;
  const ACampo, ADireccion: string);
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
    if SameText(AGrid.Columns[I].FieldName, ACampo) then
      if SameText(ADireccion, 'DESC') then
        Titulo := Titulo + ' ▼'
      else
        Titulo := Titulo + ' ▲';
    AGrid.Columns[I].Title.Caption := Titulo;
  end;
end;

procedure TFFamilias.DBGrid1TitleClick(Column: TColumn);
var
  Campo, BaseSQL: string;
begin
  if not Assigned(Column) then Exit;
  Campo := Trim(Column.FieldName);
  if Campo = '' then Exit;

  if SameText(FOrdenGridCampo, Campo) then
  begin
    if SameText(FOrdenGridDireccion, 'ASC') then
      FOrdenGridDireccion := 'DESC'
    else
      FOrdenGridDireccion := 'ASC';
  end
  else
  begin
    FOrdenGridCampo := Campo;
    FOrdenGridDireccion := 'ASC';
  end;

  BaseSQL := SQLSinOrden(dbEsta.SQL.Text);
  if BaseSQL = '' then Exit;

  dbEsta.DisableControls;
  try
    dbEsta.Close;
    dbEsta.SQL.Text := BaseSQL + ' ORDER BY `' + Campo + '` ' +
      FOrdenGridDireccion;
    dbEsta.Open;
  finally
    dbEsta.EnableControls;
  end;
  ActualizarFlechaGrid(DBGrid1, FOrdenGridCampo, FOrdenGridDireccion);
end;

procedure TFFamilias.AplicarEstiloModerno;
var
  I: Integer;
  C: TComponent;
begin
  Caption := 'FacturLinEx · Gestión de familias';
  Color := RGBToColor(241, 245, 247);
  ParentFont := False;
  Font.Name := 'Sans';
  Font.Height := -12;
  Constraints.MinWidth := 1100;
  Constraints.MinHeight := 720;
  WindowState := wsMaximized;

  FHeaderBar := CrearPanelVisual(Self, RGBToColor(18, 76, 91));
  FHeaderBar.Align := alTop;
  FHeaderBar.Height := 92;
  FHeaderBar.TabOrder := 0;
  FHeaderBar.BringToFront;

  FHeaderTitle := CrearTituloVisual(FHeaderBar, 'GESTIÓN DE FAMILIAS');
  FHeaderTitle.Font.Height := -20;
  FHeaderTitle.Font.Color := clWhite;
  FHeaderSubtitle := CrearTituloVisual(FHeaderBar,
    'Clasificación, departamento, estadísticas y evolución de ventas');
  FHeaderSubtitle.Font.Height := -11;
  FHeaderSubtitle.Font.Style := [];
  FHeaderSubtitle.Font.Color := RGBToColor(205, 232, 237);

  Label1.Parent := FHeaderBar;
  Edit1.Parent := FHeaderBar;
  Label7.Parent := FHeaderBar;
  Label1.Caption := 'Código de familia';
  Label1.Transparent := True;
  Label7.Transparent := True;

  Panel1.Align := alBottom;
  Panel1.TabOrder := 2;
  Panel1.Height := 66;
  Panel1.Caption := '';
  Panel1.BevelOuter := bvNone;
  Panel1.BevelInner := bvNone;
  Panel1.ParentColor := False;
  Panel1.Color := RGBToColor(225, 233, 236);
  Panel1.BringToFront;

  PageControl1.Align := alClient;
  PageControl1.TabOrder := 1;
  PageControl1.Font.Name := 'Sans';
  PageControl1.Font.Height := -12;
  PageControl1.Color := RGBToColor(241, 245, 247);
  PageControl1.SendToBack;
  TabSheet1.Color := RGBToColor(241, 245, 247);
  if Assigned(TabSheet2) then TabSheet2.Color := RGBToColor(241, 245, 247);
  if Assigned(TabSheet3) then TabSheet3.Color := RGBToColor(241, 245, 247);

  TabSheet1.Caption := ' Ficha general ';
  if Assigned(TabSheet2) then TabSheet2.Caption := ' Estadísticas ';
  if Assigned(TabSheet3) then TabSheet3.Caption := ' Gráficas ';

  FCardGeneral := CrearTarjetaVisual(TabSheet1, RGBToColor(226, 238, 242));
  FCardActivity := CrearTarjetaVisual(TabSheet1, RGBToColor(231, 243, 234));
  FCardNotes := CrearTarjetaVisual(TabSheet1, RGBToColor(250, 244, 226));
  FTitleGeneral := CrearTituloVisual(TabSheet1, 'IDENTIFICACIÓN DE LA FAMILIA');
  FTitleActivity := CrearTituloVisual(TabSheet1, 'ACTIVIDAD');
  FTitleNotes := CrearTituloVisual(TabSheet1, 'OBSERVACIONES');

  Label2.Caption := 'Nombre';
  Label3.Caption := 'Departamento';
  Label11.Caption := 'Última venta';
  Label12.Caption := 'Última compra';
  Label17.Caption := 'Observaciones';

  for I := 0 to ComponentCount - 1 do
  begin
    C := Components[I];
    if C is TLabel then
    begin
      TLabel(C).ParentFont := False;
      TLabel(C).Font.Name := 'Sans';
      if TLabel(C).Font.Height > -11 then TLabel(C).Font.Height := -11;
      if (C <> FHeaderTitle) and (C <> FHeaderSubtitle) then
        TLabel(C).Font.Color := RGBToColor(37, 52, 61);
    end
    else if C is TEdit then
    begin
      TEdit(C).ParentFont := False;
      TEdit(C).Font.Name := 'Sans';
      TEdit(C).Font.Height := -12;
      TEdit(C).Color := clWhite;
    end
    else if C is TMemo then
    begin
      TMemo(C).ParentFont := False;
      TMemo(C).Font.Name := 'Sans';
      TMemo(C).Font.Height := -12;
    end
    else if C is TListBox then
    begin
      TListBox(C).ParentFont := False;
      TListBox(C).Font.Name := 'Sans';
      TListBox(C).Font.Height := -11;
      TListBox(C).Color := clWhite;
    end;
  end;

  Label1.Font.Color := clWhite;
  Label1.Font.Style := [fsBold];
  Label1.Font.Height := -11;
  Label7.Font.Color := clWhite;
  Label7.Font.Style := [fsBold];
  Label7.Font.Height := -13;
  Label7.Layout := tlCenter;

  Edit1.ParentFont := False;
  Edit1.Font.Name := 'Sans';
  Edit1.Font.Height := -13;
  Edit1.Font.Style := [fsBold];
  Edit1.Font.Color := RGBToColor(18, 76, 91);
  Edit1.Color := clWhite;

  Label2.Font.Style := [fsBold];
  Label3.Font.Style := [fsBold];
  Label11.Font.Style := [fsBold];
  Label12.Font.Style := [fsBold];
  Label17.Font.Style := [fsBold];

  Memo1.Color := RGBToColor(255, 253, 247);
  Memo1.Font.Color := RGBToColor(30, 41, 59);
  Memo1.BorderStyle := bsSingle;
  Memo1.ScrollBars := ssAutoVertical;

  { Recorrido de teclado coherente con la disposición visual. }
  Edit2.TabOrder := 0;
  BitBtn8.TabOrder := 1;
  BitBtn8.TabStop := True;
  Edit3.TabOrder := 2;
  BitBtn7.TabOrder := 3;
  BitBtn7.TabStop := True;
  Edit4.TabOrder := 4;
  Edit10.TabOrder := 5;
  Edit11.TabOrder := 6;
  Memo1.TabOrder := 7;

  EstilarBoton(BitBtn2, RGBToColor(5, 150, 105), True);
  EstilarBoton(BitBtn3, RGBToColor(185, 28, 28), True);
  EstilarBoton(BitBtn4, RGBToColor(18, 76, 91), True);
  EstilarBoton(BitBtn5, RGBToColor(218, 226, 230), False);
  EstilarBoton(BitBtn6, RGBToColor(218, 226, 230), False);
  EstilarBoton(BitBtn1, RGBToColor(71, 85, 105), True);
  EstilarBoton(BitBtn7, RGBToColor(23, 96, 116), True);
  EstilarBoton(BitBtn8, RGBToColor(23, 96, 116), True);
  BitBtn4.Caption := 'Modificar';
  BitBtn5.Caption := 'Anterior';
  BitBtn6.Caption := 'Siguiente';
  BitBtn7.Hint := 'Buscar departamento por nombre';
  BitBtn8.Hint := 'Buscar familia por nombre';

  if Assigned(TabSheet2) then
  begin
    FStatsSummaryPanel := CrearPanelVisual(TabSheet2, RGBToColor(232, 239, 242));
    FStatsSummaryPanel.Align := alBottom;
    FStatsSummaryPanel.Height := 90;

    Panel3.Align := alRight;
    Panel3.Width := 220;
    Panel3.Caption := '';
    Panel3.BevelOuter := bvNone;
    Panel3.ParentColor := False;
    Panel3.Color := RGBToColor(230, 241, 234);

    DBGrid1.Align := alClient;
    DBGrid1.BorderSpacing.Bottom := 0;
    DBGrid1.DefaultRowHeight := 27;
    DBGrid1.ParentFont := False;
    DBGrid1.Font.Name := 'Sans';
    DBGrid1.Font.Height := -11;
    DBGrid1.TitleFont.Name := 'Sans';
    DBGrid1.TitleFont.Style := [fsBold];
    DBGrid1.FixedColor := RGBToColor(211, 225, 231);
    DBGrid1.OnTitleClick := @DBGrid1TitleClick;
    FOrdenGridCampo := 'FF1';
    FOrdenGridDireccion := 'ASC';
    ActualizarFlechaGrid(DBGrid1, FOrdenGridCampo, FOrdenGridDireccion);

    Label76.Parent := FStatsSummaryPanel; lbUC.Parent := FStatsSummaryPanel;
    Label75.Parent := FStatsSummaryPanel; lbIC.Parent := FStatsSummaryPanel;
    Label68.Parent := FStatsSummaryPanel; lbUV.Parent := FStatsSummaryPanel;
    Label65.Parent := FStatsSummaryPanel; lbIVP.Parent := FStatsSummaryPanel;
    Label4.Parent := FStatsSummaryPanel; lbIVC.Parent := FStatsSummaryPanel;
    Label5.Parent := FStatsSummaryPanel; lbBeneficio.Parent := FStatsSummaryPanel;

    Label76.Caption := 'U. compradas';
    Label75.Caption := 'Importe comprado';
    Label68.Caption := 'U. vendidas';
    Label65.Caption := 'Venta a PVP';
    Label4.Caption := 'Venta a coste';
    Label5.Caption := 'Beneficio';
    lbBeneficio.Font.Color := RGBToColor(5, 150, 105);
  end;

  if Assigned(TabSheet3) then
  begin
    FGraphSidePanel := CrearPanelVisual(TabSheet3, RGBToColor(232, 239, 242));
    FGraphSidePanel.Align := alRight;
    FGraphSidePanel.Width := 260;
    Label47.Parent := FGraphSidePanel;
    Label48.Parent := FGraphSidePanel;
    Label49.Parent := FGraphSidePanel;
    ListBox3.Parent := FGraphSidePanel;
    ListBox4.Parent := FGraphSidePanel;
    ListBox6.Parent := FGraphSidePanel;
    Chart1.Align := alClient;
    Chart1.Visible := True;
    Chart1.Color := clWhite;
    Chart1.Title.Font.Color := RGBToColor(18, 76, 91);
    Chart1.Title.Font.Style := [fsBold];
  end;

  OnResize := @RecolocarControles;
  RecolocarControles(Self);
end;

procedure TFFamilias.RecolocarControles(Sender: TObject);
const
  Pad = 24;
  Gap = 18;
var
  W, H, ContentW, TopH, BottomY, BottomH, LeftW, RightW: Integer;
  X, Y, FieldX, FieldW, ItemW, I: Integer;
  LabelsStats: array[0..5] of TLabel;
  ValuesStats: array[0..5] of TLabel;
begin
  if not Assigned(FHeaderBar) then Exit;

  W := FHeaderBar.ClientWidth;
  FHeaderTitle.SetBounds(24, 10, Max(360, W - 560), 30);
  FHeaderSubtitle.SetBounds(26, 44, Max(360, W - 560), 22);

  X := Max(590, W - 470);
  Label1.SetBounds(X, 18, 112, 24);
  Edit1.SetBounds(X + 118, 14, 92, 32);
  Label7.SetBounds(X + 224, 14, Max(210, W - X - 242), 32);

  ContentW := Max(760, TabSheet1.ClientWidth - (Pad * 2));
  H := TabSheet1.ClientHeight;
  TopH := 188;
  BottomY := Pad + TopH + Gap;
  BottomH := Max(190, H - BottomY - Pad);
  LeftW := Max(330, (ContentW * 38) div 100);
  RightW := ContentW - LeftW - Gap;

  FCardGeneral.SetBounds(Pad, Pad, ContentW, TopH);
  FTitleGeneral.SetBounds(Pad + 18, Pad + 10, ContentW - 36, 28);

  FCardActivity.SetBounds(Pad, BottomY, LeftW, BottomH);
  FTitleActivity.SetBounds(Pad + 18, BottomY + 10, LeftW - 36, 28);

  FCardNotes.SetBounds(Pad + LeftW + Gap, BottomY, RightW, BottomH);
  FTitleNotes.SetBounds(Pad + LeftW + Gap + 18, BottomY + 10,
    RightW - 36, 28);

  X := Pad + 20;
  FieldX := X + 120;
  FieldW := ContentW - 174;
  Y := Pad + 58;
  Label2.SetBounds(X, Y + 5, 104, 22);
  Edit2.SetBounds(FieldX, Y, Max(260, FieldW - 48), 30);
  BitBtn8.SetBounds(FieldX + Max(260, FieldW - 40), Y, 40, 30);

  Inc(Y, 52);
  Label3.SetBounds(X, Y + 5, 104, 22);
  Edit3.SetBounds(FieldX, Y, 86, 30);
  BitBtn7.SetBounds(FieldX + 94, Y, 40, 30);
  Edit4.SetBounds(FieldX + 144, Y, Max(180, FieldW - 144), 30);

  X := Pad + 20;
  FieldX := X + 116;
  Y := BottomY + 58;
  Label11.SetBounds(X, Y + 5, 100, 22);
  Edit10.SetBounds(FieldX, Y, Max(130, LeftW - 156), 30);
  Inc(Y, 52);
  Label12.SetBounds(X, Y + 5, 100, 22);
  Edit11.SetBounds(FieldX, Y, Max(130, LeftW - 156), 30);

  X := Pad + LeftW + Gap + 20;
  Y := BottomY + 50;
  Label17.SetBounds(X, Y, RightW - 40, 22);
  Memo1.SetBounds(X, Y + 26, RightW - 40, Max(100, BottomH - 92));

  BitBtn2.SetBounds(18, 12, 126, 42);
  BitBtn3.SetBounds(156, 12, 126, 42);
  BitBtn4.SetBounds(294, 12, 126, 42);
  BitBtn5.SetBounds(432, 12, 126, 42);
  BitBtn6.SetBounds(570, 12, 126, 42);
  BitBtn1.SetBounds(Panel1.ClientWidth - 144, 12, 126, 42);

  if Assigned(TabSheet2) and Assigned(FStatsSummaryPanel) then
  begin
    Label57.SetBounds(16, 16, Panel3.ClientWidth - 32, 22);
    ListBox5.SetBounds(16, 44, Panel3.ClientWidth - 32, 160);

    LabelsStats[0] := Label76; ValuesStats[0] := lbUC;
    LabelsStats[1] := Label75; ValuesStats[1] := lbIC;
    LabelsStats[2] := Label68; ValuesStats[2] := lbUV;
    LabelsStats[3] := Label65; ValuesStats[3] := lbIVP;
    LabelsStats[4] := Label4; ValuesStats[4] := lbIVC;
    LabelsStats[5] := Label5; ValuesStats[5] := lbBeneficio;
    ItemW := Max(120, FStatsSummaryPanel.ClientWidth div 6);
    for I := 0 to 5 do
    begin
      LabelsStats[I].SetBounds(I * ItemW + 8, 10, ItemW - 16, 20);
      LabelsStats[I].Alignment := taCenter;
      LabelsStats[I].Font.Style := [fsBold];
      ValuesStats[I].SetBounds(I * ItemW + 8, 34, ItemW - 16, 34);
      ValuesStats[I].Alignment := taCenter;
      ValuesStats[I].Font.Height := -15;
      ValuesStats[I].Font.Style := [fsBold];
    end;
  end;

  if Assigned(TabSheet3) and Assigned(FGraphSidePanel) then
  begin
    Label47.SetBounds(16, 18, 228, 22);
    ListBox3.SetBounds(16, 44, 228, 92);
    Label48.SetBounds(16, 154, 228, 22);
    ListBox4.SetBounds(16, 180, 228, 210);
    Label49.SetBounds(16, 408, 228, 22);
    ListBox6.SetBounds(16, 434, 228,
      Max(90, FGraphSidePanel.ClientHeight - 450));
    FGraphSidePanel.BringToFront;
  end;

  FCardGeneral.SendToBack;
  FCardActivity.SendToBack;
  FCardNotes.SendToBack;
end;

//=============== Crea el formulario ================
procedure ShowFormFamilias;
begin
  with TFFamilias.Create(Application) do
    begin
       ShowModal;
    end;
end;
Procedure TFFamilias.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);    // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbFamilias.Sql.Text:='SELECT * FROM familias'+Tienda+' ORDER BY F0';
  dbFamilias.Active := True;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Familias', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Familias', 3);//------------------ Boton Borrar
  if CheckRoles(dbRoles, CgRol, 'Familias', 4)=False then FreeAndNil(Tabsheet2);//--- Estadisticas
  if CheckRoles(dbRoles, CgRol, 'Familias', 4)=False then FreeAndNil(Tabsheet3);//--- Graficas

  AplicarEstiloModerno;

  { Al abrir el formulario, dejar preparado el campo Código. }
  ActiveControl := Edit1;

  { ESC actúa antes que el control activo. }
  KeyPreview := True;
  OnKeyDown := @FormKeyDown;
end;

procedure TFFamilias.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then Exit;

  { En la página principal equivale exactamente al botón Cerrar. }
  Key := 0;
  BitBtn1Click(nil);
end;

//==================== CERRAR ======================
Procedure TFFamilias.Bitbtn1click(Sender: Tobject);
Begin
  dbFamilias.Active:=False; dbEsta.Active:=False;
  dbGrafica.Active:=False;
  Close();
End;
Procedure TFFamilias.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//=================== REGISTRO NUEVO ===================
Procedure TFFamilias.Bitbtn2click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if dbFamilias.Locate('F0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO YA EXISTE');
      exit;
    end;
   dbFamilias.Append;
   LlenaReg();
   dbFamilias.Post;
   Label7.Caption:=dbFamilias.FieldByName('F1').AsString;
End;
//=================== BORRAR REGISTRO ===================
Procedure TFFamilias.Bitbtn3click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if not dbFamilias.Locate('F0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbFamilias.Delete;
  Edit1.Text := '';
  LimpiaForm();
End;

//=================== MODIFICAR ===================
Procedure TFFamilias.Bitbtn4click(Sender: Tobject);
Begin
   if (Edit1.Text='') or (dbFamilias.Recordcount=0) then exit;
   if not dbFamilias.Locate('F0,', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO!');
       exit;
     end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
   dbFamilias.Edit;
   LlenaReg();
   dbFamilias.Post;
End;

//=================== CODIGO DE LA FAMILIA ================
Procedure TFFamilias.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;
Procedure TFFamilias.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbFamilias.Locate('F0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;
//=====================================================
//================== BUSCAR FAMILIAS ==================
//=====================================================
procedure TFFamilias.BitBtn8Click(Sender: TObject);
begin
  if Edit2.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit2.SetFocus;
     Exit;
  end;
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT F0,F1 FROM familias'+tienda+' WHERE F1 LIKE "%'+Edit2.Text+'%"',
                                         ['Código','Nombre'], 'F0');
  if Edit1.Text='-1' then Edit1.Text:='' else Edit1Exit(Edit1);
end;

procedure TFFamilias.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn8Click(BitBtn8);
end;

//===================== LIMPIAR DATOS =======================
Procedure TFFamilias.LimpiaForm();
Begin
  Edit2.Text:=''; Edit3.Text:=''; Label7.Caption:='';
  Edit10.Text:=''; Edit11.Text:=''; Memo1.Lines.Text:='';
  Edit4.Text:='';
End;

//===================== PINTAR DATOS =======================
Procedure TFFamilias.Relleno();
Begin
  if dbFamilias.RecordCount=0 then exit;
  Label7.Caption:=dbFamilias.FieldByName('F1').AsString;
  Edit1.Text:=dbFamilias.FieldByName('F0').AsString;//-------------- Cgo. Familia
  Edit2.Text:=dbFamilias.FieldByName('F1').AsString;//-------------- Nombre
  Edit3.Text:=dbFamilias.FieldByName('F2').AsString;//-------------- Departamento
  if (Edit3.Text<>'0') and (Edit3.Text<>'') then VerDepartamento();//- Nombre Departam.
  Edit10.Text:=dbFamilias.FieldByName('F3').AsString;//------------- F.Ult.Venta
  Edit11.Text:=dbFamilias.FieldByName('F4').AsString;//------------- F.Ult.Compra
  Memo1.Lines.Text:=dbFamilias.FieldByName('F5').AsString;//-------- Observaciones
  //-------------- Estadisticas --------------------
  if Assigned(TabSheet2) then
  begin
    RellenaEsta(FormatDateTime('YYYY',Date));//--------- Rellenar los meses que esten a 0
    dbEsta.Active:=False;
    dbEsta.SQL.Text:='SELECT *, FF6-FF7 As BENEF FROM estafami'+Tienda+' WHERE FF0="'+Edit1.Text+'"'+
                     ' AND FF1='+FormatDateTime('YYYY',Date)+
                     ' ORDER BY FF1 ASC, FF2 ASC';
    dbEsta.Active:=True;
    FOrdenGridCampo := 'FF1';
    FOrdenGridDireccion := 'ASC';
    ActualizarFlechaGrid(DBGrid1, FOrdenGridCampo, FOrdenGridDireccion);
  end;
  //------------------------------------------------
  if Assigned(TabSheet3) then
  begin
    CargaGrafica:=1;
    try
      Graficas();//---------------- Pintar Graficas
    finally
      CargaGrafica:=0;
    end;
  end;
End;
//===================== RELLENAR DATOS =======================
Procedure TFFamilias.LlenaReg();
Begin
  dbFamilias.FieldByName('F0').AsString:=Edit1.Text;//------------- Codigo
  dbFamilias.FieldByName('F1').AsString:=Edit2.Text;//------------- Nombre
  dbFamilias.FieldByName('F2').AsString:=Edit3.Text;//------------- Departamento
  //------ Fecha Ultima Venta
  if Edit10.Text='' then
    dbFamilias.FieldByName('F3').Value:=Null
  else
    dbFamilias.FieldByName('F3').AsString:=Edit10.Text;
  //------ Fecha Ultima Compra
  if Edit11.Text='' then
    dbFamilias.FieldByName('F4').Value:=Null
  else
    dbFamilias.FieldByName('F4').AsString:=Edit11.Text;
  dbFamilias.FieldByName('F5').AsString:=Memo1.Lines.Text;//------- Observaciones
End;

//==================== REG. ANTERIOR ===============
Procedure TFFamilias.Bitbtn5click(Sender: Tobject);
Begin
  dbFamilias.Prior;
  LimpiaForm(); Relleno();
End;

//==================== REG. POSTERIOR ===============
Procedure TFFamilias.Bitbtn6click(Sender: Tobject);
Begin
   dbFamilias.Next;
   LimpiaForm(); Relleno();
End;

//============================================================
//===================== GRAFICAS =============================
//============================================================
procedure TFFamilias.Graficas();
Var
  Conta: Integer;
begin
  //-------------- Mostrar los distintos años ------------------
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT DISTINCT FF1 FROM estafami'+Tienda+' WHERE FF0="'+Edit1.Text+'" ORDER BY FF1 DESC';
  dbGrafica.Active:=True;
  ListBox3.Items.Clear; ListBox5.Items.Clear;
  dbGrafica.First;
  while not dbGrafica.EOF do
    begin
      ListBox3.Items.Add(dbGrafica.FieldByName('FF1').AsString);
      ListBox5.Items.Add(dbGrafica.FieldByName('FF1').AsString);
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
     dbGrafica.SQL.Text:='SELECT *, FF6-FF7 As BENEF FROM estafami'+Tienda+' WHERE FF0="'+Edit1.Text+'"'+
                         ' AND FF1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                         ' ORDER BY FF1 ASC, FF2 ASC';
     dbGrafica.Active:=True; ListBox6.ItemIndex:=0;
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
procedure TFFamilias.ListBox3Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//------------------ Cambiar datos grafica -------------------
procedure TFFamilias.ListBox4Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//----------------- Cambiar tipo de grafica ----------------
procedure TFFamilias.ListBox6Click(Sender: TObject);
begin
 Chart1Serie1.Active:=False; Chart1AreaSeries1.Active:=False;
 Chart1BarSeries1.Active:=False; Chart1PieSeries1.Active:=False;
 case ListBox6.ItemIndex of
   0: Chart1Serie1.Active:=True;
   1: Chart1BarSeries1.Active:=True;
   2: Chart1AreaSeries1.Active:=True;
   3: Chart1PieSeries1.Active:=True;
 end;
end;

//--------------- Cambiar Grafica -----------------
procedure TFFamilias.CambiarGrafica();
var
  Conta: Integer;
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox3.Items.Count=0 then exit;//----- Si no hay años
  if ListBox3.ItemIndex=-1 then ListBox3.ItemIndex:=0;
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT *, FF6-FF7 As BENEF FROM estafami'+Tienda+' WHERE FF0="'+Edit1.Text+'"'+
                      ' AND FF1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                      ' ORDER BY FF1 ASC, FF2 ASC';
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
procedure TFFamilias.ListBox5Click(Sender: TObject);
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox5.Items.Count=0 then exit;//----- Si no hay años
  if ListBox5.ItemIndex=-1 then ListBox5.ItemIndex:=0;
  RellenaEsta(ListBox5.Items.Strings[ListBox5.ItemIndex]);//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, FF6-FF7 As BENEF FROM estafami'+Tienda+' WHERE FF0="'+Edit1.Text+'"'+
                   ' AND FF1='+ListBox5.Items.Strings[ListBox5.ItemIndex]+
                   ' ORDER BY FF1 ASC, FF2 ASC';
  dbEsta.Active:=True;
end;


//==========================================================
//============= RELLENAR MESES QUE ESTEN A 0 ===============
//==========================================================
procedure TFFamilias.RellenaEsta(Ano: String);
var
  Conta: Integer;
  UC,IC,UV,IVP,IVC,Beneficio : Double;
begin
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT * FROM estafami'+Tienda+' WHERE FF0="'+Edit1.Text+'"'+
                   ' AND FF1='+Ano+
                   ' ORDER BY FF1 ASC, FF2 ASC';
  dbEsta.Active:=True;
  dbEsta.First;

    //*********** IMPLEMENTACIÓN DE MUESTREO DE TOTALES
      UC:=0; IC:=0; UV:=0; IVP:=0; IVC:=0; Beneficio:=0;
      While not dbEsta.EOF do
        begin
          UC := UC + dbEsta.FieldByName('FF3').Value;
          IC := IC + dbEsta.FieldByName('FF4').Value;
          UV := UV + dbEsta.FieldByName('FF5').Value;
          IVP := IVP + dbEsta.FieldByName('FF6').Value;
          IVC := IVC + dbEsta.FieldByName('FF7').Value;
          Beneficio := Beneficio + ( dbEsta.FieldByName('FF6').Value - dbEsta.FieldByName('FF7').Value );
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
      if not dbEsta.Locate('FF2',Conta,[]) then
        begin
           dbEsta.Append;
           dbEsta.FieldByName('FF0').AsString:=Edit1.Text;
           dbEsta.FieldByName('FF1').AsString:=Ano;
           dbEsta.FieldByName('FF2').AsString:=IntToStr(Conta);
           dbEsta.Post;
        end;
    end;
end;

//================ CODIGO DEPARTAMENTO =====================
procedure TFFamilias.Edit3Enter(Sender: TObject);
begin
  Edit4.Text:='';
end;
procedure TFFamilias.Edit3Exit(Sender: TObject);
begin
  if Edit3.Text<>'' then VerDepartamento();
end;

//=============== BUSCAR DEPARTAMENTOS =====================
procedure TFFamilias.BitBtn7Click(Sender: TObject);
begin
  if Edit4.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit4.SetFocus;
     Exit;
  End;
  Edit3.Text:=FBusquedas.IniciaBusquedas('SELECT D0,D1 FROM departamentos'+tienda+' WHERE D1 LIKE "%'+Edit4.Text+'%"',
                                         ['Código','Nombre'], 'D0');
  if Edit3.Text='-1' then Edit3.Text:='' else Edit3Exit(Edit3);
end;

procedure TFFamilias.Edit4KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn7Click(BitBtn7);
end;

//================ PINTAR NOMBRE DEPARTAMENTO ==============
procedure TFFamilias.VerDepartamento();
begin
  Edit4.Text:='';
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT * FROM departamentos'+Tienda+' WHERE D0='+Edit3.Text;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  Edit4.Text:=dbBusca.FieldByName('D1').AsString;
end;


Initialization
  {$I familias.lrs}

End.

