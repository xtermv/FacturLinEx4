unit uVFCentroControl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DateUtils, Forms, Controls, Dialogs, StdCtrls, ExtCtrls, Buttons,
  DBGrids, DB, Graphics, Grids, LCLType, ComCtrls, ZConnection, ZDataset;

procedure VFC_OpenControl(const Conn: TZConnection; const Tienda: string);

implementation

uses
  uvfqueuemonitor, Global, uVeriHash, IniFiles, uFLXAuditEngine, uFLXAuditTypes,
  uFLXCentroSalud, uFLXDatabaseMigration, uVFValidadorTecnico, uVFSubsanaciones, uVFTrazabilidad;

type
  TfrmVFCentroControl = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;
    TopPanel, HeaderPanel, SummaryPanel, FilterPanel, ActionPanel,
      DetailPanel, DashboardPanel, HealthPanel, HashTopPanel,
      HashDetailPanel: TPanel;
    Pages: TPageControl;
    TabSummary, TabRecords, TabAudit, TabHash, TabConfig: TTabSheet;
    LbTitle, LbSubtitle, LbYear, LbScope, LbEnvironment, LbOrigin, LbTotal, LbPending,
      LbSent, LbIncidents, LbRetryable, LbHint, LbDetailTitle,
      LbClassification, LbTrafficLight, LbCommunication, LbHash, LbQueue,
      LbEnvironmentState, LbLastCommunication, LbDeclaration,
      LbHashTotal, LbHashOK, LbHashWarnings, LbHashErrors, LbHashFilter: TLabel;
    CbYear, CbState, CbEnvironment, CbOrigin: TComboBox;
    BtnRefresh, BtnBulkRetry, BtnTechnicalMonitor, BtnClose, BtnRunAudit, BtnRunConfigAudit,
      BtnHealthCenter, BtnTechnicalValidator, BtnSubsanaciones, BtnTraceability,
      BtnHashRefresh: TBitBtn;
    Grid: TDBGrid;
    HashGrid: TStringGrid;
    MemoGuidance, MemoAudit, MemoHashDetail, MemoConfig: TMemo;
    DS: TDataSource;
    Q, QAux: TZQuery;
    FSortField: string;
    FSortDesc: Boolean;
    FHashSortColumn: Integer;
    FHashSortAscending: Boolean;

    procedure BuildUI;
    procedure LoadYears;
    procedure RefreshData;
    procedure RefreshSummary;
    procedure RefreshDashboard;
    procedure SetupColumns;
    procedure UpdateButtons;
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnBulkRetryClick(Sender: TObject);
    procedure BtnMonitorClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure CbChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DataAfterScroll(DataSet: TDataSet);
    procedure GridTitleClick(Column: TColumn);
    function SortExpressionForField(const AField: string): string;
    procedure RefreshSelectedDetail;
    function IncidentClassification: string;
    function RecommendedAction: string;
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    function SelectedYear: Integer;
    function SelectedEnvironment: string;
    function SelectedOrigin: string;
    function EnvironmentWhereSQL: string;
    function OriginWhereSQL: string;
    function SafeTienda(const S: string): string;
    function TechnicalWhereSQL: string;
    function CountFor(const ExtraWhere: string): Integer;
    function ConfirmBulkRetry(const AYear, ACount: Integer): Boolean;
    procedure RunHashAudit;
    procedure BtnRunAuditClick(Sender: TObject);
    procedure RunConfigurationAudit;
    procedure BtnRunConfigAuditClick(Sender: TObject);
    procedure BtnHealthCenterClick(Sender: TObject);
    procedure BtnTechnicalValidatorClick(Sender: TObject);
    procedure BtnSubsanacionesClick(Sender: TObject);
    procedure BtnTraceabilityClick(Sender: TObject);
    procedure LoadHashIntegrity;
    procedure BtnHashRefreshClick(Sender: TObject);
    procedure HashGridClick(Sender: TObject);
    procedure HashGridHeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer);
    procedure SortHashGrid(const AColumn: Integer);
    procedure RefreshHashDetail;
    function ShortHash(const S: string): string;
  public
    constructor CreateWith(const Conn: TZConnection; const ATienda: string); reintroduce;
  end;

procedure VFC_OpenControl(const Conn: TZConnection; const Tienda: string);
var
  F: TfrmVFCentroControl;
  MigrationError: string;
begin
  if Conn = nil then
  begin
    ShowMessage('Centro de Control VeriFactu: conexión no asignada.');
    Exit;
  end;
  if not Conn.Connected then
  begin
    ShowMessage('Centro de Control VeriFactu: la conexión a la base de datos no está activa.');
    Exit;
  end;

  if not FLXEnsureVeriFactuAuditSchema(Conn, MigrationError) then
  begin
    MessageDlg('No se ha podido actualizar la estructura necesaria para el Centro de Control:' +
      LineEnding + MigrationError, mtError, [mbOK], 0);
    Exit;
  end;

  F := TfrmVFCentroControl.CreateWith(Conn, Tienda);
  F.Show;
end;

constructor TfrmVFCentroControl.CreateWith(const Conn: TZConnection;
  const ATienda: string);
begin
  inherited CreateNew(nil, 1);
  Caption := 'Centro de Control VeriFactu';
  Position := poScreenCenter;
  WindowState := wsMaximized;
  Width := 1450;
  Height := 820;
  KeyPreview := True;
  OnKeyDown := @FormKeyDown;

  FConn := Conn;
  FTienda := SafeTienda(ATienda);
  FSortField := 'fecha';
  FSortDesc := True;
  FHashSortColumn := -1;
  FHashSortAscending := True;

  BuildUI;

  Q := TZQuery.Create(Self);
  Q.Connection := FConn;
  Q.AfterScroll := @DataAfterScroll;
  QAux := TZQuery.Create(Self);
  QAux.Connection := FConn;

  DS := TDataSource.Create(Self);
  DS.DataSet := Q;
  Grid.DataSource := DS;
  Grid.OnTitleClick := @GridTitleClick;

  LoadYears;
  RefreshData;
end;

function TfrmVFCentroControl.SafeTienda(const S: string): string;
var
  I: Integer;
begin
  Result := Trim(S);
  if Length(Result) <> 4 then Exit('0000');
  for I := 1 to Length(Result) do
    if not (Result[I] in ['0'..'9']) then Exit('0000');
end;

procedure TfrmVFCentroControl.BuildUI;
  procedure CreateStatusLabel(var L: TLabel; AParent: TWinControl;
    const ACaption: string; ALeft, ATop, AWidth: Integer);
  begin
    L := TLabel.Create(Self);
    L.Parent := AParent;
    L.SetBounds(ALeft, ATop, AWidth, 25);
    L.Caption := ACaption;
    L.ParentFont := False;
    L.Font.Name := 'Sans';
    L.Font.Height := -13;
    L.Font.Style := [fsBold];
  end;
begin
  Color := clWhite;
  Font.Name := 'Sans';
  Font.Height := -13;

  HeaderPanel := TPanel.Create(Self);
  HeaderPanel.Parent := Self;
  HeaderPanel.Align := alTop;
  HeaderPanel.Height := 82;
  HeaderPanel.BevelOuter := bvNone;
  HeaderPanel.Color := clNavy;

  LbTitle := TLabel.Create(Self);
  LbTitle.Parent := HeaderPanel;
  LbTitle.SetBounds(18, 9, 700, 30);
  LbTitle.Caption := 'CENTRO DE CONTROL VERIFACTU';
  LbTitle.ParentFont := False;
  LbTitle.Font.Name := 'Sans';
  LbTitle.Font.Height := -22;
  LbTitle.Font.Style := [fsBold];
  LbTitle.Font.Color := clWhite;

  LbSubtitle := TLabel.Create(Self);
  LbSubtitle.Parent := HeaderPanel;
  LbSubtitle.SetBounds(18, 45, 1050, 22);
  LbSubtitle.Caption := 'Estado general, incidencias, auditoría y control de reenvíos por ejercicio y entorno.';
  LbSubtitle.ParentFont := False;
  LbSubtitle.Font.Height := -12;
  LbSubtitle.Font.Color := clSilver;

  LbTrafficLight := TLabel.Create(Self);
  LbTrafficLight.Parent := HeaderPanel;
  LbTrafficLight.SetBounds(HeaderPanel.Width - 420, 20, 260, 38);
  LbTrafficLight.Anchors := [akTop, akRight];
  LbTrafficLight.Alignment := taCenter;
  LbTrafficLight.Layout := tlCenter;
  LbTrafficLight.AutoSize := False;
  LbTrafficLight.Caption := 'COMPROBANDO...';
  LbTrafficLight.ParentFont := False;
  LbTrafficLight.Font.Name := 'Sans';
  LbTrafficLight.Font.Height := -15;
  LbTrafficLight.Font.Style := [fsBold];
  LbTrafficLight.Font.Color := clWhite;
  LbTrafficLight.Color := RGBToColor(120, 120, 120);
  LbTrafficLight.Transparent := False;

  BtnClose := TBitBtn.Create(Self);
  BtnClose.Parent := HeaderPanel;
  BtnClose.Caption := 'Cerrar';
  BtnClose.SetBounds(HeaderPanel.Width - 140, 22, 115, 34);
  BtnClose.Anchors := [akTop, akRight];
  BtnClose.OnClick := @BtnCloseClick;

  Pages := TPageControl.Create(Self);
  Pages.Parent := Self;
  Pages.Align := alClient;

  TabSummary := TTabSheet.Create(Self);
  TabSummary.PageControl := Pages;
  TabSummary.Caption := 'Resumen';

  TabRecords := TTabSheet.Create(Self);
  TabRecords.PageControl := Pages;
  TabRecords.Caption := 'Registros e incidencias';

  TabAudit := TTabSheet.Create(Self);
  TabAudit.PageControl := Pages;
  TabAudit.Caption := 'Auditoría';

  TabHash := TTabSheet.Create(Self);
  TabHash.PageControl := Pages;
  TabHash.Caption := 'Integridad HASH';

  TabConfig := TTabSheet.Create(Self);
  TabConfig.PageControl := Pages;
  TabConfig.Caption := 'Configuración';

  DashboardPanel := TPanel.Create(Self);
  DashboardPanel.Parent := TabSummary;
  DashboardPanel.Align := alClient;
  DashboardPanel.BevelOuter := bvNone;
  DashboardPanel.Color := clWhite;

  SummaryPanel := TPanel.Create(Self);
  SummaryPanel.Parent := DashboardPanel;
  SummaryPanel.SetBounds(20, 20, DashboardPanel.ClientWidth - 40, 78);
  SummaryPanel.Anchors := [akLeft, akTop, akRight];
  SummaryPanel.BevelOuter := bvNone;
  SummaryPanel.Color := RGBToColor(240, 244, 248);

  CreateStatusLabel(LbTotal, SummaryPanel, 'Registros: 0', 18, 27, 180);
  CreateStatusLabel(LbPending, SummaryPanel, 'Pendientes: 0', 215, 27, 180);
  LbPending.Font.Color := RGBToColor(145, 95, 0);
  CreateStatusLabel(LbSent, SummaryPanel, 'Enviados: 0', 410, 27, 180);
  LbSent.Font.Color := RGBToColor(20, 115, 55);
  CreateStatusLabel(LbIncidents, SummaryPanel, 'Incidencias: 0', 605, 27, 195);
  LbIncidents.Font.Color := RGBToColor(170, 35, 35);
  CreateStatusLabel(LbRetryable, SummaryPanel, 'Reintentos técnicos: 0', 815, 27, 250);
  LbRetryable.Font.Color := clNavy;

  HealthPanel := TPanel.Create(Self);
  HealthPanel.Parent := DashboardPanel;
  HealthPanel.SetBounds(20, 120, DashboardPanel.ClientWidth - 40, 350);
  HealthPanel.Anchors := [akLeft, akTop, akRight];
  HealthPanel.BevelOuter := bvNone;
  HealthPanel.Color := RGBToColor(248, 250, 252);

  CreateStatusLabel(LbCommunication, HealthPanel, 'Comunicaciones AEAT: comprobando', 28, 30, 620);
  CreateStatusLabel(LbHash, HealthPanel, 'Cadena HASH: pendiente de auditoría', 28, 80, 620);
  CreateStatusLabel(LbQueue, HealthPanel, 'Cola de envío: comprobando', 28, 130, 620);
  CreateStatusLabel(LbEnvironmentState, HealthPanel, 'Entorno: comprobando', 28, 180, 720);
  CreateStatusLabel(LbLastCommunication, HealthPanel, 'Última comunicación: sin datos', 28, 230, 720);
  CreateStatusLabel(LbDeclaration, HealthPanel, 'Declaración responsable: EN PREPARACIÓN', 28, 280, 720);
  LbDeclaration.Font.Color := RGBToColor(145, 95, 0);

  LbHint := TLabel.Create(Self);
  LbHint.Parent := DashboardPanel;
  LbHint.SetBounds(24, 495, DashboardPanel.ClientWidth - 48, 45);
  LbHint.Anchors := [akLeft, akTop, akRight];
  LbHint.WordWrap := True;
  LbHint.Caption := 'El semáforo resume el ejercicio y entorno seleccionados en la pestaña Registros. La pestaña Integridad HASH permite inspeccionar la cadena, las huellas y el canonical sin modificar ningún registro.';
  LbHint.Font.Color := clGray;

  BtnHealthCenter := TBitBtn.Create(Self);
  BtnHealthCenter.Parent := DashboardPanel;
  BtnHealthCenter.SetBounds(24, 548, 310, 42);
  BtnHealthCenter.Caption := 'Abrir Centro de Salud de FacturLinEx';
  BtnHealthCenter.Font.Style := [fsBold];
  BtnHealthCenter.OnClick := @BtnHealthCenterClick;

  TopPanel := TPanel.Create(Self);
  TopPanel.Parent := TabRecords;
  TopPanel.Align := alTop;
  TopPanel.Height := 126;
  TopPanel.BevelOuter := bvNone;
  TopPanel.Color := clWhite;

  FilterPanel := TPanel.Create(Self);
  FilterPanel.Parent := TopPanel;
  FilterPanel.SetBounds(14, 10, TopPanel.ClientWidth - 28, 54);
  FilterPanel.Anchors := [akLeft, akTop, akRight];
  FilterPanel.BevelOuter := bvNone;
  FilterPanel.Color := RGBToColor(250, 250, 250);

  LbYear := TLabel.Create(Self); LbYear.Parent := FilterPanel;
  LbYear.SetBounds(12, 17, 70, 22); LbYear.Caption := 'Ejercicio'; LbYear.Font.Style := [fsBold];
  CbYear := TComboBox.Create(Self); CbYear.Parent := FilterPanel;
  CbYear.SetBounds(82, 12, 105, 30); CbYear.Style := csDropDownList; CbYear.OnChange := @CbChange;

  LbScope := TLabel.Create(Self); LbScope.Parent := FilterPanel;
  LbScope.SetBounds(210, 17, 55, 22); LbScope.Caption := 'Estado'; LbScope.Font.Style := [fsBold];
  CbState := TComboBox.Create(Self); CbState.Parent := FilterPanel;
  CbState.SetBounds(270, 12, 210, 30); CbState.Style := csDropDownList;
  CbState.Items.Add('Todos'); CbState.Items.Add('Pendientes'); CbState.Items.Add('Enviados');
  CbState.Items.Add('Incidencias'); CbState.Items.Add('Reintentos técnicos'); CbState.ItemIndex := 0;
  CbState.OnChange := @CbChange;

  LbEnvironment := TLabel.Create(Self); LbEnvironment.Parent := FilterPanel;
  LbEnvironment.SetBounds(500, 17, 65, 22); LbEnvironment.Caption := 'Entorno'; LbEnvironment.Font.Style := [fsBold];
  CbEnvironment := TComboBox.Create(Self); CbEnvironment.Parent := FilterPanel;
  CbEnvironment.SetBounds(568, 12, 165, 30); CbEnvironment.Style := csDropDownList;
  CbEnvironment.Items.Add('PRODUCCION'); CbEnvironment.Items.Add('PRUEBAS');
  CbEnvironment.Items.Add('SIN CLASIFICAR'); CbEnvironment.Items.Add('TODOS (solo consulta)');
  if (UpperCase(Trim(vfMode)) = 'PRUEBAS') or (UpperCase(Trim(vfMode)) = 'TEST') then
    CbEnvironment.ItemIndex := 1 else CbEnvironment.ItemIndex := 0;
  CbEnvironment.OnChange := @CbChange;

  LbOrigin := TLabel.Create(Self); LbOrigin.Parent := FilterPanel;
  LbOrigin.SetBounds(748, 17, 55, 22); LbOrigin.Caption := 'Origen'; LbOrigin.Font.Style := [fsBold];
  CbOrigin := TComboBox.Create(Self); CbOrigin.Parent := FilterPanel;
  CbOrigin.SetBounds(808, 12, 180, 30); CbOrigin.Style := csDropDownList;
  CbOrigin.Items.Add('TODOS');
  CbOrigin.Items.Add('NORMAL');
  CbOrigin.Items.Add('RECTIFICATIVA');
  CbOrigin.Items.Add('SUBSANACION');
  CbOrigin.Items.Add('SIN CLASIFICAR');
  CbOrigin.ItemIndex := 0;
  CbOrigin.OnChange := @CbChange;

  ActionPanel := TPanel.Create(Self);
  ActionPanel.Parent := TopPanel;
  ActionPanel.SetBounds(14, 70, TopPanel.ClientWidth - 28, 48);
  ActionPanel.Anchors := [akLeft, akTop, akRight];
  ActionPanel.BevelOuter := bvNone; ActionPanel.Color := clWhite;

  BtnRefresh := TBitBtn.Create(Self); BtnRefresh.Parent := ActionPanel;
  BtnRefresh.Caption := 'Refrescar'; BtnRefresh.SetBounds(0, 7, 120, 34); BtnRefresh.OnClick := @BtnRefreshClick;
  BtnBulkRetry := TBitBtn.Create(Self); BtnBulkRetry.Parent := ActionPanel;
  BtnBulkRetry.Caption := 'Preparar reenvío técnico del ejercicio'; BtnBulkRetry.SetBounds(132, 7, 300, 34);
  BtnBulkRetry.Font.Style := [fsBold]; BtnBulkRetry.OnClick := @BtnBulkRetryClick;
  BtnTechnicalMonitor := TBitBtn.Create(Self); BtnTechnicalMonitor.Parent := ActionPanel;
  BtnTechnicalMonitor.Caption := 'Abrir monitor técnico'; BtnTechnicalMonitor.SetBounds(444, 7, 190, 34);
  BtnTechnicalMonitor.OnClick := @BtnMonitorClick;

  BtnSubsanaciones := TBitBtn.Create(Self);
  BtnSubsanaciones.Parent := ActionPanel;
  BtnSubsanaciones.SetBounds(650, 6, 235, 36);
  BtnSubsanaciones.Caption := 'Control de subsanaciones';
  BtnSubsanaciones.Font.Style := [fsBold];
  BtnSubsanaciones.OnClick := @BtnSubsanacionesClick;

  BtnTraceability := TBitBtn.Create(Self);
  BtnTraceability.Parent := ActionPanel;
  BtnTraceability.SetBounds(900, 6, 205, 36);
  BtnTraceability.Caption := 'Ver trazabilidad';
  BtnTraceability.Font.Style := [fsBold];
  BtnTraceability.OnClick := @BtnTraceabilityClick;

  DetailPanel := TPanel.Create(Self);
  DetailPanel.Parent := TabRecords;
  DetailPanel.Align := alBottom;
  DetailPanel.Height := 190;
  DetailPanel.BevelOuter := bvNone;
  DetailPanel.Color := RGBToColor(246, 248, 251);

  LbDetailTitle := TLabel.Create(Self); LbDetailTitle.Parent := DetailPanel;
  LbDetailTitle.SetBounds(14, 10, 310, 24); LbDetailTitle.Caption := 'DIAGNÓSTICO Y ACTUACIÓN RECOMENDADA';
  LbDetailTitle.Font.Style := [fsBold]; LbDetailTitle.Font.Color := clNavy;
  LbClassification := TLabel.Create(Self); LbClassification.Parent := DetailPanel;
  LbClassification.SetBounds(340, 10, 700, 24); LbClassification.Caption := 'Selecciona un registro para revisar su situación.';
  LbClassification.Font.Style := [fsBold];
  MemoGuidance := TMemo.Create(Self); MemoGuidance.Parent := DetailPanel;
  MemoGuidance.SetBounds(14, 40, DetailPanel.ClientWidth - 28, 136);
  MemoGuidance.Anchors := [akLeft, akTop, akRight, akBottom]; MemoGuidance.ReadOnly := True;
  MemoGuidance.ScrollBars := ssAutoVertical; MemoGuidance.WordWrap := True; MemoGuidance.Color := clWhite;
  MemoGuidance.TabStop := False; MemoGuidance.Lines.Text := 'Selecciona un registro de la tabla para ver el diagnóstico.';

  Grid := TDBGrid.Create(Self);
  Grid.Parent := TabRecords;
  Grid.Align := alClient;
  Grid.Options := Grid.Options + [dgTitles, dgIndicator, dgRowSelect, dgAutoSizeColumns];
  Grid.Color := clWhite; Grid.FixedColor := RGBToColor(226, 230, 235);
  Grid.DefaultDrawing := False; Grid.OnDrawColumnCell := @GridDrawColumnCell;

  BtnRunAudit := TBitBtn.Create(Self);
  BtnRunAudit.Parent := TabAudit;
  BtnRunAudit.Caption := 'Comprobar cadena HASH';
  BtnRunAudit.SetBounds(18, 16, 220, 38);
  BtnRunAudit.Font.Style := [fsBold];
  BtnRunAudit.OnClick := @BtnRunAuditClick;

  BtnTechnicalValidator := TBitBtn.Create(Self);
  BtnTechnicalValidator.Parent := TabAudit;
  BtnTechnicalValidator.Caption := 'Validador técnico V1.1';
  BtnTechnicalValidator.SetBounds(252, 16, 220, 38);
  BtnTechnicalValidator.Font.Style := [fsBold];
  BtnTechnicalValidator.OnClick := @BtnTechnicalValidatorClick;

  MemoAudit := TMemo.Create(Self);
  MemoAudit.Parent := TabAudit;
  MemoAudit.SetBounds(18, 68, TabAudit.ClientWidth - 36, TabAudit.ClientHeight - 86);
  MemoAudit.Anchors := [akLeft, akTop, akRight, akBottom];
  MemoAudit.ReadOnly := True;
  MemoAudit.ScrollBars := ssAutoBoth;
  MemoAudit.WordWrap := False;
  MemoAudit.Color := clWhite;
  MemoAudit.Font.Name := 'Monospace';
  MemoAudit.Font.Height := -12;
  MemoAudit.Lines.Text :=
    'AUDITORÍA VERIFACTU' + LineEnding +
    '-------------------' + LineEnding +
    'Selecciona ejercicio y entorno en Registros e incidencias y pulsa Comprobar cadena HASH.' + LineEnding +
    'La comprobación es únicamente de lectura y no modifica ningún registro.';


  HashTopPanel := TPanel.Create(Self);
  HashTopPanel.Parent := TabHash;
  HashTopPanel.Align := alTop;
  HashTopPanel.Height := 92;
  HashTopPanel.BevelOuter := bvNone;
  HashTopPanel.Color := RGBToColor(248, 250, 252);

  LbHashTotal := TLabel.Create(Self);
  LbHashTotal.Parent := HashTopPanel;
  LbHashTotal.SetBounds(18, 16, 175, 24);
  LbHashTotal.Caption := 'Revisados: 0';
  LbHashTotal.Font.Style := [fsBold];

  LbHashOK := TLabel.Create(Self);
  LbHashOK.Parent := HashTopPanel;
  LbHashOK.SetBounds(205, 16, 175, 24);
  LbHashOK.Caption := 'Correctos: 0';
  LbHashOK.Font.Style := [fsBold];
  LbHashOK.Font.Color := RGBToColor(20, 115, 55);

  LbHashWarnings := TLabel.Create(Self);
  LbHashWarnings.Parent := HashTopPanel;
  LbHashWarnings.SetBounds(392, 16, 210, 24);
  LbHashWarnings.Caption := 'No verificables: 0';
  LbHashWarnings.Font.Style := [fsBold];
  LbHashWarnings.Font.Color := RGBToColor(185, 105, 15);

  LbHashErrors := TLabel.Create(Self);
  LbHashErrors.Parent := HashTopPanel;
  LbHashErrors.SetBounds(614, 16, 210, 24);
  LbHashErrors.Caption := 'Incidencias: 0';
  LbHashErrors.Font.Style := [fsBold];
  LbHashErrors.Font.Color := RGBToColor(185, 45, 45);

  LbHashFilter := TLabel.Create(Self);
  LbHashFilter.Parent := HashTopPanel;
  LbHashFilter.SetBounds(18, 52, 880, 24);
  LbHashFilter.Caption := 'Filtro: pendiente de cargar';
  LbHashFilter.Font.Color := clGray;

  BtnHashRefresh := TBitBtn.Create(Self);
  BtnHashRefresh.Parent := HashTopPanel;
  BtnHashRefresh.Caption := 'Comprobar integridad';
  BtnHashRefresh.SetBounds(HashTopPanel.ClientWidth - 225, 24, 195, 40);
  BtnHashRefresh.Anchors := [akTop, akRight];
  BtnHashRefresh.Font.Style := [fsBold];
  BtnHashRefresh.OnClick := @BtnHashRefreshClick;

  HashDetailPanel := TPanel.Create(Self);
  HashDetailPanel.Parent := TabHash;
  HashDetailPanel.Align := alBottom;
  HashDetailPanel.Height := 255;
  HashDetailPanel.BevelOuter := bvNone;
  HashDetailPanel.Color := RGBToColor(248, 250, 252);

  MemoHashDetail := TMemo.Create(Self);
  MemoHashDetail.Parent := HashDetailPanel;
  MemoHashDetail.Align := alClient;
  MemoHashDetail.BorderSpacing.Around := 10;
  MemoHashDetail.ReadOnly := True;
  MemoHashDetail.ScrollBars := ssAutoBoth;
  MemoHashDetail.WordWrap := False;
  MemoHashDetail.Color := clWhite;
  MemoHashDetail.Font.Name := 'Monospace';
  MemoHashDetail.Font.Height := -11;
  MemoHashDetail.Lines.Text :=
    'Selecciona un registro para ver HASH, HASH PREV, HASH INPUT, CANONICAL y FECHA ISO completa.';

  HashGrid := TStringGrid.Create(Self);
  HashGrid.Parent := TabHash;
  HashGrid.Align := alClient;
  HashGrid.FixedRows := 1;
  HashGrid.FixedCols := 0;
  HashGrid.ColCount := 10;
  HashGrid.RowCount := 1;
  HashGrid.Options := HashGrid.Options + [goRowSelect, goFixedVertLine, goFixedHorzLine,
    goVertLine, goHorzLine];
  HashGrid.DefaultRowHeight := 26;
  HashGrid.Color := clWhite;
  HashGrid.FixedColor := RGBToColor(226, 230, 235);
  HashGrid.OnClick := @HashGridClick;
  HashGrid.OnHeaderClick := @HashGridHeaderClick;

  HashGrid.Cells[0,0] := 'ID';
  HashGrid.Cells[1,0] := 'Estado';
  HashGrid.Cells[2,0] := 'Fecha';
  HashGrid.Cells[3,0] := 'Hora';
  HashGrid.Cells[4,0] := 'Serie';
  HashGrid.Cells[5,0] := 'Número';
  HashGrid.Cells[6,0] := 'Tipo';
  HashGrid.Cells[7,0] := 'HASH';
  HashGrid.Cells[8,0] := 'HASH PREV';
  HashGrid.Cells[9,0] := 'SHA-256';

  HashGrid.ColWidths[0] := 70;
  HashGrid.ColWidths[1] := 175;
  HashGrid.ColWidths[2] := 90;
  HashGrid.ColWidths[3] := 75;
  HashGrid.ColWidths[4] := 95;
  HashGrid.ColWidths[5] := 75;
  HashGrid.ColWidths[6] := 65;
  HashGrid.ColWidths[7] := 180;
  HashGrid.ColWidths[8] := 180;
  HashGrid.ColWidths[9] := 145;

  BtnRunConfigAudit := TBitBtn.Create(Self);
  BtnRunConfigAudit.Parent := TabConfig;
  BtnRunConfigAudit.Caption := 'Ejecutar auditoría general';
  BtnRunConfigAudit.SetBounds(18, 16, 230, 38);
  BtnRunConfigAudit.Font.Style := [fsBold];
  BtnRunConfigAudit.OnClick := @BtnRunConfigAuditClick;

  MemoConfig := TMemo.Create(Self);
  MemoConfig.Parent := TabConfig;
  MemoConfig.SetBounds(18, 68, TabConfig.ClientWidth - 36, TabConfig.ClientHeight - 86);
  MemoConfig.Anchors := [akLeft, akTop, akRight, akBottom];
  MemoConfig.ReadOnly := True;
  MemoConfig.ScrollBars := ssAutoBoth;
  MemoConfig.WordWrap := False;
  MemoConfig.Color := clWhite;
  MemoConfig.Font.Name := 'Monospace';
  MemoConfig.Font.Height := -12;
  MemoConfig.Lines.Text :=
    'AUDITORÍA DE CONFIGURACIÓN VERIFACTU' + LineEnding +
    '------------------------------------' + LineEnding +
    'Esta comprobación es únicamente de lectura.' + LineEnding +
    'No prueba envíos, no contacta con la AEAT y no modifica la configuración.';

  Pages.ActivePage := TabSummary;
end;

procedure TfrmVFCentroControl.LoadYears;
var
  CurrentYear, Y: Integer;
begin
  CurrentYear := YearOf(Date);
  CbYear.Items.Clear;

  QAux.Close;
  QAux.SQL.Text :=
    'SELECT DISTINCT YEAR(fecha) AS ejercicio FROM verifactu_queue ' +
    'WHERE fecha IS NOT NULL ORDER BY ejercicio DESC';
  try
    QAux.Open;
    while not QAux.EOF do
    begin
      Y := QAux.FieldByName('ejercicio').AsInteger;
      if Y > 0 then CbYear.Items.Add(IntToStr(Y));
      QAux.Next;
    end;
  except
    { Si la tabla está vacía o aún no existe, al menos ofrecemos el año actual. }
  end;

  if CbYear.Items.IndexOf(IntToStr(CurrentYear)) < 0 then
    CbYear.Items.Insert(0, IntToStr(CurrentYear));
  CbYear.ItemIndex := CbYear.Items.IndexOf(IntToStr(CurrentYear));
  if CbYear.ItemIndex < 0 then CbYear.ItemIndex := 0;
end;

function TfrmVFCentroControl.SelectedYear: Integer;
begin
  Result := StrToIntDef(CbYear.Text, YearOf(Date));
end;

function TfrmVFCentroControl.SelectedEnvironment: string;
begin
  case CbEnvironment.ItemIndex of
    0: Result := 'PRODUCCION';
    1: Result := 'PRUEBAS';
    2: Result := 'SIN_CLASIFICAR';
  else
    Result := '';
  end;
end;

function TfrmVFCentroControl.SelectedOrigin: string;
begin
  case CbOrigin.ItemIndex of
    1: Result := 'NORMAL';
    2: Result := 'RECTIFICATIVA';
    3: Result := 'SUBSANACION';
    4: Result := 'SIN_CLASIFICAR';
  else
    Result := '';
  end;
end;

function TfrmVFCentroControl.EnvironmentWhereSQL: string;
var
  E: string;
begin
  E := SelectedEnvironment;
  if E = '' then
    Result := ''
  else
    Result := ' AND COALESCE(q.entorno,''SIN_CLASIFICAR'')=' + QuotedStr(E) + ' ';
end;

function TfrmVFCentroControl.OriginWhereSQL: string;
var
  O: string;
begin
  O := SelectedOrigin;
  if O = '' then
    Result := ''
  else
    Result := ' AND COALESCE(q.origen,''SIN_CLASIFICAR'')=' + QuotedStr(O) + ' ';
end;

function TfrmVFCentroControl.TechnicalWhereSQL: string;
begin
  Result :=
    ' AND (' +
    ' q.estado = ''PENDIENTE'' ' +
    ' OR (' +
    '   q.estado = ''ERROR'' ' +
    '   AND COALESCE(q.respuesta_text,'''') NOT LIKE ''%EstadoRegistro>Incorrecto%'' ' +
    '   AND COALESCE(q.respuesta_text,'''') NOT LIKE ''%EstadoRegistro>AceptadoConErrores%'' ' +
    '   AND (' +
    '     COALESCE(q.last_error,'''') LIKE ''%SockErr%'' ' +
    '     OR COALESCE(q.last_error,'''') LIKE ''%SSLErr%'' ' +
    '     OR COALESCE(q.last_error,'''') LIKE ''%HTTP%'' ' +
    '     OR COALESCE(q.last_error,'''') LIKE ''%conexi%'' ' +
    '     OR COALESCE(q.last_error,'''') LIKE ''%timeout%'' ' +
    '     OR COALESCE(q.last_error,'''') LIKE ''%certific%'' ' +
    '     OR COALESCE(q.last_error,'''') LIKE ''%PEM%'' ' +
    '     OR COALESCE(q.respuesta_text,'''') LIKE ''%<env:Fault%'' ' +
    '     OR COALESCE(q.respuesta_text,'''') LIKE ''%<soap:Fault%'' ' +
    '     OR COALESCE(q.respuesta_text,'''') LIKE ''%faultstring%'' ' +
    '     OR COALESCE(q.respuesta_text,'''') LIKE ''%<wsdl:definitions%'' ' +
    '     OR COALESCE(q.respuesta_text,'''') LIKE ''%SistemaFacturacion.wsdl%'' ' +
    '     OR COALESCE(q.respuesta_text,'''') LIKE ''%404%'' ' +
    '     OR COALESCE(q.respuesta_text,'''') LIKE ''%SOAPAction%'' ' +
    '     OR COALESCE(q.respuesta_text,'''') LIKE ''%endpoint%'' ' +
    '   )' +
    ' )' +
    ')';
end;

procedure TfrmVFCentroControl.RefreshData;
var
  StateWhere, SortExpr, SortDir: string;
  SavedID: Int64;
begin
  SavedID := 0;
  if Q.Active and (not Q.IsEmpty) and (Q.FindField('id') <> nil) then
    SavedID := Q.FieldByName('id').AsLargeInt;
  StateWhere := '';
  case CbState.ItemIndex of
    1: StateWhere := ' AND q.estado = ''PENDIENTE'' ';
    2: StateWhere := ' AND q.estado = ''ENVIADO'' ';
    3: StateWhere := ' AND (q.estado = ''ERROR'' OR COALESCE(q.respuesta_text,'''') LIKE ''%AceptadoConErrores%'') ';
    4: StateWhere := TechnicalWhereSQL;
  end;

  Q.Close;
  Q.SQL.Text :=
    'SELECT q.id, q.fecha, q.hora, q.serie, q.numero, q.tipo_factura, q.origen, q.registro_uid, q.entorno, ' +
    'q.total_con_iva, q.estado, q.intentos, q.last_attempt_at, ' +
    'COALESCE(q.hash_fecha_huso,'''') AS fecha_hora_generacion, ' +
    'q.last_error, q.respuesta_text, LEFT(COALESCE(q.last_error,''''),240) AS ultimo_error, ' +
    'CASE ' +
    ' WHEN COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>Correcto%'' THEN ''CORRECTO'' ' +
    ' WHEN COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>AceptadoConErrores%'' THEN ''ACEPTADO CON ERRORES'' ' +
    ' WHEN COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>Incorrecto%'' THEN ''INCORRECTO AEAT'' ' +
    ' WHEN q.estado = ''ERROR'' THEN ''ERROR'' ' +
    ' ELSE q.estado END AS resultado ' +
    'FROM verifactu_queue q ' +
    'WHERE YEAR(q.fecha)=:Y ' + EnvironmentWhereSQL + OriginWhereSQL + StateWhere;

  SortExpr := SortExpressionForField(FSortField);
  if SortExpr = '' then
    SortExpr := 'q.fecha';

  if FSortDesc then
    SortDir := ' DESC'
  else
    SortDir := ' ASC';

  Q.SQL.Text := Q.SQL.Text + ' ORDER BY ' + SortExpr + SortDir + ', q.id DESC';
  Q.ParamCheck := True;
  Q.ParamByName('Y').AsInteger := SelectedYear;
  try
    Q.Open;
    SetupColumns;
    if SavedID > 0 then
      Q.Locate('id', SavedID, []);
    RefreshSummary;
    RefreshDashboard;
    UpdateButtons;
    RefreshSelectedDetail;
  except
    on E: Exception do
      ShowMessage('No se ha podido consultar el Centro de Control VeriFactu:' + LineEnding + E.Message);
  end;
end;

procedure TfrmVFCentroControl.SetupColumns;
  procedure AddCol(const F, T: string; W: Integer);
  var C: TColumn;
  begin
    C := Grid.Columns.Add;
    C.FieldName := F;
    C.Title.Caption := T;
    if SameText(FSortField, F) then
    begin
      if FSortDesc then
        C.Title.Caption := T + ' ▼'
      else
        C.Title.Caption := T + ' ▲';
    end;
    C.Width := W;
  end;
begin
  if not Q.Active then Exit;
  Grid.Columns.BeginUpdate;
  try
    Grid.Columns.Clear;
    AddCol('fecha', 'Fecha', 90);
    AddCol('hora', 'Hora', 75);
    AddCol('serie', 'Serie', 95);
    AddCol('numero', 'Número', 70);
    AddCol('tipo_factura', 'Tipo', 65);
    AddCol('origen', 'Origen', 125);
    AddCol('registro_uid', 'Registro', 110);
    AddCol('entorno', 'Entorno', 110);
    AddCol('total_con_iva', 'Total', 90);
    AddCol('estado', 'Cola', 95);
    AddCol('resultado', 'Resultado', 165);
    AddCol('intentos', 'Intentos', 65);
    AddCol('last_attempt_at', 'Último intento', 145);
    AddCol('fecha_hora_generacion', 'Fecha/hora generación', 190);
    AddCol('ultimo_error', 'Diagnóstico', 430);
  finally
    Grid.Columns.EndUpdate;
  end;
end;


function TfrmVFCentroControl.SortExpressionForField(const AField: string): string;
begin
  Result := '';

  if SameText(AField, 'id') then Result := 'q.id'
  else if SameText(AField, 'fecha') then Result := 'q.fecha'
  else if SameText(AField, 'hora') then Result := 'q.hora'
  else if SameText(AField, 'serie') then Result := 'q.serie'
  else if SameText(AField, 'numero') then Result := 'q.numero'
  else if SameText(AField, 'tipo_factura') then Result := 'q.tipo_factura'
  else if SameText(AField, 'origen') then Result := 'q.origen'
  else if SameText(AField, 'registro_uid') then Result := 'q.registro_uid'
  else if SameText(AField, 'entorno') then Result := 'q.entorno'
  else if SameText(AField, 'total_con_iva') then Result := 'q.total_con_iva'
  else if SameText(AField, 'estado') then Result := 'q.estado'
  else if SameText(AField, 'resultado') then Result := 'resultado'
  else if SameText(AField, 'intentos') then Result := 'q.intentos'
  else if SameText(AField, 'last_attempt_at') then Result := 'q.last_attempt_at'
  else if SameText(AField, 'fecha_hora_generacion') then Result := 'fecha_hora_generacion'
  else if SameText(AField, 'ultimo_error') then Result := 'ultimo_error';
end;

procedure TfrmVFCentroControl.GridTitleClick(Column: TColumn);
var
  FieldName: string;
begin
  if (Column = nil) or (Column.Field = nil) then Exit;

  FieldName := Column.Field.FieldName;
  if SortExpressionForField(FieldName) = '' then Exit;

  if SameText(FSortField, FieldName) then
    FSortDesc := not FSortDesc
  else
  begin
    FSortField := FieldName;
    FSortDesc := False;
  end;

  RefreshData;
end;

function TfrmVFCentroControl.CountFor(const ExtraWhere: string): Integer;
begin
  Result := 0;
  QAux.Close;
  QAux.SQL.Text :=
    'SELECT COUNT(*) AS n FROM verifactu_queue q WHERE YEAR(q.fecha)=:Y ' +
    EnvironmentWhereSQL + OriginWhereSQL + ExtraWhere;
  QAux.ParamCheck := True;
  QAux.ParamByName('Y').AsInteger := SelectedYear;
  QAux.Open;
  Result := QAux.FieldByName('n').AsInteger;
end;

procedure TfrmVFCentroControl.RefreshSummary;
var
  Total, Pending, Sent, Incidents, Retryable: Integer;
begin
  Total := CountFor('');
  Pending := CountFor(' AND q.estado=''PENDIENTE'' ');
  Sent := CountFor(' AND q.estado=''ENVIADO'' ');
  Incidents := CountFor(
    ' AND (q.estado=''ERROR'' OR COALESCE(q.respuesta_text,'''') LIKE ''%AceptadoConErrores%'' ' +
    ' OR COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>Incorrecto%'') ');
  Retryable := CountFor(TechnicalWhereSQL);

  LbTotal.Caption := 'Registros: ' + IntToStr(Total);
  LbPending.Caption := 'Pendientes: ' + IntToStr(Pending);
  LbSent.Caption := 'Enviados: ' + IntToStr(Sent);
  LbIncidents.Caption := 'Incidencias: ' + IntToStr(Incidents);
  LbRetryable.Caption := 'Reintentos técnicos: ' + IntToStr(Retryable);
end;

procedure TfrmVFCentroControl.RefreshDashboard;
var
  Pending, Incidents, Retryable: Integer;
  LastComm: string;
begin
  Pending := CountFor(' AND q.estado=''PENDIENTE'' ');
  Incidents := CountFor(
    ' AND (q.estado=''ERROR'' OR COALESCE(q.respuesta_text,'''') LIKE ''%AceptadoConErrores%'' ' +
    ' OR COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>Incorrecto%'') ');
  Retryable := CountFor(TechnicalWhereSQL);

  if Incidents > 0 then
  begin
    LbTrafficLight.Caption := 'ACTUACIÓN NECESARIA';
    LbTrafficLight.Color := RGBToColor(170, 35, 35);
  end
  else if (Pending > 0) or (Retryable > 0) then
  begin
    LbTrafficLight.Caption := 'REVISAR';
    LbTrafficLight.Color := RGBToColor(190, 120, 0);
  end
  else
  begin
    LbTrafficLight.Caption := 'TODO CORRECTO';
    LbTrafficLight.Color := RGBToColor(20, 125, 60);
  end;

  if Incidents > 0 then
  begin
    LbCommunication.Caption := 'Comunicaciones AEAT: existen incidencias registradas';
    LbCommunication.Font.Color := RGBToColor(170, 35, 35);
  end
  else
  begin
    LbCommunication.Caption := 'Comunicaciones AEAT: sin rechazos detectados en el filtro actual';
    LbCommunication.Font.Color := RGBToColor(20, 115, 55);
  end;

  if Pending = 0 then
  begin
    LbQueue.Caption := 'Cola de envío: sin pendientes';
    LbQueue.Font.Color := RGBToColor(20, 115, 55);
  end
  else
  begin
    LbQueue.Caption := 'Cola de envío: ' + IntToStr(Pending) + ' pendientes';
    LbQueue.Font.Color := RGBToColor(145, 95, 0);
  end;

  if SelectedEnvironment = '' then
    LbEnvironmentState.Caption := 'Entorno consultado: TODOS (solo consulta) · Ejercicio ' + IntToStr(SelectedYear)
  else
    LbEnvironmentState.Caption := 'Entorno consultado: ' + SelectedEnvironment + ' · Ejercicio ' + IntToStr(SelectedYear);

  QAux.Close;
  QAux.SQL.Text :=
    'SELECT MAX(COALESCE(last_attempt_at, updated_at)) AS ultima ' +
    'FROM verifactu_queue q WHERE YEAR(q.fecha)=:Y ' + EnvironmentWhereSQL + OriginWhereSQL + OriginWhereSQL;
  QAux.ParamCheck := True;
  QAux.ParamByName('Y').AsInteger := SelectedYear;
  try
    QAux.Open;
    if QAux.FieldByName('ultima').IsNull then
      LastComm := 'sin datos'
    else
      LastComm := QAux.FieldByName('ultima').AsString;
  except
    LastComm := 'no disponible';
  end;
  LbLastCommunication.Caption := 'Última actividad registrada: ' + LastComm;
end;

procedure TfrmVFCentroControl.UpdateButtons;
begin
  BtnBulkRetry.Enabled := (SelectedEnvironment = 'PRODUCCION') or
    (SelectedEnvironment = 'PRUEBAS');
  BtnBulkRetry.Enabled := BtnBulkRetry.Enabled and (CountFor(TechnicalWhereSQL) > 0);
end;

function TfrmVFCentroControl.ConfirmBulkRetry(const AYear, ACount: Integer): Boolean;
begin
  Result := MessageDlg(
    'Preparar reenvío técnico',
    'Ejercicio seleccionado: ' + IntToStr(AYear) + LineEnding +
    'Entorno seleccionado: ' + SelectedEnvironment + LineEnding +
    'Registros afectados: ' + IntToStr(ACount) + LineEnding + LineEnding +
    'Solo se incluirán pendientes y errores técnicos.' + LineEnding +
    'Los registros Incorrectos o Aceptados con errores por la AEAT quedarán excluidos.' + LineEnding + LineEnding +
    '¿Deseas continuar?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

procedure TfrmVFCentroControl.BtnBulkRetryClick(Sender: TObject);
var
  N, Y: Integer;
begin
  Y := SelectedYear;
  if not ((SelectedEnvironment = 'PRODUCCION') or
          (SelectedEnvironment = 'PRUEBAS')) then
  begin
    ShowMessage('Para un reenvío masivo debes seleccionar expresamente PRODUCCION o PRUEBAS.' +
      LineEnding + 'SIN CLASIFICAR y TODOS son opciones de consulta, nunca de reenvío.');
    Exit;
  end;
  N := CountFor(TechnicalWhereSQL);
  if N = 0 then
  begin
    ShowMessage('No hay registros técnicamente reintentables en el ejercicio ' + IntToStr(Y) + '.');
    Exit;
  end;
  if not ConfirmBulkRetry(Y, N) then Exit;

  QAux.Close;
  QAux.SQL.Text :=
    'UPDATE verifactu_queue q SET ' +
    'estado=''PENDIENTE'', intentos=0, last_error=NULL, respuesta_text=NULL, ' +
    'updated_at=NOW(), last_attempt_at=NULL, token=NULL, claimed_until=NULL ' +
    'WHERE YEAR(q.fecha)=:Y ' + EnvironmentWhereSQL + OriginWhereSQL + TechnicalWhereSQL;
  QAux.ParamCheck := True;
  QAux.ParamByName('Y').AsInteger := Y;
  try
    QAux.ExecSQL;
    ShowMessage(IntToStr(QAux.RowsAffected) +
      ' registros del ejercicio ' + IntToStr(Y) +
      ' y entorno ' + SelectedEnvironment +
      ' han quedado preparados para reenvío técnico.');
    RefreshData;
  except
    on E: Exception do
      ShowMessage('No se ha podido preparar el reenvío:' + LineEnding + E.Message);
  end;
end;

procedure TfrmVFCentroControl.BtnRefreshClick(Sender: TObject);
begin
  RefreshData;
end;

procedure TfrmVFCentroControl.BtnMonitorClick(Sender: TObject);
begin
  VFQ_OpenMonitor(FConn, FTienda);
end;

procedure TfrmVFCentroControl.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmVFCentroControl.CbChange(Sender: TObject);
begin
  RefreshData;
end;

procedure TfrmVFCentroControl.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfrmVFCentroControl.DataAfterScroll(DataSet: TDataSet);
begin
  RefreshSelectedDetail;
end;

function TfrmVFCentroControl.IncidentClassification: string;
var
  Estado, Respuesta, ErrorTxt, Todo: string;
begin
  Result := 'SIN DATOS';
  if (not Q.Active) or Q.IsEmpty then Exit;

  Estado := UpperCase(Trim(Q.FieldByName('estado').AsString));
  Respuesta := UpperCase(Q.FieldByName('respuesta_text').AsString);
  ErrorTxt := UpperCase(Q.FieldByName('last_error').AsString);
  Todo := Respuesta + ' ' + ErrorTxt;

  if Pos('ESTADOREGISTRO>CORRECTO', Respuesta) > 0 then
    Result := 'ACEPTADO CORRECTAMENTE'
  else if Pos('ACEPTADOCONERRORES', Respuesta) > 0 then
    Result := 'ACEPTADO CON INCIDENCIAS POR LA AEAT'
  else if Pos('ESTADOREGISTRO>INCORRECTO', Respuesta) > 0 then
    Result := 'RECHAZADO POR LA AEAT'
  else if (Pos('SOCKERR', Todo) > 0) or (Pos('SSLERR', Todo) > 0) or
          (Pos('TIMEOUT', Todo) > 0) or (Pos('CONEXI', Todo) > 0) or
          (Pos('HTTP', Todo) > 0) or (Pos('CERTIFIC', Todo) > 0) or
          (Pos('PEM', Todo) > 0) or (Pos('SOAPACTION', Todo) > 0) or
          (Pos('ENDPOINT', Todo) > 0) or (Pos('<ENV:FAULT', Todo) > 0) or
          (Pos('<SOAP:FAULT', Todo) > 0) or (Pos('WSDL', Todo) > 0) then
    Result := 'ERROR TÉCNICO REINTENTABLE'
  else if Estado = 'PENDIENTE' then
    Result := 'PENDIENTE DE ENVÍO'
  else if Estado = 'EN_PROCESO' then
    Result := 'ENVÍO EN PROCESO'
  else if Estado = 'ENVIADO' then
    Result := 'ENVIADO / SIN INCIDENCIA DETECTADA'
  else if Estado = 'ERROR' then
    Result := 'INCIDENCIA PENDIENTE DE CLASIFICAR'
  else
    Result := Estado;
end;

function TfrmVFCentroControl.RecommendedAction: string;
var
  C, Err: string;
begin
  C := IncidentClassification;
  Err := Trim(Q.FieldByName('last_error').AsString);

  if C = 'ACEPTADO CORRECTAMENTE' then
    Result := 'No requiere actuación. Conserva la respuesta y la trazabilidad del registro.'
  else if C = 'PENDIENTE DE ENVÍO' then
    Result := 'Espera al proceso normal de envío. Si permanece pendiente, revisa conexión, certificado y servicio de envío.'
  else if C = 'ENVÍO EN PROCESO' then
    Result := 'No intervengas mientras el registro esté reclamado por el proceso de envío. Refresca el estado posteriormente.'
  else if C = 'ERROR TÉCNICO REINTENTABLE' then
    Result := 'Corrige primero la causa técnica (conexión, endpoint, certificado, SOAP o disponibilidad del servicio). Después puede utilizarse el reintento técnico.'
  else if C = 'ACEPTADO CON INCIDENCIAS POR LA AEAT' then
    Result := 'No uses un simple reenvío. Revisa la respuesta completa de la AEAT y determina si procede subsanación, corrección de datos o actuación fiscal específica.'
  else if C = 'RECHAZADO POR LA AEAT' then
    Result := 'No reenvíes sin corregir. Analiza el código y mensaje de la AEAT. Según el dato afectado puede ser necesaria una subsanación, anulación o factura rectificativa.'
  else if C = 'INCIDENCIA PENDIENTE DE CLASIFICAR' then
    Result := 'Revisa el diagnóstico y la respuesta completa en el monitor técnico. No realices un reenvío masivo hasta identificar la naturaleza del error.'
  else
    Result := 'Revisa el detalle técnico antes de realizar cualquier actuación.';

  if Err <> '' then
    Result := Result + LineEnding + LineEnding + 'Último diagnóstico registrado:' + LineEnding + Err;
end;

procedure TfrmVFCentroControl.RefreshSelectedDetail;
var
  C: string;
begin
  if not Assigned(MemoGuidance) then Exit;
  if (not Q.Active) or Q.IsEmpty then
  begin
    LbClassification.Caption := 'No hay registros para los filtros seleccionados.';
    LbClassification.Font.Color := clGray;
    MemoGuidance.Lines.Text := 'Cambia el ejercicio, entorno o estado para consultar otros registros.';
    Exit;
  end;

  C := IncidentClassification;
  LbClassification.Caption := C + ' · ' +
    Q.FieldByName('serie').AsString + '/' + Q.FieldByName('numero').AsString;

  if (Pos('RECHAZADO', C) > 0) or (Pos('INCIDENCIA', C) > 0) then
    LbClassification.Font.Color := RGBToColor(170, 35, 35)
  else if Pos('ERROR TÉCNICO', C) > 0 then
    LbClassification.Font.Color := RGBToColor(180, 100, 0)
  else if (Pos('CORRECTAMENTE', C) > 0) or (Pos('ENVIADO', C) > 0) then
    LbClassification.Font.Color := RGBToColor(20, 115, 55)
  else
    LbClassification.Font.Color := clNavy;

  MemoGuidance.Lines.Text := RecommendedAction;
end;

procedure TfrmVFCentroControl.BtnRunConfigAuditClick(Sender: TObject);
begin
  RunConfigurationAudit;
end;

procedure TfrmVFCentroControl.BtnHealthCenterClick(Sender: TObject);
begin
  FLX_OpenHealthCenter(FConn);
end;

procedure TfrmVFCentroControl.RunConfigurationAudit;
var
  Engine: TFLXAuditEngine;
  Report: TFLXAuditReport;
  IniName: string;
begin
  if not Assigned(MemoConfig) then Exit;

  IniName := IncludeTrailingPathDelimiter(RutaIni) + 'FacturConf.ini';
  Engine := TFLXAuditEngine.Create(FConn, IniName, vfMode, vfUrl, vfUrlTP);
  try
    Report := Engine.Execute;
    MemoConfig.Lines.Text := Report.ToText;

    case Report.OverallLevel of
      alError:
        begin
          LbTrafficLight.Caption := 'ACTUACIÓN NECESARIA';
          LbTrafficLight.Color := RGBToColor(175, 45, 45);
        end;
      alWarning, alNotChecked:
        begin
          LbTrafficLight.Caption := 'REVISAR';
          LbTrafficLight.Color := RGBToColor(190, 125, 0);
        end;
    else
      begin
        LbTrafficLight.Caption := 'TODO CORRECTO';
        LbTrafficLight.Color := RGBToColor(25, 125, 60);
      end;
    end;
  except
    on E: Exception do
    begin
      MemoConfig.Lines.Text := 'No se ha podido ejecutar el motor de auditoría:' +
        LineEnding + E.Message;
      LbTrafficLight.Caption := 'ERROR DE AUDITORÍA';
      LbTrafficLight.Color := RGBToColor(175, 45, 45);
    end;
  end;
  Engine.Free;
end;

procedure TfrmVFCentroControl.BtnSubsanacionesClick(Sender: TObject);
begin
  VF_OpenSubsanaciones(FConn, SelectedYear, SelectedEnvironment, SelectedOrigin);
end;

procedure TfrmVFCentroControl.BtnTraceabilityClick(Sender: TObject);
begin
  if (not Q.Active) or Q.IsEmpty then
  begin
    MessageDlg('Trazabilidad VeriFactu',
      'Seleccione primero un registro en la rejilla.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  VF_OpenTrazabilidad(
    FConn,
    Q.FieldByName('serie').AsString,
    Q.FieldByName('numero').AsInteger
  );
end;

procedure TfrmVFCentroControl.BtnTechnicalValidatorClick(Sender: TObject);
begin
  VF_OpenValidadorTecnico(FConn);
end;

procedure TfrmVFCentroControl.BtnRunAuditClick(Sender: TObject);
begin
  RunHashAudit;
end;


function TfrmVFCentroControl.ShortHash(const S: string): string;
var
  T: string;
begin
  T := Trim(S);
  if Length(T) <= 22 then
    Result := T
  else
    Result := Copy(T, 1, 10) + '...' + Copy(T, Length(T) - 8, 9);
end;

procedure TfrmVFCentroControl.BtnHashRefreshClick(Sender: TObject);
begin
  LoadHashIntegrity;
end;

procedure TfrmVFCentroControl.HashGridClick(Sender: TObject);
begin
  RefreshHashDetail;
end;

procedure TfrmVFCentroControl.HashGridHeaderClick(Sender: TObject;
  IsColumn: Boolean; Index: Integer);
begin
  if (not IsColumn) or (Index < 0) or (Index >= HashGrid.ColCount) then Exit;

  if FHashSortColumn = Index then
    FHashSortAscending := not FHashSortAscending
  else
  begin
    FHashSortColumn := Index;
    FHashSortAscending := True;
  end;

  SortHashGrid(Index);
end;

procedure TfrmVFCentroControl.SortHashGrid(const AColumn: Integer);
var
  I, J, C: Integer;
  Tmp: string;
  Cmp: Integer;
  A, B: string;

  function CompareValues(const S1, S2: string): Integer;
  var
    N1, N2: Int64;
    D1, D2: TDateTime;
  begin
    if AColumn in [0,5] then
    begin
      N1 := StrToInt64Def(Trim(S1), 0);
      N2 := StrToInt64Def(Trim(S2), 0);
      if N1 < N2 then Exit(-1);
      if N1 > N2 then Exit(1);
      Exit(0);
    end;

    if AColumn = 2 then
    begin
      if TryStrToDate(S1, D1) and TryStrToDate(S2, D2) then
      begin
        if D1 < D2 then Exit(-1);
        if D1 > D2 then Exit(1);
        Exit(0);
      end;
    end;

    Result := AnsiCompareText(S1, S2);
  end;

begin
  if HashGrid.RowCount <= 2 then Exit;

  for I := 1 to HashGrid.RowCount - 2 do
    for J := I + 1 to HashGrid.RowCount - 1 do
    begin
      A := HashGrid.Cells[AColumn, I];
      B := HashGrid.Cells[AColumn, J];
      Cmp := CompareValues(A, B);
      if not FHashSortAscending then Cmp := -Cmp;
      if Cmp > 0 then
        for C := 0 to HashGrid.ColCount - 1 do
        begin
          Tmp := HashGrid.Cells[C, I];
          HashGrid.Cells[C, I] := HashGrid.Cells[C, J];
          HashGrid.Cells[C, J] := Tmp;
        end;
    end;

  for C := 0 to HashGrid.ColCount - 1 do
  begin
    case C of
      0: HashGrid.Cells[C,0] := 'ID';
      1: HashGrid.Cells[C,0] := 'Estado';
      2: HashGrid.Cells[C,0] := 'Fecha';
      3: HashGrid.Cells[C,0] := 'Hora';
      4: HashGrid.Cells[C,0] := 'Serie';
      5: HashGrid.Cells[C,0] := 'Número';
      6: HashGrid.Cells[C,0] := 'Tipo';
      7: HashGrid.Cells[C,0] := 'HASH';
      8: HashGrid.Cells[C,0] := 'HASH PREV';
      9: HashGrid.Cells[C,0] := 'SHA-256';
    end;
  end;

  if FHashSortColumn >= 0 then
  begin
    if FHashSortAscending then
      HashGrid.Cells[FHashSortColumn,0] := HashGrid.Cells[FHashSortColumn,0] + ' ▲'
    else
      HashGrid.Cells[FHashSortColumn,0] := HashGrid.Cells[FHashSortColumn,0] + ' ▼';
  end;

  if HashGrid.RowCount > 1 then
  begin
    HashGrid.Row := 1;
    RefreshHashDetail;
  end;
end;

procedure TfrmVFCentroControl.RefreshHashDetail;
var
  ID: Int64;
  QD: TZQuery;
  Recalculated: string;
begin
  if not Assigned(MemoHashDetail) then Exit;

  if (HashGrid.Row <= 0) or (HashGrid.Row >= HashGrid.RowCount) then
  begin
    MemoHashDetail.Lines.Text := 'Selecciona un registro para ver el detalle completo.';
    Exit;
  end;

  ID := StrToInt64Def(HashGrid.Cells[0, HashGrid.Row], 0);
  if ID <= 0 then Exit;

  QD := TZQuery.Create(nil);
  try
    QD.Connection := FConn;
    QD.SQL.Text :=
      'SELECT id,fecha,hora,serie,numero,tipo_factura,estado,entorno,origen,' +
      'COALESCE(hash,'''') AS hash, COALESCE(hash_prev,'''') AS hash_prev,' +
      'COALESCE(hash_input,'''') AS hash_input, COALESCE(canonical,'''') AS canonical,' +
      'COALESCE(fecha_isoz,'''') AS fecha_isoz, COALESCE(hash_algoritmo,'''') AS hash_algoritmo ' +
      'FROM verifactu_queue WHERE id=:ID';
    QD.ParamByName('ID').AsLargeInt := ID;
    QD.Open;

    if QD.EOF then
    begin
      MemoHashDetail.Lines.Text := 'El registro seleccionado ya no está disponible.';
      Exit;
    end;

    Recalculated := '';
    if Trim(QD.FieldByName('hash_input').AsString) <> '' then
      Recalculated := UpperCase(SHA256Hex(QD.FieldByName('hash_input').AsString));

    MemoHashDetail.Clear;
    MemoHashDetail.Lines.Add('DETALLE DE INTEGRIDAD GLOBAL - SOLO LECTURA');
    MemoHashDetail.Lines.Add('===================================');
    MemoHashDetail.Lines.Add('ID          : ' + QD.FieldByName('id').AsString);
    MemoHashDetail.Lines.Add('Documento   : ' + QD.FieldByName('serie').AsString + '/' +
      QD.FieldByName('numero').AsString + '  Tipo=' + QD.FieldByName('tipo_factura').AsString);
    MemoHashDetail.Lines.Add('Fecha/hora  : ' + QD.FieldByName('fecha').AsString + ' ' +
      QD.FieldByName('hora').AsString);
    MemoHashDetail.Lines.Add('Entorno     : ' + QD.FieldByName('entorno').AsString);
    MemoHashDetail.Lines.Add('Origen      : ' + QD.FieldByName('origen').AsString);
    MemoHashDetail.Lines.Add('Estado cola : ' + QD.FieldByName('estado').AsString);
    MemoHashDetail.Lines.Add('Algoritmo   : ' + QD.FieldByName('hash_algoritmo').AsString);
    MemoHashDetail.Lines.Add('Fecha ISO   : ' + QD.FieldByName('fecha_isoz').AsString);
    MemoHashDetail.Lines.Add('');
    MemoHashDetail.Lines.Add('HASH');
    MemoHashDetail.Lines.Add(QD.FieldByName('hash').AsString);
    MemoHashDetail.Lines.Add('');
    MemoHashDetail.Lines.Add('HASH PREV');
    MemoHashDetail.Lines.Add(QD.FieldByName('hash_prev').AsString);
    MemoHashDetail.Lines.Add('');
    MemoHashDetail.Lines.Add('HASH RECALCULADO DESDE hash_input');
    if Recalculated = '' then
      MemoHashDetail.Lines.Add('(No verificable: hash_input no está conservado)')
    else
      MemoHashDetail.Lines.Add(Recalculated);
    MemoHashDetail.Lines.Add('');
    MemoHashDetail.Lines.Add('HASH INPUT');
    MemoHashDetail.Lines.Add(QD.FieldByName('hash_input').AsString);
    MemoHashDetail.Lines.Add('');
    MemoHashDetail.Lines.Add('CANONICAL');
    MemoHashDetail.Lines.Add(QD.FieldByName('canonical').AsString);
  finally
    QD.Free;
  end;
end;

procedure TfrmVFCentroControl.LoadHashIntegrity;
var
  QA: TZQuery;
  PrevHash, Serie, HashValue, HashPrevValue, HashInput,
    RecalculatedHash, StatusText, SHAState: string;
  Total, OKCount, WarningCount, ErrorCount, RowN: Integer;
  FirstVisible, HasError, HasWarning: Boolean;
begin
  if not Assigned(HashGrid) then Exit;

  Screen.Cursor := crHourGlass;
  BtnHashRefresh.Enabled := False;
  try
    HashGrid.RowCount := 1;
    MemoHashDetail.Lines.Text := 'Cargando comprobación de integridad...';

    if SelectedEnvironment = '' then
      LbHashFilter.Caption := 'Filtro: ejercicio ' + IntToStr(SelectedYear) +
        ' · TODOS los entornos · origen ' + CbOrigin.Text
    else
      LbHashFilter.Caption := 'Filtro: ejercicio ' + IntToStr(SelectedYear) +
        ' · ' + SelectedEnvironment + ' · origen ' + CbOrigin.Text;

    QA := TZQuery.Create(nil);
    try
      QA.Connection := FConn;
      QA.SQL.Text :=
        'SELECT q.id,q.fecha,q.hora,q.serie,q.numero,q.tipo_factura,' +
        'COALESCE(q.hash,'''') AS hash, COALESCE(q.hash_prev,'''') AS hash_prev,' +
        'COALESCE(q.hash_input,'''') AS hash_input ' +
        'FROM verifactu_queue q WHERE YEAR(q.fecha)=:Y ' +
        EnvironmentWhereSQL + OriginWhereSQL +
        'ORDER BY q.id';
      QA.ParamByName('Y').AsInteger := SelectedYear;
      QA.Open;

      Total := 0;
      OKCount := 0;
      WarningCount := 0;
      ErrorCount := 0;
      PrevHash := '';

      while not QA.EOF do
      begin
        Inc(Total);
        Serie := Trim(QA.FieldByName('serie').AsString);
        HashValue := UpperCase(Trim(QA.FieldByName('hash').AsString));
        HashPrevValue := UpperCase(Trim(QA.FieldByName('hash_prev').AsString));
        HashInput := QA.FieldByName('hash_input').AsString;
        FirstVisible := (Total = 1);
        HasError := False;
        HasWarning := False;
        StatusText := 'OK';
        SHAState := 'OK';

        if HashValue = '' then
        begin
          StatusText := 'SIN HASH';
          SHAState := 'FALLO';
          HasError := True;
        end;

        { La cadena VeriFactu real de FacturLinEx es GLOBAL por orden de
          generación/cola, no independiente por serie. Por tanto un cambio
          FS-A26 -> A26 -> FS-R26 es totalmente válido si hash_prev coincide
          con el hash del registro global inmediatamente anterior. }
        if FirstVisible then
        begin
          if (HashPrevValue <> '') and (StatusText = 'OK') then
            StatusText := 'ANTERIOR FUERA FILTRO';
        end
        else if HashPrevValue <> PrevHash then
        begin
          if StatusText = 'OK' then StatusText := 'RUPTURA CADENA'
          else StatusText := StatusText + ' + RUPTURA';
          HasError := True;
        end;

        if HashInput = '' then
        begin
          SHAState := 'NO VERIFICABLE';
          if not HasError then
          begin
            StatusText := 'NO VERIFICABLE';
            HasWarning := True;
          end;
        end
        else if HashValue <> '' then
        begin
          RecalculatedHash := UpperCase(SHA256Hex(HashInput));
          if RecalculatedHash <> HashValue then
          begin
            SHAState := 'NO COINCIDE';
            if StatusText = 'OK' then StatusText := 'HASH NO COINCIDE'
            else StatusText := StatusText + ' + HASH';
            HasError := True;
          end;
        end;

        if HasError then Inc(ErrorCount)
        else if HasWarning then Inc(WarningCount)
        else Inc(OKCount);

        RowN := HashGrid.RowCount;
        HashGrid.RowCount := RowN + 1;
        HashGrid.Cells[0,RowN] := QA.FieldByName('id').AsString;
        HashGrid.Cells[1,RowN] := StatusText;
        HashGrid.Cells[2,RowN] := FormatDateTime('dd/mm/yyyy', QA.FieldByName('fecha').AsDateTime);
        HashGrid.Cells[3,RowN] := QA.FieldByName('hora').AsString;
        HashGrid.Cells[4,RowN] := Serie;
        HashGrid.Cells[5,RowN] := QA.FieldByName('numero').AsString;
        HashGrid.Cells[6,RowN] := QA.FieldByName('tipo_factura').AsString;
        HashGrid.Cells[7,RowN] := ShortHash(HashValue);
        HashGrid.Cells[8,RowN] := ShortHash(HashPrevValue);
        HashGrid.Cells[9,RowN] := SHAState;

        PrevHash := HashValue;
        QA.Next;
      end;

      LbHashTotal.Caption := 'Revisados: ' + IntToStr(Total);
      LbHashOK.Caption := 'Correctos: ' + IntToStr(OKCount);
      LbHashWarnings.Caption := 'No verificables: ' + IntToStr(WarningCount);
      LbHashErrors.Caption := 'Incidencias: ' + IntToStr(ErrorCount);

      if Total = 0 then
      begin
        MemoHashDetail.Lines.Text := 'No existen registros para el filtro seleccionado.';
      end
      else
      begin
        HashGrid.Row := 1;
        RefreshHashDetail;
      end;

      if ErrorCount > 0 then
      begin
        LbHash.Caption := 'Cadena HASH: INCIDENCIAS DETECTADAS';
        LbHash.Font.Color := RGBToColor(170, 35, 35);
      end
      else if WarningCount > 0 then
      begin
        LbHash.Caption := 'Cadena HASH: correcta con registros no verificables';
        LbHash.Font.Color := RGBToColor(190, 120, 0);
      end
      else if Total > 0 then
      begin
        LbHash.Caption := 'Cadena HASH: integridad correcta';
        LbHash.Font.Color := RGBToColor(20, 115, 55);
      end;

      if FHashSortColumn >= 0 then
        SortHashGrid(FHashSortColumn);

    finally
      QA.Free;
    end;
  except
    on E: Exception do
    begin
      MemoHashDetail.Lines.Text :=
        'ERROR AL COMPROBAR INTEGRIDAD:' + LineEnding + E.Message;
      LbHashErrors.Caption := 'Incidencias: ERROR';
    end;
  end;

  BtnHashRefresh.Enabled := True;
  Screen.Cursor := crDefault;
end;

procedure TfrmVFCentroControl.RunHashAudit;
var
  QA: TZQuery;
  PrevHash, Serie, HashValue, HashPrevValue, HashInput,
    RecalculatedHash: string;
  Total, MissingHash, MissingInput, BrokenLinks, ExternalStarts,
    HashMismatches, VerifiedHashes: Integer;
  FirstVisible: Boolean;
  LineText: string;
begin
  if not Assigned(MemoAudit) then Exit;

  MemoAudit.Clear;
  MemoAudit.Lines.Add('AUDITORÍA CRIPTOGRÁFICA DE CADENA HASH');
  MemoAudit.Lines.Add('=======================================');
  MemoAudit.Lines.Add('Ejercicio: ' + IntToStr(SelectedYear));
  if SelectedEnvironment = '' then
    MemoAudit.Lines.Add('Entorno: TODOS (solo auditoría de lectura)')
  else
    MemoAudit.Lines.Add('Entorno: ' + SelectedEnvironment);
  MemoAudit.Lines.Add('');
  MemoAudit.Lines.Add('Criterio: cadena GLOBAL por orden interno de generación (id).');
  MemoAudit.Lines.Add('Se comprueba continuidad y, cuando existe hash_input, se recalcula SHA-256.');
  MemoAudit.Lines.Add('Los registros históricos sin hash_input se muestran como NO VERIFICABLES, no como fallos.');
  MemoAudit.Lines.Add('');

  QA := TZQuery.Create(nil);
  try
    QA.Connection := FConn;
    QA.SQL.Text :=
      'SELECT q.id, q.fecha, q.hora, q.serie, q.numero, q.hash, q.hash_prev, ' +
      'COALESCE(q.hash_input,'''') AS hash_input ' +
      'FROM verifactu_queue q WHERE YEAR(q.fecha)=:Y ' + EnvironmentWhereSQL + OriginWhereSQL +
      'ORDER BY q.id';
    QA.ParamCheck := True;
    QA.ParamByName('Y').AsInteger := SelectedYear;
    QA.Open;

    Total := 0;
    MissingHash := 0;
    MissingInput := 0;
    BrokenLinks := 0;
    ExternalStarts := 0;
    HashMismatches := 0;
    VerifiedHashes := 0;
    PrevHash := '';

    while not QA.EOF do
    begin
      Inc(Total);
      Serie := Trim(QA.FieldByName('serie').AsString);
      HashValue := UpperCase(Trim(QA.FieldByName('hash').AsString));
      HashPrevValue := UpperCase(Trim(QA.FieldByName('hash_prev').AsString));
      HashInput := QA.FieldByName('hash_input').AsString;
      FirstVisible := (Total = 1);

      LineText := FormatDateTime('yyyy-mm-dd', QA.FieldByName('fecha').AsDateTime) +
        '  ' + Serie + '/' + QA.FieldByName('numero').AsString;

      if HashValue = '' then
      begin
        Inc(MissingHash);
        MemoAudit.Lines.Add('[FALLO] ' + LineText + ' · hash vacío.');
      end;

      if HashInput = '' then
      begin
        Inc(MissingInput);
        MemoAudit.Lines.Add('[NO VERIFICABLE] ' + LineText +
          ' · registro histórico sin hash_input conservado.');
      end
      else if HashValue <> '' then
      begin
        RecalculatedHash := UpperCase(SHA256Hex(HashInput));
        Inc(VerifiedHashes);
        if RecalculatedHash <> HashValue then
        begin
          Inc(HashMismatches);
          MemoAudit.Lines.Add('[FALLO] ' + LineText +
            ' · el SHA-256 recalculado no coincide con el hash almacenado.');
          MemoAudit.Lines.Add('        Recalculado: ' + RecalculatedHash);
          MemoAudit.Lines.Add('        Almacenado : ' + HashValue);
        end;
      end;

      if FirstVisible then
      begin
        if HashPrevValue <> '' then
        begin
          Inc(ExternalStarts);
          MemoAudit.Lines.Add('[INFO ] ' + LineText +
            ' · primer registro visible enlazado con un registro anterior al filtro.');
        end;
      end
      else if HashPrevValue <> PrevHash then
      begin
        Inc(BrokenLinks);
        MemoAudit.Lines.Add('[FALLO] ' + LineText +
          ' · hash_prev no coincide con el hash GLOBAL inmediatamente anterior.');
        MemoAudit.Lines.Add('        Esperado: ' + PrevHash);
        MemoAudit.Lines.Add('        Guardado : ' + HashPrevValue);
      end;

      PrevHash := HashValue;
      QA.Next;
    end;

    MemoAudit.Lines.Add('');
    MemoAudit.Lines.Add('RESUMEN');
    MemoAudit.Lines.Add('-------');
    MemoAudit.Lines.Add('Registros revisados........: ' + IntToStr(Total));
    MemoAudit.Lines.Add('Hashes recalculados.........: ' + IntToStr(VerifiedHashes));
    MemoAudit.Lines.Add('Históricos no verificables..: ' + IntToStr(MissingInput));
    MemoAudit.Lines.Add('Hashes vacíos...............: ' + IntToStr(MissingHash));
    MemoAudit.Lines.Add('Hashes que no coinciden.....: ' + IntToStr(HashMismatches));
    MemoAudit.Lines.Add('Rupturas de continuidad.....: ' + IntToStr(BrokenLinks));
    MemoAudit.Lines.Add('Inicios enlazados anteriores: ' + IntToStr(ExternalStarts));
    MemoAudit.Lines.Add('');

    if Total = 0 then
    begin
      MemoAudit.Lines.Add('RESULTADO: SIN REGISTROS PARA EL FILTRO SELECCIONADO.');
      LbHash.Caption := 'Cadena HASH: sin registros para auditar';
      LbHash.Font.Color := clGray;
    end
    else if (MissingHash > 0) or (BrokenLinks > 0) or (HashMismatches > 0) then
    begin
      MemoAudit.Lines.Add('RESULTADO: ACTUACIÓN NECESARIA.');
      MemoAudit.Lines.Add('Se han detectado hashes ausentes, huellas que no coinciden o rupturas de continuidad.');
      MemoAudit.Lines.Add('La auditoría no ha modificado ningún dato.');
      LbHash.Caption := 'Cadena HASH: INCIDENCIAS DETECTADAS';
      LbHash.Font.Color := RGBToColor(170, 35, 35);
      LbTrafficLight.Caption := 'ACTUACIÓN NECESARIA';
      LbTrafficLight.Color := RGBToColor(170, 35, 35);
    end
    else if MissingInput > 0 then
    begin
      MemoAudit.Lines.Add('RESULTADO: CONTINUIDAD CORRECTA, AUDITORÍA PARCIAL.');
      MemoAudit.Lines.Add('Los registros nuevos verificables son correctos, pero existen históricos sin hash_input.');
      LbHash.Caption := 'Cadena HASH: correcta con históricos no verificables';
      LbHash.Font.Color := RGBToColor(190, 120, 0);
    end
    else
    begin
      MemoAudit.Lines.Add('RESULTADO: AUDITORÍA CRIPTOGRÁFICA CORRECTA.');
      MemoAudit.Lines.Add('Todos los registros del ámbito seleccionado tienen continuidad y SHA-256 coincidente.');
      LbHash.Caption := 'Cadena HASH: auditoría criptográfica correcta';
      LbHash.Font.Color := RGBToColor(20, 115, 55);
    end;
  except
    on E: Exception do
    begin
      MemoAudit.Lines.Add('ERROR AL EJECUTAR LA AUDITORÍA:');
      MemoAudit.Lines.Add(E.Message);
      LbHash.Caption := 'Cadena HASH: no se ha podido comprobar';
      LbHash.Font.Color := RGBToColor(170, 35, 35);
    end;
  end;
  QA.Free;
end;

procedure TfrmVFCentroControl.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  S: string;
begin
  if gdSelected in State then
  begin
    Grid.Canvas.Brush.Color := clNavy;
    Grid.Canvas.Font.Color := clWhite;
  end
  else
  begin
    S := UpperCase(Q.FieldByName('resultado').AsString);
    if Pos('CORRECTO', S) > 0 then
      Grid.Canvas.Brush.Color := RGBToColor(230, 255, 230)
    else if (Pos('ERROR', S) > 0) or (Pos('INCORRECTO', S) > 0) then
      Grid.Canvas.Brush.Color := RGBToColor(255, 230, 230)
    else if Pos('ACEPTADO CON ERRORES', S) > 0 then
      Grid.Canvas.Brush.Color := RGBToColor(255, 245, 210)
    else
      Grid.Canvas.Brush.Color := clWhite;
    Grid.Canvas.Font.Color := clBlack;
  end;
  Grid.Canvas.FillRect(Rect);
  Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

end.
