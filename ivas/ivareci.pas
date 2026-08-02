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

Unit ivaReci;

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

  { TFLIvaReci }

  TFLIvaReci = Class(Tform)
    DateEditDesde: TDateEdit;
    DateEditHasta: TDateEdit;
    DBGrid1: TDBGrid;
    dbBusca: TZQuery;
    dbTrabajo: TZQuery;
    //Edit5: TEdit;
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
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
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
    LabelTituloDBGrid: TLabel;
    Panel1: Tpanel;
    Bitbtn1: Tbitbtn;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    BitBtn4: TBitBtn;
    Datasource1: TDatasource;
    dbQuery: TZQuery;
    Panel2: TPanel;
    PanelFechaDesdeHasta: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    StaticText14: TStaticText;
    StaticText15: TStaticText;
    StaticText16: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure DateEditDesdeExit(Sender: TObject);
    procedure DateEditHastaExit(Sender: TObject);
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

    procedure OcultarBDGrid();
    procedure PanelFechaDesdeHastaClick(Sender: TObject);

  Private
    FLabelSubtitulo: TLabel;
    FLabelPeriodo: TLabel;
    FLabelDocumento: TLabel;
    FLabelResumen: TLabel;
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
    function NombreBaseSalida: String;
    procedure PrepararCabeceraSalida(ALines: TStrings);
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

  procedure ShowFormlistaivaReci;
  
Var
  FLIvaReci: TFLIvaReci;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;
  BASE1,BASE2,BASE3,BASE4,IMPOIVA1,IMPOIVA2,IMPOIVA3,IMPOIVA4: Double;
  TOTAL1,TOTAL2,TOTAL3,TOTAL4: Double;
  IRIVA1,IRIVA2,IRIVA3,IRIVA4,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PIVA4,PRIVA1,PRIVA2,PRIVA3,PRIVA4:Double;

Implementation

uses
  Global, Funciones;


function TFLIvaReci.NombreBaseSalida: String;
begin
  Result := 'iva_recibido_' + FormatDateTime('yyyymmdd', DateEditDesde.Date) + '_' +
    FormatDateTime('yyyymmdd', DateEditHasta.Date);
end;

procedure TFLIvaReci.PrepararCabeceraSalida(ALines: TStrings);
var
  TipoDocumento: String;
begin
  if not Assigned(ALines) then Exit;
  ALines.Clear;
  ALines.Add(Empresa + ' - ' + Nif);
  ALines.Add(Direccion + ' - ' + CP + ' ' + Localidad);
  ALines.Add('Periodo: ' + DateEditDesde.Text + ' a ' + DateEditHasta.Text);
  if RadioButton1.Checked then TipoDocumento := RadioButton1.Caption
  else if RadioButton2.Checked then TipoDocumento := RadioButton2.Caption
  else if RadioButton3.Checked then TipoDocumento := RadioButton3.Caption
  else if RadioButton4.Checked then TipoDocumento := RadioButton4.Caption
  else TipoDocumento := RadioButton5.Caption;
  ALines.Add('Documentos: ' + TipoDocumento);
  ALines.Add(StaticText1.Caption + ': Base ' + StaticText5.Caption +
    ' | IVA ' + StaticText6.Caption + ' | Total ' + StaticText13.Caption);
  ALines.Add(StaticText2.Caption + ': Base ' + StaticText7.Caption +
    ' | IVA ' + StaticText8.Caption + ' | Total ' + StaticText14.Caption);
  ALines.Add(StaticText3.Caption + ': Base ' + StaticText9.Caption +
    ' | IVA ' + StaticText10.Caption + ' | Total ' + StaticText15.Caption);
  ALines.Add(StaticText4.Caption + ': Base ' + StaticText11.Caption +
    ' | IVA ' + StaticText12.Caption + ' | Total ' + StaticText16.Caption);
end;

procedure TFLIvaReci.ActualizarBotonesSalida(AEnabled: Boolean);
begin
  BitBtn2.Enabled := AEnabled;
  if Assigned(FBtnInformeOriginal) then FBtnInformeOriginal.Enabled := AEnabled;
  if Assigned(FBtnVistaPreviaPDF) then FBtnVistaPreviaPDF.Enabled := AEnabled;
  if Assigned(FBtnImprimirPDF) then FBtnImprimirPDF.Enabled := AEnabled;
  if Assigned(FBtnCSV) then FBtnCSV.Enabled := AEnabled;
end;

procedure TFLIvaReci.MostrarInformeOriginal;
begin
  try
    frDBDataSet1.DataSet := dbQuery;
    frReport1.LoadFromFile(RutaReports + 'ListadoIvaReci.lrf');
    frReport1.ShowReport;
  except
    on E: Exception do
      ShowMessage('No se pudo abrir el informe original:' + LineEnding + E.Message);
  end;
end;

procedure TFLIvaReci.GuardarPDFActual;
var
  Dlg: TSaveDialog;
  Cabecera: TStringList;
begin
  if (not DBGrid1.Visible) or (DBGrid1.DataSource = nil) or
     (DBGrid1.DataSource.DataSet = nil) or
     (not DBGrid1.DataSource.DataSet.Active) or DBGrid1.DataSource.DataSet.IsEmpty then
  begin
    ShowMessage('No hay datos visibles para exportar.');
    Exit;
  end;
  Dlg := TSaveDialog.Create(Self);
  Cabecera := TStringList.Create;
  try
    Dlg.Title := 'Guardar informe de IVA recibido en PDF';
    Dlg.Filter := 'Documento PDF (*.pdf)|*.pdf';
    Dlg.DefaultExt := 'pdf';
    Dlg.FileName := NombreBaseSalida + '.pdf';
    if Dlg.Execute then
    begin
      PrepararCabeceraSalida(Cabecera);
      ExportarGridAPDF(DBGrid1, Dlg.FileName, TituloGrid, Cabecera);
      ShowMessage('PDF guardado correctamente en:' + LineEnding + Dlg.FileName);
    end;
  except
    on E: Exception do ShowMessage('No se pudo generar el PDF:' + LineEnding + E.Message);
  end;
  Cabecera.Free;
  Dlg.Free;
end;

procedure TFLIvaReci.PrevisualizarPDFActual;
var
  Cabecera: TStringList;
  Fichero, Mensaje: String;
begin
  if (not DBGrid1.Visible) or (DBGrid1.DataSource = nil) or
     (DBGrid1.DataSource.DataSet = nil) or
     (not DBGrid1.DataSource.DataSet.Active) or DBGrid1.DataSource.DataSet.IsEmpty then
  begin
    ShowMessage('No hay datos visibles para previsualizar.');
    Exit;
  end;

  Fichero := IncludeTrailingPathDelimiter(GetTempDir(False)) + NombreBaseSalida +
    '_vista_' + FormatDateTime('yyyymmdd_hhnnss_zzz', Now) + '.pdf';
  Cabecera := TStringList.Create;
  try
    PrepararCabeceraSalida(Cabecera);
    ExportarGridAPDF(DBGrid1, Fichero, TituloGrid, Cabecera);
    if not PrevisualizarPDFPredeterminado(Fichero, Mensaje) then
      ShowMessage(Mensaje);
  except
    on E: Exception do
      ShowMessage('No se pudo previsualizar el PDF:' + LineEnding + E.Message);
  end;
  Cabecera.Free;
end;

procedure TFLIvaReci.ImprimirPDFActual;
var
  Cabecera: TStringList;
  Fichero, Mensaje: String;
begin
  if (not DBGrid1.Visible) or (DBGrid1.DataSource = nil) or
     (DBGrid1.DataSource.DataSet = nil) or
     (not DBGrid1.DataSource.DataSet.Active) or DBGrid1.DataSource.DataSet.IsEmpty then
  begin
    ShowMessage('No hay datos visibles para imprimir.');
    Exit;
  end;
  Fichero := IncludeTrailingPathDelimiter(GetTempDir(False)) + NombreBaseSalida +
    '_' + FormatDateTime('hhnnss', Now) + '.pdf';
  Cabecera := TStringList.Create;
  try
    PrepararCabeceraSalida(Cabecera);
    ExportarGridAPDF(DBGrid1, Fichero, TituloGrid, Cabecera);
    ImprimirPDFPredeterminado(Fichero, Mensaje);
    ShowMessage(Mensaje);
  except
    on E: Exception do ShowMessage('No se pudo imprimir el PDF:' + LineEnding + E.Message);
  end;
  Cabecera.Free;
end;

procedure TFLIvaReci.ExportarCSVActual;
var
  Dlg: TSaveDialog;
begin
  if (not DBGrid1.Visible) or (DBGrid1.DataSource = nil) or
     (DBGrid1.DataSource.DataSet = nil) or
     (not DBGrid1.DataSource.DataSet.Active) or DBGrid1.DataSource.DataSet.IsEmpty then
  begin
    ShowMessage('No hay datos visibles para exportar.');
    Exit;
  end;
  Dlg := TSaveDialog.Create(Self);
  try
    Dlg.Title := 'Exportar IVA recibido a CSV';
    Dlg.Filter := 'Archivo CSV (*.csv)|*.csv';
    Dlg.DefaultExt := 'csv';
    Dlg.FileName := NombreBaseSalida + '.csv';
    if Dlg.Execute then
    begin
      ExportarGridACSV(DBGrid1, Dlg.FileName);
      ShowMessage('CSV guardado correctamente en:' + LineEnding + Dlg.FileName);
    end;
  except
    on E: Exception do ShowMessage('No se pudo generar el CSV:' + LineEnding + E.Message);
  end;
  Dlg.Free;
end;

procedure TFLIvaReci.BtnInformeOriginalClick(Sender: TObject);
begin
  MostrarInformeOriginal;
end;

procedure TFLIvaReci.BtnVistaPreviaPDFClick(Sender: TObject);
begin
  PrevisualizarPDFActual;
end;

procedure TFLIvaReci.BtnImprimirPDFClick(Sender: TObject);
begin
  ImprimirPDFActual;
end;

procedure TFLIvaReci.BtnCSVClick(Sender: TObject);
begin
  ExportarCSVActual;
end;

procedure TFLIvaReci.EstilizarBoton(ABoton: TBitBtn;
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

procedure TFLIvaReci.EstilizarControles(AParent: TWinControl);
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
    end;

    if C is TWinControl then
      EstilizarControles(TWinControl(C));
  end;
end;

procedure TFLIvaReci.ConfigurarApariencia;
var
  I: Integer;
begin
  Color := RGBToColor(244, 247, 250);
  Font.Name := 'DejaVu Sans';
  Font.Color := RGBToColor(31, 48, 65);
  Font.Height := -13;
  Constraints.MinWidth := 1024;
  Constraints.MinHeight := 680;

  PanelTituloGrid.Caption := '';
  PanelTituloGrid.Height := 76;
  PanelTituloGrid.Color := RGBToColor(38, 73, 108);
  PanelTituloGrid.BevelOuter := bvNone;
  LabelTituloDBGrid.Caption := 'IVA RECIBIDO';
  LabelTituloDBGrid.ParentColor := True;
  LabelTituloDBGrid.Font.Color := clWhite;
  LabelTituloDBGrid.Font.Height := -23;
  LabelTituloDBGrid.Font.Style := [fsBold];
  LabelTituloDBGrid.Alignment := taLeftJustify;
  LabelTituloDBGrid.Layout := tlCenter;
  LabelTituloDBGrid.SetBounds(24, 8, 900, 36);
  LabelTituloDBGrid.Anchors := [akTop, akLeft, akRight];

  FLabelSubtitulo := TLabel.Create(Self);
  FLabelSubtitulo.Parent := PanelTituloGrid;
  FLabelSubtitulo.Caption := 'Consulta e impresión del IVA soportado en compras y documentos de proveedores';
  FLabelSubtitulo.Font.Color := RGBToColor(220, 234, 247);
  FLabelSubtitulo.Font.Height := -13;
  FLabelSubtitulo.SetBounds(26, 46, 1000, 20);
  FLabelSubtitulo.Anchors := [akTop, akLeft, akRight];

  Panel1.Caption := '';
  Panel1.Height := 68;
  Panel1.Color := RGBToColor(255, 255, 255);
  Panel1.BevelOuter := bvNone;

  EstilizarBoton(BitBtn1, 'Consultar IVA', 'Consultar los documentos con los filtros indicados', RGBToColor(205, 228, 249));
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
    'Abrir el informe original basado en la plantilla LRF',
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

  PanelFechaDesdeHasta.Caption := '';
  PanelFechaDesdeHasta.Width := 860;
  PanelFechaDesdeHasta.Height := 290;
  PanelFechaDesdeHasta.Color := RGBToColor(232, 241, 249);
  PanelFechaDesdeHasta.BevelOuter := bvNone;
  PanelFechaDesdeHasta.BorderSpacing.Around := 0;

  FLabelPeriodo := TLabel.Create(Self);
  FLabelPeriodo.Parent := PanelFechaDesdeHasta;
  FLabelPeriodo.Caption := 'PERIODO DEL INFORME';
  FLabelPeriodo.Font.Color := RGBToColor(38, 73, 108);
  FLabelPeriodo.Font.Height := -16;
  FLabelPeriodo.Font.Style := [fsBold];
  FLabelPeriodo.SetBounds(32, 24, 310, 24);

  FLabelDocumento := TLabel.Create(Self);
  FLabelDocumento.Parent := PanelFechaDesdeHasta;
  FLabelDocumento.Caption := 'DOCUMENTOS A INCLUIR';
  FLabelDocumento.Font.Color := RGBToColor(38, 73, 108);
  FLabelDocumento.Font.Height := -16;
  FLabelDocumento.Font.Style := [fsBold];
  FLabelDocumento.SetBounds(470, 24, 330, 24);

  Label10.Caption := 'Fecha inicial';
  Label10.SetBounds(34, 78, 125, 24);
  DateEditDesde.SetBounds(175, 72, 190, 34);
  Label11.Caption := 'Fecha final';
  Label11.SetBounds(34, 138, 125, 24);
  DateEditHasta.SetBounds(175, 132, 190, 34);

  RadioButton1.SetBounds(470, 68, 300, 28);
  RadioButton2.SetBounds(470, 106, 220, 28);
  RadioButton3.SetBounds(470, 144, 220, 28);
  RadioButton4.SetBounds(470, 182, 220, 28);
  RadioButton5.SetBounds(470, 220, 260, 28);

  DBGrid1.Align := alNone;
  DBGrid1.Color := clWhite;
  DBGrid1.Font.Color := RGBToColor(24, 36, 48);
  DBGrid1.Font.Height := -13;
  DBGrid1.TitleFont.Color := RGBToColor(31, 48, 65);
  DBGrid1.TitleFont.Style := [fsBold];
  DBGrid1.Options := DBGrid1.Options + [dgAlwaysShowSelection, dgRowSelect];

  Panel2.Caption := '';
  Panel2.Align := alNone;
  Panel2.Height := 174;
  Panel2.Color := RGBToColor(235, 246, 238);
  Panel2.BevelOuter := bvNone;
  Panel2.Anchors := [akLeft, akRight, akBottom];

  FLabelResumen := TLabel.Create(Self);
  FLabelResumen.Parent := Panel2;
  FLabelResumen.Caption := 'RESUMEN POR TIPO DE IVA';
  FLabelResumen.Font.Color := RGBToColor(39, 91, 61);
  FLabelResumen.Font.Height := -15;
  FLabelResumen.Font.Style := [fsBold];
  FLabelResumen.SetBounds(24, 10, 360, 24);

  for I := 1 to 16 do
    case I of
      1: StaticText1.Color := RGBToColor(218, 238, 224);
      2: StaticText2.Color := RGBToColor(218, 238, 224);
      3: StaticText3.Color := RGBToColor(218, 238, 224);
      4: StaticText4.Color := RGBToColor(218, 238, 224);
      5: StaticText5.Color := clWhite;
      6: StaticText6.Color := clWhite;
      7: StaticText7.Color := clWhite;
      8: StaticText8.Color := clWhite;
      9: StaticText9.Color := clWhite;
      10: StaticText10.Color := clWhite;
      11: StaticText11.Color := clWhite;
      12: StaticText12.Color := clWhite;
      13: StaticText13.Color := RGBToColor(255, 247, 220);
      14: StaticText14.Color := RGBToColor(255, 247, 220);
      15: StaticText15.Color := RGBToColor(255, 247, 220);
      16: StaticText16.Color := RGBToColor(255, 247, 220);
    end;

  StaticText1.Font.Style := [fsBold]; StaticText2.Font.Style := [fsBold];
  StaticText3.Font.Style := [fsBold]; StaticText4.Font.Style := [fsBold];
  StaticText13.Font.Style := [fsBold]; StaticText14.Font.Style := [fsBold];
  StaticText15.Font.Style := [fsBold]; StaticText16.Font.Style := [fsBold];

  EstilizarControles(Self);
  LabelTituloDBGrid.Font.Color := clWhite;
  FLabelSubtitulo.Font.Color := RGBToColor(220, 234, 247);
  FLabelPeriodo.Font.Color := RGBToColor(38, 73, 108);
  FLabelDocumento.Font.Color := RGBToColor(38, 73, 108);
  FLabelResumen.Font.Color := RGBToColor(39, 91, 61);
  RecolocarControles;
end;

procedure TFLIvaReci.RecolocarControles;
const
  Separacion = 7;
  AltoBoton = 48;
var
  AreaTop, AreaHeight, X0, ColW, X, Y, AnchoTotal: Integer;
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
  if Assigned(FLabelSubtitulo) then
    FLabelSubtitulo.Width := PanelTituloGrid.ClientWidth - 52;

  Panel2.SetBounds(8, ClientHeight - Panel1.Height - Panel2.Height - 6,
    ClientWidth - 16, Panel2.Height);

  if DBGrid1.Visible then
  begin
    DBGrid1.SetBounds(8, PanelTituloGrid.Height + 8, ClientWidth - 16,
      ClientHeight - PanelTituloGrid.Height - Panel1.Height - Panel2.Height - 22);
  end;

  if PanelFechaDesdeHasta.Visible and (not DBGrid1.Visible) then
  begin
    AreaTop := PanelTituloGrid.Height;
    AreaHeight := ClientHeight - PanelTituloGrid.Height - Panel1.Height;
    PanelFechaDesdeHasta.Left := (ClientWidth - PanelFechaDesdeHasta.Width) div 2;
    PanelFechaDesdeHasta.Top := AreaTop + (AreaHeight - PanelFechaDesdeHasta.Height) div 2;
    if PanelFechaDesdeHasta.Left < 12 then PanelFechaDesdeHasta.Left := 12;
    if PanelFechaDesdeHasta.Top < AreaTop + 12 then PanelFechaDesdeHasta.Top := AreaTop + 12;
  end;

  X0 := (Panel2.ClientWidth - 760) div 2;
  if X0 < 170 then X0 := 170;
  ColW := 138;
  Label1.SetBounds(X0 - 150, 63, 140, 24);
  Label2.SetBounds(X0 - 150, 96, 140, 24);
  Label3.SetBounds(X0 - 150, 129, 140, 24);

  StaticText1.SetBounds(X0, 37, ColW, 26);
  StaticText2.SetBounds(X0 + ColW + 12, 37, ColW, 26);
  StaticText3.SetBounds(X0 + 2*(ColW + 12), 37, ColW, 26);
  StaticText4.SetBounds(X0 + 3*(ColW + 12), 37, ColW, 26);
  StaticText5.SetBounds(X0, 63, ColW, 26);
  StaticText7.SetBounds(X0 + ColW + 12, 63, ColW, 26);
  StaticText9.SetBounds(X0 + 2*(ColW + 12), 63, ColW, 26);
  StaticText11.SetBounds(X0 + 3*(ColW + 12), 63, ColW, 26);
  StaticText6.SetBounds(X0, 96, ColW, 26);
  StaticText8.SetBounds(X0 + ColW + 12, 96, ColW, 26);
  StaticText10.SetBounds(X0 + 2*(ColW + 12), 96, ColW, 26);
  StaticText12.SetBounds(X0 + 3*(ColW + 12), 96, ColW, 26);
  StaticText13.SetBounds(X0, 129, ColW, 26);
  StaticText14.SetBounds(X0 + ColW + 12, 129, ColW, 26);
  StaticText15.SetBounds(X0 + 2*(ColW + 12), 129, ColW, 26);
  StaticText16.SetBounds(X0 + 3*(ColW + 12), 129, ColW, 26);
end;

procedure TFLIvaReci.AplicarContrasteSeleccion(AControl: TWinControl);
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

procedure TFLIvaReci.AplicarContrasteSeleccionControles(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I := 0 to AParent.ControlCount - 1 do
  begin
    C := AParent.Controls[I];
    if (C is TCustomEdit) or (C is TDateEdit) then
      AplicarContrasteSeleccion(TWinControl(C));
    if C is TWinControl then
      AplicarContrasteSeleccionControles(TWinControl(C));
  end;
end;

procedure TFLIvaReci.ActualizarFlechaOrdenacion(AGrid: TDBGrid; AColumn: TColumn);
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
  if UpperCase(Orden) = 'DESC' then
    AColumn.Title.Caption := S + ' ▼'
  else
    AColumn.Title.Caption := S + ' ▲';
end;

procedure TFLIvaReci.FormShow(Sender: TObject);
begin
  AplicarContrasteSeleccionControles(Self);
  RecolocarControles;
  if not DBGrid1.Visible then PanelFechaDesdeHasta.BringToFront;
end;

procedure TFLIvaReci.FormResize(Sender: TObject);
begin
  RecolocarControles;
end;

procedure TFLIvaReci.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then Exit;
  Key := 0;
  if DBGrid1.Visible then
    BitBtn3Click(BitBtn3)
  else
    BitBtn4Click(BitBtn4);
end;

procedure TFLIvaReci.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
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
procedure ShowFormlistaivaReci;
begin
  with TFLIvaReci.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLIvaReci.Formcreate(Sender: Tobject);

Begin
   //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
   //---------------------Paneles visibles por defecto, los de RadioButton1Change
   PanelFechaDesdeHasta.Visible:=True;

   BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
   DateEditDesde.Date:=StrToDate('01/01/'+FormatDateTime('YYYY',Date));
   DateEditHasta.Date:=Date;

   //ocultamos todos los DBGrid
   OcultarBDGrid();
   ConfigurarApariencia;
   ActualizarBotonesSalida(False);
End;

//==================== CERRAR ======================
procedure TFLIvaReci.BitBtn4Click(Sender: TObject);
begin
  dbQuery.Active:=False;
  Close();
end;

procedure TFLIvaReci.DateEditDesdeExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditDesde.text) Then
     begin
       DateEditDesde.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

procedure TFLIvaReci.DateEditHastaExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditHasta.text) Then
     begin
       DateEditHasta.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

Procedure TFLIvaReci.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//==================== VISUALIZAR ===================
procedure TFLIvaReci.BitBtn1Click(Sender: TObject);
Var
  TxtQuery, TxtQ: String;
  Stabla: String; //-- Nombre de la tabla en función de la selección
begin
  AntColun:='0';Ordenado:=False;
  ActualizarBotonesSalida(False); BitBtn3.Enabled:=True;
//---- Consulta para el listado
  TituloGrid:='LISTADO DE IVA RECIBIDO, agrupado por Tipos';
  IMPOIVA1:=0; BASE1:=0; TOTAL1:=0; IRIVA1:=0; PIVA1:=0; PRIVA1:=0;
  IMPOIVA2:=0; BASE2:=0; TOTAL2:=0; IRIVA2:=0; PIVA2:=0; PRIVA2:=0;
  IMPOIVA3:=0; BASE3:=0; TOTAL3:=0; IRIVA3:=0; PIVA3:=0; PRIVA3:=0;
  IMPOIVA4:=0; BASE4:=0; TOTAL4:=0; IRIVA4:=0; PIVA4:=0; PRIVA4:=0;
  //-- Selección de TABLA
  if RadioButton1.Checked=True then Stabla:='hipedicc';
  if RadioButton2.Checked=True then Stabla:='hipedifacc';
  if RadioButton3.Checked=True then Stabla:='hipedicc';
  if RadioButton4.Checked=True then Stabla:='hipedicc';
  if RadioButton5.Checked=True then Stabla:='hipedicc';


  TxtQ:='SELECT SUM(HPC31),SUM(HPC32),SUM(HPC33),SUM(HPC34),SUM(HPC35),SUM(HPC36),'+
        'SUM(HPC37),SUM(HPC38) FROM '+Stabla+Tienda+' WHERE '+
        'HPC1 >="'+FormatDateTime('YY/MM/DD',DateEditDesde.Date)+'" AND HPC1 <="'+FormatDateTime('YY/MM/DD',DateEditHasta.Date)+'"';
  if RadioButton2.Checked=True then TxtQ:=TxtQ+' AND HPC28="F"';//---------------- Facturas
  if RadioButton3.Checked=True then TxtQ:=TxtQ+' AND HPC28="A"';//---------------- Albaranes
  if RadioButton4.Checked=True then TxtQ:=TxtQ+' AND HPC28="P"';//---------------- Pedidos
  if RadioButton5.Checked=True then TxtQ:=TxtQ+' AND HPC28="N"';//---------------- Notas de entregas
  dbTrabajo.Active:=False; dbTrabajo.Sql.Text:=TxtQ; dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then begin showmessage('CON ESTA SELECCION NO HAY DATOS'); exit; end;
  dbTrabajo.First;

  StaticText1.Caption:='IVA '+FloatToStr(IVA1)+'%';
  StaticText2.Caption:='IVA '+FloatToStr(IVA2)+'%';
  StaticText3.Caption:='IVA '+FloatToStr(IVA3)+'%';
  StaticText4.Caption:='IVA 0%';
  dbGrid1.Columns[5].Title.Caption:='BASE I. '+FloatToStr(IVA1)+'%';
  dbGrid1.Columns[6].Title.Caption:='IMP. IVA '+FloatToStr(IVA1)+'%';
  dbGrid1.Columns[7].Title.Caption:='BASE I. '+FloatToStr(IVA2)+'%';
  dbGrid1.Columns[8].Title.Caption:='IMP. IVA '+FloatToStr(IVA2)+'%';
  dbGrid1.Columns[9].Title.Caption:='BASE I. '+FloatToStr(IVA3)+'%';
  dbGrid1.Columns[10].Title.Caption:='IMP. IVA '+FloatToStr(IVA3)+'%';
  dbGrid1.Columns[11].Title.Caption:='BASE I. 0%';
  dbGrid1.Columns[12].Title.Caption:='IMP. IVA 0%';

  StaticText5.Caption:=FormatFloat('0.00',dbTrabajo.Fields[0].AsFloat);
  StaticText6.Caption:=FormatFloat('0.00',dbTrabajo.Fields[1].AsFloat);
  StaticText13.Caption:=FormatFloat('0.00',dbTrabajo.Fields[0].AsFloat+dbTrabajo.Fields[1].AsFloat);
  StaticText7.Caption:=FormatFloat('0.00',dbTrabajo.Fields[2].AsFloat);
  StaticText8.Caption:=FormatFloat('0.00',dbTrabajo.Fields[3].AsFloat);
  StaticText14.Caption:=FormatFloat('0.00',dbTrabajo.Fields[2].AsFloat+dbTrabajo.Fields[3].AsFloat);
  StaticText9.Caption:=FormatFloat('0.00',dbTrabajo.Fields[4].AsFloat);
  StaticText10.Caption:=FormatFloat('0.00',dbTrabajo.Fields[5].AsFloat);
  StaticText15.Caption:=FormatFloat('0.00',dbTrabajo.Fields[4].AsFloat+dbTrabajo.Fields[5].AsFloat);
  StaticText11.Caption:=FormatFloat('0.00',dbTrabajo.Fields[6].AsFloat);
  StaticText12.Caption:=FormatFloat('0.00',dbTrabajo.Fields[7].AsFloat);
  StaticText16.Caption:=FormatFloat('0.00',dbTrabajo.Fields[6].AsFloat+dbTrabajo.Fields[7].AsFloat);
  //-------------------------- Listado -------------------------
  TituloGrid:='LISTADO DE IVA RECIBIDO, DESDE '+DateEditDesde.Text+' HASTA '+DateEditHasta.Text;
  TxtQuery := 'SELECT * FROM '+Stabla+Tienda+',proveedores WHERE HPC2=P0 AND '+
              'HPC1 >="'+FormatDateTime('YY/MM/DD',DateEditDesde.Date)+'" AND HPC1 <="'+FormatDateTime('YY/MM/DD',DateEditHasta.Date)+'"';
  if RadioButton2.Checked=True then TxtQuery:=TxtQuery+' AND HPC28="F"';//---------------- Facturas
  if RadioButton3.Checked=True then TxtQuery:=TxtQuery+' AND HPC28="A"';//---------------- Albaranes
  if RadioButton4.Checked=True then TxtQuery:=TxtQuery+' AND HPC28="P"';//---------------- Pedidos
  if RadioButton5.Checked=True then TxtQuery:=TxtQuery+' AND HPC28="N"';//---------------- Notas de entregas
  if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
  else
       TxtQuery := TxtQuery + ' ORDER BY HPC1,HPC2';

  LabelTituloDBGrid.Caption:=TituloGrid;
  dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
  PanelFechaDesdeHasta.SendToBack;
  DBGrid1.BringToFront; DBGrid1.Visible:=True;
  Panel2.Visible:=True; Panel2.BringToFront;
  RecolocarControles;
  ActualizarBotonesSalida(True);
  //WriteLn(TxtQuery);
end;

//==================== SELECCIONAR ===================
procedure TFLIvaReci.BitBtn3Click(Sender: TObject);
begin
  ActualizarBotonesSalida(False); BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
 end;

//==================== IMPRIMIR ===================
procedure TFLIvaReci.BitBtn2Click(Sender: TObject);
begin
  GuardarPDFActual;
end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLIvaReci.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  if ParName ='EMPRESA' then ParValue := Empresa;
  if ParName='DIRECCION' then ParValue := Direccion;
  if ParName='LOCALIDAD' then ParValue := Localidad;
  if ParName='CP' then ParValue := CP;
  if ParName='TITULO' then ParValue := TituloGrid;
  if ParName='TXTIVA1' then ParValue := 'BASE/IVA '+FloatToStr(IVA1)+'%';
  if ParName='TXTIVA2' then ParValue := 'BASE/IVA '+FloatToStr(IVA2)+'%';
  if ParName='TXTIVA3' then ParValue := 'BASE/IVA '+FloatToStr(IVA3)+'%';
  if ParName='TXTIVA4' then ParValue := 'BASE/IVA 0%';
  if ParName='IMPBASE1' then ParValue := StaticText5.Caption;
  if ParName='IMPIVA1' then ParValue := StaticText6.Caption;
  if ParName='IMPBASE2' then ParValue := StaticText7.Caption;
  if ParName='IMPIVA2' then ParValue := StaticText8.Caption;
  if ParName='IMPBASE3' then ParValue := StaticText9.Caption;
  if ParName='IMPIVA3' then ParValue := StaticText10.Caption;
  if ParName='IMPBASE4' then ParValue := StaticText11.Caption;
  if ParName='IMPIVA4' then ParValue := StaticText12.Caption;

  if ParName='TOTBASE1' then ParValue := StaticText13.Caption;
  if ParName='TOTBASE2' then ParValue := StaticText14.Caption;
  if ParName='TOTBASE3' then ParValue := StaticText15.Caption;
  if ParName='TOTBASE4' then ParValue := StaticText16.Caption;


end;
//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFLIvaReci.frReport1EnterRect(Memo: TStringList; View: TfrView);
var
  vImage: TImage;
begin
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

//======================= OCULTA TODOS LOS DBGird
procedure TFLIvaReci.OcultarBDGrid();
  begin
     LabelTituloDBGrid.Caption:='';
     DBGrid1.Visible:=False;
     Panel2.Visible:=False;
     LabelTituloDBGrid.Caption:='IVA RECIBIDO';
     PanelFechaDesdeHasta.Visible:=True;
     PanelFechaDesdeHasta.BringToFront;
     RecolocarControles;
  end;

procedure TFLIvaReci.PanelFechaDesdeHastaClick(Sender: TObject);
begin

end;


//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLIvaReci.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechaOrdenacion(DBGrid1, Column);
end;

Initialization
  {$I ivareci.lrs}

End.

