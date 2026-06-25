unit uVF_HashChain;

{-------------------------------------------------------------------------------
  uVF_HashChain
  Encadenamiento + hash para verifactu_queue SIN tocar tu unidad principal.
  Llamada: VF_AttachHashToQueue(Conn, Serie, Numero, PayloadJSON, TipoEvento);
-------------------------------------------------------------------------------}

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, DateUtils, ZConnection, ZDataset, uVeriHash;

procedure VF_AttachHashToQueue(const Conn: TZConnection;
  const Serie: string; const Numero: Integer;
  const PayloadJSON: string; const TipoEvento: string = 'ALTA');

implementation

type
  TEmisorInfo = record
    UUID: string;
    NIF:  string;
  end;

const
  // Límite conservador para que vf_hashchain.log no crezca sin control.
  HC_LOG_MAX_LINES      = 2000;
  HC_LOG_TRIM_AT_BYTES  = 512 * 1024; // recorta cuando supera 512 KB
  HC_LOG_MAX_LINE_CHARS = 4000;

{==============================================================================
                              LOG LOCAL (DEBUG)
==============================================================================}
{==============================================================================
                           UTILIDADES DE RUTAS / LOG
==============================================================================}

function HC_DataPath: string;
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

function HC_LimitLogLine(const S: string): string;
begin
  Result := S;
  if Length(Result) > HC_LOG_MAX_LINE_CHARS then
    Result := Copy(Result, 1, HC_LOG_MAX_LINE_CHARS) +
              ' ... [TRUNCADO, longitud original=' + IntToStr(Length(S)) + ' caracteres]';
end;

function HC_GetFileSizeBytes(const FileName: string): Int64;
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

procedure HC_TrimLogFile(const FileName: string);
var
  SL, LastLines: TStringList;
  I, StartIdx: Integer;
begin
  try
    if (HC_LOG_MAX_LINES <= 0) or (not FileExists(FileName)) then
      Exit;

    // Para no penalizar cada escritura, solo recortamos cuando el fichero ya pesa.
    if HC_GetFileSizeBytes(FileName) < HC_LOG_TRIM_AT_BYTES then
      Exit;

    SL := TStringList.Create;
    LastLines := TStringList.Create;
    try
      SL.LoadFromFile(FileName);
      if SL.Count <= HC_LOG_MAX_LINES then
        Exit;

      StartIdx := SL.Count - HC_LOG_MAX_LINES;
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

procedure HC_SafeAppendLine(const FileName, Line: string);
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
      S := HC_LimitLogLine(Line) + LineEnding;
      if S <> '' then
        FS.WriteBuffer(Pointer(S)^, Length(S));
    finally
      FS.Free;
    end;

    HC_TrimLogFile(FileName);
  except
    on E: Exception do ; // suprime diálogo
  end;
end;

// Log muy simple y local de esta unidad, para diagnosticar por qué el hash
// no llega a la tabla. Genera ./vf_hashchain.log en el directorio actual.
procedure HC_WriteDiag(const S: string);
var
  fn: string;
begin
  try
    fn := IncludeTrailingPathDelimiter(HC_DataPath) + 'logs' + DirectorySeparator + 'vf_hashchain.log';
    HC_SafeAppendLine(fn, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + '  ' + S);
  except
    // Nunca romper el flujo por un problema de log
  end;
end;

{==============================================================================
                           AUXILIARES DE LECTURA
==============================================================================}

function GetEmisor(const Conn: TZConnection; out E: TEmisorInfo): Boolean;
var
  q: TZQuery;
begin
  Result := False;
  E.UUID := '';
  E.NIF  := '';

  if Conn = nil then
  begin
    HC_WriteDiag('GetEmisor: Conn=nil');
    Exit;
  end;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'SELECT uuid_emisor, nif_emisor ' +
      'FROM verifactu_config ' +
      'ORDER BY id DESC LIMIT 1';
    q.Open;
    if not q.EOF then
    begin
      E.UUID := Trim(q.Fields[0].AsString);
      E.NIF  := Trim(q.Fields[1].AsString);
      Result := True;
      HC_WriteDiag(Format('GetEmisor: UUID=%s NIF=%s', [E.UUID, E.NIF]));
    end
    else
      HC_WriteDiag('GetEmisor: verifactu_config sin filas');
  finally
    q.Free;
  end;
end;

function GetPrevHash(const Conn: TZConnection; const Serie: string;
  const Numero: Integer): string;
var
  q: TZQuery;
begin
  Result := '';
  if Conn = nil then Exit;

  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'SELECT hash FROM verifactu_queue ' +
      'WHERE serie=:s AND numero<:n AND IFNULL(hash,"")<>"" ' +
      'ORDER BY numero DESC LIMIT 1';
    q.ParamByName('s').AsString  := Serie;
    q.ParamByName('n').AsInteger := Numero;
    q.Open;
    if not q.EOF then
      Result := Trim(q.Fields[0].AsString);
    HC_WriteDiag(Format('GetPrevHash: serie=%s num=%d prevHash=%s',
      [Serie, Numero, Result]));
  finally
    q.Free;
  end;
end;

{==============================================================================
                      CÁLCULO Y ACTUALIZACIÓN DEL HASH
==============================================================================}

procedure VF_AttachHashToQueue(const Conn: TZConnection;
  const Serie: string; const Numero: Integer;
  const PayloadJSON: string; const TipoEvento: string);
var
  em: TEmisorInfo;
  fechaZ, prevH, canonical, hash: string;
  q: TZQuery;
begin
  if Conn = nil then
  begin
    HC_WriteDiag('VF_AttachHashToQueue: Conn=nil, salgo.');
    Exit;
  end;

  HC_WriteDiag(Format('VF_AttachHashToQueue: serie=%s num=%d tipo=%s',
    [Serie, Numero, TipoEvento]));

  // 1) Emisor (lo dejamos igual, para canonical/fecha_isoz)
  if not GetEmisor(Conn, em) then
  begin
    HC_WriteDiag('VF_AttachHashToQueue: GetEmisor devolvió False, no se genera hash_prev.');
    Exit;
  end;

  // 2) Fecha ISO-8601 Z "canónica" (solo a efectos internos)
  fechaZ := ToISO8601Zulu(Now, False);
  HC_WriteDiag('VF_AttachHashToQueue: fechaZ=' + fechaZ);

  // 3) Hash previo: ahora será SIEMPRE el valor del campo hash de la factura anterior
  prevH := GetPrevHash(Conn, Serie, Numero);
  HC_WriteDiag('VF_AttachHashToQueue: prevH=' + prevH);

  // 4) Podemos seguir construyendo una canónica interna si quieres conservarla
  canonical := BuildCanonicalV0(
    em.UUID,
    em.NIF,
    TipoEvento,
    fechaZ,
    prevH + '|' + PayloadJSON,
    '|'
  );

  HC_WriteDiag('VF_AttachHashToQueue: canonical=' + canonical);

  // 5) Actualizar SOLO hash_prev (más fecha_isoz / canonical si quieres)
  q := TZQuery.Create(nil);
  try
    q.Connection := Conn;
    q.SQL.Text :=
      'UPDATE verifactu_queue SET ' +
      '  fecha_isoz = :f, ' +
      '  canonical  = :c, ' +
      '  hash_prev  = :p ' +     // <- YA NO tocamos hash
      'WHERE serie=:s AND numero=:n LIMIT 1';
    q.ParamByName('f').AsString := fechaZ;
    q.ParamByName('c').AsString := canonical;
    q.ParamByName('p').AsString := prevH;
    q.ParamByName('s').AsString := Serie;
    q.ParamByName('n').AsInteger := Numero;

    try
      q.ExecSQL;
      HC_WriteDiag(Format(
        'VF_AttachHashToQueue: UPDATE ok (RowsAffected=%d)',
        [q.RowsAffected]
      ));
    except
      on E: Exception do
        HC_WriteDiag('VF_AttachHashToQueue: EXCEPTION en UPDATE → ' + E.Message);
    end;
  finally
    q.Free;
  end;
end;

end.
