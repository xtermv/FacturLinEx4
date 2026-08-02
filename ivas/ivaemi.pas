{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2009,  Nicolas Lopez de Lerma Aymerich

  PuntoDev GNU S.L. <info@puntodev.com>

  Collaborators:
                 xxxxxxxxxxxxxxxxxxxxxxxxx
                 xxxxxxxxxxxxxxxxxxxxxxxxx

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

Unit ivaEmi;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class, ExtDlgs, EditBtn, Grids, uFLXExportGrid
  {$IFDEF LCLGTK2}
  , gtk2, gdk2
  {$ENDIF}
  ;

Type

  { TFLIvaEmi }

  TFLIvaEmi = Class(Tform)
    BitBtnCambiable: TBitBtn;
    ChkBoxGroup1: TCheckBox;
    ComboCambiableNombre: TComboBox;
    DataSource2: TDataSource;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    dbCambiable: TZQuery;
    DBGrid1: TDBGrid;
    DBGridIVA: TDBGrid;
    DBGridIVA1: TDBGrid;
    Edit1: TEdit;
    //Edit5: TEdit;
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
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Bevel1: TBevel;
    EditCambiableCodigo: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frDBDataSet2: TfrDBDataSet;
    frReport1: TfrReport;
    frReport2: TfrReport;
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
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label5: TLabel;
    LabelCambiable: TLabel;
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
    PanelFechaDesdeHasta: TPanel;
    PanelDesdeHasta: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    StaticTextCambiableNombre: TStaticText;
    dbIva: TZQuery;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure DBGridIVATitleClick(Column: TColumn);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);


    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    //procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
    //procedure RellenaListBoxAnos(TxtQuery: String);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    //procedure BlancoGrid(Grid: TDBGrid);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure BitBtnCambiableClick(Sender: TObject);
    procedure ComboCambiableNombreClick(Sender: TObject);
    procedure ComboCambiableNombreKeyPress(Sender: TObject; var Key: char);
    procedure EditCambiableCodigoExit(Sender: TObject);
    procedure EditCambiableCodigoEnter(Sender: TObject);

    procedure DimensionarColocarBDGrid();
    procedure OcultarBDGrid();

  Private
    FPanelFiltros: TPanel;
    FLabelSubtitulo: TLabel;
    FLabelAyuda: TLabel;
    FLabelRango: TLabel;
    FLabelPeriodo: TLabel;
    FLabelSerie: TLabel;
    FBtnInformeOriginal: TBitBtn;
    FBtnVistaPreviaPDF: TBitBtn;
    FBtnImprimirPDF: TBitBtn;
    FBtnCSV: TBitBtn;
    procedure ConfigurarApariencia;
    procedure RecolocarControles;
    procedure EstilizarControles(AParent: TWinControl);
    procedure EstilizarBoton(ABoton: TBitBtn; const ACaption, AHint: String; AColor: TColor);
    procedure AplicarContrasteSeleccion(AControl: TWinControl);
    procedure AplicarContrasteSeleccionControles(AParent: TWinControl);
    procedure ActualizarFlechaOrdenacion(AGrid: TDBGrid; AColumn: TColumn);
    function GridActivo: TDBGrid;
    function NombreBaseSalida: String;
    procedure PrepararCabeceraSalida(ALines: TStrings);
    procedure CalcularTotalesActivos(out ABase, AIva, ATotal: Double);
    procedure ActualizarBotonesSalida(AEnabled: Boolean);
    procedure MostrarInformeOriginal;
    procedure GuardarPDFActual;
    procedure PrevisualizarPDFActual;
    procedure ImprimirPDFActual;
    procedure ExportarCSVActual;
    procedure BtnInformeOriginalClick(Sender: TObject);
    procedure BtnVistaPreviaPDFClick(Sender: TObject);
    procedure BtnImprimirPDFClick(Sender: TObject);
    procedure BtnCSVClick(Sender: TObject);
  Public
    { Public Declarations }
  End;

  procedure ShowFormlistaivaEmi;
  
Var
  FLIvaEmi: TFLIvaEmi;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

uses
  Global, Funciones;


function TFLIvaEmi.GridActivo: TDBGrid;
begin
  Result := nil;
  if DBGrid1.Visible then Result := DBGrid1
  else if DBGridIVA.Visible then Result := DBGridIVA
  else if DBGridIVA1.Visible then Result := DBGridIVA1;
end;

function TFLIvaEmi.NombreBaseSalida: String;
begin
  Result := 'iva_emitido_' + FormatDateTime('yyyymmdd', DateEdit1.Date) + '_' +
    FormatDateTime('yyyymmdd', DateEdit2.Date);
end;

procedure TFLIvaEmi.CalcularTotalesActivos(out ABase, AIva, ATotal: Double);
var
  D: TDataSet;
  FBase, FIva, FTotal: TField;
  OldRecNo: Integer;
begin
  ABase := 0; AIva := 0; ATotal := 0;
  if GridActivo = nil then Exit;
  D := GridActivo.DataSource.DataSet;
  if (D = nil) or (not D.Active) then Exit;

  FBase := D.FindField('Bases');
  if FBase = nil then FBase := D.FindField('Base');
  if FBase = nil then FBase := D.FindField('TotBase');
  FIva := D.FindField('Ivas');
  if FIva = nil then FIva := D.FindField('Iva');
  if FIva = nil then FIva := D.FindField('TotIva');
  FTotal := D.FindField('Total');
  if FTotal = nil then FTotal := D.FindField('Tot');

  OldRecNo := D.RecNo;
  D.DisableControls;
  try
    D.First;
    while not D.EOF do
    begin
      if Assigned(FBase) and (not FBase.IsNull) then ABase := ABase + FBase.AsFloat;
      if Assigned(FIva) and (not FIva.IsNull) then AIva := AIva + FIva.AsFloat;
      if Assigned(FTotal) and (not FTotal.IsNull) then ATotal := ATotal + FTotal.AsFloat;
      D.Next;
    end;
  finally
    try
      if OldRecNo > 0 then D.RecNo := OldRecNo;
    except
    end;
    D.EnableControls;
  end;
end;

procedure TFLIvaEmi.PrepararCabeceraSalida(ALines: TStrings);
var
  TipoListado: String;
  BaseTotal, IvaTotal, TotalGeneral: Double;
begin
  if not Assigned(ALines) then Exit;
  ALines.Clear;
  ALines.Add(Empresa + ' - ' + Nif);
  ALines.Add(Direccion + ' - ' + CP + ' ' + Localidad);
  ALines.Add('Periodo: ' + DateEdit1.Text + ' a ' + DateEdit2.Text);
  if RadioButton1.Checked then TipoListado := RadioButton1.Caption
  else if RadioButton2.Checked then TipoListado := RadioButton2.Caption
  else if RadioButton3.Checked then TipoListado := RadioButton3.Caption
  else if RadioButton4.Checked then TipoListado := RadioButton4.Caption
  else TipoListado := RadioButton5.Caption;
  ALines.Add('Listado: ' + TipoListado);
  if RadioButton1.Checked then
    ALines.Add('Serie: ' + EditCambiableCodigo.Text + ' | Facturas: ' +
      Edit1.Text + ' a ' + Edit2.Text);
  if RadioButton2.Checked then
    if ChkBoxGroup1.Checked then ALines.Add('Presentación: agrupada por tipo de IVA')
    else ALines.Add('Presentación: detalle de operaciones');
  CalcularTotalesActivos(BaseTotal, IvaTotal, TotalGeneral);
  ALines.Add('Totales: Base ' + FormatFloat('#,##0.00', BaseTotal) +
    ' | IVA ' + FormatFloat('#,##0.00', IvaTotal) +
    ' | Total ' + FormatFloat('#,##0.00', TotalGeneral));
end;

procedure TFLIvaEmi.ActualizarBotonesSalida(AEnabled: Boolean);
begin
  BitBtn2.Enabled := AEnabled;
  if Assigned(FBtnInformeOriginal) then FBtnInformeOriginal.Enabled := AEnabled;
  if Assigned(FBtnVistaPreviaPDF) then FBtnVistaPreviaPDF.Enabled := AEnabled;
  if Assigned(FBtnImprimirPDF) then FBtnImprimirPDF.Enabled := AEnabled;
  if Assigned(FBtnCSV) then FBtnCSV.Enabled := AEnabled;
end;

procedure TFLIvaEmi.MostrarInformeOriginal;
begin
  try
    if RadioButton1.Checked then
    begin
      frDBDataSet1.DataSet := dbQuery;
      frReport1.LoadFromFile(RutaReports + 'ListadoIvaEmi.lrf');
    end
    else
    begin
      frDBDataSet1.DataSet := dbIva;
      if not ChkBoxGroup1.Checked then
        frReport1.LoadFromFile(RutaReports + 'ListadoIvaEmi2.lrf')
      else
        frReport1.LoadFromFile(RutaReports + 'ListadoIvaEmi3.lrf');
    end;
    frReport1.ShowReport;
  except
    on E: Exception do
      ShowMessage('No se pudo abrir el informe original:' + LineEnding + E.Message);
  end;
end;

procedure TFLIvaEmi.GuardarPDFActual;
var
  Dlg: TSaveDialog;
  Cabecera: TStringList;
  G: TDBGrid;
begin
  G := GridActivo;
  if (G = nil) or (G.DataSource = nil) or (G.DataSource.DataSet = nil) or
     (not G.DataSource.DataSet.Active) or G.DataSource.DataSet.IsEmpty then
  begin
    ShowMessage('No hay datos visibles para exportar.');
    Exit;
  end;
  Dlg := TSaveDialog.Create(Self);
  Cabecera := TStringList.Create;
  try
    Dlg.Title := 'Guardar informe de IVA emitido en PDF';
    Dlg.Filter := 'Documento PDF (*.pdf)|*.pdf';
    Dlg.DefaultExt := 'pdf';
    Dlg.FileName := NombreBaseSalida + '.pdf';
    if Dlg.Execute then
    begin
      PrepararCabeceraSalida(Cabecera);
      ExportarGridAPDF(G, Dlg.FileName, TituloGrid, Cabecera);
      ShowMessage('PDF guardado correctamente en:' + LineEnding + Dlg.FileName);
    end;
  except
    on E: Exception do ShowMessage('No se pudo generar el PDF:' + LineEnding + E.Message);
  end;
  Cabecera.Free;
  Dlg.Free;
end;

procedure TFLIvaEmi.PrevisualizarPDFActual;
var
  Cabecera: TStringList;
  G: TDBGrid;
  Fichero, Mensaje: String;
begin
  G := GridActivo;
  if (G = nil) or (G.DataSource = nil) or (G.DataSource.DataSet = nil) or
     (not G.DataSource.DataSet.Active) or G.DataSource.DataSet.IsEmpty then
  begin
    ShowMessage('No hay datos visibles para previsualizar.');
    Exit;
  end;

  Fichero := IncludeTrailingPathDelimiter(GetTempDir(False)) + NombreBaseSalida +
    '_vista_' + FormatDateTime('yyyymmdd_hhnnss_zzz', Now) + '.pdf';
  Cabecera := TStringList.Create;
  try
    PrepararCabeceraSalida(Cabecera);
    ExportarGridAPDF(G, Fichero, TituloGrid, Cabecera);
    if not PrevisualizarPDFPredeterminado(Fichero, Mensaje) then
      ShowMessage(Mensaje);
  except
    on E: Exception do
      ShowMessage('No se pudo previsualizar el PDF:' + LineEnding + E.Message);
  end;
  Cabecera.Free;
end;

procedure TFLIvaEmi.ImprimirPDFActual;
var
  Cabecera: TStringList;
  G: TDBGrid;
  Fichero, Mensaje: String;
begin
  G := GridActivo;
  if (G = nil) or (G.DataSource = nil) or (G.DataSource.DataSet = nil) or
     (not G.DataSource.DataSet.Active) or G.DataSource.DataSet.IsEmpty then
  begin
    ShowMessage('No hay datos visibles para imprimir.');
    Exit;
  end;
  Fichero := IncludeTrailingPathDelimiter(GetTempDir(False)) + NombreBaseSalida +
    '_' + FormatDateTime('hhnnss', Now) + '.pdf';
  Cabecera := TStringList.Create;
  try
    PrepararCabeceraSalida(Cabecera);
    ExportarGridAPDF(G, Fichero, TituloGrid, Cabecera);
    ImprimirPDFPredeterminado(Fichero, Mensaje);
    ShowMessage(Mensaje);
  except
    on E: Exception do ShowMessage('No se pudo imprimir el PDF:' + LineEnding + E.Message);
  end;
  Cabecera.Free;
end;

procedure TFLIvaEmi.ExportarCSVActual;
var
  Dlg: TSaveDialog;
  G: TDBGrid;
begin
  G := GridActivo;
  if (G = nil) or (G.DataSource = nil) or (G.DataSource.DataSet = nil) or
     (not G.DataSource.DataSet.Active) or G.DataSource.DataSet.IsEmpty then
  begin
    ShowMessage('No hay datos visibles para exportar.');
    Exit;
  end;
  Dlg := TSaveDialog.Create(Self);
  try
    Dlg.Title := 'Exportar IVA emitido a CSV';
    Dlg.Filter := 'Archivo CSV (*.csv)|*.csv';
    Dlg.DefaultExt := 'csv';
    Dlg.FileName := NombreBaseSalida + '.csv';
    if Dlg.Execute then
    begin
      ExportarGridACSV(G, Dlg.FileName);
      ShowMessage('CSV guardado correctamente en:' + LineEnding + Dlg.FileName);
    end;
  except
    on E: Exception do ShowMessage('No se pudo generar el CSV:' + LineEnding + E.Message);
  end;
  Dlg.Free;
end;

procedure TFLIvaEmi.BtnInformeOriginalClick(Sender: TObject);
begin
  MostrarInformeOriginal;
end;

procedure TFLIvaEmi.BtnVistaPreviaPDFClick(Sender: TObject);
begin
  PrevisualizarPDFActual;
end;

procedure TFLIvaEmi.BtnImprimirPDFClick(Sender: TObject);
begin
  ImprimirPDFActual;
end;

procedure TFLIvaEmi.BtnCSVClick(Sender: TObject);
begin
  ExportarCSVActual;
end;

procedure TFLIvaEmi.EstilizarBoton(ABoton: TBitBtn;
  const ACaption, AHint: String; AColor: TColor);
begin
  if not Assigned(ABoton) then Exit;
  ABoton.Caption := ACaption;
  ABoton.Hint := AHint;
  ABoton.ShowHint := True;
  ABoton.Color := AColor;
  ABoton.Font.Color := RGBToColor(24, 36, 48);
  ABoton.Font.Height := -14;
  ABoton.Font.Style := [fsBold];
  ABoton.Glyph.Clear;
  ABoton.Layout := blGlyphLeft;
  ABoton.Spacing := 8;
  ABoton.Visible := True;
  ABoton.BringToFront;
end;

procedure TFLIvaEmi.EstilizarControles(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I := 0 to AParent.ControlCount - 1 do
  begin
    C := AParent.Controls[I];
    if C is TLabel then
    begin
      TLabel(C).ParentColor := True;
      TLabel(C).Font.Color := RGBToColor(31, 48, 65);
      TLabel(C).Font.Height := -13;
    end
    else if C is TRadioButton then
    begin
      TRadioButton(C).ParentColor := True;
      TRadioButton(C).Font.Color := RGBToColor(31, 48, 65);
      TRadioButton(C).Font.Height := -14;
    end
    else if C is TCheckBox then
    begin
      TCheckBox(C).ParentColor := True;
      TCheckBox(C).Font.Color := RGBToColor(31, 48, 65);
      TCheckBox(C).Font.Height := -14;
      TCheckBox(C).Font.Style := [fsBold];
    end
    else if C is TCustomEdit then
    begin
      TCustomEdit(C).Color := clWhite;
      TCustomEdit(C).Font.Color := RGBToColor(16, 24, 32);
      TCustomEdit(C).Font.Height := -14;
    end
    else if C is TDateEdit then
    begin
      TDateEdit(C).Color := clWhite;
      TDateEdit(C).Font.Color := RGBToColor(16, 24, 32);
      TDateEdit(C).Font.Height := -14;
    end
    else if C is TComboBox then
    begin
      TComboBox(C).Color := clWhite;
      TComboBox(C).Font.Color := RGBToColor(16, 24, 32);
      TComboBox(C).Font.Height := -14;
    end;
    if C is TWinControl then EstilizarControles(TWinControl(C));
  end;
end;

procedure TFLIvaEmi.ConfigurarApariencia;
begin
  Color := RGBToColor(244, 247, 250);
  Font.Name := 'DejaVu Sans';
  Font.Color := RGBToColor(31, 48, 65);
  Font.Height := -13;
  Constraints.MinWidth := 1080;
  Constraints.MinHeight := 700;

  PanelTituloGrid.Caption := '';
  PanelTituloGrid.Height := 76;
  PanelTituloGrid.Color := RGBToColor(38, 73, 108);
  PanelTituloGrid.BevelOuter := bvNone;
  LabelTituloDBGrid.Caption := 'IVA EMITIDO';
  LabelTituloDBGrid.ParentColor := True;
  LabelTituloDBGrid.Font.Color := clWhite;
  LabelTituloDBGrid.Font.Height := -23;
  LabelTituloDBGrid.Font.Style := [fsBold];
  LabelTituloDBGrid.Alignment := taLeftJustify;
  LabelTituloDBGrid.Layout := tlCenter;
  LabelTituloDBGrid.SetBounds(24, 8, 1000, 36);
  LabelTituloDBGrid.Anchors := [akTop, akLeft, akRight];

  FLabelSubtitulo := TLabel.Create(Self);
  FLabelSubtitulo.Parent := PanelTituloGrid;
  FLabelSubtitulo.Caption := 'Consulta e impresión del IVA repercutido en ventas y facturación';
  FLabelSubtitulo.Font.Color := RGBToColor(220, 234, 247);
  FLabelSubtitulo.Font.Height := -13;
  FLabelSubtitulo.SetBounds(26, 46, 1000, 20);
  FLabelSubtitulo.Anchors := [akTop, akLeft, akRight];

  Panel1.Caption := '';
  Panel1.Height := 68;
  Panel1.Color := clWhite;
  Panel1.BevelOuter := bvNone;
  EstilizarBoton(BitBtn1, 'Consultar IVA', 'Consultar los datos según los filtros seleccionados', RGBToColor(205, 228, 249));
  EstilizarBoton(BitBtn2, 'Guardar PDF', 'Guardar el resultado visible en un PDF nuevo', RGBToColor(213, 238, 220));
  EstilizarBoton(BitBtn3, 'Nueva consulta', 'Volver a los filtros y preparar otra consulta', RGBToColor(255, 235, 194));
  EstilizarBoton(BitBtn4, 'Cerrar', 'Cerrar el formulario', RGBToColor(248, 215, 218));
  BitBtn1.Anchors := [akTop, akLeft];
  BitBtn2.Anchors := [akTop, akLeft];
  BitBtn3.Anchors := [akTop, akLeft];
  BitBtn4.Anchors := [akTop, akLeft];

  FBtnInformeOriginal := TBitBtn.Create(Self);
  FBtnInformeOriginal.Parent := Panel1;
  FBtnInformeOriginal.OnClick := @BtnInformeOriginalClick;
  EstilizarBoton(FBtnInformeOriginal, 'Informe original',
    'Abrir el informe original basado en las plantillas LRF',
    RGBToColor(239, 228, 250));

  FBtnVistaPreviaPDF := TBitBtn.Create(Self);
  FBtnVistaPreviaPDF.Parent := Panel1;
  FBtnVistaPreviaPDF.OnClick := @BtnVistaPreviaPDFClick;
  EstilizarBoton(FBtnVistaPreviaPDF, 'Previsualizar PDF',
    'Generar un PDF temporal y abrirlo en el visor predeterminado',
    RGBToColor(225, 232, 246));

  FBtnImprimirPDF := TBitBtn.Create(Self);
  FBtnImprimirPDF.Parent := Panel1;
  FBtnImprimirPDF.OnClick := @BtnImprimirPDFClick;
  EstilizarBoton(FBtnImprimirPDF, 'Imprimir PDF',
    'Generar el PDF y enviarlo a la impresora predeterminada',
    RGBToColor(205, 228, 249));

  FBtnCSV := TBitBtn.Create(Self);
  FBtnCSV.Parent := Panel1;
  FBtnCSV.OnClick := @BtnCSVClick;
  EstilizarBoton(FBtnCSV, 'Exportar CSV',
    'Guardar las columnas visibles en un archivo CSV',
    RGBToColor(226, 239, 209));

  ActualizarBotonesSalida(False);

  FPanelFiltros := TPanel.Create(Self);
  FPanelFiltros.Parent := Self;
  FPanelFiltros.Caption := '';
  FPanelFiltros.Width := 1120;
  FPanelFiltros.Height := 450;
  FPanelFiltros.Color := RGBToColor(232, 241, 249);
  FPanelFiltros.BevelOuter := bvNone;

  FLabelAyuda := TLabel.Create(Self);
  FLabelAyuda.Parent := FPanelFiltros;
  FLabelAyuda.Caption := 'Seleccione el tipo de listado y complete únicamente los filtros que correspondan.';
  FLabelAyuda.Font.Color := RGBToColor(66, 91, 115);
  FLabelAyuda.Font.Height := -13;
  FLabelAyuda.SetBounds(28, 18, 960, 22);

  PanelDesdeHasta.Parent := FPanelFiltros;
  PanelDesdeHasta.Caption := '';
  PanelDesdeHasta.SetBounds(28, 58, 420, 126);
  PanelDesdeHasta.Color := RGBToColor(246, 249, 252);
  PanelDesdeHasta.BevelOuter := bvNone;
  FLabelRango := TLabel.Create(Self);
  FLabelRango.Parent := PanelDesdeHasta;
  FLabelRango.Caption := 'RANGO DE FACTURAS';
  FLabelRango.Font.Color := RGBToColor(38, 73, 108);
  FLabelRango.Font.Height := -15;
  FLabelRango.Font.Style := [fsBold];
  FLabelRango.SetBounds(20, 14, 260, 22);
  Label2.Caption := 'Primera factura'; Label2.SetBounds(22, 52, 130, 24);
  Edit1.SetBounds(174, 47, 150, 34);
  Label1.Caption := 'Última factura'; Label1.SetBounds(22, 91, 130, 24);
  Edit2.SetBounds(174, 86, 150, 34);

  PanelFechaDesdeHasta.Parent := FPanelFiltros;
  PanelFechaDesdeHasta.Caption := '';
  PanelFechaDesdeHasta.SetBounds(28, 198, 420, 126);
  PanelFechaDesdeHasta.Color := RGBToColor(246, 249, 252);
  PanelFechaDesdeHasta.BevelOuter := bvNone;
  FLabelPeriodo := TLabel.Create(Self);
  FLabelPeriodo.Parent := PanelFechaDesdeHasta;
  FLabelPeriodo.Caption := 'PERIODO DEL INFORME';
  FLabelPeriodo.Font.Color := RGBToColor(38, 73, 108);
  FLabelPeriodo.Font.Height := -15;
  FLabelPeriodo.Font.Style := [fsBold];
  FLabelPeriodo.SetBounds(20, 14, 280, 22);
  Label10.Caption := 'Fecha inicial'; Label10.SetBounds(22, 52, 130, 24);
  DateEdit1.SetBounds(174, 47, 180, 34);
  Label11.Caption := 'Fecha final'; Label11.SetBounds(22, 91, 130, 24);
  DateEdit2.SetBounds(174, 86, 180, 34);

  PanelCambiable.Parent := FPanelFiltros;
  PanelCambiable.Caption := '';
  PanelCambiable.SetBounds(28, 338, 650, 84);
  PanelCambiable.Color := RGBToColor(246, 249, 252);
  PanelCambiable.BevelOuter := bvNone;
  FLabelSerie := TLabel.Create(Self);
  FLabelSerie.Parent := PanelCambiable;
  FLabelSerie.Caption := 'SERIE DE FACTURACIÓN';
  FLabelSerie.Font.Color := RGBToColor(38, 73, 108);
  FLabelSerie.Font.Height := -15;
  FLabelSerie.Font.Style := [fsBold];
  FLabelSerie.SetBounds(20, 12, 280, 22);
  LabelCambiable.Caption := 'Código'; LabelCambiable.SetBounds(22, 49, 70, 24);
  EditCambiableCodigo.SetBounds(96, 43, 110, 34);
  BitBtnCambiable.SetBounds(216, 43, 42, 34);
  BitBtnCambiable.Caption := '...';
  BitBtnCambiable.Color := RGBToColor(184, 215, 243);
  BitBtnCambiable.Font.Color := RGBToColor(24, 36, 48);
  BitBtnCambiable.Font.Style := [fsBold];
  ComboCambiableNombre.SetBounds(270, 43, 350, 34);
  StaticTextCambiableNombre.SetBounds(270, 43, 350, 34);
  StaticTextCambiableNombre.Color := clWhite;
  StaticTextCambiableNombre.Font.Color := RGBToColor(24, 36, 48);

  Label5.Parent := FPanelFiltros;
  Label5.Caption := 'TIPO DE LISTADO';
  Label5.SetBounds(520, 64, 360, 28);
  Label5.Font.Color := RGBToColor(38, 73, 108);
  Label5.Font.Height := -16;
  Label5.Font.Style := [fsBold];
  RadioButton1.Parent := FPanelFiltros; RadioButton1.SetBounds(520, 106, 520, 28);
  RadioButton2.Parent := FPanelFiltros; RadioButton2.SetBounds(520, 148, 520, 28);
  RadioButton3.Parent := FPanelFiltros; RadioButton3.SetBounds(520, 190, 520, 28);
  RadioButton4.Parent := FPanelFiltros; RadioButton4.SetBounds(520, 232, 560, 28);
  RadioButton5.Parent := FPanelFiltros; RadioButton5.SetBounds(520, 274, 560, 28);
  ChkBoxGroup1.Parent := FPanelFiltros;
  ChkBoxGroup1.Caption := 'Agrupar resultados por tipo de IVA';
  ChkBoxGroup1.SetBounds(700, 326, 360, 30);

  DBGrid1.Align := alNone;
  DBGridIVA.Align := alNone;
  DBGridIVA1.Align := alNone;
  DBGrid1.Color := clWhite; DBGridIVA.Color := clWhite; DBGridIVA1.Color := clWhite;
  DBGrid1.Font.Color := RGBToColor(24, 36, 48);
  DBGridIVA.Font.Color := RGBToColor(24, 36, 48);
  DBGridIVA1.Font.Color := RGBToColor(24, 36, 48);
  DBGrid1.Font.Height := -13; DBGridIVA.Font.Height := -13; DBGridIVA1.Font.Height := -13;
  DBGrid1.TitleFont.Style := [fsBold]; DBGridIVA.TitleFont.Style := [fsBold]; DBGridIVA1.TitleFont.Style := [fsBold];
  DBGrid1.Options := DBGrid1.Options + [dgAlwaysShowSelection, dgRowSelect];
  DBGridIVA.Options := DBGridIVA.Options + [dgAlwaysShowSelection, dgRowSelect];
  DBGridIVA1.Options := DBGridIVA1.Options + [dgAlwaysShowSelection, dgRowSelect];

  Bevel1.Visible := False;
  EstilizarControles(Self);
  LabelTituloDBGrid.Font.Color := clWhite;
  FLabelSubtitulo.Font.Color := RGBToColor(220, 234, 247);
  FLabelAyuda.Font.Color := RGBToColor(66, 91, 115);
  FLabelRango.Font.Color := RGBToColor(38, 73, 108);
  FLabelPeriodo.Font.Color := RGBToColor(38, 73, 108);
  FLabelSerie.Font.Color := RGBToColor(38, 73, 108);
  Label5.Font.Color := RGBToColor(38, 73, 108);
  RecolocarControles;
end;

procedure TFLIvaEmi.RecolocarControles;
const
  Separacion = 7;
  AltoBoton = 48;
var
  AreaTop, AreaHeight, X, Y, AnchoTotal: Integer;
  procedure ColocarBoton(ABoton: TBitBtn; AAncho: Integer);
  begin
    if not Assigned(ABoton) then Exit;
    ABoton.SetBounds(X, Y, AAncho, AltoBoton);
    Inc(X, AAncho + Separacion);
  end;
begin
  AnchoTotal := 112 + 126 + 112 + 140 + 112 + 110 + 120 + 86 + (7 * Separacion);
  X := (Panel1.ClientWidth - AnchoTotal) div 2;
  if X < 8 then X := 8;
  Y := 10;
  ColocarBoton(BitBtn1, 112);
  ColocarBoton(FBtnInformeOriginal, 126);
  ColocarBoton(BitBtn2, 112);
  ColocarBoton(FBtnVistaPreviaPDF, 140);
  ColocarBoton(FBtnImprimirPDF, 112);
  ColocarBoton(FBtnCSV, 110);
  ColocarBoton(BitBtn3, 120);
  ColocarBoton(BitBtn4, 86);
  if Assigned(FLabelSubtitulo) then FLabelSubtitulo.Width := PanelTituloGrid.ClientWidth - 52;

  if Assigned(FPanelFiltros) and (not DBGrid1.Visible) and
     (not DBGridIVA.Visible) and (not DBGridIVA1.Visible) then
  begin
    AreaTop := PanelTituloGrid.Height;
    AreaHeight := ClientHeight - PanelTituloGrid.Height - Panel1.Height;
    FPanelFiltros.Left := (ClientWidth - FPanelFiltros.Width) div 2;
    FPanelFiltros.Top := AreaTop + (AreaHeight - FPanelFiltros.Height) div 2;
    if FPanelFiltros.Left < 12 then FPanelFiltros.Left := 12;
    if FPanelFiltros.Top < AreaTop + 10 then FPanelFiltros.Top := AreaTop + 10;
  end;

  if DBGrid1.Visible then DBGrid1.SetBounds(8, PanelTituloGrid.Height + 8,
    ClientWidth - 16, ClientHeight - PanelTituloGrid.Height - Panel1.Height - 16);
  if DBGridIVA.Visible then DBGridIVA.SetBounds(8, PanelTituloGrid.Height + 8,
    ClientWidth - 16, ClientHeight - PanelTituloGrid.Height - Panel1.Height - 16);
  if DBGridIVA1.Visible then DBGridIVA1.SetBounds(8, PanelTituloGrid.Height + 8,
    ClientWidth - 16, ClientHeight - PanelTituloGrid.Height - Panel1.Height - 16);
end;

procedure TFLIvaEmi.AplicarContrasteSeleccion(AControl: TWinControl);
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

procedure TFLIvaEmi.AplicarContrasteSeleccionControles(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I := 0 to AParent.ControlCount - 1 do
  begin
    C := AParent.Controls[I];
    if (C is TCustomEdit) or (C is TDateEdit) or (C is TComboBox) then
      AplicarContrasteSeleccion(TWinControl(C));
    if C is TWinControl then AplicarContrasteSeleccionControles(TWinControl(C));
  end;
end;

procedure TFLIvaEmi.ActualizarFlechaOrdenacion(AGrid: TDBGrid; AColumn: TColumn);
var
  I: Integer;
  S: String;
begin
  if not Assigned(AGrid) or not Assigned(AColumn) then Exit;
  for I := 0 to AGrid.Columns.Count - 1 do
  begin
    S := AGrid.Columns[I].Title.Caption;
    S := StringReplace(S, ' ▲', '', [rfReplaceAll]);
    S := StringReplace(S, ' ▼', '', [rfReplaceAll]);
    AGrid.Columns[I].Title.Caption := S;
  end;
  S := AColumn.Title.Caption;
  if UpperCase(Orden) = 'DESC' then AColumn.Title.Caption := S + ' ▼'
  else AColumn.Title.Caption := S + ' ▲';
end;

procedure TFLIvaEmi.FormShow(Sender: TObject);
begin
  AplicarContrasteSeleccionControles(Self);
  RecolocarControles;
  if Assigned(FPanelFiltros) and (not DBGrid1.Visible) and
     (not DBGridIVA.Visible) and (not DBGridIVA1.Visible) then
    FPanelFiltros.BringToFront;
end;

procedure TFLIvaEmi.FormResize(Sender: TObject);
begin
  RecolocarControles;
end;

procedure TFLIvaEmi.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then Exit;
  Key := 0;
  if DBGrid1.Visible or DBGridIVA.Visible or DBGridIVA1.Visible then
    BitBtn3Click(BitBtn3)
  else
    BitBtn4Click(BitBtn4);
end;

procedure TFLIvaEmi.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  S: String;
  G: TDBGrid;
begin
  G := TDBGrid(Sender);
  if gdSelected in State then
  begin
    G.Canvas.Brush.Color := RGBToColor(42, 86, 132);
    G.Canvas.Font.Color := clWhite;
    G.Canvas.FillRect(Rect);
    if Assigned(Column) and Assigned(Column.Field) then S := Column.Field.DisplayText else S := '';
    G.Canvas.TextRect(Rect, Rect.Left + 4, Rect.Top + 3, S);
  end
  else
    G.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

//=============== Crea el formulario ================
procedure ShowFormlistaivaEmi;
begin
  with TFLIvaEmi.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLIvaEmi.Formcreate(Sender: Tobject);

Begin
   //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
   //---------------------Paneles visibles por defecto, los de RadioButton1Change
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiable.Visible:=True;


   BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
   DateEdit1.Date:=StrToDate('01/01/'+FormatDateTime('YYYY',Date));
   DateEdit2.Date:=Date;
   LabelCambiable.Caption:='Serie';
   
   //Ococultamos todos los DBGrid
   DimensionarColocarBDGrid();
   OcultarBDGrid();
   ConfigurarApariencia;
   ActualizarBotonesSalida(False);
End;

//==================== CERRAR ======================
procedure TFLIvaEmi.BitBtn4Click(Sender: TObject);
begin
  dbQuery.Active:=False;
  dbIva.Active:=False;
  Close();
end;

Procedure TFLIvaEmi.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//==================== VISUALIZAR ===================
procedure TFLIvaEmi.BitBtn1Click(Sender: TObject);
Var
  TxtQuery: String;
begin
  AntColun:='0';Ordenado:=False;
  ActualizarBotonesSalida(False); BitBtn3.Enabled:=True;
  //if EditCambiableCodigo.Text<>'' then EditCambiableCodigo.Text:='A';
  EditCambiableCodigoExit(EditCambiableCodigo);
  //-------------------------- IVA EMITIDO, Esta instruccion SQL NO se si es la correcta
  TituloGrid:='LISTADO DE IVA EMITIDO';
  //TxtQuery := 'SELECT factud'+Tienda+'.*, FORMAT((SUM(FD13) - ((SUM(FD13)*100) / (FD12+100))),2) As Ivas, FORMAT(SUM(FD11),2) As Bases,';

  if RadioButton1.Checked then
    begin
      TxtQuery := 'SELECT factud'+Tienda+'.*, (SUM(FD13) - ((SUM(FD13)*100) / (FD12+100))) As Ivas, SUM(FD11) As Bases,';
      TxtQuery := TxtQuery + ' SUM(FD13) As Total, C1, C5';
      TxtQuery := TxtQuery + ' FROM factud'+Tienda+', clientes';
      TxtQuery := TxtQuery + ' WHERE FD0=C0 AND FD2 = "'+EditCambiableCodigo.Text+'" AND FD3 >= '+Edit1.Text+' AND FD3 <='+Edit2.Text+' AND ';
      TxtQuery := TxtQuery + ' FD1 >="'+FormatDateTime('YY/MM/DD',DateEdit1.Date)+'" AND FD1 <="'+FormatDateTime('YY/MM/DD',DateEdit2.Date)+'"';
      TxtQuery := TxtQuery + ' GROUP BY FD13, FD0';

      //-- TxtQuery := 'SELECT hisopdd'+Tienda+'.*, sum(HOD12) where HOD13='+IVA1+' and HOD0>='+DateEdit1.Date+' and HOD0<='+DateEdit2.Date;
      dbQuery.Active:=False; dbQuery.sql.Text:=TxtQuery; dbQuery.Active:=True;
      if Ordenado=True then
           TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
           TxtQuery:=TxtQuery + ' ORDER BY FD2,FD3';
      dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
      FPanelFiltros.SendToBack; DBGrid1.BringToFront; DBGrid1.Visible:=True; RecolocarControles;
    end;
  if RadioButton2.Checked then
    begin
      if ChkBoxGroup1.Checked=False then
        begin
         TxtQuery := 'select * from iva' + Tienda;
         TxtQuery := TxtQuery + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text));
         TxtQuery := TxtQuery + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text));
         TxtQuery := TxtQuery + '" and TipoOp<>"FM" and TipoOp<>"FA"';
          if Ordenado=True then
               TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
          else
               TxtQuery:=TxtQuery + ' ORDER BY Fecha,Hora';
          dbIva.Active:=False; dbIva.Sql.Text:=TxtQuery; dbIva.Active:=True;
          FPanelFiltros.SendToBack; DBGridIva.BringToFront; DBGridIva.Visible:=True; RecolocarControles;
        end
      else
        begin
           TxtQuery := 'select sum(Base) as TotBase,sum(Iva) as TotIva,TIva,sum(Total) as Tot from iva' + Tienda;
           TxtQuery := TxtQuery + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text));
           TxtQuery := TxtQuery + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text));
           TxtQuery := TxtQuery + '" and TipoOp<>"FM" and TipoOp<>"FA" group by TIva Order by TIva';
           if Ordenado=True then showmessage('Lamentamos comunicar que NO se puede modificar la ordenación en listados agrupados');
           dbIva.Active:=False; dbIva.Sql.Text:=TxtQuery; dbIva.Active:=True;
           FPanelFiltros.SendToBack; DBGridIva1.BringToFront; DBGridIva1.Visible:=True; RecolocarControles;
        end;

      //-- TxtQuery := 'SELECT hisopdd'+Tienda+'.*, sum(HOD12) where HOD13='+IVA1+' and HOD0>='+DateEdit1.Date+' and HOD0<='+DateEdit2.Date;
//--ANULADO PARA PODER MOSTRAR DOS GRID DISTINTOS
      {
      dbIva.Active:=False; dbIva.Sql.Text:=TxtQuery; dbIva.Active:=True;
      FPanelFiltros.SendToBack; DBGridIva.BringToFront; DBGridIva.Visible:=True; RecolocarControles;
      }
    end;
  if RadioButton3.Checked then
    begin
      TxtQuery := 'select * from iva' + Tienda;
      TxtQuery := TxtQuery + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text));
      TxtQuery := TxtQuery + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text));
      TxtQuery := TxtQuery + '" and TipoOp="FA"';

      //-- TxtQuery := 'SELECT hisopdd'+Tienda+'.*, sum(HOD12) where HOD13='+IVA1+' and HOD0>='+DateEdit1.Date+' and HOD0<='+DateEdit2.Date;
      dbIva.Active:=False; dbIva.sql.Text:=TxtQuery; dbIva.Active:=True;
      if Ordenado=True then
           TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
           TxtQuery:=TxtQuery + ' ORDER BY Fecha,Hora';
      dbIva.Active:=False; dbIva.Sql.Text:=TxtQuery; dbIva.Active:=True;
      FPanelFiltros.SendToBack; DBGridIva.BringToFront; DBGridIva.Visible:=True; RecolocarControles;
    end;
  if RadioButton4.Checked then
    begin
      TxtQuery := 'select * from iva' + Tienda;
      TxtQuery := TxtQuery + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text));
      TxtQuery := TxtQuery + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text));
      TxtQuery := TxtQuery + '" and TipoOp="FM"';

      //-- TxtQuery := 'SELECT hisopdd'+Tienda+'.*, sum(HOD12) where HOD13='+IVA1+' and HOD0>='+DateEdit1.Date+' and HOD0<='+DateEdit2.Date;
      dbIva.Active:=False; dbIva.sql.Text:=TxtQuery; dbIva.Active:=True;
      if Ordenado=True then
           TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
           TxtQuery:=TxtQuery + ' ORDER BY Fecha,Hora';
      dbIva.Active:=False; dbIva.Sql.Text:=TxtQuery; dbIva.Active:=True;
      FPanelFiltros.SendToBack; DBGridIva.BringToFront; DBGridIva.Visible:=True; RecolocarControles;
    end;
  if RadioButton5.Checked then
    begin
      {
      TxtQuery := 'select * from iva' + Tienda;
      TxtQuery := TxtQuery + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text));
      TxtQuery := TxtQuery + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text))+'"';
      }
      TxtQuery := 'select TipoOP,sum(Base) as TotBase,sum(Iva) as TotIva,TIva,sum(Total) as Tot FROM iva' + Tienda;
      TxtQuery := TxtQuery + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text));
      TxtQuery := TxtQuery + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text))+'"';
      TxtQuery := TxtQuery + ' group by TipoOP,TIva';


      //-- TxtQuery := 'SELECT hisopdd'+Tienda+'.*, sum(HOD12) where HOD13='+IVA1+' and HOD0>='+DateEdit1.Date+' and HOD0<='+DateEdit2.Date;
      dbIva.Active:=False; dbIva.sql.Text:=TxtQuery; dbIva.Active:=True;
      if Ordenado=True then
           TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
//-- MODIFICADO POR RESUMEN           TxtQuery:=TxtQuery + ' ORDER BY Fecha,Hora';
           TxtQuery:=TxtQuery + ' order by TIva,TipoOP';
      dbIva.Active:=False; dbIva.Sql.Text:=TxtQuery; dbIva.Active:=True;
      FPanelFiltros.SendToBack; DBGridIva1.BringToFront; DBGridIva1.Visible:=True; RecolocarControles;
    end;
  LabelTituloDBGrid.Caption:=TituloGrid;
  ActualizarBotonesSalida(GridActivo <> nil);
  //WriteLn(TxtQuery);
end;

//==================== SELECCIONAR ===================
procedure TFLIvaEmi.BitBtn3Click(Sender: TObject);
begin
  ActualizarBotonesSalida(False); BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
 end;

//==================== IMPRIMIR ===================
procedure TFLIvaEmi.BitBtn2Click(Sender: TObject);
begin
  GuardarPDFActual;
end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLIvaEmi.frReport1GetValue(const ParName: String;
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
  If ChkBoxGroup1.Checked=True then
    begin
      if ParName='DESDE' then ParValue := DateEdit1.Text;
      if ParName='HASTA' then ParValue := DateEdit2.Text;
    end;
end;
//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFLIvaEmi.frReport1EnterRect(Memo: TStringList; View: TfrView);
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

// ====================== Redimensiona y Coloca Todos los DBGrid
procedure TFLIvaEmi.DimensionarColocarBDGrid();
  begin
    DBGrid1.Align:=alClient;
    DBGridIVA.Align:=alClient;
    DBGridIVA1.Align:=alClient;
    //DBGrid3.Align:=alClient;
    //DBGrid4.Align:=alClient;
    //DBGrid5.Align:=alClient;
    //DBGrid6.Align:=alClient;
    //DBGrid7.Align:=alClient;
  end;

//======================= OCULTA TODOS LOS DBGird
procedure TFLIvaEmi.OcultarBDGrid();
  begin
    LabelTituloDBGrid.Caption:='';
    DBGrid1.Visible:=False;
    DBGridIVA.Visible:=False;
    DBGridIVA1.Visible:=False;
    LabelTituloDBGrid.Caption:='IVA EMITIDO';
    if Assigned(FPanelFiltros) then FPanelFiltros.BringToFront;
    RecolocarControles;
  end;


//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLIvaEmi.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid1, Column);
end;

procedure TFLIvaEmi.DBGridIVATitleClick(Column: TColumn);
begin
  if ChkBoxGroup1.Checked=False then
    begin
      Colorea(Column,DBGridIVA,dbIva, AntColun, Orden, TituloColumn, Ordenado);
      ActualizarFlechaOrdenacion(DBGridIVA, Column);
    end
  else
    showmessage('Lamentamos comunicar que NO se puede modificar la ordenación en listados agrupados');
end;

//========= Boton de busqueda del panel cambiable y seleccion del nombre elejido
procedure TFLIvaEmi.BitBtnCambiableClick(Sender: TObject);
var
 TxtQuery: String;
begin
 TxtQuery:='SELECT SF0, SF1 FROM seriesfactu ORDER BY SF1';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre, dbCambiable, LabelCambiable);
end;

procedure TFLIvaEmi.ComboCambiableNombreClick(Sender: TObject);
begin
  EscogeNombreComboCambiable( 'SF1', ComboCambiableNombre, dbCambiable, EditCambiableCodigo, StaticTextCambiableNombre)
end;

procedure TFLIvaEmi.ComboCambiableNombreKeyPress(Sender: TObject;
  var Key: char);
begin
  if key=#13 then ComboCambiableNombreClick(ComboCambiableNombre);
end;

//======================= Despues de introducir un codigo, al salir, si existe,
//======================= completa el StaticText con el nombre oportuno
procedure TFLIvaEmi.EditCambiableCodigoExit(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT SF1 FROM seriesfactu WHERE SF0="'+EditCambiableCodigo.Text+'"';
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

procedure TFLIvaEmi.EditCambiableCodigoEnter(Sender: TObject);
begin
  StaticTextCambiableNombre.Caption:='';
end;

Initialization
  {$I ivaemi.lrs}

End.

