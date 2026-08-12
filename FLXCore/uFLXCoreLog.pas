unit uFLXCoreLog;
{$mode objfpc}{$H+}
interface
uses Classes, SysUtils, uFLXCorePaths;
type TFLXLog=class
private FFileName:string; procedure WriteLine(const ALevel,AMessage:string);
public constructor Create(const APrefix:string); property FileName:string read FFileName; procedure Info(const AMessage:string); procedure Warning(const AMessage:string); procedure Error(const AMessage:string); end;
implementation
constructor TFLXLog.Create(const APrefix:string); var D:string; begin inherited Create; D:=IncludeTrailingPathDelimiter(FLXAppConfigDir)+'logs'; if not FLXEnsureDirectory(D) then raise Exception.Create('No se puede crear la carpeta de logs: '+D); FFileName:=IncludeTrailingPathDelimiter(D)+APrefix+'_'+FormatDateTime('yyyymmdd',Date)+'.log'; end;
procedure TFLXLog.WriteLine(const ALevel,AMessage:string); var F:TextFile; begin AssignFile(F,FFileName); if FileExists(FFileName) then Append(F) else Rewrite(F); try WriteLn(F,FormatDateTime('yyyy-mm-dd hh:nn:ss',Now),' [',ALevel,'] ',AMessage); finally CloseFile(F); end; end;
procedure TFLXLog.Info(const AMessage:string); begin WriteLine('INFO',AMessage); end;
procedure TFLXLog.Warning(const AMessage:string); begin WriteLine('AVISO',AMessage); end;
procedure TFLXLog.Error(const AMessage:string); begin WriteLine('ERROR',AMessage); end;
end.
