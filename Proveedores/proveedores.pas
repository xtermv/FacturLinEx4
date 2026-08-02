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

Unit Proveedores;

{$mode Objfpc}{$H+}
{$codepage utf8}

Interface

Uses
  Classes, Sysutils, StrUtils, Math, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType, DBGrids,
  TAGraph, TASeries, db, DbCtrls, DateUtils, EditBtn;


Type

  { TFProveedores }

  TFProveedores = Class(Tform)
    Bevel1: TBevel;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    Chart1: TChart;
    Chart1AreaSeries1: TAreaSeries;
    Chart1BarSeries1: TBarSeries;
    Chart1PieSeries1: TPieSeries;
    Chart1Serie1: TLineSeries;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    DateEdit3: TDateEdit;
    DateEdit4: TDateEdit;
    dbRoles: TZQuery;
    dbCliSic: TZQuery;
    dbTrabajo: TZQuery;
    dbBusca: TZQuery;
    Edit48: TEdit;
    Edit49: TEdit;
    Edit51: TEdit;
    Label19: TLabel;
    Label25: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
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
    ListBox1: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    ListBox6: TListBox;
    ListBox7: TListBox;
    PanelNuevoPro: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    SicConnect: TZConnection;
    dbGrafica: TZQuery;
    dbHisto: TZQuery;
    DBGrid2: TDBGrid;
    dbPagos: TZQuery;
    DBGrid1: TDBGrid;
    dbEsta: TZQuery;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit29: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit37: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Edit40: TEdit;
    Edit41: TEdit;
    Edit42: TEdit;
    Edit45: TEdit;
    Edit46: TEdit;
    Edit47: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
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
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label31: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label49: TLabel;
    Label57: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox2: TListBox;
    ListBox5: TListBox;
    Memo1: TMemo;
    Edit1: Tedit;
    dbProve: TZQuery;
    Panel1: Tpanel;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    Bitbtn4: Tbitbtn;
    Bitbtn5: Tbitbtn;
    Bitbtn6: Tbitbtn;
    Bitbtn1: Tbitbtn;
    Label7: Tlabel;
    Pagecontrol1: Tpagecontrol;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel5: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Tabsheet1: Ttabsheet;
    Tabsheet2: Ttabsheet;
    Tabsheet3: Ttabsheet;
    TabSheet4: TTabSheet;
    Label2: Tlabel;
    Label3: Tlabel;
    Label4: Tlabel;
    Label5: Tlabel;
    Label6: Tlabel;
    Edit2: Tedit;
    Edit3: Tedit;
    Edit4: Tedit;
    Edit5: Tedit;
    Edit6: Tedit;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure DateEdit1Exit(Sender: TObject);
    procedure DateEdit2Exit(Sender: TObject);
    procedure DateEdit3Exit(Sender: TObject);
    procedure DateEdit4Exit(Sender: TObject);
    procedure Edit12Enter(Sender: TObject);
    procedure Edit12Exit(Sender: TObject);
    procedure Edit15Enter(Sender: TObject);
    procedure Edit15Exit(Sender: TObject);
    procedure Edit1MouseEnter(Sender: TObject);
    procedure Edit1MouseLeave(Sender: TObject);
    procedure Edit22Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    Procedure Formcreate(Sender: Tobject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    Procedure Edit1enter(Sender: Tobject);
    Procedure Edit1exit(Sender: Tobject);
    Procedure LimpiaForm();
    procedure ListBox2DblClick(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure ListBox4Click(Sender: TObject);
    procedure ListBox5Click(Sender: TObject);
    procedure ListBox6DblClick(Sender: TObject);
    procedure ListBox7Click(Sender: TObject);
    Procedure Relleno();
    Procedure LlenaReg();
    Procedure VerTipoPago();
    Procedure VerRutas();
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
    procedure GrabarModificarSic();
    procedure BorrarSic();
    procedure RellenaSIC();
    procedure CargaSIC();
    function LeerClienteSic: Boolean;
    

  Private
    { Capa visual moderna: no altera consultas ni tratamiento de datos. }
    FHeaderBar: TPanel;
    FHeaderTitle: TLabel;
    FHeaderSubtitle: TLabel;

    FGeneralContactCard: TShape;
    FGeneralTermsCard: TShape;
    FGeneralNotesCard: TShape;
    FGeneralContactTitle: TLabel;
    FGeneralTermsTitle: TLabel;
    FGeneralNotesTitle: TLabel;

    FInvoiceTermsCard: TShape;
    FDeliveryCard: TShape;
    FInvoiceTermsTitle: TLabel;
    FDeliveryTitle: TLabel;

    FBankDataCard: TShape;
    FBankAccountsCard: TShape;
    FBankDataTitle: TLabel;
    FBankAccountsTitle: TLabel;

    FHistoryTitle: TLabel;
    FStatsSummaryPanel: TPanel;
    FChartsSidePanel: TPanel;

    FBtnNombreVisual: TPanel;
    FBtnEmailVisual: TPanel;
    FBtnPagoVisual: TPanel;
    FBtnRutaVisual: TPanel;
    FBtnCerrarPagoVisual: TPanel;
    FBtnCerrarRutaVisual: TPanel;
    FBtnCerrarSICVisual: TPanel;

    FOrdenGrid1Campo: string;
    FOrdenGrid1Direccion: string;
    FOrdenGrid2Campo: string;
    FOrdenGrid2Direccion: string;

    function CrearPanelVisual(AParent: TWinControl; AColor: TColor): TPanel;
    function CrearTarjetaVisual(AParent: TWinControl; AColor: TColor): TShape;
    function CrearTituloVisual(AParent: TWinControl;
      const ACaption: string): TLabel;
    procedure EstilarBoton(ABoton: TBitBtn; AColor: TColor;
      ATextoClaro: Boolean);
    procedure PrepararBotonVisual(APanel: TPanel;
      AOnClick: TNotifyEvent; const ACaption, AHint: string;
      AColor: TColor);
    procedure BotonVisualKeyPress(Sender: TObject; var Key: char);
    procedure BotonEmailVisualClick(Sender: TObject);

    procedure AplicarEstiloModerno;
    procedure ReorganizarFormulario;
    procedure FormResizeModerno(Sender: TObject);

    function SQLSinOrden(const ASQL: string): string;
    procedure ActualizarFlechaGrid(AGrid: TDBGrid;
      const ACampo, ADireccion: string);
    procedure OrdenarGrid(AQuery: TZQuery; AGrid: TDBGrid;
      AColumn: TColumn; var ACampo, ADireccion: string);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure ConfigurarOrdenacionGrids;
  Public
    { Public Declarations }
  End;

  procedure ShowFormProveedores;
  
Var
  FProveedores: TFProveedores;
  CargaGrafica, NTienda: Integer;
  s: TBarSeries;
  CodClienteSic: String;

Implementation

uses
  Global, Funciones, Busquedas, uFLXTemaVisual;
  


function FLXTextoUTF8Seguro(const ATexto: string): string;
var
  I, Codigo: Integer;
  Hexa: string;
  TextoUnicode: UnicodeString;
begin
  TextoUnicode := '';
  I := 1;

  while I <= Length(ATexto) do
  begin
    if (ATexto[I] = #92) and
       (I + 5 <= Length(ATexto)) and
       (ATexto[I + 1] in ['u', 'U']) then
    begin
      Hexa := Copy(ATexto, I + 2, 4);
      Codigo := StrToIntDef('$' + Hexa, -1);
      if Codigo >= 0 then
      begin
        TextoUnicode := TextoUnicode + UnicodeString(WideChar(Codigo));
        Inc(I, 6);
        Continue;
      end;
    end;

    TextoUnicode := TextoUnicode +
      UnicodeString(WideChar(Ord(ATexto[I])));
    Inc(I);
  end;

  Result := UTF8Encode(TextoUnicode);
end;


//============================================================================
//====================== DISEÑO MODERNO Y ADAPTABLE ==========================
//============================================================================
function TFProveedores.CrearPanelVisual(AParent: TWinControl;
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
  Result.SendToBack;
end;

function TFProveedores.CrearTarjetaVisual(AParent: TWinControl;
  AColor: TColor): TShape;
begin
  // TShape evita que los fondos dinámicos oculten TLabel, TCheckBox o
  // TBitBtn en Lazarus/GTK. Es el mismo sistema validado en Clientes.
  Result := TShape.Create(Self);
  Result.Parent := AParent;
  Result.Shape := stRectangle;
  Result.Brush.Style := bsSolid;
  Result.Brush.Color := AColor;
  Result.Pen.Style := psSolid;
  Result.Pen.Color := RGBToColor(218, 226, 230);
  Result.Pen.Width := 1;
  Result.SendToBack;
end;

function TFProveedores.CrearTituloVisual(AParent: TWinControl;
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
  Result.Font.Height := -12;
  Result.Font.Style := [fsBold];
  Result.Font.Color := RGBToColor(38, 77, 96);
end;

procedure TFProveedores.EstilarBoton(ABoton: TBitBtn;
  AColor: TColor; ATextoClaro: Boolean);
begin
  if not Assigned(ABoton) then
    Exit;

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

procedure TFProveedores.PrepararBotonVisual(APanel: TPanel;
  AOnClick: TNotifyEvent; const ACaption, AHint: string;
  AColor: TColor);
var
  LTexto: TLabel;
begin
  if not Assigned(APanel) then
    Exit;

  APanel.Caption := '';
  APanel.BevelOuter := bvRaised;
  APanel.BevelInner := bvNone;
  APanel.BorderWidth := 2;
  APanel.ParentColor := False;
  APanel.Color := AColor;
  APanel.Cursor := crHandPoint;
  APanel.Hint := AHint;
  APanel.ShowHint := True;
  APanel.OnClick := AOnClick;
  APanel.OnKeyPress := @BotonVisualKeyPress;
  APanel.Visible := True;
  APanel.Enabled := True;
  APanel.TabStop := True;

  LTexto := TLabel.Create(APanel);
  LTexto.Parent := APanel;
  LTexto.Align := alClient;
  LTexto.Alignment := taCenter;
  LTexto.Layout := tlCenter;
  LTexto.AutoSize := False;
  LTexto.Transparent := False;
  LTexto.ParentColor := False;
  LTexto.Color := AColor;
  LTexto.ParentFont := False;
  LTexto.Font.Name := 'Sans';
  LTexto.Font.Height := -12;
  LTexto.Font.Style := [fsBold];
  LTexto.Font.Color := clWhite;
  LTexto.Cursor := crHandPoint;
  LTexto.Caption := ACaption;
  LTexto.Hint := AHint;
  LTexto.ShowHint := True;
  LTexto.OnClick := AOnClick;
  LTexto.BringToFront;
end;

procedure TFProveedores.BotonVisualKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = #13) or (Key = #32) then
  begin
    if (Sender is TPanel) and Assigned(TPanel(Sender).OnClick) then
      TPanel(Sender).OnClick(Sender);
    Key := #0;
  end;
end;

procedure TFProveedores.BotonEmailVisualClick(Sender: TObject);
begin
  // El botón original no trae OnClick en los archivos recibidos. Se invoca
  // su Click para conservar cualquier Action que pueda asignarse externamente.
  BitBtn9.Click;
end;


//============================================================================
//======================= ORDENACIÓN DE LOS GRIDS ============================
//============================================================================
function TFProveedores.SQLSinOrden(const ASQL: string): string;
var
  P: SizeInt;
begin
  Result := Trim(ASQL);
  P := RPos(' ORDER BY ', UpperCase(Result));
  if P > 0 then
    Result := Trim(Copy(Result, 1, P - 1));

  if (Result <> '') and (Result[Length(Result)] = ';') then
    Delete(Result, Length(Result), 1);
end;

procedure TFProveedores.ActualizarFlechaGrid(AGrid: TDBGrid;
  const ACampo, ADireccion: string);
var
  I: Integer;
  Titulo, FlechaArriba, FlechaAbajo: string;
begin
  if not Assigned(AGrid) then
    Exit;

  FlechaArriba := FLXTextoUTF8Seguro('\u25B2');
  FlechaAbajo := FLXTextoUTF8Seguro('\u25BC');

  for I := 0 to AGrid.Columns.Count - 1 do
  begin
    Titulo := AGrid.Columns[I].Title.Caption;
    Titulo := StringReplace(Titulo, ' ' + FlechaArriba, '',
      [rfReplaceAll]);
    Titulo := StringReplace(Titulo, ' ' + FlechaAbajo, '',
      [rfReplaceAll]);

    if SameText(AGrid.Columns[I].FieldName, ACampo) then
    begin
      if SameText(ADireccion, 'DESC') then
        Titulo := Titulo + ' ' + FlechaAbajo
      else
        Titulo := Titulo + ' ' + FlechaArriba;
    end;

    AGrid.Columns[I].Title.Caption := Titulo;
  end;
end;

procedure TFProveedores.OrdenarGrid(AQuery: TZQuery; AGrid: TDBGrid;
  AColumn: TColumn; var ACampo, ADireccion: string);
var
  Campo, BaseSQL: string;
begin
  if (not Assigned(AQuery)) or (not Assigned(AGrid)) or
     (not Assigned(AColumn)) then
    Exit;

  Campo := Trim(AColumn.FieldName);
  if Campo = '' then
    Exit;

  if SameText(ACampo, Campo) then
  begin
    if SameText(ADireccion, 'ASC') then
      ADireccion := 'DESC'
    else
      ADireccion := 'ASC';
  end
  else
  begin
    ACampo := Campo;
    ADireccion := 'ASC';
  end;

  BaseSQL := SQLSinOrden(AQuery.SQL.Text);
  if BaseSQL = '' then
    Exit;

  AQuery.DisableControls;
  try
    AQuery.Close;
    AQuery.SQL.Text :=
      BaseSQL + ' ORDER BY `' + Campo + '` ' + ADireccion;
    AQuery.Open;
  finally
    AQuery.EnableControls;
  end;

  ActualizarFlechaGrid(AGrid, ACampo, ADireccion);
end;

procedure TFProveedores.DBGrid1TitleClick(Column: TColumn);
begin
  OrdenarGrid(dbEsta, DBGrid1, Column,
    FOrdenGrid1Campo, FOrdenGrid1Direccion);
end;

procedure TFProveedores.DBGrid2TitleClick(Column: TColumn);
begin
  OrdenarGrid(dbHisto, DBGrid2, Column,
    FOrdenGrid2Campo, FOrdenGrid2Direccion);
end;

procedure TFProveedores.ConfigurarOrdenacionGrids;
begin
  if Assigned(TabSheet2) then
  begin
    DBGrid1.OnTitleClick := @DBGrid1TitleClick;
    FOrdenGrid1Campo := 'PP1';
    FOrdenGrid1Direccion := 'ASC';
    ActualizarFlechaGrid(DBGrid1,
      FOrdenGrid1Campo, FOrdenGrid1Direccion);
  end;

  DBGrid2.OnTitleClick := @DBGrid2TitleClick;
  FOrdenGrid2Campo := 'HPD1';
  FOrdenGrid2Direccion := 'DESC';
  ActualizarFlechaGrid(DBGrid2,
    FOrdenGrid2Campo, FOrdenGrid2Direccion);
end;


//============================================================================
//======================== APLICACIÓN DEL ESTILO =============================
//============================================================================
procedure TFProveedores.AplicarEstiloModerno;
var
  I: Integer;
  C: TComponent;
  G: TDBGrid;
begin
  Caption := 'FacturLinEx · Gestión de proveedores';
  Color := RGBToColor(241, 245, 247);
  Font.Name := 'Sans';
  Font.Height := -12;
  Constraints.MinWidth := 1020;
  Constraints.MinHeight := 680;

  FHeaderBar := CrearPanelVisual(Self, RGBToColor(18, 76, 91));
  FHeaderBar.Align := alTop;
  FHeaderBar.Height := 92;

  FHeaderTitle := CrearTituloVisual(FHeaderBar,
    'GESTIÓN DE PROVEEDORES');
  FHeaderTitle.Font.Height := -20;
  FHeaderTitle.Font.Color := clWhite;

  FHeaderSubtitle := CrearTituloVisual(FHeaderBar,
    'Datos generales, facturación, compras y análisis');
  FHeaderSubtitle.Font.Height := -11;
  FHeaderSubtitle.Font.Style := [];
  FHeaderSubtitle.Font.Color := RGBToColor(205, 232, 237);

  Label1.Parent := FHeaderBar;
  Edit1.Parent := FHeaderBar;
  Label7.Parent := FHeaderBar;
  BitBtn15.Parent := FHeaderBar;
  PanelNuevoPro.Parent := FHeaderBar;

  Panel1.Align := alBottom;
  Panel1.Height := 64;
  Panel1.Caption := '';
  Panel1.BevelOuter := bvNone;
  Panel1.BevelInner := bvNone;
  Panel1.ParentColor := False;
  Panel1.Color := RGBToColor(225, 233, 236);

  PageControl1.Align := alClient;
  PageControl1.Font.Name := 'Sans';
  PageControl1.Font.Height := -12;
  PageControl1.Color := RGBToColor(241, 245, 247);

  TabSheet1.Color := RGBToColor(241, 245, 247);
  TabSheet6.Color := RGBToColor(241, 245, 247);
  if Assigned(TabSheet4) then
    TabSheet4.Color := RGBToColor(241, 245, 247);
  if Assigned(TabSheet5) then
    TabSheet5.Color := RGBToColor(241, 245, 247);
  if Assigned(TabSheet2) then
    TabSheet2.Color := RGBToColor(241, 245, 247);
  if Assigned(TabSheet3) then
    TabSheet3.Color := RGBToColor(241, 245, 247);

  // General.
  FGeneralContactCard := CrearTarjetaVisual(TabSheet1,
    RGBToColor(226, 238, 242));
  FGeneralTermsCard := CrearTarjetaVisual(TabSheet1,
    RGBToColor(231, 243, 234));
  FGeneralNotesCard := CrearTarjetaVisual(TabSheet1,
    RGBToColor(239, 235, 247));
  FGeneralContactTitle := CrearTituloVisual(TabSheet1,
    'IDENTIFICACIÓN Y CONTACTO');
  FGeneralTermsTitle := CrearTituloVisual(TabSheet1,
    'CONDICIONES Y RUTA');
  FGeneralNotesTitle := CrearTituloVisual(TabSheet1,
    'AVISOS Y OBSERVACIONES');

  FBtnNombreVisual := TPanel.Create(Self);
  FBtnNombreVisual.Parent := TabSheet1;
  PrepararBotonVisual(FBtnNombreVisual, @BitBtn18Click, '...',
    'Buscar proveedor por razón social',
    RGBToColor(23, 96, 116));
  FBtnNombreVisual.TabOrder := BitBtn18.TabOrder;

  FBtnEmailVisual := TPanel.Create(Self);
  FBtnEmailVisual.Parent := TabSheet1;
  PrepararBotonVisual(FBtnEmailVisual, @BotonEmailVisualClick, '...',
    'Acción de correo electrónico',
    RGBToColor(23, 96, 116));
  FBtnEmailVisual.TabOrder := BitBtn9.TabOrder;

  FBtnPagoVisual := TPanel.Create(Self);
  FBtnPagoVisual.Parent := TabSheet1;
  PrepararBotonVisual(FBtnPagoVisual, @BitBtn7Click, '...',
    'Seleccionar tipo de cobro',
    RGBToColor(23, 96, 116));
  FBtnPagoVisual.TabOrder := BitBtn7.TabOrder;

  FBtnRutaVisual := TPanel.Create(Self);
  FBtnRutaVisual.Parent := TabSheet1;
  PrepararBotonVisual(FBtnRutaVisual, @BitBtn8Click, '...',
    'Seleccionar distintivo o ruta',
    RGBToColor(23, 96, 116));
  FBtnRutaVisual.TabOrder := BitBtn8.TabOrder;

  // Ventanas auxiliares de General.
  Panel5.BevelOuter := bvNone;
  Panel5.ParentColor := False;
  Panel5.Color := RGBToColor(226, 238, 242);
  Panel7.BevelOuter := bvNone;
  Panel7.ParentColor := False;
  Panel7.Color := RGBToColor(231, 243, 234);
  Panel6.BevelOuter := bvNone;
  Panel6.ParentColor := False;
  Panel6.Color := RGBToColor(226, 238, 242);

  FBtnCerrarPagoVisual := TPanel.Create(Self);
  FBtnCerrarPagoVisual.Parent := Panel5;
  PrepararBotonVisual(FBtnCerrarPagoVisual, @BitBtn10Click, 'X',
    'Cerrar tipos de cobro', RGBToColor(185, 28, 28));
  FBtnCerrarPagoVisual.TabOrder := BitBtn10.TabOrder;

  FBtnCerrarRutaVisual := TPanel.Create(Self);
  FBtnCerrarRutaVisual.Parent := Panel7;
  PrepararBotonVisual(FBtnCerrarRutaVisual, @BitBtn16Click, 'X',
    'Cerrar distintivos o rutas', RGBToColor(185, 28, 28));
  FBtnCerrarRutaVisual.TabOrder := BitBtn16.TabOrder;

  FBtnCerrarSICVisual := TPanel.Create(Self);
  FBtnCerrarSICVisual.Parent := Panel6;
  PrepararBotonVisual(FBtnCerrarSICVisual, @BitBtn14Click, 'X',
    'Cerrar búsqueda SIC', RGBToColor(185, 28, 28));
  FBtnCerrarSICVisual.TabOrder := BitBtn14.TabOrder;

  // Facturación.
  if Assigned(TabSheet4) then
  begin
    FInvoiceTermsCard := CrearTarjetaVisual(TabSheet4,
      RGBToColor(226, 238, 242));
    FDeliveryCard := CrearTarjetaVisual(TabSheet4,
      RGBToColor(231, 243, 234));
    FInvoiceTermsTitle := CrearTituloVisual(TabSheet4,
      'CONDICIONES DE FACTURACIÓN Y PAGO');
    FDeliveryTitle := CrearTituloVisual(TabSheet4,
      'TRANSPORTE Y DATOS DE ENTREGA');
    Bevel1.Visible := False;
  end;

  // Datos bancarios.
  if Assigned(TabSheet5) then
  begin
    FBankDataCard := CrearTarjetaVisual(TabSheet5,
      RGBToColor(226, 238, 242));
    FBankAccountsCard := CrearTarjetaVisual(TabSheet5,
      RGBToColor(242, 238, 226));
    FBankDataTitle := CrearTituloVisual(TabSheet5,
      'ENTIDAD Y CUENTA BANCARIA');
    FBankAccountsTitle := CrearTituloVisual(TabSheet5,
      'CUENTAS CONTABLES');
  end;

  // Histórico de compras.
  Panel2.BevelOuter := bvNone;
  Panel2.BevelInner := bvNone;
  Panel2.ParentColor := False;
  Panel2.Color := RGBToColor(226, 238, 242);
  FHistoryTitle := CrearTituloVisual(Panel2, 'FILTROS DEL HISTÓRICO');
  FHistoryTitle.Alignment := taCenter;

  // Estadísticas.
  if Assigned(TabSheet2) then
  begin
    FStatsSummaryPanel := CrearPanelVisual(TabSheet2,
      RGBToColor(231, 243, 234));
    FStatsSummaryPanel.Align := alBottom;
    FStatsSummaryPanel.Height := 92;

    Label76.Parent := FStatsSummaryPanel;
    lbUC.Parent := FStatsSummaryPanel;
    Label75.Parent := FStatsSummaryPanel;
    lbIC.Parent := FStatsSummaryPanel;
    Label68.Parent := FStatsSummaryPanel;
    lbUV.Parent := FStatsSummaryPanel;
    Label65.Parent := FStatsSummaryPanel;
    lbIVP.Parent := FStatsSummaryPanel;
    Label19.Parent := FStatsSummaryPanel;
    lbIVC.Parent := FStatsSummaryPanel;
    Label25.Parent := FStatsSummaryPanel;
    lbBeneficio.Parent := FStatsSummaryPanel;

    Panel3.Align := alRight;
    Panel3.Width := 210;
    Panel3.BevelOuter := bvNone;
    Panel3.ParentColor := False;
    Panel3.Color := RGBToColor(226, 238, 242);
    DBGrid1.Align := alClient;
    DBGrid1.BorderSpacing.Bottom := 0;
  end;

  // Gráficas.
  if Assigned(TabSheet3) then
  begin
    FChartsSidePanel := CrearPanelVisual(TabSheet3,
      RGBToColor(226, 238, 242));
    FChartsSidePanel.Align := alRight;
    FChartsSidePanel.Width := 235;

    Label47.Parent := FChartsSidePanel;
    ListBox3.Parent := FChartsSidePanel;
    Label48.Parent := FChartsSidePanel;
    ListBox4.Parent := FChartsSidePanel;
    Label56.Parent := FChartsSidePanel;
    ListBox7.Parent := FChartsSidePanel;

    Chart1.Align := alClient;
    Chart1.Color := RGBToColor(250, 251, 252);
    Chart1.Visible := True;
  end;

  // Aspecto uniforme de todos los controles que siguen existiendo tras
  // aplicar los permisos del usuario.
  for I := 0 to ComponentCount - 1 do
  begin
    C := Components[I];

    if C is TDateEdit then
    begin
      TDateEdit(C).ParentFont := False;
      TDateEdit(C).Font.Name := 'Sans';
      TDateEdit(C).Font.Height := -12;
      TDateEdit(C).Height := 29;
      TDateEdit(C).Color := clWhite;
    end
    else if C is TEdit then
    begin
      TEdit(C).ParentFont := False;
      TEdit(C).Font.Name := 'Sans';
      TEdit(C).Font.Height := -12;
      TEdit(C).Height := 29;
      if TEdit(C).ReadOnly then
        TEdit(C).Color := RGBToColor(244, 246, 248)
      else
        TEdit(C).Color := clWhite;
    end
    else if C is TMemo then
    begin
      TMemo(C).ParentFont := False;
      TMemo(C).Font.Name := 'Sans';
      TMemo(C).Font.Height := -12;
      TMemo(C).Color := clWhite;
    end
    else if C is TListBox then
    begin
      TListBox(C).ParentFont := False;
      TListBox(C).Font.Name := 'Sans';
      TListBox(C).Font.Height := -12;
      TListBox(C).Color := clWhite;
    end
    else if C is TCheckBox then
    begin
      TCheckBox(C).ParentFont := False;
      TCheckBox(C).Font.Name := 'Sans';
      TCheckBox(C).Font.Height := -12;
      TCheckBox(C).Font.Color := RGBToColor(51, 65, 85);
    end
    else if C is TLabel then
    begin
      TLabel(C).ParentFont := False;
      TLabel(C).Font.Name := 'Sans';
      if TLabel(C).Font.Height > -12 then
        TLabel(C).Font.Height := -12;
      TLabel(C).Font.Color := RGBToColor(51, 65, 85);
      TLabel(C).Transparent := True;
    end
    else if C is TStaticText then
    begin
      TStaticText(C).ParentFont := False;
      TStaticText(C).Font.Name := 'Sans';
      TStaticText(C).Font.Height := -12;
      TStaticText(C).Font.Color := RGBToColor(51, 65, 85);
      TStaticText(C).Color := RGBToColor(248, 250, 252);
    end
    else if C is TBitBtn then
    begin
      TBitBtn(C).ParentFont := False;
      TBitBtn(C).Font.Name := 'Sans';
      TBitBtn(C).Font.Height := -11;
      TBitBtn(C).Font.Style := [fsBold];
      TBitBtn(C).ShowHint := True;
    end
    else if C is TDBGrid then
    begin
      G := TDBGrid(C);
      G.ParentFont := False;
      G.Font.Name := 'Sans';
      G.Font.Height := -12;
      G.Font.Color := RGBToColor(30, 41, 59);
      G.TitleFont.Name := 'Sans';
      G.TitleFont.Height := -11;
      G.TitleFont.Style := [fsBold];
      G.TitleFont.Color := clWhite;
      G.Color := clWhite;
      G.FixedColor := RGBToColor(18, 76, 91);
      G.GridLineColor := RGBToColor(203, 213, 225);
      G.AlternateColor := RGBToColor(248, 250, 252);
      G.SelectedColor := clHighlight;
      G.DefaultRowHeight := 27;
    end;
  end;

  // Paleta validada en Clientes.
  EstilarBoton(BitBtn2, RGBToColor(5, 150, 105), True);
  EstilarBoton(BitBtn4, RGBToColor(18, 76, 91), True);
  EstilarBoton(BitBtn3, RGBToColor(185, 28, 28), True);
  EstilarBoton(BitBtn5, RGBToColor(226, 232, 240), False);
  EstilarBoton(BitBtn6, RGBToColor(226, 232, 240), False);
  EstilarBoton(BitBtn1, RGBToColor(71, 85, 105), True);

  EstilarBoton(BitBtn11, RGBToColor(5, 150, 105), True);
  EstilarBoton(BitBtn15, RGBToColor(30, 64, 79), True);
  EstilarBoton(BitBtn13, RGBToColor(18, 76, 91), True);
  EstilarBoton(BitBtn12, RGBToColor(5, 150, 105), True);

  // Textos visibles normalizados en UTF-8.
  Label1.Caption := 'CÓDIGO';
  BitBtn4.Caption := 'Modificar';
  BitBtn5.Caption := 'Anterior';
  BitBtn6.Caption := 'Siguiente';

  TabSheet1.Caption := '  General  ';
  TabSheet6.Caption := '  Histórico de compras  ';
  if Assigned(TabSheet4) then
    TabSheet4.Caption := '  Datos de facturación  ';
  if Assigned(TabSheet5) then
    TabSheet5.Caption := '  Datos bancarios  ';
  if Assigned(TabSheet2) then
    TabSheet2.Caption := '  Estadísticas  ';
  if Assigned(TabSheet3) then
    TabSheet3.Caption := '  Gráficas  ';

  Label2.Caption := 'Razón social';
  Label3.Caption := 'Dirección';
  Label4.Caption := 'Localidad';
  Label5.Caption := 'Código postal';
  Label6.Caption := 'Provincia';
  Label8.Caption := 'N.I.F. / C.I.F.';
  Label9.Caption := 'Fax';
  Label10.Caption := 'Teléfono';
  Label11.Caption := 'Mes de vacaciones';
  Label12.Caption := 'Días de cobro';
  Label13.Caption := 'Tipo de cobro';
  Label15.Caption := 'Distintivo / ruta';
  Label17.Caption := 'Observaciones';
  Label22.Caption := 'Representante';
  Label23.Caption := 'E-mail';
  Label54.Caption := 'Teléfono representante';

  if Assigned(TabSheet4) then
  begin
    Label14.Caption := 'Días hasta el primer plazo';
    Label16.Caption := 'Días entre plazos';
    Label18.Caption := 'Número de plazos';
    Label20.Caption := 'Descuento comercial';
    Label21.Caption := 'Descuento por pronto pago';
    Label24.Caption := 'Recargo de equivalencia';
    Label31.Caption := 'Mínimo del primer plazo';
    Label33.Caption := 'Fecha de última venta';
    Label53.Caption := 'Fecha de última compra';
    Label34.Caption := 'Agencia de transportes';
    Label35.Caption := 'Domicilio de entrega';
    Label36.Caption := 'Localidad de entrega';
  end;

  if Assigned(TabSheet5) then
  begin
    Label39.Caption := 'Nombre del banco o caja';
    Label40.Caption := 'Número de cuenta';
    Label41.Caption := 'Domicilio del banco';
    Label42.Caption := 'Localidad del banco';
    Label43.Caption := 'Cuenta de cargo';
    Label44.Caption := 'Cuenta de abono';
  end;

  Label45.Caption := 'Desde fecha';
  Label46.Caption := 'Hasta fecha';
  CheckBox3.Caption := 'Buscar por código';
  CheckBox4.Caption := 'Buscar por unidades';
  CheckBox5.Caption := 'Buscar por importe';

  if Assigned(TabSheet2) then
  begin
    Label57.Caption := 'Periodo a visualizar';
    Label76.Caption := 'Unidades compradas';
    Label75.Caption := 'Importe comprado';
    Label68.Caption := 'Unidades vendidas';
    Label65.Caption := 'Venta a PVP';
    Label19.Caption := 'Venta a coste';
    Label25.Caption := 'Beneficio';
  end;

  if Assigned(TabSheet3) then
  begin
    Label47.Caption := 'Periodo a visualizar';
    Label48.Caption := 'Datos a visualizar';
    Label56.Caption := 'Tipo de gráfica';
  end;

  BitBtn18.Hint := 'Buscar proveedor por razón social';
  BitBtn9.Hint := 'Acción de correo electrónico';
  BitBtn7.Hint := 'Seleccionar tipo de cobro';
  BitBtn8.Hint := 'Seleccionar distintivo o ruta';

  // Los TBitBtn pequeños conservan sus eventos, pero se sustituyen
  // visualmente por paneles sólidos para que GTK no los deje transparentes.
  BitBtn18.Visible := False;
  BitBtn9.Visible := False;
  BitBtn7.Visible := False;
  BitBtn8.Visible := False;
  BitBtn10.Visible := False;
  BitBtn14.Visible := False;
  BitBtn16.Visible := False;

  Panel1.Visible := True;
  BitBtn2.Visible := True;
  BitBtn4.Visible := True;
  BitBtn3.Visible := True;
  BitBtn5.Visible := True;
  BitBtn6.Visible := True;
  BitBtn1.Visible := True;

  ConfigurarOrdenacionGrids;
  OnResize := @FormResizeModerno;
  ReorganizarFormulario;
end;

procedure TFProveedores.FormResizeModerno(Sender: TObject);
begin
  ReorganizarFormulario;
end;

procedure TFProveedores.ReorganizarFormulario;
var
  W, H, Pad, Gap, LeftW, RightW, TopH, NotesY, NotesH: Integer;
  X, Y, RowY, RowGap, FieldW, ColW, I: Integer;
  BtnW, TotalW, StartX: Integer;
  PanelW, PanelH, SummaryW, SummaryCellW: Integer;
  Btns: array[0..5] of TBitBtn;
  SummaryLabels: array[0..5] of TLabel;
  SummaryValues: array[0..5] of TLabel;

  procedure PlaceField(ALabel: TLabel; AControl: TControl;
    AX, AY, AWidth: Integer);
  begin
    ALabel.SetBounds(AX, AY, AWidth, 17);
    AControl.SetBounds(AX, AY + 18, AWidth, 29);
  end;

begin
  if not Assigned(FHeaderBar) then
    Exit;

  // Cabecera.
  W := FHeaderBar.ClientWidth;
  Label1.SetBounds(24, 10, 170, 17);
  Label1.Font.Height := -10;
  Label1.Font.Style := [fsBold];
  Label1.Font.Color := RGBToColor(205, 232, 237);
  Edit1.SetBounds(24, 30, 170, 32);
  Edit1.Font.Height := -13;
  Edit1.Font.Style := [fsBold];
  Edit1.Font.Color := RGBToColor(18, 76, 91);
  Edit1.Color := clWhite;

  FHeaderTitle.SetBounds(220, 8, Max(280, W - 440), 27);
  FHeaderSubtitle.SetBounds(220, 34, Max(280, W - 440), 19);
  Label7.SetBounds(220, 54, Max(280, W - 440), 31);
  Label7.AutoSize := False;
  Label7.Alignment := taCenter;
  Label7.Layout := tlCenter;
  Label7.Font.Height := -16;
  Label7.Font.Style := [fsBold];
  Label7.Font.Color := clWhite;

  BitBtn15.SetBounds(W - 116, 27, 88, 38);
  PanelNuevoPro.SetBounds(24, 65, 170, 23);
  PanelNuevoPro.BevelOuter := bvNone;
  PanelNuevoPro.ParentColor := False;
  PanelNuevoPro.Color := RGBToColor(187, 247, 208);
  PanelNuevoPro.Font.Name := 'Sans';
  PanelNuevoPro.Font.Height := -11;
  PanelNuevoPro.Font.Style := [fsBold];
  PanelNuevoPro.Font.Color := RGBToColor(22, 101, 52);
  PanelNuevoPro.Hint := 'Siguiente código de proveedor disponible';
  PanelNuevoPro.ShowHint := True;

  // Barra inferior.
  Btns[0] := BitBtn2;
  Btns[1] := BitBtn4;
  Btns[2] := BitBtn3;
  Btns[3] := BitBtn5;
  Btns[4] := BitBtn6;
  Btns[5] := BitBtn1;

  Gap := 14;
  BtnW := 120;
  TotalW := (BtnW * 6) + (Gap * 5);
  if Panel1.ClientWidth < TotalW + 16 then
  begin
    Gap := 7;
    BtnW := (Panel1.ClientWidth - 16 - (Gap * 5)) div 6;
    if BtnW < 88 then
      BtnW := 88;
    TotalW := (BtnW * 6) + (Gap * 5);
  end;
  StartX := (Panel1.ClientWidth - TotalW) div 2;
  if StartX < 8 then
    StartX := 8;

  for I := 0 to 5 do
  begin
    Btns[I].SetBounds(StartX + I * (BtnW + Gap), 11, BtnW, 41);
    Btns[I].TabOrder := I;
    Btns[I].BringToFront;
  end;

  // ------------------------------- GENERAL -------------------------------
  W := TabSheet1.ClientWidth;
  H := TabSheet1.ClientHeight;
  Pad := 18;
  Gap := 14;
  RightW := 330;
  if W < 1080 then
    RightW := 300;
  LeftW := W - (Pad * 2) - Gap - RightW;
  if LeftW < 580 then
  begin
    RightW := 270;
    LeftW := W - (Pad * 2) - Gap - RightW;
  end;

  TopH := 322;
  if H > 560 then
    TopH := 338;
  if TopH > H - 116 then
    TopH := H - 116;
  if TopH < 300 then
    TopH := 300;

  NotesY := Pad + TopH + Gap;
  NotesH := H - NotesY - Pad;
  if NotesH < 82 then
    NotesH := 82;

  FGeneralContactCard.SetBounds(Pad, Pad, LeftW, TopH);
  FGeneralTermsCard.SetBounds(Pad + LeftW + Gap, Pad, RightW, TopH);
  FGeneralNotesCard.SetBounds(Pad, NotesY, W - (Pad * 2), NotesH);
  FGeneralContactCard.SendToBack;
  FGeneralTermsCard.SendToBack;
  FGeneralNotesCard.SendToBack;

  FGeneralContactTitle.SetBounds(Pad + 16, Pad + 8, LeftW - 32, 22);
  FGeneralTermsTitle.SetBounds(Pad + LeftW + Gap + 16,
    Pad + 8, RightW - 32, 22);
  FGeneralNotesTitle.SetBounds(Pad + 16, NotesY + 8,
    W - (Pad * 2) - 32, 22);

  // Identificación y contacto: seis filas compactas y amplias.
  X := Pad + 16;
  RowGap := 45;
  RowY := Pad + 36;

  Label2.SetBounds(X, RowY, LeftW - 32, 17);
  Edit2.SetBounds(X, RowY + 18, LeftW - 78, 29);
  FBtnNombreVisual.SetBounds(Pad + LeftW - 48, RowY + 18, 32, 29);

  RowY := RowY + RowGap;
  PlaceField(Label3, Edit4, X, RowY, LeftW - 32);

  RowY := RowY + RowGap;
  ColW := (LeftW - 32 - (Gap * 2)) div 3;
  PlaceField(Label4, Edit5, X, RowY, ColW + 70);
  PlaceField(Label5, Edit6, X + ColW + 70 + Gap,
    RowY, Max(90, ColW - 70));
  PlaceField(Label6, Edit7, X + (ColW * 2) + (Gap * 2),
    RowY, LeftW - 32 - ((ColW * 2) + (Gap * 2)));

  RowY := RowY + RowGap;
  FieldW := (LeftW - 32 - Gap) div 2;
  PlaceField(Label8, Edit8, X, RowY, FieldW);
  Label23.SetBounds(X + FieldW + Gap, RowY, FieldW, 17);
  Edit9.SetBounds(X + FieldW + Gap, RowY + 18, FieldW - 40, 29);
  FBtnEmailVisual.SetBounds(X + FieldW + Gap + FieldW - 34,
    RowY + 18, 34, 29);

  RowY := RowY + RowGap;
  ColW := (LeftW - 32 - (Gap * 2)) div 3;
  PlaceField(Label10, Edit10, X, RowY, ColW);
  PlaceField(Label9, Edit11, X + ColW + Gap, RowY, ColW);
  PlaceField(Label54, Edit51, X + (ColW + Gap) * 2, RowY, ColW);

  RowY := RowY + RowGap;
  PlaceField(Label22, Edit3, X, RowY, LeftW - 32);

  // Condiciones y ruta.
  X := Pad + LeftW + Gap + 16;
  FieldW := (RightW - 32 - Gap) div 2;
  PlaceField(Label11, Edit13, X, Pad + 42, FieldW);
  PlaceField(Label12, Edit14, X + FieldW + Gap,
    Pad + 42, FieldW);

  Label13.SetBounds(X, Pad + 102, RightW - 32, 17);
  Edit12.SetBounds(X, Pad + 121, 66, 29);
  FBtnPagoVisual.SetBounds(X + 72, Pad + 121, 34, 29);
  StaticText1.SetBounds(X + 112, Pad + 121,
    RightW - 32 - 112, 29);

  Label15.SetBounds(X, Pad + 174, RightW - 32, 17);
  Edit15.SetBounds(X, Pad + 193, 78, 29);
  FBtnRutaVisual.SetBounds(X + 84, Pad + 193, 34, 29);
  StaticText2.SetBounds(X + 124, Pad + 193,
    RightW - 32 - 124, 29);

  // Observaciones.
  Label17.SetBounds(Pad + 16, NotesY + 34,
    W - (Pad * 2) - 32, 17);
  Memo1.SetBounds(Pad + 16, NotesY + 52,
    W - (Pad * 2) - 32, NotesH - 66);
  if Memo1.Height < 30 then
    Memo1.Height := 30;

  // Ventanas auxiliares centradas.
  PanelW := Min(610, W - 70);
  PanelH := Min(330, H - 50);
  Panel5.SetBounds((W - PanelW) div 2, (H - PanelH) div 2,
    PanelW, PanelH);
  Label49.SetBounds(16, 8, PanelW - 64, 25);
  Label49.Alignment := taCenter;
  Label49.Font.Height := -13;
  Label49.Font.Style := [fsBold];
  ListBox2.SetBounds(16, 40, PanelW - 32, PanelH - 56);
  FBtnCerrarPagoVisual.SetBounds(PanelW - 42, 6, 30, 28);
  Panel5.BringToFront;
  FBtnCerrarPagoVisual.BringToFront;

  Panel7.SetBounds((W - PanelW) div 2, (H - PanelH) div 2,
    PanelW, PanelH);
  Label55.SetBounds(16, 8, PanelW - 64, 25);
  Label55.Alignment := taCenter;
  Label55.Font.Height := -13;
  Label55.Font.Style := [fsBold];
  ListBox6.SetBounds(16, 40, PanelW - 32, PanelH - 56);
  FBtnCerrarRutaVisual.SetBounds(PanelW - 42, 6, 30, 28);
  Panel7.BringToFront;
  FBtnCerrarRutaVisual.BringToFront;

  PanelW := Min(600, W - 70);
  PanelH := Min(440, H - 40);
  Panel6.SetBounds((W - PanelW) div 2, (H - PanelH) div 2,
    PanelW, PanelH);
  Label52.SetBounds(16, 6, PanelW - 64, 29);
  Label52.Alignment := taCenter;
  Label52.Font.Height := -13;
  Label52.Font.Style := [fsBold];
  FBtnCerrarSICVisual.SetBounds(PanelW - 42, 5, 30, 28);
  ListBox1.SetBounds(16, 44, PanelW - 32, PanelH - 166);
  Label51.SetBounds(16, PanelH - 112, 90, 17);
  Edit49.SetBounds(106, PanelH - 116, PanelW - 122, 29);
  Label50.SetBounds(16, PanelH - 75, 90, 17);
  Edit48.SetBounds(106, PanelH - 79, 160, 29);
  BitBtn13.SetBounds(16, PanelH - 39, 105, 32);
  BitBtn12.SetBounds(PanelW - 121, PanelH - 39, 105, 32);
  Panel6.BringToFront;
  FBtnCerrarSICVisual.BringToFront;

  FBtnNombreVisual.BringToFront;
  FBtnEmailVisual.BringToFront;
  FBtnPagoVisual.BringToFront;
  FBtnRutaVisual.BringToFront;

  // ----------------------- DATOS DE FACTURACIÓN --------------------------
  if Assigned(TabSheet4) then
  begin
    W := TabSheet4.ClientWidth;
    H := TabSheet4.ClientHeight;
    Pad := 18;
    Gap := 14;
    TopH := 232;

    FInvoiceTermsCard.SetBounds(Pad, Pad, W - (Pad * 2), TopH);
    FDeliveryCard.SetBounds(Pad, Pad + TopH + Gap,
      W - (Pad * 2), H - (Pad * 2) - TopH - Gap);
    FInvoiceTermsCard.SendToBack;
    FDeliveryCard.SendToBack;

    FInvoiceTermsTitle.SetBounds(Pad + 16, Pad + 8,
      W - (Pad * 2) - 32, 22);
    FDeliveryTitle.SetBounds(Pad + 16, Pad + TopH + Gap + 8,
      W - (Pad * 2) - 32, 22);

    ColW := (W - (Pad * 2) - 32 - (Gap * 2)) div 3;
    X := Pad + 16;
    Y := Pad + 38;
    PlaceField(Label14, Edit16, X, Y, ColW);
    PlaceField(Label16, Edit17, X + ColW + Gap, Y, ColW);
    PlaceField(Label18, Edit18, X + (ColW + Gap) * 2, Y, ColW);

    Y := Y + 58;
    PlaceField(Label24, Edit22, X, Y, ColW);
    PlaceField(Label20, Edit20, X + ColW + Gap, Y, ColW);
    PlaceField(Label21, Edit21, X + (ColW + Gap) * 2, Y, ColW);

    Y := Y + 58;
    PlaceField(Label31, Edit29, X, Y, ColW);
    PlaceField(Label33, DateEdit1, X + ColW + Gap, Y, ColW);
    PlaceField(Label53, DateEdit2, X + (ColW + Gap) * 2, Y, ColW);

    Y := Pad + TopH + Gap + 38;
    FieldW := W - (Pad * 2) - 32;
    PlaceField(Label34, Edit32, X, Y, FieldW);

    Y := Y + 54;
    PlaceField(Label35, Edit33, X, Y, FieldW);

    Y := Y + 54;
    Label36.SetBounds(X, Y, (FieldW * 3) div 4, 17);
    Edit34.SetBounds(X, Y + 18, (FieldW * 3) div 4, 29);
    Label37.SetBounds(X + ((FieldW * 3) div 4) + Gap,
      Y, FieldW - ((FieldW * 3) div 4) - Gap, 17);
    Edit35.SetBounds(X + ((FieldW * 3) div 4) + Gap,
      Y + 18, FieldW - ((FieldW * 3) div 4) - Gap, 29);
  end;

  // --------------------------- DATOS BANCARIOS ---------------------------
  if Assigned(TabSheet5) then
  begin
    W := TabSheet5.ClientWidth;
    H := TabSheet5.ClientHeight;
    Pad := 18;
    Gap := 14;
    LeftW := (W - (Pad * 2) - Gap) * 2 div 3;
    RightW := W - (Pad * 2) - Gap - LeftW;

    FBankDataCard.SetBounds(Pad, Pad, LeftW, H - (Pad * 2));
    FBankAccountsCard.SetBounds(Pad + LeftW + Gap, Pad,
      RightW, H - (Pad * 2));
    FBankDataCard.SendToBack;
    FBankAccountsCard.SendToBack;

    FBankDataTitle.SetBounds(Pad + 16, Pad + 10,
      LeftW - 32, 22);
    FBankAccountsTitle.SetBounds(Pad + LeftW + Gap + 16,
      Pad + 10, RightW - 32, 22);

    X := Pad + 16;
    FieldW := LeftW - 32;
    PlaceField(Label39, Edit37, X, Pad + 48, FieldW);
    PlaceField(Label40, Edit38, X, Pad + 116, FieldW);
    PlaceField(Label41, Edit39, X, Pad + 184, FieldW);
    PlaceField(Label42, Edit40, X, Pad + 252, FieldW);

    X := Pad + LeftW + Gap + 16;
    FieldW := RightW - 32;
    PlaceField(Label43, Edit41, X, Pad + 64, FieldW);
    PlaceField(Label44, Edit42, X, Pad + 142, FieldW);
  end;

  // ------------------------- HISTÓRICO DE COMPRAS ------------------------
  W := TabSheet6.ClientWidth;
  H := TabSheet6.ClientHeight;
  Panel2.Align := alRight;
  Panel2.Width := 260;
  DBGrid2.Align := alClient;

  FHistoryTitle.SetBounds(12, 10, Panel2.ClientWidth - 24, 25);
  Label45.SetBounds(22, 50, Panel2.ClientWidth - 44, 17);
  DateEdit3.SetBounds(22, 69, Panel2.ClientWidth - 44, 29);
  Label46.SetBounds(22, 112, Panel2.ClientWidth - 44, 17);
  DateEdit4.SetBounds(22, 131, Panel2.ClientWidth - 44, 29);

  CheckBox3.SetBounds(16, 183, Panel2.ClientWidth - 32, 24);
  Edit45.SetBounds(22, 211, Panel2.ClientWidth - 44, 29);
  CheckBox4.SetBounds(16, 257, Panel2.ClientWidth - 32, 24);
  Edit46.SetBounds(22, 285, Panel2.ClientWidth - 44, 29);
  CheckBox5.SetBounds(16, 331, Panel2.ClientWidth - 32, 24);
  Edit47.SetBounds(22, 359, Panel2.ClientWidth - 44, 29);
  BitBtn11.SetBounds(54, H - 54, Panel2.ClientWidth - 108, 39);

  if DBGrid2.Columns.Count >= 5 then
  begin
    DBGrid2.Columns[0].Width := 92;
    DBGrid2.Columns[1].Width := 120;
    DBGrid2.Columns[3].Width := 78;
    DBGrid2.Columns[4].Width := 105;
    DBGrid2.Columns[2].Width := Max(220,
      DBGrid2.ClientWidth - 92 - 120 - 78 - 105 - 42);
  end;

  // ----------------------------- ESTADÍSTICAS ----------------------------
  if Assigned(TabSheet2) then
  begin
    W := TabSheet2.ClientWidth;
    H := TabSheet2.ClientHeight;
    Panel3.Width := 210;
    Panel3.Align := alRight;
    DBGrid1.Align := alClient;
    FStatsSummaryPanel.Align := alBottom;
    FStatsSummaryPanel.Height := 92;

    Label57.SetBounds(16, 16, Panel3.ClientWidth - 32, 20);
    Label57.Alignment := taCenter;
    Label57.Font.Style := [fsBold];
    ListBox5.SetBounds(16, 43, Panel3.ClientWidth - 32,
      Min(180, Panel3.ClientHeight - 60));

    SummaryLabels[0] := Label76;
    SummaryLabels[1] := Label75;
    SummaryLabels[2] := Label68;
    SummaryLabels[3] := Label65;
    SummaryLabels[4] := Label19;
    SummaryLabels[5] := Label25;

    SummaryValues[0] := lbUC;
    SummaryValues[1] := lbIC;
    SummaryValues[2] := lbUV;
    SummaryValues[3] := lbIVP;
    SummaryValues[4] := lbIVC;
    SummaryValues[5] := lbBeneficio;

    SummaryW := FStatsSummaryPanel.ClientWidth - 24;
    SummaryCellW := SummaryW div 6;
    for I := 0 to 5 do
    begin
      SummaryLabels[I].SetBounds(12 + I * SummaryCellW,
        13, SummaryCellW, 18);
      SummaryLabels[I].Alignment := taCenter;
      SummaryLabels[I].Font.Height := -10;
      SummaryLabels[I].Font.Style := [fsBold];

      SummaryValues[I].SetBounds(12 + I * SummaryCellW,
        36, SummaryCellW, 36);
      SummaryValues[I].Alignment := taCenter;
      SummaryValues[I].Layout := tlCenter;
      SummaryValues[I].Font.Height := -16;
      SummaryValues[I].Font.Style := [fsBold];
      SummaryValues[I].Font.Color := RGBToColor(18, 76, 91);
    end;
    lbBeneficio.Font.Color := RGBToColor(22, 101, 52);
  end;

  // ------------------------------- GRÁFICAS -------------------------------
  if Assigned(TabSheet3) then
  begin
    W := TabSheet3.ClientWidth;
    H := TabSheet3.ClientHeight;
    FChartsSidePanel.Width := 235;
    FChartsSidePanel.Align := alRight;
    Chart1.Align := alClient;

    Label47.SetBounds(18, 18, 199, 20);
    ListBox3.SetBounds(18, 42, 199, 72);
    Label48.SetBounds(18, 132, 199, 20);
    ListBox4.SetBounds(18, 156, 199, Min(180, H - 330));
    Label56.SetBounds(18, H - 150, 199, 20);
    ListBox7.SetBounds(18, H - 126, 199, 104);
  end;

  FGeneralContactTitle.BringToFront;
  FGeneralTermsTitle.BringToFront;
  FGeneralNotesTitle.BringToFront;
  if Assigned(TabSheet4) then
  begin
    FInvoiceTermsTitle.BringToFront;
    FDeliveryTitle.BringToFront;
  end;
  if Assigned(TabSheet5) then
  begin
    FBankDataTitle.BringToFront;
    FBankAccountsTitle.BringToFront;
  end;

  Panel1.BringToFront;
  FHeaderBar.BringToFront;
end;

//=============== CREAR EL FORMULARIO ================
procedure ShowFormProveedores;
begin
  with TFProveedores.Create(Application) do
    begin
       ShowModal;
    end;
end;
Procedure TFProveedores.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbProve.Sql.Text:='SELECT * FROM proveedores ORDER BY P0';
  dbProve.Active := True;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Proveed', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Proveed', 3);//------------------ Boton Borrar
  if CheckRoles(dbRoles, CgRol, 'Proveed', 4)=False then FreeAndNil(TabSheet2);//--- Estadisticas
  if CheckRoles(dbRoles, CgRol, 'Proveed', 4)=False then FreeAndNil(TabSheet3);//--- Graficas
  if CheckRoles(dbRoles, CgRol, 'Proveed', 5)=False then FreeAndNil(TabSheet4);//--- Datos de facturacion
  if CheckRoles(dbRoles, CgRol, 'Proveed', 6)=False then FreeAndNil(TabSheet5);//--- Datos bancarios
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

  AplicarEstiloModerno();

  { Al abrir el formulario, dejar preparado el campo Codigo. }
  ActiveControl := Edit1;

  { ESC actua antes que el control activo y respeta los paneles auxiliares. }
  KeyPreview := True;
  OnKeyDown := @FormKeyDown;
  FLXAplicarTemaVisual(Self);
End;

procedure TFProveedores.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then Exit;

  { Si hay un selector auxiliar abierto, ESC lo cierra primero. }
  if Panel5.Visible then
  begin
    BitBtn10Click(nil);
    Key := 0;
    Exit;
  end;

  if Panel7.Visible then
  begin
    BitBtn16Click(nil);
    Key := 0;
    Exit;
  end;

  { En la pantalla principal equivale exactamente al boton Cerrar. }
  Key := 0;
  BitBtn1Click(nil);
end;

//==================== CERRAR ======================
Procedure TFProveedores.Bitbtn1click(Sender: Tobject);
Begin
  Close();
End;
Procedure TFProveedores.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;
//=================== REGISTRO NUEVO ===================
Procedure TFProveedores.Bitbtn2click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if dbProve.Locate('P0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO YA EXISTE');
      exit;
    end;
   dbProve.Append; LlenaReg(); dbProve.Post;
   Label7.Caption:=dbProve.Fields[1].AsString; //--- Refrescar nombre.
   if ActivarSIC='S' then GrabarModificarSic();//------ Comprobar si se crea cliente en el SIC.
End;
//=================== BORRAR REGISTRO ===================
Procedure TFProveedores.Bitbtn3click(Sender: Tobject);
Begin
   if Edit1.Text='' then exit;
   if not dbProve.Locate('P0', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
       exit;
     end;
   CodClienteSic:=dbProve.FieldByName('P39').AsString;//---- Para leer cliente en el sic.
   if Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
       Exit;
   dbProve.Delete; Edit1.Text := ''; LimpiaForm();
   if ActivarSIC='S' then BorrarSic();//------ Comprobar si se crea cliente en el SIC.
End;

//=================== MODIFICAR ===================
Procedure TFProveedores.Bitbtn4click(Sender: Tobject);
Begin
   if (Edit1.Text='') or (dbProve.Recordcount=0) then exit;
   if not dbProve.Locate('P0,', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO!');
       exit;
     end;
   If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
   dbProve.Edit; LlenaReg(); dbProve.Post;
   Label7.Caption:=dbProve.Fields[1].AsString;//--- Refrescar nombre.
   if ActivarSIC='S' then GrabarModificarSic();//------ Comprobar si se modifica cliente en el SIC.
End;

//==================== REG. ANTERIOR ===============
Procedure TFProveedores.Bitbtn5click(Sender: Tobject);
Begin
  dbProve.Prior;
  LimpiaForm(); Relleno();
End;

//==================== REG. POSTERIOR ===============
Procedure TFProveedores.Bitbtn6click(Sender: Tobject);
Begin
   dbProve.Next;
   LimpiaForm(); Relleno();
End;

//=================== CODIGO DEL PROVEEDOR ================
Procedure TFProveedores.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;
Procedure TFProveedores.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbProve.Locate('P0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;

//================== BUSCAR PROVEEDORES ================
procedure TFProveedores.BitBtn18Click(Sender: TObject);
begin
   if Edit2.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit2.SetFocus;
     Exit;
  end;
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT P0,P1 FROM proveedores WHERE P1 LIKE "%'+Edit2.Text+'%"',
                                         ['Código','Razón Social'], 'P0');
  if ((Edit1.Text='-') or (Edit1.Text='-1')) then Edit1.Text:='' else Edit1Exit(Edit1);
end;

procedure TFProveedores.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn18Click(BitBtn8);
end;

//================== CHEQUEAR FECHAS ULTIMA VENTA/COMPRA ==================
procedure TFProveedores.DateEdit1Exit(Sender: TObject);
begin
  if not EsFechaValida(DateEdit1.text) Then ShowMessage('Formato de Fecha Invalido, debe ser DD/MM/AAAA');
end;
procedure TFProveedores.DateEdit2Exit(Sender: TObject);
begin
  if not EsFechaValida(DateEdit2.text) Then ShowMessage('Formato de Fecha Invalido, debe ser DD/MM/AAAA');
end;
//================== CHEQUEAR FECHAS HISTORICO DE COMPRAS ==================
procedure TFProveedores.DateEdit3Exit(Sender: TObject);
begin
  if not EsFechaValida(DateEdit3.text) Then ShowMessage('Formato de Fecha Invalido, debe ser DD/MM/AAAA');
end;
procedure TFProveedores.DateEdit4Exit(Sender: TObject);
begin
  if not EsFechaValida(DateEdit4.text) Then ShowMessage('Formato de Fecha Invalido, debe ser DD/MM/AAAA');
end;

//===================== LIMPIAR DATOS =======================
Procedure TFProveedores.LimpiaForm();
Begin
  Edit2.Text:=''; Edit3.Text:=''; Edit4.Text:=''; Edit5.Text:='';
  Edit6.Text:=''; Label7.Caption:='';
  Edit7.Text:=''; Edit8.Text:=''; Edit9.Text:=''; Edit10.Text:='';
  Edit11.Text:=''; Edit12.Text:=''; Edit13.Text:='';
  Edit14.Text:=''; Memo1.Lines.Text:=''; Edit15.Text:='';
  Edit16.Text:=''; Edit17.Text:=''; Edit18.Text:='';
  Edit20.Text:=''; Edit21.Text:='';
  Edit22.Text:=''; Edit29.Text:='';
  // Edit31.Text:=''; // Cambiado Por DateEdit1
  Edit32.Text:=''; Edit33.Text:='';
  //DateEdit1.Date:=Null;DateEdit2.Date:=Null;
  //DateEdit1.Date:=Date;DateEdit2.Date:=Date;
  DateEdit1.Text:=''; DateEdit2.Text:='';
  Edit34.Text:=''; Edit35.Text:='';
  Edit37.Text:=''; Edit38.Text:=''; Edit39.Text:='';
  Edit40.Text:=''; Edit41.Text:=''; Edit42.Text:='';
  // Edit43.Text:=''; Edit44.Text:='';  // CambiadoS Por DateEdit3 y DateEdit4
  Edit45.Text:='';
  DateEdit3.Date:=StartOfTheMonth(Date);DateEdit4.Date:=Date;
  Edit46.Text:=''; Edit47.Text:=''; Edit51.Text:='';
  CheckBox3.Checked:=False; CheckBox4.Checked:=False;
  CheckBox5.Checked:=False; StaticText1.Caption:='';
  StaticText2.Caption:='';

End;

//===================== PINTAR DATOS =======================
Procedure TFProveedores.Relleno();
Begin
  if dbProve.RecordCount=0 then exit;
  Label7.Caption:=dbProve.FieldByName('P1').AsString;//---------- Nombre (Arriba)
  Edit1.Text:=dbProve.FieldByName('P0').AsString;//-------------- Cgo. Proveedor
  Edit2.Text:=dbProve.FieldByName('P1').AsString;//-------------- Nombre
  Edit4.Text:=dbProve.FieldByName('P2').AsString;//-------------- Direccion
  Edit5.Text:=dbProve.FieldByName('P3').AsString;//-------------- Localidad
  Edit6.Text:=dbProve.FieldByName('P4').AsString;//-------------- C.Postal
  Edit7.Text:=dbProve.FieldByName('P5').AsString;//-------------- Provincia
  Edit8.Text:=dbProve.FieldByName('P6').AsString;//-------------- N.I.F.
  Edit9.Text:=dbProve.FieldByName('P34').AsString;//------------- E-Mail
  Edit10.Text:=dbProve.FieldByName('P7').AsString;//------------- Telef.
  Edit11.Text:=dbProve.FieldByName('P8').AsString;//------------- Fax
  Edit3.Text:=dbProve.FieldByName('P9').AsString;//-------------- Representante
  Edit51.Text:=dbProve.FieldByName('P10').AsString;//------------ Telefono Representante
  Edit12.Text:=dbProve.FieldByName('P11').AsString;//------------ Tipo de pago
  if Edit12.Text<>'' then VerTipoPago();//----------------------- Nombre tipo de pago
  Edit13.Text:=dbProve.FieldByName('P13').AsString;//------------ Mes de vacaciones
  Edit14.Text:=dbProve.FieldByName('P14').AsString;//------------ Dias de pago
  Edit15.Text:=dbProve.FieldByName('P12').AsString;//------------ Distintivo / Ruta
  if Edit15.Text<>'' then VerRutas();//-------------------------- Nombre distintivo / ruta
  Memo1.Lines.Text:=dbProve.FieldByName('P35').AsString;//------- Observaciones
  Edit16.Text:=dbProve.FieldByName('P15').AsString;//------------ Dias hasta 1º plazo
  Edit17.Text:=dbProve.FieldByName('P16').AsString;//------------ Dias entre plazos
  Edit18.Text:=dbProve.FieldByName('P17').AsString;//------------ Numero de plazos
  Edit20.Text:=dbProve.FieldByName('P18').AsString;//------------ Dto. comercial
  Edit21.Text:=dbProve.FieldByName('P19').AsString;//------------ Dto. pronto pago
  Edit22.Text:=dbProve.FieldByName('P20').AsString;//------------ Recargo equivalencia S/N
  Edit29.Text:=dbProve.FieldByName('P21').AsString;//------------ Minimo primer plazo
  //Edit31.Text:=dbProve.FieldByName('P22').AsString;//------------ Fecha ultima Venta
  //Edit50.Text:=dbProve.FieldByName('P23').AsString;//------------ Fecha ultima Compra
  DateEdit1.Date:=dbProve.FieldByName('P22').AsDateTime;//------------ Fecha ultima Venta
  DateEdit2.Date:=dbProve.FieldByName('P23').AsDateTime;//------------ Fecha ultima Compra

  Edit32.Text:=dbProve.FieldByName('P24').AsString;//------------ Agencia de transportes
  Edit33.Text:=dbProve.FieldByName('P26').AsString;//------------ Domicilio de entrega
  Edit34.Text:=dbProve.FieldByName('P27').AsString;//------------ Localidad de entrega
  Edit35.Text:=dbProve.FieldByName('P25').AsString;//------------ Portes D/P

  Edit37.Text:=dbProve.FieldByName('P28').AsString;//------------ Nombre banco / caja
  Edit38.Text:=dbProve.FieldByName('P29').AsString;//------------ N. Cuenta
  Edit39.Text:=dbProve.FieldByName('P30').AsString;//------------ Domicilio banco
  Edit40.Text:=dbProve.FieldByName('P31').AsString;//------------ Localidad banco
  Edit41.Text:=dbProve.FieldByName('P32').AsString;//------------ Cuenta de cargo
  Edit42.Text:=dbProve.FieldByName('P33').AsString;//------------ Cuenta de abono

  //-------------- Estadisticas --------------------
  RellenaEsta(FormatDateTime('YYYY',Date));//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, PP6-PP7 As BENEF FROM estaprove WHERE PP0="'+Edit1.Text+'"'+
                   ' AND PP1='+FormatDateTime('YYYY',Date)+
                   ' ORDER BY PP1 ASC, PP2 ASC';
  dbEsta.Active:=True;
  //------------------------------------------------
  CargaGrafica:=1; Graficas(); CargaGrafica:=0;//---------------- Pintar Graficas

  //-------------- Historico de compras --------------------
  //Edit43.Text:='01/'+FormatDateTime('MM/YYYY',Date);
  //Edit43.Text:=FormatDateTime(ShortDateFormat, StartOfTheMonth(Date));
  DateEdit3.Date:=StartOfTheMonth(Date);
  //Edit44.Text:=FormatDateTime('DD/MM/YYYY',Date);
  //Edit44.Text:=FormatDateTime(ShortDateFormat,Date);
  DateEdit4.Date:=Date;
  dbHisto.Active:=False;
  dbHisto.SQL.Text:='SELECT * FROM hipedidd'+Tienda+' WHERE HPD2='+Edit1.Text+
                    ' AND HPD1>="'+FormatDateTime('YYYY-MM-DD',DateEdit3.Date)+'"'+
                    ' AND HPD1<="'+FormatDateTime('YYYY-MM-DD',DateEdit4.Date)+'"'+
                    ' ORDER BY HPD1 DESC';
                    // Se modifoco para cambiar a TDateEdit
                    //' AND AP1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit43.Text))+'"'+
                    //' AND AP1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit44.Text))+'"'+
  dbHisto.Active:=True;
  //-------------- Ver si esta es la misma version que la del SIC
  CodClienteSic:=dbProve.FieldByName('P39').AsString;
  if (ActivarSIC='S') and (LeerClienteSic=true) then
    begin
      if (dbCliSic.FieldByName('ES_PROVEEDOR').AsString='1') and
         (dbProve.FieldByName('P38').AsInteger<dbCliSic.FieldByName('version').AsInteger) then
         If Application.MessageBox('EXISTE DATOS ACTUALIZADOS DE ESTE PROVEEDOR EN EL SISTEMA SIC, LOS ACTUALIZO AQUI?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
            Exit
         else
          begin
            CargaSic();
            If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
               Exit;
            dbProve.Edit; LlenaReg(); dbProve.Post;
            Label7.Caption:=dbProve.Fields[1].AsString;//--- Refrescar nombre.
            dbProve.Edit;
            dbProve.FieldByName('P38').Value:=dbCliSic.FieldByName('version').Value;//------- Control de Version
            dbProve.Post;
          end;
    end;
End;
//===================== RELLENAR DATOS =======================
Procedure TFProveedores.LlenaReg();
Begin
  dbProve.FieldByName('P0').AsString:=Edit1.Text;//-------------- Cgo. Proveedor
  dbProve.FieldByName('P1').AsString:=Edit2.Text;//-------------- Nombre
  dbProve.FieldByName('P2').AsString:=Edit4.Text;//-------------- Direccion
  dbProve.FieldByName('P3').AsString:=Edit5.Text;//-------------- Localidad
  dbProve.FieldByName('P4').AsString:=Edit6.Text;//-------------- C.Postal
  dbProve.FieldByName('P5').AsString:=Edit7.Text;//-------------- Provincia
  dbProve.FieldByName('P6').AsString:=Edit8.Text;//-------------- N.I.F.
  dbProve.FieldByName('P34').AsString:=Edit9.Text;//------------- E-Mail
  dbProve.FieldByName('P7').AsString:=Edit10.Text;//------------- Telef.
  dbProve.FieldByName('P8').AsString:=Edit11.Text;//------------- Fax
  dbProve.FieldByName('P9').AsString:=Edit3.Text;//-------------- Representante
  dbProve.FieldByName('P10').AsString:=Edit51.Text;//------------ Telef Repre.
  dbProve.FieldByName('P11').AsString:=Edit12.Text;//------------ Tipo de pago
  dbProve.FieldByName('P13').AsString:=Edit13.Text;//------------ Mes de vacaciones
  dbProve.FieldByName('P14').AsString:=Edit14.Text;//------------ Dias de pago
  dbProve.FieldByName('P12').AsString:=Edit15.Text;//------------ Distintivo / Ruta
  dbProve.FieldByName('P35').AsString:=Memo1.Lines.Text;//------- Observaciones
  dbProve.FieldByName('P15').AsString:=Edit16.Text;//------------ Dias hasta 1º plazo
  dbProve.FieldByName('P16').AsString:=Edit17.Text;//------------ Dias entre plazos
  dbProve.FieldByName('P17').AsString:=Edit18.Text;//------------ Numero de plazos
  dbProve.FieldByName('P18').AsString:=Edit20.Text;//------------ Dto. comercial
  dbProve.FieldByName('P19').AsString:=Edit21.Text;//------------ Dto. pronto pago
  dbProve.FieldByName('P20').AsString:=Edit22.Text;//------------ Recargo equivalencia S/N
  dbProve.FieldByName('P21').AsString:=Edit29.Text;//------------ Minimo primer plazo

  //----- Fecha ultima Venta
  //if Edit43.Text='' then
  if DateEdit1.Date=Null then
    dbProve.FieldByName('P22').Value:=Null
  else
    //dbProve.FieldByName('P22').AsString:=Edit31.Text;//---------- Fecha ultima Venta
    dbProve.FieldByName('P22').AsDateTime:=DateEdit1.Date;//---------- Fecha ultima Venta

  //----- Fecha ultima Compra
  // if Edit50.Text='' then
  if DateEdit2.Date=Null then
    dbProve.FieldByName('P23').Value:=Null
  else
//    dbProve.FieldByName('P23').AsString:=Edit50.Text;//---------- Fecha ultima Compra
    dbProve.FieldByName('P23').AsDateTime:=DateEdit2.Date;//---------- Fecha ultima Compra

  dbProve.FieldByName('P24').AsString:=Edit32.Text;//------------ Agencia de transportes
  dbProve.FieldByName('P26').AsString:=Edit33.Text;//------------ Domicilio de entrega
  dbProve.FieldByName('P27').AsString:=Edit34.Text;//------------ Localidad de entrega
  dbProve.FieldByName('P25').AsString:=Edit35.Text;//------------ Portes D/P

  dbProve.FieldByName('P28').AsString:=Edit37.Text;//------------ Nombre banco / caja
  dbProve.FieldByName('P29').AsString:=Edit38.Text;//------------ N. Cuenta
  dbProve.FieldByName('P30').AsString:=Edit39.Text;//------------ Domicilio banco
  dbProve.FieldByName('P31').AsString:=Edit40.Text;//------------ Localidad banco
  dbProve.FieldByName('P32').AsString:=Edit41.Text;//------------ Cuenta de cargo
  dbProve.FieldByName('P33').AsString:=Edit42.Text;//------------ Cuenta de abono

End;

//========================================================
//=================== TIPOS DE PAGOS =====================
//========================================================
procedure TFProveedores.BitBtn7Click(Sender: TObject);
begin
  dbPagos.SQL.Text:='SELECT * FROM formapago ORDER BY FPA1 ASC';
  dbPagos.Active:=True;
  if dbPagos.RecordCount=0 then exit;
  dbPagos.First; ListBox2.Items.Clear;
  while not dbPagos.EOF do
    begin
      ListBox2.Items.Add(Space(2-length(dbPagos.FieldByName('FPA0').AsString))+
                         dbPagos.FieldByName('FPA0').AsString+' '+
                         dbPagos.FieldByName('FPA1').AsString);
      dbPagos.Next;
    end;
  dbPagos.Active:=False; Panel5.Visible:=True; Panel5.BringToFront;
end;

//------------------- VER TIPOS DE PAGO -----------------
procedure TFProveedores.Edit12Enter(Sender: TObject);
begin
  StaticText1.Caption:=''
end;
procedure TFProveedores.Edit12Exit(Sender: TObject);
begin
  if Edit12.Text<>'' then VerTipoPago();
end;
Procedure TFProveedores.VerTipoPago();
Begin
  dbPagos.Active:=False;
  dbPagos.SQL.Text:='SELECT * FROM formapago WHERE FPA0='+Edit12.Text;
  dbPagos.Active:=True;
  if dbPagos.RecordCount=0 then
   StaticText1.Caption:=''
  else
   StaticText1.Caption:=dbPagos.Fields[1].AsString;
  dbPagos.Active:=False;
End;
//------------------- SELECCIONAR TIPO DE PAGO ---------------
procedure TFProveedores.ListBox2DblClick(Sender: TObject);
begin
  Edit12.Text:=trim(copy(ListBox2.Items.Strings[ListBox2.ItemIndex],1,2));
  if Edit12.Text<>'' then Edit12Exit(Edit12);
  Panel5.Visible:=False;
end;
//--------------- Cerrar tipos de pagos / cobros -------------
procedure TFProveedores.BitBtn10Click(Sender: TObject);
begin
  Panel5.Visible:=False;
end;

//=======================================================
//================= DISTINTIVOS / RUTAS =================
//=======================================================
procedure TFProveedores.BitBtn8Click(Sender: TObject);
begin
  dbPagos.SQL.Text:='SELECT * FROM rutas'+Tienda+' ORDER BY RUT1 ASC';
  dbPagos.Active:=True;
  if dbPagos.RecordCount=0 then exit;
  dbPagos.First; ListBox6.Items.Clear;
  while not dbPagos.EOF do
    begin
      ListBox6.Items.Add(Space(7-length(dbPagos.FieldByName('RUT0').AsString))+
                         dbPagos.FieldByName('RUT0').AsString+' '+
                         dbPagos.FieldByName('RUT1').AsString);
      dbPagos.Next;
    end;
  dbPagos.Active:=False; Panel7.Visible:=True; Panel7.BringToFront;
end;

//-------------- Seleccionar distintivos / rutas -------
procedure TFProveedores.ListBox6DblClick(Sender: TObject);
begin
  Edit15.Text:=trim(copy(ListBox6.Items.Strings[ListBox6.ItemIndex],1,7));
  if Edit15.Text<>'' then Edit15Exit(Edit15);
  Panel7.Visible:=False;
end;

//-------------- Cerrar distintivos / rutas -------
procedure TFProveedores.BitBtn16Click(Sender: TObject);
begin
  Panel7.Visible:=False;
end;

//-------------- Ver distintivos / rutas -------
procedure TFProveedores.Edit15Enter(Sender: TObject);
begin
  StaticText2.Caption:='';
end;
procedure TFProveedores.Edit15Exit(Sender: TObject);
begin
  if Edit15.Text<>'' then VerRutas();
end;

procedure TFProveedores.Edit1MouseEnter(Sender: TObject);
var
  Ultimo : Integer;
begin
  PanelNuevoPro.Visible:=True;
  PanelNuevoPro.BringToFront;
  //------ Ver cual es el ultimo proveedor en nuestro file
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT P0 FROM proveedores where P0<999990 ORDER BY P0 DESC';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then Ultimo:=1 else Ultimo:=dbTRabajo.FieldByName('P0').AsInteger+1;
  //------ Cargar datos en pantalla
  PanelNuevoPro.Caption:=IntToStr(Ultimo);end;

procedure TFProveedores.Edit1MouseLeave(Sender: TObject);
begin
  PanelNuevoPro.Visible:=False;
end;

Procedure TFProveedores.VerRutas();
Begin
  dbPagos.Active:=False;
  dbPagos.SQL.Text:='SELECT * FROM rutas'+Tienda+' WHERE RUT0='+Edit15.Text;
  dbPagos.Active:=True;
  if dbPagos.RecordCount=0 then
   StaticText2.Caption:=''
  else
   StaticText2.Caption:=dbPagos.Fields[1].AsString;
  dbPagos.Active:=False;
End;

//=================== CONTROLAR RECARGO EQUIVALENCIA ===============
procedure TFProveedores.Edit22Exit(Sender: TObject);
begin
  if Edit22.Text='' then Edit22.Text:='N';
  if (Edit22.Text='S') or (Edit22.Text='N') then exit;
  showmessage('Debe teclear S o N en este campo.');
  Edit22.SetFocus;
end;

//=======================================================
//============= FILTRO HIST. COMPRAS ====================
//=======================================================
//------------- Buscar codigo ------------
procedure TFProveedores.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked=True then
    Edit45.Enabled:=True else Edit45.Enabled:=False;
end;
//------------- Buscar unidades ----------
procedure TFProveedores.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked=True then
    Edit46.Enabled:=True else Edit46.Enabled:=False;
end;
//------------- Buscar importe ----------
procedure TFProveedores.CheckBox5Click(Sender: TObject);
begin
  if CheckBox5.Checked=True then
    Edit47.Enabled:=True else Edit47.Enabled:=False;
end;

//------------ APLICAR FILTRO -----------
procedure TFProveedores.BitBtn11Click(Sender: TObject);
var
  Codigo,Unidades,Importe: String;
begin
  if (Edit1.Text = '') Then
     begin
       ShowMessage('Primero debe Selecionar un Proveedor, verifique');
       exit;
     end;

  //if Edit43.Text='' then Edit43.Text:='01/'+FormatDateTime('MM/YYYY',Date);
  if DateEdit1.Date=Null then DateEdit3.Date:=StartOfTheMonth(Date);
  //if Edit44.Text='' then Edit44.Text:=FormatDateTime('DD/MM/YYYY',Date);
  if DateEdit2.Date=Null then DateEdit4.Date:=Date;
  //if StrToDate(Edit43.Text) > StrToDate(Edit44.Text) then
  if DateEdit3.Date > DateEdit4.Date then
    begin ShowMessage('LA PRIMERA FECHA NO PUEDE SER MAYOR QUE LA ULTIMA'); exit; end;
  //------- Ver si buscar por codigo
  if (CheckBox3.Checked=True) and (Edit45.Text<>'') then
    Codigo:=' AND HPD6="'+Edit45.Text+'"' else Codigo:='';
  //------- Ver si buscar por unidades
  if (CheckBox4.Checked=True) and (Edit46.Text<>'') then
    Unidades:=' AND HPD8='+Edit46.Text else Unidades:='';
  //------- Ver si buscar por importe
  if (CheckBox5.Checked=True) and (Edit47.Text<>'') then
    Importe:=' AND HPD17='+Edit47.Text else Importe:='';
  //-------------------------------------
  dbHisto.Active:=False;
  dbHisto.SQL.Text:='SELECT * FROM hipedidd'+Tienda+' WHERE HPD2='+Edit1.Text+
                    ' AND HPD1>="'+FormatDateTime('YYYY-MM-DD',DateEdit3.Date)+'"'+
                    ' AND HPD1<="'+FormatDateTime('YYYY-MM-DD',DateEdit4.Date)+'"'+
                    Codigo + Unidades + Importe +
                    ' ORDER BY HPD1 DESC';
  dbHisto.Active:=True;
end;

//============================================================
//===================== GRAFICAS =============================
//============================================================
procedure TFProveedores.Graficas();
Var
  Conta: Integer;
begin
  //-------------- Mostrar los distintos años ------------------
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT DISTINCT PP1 FROM estaprove WHERE PP0="'+Edit1.Text+'" ORDER BY PP1 DESC';
  dbGrafica.Active:=True;
  ListBox3.Items.Clear; ListBox5.Items.Clear;
  dbGrafica.First;
  while not dbGrafica.EOF do
    begin
      ListBox3.Items.Add(dbGrafica.FieldByName('PP1').AsString);
      ListBox5.Items.Add(dbGrafica.FieldByName('PP1').AsString);
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
     dbGrafica.SQL.Text:='SELECT *, PP6-PP7 As BENEF FROM estaprove WHERE PP0="'+Edit1.Text+'"'+
                         ' AND PP1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                         ' ORDER BY PP1 ASC, PP2 ASC';
     dbGrafica.Active:=True; ListBox7.ItemIndex:=0;
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
procedure TFProveedores.ListBox3Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//------------------ Cambiar datos grafica -------------------
procedure TFProveedores.ListBox4Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//----------------- Cambiar tipo de grafica ----------------
procedure TFProveedores.ListBox7Click(Sender: TObject);
begin
 Chart1Serie1.Active:=False; Chart1AreaSeries1.Active:=False;
 Chart1BarSeries1.Active:=False; Chart1PieSeries1.Active:=False;
 case ListBox7.ItemIndex of
   0: Chart1Serie1.Active:=True;
   1: Chart1BarSeries1.Active:=True;
   2: Chart1AreaSeries1.Active:=True;
   3: Chart1PieSeries1.Active:=True;
 end;
end;

//--------------- Cambiar Grafica -----------------
procedure TFProveedores.CambiarGrafica();
var
  Conta: Integer;
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox3.Items.Count=0 then exit;//----- Si no hay años
  if ListBox3.ItemIndex=-1 then ListBox3.ItemIndex:=0;
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT *, PP6-PP7 As BENEF FROM estaprove WHERE PP0="'+Edit1.Text+'"'+
                      ' AND PP1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                      ' ORDER BY PP1 ASC, PP2 ASC';
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
procedure TFProveedores.ListBox5Click(Sender: TObject);
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox5.Items.Count=0 then exit;//----- Si no hay años
  if ListBox5.ItemIndex=-1 then ListBox5.ItemIndex:=0;
  RellenaEsta(ListBox5.Items.Strings[ListBox5.ItemIndex]);//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, PP6-PP7 As BENEF FROM estaprove WHERE PP0="'+Edit1.Text+'"'+
                   ' AND PP1='+ListBox5.Items.Strings[ListBox5.ItemIndex]+
                   ' ORDER BY PP1 ASC, PP2 ASC';
  dbEsta.Active:=True;
end;

//==========================================================
//============= RELLENAR MESES QUE ESTEN A 0 ===============
//==========================================================
procedure TFProveedores.RellenaEsta(Ano: String);
var
  Conta: Integer;
  UC,IC,UV,IVP,IVC,Beneficio : Double;
begin
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT * FROM estaprove WHERE PP0="'+Edit1.Text+'"'+
                   ' AND PP1='+Ano+
                   ' ORDER BY PP1 ASC, PP2 ASC';
  dbEsta.Active:=True;
  dbEsta.First;

  //*********** IMPLEMENTACIÓN DE MUESTREO DE TOTALES
    UC:=0; IC:=0; UV:=0; IVP:=0; IVC:=0; Beneficio:=0;
    While not dbEsta.EOF do
      begin
        UC := UC + dbEsta.FieldByName('PP3').Value;
        IC := IC + dbEsta.FieldByName('PP4').Value;
        UV := UV + dbEsta.FieldByName('PP5').Value;
        IVP := IVP + dbEsta.FieldByName('PP6').Value;
        IVC := IVC + dbEsta.FieldByName('PP7').Value;
        Beneficio := Beneficio + ( dbEsta.FieldByName('PP6').Value - dbEsta.FieldByName('PP7').Value );
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
      if not dbEsta.Locate('PP2',Conta,[]) then
        begin
           dbEsta.Append;
           dbEsta.FieldByName('PP0').AsString:=Edit1.Text;
           dbEsta.FieldByName('PP1').AsString:=Ano;
           dbEsta.FieldByName('PP2').AsString:=IntToStr(Conta);
           dbEsta.Post;
        end;
    end;
end;

//============================================================================
//======================== SISTEMA DE INFORMACION COMUN ======================
//============================================================================

//============= COMPROBAR CLIENTE EN SIC ==============
procedure TFProveedores.GrabarModificarSic();
begin
   CodClienteSic:=dbProve.FieldByName('P39').AsString;
   if LeerClienteSic=False then
     begin
        If Application.MessageBox('ESTE PROVEEDOR NO EXISTE EN EL S.I.C. (SISTEMA DE INFORMACION COMUN),    LO CREAMOS?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Append;
        RellenaSIC();
        dbCliSic.FieldByName('version').Value:=1;
        dbCliSic.Post;
        dbProve.Edit;
        dbProve.FieldByName('P38').AsString:='1';//--------- Control de Version
        dbProve.FieldByName('P39').AsString:=Edit1.Text;//-- Codigo siclinex
        dbProve.Post;
     end
   else
     begin
        If Application.MessageBox('QUIERE ACTUALIZAR LOS CAMBIOS EN EL S.I.C.  (SISTEMA DE INFORMACION COMUN)?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Edit;
        dbCliSic.FieldByName('version').Value:=dbCliSic.FieldByName('version').AsInteger+1;
        RellenaSIC();
        dbCliSic.Post;
        dbProve.Edit;
        dbProve.FieldByName('P38').Value:=dbCliSic.FieldByName('version').Value;//------- Control de Version
        dbProve.Post;
     end;
end;
//============= BORRAR CLIENTE EN SIC ==============
procedure TFProveedores.BorrarSic();
begin
   if LeerClienteSic=False then exit;
     begin
        If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO EN EL S.I.C.  (SISTEMA DE INFORMACION COMUN)?','FacturLinEx - SIC (Sistema de información común)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Delete;
     end;
end;

//============= LOCALIZAR CLIENTE EN SIC POR CODIGO INTERNO ==============
function TFProveedores.LeerClienteSic: Boolean;
begin
  LeerClienteSic:=False;
  //------ Buscar por codigo interno
  if dbProve.FieldByName('P39').AsString<>'' then
    begin
     dbCliSic.Active:=False;
     dbCliSic.SQL.Text:='SELECT * FROM clientes_proveedores WHERE CODIGO="'+CodClienteSic+'"'+
                        ' AND ES_PROVEEDOR=1';
     dbCliSic.Active:=True;
     if dbCliSIc.RecordCount<>0 then begin LeerClienteSic:=True; exit; end;
    end
  else
    begin
     //----- De todas maneras abro el dataset para grabar el cliente si no existe
     dbCliSic.Active:=False;
     dbCliSic.SQL.Text:='SELECT * FROM clientes_proveedores WHERE CODIGO="'+CodClienteSic+'"'+
                        ' AND ES_PROVEEDOR=1';
     dbCliSic.Active:=True;
    end;
end;

//=============== MOSTRAR PANEL DE BUSQUEDA PROVEEDORES SIC ===============
procedure TFProveedores.BitBtn15Click(Sender: TObject);
begin
  Panel6.Visible:=True;
  Panel6.BringToFront;
end;

//=================== BUSCAR PROVEEDORES DEL SIC PARA IMPORTAR ============
procedure TFProveedores.BitBtn13Click(Sender: TObject);
var
  TxtQ: String;
begin
  BitBtn12.Enabled:=False; ListBox1.Items.Clear;
  if (Edit48.Text='') and (Edit49.Text='') then exit;
  TxtQ:='SELECT * FROM clientes_proveedores WHERE ES_PROVEEDOR=1 AND ';
  if Edit49.Text<>'' then TxtQ:=TxtQ+'NOMBRE LIKE "'+Edit49.Text+'%" ';
  if (Edit49.Text<>'') and (Edit48.Text<>'') then TxtQ:=TxtQ+'AND ';
  if Edit48.Text<>'' then TxtQ:=TxtQ+'NIF LIKE "'+Edit48.Text+'%"';
  dbCliSic.Active:=False;
  dbCliSic.SQL.Text:=TxtQ;
  dbCliSic.Active:=True;
  if dbCliSIc.RecordCount=0 then begin showmessage('NO EXISTEN DATOS CON ESE FILTRO.'); exit; end;
  dbCliSic.First;
  while not dbCliSic.EOF do
    begin
      ListBox1.Items.Add(dbCliSic.FieldByName('NOMBRE').AsString);
      dbCliSic.Next;
    end;
  ListBox1.ItemIndex:=0;
  BitBtn12.Enabled:=True;
end;

//=================== IMPORTAR PROVEEDORES DEL SIC ===============
procedure TFProveedores.BitBtn12Click(Sender: TObject);
var
  Ultimo: Integer;
begin
  if ListBox1.Items.Count=0 then exit;//----- Si no hay proveedores en la lista
  if ListBox1.ItemIndex=-1 then ListBox1.ItemIndex:=0; //--- Si no hay selecionado ninguno
  dbCliSic.Locate('Nombre',ListBox1.Items.Strings[ListBox1.ItemIndex],[]);
  //----- Buscar si existe en nuestro fichero
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM proveedores WHERE P39="'+dbCliSic.FieldByName('CODIGO').AsString+'"';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    begin
       ShowMessage('ESTE PROVEEDOR DEL SIC YA EXISTE EN NUESTRO FICHERO CON EL CGO.:'+dbTrabajo.FieldByName('P0').AsString);
       Exit;
    end;
  //------ Ver cual es el ultimo proveedor en nuestro file
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT P0 FROM proveedores where P0<999990 ORDER BY P0 DESC';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then Ultimo:=1 else Ultimo:=dbTRabajo.FieldByName('P0').AsInteger+1;
  //------ Cargar datos en pantalla
  Edit1.Text:=IntToStr(Ultimo);
  LimpiaForm(); CargaSIC();
  //------ Crear proveedor en nuestro file
  if Application.MessageBox('CREAMOS EL REGISTRO EN NUESTRO FICHERO?','FacturLinEx', boxstyle) = IDYES Then
    begin
     dbProve.Append;
     LlenaReg();
     dbProve.FieldByName('P38').AsInteger:=dbCliSic.FieldByName('version').AsInteger;//- Control de Version
     dbProve.FieldByName('P39').AsString:=dbCliSic.FieldByName('CODIGO').AsString;//--- Codigo siclinex
     dbProve.Post;
     Label7.Caption:=dbProve.FieldByName('P1').AsString;//--- Refrescar nombre.
    end
  else LimpiaForm();
  //---------------------
  dbTrabajo.Active:=False; ListBox1.Items.Clear;
  BitBtn12.Enabled:=False; Panel6.Visible:=False;
  Tabsheet1.SetFocus;
end;

//============== CERRAR PANEL IMPORTAR PROVEEDORES SIC ===========
procedure TFProveedores.BitBtn14Click(Sender: TObject);
begin
  Panel6.Visible:=False; BitBtn12.Enabled:=False;
end;

//================== RELLENAR CAMPOS DEL SIC ===================
procedure TFProveedores.RellenaSIC();
begin
  dbCliSic.FieldByName('NOMBRE').AsString:=Edit2.Text;
  dbCliSic.FieldByName('NIF').AsString:=Edit8.Text;
  dbCliSic.FieldByName('CODIGO').AsString:=Edit1.Text;
  dbCliSic.FieldByName('DIRECCION').AsString:=Edit4.Text;
  dbCliSic.FieldByName('CODPOSTAL').AsString:=Edit6.Text;
  dbCliSic.FieldByName('TELEFONO1').AsString:=Edit10.Text;
  dbCliSic.FieldByName('FAX').AsString:=Edit11.Text;
  dbCliSic.FieldByName('EMAIL').AsString:=Edit9.Text;
  dbCliSic.FieldByName('RESPONSABLE').AsString:=Edit3.Text;
  dbCliSic.FieldByName('ES_PROVEEDOR').AsString:='1';
end;

//================== RELLENAR CAMPOS DEL SIC ===================
procedure TFProveedores.CargaSIC();
begin
  Edit2.Text:=dbCliSic.FieldByName('NOMBRE').AsString;
  Edit8.Text:=dbCliSic.FieldByName('NIF').AsString;
  Edit4.Text:=dbCliSic.FieldByName('DIRECCION').AsString;
  Edit6.Text:=dbCliSic.FieldByName('CODPOSTAL').AsString;
  Edit10.Text:=dbCliSic.FieldByName('TELEFONO1').AsString;
  Edit11.Text:=dbCliSic.FieldByName('FAX').AsString;
  Edit9.Text:=dbCliSic.FieldByName('EMAIL').AsString;
  Edit3.Text:=dbCliSic.FieldByName('RESPONSABLE').AsString;
end;

Initialization
  {$I proveedores.lrs}

End.

