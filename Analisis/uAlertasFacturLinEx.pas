unit uAlertasFacturLinEx;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, LCLType, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, Grids, DB, ZConnection, ZDataset,
  uFLXIntelligenceEngine, uFLXGridStyle, uFLXExport, uFLXIcons, uFLXDialogs;

procedure MostrarAlertasFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);

implementation

type
  TAlertasFacturLinExForm = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;
    Grid: TStringGrid;
    Memo: TMemo;
    BtnRevisar: TBitBtn;
    BtnCSV: TBitBtn;
    BtnCerrar: TBitBtn;
    FLastSortCol: Integer;
    FSortDesc: Boolean;
    FAlta: Integer;
    FMedia: Integer;
    FAviso: Integer;
    FBaja: Integer;
    FOK: Integer;
    HeaderPanel: TPanel;
    ActionPanel: TPanel;
    InfoPanel: TPanel;
    ContentPanel: TPanel;
    TitlePanel: TPanel;
    KPIPanel: TPanel;
    LblTitulo: TLabel;
    LblSubtitulo: TLabel;
    LblVistaActual: TLabel;
    LblSubtituloVista: TLabel;
    LblKPIAlta: TLabel;
    LblKPIMedia: TLabel;
    LblKPIAviso: TLabel;
    LblKPIOK: TLabel;
    LblKPISalud: TLabel;
    procedure CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
    procedure CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer = 118);
    procedure CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
    function SaludEstimada: Integer;
    procedure AplicarEstiloGrid;
    procedure AjustarColumnas;
    procedure InitGrid;
    procedure LimpiarContadores;
    procedure IncPrioridad(const Prioridad: string);
    procedure AddRow(const Prioridad, Area, Alerta, Detalle, Accion: string);
    function CleanIdent(const S: string): string;
    function SQLIdent(const S: string): string;
    function DBName: string;
    function TableName(const Prefix: string): string;
    function TableExists(const ATable: string): Boolean;
    function ColumnExists(const ATable, AColumn: string): Boolean;
    function ScalarInt(const ASQL: string; const ADefault: Integer = 0): Integer;
    procedure RevisarAlertasEngine;
    procedure RevisarAlertasEspecificas;
    procedure RevisarAlertasCompleto;
    procedure ActualizarResumen;
    procedure RevisarClick(Sender: TObject);
    procedure CSVClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CerrarClick(Sender: TObject);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
  public
    constructor CreateAlertas(AOwner: TComponent; AConnection: TZConnection; const ATienda: string); reintroduce;
  end;

procedure TAlertasFacturLinExForm.CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
begin
  FLXSetBitBtnIcon(ABtn, AIcon, ASize);
end;

procedure TAlertasFacturLinExForm.CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer);
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

procedure TAlertasFacturLinExForm.CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
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

function TAlertasFacturLinExForm.SaludEstimada: Integer;
begin
  Result := 100 - (FAlta * 14) - (FMedia * 7) - (FAviso * 3) - FBaja;
  if Result < 0 then Result := 0;
  if Result > 100 then Result := 100;
end;

constructor TAlertasFacturLinExForm.CreateAlertas(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
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
  FLastSortCol := -1;
  FSortDesc := False;

  Caption := 'FacturLinEx - Alertas';
  Width := 1300;
  Height := 820;
  Position := poScreenCenter;
  WindowState := wsMaximized;
  BorderIcons := [biSystemMenu, biMaximize];
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
  FN := FLXIconFile('alertas', 64);
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
  LblTitulo.Caption := 'Centro de Alertas';
  LblTitulo.Font.Size := 24;
  LblTitulo.Font.Style := [fsBold];
  LblTitulo.Font.Color := RGBToColor(0,32,80);

  LblSubtitulo := TLabel.Create(Self);
  LblSubtitulo.Parent := HeaderPanel;
  LblSubtitulo.Left := 114;
  LblSubtitulo.Top := 68;
  LblSubtitulo.Caption := 'Avisos accionables del motor común y comprobaciones específicas de FacturLinEx';
  LblSubtitulo.Font.Size := 11;
  LblSubtitulo.Font.Color := RGBToColor(45,70,105);

  ActionPanel := TPanel.Create(Self);
  ActionPanel.Parent := HeaderPanel;
  ActionPanel.Align := alRight;
  ActionPanel.Width := 430;
  ActionPanel.BevelOuter := bvNone;
  ActionPanel.Color := HeaderPanel.Color;

  CrearBotonAccion(ActionPanel, BtnRevisar, 'Actualizar', 'tend_actualizar', 8, 124);
  BtnRevisar.OnClick := @RevisarClick;
  CrearBotonAccion(ActionPanel, BtnCSV, 'Exportar', 'tend_exportar', 146, 118);
  BtnCSV.OnClick := @CSVClick;
  CrearBotonAccion(ActionPanel, BtnCerrar, 'Cerrar', 'tend_cerrar', 278, 118);
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
  L.Top := 58;
  L.Width := 205;
  L.Height := 185;
  L.WordWrap := True;
  L.Caption := 'Alertas revisa puntos que pueden requerir atención: VeriFactu, artículos, proveedores, EAN, clientes y promociones. Es una pantalla de consulta y no modifica datos.';
  L.Font.Color := RGBToColor(45,70,105);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 280;
  L.Caption := 'Prioridades';
  L.Font.Size := 12;
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,65,145);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 318;
  L.Width := 205;
  L.Height := 180;
  L.WordWrap := True;
  L.Caption := 'ALTA: revisar cuanto antes.' + LineEnding +
               'MEDIA: conviene revisar.' + LineEnding +
               'AVISO/BAJA: preventivo.' + LineEnding +
               'OK: sin incidencias destacables.';
  L.Font.Color := RGBToColor(45,70,105);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 540;
  L.Width := 205;
  L.Height := 90;
  L.WordWrap := True;
  L.Caption := 'Diseño visual alineado con Predicciones v1/v1.1. Grid ordenable por cabeceras y selección con texto negro.';
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
  LblVistaActual.Caption := 'Alertas del sistema';
  LblVistaActual.Font.Size := 12;
  LblVistaActual.Font.Style := [fsBold];
  LblVistaActual.Font.Color := RGBToColor(0,65,145);

  LblSubtituloVista := TLabel.Create(Self);
  LblSubtituloVista.Parent := TitlePanel;
  LblSubtituloVista.Left := 16;
  LblSubtituloVista.Top := 38;
  LblSubtituloVista.Caption := 'Pulse Actualizar para revisar avisos. Las columnas se ordenan con clic en la cabecera.';
  LblSubtituloVista.Font.Color := RGBToColor(45,70,105);

  KPIPanel := TPanel.Create(Self);
  KPIPanel.Parent := ContentPanel;
  KPIPanel.Align := alBottom;
  KPIPanel.Height := 108;
  KPIPanel.BevelOuter := bvLowered;
  KPIPanel.Color := RGBToColor(250,252,255);

  CrearKPI(KPIPanel, 'ALTA', 'alertas', 12, LblKPIAlta);
  CrearKPI(KPIPanel, 'MEDIA', 'doctor', 252, LblKPIMedia);
  CrearKPI(KPIPanel, 'AVISOS', 'tend_configuracion', 492, LblKPIAviso);
  CrearKPI(KPIPanel, 'OK', 'centro_inteligencia', 732, LblKPIOK);
  CrearKPI(KPIPanel, 'Salud', 'rentabilidad', 972, LblKPISalud);

  Grid := TStringGrid.Create(Self);
  Grid.Parent := ContentPanel;
  Grid.Align := alClient;
  Grid.OnMouseDown := @GridMouseDown;
  Grid.OnDrawCell := @GridDrawCell;
  AplicarEstiloGrid;
  InitGrid;

  Memo := TMemo.Create(Self);
  Memo.Parent := Self;
  Memo.Align := alBottom;
  Memo.Height := 78;
  Memo.ReadOnly := True;
  Memo.ScrollBars := ssVertical;
  Memo.Color := RGBToColor(250,252,255);
  Memo.Lines.Text := 'Centro de Alertas listo. Pulse Actualizar para ejecutar la revisión.' + LineEnding +
                     'Mantiene el motor común + comprobaciones específicas. Modo solo lectura.' + LineEnding +
                     'No modifica tablas, no cambia precios y no altera VeriFactu.';

  LimpiarContadores;
  ActualizarResumen;
end;

procedure TAlertasFacturLinExForm.AplicarEstiloGrid;
begin
  FLXGridPreparar(Grid);
  Grid.Color := clWhite;
  Grid.FixedColor := RGBToColor(225,238,252);
  Grid.AlternateColor := RGBToColor(248,251,255);
  Grid.Font.Color := clBlack;
  Grid.TitleFont.Color := RGBToColor(0,32,80);
  Grid.TitleFont.Style := [fsBold];
  Grid.Options := Grid.Options + [goRowSelect, goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goThumbTracking];
end;

procedure TAlertasFacturLinExForm.AjustarColumnas;
var
  W: Integer;
begin
  if Grid.ColCount < 5 then Exit;
  W := Grid.ClientWidth - 48;
  if W < 900 then W := 900;
  Grid.ColWidths[0] := 95;
  Grid.ColWidths[1] := 135;
  Grid.ColWidths[2] := 300;
  Grid.ColWidths[3] := (W - 95 - 135 - 300) div 2;
  if Grid.ColWidths[3] < 260 then Grid.ColWidths[3] := 260;
  Grid.ColWidths[4] := W - 95 - 135 - 300 - Grid.ColWidths[3];
  if Grid.ColWidths[4] < 260 then Grid.ColWidths[4] := 260;
end;

procedure TAlertasFacturLinExForm.InitGrid;
begin
  Grid.ColCount := 5;
  Grid.FixedRows := 1;
  Grid.RowCount := 1;
  Grid.Cells[0,0] := 'Prioridad';
  Grid.Cells[1,0] := 'Área';
  Grid.Cells[2,0] := 'Alerta';
  Grid.Cells[3,0] := 'Detalle';
  Grid.Cells[4,0] := 'Acción recomendada';
  AjustarColumnas;
end;

procedure TAlertasFacturLinExForm.LimpiarContadores;
begin
  FAlta := 0;
  FMedia := 0;
  FAviso := 0;
  FBaja := 0;
  FOK := 0;
end;

procedure TAlertasFacturLinExForm.IncPrioridad(const Prioridad: string);
var
  S: string;
begin
  S := UpperCase(Trim(Prioridad));
  if S = 'ALTA' then Inc(FAlta)
  else if S = 'MEDIA' then Inc(FMedia)
  else if S = 'AVISO' then Inc(FAviso)
  else if S = 'BAJA' then Inc(FBaja)
  else if S = 'OK' then Inc(FOK);
end;

procedure TAlertasFacturLinExForm.AddRow(const Prioridad, Area, Alerta, Detalle, Accion: string);
var
  R: Integer;
begin
  R := Grid.RowCount;
  Grid.RowCount := R + 1;
  Grid.Cells[0,R] := Prioridad;
  Grid.Cells[1,R] := Area;
  Grid.Cells[2,R] := Alerta;
  Grid.Cells[3,R] := Detalle;
  Grid.Cells[4,R] := Accion;
  IncPrioridad(Prioridad);
end;

function TAlertasFacturLinExForm.CleanIdent(const S: string): string;
begin
  Result := StringReplace(S, '`', '', [rfReplaceAll]);
end;

function TAlertasFacturLinExForm.SQLIdent(const S: string): string;
begin
  Result := '`' + CleanIdent(S) + '`';
end;

function TAlertasFacturLinExForm.DBName: string;
begin
  Result := '';
  if Assigned(FConn) then
    Result := FConn.Database;
end;

function TAlertasFacturLinExForm.TableName(const Prefix: string): string;
begin
  Result := Prefix + FTienda;
end;

function TAlertasFacturLinExForm.TableExists(const ATable: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (not Assigned(FConn)) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    try
      Q.Connection := FConn;
      Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=:DB AND TABLE_NAME=:T';
      Q.ParamByName('DB').AsString := DBName;
      Q.ParamByName('T').AsString := CleanIdent(ATable);
      Q.Open;
      Result := Q.FieldByName('C').AsInteger > 0;
    except
      Result := False;
    end;
  finally
    Q.Free;
  end;
end;

function TAlertasFacturLinExForm.ColumnExists(const ATable, AColumn: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (not Assigned(FConn)) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    try
      Q.Connection := FConn;
      Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=:DB AND TABLE_NAME=:T AND COLUMN_NAME=:C';
      Q.ParamByName('DB').AsString := DBName;
      Q.ParamByName('T').AsString := CleanIdent(ATable);
      Q.ParamByName('C').AsString := CleanIdent(AColumn);
      Q.Open;
      Result := Q.FieldByName('C').AsInteger > 0;
    except
      Result := False;
    end;
  finally
    Q.Free;
  end;
end;

function TAlertasFacturLinExForm.ScalarInt(const ASQL: string; const ADefault: Integer): Integer;
var
  Q: TZQuery;
begin
  Result := ADefault;
  if (not Assigned(FConn)) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    try
      Q.Connection := FConn;
      Q.SQL.Text := ASQL;
      Q.Open;
      if not Q.EOF then
        Result := Q.Fields[0].AsInteger;
    except
      Result := ADefault;
    end;
  finally
    Q.Free;
  end;
end;

procedure TAlertasFacturLinExForm.RevisarAlertasEngine;
var
  Engine: TFLXIntelligenceEngine;
  I: Integer;
  It: TFLXIntelItem;
begin
  Engine := TFLXIntelligenceEngine.Create(FConn, FTienda);
  try
    Engine.Clear;
    Engine.RevisarDoctor;
    Engine.RevisarAlertas;
    Engine.RevisarCompras;
    Engine.RevisarRentabilidad;
    Engine.RevisarVeriFactu;

    for I := 0 to Engine.Results.Count - 1 do
    begin
      It := Engine.Results[I];
      if It.Prioridad <> ipOK then
        AddRow(It.PrioridadTexto, It.Origen, It.Resumen, It.Detalle, It.Accion);
    end;
  finally
    Engine.Free;
  end;
end;

procedure TAlertasFacturLinExForm.RevisarAlertasEspecificas;
var
  TArt, TPromo, TRules, TPack: string;
  N: Integer;
begin
  TArt := TableName('artitien');
  TPromo := TableName('promo');
  TRules := TableName('promo_rules');
  TPack := TableName('promo_pack_items');

  { VeriFactu: avisos accionables. }
  if TableExists('verifactu_queue') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM verifactu_queue WHERE estado IN (''PENDIENTE'',''EN_PROCESO'',''ERROR_TECNICO'')');
    if N > 0 then
      AddRow('ALTA', 'VeriFactu', IntToStr(N) + ' documentos pendientes o bloqueantes',
             'Hay documentos en PENDIENTE, EN_PROCESO o ERROR_TECNICO.', 'Abrir monitor VeriFactu y revisar estado.');

    N := ScalarInt('SELECT COUNT(*) FROM verifactu_queue WHERE estado = ''ERROR''');
    if N > 0 then
      AddRow('MEDIA', 'VeriFactu', IntToStr(N) + ' documentos con ERROR AEAT',
             'Errores con respuesta que pueden requerir revisión/subsanación.', 'Abrir monitor VeriFactu.');
  end;

  { Artículos. }
  if TableExists(TArt) then
  begin
    if ColumnExists(TArt, 'A32') then
    begin
      N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TArt) + ' WHERE IFNULL(A32,0)=0');
      if N > 0 then
        AddRow('MEDIA', 'Artículos', IntToStr(N) + ' artículos sin proveedor habitual',
               'Campo A32 vacío/cero. Afecta a pedidos, compras y asesor.', 'Completar proveedor en ficha.');

      if TableExists('proveedores') then
      begin
        N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TArt) + ' a LEFT JOIN proveedores p ON p.P0=a.A32 WHERE IFNULL(a.A32,0)<>0 AND p.P0 IS NULL');
        if N > 0 then
          AddRow('ALTA', 'Artículos', IntToStr(N) + ' artículos con proveedor inexistente',
                 'A32 apunta a un código que no existe en proveedores.', 'Revisar proveedor asignado.');
      end;
    end;

    if ColumnExists(TArt, 'A14') then
    begin
      N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TArt) + ' WHERE IFNULL(A14,0)=0');
      if N > 0 then
        AddRow('BAJA', 'Artículos', IntToStr(N) + ' artículos sin familia',
               'Campo A14 vacío/cero. Afecta a informes y tendencias.', 'Asignar familia.');
    end;

    if ColumnExists(TArt, 'A19') then
    begin
      N := ScalarInt('SELECT COUNT(*) FROM (SELECT A19 FROM ' + SQLIdent(TArt) + ' WHERE IFNULL(A19,'''')<>'''' GROUP BY A19 HAVING COUNT(*)>1) x');
      if N > 0 then
        AddRow('MEDIA', 'EAN', IntToStr(N) + ' EAN auxiliares duplicados',
               'Hay códigos auxiliares repetidos en A19.', 'Revisar duplicados para evitar búsquedas ambiguas.');
    end;

    if ColumnExists(TArt, 'A1') then
    begin
      N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TArt) + ' WHERE A1 LIKE ''%''''%'' OR A1 LIKE ''%"%''');
      if N > 0 then
        AddRow('AVISO', 'Artículos', IntToStr(N) + ' descripciones con comillas',
               'Pueden generar problemas si alguna consulta antigua concatena SQL.', 'Revisar/normalizar descripciones.');
    end;
  end;

  { Clientes: C6 se usa como campo candidato de NIF/CIF en la estructura clásica. }
  if TableExists('clientes') and ColumnExists('clientes', 'C6') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM clientes WHERE IFNULL(C6,'''')=''''');
    if N > 0 then
      AddRow('BAJA', 'Clientes', IntToStr(N) + ' clientes sin NIF/CIF',
             'Campo C6 vacío.', 'Revisar solo si el cliente requiere facturación completa.');
  end;

  { Promociones clásicas. }
  if TableExists(TPromo) then
  begin
    if ColumnExists(TPromo, 'P6') then
    begin
      N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TPromo) + ' WHERE P6<>''0000-00-00'' AND P6 < CURDATE()');
      if N > 0 then
        AddRow('AVISO', 'Promociones', IntToStr(N) + ' promociones caducadas',
               'Promociones con fecha fin P6 anterior a hoy.', 'Revisar/limpiar promociones caducadas.');

      N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TPromo) + ' WHERE P6 BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)');
      if N > 0 then
        AddRow('BAJA', 'Promociones', IntToStr(N) + ' promociones terminan en 7 días',
               'Hay promociones próximas a finalizar.', 'Revisar continuidad o sustitución.');
    end;
  end;

  { Motor nuevo de promociones. }
  if TableExists(TRules) then
  begin
    if ColumnExists(TRules, 'activo') then
    begin
      N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TRules) + ' WHERE UPPER(IFNULL(activo,'''')) NOT IN (''S'',''N'','''')');
      if N > 0 then
        AddRow('MEDIA', 'Promociones', IntToStr(N) + ' reglas con activo inválido',
               'El campo activo debería ser S, N o vacío.', 'Revisar reglas de promoción.');
    end;

    if ColumnExists(TRules, 'activo') and ColumnExists(TRules, 'fin_dt') then
    begin
      N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TRules) + ' WHERE UPPER(IFNULL(activo,''''))=''S'' AND fin_dt IS NOT NULL AND fin_dt < NOW()');
      if N > 0 then
        AddRow('AVISO', 'Promociones', IntToStr(N) + ' reglas activas caducadas',
               'Reglas promo_rules activas con fin_dt ya vencido.', 'Desactivar o actualizar fechas.');

      N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TRules) + ' WHERE UPPER(IFNULL(activo,''''))=''S'' AND fin_dt BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 7 DAY)');
      if N > 0 then
        AddRow('BAJA', 'Promociones', IntToStr(N) + ' reglas terminan en 7 días',
               'Reglas activas próximas a vencer.', 'Revisar campañas próximas.');
    end;
  end;

  if TableExists(TPack) and TableExists(TArt) and ColumnExists(TPack, 'articulo') and ColumnExists(TArt, 'A0') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TPack) + ' pi LEFT JOIN ' + SQLIdent(TArt) + ' a ON a.A0=pi.articulo WHERE a.A0 IS NULL');
    if N > 0 then
      AddRow('MEDIA', 'Promociones', IntToStr(N) + ' líneas de pack con artículo inexistente',
             'promo_pack_items contiene artículos que no existen en artitien.', 'Revisar packs de promociones.');
  end;
end;

procedure TAlertasFacturLinExForm.RevisarAlertasCompleto;
begin
  InitGrid;
  LimpiarContadores;

  if (not Assigned(FConn)) or (not FConn.Connected) then
  begin
    AddRow('ALTA', 'Conexión', 'No hay conexión activa a la base de datos',
           'No se puede ejecutar la revisión sin conexión MariaDB.', 'Abrir desde FacturLinEx con la conexión global activa.');
    Exit;
  end;

  RevisarAlertasEngine;
  RevisarAlertasEspecificas;

  if Grid.RowCount = 1 then
    AddRow('OK', 'Sistema', 'Sin alertas destacables', 'No se han detectado avisos en las comprobaciones actuales.', 'No requiere acción.');
end;

procedure TAlertasFacturLinExForm.ActualizarResumen;
var
  Salud: Integer;
begin
  Salud := SaludEstimada;
  if Assigned(LblKPIAlta) then LblKPIAlta.Caption := IntToStr(FAlta);
  if Assigned(LblKPIMedia) then LblKPIMedia.Caption := IntToStr(FMedia);
  if Assigned(LblKPIAviso) then LblKPIAviso.Caption := IntToStr(FAviso + FBaja);
  if Assigned(LblKPIOK) then LblKPIOK.Caption := IntToStr(FOK);
  if Assigned(LblKPISalud) then LblKPISalud.Caption := IntToStr(Salud) + '%';

  if Assigned(LblVistaActual) then
    LblVistaActual.Caption := 'Alertas del sistema: ' + IntToStr(Grid.RowCount - 1) + ' líneas';

  if Assigned(LblSubtituloVista) then
  begin
    if FAlta > 0 then
      LblSubtituloVista.Caption := 'Hay alertas de prioridad ALTA. Conviene revisarlas primero.'
    else if FMedia > 0 then
      LblSubtituloVista.Caption := 'No hay altas, pero sí alertas medias o preventivas.'
    else if (FAviso + FBaja) > 0 then
      LblSubtituloVista.Caption := 'Solo se han detectado avisos preventivos.'
    else
      LblSubtituloVista.Caption := 'Sin alertas destacables en la revisión actual.';
  end;

  if Assigned(Memo) then
    Memo.Lines.Text := 'Centro de Alertas actualizado.' + LineEnding +
                       'ALTA: ' + IntToStr(FAlta) + ' | MEDIA: ' + IntToStr(FMedia) +
                       ' | AVISO/BAJA: ' + IntToStr(FAviso + FBaja) + ' | OK: ' + IntToStr(FOK) +
                       ' | Salud estimada: ' + IntToStr(Salud) + '%' + LineEnding +
                       'Modo solo lectura. Ordenable por columnas. Selección con texto negro.';
end;

procedure TAlertasFacturLinExForm.RevisarClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    try
      RevisarAlertasCompleto;
    except
      on E: Exception do
      begin
        InitGrid;
        LimpiarContadores;
        AddRow('ALTA', 'Sistema', 'Error ejecutando alertas', E.Message, 'Comunicar el mensaje exacto y revisar campos/consulta.');
      end;
    end;
    AjustarColumnas;
    ActualizarResumen;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TAlertasFacturLinExForm.CSVClick(Sender: TObject);
begin
  if FLXGuardarCSVConDialogo(Grid, 'Exportar alertas FacturLinEx', 'alertas_facturlinex.csv') then
    FLXInfo('CSV generado correctamente.', 'Alertas');
end;

procedure TAlertasFacturLinExForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TAlertasFacturLinExForm.CerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TAlertasFacturLinExForm.GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  C, R: Integer;
begin
  if Button <> mbLeft then Exit;
  Grid.MouseToCell(X, Y, C, R);
  if R = 0 then
    FLXGridOrdenar(Grid, C, FLastSortCol, FSortDesc);
end;

procedure TAlertasFacturLinExForm.GridDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
var
  S: string;
begin
  Grid.Canvas.Font.Color := clBlack;
  if gdFixed in aState then
  begin
    Grid.Canvas.Brush.Color := RGBToColor(225,238,252);
    Grid.Canvas.Font.Color := RGBToColor(0,32,80);
    Grid.Canvas.Font.Style := [fsBold];
  end
  else
  begin
    Grid.Canvas.Font.Style := [];
    if gdSelected in aState then
      Grid.Canvas.Brush.Color := RGBToColor(232,244,255)
    else
    begin
      S := UpperCase(Trim(Grid.Cells[0,aRow]));
      if S = 'ALTA' then
        Grid.Canvas.Brush.Color := RGBToColor(255,226,226)
      else if S = 'MEDIA' then
        Grid.Canvas.Brush.Color := RGBToColor(255,246,210)
      else if S = 'AVISO' then
        Grid.Canvas.Brush.Color := RGBToColor(236,242,255)
      else if S = 'BAJA' then
        Grid.Canvas.Brush.Color := RGBToColor(245,245,245)
      else if S = 'OK' then
        Grid.Canvas.Brush.Color := RGBToColor(232,250,232)
      else if Odd(aRow) then
        Grid.Canvas.Brush.Color := RGBToColor(248,251,255)
      else
        Grid.Canvas.Brush.Color := clWhite;
    end;
  end;
  Grid.Canvas.FillRect(aRect);
  Grid.Canvas.TextRect(aRect, aRect.Left + 5, aRect.Top + 3, Grid.Cells[aCol,aRow]);
end;

procedure MostrarAlertasFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  F: TAlertasFacturLinExForm;
begin
  F := TAlertasFacturLinExForm.CreateAlertas(AOwner, AConnection, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

end.
