unit uVF_CertTools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

{*
  Genera los ficheros PEM (CertFile, KeyFile, CAFile) a partir de un .p12
  usando OpenSSL, según la configuración en FacturConf.ini:

    [VeriFactuTLS]
    P12File=/ruta/al/certificado.p12
    P12Password=XXXXXXXX
    OpenSSLPath=openssl      ; opcional, si está en el PATH
    CertFile=/ruta/client_cert.pem
    KeyFile=/ruta/client_key.pem
    CAFile=/ruta/ca_chain.pem

  Devuelve:
    - True  si ya existían los PEM o se han generado correctamente.
    - False si ha habido algún error (detalle en Msg).
*}
function VF_TLS_EnsurePEMsFromP12(out Msg: string): Boolean;

implementation

uses
  IniFiles, Process, Global;

type
  TVFTLSIni = record
    P12File     : string;
    P12Password : string;
    OpenSSLPath : string;
    CertFile    : string;
    KeyFile     : string;
    CAFile      : string;
  end;

function HomeDir: string;
begin
  {$IFDEF UNIX}
  Result := GetEnvironmentVariable('HOME');
  {$ELSE}
  Result := GetEnvironmentVariable('USERPROFILE');
  {$ENDIF}
  if Result = '' then
    Result := GetCurrentDir;
end;

function VF_GetIniPath: string;
begin
  // Usamos tu lógica: si RutaIni está rellena, ahí vive FacturConf.ini
  if Trim(RutaIni) <> '' then
    Result := IncludeTrailingPathDelimiter(RutaIni) + 'FacturConf.ini'
  else
  {$IFDEF UNIX}
    Result := IncludeTrailingPathDelimiter(HomeDir) +
              '.facturlinex2' + DirectorySeparator + 'FacturConf.ini';
  {$ELSE}
    Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
              'FacturConf.ini';
  {$ENDIF}
end;

procedure EnsureDir(const APath: string);
begin
  if (APath <> '') and (not DirectoryExists(APath)) then
    ForceDirectories(APath);
end;

procedure VF_Log(const S: string);
var
  LogDir, FileName, Line: string;
begin
  try
    LogDir := IncludeTrailingPathDelimiter(HomeDir) +
      '.local' + DirectorySeparator + 'share' +
      DirectorySeparator + 'verifactu' + DirectorySeparator + 'logs';
    EnsureDir(LogDir);
    FileName := IncludeTrailingPathDelimiter(LogDir) + 'certtools.log';
    Line := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + '  ' + S + LineEnding;
    with TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone) do
    try
      Position := Size;
      WriteBuffer(Pointer(Line)^, Length(Line));
    finally
      Free;
    end;
  except
    // Nunca dejamos que un fallo de log rompa nada
  end;
end;

function VF_LoadTLSIni(out C: TVFTLSIni; out Err: string): Boolean;
var
  ini: TIniFile;
  fn: string;
begin
  Result := False;
  Err := '';
  FillChar(C, SizeOf(C), 0);

  fn := VF_GetIniPath;
  if not FileExists(fn) then
  begin
    Err := 'No se encuentra FacturConf.ini en: ' + fn;
    VF_Log(Err);
    Exit(False);
  end;

  ini := TIniFile.Create(fn);
  try
    C.P12File     := Trim(ini.ReadString('VeriFactuTLS', 'P12File', ''));
    C.P12Password := ini.ReadString('VeriFactuTLS', 'P12Password', '');
    C.OpenSSLPath := Trim(ini.ReadString('VeriFactuTLS', 'OpenSSLPath', ''));
    C.CertFile    := Trim(ini.ReadString('VeriFactuTLS', 'CertFile', ''));
    C.KeyFile     := Trim(ini.ReadString('VeriFactuTLS', 'KeyFile', ''));
    C.CAFile      := Trim(ini.ReadString('VeriFactuTLS', 'CAFile', ''));
  finally
    ini.Free;
  end;

  if C.OpenSSLPath = '' then
    C.OpenSSLPath := 'openssl';   // asumimos que está en el PATH

  if C.P12File = '' then
  begin
    Err := 'VeriFactuTLS.P12File vacío en FacturConf.ini';
    VF_Log(Err);
    Exit(False);
  end;

  if not FileExists(C.P12File) then
  begin
    Err := 'No se encuentra el fichero P12: ' + C.P12File;
    VF_Log(Err);
    Exit(False);
  end;

  // Si no se han definido rutas para Cert/Key/CA, proponemos rutas por defecto
  if C.CertFile = '' then
    C.CertFile := ChangeFileExt(C.P12File, '_cert.pem');
  if C.KeyFile = '' then
    C.KeyFile := ChangeFileExt(C.P12File, '_key.pem');
  if C.CAFile = '' then
    C.CAFile := ChangeFileExt(C.P12File, '_ca.pem');

  Result := True;
end;

function RunOpenSSL(const CmdLine: array of string; out Output, ErrOutput: string): Boolean;
var
  P: TProcess;
  i: Integer;
  SL, EL: TStringList;
begin
  Result := False;
  Output := '';
  ErrOutput := '';

  P := TProcess.Create(nil);
  SL := TStringList.Create;
  EL := TStringList.Create;
  try
    P.Options := [poUsePipes, poWaitOnExit];
    P.ShowWindow := swoHide;

    // Montamos CommandLine
    // CmdLine[0] = ruta a openssl, resto = params
    P.Executable := CmdLine[0];
    for i := 1 to High(CmdLine) do
      P.Parameters.Add(CmdLine[i]);

    try
      P.Execute;
    except
      on E: Exception do
      begin
        ErrOutput := 'No se pudo ejecutar OpenSSL: ' + E.Message;
        VF_Log(ErrOutput);
        Exit(False);
      end;
    end;

    // Leer stdout
    SL.LoadFromStream(P.Output);
    Output := SL.Text;

    // Leer stderr
    EL.LoadFromStream(P.Stderr);
    ErrOutput := EL.Text;

    Result := (P.ExitStatus = 0);
    if not Result then
      VF_Log(Format('OpenSSL exit=%d, stderr=%s', [P.ExitStatus, ErrOutput]));
  finally
    EL.Free;
    SL.Free;
    P.Free;
  end;
end;

function VF_GeneratePEMsFromP12(const C: TVFTLSIni; out Err: string): Boolean;
var
  OutDir: string;
  StdOut, StdErr: string;
  PassArg: string;
begin
  Result := False;
  Err := '';

  // Aseguramos directorios de salida
  OutDir := ExtractFilePath(C.CertFile);
  if OutDir <> '' then EnsureDir(OutDir);
  OutDir := ExtractFilePath(C.KeyFile);
  if OutDir <> '' then EnsureDir(OutDir);
  OutDir := ExtractFilePath(C.CAFile);
  if OutDir <> '' then EnsureDir(OutDir);

  if C.P12Password <> '' then
    PassArg := 'pass:' + C.P12Password
  else
    PassArg := '';

  // 1) Certificado cliente
  if FileExists(C.CertFile) then DeleteFile(C.CertFile);
  if C.P12Password <> '' then
  begin
    if not RunOpenSSL(
      [C.OpenSSLPath, 'pkcs12', '-legacy',
       '-in', C.P12File,
       '-clcerts', '-nokeys',
       '-out', C.CertFile,
       '-passin', PassArg],
       StdOut, StdErr) then
    begin
      Err := 'Error al extraer el certificado cliente (CertFile) desde el P12. ' + StdErr;
      Exit(False);
    end;
  end
  else
  begin
    if not RunOpenSSL(
      [C.OpenSSLPath, 'pkcs12', '-legacy',
       '-in', C.P12File,
       '-clcerts', '-nokeys',
       '-out', C.CertFile],
       StdOut, StdErr) then
    begin
      Err := 'Error al extraer el certificado cliente (CertFile) desde el P12. ' + StdErr;
      Exit(False);
    end;
  end;

  // 2) Clave privada (sin pass, -nodes)
  if FileExists(C.KeyFile) then DeleteFile(C.KeyFile);
  if C.P12Password <> '' then
  begin
    if not RunOpenSSL(
      [C.OpenSSLPath, 'pkcs12', '-legacy',
       '-in', C.P12File,
       '-nocerts', '-nodes',
       '-out', C.KeyFile,
       '-passin', PassArg],
       StdOut, StdErr) then
    begin
      Err := 'Error al extraer la clave privada (KeyFile) desde el P12. ' + StdErr;
      Exit(False);
    end;
  end
  else
  begin
    if not RunOpenSSL(
      [C.OpenSSLPath, 'pkcs12', '-legacy',
       '-in', C.P12File,
       '-nocerts', '-nodes',
       '-out', C.KeyFile],
       StdOut, StdErr) then
    begin
      Err := 'Error al extraer la clave privada (KeyFile) desde el P12. ' + StdErr;
      Exit(False);
    end;
  end;

  // 3) Certificados CA (cadena)
  if FileExists(C.CAFile) then DeleteFile(C.CAFile);
  if C.P12Password <> '' then
  begin
    if not RunOpenSSL(
      [C.OpenSSLPath, 'pkcs12', '-legacy',
       '-in', C.P12File,
       '-cacerts', '-nokeys',
       '-out', C.CAFile,
       '-passin', PassArg],
       StdOut, StdErr) then
    begin
      Err := 'Error al extraer la cadena CA (CAFile) desde el P12. ' + StdErr;
      Exit(False);
    end;
  end
  else
  begin
    if not RunOpenSSL(
      [C.OpenSSLPath, 'pkcs12', '-legacy',
       '-in', C.P12File,
       '-cacerts', '-nokeys',
       '-out', C.CAFile],
       StdOut, StdErr) then
    begin
      Err := 'Error al extraer la cadena CA (CAFile) desde el P12. ' + StdErr;
      Exit(False);
    end;
  end;

  // Comprobamos que realmente se han creado
  if (not FileExists(C.CertFile)) or
     (not FileExists(C.KeyFile)) or
     (not FileExists(C.CAFile)) then
  begin
    Err := 'No se han generado correctamente todos los ficheros PEM (CertFile/KeyFile/CAFile).';
    VF_Log(Err);
    Exit(False);
  end;

  Result := True;
end;

function VF_TLS_EnsurePEMsFromP12(out Msg: string): Boolean;
var
  C   : TVFTLSIni;
  Err : string;
begin
  Msg := '';
  Result := False;

  // 1) Cargar configuración INI
  if not VF_LoadTLSIni(C, Err) then
  begin
    Msg := Err;
    Exit(False);
  end;

  // 2) Si ya existen los tres ficheros, no hacemos nada
  if FileExists(C.CertFile) and FileExists(C.KeyFile) and FileExists(C.CAFile) then
  begin
    Msg := 'Ficheros PEM ya existentes. No es necesaria conversión.';
    VF_Log(Msg);
    Exit(True);
  end;

  // 3) Intentar generarlos
  if not VF_GeneratePEMsFromP12(C, Err) then
  begin
    Msg := Err;
    VF_Log('VF_TLS_EnsurePEMsFromP12: ' + Err);
    Exit(False);
  end;

  Msg := 'Conversión P12 → PEM completada correctamente.';
  VF_Log(Msg);
  Result := True;
end;

end.
