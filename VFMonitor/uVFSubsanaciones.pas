unit uVFSubsanaciones;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, DBGrids, DB, LCLType, ZConnection, ZDataset, uVFSubsanacionBuilder, uVFSubsanacionFinal, uVFSubsanacionEditor, uVFSubsanacionQueue, uVFSubsanacionCrypto, uVFSubsanacionXML, uVFSubsanacionSend, uVFSubsanacionCertificacion, Global;

procedure VF_OpenSubsanaciones(const AConnection: TZConnection;
  const AYear: Integer; const AEnvironment, AOrigin: string);

implementation

var
  GSubSchemaChecked: Boolean = False;

type
  TfrmVFSubsanaciones = class(TForm)
  private
    FConn: TZConnection;
    FYear: Integer;
    FEnvironment: string;
    FOrigin: string;
    FSortField: string;
    FSortDesc: Boolean;
    HeaderPanel, InfoPanel, DetailPanel, FooterPanel: TPanel;
    LbTitle, LbSubtitle, LbFilter, LbSelected, LbHelp: TLabel;
    Grid: TDBGrid;
    DS: TDataSource;
    Q, QAux: TZQuery;
    MemoResponse: TMemo;
    BtnRefresh, BtnPrepare, BtnGenerateDraft, BtnCorrectData, BtnPrepareFinal, BtnQueueSub, BtnNoRequire, BtnClose: TBitBtn;
    procedure BuildUI;
    function EnsureSchema(out AError: string): Boolean;
    function EnvironmentWhereSQL: string;
    function OriginWhereSQL: string;
    procedure LoadData;
    procedure SetupColumns;
    procedure RefreshDetail;
    procedure GridCellClick(Column: TColumn);
    procedure GridTitleClick(Column: TColumn);
    function SortOrderSQL: string;
    function IsTechnicalIntegrityIssue: Boolean;
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnPrepareClick(Sender: TObject);
    procedure BtnGenerateDraftClick(Sender: TObject);
    procedure BtnCorrectDataClick(Sender: TObject);
    procedure BtnPrepareFinalClick(Sender: TObject);
    procedure BtnQueueSubClick(Sender: TObject);
    procedure BtnNoRequireClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormKeyDownHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
    function SuggestedOperation(out ASub, AReject, AExplanation: string): string;
    function CurrentQueueID: Int64;
    function AlreadyPrepared: Boolean;
    function CurrentSubID: Int64;
    function EnsureDraftColumns(out AError: string): Boolean;
    function CurrentSystemVFEnvironment: string;
  public
    constructor CreateWith(const AConnection: TZConnection;
      const AYear: Integer; const AEnvironment, AOrigin: string); reintroduce;
  end;

procedure VF_OpenSubsanaciones(const AConnection: TZConnection;
  const AYear: Integer; const AEnvironment, AOrigin: string);
var
  F: TfrmVFSubsanaciones;
  Err: string;
begin
  if (AConnection = nil) or (not AConnection.Connected) then
  begin
    MessageDlg('Control de subsanaciones: no existe una conexión activa.',
      mtError, [mbOK], 0);
    Exit;
  end;

  F := TfrmVFSubsanaciones.CreateWith(AConnection, AYear, AEnvironment, AOrigin);
  try
    if not F.EnsureSchema(Err) then
    begin
      MessageDlg('No se ha podido preparar el control de subsanaciones:' +
        LineEnding + Err, mtError, [mbOK], 0);
      Exit;
    end;
    F.LoadData;
    F.ShowModal;
  finally
    F.Free;
  end;
end;

constructor TfrmVFSubsanaciones.CreateWith(const AConnection: TZConnection;
  const AYear: Integer; const AEnvironment, AOrigin: string);
begin
  inherited CreateNew(nil, 1);
  FConn := AConnection;
  FYear := AYear;
  FEnvironment := UpperCase(Trim(AEnvironment));
  FOrigin := UpperCase(Trim(AOrigin));
  FSortField := 'fecha';
  FSortDesc := True;
  Caption := 'Control de Subsanaciones VeriFactu';
  Position := poScreenCenter;
  WindowState := wsMaximized;
  Width := 1380;
  Height := 820;
  Color := RGBToColor(244, 247, 250);
  KeyPreview := True;
  OnKeyDown := @FormKeyDownHandler;

  Q := TZQuery.Create(Self);
  Q.Connection := FConn;
  QAux := TZQuery.Create(Self);
  QAux.Connection := FConn;
  DS := TDataSource.Create(Self);
  DS.DataSet := Q;
  BuildUI;
end;

procedure TfrmVFSubsanaciones.BuildUI;
begin
  HeaderPanel := TPanel.Create(Self);
  HeaderPanel.Parent := Self;
  HeaderPanel.Align := alTop;
  HeaderPanel.Height := 100;
  HeaderPanel.BevelOuter := bvNone;
  HeaderPanel.Color := RGBToColor(28, 82, 130);
  HeaderPanel.Caption := '';

  LbTitle := TLabel.Create(Self);
  LbTitle.Parent := HeaderPanel;
  LbTitle.SetBounds(24, 14, 900, 30);
  LbTitle.Caption := 'CONTROL DE SUBSANACIONES VERIFACTU';
  LbTitle.ParentFont := False;
  LbTitle.Font.Height := -22;
  LbTitle.Font.Style := [fsBold];
  LbTitle.Font.Color := clWhite;

  LbSubtitle := TLabel.Create(Self);
  LbSubtitle.Parent := HeaderPanel;
  LbSubtitle.SetBounds(25, 55, 1200, 34);
  LbSubtitle.AutoSize := False;
  LbSubtitle.WordWrap := True;
  LbSubtitle.Caption :=
    'El registro original permanece inalterado. V1.3 prepara y congela un borrador técnico con los indicadores y el ancla de encadenamiento; NO envía todavía a la AEAT.';
  LbSubtitle.ParentFont := False;
  LbSubtitle.Font.Height := -12;
  LbSubtitle.Font.Color := RGBToColor(222, 236, 248);

  InfoPanel := TPanel.Create(Self);
  InfoPanel.Parent := Self;
  InfoPanel.Align := alTop;
  InfoPanel.Height := 72;
  InfoPanel.BevelOuter := bvNone;
  InfoPanel.Color := RGBToColor(236, 242, 247);
  InfoPanel.Caption := '';

  LbFilter := TLabel.Create(Self);
  LbFilter.Parent := InfoPanel;
  LbFilter.SetBounds(22, 18, 900, 30);
  if FEnvironment = '' then
    LbFilter.Caption := 'Ejercicio ' + IntToStr(FYear) + ' · Entorno: TODOS'
  else
    LbFilter.Caption := 'Ejercicio ' + IntToStr(FYear) + ' · Entorno: ' + FEnvironment;

  if FOrigin = '' then
    LbFilter.Caption := LbFilter.Caption + ' · Origen: TODOS'
  else
    LbFilter.Caption := LbFilter.Caption + ' · Origen: ' + FOrigin;
  LbFilter.Font.Style := [fsBold];

  BtnRefresh := TBitBtn.Create(Self);
  BtnRefresh.Parent := InfoPanel;
  BtnRefresh.SetBounds(InfoPanel.Width - 165, 16, 140, 38);
  BtnRefresh.Anchors := [akTop, akRight];
  BtnRefresh.Caption := 'Actualizar';
  BtnRefresh.OnClick := @BtnRefreshClick;

  FooterPanel := TPanel.Create(Self);
  FooterPanel.Parent := Self;
  FooterPanel.Align := alBottom;
  FooterPanel.Height := 70;
  FooterPanel.BevelOuter := bvNone;
  FooterPanel.Color := RGBToColor(232, 240, 247);
  FooterPanel.Caption := '';

  BtnPrepare := TBitBtn.Create(Self);
  BtnPrepare.Parent := FooterPanel;
  BtnPrepare.SetBounds(20, 16, 230, 40);
  BtnPrepare.Caption := 'Preparar subsanación';
  BtnPrepare.Font.Style := [fsBold];
  BtnPrepare.OnClick := @BtnPrepareClick;

  BtnGenerateDraft := TBitBtn.Create(Self);
  BtnGenerateDraft.Parent := FooterPanel;
  BtnGenerateDraft.SetBounds(265, 16, 250, 40);
  BtnGenerateDraft.Caption := 'Generar borrador técnico';
  BtnGenerateDraft.Font.Style := [fsBold];
  BtnGenerateDraft.OnClick := @BtnGenerateDraftClick;

  BtnCorrectData := TBitBtn.Create(Self);
  BtnCorrectData.Parent := FooterPanel;
  BtnCorrectData.SetBounds(530, 16, 230, 40);
  BtnCorrectData.Caption := 'Corregir datos';
  BtnCorrectData.Font.Style := [fsBold];
  BtnCorrectData.OnClick := @BtnCorrectDataClick;

  BtnPrepareFinal := TBitBtn.Create(Self);
  BtnPrepareFinal.Parent := FooterPanel;
  BtnPrepareFinal.SetBounds(775, 16, 240, 40);
  BtnPrepareFinal.Caption := 'Preparar registro final';
  BtnPrepareFinal.Font.Style := [fsBold];
  BtnPrepareFinal.OnClick := @BtnPrepareFinalClick;

  BtnQueueSub := TBitBtn.Create(Self);
  BtnQueueSub.Parent := FooterPanel;
  BtnQueueSub.SetBounds(1030, 16, 210, 40);
  BtnQueueSub.Caption := 'Crear en cola';
  BtnQueueSub.Font.Style := [fsBold];
  BtnQueueSub.OnClick := @BtnQueueSubClick;

  BtnNoRequire := TBitBtn.Create(Self);
  BtnNoRequire.Parent := FooterPanel;
  BtnNoRequire.SetBounds(1255, 16, 185, 40);
  BtnNoRequire.Caption := 'Marcar: no requiere';
  BtnNoRequire.OnClick := @BtnNoRequireClick;

  BtnClose := TBitBtn.Create(Self);
  BtnClose.Parent := FooterPanel;
  BtnClose.SetBounds(FooterPanel.Width - 145, 16, 120, 40);
  BtnClose.Anchors := [akTop, akRight];
  BtnClose.Caption := 'Cerrar';
  BtnClose.OnClick := @BtnCloseClick;

  DetailPanel := TPanel.Create(Self);
  DetailPanel.Parent := Self;
  DetailPanel.Align := alBottom;
  DetailPanel.Height := 240;
  DetailPanel.BevelOuter := bvNone;
  DetailPanel.Color := RGBToColor(248, 250, 252);
  DetailPanel.Caption := '';

  LbSelected := TLabel.Create(Self);
  LbSelected.Parent := DetailPanel;
  LbSelected.SetBounds(20, 12, 1280, 25);
  LbSelected.Caption := 'Seleccione un registro.';
  LbSelected.Font.Style := [fsBold];

  LbHelp := TLabel.Create(Self);
  LbHelp.Parent := DetailPanel;
  LbHelp.SetBounds(20, 42, 1280, 48);
  LbHelp.AutoSize := False;
  LbHelp.WordWrap := True;
  LbHelp.Caption :=
    'Confirme siempre que la corrección NO exige factura rectificativa ni anulación. FacturLinEx no decidirá automáticamente esa cuestión fiscal.';

  MemoResponse := TMemo.Create(Self);
  MemoResponse.Parent := DetailPanel;
  MemoResponse.SetBounds(20, 96, DetailPanel.ClientWidth - 40, 125);
  MemoResponse.Anchors := [akLeft, akTop, akRight, akBottom];
  MemoResponse.ReadOnly := True;
  MemoResponse.ScrollBars := ssAutoBoth;
  MemoResponse.WordWrap := False;
  MemoResponse.Color := clWhite;

  Grid := TDBGrid.Create(Self);
  Grid.Parent := Self;
  Grid.Align := alClient;
  Grid.DataSource := DS;
  Grid.ReadOnly := True;
  Grid.Options := Grid.Options + [dgTitles, dgIndicator, dgRowSelect, dgAlwaysShowSelection];
  Grid.OnCellClick := @GridCellClick;
  Grid.OnTitleClick := @GridTitleClick;
end;

function TfrmVFSubsanaciones.EnsureSchema(out AError: string): Boolean;
begin
  Result := False;
  AError := '';
  try
    QAux.Close;
    QAux.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS verifactu_subsanaciones (' +
      'id BIGINT NOT NULL AUTO_INCREMENT,' +
      'queue_id BIGINT NOT NULL,' +
      'serie VARCHAR(64) NOT NULL,' +
      'numero VARCHAR(64) NOT NULL,' +
      'fecha DATE NOT NULL,' +
      'entorno VARCHAR(16) NOT NULL DEFAULT ''SIN_CLASIFICAR'',' +
      'operacion VARCHAR(24) NOT NULL,' +
      'indicador_subsanacion CHAR(1) NOT NULL DEFAULT ''S'',' +
      'indicador_rechazo_previo CHAR(1) NOT NULL DEFAULT ''N'',' +
      'estado VARCHAR(32) NOT NULL DEFAULT ''PENDIENTE_PREPARACION'',' +
      'motivo TEXT NULL,' +
      'respuesta_origen LONGTEXT NULL,' +
      'created_at DATETIME NOT NULL,' +
      'updated_at DATETIME NOT NULL,' +
      'prepared_at DATETIME NULL,' +
      'sent_at DATETIME NULL,' +
      'nuevo_queue_id BIGINT NULL,' +
      'PRIMARY KEY (id),' +
      'KEY idx_vfs_queue (queue_id),' +
      'KEY idx_vfs_estado (estado),' +
      'KEY idx_vfs_fecha (fecha),' +
      'KEY idx_vfs_entorno (entorno)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8mb4';
    QAux.ExecSQL;
    if not EnsureDraftColumns(AError) then Exit;
    Result := True;
  except
    on E: Exception do AError := E.Message;
  end;
end;

function TfrmVFSubsanaciones.EnvironmentWhereSQL: string;
begin
  Result := '';
  if FEnvironment = 'PRODUCCION' then
    Result := ' AND COALESCE(q.entorno,''SIN_CLASIFICAR'')=''PRODUCCION'' '
  else if FEnvironment = 'PRUEBAS' then
    Result := ' AND COALESCE(q.entorno,''SIN_CLASIFICAR'')=''PRUEBAS'' '
  else if (FEnvironment = 'SIN_CLASIFICAR') or (FEnvironment = 'SIN CLASIFICAR') then
    Result := ' AND COALESCE(q.entorno,''SIN_CLASIFICAR'')=''SIN_CLASIFICAR'' ';
end;

function TfrmVFSubsanaciones.OriginWhereSQL: string;
begin
  Result := '';
  if FOrigin = 'NORMAL' then
    Result := ' AND COALESCE(q.origen,''SIN_CLASIFICAR'')=''NORMAL'' '
  else if FOrigin = 'RECTIFICATIVA' then
    Result := ' AND COALESCE(q.origen,''SIN_CLASIFICAR'')=''RECTIFICATIVA'' '
  else if FOrigin = 'SUBSANACION' then
    Result := ' AND COALESCE(q.origen,''SIN_CLASIFICAR'')=''SUBSANACION'' '
  else if (FOrigin = 'SIN_CLASIFICAR') or (FOrigin = 'SIN CLASIFICAR') then
    Result := ' AND COALESCE(q.origen,''SIN_CLASIFICAR'')=''SIN_CLASIFICAR'' ';
end;

function TfrmVFSubsanaciones.CurrentSystemVFEnvironment: string;
begin
  Result := UpperCase(Trim(vfMode));
  if Result = 'TEST' then Result := 'PRUEBAS';
  if (Result <> 'PRUEBAS') and (Result <> 'PRODUCCION') then
    Result := 'SIN_CLASIFICAR';
end;

function TfrmVFSubsanaciones.SortOrderSQL: string;
var
  F: string;
begin
  F := LowerCase(Trim(FSortField));

  if F = 'fecha' then Result := 'q.fecha'
  else if F = 'serie' then Result := 'q.serie'
  else if F = 'numero' then Result := 'q.numero'
  else if F = 'tipo_factura' then Result := 'q.tipo_factura'
  else if F = 'entorno' then Result := 'q.entorno'
  else if F = 'origen' then Result := 'q.origen'
  else if F = 'estado_aeat' then Result := 'estado_aeat'
  else if F = 'clasificacion' then Result := 'clasificacion'
  else if F = 'sub_operacion' then Result := 'sub_operacion'
  else if F = 'sub_estado' then Result := 'sub_estado'
  else if F = 'diagnostico' then Result := 'diagnostico'
  else Result := 'q.fecha';

  if FSortDesc then
    Result := Result + ' DESC'
  else
    Result := Result + ' ASC';

  Result := Result + ', q.fecha DESC, q.serie, q.numero';
end;

procedure TfrmVFSubsanaciones.LoadData;
var
  SavedSubID, SavedQueueID: Int64;
begin
  SavedSubID := 0;
  SavedQueueID := 0;

  if Q.Active and (not Q.IsEmpty) then
  begin
    if (Q.FindField('sub_id') <> nil) and
       (not Q.FieldByName('sub_id').IsNull) then
      SavedSubID := Q.FieldByName('sub_id').AsLargeInt;
    if Q.FindField('id') <> nil then
      SavedQueueID := Q.FieldByName('id').AsLargeInt;
  end;

  Q.Close;
  Q.SQL.Text :=
    'SELECT q.id,q.fecha,q.serie,q.numero,q.tipo_factura,q.entorno,q.origen,' +
    'CASE WHEN COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>Correcto%'' THEN ''CORRECTO'' ' +
    'WHEN COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>AceptadoConErrores%'' THEN ''ACEPTADO CON ERRORES'' ' +
    'WHEN COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>Incorrecto%'' THEN ''INCORRECTO AEAT'' ' +
    'ELSE q.estado END AS estado_aeat,' +
    'CASE ' +
    'WHEN LOWER(COALESCE(q.last_error,'''')) LIKE ''%hash%'' ' +
    ' OR LOWER(COALESCE(q.last_error,'''')) LIKE ''%huella%'' ' +
    ' OR LOWER(COALESCE(q.last_error,'''')) LIKE ''%encaden%'' ' +
    ' OR LOWER(COALESCE(q.last_error,'''')) LIKE ''%canonical%'' ' +
    'THEN ''INCIDENCIA TECNICA HASH/ENCADENAMIENTO'' ' +
    'ELSE ''DATOS / RESPUESTA AEAT'' END AS clasificacion,' +
    'LEFT(COALESCE(q.last_error,''''),220) AS diagnostico,' +
    's.id AS sub_id,s.operacion AS sub_operacion,s.estado AS sub_estado,s.motivo AS sub_motivo,' +
    'q.respuesta_text ' +
    'FROM verifactu_queue q ' +
    'LEFT JOIN verifactu_subsanaciones s ON s.id=(' +
    'SELECT MAX(s2.id) FROM verifactu_subsanaciones s2 WHERE s2.queue_id=q.id) ' +
    'WHERE YEAR(q.fecha)=:Y ' + EnvironmentWhereSQL + OriginWhereSQL +
    'AND (COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>Correcto%'' ' +
    'OR COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>AceptadoConErrores%'' ' +
    'OR COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>Incorrecto%'' ' +
    'OR LOWER(COALESCE(q.last_error,'''')) LIKE ''%hash%'' ' +
    'OR LOWER(COALESCE(q.last_error,'''')) LIKE ''%huella%'' ' +
    'OR LOWER(COALESCE(q.last_error,'''')) LIKE ''%encaden%'' ' +
    'OR LOWER(COALESCE(q.last_error,'''')) LIKE ''%canonical%'' ' +
    'OR s.id IS NOT NULL) ' +
    'ORDER BY ' + SortOrderSQL;
  Q.ParamCheck := True;
  Q.ParamByName('Y').AsInteger := FYear;
  Q.Open;
  SetupColumns;

  { Mantener el foco en la misma subsanación después de cada paso.
    Primero buscamos sub_id, que permanece estable durante todo el flujo.
    Si aún no existe subsanación, usamos el queue id original. }
  if SavedSubID > 0 then
    Q.Locate('sub_id', SavedSubID, [])
  else if SavedQueueID > 0 then
    Q.Locate('id', SavedQueueID, []);

  RefreshDetail;
end;

procedure TfrmVFSubsanaciones.SetupColumns;

  function SortTitle(const AField, ATitle: string): string;
  begin
    Result := ATitle;
    if SameText(FSortField, AField) then
      if FSortDesc then
        Result := ATitle + ' ▼'
      else
        Result := ATitle + ' ▲';
  end;

  procedure AddCol(const AField, ATitle: string; AWidth: Integer);
  var
    C: TColumn;
  begin
    C := Grid.Columns.Add;
    C.FieldName := AField;
    C.Title.Caption := SortTitle(AField, ATitle);
    C.Width := AWidth;
  end;

begin
  Grid.Columns.BeginUpdate;
  try
    Grid.Columns.Clear;
    AddCol('fecha','Fecha',95);
    AddCol('serie','Serie',115);
    AddCol('numero','Número',90);
    AddCol('tipo_factura','Tipo',70);
    AddCol('entorno','Entorno',110);
    AddCol('origen','Origen',125);
    AddCol('estado_aeat','Resultado AEAT',175);
    AddCol('clasificacion','Clasificación',250);
    AddCol('sub_operacion','Operación prevista',180);
    AddCol('sub_estado','Estado subsanación',175);
    AddCol('diagnostico','Diagnóstico',340);
  finally
    Grid.Columns.EndUpdate;
  end;
end;

function TfrmVFSubsanaciones.CurrentQueueID: Int64;
begin
  Result := 0;
  if Q.Active and not Q.IsEmpty then Result := Q.FieldByName('id').AsLargeInt;
end;

function TfrmVFSubsanaciones.SuggestedOperation(out ASub, AReject,
  AExplanation: string): string;
var State: string;
begin
  State := UpperCase(Trim(Q.FieldByName('estado_aeat').AsString));
  ASub := 'S';
  AReject := 'N';
  if State = 'INCORRECTO AEAT' then
  begin
    Result := 'ALTA_RECHAZO_PREVIO';
    AReject := 'X';
    AExplanation :=
      'Alta tras rechazo previo: Subsanacion=S y RechazoPrevio=X. El registro anterior fue rechazado y no quedó registrado en AEAT.';
  end
  else
  begin
    Result := 'ALTA_SUBSANACION';
    AExplanation :=
      'Subsanación de un registro ya existente: Subsanacion=S y RechazoPrevio=N (u omitido).';
  end;
end;

function TfrmVFSubsanaciones.AlreadyPrepared: Boolean;
begin
  Result := False;
  if CurrentQueueID = 0 then Exit;
  QAux.Close;
  QAux.SQL.Text :=
    'SELECT COUNT(*) AS n FROM verifactu_subsanaciones ' +
    'WHERE queue_id=:Q AND estado<>''NO_REQUIERE''';
  QAux.ParamCheck := True;
  QAux.ParamByName('Q').AsLargeInt := CurrentQueueID;
  QAux.Open;
  Result := QAux.FieldByName('n').AsInteger > 0;
end;

function TfrmVFSubsanaciones.CurrentSubID: Int64;
begin
  Result := 0;
  if Q.Active and (not Q.IsEmpty) and (Q.FindField('sub_id') <> nil) and
     (not Q.FieldByName('sub_id').IsNull) then
    Result := Q.FieldByName('sub_id').AsLargeInt;
end;

function TfrmVFSubsanaciones.EnsureDraftColumns(out AError: string): Boolean;

  function ColumnExists(const AName: string): Boolean;
  begin
    QAux.Close;
    QAux.SQL.Text :=
      'SELECT COUNT(*) AS n FROM information_schema.columns ' +
      'WHERE table_schema=DATABASE() AND table_name=''verifactu_subsanaciones'' ' +
      'AND column_name=:c';
    QAux.ParamCheck := True;
    QAux.ParamByName('c').AsString := AName;
    QAux.Open;
    Result := QAux.FieldByName('n').AsInteger > 0;
  end;

  procedure AddColumn(const AName, ADef: string);
  begin
    if ColumnExists(AName) then Exit;
    QAux.Close;
    QAux.SQL.Text :=
      'ALTER TABLE verifactu_subsanaciones ADD COLUMN ' + AName + ' ' + ADef;
    QAux.ExecSQL;
  end;

begin
  Result := False;
  AError := '';
  if GSubSchemaChecked then
  begin
    Result := True;
    Exit;
  end;
  try
    AddColumn('draft_json', 'LONGTEXT NULL');
    AddColumn('draft_created_at', 'DATETIME NULL');
    AddColumn('chain_queue_id', 'BIGINT NULL');
    AddColumn('chain_serie', 'VARCHAR(64) NULL');
    AddColumn('chain_numero', 'VARCHAR(64) NULL');
    AddColumn('chain_fecha', 'DATE NULL');
    AddColumn('chain_hash', 'VARCHAR(128) NULL');
    AddColumn('payload_origen', 'LONGTEXT NULL');
    AddColumn('payload_corregido', 'LONGTEXT NULL');
    AddColumn('corrected_nif', 'VARCHAR(40) NULL');
    AddColumn('corrected_name', 'VARCHAR(180) NULL');
    AddColumn('correction_notes', 'TEXT NULL');
    AddColumn('corrected_at', 'DATETIME NULL');
    AddColumn('payload_preparado', 'LONGTEXT NULL');
    AddColumn('final_prepared_at', 'DATETIME NULL');
    AddColumn('xml_preparado', 'LONGTEXT NULL');
    AddColumn('xml_validated_at', 'DATETIME NULL');
    GSubSchemaChecked := True;
    Result := True;
  except
    on E: Exception do
      AError := E.Message;
  end;
end;

function TfrmVFSubsanaciones.IsTechnicalIntegrityIssue: Boolean;
begin
  Result := Q.Active and (not Q.IsEmpty) and
    SameText(Trim(Q.FieldByName('clasificacion').AsString),
      'INCIDENCIA TECNICA HASH/ENCADENAMIENTO');
end;

procedure TfrmVFSubsanaciones.RefreshDetail;
var
  Sub, Reject, Explain, Op, Existing: string;
begin
  if not Q.Active or Q.IsEmpty then
  begin
    LbSelected.Caption := 'No hay registros para el filtro actual.';
    MemoResponse.Clear;
    BtnPrepare.Enabled := False;
    BtnGenerateDraft.Enabled := False;
    BtnCorrectData.Enabled := False;
    BtnPrepareFinal.Enabled := False;
    BtnQueueSub.Enabled := False;
    BtnNoRequire.Enabled := False;
    Exit;
  end;

  if IsTechnicalIntegrityIssue then
  begin
    LbSelected.Caption :=
      Q.FieldByName('serie').AsString + ' / ' +
      Q.FieldByName('numero').AsString +
      ' · INCIDENCIA TÉCNICA — HASH/ENCADENAMIENTO';

    MemoResponse.Lines.Text :=
      'ESTE CASO NO SE TRATA COMO SUBSANACIÓN DE DATOS.' + LineEnding + LineEnding +
      'Un error de huella, canonical o encadenamiento afecta a la integridad técnica del registro. ' +
      'El registro original NO debe recalcularse ni modificarse a posteriori.' + LineEnding + LineEnding +
      'Si corresponde a pruebas históricas, debe conservarse identificado como incidencia técnica/histórica. ' +
      'Si apareciera en producción, debe detenerse la actuación automática y revisarse la causa antes de generar ' +
      'nuevos registros.' + LineEnding + LineEnding +
      'DIAGNÓSTICO' + LineEnding + StringOfChar('-',70) + LineEnding +
      Q.FieldByName('diagnostico').AsString + LineEnding + LineEnding +
      'RESPUESTA AEAT ORIGINAL' + LineEnding + StringOfChar('-',70) + LineEnding +
      Q.FieldByName('respuesta_text').AsString;

    BtnPrepare.Enabled := False;
    BtnGenerateDraft.Enabled := False;
    BtnCorrectData.Enabled := False;
    BtnPrepareFinal.Enabled := False;
    BtnQueueSub.Enabled := False;
    BtnNoRequire.Enabled := False;
    Exit;
  end;

  Op := SuggestedOperation(Sub, Reject, Explain);
  LbSelected.Caption := Q.FieldByName('serie').AsString + ' / ' +
    Q.FieldByName('numero').AsString + ' · ' +
    Q.FieldByName('estado_aeat').AsString + ' · ' + Op;

  Existing := '';
  if not Q.FieldByName('sub_estado').IsNull then
    Existing := LineEnding + LineEnding + 'CONTROL ACTUAL: ' +
      Q.FieldByName('sub_estado').AsString + ' · ' +
      Q.FieldByName('sub_operacion').AsString;

  MemoResponse.Lines.Text := Explain + Existing + LineEnding + LineEnding +
    'RESPUESTA AEAT ORIGINAL' + LineEnding + StringOfChar('-',70) + LineEnding +
    Q.FieldByName('respuesta_text').AsString;

  BtnPrepare.Enabled := not AlreadyPrepared;

  { El flujo debe ser recuperable. Un borrador puede regenerarse si quedó a
    medias, si ya se corrigieron datos o incluso si se llegó a preparar el
    candidato final. La regeneración NO borra payload_corregido. }
  BtnGenerateDraft.Enabled := (CurrentSubID > 0) and
    (SameText(Q.FieldByName('sub_estado').AsString, 'PENDIENTE_PREPARACION') or
     SameText(Q.FieldByName('sub_estado').AsString, 'BORRADOR_GENERADO') or
     SameText(Q.FieldByName('sub_estado').AsString, 'DATOS_CORREGIDOS') or
     SameText(Q.FieldByName('sub_estado').AsString, 'LISTO_PARA_GENERADOR'));

  if SameText(Q.FieldByName('sub_estado').AsString, 'PENDIENTE_PREPARACION') then
    BtnGenerateDraft.Caption := 'Generar borrador técnico'
  else
    BtnGenerateDraft.Caption := 'Regenerar borrador técnico';

  BtnCorrectData.Enabled := (CurrentSubID > 0) and
    (SameText(Q.FieldByName('sub_estado').AsString, 'BORRADOR_GENERADO') or
     SameText(Q.FieldByName('sub_estado').AsString, 'DATOS_CORREGIDOS') or
     SameText(Q.FieldByName('sub_estado').AsString, 'LISTO_PARA_GENERADOR'));

  { Si ya estaba listo, se permite volver a preparar el candidato. }
  BtnPrepareFinal.Enabled := (CurrentSubID > 0) and
    (SameText(Q.FieldByName('sub_estado').AsString, 'DATOS_CORREGIDOS') or
     SameText(Q.FieldByName('sub_estado').AsString, 'LISTO_PARA_GENERADOR'));

  if SameText(Q.FieldByName('sub_estado').AsString, 'LISTO_PARA_GENERADOR') then
    BtnPrepareFinal.Caption := 'Repreparar registro final'
  else
    BtnPrepareFinal.Caption := 'Preparar registro final';

  BtnQueueSub.Enabled := (CurrentSubID > 0) and
    (SameText(Q.FieldByName('sub_estado').AsString, 'LISTO_PARA_GENERADOR') or
     SameText(Q.FieldByName('sub_estado').AsString, 'EN_COLA_PENDIENTE') or
     SameText(Q.FieldByName('sub_estado').AsString, 'HUELLA_PREPARADA') or
     SameText(Q.FieldByName('sub_estado').AsString, 'XML_VALIDADO') or
     SameText(Q.FieldByName('sub_estado').AsString, 'ERROR_TECNICO'));

  if SameText(Q.FieldByName('sub_estado').AsString, 'EN_COLA_PENDIENTE') then
    BtnQueueSub.Caption := 'Preparar huella'
  else if SameText(Q.FieldByName('sub_estado').AsString, 'HUELLA_PREPARADA') then
    BtnQueueSub.Caption := 'Validar XML'
  else if SameText(Q.FieldByName('sub_estado').AsString, 'XML_VALIDADO') then
  begin
    if SameText(CurrentSystemVFEnvironment, 'PRODUCCION') then
      BtnQueueSub.Caption := 'Enviar SUB (PRODUCCIÓN)'
    else
      BtnQueueSub.Caption := 'Enviar SUB (PRUEBAS)';
  end
  else if SameText(Q.FieldByName('sub_estado').AsString, 'ERROR_TECNICO') then
  begin
    if SameText(CurrentSystemVFEnvironment, 'PRODUCCION') then
      BtnQueueSub.Caption := 'Reintentar SUB (PRODUCCIÓN)'
    else
      BtnQueueSub.Caption := 'Reintentar SUB (PRUEBAS)';
  end
  else
    BtnQueueSub.Caption := 'Crear en cola';

  BtnNoRequire.Enabled := True;
end;

procedure TfrmVFSubsanaciones.GridCellClick(Column: TColumn);
begin
  RefreshDetail;
end;

procedure TfrmVFSubsanaciones.GridTitleClick(Column: TColumn);
var
  NewField: string;
begin
  if (Column = nil) or (Column.Field = nil) then Exit;
  NewField := Column.FieldName;
  if Trim(NewField) = '' then Exit;

  if SameText(FSortField, NewField) then
    FSortDesc := not FSortDesc
  else
  begin
    FSortField := NewField;
    FSortDesc := False;
  end;

  LoadData;
end;

procedure TfrmVFSubsanaciones.BtnRefreshClick(Sender: TObject);
begin
  LoadData;
end;

procedure TfrmVFSubsanaciones.BtnPrepareClick(Sender: TObject);
var Sub, Reject, Explain, Op, Motive: string;
begin
  if CurrentQueueID = 0 then Exit;
  if IsTechnicalIntegrityIssue then
  begin
    MessageDlg('Incidencia técnica',
      'Los errores de hash/huella/encadenamiento no se incorporan al flujo de subsanación.',
      mtWarning, [mbOK], 0);
    Exit;
  end;
  Op := SuggestedOperation(Sub, Reject, Explain);
  Motive := Trim(Q.FieldByName('diagnostico').AsString);
  if Motive = '' then Motive := 'Pendiente de documentar la corrección concreta.';

  if MessageDlg('Preparar subsanación',
    Explain + LineEnding + LineEnding +
    'Continúe únicamente si NO procede factura rectificativa ni anulación.' + LineEnding +
    'No se modificará el registro original y no se enviará nada todavía.' + LineEnding + LineEnding +
    '¿Desea continuar?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  try
    QAux.Close;
    QAux.SQL.Text :=
      'INSERT INTO verifactu_subsanaciones ' +
      '(queue_id,serie,numero,fecha,entorno,operacion,indicador_subsanacion,' +
      'indicador_rechazo_previo,estado,motivo,respuesta_origen,created_at,updated_at,prepared_at) ' +
      'VALUES (:qid,:ser,:num,:fec,:ent,:op,:sub,:rej,''PENDIENTE_PREPARACION'',:mot,:resp,NOW(),NOW(),NOW())';
    QAux.ParamCheck := True;
    QAux.ParamByName('qid').AsLargeInt := CurrentQueueID;
    QAux.ParamByName('ser').AsString := Q.FieldByName('serie').AsString;
    QAux.ParamByName('num').AsString := Q.FieldByName('numero').AsString;
    QAux.ParamByName('fec').AsDate := Q.FieldByName('fecha').AsDateTime;
    QAux.ParamByName('ent').AsString := CurrentSystemVFEnvironment;
    QAux.ParamByName('op').AsString := Op;
    QAux.ParamByName('sub').AsString := Sub;
    QAux.ParamByName('rej').AsString := Reject;
    QAux.ParamByName('mot').AsString := Motive;
    QAux.ParamByName('resp').AsString := Q.FieldByName('respuesta_text').AsString;
    QAux.ExecSQL;
    MessageDlg('Registro incorporado al flujo de subsanación.' + LineEnding +
      'El registro original permanece inalterado.', mtInformation, [mbOK], 0);
    LoadData;
  except
    on E: Exception do
      MessageDlg('No se ha podido preparar la subsanación:' + LineEnding + E.Message,
        mtError, [mbOK], 0);
  end;
end;

procedure TfrmVFSubsanaciones.BtnGenerateDraftClick(Sender: TObject);
var
  D: TVFSubsanacionDraft;
  Err, Sub, Reject, Explain: string;
  SubID: Int64;
begin
  SubID := CurrentSubID;
  if SubID = 0 then
  begin
    MessageDlg('Primero debe preparar la subsanación.', mtInformation, [mbOK], 0);
    Exit;
  end;

  SuggestedOperation(Sub, Reject, Explain);

  if MessageDlg('Generar / regenerar borrador técnico',
    'Se tomará una nueva fotografía técnica del registro original y del último ' +
    'registro actualmente generado por el SIF.' + LineEnding + LineEnding +
    'Si ya había introducido datos corregidos, SE CONSERVARÁN.' + LineEnding +
    'Cualquier candidato final anterior quedará invalidado y podrá volver a ' +
    'prepararse con el nuevo ancla.' + LineEnding + LineEnding +
    'No se modificará verifactu_queue, no se calculará todavía una huella nueva ' +
    'y no se enviará nada a la AEAT.' + LineEnding + LineEnding +
    '¿Desea continuar?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  Screen.Cursor := crHourGlass;
  try
    if not VF_BuildSubsanacionDraft(FConn, CurrentQueueID, Sub, Reject, D, Err) then
    begin
      MessageDlg('No se ha podido generar el borrador:' + LineEnding + Err,
        mtError, [mbOK], 0);
      Exit;
    end;

    QAux.Close;
    QAux.SQL.Text :=
      'UPDATE verifactu_subsanaciones SET ' +
      'draft_json=:dj,draft_created_at=NOW(),payload_origen=:po,' +
      'chain_queue_id=:cq,chain_serie=:cs,chain_numero=:cn,chain_fecha=:cf,' +
      'chain_hash=:ch,' +
      { Si ya existen datos corregidos, se conservan y el estado vuelve a
        DATOS_CORREGIDOS. Si no, queda BORRADOR_GENERADO. Además se invalida
        cualquier payload final anterior porque el ancla acaba de cambiar. }
      'estado=CASE WHEN COALESCE(payload_corregido,'''')<>'''' ' +
      'THEN ''DATOS_CORREGIDOS'' ELSE ''BORRADOR_GENERADO'' END,' +
      'payload_preparado=NULL,final_prepared_at=NULL,updated_at=NOW() ' +
      'WHERE id=:id';
    QAux.ParamCheck := True;
    QAux.ParamByName('dj').AsString := D.DraftJSON;
    QAux.ParamByName('po').AsString := D.PayloadOrigen;
    QAux.ParamByName('cq').AsLargeInt := D.UltimoQueueID;
    QAux.ParamByName('cs').AsString := D.UltimaSerie;
    QAux.ParamByName('cn').AsString := D.UltimoNumero;
    if D.UltimaFecha > 0 then
      QAux.ParamByName('cf').AsDate := D.UltimaFecha
    else
      QAux.ParamByName('cf').Clear;
    QAux.ParamByName('ch').AsString := D.UltimoHash;
    QAux.ParamByName('id').AsLargeInt := SubID;
    QAux.ExecSQL;

    MessageDlg('Borrador técnico generado correctamente.' + LineEnding +
      'Ancla actual de cadena: ' + D.UltimaSerie + ' / ' + D.UltimoNumero +
      LineEnding + LineEnding +
      'Si ya había datos corregidos, se han conservado.' + LineEnding +
      'El registro original permanece inalterado.',
      mtInformation, [mbOK], 0);
    LoadData;
  except
    on E: Exception do
      MessageDlg('Error al guardar el borrador:' + LineEnding + E.Message,
        mtError, [mbOK], 0);
  end;
  Screen.Cursor := crDefault;
end;

procedure TfrmVFSubsanaciones.BtnCorrectDataClick(Sender: TObject);
var
  DataChanged: Boolean;
  Err: string;
begin
  if CurrentSubID = 0 then Exit;

  DataChanged := False;
  if not VF_EditSubsanacionData(FConn, CurrentSubID, DataChanged, Err) then
  begin
    if Err <> '' then
      MessageDlg('No se puede abrir la corrección:' + LineEnding + Err,
        mtError, [mbOK], 0);
    Exit;
  end;

  if DataChanged then
  begin
    MessageDlg('Datos corregidos y guardados.' + LineEnding +
      'Ahora puede preparar el registro final de subsanación.',
      mtInformation, [mbOK], 0);
    LoadData;
  end;
end;

procedure TfrmVFSubsanaciones.BtnPrepareFinalClick(Sender: TObject);
var
  F: TVFSubsanacionFinal;
  Err: string;
  SubID: Int64;
begin
  SubID := CurrentSubID;
  if SubID = 0 then Exit;

  if MessageDlg('Preparar registro final de subsanación',
    'Se comprobará que el ancla de encadenamiento del borrador sigue siendo ' +
    'el último registro generado por el SIF.' + LineEnding + LineEnding +
    'Si es correcta se generará un payload candidato con Subsanacion y ' +
    'RechazoPrevio, pero NO se calculará aún la huella definitiva ni se ' +
    'enviará a la AEAT.' + LineEnding + LineEnding +
    '¿Desea continuar?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  Screen.Cursor := crHourGlass;
  try
    if not VF_PrepareFinalSubsanacion(FConn, SubID, F, Err) then
    begin
      MessageDlg('No se puede preparar el registro final:' + LineEnding + Err,
        mtWarning, [mbOK], 0);
      Exit;
    end;

    QAux.Close;
    QAux.SQL.Text :=
      'UPDATE verifactu_subsanaciones SET ' +
      'payload_preparado=:p,final_prepared_at=NOW(),' +
      'estado=''LISTO_PARA_GENERADOR'',updated_at=NOW() WHERE id=:id';
    QAux.ParamCheck := True;
    QAux.ParamByName('p').AsString := F.PayloadPreparado;
    QAux.ParamByName('id').AsLargeInt := SubID;
    QAux.ExecSQL;

    MessageDlg('Registro candidato preparado correctamente.' + LineEnding +
      'Estado: LISTO_PARA_GENERADOR' + LineEnding + LineEnding +
      'El registro original continúa inalterado y todavía no se ha enviado nada.',
      mtInformation, [mbOK], 0);
    LoadData;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmVFSubsanaciones.BtnQueueSubClick(Sender: TObject);
var
  QueueID, TestQueueID: Int64;
  UID, Err, StateNow, HashNow, ConfirmText, EffectiveEnvironment, TargetURL: string;
  TestDate: TDateTime;
begin
  if CurrentSubID = 0 then Exit;
  StateNow := UpperCase(Trim(Q.FieldByName('sub_estado').AsString));

  if (StateNow = 'XML_VALIDADO') or (StateNow = 'ERROR_TECNICO') then
  begin
    EffectiveEnvironment := '';
    TargetURL := '';
    Err := '';
    if not VF_EnsureSubEnvironment(
      FConn, CurrentSubID, EffectiveEnvironment, TargetURL, Err) then
    begin
      MessageDlg('Envío bloqueado',
        Err + LineEnding + LineEnding +
        'No se realizará ninguna comunicación con AEAT.',
        mtWarning, [mbOK], 0);
      Exit;
    end;

    if SameText(EffectiveEnvironment, 'PRODUCCION') then
    begin
      { Precomprobación visible. La función de envío la repetirá por seguridad. }
      { No se exige certificación local de PRUEBAS. }
      ConfirmText := '';
      if not InputQuery('CONFIRMACIÓN PRODUCCIÓN',
        'Este envío llegará al servicio VeriFactu de PRODUCCIÓN.' + LineEnding +
        'Escriba PRODUCCION para continuar:', ConfirmText) then Exit;

      if UpperCase(Trim(ConfirmText)) <> 'PRODUCCION' then
      begin
        MessageDlg('Envío cancelado',
          'La palabra de confirmación no coincide. No se ha enviado nada.',
          mtInformation, [mbOK], 0);
        Exit;
      end;

      if MessageDlg('Última confirmación — PRODUCCIÓN',
        'Se enviará el XML VALIDADO de la subsanación a PRODUCCIÓN.' +
        LineEnding + LineEnding +
        
        LineEnding + LineEnding + '¿Confirma definitivamente el envío?',
        mtWarning, [mbYes, mbNo], 0) <> mrYes then Exit;
    end
    else
    begin

      if MessageDlg('Enviar subsanación a AEAT — PRUEBAS',
        'Este paso realizará una comunicación real con el servicio VeriFactu ' +
        'configurado para PRUEBAS.' + LineEnding + LineEnding +
        'Si AEAT responde EstadoRegistro=Correcto, FacturLinEx guardará esta ' +
        'prueba como certificación necesaria para abrir PRODUCCIÓN.' +
        LineEnding + LineEnding + '¿Desea continuar?',
        mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
    end;

    Screen.Cursor := crHourGlass;
    try
      UID := '';
      Err := '';
      HashNow := '';
      if not VF_SendValidatedSubsanacion(
        FConn, CurrentSubID, QueueID, HashNow, UID, Err) then
      begin
        MessageDlg('El envío de subsanación no se ha completado:' +
          LineEnding + Err + LineEnding + LineEnding +
          'Estado: ' + HashNow,
          mtError, [mbOK], 0);
        LoadData;
        Exit;
      end;

      MessageDlg('Respuesta de AEAT recibida.' + LineEnding + LineEnding +
        'Queue ID: ' + IntToStr(QueueID) + LineEnding +
        'Estado final: ' + HashNow + LineEnding + LineEnding +
        'La respuesta completa ha quedado guardada en el registro SUB-*.',
        mtInformation, [mbOK], 0);
      LoadData;
    finally
      Screen.Cursor := crDefault;
    end;
    Exit;
  end;

  if StateNow = 'HUELLA_PREPARADA' then
  begin
    if MessageDlg('Validar XML de subsanación',
      'Se construirá el XML completo de la subsanación SIN ENVIARLO.' +
      LineEnding + LineEnding +
      'Se comprobará:' + LineEnding +
      '  - Subsanacion=S' + LineEnding +
      '  - RechazoPrevio correcto' + LineEnding +
      '  - RegistroAnterior real' + LineEnding +
      '  - misma huella SHA-256 ya congelada' + LineEnding +
      '  - misma FechaHoraHusoGenRegistro' + LineEnding + LineEnding +
      '¿Desea continuar?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

    Screen.Cursor := crHourGlass;
    try
      UID := '';
      if not VF_PrepareAndValidateSubsanacionXML(
        FConn, CurrentSubID, QueueID, UID, Err) then
      begin
        MessageDlg('El XML de subsanación NO ha superado la validación:' +
          LineEnding + Err, mtError, [mbOK], 0);
        Exit;
      end;

      MessageDlg('XML de subsanación validado correctamente.' + LineEnding +
        LineEnding + 'Queue ID: ' + IntToStr(QueueID) +
        LineEnding + 'Estado: XML_VALIDADO' + LineEnding + LineEnding +
        'El XML se ha conservado como evidencia, pero NO se ha enviado a la AEAT.',
        mtInformation, [mbOK], 0);
      LoadData;
    finally
      Screen.Cursor := crDefault;
    end;
    Exit;
  end;

  if StateNow = 'EN_COLA_PENDIENTE' then
  begin
    if MessageDlg('Preparar huella de subsanación',
      'Se calculará la huella SHA-256 SIF-B del registro SUB-* usando exactamente ' +
      'el mismo constructor que usa FacturLinEx para el envío normal.' + LineEnding +
      LineEnding +
      'También se congelarán el hash previo y FechaHoraHusoGenRegistro.' +
      LineEnding + LineEnding +
      'NO se realizará todavía ninguna comunicación con la AEAT.' +
      LineEnding + LineEnding + '¿Desea continuar?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

    Screen.Cursor := crHourGlass;
    try
      if not VF_PrepareSubsanacionCrypto(FConn, CurrentSubID, QueueID,
        HashNow, Err) then
      begin
        MessageDlg('No se ha podido preparar la huella:' + LineEnding + Err,
          mtError, [mbOK], 0);
        Exit;
      end;

      MessageDlg('Huella de subsanación preparada correctamente.' + LineEnding +
        LineEnding + 'Queue ID: ' + IntToStr(QueueID) +
        LineEnding + 'SHA-256: ' + HashNow +
        LineEnding + LineEnding +
        'El registro sigue sin enviarse a la AEAT.',
        mtInformation, [mbOK], 0);
      LoadData;
    finally
      Screen.Cursor := crDefault;
    end;
    Exit;
  end;

  if StateNow <> 'LISTO_PARA_GENERADOR' then
  begin
    MessageDlg('La subsanación no está en un estado que permita crearla en cola.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  if MessageDlg('Crear registro de subsanación en cola',
    'Se creará un NUEVO registro técnico en verifactu_queue con:' + LineEnding +
    '  origen = SUBSANACION' + LineEnding +
    '  registro_uid = SUB-' + IntToStr(CurrentSubID) + LineEnding +
    '  estado = PENDIENTE' + LineEnding + LineEnding +
    'Mantendrá la misma serie y número fiscales del documento original.' + LineEnding +
    'Todavía NO se calculará la huella definitiva y NO se enviará a la AEAT.' +
    LineEnding + LineEnding + '¿Desea continuar?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  Screen.Cursor := crHourGlass;
  try
    if not VF_CreatePendingSubsanacionQueue(FConn, CurrentSubID,
      QueueID, UID, Err) then
    begin
      MessageDlg('No se ha podido crear el registro en cola:' +
        LineEnding + Err, mtError, [mbOK], 0);
      Exit;
    end;

    MessageDlg('Subsanación registrada en la cola.' + LineEnding + LineEnding +
      'Queue ID: ' + IntToStr(QueueID) + LineEnding +
      'Identidad técnica: ' + UID + LineEnding +
      'Estado: PENDIENTE' + LineEnding + LineEnding +
      'Aún no se ha enviado nada a la AEAT.',
      mtInformation, [mbOK], 0);
    LoadData;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmVFSubsanaciones.BtnNoRequireClick(Sender: TObject);
begin
  if CurrentQueueID = 0 then Exit;
  if MessageDlg('Marcar como no requiere',
    'Esta marca es solo de control interno y no modifica el registro ni la respuesta AEAT.' +
    LineEnding + LineEnding + '¿Desea continuar?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
  try
    QAux.Close;
    QAux.SQL.Text :=
      'INSERT INTO verifactu_subsanaciones ' +
      '(queue_id,serie,numero,fecha,entorno,operacion,indicador_subsanacion,' +
      'indicador_rechazo_previo,estado,motivo,respuesta_origen,created_at,updated_at) ' +
      'VALUES (:qid,:ser,:num,:fec,:ent,''CONTROL_INTERNO'',''N'',''N'',''NO_REQUIERE'',' +
      '''Revisión manual: no requiere subsanación'',:resp,NOW(),NOW())';
    QAux.ParamCheck := True;
    QAux.ParamByName('qid').AsLargeInt := CurrentQueueID;
    QAux.ParamByName('ser').AsString := Q.FieldByName('serie').AsString;
    QAux.ParamByName('num').AsString := Q.FieldByName('numero').AsString;
    QAux.ParamByName('fec').AsDate := Q.FieldByName('fecha').AsDateTime;
    QAux.ParamByName('ent').AsString := CurrentSystemVFEnvironment;
    QAux.ParamByName('resp').AsString := Q.FieldByName('respuesta_text').AsString;
    QAux.ExecSQL;
    LoadData;
  except
    on E: Exception do
      MessageDlg('No se ha podido registrar la revisión:' + LineEnding + E.Message,
        mtError, [mbOK], 0);
  end;
end;

procedure TfrmVFSubsanaciones.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmVFSubsanaciones.FormKeyDownHandler(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

end.
