unit uRestoreBackup;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Process, FileUtil, Grids, IniFiles, 
  uFLXRestoreRemote, BaseUnix, Global;

type

  { TfRestoreBackup }

  TfRestoreBackup = class(TForm)
    btnActualizar: TButton;
    btnCancelar: TButton;
    btnExaminarRuta: TButton;
    btnBackupAhora: TButton;
    btnRestaurar: TButton;
    chkBackupAntesRestore: TCheckBox;
    chkRestoreAria: TCheckBox;
    chkRestoreConf: TCheckBox;
    edRutaBackups: TEdit;
    GridBackups: TStringGrid;
    lblBackups: TLabel;
    lblInfo: TLabel;
    lblRuta: TLabel;
    MemoInfo: TMemo;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure btnActualizarClick(Sender: TObject);
    procedure btnBackupAhoraClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExaminarRutaClick(Sender: TObject);
    procedure btnRestaurarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GridBackupsClick(Sender: TObject);
    procedure GridBackupsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridBackupsSelection(Sender: TObject; aCol, aRow: Integer);
  private
    FBaseBackupDir: string;
    FDBNameActual: string;
    FRutaIni: string;
    FUsarPkExec: Boolean;
    FOnBeforeRestoreCloseApp: TNotifyEvent;
    FBackupPaths: TStringList;
    FInitialized: Boolean;
    FSortColumn: Integer;
    FSortAsc: Boolean;

    procedure ConfigurarGrid;
    procedure LimpiarGrid;
    procedure AddBackupToGrid(const ARutaBackup, AFecha, AHost, ADBName, ATamano: string);
    procedure CargarListaBackups;
    procedure MostrarInfoSeleccion;
    procedure OrdenarGrid(ACol: Integer);
    function  GetRutaBackupSeleccionada: string;
    function  LeerValorManifest(const AFichero, AClave: string): string;
    function  BackupEsValido(const ARutaBackup: string): Boolean;
    function  ExisteEstructuraRestore(const ARutaBackup: string): Boolean;
    function  EjecutarBackupManual: Boolean;
    function  EjecutarRestore(const ARutaBackup: string): Boolean;
    procedure CierreLimpioAntesRestore;
    function  GetManifestPath(const ARutaBackup: string): string;
    function  GetFechaMostrar(const AMF: string): string;
    function  GetConfigFileName: string;
    procedure CargarConfiguracion;
    procedure GuardarConfiguracion;
    function  GetSelectedBackupDBName(const ARutaBackup: string): string;
    function  GetTerminalExecutable: string;
  public
    property DBNameActual: string read FDBNameActual write FDBNameActual;
    property RutaIni: string read FRutaIni write FRutaIni;
    property UsarPkExec: Boolean read FUsarPkExec write FUsarPkExec;
    property OnBeforeRestoreCloseApp: TNotifyEvent read FOnBeforeRestoreCloseApp write FOnBeforeRestoreCloseApp;
  end;

var
  fRestoreBackup: TfRestoreBackup;
  Ini : TIniFile;

implementation

{$R *.lfm}

function NormalizarRuta(const S: string): string;
begin
  Result := Trim(S);
  if Result <> '' then
    Result := ExcludeTrailingPathDelimiter(Result);
end;

{ TfRestoreBackup }

procedure TfRestoreBackup.FormCreate(Sender: TObject);
begin
  FBackupPaths := TStringList.Create;
  FUsarPkExec := False; // para restore visible en terminal usaremos sudo
  chkRestoreConf.Checked := True;
  chkRestoreAria.Checked := True;
  chkBackupAntesRestore.Checked := True;
  FBaseBackupDir := IncludeTrailingPathDelimiter(GetUserDir) + 'backups' + PathDelim + 'facturlinex';
  FSortColumn := -1;
  FSortAsc := True;
  ConfigurarGrid;
  MemoInfo.Clear;
  FInitialized := False;
end;

procedure TfRestoreBackup.FormDestroy(Sender: TObject);
begin
  GuardarConfiguracion;
  FreeAndNil(FBackupPaths);
end;

procedure TfRestoreBackup.FormShow(Sender: TObject);
begin
  if FInitialized then
    Exit;

  CargarConfiguracion;
  edRutaBackups.Text := FBaseBackupDir;
  CargarListaBackups;
  FInitialized := True;
end;

procedure TfRestoreBackup.GridBackupsClick(Sender: TObject);
begin
  MostrarInfoSeleccion;
end;

procedure TfRestoreBackup.GridBackupsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: LongInt;
begin
  if Button <> mbLeft then
    Exit;

  GridBackups.MouseToCell(X, Y, ACol, ARow);
  if ARow = 0 then
    OrdenarGrid(ACol);
end;

procedure TfRestoreBackup.GridBackupsSelection(Sender: TObject; aCol, aRow: Integer);
begin
  MostrarInfoSeleccion;
end;

procedure TfRestoreBackup.btnActualizarClick(Sender: TObject);
begin
  FBaseBackupDir := NormalizarRuta(edRutaBackups.Text);
  GuardarConfiguracion;
  CargarListaBackups;
end;

procedure TfRestoreBackup.btnBackupAhoraClick(Sender: TObject);
var
  Msg: string;
begin
  if Trim(FDBNameActual) = '' then
  begin
    ShowMessage('DBNameActual no está configurado en el formulario.');
    Exit;
  end;

  if Trim(FRutaIni) = '' then
  begin
    ShowMessage('RutaIni no está configurada en el formulario.');
    Exit;
  end;

  Msg :=
    'Se va a lanzar un backup manual de la base actual.' + LineEnding + LineEnding +
    'La copia se guardará usando el script flx_backup.sh.' + LineEnding +
    '¿Deseas continuar?';

  if MessageDlg('Confirmar backup manual', Msg, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  Screen.Cursor := crHourGlass;
  try
    if EjecutarBackupManual then
      ShowMessage('Backup manual lanzado correctamente.')
    else
      ShowMessage('No se pudo lanzar el backup manual.');
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfRestoreBackup.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfRestoreBackup.btnExaminarRutaClick(Sender: TObject);
begin
  SelectDirectoryDialog1.InitialDir := edRutaBackups.Text;
  if SelectDirectoryDialog1.Execute then
  begin
    edRutaBackups.Text := NormalizarRuta(SelectDirectoryDialog1.FileName);
    FBaseBackupDir := edRutaBackups.Text;
    GuardarConfiguracion;
    CargarListaBackups;
  end;
end;

procedure TfRestoreBackup.btnRestaurarClick(Sender: TObject);
var
  RutaBackup: string;
  Msg: string;
//--  DBHost: string;     //-- Ya existe esta variable a nivel global
  SSHUser: string;
  ServerHome: string;
  FacturConfServidor: string;
  DBNameCopia: string;
begin
  RutaBackup := GetRutaBackupSeleccionada;
  if RutaBackup = '' then
  begin
    ShowMessage('Selecciona una copia de seguridad.');
    Exit;
  end;

  if Trim(FRutaIni) = '' then
  begin
    ShowMessage('RutaIni no está configurada en el formulario de restauración.');
    Exit;
  end;

  if not BackupEsValido(RutaBackup) then
  begin
    ShowMessage('La copia seleccionada no es válida. Revisa el manifest y la estructura mysql_datadir/<DBNAME>.');
    Exit;
  end;

  DBNameCopia := Trim(LeerValorManifest(GetManifestPath(RutaBackup), 'DBNAME'));
  if DBNameCopia = '' then
    DBNameCopia := Trim(FDBNameActual);

  if DBNameCopia = '' then
  begin
    ShowMessage('No se ha podido determinar la base de datos de la copia.');
    Exit;
  end;

  { Host real de la BBDD configurada en FacturLinEx }
  DBHost := Trim(Ini.ReadString('BBDD', 'host', 'localhost'));

  Msg :=
    'Se va a restaurar la copia seleccionada:' + LineEnding + LineEnding +
    RutaBackup + LineEnding + LineEnding;

  if FLX_IsLocalDBHost(DBHost) then
    Msg := Msg + 'Modo: restauración LOCAL.' + LineEnding
  else
    Msg := Msg + 'Modo: restauración REMOTA sobre el servidor ' + DBHost + '.' + LineEnding;

  Msg := Msg +
    'Se abrirá una terminal en primer plano.' + LineEnding +
    'La aplicación se cerrará por su flujo normal.' + LineEnding +
    'El proceso esperará a que FacturLinEx termine completamente antes de parar MariaDB.' + LineEnding;

  if chkBackupAntesRestore.Checked then
    Msg := Msg + 'Antes de restaurar se hará un backup previo obligatorio del estado actual.' + LineEnding;

  if chkRestoreConf.Checked then
    Msg := Msg + 'También se restaurará FacturConf.ini.' + LineEnding;

  if chkRestoreAria.Checked then
    Msg := Msg + 'También se restaurarán los ficheros globales Aria.' + LineEnding;

  Msg := Msg + LineEnding + '¿Deseas continuar?';

  if MessageDlg('Confirmar restauración', Msg, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  Screen.Cursor := crHourGlass;
  try
    if FLX_IsLocalDBHost(DBHost) then
    begin
      { ===== RESTORE LOCAL: flujo actual ===== }
      if not EjecutarRestore(RutaBackup) then
      begin
        ShowMessage('No se pudo lanzar la restauración local en terminal.');
        Exit;
      end;
    end
    else
    begin
      { ===== RESTORE REMOTO =====
        Estos datos los puedes guardar donde prefieras.
        Aquí supongo que los leerás de tu configuración. }
      SSHUser := Trim(Ini.ReadString('SSH', 'user', ''));
      ServerHome := Trim(Ini.ReadString('SSH', 'server_home', ''));
      FacturConfServidor := Trim(Ini.ReadString('SSH', 'facturconf_path', ''));

      if SSHUser = '' then
      begin
        ShowMessage('Falta SSH\user en la configuración.');
        Exit;
      end;

      if ServerHome = '' then
      begin
        ShowMessage('Falta SSH\server_home en la configuración.');
        Exit;
      end;

      if FacturConfServidor = '' then
      begin
        ShowMessage('Falta SSH\facturconf_path en la configuración.');
        Exit;
      end;

      if not FLX_LaunchRemoteRestoreTerminal(
        DBHost,
        SSHUser,
        RutaBackup,
        ServerHome,
        DBNameCopia,
        FacturConfServidor,
        Application.ExeName,
        fpGetPid,
        chkRestoreConf.Checked,
        chkRestoreAria.Checked
      ) then
      begin
        ShowMessage('No se pudo lanzar la restauración remota.');
        Exit;
      end;
    end;

    CierreLimpioAntesRestore;

    if Assigned(FOnBeforeRestoreCloseApp) then
      FOnBeforeRestoreCloseApp(Self)
    else if Assigned(Application.MainForm) then
      Application.MainForm.Close
    else
      Application.Terminate;
  finally
    Screen.Cursor := crDefault;
  end;
end;
procedure TfRestoreBackup.ConfigurarGrid;
begin
  GridBackups.ColCount := 5;
  GridBackups.FixedCols := 0;
  GridBackups.FixedRows := 1;
  GridBackups.RowCount := 2;
  GridBackups.Options := GridBackups.Options + [goRowSelect];
  GridBackups.Cells[0, 0] := 'Fecha';
  GridBackups.Cells[1, 0] := 'Equipo';
  GridBackups.Cells[2, 0] := 'Base';
  GridBackups.Cells[3, 0] := 'Tamaño';
  GridBackups.Cells[4, 0] := 'Carpeta';
  GridBackups.ColWidths[0] := 170;
  GridBackups.ColWidths[1] := 110;
  GridBackups.ColWidths[2] := 110;
  GridBackups.ColWidths[3] := 120;
  GridBackups.ColWidths[4] := 300;
end;

procedure TfRestoreBackup.LimpiarGrid;
begin
  FBackupPaths.Clear;
  GridBackups.RowCount := 2;
  GridBackups.Rows[1].Clear;
  GridBackups.Row := 1;
end;

procedure TfRestoreBackup.AddBackupToGrid(const ARutaBackup, AFecha, AHost, ADBName,
  ATamano: string);
var
  R: Integer;
begin
  R := FBackupPaths.Count + 1;
  if R >= GridBackups.RowCount then
    GridBackups.RowCount := R + 1;

  FBackupPaths.Add(ARutaBackup);
  GridBackups.Cells[0, R] := AFecha;
  GridBackups.Cells[1, R] := AHost;
  GridBackups.Cells[2, R] := ADBName;
  GridBackups.Cells[3, R] := ATamano;
  GridBackups.Cells[4, R] := ExtractFileName(ARutaBackup);
end;

procedure TfRestoreBackup.CargarListaBackups;
var
  SR: TSearchRec;
  Ruta, MF, Fecha, Host, DBName, Tamano: string;
begin
  LimpiarGrid;
  MemoInfo.Clear;
  FBaseBackupDir := NormalizarRuta(edRutaBackups.Text);

  if FBaseBackupDir = '' then
  begin
    MemoInfo.Lines.Add('Indica una carpeta base de copias.');
    Exit;
  end;

  if not DirectoryExists(FBaseBackupDir) then
  begin
    MemoInfo.Lines.Add('No existe la carpeta de copias:');
    MemoInfo.Lines.Add(FBaseBackupDir);
    Exit;
  end;

  if FindFirst(IncludeTrailingPathDelimiter(FBaseBackupDir) + '*', faDirectory, SR) = 0 then
  begin
    repeat
      if (SR.Name <> '.') and (SR.Name <> '..') then
      begin
        Ruta := IncludeTrailingPathDelimiter(FBaseBackupDir) + SR.Name;
        if DirectoryExists(Ruta) then
        begin
          MF := GetManifestPath(Ruta);
          if FileExists(MF) then
          begin
            Fecha := GetFechaMostrar(MF);
            Host := LeerValorManifest(MF, 'HOST');
            DBName := LeerValorManifest(MF, 'DBNAME');
            Tamano := LeerValorManifest(MF, 'SIZE_DEST');
            AddBackupToGrid(Ruta, Fecha, Host, DBName, Tamano);
          end;
        end;
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;

  if FBackupPaths.Count > 0 then
  begin
    GridBackups.Row := FBackupPaths.Count;
    MostrarInfoSeleccion;
  end
  else
    MemoInfo.Lines.Add('No se han encontrado copias válidas en la carpeta seleccionada.');
end;

procedure TfRestoreBackup.MostrarInfoSeleccion;
var
  RutaBackup, MF, SelDB: string;
begin
  MemoInfo.Clear;
  RutaBackup := GetRutaBackupSeleccionada;
  if RutaBackup = '' then
    Exit;

  MF := GetManifestPath(RutaBackup);
  SelDB := GetSelectedBackupDBName(RutaBackup);

  MemoInfo.Lines.Add('Ruta: ' + RutaBackup);
  MemoInfo.Lines.Add('');
  MemoInfo.Lines.Add('Fecha parámetro: ' + LeerValorManifest(MF, 'FECHA_PARAM'));
  MemoInfo.Lines.Add('Stamp: ' + LeerValorManifest(MF, 'STAMP'));
  MemoInfo.Lines.Add('Fecha real: ' + LeerValorManifest(MF, 'DATE'));
  MemoInfo.Lines.Add('Host: ' + LeerValorManifest(MF, 'HOST'));
  MemoInfo.Lines.Add('DBNAME copia: ' + SelDB);
  MemoInfo.Lines.Add('DB actual FL2: ' + FDBNameActual);
  MemoInfo.Lines.Add('MYSQL_DATADIR: ' + LeerValorManifest(MF, 'MYSQL_DATADIR'));
  MemoInfo.Lines.Add('DBDIR: ' + LeerValorManifest(MF, 'DBDIR'));
  MemoInfo.Lines.Add('FacturConf: ' + LeerValorManifest(MF, 'FACTURCONF_PATH'));
  MemoInfo.Lines.Add('Destino original: ' + LeerValorManifest(MF, 'DEST_DIR'));
  MemoInfo.Lines.Add('Tamaño: ' + LeerValorManifest(MF, 'SIZE_DEST'));
  MemoInfo.Lines.Add('');

  if BackupEsValido(RutaBackup) then
    MemoInfo.Lines.Add('Validación: OK')
  else
    MemoInfo.Lines.Add('Validación: ERROR');
end;

procedure TfRestoreBackup.OrdenarGrid(ACol: Integer);
var
  TempRows: TStringList;
  TempPaths: TStringList;
  R, OutRow: Integer;
  Key, Path, Line: string;
  Parts: TStringList;
begin
  if FBackupPaths.Count <= 1 then
    Exit;

  if FSortColumn = ACol then
    FSortAsc := not FSortAsc
  else
  begin
    FSortColumn := ACol;
    FSortAsc := True;
  end;

  TempRows := TStringList.Create;
  TempPaths := TStringList.Create;
  Parts := TStringList.Create;
  try
    Parts.Delimiter := #9;
    Parts.StrictDelimiter := True;

    for R := 1 to FBackupPaths.Count do
    begin
      Key := AnsiLowerCase(GridBackups.Cells[ACol, R]);
      Line := Key + #9 + GridBackups.Cells[0, R] + #9 + GridBackups.Cells[1, R] + #9 +
              GridBackups.Cells[2, R] + #9 + GridBackups.Cells[3, R] + #9 +
              GridBackups.Cells[4, R] + #9 + FBackupPaths[R - 1];
      TempRows.Add(Line);
    end;

    TempRows.Sort;

    if not FSortAsc then
    begin
      for R := TempRows.Count - 1 downto 0 do
        TempPaths.Add(TempRows[R]);
      TempRows.Assign(TempPaths);
      TempPaths.Clear;
    end;

    LimpiarGrid;
    for R := 0 to TempRows.Count - 1 do
    begin
      Parts.DelimitedText := TempRows[R];
      if Parts.Count >= 7 then
      begin
        Path := Parts[6];
        OutRow := FBackupPaths.Count + 1;
        if OutRow >= GridBackups.RowCount then
          GridBackups.RowCount := OutRow + 1;
        FBackupPaths.Add(Path);
        GridBackups.Cells[0, OutRow] := Parts[1];
        GridBackups.Cells[1, OutRow] := Parts[2];
        GridBackups.Cells[2, OutRow] := Parts[3];
        GridBackups.Cells[3, OutRow] := Parts[4];
        GridBackups.Cells[4, OutRow] := Parts[5];
      end;
    end;

    if FBackupPaths.Count > 0 then
      GridBackups.Row := 1;

    MostrarInfoSeleccion;
  finally
    Parts.Free;
    TempPaths.Free;
    TempRows.Free;
  end;
end;

function TfRestoreBackup.GetRutaBackupSeleccionada: string;
begin
  Result := '';
  if (GridBackups.Row > 0) and (GridBackups.Row - 1 < FBackupPaths.Count) then
    Result := Trim(FBackupPaths[GridBackups.Row - 1]);
end;

function TfRestoreBackup.LeerValorManifest(const AFichero, AClave: string): string;
var
  SL: TStringList;
  I, P: Integer;
  Linea, K, V: string;
begin
  Result := '';
  if not FileExists(AFichero) then
    Exit;

  SL := TStringList.Create;
  try
    SL.LoadFromFile(AFichero);
    for I := 0 to SL.Count - 1 do
    begin
      Linea := Trim(SL[I]);
      if Linea = '' then
        Continue;

      P := Pos('=', Linea);
      if P <= 0 then
        Continue;

      K := Trim(Copy(Linea, 1, P - 1));
      V := Trim(Copy(Linea, P + 1, MaxInt));

      if SameText(K, AClave) then
      begin
        Result := V;
        Exit;
      end;
    end;
  finally
    SL.Free;
  end;
end;

function TfRestoreBackup.ExisteEstructuraRestore(const ARutaBackup: string): Boolean;
var
  MF, DBMan, DirDB: string;
begin
  Result := False;

  if not DirectoryExists(ARutaBackup) then
    Exit;

  MF := GetManifestPath(ARutaBackup);
  if not FileExists(MF) then
    Exit;

  DBMan := Trim(LeerValorManifest(MF, 'DBNAME'));
  if DBMan = '' then
    Exit;

  DirDB := IncludeTrailingPathDelimiter(ARutaBackup) + 'mysql_datadir' + PathDelim + DBMan;
  Result := DirectoryExists(DirDB);
end;

function TfRestoreBackup.BackupEsValido(const ARutaBackup: string): Boolean;
var
  MF: string;
begin
  Result := False;

  MF := GetManifestPath(ARutaBackup);
  if not FileExists(MF) then
    Exit;

  if not ExisteEstructuraRestore(ARutaBackup) then
    Exit;

  if not FileExists('/usr/local/sbin/flx_restore.sh') then
    Exit;

  if not FileExists('/usr/local/sbin/flx_restore_run.sh') then
    Exit;

  Result := True;
end;

function TfRestoreBackup.EjecutarBackupManual: Boolean;
var
  P: TProcess;
  FacturConfPath: string;
  FechaStr: string;
begin
  Result := False;

  if not FileExists('/usr/local/sbin/flx_backup.sh') then
  begin
    ShowMessage('No existe /usr/local/sbin/flx_backup.sh');
    Exit;
  end;

  FacturConfPath := IncludeTrailingPathDelimiter(FRutaIni) + 'FacturConf.ini';
  FechaStr := FormatDateTime('yyyymmdd', Now);

  P := TProcess.Create(nil);
  try
    if FUsarPkExec then
      P.Executable := 'pkexec'
    else
      P.Executable := 'sudo';

    P.Parameters.Add('/usr/local/sbin/flx_backup.sh');
    P.Parameters.Add(FechaStr);
    P.Parameters.Add(GetUserDir);
    P.Parameters.Add(FDBNameActual);
    P.Parameters.Add(FacturConfPath);

    P.Options := [];
    P.ShowWindow := swoHIDE;
    P.Execute;

    Result := True;
  finally
    P.Free;
  end;
end;

function TfRestoreBackup.GetSelectedBackupDBName(const ARutaBackup: string): string;
var
  MF: string;
begin
  MF := GetManifestPath(ARutaBackup);
  Result := Trim(LeerValorManifest(MF, 'DBNAME'));
  if Result = '' then
    Result := Trim(FDBNameActual);
end;

function TfRestoreBackup.GetTerminalExecutable: string;
begin
  if FindDefaultExecutablePath('x-terminal-emulator') <> '' then
    Result := 'x-terminal-emulator'
  else if FindDefaultExecutablePath('xterm') <> '' then
    Result := 'xterm'
  else
    Result := '';
end;

function TfRestoreBackup.EjecutarRestore(const ARutaBackup: string): Boolean;
var
  P: TProcess;
  FacturConfPath, SelDB, TermExe, AppUser, DispVar, XAuthVar: string;
begin
  Result := False;

  if not FileExists('/usr/local/sbin/flx_restore_run.sh') then
  begin
    ShowMessage('No existe /usr/local/sbin/flx_restore_run.sh');
    Exit;
  end;

  TermExe := GetTerminalExecutable;
  if TermExe = '' then
  begin
    ShowMessage('No se encontró un emulador de terminal (x-terminal-emulator / xterm).');
    Exit;
  end;

  FacturConfPath := IncludeTrailingPathDelimiter(FRutaIni) + 'FacturConf.ini';
  SelDB := GetSelectedBackupDBName(ARutaBackup);
  AppUser := GetEnvironmentVariable('USER');
  if Trim(AppUser) = '' then
    AppUser := 'root';
  DispVar := GetEnvironmentVariable('DISPLAY');
  XAuthVar := GetEnvironmentVariable('XAUTHORITY');

  P := TProcess.Create(nil);
  try
    P.Executable := TermExe;

    if ExtractFileName(TermExe) = 'xterm' then
    begin
      P.Parameters.Add('-hold');
      P.Parameters.Add('-T');
      P.Parameters.Add('Restore FLX');
      P.Parameters.Add('-e');
    end
    else
      P.Parameters.Add('-e');

    P.Parameters.Add('sudo');
    P.Parameters.Add('/usr/local/sbin/flx_restore_run.sh');
    P.Parameters.Add(ARutaBackup);
    P.Parameters.Add(GetUserDir);
    P.Parameters.Add(SelDB);
    P.Parameters.Add(FacturConfPath);

    if chkRestoreConf.Checked then
      P.Parameters.Add('1')
    else
      P.Parameters.Add('0');

    if chkRestoreAria.Checked then
      P.Parameters.Add('1')
    else
      P.Parameters.Add('0');

    if chkBackupAntesRestore.Checked then
      P.Parameters.Add('1')
    else
      P.Parameters.Add('0');

    P.Parameters.Add(IntToStr(fpGetPid));
    P.Parameters.Add(AppUser);
    P.Parameters.Add(Application.ExeName);
    P.Parameters.Add(DispVar);
    P.Parameters.Add(XAuthVar);

    P.Options := [];
    P.ShowWindow := swoShow;
    P.Execute;

    Result := True;
  finally
    P.Free;
  end;
end;

procedure TfRestoreBackup.CierreLimpioAntesRestore;
begin
  try
    // Aquí cierras timers, queries, conexiones, etc.
    // Ejemplos:
    // Timer1.Enabled := False;
    // TimerVF.Enabled := False;
    // ZQuery1.Close;
    // ZConnection1.Disconnect;
    // Application.ProcessMessages;
  except
    on E: Exception do
      ShowMessage('Aviso durante el cierre previo a la restauración: ' + E.Message);
  end;
end;

function TfRestoreBackup.GetManifestPath(const ARutaBackup: string): string;
begin
  Result := IncludeTrailingPathDelimiter(ARutaBackup) + 'manifest.txt';
end;

function TfRestoreBackup.GetFechaMostrar(const AMF: string): string;
begin
  Result := LeerValorManifest(AMF, 'DATE');
  if Result = '' then
    Result := LeerValorManifest(AMF, 'FECHA_PARAM');
end;

function TfRestoreBackup.GetConfigFileName: string;
var
  BaseDir: string;
begin
  if Trim(FRutaIni) <> '' then
    BaseDir := ExcludeTrailingPathDelimiter(FRutaIni)
  else
    BaseDir := IncludeTrailingPathDelimiter(GetAppConfigDir(False)) + 'facturlinex';

  if not DirectoryExists(BaseDir) then
    ForceDirectories(BaseDir);

  Result := IncludeTrailingPathDelimiter(BaseDir) + 'restorebackup.ini';
end;

procedure TfRestoreBackup.CargarConfiguracion;
var
  Ini: TIniFile;
  Fichero: string;
  S: string;
begin
  Fichero := GetConfigFileName;
  Ini := TIniFile.Create(Fichero);
  try
    S := Trim(Ini.ReadString('RESTORE', 'BaseBackupDir', FBaseBackupDir));
    if S <> '' then
      FBaseBackupDir := NormalizarRuta(S);
    chkRestoreConf.Checked := Ini.ReadBool('RESTORE', 'RestoreConf', chkRestoreConf.Checked);
    chkRestoreAria.Checked := Ini.ReadBool('RESTORE', 'RestoreAria', chkRestoreAria.Checked);
    chkBackupAntesRestore.Checked := Ini.ReadBool('RESTORE', 'BackupAntesRestore', chkBackupAntesRestore.Checked);
  finally
    Ini.Free;
  end;
end;

procedure TfRestoreBackup.GuardarConfiguracion;
var
  Ini: TIniFile;
  Fichero: string;
begin
  Fichero := GetConfigFileName;
  Ini := TIniFile.Create(Fichero);
  try
    Ini.WriteString('RESTORE', 'BaseBackupDir', NormalizarRuta(edRutaBackups.Text));
    Ini.WriteBool('RESTORE', 'RestoreConf', chkRestoreConf.Checked);
    Ini.WriteBool('RESTORE', 'RestoreAria', chkRestoreAria.Checked);
    Ini.WriteBool('RESTORE', 'BackupAntesRestore', chkBackupAntesRestore.Checked);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

end.
