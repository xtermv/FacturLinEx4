unit uVeriSIF;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, Global, uFLXCertificationProfile;

type
  TVeriSIFConfig = record
    NombreRazon: string;      // SIFNombreRazon   -> normalmente Empresa
    NIF: string;              // SIFNIF           -> normalmente Nif
    NombreSistema: string;    // SIFNombreSistema
    IdSistema: string;        // SIFId
    Version: string;          // SIFVersion
    NumeroInstalacion: string; // SIFNumeroInst
    SoloVerifactu: string;    // 'S' / 'N'
    MultiOT: string;          // 'S' / 'N'
    MultiplesOT: string;      // 'S' / 'N'
  end;

// Devuelve la ruta completa del FacturConf.ini que se debe usar
function VF_SIF_GetIniPath: string;

// Carga la configuración SIF desde FacturConf.ini (con valores por defecto si faltan)
procedure VF_SIF_Load(var Cfg: TVeriSIFConfig);

// Guarda la configuración SIF en FacturConf.ini
procedure VF_SIF_Save(const Cfg: TVeriSIFConfig);

implementation

function VF_SIF_GetIniPath: string;
begin
  // Si RutaIni ya está inicializada en Global (como en tu FormCreate del menú),
  // usamos siempre esa ruta, que es lo que haces en toda la app.
  if Trim(RutaIni) <> '' then
  begin
    Result := IncludeTrailingPathDelimiter(RutaIni) + 'FacturConf.ini';
    Exit;
  end;

  // Fallback por seguridad, en caso de que se llame muy pronto:
  {$IFDEF UNIX}
  Result := IncludeTrailingPathDelimiter(
              IncludeTrailingPathDelimiter(GetEnvironmentVariable('HOME')) +
              '.facturlinex2') + 'FacturConf.ini';
  {$ELSE}
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'FacturConf.ini';
  {$ENDIF}
end;

function GenerarUUID: string;
var
  guid: TGUID;
begin
  // Crear un nuevo GUID/UUID
  CreateGUID(guid);
  // Convertirlo a string con el formato estándar
  Result := GUIDToString(guid);
end;

procedure VF_SIF_ApplyDefaults(var Cfg: TVeriSIFConfig);
begin
  { Identidad certificada del PRODUCTOR/SIF: fija para esta compilación. }
  Cfg.NombreRazon       := FLX_CERT_PRODUCER_NAME;
  Cfg.NIF               := FLX_CERT_PRODUCER_NIF;
  Cfg.NombreSistema     := FLX_CERT_SIF_NAME;
  Cfg.IdSistema         := FLX_CERT_SIF_ID;
  Cfg.Version           := FLXCertVersion;
  Cfg.NumeroInstalacion := '1';
  Cfg.SoloVerifactu     := FLX_CERT_ONLY_VERIFACTU;
  Cfg.MultiOT           := FLX_CERT_MULTI_OT;
  Cfg.MultiplesOT       := FLX_CERT_MULTIPLES_OT
end;

procedure VF_SIF_Load(var Cfg: TVeriSIFConfig);
var
  ini: TIniFile;
  fn: string;
begin
  // Cargamos valores por defecto primero
  VF_SIF_ApplyDefaults(Cfg);

  fn := VF_SIF_GetIniPath;
  if not FileExists(fn) then
  begin
    // No hay INI todavía → se usarán los valores por defecto
    Exit;
  end;

  ini := TIniFile.Create(fn);
  try
    { Solo NumeroInstalacion es propio de la instalación.
      La identidad certificada NO se lee del INI. }
    Cfg.NumeroInstalacion := ini.ReadString('SIFVeriFactu', 'NumeroInstalacion',
                                            Cfg.NumeroInstalacion);
  finally
    ini.Free;
  end;
end;

procedure VF_SIF_Save(const Cfg: TVeriSIFConfig);
var
  ini: TIniFile;
  fn: string;
begin
  fn := VF_SIF_GetIniPath;
  ini := TIniFile.Create(fn);
  try
    { Eliminar valores históricos que ya no deben gobernar la identidad SIF. }
    ini.DeleteKey('SIFVeriFactu', 'NombreRazon');
    ini.DeleteKey('SIFVeriFactu', 'NIF');
    ini.DeleteKey('SIFVeriFactu', 'NombreSistema');
    ini.DeleteKey('SIFVeriFactu', 'IdSistema');
    ini.DeleteKey('SIFVeriFactu', 'Version');
    ini.DeleteKey('SIFVeriFactu', 'SoloVerifactu');
    ini.DeleteKey('SIFVeriFactu', 'MultiOT');
    ini.DeleteKey('SIFVeriFactu', 'MultiplesOT');
    ini.WriteString('SIFVeriFactu', 'NumeroInstalacion', Cfg.NumeroInstalacion);
  finally
    ini.Free;
  end;
end;

end.
