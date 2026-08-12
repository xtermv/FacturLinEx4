unit uFLXCoreVersion;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

const
  FLX_CORE_VERSION = '1.0.1';
  FLX_PRODUCT_VERSION = '4.2.6';
  FLX_DEFAULT_EDITION = 'J';

function FLXFullVersion(const AEdition: string): string;

implementation

function FLXFullVersion(const AEdition: string): string;
begin
  Result := FLX_PRODUCT_VERSION + UpperCase(AEdition);
end;

end.
