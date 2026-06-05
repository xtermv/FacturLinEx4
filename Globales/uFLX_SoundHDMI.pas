unit uFLX_Sound;

{$mode objfpc}{$H+}

{
  uFLX_Sound.pas
  --------------
  Sonido "beep" audible para apps GUI Lazarus en Linux.

  - En Linux GUI, Beep/bell/PC speaker NO es fiable.
  - Esta unidad reproduce sonidos reales vía:
      1) aplay  (ALSA) si existe  <-- PRIMERO (como pediste)
      2) paplay (PulseAudio/PipeWire) si existe

  WAV:
    - <BaseDir>/beep.wav
    - <BaseDir>/ok.wav
    - <BaseDir>/error.wav
    - <BaseDir>/warning.wav

  Autodetección ALSA:
    - Si NO se fija ALSADevice manualmente (o por INI),
      la unidad ejecuta: aplay -l
      y elige el mejor device con esta prioridad:
        1) HDMI con ELD válido (eld_valid 1)  <-- lo más fiable (monitor conectado)
        2) HDMI con nombre de monitor [....]
        3) Analog (AIO / placa base)
        4) vacío (aplay usará default)

  ELD:
    - Se consulta /proc/asound/cardX/eld#Y.Z
      buscando "eld_valid 1" y opcionalmente "monitor_name".

  Orden reproducción (sin bloquear):
    - aplay -D <detectado> file.wav
    - aplay file.wav (default)
    - aplay -D <analog> file.wav (si existe y es distinto)
    - aplay -D <hdmi> file.wav (si existe y es distinto)
    - paplay file.wav (si no hay aplay)

  Uso:
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

// Beep "audible"
procedure FLX_Beep(const Kind: TFLXSoundKind = skInfo);

// Reproduce un fichero concreto (normalmente WAV). Devuelve True si pudo lanzarlo.
function FLX_PlaySoundFile(const AFileName: string): Boolean;

implementation

uses
  Process, BaseUnix, IniFiles, uFLX_Log, Global;

var
  GEnabled: Boolean = True;

  GDebugSound: Boolean = True; // True para diagnosticar

  // Backend detectado
  GDetected  : Boolean = False;
  GHavePaPlay: Boolean = False;
  GHaveAPlay : Boolean = False;

  // Ejecutables encontrados (ruta completa)
  GPaPlayExe: string = '';
  GAPlayExe : string = '';

  // ALSA device elegido (final)
  GALSAAudioDevice: string = '';

  // Candidatos detectados (para fallback)
  GALSADefaultHDMI  : string = '';
  GALSADefaultAnalog: string = '';

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
    // RutaSql DEBE terminar con /
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

  // Si viene con ruta, comprobamos directo
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
  // 1) PATH
  Result := FindExeInPATH(ExeName);
  if Result <> '' then Exit;

  // 2) rutas típicas (muy importante en apps GUI lanzadas desde menú)
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

    // En debug, usamos pipes + wait para ver errores
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

function ReadSmallTextFile(const Fn: string): string;
var
  SL: TStringList;
begin
  Result := '';
  if (Fn = '') or (not FileExists(Fn)) then Exit;
  SL := TStringList.Create;
  try
    try
      SL.LoadFromFile(Fn);
      Result := SL.Text;
    except
      Result := '';
    end;
  finally
    SL.Free;
  end;
end;

function ELDFileFor(const CardN, DevN, SubN: Integer): string;
begin
  // /proc/asound/card1/eld#3.0
  Result := Format('/proc/asound/card%d/eld#%d.%d', [CardN, DevN, SubN]);
end;

function ELDIsValid(const EldText: string): Boolean;
var
  Up: string;
begin
  Up := UpperCase(EldText);
  // suele aparecer como: "eld_valid               1"
  Result := (Pos('ELD_VALID', Up) > 0) and (Pos('ELD_VALID', Up) < Pos('1', Up) + 100) and (Pos('ELD_VALID', Up) > 0) and (Pos('ELD_VALID', Up) > 0);
  // Mejor comprobación exacta:
  Result := (Pos('ELD_VALID', Up) > 0) and (Pos('ELD_VALID', Up) > 0) and (Pos('ELD_VALID', Up) > 0);
  // (La comprobación robusta va abajo, sin depender del formato)
  Result := (Pos('ELD_VALID', Up) > 0) and (Pos('ELD_VALID', Up) > 0);
  // Reemplazo por parse simple fiable:
  Result := (Pos('ELD_VALID', Up) > 0) and (Pos('ELD_VALID', Up) > 0);
end;

function ELDHasValid1(const EldText: string): Boolean;
var
  Up: string;
begin
  Up := UpperCase(EldText);
  // buscamos "ELD_VALID" y luego un "1" en la misma línea aprox.
  Result := (Pos('ELD_VALID', Up) > 0) and (Pos('ELD_VALID               1', Up) > 0);
  if Result then Exit;

  // fallback: "eld_valid 1"
  Result := (Pos('ELD_VALID 1', Up) > 0);
end;

function ELDMonitorName(const EldText: string): string;
var
  SL: TStringList;
  I: Integer;
  S, Key: string;
begin
  Result := '';
  Key := 'monitor_name';

  SL := TStringList.Create;
  try
    SL.Text := EldText;
    for I := 0 to SL.Count - 1 do
    begin
      S := Trim(SL[I]);
      if (Length(S) >= Length(Key)) and (Pos(Key, LowerCase(S)) = 1) then
      begin
        // "monitor_name            MSI MP275"
        Result := Trim(Copy(S, Length(Key) + 1, MaxInt));
        Exit;
      end;
    end;
  finally
    SL.Free;
  end;
end;

function HDMIHasValidELD(const CardN, DevN: Integer; out MonitorName: string): Boolean;
var
  EldFn, Txt: string;
  SubN: Integer;
begin
  Result := False;
  MonitorName := '';

  // Normalmente .0, pero probamos 0..3 por si el driver expone otra sub
  for SubN := 0 to 3 do
  begin
    EldFn := ELDFileFor(CardN, DevN, SubN);
    if not FileExists(EldFn) then Continue;

    Txt := ReadSmallTextFile(EldFn);
    if Trim(Txt) = '' then Continue;

    if ELDHasValid1(Txt) then
    begin
      MonitorName := ELDMonitorName(Txt);
      Result := True;
      Exit;
    end;
  end;
end;

function AutoDetectALSAHwFromAplayList(const AplayExe: string; out DevHDMI, DevAnalog: string): string;
var
  Txt: string;
  SL: TStringList;
  I: Integer;
  CardN, DevN: Integer;
  Line, LTrim: string;

  CurCard: Integer;

  Up: string;
  HasHDMI, HasMonitorName, IsAnalog: Boolean;

  BestHDMIValid: string;
  BestHDMIValidName: string;
  FirstHDMI: string;
  BestHDMIWithName: string;
  BestAnalog: string;

  MonName: string;
  HasELD: Boolean;
begin
  Result := '';
  DevHDMI := '';
  DevAnalog := '';

  BestHDMIValid := '';
  BestHDMIValidName := '';
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

          // Guardar Analog (primer analog encontrado)
          if IsAnalog and (BestAnalog = '') then
            BestAnalog := 'hw:' + IntToStr(CurCard) + ',' + IntToStr(DevN);

          if HasHDMI then
          begin
            if FirstHDMI = '' then
              FirstHDMI := 'hw:' + IntToStr(CurCard) + ',' + IntToStr(DevN);

            if HasMonitorName and (BestHDMIWithName = '') then
              BestHDMIWithName := 'hw:' + IntToStr(CurCard) + ',' + IntToStr(DevN);

            // ---- CLAVE: ELD válido (monitor conectado con audio real)
            MonName := '';
            HasELD := HDMIHasValidELD(CurCard, DevN, MonName);
            if HasELD and (BestHDMIValid = '') then
            begin
              BestHDMIValid := 'hw:' + IntToStr(CurCard) + ',' + IntToStr(DevN);
              BestHDMIValidName := MonName; // puede venir vacío
            end;

            // Si hay varios ELD válidos (raro), priorizamos el que tenga nombre
            if HasELD and (MonName <> '') and (BestHDMIValidName = '') then
            begin
              BestHDMIValid := 'hw:' + IntToStr(CurCard) + ',' + IntToStr(DevN);
              BestHDMIValidName := MonName;
            end;
          end;
        end;
      end;
    end;

    // Exportar candidatos
    if BestHDMIValid <> '' then
      DevHDMI := BestHDMIValid
    else if BestHDMIWithName <> '' then
      DevHDMI := BestHDMIWithName
    else
      DevHDMI := FirstHDMI;

    DevAnalog := BestAnalog;

    // Elección final (prioridad)
    if BestHDMIValid <> '' then
      Result := BestHDMIValid
    else if BestHDMIWithName <> '' then
      Result := BestHDMIWithName
    else if BestAnalog <> '' then
      Result := BestAnalog
    else
      Result := FirstHDMI;

    if GDebugSound then
    begin
      SoundLog('AutoDetect detail: HDMI_ELD="' + BestHDMIValid + '" MonName="' + BestHDMIValidName + '"');
      SoundLog('AutoDetect detail: HDMI_Name="' + BestHDMIWithName + '" HDMI_First="' + FirstHDMI + '" Analog="' + BestAnalog + '"');
    end;

  finally
    SL.Free;
  end;
end;

procedure DetectBackend;
begin
  if GDetected then Exit;
  GDetected := True;

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

  GPaPlayExe := FindExeSmart('paplay');
  GHavePaPlay := (GPaPlayExe <> '');

  // Autodetección ALSA hw:X,Y si NO lo han fijado manualmente/INI
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
  // si fijas manualmente, se usa tal cual
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

  SoundLog('Backend: HaveAPlay=' + BoolToStr(GHaveAPlay, True) +
           ' APlayExe="' + GAPlayExe + '"' +
           ' HavePaPlay=' + BoolToStr(GHavePaPlay, True) +
           ' PaPlayExe="' + GPaPlayExe + '"' +
           ' ALSADevice="' + GALSAAudioDevice + '"' +
           ' HDMI="' + GALSADefaultHDMI + '"' +
           ' Analog="' + GALSADefaultAnalog + '"' +
           ' AutoDetect=' + BoolToStr(GAutoDetectALSADevice, True));

  if (Trim(AFileName) = '') or (not FileExists(AFileName)) then Exit;

  // aplay primero (como pediste)
  if GHaveAPlay then
  begin
    // 1) Si tenemos device elegido (por ELD/HDMI/Analog), lo probamos primero
    if Trim(GALSAAudioDevice) <> '' then
    begin
      SoundLog('Launching aplay -D "' + GALSAAudioDevice + '"');
      Result := LaunchProcess(GAPlayExe, ['-D', GALSAAudioDevice, AFileName]);
      if Result then Exit;
    end;

    // 2) Default (sin -D): en AIO suele ser lo correcto
    SoundLog('Launching aplay default');
    Result := LaunchProcess(GAPlayExe, [AFileName]);
    if Result then Exit;

    // 3) Fallbacks: analog y hdmi detectados (si existen y son distintos)
    if (Trim(GALSADefaultAnalog) <> '') and (not SameText(Trim(GALSADefaultAnalog), Trim(GALSAAudioDevice))) then
    begin
      SoundLog('Launching aplay -D Analog "' + GALSADefaultAnalog + '"');
      Result := LaunchProcess(GAPlayExe, ['-D', GALSADefaultAnalog, AFileName]);
      if Result then Exit;
    end;

    if (Trim(GALSADefaultHDMI) <> '') and (not SameText(Trim(GALSADefaultHDMI), Trim(GALSAAudioDevice))) then
    begin
      SoundLog('Launching aplay -D HDMI "' + GALSADefaultHDMI + '"');
      Result := LaunchProcess(GAPlayExe, ['-D', GALSADefaultHDMI, AFileName]);
      if Result then Exit;
    end;

    Exit;
  end;

  // paplay después
  if GHavePaPlay then
  begin
    SoundLog('Launching paplay');
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
