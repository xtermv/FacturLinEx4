unit uVeriHash;

{ -----------------------------------------------------------------------------
  uVeriHash
  Fase 1: Cálculo de huella (SHA-256) para VERI*FACTU
  Lazarus 4.2 + FPC 3.2.2
  Dependencias: DCPcrypt 2 (unidades: DCPsha256, DCPcrypt2)

  Qué hace:
    - SHA256 en hexadecimal minúscula desde bytes UTF-8
    - Helpers de normalización (fechas ISO-8601 Z, importes, utf8)
    - Constructor de cadena canónica provisional (con separador '|')

  Añadido (SIF B AEAT):
    - Construcción de la cadena de entrada para la HUELLTA encadenada
      según el diseño SIF B:
        IDEmisorFactura=...&
        NumSerieFactura=...&
        FechaExpedicionFactura=DD-MM-YYYY&
        TipoFactura=F1&
        CuotaTotal=0.00&
        ImporteTotal=0.00&
        Huella=<hash_anterior>&
        FechaHoraHusoGenRegistro=YYYY-MM-DDThh:mm:ss+HH:MM

    - Cálculo de la huella en HEX MAYÚSCULAS (como AEAT).

-------------------------------------------------------------------------------}

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, DateUtils;

type
  TVeriImporteFormat = (vi2Dec, vi3Dec, viNoDec);

{ Convierte un TDateTime local a ISO-8601 con 'Z' (UTC) sin offset, p.ej:
  2025-11-09T20:31:05Z  o  2025-11-09T20:31:05.123Z si IncludeMillis = True }
function ToISO8601Zulu(const ALocalDT: TDateTime; const IncludeMillis: Boolean = False): string;

{ Normaliza un importe a texto con punto decimal, sin separador de miles.
  Ej.:  1234.50 -> '1234.50' (vi2Dec)
        10      -> '10'      (viNoDec) }
function FormatImporte(const AValue: Extended; const Mode: TVeriImporteFormat): string;

{ Convierte a bytes UTF-8 de forma explícita }
function UTF8Bytes(const S: string): TBytes;

{ SHA-256(UTF-8(input)) -> hex minúscula }
function SHA256Hex(const InputUTF8: TBytes): string; overload;
function SHA256Hex(const S: string): string; overload;

{ *** Constructor de cadena canónica provisional ***
  IMPORTANTE: Ajusta el orden/selección de campos y separadores según doc AEAT.
  Aquí partimos de un estándar habitual:
    NumInst | NIFEmisor | TipoEvento | FechaISOZ | PayloadCanonical
  - 'PayloadCanonical' es un string ya normalizado (p.ej. JSON sin espacios,
    o concatenación de campos de factura con su propio formato).
  - Para Fase 2, añadiremos 'HashPrev' en la posición que marque la guía. }
function BuildCanonicalV0(const NumInst, NIFEmisor, TipoEvento,
  FechaISOZ, PayloadCanonical: string; const Sep: string = '|'): string;

{ Cálculo de huella para la canónica ya formada (hex minúscula) }
function CalcVeriHashAEAT(const Canonical: string): string;

// ============================================================================
//  NUEVO: Funciones específicas para HUELLTA SIF B AEAT
// ============================================================================

{ Construye la cadena EXACTA que la AEAT usa para calcular la huella SIF B.
  Formato:

    IDEmisorFactura=<NIFEmisor>
    &NumSerieFactura=<NumSerieFactura>
    &FechaExpedicionFactura=<DD-MM-YYYY>
    &TipoFactura=<F1/F2/...>
    &CuotaTotal=<importe con '.' y 2 decimales>
    &ImporteTotal=<importe con '.' y 2 decimales>
    &Huella=<huella_anterior>
    &FechaHoraHusoGenRegistro=<YYYY-MM-DDThh:mm:ss+HH:MM>

  Todos los '&' seguidos, sin espacios, sin salto de línea final. }
function VF_BuildSIFHashInput(const NIFEmisor, NumSerieFactura,
  FechaExpedicionFactura, TipoFactura: string;
  const CuotaTotal, ImporteTotal: Double;
  const HuellaPrev, FechaHoraHusoGenRegistro: string): string;

{ Calcula la HUELLTA SIF B con el formato AEAT:
    SHA-256( UTF-8( VF_BuildSIFHashInput(...) ) ) en HEX MAYÚSCULAS.

  Esto debe devolver EXACTAMENTE la misma huella que aparece en:
    "Huella calculada: XXXXX..." de los mensajes de error 2000. }
function VF_CalcSIFHashAEAT(const NIFEmisor, NumSerieFactura,
  FechaExpedicionFactura, TipoFactura: string;
  const CuotaTotal, ImporteTotal: Double;
  const HuellaPrev, FechaHoraHusoGenRegistro: string): string;

implementation

uses
  DCPsha256, DCPcrypt2;

function ToISO8601Zulu(const ALocalDT: TDateTime; const IncludeMillis: Boolean
  ): string;
var
  UtcDT: TDateTime;
  FS: TFormatSettings;
begin
  // Pasa de hora local a UTC y formatea con separadores ISO y 'Z'
  UtcDT := LocalTimeToUniversal(ALocalDT);
  FS := DefaultFormatSettings;
  FS.DateSeparator := '-';
  FS.TimeSeparator := ':';
  FS.ShortDateFormat := 'yyyy-mm-dd';
  // Forzamos 24h y ceros a la izquierda
  if IncludeMillis then
    Result := FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss"."zzz"Z"', UtcDT, FS)
  else
    Result := FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss"Z"', UtcDT, FS);
end;

function FormatImporte(const AValue: Extended; const Mode: TVeriImporteFormat
  ): string;
var
  FS: TFormatSettings;
begin
  FS := DefaultFormatSettings;
  FS.DecimalSeparator := '.';
  case Mode of
    vi2Dec:   Result := FormatFloat('0.00', AValue, FS);
    vi3Dec:   Result := FormatFloat('0.000', AValue, FS);
    viNoDec:  Result := FormatFloat('0', AValue, FS);
  end;
  // Elimina posibles "-0.00" por efectos de redondeo muy raros
  if (Result = '-0.00') or (Result = '-0.000') or (Result = '-0') then
    Result := StringReplace(Result, '-0', '0', []);
end;

function UTF8Bytes(const S: string): TBytes;
begin
  Result := TEncoding.UTF8.GetBytes(S); // en FPC devuelve TUTF8String -> TBytes implícito
end;

function BytesToHexLower(const B: TBytes): string;
const
  Hex: array[0..15] of Char = ('0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f');
var
  I: SizeInt;
begin
  SetLength(Result, Length(B) * 2);
  for I := 0 to High(B) do
  begin
    Result[I*2+1] := Hex[(B[I] shr 4) and $F];
    Result[I*2+2] := Hex[B[I] and $F];
  end;
end;

function SHA256Hex(const InputUTF8: TBytes): string;
var
  Ctx: TDCP_sha256;
  Digest: array[0..31] of byte; // 256 bits
begin
  Ctx := TDCP_sha256.Create(nil);
  try
    Ctx.Init;
    if Length(InputUTF8) > 0 then
      Ctx.Update(InputUTF8[0], Length(InputUTF8));
    Ctx.Final(Digest);
    Result := BytesToHexLower(Digest);
  finally
    Ctx.Free;
  end;
end;

function SHA256Hex(const S: string): string;
begin
  Result := SHA256Hex(UTF8Bytes(S));
end;

function BuildCanonicalV0(const NumInst, NIFEmisor, TipoEvento, FechaISOZ,
  PayloadCanonical: string; const Sep: string): string;
begin
  // *** ATENCIÓN ***
  // Esta es una propuesta de orden y separadores. Debe ajustarse al documento AEAT.
  // Cambiar aquí si el orden o los separadores oficiales difieren.
  Result := NumInst + Sep +
            NIFEmisor + Sep +
            TipoEvento + Sep +
            FechaISOZ + Sep +
            PayloadCanonical;
end;

function CalcVeriHashAEAT(const Canonical: string): string;
begin
  // Hash = sha256( UTF-8( Canonical ) ) en hex minúscula
  Result := SHA256Hex(Canonical);
end;

// ============================================================================
//  IMPLEMENTACIÓN NUEVA: HUELLTA SIF B AEAT
// ============================================================================

function VF_BuildSIFHashInput(const NIFEmisor, NumSerieFactura,
  FechaExpedicionFactura, TipoFactura: string;
  const CuotaTotal, ImporteTotal: Double;
  const HuellaPrev, FechaHoraHusoGenRegistro: string): string;
var
  FS: TFormatSettings;
  sCuota, sImporte: string;
begin
  // Formateo de importes EXACTAMENTE como espera AEAT: 2 decimales, punto.
  FS := DefaultFormatSettings;
  FS.DecimalSeparator := '.';
  sCuota   := FormatFloat('0.00', CuotaTotal, FS);
  sImporte := FormatFloat('0.00', ImporteTotal, FS);

  // OJO: FechaExpedicionFactura debe venir YA en formato 'DD-MM-YYYY'
  //      FechaHoraHusoGenRegistro debe venir YA como 'YYYY-MM-DDThh:nn:ss+HH:MM'

  Result :=
    'IDEmisorFactura='       + NIFEmisor +
    '&NumSerieFactura='      + NumSerieFactura +
    '&FechaExpedicionFactura=' + FechaExpedicionFactura +
    '&TipoFactura='          + TipoFactura +
    '&CuotaTotal='           + sCuota +
    '&ImporteTotal='         + sImporte +
    '&Huella='               + HuellaPrev +
    '&FechaHoraHusoGenRegistro=' + FechaHoraHusoGenRegistro;
end;

function VF_CalcSIFHashAEAT(const NIFEmisor, NumSerieFactura,
  FechaExpedicionFactura, TipoFactura: string;
  const CuotaTotal, ImporteTotal: Double;
  const HuellaPrev, FechaHoraHusoGenRegistro: string): string;
var
  Input: string;
begin
  Input  := VF_BuildSIFHashInput(NIFEmisor, NumSerieFactura,
                                 FechaExpedicionFactura, TipoFactura,
                                 CuotaTotal, ImporteTotal,
                                 HuellaPrev, FechaHoraHusoGenRegistro);

  // AEAT devuelve la huella en HEX MAYÚSCULAS, así que adaptamos aquí,
  // sin tocar el resto de funciones que siguen devolviendo minúsculas.
  Result := UpperCase(SHA256Hex(Input));
end;

end.
