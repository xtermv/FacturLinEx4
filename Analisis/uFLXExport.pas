unit uFLXExport;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids;

{ Exportación común FacturLinEx.
  Unidad base reutilizable, sin lógica de negocio.
  No cambia ningún formulario por sí sola: solo ofrece funciones comunes
  para que Doctor, Alertas, Tendencias, Predicciones, etc. exporten igual. }

function FLXCSVValue(const S: string): string;
function FLXExportarStringGridCSV(Grid: TStringGrid; const AFichero: string): Boolean;
function FLXExportarStringGridTXT(Grid: TStringGrid; const AFichero: string): Boolean;
function FLXGuardarTextoTXT(const Texto, AFichero: string): Boolean;
function FLXGuardarCSVConDialogo(Grid: TStringGrid; const ATitulo, AFicheroSugerido: string): Boolean;
function FLXGuardarTXTConDialogo(const Texto, ATitulo, AFicheroSugerido: string): Boolean;

implementation

uses
  Dialogs;

function FLXCSVValue(const S: string): string;
var
  T: string;
begin
  T := StringReplace(S, '"', '""', [rfReplaceAll]);
  Result := '"' + T + '"';
end;

function FLXExportarStringGridCSV(Grid: TStringGrid; const AFichero: string): Boolean;
var
  SL: TStringList;
  R, C: Integer;
  Linea: string;
begin
  Result := False;
  if (Grid = nil) or (AFichero = '') then Exit;

  SL := TStringList.Create;
  try
    SL.LineBreak := LineEnding;
    for R := 0 to Grid.RowCount - 1 do
    begin
      Linea := '';
      for C := 0 to Grid.ColCount - 1 do
      begin
        if C > 0 then Linea := Linea + ';';
        Linea := Linea + FLXCSVValue(Grid.Cells[C, R]);
      end;
      SL.Add(Linea);
    end;
    SL.SaveToFile(AFichero);
    Result := True;
  finally
    SL.Free;
  end;
end;

function FLXExportarStringGridTXT(Grid: TStringGrid; const AFichero: string): Boolean;
var
  SL: TStringList;
  R, C: Integer;
  Linea: string;
begin
  Result := False;
  if (Grid = nil) or (AFichero = '') then Exit;

  SL := TStringList.Create;
  try
    for R := 0 to Grid.RowCount - 1 do
    begin
      Linea := '';
      for C := 0 to Grid.ColCount - 1 do
      begin
        if C > 0 then Linea := Linea + #9;
        Linea := Linea + Grid.Cells[C, R];
      end;
      SL.Add(Linea);
    end;
    SL.SaveToFile(AFichero);
    Result := True;
  finally
    SL.Free;
  end;
end;

function FLXGuardarTextoTXT(const Texto, AFichero: string): Boolean;
var
  SL: TStringList;
begin
  Result := False;
  if AFichero = '' then Exit;

  SL := TStringList.Create;
  try
    SL.Text := Texto;
    SL.SaveToFile(AFichero);
    Result := True;
  finally
    SL.Free;
  end;
end;

function FLXGuardarCSVConDialogo(Grid: TStringGrid; const ATitulo, AFicheroSugerido: string): Boolean;
var
  D: TSaveDialog;
begin
  Result := False;
  D := TSaveDialog.Create(nil);
  try
    D.Title := ATitulo;
    D.Filter := 'CSV (*.csv)|*.csv|Todos los archivos|*.*';
    D.DefaultExt := 'csv';
    D.FileName := AFicheroSugerido;
    if D.Execute then
      Result := FLXExportarStringGridCSV(Grid, D.FileName);
  finally
    D.Free;
  end;
end;

function FLXGuardarTXTConDialogo(const Texto, ATitulo, AFicheroSugerido: string): Boolean;
var
  D: TSaveDialog;
begin
  Result := False;
  D := TSaveDialog.Create(nil);
  try
    D.Title := ATitulo;
    D.Filter := 'Texto (*.txt)|*.txt|Todos los archivos|*.*';
    D.DefaultExt := 'txt';
    D.FileName := AFicheroSugerido;
    if D.Execute then
      Result := FLXGuardarTextoTXT(Texto, D.FileName);
  finally
    D.Free;
  end;
end;

end.
