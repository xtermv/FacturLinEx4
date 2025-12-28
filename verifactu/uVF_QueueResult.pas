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

  // Reencolar todas las líneas en estado ERROR (a PENDIENTE)
  // Devuelve cuántos registros ha modificado
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
      '    intentos = intentos + 1, ' +
      '    respuesta_text = :r, ' +
      '    last_error = :le, ' +
      '    last_attempt_at = NOW() ' +
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
    Q.SQL.Text :=
      'UPDATE verifactu_queue ' +
      'SET estado = ''PENDIENTE'', ' +
      '    claimed_by = '''', ' +
      '    token = '''', ' +
      '    claimed_at = NULL, ' +
      '    claimed_until = NULL, ' +
      '    last_error = '''' ' +      // limpiamos el texto de error
      'WHERE estado = ''ERROR''';
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
