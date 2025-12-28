unit uFLX_DBGridColor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Graphics, Grids, DBGrids;

procedure FLX_DBGrid_DrawColorGeneric(
  Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState;
  const MarkFieldName: string = 'V13';
  const MarkValue: string = 'S'
);

procedure FLX_DBGrid_AttachColorToAll(
  AOwner: TComponent;
  const MarkFieldName: string = 'V13';
  const MarkValue: string = 'S'
);

implementation

procedure FLX_DBGrid_DrawColorGeneric(
  Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState;
  const MarkFieldName: string;
  const MarkValue: string
);
var
  G: TDBGrid;
  DS: TDataSet;
  F: TField;
begin
  if not (Sender is TDBGrid) then Exit;

  G := TDBGrid(Sender);
  DS := nil;
  if (G.DataSource <> nil) then
    DS := G.DataSource.DataSet;

  // 1) Base: selección / no selección
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

  // 2) Marcado (solo si existe el campo; si no existe, no hace nada)
  if (DS <> nil) and (DS.Active) and (not DS.IsEmpty) then
  begin
    F := DS.FindField(MarkFieldName); // <- NO revienta si no existe
    if (F <> nil) and (F.AsString = MarkValue) then
      G.Canvas.Font.Color := clRed;
  end;

  // 3) Pintar fondo y luego dibujo estándar
  G.Canvas.FillRect(Rect);
  G.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure FLX_DBGrid_AttachColorToAll(
  AOwner: TComponent;
  const MarkFieldName: string;
  const MarkValue: string
);
var
  i: Integer;
  G: TDBGrid;
begin
  if AOwner = nil then Exit;

  for i := 0 to AOwner.ComponentCount - 1 do
  begin
    if AOwner.Components[i] is TDBGrid then
    begin
      G := TDBGrid(AOwner.Components[i]);

      // Enganchamos un handler común usando un método anónimo NO podemos en FPC clásico,
      // así que lo típico es asignar cada grid a un mismo procedimiento del FORM.
      // Aquí no podemos asignar directamente sin un método.
      //
      // Por eso esta rutina se usa normalmente junto al "handler único" del formulario.
    end;
  end;
end;

end.
