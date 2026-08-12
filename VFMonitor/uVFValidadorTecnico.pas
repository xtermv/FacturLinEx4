unit uVFValidadorTecnico;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, ComCtrls, LCLType, ZConnection, ZDataset, DB;

procedure VF_OpenValidadorTecnico(const AConnection: TZConnection);

implementation

type
  TVFCheckLevel = (vclOK, vclWarning, vclError, vclInfo);

  TfrmVFValidadorTecnico = class(TForm)
  private
    FConn: TZConnection;
    HeaderPanel, SummaryPanel, FooterPanel: TPanel;
    LbTitle, LbSubtitle, LbResult, LbCounters: TLabel;
    MemoReport: TMemo;
    BtnRun, BtnSave, BtnClose: TBitBtn;
    FOK, FWarnings, FErrors, FInfo: Integer;

    procedure BuildUI;
    procedure AddCheck(const ACode, ATitle, ADetail: string;
      ALevel: TVFCheckLevel);
    procedure ResetReport;
    procedure RunValidation;
    procedure BtnRunClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormKeyDownHandler(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    function TableExists(const ATable: string): Boolean;
    function ColumnExists(const ATable, AColumn: string): Boolean;
    function IndexExists(const ATable, AIndex: string): Boolean;
    function ScalarInt(const ASQL: string): Int64;
    function ColumnType(const ATable, AColumn: string): string;
    procedure CheckStructure;
    procedure CheckIndexes;
    procedure CheckStateDefinition;
    procedure CheckQueueCoherence;
    procedure CheckTechnicalTrace;
    procedure CheckResponses;
    procedure FinishSummary;
  public
    constructor CreateWithConnection(AConnection: TZConnection); reintroduce;
  end;

procedure VF_OpenValidadorTecnico(const AConnection: TZConnection);
var
  F: TfrmVFValidadorTecnico;
begin
  if (AConnection = nil) or (not AConnection.Connected) then
  begin
    MessageDlg('Validador técnico VeriFactu: no existe una conexión activa con MariaDB.',
      mtError, [mbOK], 0);
    Exit;
  end;

  F := TfrmVFValidadorTecnico.CreateWithConnection(AConnection);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

constructor TfrmVFValidadorTecnico.CreateWithConnection(
  AConnection: TZConnection);
begin
  inherited CreateNew(nil, 1);
  FConn := AConnection;

  Caption := 'Validador Técnico VeriFactu V1.1';
  Position := poScreenCenter;
  WindowState := wsMaximized;
  Width := 1280;
  Height := 780;
  Color := RGBToColor(244, 247, 250);
  KeyPreview := True;
  OnKeyDown := @FormKeyDownHandler;

  BuildUI;
  RunValidation;
end;

procedure TfrmVFValidadorTecnico.BuildUI;
begin
  HeaderPanel := TPanel.Create(Self);
  HeaderPanel.Parent := Self;
  HeaderPanel.Align := alTop;
  HeaderPanel.Height := 92;
  HeaderPanel.BevelOuter := bvNone;
  HeaderPanel.Color := RGBToColor(25, 79, 127);
  HeaderPanel.Caption := '';

  LbTitle := TLabel.Create(Self);
  LbTitle.Parent := HeaderPanel;
  LbTitle.SetBounds(22, 12, 800, 32);
  LbTitle.Caption := 'VALIDADOR TÉCNICO VERIFACTU — V1.1';
  LbTitle.ParentFont := False;
  LbTitle.Font.Name := 'Sans';
  LbTitle.Font.Height := -22;
  LbTitle.Font.Style := [fsBold];
  LbTitle.Font.Color := clWhite;

  LbSubtitle := TLabel.Create(Self);
  LbSubtitle.Parent := HeaderPanel;
  LbSubtitle.SetBounds(23, 51, 1080, 24);
  LbSubtitle.Caption :=
    'Validación de solo lectura: arquitectura, estructura, estados, cola y trazabilidad técnica.';
  LbSubtitle.ParentFont := False;
  LbSubtitle.Font.Height := -12;
  LbSubtitle.Font.Color := RGBToColor(220, 235, 248);

  SummaryPanel := TPanel.Create(Self);
  SummaryPanel.Parent := Self;
  SummaryPanel.Align := alTop;
  SummaryPanel.Height := 84;
  SummaryPanel.BevelOuter := bvNone;
  SummaryPanel.Color := RGBToColor(232, 240, 247);
  SummaryPanel.Caption := '';

  LbResult := TLabel.Create(Self);
  LbResult.Parent := SummaryPanel;
  LbResult.SetBounds(24, 13, 470, 30);
  LbResult.Caption := 'COMPROBANDO...';
  LbResult.ParentFont := False;
  LbResult.Font.Height := -17;
  LbResult.Font.Style := [fsBold];

  LbCounters := TLabel.Create(Self);
  LbCounters.Parent := SummaryPanel;
  LbCounters.SetBounds(24, 49, 980, 24);
  LbCounters.Caption := '';

  FooterPanel := TPanel.Create(Self);
  FooterPanel.Parent := Self;
  FooterPanel.Align := alBottom;
  FooterPanel.Height := 66;
  FooterPanel.BevelOuter := bvNone;
  FooterPanel.Color := RGBToColor(232, 240, 247);
  FooterPanel.Caption := '';

  BtnRun := TBitBtn.Create(Self);
  BtnRun.Parent := FooterPanel;
  BtnRun.SetBounds(20, 15, 190, 38);
  BtnRun.Caption := 'Repetir validación';
  BtnRun.Font.Style := [fsBold];
  BtnRun.OnClick := @BtnRunClick;

  BtnSave := TBitBtn.Create(Self);
  BtnSave.Parent := FooterPanel;
  BtnSave.SetBounds(222, 15, 190, 38);
  BtnSave.Caption := 'Guardar informe';
  BtnSave.OnClick := @BtnSaveClick;

  BtnClose := TBitBtn.Create(Self);
  BtnClose.Parent := FooterPanel;
  BtnClose.Width := 120;
  BtnClose.Height := 38;
  BtnClose.Left := FooterPanel.Width - 140;
  BtnClose.Top := 15;
  BtnClose.Anchors := [akTop, akRight];
  BtnClose.Caption := 'Cerrar';
  BtnClose.OnClick := @BtnCloseClick;

  MemoReport := TMemo.Create(Self);
  MemoReport.Parent := Self;
  MemoReport.Align := alClient;
  MemoReport.ReadOnly := True;
  MemoReport.ScrollBars := ssAutoBoth;
  MemoReport.WordWrap := False;
  MemoReport.Color := clWhite;
  MemoReport.Font.Name := 'Monospace';
  MemoReport.Font.Height := -12;
end;

procedure TfrmVFValidadorTecnico.ResetReport;
begin
  FOK := 0;
  FWarnings := 0;
  FErrors := 0;
  FInfo := 0;
  MemoReport.Clear;
  MemoReport.Lines.Add('VALIDACIÓN TÉCNICA VERIFACTU');
  MemoReport.Lines.Add('Fecha: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
  MemoReport.Lines.Add('Modo: SOLO LECTURA');
  MemoReport.Lines.Add(StringOfChar('=', 76));
  MemoReport.Lines.Add('');
end;

procedure TfrmVFValidadorTecnico.AddCheck(const ACode, ATitle,
  ADetail: string; ALevel: TVFCheckLevel);
var
  Prefix: string;
begin
  case ALevel of
    vclOK:
      begin Prefix := '[OK]'; Inc(FOK); end;
    vclWarning:
      begin Prefix := '[AVISO]'; Inc(FWarnings); end;
    vclError:
      begin Prefix := '[ERROR]'; Inc(FErrors); end;
  else
    begin Prefix := '[INFO]'; Inc(FInfo); end;
  end;

  MemoReport.Lines.Add(Prefix + ' ' + ACode + ' - ' + ATitle);
  if Trim(ADetail) <> '' then
    MemoReport.Lines.Add('  ' + ADetail);
  MemoReport.Lines.Add('');
end;

function TfrmVFValidadorTecnico.TableExists(const ATable: string): Boolean;
var
  Q: TZQuery;
begin
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS n FROM information_schema.tables ' +
      'WHERE table_schema=DATABASE() AND table_name=:t';
    Q.ParamByName('t').AsString := ATable;
    Q.Open;
    Result := Q.FieldByName('n').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TfrmVFValidadorTecnico.ColumnExists(const ATable,
  AColumn: string): Boolean;
var
  Q: TZQuery;
begin
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS n FROM information_schema.columns ' +
      'WHERE table_schema=DATABASE() AND table_name=:t AND column_name=:c';
    Q.ParamByName('t').AsString := ATable;
    Q.ParamByName('c').AsString := AColumn;
    Q.Open;
    Result := Q.FieldByName('n').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TfrmVFValidadorTecnico.IndexExists(const ATable,
  AIndex: string): Boolean;
var
  Q: TZQuery;
begin
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS n FROM information_schema.statistics ' +
      'WHERE table_schema=DATABASE() AND table_name=:t AND index_name=:i';
    Q.ParamByName('t').AsString := ATable;
    Q.ParamByName('i').AsString := AIndex;
    Q.Open;
    Result := Q.FieldByName('n').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TfrmVFValidadorTecnico.ScalarInt(const ASQL: string): Int64;
var
  Q: TZQuery;
begin
  Result := 0;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := ASQL;
    Q.Open;
    if (Q.FieldCount > 0) and not Q.Fields[0].IsNull then
      Result := Q.Fields[0].AsLargeInt;
  finally
    Q.Free;
  end;
end;

function TfrmVFValidadorTecnico.ColumnType(const ATable,
  AColumn: string): string;
var
  Q: TZQuery;
begin
  Result := '';
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT column_type FROM information_schema.columns ' +
      'WHERE table_schema=DATABASE() AND table_name=:t AND column_name=:c';
    Q.ParamByName('t').AsString := ATable;
    Q.ParamByName('c').AsString := AColumn;
    Q.Open;
    if not Q.EOF then Result := LowerCase(Q.Fields[0].AsString);
  finally
    Q.Free;
  end;
end;

procedure TfrmVFValidadorTecnico.CheckStructure;
const
  RequiredColumns: array[0..28] of string = (
    'id','serie','numero','fecha','hora','total_con_iva','estado','intentos',
    'payload_json','hash','hash_prev','respuesta_text','last_error','token',
    'claimed_by','claimed_at','claimed_until','last_attempt_at','fecha_isoz',
    'canonical','tipo_factura','origen','registro_uid','created_at','updated_at','entorno',
    'hash_input','hash_fecha_huso','hash_algoritmo'
  );
var
  I, Missing: Integer;
  MissingList: string;
begin
  if not TableExists('verifactu_queue') then
  begin
    AddCheck('VF-DB-001', 'Tabla verifactu_queue',
      'La tabla no existe en la base de datos actual.', vclError);
    Exit;
  end;

  AddCheck('VF-DB-001', 'Tabla verifactu_queue',
    'Tabla localizada correctamente.', vclOK);

  Missing := 0;
  MissingList := '';
  for I := Low(RequiredColumns) to High(RequiredColumns) do
    if not ColumnExists('verifactu_queue', RequiredColumns[I]) then
    begin
      Inc(Missing);
      if MissingList <> '' then MissingList := MissingList + ', ';
      MissingList := MissingList + RequiredColumns[I];
    end;

  if Missing = 0 then
    AddCheck('VF-DB-002', 'Columnas obligatorias y de trazabilidad',
      IntToStr(Length(RequiredColumns)) + ' columnas comprobadas.', vclOK)
  else
    AddCheck('VF-DB-002', 'Columnas obligatorias y de trazabilidad',
      'Faltan ' + IntToStr(Missing) + ': ' + MissingList, vclError);

  if ColumnExists('verifactu_queue', 'tipo_factura') then
  begin
    if Pos('char(2)', ColumnType('verifactu_queue', 'tipo_factura')) > 0 then
      AddCheck('VF-DB-003', 'Tipo de tipo_factura',
        ColumnType('verifactu_queue', 'tipo_factura'), vclOK)
    else
      AddCheck('VF-DB-003', 'Tipo de tipo_factura',
        'Tipo actual: ' + ColumnType('verifactu_queue', 'tipo_factura'),
        vclWarning);
  end;
end;

procedure TfrmVFValidadorTecnico.CheckIndexes;
begin
  if not TableExists('verifactu_queue') then Exit;

  if IndexExists('verifactu_queue', 'PRIMARY') then
    AddCheck('VF-IDX-001', 'Clave primaria', 'PRIMARY localizada.', vclOK)
  else
    AddCheck('VF-IDX-001', 'Clave primaria', 'No se localiza PRIMARY.', vclError);

  if IndexExists('verifactu_queue', 'uq_serie_numero_reguid') then
    AddCheck('VF-IDX-002', 'Unicidad fiscal + identidad técnica',
      'Índice uq_serie_numero_reguid localizado.', vclOK)
  else if IndexExists('verifactu_queue', 'uq_serie_numero') then
    AddCheck('VF-IDX-002', 'Unicidad fiscal + identidad técnica',
      'Permanece la unicidad antigua serie/número; falta completar V1.8.',
      vclWarning)
  else
    AddCheck('VF-IDX-002', 'Unicidad fiscal + identidad técnica',
      'No se localiza ningún índice único esperado.', vclError);

  if IndexExists('verifactu_queue', 'idx_estado') then
    AddCheck('VF-IDX-003', 'Índice por estado', 'idx_estado localizado.', vclOK)
  else
    AddCheck('VF-IDX-003', 'Índice por estado',
      'No se localiza idx_estado.', vclWarning);

  if IndexExists('verifactu_queue', 'idx_token') then
    AddCheck('VF-IDX-004', 'Índice de reclamación técnica',
      'idx_token localizado.', vclOK)
  else
    AddCheck('VF-IDX-004', 'Índice de reclamación técnica',
      'No se localiza idx_token.', vclWarning);
end;

procedure TfrmVFValidadorTecnico.CheckStateDefinition;
var
  T: string;
begin
  if not ColumnExists('verifactu_queue', 'estado') then Exit;

  T := ColumnType('verifactu_queue', 'estado');
  if (Pos('pendiente', T) > 0) and
     (Pos('en_proceso', T) > 0) and
     (Pos('enviado', T) > 0) and
     (Pos('error', T) > 0) then
    AddCheck('VF-EST-001', 'Estados internos de la cola', T, vclOK)
  else
    AddCheck('VF-EST-001', 'Estados internos de la cola',
      'Definición actual: ' + T, vclError);
end;

procedure TfrmVFValidadorTecnico.CheckQueueCoherence;
var
  N: Int64;
begin
  if not TableExists('verifactu_queue') then Exit;

  N := ScalarInt(
    'SELECT COUNT(*) FROM (' +
    ' SELECT serie, numero, COUNT(*) c FROM verifactu_queue ' +
    ' GROUP BY serie, numero HAVING COUNT(*)>1' +
    ') x');
  if N = 0 then
    AddCheck('VF-QUE-001', 'Duplicados serie/número',
      'No se han detectado duplicados.', vclOK)
  else
    AddCheck('VF-QUE-001', 'Duplicados serie/número',
      IntToStr(N) + ' combinaciones duplicadas.', vclError);

  if ColumnExists('verifactu_queue', 'tipo_factura') then
  begin
    N := ScalarInt(
      'SELECT COUNT(*) FROM verifactu_queue ' +
      'WHERE COALESCE(tipo_factura,'''') NOT IN ' +
      '(''F1'',''F2'',''F3'',''R1'',''R2'',''R3'',''R4'',''R5'')');
    if N = 0 then
      AddCheck('VF-QUE-002', 'Tipos de factura VeriFactu',
        'Tipos reconocidos: F1, F2, F3 y R1-R5.', vclOK)
    else
      AddCheck('VF-QUE-002', 'Tipos de factura VeriFactu',
        IntToStr(N) + ' registros presentan un tipo no reconocido.', vclError);

    AddCheck('VF-QUE-002A', 'Resumen por tipo de factura',
      'F1=' + IntToStr(ScalarInt(
        'SELECT COUNT(*) FROM verifactu_queue WHERE tipo_factura=''F1''')) +
      ' | F2=' + IntToStr(ScalarInt(
        'SELECT COUNT(*) FROM verifactu_queue WHERE tipo_factura=''F2''')) +
      ' | F3=' + IntToStr(ScalarInt(
        'SELECT COUNT(*) FROM verifactu_queue WHERE tipo_factura=''F3''')) +
      ' | R1=' + IntToStr(ScalarInt(
        'SELECT COUNT(*) FROM verifactu_queue WHERE tipo_factura=''R1''')) +
      ' | R2=' + IntToStr(ScalarInt(
        'SELECT COUNT(*) FROM verifactu_queue WHERE tipo_factura=''R2''')) +
      ' | R3=' + IntToStr(ScalarInt(
        'SELECT COUNT(*) FROM verifactu_queue WHERE tipo_factura=''R3''')) +
      ' | R4=' + IntToStr(ScalarInt(
        'SELECT COUNT(*) FROM verifactu_queue WHERE tipo_factura=''R4''')) +
      ' | R5=' + IntToStr(ScalarInt(
        'SELECT COUNT(*) FROM verifactu_queue WHERE tipo_factura=''R5''')),
      vclInfo);

    if ColumnExists('verifactu_queue', 'origen') then
    begin
      N := ScalarInt(
        'SELECT COUNT(*) FROM verifactu_queue WHERE ' +
        'COALESCE(origen,''SIN_CLASIFICAR'') NOT IN ' +
        '(''NORMAL'',''RECTIFICATIVA'',''SUBSANACION'',''SIN_CLASIFICAR'')');
      if N = 0 then
        AddCheck('VF-QUE-002B', 'Origen del registro',
          'Valores reconocidos: NORMAL, RECTIFICATIVA, SUBSANACION y SIN_CLASIFICAR.',
          vclOK)
      else
        AddCheck('VF-QUE-002B', 'Origen del registro',
          IntToStr(N) + ' registros contienen un origen no reconocido.', vclError);

      AddCheck('VF-QUE-002C', 'Resumen por origen',
        'NORMAL=' + IntToStr(ScalarInt(
          'SELECT COUNT(*) FROM verifactu_queue WHERE origen=''NORMAL''')) +
        ' | RECTIFICATIVA=' + IntToStr(ScalarInt(
          'SELECT COUNT(*) FROM verifactu_queue WHERE origen=''RECTIFICATIVA''')) +
        ' | SUBSANACION=' + IntToStr(ScalarInt(
          'SELECT COUNT(*) FROM verifactu_queue WHERE origen=''SUBSANACION''')) +
        ' | SIN_CLASIFICAR=' + IntToStr(ScalarInt(
          'SELECT COUNT(*) FROM verifactu_queue WHERE ' +
          'COALESCE(origen,''SIN_CLASIFICAR'')=''SIN_CLASIFICAR''')),
        vclInfo);
    end;
  end;

  if ColumnExists('verifactu_queue', 'registro_uid') then
  begin
    N := ScalarInt(
      'SELECT COUNT(*) FROM verifactu_queue ' +
      'WHERE COALESCE(registro_uid,'''')=''''');
    if N = 0 then
      AddCheck('VF-QUE-002D', 'Identidad técnica de registros',
        'Todos los registros tienen registro_uid.', vclOK)
    else
      AddCheck('VF-QUE-002D', 'Identidad técnica de registros',
        IntToStr(N) + ' registros carecen de registro_uid.', vclError);
  end;

  if ColumnExists('verifactu_queue', 'entorno') then
  begin
    N := ScalarInt(
      'SELECT COUNT(*) FROM verifactu_queue ' +
      'WHERE COALESCE(entorno,''SIN_CLASIFICAR'') NOT IN ' +
      '(''PRODUCCION'',''PRUEBAS'',''SIN_CLASIFICAR'')');
    if N = 0 then
      AddCheck('VF-QUE-003', 'Clasificación de entorno',
        'PRODUCCION / PRUEBAS / SIN_CLASIFICAR coherentes.', vclOK)
    else
      AddCheck('VF-QUE-003', 'Clasificación de entorno',
        IntToStr(N) + ' registros contienen un entorno desconocido.', vclWarning);

    N := ScalarInt(
      'SELECT COUNT(*) FROM verifactu_queue ' +
      'WHERE COALESCE(entorno,''SIN_CLASIFICAR'')=''SIN_CLASIFICAR''');
    if N > 0 then
      AddCheck('VF-QUE-004', 'Registros históricos sin clasificar',
        IntToStr(N) + ' registros. Es admisible para históricos anteriores a la migración.',
        vclInfo)
    else
      AddCheck('VF-QUE-004', 'Registros históricos sin clasificar',
        'No existen registros SIN_CLASIFICAR.', vclOK);
  end;

  if ColumnExists('verifactu_queue', 'claimed_until') then
  begin
    N := ScalarInt(
      'SELECT COUNT(*) FROM verifactu_queue ' +
      'WHERE estado=''EN_PROCESO'' ' +
      'AND (claimed_until IS NULL OR claimed_until < NOW())');
    if N = 0 then
      AddCheck('VF-QUE-005', 'Registros técnicos bloqueados',
        'No se detectan reclamaciones EN_PROCESO caducadas.', vclOK)
    else
      AddCheck('VF-QUE-005', 'Registros técnicos bloqueados',
        IntToStr(N) + ' registros EN_PROCESO tienen reclamación caducada.',
        vclWarning);
  end;
end;

procedure TfrmVFValidadorTecnico.CheckTechnicalTrace;
var
  N: Int64;
begin
  if not TableExists('verifactu_queue') then Exit;

  if ColumnExists('verifactu_queue', 'hash') then
  begin
    N := ScalarInt(
      'SELECT COUNT(*) FROM verifactu_queue ' +
      'WHERE estado=''ENVIADO'' AND COALESCE(hash,'''')=''''');
    if N = 0 then
      AddCheck('VF-TRZ-001', 'Hash en registros enviados',
        'Todos los registros ENVIADO tienen hash.', vclOK)
    else
      AddCheck('VF-TRZ-001', 'Hash en registros enviados',
        IntToStr(N) + ' registros ENVIADO carecen de hash.', vclError);
  end;

  if ColumnExists('verifactu_queue', 'payload_json') then
  begin
    N := ScalarInt(
      'SELECT COUNT(*) FROM verifactu_queue ' +
      'WHERE estado=''ENVIADO'' AND COALESCE(payload_json,'''')=''''');
    if N = 0 then
      AddCheck('VF-TRZ-002', 'Payload en registros enviados',
        'Todos los registros ENVIADO conservan payload_json.', vclOK)
    else
      AddCheck('VF-TRZ-002', 'Payload en registros enviados',
        IntToStr(N) + ' registros ENVIADO carecen de payload_json.', vclError);
  end;

  if ColumnExists('verifactu_queue', 'canonical') then
  begin
    N := ScalarInt(
      'SELECT COUNT(*) FROM verifactu_queue ' +
      'WHERE estado=''ENVIADO'' AND COALESCE(canonical,'''')=''''');
    if N = 0 then
      AddCheck('VF-TRZ-003', 'Canonical de auditoría',
        'Todos los registros ENVIADO tienen canonical.', vclOK)
    else
      AddCheck('VF-TRZ-003', 'Canonical de auditoría',
        IntToStr(N) + ' registros ENVIADO no conservan canonical. ' +
        'Puede corresponder a históricos anteriores a esta trazabilidad.',
        vclWarning);
  end;

  if ColumnExists('verifactu_queue', 'hash_algoritmo') then
  begin
    N := ScalarInt(
      'SELECT COUNT(*) FROM verifactu_queue ' +
      'WHERE COALESCE(hash_algoritmo,''SHA-256'')<>''SHA-256''');
    if N = 0 then
      AddCheck('VF-TRZ-004', 'Algoritmo de huella',
        'Los registros auditables indican SHA-256.', vclOK)
    else
      AddCheck('VF-TRZ-004', 'Algoritmo de huella',
        IntToStr(N) + ' registros indican un algoritmo distinto.', vclError);
  end;
end;

procedure TfrmVFValidadorTecnico.CheckResponses;
var
  CorrectCount, WithErrors, IncorrectCount, PendingCount, ErrorCount: Int64;
begin
  if not TableExists('verifactu_queue') then Exit;

  CorrectCount := ScalarInt(
    'SELECT COUNT(*) FROM verifactu_queue WHERE ' +
    'COALESCE(respuesta_text,'''') LIKE ''%EstadoRegistro>Correcto%''');
  WithErrors := ScalarInt(
    'SELECT COUNT(*) FROM verifactu_queue WHERE ' +
    'COALESCE(respuesta_text,'''') LIKE ''%EstadoRegistro>AceptadoConErrores%''');
  IncorrectCount := ScalarInt(
    'SELECT COUNT(*) FROM verifactu_queue WHERE ' +
    'COALESCE(respuesta_text,'''') LIKE ''%EstadoRegistro>Incorrecto%''');
  PendingCount := ScalarInt(
    'SELECT COUNT(*) FROM verifactu_queue WHERE estado=''PENDIENTE''');
  ErrorCount := ScalarInt(
    'SELECT COUNT(*) FROM verifactu_queue WHERE estado=''ERROR''');

  AddCheck('VF-RSP-001', 'Resumen de respuestas AEAT',
    'Correcto=' + IntToStr(CorrectCount) +
    ' | AceptadoConErrores=' + IntToStr(WithErrors) +
    ' | Incorrecto=' + IntToStr(IncorrectCount) +
    ' | Pendiente=' + IntToStr(PendingCount) +
    ' | Error técnico/cola=' + IntToStr(ErrorCount), vclInfo);

  if WithErrors > 0 then
    AddCheck('VF-SUB-001', 'Candidatos a revisión/subsanación',
      IntToStr(WithErrors) +
      ' registros figuran como AceptadoConErrores. Este será el siguiente bloque específico.',
      vclWarning)
  else
    AddCheck('VF-SUB-001', 'Candidatos a revisión/subsanación',
      'No hay registros AceptadoConErrores en la cola actual.', vclOK);

  if IncorrectCount > 0 then
    AddCheck('VF-SUB-002', 'Registros Incorrecto AEAT',
      IntToStr(IncorrectCount) +
      ' registros requieren diagnóstico antes de cualquier actuación.',
      vclWarning)
  else
    AddCheck('VF-SUB-002', 'Registros Incorrecto AEAT',
      'No hay registros clasificados como Incorrecto por la AEAT.', vclOK);
end;

procedure TfrmVFValidadorTecnico.FinishSummary;
begin
  LbCounters.Caption :=
    'Correctas: ' + IntToStr(FOK) +
    '     Avisos: ' + IntToStr(FWarnings) +
    '     Errores: ' + IntToStr(FErrors) +
    '     Información: ' + IntToStr(FInfo);

  if FErrors > 0 then
  begin
    LbResult.Caption := 'RESULTADO: REQUIERE CORRECCIÓN';
    LbResult.Font.Color := RGBToColor(185, 45, 45);
  end
  else if FWarnings > 0 then
  begin
    LbResult.Caption := 'RESULTADO: CORRECTO CON AVISOS';
    LbResult.Font.Color := RGBToColor(185, 105, 15);
  end
  else
  begin
    LbResult.Caption := 'RESULTADO: ARQUITECTURA CORRECTA';
    LbResult.Font.Color := RGBToColor(20, 125, 60);
  end;

  MemoReport.Lines.Add(StringOfChar('=', 76));
  MemoReport.Lines.Add(LbResult.Caption);
  MemoReport.Lines.Add(LbCounters.Caption);
  MemoReport.Lines.Add('');
  MemoReport.Lines.Add(
    'IMPORTANTE: este validador no modifica tablas, estados, hashes ni envía datos a la AEAT.');
end;

procedure TfrmVFValidadorTecnico.RunValidation;
begin
  Screen.Cursor := crHourGlass;
  BtnRun.Enabled := False;
  try
    ResetReport;
    Application.ProcessMessages;
    CheckStructure;
    Application.ProcessMessages;
    CheckIndexes;
    CheckStateDefinition;
    Application.ProcessMessages;
    CheckQueueCoherence;
    Application.ProcessMessages;
    CheckTechnicalTrace;
    Application.ProcessMessages;
    CheckResponses;
    FinishSummary;
  except
    on E: Exception do
    begin
      AddCheck('VF-VAL-999', 'Excepción durante la validación', E.Message, vclError);
      FinishSummary;
    end;
  end;
  BtnRun.Enabled := True;
  Screen.Cursor := crDefault;
end;

procedure TfrmVFValidadorTecnico.BtnRunClick(Sender: TObject);
begin
  RunValidation;
end;

procedure TfrmVFValidadorTecnico.BtnSaveClick(Sender: TObject);
var
  D: TSaveDialog;
begin
  D := TSaveDialog.Create(Self);
  try
    D.Title := 'Guardar validación técnica VeriFactu';
    D.Filter := 'Texto (*.txt)|*.txt|Todos los archivos|*';
    D.DefaultExt := 'txt';
    D.FileName := 'VALIDACION_VERIFACTU_' +
      FormatDateTime('yyyymmdd_hhnnss', Now) + '.txt';
    if D.Execute then
    begin
      MemoReport.Lines.SaveToFile(D.FileName);
      MessageDlg('Informe guardado correctamente:' + LineEnding + D.FileName,
        mtInformation, [mbOK], 0);
    end;
  finally
    D.Free;
  end;
end;

procedure TfrmVFValidadorTecnico.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmVFValidadorTecnico.FormKeyDownHandler(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

end.
