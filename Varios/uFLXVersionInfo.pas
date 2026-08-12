unit uFLXVersionInfo;

{$mode objfpc}{$H+}

interface

const
  { Cambiar únicamente estos valores para cada edición oficial. }
  FLX_VERSION_BASE        = '4.2.6';
  FLX_EDITION_SUFFIX      = 'J';
  FLX_PRODUCT_NAME        = 'FacturLinEx';
  FLX_PRODUCT_FULL_NAME   = 'FacturLinEx Veri*Factu';
  FLX_SYSTEM_ID           = 'FL';

  { Durante el desarrollo no debe mostrarse como versión certificada. }
  FLX_RELEASE_STATUS      = 'En preparación para auditoría VeriFactu';
  FLX_SCHEMA_VERSION      = 'Pendiente de fijar';
  FLX_SOURCE_REVISION     = 'Pendiente de fijar';

  { Completar antes de generar la declaración responsable. }
  FLX_PRODUCER_NAME       = 'E. José Belenguer Belenguer';
  FLX_PRODUCER_ID         = '73559542E';

  FLX_PRODUCER_ADDRESS    = 'Calle Penya 2, 46220 Picassent, Valencia, España';

  FLX_LICENSE_NAME        = 'GNU GPL versión 3 o posterior';
  FLX_PROJECT_URL         = 'https://github.com/';

function FLXVersion: String;
function FLXVersionDisplay: String;
function FLXOfficialBuildId: String;

implementation

uses
  SysUtils;

function FLXVersion: String;
begin
  Result := FLX_VERSION_BASE + FLX_EDITION_SUFFIX;
end;

function FLXVersionDisplay: String;
begin
  Result := FLX_PRODUCT_NAME + ' ' + FLXVersion;
end;

function FLXOfficialBuildId: String;
begin
  Result := FLX_SYSTEM_ID + '-' + StringReplace(FLXVersion, '.', '', [rfReplaceAll]);
end;

end.
