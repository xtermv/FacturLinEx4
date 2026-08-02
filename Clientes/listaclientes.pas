{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2008,

  Antonio Dominguez

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

Unit listaclientes;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class, EditBtn, Grids
  {$IFDEF LCLGTK2}
  , gtk2, gdk2
  {$ENDIF}
  ;

Type

  { TFLClientes }

  TFLClientes = Class(Tform)
    Bevel1: TBevel;
    BitBtnCambiableRuta: TBitBtn;
    ComboCambiableNombreRuta: TComboBox;
    ComboCambiableNombreProvincia: TComboBox;
    ComboCambiableNombreLocalidad: TComboBox;
    DateEditDesde: TDateEdit;
    DateEditHasta: TDateEdit;
    dbCambiable: TZQuery;
    DBGrid1: TDBGrid;
    DBGrid11: TDBGrid;
    DBGrid7: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    DBGrid6: TDBGrid;
    DBGrid8: TDBGrid;
    DBGrid10: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid9: TDBGrid;
    dbQuery1: TZQuery;
    Edit1: TEdit;
    EditEntregasCuenta: TEdit;
    EditRiesgoMaximo: TEdit;
    EditPendFacturar: TEdit;
    EditCodVendedor: TEdit;
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
    dbAnos: TZQuery;
    Edit7: TEdit;
    Edit8: TEdit;
    EditCambiableCodigo: TEdit;
    EditCambiableCodigoRuta: TEdit;
    EditCambiableNombre: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    LabelPendFacutar: TLabel;
    LabelEntreCuenta: TLabel;
    LabelVendedor: TLabel;
    LabelRiesgoMax: TLabel;
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
    LabelCambiableRuta: TLabel;
    LabelCambiableProvincia: TLabel;
    LabelCambiableLocalidad: TLabel;
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
    PanelCambiableRuta: TPanel;
    PanelCambiableProvincia: TPanel;
    PanelCambiableLocalidad: TPanel;
    PanelFechaDesdeHasta: TPanel;
    PanelSelectAno: TPanel;
    PanelRiesgoMax: TPanel;
    PanelVendedor: TPanel;
    PanelTituloGrid: TPanel;
    PanelDesdeHasta: TPanel;
    RadioButton1: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    StaticTextCambiableNombreRuta: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);

    procedure DateEditDesdeExit(Sender: TObject);
    procedure DateEditHastaExit(Sender: TObject);
    procedure DBGrid11TitleClick(Column: TColumn);
    procedure DBGrid7TitleClick(Column: TColumn);
    procedure DBGrid4TitleClick(Column: TColumn);
    procedure DBGrid5TitleClick(Column: TColumn);
    procedure DBGrid6TitleClick(Column: TColumn);
    procedure DBGrid8TitleClick(Column: TColumn);
    procedure DBGrid10TitleClick(Column: TColumn);
    procedure DBGrid3TitleClick(Column: TColumn);
    procedure DBGrid9TitleClick(Column: TColumn);


    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    procedure FormShow(Sender: TObject);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    procedure OcultarBDGrid();
    procedure RadioButton10Change(Sender: TObject);
    procedure RadioButton11Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    procedure RadioButton5Change(Sender: TObject);
    procedure RadioButton6Change(Sender: TObject);
    procedure RadioButton7Change(Sender: TObject);
    procedure RadioButton8Change(Sender: TObject);
    procedure RadioButton9Change(Sender: TObject);

    procedure EditCambiableCodigoRutaEnter(Sender: TObject);
    procedure EditCambiableCodigoRutaExit(Sender: TObject);
    procedure ComboCambiableNombreRutaClick(Sender: TObject);
    procedure ComboCambiableNombreRutaKeyPress(Sender: TObject; var Key: char);
    procedure BitBtnCambiableRutaClick(Sender: TObject);
    procedure ComboCambiableNombreLocalidadDropDown(Sender: TObject);
    procedure ComboCambiableNombreProvinciaDropDown(Sender: TObject);

    procedure DBGrid1TitleClick(Column: TColumn);

    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);

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

  procedure ShowFormlistaclientes;
  
Var
  FLClientes: TFLClientes;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

Uses
  Global, Funciones, uFLXExportGrid;


procedure TFLClientes.ConfigurarBoton(ABoton: TBitBtn;
  const ACaption, AHint: String; AColor: TColor);
begin
  if not Assigned(ABoton) then Exit;
  ABoton.Caption := ACaption;
  ABoton.Hint := AHint;
  ABoton.ShowHint := True;
  ABoton.Color := AColor;
  ABoton.Font.Name := 'Sans';
  ABoton.Font.Height := -14;
  ABoton.Font.Color := RGBToColor(24, 36, 48);
  ABoton.Font.Style := [fsBold];
  ABoton.Glyph.Clear;
  ABoton.Layout := blGlyphLeft;
  ABoton.Margin := 8;
  ABoton.Spacing := 8;
  ABoton.Visible := True;
  ABoton.BringToFront;
end;

procedure TFLClientes.ConfigurarGrid(AGrid: TDBGrid);
begin
  if not Assigned(AGrid) then Exit;
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

procedure TFLClientes.AplicarContrasteSeleccion(AControl: TWinControl);
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

procedure TFLClientes.AplicarContrasteSeleccionControles(AParent: TWinControl);
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

procedure TFLClientes.ConfigurarControlesRecursivo(AParent: TWinControl);
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
      { Estos labels conservan el estilo específico del formulario. }
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

procedure TFLClientes.AplicarDisenoModerno;
var
  Paneles: array[0..7] of TPanel;
  I: Integer;
begin
  Caption := 'Listados y análisis de clientes';
  WindowState := wsMaximized;
  Position := poScreenCenter;
  KeyPreview := True;
  Color := RGBToColor(242, 246, 249);
  Font.Name := 'Sans';
  Font.Height := -13;
  Constraints.MinWidth := 1120;
  Constraints.MinHeight := 760;
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
  FLabelCabTitulo.Caption := 'LISTADOS Y ANÁLISIS DE CLIENTES';
  FLabelCabTitulo.AutoSize := False;
  FLabelCabTitulo.Font.Name := 'Sans';
  FLabelCabTitulo.Font.Height := -22;
  FLabelCabTitulo.Font.Style := [fsBold];
  FLabelCabTitulo.Font.Color := clWhite;
  FLabelCabTitulo.Transparent := True;

  FLabelCabSubtitulo := TLabel.Create(Self);
  FLabelCabSubtitulo.Parent := FPanelCabecera;
  FLabelCabSubtitulo.Caption :=
    'Seleccione el tipo de informe, defina sus filtros y consulte el resultado.';
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
  RadioButton6.Parent := FPanelTipos;
  RadioButton7.Parent := FPanelTipos;
  RadioButton8.Parent := FPanelTipos;
  RadioButton9.Parent := FPanelTipos;
  RadioButton11.Parent := FPanelTipos;
  RadioButton10.Parent := FPanelTipos;

  RadioButton1.Caption := 'Datos personales y direcciones';
  RadioButton2.Caption := 'Etiquetas de clientes';
  RadioButton3.Caption := 'Créditos detallados';
  RadioButton4.Caption := 'Créditos agrupados';
  RadioButton5.Caption := 'Créditos por localidad, provincia o ruta';
  RadioButton6.Caption := 'Préstamos';
  RadioButton7.Caption := 'Riesgo máximo';
  RadioButton8.Caption := 'Descuentos comerciales';
  RadioButton9.Caption := 'Albaranes de clientes';
  RadioButton11.Caption := 'Facturas de clientes';
  RadioButton10.Caption := 'Estadísticas de ventas';

  PanelDesdeHasta.Parent := FPanelFiltros;
  PanelCambiableRuta.Parent := FPanelFiltros;
  PanelCambiableProvincia.Parent := FPanelFiltros;
  PanelCambiableLocalidad.Parent := FPanelFiltros;
  PanelFechaDesdeHasta.Parent := FPanelFiltros;
  PanelVendedor.Parent := FPanelFiltros;
  PanelRiesgoMax.Parent := FPanelFiltros;
  PanelSelectAno.Parent := FPanelFiltros;

  Paneles[0] := PanelDesdeHasta;
  Paneles[1] := PanelCambiableRuta;
  Paneles[2] := PanelCambiableProvincia;
  Paneles[3] := PanelCambiableLocalidad;
  Paneles[4] := PanelFechaDesdeHasta;
  Paneles[5] := PanelVendedor;
  Paneles[6] := PanelRiesgoMax;
  Paneles[7] := PanelSelectAno;
  for I := Low(Paneles) to High(Paneles) do
  begin
    Paneles[I].Caption := '';
    Paneles[I].BevelOuter := bvNone;
    Paneles[I].Color := RGBToColor(236, 244, 250);
  end;
  PanelDesdeHasta.Color := RGBToColor(245, 248, 251);
  PanelFechaDesdeHasta.Color := RGBToColor(239, 247, 241);
  PanelRiesgoMax.Color := RGBToColor(255, 247, 225);
  PanelSelectAno.Color := RGBToColor(248, 241, 252);

  Label2.Caption := 'Código inicial';
  Label1.Caption := 'Código final';
  Label3.Caption := 'Nombre inicial';
  Label4.Caption := 'Nombre final';
  Label10.Caption := 'Fecha inicial';
  Label11.Caption := 'Fecha final';
  LabelVendedor.Caption := 'Vendedor';
  LabelPendFacutar.Caption := 'Pendiente de facturar <=';
  LabelEntreCuenta.Caption := 'Entregas a cuenta >=';
  LabelRiesgoMax.Caption := 'Riesgo máximo >';
  Label6.Caption := 'Ejercicio';
  Label7.Caption := 'Mes inicial';
  Label8.Caption := 'Mes final';

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
    'Generar y mostrar el listado con los filtros seleccionados',
    RGBToColor(166, 214, 181));
  ConfigurarBoton(BitBtn2, 'Informe original',
    'Abrir el informe original correspondiente al listado actual',
    RGBToColor(184, 218, 244));

  FBtnGuardarPDF := TBitBtn.Create(Self);
  FBtnGuardarPDF.Name := 'BtnGuardarPDF';
  FBtnGuardarPDF.Parent := Panel1;
  FBtnGuardarPDF.OnClick := @GuardarPDFClick;
  ConfigurarBoton(FBtnGuardarPDF, 'Guardar PDF',
    'Guardar el listado visible como un PDF nuevo e independiente',
    RGBToColor(199, 224, 246));

  FBtnPrevisualizarPDF := TBitBtn.Create(Self);
  FBtnPrevisualizarPDF.Name := 'BtnPrevisualizarPDF';
  FBtnPrevisualizarPDF.Parent := Panel1;
  FBtnPrevisualizarPDF.OnClick := @PrevisualizarPDFClick;
  ConfigurarBoton(FBtnPrevisualizarPDF, 'Previsualizar PDF',
    'Generar un PDF temporal y abrirlo en el visor predeterminado',
    RGBToColor(210, 228, 247));

  FBtnImprimirPDF := TBitBtn.Create(Self);
  FBtnImprimirPDF.Name := 'BtnImprimirPDF';
  FBtnImprimirPDF.Parent := Panel1;
  FBtnImprimirPDF.OnClick := @ImprimirPDFClick;
  ConfigurarBoton(FBtnImprimirPDF, 'Imprimir PDF',
    'Generar el PDF y enviarlo a la impresora predeterminada',
    RGBToColor(218, 231, 244));

  FBtnExportarCSV := TBitBtn.Create(Self);
  FBtnExportarCSV.Name := 'BtnExportarCSV';
  FBtnExportarCSV.Parent := Panel1;
  FBtnExportarCSV.OnClick := @ExportarCSVClick;
  ConfigurarBoton(FBtnExportarCSV, 'Exportar CSV',
    'Guardar las columnas visibles en un archivo CSV UTF-8',
    RGBToColor(210, 232, 216));

  ConfigurarBoton(BitBtn3, 'Nueva consulta',
    'Volver a los filtros para preparar otro listado',
    RGBToColor(255, 224, 166));
  ConfigurarBoton(BitBtn4, 'Cerrar',
    'Cerrar el formulario de listados de clientes',
    RGBToColor(238, 190, 190));
  ConfigurarBoton(BitBtnCambiableRuta, '...',
    'Buscar y seleccionar una ruta o distintivo',
    RGBToColor(184, 218, 244));

  PanelTituloGrid.Visible := False;

  ConfigurarGrid(DBGrid1);
  ConfigurarGrid(DBGrid3);
  ConfigurarGrid(DBGrid4);
  ConfigurarGrid(DBGrid5);
  ConfigurarGrid(DBGrid6);
  ConfigurarGrid(DBGrid7);
  ConfigurarGrid(DBGrid8);
  ConfigurarGrid(DBGrid9);
  ConfigurarGrid(DBGrid10);
  ConfigurarGrid(DBGrid11);

  DBGrid1.OnTitleClick := @DBGrid1TitleClick;
  DBGrid3.OnTitleClick := @DBGrid3TitleClick;
  DBGrid4.OnTitleClick := @DBGrid4TitleClick;
  DBGrid5.OnTitleClick := @DBGrid5TitleClick;
  DBGrid6.OnTitleClick := @DBGrid6TitleClick;
  DBGrid7.OnTitleClick := @DBGrid7TitleClick;
  DBGrid8.OnTitleClick := @DBGrid8TitleClick;
  DBGrid9.OnTitleClick := @DBGrid9TitleClick;
  DBGrid10.OnTitleClick := @DBGrid10TitleClick;
  DBGrid11.OnTitleClick := @DBGrid11TitleClick;

  ConfigurarControlesRecursivo(Self);
  FEnResultados := False;
  RecolocarControles;
end;

procedure TFLClientes.RecolocarControles;
var
  W, H, CabeceraH, BarraH, Margen, ConfigTop, ConfigH: Integer;
  TiposW, PanelW, I, RadioTop: Integer;
  BotonW, BotonH, Separacion, TotalBotonesW, BotonX: Integer;
  Radios: array[0..10] of TRadioButton;
  Botones: array[0..7] of TBitBtn;
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
  if ConfigH < 560 then ConfigH := 560;
  FPanelConfiguracion.SetBounds(Margen, ConfigTop, W - (Margen * 2), ConfigH);

  TiposW := 390;
  if FPanelConfiguracion.Width < 1080 then TiposW := 350;
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
  Radios[5] := RadioButton6;
  Radios[6] := RadioButton7;
  Radios[7] := RadioButton8;
  Radios[8] := RadioButton9;
  Radios[9] := RadioButton11;
  Radios[10] := RadioButton10;
  RadioTop := 58;
  for I := Low(Radios) to High(Radios) do
  begin
    Radios[I].SetBounds(22, RadioTop + (I * 40),
      FPanelTipos.Width - 44, 28);
    Radios[I].BringToFront;
  end;

  PanelW := FPanelFiltros.Width - 36;

  PanelDesdeHasta.SetBounds(18, 72, PanelW, 142);
  Label2.SetBounds(16, 19, 105, 22);
  Edit1.SetBounds(130, 14, 135, 30);
  Label1.SetBounds(300, 19, 105, 22);
  Edit2.SetBounds(415, 14, 135, 30);
  Label3.SetBounds(16, 64, 105, 22);
  Edit3.SetBounds(130, 59, PanelW - 150, 30);
  Label4.SetBounds(16, 109, 105, 22);
  Edit4.SetBounds(130, 104, PanelW - 150, 30);

  PanelCambiableRuta.SetBounds(18, 226, PanelW, 54);
  LabelCambiableRuta.SetBounds(16, 17, 105, 22);
  EditCambiableCodigoRuta.SetBounds(130, 12, 120, 30);
  BitBtnCambiableRuta.SetBounds(260, 11, 42, 32);
  StaticTextCambiableNombreRuta.SetBounds(312, 12, PanelW - 328, 30);
  ComboCambiableNombreRuta.SetBounds(312, 12, PanelW - 328, 30);

  PanelCambiableProvincia.SetBounds(18, 290, PanelW, 54);
  LabelCambiableProvincia.SetBounds(16, 17, 105, 22);
  ComboCambiableNombreProvincia.SetBounds(130, 12, PanelW - 146, 30);

  PanelCambiableLocalidad.SetBounds(18, 354, PanelW, 54);
  LabelCambiableLocalidad.SetBounds(16, 17, 105, 22);
  ComboCambiableNombreLocalidad.SetBounds(130, 12, PanelW - 146, 30);

  PanelFechaDesdeHasta.SetBounds(18, 418, PanelW, 58);
  Label10.SetBounds(16, 20, 95, 22);
  DateEditDesde.SetBounds(118, 14, 165, 32);
  Label11.SetBounds(315, 20, 90, 22);
  DateEditHasta.SetBounds(412, 14, 165, 32);

  PanelVendedor.SetBounds(18, 486, PanelW, 54);
  LabelVendedor.SetBounds(16, 17, 95, 22);
  EditCodVendedor.SetBounds(118, 12, 100, 30);

  PanelRiesgoMax.SetBounds(18, 226, 440, 116);
  LabelPendFacutar.SetBounds(16, 15, 185, 22);
  EditPendFacturar.SetBounds(215, 10, 110, 30);
  LabelEntreCuenta.SetBounds(16, 50, 185, 22);
  EditEntregasCuenta.SetBounds(215, 45, 110, 30);
  LabelRiesgoMax.SetBounds(16, 85, 185, 22);
  EditRiesgoMaximo.SetBounds(215, 80, 110, 30);

  PanelSelectAno.SetBounds(18, 418, PanelW, 122);
  Label6.SetBounds(18, 14, 95, 22);
  ListBoxAnos.SetBounds(18, 40, 120, 72);
  Label7.SetBounds(175, 52, 90, 22);
  Edit7.SetBounds(270, 47, 70, 30);
  Label8.SetBounds(380, 52, 85, 22);
  Edit8.SetBounds(470, 47, 70, 30);

  PanelTituloGrid.Align := alNone;
  PanelTituloGrid.SetBounds(Margen, CabeceraH + 12, W - (Margen * 2), 44);
  LabelTituloDBGrid.SetBounds(12, 10, PanelTituloGrid.Width - 24, 25);
  DimensionarColocarBDGrid;
end;

procedure TFLClientes.MostrarZonaFiltros;
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

procedure TFLClientes.MostrarZonaResultados;
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

procedure TFLClientes.ActualizarFlechaOrdenacion(AGrid: TDBGrid;
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

procedure TFLClientes.GridDrawColumnCell(Sender: TObject;
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


function TFLClientes.GridResultadoVisible: TDBGrid;
begin
  Result := nil;
  if DBGrid1.Visible then Result := DBGrid1
  else if DBGrid3.Visible then Result := DBGrid3
  else if DBGrid4.Visible then Result := DBGrid4
  else if DBGrid5.Visible then Result := DBGrid5
  else if DBGrid6.Visible then Result := DBGrid6
  else if DBGrid7.Visible then Result := DBGrid7
  else if DBGrid8.Visible then Result := DBGrid8
  else if DBGrid9.Visible then Result := DBGrid9
  else if DBGrid10.Visible then Result := DBGrid10
  else if DBGrid11.Visible then Result := DBGrid11;
end;

procedure TFLClientes.PrepararCabeceraExportacion(ACabecera: TStrings);
var
  Grid: TDBGrid;
begin
  if not Assigned(ACabecera) then Exit;
  ACabecera.Clear;
  if Empresa <> '' then ACabecera.Add('Empresa: ' + Empresa);
  if TituloGrid <> '' then ACabecera.Add('Listado: ' + TituloGrid);
  Grid := GridResultadoVisible;
  if Assigned(Grid) and Assigned(Grid.DataSource) and
     Assigned(Grid.DataSource.DataSet) and Grid.DataSource.DataSet.Active then
    ACabecera.Add('Registros: ' + IntToStr(Grid.DataSource.DataSet.RecordCount));
  ACabecera.Add('Generado: ' + FormatDateTime('dd/mm/yyyy hh:nn', Now));
end;

function TFLClientes.GenerarPDFTemporal(out AFileName: String): Boolean;
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
    'facturlinex_clientes_' + FormatDateTime('yyyymmdd_hhnnss_zzz', Now) + '.pdf';
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

procedure TFLClientes.GuardarPDFClick(Sender: TObject);
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
    Dialogo.Title := 'Guardar listado de clientes en PDF';
    Dialogo.Filter := 'Documento PDF (*.pdf)|*.pdf';
    Dialogo.DefaultExt := 'pdf';
    Dialogo.FileName := 'Listado_clientes_' + FormatDateTime('yyyymmdd', Date) + '.pdf';
    Dialogo.Options := Dialogo.Options + [ofOverwritePrompt];
    if not Dialogo.Execute then Exit;
    PrepararCabeceraExportacion(Cabecera);
    try
      ExportarGridAPDF(Grid, Dialogo.FileName, TituloGrid, Cabecera);
      ShowMessage('PDF guardado correctamente en:' + LineEnding + Dialogo.FileName);
    except
      on E: Exception do
        ShowMessage('No se pudo guardar el PDF: ' + E.Message);
    end;
  finally
    Cabecera.Free;
    Dialogo.Free;
  end;
end;

procedure TFLClientes.PrevisualizarPDFClick(Sender: TObject);
var
  Archivo, Mensaje: String;
begin
  if not GenerarPDFTemporal(Archivo) then Exit;
  if not PrevisualizarPDFPredeterminado(Archivo, Mensaje) then
    ShowMessage(Mensaje);
end;

procedure TFLClientes.ImprimirPDFClick(Sender: TObject);
var
  Archivo, Mensaje: String;
begin
  if not GenerarPDFTemporal(Archivo) then Exit;
  ImprimirPDFPredeterminado(Archivo, Mensaje);
  ShowMessage(Mensaje);
end;

procedure TFLClientes.ExportarCSVClick(Sender: TObject);
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
    Dialogo.Title := 'Exportar listado de clientes a CSV';
    Dialogo.Filter := 'Archivo CSV (*.csv)|*.csv';
    Dialogo.DefaultExt := 'csv';
    Dialogo.FileName := 'Listado_clientes_' + FormatDateTime('yyyymmdd', Date) + '.csv';
    Dialogo.Options := Dialogo.Options + [ofOverwritePrompt];
    if not Dialogo.Execute then Exit;
    try
      ExportarGridACSV(Grid, Dialogo.FileName);
      ShowMessage('CSV guardado correctamente en:' + LineEnding + Dialogo.FileName);
    except
      on E: Exception do
        ShowMessage('No se pudo exportar el CSV: ' + E.Message);
    end;
  finally
    Dialogo.Free;
  end;
end;

procedure TFLClientes.AplicarFocoInicial(Data: PtrInt);
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

procedure TFLClientes.FormularioKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then Exit;
  Key := 0;
  if FEnResultados then
    BitBtn3Click(BitBtn3)
  else
    BitBtn4Click(BitBtn4);
end;

procedure TFLClientes.FormularioResize(Sender: TObject);
begin
  RecolocarControles;
end;

//=============== Crea el formulario ================
procedure ShowFormlistaclientes;
begin
  with TFLClientes.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLClientes.Formcreate(Sender: Tobject);

Begin
    //Conectate(dbConect);         // Utilizamos datamodule1.dbConexión para toda la aplicación.

  //---------------------Paneles visibles por defecto, los de RadioButton1Change
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=False;

   LabelCambiableRuta.Caption:='Ruta/Distintivo';
   EditCambiableCodigoRuta.Text:='';
   StaticTextCambiableNombreRuta.Caption:='';
   LabelCambiableProvincia.Caption:='Provincia';
   LabelCambiableLocalidad.Caption:='Localidad';

   DateEditDesde.Date:=StrToDate('01/01/'+FormatDateTime('YYYY',Date));
   DateEditHasta.Date:=Date;
   BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;

  AplicarDisenoModerno;

  // Ocultamos todos los DBGrid
  DimensionarColocarBDGrid();
  OcultarBDGrid();
End;

//==================== CERRAR ======================
procedure TFLClientes.BitBtn4Click(Sender: TObject);
begin
  dbQuery.Active:=False;
  Close();
end;

// --------Formateo de fechas entrantes
procedure TFLClientes.DateEditDesdeExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditDesde.text) Then
     begin
       DateEditDesde.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

procedure TFLClientes.DateEditHastaExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditHasta.text) Then
     begin
       DateEditHasta.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

Procedure TFLClientes.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//==================== VISUALIZAR ===================
procedure TFLClientes.BitBtn1Click(Sender: TObject);
Var
  TxtQuery: String;
begin
  AntColun:='0';Ordenado:=False;
  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  //-------------------------- DATOS PERSONALES (DIRECCIONES) Y ETIQUETAS
  if (RadioButton1.Checked=True) or (RadioButton2.Checked=True) then
    begin
     TituloGrid:='LISTADO DE DATOS PERSONALES (DIRECCIONES)';
     TxtQuery:='SELECT C0, C1, C3, C4, C5, C6, C37, C38 from clientes WHERE';
     if EditCambiableCodigoRuta.Text<>'' then
      TxtQuery:=TxtQuery + ' C10 >= "'+EditCambiableCodigoRuta.Text+'" AND';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
     TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     if EditCambiableCodigoRuta.Text<>'' then TituloGrid:=TituloGrid +' DE LA RUTA '+StaticTextCambiableNombreRuta.Caption;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
    end;
  //-------------------------- CREDITOS
  if RadioButton3.Checked=True then
    begin
     TituloGrid:='LISTADO DE CREDITOS';
     TxtQuery:='SELECT C0, C1, C10 ,CRE1, CRE2, CRE3, CRE10, HO11, HO12, CRE7, CRE8 from clientes, creditos'+Tienda+', hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' C0=CRE0 AND HO0=CRE1 AND HO1=CRE2 AND HO4=CRE4 AND HO3=CRE5 AND';
     if EditCambiableCodigoRuta.Text<>'' then
      TxtQuery:=TxtQuery + ' C10 >= "'+EditCambiableCodigoRuta.Text+'" AND';
     if EditCodVendedor.Text<>'' then
      TxtQuery:=TxtQuery + ' CRE10 >= "'+EditCodVendedor.Text+'" AND';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
      TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
      TxtQuery:=TxtQuery + ' AND CRE1>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND CRE1<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C10, C0';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     TituloGrid:=TituloGrid+' ENTRE EL '+FormatDateTime('DD-MM-YYYY',DateEditDesde.Date)+
        ' Y EL '+FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);
     DBGrid3.BringToFront; DBGrid3.Visible:=True;
    end;
  //-------------------------- CREDITOS AGUPADOS
  if RadioButton4.Checked=True then
    begin
     TituloGrid:='LISTADO DE CREDITOS AGRUPADOS';
     TxtQuery:='SELECT C10, C0, C1, SUM(HO11) as ImporteTotal, SUM(CRE7) as Debe, SUM(CRE8) as Haber from clientes, creditos'+Tienda+', hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' C0=CRE0 AND HO0=CRE1 AND HO1=CRE2 AND HO4=CRE4 AND HO3=CRE5 AND';
     if EditCambiableCodigoRuta.Text<>'' then
      TxtQuery:=TxtQuery + ' C10 >= "'+EditCambiableCodigoRuta.Text+'" AND';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
      TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
      TxtQuery:=TxtQuery + ' AND CRE1>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND CRE1<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"';
     TxtQuery:=TxtQuery + ' GROUP BY C0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C10, C0';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     TituloGrid:=TituloGrid+' ENTRE EL '+FormatDateTime('DD-MM-YYYY',DateEditDesde.Date)+
        ' Y EL '+FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);
     DBGrid4.BringToFront; DBGrid4.Visible:=True;
    end;
  //----------- Créditos por Localidad, Provincia o Ruta
  if RadioButton5.Checked=True then
    begin
     TituloGrid:='LISTADO DE CREDITOS POR LOCALIDAD, PROVINCIA O RUTA';
     TxtQuery:='SELECT C10, C0, C1, C3, C4, C38, C44, C45, SUM(CRE7) as Debe, SUM(CRE8) as Haber from clientes, creditos'+Tienda+' WHERE C0=CRE0 AND';
     if EditCambiableCodigoRuta.Text<>'' then
      TxtQuery:=TxtQuery + ' C10 >= "'+EditCambiableCodigoRuta.Text+'" AND';
     if ComboCambiableNombreProvincia.Text<>'' then
      TxtQuery:=TxtQuery + ' C38 = "'+ComboCambiableNombreProvincia.Text+'" AND';
     if ComboCambiableNombreLocalidad.Text<>'' then
      TxtQuery:=TxtQuery + ' C4 = "'+ComboCambiableNombreLocalidad.Text+'" AND';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
      TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     TxtQuery:=TxtQuery + ' GROUP BY C0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C10, C0';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid5.BringToFront; DBGrid5.Visible:=True;
    end;
  //-------------------------- Prestamos // De momento es igual que créditos, según Nico sale de esta misma tabla pero no se como
  if RadioButton6.Checked=True then
    begin
     TituloGrid:='LISTADO DE PRESTAMO';
     TxtQuery:='SELECT C0, C1, C10 ,CRE1, CRE2, CRE3, HO11, HO12, CRE7, CRE8 from clientes, creditos'+Tienda+', hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' C0=CRE0 AND HO0=CRE1 AND HO1=CRE2 AND HO4=CRE4 AND HO3=CRE5 AND';
     if EditCambiableCodigoRuta.Text<>'' then
      TxtQuery:=TxtQuery + ' C10 >= "'+EditCambiableCodigoRuta.Text+'" AND';
     if EditCodVendedor.Text<>'' then
      TxtQuery:=TxtQuery + ' CRE10 >= "'+EditCodVendedor.Text+'" AND';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
      TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
      TxtQuery:=TxtQuery + ' AND CRE1>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND CRE1<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C10, C0';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     TituloGrid:=TituloGrid+' ENTRE EL '+FormatDateTime('DD-MM-YYYY',DateEditDesde.Date)+
        ' Y EL '+FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);
     DBGrid6.BringToFront; DBGrid6.Visible:=True;
    end;
//--------------------------- Listado de Riesgo máximo
  if RadioButton7.Checked=True then
    begin
     TituloGrid:='LISTADO DE RIESGO MAXIMO';
     TxtQuery:='SELECT C0, C1, C20, C21, C22 from clientes WHERE';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
     if EsFloat(EditPendFacturar.Text) then   // Pendiente de facturacion es un valor negativo
      TxtQuery:=TxtQuery + ' C20 <= "'+EditPendFacturar.Text+'" AND';
     if EsFloat(EditEntregasCuenta.Text) then
      TxtQuery:=TxtQuery + ' C21 >= "'+EditEntregasCuenta.Text+'" AND';
     if EsFloat(EditRiesgoMaximo.Text) then   // 0 por defecto, los clientes con riesgo 0 no salen
      TxtQuery:=TxtQuery + ' C22 > "'+EditRiesgoMaximo.Text+'" AND';
     TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C1';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid7.BringToFront; DBGrid7.Visible:=True;
    end;
//--------------------------- Listado de Riesgo máximo
  if RadioButton8.Checked=True then
    begin
     TituloGrid:='LISTADO DE DESCUENTOS';
     TxtQuery:='SELECT C0, C1, C6, C16, C17, C18, C19, C22 from clientes WHERE';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
     TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C1';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid8.BringToFront; DBGrid8.Visible:=True;
    end;
  //-------------------------- LISTADOS DE ALBARANES PENDIENES
  if RadioButton9.Checked=True then
    begin
     TituloGrid:='LISTADO DE ALBARANES PENDIENES';
     TxtQuery:='SELECT C0, C1, C10 ,AC1, AC3, AC4, AC5, AC6, AC7, AC8, AC9 from clientes, albac'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' C0=AC0 AND';
     if EditCambiableCodigoRuta.Text<>'' then
      TxtQuery:=TxtQuery + ' C10 >= "'+EditCambiableCodigoRuta.Text+'" AND';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
      TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
      TxtQuery:=TxtQuery + ' AND AC1>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND AC1<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C10, C0';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     TituloGrid:=TituloGrid+' ENTRE EL '+FormatDateTime('DD-MM-YYYY',DateEditDesde.Date)+
        ' Y EL '+FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);
     DBGrid9.BringToFront; DBGrid9.Visible:=True;
    end;

  //-------------------------- LISTADOS DE Facturas
  if RadioButton11.Checked=True then
    begin
     TituloGrid:='LISTADO DE Facturas';
     TxtQuery:='SELECT C0, C1, C10 ,FC1, FC3, FC4, FC5, FC6, FC7, FC8, FC9 from clientes, factuc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' C0=FC0 AND';
     if EditCambiableCodigoRuta.Text<>'' then
      TxtQuery:=TxtQuery + ' C10 >= "'+EditCambiableCodigoRuta.Text+'" AND';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
      TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
      TxtQuery:=TxtQuery + ' AND FC1>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND FC1<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C10, C0';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     TituloGrid:=TituloGrid+' ENTRE EL '+FormatDateTime('DD-MM-YYYY',DateEditDesde.Date)+
        ' Y EL '+FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);
     DBGrid11.BringToFront; DBGrid11.Visible:=True;
    end;


  //-------------------------- ESTADISTICAS DE VENTAS
  if RadioButton10.Checked=True then
    begin
     if dbAnos.RecordCount=0 then begin showmessage('NO HAY DATOS PARA VISUALIZAR'); exit; end;
     TituloGrid:='LISTADO DE ESTADISTICAS DE VENTAS';
     TxtQuery:='SELECT C0,C1,SUM(CC5) AS UNIVND,SUM(CC6) AS IMPUNIVND,SUM(CC7) AS IMPVENCOST,SUM(CC6-CC7) AS BENEF '+
     'from clientes,estaclie WHERE';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
     TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     TxtQuery:=TxtQuery +' AND CC1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+' AND CC2>='+
     Edit7.Text+' AND CC2<='+Edit8.Text+' AND C0=CC0 GROUP BY C0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     DBGrid10.BringToFront; DBGrid10.Visible:=True;
    end;
  LabelTituloDBGrid.Caption:=TituloGrid;
  if DBGrid1.Visible or DBGrid3.Visible or DBGrid4.Visible or
     DBGrid5.Visible or DBGrid6.Visible or DBGrid7.Visible or
     DBGrid8.Visible or DBGrid9.Visible or DBGrid10.Visible or
     DBGrid11.Visible then
    MostrarZonaResultados;
  //WriteLn(TxtQuery);
end;

//==================== SELECCIONAR ===================
procedure TFLClientes.BitBtn3Click(Sender: TObject);
begin
  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
  MostrarZonaFiltros;
end;

//==================== IMPRIMIR ===================
procedure TFLClientes.BitBtn2Click(Sender: TObject);
begin
  //-------------------------- Datos Personales (Direcciones)
  if (RadioButton1.Checked=True) then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesDirec.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Etiquetas
  if RadioButton2.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesEtiquetas.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Listado de Créditos
  if RadioButton3.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesCreditos.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Listado de Créditos Agrupados
  if RadioButton4.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesCredAgrup.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Listado de Créditos por Localidades
  if RadioButton5.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesCredLocalid.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Listado de Créditos por Riesgo Máximo
  if RadioButton7.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesRiesgMax.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Listado de Créditos Descuentos
  if RadioButton8.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesDescuentos.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Listado de Créditos Albaranes
  if RadioButton9.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesAlbaranes.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Listado de Facturas
  if RadioButton11.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesFacturas.lrf');
     frReport1.ShowReport;
    end;
  if RadioButton10.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesEsta.lrf');
     frReport1.ShowReport;
    end;
end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLClientes.frReport1GetValue(const ParName: String;
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
procedure TFLClientes.frReport1EnterRect(Memo: TStringList; View: TfrView);
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

//---------- Datos Generales
procedure TFLClientes.RadioButton1Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
//---------- Etiquetas
procedure TFLClientes.RadioButton2Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
//---------- Creditos
procedure TFLClientes.RadioButton3Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=True;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
//---------- Creditos Agrupados
procedure TFLClientes.RadioButton4Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
//----------- Clientes por Localidad, Provincia o Ruta
procedure TFLClientes.RadioButton5Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=True;
   PanelCambiableLocalidad.Visible:=True;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
//---------- Prestamos
procedure TFLClientes.RadioButton6Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=True;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
//---------- Listado de Riesgo Maximo
procedure TFLClientes.RadioButton7Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiableRuta.Visible:=False;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=True;
   OcultarBDGrid();
end;
//---------- Listado de Descuentos
procedure TFLClientes.RadioButton8Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiableRuta.Visible:=False;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
procedure TFLClientes.RadioButton9Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
//---------- Estadisticas de cliente
procedure TFLClientes.RadioButton10Change(Sender: TObject);
begin
  if RadioButton10.Checked=True then RellenaListBoxAnos('SELECT DISTINCT(CC1) FROM estaclie',dbAnos, PanelSelectAno, ListBoxAnos)
  else PanelSelectAno.Visible:=False;
  PanelDesdeHasta.Visible:=True;
  PanelFechaDesdeHasta.Visible:=False;
  OcultarBDGrid();
end;

procedure TFLClientes.RadioButton11Change(Sender: TObject);
begin
  PanelDesdeHasta.Visible:=True;
  PanelSelectAno.Visible:=False;
  PanelFechaDesdeHasta.Visible:=True;
  PanelCambiableRuta.Visible:=True;
  PanelCambiableProvincia.Visible:=False;
  PanelCambiableLocalidad.Visible:=False;
  PanelVendedor.Visible:=False;
  PanelRiesgoMax.Visible:=False;
  OcultarBDGrid();
end;

// ====================== Redimensiona y Coloca Todos los DBGrid
procedure TFLClientes.DimensionarColocarBDGrid();
var
  Margen, ResultadoTop, ResultadoH, W: Integer;
  procedure ColocarGrid(AGrid: TDBGrid);
  begin
    AGrid.Align := alNone;
    AGrid.SetBounds(Margen, ResultadoTop, W - (Margen * 2), ResultadoH);
  end;
begin
  Margen := 18;
  W := ClientWidth;
  ResultadoTop := 150;
  ResultadoH := ClientHeight - ResultadoTop - 96;
  if ResultadoH < 260 then ResultadoH := 260;
  ColocarGrid(DBGrid1);
  ColocarGrid(DBGrid3);
  ColocarGrid(DBGrid4);
  ColocarGrid(DBGrid5);
  ColocarGrid(DBGrid6);
  ColocarGrid(DBGrid7);
  ColocarGrid(DBGrid8);
  ColocarGrid(DBGrid9);
  ColocarGrid(DBGrid10);
  ColocarGrid(DBGrid11);
end;

//======================= OCULTA TODOS LOS DBGird
procedure TFLClientes.OcultarBDGrid();
  begin
    LabelTituloDBGrid.Caption:='';
    DBGrid1.Visible:=False; DBGrid3.Visible:=False; DBGrid4.Visible:=False;
    DBGrid5.Visible:=False; DBGrid6.Visible:=False; DBGrid7.Visible:=False;
    DBGrid8.Visible:=False; DBGrid9.Visible:=False; DBGrid10.Visible:=False;
    DBGrid11.Visible:=False;
  end;


//======================== Metodos de los Paneles Cambiables
procedure TFLClientes.ComboCambiableNombreRutaClick(Sender: TObject);
begin
  EscogeNombreComboCambiable('RUT1', ComboCambiableNombreRuta, dbCambiable, EditCambiableCodigoRuta, StaticTextCambiableNombreRuta)
end;

procedure TFLClientes.ComboCambiableNombreRutaKeyPress(Sender: TObject;
  var Key: char);
begin
  if key=#13 then ComboCambiableNombreRutaClick(ComboCambiableNombreRuta);
end;

//======================= Despues de introducir un codigo, al salir, si existe,
//======================= completa el StaticText con el nombre oportuno
procedure TFLClientes.EditCambiableCodigoRutaExit(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT RUT1 FROM rutas WHERE RUT0="'+EditCambiableCodigoRuta.Text+'"';
  if EditCambiableCodigoRuta.Text<>'' then
    begin
     RellenaPanelCambiableN(TxtQuery,dbCambiable, StaticTextCambiableNombreRuta);
     if dbCambiable.RecordCount=0 then
       begin
         Showmessage('NO HAY '+LabelCambiableRuta.Caption+' CON ESE CODIGO');
         EditCambiableCodigoRuta.Text:='';
         exit;
       end;
    end;
end;

procedure TFLClientes.EditCambiableCodigoRutaEnter(Sender: TObject);
begin
  StaticTextCambiableNombreRuta.Caption:='';
end;

//procedure TFLClientes.EditCambiableCodigo2Enter(Sender: TObject);
//begin
  //StaticTextCambiableNombre2.Caption:='';
//end;
//procedure TFLClientes.EditCambiableCodigo3Enter(Sender: TObject);
//begin
  //StaticTextCambiableNombre3.Caption:='';
//end;
//========= Botones de carga de los paneles cambiables
procedure TFLClientes.BitBtnCambiableRutaClick(Sender: TObject);
var
 TxtQuery: String;
begin
 TxtQuery:='SELECT RUT0, RUT1 FROM rutas'+Tienda+' ORDER BY RUT1';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombreRuta, dbCambiable, LabelCambiableRuta);
end;

procedure TFLClientes.ComboCambiableNombreLocalidadDropDown(Sender: TObject);
var
 TxtQuery: String;
begin //Que se repita C4 solo obedece a la compatibilidad con la función CargaValoresEnComboCambiable
 TxtQuery:='SELECT DISTINCT C4, C4 FROM clientes WHERE C4<>"" ORDER BY C4';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombreLocalidad, dbCambiable, LabelCambiableLocalidad);
end;

procedure TFLClientes.ComboCambiableNombreProvinciaDropDown(Sender: TObject);
var
 TxtQuery: String;
begin //Que se repita C38 solo obedece a la compatibilidad con la función CargaValoresEnComboCambiable
 TxtQuery:='SELECT DISTINCT C38, C38 FROM clientes WHERE C38<>"" ORDER BY C38';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombreProvincia, dbCambiable, LabelCambiableProvincia);
end;

//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLClientes.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid1, Column);
end;
procedure TFLClientes.DBGrid10TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid10,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid10, Column);
end;
procedure TFLClientes.DBGrid3TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid3,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid3, Column);
end;
procedure TFLClientes.DBGrid4TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid4,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid4, Column);
end;
procedure TFLClientes.DBGrid5TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid5,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid5, Column);
end;
procedure TFLClientes.DBGrid6TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid6,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid6, Column);
end;
procedure TFLClientes.DBGrid7TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid7,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid7, Column);
end;
procedure TFLClientes.DBGrid8TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid8,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid8, Column);
end;
procedure TFLClientes.DBGrid9TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid9,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid9, Column);
end;
procedure TFLClientes.DBGrid11TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid11,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid11, Column);
end;


procedure TFLClientes.FormShow(Sender: TObject);
begin
  RadioButton1.Checked := True;
  RadioButton1Change(RadioButton1);
  MostrarZonaFiltros;
  RecolocarControles;
  AplicarContrasteSeleccionControles(Self);
  Application.QueueAsyncCall(@AplicarFocoInicial, 0);
end;

Initialization
  {$I listaclientes.lrs}

End.

