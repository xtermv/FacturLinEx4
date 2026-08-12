unit uVFSubsanacionCertificacion;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, ZConnection, ZDataset;

function VF_SubEnsureCertificationSchema(AConn: TZConnection;
  out AError: string): Boolean;

function VF_SubRegisterSuccessfulTest(AConn: TZConnection;
  const ASubID, AQueueID: Int64; const AResponse: string;
  out AError: string): Boolean;

function VF_SubHasSuccessfulTest(AConn: TZConnection;
  out ATestSubID, ATestQueueID: Int64; out ATestDate: TDateTime;
  out AError: string): Boolean;

implementation

var
  GCertSchemaChecked: Boolean = False;

function VF_SubEnsureCertificationSchema(AConn: TZConnection;
  out AError: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  AError := '';

  if GCertSchemaChecked then
  begin
    Result := True;
    Exit;
  end;

  if (AConn = nil) or (not AConn.Connected) then
  begin
    AError := 'No existe una conexión activa con MariaDB.';
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;
    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS verifactu_sub_certificacion (' +
      'id BIGINT NOT NULL AUTO_INCREMENT,' +
      'sub_id BIGINT NOT NULL,' +
      'queue_id BIGINT NOT NULL,' +
      'entorno VARCHAR(16) NOT NULL,' +
      'estado_registro VARCHAR(40) NOT NULL,' +
      'respuesta_text LONGTEXT NULL,' +
      'certified_at DATETIME NOT NULL,' +
      'PRIMARY KEY (id),' +
      'KEY idx_sub_cert_ok (entorno,estado_registro,certified_at),' +
      'KEY idx_sub_cert_queue (queue_id)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8';
    Q.ExecSQL;
    GCertSchemaChecked := True;
    Result := True;
  except
    on E: Exception do
      AError := E.Message;
  end;
  Q.Free;
end;

function VF_SubRegisterSuccessfulTest(AConn: TZConnection;
  const ASubID, AQueueID: Int64; const AResponse: string;
  out AError: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  AError := '';

  if not VF_SubEnsureCertificationSchema(AConn, AError) then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;

    { Idempotencia por queue_id: una misma prueba correcta no se duplica. }
    Q.SQL.Text :=
      'SELECT id FROM verifactu_sub_certificacion ' +
      'WHERE queue_id=:qid AND entorno=''PRUEBAS'' ' +
      'AND estado_registro=''Correcto'' LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('qid').AsLargeInt := AQueueID;
    Q.Open;
    if not Q.EOF then
    begin
      Result := True;
      Exit;
    end;
    Q.Close;

    Q.SQL.Text :=
      'INSERT INTO verifactu_sub_certificacion ' +
      '(sub_id,queue_id,entorno,estado_registro,respuesta_text,certified_at) ' +
      'VALUES (:sid,:qid,''PRUEBAS'',''Correcto'',:r,NOW())';
    Q.ParamCheck := True;
    Q.ParamByName('sid').AsLargeInt := ASubID;
    Q.ParamByName('qid').AsLargeInt := AQueueID;
    Q.ParamByName('r').AsString := AResponse;
    Q.ExecSQL;
    Result := True;
  except
    on E: Exception do
      AError := E.Message;
  end;
  Q.Free;
end;

function VF_SubHasSuccessfulTest(AConn: TZConnection;
  out ATestSubID, ATestQueueID: Int64; out ATestDate: TDateTime;
  out AError: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  ATestSubID := 0;
  ATestQueueID := 0;
  ATestDate := 0;
  AError := '';

  if not VF_SubEnsureCertificationSchema(AConn, AError) then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;
    Q.SQL.Text :=
      'SELECT sub_id,queue_id,certified_at ' +
      'FROM verifactu_sub_certificacion ' +
      'WHERE entorno=''PRUEBAS'' AND estado_registro=''Correcto'' ' +
      'ORDER BY certified_at DESC,id DESC LIMIT 1';
    Q.Open;
    if Q.EOF then Exit;

    ATestSubID := Q.FieldByName('sub_id').AsLargeInt;
    ATestQueueID := Q.FieldByName('queue_id').AsLargeInt;
    ATestDate := Q.FieldByName('certified_at').AsDateTime;
    Result := True;
  except
    on E: Exception do
      AError := E.Message;
  end;
  Q.Free;
end;

end.
