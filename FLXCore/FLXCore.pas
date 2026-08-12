{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit FLXCore;

{$warn 5023 off : no warning about unused units}
interface

uses
  uFLXCorePaths, uFLXCoreProcess, uFLXCoreLog, uFLXCoreSystem, 
  uFLXCoreDiagnostics, uFLXCoreVersion, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('FLXCore', @Register);
end.
