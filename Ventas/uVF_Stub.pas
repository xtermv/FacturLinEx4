unit uVF_Stub;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure VeriFactu_QueueFactura(
  const Serie: string;
  const Numero: Integer;
  const Fecha: TDate;
  const Hora: TTime;
  const TotalConIVA: Double
);

implementation

function TryAppendToFile(const APath, AText: string): boolean;
var
  SL: TStringList;
begin
  Result := False;
  try
    SL := TStringList.Create;
    try
      if FileExists(APath) then
        SL.LoadFromFile(APath);
      SL.Add(AText);
      SL.SaveToFile(APath); // sin encoding explícito para máxima compatibilidad (FPC 3.2.2)
      Result := True;
    finally
      SL.Free;
    end;
  except
    on E: Exception do
    begin
      // silencioso: no romper el flujo
      Result := False;
    end;
  end;
end;

function GetCandidatePaths: TStringList;
var
  HomeDir, AppDir, TmpDir: string;
begin
  Result := TStringList.Create;
  // 1) HOME
  {$IFDEF UNIX}
  HomeDir := GetEnvironmentVariable('HOME');
  {$ELSE}
  HomeDir := GetEnvironmentVariable('USERPROFILE');
  {$ENDIF}
  if HomeDir <> '' then
    Result.Add(IncludeTrailingPathDelimiter(HomeDir) + 'vf_stub.log');

  // 2) /tmp o carpeta temporal del SO
  TmpDir := GetTempDir(False);
  if TmpDir <> '' then
    Result.Add(IncludeTrailingPathDelimiter(TmpDir) + 'vf_stub.log');

  // 3) Carpeta de la aplicación
  AppDir := ExtractFilePath(ParamStr(0));
  if AppDir <> '' then
    Result.Add(IncludeTrailingPathDelimiter(AppDir) + 'vf_stub.log');
end;

procedure VeriFactu_QueueFactura(
  const Serie: string;
  const Numero: Integer;
  const Fecha: TDate;
  const Hora: TTime;
  const TotalConIVA: Double
);
var
  LogEntry, PathItem: string;
  Paths: TStringList;
  i: Integer;
begin
  // Construimos una entrada legible e independiente de locale
  LogEntry := 'VF STUB  -> ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + LineEnding +
              Format('Serie         = %s', [Serie]) + LineEnding +
              Format('Numero        = %d', [Numero]) + LineEnding +
              Format('Fecha         = %s', [FormatDateTime('yyyy-mm-dd', Fecha)]) + LineEnding +
              Format('Hora          = %s', [FormatDateTime('hh:nn:ss', Hora)]) + LineEnding +
              Format('TotalConIVA   = %.2f', [TotalConIVA]) + LineEnding +
              '----------------------------------------' + LineEnding;

  // Intentamos varios destinos por si HOME o permisos fallan
  Paths := GetCandidatePaths;
  try
    for i := 0 to Paths.Count - 1 do
    begin
      PathItem := Paths[i];
      if TryAppendToFile(PathItem, LogEntry) then
        Exit; // éxito en el primer path válido
    end;
  finally
    Paths.Free;
  end;
  // Si todos fallan, callar: nunca interrumpir facturación
end;

end.
