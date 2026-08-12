unit uFLXRepairPaths;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BaseUnix, uFLXRepairTypes, uFLXRepairBase;

type
  TFLXRepairPaths = class(TFLXRepair)
  public
    function Code: string; override;
    function Title: string; override;
    function Description: string; override;
    function Risk: TFLXRepairRisk; override;
    function CanRepair(out AReason: string): Boolean; override;
    function Execute: TFLXRepairResult; override;
  end;

implementation

function TFLXRepairPaths.Code: string;
begin
  Result := 'CFG-008';
end;

function TFLXRepairPaths.Title: string;
begin
  Result := 'Crear rutas estándar de FacturLinEx';
end;

function TFLXRepairPaths.Description: string;
begin
  Result := 'Crea recursos, informes, documentación y logs.';
end;

function TFLXRepairPaths.Risk: TFLXRepairRisk;
begin
  Result := rrLow;
end;

function TFLXRepairPaths.CanRepair(out AReason: string): Boolean;
begin
  Result := fpGetEUID = 0;
  if Result then AReason := 'Permisos root disponibles.'
  else AReason := 'La reparación requiere permisos root.';
end;

function TFLXRepairPaths.Execute: TFLXRepairResult;
const
  Paths: array[0..3] of string = (
    '/usr/share/facturlinex2',
    '/usr/share/facturlinex2/Report',
    '/usr/share/facturlinex2/Documentacion',
    '/var/log/facturlinex2'
  );
var
  P: string;
  T0: QWord;
  Failed: TStringList;
begin
  T0 := TickMS;
  Result.Code := Code;
  Result.Title := Title;
  Result.Description := Description;
  Result.Risk := Risk;
  Result.NeedRestart := False;
  Result.State := rsFailed;

  if fpGetEUID <> 0 then
  begin
    Result.ActionTaken := 'No se realizó ningún cambio.';
    Result.Evidence := 'Requiere root.';
    Result.ElapsedMS := TickMS - T0;
    Exit;
  end;

  Failed := TStringList.Create;
  try
    for P in Paths do
      if not DirectoryExists(P) then
        if not ForceDirectories(P) then Failed.Add(P);

    if Failed.Count = 0 then
    begin
      Result.State := rsSuccess;
      Result.ActionTaken := 'Rutas comprobadas o creadas.';
      Result.Evidence := 'Recursos, Report, Documentación y logs.';
    end
    else
    begin
      Result.ActionTaken := 'Creación parcial.';
      Result.Evidence := Failed.CommaText;
    end;
  finally
    Failed.Free;
  end;
  Result.ElapsedMS := TickMS - T0;
end;

end.
