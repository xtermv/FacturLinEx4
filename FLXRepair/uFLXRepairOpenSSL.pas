unit uFLXRepairOpenSSL;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, uFLXRepairTypes, uFLXRepairBase;

type
  TFLXRepairOpenSSL = class(TFLXRepair)
  private
    function FindOpenSSL: string;
  public
    function Code: string; override;
    function Title: string; override;
    function Description: string; override;
    function Risk: TFLXRepairRisk; override;
    function CanRepair(out AReason: string): Boolean; override;
    function Execute: TFLXRepairResult; override;
  end;

implementation

function TFLXRepairOpenSSL.FindOpenSSL: string;
const
  Candidates: array[0..2] of string = (
    '/usr/bin/openssl', '/bin/openssl', '/usr/local/bin/openssl'
  );
var
  S, Candidate: string;
  Parts: TStringList;
  I: Integer;
begin
  Result := '';
  for S in Candidates do
    if FileExists(S) then Exit(S);

  Parts := TStringList.Create;
  try
    Parts.StrictDelimiter := True;
    Parts.Delimiter := PathSeparator;
    Parts.DelimitedText := GetEnvironmentVariable('PATH');
    for I := 0 to Parts.Count - 1 do
    begin
      if Parts[I] = '' then Continue;
      Candidate := IncludeTrailingPathDelimiter(Parts[I]) + 'openssl';
      if FileExists(Candidate) then Exit(Candidate);
    end;
  finally
    Parts.Free;
  end;
end;

function TFLXRepairOpenSSL.Code: string;
begin
  Result := 'CERT-005';
end;

function TFLXRepairOpenSSL.Title: string;
begin
  Result := 'Configurar ruta de OpenSSL';
end;

function TFLXRepairOpenSSL.Description: string;
begin
  Result := 'Localiza OpenSSL y actualiza su ruta en FacturConf.ini.';
end;

function TFLXRepairOpenSSL.Risk: TFLXRepairRisk;
begin
  Result := rrMedium;
end;

function TFLXRepairOpenSSL.CanRepair(out AReason: string): Boolean;
var
  P: string;
begin
  P := FindOpenSSL;
  Result := (P <> '') and FileExists(FContext.ConfigFile);
  if P = '' then
    AReason := 'OpenSSL no está instalado o no es localizable.'
  else if not FileExists(FContext.ConfigFile) then
    AReason := 'No existe ' + FContext.ConfigFile
  else
    AReason := 'OpenSSL localizado en ' + P;
end;

function TFLXRepairOpenSSL.Execute: TFLXRepairResult;
var
  Ini: TIniFile;
  P, Backup: string;
  SourceStream, DestStream: TFileStream;
  T0: QWord;
begin
  T0 := TickMS;
  Result.Code := Code;
  Result.Title := Title;
  Result.Description := Description;
  Result.Risk := Risk;
  Result.NeedRestart := False;
  Result.State := rsFailed;

  P := FindOpenSSL;
  if (P = '') or not FileExists(FContext.ConfigFile) then
  begin
    Result.ActionTaken := 'No se realizó ningún cambio.';
    Result.Evidence := 'Falta OpenSSL o configuración.';
    Result.ElapsedMS := TickMS - T0;
    Exit;
  end;

  Backup := FContext.ConfigFile + '.bak.' + FormatDateTime('yyyymmdd_hhnnss', Now);
  SourceStream := TFileStream.Create(FContext.ConfigFile, fmOpenRead or fmShareDenyWrite);
  try
    DestStream := TFileStream.Create(Backup, fmCreate);
    try
      DestStream.CopyFrom(SourceStream, 0);
    finally
      DestStream.Free;
    end;
  finally
    SourceStream.Free;
  end;

  Ini := TIniFile.Create(FContext.ConfigFile);
  try
    Ini.WriteString('VeriFactu', 'OpenSSLPath', P);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;

  Result.State := rsSuccess;
  Result.ActionTaken := 'Actualizada la ruta de OpenSSL.';
  Result.Evidence := P + ' | Copia: ' + Backup;
  Result.ElapsedMS := TickMS - T0;
end;

end.
