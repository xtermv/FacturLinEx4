unit uFLXAuditEngine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, ZConnection, ZDataset,
  uFLXAuditTypes, uFLXSystemAudit, uFLXVeriFactuAudit,
  uFLXCertificateAudit, uFLXInstallationAudit, uFLXDocumentationAudit,
  uFLXSchemaAudit;

type
  TFLXAuditEngine = class
  private
    FConnection: TZConnection;
    FConfigFile: string;
    FMode: string;
    FProductionURL: string;
    FTestURL: string;
    FReport: TFLXAuditReport;
    function ActiveURL: string;
    procedure AuditDatabase;
    procedure AuditConfiguration;
    procedure AuditQueue;
    procedure CheckColumn(Q: TZQuery; const AColumn, ACode: string;
      ARequired: Boolean);
  public
    constructor Create(AConnection: TZConnection; const AConfigFile,
      AMode, AProductionURL, ATestURL: string);
    destructor Destroy; override;
    function Execute: TFLXAuditReport;
  end;

implementation

constructor TFLXAuditEngine.Create(AConnection: TZConnection;
  const AConfigFile, AMode, AProductionURL, ATestURL: string);
begin
  inherited Create;
  FConnection := AConnection;
  FConfigFile := AConfigFile;
  FMode := UpperCase(Trim(AMode));
  FProductionURL := Trim(AProductionURL);
  FTestURL := Trim(ATestURL);
  FReport := TFLXAuditReport.Create;
end;

destructor TFLXAuditEngine.Destroy;
begin
  FReport.Free;
  inherited Destroy;
end;

function TFLXAuditEngine.ActiveURL: string;
begin
  if (FMode = 'PRUEBAS') or (FMode = 'TEST') then
    Result := FTestURL
  else
    Result := FProductionURL;
end;

procedure TFLXAuditEngine.CheckColumn(Q: TZQuery; const AColumn,
  ACode: string; ARequired: Boolean);
begin
  Q.Close;
  Q.SQL.Text :=
    'SELECT COUNT(*) AS n FROM information_schema.COLUMNS ' +
    'WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=''verifactu_queue'' ' +
    'AND COLUMN_NAME=:c';
  Q.ParamByName('c').AsString := AColumn;
  Q.Open;
  if Q.FieldByName('n').AsInteger > 0 then
    FReport.Add(ACode, 'BASE DE DATOS', alOK,
      'Columna ' + AColumn + ' disponible',
      'La estructura necesaria está presente.', '', AColumn)
  else if ARequired then
    FReport.Add(ACode, 'BASE DE DATOS', alError,
      'Falta la columna ' + AColumn,
      'La tabla verifactu_queue no contiene una columna obligatoria.',
      'Actualizar la estructura antes de continuar.', AColumn)
  else
    FReport.Add(ACode, 'BASE DE DATOS', alWarning,
      'Falta la columna opcional ' + AColumn,
      'La ausencia limita algunas comprobaciones de auditoría.',
      'Actualizar la estructura para disponer de trazabilidad completa.', AColumn);
end;

procedure TFLXAuditEngine.AuditDatabase;
var
  Q: TZQuery;
begin
  if not Assigned(FConnection) then
  begin
    FReport.Add('DB001', 'BASE DE DATOS', alError,
      'Conexión no asignada', 'El motor no ha recibido una conexión.',
      'Abrir la auditoría desde una sesión conectada.', '');
    Exit;
  end;
  if not FConnection.Connected then
  begin
    FReport.Add('DB001', 'BASE DE DATOS', alError,
      'Conexión no activa', 'La conexión con MariaDB está cerrada.',
      'Restablecer la conexión antes de auditar.', '');
    Exit;
  end;

  FReport.Add('DB001', 'BASE DE DATOS', alOK, 'Conexión activa',
    'La conexión con MariaDB está disponible.', '', FConnection.Database);

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConnection;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS n FROM information_schema.TABLES ' +
      'WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=''verifactu_queue''';
    Q.Open;
    if Q.FieldByName('n').AsInteger = 0 then
    begin
      FReport.Add('DB002', 'BASE DE DATOS', alError,
        'No existe verifactu_queue',
        'No se encuentra la tabla principal de la cola VeriFactu.',
        'Inicializar la estructura VeriFactu antes de continuar.', '');
      Exit;
    end;

    FReport.Add('DB002', 'BASE DE DATOS', alOK,
      'Tabla verifactu_queue disponible',
      'La tabla principal de la cola existe.', '', 'verifactu_queue');

    CheckColumn(Q, 'estado', 'DB003', True);
    CheckColumn(Q, 'payload_json', 'DB004', True);
    CheckColumn(Q, 'canonical', 'DB005', True);
    CheckColumn(Q, 'hash', 'DB006', True);
    CheckColumn(Q, 'hash_prev', 'DB007', True);
    CheckColumn(Q, 'respuesta_text', 'DB008', True);
    CheckColumn(Q, 'entorno', 'DB009', True);
    CheckColumn(Q, 'hash_input', 'DB010', False);
    CheckColumn(Q, 'hash_fecha_huso', 'DB011', False);
    CheckColumn(Q, 'hash_algoritmo', 'DB012', False);
  except
    on E: Exception do
      FReport.Add('DB099', 'BASE DE DATOS', alError,
        'Error al revisar la estructura', E.Message,
        'Revisar permisos y compatibilidad de MariaDB.', E.ClassName);
  end;
  Q.Free;
end;

procedure TFLXAuditEngine.AuditConfiguration;
var
  Ini: TIniFile;
  CertAudit: TFLXCertificateAudit;
  P12File, CertFile, KeyFile, CAFile, OpenSSLPath: string;
  VFAudit: TFLXVeriFactuAudit;
begin
  VFAudit := TFLXVeriFactuAudit.Create(FReport);
  try
    VFAudit.AddEnvironment(FMode, ActiveURL);
  finally
    VFAudit.Free;
  end;

  if not FileExists(FConfigFile) then
  begin
    FReport.Add('CFG001', 'CONFIGURACION', alError,
      'FacturConf.ini no localizado',
      'No se encuentra el fichero de configuración indicado.',
      'Revisar RutaIni y la instalación.', ExpandFileName(FConfigFile));
    Exit;
  end;

  FReport.Add('CFG001', 'CONFIGURACION', alOK,
    'FacturConf.ini localizado',
    'El fichero de configuración puede leerse.', '', ExpandFileName(FConfigFile));

  Ini := TIniFile.Create(FConfigFile);
  try
    P12File := Trim(Ini.ReadString('VeriFactuTLS', 'P12File', ''));
    CertFile := Trim(Ini.ReadString('VeriFactuTLS', 'CertFile', ''));
    KeyFile := Trim(Ini.ReadString('VeriFactuTLS', 'KeyFile', ''));
    CAFile := Trim(Ini.ReadString('VeriFactuTLS', 'CAFile', ''));
    OpenSSLPath := Trim(Ini.ReadString('VeriFactuTLS', 'OpenSSLPath', ''));
    if OpenSSLPath = '' then
      OpenSSLPath := 'openssl';

    CertAudit := TFLXCertificateAudit.Create(FReport);
    try
      CertAudit.Run(P12File, CertFile, KeyFile, CAFile, OpenSSLPath);
    finally
      CertAudit.Free;
    end;
  finally
    Ini.Free;
  end;
end;

procedure TFLXAuditEngine.AuditQueue;
var
  Q: TZQuery;
  Total, Pending, Sent, Errors: Int64;
  VFAudit: TFLXVeriFactuAudit;
begin
  if (not Assigned(FConnection)) or (not FConnection.Connected) then Exit;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConnection;
    Q.SQL.Text :=
      'SELECT COUNT(*) AS total, ' +
      'SUM(CASE WHEN estado=''PENDIENTE'' THEN 1 ELSE 0 END) AS pendientes, ' +
      'SUM(CASE WHEN estado=''ENVIADO'' THEN 1 ELSE 0 END) AS enviados, ' +
      'SUM(CASE WHEN estado=''ERROR'' THEN 1 ELSE 0 END) AS errores ' +
      'FROM verifactu_queue';
    Q.Open;
    Total := Q.FieldByName('total').AsLargeInt;
    Pending := Q.FieldByName('pendientes').AsLargeInt;
    Sent := Q.FieldByName('enviados').AsLargeInt;
    Errors := Q.FieldByName('errores').AsLargeInt;

    VFAudit := TFLXVeriFactuAudit.Create(FReport);
    try
      VFAudit.AddQueueSummary(Total, Pending, Sent, Errors);
    finally
      VFAudit.Free;
    end;
  except
    on E: Exception do
      FReport.Add('VF099', 'VERIFACTU', alError,
        'No se ha podido resumir la cola', E.Message,
        'Revisar la estructura y permisos de verifactu_queue.', E.ClassName);
  end;
  Q.Free;
end;

function TFLXAuditEngine.Execute: TFLXAuditReport;
var
  SysAudit: TFLXSystemAudit;
  InstallAudit: TFLXInstallationAudit;
  DocumentationAudit: TFLXDocumentationAudit;
begin
  FReport.Clear;

  SysAudit := TFLXSystemAudit.Create(FReport);
  try
    SysAudit.RunBasic(FConfigFile);
  finally
    SysAudit.Free;
  end;

  InstallAudit := TFLXInstallationAudit.Create(FReport);
  try
    InstallAudit.Run(FConfigFile);
  finally
    InstallAudit.Free;
  end;

  DocumentationAudit := TFLXDocumentationAudit.Create(FReport);
  try
    DocumentationAudit.Run;
  finally
    DocumentationAudit.Free;
  end;

  { La auditoria exhaustiva del esquema no se ejecuta al abrir el Centro de Salud.
    Se lanza expresamente desde el boton "Exportar esquema BBDD" para evitar
    bloquear la interfaz en bases de datos grandes. }

  AuditDatabase;
  AuditConfiguration;
  AuditQueue;
  FReport.Finish;
  Result := FReport;
end;

end.
