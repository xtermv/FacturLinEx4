unit uFLXUpdater;

{$mode objfpc}{$H+}

interface

procedure FLX_UpdateCheckAtStartup(const AIniFile, ACurrentExecutable: string);

implementation

uses
  Classes, SysUtils, StrUtils, IniFiles, Dialogs, Process, Forms, BaseUnix, fphttpclient, opensslsockets;

const
  FLX_UPD_SECTION = 'Actualizaciones';

function DefaultUpdateLogFile(const AIniFile: string): string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(AIniFile)) + 'logs' +
            DirectorySeparator + 'actualizaciones.log';
end;

function EnsureLogFolder(const LogFile: string; out Info: string): Boolean;
var
  Dir: string;
begin
  Result := True;
  Info := '';
  Dir := ExtractFileDir(Trim(LogFile));
  if Dir = '' then Exit;
  if DirectoryExists(Dir) then
  begin
    Info := 'Carpeta de log existente: ' + Dir;
    Exit;
  end;
  Result := ForceDirectories(Dir);
  if Result then
    Info := 'Carpeta de log creada automáticamente: ' + Dir
  else
    Info := 'No se pudo crear la carpeta de log: ' + Dir;
end;

procedure FLXLog(const LogFile, Text: string);
var
  F: TextFile;
  Dir: string;
begin
  if Trim(LogFile) = '' then Exit;
  try
    Dir := ExtractFileDir(LogFile);
    if Dir <> '' then ForceDirectories(Dir);
    AssignFile(F, LogFile);
    if FileExists(LogFile) then Append(F) else Rewrite(F);
    try
      Writeln(F, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + '  ' + Text);
    finally
      CloseFile(F);
    end;
  except
    { El log nunca debe impedir arrancar FacturLinEx }
  end;
end;

procedure FLXLogBlock(const LogFile, Title, Text: string);
var
  SL: TStringList;
  I: Integer;
begin
  FLXLog(LogFile, '--- ' + Title + ' ---');
  SL := TStringList.Create;
  try
    SL.Text := Text;
    for I := 0 to SL.Count - 1 do
      if Trim(SL[I]) <> '' then
        FLXLog(LogFile, SL[I]);
  finally
    SL.Free;
  end;
end;

function EnsureTrailingSlash(const S: string): string;
begin
  Result := Trim(S);
  if Result = '' then Exit;
  if Result[Length(Result)] <> '/' then
    Result := Result + '/';
end;

function IsHTTP(const S: string): Boolean;
var
  L: string;
begin
  L := LowerCase(Trim(S));
  Result := (Pos('http://', L) = 1) or (Pos('https://', L) = 1);
end;

function StripFilePrefix(const S: string): string;
begin
  Result := S;
  if Pos('file://', LowerCase(Result)) = 1 then
    Result := Copy(Result, 8, MaxInt);
end;


function FLXCopyFileStream(const Src, Dst: string; out Err: string): Boolean;
var
  InS, OutS: TFileStream;
begin
  Result := False;
  Err := '';
  InS := nil;
  OutS := nil;
  try
    ForceDirectories(ExtractFileDir(Dst));
    InS := TFileStream.Create(Src, fmOpenRead or fmShareDenyNone);
    OutS := TFileStream.Create(Dst, fmCreate);
    OutS.CopyFrom(InS, 0);
    Result := True;
  except
    on E: Exception do
    begin
      Err := E.Message;
      Result := False;
    end;
  end;
  OutS.Free;
  InS.Free;
end;

function RunCommandCapture(const Exe: string; const Params: array of string; out OutputText: string): Integer;
var
  P: TProcess;
  SL: TStringList;
  I: Integer;
begin
  Result := -1;
  OutputText := '';
  P := TProcess.Create(nil);
  SL := TStringList.Create;
  try
    P.Executable := Exe;
    for I := Low(Params) to High(Params) do
      P.Parameters.Add(Params[I]);
    P.Options := [poUsePipes, poWaitOnExit, poStderrToOutPut];
    try
      P.Execute;
      SL.LoadFromStream(P.Output);
      OutputText := SL.Text;
      Result := P.ExitStatus;
    except
      on E: Exception do
      begin
        OutputText := E.Message;
        Result := -1;
      end;
    end;
  finally
    SL.Free;
    P.Free;
  end;
end;

function FirstLine(const S: string): string;
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Text := S;
    if L.Count > 0 then Result := Trim(L[0]) else Result := '';
  finally
    L.Free;
  end;
end;

function CommandExists(const Cmd: string): Boolean;
var
  OutText: string;
begin
  Result := RunCommandCapture('/usr/bin/which', [Cmd], OutText) = 0;
end;

function FetchText(const BaseURL, FileName: string; out Text, Err: string): Boolean;
var
  URL, LocalPath: string;
  HTTP: TFPHTTPClient;
  SL: TStringList;
begin
  Result := False;
  Text := '';
  Err := '';
  URL := EnsureTrailingSlash(BaseURL) + FileName;

  try
    if IsHTTP(URL) then
    begin
      HTTP := TFPHTTPClient.Create(nil);
      try
        HTTP.AllowRedirect := True;
        HTTP.ConnectTimeout := 5000;
        HTTP.IOTimeout := 8000;
        Text := HTTP.Get(URL);
        Result := True;
      finally
        HTTP.Free;
      end;
    end
    else
    begin
      LocalPath := StripFilePrefix(URL);
      if not FileExists(LocalPath) then
      begin
        Err := 'No existe el fichero: ' + LocalPath;
        Exit;
      end;
      SL := TStringList.Create;
      try
        SL.LoadFromFile(LocalPath);
        Text := SL.Text;
        Result := True;
      finally
        SL.Free;
      end;
    end;
  except
    on E: Exception do
    begin
      Err := E.Message;
      Result := False;
    end;
  end;
end;

function DownloadFileFromSource(const BaseURL, FileName, DestFile: string; out Err: string): Boolean;
var
  URL, LocalPath: string;
  HTTP: TFPHTTPClient;
  MS: TMemoryStream;
begin
  Result := False;
  Err := '';
  URL := EnsureTrailingSlash(BaseURL) + FileName;
  try
    ForceDirectories(ExtractFileDir(DestFile));
    if IsHTTP(URL) then
    begin
      HTTP := TFPHTTPClient.Create(nil);
      MS := TMemoryStream.Create;
      try
        HTTP.AllowRedirect := True;
        HTTP.ConnectTimeout := 5000;
        HTTP.IOTimeout := 30000;
        HTTP.Get(URL, MS);
        MS.SaveToFile(DestFile);
        Result := True;
      finally
        MS.Free;
        HTTP.Free;
      end;
    end
    else
    begin
      LocalPath := StripFilePrefix(URL);
      if not FileExists(LocalPath) then
      begin
        Err := 'No existe el fichero a descargar: ' + LocalPath;
        Exit;
      end;
      if not FLXCopyFileStream(LocalPath, DestFile, Err) then
      begin
        Err := 'No se pudo copiar desde:' + LineEnding + LocalPath + LineEnding +
               'hasta:' + LineEnding + DestFile + LineEnding + Err;
        Exit;
      end;
      Result := True;
    end;
  except
    on E: Exception do
    begin
      Err := E.Message;
      Result := False;
    end;
  end;
end;

function LocalSHA256(const FileName: string; out Hash, Err: string): Boolean;
var
  OutText: string;
begin
  Result := False;
  Hash := '';
  Err := '';
  if not FileExists(FileName) then
  begin
    Err := 'No existe para SHA256: ' + FileName;
    Exit;
  end;
  if not CommandExists('sha256sum') then
  begin
    Err := 'No se encontró el comando sha256sum.';
    Exit;
  end;
  if RunCommandCapture('/usr/bin/sha256sum', [FileName], OutText) <> 0 then
  begin
    Err := OutText;
    Exit;
  end;
  Hash := Trim(ExtractWord(1, OutText, [' ', #9]));
  Result := Hash <> '';
end;

function CheckLddOK(const FileName: string; out LddText, Err: string): Boolean;
begin
  Result := False;
  LddText := '';
  Err := '';
  if not FileExists(FileName) then
  begin
    Err := 'No existe para ldd: ' + FileName;
    Exit;
  end;
  if not CommandExists('ldd') then
  begin
    Err := 'No se encontró el comando ldd.';
    Exit;
  end;
  RunCommandCapture('/usr/bin/ldd', [FileName], LddText);
  Result := Pos('not found', LowerCase(LddText)) = 0;
end;


function CreateInstallScript(const TmpDir: string; out ScriptFile, Err: string): Boolean;
var
  SL: TStringList;
begin
  Result := False;
  Err := '';
  ScriptFile := IncludeTrailingPathDelimiter(TmpDir) + 'flx_instalar_actualizacion.sh';
  SL := TStringList.Create;
  try
    try
      ForceDirectories(TmpDir);
      SL.Add('#!/bin/sh');
      SL.Add('set -e');
      SL.Add('SRC="$1"');
      SL.Add('DST="$2"');
      SL.Add('TMPDIR="$3"');
      SL.Add('if [ -z "$SRC" ] || [ -z "$DST" ] || [ -z "$TMPDIR" ]; then');
      SL.Add('  echo "Parametros insuficientes"');
      SL.Add('  exit 10');
      SL.Add('fi');
      SL.Add('if [ ! -f "$SRC" ]; then');
      SL.Add('  echo "No existe el ejecutable descargado: $SRC"');
      SL.Add('  exit 11');
      SL.Add('fi');
      SL.Add('if [ ! -f "$DST" ]; then');
      SL.Add('  echo "No existe el ejecutable local: $DST"');
      SL.Add('  exit 12');
      SL.Add('fi');
      SL.Add('STAMP=$(date +%Y%m%d_%H%M%S)');
      SL.Add('BAK="$DST.bak_$STAMP"');
      SL.Add('cp -p "$DST" "$BAK"');
      SL.Add('install -m 755 "$SRC" "$DST"');
      SL.Add('chmod 755 "$DST"');
      SL.Add('echo "$BAK" > "$TMPDIR/ultimo_backup.txt"');
      SL.Add('echo "Actualizacion instalada correctamente"');
      SL.SaveToFile(ScriptFile);
      RunCommandCapture('/bin/chmod', ['755', ScriptFile], Err);
      Result := True;
    except
      on E: Exception do
      begin
        Err := E.Message;
        Result := False;
      end;
    end;
  finally
    SL.Free;
  end;
end;

function ReadSmallTextFile(const FileName: string): string;
var
  SL: TStringList;
begin
  Result := '';
  if not FileExists(FileName) then Exit;
  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName);
    Result := Trim(SL.Text);
  finally
    SL.Free;
  end;
end;

function InstallDownloadedExecutable(const DownloadedFile, ExeLocal, TmpDir: string; out OutText, Err: string): Boolean;
var
  ScriptFile: string;
  ExitCode: Integer;
begin
  Result := False;
  OutText := '';
  Err := '';
  if not CommandExists('pkexec') then
  begin
    Err := 'No se encontró pkexec. No se puede sustituir el ejecutable en /usr/bin desde el programa.';
    Exit;
  end;
  if not CreateInstallScript(TmpDir, ScriptFile, Err) then Exit;
  ExitCode := RunCommandCapture('/usr/bin/pkexec', [ScriptFile, DownloadedFile, ExeLocal, TmpDir], OutText);
  if ExitCode <> 0 then
  begin
    Err := 'pkexec devolvió código ' + IntToStr(ExitCode) + LineEnding + OutText;
    Exit;
  end;
  Result := True;
end;

function CreateRelaunchScript(const TmpDir: string; out ScriptFile, Err: string): Boolean;
var
  SL: TStringList;
begin
  Result := False;
  Err := '';
  ScriptFile := IncludeTrailingPathDelimiter(TmpDir) + 'flx_relaunch_wait.sh';
  ForceDirectories(TmpDir);
  SL := TStringList.Create;
  try
    SL.Add('#!/bin/sh');
    SL.Add('OLDPID="$1"');
    SL.Add('EXE="$2"');
    SL.Add('LOG="$3"');
    SL.Add('echo "$(date ''+%F %T'') [RELAUNCH] Esperando cierre de PID antiguo: $OLDPID" >> "$LOG" 2>/dev/null');
    SL.Add('I=0');
    SL.Add('while kill -0 "$OLDPID" 2>/dev/null; do');
    SL.Add('  I=$((I+1))');
    SL.Add('  if [ "$I" -gt 60 ]; then');
    SL.Add('    echo "$(date ''+%F %T'') [RELAUNCH] Tiempo agotado esperando cierre. No se lanza nueva instancia." >> "$LOG" 2>/dev/null');
    SL.Add('    exit 1');
    SL.Add('  fi');
    SL.Add('  sleep 1');
    SL.Add('done');
    SL.Add('echo "$(date ''+%F %T'') [RELAUNCH] PID antiguo cerrado. Lanzando: $EXE" >> "$LOG" 2>/dev/null');
    SL.Add('nohup "$EXE" >/dev/null 2>&1 &');
    SL.Add('echo "$(date ''+%F %T'') [RELAUNCH] Nueva instancia lanzada." >> "$LOG" 2>/dev/null');
    try
      SL.SaveToFile(ScriptFile);
      fpChmod(ScriptFile, &755);
      Result := True;
    except
      on E: Exception do
      begin
        Err := E.Message;
        Result := False;
      end;
    end;
  finally
    SL.Free;
  end;
end;

function RelaunchFacturLinExAfterExit(const ExeLocal, TmpDir, LogFile: string; out Err: string): Boolean;
var
  P: TProcess;
  ScriptFile: string;
begin
  Result := False;
  Err := '';
  if not FileExists(ExeLocal) then
  begin
    Err := 'No existe el ejecutable para relanzar: ' + ExeLocal;
    Exit;
  end;
  if not CreateRelaunchScript(TmpDir, ScriptFile, Err) then Exit;

  P := TProcess.Create(nil);
  try
    P.Executable := '/bin/sh';
    P.Parameters.Add(ScriptFile);
    P.Parameters.Add(IntToStr(fpGetPid));
    P.Parameters.Add(ExeLocal);
    P.Parameters.Add(LogFile);
    P.Options := [];
    try
      P.Execute;
      Result := True;
    except
      on E: Exception do
      begin
        Err := E.Message;
        Result := False;
      end;
    end;
  finally
    P.Free;
  end;
end;

procedure EnsureDefaultIniValues(Ini: TIniFile; const ACurrentExecutable: string);
var
  ExeDefault: string;
begin
  ExeDefault := Ini.ReadString(FLX_UPD_SECTION, 'EjecutableLocal', '');
  if ExeDefault = '' then
  begin
    if FileExists('/usr/bin/FacturLinEx') then
      ExeDefault := '/usr/bin/FacturLinEx'
    else
      ExeDefault := ACurrentExecutable;
    Ini.WriteString(FLX_UPD_SECTION, 'EjecutableLocal', ExeDefault);
  end;

  if Ini.ReadString(FLX_UPD_SECTION, 'Activar', '') = '' then
    Ini.WriteString(FLX_UPD_SECTION, 'Activar', '0');
  if Ini.ReadString(FLX_UPD_SECTION, 'URL', '') = '' then
    Ini.WriteString(FLX_UPD_SECTION, 'URL', '');
  if Ini.ReadString(FLX_UPD_SECTION, 'Canal', '') = '' then
    Ini.WriteString(FLX_UPD_SECTION, 'Canal', 'estable');
  if Ini.ReadString(FLX_UPD_SECTION, 'VersionLocal', '') = '' then
    Ini.WriteString(FLX_UPD_SECTION, 'VersionLocal', '');
  if Ini.ReadString(FLX_UPD_SECTION, 'ComprobarAlInicio', '') = '' then
    Ini.WriteString(FLX_UPD_SECTION, 'ComprobarAlInicio', '1');
  if Ini.ReadString(FLX_UPD_SECTION, 'MantenerCopias', '') = '' then
    Ini.WriteString(FLX_UPD_SECTION, 'MantenerCopias', '5');
  if Ini.ReadString(FLX_UPD_SECTION, 'RutaTemporal', '') = '' then
    Ini.WriteString(FLX_UPD_SECTION, 'RutaTemporal', '/tmp/facturlinex_update');
  if Ini.ReadString(FLX_UPD_SECTION, 'PrepararDescarga', '') = '' then
    Ini.WriteString(FLX_UPD_SECTION, 'PrepararDescarga', '1');
  if Ini.ReadString(FLX_UPD_SECTION, 'PermitirInstalar', '') = '' then
    Ini.WriteString(FLX_UPD_SECTION, 'PermitirInstalar', '0');
  if Ini.ReadString(FLX_UPD_SECTION, 'PermitirSinSHA256', '') = '' then
    Ini.WriteString(FLX_UPD_SECTION, 'PermitirSinSHA256', '0');
  if Ini.ReadString(FLX_UPD_SECTION, 'LogFile', '') = '' then
    Ini.WriteString(FLX_UPD_SECTION, 'LogFile', DefaultUpdateLogFile(Ini.FileName));
  if Ini.ReadString(FLX_UPD_SECTION, 'ReiniciarTrasActualizar', '') = '' then
    Ini.WriteString(FLX_UPD_SECTION, 'ReiniciarTrasActualizar', '0');
end;

procedure FLX_UpdateCheckAtStartup(const AIniFile, ACurrentExecutable: string);
var
  Ini, RemoteIni: TIniFile;
  RemoteText, Err, URL, LocalVersion, RemoteVersion, ExeLocal: string;
  RemoteFileName, RemoteSHA, CanalLocal, CanalRemote, TmpDir, DownloadedFile: string;
  TmpFile: string;
  SLTmp: TStringList;
  DebianOut, LddOut, HashLocal, InstallOut, BackupFile, LogFile, RelaunchErr, LogDirInfo: string;
  Msg: string;
  NeedUpdate, SHAOK, LddOK, CanInstall, RequireSHA, RestartAfterUpdate: Boolean;
begin
  if not FileExists(AIniFile) then Exit;

  Ini := TIniFile.Create(AIniFile);
  try
    EnsureDefaultIniValues(Ini, ACurrentExecutable);
    LogFile := Trim(Ini.ReadString(FLX_UPD_SECTION, 'LogFile', DefaultUpdateLogFile(AIniFile)));
    EnsureLogFolder(LogFile, LogDirInfo);
    FLXLog(LogFile, 'Inicio comprobación actualizaciones. INI=' + AIniFile);
    if LogDirInfo <> '' then FLXLog(LogFile, LogDirInfo);

    if not Ini.ReadBool(FLX_UPD_SECTION, 'Activar', False) then
    begin
      FLXLog(LogFile, 'Actualizador desactivado.');
      Exit;
    end;
    if not Ini.ReadBool(FLX_UPD_SECTION, 'ComprobarAlInicio', True) then
    begin
      FLXLog(LogFile, 'ComprobarAlInicio=0.');
      Exit;
    end;

    URL := Trim(Ini.ReadString(FLX_UPD_SECTION, 'URL', ''));
    ExeLocal := Trim(Ini.ReadString(FLX_UPD_SECTION, 'EjecutableLocal', '/usr/bin/FacturLinEx'));
    LocalVersion := Trim(Ini.ReadString(FLX_UPD_SECTION, 'VersionLocal', ''));
    CanalLocal := Trim(Ini.ReadString(FLX_UPD_SECTION, 'Canal', 'estable'));
    TmpDir := Trim(Ini.ReadString(FLX_UPD_SECTION, 'RutaTemporal', '/tmp/facturlinex_update'));

    if URL = '' then
    begin
      ShowMessage('Actualizaciones activadas, pero falta URL en FacturConf.ini.' + LineEnding +
                  'Sección [Actualizaciones], clave URL.');
      Exit;
    end;

    if not FetchText(URL, 'version.ini', RemoteText, Err) then
    begin
      FLXLog(LogFile, 'ERROR comprobando version.ini: ' + Err);
      ShowMessage('No se pudo comprobar la actualización de FacturLinEx.' + LineEnding + Err);
      Exit;
    end;

    TmpFile := GetTempDir(False) + 'flx_version_' + IntToStr(GetTickCount64) + '.ini';
    SLTmp := TStringList.Create;
    try
      SLTmp.Text := RemoteText;
      SLTmp.SaveToFile(TmpFile);
    finally
      SLTmp.Free;
    end;

    RemoteIni := TIniFile.Create(TmpFile);
    try
      RemoteVersion := Trim(RemoteIni.ReadString('Version', 'Numero', ''));
      CanalRemote := Trim(RemoteIni.ReadString('Version', 'Canal', 'estable'));
      RemoteFileName := Trim(RemoteIni.ReadString('Version', 'Fichero', ''));
      RemoteSHA := LowerCase(Trim(RemoteIni.ReadString('Version', 'SHA256', '')));

      if RemoteVersion = '' then
      begin
        ShowMessage('El fichero version.ini remoto no contiene [Version] Numero.');
        Exit;
      end;

      if RemoteFileName = '' then
      begin
        ShowMessage('El fichero version.ini remoto no contiene [Version] Fichero.');
        Exit;
      end;

      RunCommandCapture('/bin/cat', ['/etc/debian_version'], DebianOut);

      NeedUpdate := (LocalVersion = '') or (LocalVersion <> RemoteVersion);
      CanInstall := Ini.ReadBool(FLX_UPD_SECTION, 'PermitirInstalar', False);
      RequireSHA := not Ini.ReadBool(FLX_UPD_SECTION, 'PermitirSinSHA256', False);
      RestartAfterUpdate := Ini.ReadBool(FLX_UPD_SECTION, 'ReiniciarTrasActualizar', False);
      FLXLog(LogFile, 'Local=' + LocalVersion + ' Remota=' + RemoteVersion + ' Canal=' + CanalLocal + ' URL=' + URL);

      Msg := 'Comprobación de actualizaciones FacturLinEx' + LineEnding + LineEnding +
             'Ejecutable local: ' + ExeLocal + LineEnding +
             'Versión local: ' + IfThen(LocalVersion <> '', LocalVersion, '(no indicada)') + LineEnding +
             'Versión servidor: ' + RemoteVersion + LineEnding +
             'Canal local: ' + CanalLocal + LineEnding +
             'Canal servidor: ' + CanalRemote + LineEnding +
             'Debian: ' + FirstLine(DebianOut) + LineEnding + LineEnding;

      if CanalLocal <> CanalRemote then
      begin
        Msg := Msg + 'AVISO: el canal local no coincide con el canal del servidor.' + LineEnding +
                     'No se preparará descarga.';
        ShowMessage(Msg);
        Exit;
      end;

      if not NeedUpdate then
      begin
        Msg := Msg + 'El equipo ya tiene registrada la última versión.';
        FLXLogBlock(LogFile, 'Sin actualización', Msg);
        ShowMessage(Msg);
        Exit;
      end;

      Msg := Msg + 'Hay una versión distinta disponible.' + LineEnding + LineEnding;

      if not Ini.ReadBool(FLX_UPD_SECTION, 'PrepararDescarga', True) then
      begin
        Msg := Msg + 'PrepararDescarga=0. Solo se informa, no se descarga nada.';
        ShowMessage(Msg);
        Exit;
      end;

      ForceDirectories(TmpDir);
      DownloadedFile := IncludeTrailingPathDelimiter(TmpDir) + RemoteFileName + '.descargado';

      if not DownloadFileFromSource(URL, RemoteFileName, DownloadedFile, Err) then
      begin
        Msg := Msg + 'No se pudo preparar la descarga:' + LineEnding + Err + LineEnding + LineEnding +
                     'No se ha modificado el ejecutable local.';
        FLXLogBlock(LogFile, 'Error descarga/preparación', Msg);
        ShowMessage(Msg);
        Exit;
      end;

      FLXLog(LogFile, 'Ejecutable preparado en ' + DownloadedFile);
      Msg := Msg + 'Descargado/preparado en:' + LineEnding + DownloadedFile + LineEnding + LineEnding;

      SHAOK := True;
      if RemoteSHA <> '' then
      begin
        SHAOK := False;
        if LocalSHA256(DownloadedFile, HashLocal, Err) then
        begin
          SHAOK := LowerCase(HashLocal) = RemoteSHA;
          Msg := Msg + 'SHA256 servidor: ' + RemoteSHA + LineEnding +
                       'SHA256 descargado: ' + LowerCase(HashLocal) + LineEnding;
          if SHAOK then
            Msg := Msg + 'SHA256: correcto.' + LineEnding + LineEnding
          else
            Msg := Msg + 'SHA256: NO COINCIDE. No debe instalarse.' + LineEnding + LineEnding;
        end
        else
          Msg := Msg + 'No se pudo calcular SHA256: ' + Err + LineEnding + LineEnding;
      end
      else
      begin
        SHAOK := not RequireSHA;
        Msg := Msg + 'SHA256 no indicado en version.ini.' + LineEnding;
        if RequireSHA then
          Msg := Msg + 'PermitirSinSHA256=0: por seguridad NO se instalará sin SHA256.' + LineEnding + LineEnding
        else
          Msg := Msg + 'PermitirSinSHA256=1: se permitirá continuar sin SHA256.' + LineEnding + LineEnding;
      end;

      if RemoteSHA <> '' then FLXLog(LogFile, 'SHA256 descargado=' + LowerCase(HashLocal) + ' esperado=' + RemoteSHA + ' OK=' + BoolToStr(SHAOK, True));

      LddOK := CheckLddOK(DownloadedFile, LddOut, Err);
      FLXLog(LogFile, 'ldd OK=' + BoolToStr(LddOK, True));
      if LddOK then
        Msg := Msg + 'ldd del nuevo ejecutable: correcto, sin dependencias not found.' + LineEnding
      else
      begin
        Msg := Msg + 'ldd del nuevo ejecutable: hay problemas.' + LineEnding;
        if Err <> '' then
          Msg := Msg + Err + LineEnding;
        if Pos('not found', LowerCase(LddOut)) > 0 then
          Msg := Msg + 'Hay dependencias no encontradas. No conviene actualizar este equipo.' + LineEnding;
      end;

      if FileExists(ExeLocal) then
      begin
        RunCommandCapture('/usr/bin/ldd', [ExeLocal], LddOut);
        if Pos('not found', LowerCase(LddOut)) > 0 then
          Msg := Msg + LineEnding + 'AVISO: el ejecutable local actual también tiene dependencias no encontradas según ldd.' + LineEnding;
      end
      else
        Msg := Msg + LineEnding + 'AVISO: no existe el ejecutable configurado: ' + ExeLocal + LineEnding;

      if not CommandExists('pkexec') then
        Msg := Msg + 'AVISO: no se encontró pkexec. Hará falta para reemplazar en /usr/bin.' + LineEnding;

      if (not SHAOK) or (not LddOK) then
      begin
        Msg := Msg + LineEnding +
               'RESULTADO: actualización NO apta en este equipo por ahora.' + LineEnding +
               'No se ha modificado el ejecutable local.';
        FLXLogBlock(LogFile, 'Actualización no apta', Msg);
        ShowMessage(Msg);
        Exit;
      end;

      if not CanInstall then
      begin
        Msg := Msg + LineEnding +
               'FASE 3 preparada, pero PermitirInstalar=0.' + LineEnding +
               'No se ha modificado el ejecutable local.' + LineEnding + LineEnding +
               'Para permitir instalación real, en FacturConf.ini:' + LineEnding +
               '[Actualizaciones]' + LineEnding +
               'PermitirInstalar=1';
        FLXLogBlock(LogFile, 'Instalación no permitida', Msg);
        ShowMessage(Msg);
        Exit;
      end;

      Msg := Msg + LineEnding +
             'La actualización está validada y puede instalarse.' + LineEnding + LineEnding +
             'Se creará una copia de seguridad del ejecutable actual:' + LineEnding +
             ExeLocal + '.bak_FECHA_HORA' + LineEnding + LineEnding +
             'Después se sustituirá:' + LineEnding +
             ExeLocal + LineEnding + LineEnding +
             '¿Desea instalar ahora la actualización?';

      if MessageDlg('Actualizar FacturLinEx', Msg, mtConfirmation, [mbYes, mbNo], 0) <> 6 then
      begin
        FLXLog(LogFile, 'Actualización validada, cancelada por el usuario.');
        Exit;
      end;

      if not InstallDownloadedExecutable(DownloadedFile, ExeLocal, TmpDir, InstallOut, Err) then
      begin
        FLXLog(LogFile, 'ERROR instalando actualización: ' + Err);
        if InstallOut <> '' then FLXLogBlock(LogFile, 'Salida instalación fallida', InstallOut);
        ShowMessage('No se pudo instalar la actualización.' + LineEnding + LineEnding + Err + LineEnding + LineEnding +
                    'No se ha confirmado ningún cambio definitivo desde FacturLinEx.');
        Exit;
      end;

      BackupFile := ReadSmallTextFile(IncludeTrailingPathDelimiter(TmpDir) + 'ultimo_backup.txt');
      Ini.WriteString(FLX_UPD_SECTION, 'VersionLocal', RemoteVersion);
      Ini.UpdateFile;

      FLXLog(LogFile, 'Actualización instalada OK. ' + LocalVersion + ' -> ' + RemoteVersion +
             ' Ejecutable=' + ExeLocal + ' Backup=' + BackupFile);
      if InstallOut <> '' then FLXLogBlock(LogFile, 'Salida instalación', InstallOut);

      if RestartAfterUpdate then
      begin
        FLXLog(LogFile, 'Reinicio automático activado por INI: ReiniciarTrasActualizar=1. Intentando relanzar.');
        ShowMessage('Actualización instalada correctamente.' + LineEnding + LineEnding +
                    'Ejecutable actualizado:' + LineEnding + ExeLocal + LineEnding + LineEnding +
                    'Copia de seguridad:' + LineEnding + IfThen(BackupFile <> '', BackupFile, '(no indicada por el script)') + LineEnding + LineEnding +
                    'FacturLinEx se reiniciará ahora para ejecutar la nueva versión.');
        if RelaunchFacturLinExAfterExit(ExeLocal, TmpDir, LogFile, RelaunchErr) then
        begin
          FLXLog(LogFile, 'Lanzador externo creado. Cerrando instancia anterior antes de abrir la nueva.');
          Application.Terminate;
        end
        else
        begin
          FLXLog(LogFile, 'ERROR relanzando ejecutable actualizado: ' + RelaunchErr);
          ShowMessage('La actualización se instaló, pero no se pudo relanzar FacturLinEx automáticamente.' + LineEnding + LineEnding +
                      RelaunchErr + LineEnding + LineEnding +
                      'Cierre FacturLinEx y vuelva a abrirlo manualmente.');
        end;
      end
      else
      begin
        FLXLog(LogFile, 'Reinicio automático desactivado por INI: ReiniciarTrasActualizar=0.');
        ShowMessage('Actualización instalada correctamente.' + LineEnding + LineEnding +
                    'Ejecutable actualizado:' + LineEnding + ExeLocal + LineEnding + LineEnding +
                    'Copia de seguridad:' + LineEnding + IfThen(BackupFile <> '', BackupFile, '(no indicada por el script)') + LineEnding + LineEnding +
                    'Cierre FacturLinEx y vuelva a abrirlo para ejecutar ya la nueva versión.' + LineEnding + LineEnding +
                    'Log:' + LineEnding + LogFile);
      end;
    finally
      RemoteIni.Free;
      if TmpFile <> '' then DeleteFile(TmpFile);
    end;
  finally
    Ini.Free;
  end;
end;

end.
