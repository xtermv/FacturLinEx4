unit uFLXIcons;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Buttons, Graphics;

function FLXIconFile(const AIconName: string; ASize: Integer = 30): string;
procedure FLXSetBitBtnIcon(ABtn: TBitBtn; const AIconName: string; ASize: Integer = 30);
procedure FLXSetIntelligenceButtonIcon(ABtn: TBitBtn; const AKeyOrCaption: string; ASize: Integer = 30);

implementation

function NormalizeKey(S: string): string;
begin
  S := LowerCase(Trim(S));
  S := StringReplace(S, 'á', 'a', [rfReplaceAll]);
  S := StringReplace(S, 'é', 'e', [rfReplaceAll]);
  S := StringReplace(S, 'í', 'i', [rfReplaceAll]);
  S := StringReplace(S, 'ó', 'o', [rfReplaceAll]);
  S := StringReplace(S, 'ú', 'u', [rfReplaceAll]);
  S := StringReplace(S, 'ñ', 'n', [rfReplaceAll]);
  S := StringReplace(S, '.', '', [rfReplaceAll]);
  S := StringReplace(S, ' ', '_', [rfReplaceAll]);
  S := StringReplace(S, '-', '_', [rfReplaceAll]);
  Result := S;
end;

function MapIconName(const AIconName: string): string;
var K: string;
begin
  K := NormalizeKey(AIconName);
  Result := K;
  if (K = 'doctor') or (K = 'doctor_facturlinex') then Result := 'doctor'
  else if (K = 'alerta') or (K = 'alertas') then Result := 'alertas'
  else if (K = 'centro') or (K = 'centro_intelig') or (K = 'centro_inteligencia') or (K = 'centro_inteligente') then Result := 'centro_inteligencia'
  else if (K = 'tendencia') or (K = 'tendencias') then Result := 'tendencias'
  else if (K = 'prediccion') or (K = 'predicciones') then Result := 'predicciones'
  else if (K = 'rentabilidad') then Result := 'rentabilidad'
  else if (K = 'precio') or (K = 'precios') or (K = 'historico_precios') then Result := 'historico_precios'
  else if (K = 'proveedor') or (K = 'proveedores') then Result := 'proveedores'
  else if (K = 'asesor') or (K = 'asesor_compras') or (K = 'compras') then Result := 'asesor_compras'
  else if (K = 'mantenimiento') then Result := 'mantenimiento'
  else if (K = 'accion') or (K = 'acciones') or (K = 'acciones_recomendadas') then Result := 'acciones'
  else if (K = 'resumen') then Result := 'tend_resumen'
  else if (K = 'familia') or (K = 'familias') then Result := 'tend_familias'
  else if (K = 'articulo') or (K = 'articulos') then Result := 'tend_articulos'
  else if (K = 'cliente') or (K = 'clientes') then Result := 'tend_clientes'
  else if (K = 'actualizar') or (K = 'analizar') then Result := 'tend_actualizar'
  else if (K = 'exportar') or (K = 'exportar_csv') then Result := 'tend_exportar'
  else if (K = 'imprimir') then Result := 'tend_imprimir'
  else if (K = 'graficos') then Result := 'tend_graficos'
  else if (K = 'configuracion') then Result := 'tend_configuracion'
  else if (K = 'cerrar') then Result := 'tend_cerrar';
end;

function TryPath(const ADir, AName: string): string;
begin
  Result := IncludeTrailingPathDelimiter(ADir) + AName;
  if not FileExists(Result) then Result := '';
end;

function FLXIconFile(const AIconName: string; ASize: Integer): string;
var
  Key, FileName, ExeDir, CurDir, SizeDir: string;
  Candidates: array[0..16] of string;
  I: Integer;
begin
  Result := '';
  Key := MapIconName(AIconName);
  FileName := Key + '.png';
  if ASize <= 30 then SizeDir := '30x30'
  else if ASize <= 48 then SizeDir := '48x48'
  else SizeDir := '64x64';

  ExeDir := ExtractFilePath(ParamStr(0));
  CurDir := GetCurrentDir;

  // Produccion FacturLinEx 2: recursos instalados en /usr/share/facturlinex2.
  // No depende del directorio desde el que se lance el programa.
  Candidates[0] := '/usr/share/facturlinex2/Imagenes/Inteligencia/' + SizeDir;
  Candidates[1] := '/usr/share/facturlinex2/Imagenes/Inteligencia/30x30';
  Candidates[2] := '/usr/share/facturlinex2/Imagenes/Inteligencia';
  Candidates[3] := '/usr/share/facturlinex2/Imagenes/' + SizeDir;
  Candidates[4] := '/usr/share/facturlinex2/Imagenes/30x30';
  Candidates[5] := '/usr/share/facturlinex2/Imagenes';

  // Pruebas/desarrollo: rutas relativas al ejecutable y al directorio actual.
  Candidates[6] := ExeDir + '..' + DirectorySeparator + 'Imagenes' + DirectorySeparator + 'Inteligencia' + DirectorySeparator + SizeDir;
  Candidates[7] := ExeDir + 'Imagenes' + DirectorySeparator + 'Inteligencia' + DirectorySeparator + SizeDir;
  Candidates[8] := CurDir + DirectorySeparator + 'Imagenes' + DirectorySeparator + 'Inteligencia' + DirectorySeparator + SizeDir;
  Candidates[9] := ExeDir + '..' + DirectorySeparator + 'Imagenes' + DirectorySeparator + '30x30';
  Candidates[10] := ExeDir + 'Imagenes' + DirectorySeparator + '30x30';
  Candidates[11] := CurDir + DirectorySeparator + 'Imagenes' + DirectorySeparator + '30x30';
  Candidates[12] := ExeDir + '..' + DirectorySeparator + 'Imagenes';
  Candidates[13] := ExeDir + 'Imagenes';
  Candidates[14] := CurDir + DirectorySeparator + 'Imagenes';
  Candidates[15] := ExeDir + '..' + DirectorySeparator + 'Imagenes' + DirectorySeparator + SizeDir;
  Candidates[16] := CurDir;

  for I := Low(Candidates) to High(Candidates) do
  begin
    Result := TryPath(Candidates[I], FileName);
    if Result <> '' then Exit;
  end;
end;

procedure FLXSetBitBtnIcon(ABtn: TBitBtn; const AIconName: string; ASize: Integer);
var
  FN: string;
  Pic: TPicture;
begin
  if not Assigned(ABtn) then Exit;
  FN := FLXIconFile(AIconName, ASize);
  if FN = '' then Exit;
  Pic := TPicture.Create;
  try
    Pic.LoadFromFile(FN);
    ABtn.Glyph.Assign(Pic.Graphic);
    ABtn.NumGlyphs := 1;
    ABtn.Layout := blGlyphTop;
  finally
    Pic.Free;
  end;
end;

procedure FLXSetIntelligenceButtonIcon(ABtn: TBitBtn; const AKeyOrCaption: string; ASize: Integer);
begin
  FLXSetBitBtnIcon(ABtn, AKeyOrCaption, ASize);
end;

end.
