unit uVeriSIF;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, Global;

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
  // Nombre y NIF del emisor desde tu configuración global
  Cfg.NombreRazon       := Trim(Empresa);
  Cfg.NIF               := Trim(Nif);

  // Valores recomendados por defecto para FacturLinEx (software libre)
  Cfg.NombreSistema     := 'FacturLinEx 2.0 (SIF Libre)';
  Cfg.IdSistema         := 'FL';
  Cfg.Version           := '2.0.0';
  Cfg.NumeroInstalacion := '1';

  Cfg.SoloVerifactu     := 'N';  // No es solo para VeriFactu
  Cfg.MultiOT           := 'N';  // No es multi-OT
  Cfg.MultiplesOT       := 'N';  // Esta instalación no tiene varios OT
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
    // Sección propia para VeriFactu SIF
    Cfg.NombreRazon       := ini.ReadString('SIFVeriFactu', 'NombreRazon',       Cfg.NombreRazon);
    Cfg.NIF               := ini.ReadString('SIFVeriFactu', 'NIF',               Cfg.NIF);
    Cfg.NombreSistema     := ini.ReadString('SIFVeriFactu', 'NombreSistema',     Cfg.NombreSistema);
    Cfg.IdSistema         := ini.ReadString('SIFVeriFactu', 'IdSistema',         Cfg.IdSistema);
    Cfg.Version           := ini.ReadString('SIFVeriFactu', 'Version',           Cfg.Version);
    Cfg.NumeroInstalacion := ini.ReadString('SIFVeriFactu', 'NumeroInstalacion', Cfg.NumeroInstalacion);
    Cfg.SoloVerifactu     := ini.ReadString('SIFVeriFactu', 'SoloVerifactu',     Cfg.SoloVerifactu);
    Cfg.MultiOT           := ini.ReadString('SIFVeriFactu', 'MultiOT',           Cfg.MultiOT);
    Cfg.MultiplesOT       := ini.ReadString('SIFVeriFactu', 'MultiplesOT',       Cfg.MultiplesOT);
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
    ini.WriteString('SIFVeriFactu', 'NombreRazon',       Cfg.NombreRazon);
    ini.WriteString('SIFVeriFactu', 'NIF',               Cfg.NIF);
    ini.WriteString('SIFVeriFactu', 'NombreSistema',     Cfg.NombreSistema);
    ini.WriteString('SIFVeriFactu', 'IdSistema',         Cfg.IdSistema);
    ini.WriteString('SIFVeriFactu', 'Version',           Cfg.Version);
    ini.WriteString('SIFVeriFactu', 'NumeroInstalacion', Cfg.NumeroInstalacion);
    ini.WriteString('SIFVeriFactu', 'SoloVerifactu',     UpperCase(Trim(Cfg.SoloVerifactu)));
    ini.WriteString('SIFVeriFactu', 'MultiOT',           UpperCase(Trim(Cfg.MultiOT)));
    ini.WriteString('SIFVeriFactu', 'MultiplesOT',       UpperCase(Trim(Cfg.MultiplesOT)));
  finally
    ini.Free;
  end;
end;

end.
