unit uFLXToolsMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, Process, LCLType;

type
  TfrmFLXTools = class(TForm)
  private
    pnlHeader, pnlStatus, pnlActions, pnlFooter: TPanel;
    lblTitle, lblSubtitle, lblState, lblPaths: TLabel;
    memoEvents: TMemo;
    btnFacturLinEx, btnCentroSalud, btnInstaller, btnMaintenance,
      btnDocumentation, btnDiagnosis, btnRefresh, btnClose: TBitBtn;
    FRootDir, FMainBinary, FInstallerBinary, FMaintenanceBinary, FDocsDir: string;

    procedure BuildUI;
    procedure DetectPaths;
    procedure RefreshState;
    procedure AddEvent(const AText: string);
    function RunExecutable(const AFileName: string;
      const AParameters: array of string): Boolean;
    function OpenPath(const APath: string): Boolean;
    function FindFirstExisting(const ACandidates: array of string): string;

    procedure FacturLinExClick(Sender: TObject);
    procedure CentroSaludClick(Sender: TObject);
    procedure InstallerClick(Sender: TObject);
    procedure MaintenanceClick(Sender: TObject);
    procedure DocumentationClick(Sender: TObject);
    procedure DiagnosisClick(Sender: TObject);
    procedure RefreshClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure FormKeyDownHandler(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public
    constructor Create(TheOwner: TComponent); override;
  end;

var
  frmFLXTools: TfrmFLXTools;

implementation

function ExecutableInPath(const AName: string): string;
var
  P, Candidate: string;
  L: TStringList;
  I: Integer;
begin
  Result := '';
  P := GetEnvironmentVariable('PATH');
  L := TStringList.Create;
  try
    L.StrictDelimiter := True;
    L.Delimiter := PathSeparator;
    L.DelimitedText := P;
    for I := 0 to L.Count - 1 do
    begin
      if L[I] = '' then Continue;
      Candidate := IncludeTrailingPathDelimiter(L[I]) + AName;
      if FileExists(Candidate) then Exit(Candidate);
    end;
  finally
    L.Free;
  end;
end;

constructor TfrmFLXTools.Create(TheOwner: TComponent);
begin
  inherited CreateNew(TheOwner, 1);
  Caption := 'FacturLinEx Tools';
  Width := 1020;
  Height := 730;
  Position := poScreenCenter;
  Constraints.MinWidth := 900;
  Constraints.MinHeight := 640;
  Color := RGBToColor(242, 246, 250);
  KeyPreview := True;
  OnKeyDown := @FormKeyDownHandler;

  DetectPaths;
  BuildUI;
  RefreshState;
end;

procedure TfrmFLXTools.BuildUI;

  function AddActionButton(const ACaption: string; ATop: Integer;
    AHandler: TNotifyEvent): TBitBtn;
  begin
    Result := TBitBtn.Create(Self);
    Result.Parent := pnlActions;
    Result.Left := 28;
    Result.Top := ATop;
    Result.Width := 270;
    Result.Height := 50;
    Result.Caption := ACaption;
    Result.Font.Size := 11;
    Result.Font.Style := [fsBold];
    Result.OnClick := AHandler;
  end;

var
  L: TLabel;
begin
  pnlHeader := TPanel.Create(Self);
  pnlHeader.Parent := Self;
  pnlHeader.Align := alTop;
  pnlHeader.Height := 112;
  pnlHeader.BevelOuter := bvNone;
  pnlHeader.Color := RGBToColor(32, 82, 132);
  pnlHeader.Caption := '';

  lblTitle := TLabel.Create(Self);
  lblTitle.Parent := pnlHeader;
  lblTitle.Left := 30;
  lblTitle.Top := 18;
  lblTitle.Caption := 'FACTURLINEX TOOLS';
  lblTitle.Font.Size := 24;
  lblTitle.Font.Style := [fsBold];
  lblTitle.Font.Color := clWhite;

  lblSubtitle := TLabel.Create(Self);
  lblSubtitle.Parent := pnlHeader;
  lblSubtitle.Left := 32;
  lblSubtitle.Top := 66;
  lblSubtitle.Caption := 'Centro de operaciones, instalación, mantenimiento y diagnóstico';
  lblSubtitle.Font.Size := 12;
  lblSubtitle.Font.Color := RGBToColor(218, 234, 248);

  pnlFooter := TPanel.Create(Self);
  pnlFooter.Parent := Self;
  pnlFooter.Align := alBottom;
  pnlFooter.Height := 60;
  pnlFooter.BevelOuter := bvNone;
  pnlFooter.Color := RGBToColor(226, 234, 242);
  pnlFooter.Caption := '';

  btnClose := TBitBtn.Create(Self);
  btnClose.Parent := pnlFooter;
  btnClose.Caption := 'Cerrar';
  btnClose.Width := 110;
  btnClose.Height := 36;
  btnClose.Left := pnlFooter.Width - 132;
  btnClose.Top := 12;
  btnClose.Anchors := [akTop, akRight];
  btnClose.OnClick := @CloseClick;

  btnRefresh := TBitBtn.Create(Self);
  btnRefresh.Parent := pnlFooter;
  btnRefresh.Caption := 'Actualizar estado';
  btnRefresh.Width := 150;
  btnRefresh.Height := 36;
  btnRefresh.Left := btnClose.Left - 162;
  btnRefresh.Top := 12;
  btnRefresh.Anchors := [akTop, akRight];
  btnRefresh.OnClick := @RefreshClick;

  pnlActions := TPanel.Create(Self);
  pnlActions.Parent := Self;
  pnlActions.Align := alLeft;
  pnlActions.Width := 330;
  pnlActions.BevelOuter := bvNone;
  pnlActions.Color := RGBToColor(232, 240, 247);
  pnlActions.Caption := '';

  L := TLabel.Create(Self);
  L.Parent := pnlActions;
  L.Left := 28;
  L.Top := 20;
  L.Caption := 'Acciones principales';
  L.Font.Size := 15;
  L.Font.Style := [fsBold];

  btnFacturLinEx := AddActionButton('Abrir FacturLinEx', 62, @FacturLinExClick);
  btnCentroSalud := AddActionButton('Centro de Salud', 122, @CentroSaludClick);
  btnMaintenance := AddActionButton('Centro de Mantenimiento', 182, @MaintenanceClick);
  btnInstaller := AddActionButton('Instalador gráfico', 242, @InstallerClick);
  btnDocumentation := AddActionButton('Abrir documentación', 302, @DocumentationClick);
  btnDiagnosis := AddActionButton('Generar diagnóstico', 362, @DiagnosisClick);

  pnlStatus := TPanel.Create(Self);
  pnlStatus.Parent := Self;
  pnlStatus.Align := alClient;
  pnlStatus.BevelOuter := bvNone;
  pnlStatus.Color := Color;
  pnlStatus.Caption := '';

  L := TLabel.Create(Self);
  L.Parent := pnlStatus;
  L.Left := 32;
  L.Top := 24;
  L.Caption := 'Estado del ecosistema';
  L.Font.Size := 18;
  L.Font.Style := [fsBold];

  lblState := TLabel.Create(Self);
  lblState.Parent := pnlStatus;
  lblState.Left := 34;
  lblState.Top := 72;
  lblState.AutoSize := False;
  lblState.Width := 620;
  lblState.Height := 145;
  lblState.WordWrap := True;
  lblState.Font.Size := 12;

  lblPaths := TLabel.Create(Self);
  lblPaths.Parent := pnlStatus;
  lblPaths.Left := 34;
  lblPaths.Top := 218;
  lblPaths.AutoSize := False;
  lblPaths.Width := 620;
  lblPaths.Height := 125;
  lblPaths.WordWrap := True;
  lblPaths.Font.Size := 9;

  L := TLabel.Create(Self);
  L.Parent := pnlStatus;
  L.Left := 32;
  L.Top := 350;
  L.Caption := 'Últimos eventos';
  L.Font.Size := 14;
  L.Font.Style := [fsBold];

  memoEvents := TMemo.Create(Self);
  memoEvents.Parent := pnlStatus;
  memoEvents.Left := 32;
  memoEvents.Top := 384;
  memoEvents.Width := 620;
  memoEvents.Height := 185;
  memoEvents.Anchors := [akLeft, akTop, akRight, akBottom];
  memoEvents.ReadOnly := True;
  memoEvents.ScrollBars := ssAutoVertical;
  memoEvents.Color := clWhite;
end;

procedure TfrmFLXTools.DetectPaths;
var
  AppDir: string;
begin
  AppDir := ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  FRootDir := ExpandFileName(AppDir + PathDelim + '..');

  FMainBinary := FindFirstExisting([
    '/usr/bin/FacturLinEx',
    IncludeTrailingPathDelimiter(FRootDir) + 'Bin/FacturLinEx'
  ]);

  FInstallerBinary := FindFirstExisting([
    '/usr/bin/FLXInstaller',
    IncludeTrailingPathDelimiter(FRootDir) + 'Bin/FLXInstaller'
  ]);

  FMaintenanceBinary := FindFirstExisting([
    '/usr/bin/FLXMantenimiento',
    IncludeTrailingPathDelimiter(FRootDir) + 'Bin/FLXMantenimiento'
  ]);

  FDocsDir := FindFirstExisting([
    '/usr/share/facturlinex2/Documentacion',
    '/usr/share/doc/facturlinex2',
    IncludeTrailingPathDelimiter(FRootDir) + 'Documentacion',
    IncludeTrailingPathDelimiter(FRootDir) + 'Documents'
  ]);
end;

function TfrmFLXTools.FindFirstExisting(const ACandidates: array of string): string;
var
  S: string;
begin
  Result := '';
  for S in ACandidates do
    if FileExists(S) or DirectoryExists(S) then Exit(ExpandFileName(S));
end;

procedure TfrmFLXTools.RefreshState;
var
  MainOK, InstallerOK, MaintOK, DocsOK, OpenSSLOK: Boolean;
begin
  DetectPaths;
  MainOK := FileExists(FMainBinary);
  InstallerOK := FileExists(FInstallerBinary);
  MaintOK := FileExists(FMaintenanceBinary);
  DocsOK := DirectoryExists(FDocsDir);
  OpenSSLOK := ExecutableInPath('openssl') <> '';

  lblState.Caption :=
    'FacturLinEx: ' + IfThen(MainOK, 'CORRECTO', 'NO LOCALIZADO') + LineEnding +
    'Centro de Mantenimiento: ' + IfThen(MaintOK, 'CORRECTO', 'NO LOCALIZADO') + LineEnding +
    'Instalador gráfico: ' + IfThen(InstallerOK, 'CORRECTO', 'NO LOCALIZADO') + LineEnding +
    'Documentación: ' + IfThen(DocsOK, 'CORRECTO', 'NO LOCALIZADA') + LineEnding +
    'OpenSSL: ' + IfThen(OpenSSLOK, 'CORRECTO', 'NO LOCALIZADO');

  lblPaths.Caption :=
    'Raíz: ' + FRootDir + LineEnding +
    'FacturLinEx: ' + IfThen(FMainBinary <> '', FMainBinary, '(no localizado)') + LineEnding +
    'Mantenimiento: ' + IfThen(FMaintenanceBinary <> '', FMaintenanceBinary, '(no localizado)') + LineEnding +
    'Instalador: ' + IfThen(FInstallerBinary <> '', FInstallerBinary, '(no localizado)') + LineEnding +
    'Documentación: ' + IfThen(FDocsDir <> '', FDocsDir, '(no localizada)');

  btnFacturLinEx.Enabled := MainOK;
  btnCentroSalud.Enabled := MainOK;
  btnMaintenance.Enabled := MaintOK;
  btnInstaller.Enabled := InstallerOK;
  btnDocumentation.Enabled := DocsOK;

  AddEvent('Estado del ecosistema actualizado.');
end;

procedure TfrmFLXTools.AddEvent(const AText: string);
begin
  if Assigned(memoEvents) then
    memoEvents.Lines.Insert(0,
      FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + '  ' + AText);
end;

function TfrmFLXTools.RunExecutable(const AFileName: string;
  const AParameters: array of string): Boolean;
var
  P: TProcess;
  S: string;
begin
  Result := False;
  if not FileExists(AFileName) then Exit;
  P := TProcess.Create(nil);
  try
    P.Executable := AFileName;
    for S in AParameters do P.Parameters.Add(S);
    P.ShowWindow := swoShowNormal;
    try
      P.Execute;
      Result := True;
      AddEvent('Ejecutado: ' + AFileName);
    except
      on E: Exception do
      begin
        MessageDlg('No se pudo ejecutar:' + LineEnding + AFileName +
          LineEnding + E.Message, mtError, [mbOK], 0);
        AddEvent('Error: ' + E.Message);
      end;
    end;
  finally
    P.Free;
  end;
end;

function TfrmFLXTools.OpenPath(const APath: string): Boolean;
var
  Opener: string;
begin
  Result := False;
  if not (FileExists(APath) or DirectoryExists(APath)) then Exit;
  Opener := ExecutableInPath('xdg-open');
  if Opener <> '' then
    Exit(RunExecutable(Opener, [APath]));
  Opener := ExecutableInPath('gio');
  if Opener <> '' then
    Exit(RunExecutable(Opener, ['open', APath]));
end;

procedure TfrmFLXTools.FacturLinExClick(Sender: TObject);
begin
  RunExecutable(FMainBinary, []);
end;

procedure TfrmFLXTools.CentroSaludClick(Sender: TObject);
begin
  MessageDlg('El Centro de Salud sigue integrado en FacturLinEx.' + LineEnding +
    'Se abrirá la aplicación principal.', mtInformation, [mbOK], 0);
  RunExecutable(FMainBinary, []);
end;

procedure TfrmFLXTools.MaintenanceClick(Sender: TObject);
begin
  RunExecutable(FMaintenanceBinary, []);
end;

procedure TfrmFLXTools.InstallerClick(Sender: TObject);
begin
  RunExecutable(FInstallerBinary, []);
end;

procedure TfrmFLXTools.DocumentationClick(Sender: TObject);
begin
  if OpenPath(FDocsDir) then AddEvent('Documentación abierta.');
end;

procedure TfrmFLXTools.DiagnosisClick(Sender: TObject);
var
  D, N: string;
  L: TStringList;
begin
  D := GetAppConfigDir(False);
  ForceDirectories(D);
  N := IncludeTrailingPathDelimiter(D) + 'Diagnostico_FLXTools_' +
    FormatDateTime('yyyymmdd_hhnnss', Now) + '.txt';
  L := TStringList.Create;
  try
    L.Add('FACTURLINEX TOOLS - DIAGNÓSTICO');
    L.Add('Fecha=' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
    L.Add('Raiz=' + FRootDir);
    L.Add('FacturLinEx=' + FMainBinary);
    L.Add('Mantenimiento=' + FMaintenanceBinary);
    L.Add('Instalador=' + FInstallerBinary);
    L.Add('Documentacion=' + FDocsDir);
    L.Add('OpenSSL=' + ExecutableInPath('openssl'));
    L.Add('MariaDB=' + ExecutableInPath('mariadb'));
    if L.Values['MariaDB'] = '' then L.Values['MariaDB'] := ExecutableInPath('mysql');
    L.Add('rsync=' + ExecutableInPath('rsync'));
    L.Add('');
    L.Add('No incluye contraseñas ni contenido fiscal.');
    L.SaveToFile(N);
    MessageDlg('Diagnóstico guardado en:' + LineEnding + N,
      mtInformation, [mbOK], 0);
    AddEvent('Diagnóstico generado.');
  finally
    L.Free;
  end;
end;

procedure TfrmFLXTools.RefreshClick(Sender: TObject);
begin
  RefreshState;
end;

procedure TfrmFLXTools.CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFLXTools.FormKeyDownHandler(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

end.
