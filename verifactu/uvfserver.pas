unit uVFServer;

{$mode objfpc}{$H+}

{ Mini servidor local de pruebas para Veri*Factu
  - Endpoint principal (POST):  http://127.0.0.1:8080/verifactu/test
  - Endpoint de apagado (GET):  http://127.0.0.1:8080/__quit   (interno, usado en StopServer)
  - Guarda el cuerpo recibido en ~/.local/share/verifactu/incoming/
  - Responde JSON simulando OK o ERROR
      * ?mode=error             -> fuerza error 500
      * Header X-VF-Mode: ERROR -> fuerza error 500

  API pública:
    StartVFMockServer(APort: Word = 8080): Boolean;
    StopVFMockServer;
    VFMockServerIsRunning: Boolean;
}

interface

function StartVFMockServer(APort: Word = 8080): Boolean;
procedure StopVFMockServer;
function VFMockServerIsRunning: Boolean;

implementation

uses
  Classes, SysUtils, DateUtils,
  fphttpserver, httpdefs, fpjson, jsonparser, md5, fphttpclient;

type
  TVFMockServerThread = class(TThread)
  private
    FServer : TFPHTTPServer;
    FPort   : Word;
    procedure DoRequest(Sender: TObject; var ARequest: TFPHTTPConnectionRequest;
      var AResponse: TFPHTTPConnectionResponse);
    function  SaveIncoming(const Body: RawByteString; const SuggestedName: string): string;
    function  NowISO8601: string;
  protected
    procedure Execute; override;
  public
    constructor Create(APort: Word);
    destructor Destroy; override;
    procedure StopServer;
  end;

var
  GServerThread: TVFMockServerThread = nil;

{ ---------- Utilidades ---------- }

function ExpandTilde(const Path: string): string;
var
  Home: string;
begin
  Home := GetEnvironmentVariable('HOME');
  if (Home <> '') and (Copy(Path,1,2)='~/') then
    Result := IncludeTrailingPathDelimiter(Home) + Copy(Path,3,Length(Path))
  else
    Result := Path;
end;

function EnsureDir(const Dir: string): Boolean;
begin
  Result := True;
  if not DirectoryExists(Dir) then
    Result := ForceDirectories(Dir);
end;

function ExtractSafeFileName(const S: string): string;
var
  i: Integer;
begin
  Result := S;
  for i := 1 to Length(Result) do
    if not (Result[i] in ['A'..'Z','a'..'z','0'..'9','-','_','.']) then
      Result[i] := '_';
end;

const
  VF_LOG_RELATIVE = '~/.local/share/verifactu/mockserver.log';
  VF_LOG_MAX_SIZE = 5 * 1024 * 1024; // 5 MiB
  VF_LOG_BACKUPS  = 3;               // .1 .. .3

function GetFileSizeSafe(const FileName: string): Int64;
var
  FS: TFileStream;
begin
  Result := -1;
  try
    if FileExists(FileName) then
    begin
      FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
      try
        Result := FS.Size;
      finally
        FS.Free;
      end;
    end;
  except
    Result := -1;
  end;
end;

procedure RotateLogIfNeeded(const LogPath: string);
var
  Size: Int64;
  i: Integer;
  Base: string;
begin
  Size := GetFileSizeSafe(LogPath);
  if (Size >= 0) and (Size > VF_LOG_MAX_SIZE) then
  begin
    Base := LogPath;
    // Delete oldest
    if FileExists(Base + '.' + IntToStr(VF_LOG_BACKUPS)) then
      DeleteFile(Base + '.' + IntToStr(VF_LOG_BACKUPS));
    // Shift others
    for i := VF_LOG_BACKUPS - 1 downto 1 do
      if FileExists(Base + '.' + IntToStr(i)) then
        RenameFile(Base + '.' + IntToStr(i), Base + '.' + IntToStr(i+1));
    // Current -> .1
    if FileExists(Base) then
      RenameFile(Base, Base + '.1');
  end;
end;

procedure AppendLogLine(const Line: string);
var
  LogPath: string;
  Dir: string;
  FS: TextFile;
begin
  LogPath := ExpandTilde(VF_LOG_RELATIVE);
  Dir := ExtractFileDir(LogPath);
  if not EnsureDir(Dir + DirectorySeparator) then
    Exit;
  RotateLogIfNeeded(LogPath);
  try
    AssignFile(FS, LogPath);
    if FileExists(LogPath) then
      Append(FS)
    else
      Rewrite(FS);
    try
      Writeln(FS, Line);
    finally
      CloseFile(FS);
    end;
  except
    // swallow
  end;
end;

{ ---------- API pública ---------- }

function StartVFMockServer(APort: Word): Boolean;
begin
  if Assigned(GServerThread) then Exit(True);
  GServerThread := TVFMockServerThread.Create(APort);
  Result := Assigned(GServerThread);
end;

procedure StopVFMockServer;
begin
  if Assigned(GServerThread) then
  begin
    GServerThread.StopServer;   // pedir parada (hace autopoke /__quit)
    GServerThread.WaitFor;      // esperar a que termine
    FreeAndNil(GServerThread);  // liberar
  end;
end;

function VFMockServerIsRunning: Boolean;
begin
  Result := Assigned(GServerThread);
end;

{ ---------- Implementación del hilo/servidor ---------- }

constructor TVFMockServerThread.Create(APort: Word);
begin
  inherited Create(False);
  FreeOnTerminate := False;
  FPort := APort;
end;

destructor TVFMockServerThread.Destroy;
begin
  inherited Destroy;
end;

procedure TVFMockServerThread.StopServer;
begin
  Terminate; // marca salida del bucle

  // Autopoke: GET /__quit para desbloquear accept()
  try
    TFPCustomHTTPClient.SimpleGet('http://127.0.0.1:' + IntToStr(FPort) + '/__quit');
  except
    // Si ya está parado o no hay socket, ignorar
  end;

  if Assigned(FServer) then
  begin
    try
      FServer.OnRequest := nil; // evitar callbacks durante cierre
      FServer.Active := False;  // cierra socket
    except
      // ignore
    end;
  end;
end;

function TVFMockServerThread.NowISO8601: string;
begin
  Result := FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss', Now);
end;

function TVFMockServerThread.SaveIncoming(const Body: RawByteString; const SuggestedName: string): string;
var
  BaseDir, FileName, FullPath: string;
  FS: TFileStream;
begin
  BaseDir := ExpandTilde('~/.local/share/verifactu/incoming/');
  if not EnsureDir(BaseDir) then Exit('');

  if SuggestedName <> '' then
    FileName := ExtractSafeFileName(SuggestedName)
  else
    FileName := '';

  if FileName = '' then
    FileName := 'vf_' + FormatDateTime('yyyymmdd_hhnnss_zzz', Now) + '.json';

  FullPath := BaseDir + FileName;

  while FileExists(FullPath) do
    FullPath := BaseDir + 'vf_' + FormatDateTime('yyyymmdd_hhnnss_zzz', Now) + '_' + IntToStr(Random(1000)) + '.json';

  FS := TFileStream.Create(FullPath, fmCreate);
  try
    if Length(Body) > 0 then
      FS.WriteBuffer(Body[1], Length(Body));
  finally
    FS.Free;
  end;
  Result := FullPath;
end;

procedure TVFMockServerThread.DoRequest(Sender: TObject; var ARequest: TFPHTTPConnectionRequest;
  var AResponse: TFPHTTPConnectionResponse);
var
  Body: RawByteString;
  Mode: string;
  SavedTo: string;
  Suggest: string;
  J: TJSONData;
begin
  // Endpoint de apagado controlado
  if (ARequest.Method = 'GET') and (ARequest.PathInfo = '/__quit') then
  begin
    AResponse.Code := 200;
    AResponse.ContentType := 'application/json; charset=utf-8';
    AResponse.Contents.Text := '{"status":"BYE"}';
    Terminate;
    if Assigned(FServer) then
      FServer.Active := False;
    Exit;
  end;

  // Solo endpoint POST /verifactu/test
  if (ARequest.Method <> 'POST') or (ARequest.PathInfo <> '/verifactu/test') then
  begin
    AResponse.Code := 404;
    AResponse.ContentType := 'application/json; charset=utf-8';
    AResponse.Contents.Text := '{"status":"ERROR","message":"Not found"}';
    Exit;
  end;

  // Leer cuerpo (en FPC 3.2.2 Content es string)
  if ARequest.ContentLength > 0 then
    Body := ARequest.Content
  else
    Body := '';

  // Nombre sugerido (serie_numero.json si existe)
  Suggest := '';
  try
    if (Body <> '') and (Pos('{', Body) > 0) then
    begin
      try
        J := GetJSON(Body);
        try
          if (J.JSONType = jtObject) then
          begin
            if TJSONObject(J).Find('serie') <> nil then
              Suggest := TJSONObject(J).Get('serie', '');
            if TJSONObject(J).Find('numero') <> nil then
            begin
              if Suggest <> '' then
                Suggest := Suggest + '_';
              Suggest := Suggest + TJSONObject(J).Get('numero','');
            end;
          end;
        finally
          J.Free;
        end;
      except
        // ignorar parseo
      end;
    end;
  except
    // ignorar errores
  end;

  // Guardar recibido
  SavedTo := SaveIncoming(Body, Suggest + '.json');

  // Forzar error (query o cabecera)
  Mode := LowerCase(ARequest.QueryFields.Values['mode']);
  if Mode = '' then
    Mode := LowerCase(ARequest.CustomHeaders.Values['X-VF-Mode']);

  // Log consola
  Writeln('['+FormatDateTime('hh:nn:ss', Now)+'] Recibido POST ', ARequest.PathInfo);
  Writeln('  -> Guardado: ', SavedTo);
  if Mode = 'error' then
    Writeln('  -> Modo: ERROR (500 simulado)')
  else
    Writeln('  -> Modo: OK');
  Writeln('  -> Tamaño body: ', Length(Body), ' bytes');
  try Writeln('  -> MD5 body: ', MD5Print(MD5String(Body))); except end;

  // Log fichero
  if Mode = 'error' then
    AppendLogLine(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)+' | ERROR  | '+IntToStr(Length(Body))+' bytes | MD5='+MD5Print(MD5String(Body))+' | '+ExtractFileName(SavedTo))
  else
    AppendLogLine(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)+' | OK     | '+IntToStr(Length(Body))+' bytes | MD5='+MD5Print(MD5String(Body))+' | '+ExtractFileName(SavedTo));

  if Mode = 'error' then
  begin
    AResponse.Code := 500;
    AResponse.ContentType := 'application/json; charset=utf-8';
    AResponse.Contents.Text :=
      '{'+
      '"status":"ERROR",'+
      '"timestamp":"'+NowISO8601+'",'+
      '"message":"Error simulado por el servidor local",'+
      '"saved_to":"'+StringReplace(SavedTo,'"','\"',[rfReplaceAll])+'"'+
      '}';
    Exit;
  end;

  // Respuesta OK simulada
  AResponse.Code := 200;
  AResponse.ContentType := 'application/json; charset=utf-8';
  AResponse.Contents.Text :=
    '{'+
    '"status":"OK",'+
    '"timestamp":"'+NowISO8601+'",'+
    '"hash":"ABC123FAKEHASH",'+
    '"message":"Factura recibida correctamente (modo prueba, local).",'+
    '"saved_to":"'+StringReplace(SavedTo,'"','\"',[rfReplaceAll])+'"'+
    '}';
end;

procedure TVFMockServerThread.Execute;
begin
  Randomize;
  FServer := TFPHTTPServer.Create(nil);
  try
    FServer.Threaded := False;       // manejamos los hilos nosotros
    FServer.Port := FPort;
    FServer.OnRequest := @DoRequest;
    FServer.Active := True;
    while not Terminated do
      Sleep(100);
  finally
    if Assigned(FServer) then
    begin
      try FServer.Active := False except end;
      FreeAndNil(FServer);
    end;
  end;
end;

end.
