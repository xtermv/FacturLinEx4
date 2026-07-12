unit uFLXButtonStyle;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, Buttons, StdCtrls, ExtCtrls;

procedure FLXPrepararBitBtn(B: TBitBtn; const ACaption: string = ''; AWidth: Integer = 96; AHeight: Integer = 54);
procedure FLXPrepararButton(B: TButton; const ACaption: string = ''; AWidth: Integer = 96; AHeight: Integer = 32);
procedure FLXPrepararPanelBotones(P: TPanel);
procedure FLXBotonPrincipal(B: TBitBtn);
procedure FLXBotonAdvertencia(B: TBitBtn);
procedure FLXBotonCerrar(B: TBitBtn);

implementation

procedure FLXPrepararBitBtn(B: TBitBtn; const ACaption: string; AWidth: Integer; AHeight: Integer);
begin
  if B = nil then Exit;
  if ACaption <> '' then B.Caption := ACaption;
  B.Width := AWidth;
  B.Height := AHeight;
  B.Layout := blGlyphTop;
  B.Spacing := 2;
  B.Margin := 3;
  B.Font.Color := clBlack;
  B.Font.Style := [];
  B.ShowHint := True;
  if B.Hint = '' then B.Hint := B.Caption;
end;

procedure FLXPrepararButton(B: TButton; const ACaption: string; AWidth: Integer; AHeight: Integer);
begin
  if B = nil then Exit;
  if ACaption <> '' then B.Caption := ACaption;
  B.Width := AWidth;
  B.Height := AHeight;
  B.Font.Color := clBlack;
  B.ShowHint := True;
  if B.Hint = '' then B.Hint := B.Caption;
end;

procedure FLXPrepararPanelBotones(P: TPanel);
begin
  if P = nil then Exit;
  P.BevelOuter := bvNone;
  P.Color := clBtnFace;
  P.Height := 64;
end;

procedure FLXBotonPrincipal(B: TBitBtn);
begin
  FLXPrepararBitBtn(B);
  B.Font.Style := [fsBold];
end;

procedure FLXBotonAdvertencia(B: TBitBtn);
begin
  FLXPrepararBitBtn(B);
  B.Font.Color := clBlack;
  B.Color := $00DFFFFF;
end;

procedure FLXBotonCerrar(B: TBitBtn);
begin
  FLXPrepararBitBtn(B, '', 82, 54);
end;

end.
