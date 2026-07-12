unit uDoctorFacturLinEx;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, Grids, DB, ZConnection, ZDataset,
  uFLXIntelligenceEngine, uFLXGridStyle, uFLXExport, uFLXIcons;

procedure MostrarDoctorFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);

implementation

type

  TDoctorDetalleSQLForm = class(TForm)
  private
    FConn: TZConnection;
    FSQL: string;
    FSortCol: Integer;
    FSortDesc: Boolean;
    GridDetalle: TStringGrid;
    MemoSQL: TMemo;
    procedure CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
    procedure ExportarCSV(Sender: TObject);
    procedure Cerrar(Sender: TObject);
    procedure GridDetalleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridDetalleDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
    procedure CargarDatos;
  public
    constructor CreateDetalle(AOwner: TComponent; AConnection: TZConnection; const ATitulo, ASQL: string); reintroduce;
  end;

  TDoctorFacturLinExForm = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;
    Grid: TStringGrid;
    Memo: TMemo;
    BtnRevisar: TBitBtn;
    BtnCSV: TBitBtn;
    BtnDetalle: TBitBtn;
    BtnNormalizarNIF: TBitBtn;
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
    procedure AddRow(const Prioridad, Area, Revision, Detalle, Accion: string);
    procedure AddRowSQL(const Prioridad, Area, Revision, Detalle, Accion, ASQLDetalle: string);
    procedure IncPrioridad(const Prioridad: string);
    function CleanIdent(const S: string): string;
    function SQLIdent(const S: string): string;
    function DBName: string;
    function TableName(const Prefix: string): string;
    function TableExists(const ATable: string): Boolean;
    function ColumnExists(const ATable, AColumn: string): Boolean;
    function ScalarInt(const ASQL: string; const ADefault: Integer = 0): Integer;
    function FirstExistingColumn(const ATable: string; const Candidates: array of string): string;
    procedure AddEngineRows;
    procedure RevisarTablasClave;
    procedure RevisarArticulos;
    procedure RevisarEANs;
    procedure RevisarClientes;
    procedure RevisarProveedores;
    procedure RevisarPromociones;
    procedure RevisarComprasVentas;
    procedure RevisarVeriFactuExtra;
    procedure RevisarClick(Sender: TObject);
    procedure CSVClick(Sender: TObject);
    procedure DetalleClick(Sender: TObject);
    procedure NormalizarNIFClick(Sender: TObject);
    procedure CerrarClick(Sender: TObject);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridDblClick(Sender: TObject);
    procedure MostrarDetalleSQL;
    procedure GridDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
    procedure RevisarDoctorCompleto;
    procedure ActualizarResumen;
  public
    constructor CreateDoctor(AOwner: TComponent; AConnection: TZConnection; const ATienda: string); reintroduce;
  end;


procedure TDoctorDetalleSQLForm.CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
begin
  FLXSetBitBtnIcon(ABtn, AIcon, ASize);
end;

constructor TDoctorDetalleSQLForm.CreateDetalle(AOwner: TComponent; AConnection: TZConnection; const ATitulo, ASQL: string);
var
  Header, ActionPanel: TPanel;
  BCSV, BCerrar: TBitBtn;
  Logo: TImage;
  Pic: TPicture;
  FN: string;
  L: TLabel;
begin
  inherited CreateNew(AOwner, 1);
  FConn := AConnection;
  FSQL := ASQL;
  FSortCol := -1;
  FSortDesc := False;

  Caption := ATitulo;
  Position := poScreenCenter;
  WindowState := wsMaximized;
  Color := RGBToColor(245,248,252);

  Header := TPanel.Create(Self);
  Header.Parent := Self;
  Header.Align := alTop;
  Header.Height := 96;
  Header.BevelOuter := bvNone;
  Header.Color := RGBToColor(248,251,255);

  Logo := TImage.Create(Self);
  Logo.Parent := Header;
  Logo.Left := 22;
  Logo.Top := 16;
  Logo.Width := 56;
  Logo.Height := 56;
  Logo.Stretch := True;
  FN := FLXIconFile('doctor', 64);
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

  L := TLabel.Create(Self);
  L.Parent := Header;
  L.Left := 96;
  L.Top := 22;
  L.Caption := ATitulo;
  L.Font.Size := 18;
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,32,80);

  L := TLabel.Create(Self);
  L.Parent := Header;
  L.Left := 98;
  L.Top := 56;
  L.Caption := 'Detalle SQL en modo consulta. No ejecuta reparaciones.';
  L.Font.Color := RGBToColor(45,70,105);

  ActionPanel := TPanel.Create(Self);
  ActionPanel.Parent := Header;
  ActionPanel.Align := alRight;
  ActionPanel.Width := 290;
  ActionPanel.BevelOuter := bvNone;
  ActionPanel.Color := Header.Color;

  BCSV := TBitBtn.Create(Self);
  BCSV.Parent := ActionPanel;
  BCSV.Left := 8;
  BCSV.Top := 12;
  BCSV.Width := 128;
  BCSV.Height := 60;
  BCSV.Caption := 'Exportar';
  BCSV.Layout := blGlyphTop;
  BCSV.Font.Style := [fsBold];
  CargarIconoBoton(BCSV, 'tend_exportar', 30);
  BCSV.OnClick := @ExportarCSV;

  BCerrar := TBitBtn.Create(Self);
  BCerrar.Parent := ActionPanel;
  BCerrar.Left := 146;
  BCerrar.Top := 12;
  BCerrar.Width := 128;
  BCerrar.Height := 60;
  BCerrar.Caption := 'Cerrar';
  BCerrar.Layout := blGlyphTop;
  BCerrar.Font.Style := [fsBold];
  CargarIconoBoton(BCerrar, 'tend_cerrar', 30);
  BCerrar.OnClick := @Cerrar;

  MemoSQL := TMemo.Create(Self);
  MemoSQL.Parent := Self;
  MemoSQL.Align := alTop;
  MemoSQL.Height := 96;
  MemoSQL.ReadOnly := True;
  MemoSQL.ScrollBars := ssVertical;
  MemoSQL.Color := RGBToColor(250,252,255);
  MemoSQL.Lines.Text := FSQL;

  GridDetalle := TStringGrid.Create(Self);
  GridDetalle.Parent := Self;
  GridDetalle.Align := alClient;
  GridDetalle.Options := GridDetalle.Options + [goRowSelect, goColSizing, goThumbTracking];
  GridDetalle.OnMouseDown := @GridDetalleMouseDown;
  GridDetalle.OnDrawCell := @GridDetalleDrawCell;
  FLXGridPreparar(GridDetalle);

  CargarDatos;
end;

procedure TDoctorDetalleSQLForm.CargarDatos;
var
  Q: TZQuery;
  R, C, W: Integer;
begin
  GridDetalle.ColCount := 1;
  GridDetalle.RowCount := 1;
  GridDetalle.Cells[0,0] := 'Resultado';
  if Trim(FSQL) = '' then Exit;

  Q := TZQuery.Create(Self);
  try
    Q.Connection := FConn;
    Q.SQL.Text := FSQL;
    Q.Open;
    GridDetalle.ColCount := Q.FieldCount;
    GridDetalle.RowCount := 1;
    GridDetalle.FixedRows := 1;
    for C := 0 to Q.FieldCount - 1 do
    begin
      GridDetalle.Cells[C,0] := Q.Fields[C].FieldName;
      W := Length(Q.Fields[C].FieldName) * 9 + 35;
      if W < 90 then W := 90;
      if W > 380 then W := 380;
      GridDetalle.ColWidths[C] := W;
    end;
    R := 1;
    while not Q.EOF do
    begin
      GridDetalle.RowCount := R + 1;
      for C := 0 to Q.FieldCount - 1 do
      begin
        GridDetalle.Cells[C,R] := Q.Fields[C].AsString;
        W := Length(GridDetalle.Cells[C,R]) * 8 + 25;
        if W > GridDetalle.ColWidths[C] then
        begin
          if W > 520 then W := 520;
          GridDetalle.ColWidths[C] := W;
        end;
      end;
      Inc(R);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TDoctorDetalleSQLForm.GridDetalleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  GridDetalle.MouseToCell(X, Y, ACol, ARow);
  if (ARow = 0) and (ACol >= 0) then
    FLXGridOrdenar(GridDetalle, ACol, FSortCol, FSortDesc);
end;

procedure TDoctorDetalleSQLForm.GridDetalleDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  FLXGridPrepararCanvasSeleccion(GridDetalle, aRow, aState);
  if gdFixed in aState then
  begin
    GridDetalle.Canvas.Font.Style := [fsBold];
    GridDetalle.Canvas.Font.Color := RGBToColor(0,32,80);
  end
  else
    GridDetalle.Canvas.Font.Style := [];
  GridDetalle.Canvas.FillRect(aRect);
  GridDetalle.Canvas.TextRect(aRect, aRect.Left + 5, aRect.Top + 3, GridDetalle.Cells[aCol,aRow]);
end;

procedure TDoctorDetalleSQLForm.ExportarCSV(Sender: TObject);
var
  SD: TSaveDialog;
  SL: TStringList;
  R, C: Integer;
  Line: string;
begin
  SD := TSaveDialog.Create(Self);
  SL := TStringList.Create;
  try
    SD.Filter := 'CSV|*.csv';
    SD.DefaultExt := 'csv';
    SD.FileName := 'doctor_detalle.csv';
    if not SD.Execute then Exit;
    SL.Add('"CONSULTA"');
    SL.Add('"' + StringReplace(FSQL, '"', '""', [rfReplaceAll]) + '"');
    SL.Add('');
    for R := 0 to GridDetalle.RowCount - 1 do
    begin
      Line := '';
      for C := 0 to GridDetalle.ColCount - 1 do
      begin
        if C > 0 then Line := Line + ';';
        Line := Line + '"' + StringReplace(GridDetalle.Cells[C,R], '"', '""', [rfReplaceAll]) + '"';
      end;
      SL.Add(Line);
    end;
    SL.SaveToFile(SD.FileName);
  finally
    SL.Free;
    SD.Free;
  end;
end;

procedure TDoctorDetalleSQLForm.Cerrar(Sender: TObject);
begin
  Close;
end;

procedure TDoctorFacturLinExForm.CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
begin
  FLXSetBitBtnIcon(ABtn, AIcon, ASize);
end;

procedure TDoctorFacturLinExForm.CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AWidth: Integer);
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

procedure TDoctorFacturLinExForm.CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
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

function TDoctorFacturLinExForm.SaludEstimada: Integer;
begin
  Result := 100 - (FAlta * 12) - (FMedia * 6) - (FAviso * 3) - FBaja;
  if Result < 0 then Result := 0;
  if Result > 100 then Result := 100;
end;

procedure TDoctorFacturLinExForm.AplicarEstiloGrid;
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

procedure TDoctorFacturLinExForm.AjustarColumnas;
var
  Disponible: Integer;
begin
  if Grid.ColCount < 6 then Exit;
  Grid.ColWidths[0] := 95;
  Grid.ColWidths[1] := 135;
  Grid.ColWidths[2] := 310;
  Grid.ColWidths[4] := 380;
  Grid.ColWidths[5] := 0;
  Disponible := Grid.ClientWidth - (Grid.ColWidths[0] + Grid.ColWidths[1] + Grid.ColWidths[2] + Grid.ColWidths[4] + 62);
  if Disponible < 360 then Disponible := 360;
  Grid.ColWidths[3] := Disponible;
end;

constructor TDoctorFacturLinExForm.CreateDoctor(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  Logo: TImage;
  Pic: TPicture;
  FN: string;
  L: TLabel;
begin
  inherited CreateNew(AOwner, 1);
  FConn := AConnection;
  FTienda := ATienda;
  FLastSortCol := -1;
  FSortDesc := False;

  Caption := 'FacturLinEx - Doctor';
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
  FN := FLXIconFile('doctor', 64);
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
  LblTitulo.Caption := 'Doctor FacturLinEx';
  LblTitulo.Font.Size := 24;
  LblTitulo.Font.Style := [fsBold];
  LblTitulo.Font.Color := RGBToColor(0,32,80);

  LblSubtitulo := TLabel.Create(Self);
  LblSubtitulo.Parent := HeaderPanel;
  LblSubtitulo.Left := 114;
  LblSubtitulo.Top := 68;
  LblSubtitulo.Caption := 'Revisión guiada de datos, coherencia interna, EAN, clientes, compras y VeriFactu';
  LblSubtitulo.Font.Size := 11;
  LblSubtitulo.Font.Color := RGBToColor(45,70,105);

  ActionPanel := TPanel.Create(Self);
  ActionPanel.Parent := HeaderPanel;
  ActionPanel.Align := alRight;
  ActionPanel.Width := 760;
  ActionPanel.BevelOuter := bvNone;
  ActionPanel.Color := HeaderPanel.Color;

  CrearBotonAccion(ActionPanel, BtnRevisar, 'Revisar', 'tend_actualizar', 8, 118);
  BtnRevisar.OnClick := @RevisarClick;
  CrearBotonAccion(ActionPanel, BtnDetalle, 'Ver detalle', 'doctor', 134, 128);
  BtnDetalle.OnClick := @DetalleClick;
  CrearBotonAccion(ActionPanel, BtnCSV, 'Exportar', 'tend_exportar', 270, 118);
  BtnCSV.OnClick := @CSVClick;
  CrearBotonAccion(ActionPanel, BtnNormalizarNIF, 'Normalizar NIF', 'tend_clientes', 396, 142);
  BtnNormalizarNIF.OnClick := @NormalizarNIFClick;
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
  L.Top := 58;
  L.Width := 205;
  L.Height := 210;
  L.WordWrap := True;
  L.Caption := 'El Doctor revisa puntos delicados de FacturLinEx y muestra acciones recomendadas. Doble clic sobre una línea con SQL para ver el detalle. No ejecuta reparaciones salvo la normalización NIF, que mantiene confirmación explícita.';
  L.Font.Color := RGBToColor(45,70,105);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 300;
  L.Caption := 'Prioridades';
  L.Font.Size := 12;
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(0,65,145);

  L := TLabel.Create(Self);
  L.Parent := InfoPanel;
  L.Left := 18;
  L.Top := 338;
  L.Width := 205;
  L.Height := 190;
  L.WordWrap := True;
  L.Caption := 'ALTA: conviene revisar pronto.' + LineEnding +
               'MEDIA: revisar cuando sea posible.' + LineEnding +
               'AVISO/BAJA: información preventiva.' + LineEnding +
               'OK: comprobación correcta.';
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
  LblVistaActual.Caption := 'Revisión del sistema';
  LblVistaActual.Font.Size := 12;
  LblVistaActual.Font.Style := [fsBold];
  LblVistaActual.Font.Color := RGBToColor(0,65,145);

  LblSubtituloVista := TLabel.Create(Self);
  LblSubtituloVista.Parent := TitlePanel;
  LblSubtituloVista.Left := 16;
  LblSubtituloVista.Top := 38;
  LblSubtituloVista.Caption := 'Pulse Revisar para ejecutar el diagnóstico. Use doble clic para abrir detalle SQL cuando exista.';
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
  Grid.OnDblClick := @GridDblClick;
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
  Memo.Lines.Text := 'Doctor FacturLinEx listo. Pulse Revisar para iniciar el diagnóstico.' + LineEnding +
                     'Se mantiene la lógica anterior y se actualiza la pantalla a la línea visual de Predicciones v1.' + LineEnding +
                     'La normalización NIF sigue protegida por previsualización y confirmación.';
end;

procedure TDoctorFacturLinExForm.InitGrid;
begin
  Grid.ColCount := 6;
  Grid.FixedRows := 1;
  Grid.RowCount := 1;
  Grid.Cells[0,0] := 'Prioridad';
  Grid.Cells[1,0] := 'Área';
  Grid.Cells[2,0] := 'Revisión';
  Grid.Cells[3,0] := 'Detalle';
  Grid.Cells[4,0] := 'Acción recomendada';
  Grid.Cells[5,0] := 'SQL detalle';
  AjustarColumnas;
end;

procedure TDoctorFacturLinExForm.IncPrioridad(const Prioridad: string);
var
  S: string;
begin
  S := UpperCase(Prioridad);
  if S = 'ALTA' then Inc(FAlta)
  else if S = 'MEDIA' then Inc(FMedia)
  else if S = 'AVISO' then Inc(FAviso)
  else if S = 'BAJA' then Inc(FBaja)
  else if S = 'OK' then Inc(FOK);
end;

procedure TDoctorFacturLinExForm.AddRow(const Prioridad, Area, Revision, Detalle, Accion: string);
begin
  AddRowSQL(Prioridad, Area, Revision, Detalle, Accion, '');
end;

procedure TDoctorFacturLinExForm.AddRowSQL(const Prioridad, Area, Revision, Detalle, Accion, ASQLDetalle: string);
var
  R: Integer;
begin
  R := Grid.RowCount;
  Grid.RowCount := R + 1;
  Grid.Cells[0,R] := Prioridad;
  Grid.Cells[1,R] := Area;
  Grid.Cells[2,R] := Revision;
  Grid.Cells[3,R] := Detalle;
  Grid.Cells[4,R] := Accion;
  Grid.Cells[5,R] := ASQLDetalle;
  IncPrioridad(Prioridad);
end;

function TDoctorFacturLinExForm.CleanIdent(const S: string): string;
begin
  Result := StringReplace(S, '`', '', [rfReplaceAll]);
end;

function TDoctorFacturLinExForm.SQLIdent(const S: string): string;
begin
  Result := '`' + CleanIdent(S) + '`';
end;

function TDoctorFacturLinExForm.DBName: string;
begin
  Result := '';
  if Assigned(FConn) then Result := FConn.Database;
end;

function TDoctorFacturLinExForm.TableName(const Prefix: string): string;
begin
  Result := Prefix + FTienda;
end;

function TDoctorFacturLinExForm.TableExists(const ATable: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (not Assigned(FConn)) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=:DB AND TABLE_NAME=:T';
    Q.ParamByName('DB').AsString := DBName;
    Q.ParamByName('T').AsString := CleanIdent(ATable);
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TDoctorFacturLinExForm.ColumnExists(const ATable, AColumn: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (not Assigned(FConn)) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=:DB AND TABLE_NAME=:T AND COLUMN_NAME=:C';
    Q.ParamByName('DB').AsString := DBName;
    Q.ParamByName('T').AsString := CleanIdent(ATable);
    Q.ParamByName('C').AsString := CleanIdent(AColumn);
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TDoctorFacturLinExForm.ScalarInt(const ASQL: string; const ADefault: Integer): Integer;
var
  Q: TZQuery;
begin
  Result := ADefault;
  if (not Assigned(FConn)) or (not FConn.Connected) then Exit;
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

function TDoctorFacturLinExForm.FirstExistingColumn(const ATable: string; const Candidates: array of string): string;
var
  I: Integer;
begin
  Result := '';
  for I := Low(Candidates) to High(Candidates) do
    if ColumnExists(ATable, Candidates[I]) then
      Exit(Candidates[I]);
end;

procedure TDoctorFacturLinExForm.AddEngineRows;
var
  Engine: TFLXIntelligenceEngine;
  I: Integer;
  It: TFLXIntelItem;
  SOrigen, STexto: string;
begin
  Engine := TFLXIntelligenceEngine.Create(FConn, FTienda);
  try
    Engine.Clear;
    Engine.RevisarMantenimiento;
    Engine.RevisarDoctor;
    Engine.RevisarVeriFactu;
    for I := 0 to Engine.Results.Count - 1 do
    begin
      It := Engine.Results[I];

      { Evita duplicar incidencias que el Doctor ya vuelve a calcular debajo
        con SQL de detalle propio (doble clic). El Engine queda como chequeo
        comun, pero el Doctor debe mostrar una sola linea util por problema. }
      SOrigen := LowerCase(It.Origen);
      STexto := LowerCase(It.Resumen + ' ' + It.Detalle);
      if (SOrigen = 'doctor') and
         ((Pos('sin familia', STexto) > 0) or (Pos('sin proveedor', STexto) > 0)) then
        Continue;

      AddRow(It.PrioridadTexto, It.Origen + ' / Engine', It.Resumen, It.Detalle, It.Accion);
    end;
  finally
    Engine.Free;
  end;
end;

procedure TDoctorFacturLinExForm.RevisarTablasClave;
const
  Nombres: array[0..12] of string = ('artitien','clientes','proveedores','familias','promo','promo_pack_items','promo_rules','hisopcc','hisopdd','hipedicc','hipedidd','ultimopedi','verifactu_queue');
var
  I: Integer;
  T: string;
begin
  for I := Low(Nombres) to High(Nombres) do
  begin
    if (Nombres[I] = 'clientes') or (Nombres[I] = 'proveedores') or (Nombres[I] = 'verifactu_queue') then
      T := Nombres[I]
    else
      T := TableName(Nombres[I]);
    if TableExists(T) then
      AddRow('OK', 'BBDD', 'Tabla localizada', T + ' existe.', 'Sin accion')
    else
      AddRow('AVISO', 'BBDD', 'Tabla no localizada', T + ' no existe o no corresponde a esta instalacion.', 'Revisar solo si el modulo debe estar activo');
  end;
end;

procedure TDoctorFacturLinExForm.RevisarArticulos;
var
  TArt, TFam: string;
  N: Integer;
  CDesc: string;
begin
  TArt := TableName('artitien');
  TFam := TableName('familias');
  if not TableExists(TArt) then Exit;

  if ColumnExists(TArt, 'A32') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TArt) + ' WHERE IFNULL(A32,0)=0');
    if N > 0 then AddRowSQL('MEDIA', 'Articulos', IntToStr(N) + ' articulos sin proveedor en ficha', 'Campo artitien.A32 = 0. El problema esta en la ficha del articulo, no en ventas.', 'Doble clic para ver articulos afectados', 'SELECT a.A0 AS COD_ARTICULO, a.A1 AS DESCRIPCION, a.A32 AS PROV_FICHA_A32, a.A2 AS PVP_CON_IVA, a.A21 AS PVP_SIN_IVA, a.A24 AS COSTE_APROX FROM ' + SQLIdent(TArt) + ' a WHERE IFNULL(a.A32,0)=0 ORDER BY a.A0 LIMIT 1000')
    else AddRow('OK', 'Articulos', 'Proveedor habitual informado', 'No se detectan articulos con A32 = 0.', 'Sin accion');

    if TableExists('proveedores') and ColumnExists('proveedores', 'P0') then
    begin
      N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TArt) + ' a LEFT JOIN proveedores p ON p.P0=a.A32 WHERE IFNULL(a.A32,0)<>0 AND p.P0 IS NULL');
      if N > 0 then AddRowSQL('ALTA', 'Articulos', IntToStr(N) + ' articulos con proveedor inexistente', 'artitien.A32 apunta a un proveedor que no existe en proveedores.P0. El error esta en la ficha del articulo.', 'Doble clic para ver articulos y proveedor informado', 'SELECT a.A0 AS COD_ARTICULO, a.A1 AS DESCRIPCION, a.A32 AS PROV_FICHA_A32, p.P1 AS NOMBRE_PROVEEDOR, a.A2 AS PVP_CON_IVA, a.A24 AS COSTE_APROX FROM ' + SQLIdent(TArt) + ' a LEFT JOIN proveedores p ON p.P0=a.A32 WHERE IFNULL(a.A32,0)<>0 AND p.P0 IS NULL ORDER BY a.A32,a.A0 LIMIT 1000')
      else AddRow('OK', 'Articulos', 'Proveedores de ficha coherentes', 'artitien.A32 coincide con proveedores.P0 en los articulos revisados.', 'Sin accion');
    end;
  end;

  if ColumnExists(TArt, 'A14') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TArt) + ' WHERE IFNULL(A14,0)=0');
    if N > 0 then AddRowSQL('BAJA', 'Articulos', IntToStr(N) + ' articulos sin familia en ficha', 'Campo artitien.A14 = 0. Desde ventas no deberia cambiarse; si aparece tras compras, revisar aceptacion de pedidos.', 'Doble clic para ver articulos afectados', 'SELECT a.A0 AS COD_ARTICULO, a.A1 AS DESCRIPCION, a.A14 AS FAMILIA_A14, a.A32 AS PROV_FICHA_A32 FROM ' + SQLIdent(TArt) + ' a WHERE IFNULL(a.A14,0)=0 ORDER BY a.A0 LIMIT 1000');
    if TableExists(TFam) and ColumnExists(TFam, 'F0') then
    begin
      N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TArt) + ' a LEFT JOIN ' + SQLIdent(TFam) + ' f ON f.F0=a.A14 WHERE IFNULL(a.A14,0)<>0 AND f.F0 IS NULL');
      if N > 0 then AddRowSQL('MEDIA', 'Articulos', IntToStr(N) + ' articulos con familia inexistente', 'artitien.A14 apunta a una familia no localizada en familias.F0.', 'Doble clic para ver articulos afectados', 'SELECT a.A0 AS COD_ARTICULO, a.A1 AS DESCRIPCION, a.A14 AS FAMILIA_A14, f.F1 AS NOMBRE_FAMILIA FROM ' + SQLIdent(TArt) + ' a LEFT JOIN ' + SQLIdent(TFam) + ' f ON f.F0=a.A14 WHERE IFNULL(a.A14,0)<>0 AND f.F0 IS NULL ORDER BY a.A14,a.A0 LIMIT 1000')
      else AddRow('OK', 'Articulos', 'Familias coherentes', 'Las familias informadas existen.', 'Sin accion');
    end;
  end;

  if ColumnExists(TArt, 'A4') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TArt) + ' WHERE TRIM(COALESCE(CAST(A4 AS CHAR),''''))=''''');
    if N > 0 then
      AddRowSQL('AVISO', 'Articulos', 'Comprobacion A4: ' + IntToStr(N) + ' articulos con A4 vacio',
        'Campo revisado: artitien.A4. Esta comprobacion es independiente de la familia A14.',
        'Doble clic para ver articulos con A4 vacio',
        'SELECT a.A0 AS COD_ARTICULO, a.A1 AS DESCRIPCION, a.A4 AS A4_REVISADO, a.A2 AS PVP_CON_IVA, a.A21 AS PVP_SIN_IVA, a.A24 AS COSTE_APROX, a.A14 AS FAMILIA_A14, a.A32 AS PROV_FICHA_A32 FROM ' + SQLIdent(TArt) + ' a WHERE TRIM(COALESCE(CAST(a.A4 AS CHAR),''''))='''' ORDER BY a.A0 LIMIT 1000')
    else
      AddRow('OK', 'Articulos', 'Comprobacion A4: informado', 'Campo revisado: artitien.A4. No se detectan articulos con A4 vacio.', 'Sin accion');
  end
  else
    AddRow('AVISO', 'Articulos', 'Comprobacion A4: columna no localizada', 'No existe el campo artitien.A4 en esta instalacion/tienda.', 'Sin accion');

  { En FacturLinEx los EAN auxiliares/packs viven en la tabla eans.
    No se revisa A1/A2/A5 como EAN porque son descripcion/precios/costes.
    A4 se revisa aparte como stock/existencia para que tenga detalle SQL. }
  AddRow('OK', 'Articulos', 'EAN revisados en tabla eans', 'El Doctor no usa campos de artitien como EAN. Los codigos auxiliares se revisan en el bloque EAN.', 'Sin accion');

  CDesc := FirstExistingColumn(TArt, ['A1','DESCRIPCION','DESCRIP']);
  if CDesc <> '' then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TArt) + ' WHERE ' + CDesc + ' LIKE ''%''''%'' OR ' + CDesc + ' LIKE ''%"%''');
    if N > 0 then AddRowSQL('AVISO', 'Articulos', IntToStr(N) + ' descripciones con comillas', 'Campo revisado: ' + CDesc + '. Puede afectar a consultas antiguas no parametrizadas.', 'Doble clic para ver articulos afectados', 'SELECT A0 AS COD_ARTICULO, A1 AS DESCRIPCION FROM ' + SQLIdent(TArt) + ' WHERE ' + CDesc + ' LIKE ''%''''%'' OR ' + CDesc + ' LIKE ''%"%'' ORDER BY A0 LIMIT 1000')
    else AddRow('OK', 'Articulos', 'Descripciones sin comillas detectadas', 'Campo revisado: ' + CDesc + '.', 'Sin accion');
  end;
end;


procedure TDoctorFacturLinExForm.RevisarEANs;
var
  TArt, SQLDet: string;
  N: Integer;
begin
  TArt := TableName('artitien');
  if not TableExists('eans') then
  begin
    AddRow('AVISO', 'EAN', 'Tabla eans no localizada', 'No se ha encontrado la tabla eans. Si esta instalacion no usa codigos auxiliares, puede ignorarse.', 'Revisar solo si se usan EAN auxiliares o packs');
    Exit;
  end;

  if not (ColumnExists('eans','EAN0') and ColumnExists('eans','EAN1')) then
  begin
    AddRow('ALTA', 'EAN', 'Estructura de eans incompleta', 'No se localizan EAN0/EAN1 en la tabla eans.', 'Revisar estructura de tabla eans');
    Exit;
  end;

  SQLDet := 'SELECT e.EAN0 AS EAN_LEIDO, e.EAN1 AS COD_ARTICULO_EAN1, IFNULL(a.A1,''<ARTICULO NO EXISTE>'') AS DESCRIPCION_ARTICULO, e.EAN2 AS DESCRIPCION_EAN, e.EAN3 AS CANTIDAD_EQUIVALENTE, e.EAN4, e.EAN5, d.ARTICULOS AS NUM_ARTICULOS_DISTINTOS, d.CODIGOS_ARTICULO AS CODIGOS_AFECTADOS FROM eans e INNER JOIN (SELECT EAN0, COUNT(DISTINCT EAN1) AS ARTICULOS, GROUP_CONCAT(DISTINCT EAN1 ORDER BY EAN1 SEPARATOR '', '') AS CODIGOS_ARTICULO FROM eans WHERE IFNULL(EAN0,'''')<>'''' GROUP BY EAN0 HAVING COUNT(DISTINCT EAN1)>1) d ON d.EAN0=e.EAN0 LEFT JOIN ' + SQLIdent(TArt) + ' a ON a.A0=e.EAN1 ORDER BY e.EAN0,e.EAN1 LIMIT 1000';
  N := ScalarInt('SELECT COUNT(*) FROM (SELECT EAN0 FROM eans WHERE IFNULL(EAN0,'''')<>'''' GROUP BY EAN0 HAVING COUNT(DISTINCT EAN1)>1) X');
  if N > 0 then
    AddRowSQL('ALTA', 'EAN', IntToStr(N) + ' EAN0 vinculados a varios articulos', 'El error esta en eans: el mismo codigo leido EAN0 apunta a mas de un articulo EAN1. El detalle muestra todas las lineas implicadas para comprobarlo.', 'Doble clic para ver EAN, articulos y descripciones', SQLDet)
  else
    AddRow('OK', 'EAN', 'Sin EAN0 vinculados a varios articulos', 'No se detectan EAN0 asociados a distintos EAN1.', 'Sin accion');

  SQLDet := 'SELECT e.EAN0 AS EAN_LEIDO, e.EAN1 AS COD_ARTICULO_EAN1, e.EAN2 AS DESCRIPCION_EAN, e.EAN3 AS CANTIDAD_EQUIVALENTE, CASE WHEN IFNULL(e.EAN0,'''')='''' THEN ''Falta EAN0/codigo leido'' ELSE '''' END AS ERROR_EAN0, CASE WHEN IFNULL(e.EAN1,'''')='''' THEN ''Falta EAN1/codigo articulo'' ELSE '''' END AS ERROR_EAN1 FROM eans e WHERE IFNULL(e.EAN0,'''')='''' OR IFNULL(e.EAN1,'''')='''' ORDER BY e.EAN0,e.EAN1 LIMIT 1000';
  N := ScalarInt('SELECT COUNT(*) FROM eans WHERE IFNULL(EAN0,'''')='''' OR IFNULL(EAN1,'''')=''''');
  if N > 0 then
    AddRowSQL('ALTA', 'EAN', IntToStr(N) + ' registros eans incompletos', 'El error esta en eans: EAN0 es el codigo leido y EAN1 es el codigo principal del articulo. Alguno esta vacio.', 'Doble clic para ver registros incompletos', SQLDet);

  if TableExists(TArt) and ColumnExists(TArt, 'A0') then
  begin
    SQLDet := 'SELECT e.EAN0 AS EAN_LEIDO, e.EAN1 AS COD_ARTICULO_EAN1, e.EAN2 AS DESCRIPCION_EAN, e.EAN3 AS CANTIDAD_EQUIVALENTE, ''EAN1 no existe en ' + TArt + '.A0'' AS ERROR FROM eans e LEFT JOIN ' + SQLIdent(TArt) + ' a ON a.A0=e.EAN1 WHERE IFNULL(e.EAN1,'''')<>'''' AND a.A0 IS NULL ORDER BY e.EAN1,e.EAN0 LIMIT 1000';
    N := ScalarInt('SELECT COUNT(*) FROM eans e LEFT JOIN ' + SQLIdent(TArt) + ' a ON a.A0=e.EAN1 WHERE IFNULL(e.EAN1,'''')<>'''' AND a.A0 IS NULL');
    if N > 0 then
      AddRowSQL('ALTA', 'EAN', IntToStr(N) + ' EAN con articulo principal inexistente', 'El error esta en eans: EAN1 debe enlazar con ' + TArt + '.A0, pero ese articulo no existe.', 'Doble clic para ver que EAN apunta a que articulo inexistente', SQLDet)
    else
      AddRow('OK', 'EAN', 'Todos los EAN apuntan a articulos existentes', 'EAN1 existe en ' + TArt + '.A0.', 'Sin accion');
  end;

  if ColumnExists('eans','EAN3') then
  begin
    SQLDet := 'SELECT e.EAN0 AS EAN_LEIDO, e.EAN1 AS COD_ARTICULO_EAN1, IFNULL(a.A1,''<ARTICULO NO EXISTE>'') AS DESCRIPCION_ARTICULO, e.EAN2 AS DESCRIPCION_EAN, e.EAN3 AS CANTIDAD_EQUIVALENTE, CASE WHEN IFNULL(e.EAN3,0)<=0 THEN ''Cantidad equivalente debe ser mayor que 0'' ELSE '''' END AS ERROR FROM eans e LEFT JOIN ' + SQLIdent(TArt) + ' a ON a.A0=e.EAN1 WHERE IFNULL(e.EAN3,0)<=0 ORDER BY e.EAN0,e.EAN1 LIMIT 1000';
    N := ScalarInt('SELECT COUNT(*) FROM eans WHERE IFNULL(EAN3,0)<=0');
    if N > 0 then
      AddRowSQL('MEDIA', 'EAN', IntToStr(N) + ' EAN con cantidad equivalente cero o negativa', 'El error esta en eans.EAN3. Para codigo auxiliar normal deberia ser 1; para pack, la cantidad del pack.', 'Doble clic para ver registros afectados', SQLDet)
    else
      AddRow('OK', 'EAN', 'Cantidades equivalentes correctas', 'No se detectan EAN3 <= 0.', 'Sin accion');
  end;

  SQLDet := 'SELECT e.EAN0 AS EAN_LEIDO, e.EAN1 AS COD_ARTICULO_EAN1, IFNULL(a.A1,''<ARTICULO NO EXISTE>'') AS DESCRIPCION_ARTICULO, e.EAN2 AS DESCRIPCION_EAN, e.EAN3 AS CANTIDAD_EQUIVALENTE FROM eans e LEFT JOIN ' + SQLIdent(TArt) + ' a ON a.A0=e.EAN1 WHERE e.EAN0=e.EAN1 ORDER BY e.EAN0 LIMIT 1000';
  N := ScalarInt('SELECT COUNT(*) FROM eans WHERE EAN0=EAN1');
  if N > 0 then
    AddRowSQL('BAJA', 'EAN', IntToStr(N) + ' EAN0 iguales al codigo principal EAN1', 'Informativo: puede ser redundante, pero no siempre es error si el codigo principal del articulo tambien es un EAN.', 'Doble clic para revisar si procede', SQLDet);

  { Solo se valida la longitud de EAN0. EAN1 es el codigo principal del articulo, no el EAN leido. }
  SQLDet := 'SELECT e.EAN0 AS EAN_LEIDO, e.EAN1 AS COD_ARTICULO_EAN1, IFNULL(a.A1,''<ARTICULO NO EXISTE>'') AS DESCRIPCION_ARTICULO, e.EAN2 AS DESCRIPCION_EAN, e.EAN3 AS CANTIDAD_EQUIVALENTE, CHAR_LENGTH(TRIM(e.EAN0)) AS LONGITUD_EAN0 FROM eans e LEFT JOIN ' + SQLIdent(TArt) + ' a ON a.A0=e.EAN1 WHERE CHAR_LENGTH(TRIM(e.EAN0))<>13 ORDER BY e.EAN0,e.EAN1 LIMIT 1000';
  N := ScalarInt('SELECT COUNT(*) FROM eans WHERE CHAR_LENGTH(TRIM(EAN0))<>13');
  if N > 0 then
    AddRowSQL('AVISO', 'EAN', IntToStr(N) + ' EAN0 con longitud distinta de 13', 'Informativo: EAN0 es el codigo leido/auxiliar. EAN1 no se valida como EAN de 13 digitos porque es el codigo del articulo.', 'Doble clic para revisar codigos auxiliares no EAN13', SQLDet);
end;

procedure TDoctorFacturLinExForm.RevisarClientes;
var
  CNif, CNombre: string;
  N: Integer;
begin
  if not TableExists('clientes') then Exit;
  { En FacturLinEx el NIF/CIF real de clientes es C5.
    No usar busqueda automatica porque puede confundir poblacion u otros campos. }
  if ColumnExists('clientes', 'C5') then
    CNif := 'C5'
  else
    CNif := '';

  if CNif <> '' then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM clientes WHERE TRIM(IFNULL(C5,''''))<>'''' AND C5<>UPPER(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(C5),'' '', ''''),''-'',''''),''_'',''''),''.'',''''))');
    if N > 0 then AddRowSQL('AVISO', 'Clientes', IntToStr(N) + ' NIF/CIF con formato no normalizado', 'Hay NIF/CIF con espacios, guiones, subguiones, puntos o minusculas. El campo correcto es clientes.C5. Esta revision no cambia la letra ni corrige NIF invalidos; solo normaliza formato.', 'Boton Normalizar NIF o doble clic para previsualizar', 'SELECT C0 AS COD_CLIENTE, C1 AS NOMBRE_CLIENTE, C5 AS NIF_ACTUAL, UPPER(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(C5),'' '', ''''),''-'',''''),''_'',''''),''.'','''')) AS NIF_NORMALIZADO FROM clientes WHERE TRIM(IFNULL(C5,''''))<>'''' AND C5<>UPPER(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(C5),'' '', ''''),''-'',''''),''_'',''''),''.'','''')) ORDER BY C0 LIMIT 1000');

    N := ScalarInt('SELECT COUNT(*) FROM clientes WHERE TRIM(IFNULL(C5,''''))<>'''' AND UPPER(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(C5),'' '', ''''),''-'',''''),''_'',''''),''.'','''')) NOT REGEXP ''^([0-9]{8}[A-Z]|[XYZ][0-9]{7}[A-Z]|[ABCDEFGHJKLMNPQRSUVW][0-9]{7}[0-9A-J])$''');
    if N > 0 then AddRowSQL('MEDIA', 'Clientes', IntToStr(N) + ' NIF/CIF con formato legal no reconocido', 'El Doctor normaliza C5 para revisar formato. No corrige letras de control; solo avisa si el resultado no parece DNI, NIE o CIF/NIF de entidad.', 'Doble clic para revisar clientes afectados', 'SELECT C0 AS COD_CLIENTE, C1 AS NOMBRE_CLIENTE, C5 AS NIF_ACTUAL, UPPER(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(C5),'' '', ''''),''-'',''''),''_'',''''),''.'','''')) AS NIF_NORMALIZADO_REVISADO FROM clientes WHERE TRIM(IFNULL(C5,''''))<>'''' AND UPPER(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(C5),'' '', ''''),''-'',''''),''_'',''''),''.'','''')) NOT REGEXP ''^([0-9]{8}[A-Z]|[XYZ][0-9]{7}[A-Z]|[ABCDEFGHJKLMNPQRSUVW][0-9]{7}[0-9A-J])$'' ORDER BY C0 LIMIT 1000');

    N := ScalarInt('SELECT COUNT(*) FROM clientes WHERE TRIM(IFNULL(' + CNif + ',''''))=''''');
    if N > 0 then AddRowSQL('BAJA', 'Clientes', IntToStr(N) + ' clientes sin NIF/CIF', 'Campo revisado: clientes.' + CNif + ' (NIF/CIF real). El detalle muestra los clientes afectados para poder revisarlos.', 'Doble clic para ver clientes sin NIF/CIF', 'SELECT C0 AS COD_CLIENTE, C1 AS NOMBRE_CLIENTE, ' + CNif + ' AS NIF_CIF_REVISADO FROM clientes WHERE TRIM(IFNULL(' + CNif + ',''''))='''' ORDER BY C0 LIMIT 1000');
    N := ScalarInt('SELECT COUNT(*) FROM (SELECT UPPER(TRIM(' + CNif + ')) AS NIF_NORMALIZADO FROM clientes WHERE TRIM(IFNULL(' + CNif + ',''''))<>'''' GROUP BY UPPER(TRIM(' + CNif + ')) HAVING COUNT(*)>1) X');
    if N > 0 then AddRowSQL('MEDIA', 'Clientes', IntToStr(N) + ' NIF/CIF duplicados', 'Campo revisado: clientes.' + CNif + ' (NIF/CIF real). El detalle muestra el NIF duplicado y todos los clientes implicados.', 'Doble clic para ver clientes duplicados', 'SELECT d.NIF_DUP AS NIF_CIF_DUPLICADO, d.VECES AS NUM_CLIENTES_CON_MISMO_NIF, c.C0 AS COD_CLIENTE, c.C1 AS NOMBRE_CLIENTE, c.' + CNif + ' AS NIF_CIF_CLIENTE FROM clientes c INNER JOIN (SELECT UPPER(TRIM(' + CNif + ')) AS NIF_DUP, COUNT(*) AS VECES FROM clientes WHERE TRIM(IFNULL(' + CNif + ',''''))<>'''' GROUP BY UPPER(TRIM(' + CNif + ')) HAVING COUNT(*)>1) d ON d.NIF_DUP=UPPER(TRIM(c.' + CNif + ')) ORDER BY d.NIF_DUP,c.C0 LIMIT 1000');
  end
  else
    AddRow('AVISO', 'Clientes', 'Campo NIF/CIF no localizado', 'No existe clientes.C5, que es el campo NIF/CIF esperado en FacturLinEx.', 'Revisar estructura de clientes');

  CNombre := FirstExistingColumn('clientes', ['C1','NOMBRE','RAZON','RAZONSOCIAL']);
  if CNombre <> '' then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM clientes WHERE IFNULL(' + CNombre + ','''')=''''');
    if N > 0 then AddRow('MEDIA', 'Clientes', IntToStr(N) + ' clientes sin nombre', 'Campo revisado: ' + CNombre + '.', 'Revisar fichas de clientes');
  end;
end;

procedure TDoctorFacturLinExForm.RevisarProveedores;
var
  N: Integer;
begin
  if not TableExists('proveedores') then Exit;
  if ColumnExists('proveedores', 'P0') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM proveedores WHERE IFNULL(P0,'''')=''''');
    if N > 0 then AddRow('ALTA', 'Proveedores', IntToStr(N) + ' proveedores sin codigo', 'Campo P0 vacio.', 'Corregir proveedor');
  end;
  if ColumnExists('proveedores', 'P1') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM proveedores WHERE IFNULL(P1,'''')=''''');
    if N > 0 then AddRow('MEDIA', 'Proveedores', IntToStr(N) + ' proveedores sin descripcion', 'Campo P1 vacio.', 'Completar proveedor')
    else AddRow('OK', 'Proveedores', 'Descripcion de proveedores correcta', 'No se detectan proveedores sin P1.', 'Sin accion');
  end;
end;

procedure TDoctorFacturLinExForm.RevisarPromociones;
var
  TPromo, TPack, TRules: string;
  N: Integer;
begin
  TPromo := TableName('promo');
  TPack := TableName('promo_pack_items');
  TRules := TableName('promo_rules');

  if TableExists(TRules) and ColumnExists(TRules, 'activo') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TRules) + ' WHERE UPPER(IFNULL(activo,'''')) NOT IN (''S'',''N'','''')');
    if N > 0 then AddRow('MEDIA', 'Promociones', IntToStr(N) + ' reglas con activo no valido', 'Valores distintos de S/N/vacio en promo_rules.activo.', 'Revisar reglas de promociones')
    else AddRow('OK', 'Promociones', 'Reglas activo S/N correctas', TRules + '.activo revisado.', 'Sin accion');
  end;

  if TableExists(TPromo) and TableExists(TPack) then
    AddRow('OK', 'Promociones', 'Tablas principales localizadas', TPromo + ' y ' + TPack + ' existen.', 'Sin accion');
end;

procedure TDoctorFacturLinExForm.RevisarComprasVentas;
var
  THisD, THPedD, TUlt: string;
  N: Integer;
begin
  THisD := TableName('hisopdd');
  THPedD := TableName('hipedidd');
  TUlt := TableName('ultimopedi');
  if TableExists(THisD) then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(THisD) + ' WHERE HOD0 >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)');
    AddRow('OK', 'Ventas', IntToStr(N) + ' lineas historicas ultimos 30 dias', 'Fuente: ' + THisD + '.', 'Sin accion');
  end;
  if TableExists(THPedD) then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(THPedD) + ' WHERE HPD1 >= DATE_SUB(CURDATE(), INTERVAL 365 DAY)');
    AddRow('OK', 'Compras', IntToStr(N) + ' lineas de compra ultimo año', 'Fuente: ' + THPedD + '.', 'Sin accion');
  end
  else if TableExists(TUlt) then
    AddRow('AVISO', 'Compras', 'No localizada hipedidd; existe ultimopedi', 'El Doctor puede revisar historico resumido pero no todo el detalle.', 'Revisar modulo compras');
end;

procedure TDoctorFacturLinExForm.RevisarVeriFactuExtra;
var
  N: Integer;
begin
  if not TableExists('verifactu_queue') then Exit;
  if ColumnExists('verifactu_queue', 'estado') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM verifactu_queue WHERE estado IN (''ERROR'',''ERROR_TECNICO'')');
    if N > 0 then AddRow('ALTA', 'VeriFactu', IntToStr(N) + ' registros en error', 'Estados ERROR o ERROR_TECNICO.', 'Abrir monitor VeriFactu');
    N := ScalarInt('SELECT COUNT(*) FROM verifactu_queue WHERE estado IN (''PENDIENTE'',''EN_PROCESO'')');
    if N > 0 then AddRow('MEDIA', 'VeriFactu', IntToStr(N) + ' registros pendientes/en proceso', 'Cola con documentos no cerrados.', 'Revisar monitor VeriFactu')
    else AddRow('OK', 'VeriFactu', 'Sin pendientes/en proceso', 'No se detectan PENDIENTE ni EN_PROCESO.', 'Sin accion');
  end;
end;

procedure TDoctorFacturLinExForm.ActualizarResumen;
var
  TotalInc, Salud: Integer;
begin
  TotalInc := FAlta + FMedia + FAviso + FBaja;
  Salud := SaludEstimada;

  if Assigned(LblKPIAlta) then LblKPIAlta.Caption := IntToStr(FAlta);
  if Assigned(LblKPIMedia) then LblKPIMedia.Caption := IntToStr(FMedia);
  if Assigned(LblKPIAviso) then LblKPIAviso.Caption := IntToStr(FAviso + FBaja);
  if Assigned(LblKPIOK) then LblKPIOK.Caption := IntToStr(FOK);
  if Assigned(LblKPISalud) then LblKPISalud.Caption := IntToStr(Salud) + ' %';

  if Assigned(LblVistaActual) then
    LblVistaActual.Caption := 'Revisión finalizada: ' + IntToStr(Grid.RowCount - 1) + ' líneas';
  if Assigned(LblSubtituloVista) then
    LblSubtituloVista.Caption := 'Incidencias: ' + IntToStr(TotalInc) +
      ' | ALTA: ' + IntToStr(FAlta) +
      ' | MEDIA: ' + IntToStr(FMedia) +
      ' | AVISO/BAJA: ' + IntToStr(FAviso + FBaja) +
      ' | OK: ' + IntToStr(FOK);

  Memo.Lines.Text := 'Doctor FacturLinEx - revisión completa finalizada.' + LineEnding +
    'Salud estimada del sistema: ' + IntToStr(Salud) + ' %' + LineEnding +
    'ALTA: ' + IntToStr(FAlta) + ' | MEDIA: ' + IntToStr(FMedia) +
    ' | AVISO: ' + IntToStr(FAviso) + ' | BAJA: ' + IntToStr(FBaja) +
    ' | OK: ' + IntToStr(FOK) + LineEnding +
    'Resultado: Engine común + comprobaciones específicas ampliadas del Doctor.' + LineEnding +
    'Las posibles reparaciones se proponen como acción. Normalizar NIF requiere previsualización y confirmación.';

  AjustarColumnas;
end;

procedure TDoctorFacturLinExForm.RevisarDoctorCompleto;
begin
  InitGrid;
  FAlta := 0; FMedia := 0; FAviso := 0; FBaja := 0; FOK := 0;

  AddEngineRows;
  RevisarTablasClave;
  RevisarArticulos;
  RevisarEANs;
  RevisarClientes;
  RevisarProveedores;
  RevisarPromociones;
  RevisarComprasVentas;
  RevisarVeriFactuExtra;

  if Grid.RowCount = 1 then
    AddRow('OK', 'Doctor', 'Sin incidencias detectadas', 'No se han detectado incidencias en las revisiones ejecutadas.', 'Sin accion');

  ActualizarResumen;
end;

procedure TDoctorFacturLinExForm.RevisarClick(Sender: TObject);
begin
  RevisarDoctorCompleto;
end;

procedure TDoctorFacturLinExForm.CSVClick(Sender: TObject);
begin
  FLXGuardarCSVConDialogo(Grid, 'Exportar Doctor FacturLinEx', 'doctor_facturlinex_completo.csv');
end;

procedure TDoctorFacturLinExForm.DetalleClick(Sender: TObject);
begin
  MostrarDetalleSQL;
end;

procedure TDoctorFacturLinExForm.GridDblClick(Sender: TObject);
begin
  MostrarDetalleSQL;
end;

procedure TDoctorFacturLinExForm.MostrarDetalleSQL;
var
  SQLDet: string;
  F: TDoctorDetalleSQLForm;
begin
  if (Grid.Row < 1) or (Grid.Row >= Grid.RowCount) then
  begin
    ShowMessage('Seleccione una incidencia del Doctor.');
    Exit;
  end;
  SQLDet := Grid.Cells[5, Grid.Row];
  if Trim(SQLDet) = '' then
  begin
    ShowMessage('Esta revisión no tiene consulta de detalle asociada todavía.');
    Exit;
  end;

  F := TDoctorDetalleSQLForm.CreateDetalle(Self, FConn,
    'Detalle Doctor - ' + Grid.Cells[1,Grid.Row] + ' - ' + Grid.Cells[2,Grid.Row], SQLDet);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

procedure TDoctorFacturLinExForm.NormalizarNIFClick(Sender: TObject);
var
  QSel, QUpd: TZQuery;
  Candidates: TStringList;
  CodCli, NifActual, NifNorm, WhereList, SQLPreview: string;
  I, N, Ignorados, LimitPreview: Integer;
  F: TDoctorDetalleSQLForm;

  function SoloDigitos(const S: string): Boolean;
  var J: Integer;
  begin
    Result := S <> '';
    for J := 1 to Length(S) do
      if not (S[J] in ['0'..'9']) then Exit(False);
  end;

  function NormalizaNIFTexto(const S: string): string;
  var J: Integer; Ch: Char;
  begin
    Result := '';
    for J := 1 to Length(S) do
    begin
      Ch := UpCase(S[J]);
      if Ch in ['A'..'Z','0'..'9'] then
        Result := Result + Ch;
    end;
  end;

  function ValidaDNI(const S: string): Boolean;
  const Letras = 'TRWAGMYFPDXBNJZSQVHLCKE';
  var Num: Int64; Dig: string;
  begin
    Result := False;
    if Length(S) <> 9 then Exit;
    Dig := Copy(S,1,8);
    if not SoloDigitos(Dig) then Exit;
    if not TryStrToInt64(Dig, Num) then Exit;
    Result := S[9] = Letras[(Num mod 23) + 1];
  end;

  function ValidaNIE(const S: string): Boolean;
  const Letras = 'TRWAGMYFPDXBNJZSQVHLCKE';
  var Num: Int64; Dig: string; Prefix: Char;
  begin
    Result := False;
    if Length(S) <> 9 then Exit;
    Prefix := S[1];
    if not (Prefix in ['X','Y','Z']) then Exit;
    Dig := Copy(S,2,7);
    if not SoloDigitos(Dig) then Exit;
    case Prefix of
      'X': Dig := '0' + Dig;
      'Y': Dig := '1' + Dig;
      'Z': Dig := '2' + Dig;
    end;
    if not TryStrToInt64(Dig, Num) then Exit;
    Result := S[9] = Letras[(Num mod 23) + 1];
  end;

  function ValidaCIF(const S: string): Boolean;
  const LetrasCIF = 'JABCDEFGHI';
  var
    J, V, Suma, ControlDig: Integer;
    ControlLetra: Char;
    Digitos: string;
  begin
    Result := False;
    if Length(S) <> 9 then Exit;
    if not (S[1] in ['A'..'Z']) then Exit;
    Digitos := Copy(S,2,7);
    if not SoloDigitos(Digitos) then Exit;

    Suma := 0;
    for J := 1 to 7 do
    begin
      V := Ord(Digitos[J]) - Ord('0');
      if (J mod 2) = 1 then
      begin
        V := V * 2;
        Suma := Suma + (V div 10) + (V mod 10);
      end
      else
        Suma := Suma + V;
    end;
    ControlDig := (10 - (Suma mod 10)) mod 10;
    ControlLetra := LetrasCIF[ControlDig + 1];

    { Aceptamos NIF/CIF de entidad si el control coincide en formato numerico
      o alfabetico. No inventamos letras ni cambiamos valores invalidos. }
    Result := (S[9] = Chr(Ord('0') + ControlDig)) or (S[9] = ControlLetra);
  end;

  function EsNIFValido(const S: string): Boolean;
  begin
    Result := ValidaDNI(S) or ValidaNIE(S) or ValidaCIF(S);
  end;

begin
  if not ColumnExists('clientes','C5') then
  begin
    MessageDlg('Normalizar NIF', 'No existe el campo clientes.C5.', mtWarning, [mbOK], 0);
    Exit;
  end;

  Candidates := TStringList.Create;
  QSel := TZQuery.Create(nil);
  try
    QSel.Connection := FConn;
    QSel.SQL.Text := 'SELECT C0, C5 FROM clientes WHERE TRIM(IFNULL(C5,''''))<>'''' ORDER BY C0';
    QSel.Open;
    Ignorados := 0;
    while not QSel.EOF do
    begin
      CodCli := Trim(QSel.FieldByName('C0').AsString);
      NifActual := QSel.FieldByName('C5').AsString;
      NifNorm := NormalizaNIFTexto(NifActual);

      if (NifNorm <> '') and (NifNorm <> NifActual) then
      begin
        if EsNIFValido(NifNorm) then
          Candidates.Values[CodCli] := NifNorm
        else
          Inc(Ignorados);
      end;
      QSel.Next;
    end;
  finally
    QSel.Free;
  end;

  N := Candidates.Count;
  if N <= 0 then
  begin
    MessageDlg('Normalizar NIF',
      'No hay NIF/CIF validos pendientes de normalizar en clientes.C5.' + LineEnding + LineEnding +
      'Los valores no validos o usados como texto libre se dejan sin tocar para revisarlos manualmente.',
      mtInformation, [mbOK], 0);
    Candidates.Free;
    Exit;
  end;

  WhereList := '';
  LimitPreview := N;
  if LimitPreview > 2000 then LimitPreview := 2000;
  for I := 0 to LimitPreview - 1 do
  begin
    if WhereList <> '' then WhereList := WhereList + ',';
    WhereList := WhereList + QuotedStr(Candidates.Names[I]);
  end;

  SQLPreview := 'SELECT C0 AS COD_CLIENTE, C1 AS NOMBRE_CLIENTE, C5 AS NIF_ACTUAL, ' +
    'UPPER(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(C5),'' '', ''''),''-'',''''),''_'',''''),''.'','''')) AS NIF_NORMALIZADO_VALIDO ' +
    'FROM clientes WHERE C0 IN (' + WhereList + ') ORDER BY C0';

  F := TDoctorDetalleSQLForm.CreateDetalle(Self, FConn, 'Previsualizacion NIF/CIF validos que se normalizaran', SQLPreview);
  try
    F.ShowModal;
  finally
    F.Free;
  end;

  if MessageDlg('Normalizar NIF/CIF',
    'Se van a normalizar ' + IntToStr(N) + ' NIF/CIF VALIDOS en clientes.C5.' + LineEnding + LineEnding +
    'Solo se tocaran NIF/DNI/NIE/CIF que sean correctos tras quitar espacios, guiones, subguiones y puntos.' + LineEnding +
    'Los NIF no validos, textos libres o datos antiguos se dejan SIN MODIFICAR.' + LineEnding +
    'Ignorados por no ser validos: ' + IntToStr(Ignorados) + LineEnding + LineEnding +
    '¿Desea aplicar la normalizacion?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
  begin
    Candidates.Free;
    Exit;
  end;

  QUpd := TZQuery.Create(nil);
  try
    QUpd.Connection := FConn;
    for I := 0 to Candidates.Count - 1 do
    begin
      CodCli := Candidates.Names[I];
      NifNorm := Candidates.ValueFromIndex[I];
      QUpd.SQL.Text := 'UPDATE clientes SET C5=' + QuotedStr(NifNorm) + ' WHERE C0=' + QuotedStr(CodCli);
      QUpd.ExecSQL;
    end;
  finally
    QUpd.Free;
    Candidates.Free;
  end;

  MessageDlg('Normalizar NIF/CIF',
    'Normalizacion finalizada.' + LineEnding +
    'Solo se han modificado NIF/CIF validos.' + LineEnding +
    'Ejecute de nuevo Revisar para actualizar el Doctor.', mtInformation, [mbOK], 0);
  RevisarDoctorCompleto;
end;

procedure TDoctorFacturLinExForm.CerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TDoctorFacturLinExForm.GridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  Grid.MouseToCell(X, Y, ACol, ARow);
  if (ARow = 0) and (ACol >= 0) then
    FLXGridOrdenar(Grid, ACol, FLastSortCol, FSortDesc);
end;

procedure TDoctorFacturLinExForm.GridDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
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
      S := UpperCase(Grid.Cells[0,aRow]);
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

procedure MostrarDoctorFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  F: TDoctorFacturLinExForm;
begin
  F := TDoctorFacturLinExForm.CreateDoctor(AOwner, AConnection, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

end.
