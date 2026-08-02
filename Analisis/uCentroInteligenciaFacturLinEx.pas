unit uCentroInteligenciaFacturLinEx;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, LCLType, Dialogs, ExtCtrls, StdCtrls, Buttons,
  Grids, Graphics, DateUtils, Math, DB, ZConnection, ZDataset,
  uFLXCompraAnalyzer, uAsesorComprasFacturLinEx, uFLXIntelligenceEngine,
  uFLXGridStyle, uFLXExport, uFLXDialogs, uFLXLogger, uFLXIcons;

procedure MostrarCentroInteligenciaFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);

implementation

type
  TCentroInteligenciaForm = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;
    FSortCol: Integer;
    FSortDesc: Boolean;
    Grid: TStringGrid;
    Memo: TMemo;
    LblTitulo: TLabel;
    LblResumen1: TLabel;
    LblResumen2: TLabel;
    LblResumen3: TLabel;
    LblResumen4: TLabel;
    BtnRevisar: TBitBtn;
    BtnAbrir: TBitBtn;
    BtnCSV: TBitBtn;
    BtnInforme: TBitBtn;
    BtnCerrar: TBitBtn;
    HeaderPanel: TPanel;
    ActionPanel: TPanel;
    ContentPanel: TPanel;
    TitlePanel: TPanel;
    KPIPanel: TPanel;
    InfoPanel: TPanel;
    LblSubtitulo: TLabel;
    LblVistaActual: TLabel;
    LblSubtituloVista: TLabel;
    LblKPI5: TLabel;
    FInicioRevision: TDateTime;
    procedure CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
    procedure CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer = 118);
    procedure CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
    procedure ResetGrid;
    procedure AddRow(const Modulo, Estado, Resumen, Accion: string; Prioridad: Integer);
    procedure AjustarColumnas;
    procedure RevisarTodoClick(Sender: TObject);
    procedure AbrirSeleccionClick(Sender: TObject);
    procedure CSVClick(Sender: TObject);
    procedure InformeClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CerrarClick(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure GridHeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer);
    procedure GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
    function DBName: string;
    function SQLIdent(const S: string): string;
    function TableName(const Prefix: string): string;
    function TableExists(const ATable: string): Boolean;
    function ScalarInt(const ASQL: string; const ADefault: Integer = 0): Integer;
    function ScalarFloat(const ASQL: string; const ADefault: Double = 0): Double;
    procedure RevisarDoctor;
    procedure RevisarAlertas;
    procedure RevisarCompras;
    procedure RevisarRentabilidad;
    procedure RevisarVerifactu;
    procedure RefrescarResumen;
    procedure GenerarInformeEjecutivo;
  public
    constructor CreateForm(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
  end;

function IfThenStr(ACond: Boolean; const ATrue, AFalse: string): string;
begin
  if ACond then Result := ATrue else Result := AFalse;
end;

function IfThenInt(ACond: Boolean; ATrue, AFalse: Integer): Integer;
begin
  if ACond then Result := ATrue else Result := AFalse;
end;

procedure TCentroInteligenciaForm.CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
begin
  FLXSetBitBtnIcon(ABtn, AIcon, ASize);
end;

procedure TCentroInteligenciaForm.CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer);
begin
  ABtn := TBitBtn.Create(Self);
  ABtn.Parent := AParent;
  ABtn.Left := ALeft;
  ABtn.Top := 8;
  ABtn.Width := AWidth;
  ABtn.Height := 58;
  ABtn.Caption := ACaption;
  ABtn.Layout := blGlyphTop;
  ABtn.Font.Style := [fsBold];
  CargarIconoBoton(ABtn, AIcon, 30);
end;

procedure TCentroInteligenciaForm.CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
var
  P: TPanel;
  Img: TImage;
  L: TLabel;
  FN: string;
  Pic: TPicture;
begin
  P := TPanel.Create(Self);
  P.Parent := AParent;
  P.Left := ALeft;
  P.Top := 12;
  P.Width := 230;
  P.Height := 82;
  P.BevelOuter := bvLowered;
  P.Color := RGBToColor(250,252,255);

  Img := TImage.Create(Self);
  Img.Parent := P;
  Img.Left := 12;
  Img.Top := 16;
  Img.Width := 42;
  Img.Height := 42;
  Img.Stretch := True;
  FN := FLXIconFile(AIcon, 48);
  if FN <> '' then
  begin
    Pic := TPicture.Create;
    try
      Pic.LoadFromFile(FN);
      Img.Picture.Assign(Pic);
    finally
      Pic.Free;
    end;
  end;

  L := TLabel.Create(Self);
  L.Parent := P;
  L.Left := 68;
  L.Top := 12;
  L.Caption := ATitle;
  L.Font.Color := RGBToColor(10,45,95);
  L.Font.Style := [fsBold];

  AValueLabel := TLabel.Create(Self);
  AValueLabel.Parent := P;
  AValueLabel.Left := 68;
  AValueLabel.Top := 38;
  AValueLabel.Caption := '-';
  AValueLabel.Font.Size := 14;
  AValueLabel.Font.Style := [fsBold];
  AValueLabel.Font.Color := RGBToColor(0,32,80);
end;

constructor TCentroInteligenciaForm.CreateForm(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  Logo: TImage;
  Pic: TPicture;
  FN: string;
  L: TLabel;
begin
  inherited CreateNew(AOwner, 1);
  KeyPreview := True;
  OnKeyDown := @FormKeyDown;
  FConn := AConnection;
  FTienda := ATienda;
  FSortCol := -1;
  FSortDesc := False;

  Caption := 'FacturLinEx - Centro de Inteligencia';
  Width := 1300;
  Height := 820;
  Position := poScreenCenter;
  WindowState := wsMaximized;
  Color := RGBToColor(245,248,252);

  HeaderPanel := TPanel.Create(Self);
  HeaderPanel.Parent := Self;
  HeaderPanel.Align := alTop;
  HeaderPanel.Height := 118;
  HeaderPanel.BevelOuter := bvNone;
  HeaderPanel.Color := RGBToColor(248,251,255);

  Logo := TImage.Create(Self);
  Logo.Parent := HeaderPanel;
  Logo.Left := 24;
  Logo.Top := 18;
  Logo.Width := 68;
  Logo.Height := 68;
  Logo.Stretch := True;
  FN := FLXIconFile('centro_inteligencia', 64);
  if FN <> '' then
  begin
    Pic := TPicture.Create;
    try
      Pic.LoadFromFile(FN);
      Logo.Picture.Assign(Pic);
    finally
      Pic.Free;
    end;
  end;

  LblTitulo := TLabel.Create(Self);
  LblTitulo.Parent := HeaderPanel;
  LblTitulo.Left := 112;
  LblTitulo.Top := 24;
  LblTitulo.Caption := 'Centro de Inteligencia';
  LblTitulo.Font.Size := 24;
  LblTitulo.Font.Style := [fsBold];
  LblTitulo.Font.Color := RGBToColor(0,32,80);

  LblSubtitulo := TLabel.Create(Self);
  LblSubtitulo.Parent := HeaderPanel;
  LblSubtitulo.Left := 114;
  LblSubtitulo.Top := 68;
  LblSubtitulo.Caption := 'Resumen ejecutivo de los módulos principales de Inteligencia';
  LblSubtitulo.Font.Size := 11;
  LblSubtitulo.Font.Color := RGBToColor(45,70,105);

  ActionPanel := TPanel.Create(Self);
  ActionPanel.Parent := HeaderPanel;
  ActionPanel.Align := alRight;
  ActionPanel.Width := 760;
  ActionPanel.BevelOuter := bvNone;
  ActionPanel.Color := HeaderPanel.Color;

  CrearBotonAccion(ActionPanel, BtnRevisar, 'Revisar', 'tend_actualizar', 8, 118);
  BtnRevisar.OnClick := @RevisarTodoClick;
  CrearBotonAccion(ActionPanel, BtnAbrir, 'Abrir módulo', 'centro_inteligencia', 134, 128);
  BtnAbrir.OnClick := @AbrirSeleccionClick;
  CrearBotonAccion(ActionPanel, BtnCSV, 'Exportar', 'tend_exportar', 270, 118);
  BtnCSV.OnClick := @CSVClick;
  CrearBotonAccion(ActionPanel, BtnInforme, 'Informe', 'tend_imprimir', 396, 118);
  BtnInforme.OnClick := @InformeClick;
  CrearBotonAccion(ActionPanel, BtnCerrar, 'Cerrar', 'tend_cerrar', 624, 118);
  BtnCerrar.OnClick := @CerrarClick;

  InfoPanel := TPanel.Create(Self);
  InfoPanel.Parent := Self;
  InfoPanel.Align := alLeft;
  InfoPanel.Width := 245;
  InfoPanel.BevelOuter := bvLowered;
  InfoPanel.Color := RGBToColor(248,251,255);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 20;
  L.Caption := 'Funcionamiento';
  L.Font.Size := 12;
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,65,145);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 60;
  L.Width := 205;
  L.Height := 240;
  L.WordWrap := True;
  L.Caption := 'Pulse Revisar para generar un resumen ejecutivo mediante el motor común de Inteligencia.' + LineEnding + LineEnding +
               'Seleccione una fila y pulse Abrir módulo, o haga doble clic sobre la línea.' + LineEnding + LineEnding +
               'Solo lectura: no modifica datos.';
  L.Font.Color := RGBToColor(45,70,105);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 330;
  L.Width := 205;
  L.Height := 170;
  L.WordWrap := True;
  L.Caption := 'Prioridad ALTA: revisar primero. MEDIA/AVISO: revisar cuando sea posible. OK: sin acción urgente.';
  L.Font.Color := RGBToColor(45,70,105);

  ContentPanel := TPanel.Create(Self);
  ContentPanel.Parent := Self;
  ContentPanel.Align := alClient;
  ContentPanel.BevelOuter := bvNone;
  ContentPanel.Color := RGBToColor(245,248,252);

  TitlePanel := TPanel.Create(Self);
  TitlePanel.Parent := ContentPanel;
  TitlePanel.Align := alTop;
  TitlePanel.Height := 62;
  TitlePanel.BevelOuter := bvLowered;
  TitlePanel.Color := RGBToColor(250,252,255);

  LblVistaActual := TLabel.Create(Self);
  LblVistaActual.Parent := TitlePanel;
  LblVistaActual.Left := 16;
  LblVistaActual.Top := 14;
  LblVistaActual.Caption := 'Vista actual: RESUMEN EJECUTIVO';
  LblVistaActual.Font.Size := 12;
  LblVistaActual.Font.Style := [fsBold];
  LblVistaActual.Font.Color := RGBToColor(0,65,145);

  LblSubtituloVista := TLabel.Create(Self);
  LblSubtituloVista.Parent := TitlePanel;
  LblSubtituloVista.Left := 16;
  LblSubtituloVista.Top := 38;
  LblSubtituloVista.Caption := 'Revisión agrupada de Doctor, Alertas, Compras, Rentabilidad, VeriFactu y el resto de señales disponibles.';
  LblSubtituloVista.Font.Color := RGBToColor(45,70,105);

  KPIPanel := TPanel.Create(Self);
  KPIPanel.Parent := ContentPanel;
  KPIPanel.Align := alBottom;
  KPIPanel.Height := 108;
  KPIPanel.BevelOuter := bvLowered;
  KPIPanel.Color := RGBToColor(250,252,255);

  CrearKPI(KPIPanel, 'Revisados', 'tend_resumen', 12, LblResumen1);
  CrearKPI(KPIPanel, 'Prioritarios', 'alertas', 252, LblResumen2);
  CrearKPI(KPIPanel, 'Revisar', 'doctor', 492, LblResumen3);
  CrearKPI(KPIPanel, 'OK', 'rentabilidad', 732, LblResumen4);
  CrearKPI(KPIPanel, 'Tiempo', 'tend_configuracion', 972, LblKPI5);

  Grid := TStringGrid.Create(Self);
  Grid.Parent := ContentPanel;
  Grid.Align := alClient;
  Grid.FixedRows := 1;
  Grid.Options := Grid.Options + [goRowSelect, goColSizing];
  Grid.OnHeaderClick := @GridHeaderClick;
  Grid.OnDblClick := @GridDblClick;
  Grid.OnPrepareCanvas := @GridPrepareCanvas;
  FLXGridPreparar(Grid);
  Grid.Color := clWhite;
  Grid.FixedColor := RGBToColor(225,238,252);
  Grid.AlternateColor := RGBToColor(248,251,255);
  Grid.Font.Color := clBlack;
  Grid.TitleFont.Color := RGBToColor(0,32,80);
  Grid.TitleFont.Style := [fsBold];

  Memo := TMemo.Create(Self);
  Memo.Parent := Self;
  Memo.Align := alBottom;
  Memo.Height := 96;
  Memo.ScrollBars := ssVertical;
  Memo.Color := RGBToColor(250,252,255);
  Memo.Lines.Text := 'Centro de Inteligencia FacturLinEx. Pulse Revisar para generar el resumen.' + LineEnding +
                     'Esta pantalla no modifica datos. Es solo lectura.';

  ResetGrid;
end;

procedure TCentroInteligenciaForm.ResetGrid;
begin
  Grid.ColCount := 5;
  Grid.RowCount := 1;
  Grid.Cells[0,0] := 'Prioridad';
  Grid.Cells[1,0] := 'Módulo';
  Grid.Cells[2,0] := 'Estado';
  Grid.Cells[3,0] := 'Resumen';
  Grid.Cells[4,0] := 'Acción recomendada';
  AjustarColumnas;
  if Assigned(LblResumen1) then LblResumen1.Caption := '0';
  if Assigned(LblResumen2) then LblResumen2.Caption := '0';
  if Assigned(LblResumen3) then LblResumen3.Caption := '0';
  if Assigned(LblResumen4) then LblResumen4.Caption := '0';
  if Assigned(LblKPI5) then LblKPI5.Caption := '-';
end;

procedure TCentroInteligenciaForm.AddRow(const Modulo, Estado, Resumen, Accion: string; Prioridad: Integer);
var R: Integer;
begin
  R := Grid.RowCount;
  Grid.RowCount := R + 1;
  case Prioridad of
    1: Grid.Cells[0,R] := 'ALTA';
    2: Grid.Cells[0,R] := 'MEDIA';
    3: Grid.Cells[0,R] := 'AVISO';
    4: Grid.Cells[0,R] := 'BAJA';
  else
    Grid.Cells[0,R] := 'OK';
  end;
  Grid.Cells[1,R] := Modulo;
  Grid.Cells[2,R] := Estado;
  Grid.Cells[3,R] := Resumen;
  Grid.Cells[4,R] := Accion;
end;

procedure TCentroInteligenciaForm.AjustarColumnas;
var
  Disponible: Integer;
begin
  if Grid.ColCount < 5 then Exit;
  Grid.ColWidths[0] := 90;
  Grid.ColWidths[1] := 170;
  Grid.ColWidths[2] := 130;
  Grid.ColWidths[4] := 330;
  Disponible := Grid.ClientWidth - (Grid.ColWidths[0] + Grid.ColWidths[1] + Grid.ColWidths[2] + Grid.ColWidths[4] + 48);
  if Disponible < 360 then Disponible := 360;
  Grid.ColWidths[3] := Disponible;
end;

function TCentroInteligenciaForm.DBName: string;
begin
  Result := '';
  if Assigned(FConn) then Result := FConn.Database;
end;

function TCentroInteligenciaForm.SQLIdent(const S: string): string;
begin
  Result := '`' + StringReplace(S, '`', '``', [rfReplaceAll]) + '`';
end;

function TCentroInteligenciaForm.TableName(const Prefix: string): string;
begin
  Result := Prefix + FTienda;
end;

function TCentroInteligenciaForm.TableExists(const ATable: string): Boolean;
var Q: TZQuery;
begin
  Result := False;
  if (FConn = nil) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = :db AND TABLE_NAME = :t';
    Q.ParamByName('db').AsString := DBName;
    Q.ParamByName('t').AsString := ATable;
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TCentroInteligenciaForm.ScalarInt(const ASQL: string; const ADefault: Integer): Integer;
var Q: TZQuery;
begin
  Result := ADefault;
  if (FConn = nil) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := ASQL;
    Q.Open;
    if not Q.EOF then Result := Q.Fields[0].AsInteger;
  except
    Result := ADefault;
  end;
  Q.Free;
end;

function TCentroInteligenciaForm.ScalarFloat(const ASQL: string; const ADefault: Double): Double;
var Q: TZQuery;
begin
  Result := ADefault;
  if (FConn = nil) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := ASQL;
    Q.Open;
    if not Q.EOF then Result := Q.Fields[0].AsFloat;
  except
    Result := ADefault;
  end;
  Q.Free;
end;

procedure TCentroInteligenciaForm.RevisarDoctor;
var
  Art: string;
  SinProv, SinFam, PvpCero, Total: Integer;
begin
  Art := TableName('artitien');
  if not TableExists(Art) then
  begin
    AddRow('Doctor', 'ERROR', 'No se encuentra la tabla ' + Art, 'Revisar estructura de BBDD', 1);
    Exit;
  end;

  Total := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(Art));
  SinProv := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(Art) + ' WHERE COALESCE(A32, '''') = ''''');
  SinFam := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(Art) + ' WHERE COALESCE(A4, '''') = ''''');
  PvpCero := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(Art) + ' WHERE COALESCE(A10,0) <= 0');

  AddRow('Doctor', IfThenStr((SinProv + SinFam + PvpCero) = 0, 'OK', 'REVISAR'),
    Format('%d artículos. Sin proveedor: %d. Sin familia: %d. PVP <= 0: %d.', [Total, SinProv, SinFam, PvpCero]),
    IfThenStr((SinProv + SinFam + PvpCero) = 0, 'Sin acción urgente', 'Abrir Doctor y revisar calidad de datos'),
    IfThenInt((SinProv + SinFam + PvpCero) = 0, 5, 2));
end;

procedure TCentroInteligenciaForm.RevisarAlertas;
var
  Promo, VF: string;
  PromosCad, VFPend: Integer;
begin
  PromosCad := 0;
  Promo := TableName('promo');
  if TableExists(Promo) then
    PromosCad := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(Promo) + ' WHERE CURDATE() > COALESCE(fecha_fin, CURDATE())');

  VFPend := 0;
  VF := 'verifactu_queue';
  if TableExists(VF) then
    VFPend := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(VF) + ' WHERE estado IN (''PENDIENTE'', ''EN_PROCESO'', ''ERROR_TECNICO'')');

  AddRow('Alertas', IfThenStr((PromosCad + VFPend) = 0, 'OK', 'ATENCIÓN'),
    Format('Promociones caducadas: %d. VeriFactu pendiente/técnico: %d.', [PromosCad, VFPend]),
    IfThenStr((PromosCad + VFPend) = 0, 'Sin alertas principales', 'Abrir Alertas y priorizar incidencias'),
    IfThenInt((PromosCad + VFPend) = 0, 5, 1));
end;

procedure TCentroInteligenciaForm.RevisarCompras;
var
  Analyzer: TFLXCompraAnalyzer;
  L: TList;
  S: TStringList;
  I, Cambios, Revisar: Integer;
  Ahorro: Double;
  R: TFLXCompraRecomendacion;
begin
  if not TableExists(TableName('hipedidd')) then
  begin
    AddRow('Asesor Compras', 'SIN DATOS', 'No se encuentra histórico de compras ' + TableName('hipedidd'), 'Revisar módulo de compras', 3);
    Exit;
  end;

  Analyzer := TFLXCompraAnalyzer.Create(FConn, FTienda);
  L := TList.Create;
  S := TStringList.Create;
  try
    Analyzer.MaxFilasSQL := 1800;
    Analyzer.Analizar('', '', '', '', True, L, S);
    Cambios := 0;
    Revisar := 0;
    Ahorro := 0;
    for I := 0 to L.Count - 1 do
    begin
      R := TFLXCompraRecomendacion(L[I]);
      if Pos('CAMBIO', UpperCase(R.Diagnostico)) > 0 then Inc(Cambios)
      else if Pos('REVIS', UpperCase(R.Diagnostico)) > 0 then Inc(Revisar);
      if R.AhorroAnual > 0 then Ahorro := Ahorro + R.AhorroAnual;
    end;
    AddRow('Asesor Compras', IfThenStr(Cambios > 0, 'OPORTUNIDAD', 'OK'),
      Format('Analizados %d artículos comparables. Cambios claros: %d. Revisar: %d. Ahorro anual estimado: %.2f €.', [L.Count, Cambios, Revisar, Ahorro]),
      IfThenStr(Cambios > 0, 'Abrir Asesor y revisar prioridad ALTA', 'Mantener seguimiento'),
      IfThenInt(Cambios > 0, 1, 4));
  finally
    for I := 0 to L.Count - 1 do TObject(L[I]).Free;
    L.Free;
    S.Free;
    Analyzer.Free;
  end;
end;

procedure TCentroInteligenciaForm.RevisarRentabilidad;
var
  Art: string;
  SinCoste, MargenNeg: Integer;
begin
  Art := TableName('artitien');
  if not TableExists(Art) then Exit;
  SinCoste := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(Art) + ' WHERE COALESCE(A11,0) <= 0');
  MargenNeg := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(Art) + ' WHERE COALESCE(A10,0) > 0 AND COALESCE(A11,0) > COALESCE(A10,0)');
  AddRow('Rentabilidad', IfThenStr(MargenNeg > 0, 'REVISAR', 'OK'),
    Format('Artículos sin coste: %d. Posible margen negativo: %d.', [SinCoste, MargenNeg]),
    IfThenStr(MargenNeg > 0, 'Abrir Rentabilidad y revisar pérdidas', 'Revisión periódica'),
    IfThenInt(MargenNeg > 0, 2, 4));
end;

procedure TCentroInteligenciaForm.RevisarVerifactu;
var VF: string; Pend, Err, Env: Integer;
begin
  VF := 'verifactu_queue';
  if not TableExists(VF) then
  begin
    AddRow('VeriFactu', 'SIN TABLA', 'No existe verifactu_queue.', 'Revisar configuración VeriFactu', 3);
    Exit;
  end;
  Pend := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(VF) + ' WHERE estado IN (''PENDIENTE'', ''EN_PROCESO'')');
  Err := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(VF) + ' WHERE estado LIKE ''ERROR%''');
  Env := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(VF) + ' WHERE estado IN (''ENVIADO'', ''ACEPTADO'', ''AceptadoConErrores'')');
  AddRow('VeriFactu', IfThenStr((Pend + Err) = 0, 'OK', 'ATENCIÓN'),
    Format('Enviados/aceptados: %d. Pendientes: %d. Errores: %d.', [Env, Pend, Err]),
    IfThenStr((Pend + Err) = 0, 'Sin acción urgente', 'Abrir monitor VeriFactu'),
    IfThenInt((Pend + Err) = 0, 5, 1));
end;

procedure TCentroInteligenciaForm.RefrescarResumen;
var
  I, Urg, Rev, Ok: Integer;
  Estado: string;
  Segundos: Double;
begin
  Urg := 0; Rev := 0; Ok := 0;
  for I := 1 to Grid.RowCount - 1 do
  begin
    Estado := UpperCase(Grid.Cells[2,I]);
    if (Pos('ERROR', Estado) > 0) or (Pos('ATEN', Estado) > 0) or (Pos('OPORTUNIDAD', Estado) > 0) then Inc(Urg)
    else if Pos('REVIS', Estado) > 0 then Inc(Rev)
    else Inc(Ok);
  end;
  Segundos := SecondSpan(Now, FInicioRevision);
  LblResumen1.Caption := IntToStr(Max(0, Grid.RowCount - 1));
  LblResumen2.Caption := IntToStr(Urg);
  LblResumen3.Caption := IntToStr(Rev);
  LblResumen4.Caption := IntToStr(Ok);
  if Assigned(LblKPI5) then LblKPI5.Caption := Format('%.2f s', [Segundos]);
end;


procedure TCentroInteligenciaForm.GenerarInformeEjecutivo;
var
  I: Integer;
  Estado, Modulo, Resumen, Accion: string;
  Criticos, Revisar, Ok: Integer;
begin
  Criticos := 0;
  Revisar := 0;
  Ok := 0;

  Memo.Lines.Add('');
  Memo.Lines.Add('================ INFORME EJECUTIVO ================');
  Memo.Lines.Add('Centro de Inteligencia FacturLinEx');
  Memo.Lines.Add('Generado: ' + DateTimeToStr(Now));
  Memo.Lines.Add('');

  for I := 1 to Grid.RowCount - 1 do
  begin
    Modulo := Grid.Cells[1,I];
    Estado := UpperCase(Grid.Cells[2,I]);
    Resumen := Grid.Cells[3,I];
    Accion := Grid.Cells[4,I];

    if (Pos('ERROR', Estado) > 0) or (Pos('ATEN', Estado) > 0) or
       (Pos('OPORTUNIDAD', Estado) > 0) then
    begin
      Inc(Criticos);
      Memo.Lines.Add('[!] ' + Modulo + ': ' + Resumen);
      if Accion <> '' then Memo.Lines.Add('    Acción: ' + Accion);
    end
    else if Pos('REVIS', Estado) > 0 then
    begin
      Inc(Revisar);
      Memo.Lines.Add('[~] ' + Modulo + ': ' + Resumen);
      if Accion <> '' then Memo.Lines.Add('    Acción: ' + Accion);
    end
    else
      Inc(Ok);
  end;

  Memo.Lines.Add('');
  if Criticos > 0 then
    Memo.Lines.Add('Conclusión: hay ' + IntToStr(Criticos) + ' punto(s) prioritario(s) que conviene revisar primero.')
  else if Revisar > 0 then
    Memo.Lines.Add('Conclusión: no hay incidencias críticas, pero hay ' + IntToStr(Revisar) + ' punto(s) revisables.')
  else
    Memo.Lines.Add('Conclusión: todo correcto en las revisiones principales.');

  Memo.Lines.Add('OK: ' + IntToStr(Ok) + '  Revisar: ' + IntToStr(Revisar) + '  Prioritarios: ' + IntToStr(Criticos));
  Memo.Lines.Add('====================================================');
end;

procedure TCentroInteligenciaForm.RevisarTodoClick(Sender: TObject);
var
  Engine: TFLXIntelligenceEngine;
  I, Pri: Integer;
  Item: TFLXIntelItem;
  Estado: string;
begin
  Screen.Cursor := crHourGlass;
  BtnRevisar.Enabled := False;
  FInicioRevision := Now;
  try
    ResetGrid;
    Memo.Clear;
    Memo.Lines.Add('Revisión completa iniciada: ' + DateTimeToStr(FInicioRevision));
    Memo.Lines.Add('Motor común: uFLXIntelligenceEngine');
    Application.ProcessMessages;

    Engine := TFLXIntelligenceEngine.Create(FConn, FTienda);
    try
      Engine.RevisarTodo;
      for I := 0 to Engine.Results.Count - 1 do
      begin
        Item := Engine.Results[I];
        case Item.Prioridad of
          ipAlta:
            begin
              Pri := 1;
              Estado := 'ATENCIÓN';
            end;
          ipMedia:
            begin
              Pri := 2;
              Estado := 'REVISAR';
            end;
          ipAviso:
            begin
              Pri := 3;
              Estado := 'AVISO';
            end;
          ipBaja:
            begin
              Pri := 4;
              Estado := 'BAJA';
            end;
        else
          begin
            Pri := 5;
            Estado := 'OK';
          end;
        end;
        AddRow(Item.Origen, Estado, Item.Resumen, Item.Accion, Pri);
      end;
    finally
      Engine.Free;
    end;

    RefrescarResumen;
    Memo.Lines.Add('Revisión finalizada: ' + DateTimeToStr(Now));
    Memo.Lines.Add('Resumen: esta revisión ya se alimenta desde el motor común. Las ventanas específicas siguen disponibles para análisis detallado.');
    GenerarInformeEjecutivo;
    AjustarColumnas;
  finally
    BtnRevisar.Enabled := True;
    Screen.Cursor := crDefault;
  end;
end;


procedure TCentroInteligenciaForm.AbrirSeleccionClick(Sender: TObject);
var
  Modulo: string;
begin
  if (Grid.Row < 1) or (Grid.Row >= Grid.RowCount) then
  begin
    FLXWarning('Seleccione una fila del Centro de Inteligencia.', 'Centro de Inteligencia');
    Exit;
  end;

  Modulo := UpperCase(Grid.Cells[1, Grid.Row]);

  if Pos('ASESOR', Modulo) > 0 then
    MostrarAsesorComprasFacturLinEx(Self, FConn, FTienda)
  else
    FLXWarning('Para este módulo use de momento su botón específico en la pestaña Inteligencia.' + LineEnding +
                'En próximas versiones iremos conectando todos los módulos desde este Centro.', 'Centro de Inteligencia');
end;

procedure TCentroInteligenciaForm.GridDblClick(Sender: TObject);
begin
  AbrirSeleccionClick(Sender);
end;


procedure TCentroInteligenciaForm.GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
var
  Estado, Pri: string;
begin
  FLXGridPrepararCanvasSeleccion(Grid, aRow, aState);

  if aRow = 0 then
  begin
    Grid.Canvas.Font.Style := [fsBold];
    Exit;
  end;

  Grid.Canvas.Font.Color := clBlack;
  if gdSelected in aState then Exit;

  Estado := UpperCase(Grid.Cells[2, aRow]);
  Pri := UpperCase(Grid.Cells[0, aRow]);

  if (Pos('ERROR', Estado) > 0) or (Pos('ATEN', Estado) > 0) or (Pri = 'ALTA') then
    Grid.Canvas.Brush.Color := $00D6D6FF
  else if (Pos('OPORTUNIDAD', Estado) > 0) or (Pri = 'MEDIA') then
    Grid.Canvas.Brush.Color := $00CCFFFF
  else if (Pos('REVIS', Estado) > 0) or (Pri = 'AVISO') then
    Grid.Canvas.Brush.Color := $00E6F2FF
  else if (Pos('OK', Estado) > 0) then
    Grid.Canvas.Brush.Color := $00DFFFE0;
end;

procedure TCentroInteligenciaForm.CSVClick(Sender: TObject);
begin
  FLXGuardarCSVConDialogo(Grid,
    'Exportar Centro de Inteligencia',
    'centro_inteligencia_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.csv');
end;


procedure TCentroInteligenciaForm.InformeClick(Sender: TObject);
begin
  FLXGuardarTXTConDialogo(Memo.Lines.Text,
    'Guardar informe Centro de Inteligencia',
    'informe_centro_inteligencia_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.txt');
end;

procedure TCentroInteligenciaForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then Exit;

  // Si hay un desplegable activo, ESC lo cierra antes de salir del formulario.
  if (ActiveControl is TComboBox) and TComboBox(ActiveControl).DroppedDown then
  begin
    TComboBox(ActiveControl).DroppedDown := False;
    Key := 0;
    Exit;
  end;

  Key := 0;
  CerrarClick(Self);
end;

procedure TCentroInteligenciaForm.CerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TCentroInteligenciaForm.GridHeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer);
begin
  if not IsColumn then Exit;
  FLXGridOrdenar(Grid, Index, FSortCol, FSortDesc);
end;

procedure MostrarCentroInteligenciaFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var F: TCentroInteligenciaForm;
begin
  F := TCentroInteligenciaForm.CreateForm(AOwner, AConnection, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

end.
