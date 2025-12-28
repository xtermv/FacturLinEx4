unit uFLX_Backup;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

function FLX_RunBackup(
  const DBName: string;
  const RutaIni: string;
  out OutText: string
): Boolean;

implementation

uses
  Classes, Process, uFLX_Log;

function FLX_RunBackup(
  const DBName: string;
  const RutaIni: string;
  out OutText: string
): Boolean;
var
  P: TProcess;
  SL: TStringList;
  Fecha, HomeDir, RutaConf: string;
begin
  Result := False;
  OutText := '';

  Fecha    := FormatDateTime('yyyymmdd', Now);
  HomeDir := GetEnvironmentVariable('HOME');
  RutaConf := IncludeTrailingPathDelimiter(RutaIni) + 'FacturConf.ini';

  FLX_WriteLog('BACKUP', 'Inicio backup DB=' + DBName);

  P := TProcess.Create(nil);
  SL := TStringList.Create;
  try
    P.Executable := 'sudo';
    P.Parameters.Add('-n');
    P.Parameters.Add('/usr/local/sbin/flx_backup.sh');
    P.Parameters.Add(Fecha);
    P.Parameters.Add(HomeDir);
    P.Parameters.Add(DBName);
    P.Parameters.Add(RutaConf);

    P.Options := [poWaitOnExit, poUsePipes];
    P.Execute;

    SL.LoadFromStream(P.Output);
    OutText := Trim(SL.Text);

    if P.ExitStatus <> 0 then
    begin
      FLX_WriteLog('BACKUP', 'ERROR (' + IntToStr(P.ExitStatus) + ') ' + OutText);
      Exit(False);
    end;

    if OutText <> '' then
      FLX_WriteLog('BACKUP', OutText);

    FLX_WriteLog('BACKUP', 'Fin backup DB=' + DBName);
    Result := True;
  finally
    SL.Free;
    P.Free;
  end;
end;

end.
