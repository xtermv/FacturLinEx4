unit uFLXIntelligenceEngine;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset;

type
  TFLXIntelPriority = (ipOK, ipBaja, ipAviso, ipMedia, ipAlta);

  TFLXIntelItem = class
  public
    Origen: string;
    Prioridad: TFLXIntelPriority;
    PrioridadTexto: string;
    Resumen: string;
    Detalle: string;
    Accion: string;
    Valor1: Double;
    Valor2: Double;
  end;

  TFLXIntelResults = class
  private
    FItems: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TFLXIntelItem;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(const AOrigen: string; APrioridad: TFLXIntelPriority;
      const AResumen, ADetalle, AAccion: string; AValor1: Double = 0; AValor2: Double = 0): TFLXIntelItem;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TFLXIntelItem read GetItem; default;
  end;

  { TFLXIntelligenceEngine }

  TFLXIntelligenceEngine = class
  private
    FConn: TZConnection;
    FTienda: string;
    FResults: TFLXIntelResults;
    function DBName: string;
    function CleanIdent(const S: string): string;
    function SQLIdent(const S: string): string;
    function TableName(const Prefix: string): string;
    function TableExists(const ATable: string): Boolean;
    function ColumnExists(const ATable, AColumn: string): Boolean;
    function ScalarInt(const ASQL: string; const ADefault: Integer = 0): Integer;
    function ScalarFloat(const ASQL: string; const ADefault: Double = 0): Double;
    function PrioText(APrio: TFLXIntelPriority): string;
    procedure AddItem(const AOrigen: string; APrioridad: TFLXIntelPriority;
      const AResumen, ADetalle, AAccion: string; AValor1: Double = 0; AValor2: Double = 0);
  public
    constructor Create(AConnection: TZConnection; const ATienda: string);
    destructor Destroy; override;

    procedure Clear;
    procedure RevisarTodo;
    procedure RevisarDoctor;
    procedure RevisarAlertas;
    procedure RevisarCompras;
    procedure RevisarRentabilidad;
    procedure RevisarVeriFactu;
    procedure RevisarMantenimiento;
    procedure RevisarPromociones;
    procedure RevisarClientes;

    property Results: TFLXIntelResults read FResults;
  end;

implementation

{ TFLXIntelResults }

constructor TFLXIntelResults.Create;
begin
  inherited Create;
  FItems := TList.Create;
end;

destructor TFLXIntelResults.Destroy;
begin
  Clear;
  FItems.Free;
  inherited Destroy;
end;

procedure TFLXIntelResults.Clear;
var
  I: Integer;
begin
  for I := FItems.Count - 1 downto 0 do
    TObject(FItems[I]).Free;
  FItems.Clear;
end;

function TFLXIntelResults.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TFLXIntelResults.GetItem(Index: Integer): TFLXIntelItem;
begin
  Result := TFLXIntelItem(FItems[Index]);
end;

function TFLXIntelResults.Add(const AOrigen: string; APrioridad: TFLXIntelPriority;
  const AResumen, ADetalle, AAccion: string; AValor1: Double; AValor2: Double): TFLXIntelItem;
begin
  Result := TFLXIntelItem.Create;
  Result.Origen := AOrigen;
  Result.Prioridad := APrioridad;
  case APrioridad of
    ipAlta:  Result.PrioridadTexto := 'ALTA';
    ipMedia: Result.PrioridadTexto := 'MEDIA';
    ipAviso: Result.PrioridadTexto := 'AVISO';
    ipBaja:  Result.PrioridadTexto := 'BAJA';
  else
    Result.PrioridadTexto := 'OK';
  end;
  Result.Resumen := AResumen;
  Result.Detalle := ADetalle;
  Result.Accion := AAccion;
  Result.Valor1 := AValor1;
  Result.Valor2 := AValor2;
  FItems.Add(Result);
end;

{ TFLXIntelligenceEngine }

constructor TFLXIntelligenceEngine.Create(AConnection: TZConnection; const ATienda: string);
begin
  inherited Create;
  FConn := AConnection;
  FTienda := ATienda;
  FResults := TFLXIntelResults.Create;
end;

destructor TFLXIntelligenceEngine.Destroy;
begin
  FResults.Free;
  inherited Destroy;
end;

procedure TFLXIntelligenceEngine.Clear;
begin
  FResults.Clear;
end;

function TFLXIntelligenceEngine.CleanIdent(const S: string): string;
begin
  Result := StringReplace(S, '`', '', [rfReplaceAll]);
end;

function TFLXIntelligenceEngine.SQLIdent(const S: string): string;
begin
  Result := '`' + CleanIdent(S) + '`';
end;

function TFLXIntelligenceEngine.DBName: string;
begin
  Result := '';
  if Assigned(FConn) then
    Result := FConn.Database;
end;

function TFLXIntelligenceEngine.TableName(const Prefix: string): string;
begin
  Result := Prefix + FTienda;
end;

function TFLXIntelligenceEngine.TableExists(const ATable: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (not Assigned(FConn)) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.TABLES ' +
      'WHERE TABLE_SCHEMA = :DB AND TABLE_NAME = :T';
    Q.ParamByName('DB').AsString := DBName;
    Q.ParamByName('T').AsString := CleanIdent(ATable);
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TFLXIntelligenceEngine.ColumnExists(const ATable, AColumn: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (not Assigned(FConn)) or (not FConn.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.COLUMNS ' +
      'WHERE TABLE_SCHEMA = :DB AND TABLE_NAME = :T AND COLUMN_NAME = :C';
    Q.ParamByName('DB').AsString := DBName;
    Q.ParamByName('T').AsString := CleanIdent(ATable);
    Q.ParamByName('C').AsString := CleanIdent(AColumn);
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TFLXIntelligenceEngine.ScalarInt(const ASQL: string; const ADefault: Integer): Integer;
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
    if not Q.EOF then
      Result := Q.Fields[0].AsInteger;
  except
    Result := ADefault;
  end;
  Q.Free;
end;

function TFLXIntelligenceEngine.ScalarFloat(const ASQL: string; const ADefault: Double): Double;
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
    if not Q.EOF then
      Result := Q.Fields[0].AsFloat;
  except
    Result := ADefault;
  end;
  Q.Free;
end;

function TFLXIntelligenceEngine.PrioText(APrio: TFLXIntelPriority): string;
begin
  case APrio of
    ipAlta:  Result := 'ALTA';
    ipMedia: Result := 'MEDIA';
    ipAviso: Result := 'AVISO';
    ipBaja:  Result := 'BAJA';
  else
    Result := 'OK';
  end;
end;

procedure TFLXIntelligenceEngine.AddItem(const AOrigen: string; APrioridad: TFLXIntelPriority;
  const AResumen, ADetalle, AAccion: string; AValor1: Double; AValor2: Double);
begin
  FResults.Add(AOrigen, APrioridad, AResumen, ADetalle, AAccion, AValor1, AValor2);
end;

procedure TFLXIntelligenceEngine.RevisarTodo;
begin
  Clear;
  RevisarMantenimiento;
  RevisarDoctor;
  RevisarAlertas;
  RevisarCompras;
  RevisarRentabilidad;
  RevisarVeriFactu;
end;

procedure TFLXIntelligenceEngine.RevisarMantenimiento;
begin
  if not Assigned(FConn) then
  begin
    AddItem('Mantenimiento', ipAlta, 'Sin conexión asignada', 'No se ha recibido conexión de base de datos.', 'Revisar llamada al motor');
    Exit;
  end;

  if not FConn.Connected then
  begin
    AddItem('Mantenimiento', ipAlta, 'Base de datos desconectada', 'La conexión MariaDB no está activa.', 'Revisar conexión');
    Exit;
  end;

  AddItem('Mantenimiento', ipOK, 'Conexión BBDD correcta', 'Conectado a ' + DBName + '.', 'Sin acción');
end;

procedure TFLXIntelligenceEngine.RevisarDoctor;
var
  TArt, TPromo: string;
  N: Integer;
begin
  TArt := TableName('artitien');
  if not TableExists(TArt) then
  begin
    AddItem('Doctor', ipAlta, 'No existe tabla de artículos', TArt + ' no existe.', 'Revisar tienda/configuración');
    Exit;
  end;

  if ColumnExists(TArt, 'A32') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TArt) + ' WHERE IFNULL(A32,'''') = ''''');
    if N > 0 then
      AddItem('Doctor', ipMedia, IntToStr(N) + ' artículos sin proveedor', 'Artículos con A32 vacío.', 'Revisar ficha de artículos', N);
  end;

  if ColumnExists(TArt, 'A14') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TArt) + ' WHERE IFNULL(A14,0) = 0');
    if N > 0 then
      AddItem('Doctor', ipBaja, IntToStr(N) + ' artículos sin familia', 'Artículos con A14 vacío o cero.', 'Revisar familias', N);
  end;

  TPromo := TableName('promo');
  if TableExists(TPromo) then
    AddItem('Doctor', ipOK, 'Tabla de promociones localizada', TPromo + ' existe.', 'Sin acción')
  else
    AddItem('Doctor', ipAviso, 'No localizada tabla de promociones', TPromo + ' no existe.', 'Revisar si el módulo promociones está activo');
end;

procedure TFLXIntelligenceEngine.RevisarAlertas;
begin
  RevisarPromociones;
  RevisarClientes;
end;

procedure TFLXIntelligenceEngine.RevisarPromociones;
var
  TPromo: string;
  N: Integer;
begin
  TPromo := TableName('promo');
  if not TableExists(TPromo) then Exit;

  { Comprobación defensiva: se ejecuta solo si existen campos habituales. }
  if ColumnExists(TPromo, 'P0') and ColumnExists(TPromo, 'P1') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TPromo) + ' WHERE IFNULL(P0,'''') = ''''');
    if N > 0 then
      AddItem('Promociones', ipBaja, IntToStr(N) + ' promociones sin código', 'Promociones con identificador vacío.', 'Revisar promociones', N);
  end;
end;

procedure TFLXIntelligenceEngine.RevisarClientes;
var
  N: Integer;
begin
  if not TableExists('clientes') then
  begin
    AddItem('Clientes', ipAlta, 'No existe tabla clientes', 'La tabla clientes no está disponible.', 'Revisar BBDD');
    Exit;
  end;

  if ColumnExists('clientes', 'CIF') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM clientes WHERE IFNULL(CIF,'''') = ''''');
    if N > 0 then
      AddItem('Clientes', ipBaja, IntToStr(N) + ' clientes sin NIF/CIF', 'Clientes con CIF vacío.', 'Revisar fichas de clientes', N);
  end;
end;

procedure TFLXIntelligenceEngine.RevisarCompras;
var
  THPed, TUlt, TArt: string;
  N: Integer;
begin
  THPed := TableName('hipedidd');
  TUlt := TableName('ultimopedi');
  TArt := TableName('artitien');

  if TableExists(THPed) then
  begin
    N := ScalarInt('SELECT COUNT(DISTINCT HPD6) FROM ' + SQLIdent(THPed) + ' WHERE HPD1 >= DATE_SUB(CURDATE(), INTERVAL 365 DAY)');
    AddItem('Compras', ipOK, IntToStr(N) + ' artículos con compras último año', 'Fuente: ' + THPed + '.', 'Abrir Asesor Compras', N);
  end
  else if TableExists(TUlt) then
  begin
    N := ScalarInt('SELECT COUNT(DISTINCT AP0) FROM ' + SQLIdent(TUlt));
    AddItem('Compras', ipAviso, IntToStr(N) + ' artículos en histórico último pedido', 'No se localizó ' + THPed + ', se usará ' + TUlt + '.', 'Revisar Asesor Compras', N);
  end
  else
    AddItem('Compras', ipAviso, 'Sin histórico de compras localizado', 'No se localizaron ' + THPed + ' ni ' + TUlt + '.', 'Revisar tablas de compras');

  if TableExists(TArt) and ColumnExists(TArt, 'A32') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TArt) + ' WHERE IFNULL(A32,'''') = ''''');
    if N > 0 then
      AddItem('Compras', ipMedia, IntToStr(N) + ' artículos sin proveedor habitual', 'El Asesor perderá precisión en esos artículos.', 'Completar proveedor en ficha', N);
  end;
end;

procedure TFLXIntelligenceEngine.RevisarRentabilidad;
var
  TArt: string;
  N: Integer;
begin
  TArt := TableName('artitien');
  if not TableExists(TArt) then Exit;

  { Campos de coste/PVP varían entre instalaciones; por eso solo se informa si se detectan. }
  if ColumnExists(TArt, 'A7') and ColumnExists(TArt, 'A8') then
  begin
    N := ScalarInt('SELECT COUNT(*) FROM ' + SQLIdent(TArt) + ' WHERE IFNULL(A8,0) > 0 AND IFNULL(A7,0) > IFNULL(A8,0)');
    if N > 0 then
      AddItem('Rentabilidad', ipAlta, IntToStr(N) + ' artículos con posible margen negativo', 'Coste superior al PVP según campos detectados A7/A8.', 'Revisar rentabilidad', N)
    else
      AddItem('Rentabilidad', ipOK, 'Sin márgenes negativos detectados', 'Comprobación básica A7/A8 correcta.', 'Sin acción');
  end
  else
    AddItem('Rentabilidad', ipAviso, 'Rentabilidad pendiente de campos reales', 'No se han detectado A7/A8 para la comprobación básica.', 'Revisar módulo Rentabilidad');
end;

procedure TFLXIntelligenceEngine.RevisarVeriFactu;
var
  N: Integer;
begin
  if not TableExists('verifactu_queue') then
  begin
    AddItem('VeriFactu', ipAviso, 'Tabla verifactu_queue no localizada', 'No se puede revisar cola VeriFactu desde el motor.', 'Revisar instalación VeriFactu');
    Exit;
  end;

  N := ScalarInt('SELECT COUNT(*) FROM verifactu_queue WHERE estado IN (''PENDIENTE'',''EN_PROCESO'',''ERROR_TECNICO'')');
  if N > 0 then
    AddItem('VeriFactu', ipAlta, IntToStr(N) + ' documentos VeriFactu pendientes/bloqueantes', 'Estados PENDIENTE, EN_PROCESO o ERROR_TECNICO.', 'Abrir monitor VeriFactu', N)
  else
    AddItem('VeriFactu', ipOK, 'VeriFactu sin pendientes bloqueantes', 'No se detectan estados pendientes o técnicos bloqueantes.', 'Sin acción');
end;

end.
