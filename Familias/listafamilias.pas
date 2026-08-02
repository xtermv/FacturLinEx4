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

Unit listafamilias;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class, Grids
  {$IFDEF LCLGTK2}
  , gtk2, gdk2
  {$ENDIF}
  ;

Type

  { TFLFamilias }

  TFLFamilias = Class(Tform)
    dbAnos: TZQuery;
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
    Edit4: TEdit;
    Bevel1: TBevel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    Edit7: TEdit;
    Edit8: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
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
    LabelTituloDBGrid: TLabel;
    LabelTituloDBGrid1: TLabel;
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
    PanelDesdeHasta: TPanel;
    PanelSelectAno: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGrid3TitleClick(Column: TColumn);
    //procedure DBGrid4TitleClick(Column: TColumn);

    Procedure Formcreate(Sender: Tobject);
    procedure FormShow(Sender: TObject);
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
    procedure DescripcionHexGetText(Sender: TField; var AText: String;
      DisplayText: Boolean);
    procedure ConfigurarCampoDescripcion;
    procedure ConfigurarCampoObservaciones;
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

  procedure ShowFormlistafamilias;
  
Var
  FLFamilias: TFLFamilias;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

uses
  Global, Funciones, uFLXExportGrid;



procedure TFLFamilias.ConfigurarBoton(ABoton: TBitBtn;
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

function HexATextoUTF8(const AHex: String): String;
var
  I, N: Integer;
  Raw: RawByteString;
begin
  Result := '';
  N := Length(AHex) div 2;
  if N <= 0 then Exit;
  SetLength(Raw, N);
  for I := 0 to N - 1 do
    Raw[I + 1] := AnsiChar(StrToIntDef('$' + Copy(AHex, I * 2 + 1, 2), 0));
  { El servidor genera el HEX después de convertir F1 a utf8mb4.
    Validamos y devolvemos los bytes como texto UTF-8 para LCL/GTK. }
  Result := UTF8Encode(UTF8Decode(Raw));
end;

procedure TFLFamilias.DescripcionHexGetText(Sender: TField;
  var AText: String; DisplayText: Boolean);
begin
  if (not Assigned(Sender)) or Sender.IsNull then
    AText := ''
  else
    AText := HexATextoUTF8(Sender.AsString);
end;

procedure TFLFamilias.ConfigurarCampoDescripcion;
var
  Campo: TField;
begin
  if not dbQuery.Active then Exit;
  Campo := dbQuery.FindField('DESCRIPCION_HEX');
  if Assigned(Campo) then
  begin
    Campo.DisplayLabel := 'DESCRIPCIÓN';
    Campo.OnGetText := @DescripcionHexGetText;
  end;
end;

procedure TFLFamilias.ConfigurarCampoObservaciones;
var
  Campo: TField;
begin
  if not dbQuery.Active then Exit;
  Campo := dbQuery.FindField('OBSERVACIONES_HEX');
  if Assigned(Campo) then
  begin
    Campo.DisplayLabel := 'OBSERVACIONES';
    Campo.OnGetText := @DescripcionHexGetText;
  end;
end;

procedure TFLFamilias.ConfigurarGrid(AGrid: TDBGrid);
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

procedure TFLFamilias.AplicarContrasteSeleccion(AControl: TWinControl);
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

procedure TFLFamilias.AplicarContrasteSeleccionControles(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I := 0 to AParent.ControlCount - 1 do
  begin
    C := AParent.Controls[I];
    if (C is TCustomEdit) or (C is TComboBox) or (C is TListBox) then
      AplicarContrasteSeleccion(TWinControl(C));
    if C is TWinControl then
      AplicarContrasteSeleccionControles(TWinControl(C));
  end;
end;

procedure TFLFamilias.ConfigurarControlesRecursivo(AParent: TWinControl);
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
    else if C is TListBox then
    begin
      TListBox(C).Color := clWhite;
      TListBox(C).Font.Name := 'Sans';
      TListBox(C).Font.Height := -13;
      TListBox(C).Font.Color := RGBToColor(16, 24, 32);
    end;
    if C is TWinControl then
      ConfigurarControlesRecursivo(TWinControl(C));
  end;
end;

procedure TFLFamilias.AplicarDisenoModerno;
begin
  Caption := 'Listados y análisis de familias';
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
  FLabelCabTitulo.Caption := 'LISTADOS Y ANÁLISIS DE FAMILIAS';
  FLabelCabTitulo.AutoSize := False;
  FLabelCabTitulo.Font.Name := 'Sans';
  FLabelCabTitulo.Font.Height := -22;
  FLabelCabTitulo.Font.Style := [fsBold];
  FLabelCabTitulo.Font.Color := clWhite;
  FLabelCabTitulo.Transparent := True;

  FLabelCabSubtitulo := TLabel.Create(Self);
  FLabelCabSubtitulo.Parent := FPanelCabecera;
  FLabelCabSubtitulo.Caption :=
    'Consulte datos generales, compras o ventas agrupadas por familia.';
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
    'Defina el intervalo de familias y, para compras o ventas, el ejercicio y los meses.';
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
  RadioButton1.Caption := 'Datos generales de familias';
  RadioButton2.Caption := 'Compras agrupadas por familias';
  RadioButton3.Caption := 'Ventas y beneficio por familias';

  PanelDesdeHasta.Parent := FPanelFiltros;
  PanelSelectAno.Parent := FPanelFiltros;
  PanelDesdeHasta.Caption := '';
  PanelDesdeHasta.BevelOuter := bvNone;
  PanelDesdeHasta.Color := RGBToColor(245, 248, 251);
  PanelSelectAno.Caption := '';
  PanelSelectAno.BevelOuter := bvNone;
  PanelSelectAno.Color := RGBToColor(239, 247, 241);

  Label2.Caption := 'Código inicial';
  Label1.Caption := 'Código final';
  Label3.Caption := 'Nombre inicial';
  Label4.Caption := 'Nombre final';
  Label6.Caption := 'Ejercicios disponibles';
  Label7.Caption := 'Mes inicial';
  Label8.Caption := 'Mes final';

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
    'Cerrar el formulario de familias',
    RGBToColor(238, 190, 190));

  PanelTituloGrid.Visible := False;
  ConfigurarGrid(DBGrid1);
  ConfigurarGrid(DBGrid2);
  ConfigurarGrid(DBGrid3);
  DBGrid1.OnTitleClick := @DBGrid1TitleClick;
  DBGrid2.OnTitleClick := @DBGrid2TitleClick;
  DBGrid3.OnTitleClick := @DBGrid3TitleClick;

  if DBGrid1.Columns.Count >= 4 then
  begin
    DBGrid1.Columns[0].Width := 90;
    DBGrid1.Columns[1].Width := 290;
    DBGrid1.Columns[2].Width := 460;
    DBGrid1.Columns[3].Width := 190;
  end;
  if DBGrid2.Columns.Count >= 4 then
  begin
    DBGrid2.Columns[0].Width := 95;
    DBGrid2.Columns[1].Width := 340;
    DBGrid2.Columns[2].Width := 160;
    DBGrid2.Columns[3].Width := 180;
  end;
  if DBGrid3.Columns.Count >= 6 then
  begin
    DBGrid3.Columns[0].Width := 95;
    DBGrid3.Columns[1].Width := 300;
    DBGrid3.Columns[2].Width := 130;
    DBGrid3.Columns[3].Width := 165;
    DBGrid3.Columns[4].Width := 165;
    DBGrid3.Columns[5].Width := 155;
  end;

  ConfigurarControlesRecursivo(Self);
  FEnResultados := False;
  RecolocarControles;
end;

procedure TFLFamilias.RecolocarControles;
var
  W, H, CabeceraH, BarraH, Margen, ConfigTop, ConfigH: Integer;
  TiposW, PanelW, I, RadioTop: Integer;
  BotonW, BotonH, Separacion, TotalBotonesW, BotonX: Integer;
  Radios: array[0..2] of TRadioButton;
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
      if BotonW < 142 then Botones[I].Font.Height := -11
      else Botones[I].Font.Height := -13;
      Botones[I].BringToFront;
    end;

  ConfigTop := CabeceraH + 14;
  ConfigH := H - ConfigTop - BarraH - 14;
  if ConfigH < 510 then ConfigH := 510;
  FPanelConfiguracion.SetBounds(Margen, ConfigTop, W - (Margen * 2), ConfigH);

  TiposW := 355;
  if FPanelConfiguracion.Width < 1040 then TiposW := 325;
  FPanelTipos.SetBounds(FPanelConfiguracion.Width - TiposW, 0,
    TiposW, FPanelConfiguracion.Height);
  FPanelFiltros.SetBounds(0, 0, FPanelConfiguracion.Width - TiposW - 14,
    FPanelConfiguracion.Height);

  FLabelFiltros.SetBounds(20, 16, FPanelFiltros.Width - 40, 25);
  FLabelAyudaFiltros.SetBounds(20, 42, FPanelFiltros.Width - 40, 35);
  FLabelAyudaTipos.SetBounds(20, 18, FPanelTipos.Width - 40, 25);

  Radios[0] := RadioButton1;
  Radios[1] := RadioButton2;
  Radios[2] := RadioButton3;
  RadioTop := 72;
  for I := Low(Radios) to High(Radios) do
  begin
    Radios[I].SetBounds(22, RadioTop + (I * 58),
      FPanelTipos.Width - 44, 38);
    Radios[I].BringToFront;
  end;

  PanelW := FPanelFiltros.Width - 36;
  PanelDesdeHasta.SetBounds(18, 88, PanelW, 184);
  Label2.SetBounds(16, 18, 105, 22);
  Edit1.SetBounds(130, 13, 140, 30);
  Label1.SetBounds(310, 18, 100, 22);
  Edit2.SetBounds(420, 13, 140, 30);
  Label3.SetBounds(16, 68, 105, 22);
  Edit3.SetBounds(130, 63, PanelW - 150, 30);
  Label4.SetBounds(16, 118, 105, 22);
  Edit4.SetBounds(130, 113, PanelW - 150, 30);

  PanelSelectAno.SetBounds(18, 288, PanelW, 152);
  Label6.SetBounds(16, 15, 170, 22);
  ListBoxAnos.SetBounds(16, 40, 160, 96);
  Label7.SetBounds(220, 48, 90, 22);
  Edit7.SetBounds(315, 43, 100, 30);
  Label8.SetBounds(220, 96, 90, 22);
  Edit8.SetBounds(315, 91, 100, 30);

  PanelTituloGrid.SetBounds(Margen, CabeceraH + 12, W - (Margen * 2), 44);
  LabelTituloDBGrid.SetBounds(12, 10, PanelTituloGrid.Width - 24, 25);
  GridTop := CabeceraH + 64;
  GridH := H - GridTop - BarraH - 12;
  if GridH < 100 then GridH := 100;
  DBGrid1.SetBounds(Margen, GridTop, W - (Margen * 2), GridH);
  DBGrid2.SetBounds(Margen, GridTop, W - (Margen * 2), GridH);
  DBGrid3.SetBounds(Margen, GridTop, W - (Margen * 2), GridH);
end;

procedure TFLFamilias.MostrarZonaFiltros;
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
  if Visible then Application.QueueAsyncCall(@AplicarFocoInicial, 0);
end;

procedure TFLFamilias.MostrarZonaResultados;
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

procedure TFLFamilias.ActualizarFlechaOrdenacion(AGrid: TDBGrid;
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

procedure TFLFamilias.GridDrawColumnCell(Sender: TObject;
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

function TFLFamilias.GridResultadoVisible: TDBGrid;
begin
  Result := nil;
  if DBGrid1.Visible then Result := DBGrid1
  else if DBGrid2.Visible then Result := DBGrid2
  else if DBGrid3.Visible then Result := DBGrid3;
end;

procedure TFLFamilias.PrepararCabeceraExportacion(ACabecera: TStrings);
var
  Grid: TDBGrid;
begin
  if not Assigned(ACabecera) then Exit;
  ACabecera.Clear;
  if Empresa <> '' then ACabecera.Add('Empresa: ' + Empresa);
  if TituloGrid <> '' then ACabecera.Add('Listado: ' + TituloGrid);
  ACabecera.Add('Familias: códigos ' + Edit1.Text + ' a ' + Edit2.Text +
    '; nombres ' + Edit3.Text + ' a ' + Edit4.Text);
  if RadioButton2.Checked or RadioButton3.Checked then
  begin
    if ListBoxAnos.ItemIndex >= 0 then
      ACabecera.Add('Periodo: meses ' + Edit7.Text + ' a ' + Edit8.Text +
        ' del ejercicio ' + ListBoxAnos.Items[ListBoxAnos.ItemIndex]);
  end;
  Grid := GridResultadoVisible;
  if Assigned(Grid) and Assigned(Grid.DataSource) and
     Assigned(Grid.DataSource.DataSet) and Grid.DataSource.DataSet.Active then
    ACabecera.Add('Registros: ' + IntToStr(Grid.DataSource.DataSet.RecordCount));
  ACabecera.Add('Generado: ' + FormatDateTime('dd/mm/yyyy hh:nn', Now));
end;

function TFLFamilias.GenerarPDFTemporal(out AFileName: String): Boolean;
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
    'facturlinex_familias_' + FormatDateTime('yyyymmdd_hhnnss_zzz', Now) + '.pdf';
  Cabecera := TStringList.Create;
  try
    PrepararCabeceraExportacion(Cabecera);
    try
      ExportarGridAPDF(Grid, AFileName, TituloGrid, Cabecera);
      Result := True;
    except
      on E: Exception do ShowMessage('No se pudo generar el PDF: ' + E.Message);
    end;
  finally
    Cabecera.Free;
  end;
end;

procedure TFLFamilias.GuardarPDFClick(Sender: TObject);
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
    Dialogo.Title := 'Guardar listado de familias en PDF';
    Dialogo.Filter := 'Documento PDF (*.pdf)|*.pdf';
    Dialogo.DefaultExt := 'pdf';
    Dialogo.FileName := 'Listado_familias_' + FormatDateTime('yyyymmdd', Date) + '.pdf';
    Dialogo.Options := Dialogo.Options + [ofOverwritePrompt];
    if not Dialogo.Execute then Exit;
    PrepararCabeceraExportacion(Cabecera);
    try
      ExportarGridAPDF(Grid, Dialogo.FileName, TituloGrid, Cabecera);
      ShowMessage('PDF guardado correctamente en:' + LineEnding + Dialogo.FileName);
    except
      on E: Exception do ShowMessage('No se pudo guardar el PDF: ' + E.Message);
    end;
  finally
    Cabecera.Free;
    Dialogo.Free;
  end;
end;

procedure TFLFamilias.PrevisualizarPDFClick(Sender: TObject);
var
  Archivo, Mensaje: String;
begin
  if not GenerarPDFTemporal(Archivo) then Exit;
  if not PrevisualizarPDFPredeterminado(Archivo, Mensaje) then ShowMessage(Mensaje);
end;

procedure TFLFamilias.ImprimirPDFClick(Sender: TObject);
var
  Archivo, Mensaje: String;
begin
  if not GenerarPDFTemporal(Archivo) then Exit;
  ImprimirPDFPredeterminado(Archivo, Mensaje);
  ShowMessage(Mensaje);
end;

procedure TFLFamilias.ExportarCSVClick(Sender: TObject);
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
    Dialogo.Title := 'Exportar listado de familias a CSV';
    Dialogo.Filter := 'Archivo CSV (*.csv)|*.csv';
    Dialogo.DefaultExt := 'csv';
    Dialogo.FileName := 'Listado_familias_' + FormatDateTime('yyyymmdd', Date) + '.csv';
    Dialogo.Options := Dialogo.Options + [ofOverwritePrompt];
    if not Dialogo.Execute then Exit;
    try
      ExportarGridACSV(Grid, Dialogo.FileName);
      ShowMessage('CSV guardado correctamente en:' + LineEnding + Dialogo.FileName);
    except
      on E: Exception do ShowMessage('No se pudo exportar el CSV: ' + E.Message);
    end;
  finally
    Dialogo.Free;
  end;
end;

procedure TFLFamilias.AplicarFocoInicial(Data: PtrInt);
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

procedure TFLFamilias.FormularioKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then Exit;
  Key := 0;
  if FEnResultados then BitBtn3Click(BitBtn3)
  else BitBtn4Click(BitBtn4);
end;

procedure TFLFamilias.FormularioResize(Sender: TObject);
begin
  RecolocarControles;
end;


//=============== Crea el formulario ================
procedure ShowFormlistafamilias;
begin
  with TFLFamilias.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLFamilias.Formcreate(Sender: Tobject);
Begin
  PanelSelectAno.Visible := False;
  PanelDesdeHasta.Visible := True;
  BitBtn2.Enabled := False;
  BitBtn3.Enabled := False;
  AplicarDisenoModerno;
  DimensionarColocarBDGrid();
  OcultarBDGrid();
  MostrarZonaFiltros;
End;

procedure TFLFamilias.FormShow(Sender: TObject);
begin
  AplicarContrasteSeleccionControles(Self);
  RecolocarControles;
  Application.QueueAsyncCall(@AplicarFocoInicial, 0);
end;

//==================== CERRAR ======================
procedure TFLFamilias.BitBtn4Click(Sender: TObject);
begin
  dbQuery.Active:=False;
  Close();
end;



//==================== VISUALIZAR ===================
procedure TFLFamilias.BitBtn1Click(Sender: TObject);
Var
  TxtQuery, DescripcionHexSQL, ObservacionesHexSQL: String;
begin
  { F1 y OBSER se mantienen intactos para los informes FastReport originales.
    Para los DBGrid y las nuevas salidas generamos campos ASCII seguros
    con los bytes UTF-8 en hexadecimal; OnGetText los convierte a texto. }
  DescripcionHexSQL := 'HEX(CONVERT(F1 USING utf8mb4))';
  ObservacionesHexSQL :=
    'HEX(CONVERT(MID(F5,1,30) USING utf8mb4))';

  if (RadioButton2.Checked or RadioButton3.Checked) and
     (ListBoxAnos.ItemIndex < 0) then
  begin
    ShowMessage('Seleccione un ejercicio antes de consultar el listado.');
    Exit;
  end;
  AntColun := '0';
  Ordenado := False;
  BitBtn2.Enabled := True;
  BitBtn3.Enabled := True;
  //-------------------------- DATOS PRINCIPALES
  if RadioButton1.Checked=True then
    begin
     TituloGrid:='LISTADO DE FAMILIAS - DATOS PRINCIPALES';
     TxtQuery := 'select distinct F0, F1, ' + DescripcionHexSQL +
       ' AS DESCRIPCION_HEX, MID(F5,1,30) as OBSER, ' +
       ObservacionesHexSQL + ' AS OBSERVACIONES_HEX, D1 ';
     TxtQuery := TxtQuery + 'FROM familias'+Tienda+' LEFT OUTER JOIN departamentos'+Tienda+' ON F2=D0 WHERE';
     if Edit1.Text<>'' then
       TxtQuery:=TxtQuery + ' F0>='+Edit1.Text+' AND';
     if Edit2.Text<>'' then
       TxtQuery:=TxtQuery + ' F0<='+Edit2.Text+' AND';
     TxtQuery:=TxtQuery + ' MID(F1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(F1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY F0, F1';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     ConfigurarCampoDescripcion;
     ConfigurarCampoObservaciones;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
    end;
 //--------------------------- COMPRAS POR FAMILIAS
  if RadioButton2.Checked=True then
    begin
     TituloGrid:='LISTADO DE COMPRAS POR FAMILIAS';
     TxtQuery := 'SELECT F0, F1, ' + DescripcionHexSQL +
       ' AS DESCRIPCION_HEX, SUM(FF3) As Unid, SUM(FF4) As Impor';
     TxtQuery := TxtQuery + ' FROM familias'+Tienda+',estafami'+Tienda+' WHERE';
     if Edit1.Text<>'' then
       TxtQuery:=TxtQuery + ' F0>='+Edit1.Text+' AND';
     if Edit2.Text<>'' then
       TxtQuery:=TxtQuery + ' F0<='+Edit2.Text+' AND';
     TxtQuery:=TxtQuery + ' MID(F1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(F1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     TxtQuery := TxtQuery + ' AND FF1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+
     ' AND FF2>='+Edit7.Text+' AND FF2<='+Edit8.Text;
     TxtQuery := TxtQuery + ' AND F0=FF0';
     TxtQuery := TxtQuery + ' GROUP BY F0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY F0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     ConfigurarCampoDescripcion;
     if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     DBGrid2.BringToFront; DBGrid2.Visible:=True;
    end;
  //-------------------------- VENTAS POR FAMILIAS

  if RadioButton3.Checked=True then
    begin
     TituloGrid:='LISTADO DE VENTAS POR FAMILIAS';
     TxtQuery := 'SELECT F0, F1, ' + DescripcionHexSQL +
       ' AS DESCRIPCION_HEX, SUM(FF5) As Unid, SUM(FF6) As ImporPrc, ' +
       'SUM(FF7) As ImporCOS, SUM(FF6-FF7) As Benef';
     TxtQuery := TxtQuery + ' FROM familias'+Tienda+',estafami'+Tienda+' WHERE';
     if Edit1.Text<>'' then
       TxtQuery:=TxtQuery + ' F0>='+Edit1.Text+' AND';
     if Edit2.Text<>'' then
       TxtQuery:=TxtQuery + ' F0<='+Edit2.Text+' AND';
     TxtQuery:=TxtQuery + ' MID(F1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(F1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     TxtQuery := TxtQuery + ' AND FF1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+
     ' AND FF2>='+Edit7.Text+' AND FF2<='+Edit8.Text;
     TxtQuery := TxtQuery + ' AND F0=FF0';
     TxtQuery := TxtQuery + ' GROUP BY F0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + '  ORDER BY F0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     ConfigurarCampoDescripcion;
     if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     DBGrid3.BringToFront; DBGrid3.Visible:=True;
    end;
   LabelTituloDBGrid.Caption := TituloGrid;
   MostrarZonaResultados;
end;

//==================== SELECCIONAR ===================
procedure TFLFamilias.BitBtn3Click(Sender: TObject);
begin
  BitBtn2.Enabled := False;
  BitBtn3.Enabled := False;
  Ordenado := False;
  OcultarBDGrid();
  MostrarZonaFiltros;
end;

//==================== IMPRIMIR ===================
procedure TFLFamilias.BitBtn2Click(Sender: TObject);
begin
  //-------------------------- Datos Principales
  if RadioButton1.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoFamiliasDatos.lrf');
     frReport1.ShowReport;
    end;
    
  //--------------------------_ LISTADO DE FAMILIAS POR COMPRAS
  if RadioButton2.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoFamiliasCompras.lrf');
     frReport1.ShowReport;
    end;

  //--------------------------_ LISTADO DE FAMILIAS POR VENTAS

  if RadioButton3.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoFamiliasVentas.lrf');
     frReport1.ShowReport;
    end;

end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLFamilias.frReport1GetValue(const ParName: String;
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
procedure TFLFamilias.frReport1EnterRect(Memo: TStringList; View: TfrView);
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

procedure TFLFamilias.RadioButton1Change(Sender: TObject);
begin
  if not RadioButton1.Checked then Exit;
  PanelSelectAno.Visible := False;
  PanelDesdeHasta.Visible := True;
  OcultarBDGrid();
  RecolocarControles;
end;

procedure TFLFamilias.RadioButton2Change(Sender: TObject);
begin
  if not RadioButton2.Checked then Exit;
  RellenaListBoxAnos('SELECT DISTINCT(FF1) FROM estafami' + Tienda,
    dbAnos, PanelSelectAno, ListBoxAnos);
  PanelDesdeHasta.Visible := True;
  PanelSelectAno.Visible := True;
  if (ListBoxAnos.Items.Count > 0) and (ListBoxAnos.ItemIndex < 0) then
    ListBoxAnos.ItemIndex := 0;
  OcultarBDGrid();
  RecolocarControles;
end;

procedure TFLFamilias.RadioButton3Change(Sender: TObject);
begin
  if not RadioButton3.Checked then Exit;
  RellenaListBoxAnos('SELECT DISTINCT(FF1) FROM estafami' + Tienda,
    dbAnos, PanelSelectAno, ListBoxAnos);
  PanelDesdeHasta.Visible := True;
  PanelSelectAno.Visible := True;
  if (ListBoxAnos.Items.Count > 0) and (ListBoxAnos.ItemIndex < 0) then
    ListBoxAnos.ItemIndex := 0;
  OcultarBDGrid();
  RecolocarControles;
end;

// ====================== Redimensiona y Coloca Todos los DBGrid
procedure TFLFamilias.DimensionarColocarBDGrid();
begin
  DBGrid1.Align := alNone;
  DBGrid2.Align := alNone;
  DBGrid3.Align := alNone;
  RecolocarControles;
end;

//======================= OCULTA TODOS LOS DBGird
procedure TFLFamilias.OcultarBDGrid();
  begin
    LabelTituloDBGrid.Caption:='';
    DBGrid1.Visible:=False; DBGrid2.Visible:=False;
    DBGrid3.Visible:=False; //DBGrid4.Visible:=False;
  end;


//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLFamilias.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column, DBGrid1, dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid1, Column);
end;
procedure TFLFamilias.DBGrid2TitleClick(Column: TColumn);
begin
  Colorea(Column, DBGrid2, dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid2, Column);
end;
procedure TFLFamilias.DBGrid3TitleClick(Column: TColumn);
begin
  Colorea(Column, DBGrid3, dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid3, Column);
end;
{procedure TFLFamilias.DBGrid4TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid4,dbQuery);
end;}


Procedure TFLFamilias.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

Initialization
  {$I listafamilias.lrs}

End.

