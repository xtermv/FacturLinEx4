unit uVeriFactuHTTPSender;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, httpsend, ssl_openssl, uVeriFactu, uVeriFactuDispatcher, DCPsha256;

{ Configuración del sender HTTP }
procedure VF_HttpConfigure(const AURL: string; const ABearerToken: string = '';
                           const ATimeoutMS: Integer = 10000;
                           const AExtraHeader: string = '');

{ Conecta este sender al dispatcher }
procedure VF_UseHTTPSender;

{ Conectamos con el uVFSenderAEAT modo local desde Menu }
procedure VF_LocalJSONSender;

implementation

var
  CFG_URL: string = '';
  CFG_Bearer: string = '';
  CFG_Timeout: Integer = 10000;
  CFG_ExtraHeader: string = '';

function SHA256Hex(const S: string): string;
var
  Hash: TDCP_sha256;
  Digest: array[0..31] of byte;
  i: Integer;
begin
  Result := '';
  Hash := TDCP_sha256.Create(nil);
  try
    Hash.Init;
    Hash.UpdateStr(S);
    Hash.Final(Digest);
    for i := 0 to High(Digest) do
      Result := Result + IntToHex(Digest[i], 2);
  finally
    Hash.Free;
  end;
end;

function _HTTPSender(const Serie: string; Numero: Integer; const PayloadJSON: string;
                     const EncadenamientoHash: string;
                     out Hash: string; out Respuesta: string): Boolean;
var
  http: THTTPSend;
  ok: Boolean;
  respSL: TStringList;
begin
  Result := False;
  Hash := EncadenamientoHash;	//-- Estaba como '' pero por coherencia se cambia al encadenamiento
  Respuesta := '';
  if CFG_URL = '' then
  begin
    Respuesta := 'VF_HTTP: URL no configurada';
    Exit(False);
  end;

  http := THTTPSend.Create;
  try
    http.Timeout := CFG_Timeout;
    http.Protocol := '1.1';

    http.MimeType := 'application/json; charset=utf-8';
    http.Headers.Add('Content-Type: application/json; charset=utf-8');
    http.Headers.Add('Accept: application/json');

    if CFG_Bearer <> '' then
      http.Headers.Add('Authorization: Bearer ' + CFG_Bearer);
    if CFG_ExtraHeader <> '' then
      http.Headers.Add(CFG_ExtraHeader);

    // payload de solicitud en Document
    http.Document.Size := 0;
    if Length(PayloadJSON) > 0 then
      http.Document.WriteBuffer(Pointer(PayloadJSON)^, Length(PayloadJSON));
    http.Document.Position := 0;

    ok := http.HTTPMethod('POST', CFG_URL);

    // respuesta en Document
    http.Document.Position := 0;
    respSL := TStringList.Create;
    try
      try
        respSL.LoadFromStream(http.Document);
        Respuesta := respSL.Text;
      except
        // si no es texto, devolver tamaño
        Respuesta := Format('<%d bytes binarios>', [http.Document.Size]);
      end;
    finally
      respSL.Free;
    end;

    // hash simple para auditoría (no oficial AEAT)
    Hash := SHA256Hex(PayloadJSON);

    if not ok then
      Exit(False);

    // Éxito si 2xx
    Result := (http.ResultCode >= 200) and (http.ResultCode < 300);
    if not Result then
      Respuesta := Format('HTTP %d %s | %s', [http.ResultCode, http.ResultString, Respuesta]);

  finally
    http.Free;
  end;
end;

procedure VF_HttpConfigure(const AURL: string; const ABearerToken: string;
                           const ATimeoutMS: Integer; const AExtraHeader: string);
begin
  CFG_URL := AURL;
  CFG_Bearer := ABearerToken;
  CFG_Timeout := ATimeoutMS;
  CFG_ExtraHeader := AExtraHeader;
end;

procedure VF_UseHTTPSender;
begin
  VF_SetSender(@_HTTPSender);
end;

procedure VF_LocalJSONSender;
begin
  // Modo pruebas: usar HTTP JSON (tu servidor local)
  VF_UseHTTPSender;
end;


end.
