unit uFLXVeriFactuAudit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uFLXAuditTypes;

type
  TFLXVeriFactuAudit = class
  private
    FReport: TFLXAuditReport;
  public
    constructor Create(AReport: TFLXAuditReport);
    procedure AddQueueSummary(ATotal, APending, ASent, AErrors: Int64);
    procedure AddHashAuditSummary(AChecked, AValid, AInvalid,
      ANotVerifiable: Int64);
    procedure AddEnvironment(const AEnvironment, AEndpoint: string);
  end;

implementation

constructor TFLXVeriFactuAudit.Create(AReport: TFLXAuditReport);
begin
  inherited Create;
  if not Assigned(AReport) then
    raise Exception.Create('TFLXVeriFactuAudit necesita un informe de auditoria');
  FReport := AReport;
end;

procedure TFLXVeriFactuAudit.AddQueueSummary(ATotal, APending, ASent,
  AErrors: Int64);
begin
  if AErrors > 0 then
    FReport.Add('VF-QUEUE', 'VERIFACTU', alError, 'La cola contiene incidencias',
      Format('Total: %d; pendientes: %d; enviados: %d; errores: %d.',
        [ATotal, APending, ASent, AErrors]),
      'Revisar las incidencias antes de considerar el sistema listo.', '')
  else if APending > 0 then
    FReport.Add('VF-QUEUE', 'VERIFACTU', alWarning, 'La cola contiene pendientes',
      Format('Hay %d registro(s) pendiente(s) de envio.', [APending]),
      'Comprobar comunicaciones y procesar la cola.', '')
  else
    FReport.Add('VF-QUEUE', 'VERIFACTU', alOK, 'Cola sin incidencias',
      Format('Se han revisado %d registro(s).', [ATotal]), '', '');
end;

procedure TFLXVeriFactuAudit.AddHashAuditSummary(AChecked, AValid, AInvalid,
  ANotVerifiable: Int64);
begin
  if AInvalid > 0 then
    FReport.Add('VF-HASH', 'VERIFACTU', alError, 'Auditoria HASH con errores',
      Format('Comprobados: %d; validos: %d; invalidos: %d; no verificables: %d.',
        [AChecked, AValid, AInvalid, ANotVerifiable]),
      'Localizar las rupturas antes de continuar.', '')
  else if ANotVerifiable > 0 then
    FReport.Add('VF-HASH', 'VERIFACTU', alWarning,
      'Auditoria HASH correcta con registros historicos no verificables',
      Format('Comprobados: %d; validos: %d; no verificables: %d.',
        [AChecked, AValid, ANotVerifiable]),
      'Conservar esta limitacion documentada en la auditoria.', '')
  else
    FReport.Add('VF-HASH', 'VERIFACTU', alOK, 'Auditoria HASH correcta',
      Format('Se han validado %d registro(s).', [AValid]), '', '');
end;

procedure TFLXVeriFactuAudit.AddEnvironment(const AEnvironment,
  AEndpoint: string);
var
  E: string;
begin
  E := UpperCase(Trim(AEnvironment));
  if (E <> 'PRODUCCION') and (E <> 'PRUEBAS') then
    FReport.Add('VF-ENV', 'VERIFACTU', alWarning, 'Entorno no identificado',
      'El entorno activo no es PRODUCCION ni PRUEBAS.',
      'Revisar la configuracion antes de enviar.', AEnvironment)
  else if Trim(AEndpoint) = '' then
    FReport.Add('VF-ENV', 'VERIFACTU', alError, 'Endpoint no configurado',
      'El entorno esta identificado pero no tiene URL de servicio.',
      'Configurar la URL correspondiente.', E)
  else
    FReport.Add('VF-ENV', 'VERIFACTU', alOK, 'Entorno VeriFactu identificado',
      'El entorno y su endpoint estan disponibles para auditoria.', '',
      E + ' - ' + AEndpoint);
end;

end.
