unit uFLXSchemaAudit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, uFLXAuditTypes;

type
  TFLXSchemaProgressEvent = procedure(APercent: Integer; const AMessage: string) of object;

  TFLXSchemaAudit = class
  private
    FConnection: TZConnection;
    FReport: TFLXAuditReport;
    FOnProgress: TFLXSchemaProgressEvent;
    procedure NotifyProgress(APercent: Integer; const AMessage: string);
    function TableExists(const ATable: string): Boolean;
    function ColumnExists(const ATable, AColumn: string): Boolean;
    function IndexExists(const ATable, AIndex: string): Boolean;
  public
    constructor Create(AConnection: TZConnection; AReport: TFLXAuditReport);
    procedure Run;
    procedure ExportInventory(const AFileName: string);
    property OnProgress: TFLXSchemaProgressEvent read FOnProgress write FOnProgress;
  end;

implementation


procedure TFLXSchemaAudit.NotifyProgress(APercent: Integer; const AMessage: string);
begin
  if Assigned(FOnProgress) then
    FOnProgress(APercent, AMessage);
end;

constructor TFLXSchemaAudit.Create(AConnection: TZConnection;
  AReport: TFLXAuditReport);
begin
  inherited Create;
  FConnection := AConnection;
  FReport := AReport;
end;

function TFLXSchemaAudit.TableExists(const ATable: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (FConnection = nil) or (not FConnection.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConnection;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS n FROM information_schema.TABLES ' +
      'WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=:t';
    Q.ParamByName('t').AsString := ATable;
    Q.Open;
    Result := Q.FieldByName('n').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TFLXSchemaAudit.ColumnExists(const ATable, AColumn: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (FConnection = nil) or (not FConnection.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConnection;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS n FROM information_schema.COLUMNS ' +
      'WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=:t AND COLUMN_NAME=:c';
    Q.ParamByName('t').AsString := ATable;
    Q.ParamByName('c').AsString := AColumn;
    Q.Open;
    Result := Q.FieldByName('n').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TFLXSchemaAudit.IndexExists(const ATable, AIndex: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if (FConnection = nil) or (not FConnection.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConnection;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS n FROM information_schema.STATISTICS ' +
      'WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=:t AND INDEX_NAME=:i';
    Q.ParamByName('t').AsString := ATable;
    Q.ParamByName('i').AsString := AIndex;
    Q.Open;
    Result := Q.FieldByName('n').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

procedure TFLXSchemaAudit.Run;
const
  RequiredVFColumns: array[0..13] of string = (
    'id', 'fecha', 'serie', 'numero', 'estado', 'payload_json', 'canonical',
    'hash', 'hash_prev', 'respuesta_text', 'entorno', 'hash_input',
    'hash_fecha_huso', 'hash_algoritmo');
var
  Q: TZQuery;
  TableCount, ColumnCount, IndexCount, I, MissingCount: Integer;
  Engines, Collations, Evidence: string;
begin
  if (FConnection = nil) or (not FConnection.Connected) then
  begin
    FReport.Add('SCH001', 'ESQUEMA BBDD', alError,
      'No se puede auditar el esquema',
      'No existe una conexión activa con MariaDB.',
      'Abrir el Centro de Salud desde una sesión conectada.', '');
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConnection;

    Q.SQL.Text :=
      'SELECT COUNT(*) AS tablas, ' +
      'COUNT(DISTINCT ENGINE) AS motores, ' +
      'COUNT(DISTINCT TABLE_COLLATION) AS cotejamientos ' +
      'FROM information_schema.TABLES ' +
      'WHERE TABLE_SCHEMA=DATABASE() AND TABLE_TYPE=''BASE TABLE''';
    Q.Open;
    TableCount := Q.FieldByName('tablas').AsInteger;
    Evidence := 'Base=' + FConnection.Database + '; tablas=' + IntToStr(TableCount);
    if TableCount > 0 then
      FReport.Add('SCH001', 'ESQUEMA BBDD', alOK,
        'Inventario de tablas disponible',
        'La base de datos contiene ' + IntToStr(TableCount) + ' tablas.',
        '', Evidence)
    else
      FReport.Add('SCH001', 'ESQUEMA BBDD', alError,
        'La base de datos no contiene tablas',
        'No se ha localizado ninguna tabla en el esquema activo.',
        'Revisar la conexión y la base seleccionada.', Evidence);

    Q.Close;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS columnas FROM information_schema.COLUMNS ' +
      'WHERE TABLE_SCHEMA=DATABASE()';
    Q.Open;
    ColumnCount := Q.FieldByName('columnas').AsInteger;
    FReport.Add('SCH002', 'ESQUEMA BBDD', alOK,
      'Inventario de columnas disponible',
      'Se han localizado ' + IntToStr(ColumnCount) + ' columnas.', '',
      'columnas=' + IntToStr(ColumnCount));

    Q.Close;
    Q.SQL.Text :=
      'SELECT COUNT(DISTINCT CONCAT(TABLE_NAME,''|'',INDEX_NAME)) AS indices ' +
      'FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=DATABASE()';
    Q.Open;
    IndexCount := Q.FieldByName('indices').AsInteger;
    FReport.Add('SCH003', 'ESQUEMA BBDD', alOK,
      'Inventario de índices disponible',
      'Se han localizado ' + IntToStr(IndexCount) + ' índices.', '',
      'indices=' + IntToStr(IndexCount));

    Q.Close;
    Q.SQL.Text :=
      'SELECT GROUP_CONCAT(DISTINCT COALESCE(ENGINE,''SIN MOTOR'') ' +
      'ORDER BY ENGINE SEPARATOR '', '') AS motores, ' +
      'GROUP_CONCAT(DISTINCT COALESCE(TABLE_COLLATION,''SIN COTEJAMIENTO'') ' +
      'ORDER BY TABLE_COLLATION SEPARATOR '', '') AS cotejamientos ' +
      'FROM information_schema.TABLES ' +
      'WHERE TABLE_SCHEMA=DATABASE() AND TABLE_TYPE=''BASE TABLE''';
    Q.Open;
    Engines := Q.FieldByName('motores').AsString;
    Collations := Q.FieldByName('cotejamientos').AsString;
    FReport.Add('SCH004', 'ESQUEMA BBDD', alInfo,
      'Motores y cotejamientos detectados',
      'La instalación puede contener más de un motor o cotejamiento.',
      'Revisar el inventario exportado si se necesita homogeneizar.',
      'Motores: ' + Engines + '; Cotejamientos: ' + Collations);

    if not TableExists('verifactu_queue') then
    begin
      FReport.Add('SCH010', 'ESQUEMA BBDD', alError,
        'No existe verifactu_queue',
        'No se puede validar la estructura principal de VeriFactu.',
        'Inicializar o migrar la estructura VeriFactu.', '');
      Exit;
    end;

    MissingCount := 0;
    for I := Low(RequiredVFColumns) to High(RequiredVFColumns) do
      if not ColumnExists('verifactu_queue', RequiredVFColumns[I]) then
      begin
        Inc(MissingCount);
        FReport.Add('SCH' + Format('%.3d', [20 + I]), 'ESQUEMA BBDD',
          alWarning, 'Falta ' + RequiredVFColumns[I] + ' en verifactu_queue',
          'La columna no está disponible en esta instalación.',
          'Aplicar las migraciones automáticas de la versión actual.',
          RequiredVFColumns[I]);
      end;
    if MissingCount = 0 then
      FReport.Add('SCH019', 'ESQUEMA BBDD', alOK,
        'Estructura VeriFactu completa',
        'Todas las columnas de control y trazabilidad esperadas están disponibles.',
        '', 'verifactu_queue');

    if IndexExists('verifactu_queue', 'PRIMARY') then
      FReport.Add('SCH040', 'ESQUEMA BBDD', alOK,
        'Clave primaria de verifactu_queue disponible',
        'La tabla dispone de índice PRIMARY.', '', 'PRIMARY')
    else
      FReport.Add('SCH040', 'ESQUEMA BBDD', alWarning,
        'verifactu_queue no tiene clave primaria detectada',
        'La ausencia de una clave primaria puede perjudicar rendimiento y trazabilidad.',
        'Revisar la definición de la tabla antes de certificar.', '');
  except
    on E: Exception do
      FReport.Add('SCH099', 'ESQUEMA BBDD', alError,
        'Error al auditar el esquema', E.Message,
        'Revisar permisos sobre INFORMATION_SCHEMA y compatibilidad de MariaDB.',
        E.ClassName);
  end;
  Q.Free;
end;

procedure TFLXSchemaAudit.ExportInventory(const AFileName: string);
var
  Q: TZQuery;
  S: TStringList;
  CurrentTable: string;
begin
  if (FConnection = nil) or (not FConnection.Connected) then
    raise Exception.Create('No existe una conexión activa con MariaDB.');

  NotifyProgress(2, 'Preparando la auditoría del esquema...');
  S := TStringList.Create;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConnection;
    S.Add('FACTURLINEX - INVENTARIO COMPLETO DEL ESQUEMA DE BASE DE DATOS');
    S.Add('================================================================');
    S.Add('Fecha: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now));
    S.Add('Base de datos: ' + FConnection.Database);
    S.Add('Servidor: ' + FConnection.HostName);
    S.Add('');

    NotifyProgress(10, 'Leyendo tablas, motores y tamaños...');
    S.Add('TABLAS');
    S.Add('------');
    Q.SQL.Text :=
      'SELECT TABLE_NAME, ENGINE, TABLE_COLLATION, TABLE_ROWS, ' +
      'DATA_LENGTH, INDEX_LENGTH FROM information_schema.TABLES ' +
      'WHERE TABLE_SCHEMA=DATABASE() AND TABLE_TYPE=''BASE TABLE'' ' +
      'ORDER BY TABLE_NAME';
    Q.Open;
    while not Q.EOF do
    begin
      S.Add(Format('%s | Motor=%s | Cotejamiento=%s | Filas estimadas=%s | Datos=%s | Índices=%s',
        [Q.FieldByName('TABLE_NAME').AsString,
         Q.FieldByName('ENGINE').AsString,
         Q.FieldByName('TABLE_COLLATION').AsString,
         Q.FieldByName('TABLE_ROWS').AsString,
         Q.FieldByName('DATA_LENGTH').AsString,
         Q.FieldByName('INDEX_LENGTH').AsString]));
      Q.Next;
    end;

    NotifyProgress(35, 'Tablas leídas. Analizando columnas...');
    S.Add('');
    S.Add('COLUMNAS');
    S.Add('--------');
    Q.Close;
    Q.SQL.Text :=
      'SELECT TABLE_NAME, ORDINAL_POSITION, COLUMN_NAME, COLUMN_TYPE, ' +
      'IS_NULLABLE, COLUMN_DEFAULT, EXTRA, CHARACTER_SET_NAME, COLLATION_NAME ' +
      'FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() ' +
      'ORDER BY TABLE_NAME, ORDINAL_POSITION';
    Q.Open;
    CurrentTable := '';
    while not Q.EOF do
    begin
      if CurrentTable <> Q.FieldByName('TABLE_NAME').AsString then
      begin
        CurrentTable := Q.FieldByName('TABLE_NAME').AsString;
        S.Add('');
        S.Add('[' + CurrentTable + ']');
      end;
      S.Add(Format('  %s. %s %s | NULL=%s | DEFAULT=%s | EXTRA=%s | CHARSET=%s | COLLATION=%s',
        [Q.FieldByName('ORDINAL_POSITION').AsString,
         Q.FieldByName('COLUMN_NAME').AsString,
         Q.FieldByName('COLUMN_TYPE').AsString,
         Q.FieldByName('IS_NULLABLE').AsString,
         Q.FieldByName('COLUMN_DEFAULT').AsString,
         Q.FieldByName('EXTRA').AsString,
         Q.FieldByName('CHARACTER_SET_NAME').AsString,
         Q.FieldByName('COLLATION_NAME').AsString]));
      Q.Next;
    end;

    NotifyProgress(72, 'Columnas leídas. Analizando índices...');
    S.Add('');
    S.Add('ÍNDICES');
    S.Add('-------');
    Q.Close;
    Q.SQL.Text :=
      'SELECT TABLE_NAME, INDEX_NAME, NON_UNIQUE, SEQ_IN_INDEX, COLUMN_NAME, ' +
      'INDEX_TYPE FROM information_schema.STATISTICS ' +
      'WHERE TABLE_SCHEMA=DATABASE() ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX';
    Q.Open;
    CurrentTable := '';
    while not Q.EOF do
    begin
      if CurrentTable <> Q.FieldByName('TABLE_NAME').AsString then
      begin
        CurrentTable := Q.FieldByName('TABLE_NAME').AsString;
        S.Add('');
        S.Add('[' + CurrentTable + ']');
      end;
      S.Add(Format('  %s | Columna=%s | Orden=%s | NoÚnico=%s | Tipo=%s',
        [Q.FieldByName('INDEX_NAME').AsString,
         Q.FieldByName('COLUMN_NAME').AsString,
         Q.FieldByName('SEQ_IN_INDEX').AsString,
         Q.FieldByName('NON_UNIQUE').AsString,
         Q.FieldByName('INDEX_TYPE').AsString]));
      Q.Next;
    end;

    NotifyProgress(94, 'Guardando el inventario en disco...');
    S.SaveToFile(AFileName);
    NotifyProgress(100, 'Inventario completado.');
  finally
    Q.Free;
    S.Free;
  end;
end;

end.
