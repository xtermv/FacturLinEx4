unit uFLXColors;

{$mode objfpc}{$H+}

interface

uses
  Graphics;

{ Paleta visual común de FacturLinEx.
  Unidad sin dependencias de negocio: solo constantes y helpers de color.
  De momento no cambia ningún formulario por sí sola; se irá usando desde
  uFLXGridStyle, uFLXFormStyle y futuros módulos. }

const
  // Fondos suaves
  FLX_COLOR_INFO_BG       = TColor($00FFF2E5); // azul muy suave (BGR Lazarus)
  FLX_COLOR_OK_BG         = TColor($00EAF8EA); // verde muy suave
  FLX_COLOR_WARN_BG       = TColor($00D7F7FF); // amarillo suave
  FLX_COLOR_ERROR_BG      = TColor($00E6E6FF); // rojo suave
  FLX_COLOR_INTEL_BG      = TColor($00FFF0F8); // morado suave
  FLX_COLOR_SELECTED_BG   = TColor($00FFE9CC); // selección suave
  FLX_COLOR_HEADER_BG     = TColor($00F2F2F2);

  // Textos
  FLX_COLOR_TEXT          = clBlack;
  FLX_COLOR_TEXT_MUTED    = clGray;
  FLX_COLOR_TEXT_ERROR    = clMaroon;
  FLX_COLOR_TEXT_OK       = clGreen;
  FLX_COLOR_TEXT_WARN     = clOlive;
  FLX_COLOR_TEXT_INFO     = clNavy;

  // Prioridades
  FLX_PRIORIDAD_ALTA_BG   = FLX_COLOR_ERROR_BG;
  FLX_PRIORIDAD_MEDIA_BG  = FLX_COLOR_WARN_BG;
  FLX_PRIORIDAD_BAJA_BG   = FLX_COLOR_INFO_BG;
  FLX_PRIORIDAD_OK_BG     = FLX_COLOR_OK_BG;

function FLXColorPrioridad(const APrioridad: string): TColor;
function FLXColorDiagnostico(const ADiagnostico: string): TColor;
function FLXColorTextoPrioridad(const APrioridad: string): TColor;

implementation

uses
  SysUtils;

function FLXNorm(const S: string): string;
begin
  Result := UpperCase(Trim(S));
end;

function FLXColorPrioridad(const APrioridad: string): TColor;
var
  P: string;
begin
  P := FLXNorm(APrioridad);
  if (P = 'ALTA') or (P = 'CRITICA') or (P = 'CRÍTICA') or (P = 'ERROR') then
    Result := FLX_PRIORIDAD_ALTA_BG
  else if (P = 'MEDIA') or (P = 'AVISO') or (P = 'ADVERTENCIA') then
    Result := FLX_PRIORIDAD_MEDIA_BG
  else if (P = 'OK') or (P = 'CORRECTO') then
    Result := FLX_PRIORIDAD_OK_BG
  else
    Result := FLX_PRIORIDAD_BAJA_BG;
end;

function FLXColorDiagnostico(const ADiagnostico: string): TColor;
var
  D: string;
begin
  D := FLXNorm(ADiagnostico);
  if (Pos('ERROR', D) > 0) or (Pos('CRITIC', D) > 0) or (Pos('ALTA', D) > 0) then
    Result := FLX_COLOR_ERROR_BG
  else if (Pos('AVISO', D) > 0) or (Pos('REVIS', D) > 0) or (Pos('MEDIA', D) > 0) then
    Result := FLX_COLOR_WARN_BG
  else if (Pos('OK', D) > 0) or (Pos('CORRECT', D) > 0) then
    Result := FLX_COLOR_OK_BG
  else
    Result := FLX_COLOR_INFO_BG;
end;

function FLXColorTextoPrioridad(const APrioridad: string): TColor;
var
  P: string;
begin
  P := FLXNorm(APrioridad);
  if (P = 'ALTA') or (P = 'CRITICA') or (P = 'CRÍTICA') or (P = 'ERROR') then
    Result := FLX_COLOR_TEXT_ERROR
  else if (P = 'MEDIA') or (P = 'AVISO') or (P = 'ADVERTENCIA') then
    Result := FLX_COLOR_TEXT_WARN
  else if (P = 'OK') or (P = 'CORRECTO') then
    Result := FLX_COLOR_TEXT_OK
  else
    Result := FLX_COLOR_TEXT_INFO;
end;

end.
