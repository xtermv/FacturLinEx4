unit uFLXMantenimientoMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, ComCtrls, LCLType,
  uFLXRepairTypes, uFLXRepairBase, uFLXRepairEngine,
  uFLXRepairOpenSSL, uFLXRepairPaths, uFLXRepairDesktop;

type
  TfrmFLXMantenimiento = class(TForm)
  private
    pnlHeader, pnlLeft, pnlRight, pnlFooter: TPanel;
    lblTitle, lblSubtitle, lblState, lblCode, lblRisk: TLabel;
    lstRepairs: TListBox;
    memoDetail, memoHistory: TMemo;
    btnRefresh, btnExecute, btnOpenLog, btnClose: TBitBtn;
    ProgressBar: TProgressBar;
    FContext: TFLXRepairContext;
    FEngine: TFLXRepairEngine;
    FAvailableCodes: TStringList;

    procedure BuildUI;
    procedure RegisterRepairs;
    procedure LoadRepairs;
    procedure ShowSelectedRepair;
    procedure RefreshClick(Sender: TObject);
    procedure ExecuteClick(Sender: TObject);
    procedure OpenLogClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure RepairSelectionChanged(Sender: TObject; User: Boolean);
    procedure FormKeyDownHandler(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    function SelectedCode: string;
    function FindRepairByCode(const ACode: string): TFLXRepair;
    function ConfirmRepair(ARepair: TFLXRepair): Boolean;
    procedure SetWorking(AWorking: Boolean; const AText: string);
    procedure LoadHistory;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmFLXMantenimiento: TfrmFLXMantenimiento;

implementation

uses
  uFLXRepairLog, Process;

constructor TfrmFLXMantenimiento.Create(TheOwner: TComponent);
begin
  inherited CreateNew(TheOwner, 1);
  Caption := 'Centro de Mantenimiento FacturLinEx';
  Width := 1080;
  Height := 720;
  Position := poScreenCenter;
  Constraints.MinWidth := 900;
  Constraints.MinHeight := 620;
  Color := RGBToColor(242, 246, 250);
  KeyPreview := True;
  OnKeyDown := @FormKeyDownHandler;

  FContext := TFLXRepairContext.Create;
  FEngine := TFLXRepairEngine.Create;
  FAvailableCodes := TStringList.Create;

  BuildUI;
  RegisterRepairs;
  LoadRepairs;
  LoadHistory;
end;

destructor TfrmFLXMantenimiento.Destroy;
begin
  FAvailableCodes.Free;
  FEngine.Free;
  FContext.Free;
  inherited Destroy;
end;

procedure TfrmFLXMantenimiento.BuildUI;
begin
  pnlHeader := TPanel.Create(Self);
  pnlHeader.Parent := Self;
  pnlHeader.Align := alTop;
  pnlHeader.Height := 110;
  pnlHeader.BevelOuter := bvNone;
  pnlHeader.Color := RGBToColor(34, 85, 135);
  pnlHeader.Caption := '';

  lblTitle := TLabel.Create(Self);
  lblTitle.Parent := pnlHeader;
  lblTitle.Left := 28;
  lblTitle.Top := 18;
  lblTitle.Caption := 'CENTRO DE MANTENIMIENTO';
  lblTitle.Font.Size := 23;
  lblTitle.Font.Style := [fsBold];
  lblTitle.Font.Color := clWhite;

  lblSubtitle := TLabel.Create(Self);
  lblSubtitle.Parent := pnlHeader;
  lblSubtitle.Left := 30;
  lblSubtitle.Top := 64;
  lblSubtitle.Caption := 'Diagnóstico y reparaciones seguras de FacturLinEx';
  lblSubtitle.Font.Size := 12;
  lblSubtitle.Font.Color := RGBToColor(220, 235, 248);

  pnlFooter := TPanel.Create(Self);
  pnlFooter.Parent := Self;
  pnlFooter.Align := alBottom;
  pnlFooter.Height := 72;
  pnlFooter.BevelOuter := bvNone;
  pnlFooter.Color := RGBToColor(226, 234, 242);
  pnlFooter.Caption := '';

  ProgressBar := TProgressBar.Create(Self);
  ProgressBar.Parent := pnlFooter;
  ProgressBar.Left := 22;
  ProgressBar.Top := 24;
  ProgressBar.Width := 430;
  ProgressBar.Height := 22;
  ProgressBar.Min := 0;
  ProgressBar.Max := 100;

  lblState := TLabel.Create(Self);
  lblState.Parent := pnlFooter;
  lblState.Left := 470;
  lblState.Top := 27;
  lblState.Caption := 'Preparado';

  btnClose := TBitBtn.Create(Self);
  btnClose.Parent := pnlFooter;
  btnClose.Caption := 'Cerrar';
  btnClose.Width := 110;
  btnClose.Height := 36;
  btnClose.Left := pnlFooter.Width - 132;
  btnClose.Top := 18;
  btnClose.Anchors := [akTop, akRight];
  btnClose.OnClick := @CloseClick;

  btnOpenLog := TBitBtn.Create(Self);
  btnOpenLog.Parent := pnlFooter;
  btnOpenLog.Caption := 'Ver historial';
  btnOpenLog.Width := 120;
  btnOpenLog.Height := 36;
  btnOpenLog.Left := btnClose.Left - 132;
  btnOpenLog.Top := 18;
  btnOpenLog.Anchors := [akTop, akRight];
  btnOpenLog.OnClick := @OpenLogClick;

  btnExecute := TBitBtn.Create(Self);
  btnExecute.Parent := pnlFooter;
  btnExecute.Caption := 'Ejecutar reparación';
  btnExecute.Width := 155;
  btnExecute.Height := 36;
  btnExecute.Left := btnOpenLog.Left - 167;
  btnExecute.Top := 18;
  btnExecute.Anchors := [akTop, akRight];
  btnExecute.OnClick := @ExecuteClick;

  btnRefresh := TBitBtn.Create(Self);
  btnRefresh.Parent := pnlFooter;
  btnRefresh.Caption := 'Actualizar';
  btnRefresh.Width := 110;
  btnRefresh.Height := 36;
  btnRefresh.Left := btnExecute.Left - 122;
  btnRefresh.Top := 18;
  btnRefresh.Anchors := [akTop, akRight];
  btnRefresh.OnClick := @RefreshClick;

  pnlLeft := TPanel.Create(Self);
  pnlLeft.Parent := Self;
  pnlLeft.Align := alLeft;
  pnlLeft.Width := 380;
  pnlLeft.BevelOuter := bvNone;
  pnlLeft.Color := RGBToColor(232, 240, 247);
  pnlLeft.Caption := '';

  lblCode := TLabel.Create(Self);
  lblCode.Parent := pnlLeft;
  lblCode.Left := 22;
  lblCode.Top := 18;
  lblCode.Caption := 'Reparaciones disponibles';
  lblCode.Font.Size := 15;
  lblCode.Font.Style := [fsBold];

  lstRepairs := TListBox.Create(Self);
  lstRepairs.Parent := pnlLeft;
  lstRepairs.Left := 20;
  lstRepairs.Top := 58;
  lstRepairs.Width := 340;
  lstRepairs.Height := 470;
  lstRepairs.Anchors := [akLeft, akTop, akRight, akBottom];
  lstRepairs.ItemHeight := 28;
  lstRepairs.OnSelectionChange := @RepairSelectionChanged;

  pnlRight := TPanel.Create(Self);
  pnlRight.Parent := Self;
  pnlRight.Align := alClient;
  pnlRight.BevelOuter := bvNone;
  pnlRight.Color := Color;
  pnlRight.Caption := '';

  lblRisk := TLabel.Create(Self);
  lblRisk.Parent := pnlRight;
  lblRisk.Left := 28;
  lblRisk.Top := 20;
  lblRisk.Caption := 'Seleccione una reparación';
  lblRisk.Font.Size := 17;
  lblRisk.Font.Style := [fsBold];

  memoDetail := TMemo.Create(Self);
  memoDetail.Parent := pnlRight;
  memoDetail.Left := 28;
  memoDetail.Top := 62;
  memoDetail.Width := 620;
  memoDetail.Height := 250;
  memoDetail.Anchors := [akLeft, akTop, akRight];
  memoDetail.ReadOnly := True;
  memoDetail.ScrollBars := ssAutoVertical;
  memoDetail.Color := clWhite;

  memoHistory := TMemo.Create(Self);
  memoHistory.Parent := pnlRight;
  memoHistory.Left := 28;
  memoHistory.Top := 334;
  memoHistory.Width := 620;
  memoHistory.Height := 195;
  memoHistory.Anchors := [akLeft, akTop, akRight, akBottom];
  memoHistory.ReadOnly := True;
  memoHistory.ScrollBars := ssAutoBoth;
  memoHistory.WordWrap := False;
  memoHistory.Color := RGBToColor(250, 250, 250);
end;

procedure TfrmFLXMantenimiento.RegisterRepairs;
begin
  FEngine.RegisterRepair(TFLXRepairOpenSSL.Create(FContext));
  FEngine.RegisterRepair(TFLXRepairPaths.Create(FContext));
  FEngine.RegisterRepair(TFLXRepairDesktop.Create(FContext));
end;

procedure TfrmFLXMantenimiento.LoadRepairs;
var
  Available: TStringList;
  I, P1, P2: Integer;
  S, Code, Title, RiskText: string;
begin
  lstRepairs.Items.BeginUpdate;
  try
    lstRepairs.Clear;
    FAvailableCodes.Clear;
    Available := FEngine.AvailableRepairs;
    try
      for I := 0 to Available.Count - 1 do
      begin
        S := Available[I];
        P1 := Pos('|', S);
        Code := Copy(S, 1, P1 - 1);
        Delete(S, 1, P1);
        P2 := Pos('|', S);
        Title := Copy(S, 1, P2 - 1);
        Delete(S, 1, P2);
        P2 := Pos('|', S);
        RiskText := Copy(S, 1, P2 - 1);

        FAvailableCodes.Add(Code);
        lstRepairs.Items.Add(Code + '  [' + RiskText + ']  ' + Title);
      end;
    finally
      Available.Free;
    end;
  finally
    lstRepairs.Items.EndUpdate;
  end;

  if lstRepairs.Count > 0 then
    lstRepairs.ItemIndex := 0
  else
  begin
    memoDetail.Lines.Text :=
      'No hay reparaciones automáticas disponibles en este momento.' + LineEnding +
      'Esto no significa que la auditoría completa esté libre de avisos.';
    btnExecute.Enabled := False;
  end;
  ShowSelectedRepair;
end;

function TfrmFLXMantenimiento.SelectedCode: string;
begin
  Result := '';
  if (lstRepairs.ItemIndex >= 0) and
     (lstRepairs.ItemIndex < FAvailableCodes.Count) then
    Result := FAvailableCodes[lstRepairs.ItemIndex];
end;

function TfrmFLXMantenimiento.FindRepairByCode(
  const ACode: string): TFLXRepair;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FEngine.Count - 1 do
    if SameText(FEngine.RepairAt(I).Code, ACode) then
      Exit(FEngine.RepairAt(I));
end;

procedure TfrmFLXMantenimiento.ShowSelectedRepair;
var
  R: TFLXRepair;
  Reason: string;
begin
  R := FindRepairByCode(SelectedCode);
  if not Assigned(R) then Exit;

  R.CanRepair(Reason);
  lblRisk.Caption := R.Code + ' — ' + R.Title;
  memoDetail.Lines.Text :=
    'Descripción' + LineEnding +
    R.Description + LineEnding + LineEnding +
    'Nivel de riesgo' + LineEnding +
    FLXRepairRiskToText(R.Risk) + LineEnding + LineEnding +
    'Tiempo estimado' + LineEnding +
    IntToStr(R.EstimatedSeconds) + ' segundos' + LineEnding + LineEnding +
    'Disponibilidad' + LineEnding +
    Reason;

  case R.Risk of
    rrLow: lblRisk.Font.Color := RGBToColor(20, 120, 60);
    rrMedium: lblRisk.Font.Color := RGBToColor(180, 105, 20);
    rrHigh: lblRisk.Font.Color := RGBToColor(180, 45, 45);
  end;
  btnExecute.Enabled := True;
end;

function TfrmFLXMantenimiento.ConfirmRepair(ARepair: TFLXRepair): Boolean;
var
  Msg: string;
begin
  Msg := ARepair.Code + ' — ' + ARepair.Title + LineEnding + LineEnding +
    ARepair.Description + LineEnding + LineEnding +
    'Riesgo: ' + FLXRepairRiskToText(ARepair.Risk);

  case ARepair.Risk of
    rrLow:
      Msg := Msg + LineEnding + LineEnding +
        'La operación está clasificada como segura y no altera datos fiscales.';
    rrMedium:
      Msg := Msg + LineEnding + LineEnding +
        'Se modificará configuración o estructura auxiliar. Se requiere confirmación.';
    rrHigh:
      Msg := Msg + LineEnding + LineEnding +
        'Operación crítica. Debe existir una copia de seguridad verificada.';
  end;

  Result := MessageDlg(Msg + LineEnding + LineEnding +
    '¿Desea continuar?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

procedure TfrmFLXMantenimiento.SetWorking(AWorking: Boolean;
  const AText: string);
begin
  btnRefresh.Enabled := not AWorking;
  btnExecute.Enabled := not AWorking;
  btnOpenLog.Enabled := not AWorking;
  btnClose.Enabled := not AWorking;
  lstRepairs.Enabled := not AWorking;
  lblState.Caption := AText;
  if AWorking then
  begin
    Screen.Cursor := crHourGlass;
    ProgressBar.Style := pbstMarquee;
  end
  else
  begin
    Screen.Cursor := crDefault;
    ProgressBar.Style := pbstNormal;
    ProgressBar.Position := 0;
  end;
  Application.ProcessMessages;
end;

procedure TfrmFLXMantenimiento.ExecuteClick(Sender: TObject);
var
  R: TFLXRepair;
  Res: TFLXRepairResult;
  OK: Boolean;
begin
  R := FindRepairByCode(SelectedCode);
  if not Assigned(R) or not ConfirmRepair(R) then Exit;

  SetWorking(True, 'FacturLinEx está aplicando la reparación...');
  try
    try
      OK := FEngine.ExecuteByCode(R.Code, Res);
      if OK then
        MessageDlg('Reparación completada correctamente.' + LineEnding +
          Res.Evidence, mtInformation, [mbOK], 0)
      else
        MessageDlg('La reparación no se pudo completar.' + LineEnding +
          Res.Evidence, mtError, [mbOK], 0);
    except
      on E: Exception do
        MessageDlg('Error durante la reparación:' + LineEnding + E.Message,
          mtError, [mbOK], 0);
    end;
  finally
    SetWorking(False, 'Preparado');
    LoadRepairs;
    LoadHistory;
  end;
end;

procedure TfrmFLXMantenimiento.LoadHistory;
var
  FN: string;
begin
  FN := FLXRepairLogFile;
  if FileExists(FN) then
    memoHistory.Lines.LoadFromFile(FN)
  else
    memoHistory.Lines.Text := 'Todavía no hay reparaciones registradas.';
end;

procedure TfrmFLXMantenimiento.RefreshClick(Sender: TObject);
begin
  LoadRepairs;
  LoadHistory;
end;

procedure TfrmFLXMantenimiento.OpenLogClick(Sender: TObject);
var
  P: TProcess;
  Opener, FN: string;
begin
  FN := FLXRepairLogFile;
  if not FileExists(FN) then
  begin
    MessageDlg('Todavía no existe historial de reparaciones.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  Opener := '';
  if FileExists('/usr/bin/xdg-open') then Opener := '/usr/bin/xdg-open'
  else if FileExists('/usr/bin/gio') then Opener := '/usr/bin/gio';

  if Opener = '' then
  begin
    MessageDlg('Historial:' + LineEnding + FN, mtInformation, [mbOK], 0);
    Exit;
  end;

  P := TProcess.Create(nil);
  try
    P.Executable := Opener;
    if ExtractFileName(Opener) = 'gio' then P.Parameters.Add('open');
    P.Parameters.Add(FN);
    P.Execute;
  finally
    P.Free;
  end;
end;

procedure TfrmFLXMantenimiento.CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFLXMantenimiento.RepairSelectionChanged(Sender: TObject; User: Boolean);
begin
  ShowSelectedRepair;
end;

procedure TfrmFLXMantenimiento.FormKeyDownHandler(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    if btnClose.Enabled then Close;
  end;
end;

end.
