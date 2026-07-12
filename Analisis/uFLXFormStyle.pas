unit uFLXFormStyle;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, StdCtrls, ExtCtrls, Buttons;

procedure FLXPrepararFormulario(AForm: TCustomForm; const ATitulo: string = '');
procedure FLXMaximizarFormulario(AForm: TCustomForm);
procedure FLXAplicarCabecera(AParent: TWinControl; const ATitulo, ASubtitulo: string; const AColor: TColor = clDefault);
procedure FLXAplicarBoton(AButton: TControl);

implementation

procedure FLXPrepararFormulario(AForm: TCustomForm; const ATitulo: string);
begin
  if AForm = nil then Exit;
  if ATitulo <> '' then
    AForm.Caption := ATitulo;
  AForm.Position := poScreenCenter;
  AForm.WindowState := wsMaximized;
  AForm.Font.Name := 'Sans';
  AForm.Font.Size := 10;
  AForm.Color := clBtnFace;
end;

procedure FLXMaximizarFormulario(AForm: TCustomForm);
begin
  if AForm = nil then Exit;
  AForm.Position := poScreenCenter;
  AForm.WindowState := wsMaximized;
end;

procedure FLXAplicarCabecera(AParent: TWinControl; const ATitulo, ASubtitulo: string; const AColor: TColor);
var
  P: TPanel;
  L1, L2: TLabel;
  C: TColor;
begin
  if AParent = nil then Exit;
  C := AColor;
  if C = clDefault then C := $00F4F0EA;

  P := TPanel.Create(AParent);
  P.Parent := AParent;
  P.Align := alTop;
  P.Height := 58;
  P.BevelOuter := bvNone;
  P.Color := C;

  L1 := TLabel.Create(P);
  L1.Parent := P;
  L1.Left := 12;
  L1.Top := 8;
  L1.Caption := ATitulo;
  L1.Font.Style := [fsBold];
  L1.Font.Size := 13;
  L1.Font.Color := clBlack;

  L2 := TLabel.Create(P);
  L2.Parent := P;
  L2.Left := 12;
  L2.Top := 32;
  L2.Caption := ASubtitulo;
  L2.Font.Size := 9;
  L2.Font.Color := clBlack;
end;

procedure FLXAplicarBoton(AButton: TControl);
begin
  if AButton = nil then Exit;
  AButton.Height := 36;
  AButton.Width := 118;
  if AButton is TBitBtn then
  begin
    TBitBtn(AButton).Font.Style := [fsBold];
    TBitBtn(AButton).Font.Color := clBlack;
  end
  else if AButton is TButton then
  begin
    TButton(AButton).Font.Style := [fsBold];
    TButton(AButton).Font.Color := clBlack;
  end;
end;

end.
