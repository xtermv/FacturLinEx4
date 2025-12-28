unit uVeriFactuDispatcher;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, DateUtils, uVeriFactu, uVF_XMLParse, uVFSenderAEAT;

type
  // Función de envío: devuelve True si "envió" bien; False si hubo error.
  // Debe rellenar Hash y Respuesta si procede (pueden ir vacíos en modo TEST).
  TVFSendFunc = function(const Serie: string; Numero: Integer;
                         const PayloadJSON: string;
                         const EncadenamientoHash: string;
                         out Hash: string; out Respuesta: string): Boolean;

procedure VF_SetSender(SendFunc: TVFSendFunc);

// Envía una sola factura pendiente (si existe).
// Devuelve True si ha procesado alguna (aunque sea con error de envío).
function VF_DispatchNextPending: Boolean;

// Envía hasta MaxPerRun facturas pendientes.
// Devuelve cuántas ha procesado.
function VF_DispatchAllPending(MaxPerRun: Integer): Integer;

// Tick periódico: recoloca bloqueadas y envía hasta MaxPerTick.
// TimeoutMinutes: minutos de bloqueo para considerar una factura "atascada".
procedure VF_Tick(const TimeoutMinutes: Integer; const MaxPerTick: Integer);

//-- Procedimiento de cambio Local o AEAT
procedure VF_ApplyMode(const AMode: Integer);

implementation

uses
  StrUtils, uVeriFactuHTTPSender;  // <- AQUÍ enganchamos el parser XML

var
  GSender: TVFSendFunc;
  GEveryNForError: Integer = 0;
  GTestCounter: Integer = 0;


  // ------------------------------------------------------------------
  // PEQUEÑO STUB DE LOG LOCAL
  // (Si ya tienes tu propio logger, cambia aquí la implementación.)
  // ------------------------------------------------------------------

function DataPath: string;
begin
  {$IFDEF UNIX}
  Result := IncludeTrailingPathDelimiter(GetEnvironmentVariable('HOME')) +
            '.local' + DirectorySeparator + 'share' + DirectorySeparator + 'verifactu';
  {$ELSE}
  Result := IncludeTrailingPathDelimiter(GetEnvironmentVariable('USERPROFILE')) +
            '.local' + DirectorySeparator + 'share' + DirectorySeparator + 'verifactu';
  {$ENDIF}
end;

procedure EnsureDir(const APath: string);
begin
  if (APath <> '') and (not DirectoryExists(APath)) then
    ForceDirectories(APath);
end;

procedure SafeAppendLine(const FileName, Line: string);
var
  SL: TStringList;
begin
  try
    EnsureDir(ExtractFilePath(FileName));
    SL := TStringList.Create;
    try
      if FileExists(FileName) then SL.LoadFromFile(FileName);
      SL.Add(Line);
      SL.SaveToFile(FileName);
    finally
      SL.Free;
    end;
  except
    on E: Exception do ; // suprime diálogo
  end;
end;

procedure WriteDiag(const Msg: string);
var
  f: string;
begin
  // De momento lo dejamos vacío para no depender de nada.
  // Si quieres que escriba en consola:
  f := IncludeTrailingPathDelimiter(DataPath) + 'logs' + DirectorySeparator + 'dispatcher.log';
  SafeAppendLine(f, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + '  ' + Msg);
  WriteLn(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + '  ' + Msg);
end;

// ------------------------------------------------------------------
// Asignar función de envío
// ------------------------------------------------------------------
procedure VF_SetSender(SendFunc: TVFSendFunc);
begin
  GSender := SendFunc;
  WriteDiag('Sender personalizado ACTIVADO.');
end;

// ------------------------------------------------------------------
// Envío de UNA factura pendiente
// ------------------------------------------------------------------
function VF_DispatchNextPending: Boolean;
var
  Serie: string;
  Numero: Integer;
  Payload: string;
  EncadenamientoHash: String;
  Hash, RespStr: string;
  Trimmed: string;
  Resp: TVFResponse;     // viene de uVF_XMLParse
  IsAEATXML: Boolean;
begin
  Result := False;

  try
    // Si no hay sender asignado, no hacemos nada (evitamos errores).
    if not Assigned(GSender) then
    begin
      WriteDiag('VF_DispatchNextPending: NO hay sender asignado, salgo.');
      Exit(False);
    end;

    // Intenta tomar la siguiente pendiente (claim seguro en la cola)
    if not VeriFactu_TakeNextPending(Serie, Numero, Payload, EncadenamientoHash) then
      Exit(False); // no había pendientes

    // Enviar usando el sender actual (puede ser local JSON o AEAT XML)
    try
      if GSender(Serie, Numero, Payload, EncadenamientoHash, Hash, RespStr) then
      begin
        // -------------------------------
        // Detectar tipo de respuesta
        // -------------------------------
        Trimmed := Trim(RespStr);

        // AEAT suele responder con un SOAP Envelope en XML.
        // Evitamos parsear HTML (302, errores, etc.).
        IsAEATXML :=
          (Pos('<?xml', Trimmed) = 1) or
          (Pos('<soapenv:Envelope', Trimmed) > 0) or
          (Pos('<soap:Envelope', Trimmed) > 0) or
          (Pos(':Envelope', Trimmed) > 0);

        if IsAEATXML then
        begin
          // *** MODO AEAT: RESPUESTA XML ***
          try
            Resp := VF_ParseResponseXML(RespStr);

            if Resp.CodigoError = '' then
            begin
              // OK: marcamos como enviada. Guardamos la respuesta COMPLETA para poder depurar.
			  VeriFactu_MarkSent(Serie, Numero, Hash, RespStr);
              WriteDiag(Format(
                'ENVIADO %s-%d  hash=%s  CSV=%s',
                [Serie, Numero, Hash, Resp.CSV]
              ));
            end
            else
            begin
              // ERROR: guardamos código + descripción
              VeriFactu_MarkError(Serie, Numero,
                                  Resp.CodigoError,
                                  Resp.DescripcionError);
              WriteDiag(Format(
                'ERROR %s-%d  %s - %s',
                [Serie, Numero,
                 Resp.CodigoError,
                 Resp.DescripcionError]
              ));
            end;
          except
            on E: Exception do
            begin
              // Si falla el parser XML, al menos guardamos el texto de error
              VeriFactu_MarkError(Serie, Numero, 'PARSE_XML', E.Message);
              WriteDiag(Format(
                'EXCEPTION parse XML %s-%d  %s',
                [Serie, Numero, E.Message]
              ));
            end;
          end;
        end
        else
        begin
          // *** MODO PRUEBAS LOCAL / JSON / OTRO TEXTO ***
          // Como antes: marcamos enviado y guardamos la respuesta tal cual.
          VeriFactu_MarkSent(Serie, Numero, Hash, RespStr);
          WriteDiag(Format(
            'ENVIADO %s-%d  hash=%s (no XML AEAT)',
            [Serie, Numero, Hash]
          ));
        end;
      end
      else
      begin
        // Envío fallido pero sin excepción: lo marcamos como error genérico.
        VeriFactu_MarkError(Serie, Numero, 'ENVIO_FALLIDO', RespStr);
        WriteDiag(Format(
          'ERROR %s-%d (ENVIO_FALLIDO)',
          [Serie, Numero]
        ));
      end;
    except
      on E: Exception do
      begin
        // Cualquier excepción en el sender, la registramos como error.
        VeriFactu_MarkError(Serie, Numero, 'EXCEPTION', E.Message);
        WriteDiag(Format(
          'EXCEPTION %s-%d  %s',
          [Serie, Numero, E.Message]
        ));
      end;
    end;

    Result := True;
  except
    on E: Exception do
      WriteDiag('VF_DispatchNextPending exception: ' + E.Message);
  end;
end;

// ------------------------------------------------------------------
// Bucle de envío de varias pendientes
// ------------------------------------------------------------------
function VF_DispatchAllPending(MaxPerRun: Integer): Integer;
var
  Procesadas: Integer;
begin
  Procesadas := 0;

  // Si MaxPerRun <= 0, interpretamos "sin límite".
  while (MaxPerRun <= 0) or (Procesadas < MaxPerRun) do
  begin
    if not VF_DispatchNextPending then
      Break;
    Inc(Procesadas);
  end;

  WriteDiag(Format('VF_DispatchAllPending procesadas=%d', [Procesadas]));
  Result := Procesadas;
end;

// ------------------------------------------------------------------
// Tick periódico (para usar con un TTimer, cron, etc.)
// ------------------------------------------------------------------
procedure VF_Tick(const TimeoutMinutes: Integer; const MaxPerTick: Integer);
begin
  try
    // 1) Recolocar bloqueadas por timeout
    VeriFactu_RequeueStuck(TimeoutMinutes);
    // 2) Enviar hasta N
    VF_DispatchAllPending(MaxPerTick);
  except
    on E: Exception do
      WriteDiag('VF_Tick exception: ' + E.Message);
  end;
end;

procedure VF_ApplyMode(const AMode: Integer);
begin
  //--  showmessage('El Modo Actual de Trabajo es : ' + IntToStr(AMode));
  case AMode of
    0:  // Modo PRUEBAS LOCAL (tu servidor JSON)
      // VF_SetSender(@VF_LocalJSONSender);   // nombre que ya tengas en uVF_Stub
      VF_UseHTTPSender;

    1:  // Modo AEAT (real)
      VF_SetSender(@VF_SendAEAT_HTTP);
  else
    // Por seguridad, si el modo no se reconoce, no mandamos nada
    VF_SetSender(nil);
  end;
end;

end.
