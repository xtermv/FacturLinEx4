unit uFLXInstallationAudit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uFLXAuditTypes;

type
  TFLXInstallationAudit = class
  private
    FReport: TFLXAuditReport;
    function FindCommand(const ANames: array of string): string;
    procedure CheckRequiredCommand(const ACode, ATitle: string;
      const ANames: array of string; const AInstallHint: string);
    procedure CheckOptionalCommand(const ACode, ATitle: string;
      const ANames: array of string; const AInstallHint: string);
    procedure CheckInstallationDirectories;
    procedure CheckConfigDirectory(const AConfigFile: string);
  public
    constructor Create(AReport: TFLXAuditReport);
    procedure Run(const AConfigFile: string);
  end;

implementation

constructor TFLXInstallationAudit.Create(AReport: TFLXAuditReport);
begin
  inherited Create;
  if not Assigned(AReport) then
    raise Exception.Create('TFLXInstallationAudit necesita un informe de auditoria');
  FReport := AReport;
end;

function TFLXInstallationAudit.FindCommand(const ANames: array of string): string;
const
  CommonDirs: array[0..2] of string = ('/usr/bin', '/bin', '/usr/local/bin');
var
  I, J: Integer;
  Candidate, PathValue: string;
begin
  Result := '';
  for I := Low(ANames) to High(ANames) do
  begin
    if Trim(ANames[I]) = '' then Continue;
    if ExtractFilePath(ANames[I]) <> '' then
    begin
      Candidate := ExpandFileName(ANames[I]);
      if FileExists(Candidate) then Exit(Candidate);
    end;
    for J := Low(CommonDirs) to High(CommonDirs) do
    begin
      Candidate := IncludeTrailingPathDelimiter(CommonDirs[J]) + ANames[I];
      if FileExists(Candidate) then Exit(Candidate);
    end;
    PathValue := GetEnvironmentVariable('PATH');
    Candidate := FileSearch(ANames[I], PathValue);
    if Candidate <> '' then Exit(ExpandFileName(Candidate));
  end;
end;

procedure TFLXInstallationAudit.CheckRequiredCommand(const ACode, ATitle: string;
  const ANames: array of string; const AInstallHint: string);
var
  Found: string;
begin
  Found := FindCommand(ANames);
  if Found <> '' then
    FReport.Add(ACode, 'INSTALACION', alOK, ATitle + ' disponible',
      'La dependencia obligatoria está instalada y accesible.', '', Found)
  else
    FReport.Add(ACode, 'INSTALACION', alError, ATitle + ' no localizado',
      'No se encuentra una dependencia necesaria para funciones básicas de FacturLinEx.',
      AInstallHint, 'Dependencia no encontrada en PATH ni en rutas estándar');
end;

procedure TFLXInstallationAudit.CheckOptionalCommand(const ACode, ATitle: string;
  const ANames: array of string; const AInstallHint: string);
var
  Found: string;
begin
  Found := FindCommand(ANames);
  if Found <> '' then
    FReport.Add(ACode, 'INSTALACION', alOK, ATitle + ' disponible',
      'La dependencia opcional está instalada.', '', Found)
  else
    FReport.Add(ACode, 'INSTALACION', alInfo, ATitle + ' no instalado',
      'Esta ausencia solo limita funciones opcionales.', AInstallHint, '');
end;

procedure TFLXInstallationAudit.CheckInstallationDirectories;
var
  ExeDir: string;
  InstalledMode: Boolean;
begin
  ExeDir := IncludeTrailingPathDelimiter(ExtractFilePath(ExpandFileName(ParamStr(0))));
  InstalledMode := SameText(ExcludeTrailingPathDelimiter(ExeDir), '/usr/bin');

  if InstalledMode then
  begin
    FReport.Add('IN010', 'INSTALACION', alOK, 'Ejecución desde /usr/bin',
      'FacturLinEx se está ejecutando desde la ubicación prevista para producción.', '', ExeDir);
    if DirectoryExists('/usr/share/facturlinex2') then
      FReport.Add('IN011', 'INSTALACION', alOK, 'Directorio principal instalado',
        'Existe /usr/share/facturlinex2.', '', '/usr/share/facturlinex2')
    else
      FReport.Add('IN011', 'INSTALACION', alError, 'Directorio principal ausente',
        'No existe /usr/share/facturlinex2.',
        'Reinstalar o copiar los recursos de FacturLinEx.', '/usr/share/facturlinex2');

    if DirectoryExists('/usr/share/facturlinex2/Report') then
      FReport.Add('IN012', 'INSTALACION', alOK, 'Carpeta de informes disponible',
        'La carpeta Report existe.', '', '/usr/share/facturlinex2/Report')
    else
      FReport.Add('IN012', 'INSTALACION', alError, 'Carpeta de informes ausente',
        'Los informes LRF instalados no podrán localizarse.',
        'Restaurar /usr/share/facturlinex2/Report.', '/usr/share/facturlinex2/Report');
  end
  else
    FReport.Add('IN010', 'INSTALACION', alInfo, 'Ejecución en entorno de desarrollo',
      'El ejecutable no se está lanzando desde /usr/bin; no se exigen todavía las rutas finales de instalación.',
      '', ExeDir);
end;

procedure TFLXInstallationAudit.CheckConfigDirectory(const AConfigFile: string);
var
  DirName: string;
begin
  DirName := ExtractFileDir(ExpandFileName(AConfigFile));
  if DirectoryExists(DirName) then
    FReport.Add('IN020', 'INSTALACION', alOK, 'Directorio de configuración accesible',
      'La carpeta que contiene FacturConf.ini existe.', '', DirName)
  else
    FReport.Add('IN020', 'INSTALACION', alError, 'Directorio de configuración ausente',
      'No existe la carpeta prevista para la configuración.',
      'Crear o corregir la ruta de configuración.', DirName);
end;

procedure TFLXInstallationAudit.Run(const AConfigFile: string);
begin
  CheckRequiredCommand('IN001', 'Cliente MariaDB/MySQL',
    ['mariadb', 'mysql'], 'Instalar mariadb-client o default-mysql-client.');
  CheckRequiredCommand('IN002', 'Rsync',
    ['rsync'], 'Instalar el paquete rsync.');
  CheckOptionalCommand('IN003', 'Compresor 7-Zip',
    ['7zz', '7z'], 'Instalar 7zip o p7zip-full si se usarán copias .7z.');
  CheckOptionalCommand('IN004', 'Cliente FTP/FTPS',
    ['lftp'], 'Instalar lftp si se utilizarán copias remotas FTP/FTPS.');
  CheckOptionalCommand('IN005', 'Apertura de documentos',
    ['xdg-open', 'gio'], 'Instalar xdg-utils o GLib para apertura externa.');
  CheckOptionalCommand('IN006', 'Impresión por sistema',
    ['lp', 'lpr'], 'Instalar cups-client si se utilizará impresión mediante CUPS.');
  CheckInstallationDirectories;
  CheckConfigDirectory(AConfigFile);
end;

end.
