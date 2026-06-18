unit uPedidoProveedorAuto;

{$mode objfpc}{$H+}

{
  FacturLinEx - Propuesta automática de pedido por proveedor
  Version: 2026-06-17-v1.1-SOLO-PROPUESTA-FIX-CREATENEW

  OBJETIVO
  --------
  Generar una PROPUESTA revisable de pedido a proveedor usando ventas reales
  e historial de compras a ese proveedor, sin fiarse del stock actual.

  Esta primera versión NO crea pedido real en pedicc/pedidd.
  Solo consulta y muestra sugerencias en pantalla, y permite exportar CSV.

  Integración esperada:
    uses uPedidoProveedorAuto;

    MostrarPedidoProveedorAuto(Self, TuConexionZConnection, Tienda);

  Donde Tienda suele ser '0000', '0001', etc. según FacturLinEx.
}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Grids, Spin, DateUtils, Math, DB, ZConnection, ZDataset;

type

  { TfPedidoProveedorAuto }

  TfPedidoProveedorAuto = class(TForm)
  private
    FConn: TZConnection;
    FTienda: string;

    PanelTop: TPanel;
    PanelBottom: TPanel;
    Grid: TStringGrid;

    lblProveedor: TLabel;
    cbProveedor: TComboBox;
    lblDiasCubrir: TLabel;
    seDiasCubrir: TSpinEdit;
    lblDiasVentas: TLabel;
    seDiasVentas: TSpinEdit;
    lblDiasHistorico: TLabel;
    seDiasHistorico: TSpinEdit;
    lblFactor: TLabel;
    edtFactor: TEdit;
    chkMostrarCero: TCheckBox;

    btnCalcular: TButton;
    btnExportar: TButton;
    btnCerrar: TButton;

    lblEstado: TLabel;

    procedure BtnCalcularClick(Sender: TObject);
    procedure BtnExportarClick(Sender: TObject);
    procedure BtnCerrarClick(Sender: TObject);

    procedure ConstruirInterfaz;
    procedure InicializarGrid;
    procedure CargarProveedores;

    function CodigoProveedorSeleccionado: Integer;
    function NombreProveedorSeleccionado: string;
    function SufijoTiendaSeguro(const S: string): string;
    function TablaExiste(const NombreTabla: string): Boolean;
    function SQLComprasProveedor(const CodProveedor: Integer): string;
    function SQLVentas(const FechaDesdeHistorico, FechaHasta: TDateTime): string;
    function SQLFinal(const CodProveedor: Integer; const FechaDesdeHistorico,
      FechaHasta: TDateTime): string;

    function FloatSeguro(const S: string; const Def: Double): Double;
    function RedondearArriba(const Valor: Double): Double;
    function FechaSQL(const Fecha: TDateTime): string;
    function CSVSeguro(const S: string): string;
    procedure AutoAjustarColumnas;

  public
    constructor CreateAuto(AOwner: TComponent; AConn: TZConnection;
      const ATienda: string); reintroduce;
  end;

procedure MostrarPedidoProveedorAuto(AOwner: TComponent; AConn: TZConnection;
  const ATienda: string);

implementation

procedure MostrarPedidoProveedorAuto(AOwner: TComponent; AConn: TZConnection;
  const ATienda: string);
var
  F: TfPedidoProveedorAuto;
begin
  F := TfPedidoProveedorAuto.CreateAuto(AOwner, AConn, ATienda);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

{ TfPedidoProveedorAuto }

constructor TfPedidoProveedorAuto.CreateAuto(AOwner: TComponent;
  AConn: TZConnection; const ATienda: string);
begin
  // Formulario sin .lfm: hay que usar CreateNew para que Lazarus no intente cargar recurso .lfm
  inherited CreateNew(AOwner, 0);

  FConn := AConn;
  FTienda := SufijoTiendaSeguro(ATienda);

  Caption := 'Propuesta de pedido por proveedor';
  Position := poScreenCenter;
  Width := 1250;
  Height := 720;

  ConstruirInterfaz;
  InicializarGrid;
  CargarProveedores;
end;

procedure TfPedidoProveedorAuto.ConstruirInterfaz;
begin
  PanelTop := TPanel.Create(Self);
  PanelTop.Parent := Self;
  PanelTop.Align := alTop;
  PanelTop.Height := 86;
  PanelTop.BevelOuter := bvNone;

  lblProveedor := TLabel.Create(Self);
  lblProveedor.Parent := PanelTop;
  lblProveedor.Left := 10;
  lblProveedor.Top := 12;
  lblProveedor.Caption := 'Proveedor:';

  cbProveedor := TComboBox.Create(Self);
  cbProveedor.Parent := PanelTop;
  cbProveedor.Left := 85;
  cbProveedor.Top := 8;
  cbProveedor.Width := 330;
  cbProveedor.Style := csDropDownList;

  lblDiasCubrir := TLabel.Create(Self);
  lblDiasCubrir.Parent := PanelTop;
  lblDiasCubrir.Left := 430;
  lblDiasCubrir.Top := 12;
  lblDiasCubrir.Caption := 'Días a cubrir:';

  seDiasCubrir := TSpinEdit.Create(Self);
  seDiasCubrir.Parent := PanelTop;
  seDiasCubrir.Left := 525;
  seDiasCubrir.Top := 8;
  seDiasCubrir.Width := 70;
  seDiasCubrir.MinValue := 1;
  seDiasCubrir.MaxValue := 365;
  seDiasCubrir.Value := 15;

  lblDiasVentas := TLabel.Create(Self);
  lblDiasVentas.Parent := PanelTop;
  lblDiasVentas.Left := 615;
  lblDiasVentas.Top := 12;
  lblDiasVentas.Caption := 'Ventas últimos días:';

  seDiasVentas := TSpinEdit.Create(Self);
  seDiasVentas.Parent := PanelTop;
  seDiasVentas.Left := 740;
  seDiasVentas.Top := 8;
  seDiasVentas.Width := 70;
  seDiasVentas.MinValue := 1;
  seDiasVentas.MaxValue := 730;
  seDiasVentas.Value := 60;

  lblDiasHistorico := TLabel.Create(Self);
  lblDiasHistorico.Parent := PanelTop;
  lblDiasHistorico.Left := 830;
  lblDiasHistorico.Top := 12;
  lblDiasHistorico.Caption := 'Histórico anterior:';

  seDiasHistorico := TSpinEdit.Create(Self);
  seDiasHistorico.Parent := PanelTop;
  seDiasHistorico.Left := 945;
  seDiasHistorico.Top := 8;
  seDiasHistorico.Width := 70;
  seDiasHistorico.MinValue := 1;
  seDiasHistorico.MaxValue := 1460;
  seDiasHistorico.Value := 180;

  lblFactor := TLabel.Create(Self);
  lblFactor.Parent := PanelTop;
  lblFactor.Left := 1035;
  lblFactor.Top := 12;
  lblFactor.Caption := 'Factor:';

  edtFactor := TEdit.Create(Self);
  edtFactor.Parent := PanelTop;
  edtFactor.Left := 1085;
  edtFactor.Top := 8;
  edtFactor.Width := 55;
  edtFactor.Text := '1,00';

  chkMostrarCero := TCheckBox.Create(Self);
  chkMostrarCero.Parent := PanelTop;
  chkMostrarCero.Left := 10;
  chkMostrarCero.Top := 48;
  chkMostrarCero.Width := 260;
  chkMostrarCero.Caption := 'Mostrar también artículos con sugerencia 0';
  chkMostrarCero.Checked := False;

  btnCalcular := TButton.Create(Self);
  btnCalcular.Parent := PanelTop;
  btnCalcular.Left := 300;
  btnCalcular.Top := 43;
  btnCalcular.Width := 130;
  btnCalcular.Caption := 'Calcular propuesta';
  btnCalcular.OnClick := @BtnCalcularClick;

  btnExportar := TButton.Create(Self);
  btnExportar.Parent := PanelTop;
  btnExportar.Left := 440;
  btnExportar.Top := 43;
  btnExportar.Width := 100;
  btnExportar.Caption := 'Exportar CSV';
  btnExportar.OnClick := @BtnExportarClick;

  btnCerrar := TButton.Create(Self);
  btnCerrar.Parent := PanelTop;
  btnCerrar.Left := 550;
  btnCerrar.Top := 43;
  btnCerrar.Width := 90;
  btnCerrar.Caption := 'Cerrar';
  btnCerrar.OnClick := @BtnCerrarClick;

  lblEstado := TLabel.Create(Self);
  lblEstado.Parent := PanelTop;
  lblEstado.Left := 660;
  lblEstado.Top := 49;
  lblEstado.Width := 520;
  lblEstado.Caption := 'Fase 1: solo propuesta. No crea pedido real.';

  PanelBottom := TPanel.Create(Self);
  PanelBottom.Parent := Self;
  PanelBottom.Align := alClient;
  PanelBottom.BevelOuter := bvNone;

  Grid := TStringGrid.Create(Self);
  Grid.Parent := PanelBottom;
  Grid.Align := alClient;
  Grid.FixedRows := 1;
  Grid.Options := Grid.Options + [goRowSelect, goColSizing, goThumbTracking];
end;

procedure TfPedidoProveedorAuto.InicializarGrid;
begin
  Grid.ColCount := 15;
  Grid.RowCount := 2;

  Grid.Cells[0, 0] := 'Código';
  Grid.Cells[1, 0] := 'Descripción';
  Grid.Cells[2, 0] := 'Vendido periodo';
  Grid.Cells[3, 0] := 'Vendido histórico';
  Grid.Cells[4, 0] := 'Venta/día usada';
  Grid.Cells[5, 0] := 'Sugerido';
  Grid.Cells[6, 0] := 'Últ. venta';
  Grid.Cells[7, 0] := 'Últ. compra';
  Grid.Cells[8, 0] := 'Coste';
  Grid.Cells[9, 0] := 'PVP';
  Grid.Cells[10, 0] := 'IVA';
  Grid.Cells[11, 0] := 'Stock info';
  Grid.Cells[12, 0] := 'Familia';
  Grid.Cells[13, 0] := 'Estado';
  Grid.Cells[14, 0] := 'Observaciones';

  Grid.Rows[1].Clear;
  AutoAjustarColumnas;
end;

procedure TfPedidoProveedorAuto.CargarProveedores;
var
  Q: TZQuery;
begin
  cbProveedor.Items.Clear;

  if (FConn = nil) or (not FConn.Connected) then
  begin
    ShowMessage('La conexión a la base de datos no está activa.');
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT P0, P1 FROM proveedores ORDER BY P1';
    Q.Open;
    while not Q.EOF do
    begin
      cbProveedor.Items.Add(Q.FieldByName('P0').AsString + ' - ' +
        Q.FieldByName('P1').AsString);
      Q.Next;
    end;
  finally
    Q.Free;
  end;

  if cbProveedor.Items.Count > 0 then
    cbProveedor.ItemIndex := 0;
end;

function TfPedidoProveedorAuto.CodigoProveedorSeleccionado: Integer;
var
  S: string;
  P: Integer;
begin
  Result := 0;
  if cbProveedor.ItemIndex < 0 then Exit;

  S := cbProveedor.Text;
  P := Pos(' - ', S);
  if P > 0 then
    S := Copy(S, 1, P - 1);

  Result := StrToIntDef(Trim(S), 0);
end;

function TfPedidoProveedorAuto.NombreProveedorSeleccionado: string;
var
  S: string;
  P: Integer;
begin
  Result := '';
  if cbProveedor.ItemIndex < 0 then Exit;

  S := cbProveedor.Text;
  P := Pos(' - ', S);
  if P > 0 then
    Result := Copy(S, P + 3, Length(S))
  else
    Result := S;
end;

function TfPedidoProveedorAuto.SufijoTiendaSeguro(const S: string): string;
var
  I: Integer;
  C: Char;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    C := S[I];
    if C in ['0'..'9', 'A'..'Z', 'a'..'z', '_'] then
      Result := Result + C;
  end;
end;

function TfPedidoProveedorAuto.TablaExiste(const NombreTabla: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) AS C FROM information_schema.TABLES ' +
      'WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = :T';
    Q.ParamByName('T').AsString := NombreTabla;
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TfPedidoProveedorAuto.SQLComprasProveedor(const CodProveedor: Integer): string;
var
  TPedid: string;
  THiPedid: string;
  THiPedifa: string;
  L: TStringList;
begin
  Result := '';
  TPedid := 'pedidd' + FTienda;
  THiPedid := 'hipedidd' + FTienda;
  THiPedifa := 'hipedifadd' + FTienda;

  L := TStringList.Create;
  try
    if TablaExiste(TPedid) then
      L.Add('SELECT PD6 AS CODIGO, MAX(PD1) AS ULT_COMPRA, MAX(PD10) AS ULT_COSTE ' +
        'FROM `' + TPedid + '` WHERE PD2 = ' + IntToStr(CodProveedor) +
        ' AND TRIM(PD6) <> '''' GROUP BY PD6');

    if TablaExiste(THiPedid) then
      L.Add('SELECT HPD6 AS CODIGO, MAX(HPD1) AS ULT_COMPRA, MAX(HPD10) AS ULT_COSTE ' +
        'FROM `' + THiPedid + '` WHERE HPD2 = ' + IntToStr(CodProveedor) +
        ' AND TRIM(HPD6) <> '''' GROUP BY HPD6');

    if TablaExiste(THiPedifa) then
      L.Add('SELECT HPD6 AS CODIGO, MAX(HPD1) AS ULT_COMPRA, MAX(HPD10) AS ULT_COSTE ' +
        'FROM `' + THiPedifa + '` WHERE HPD2 = ' + IntToStr(CodProveedor) +
        ' AND TRIM(HPD6) <> '''' GROUP BY HPD6');

    if L.Count = 0 then Exit;

    Result := 'SELECT CODIGO, MAX(ULT_COMPRA) AS ULT_COMPRA, MAX(ULT_COSTE) AS ULT_COSTE ' +
      'FROM (' + StringReplace(Trim(L.Text), LineEnding, ' UNION ALL ', [rfReplaceAll]) +
      ') CP GROUP BY CODIGO';
  finally
    L.Free;
  end;
end;

function TfPedidoProveedorAuto.SQLVentas(const FechaDesdeHistorico,
  FechaHasta: TDateTime): string;
var
  THis: string;
begin
  Result := '';
  THis := 'hisopdd' + FTienda;

  if not TablaExiste(THis) then Exit;

  Result :=
    'SELECT CODIGO, ' +
    'SUM(CASE WHEN FECHA >= ' + FechaSQL(IncDay(FechaHasta, -seDiasVentas.Value + 1)) +
    ' THEN UDS ELSE 0 END) AS VENTAS_PERIODO, ' +
    'SUM(CASE WHEN FECHA < ' + FechaSQL(IncDay(FechaHasta, -seDiasVentas.Value + 1)) +
    ' THEN UDS ELSE 0 END) AS VENTAS_HISTORICO, ' +
    'MAX(FECHA) AS ULT_VENTA ' +
    'FROM (SELECT HOD6 AS CODIGO, HOD0 AS FECHA, ' +
    'CASE WHEN HOD8 > 0 THEN HOD8 ELSE 0 END AS UDS ' +
    'FROM `' + THis + '` WHERE HOD0 BETWEEN ' + FechaSQL(FechaDesdeHistorico) +
    ' AND ' + FechaSQL(FechaHasta) + ' AND TRIM(HOD6) <> '''') V ' +
    'GROUP BY CODIGO';
end;

function TfPedidoProveedorAuto.SQLFinal(const CodProveedor: Integer;
  const FechaDesdeHistorico, FechaHasta: TDateTime): string;
var
  ComprasSQL: string;
  VentasSQL: string;
  TArti: string;
begin
  Result := '';
  TArti := 'artitien' + FTienda;

  if not TablaExiste(TArti) then
  begin
    ShowMessage('No existe la tabla de artículos: ' + TArti);
    Exit;
  end;

  ComprasSQL := SQLComprasProveedor(CodProveedor);
  if ComprasSQL = '' then
  begin
    ShowMessage('No encuentro tablas de pedidos/histórico de compras para la tienda ' + FTienda + '.');
    Exit;
  end;

  VentasSQL := SQLVentas(FechaDesdeHistorico, FechaHasta);

  Result :=
    'SELECT A.A0 AS CODIGO, A.A1 AS DESCRIPCION, A.A2 AS PVP, A.A3 AS IVA, ' +
    'A.A4 AS STOCK_INFO, A.A13 AS ULT_COMPRA_FICHA, A.A14 AS FAMILIA, ' +
    'A.A24 AS COSTE_FICHA, CP.ULT_COMPRA, CP.ULT_COSTE, ';

  if VentasSQL <> '' then
    Result := Result +
      'COALESCE(V.VENTAS_PERIODO, 0) AS VENTAS_PERIODO, ' +
      'COALESCE(V.VENTAS_HISTORICO, 0) AS VENTAS_HISTORICO, V.ULT_VENTA '
  else
    Result := Result +
      '0 AS VENTAS_PERIODO, 0 AS VENTAS_HISTORICO, NULL AS ULT_VENTA ';

  Result := Result +
    'FROM (' + ComprasSQL + ') CP ' +
    'JOIN `' + TArti + '` A ON A.A0 = CP.CODIGO ';

  if VentasSQL <> '' then
    Result := Result + 'LEFT JOIN (' + VentasSQL + ') V ON V.CODIGO = A.A0 ';

  Result := Result + 'ORDER BY A.A1';
end;

procedure TfPedidoProveedorAuto.BtnCalcularClick(Sender: TObject);
var
  Q: TZQuery;
  SQL: string;
  CodProv: Integer;
  FechaHasta: TDateTime;
  FechaDesdeVentas: TDateTime;
  FechaDesdeHistorico: TDateTime;
  Factor: Double;
  VentasPeriodo: Double;
  VentasHistorico: Double;
  VentaDia: Double;
  Sugerido: Double;
  R: Integer;
  Estado: string;
  Obs: string;
  UltCompra: string;
  UltVenta: string;
  Coste: Double;
begin
  CodProv := CodigoProveedorSeleccionado;
  if CodProv <= 0 then
  begin
    ShowMessage('Seleccione un proveedor.');
    Exit;
  end;

  Factor := FloatSeguro(edtFactor.Text, 1.0);
  if Factor <= 0 then Factor := 1.0;

  FechaHasta := Date;
  FechaDesdeVentas := IncDay(FechaHasta, -seDiasVentas.Value + 1);
  FechaDesdeHistorico := IncDay(FechaDesdeVentas, -seDiasHistorico.Value);

  SQL := SQLFinal(CodProv, FechaDesdeHistorico, FechaHasta);
  if SQL = '' then Exit;

  InicializarGrid;
  lblEstado.Caption := 'Calculando propuesta para ' + NombreProveedorSeleccionado + '...';
  Application.ProcessMessages;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := SQL;
    Q.Open;

    R := 1;
    while not Q.EOF do
    begin
      VentasPeriodo := Q.FieldByName('VENTAS_PERIODO').AsFloat;
      VentasHistorico := Q.FieldByName('VENTAS_HISTORICO').AsFloat;

      if VentasPeriodo > 0 then
      begin
        VentaDia := VentasPeriodo / seDiasVentas.Value;
        Estado := 'VENTA RECIENTE';
        Obs := 'Cálculo basado en ventas recientes.';
      end
      else if VentasHistorico > 0 then
      begin
        VentaDia := VentasHistorico / seDiasHistorico.Value;
        Estado := 'POSIBLE ROTURA STOCK';
        Obs := 'Sin venta reciente, pero con histórico. Revisar posible falta de existencias.';
      end
      else
      begin
        VentaDia := 0;
        Estado := 'SIN VENTA';
        Obs := 'Comprado al proveedor, sin ventas en los periodos analizados.';
      end;

      Sugerido := RedondearArriba(VentaDia * seDiasCubrir.Value * Factor);

      if (Sugerido > 0) or chkMostrarCero.Checked then
      begin
        if R >= Grid.RowCount then
          Grid.RowCount := Grid.RowCount + 1;

        Coste := Q.FieldByName('ULT_COSTE').AsFloat;
        if Coste <= 0 then
          Coste := Q.FieldByName('COSTE_FICHA').AsFloat;

        UltCompra := '';
        if not Q.FieldByName('ULT_COMPRA').IsNull then
          UltCompra := DateToStr(Q.FieldByName('ULT_COMPRA').AsDateTime)
        else if not Q.FieldByName('ULT_COMPRA_FICHA').IsNull then
          UltCompra := DateToStr(Q.FieldByName('ULT_COMPRA_FICHA').AsDateTime);

        UltVenta := '';
        if not Q.FieldByName('ULT_VENTA').IsNull then
          UltVenta := DateToStr(Q.FieldByName('ULT_VENTA').AsDateTime);

        Grid.Cells[0, R] := Q.FieldByName('CODIGO').AsString;
        Grid.Cells[1, R] := Q.FieldByName('DESCRIPCION').AsString;
        Grid.Cells[2, R] := FormatFloat('0.##', VentasPeriodo);
        Grid.Cells[3, R] := FormatFloat('0.##', VentasHistorico);
        Grid.Cells[4, R] := FormatFloat('0.####', VentaDia);
        Grid.Cells[5, R] := FormatFloat('0.##', Sugerido);
        Grid.Cells[6, R] := UltVenta;
        Grid.Cells[7, R] := UltCompra;
        Grid.Cells[8, R] := FormatFloat('0.000', Coste);
        Grid.Cells[9, R] := FormatFloat('0.00', Q.FieldByName('PVP').AsFloat);
        Grid.Cells[10, R] := FormatFloat('0.##', Q.FieldByName('IVA').AsFloat);
        Grid.Cells[11, R] := FormatFloat('0.##', Q.FieldByName('STOCK_INFO').AsFloat);
        Grid.Cells[12, R] := Q.FieldByName('FAMILIA').AsString;
        Grid.Cells[13, R] := Estado;
        Grid.Cells[14, R] := Obs;
        Inc(R);
      end;

      Q.Next;
    end;
  finally
    Q.Free;
  end;

  if Grid.RowCount = 2 then
    Grid.Rows[1].Clear;

  AutoAjustarColumnas;
  lblEstado.Caption := 'Propuesta calculada. Líneas mostradas: ' + IntToStr(Grid.RowCount - 1) +
    '. Periodo ventas: ' + DateToStr(FechaDesdeVentas) + ' a ' + DateToStr(FechaHasta) + '.';
end;

procedure TfPedidoProveedorAuto.BtnExportarClick(Sender: TObject);
var
  SD: TSaveDialog;
  SL: TStringList;
  R: Integer;
  C: Integer;
  Linea: string;
begin
  if Grid.RowCount <= 1 then
  begin
    ShowMessage('No hay datos para exportar.');
    Exit;
  end;

  SD := TSaveDialog.Create(nil);
  SL := TStringList.Create;
  try
    SD.Filter := 'CSV (*.csv)|*.csv|Todos los ficheros|*.*';
    SD.DefaultExt := 'csv';
    SD.FileName := 'propuesta_pedido_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.csv';

    if not SD.Execute then Exit;

    for R := 0 to Grid.RowCount - 1 do
    begin
      Linea := '';
      for C := 0 to Grid.ColCount - 1 do
      begin
        if C > 0 then Linea := Linea + ';';
        Linea := Linea + CSVSeguro(Grid.Cells[C, R]);
      end;
      SL.Add(Linea);
    end;

    SL.SaveToFile(SD.FileName);
    ShowMessage('CSV exportado correctamente:' + LineEnding + SD.FileName);
  finally
    SL.Free;
    SD.Free;
  end;
end;

procedure TfPedidoProveedorAuto.BtnCerrarClick(Sender: TObject);
begin
  Close;
end;

function TfPedidoProveedorAuto.FloatSeguro(const S: string; const Def: Double): Double;
var
  T: string;
  FS: TFormatSettings;
begin
  T := Trim(S);
  if T = '' then Exit(Def);

  FS := DefaultFormatSettings;
  T := StringReplace(T, '.', FS.DecimalSeparator, [rfReplaceAll]);
  T := StringReplace(T, ',', FS.DecimalSeparator, [rfReplaceAll]);
  Result := StrToFloatDef(T, Def, FS);
end;

function TfPedidoProveedorAuto.RedondearArriba(const Valor: Double): Double;
begin
  if Valor <= 0 then
    Result := 0
  else
    Result := Ceil(Valor);
end;

function TfPedidoProveedorAuto.FechaSQL(const Fecha: TDateTime): string;
begin
  Result := QuotedStr(FormatDateTime('yyyy-mm-dd', Fecha));
end;

function TfPedidoProveedorAuto.CSVSeguro(const S: string): string;
var
  T: string;
begin
  T := StringReplace(S, '"', '""', [rfReplaceAll]);
  Result := '"' + T + '"';
end;

procedure TfPedidoProveedorAuto.AutoAjustarColumnas;
begin
  if Grid.ColCount < 15 then Exit;

  Grid.ColWidths[0] := 90;
  Grid.ColWidths[1] := 260;
  Grid.ColWidths[2] := 95;
  Grid.ColWidths[3] := 105;
  Grid.ColWidths[4] := 95;
  Grid.ColWidths[5] := 80;
  Grid.ColWidths[6] := 85;
  Grid.ColWidths[7] := 85;
  Grid.ColWidths[8] := 70;
  Grid.ColWidths[9] := 70;
  Grid.ColWidths[10] := 55;
  Grid.ColWidths[11] := 75;
  Grid.ColWidths[12] := 60;
  Grid.ColWidths[13] := 135;
  Grid.ColWidths[14] := 360;
end;

end.
