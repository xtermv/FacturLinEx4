unit uFLXRegressionAudit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uFLXAuditTypes, uFLXVersionControl;

type
  TFLXRiskLevel = (rlLow, rlMedium, rlHigh);

  TFLXRegressionEntry = record
    ChangeDate: TDateTime;
    FileName: string;
    Description: string;
    Risk: TFLXRiskLevel;
    RegressionRequired: Boolean;
    Validated: Boolean;
    ValidationNotes: string;
  end;

  TFLXRegressionEntryArray = array of TFLXRegressionEntry;

  TFLXRegressionRegistry = class
  private
    FEntries: TFLXRegressionEntryArray;
  public
    procedure Clear;
    procedure RegisterChange(const AFileName, ADescription: string;
      ARisk: TFLXRiskLevel);
    procedure MarkValidated(AIndex: Integer; const ANotes: string);
    function PendingCount: Integer;
    function Count: Integer;
    function Item(AIndex: Integer): TFLXRegressionEntry;
    procedure AddAuditResults(AReport: TFLXAuditReport);
  end;

function FLXRiskLevelToText(ARisk: TFLXRiskLevel): string;

implementation

function FLXRiskLevelToText(ARisk: TFLXRiskLevel): string;
begin
  case ARisk of
    rlLow: Result := 'BAJO';
    rlMedium: Result := 'MEDIO';
    rlHigh: Result := 'ALTO';
  else
    Result := 'DESCONOCIDO';
  end;
end;

procedure TFLXRegressionRegistry.Clear;
begin
  SetLength(FEntries, 0);
end;

procedure TFLXRegressionRegistry.RegisterChange(const AFileName,
  ADescription: string; ARisk: TFLXRiskLevel);
var
  N: Integer;
begin
  N := Length(FEntries);
  SetLength(FEntries, N + 1);
  FEntries[N].ChangeDate := Now;
  FEntries[N].FileName := AFileName;
  FEntries[N].Description := ADescription;
  FEntries[N].Risk := ARisk;
  FEntries[N].RegressionRequired := FLXIsProtectedUnit(AFileName) or
    (ARisk = rlHigh);
  FEntries[N].Validated := not FEntries[N].RegressionRequired;
  FEntries[N].ValidationNotes := '';
end;

procedure TFLXRegressionRegistry.MarkValidated(AIndex: Integer;
  const ANotes: string);
begin
  if (AIndex < 0) or (AIndex >= Length(FEntries)) then
    raise ERangeError.CreateFmt('Indice de regresion fuera de rango: %d', [AIndex]);
  FEntries[AIndex].Validated := True;
  FEntries[AIndex].ValidationNotes := ANotes;
end;

function TFLXRegressionRegistry.PendingCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to High(FEntries) do
    if FEntries[I].RegressionRequired and (not FEntries[I].Validated) then
      Inc(Result);
end;

function TFLXRegressionRegistry.Count: Integer;
begin
  Result := Length(FEntries);
end;

function TFLXRegressionRegistry.Item(AIndex: Integer): TFLXRegressionEntry;
begin
  if (AIndex < 0) or (AIndex >= Length(FEntries)) then
    raise ERangeError.CreateFmt('Indice de regresion fuera de rango: %d', [AIndex]);
  Result := FEntries[AIndex];
end;

procedure TFLXRegressionRegistry.AddAuditResults(AReport: TFLXAuditReport);
begin
  if not Assigned(AReport) then
    Exit;
  if PendingCount = 0 then
    AReport.Add('REG-001', 'REGRESION', alOK,
      'No hay cambios críticos pendientes de regresión',
      'Las modificaciones registradas no requieren pruebas pendientes.', '', '')
  else
    AReport.Add('REG-001', 'REGRESION', alError,
      'Existen cambios críticos pendientes de regresión',
      Format('Hay %d cambio(s) pendiente(s) de validar.', [PendingCount]),
      'Ejecutar la matriz de pruebas VeriFactu antes de considerar estable la versión.', '');
end;

end.
