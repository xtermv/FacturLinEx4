unit uFLXSystemAudit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uFLXAuditTypes;

type
  TFLXSystemAudit = class
  private
    FReport: TFLXAuditReport;
    procedure CheckExecutable;
    procedure CheckWorkingDirectory;
    procedure CheckConfigFile(const AConfigFile: string);
  public
    constructor Create(AReport: TFLXAuditReport);
    procedure RunBasic(const AConfigFile: string = 'FacturConf.ini');
  end;

implementation

constructor TFLXSystemAudit.Create(AReport: TFLXAuditReport);
begin
  inherited Create;
  if not Assigned(AReport) then
    raise Exception.Create('TFLXSystemAudit necesita un informe de auditoria');
  FReport := AReport;
end;

procedure TFLXSystemAudit.CheckExecutable;
var
  ExeName: string;
begin
  ExeName := ParamStr(0);
  if (ExeName <> '') and FileExists(ExeName) then
    FReport.Add('SYS-001', 'SISTEMA', alOK, 'Ejecutable localizado',
      'El ejecutable activo puede identificarse correctamente.', '', ExpandFileName(ExeName))
  else
    FReport.Add('SYS-001', 'SISTEMA', alWarning, 'Ejecutable no verificable',
      'No se ha podido confirmar la ruta del ejecutable activo.',
      'Revisar la forma de lanzamiento de FacturLinEx.', ExeName);
end;

procedure TFLXSystemAudit.CheckWorkingDirectory;
var
  Dir: string;
begin
  Dir := GetCurrentDir;
  if DirectoryExists(Dir) then
    FReport.Add('SYS-002', 'SISTEMA', alOK, 'Directorio de trabajo accesible',
      'El directorio de trabajo existe y puede consultarse.', '', Dir)
  else
    FReport.Add('SYS-002', 'SISTEMA', alError, 'Directorio de trabajo no accesible',
      'El directorio de trabajo no existe o no puede consultarse.',
      'Corregir el directorio de inicio del programa.', Dir);
end;

procedure TFLXSystemAudit.CheckConfigFile(const AConfigFile: string);
var
  FullName: string;
begin
  FullName := ExpandFileName(AConfigFile);
  if FileExists(FullName) then
    FReport.Add('SYS-003', 'CONFIGURACION', alOK, 'Configuracion localizada',
      'El fichero de configuracion indicado existe.', '', FullName)
  else
    FReport.Add('SYS-003', 'CONFIGURACION', alWarning, 'Configuracion no localizada',
      'No se ha encontrado el fichero de configuracion en la ruta comprobada.',
      'Confirmar la ruta real de FacturConf.ini.', FullName);
end;

procedure TFLXSystemAudit.RunBasic(const AConfigFile: string);
begin
  CheckExecutable;
  CheckWorkingDirectory;
  CheckConfigFile(AConfigFile);
end;

end.
