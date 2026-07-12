unit uFLXGridStyle;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Grids, Graphics;

procedure FLXGridPreparar(AGrid: TStringGrid);
procedure FLXGridAutoAjustar(AGrid: TStringGrid; AMinWidth: Integer = 60; AMaxWidth: Integer = 360);
procedure FLXGridOrdenar(AGrid: TStringGrid; ACol: Integer; var ALastCol: Integer; var ADesc: Boolean);
procedure FLXGridPrepararCanvasSeleccion(AGrid: TStringGrid; ARow: Integer; AState: TGridDrawState);
function FLXGridCabeceraLimpia(const S: string): string;

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

function FLXGridCabeceraLimpia(const S: string): string;
begin
  Result := StringReplace(S, ' ▲', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' ▼', '', [rfReplaceAll]);
end;

function FLXTryFloatGrid(const S: string; out V: Double): Boolean;
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

  FS := DefaultFormatSettings;
  FS.DecimalSeparator := ',';
  FS.ThousandSeparator := '.';
  Result := TryStrToFloat(T, V, FS);
  if Result then Exit;

  FS := DefaultFormatSettings;
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

procedure FLXGridPreparar(AGrid: TStringGrid);
begin
  if AGrid = nil then Exit;
  AGrid.FixedRows := 1;
  AGrid.DefaultDrawing := True;
  AGrid.Options := AGrid.Options + [goColSizing, goRowSelect, goThumbTracking];
  AGrid.Color := clWhite;
  AGrid.Font.Color := clBlack;
  AGrid.FixedColor := $00E8E8E8;
end;

procedure FLXGridAutoAjustar(AGrid: TStringGrid; AMinWidth: Integer; AMaxWidth: Integer);
var
  C, R, W, MaxW: Integer;
begin
  if AGrid = nil then Exit;
  if AMinWidth < 30 then AMinWidth := 30;
  if AMaxWidth < AMinWidth then AMaxWidth := AMinWidth + 100;

  FLXGridPreparar(AGrid);

  for C := 0 to AGrid.ColCount - 1 do
  begin
    MaxW := AGrid.Canvas.TextWidth(FLXGridCabeceraLimpia(AGrid.Cells[C, 0])) + 28;
    for R := AGrid.FixedRows to AGrid.RowCount - 1 do
    begin
      W := AGrid.Canvas.TextWidth(AGrid.Cells[C, R]) + 22;
      if W > MaxW then MaxW := W;
    end;

    if MaxW < AMinWidth then MaxW := AMinWidth;
    if MaxW > AMaxWidth then MaxW := AMaxWidth;
    AGrid.ColWidths[C] := MaxW;
  end;
end;

procedure FLXGridOrdenar(AGrid: TStringGrid; ACol: Integer; var ALastCol: Integer; var ADesc: Boolean);
var
  Rows: TFLXGridRows;
  R, C, DataRows, FixedRows: Integer;
  V: Double;
begin
  if (AGrid = nil) or (ACol < 0) or (ACol >= AGrid.ColCount) then Exit;
  FixedRows := AGrid.FixedRows;
  if FixedRows < 1 then FixedRows := 1;
  if AGrid.RowCount <= FixedRows + 1 then Exit;

  if ALastCol = ACol then
    ADesc := not ADesc
  else
  begin
    ALastCol := ACol;
    ADesc := False;
  end;

  for C := 0 to AGrid.ColCount - 1 do
    AGrid.Cells[C, 0] := FLXGridCabeceraLimpia(AGrid.Cells[C, 0]);

  if ADesc then
    AGrid.Cells[ACol, 0] := AGrid.Cells[ACol, 0] + ' ▼'
  else
    AGrid.Cells[ACol, 0] := AGrid.Cells[ACol, 0] + ' ▲';

  DataRows := AGrid.RowCount - FixedRows;
  SetLength(Rows, DataRows);
  for R := 0 to DataRows - 1 do
  begin
    Rows[R].KeyText := Trim(AGrid.Cells[ACol, R + FixedRows]);
    Rows[R].IsNum := FLXTryFloatGrid(Rows[R].KeyText, V);
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

procedure FLXGridPrepararCanvasSeleccion(AGrid: TStringGrid; ARow: Integer; AState: TGridDrawState);
begin
  if AGrid = nil then Exit;

  AGrid.Canvas.Font.Color := clBlack;

  if gdSelected in AState then
    AGrid.Canvas.Brush.Color := $00EAF4FF   { azul suave, texto negro }
  else if gdFixed in AState then
    AGrid.Canvas.Brush.Color := $00E8E8E8
  else if (ARow > 0) and Odd(ARow) then
    AGrid.Canvas.Brush.Color := $00F8F8F8
  else
    AGrid.Canvas.Brush.Color := clWhite;
end;

end.
