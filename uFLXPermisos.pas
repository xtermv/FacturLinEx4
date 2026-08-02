unit uFLXPermisos;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  Classes, SysUtils, ZConnection;

procedure FLXPermisosCargar(AConnection: TZConnection;
  const ATienda, ARol: string);
procedure FLXPermisosLimpiar;
function FLXTienePermiso(const AModulo: string;
  APosicion: Integer): Boolean;
function FLXPermisosAmpliadosActivos: Boolean;

implementation

uses
  ZDataset;

var
  FPermisos: TStringList = nil;
  FPermisosActivos: Boolean = False;

function NombreTablaPermisos(const ATienda: string): string;
var
  I: Integer;
  S: string;
begin
  S := '';
  for I := 1 to Length(ATienda) do
    if ATienda[I] in ['A'..'Z', 'a'..'z', '0'..'9', '_'] then
      S := S + ATienda[I];
  Result := 'rolespermisos' + S;
end;

procedure PrepararLista;
begin
  if Assigned(FPermisos) then Exit;
  FPermisos := TStringList.Create;
  FPermisos.CaseSensitive := False;
  FPermisos.NameValueSeparator := '=';
end;

procedure FLXPermisosLimpiar;
begin
  PrepararLista;
  FPermisos.Clear;
  FPermisosActivos := False;
end;

procedure FLXPermisosCargar(AConnection: TZConnection;
  const ATienda, ARol: string);
var
  Q: TZQuery;
  Tabla, Clave, Valor: string;
begin
  FLXPermisosLimpiar;
  if (AConnection = nil) or (Trim(ARol) = '') then Exit;

  Tabla := NombreTablaPermisos(ATienda);
  if Tabla = 'rolespermisos' then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;

    { Comprobar la tabla sin provocar una excepción en instalaciones
      que todavía no hayan abierto la nueva pantalla de roles. }
    Q.SQL.Text :=
      'SELECT COUNT(*) AS N FROM information_schema.tables ' +
      'WHERE table_schema=DATABASE() AND table_name=:tabla';
    Q.ParamByName('tabla').AsString := Tabla;
    Q.Open;
    if Q.FieldByName('N').AsInteger = 0 then Exit;
    Q.Close;

    Q.SQL.Text := 'SELECT Modulo, Permisos FROM `' + Tabla +
      '` WHERE CgoRol=:rol';
    Q.ParamByName('rol').AsString := Trim(ARol);
    Q.Open;

    while not Q.EOF do
    begin
      Clave := UpperCase(Trim(Q.FieldByName('Modulo').AsString));
      Valor := Trim(Q.FieldByName('Permisos').AsString);
      while Length(Valor) < 4 do Valor := Valor + '0';
      if Clave <> '' then
        FPermisos.Values[Clave] := Copy(Valor, 1, 4);
      Q.Next;
    end;

    { Solo se activa el modo ampliado cuando el rol tiene alguna fila.
      Así los roles antiguos continúan funcionando como hasta ahora. }
    FPermisosActivos := FPermisos.Count > 0;
  except
    { Un fallo al leer la tabla ampliada nunca debe impedir el acceso a
      FacturLinEx. Los permisos históricos siguen siendo la referencia. }
    FLXPermisosLimpiar;
  end;
  Q.Free;
end;

function FLXTienePermiso(const AModulo: string;
  APosicion: Integer): Boolean;
var
  S: string;
begin
  { Compatibilidad: si el rol aún no tiene permisos ampliados guardados,
    no se bloquea ningún módulo nuevo. }
  if not FPermisosActivos then Exit(True);
  if (APosicion < 1) or (APosicion > 4) then Exit(False);

  S := FPermisos.Values[UpperCase(Trim(AModulo))];
  if S = '' then Exit(True);
  while Length(S) < 4 do S := S + '0';

  Result := S[APosicion] = '1';
end;

function FLXPermisosAmpliadosActivos: Boolean;
begin
  Result := FPermisosActivos;
end;

initialization
  PrepararLista;

finalization
  FreeAndNil(FPermisos);

end.
