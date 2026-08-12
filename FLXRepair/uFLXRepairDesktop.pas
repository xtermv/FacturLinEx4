unit uFLXRepairDesktop;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BaseUnix, uFLXRepairTypes, uFLXRepairBase;

type
  TFLXRepairDesktop = class(TFLXRepair)
  public
    function Code: string; override;
    function Title: string; override;
    function Description: string; override;
    function Risk: TFLXRepairRisk; override;
    function CanRepair(out AReason: string): Boolean; override;
    function Execute: TFLXRepairResult; override;
  end;

implementation

function TFLXRepairDesktop.Code: string;
begin
  Result := 'DESK-001';
end;

function TFLXRepairDesktop.Title: string;
begin
  Result := 'Regenerar acceso de escritorio';
end;

function TFLXRepairDesktop.Description: string;
begin
  Result := 'Crea el acceso .desktop oficial de FacturLinEx.';
end;

function TFLXRepairDesktop.Risk: TFLXRepairRisk;
begin
  Result := rrLow;
end;

function TFLXRepairDesktop.CanRepair(out AReason: string): Boolean;
begin
  Result := FileExists('/usr/bin/FacturLinEx') and (fpGetEUID = 0);
  if not FileExists('/usr/bin/FacturLinEx') then
    AReason := 'No existe /usr/bin/FacturLinEx.'
  else if fpGetEUID <> 0 then
    AReason := 'La reparación requiere permisos root.'
  else
    AReason := 'Binario instalado y permisos disponibles.';
end;

function TFLXRepairDesktop.Execute: TFLXRepairResult;
var
  L: TStringList;
  T0: QWord;
begin
  T0 := TickMS;
  Result.Code := Code;
  Result.Title := Title;
  Result.Description := Description;
  Result.Risk := Risk;
  Result.NeedRestart := False;
  Result.State := rsFailed;

  if not FileExists('/usr/bin/FacturLinEx') or (fpGetEUID <> 0) then
  begin
    Result.ActionTaken := 'No se realizó ningún cambio.';
    Result.Evidence := 'Falta binario o privilegios.';
    Result.ElapsedMS := TickMS - T0;
    Exit;
  end;

  L := TStringList.Create;
  try
    L.Add('[Desktop Entry]');
    L.Add('Type=Application');
    L.Add('Name=FacturLinEx');
    L.Add('Comment=TPV y facturación');
    L.Add('Exec=/usr/bin/FacturLinEx');
    L.Add('Icon=facturlinex2');
    L.Add('Terminal=false');
    L.Add('Categories=Office;Finance;');
    L.Add('StartupNotify=true');
    L.SaveToFile(FContext.DesktopFile);
  finally
    L.Free;
  end;

  Result.State := rsSuccess;
  Result.ActionTaken := 'Acceso de escritorio regenerado.';
  Result.Evidence := FContext.DesktopFile;
  Result.ElapsedMS := TickMS - T0;
end;

end.
