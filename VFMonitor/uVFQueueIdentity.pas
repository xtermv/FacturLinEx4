unit uVFQueueIdentity;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset;

type
  TVFQueueIdentity = record
    ID: Int64;
    Serie: string;
    Numero: Integer;
    RegistroUID: string;
    Origen: string;
    Estado: string;
    PayloadJSON: string;
    Hash: string;
    HashPrev: string;
    Respuesta: string;
    LastError: string;
    Intentos: Integer;
  end;

function VFQ_LoadByID(AConn: TZConnection; const AID: Int64;
  out AItem: TVFQueueIdentity; out AError: string): Boolean;

function VFQ_LoadByIdentity(AConn: TZConnection; const ASerie: string;
  const ANumero: Integer; const ARegistroUID: string;
  out AItem: TVFQueueIdentity; out AError: string): Boolean;

function VFQ_MarkSentByID(AConn: TZConnection; const AID: Int64;
  const AHash, ARespuesta: string; out AError: string): Boolean;

function VFQ_MarkErrorByID(AConn: TZConnection; const AID: Int64;
  const AMensaje, ARespuesta: string; out AError: string): Boolean;

function VFQ_RequeueByID(AConn: TZConnection; const AID: Int64;
  const AMotivo: string; out AError: string): Boolean;

function VFQ_ClaimPendingByID(AConn: TZConnection; const AID: Int64;
  const AToken, AClaimedBy: string; const AMinutes: Integer;
  out AError: string): Boolean;

implementation

procedure ClearItem(out AItem: TVFQueueIdentity);
begin
  FillChar(AItem, SizeOf(AItem), 0);
end;

function CheckConn(AConn: TZConnection; out AError: string): Boolean;
begin
  Result := (AConn <> nil) and AConn.Connected;
  if Result then
    AError := ''
  else
    AError := 'No existe una conexión activa con MariaDB.';
end;

procedure FillItem(Q: TZQuery; out AItem: TVFQueueIdentity);
begin
  ClearItem(AItem);
  AItem.ID := Q.FieldByName('id').AsLargeInt;
  AItem.Serie := Q.FieldByName('serie').AsString;
  AItem.Numero := Q.FieldByName('numero').AsInteger;
  AItem.RegistroUID := Q.FieldByName('registro_uid').AsString;
  AItem.Origen := Q.FieldByName('origen').AsString;
  AItem.Estado := Q.FieldByName('estado').AsString;
  AItem.PayloadJSON := Q.FieldByName('payload_json').AsString;
  AItem.Hash := Q.FieldByName('hash').AsString;
  AItem.HashPrev := Q.FieldByName('hash_prev').AsString;
  AItem.Respuesta := Q.FieldByName('respuesta_text').AsString;
  AItem.LastError := Q.FieldByName('last_error').AsString;
  AItem.Intentos := Q.FieldByName('intentos').AsInteger;
end;

function VFQ_LoadByID(AConn: TZConnection; const AID: Int64;
  out AItem: TVFQueueIdentity; out AError: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  ClearItem(AItem);
  if not CheckConn(AConn, AError) then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;
    Q.SQL.Text :=
      'SELECT id,serie,numero,registro_uid,origen,estado,payload_json,' +
      'hash,hash_prev,respuesta_text,last_error,intentos ' +
      'FROM verifactu_queue WHERE id=:id LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('id').AsLargeInt := AID;
    Q.Open;
    if Q.EOF then
    begin
      AError := 'No se localiza el registro VeriFactu id=' + IntToStr(AID) + '.';
      Exit;
    end;
    FillItem(Q, AItem);
    Result := True;
  except
    on E: Exception do AError := E.Message;
  end;
  Q.Free;
end;

function VFQ_LoadByIdentity(AConn: TZConnection; const ASerie: string;
  const ANumero: Integer; const ARegistroUID: string;
  out AItem: TVFQueueIdentity; out AError: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  ClearItem(AItem);
  if not CheckConn(AConn, AError) then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;
    Q.SQL.Text :=
      'SELECT id,serie,numero,registro_uid,origen,estado,payload_json,' +
      'hash,hash_prev,respuesta_text,last_error,intentos ' +
      'FROM verifactu_queue ' +
      'WHERE serie=:s AND numero=:n AND registro_uid=:u LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('s').AsString := ASerie;
    Q.ParamByName('n').AsInteger := ANumero;
    Q.ParamByName('u').AsString := ARegistroUID;
    Q.Open;
    if Q.EOF then
    begin
      AError := 'No se localiza ' + ASerie + '/' + IntToStr(ANumero) +
        ' [' + ARegistroUID + '].';
      Exit;
    end;
    FillItem(Q, AItem);
    Result := True;
  except
    on E: Exception do AError := E.Message;
  end;
  Q.Free;
end;

function VFQ_MarkSentByID(AConn: TZConnection; const AID: Int64;
  const AHash, ARespuesta: string; out AError: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if not CheckConn(AConn, AError) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;
    Q.SQL.Text :=
      'UPDATE verifactu_queue SET estado=''ENVIADO'',hash=:h,' +
      'respuesta_text=:r,last_error=NULL,token=NULL,claimed_by=NULL,' +
      'claimed_at=NULL,claimed_until=NULL,last_attempt_at=NOW(),updated_at=NOW() ' +
      'WHERE id=:id';
    Q.ParamCheck := True;
    Q.ParamByName('h').AsString := AHash;
    Q.ParamByName('r').AsString := ARespuesta;
    Q.ParamByName('id').AsLargeInt := AID;
    Q.ExecSQL;
    Result := Q.RowsAffected = 1;
    if not Result then AError := 'No se actualizó ningún registro.';
  except
    on E: Exception do AError := E.Message;
  end;
  Q.Free;
end;

function VFQ_MarkErrorByID(AConn: TZConnection; const AID: Int64;
  const AMensaje, ARespuesta: string; out AError: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if not CheckConn(AConn, AError) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;
    Q.SQL.Text :=
      'UPDATE verifactu_queue SET estado=''ERROR'',last_error=:e,' +
      'respuesta_text=:r,intentos=intentos+1,token=NULL,claimed_by=NULL,' +
      'claimed_at=NULL,claimed_until=NULL,last_attempt_at=NOW(),updated_at=NOW() ' +
      'WHERE id=:id';
    Q.ParamCheck := True;
    Q.ParamByName('e').AsString := Copy(AMensaje,1,255);
    Q.ParamByName('r').AsString := ARespuesta;
    Q.ParamByName('id').AsLargeInt := AID;
    Q.ExecSQL;
    Result := Q.RowsAffected = 1;
    if not Result then AError := 'No se actualizó ningún registro.';
  except
    on E: Exception do AError := E.Message;
  end;
  Q.Free;
end;

function VFQ_RequeueByID(AConn: TZConnection; const AID: Int64;
  const AMotivo: string; out AError: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  if not CheckConn(AConn, AError) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;
    Q.SQL.Text :=
      'UPDATE verifactu_queue SET estado=''PENDIENTE'',last_error=:e,' +
      'token=NULL,claimed_by=NULL,claimed_at=NULL,claimed_until=NULL,' +
      'updated_at=NOW() WHERE id=:id';
    Q.ParamCheck := True;
    Q.ParamByName('e').AsString := Copy(AMotivo,1,255);
    Q.ParamByName('id').AsLargeInt := AID;
    Q.ExecSQL;
    Result := Q.RowsAffected = 1;
    if not Result then AError := 'No se actualizó ningún registro.';
  except
    on E: Exception do AError := E.Message;
  end;
  Q.Free;
end;

function VFQ_ClaimPendingByID(AConn: TZConnection; const AID: Int64;
  const AToken, AClaimedBy: string; const AMinutes: Integer;
  out AError: string): Boolean;
var
  Q: TZQuery;
  M: Integer;
begin
  Result := False;
  if not CheckConn(AConn, AError) then Exit;
  M := AMinutes;
  if M < 1 then M := 10;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;
    Q.SQL.Text :=
      'UPDATE verifactu_queue SET estado=''EN_PROCESO'',token=:t,' +
      'claimed_by=:b,claimed_at=NOW(),claimed_until=DATE_ADD(NOW(),INTERVAL :m MINUTE),' +
      'updated_at=NOW() ' +
      'WHERE id=:id AND estado=''PENDIENTE'' AND ' +
      '(token IS NULL OR claimed_until IS NULL OR claimed_until<NOW())';
    Q.ParamCheck := True;
    Q.ParamByName('t').AsString := AToken;
    Q.ParamByName('b').AsString := Copy(AClaimedBy,1,64);
    Q.ParamByName('m').AsInteger := M;
    Q.ParamByName('id').AsLargeInt := AID;
    Q.ExecSQL;
    Result := Q.RowsAffected = 1;
    if not Result then
      AError := 'El registro no está PENDIENTE o ya está reclamado por otro proceso.';
  except
    on E: Exception do AError := E.Message;
  end;
  Q.Free;
end;

end.
