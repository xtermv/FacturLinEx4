unit uFLXVersionControl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils;

const
  FLX_AUDIT_SCHEMA_VERSION = '1.0';

function FLXProtectedUnits: TStringList;
function FLXIsProtectedUnit(const AFileName: string): Boolean;
function FLXNormalizeUnitPath(const AFileName: string): string;

implementation

function FLXNormalizeUnitPath(const AFileName: string): string;
begin
  Result := LowerCase(StringReplace(Trim(AFileName), '\', '/', [rfReplaceAll]));
  while Pos('./', Result) = 1 do
    Delete(Result, 1, 2);
end;

function FLXProtectedUnits: TStringList;
begin
  Result := TStringList.Create;
  Result.CaseSensitive := False;
  Result.Sorted := True;
  Result.Duplicates := dupIgnore;
  Result.Add('Facturar/facturar.pas');
  Result.Add('Ventas/ventas.pas');
  Result.Add('Ventas/uVeriFactu.pas');
  Result.Add('verifactu/uVF_HashChain.pas');
  Result.Add('verifactu/uVF_Integration.pas');
  Result.Add('verifactu/uVF_Sender.pas');
  Result.Add('verifactu/uVFSenderAEAT.pas');
  Result.Add('verifactu/uVeriFactuHTTPSender.pas');
  Result.Add('VFMonitor/uvfqueuemonitor.pas');
  Result.Add('VFMonitor/uVFCentroControl.pas');
end;

function FLXIsProtectedUnit(const AFileName: string): Boolean;
var
  L: TStringList;
  N, Item: string;
  I: Integer;
begin
  Result := False;
  N := FLXNormalizeUnitPath(AFileName);
  L := FLXProtectedUnits;
  try
    for I := 0 to L.Count - 1 do
    begin
      Item := FLXNormalizeUnitPath(L[I]);
      if (N = Item) or (RightStr(N, Length(Item)) = Item) then
        Exit(True);
    end;
  finally
    L.Free;
  end;
end;

end.
