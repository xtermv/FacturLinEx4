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

procedure HC_SafeAppendLine(const FileName, Line: string);
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

// Log muy simple y local de esta unidad, para diagnosticar por qué el hash
// no llega a la tabla. Genera ./vf_hashchain.log en el directorio actual.
procedure HC_WriteDiag(const S: string);
var
  fn: string;
  fs: TFileStream;
  line: string;
begin
  try
    fn := IncludeTrailingPathDelimiter(Hc_DataPath) + 'logs' + DirectorySeparator + 'vf_hashchain.log';
    if FileExists(fn) then
      fs := TFileStream.Create(fn, fmOpenReadWrite or fmShareDenyNone)
    else
      fs := TFileStream.Create(fn, fmCreate or fmShareDenyNone);
    try
      fs.Position := fs.Size;
      line := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + '  ' + S + LineEnding;
      fs.WriteBuffer(Pointer(line)^, Length(line));
    finally
      fs.Free;
    end;
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
