unit uFLXTaskProgress;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, ComCtrls, Graphics;

type
  TFLXTaskProgress = class
  private
    FOwner: TForm;
    FForm: TForm;
    FProgress: TProgressBar;
    FPhaseLabel: TLabel;
    FPercentLabel: TLabel;
    procedure PumpUI;
  public
    constructor Create(AOwner: TForm; const ATaskTitle: string);
    destructor Destroy; override;
    procedure Update(APercent: Integer; const APhase: string);
    procedure Close;
  end;

implementation

constructor TFLXTaskProgress.Create(AOwner: TForm; const ATaskTitle: string);
var
  Header: TPanel;
  L: TLabel;
begin
  inherited Create;
  FOwner := AOwner;

  FForm := TForm.CreateNew(nil, 1);
  FForm.Caption := 'FacturLinEx está trabajando';
  FForm.Position := poOwnerFormCenter;
  FForm.BorderStyle := bsDialog;
  FForm.BorderIcons := [];
  FForm.FormStyle := fsStayOnTop;
  FForm.Width := 760;
  FForm.Height := 270;
  FForm.Color := clWhite;

  Header := TPanel.Create(FForm);
  Header.Parent := FForm;
  Header.Align := alTop;
  Header.Height := 82;
  Header.BevelOuter := bvNone;
  Header.Color := RGBToColor(26, 62, 105);

  L := TLabel.Create(FForm);
  L.Parent := Header;
  L.SetBounds(26, 12, 700, 34);
  L.Caption := 'FACTURLINEX ESTÁ TRABAJANDO';
  L.ParentFont := False;
  L.Font.Height := -21;
  L.Font.Style := [fsBold];
  L.Font.Color := clWhite;

  L := TLabel.Create(FForm);
  L.Parent := Header;
  L.SetBounds(28, 49, 700, 22);
  L.Caption := ATaskTitle;
  L.ParentFont := False;
  L.Font.Height := -12;
  L.Font.Color := RGBToColor(225, 236, 248);

  FPhaseLabel := TLabel.Create(FForm);
  FPhaseLabel.Parent := FForm;
  FPhaseLabel.SetBounds(30, 104, 575, 52);
  FPhaseLabel.AutoSize := False;
  FPhaseLabel.WordWrap := True;
  FPhaseLabel.Caption := 'Preparando la tarea...';
  FPhaseLabel.ParentFont := False;
  FPhaseLabel.Font.Height := -15;
  FPhaseLabel.Font.Style := [fsBold];
  FPhaseLabel.Font.Color := RGBToColor(26, 62, 105);

  FPercentLabel := TLabel.Create(FForm);
  FPercentLabel.Parent := FForm;
  FPercentLabel.SetBounds(620, 104, 105, 45);
  FPercentLabel.AutoSize := False;
  FPercentLabel.Alignment := taRightJustify;
  FPercentLabel.Caption := '0 %';
  FPercentLabel.ParentFont := False;
  FPercentLabel.Font.Height := -22;
  FPercentLabel.Font.Style := [fsBold];
  FPercentLabel.Font.Color := RGBToColor(26, 62, 105);

  FProgress := TProgressBar.Create(FForm);
  FProgress.Parent := FForm;
  FProgress.SetBounds(30, 164, 695, 34);
  FProgress.Min := 0;
  FProgress.Max := 100;
  FProgress.Position := 0;
  FProgress.Smooth := True;

  L := TLabel.Create(FForm);
  L.Parent := FForm;
  L.SetBounds(30, 213, 695, 24);
  L.Caption := 'La aplicación continúa trabajando. No cierre FacturLinEx.';
  L.ParentFont := False;
  L.Font.Height := -12;
  L.Font.Color := RGBToColor(120, 75, 15);

  if Assigned(FOwner) then
    FOwner.Enabled := False;
  Screen.Cursor := crHourGlass;
  FForm.HandleNeeded;
  FForm.Show;
  FForm.BringToFront;
  PumpUI;
end;

procedure TFLXTaskProgress.PumpUI;
begin
  if Assigned(FForm) then
  begin
    FForm.BringToFront;
    FForm.Repaint;
    FForm.Update;
  end;
  Application.ProcessMessages;
end;

procedure TFLXTaskProgress.Update(APercent: Integer; const APhase: string);
begin
  if not Assigned(FForm) then Exit;
  if APercent < 0 then APercent := 0;
  if APercent > 100 then APercent := 100;
  FProgress.Position := APercent;
  FPhaseLabel.Caption := APhase;
  FPercentLabel.Caption := IntToStr(APercent) + ' %';
  FForm.Caption := 'FacturLinEx está trabajando - ' + IntToStr(APercent) + ' %';
  PumpUI;
end;

procedure TFLXTaskProgress.Close;
begin
  Screen.Cursor := crDefault;
  if Assigned(FOwner) then
  begin
    FOwner.Enabled := True;
    FOwner.BringToFront;
  end;
  FreeAndNil(FForm);
  FProgress := nil;
  FPhaseLabel := nil;
  FPercentLabel := nil;
  Application.ProcessMessages;
end;

destructor TFLXTaskProgress.Destroy;
begin
  Close;
  inherited Destroy;
end;

end.
