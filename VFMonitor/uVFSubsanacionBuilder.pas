unit uVFSubsanacionBuilder;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, ZConnection, ZDataset;

type
  TVFSubsanacionDraft = record
    QueueIDOrigen: Int64;
    Serie: string;
    Numero: string;
    Fecha: TDateTime;
    Entorno: string;
    TipoFactura: string;
    Subsanacion: string;
    RechazoPrevio: string;
    PayloadOrigen: string;
    HashOrigen: string;
    UltimoQueueID: Int64;
    UltimaSerie: string;
    UltimoNumero: string;
    UltimaFecha: TDateTime;
    UltimoHash: string;
    DraftJSON: string;
  end;

function VF_BuildSubsanacionDraft(AConn: TZConnection; AQueueID: Int64;
  const ASubsanacion, ARechazoPrevio: string;
  out ADraft: TVFSubsanacionDraft; out AError: string): Boolean;

implementation

function JSONString(AObj: TJSONObject; const AName: string): string;
begin
  if AObj.Find(AName) <> nil then
    Result := AObj.Get(AName, '')
  else
    Result := '';
end;

function VF_BuildSubsanacionDraft(AConn: TZConnection; AQueueID: Int64;
  const ASubsanacion, ARechazoPrevio: string;
  out ADraft: TVFSubsanacionDraft; out AError: string): Boolean;
var
  Q: TZQuery;
  Root, InvoiceObj, FlagsObj, ChainObj, MetaObj: TJSONObject;
begin
  Result := False;
  AError := '';
  FillChar(ADraft, SizeOf(ADraft), 0);

  if (AConn = nil) or (not AConn.Connected) then
  begin
    AError := 'No existe una conexión activa con MariaDB.';
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;

    Q.SQL.Text :=
      'SELECT id,serie,numero,fecha,entorno,tipo_factura,payload_json,hash ' +
      'FROM verifactu_queue WHERE id=:id LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('id').AsLargeInt := AQueueID;
    Q.Open;

    if Q.EOF then
    begin
      AError := 'No se localiza el registro original de la cola.';
      Exit;
    end;

    ADraft.QueueIDOrigen := Q.FieldByName('id').AsLargeInt;
    ADraft.Serie := Q.FieldByName('serie').AsString;
    ADraft.Numero := Q.FieldByName('numero').AsString;
    ADraft.Fecha := Q.FieldByName('fecha').AsDateTime;
    ADraft.Entorno := Q.FieldByName('entorno').AsString;
    ADraft.TipoFactura := Q.FieldByName('tipo_factura').AsString;
    ADraft.PayloadOrigen := Q.FieldByName('payload_json').AsString;
    ADraft.HashOrigen := Q.FieldByName('hash').AsString;
    ADraft.Subsanacion := ASubsanacion;
    ADraft.RechazoPrevio := ARechazoPrevio;

    Q.Close;
    Q.SQL.Text :=
      'SELECT id,serie,numero,fecha,hash FROM verifactu_queue ' +
      'ORDER BY id DESC LIMIT 1';
    Q.Open;
    if not Q.EOF then
    begin
      ADraft.UltimoQueueID := Q.FieldByName('id').AsLargeInt;
      ADraft.UltimaSerie := Q.FieldByName('serie').AsString;
      ADraft.UltimoNumero := Q.FieldByName('numero').AsString;
      ADraft.UltimaFecha := Q.FieldByName('fecha').AsDateTime;
      ADraft.UltimoHash := Q.FieldByName('hash').AsString;
    end;

    Root := TJSONObject.Create;
    try
      MetaObj := TJSONObject.Create;
      MetaObj.Add('version_borrador', 'VF-SUB-1');
      MetaObj.Add('generado_en', FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', Now));
      MetaObj.Add('queue_id_origen', ADraft.QueueIDOrigen);
      MetaObj.Add('solo_preparacion', True);
      Root.Add('meta', MetaObj);

      InvoiceObj := TJSONObject.Create;
      InvoiceObj.Add('serie', ADraft.Serie);
      InvoiceObj.Add('numero', ADraft.Numero);
      InvoiceObj.Add('fecha_expedicion', FormatDateTime('yyyy-mm-dd', ADraft.Fecha));
      InvoiceObj.Add('tipo_factura', ADraft.TipoFactura);
      InvoiceObj.Add('entorno', ADraft.Entorno);
      InvoiceObj.Add('hash_registro_origen', ADraft.HashOrigen);
      Root.Add('factura_objetivo', InvoiceObj);

      FlagsObj := TJSONObject.Create;
      FlagsObj.Add('Subsanacion', ADraft.Subsanacion);
      FlagsObj.Add('RechazoPrevio', ADraft.RechazoPrevio);
      Root.Add('indicadores_aeat', FlagsObj);

      ChainObj := TJSONObject.Create;
      ChainObj.Add('queue_id', ADraft.UltimoQueueID);
      ChainObj.Add('serie', ADraft.UltimaSerie);
      ChainObj.Add('numero', ADraft.UltimoNumero);
      if ADraft.UltimaFecha > 0 then
        ChainObj.Add('fecha_expedicion',
          FormatDateTime('yyyy-mm-dd', ADraft.UltimaFecha))
      else
        ChainObj.Add('fecha_expedicion', '');
      ChainObj.Add('huella', ADraft.UltimoHash);
      Root.Add('ancla_encadenamiento', ChainObj);

      { La copia original se conserva como texto, sin reinterpretarla ni modificarla. }
      Root.Add('payload_original', ADraft.PayloadOrigen);

      ADraft.DraftJSON := Root.FormatJSON;
    finally
      Root.Free;
    end;

    Result := True;
  except
    on E: Exception do
      AError := E.Message;
  end;
  Q.Free;
end;

end.
