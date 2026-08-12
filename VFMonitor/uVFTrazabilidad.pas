unit uVFTrazabilidad;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, StdCtrls, ExtCtrls, Buttons,
  DBGrids, DB, Graphics, Grids, LCLType, ZConnection, ZDataset;

procedure VF_OpenTrazabilidad(AConn: TZConnection;
  const ASerie: string; const ANumero: Integer);

implementation

type
  TfrmVFTrazabilidad = class(TForm)
  private
    FConn: TZConnection;
    FSerie: string;
    FNumero: Integer;
    FSortField: string;
    FSortDesc: Boolean;

    HeaderPanel, SummaryPanel, DetailPanel, ButtonPanel: TPanel;
    LbTitle, LbSubtitle, LbSummary: TLabel;
    BtnRefresh, BtnClose: TBitBtn;
    Grid: TDBGrid;
    MemoDetail: TMemo;
    DS: TDataSource;
    Q, QAux: TZQuery;

    procedure BuildUI;
    procedure LoadData;
    procedure SetupColumns;
    function SortSQL: string;
    procedure GridTitleClick(Column: TColumn);
    procedure GridCellClick(Column: TColumn);
    procedure DataAfterScroll(DataSet: TDataSet);
    procedure RefreshDetail;
    procedure RefreshSummary;
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    constructor CreateWith(AConn: TZConnection;
      const ASerie: string; const ANumero: Integer); reintroduce;
  end;

procedure VF_OpenTrazabilidad(AConn: TZConnection;
  const ASerie: string; const ANumero: Integer);
var
  F: TfrmVFTrazabilidad;
begin
  if (AConn = nil) or (not AConn.Connected) then
  begin
    MessageDlg('Trazabilidad VeriFactu',
      'No existe una conexión activa con la base de datos.',
      mtError, [mbOK], 0);
    Exit;
  end;

  if (Trim(ASerie) = '') or (ANumero <= 0) then
  begin
    MessageDlg('Trazabilidad VeriFactu',
      'Seleccione primero un registro válido en el Centro de Control.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  F := TfrmVFTrazabilidad.CreateWith(AConn, ASerie, ANumero);
  F.Show;
end;

constructor TfrmVFTrazabilidad.CreateWith(AConn: TZConnection;
  const ASerie: string; const ANumero: Integer);
begin
  inherited CreateNew(nil, 1);
  Caption := 'Trazabilidad VeriFactu';
  Position := poScreenCenter;
  WindowState := wsMaximized;
  Width := 1450;
  Height := 850;
  KeyPreview := True;
  OnKeyDown := @FormKeyDown;

  FConn := AConn;
  FSerie := Trim(ASerie);
  FNumero := ANumero;
  FSortField := 'id';
  FSortDesc := False;

  BuildUI;

  Q := TZQuery.Create(Self);
  Q.Connection := FConn;
  Q.AfterScroll := @DataAfterScroll;

  QAux := TZQuery.Create(Self);
  QAux.Connection := FConn;

  DS := TDataSource.Create(Self);
  DS.DataSet := Q;
  Grid.DataSource := DS;

  LoadData;
end;

procedure TfrmVFTrazabilidad.BuildUI;
begin
  Color := clWhite;
  Font.Name := 'Sans';
  Font.Height := -13;

  HeaderPanel := TPanel.Create(Self);
  HeaderPanel.Parent := Self;
  HeaderPanel.Align := alTop;
  HeaderPanel.Height := 86;
  HeaderPanel.BevelOuter := bvNone;
  HeaderPanel.Color := clNavy;
  HeaderPanel.Caption := '';

  LbTitle := TLabel.Create(Self);
  LbTitle.Parent := HeaderPanel;
  LbTitle.SetBounds(20, 10, 850, 30);
  LbTitle.Caption := 'TRAZABILIDAD VERIFACTU';
  LbTitle.ParentFont := False;
  LbTitle.Font.Name := 'Sans';
  LbTitle.Font.Height := -22;
  LbTitle.Font.Style := [fsBold];
  LbTitle.Font.Color := clWhite;
  LbTitle.BringToFront;

  LbSubtitle := TLabel.Create(Self);
  LbSubtitle.Parent := HeaderPanel;
  LbSubtitle.SetBounds(20, 47, 1050, 22);
  LbSubtitle.Caption :=
    'Vida técnica del documento: registro original, subsanaciones, huellas y respuestas AEAT.';
  LbSubtitle.ParentFont := False;
  LbSubtitle.Font.Height := -12;
  LbSubtitle.Font.Color := clSilver;
  LbSubtitle.BringToFront;

  BtnClose := TBitBtn.Create(Self);
  BtnClose.Parent := HeaderPanel;
  BtnClose.Caption := 'Cerrar';
  BtnClose.SetBounds(HeaderPanel.Width - 140, 24, 115, 36);
  BtnClose.Anchors := [akTop, akRight];
  BtnClose.OnClick := @BtnCloseClick;

  SummaryPanel := TPanel.Create(Self);
  SummaryPanel.Parent := Self;
  SummaryPanel.Align := alTop;
  SummaryPanel.Height := 58;
  SummaryPanel.BevelOuter := bvNone;
  SummaryPanel.Color := RGBToColor(242, 246, 250);
  SummaryPanel.Caption := '';

  LbSummary := TLabel.Create(Self);
  LbSummary.Parent := SummaryPanel;
  LbSummary.SetBounds(18, 18, 1100, 25);
  LbSummary.Font.Style := [fsBold];
  LbSummary.Font.Color := clNavy;
  LbSummary.Caption := 'Cargando trazabilidad...';
  LbSummary.BringToFront;

  ButtonPanel := TPanel.Create(Self);
  ButtonPanel.Parent := Self;
  ButtonPanel.Align := alTop;
  ButtonPanel.Height := 52;
  ButtonPanel.BevelOuter := bvNone;
  ButtonPanel.Color := clWhite;
  ButtonPanel.Caption := '';

  BtnRefresh := TBitBtn.Create(Self);
  BtnRefresh.Parent := ButtonPanel;
  BtnRefresh.SetBounds(18, 8, 145, 34);
  BtnRefresh.Caption := 'Refrescar';
  BtnRefresh.OnClick := @BtnRefreshClick;

  DetailPanel := TPanel.Create(Self);
  DetailPanel.Parent := Self;
  DetailPanel.Align := alBottom;
  DetailPanel.Height := 310;
  DetailPanel.BevelOuter := bvNone;
  DetailPanel.Color := RGBToColor(246, 248, 251);
  DetailPanel.Caption := '';

  MemoDetail := TMemo.Create(Self);
  MemoDetail.Parent := DetailPanel;
  MemoDetail.SetBounds(14, 12, DetailPanel.ClientWidth - 28,
    DetailPanel.ClientHeight - 24);
  MemoDetail.Anchors := [akLeft, akTop, akRight, akBottom];
  MemoDetail.ReadOnly := True;
  MemoDetail.ScrollBars := ssAutoBoth;
  MemoDetail.WordWrap := False;
  MemoDetail.Font.Name := 'Monospace';
  MemoDetail.Font.Height := -12;
  MemoDetail.Color := clWhite;

  Grid := TDBGrid.Create(Self);
  Grid.Parent := Self;
  Grid.Align := alClient;
  Grid.Options := Grid.Options + [dgTitles, dgIndicator, dgRowSelect];
  Grid.Color := clWhite;
  Grid.FixedColor := RGBToColor(226, 230, 235);
  Grid.OnTitleClick := @GridTitleClick;
  Grid.OnCellClick := @GridCellClick;
end;

function TfrmVFTrazabilidad.SortSQL: string;
var
  F: string;
begin
  F := LowerCase(Trim(FSortField));

  if F = 'id' then Result := 'q.id'
  else if F = 'registro_uid' then Result := 'q.registro_uid'
  else if F = 'origen' then Result := 'q.origen'
  else if F = 'tipo_factura' then Result := 'q.tipo_factura'
  else if F = 'fecha' then Result := 'q.fecha'
  else if F = 'hora' then Result := 'q.hora'
  else if F = 'entorno' then Result := 'q.entorno'
  else if F = 'estado' then Result := 'q.estado'
  else if F = 'resultado' then Result := 'resultado'
  else if F = 'sub_estado' then Result := 'sub_estado'
  else if F = 'intentos' then Result := 'q.intentos'
  else Result := 'q.id';

  if FSortDesc then
    Result := Result + ' DESC'
  else
    Result := Result + ' ASC';

  Result := Result + ', q.id ASC';
end;

procedure TfrmVFTrazabilidad.LoadData;
begin
  Q.Close;
  Q.SQL.Text :=
    'SELECT q.id,q.serie,q.numero,q.registro_uid,q.origen,q.tipo_factura,' +
    'q.fecha,q.hora,q.entorno,q.estado,q.intentos,q.last_attempt_at,' +
    'q.hash,q.hash_prev,q.hash_input,q.hash_fecha_huso,q.respuesta_text,' +
    'q.last_error,q.payload_json,' +
    's.id AS sub_id,s.estado AS sub_estado,s.operacion AS sub_operacion,' +
    's.indicador_subsanacion,s.indicador_rechazo_previo,s.motivo,' +
    's.chain_queue_id,s.chain_serie,s.chain_numero,s.chain_fecha,s.chain_hash,' +
    's.xml_preparado,s.xml_validated_at,' +
    'CASE ' +
    ' WHEN COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>Correcto%'' ' +
    '   THEN ''CORRECTO'' ' +
    ' WHEN COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>AceptadoConErrores%'' ' +
    '   THEN ''ACEPTADO CON ERRORES'' ' +
    ' WHEN COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>Incorrecto%'' ' +
    '   THEN ''INCORRECTO AEAT'' ' +
    ' WHEN q.estado=''ERROR'' THEN ''ERROR'' ' +
    ' ELSE q.estado END AS resultado ' +
    'FROM verifactu_queue q ' +
    'LEFT JOIN verifactu_subsanaciones s ON s.id=(' +
    '  SELECT MAX(s2.id) FROM verifactu_subsanaciones s2 ' +
    '  WHERE s2.nuevo_queue_id=q.id OR ' +
    '        (s2.queue_id=q.id AND COALESCE(q.registro_uid,''ORIG'')=''ORIG'')' +
    ') ' +
    'WHERE q.serie=:s AND q.numero=:n ' +
    'ORDER BY ' + SortSQL;
  Q.ParamCheck := True;
  Q.ParamByName('s').AsString := FSerie;
  Q.ParamByName('n').AsInteger := FNumero;

  try
    Q.Open;
    SetupColumns;
    RefreshSummary;
    RefreshDetail;
  except
    on E: Exception do
      MessageDlg('No se ha podido cargar la trazabilidad:' + LineEnding +
        E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmVFTrazabilidad.SetupColumns;

  function SortTitle(const FieldName, TitleText: string): string;
  begin
    Result := TitleText;
    if SameText(FSortField, FieldName) then
      if FSortDesc then
        Result := TitleText + ' ▼'
      else
        Result := TitleText + ' ▲';
  end;

  procedure AddCol(const FieldName, TitleText: string; AWidth: Integer);
  var
    C: TColumn;
  begin
    C := Grid.Columns.Add;
    C.FieldName := FieldName;
    C.Title.Caption := SortTitle(FieldName, TitleText);
    C.Width := AWidth;
  end;

begin
  if not Q.Active then Exit;

  Grid.Columns.BeginUpdate;
  try
    Grid.Columns.Clear;
    AddCol('id', 'ID', 70);
    AddCol('registro_uid', 'Registro', 110);
    AddCol('origen', 'Origen', 125);
    AddCol('tipo_factura', 'Tipo', 65);
    AddCol('fecha', 'Fecha', 95);
    AddCol('hora', 'Hora', 80);
    AddCol('entorno', 'Entorno', 110);
    AddCol('estado', 'Cola', 115);
    AddCol('resultado', 'Resultado AEAT', 175);
    AddCol('sub_estado', 'Estado subsanación', 185);
    AddCol('intentos', 'Intentos', 70);
    AddCol('last_attempt_at', 'Último intento', 145);
  finally
    Grid.Columns.EndUpdate;
  end;
end;

procedure TfrmVFTrazabilidad.RefreshSummary;
var
  Total, Orig, Subs, Sent, Errors: Integer;
begin
  Total := 0;
  Orig := 0;
  Subs := 0;
  Sent := 0;
  Errors := 0;

  QAux.Close;
  QAux.SQL.Text :=
    'SELECT COUNT(*) AS total,' +
    'SUM(CASE WHEN COALESCE(registro_uid,''ORIG'')=''ORIG'' THEN 1 ELSE 0 END) AS orig,' +
    'SUM(CASE WHEN COALESCE(registro_uid,''ORIG'')<>''ORIG'' THEN 1 ELSE 0 END) AS subs,' +
    'SUM(CASE WHEN estado=''ENVIADO'' THEN 1 ELSE 0 END) AS sent,' +
    'SUM(CASE WHEN estado=''ERROR'' THEN 1 ELSE 0 END) AS errors ' +
    'FROM verifactu_queue WHERE serie=:s AND numero=:n';
  QAux.ParamCheck := True;
  QAux.ParamByName('s').AsString := FSerie;
  QAux.ParamByName('n').AsInteger := FNumero;
  QAux.Open;

  if not QAux.EOF then
  begin
    Total := QAux.FieldByName('total').AsInteger;
    Orig := QAux.FieldByName('orig').AsInteger;
    Subs := QAux.FieldByName('subs').AsInteger;
    Sent := QAux.FieldByName('sent').AsInteger;
    Errors := QAux.FieldByName('errors').AsInteger;
  end;

  LbSummary.Caption :=
    FSerie + '/' + IntToStr(FNumero) +
    '   · Registros: ' + IntToStr(Total) +
    '   · ORIG: ' + IntToStr(Orig) +
    '   · SUB: ' + IntToStr(Subs) +
    '   · Enviados: ' + IntToStr(Sent) +
    '   · Error: ' + IntToStr(Errors);
end;

procedure TfrmVFTrazabilidad.RefreshDetail;

  procedure AddField(const CaptionText, FieldName: string);
  var
    V: string;
  begin
    if Q.FindField(FieldName) = nil then Exit;
    if Q.FieldByName(FieldName).IsNull then
      V := ''
    else
      V := Q.FieldByName(FieldName).AsString;
    MemoDetail.Lines.Add(CaptionText + ': ' + V);
  end;

  procedure AddBlock(const CaptionText, FieldName: string);
  var
    V: string;
  begin
    if Q.FindField(FieldName) = nil then Exit;
    V := Q.FieldByName(FieldName).AsString;
    if Trim(V) = '' then Exit;
    MemoDetail.Lines.Add('');
    MemoDetail.Lines.Add(CaptionText);
    MemoDetail.Lines.Add(StringOfChar('-', 78));
    MemoDetail.Lines.Add(V);
  end;

begin
  MemoDetail.Clear;

  if (not Q.Active) or Q.IsEmpty then
  begin
    MemoDetail.Lines.Text := 'No existen registros para esta identidad fiscal.';
    Exit;
  end;

  MemoDetail.Lines.Add('IDENTIDAD DEL REGISTRO');
  MemoDetail.Lines.Add('=====================');
  AddField('Queue ID', 'id');
  AddField('Serie', 'serie');
  AddField('Número', 'numero');
  AddField('Registro técnico', 'registro_uid');
  AddField('Origen', 'origen');
  AddField('Tipo fiscal', 'tipo_factura');
  AddField('Entorno', 'entorno');
  AddField('Estado cola', 'estado');
  AddField('Resultado AEAT', 'resultado');
  AddField('Intentos', 'intentos');
  AddField('Último intento', 'last_attempt_at');

  MemoDetail.Lines.Add('');
  MemoDetail.Lines.Add('CADENA CRIPTOGRÁFICA');
  MemoDetail.Lines.Add('====================');
  AddField('Hash previo', 'hash_prev');
  AddField('Hash', 'hash');
  AddField('Fecha/hora con huso', 'hash_fecha_huso');

  if not Q.FieldByName('sub_id').IsNull then
  begin
    MemoDetail.Lines.Add('');
    MemoDetail.Lines.Add('SUBSANACIÓN');
    MemoDetail.Lines.Add('===========');
    AddField('Subsanación ID', 'sub_id');
    AddField('Estado subsanación', 'sub_estado');
    AddField('Operación', 'sub_operacion');
    AddField('Indicador Subsanación', 'indicador_subsanacion');
    AddField('Rechazo previo', 'indicador_rechazo_previo');
    AddField('Motivo', 'motivo');

    MemoDetail.Lines.Add('');
    MemoDetail.Lines.Add('ANCLA / REGISTRO ANTERIOR');
    MemoDetail.Lines.Add('=========================');
    AddField('Queue ID anterior', 'chain_queue_id');
    AddField('Serie anterior', 'chain_serie');
    AddField('Número anterior', 'chain_numero');
    AddField('Fecha anterior', 'chain_fecha');
    AddField('Hash anterior', 'chain_hash');
    AddField('XML validado en', 'xml_validated_at');
  end;

  AddBlock('ENTRADA SIF-B / HASH_INPUT', 'hash_input');
  AddBlock('ÚLTIMO ERROR', 'last_error');
  AddBlock('RESPUESTA AEAT COMPLETA', 'respuesta_text');
  AddBlock('XML DE SUBSANACIÓN VALIDADO', 'xml_preparado');
  AddBlock('PAYLOAD JSON', 'payload_json');

  MemoDetail.SelStart := 0;
end;

procedure TfrmVFTrazabilidad.GridTitleClick(Column: TColumn);
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

procedure TfrmVFTrazabilidad.GridCellClick(Column: TColumn);
begin
  RefreshDetail;
end;

procedure TfrmVFTrazabilidad.DataAfterScroll(DataSet: TDataSet);
begin
  RefreshDetail;
end;

procedure TfrmVFTrazabilidad.BtnRefreshClick(Sender: TObject);
begin
  LoadData;
end;

procedure TfrmVFTrazabilidad.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmVFTrazabilidad.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

end.
