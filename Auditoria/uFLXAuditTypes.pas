unit uFLXAuditTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TFLXAuditLevel = (alOK, alWarning, alError, alInfo, alNotChecked);

  TFLXAuditResult = record
    Code: string;
    Category: string;
    Level: TFLXAuditLevel;
    Title: string;
    Description: string;
    RecommendedAction: string;
    Evidence: string;
  end;

  TFLXAuditResultArray = array of TFLXAuditResult;

  TFLXAuditReport = class
  private
    FResults: TFLXAuditResultArray;
    FStartedAt: TDateTime;
    FFinishedAt: TDateTime;
    function GetCount: Integer;
    function GetItem(Index: Integer): TFLXAuditResult;
  public
    constructor Create;
    procedure Clear;
    procedure Add(const ACode, ACategory: string; ALevel: TFLXAuditLevel;
      const ATitle, ADescription, ARecommendedAction: string;
      const AEvidence: string = '');
    procedure Finish;
    function CountByLevel(ALevel: TFLXAuditLevel): Integer;
    function HasErrors: Boolean;
    function HasWarnings: Boolean;
    function OverallLevel: TFLXAuditLevel;
    function ToText: string;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TFLXAuditResult read GetItem; default;
    property StartedAt: TDateTime read FStartedAt;
    property FinishedAt: TDateTime read FFinishedAt;
  end;

function FLXAuditLevelToText(ALevel: TFLXAuditLevel): string;

implementation

function FLXAuditLevelToText(ALevel: TFLXAuditLevel): string;
begin
  case ALevel of
    alOK: Result := 'CORRECTO';
    alWarning: Result := 'AVISO';
    alError: Result := 'ERROR';
    alInfo: Result := 'INFORMACION';
    alNotChecked: Result := 'NO COMPROBADO';
  else
    Result := 'DESCONOCIDO';
  end;
end;

constructor TFLXAuditReport.Create;
begin
  inherited Create;
  Clear;
end;

procedure TFLXAuditReport.Clear;
begin
  SetLength(FResults, 0);
  FStartedAt := Now;
  FFinishedAt := 0;
end;

procedure TFLXAuditReport.Add(const ACode, ACategory: string;
  ALevel: TFLXAuditLevel; const ATitle, ADescription,
  ARecommendedAction: string; const AEvidence: string);
var
  N: Integer;
begin
  N := Length(FResults);
  SetLength(FResults, N + 1);
  FResults[N].Code := ACode;
  FResults[N].Category := ACategory;
  FResults[N].Level := ALevel;
  FResults[N].Title := ATitle;
  FResults[N].Description := ADescription;
  FResults[N].RecommendedAction := ARecommendedAction;
  FResults[N].Evidence := AEvidence;
end;

procedure TFLXAuditReport.Finish;
begin
  FFinishedAt := Now;
end;

function TFLXAuditReport.GetCount: Integer;
begin
  Result := Length(FResults);
end;

function TFLXAuditReport.GetItem(Index: Integer): TFLXAuditResult;
begin
  if (Index < 0) or (Index >= Length(FResults)) then
    raise ERangeError.CreateFmt('Indice de auditoria fuera de rango: %d', [Index]);
  Result := FResults[Index];
end;

function TFLXAuditReport.CountByLevel(ALevel: TFLXAuditLevel): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to High(FResults) do
    if FResults[I].Level = ALevel then
      Inc(Result);
end;

function TFLXAuditReport.HasErrors: Boolean;
begin
  Result := CountByLevel(alError) > 0;
end;

function TFLXAuditReport.HasWarnings: Boolean;
begin
  Result := CountByLevel(alWarning) > 0;
end;

function TFLXAuditReport.OverallLevel: TFLXAuditLevel;
begin
  if HasErrors then
    Exit(alError);
  if HasWarnings then
    Exit(alWarning);
  if CountByLevel(alNotChecked) > 0 then
    Exit(alNotChecked);
  Result := alOK;
end;

function TFLXAuditReport.ToText: string;
var
  I: Integer;
  S: TStringList;
begin
  S := TStringList.Create;
  try
    S.Add('INFORME DE AUDITORIA FACTURLINEX');
    S.Add('Inicio: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', FStartedAt));
    if FFinishedAt > 0 then
      S.Add('Fin:    ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', FFinishedAt));
    S.Add('Resultado general: ' + FLXAuditLevelToText(OverallLevel));
    S.Add('');
    for I := 0 to High(FResults) do
    begin
      S.Add(Format('[%s] %s - %s', [FLXAuditLevelToText(FResults[I].Level),
        FResults[I].Code, FResults[I].Title]));
      if FResults[I].Description <> '' then
        S.Add('  ' + FResults[I].Description);
      if FResults[I].RecommendedAction <> '' then
        S.Add('  Accion: ' + FResults[I].RecommendedAction);
      if FResults[I].Evidence <> '' then
        S.Add('  Evidencia: ' + FResults[I].Evidence);
      S.Add('');
    end;
    Result := S.Text;
  finally
    S.Free;
  end;
end;

end.
