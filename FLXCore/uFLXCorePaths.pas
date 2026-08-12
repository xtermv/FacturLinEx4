unit uFLXCorePaths;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function FLXFindFirstExisting(const ACandidates: array of string): string;
function FLXExecutablePath(const AName: string): string;
function FLXAppConfigDir: string;
function FLXEnsureDirectory(const APath: string): Boolean;
function FLXRootFromExecutable: string;

implementation

function FLXFindFirstExisting(const ACandidates: array of string): string;
var
  S: string;
begin
  Result := '';
  for S in ACandidates do
    if FileExists(S) or DirectoryExists(S) then
      Exit(ExpandFileName(S));
end;

function FLXExecutablePath(const AName: string): string;
var
  PathValue: string;
  Parts: TStringList;
  I: Integer;
  Candidate: string;
begin
  Result := '';

  if AName = '' then
    Exit;

  if ExtractFilePath(AName) <> '' then
  begin
    if FileExists(AName) then
      Result := ExpandFileName(AName);
    Exit;
  end;

  PathValue := GetEnvironmentVariable('PATH');
  if PathValue = '' then
    Exit;

  Parts := TStringList.Create;
  try
    Parts.StrictDelimiter := True;
    Parts.Delimiter := PathSeparator;
    Parts.DelimitedText := PathValue;

    for I := 0 to Parts.Count - 1 do
    begin
      if Parts[I] = '' then
        Continue;

      Candidate := IncludeTrailingPathDelimiter(Parts[I]) + AName;
      if FileExists(Candidate) then
        Exit(ExpandFileName(Candidate));
    end;
  finally
    Parts.Free;
  end;
end;

function FLXAppConfigDir: string;
begin
  Result := GetAppConfigDir(False);
end;

function FLXEnsureDirectory(const APath: string): Boolean;
begin
  Result := DirectoryExists(APath) or ForceDirectories(APath);
end;

function FLXRootFromExecutable: string;
var
  AppDir: string;
begin
  AppDir := ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  Result := ExpandFileName(AppDir + PathDelim + '..');
end;

end.
