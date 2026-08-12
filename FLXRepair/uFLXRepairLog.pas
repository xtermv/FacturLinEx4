unit uFLXRepairLog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uFLXRepairTypes;

procedure FLXWriteRepairLog(const AResult: TFLXRepairResult);
function FLXRepairLogFile: string;

implementation

function FLXRepairLogFile: string;
var
  D: string;
begin
  D := IncludeTrailingPathDelimiter(GetAppConfigDir(False)) + 'logs';
  if not DirectoryExists(D) then
    ForceDirectories(D);
  Result := IncludeTrailingPathDelimiter(D) + 'flx_repair.log';
end;

procedure FLXWriteRepairLog(const AResult: TFLXRepairResult);
var
  F: TextFile;
  FN: string;
begin
  FN := FLXRepairLogFile;
  AssignFile(F, FN);
  if FileExists(FN) then Append(F) else Rewrite(F);
  try
    WriteLn(F,
      FormatDateTime('yyyy-mm-dd hh:nn:ss', Now), '|',
      AResult.Code, '|',
      FLXRepairRiskToText(AResult.Risk), '|',
      FLXRepairStateToText(AResult.State), '|',
      AResult.Title, '|',
      AResult.ActionTaken, '|',
      AResult.Evidence, '|',
      AResult.ElapsedMS, 'ms');
  finally
    CloseFile(F);
  end;
end;

end.
