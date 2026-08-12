unit uvfqueuemonitor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, StdCtrls, ExtCtrls, Buttons, EditBtn,
  DBGrids, DB, Graphics, Grids, LCLType, ComCtrls, Clipbrd, // RGBToColor + Canvas
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

    TopPanel, HeaderPanel, ActionPanel, GridHeaderPanel, SummaryPanel: TPanel;
    FilterGroup: TGroupBox;
    LbTitle, LbSubtitle, LbGridTitle, LbGridHint: TLabel;
    LbTotal, LbPending, LbSent, LbIncidents: TLabel;
    BtnRefresh, BtnRetry, BtnDetail, BtnClose: TBitBtn;
    CbEstado: TComboBox;
    EdSerie, EdNumero, EdCliente: TEdit;

    // Fechas con calendario desplegable integrado
    EdDesde, EdHasta: TDateEdit;
    LbTienda, LbEstado, LbSerie, LbNumero, LbCliente, LbDesde, LbHasta: TLabel;

    Grid: TDBGrid;
    DS: TDataSource;
    Q: TZQuery;

    procedure CreateUI;
    procedure AssignButtonGlyph(ABtn: TBitBtn; AKind: Integer);
    procedure PopulateEstado;
    procedure RefreshData;
    procedure SetupGridColumns;
    procedure UpdateSummary;
    procedure UpdateActionState;
    function CurrentResult: string;
    function IsTechnicalRetryAllowed(out AReason: string): Boolean;

    // Mostrar detalle resumido de respuesta AEAT (columna 'Respuesta')
    procedure VFRespuestaGetText(Sender: TField; var aText: string; DisplayText: Boolean);

    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnRetryClick(Sender: TObject);
    procedure BtnDetailClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);

    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure CbEstadoChange(Sender: TObject);

    procedure GridDblClick(Sender: TObject);
    procedure GridCellClick(Column: TColumn);
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

  Caption := 'Centro de Control VeriFactu';
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
  EdDesde.Date := Date - 30;
  EdHasta.Date := Date;

  FSortField := 'fecha';
  FSortDesc := True;

  RefreshData;
end;

procedure TfrmVFQMonitor.AssignButtonGlyph(ABtn: TBitBtn; AKind: Integer);
var
  B: TBitmap;
  C: TCanvas;
begin
  if ABtn = nil then Exit;

  B := TBitmap.Create;
  try
    B.PixelFormat := pf24bit;
    B.SetSize(20, 20);
    B.Transparent := True;
    B.TransparentColor := clFuchsia;

    C := B.Canvas;
    C.Brush.Color := clFuchsia;
    C.Brush.Style := bsSolid;
    C.FillRect(Rect(0, 0, 20, 20));
    C.Brush.Style := bsClear;
    C.Pen.Color := clNavy;
    C.Pen.Width := 2;

    case AKind of
      1: begin { refrescar }
           C.MoveTo(4, 8); C.LineTo(4, 4); C.LineTo(8, 4);
           C.MoveTo(4, 4); C.LineTo(7, 7);
           C.MoveTo(5, 11); C.LineTo(7, 14); C.LineTo(11, 16); C.LineTo(15, 14);
           C.MoveTo(16, 12); C.LineTo(16, 16); C.LineTo(12, 16);
           C.MoveTo(16, 16); C.LineTo(13, 13);
           C.MoveTo(15, 9); C.LineTo(13, 6); C.LineTo(9, 4);
         end;
      2: begin { reintentar / reenviar }
           C.MoveTo(3, 9); C.LineTo(3, 4); C.LineTo(8, 4);
           C.MoveTo(3, 4); C.LineTo(7, 8);
           C.MoveTo(5, 13); C.LineTo(8, 16); C.LineTo(13, 16); C.LineTo(17, 12);
           C.MoveTo(14, 5); C.LineTo(17, 8); C.LineTo(17, 12);
           C.MoveTo(17, 12); C.LineTo(13, 12);
         end;
      3: begin { detalle }
           C.Rectangle(3, 3, 12, 16);
           C.MoveTo(6, 7); C.LineTo(10, 7);
           C.MoveTo(6, 10); C.LineTo(10, 10);
           C.Ellipse(10, 10, 17, 17);
           C.MoveTo(16, 16); C.LineTo(19, 19);
         end;
      4: begin { cerrar }
           C.MoveTo(5, 5); C.LineTo(15, 15);
           C.MoveTo(15, 5); C.LineTo(5, 15);
         end;
    end;

    ABtn.Glyph.Assign(B);
    ABtn.NumGlyphs := 1;
    ABtn.Layout := blGlyphLeft;
    ABtn.Spacing := 6;
  finally
    B.Free;
  end;
end;

procedure TfrmVFQMonitor.CreateUI;
var
  HeaderRight: TPanel;
begin
  Color := clWhite;
  Font.Name := 'Sans';
  Font.Height := -13;

  TopPanel := TPanel.Create(Self);
  TopPanel.Parent := Self;
  TopPanel.Align := alTop;
  TopPanel.Height := 334;
  TopPanel.BevelOuter := bvNone;
  TopPanel.Color := clWhite;

  HeaderPanel := TPanel.Create(Self);
  HeaderPanel.Parent := TopPanel;
  HeaderPanel.Align := alTop;
  HeaderPanel.Height := 78;
  HeaderPanel.BevelOuter := bvNone;
  HeaderPanel.Color := clNavy;

  LbTitle := TLabel.Create(Self);
  LbTitle.Parent := HeaderPanel;
  LbTitle.Left := 18;
  LbTitle.Top := 11;
  LbTitle.Caption := 'CENTRO DE CONTROL VERIFACTU';
  LbTitle.ParentFont := False;
  LbTitle.Font.Name := 'Sans';
  LbTitle.Font.Height := -22;
  LbTitle.Font.Style := [fsBold];
  LbTitle.Font.Color := clWhite;

  LbSubtitle := TLabel.Create(Self);
  LbSubtitle.Parent := HeaderPanel;
  LbSubtitle.Left := 18;
  LbSubtitle.Top := 43;
  LbSubtitle.Caption := 'Supervisa envíos, diagnostica incidencias y separa reintentos técnicos de correcciones fiscales.';
  LbSubtitle.ParentFont := False;
  LbSubtitle.Font.Name := 'Sans';
  LbSubtitle.Font.Height := -12;
  LbSubtitle.Font.Color := clSilver;

  HeaderRight := TPanel.Create(Self);
  HeaderRight.Parent := HeaderPanel;
  HeaderRight.Align := alRight;
  HeaderRight.Width := 190;
  HeaderRight.BevelOuter := bvNone;
  HeaderRight.ParentColor := True;

  BtnClose := TBitBtn.Create(Self);
  BtnClose.Parent := HeaderRight;
  BtnClose.Caption := 'Cerrar';
  BtnClose.SetBounds(18, 20, 112, 34);
  BtnClose.OnClick := @BtnCloseClick;
  AssignButtonGlyph(BtnClose, 4);

  SummaryPanel := TPanel.Create(Self);
  SummaryPanel.Parent := TopPanel;
  SummaryPanel.SetBounds(14, 88, TopPanel.ClientWidth - 28, 48);
  SummaryPanel.Anchors := [akLeft, akTop, akRight];
  SummaryPanel.BevelOuter := bvNone;
  SummaryPanel.Color := RGBToColor(240, 244, 248);

  LbTotal := TLabel.Create(Self);
  LbTotal.Parent := SummaryPanel;
  LbTotal.SetBounds(16, 13, 205, 24);
  LbTotal.ParentFont := False;
  LbTotal.Font.Style := [fsBold];
  LbTotal.Caption := 'Registros: 0';

  LbPending := TLabel.Create(Self);
  LbPending.Parent := SummaryPanel;
  LbPending.SetBounds(230, 13, 205, 24);
  LbPending.ParentFont := False;
  LbPending.Font.Style := [fsBold];
  LbPending.Font.Color := RGBToColor(145, 95, 0);
  LbPending.Caption := 'Pendientes: 0';

  LbSent := TLabel.Create(Self);
  LbSent.Parent := SummaryPanel;
  LbSent.SetBounds(444, 13, 205, 24);
  LbSent.ParentFont := False;
  LbSent.Font.Style := [fsBold];
  LbSent.Font.Color := RGBToColor(20, 115, 55);
  LbSent.Caption := 'Enviados: 0';

  LbIncidents := TLabel.Create(Self);
  LbIncidents.Parent := SummaryPanel;
  LbIncidents.SetBounds(658, 13, 300, 24);
  LbIncidents.ParentFont := False;
  LbIncidents.Font.Style := [fsBold];
  LbIncidents.Font.Color := RGBToColor(170, 35, 35);
  LbIncidents.Caption := 'Incidencias: 0';

  FilterGroup := TGroupBox.Create(Self);
  FilterGroup.Parent := TopPanel;
  FilterGroup.SetBounds(14, 146, TopPanel.ClientWidth - 28, 104);
  FilterGroup.Anchors := [akLeft, akTop, akRight];
  FilterGroup.Caption := ' FILTROS DE CONSULTA ';
  FilterGroup.ParentFont := False;
  FilterGroup.Font.Name := 'Sans';
  FilterGroup.Font.Height := -13;
  FilterGroup.Font.Style := [fsBold];

  LbEstado := TLabel.Create(Self);
  LbEstado.Parent := FilterGroup;
  LbEstado.Caption := 'Estado';
  LbEstado.Left := 16;
  LbEstado.Top := 22;
  LbEstado.ParentFont := False;
  LbEstado.Font.Style := [];

  CbEstado := TComboBox.Create(Self);
  CbEstado.Parent := FilterGroup;
  CbEstado.SetBounds(16, 42, 170, 28);
  CbEstado.Style := csDropDownList;
  CbEstado.OnChange := @CbEstadoChange;

  LbSerie := TLabel.Create(Self);
  LbSerie.Parent := FilterGroup;
  LbSerie.Caption := 'Serie de cola';
  LbSerie.Left := 202;
  LbSerie.Top := 22;
  LbSerie.ParentFont := False;
  LbSerie.Font.Style := [];

  EdSerie := TEdit.Create(Self);
  EdSerie.Parent := FilterGroup;
  EdSerie.SetBounds(202, 42, 132, 28);

  LbNumero := TLabel.Create(Self);
  LbNumero.Parent := FilterGroup;
  LbNumero.Caption := 'Número';
  LbNumero.Left := 350;
  LbNumero.Top := 22;
  LbNumero.ParentFont := False;
  LbNumero.Font.Style := [];

  EdNumero := TEdit.Create(Self);
  EdNumero.Parent := FilterGroup;
  EdNumero.SetBounds(350, 42, 92, 28);

  LbCliente := TLabel.Create(Self);
  LbCliente.Parent := FilterGroup;
  LbCliente.Caption := 'Cliente';
  LbCliente.Left := 458;
  LbCliente.Top := 22;
  LbCliente.ParentFont := False;
  LbCliente.Font.Style := [];

  EdCliente := TEdit.Create(Self);
  EdCliente.Parent := FilterGroup;
  EdCliente.SetBounds(458, 42, 96, 28);

  LbDesde := TLabel.Create(Self);
  LbDesde.Parent := FilterGroup;
  LbDesde.Caption := 'Desde';
  LbDesde.Left := 570;
  LbDesde.Top := 22;
  LbDesde.ParentFont := False;
  LbDesde.Font.Style := [];

  EdDesde := TDateEdit.Create(Self);
  EdDesde.Parent := FilterGroup;
  EdDesde.SetBounds(570, 42, 142, 28);
  EdDesde.DateFormat := 'yyyy-mm-dd';
  EdDesde.DefaultToday := True;
  EdDesde.ButtonWidth := 28;
  EdDesde.ButtonHint := 'Seleccionar fecha desde el calendario';
  EdDesde.ShowHint := True;

  LbHasta := TLabel.Create(Self);
  LbHasta.Parent := FilterGroup;
  LbHasta.Caption := 'Hasta';
  LbHasta.Left := 728;
  LbHasta.Top := 22;
  LbHasta.ParentFont := False;
  LbHasta.Font.Style := [];

  EdHasta := TDateEdit.Create(Self);
  EdHasta.Parent := FilterGroup;
  EdHasta.SetBounds(728, 42, 142, 28);
  EdHasta.DateFormat := 'yyyy-mm-dd';
  EdHasta.DefaultToday := True;
  EdHasta.ButtonWidth := 28;
  EdHasta.ButtonHint := 'Seleccionar fecha hasta el calendario';
  EdHasta.ShowHint := True;

  LbTienda := TLabel.Create(Self);
  LbTienda.Parent := FilterGroup;
  LbTienda.Caption := 'Tienda activa: ' + FTienda;
  LbTienda.SetBounds(904, 43, 250, 24);
  LbTienda.ParentFont := False;
  LbTienda.Font.Name := 'Sans';
  LbTienda.Font.Height := -13;
  LbTienda.Font.Style := [fsBold];
  LbTienda.Font.Color := clNavy;

  ActionPanel := TPanel.Create(Self);
  ActionPanel.Parent := TopPanel;
  ActionPanel.SetBounds(14, 258, TopPanel.ClientWidth - 28, 40);
  ActionPanel.Anchors := [akLeft, akTop, akRight];
  ActionPanel.BevelOuter := bvNone;
  ActionPanel.Color := clWhite;

  BtnRefresh := TBitBtn.Create(Self);
  BtnRefresh.Parent := ActionPanel;
  BtnRefresh.Caption := 'Refrescar';
  BtnRefresh.SetBounds(0, 4, 120, 32);
  BtnRefresh.OnClick := @BtnRefreshClick;
  AssignButtonGlyph(BtnRefresh, 1);

  BtnRetry := TBitBtn.Create(Self);
  BtnRetry.Parent := ActionPanel;
  BtnRetry.Caption := 'Reintento técnico';
  BtnRetry.SetBounds(130, 4, 170, 32);
  BtnRetry.ParentFont := False;
  BtnRetry.Font.Style := [fsBold];
  BtnRetry.OnClick := @BtnRetryClick;
  AssignButtonGlyph(BtnRetry, 2);

  BtnDetail := TBitBtn.Create(Self);
  BtnDetail.Parent := ActionPanel;
  BtnDetail.Caption := 'Diagnóstico completo';
  BtnDetail.SetBounds(310, 4, 155, 32);
  BtnDetail.OnClick := @BtnDetailClick;
  AssignButtonGlyph(BtnDetail, 3);

  LbGridHint := TLabel.Create(Self);
  LbGridHint.Parent := ActionPanel;
  LbGridHint.Left := 490;
  LbGridHint.Top := 12;
  LbGridHint.Caption := 'Doble clic para abrir el detalle. Pulsa una cabecera para ordenar.';
  LbGridHint.ParentFont := False;
  LbGridHint.Font.Name := 'Sans';
  LbGridHint.Font.Height := -12;
  LbGridHint.Font.Color := clGray;

  GridHeaderPanel := TPanel.Create(Self);
  GridHeaderPanel.Parent := TopPanel;
  GridHeaderPanel.Align := alBottom;
  GridHeaderPanel.Height := 36;
  GridHeaderPanel.BevelOuter := bvNone;
  GridHeaderPanel.Color := RGBToColor(226, 230, 235);

  LbGridTitle := TLabel.Create(Self);
  LbGridTitle.Parent := GridHeaderPanel;
  LbGridTitle.Left := 10;
  LbGridTitle.Top := 10;
  LbGridTitle.Caption := 'REGISTROS DE LA COLA VERIFACTU';
  LbGridTitle.ParentFont := False;
  LbGridTitle.Font.Name := 'Sans';
  LbGridTitle.Font.Height := -13;
  LbGridTitle.Font.Style := [fsBold];
  LbGridTitle.Font.Color := RGBToColor(35, 45, 58);

  Grid := TDBGrid.Create(Self);
  Grid.Parent := Self;
  Grid.Align := alClient;
  Grid.Options := Grid.Options + [dgTitles, dgIndicator, dgRowSelect, dgAutoSizeColumns];
  Grid.Color := clWhite;
  Grid.FixedColor := RGBToColor(226, 230, 235);
  Grid.ParentFont := False;
  Grid.Font.Name := 'Sans';
  Grid.Font.Height := -12;
  Grid.TitleFont.Name := 'Sans';
  Grid.TitleFont.Height := -12;
  Grid.TitleFont.Style := [fsBold];
  Grid.OnDblClick := @GridDblClick;
  Grid.OnCellClick := @GridCellClick;
  Grid.OnTitleClick := @GridTitleClick;

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

  D1 := EdDesde.Date;
  if D1 <= 0 then
    if not ParseDateISO(EdDesde.Text, D1) then D1 := Date - 30;

  D2 := EdHasta.Date;
  if D2 <= 0 then
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
    '    WHEN q.estado = ''PENDIENTE'' AND q.intentos > 0 AND COALESCE(q.last_error,'''') <> '''' THEN ''PENDIENTE REINTENTO'' '+
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
    '    WHEN q.estado = ''PENDIENTE'' AND q.intentos > 0 AND COALESCE(q.last_error,'''') <> '''' THEN CONCAT(''Reintento automático pendiente. Último error: '', LEFT(COALESCE(q.last_error,''''), 220)) '+
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
    UpdateSummary;
    UpdateActionState;
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
begin
  ReasonText := '';
  Result := False;
  ShowMessage('La subsanación no se realiza mediante un reenvío ciego. Usa Diagnóstico completo para determinar la actuación correcta.');
end;

function TfrmVFQMonitor.CurrentResult: string;
begin
  Result := '';
  if (Q <> nil) and Q.Active and (not Q.IsEmpty) then
  begin
    if Q.FindField('vf_resultado') <> nil then
      Result := Q.FieldByName('vf_resultado').AsString
    else
      Result := Q.FieldByName('estado').AsString;
  end;
end;

function TfrmVFQMonitor.IsTechnicalRetryAllowed(out AReason: string): Boolean;
var
  Estado, Resultado, LastErr, Resp, U: string;
begin
  Result := False;
  AReason := '';
  if (Q = nil) or (not Q.Active) or Q.IsEmpty then
  begin
    AReason := 'No hay ningún registro seleccionado.';
    Exit;
  end;
  Estado := UpperCase(Trim(Q.FieldByName('estado').AsString));
  Resultado := UpperCase(Trim(CurrentResult));
  LastErr := UpperCase(Q.FieldByName('last_error').AsString);
  Resp := UpperCase(Q.FieldByName('respuesta_text').AsString);
  U := Resultado + ' ' + LastErr + ' ' + Resp;

  if (Estado = 'ENVIADO') or SameText(Resultado, 'CORRECTO') then
  begin
    AReason := 'El registro ya consta enviado/correcto y no debe reenviarse.';
    Exit;
  end;
  if Estado = 'EN_PROCESO' then
  begin
    AReason := 'El registro está siendo procesado. Refresca antes de actuar.';
    Exit;
  end;
  if (Pos('ESTADOREGISTRO>INCORRECTO', U) > 0) or
     (Pos('ACEPTADO CON ERRORES', U) > 0) or
     (Pos('INCORRECTO AEAT', U) > 0) then
  begin
    AReason := 'La AEAT ha respondido con una incidencia de contenido. No se permite el reenvío automático: revisa el diagnóstico y decide si procede corrección, anulación o rectificativa.';
    Exit;
  end;
  if (Pos('SOCKERR', U) > 0) or (Pos('SSLERR', U) > 0) or
     (Pos('HTTPMETHOD', U) > 0) or (Pos('SIN RESPUESTA HTTP', U) > 0) or
     (Pos('KEY VALUES MISMATCH', U) > 0) or (Pos('PEM ROUTINES', U) > 0) or
     (Pos('NO START LINE', U) > 0) or
     (Pos('ERROR SOAP', U) > 0) or
     (Pos('<ENV:FAULT', U) > 0) or (Pos('<SOAP:FAULT', U) > 0) or
     (Pos('FAULTSTRING', U) > 0) or
     (Pos('<WSDL:DEFINITIONS', U) > 0) or
     (Pos('SISTEMAFACTURACION.WSDL', U) > 0) or
     (Pos('CODIGO[404]', U) > 0) or (Pos('HTTP 404', U) > 0) or
     (Pos('NOT FOUND', U) > 0) or (Pos('ENDPOINT', U) > 0) or
     (Pos('SOAPAction', U) > 0) or (Pos('WEB SERVICE', U) > 0) or
     ((Estado = 'PENDIENTE') and (Q.FieldByName('intentos').AsInteger > 0)) then
  begin
    AReason := 'Incidencia técnica o de comunicación: el reintento controlado está permitido.';
    Result := True;
    Exit;
  end;
  if (Estado = 'PENDIENTE') and (Q.FieldByName('intentos').AsInteger = 0) then
  begin
    AReason := 'Pendiente de primer envío. Puedes forzar un intento inmediato.';
    Result := True;
    Exit;
  end;
  AReason := 'No se puede clasificar con seguridad como fallo técnico. Abre el diagnóstico antes de actuar.';
end;

procedure TfrmVFQMonitor.UpdateActionState;
var
  R: string;
begin
  if BtnRetry = nil then Exit;
  BtnRetry.Enabled := IsTechnicalRetryAllowed(R);
  BtnRetry.Hint := R;
  BtnRetry.ShowHint := True;
end;

procedure TfrmVFQMonitor.UpdateSummary;
var
  QS: TZQuery;
  Total, Pend, Sent, Incid: Integer;
begin
  Total := 0; Pend := 0; Sent := 0; Incid := 0;
  QS := TZQuery.Create(nil);
  try
    QS.Connection := FConn;
    QS.SQL.Text :=
      'SELECT COUNT(*) total, ' +
      'SUM(CASE WHEN estado IN (''PENDIENTE'',''EN_PROCESO'') THEN 1 ELSE 0 END) pendientes, ' +
      'SUM(CASE WHEN estado=''ENVIADO'' THEN 1 ELSE 0 END) enviados, ' +
      'SUM(CASE WHEN estado=''ERROR'' OR COALESCE(respuesta_text,'''') LIKE ''%EstadoRegistro>Incorrecto%'' ' +
      'OR COALESCE(respuesta_text,'''') LIKE ''%EstadoRegistro>AceptadoConErrores%'' THEN 1 ELSE 0 END) incidencias ' +
      'FROM verifactu_queue';
    QS.Open;
    Total := QS.FieldByName('total').AsInteger;
    Pend := QS.FieldByName('pendientes').AsInteger;
    Sent := QS.FieldByName('enviados').AsInteger;
    Incid := QS.FieldByName('incidencias').AsInteger;
  except
    // El resumen es informativo y no debe impedir abrir el centro de control.
  end;
  QS.Free;
  LbTotal.Caption := 'Registros: ' + IntToStr(Total);
  LbPending.Caption := 'Pendientes: ' + IntToStr(Pend);
  LbSent.Caption := 'Enviados: ' + IntToStr(Sent);
  LbIncidents.Caption := 'Incidencias: ' + IntToStr(Incid);
end;

procedure TfrmVFQMonitor.BtnRetryClick(Sender: TObject);
var
  Serie, Reason: string;
  Numero: Integer;
  Ok: Boolean;
begin
  if not IsTechnicalRetryAllowed(Reason) then
  begin
    ShowMessage(Reason);
    Exit;
  end;
  if MessageDlg('Reintento técnico', Reason + LineEnding + LineEnding +
    '¿Deseas devolver el registro a PENDIENTE y ejecutar ahora un intento controlado?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
  Serie := Q.FieldByName('serie').AsString;
  Numero := Q.FieldByName('numero').AsInteger;
  try
    VeriFactu_ResetToPending(Serie, Numero);
    Ok := VF_DispatchSpecific(Serie, Numero);
    if not Ok then
      ShowMessage('El registro queda disponible para la cola, pero no pudo enviarse ahora mismo. Revisa la conexión y refresca.');
  except
    on E: Exception do ShowMessage('Reintento técnico: ' + E.Message);
  end;
  FSortField := 'fecha';
  FSortDesc := True;
  RefreshData;
end;

procedure TfrmVFQMonitor.BtnDetailClick(Sender: TObject);
var
  Id: Int64;
  QD: TZQuery;
  Msg: string;
  DetailForm: TForm;
  DetailMemo: TMemo;
  BottomPanel: TPanel;
  BtnCloseDetail: TBitBtn;
begin
  if (Q = nil) or (not Q.Active) or (Q.RecordCount = 0) then Exit;
  Id := Q.FieldByName('id').AsLargeInt;

  QD := TZQuery.Create(nil);
  try
    QD.Connection := FConn;
    QD.SQL.Text :=
      'SELECT estado, intentos, claimed_by, claimed_at, claimed_until, last_attempt_at, last_error, token, hash, hash_prev, respuesta_text, payload_json, canonical, fecha_isoz '+
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
      'Fecha ISOZ: ' + QD.FieldByName('fecha_isoz').AsString + LineEnding +
      'Token: ' + QD.FieldByName('token').AsString + LineEnding +
      'HashPrev: ' + QD.FieldByName('hash_prev').AsString + LineEnding +
      'Hash: ' + QD.FieldByName('hash').AsString + LineEnding + LineEnding +
      'LastError:' + LineEnding + QD.FieldByName('last_error').AsString + LineEnding + LineEnding +
      'ACCIÓN ORIENTATIVA:' + LineEnding +
      'Los errores técnicos permiten reintento. Las respuestas Incorrecto/AceptadoConErrores requieren diagnóstico antes de reenviar.' + LineEnding + LineEnding +
      'CANONICAL:' + LineEnding +
      QD.FieldByName('canonical').AsString + LineEnding + LineEnding +
      'PAYLOAD JSON:' + LineEnding +
      QD.FieldByName('payload_json').AsString + LineEnding + LineEnding +
      'RESPUESTA AEAT:' + LineEnding +
      QD.FieldByName('respuesta_text').AsString;

    DetailForm := TForm.Create(Self);
    try
      DetailForm.Caption := 'Detalle completo VeriFactu - ID ' + IntToStr(Id);
      DetailForm.Position := poScreenCenter;
      DetailForm.Width := 980;
      DetailForm.Height := 720;
      DetailForm.Constraints.MinWidth := 700;
      DetailForm.Constraints.MinHeight := 480;
      DetailForm.BorderStyle := bsSizeable;
      DetailForm.KeyPreview := True;

      BottomPanel := TPanel.Create(DetailForm);
      BottomPanel.Parent := DetailForm;
      BottomPanel.Align := alBottom;
      BottomPanel.Height := 52;
      BottomPanel.BevelOuter := bvNone;
      BottomPanel.Caption := '';

      BtnCloseDetail := TBitBtn.Create(DetailForm);
      BtnCloseDetail.Parent := BottomPanel;
      BtnCloseDetail.Caption := 'Cerrar';
      BtnCloseDetail.ModalResult := mrClose;
      BtnCloseDetail.Cancel := True;
      BtnCloseDetail.SetBounds(BottomPanel.Width - 120, 10, 105, 32);
      BtnCloseDetail.Anchors := [akTop, akRight];

      DetailMemo := TMemo.Create(DetailForm);
      DetailMemo.Parent := DetailForm;
      DetailMemo.Align := alClient;
      DetailMemo.ReadOnly := True;
      DetailMemo.WordWrap := False;
      DetailMemo.ScrollBars := ssAutoBoth;
      DetailMemo.Font.Name := 'Monospace';
      DetailMemo.Font.Size := 10;
      DetailMemo.Lines.Text := Msg;
      DetailMemo.SelStart := 0;
      DetailMemo.TabStop := True;

      DetailForm.ActiveControl := DetailMemo;
      DetailForm.ShowModal;
    finally
      DetailForm.Free;
    end;
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

procedure TfrmVFQMonitor.GridCellClick(Column: TColumn);
begin
  UpdateActionState;
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
