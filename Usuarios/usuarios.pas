{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010

  Antonio Dominguez
  Equipo de colaboradores.

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

Unit Usuarios;

{$mode Objfpc}{$H+}
{$codepage utf8}

Interface

Uses
  Classes, Sysutils, Math, StrUtils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, Inifiles, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType,
  Process, DBGrids, TAGraph, TASeries, LR_DBSet, LR_Class, db, DbCtrls, ExtDlgs;


Type

  { TFUsuarios }

  TFUsuarios = Class(Tform)
    Bevel1: TBevel;
    BitBtn12: TBitBtn;
    BitBtn21: TBitBtn;
    BitBtn7: TBitBtn;
    Chart1: TChart;
    Chart1AreaSeries1: TAreaSeries;
    Chart1BarSeries1: TBarSeries;
    Chart1PieSeries1: TPieSeries;
    Chart1Serie1: TLineSeries;
    Datasource1: TDatasource;
    dbGrafica: TZQuery;
    dbEsta: TZQuery;
    DBGrid1: TDBGrid;
    dbUsuarios: TZQuery;
    dbUsuarios1: TZQuery;
    dbRoles: TZQuery;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
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
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label57: TLabel;
    Label65: TLabel;
    Label68: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbBeneficio: TLabel;
    lbIC: TLabel;
    lbIVC: TLabel;
    lbIVP: TLabel;
    lbUC: TLabel;
    lbUV: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox6: TListBox;
    Memo1: TMemo;
    Edit1: Tedit;
    OpenPictureDialog1: TOpenPictureDialog;
    Panel1: Tpanel;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    Bitbtn4: Tbitbtn;
    Bitbtn5: Tbitbtn;
    Bitbtn6: Tbitbtn;
    Bitbtn1: Tbitbtn;
    Label2: TLabel;
    Pagecontrol1: Tpagecontrol;
    PanelNuevoUs: TPanel;
    Panel3: TPanel;
    Tabsheet2: Ttabsheet;
    Tabsheet3: Ttabsheet;
    TabSheet4: TTabSheet;
    dbTrabajo: TZQuery;

    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure Edit13Enter(Sender: TObject);
    procedure Edit13Exit(Sender: TObject);
    procedure Edit1MouseEnter(Sender: TObject);
    procedure Edit1MouseLeave(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit9Exit(Sender: TObject);
    Procedure Formcreate(Sender: Tobject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    Procedure Edit1enter(Sender: Tobject);
    Procedure Edit1exit(Sender: Tobject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    Procedure LimpiaForm();
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
    
    procedure ListBox1Click(Sender: TObject);
    procedure RellenaEsta(Ano: String);

    procedure Graficas();
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure CambiarGrafica();


  Private
    { Capa visual moderna: no altera consultas ni tratamiento de datos. }
    FHeaderBar: TPanel;
    FHeaderTitle: TLabel;
    FHeaderSubtitle: TLabel;
    FCardContact: TShape;
    FCardPhoto: TShape;
    FCardAccess: TShape;
    FCardNotes: TShape;
    FTitleContact: TLabel;
    FTitlePhoto: TLabel;
    FTitleAccess: TLabel;
    FTitleNotes: TLabel;
    FStatsMainPanel: TPanel;
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
//   IniReader : TIniFile; //quitado por javi no se usa
//   Sections : TStringList;//quitado por javi no se usa
//   Contents : TStringList; //quitado por javi no se usa
  End;

  procedure ShowFormUsuarios;
  
Var
  FUsuarios: TFUsuarios;
  CargaGrafica,NTienda: Integer;
  s: TBarSeries;
  CodUsuSic: String;
  TituloGrid: String;


Implementation

uses
  Global, Funciones, Busquedas;

//============================================================================
//====================== DISEÑO MODERNO Y ADAPTABLE ==========================
//============================================================================
function TFUsuarios.CrearPanelVisual(AParent: TWinControl;
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

function TFUsuarios.CrearTarjetaVisual(AParent: TWinControl;
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

function TFUsuarios.CrearTituloVisual(AParent: TWinControl;
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

procedure TFUsuarios.EstilarBoton(ABoton: TBitBtn;
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

function TFUsuarios.SQLSinOrden(const ASQL: string): string;
var
  P: SizeInt;
begin
  Result := Trim(ASQL);
  P := RPos(' ORDER BY ', UpperCase(Result));
  if P > 0 then Result := Trim(Copy(Result, 1, P - 1));
  if (Result <> '') and (Result[Length(Result)] = ';') then
    Delete(Result, Length(Result), 1);
end;

procedure TFUsuarios.ActualizarFlechaGrid(AGrid: TDBGrid;
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

procedure TFUsuarios.DBGrid1TitleClick(Column: TColumn);
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

procedure TFUsuarios.AplicarEstiloModerno;
var
  I: Integer;
  C: TComponent;
begin
  Caption := 'FacturLinEx · Gestión de usuarios';
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

  FHeaderTitle := CrearTituloVisual(FHeaderBar, 'GESTIÓN DE USUARIOS');
  FHeaderTitle.Font.Height := -20;
  FHeaderTitle.Font.Color := clWhite;
  FHeaderSubtitle := CrearTituloVisual(FHeaderBar,
    'Datos personales, credenciales, roles, estadísticas y actividad');
  FHeaderSubtitle.Font.Height := -11;
  FHeaderSubtitle.Font.Style := [];
  FHeaderSubtitle.Font.Color := RGBToColor(205, 232, 237);

  Label1.Parent := FHeaderBar;
  Edit1.Parent := FHeaderBar;
  Label2.Parent := FHeaderBar;
  PanelNuevoUs.Parent := FHeaderBar;
  Label1.Caption := 'Código de usuario';
  Label1.Transparent := True;
  Label2.Transparent := True;

  PanelNuevoUs.BevelOuter := bvNone;
  PanelNuevoUs.ParentColor := False;
  PanelNuevoUs.Color := RGBToColor(255, 244, 194);
  PanelNuevoUs.ParentFont := False;
  PanelNuevoUs.Font.Name := 'Sans';
  PanelNuevoUs.Font.Height := -12;
  PanelNuevoUs.Font.Style := [fsBold];
  PanelNuevoUs.Font.Color := RGBToColor(92, 68, 0);

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
  TabSheet4.Color := RGBToColor(241, 245, 247);
  if Assigned(TabSheet2) then TabSheet2.Color := RGBToColor(241, 245, 247);
  if Assigned(TabSheet3) then TabSheet3.Color := RGBToColor(241, 245, 247);

  TabSheet4.Caption := ' Ficha del usuario ';
  if Assigned(TabSheet2) then TabSheet2.Caption := ' Estadísticas ';
  if Assigned(TabSheet3) then TabSheet3.Caption := ' Gráficas ';

  FCardContact := CrearTarjetaVisual(TabSheet4, RGBToColor(226, 238, 242));
  FCardPhoto := CrearTarjetaVisual(TabSheet4, RGBToColor(238, 234, 247));
  FCardAccess := CrearTarjetaVisual(TabSheet4, RGBToColor(231, 243, 234));
  FCardNotes := CrearTarjetaVisual(TabSheet4, RGBToColor(250, 244, 226));
  FTitleContact := CrearTituloVisual(TabSheet4, 'DATOS PERSONALES Y CONTACTO');
  FTitlePhoto := CrearTituloVisual(TabSheet4, 'FOTOGRAFÍA');
  FTitleAccess := CrearTituloVisual(TabSheet4, 'ACCESO, SEGURIDAD Y ROL');
  FTitleNotes := CrearTituloVisual(TabSheet4, 'OBSERVACIONES');

  Label16.Caption := 'Nombre';
  Label7.Caption := 'Dirección';
  Label3.Caption := 'Localidad';
  Label5.Caption := 'Código postal';
  Label6.Caption := 'Provincia';
  Label9.Caption := 'Teléfono';
  Label8.Caption := 'NIF';
  Label10.Caption := 'Correo electrónico';
  Label11.Caption := 'Ruta de la imagen';
  Label12.Caption := 'Usuario';
  Label13.Caption := 'Clave de acceso';
  Label14.Caption := 'Tipo de rol';
  Label15.Caption := 'Observaciones';
  Label4.Visible := False;

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
  Label2.Font.Color := clWhite;
  Label2.Font.Style := [fsBold];
  Label2.Font.Height := -13;
  Label2.Layout := tlCenter;

  Edit1.ParentFont := False;
  Edit1.Font.Name := 'Sans';
  Edit1.Font.Height := -13;
  Edit1.Font.Style := [fsBold];
  Edit1.Font.Color := RGBToColor(18, 76, 91);
  Edit1.Color := clWhite;

  Label16.Font.Style := [fsBold];
  Label7.Font.Style := [fsBold];
  Label3.Font.Style := [fsBold];
  Label5.Font.Style := [fsBold];
  Label6.Font.Style := [fsBold];
  Label9.Font.Style := [fsBold];
  Label8.Font.Style := [fsBold];
  Label10.Font.Style := [fsBold];
  Label11.Font.Style := [fsBold];
  Label12.Font.Style := [fsBold];
  Label13.Font.Style := [fsBold];
  Label14.Font.Style := [fsBold];
  Label17.Font.Style := [fsBold];
  Label17.Font.Color := RGBToColor(23, 96, 116);

  Memo1.Color := RGBToColor(255, 253, 247);
  Memo1.Font.Color := RGBToColor(30, 41, 59);
  Memo1.BorderStyle := bsSingle;
  Memo1.ScrollBars := ssAutoVertical;

  Image1.Stretch := True;
  Image1.Proportional := True;
  Image1.Center := True;

  { Recorrido de teclado coherente con la nueva disposición. }
  Edit2.TabOrder := 0;
  BitBtn7.TabOrder := 1;
  Edit3.TabOrder := 2;
  Edit4.TabOrder := 3;
  Edit5.TabOrder := 4;
  Edit6.TabOrder := 5;
  Edit8.TabOrder := 6;
  Edit7.TabOrder := 7;
  Edit10.TabOrder := 8;
  Edit9.TabOrder := 9;
  BitBtn12.TabOrder := 10;
  Edit11.TabOrder := 11;
  Edit12.TabOrder := 12;
  Edit13.TabOrder := 13;
  BitBtn21.TabOrder := 14;
  Memo1.TabOrder := 15;

  EstilarBoton(BitBtn2, RGBToColor(5, 150, 105), True);
  EstilarBoton(BitBtn3, RGBToColor(185, 28, 28), True);
  EstilarBoton(BitBtn4, RGBToColor(18, 76, 91), True);
  EstilarBoton(BitBtn5, RGBToColor(218, 226, 230), False);
  EstilarBoton(BitBtn6, RGBToColor(218, 226, 230), False);
  EstilarBoton(BitBtn1, RGBToColor(71, 85, 105), True);
  EstilarBoton(BitBtn7, RGBToColor(23, 96, 116), True);
  EstilarBoton(BitBtn12, RGBToColor(23, 96, 116), True);
  EstilarBoton(BitBtn21, RGBToColor(91, 73, 133), True);
  BitBtn4.Caption := 'Modificar';
  BitBtn5.Caption := 'Anterior';
  BitBtn6.Caption := 'Siguiente';
  BitBtn7.Hint := 'Buscar usuario por nombre';
  BitBtn12.Hint := 'Seleccionar fotografía';
  BitBtn21.Hint := 'Imprimir documento LOPD del usuario';

  if Assigned(TabSheet2) then
  begin
    Panel3.Align := alRight;
    Panel3.Width := 220;
    Panel3.Caption := '';
    Panel3.BevelOuter := bvNone;
    Panel3.ParentColor := False;
    Panel3.Color := RGBToColor(230, 241, 234);

    FStatsMainPanel := CrearPanelVisual(TabSheet2, RGBToColor(241, 245, 247));
    FStatsMainPanel.Align := alClient;
    DBGrid1.Parent := FStatsMainPanel;
    FStatsSummaryPanel := CrearPanelVisual(FStatsMainPanel, RGBToColor(232, 239, 242));
    FStatsSummaryPanel.Align := alBottom;
    FStatsSummaryPanel.Height := 90;
    FStatsSummaryPanel.BringToFront;

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
    FOrdenGridCampo := 'TUSU1';
    FOrdenGridDireccion := 'ASC';
    ActualizarFlechaGrid(DBGrid1, FOrdenGridCampo, FOrdenGridDireccion);

    Label76.Parent := FStatsSummaryPanel; lbUC.Parent := FStatsSummaryPanel;
    Label75.Parent := FStatsSummaryPanel; lbIC.Parent := FStatsSummaryPanel;
    Label68.Parent := FStatsSummaryPanel; lbUV.Parent := FStatsSummaryPanel;
    Label65.Parent := FStatsSummaryPanel; lbIVP.Parent := FStatsSummaryPanel;
    Label18.Parent := FStatsSummaryPanel; lbIVC.Parent := FStatsSummaryPanel;
    Label19.Parent := FStatsSummaryPanel; lbBeneficio.Parent := FStatsSummaryPanel;

    Label76.Caption := 'U. compradas';
    Label75.Caption := 'Importe comprado';
    Label68.Caption := 'U. vendidas';
    Label65.Caption := 'Venta a PVP';
    Label18.Caption := 'Venta a coste';
    Label19.Caption := 'Beneficio';
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
    ListBox2.Parent := FGraphSidePanel;
    ListBox3.Parent := FGraphSidePanel;
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

procedure TFUsuarios.RecolocarControles(Sender: TObject);
const
  Pad = 20;
  Gap = 16;
var
  W, H, CodeX, PhotoW, ContactW, TopH, AccessY, AccessH, NotesY, NotesH: Integer;
  X, Y, FieldX, FieldW, ItemW, I, BtnW, BtnGap: Integer;
  LabelsStats: array[0..5] of TLabel;
  ValuesStats: array[0..5] of TLabel;
begin
  if not Assigned(FHeaderBar) then Exit;

  W := FHeaderBar.ClientWidth;
  FHeaderTitle.SetBounds(24, 10, Max(350, W - 720), 30);
  FHeaderSubtitle.SetBounds(26, 44, Max(350, W - 720), 22);

  CodeX := Max(500, W - 650);
  Label1.SetBounds(CodeX, 14, 145, 22);
  Edit1.SetBounds(CodeX, 40, 130, 34);
  PanelNuevoUs.SetBounds(CodeX + 138, 40, 98, 34);
  Label2.SetBounds(CodeX + 246, 40, Max(180, W - CodeX - 270), 34);

  W := TabSheet4.ClientWidth;
  H := TabSheet4.ClientHeight;
  PhotoW := Min(250, Max(205, W div 5));
  ContactW := Max(640, W - (Pad * 2) - Gap - PhotoW);
  TopH := Min(270, Max(225, (H * 45) div 100));
  AccessH := Min(130, Max(105, (H * 20) div 100));
  AccessY := Pad + TopH + Gap;
  NotesY := AccessY + AccessH + Gap;
  NotesH := Max(80, H - NotesY - Pad);

  FCardContact.SetBounds(Pad, Pad, ContactW, TopH);
  FTitleContact.SetBounds(Pad + 18, Pad + 8, ContactW - 36, 26);
  FCardPhoto.SetBounds(Pad + ContactW + Gap, Pad, PhotoW, TopH);
  FTitlePhoto.SetBounds(Pad + ContactW + Gap + 18, Pad + 8, PhotoW - 36, 26);
  FCardAccess.SetBounds(Pad, AccessY, W - (Pad * 2), AccessH);
  FTitleAccess.SetBounds(Pad + 18, AccessY + 8, W - (Pad * 2) - 36, 26);
  FCardNotes.SetBounds(Pad, NotesY, W - (Pad * 2), NotesH);
  FTitleNotes.SetBounds(Pad + 18, NotesY + 8, W - (Pad * 2) - 36, 26);

  X := Pad + 18;
  FieldX := X + 112;
  FieldW := ContactW - 148;
  Y := Pad + 38;

  Label16.SetBounds(X, Y + 5, 100, 22);
  Edit2.SetBounds(FieldX, Y, Max(260, FieldW - 46), 29);
  BitBtn7.SetBounds(FieldX + Max(260, FieldW - 38), Y, 38, 29);

  Inc(Y, 32);
  Label7.SetBounds(X, Y + 5, 100, 22);
  Edit3.SetBounds(FieldX, Y, FieldW, 29);

  Inc(Y, 32);
  Label3.SetBounds(X, Y + 5, 100, 22);
  Edit4.SetBounds(FieldX, Y, FieldW, 29);

  Inc(Y, 32);
  Label5.SetBounds(X, Y + 5, 100, 22);
  Edit5.SetBounds(FieldX, Y, 90, 29);
  Label6.SetBounds(FieldX + 106, Y + 5, 78, 22);
  Edit6.SetBounds(FieldX + 190, Y, Max(140, FieldW - 190), 29);

  Inc(Y, 32);
  Label9.SetBounds(X, Y + 5, 100, 22);
  Edit8.SetBounds(FieldX, Y, Max(145, (FieldW - 112) div 2), 29);
  Label8.SetBounds(FieldX + Max(155, (FieldW - 100) div 2) + 16,
    Y + 5, 40, 22);
  Edit7.SetBounds(FieldX + Max(155, (FieldW - 100) div 2) + 60,
    Y, Max(105, FieldW - Max(155, (FieldW - 100) div 2) - 60), 29);

  Inc(Y, 32);
  Label10.SetBounds(X, Y + 5, 100, 22);
  Edit10.SetBounds(FieldX, Y, FieldW, 29);

  X := Pad + ContactW + Gap;
  Bevel1.SetBounds(X + 18, Pad + 38, PhotoW - 36, Max(80, TopH - 112));
  Image1.SetBounds(X + 23, Pad + 43, PhotoW - 46, Max(70, TopH - 122));
  Label11.SetBounds(X + 18, Pad + TopH - 64, PhotoW - 36, 20);
  Edit9.SetBounds(X + 18, Pad + TopH - 40, PhotoW - 64, 29);
  BitBtn12.SetBounds(X + PhotoW - 42, Pad + TopH - 40, 30, 29);

  X := Pad + 18;
  Y := AccessY + 42;
  Label12.SetBounds(X, Y + 5, 60, 22);
  Edit11.SetBounds(X + 66, Y, 170, 29);
  Label13.SetBounds(X + 256, Y + 5, 105, 22);
  Edit12.SetBounds(X + 367, Y, 150, 29);
  Label14.SetBounds(X + 541, Y + 5, 75, 22);
  Edit13.SetBounds(X + 622, Y, 58, 29);
  Label17.SetBounds(X + 690, Y, Max(130, W - X - 690 - 170), 29);
  BitBtn21.SetBounds(W - Pad - 142, Y - 2, 124, 34);

  Memo1.SetBounds(Pad + 18, NotesY + 40, W - (Pad * 2) - 36,
    Max(34, NotesH - 54));
  Label15.Visible := False;

  BtnW := 126;
  BtnGap := Max(10, (Panel1.ClientWidth - 48 - (BtnW * 6)) div 5);
  BitBtn2.SetBounds(24, 12, BtnW, 42);
  BitBtn3.SetBounds(24 + BtnW + BtnGap, 12, BtnW, 42);
  BitBtn4.SetBounds(24 + (BtnW + BtnGap) * 2, 12, BtnW, 42);
  BitBtn5.SetBounds(24 + (BtnW + BtnGap) * 3, 12, BtnW, 42);
  BitBtn6.SetBounds(24 + (BtnW + BtnGap) * 4, 12, BtnW, 42);
  BitBtn1.SetBounds(Panel1.ClientWidth - 24 - BtnW, 12, BtnW, 42);

  if Assigned(TabSheet2) and Assigned(FStatsSummaryPanel) then
  begin
    Label57.SetBounds(16, 16, Panel3.ClientWidth - 32, 22);
    ListBox1.SetBounds(16, 44, Panel3.ClientWidth - 32, 160);

    LabelsStats[0] := Label76; ValuesStats[0] := lbUC;
    LabelsStats[1] := Label75; ValuesStats[1] := lbIC;
    LabelsStats[2] := Label68; ValuesStats[2] := lbUV;
    LabelsStats[3] := Label65; ValuesStats[3] := lbIVP;
    LabelsStats[4] := Label18; ValuesStats[4] := lbIVC;
    LabelsStats[5] := Label19; ValuesStats[5] := lbBeneficio;
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
    ListBox2.SetBounds(16, 44, 228, 92);
    Label48.SetBounds(16, 154, 228, 22);
    ListBox3.SetBounds(16, 180, 228, 190);
    Label49.SetBounds(16, 390, 228, 22);
    ListBox6.SetBounds(16, 416, 228,
      Max(90, FGraphSidePanel.ClientHeight - 432));
    FGraphSidePanel.BringToFront;
  end;

  FCardContact.SendToBack;
  FCardPhoto.SendToBack;
  FCardAccess.SendToBack;
  FCardNotes.SendToBack;
end;

//=============== Crea el formulario ================
procedure ShowFormUsuarios;
begin
  with TFUsuarios.Create(Application) do
    begin
       ShowModal;
    end;
end;

//============ Conexion a la bbdd y carga de datos =========
Procedure TFUsuarios.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.

  //------------------- Tablas ------------------
  dbUsuarios.Sql.Text:='SELECT * FROM usuarios0000 ORDER BY USU0';
  dbUsuarios.Active := True;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Usuarios', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Usuarios', 3);//------------------ Boton Borrar
  if CheckRoles(dbRoles, CgRol, 'Usuarios', 4)=False then
    begin
      FreeAndNil(Tabsheet2);//--- Estadisticas
      FreeAndNil(Tabsheet3);//--- Graficas
    end;

  AplicarEstiloModerno;

  { Al abrir el formulario, dejar preparado el campo Código. }
  PageControl1.ActivePage := TabSheet4;
  ActiveControl := Edit1;
  OnShow := @FormShow;

  { ESC actúa antes que el control activo. }
  KeyPreview := True;
  OnKeyDown := @FormKeyDown;
End;

procedure TFUsuarios.FormShow(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet4;
  ActiveControl := Edit1;
  if Edit1.CanFocus then Edit1.SetFocus;
end;

procedure TFUsuarios.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then Exit;

  { Los diálogos modales (imagen, informes, confirmaciones) gestionan su
    propio ESC. En la página principal equivale exactamente a Cerrar. }
  Key := 0;
  BitBtn1Click(nil);
end;

//==================== IMAGEN =======================
procedure TFUsuarios.Edit9Exit(Sender: TObject);
begin
  if Edit9.Text='' then
    begin
      Image1.Picture:=Nil; Image1.Refresh;
    end;
  if FileExists(Edit9.Text) then
    Image1.Picture.LoadFromFile(Edit9.Text)
  else
    begin
     Image1.Picture:=Nil; Image1.Refresh;
    end;
end;
procedure TFUsuarios.BitBtn12Click(Sender: TObject);
begin
 if openPictureDialog1.Execute then
   begin
     Edit9.Text:=openPictureDialog1.FileName;
     if FileExists(openPictureDialog1.FileName) then
       Image1.Picture.LoadFromFile(openPictureDialog1.FileName)
   end;
end;

//=================== BOTON LOPD ================
procedure TFUsuarios.frReport1GetValue(const ParName: String;
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
end;

procedure TFUsuarios.BitBtn21Click(Sender: TObject);
var
  TxtQuery:String;
begin
      TituloGrid:='LOPD - Firma de privacidad de datos';
      TxtQuery:='SELECT * FROM usuarios'+tienda+' WHERE USU0="'+Edit1.Text+'"';
      dbUsuarios1.Active:=False; dbUsuarios1.Sql.Text:=TxtQuery; dbUsuarios1.Active:=True;
     if (dbUsuarios1.RecordCount=0) then
       begin
         Showmessage('NO HA SELECCIONADO NINGÚN USUARIO');
         exit;
       end;
     frDBDataSet1.DataSet:=dbUsuarios1;
     frReport1.LoadFromFile(RutaReports+'LopdUsuarios.lrf');
     frReport1.ShowReport;
end;

//================= BUSCAR USUARIOS ==================
procedure TFUsuarios.BitBtn7Click(Sender: TObject);
begin
  if Edit2.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit2.SetFocus;
     Exit;
  End;
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT USU0,USU1 FROM usuarios'+Tienda+' WHERE USU1 LIKE "%'+Edit2.Text+'%"',
                                          ['Código','Nombre'],'USU0');
  if Edit1.Text='-1' then Edit1.Text:='' else Edit1Exit(Edit1);
End;
procedure TFUsuarios.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn7Click(BitBtn7);
end;

//==================== CERRAR ======================
Procedure TFUsuarios.Bitbtn1click(Sender: Tobject);
Begin
  Close();
End;
Procedure TFUsuarios.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;
//=================== REGISTRO NUEVO ===================
Procedure TFUsuarios.Bitbtn2click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if dbUsuarios.Locate('USU0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO YA EXISTE');
      exit;
    end;
   dbUsuarios.Append;
   LlenaReg();
   dbUsuarios.Post;
   Label2.Caption:=dbUsuarios.Fields[1].AsString;//--- Refrescar nombre.}
End;
//=================== BORRAR REGISTRO ===================
Procedure TFUsuarios.Bitbtn3click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if not dbUsuarios.Locate('USU0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbUsuarios.Delete;
  Edit1.Text := '';
  LimpiaForm();
End;

//=================== MODIFICAR ===================
Procedure TFUsuarios.Bitbtn4click(Sender: Tobject);
Begin
   if (Edit1.Text='') or (dbUsuarios.Recordcount=0) then exit;
   if not dbUsuarios.Locate('USU0,', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO!');
       exit;
     end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
   dbUsuarios.Edit; LlenaReg(); dbUsuarios.Post;
   Label2.Caption:=dbUsuarios.Fields[1].AsString;//--- Refrescar nombre.}
End;


//==================== REG. ANTERIOR ===============
Procedure TFUsuarios.Bitbtn5click(Sender: Tobject);
Begin
  dbUsuarios.Prior;
  LimpiaForm(); Relleno();
End;

//==================== REG. POSTERIOR ===============
Procedure TFUsuarios.Bitbtn6click(Sender: Tobject);
Begin
   dbUsuarios.Next;
   LimpiaForm(); Relleno();
End;


//=================== CODIGO DE USUARIO ================
Procedure TFUsuarios.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;
Procedure TFUsuarios.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbUsuarios.Locate('USU0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;


//==================== CODIGO DE ROL ======================
procedure TFUsuarios.Edit13Enter(Sender: TObject);
begin
  Label17.Caption:='';
end;
procedure TFUsuarios.Edit13Exit(Sender: TObject);
begin
  if Edit13.Text='' then exit;
  dbRoles.SQL.Text:='SELECT * FROM roles'+Tienda+' WHERE CgoRol='+Edit13.Text;
  dbRoles.Active:=True;
  if dbRoles.RecordCount=0 then exit;
  Label17.Caption:=dbRoles.FieldByName('Descrirol').AsString;
  dbRoles.Active:=False;
end;

procedure TFUsuarios.Edit1MouseEnter(Sender: TObject);
var
  Ultimo : Integer;
begin
  PanelNuevoUs.Visible:=True;
  //------ Ver cual es el ultimo proveedor en nuestro file
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT USU0 FROM usuarios'+Tienda+' where USU0<999990 ORDER BY USU0 DESC';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then Ultimo:=1 else Ultimo:=dbTRabajo.FieldByName('USU0').AsInteger+1;
  //------ Cargar datos en pantalla
  PanelNuevoUs.Caption:=IntToStr(Ultimo);
end;

procedure TFUsuarios.Edit1MouseLeave(Sender: TObject);
begin
  PanelNuevoUs.Visible:=False;
end;



//===================== LIMPIAR DATOS =======================
Procedure TFUsuarios.LimpiaForm();
Begin
  Edit2.Text:=''; Edit3.Text:=''; Edit4.Text:=''; Edit5.Text:='';
  Edit6.Text:=''; Label2.Caption:='';
  Edit7.Text:=''; Edit8.Text:=''; Edit9.Text:=''; Edit10.Text:='';
  Edit11.Text:=''; Edit12.Text:=''; Edit13.Text:='0';
  Memo1.Lines.Text:='';
  Image1.Picture:=Nil;
End;

//===================== PINTAR DATOS =======================
Procedure TFUsuarios.Relleno();
Begin
  if dbUsuarios.RecordCount=0 then exit;
  Label2.Caption:=dbUsuarios.FieldByName('USU1').AsString;
  Edit1.Text:=dbUsuarios.FieldByName('USU0').AsString;//------------ Cgo. Usuario
  Edit2.Text:=dbUsuarios.FieldByName('USU1').AsString;//------------ Nombre
  Edit3.Text:=dbUsuarios.FieldByName('USU2').AsString;//------------ Direccion
  Edit4.Text:=dbUsuarios.FieldByName('USU3').AsString;//------------ Localidad
  Edit5.Text:=dbUsuarios.FieldByName('USU4').AsString;//------------ Codigo p.
  Edit6.Text:=dbUsuarios.FieldByName('USU5').AsString;//------------ Provincia
  Edit7.Text:=dbUsuarios.FieldByName('USU7').AsString;//------------ NIF
  Edit8.Text:=dbUsuarios.FieldByName('USU6').AsString;//------------ Telefono
  Edit10.Text:=dbUsuarios.FieldByName('USU8').AsString;//----------- E-Mail
  Edit11.Text:=dbUsuarios.FieldByName('USU9').AsString;//----------- Usuario
  Edit12.Text:=dbUsuarios.FieldByName('USU10').AsString;//---------- Clave Usuario
  Edit13.Text:=dbUsuarios.FieldByName('USU11').AsString;//---------- Cgo. Rol
  Edit13Exit(Edit13);
  Edit9.Text:=dbUsuarios.FieldByName('USU13').AsString;//------------ Imagen
  if (Edit9.Text<>'') and (FileExists(Edit9.Text)) then
    Image1.Picture.LoadFromFile(Edit9.Text);
  Memo1.Lines.Text:=dbUsuarios.FieldByName('USU12').AsString;//----- Observaciones


  //-------------- Estadisticas --------------------
  if Assigned(TabSheet2) then
  begin
    RellenaEsta(FormatDateTime('YYYY',Date));//--------- Rellenar los meses que esten a 0
    dbEsta.Active:=False;
    dbEsta.SQL.Text:='SELECT *, TUSU6-TUSU7 As BENEF FROM estausu'+Tienda+' WHERE TUSU0="'+Edit1.Text+'"'+
                     ' AND TUSU1='+FormatDateTime('YYYY',Date)+
                     ' ORDER BY TUSU1 ASC, TUSU2 ASC';
    dbEsta.Active:=True;
    FOrdenGridCampo := 'TUSU1';
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
end;

//===================== RELLENAR DATOS =======================
Procedure TFUsuarios.LlenaReg();
Begin
  dbUsuarios.FieldByName('USU0').AsString:=Edit1.Text;//------------ Cgo. Usuario
  dbUsuarios.FieldByName('USU1').AsString:=Edit2.Text;//------------ Nombre
  dbUsuarios.FieldByName('USU2').AsString:=Edit3.Text;//------------ Direccion
  dbUsuarios.FieldByName('USU3').AsString:=Edit4.Text;//------------ Localidad
  dbUsuarios.FieldByName('USU4').AsString:=Edit5.Text;//------------ Codigo p.
  dbUsuarios.FieldByName('USU5').AsString:=Edit6.Text;//------------ Provincia
  dbUsuarios.FieldByName('USU7').AsString:=Edit7.Text;//------------ NIF
  dbUsuarios.FieldByName('USU6').AsString:=Edit8.Text;//------------ Telefono
  dbUsuarios.FieldByName('USU8').AsString:=Edit10.Text;//----------- E-Mail
  dbUsuarios.FieldByName('USU9').AsString:=Edit11.Text;//----------- Usuario
  dbUsuarios.FieldByName('USU10').AsString:=Edit12.Text;;//---------- Clave Usuario
  dbUsuarios.FieldByName('USU11').AsString:=Edit13.Text;;//---------- Nivel de acceso

  dbUsuarios.FieldByName('USU12').AsString:=Memo1.Lines.Text;//----- Observaciones
  dbUsuarios.FieldByName('USU13').AsString:=Edit9.Text;//----------- Imagen


End;


//----------------- Cambiar estadisticas ---------------
procedure TFUsuarios.ListBox1Click(Sender: TObject);
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox1.Items.Count=0 then exit;//----- Si no hay años
  if ListBox1.ItemIndex=-1 then ListBox1.ItemIndex:=0;
  RellenaEsta(ListBox1.Items.Strings[ListBox1.ItemIndex]);//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, TUSU6-TUSU7 As BENEF FROM estausu'+Tienda+' WHERE TUSU0="'+Edit1.Text+'"'+
                   ' AND TUSU1='+ListBox1.Items.Strings[ListBox1.ItemIndex]+
                   ' ORDER BY TUSU1 ASC, TUSU2 ASC';
  dbEsta.Active:=True;
end;

//==========================================================
//============= RELLENAR MESES QUE ESTEN A 0 ===============
//==========================================================
procedure TFUsuarios.RellenaEsta(Ano: String);
var
  Conta: Integer;
  UC,IC,UV,IVP,IVC,Beneficio : Double;
begin
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT * FROM estausu'+Tienda+' WHERE TUSU0="'+Edit1.Text+'"'+
                   ' AND TUSU1='+Ano+
                   ' ORDER BY TUSU1 ASC, TUSU2 ASC';
  dbEsta.Active:=True;
  dbEsta.First;

  //*********** IMPLEMENTACIÓN DE MUESTREO DE TOTALES
    UC:=0; IC:=0; UV:=0; IVP:=0; IVC:=0; Beneficio:=0;
    While not dbEsta.EOF do
      begin
        UC := UC + dbEsta.FieldByName('TUSU3').Value;
        IC := IC + dbEsta.FieldByName('TUSU4').Value;
        UV := UV + dbEsta.FieldByName('TUSU5').Value;
        IVP := IVP + dbEsta.FieldByName('TUSU6').Value;
        IVC := IVC + dbEsta.FieldByName('TUSU7').Value;
        Beneficio := Beneficio + ( dbEsta.FieldByName('TUSU6').Value - dbEsta.FieldByName('TUSU7').Value );
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
      if not dbEsta.Locate('TUSU2',Conta,[]) then
        begin
           dbEsta.Append;
           dbEsta.FieldByName('TUSU0').AsString:=Edit1.Text;
           dbEsta.FieldByName('TUSU1').AsString:=Ano;
           dbEsta.FieldByName('TUSU2').AsString:=IntToStr(Conta);
           dbEsta.Post;
        end;
    end;
end;



//============================================================
//===================== GRAFICAS =============================
//============================================================

procedure TFUsuarios.Graficas();
Var
  Conta: Integer;
begin

  //-------------- Mostrar los distintos años ------------------
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT DISTINCT TUSU1 FROM estausu'+Tienda+' WHERE TUSU0="'+Edit1.Text+'" ORDER BY TUSU1 DESC';
  dbGrafica.Active:=True;
  ListBox1.Items.Clear; ListBox2.Items.Clear;
  dbGrafica.First;
  while not dbGrafica.EOF do
    begin
      ListBox1.Items.Add(dbGrafica.FieldByName('TUSU1').AsString);
      ListBox2.Items.Add(dbGrafica.FieldByName('TUSU1').AsString);
      dbGrafica.Next;
    end;
  ListBox2.ItemIndex:=0;

  //-------------- Mostrar las unidades compradas ------------------

  if ListBox2.Items.Count<>0 then
    begin
     ListBox2.ItemIndex:=0;
     Chart1Serie1.Clear; Chart1AreaSeries1.Clear;
     Chart1BarSeries1.Clear; Chart1PieSeries1.Clear;
     dbGrafica.Active:=False;
     dbGrafica.SQL.Text:='SELECT *, TUSU6-TUSU7 As BENEF FROM estausu'+Tienda+' WHERE TUSU0="'+Edit1.Text+'"'+
                         ' AND TUSU1='+ListBox2.Items.Strings[ListBox2.ItemIndex]+
                         ' ORDER BY TUSU1 ASC, TUSU2 ASC';
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
procedure TFUsuarios.ListBox2Click(Sender: TObject);
begin
  CambiarGrafica();
end;

//------------------ Cambiar datos grafica -------------------
procedure TFUsuarios.ListBox3Click(Sender: TObject);
begin
  CambiarGrafica();
end;

//----------------- Cambiar tipo de grafica ----------------
procedure TFUsuarios.ListBox6Click(Sender: TObject);
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

procedure TFUsuarios.CambiarGrafica();
var
  Conta: Integer;
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox2.Items.Count=0 then exit;//----- Si no hay años
  if ListBox2.ItemIndex=-1 then ListBox2.ItemIndex:=0;
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT *, TUSU6-TUSU7 As BENEF FROM estausu'+Tienda+' WHERE TUSU0="'+Edit1.Text+'"'+
                      ' AND TUSU1='+ListBox2.Items.Strings[ListBox2.ItemIndex]+
                      ' ORDER BY TUSU1 ASC, TUSU2 ASC';
  dbGrafica.Active:=True;
  Chart1Serie1.Clear; Chart1AreaSeries1.Clear;
  Chart1BarSeries1.Clear; Chart1PieSeries1.Clear;
  if ListBox3.ItemIndex=-1 then ListBox3.ItemIndex:=0;
  dbGrafica.First; Chart1.Title.Text.Text:=ListBox3.Items.Strings[ListBox3.ItemIndex];
  for conta:=1 to dbGrafica.RecordCount do
    begin
     Chart1Serie1.AddXY(conta,dbGrafica.Fields[ListBox3.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox3.ItemIndex+3].AsFloat), clred);
     Chart1AreaSeries1.AddXY(conta,dbGrafica.Fields[ListBox3.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox3.ItemIndex+3].AsFloat), clred);
     Chart1BarSeries1.AddXY(conta,dbGrafica.Fields[ListBox3.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox3.ItemIndex+3].AsFloat), clred);
     Chart1PieSeries1.AddXY(conta,dbGrafica.Fields[ListBox3.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox3.ItemIndex+3].AsFloat), clred);
     dbGrafica.Next;
    end;
end;


Initialization
  {$I usuarios.lrs}

End.

