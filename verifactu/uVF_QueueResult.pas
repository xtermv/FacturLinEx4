unit uVF_QueueResult;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, ZConnection, ZDataset;

type
  // Resultado simplificado de un intento de envío HTTP
  TVFSendOutcome = (soOK, soError);

  // Marcar una línea como ENVIADO
  procedure VF_MarkSendOK(const Conn: TZConnection;
                          const Serie: string;
                          const Numero: Integer;
                          const HttpCode: Integer;
                          const ResponseText: string);

  // Marcar una línea como ERROR
  procedure VF_MarkSendError(const Conn: TZConnection;
                             const Serie: string;
                             const Numero: Integer;
                             const HttpCode: Integer;
                             const ResponseText: string;
                             const ErrorSummary: string);

  // Reencolar SOLO errores técnicos reintentables del ejercicio actual.
  // No toca errores AEAT de contenido, integridad/hash ni ejercicios anteriores.
  // Conserva last_error/respuesta_text como evidencia del fallo original.
  function VF_RequeueAllErrors(const Conn: TZConnection): Integer;

implementation

procedure InternalMark(const Conn: TZConnection;
                       const Estado: string;
                       const Serie: string;
                       const Numero: Integer;
                       const HttpCode: Integer;
                       const ResponseText: string;
                       const ErrorSummary: string);
var
  Q: TZQuery;
  MsgShort, ErrShort: string;
begin
  if Conn = nil then Exit;

  // Acotamos un poco tamaños para no saturar
  MsgShort := Copy(ResponseText, 1, 16000);   // MEDIUMTEXT aguanta de sobra
  if ErrorSummary <> '' then
    ErrShort := Copy(ErrorSummary, 1, 255)    // last_error es VARCHAR(255)
  else if HttpCode <> 0 then
    ErrShort := 'HTTP ' + IntToStr(HttpCode)
  else
    ErrShort := '';

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;
    Q.SQL.Text :=
      'UPDATE verifactu_queue ' +
      'SET estado = :e, ' +
      '    respuesta_text = :r, ' +
      '    last_error = :le, ' +
      '    last_attempt_at = NOW(), ' +
      '    token = NULL, claimed_by = NULL, claimed_at = NULL, claimed_until = NULL ' +
      'WHERE serie = :s AND numero = :n';
    Q.ParamByName('e').AsString  := Estado;
    Q.ParamByName('r').AsString  := MsgShort;
    Q.ParamByName('le').AsString := ErrShort;
    Q.ParamByName('s').AsString  := Serie;
    Q.ParamByName('n').AsInteger := Numero;
    try
      Q.ExecSQL;
    except
      // Si aquí peta, no rompemos el flujo de envío; se podría hacer un WriteDiag
    end;
  finally
    Q.Free;
  end;
end;

procedure VF_MarkSendOK(const Conn: TZConnection;
                        const Serie: string;
                        const Numero: Integer;
                        const HttpCode: Integer;
                        const ResponseText: string);
begin
  InternalMark(Conn, 'ENVIADO', Serie, Numero, HttpCode, ResponseText, '');
end;

procedure VF_MarkSendError(const Conn: TZConnection;
                           const Serie: string;
                           const Numero: Integer;
                           const HttpCode: Integer;
                           const ResponseText: string;
                           const ErrorSummary: string);
begin
  InternalMark(Conn, 'ERROR', Serie, Numero, HttpCode, ResponseText, ErrorSummary);
end;

function VF_RequeueAllErrors(const Conn: TZConnection): Integer;
var
  Q: TZQuery;
begin
  Result := 0;
  if Conn = nil then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;

    { IMPORTANTE:
      Esta acción manual NO debe convertir indiscriminadamente todos los
      errores fiscales en PENDIENTE.

      El dispatcher marca como reintentables técnicos estas familias:
        RESPUESTA_NO_RECONOCIDA
        RESPUESTA_INVALIDA
        SOAP_FAULT
        PARSE_XML
        ENVIO_FALLIDO
        EXCEPTION

      Los errores AEAT de contenido (NIF, destinatario, tipo, fechas, etc.)
      se marcan por su código AEAT y NO coinciden con esta lista.
      Tampoco se reencolan incidencias de HASH/encadenamiento.

      Además se limita al ejercicio actual según verifactu_queue.fecha.
      Se conserva last_error, respuesta_text y last_attempt_at como evidencia. }

    Q.SQL.Text :=
      'UPDATE verifactu_queue ' +
      'SET estado = ''PENDIENTE'', ' +
      '    intentos = 0, ' +
      '    claimed_by = NULL, ' +
      '    token = NULL, ' +
      '    claimed_at = NULL, ' +
      '    claimed_until = NULL, ' +
      '    updated_at = NOW() ' +
      'WHERE estado = ''ERROR'' ' +
      '  AND YEAR(fecha) = YEAR(CURDATE()) ' +
      '  AND ( ' +
      '       UPPER(COALESCE(last_error,'''')) LIKE ''RESPUESTA_NO_RECONOCIDA:%'' ' +
      '    OR UPPER(COALESCE(last_error,'''')) LIKE ''RESPUESTA_INVALIDA:%'' ' +
      '    OR UPPER(COALESCE(last_error,'''')) LIKE ''SOAP_FAULT:%'' ' +
      '    OR UPPER(COALESCE(last_error,'''')) LIKE ''PARSE_XML:%'' ' +
      '    OR UPPER(COALESCE(last_error,'''')) = ''ENVIO_FALLIDO'' ' +
      '    OR UPPER(COALESCE(last_error,'''')) LIKE ''EXCEPTION:%'' ' +
      '      ) ' +
      '  AND UPPER(COALESCE(last_error,'''')) NOT LIKE ''%HASH%'' ' +
      '  AND UPPER(COALESCE(last_error,'''')) NOT LIKE ''%HUELLA%'' ' +
      '  AND UPPER(COALESCE(last_error,'''')) NOT LIKE ''%ENCADEN%''';

    try
      Q.ExecSQL;
      Result := Q.RowsAffected;
    except
      Result := 0;
    end;
  finally
    Q.Free;
  end;
end;

end.
