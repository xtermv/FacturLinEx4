unit uFLXRepairEngine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uFLXRepairTypes, uFLXRepairBase, uFLXRepairLog;

type
  TFLXRepairEngine = class
  private
    FRepairs: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterRepair(ARepair: TFLXRepair);
    function Count: Integer;
    function RepairAt(AIndex: Integer): TFLXRepair;
    function AvailableRepairs: TStringList;
    function ExecuteByCode(const ACode: string;
      out AResult: TFLXRepairResult): Boolean;
  end;

implementation

constructor TFLXRepairEngine.Create;
begin
  inherited Create;
  FRepairs := TList.Create;
end;

destructor TFLXRepairEngine.Destroy;
var
  I: Integer;
begin
  for I := 0 to FRepairs.Count - 1 do TObject(FRepairs[I]).Free;
  FRepairs.Free;
  inherited Destroy;
end;

procedure TFLXRepairEngine.RegisterRepair(ARepair: TFLXRepair);
begin
  if Assigned(ARepair) then FRepairs.Add(ARepair);
end;

function TFLXRepairEngine.Count: Integer;
begin
  Result := FRepairs.Count;
end;

function TFLXRepairEngine.RepairAt(AIndex: Integer): TFLXRepair;
begin
  Result := TFLXRepair(FRepairs[AIndex]);
end;

function TFLXRepairEngine.AvailableRepairs: TStringList;
var
  I: Integer;
  R: TFLXRepair;
  Reason: string;
begin
  Result := TStringList.Create;
  for I := 0 to FRepairs.Count - 1 do
  begin
    R := RepairAt(I);
    if R.CanRepair(Reason) then
      Result.Add(R.Code + '|' + R.Title + '|' +
        FLXRepairRiskToText(R.Risk) + '|' + Reason);
  end;
end;

function TFLXRepairEngine.ExecuteByCode(const ACode: string;
  out AResult: TFLXRepairResult): Boolean;
var
  I: Integer;
  R: TFLXRepair;
  Reason: string;
begin
  Result := False;
  FillChar(AResult, SizeOf(AResult), 0);
  for I := 0 to FRepairs.Count - 1 do
  begin
    R := RepairAt(I);
    if SameText(R.Code, ACode) then
    begin
      if not R.CanRepair(Reason) then
      begin
        AResult.Code := R.Code;
        AResult.Title := R.Title;
        AResult.Description := R.Description;
        AResult.Risk := R.Risk;
        AResult.State := rsFailed;
        AResult.ActionTaken := 'Reparación no disponible.';
        AResult.Evidence := Reason;
        FLXWriteRepairLog(AResult);
        Exit(False);
      end;
      AResult := R.Execute;
      FLXWriteRepairLog(AResult);
      Exit(AResult.State = rsSuccess);
    end;
  end;
end;

end.
