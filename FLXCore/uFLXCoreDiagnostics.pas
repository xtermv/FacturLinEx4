unit uFLXCoreDiagnostics;
{$mode objfpc}{$H+}
interface
uses Classes, SysUtils, uFLXCorePaths, uFLXCoreSystem;
function FLXGenerateBasicDiagnostic(const AProductName:string; const AExtraLines:TStrings=nil):string;
implementation
function FLXGenerateBasicDiagnostic(const AProductName:string; const AExtraLines:TStrings):string;
var D,N:string; L:TStringList; T:TFLXSystemTools; begin D:=FLXAppConfigDir; if not FLXEnsureDirectory(D) then raise Exception.Create('No se puede crear la carpeta de configuración.'); N:=IncludeTrailingPathDelimiter(D)+'Diagnostico_'+AProductName+'_'+FormatDateTime('yyyymmdd_hhnnss',Now)+'.txt'; T:=FLXDetectSystemTools; L:=TStringList.Create; try L.Add('DIAGNÓSTICO '+UpperCase(AProductName)); L.Add('Fecha='+FormatDateTime('yyyy-mm-dd hh:nn:ss',Now)); L.Add('Raiz='+FLXRootFromExecutable); L.Add('OpenSSL='+T.OpenSSL); L.Add('MariaDB='+T.MariaDB); L.Add('MySQL='+T.MySQL); L.Add('rsync='+T.Rsync); if Assigned(AExtraLines) then L.AddStrings(AExtraLines); L.Add(''); L.Add('No contiene contraseñas ni contenido fiscal.'); L.SaveToFile(N); finally L.Free; end; Result:=N; end;
end.
