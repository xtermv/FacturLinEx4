{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2009,

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

Unit listaproveedores;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class, ExtDlgs, EditBtn, Grids
  {$IFDEF LCLGTK2}
  , gtk2, gdk2
  {$ENDIF}
  ;

Type

  { TFLProveedores }

  TFLProveedores = Class(Tform)
    BitBtnCambiable: TBitBtn;
    BitBtnCambiable1: TBitBtn;
    ComboCambiableNombre: TComboBox;
    ComboCambiableNombre1: TComboBox;
    DateEditDesde: TDateEdit;
    DateEditHasta: TDateEdit;
    dbCambiable: TZQuery;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    dbVencimientos: TZQuery;
    Edit1: TEdit;
    Edit2: TEdit;
    EditCambiableCodigo: TEdit;
    EditCambiableCodigo1: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
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
    Edit4: TEdit;
    Bevel1: TBevel;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
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
    LabelCambiable: TLabel;
    LabelCambiable1: TLabel;
    LabelTituloDBGrid: TLabel;
    LabelTituloDBGrid1: TLabel;
    Panel1: Tpanel;
    Bitbtn1: Tbitbtn;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    BitBtn4: TBitBtn;
    Datasource1: TDatasource;
    dbQuery: TZQuery;
    PanelCambiable: TPanel;
    PanelCambiable1: TPanel;
    PanelFechaDesdeHasta: TPanel;
    PanelDesdeHasta: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton1: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton5: TRadioButton;
    StaticTextCambiableNombre: TStaticText;
    StaticTextCambiableNombre1: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtnCambiable1Click(Sender: TObject);
    procedure BitBtnCambiableClick(Sender: TObject);
    procedure ComboCambiableNombre1Click(Sender: TObject);
    procedure ComboCambiableNombre1KeyPress(Sender: TObject; var Key: char);
    procedure ComboCambiableNombreClick(Sender: TObject);
    procedure ComboCambiableNombreKeyPress(Sender: TObject; var Key: char);
    procedure DateEditDesdeExit(Sender: TObject);
    procedure DateEditHastaExit(Sender: TObject);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid3TitleClick(Column: TColumn);
    procedure DBGrid4TitleClick(Column: TColumn);
    procedure DBGrid5TitleClick(Column: TColumn);
    procedure EditCambiableCodigo1Enter(Sender: TObject);
    procedure EditCambiableCodigo1Exit(Sender: TObject);
    procedure EditCambiableCodigoEnter(Sender: TObject);
    procedure EditCambiableCodigoExit(Sender: TObject);

    Procedure Formcreate(Sender: Tobject);
    procedure FormShow(Sender: TObject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    //procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton5Change(Sender: TObject);
    //procedure RellenaListBoxAnos(TxtQuery: String);
    procedure DBGrid1TitleClick(Column: TColumn);
    //procedure BlancoGrid(Grid: TDBGrid);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    
    procedure OcultarBDGrid();
    procedure DimensionarColocarBDGrid();

  Private
    FPanelCabecera: TPanel;
    FPanelConfiguracion: TPanel;
    FPanelFiltros: TPanel;
    FPanelTipos: TPanel;
    FLabelCabTitulo: TLabel;
    FLabelCabSubtitulo: TLabel;
    FLabelFiltros: TLabel;
    FLabelAyudaFiltros: TLabel;
    FLabelAyudaTipos: TLabel;
    FBtnGuardarPDF: TBitBtn;
    FBtnPrevisualizarPDF: TBitBtn;
    FBtnImprimirPDF: TBitBtn;
    FBtnExportarCSV: TBitBtn;
    FEnResultados: Boolean;
    procedure AplicarDisenoModerno;
    procedure ConfigurarBoton(ABoton: TBitBtn; const ACaption, AHint: String;
      AColor: TColor);
    procedure ConfigurarGrid(AGrid: TDBGrid);
    procedure ConfigurarControlesRecursivo(AParent: TWinControl);
    procedure AplicarContrasteSeleccion(AControl: TWinControl);
    procedure AplicarContrasteSeleccionControles(AParent: TWinControl);
    procedure RecolocarControles;
    procedure MostrarZonaFiltros;
    procedure MostrarZonaResultados;
    procedure ActualizarFlechaOrdenacion(AGrid: TDBGrid; AColumn: TColumn);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    function GridResultadoVisible: TDBGrid;
    procedure PrepararCabeceraExportacion(ACabecera: TStrings);
    function GenerarPDFTemporal(out AFileName: String): Boolean;
    procedure GuardarPDFClick(Sender: TObject);
    procedure PrevisualizarPDFClick(Sender: TObject);
    procedure ImprimirPDFClick(Sender: TObject);
    procedure ExportarCSVClick(Sender: TObject);
    procedure AplicarFocoInicial(Data: PtrInt);
    procedure FormularioKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormularioResize(Sender: TObject);
  Public
    { Public Declarations }
  End;

  procedure ShowFormlistaproveedores;
  
Var
  FLProveedores: TFLProveedores;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

uses
  Global, Funciones, busquedas, uFLXExportGrid;


procedure TFLProveedores.ConfigurarBoton(ABoton: TBitBtn;
  const ACaption, AHint: String; AColor: TColor);
begin
  if not Assigned(ABoton) then Exit;
  ABoton.Caption := ACaption;
  ABoton.Hint := AHint;
  ABoton.ShowHint := True;
  ABoton.Color := AColor;
  ABoton.Font.Name := 'Sans';
  ABoton.Font.Height := -13;
  ABoton.Font.Color := RGBToColor(24, 36, 48);
  ABoton.Font.Style := [fsBold];
  ABoton.Glyph.Clear;
  ABoton.Layout := blGlyphLeft;
  ABoton.Margin := 8;
  ABoton.Spacing := 8;
  ABoton.Visible := True;
  ABoton.BringToFront;
end;

procedure TFLProveedores.ConfigurarGrid(AGrid: TDBGrid);
begin
  if not Assigned(AGrid) then Exit;
  AGrid.Align := alNone;
  AGrid.Color := clWhite;
  AGrid.FixedColor := RGBToColor(224, 235, 244);
  AGrid.Font.Name := 'Sans';
  AGrid.Font.Height := -13;
  AGrid.Font.Color := RGBToColor(20, 30, 40);
  AGrid.TitleFont.Name := 'Sans';
  AGrid.TitleFont.Height := -13;
  AGrid.TitleFont.Color := RGBToColor(24, 52, 78);
  AGrid.TitleFont.Style := [fsBold];
  AGrid.Options := AGrid.Options + [dgTitles, dgIndicator, dgColumnResize,
    dgColumnMove, dgColLines, dgRowLines, dgRowSelect,
    dgAlwaysShowSelection];
  AGrid.OnDrawColumnCell := @GridDrawColumnCell;
end;

procedure TFLProveedores.AplicarContrasteSeleccion(AControl: TWinControl);
{$IFDEF LCLGTK2}
var
  FondoNormal, TextoNormal, FondoSeleccion, TextoSeleccion: TGdkColor;
  Widget: PGtkWidget;
{$ENDIF}
begin
  if not Assigned(AControl) then Exit;
  AControl.HandleNeeded;
  {$IFDEF LCLGTK2}
  Widget := PGtkWidget(AControl.Handle);
  if Assigned(Widget) then
  begin
    gdk_color_parse(PChar('#FFFFFF'), @FondoNormal);
    gdk_color_parse(PChar('#101820'), @TextoNormal);
    gtk_widget_modify_base(Widget, GTK_STATE_NORMAL, @FondoNormal);
    gtk_widget_modify_text(Widget, GTK_STATE_NORMAL, @TextoNormal);
    gdk_color_parse(PChar('#2A5684'), @FondoSeleccion);
    gdk_color_parse(PChar('#FFFFFF'), @TextoSeleccion);
    gtk_widget_modify_base(Widget, GTK_STATE_SELECTED, @FondoSeleccion);
    gtk_widget_modify_text(Widget, GTK_STATE_SELECTED, @TextoSeleccion);
  end;
  {$ENDIF}
end;

procedure TFLProveedores.AplicarContrasteSeleccionControles(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I := 0 to AParent.ControlCount - 1 do
  begin
    C := AParent.Controls[I];
    if (C is TCustomEdit) or (C is TComboBox) then
      AplicarContrasteSeleccion(TWinControl(C));
    if C is TWinControl then
      AplicarContrasteSeleccionControles(TWinControl(C));
  end;
end;

procedure TFLProveedores.ConfigurarControlesRecursivo(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I := 0 to AParent.ControlCount - 1 do
  begin
    C := AParent.Controls[I];
    if (C = FLabelCabTitulo) or (C = FLabelCabSubtitulo) or
       (C = FLabelFiltros) or (C = FLabelAyudaFiltros) or
       (C = FLabelAyudaTipos) or (C = LabelTituloDBGrid) then
    begin
      { Conservan su estilo específico. }
    end
    else if C is TLabel then
    begin
      TLabel(C).ParentColor := True;
      TLabel(C).Transparent := True;
      TLabel(C).Font.Name := 'Sans';
      TLabel(C).Font.Height := -13;
      TLabel(C).Font.Color := RGBToColor(24, 36, 48);
    end
    else if C is TRadioButton then
    begin
      TRadioButton(C).ParentColor := True;
      TRadioButton(C).Font.Name := 'Sans';
      TRadioButton(C).Font.Height := -13;
      TRadioButton(C).Font.Color := RGBToColor(24, 36, 48);
    end
    else if C is TCustomEdit then
    begin
      TCustomEdit(C).Color := clWhite;
      TCustomEdit(C).Font.Name := 'Sans';
      TCustomEdit(C).Font.Height := -13;
      TCustomEdit(C).Font.Color := RGBToColor(16, 24, 32);
    end
    else if C is TComboBox then
    begin
      TComboBox(C).Color := clWhite;
      TComboBox(C).Font.Name := 'Sans';
      TComboBox(C).Font.Height := -13;
      TComboBox(C).Font.Color := RGBToColor(16, 24, 32);
    end
    else if C is TStaticText then
    begin
      TStaticText(C).Color := clWhite;
      TStaticText(C).Font.Name := 'Sans';
      TStaticText(C).Font.Height := -13;
      TStaticText(C).Font.Color := RGBToColor(16, 24, 32);
    end;
    if C is TWinControl then
      ConfigurarControlesRecursivo(TWinControl(C));
  end;
end;

procedure TFLProveedores.AplicarDisenoModerno;
var
  Paneles: array[0..3] of TPanel;
  I: Integer;
begin
  Caption := 'Listados y análisis de proveedores';
  WindowState := wsMaximized;
  Position := poScreenCenter;
  KeyPreview := True;
  Color := RGBToColor(242, 246, 249);
  Font.Name := 'Sans';
  Font.Height := -13;
  Constraints.MinWidth := 1120;
  Constraints.MinHeight := 720;
  ActiveControl := nil;
  OnShow := @FormShow;
  OnKeyDown := @FormularioKeyDown;
  OnResize := @FormularioResize;

  FPanelCabecera := TPanel.Create(Self);
  FPanelCabecera.Name := 'PanelCabeceraModerna';
  FPanelCabecera.Caption := '';
  FPanelCabecera.Parent := Self;
  FPanelCabecera.BevelOuter := bvNone;
  FPanelCabecera.Color := RGBToColor(37, 73, 108);

  FLabelCabTitulo := TLabel.Create(Self);
  FLabelCabTitulo.Parent := FPanelCabecera;
  FLabelCabTitulo.Caption := 'LISTADOS Y ANÁLISIS DE PROVEEDORES';
  FLabelCabTitulo.AutoSize := False;
  FLabelCabTitulo.Font.Name := 'Sans';
  FLabelCabTitulo.Font.Height := -22;
  FLabelCabTitulo.Font.Style := [fsBold];
  FLabelCabTitulo.Font.Color := clWhite;
  FLabelCabTitulo.Transparent := True;

  FLabelCabSubtitulo := TLabel.Create(Self);
  FLabelCabSubtitulo.Parent := FPanelCabecera;
  FLabelCabSubtitulo.Caption :=
    'Seleccione el listado, defina los filtros y consulte los resultados.';
  FLabelCabSubtitulo.AutoSize := False;
  FLabelCabSubtitulo.Font.Name := 'Sans';
  FLabelCabSubtitulo.Font.Height := -13;
  FLabelCabSubtitulo.Font.Color := RGBToColor(221, 234, 245);
  FLabelCabSubtitulo.Transparent := True;

  FPanelConfiguracion := TPanel.Create(Self);
  FPanelConfiguracion.Name := 'PanelConfiguracionModerna';
  FPanelConfiguracion.Caption := '';
  FPanelConfiguracion.Parent := Self;
  FPanelConfiguracion.BevelOuter := bvNone;
  FPanelConfiguracion.Color := RGBToColor(242, 246, 249);

  FPanelTipos := TPanel.Create(Self);
  FPanelTipos.Name := 'PanelTiposListado';
  FPanelTipos.Caption := '';
  FPanelTipos.Parent := FPanelConfiguracion;
  FPanelTipos.BevelOuter := bvNone;
  FPanelTipos.Color := RGBToColor(231, 240, 248);

  FPanelFiltros := TPanel.Create(Self);
  FPanelFiltros.Name := 'PanelFiltrosListado';
  FPanelFiltros.Caption := '';
  FPanelFiltros.Parent := FPanelConfiguracion;
  FPanelFiltros.BevelOuter := bvNone;
  FPanelFiltros.Color := RGBToColor(249, 251, 253);

  FLabelFiltros := TLabel.Create(Self);
  FLabelFiltros.Parent := FPanelFiltros;
  FLabelFiltros.Caption := 'FILTROS Y PARÁMETROS';
  FLabelFiltros.AutoSize := False;
  FLabelFiltros.Font.Name := 'Sans';
  FLabelFiltros.Font.Height := -16;
  FLabelFiltros.Font.Style := [fsBold];
  FLabelFiltros.Font.Color := RGBToColor(37, 73, 108);
  FLabelFiltros.Transparent := True;

  FLabelAyudaFiltros := TLabel.Create(Self);
  FLabelAyudaFiltros.Parent := FPanelFiltros;
  FLabelAyudaFiltros.Caption :=
    'Los filtros visibles cambian según el listado seleccionado.';
  FLabelAyudaFiltros.AutoSize := False;
  FLabelAyudaFiltros.Font.Name := 'Sans';
  FLabelAyudaFiltros.Font.Height := -12;
  FLabelAyudaFiltros.Font.Color := RGBToColor(80, 96, 112);
  FLabelAyudaFiltros.Transparent := True;

  FLabelAyudaTipos := TLabel.Create(Self);
  FLabelAyudaTipos.Parent := FPanelTipos;
  FLabelAyudaTipos.Caption := 'TIPO DE LISTADO';
  FLabelAyudaTipos.AutoSize := False;
  FLabelAyudaTipos.Font.Name := 'Sans';
  FLabelAyudaTipos.Font.Height := -16;
  FLabelAyudaTipos.Font.Style := [fsBold];
  FLabelAyudaTipos.Font.Color := RGBToColor(37, 73, 108);
  FLabelAyudaTipos.Transparent := True;

  Label5.Visible := False;
  Bevel1.Visible := False;

  RadioButton1.Parent := FPanelTipos;
  RadioButton2.Parent := FPanelTipos;
  RadioButton3.Parent := FPanelTipos;
  RadioButton4.Parent := FPanelTipos;
  RadioButton5.Parent := FPanelTipos;

  RadioButton1.Caption := 'Datos generales de proveedores';
  RadioButton2.Caption := 'Facturas recibidas';
  RadioButton3.Caption := 'Vencimientos de pago';
  RadioButton4.Caption := 'Compras realizadas';
  RadioButton5.Caption := 'Etiquetas y direcciones';

  PanelDesdeHasta.Parent := FPanelFiltros;
  PanelCambiable.Parent := FPanelFiltros;
  PanelCambiable1.Parent := FPanelFiltros;
  PanelFechaDesdeHasta.Parent := FPanelFiltros;

  Paneles[0] := PanelDesdeHasta;
  Paneles[1] := PanelCambiable;
  Paneles[2] := PanelCambiable1;
  Paneles[3] := PanelFechaDesdeHasta;
  for I := Low(Paneles) to High(Paneles) do
  begin
    Paneles[I].Caption := '';
    Paneles[I].BevelOuter := bvNone;
    Paneles[I].Color := RGBToColor(236, 244, 250);
  end;
  PanelDesdeHasta.Color := RGBToColor(245, 248, 251);
  PanelFechaDesdeHasta.Color := RGBToColor(239, 247, 241);

  Label2.Caption := 'Código inicial';
  Label1.Caption := 'Código final';
  Label3.Caption := 'Nombre inicial';
  Label4.Caption := 'Nombre final';
  Label10.Caption := 'Fecha inicial';
  Label11.Caption := 'Fecha final';

  PanelTituloGrid.Align := alNone;
  PanelTituloGrid.Caption := '';
  PanelTituloGrid.BevelOuter := bvNone;
  PanelTituloGrid.Color := RGBToColor(222, 235, 246);
  LabelTituloDBGrid.Alignment := taCenter;
  LabelTituloDBGrid.Font.Name := 'Sans';
  LabelTituloDBGrid.Font.Height := -15;
  LabelTituloDBGrid.Font.Style := [fsBold];
  LabelTituloDBGrid.Font.Color := RGBToColor(37, 73, 108);
  LabelTituloDBGrid.Transparent := True;

  Panel1.Align := alNone;
  Panel1.Caption := '';
  Panel1.BevelOuter := bvNone;
  Panel1.Color := RGBToColor(224, 234, 242);

  ConfigurarBoton(BitBtn1, 'Consultar listado',
    'Generar el listado con los filtros seleccionados',
    RGBToColor(166, 214, 181));
  ConfigurarBoton(BitBtn2, 'Informe original',
    'Abrir el informe original correspondiente al listado',
    RGBToColor(184, 218, 244));

  FBtnGuardarPDF := TBitBtn.Create(Self);
  FBtnGuardarPDF.Name := 'BtnGuardarPDF';
  FBtnGuardarPDF.Parent := Panel1;
  FBtnGuardarPDF.OnClick := @GuardarPDFClick;
  ConfigurarBoton(FBtnGuardarPDF, 'Guardar PDF',
    'Guardar el resultado visible en un PDF nuevo',
    RGBToColor(199, 224, 246));

  FBtnPrevisualizarPDF := TBitBtn.Create(Self);
  FBtnPrevisualizarPDF.Name := 'BtnPrevisualizarPDF';
  FBtnPrevisualizarPDF.Parent := Panel1;
  FBtnPrevisualizarPDF.OnClick := @PrevisualizarPDFClick;
  ConfigurarBoton(FBtnPrevisualizarPDF, 'Previsualizar PDF',
    'Abrir un PDF temporal en el visor predeterminado',
    RGBToColor(210, 228, 247));

  FBtnImprimirPDF := TBitBtn.Create(Self);
  FBtnImprimirPDF.Name := 'BtnImprimirPDF';
  FBtnImprimirPDF.Parent := Panel1;
  FBtnImprimirPDF.OnClick := @ImprimirPDFClick;
  ConfigurarBoton(FBtnImprimirPDF, 'Imprimir PDF',
    'Enviar el PDF a la impresora predeterminada',
    RGBToColor(218, 231, 244));

  FBtnExportarCSV := TBitBtn.Create(Self);
  FBtnExportarCSV.Name := 'BtnExportarCSV';
  FBtnExportarCSV.Parent := Panel1;
  FBtnExportarCSV.OnClick := @ExportarCSVClick;
  ConfigurarBoton(FBtnExportarCSV, 'Exportar CSV',
    'Guardar las columnas visibles en CSV UTF-8',
    RGBToColor(210, 232, 216));

  ConfigurarBoton(BitBtn3, 'Nueva consulta',
    'Volver a los filtros y preparar otro listado',
    RGBToColor(255, 224, 166));
  ConfigurarBoton(BitBtn4, 'Cerrar',
    'Cerrar el formulario de proveedores',
    RGBToColor(238, 190, 190));
  ConfigurarBoton(BitBtnCambiable, '...',
    'Buscar y seleccionar una tienda',
    RGBToColor(184, 218, 244));
  ConfigurarBoton(BitBtnCambiable1, '...',
    'Buscar y seleccionar un proveedor',
    RGBToColor(184, 218, 244));

  PanelTituloGrid.Visible := False;

  ConfigurarGrid(DBGrid1);
  ConfigurarGrid(DBGrid2);
  ConfigurarGrid(DBGrid3);
  ConfigurarGrid(DBGrid4);
  ConfigurarGrid(DBGrid5);
  DBGrid3.OnDrawColumnCell := @DBGrid3DrawColumnCell;

  DBGrid1.OnTitleClick := @DBGrid1TitleClick;
  DBGrid2.OnTitleClick := @DBGrid2TitleClick;
  DBGrid3.OnTitleClick := @DBGrid3TitleClick;
  DBGrid4.OnTitleClick := @DBGrid4TitleClick;
  DBGrid5.OnTitleClick := @DBGrid5TitleClick;

  ConfigurarControlesRecursivo(Self);
  FEnResultados := False;
  RecolocarControles;
end;

procedure TFLProveedores.RecolocarControles;
var
  W, H, CabeceraH, BarraH, Margen, ConfigTop, ConfigH: Integer;
  TiposW, PanelW, I, RadioTop: Integer;
  BotonW, BotonH, Separacion, TotalBotonesW, BotonX: Integer;
  Radios: array[0..4] of TRadioButton;
  Botones: array[0..7] of TBitBtn;
  GridTop, GridH: Integer;
begin
  if not Assigned(FPanelCabecera) then Exit;
  W := ClientWidth;
  H := ClientHeight;
  CabeceraH := 82;
  BarraH := 82;
  Margen := 18;

  FPanelCabecera.SetBounds(0, 0, W, CabeceraH);
  FLabelCabTitulo.SetBounds(24, 15, W - 48, 31);
  FLabelCabSubtitulo.SetBounds(26, 51, W - 52, 22);

  Panel1.SetBounds(0, H - BarraH, W, BarraH);

  Botones[0] := BitBtn1;
  Botones[1] := BitBtn2;
  Botones[2] := FBtnGuardarPDF;
  Botones[3] := FBtnPrevisualizarPDF;
  Botones[4] := FBtnImprimirPDF;
  Botones[5] := FBtnExportarCSV;
  Botones[6] := BitBtn3;
  Botones[7] := BitBtn4;
  Separacion := 8;
  BotonH := 54;
  BotonW := (W - 36 - (Separacion * 7)) div 8;
  if BotonW > 180 then BotonW := 180;
  if BotonW < 116 then BotonW := 116;
  TotalBotonesW := (BotonW * 8) + (Separacion * 7);
  BotonX := (W - TotalBotonesW) div 2;
  if BotonX < 8 then BotonX := 8;
  for I := Low(Botones) to High(Botones) do
    if Assigned(Botones[I]) then
    begin
      Botones[I].SetBounds(BotonX + I * (BotonW + Separacion), 14,
        BotonW, BotonH);
      if BotonW < 142 then
        Botones[I].Font.Height := -11
      else
        Botones[I].Font.Height := -13;
      Botones[I].BringToFront;
    end;

  ConfigTop := CabeceraH + 14;
  ConfigH := H - ConfigTop - BarraH - 14;
  if ConfigH < 510 then ConfigH := 510;
  FPanelConfiguracion.SetBounds(Margen, ConfigTop, W - (Margen * 2), ConfigH);

  TiposW := 365;
  if FPanelConfiguracion.Width < 1050 then TiposW := 325;
  FPanelTipos.SetBounds(FPanelConfiguracion.Width - TiposW, 0,
    TiposW, FPanelConfiguracion.Height);
  FPanelFiltros.SetBounds(0, 0, FPanelConfiguracion.Width - TiposW - 14,
    FPanelConfiguracion.Height);

  FLabelFiltros.SetBounds(20, 16, FPanelFiltros.Width - 40, 25);
  FLabelAyudaFiltros.SetBounds(20, 42, FPanelFiltros.Width - 40, 21);
  FLabelAyudaTipos.SetBounds(20, 18, FPanelTipos.Width - 40, 25);

  Radios[0] := RadioButton1;
  Radios[1] := RadioButton2;
  Radios[2] := RadioButton3;
  Radios[3] := RadioButton4;
  Radios[4] := RadioButton5;
  RadioTop := 66;
  for I := Low(Radios) to High(Radios) do
  begin
    Radios[I].SetBounds(22, RadioTop + (I * 48),
      FPanelTipos.Width - 44, 30);
    Radios[I].BringToFront;
  end;

  PanelW := FPanelFiltros.Width - 36;

  PanelDesdeHasta.SetBounds(18, 78, PanelW, 190);
  Label2.SetBounds(16, 19, 105, 22);
  Edit1.SetBounds(130, 14, 140, 30);
  Label1.SetBounds(305, 19, 100, 22);
  Edit2.SetBounds(415, 14, 140, 30);
  Label3.SetBounds(16, 69, 105, 22);
  Edit3.SetBounds(130, 64, PanelW - 150, 30);
  Label4.SetBounds(16, 119, 105, 22);
  Edit4.SetBounds(130, 114, PanelW - 150, 30);

  PanelCambiable.SetBounds(18, 78, PanelW, 54);
  LabelCambiable.SetBounds(16, 17, 105, 22);
  EditCambiableCodigo.SetBounds(130, 12, 120, 30);
  BitBtnCambiable.SetBounds(260, 11, 42, 32);
  StaticTextCambiableNombre.SetBounds(312, 12, PanelW - 328, 30);
  ComboCambiableNombre.SetBounds(312, 12, PanelW - 328, 30);

  PanelCambiable1.SetBounds(18, 142, PanelW, 54);
  LabelCambiable1.SetBounds(16, 17, 105, 22);
  EditCambiableCodigo1.SetBounds(130, 12, 120, 30);
  BitBtnCambiable1.SetBounds(260, 11, 42, 32);
  StaticTextCambiableNombre1.SetBounds(312, 12, PanelW - 328, 30);
  ComboCambiableNombre1.SetBounds(312, 12, PanelW - 328, 30);

  PanelFechaDesdeHasta.SetBounds(18, 206, PanelW, 60);
  Label10.SetBounds(16, 20, 95, 22);
  DateEditDesde.SetBounds(118, 14, 165, 32);
  Label11.SetBounds(315, 20, 90, 22);
  DateEditHasta.SetBounds(412, 14, 165, 32);

  PanelTituloGrid.SetBounds(Margen, CabeceraH + 12, W - (Margen * 2), 44);
  LabelTituloDBGrid.SetBounds(12, 10, PanelTituloGrid.Width - 24, 25);

  GridTop := CabeceraH + 64;
  GridH := H - GridTop - BarraH - 12;
  if GridH < 100 then GridH := 100;
  DBGrid1.SetBounds(Margen, GridTop, W - (Margen * 2), GridH);
  DBGrid2.SetBounds(Margen, GridTop, W - (Margen * 2), GridH);
  DBGrid3.SetBounds(Margen, GridTop, W - (Margen * 2), GridH);
  DBGrid4.SetBounds(Margen, GridTop, W - (Margen * 2), GridH);
  DBGrid5.SetBounds(Margen, GridTop, W - (Margen * 2), GridH);
end;

procedure TFLProveedores.MostrarZonaFiltros;
begin
  FEnResultados := False;
  if Assigned(FPanelConfiguracion) then
  begin
    FPanelConfiguracion.Visible := True;
    FPanelConfiguracion.BringToFront;
  end;
  PanelTituloGrid.Visible := False;
  BitBtn1.Enabled := True;
  BitBtn2.Enabled := False;
  if Assigned(FBtnGuardarPDF) then FBtnGuardarPDF.Enabled := False;
  if Assigned(FBtnPrevisualizarPDF) then FBtnPrevisualizarPDF.Enabled := False;
  if Assigned(FBtnImprimirPDF) then FBtnImprimirPDF.Enabled := False;
  if Assigned(FBtnExportarCSV) then FBtnExportarCSV.Enabled := False;
  BitBtn3.Enabled := False;
  RecolocarControles;
  FPanelCabecera.BringToFront;
  Panel1.BringToFront;
  if Visible then
    Application.QueueAsyncCall(@AplicarFocoInicial, 0);
end;

procedure TFLProveedores.MostrarZonaResultados;
begin
  FEnResultados := True;
  if Assigned(FPanelConfiguracion) then FPanelConfiguracion.Visible := False;
  PanelTituloGrid.Visible := True;
  PanelTituloGrid.BringToFront;
  BitBtn1.Enabled := False;
  BitBtn2.Enabled := True;
  if Assigned(FBtnGuardarPDF) then FBtnGuardarPDF.Enabled := True;
  if Assigned(FBtnPrevisualizarPDF) then FBtnPrevisualizarPDF.Enabled := True;
  if Assigned(FBtnImprimirPDF) then FBtnImprimirPDF.Enabled := True;
  if Assigned(FBtnExportarCSV) then FBtnExportarCSV.Enabled := True;
  BitBtn3.Enabled := True;
  RecolocarControles;
  FPanelCabecera.BringToFront;
  Panel1.BringToFront;
end;

procedure TFLProveedores.ActualizarFlechaOrdenacion(AGrid: TDBGrid;
  AColumn: TColumn);
var
  I: Integer;
  Texto, Flecha: String;
begin
  if (not Assigned(AGrid)) or (not Assigned(AColumn)) then Exit;
  for I := 0 to AGrid.Columns.Count - 1 do
  begin
    Texto := AGrid.Columns[I].Title.Caption;
    Texto := StringReplace(Texto, ' ▲', '', [rfReplaceAll]);
    Texto := StringReplace(Texto, ' ▼', '', [rfReplaceAll]);
    AGrid.Columns[I].Title.Caption := Texto;
  end;
  if SameText(Orden, 'ASC') then Flecha := ' ▲' else Flecha := ' ▼';
  AColumn.Title.Caption := AColumn.Title.Caption + Flecha;
end;

procedure TFLProveedores.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Grid: TDBGrid;
begin
  Grid := TDBGrid(Sender);
  if gdSelected in State then
  begin
    Grid.Canvas.Brush.Color := RGBToColor(42, 86, 132);
    Grid.Canvas.Font.Color := clWhite;
  end
  else
  begin
    Grid.Canvas.Brush.Color := clWhite;
    Grid.Canvas.Font.Color := RGBToColor(20, 30, 40);
  end;
  Grid.Canvas.FillRect(Rect);
  Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

function TFLProveedores.GridResultadoVisible: TDBGrid;
begin
  Result := nil;
  if DBGrid1.Visible then Result := DBGrid1
  else if DBGrid2.Visible then Result := DBGrid2
  else if DBGrid3.Visible then Result := DBGrid3
  else if DBGrid4.Visible then Result := DBGrid4
  else if DBGrid5.Visible then Result := DBGrid5;
end;

procedure TFLProveedores.PrepararCabeceraExportacion(ACabecera: TStrings);
var
  Grid: TDBGrid;
begin
  if not Assigned(ACabecera) then Exit;
  ACabecera.Clear;
  if Empresa <> '' then ACabecera.Add('Empresa: ' + Empresa);
  if TituloGrid <> '' then ACabecera.Add('Listado: ' + TituloGrid);
  if RadioButton2.Checked or RadioButton3.Checked or RadioButton4.Checked then
    ACabecera.Add('Periodo: ' + FormatDateTime('dd/mm/yyyy', DateEditDesde.Date) +
      ' - ' + FormatDateTime('dd/mm/yyyy', DateEditHasta.Date));
  if EditCambiableCodigo.Text <> '' then
    ACabecera.Add('Tienda: ' + EditCambiableCodigo.Text + ' ' +
      StaticTextCambiableNombre.Caption);
  if EditCambiableCodigo1.Text <> '' then
    ACabecera.Add('Proveedor: ' + EditCambiableCodigo1.Text + ' ' +
      StaticTextCambiableNombre1.Caption);
  Grid := GridResultadoVisible;
  if Assigned(Grid) and Assigned(Grid.DataSource) and
     Assigned(Grid.DataSource.DataSet) and Grid.DataSource.DataSet.Active then
    ACabecera.Add('Registros: ' + IntToStr(Grid.DataSource.DataSet.RecordCount));
  ACabecera.Add('Generado: ' + FormatDateTime('dd/mm/yyyy hh:nn', Now));
end;

function TFLProveedores.GenerarPDFTemporal(out AFileName: String): Boolean;
var
  Grid: TDBGrid;
  Cabecera: TStringList;
begin
  Result := False;
  AFileName := '';
  Grid := GridResultadoVisible;
  if not Assigned(Grid) then
  begin
    ShowMessage('No hay ningún listado visible para generar el PDF.');
    Exit;
  end;
  AFileName := IncludeTrailingPathDelimiter(GetTempDir(False)) +
    'facturlinex_proveedores_' +
    FormatDateTime('yyyymmdd_hhnnss_zzz', Now) + '.pdf';
  Cabecera := TStringList.Create;
  try
    PrepararCabeceraExportacion(Cabecera);
    try
      ExportarGridAPDF(Grid, AFileName, TituloGrid, Cabecera);
      Result := True;
    except
      on E: Exception do
        ShowMessage('No se pudo generar el PDF: ' + E.Message);
    end;
  finally
    Cabecera.Free;
  end;
end;

procedure TFLProveedores.GuardarPDFClick(Sender: TObject);
var
  Dialogo: TSaveDialog;
  Grid: TDBGrid;
  Cabecera: TStringList;
begin
  Grid := GridResultadoVisible;
  if not Assigned(Grid) then
  begin
    ShowMessage('No hay ningún listado visible para guardar.');
    Exit;
  end;
  Dialogo := TSaveDialog.Create(Self);
  Cabecera := TStringList.Create;
  try
    Dialogo.Title := 'Guardar listado de proveedores en PDF';
    Dialogo.Filter := 'Documento PDF (*.pdf)|*.pdf';
    Dialogo.DefaultExt := 'pdf';
    Dialogo.FileName := 'Listado_proveedores_' +
      FormatDateTime('yyyymmdd', Date) + '.pdf';
    Dialogo.Options := Dialogo.Options + [ofOverwritePrompt];
    if not Dialogo.Execute then Exit;
    PrepararCabeceraExportacion(Cabecera);
    try
      ExportarGridAPDF(Grid, Dialogo.FileName, TituloGrid, Cabecera);
      ShowMessage('PDF guardado correctamente en:' + LineEnding +
        Dialogo.FileName);
    except
      on E: Exception do
        ShowMessage('No se pudo guardar el PDF: ' + E.Message);
    end;
  finally
    Cabecera.Free;
    Dialogo.Free;
  end;
end;

procedure TFLProveedores.PrevisualizarPDFClick(Sender: TObject);
var
  Archivo, Mensaje: String;
begin
  if not GenerarPDFTemporal(Archivo) then Exit;
  if not PrevisualizarPDFPredeterminado(Archivo, Mensaje) then
    ShowMessage(Mensaje);
end;

procedure TFLProveedores.ImprimirPDFClick(Sender: TObject);
var
  Archivo, Mensaje: String;
begin
  if not GenerarPDFTemporal(Archivo) then Exit;
  ImprimirPDFPredeterminado(Archivo, Mensaje);
  ShowMessage(Mensaje);
end;

procedure TFLProveedores.ExportarCSVClick(Sender: TObject);
var
  Dialogo: TSaveDialog;
  Grid: TDBGrid;
begin
  Grid := GridResultadoVisible;
  if not Assigned(Grid) then
  begin
    ShowMessage('No hay ningún listado visible para exportar.');
    Exit;
  end;
  Dialogo := TSaveDialog.Create(Self);
  try
    Dialogo.Title := 'Exportar listado de proveedores a CSV';
    Dialogo.Filter := 'Archivo CSV (*.csv)|*.csv';
    Dialogo.DefaultExt := 'csv';
    Dialogo.FileName := 'Listado_proveedores_' +
      FormatDateTime('yyyymmdd', Date) + '.csv';
    Dialogo.Options := Dialogo.Options + [ofOverwritePrompt];
    if not Dialogo.Execute then Exit;
    try
      ExportarGridACSV(Grid, Dialogo.FileName);
      ShowMessage('CSV guardado correctamente en:' + LineEnding +
        Dialogo.FileName);
    except
      on E: Exception do
        ShowMessage('No se pudo exportar el CSV: ' + E.Message);
    end;
  finally
    Dialogo.Free;
  end;
end;

procedure TFLProveedores.AplicarFocoInicial(Data: PtrInt);
begin
  if (csDestroying in ComponentState) or (not Visible) then Exit;
  if not Assigned(Edit1) then Exit;
  if (not Edit1.Visible) or (not Edit1.Enabled) then Exit;
  if Edit1.CanFocus then
  begin
    ActiveControl := Edit1;
    Edit1.SetFocus;
    Edit1.SelectAll;
  end;
end;

procedure TFLProveedores.FormularioKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then Exit;
  Key := 0;
  if FEnResultados then
    BitBtn3Click(BitBtn3)
  else
    BitBtn4Click(BitBtn4);
end;

procedure TFLProveedores.FormularioResize(Sender: TObject);
begin
  RecolocarControles;
end;


//=============== Crea el formulario ================
procedure ShowFormlistaproveedores;
begin
  with TFLProveedores.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLProveedores.Formcreate(Sender: Tobject);

Begin
//Conectate(dbConect);    // Utilizamos datamodule1.dbConexión para toda la aplicación.

   //---------------------Paneles visibles por defecto, los de RadioButton1Change
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiable.Visible:=False;
   PanelCambiable1.Visible:=False;
   OcultarBDGrid();

   BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
   DateEditDesde.Date:=Date;
   DateEditHasta.Date:=Date;

   LabelCambiable.Caption:='Tienda';
   LabelCambiable1.Caption:='Proveedor';
   
   AplicarDisenoModerno;

   //Dimensionamos, colocamos y ocultamos todos los DBGrid
   DimensionarColocarBDGrid();
   OcultarBDGrid();
End;

//==================== CERRAR ======================
procedure TFLProveedores.BitBtn4Click(Sender: TObject);
begin
  dbQuery.Active:=False;
  Close();
end;

//==================== VISUALIZAR ===================
procedure TFLProveedores.BitBtn1Click(Sender: TObject);
Var
  //TituloCampos: array[1..3] of string;
  TxtQuery: String;
begin
  AntColun:='0';Ordenado:=False;
  BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
  if EditCambiableCodigo.Text<>'' then Tienda:=DataModule1.LFill(EditCambiableCodigo.Text,4,'0')
  else
   begin
    EditCambiableCodigo.Text:= Tienda;
    EditCambiableCodigoExit(EditCambiableCodigo);
   end;
  //-------------------------- LISTADO DE PROVEEDORES
  if RadioButton1.Checked=True then
    begin
      TituloGrid:='LISTADO DE PROVEEDORES';
      TxtQuery := 'SELECT * FROM proveedores WHERE';
      if Edit1.Text<>'' then
        TxtQuery:=TxtQuery + ' P0>='+Edit1.Text+' AND';
      if Edit2.Text<>'' then
        TxtQuery:=TxtQuery + ' P0<='+Edit2.Text+' AND';
      TxtQuery:=TxtQuery + ' MID(P1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                      '" AND MID(P1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY P0, P1';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
    end;
 //--------------------------_ LISTADO DE FACTURAS RECIBIDAS
  if RadioButton2.Checked=True then
    begin
      TituloGrid:='LISTADO DE FACTURAS RECIBIDAS';
      TxtQuery := 'SELECT * FROM hipedicc'+Tienda+' WHERE ';
      TxtQuery := TxtQuery + ' HPC28 = "F"'; // Filtrado para que solo aparezcan las facturas
      TxtQuery := TxtQuery + ' AND HPC1>="'+FormatDateTime('YYYY/MM/DD',DateEditDesde.Date)+'" AND HPC1<="'+FormatDateTime('YYYY/MM/DD',DateEditHasta.Date)+'"';
      If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HPC0='+EditCambiableCodigo.Text;
      If EditCambiableCodigo1.Text<>'' then TxtQuery := TxtQuery + ' AND HPC2='+EditCambiableCodigo1.Text;
      if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
       TxtQuery:=TxtQuery + ' ORDER BY HPC1,HPC2';

     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid2.BringToFront; DBGrid2.Visible:=True;
    end;
  //--------------------------_ LISTADO DE VENCIMIENTO DE PAGOS

  if RadioButton3.Checked=True then
    begin
      TituloGrid:='LISTADO DE VENCIMIENTOS DE PAGOS';
      TxtQuery := 'SELECT HPC1,HPC2,HPC29,HPC20,HPC21,HPC22,HPC23,HPC24,HPC25,HPC26, HPC27, P0, P1 FROM hipedicc'+Tienda+', proveedores WHERE';
      TxtQuery := TxtQuery + '( HPC20>="'+FormatDateTime('YYYY/MM/DD',DateEditDesde.Date)+'" AND HPC20<="'+FormatDateTime('YYYY/MM/DD',DateEditHasta.Date)+'"';// AND HPC21 <> 0';
      TxtQuery := TxtQuery + ' OR HPC22>="'+FormatDateTime('YYYY/MM/DD',DateEditDesde.Date)+'" AND HPC22<="'+FormatDateTime('YYYY/MM/DD',DateEditHasta.Date)+'"';// AND HPC23 <> 0';
      TxtQuery := TxtQuery + ' OR HPC24>="'+FormatDateTime('YYYY/MM/DD',DateEditDesde.Date)+'" AND HPC24<="'+FormatDateTime('YYYY/MM/DD',DateEditHasta.Date)+'"';// AND HPC25 <> 0';
      TxtQuery := TxtQuery + ' OR HPC26>="'+FormatDateTime('YYYY/MM/DD',DateEditDesde.Date)+'" AND HPC26<="'+FormatDateTime('YYYY/MM/DD',DateEditHasta.Date)+'")';// AND HPC27 <> 0 )';
      TxtQuery := TxtQuery + ' AND P0 = HPC2 AND HPC28 = "F"'; // Filtrado para que solo aparezcan las facturas
      If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HPC0='+EditCambiableCodigo.Text;
      If EditCambiableCodigo1.Text<>'' then TxtQuery := TxtQuery + ' AND HPC2='+EditCambiableCodigo1.Text;
      if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
       TxtQuery:=TxtQuery + ' ORDER BY HPC1,HPC2';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid3.BringToFront; DBGrid3.Visible:=True;
    end;
  //-------------------------- LISTADO DE COMPRAS REALIZADAS
  if RadioButton4.Checked=True then
    begin
      TituloGrid:='LISTADO DE COMPRAS REALIZADAS';
      TxtQuery:=' SELECT HPC0,HPC1,HPC2,HPC7,HPC9,HPC29,HPC30,P0,P1 from hipedicc'+Tienda+', proveedores WHERE';
      TxtQuery := TxtQuery + ' HPC1>="'+FormatDateTime('YYYY/MM/DD',DateEditDesde.Date)+'" AND HPC1<="'+FormatDateTime('YYYY/MM/DD',DateEditHasta.Date)+'"';
      TxtQuery := TxtQuery + ' AND P0 = HPC2';
      If EditCambiableCodigo1.Text<>'' then TxtQuery := TxtQuery + ' AND HPC2='+EditCambiableCodigo1.Text;
      if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
       TxtQuery:=TxtQuery + ' ORDER BY HPC1,HPC2';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid4.BringToFront; DBGrid4.Visible:=True;
    end;
  //-------------------------- LISTADO DE ETIQUETAS Y DIRECCIONES
  // Es el mismo que el 1, lo que cambia es el formato del Report
  if RadioButton5.Checked=True then
    begin
      TituloGrid:='LISTADO DE ETIQUETAS Y DIRECCIONES';
      TxtQuery := 'SELECT * FROM proveedores';
    TxtQuery := TxtQuery + ' WHERE P0 >= '+Edit1.Text+' AND P0 <= '+Edit2.Text+' AND P1>="'+Edit3.Text+'" AND P1<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY P0, P1';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid5.BringToFront; DBGrid5.Visible:=True;
    end;
    LabelTituloDBGrid.Caption:=TituloGrid;
    if DBGrid1.Visible or DBGrid2.Visible or DBGrid3.Visible or
       DBGrid4.Visible or DBGrid5.Visible then
      MostrarZonaResultados;
   WriteLn(TxtQuery);
end;

//==================== SELECCIONAR ===================
procedure TFLProveedores.BitBtn3Click(Sender: TObject);
begin
  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
  MostrarZonaFiltros;
 end;

//==================== IMPRIMIR ===================
procedure TFLProveedores.BitBtn2Click(Sender: TObject);
begin
  //-------------------------- Datos Principales
  if RadioButton1.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoProveedoresDatos.lrf');
     frReport1.ShowReport;
    end;

 //--------------------------_ LISTADO DE FACTURAS RECIBIDAS
  if RadioButton2.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoProveedoresFacRec.lrf');
     frReport1.ShowReport;
    end;
  //--------------------------_ LISTADO DE VENCIMIENTO DE PAGOS

  if RadioButton3.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoProveedoresPagVen.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- LISTADO DE COMPRAS REALIZADAS
  if RadioButton4.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoProveedoresCompras.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- LISTADO DE ETIQUETAS Y DIRECCIONES
  if RadioButton5.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoProveedoresEtiquetas.lrf');
     frReport1.ShowReport;
    end;
end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLProveedores.frReport1GetValue(const ParName: String;
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
procedure TFLProveedores.frReport1EnterRect(Memo: TStringList; View: TfrView);
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

procedure TFLProveedores.RadioButton1Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiable.Visible:=False;
   PanelCambiable1.Visible:=False;
   
   OcultarBDGrid();
end;

procedure TFLProveedores.RadioButton2Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=False;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiable.Visible:=True;
   PanelCambiable1.Visible:=True;

   OcultarBDGrid();
end;

procedure TFLProveedores.RadioButton3Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=False;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiable.Visible:=True;
   PanelCambiable1.Visible:=True;

   OcultarBDGrid();
end;

procedure TFLProveedores.RadioButton4Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=False;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiable.Visible:=True;
   PanelCambiable1.Visible:=True;

   OcultarBDGrid();
end;

procedure TFLProveedores.RadioButton5Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiable.Visible:=False;
   PanelCambiable1.Visible:=False;

   OcultarBDGrid();
end;

// ====================== Redimensiona y Coloca Todos los DBGrid
procedure TFLProveedores.DimensionarColocarBDGrid();
begin
  DBGrid1.Align := alNone;
  DBGrid2.Align := alNone;
  DBGrid3.Align := alNone;
  DBGrid4.Align := alNone;
  DBGrid5.Align := alNone;
  RecolocarControles;
end;

//======================= OCULTA TODOS LOS DBGird
procedure TFLProveedores.OcultarBDGrid();
  begin
    DBGrid1.Visible:=False; DBGrid2.Visible:=False;
    DBGrid3.Visible:=False; DBGrid4.Visible:=False;
    DBGrid5.Visible:=False;
    LabelTituloDBGrid.Caption:='';
  end;
{// ===================== OBTENER AÑOS PARA EL ListBoxAnos
// pasamos como parametro la instrucci´on SQL de donde estan los años buscados
procedure TFLClientes.RellenaListBoxAnos(TxtQuery: String);
begin
     dbAnos.Active:=False;
     dbAnos.SQL.Text:=TxtQuery;
     dbAnos.Active:=True;
     if dbAnos.RecordCount<>0 then
       begin
         dbAnos.First; ListBoxAnos.Items.Clear;
         while not dbAnos.EOF do
          begin
            ListBoxAnos.Items.Add(dbAnos.Fields[0].AsString);
            dbAnos.Next;
          end;
         ListBoxAnos.ItemIndex:=0;
       end;
     PanelSelectAno.Visible:=True;
     PanelDesdeHasta.Visible:=False;
end;
}


//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLProveedores.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid1, Column);
end;
procedure TFLProveedores.DBGrid2TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid2,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid2, Column);
end;
//======SEÑALANDO LAS CELDAS DEL GRID====FECHAS VENCIDAS==================
procedure TFLProveedores.DBGrid3DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
MiColor:TBrush;
ColorVerdoso, ColorRojizo:TColor;
MiDate:TDateTime;
begin
  if gdSelected in State then
  begin
    DBGrid3.Canvas.Brush.Color := RGBToColor(42, 86, 132);
    DBGrid3.Canvas.Font.Color := clWhite;
    DBGrid3.Canvas.FillRect(Rect);
    DBGrid3.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    Exit;
  end;

  DBGrid3.Canvas.Brush.Color := clWhite;
  DBGrid3.Canvas.Font.Color := RGBToColor(20, 30, 40);
  ColorVerdoso:=RGBToColor(18, 128, 74);
  ColorRojizo:=RGBToColor(190, 45, 45);
  MiColor:=DBGrid3.Canvas.Brush;
  MiDate:=Date;
  //MiDate:=StrToDate('01/12/2008');
  if dbQuery.Fields[3].AsString <> ''  then
  begin
    //Primer Vencimiento Fecha
    if (column.Field=dbQuery.Fields[3]) and (dbQuery.Fields[3].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[3].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate)) ;WriteLn(' Menor y pongo las letras en ROJO');
           DBGrid3.Canvas.Font.Color :=ColorRojizo;
           //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
           DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[3]) and (dbQuery.Fields[3].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[3].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo las letras en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
    //Primer Vencimiento Importe
    if (column.Field=dbQuery.Fields[4]) and (dbQuery.Fields[3].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[4].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en ROJO');
       DBGrid3.Canvas.Font.Color :=ColorRojizo;
       //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
       DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[4]) and (dbQuery.Fields[3].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[4].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
  end;

  if dbQuery.Fields[5].AsString <> ''  then
  begin
    //Segundo Vencimiento Fecha
    if (column.Field=dbQuery.Fields[5]) and (dbQuery.Fields[5].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[5].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate)) ;WriteLn(' Menor y pongo las letras en ROJO');
           DBGrid3.Canvas.Font.Color :=ColorRojizo;
           //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
           DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[5]) and (dbQuery.Fields[5].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[5].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo las letras en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
    //Segundo Vencimiento Importe
    if (column.Field=dbQuery.Fields[6]) and (dbQuery.Fields[5].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[6].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en ROJO');
       DBGrid3.Canvas.Font.Color :=ColorRojizo;
       //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
       DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[6]) and (dbQuery.Fields[5].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[6].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
  end;

  if dbQuery.Fields[7].AsString <> ''  then
  begin
    //Tercer Vencimiento Fecha
    if (column.Field=dbQuery.Fields[7]) and (dbQuery.Fields[7].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[7].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate)) ;WriteLn(' Menor y pongo las letras en ROJO');
           DBGrid3.Canvas.Font.Color :=ColorRojizo;
           //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
           DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[7]) and (dbQuery.Fields[7].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[5].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo las letras en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
    //Tercer Vencimiento Importe
    if (column.Field=dbQuery.Fields[8]) and (dbQuery.Fields[7].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[8].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en ROJO');
       DBGrid3.Canvas.Font.Color :=ColorRojizo;
       //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
       DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[8]) and (dbQuery.Fields[7].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[8].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
  end;
  if dbQuery.Fields[9].AsString <> ''  then
  begin
    //Cuarto Vencimiento Fecha
    if (column.Field=dbQuery.Fields[9]) and (dbQuery.Fields[9].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[9].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate)) ;WriteLn(' Menor y pongo las letras en ROJO');
           DBGrid3.Canvas.Font.Color :=ColorRojizo;
           //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
           DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[9]) and (dbQuery.Fields[9].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[9].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo las letras en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
    //Cuarto Vencimiento Importe
    if (column.Field=dbQuery.Fields[10]) and (dbQuery.Fields[9].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[6].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en ROJO');
       DBGrid3.Canvas.Font.Color :=ColorRojizo;
       //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
       DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[10]) and (dbQuery.Fields[9].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[6].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
  end;
  DBGrid3.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  DBGrid3.Canvas.brush:=MiColor;
end;

procedure TFLProveedores.DBGrid3TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid3,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid3, Column);
end;
procedure TFLProveedores.DBGrid4TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid4,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid4, Column);
end;
procedure TFLProveedores.DBGrid5TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid5,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid5, Column);
end;

//========= Boton de busqueda del panel cambiable y seleccion del nombre elejido

procedure TFLProveedores.BitBtnCambiable1Click(Sender: TObject);
var
 TxtQuery: String;
begin
 TxtQuery:='SELECT P0, P1 FROM proveedores ORDER BY P1';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre1, dbCambiable, LabelCambiable1);
end;

procedure TFLProveedores.BitBtnCambiableClick(Sender: TObject);
var
 TxtQuery: String;
begin
 TxtQuery:='SELECT T0, T1 FROM tiendas ORDER BY T1';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre, dbCambiable, LabelCambiable);
end;

procedure TFLProveedores.ComboCambiableNombre1Click(Sender: TObject);
begin
  EscogeNombreComboCambiable( 'P1', ComboCambiableNombre1, dbCambiable, EditCambiableCodigo1, StaticTextCambiableNombre1)
end;

procedure TFLProveedores.ComboCambiableNombreClick(Sender: TObject);
begin
  EscogeNombreComboCambiable( 'T1', ComboCambiableNombre, dbCambiable, EditCambiableCodigo, StaticTextCambiableNombre)
end;

procedure TFLProveedores.ComboCambiableNombre1KeyPress(Sender: TObject;
  var Key: char);
begin
  if key=#13 then ComboCambiableNombre1Click(ComboCambiableNombre1);
end;

procedure TFLProveedores.ComboCambiableNombreKeyPress(Sender: TObject;
  var Key: char);
begin
  if key=#13 then ComboCambiableNombreClick(ComboCambiableNombre);
end;

// --------Formateo de fechas entrantes
procedure TFLProveedores.DateEditDesdeExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditDesde.text) Then
     begin
       DateEditDesde.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

procedure TFLProveedores.DateEditHastaExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditHasta.text) Then
     begin
       DateEditHasta.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

//======================= Despues de introducir un codigo, al salir, si existe,
//======================= completa el StaticText con el nombre oportuno
procedure TFLProveedores.EditCambiableCodigo1Exit(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT P1 FROM proveedores WHERE P0="'+EditCambiableCodigo1.Text+'"';
  if EditCambiableCodigo1.Text<>'' then
    begin
     RellenaPanelCambiableN(TxtQuery,dbCambiable, StaticTextCambiableNombre1);
     if dbCambiable.RecordCount=0 then
       begin
         Showmessage('NO HAY '+LabelCambiable1.Caption+' CON ESE CODIGO');
         EditCambiableCodigo1.Text:='';
         exit;
       end;
    end;
end;

procedure TFLProveedores.EditCambiableCodigoExit(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT T1 FROM tiendas WHERE T0="'+EditCambiableCodigo.Text+'"';
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

procedure TFLProveedores.EditCambiableCodigoEnter(Sender: TObject);
begin
  StaticTextCambiableNombre.Caption:='';
end;

procedure TFLProveedores.EditCambiableCodigo1Enter(Sender: TObject);
begin
  StaticTextCambiableNombre1.Caption:='';
end;

procedure TFLProveedores.FormShow(Sender: TObject);
begin
  RadioButton1.Checked := True;
  RadioButton1Change(RadioButton1);
  MostrarZonaFiltros;
  RecolocarControles;
  AplicarContrasteSeleccionControles(Self);
  Application.QueueAsyncCall(@AplicarFocoInicial, 0);
end;

Procedure TFLProveedores.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

Initialization
  {$I listaproveedores.lrs}

End.

