unit uFLXCoreProcess;
{$mode objfpc}{$H+}
interface
uses Classes, SysUtils, Process;
type TFLXProcessResult=record ExitCode:Integer; OutputText:string; Success:Boolean; end;
function FLXRunProcess(const AExecutable:string; const AParameters:array of string; AWait:Boolean=True):TFLXProcessResult;
function FLXLaunchProcess(const AExecutable:string; const AParameters:array of string):Boolean;
implementation
function FLXRunProcess(const AExecutable:string; const AParameters:array of string; AWait:Boolean):TFLXProcessResult;
var P:TProcess; S:TStringList; Param:string; begin Result.ExitCode:=-1; Result.OutputText:=''; Result.Success:=False; P:=TProcess.Create(nil); S:=TStringList.Create; try P.Executable:=AExecutable; for Param in AParameters do P.Parameters.Add(Param); if AWait then P.Options:=[poUsePipes,poStderrToOutput] else P.Options:=[]; P.Execute; if AWait then begin S.LoadFromStream(P.Output); P.WaitOnExit; Result.ExitCode:=P.ExitStatus; Result.OutputText:=S.Text; Result.Success:=P.ExitStatus=0; end else begin Result.ExitCode:=0; Result.Success:=True; end; finally S.Free; P.Free; end; end;
function FLXLaunchProcess(const AExecutable:string; const AParameters:array of string):Boolean; var R:TFLXProcessResult; begin R:=FLXRunProcess(AExecutable,AParameters,False); Result:=R.Success; end;
end.
