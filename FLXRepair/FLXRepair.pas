{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit FLXRepair;

{$warn 5023 off : no warning about unused units}
interface

uses
  uFLXRepairTypes, uFLXRepairBase, uFLXRepairLog, uFLXRepairEngine, 
  uFLXRepairOpenSSL, uFLXRepairDesktop, uFLXRepairPaths, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('FLXRepair', @Register);
end.
