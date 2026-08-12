unit uFLXCertificateAudit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uFLXAuditTypes;

type
  TFLXCertificateAudit = class
  private
    FReport: TFLXAuditReport;
    procedure CheckFile(const ACode, ATitle, AFileName: string; ARequired: Boolean);
    function LocateExecutable(const AExecutable: string): string;
    procedure CheckExecutable(const ACode, ATitle, AExecutable: string; ARequired: Boolean);
  public
    constructor Create(AReport: TFLXAuditReport);
    procedure Run(const AP12File, ACertPemFile, AKeyPemFile, ACAFile,
      AOpenSSLExecutable: string);
  end;

implementation

constructor TFLXCertificateAudit.Create(AReport: TFLXAuditReport);
begin
  inherited Create;
  if not Assigned(AReport) then
    raise Exception.Create('TFLXCertificateAudit necesita un informe de auditoria');
  FReport := AReport;
end;

procedure TFLXCertificateAudit.CheckFile(const ACode, ATitle, AFileName: string;
  ARequired: Boolean);
var
  FullName: string;
begin
  if Trim(AFileName) = '' then
  begin
    if ARequired then
      FReport.Add(ACode, 'CERTIFICADOS', alWarning, ATitle + ' no configurado',
        'No se ha indicado una ruta para este componente.',
        'Configurar la ruta antes de utilizar el envio VeriFactu.', '')
    else
      FReport.Add(ACode, 'CERTIFICADOS', alInfo, ATitle + ' no configurado',
        'Este componente opcional no tiene ruta configurada.', '', '');
    Exit;
  end;
  FullName := ExpandFileName(AFileName);
  if FileExists(FullName) then
    FReport.Add(ACode, 'CERTIFICADOS', alOK, ATitle + ' localizado',
      'El fichero indicado existe.', '', FullName)
  else
    FReport.Add(ACode, 'CERTIFICADOS', alError, ATitle + ' no localizado',
      'La ruta configurada no corresponde a un fichero existente.',
      'Corregir la ruta o instalar el fichero necesario.', FullName);
end;

function TFLXCertificateAudit.LocateExecutable(const AExecutable: string): string;
var
  Candidate, PathValue: string;
  Paths: TStringList;
  I: Integer;
begin
  Result := '';
  Candidate := Trim(AExecutable);
  if Candidate = '' then
    Candidate := 'openssl';

  { Si se ha indicado una ruta explicita, se respeta. }
  if (ExtractFilePath(Candidate) <> '') or (Candidate[1] = DirectorySeparator) then
  begin
    Candidate := ExpandFileName(Candidate);
    if FileExists(Candidate) then
      Result := Candidate;
    Exit;
  end;

  { Rutas habituales en Debian/Linux. }
  if FileExists('/usr/bin/' + Candidate) then
    Exit('/usr/bin/' + Candidate);
  if FileExists('/bin/' + Candidate) then
    Exit('/bin/' + Candidate);
  if FileExists('/usr/local/bin/' + Candidate) then
    Exit('/usr/local/bin/' + Candidate);

  { Busqueda general en PATH, sin ejecutar ningun comando externo. }
  PathValue := GetEnvironmentVariable('PATH');
  Paths := TStringList.Create;
  try
    Paths.StrictDelimiter := True;
    Paths.Delimiter := PathSeparator;
    Paths.DelimitedText := PathValue;
    for I := 0 to Paths.Count - 1 do
    begin
      if Trim(Paths[I]) = '' then
        Continue;
      Candidate := IncludeTrailingPathDelimiter(Paths[I]) + Trim(AExecutable);
      if FileExists(Candidate) then
        Exit(ExpandFileName(Candidate));
    end;
  finally
    Paths.Free;
  end;
end;

procedure TFLXCertificateAudit.CheckExecutable(const ACode, ATitle,
  AExecutable: string; ARequired: Boolean);
var
  Located, Requested: string;
begin
  Requested := Trim(AExecutable);
  if Requested = '' then
    Requested := 'openssl';
  Located := LocateExecutable(Requested);

  if Located <> '' then
    FReport.Add(ACode, 'CERTIFICADOS', alOK, ATitle + ' localizado',
      'Se ha localizado la herramienta instalada por el sistema.', '', Located)
  else if ARequired then
    FReport.Add(ACode, 'CERTIFICADOS', alError, ATitle + ' no localizado',
      'No se encuentra el ejecutable ni en la ruta configurada ni en el PATH.',
      'Instalar el paquete openssl o corregir OpenSSLPath.', Requested)
  else
    FReport.Add(ACode, 'CERTIFICADOS', alWarning, ATitle + ' no localizado',
      'No se encuentra la herramienta opcional.',
      'Instalarla si resulta necesaria.', Requested);
end;

procedure TFLXCertificateAudit.Run(const AP12File, ACertPemFile, AKeyPemFile,
  ACAFile, AOpenSSLExecutable: string);
begin
  CheckFile('CERT-001', 'Certificado P12', AP12File, False);
  CheckFile('CERT-002', 'Certificado cliente PEM', ACertPemFile, True);
  CheckFile('CERT-003', 'Clave privada PEM', AKeyPemFile, True);
  CheckFile('CERT-004', 'Cadena de confianza CA', ACAFile, False);
  CheckExecutable('CERT-005', 'Ejecutable OpenSSL', AOpenSSLExecutable, True);
end;

end.
