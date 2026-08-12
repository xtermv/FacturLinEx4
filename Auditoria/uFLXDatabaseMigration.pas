unit uFLXDatabaseMigration;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection;

{ Garantiza únicamente las ampliaciones de trazabilidad/auditoría añadidas
  para FacturLinEx 4.2.6. No modifica registros fiscales ni estados. }
function FLXEnsureVeriFactuAuditSchema(const Conn: TZConnection;
  out ErrorText: string): Boolean;

procedure FLXResetMigrationSessionState;

implementation

uses
  ZDataset;

var
  GCheckedThisRun: Boolean = False;
  GLastResult: Boolean = False;
  GLastError: string = '';

procedure FLXResetMigrationSessionState;
begin
  GCheckedThisRun := False;
  GLastResult := False;
  GLastError := '';
end;

function FLXEnsureVeriFactuAuditSchema(const Conn: TZConnection;
  out ErrorText: string): Boolean;
var
  Q: TZQuery;
  Existing: TStringList;

  function TableExists: Boolean;
  begin
    Q.Close;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS n FROM information_schema.TABLES ' +
      'WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=''verifactu_queue''';
    Q.Open;
    Result := Q.FieldByName('n').AsInteger > 0;
    Q.Close;
  end;

  procedure LoadExistingColumns;
  begin
    Existing.Clear;
    Q.Close;
    Q.SQL.Text :=
      'SELECT COLUMN_NAME FROM information_schema.COLUMNS ' +
      'WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=''verifactu_queue''';
    Q.Open;
    while not Q.EOF do
    begin
      Existing.Add(LowerCase(Q.FieldByName('COLUMN_NAME').AsString));
      Q.Next;
    end;
    Q.Close;
  end;

  procedure AddColumnIfMissing(const ColumnName, ColumnDDL: string);
  begin
    if Existing.IndexOf(LowerCase(ColumnName)) >= 0 then
      Exit;

    Q.Close;
    Q.SQL.Text := 'ALTER TABLE verifactu_queue ADD COLUMN ' + ColumnDDL;
    Q.ExecSQL;
    Existing.Add(LowerCase(ColumnName));
  end;

  function IndexExists(const IndexName: string): Boolean;
  begin
    Q.Close;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS n FROM information_schema.STATISTICS ' +
      'WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=''verifactu_queue'' ' +
      'AND INDEX_NAME=:i';
    Q.ParamCheck := True;
    Q.ParamByName('i').AsString := IndexName;
    Q.Open;
    Result := Q.FieldByName('n').AsInteger > 0;
    Q.Close;
  end;

  procedure EnsureRegistroIdentityIndex;
  begin
    { Se crea primero el nuevo índice. Solo se retira el anterior si el nuevo
      existe correctamente, evitando dejar la cola sin protección. }
    if not IndexExists('uq_serie_numero_reguid') then
    begin
      Q.Close;
      Q.SQL.Text :=
        'ALTER TABLE verifactu_queue ADD UNIQUE KEY ' +
        'uq_serie_numero_reguid (serie, numero, registro_uid)';
      Q.ExecSQL;
    end;

    if IndexExists('uq_serie_numero_reguid') and IndexExists('uq_serie_numero') then
    begin
      Q.Close;
      Q.SQL.Text :=
        'ALTER TABLE verifactu_queue DROP INDEX uq_serie_numero';
      Q.ExecSQL;
    end;
  end;

begin
  ErrorText := '';

  { No repetir consultas ni DDL durante la misma ejecución del programa. }
  if GCheckedThisRun then
  begin
    ErrorText := GLastError;
    Exit(GLastResult);
  end;

  GCheckedThisRun := True;
  GLastResult := False;
  GLastError := '';

  if Conn = nil then
  begin
    GLastError := 'Conexión de base de datos no asignada.';
    ErrorText := GLastError;
    Exit(False);
  end;

  if not Conn.Connected then
  begin
    GLastError := 'La conexión de base de datos no está activa.';
    ErrorText := GLastError;
    Exit(False);
  end;

  Q := TZQuery.Create(nil);
  Existing := TStringList.Create;
  try
    try
      Q.Connection := Conn;
      Existing.CaseSensitive := False;
      Existing.Sorted := True;
      Existing.Duplicates := dupIgnore;

      if not TableExists then
      begin
        GLastError :=
          'No existe la tabla verifactu_queue. Debe inicializarse primero el subsistema VeriFactu.';
        ErrorText := GLastError;
        Result := False;
        Exit;
      end;

      LoadExistingColumns;

      { Registros históricos: SIN_CLASIFICAR evita atribuirles un entorno no demostrado. }
      AddColumnIfMissing('entorno',
        'entorno VARCHAR(16) NOT NULL DEFAULT ''SIN_CLASIFICAR''');

      { Naturaleza del registro. No se fuerza NORMAL en históricos porque no
        debemos atribuir un origen que no podamos demostrar. }
      AddColumnIfMissing('origen',
        'origen VARCHAR(24) NOT NULL DEFAULT ''SIN_CLASIFICAR''');

      { Identidad técnica interna. No forma parte del registro fiscal ni se
        envía a AEAT. Todos los registros existentes permanecen como ORIG. }
      AddColumnIfMissing('registro_uid',
        'registro_uid VARCHAR(64) NOT NULL DEFAULT ''ORIG''');

      Q.Close;
      Q.SQL.Text :=
        'UPDATE verifactu_queue SET registro_uid=''ORIG'' ' +
        'WHERE COALESCE(registro_uid,'''')=''''';
      Q.ExecSQL;

      EnsureRegistroIdentityIndex;

      { Clasificación segura únicamente de rectificativas históricas: el propio
        tipo R1..R5 demuestra su naturaleza. Los F1/F2/F3 antiguos permanecen
        SIN_CLASIFICAR para no mezclar producción, pruebas y migraciones. }
      Q.Close;
      Q.SQL.Text :=
        'UPDATE verifactu_queue SET origen=''RECTIFICATIVA'' ' +
        'WHERE origen=''SIN_CLASIFICAR'' AND tipo_factura IN ' +
        '(''R1'',''R2'',''R3'',''R4'',''R5'')';
      Q.ExecSQL;

      { Evidencias necesarias para auditoría criptográfica de registros nuevos. }
      AddColumnIfMissing('hash_input',
        'hash_input MEDIUMTEXT NULL');
      AddColumnIfMissing('hash_fecha_huso',
        'hash_fecha_huso VARCHAR(35) NULL');
      AddColumnIfMissing('hash_algoritmo',
        'hash_algoritmo VARCHAR(16) NOT NULL DEFAULT ''SHA-256''');

      GLastResult := True;
      Result := True;
    except
      on E: Exception do
      begin
        GLastError := E.Message;
        ErrorText := GLastError;
        Result := False;
      end;
    end;
  finally
    Existing.Free;
    Q.Free;
  end;
end;

end.
