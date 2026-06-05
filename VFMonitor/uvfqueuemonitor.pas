unit uvfqueuemonitor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, StdCtrls, ExtCtrls,
  DBGrids, DB, Graphics, Grids, LCLType, // RGBToColor + Canvas
  ZConnection, ZDataset;

procedure VFQ_OpenMonitor(const Conn: TZConnection; const Tienda: string);

implementation

uses
  uVeriFactu, uVeriFactuDispatcher;

type
  TfrmVFQMonitor = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;

    FSortField: string;
    FSortDesc: Boolean;

    TopPanel: TPanel;
    BtnRefresh, BtnRetry, BtnDetail, BtnClose: TButton;
    CbEstado: TComboBox;
    EdSerie, EdNumero, EdCliente: TEdit;

    // Sin TDateTimePicker: usamos TEdit
    EdDesde, EdHasta: TEdit;
    LbTienda, LbEstado, LbSerie, LbNumero, LbCliente, LbDesde, LbHasta: TLabel;

    Grid: TDBGrid;
    DS: TDataSource;
    Q: TZQuery;

    procedure CreateUI;
    procedure PopulateEstado;
    procedure RefreshData;
    procedure SetupGridColumns;

    // Mostrar detalle resumido de respuesta AEAT (columna 'Respuesta')
    procedure VFRespuestaGetText(Sender: TField; var aText: string; DisplayText: Boolean);

    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnRetryClick(Sender: TObject);
    procedure BtnDetailClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);

    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure CbEstadoChange(Sender: TObject);

    procedure GridDblClick(Sender: TObject);
    procedure GridTitleClick(Column: TColumn);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);

    function SafeTienda(const S: string): string;
    function HistTableName: string;
    function PromptReason(out ReasonText: string): Boolean;

    function ParseDateISO(const S: string; out D: TDateTime): Boolean;
    function RowColorForEstado(const Estado: string): TColor;
    function SortExprForField(const FieldName: string): string;

  public
    constructor CreateWith(const Conn: TZConnection; const ATienda: string); reintroduce;
  end;

procedure VFQ_OpenMonitor(const Conn: TZConnection; const Tienda: string);
var
  F: TfrmVFQMonitor;
begin
  if Conn = nil then
  begin
    ShowMessage('VF Monitor: Conn=nil');
    Exit;
  end;
  if not Conn.Connected then
  begin
    ShowMessage('VF Monitor: la conexión a BD no está conectada');
    Exit;
  end;

  F := TfrmVFQMonitor.CreateWith(Conn, Tienda);
  F.Show;
end;

{ TfrmVFQMonitor }

constructor TfrmVFQMonitor.CreateWith(const Conn: TZConnection; const ATienda: string);
begin
  // Form sin .lfm -> CreateNew
  inherited CreateNew(nil, 1);

  Caption := 'Monitor VeriFactu (cola)';
  Position := poScreenCenter;
  Width := 1450;
  Height := 780;

  // 1) Abrir maximizado
  WindowState := wsMaximized;
  KeyPreview := True;
  OnKeyDown := @FormKeyDown;

  FConn := Conn;
  FTienda := SafeTienda(ATienda);

  CreateUI;

  Q := TZQuery.Create(Self);
  Q.Connection := FConn;

  DS := TDataSource.Create(Self);
  DS.DataSet := Q;
  Grid.DataSource := DS;

  PopulateEstado;

  // Valores por defecto: últimos 30 días
  EdDesde.Text := FormatDateTime('yyyy"-"mm"-"dd', Date - 30);
  EdHasta.Text := FormatDateTime('yyyy"-"mm"-"dd', Date);

  FSortField := 'fecha';
  FSortDesc := True;

  RefreshData;
end;

procedure TfrmVFQMonitor.CreateUI;
begin
  TopPanel := TPanel.Create(Self);
  TopPanel.Parent := Self;
  TopPanel.Align := alTop;
  TopPanel.Height := 110;

  // 2) Botón cerrar a la derecha
  BtnClose := TButton.Create(Self);
  BtnClose.Parent := TopPanel;
  BtnClose.Caption := 'Cerrar';
  BtnClose.Width := 90;
  BtnClose.Top := 8;
  BtnClose.Left := TopPanel.Width - BtnClose.Width - 10;
  BtnClose.Anchors := [akTop, akRight];
  BtnClose.OnClick := @BtnCloseClick;

  LbTienda := TLabel.Create(Self);
  LbTienda.Parent := TopPanel;
  LbTienda.Caption := 'Tienda: ' + FTienda;
  LbTienda.Left := 10;
  LbTienda.Top := 10;

  LbEstado := TLabel.Create(Self);
  LbEstado.Parent := TopPanel;
  LbEstado.Caption := 'Estado:';
  LbEstado.Left := 10;
  LbEstado.Top := 44;

  CbEstado := TComboBox.Create(Self);
  CbEstado.Parent := TopPanel;
  CbEstado.Left := 70;
  CbEstado.Top := 40;
  CbEstado.Width := 160;
  CbEstado.Style := csDropDownList;
  CbEstado.OnChange := @CbEstadoChange;

  LbSerie := TLabel.Create(Self);
  LbSerie.Parent := TopPanel;
  LbSerie.Caption := 'Serie (cola):';
  LbSerie.Left := 245;
  LbSerie.Top := 44;

  EdSerie := TEdit.Create(Self);
  EdSerie.Parent := TopPanel;
  EdSerie.Left := 325;
  EdSerie.Top := 40;
  EdSerie.Width := 140;

  LbNumero := TLabel.Create(Self);
  LbNumero.Parent := TopPanel;
  LbNumero.Caption := 'Número:';
  LbNumero.Left := 475;
  LbNumero.Top := 44;

  EdNumero := TEdit.Create(Self);
  EdNumero.Parent := TopPanel;
  EdNumero.Left := 535;
  EdNumero.Top := 40;
  EdNumero.Width := 90;

  LbCliente := TLabel.Create(Self);
  LbCliente.Parent := TopPanel;
  LbCliente.Caption := 'Cliente:';
  LbCliente.Left := 635;
  LbCliente.Top := 44;

  EdCliente := TEdit.Create(Self);
  EdCliente.Parent := TopPanel;
  EdCliente.Left := 695;
  EdCliente.Top := 40;
  EdCliente.Width := 90;

  LbDesde := TLabel.Create(Self);
  LbDesde.Parent := TopPanel;
  LbDesde.Caption := 'Desde (YYYY-MM-DD):';
  LbDesde.Left := 800;
  LbDesde.Top := 44;

  EdDesde := TEdit.Create(Self);
  EdDesde.Parent := TopPanel;
  EdDesde.Left := 940;
  EdDesde.Top := 40;
  EdDesde.Width := 110;

  LbHasta := TLabel.Create(Self);
  LbHasta.Parent := TopPanel;
  LbHasta.Caption := 'Hasta (YYYY-MM-DD):';
  LbHasta.Left := 1060;
  LbHasta.Top := 44;

  EdHasta := TEdit.Create(Self);
  EdHasta.Parent := TopPanel;
  EdHasta.Left := 1195;
  EdHasta.Top := 40;
  EdHasta.Width := 110;

  BtnRefresh := TButton.Create(Self);
  BtnRefresh.Parent := TopPanel;
  BtnRefresh.Caption := 'Refrescar';
  BtnRefresh.Left := 245;
  BtnRefresh.Top := 75;
  BtnRefresh.OnClick := @BtnRefreshClick;

  BtnRetry := TButton.Create(Self);
  BtnRetry.Parent := TopPanel;
  BtnRetry.Caption := 'Reintentar / Reenviar';
  BtnRetry.Left := 340;
  BtnRetry.Top := 75;
  BtnRetry.Width := 160;
  BtnRetry.OnClick := @BtnRetryClick;

  BtnDetail := TButton.Create(Self);
  BtnDetail.Parent := TopPanel;
  BtnDetail.Caption := 'Ver detalle';
  BtnDetail.Left := 510;
  BtnDetail.Top := 75;
  BtnDetail.OnClick := @BtnDetailClick;

  Grid := TDBGrid.Create(Self);
  Grid.Parent := Self;
  Grid.Align := alClient;
  Grid.Options := Grid.Options + [dgTitles, dgIndicator, dgRowSelect, dgAutoSizeColumns];
  Grid.OnDblClick := @GridDblClick;
  Grid.OnTitleClick := @GridTitleClick;

  // 3) Coloreado de filas
  Grid.DefaultDrawing := False;
  Grid.OnDrawColumnCell := @GridDrawColumnCell;
end;

procedure TfrmVFQMonitor.PopulateEstado;
begin
  CbEstado.Items.Clear;
  CbEstado.Items.Add('Todos');
  CbEstado.Items.Add('PENDIENTE');
  CbEstado.Items.Add('EN_PROCESO');
  CbEstado.Items.Add('ENVIADO');
  CbEstado.Items.Add('ERROR');
  CbEstado.ItemIndex := 0;
end;

function TfrmVFQMonitor.SafeTienda(const S: string): string;
var
  I: Integer;
begin
  Result := Trim(S);
  if Result = '' then Result := '0000';
  if Length(Result) <> 4 then Result := '0000';
  for I := 1 to 4 do
    if not (Result[I] in ['0'..'9']) then
      Exit('0000');
end;

function TfrmVFQMonitor.HistTableName: string;
begin
  Result := 'hisopcc' + FTienda;
end;

function TfrmVFQMonitor.ParseDateISO(const S: string; out D: TDateTime): Boolean;
var
  FS: TFormatSettings;
  SS: string;
begin
  SS := Trim(S);
  FS := DefaultFormatSettings;
  FS.DateSeparator := '-';
  FS.ShortDateFormat := 'yyyy-mm-dd';
  Result := TryStrToDate(SS, D, FS);
end;

function TfrmVFQMonitor.RowColorForEstado(const Estado: string): TColor;
begin
  // Base: amarillo suave (estilo "info")
  Result := RGBToColor(255, 250, 230);

  if SameText(Estado, 'CORRECTO') then
    Result := RGBToColor(230, 255, 230)     // verde suave
  else if SameText(Estado, 'ENVIADO') then
    Result := RGBToColor(230, 255, 230)     // verde suave
  else if SameText(Estado, 'ACEPTADO CON ERRORES') then
    Result := RGBToColor(255, 245, 210)     // naranja suave
  else if (Pos('ERROR', UpperCase(Estado)) > 0) or
          (Pos('INCORRECTO', UpperCase(Estado)) > 0) or
          (Pos('INVALIDA', UpperCase(Estado)) > 0) or
          (Pos('INVÁLIDA', UpperCase(Estado)) > 0) then
    Result := RGBToColor(255, 230, 230)     // rojo suave
  else if SameText(Estado, 'NO VERIFICADO') then
    Result := RGBToColor(255, 245, 210)     // naranja suave
  else if SameText(Estado, 'EN_PROCESO') then
    Result := RGBToColor(230, 240, 255)     // azul suave
  else if SameText(Estado, 'PENDIENTE') then
    Result := RGBToColor(255, 250, 230);    // amarillo suave
end;

function TfrmVFQMonitor.SortExprForField(const FieldName: string): string;
begin
  // Whitelist de campos ordenables -> expresión SQL segura
  // (evitamos inyección / nombres raros)
  if SameText(FieldName, 'fecha') then Exit('q.fecha');
  if SameText(FieldName, 'hora') then Exit('q.hora');
  if SameText(FieldName, 'serie') then Exit('q.serie');
  if SameText(FieldName, 'numero') then Exit('q.numero');
  if SameText(FieldName, 'total_con_iva') then Exit('q.total_con_iva');
  if SameText(FieldName, 'estado') then Exit('q.estado');
  if SameText(FieldName, 'claimed_by') then Exit('q.claimed_by');
  if SameText(FieldName, 'PuestoVenta') then Exit('h.HO2');

  // Aliases calculados: se pueden ordenar por alias en MySQL/MariaDB
  if SameText(FieldName, 'vf_resultado') then Exit('vf_resultado');
  if SameText(FieldName, 'RectInfo') then Exit('RectInfo');
  if SameText(FieldName, 'vf_motivo') then Exit('vf_motivo');

  // Campos del histórico (join)
  if SameText(FieldName, 'CodCliente') then Exit('h.HO8');
  if SameText(FieldName, 'NIF') then Exit('h.HO19');
  if SameText(FieldName, 'intentos') then Exit('q.intentos');
  if SameText(FieldName, 'last_attempt_at') then Exit('q.last_attempt_at');

  // Por defecto
  Result := 'q.fecha';
end;

procedure TfrmVFQMonitor.RefreshData;
var
  SortDir: string;
  SortExpr: string;
  EstadoStr, Serie, Cliente: string;
  HaveEstado, HaveNum: Boolean;
  Num: Integer;
  D1, D2: TDateTime;
begin
  EstadoStr := '';
  HaveEstado := CbEstado.ItemIndex > 0;
  if HaveEstado then EstadoStr := CbEstado.Items[CbEstado.ItemIndex];

  Serie := Trim(EdSerie.Text);
  Cliente := Trim(EdCliente.Text);
  HaveNum := TryStrToInt(Trim(EdNumero.Text), Num);

  if not ParseDateISO(EdDesde.Text, D1) then D1 := Date - 30;
  if not ParseDateISO(EdHasta.Text, D2) then D2 := Date;

  if FSortDesc then SortDir := ' DESC' else SortDir := ' ASC';
  SortExpr := SortExprForField(FSortField);

  Q.Close;
  Q.SQL.Clear;

  Q.SQL.Text :=
    'SELECT '+
    '  q.id, q.fecha, q.hora, q.serie, q.numero, q.tipo_factura, '+
    '  q.total_con_iva, q.estado, q.claimed_by, '+
    '  CASE '+
    '    WHEN COALESCE(q.last_error,'''') LIKE ''%key values mismatch%'' THEN ''ERROR CERTIFICADO'' '+
    '    WHEN COALESCE(q.last_error,'''') LIKE ''%PEM routines%'' THEN ''ERROR CERTIFICADO'' '+
    '    WHEN COALESCE(q.last_error,'''') LIKE ''%no start line%'' THEN ''ERROR CERTIFICADO'' '+
    '    WHEN COALESCE(q.last_error,'''') LIKE ''%HTTPMethod%'' THEN ''ERROR COMUNICACION'' '+
    '    WHEN COALESCE(q.last_error,'''') LIKE ''%sin respuesta HTTP%'' THEN ''ERROR COMUNICACION'' '+
    '    WHEN COALESCE(q.last_error,'''') LIKE ''%SockErr%'' THEN ''ERROR COMUNICACION'' '+
    '    WHEN COALESCE(q.last_error,'''') LIKE ''%SSLErr%'' THEN ''ERROR SSL'' '+
    '    WHEN COALESCE(q.respuesta_text,'''') LIKE ''%<wsdl:definitions%'' THEN ''RESPUESTA INVALIDA'' '+
    '    WHEN COALESCE(q.respuesta_text,'''') LIKE ''%SistemaFacturacion.wsdl%'' THEN ''RESPUESTA INVALIDA'' '+
    '    WHEN COALESCE(q.respuesta_text,'''') LIKE ''%<env:Fault%'' THEN ''ERROR SOAP'' '+
    '    WHEN COALESCE(q.respuesta_text,'''') LIKE ''%<soap:Fault%'' THEN ''ERROR SOAP'' '+
    '    WHEN COALESCE(q.respuesta_text,'''') LIKE ''%faultstring%'' THEN ''ERROR SOAP'' '+
    '    WHEN COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>AceptadoConErrores%'' THEN ''ACEPTADO CON ERRORES'' '+
    '    WHEN COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>Incorrecto%'' THEN ''INCORRECTO AEAT'' '+
    '    WHEN COALESCE(q.respuesta_text,'''') LIKE ''%RespuestaRegFactuSistemaFacturacion%'' '+
    '     AND COALESCE(q.respuesta_text,'''') LIKE ''%EstadoEnvio>Correcto%'' '+
    '     AND COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>Correcto%'' THEN ''CORRECTO'' '+
    '    WHEN q.estado = ''ERROR'' THEN ''ERROR'' '+
    '    WHEN q.estado = ''ENVIADO'' THEN ''NO VERIFICADO'' '+
    '    ELSE q.estado '+
    '  END AS vf_resultado, '+
    '  h.HO20_RECT AS RectInfo, '+
    '  CASE '+
    '    WHEN COALESCE(q.last_error,'''') LIKE ''%key values mismatch%'' THEN ''El certificado y la clave privada no corresponden entre si.'' '+
    '    WHEN COALESCE(q.last_error,'''') LIKE ''%PEM routines%'' THEN ''PEM/certificado invalido o P12 tratado como PEM.'' '+
    '    WHEN COALESCE(q.last_error,'''') LIKE ''%no start line%'' THEN ''PEM invalido: no se encontro BEGIN CERTIFICATE/PRIVATE KEY.'' '+
    '    WHEN COALESCE(q.last_error,'''') LIKE ''%HTTPMethod%'' THEN LEFT(COALESCE(q.last_error,''''), 255) '+
    '    WHEN COALESCE(q.last_error,'''') LIKE ''%SockErr%'' THEN LEFT(COALESCE(q.last_error,''''), 255) '+
    '    WHEN COALESCE(q.last_error,'''') LIKE ''%SSLErr%'' THEN LEFT(COALESCE(q.last_error,''''), 255) '+
    '    WHEN COALESCE(q.respuesta_text,'''') LIKE ''%<wsdl:definitions%'' THEN ''Respuesta invalida: se recibio WSDL, no respuesta SOAP AEAT.'' '+
    '    WHEN COALESCE(q.respuesta_text,'''') LIKE ''%SistemaFacturacion.wsdl%'' THEN ''Respuesta invalida: se recibio WSDL, no respuesta SOAP AEAT.'' '+
    '    WHEN COALESCE(q.respuesta_text,'''') LIKE ''%Codigo[404]%'' THEN ''SOAP Fault 404: Web Service no habilitado/desactivado temporalmente.'' '+
    '    WHEN COALESCE(q.respuesta_text,'''') LIKE ''%faultstring%'' THEN LEFT(COALESCE(q.respuesta_text,''''), 255) '+
    '    WHEN COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>Incorrecto%'' THEN LEFT(COALESCE(q.respuesta_text,''''), 255) '+
    '    WHEN COALESCE(q.respuesta_text,'''') LIKE ''%EstadoRegistro>AceptadoConErrores%'' THEN LEFT(COALESCE(q.respuesta_text,''''), 255) '+
    '    WHEN q.estado = ''ERROR'' THEN COALESCE(NULLIF(q.last_error,''''), LEFT(COALESCE(q.respuesta_text,''''), 255)) '+
    '    WHEN q.estado = ''ENVIADO'' THEN ''Enviado en cola, pero la respuesta no ha podido validarse como Correcto.'' '+
    '    ELSE '''' '+
    '  END AS vf_motivo, '+
    '  q.intentos, q.last_attempt_at, q.last_error, q.respuesta_text, NULL AS vf_respuesta, '+
    '  q.hash, q.hash_prev, q.token, '+
    '  CASE WHEN q.serie LIKE ''FS-%'' THEN SUBSTRING(q.serie,4) ELSE q.serie END AS serie_hist, '+
    '  h.HO2  AS PuestoVenta, '+
    '  h.HO8  AS CodCliente, '+
    '  h.HO19 AS NIF, '+
    '  h.HO5  AS TipoHist '+
    'FROM verifactu_queue q '+
    'LEFT JOIN ' + HistTableName + ' h '+
    '  ON h.HO0 = q.fecha '+
    ' AND h.HO1 = q.hora '+
    ' AND h.HO3 = q.numero '+
    ' AND h.HO4 = (CASE WHEN q.serie LIKE ''FS-%'' THEN SUBSTRING(q.serie,4) ELSE q.serie END) '+
    ' AND ( '+
    '      (q.serie LIKE ''FS-%'' AND h.HO5 IN (''NT'',''NS'')) '+
    '   OR (q.serie NOT LIKE ''FS-%'' AND h.HO5 = ''FA'') '+
    ' ) '+
    'WHERE q.fecha BETWEEN :D1 AND :D2 ';

  if HaveEstado then
    Q.SQL.Add(' AND q.estado = :ESTADO ');

  if Serie <> '' then
    Q.SQL.Add(' AND q.serie = :SERIE ');

  if HaveNum then
    Q.SQL.Add(' AND q.numero = :NUMERO ');

  if Cliente <> '' then
    Q.SQL.Add(' AND h.HO8 = :CLIENTE ');

  if SameText(SortExpr, 'q.fecha') then
    Q.SQL.Add('ORDER BY ' + SortExpr + SortDir + ', q.hora DESC, q.serie, q.numero')
  else
    Q.SQL.Add('ORDER BY ' + SortExpr + SortDir + ', q.fecha DESC, q.hora DESC, q.serie, q.numero');

// Asegurar que existen los parámetros (:D1, :D2, etc.) antes de asignarlos.
// En algunos entornos Zeos puede no autogenerarlos al vuelo y dispara:
//   Parameter "D1" not found.
Q.ParamCheck := True;

if Q.Params.FindParam('D1') = nil then
  Q.Params.CreateParam(ftDate, 'D1', ptInput);
if Q.Params.FindParam('D2') = nil then
  Q.Params.CreateParam(ftDate, 'D2', ptInput);

if HaveEstado and (Q.Params.FindParam('ESTADO') = nil) then
  Q.Params.CreateParam(ftString, 'ESTADO', ptInput);
if (Serie <> '') and (Q.Params.FindParam('SERIE') = nil) then
  Q.Params.CreateParam(ftString, 'SERIE', ptInput);
if HaveNum and (Q.Params.FindParam('NUMERO') = nil) then
  Q.Params.CreateParam(ftInteger, 'NUMERO', ptInput);
if (Cliente <> '') and (Q.Params.FindParam('CLIENTE') = nil) then
  Q.Params.CreateParam(ftString, 'CLIENTE', ptInput);

// Asignación de parámetros
Q.ParamByName('D1').AsDate := D1;
Q.ParamByName('D2').AsDate := D2;

if HaveEstado then Q.ParamByName('ESTADO').AsString := EstadoStr;
  if Serie <> '' then Q.ParamByName('SERIE').AsString := Serie;
  if HaveNum then Q.ParamByName('NUMERO').AsInteger := Num;
  if Cliente <> '' then Q.ParamByName('CLIENTE').AsString := Cliente;

  try
    Q.Open;
    SetupGridColumns;
  except
    on E: Exception do
      ShowMessage('VF Monitor: error al refrescar: ' + E.Message);
  end;
end;

procedure TfrmVFQMonitor.CbEstadoChange(Sender: TObject);
begin
  // Refrescar automáticamente al cambiar el estado (evita tener que pulsar "Refrescar")
  FSortField := 'fecha';
  FSortDesc := True;

  RefreshData;
end;

procedure TfrmVFQMonitor.SetupGridColumns;
  procedure AddCol(const FieldName, Title: string; const W: Integer);
  var
    C: TColumn;
  begin
    C := Grid.Columns.Add;
    C.FieldName := FieldName;
    if Title <> '' then C.Title.Caption := Title;
    if W > 0 then C.Width := W;
  end;
begin
  // Reordenar columnas explícitamente para evitar que Lazarus las coloque "como quiera"
  if (Grid = nil) or (DS = nil) or (DS.DataSet = nil) or (not DS.DataSet.Active) then Exit;

  Grid.Columns.BeginUpdate;
  try
    Grid.Columns.Clear;

    // Orden recomendado (compacto y útil):
    AddCol('fecha', 'Fecha', 80);
    AddCol('hora', 'Hora', 70);
    AddCol('serie', 'Serie', 90);
    AddCol('numero', 'Nº', 60);
    AddCol('total_con_iva', 'Total', 80);
    AddCol('estado', 'Estado', 90);
    AddCol('PuestoVenta', 'Puesto', 55);
    AddCol('claimed_by', 'Enviado por', 150);

    // >>> Lo que pedías:
    AddCol('vf_resultado', 'Resultado', 95);
    AddCol('RectInfo', 'RectInfo', 220);   // ENTRE Resultado y Motivo
    AddCol('vf_motivo', 'Motivo', 260);
    AddCol('vf_respuesta', 'Respuesta', 320);

    AddCol('intentos', 'Intentos', 70);
    AddCol('last_attempt_at', 'Último intento', 135);
    AddCol('CodCliente', 'Cliente', 70);
    AddCol('NIF', 'NIF', 110);

    // Si quieres ver más campos, se pueden añadir aquí sin ensanchar demasiado el grid.


    // Hook: construir texto de la columna "Respuesta" desde respuesta_text
    if (DS <> nil) and (DS.DataSet <> nil) and (DS.DataSet.Active) then
    begin
      if DS.DataSet.FindField('vf_respuesta') <> nil then
        DS.DataSet.FieldByName('vf_respuesta').OnGetText := @VFRespuestaGetText;
    end;
  finally
    Grid.Columns.EndUpdate;
  end;
end;


procedure TfrmVFQMonitor.VFRespuestaGetText(Sender: TField; var aText: string; DisplayText: Boolean);
  function NormalizeSpaces(const S: string): string;
  var
    I: Integer;
    Ch: Char;
    R: string;
  begin
    R := S;
    // Quitar CR y convertir LF/tab a espacio para que quede en una sola línea
    R := StringReplace(R, #13, '', [rfReplaceAll]);
    for I := 1 to Length(R) do
    begin
      Ch := R[I];
      if (Ch = #10) or (Ch = #9) then
        R[I] := ' ';
    end;
    Result := Trim(R);
  end;

  function LastNonEmptyLine(const S: string): string;
  var
    tmp: string;
    i, p: Integer;
    line: string;
  begin
    Result := '';
    tmp := StringReplace(S, #13, '', [rfReplaceAll]);
    i := Length(tmp);
    while i > 0 do
    begin
      p := i;
      while (p > 0) and (tmp[p] <> #10) do Dec(p);
      line := Trim(Copy(tmp, p + 1, i - p));
      if line <> '' then Exit(line);
      i := p - 1;
    end;
  end;

  function ExtractTagValue(const S, Tag1, Tag2: string): string;
  var
    p1, p2, rel: Integer;
    tail: string;
  begin
    Result := '';
    p1 := Pos(Tag1, S);
    if p1 <= 0 then Exit;
    p1 := p1 + Length(Tag1);

    tail := Copy(S, p1, MaxInt);
    rel := Pos(Tag2, tail);
    if rel <= 0 then Exit;
    p2 := p1 + rel - 1;

    Result := Trim(Copy(S, p1, p2 - p1));
  end;

var
  LDS: TDataSet;
  RespRaw, RespNorm, Linea, Estado, EstadoReg, CSV, LastErr, Fault: string;
  UpResp, UpErr: string;
begin
  aText := '';
  if Sender = nil then Exit;

  LDS := Sender.DataSet;
  if (LDS = nil) or (not LDS.Active) then Exit;

  if LDS.FindField('last_error') <> nil then
    LastErr := LDS.FieldByName('last_error').AsString
  else
    LastErr := '';

  // necesitamos respuesta_text para construir la vista
  if LDS.FindField('respuesta_text') = nil then Exit;

  RespRaw := LDS.FieldByName('respuesta_text').AsString;
  RespNorm := NormalizeSpaces(RespRaw);
  UpResp := UpperCase(RespNorm);
  UpErr := UpperCase(LastErr);

  // 0) Errores técnicos sin respuesta HTTP / certificado / SSL
  if (Pos('KEY VALUES MISMATCH', UpErr) > 0) then
  begin
    aText := 'ERROR CERTIFICADO: certificado y clave privada no corresponden';
    Exit;
  end;
  if (Pos('PEM ROUTINES', UpErr) > 0) or (Pos('NO START LINE', UpErr) > 0) then
  begin
    aText := 'ERROR CERTIFICADO: PEM inválido o P12 tratado como PEM';
    Exit;
  end;
  if (Pos('HTTPMETHOD', UpErr) > 0) or (Pos('SOCKERR', UpErr) > 0) or (Pos('SSLERR', UpErr) > 0) then
  begin
    aText := LastErr;
    if Length(aText) > 255 then aText := Copy(aText, 1, 252) + '...';
    Exit;
  end;

  // 1) Respuesta inválida: WSDL recibido en vez de respuesta SOAP AEAT
  if (Pos('<WSDL:DEFINITIONS', UpResp) > 0) or (Pos('SISTEMAFACTURACION.WSDL', UpResp) > 0) then
  begin
    aText := 'RESPUESTA INVÁLIDA: se recibió WSDL, no respuesta SOAP AEAT';
    Exit;
  end;

  // 2) SOAP Fault
  if (Pos('<ENV:FAULT', UpResp) > 0) or (Pos('<SOAP:FAULT', UpResp) > 0) or (Pos('FAULTSTRING', UpResp) > 0) then
  begin
    Fault := ExtractTagValue(RespNorm, '<faultstring>', '</faultstring>');
    if Fault = '' then
      Fault := ExtractTagValue(RespNorm, '<env:faultstring>', '</env:faultstring>');
    if Fault <> '' then
      aText := 'ERROR SOAP: ' + Fault
    else
      aText := 'ERROR SOAP: ' + Copy(RespNorm, 1, 220);
    if Length(aText) > 255 then aText := Copy(aText, 1, 252) + '...';
    Exit;
  end;

  // 3) Si la última línea empieza por [AEAT -> mostrarla completa
  Linea := LastNonEmptyLine(RespRaw);
  if (Linea <> '') and (Pos('[AEAT', Linea) = 1) then
  begin
    aText := Linea;
    Exit;
  end;

  // 4) Respuesta AEAT: extraer EstadoEnvio, EstadoRegistro y CSV del XML
  Estado := ExtractTagValue(RespNorm, '<tikR:EstadoEnvio>', '</tikR:EstadoEnvio>');
  if Estado = '' then
    Estado := ExtractTagValue(RespNorm, '<EstadoEnvio>', '</EstadoEnvio>');

  EstadoReg := ExtractTagValue(RespNorm, '<tikR:EstadoRegistro>', '</tikR:EstadoRegistro>');
  if EstadoReg = '' then
    EstadoReg := ExtractTagValue(RespNorm, '<EstadoRegistro>', '</EstadoRegistro>');

  CSV := ExtractTagValue(RespNorm, '<tikR:CSV>', '</tikR:CSV>');
  if CSV = '' then
    CSV := ExtractTagValue(RespNorm, '<CSV>', '</CSV>');

  if (Estado <> '') or (EstadoReg <> '') or (CSV <> '') then
  begin
    aText := '';
    if Estado <> '' then aText := 'Envio: ' + Estado;
    if EstadoReg <> '' then
    begin
      if aText <> '' then aText := aText + ' | ';
      aText := aText + 'Registro: ' + EstadoReg;
    end;
    if CSV <> '' then
    begin
      if aText <> '' then aText := aText + ' | ';
      aText := aText + 'CSV: ' + CSV;
    end;
  end
  else
  begin
    // 3) Fallback: última línea útil (o recorte alrededor de "Correcto"/"Incorrecto" si aparece)
    if Linea <> '' then
      aText := Linea
    else
      aText := '';
  end;

  // Evitar textos demasiado largos en el grid
  if Length(aText) > 255 then
    aText := Copy(aText, 1, 252) + '...';
end;


procedure TfrmVFQMonitor.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfrmVFQMonitor.BtnRefreshClick(Sender: TObject);
begin
  FSortField := 'fecha';
  FSortDesc := True;

  RefreshData;
end;

function TfrmVFQMonitor.PromptReason(out ReasonText: string): Boolean;
var
  S: string;
begin
  S := '';
  Result := InputQuery('Reenviar a AEAT', 'Motivo subsanación (interno):', S);
  ReasonText := Trim(S);
  if Result and (ReasonText = '') then
  begin
    ShowMessage('Debes indicar un motivo (aunque sea breve).');
    Result := False;
  end;
end;

procedure TfrmVFQMonitor.BtnRetryClick(Sender: TObject);
var
  Serie: string;
  Numero: Integer;
  Estado: string;
  Reason: string;
  Ok: Boolean;
begin
  if (Q = nil) or (not Q.Active) or (Q.RecordCount = 0) then Exit;

  Serie := Q.FieldByName('serie').AsString;
  Numero := Q.FieldByName('numero').AsInteger;
  Estado := Q.FieldByName('estado').AsString;

  Reason := '';
  if SameText(Estado, 'ERROR') then
    if not PromptReason(Reason) then Exit;

  try
    VeriFactu_ResetToPending(Serie, Numero);
  except
    on E: Exception do
    begin
      ShowMessage('ResetToPending ERROR: ' + E.Message);
      Exit;
    end;
  end;

  Ok := VF_DispatchSpecific(Serie, Numero);
  if not Ok then
    ShowMessage('No se pudo enviar ahora mismo (revisa sender/estado).');

  FSortField := 'fecha';
  FSortDesc := True;

  RefreshData;
end;

procedure TfrmVFQMonitor.BtnDetailClick(Sender: TObject);
var
  Id: Int64;
  QD: TZQuery;
  Msg: string;
begin
  if (Q = nil) or (not Q.Active) or (Q.RecordCount = 0) then Exit;
  Id := Q.FieldByName('id').AsLargeInt;

  QD := TZQuery.Create(nil);
  try
    QD.Connection := FConn;
    QD.SQL.Text :=
      'SELECT estado, intentos, claimed_by, claimed_at, claimed_until, last_attempt_at, last_error, token, hash, hash_prev, respuesta_text '+
      'FROM verifactu_queue WHERE id=:ID';
    QD.ParamByName('ID').AsLargeInt := Id;
    QD.Open;

    Msg :=
      'ID: ' + IntToStr(Id) + LineEnding +
      'Estado: ' + QD.FieldByName('estado').AsString + LineEnding +
      'Enviado por: ' + QD.FieldByName('claimed_by').AsString + LineEnding +
      'Claimed at: ' + QD.FieldByName('claimed_at').AsString + LineEnding +
      'Claimed until: ' + QD.FieldByName('claimed_until').AsString + LineEnding +
      'Intentos: ' + QD.FieldByName('intentos').AsString + LineEnding +
      'Último intento: ' + QD.FieldByName('last_attempt_at').AsString + LineEnding +
      'Token: ' + QD.FieldByName('token').AsString + LineEnding +
      'HashPrev: ' + QD.FieldByName('hash_prev').AsString + LineEnding +
      'Hash: ' + QD.FieldByName('hash').AsString + LineEnding + LineEnding +
      'LastError: ' + QD.FieldByName('last_error').AsString + LineEnding + LineEnding +
      'Respuesta (primeros 2000 caracteres):' + LineEnding +
      Copy(QD.FieldByName('respuesta_text').AsString, 1, 2000);

    ShowMessage(Msg);
  except
    on E: Exception do
      ShowMessage('Detalle ERROR: ' + E.Message);
  end;
  QD.Free;
end;

procedure TfrmVFQMonitor.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmVFQMonitor.GridDblClick(Sender: TObject);
begin
  BtnDetailClick(Sender);
end;

procedure TfrmVFQMonitor.GridTitleClick(Column: TColumn);
var
  FN: string;
begin
  if Column = nil then Exit;
  FN := Column.FieldName;
  if FN = '' then Exit;

  // Si pulsas la misma columna, invierte ASC/DESC. Si es otra, empieza DESC (lo típico)
  if SameText(FSortField, FN) then
    FSortDesc := not FSortDesc
  else
  begin
    FSortField := FN;
    FSortDesc := True;
  end;

  RefreshData;
end;

procedure TfrmVFQMonitor.GridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Bk: TColor;
  Estado: string;
  CellText: string;
begin
  if gdSelected in State then
  begin
    // Selección estilo FacturLinEx: amarillo suave (no azul del sistema)
    Grid.Canvas.Brush.Color := RGBToColor(255, 245, 200);
    Grid.Canvas.Font.Color := clBlack;
  end
  else
  begin
    Estado := '';
    if (Q <> nil) and Q.Active then
      try
        if Q.FindField('vf_resultado') <> nil then
          Estado := Q.FieldByName('vf_resultado').AsString
        else
          Estado := Q.FieldByName('estado').AsString;
      except
        Estado := '';
      end;

    Bk := RowColorForEstado(Estado);
    Grid.Canvas.Brush.Color := Bk;
    Grid.Canvas.Font.Color := clBlack;
  end;

  Grid.Canvas.FillRect(Rect);
  if (Column = nil) or (Column.Field = nil) then
    CellText := ''
  else
    CellText := Column.Field.DisplayText;
  if Length(CellText) > 50 then CellText := Copy(CellText, 1, 50) + '…';
  Grid.Canvas.TextRect(Rect, Rect.Left + 4, Rect.Top + 2, CellText);
end;

end.
