unit uHistoricoPreciosFacturLinEx;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, LCLType, Dialogs, ExtCtrls, StdCtrls, Buttons,
  Grids, Graphics, DB, ZConnection, ZDataset,
  uFLXGridStyle, uFLXExport, uFLXIcons, uFLXDialogs;

procedure MostrarHistoricoPreciosFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);

implementation

type
  THistoricoPreciosFacturLinExForm = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;
    Grid: TStringGrid;
    Memo: TMemo;
    EditFiltro: TEdit;
    BtnActual: TBitBtn;
    BtnAnomalias: TBitBtn;
    BtnHist: TBitBtn;
    BtnActualizar: TBitBtn;
    BtnCSV: TBitBtn;
    BtnCerrar: TBitBtn;
    FSortCol: Integer;
    FSortDesc: Boolean;
    FVistaActual: string;
    FTotalLineas: Integer;
    FMargenAcum: Double;
    FMargenNum: Integer;
    FSinCoste: Integer;
    FSinPVP: Integer;
    FAvisos: Integer;
    FSubidas: Integer;
    FBajadas: Integer;
    FUsuarios: TStringList;
    FUltimoMov: string;
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
    LblKPILineas: TLabel;
    LblKPIMargen: TLabel;
    LblKPISinCoste: TLabel;
    LblKPISinPVP: TLabel;
    LblKPIAvisos: TLabel;
    procedure CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
    procedure CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer = 118);
    procedure CrearBotonVista(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ATop: Integer);
    procedure CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
    function DBName: string;
    function CleanIdent(const S: string): string;
    function SQLIdent(const S: string): string;
    function ArtTable: string;
    function HistTable: string;
    function TableExists(const ATable: string): Boolean;
    function ColumnExists(const ATable, AColumn: string): Boolean;
    function FieldSQL(const ATable, AColumn, ADefault: string): string;
    function SafeFloat(AField: TField): Double;
    function Money4(V: Double): string;
    function Porc2(V: Double): string;
    function TryParseNumber(const S: string; out V: Double): Boolean;
    function AvisoPrecio(Coste, PVP, PVPIVA, Margen: Double): string;
    procedure ResetGrid(const Headers: array of string);
    procedure AddRow(const Values: array of string);
    procedure AplicarEstiloGrid;
    procedure AjustarColumnas;
    procedure LimpiarKPIs;
    procedure AcumularActual(Coste, PVP, PVPIVA, Margen: Double; const Aviso: string);
    procedure AcumularHistorico(const Usuario, Fecha, Hora, Antes, Despues: string);
    procedure ActualizarKPIsActual;
    procedure ActualizarKPIsHistorico;
    function HistColumnsOK(out AMsg: string): Boolean;
    procedure CargarFotoActual(const SoloAnomalias: Boolean);
    procedure CargarHistorico;
    procedure RecargarVista;
    procedure ActualClick(Sender: TObject);
    procedure AnomaliasClick(Sender: TObject);
    procedure HistClick(Sender: TObject);
    procedure ActualizarClick(Sender: TObject);
    procedure CSVClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CerrarClick(Sender: TObject);
    procedure GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  public
    constructor CreateHistorico(AOwner: TComponent; AConnection: TZConnection; const ATienda: string); reintroduce;
    destructor Destroy; override;
  end;

procedure THistoricoPreciosFacturLinExForm.CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
begin
  FLXSetBitBtnIcon(ABtn, AIcon, ASize);
end;

procedure THistoricoPreciosFacturLinExForm.CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer);
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

procedure THistoricoPreciosFacturLinExForm.CrearBotonVista(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ATop: Integer);
begin
  ABtn := TBitBtn.Create(Self);
  ABtn.Parent := AParent;
  ABtn.Left := 18;
  ABtn.Top := ATop;
  ABtn.Width := 205;
  ABtn.Height := 52;
  ABtn.Caption := ACaption;
  ABtn.Layout := blGlyphLeft;
  ABtn.Font.Style := [fsBold];
  CargarIconoBoton(ABtn, AIcon, 30);
end;

procedure THistoricoPreciosFacturLinExForm.CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
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

constructor THistoricoPreciosFacturLinExForm.CreateHistorico(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
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
  FVistaActual := 'ACTUAL';
  FUsuarios := TStringList.Create;
  FUsuarios.Sorted := True;
  FUsuarios.Duplicates := dupIgnore;

  Caption := 'FacturLinEx - Histórico de precios';
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
  FN := FLXIconFile('historico_precios', 64);
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
  LblTitulo.Caption := 'Histórico de precios';
  LblTitulo.Font.Size := 24;
  LblTitulo.Font.Style := [fsBold];
  LblTitulo.Font.Color := RGBToColor(0,32,80);

  LblSubtitulo := TLabel.Create(Self);
  LblSubtitulo.Parent := HeaderPanel;
  LblSubtitulo.Left := 114;
  LblSubtitulo.Top := 68;
  LblSubtitulo.Caption := 'Control visual de PVP, coste, margen y cambios guardados. Consulta segura de solo lectura.';
  LblSubtitulo.Font.Size := 11;
  LblSubtitulo.Font.Color := RGBToColor(45,70,105);

  ActionPanel := TPanel.Create(Self);
  ActionPanel.Parent := HeaderPanel;
  ActionPanel.Align := alRight;
  ActionPanel.Width := 430;
  ActionPanel.BevelOuter := bvNone;
  ActionPanel.Color := HeaderPanel.Color;

  CrearBotonAccion(ActionPanel, BtnActualizar, 'Actualizar', 'tend_actualizar', 8, 124);
  BtnActualizar.OnClick := @ActualizarClick;
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
  L.Top := 18;
  L.Caption := 'Vistas';
  L.Font.Size := 12;
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,65,145);

  CrearBotonVista(InfoPanel, BtnActual, 'Foto actual', 'historico_precios', 50);
  BtnActual.OnClick := @ActualClick;
  CrearBotonVista(InfoPanel, BtnAnomalias, 'Márgenes raros', 'alertas', 110);
  BtnAnomalias.OnClick := @AnomaliasClick;
  CrearBotonVista(InfoPanel, BtnHist, 'Histórico guardado', 'tend_resumen', 170);
  BtnHist.OnClick := @HistClick;

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 246;
  L.Caption := 'Filtro';
  L.Font.Size := 12;
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,65,145);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 278;
  L.Width := 205;
  L.Height := 34;
  L.WordWrap := True;
  L.Caption := 'Código o descripción:';
  L.Font.Color := RGBToColor(45,70,105);

  EditFiltro := TEdit.Create(Self);
  EditFiltro.Parent := InfoPanel;
  EditFiltro.Left := 18;
  EditFiltro.Top := 316;
  EditFiltro.Width := 205;
  EditFiltro.Height := 28;

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 382;
  L.Caption := 'Criterios';
  L.Font.Size := 12;
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,65,145);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 420;
  L.Width := 205;
  L.Height := 190;
  L.WordWrap := True;
  L.Caption := 'Foto actual lee artitien' + FTienda + ' y revisa A2, A21 y A24.' + LineEnding +
               'Márgenes raros filtra coste cero, PVP cero, coste mayor que PVP o margen bajo.' + LineEnding +
               'Histórico guardado lee flx_hist_precios' + FTienda + '. La ficha de artículos lo crea automáticamente al cambiar A2/A21/A24.' + LineEnding +
               'Esta pantalla no crea tablas ni modifica datos.';
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
  LblVistaActual.Caption := 'Foto actual de precios';
  LblVistaActual.Font.Size := 12;
  LblVistaActual.Font.Style := [fsBold];
  LblVistaActual.Font.Color := RGBToColor(0,65,145);

  LblSubtituloVista := TLabel.Create(Self);
  LblSubtituloVista.Parent := TitlePanel;
  LblSubtituloVista.Left := 16;
  LblSubtituloVista.Top := 38;
  LblSubtituloVista.Caption := 'Ordene por cabeceras para localizar márgenes bajos, costes cero o artículos sin PVP.';
  LblSubtituloVista.Font.Color := RGBToColor(45,70,105);

  KPIPanel := TPanel.Create(Self);
  KPIPanel.Parent := ContentPanel;
  KPIPanel.Align := alBottom;
  KPIPanel.Height := 108;
  KPIPanel.BevelOuter := bvLowered;
  KPIPanel.Color := RGBToColor(250,252,255);

  CrearKPI(KPIPanel, 'Líneas', 'tend_resumen', 12, LblKPILineas);
  CrearKPI(KPIPanel, 'Margen medio', 'tend_kpi_margen', 252, LblKPIMargen);
  CrearKPI(KPIPanel, 'Sin coste', 'tend_configuracion', 492, LblKPISinCoste);
  CrearKPI(KPIPanel, 'Sin PVP', 'historico_precios', 732, LblKPISinPVP);
  CrearKPI(KPIPanel, 'Avisos', 'alertas', 972, LblKPIAvisos);

  Grid := TStringGrid.Create(Self);
  Grid.Parent := ContentPanel;
  Grid.Align := alClient;
  Grid.OnMouseDown := @GridMouseDown;
  Grid.OnPrepareCanvas := @GridPrepareCanvas;
  AplicarEstiloGrid;

  Memo := TMemo.Create(Self);
  Memo.Parent := Self;
  Memo.Align := alBottom;
  Memo.Height := 78;
  Memo.ReadOnly := True;
  Memo.ScrollBars := ssVertical;
  Memo.Color := RGBToColor(250,252,255);
  Memo.Lines.Text := 'Histórico de precios listo. Vista inicial: foto actual.' + LineEnding +
                     'Modo seguro: solo lectura, sin cambios en artículos ni creación automática de tablas.' + LineEnding +
                     'Fase futura: enganchar registro real de cambios cuando decidamos el punto exacto sin romper nada.';

  CargarFotoActual(False);
end;

destructor THistoricoPreciosFacturLinExForm.Destroy;
begin
  FUsuarios.Free;
  inherited Destroy;
end;

function THistoricoPreciosFacturLinExForm.DBName: string;
begin
  Result := '';
  if Assigned(FConn) then Result := FConn.Database;
end;

function THistoricoPreciosFacturLinExForm.CleanIdent(const S: string): string;
begin
  Result := StringReplace(S, '`', '', [rfReplaceAll]);
end;

function THistoricoPreciosFacturLinExForm.SQLIdent(const S: string): string;
begin
  Result := '`' + CleanIdent(S) + '`';
end;

function THistoricoPreciosFacturLinExForm.ArtTable: string;
begin
  Result := 'artitien' + FTienda;
end;

function THistoricoPreciosFacturLinExForm.HistTable: string;
begin
  Result := 'flx_hist_precios' + FTienda;
end;

function THistoricoPreciosFacturLinExForm.TableExists(const ATable: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (not Assigned(FConn)) or (not FConn.Connected) or (ATable = '') then Exit;
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

function THistoricoPreciosFacturLinExForm.ColumnExists(const ATable, AColumn: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (not Assigned(FConn)) or (not FConn.Connected) or (ATable = '') or (AColumn = '') then Exit;
  Q := TZQuery.Create(nil);
  try
    try
      Q.Connection := FConn;
      Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=:DB AND TABLE_NAME=:T AND COLUMN_NAME=:C';
      Q.ParamByName('DB').AsString := DBName;
      Q.ParamByName('T').AsString := CleanIdent(ATable);
      Q.ParamByName('C').AsString := AColumn;
      Q.Open;
      Result := Q.FieldByName('C').AsInteger > 0;
    except
      Result := False;
    end;
  finally
    Q.Free;
  end;
end;

function THistoricoPreciosFacturLinExForm.FieldSQL(const ATable, AColumn, ADefault: string): string;
begin
  if ColumnExists(ATable, AColumn) then Result := SQLIdent(AColumn) else Result := ADefault;
end;

function THistoricoPreciosFacturLinExForm.SafeFloat(AField: TField): Double;
begin
  Result := 0;
  if Assigned(AField) and (not AField.IsNull) then
  begin
    try
      Result := AField.AsFloat;
    except
      Result := 0;
    end;
  end;
end;

function THistoricoPreciosFacturLinExForm.Money4(V: Double): string;
begin
  Result := FormatFloat('0.0000', V);
end;

function THistoricoPreciosFacturLinExForm.Porc2(V: Double): string;
begin
  Result := FormatFloat('0.00', V) + ' %';
end;

function THistoricoPreciosFacturLinExForm.TryParseNumber(const S: string; out V: Double): Boolean;
var
  T: string;
  FS: TFormatSettings;
begin
  T := Trim(S);
  T := StringReplace(T, '€', '', [rfReplaceAll]);
  T := StringReplace(T, '%', '', [rfReplaceAll]);
  T := StringReplace(T, ' ', '', [rfReplaceAll]);
  T := StringReplace(T, #160, '', [rfReplaceAll]);
  Result := False;
  V := 0;
  if T = '' then Exit;

  FS := DefaultFormatSettings;
  Result := TryStrToFloat(T, V, FS);
  if Result then Exit;

  FS := DefaultFormatSettings;
  FS.DecimalSeparator := ',';
  FS.ThousandSeparator := '.';
  Result := TryStrToFloat(T, V, FS);
  if Result then Exit;

  FS := DefaultFormatSettings;
  FS.DecimalSeparator := '.';
  FS.ThousandSeparator := ',';
  Result := TryStrToFloat(T, V, FS);
end;

function THistoricoPreciosFacturLinExForm.AvisoPrecio(Coste, PVP, PVPIVA, Margen: Double): string;
begin
  Result := 'OK';
  if PVPIVA = 0 then Result := 'PVP con IVA a cero';
  if PVP = 0 then Result := 'PVP sin IVA a cero';
  if Coste = 0 then Result := 'Coste a cero';
  if (PVP > 0) and (Coste > PVP) then Result := 'Coste mayor que PVP sin IVA';
  if (PVP > 0) and (Coste > 0) and (Margen < 5) then Result := 'Margen muy bajo';
end;

procedure THistoricoPreciosFacturLinExForm.ResetGrid(const Headers: array of string);
var
  I: Integer;
begin
  Grid.BeginUpdate;
  try
    Grid.ColCount := Length(Headers);
    Grid.FixedRows := 1;
    Grid.RowCount := 1;
    for I := Low(Headers) to High(Headers) do
      Grid.Cells[I,0] := Headers[I];
    FSortCol := -1;
    FSortDesc := False;
    LimpiarKPIs;
  finally
    Grid.EndUpdate;
  end;
end;

procedure THistoricoPreciosFacturLinExForm.AddRow(const Values: array of string);
var
  R, I: Integer;
begin
  R := Grid.RowCount;
  Grid.RowCount := R + 1;
  for I := Low(Values) to High(Values) do
    if I < Grid.ColCount then Grid.Cells[I,R] := Values[I];
end;

procedure THistoricoPreciosFacturLinExForm.AplicarEstiloGrid;
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

procedure THistoricoPreciosFacturLinExForm.AjustarColumnas;
var
  W, DescW: Integer;
begin
  if Grid.ColCount = 8 then
  begin
    W := Grid.ClientWidth - 60;
    if W < 1050 then W := 1050;
    DescW := W - 110 - 75 - 110 - 110 - 110 - 100 - 260;
    if DescW < 320 then DescW := 320;
    Grid.ColWidths[0] := 110;
    Grid.ColWidths[1] := DescW;
    Grid.ColWidths[2] := 75;
    Grid.ColWidths[3] := 110;
    Grid.ColWidths[4] := 110;
    Grid.ColWidths[5] := 110;
    Grid.ColWidths[6] := 100;
    Grid.ColWidths[7] := 260;
  end
  else if Grid.ColCount = 9 then
  begin
    W := Grid.ClientWidth - 60;
    if W < 1150 then W := 1150;
    DescW := W - 95 - 75 - 100 - 110 - 95 - 100 - 100 - 240;
    if DescW < 260 then DescW := 260;
    Grid.ColWidths[0] := 95;
    Grid.ColWidths[1] := 75;
    Grid.ColWidths[2] := 100;
    Grid.ColWidths[3] := 110;
    Grid.ColWidths[4] := DescW;
    Grid.ColWidths[5] := 95;
    Grid.ColWidths[6] := 100;
    Grid.ColWidths[7] := 100;
    Grid.ColWidths[8] := 240;
  end
  else
    FLXGridAutoAjustar(Grid, 80, 360);
end;

procedure THistoricoPreciosFacturLinExForm.LimpiarKPIs;
begin
  FTotalLineas := 0;
  FMargenAcum := 0;
  FMargenNum := 0;
  FSinCoste := 0;
  FSinPVP := 0;
  FAvisos := 0;
  FSubidas := 0;
  FBajadas := 0;
  FUltimoMov := '-';
  if Assigned(FUsuarios) then FUsuarios.Clear;
end;

procedure THistoricoPreciosFacturLinExForm.AcumularActual(Coste, PVP, PVPIVA, Margen: Double; const Aviso: string);
begin
  Inc(FTotalLineas);
  if Coste = 0 then Inc(FSinCoste);
  if (PVP = 0) or (PVPIVA = 0) then Inc(FSinPVP);
  if Aviso <> 'OK' then Inc(FAvisos);
  if PVP > 0 then
  begin
    Inc(FMargenNum);
    FMargenAcum := FMargenAcum + Margen;
  end;
end;

procedure THistoricoPreciosFacturLinExForm.AcumularHistorico(const Usuario, Fecha, Hora, Antes, Despues: string);
var
  VAntes, VDespues: Double;
begin
  Inc(FTotalLineas);
  if Trim(Usuario) <> '' then FUsuarios.Add(Trim(Usuario));
  if FUltimoMov = '-' then FUltimoMov := Trim(Fecha + ' ' + Hora);
  if TryParseNumber(Antes, VAntes) and TryParseNumber(Despues, VDespues) then
  begin
    if VDespues > VAntes then Inc(FSubidas)
    else if VDespues < VAntes then Inc(FBajadas);
  end;
end;

procedure THistoricoPreciosFacturLinExForm.ActualizarKPIsActual;
var
  M: Double;
begin
  LblKPILineas.Caption := IntToStr(FTotalLineas);
  if FMargenNum > 0 then M := FMargenAcum / FMargenNum else M := 0;
  LblKPIMargen.Caption := Porc2(M);
  LblKPISinCoste.Caption := IntToStr(FSinCoste);
  LblKPISinPVP.Caption := IntToStr(FSinPVP);
  LblKPIAvisos.Caption := IntToStr(FAvisos);
end;

procedure THistoricoPreciosFacturLinExForm.ActualizarKPIsHistorico;
begin
  LblKPILineas.Caption := IntToStr(FTotalLineas);
  LblKPIMargen.Caption := 'Subidas ' + IntToStr(FSubidas);
  LblKPISinCoste.Caption := 'Bajadas ' + IntToStr(FBajadas);
  LblKPISinPVP.Caption := 'Usuarios ' + IntToStr(FUsuarios.Count);
  LblKPIAvisos.Caption := FUltimoMov;
end;

function THistoricoPreciosFacturLinExForm.HistColumnsOK(out AMsg: string): Boolean;
var
  T: string;
begin
  T := HistTable;
  Result := ColumnExists(T, 'fecha') and ColumnExists(T, 'hora') and ColumnExists(T, 'usuario') and
            ColumnExists(T, 'codigo') and ColumnExists(T, 'descripcion') and ColumnExists(T, 'campo') and
            ColumnExists(T, 'valor_anterior') and ColumnExists(T, 'valor_nuevo') and ColumnExists(T, 'motivo');
  if not Result then
    AMsg := 'La tabla ' + T + ' existe, pero no tiene la estructura esperada: fecha, hora, usuario, codigo, descripcion, campo, valor_anterior, valor_nuevo y motivo.'
  else
    AMsg := '';
end;

procedure THistoricoPreciosFacturLinExForm.CargarFotoActual(const SoloAnomalias: Boolean);
var
  Q: TZQuery;
  T, Filtro, WhereSQL, Aviso, SQLIVA: string;
  Coste, PVP, PVP2, IVA, Margen: Double;
begin
  if SoloAnomalias then
  begin
    FVistaActual := 'ANOMALIAS';
    LblVistaActual.Caption := 'Márgenes raros';
    LblSubtituloVista.Caption := 'Artículos con coste cero, PVP cero, coste mayor que PVP o margen inferior al 5%.';
  end
  else
  begin
    FVistaActual := 'ACTUAL';
    LblVistaActual.Caption := 'Foto actual de precios';
    LblSubtituloVista.Caption := 'Precios y margen teórico actual por artículo. Use el filtro lateral y las cabeceras.';
  end;

  ResetGrid(['Código','Descripción','IVA','PVP c/IVA','PVP s/IVA','Coste aprox.','Margen','Aviso']);
  AjustarColumnas;

  T := ArtTable;
  if not TableExists(T) then
  begin
    AddRow(['','','','','','','','No existe la tabla ' + T]);
    ActualizarKPIsActual;
    Exit;
  end;

  Filtro := Trim(EditFiltro.Text);
  WhereSQL := ' WHERE 1=1 ';
  if Filtro <> '' then
    WhereSQL := WhereSQL + ' AND (A0 LIKE ' + QuotedStr('%' + Filtro + '%') + ' OR A1 LIKE ' + QuotedStr('%' + Filtro + '%') + ') ';

  if SoloAnomalias then
    WhereSQL := WhereSQL + ' AND (A2 = 0 OR A21 = 0 OR A24 = 0 OR A24 > A21 OR ((A21-A24)/NULLIF(A21,0))*100 < 5) ';

  SQLIVA := FieldSQL(T, 'A3', '0');

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT A0, A1, ' + SQLIVA + ' IVA, A2, A21, A24 FROM ' + SQLIdent(T) + WhereSQL +
                  ' ORDER BY A1 LIMIT 1500';
    Q.Open;
    while not Q.EOF do
    begin
      IVA := SafeFloat(Q.FieldByName('IVA'));
      PVP := SafeFloat(Q.FieldByName('A2'));
      PVP2 := SafeFloat(Q.FieldByName('A21'));
      Coste := SafeFloat(Q.FieldByName('A24'));
      Margen := 0;
      if PVP2 <> 0 then Margen := ((PVP2 - Coste) / PVP2) * 100;
      Aviso := AvisoPrecio(Coste, PVP2, PVP, Margen);

      AddRow([Q.FieldByName('A0').AsString,
              Q.FieldByName('A1').AsString,
              FormatFloat('0.00', IVA),
              Money4(PVP),
              Money4(PVP2),
              Money4(Coste),
              Porc2(Margen),
              Aviso]);
      AcumularActual(Coste, PVP2, PVP, Margen, Aviso);
      Q.Next;
    end;
    if Grid.RowCount = 1 then AddRow(['','','','','','','','Sin resultados']);
  finally
    Q.Free;
  end;
  AjustarColumnas;
  ActualizarKPIsActual;
end;

procedure THistoricoPreciosFacturLinExForm.CargarHistorico;
var
  Q: TZQuery;
  T, Filtro, WhereSQL, Msg: string;
begin
  FVistaActual := 'HISTORICO';
  LblVistaActual.Caption := 'Histórico guardado';
  LblSubtituloVista.Caption := 'Muestra movimientos registrados desde la ficha de artículos al cambiar A2, A21 o A24.';

  ResetGrid(['Fecha','Hora','Usuario','Código','Descripción','Campo','Antes','Después','Motivo']);
  AjustarColumnas;

  T := HistTable;
  if not TableExists(T) then
  begin
    AddRow(['','','','','','','','','No existe ' + T + '. Se creará automáticamente al modificar un precio/coste desde la ficha de artículos.']);
    Memo.Lines.Add('Tabla histórica esperada: ' + T + '. Se crea automáticamente al modificar A2/A21/A24 desde la ficha de artículos.');
    ActualizarKPIsHistorico;
    Exit;
  end;

  if not HistColumnsOK(Msg) then
  begin
    AddRow(['','','','','','','','',Msg]);
    ActualizarKPIsHistorico;
    Exit;
  end;

  Filtro := Trim(EditFiltro.Text);
  WhereSQL := ' WHERE 1=1 ';
  if Filtro <> '' then
    WhereSQL := WhereSQL + ' AND (codigo LIKE ' + QuotedStr('%' + Filtro + '%') + ' OR descripcion LIKE ' + QuotedStr('%' + Filtro + '%') + ') ';

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT fecha,hora,usuario,codigo,descripcion,campo,valor_anterior,valor_nuevo,motivo FROM ' + SQLIdent(T) + WhereSQL +
                  ' ORDER BY fecha DESC, hora DESC LIMIT 1500';
    Q.Open;
    while not Q.EOF do
    begin
      AddRow([Q.FieldByName('fecha').AsString,
              Q.FieldByName('hora').AsString,
              Q.FieldByName('usuario').AsString,
              Q.FieldByName('codigo').AsString,
              Q.FieldByName('descripcion').AsString,
              Q.FieldByName('campo').AsString,
              Q.FieldByName('valor_anterior').AsString,
              Q.FieldByName('valor_nuevo').AsString,
              Q.FieldByName('motivo').AsString]);
      AcumularHistorico(Q.FieldByName('usuario').AsString,
                        Q.FieldByName('fecha').AsString,
                        Q.FieldByName('hora').AsString,
                        Q.FieldByName('valor_anterior').AsString,
                        Q.FieldByName('valor_nuevo').AsString);
      Q.Next;
    end;
    if Grid.RowCount = 1 then AddRow(['','','','','','','','','Sin movimientos guardados']);
  finally
    Q.Free;
  end;
  AjustarColumnas;
  ActualizarKPIsHistorico;
end;

procedure THistoricoPreciosFacturLinExForm.RecargarVista;
begin
  if FVistaActual = 'HISTORICO' then
    CargarHistorico
  else if FVistaActual = 'ANOMALIAS' then
    CargarFotoActual(True)
  else
    CargarFotoActual(False);
end;

procedure THistoricoPreciosFacturLinExForm.ActualClick(Sender: TObject);
begin
  CargarFotoActual(False);
end;

procedure THistoricoPreciosFacturLinExForm.AnomaliasClick(Sender: TObject);
begin
  CargarFotoActual(True);
end;

procedure THistoricoPreciosFacturLinExForm.HistClick(Sender: TObject);
begin
  CargarHistorico;
end;

procedure THistoricoPreciosFacturLinExForm.ActualizarClick(Sender: TObject);
begin
  RecargarVista;
end;

procedure THistoricoPreciosFacturLinExForm.CSVClick(Sender: TObject);
begin
  if FLXGuardarCSVConDialogo(Grid, 'Exportar histórico de precios a CSV', 'historico_precios_facturlinex.csv') then
    ShowMessage('CSV generado correctamente.');
end;

procedure THistoricoPreciosFacturLinExForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure THistoricoPreciosFacturLinExForm.CerrarClick(Sender: TObject);
begin
  Close;
end;

procedure THistoricoPreciosFacturLinExForm.GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
begin
  FLXGridPrepararCanvasSeleccion(Grid, aRow, aState);
end;

procedure THistoricoPreciosFacturLinExForm.GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  C, R: Integer;
begin
  if Button <> mbLeft then Exit;
  Grid.MouseToCell(X, Y, C, R);
  if (R = 0) and (C >= 0) then
    FLXGridOrdenar(Grid, C, FSortCol, FSortDesc);
end;

procedure MostrarHistoricoPreciosFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  F: THistoricoPreciosFacturLinExForm;
begin
  F := THistoricoPreciosFacturLinExForm.CreateHistorico(AOwner, AConnection, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

end.
