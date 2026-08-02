{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010,

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

Unit historicoop;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, EditBtn, MaskEdit, Grids, LR_Class, LR_DBSet, lr_e_pdf;

Type

  { TFLHistoop }

  TFLHistoop = Class(Tform)
    BitBtn26: TBitBtn;
    BitBtn27: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtnCambiable: TBitBtn;
    btPuesto: TBitBtn;
    CheckBox1: TCheckBox;
    cbTodosPuestos: TCheckBox;
    CheckBox2: TCheckBox;
    ComboBox1: TComboBox;
    ComboBoxHoraDesde: TComboBox;
    ComboBoxHoraHasta: TComboBox;
    ComboCambiableNombre: TComboBox;
    Datasource2: TDatasource;
    DateEditDesde: TDateEdit;
    DateEditHasta: TDateEdit;
    dbCambiable: TZQuery;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    dbCreditos: TZQuery;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    dbHistodd: TZQuery;
    dbMuestrac: TZQuery;
    dbMuestrad: TZQuery;
    dbUsu: TZQuery;
    Edit1: TEdit;
    EditCambiableCodigo: TEdit;
    edCodigoPuesto: TEdit;
    edDescripcionPuesto: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LabelCambiable: TLabel;
    lbPuesto: TLabel;
    LabelTituloDBGrid: TLabel;
    lbCodigoPuesto: TLabel;
    lbDescripcionPuesto: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Bitbtn1: Tbitbtn;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    BitBtn4: TBitBtn;
    Datasource1: TDatasource;
    dbOperaciones: TZQuery;
    PanelCambiable: TPanel;
    PanelPuesto: TPanel;
    PanelRadioButton: TPanel;
    PanelLeyenda: TPanel;
    PanelDetalleOperacion: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    StaticTextCambiableNombre: TStaticText;
    StaticTextEntregaContado: TStaticText;
    StaticTextLabEntrega1: TStaticText;
    StaticTextLabTotal: TStaticText;
    StaticTextHora: TStaticText;
    StaticTextLabVend: TStaticText;
    StaticTextVend: TStaticText;
    StaticTextTipoPago: TStaticText;
    StaticTextNumOper: TStaticText;
    StaticTextLabNumOper: TStaticText;
    StaticTextCliente: TStaticText;
    StaticTextLabCliente: TStaticText;
    StaticTextLabEntrega: TStaticText;
    StaticTextLabCambio: TStaticText;
    StaticTextTotal: TStaticText;
    StaticTextEntrega: TStaticText;
    StaticTextCambio: TStaticText;
    StaticTextLabFecha: TStaticText;
    StaticTextLabHora: TStaticText;
    StaticTextFecha: TStaticText;
    dbPuesto: TZQuery;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn26Click(Sender: TObject);
    procedure BitBtn27Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure btPuestoClick(Sender: TObject);
    procedure cbTodosPuestosChange(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure DateEditDesdeExit(Sender: TObject);
    procedure DateEditHastaExit(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edCodigoPuestoEnter(Sender: TObject);
    procedure edCodigoPuestoExit(Sender: TObject);
    procedure edDescripcionPuestoExit(Sender: TObject);
    procedure edDescripcionPuestoKeyPress(Sender: TObject; var Key: char);
    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGrid4TitleClick(Column: TColumn);
    procedure DBGrid3TitleClick(Column: TColumn);
    procedure DBGrid5TitleClick(Column: TColumn);
    procedure BlancoGrid(Grid: TDBGrid);
    procedure RadioButton1ChangeBounds(Sender: TObject);
    procedure RadioButton2ChangeBounds(Sender: TObject);
    procedure RadioButton3ChangeBounds(Sender: TObject);
    procedure RadioButton4ChangeBounds(Sender: TObject);
    procedure RadioButton5ChangeBounds(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7ChangeBounds(Sender: TObject);
    procedure RadioButton8ChangeBounds(Sender: TObject);
    procedure RadioButton9ChangeBounds(Sender: TObject);
    procedure BitBtnCambiableClick(Sender: TObject);
    procedure ComboCambiableNombreClick(Sender: TObject);
    procedure ComboCambiableNombreKeyPress(Sender: TObject; var Key: char);
    procedure EditCambiableCodigoExit(Sender: TObject);
    procedure EditCambiableCodigoEnter(Sender: TObject);

    procedure OcultarBDGrid();
    procedure DimensionarColocarBDGrid();

    procedure RecuperaOperacion();

    procedure ImpreTicket(regalo: boolean);
    procedure CabeceraTicket();
    procedure TotalTicket(n1,n2,n3,ti1,ti2,ti3,i1,i2,i3: Double);
    procedure PieTicket();
    procedure ImprimeQRTicket();

    procedure Corte();


  Private
    { Private Declarations }
    FPanelPeriodo: TPanel;
    FLabelPeriodo: TLabel;
    FHeaderSubtitle: TLabel;
    FFooterHint: TLabel;
    FDetalleTitulo: TLabel;
    FDisenoAplicado: Boolean;
    FEnAjusteDiseno: Boolean;
    procedure dbOperacionesAfterOpen(DataSet: TDataSet);
    procedure CrearControlesVisuales;
    procedure AplicarDisenoModerno;
    procedure AjustarDisenoModerno;
    procedure ActualizarVistaSeleccion(ASeleccion: Boolean);
    procedure FormResizeModerno(Sender: TObject);
    procedure EstiloBoton(ABoton: TBitBtn; AColor: TColor;
      ATextoClaro: Boolean = True);
    procedure EstiloGrid(AGrid: TDBGrid);
    procedure DBGridModernoDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
  Public
    { Public Declarations }
  End;

  procedure ShowFormHistoop;
  
Var
  FLHistoop: TFLHistoop;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;
  PrintText: TextFile;
  nPuestoDetalles, nPuestoCabeceras: string;

Implementation

uses
  Global, Funciones, Imprimir, Ventas, busquedas;

const
  HOP_GS = #29;
  HOP_ESC = #27;
  // En el comando de tamaño QR usamos #6 para quedar alrededor de 30x30 mm.
  // Antes estaba en #8 y se iba por encima de 4 cm en muchas ticketadoras.

function HOP_EsModoProduccion: Boolean;
var
  M: string;
begin
  M := UpperCase(Trim(vfMode));
  Result := (M = 'PRODUCCION') or (Copy(M, 1, 4) = 'PROD');
end;

function HOP_QRImporte(const AImporte: Double): string;
begin
  Result := StringReplace(FormatFloat('0.00', AImporte), ',', '.', [rfReplaceAll]);
end;

function HOP_NormalizaSerieFS(const ASerie: string): string;
var
  S: string;
begin
  S := Trim(ASerie);
  if Copy(UpperCase(S), 1, 3) = 'FS-' then
    Result := S
  else
    Result := 'FS-' + S;
end;

function HOP_BuildQRTributario(const ASerie, ANumero: string;
  const AFecha: TDateTime; const AImporte: Double): string;
begin
  // En histórico la serie queda guardada como A26/B26/R26/etc.
  // Para el QR tributario de tickets se informa como FS-serie-numero,
  // sin modificar la BBDD ni ampliar campos.
  Result := vfUrl + 'nif=' + NIF +
            '&numserie=' + HOP_NormalizaSerieFS(ASerie) + '-' + Trim(ANumero) +
            '&fecha=' + FormatDateTime('dd-mm-yyyy', AFecha) +
            '&importe=' + HOP_QRImporte(AImporte);
end;

//====================================================================
// DISEÑO MODERNO CONSERVADOR
// Solo modifica presentación y distribución. No altera consultas, eventos,
// impresión, QR ni la generación de ventas/abonos.
//====================================================================
procedure TFLHistoop.EstiloBoton(ABoton: TBitBtn; AColor: TColor;
  ATextoClaro: Boolean);
begin
  if not Assigned(ABoton) then
    Exit;

  ABoton.Color := AColor;
  ABoton.Font.Style := [fsBold];
  ABoton.Font.Height := -13;
  if ATextoClaro then
    ABoton.Font.Color := clWhite
  else
    ABoton.Font.Color := RGBToColor(30, 41, 59);
end;

procedure TFLHistoop.EstiloGrid(AGrid: TDBGrid);
begin
  if not Assigned(AGrid) then
    Exit;

  AGrid.Align := alNone;
  AGrid.Color := clWhite;
  AGrid.Font.Color := RGBToColor(30, 41, 59);
  AGrid.Font.Height := -13;
  AGrid.DefaultRowHeight := 25;
  AGrid.GridLineColor := RGBToColor(203, 213, 225);
  AGrid.TitleFont.Color := clWhite;
  AGrid.TitleFont.Style := [fsBold];
  AGrid.TitleFont.Height := -13;
end;

procedure TFLHistoop.DBGridModernoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Grid: TDBGrid;
  EstadoPintado: TGridDrawState;
begin
  if not (Sender is TDBGrid) then
    Exit;

  Grid := TDBGrid(Sender);
  EstadoPintado := State - [gdSelected, gdFocused];
  Grid.Canvas.Font.Style := [];

  if gdSelected in State then
  begin
    Grid.Canvas.Brush.Color := RGBToColor(219, 234, 254);
    Grid.Canvas.Font.Color := RGBToColor(15, 23, 42);
    Grid.Canvas.Font.Style := [fsBold];
  end
  else
  begin
    Grid.Canvas.Brush.Color := Column.Color;
    Grid.Canvas.Font.Color := RGBToColor(30, 41, 59);
  end;

  Grid.Canvas.FillRect(Rect);
  Grid.DefaultDrawColumnCell(Rect, DataCol, Column, EstadoPintado);
end;

procedure TFLHistoop.CrearControlesVisuales;
begin
  if Assigned(FPanelPeriodo) then
    Exit;

  // Las etiquetas que se distribuyen manualmente no deben recalcular su
  // tamaño según el texto. AutoSize junto con SetBounds puede provocar un
  // bucle de ChangeBounds en determinadas versiones de GTK/Lazarus.
  LabelTituloDBGrid.AutoSize := False;
  Label1.AutoSize := False;
  Label2.AutoSize := False;
  Label3.AutoSize := False;
  Label4.AutoSize := False;
  Label5.AutoSize := False;
  Label6.AutoSize := False;
  Label11.AutoSize := False;
  Label12.AutoSize := False;
  LabelCambiable.AutoSize := False;
  lbPuesto.AutoSize := False;
  lbCodigoPuesto.AutoSize := False;
  lbDescripcionPuesto.AutoSize := False;

  FHeaderSubtitle := TLabel.Create(Self);
  FHeaderSubtitle.Parent := PanelTituloGrid;
  FHeaderSubtitle.AutoSize := False;
  FHeaderSubtitle.Caption :=
    'Consulta, revisa, reimprime y recupera operaciones con total trazabilidad';

  FPanelPeriodo := TPanel.Create(Self);
  FPanelPeriodo.Parent := Self;
  FPanelPeriodo.BevelOuter := bvNone;
  FPanelPeriodo.BorderWidth := 1;
  FPanelPeriodo.Color := clWhite;

  FLabelPeriodo := TLabel.Create(Self);
  FLabelPeriodo.Parent := FPanelPeriodo;
  FLabelPeriodo.AutoSize := False;
  FLabelPeriodo.Caption := 'Periodo y horario de consulta';

  // Los controles conservan sus eventos; solo cambian de contenedor visual.
  Label2.Parent := FPanelPeriodo;
  Label1.Parent := FPanelPeriodo;
  Label3.Parent := FPanelPeriodo;
  Label4.Parent := FPanelPeriodo;
  DateEditDesde.Parent := FPanelPeriodo;
  DateEditHasta.Parent := FPanelPeriodo;
  ComboBoxHoraDesde.Parent := FPanelPeriodo;
  ComboBoxHoraHasta.Parent := FPanelPeriodo;

  FFooterHint := TLabel.Create(Self);
  FFooterHint.Parent := Panel1;
  FFooterHint.AutoSize := False;
  FFooterHint.Caption :=
    'Doble clic: abrir detalle  ·  Cabeceras: ordenar  ·  Rojo: operación en crédito';

  FDetalleTitulo := TLabel.Create(Self);
  FDetalleTitulo.Parent := PanelDetalleOperacion;
  FDetalleTitulo.AutoSize := False;
  FDetalleTitulo.Caption := 'Detalle de la operación seleccionada';
end;

procedure TFLHistoop.AplicarDisenoModerno;
var
  I: Integer;
  R: TRadioButton;
begin
  // Estos controles se distribuyen manualmente. Se eliminan Align,
  // Anchors y AnchorSides heredados del LFM para que GTK/LCL no intente
  // recalcular sus límites al mismo tiempo que AjustarDisenoModerno.
  PanelCambiable.Align := alNone;
  PanelCambiable.Anchors := [akTop, akLeft];

  PanelPuesto.Align := alNone;
  PanelPuesto.Anchors := [akTop, akLeft];
  PanelPuesto.AnchorSideRight.Control := nil;
  PanelPuesto.BorderSpacing.Right := 0;

  PanelRadioButton.Align := alNone;
  PanelRadioButton.Anchors := [akTop, akLeft];

  PanelLeyenda.Align := alNone;
  PanelLeyenda.Anchors := [akTop, akLeft];

  PanelDetalleOperacion.Align := alNone;
  PanelDetalleOperacion.Anchors := [akTop, akLeft];
  PanelDetalleOperacion.AnchorSideRight.Control := nil;
  PanelDetalleOperacion.AnchorSideBottom.Control := nil;
  PanelDetalleOperacion.BorderSpacing.Bottom := 0;

  DBGrid1.Align := alNone;
  DBGrid1.Anchors := [akTop, akLeft];
  DBGrid1.AnchorSideRight.Control := nil;
  DBGrid1.AnchorSideBottom.Control := nil;

  DBGrid2.Align := alNone;
  DBGrid2.Anchors := [akTop, akLeft];
  DBGrid2.AnchorSideRight.Control := nil;
  DBGrid2.AnchorSideBottom.Control := nil;

  DBGrid4.Align := alNone;
  DBGrid4.Anchors := [akTop, akLeft];
  DBGrid4.AnchorSideRight.Control := nil;
  DBGrid4.AnchorSideBottom.Control := nil;

  DBGrid5.Align := alNone;
  DBGrid5.Anchors := [akTop, akLeft];
  DBGrid5.AnchorSideRight.Control := nil;
  DBGrid5.AnchorSideBottom.Control := nil;

  DBGrid3.Align := alNone;
  DBGrid3.Anchors := [akTop, akLeft];
  DBGrid3.AnchorSideBottom.Control := nil;
  DBGrid3.BorderSpacing.Bottom := 0;

  BitBtn1.Anchors := [akTop, akLeft];
  BitBtn2.Anchors := [akTop, akLeft];
  BitBtn3.Anchors := [akTop, akLeft];
  BitBtn4.Anchors := [akTop, akLeft];
  BitBtn5.Anchors := [akTop, akLeft];

  BitBtn26.Anchors := [akTop, akLeft];
  BitBtn26.AnchorSideBottom.Control := nil;
  BitBtn26.BorderSpacing.Bottom := 0;

  BitBtn27.Anchors := [akTop, akLeft];
  BitBtn27.AnchorSideBottom.Control := nil;
  BitBtn27.BorderSpacing.Bottom := 0;

  CheckBox1.Anchors := [akTop, akLeft];
  CheckBox1.AnchorSideBottom.Control := nil;
  CheckBox1.BorderSpacing.Bottom := 0;

  ComboBox1.Anchors := [akTop, akLeft];
  ComboBox1.AnchorSideBottom.Control := nil;
  ComboBox1.BorderSpacing.Bottom := 0;

  CheckBox2.Anchors := [akTop, akLeft];
  CheckBox2.AnchorSideLeft.Control := nil;
  CheckBox2.AnchorSideRight.Control := nil;

  FEnAjusteDiseno := False;
  Color := RGBToColor(241, 245, 249);
  Font.Name := 'Sans';
  Font.Height := -13;

  PanelTituloGrid.BevelOuter := bvNone;
  PanelTituloGrid.Color := RGBToColor(15, 76, 92);
  LabelTituloDBGrid.Font.Color := clWhite;
  LabelTituloDBGrid.Font.Style := [fsBold];
  LabelTituloDBGrid.Font.Height := -20;
  if Trim(LabelTituloDBGrid.Caption) = '' then
    LabelTituloDBGrid.Caption := 'Histórico de operaciones';

  FHeaderSubtitle.Font.Color := RGBToColor(204, 231, 236);
  FHeaderSubtitle.Font.Height := -12;

  FPanelPeriodo.Color := clWhite;
  FLabelPeriodo.Font.Color := RGBToColor(15, 76, 92);
  FLabelPeriodo.Font.Style := [fsBold];
  FLabelPeriodo.Font.Height := -16;

  Label2.Font.Color := RGBToColor(71, 85, 105);
  Label1.Font.Color := RGBToColor(71, 85, 105);
  Label3.Font.Color := RGBToColor(71, 85, 105);
  Label4.Font.Color := RGBToColor(71, 85, 105);
  Label2.Font.Style := [fsBold];
  Label1.Font.Style := [fsBold];
  Label3.Font.Style := [fsBold];
  Label4.Font.Style := [fsBold];

  DateEditDesde.Font.Height := -14;
  DateEditHasta.Font.Height := -14;
  ComboBoxHoraDesde.Font.Height := -14;
  ComboBoxHoraHasta.Font.Height := -14;

  PanelCambiable.BevelOuter := bvNone;
  PanelCambiable.BorderWidth := 1;
  PanelCambiable.Color := clWhite;
  LabelCambiable.Font.Color := RGBToColor(15, 76, 92);
  LabelCambiable.Font.Style := [fsBold];
  EditCambiableCodigo.Font.Height := -14;
  StaticTextCambiableNombre.Font.Color := RGBToColor(30, 41, 59);
  StaticTextCambiableNombre.Font.Height := -14;
  ComboCambiableNombre.Font.Height := -14;

  PanelPuesto.BevelOuter := bvNone;
  PanelPuesto.BorderWidth := 1;
  PanelPuesto.Color := clWhite;
  lbPuesto.Font.Color := RGBToColor(15, 76, 92);
  lbPuesto.Font.Style := [fsBold];
  lbPuesto.Font.Height := -16;
  lbCodigoPuesto.Font.Color := RGBToColor(71, 85, 105);
  lbDescripcionPuesto.Font.Color := RGBToColor(71, 85, 105);
  edCodigoPuesto.Font.Height := -14;
  edDescripcionPuesto.Font.Height := -14;

  PanelRadioButton.BevelOuter := bvNone;
  PanelRadioButton.BorderWidth := 1;
  PanelRadioButton.Color := clWhite;
  Label5.Font.Color := RGBToColor(15, 76, 92);
  Label5.Font.Style := [fsBold];
  Label5.Font.Height := -16;

  for I := 0 to PanelRadioButton.ControlCount - 1 do
    if PanelRadioButton.Controls[I] is TRadioButton then
    begin
      R := TRadioButton(PanelRadioButton.Controls[I]);
      R.Font.Color := RGBToColor(30, 41, 59);
      R.Font.Height := -13;
    end;

  Label11.Font.Color := RGBToColor(71, 85, 105);
  Label12.Font.Color := RGBToColor(100, 116, 139);
  Edit1.Font.Height := -14;

  PanelLeyenda.BevelOuter := bvNone;
  PanelLeyenda.BorderWidth := 1;
  PanelLeyenda.Color := RGBToColor(255, 251, 235);
  Label6.Font.Color := RGBToColor(146, 64, 14);
  Label6.Font.Style := [fsBold];
  for I := 0 to PanelLeyenda.ControlCount - 1 do
    if PanelLeyenda.Controls[I] is TLabel then
      TLabel(PanelLeyenda.Controls[I]).Font.Height := -12;
  Label13.Font.Color := RGBToColor(185, 28, 28);
  Label13.Font.Style := [fsBold];

  Panel1.BevelOuter := bvNone;
  Panel1.BorderWidth := 1;
  Panel1.Color := clWhite;
  FFooterHint.Font.Color := RGBToColor(100, 116, 139);
  FFooterHint.Font.Height := -12;

  EstiloBoton(BitBtn1, RGBToColor(15, 118, 110));
  EstiloBoton(BitBtn2, RGBToColor(37, 99, 235));
  EstiloBoton(BitBtn3, RGBToColor(71, 85, 105));
  EstiloBoton(BitBtn5, RGBToColor(124, 58, 237));
  EstiloBoton(BitBtn4, RGBToColor(185, 28, 28));
  EstiloBoton(BitBtn26, RGBToColor(37, 99, 235));
  EstiloBoton(BitBtn27, RGBToColor(71, 85, 105));
  EstiloBoton(BitBtnCambiable, RGBToColor(15, 118, 110));
  EstiloBoton(btPuesto, RGBToColor(15, 118, 110));

  BitBtn1.Caption := 'Visualizar';
  BitBtn2.Caption := 'Imprimir';
  BitBtn3.Caption := 'Nueva selección';
  BitBtn5.Caption := 'Generar venta/abono';
  BitBtn4.Caption := 'Cerrar';

  PanelDetalleOperacion.BevelOuter := bvNone;
  PanelDetalleOperacion.BorderWidth := 1;
  PanelDetalleOperacion.Color := clWhite;
  FDetalleTitulo.Font.Color := RGBToColor(15, 76, 92);
  FDetalleTitulo.Font.Style := [fsBold];
  FDetalleTitulo.Font.Height := -16;

  StaticTextLabNumOper.Font.Color := RGBToColor(100, 116, 139);
  StaticTextLabCliente.Font.Color := RGBToColor(100, 116, 139);
  StaticTextLabFecha.Font.Color := RGBToColor(100, 116, 139);
  StaticTextLabHora.Font.Color := RGBToColor(100, 116, 139);
  StaticTextLabVend.Font.Color := RGBToColor(100, 116, 139);
  StaticTextLabTotal.Font.Color := RGBToColor(15, 76, 92);
  StaticTextLabEntrega.Font.Color := RGBToColor(37, 99, 235);
  StaticTextLabCambio.Font.Color := RGBToColor(5, 150, 105);

  StaticTextNumOper.Font.Style := [fsBold];
  StaticTextCliente.Font.Style := [fsBold];
  StaticTextTipoPago.Font.Style := [fsBold];
  StaticTextTotal.Font.Style := [fsBold];
  StaticTextTotal.Font.Height := -23;
  StaticTextTotal.Font.Color := RGBToColor(15, 76, 92);
  StaticTextEntrega.Font.Style := [fsBold];
  StaticTextEntrega.Font.Color := RGBToColor(37, 99, 235);
  StaticTextCambio.Font.Style := [fsBold];
  StaticTextCambio.Font.Color := RGBToColor(5, 150, 105);
  StaticTextEntregaContado.Font.Style := [fsBold];
  StaticTextEntregaContado.Font.Color := RGBToColor(37, 99, 235);

  EstiloGrid(DBGrid1);
  EstiloGrid(DBGrid2);
  EstiloGrid(DBGrid3);
  EstiloGrid(DBGrid4);
  EstiloGrid(DBGrid5);

  DBGrid2.OnDrawColumnCell := @DBGridModernoDrawColumnCell;
  DBGrid3.OnDrawColumnCell := @DBGridModernoDrawColumnCell;
  DBGrid4.OnDrawColumnCell := @DBGridModernoDrawColumnCell;
  DBGrid5.OnDrawColumnCell := @DBGridModernoDrawColumnCell;

  FDisenoAplicado := True;
end;

procedure TFLHistoop.ActualizarVistaSeleccion(ASeleccion: Boolean);
begin
  if Assigned(FPanelPeriodo) then
    FPanelPeriodo.Visible := ASeleccion;
  PanelPuesto.Visible := ASeleccion;
  PanelRadioButton.Visible := ASeleccion;
  PanelCambiable.Visible := ASeleccion;

  if ASeleccion then
  begin
    PanelDetalleOperacion.Visible := False;
    PanelLeyenda.Visible := False;
    if Trim(LabelTituloDBGrid.Caption) = '' then
      LabelTituloDBGrid.Caption := 'Histórico de operaciones';
  end;

  AjustarDisenoModerno;
end;

procedure TFLHistoop.AjustarDisenoModerno;
var
  Margen, AnchoFiltro, AnchoIzq, AltoDetalle, AltoGrid: Integer;
  GridActivo: TDBGrid;
begin
  if (not FDisenoAplicado) or FEnAjusteDiseno then
    Exit;

  FEnAjusteDiseno := True;
  DisableAlign;
  Panel1.DisableAlign;
  PanelDetalleOperacion.DisableAlign;
  try
    Margen := 18;
  PanelTituloGrid.Height := 64;
  LabelTituloDBGrid.SetBounds(18, 7, ClientWidth - 36, 28);
  FHeaderSubtitle.SetBounds(19, 35, ClientWidth - 38, 20);

  Panel1.Height := 78;
  BitBtn1.SetBounds(16, 14, 116, 48);
  BitBtn2.SetBounds(142, 14, 116, 48);
  BitBtn3.SetBounds(268, 14, 148, 48);
  BitBtn5.SetBounds(426, 14, 178, 48);
  BitBtn4.SetBounds(Panel1.ClientWidth - 132, 14, 116, 48);
  FFooterHint.SetBounds(620, 27, Panel1.ClientWidth - 770, 22);

  AnchoFiltro := 304;
  AnchoIzq := ClientWidth - AnchoFiltro - (Margen * 3);
  if AnchoIzq < 560 then
    AnchoIzq := 560;

  FPanelPeriodo.SetBounds(Margen, 86, AnchoIzq, 116);
  FLabelPeriodo.SetBounds(16, 10, AnchoIzq - 32, 24);
  Label2.SetBounds(18, 42, 90, 20);
  DateEditDesde.SetBounds(112, 36, 118, DateEditDesde.Height);
  Label1.SetBounds(258, 42, 90, 20);
  DateEditHasta.SetBounds(352, 36, 118, DateEditHasta.Height);
  Label3.SetBounds(18, 80, 90, 20);
  ComboBoxHoraDesde.SetBounds(112, 73, 118, ComboBoxHoraDesde.Height);
  Label4.SetBounds(258, 80, 90, 20);
  ComboBoxHoraHasta.SetBounds(352, 73, 118, ComboBoxHoraHasta.Height);

  PanelCambiable.SetBounds(Margen, 216, AnchoIzq, 64);
  LabelCambiable.SetBounds(16, 22, 98, 22);
  EditCambiableCodigo.SetBounds(120, 16, 96, EditCambiableCodigo.Height);
  BitBtnCambiable.SetBounds(222, 16, 34, 31);
  StaticTextCambiableNombre.SetBounds(266, 16, AnchoIzq - 282, 31);
  ComboCambiableNombre.SetBounds(266, 16, AnchoIzq - 282,
    ComboCambiableNombre.Height);

  // Los TCheckBox y TRadioButton conservan su tamaño nativo GTK.
  // Solo se cambia su posición para evitar bucles ChangeBounds.
  PanelPuesto.SetBounds(Margen, 294, AnchoIzq, 126);
  lbPuesto.SetBounds(16, 10, AnchoIzq - 32, 24);
  lbCodigoPuesto.SetBounds(18, 47, 60, 20);
  edCodigoPuesto.SetBounds(82, 40, 66, edCodigoPuesto.Height);
  btPuesto.SetBounds(154, 40, 34, 30);
  lbDescripcionPuesto.SetBounds(204, 47, 80, 20);
  edDescripcionPuesto.SetBounds(290, 40, AnchoIzq - 306,
    edDescripcionPuesto.Height);
  cbTodosPuestos.Left := 18;
  cbTodosPuestos.Top := 86;

  PanelRadioButton.SetBounds(ClientWidth - AnchoFiltro - Margen,
    86, AnchoFiltro, 396);
  Label5.SetBounds(18, 12, AnchoFiltro - 36, 24);
  RadioButton1.Left := 18; RadioButton1.Top := 43;
  RadioButton2.Left := 18; RadioButton2.Top := 72;
  RadioButton3.Left := 18; RadioButton3.Top := 101;
  RadioButton4.Left := 18; RadioButton4.Top := 130;
  RadioButton5.Left := 18; RadioButton5.Top := 159;
  RadioButton9.Left := 18; RadioButton9.Top := 188;
  RadioButton7.Left := 18; RadioButton7.Top := 217;
  RadioButton8.Left := 18; RadioButton8.Top := 246;
  RadioButton6.Left := 18; RadioButton6.Top := 275;
  Label11.SetBounds(18, 306, 260, 20);
  Edit1.SetBounds(18, 327, 268, Edit1.Height);
  Label12.SetBounds(18, 361, 268, 20);

  PanelLeyenda.SetBounds(ClientWidth - 314, 88, 286, 270);
  Label6.SetBounds(12, 8, 260, 23);

  GridActivo := nil;
  if DBGrid1.Visible then GridActivo := DBGrid1
  else if DBGrid2.Visible then GridActivo := DBGrid2
  else if DBGrid4.Visible then GridActivo := DBGrid4
  else if DBGrid5.Visible then GridActivo := DBGrid5;

  if Assigned(GridActivo) then
  begin
    AltoDetalle := 0;
    if PanelDetalleOperacion.Visible and (GridActivo = DBGrid1) then
      AltoDetalle := 294;

    AltoGrid := ClientHeight - PanelTituloGrid.Height - Panel1.Height -
      AltoDetalle - (Margen * 2);
    if AltoGrid < 180 then
      AltoGrid := 180;

    GridActivo.Align := alNone;
    GridActivo.SetBounds(Margen, PanelTituloGrid.Height + 10,
      ClientWidth - (Margen * 2), AltoGrid);

    if PanelDetalleOperacion.Visible and (GridActivo = DBGrid1) then
    begin
      PanelDetalleOperacion.SetBounds(Margen, GridActivo.Top + GridActivo.Height + 8,
        ClientWidth - (Margen * 2), 286);
      FDetalleTitulo.SetBounds(14, 8, PanelDetalleOperacion.ClientWidth - 28, 24);

      StaticTextLabNumOper.SetBounds(16, 38, 98, 22);
      StaticTextNumOper.SetBounds(118, 38, 96, 22);
      StaticTextTipoPago.SetBounds(226, 38, 150, 22);
      StaticTextLabCliente.SetBounds(390, 38, 62, 22);
      StaticTextCliente.SetBounds(456, 38,
        PanelDetalleOperacion.ClientWidth - 760, 22);
      StaticTextLabTotal.SetBounds(PanelDetalleOperacion.ClientWidth - 260,
        35, 62, 24);
      StaticTextTotal.SetBounds(PanelDetalleOperacion.ClientWidth - 194,
        30, 174, 34);

      StaticTextLabFecha.SetBounds(16, 70, 50, 22);
      StaticTextFecha.SetBounds(70, 70, 96, 22);
      StaticTextLabHora.SetBounds(176, 70, 42, 22);
      StaticTextHora.SetBounds(222, 70, 82, 22);
      StaticTextLabVend.SetBounds(316, 70, 62, 22);
      StaticTextVend.SetBounds(382, 70, 180, 22);
      StaticTextLabEntrega.SetBounds(PanelDetalleOperacion.ClientWidth - 472,
        70, 68, 22);
      StaticTextEntrega.SetBounds(PanelDetalleOperacion.ClientWidth - 400,
        70, 76, 22);
      StaticTextLabEntrega1.SetBounds(PanelDetalleOperacion.ClientWidth - 320,
        70, 16, 22);
      StaticTextEntregaContado.SetBounds(PanelDetalleOperacion.ClientWidth - 302,
        70, 76, 22);
      StaticTextLabCambio.SetBounds(PanelDetalleOperacion.ClientWidth - 218,
        70, 60, 22);
      StaticTextCambio.SetBounds(PanelDetalleOperacion.ClientWidth - 154,
        70, 134, 22);

      DBGrid3.SetBounds(12, 101, PanelDetalleOperacion.ClientWidth - 24, 134);
      CheckBox1.Left := 16; CheckBox1.Top := 247;
      ComboBox1.SetBounds(302, 244, 250, ComboBox1.Height);
      BitBtn27.SetBounds(568, 244, 126, 32);
      CheckBox2.Left := 710; CheckBox2.Top := 247;
      BitBtn26.SetBounds(PanelDetalleOperacion.ClientWidth - 132,
        244, 116, 32);
    end;
  end;
  finally
    PanelDetalleOperacion.EnableAlign;
    Panel1.EnableAlign;
    EnableAlign;
    FEnAjusteDiseno := False;
  end;
end;

procedure TFLHistoop.FormResizeModerno(Sender: TObject);
begin
  AjustarDisenoModerno;
end;

//=============== Crea el formulario ================
procedure ShowFormHistoop;
begin
  with TFLHistoop.Create(Application) do
    begin
       ShowModal;
    end;
end;
Procedure TFLHistoop.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.

  //---------------------Paneles visibles por defecto
  PanelDetalleOperacion.Visible:=False;
  PanelRadioButton.Visible:=True;
  PanelLeyenda.Visible:=False;
  PanelCambiable.Visible:=True;

  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False; BitBtn5.Enabled:=False;

  DateEditDesde.Date:=Date; // StrToDate('01/01/'+FormatDateTime('YYYY',Date));
  DateEditHasta.Date:=Date;
  LabelCambiable.Caption:='Cliente';
  EditCambiableCodigo.Text:= '';
  nPuestoDetalles:=''; nPuestoCabeceras:='';

  // Ocultamos todos los DBGrid
  DimensionarColocarBDGrid();
  OcultarBDGrid();

  CrearControlesVisuales;
  AplicarDisenoModerno;
  OnResize := @FormResizeModerno;
  ActualizarVistaSeleccion(True);
End;

//-- Mantener compatibilidad al añadir campos nuevos en hisopcc (p.ej. HO20_RECT)
//   Si el TZQuery tiene campos persistentes antiguos, el nuevo campo no aparece.
//   Aquí lo creamos en tiempo de ejecución sin alterar la lógica existente.
procedure TFLHistoop.dbOperacionesAfterOpen(DataSet: TDataSet);
var
  F: TStringField;
  Col: TColumn;
  i: Integer;
  HasCol: Boolean;
begin
  // 1) Garantiza que el campo existe en el dataset (aunque haya Fields persistentes antiguos)
  if (dbOperaciones.FindField('HO20_RECT')=nil) and (dbOperaciones.FieldDefs.IndexOf('HO20_RECT')>=0) then
  begin
    F:=TStringField.Create(dbOperaciones);
    F.FieldName:='HO20_RECT';
    F.Size:=255;
    F.DataSet:=dbOperaciones;
  end;

  // 2) Si el grid tiene columnas persistentes, añadimos la columna para visualizarlo.
  //    OJO: si Columns.Count=0, el grid autogenera columnas y no conviene forzar persistentes aquí.
  if (DBGrid1<>nil) and (DBGrid1.Columns.Count>0) and (dbOperaciones.FindField('HO20_RECT')<>nil) then
  begin
    HasCol:=False;
    for i:=0 to DBGrid1.Columns.Count-1 do
      if SameText(DBGrid1.Columns[i].FieldName,'HO20_RECT') then begin HasCol:=True; break; end;

    if not HasCol then
    begin
      Col:=DBGrid1.Columns.Add;
      Col.FieldName:='HO20_RECT';
      Col.Title.Caption:='RECTIF';
      Col.Width:=120;
    end;
  end;
end;



//==================== CERRAR ======================
procedure TFLHistoop.BitBtn4Click(Sender: TObject);
begin
  Edit1.Visible:=False;
  Label11.Visible:=False;
  dbOperaciones.Active:=False;
  Close();
end;

//==============GENERACION AUTOMATICA DE UNA VENTA ============
procedure TFLHistoop.BitBtn5Click(Sender: TObject);
var
  multiplicador: string;
  nMultiplicador: Double;
begin
  multiplicador:='-1';
  // Confirma la grabación de una nueva venta y solicita el multiplicador
  if Application.MessageBox('PROCESO PARA GENERAR NUEVA VENTA'+#13 + '¿DESEA CONTINUAR?',
                            'FacturLinEx 2', MB_ICONQUESTION + MB_YESNO) = idYes then begin
     InputQuery('FacturLinEx 2','Introducir multiplicador (-1 para abono)',multiplicador);
     nMultiplicador:=StrToFloat(multiplicador);
     fVentas:=TfVentas.Create(Application);    // Creamos el formulario para acceder a su contenido
     fVentas.WindowState:=wsMinimized;
     fVentas.Show;
     fVentas.BitBtn24.Click;    // Ejecutamos aparcar ticket para asignar Numero de Ticket
     fVentas.dbVentas.Open;
     dbHistodd.First;
     while not dbHistodd.EOF do begin
       if dbHistodd.FieldByName('HOD17').AsString='' then begin;
          fVentas.Edit1.Text:=dbOperaciones.FieldByName('HO8').AsString; // Asignamos el valor de CODIGO CLIENTE
          fVentas.Edit3.Text:=dbHistodd.FieldByName('HOD6').AsString;  // Asignamos el valor de CODIGO ARTICULO
          fVentas.Edit4.Text:=dbHistodd.FieldByName('HOD7').AsString;  // Asignamos el valor de DESCRIPCION
          fVentas.Edit5.Text:=FloatToStr(dbHistodd.FieldByName('HOD8').asFloat*nMultiplicador);  // Asignamos el valor de CANTIDAD
          fVentas.Edit6.Text:=dbHistodd.FieldByName('HOD9').AsString;   // Asignamos el valor de PVP
          fVentas.Edit7.Text:=dbHistodd.FieldByName('HOD10').AsString;  // Asignamos el valor de PRECIO SIN IVA
          fVentas.Edit8.Text:=dbHistodd.FieldByName('HOD11').AsString;  // Asignamos el valor de DESCUENTO LINEAL
          fVentas.Edit9.Text:=FloatToStr(dbHistodd.FieldByName('HOD12').asFloat*nMultiplicador);  // CALCULARLO - Asignamos el valor de IMPORTE SIN IVA
          fVentas.Edit10.Text:=IntToStr(dbHistodd.FieldByName('HOD13').AsInteger);  // Asignamos el valor de TIPO DE IVA
          fVentas.Edit11.Text:=FloatToStr(dbHistodd.FieldByName('HOD14').asFloat*nMultiplicador); // CALCULARLO - Asignamos el valor de IMPORTE CON IVA
          fVentas.WindowState:=wsMinimized;
          fVentas.Show;
          fVentas.BitBtn14.Click;  // Simulamos el CLIC para la inserción de linea de venta

          // Rectificativas paso 4:
          // Si se recupera desde histórico con multiplicador negativo, guardamos el origen
          // real de la línea en ventasrectif+Tienda+Puesto. No afecta a recuperaciones normales.
          if nMultiplicador < 0 then
            fVentas.VF_RegistrarLineaRectifTemporal(
              dbOperaciones.FieldByName('HO5').AsString,
              dbOperaciones.FieldByName('HO0').AsDateTime,
              dbOperaciones.FieldByName('HO1').AsDateTime,
              dbOperaciones.FieldByName('HO2').AsString,
              dbOperaciones.FieldByName('HO4').AsString,
              dbOperaciones.FieldByName('HO3').AsInteger,
              dbHistodd.FieldByName('HOD5').AsInteger,
              dbHistodd.FieldByName('HOD8').AsFloat,
              dbHistodd.FieldByName('HOD8').AsFloat*nMultiplicador,
              dbHistodd.FieldByName('HOD14').AsFloat,
              dbHistodd.FieldByName('HOD14').AsFloat*nMultiplicador);
       end;
       dbHistodd.Next;
     end;
     fVentas.dbVentas.Close;
     fVentas.Free;
     ShowMessage('PROCESO FINALIZADO')
  end;
end;

// Selección del puesto a leer en los históricos.

procedure TFLHistoop.btPuestoClick(Sender: TObject);
begin
   edCodigoPuesto.Text:=FBusquedas.IniciaBusquedas('SELECT PT0,PT1 FROM puestos'+Tienda,['Puesto','Descripción'],'PT0');
   edDescripcionPuesto.SetFocus;
   edCodigoPuestoExit(self);
end;

procedure TFLHistoop.cbTodosPuestosChange(Sender: TObject);
begin
  if cbTodosPuestos.Checked then
    begin
     edCodigoPuesto.Enabled:=False;
     edDescripcionPuesto.Enabled:=False;
     btPuesto.Enabled:=False;
     nPuestoDetalles:=''; nPuestoCabeceras:='';
    end else
    begin
     edCodigoPuesto.Enabled:=True;
     edDescripcionPuesto.Enabled:=True;
     btPuesto.Enabled:=True;
    end
end;


procedure TFLHistoop.edDescripcionPuestoExit(Sender: TObject);
begin
  if edDescripcionPuesto.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); edDescripcionPuesto.SetFocus; Exit; end;
  dbPuesto.SQL.Text:='SELECT PT0,PT1 FROM puestos'+Tienda+' WHERE PT1="'+edDescripcionPuesto.Text+'"'; dbPuesto.Active:=True;
  if dbPuesto.RecordCount=0 then
                             begin
                               edCodigoPuesto.Text:=FBusquedas.IniciaBusquedas('SELECT PT0,PT1 FROM puestos'+Tienda+' WHERE PT1 LIKE "'+edDescripcionPuesto.Text+'%"',
                                                         ['Puesto', 'Descripción'],'PT0');
                               edCodigoPuestoExit(self);
                               Exit;
                              end;
  edCodigoPuesto.Text:=dbPuesto.FieldByName('PT0').AsString;
  edCodigoPuestoExit(self);
end;

procedure TFLHistoop.edDescripcionPuestoKeyPress(Sender: TObject; var Key: char
  );
begin
  if (Key=#13) then edDescripcionPuestoExit(self);
  Exit;
end;

procedure TFLHistoop.edCodigoPuestoEnter(Sender: TObject);
begin
  edCodigoPuesto.Text:='';
end;

procedure TFLHistoop.edCodigoPuestoExit(Sender: TObject);
begin
   if edCodigoPuesto.Text='' then Exit;
   dbPuesto.SQL.Text:='SELECT PT0,PT1 FROM puestos'+Tienda+' WHERE PT0="'+edCodigoPuesto.Text+'"';
   dbPuesto.Active:=True;
   If dbPuesto.RecordCount=0 then
                               Begin
                                 btPuestoClick(self);
                                 edDescripcionPuesto.SetFocus; Exit;
                               End;
   edDescripcionPuesto.Text:=dbPuesto.FieldByName('PT1').AsString;
   nPuestoDetalles:= ' AND HOD2="' + edCodigoPuesto.Text + '"';
   nPuestoCabeceras:=' AND HO2="' + edCodigoPuesto.Text + '"';
end;


procedure TFLHistoop.DateEditDesdeExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditDesde.text) Then
     begin
       DateEditDesde.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

procedure TFLHistoop.DateEditHastaExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditHasta.text) Then
     begin
       DateEditHasta.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

procedure TFLHistoop.DBGrid1CellClick(Column: TColumn);
begin
  RecuperaOperacion();
end;


//======================== DOBLE CLICK EN GRID DE OPERACIONES ==================
procedure TFLHistoop.DBGrid1DblClick(Sender: TObject);
begin
  RecuperaOperacion();
  //Dejo estas opciones comentadas por si hubiera que sacar distintos paneles, según la operación
  //if dbOperaciones.FieldByName('CRE3').AsString='EN' then RecuperaEntrega();
  //if (dbOperaciones.FieldByName('CRE3').AsString='NS') or
     //(dbOperaciones.FieldByName('CRE3').AsString='NT') then RecuperaTicket();
end;

Procedure TFLHistoop.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//==================== NAVEGACION CON ESC ======================
procedure TFLHistoop.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then
    Exit;

  // Si hay una lista desplegable abierta, dejamos que el propio control
  // procese ESC y cierre solo la lista, sin cambiar de pantalla.
  if (ActiveControl is TComboBox) and
     TComboBox(ActiveControl).DroppedDown then
    Exit;

  Key := 0;

  // Cierra primero la leyenda auxiliar, manteniendo el estado del listado.
  if PanelLeyenda.Visible then
  begin
    BitBtn27Click(Self);
    Exit;
  end;

  // Cierra primero el detalle de la operación y conserva el listado.
  if PanelDetalleOperacion.Visible then
  begin
    PanelDetalleOperacion.Visible := False;
    AjustarDisenoModerno;
    Exit;
  end;

  // Desde cualquier listado vuelve a la pantalla de selección.
  if not PanelRadioButton.Visible then
  begin
    BitBtn3Click(Self);
    Exit;
  end;

  // En la pantalla principal ejecuta exactamente la acción del botón Cerrar.
  BitBtn4Click(Self);
end;

//==================== VISUALIZAR ===================
procedure TFLHistoop.BitBtn1Click(Sender: TObject);
Var
  TxtQuery: String;
  FiltroVisual: String;
begin
  FiltroVisual:='';
  if ComboBox1.ItemIndex=0 then FiltroVisual:=' AND HO16="N" ';
  if ComboBox1.ItemIndex=1 then FiltroVisual:=' AND HO16="A" ';

  if FiltroVisual<>'' then
   begin
     DbGrid1.DataSource:=Nil;
     TxtQuery:='SELECT *,HO12+HO14 As ENTRETOTAL from hisopcc'+Tienda+' WHERE '+copy(FiltroVisual,5,10)+nPuestoCabeceras;
     TxtQuery:=TxtQuery + ' ORDER BY HO0,HO1,HO2,HO4,HO3 DESC';
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then
       begin
         Showmessage('No existen documentos en el histórico a visualizar');
         FiltroVisual:='';
         ComboBox1.ItemIndex:=2;
       end;
     dbOperaciones.Active:=False;
     dbGrid1.DataSource:= DataSource1;
   end;
  AntColun:='0';Ordenado:=False;
  BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True;
  PanelCambiable.Visible:=False;
  //-------------------------- Todas las operaciones
  if RadioButton1.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES';
     //-- MID(HO18,1,250)
     TxtQuery:='SELECT *, CONVERT(HO18 USING UTF8) as NOTAS,HO12+HO14 As ENTRETOTAL from hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery +' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          FiltroVisual+ nPuestoCabeceras;
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO0,HO1,HO2,HO4,HO3 DESC';

     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
     DBGrid1DblClick(Self);
     PanelRadioButton.Visible:=False;// PanelLeyenda.Visible:=True;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end;
  //-------------------------- Operaciones normales sin ticket
  if RadioButton2.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES SIN TICKET';
     //-- MID(HO18,1,250)
     TxtQuery:='SELECT *, CONVERT(HO18 USING UTF8) as NOTAS, HO12+HO14 As ENTRETOTAL from hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          ' AND HO5="NS"'+FiltroVisual+ nPuestoCabeceras;
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO0,HO1,HO2,HO4,HO3 DESC';
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid1DblClick(Self);
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
     PanelRadioButton.Visible:=False; //PanelLeyenda.Visible:=True;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end;
  //-------------------------- Operaciones normales con ticket
  if RadioButton3.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES CON TICKET';
     //-- MID(HO18,1,250)
     TxtQuery:='SELECT *, CONVERT(HO18 USING UTF8) as NOTAS, HO12+HO14 As ENTRETOTAL from hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          ' AND HO5="NT"'+FiltroVisual + nPuestoCabeceras;
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO0,HO1,HO2,HO4,HO3 DESC';
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid1DblClick(Self);
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
     PanelRadioButton.Visible:=False; //PanelLeyenda.Visible:=True;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end;
  //-------------------------- Operaciones con Albaranes
  if RadioButton4.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES CON ALBARANES';
     //-- MID(HO18,1,250)
     TxtQuery:='SELECT *, CONVERT(HO18 USING UTF8) as NOTAS, HO12+HO14 As ENTRETOTAL from hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          ' AND HO5="AL"'+FiltroVisual + nPuestoCabeceras;
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO0,HO1,HO2,HO4,HO3 DESC';
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid1DblClick(Self);
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
     PanelRadioButton.Visible:=False; //PanelLeyenda.Visible:=True;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end;
  //-------------------------- Operaciones normales con factura
  if RadioButton5.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES CON FACTURA';
     //-- MID(HO18,1,250)
     TxtQuery:='SELECT *, CONVERT(HO18 USING UTF8) as NOTAS, HO12+HO14 As ENTRETOTAL from hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          ' AND HO5="FA"'+FiltroVisual + nPuestoCabeceras;
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO0,HO1,HO2,HO4,HO3 DESC';
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid1DblClick(Self);
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
     PanelRadioButton.Visible:=False;// PanelLeyenda.Visible:=True;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end;
  //-------------------------- Operaciones de un Articulo
  if RadioButton6.Checked=True then
    begin
     Edit1.Visible:=True;
     Label11.Visible:=True;
     Label12.Visible:=True;
     TituloGrid:='LISTADO DE OPERACIONES DE UN ARTÍCULO';
     //-- MID(HOD7,1,100)
     TxtQuery:='SELECT *, CONVERT(HOD7 USING UTF8) as DESCRIP from hisopdd'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' HOD0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HOD0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          ' AND HOD7 LIKE "'+UpperCase(Edit1.Text)+'"'+ nPuestoDetalles;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HOD0,HOD1,HOD2,HOD4,HOD3 DESC';
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
//-- Prueba doble busqueda     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     if dbOperaciones.RecordCount=0 then
       begin
        //-- MID(HOD7,1,30)
        TxtQuery:='SELECT *, CONVERT(HOD7 USING UTF8) as DESCRIP from hisopdd'+Tienda+' WHERE';
        TxtQuery:=TxtQuery + ' HOD0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                             ' AND HOD0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                             ' AND HOD6 LIKE "'+UpperCase(Edit1.Text)+'"'+ nPuestoDetalles;
        if Ordenado=True then
          TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
        else
          TxtQuery:=TxtQuery + ' ORDER BY HOD0,HOD1,HOD2,HOD4,HOD3 DESC';
        dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
        if dbOperaciones.RecordCount=0 then
          begin
               ShowMessage('CON ESA SELECCION NO HAY DATOS');
               exit;
          end;
       end;

     DBGrid2.BringToFront; DBGrid2.Visible:=True;
     PanelRadioButton.Visible:=False;
     BitBtn2.Enabled:=False; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
     RadioButton1.Checked:=True;
    end;
  //-------------------------- Operaciones por Horas
  if RadioButton7.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES AGRUPADAS POR HORAS';
     TxtQuery:='SELECT HOUR(HO1), COUNT(*) AS NumeroDeVentas, SUM(HO9) AS ImporteTotal from hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          ' AND HOUR(HO1)>="'+ComboBoxHoraDesde.Text+'"'+
                          ' AND HOUR(HO1)<="'+ComboBoxHoraHasta.Text+'"'+ nPuestoCabeceras;
     TxtQuery:=TxtQuery + ' GROUP BY HOUR(HO1)';
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HOUR(HO1)';

     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     if FormatDateTime('DD-MM-YYYY',DateEditDesde.Date) <> '' then
       TituloGrid:= TituloGrid + ' DESDE EL DIA '+ FormatDateTime('DD-MM-YYYY',DateEditDesde.Date);
     if FormatDateTime('DD-MM-YYYY',DateEditHasta.Date) <> '' then
       TituloGrid:= TituloGrid + ' HASTA EL DIA '+ FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);

     DBGrid4.BringToFront; DBGrid4.Visible:=True;
     PanelRadioButton.Visible:=False; //PanelLeyenda.Visible:=False;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end;
   //-------------------------- Operaciones por Usuarios
  if RadioButton8.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES AGRUPADAS POR USUARIOS';
     TxtQuery:='SELECT HO7, COUNT(*) AS NumeroDeVentas, SUM(HO9) AS ImporteTotal, USU1 from hisopcc'+Tienda+', usuarios'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          ' AND HOUR(HO1)>="'+ComboBoxHoraDesde.Text+'"'+
                          ' AND HOUR(HO1)<="'+ComboBoxHoraHasta.Text+'"'+
                          ' AND HO7=USU0' + nPuestoCabeceras;
     TxtQuery:=TxtQuery + ' GROUP BY HO7';
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO7';
     //WriteLn(TxtQuery);
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     if FormatDateTime('DD-MM-YYYY',DateEditDesde.Date) <> '' then
       TituloGrid:= TituloGrid + ' DESDE EL DIA '+ FormatDateTime('DD-MM-YYYY',DateEditDesde.Date);
     if FormatDateTime('DD-MM-YYYY',DateEditHasta.Date) <> '' then
       TituloGrid:= TituloGrid + ' HASTA EL DIA '+ FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);

     DBGrid5.BringToFront; DBGrid5.Visible:=True;
     PanelRadioButton.Visible:=False; //PanelLeyenda.Visible:=False;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end;
    //-------------------------- Todas las operaciones de crédito
  if RadioButton9.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES DE CRÉDITO';
//     TxtQuery:='SELECT HO0,HO1,HO2,HO3,HO4,HO5,HO8,HO11,HO12,HO13,HO14 from hisopcc'+Tienda+', creditos'+Tienda+' WHERE'; //--- Generaba un error, no encontraba HO7
     TxtQuery:='SELECT *, HO12+HO14 As ENTRETOTAL from hisopcc'+Tienda+', creditos'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' CRE0=HO8 AND CRE1=HO0 AND CRE2=HO1 AND CRE3=HO5 AND CRE4=HO4 AND CRE5=HO3 AND';
     TxtQuery:=TxtQuery + ' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+ nPuestoCabeceras;
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO0,HO1,HO2,HO4,HO3 DESC';
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
     PanelRadioButton.Visible:=False; PanelLeyenda.Visible:=True;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end
  else
    begin
     Edit1.Visible:=False;
     Label11.Visible:=False;
     Label12.Visible:=False;
    end;
  LabelTituloDBGrid.Caption:=TituloGrid;
  ActualizarVistaSeleccion(False);
  AjustarDisenoModerno;
  //WriteLn(TxtQuery);
end;


//============ IMPRIMIMOS COPIAS DE DOCUMENTOS/TICKETS ======================
procedure TFLHistoop.BitBtn26Click(Sender: TObject);
var
  TxtQuery: String;
  Documento: String;
begin
  dbUsu.Active:=False;
  dbUsu.SQL.Text:='SELECT * FROM clientes WHERE C0='+
                   dbOperaciones.FieldByName('HO8').AsString;
  dbUsu.Active:=True;

  if (dbOperaciones.FieldByName('HO5').Value='AL') or
     (dbOperaciones.FieldByName('HO5').Value='FA') or
     (dbOperaciones.FieldByName('HO5').Value='PR') or
     (dbOperaciones.FieldByName('HO5').Value='PO')
  then                            // Impresión de albaranes, facturas, presupuestos y proformas.
  begin
                // Si está anulada no se imprime
    if dbOperaciones.FieldByName('HO16').Value='A' then
      begin
        ShowMessage('Este documento fue eliminado de la BBDD,'+#13+'no es posible su reimpresión');
        Exit;
      end;
                 // Cargamos datos en tabla para impresión.
    if dbOperaciones.FieldByName('HO5').Value='FA' then
      begin
        dbMuestrac.Active:=False;
        dbMuestrac.SQL.Text:= 'SELECT * FROM factuc'+Tienda+' WHERE FC0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND FC1="'+FormatDateTime('YYYY/MM/DD',dbOperaciones.FieldByName('HO0').AsDateTime)+'" AND FC2="'+dbOperaciones.FieldByName('HO4').AsString+
        '" AND FC3='+dbOperaciones.FieldByName('HO3').AsString;
        dbMuestrac.Active:=True;

        dbMuestrad.Active:=False;
        dbMuestrad.SQL.Text:= 'SELECT * FROM factud'+Tienda+' WHERE FD0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND FD1="'+FormatDateTime('YYYY/MM/DD',dbHistodd.FieldByName('HOD0').AsDateTime)+'" AND FD2="'+dbHistodd.FieldByName('HOD4').AsString+
        '" AND FD3='+dbHistodd.FieldByName('HOD3').AsString;
        dbMuestrad.Active:=True;

        Documento:='FACTURA';
      end;

     if dbOperaciones.FieldByName('HO5').Value='AL' then
      begin
        dbMuestrac.Active:=False;
        dbMuestrac.SQL.Text:= 'SELECT * FROM albac'+Tienda+' WHERE AC0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND AC1="'+FormatDateTime('YYYY/MM/DD',dbOperaciones.FieldByName('HO0').AsDateTime)+'" AND AC2="'+dbOperaciones.FieldByName('HO4').AsString+
        '" AND AC3='+dbOperaciones.FieldByName('HO3').AsString;
        dbMuestrac.Active:=True;

        dbMuestrad.Active:=False;
        dbMuestrad.SQL.Text:= 'SELECT * FROM albad'+Tienda+' WHERE AD0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND AD1="'+FormatDateTime('YYYY/MM/DD',dbHistodd.FieldByName('HOD0').AsDateTime)+'" AND AD2="'+dbHistodd.FieldByName('HOD4').AsString+
        '" AND AD3='+dbHistodd.FieldByName('HOD3').AsString;
        dbMuestrad.Active:=True;

        Documento:='ALBARAN';
      end;

     if dbOperaciones.FieldByName('HO5').Value='PR' then
      begin
        dbMuestrac.Active:=False;
        dbMuestrac.SQL.Text:= 'SELECT * FROM presuc'+Tienda+' WHERE PRC0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbOperaciones.FieldByName('HO0').AsDateTime)+'" AND PRC2="'+dbOperaciones.FieldByName('HO4').AsString+
        '" AND PRC3='+dbOperaciones.FieldByName('HO3').AsString;
        dbMuestrac.Active:=True;

        dbMuestrad.Active:=False;
        dbMuestrad.SQL.Text:= 'SELECT * FROM presud'+Tienda+' WHERE PRD0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbHistodd.FieldByName('HOD0').AsDateTime)+'" AND PRD2="'+dbHistodd.FieldByName('HOD4').AsString+
        '" AND PRD3='+dbHistodd.FieldByName('HOD3').AsString;
        dbMuestrad.Active:=True;

        Documento:='PRESUPUESTO';
      end;

     if dbOperaciones.FieldByName('HO5').Value='PO' then
      begin
        dbMuestrac.Active:=False;
        dbMuestrac.SQL.Text:= 'SELECT * FROM proforc'+Tienda+' WHERE PRC0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbOperaciones.FieldByName('HO0').AsDateTime)+'" AND PRC2="'+dbOperaciones.FieldByName('HO4').AsString+
        '" AND PRC3='+dbOperaciones.FieldByName('HO3').AsString;
        dbMuestrac.Active:=True;

        dbMuestrad.Active:=False;
        dbMuestrad.SQL.Text:= 'SELECT * FROM proford'+Tienda+' WHERE PRD0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbHistodd.FieldByName('HOD0').AsDateTime)+'" AND PRD2="'+dbHistodd.FieldByName('HOD4').AsString+
        '" AND PRD3='+dbHistodd.FieldByName('HOD3').AsString;
        dbMuestrad.Active:=True;

        Documento:='PROFORMA';
      end;

    FImpresion.Imprime(dbMuestrad, dbMuestrac, dbUsu, Documento, false, 1);
  end;
          // Imprime operaciones con tickets.

  if (dbOperaciones.FieldByName('HO5').Value='NS') or
     (dbOperaciones.FieldByName('HO5').Value='NT') then
    begin
      ImpreTicket(false);
      if CheckBox2.Checked then ImpreTicket(true);
    end;
end;

//=====================================================================
//==================== IMPRIMIR TICKETS ===============================
//=====================================================================
procedure TFLHistoop.ImpreTicket(regalo: boolean);
var
  Texto: String;
  Precio, SubTotal: Double;
  b1,b2,b3,tiva1,tiva2,tiva3,iiva1,iiva2,iiva3: Double;
  LeyendaCabeceraQR, LeyendaPieQR: string;
begin
  b1:=0;
  b2:=0;
  b3:=0;
  tiva1:=0;
  tiva2:=0;
  tiva3:=0;
  iiva1:=0;
  iiva2:=0;
  iiva3:=0;

  if HOP_EsModoProduccion then
    begin
      LeyendaCabeceraQR := ' QR Tributario : ';
      LeyendaPieQR := ' VERI*FACTU ';
    end
  else
    begin
      LeyendaCabeceraQR := LeyendaSuperiorQR;
      LeyendaPieQR := LeyendaInferiorQR;
    end;

  OpenDialog1.FileName:=DevTicket;
  AssignFile(PrintText, OpenDialog1.FileName);
  Rewrite(PrintText);

  Write(PrintText, #27#97#1); // Centrar
  Writeln(PrintText, LeyendaCabeceraQR);
  Write(PrintText, #27#97#0); // Volver a izquierda
  CloseFile(PrintText);

  ImprimeQRTicket();

  AssignFile(PrintText, OpenDialog1.FileName);
  Rewrite(PrintText);
  Write(PrintText, #27#97#1); // Centrar
  Writeln(PrintText, LeyendaPieQR);
  Write(PrintText, #27#97#0); // Volver a izquierda

// -- Añadidio por Ticket Regalo
  if Checkbox2.Checked then
    begin
      Writeln(PrintText, ''); WriteLn(PrintText, ''); WriteLn(PrintText, '');
    end;
// -- FIN Añadidio por Ticket Regalo

  CabeceraTicket();
  dbHistodd.First;
  while not dbHistodd.Eof do
    begin
      if (tiva1=0) then tiva1:=dbHistodd.FieldByName('HOD13').AsInteger;
      if ((tiva2=0) and (tiva1<>dbHistodd.FieldByName('HOD13').AsInteger)) then tiva2:=dbHistodd.FieldByName('HOD13').AsInteger;
      if ((tiva3=0) and (tiva1<>dbHistodd.FieldByName('HOD13').AsInteger) and (tiva2<>dbHistodd.FieldByName('HOD13').AsInteger)) then tiva3:=dbHistodd.FieldByName('HOD13').AsInteger;

      if tiva1=dbHistodd.FieldByName('HOD13').AsInteger then
         begin
          b1:=b1+((dbHistodd.FieldByName('HOD14').AsFloat)/(1+(dbHistodd.FieldByName('HOD13').AsInteger/100)));
          {
          showmessage(FloatToStr(b1));
          showmessage(FloatToStr(dbVentas.Fields[11].AsFloat));
          showmessage(FloatToStr(1+(dbVentas.FieldByName('V10').AsInteger/100)));
          }
          iiva1:=iiva1+((dbHistodd.FieldByName('HOD14').AsFloat)-(dbHistodd.FieldByName('HOD14').AsFloat/(1+(dbHistodd.FieldByName('HOD13').AsInteger/100))))
        end;
      if tiva2=dbHistodd.FieldByName('HOD13').AsInteger then
        begin
          b2:=b2+((dbHistodd.FieldByName('HOD14').AsFloat)/(1+(dbHistodd.FieldByName('HOD13').AsInteger/100)));
          iiva2:=iiva2+((dbHistodd.FieldByName('HOD14').AsFloat)-(dbHistodd.FieldByName('HOD14').AsFloat/(1+(dbHistodd.FieldByName('HOD13').AsInteger/100))))
        end;
      if tiva3=dbHistodd.FieldByName('HOD13').AsInteger then
        begin
          b3:=b3+((dbHistodd.FieldByName('HOD14').AsFloat)/(1+(dbHistodd.FieldByName('HOD13').AsInteger/100)));
          iiva3:=iiva3+((dbHistodd.FieldByName('HOD14').AsFloat)-(dbHistodd.FieldByName('HOD14').AsFloat/(1+(dbHistodd.FieldByName('HOD13').AsInteger/100))))
        end;

      if DesgloIva='S' then
           begin
            Precio:=dbHistodd.Fieldbyname('HOD10').AsFloat;
            SubTotal:=dbHistodd.Fieldbyname('HOD12').AsFloat;
           end else
           begin
            Precio:=dbHistodd.Fieldbyname('HOD9').AsFloat;
            SubTotal:=dbHistodd.Fieldbyname('HOD14').AsFloat;
           end;
      //--- Línea con código de artículo
      if CgoEnTicket='S' then Texto:=Copy(dbHistodd.Fieldbyname('HOD6').AsString+'                    ',1,18)+' '
                         else Texto:=Copy(dbHistodd.Fieldbyname('HOD7').AsString+'                    ',1,18)+' ';

      Texto:=Texto + DataModule1.LFill(FormatFloat('##0.00',dbHistodd.FieldByName('HOD8').AsFloat),6,' ') + ' ';

// --  Añadido por Ticket REGALO
      if regalo=False then
        begin

               Texto:=Texto + DataModule1.LFill(FormatFloat('##0.00',Precio),6,' ') + ' ';
               Texto:=Texto + DataModule1.LFill(FormatFloat('###0.00',SubTotal),7,' ');

        end;

// -- FIN Añadidio por Ticket Regalo (OJO, solo el IF, el contenido del if existía antes).


      //--- Cgo Articulo en ticket (Ojo! se imprimen dos lineas por articulo)
      if CgoEnTicket='S' then
        begin
          Writeln(PrintText, Texto);
          Writeln(PrintText, Copy(dbHistodd.Fieldbyname('HOD7').AsString+'                                        ',1,40));

        end else
          Writeln(PrintText, Texto);

      dbHistodd.Next;
     end;

// -- Añadidio por Ticket Regalo

     If regalo=false then TotalTicket(b1,b2,b3,tiva1,tiva2,tiva3,iiva1,iiva2,iiva3) else
       begin
         WriteLn(PrintText, '');
         WriteLn(PrintText, '*** TICKET REGALO ***');
         WriteLn(PrintText, '');
       end;

  PieTicket();
  Corte();
  CloseFile(PrintText);
end;


//=============== QR DEL TICKET REIMPRESO ===============================
Procedure TFLHistoop.ImprimeQRTicket();
var
  Ticketera: TLCLHandle;
  S: RawByteString;
  LeyendaTextoQR: string;
  NumOperacion: string;
begin
  NumOperacion := FormatFloat('0', dbOperaciones.FieldByName('HO3').AsFloat);

  if HOP_EsModoProduccion then
    LeyendaTextoQR := HOP_BuildQRTributario(
      dbOperaciones.FieldByName('HO4').AsString,
      NumOperacion,
      dbOperaciones.FieldByName('HO0').AsDateTime,
      dbOperaciones.FieldByName('HO11').AsFloat)
  else
    LeyendaTextoQR := TextoCodigoQR;

  try
    S := HOP_ESC + '@'; // Resetear impresora

    // Modelo QR
    S += HOP_GS + '(k' + #4#0 + #49#65#50#0;

    // Contenido QR
    S += HOP_GS + '(k';
    S += Char(Length(LeyendaTextoQR) + 3);
    S += #0;
    S += #49#80#48;
    S += LeyendaTextoQR;

    // Centrar QR
    S += HOP_ESC + 'a' + #1;

    // Tamaño QR aprox. 30x30 mm
    S += HOP_GS + '(k' + #3#0 + #49#67#6;

    // Imprimir QR
    S += HOP_GS + '(k' + #3#0 + #49#81#48;

    Ticketera := FileCreate(DevTicket);
    if Ticketera = feInvalidHandle then
      raise Exception.Create('No se puede abrir la impresora de ticket para QR en: ' + DevTicket);

    try
      FileWrite(Ticketera, Pointer(S)^, Length(S));
    finally
      FileClose(Ticketera);
    end;

  except
    // No bloqueamos la reimpresión por fallo del QR.
  end;
end;


//============== CABECERA DEL TICKETC ===================================
procedure TFLHistoop.CabeceraTicket();
begin
  if Trim(LCTI1)<>'' then Writeln(PrintText, LCTI1);
  if Trim(LCTI2)<>'' then Writeln(PrintText, LCTI2);
  if Trim(LCTI3)<>'' then Writeln(PrintText, LCTI3);
  if Trim(LCTI4)<>'' then Writeln(PrintText, LCTI4);
  Writeln(PrintText, ' ');

  Writeln(PrintText, 'N.FRA.SIMPL.: (H) :'+DataModule1.LFill(FormatFloat('#######',dbOperaciones.FieldByName('HO3').AsFloat),7,' '));
  {
  Writeln(PrintText, ' ');
  Writeln(PrintText, 'CLIENTE : '+dbOperaciones.FieldByName('HO8').Text);
  Writeln(PrintText, 'Forma de PAGO : '+dbOperaciones.FieldByName('HO6').Text);
  }
  Writeln(PrintText, ' ');
  Writeln(PrintText, 'Fecha.: '+FormatDateTime('dd/mm/yyyy',dbOperaciones.FieldByName('HO0').AsDateTime)+'   Hora.:'+FormatDateTime('hh:mm:ss',dbOperaciones.FieldByName('HO1').AsDateTime));
  Writeln(PrintText, ' ');
  Writeln(PrintText, 'ARTICULO              UND PRECIO   TOTAL');
  Writeln(PrintText, '========================================');
end;

//====================== PIE DEL TICKETC =============================
procedure TFLHistoop.TotalTicket(n1,n2,n3,ti1,ti2,ti3,i1,i2,i3: Double);
Var
  Texto1,Texto2,Texto3: String;
  Conta: Integer;
begin

Writeln(PrintText, ' ');
// --- Writeln(PrintText, '                               ---------'); //-- ANULADO POR JOSE PORQUE NO QUEDA BIEN LA LÍNEA

//---------------------- Desglose de Iva en ticket
if SacaIva='N' then
  begin
    Writeln(PrintText, ' ');
    Writeln(PrintText, '   Base      Tipo       Iva             ');
    Writeln(PrintText, '----------------------------------------');
//--------- IMPLEMENTADO POR JOSE PARA CONTROLAR EL MULTI-IVA
    IF ti1<>0 then
      begin
         Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',n1),10,' '));
         Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',ti1),10,' '));
         Writeln(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',i1),10,' '));
      end;
    IF ti2<>0 then
      begin
         Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',n2),10,' '));
         Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',ti2),10,' '));
         Writeln(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',i2),10,' '));
      end;
    IF ti3<>0 then
      begin
         Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',n3),10,' '));
         Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',ti3),10,' '));
         Writeln(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',i3),10,' '));
      end;

    Writeln(PrintText, '----------------------------------------');
    Writeln(PrintText, ' ');
 end
    ELSE
        Writeln(PrintText, '                               ---------');

//-------- FIN IMPLEMENTACIÓN JOSE PARA CONTROLAR EL MULTI-IVA

//---------------- Descuento
if (dbOperaciones.FieldByName('HO10').AsFloat<>0)  then
  begin
   Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(dbOperaciones.FieldByName('HO9').AsString)),10,' ');
   Texto3:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(dbOperaciones.FieldByName('HO11').AsString)),10,' ');
   Texto2:=DataModule1.LFill( FormatFloat('##0.00',StrToFloat(dbOperaciones.FieldByName('HO10').AsString)),6,' ');
   Writeln(PrintText, 'TOTAL:'+Texto1+'-'+Texto2+'% Dto ='+Texto3);
  end
else
  begin
   Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(dbOperaciones.FieldByName('HO11').AsString)),10,' ');
   Writeln(PrintText, '                    TOTAL     '+Texto1);
  end;
Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(dbOperaciones.FieldByName('HO12').AsString)),10,' ');
Writeln(PrintText, '                    ENTREGA   '+Texto1);
Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(dbOperaciones.FieldByName('HO13').AsString)),10,' ');
if StrToFloat(dbOperaciones.FieldByName('HO13').AsString)>=0 then
  Writeln(PrintText, '                    CAMBIO    '+Texto1)
else
  Writeln(PrintText, '                    CREDITO   '+Texto1);
Writeln(PrintText, ' ');
//----------------- Sacar iva uncluido en el ticket o no --------------
if SacaIva<>'N' then
  begin
   Writeln(PrintText, '            * IVA INCLUIDO *            ');
   Writeln(PrintText, ' ');
  end;
end;

procedure TFLHistoop.PieTicket();
Var
  Texto1,Texto2,Texto3: String;
  Conta: Integer;
begin

   Writeln(PrintText, 'Cliente: '+dbUsu.FieldByName('C0').AsString);
   Writeln(PrintText, dbUsu.FieldByName('C1').AsString);
   Writeln(PrintText, ' ');

  //----------------- Sacar vendedor en el ticket o no --------------
   if SacaVende<>'N' then Writeln(PrintText, 'LE ATENDIO.: '+ copy(StaticTextVend.Caption, 1, 35));

  //----------------------------------------------------------------
  if Trim(LPTI1)<>'' then Writeln(PrintText, LPTI1);
  if Trim(LPTI2)<>'' then Writeln(PrintText, LPTI2);
  if Trim(LPTI3)<>'' then Writeln(PrintText, LPTI3);
  for Conta:=1 to StrToInt(LiFinTick) do Writeln(PrintText, ' ');
end;

//================== CORTE DE PAPEL ===================
procedure TFLHistoop.Corte();
begin
  if trim(CgoCorte)='' then exit;
  WriteLn(PrintText, PCgoCorte);
end;

//====================== VER TIPOS DE DOCUMENTO =====
procedure TFLHistoop.BitBtn27Click(Sender: TObject);
begin
 if PanelLeyenda.Visible=True then
    begin
       PanelLeyenda.Visible:=False;
       BitBtn27.Caption:='Mostar Tipos';
    end else
    begin
       PanelLeyenda.BringToFront;
       PanelLeyenda.Visible:=True;
       BitBtn27.Caption:='Ocultar Tipos';
    end;
end;

//==================== SELECCIONAR ===================
procedure TFLHistoop.BitBtn3Click(Sender: TObject);
begin
  Ordenado:=False; BitBtn2.Enabled:=False; BitBtn3.Enabled:=False; BitBtn5.Enabled:=False;
  PanelRadioButton.Visible:=True; //PanelLeyenda.Visible:=False;
  PanelDetalleOperacion.Visible:=False;PanelCambiable.Visible:=True;
  LabelTituloDBGrid.Caption:='';
  DBGrid1.SendToBack;
  OcultarBDGrid();
  ActualizarVistaSeleccion(True);
end;

//==================== IMPRIMIR ===================
procedure TFLHistoop.BitBtn2Click(Sender: TObject);
begin
  if (RadioButton1.Checked=True) OR (RadioButton2.Checked=True)
    OR (RadioButton3.Checked=True) OR (RadioButton4.Checked=True)
    OR (RadioButton5.Checked=True) OR
       (RadioButton9.Checked=True) then FImpresion.Imprime(dbOperaciones.SQL.Text, 'ListadoHistoricoOperaciones',TituloGrid);
  if RadioButton6.Checked=True then FImpresion.Imprime(dbOperaciones.SQL.Text, 'ListadoHistoricoOperacionesArticulo',TituloGrid);
  if RadioButton7.Checked=True then FImpresion.Imprime(dbOperaciones.SQL.Text, 'ListadoHistoricoOperacionesHoras',TituloGrid);
  if RadioButton8.Checked=True then FImpresion.Imprime(dbOperaciones.SQL.Text, 'ListadoHistoricoOperacionesUsuarios',TituloGrid);
end;

//================ RECUPERAR UNA OPERACIÓN DE HISOPDDXXXX
procedure TFLHistoop.RecuperaOperacion();
//var
//  TxtQ: String;
//  FiltraHoras: String;
begin
  //TxtQ:='SELECT * FROM hisopcc'+Tienda+' WHERE '+
        //' HO0="'+FormatDateTime('YYYY/MM/DD',dbCreditos.FieldByName('CRE1').AsDateTime)+'"'+
        //' AND HO1="'+FormatDateTime('HH:MM:SS',dbCreditos.FieldByName('CRE2').AsDateTime)+'"'+
        //' AND HO2="'+Puesto+'"'+
        //' AND HO3='+dbCreditos.FieldByName('CRE5').AsString+
        //' AND HO4="'+dbCreditos.FieldByName('CRE4').AsString+'"';
  //dbHistocc.Active:=False; dbHistocc.SQL.Text:=TxtQ; dbHistocc.Active:=True;
  //if dbHistocc.RecordCount=0 then exit;
  StaticTextFecha.Caption:=FormatDateTime('DD/MM/YYYY',dbOperaciones.FieldByName('HO0').AsDateTime);//---Fecha
  StaticTextHora.Caption:=FormatDateTime('HH:MM:SS',dbOperaciones.FieldByName('HO1').AsDateTime);//--Hora
  //--------------- N. Ticket
  StaticTextNumOper.Caption:=dbOperaciones.FieldByName('HO4').AsString+'/'+dbOperaciones.FieldByName('HO3').AsString;
  //--------------- Vendedor de la operacion
  dbUsu.Active:=False;
  dbUsu.SQL.Text:='SELECT USU0, USU1 FROM usuarios'+Tienda+' WHERE USU0='+
                   dbOperaciones.FieldByName('HO7').AsString;
  dbUsu.Active:=True;
  if dbUsu.RecordCount=0 then StaticTextVend.Caption:='' else StaticTextVend.Caption:=dbUsu.FieldByName('USU1').AsString;
  dbUsu.Active:=False;
  //--------------- Cliente de la operacion
  dbUsu.Active:=False;
  dbUsu.SQL.Text:='SELECT C0, C1 FROM clientes WHERE C0='+
                   dbOperaciones.FieldByName('HO8').AsString;
  dbUsu.Active:=True;
  if dbUsu.RecordCount=0 then StaticTextCliente.Caption:='' else StaticTextCliente.Caption:=dbUsu.FieldByName('C1').AsString;
  dbUsu.Active:=False;
  //--------------------
  StaticTextTotal.Caption:=FormatFloat('0.00',dbOperaciones.FieldByName('HO9').AsFloat);//---Total
  StaticTextEntrega.Caption:=FormatFloat('0.00',dbOperaciones.FieldByName('HO12').AsFloat);//--Entrega
  StaticTextEntregaContado.Caption:=FormatFloat('0.00',dbOperaciones.FieldByName('HO14').AsFloat);//--Entrega Tarjeta + Contado
  StaticTextCambio.Caption:=FormatFloat('0.00',dbOperaciones.FieldByName('HO13').AsFloat);//--Cambio
  StaticTextTipoPago.Caption:=dbOperaciones.FieldByName('HO6').AsString;//--- Tipo de pago
  CheckBox1Click(Self);

  PanelDetalleOperacion.Visible:=True;
  AjustarDisenoModerno;
end;


procedure TFLHistoop.CheckBox1Click(Sender: TObject);
var
   TxtQ: String;
   FiltraHoras: String;
begin
   FiltraHoras:='';

  if (CheckBox1.Checked=False) then FiltraHoras:='AND HOD1="'+FormatDateTime('HH:MM:SS',dbOperaciones.FieldByName('HO1').AsDateTime)+'"';

  //-- MID(HOD7,1,50)
  TxtQ:='SELECT *, CONVERT(HOD7 USING UTF8) As DESCRI FROM hisopdd'+Tienda+' WHERE '+
        ' HOD0="'+FormatDateTime('YYYY/MM/DD',dbOperaciones.FieldByName('HO0').AsDateTime)+'"'+
        FiltraHoras+ nPuestoDetalles +
        ' AND HOD3='+dbOperaciones.FieldByName('HO3').AsString+
        ' AND HOD4="'+dbOperaciones.FieldByName('HO4').AsString+'"';
  dbHistodd.Active:=False; dbHistodd.SQL.Text:=TxtQ; dbHistodd.Active:=True;
end;

procedure TFLHistoop.ComboBox1Change(Sender: TObject);
begin
  BitBtn1Click(Self);
end;


//=============== PONER LINEAS DE CREDITO EN ROJO============
procedure TFLHistoop.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  EsCredito: Boolean;
  EstadoPintado: TGridDrawState;
begin
  dbCreditos.SQL.Text:='SELECT * FROM creditos'+Tienda+' WHERE CRE0='+
                    dbOperaciones.FieldByName('HO8').AsString+' AND CRE1="'+
                    FormatDateTime('YYYY/MM/DD',dbOperaciones.FieldByName('HO0').AsDateTime)+'"'+
                    ' AND CRE2="'+FormatDateTime('HH:MM:SS',dbOperaciones.FieldByName('HO1').AsDateTime)+'"'+
                    ' AND CRE3="'+dbOperaciones.FieldByName('HO5').AsString+'"'+
                    ' AND CRE4="'+dbOperaciones.FieldByName('HO4').AsString+'"'+
                    ' AND CRE5='+dbOperaciones.FieldByName('HO3').AsString;
  dbCreditos.Active:=True;
  EsCredito := dbCreditos.RecordCount<>0;
  dbCreditos.Active:=False;

  EstadoPintado := State - [gdSelected, gdFocused];
  DBGrid1.Canvas.Font.Style := [];

  if EsCredito then
  begin
    if gdSelected in State then
      DBGrid1.Canvas.Brush.Color := RGBToColor(254, 242, 242)
    else
      DBGrid1.Canvas.Brush.Color := RGBToColor(254, 226, 226);
    DBGrid1.Canvas.Font.Color := RGBToColor(185, 28, 28);
    DBGrid1.Canvas.Font.Style := [fsBold];
  end
  else if gdSelected in State then
  begin
    DBGrid1.Canvas.Brush.Color := RGBToColor(219, 234, 254);
    DBGrid1.Canvas.Font.Color := RGBToColor(15, 23, 42);
    DBGrid1.Canvas.Font.Style := [fsBold];
  end
  else
  begin
    DBGrid1.Canvas.Brush.Color := Column.Color;
    DBGrid1.Canvas.Font.Color := RGBToColor(30, 41, 59);
  end;

  DBGrid1.Canvas.FillRect(Rect);
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, EstadoPintado);
end;

procedure TFLHistoop.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  DBGrid1CellClick( DBGrid1.SelectedColumn );
end;


// ===================== COLOREA EL LISTADO =============================
procedure TFLHistoop.Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
var
 TxtQuery,TxtQuery1: String;
 x,j: integer;
begin
  TxtQuery:=dbColor.Sql.Text;
  j:=length(TxtQuery);
  x:=pos('ORDER',TxtQuery);
  if x=0 then x:=pos('ORDER',TxtQuery);
  delete(TxtQuery,x,j-(x-1));
  BlancoGrid(Grid);
  if AntColun <> '' then
     begin
     If StrToInt(AntColun) = Column.Index Then
        if Orden = ' ASC' then Orden:='DESC' else Orden:=' ASC';
  end;
  AntColun:=IntTostr(Column.Index);
  if Orden = 'DESC' then Column.Color := $00DEDEF5 else Column.Color := $00FDEDDF;
  dbColor.Active:=False;
  TxtQuery1:=' ORDER BY ' + Column.FieldName +' '+ Orden;
  Insert(TxtQuery1,TxtQuery,j);
  dbColor.Sql.Text:=TxtQuery; dbColor.Active:=True;
  dbColor.Refresh; Grid.Refresh; Ordenado:=True;
  TituloColumn:=Column.FieldName;
end;
//-------- Poner las columnas del grid en blanco
procedure TFLHistoop.BlancoGrid(Grid: TDBGrid);
var
  conta:integer;
begin
for conta:=0 to Grid.Columns.Count-1 do
    begin Grid.Columns[conta].Color:= clWindow;
  end;
end;

//===============================================================
//==================== OPCIONES DE LISTADOS =====================
//===============================================================
procedure TFLHistoop.RadioButton1ChangeBounds(Sender: TObject);
begin
  OcultarBDGrid();
end;

procedure TFLHistoop.RadioButton2ChangeBounds(Sender: TObject);
begin
  OcultarBDGrid();
end;

procedure TFLHistoop.RadioButton3ChangeBounds(Sender: TObject);
begin
  OcultarBDGrid();
end;

procedure TFLHistoop.RadioButton4ChangeBounds(Sender: TObject);
begin
  OcultarBDGrid();
end;

procedure TFLHistoop.RadioButton5ChangeBounds(Sender: TObject);
begin
  OcultarBDGrid();
end;

procedure TFLHistoop.RadioButton6Click(Sender: TObject);
begin
  if RadioButton6.Checked=True then
    begin
     Edit1.Visible:=True;
     Label11.Visible:=True;
     Label12.Visible:=True;
    end
  else
    begin
     Edit1.Visible:=False;
     Label11.Visible:=False;
     Label12.Visible:=False;
    end;
  OcultarBDGrid();
end;
procedure TFLHistoop.RadioButton7ChangeBounds(Sender: TObject);
begin
   OcultarBDGrid();
end;
procedure TFLHistoop.RadioButton8ChangeBounds(Sender: TObject);
begin
   OcultarBDGrid();
end;
procedure TFLHistoop.RadioButton9ChangeBounds(Sender: TObject);
begin
   OcultarBDGrid();
end;

//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLHistoop.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbOperaciones);
end;
procedure TFLHistoop.DBGrid2TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid2,dbOperaciones);
end;
procedure TFLHistoop.DBGrid4TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid4,dbOperaciones);
end;
procedure TFLHistoop.DBGrid3TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid3,dbOperaciones);
end;
procedure TFLHistoop.DBGrid5TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid5,dbOperaciones);
end;
//========= Boton de busqueda del panel cambiable y seleccion del nombre elejido
procedure TFLHistoop.BitBtnCambiableClick(Sender: TObject);
var
 TxtQuery: String;
begin
 //-- Antigua consulta
 //-- TxtQuery:='SELECT C0, C1 FROM clientes ORDER BY C1';
 //-- CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre, dbCambiable, LabelCambiable);
 TxtQuery := FBusquedas.IniciaBusquedas('SELECT C0, C1 FROM clientes ORDER BY C1',
           ['Codigo', ' Razón social '], 'C0' );
 EditCambiableCodigo.Text:=TxtQuery;
 EditCambiableCodigoExit(EditCambiableCodigo);
end;

procedure TFLHistoop.ComboCambiableNombreClick(Sender: TObject);
begin
  EscogeNombreComboCambiable( 'C1', ComboCambiableNombre, dbCambiable, EditCambiableCodigo, StaticTextCambiableNombre)
end;

procedure TFLHistoop.ComboCambiableNombreKeyPress(Sender: TObject;
  var Key: char);
begin
  if key=#13 then ComboCambiableNombreClick(ComboCambiableNombre);
end;

//======================= Despues de introducir un codigo, al salir, si existe,
//======================= completa el StaticText con el nombre oportuno
procedure TFLHistoop.EditCambiableCodigoExit(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT C1 FROM clientes WHERE C0="'+EditCambiableCodigo.Text+'"';
  if EditCambiableCodigo.Text<>'' then
    begin
     RellenaPanelCambiableN(TxtQuery,dbCambiable, StaticTextCambiableNombre);
     if dbCambiable.RecordCount=0 then
       begin
         Showmessage('NO HAY '+LabelCambiable.Caption+' CON ESE CODIGO');
         EditCambiableCodigo.Text:='';
         exit;
       end;
    end;
end;

procedure TFLHistoop.EditCambiableCodigoEnter(Sender: TObject);
begin
  StaticTextCambiableNombre.Caption:='';
end;

//======================= OCULTA TODOS LOS DBGird y su Titulo
procedure TFLHistoop.OcultarBDGrid();
  begin
    DBGrid1.Visible:=False;
    DBGrid2.Visible:=False;
    DBGrid4.Visible:=False;
    DBGrid5.Visible:=False;
    DimensionarColocarBDGrid();
  end;
//======================= DIMENSIONA LOS DBGrid
// Los DBGrid estan "minimizados" (50x50) para poder trabajar en el resto del
// formulario, con esta funcion los adapto al Panel donde se encuentran
procedure TFLHistoop.DimensionarColocarBDGrid();
  begin
    if FDisenoAplicado then
    begin
      AjustarDisenoModerno;
      Exit;
    end;

    // Distribución original durante la carga inicial del formulario.
    DBGrid1.Top:=40;DBGrid1.Left:=0;DBGrid1.Width:=1000;DBGrid1.Height:=264;
    DBGrid4.Top:=45;DBGrid4.Left:=8;DBGrid4.Width:=554;DBGrid4.Height:=544;
    DBGrid5.Top:=45;DBGrid5.Left:=8;DBGrid5.Width:=554;DBGrid5.Height:=544;
    DBGrid2.Align:=alClient;
  end;

Initialization
  {$I historicoop.lrs}

End.

