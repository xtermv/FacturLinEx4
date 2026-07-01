unit uVeriFactuDispatcher;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, DateUtils, uVeriFactu, uVF_XMLParse, uVFSenderAEAT;

type
  // FunciÃ³n de envÃ­o: devuelve True si "enviÃ³" bien; False si hubo error.
  // Debe rellenar Hash y Respuesta si procede (pueden ir vacÃ­os en modo TEST).
  TVFSendFunc = function(const Serie: string; Numero: Integer;
                         const PayloadJSON: string;
                         const EncadenamientoHash: string;
                         out Hash: string; out Respuesta: string): Boolean;

procedure VF_SetSender(SendFunc: TVFSendFunc);

// EnvÃ­a una sola factura pendiente (si existe).
// Devuelve True si ha procesado alguna (aunque sea con error de envÃ­o).
function VF_DispatchNextPending: Boolean;

// EnvÃ­a UNA factura concreta (si existe y estÃ¡ PENDIENTE).
// Devuelve True si ha procesado alguna (aunque sea con error de envÃ­o).
function VF_DispatchSpecific(const Serie: string; Numero: Integer): Boolean;


// EnvÃ­a hasta MaxPerRun facturas pendientes.
// Devuelve cuÃ¡ntas ha procesado.
function VF_DispatchAllPending(MaxPerRun: Integer): Integer;

// Tick periÃ³dico: recoloca bloqueadas y envÃ­a hasta MaxPerTick.
// TimeoutMinutes: minutos de bloqueo para considerar una factura "atascada".
procedure VF_Tick(const TimeoutMinutes: Integer; const MaxPerTick: Integer);

// Lanza el envÃ­o de pendientes en segundo plano. No bloquea menÃº/ventas.
procedure VF_StartDispatcherThread(const TimeoutMinutes: Integer; const MaxPerRun: Integer);
function VF_DispatcherThreadRunning: Boolean;

//-- Procedimiento de cambio Local o AEAT
procedure VF_ApplyMode(const AMode: Integer);

implementation

uses
  StrUtils, uVeriFactuHTTPSender;  // <- AQUÃ enganchamos el parser XML

const
  // LÃ­mite conservador para que dispatcher.log no crezca sin control.
  VF_LOG_MAX_LINES      = 2000;
  VF_LOG_TRIM_AT_BYTES  = 512 * 1024; // recorta cuando supera 512 KB
  VF_LOG_MAX_LINE_CHARS = 4000;


var
  GSender: TVFSendFunc;
  GEveryNForError: Integer = 0;
  GTestCounter: Integer = 0;
  GLastDispatchTransportError: Boolean = False;
  GVFDispatcherThreadRunning: Boolean = False;
  GVFDispatcherCS: TRTLCriticalSection;


  // ------------------------------------------------------------------
  // PEQUEÃO STUB DE LOG LOCAL
  // (Si ya tienes tu propio logger, cambia aquÃ­ la implementaciÃ³n.)
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

function VF_LimitLogLine(const S: string): string;
begin
  Result := S;
  if Length(Result) > VF_LOG_MAX_LINE_CHARS then
    Result := Copy(Result, 1, VF_LOG_MAX_LINE_CHARS) +
              ' ... [TRUNCADO, longitud original=' + IntToStr(Length(S)) + ' caracteres]';
end;

function VF_GetFileSizeBytes(const FileName: string): Int64;
var
  FS: TFileStream;
begin
  Result := 0;
  if not FileExists(FileName) then
    Exit;

  FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    Result := FS.Size;
  finally
    FS.Free;
  end;
end;

procedure VF_TrimLogFile(const FileName: string);
var
  SL, LastLines: TStringList;
  I, StartIdx: Integer;
begin
  try
    if (VF_LOG_MAX_LINES <= 0) or (not FileExists(FileName)) then
      Exit;

    // Para no penalizar cada escritura, solo recortamos cuando el fichero ya pesa.
    if VF_GetFileSizeBytes(FileName) < VF_LOG_TRIM_AT_BYTES then
      Exit;

    SL := TStringList.Create;
    LastLines := TStringList.Create;
    try
      SL.LoadFromFile(FileName);
      if SL.Count <= VF_LOG_MAX_LINES then
        Exit;

      StartIdx := SL.Count - VF_LOG_MAX_LINES;
      for I := StartIdx to SL.Count - 1 do
        LastLines.Add(SL[I]);

      LastLines.SaveToFile(FileName);
    finally
      LastLines.Free;
      SL.Free;
    end;
  except
    on E: Exception do ; // el log nunca debe romper el flujo
  end;
end;

procedure SafeAppendLine(const FileName, Line: string);
var
  FS: TFileStream;
  S : string;
begin
  try
    EnsureDir(ExtractFilePath(FileName));

    if FileExists(FileName) then
      FS := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone)
    else
      FS := TFileStream.Create(FileName, fmCreate or fmShareDenyNone);

    try
      FS.Position := FS.Size;
      S := VF_LimitLogLine(Line) + LineEnding;
      if S <> '' then
        FS.WriteBuffer(Pointer(S)^, Length(S));
    finally
      FS.Free;
    end;

    VF_TrimLogFile(FileName);
  except
    on E: Exception do ; // suprime diÃ¡logo
  end;
end;

procedure WriteDiag(const Msg: string);
var
  f: string;
begin
  // De momento lo dejamos vacÃ­o para no depender de nada.
  // Si quieres que escriba en consola:
  f := IncludeTrailingPathDelimiter(DataPath) + 'logs' + DirectorySeparator + 'dispatcher.log';
  SafeAppendLine(f, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + '  ' + Msg);
  WriteLn(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + '  ' + Msg);
end;

function VF_DispatcherThreadRunning: Boolean;
begin
  EnterCriticalSection(GVFDispatcherCS);
  try
    Result := GVFDispatcherThreadRunning;
  finally
    LeaveCriticalSection(GVFDispatcherCS);
  end;
end;

procedure VF_SetDispatcherThreadRunning(const AValue: Boolean);
begin
  EnterCriticalSection(GVFDispatcherCS);
  try
    GVFDispatcherThreadRunning := AValue;
  finally
    LeaveCriticalSection(GVFDispatcherCS);
  end;
end;

type
  TVFDispatcherThread = class(TThread)
  private
    FTimeoutMinutes: Integer;
    FMaxPerRun: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(const ATimeoutMinutes: Integer; const AMaxPerRun: Integer);
  end;

constructor TVFDispatcherThread.Create(const ATimeoutMinutes: Integer; const AMaxPerRun: Integer);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FTimeoutMinutes := ATimeoutMinutes;
  FMaxPerRun := AMaxPerRun;
  Start;
end;

procedure TVFDispatcherThread.Execute;
var
  N: Integer;
begin
  try
    WriteDiag(Format('VF worker START timeout=%d max=%d', [FTimeoutMinutes, FMaxPerRun]));

    // Muy importante: en un hilo NO usamos la conexiÃ³n global visual de FacturLinEx.
    // Cada operaciÃ³n abrirÃ¡ conexiÃ³n temporal propia desde uVeriFactu.
    VeriFactu_ForceTempConnectionForCurrentThread(True);
    try
      VeriFactu_RequeueStuck(FTimeoutMinutes);
      N := VF_DispatchAllPending(FMaxPerRun);
      WriteDiag(Format('VF worker END procesadas=%d', [N]));
    finally
      VeriFactu_ForceTempConnectionForCurrentThread(False);
    end;
  except
    on E: Exception do
      WriteDiag('VF worker EXCEPTION: ' + E.Message);
  end;

  VF_SetDispatcherThreadRunning(False);
end;

procedure VF_StartDispatcherThread(const TimeoutMinutes: Integer; const MaxPerRun: Integer);
begin
  if not Assigned(GSender) then
  begin
    WriteDiag('VF_StartDispatcherThread: NO hay sender asignado, salgo.');
    Exit;
  end;

  EnterCriticalSection(GVFDispatcherCS);
  try
    if GVFDispatcherThreadRunning then
    begin
      WriteDiag('VF_StartDispatcherThread: ya hay worker activo, no se lanza otro.');
      Exit;
    end;
    GVFDispatcherThreadRunning := True;
  finally
    LeaveCriticalSection(GVFDispatcherCS);
  end;

  try
    TVFDispatcherThread.Create(TimeoutMinutes, MaxPerRun);
  except
    on E: Exception do
    begin
      VF_SetDispatcherThreadRunning(False);
      WriteDiag('VF_StartDispatcherThread exception: ' + E.Message);
    end;
  end;
end;

function VF_ContainsText(const S, Needle: string): Boolean;
begin
  Result := Pos(UpperCase(Needle), UpperCase(S)) > 0;
end;

function VF_IsWSDLResponse(const S: string): Boolean;
begin
  Result := VF_ContainsText(S, '<wsdl:definitions') or
            VF_ContainsText(S, 'SistemaFacturacion.wsdl');
end;

function VF_IsSOAPFaultResponse(const S: string): Boolean;
begin
  Result := VF_ContainsText(S, '<env:Fault') or
            VF_ContainsText(S, '<soap:Fault') or
            VF_ContainsText(S, 'faultstring');
end;

function VF_ExtractXMLLocalTagValue(const XMLText, LocalTag: string): string;
var
  U, UTag: string;
  P, GT, LT: SizeInt;
begin
  Result := '';
  U := UpperCase(XMLText);
  UTag := UpperCase(LocalTag);
  P := Pos(UTag, U);
  while P > 0 do
  begin
    GT := PosEx('>', XMLText, P);
    if GT <= 0 then Exit;
    LT := PosEx('<', XMLText, GT + 1);
    if LT <= GT then Exit;
    Result := Trim(Copy(XMLText, GT + 1, LT - GT - 1));
    Exit;
  end;
end;

function VF_XMLTieneEstadoRegistro(const XMLText: string): Boolean;
begin
  Result := VF_ExtractXMLLocalTagValue(XMLText, 'EstadoRegistro') <> '';
end;

function VF_XMLPareceRespuestaAEATRegistro(const XMLText: string): Boolean;
begin
  // v7: cualquier XML de respuesta de registro AEAT, aunque sea Incorrecto,
  // NO debe volver a PENDIENTE_REINTENTO. Debe cerrarse como ENVIADO
  // (si Correcto/AceptadoConErrores/duplicado ya registrado) o ERROR
  // de datos/subsanación, para no bloquear documentos posteriores.
  Result := VF_XMLTieneEstadoRegistro(XMLText) or
            VF_ContainsText(XMLText, 'RespuestaRegFactuSistemaFacturacion') or
            VF_ContainsText(XMLText, 'RespuestaLinea') or
            VF_ContainsText(XMLText, 'CodigoErrorRegistro') or
            VF_ContainsText(XMLText, 'DescripcionErrorRegistro') or
            VF_ContainsText(XMLText, 'EstadoEnvio');
end;

function VF_XMLEstadoRegistroEs(const XMLText, Estado: string): Boolean;
begin
  Result := SameText(VF_ExtractXMLLocalTagValue(XMLText, 'EstadoRegistro'), Estado);
end;

function VF_XMLCodigoErrorRegistroEs(const XMLText, Cod: string): Boolean;
begin
  Result := SameText(VF_ExtractXMLLocalTagValue(XMLText, 'CodigoErrorRegistro'), Cod);
end;

function VF_XMLRegistroDuplicadoAceptado(const XMLText: string): Boolean;
var
  EstadoDup: string;
begin
  EstadoDup := VF_ExtractXMLLocalTagValue(XMLText, 'EstadoRegistroDuplicado');

  // AEAT puede responder EstadoRegistro=Incorrecto + CodigoErrorRegistro=3000
  // por duplicado, pero indicar que el registro previamente almacenado estÃ¡
  // Correcta/AceptadaConErrores. En ese caso NO hay que reintentar: ya consta
  // en AEAT y debe tratarse como enviado/localmente cerrado.
  Result := VF_XMLCodigoErrorRegistroEs(XMLText, '3000') and
            (SameText(EstadoDup, 'Correcta') or SameText(EstadoDup, 'AceptadaConErrores'));
end;

procedure VF_MarkAEATResponseErrorNoRetry(const Serie: string; Numero: Integer; const RespStr: string);
var
  Cod, Desc, EstadoReg: string;
begin
  Cod := VF_ExtractXMLLocalTagValue(RespStr, 'CodigoErrorRegistro');
  Desc := VF_ExtractXMLLocalTagValue(RespStr, 'DescripcionErrorRegistro');
  EstadoReg := VF_ExtractXMLLocalTagValue(RespStr, 'EstadoRegistro');

  if Cod = '' then
    Cod := 'AEAT_RESPUESTA_REGISTRO';
  if Desc = '' then
  begin
    if EstadoReg <> '' then
      Desc := 'AEAT respondio EstadoRegistro=' + EstadoReg
    else
      Desc := 'AEAT respondio con XML de registro no aceptado. Revisar respuesta_text.';
  end;

  VeriFactu_MarkError(Serie, Numero, Cod, RespStr);
  WriteDiag(Format('ERROR_AEAT_NO_REINTENTO %s-%d  %s - %s',
    [Serie, Numero, Cod, Copy(Desc, 1, 300)]));
end;

procedure VF_MarkInvalidResponse(const Serie: string; Numero: Integer; const Code, Msg, RespStr: string);
begin
  // WSDL, SOAP Fault o XML sin EstadoRegistro NO son respuesta vÃ¡lida de registro.
  // Deben comportarse como incidencia tÃ©cnica: quedan PENDIENTE para reintento
  // y bloquean la serie hasta recibir una respuesta AEAT de registro real.
  GLastDispatchTransportError := True;
  VeriFactu_MarkRetryOrError(Serie, Numero, Code + ': ' + Msg, RespStr);
  WriteDiag(Format('PENDIENTE_TECNICO %s-%d  %s - %s', [Serie, Numero, Code, Msg]));
end;

// ------------------------------------------------------------------
// Asignar funciÃ³n de envÃ­o
// ------------------------------------------------------------------
procedure VF_SetSender(SendFunc: TVFSendFunc);
begin
  GSender := SendFunc;
  WriteDiag('Sender personalizado ACTIVADO.');
end;

// ------------------------------------------------------------------
// EnvÃ­o de UNA factura pendiente
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
  GLastDispatchTransportError := False;

  try
    // Si no hay sender asignado, no hacemos nada (evitamos errores).
    if not Assigned(GSender) then
    begin
      WriteDiag('VF_DispatchNextPending: NO hay sender asignado, salgo.');
      Exit(False);
    end;

    // Intenta tomar la siguiente pendiente (claim seguro en la cola)
    if not VeriFactu_TakeNextPending(Serie, Numero, Payload, EncadenamientoHash) then
      Exit(False); // no habÃ­a pendientes

    // Enviar usando el sender actual (puede ser local JSON o AEAT XML)
    try
      if GSender(Serie, Numero, Payload, EncadenamientoHash, Hash, RespStr) then
      begin
        // -------------------------------
        // Detectar tipo de respuesta
        // -------------------------------
        Trimmed := Trim(RespStr);

        // Seguridad: un WSDL o un SOAP Fault NO son una respuesta registrada correctamente.
        if VF_IsWSDLResponse(Trimmed) then
        begin
          VF_MarkInvalidResponse(Serie, Numero, 'RESPUESTA_INVALIDA',
            'Se recibio WSDL en lugar de respuesta SOAP AEAT.', RespStr);
          Exit(True);
        end;

        if VF_IsSOAPFaultResponse(Trimmed) then
        begin
          VF_MarkInvalidResponse(Serie, Numero, 'SOAP_FAULT',
            'AEAT devolvio un SOAP Fault. Revisar endpoint/servicio/certificado.', RespStr);
          Exit(True);
        end;

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

            if VF_XMLRegistroDuplicadoAceptado(RespStr) then
            begin
              // Duplicado, pero AEAT informa que el registro anterior consta
              // como Correcta/AceptadaConErrores. Lo cerramos como ENVIADO
              // para no entrar en bucle de reintentos.
              VeriFactu_MarkSent(Serie, Numero, Hash, RespStr);
              WriteDiag(Format(
                'DUPLICADO_YA_REGISTRADO %s-%d  hash=%s  %s - %s',
                [Serie, Numero, Hash, Resp.CodigoError, Resp.DescripcionError]
              ));
            end
            else if VF_XMLEstadoRegistroEs(RespStr, 'Correcto') then
            begin
              VeriFactu_MarkSent(Serie, Numero, Hash, RespStr);
              WriteDiag(Format(
                'ENVIADO %s-%d  hash=%s  CSV=%s',
                [Serie, Numero, Hash, Resp.CSV]
              ));
            end
            else if VF_XMLEstadoRegistroEs(RespStr, 'AceptadoConErrores') or
                    (Pos('AceptadoConErrores', RespStr) > 0) then
            begin
              // AEAT ha registrado el asiento, aunque quede pendiente de subsanar.
              VeriFactu_MarkSent(Serie, Numero, Hash, RespStr);
              WriteDiag(Format(
                'ACEPTADO_CON_ERRORES %s-%d  %s - %s',
                [Serie, Numero, Resp.CodigoError, Resp.DescripcionError]
              ));
            end
            else if VF_XMLTieneEstadoRegistro(RespStr) or (Resp.CodigoError <> '') then
            begin
              // Incorrecto/Rechazado: guardamos cÃ³digo + descripciÃ³n
              VeriFactu_MarkError(Serie, Numero,
                                  Resp.CodigoError,
                                  Resp.DescripcionError + LineEnding + RespStr);
              WriteDiag(Format(
                'ERROR %s-%d  %s - %s',
                [Serie, Numero,
                 Resp.CodigoError,
                 Resp.DescripcionError]
              ));
            end
            else
            begin
              // XML recibido, pero no contiene EstadoRegistro reconocible.
              VF_MarkInvalidResponse(Serie, Numero, 'RESPUESTA_NO_RECONOCIDA',
                'Respuesta XML sin EstadoRegistro AEAT reconocible.', RespStr);
            end;
          except
            on E: Exception do
            begin
              if VF_XMLPareceRespuestaAEATRegistro(RespStr) then
              begin
                VF_MarkAEATResponseErrorNoRetry(Serie, Numero, RespStr);
              end
              else
              begin
                // Si no parece respuesta AEAT de registro, si es tecnico/transitorio.
                GLastDispatchTransportError := True;
                VeriFactu_MarkRetryOrError(Serie, Numero, 'PARSE_XML: ' + E.Message, RespStr);
                WriteDiag(Format(
                  'EXCEPTION parse XML %s-%d  %s',
                  [Serie, Numero, E.Message]
                ));
              end;
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
        // EnvÃ­o fallido pero sin excepciÃ³n. Si pese al Result=False hay una respuesta
        // AEAT con EstadoRegistro, NO es un fallo tÃ©cnico: se cierra como ENVIADO
        // si el duplicado ya consta registrado, o como ERROR de datos/subsanaciÃ³n.
        Trimmed := Trim(RespStr);
        if (not VF_XMLTieneEstadoRegistro(RespStr)) and VF_XMLPareceRespuestaAEATRegistro(RespStr) then
        begin
          VF_MarkAEATResponseErrorNoRetry(Serie, Numero, RespStr);
        end
        else if VF_XMLTieneEstadoRegistro(RespStr) then
        begin
          Resp := VF_ParseResponseXML(RespStr);
          if VF_XMLRegistroDuplicadoAceptado(RespStr) or
             VF_XMLEstadoRegistroEs(RespStr, 'Correcto') or
             VF_XMLEstadoRegistroEs(RespStr, 'AceptadoConErrores') then
          begin
            VeriFactu_MarkSent(Serie, Numero, Hash, RespStr);
            WriteDiag(Format(
              'ENVIADO_CON_RESPUESTA_AEAT %s-%d  %s - %s',
              [Serie, Numero, Resp.CodigoError, Resp.DescripcionError]
            ));
          end
          else
          begin
            VeriFactu_MarkError(Serie, Numero, Resp.CodigoError, Resp.DescripcionError + LineEnding + RespStr);
            WriteDiag(Format(
              'ERROR_AEAT_NO_REINTENTO %s-%d  %s - %s',
              [Serie, Numero, Resp.CodigoError, Resp.DescripcionError]
            ));
          end;
        end
        else if VF_IsWSDLResponse(Trimmed) then
          VF_MarkInvalidResponse(Serie, Numero, 'RESPUESTA_INVALIDA',
            'Se recibio WSDL en lugar de respuesta SOAP AEAT.', RespStr)
        else if VF_IsSOAPFaultResponse(Trimmed) then
          VF_MarkInvalidResponse(Serie, Numero, 'SOAP_FAULT',
            'AEAT devolvio un SOAP Fault. Revisar endpoint/servicio/certificado.', RespStr)
        else
        begin
          GLastDispatchTransportError := True;
          VeriFactu_MarkRetryOrError(Serie, Numero, 'ENVIO_FALLIDO', RespStr);
          WriteDiag(Format(
            'ERROR %s-%d (ENVIO_FALLIDO)',
            [Serie, Numero]
          ));
        end;
      end;
    except
      on E: Exception do
      begin
        // Cualquier excepciÃ³n en el sender se considera tÃ©cnica/transitoria hasta 3 intentos.
        GLastDispatchTransportError := True;
        VeriFactu_MarkRetryOrError(Serie, Numero, 'EXCEPTION: ' + E.Message, '');
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
// EnvÃ­o de UNA factura concreta (Serie+Numero) - reintento exacto
// ------------------------------------------------------------------
function VF_DispatchSpecific(const Serie: string; Numero: Integer): Boolean;
var
  Payload: string;
  EncadenamientoHash: string;
  Hash, RespStr: string;
  Trimmed: string;
  Resp: TVFResponse;
  IsAEATXML: Boolean;
begin
  Result := False;
  GLastDispatchTransportError := False;

  try
    // Si no hay sender asignado, no hacemos nada (evitamos errores).
    if not Assigned(GSender) then
    begin
      WriteDiag('VF_DispatchSpecific: NO hay sender asignado, salgo.');
      Exit(False);
    end;

    // Intenta tomar ESA pendiente (claim seguro en la cola)
    if not VeriFactu_TakeSpecificPending(Serie, Numero, Payload, EncadenamientoHash) then
      Exit(False); // no estÃ¡ pendiente o no es reclamable

    // Enviar usando el sender actual (puede ser local JSON o AEAT XML)
    try
      if GSender(Serie, Numero, Payload, EncadenamientoHash, Hash, RespStr) then
      begin
        // -------------------------------
        // Detectar tipo de respuesta
        // -------------------------------
        Trimmed := Trim(RespStr);

        // Seguridad: un WSDL o un SOAP Fault NO son una respuesta registrada correctamente.
        if VF_IsWSDLResponse(Trimmed) then
        begin
          VF_MarkInvalidResponse(Serie, Numero, 'RESPUESTA_INVALIDA',
            'Se recibio WSDL en lugar de respuesta SOAP AEAT.', RespStr);
          Exit(True);
        end;

        if VF_IsSOAPFaultResponse(Trimmed) then
        begin
          VF_MarkInvalidResponse(Serie, Numero, 'SOAP_FAULT',
            'AEAT devolvio un SOAP Fault. Revisar endpoint/servicio/certificado.', RespStr);
          Exit(True);
        end;

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

            if VF_XMLRegistroDuplicadoAceptado(RespStr) then
            begin
              VeriFactu_MarkSent(Serie, Numero, Hash, RespStr);
              WriteDiag(Format('DUPLICADO_YA_REGISTRADO %s-%d  hash=%s  %s - %s', [Serie, Numero, Hash, Resp.CodigoError, Resp.DescripcionError]));
            end
            else if VF_XMLEstadoRegistroEs(RespStr, 'Correcto') then
            begin
              VeriFactu_MarkSent(Serie, Numero, Hash, RespStr);
              WriteDiag(Format('ENVIADO %s-%d  hash=%s  CSV=%s', [Serie, Numero, Hash, Resp.CSV]));
            end
            else if VF_XMLEstadoRegistroEs(RespStr, 'AceptadoConErrores') or
                    (Pos('AceptadoConErrores', RespStr) > 0) then
            begin
              VeriFactu_MarkSent(Serie, Numero, Hash, RespStr);
              WriteDiag(Format('ACEPTADO_CON_ERRORES %s-%d  %s - %s', [Serie, Numero, Resp.CodigoError, Resp.DescripcionError]));
            end
            else if VF_XMLTieneEstadoRegistro(RespStr) or (Resp.CodigoError <> '') then
            begin
              VeriFactu_MarkError(Serie, Numero, Resp.CodigoError, Resp.DescripcionError + LineEnding + RespStr);
              WriteDiag(Format('ERROR %s-%d  %s - %s', [Serie, Numero, Resp.CodigoError, Resp.DescripcionError]));
            end
            else
            begin
              VF_MarkInvalidResponse(Serie, Numero, 'RESPUESTA_NO_RECONOCIDA',
                'Respuesta XML sin EstadoRegistro AEAT reconocible.', RespStr);
            end;
          except
            on E: Exception do
            begin
              if VF_XMLPareceRespuestaAEATRegistro(RespStr) then
              begin
                VF_MarkAEATResponseErrorNoRetry(Serie, Numero, RespStr);
              end
              else
              begin
                GLastDispatchTransportError := True;
                VeriFactu_MarkRetryOrError(Serie, Numero, 'PARSE_XML: ' + E.Message, RespStr);
                WriteDiag(Format('EXCEPTION parse XML %s-%d  %s', [Serie, Numero, E.Message]));
              end;
            end;
          end;
        end
        else
        begin
          // Respuesta no XML (modo local o texto): si GSender devolviÃ³ True, lo consideramos enviado
          VeriFactu_MarkSent(Serie, Numero, Hash, RespStr);
          WriteDiag(Format('ENVIADO %s-%d  hash=%s (no XML AEAT)', [Serie, Numero, Hash]));
        end;
      end
      else
      begin
        // GSender devolviÃ³ False. Si hay EstadoRegistro en la respuesta, no es
        // transporte/red: AEAT contestÃ³. Por tanto no debe quedar PENDIENTE.
        Trimmed := Trim(RespStr);
        if (not VF_XMLTieneEstadoRegistro(RespStr)) and VF_XMLPareceRespuestaAEATRegistro(RespStr) then
        begin
          VF_MarkAEATResponseErrorNoRetry(Serie, Numero, RespStr);
        end
        else if VF_XMLTieneEstadoRegistro(RespStr) then
        begin
          Resp := VF_ParseResponseXML(RespStr);
          if VF_XMLRegistroDuplicadoAceptado(RespStr) or
             VF_XMLEstadoRegistroEs(RespStr, 'Correcto') or
             VF_XMLEstadoRegistroEs(RespStr, 'AceptadoConErrores') then
          begin
            VeriFactu_MarkSent(Serie, Numero, Hash, RespStr);
            WriteDiag(Format('ENVIADO_CON_RESPUESTA_AEAT %s-%d  %s - %s', [Serie, Numero, Resp.CodigoError, Resp.DescripcionError]));
          end
          else
          begin
            VeriFactu_MarkError(Serie, Numero, Resp.CodigoError, Resp.DescripcionError + LineEnding + RespStr);
            WriteDiag(Format('ERROR_AEAT_NO_REINTENTO %s-%d  %s - %s', [Serie, Numero, Resp.CodigoError, Resp.DescripcionError]));
          end;
        end
        else if VF_IsWSDLResponse(Trimmed) then
          VF_MarkInvalidResponse(Serie, Numero, 'RESPUESTA_INVALIDA',
            'Se recibio WSDL en lugar de respuesta SOAP AEAT.', RespStr)
        else if VF_IsSOAPFaultResponse(Trimmed) then
          VF_MarkInvalidResponse(Serie, Numero, 'SOAP_FAULT',
            'AEAT devolvio un SOAP Fault. Revisar endpoint/servicio/certificado.', RespStr)
        else
        begin
          GLastDispatchTransportError := True;
          VeriFactu_MarkRetryOrError(Serie, Numero, 'ENVIO_FALLIDO', RespStr);
          WriteDiag(Format('ERROR %s-%d (ENVIO_FALLIDO)', [Serie, Numero]));
        end;
      end;
    except
      on E: Exception do
      begin
        GLastDispatchTransportError := True;
        VeriFactu_MarkRetryOrError(Serie, Numero, 'EXCEPTION: ' + E.Message, '');
        WriteDiag(Format('EXCEPTION %s-%d  %s', [Serie, Numero, E.Message]));
      end;
    end;

    Result := True;
  except
    on E: Exception do
      WriteDiag('VF_DispatchSpecific exception: ' + E.Message);
  end;
end;


// ------------------------------------------------------------------
// Bucle de envÃ­o de varias pendientes
// ------------------------------------------------------------------
function VF_DispatchAllPending(MaxPerRun: Integer): Integer;
var
  Procesadas: Integer;
begin
  Procesadas := 0;

  // Si MaxPerRun <= 0, interpretamos "sin lÃ­mite".
  while (MaxPerRun <= 0) or (Procesadas < MaxPerRun) do
  begin
    if not VF_DispatchNextPending then
      Break;
    Inc(Procesadas);

    // Si el Ãºltimo envÃ­o fallÃ³ por red/timeout/transporte, paramos el lote.
    // Evita hacer muchos timeouts seguidos cuando AEAT o la red estÃ¡n caÃ­dos.
    if GLastDispatchTransportError then
    begin
      WriteDiag('VF_DispatchAllPending: paro lote por error tecnico/transporte.');
      Break;
    end;
  end;

  WriteDiag(Format('VF_DispatchAllPending procesadas=%d', [Procesadas]));
  Result := Procesadas;
end;

// ------------------------------------------------------------------
// Tick periÃ³dico (para usar con un TTimer, cron, etc.)
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

initialization
  InitCriticalSection(GVFDispatcherCS);

finalization
  DoneCriticalSection(GVFDispatcherCS);

end.
