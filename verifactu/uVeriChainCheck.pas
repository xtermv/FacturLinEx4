unit uVeriChainCheck;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, ZConnection, ZDataset;

type
  TVFChainCheck = record
    Serie: string;
    Total: Integer;
    Mismatches: Integer;
    FirstBadNumero: string;
    FirstBadMsg: string;
  end;

function VF_ValidateSerie(const Conn: TZConnection; const Serie: string): TVFChainCheck;

implementation

function SqlOrderTimestampExpr: string;
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

function VF_ValidateSerie(const Conn: TZConnection; const Serie: string): TVFChainCheck;
var
  Q: TZQuery;
  lastHash, curHash, curPrev: string;
  curNum: string;
  tsExpr: string;
begin
  FillChar(Result, SizeOf(Result), 0);
  Result.Serie := Serie;
  if Conn = nil then Exit;

  tsExpr := SqlOrderTimestampExpr;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;
    Q.SQL.Text :=
      'SELECT numero, hash, hash_prev, ' + tsExpr + ' AS ts ' +
      'FROM verifactu_queue ' +
      'WHERE serie = :s ' +
      'ORDER BY ' + tsExpr + ' ASC, CAST(numero AS UNSIGNED) ASC';
    Q.ParamByName('s').AsString := Serie;
    Q.Open;

    lastHash := '';
    while not Q.EOF do
    begin
      curNum  := Trim(Q.FieldByName('numero').AsString);
      curHash := Trim(Q.FieldByName('hash').AsString);
      curPrev := Trim(Q.FieldByName('hash_prev').AsString);

      if curHash <> '' then
      begin
        Inc(Result.Total);

        if lastHash <> '' then
        begin
          if curPrev <> lastHash then
          begin
            Inc(Result.Mismatches);
            if Result.FirstBadNumero = '' then
            begin
              Result.FirstBadNumero := curNum;
              Result.FirstBadMsg := 'hash_prev=' + curPrev + ' <> prev.hash=' + lastHash;
            end;
          end;
        end
        else
        begin
          if curPrev <> '' then
          begin
            Inc(Result.Mismatches);
            if Result.FirstBadNumero = '' then
            begin
              Result.FirstBadNumero := curNum;
              Result.FirstBadMsg := 'Primera con hash y hash_prev debería estar vacío';
            end;
          end;
        end;

        lastHash := curHash;
      end;

      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

end.
