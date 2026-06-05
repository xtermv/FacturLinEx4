unit uFLX_Sound;

{$mode objfpc}{$H+}

{
  uFLX_Sound.pas
  --------------
  Sonido "beep" audible para apps GUI Lazarus en Linux.

  - En Linux GUI, Beep/bell/PC speaker NO es fiable.
  - Esta unidad reproduce sonidos reales vía:
      1) paplay (PulseAudio/PipeWire) si existe
      2) aplay  (ALSA) si existe, con autodetección de hw:X,Y

  Recomendación PRODUCCIÓN:
    - Incluye WAV propios en:
        <carpeta_del_ejecutable>/sounds/beep.wav
        <carpeta_del_ejecutable>/sounds/ok.wav
        <carpeta_del_ejecutable>/sounds/error.wav
        <carpeta_del_ejecutable>/sounds/warning.wav

  Autodetección ALSA:
    - Si NO se fija ALSADevice manualmente (o por INI),
      la unidad ejecuta: aplay -l y obtiene candidatos:
        - HDMI con nombre de monitor (p.ej. [MSI MP275]) -> preferido para HDMI real
        - HDMI genérico (primer HDMI)
        - Analog (AIO / altavoz interno)

  Estrategia de reproducción (SIN BLOQUEOS):
    - Manteniendo tu orden: primero aplay y luego paplay
    - aplay intenta:
        1) default (sin -D)   -> el más robusto, suele funcionar en AIO
        2) -D HDMI detectado  -> para casos HDMI que no van por default
        3) -D Analog detectado
        4) -D ALSADevice (si estaba fijado)
    - si no hay aplay, usa paplay

  Uso:
    uses uFLX_Sound;

    FLX_Sound_Init;
    FLX_Beep;
}

interface

uses
  Classes, SysUtils;

type
  TFLXSoundKind = (skInfo, skOk, skError, skWarning);

procedure FLX_Sound_Init;

procedure FLX_Sound_Enable(const Enable: Boolean);
function  FLX_Sound_IsEnabled: Boolean;

procedure FLX_Sound_SetALSADevice(const Dev: string);
procedure FLX_Sound_SetAutoDetectALSADevice(const Enable: Boolean);

procedure FLX_Sound_SetFiles(const InfoFile, OkFile, ErrorFile, WarningFile: string);
procedure FLX_Sound_LoadFromIni(const IniFileName: string);

procedure FLX_Beep(const Kind: TFLXSoundKind = skInfo);
function FLX_PlaySoundFile(const AFileName: string): Boolean;

implementation

uses
  Process, BaseUnix, IniFiles, uFLX_Log, Global;

var
  GEnabled: Boolean = True;

  GDebugSound: Boolean = False; // ponlo a True si quieres log

  // Backend detectado
  GDetected  : Boolean = False;
  GHavePaPlay: Boolean = False;
  GHaveAPlay : Boolean = False;

  // Ejecutables encontrados (ruta completa)
  GPaPlayExe: string = '';
  GAPlayExe : string = '';

  // ALSA device opcional (p.ej. 'hw:1,3' si lo fijas manualmente)
  GALSAAudioDevice: string = '';

  // Candidatos autodetectados (para no depender de adivinar)
  GALSADefaultHDMI  : string = ''; // hw:x,y HDMI mejor
  GALSADefaultAnalog: string = ''; // hw:x,y Analog mejor

  // Autodetección ALSA
  GAutoDetectALSADevice: Boolean = True;

  // Ficheros por defecto (se rellenan en Init)
  GFileInfo   : string = '';
  GFileOk     : string = '';
  GFileError  : string = '';
  GFileWarning: string = '';

procedure SoundLog(const Msg: string);
begin
  if not GDebugSound then Exit;
  try
    FLX_WriteLog('SOUND', Msg);
  except
  end;
end;

function GetSoundBaseDir: string;
var
  ExeDir: string;
begin
  ExeDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));

  // Caso 1: ejecutable en /usr/bin
  if SameText(ExeDir, '/usr/bin/') then
  begin
    Result := IncludeTrailingPathDelimiter(RutaSql) + 'sounds' + DirectorySeparator;
    Exit;
  end;

  // Caso 2: ejecutable fuera de /usr/bin → ../sounds/
  Result := ExpandFileName(ExeDir + '..' + DirectorySeparator + 'sounds') + DirectorySeparator;
end;

function IsExecutableFile(const Fn: string): Boolean;
begin
  Result := (Fn <> '') and FileExists(Fn) and (fpAccess(PChar(Fn), X_OK) = 0);
end;

function FindExeInPATH(const ExeName: string): string;
var
  PathEnv, OneDir, Candidate: string;
  P, Start: Integer;
begin
  Result := '';

  if (Pos(DirectorySeparator, ExeName) > 0) then
  begin
    if IsExecutableFile(ExeName) then Exit(ExeName) else Exit('');
  end;

  PathEnv := GetEnvironmentVariable('PATH');
  if Trim(PathEnv) = '' then Exit('');

  Start := 1;
  while Start <= Length(PathEnv) do
  begin
    P := Start;
    while (P <= Length(PathEnv)) and (PathEnv[P] <> PathSeparator) do Inc(P);

    OneDir := Copy(PathEnv, Start, P - Start);
    if OneDir <> '' then
    begin
      Candidate := IncludeTrailingPathDelimiter(OneDir) + ExeName;
      if IsExecutableFile(Candidate) then Exit(Candidate);
    end;

    Start := P + 1;
  end;
end;

function FindExeSmart(const ExeName: string): string;
const
  CommonDirs: array[0..2] of string = ('/usr/bin', '/bin', '/usr/local/bin');
var
  I: Integer;
  Candidate: string;
begin
  Result := FindExeInPATH(ExeName);
  if Result <> '' then Exit;

  for I := Low(CommonDirs) to High(CommonDirs) do
  begin
    Candidate := IncludeTrailingPathDelimiter(CommonDirs[I]) + ExeName;
    if IsExecutableFile(Candidate) then Exit(Candidate);
  end;

  Result := '';
end;

function LaunchProcess(const ExeName: string; const Params: array of string): Boolean;
var
  P: TProcess;
  I: Integer;
  SS: TStringStream;
  OutTxt, ErrTxt: string;
begin
  Result := False;
  if Trim(ExeName) = '' then Exit;

  P := TProcess.Create(nil);
  try
    P.Executable := ExeName;

    for I := Low(Params) to High(Params) do
      if Trim(Params[I]) <> '' then
        P.Parameters.Add(Params[I]);

    if GDebugSound then
      P.Options := [poUsePipes, poNoConsole, poWaitOnExit]
    else
      P.Options := [poNoConsole];

    try
      P.Execute;

      if GDebugSound then
      begin
        SS := TStringStream.Create('');
        try
          SS.CopyFrom(P.Output, 0);
          OutTxt := SS.DataString;
          SS.Clear;
          SS.CopyFrom(P.Stderr, 0);
          ErrTxt := SS.DataString;
        finally
          SS.Free;
        end;

        SoundLog('ExitStatus=' + IntToStr(P.ExitStatus));
        if Trim(OutTxt) <> '' then SoundLog('STDOUT: ' + Trim(OutTxt));
        if Trim(ErrTxt) <> '' then SoundLog('STDERR: ' + Trim(ErrTxt));
      end;

      Result := True;
    except
      on E: Exception do
      begin
        SoundLog('Execute exception: ' + E.ClassName + ': ' + E.Message);
        Result := False;
      end;
    end;

  finally
    P.Free;
  end;
end;

function RunAndCapture(const ExeName: string; const Params: array of string; out OutputText: string): Boolean;
var
  P: TProcess;
  SS: TStringStream;
  I: Integer;
begin
  Result := False;
  OutputText := '';
  if Trim(ExeName) = '' then Exit;

  P := TProcess.Create(nil);
  try
    P.Executable := ExeName;
    for I := Low(Params) to High(Params) do
      P.Parameters.Add(Params[I]);

    P.Options := [poUsePipes, poNoConsole, poWaitOnExit];

    try
      P.Execute;
      SS := TStringStream.Create('');
      try
        SS.CopyFrom(P.Output, 0);
        OutputText := SS.DataString;
      finally
        SS.Free;
      end;
      Result := (P.ExitStatus = 0);
    except
      Result := False;
    end;
  finally
    P.Free;
  end;
end;

function TrimLeftSpaces(const S: string): string;
var
  I: Integer;
begin
  I := 1;
  while (I <= Length(S)) and (S[I] in [' ', #9]) do Inc(I);
  Result := Copy(S, I, MaxInt);
end;

function TryParseIntAfter(const Line, Key: string; out N: Integer): Boolean;
var
  P, I: Integer;
  Num: string;
begin
  Result := False;
  N := 0;

  P := Pos(Key, Line);
  if P <= 0 then Exit;
  P := P + Length(Key);

  while (P <= Length(Line)) and (Line[P] = ' ') do Inc(P);

  Num := '';
  I := P;
  while (I <= Length(Line)) and (Line[I] in ['0'..'9']) do
  begin
    Num := Num + Line[I];
    Inc(I);
  end;

  if Num = '' then Exit;

  try
    N := StrToInt(Num);
    Result := True;
  except
    Result := False;
  end;
end;

// NUEVA autodetección: devuelve preferido y también candidatos HDMI/Analog
function AutoDetectALSAHwFromAplayList(const AplayExe: string; out DevHDMI, DevAnalog: string): string;
var
  Txt: string;
  SL: TStringList;
  I: Integer;
  CardN, DevN: Integer;
  Line, LTrim, Up: string;
  CurCard: Integer;

  HasHDMI, HasMonitorName, IsAnalog: Boolean;

  FirstHDMI: string;
  BestHDMIWithName: string;
  BestAnalog: string;
begin
  Result := '';
  DevHDMI := '';
  DevAnalog := '';
  FirstHDMI := '';
  BestHDMIWithName := '';
  BestAnalog := '';

  if not RunAndCapture(AplayExe, ['-l'], Txt) then Exit;
  if Trim(Txt) = '' then Exit;

  SL := TStringList.Create;
  try
    SL.Text := Txt;
    CurCard := -1;

    for I := 0 to SL.Count - 1 do
    begin
      Line := SL[I];
      LTrim := TrimLeftSpaces(Line);

      if Pos('card ', LTrim) = 1 then
      begin
        if TryParseIntAfter(LTrim, 'card ', CardN) then
          CurCard := CardN;

        if (CurCard >= 0) and TryParseIntAfter(LTrim, 'device ', DevN) then
        begin
          Up := UpperCase(LTrim);

          HasHDMI := (Pos('HDMI', Up) > 0);
          IsAnalog := (Pos('ANALOG', Up) > 0);

          HasMonitorName := HasHDMI and (Pos('[', LTrim) > 0) and (Pos(']', LTrim) > Pos('[', LTrim));

          if IsAnalog and (BestAnalog = '') then
            BestAnalog := 'hw:' + IntToStr(CurCard) + ',' + IntToStr(DevN);

          if HasHDMI then
          begin
            if (FirstHDMI = '') then
              FirstHDMI := 'hw:' + IntToStr(CurCard) + ',' + IntToStr(DevN);

            if HasMonitorName and (BestHDMIWithName = '') then
              BestHDMIWithName := 'hw:' + IntToStr(CurCard) + ',' + IntToStr(DevN);
          end;
        end;
      end;
    end;

    if BestHDMIWithName <> '' then DevHDMI := BestHDMIWithName
    else DevHDMI := FirstHDMI;

    DevAnalog := BestAnalog;

    // Preferencia final (para tu casa: HDMI con nombre manda)
    if BestHDMIWithName <> '' then Result := BestHDMIWithName
    else if BestAnalog <> '' then Result := BestAnalog
    else Result := FirstHDMI;

  finally
    SL.Free;
  end;
end;

procedure DetectBackend;
begin
  if GDetected then Exit;
  GDetected := True;

  GPaPlayExe := FindExeSmart('paplay');
  GHavePaPlay := (GPaPlayExe <> '');

  GAPlayExe := FindExeSmart('aplay');
  GHaveAPlay := (GAPlayExe <> '');

  if not GHaveAPlay then
  begin
    if IsExecutableFile('/usr/bin/aplay') then
    begin
      GAPlayExe := '/usr/bin/aplay';
      GHaveAPlay := True;
    end;
  end;

  // Autodetección ALSA
  if GHaveAPlay and GAutoDetectALSADevice and (Trim(GALSAAudioDevice) = '') then
  begin
    GALSAAudioDevice := AutoDetectALSAHwFromAplayList(GAPlayExe, GALSADefaultHDMI, GALSADefaultAnalog);

    SoundLog('AutoDetect: ALSADevice="' + GALSAAudioDevice +
             '" HDMI="' + GALSADefaultHDMI + '" Analog="' + GALSADefaultAnalog + '"');
  end;
end;

procedure FLX_Sound_Init;
var
  BaseDir: string;
begin
  BaseDir := GetSoundBaseDir;

  GFileInfo    := BaseDir + 'beep.wav';
  GFileOk      := BaseDir + 'ok.wav';
  GFileError   := BaseDir + 'error.wav';
  GFileWarning := BaseDir + 'warning.wav';

  SoundLog('Init: BaseDir="' + BaseDir + '"');
  SoundLog('Init: FileInfo="' + GFileInfo + '" Exists=' + BoolToStr(FileExists(GFileInfo), True));

  if not FileExists(GFileOk) then GFileOk := GFileInfo;
  if not FileExists(GFileError) then GFileError := GFileInfo;
  if not FileExists(GFileWarning) then GFileWarning := GFileInfo;

  DetectBackend;
end;

procedure FLX_Sound_Enable(const Enable: Boolean);
begin
  GEnabled := Enable;
end;

function FLX_Sound_IsEnabled: Boolean;
begin
  Result := GEnabled;
end;

procedure FLX_Sound_SetALSADevice(const Dev: string);
begin
  GALSAAudioDevice := Trim(Dev);
end;

procedure FLX_Sound_SetAutoDetectALSADevice(const Enable: Boolean);
begin
  GAutoDetectALSADevice := Enable;
end;

procedure FLX_Sound_SetFiles(const InfoFile, OkFile, ErrorFile, WarningFile: string);
begin
  if Trim(InfoFile) <> '' then GFileInfo := InfoFile;
  if Trim(OkFile) <> '' then GFileOk := OkFile;
  if Trim(ErrorFile) <> '' then GFileError := ErrorFile;
  if Trim(WarningFile) <> '' then GFileWarning := WarningFile;
end;

procedure FLX_Sound_LoadFromIni(const IniFileName: string);
var
  Ini: TIniFile;
  S: string;
begin
  if Trim(IniFileName) = '' then Exit;
  if not FileExists(IniFileName) then Exit;

  Ini := TIniFile.Create(IniFileName);
  try
    GEnabled := (Ini.ReadString('Sound', 'Enabled', '1') <> '0');

    S := Trim(Ini.ReadString('Sound', 'AutoDetectALSADevice', '1'));
    GAutoDetectALSADevice := (S <> '0');

    S := Trim(Ini.ReadString('Sound', 'ALSADevice', ''));
    if S <> '' then
      GALSAAudioDevice := S;

    S := Trim(Ini.ReadString('Sound', 'InfoFile', ''));
    if S <> '' then GFileInfo := S;

    S := Trim(Ini.ReadString('Sound', 'OkFile', ''));
    if S <> '' then GFileOk := S;

    S := Trim(Ini.ReadString('Sound', 'ErrorFile', ''));
    if S <> '' then GFileError := S;

    S := Trim(Ini.ReadString('Sound', 'WarningFile', ''));
    if S <> '' then GFileWarning := S;

  finally
    Ini.Free;
  end;
end;

function FLX_PlaySoundFile(const AFileName: string): Boolean;
begin
  Result := False;

  if not GEnabled then Exit;

  DetectBackend;

  SoundLog('Play request. Enabled=' + BoolToStr(GEnabled, True) +
           ' File="' + AFileName + '" Exists=' + BoolToStr(FileExists(AFileName), True));

  SoundLog('Backend: HavePaPlay=' + BoolToStr(GHavePaPlay, True) +
           ' PaPlayExe="' + GPaPlayExe + '"' +
           ' HaveAPlay=' + BoolToStr(GHaveAPlay, True) +
           ' APlayExe="' + GAPlayExe + '"' +
           ' ALSADevice="' + GALSAAudioDevice + '"' +
           ' HDMI="' + GALSADefaultHDMI + '"' +
           ' Analog="' + GALSADefaultAnalog + '"' +
           ' AutoDetect=' + BoolToStr(GAutoDetectALSADevice, True));

  if (Trim(AFileName) = '') or (not FileExists(AFileName)) then Exit;

  // aplay primero (como pediste)
  if GHaveAPlay then
  begin
    // 1) DEFAULT (sin -D): lo más robusto y lo que te funciona en AIO desde terminal
    Result := LaunchProcess(GAPlayExe, [AFileName]);
    if Result then Exit;

    // 2) HDMI detectado (si existe)
    if Trim(GALSADefaultHDMI) <> '' then
    begin
      Result := LaunchProcess(GAPlayExe, ['-D', GALSADefaultHDMI, AFileName]);
      if Result then Exit;
    end;

    // 3) Analog detectado (si existe)
    if Trim(GALSADefaultAnalog) <> '' then
    begin
      Result := LaunchProcess(GAPlayExe, ['-D', GALSADefaultAnalog, AFileName]);
      if Result then Exit;
    end;

    // 4) Compatibilidad: el ALSADevice calculado o fijado manualmente
    if Trim(GALSAAudioDevice) <> '' then
    begin
      Result := LaunchProcess(GAPlayExe, ['-D', GALSAAudioDevice, AFileName]);
      if Result then Exit;
    end;

    Exit;
  end;

  // paplay después
  if GHavePaPlay then
  begin
    Result := LaunchProcess(GPaPlayExe, [AFileName]);
    Exit;
  end;

  Result := False;
end;

procedure FLX_Beep(const Kind: TFLXSoundKind);
var
  Fn: string;
begin
  if (not GDetected) or (Trim(GFileInfo) = '') then FLX_Sound_Init;
  if not GEnabled then Exit;

  case Kind of
    skInfo   : Fn := GFileInfo;
    skOk     : Fn := GFileOk;
    skError  : Fn := GFileError;
    skWarning: Fn := GFileWarning;
  else
    Fn := GFileInfo;
  end;

  FLX_PlaySoundFile(Fn);
end;

end.
