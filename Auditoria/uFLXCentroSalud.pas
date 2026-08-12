unit uFLXCentroSalud;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Buttons, ComCtrls,
  Graphics, Dialogs, LCLType, ZConnection;

procedure FLX_OpenHealthCenter(AConnection: TZConnection);

implementation

uses
  Global, uFLXAuditEngine, uFLXAuditTypes, uFLXSchemaAudit, uFLXTaskProgress;

type
  TfrmFLXCentroSalud = class(TForm)
  private
    FConnection: TZConnection;
    HeaderPanel, MainPanel, MetricsPanel, StatusPanel, BottomPanel: TPanel;
    LbTitle, LbSubtitle, LbTraffic, LbProgress, LbOK, LbWarnings,
      LbErrors, LbNotChecked, LbDatabase, LbVeriFactu, LbCertificates,
      LbConfiguration, LbInstallation, LbDocumentation, LbDeclaration, LbLastRun: TLabel;
    Progress: TProgressBar;
    MemoResults: TMemo;
    BtnRun, BtnSave, BtnHistory, BtnCompare, BtnMilestones, BtnSchema, BtnUpdateReady, BtnClose: TBitBtn;
    FLastReportText: string;
    FCurrentPercent: Integer;
    FCurrentState: string;
    FTaskProgress: TFLXTaskProgress;
    procedure BuildUI;
    procedure RunAudit(AFull: Boolean);
    procedure BtnRunClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnHistoryClick(Sender: TObject);
    procedure BtnCompareClick(Sender: TObject);
    procedure BtnMilestonesClick(Sender: TObject);
    procedure BtnSchemaClick(Sender: TObject);
    procedure BtnUpdateReadyClick(Sender: TObject);
    procedure SchemaProgress(APercent: Integer; const AMessage: string);
    procedure OpenWorkProgress(const ATitle: string);
    procedure CloseWorkProgress;
    function HistoryFileName: string;
    procedure AppendHistoryEntry(const AReportFile: string);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function CategoryState(AReport: TFLXAuditReport; const ACategory: string): string;
    procedure SetStatusLabel(ALabel: TLabel; const ACaption: string;
      ALevel: TFLXAuditLevel);
  public
    constructor CreateWith(AConnection: TZConnection); reintroduce;
  end;

procedure FLX_OpenHealthCenter(AConnection: TZConnection);
var
  F: TfrmFLXCentroSalud;
begin
  if (AConnection = nil) or (not AConnection.Connected) then
  begin
    MessageDlg('Centro de Salud',
      'No hay una conexión activa con la base de datos.', mtError, [mbOK], 0);
    Exit;
  end;
  F := TfrmFLXCentroSalud.CreateWith(AConnection);
  F.Show;
  F.BringToFront;
  F.Repaint;
  Application.ProcessMessages;
  F.RunAudit(False);
end;

constructor TfrmFLXCentroSalud.CreateWith(AConnection: TZConnection);
begin
  inherited CreateNew(nil, 1);
  FConnection := AConnection;
  Caption := 'Centro de Salud de FacturLinEx';
  Position := poScreenCenter;
  WindowState := wsMaximized;
  Width := 1420;
  Height := 850;
  Color := clWhite;
  Font.Name := 'Sans';
  Font.Height := -13;
  KeyPreview := True;
  OnKeyDown := @FormKeyDown;
  BuildUI;
end;

procedure TfrmFLXCentroSalud.BuildUI;
  procedure MakeMetric(var L: TLabel; const ACaption: string; ALeft: Integer);
  begin
    L := TLabel.Create(Self);
    L.Parent := MetricsPanel;
    L.SetBounds(ALeft, 22, 235, 34);
    L.AutoSize := False;
    L.Alignment := taCenter;
    L.Layout := tlCenter;
    L.Caption := ACaption;
    L.ParentFont := False;
    L.Font.Height := -14;
    L.Font.Style := [fsBold];
    L.Color := clWhite;
    L.Transparent := False;
  end;
  procedure MakeStatus(var L: TLabel; const ACaption: string; ATop: Integer);
  begin
    L := TLabel.Create(Self);
    L.Parent := StatusPanel;
    L.SetBounds(22, ATop, StatusPanel.ClientWidth - 44, 38);
    L.Anchors := [akLeft, akTop, akRight];
    L.AutoSize := False;
    L.Layout := tlCenter;
    L.Caption := ACaption;
    L.ParentFont := False;
    L.Font.Height := -13;
    L.Font.Style := [fsBold];
    L.Color := RGBToColor(245, 247, 250);
    L.Transparent := False;
  end;
begin
  HeaderPanel := TPanel.Create(Self);
  HeaderPanel.Parent := Self;
  HeaderPanel.Align := alTop;
  HeaderPanel.Height := 112;
  HeaderPanel.BevelOuter := bvNone;
  HeaderPanel.Color := RGBToColor(26, 62, 105);

  LbTitle := TLabel.Create(Self);
  LbTitle.Parent := HeaderPanel;
  LbTitle.SetBounds(24, 12, 760, 38);
  LbTitle.Caption := 'CENTRO DE SALUD DE FACTURLINEX';
  LbTitle.ParentFont := False;
  LbTitle.Font.Height := -24;
  LbTitle.Font.Style := [fsBold];
  LbTitle.Font.Color := clWhite;

  LbSubtitle := TLabel.Create(Self);
  LbSubtitle.Parent := HeaderPanel;
  LbSubtitle.SetBounds(26, 56, 900, 24);
  LbSubtitle.Caption := 'Auditoría unificada de base de datos, VeriFactu, instalación y documentación.';
  LbSubtitle.ParentFont := False;
  LbSubtitle.Font.Height := -12;
  LbSubtitle.Font.Color := RGBToColor(220, 230, 240);

  LbTraffic := TLabel.Create(Self);
  LbTraffic.Parent := HeaderPanel;
  LbTraffic.SetBounds(HeaderPanel.Width - 430, 22, 270, 56);
  LbTraffic.Anchors := [akTop, akRight];
  LbTraffic.AutoSize := False;
  LbTraffic.Alignment := taCenter;
  LbTraffic.Layout := tlCenter;
  LbTraffic.Caption := 'COMPROBANDO';
  LbTraffic.ParentFont := False;
  LbTraffic.Font.Height := -17;
  LbTraffic.Font.Style := [fsBold];
  LbTraffic.Font.Color := clWhite;
  LbTraffic.Color := RGBToColor(110, 110, 110);
  LbTraffic.Transparent := False;

  BtnClose := TBitBtn.Create(Self);
  BtnClose.Parent := HeaderPanel;
  BtnClose.SetBounds(HeaderPanel.Width - 140, 31, 110, 38);
  BtnClose.Anchors := [akTop, akRight];
  BtnClose.Caption := 'Cerrar';
  BtnClose.OnClick := @BtnCloseClick;

  MainPanel := TPanel.Create(Self);
  MainPanel.Parent := Self;
  MainPanel.Align := alClient;
  MainPanel.BevelOuter := bvNone;
  MainPanel.Color := clWhite;

  LbProgress := TLabel.Create(Self);
  LbProgress.Parent := MainPanel;
  LbProgress.SetBounds(24, 18, 540, 25);
  LbProgress.Caption := 'Nivel de preparación interna: 0 %';
  LbProgress.ParentFont := False;
  LbProgress.Font.Height := -15;
  LbProgress.Font.Style := [fsBold];
  LbProgress.Font.Color := RGBToColor(26, 62, 105);

  Progress := TProgressBar.Create(Self);
  Progress.Parent := MainPanel;
  Progress.SetBounds(24, 50, MainPanel.ClientWidth - 48, 28);
  Progress.Anchors := [akLeft, akTop, akRight];
  Progress.Min := 0;
  Progress.Max := 100;
  Progress.Position := 0;

  MetricsPanel := TPanel.Create(Self);
  MetricsPanel.Parent := MainPanel;
  MetricsPanel.SetBounds(24, 94, MainPanel.ClientWidth - 48, 78);
  MetricsPanel.Anchors := [akLeft, akTop, akRight];
  MetricsPanel.BevelOuter := bvNone;
  MetricsPanel.Color := RGBToColor(238, 243, 248);

  MakeMetric(LbOK, 'Correctas: 0', 20);
  MakeMetric(LbWarnings, 'Avisos: 0', 275);
  MakeMetric(LbErrors, 'Errores: 0', 530);
  MakeMetric(LbNotChecked, 'No comprobadas: 0', 785);

  StatusPanel := TPanel.Create(Self);
  StatusPanel.Parent := MainPanel;
  StatusPanel.SetBounds(24, 190, 500, MainPanel.ClientHeight - 270);
  StatusPanel.Anchors := [akLeft, akTop, akBottom];
  StatusPanel.BevelOuter := bvNone;
  StatusPanel.Color := RGBToColor(248, 250, 252);

  MakeStatus(LbDatabase, 'Base de datos: pendiente', 18);
  MakeStatus(LbVeriFactu, 'VeriFactu: pendiente', 66);
  MakeStatus(LbCertificates, 'Certificados y OpenSSL: pendiente', 114);
  MakeStatus(LbConfiguration, 'Configuración: pendiente', 162);
  MakeStatus(LbInstallation, 'Instalación y dependencias: pendiente', 210);
  MakeStatus(LbDocumentation, 'Documentación: pendiente', 258);
  MakeStatus(LbDeclaration, 'Declaración responsable: EN PREPARACIÓN', 306);

  LbLastRun := TLabel.Create(Self);
  LbLastRun.Parent := StatusPanel;
  LbLastRun.SetBounds(24, 366, StatusPanel.ClientWidth - 48, 48);
  LbLastRun.Anchors := [akLeft, akTop, akRight];
  LbLastRun.WordWrap := True;
  LbLastRun.Caption := 'Auditoría aún no ejecutada.';
  LbLastRun.Font.Color := clGray;

  MemoResults := TMemo.Create(Self);
  MemoResults.Parent := MainPanel;
  MemoResults.SetBounds(545, 190, MainPanel.ClientWidth - 569,
    MainPanel.ClientHeight - 270);
  MemoResults.Anchors := [akLeft, akTop, akRight, akBottom];
  MemoResults.ReadOnly := True;
  MemoResults.ScrollBars := ssAutoBoth;
  MemoResults.WordWrap := False;
  MemoResults.Font.Name := 'Monospace';
  MemoResults.Font.Height := -12;
  MemoResults.Color := clWhite;

  BottomPanel := TPanel.Create(Self);
  BottomPanel.Parent := Self;
  BottomPanel.Align := alBottom;
  BottomPanel.Height := 72;
  BottomPanel.BevelOuter := bvNone;
  BottomPanel.Color := RGBToColor(238, 243, 248);

  BtnRun := TBitBtn.Create(Self);
  BtnRun.Parent := BottomPanel;
  BtnRun.SetBounds(24, 17, 230, 38);
  BtnRun.Caption := 'Ejecutar auditoría completa';
  BtnRun.Font.Style := [fsBold];
  BtnRun.OnClick := @BtnRunClick;

  BtnSave := TBitBtn.Create(Self);
  BtnSave.Parent := BottomPanel;
  BtnSave.SetBounds(274, 17, 210, 38);
  BtnSave.Caption := 'Guardar informe';
  BtnSave.Enabled := False;
  BtnSave.OnClick := @BtnSaveClick;

  BtnHistory := TBitBtn.Create(Self);
  BtnHistory.Parent := BottomPanel;
  BtnHistory.SetBounds(504, 17, 190, 38);
  BtnHistory.Caption := 'Ver historial';
  BtnHistory.OnClick := @BtnHistoryClick;

  BtnCompare := TBitBtn.Create(Self);
  BtnCompare.Parent := BottomPanel;
  BtnCompare.SetBounds(714, 17, 220, 38);
  BtnCompare.Caption := 'Comparar con anterior';
  BtnCompare.OnClick := @BtnCompareClick;

  BtnMilestones := TBitBtn.Create(Self);
  BtnMilestones.Parent := BottomPanel;
  BtnMilestones.SetBounds(954, 17, 180, 38);
  BtnMilestones.Caption := 'Hitos 4.2.6';
  BtnMilestones.Font.Style := [fsBold];
  BtnMilestones.OnClick := @BtnMilestonesClick;

  BtnSchema := TBitBtn.Create(Self);
  BtnSchema.Parent := BottomPanel;
  BtnSchema.SetBounds(1125, 17, 190, 38);
  BtnSchema.Caption := 'Exportar esquema';
  BtnSchema.OnClick := @BtnSchemaClick;

  BtnUpdateReady := TBitBtn.Create(Self);
  BtnUpdateReady.Parent := BottomPanel;
  BtnUpdateReady.SetBounds(1330, 17, 220, 38);
  BtnUpdateReady.Caption := '¿Preparado para actualizar?';
  BtnUpdateReady.Font.Style := [fsBold];
  BtnUpdateReady.OnClick := @BtnUpdateReadyClick;
end;

procedure TfrmFLXCentroSalud.SetStatusLabel(ALabel: TLabel;
  const ACaption: string; ALevel: TFLXAuditLevel);
begin
  ALabel.Caption := ACaption;
  case ALevel of
    alError:
      begin
        ALabel.Color := RGBToColor(252, 226, 226);
        ALabel.Font.Color := RGBToColor(160, 30, 30);
      end;
    alWarning, alNotChecked:
      begin
        ALabel.Color := RGBToColor(255, 244, 210);
        ALabel.Font.Color := RGBToColor(145, 90, 0);
      end;
    alOK:
      begin
        ALabel.Color := RGBToColor(224, 245, 230);
        ALabel.Font.Color := RGBToColor(20, 110, 50);
      end;
  else
    begin
      ALabel.Color := RGBToColor(235, 240, 246);
      ALabel.Font.Color := RGBToColor(40, 70, 105);
    end;
  end;
end;

function TfrmFLXCentroSalud.CategoryState(AReport: TFLXAuditReport;
  const ACategory: string): string;
var
  I: Integer;
  HasWarning, HasAny: Boolean;
begin
  Result := 'NO COMPROBADO';
  HasWarning := False;
  HasAny := False;
  for I := 0 to AReport.Count - 1 do
    if SameText(AReport[I].Category, ACategory) then
    begin
      HasAny := True;
      if AReport[I].Level = alError then Exit('ERROR');
      if AReport[I].Level in [alWarning, alNotChecked] then HasWarning := True;
    end;
  if not HasAny then Exit('NO COMPROBADO');
  if HasWarning then Result := 'AVISO' else Result := 'CORRECTO';
end;

procedure TfrmFLXCentroSalud.RunAudit(AFull: Boolean);
var
  Engine: TFLXAuditEngine;
  Report: TFLXAuditReport;
  SchemaAudit: TFLXSchemaAudit;
  AuditTitle: string;
  IniName, S: string;
  TotalScored, OKCount, WarningCount, ErrorCount, NotCheckedCount,
    Percent: Integer;
  Level: TFLXAuditLevel;
  function StateLevel(const AState: string): TFLXAuditLevel;
  begin
    if AState = 'ERROR' then Result := alError
    else if AState = 'AVISO' then Result := alWarning
    else if AState = 'CORRECTO' then Result := alOK
    else Result := alNotChecked;
  end;
begin
  Engine := nil;
  Report := nil;
  SchemaAudit := nil;
  if AFull then
    AuditTitle := 'Auditoría completa del sistema'
  else
    AuditTitle := 'Auditoría rápida del sistema';
  OpenWorkProgress(AuditTitle);
  try
    try
      SchemaProgress(5, 'Preparando comprobaciones del sistema...');
      IniName := IncludeTrailingPathDelimiter(RutaIni) + 'FacturConf.ini';
      Engine := TFLXAuditEngine.Create(FConnection, IniName, vfMode, vfUrl, vfUrlTP);
      SchemaProgress(15, 'Comprobando base de datos, VeriFactu, instalación y documentación...');
      Report := Engine.Execute;
      if AFull then
      begin
        SchemaProgress(55, 'Revisando la estructura completa de la base de datos...');
        SchemaAudit := TFLXSchemaAudit.Create(FConnection, Report);
        try
          SchemaAudit.Run;
        finally
          FreeAndNil(SchemaAudit);
        end;
      end;
      SchemaProgress(85, 'Procesando los resultados de la auditoría...');

      OKCount := Report.CountByLevel(alOK);
      WarningCount := Report.CountByLevel(alWarning);
      ErrorCount := Report.CountByLevel(alError);
      NotCheckedCount := Report.CountByLevel(alNotChecked);
      TotalScored := OKCount + WarningCount + ErrorCount + NotCheckedCount;
      if TotalScored > 0 then
        Percent := Round((OKCount * 100.0) / TotalScored)
      else
        Percent := 0;
      if Percent < 0 then Percent := 0;
      if Percent > 100 then Percent := 100;

      Progress.Position := Percent;
      LbProgress.Caption := 'Nivel de preparación interna: ' + IntToStr(Percent) + ' %';
      LbOK.Caption := 'Correctas: ' + IntToStr(OKCount);
      LbWarnings.Caption := 'Avisos: ' + IntToStr(WarningCount);
      LbErrors.Caption := 'Errores: ' + IntToStr(ErrorCount);
      LbNotChecked.Caption := 'No comprobadas: ' + IntToStr(NotCheckedCount);

      Level := Report.OverallLevel;
      case Level of
        alError:
          begin
            LbTraffic.Caption := 'NO CERTIFICABLE';
            LbTraffic.Color := RGBToColor(170, 35, 35);
          end;
        alWarning, alNotChecked:
          begin
            LbTraffic.Caption := 'REVISAR';
            LbTraffic.Color := RGBToColor(190, 120, 0);
          end;
      else
        begin
          LbTraffic.Caption := 'PREPARADO INTERNAMENTE';
          LbTraffic.Color := RGBToColor(20, 125, 60);
        end;
      end;

      S := CategoryState(Report, 'BASE DE DATOS');
      SetStatusLabel(LbDatabase, 'Base de datos: ' + S, StateLevel(S));
      S := CategoryState(Report, 'VERIFACTU');
      SetStatusLabel(LbVeriFactu, 'VeriFactu y cola: ' + S, StateLevel(S));
      S := CategoryState(Report, 'CERTIFICADOS');
      SetStatusLabel(LbCertificates, 'Certificados y OpenSSL: ' + S, StateLevel(S));
      S := CategoryState(Report, 'CONFIGURACION');
      SetStatusLabel(LbConfiguration, 'Configuración: ' + S, StateLevel(S));
      S := CategoryState(Report, 'INSTALACION');
      SetStatusLabel(LbInstallation, 'Instalación y dependencias: ' + S, StateLevel(S));
      S := CategoryState(Report, 'DOCUMENTACION');
      SetStatusLabel(LbDocumentation, 'Documentación: ' + S, StateLevel(S));
      SetStatusLabel(LbDeclaration,
        'Declaración responsable: EN PREPARACIÓN', alWarning);

      LbLastRun.Caption := 'Última auditoría: ' +
        FormatDateTime('dd/mm/yyyy hh:nn:ss', Report.FinishedAt) + LineEnding +
        'Comprobaciones ejecutadas: ' + IntToStr(Report.Count);
      FCurrentPercent := Percent;
      FCurrentState := LbTraffic.Caption;
      FLastReportText :=
        'FACTURLINEX - INFORME INTERNO DE AUDITORÍA' + LineEnding +
        '================================================' + LineEnding +
        'Tipo: ' + AuditTitle + LineEnding +
        'Fecha: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Report.FinishedAt) + LineEnding +
        'Estado mostrado: ' + LbTraffic.Caption + LineEnding +
        'Preparación interna: ' + IntToStr(Percent) + ' %' + LineEnding +
        'Correctas: ' + IntToStr(OKCount) + LineEnding +
        'Avisos: ' + IntToStr(WarningCount) + LineEnding +
        'Errores: ' + IntToStr(ErrorCount) + LineEnding +
        'No comprobadas: ' + IntToStr(NotCheckedCount) + LineEnding +
        LineEnding + Report.ToText;
      MemoResults.Lines.Text := FLastReportText;
      BtnSave.Enabled := True;
      SchemaProgress(100, 'Auditoría terminada correctamente.');
      { Report pertenece a Engine. No debe liberarse aquí. }
      Report := nil;
    except
      on E: Exception do
      begin
        LbTraffic.Caption := 'ERROR DE AUDITORÍA';
        LbTraffic.Color := RGBToColor(170, 35, 35);
        FCurrentPercent := 0;
        FCurrentState := 'ERROR DE AUDITORÍA';
        FLastReportText := '';
        BtnSave.Enabled := False;
        MemoResults.Lines.Text := 'No se ha podido ejecutar la auditoría:' +
          LineEnding + E.Message;
      end;
    end;
  finally
    Report := nil;
    FreeAndNil(Engine);
    CloseWorkProgress;
  end;
end;

procedure TfrmFLXCentroSalud.BtnRunClick(Sender: TObject);
begin
  RunAudit(True);
end;


procedure TfrmFLXCentroSalud.BtnSaveClick(Sender: TObject);
var
  Dlg: TSaveDialog;
  OutputName: string;
  Lines: TStringList;
begin
  if Trim(FLastReportText) = '' then
  begin
    MessageDlg('Guardar informe',
      'Primero debe ejecutarse correctamente la auditoría.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  Dlg := TSaveDialog.Create(Self);
  try
    try
      Dlg.Title := 'Guardar informe de auditoría';
      Dlg.Filter := 'Informe de texto (*.txt)|*.txt|Todos los archivos|*.*';
      Dlg.DefaultExt := 'txt';
      Dlg.FileName := 'AUDITORIA_FACTURLINEX_' +
        FormatDateTime('yyyymmdd_hhnnss', Now) + '.txt';
      if not Dlg.Execute then Exit;

      OutputName := Dlg.FileName;
      if ExtractFileExt(OutputName) = '' then
        OutputName := OutputName + '.txt';

      Lines := TStringList.Create;
      try
        Lines.Text := FLastReportText;
        Lines.SaveToFile(OutputName);
      finally
        Lines.Free;
      end;

      AppendHistoryEntry(OutputName);
      MessageDlg('Informe guardado',
        'El informe se ha guardado correctamente en:' + LineEnding +
        OutputName, mtInformation, [mbOK], 0);
    except
      on E: Exception do
        MessageDlg('No se ha podido guardar el informe', E.Message,
          mtError, [mbOK], 0);
    end;
  finally
    Dlg.Free;
  end;
end;


function TfrmFLXCentroSalud.HistoryFileName: string;
var
  DirName: string;
begin
  DirName := ExcludeTrailingPathDelimiter(GetAppConfigDir(False));
  if not DirectoryExists(DirName) then
    ForceDirectories(DirName);
  Result := IncludeTrailingPathDelimiter(DirName) +
    'historial_auditorias.log';
end;

procedure TfrmFLXCentroSalud.AppendHistoryEntry(const AReportFile: string);
var
  Lines: TStringList;
  FileName: string;
begin
  FileName := HistoryFileName;
  Lines := TStringList.Create;
  try
    if FileExists(FileName) then
      Lines.LoadFromFile(FileName);
    Lines.Add(FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + ' | ' +
      LbTraffic.Caption + ' | ' + LbProgress.Caption + ' | ' + AReportFile);
    Lines.SaveToFile(FileName);
  finally
    Lines.Free;
  end;
end;

procedure TfrmFLXCentroSalud.BtnHistoryClick(Sender: TObject);
var
  F: TForm;
  M: TMemo;
  B: TBitBtn;
  FileName: string;
begin
  FileName := HistoryFileName;
  F := TForm.CreateNew(Self, 1);
  try
    F.Caption := 'Historial de auditorías guardadas';
    F.Position := poScreenCenter;
    F.Width := 1050;
    F.Height := 650;
    F.Color := clWhite;
    F.KeyPreview := True;

    M := TMemo.Create(F);
    M.Parent := F;
    M.Align := alClient;
    M.ReadOnly := True;
    M.ScrollBars := ssAutoBoth;
    M.WordWrap := False;
    M.Font.Name := 'Monospace';
    M.Font.Height := -12;
    if FileExists(FileName) then
      M.Lines.LoadFromFile(FileName)
    else
      M.Lines.Text := 'Todavía no se ha guardado ningún informe de auditoría.';

    B := TBitBtn.Create(F);
    B.Parent := F;
    B.Align := alBottom;
    B.Height := 42;
    B.Caption := 'Cerrar';
    B.Cancel := True;
    B.ModalResult := mrCancel;

    F.ShowModal;
  finally
    F.Free;
  end;
end;


procedure TfrmFLXCentroSalud.BtnCompareClick(Sender: TObject);
var
  Lines, Parts: TStringList;
  FileName, LastLine, PreviousState, PreviousProgress, MessageText: string;
  PreviousPercent, Difference, P1, P2: Integer;
begin
  if Trim(FLastReportText) = '' then
  begin
    MessageDlg('Comparar auditorías',
      'Primero debe ejecutarse correctamente la auditoría actual.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  FileName := HistoryFileName;
  if not FileExists(FileName) then
  begin
    MessageDlg('Comparar auditorías',
      'Todavía no existe ninguna auditoría guardada para utilizar como referencia.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  Lines := TStringList.Create;
  Parts := TStringList.Create;
  try
    Lines.LoadFromFile(FileName);
    if Lines.Count = 0 then
    begin
      MessageDlg('Comparar auditorías',
        'El historial de auditorías está vacío.', mtInformation, [mbOK], 0);
      Exit;
    end;

    LastLine := Lines[Lines.Count - 1];
    Parts.StrictDelimiter := True;
    Parts.Delimiter := '|';
    Parts.DelimitedText := LastLine;
    if Parts.Count < 4 then
    begin
      MessageDlg('Comparar auditorías',
        'La última entrada del historial no tiene un formato reconocible.',
        mtError, [mbOK], 0);
      Exit;
    end;

    PreviousState := Trim(Parts[1]);
    PreviousProgress := Trim(Parts[2]);
    PreviousPercent := 0;
    P1 := Pos(':', PreviousProgress);
    P2 := Pos('%', PreviousProgress);
    if (P1 > 0) and (P2 > P1) then
      PreviousPercent := StrToIntDef(Trim(Copy(PreviousProgress, P1 + 1,
        P2 - P1 - 1)), 0);

    Difference := FCurrentPercent - PreviousPercent;
    MessageText :=
      'AUDITORÍA ANTERIOR' + LineEnding +
      'Estado: ' + PreviousState + LineEnding +
      'Preparación: ' + IntToStr(PreviousPercent) + ' %' + LineEnding +
      LineEnding +
      'AUDITORÍA ACTUAL' + LineEnding +
      'Estado: ' + FCurrentState + LineEnding +
      'Preparación: ' + IntToStr(FCurrentPercent) + ' %' + LineEnding +
      LineEnding;

    if Difference > 0 then
      MessageText := MessageText + 'Resultado: MEJORA de ' +
        IntToStr(Difference) + ' puntos porcentuales.'
    else if Difference < 0 then
      MessageText := MessageText + 'Resultado: EMPEORA ' +
        IntToStr(Abs(Difference)) + ' puntos porcentuales.'
    else
      MessageText := MessageText + 'Resultado: SIN CAMBIOS en el porcentaje.';

    if not SameText(PreviousState, FCurrentState) then
      MessageText := MessageText + LineEnding +
        'El estado general ha cambiado de "' + PreviousState + '" a "' +
        FCurrentState + '".'
    else
      MessageText := MessageText + LineEnding +
        'El estado general permanece en "' + FCurrentState + '".';

    MessageDlg('Comparación de auditorías', MessageText,
      mtInformation, [mbOK], 0);
  finally
    Parts.Free;
    Lines.Free;
  end;
end;


procedure TfrmFLXCentroSalud.BtnMilestonesClick(Sender: TObject);
var
  F: TForm;
  PTop, PBody, PBottom: TPanel;
  LTitle, LPercent, LNote: TLabel;
  Bar: TProgressBar;
  M: TMemo;
  B: TBitBtn;
  MilestonePercent: Integer;
begin
  { Hitos cerrados actualmente:
      A - Motor de auditoría integrado
      B - Centro de Salud inicial operativo
    Los hitos C, D y E permanecen pendientes. }
  MilestonePercent := 40;

  F := TForm.CreateNew(Self, 1);
  try
    F.Caption := 'Preparación de FacturLinEx 4.2.6';
    F.Position := poScreenCenter;
    F.Width := 900;
    F.Height := 650;
    F.Color := clWhite;
    F.KeyPreview := True;

    PTop := TPanel.Create(F);
    PTop.Parent := F;
    PTop.Align := alTop;
    PTop.Height := 120;
    PTop.BevelOuter := bvNone;
    PTop.Color := RGBToColor(26, 62, 105);

    LTitle := TLabel.Create(F);
    LTitle.Parent := PTop;
    LTitle.SetBounds(24, 14, 820, 34);
    LTitle.Caption := 'PREPARACIÓN PARA FACTURLINEX 4.2.6J / 4.2.6X';
    LTitle.ParentFont := False;
    LTitle.Font.Height := -19;
    LTitle.Font.Style := [fsBold];
    LTitle.Font.Color := clWhite;

    LPercent := TLabel.Create(F);
    LPercent.Parent := PTop;
    LPercent.SetBounds(24, 57, 430, 26);
    LPercent.Caption := 'Avance de hitos del proyecto: ' +
      IntToStr(MilestonePercent) + ' %';
    LPercent.ParentFont := False;
    LPercent.Font.Height := -13;
    LPercent.Font.Style := [fsBold];
    LPercent.Font.Color := clWhite;

    Bar := TProgressBar.Create(F);
    Bar.Parent := PTop;
    Bar.SetBounds(470, 57, 390, 26);
    Bar.Min := 0;
    Bar.Max := 100;
    Bar.Position := MilestonePercent;

    PBody := TPanel.Create(F);
    PBody.Parent := F;
    PBody.Align := alClient;
    PBody.BevelOuter := bvNone;
    PBody.Color := clWhite;

    M := TMemo.Create(F);
    M.Parent := PBody;
    M.Align := alClient;
    M.BorderSpacing.Around := 18;
    M.ReadOnly := True;
    M.ScrollBars := ssAutoVertical;
    M.WordWrap := True;
    M.Font.Name := 'Sans';
    M.Font.Height := -13;
    M.Lines.Add('HITO A - MOTOR DE AUDITORÍA OPERATIVO');
    M.Lines.Add('  [COMPLETADO] Motor común conectado al Centro de Control.');
    M.Lines.Add('  [COMPLETADO] Auditoría de base de datos, configuración, certificados y OpenSSL.');
    M.Lines.Add('');
    M.Lines.Add('HITO B - CENTRO DE SALUD DEL SISTEMA');
    M.Lines.Add('  [COMPLETADO INICIAL] Semáforo, métricas, informe, historial y comparación.');
    M.Lines.Add('  [EN EVOLUCIÓN] Ampliación de comprobaciones y presentación.');
    M.Lines.Add('');
    M.Lines.Add('HITO C - INSTALADOR PROFESIONAL');
    M.Lines.Add('  [PENDIENTE] Dependencias, MariaDB, carpetas, permisos, sudoers y datos iniciales.');
    M.Lines.Add('');
    M.Lines.Add('HITO D - DOCUMENTACIÓN TÉCNICA Y MANUALES');
    M.Lines.Add('  [PENDIENTE] Manual VeriFactu, manual técnico, libro maestro y versión web.');
    M.Lines.Add('');
    M.Lines.Add('HITO E - AUDITORÍA FINAL Y DECLARACIÓN RESPONSABLE');
    M.Lines.Add('  [PENDIENTE] Regresión completa, evidencias, declaraciones J/X y congelación 4.2.6.');
    M.Lines.Add('');
    M.Lines.Add('SALUD TÉCNICA ACTUAL');
    M.Lines.Add('  Auditoría interna del sistema: ' + IntToStr(FCurrentPercent) + ' %');
    M.Lines.Add('  Estado actual: ' + FCurrentState);
    M.Lines.Add('');
    M.Lines.Add('IMPORTANTE');
    M.Lines.Add('El avance de hitos mide el trabajo del proyecto. La salud técnica mide el resultado');
    M.Lines.Add('de las comprobaciones de esta instalación. Ninguno de los dos porcentajes equivale');
    M.Lines.Add('por sí solo a una declaración responsable firmada.');

    PBottom := TPanel.Create(F);
    PBottom.Parent := F;
    PBottom.Align := alBottom;
    PBottom.Height := 58;
    PBottom.BevelOuter := bvNone;
    PBottom.Color := RGBToColor(238, 243, 248);

    LNote := TLabel.Create(F);
    LNote.Parent := PBottom;
    LNote.SetBounds(18, 18, 650, 22);
    LNote.Caption := 'Próximo hito previsto: Instalador profesional y auditoría de instalación.';
    LNote.Font.Color := RGBToColor(60, 80, 105);

    B := TBitBtn.Create(F);
    B.Parent := PBottom;
    B.SetBounds(PBottom.Width - 130, 10, 110, 38);
    B.Anchors := [akTop, akRight];
    B.Caption := 'Cerrar';
    B.Cancel := True;
    B.ModalResult := mrCancel;

    F.ShowModal;
  finally
    F.Free;
  end;
end;


procedure TfrmFLXCentroSalud.BtnUpdateReadyClick(Sender: TObject);
const
  MinFreeBytes: Int64 = 1024 * 1024 * 1024; { 1 GiB }
var
  Msg: TStringList;
  Ready, HasWarning: Boolean;
  FreeBytes: Int64;
  ConfigDir, BackupDir, SearchDir, SRName: string;
  SR: TSearchRec;
  LatestBackup: TDateTime;
  AgeDays: Integer;

  procedure CheckBackupDir(const ADir: string);
  var
    R: TSearchRec;
    D: TDateTime;
  begin
    if not DirectoryExists(ADir) then Exit;
    if FindFirst(IncludeTrailingPathDelimiter(ADir) + '*', faAnyFile, R) = 0 then
    try
      repeat
        if (R.Name = '.') or (R.Name = '..') or ((R.Attr and faDirectory) <> 0) then
          Continue;
        D := FileDateToDateTime(R.Time);
        if D > LatestBackup then LatestBackup := D;
      until FindNext(R) <> 0;
    finally
      FindClose(R);
    end;
  end;

begin
  Msg := TStringList.Create;
  try
    Ready := True;
    HasWarning := False;
    Msg.Add('COMPROBACIÓN PREVIA A UNA ACTUALIZACIÓN');
    Msg.Add('=======================================');
    Msg.Add('');

    if FCurrentState = 'ERROR DE AUDITORÍA' then
    begin
      Msg.Add('[ERROR] La auditoría general no ha podido completarse.');
      Ready := False;
    end
    else if Pos('NO CERTIFICABLE', FCurrentState) > 0 then
    begin
      Msg.Add('[ERROR] Existen errores críticos en la auditoría actual.');
      Ready := False;
    end
    else if Pos('REVISAR', FCurrentState) > 0 then
    begin
      Msg.Add('[AVISO] La auditoría contiene avisos o controles pendientes.');
      HasWarning := True;
    end
    else
      Msg.Add('[OK] La auditoría general no muestra errores críticos.');

    if (FConnection <> nil) and FConnection.Connected then
      Msg.Add('[OK] Conexión con la base de datos activa.')
    else
    begin
      Msg.Add('[ERROR] No existe conexión activa con la base de datos.');
      Ready := False;
    end;

    FreeBytes := DiskFree(0);
    if FreeBytes < 0 then
    begin
      Msg.Add('[AVISO] No se ha podido calcular el espacio libre en disco.');
      HasWarning := True;
    end
    else if FreeBytes < MinFreeBytes then
    begin
      Msg.Add('[ERROR] Hay menos de 1 GiB libre en la unidad del sistema.');
      Ready := False;
    end
    else
      Msg.Add('[OK] Espacio libre suficiente: ' +
        FormatFloat('0.00', FreeBytes / 1024 / 1024 / 1024) + ' GiB.');

    LatestBackup := 0;
    ConfigDir := ExcludeTrailingPathDelimiter(GetAppConfigDir(False));
    SearchDir := ExtractFilePath(ExpandFileName(ParamStr(0)));
    CheckBackupDir(IncludeTrailingPathDelimiter(ConfigDir) + 'backup');
    CheckBackupDir(IncludeTrailingPathDelimiter(ConfigDir) + 'backups');
    CheckBackupDir(IncludeTrailingPathDelimiter(SearchDir) + 'backup');
    CheckBackupDir(IncludeTrailingPathDelimiter(SearchDir) + 'backups');
    CheckBackupDir(IncludeTrailingPathDelimiter(SearchDir) + 'Copias');

    if LatestBackup = 0 then
    begin
      Msg.Add('[AVISO] No se ha localizado una copia de seguridad reciente en las rutas habituales.');
      Msg.Add('        Antes de actualizar, realice y verifique una copia completa.');
      HasWarning := True;
    end
    else
    begin
      AgeDays := Trunc(Now - LatestBackup);
      if AgeDays > 7 then
      begin
        Msg.Add('[AVISO] La última copia localizada tiene ' + IntToStr(AgeDays) + ' días.');
        HasWarning := True;
      end
      else
        Msg.Add('[OK] Copia de seguridad localizada de hace ' + IntToStr(AgeDays) + ' día(s).');
      Msg.Add('     Fecha: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', LatestBackup));
    end;

    Msg.Add('');
    if not Ready then
      Msg.Add('RESULTADO: NO PREPARADO PARA ACTUALIZAR.')
    else if HasWarning then
      Msg.Add('RESULTADO: PREPARADO CON AVISOS. Revise los puntos indicados.')
    else
      Msg.Add('RESULTADO: SISTEMA PREPARADO PARA ACTUALIZAR FACTURLINEX.');

    Msg.Add('');
    Msg.Add('Esta comprobación no instala ni modifica nada. Antes de aplicar una versión,');
    Msg.Add('conserve una copia de la base de datos, configuración y versión ejecutable actual.');

    MessageDlg('Preparación para actualizar', Msg.Text,
      mtInformation, [mbOK], 0);
  finally
    Msg.Free;
  end;
end;


procedure TfrmFLXCentroSalud.OpenWorkProgress(const ATitle: string);
begin
  FreeAndNil(FTaskProgress);
  FTaskProgress := TFLXTaskProgress.Create(Self, ATitle);
end;

procedure TfrmFLXCentroSalud.SchemaProgress(APercent: Integer;
  const AMessage: string);
begin
  if Assigned(FTaskProgress) then
    FTaskProgress.Update(APercent, AMessage);
end;

procedure TfrmFLXCentroSalud.CloseWorkProgress;
begin
  FreeAndNil(FTaskProgress);
end;

procedure TfrmFLXCentroSalud.BtnSchemaClick(Sender: TObject);
var
  Dlg: TSaveDialog;
  Audit: TFLXSchemaAudit;
  OutputName: string;
begin
  Dlg := TSaveDialog.Create(Self);
  try
    Dlg.Title := 'Exportar inventario completo de la base de datos';
    Dlg.Filter := 'Informe de texto (*.txt)|*.txt|Todos los archivos|*.*';
    Dlg.DefaultExt := 'txt';
    Dlg.FileName := 'ESQUEMA_BBDD_' +
      FormatDateTime('yyyymmdd_hhnnss', Now) + '.txt';
    if not Dlg.Execute then Exit;

    OutputName := Dlg.FileName;
    if ExtractFileExt(OutputName) = '' then
      OutputName := OutputName + '.txt';

    OpenWorkProgress('Exportando esquema de la base de datos');
    try
      Audit := TFLXSchemaAudit.Create(FConnection, nil);
      try
        Audit.OnProgress := @SchemaProgress;
        Audit.ExportInventory(OutputName);
      finally
        Audit.Free;
      end;
    finally
      CloseWorkProgress;
    end;

    MessageDlg('Esquema exportado',
      'El inventario completo se ha guardado correctamente en:' +
      LineEnding + OutputName, mtInformation, [mbOK], 0);
  except
    on E: Exception do
    begin
      CloseWorkProgress;
      MessageDlg('No se ha podido exportar el esquema', E.Message,
        mtError, [mbOK], 0);
    end;
  end;
  Dlg.Free;
end;

procedure TfrmFLXCentroSalud.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFLXCentroSalud.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

end.
