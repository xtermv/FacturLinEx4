unit uFLX_DBGridPaint;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Graphics, Grids, DBGrids;

type
  // Callback opcional: decide si la fila está "marcada" (ej: roja)
  TFLXRowMarkedEvent = function(DS: TDataSet): Boolean;

procedure FLX_DBGrid_DrawColor(
  Sender: TObject;
  const Rect: TRect;
  DataCol: Integer;
  Column: TColumn;
  State: TGridDrawState;
  const Marked: TFLXRowMarkedEvent;
  const HideRowIndicator: Boolean = True
);

implementation

procedure FLX_DBGrid_DrawColor(
  Sender: TObject;
  const Rect: TRect;
  DataCol: Integer;
  Column: TColumn;
  State: TGridDrawState;
  const Marked: TFLXRowMarkedEvent;
  const HideRowIndicator: Boolean
);
var
  G: TDBGrid;
  DS: TDataSet;
  IsMarked: Boolean;
begin
  if not (Sender is TDBGrid) then Exit;

  G := TDBGrid(Sender);
  DS := nil;
  if (G.DataSource <> nil) then
    DS := G.DataSource.DataSet;

  // (Opcional) Ocultar el indicador/columna de "fila" (la del triángulo / número)
  // Nota: esto actúa sobre el dibujo; para quitar el ancho permanentemente mira el punto 2.
  if HideRowIndicator and (gdIndicator in State) then
  begin
    G.Canvas.Brush.Color := clWhite;
    G.Canvas.FillRect(Rect);
    Exit;
  end;

  // 1) Colores base
  if (gdSelected in State) then
  begin
    G.Canvas.Brush.Color := clInfoBK;
    G.Canvas.Font.Color := clBlack;
  end
  else
  begin
    G.Canvas.Brush.Color := clWhite;
    G.Canvas.Font.Color := clBlack;
  end;

  // 2) Marcado (solo cambia la fuente)
  IsMarked := False;
  if Assigned(Marked) and (DS <> nil) and (not DS.IsEmpty) then
    IsMarked := Marked(DS);

  if IsMarked then
    G.Canvas.Font.Color := clRed;

  // 3) Pintar fondo
  G.Canvas.FillRect(Rect);

  // 4) Dibujo estándar del contenido
  G.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

end.
