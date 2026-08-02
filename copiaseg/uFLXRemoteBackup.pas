unit uFLXRemoteBackup;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  Classes, SysUtils, IniFiles;

const
  FLX_SSH_AUTH_KEY = 'CLAVE';
  FLX_SSH_AUTH_PASSWORD = 'PASSWORD';

type
  TFLXRemoteBackupConfig = record
    Enabled: Boolean;
    AutoOnExit: Boolean;
    FTPOnExit: Boolean;
    Host: string;
    Port: Integer;
    UserName: string;
    AuthMethod: string;
    IdentityFile: string;
    Password: string;
    LocalDestination: string;
    RemoteCommand: string;
    KeepRemoteCopies: Integer;
    TimeoutSeconds: Integer;
    DatabaseLabel: string;
  end;

  TFLXFTPTransferConfig = record
    UseFTPS: Boolean;
    Host: string;
    Port: Integer;
    UserName: string;
    Password: string;
    RemoteDir: string;
    Passive: Boolean;
    CreateRemoteDir: Boolean;
    TimeoutSeconds: Integer;
  end;

procedure FLXRemoteBackupDefaults(out ACfg: TFLXRemoteBackupConfig);
function FLXIniReadBoolCompat(AIni: TCustomIniFile; const ASection,
  AKey: string; const ADefault: Boolean): Boolean;
procedure FLXIniWriteBoolCompat(AIni: TCustomIniFile; const ASection,
  AKey: string; const AValue: Boolean);
function FLXReadRemoteBackupConfig(AIni: TCustomIniFile;
  const ADatabaseLabel: string): TFLXRemoteBackupConfig;
function FLXValidateRemoteBackupConfig(const ACfg: TFLXRemoteBackupConfig;
  out AError: string): Boolean;
function FLXTestRemoteBackupConnection(const ACfg: TFLXRemoteBackupConfig;
  out AMessage: string): Boolean;
function FLXRunRemoteBackup(const ACfg: TFLXRemoteBackupConfig;
  out ALocalFile, AMessage: string): Boolean;
function FLXRunRemoteDatabaseBackup(const ACfg: TFLXRemoteBackupConfig;
  const ADatabaseName: string; out ALocalFile, AMessage: string): Boolean;
function FLXUploadFileFTP(const ACfg: TFLXFTPTransferConfig;
  const ALocalFile: string; out AMessage: string): Boolean;
function FLXRunRemoteRestore(const ACfg: TFLXRemoteBackupConfig;
  const ALocalArchive: string; out AMessage: string): Boolean;

implementation

uses
  Process, Forms, Controls, StdCtrls, ComCtrls, Graphics
  {$IFDEF UNIX}, BaseUnix{$ENDIF};

const
  FLX_REMOTE_SECTION = 'BackupRemoto';

type
  { Ventana creada íntegramente por código para no añadir ningún .lfm.
    Muestra actividad real, fase y tiempo transcurrido. La barra es
    indeterminada: mariadb-backup no ofrece un porcentaje global fiable. }
  TFLXBackupProgressForm = class(TForm)
  private
    FTitleLabel: TLabel;
    FStageLabel: TLabel;
    FInfoLabel: TLabel;
    FElapsedLabel: TLabel;
    FProgressBar: TProgressBar;
    FStartedAt: QWord;
    FLastPulseAt: QWord;
    procedure PreventClose(Sender: TObject; var CanClose: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeginOperation(const ATitle, AStage: string);
    procedure SetStage(const AStage, ADetail: string);
    procedure Pulse;
  end;

var
  GBackupProgress: TFLXBackupProgressForm = nil;
  GBackupProgressDepth: Integer = 0;
  GPreviousCursor: TCursor = crDefault;

constructor TFLXBackupProgressForm.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner, 1);

  Caption := 'FacturLinEx - Copia de seguridad en curso';
  Position := poScreenCenter;
  BorderStyle := bsDialog;
  BorderIcons := [];
  FormStyle := fsStayOnTop;
  ClientWidth := 560;
  ClientHeight := 205;
  Color := RGBToColor(238, 243, 248);
  OnCloseQuery := @PreventClose;

  FTitleLabel := TLabel.Create(Self);
  FTitleLabel.Parent := Self;
  FTitleLabel.SetBounds(24, 18, 512, 28);
  FTitleLabel.AutoSize := False;
  FTitleLabel.Font.Size := 12;
  FTitleLabel.Font.Style := [fsBold];
  FTitleLabel.Font.Color := RGBToColor(25, 62, 98);
  FTitleLabel.Caption := 'Copia de seguridad';

  FStageLabel := TLabel.Create(Self);
  FStageLabel.Parent := Self;
  FStageLabel.SetBounds(24, 56, 512, 24);
  FStageLabel.AutoSize := False;
  FStageLabel.Font.Size := 10;
  FStageLabel.Font.Style := [fsBold];
  FStageLabel.Caption := 'Preparando la operación...';

  FProgressBar := TProgressBar.Create(Self);
  FProgressBar.Parent := Self;
  FProgressBar.SetBounds(24, 88, 512, 22);
  FProgressBar.Min := 0;
  FProgressBar.Max := 100;
  FProgressBar.Position := 0;

  FElapsedLabel := TLabel.Create(Self);
  FElapsedLabel.Parent := Self;
  FElapsedLabel.SetBounds(24, 121, 512, 20);
  FElapsedLabel.AutoSize := False;
  FElapsedLabel.Caption := 'Tiempo transcurrido: 00:00:00';

  FInfoLabel := TLabel.Create(Self);
  FInfoLabel.Parent := Self;
  FInfoLabel.SetBounds(24, 149, 512, 42);
  FInfoLabel.AutoSize := False;
  FInfoLabel.WordWrap := True;
  FInfoLabel.Font.Color := RGBToColor(70, 80, 90);
  FInfoLabel.Caption :=
    'La operación está activa. Puede tardar varios minutos según el tamaño ' +
    'de la base de datos y la velocidad de la red.';
end;

procedure TFLXBackupProgressForm.PreventClose(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := False;
end;

procedure TFLXBackupProgressForm.BeginOperation(const ATitle, AStage: string);
begin
  FStartedAt := GetTickCount64;
  FLastPulseAt := 0;
  FProgressBar.Position := 0;
  FTitleLabel.Caption := ATitle;
  SetStage(AStage,
    'La operación está activa. Espere a que termine y no apague el equipo ni el servidor.');
end;

procedure TFLXBackupProgressForm.SetStage(const AStage, ADetail: string);
begin
  FStageLabel.Caption := AStage;
  if Trim(ADetail) <> '' then
    FInfoLabel.Caption := ADetail;
  Pulse;
  Application.ProcessMessages;
end;

procedure TFLXBackupProgressForm.Pulse;
var
  NowTick, ElapsedSeconds: QWord;
  Hours, Minutes, Seconds: Integer;
begin
  NowTick := GetTickCount64;
  if (FLastPulseAt <> 0) and ((NowTick - FLastPulseAt) < 120) then
    Exit;
  FLastPulseAt := NowTick;

  if FProgressBar.Position >= 96 then
    FProgressBar.Position := 0
  else
    FProgressBar.Position := FProgressBar.Position + 4;

  ElapsedSeconds := (NowTick - FStartedAt) div 1000;
  Hours := Integer(ElapsedSeconds div 3600);
  Minutes := Integer((ElapsedSeconds mod 3600) div 60);
  Seconds := Integer(ElapsedSeconds mod 60);
  FElapsedLabel.Caption := Format(
    'Tiempo transcurrido: %2.2d:%2.2d:%2.2d',
    [Hours, Minutes, Seconds]);
end;

procedure FLXProgressBegin(const ATitle, AStage: string);
begin
  Inc(GBackupProgressDepth);
  if not Assigned(GBackupProgress) then
  begin
    GPreviousCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    GBackupProgress := TFLXBackupProgressForm.Create(Application);
    GBackupProgress.BeginOperation(ATitle, AStage);
    GBackupProgress.Show;
    GBackupProgress.BringToFront;
    Application.ProcessMessages;
  end
  else
    GBackupProgress.SetStage(AStage, '');
end;

procedure FLXProgressStage(const AStage, ADetail: string);
begin
  if Assigned(GBackupProgress) then
    GBackupProgress.SetStage(AStage, ADetail);
end;

procedure FLXProgressPulse;
begin
  if Assigned(GBackupProgress) then
    GBackupProgress.Pulse;
end;

procedure FLXProgressEnd;
begin
  if GBackupProgressDepth > 0 then
    Dec(GBackupProgressDepth);
  if (GBackupProgressDepth = 0) and Assigned(GBackupProgress) then
  begin
    GBackupProgress.OnCloseQuery := nil;
    FreeAndNil(GBackupProgress);
    Screen.Cursor := GPreviousCursor;
    Application.ProcessMessages;
  end;
end;

function ExpandUserPath(const APath: string): string;
begin
  Result := Trim(APath);
  if (Length(Result) >= 2) and (Result[1] = '~') and
     ((Result[2] = '/') or (Result[2] = PathDelim)) then
    Result := IncludeTrailingPathDelimiter(GetUserDir) + Copy(Result, 3, MaxInt);
  if Result <> '' then
    Result := ExpandFileName(Result);
end;

function IsSafeHost(const S: string): Boolean;
var
  I: Integer;
begin
  Result := Trim(S) <> '';
  if not Result then Exit;
  for I := 1 to Length(S) do
    if not (S[I] in ['A'..'Z', 'a'..'z', '0'..'9', '.', '-', '_']) then
      Exit(False);
end;

function IsSafeRemoteToken(const S: string; const AllowSlash: Boolean): Boolean;
var
  I: Integer;
begin
  Result := Trim(S) <> '';
  if not Result then Exit;
  for I := 1 to Length(S) do
    if not (S[I] in ['A'..'Z', 'a'..'z', '0'..'9', '.', '-', '_']) and
       not (AllowSlash and (S[I] = '/')) then
      Exit(False);
end;

function IsSHA256(const S: string): Boolean;
var
  I: Integer;
begin
  Result := Length(S) = 64;
  if not Result then Exit;
  for I := 1 to Length(S) do
    if not (S[I] in ['0'..'9', 'a'..'f', 'A'..'F']) then
      Exit(False);
end;

function FirstToken(const S: string): string;
var
  P: SizeInt;
begin
  Result := Trim(S);
  P := Pos(' ', Result);
  if P > 0 then Result := Copy(Result, 1, P - 1);
  P := Pos(#9, Result);
  if P > 0 then Result := Copy(Result, 1, P - 1);
end;

function TailOutput(const AOutput: string; const AMaxLines: Integer = 90): string;
var
  L: TStringList;
  I, FirstLine: Integer;
begin
  Result := Trim(AOutput);
  if (Result = '') or (AMaxLines <= 0) then Exit;

  L := TStringList.Create;
  try
    L.Text := AOutput;
    FirstLine := L.Count - AMaxLines;
    if FirstLine < 0 then FirstLine := 0;
    Result := '';
    for I := FirstLine to L.Count - 1 do
    begin
      if Result <> '' then Result := Result + LineEnding;
      Result := Result + L[I];
    end;
    Result := Trim(Result);
  finally
    L.Free;
  end;
end;

function FindOutputValue(const AOutput, AName: string): string;
var
  L: TStringList;
  I: Integer;
  Prefix, S: string;
begin
  Result := '';
  Prefix := AName + '=';
  L := TStringList.Create;
  try
    L.Text := AOutput;
    for I := 0 to L.Count - 1 do
    begin
      S := Trim(L[I]);
      if Copy(S, 1, Length(Prefix)) = Prefix then
        Exit(Trim(Copy(S, Length(Prefix) + 1, MaxInt)));
    end;
  finally
    L.Free;
  end;
end;

function NormalizeSSHAuthMethod(const AMethod: string): string;
begin
  Result := UpperCase(Trim(AMethod));
  if Result = '' then Result := FLX_SSH_AUTH_KEY;
  if (Result = 'CONTRASEÑA') or (Result = 'CONTRASENA') or
     (Result = 'PASSWORD') then
    Result := FLX_SSH_AUTH_PASSWORD
  else if (Result = 'CLAVE') or (Result = 'KEY') or
          (Result = 'PRIVATEKEY') then
    Result := FLX_SSH_AUTH_KEY;
end;

function ExecutableAvailable(const AExecutable: string): Boolean;
var
  Paths: TStringList;
  I: Integer;
  Candidate: string;
begin
  Result := False;
  if Trim(AExecutable) = '' then Exit;

  if ExtractFilePath(AExecutable) <> '' then
    Exit(FileExists(AExecutable));

  Paths := TStringList.Create;
  try
    {$IFDEF UNIX}
    ExtractStrings([':'], [], PChar(GetEnvironmentVariable('PATH')), Paths);
    {$ELSE}
    ExtractStrings([';'], [], PChar(GetEnvironmentVariable('PATH')), Paths);
    {$ENDIF}
    for I := 0 to Paths.Count - 1 do
    begin
      Candidate := IncludeTrailingPathDelimiter(Paths[I]) + AExecutable;
      if FileExists(Candidate) then Exit(True);
    end;
  finally
    Paths.Free;
  end;
end;

procedure AddSSHOptions(AParams: TStrings; const ACfg: TFLXRemoteBackupConfig;
  const APortSwitch: string);
var
  KeyFile, AuthMethod: string;
begin
  AuthMethod := NormalizeSSHAuthMethod(ACfg.AuthMethod);
  AParams.Add('-o');
  if AuthMethod = FLX_SSH_AUTH_PASSWORD then
    AParams.Add('BatchMode=no')
  else
    AParams.Add('BatchMode=yes');
  AParams.Add('-o');
  AParams.Add('ConnectTimeout=12');
  AParams.Add('-o');
  AParams.Add('ServerAliveInterval=15');
  AParams.Add('-o');
  AParams.Add('ServerAliveCountMax=3');
  AParams.Add('-o');
  AParams.Add('StrictHostKeyChecking=accept-new');
  AParams.Add('-o');
  AParams.Add('NumberOfPasswordPrompts=1');

  if AuthMethod = FLX_SSH_AUTH_PASSWORD then
  begin
    AParams.Add('-o');
    AParams.Add('PreferredAuthentications=password,keyboard-interactive');
    AParams.Add('-o');
    AParams.Add('PubkeyAuthentication=no');
  end
  else
  begin
    AParams.Add('-o');
    AParams.Add('PreferredAuthentications=publickey');
    AParams.Add('-o');
    AParams.Add('PasswordAuthentication=no');
  end;

  AParams.Add(APortSwitch);
  AParams.Add(IntToStr(ACfg.Port));

  if AuthMethod = FLX_SSH_AUTH_KEY then
  begin
    KeyFile := ExpandUserPath(ACfg.IdentityFile);
    if KeyFile <> '' then
    begin
      AParams.Add('-i');
      AParams.Add(KeyFile);
    end;
  end;
end;

function RunProcessCapture(const AExecutable: string; AParams: TStrings;
  const ATimeoutSeconds: Integer; out AOutput: string;
  out AExitCode: Integer): Boolean;
var
  P: TProcess;
  Buffer: array[0..8191] of Char;
  ReadCount: LongInt;
  Chunk: string;
  StartedAt, TimeoutMS: QWord;

  procedure DrainOutput;
  begin
    while P.Output.NumBytesAvailable > 0 do
    begin
      ReadCount := P.Output.Read(Buffer, SizeOf(Buffer));
      if ReadCount <= 0 then Break;
      SetString(Chunk, PChar(@Buffer[0]), ReadCount);
      AOutput := AOutput + Chunk;
    end;
  end;

begin
  Result := False;
  AOutput := '';
  AExitCode := -1;
  P := TProcess.Create(nil);
  try
    P.Executable := AExecutable;
    P.Parameters.Assign(AParams);
    P.Options := [poUsePipes, poStderrToOutPut];
    P.ShowWindow := swoHIDE;
    try
      P.Execute;
    except
      on E: Exception do
      begin
        AOutput := E.Message;
        Exit(False);
      end;
    end;

    StartedAt := GetTickCount64;
    if ATimeoutSeconds > 0 then
      TimeoutMS := QWord(ATimeoutSeconds) * 1000
    else
      TimeoutMS := QWord(3600) * 1000;

    while P.Running do
    begin
      DrainOutput;
      FLXProgressPulse;
      Application.ProcessMessages;
      Sleep(25);
      if (GetTickCount64 - StartedAt) > TimeoutMS then
      begin
        P.Terminate(1);
        AOutput := AOutput + LineEnding +
          'Tiempo de espera agotado al ejecutar ' + AExecutable + '.';
        Exit(False);
      end;
    end;

    DrainOutput;
    AExitCode := P.ExitStatus;
    Result := AExitCode = 0;
  finally
    P.Free;
  end;
end;

function RunRemoteProcessCapture(const AExecutable: string; AParams: TStrings;
  const ACfg: TFLXRemoteBackupConfig; const ATimeoutSeconds: Integer;
  out AOutput: string; out AExitCode: Integer): Boolean;
var
  AuthMethod, PasswordFile: string;
  PasswordData: TStringList;
  WrappedParams: TStringList;
begin
  AuthMethod := NormalizeSSHAuthMethod(ACfg.AuthMethod);
  if AuthMethod <> FLX_SSH_AUTH_PASSWORD then
    Exit(RunProcessCapture(AExecutable, AParams, ATimeoutSeconds,
      AOutput, AExitCode));

  if not ExecutableAvailable('sshpass') then
  begin
    AOutput := 'Para usar contraseña SSH debe instalar sshpass en este puesto ' +
      '(Debian: sudo apt install sshpass).';
    AExitCode := -1;
    Exit(False);
  end;

  PasswordFile := GetTempFileName(GetTempDir(False), 'flxssh_');
  PasswordData := TStringList.Create;
  WrappedParams := TStringList.Create;
  try
    {$IFDEF UNIX}
    fpChmod(PChar(PasswordFile), &600);
    {$ENDIF}
    PasswordData.Add(ACfg.Password);
    PasswordData.SaveToFile(PasswordFile);

    WrappedParams.Add('-f');
    WrappedParams.Add(PasswordFile);
    WrappedParams.Add(AExecutable);
    WrappedParams.AddStrings(AParams);
    Result := RunProcessCapture('sshpass', WrappedParams, ATimeoutSeconds,
      AOutput, AExitCode);
  finally
    WrappedParams.Free;
    PasswordData.Free;
    DeleteFile(PasswordFile);
  end;
end;

procedure WriteRemoteLog(const AText: string);
var
  LogDir, LogFile: string;
  F: TextFile;
begin
  try
    LogDir := IncludeTrailingPathDelimiter(GetUserDir) +
      '.config' + PathDelim + 'facturlinex' + PathDelim + 'logs';
    ForceDirectories(LogDir);
    LogFile := IncludeTrailingPathDelimiter(LogDir) +
      'backup_remoto_' + FormatDateTime('yyyymmdd', Date) + '.log';
    AssignFile(F, LogFile);
    if FileExists(LogFile) then Append(F) else Rewrite(F);
    try
      WriteLn(F, '[' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + '] ' + AText);
    finally
      CloseFile(F);
    end;
  except
    { El registro nunca debe impedir la operación. }
  end;
end;

function CalculateSHA256(const AFileName: string; out AHash, AError: string): Boolean;
var
  Params: TStringList;
  Output: string;
  ExitCode: Integer;
begin
  Result := False;
  AHash := '';
  AError := '';
  Params := TStringList.Create;
  try
    Params.Add(AFileName);
    if not RunProcessCapture('sha256sum', Params, 600, Output, ExitCode) then
    begin
      AError := 'No se pudo calcular SHA-256.' + LineEnding + Trim(Output);
      Exit;
    end;
    AHash := LowerCase(FirstToken(Output));
    if not IsSHA256(AHash) then
    begin
      AError := 'sha256sum no devolvió una firma válida.';
      Exit;
    end;
    Result := True;
  finally
    Params.Free;
  end;
end;

function WriteSHA256Sidecar(const AFileName, AHash: string; out AError: string): Boolean;
var
  L: TStringList;
begin
  Result := False;
  AError := '';
  L := TStringList.Create;
  try
    L.Add(LowerCase(AHash) + '  ' + ExtractFileName(AFileName));
    try
      L.SaveToFile(AFileName + '.sha256');
      Result := True;
    except
      on E: Exception do
        AError := 'No se pudo guardar la firma local: ' + E.Message;
    end;
  finally
    L.Free;
  end;
end;

function FLXIniReadBoolCompat(AIni: TCustomIniFile; const ASection,
  AKey: string; const ADefault: Boolean): Boolean;
var
  S: string;
begin
  Result := ADefault;
  if not Assigned(AIni) then Exit;

  S := LowerCase(Trim(AIni.ReadString(ASection, AKey, '')));
  if S = '' then Exit;

  if (S = '1') or (S = 'true') or (S = 'yes') or
     (S = 'si') or (S = 'on') then
    Result := True
  else if (S = '0') or (S = 'false') or (S = 'no') or
          (S = 'off') then
    Result := False;
end;

procedure FLXIniWriteBoolCompat(AIni: TCustomIniFile; const ASection,
  AKey: string; const AValue: Boolean);
begin
  if not Assigned(AIni) then Exit;
  if AValue then
    AIni.WriteString(ASection, AKey, '1')
  else
    AIni.WriteString(ASection, AKey, '0');
end;

procedure FLXRemoteBackupDefaults(out ACfg: TFLXRemoteBackupConfig);
begin
  ACfg.Enabled := False;
  ACfg.AutoOnExit := False;
  ACfg.FTPOnExit := False;
  ACfg.Host := '';
  ACfg.Port := 22;
  ACfg.UserName := '';
  ACfg.AuthMethod := FLX_SSH_AUTH_KEY;
  ACfg.IdentityFile := IncludeTrailingPathDelimiter(GetUserDir) + '.ssh' +
    PathDelim + 'id_ed25519';
  ACfg.Password := '';
  ACfg.LocalDestination := IncludeTrailingPathDelimiter(GetUserDir) +
    'CopiasFacturLinEx';
  ACfg.RemoteCommand := '/usr/local/sbin/flx_remote_backup_server';
  ACfg.KeepRemoteCopies := 7;
  ACfg.TimeoutSeconds := 14400;
  ACfg.DatabaseLabel := 'facturlinex';
end;

function FLXReadRemoteBackupConfig(AIni: TCustomIniFile;
  const ADatabaseLabel: string): TFLXRemoteBackupConfig;
var
  Def: TFLXRemoteBackupConfig;
begin
  FLXRemoteBackupDefaults(Def);
  Result := Def;
  if not Assigned(AIni) then Exit;

  Result.Enabled := FLXIniReadBoolCompat(AIni, FLX_REMOTE_SECTION,
    'Activo', Def.Enabled);
  Result.AutoOnExit := FLXIniReadBoolCompat(AIni, FLX_REMOTE_SECTION,
    'AutomaticoAlSalir', Def.AutoOnExit);
  Result.FTPOnExit := FLXIniReadBoolCompat(AIni, FLX_REMOTE_SECTION,
    'EnviarFTPAlSalir', Def.FTPOnExit);
  Result.Host := Trim(AIni.ReadString(FLX_REMOTE_SECTION, 'Host', Def.Host));
  Result.Port := AIni.ReadInteger(FLX_REMOTE_SECTION, 'Puerto', Def.Port);
  Result.UserName := Trim(AIni.ReadString(FLX_REMOTE_SECTION,
    'UsuarioSSH', Def.UserName));
  Result.AuthMethod := NormalizeSSHAuthMethod(AIni.ReadString(
    FLX_REMOTE_SECTION, 'AutenticacionSSH', Def.AuthMethod));
  Result.IdentityFile := AIni.ReadString(FLX_REMOTE_SECTION,
    'ClaveSSH', Def.IdentityFile);
  { La contraseña se inyecta descifrada desde Menu mediante uFLX_CryptoIni. }
  Result.Password := '';
  Result.LocalDestination := AIni.ReadString(FLX_REMOTE_SECTION,
    'DestinoLocal', Def.LocalDestination);
  Result.RemoteCommand := Trim(AIni.ReadString(FLX_REMOTE_SECTION,
    'ComandoServidor', Def.RemoteCommand));
  Result.KeepRemoteCopies := AIni.ReadInteger(FLX_REMOTE_SECTION,
    'CopiasEnServidor', Def.KeepRemoteCopies);
  Result.TimeoutSeconds := AIni.ReadInteger(FLX_REMOTE_SECTION,
    'TiempoEsperaSegundos', Def.TimeoutSeconds);
  Result.DatabaseLabel := Trim(ADatabaseLabel);
  if Result.DatabaseLabel = '' then Result.DatabaseLabel := Def.DatabaseLabel;
end;

function FLXValidateRemoteBackupConfig(const ACfg: TFLXRemoteBackupConfig;
  out AError: string): Boolean;
var
  KeyFile, LocalDir, AuthMethod: string;
begin
  Result := False;
  AError := '';

  if not IsSafeHost(ACfg.Host) then
  begin
    AError := 'El servidor remoto está vacío o contiene caracteres no permitidos.';
    Exit;
  end;
  if (ACfg.Port < 1) or (ACfg.Port > 65535) then
  begin
    AError := 'El puerto SSH debe estar entre 1 y 65535.';
    Exit;
  end;
  if not IsSafeRemoteToken(ACfg.UserName, False) then
  begin
    AError := 'El usuario SSH está vacío o contiene caracteres no permitidos.';
    Exit;
  end;
  if not IsSafeRemoteToken(ACfg.RemoteCommand, True) then
  begin
    AError := 'El comando del servidor debe ser una ruta absoluta sin espacios.';
    Exit;
  end;
  if ACfg.RemoteCommand[1] <> '/' then
  begin
    AError := 'El comando del servidor debe comenzar por /.';
    Exit;
  end;
  if not IsSafeRemoteToken(ACfg.DatabaseLabel, False) then
  begin
    AError := 'La etiqueta de la base de datos contiene caracteres no permitidos.';
    Exit;
  end;
  if (ACfg.KeepRemoteCopies < 1) or (ACfg.KeepRemoteCopies > 365) then
  begin
    AError := 'El número de copias conservadas debe estar entre 1 y 365.';
    Exit;
  end;

  AuthMethod := NormalizeSSHAuthMethod(ACfg.AuthMethod);
  if (AuthMethod <> FLX_SSH_AUTH_KEY) and
     (AuthMethod <> FLX_SSH_AUTH_PASSWORD) then
  begin
    AError := 'El método de autenticación SSH no es válido.';
    Exit;
  end;

  if AuthMethod = FLX_SSH_AUTH_KEY then
  begin
    KeyFile := ExpandUserPath(ACfg.IdentityFile);
    if KeyFile = '' then
    begin
      AError := 'Debe indicar la clave privada SSH.';
      Exit;
    end;
    if not FileExists(KeyFile) then
    begin
      AError := 'No existe la clave SSH indicada: ' + KeyFile;
      Exit;
    end;
  end
  else
  begin
    if ACfg.Password = '' then
    begin
      AError := 'Debe indicar la contraseña SSH.';
      Exit;
    end;
    if (Pos(#10, ACfg.Password) > 0) or (Pos(#13, ACfg.Password) > 0) then
    begin
      AError := 'La contraseña SSH no puede contener saltos de línea.';
      Exit;
    end;
    if not ExecutableAvailable('sshpass') then
    begin
      AError := 'Para usar contraseña SSH debe instalar sshpass en este puesto ' +
        '(Debian: sudo apt install sshpass).';
      Exit;
    end;
  end;

  LocalDir := ExpandUserPath(ACfg.LocalDestination);
  if LocalDir = '' then
  begin
    AError := 'Debe indicar una carpeta local para recibir las copias.';
    Exit;
  end;

  Result := True;
end;

function FLXTestRemoteBackupConnection(const ACfg: TFLXRemoteBackupConfig;
  out AMessage: string): Boolean;
var
  Params: TStringList;
  Output, Err: string;
  ExitCode: Integer;
begin
  Result := False;
  if not FLXValidateRemoteBackupConfig(ACfg, Err) then
  begin
    AMessage := Err;
    Exit;
  end;

  Params := TStringList.Create;
  try
    AddSSHOptions(Params, ACfg, '-p');
    Params.Add(ACfg.UserName + '@' + ACfg.Host);
    Params.Add('sudo -n ' + ACfg.RemoteCommand + ' test');
    Result := RunRemoteProcessCapture('ssh', Params, ACfg, 60, Output, ExitCode) and
      (Pos('FLX_SERVER_OK', Output) > 0);
    if Result then
      AMessage := 'Conexión SSH (' +
        LowerCase(NormalizeSSHAuthMethod(ACfg.AuthMethod)) +
        ') y herramientas del servidor correctas.'
    else if (Pos('sudo: a password is required', LowerCase(Output)) > 0) or
      (Pos('sudo: se necesita una contraseña', LowerCase(Output)) > 0) or
      (Pos('sudo: no tty present', LowerCase(Output)) > 0) then
      AMessage :=
        'La conexión SSH es correcta, pero el usuario remoto no tiene permiso ' +
        'NOPASSWD para ejecutar el script de FacturLinEx.' + LineEnding + LineEnding +
        'En el servidor debe instalarse la regla:' + LineEnding +
        '/etc/sudoers.d/facturlinex-backup' + LineEnding + LineEnding +
        'La contraseña SSH solo sirve para iniciar la sesión; no se reutiliza ' +
        'como contraseña de sudo.' + LineEnding + LineEnding + Trim(Output)
    else if Pos('not allowed to execute', LowerCase(Output)) > 0 then
      AMessage :=
        'La conexión SSH es correcta, pero la regla sudoers no autoriza el ' +
        'comando configurado. Compruebe el usuario SSH y que la ruta sea ' +
        ACfg.RemoteCommand + '.' + LineEnding + LineEnding + Trim(Output)
    else
      AMessage := 'No se pudo validar el servidor remoto.' + LineEnding + Trim(Output);
    WriteRemoteLog('PRUEBA SSH: ' + AMessage);
  finally
    Params.Free;
  end;
end;

function FLXRunRemoteBackupCommand(const ACfg: TFLXRemoteBackupConfig;
  const ARemoteArguments, ADescription: string;
  out ALocalFile, AMessage: string): Boolean;
var
  Params: TStringList;
  Output, Err, RemoteFile, RemoteHash, LocalHash, LocalDir, RemoteSpec,
    SidecarError: string;
  ExitCode: Integer;
  FS: TFileStream;
begin
  Result := False;
  ALocalFile := '';
  AMessage := '';

  if not FLXValidateRemoteBackupConfig(ACfg, Err) then
  begin
    AMessage := Err;
    Exit;
  end;

  LocalDir := ExpandUserPath(ACfg.LocalDestination);
  if not ForceDirectories(LocalDir) then
  begin
    AMessage := 'No se ha podido crear la carpeta local: ' + LocalDir;
    Exit;
  end;

  Params := nil;
  FLXProgressBegin(ADescription, 'Conectando con el servidor remoto...');
  try
    Params := TStringList.Create;
    AddSSHOptions(Params, ACfg, '-p');
    Params.Add(ACfg.UserName + '@' + ACfg.Host);
    Params.Add('sudo -n ' + ACfg.RemoteCommand + ' ' + ARemoteArguments);

    WriteRemoteLog('INICIO ' + ADescription + ' en ' + ACfg.Host + '.');
    FLXProgressStage('Generando la copia física en el servidor...',
      'Servidor: ' + ACfg.Host +
      '. Esta fase suele ser la más larga; el indicador seguirá moviéndose.');
    if not RunRemoteProcessCapture('ssh', Params, ACfg, ACfg.TimeoutSeconds,
      Output, ExitCode) then
    begin
      AMessage := 'El servidor no pudo generar ' + LowerCase(ADescription) + '.' + LineEnding +
        'Se muestran las últimas líneas del diagnóstico remoto:' + LineEnding +
        TailOutput(Output, 100);
      WriteRemoteLog('ERROR servidor: ' + AMessage);
      Exit;
    end;

    FLXProgressStage('La copia se ha generado en el servidor.',
      'Comprobando la respuesta, la ruta del archivo y su firma SHA-256...');
    RemoteFile := FindOutputValue(Output, 'FLX_BACKUP_FILE');
    RemoteHash := LowerCase(FindOutputValue(Output, 'FLX_BACKUP_SHA256'));
    if (RemoteFile = '') or not IsSafeRemoteToken(RemoteFile, True) then
    begin
      AMessage := 'El servidor terminó, pero no devolvió una ruta de copia válida.' +
        LineEnding + TailOutput(Output, 80);
      WriteRemoteLog('ERROR respuesta servidor: ' + AMessage);
      Exit;
    end;
    if not IsSHA256(RemoteHash) then
    begin
      AMessage := 'El servidor no devolvió una firma SHA-256 válida. ' +
        'La copia no se descargará.' + LineEnding + TailOutput(Output, 80);
      WriteRemoteLog('ERROR firma servidor: ' + AMessage);
      Exit;
    end;

    FLXProgressStage('Descargando la copia al equipo...',
      'Destino local: ' + LocalDir);
    Params.Clear;
    AddSSHOptions(Params, ACfg, '-P');
    RemoteSpec := ACfg.UserName + '@' + ACfg.Host + ':' + RemoteFile;
    Params.Add(RemoteSpec);
    Params.Add(IncludeTrailingPathDelimiter(LocalDir));

    if not RunRemoteProcessCapture('scp', Params, ACfg, ACfg.TimeoutSeconds,
      Output, ExitCode) then
    begin
      AMessage := 'La copia se creó en el servidor, pero no pudo descargarse.' +
        LineEnding + Trim(Output);
      WriteRemoteLog('ERROR descarga: ' + AMessage);
      Exit;
    end;

    ALocalFile := IncludeTrailingPathDelimiter(LocalDir) +
      ExtractFileName(RemoteFile);
    if not FileExists(ALocalFile) then
    begin
      AMessage := 'SCP finalizó sin error, pero no aparece el fichero local: ' +
        ALocalFile;
      WriteRemoteLog('ERROR fichero ausente: ' + AMessage);
      Exit;
    end;

    FS := TFileStream.Create(ALocalFile, fmOpenRead or fmShareDenyNone);
    try
      if FS.Size <= 0 then
      begin
        AMessage := 'El fichero descargado está vacío: ' + ALocalFile;
        WriteRemoteLog('ERROR fichero vacío: ' + AMessage);
        Exit;
      end;
    finally
      FS.Free;
    end;

    FLXProgressStage('Verificando la integridad SHA-256...',
      'Archivo: ' + ExtractFileName(ALocalFile));
    if not CalculateSHA256(ALocalFile, LocalHash, Err) then
    begin
      AMessage := 'La copia se descargó, pero no pudo verificarse.' + LineEnding + Err;
      WriteRemoteLog('ERROR SHA256: ' + AMessage);
      Exit;
    end;
    if LocalHash <> RemoteHash then
    begin
      AMessage := 'La verificación SHA-256 no coincide. La copia descargada no ' +
        'debe utilizarse.';
      WriteRemoteLog('ERROR SHA256 distinto. Remoto=' + RemoteHash +
        ' Local=' + LocalHash);
      Exit;
    end;

    if not WriteSHA256Sidecar(ALocalFile, LocalHash, SidecarError) then
      WriteRemoteLog('AVISO firma local: ' + SidecarError);

    FLXProgressStage('Finalizando la copia...',
      'La descarga es correcta y su firma coincide con la del servidor.');
    Result := True;
    AMessage := ADescription + ' finalizada y verificada:' + LineEnding +
      ALocalFile;
    WriteRemoteLog('OK: ' + ALocalFile);
  finally
    Params.Free;
    FLXProgressEnd;
  end;
end;


function FLXRunRemoteBackup(const ACfg: TFLXRemoteBackupConfig;
  out ALocalFile, AMessage: string): Boolean;
begin
  Result := FLXRunRemoteBackupCommand(ACfg,
    'backup ' + ACfg.DatabaseLabel + ' ' + IntToStr(ACfg.KeepRemoteCopies),
    'Copia completa del servidor MariaDB', ALocalFile, AMessage);
end;

function FLXRunRemoteDatabaseBackup(const ACfg: TFLXRemoteBackupConfig;
  const ADatabaseName: string; out ALocalFile, AMessage: string): Boolean;
var
  DBName: string;
begin
  DBName := Trim(ADatabaseName);
  if not IsSafeRemoteToken(DBName, False) then
  begin
    ALocalFile := '';
    AMessage := 'El nombre de la base de datos configurada no es válido para ' +
      'una copia remota: ' + DBName;
    Exit(False);
  end;

  Result := FLXRunRemoteBackupCommand(ACfg,
    'backup database ' + DBName + ' ' + IntToStr(ACfg.KeepRemoteCopies),
    'Backup físico de la base de datos "' + DBName + '"',
    ALocalFile, AMessage);
end;

function URLPathEncode(const S: string): string;
const
  Hex = '0123456789ABCDEF';
var
  I: Integer;
  B: Byte;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    B := Ord(S[I]);
    if Char(B) in ['A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.', '~', '/'] then
      Result := Result + Char(B)
    else
      Result := Result + '%' + Hex[(B shr 4) + 1] + Hex[(B and $0F) + 1];
  end;
end;

function NetrcQuoted(const S: string): string;
begin
  Result := StringReplace(S, '\', '\\', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
  Result := '"' + Result + '"';
end;

function UploadOneFTP(const ACfg: TFLXFTPTransferConfig;
  const ALocalFile, ANetrcFile: string; out AError: string): Boolean;
var
  Params: TStringList;
  Output, Scheme, RemotePath, URL: string;
  ExitCode: Integer;
begin
  Result := False;
  AError := '';
  RemotePath := Trim(ACfg.RemoteDir);
  while (RemotePath <> '') and (RemotePath[1] = '/') do Delete(RemotePath, 1, 1);
  if (RemotePath <> '') and (RemotePath[Length(RemotePath)] <> '/') then
    RemotePath := RemotePath + '/';

  Scheme := 'ftp://';
  URL := Scheme + ACfg.Host + ':' + IntToStr(ACfg.Port) + '/' +
    URLPathEncode(RemotePath + ExtractFileName(ALocalFile));

  Params := TStringList.Create;
  try
    Params.Add('--fail');
    Params.Add('--show-error');
    Params.Add('--silent');
    Params.Add('--connect-timeout');
    Params.Add('20');
    Params.Add('--max-time');
    Params.Add(IntToStr(ACfg.TimeoutSeconds));
    Params.Add('--netrc-file');
    Params.Add(ANetrcFile);
    if ACfg.UseFTPS then
      Params.Add('--ssl-reqd');
    if ACfg.Passive then
      Params.Add('--ftp-pasv')
    else
    begin
      Params.Add('--ftp-port');
      Params.Add('-');
    end;
    if ACfg.CreateRemoteDir then
      Params.Add('--ftp-create-dirs');
    Params.Add('--upload-file');
    Params.Add(ALocalFile);
    Params.Add(URL);

    Result := RunProcessCapture('curl', Params, ACfg.TimeoutSeconds + 30,
      Output, ExitCode);
    if not Result then
      AError := Trim(Output);
  finally
    Params.Free;
  end;
end;

function FLXUploadFileFTP(const ACfg: TFLXFTPTransferConfig;
  const ALocalFile: string; out AMessage: string): Boolean;
var
  NetrcName, Err, Sidecar: string;
  L: TStringList;
begin
  Result := False;
  AMessage := '';

  if not FileExists(ALocalFile) then
  begin
    AMessage := 'No existe el fichero que se desea enviar al FTP: ' + ALocalFile;
    Exit;
  end;
  if not IsSafeHost(ACfg.Host) then
  begin
    AMessage := 'El servidor FTP está vacío o contiene caracteres no permitidos.';
    Exit;
  end;
  if (ACfg.Port < 1) or (ACfg.Port > 65535) then
  begin
    AMessage := 'El puerto FTP no es válido.';
    Exit;
  end;
  if Trim(ACfg.UserName) = '' then
  begin
    AMessage := 'Falta el usuario FTP.';
    Exit;
  end;

  NetrcName := '';
  L := nil;
  FLXProgressBegin('Envío de la copia al servidor FTP',
    'Preparando la conexión FTP...');
  try
    NetrcName := GetTempFileName(GetTempDir(False), 'flxftp_');
    L := TStringList.Create;
    L.Add('machine ' + ACfg.Host);
    L.Add('login ' + NetrcQuoted(ACfg.UserName));
    L.Add('password ' + NetrcQuoted(ACfg.Password));
    L.SaveToFile(NetrcName);
    {$IFDEF UNIX}
    fpChmod(PChar(NetrcName), &600);
    {$ENDIF}

    WriteRemoteLog('INICIO envío FTP: ' + ALocalFile);
    FLXProgressStage('Enviando la copia al FTP...',
      'Archivo: ' + ExtractFileName(ALocalFile));
    if not UploadOneFTP(ACfg, ALocalFile, NetrcName, Err) then
    begin
      AMessage := 'No se pudo enviar la copia al FTP.' + LineEnding + Err;
      WriteRemoteLog('ERROR FTP: ' + AMessage);
      Exit;
    end;

    Sidecar := ALocalFile + '.sha256';
    if FileExists(Sidecar) then
    begin
      FLXProgressStage('Enviando la firma SHA-256 al FTP...',
        'Firma: ' + ExtractFileName(Sidecar));
      if not UploadOneFTP(ACfg, Sidecar, NetrcName, Err) then
      begin
        AMessage := 'La copia llegó al FTP, pero no se pudo enviar su firma SHA-256.' +
          LineEnding + Err;
        WriteRemoteLog('ERROR FTP firma: ' + AMessage);
        Exit;
      end;
    end;

    FLXProgressStage('Finalizando el envío FTP...',
      'La copia y su firma han sido transferidas correctamente.');
    Result := True;
    AMessage := 'Copia y firma SHA-256 enviadas correctamente al FTP.';
    WriteRemoteLog('OK FTP: ' + ALocalFile);
  finally
    L.Free;
    if NetrcName <> '' then
      DeleteFile(NetrcName);
    FLXProgressEnd;
  end;
end;

function FLXRunRemoteRestore(const ACfg: TFLXRemoteBackupConfig;
  const ALocalArchive: string; out AMessage: string): Boolean;
var
  Params: TStringList;
  Output, Err, LocalHash, RemoteUpload, RemoteSpec, SidecarHash: string;
  ExitCode: Integer;
  L: TStringList;
begin
  Result := False;
  AMessage := '';

  if not FLXValidateRemoteBackupConfig(ACfg, Err) then
  begin
    AMessage := Err;
    Exit;
  end;
  if not FileExists(ALocalArchive) then
  begin
    AMessage := 'No existe la copia seleccionada: ' + ALocalArchive;
    Exit;
  end;
  if not CalculateSHA256(ALocalArchive, LocalHash, Err) then
  begin
    AMessage := Err;
    Exit;
  end;

  if FileExists(ALocalArchive + '.sha256') then
  begin
    L := TStringList.Create;
    try
      try
        L.LoadFromFile(ALocalArchive + '.sha256');
      except
        on E: Exception do
        begin
          AMessage := 'No se pudo leer la firma de la copia: ' + E.Message;
          Exit;
        end;
      end;
      if L.Count = 0 then
      begin
        AMessage := 'El fichero de firma SHA-256 está vacío.';
        Exit;
      end;
      SidecarHash := LowerCase(FirstToken(L[0]));
      if (not IsSHA256(SidecarHash)) or (SidecarHash <> LocalHash) then
      begin
        AMessage := 'La firma SHA-256 local no coincide. La restauración se cancela.';
        Exit;
      end;
    finally
      L.Free;
    end;
  end;

  Params := TStringList.Create;
  try
    WriteRemoteLog('INICIO restauración remota desde ' + ALocalArchive);

    AddSSHOptions(Params, ACfg, '-p');
    Params.Add(ACfg.UserName + '@' + ACfg.Host);
    Params.Add('sudo -n ' + ACfg.RemoteCommand + ' restore-slot ' +
      ACfg.DatabaseLabel);
    if not RunRemoteProcessCapture('ssh', Params, ACfg, 120, Output, ExitCode) then
    begin
      AMessage := 'El servidor no pudo preparar la recepción de la copia.' +
        LineEnding + Trim(Output);
      Exit;
    end;
    RemoteUpload := FindOutputValue(Output, 'FLX_RESTORE_FILE');
    if (RemoteUpload = '') or not IsSafeRemoteToken(RemoteUpload, True) then
    begin
      AMessage := 'El servidor no devolvió una ruta temporal válida.' +
        LineEnding + Trim(Output);
      Exit;
    end;

    Params.Clear;
    AddSSHOptions(Params, ACfg, '-P');
    Params.Add(ALocalArchive);
    RemoteSpec := ACfg.UserName + '@' + ACfg.Host + ':' + RemoteUpload;
    Params.Add(RemoteSpec);
    if not RunRemoteProcessCapture('scp', Params, ACfg, ACfg.TimeoutSeconds,
      Output, ExitCode) then
    begin
      AMessage := 'No se pudo transferir la copia al servidor.' + LineEnding +
        Trim(Output);
      Exit;
    end;

    Params.Clear;
    AddSSHOptions(Params, ACfg, '-p');
    Params.Add(ACfg.UserName + '@' + ACfg.Host);
    Params.Add('sudo -n ' + ACfg.RemoteCommand + ' restore-check ' +
      RemoteUpload + ' ' + LocalHash);
    if not RunRemoteProcessCapture('ssh', Params, ACfg, 600, Output, ExitCode) then
    begin
      AMessage := 'El servidor rechazó la copia antes de restaurarla.' +
        LineEnding + Trim(Output);
      Exit;
    end;

    Params.Clear;
    AddSSHOptions(Params, ACfg, '-p');
    Params.Add(ACfg.UserName + '@' + ACfg.Host);
    Params.Add('sudo -n ' + ACfg.RemoteCommand + ' restore ' +
      RemoteUpload + ' ' + LocalHash + ' RESTAURAR');
    if not RunRemoteProcessCapture('ssh', Params, ACfg, ACfg.TimeoutSeconds * 2,
      Output, ExitCode) then
    begin
      AMessage := 'La restauración no pudo completarse.' + LineEnding +
        Trim(Output);
      WriteRemoteLog('ERROR RESTORE: ' + AMessage);
      Exit;
    end;

    if Pos('FLX_RESTORE_OK', Output) = 0 then
    begin
      AMessage := 'El servidor terminó sin confirmar la restauración.' +
        LineEnding + Trim(Output);
      Exit;
    end;

    Result := True;
    AMessage := 'Restauración física remota finalizada correctamente.' +
      LineEnding + 'El servidor MariaDB ha arrancado y ha respondido a la prueba.' +
      LineEnding + Trim(FindOutputValue(Output, 'FLX_PRE_RESTORE_BACKUP'));
    WriteRemoteLog('OK RESTORE: ' + ALocalArchive);
  finally
    Params.Free;
  end;
end;

end.
