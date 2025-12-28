unit uVF_Sender;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, ZConnection, ZDataset;

type
  TVFSendResult = (srNone, srOK, srTemporaryError, srPermanentError);
  TVFStatusCallback = procedure(const Step, Detail: string; const Level: Integer);

function VF_SendQueueItem_LocalREST(const Conn: TZConnection;
  const Serie: string; const Numero: Integer;
  const OnStatus: TVFStatusCallback = nil): TVFSendResult;

function VF_SendNextPending_LocalREST(const Conn: TZConnection;
  const OnStatus: TVFStatusCallback = nil): TVFSendResult;

implementation

uses
  httpsend, ssl_openssl;

type
  TVFLocalConf = record
    URL: string;
    TimeoutMS: Integer;
    Retries: Integer;
    BackoffMS: Integer;
  end;

procedure EmitStatus(const OnStatus: TVFStatusCallback; const Step, Detail: string; const Level: Integer);
begin
  if Assigned(OnStatus) then OnStatus(Step, Detail, Level);
end;

function ReadLocalConf(const Conn: TZConnection; out C: TVFLocalConf): Boolean;
var q: TZQuery;
begin
  Result := False;
  FillChar(C, SizeOf(C), 0);
  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'SELECT endpoint_local, COALESCE(timeout_ms,0), COALESCE(retries,0), COALESCE(backoff_ms,0) ' +
      'FROM verifactu_config ORDER BY id DESC LIMIT 1';
    q.Open;
    if not q.EOF then
    begin
      C.URL       := Trim(q.Fields[0].AsString);
      C.TimeoutMS := q.Fields[1].AsInteger; if C.TimeoutMS<=0 then C.TimeoutMS:=8000;
      C.Retries   := q.Fields[2].AsInteger; if C.Retries  <0 then C.Retries  :=0;
      C.BackoffMS := q.Fields[3].AsInteger; if C.BackoffMS<0 then C.BackoffMS:=0;
      Result := C.URL<>'';
    end;
  finally
    q.Free;
  end;
end;

function UpdateQueueEstado(const Conn: TZConnection; const Serie: string; const Numero: Integer;
  const Estado: string; const RespCode: Integer; const RespMsg: string): Boolean;
var q: TZQuery;
begin
  Result := False;
  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    try
      q.SQL.Text := 'UPDATE verifactu_queue SET estado=:e, resp_code=:c, resp_msg=:m WHERE serie=:s AND numero=:n';
      q.ParamByName('e').AsString := Estado;
      q.ParamByName('c').AsInteger:= RespCode;
      q.ParamByName('m').AsString := Copy(RespMsg,1,512);
      q.ParamByName('s').AsString := Serie;
      q.ParamByName('n').AsInteger:= Numero;
      q.ExecSQL;
      Result := True;
    except
      try
        q.SQL.Text := 'UPDATE verifactu_queue SET estado=:e WHERE serie=:s AND numero=:n';
        q.ParamByName('e').AsString := Estado;
        q.ParamByName('s').AsString := Serie;
        q.ParamByName('n').AsInteger:= Numero;
        q.ExecSQL;
        Result := True;
      except
      end;
    end;
  finally
    q.Free;
  end;
end;

function LoadQueueItem(const Conn: TZConnection; const Serie: string; const Numero: Integer;
  out FechaZ, Payload, Canonical, HashPrev, Hash: string): Boolean;
var q: TZQuery;
begin
  Result := False;
  FechaZ := ''; Payload := ''; Canonical := ''; HashPrev := ''; Hash := '';
  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'SELECT COALESCE(fecha_isoz,'''') AS fz, COALESCE(payload,'''') AS pl, ' +
      '       COALESCE(canonical,'''') AS ca, COALESCE(hash_prev,'''') AS hp, COALESCE(hash,'''') AS hh ' +
      'FROM verifactu_queue WHERE serie=:s AND numero=:n LIMIT 1';
    q.ParamByName('s').AsString := Serie;
    q.ParamByName('n').AsInteger:= Numero;
    q.Open;
    if not q.EOF then
    begin
      FechaZ   := q.FieldByName('fz').AsString;
      Payload  := q.FieldByName('pl').AsString;
      Canonical:= q.FieldByName('ca').AsString;
      HashPrev := q.FieldByName('hp').AsString;
      Hash     := q.FieldByName('hh').AsString;
      Result   := True;
    end;
  finally
    q.Free;
  end;
end;

function ComposeLocalJSON(const Serie: string; const Numero: Integer;
  const FechaZ, Payload, Canonical, HashPrev, Hash: string): UTF8String;
  function JEsc(const S: string): string;
  begin
    Result := StringReplace(S, '"', '\"', [rfReplaceAll]);
    Result := StringReplace(Result, '"', '"', [rfReplaceAll]);
  end;
begin
  Result :=
    '{' +
      '"serie":"'     + JEsc(Serie) + '",' +
      '"numero":'     + IntToStr(Numero) + ',' +
      '"fecha_isoz":"' + JEsc(FechaZ) + '",' +
      '"hash_prev":"' + JEsc(HashPrev) + '",' +
      '"hash":"'      + JEsc(Hash) + '",' +
      '"canonical":"' + JEsc(Canonical) + '",' +
      '"payload":'    + Payload +
    '}';
end;

function HTTPPostJSON(const URL: string; const BodyUTF8: UTF8String;
  const TimeoutMS: Integer; out RespCode: Integer; out RespBody: UTF8String): Boolean;
var http: THTTPSend; ss: TStringStream;
begin
  Result := False; RespCode := 0; RespBody := '';
  http := THTTPSend.Create;
  try
    http.MimeType := 'application/json; charset=utf-8';
    http.Timeout := TimeoutMS div 1000;
    ss := TStringStream.Create(string(BodyUTF8), TEncoding.UTF8);
    try
      http.Document.Size := 0;
      ss.Position := 0;
      http.Document.CopyFrom(ss, ss.Size);
      Result := http.HTTPMethod('POST', URL);
      if Result then RespCode := http.ResultCode;
      if http.Document.Size > 0 then
        SetString(RespBody, PChar(http.Document.Memory), http.Document.Size);
    finally
      ss.Free;
    end;
  finally
    http.Free;
  end;
end;

function VF_SendQueueItem_LocalREST(const Conn: TZConnection;
  const Serie: string; const Numero: Integer;
  const OnStatus: TVFStatusCallback): TVFSendResult;
var
  C: TVFLocalConf;
  FechaZ, Payload, Canonical, HashPrev, Hash: string;
  Body: UTF8String;
  Attempt, MaxTry, Code: Integer;
  Resp: UTF8String;
  ok: Boolean;
begin
  Result := srTemporaryError;
  EmitStatus(OnStatus, 'Preparando envío', Serie + '/' + IntToStr(Numero), 0);

  if (Conn = nil) then begin
    EmitStatus(OnStatus, 'Sin conexión', 'Conn=nil', 3);
    Exit(srPermanentError);
  end;

  if not ReadLocalConf(Conn, C) then begin
    EmitStatus(OnStatus, 'Config', 'endpoint_local no definido', 3);
    Exit(srPermanentError);
  end;

  if not LoadQueueItem(Conn, Serie, Numero, FechaZ, Payload, Canonical, HashPrev, Hash) then begin
    EmitStatus(OnStatus, 'Cola', 'Registro no encontrado', 3);
    Exit(srPermanentError);
  end;

  UpdateQueueEstado(Conn, Serie, Numero, 'ENVIANDO', 0, '...');
  EmitStatus(OnStatus, 'Cola', 'ENVIANDO', 0);

  Body := ComposeLocalJSON(Serie, Numero, FechaZ, Payload, Canonical, HashPrev, Hash);

  MaxTry := 1 + C.Retries;
  for Attempt := 1 to MaxTry do
  begin
    EmitStatus(OnStatus, 'POST', Format('Intento %d/%d', [Attempt, MaxTry]), 0);
    ok := HTTPPostJSON(C.URL, Body, C.TimeoutMS, Code, Resp);

    if ok and (Code in [200,201,202]) then
    begin
      UpdateQueueEstado(Conn, Serie, Numero, 'ENVIADO', Code, string(Resp));
      EmitStatus(OnStatus, 'Resultado', 'ENVIADO ('+IntToStr(Code)+')', 1);
      Exit(srOK);
    end;

    if (Code = 0) or (Code = 408) or (Code = 429) or (Code >= 500) then
    begin
      EmitStatus(OnStatus, 'Temporal', 'code='+IntToStr(Code), 2);
      if Attempt < MaxTry then
      begin
        if C.BackoffMS > 0 then Sleep(C.BackoffMS);
        Continue;
      end;
      UpdateQueueEstado(Conn, Serie, Numero, 'REINTENTAR', Code, string(Resp));
      Exit(srTemporaryError);
    end
    else
    begin
      UpdateQueueEstado(Conn, Serie, Numero, 'ERROR', Code, string(Resp));
      EmitStatus(OnStatus, 'Permanente', 'code='+IntToStr(Code), 3);
      Exit(srPermanentError);
    end;
  end;

  UpdateQueueEstado(Conn, Serie, Numero, 'REINTENTAR', Code, string(Resp));
  Result := srTemporaryError;
end;

function VF_SendNextPending_LocalREST(const Conn: TZConnection;
  const OnStatus: TVFStatusCallback): TVFSendResult;
var q: TZQuery; Serie: string; Numero: Integer;
begin
  Result := srNone;
  if (Conn = nil) then
  begin
    EmitStatus(OnStatus, 'Sin conexión', 'Conn=nil', 3);
    Exit(srPermanentError);
  end;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text := 'SELECT serie, numero FROM verifactu_queue WHERE estado="PENDIENTE" ORDER BY id ASC LIMIT 1';
    q.Open;
    if q.EOF then
    begin
      EmitStatus(OnStatus, 'Cola', 'Sin pendientes', 1);
      Exit(srNone);
    end;
    Serie  := q.Fields[0].AsString;
    Numero := q.Fields[1].AsInteger;
  finally
    q.Free;
  end;

  Result := VF_SendQueueItem_LocalREST(Conn, Serie, Numero, OnStatus);
end;

end.
