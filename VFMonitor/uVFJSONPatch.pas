unit uVFJSONPatch;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, fpjson, jsonparser;

function VF_JSONValidateObject(const AJSON: string; out AError: string): Boolean;
function VF_JSONSetStringInObject(const AJSON, AObjectName, AFieldName,
  AValue: string; out AResult, AError: string): Boolean;
function VF_JSONGetStringInObject(const AJSON, AObjectName, AFieldName: string): string;
function VF_JSONSetTopLevelString(const AJSON, AFieldName, AValue: string;
  out AResult, AError: string): Boolean;

implementation

function VF_JSONGetStringInObject(const AJSON, AObjectName, AFieldName: string): string;
var
  D, Child: TJSONData;
  Root, Obj: TJSONObject;
begin
  Result := '';
  D := nil;
  try
    D := GetJSON(AJSON);
    if not (D is TJSONObject) then Exit;
    Root := TJSONObject(D);
    Child := Root.Find(AObjectName);
    if (Child = nil) or not (Child is TJSONObject) then Exit;
    Obj := TJSONObject(Child);
    Child := Obj.Find(AFieldName);
    if Child <> nil then
      Result := Child.AsString;
  except
    Result := '';
  end;
  D.Free;
end;


function VF_JSONValidateObject(const AJSON: string; out AError: string): Boolean;
var
  D: TJSONData;
begin
  Result := False;
  AError := '';
  D := nil;
  try
    D := GetJSON(AJSON);
    if not (D is TJSONObject) then
    begin
      AError := 'El payload no es un objeto JSON.';
      Exit;
    end;
    Result := True;
  except
    on E: Exception do
      AError := 'JSON no válido: ' + E.Message;
  end;
  D.Free;
end;

function EscapeJSONString(const S: string): string;
var
  I: Integer;
  C: Char;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    C := S[I];
    case C of
      '"': Result := Result + '\"';
      '\': Result := Result + '\\';
      #8: Result := Result + '\b';
      #9: Result := Result + '\t';
      #10: Result := Result + '\n';
      #12: Result := Result + '\f';
      #13: Result := Result + '\r';
    else
      Result := Result + C;
    end;
  end;
end;

function FindMatchingBrace(const S: string; AOpenPos: Integer;
  out AClosePos: Integer): Boolean;
var
  I, Depth: Integer;
  InString, Escaped: Boolean;
  C: Char;
begin
  Result := False;
  AClosePos := 0;
  if (AOpenPos < 1) or (AOpenPos > Length(S)) or (S[AOpenPos] <> '{') then Exit;

  Depth := 0;
  InString := False;
  Escaped := False;
  for I := AOpenPos to Length(S) do
  begin
    C := S[I];
    if InString then
    begin
      if Escaped then
        Escaped := False
      else if C = '\' then
        Escaped := True
      else if C = '"' then
        InString := False;
      Continue;
    end;

    if C = '"' then
      InString := True
    else if C = '{' then
      Inc(Depth)
    else if C = '}' then
    begin
      Dec(Depth);
      if Depth = 0 then
      begin
        AClosePos := I;
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function FindNamedObject(const S, AObjectName: string;
  out AOpenPos, AClosePos: Integer): Boolean;
var
  K, P, ColonPos: Integer;
  Key: string;
begin
  Result := False;
  AOpenPos := 0;
  AClosePos := 0;
  Key := '"' + AObjectName + '"';
  K := Pos(Key, S);
  if K = 0 then Exit;

  ColonPos := K + Length(Key);
  while (ColonPos <= Length(S)) and (S[ColonPos] <> ':') do Inc(ColonPos);
  if ColonPos > Length(S) then Exit;

  P := ColonPos + 1;
  while (P <= Length(S)) and (S[P] in [' ', #9, #10, #13]) do Inc(P);
  if (P > Length(S)) or (S[P] <> '{') then Exit;

  AOpenPos := P;
  Result := FindMatchingBrace(S, AOpenPos, AClosePos);
end;

function FindRootObject(const S: string; out AOpenPos, AClosePos: Integer): Boolean;
var
  P: Integer;
begin
  Result := False;
  AOpenPos := 0;
  AClosePos := 0;
  P := 1;
  while (P <= Length(S)) and (S[P] in [' ', #9, #10, #13]) do Inc(P);
  if (P > Length(S)) or (S[P] <> '{') then Exit;
  AOpenPos := P;
  Result := FindMatchingBrace(S, AOpenPos, AClosePos);
end;

function ReplaceStringFieldInRange(const S, AFieldName, AValue: string;
  AOpenPos, AClosePos: Integer; out AResult: string): Boolean;
var
  Key, NewValue: string;
  K, P, ValueStart, ValueEnd: Integer;
  InString, Escaped: Boolean;
  C: Char;
begin
  Result := False;
  AResult := S;
  Key := '"' + AFieldName + '"';
  K := PosEx(Key, S, AOpenPos + 1);
  if (K = 0) or (K >= AClosePos) then Exit;

  P := K + Length(Key);
  while (P < AClosePos) and (S[P] <> ':') do Inc(P);
  if P >= AClosePos then Exit;
  Inc(P);
  while (P < AClosePos) and (S[P] in [' ', #9, #10, #13]) do Inc(P);
  if P >= AClosePos then Exit;

  ValueStart := P;
  if S[P] = '"' then
  begin
    InString := True;
    Escaped := False;
    Inc(P);
    while (P < AClosePos) and InString do
    begin
      C := S[P];
      if Escaped then
        Escaped := False
      else if C = '\' then
        Escaped := True
      else if C = '"' then
        InString := False;
      Inc(P);
    end;
    if InString then Exit;
    ValueEnd := P - 1;
  end
  else
  begin
    while (P < AClosePos) and not (S[P] in [',', '}']) do Inc(P);
    ValueEnd := P - 1;
    while (ValueEnd >= ValueStart) and (S[ValueEnd] in [' ', #9, #10, #13]) do
      Dec(ValueEnd);
  end;

  NewValue := '"' + EscapeJSONString(AValue) + '"';
  AResult := Copy(S, 1, ValueStart - 1) + NewValue +
    Copy(S, ValueEnd + 1, MaxInt);
  Result := True;
end;

function InsertStringFieldIntoObject(const S, AFieldName, AValue: string;
  AOpenPos, AClosePos: Integer; out AResult: string): Boolean;
var
  P: Integer;
  Prefix, NewPair: string;
begin
  Result := False;
  AResult := S;
  P := AOpenPos + 1;
  while (P < AClosePos) and (S[P] in [' ', #9, #10, #13]) do Inc(P);

  NewPair := '"' + AFieldName + '":"' + EscapeJSONString(AValue) + '"';
  if P < AClosePos then
    Prefix := ','
  else
    Prefix := '';

  { Insertamos al final para no tocar ninguna representación numérica existente. }
  if Prefix = ',' then
    AResult := Copy(S, 1, AClosePos - 1) + ',' + NewPair +
      Copy(S, AClosePos, MaxInt)
  else
    AResult := Copy(S, 1, AClosePos - 1) + NewPair +
      Copy(S, AClosePos, MaxInt);
  Result := True;
end;

function VF_JSONSetStringInObject(const AJSON, AObjectName, AFieldName,
  AValue: string; out AResult, AError: string): Boolean;
var
  O, C: Integer;
begin
  Result := False;
  AResult := AJSON;
  AError := '';
  if not VF_JSONValidateObject(AJSON, AError) then Exit;
  if not FindNamedObject(AJSON, AObjectName, O, C) then
  begin
    AError := 'No se localiza el objeto JSON "' + AObjectName + '".';
    Exit;
  end;
  if not ReplaceStringFieldInRange(AJSON, AFieldName, AValue, O, C, AResult) then
  begin
    AError := 'No se localiza el campo "' + AFieldName + '" dentro de "' +
      AObjectName + '".';
    Exit;
  end;
  Result := True;
end;

function VF_JSONSetTopLevelString(const AJSON, AFieldName, AValue: string;
  out AResult, AError: string): Boolean;
var
  O, C: Integer;
begin
  Result := False;
  AResult := AJSON;
  AError := '';
  if not VF_JSONValidateObject(AJSON, AError) then Exit;
  if not FindRootObject(AJSON, O, C) then
  begin
    AError := 'No se localiza el objeto raíz del JSON.';
    Exit;
  end;

  if ReplaceStringFieldInRange(AJSON, AFieldName, AValue, O, C, AResult) then
  begin
    Result := True;
    Exit;
  end;

  Result := InsertStringFieldIntoObject(AJSON, AFieldName, AValue, O, C, AResult);
  if not Result then AError := 'No se ha podido insertar el campo "' + AFieldName + '".';
end;

end.
