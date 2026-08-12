unit uVFSubsanacionCrypto;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, ZConnection, ZDataset, uVFSenderAEAT;

function VF_PrepareSubsanacionCrypto(AConn: TZConnection; const ASubID: Int64;
  out AQueueID: Int64; out AHash, AError: string): Boolean;

implementation

function VF_PrepareSubsanacionCrypto(AConn: TZConnection; const ASubID: Int64;
  out AQueueID: Int64; out AHash, AError: string): Boolean;
var
  Q: TZQuery;
  Serie, Payload, PrevHash, FechaHuso: string;
  Numero: Integer;
begin
  Result := False;
  AQueueID := 0;
  AHash := '';
  AError := '';

  if (AConn = nil) or (not AConn.Connected) then
  begin
    AError := 'No existe una conexión activa con MariaDB.';
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;
    Q.SQL.Text :=
      'SELECT s.estado,q.id,q.serie,q.numero,q.payload_json,' +
      'q.hash,q.hash_input,q.hash_fecha_huso ' +
      'FROM verifactu_subsanaciones s ' +
      'JOIN verifactu_queue q ON q.id=s.nuevo_queue_id ' +
      'WHERE s.id=:sid AND q.origen=''SUBSANACION'' ' +
      'AND q.registro_uid=CONCAT(''SUB-'',s.id) LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('sid').AsLargeInt := ASubID;
    Q.Open;

    if Q.EOF then
    begin
      AError := 'No se localiza el registro SUB-* en verifactu_queue.';
      Exit;
    end;

    if not SameText(Q.FieldByName('estado').AsString, 'EN_COLA_PENDIENTE') then
    begin
      AError := 'La subsanación no está en estado EN_COLA_PENDIENTE.';
      Exit;
    end;

    AQueueID := Q.FieldByName('id').AsLargeInt;
    Serie := Q.FieldByName('serie').AsString;
    Numero := Q.FieldByName('numero').AsInteger;
    Payload := Q.FieldByName('payload_json').AsString;

    if (Trim(Q.FieldByName('hash').AsString) <> '') and
       (Trim(Q.FieldByName('hash_input').AsString) <> '') and
       (Trim(Q.FieldByName('hash_fecha_huso').AsString) <> '') then
    begin
      AHash := Q.FieldByName('hash').AsString;
      Q.Close;
      Q.SQL.Text :=
        'UPDATE verifactu_subsanaciones SET estado=''HUELLA_PREPARADA'',' +
        'updated_at=NOW() WHERE id=:sid';
      Q.ParamCheck := True;
      Q.ParamByName('sid').AsLargeInt := ASubID;
      Q.ExecSQL;
      Result := True;
      Exit;
    end;
    Q.Close;

    { El anterior para una subsanación es el RF inmediatamente anterior
      generado por este SIF, no necesariamente numero-1. }
    Q.SQL.Text :=
      'SELECT hash FROM verifactu_queue ' +
      'WHERE id<:qid AND COALESCE(hash, '''') <> '''' ' +
      'ORDER BY id DESC LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('qid').AsLargeInt := AQueueID;
    Q.Open;
    PrevHash := '';
    if not Q.EOF then
      PrevHash := Trim(Q.FieldByName('hash').AsString);
    Q.Close;

    if not VF_PrepareAEATHash_NoSend(
      Serie, Numero, Payload, PrevHash, AQueueID,
      AHash, FechaHuso, AError) then
      Exit;

    if Trim(AHash) = '' then
    begin
      AError := 'El motor VeriFactu devolvió una huella vacía.';
      Exit;
    end;

    Q.SQL.Text :=
      'UPDATE verifactu_queue SET hash_prev=:hp,hash=:h,updated_at=NOW() ' +
      'WHERE id=:qid';
    Q.ParamCheck := True;
    Q.ParamByName('hp').AsString := PrevHash;
    Q.ParamByName('h').AsString := AHash;
    Q.ParamByName('qid').AsLargeInt := AQueueID;
    Q.ExecSQL;

    Q.Close;
    Q.SQL.Text :=
      'UPDATE verifactu_subsanaciones SET estado=''HUELLA_PREPARADA'',' +
      'updated_at=NOW() WHERE id=:sid';
    Q.ParamCheck := True;
    Q.ParamByName('sid').AsLargeInt := ASubID;
    Q.ExecSQL;
    Result := True;
  except
    on E: Exception do
      AError := E.Message;
  end;
  Q.Free;
end;

end.
