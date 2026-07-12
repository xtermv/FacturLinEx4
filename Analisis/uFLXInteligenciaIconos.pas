unit uFLXInteligenciaIconos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, Buttons, uFLXIcons;

procedure FLXAplicarIconosInteligencia(AOwner: TComponent);

implementation

function KeyFromCaption(const S: string): string;
var K: string;
begin
  K := LowerCase(Trim(S));
  K := StringReplace(K, 'á', 'a', [rfReplaceAll]);
  K := StringReplace(K, 'é', 'e', [rfReplaceAll]);
  K := StringReplace(K, 'í', 'i', [rfReplaceAll]);
  K := StringReplace(K, 'ó', 'o', [rfReplaceAll]);
  K := StringReplace(K, 'ú', 'u', [rfReplaceAll]);
  K := StringReplace(K, 'ñ', 'n', [rfReplaceAll]);

  Result := '';
  if Pos('doctor', K) > 0 then Result := 'doctor'
  else if Pos('alert', K) > 0 then Result := 'alertas'
  else if Pos('centro', K) > 0 then Result := 'centro_inteligencia'
  else if Pos('tend', K) > 0 then Result := 'tendencias'
  else if Pos('predic', K) > 0 then Result := 'predicciones'
  else if Pos('rentab', K) > 0 then Result := 'rentabilidad'
  else if Pos('precio', K) > 0 then Result := 'historico_precios'
  else if Pos('proveedor', K) > 0 then Result := 'proveedores'
  else if Pos('asesor', K) > 0 then Result := 'asesor_compras'
  else if Pos('manten', K) > 0 then Result := 'mantenimiento'
  else if Pos('accion', K) > 0 then Result := 'acciones';
end;

procedure FLXAplicarIconosInteligencia(AOwner: TComponent);
var
  I: Integer;
  B: TBitBtn;
  Key: string;
begin
  if not Assigned(AOwner) then Exit;
  for I := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[I] is TBitBtn then
    begin
      B := TBitBtn(AOwner.Components[I]);
      Key := KeyFromCaption(B.Caption);
      if Key <> '' then FLXSetIntelligenceButtonIcon(B, Key, 30);
    end;
end;

end.
