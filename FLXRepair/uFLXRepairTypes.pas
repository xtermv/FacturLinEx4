unit uFLXRepairTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TFLXRepairRisk = (rrLow, rrMedium, rrHigh);
  TFLXRepairState = (rsNotApplicable, rsAvailable, rsRunning, rsSuccess, rsFailed);

  TFLXRepairContext = class
  public
    RootDir: string;
    ConfigFile: string;
    DesktopFile: string;
    constructor Create;
  end;

  TFLXRepairResult = record
    Code: string;
    Title: string;
    Description: string;
    ActionTaken: string;
    Evidence: string;
    Risk: TFLXRepairRisk;
    State: TFLXRepairState;
    NeedRestart: Boolean;
    ElapsedMS: QWord;
  end;

function FLXRepairRiskToText(ARisk: TFLXRepairRisk): string;
function FLXRepairStateToText(AState: TFLXRepairState): string;

implementation

constructor TFLXRepairContext.Create;
begin
  inherited Create;
  RootDir := ExpandFileName(ExtractFilePath(ParamStr(0)) + '..');
  ConfigFile := '/etc/facturlinex2/FacturConf.ini';
  DesktopFile := '/usr/share/applications/facturlinex2.desktop';
end;

function FLXRepairRiskToText(ARisk: TFLXRepairRisk): string;
begin
  case ARisk of
    rrLow: Result := 'BAJO';
    rrMedium: Result := 'MEDIO';
    rrHigh: Result := 'ALTO';
  end;
end;

function FLXRepairStateToText(AState: TFLXRepairState): string;
begin
  case AState of
    rsNotApplicable: Result := 'NO APLICABLE';
    rsAvailable: Result := 'DISPONIBLE';
    rsRunning: Result := 'EN CURSO';
    rsSuccess: Result := 'CORRECTO';
    rsFailed: Result := 'ERROR';
  end;
end;

end.
