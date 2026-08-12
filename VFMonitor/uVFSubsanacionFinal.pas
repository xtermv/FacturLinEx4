unit uVFSubsanacionFinal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, ZConnection, ZDataset, uVFJSONPatch;

type
  TVFSubsanacionFinal = record
    SubID: Int64;
    QueueIDOrigen: Int64;
    Serie: string;
    Numero: string;
    Fecha: TDateTime;
    TipoFactura: string;
    Entorno: string;
    Subsanacion: string;
    RechazoPrevio: string;
    PayloadOriginal: string;
    PayloadPreparado: string;
    ChainQueueID: Int64;
    ChainSerie: string;
    ChainNumero: string;
    ChainFecha: TDateTime;
    ChainHash: string;
    ChainChanged: Boolean;
  end;

function VF_PrepareFinalSubsanacion(AConn: TZConnection; ASubID: Int64;
  out AFinal: TVFSubsanacionFinal; out AError: string): Boolean;

implementation

function GetJSONObj(const S: string; out Obj: TJSONObject;
  out AError: string): Boolean;
var
  D: TJSONData;
begin
  Result := False;
  Obj := nil;
  AError := '';
  try
    D := GetJSON(S);
    if not (D is TJSONObject) then
    begin
      D.Free;
      AError := 'El payload original no es un objeto JSON.';
      Exit;
    end;
    Obj := TJSONObject(D);
    Result := True;
  except
    on E: Exception do
      AError := 'JSON original no válido: ' + E.Message;
  end;
end;

procedure SetStringValue(Obj: TJSONObject; const Name, Value: string);
var
  Idx: Integer;
begin
  Idx := Obj.IndexOfName(Name);
  if Idx >= 0 then
    Obj.Delete(Idx);
  Obj.Add(Name, Value);
end;

function VF_PrepareFinalSubsanacion(AConn: TZConnection; ASubID: Int64;
  out AFinal: TVFSubsanacionFinal; out AError: string): Boolean;
var
  Q: TZQuery;
  CurrentLastID: Int64;
  TmpPayload, TmpPayload2, CorrectedNIF, CorrectedName, CheckNIF: string;
  CurrentLastHash: string;
begin
  Result := False;
  AError := '';
  FillChar(AFinal, SizeOf(AFinal), 0);

  if (AConn = nil) or (not AConn.Connected) then
  begin
    AError := 'No existe conexión activa con MariaDB.';
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;
    Q.SQL.Text :=
      'SELECT s.id,s.queue_id,s.indicador_subsanacion,' +
      's.indicador_rechazo_previo,s.corrected_nif,s.corrected_name,' +
      'COALESCE(NULLIF(s.payload_corregido,''''),s.payload_origen) AS payload_base,' +
      's.chain_queue_id,s.chain_serie,s.chain_numero,s.chain_fecha,s.chain_hash,' +
      'q.serie,q.numero,q.fecha,q.tipo_factura,q.entorno ' +
      'FROM verifactu_subsanaciones s ' +
      'JOIN verifactu_queue q ON q.id=s.queue_id ' +
      'WHERE s.id=:id LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('id').AsLargeInt := ASubID;
    Q.Open;

    if Q.EOF then
    begin
      AError := 'No se localiza la subsanación preparada.';
      Exit;
    end;

    AFinal.SubID := Q.FieldByName('id').AsLargeInt;
    AFinal.QueueIDOrigen := Q.FieldByName('queue_id').AsLargeInt;
    AFinal.Serie := Q.FieldByName('serie').AsString;
    AFinal.Numero := Q.FieldByName('numero').AsString;
    AFinal.Fecha := Q.FieldByName('fecha').AsDateTime;
    AFinal.TipoFactura := Q.FieldByName('tipo_factura').AsString;
    AFinal.Entorno := Q.FieldByName('entorno').AsString;
    AFinal.Subsanacion := Q.FieldByName('indicador_subsanacion').AsString;
    AFinal.RechazoPrevio := Q.FieldByName('indicador_rechazo_previo').AsString;
    AFinal.PayloadOriginal := Q.FieldByName('payload_base').AsString;
    CorrectedNIF := UpperCase(Trim(Q.FieldByName('corrected_nif').AsString));
    CorrectedName := Trim(Q.FieldByName('corrected_name').AsString);
    AFinal.ChainQueueID := Q.FieldByName('chain_queue_id').AsLargeInt;
    AFinal.ChainSerie := Q.FieldByName('chain_serie').AsString;
    AFinal.ChainNumero := Q.FieldByName('chain_numero').AsString;
    if not Q.FieldByName('chain_fecha').IsNull then
      AFinal.ChainFecha := Q.FieldByName('chain_fecha').AsDateTime;
    AFinal.ChainHash := Q.FieldByName('chain_hash').AsString;

    Q.Close;
    Q.SQL.Text :=
      'SELECT id,hash FROM verifactu_queue ORDER BY id DESC LIMIT 1';
    Q.Open;
    if Q.EOF then
    begin
      CurrentLastID := 0;
      CurrentLastHash := '';
    end
    else
    begin
      CurrentLastID := Q.FieldByName('id').AsLargeInt;
      CurrentLastHash := Q.FieldByName('hash').AsString;
    end;

    AFinal.ChainChanged :=
      (CurrentLastID <> AFinal.ChainQueueID) or
      (Trim(CurrentLastHash) <> Trim(AFinal.ChainHash));

    if AFinal.ChainChanged then
    begin
      AError :=
        'El borrador ha quedado obsoleto porque se han generado registros ' +
        'VeriFactu posteriores. Debe regenerar el borrador técnico antes de continuar.';
      Exit;
    end;

    if Trim(AFinal.PayloadOriginal) = '' then
    begin
      AError := 'El registro original no conserva payload_json.';
      Exit;
    end;

    { Validamos el JSON, pero NO lo reconstruimos con FormatJSON. De ese modo
      importes y porcentajes conservan exactamente su notación decimal original. }
    if not VF_JSONValidateObject(AFinal.PayloadOriginal, AError) then Exit;

    { Si existen datos corregidos explícitos, se vuelven a aplicar AQUÍ.
      Esta es la barrera definitiva: el registro final nunca depende solo
      de que el editor hubiera parcheado correctamente payload_corregido. }
    TmpPayload := AFinal.PayloadOriginal;

    { La subsanación DEBE conservar la naturaleza fiscal del ORIG.
      No permitimos que el constructor XML vuelva a inferir F1/F2 por la serie. }
    AFinal.TipoFactura := UpperCase(Trim(AFinal.TipoFactura));
    if (AFinal.TipoFactura <> 'F1') and
       (AFinal.TipoFactura <> 'F2') and
       (AFinal.TipoFactura <> 'R1') and
       (AFinal.TipoFactura <> 'R2') and
       (AFinal.TipoFactura <> 'R3') and
       (AFinal.TipoFactura <> 'R4') and
       (AFinal.TipoFactura <> 'R5') then
    begin
      AError := 'Tipo de factura original no válido para subsanación: ' +
        AFinal.TipoFactura;
      Exit;
    end;

    if not VF_JSONSetStringInObject(TmpPayload, 'cabecera', 'tipoFactura',
      AFinal.TipoFactura, TmpPayload2, AError) then Exit;
    TmpPayload := TmpPayload2;

    if CorrectedNIF <> '' then
    begin
      if not VF_JSONSetStringInObject(TmpPayload, 'cabecera', 'nifCliente',
        CorrectedNIF, TmpPayload2, AError) then Exit;
      TmpPayload := TmpPayload2;
    end;

    if CorrectedName <> '' then
    begin
      if not VF_JSONSetStringInObject(TmpPayload, 'cabecera', 'nombreCliente',
        CorrectedName, TmpPayload2, AError) then Exit;
      TmpPayload := TmpPayload2;
    end;

    { Comprobación fuerte: el JSON FINAL debe conservar el tipo del ORIG. }
    CheckNIF := UpperCase(Trim(VF_JSONGetStringInObject(
      TmpPayload, 'cabecera', 'tipoFactura')));
    if CheckNIF <> AFinal.TipoFactura then
    begin
      AError := 'El JSON final ha cambiado el tipo fiscal. ORIG=' +
        AFinal.TipoFactura + ' JSON=' + CheckNIF +
        '. Se bloquea la subsanación.';
      Exit;
    end;

    { Comprobación fuerte: si había NIF corregido, el JSON FINAL debe contenerlo. }
    if CorrectedNIF <> '' then
    begin
      CheckNIF := UpperCase(Trim(VF_JSONGetStringInObject(
        TmpPayload, 'cabecera', 'nifCliente')));
      if CheckNIF <> CorrectedNIF then
      begin
        AError := 'El JSON final no contiene el NIF/DNI corregido (' +
          CorrectedNIF + '). Se bloquea la subsanación para evitar reenviar ' +
          'los datos originales.';
        Exit;
      end;
    end;

    if not VF_JSONSetTopLevelString(TmpPayload, 'Subsanacion',
      AFinal.Subsanacion, TmpPayload2, AError) then Exit;
    if not VF_JSONSetTopLevelString(TmpPayload2, 'RechazoPrevio',
      AFinal.RechazoPrevio, AFinal.PayloadPreparado, AError) then Exit;

    Result := True;
  except
    on E: Exception do
      AError := E.Message;
  end;
  Q.Free;
end;

end.
