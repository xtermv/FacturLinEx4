unit uBuscarVentaArticuloAbonoV13;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DateUtils, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, DBGrids, DB,
  ZDataset, ZAbstractConnection;

type
  TAbonoVentaOrigen = record
    OrigTipo: string;
    OrigSerie: string;
    OrigNumero: Integer;
    OrigFecha: string;
    OrigHora: string;
    OrigFechaDT: TDateTime;
    OrigHoraDT: TDateTime;
    OrigCaja: string;
    OrigLinea: Integer;
    Codigo: string;
    Descripcion: string;
    Cliente: string;
    NIF: string;
    CantidadOriginal: Double;
    CantidadYaRectificada: Double;
    CantidadDisponible: Double;
    PVP: Double;
    PrecioSinIVA: Double;
    Dto: Double;
    ImporteSinIVA: Double;
    IVA: Double;
    Total: Double;
  end;

function BuscarVentaArticuloAbono(AOwner: TComponent; AConnection: TZAbstractConnection;
  const ATienda, ACodigo, ADescripcion, AClienteActual, ANIFActual: string;
  const AMeses: Integer; out AResultado: TAbonoVentaOrigen): Boolean;

implementation

type
  TFBuscarVentaArticuloAbono = class(TForm)
  private
    FConnection: TZAbstractConnection;
    FTienda: string;
    FCodigo: string;
    FDescripcion: string;
    FClienteActual: string;
    FNIFActual: string;
    FMeses: Integer;
    FResultado: TAbonoVentaOrigen;

    Q: TZQuery;
    DS: TDataSource;
    PanelTop: TPanel;
    PanelBottom: TPanel;
    LblTitulo: TLabel;
    LblInfo: TLabel;
    ChkFiltrarCliente: TCheckBox;
    Grid: TDBGrid;
    BtnAceptar: TBitBtn;
    BtnCancelar: TBitBtn;
    BtnRefrescar: TBitBtn;

    function SafeSuffix(const S: string): string;
    function HayFiltroCliente: Boolean;
    procedure ExecBuscar;
    procedure ConfigurarColumnas;
    procedure RellenarResultadoDesdeQuery;
    procedure BtnAceptarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnRefrescarClick(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure FormKeyDownLocal(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Inicia(AConnection: TZAbstractConnection; const ATienda, ACodigo,
      ADescripcion, AClienteActual, ANIFActual: string; const AMeses: Integer);
    property Resultado: TAbonoVentaOrigen read FResultado;
  end;

const
  KEY_RETURN_LOCAL = 13;
  KEY_ESCAPE_LOCAL = 27;

function SQLTableSuffixSafe(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
  begin
    if S[i] in ['0'..'9','A'..'Z','a'..'z','_'] then
      Result := Result + S[i];
  end;
end;

procedure ClearAbonoVentaOrigen(var R: TAbonoVentaOrigen);
begin
  R.OrigTipo := '';
  R.OrigSerie := '';
  R.OrigNumero := 0;
  R.OrigFecha := '';
  R.OrigHora := '';
  R.OrigFechaDT := 0;
  R.OrigHoraDT := 0;
  R.OrigCaja := '';
  R.OrigLinea := 0;
  R.Codigo := '';
  R.Descripcion := '';
  R.Cliente := '';
  R.NIF := '';
  R.CantidadOriginal := 0;
  R.CantidadYaRectificada := 0;
  R.CantidadDisponible := 0;
  R.PVP := 0;
  R.PrecioSinIVA := 0;
  R.Dto := 0;
  R.ImporteSinIVA := 0;
  R.IVA := 0;
  R.Total := 0;
end;

constructor TFBuscarVentaArticuloAbono.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner, 0);

  Caption := 'Buscar venta para abono';
  Position := poScreenCenter;
  Width := 980;
  Height := 560;
  BorderStyle := bsSizeable;
  KeyPreview := True;
  OnKeyDown := @FormKeyDownLocal;

  PanelTop := TPanel.Create(Self);
  PanelTop.Parent := Self;
  PanelTop.Align := alTop;
  PanelTop.Height := 78;
  PanelTop.BevelOuter := bvNone;

  LblTitulo := TLabel.Create(Self);
  LblTitulo.Parent := PanelTop;
  LblTitulo.Left := 12;
  LblTitulo.Top := 10;
  LblTitulo.AutoSize := True;
  LblTitulo.Font.Style := [fsBold];
  LblTitulo.Caption := 'Articulo';

  LblInfo := TLabel.Create(Self);
  LblInfo.Parent := PanelTop;
  LblInfo.Left := 12;
  LblInfo.Top := 36;
  LblInfo.AutoSize := True;
  LblInfo.Caption := 'Buscando ventas de los ultimos 3 meses...';

  ChkFiltrarCliente := TCheckBox.Create(Self);
  ChkFiltrarCliente.Parent := PanelTop;
  ChkFiltrarCliente.Left := 680;
  ChkFiltrarCliente.Top := 34;
  ChkFiltrarCliente.Width := 280;
  ChkFiltrarCliente.Caption := 'Filtrar por cliente actual';
  ChkFiltrarCliente.Checked := False;
  ChkFiltrarCliente.OnClick := @BtnRefrescarClick;

  PanelBottom := TPanel.Create(Self);
  PanelBottom.Parent := Self;
  PanelBottom.Align := alBottom;
  PanelBottom.Height := 48;
  PanelBottom.BevelOuter := bvNone;

  BtnAceptar := TBitBtn.Create(Self);
  BtnAceptar.Parent := PanelBottom;
  BtnAceptar.Caption := 'Usar origen';
  BtnAceptar.Left := 640;
  BtnAceptar.Top := 8;
  BtnAceptar.Width := 120;
  BtnAceptar.Height := 32;
  BtnAceptar.Default := True;
  BtnAceptar.OnClick := @BtnAceptarClick;

  BtnRefrescar := TBitBtn.Create(Self);
  BtnRefrescar.Parent := PanelBottom;
  BtnRefrescar.Caption := 'Refrescar';
  BtnRefrescar.Left := 510;
  BtnRefrescar.Top := 8;
  BtnRefrescar.Width := 110;
  BtnRefrescar.Height := 32;
  BtnRefrescar.OnClick := @BtnRefrescarClick;

  BtnCancelar := TBitBtn.Create(Self);
  BtnCancelar.Parent := PanelBottom;
  BtnCancelar.Caption := 'Cancelar';
  BtnCancelar.Left := 780;
  BtnCancelar.Top := 8;
  BtnCancelar.Width := 110;
  BtnCancelar.Height := 32;
  BtnCancelar.Cancel := True;
  BtnCancelar.OnClick := @BtnCancelarClick;

  Grid := TDBGrid.Create(Self);
  Grid.Parent := Self;
  Grid.Align := alClient;
  Grid.Options := Grid.Options + [dgRowSelect, dgAlwaysShowSelection, dgDisplayMemoText] - [dgEditing];
  Grid.OnDblClick := @GridDblClick;

  Q := TZQuery.Create(Self);
  DS := TDataSource.Create(Self);
  DS.DataSet := Q;
  Grid.DataSource := DS;
end;

destructor TFBuscarVentaArticuloAbono.Destroy;
begin
  inherited Destroy;
end;

function TFBuscarVentaArticuloAbono.SafeSuffix(const S: string): string;
begin
  Result := SQLTableSuffixSafe(S);
end;

function TFBuscarVentaArticuloAbono.HayFiltroCliente: Boolean;
begin
  Result := ChkFiltrarCliente.Checked and
    ((Trim(FClienteActual) <> '') or (Trim(FNIFActual) <> ''));
end;

procedure TFBuscarVentaArticuloAbono.Inicia(AConnection: TZAbstractConnection;
  const ATienda, ACodigo, ADescripcion, AClienteActual, ANIFActual: string;
  const AMeses: Integer);
begin
  FConnection := AConnection;
  FTienda := SafeSuffix(ATienda);
  FCodigo := Trim(ACodigo);
  FDescripcion := Trim(ADescripcion);
  FClienteActual := Trim(AClienteActual);
  FNIFActual := Trim(ANIFActual);
  FMeses := AMeses;
  if FMeses <= 0 then FMeses := 3;

  ChkFiltrarCliente.Enabled := (FClienteActual <> '') or (FNIFActual <> '');
  if not ChkFiltrarCliente.Enabled then
    ChkFiltrarCliente.Caption := 'Sin cliente/NIF para filtrar';

  LblTitulo.Caption := 'Articulo ' + FCodigo;
  if FDescripcion <> '' then
    LblTitulo.Caption := LblTitulo.Caption + ' - ' + FDescripcion;

  ExecBuscar;
end;

procedure TFBuscarVentaArticuloAbono.ExecBuscar;
var
  SQLTxt, ClienteCond, FechaMin, ListaParams: string;
  N, i: Integer;
  Codigos: TStringList;
  QCod: TZQuery;

  procedure AddCodigo(const S: string);
  var
    T: string;
  begin
    T := Trim(S);
    if T = '' then Exit;
    if Codigos.IndexOf(T) < 0 then
      Codigos.Add(T);
  end;

begin
  if FConnection = nil then
  begin
    LblInfo.Caption := 'No hay conexion disponible.';
    Exit;
  end;

  if FCodigo = '' then
  begin
    LblInfo.Caption := 'No hay codigo de articulo.';
    Exit;
  end;

  ClienteCond := '';
  if HayFiltroCliente then
  begin
    ClienteCond := ' AND (';
    if FClienteActual <> '' then
      ClienteCond := ClienteCond + 'c.HO8=:CLIENTE';
    if FNIFActual <> '' then
    begin
      if FClienteActual <> '' then
        ClienteCond := ClienteCond + ' OR ';
      ClienteCond := ClienteCond + 'c.HO19=:NIF';
    end;
    ClienteCond := ClienteCond + ')';
  end;

  FechaMin := FormatDateTime('yyyy-mm-dd', IncMonth(Date, -FMeses));

  // Construimos una lista de códigos equivalentes para buscar la venta real:
  // - código tecleado/escaneado
  // - si es EAN/auxiliar (EAN0), su principal (EAN1)
  // - si es principal (A0/EAN1), todos sus EAN/auxiliares (EAN0)
  // - si era un EAN, también el resto de EAN del mismo principal
  Codigos := TStringList.Create;
  QCod := TZQuery.Create(nil);
  try
    AddCodigo(FCodigo);
    QCod.Connection := FConnection;

    // Caso 1: FCodigo es auxiliar/EAN. Obtenemos principal.
    try
      QCod.Close;
      QCod.SQL.Text := 'SELECT EAN1 FROM eans WHERE EAN0=:CODIGO LIMIT 1';
      QCod.ParamByName('CODIGO').AsString := FCodigo;
      QCod.Open;
      if not QCod.IsEmpty then
        AddCodigo(QCod.FieldByName('EAN1').AsString);
    except
      // Si la tabla eans no existe o falla, continuamos buscando por código original.
    end;

    // Caso 2: FCodigo es principal. Obtenemos auxiliares directos.
    try
      QCod.Close;
      QCod.SQL.Text := 'SELECT EAN0 FROM eans WHERE EAN1=:CODIGO';
      QCod.ParamByName('CODIGO').AsString := FCodigo;
      QCod.Open;
      while not QCod.EOF do
      begin
        AddCodigo(QCod.FieldByName('EAN0').AsString);
        QCod.Next;
      end;
    except
      // Si falla, continuamos con los códigos ya disponibles.
    end;

    // Caso 3: si FCodigo era EAN, buscamos otros EAN del mismo principal.
    if Codigos.Count > 1 then
    begin
      try
        QCod.Close;
        QCod.SQL.Text :=
          'SELECT EAN0 FROM eans WHERE EAN1 IN (' +
          'SELECT EAN1 FROM eans WHERE EAN0=:CODIGO)';
        QCod.ParamByName('CODIGO').AsString := FCodigo;
        QCod.Open;
        while not QCod.EOF do
        begin
          AddCodigo(QCod.FieldByName('EAN0').AsString);
          QCod.Next;
        end;
      except
      end;
    end;

    ListaParams := '';
    for i := 0 to Codigos.Count - 1 do
    begin
      if ListaParams <> '' then ListaParams := ListaParams + ',';
      ListaParams := ListaParams + ':CODIGO' + IntToStr(i);
    end;
    if ListaParams = '' then
      ListaParams := ':CODIGO0';

  SQLTxt :=
    'SELECT c.HO0 AS FECHA, c.HO1 AS HORA, c.HO2 AS CAJA, c.HO5 AS TIPO, ' +
    'c.HO4 AS SERIE, c.HO3 AS NUMERO, c.HO8 AS CLIENTE, c.HO19 AS NIF, ' +
    'd.HOD5 AS LINEA, d.HOD6 AS CODIGO, CAST(CONVERT(d.HOD7 USING UTF8) AS CHAR(255)) AS DESCRIPCION, ' +
    'd.HOD8 AS CANTIDAD, ' +
    'ABS(COALESCE((SELECT SUM(l.RL_QTY_RECTIFICADA) FROM rectiflin' + FTienda + ' l ' +
    ' WHERE l.RL_ORIG_TIPO=c.HO5 ' +
    ' AND l.RL_ORIG_FECHA=c.HO0 ' +
    ' AND l.RL_ORIG_HORA=c.HO1 ' +
    ' AND l.RL_ORIG_CAJA=c.HO2 ' +
    ' AND l.RL_ORIG_SERIE=c.HO4 ' +
    ' AND l.RL_ORIG_NUMERO=c.HO3 ' +
    ' AND l.RL_ORIG_LINEA=d.HOD5),0)) AS YA_RECTIFICADO, ' +
    'GREATEST(0, d.HOD8 - ABS(COALESCE((SELECT SUM(l2.RL_QTY_RECTIFICADA) FROM rectiflin' + FTienda + ' l2 ' +
    ' WHERE l2.RL_ORIG_TIPO=c.HO5 ' +
    ' AND l2.RL_ORIG_FECHA=c.HO0 ' +
    ' AND l2.RL_ORIG_HORA=c.HO1 ' +
    ' AND l2.RL_ORIG_CAJA=c.HO2 ' +
    ' AND l2.RL_ORIG_SERIE=c.HO4 ' +
    ' AND l2.RL_ORIG_NUMERO=c.HO3 ' +
    ' AND l2.RL_ORIG_LINEA=d.HOD5),0))) AS DISPONIBLE, ' +
    'd.HOD9 AS PVP, d.HOD10 AS PRECIO_SIN_IVA, d.HOD11 AS DTO, ' +
    'd.HOD12 AS IMPORTE_SIN_IVA, d.HOD13 AS IVA, d.HOD14 AS TOTAL ' +
    'FROM hisopdd' + FTienda + ' d ' +
    'JOIN hisopcc' + FTienda + ' c ON c.HO0=d.HOD0 AND c.HO1=d.HOD1 ' +
    ' AND c.HO2=d.HOD2 AND c.HO3=d.HOD3 AND c.HO4=d.HOD4 ' +
    'WHERE d.HOD6 IN (' + ListaParams + ') ' +
    ' AND d.HOD8>0 ' +
    ' AND d.HOD14>0 ' +
    ' AND c.HO5 IN ("NS","NT","FA") ' +
    ' AND c.HO0>=:FECHAMIN ' + ClienteCond +
    ' ORDER BY c.HO0 DESC, c.HO1 DESC, c.HO3 DESC, d.HOD5 ' +
    ' LIMIT 100';

  try
    Q.Close;
    Q.Connection := FConnection;
    Q.SQL.Text := SQLTxt;
    for i := 0 to Codigos.Count - 1 do
      Q.ParamByName('CODIGO' + IntToStr(i)).AsString := Codigos[i];
    Q.ParamByName('FECHAMIN').AsString := FechaMin;
    if HayFiltroCliente then
    begin
      if FClienteActual <> '' then
        Q.ParamByName('CLIENTE').AsString := FClienteActual;
      if FNIFActual <> '' then
        Q.ParamByName('NIF').AsString := FNIFActual;
    end;
    Q.Open;
    ConfigurarColumnas;

    N := 0;
    if not Q.IsEmpty then
    begin
      Q.Last;
      N := Q.RecordCount;
      Q.First;
    end;

    if N = 0 then
      LblInfo.Caption := 'Sin ventas encontradas desde ' + FechaMin + '. Revise codigo/EAN o quite filtro de cliente.'
    else
      LblInfo.Caption := 'Resultados: ' + IntToStr(N) + '  |  Códigos buscados: ' + IntToStr(Codigos.Count) +
        '  |  Doble clic o "Usar origen". Solo se permite si hay cantidad disponible.';
  except
    on E: Exception do
    begin
      LblInfo.Caption := 'Error buscando ventas: ' + E.Message;
      MessageDlg('Buscar venta para abono',
        'No se pudo consultar el historico.' + LineEnding + LineEnding + E.Message,
        mtWarning, [mbOK], 0);
    end;
  end;
  finally
    QCod.Free;
    Codigos.Free;
  end;
end;

procedure TFBuscarVentaArticuloAbono.ConfigurarColumnas;

  procedure AddCol(const AField, ATitle: string; AWidth: Integer);
  var
    C: TColumn;
  begin
    C := Grid.Columns.Add;
    C.FieldName := AField;
    C.Title.Caption := ATitle;
    C.Width := AWidth;
  end;

begin
  Grid.Columns.Clear;
  if Q.FieldCount = 0 then Exit;

  AddCol('FECHA', 'Fecha', 80);
  AddCol('HORA', 'Hora', 70);
  AddCol('CAJA', 'Caja', 55);
  AddCol('TIPO', 'Tipo', 45);
  AddCol('SERIE', 'Serie', 60);
  AddCol('NUMERO', 'Numero', 70);
  AddCol('LINEA', 'Linea', 50);
  AddCol('CLIENTE', 'Cliente', 70);
  AddCol('CODIGO', 'Codigo', 95);
  AddCol('DESCRIPCION', 'Descripcion', 240);
  AddCol('CANTIDAD', 'Vendida', 70);
  AddCol('YA_RECTIFICADO', 'Ya abon.', 70);
  AddCol('DISPONIBLE', 'Disponible', 80);
  AddCol('PVP', 'PVP', 70);
  AddCol('DTO', 'Dto%', 55);
  AddCol('IVA', 'IVA', 50);
  AddCol('TOTAL', 'Total', 80);
end;

procedure TFBuscarVentaArticuloAbono.RellenarResultadoDesdeQuery;
begin
  ClearAbonoVentaOrigen(FResultado);

  FResultado.OrigTipo := Trim(UpperCase(Q.FieldByName('TIPO').AsString));
  FResultado.OrigSerie := Trim(Q.FieldByName('SERIE').AsString);
  FResultado.OrigNumero := Q.FieldByName('NUMERO').AsInteger;
  FResultado.OrigFecha := Q.FieldByName('FECHA').AsString;
  FResultado.OrigHora := Q.FieldByName('HORA').AsString;
  FResultado.OrigFechaDT := Q.FieldByName('FECHA').AsDateTime;
  FResultado.OrigHoraDT := Q.FieldByName('HORA').AsDateTime;
  FResultado.OrigCaja := Trim(Q.FieldByName('CAJA').AsString);
  FResultado.OrigLinea := Q.FieldByName('LINEA').AsInteger;
  FResultado.Codigo := Trim(Q.FieldByName('CODIGO').AsString);
  FResultado.Descripcion := Trim(Q.FieldByName('DESCRIPCION').AsString);
  FResultado.Cliente := Trim(Q.FieldByName('CLIENTE').AsString);
  FResultado.NIF := Trim(Q.FieldByName('NIF').AsString);
  FResultado.CantidadOriginal := Q.FieldByName('CANTIDAD').AsFloat;
  FResultado.CantidadYaRectificada := Q.FieldByName('YA_RECTIFICADO').AsFloat;
  FResultado.CantidadDisponible := Q.FieldByName('DISPONIBLE').AsFloat;
  FResultado.PVP := Q.FieldByName('PVP').AsFloat;
  FResultado.PrecioSinIVA := Q.FieldByName('PRECIO_SIN_IVA').AsFloat;
  FResultado.Dto := Q.FieldByName('DTO').AsFloat;
  FResultado.ImporteSinIVA := Q.FieldByName('IMPORTE_SIN_IVA').AsFloat;
  FResultado.IVA := Q.FieldByName('IVA').AsFloat;
  FResultado.Total := Q.FieldByName('TOTAL').AsFloat;
end;

procedure TFBuscarVentaArticuloAbono.BtnAceptarClick(Sender: TObject);
begin
  if (Q = nil) or (not Q.Active) or Q.IsEmpty then Exit;

  if Q.FieldByName('DISPONIBLE').AsFloat <= 0.0001 then
  begin
    MessageDlg('Control de abonos',
      'Esta linea ya no tiene cantidad disponible para abonar.' + LineEnding +
      'Seleccione otra venta/linea.', mtWarning, [mbOK], 0);
    Exit;
  end;

  RellenarResultadoDesdeQuery;
  ModalResult := mrOk;
end;

procedure TFBuscarVentaArticuloAbono.BtnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFBuscarVentaArticuloAbono.BtnRefrescarClick(Sender: TObject);
begin
  ExecBuscar;
end;

procedure TFBuscarVentaArticuloAbono.GridDblClick(Sender: TObject);
begin
  BtnAceptarClick(Sender);
end;

procedure TFBuscarVentaArticuloAbono.FormKeyDownLocal(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = KEY_ESCAPE_LOCAL then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end
  else if Key = KEY_RETURN_LOCAL then
  begin
    Key := 0;
    BtnAceptarClick(Sender);
  end;
end;

function BuscarVentaArticuloAbono(AOwner: TComponent; AConnection: TZAbstractConnection;
  const ATienda, ACodigo, ADescripcion, AClienteActual, ANIFActual: string;
  const AMeses: Integer; out AResultado: TAbonoVentaOrigen): Boolean;
var
  F: TFBuscarVentaArticuloAbono;
begin
  Result := False;
  ClearAbonoVentaOrigen(AResultado);

  F := TFBuscarVentaArticuloAbono.Create(AOwner);
  try
    F.Inicia(AConnection, ATienda, ACodigo, ADescripcion, AClienteActual, ANIFActual, AMeses);
    if F.ShowModal = mrOk then
    begin
      AResultado := F.Resultado;
      Result := True;
    end;
  finally
    F.Free;
  end;
end;

end.
