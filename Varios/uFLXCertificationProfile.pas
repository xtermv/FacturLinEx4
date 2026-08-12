unit uFLXCertificationProfile;

{$mode objfpc}{$H+}

interface

uses
  uFLXVersionInfo;

const
  { Identidad de la compilación certificable.
    Para certificar una variante distinta, modificar este perfil ANTES de compilar
    y emitir su propia Declaración Responsable. No son parámetros de usuario. }
  FLX_CERT_SIF_NAME        = FLX_PRODUCT_NAME;
  FLX_CERT_SIF_ID          = FLX_SYSTEM_ID;
  FLX_CERT_PRODUCER_NAME   = FLX_PRODUCER_NAME;
  FLX_CERT_PRODUCER_NIF    = FLX_PRODUCER_ID;
  FLX_CERT_ONLY_VERIFACTU  = 'S';
  FLX_CERT_MULTI_OT        = 'N';
  FLX_CERT_MULTIPLES_OT    = 'N';

function FLXCertVersion: string;

implementation

function FLXCertVersion: string;
begin
  Result := FLXVersion;
end;

end.
