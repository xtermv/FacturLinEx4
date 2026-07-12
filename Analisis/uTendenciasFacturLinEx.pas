unit uTendenciasFacturLinEx;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, StdCtrls, Buttons,
  Grids, Graphics, DB, ZConnection, ZDataset, uFLXGridUtils, uFLXIcons;

procedure MostrarTendenciasFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);

implementation

type
  TTendenciasForm = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;
    FSortCol: Integer;
    FSortDesc: Boolean;
    Grid: TStringGrid;
    Memo: TMemo;
    LblTitulo: TLabel;
    LblResumen: TLabel;
    BtnAnalizar: TBitBtn;
    BtnCSV: TBitBtn;
    BtnCerrar: TBitBtn;
    CmbVista: TComboBox;
    HeaderPanel: TPanel;
    NavPanel: TPanel;
    FiltrosPanel: TPanel;
    ContentPanel: TPanel;
    TitlePanel: TPanel;
    KPIPanel: TPanel;
    LblVistaActual: TLabel;
    LblSubtituloVista: TLabel;
    LblKPI1: TLabel;
    LblKPI2: TLabel;
    LblKPI3: TLabel;
    LblKPI4: TLabel;
    LblKPI5: TLabel;
    BtnResumen: TBitBtn;
    BtnFamilias: TBitBtn;
    BtnArticulos: TBitBtn;
    BtnProveedores: TBitBtn;
    BtnClientes: TBitBtn;
    procedure CrearBotonVista(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AIndex: Integer);
    procedure CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer);
    procedure CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
    procedure VistaButtonClick(Sender: TObject);
    procedure AplicarEstiloGrid;
    procedure CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
    procedure ResetGrid;
    procedure AddRow(const Tipo, Codigo, Descripcion: string; Actual, Anterior, Dif, Porc: Double; const Tendencia, Accion: string);
    procedure AnalizarClick(Sender: TObject);
    procedure CSVClick(Sender: TObject);
    procedure CerrarClick(Sender: TObject);
    procedure GridHeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer);
    procedure GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
    procedure AjustarColumnas;
    function SQLIdent(const S: string): string;
    function TableName(const Prefix: string): string;
    function DBName: string;
    function TableExists(const ATable: string): Boolean;
    function FmtMoney(V: Double): string;
    function FmtPct(V: Double): string;
    function TendenciaTexto(const Actual, Anterior, Porc: Double): string;
    function AccionTexto(const Actual, Anterior, Porc: Double): string;
    procedure AnalizarArticulos;
    procedure AnalizarFamilias;
    procedure AnalizarProveedores;
    procedure AnalizarClientes;
    procedure AnalizarResumen;
    procedure RefrescarResumen;
  public
    constructor CreateForm(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
  end;

procedure TTendenciasForm.CargarIconoBoton(ABtn: TBitBtn; const AIcon: string; ASize: Integer);
begin
  FLXSetBitBtnIcon(ABtn, AIcon, ASize);
end;

procedure TTendenciasForm.CrearBotonVista(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer; AIndex: Integer);
begin
  ABtn := TBitBtn.Create(Self);
  ABtn.Parent := AParent;
  ABtn.Left := ALeft;
  ABtn.Top := 8;
  ABtn.Width := 136;
  ABtn.Height := 58;
  ABtn.Caption := ACaption;
  ABtn.Tag := AIndex;
  ABtn.Font.Style := [fsBold];
  ABtn.Layout := blGlyphLeft;
  ABtn.Spacing := 8;
  ABtn.OnClick := @VistaButtonClick;
  CargarIconoBoton(ABtn, AIcon, 30);
end;

procedure TTendenciasForm.CrearBotonAccion(AParent: TWinControl; var ABtn: TBitBtn; const ACaption, AIcon: string; ALeft: Integer);
begin
  ABtn := TBitBtn.Create(Self);
  ABtn.Parent := AParent;
  ABtn.Left := ALeft;
  ABtn.Top := 8;
  ABtn.Width := 118;
  ABtn.Height := 58;
  ABtn.Caption := ACaption;
  ABtn.Layout := blGlyphTop;
  ABtn.Font.Style := [fsBold];
  CargarIconoBoton(ABtn, AIcon, 30);
end;

procedure TTendenciasForm.CrearKPI(AParent: TWinControl; const ATitle, AIcon: string; ALeft: Integer; out AValueLabel: TLabel);
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

procedure TTendenciasForm.VistaButtonClick(Sender: TObject);
begin
  if Sender is TBitBtn then
  begin
    CmbVista.ItemIndex := TBitBtn(Sender).Tag;
    AnalizarClick(Sender);
  end;
end;

procedure TTendenciasForm.AplicarEstiloGrid;
begin
  Grid.Color := clWhite;
  Grid.FixedColor := RGBToColor(225,238,252);
  Grid.AlternateColor := RGBToColor(248,251,255);
  Grid.Font.Color := clBlack;
  Grid.TitleFont.Color := RGBToColor(0,32,80);
  Grid.TitleFont.Style := [fsBold];
  Grid.Options := Grid.Options + [goRowSelect, goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine];
end;

constructor TTendenciasForm.CreateForm(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var
  Logo: TImage;
  Pic: TPicture;
  FN: string;
  L: TLabel;
  ActionPanel: TPanel;
  FilterTitle: TLabel;
  E: TEdit;
  CB: TComboBox;
  BtnAplicar: TBitBtn;
begin
  inherited CreateNew(AOwner, 1);
  FConn := AConnection;
  FTienda := ATienda;
  FSortCol := -1;
  FSortDesc := False;

  Caption := 'FacturLinEx - Tendencias';
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
  FN := FLXIconFile('tendencias', 64);
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
  LblTitulo.Caption := 'Tendencias';
  LblTitulo.Font.Size := 24;
  LblTitulo.Font.Style := [fsBold];
  LblTitulo.Font.Color := RGBToColor(0,32,80);

  LblResumen := TLabel.Create(Self);
  LblResumen.Parent := HeaderPanel;
  LblResumen.Left := 114;
  LblResumen.Top := 68;
  LblResumen.Caption := 'Análisis de tendencias de ventas y compras';
  LblResumen.Font.Size := 11;
  LblResumen.Font.Color := RGBToColor(45,70,105);

  ActionPanel := TPanel.Create(Self);
  ActionPanel.Parent := HeaderPanel;
  ActionPanel.Align := alRight;
  ActionPanel.Width := 610;
  ActionPanel.BevelOuter := bvNone;
  ActionPanel.Color := HeaderPanel.Color;

  CrearBotonAccion(ActionPanel, BtnAnalizar, 'Actualizar', 'tend_actualizar', 8);
  BtnAnalizar.OnClick := @AnalizarClick;
  CrearBotonAccion(ActionPanel, BtnCSV, 'Exportar', 'tend_exportar', 134);
  BtnCSV.OnClick := @CSVClick;

  BtnCerrar := TBitBtn.Create(Self);
  BtnCerrar.Parent := ActionPanel;
  BtnCerrar.Left := 476;
  BtnCerrar.Top := 8;
  BtnCerrar.Width := 118;
  BtnCerrar.Height := 58;
  BtnCerrar.Caption := 'Cerrar';
  BtnCerrar.Layout := blGlyphTop;
  BtnCerrar.Font.Style := [fsBold];
  BtnCerrar.OnClick := @CerrarClick;
  CargarIconoBoton(BtnCerrar, 'tend_cerrar', 30);

  NavPanel := TPanel.Create(Self);
  NavPanel.Parent := Self;
  NavPanel.Align := alTop;
  NavPanel.Height := 74;
  NavPanel.BevelOuter := bvNone;
  NavPanel.Color := RGBToColor(248,251,255);

  CrearBotonVista(NavPanel, BtnResumen, 'Resumen', 'tend_resumen', 16, 0);
  CrearBotonVista(NavPanel, BtnFamilias, 'Familias', 'tend_familias', 160, 1);
  CrearBotonVista(NavPanel, BtnArticulos, 'Artículos', 'tend_articulos', 304, 2);
  CrearBotonVista(NavPanel, BtnProveedores, 'Proveedores', 'tend_proveedores', 448, 3);
  CrearBotonVista(NavPanel, BtnClientes, 'Clientes', 'tend_clientes', 592, 4);

  FiltrosPanel := TPanel.Create(Self);
  FiltrosPanel.Parent := Self;
  FiltrosPanel.Align := alLeft;
  FiltrosPanel.Width := 245;
  FiltrosPanel.BevelOuter := bvLowered;
  FiltrosPanel.Color := RGBToColor(248,251,255);

  FilterTitle := TLabel.Create(Self);
  FilterTitle.Parent := FiltrosPanel;
  FilterTitle.Left := 18;
  FilterTitle.Top := 20;
  FilterTitle.Caption := 'Filtros';
  FilterTitle.Font.Size := 12;
  FilterTitle.Font.Style := [fsBold];
  FilterTitle.Font.Color := RGBToColor(0,65,145);

  L := TLabel.Create(Self);
  L.Parent := FiltrosPanel;
  L.Left := 18; L.Top := 62; L.Caption := 'Fecha desde';
  E := TEdit.Create(Self);
  E.Parent := FiltrosPanel; E.Left := 18; E.Top := 82; E.Width := 205; E.Text := '01/01/' + FormatDateTime('yyyy', Date);

  L := TLabel.Create(Self);
  L.Parent := FiltrosPanel;
  L.Left := 18; L.Top := 122; L.Caption := 'Fecha hasta';
  E := TEdit.Create(Self);
  E.Parent := FiltrosPanel; E.Left := 18; E.Top := 142; E.Width := 205; E.Text := FormatDateTime('dd/mm/yyyy', Date);

  L := TLabel.Create(Self);
  L.Parent := FiltrosPanel;
  L.Left := 18; L.Top := 182; L.Caption := 'Agrupar por';
  CB := TComboBox.Create(Self);
  CB.Parent := FiltrosPanel; CB.Left := 18; CB.Top := 202; CB.Width := 205;
  CB.Items.Add('Mes'); CB.Items.Add('Semana'); CB.Items.Add('Día'); CB.ItemIndex := 0;

  L := TLabel.Create(Self);
  L.Parent := FiltrosPanel;
  L.Left := 18; L.Top := 242; L.Caption := 'Tipo de datos';
  CmbVista := TComboBox.Create(Self);
  CmbVista.Parent := FiltrosPanel;
  CmbVista.Left := 18;
  CmbVista.Top := 262;
  CmbVista.Width := 205;
  CmbVista.Style := csDropDownList;
  CmbVista.Items.Add('Resumen');
  CmbVista.Items.Add('Familias');
  CmbVista.Items.Add('Artículos');
  CmbVista.Items.Add('Proveedores');
  CmbVista.Items.Add('Clientes');
  CmbVista.ItemIndex := 0;

  BtnAplicar := TBitBtn.Create(Self);
  BtnAplicar.Parent := FiltrosPanel;
  BtnAplicar.Left := 18;
  BtnAplicar.Top := 340;
  BtnAplicar.Width := 205;
  BtnAplicar.Height := 50;
  BtnAplicar.Caption := 'Aplicar filtros';
  BtnAplicar.Font.Style := [fsBold];
  BtnAplicar.Layout := blGlyphLeft;
  BtnAplicar.OnClick := @AnalizarClick;
  CargarIconoBoton(BtnAplicar, 'tend_filtro', 30);

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
  LblVistaActual.Caption := 'Vista actual: RESUMEN GENERAL';
  LblVistaActual.Font.Size := 12;
  LblVistaActual.Font.Style := [fsBold];
  LblVistaActual.Font.Color := RGBToColor(0,65,145);

  LblSubtituloVista := TLabel.Create(Self);
  LblSubtituloVista.Parent := TitlePanel;
  LblSubtituloVista.Left := 16;
  LblSubtituloVista.Top := 38;
  LblSubtituloVista.Caption := 'Evolución de ventas en el periodo seleccionado.';
  LblSubtituloVista.Font.Color := RGBToColor(45,70,105);

  KPIPanel := TPanel.Create(Self);
  KPIPanel.Parent := ContentPanel;
  KPIPanel.Align := alBottom;
  KPIPanel.Height := 108;
  KPIPanel.BevelOuter := bvLowered;
  KPIPanel.Color := RGBToColor(250,252,255);

  CrearKPI(KPIPanel, 'Líneas analizadas', 'tend_kpi_ventas', 12, LblKPI1);
  CrearKPI(KPIPanel, 'Suben', 'rentabilidad', 252, LblKPI2);
  CrearKPI(KPIPanel, 'Bajan', 'predicciones', 492, LblKPI3);
  CrearKPI(KPIPanel, 'Cambios fuertes', 'tend_kpi_porcentaje', 732, LblKPI4);
  CrearKPI(KPIPanel, 'Vista actual', 'tend_kpi_clientes', 972, LblKPI5);

  Grid := TStringGrid.Create(Self);
  Grid.Parent := ContentPanel;
  Grid.Align := alClient;
  Grid.FixedRows := 1;
  Grid.Options := Grid.Options + [goRowSelect, goColSizing];
  Grid.OnHeaderClick := @GridHeaderClick;
  Grid.OnPrepareCanvas := @GridPrepareCanvas;
  AplicarEstiloGrid;

  Memo := TMemo.Create(Self);
  Memo.Parent := Self;
  Memo.Align := alBottom;
  Memo.Height := 70;
  Memo.ScrollBars := ssVertical;
  Memo.Color := RGBToColor(250,252,255);
  Memo.Lines.Text := 'Tendencias compara los últimos 30 días contra los 30 días anteriores.' + LineEnding +
                     'Es solo lectura y limita los resultados para mantener agilidad.';
  ResetGrid;
end;

procedure TTendenciasForm.ResetGrid;
begin
  Grid.ColCount := 9;
  Grid.RowCount := 1;
  Grid.Cells[0,0] := 'Tipo';
  Grid.Cells[1,0] := 'Código';
  Grid.Cells[2,0] := 'Descripción';
  Grid.Cells[3,0] := 'Últimos 30 días';
  Grid.Cells[4,0] := '30 días anteriores';
  Grid.Cells[5,0] := 'Diferencia';
  Grid.Cells[6,0] := '%';
  Grid.Cells[7,0] := 'Tendencia';
  Grid.Cells[8,0] := 'Acción recomendada';
  AjustarColumnas;
end;

procedure TTendenciasForm.AjustarColumnas;
var
  Total, Disponible: Integer;
begin
  if Grid.ColCount < 9 then Exit;
  Grid.ColWidths[0] := 95;
  Grid.ColWidths[1] := 95;
  Grid.ColWidths[3] := 125;
  Grid.ColWidths[4] := 135;
  Grid.ColWidths[5] := 115;
  Grid.ColWidths[6] := 85;
  Grid.ColWidths[7] := 145;
  Grid.ColWidths[8] := 280;
  Total := Grid.ColWidths[0] + Grid.ColWidths[1] + Grid.ColWidths[3] + Grid.ColWidths[4] +
           Grid.ColWidths[5] + Grid.ColWidths[6] + Grid.ColWidths[7] + Grid.ColWidths[8] + 40;
  Disponible := Grid.ClientWidth - Total;
  if Disponible < 220 then Disponible := 220;
  Grid.ColWidths[2] := Disponible;
end;

function TTendenciasForm.FmtMoney(V: Double): string;
begin
  Result := FormatFloat('#,##0.00 €', V);
end;

function TTendenciasForm.FmtPct(V: Double): string;
begin
  Result := FormatFloat('#,##0.00 %', V);
end;

function TTendenciasForm.TendenciaTexto(const Actual, Anterior, Porc: Double): string;
begin
  if (Actual = 0) and (Anterior = 0) then Result := 'Sin datos'
  else if (Anterior = 0) and (Actual > 0) then Result := 'Nueva / recuperada'
  else if (Actual = 0) and (Anterior > 0) then Result := 'Caída total'
  else if Porc >= 25 then Result := 'Subida fuerte'
  else if Porc >= 8 then Result := 'Sube'
  else if Porc <= -25 then Result := 'Bajada fuerte'
  else if Porc <= -8 then Result := 'Baja'
  else Result := 'Estable';
end;

function TTendenciasForm.AccionTexto(const Actual, Anterior, Porc: Double): string;
begin
  if (Anterior = 0) and (Actual > 0) then Result := 'Revisar oportunidad: empieza a venderse'
  else if (Actual = 0) and (Anterior > 0) then Result := 'Revisar posible rotura, baja o cambio de demanda'
  else if Porc >= 25 then Result := 'Vigilar stock y reposición'
  else if Porc >= 8 then Result := 'Mantener seguimiento'
  else if Porc <= -25 then Result := 'Revisar causa de caída'
  else if Porc <= -8 then Result := 'Observar evolución'
  else Result := 'Sin acción prioritaria';
end;

procedure TTendenciasForm.AddRow(const Tipo, Codigo, Descripcion: string; Actual, Anterior, Dif, Porc: Double; const Tendencia, Accion: string);
var
  R: Integer;
begin
  R := Grid.RowCount;
  Grid.RowCount := R + 1;
  Grid.Cells[0,R] := Tipo;
  Grid.Cells[1,R] := Codigo;
  Grid.Cells[2,R] := Descripcion;
  Grid.Cells[3,R] := FmtMoney(Actual);
  Grid.Cells[4,R] := FmtMoney(Anterior);
  Grid.Cells[5,R] := FmtMoney(Dif);
  Grid.Cells[6,R] := FmtPct(Porc);
  Grid.Cells[7,R] := Tendencia;
  Grid.Cells[8,R] := Accion;
end;

function TTendenciasForm.SQLIdent(const S: string): string;
begin
  Result := '`' + StringReplace(S, '`', '', [rfReplaceAll]) + '`';
end;

function TTendenciasForm.TableName(const Prefix: string): string;
begin
  Result := Prefix + FTienda;
end;

function TTendenciasForm.DBName: string;
begin
  Result := '';
  if Assigned(FConn) then Result := FConn.Database;
end;

function TTendenciasForm.TableExists(const ATable: string): Boolean;
var Q: TZQuery;
begin
  Result := False;
  if (FConn = nil) or (DBName = '') then Exit;
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

procedure TTendenciasForm.AnalizarResumen;
var Q: TZQuery; T: string; A, P, D, Porc: Double;
begin
  T := TableName('hisopdd');
  if not TableExists(T) then begin AddRow('Sistema', T, 'Tabla no encontrada', 0,0,0,0,'Sin datos','Revisar configuración de tienda'); Exit; end;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT '+
      'SUM(IF(HOD0 >= DATE_SUB(CURDATE(), INTERVAL 30 DAY), HOD14, 0)) ACT, '+
      'SUM(IF(HOD0 < DATE_SUB(CURDATE(), INTERVAL 30 DAY), HOD14, 0)) PREV '+
      'FROM '+SQLIdent(T)+' WHERE HOD0 >= DATE_SUB(CURDATE(), INTERVAL 60 DAY)';
    Q.Open;
    A := Q.FieldByName('ACT').AsFloat;
    P := Q.FieldByName('PREV').AsFloat;
    D := A - P;
    if Abs(P) > 0.0001 then Porc := (D / P) * 100 else if A > 0 then Porc := 100 else Porc := 0;
    AddRow('Resumen', 'VENTAS', 'Ventas últimos 30 días frente a 30 días anteriores', A, P, D, Porc, TendenciaTexto(A,P,Porc), AccionTexto(A,P,Porc));
  finally
    Q.Free;
  end;
end;

procedure TTendenciasForm.AnalizarFamilias;
var Q: TZQuery; T, ATab, FTab: string; A, P, D, Porc: Double; Cod, Des: string;
begin
  T := TableName('hisopdd'); ATab := TableName('artitien'); FTab := TableName('familias');
  if not TableExists(T) then begin AddRow('Sistema', T, 'Tabla de ventas no encontrada',0,0,0,0,'Sin datos','Revisar configuración'); Exit; end;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT * FROM ( '+
      'SELECT IFNULL(a.A14,0) CODFAM, IFNULL(MAX(f.F1), ''Sin familia'') DESFAM, '+
      'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL 30 DAY), h.HOD14, 0)) ACT, '+
      'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL 30 DAY), h.HOD14, 0)) PREV '+
      'FROM '+SQLIdent(T)+' h '+
      'LEFT JOIN '+SQLIdent(ATab)+' a ON a.A0 = h.HOD6 '+
      'LEFT JOIN '+SQLIdent(FTab)+' f ON f.F0 = a.A14 '+
      'WHERE h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL 60 DAY) '+
      'GROUP BY IFNULL(a.A14,0) '+
      ') X '+
      'WHERE ABS(X.ACT-X.PREV) > 0.01 '+
      'ORDER BY ABS(X.ACT-X.PREV) DESC LIMIT 150';
    Q.Open;
    while not Q.EOF do
    begin
      A := Q.FieldByName('ACT').AsFloat;
      P := Q.FieldByName('PREV').AsFloat;
      D := A - P;
      if Abs(P) > 0.0001 then Porc := (D / P) * 100 else if A > 0 then Porc := 100 else Porc := 0;
      Cod := Q.FieldByName('CODFAM').AsString;
      Des := Q.FieldByName('DESFAM').AsString;
      AddRow('Familia', Cod, Des, A, P, D, Porc, TendenciaTexto(A,P,Porc), AccionTexto(A,P,Porc));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TTendenciasForm.AnalizarArticulos;
var Q: TZQuery; T, ATab: string; A, P, D, Porc: Double; Cod, Des: string;
begin
  T := TableName('hisopdd'); ATab := TableName('artitien');
  if not TableExists(T) then begin AddRow('Sistema', T, 'Tabla de ventas no encontrada',0,0,0,0,'Sin datos','Revisar configuración'); Exit; end;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT * FROM ( '+
      'SELECT h.HOD6 COD, IFNULL(MAX(a.A1), LEFT(CAST(MAX(h.HOD7) AS CHAR),50)) DES, '+
      'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL 30 DAY), h.HOD14, 0)) ACT, '+
      'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL 30 DAY), h.HOD14, 0)) PREV '+
      'FROM '+SQLIdent(T)+' h '+
      'LEFT JOIN '+SQLIdent(ATab)+' a ON a.A0 = h.HOD6 '+
      'WHERE h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL 60 DAY) AND IFNULL(h.HOD6,'''') <> '''' '+
      'GROUP BY h.HOD6 '+
      ') X '+
      'WHERE ABS(X.ACT-X.PREV) > 0.01 '+
      'ORDER BY ABS(X.ACT-X.PREV) DESC LIMIT 300';
    Q.Open;
    while not Q.EOF do
    begin
      A := Q.FieldByName('ACT').AsFloat;
      P := Q.FieldByName('PREV').AsFloat;
      D := A - P;
      if Abs(P) > 0.0001 then Porc := (D / P) * 100 else if A > 0 then Porc := 100 else Porc := 0;
      Cod := Q.FieldByName('COD').AsString;
      Des := Q.FieldByName('DES').AsString;
      AddRow('Artículo', Cod, Des, A, P, D, Porc, TendenciaTexto(A,P,Porc), AccionTexto(A,P,Porc));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;


procedure TTendenciasForm.AnalizarProveedores;
var Q: TZQuery; T, ATab, PTab: string; A, P, D, Porc: Double; Cod, Des: string;
begin
  T := TableName('hisopdd'); ATab := TableName('artitien'); PTab := 'proveedores';
  if not TableExists(T) then begin AddRow('Sistema', T, 'Tabla de ventas no encontrada',0,0,0,0,'Sin datos','Revisar configuración'); Exit; end;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT * FROM ( '+
      'SELECT IFNULL(a.A32,0) CODPROV, IFNULL(MAX(p.P1), ''Sin proveedor'') DESPROV, '+
      'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL 30 DAY), h.HOD14, 0)) ACT, '+
      'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL 30 DAY), h.HOD14, 0)) PREV '+
      'FROM '+SQLIdent(T)+' h '+
      'LEFT JOIN '+SQLIdent(ATab)+' a ON a.A0 = h.HOD6 '+
      'LEFT JOIN '+SQLIdent(PTab)+' p ON p.P0 = a.A32 '+
      'WHERE h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL 60 DAY) '+
      'GROUP BY IFNULL(a.A32,0) '+
      ') X '+
      'WHERE ABS(X.ACT-X.PREV) > 0.01 '+
      'ORDER BY ABS(X.ACT-X.PREV) DESC LIMIT 150';
    Q.Open;
    while not Q.EOF do
    begin
      A := Q.FieldByName('ACT').AsFloat;
      P := Q.FieldByName('PREV').AsFloat;
      D := A - P;
      if Abs(P) > 0.0001 then Porc := (D / P) * 100 else if A > 0 then Porc := 100 else Porc := 0;
      Cod := Q.FieldByName('CODPROV').AsString;
      Des := Q.FieldByName('DESPROV').AsString;
      AddRow('Proveedor', Cod, Des, A, P, D, Porc, TendenciaTexto(A,P,Porc), AccionTexto(A,P,Porc));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TTendenciasForm.AnalizarClientes;
var Q: TZQuery; T, CTab, HTab: string; A, P, D, Porc: Double; Cod, Des: string;
begin
  T := TableName('hisopdd'); HTab := TableName('hisopcc'); CTab := 'clientes';
  if not TableExists(T) then begin AddRow('Sistema', T, 'Tabla de ventas no encontrada',0,0,0,0,'Sin datos','Revisar configuración'); Exit; end;
  if not TableExists(HTab) then begin AddRow('Sistema', HTab, 'Tabla de cabeceras de histórico no encontrada',0,0,0,0,'Sin datos','Revisar configuración'); Exit; end;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT * FROM ( '+
      'SELECT IFNULL(cab.HO8,0) CODCLI, IFNULL(MAX(c.C1), ''Sin cliente'') DESCLI, '+
      'SUM(IF(h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL 30 DAY), h.HOD14, 0)) ACT, '+
      'SUM(IF(h.HOD0 < DATE_SUB(CURDATE(), INTERVAL 30 DAY), h.HOD14, 0)) PREV '+
      'FROM '+SQLIdent(T)+' h '+
      'LEFT JOIN '+SQLIdent(HTab)+' cab ON cab.HO0 = h.HOD0 AND cab.HO3 = h.HOD3 AND cab.HO4 = h.HOD4 '+
      'LEFT JOIN '+SQLIdent(CTab)+' c ON c.C0 = cab.HO8 '+
      'WHERE h.HOD0 >= DATE_SUB(CURDATE(), INTERVAL 60 DAY) '+
      'GROUP BY IFNULL(cab.HO8,0) '+
      ') X '+
      'WHERE ABS(X.ACT-X.PREV) > 0.01 '+
      'ORDER BY ABS(X.ACT-X.PREV) DESC LIMIT 150';
    Q.Open;
    while not Q.EOF do
    begin
      A := Q.FieldByName('ACT').AsFloat;
      P := Q.FieldByName('PREV').AsFloat;
      D := A - P;
      if Abs(P) > 0.0001 then Porc := (D / P) * 100 else if A > 0 then Porc := 100 else Porc := 0;
      Cod := Q.FieldByName('CODCLI').AsString;
      Des := Q.FieldByName('DESCLI').AsString;
      AddRow('Cliente', Cod, Des, A, P, D, Porc, TendenciaTexto(A,P,Porc), AccionTexto(A,P,Porc));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TTendenciasForm.AnalizarClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    ResetGrid;
    Memo.Clear;
    Memo.Lines.Add('Análisis de tendencias iniciado: ' + DateTimeToStr(Now));
    case CmbVista.ItemIndex of
      1: AnalizarFamilias;
      2: AnalizarArticulos;
      3: AnalizarProveedores;
      4: AnalizarClientes;
    else
      begin
        AnalizarResumen;
        AnalizarFamilias;
      end;
    end;
    RefrescarResumen;
    Memo.Lines.Add('Análisis finalizado. Resultados limitados para mantener agilidad.');
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TTendenciasForm.RefrescarResumen;
var R, Suben, Bajan, Fuertes: Integer; Tend: string;
begin
  Suben := 0; Bajan := 0; Fuertes := 0;
  for R := 1 to Grid.RowCount - 1 do
  begin
    Tend := UpperCase(Grid.Cells[7,R]);
    if Pos('SUB', Tend) > 0 then Inc(Suben);
    if Pos('BAJ', Tend) > 0 then Inc(Bajan);
    if Pos('FUERTE', Tend) > 0 then Inc(Fuertes);
  end;
  LblResumen.Caption := Format('Líneas: %d | Suben: %d | Bajan: %d | Cambios fuertes: %d', [Grid.RowCount-1, Suben, Bajan, Fuertes]);
  if Assigned(LblKPI1) then LblKPI1.Caption := IntToStr(Grid.RowCount-1);
  if Assigned(LblKPI2) then LblKPI2.Caption := IntToStr(Suben);
  if Assigned(LblKPI3) then LblKPI3.Caption := IntToStr(Bajan);
  if Assigned(LblKPI4) then LblKPI4.Caption := IntToStr(Fuertes);
  if Assigned(LblKPI5) and Assigned(CmbVista) and (CmbVista.ItemIndex >= 0) then LblKPI5.Caption := CmbVista.Items[CmbVista.ItemIndex];
  if Assigned(LblVistaActual) and Assigned(CmbVista) and (CmbVista.ItemIndex >= 0) then
    LblVistaActual.Caption := 'Vista actual: ' + UpperCase(CmbVista.Items[CmbVista.ItemIndex]);
end;

procedure TTendenciasForm.CSVClick(Sender: TObject);
var SD: TSaveDialog; SL: TStringList; R,C: Integer; Line: string;
begin
  SD := TSaveDialog.Create(Self);
  SL := TStringList.Create;
  try
    SD.Filter := 'CSV|*.csv';
    SD.FileName := 'tendencias_facturlinex_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.csv';
    if SD.Execute then
    begin
      for R := 0 to Grid.RowCount - 1 do
      begin
        Line := '';
        for C := 0 to Grid.ColCount - 1 do
        begin
          if C > 0 then Line := Line + ';';
          Line := Line + '"' + StringReplace(Grid.Cells[C,R], '"', '''', [rfReplaceAll]) + '"';
        end;
        SL.Add(Line);
      end;
      SL.SaveToFile(SD.FileName);
    end;
  finally
    SL.Free; SD.Free;
  end;
end;

procedure TTendenciasForm.CerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TTendenciasForm.GridHeaderClick(Sender: TObject; IsColumn: Boolean; Index: Integer);
begin
  if IsColumn then FLXOrdenarStringGrid(Grid, Index, FSortCol, FSortDesc);
end;

procedure TTendenciasForm.GridPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
var S: string;
begin
  if aRow = 0 then Exit;
  FLXPrepararCanvasSeleccionNegra(Grid, aRow, aState);
  if gdSelected in aState then Exit;
  S := UpperCase(Grid.Cells[7,aRow]);
  if Pos('SUBIDA FUERTE', S) > 0 then Grid.Canvas.Brush.Color := $00D8FFD8
  else if Pos('BAJADA FUERTE', S) > 0 then Grid.Canvas.Brush.Color := $00D8D8FF
  else if Pos('SUBE', S) > 0 then Grid.Canvas.Brush.Color := $00EAFEEA
  else if Pos('BAJA', S) > 0 then Grid.Canvas.Brush.Color := $00EFEFFF;
end;

procedure MostrarTendenciasFacturLinEx(AOwner: TComponent; AConnection: TZConnection; const ATienda: string);
var F: TTendenciasForm;
begin
  F := TTendenciasForm.CreateForm(AOwner, AConnection, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

end.
