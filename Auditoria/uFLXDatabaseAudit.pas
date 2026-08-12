unit uFLXDatabaseAudit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uFLXAuditTypes;

type
  TFLXDatabaseProbe = function: Boolean of object;

  TFLXDatabaseAudit = class
  private
    FReport: TFLXAuditReport;
  public
    constructor Create(AReport: TFLXAuditReport);
    procedure CheckConnection(AProbe: TFLXDatabaseProbe);
    procedure AddNotChecked(const AReason: string);
  end;

implementation

constructor TFLXDatabaseAudit.Create(AReport: TFLXAuditReport);
begin
  inherited Create;
  if not Assigned(AReport) then
    raise Exception.Create('TFLXDatabaseAudit necesita un informe de auditoria');
  FReport := AReport;
end;

procedure TFLXDatabaseAudit.CheckConnection(AProbe: TFLXDatabaseProbe);
begin
  if not Assigned(AProbe) then
  begin
    AddNotChecked('No se ha proporcionado una funcion de comprobacion de conexion.');
    Exit;
  end;
  try
    if AProbe() then
      FReport.Add('DB-001', 'BASE DE DATOS', alOK, 'Conexion operativa',
        'La comprobacion de conexion ha respondido correctamente.', '', '')
    else
      FReport.Add('DB-001', 'BASE DE DATOS', alError, 'Conexion no operativa',
        'La comprobacion de conexion ha devuelto un resultado negativo.',
        'Revisar servidor, credenciales, red y servicio MariaDB.', '');
  except
    on E: Exception do
      FReport.Add('DB-001', 'BASE DE DATOS', alError, 'Error al comprobar la conexion',
        E.Message, 'Revisar la conexion antes de continuar.', E.ClassName);
  end;
end;

procedure TFLXDatabaseAudit.AddNotChecked(const AReason: string);
begin
  FReport.Add('DB-001', 'BASE DE DATOS', alNotChecked,
    'Conexion pendiente de comprobacion', AReason,
    'Conectar el adaptador real de base de datos al motor de auditoria.', '');
end;

end.
