unit uFLXLogger;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure FLXLogInfo(const AModulo, AMensaje: string);
procedure FLXLogAviso(const AModulo, AMensaje: string);
procedure FLXLogError(const AModulo, AMensaje: string);
function FLXLogFileName: string;

implementation

function FLXLogDir: string;
begin
  Result := IncludeTrailingPathDelimiter(GetUserDir) + '.local/share/facturlinex/logs';
end;

function FLXLogFileName: string;
begin
  Result := IncludeTrailingPathDelimiter(FLXLogDir) + 'facturlinex_ui.log';
end;

procedure FLXEnsureLogDir;
begin
  if not DirectoryExists(FLXLogDir) then
    ForceDirectories(FLXLogDir);
end;

procedure FLXWriteLog(const ANivel, AModulo, AMensaje: string);
var
  F: TextFile;
  Linea: string;
begin
  try
    FLXEnsureLogDir;
    Linea := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' [' + ANivel + '] [' + AModulo + '] ' + AMensaje;
    AssignFile(F, FLXLogFileName);
    if FileExists(FLXLogFileName) then
      Append(F)
    else
      Rewrite(F);
    try
      Writeln(F, Linea);
    finally
      CloseFile(F);
    end;
  except
    // El logger nunca debe romper FacturLinEx.
  end;
end;

procedure FLXLogInfo(const AModulo, AMensaje: string);
begin
  FLXWriteLog('INFO', AModulo, AMensaje);
end;

procedure FLXLogAviso(const AModulo, AMensaje: string);
begin
  FLXWriteLog('AVISO', AModulo, AMensaje);
end;

procedure FLXLogError(const AModulo, AMensaje: string);
begin
  FLXWriteLog('ERROR', AModulo, AMensaje);
end;

end.
