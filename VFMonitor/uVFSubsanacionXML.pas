unit uVFSubsanacionXML;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, ZConnection, ZDataset, uVFSenderAEAT;

function VF_PrepareAndValidateSubsanacionXML(AConn: TZConnection;
  const ASubID: Int64; out AQueueID: Int64; out AXML, AError: string): Boolean;

implementation

function FechaAEAT(const D: TDateTime): string;
begin
  Result := FormatDateTime('dd-mm-yyyy', D);
end;

function HasText(const S, P: string): Boolean;
begin
  Result := Pos(P, S) > 0;
end;

function VF_PrepareAndValidateSubsanacionXML(AConn: TZConnection;
  const ASubID: Int64; out AQueueID: Int64; out AXML, AError: string): Boolean;
var
  Q: TZQuery;
  Serie, Payload, HashPrev, HashStored, HashCalc, FechaHuso: string;
  SubFlag, RejectFlag: string;
  PrevSerie, PrevFecha: string;
  Numero, PrevNumero: Integer;
  PrevID: Int64;
  Expected: string;
begin
  Result := False;
  AQueueID := 0;
  AXML := '';
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
      'SELECT s.estado,s.indicador_subsanacion,s.indicador_rechazo_previo,' +
      'q.id,q.serie,q.numero,q.payload_json,q.hash,q.hash_prev,q.hash_fecha_huso ' +
      'FROM verifactu_subsanaciones s ' +
      'JOIN verifactu_queue q ON q.id=s.nuevo_queue_id ' +
      'WHERE s.id=:sid AND q.origen=''SUBSANACION'' ' +
      'AND q.registro_uid=CONCAT(''SUB-'',s.id) LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('sid').AsLargeInt := ASubID;
    Q.Open;

    if Q.EOF then
    begin
      AError := 'No se localiza el registro SUB-* vinculado.';
      Exit;
    end;

    if not SameText(Q.FieldByName('estado').AsString, 'HUELLA_PREPARADA') then
    begin
      AError := 'La subsanación debe estar en estado HUELLA_PREPARADA.';
      Exit;
    end;

    AQueueID := Q.FieldByName('id').AsLargeInt;
    Serie := Q.FieldByName('serie').AsString;
    Numero := Q.FieldByName('numero').AsInteger;
    Payload := Q.FieldByName('payload_json').AsString;
    HashStored := Trim(Q.FieldByName('hash').AsString);
    HashPrev := Trim(Q.FieldByName('hash_prev').AsString);
    FechaHuso := Trim(Q.FieldByName('hash_fecha_huso').AsString);
    SubFlag := UpperCase(Trim(Q.FieldByName('indicador_subsanacion').AsString));
    RejectFlag := UpperCase(Trim(Q.FieldByName('indicador_rechazo_previo').AsString));
    Q.Close;

    if SubFlag <> 'S' then
    begin
      AError := 'La subsanación no contiene indicador_subsanacion=S.';
      Exit;
    end;

    if (RejectFlag <> 'N') and (RejectFlag <> 'X') then
    begin
      AError := 'RechazoPrevio debe ser N o X.';
      Exit;
    end;

    if (HashStored = '') or (HashPrev = '') or (FechaHuso = '') then
    begin
      AError := 'La evidencia criptográfica de V1.11 está incompleta.';
      Exit;
    end;

    { Recuperamos el MISMO RF anterior usado conceptualmente por V1.11:
      último registro previo con huella no vacía. }
    Q.SQL.Text :=
      'SELECT id,serie,numero,fecha,hash FROM verifactu_queue ' +
      'WHERE id<:qid AND COALESCE(hash, '''') <> '''' ' +
      'ORDER BY id DESC LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('qid').AsLargeInt := AQueueID;
    Q.Open;
    if Q.EOF then
    begin
      AError := 'No se localiza el RegistroAnterior con huella.';
      Exit;
    end;

    PrevID := Q.FieldByName('id').AsLargeInt;
    PrevSerie := Q.FieldByName('serie').AsString;
    PrevNumero := Q.FieldByName('numero').AsInteger;
    PrevFecha := FechaAEAT(Q.FieldByName('fecha').AsDateTime);

    if Trim(Q.FieldByName('hash').AsString) <> HashPrev then
    begin
      AError := 'La huella del RegistroAnterior ya no coincide con hash_prev.';
      Exit;
    end;
    Q.Close;

    if not VF_PrepareAEATSubsanacionXML_NoSend(
      Serie, Numero, Payload, HashPrev, AQueueID, FechaHuso,
      SubFlag, RejectFlag, PrevSerie, PrevNumero, PrevFecha,
      AXML, HashCalc, AError) then
      Exit;

    { La reconstrucción XML debe producir exactamente la huella ya congelada. }
    if not SameText(Trim(HashCalc), HashStored) then
    begin
      AError := 'La huella reconstruida no coincide con la huella preparada. ' +
        'Se bloquea el XML para evitar enviar un registro distinto.';
      Exit;
    end;

    Expected := '<sum1:Subsanacion>S</sum1:Subsanacion>';
    if not HasText(AXML, Expected) then
    begin
      AError := 'El XML no contiene Subsanacion=S.';
      Exit;
    end;

    Expected := '<sum1:RechazoPrevio>' + RejectFlag + '</sum1:RechazoPrevio>';
    if not HasText(AXML, Expected) then
    begin
      AError := 'El XML no contiene el RechazoPrevio esperado (' +
        RejectFlag + ').';
      Exit;
    end;

    Expected := '<sum1:NumSerieFactura>' + PrevSerie + '-' +
      IntToStr(PrevNumero) + '</sum1:NumSerieFactura>';
    if not HasText(AXML, Expected) then
    begin
      AError := 'El XML no identifica correctamente el RegistroAnterior.';
      Exit;
    end;

    Expected := '<sum1:FechaExpedicionFactura>' + PrevFecha +
      '</sum1:FechaExpedicionFactura>';
    if not HasText(AXML, Expected) then
    begin
      AError := 'El XML no contiene la fecha real del RegistroAnterior.';
      Exit;
    end;

    Expected := '<sum1:Huella>' + HashPrev + '</sum1:Huella>';
    if not HasText(AXML, Expected) then
    begin
      AError := 'El XML no contiene la huella del RegistroAnterior.';
      Exit;
    end;

    Expected := '<sum1:FechaHoraHusoGenRegistro>' + FechaHuso +
      '</sum1:FechaHoraHusoGenRegistro>';
    if not HasText(AXML, Expected) then
    begin
      AError := 'El XML no conserva FechaHoraHusoGenRegistro.';
      Exit;
    end;

    { Guardamos evidencia para revisión humana antes de SOAP. }
    Q.SQL.Text :=
      'UPDATE verifactu_subsanaciones SET xml_preparado=:x,' +
      'xml_validated_at=NOW(),chain_queue_id=:pid,chain_serie=:ps,' +
      'chain_numero=:pn,chain_fecha=STR_TO_DATE(:pf,''%d-%m-%Y''),' +
      'chain_hash=:ph,estado=''XML_VALIDADO'',updated_at=NOW() ' +
      'WHERE id=:sid';
    Q.ParamCheck := True;
    Q.ParamByName('x').AsString := AXML;
    Q.ParamByName('pid').AsLargeInt := PrevID;
    Q.ParamByName('ps').AsString := PrevSerie;
    Q.ParamByName('pn').AsString := IntToStr(PrevNumero);
    Q.ParamByName('pf').AsString := PrevFecha;
    Q.ParamByName('ph').AsString := HashPrev;
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
