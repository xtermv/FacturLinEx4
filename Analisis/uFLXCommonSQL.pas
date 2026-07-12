unit uFLXCommonSQL;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function FLXQ(const S: string): string;
function FLXIdent(const S: string): string;
function FLXLike(const S: string): string;
function FLXTablaTienda(const Prefijo, Tienda: string): string;
function FLXCampoExisteSQL(const Tabla, Campo: string): string;
function FLXTablaExisteSQL(const Tabla: string): string;
function FLXLimitSQL(const SQL: string; const Limite: Integer): string;

implementation

function FLXQ(const S: string): string;
begin
  Result := QuotedStr(StringReplace(S, '''', '''''', [rfReplaceAll]));
end;

function FLXIdent(const S: string): string;
begin
  Result := '`' + StringReplace(S, '`', '', [rfReplaceAll]) + '`';
end;

function FLXLike(const S: string): string;
var
  R: string;
begin
  R := StringReplace(S, '\\', '\\\\', [rfReplaceAll]);
  R := StringReplace(R, '%', '\%', [rfReplaceAll]);
  R := StringReplace(R, '_', '\_', [rfReplaceAll]);
  R := StringReplace(R, '''', '''''', [rfReplaceAll]);
  Result := QuotedStr('%' + R + '%');
end;

function FLXTablaTienda(const Prefijo, Tienda: string): string;
begin
  Result := Prefijo + Tienda;
end;

function FLXCampoExisteSQL(const Tabla, Campo: string): string;
begin
  Result :=
    'SELECT COUNT(*) AS EXISTE FROM INFORMATION_SCHEMA.COLUMNS ' +
    'WHERE TABLE_SCHEMA = DATABASE() ' +
    'AND TABLE_NAME = ' + FLXQ(Tabla) + ' ' +
    'AND COLUMN_NAME = ' + FLXQ(Campo);
end;

function FLXTablaExisteSQL(const Tabla: string): string;
begin
  Result :=
    'SELECT COUNT(*) AS EXISTE FROM INFORMATION_SCHEMA.TABLES ' +
    'WHERE TABLE_SCHEMA = DATABASE() ' +
    'AND TABLE_NAME = ' + FLXQ(Tabla);
end;

function FLXLimitSQL(const SQL: string; const Limite: Integer): string;
begin
  Result := Trim(SQL);
  if Limite > 0 then
    Result := Result + ' LIMIT ' + IntToStr(Limite);
end;

end.
