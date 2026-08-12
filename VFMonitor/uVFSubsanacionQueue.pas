unit uVFSubsanacionQueue;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, Global;

function VF_CreatePendingSubsanacionQueue(AConn: TZConnection;
  const ASubID: Int64; out AQueueID: Int64; out ARegistroUID: string;
  out AError: string): Boolean;

implementation

function VF_CreatePendingSubsanacionQueue(AConn: TZConnection;
  const ASubID: Int64; out AQueueID: Int64; out ARegistroUID: string;
  out AError: string): Boolean;
var
  Q, QIns: TZQuery;
  Serie, Entorno, TipoFactura, Payload: string;
  Numero: Integer;
  Fecha: TDateTime;
  Hora: string;
  Total: Currency;
  ExistingID: Int64;
begin
  Result := False;
  AQueueID := 0;
  ARegistroUID := '';
  AError := '';

  if (AConn = nil) or (not AConn.Connected) then
  begin
    AError := 'No existe una conexión activa con MariaDB.';
    Exit;
  end;

  ARegistroUID := 'SUB-' + IntToStr(ASubID);

  Q := TZQuery.Create(nil);
  QIns := TZQuery.Create(nil);
  try
    Q.Connection := AConn;
    QIns.Connection := AConn;

    { Leemos exclusivamente una subsanación ya preparada. }
    Q.SQL.Text :=
      'SELECT s.id,s.estado,s.payload_preparado,s.queue_id,' +
      'q.serie,q.numero,q.fecha,q.hora,q.total_con_iva,q.tipo_factura,q.entorno ' +
      'FROM verifactu_subsanaciones s ' +
      'JOIN verifactu_queue q ON q.id=s.queue_id ' +
      'WHERE s.id=:sid LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('sid').AsLargeInt := ASubID;
    Q.Open;

    if Q.EOF then
    begin
      AError := 'No se localiza la subsanación preparada.';
      Exit;
    end;

    if not SameText(Trim(Q.FieldByName('estado').AsString),
      'LISTO_PARA_GENERADOR') then
    begin
      AError := 'La subsanación debe estar en estado LISTO_PARA_GENERADOR.';
      Exit;
    end;

    Payload := Q.FieldByName('payload_preparado').AsString;
    if Trim(Payload) = '' then
    begin
      AError := 'La subsanación no contiene payload_preparado.';
      Exit;
    end;

    Serie := Q.FieldByName('serie').AsString;
    Numero := Q.FieldByName('numero').AsInteger;
    Fecha := Q.FieldByName('fecha').AsDateTime;
    Hora := Q.FieldByName('hora').AsString;
    Total := Q.FieldByName('total_con_iva').AsCurrency;
    TipoFactura := Q.FieldByName('tipo_factura').AsString;
    Entorno := UpperCase(Trim(vfMode));
    if Entorno = 'TEST' then Entorno := 'PRUEBAS';
    if (Entorno <> 'PRUEBAS') and (Entorno <> 'PRODUCCION') then
    begin
      AError := 'vfMode contiene un entorno VeriFactu no válido: ' + Trim(vfMode);
      Exit;
    end;

    Q.Close;

    { Idempotencia: si SUB-<id> ya existe, devolvemos ese registro y no
      insertamos otro. }
    Q.SQL.Text :=
      'SELECT id FROM verifactu_queue ' +
      'WHERE serie=:s AND numero=:n AND registro_uid=:u LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('s').AsString := Serie;
    Q.ParamByName('n').AsInteger := Numero;
    Q.ParamByName('u').AsString := ARegistroUID;
    Q.Open;

    if not Q.EOF then
    begin
      ExistingID := Q.FieldByName('id').AsLargeInt;
      AQueueID := ExistingID;

      { Si el SUB ya existía de una revisión anterior, sincronizamos también
        su tipo fiscal con el ORIG antes de reutilizarlo. }
      Q.Close;
      Q.SQL.Text :=
        'UPDATE verifactu_queue SET tipo_factura=:tf,entorno=:ent,' +
        'payload_json=:p,updated_at=NOW() WHERE id=:qid';
      Q.ParamCheck := True;
      Q.ParamByName('tf').AsString := TipoFactura;
      Q.ParamByName('ent').AsString := Entorno;
      Q.ParamByName('p').AsString := Payload;
      Q.ParamByName('qid').AsLargeInt := AQueueID;
      Q.ExecSQL;

      Q.Close;
      Q.SQL.Text :=
        'UPDATE verifactu_subsanaciones SET nuevo_queue_id=:qid,' +
        'estado=''EN_COLA_PENDIENTE'',updated_at=NOW() WHERE id=:sid';
      Q.ParamCheck := True;
      Q.ParamByName('qid').AsLargeInt := AQueueID;
      Q.ParamByName('sid').AsLargeInt := ASubID;
      Q.ExecSQL;

      Result := True;
      Exit;
    end;

    { IMPORTANTE: no calculamos hash/canonical aquí. El registro queda
      PENDIENTE y separado del dispatcher normal hasta la siguiente fase. }
    QIns.SQL.Text :=
      'INSERT INTO verifactu_queue ' +
      '(serie,numero,fecha,hora,total_con_iva,estado,intentos,payload_json,hash,' +
      'hash_prev,respuesta_text,last_error,token,claimed_by,claimed_at,claimed_until,' +
      'last_attempt_at,fecha_isoz,canonical,tipo_factura,entorno,origen,registro_uid,' +
      'created_at,updated_at) ' +
      'VALUES (:s,:n,:f,:h,:t,''PENDIENTE'',0,:p,:hash,:hash_prev,:respuesta,:last_error,' +
      'NULL,NULL,NULL,NULL,NULL,:fecha_isoz,:canonical,:tf,:ent,''SUBSANACION'',:uid,NOW(),NOW())';
    QIns.ParamCheck := True;
    QIns.ParamByName('s').AsString := Serie;
    QIns.ParamByName('n').AsInteger := Numero;
    QIns.ParamByName('f').AsDate := Fecha;
    QIns.ParamByName('h').AsString := Hora;
    QIns.ParamByName('t').AsCurrency := Total;
    QIns.ParamByName('p').AsString := Payload;
    QIns.ParamByName('hash').AsString := '';
    QIns.ParamByName('hash_prev').AsString := '';
    QIns.ParamByName('respuesta').AsString := '';
    QIns.ParamByName('last_error').AsString := '';
    QIns.ParamByName('fecha_isoz').AsString := '';
    QIns.ParamByName('canonical').AsString := '';
    QIns.ParamByName('tf').AsString := TipoFactura;
    QIns.ParamByName('ent').AsString := Entorno;
    QIns.ParamByName('uid').AsString := ARegistroUID;
    QIns.ExecSQL;

    Q.Close;
    Q.SQL.Text := 'SELECT LAST_INSERT_ID() AS id';
    Q.Open;
    AQueueID := Q.FieldByName('id').AsLargeInt;
    Q.Close;

    Q.Close;
    Q.SQL.Text :=
      'UPDATE verifactu_subsanaciones SET nuevo_queue_id=:qid,' +
      'estado=''EN_COLA_PENDIENTE'',updated_at=NOW() WHERE id=:sid';
    Q.ParamCheck := True;
    Q.ParamByName('qid').AsLargeInt := AQueueID;
    Q.ParamByName('sid').AsLargeInt := ASubID;
    Q.ExecSQL;

    Result := True;
  except
    on E: Exception do
      AError := E.Message;
  end;

  QIns.Free;
  Q.Free;
end;

end.
