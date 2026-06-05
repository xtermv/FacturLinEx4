unit uFLXRestoreRemote;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Process;

function FLX_IsLocalDBHost(const AHost: string): Boolean;
function FLX_LaunchRemoteRestoreTerminal(
  const ADbHost, ASshUser, ABackupDir, AServerHome, ADbName, AFacturConfPath, AAppExe: string;
  AAppPid: Integer; ARestoreConf, ARestoreAria: Boolean): Boolean;

implementation

function ShellQuote(const S: string): string;
begin
  Result := '''' + StringReplace(S, '''', '''"''"''', [rfReplaceAll]) + '''';
end;

function FLX_IsLocalDBHost(const AHost: string): Boolean;
var
  H: string;
begin
  H := Trim(LowerCase(AHost));
  Result :=
    (H = '') or
    (H = 'localhost') or
    (H = '127.0.0.1') or
    (H = '::1');
end;

function FLX_LaunchRemoteRestoreTerminal(
  const ADbHost, ASshUser, ABackupDir, AServerHome, ADbName, AFacturConfPath, AAppExe: string;
  AAppPid: Integer; ARestoreConf, ARestoreAria: Boolean): Boolean;
var
  P: TProcess;
  Cmd: string;
begin
  Result := False;

  if FLX_IsLocalDBHost(ADbHost) then
    Exit;

  P := TProcess.Create(nil);
  try
    Cmd :=
      '/usr/local/sbin/flx_restore_remote_client_run.sh ' +
      ShellQuote(IntToStr(AAppPid)) + ' ' +
      ShellQuote(AAppExe) + ' ' +
      ShellQuote(ADbHost) + ' ' +
      ShellQuote(ASshUser) + ' ' +
      ShellQuote(ABackupDir) + ' ' +
      ShellQuote(AServerHome) + ' ' +
      ShellQuote(ADbName) + ' ' +
      ShellQuote(AFacturConfPath) + ' ';

    if ARestoreConf then
      Cmd := Cmd + '1 '
    else
      Cmd := Cmd + '0 ';

    if ARestoreAria then
      Cmd := Cmd + '1'
    else
      Cmd := Cmd + '0';

    P.Executable := 'x-terminal-emulator';
    P.Parameters.Add('-e');
    P.Parameters.Add('bash');
    P.Parameters.Add('-lc');
    P.Parameters.Add(Cmd);
    P.Options := [];
    P.Execute;

    Result := True;
  finally
    P.Free;
  end;
end;

end.
