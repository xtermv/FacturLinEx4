unit uFLXRepairBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uFLXRepairTypes;

type
  TFLXRepair = class
  protected
    FContext: TFLXRepairContext;
    function TickMS: QWord;
  public
    constructor Create(AContext: TFLXRepairContext); virtual;
    function Code: string; virtual; abstract;
    function Title: string; virtual; abstract;
    function Description: string; virtual; abstract;
    function Risk: TFLXRepairRisk; virtual; abstract;
    function EstimatedSeconds: Integer; virtual;
    function NeedRestart: Boolean; virtual;
    function CanRepair(out AReason: string): Boolean; virtual; abstract;
    function Execute: TFLXRepairResult; virtual; abstract;
  end;

implementation

constructor TFLXRepair.Create(AContext: TFLXRepairContext);
begin
  inherited Create;
  FContext := AContext;
end;

function TFLXRepair.TickMS: QWord;
begin
  Result := GetTickCount64;
end;

function TFLXRepair.EstimatedSeconds: Integer;
begin
  Result := 5;
end;

function TFLXRepair.NeedRestart: Boolean;
begin
  Result := False;
end;

end.
