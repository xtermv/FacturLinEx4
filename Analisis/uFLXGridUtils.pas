unit uFLXGridUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Grids, Graphics;

procedure FLXOrdenarStringGrid(AGrid: TStringGrid; ACol: Integer; var ALastCol: Integer; var ADesc: Boolean);
procedure FLXAjustarStringGridBasico(AGrid: TStringGrid);
procedure FLXPrepararCanvasSeleccionNegra(AGrid: TStringGrid; ARow: Integer; AState: TGridDrawState);

implementation

type
  TFLXGridRow = record
    KeyText: string;
    KeyNum: Double;
    IsNum: Boolean;
    Data: array of string;
    OrigIndex: Integer;
  end;

  TFLXGridRows = array of TFLXGridRow;

function FLXCleanHeader(const S: string): string;
begin
  Result := StringReplace(S, ' ▲', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' ▼', '', [rfReplaceAll]);
end;

function FLXTryFloat(const S: string; out V: Double): Boolean;
var
  T: string;
  FS: TFormatSettings;
begin
  T := Trim(S);
  T := StringReplace(T, '€', '', [rfReplaceAll]);
  T := StringReplace(T, '%', '', [rfReplaceAll]);
  T := StringReplace(T, ' ', '', [rfReplaceAll]);
  T := StringReplace(T, #160, '', [rfReplaceAll]);
  if T = '' then Exit(False);

  FS := DefaultFormatSettings;
  Result := TryStrToFloat(T, V, FS);
  if Result then Exit;

  FS.DecimalSeparator := ',';
  FS.ThousandSeparator := '.';
  Result := TryStrToFloat(T, V, FS);
  if Result then Exit;

  FS.DecimalSeparator := '.';
  FS.ThousandSeparator := ',';
  Result := TryStrToFloat(T, V, FS);
end;

function FLXCompareRows(const A, B: TFLXGridRow; Desc: Boolean): Integer;
begin
  if A.IsNum and B.IsNum then
  begin
    if A.KeyNum < B.KeyNum then Result := -1
    else if A.KeyNum > B.KeyNum then Result := 1
    else Result := A.OrigIndex - B.OrigIndex;
  end
  else
  begin
    Result := AnsiCompareText(A.KeyText, B.KeyText);
    if Result = 0 then Result := A.OrigIndex - B.OrigIndex;
  end;
  if Desc then Result := -Result;
end;

procedure FLXQuickSort(var Rows: TFLXGridRows; L, R: Integer; Desc: Boolean);
var
  I, J: Integer;
  P, T: TFLXGridRow;
begin
  I := L;
  J := R;
  P := Rows[(L + R) div 2];
  repeat
    while FLXCompareRows(Rows[I], P, Desc) < 0 do Inc(I);
    while FLXCompareRows(Rows[J], P, Desc) > 0 do Dec(J);
    if I <= J then
    begin
      T := Rows[I];
      Rows[I] := Rows[J];
      Rows[J] := T;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if L < J then FLXQuickSort(Rows, L, J, Desc);
  if I < R then FLXQuickSort(Rows, I, R, Desc);
end;

procedure FLXOrdenarStringGrid(AGrid: TStringGrid; ACol: Integer; var ALastCol: Integer; var ADesc: Boolean);
var
  Rows: TFLXGridRows;
  R, C, DataRows, FixedRows: Integer;
  V: Double;
begin
  if (AGrid = nil) or (ACol < 0) or (ACol >= AGrid.ColCount) then Exit;
  FixedRows := AGrid.FixedRows;
  if AGrid.RowCount <= FixedRows + 1 then Exit;

  if ALastCol = ACol then
    ADesc := not ADesc
  else
  begin
    ALastCol := ACol;
    ADesc := False;
  end;

  for C := 0 to AGrid.ColCount - 1 do
    AGrid.Cells[C, 0] := FLXCleanHeader(AGrid.Cells[C, 0]);
  if ADesc then
    AGrid.Cells[ACol, 0] := AGrid.Cells[ACol, 0] + ' ▼'
  else
    AGrid.Cells[ACol, 0] := AGrid.Cells[ACol, 0] + ' ▲';

  DataRows := AGrid.RowCount - FixedRows;
  SetLength(Rows, DataRows);
  for R := 0 to DataRows - 1 do
  begin
    Rows[R].KeyText := Trim(AGrid.Cells[ACol, R + FixedRows]);
    Rows[R].IsNum := FLXTryFloat(Rows[R].KeyText, V);
    Rows[R].KeyNum := V;
    Rows[R].OrigIndex := R;
    SetLength(Rows[R].Data, AGrid.ColCount);
    for C := 0 to AGrid.ColCount - 1 do
      Rows[R].Data[C] := AGrid.Cells[C, R + FixedRows];
  end;

  if Length(Rows) > 1 then
    FLXQuickSort(Rows, 0, High(Rows), ADesc);

  AGrid.BeginUpdate;
  try
    for R := 0 to High(Rows) do
      for C := 0 to AGrid.ColCount - 1 do
        AGrid.Cells[C, R + FixedRows] := Rows[R].Data[C];
  finally
    AGrid.EndUpdate;
  end;
end;

procedure FLXAjustarStringGridBasico(AGrid: TStringGrid);
var
  C, R, W, MaxW: Integer;
begin
  if AGrid = nil then Exit;
  AGrid.Options := AGrid.Options + [goColSizing, goRowSelect];
  AGrid.FixedRows := 1;
  AGrid.DefaultDrawing := True;

  { Ajuste prudente: calcula ancho por texto y limita para no crear columnas enormes }
  for C := 0 to AGrid.ColCount - 1 do
  begin
    MaxW := AGrid.Canvas.TextWidth(AGrid.Cells[C, 0]) + 24;
    for R := 1 to AGrid.RowCount - 1 do
    begin
      W := AGrid.Canvas.TextWidth(AGrid.Cells[C, R]) + 18;
      if W > MaxW then MaxW := W;
    end;
    if MaxW < 60 then MaxW := 60;
    if MaxW > 320 then MaxW := 320;
    AGrid.ColWidths[C] := MaxW;
  end;
end;

procedure FLXPrepararCanvasSeleccionNegra(AGrid: TStringGrid; ARow: Integer; AState: TGridDrawState);
begin
  if AGrid = nil then Exit;

  { Usar en OnDrawCell antes de pintar texto, para evitar texto blanco en fila seleccionada }
  if gdSelected in AState then
  begin
    AGrid.Canvas.Font.Color := clBlack;
    AGrid.Canvas.Brush.Color := $00EAF4FF;  { tono suave, legible }
  end
  else if (ARow > 0) and Odd(ARow) then
  begin
    AGrid.Canvas.Font.Color := clBlack;
    AGrid.Canvas.Brush.Color := $00F8F8F8;
  end
  else
  begin
    AGrid.Canvas.Font.Color := clBlack;
    AGrid.Canvas.Brush.Color := clWhite;
  end;
end;

end.
