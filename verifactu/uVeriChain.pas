unit uVeriChain;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, ZConnection, ZDataset, Global;

type
  TVFChainResult = (crOK, crNoPrev, crNotFound, crDBError);

function VF_AttachPrevHash(const Conn: TZConnection;
                           const Serie, Numero: string): TVFChainResult;

function VF_RechainSerie(const Conn: TZConnection; const Serie: string): Integer;

implementation

// === Expresión SQL de timestamp "real" (sin fecha_isoz) ===
// created_at  -> si no hay, usa fecha + hora -> si no, updated_at -> last_attempt_at -> claimed_at
function VF_SqlOrderTimestampExpr: string;
begin
  Result :=
    'COALESCE(' +
    '  created_at,' +
    '  STR_TO_DATE(CONCAT(fecha, '' '', hora), ''%Y-%m-%d %H:%i:%s''),' +
    '  updated_at,' +
    '  last_attempt_at,' +
    '  claimed_at' +
    ')';
end;


function HasColumn(Q: TZQuery; const Col: string): Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to Q.Fields.Count - 1 do
    if SameText(Q.Fields[i].FieldName, Col) then Exit(True);
end;

function TryGetPrevHash_ByFecha(const Conn: TZConnection;
                                const Serie, Numero: string;
                                out PrevHash: string): Boolean;
var
  Q: TZQuery;
  tsExpr: string;
  CurTS: string;
begin
  Result := False;
  PrevHash := '';
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;
    tsExpr := VF_SqlOrderTimestampExpr;

    // 1) Obtener el "timestamp" efectivo de la fila actual
    Q.SQL.Text :=
      'SELECT ' + tsExpr + ' AS ts ' +
      'FROM verifactu_queue ' +
      'WHERE serie=:s AND numero=:n ' +
      'LIMIT 1';
    Q.ParamByName('s').AsString := Serie;
    Q.ParamByName('n').AsString := Numero;
    Q.Open;
    if Q.RecordCount = 0 then Exit(False);
    CurTS := Trim(Q.FieldByName('ts').AsString);
    Q.Close;

    // 2) Buscar el anterior:
    //    - si el TS actual no es NULL: por TS < curTS  o (TS = curTS y numero < n)
    //    - si el TS actual es NULL:   cae a comparar solo por numero (numérico)
    if CurTS <> '' then
    begin
      Q.SQL.Text :=
        'SELECT hash FROM verifactu_queue ' +
        'WHERE serie=:s ' +
        '  AND hash IS NOT NULL AND TRIM(hash)<>'''' ' +
        '  AND ( (' + tsExpr + ' < :ts) OR (' + tsExpr + ' = :ts AND CAST(numero AS UNSIGNED) < CAST(:n AS UNSIGNED)) ) ' +
        'ORDER BY ' + tsExpr + ' DESC, CAST(numero AS UNSIGNED) DESC ' +
        'LIMIT 1';
      Q.ParamByName('s').AsString := Serie;
      Q.ParamByName('ts').AsString := CurTS;
      Q.ParamByName('n').AsString := Numero;
    end
    else
    begin
      // TS actual nulo → fallback por numero únicamente
      Q.SQL.Text :=
        'SELECT hash FROM verifactu_queue ' +
        'WHERE serie=:s ' +
        '  AND hash IS NOT NULL AND TRIM(hash)<>'''' ' +
        '  AND CAST(numero AS UNSIGNED) < CAST(:n AS UNSIGNED) ' +
        'ORDER BY CAST(numero AS UNSIGNED) DESC ' +
        'LIMIT 1';
      Q.ParamByName('s').AsString := Serie;
      Q.ParamByName('n').AsString := Numero;
    end;

    Q.Open;
    if Q.RecordCount > 0 then
    begin
      PrevHash := Trim(Q.FieldByName('hash').AsString);
      Result := PrevHash <> '';
    end;
  finally
    Q.Free;
  end;
end;


function TryGetPrevHash_Fallback(const Conn: TZConnection;
                                 const Serie, Numero: string;
                                 out PrevHash: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  PrevHash := '';
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;
    Q.SQL.Text :=
               'SELECT hash FROM verifactu_queue ' +
               'WHERE serie=:s AND hash IS NOT NULL AND TRIM(hash)<>'''' ' +
               '  AND CAST(numero AS UNSIGNED) < CAST(:n AS UNSIGNED) ' +
               'ORDER BY CAST(numero AS UNSIGNED) DESC ' +
               'LIMIT 1';
    Q.ParamByName('s').AsString  := Serie;
    Q.ParamByName('n').AsString  := Numero;       // aunque sea string, se castea en SQL
    Q.Open;
    if Q.RecordCount > 0 then
    begin
      PrevHash := Trim(Q.FieldByName('hash').AsString);
      Result := PrevHash <> '';
    end;
  finally
    Q.Free;
  end;
end;

function VF_AttachPrevHash(const Conn: TZConnection;
                           const Serie, Numero: string): TVFChainResult;
var
  Q: TZQuery;
  PrevHash, CurHashPrev: string;
  ok: Boolean;
begin
  Result := crDBError;
  if Conn = nil then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;
    Q.SQL.Text := 'SELECT hash_prev FROM verifactu_queue WHERE serie=:s AND numero=:n LIMIT 1';
    Q.ParamByName('s').AsString := Serie;
    Q.ParamByName('n').AsString := Numero;
    Q.Open;
    if Q.RecordCount = 0 then Exit(crNotFound);
    CurHashPrev := Trim(Q.FieldByName('hash_prev').AsString);
    if CurHashPrev <> '' then Exit(crOK);
  finally
    Q.Free;
  end;

  ok := TryGetPrevHash_ByFecha(Conn, Serie, Numero, PrevHash);
  if not ok then ok := TryGetPrevHash_Fallback(Conn, Serie, Numero, PrevHash);

  if not ok then Exit(crNoPrev);

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;
    Q.SQL.Text := 'UPDATE verifactu_queue SET hash_prev=:p WHERE serie=:s AND numero=:n';
    Q.ParamByName('p').AsString := PrevHash;
    Q.ParamByName('s').AsString := Serie;
    Q.ParamByName('n').AsString := Numero;
    Q.ExecSQL;
    GHashPrev := PrevHash;  //-- ASIGNAMOS EL VALOR DEL HASH PREVIO A LA VARIABLE GLOBAL
    Result := crOK;
  finally
    Q.Free;
  end;
end;

function VF_RechainSerie(const Conn: TZConnection; const Serie: string): Integer;
var
  Q: TZQuery;
  SerieLoc, Numero, LastHash: string;
begin
  Result := 0;
  if Conn = nil then Exit;

  LastHash := '';

  try
    Q := TZQuery.Create(nil);
    Q.Connection := Conn;
    Q.SQL.Text :=
      'SELECT serie, numero, hash, hash_prev, fecha_isoz ' +
      'FROM verifactu_queue ' +
      'WHERE serie=:s ' +
      'ORDER BY fecha_isoz ASC, numero ASC';
    Q.ParamByName('s').AsString := Serie;
    Q.Open;
  except
    Q.Free;
    Q := TZQuery.Create(nil);
    Q.Connection := Conn;
    Q.SQL.Text :=
      'SELECT serie, numero, hash, hash_prev ' +
      'FROM verifactu_queue ' +
      'WHERE serie=:s ' +
      'ORDER BY numero ASC';
    Q.ParamByName('s').AsString := Serie;
    Q.Open;
  end;

  try
    while not Q.EOF do
    begin
      SerieLoc := Trim(Q.FieldByName('serie').AsString);
      Numero   := Trim(Q.FieldByName('numero').AsString);
      if Trim(Q.FieldByName('hash').AsString) <> '' then
      begin
        if (LastHash <> '') and (Trim(Q.FieldByName('hash_prev').AsString) = '') then
        begin
          with TZQuery.Create(nil) do
          try
            Connection := Conn;
            SQL.Text := 'UPDATE verifactu_queue SET hash_prev=:p WHERE serie=:s AND numero=:n';
            ParamByName('p').AsString := LastHash;
            ParamByName('s').AsString := SerieLoc;
            ParamByName('n').AsString := Numero;
            ExecSQL;
            Inc(Result);
          finally
            Free;
          end;
        end;
        LastHash := Trim(Q.FieldByName('hash').AsString);
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

end.
