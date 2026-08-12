unit uFLXInstallerMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Math, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, Process, FileUtil, BaseUnix, LCLType, LCLIntf;

type
  TfrmFLXInstaller = class(TForm)
  private
    FPage: Integer;
    FSourceDir: string;
    FBinaryPath: string;
    FAppUser: string;
    FVFMode: string;
    FShopName: string;
    FShopAddress: string;
    FShopCity: string;
    FShopZip: string;
    FShopProvince: string;
    FShopPhone: string;
    FShopFax: string;
    FShopNIF: string;
    FShopDBHost: string;
    FShopDBPort: string;
    FDBName: string;
    FDBUser: string;
    FLog: TStringList;
    FRunning: Boolean;
    FLastLogFile: string;
    FServerMode: Boolean;
    FServerSSHUser: string;

    pnlHeader: TPanel;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    pnlBody: TScrollBox;
    pnlFooter: TPanel;
    pnlNav: TPanel;
    btnBack: TBitBtn;
    btnNext: TBitBtn;
    btnCancel: TBitBtn;
    ProgressBar: TProgressBar;
    lblProgress: TLabel;

    procedure BuildUI;
    procedure ShowPage(AIndex: Integer);
    procedure ClearBody;
    procedure AddHeading(const AText, ASubText: string);
    function AddEdit(const ACaption, AValue: string; ATop: Integer;
      APassword: Boolean = False): TEdit;
    function AddCombo(const ACaption: string; const AItems: array of string;
      AItemIndex, ATop: Integer): TComboBox;
    procedure AddMemo(const AText: string; ATop, AHeight: Integer);

    procedure BackClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ServerInstallClick(Sender: TObject);
    procedure OpenInstallLog(Sender: TObject);
    procedure OpenToolsDiag(Sender: TObject);
    procedure RunFacturLinEx(Sender: TObject);
    procedure RunHealthCenter(Sender: TObject);
    procedure OpenDocumentation(Sender: TObject);
    procedure FormCloseQueryHandler(Sender: TObject; var CanClose: Boolean);

    function InstallerScript: string;
    function ServerInstallerScript: string;
    function ScriptsAvailable(out AMissing: string): Boolean;
    function ServerScriptsAvailable(out AMissing: string): Boolean;
    function RunCommand(const AExecutable: string; const AParams: array of string;
      const APhase: string): Boolean;
    function RunMasterInstaller(InstallMode: Boolean): Boolean;
    function RunServerInstaller(InstallMode: Boolean): Boolean;
    procedure UpdateProgress(APosition: Integer; const AText: string);
    procedure AppendLog(const ALine: string);
    procedure SaveLog;
    function IsRoot: Boolean;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmFLXInstaller: TfrmFLXInstaller;

implementation

constructor TfrmFLXInstaller.Create(TheOwner: TComponent);
begin
  inherited CreateNew(TheOwner, 1);
  Caption := 'Instalador FacturLinEx 4.2.6J';
  Width := 940;
  Height := 760;
  Position := poScreenCenter;
  Constraints.MinWidth := 820;
  Constraints.MinHeight := 620;
  Color := RGBToColor(242, 246, 250);
  KeyPreview := True;
  BorderIcons := [biSystemMenu, biMinimize];
  OnCloseQuery := @FormCloseQueryHandler;

  FLog := TStringList.Create;
  FPage := 0;
  FRunning := False;
  FLastLogFile := '';
  FServerMode := False;
  FSourceDir := ExpandFileName(ExtractFilePath(ParamStr(0)) + '..');
  FBinaryPath := IncludeTrailingPathDelimiter(FSourceDir) + 'Bin/FacturLinEx';
  FAppUser := GetEnvironmentVariable('SUDO_USER');
  if FAppUser = '' then
    FAppUser := GetEnvironmentVariable('USER');
  FVFMode := 'PRUEBAS';
  FShopName := '';
  FShopAddress := '';
  FShopCity := '';
  FShopZip := '';
  FShopProvince := '';
  FShopPhone := '';
  FShopFax := '';
  FShopNIF := '';
  FShopDBHost := 'localhost';
  FShopDBPort := '3306';
  FDBName := 'facturlinex2';
  FDBUser := 'facturlinex';
  FServerSSHUser := FAppUser;
  if FServerSSHUser = '' then FServerSSHUser := 'facturlinex';

  BuildUI;
  ShowPage(0);
end;

destructor TfrmFLXInstaller.Destroy;
begin
  FLog.Free;
  inherited Destroy;
end;

procedure TfrmFLXInstaller.BuildUI;
begin
  pnlHeader := TPanel.Create(Self);
  pnlHeader.Parent := Self;
  pnlHeader.Align := alTop;
  pnlHeader.Height := 112;
  pnlHeader.BevelOuter := bvNone;
  pnlHeader.Color := RGBToColor(34, 85, 135);
  pnlHeader.Caption := '';

  lblTitle := TLabel.Create(Self);
  lblTitle.Parent := pnlHeader;
  lblTitle.Left := 30;
  lblTitle.Top := 20;
  lblTitle.Caption := 'FacturLinEx 4.2.6J';
  lblTitle.Font.Size := 24;
  lblTitle.Font.Style := [fsBold];
  lblTitle.Font.Color := clWhite;

  lblSubtitle := TLabel.Create(Self);
  lblSubtitle.Parent := pnlHeader;
  lblSubtitle.Left := 32;
  lblSubtitle.Top := 66;
  lblSubtitle.Caption := 'Asistente gráfico de instalación';
  lblSubtitle.Font.Size := 13;
  lblSubtitle.Font.Color := RGBToColor(220, 235, 248);

  pnlFooter := TPanel.Create(Self);
  pnlFooter.Parent := Self;
  pnlFooter.Align := alBottom;
  pnlFooter.Height := 92;
  pnlFooter.BevelOuter := bvNone;
  pnlFooter.Color := RGBToColor(226, 234, 242);
  pnlFooter.Caption := '';

  lblProgress := TLabel.Create(Self);
  lblProgress.Parent := pnlFooter;
  lblProgress.Left := 24;
  lblProgress.Top := 10;
  lblProgress.Caption := 'Paso 1 de 7';
  lblProgress.Font.Style := [fsBold];

  ProgressBar := TProgressBar.Create(Self);
  ProgressBar.Parent := pnlFooter;
  ProgressBar.Left := 24;
  ProgressBar.Top := 34;
  ProgressBar.Width := 520;
  ProgressBar.Height := 22;
  ProgressBar.Min := 0;
  ProgressBar.Max := 100;

  { Panel fijo de navegación: evita depender del ancho inicial del formulario
    y garantiza que los botones permanezcan visibles en GTK/LCL. }
  pnlNav := TPanel.Create(Self);
  pnlNav.Parent := pnlFooter;
  pnlNav.Align := alRight;
  pnlNav.Width := 390;
  pnlNav.BevelOuter := bvNone;
  pnlNav.Caption := '';
  pnlNav.Color := pnlFooter.Color;

  btnBack := TBitBtn.Create(Self);
  btnBack.Parent := pnlNav;
  btnBack.Caption := 'Anterior';
  btnBack.SetBounds(8, 28, 110, 38);
  btnBack.OnClick := @BackClick;

  btnNext := TBitBtn.Create(Self);
  btnNext.Parent := pnlNav;
  btnNext.Caption := 'Siguiente';
  btnNext.SetBounds(126, 28, 120, 38);
  btnNext.OnClick := @NextClick;

  btnCancel := TBitBtn.Create(Self);
  btnCancel.Parent := pnlNav;
  btnCancel.Caption := 'Cancelar';
  btnCancel.SetBounds(254, 28, 110, 38);
  btnCancel.OnClick := @CancelClick;

  { El cuerpo es desplazable porque la página de datos iniciales contiene
    más controles de los que caben en pantallas pequeñas. }
  pnlBody := TScrollBox.Create(Self);
  pnlBody.Parent := Self;
  pnlBody.Align := alClient;
  pnlBody.BorderStyle := bsNone;
  pnlBody.Color := Color;
  pnlBody.VertScrollBar.Visible := True;
  pnlBody.HorzScrollBar.Visible := False;

  { En algunas combinaciones GTK/LCL un alClient creado al final puede quedar
    por encima de paneles ya alineados. Forzamos el orden visual. }
  pnlBody.SendToBack;
  pnlHeader.BringToFront;
  pnlFooter.BringToFront;
  pnlNav.BringToFront;
  btnBack.BringToFront;
  btnNext.BringToFront;
  btnCancel.BringToFront;
end;

procedure TfrmFLXInstaller.ClearBody;
var
  I: Integer;
begin
  for I := pnlBody.ControlCount - 1 downto 0 do
    pnlBody.Controls[I].Free;
end;

procedure TfrmFLXInstaller.AddHeading(const AText, ASubText: string);
var
  L: TLabel;
begin
  L := TLabel.Create(Self);
  L.Parent := pnlBody;
  L.Left := 34;
  L.Top := 28;
  L.Caption := AText;
  L.Font.Size := 20;
  L.Font.Style := [fsBold];
  L.Font.Color := RGBToColor(32, 70, 105);

  L := TLabel.Create(Self);
  L.Parent := pnlBody;
  L.Left := 36;
  L.Top := 72;
  L.Width := pnlBody.ClientWidth - 72;
  L.AutoSize := False;
  L.WordWrap := True;
  L.Caption := ASubText;
  L.Font.Size := 11;
  L.Font.Color := RGBToColor(70, 80, 90);
end;

function TfrmFLXInstaller.AddEdit(const ACaption, AValue: string; ATop: Integer;
  APassword: Boolean): TEdit;
var
  L: TLabel;
begin
  L := TLabel.Create(Self);
  L.Parent := pnlBody;
  L.Left := 40;
  L.Top := ATop;
  L.Caption := ACaption;
  L.Font.Style := [fsBold];

  Result := TEdit.Create(Self);
  Result.Parent := pnlBody;
  Result.Left := 280;
  Result.Top := ATop - 5;
  Result.Width := 540;
  Result.Height := 32;
  Result.Text := AValue;
  if APassword then
    Result.PasswordChar := '*';
end;

function TfrmFLXInstaller.AddCombo(const ACaption: string;
  const AItems: array of string; AItemIndex, ATop: Integer): TComboBox;
var
  L: TLabel;
  S: string;
begin
  L := TLabel.Create(Self);
  L.Parent := pnlBody;
  L.Left := 40;
  L.Top := ATop;
  L.Caption := ACaption;
  L.Font.Style := [fsBold];

  Result := TComboBox.Create(Self);
  Result.Parent := pnlBody;
  Result.Left := 280;
  Result.Top := ATop - 5;
  Result.Width := 260;
  Result.Height := 32;
  Result.Style := csDropDownList;
  for S in AItems do
    Result.Items.Add(S);
  Result.ItemIndex := AItemIndex;
end;

procedure TfrmFLXInstaller.AddMemo(const AText: string; ATop, AHeight: Integer);
var
  M: TMemo;
begin
  M := TMemo.Create(Self);
  M.Parent := pnlBody;
  M.Left := 34;
  M.Top := ATop;
  M.Width := pnlBody.ClientWidth - 68;
  M.Height := AHeight;
  M.Anchors := [akLeft, akTop, akRight, akBottom];
  M.ReadOnly := True;
  M.ScrollBars := ssAutoBoth;
  M.WordWrap := False;
  M.Lines.Text := AText;
  M.Color := clWhite;
end;

procedure TfrmFLXInstaller.ShowPage(AIndex: Integer);
var
  E: TEdit;
  C: TComboBox;
  Missing: string;
  Summary: string;
  B: TBitBtn;

begin
  FPage := EnsureRange(AIndex, 0, 6);
  ClearBody;

  pnlHeader.BringToFront;
  pnlFooter.BringToFront;
  pnlNav.BringToFront;

  { Restablecer siempre la navegación normal antes de personalizar la página. }
  pnlNav.Width := 390;
  btnBack.SetBounds(8, 28, 110, 38);
  btnNext.SetBounds(126, 28, 120, 38);
  btnCancel.SetBounds(254, 28, 110, 38);
  btnBack.Visible := True;
  btnNext.Visible := True;
  btnCancel.Visible := True;
  btnBack.Caption := 'Anterior';
  btnNext.Caption := 'Siguiente';
  btnBack.Enabled := (FPage > 0) and not FRunning;
  btnNext.Enabled := not FRunning;
  btnCancel.Enabled := not FRunning;
  ProgressBar.Visible := True;
  lblProgress.Visible := True;

  ProgressBar.Position := Round((FPage / 6) * 100);
  lblProgress.Caption := Format('Paso %d de 7', [FPage + 1]);

  case FPage of
    0:
      begin
        AddHeading('Bienvenido al instalador de FacturLinEx',
          'Este asistente comprobará el equipo, realizará una simulación completa y, '
          + 'solo con autorización expresa y privilegios de administrador, podrá instalar '
          + 'FacturLinEx. Se recomienda usar primero una máquina de pruebas.');
        AddMemo(
          'Edición instalador: 4.2.6J' + LineEnding +
          'Sistema objetivo: Debian Linux' + LineEnding +
          'Modo inicial VeriFactu: PRUEBAS' + LineEnding + LineEnding +
          'Seleccione claramente el tipo de instalación que desea realizar.' + LineEnding +
          'Ninguna de las dos opciones elimina bases de datos ni ejecuta DROP DATABASE.',
          150, 130);

        AddMemo(
          'Puesto: instala la aplicación FacturLinEx y sus auxiliares locales.' + LineEnding +
          'Servidor: prepara MariaDB, SSH, mariadb-backup y el sistema de copias remotas; no instala la aplicación gráfica.',
          315, 105);

        { En la bienvenida los botones fijos del pie SON la selección de perfil.
          Así siempre son visibles en GTK y nunca dependen del alto del cuerpo. }
        ProgressBar.Visible := False;
        lblProgress.Visible := False;
        pnlNav.Width := 790;

        btnBack.Caption := 'Instalar FacturLinEx / Puesto';
        btnBack.SetBounds(8, 20, 290, 46);
        btnBack.Enabled := not FRunning;
        btnBack.Font.Style := [fsBold];

        btnNext.Caption := 'Instalar servidor MariaDB';
        btnNext.SetBounds(306, 20, 290, 46);
        btnNext.Enabled := not FRunning;
        btnNext.Font.Style := [fsBold];

        btnCancel.SetBounds(604, 20, 150, 46);
      end;
    1:
      begin
        if FServerMode then
        begin
          AddHeading('Instalación de servidor MariaDB',
            'Este perfil prepara un servidor de datos y copias remotas. No instala '
            + 'FacturLinEx, escritorio, informes ni componentes gráficos.');
          E := AddEdit('Carpeta raíz del paquete', FSourceDir, 145);
          E.Name := 'edtSource';
          E := AddEdit('Usuario Linux / SSH', FServerSSHUser, 195);
          E.Name := 'edtServerSSHUser';

          if ServerScriptsAvailable(Missing) then
            AddMemo('[CORRECTO] Componentes de servidor localizados.' + LineEnding + LineEnding +
              'Se prepararán MariaDB, mariadb-backup, OpenSSH, credenciales de backup,' + LineEnding +
              'sudoers limitado y /usr/local/sbin/flx_remote_backup_server.', 270, 170)
          else
            AddMemo('[PENDIENTE]' + LineEnding + Missing, 270, 180);
        end
        else
        begin
          AddHeading('Ubicación del paquete',
            'Compruebe que el instalador puede localizar el paquete completo, el binario '
            + 'y los scripts de los hitos C.1 a C.6.');
          E := AddEdit('Carpeta raíz del paquete', FSourceDir, 145);
          E.Name := 'edtSource';
          E := AddEdit('Binario FacturLinEx', FBinaryPath, 195);
          E.Name := 'edtBinary';
          E := AddEdit('Usuario de la aplicación', FAppUser, 245);
          E.Name := 'edtUser';

          if ScriptsAvailable(Missing) then
            AddMemo('[CORRECTO] Scripts principales localizados.', 310, 100)
          else
            AddMemo('[PENDIENTE]' + LineEnding + Missing, 310, 160);
        end;
      end;
    2:
      begin
        if FServerMode then
          AddHeading('Comprobación previa del servidor',
            'Se comprobará el paquete y se mostrará qué componentes del servidor ya existen '
            + 'y cuáles se instalarán. El modo de comprobación no modifica el sistema.')
        else
          AddHeading('Comprobación previa',
            'Se ejecuta el instalador maestro en modo --check. No se modifica '
            + 'el sistema. Si se detecta un problema, aquí verá la salida completa.');

        if FLog.Count = 0 then
        begin
          AddMemo(
            'Se comprobarán:' + LineEnding +
            '• OpenSSL, MariaDB/MySQL, rsync y utilidades.' + LineEnding +
            '• Directorios y permisos previstos.' + LineEnding +
            '• Binario, recursos y documentación.' + LineEnding +
            '• Configuración inicial y verificadores.',
            145, 220);
          btnNext.Caption := 'Ejecutar comprobación';
        end
        else
        begin
          AddMemo(
            'RESULTADO DE LA ÚLTIMA COMPROBACIÓN:' + LineEnding + LineEnding +
            FLog.Text,
            125, 300);

          B := TBitBtn.Create(Self);
          B.Parent := pnlBody;
          B.Caption := 'Ver log completo';
          B.SetBounds(85, 445, 165, 40);
          B.OnClick := @OpenInstallLog;

          B := TBitBtn.Create(Self);
          B.Parent := pnlBody;
          B.Caption := 'Repetir comprobación';
          B.SetBounds(270, 445, 180, 40);
          B.OnClick := @NextClick;

          btnNext.Caption := 'Repetir comprobación';
        end;
      end;

    3:
      begin
        if FServerMode then
        begin
          AddHeading('Configuración automática del servidor',
            'El instalador generará de forma segura la infraestructura necesaria para '
            + 'copias y restauraciones remotas.');
          AddMemo(
            'Se realizará:' + LineEnding +
            '• Instalación/activación de MariaDB Server, mariadb-backup y OpenSSH.' + LineEnding +
            '• Creación del usuario Linux/SSH si todavía no existe.' + LineEnding +
            '• Creación del usuario MariaDB facturlinex_backup con permisos mínimos.' + LineEnding +
            '• Generación automática de una contraseña de backup.' + LineEnding +
            '• /etc/facturlinex/backup.cnf como root:root 0600.' + LineEnding +
            '• /usr/local/sbin/flx_remote_backup_server.' + LineEnding +
            '• sudoers limitado exclusivamente a las operaciones del script remoto.' + LineEnding +
            '• Prueba final FLX_SERVER_OK.' + LineEnding + LineEnding +
            'La contraseña MariaDB de backup no se mostrará ni se incluirá en el paquete.',
            145, 310);
        end
        else
        begin
        AddHeading('Datos iniciales de FacturLinEx',
          'Introduzca o revise los datos de empresa/tienda y conexión. '
          + 'La creación efectiva de FacturConf.ini y de la BBDD sigue diferida '
          + 'a la primera ejecución de FacturLinEx, como en la versión que acaba de funcionar.');

        C := AddCombo('Entorno VeriFactu', ['PRUEBAS', 'PRODUCCION'],
          Ord(FVFMode = 'PRODUCCION'), 115);
        C.Name := 'cmbVFMode';

        E := AddEdit('Razón social / tienda', FShopName, 155); E.Name := 'edtShopName';
        E := AddEdit('NIF/CIF', FShopNIF, 195); E.Name := 'edtShopNIF';
        E := AddEdit('Dirección', FShopAddress, 235); E.Name := 'edtShopAddress';
        E := AddEdit('Localidad', FShopCity, 275); E.Name := 'edtShopCity';
        E := AddEdit('Código postal', FShopZip, 315); E.Name := 'edtShopZip';
        E := AddEdit('Provincia', FShopProvince, 355); E.Name := 'edtShopProvince';
        E := AddEdit('Teléfono', FShopPhone, 395); E.Name := 'edtShopPhone';
        E := AddEdit('Fax (opcional)', FShopFax, 435); E.Name := 'edtShopFax';
        E := AddEdit('Servidor MariaDB', FShopDBHost, 475); E.Name := 'edtShopDBHost';
        E := AddEdit('Puerto MariaDB', FShopDBPort, 515); E.Name := 'edtShopDBPort';
        E := AddEdit('Nombre BBDD', FDBName, 555); E.Name := 'edtDBName';
        E := AddEdit('Usuario BBDD', FDBUser, 595); E.Name := 'edtDBUser';
        end;
      end;
    4:
      begin
        if FServerMode then
        begin
          AddHeading('Resumen antes de preparar el servidor',
            'Revise los datos. La instalación real solicitará autorización administrativa mediante PolicyKit.');
          Summary :=
            'Perfil: SERVIDOR MARIADB (sin aplicación gráfica)' + LineEnding +
            'Origen: ' + FSourceDir + LineEnding +
            'Usuario Linux/SSH: ' + FServerSSHUser + LineEnding + LineEnding +
            'Destino script: /usr/local/sbin/flx_remote_backup_server' + LineEnding +
            'Credenciales: /etc/facturlinex/backup.cnf' + LineEnding +
            'Sudoers: /etc/sudoers.d/facturlinex-backup' + LineEnding +
            'Copias: /var/backups/facturlinex' + LineEnding + LineEnding +
            'No se instalará /usr/bin/FacturLinEx.';
          AddMemo(Summary, 145, 280);
        end
        else
        begin
          AddHeading('Resumen antes de instalar',
            'Revise cuidadosamente la configuración. La instalación real solo puede '
            + 'ejecutarse como root y solicitará confirmación.');
          Summary :=
            'Origen: ' + FSourceDir + LineEnding +
            'Binario: ' + FBinaryPath + LineEnding +
            'Usuario: ' + FAppUser + LineEnding +
            'VeriFactu: ' + FVFMode + LineEnding +
            'Tienda 0: ' + FShopName + LineEnding +
            'NIF/CIF: ' + FShopNIF + LineEnding +
            'Localidad: ' + FShopCity + LineEnding +
            'Host BD tienda: ' + FShopDBHost + ':' + FShopDBPort + LineEnding +
            'Base de datos: ' + FDBName + LineEnding +
            'Usuario BD: ' + FDBUser + LineEnding + LineEnding +
            'La instalación de archivos y auxiliares de backup/restore se realizará ahora. ' +
            'La creación de FacturConf.ini y BBDD permanece diferida a la primera ejecución de FacturLinEx.';
          AddMemo(Summary, 145, 270);
        end;
      end;
    5:
      begin
        if FServerMode then
          AddHeading('Instalación del servidor',
            'Pulse Instalar servidor para preparar MariaDB, copias remotas y permisos. '
            + 'Este panel muestra el resultado acumulado de la última ejecución.')
        else
          AddHeading('Instalación',
            'Pulse Instalar para ejecutar el instalador maestro. La aplicación mostrará '
            + 'la salida de cada fase y guardará un registro completo.');
        AddMemo(FLog.Text, 135, 330);
        if FServerMode then btnNext.Caption := 'Instalar servidor' else btnNext.Caption := 'Instalar';
      end;

    6:
      begin
        { Estado final inequívoco: no dejar botones de instalación/navegación
          que puedan hacer pensar que el proceso continúa. }
        ProgressBar.Position := 100;
        lblProgress.Caption := 'Instalación completada';
        btnBack.Caption := 'Ver log';
        btnBack.Enabled := True;
        btnBack.SetBounds(70, 24, 130, 42);
        btnNext.Caption := 'Cerrar';
        btnNext.Enabled := True;
        btnNext.SetBounds(210, 24, 130, 42);
        btnCancel.Visible := False;

        if FServerMode then
        begin
          AddHeading('Servidor FacturLinEx instalado correctamente',
            'La instalación ha finalizado. La prueba final del servidor debe haber devuelto FLX_SERVER_OK.');
          AddMemo(
            'Servidor FacturLinEx preparado para copias/restauraciones remotas.' + LineEnding + LineEnding +
            'Compruebe:' + LineEnding +
            '• MariaDB y SSH activos.' + LineEnding +
            '• /usr/local/sbin/flx_remote_backup_server.' + LineEnding +
            '• /etc/facturlinex/backup.cnf con permisos 0600.' + LineEnding +
            '• /etc/sudoers.d/facturlinex-backup validado.' + LineEnding +
            '• Resultado FLX_SERVER_OK.' + LineEnding + LineEnding +
            'Si utilizará autenticación SSH por contraseña y el usuario fue creado por el instalador, '
            + 'asígnele posteriormente una contraseña Linux segura.',
            150, 240);

          B := TBitBtn.Create(Self);
          B.Parent := pnlBody;
          B.Caption := 'Ver log de instalación';
          B.SetBounds(180, 420, 190, 42);
          B.OnClick := @OpenInstallLog;

          B := TBitBtn.Create(Self);
          B.Parent := pnlBody;
          B.Caption := 'Abrir guía servidor';
          B.SetBounds(400, 420, 180, 42);
          B.OnClick := @OpenDocumentation;
        end
        else
        begin
          AddHeading('FacturLinEx instalado correctamente',
            'La instalación ha finalizado. Puede revisar el log y completar las comprobaciones recomendadas.');

          AddMemo(
            'Prueba recomendada:' + LineEnding +
            '1. Revise el log de instalación.' + LineEnding +
            '2. Revise el diagnóstico de FLXTools.' + LineEnding +
            '3. Ejecute FacturLinEx y complete la configuración inicial/BBDD.' + LineEnding +
            '4. Ejecute el Centro de Salud.' + LineEnding +
            '5. Abra la documentación instalada.' + LineEnding + LineEnding +
            'Certificado .p12: PENDIENTE PARA UNA FASE POSTERIOR. Será opcional y podrá saltarse, '
            + 'ya que FacturLinEx permite configurarlo después de la instalación.',
            150, 220);

          B := TBitBtn.Create(Self);
          B.Parent := pnlBody;
          B.Caption := 'Ver log de instalación';
          B.SetBounds(80, 390, 180, 42);
          B.OnClick := @OpenInstallLog;

          B := TBitBtn.Create(Self);
          B.Parent := pnlBody;
          B.Caption := 'Ver diagnóstico FLXTools';
          B.SetBounds(280, 390, 190, 42);
          B.OnClick := @OpenToolsDiag;

          B := TBitBtn.Create(Self);
          B.Parent := pnlBody;
          B.Caption := 'Ejecutar FacturLinEx';
          B.SetBounds(490, 390, 170, 42);
          B.OnClick := @RunFacturLinEx;

          B := TBitBtn.Create(Self);
          B.Parent := pnlBody;
          B.Caption := 'Centro de Salud';
          B.SetBounds(180, 455, 170, 42);
          B.OnClick := @RunHealthCenter;

          B := TBitBtn.Create(Self);
          B.Parent := pnlBody;
          B.Caption := 'Abrir documentación';
          B.SetBounds(380, 455, 180, 42);
          B.OnClick := @OpenDocumentation;
        end;
      end;
  end;
end;

procedure TfrmFLXInstaller.BackClick(Sender: TObject);
begin
  if FRunning then Exit;

  if FPage = 6 then
  begin
    OpenInstallLog(Sender);
    Exit;
  end;

  if FPage = 0 then
  begin
    FServerMode := False;
    ShowPage(1);
    Exit;
  end;

  ShowPage(FPage - 1);
end;

procedure TfrmFLXInstaller.NextClick(Sender: TObject);
var
  E: TEdit;
  C: TComboBox;
begin
  if FRunning then Exit;

  case FPage of
    0:
      begin
        { En la bienvenida btnNext representa el perfil SERVIDOR. }
        FServerMode := True;
        ShowPage(1);
      end;
    1:
      begin
        E := TEdit(pnlBody.FindChildControl('edtSource'));
        if Assigned(E) then FSourceDir := Trim(E.Text);
        if FServerMode then
        begin
          E := TEdit(pnlBody.FindChildControl('edtServerSSHUser'));
          if Assigned(E) then FServerSSHUser := Trim(E.Text);
          if FServerSSHUser = '' then
          begin
            MessageDlg('Debe indicar el usuario Linux/SSH autorizado.', mtWarning, [mbOK], 0);
            Exit;
          end;
        end
        else
        begin
          E := TEdit(pnlBody.FindChildControl('edtBinary'));
          if Assigned(E) then FBinaryPath := Trim(E.Text);
          E := TEdit(pnlBody.FindChildControl('edtUser'));
          if Assigned(E) then FAppUser := Trim(E.Text);
        end;
        ShowPage(2);
      end;
    2:
      begin
        { Cada comprobación empieza con un registro limpio para que el usuario
          vea únicamente el resultado de este intento. }
        FLog.Clear;

        if (FServerMode and RunServerInstaller(False)) or
           ((not FServerMode) and RunMasterInstaller(False)) then
        begin
          SaveLog;
          ShowPage(3);
        end
        else
        begin
          SaveLog;
          ShowPage(2);
          MessageDlg(
            'La comprobación previa ha detectado errores.' + LineEnding +
            'La salida completa se muestra en esta pantalla y se ha guardado el log.',
            mtWarning, [mbOK], 0);
        end;
      end;
    3:
      begin
        if FServerMode then
        begin
          ShowPage(4);
          Exit;
        end;
        C := TComboBox(pnlBody.FindChildControl('cmbVFMode'));
        if Assigned(C) and (C.ItemIndex >= 0) then
          FVFMode := C.Items[C.ItemIndex];

        E := TEdit(pnlBody.FindChildControl('edtShopName')); if Assigned(E) then FShopName := Trim(E.Text);
        E := TEdit(pnlBody.FindChildControl('edtShopNIF')); if Assigned(E) then FShopNIF := Trim(E.Text);
        E := TEdit(pnlBody.FindChildControl('edtShopAddress')); if Assigned(E) then FShopAddress := Trim(E.Text);
        E := TEdit(pnlBody.FindChildControl('edtShopCity')); if Assigned(E) then FShopCity := Trim(E.Text);
        E := TEdit(pnlBody.FindChildControl('edtShopZip')); if Assigned(E) then FShopZip := Trim(E.Text);
        E := TEdit(pnlBody.FindChildControl('edtShopProvince')); if Assigned(E) then FShopProvince := Trim(E.Text);
        E := TEdit(pnlBody.FindChildControl('edtShopPhone')); if Assigned(E) then FShopPhone := Trim(E.Text);
        E := TEdit(pnlBody.FindChildControl('edtShopFax')); if Assigned(E) then FShopFax := Trim(E.Text);
        E := TEdit(pnlBody.FindChildControl('edtShopDBHost')); if Assigned(E) then FShopDBHost := Trim(E.Text);
        E := TEdit(pnlBody.FindChildControl('edtShopDBPort')); if Assigned(E) then FShopDBPort := Trim(E.Text);
        E := TEdit(pnlBody.FindChildControl('edtDBName')); if Assigned(E) then FDBName := Trim(E.Text);
        E := TEdit(pnlBody.FindChildControl('edtDBUser')); if Assigned(E) then FDBUser := Trim(E.Text);

        if FShopName = '' then
        begin
          MessageDlg('Debe indicar la razón social/nombre de la tienda 0.', mtWarning, [mbOK], 0);
          Exit;
        end;
        if FShopNIF = '' then
        begin
          MessageDlg('Debe indicar el NIF/CIF del obligado tributario.', mtWarning, [mbOK], 0);
          Exit;
        end;
        if FShopDBHost = '' then FShopDBHost := 'localhost';
        if FShopDBPort = '' then FShopDBPort := '3306';
        if FDBName = '' then FDBName := 'facturlinex2';
        if FDBUser = '' then FDBUser := 'facturlinex';

        ShowPage(4);
      end;
    5:
      begin
        if FServerMode then
        begin
          if MessageDlg(
            'La preparación del servidor necesita permisos de administrador.' + LineEnding + LineEnding +
            'Se instalarán/activarán MariaDB, mariadb-backup y SSH, y se crearán ' +
            'los permisos limitados para las copias remotas.' + LineEnding + LineEnding +
            'Debian solicitará las credenciales de un administrador.' + LineEnding + LineEnding +
            '¿Desea continuar?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
        end
        else
        begin
          if MessageDlg(
            'FacturLinEx necesita permisos de administrador para instalar archivos ' +
            'y configurar componentes del sistema.' + LineEnding + LineEnding +
            'Al continuar, Debian solicitará las credenciales de un administrador.' +
            LineEnding + LineEnding +
            'FacturLinEx no recibe, guarda ni registra esa contraseña.' +
            LineEnding + LineEnding +
            '¿Desea autorizar la instalación y continuar?',
            mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
        end;

        if (FServerMode and (not RunServerInstaller(True))) or
           ((not FServerMode) and (not RunMasterInstaller(True))) then
        begin
          SaveLog;
          { La página 5 contiene un TMemo creado a partir de FLog.Text.
            Hay que reconstruirla para que muestre la instalación/verificación
            recién ejecutadas y no el antiguo --check. }
          ShowPage(5);
          MessageDlg(
            'La instalación no ha podido confirmarse como finalizada correctamente.' +
            LineEnding + LineEnding +
            'Ahora se muestra en pantalla el log REAL de la última instalación/verificación.' +
            LineEnding +
            'Revíselo antes de repetir la operación.',
            mtError, [mbOK], 0);
          Exit;
        end;

        SaveLog;
        ShowPage(6);
      end;
    6: Close;
  else
    ShowPage(FPage + 1);
  end;
end;

procedure TfrmFLXInstaller.ServerInstallClick(Sender: TObject);
begin
  if FRunning then Exit;
  FServerMode := True;
  ShowPage(1);
end;

procedure TfrmFLXInstaller.CancelClick(Sender: TObject);
begin
  if FRunning then Exit;
  Close;
end;

procedure TfrmFLXInstaller.FormCloseQueryHandler(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not FRunning;
  if FRunning then
    MessageDlg('FacturLinEx está trabajando. Espere a que termine la fase actual.',
      mtInformation, [mbOK], 0);
end;

function TfrmFLXInstaller.InstallerScript: string;
begin
  Result := IncludeTrailingPathDelimiter(FSourceDir)
    + 'Instalador/instalar_facturlinex.sh';
end;

function TfrmFLXInstaller.ServerInstallerScript: string;
begin
  Result := IncludeTrailingPathDelimiter(FSourceDir)
    + 'Instalador/instalar_servidor_facturlinex.sh';
end;

function TfrmFLXInstaller.ServerScriptsAvailable(out AMissing: string): Boolean;
var
  P: string;
begin
  AMissing := '';
  P := ServerInstallerScript;
  if not FileExists(P) then AMissing := AMissing + 'Falta: ' + P + LineEnding;
  P := IncludeTrailingPathDelimiter(FSourceDir) + 'Instalador/servidor/flx_remote_backup_server';
  if not FileExists(P) then AMissing := AMissing + 'Falta: ' + P + LineEnding;
  Result := AMissing = '';
end;

function TfrmFLXInstaller.ScriptsAvailable(out AMissing: string): Boolean;
const
  RequiredScripts: array[0..6] of string = (
    'instalar_facturlinex.sh',
    'flx_requisitos.sh',
    'flx_preparar_directorios.sh',
    'flx_instalar_archivos.sh',
    'flx_preparar_mariadb.sh',
    'flx_configurar_facturlinex.sh',
    'flx_verificar_instalacion.sh'
  );
var
  S, P: string;
begin
  AMissing := '';
  for S in RequiredScripts do
  begin
    P := IncludeTrailingPathDelimiter(FSourceDir) + 'Instalador/' + S;
    if not FileExists(P) then
      AMissing := AMissing + 'Falta: ' + P + LineEnding;
  end;
  Result := AMissing = '';
end;

procedure TfrmFLXInstaller.UpdateProgress(APosition: Integer;
  const AText: string);
begin
  ProgressBar.Position := EnsureRange(APosition, 0, 100);
  lblProgress.Caption := AText;
  Application.ProcessMessages;
end;

procedure TfrmFLXInstaller.AppendLog(const ALine: string);
begin
  FLog.Add(FormatDateTime('hh:nn:ss', Now) + '  ' + ALine);

  { Persistencia inmediata: durante una comprobación larga o bloqueada,
    el fichero contiene siempre lo visto hasta ese instante. }
  if FLastLogFile <> '' then
  begin
    try
      FLog.SaveToFile(FLastLogFile);
    except
      { El fallo del log no debe interrumpir la instalación. }
    end;
  end;

  Application.ProcessMessages;
end;

function TfrmFLXInstaller.RunCommand(const AExecutable: string;
  const AParams: array of string; const APhase: string): Boolean;
var
  P: TProcess;
  Buffer: array[0..4095] of Byte;
  Count: LongInt;
  Chunk, Pending, Line: string;
  I: Integer;
begin
  Result := False;
  FillChar(Buffer, SizeOf(Buffer), 0);
  { Crear el log ANTES de lanzar el proceso para que exista incluso si
    una fase queda esperando o se bloquea. }
  ForceDirectories(GetAppConfigDir(False));
  FLastLogFile := IncludeTrailingPathDelimiter(GetAppConfigDir(False))
    + 'FLXInstaller_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.log';
  try
    FLog.SaveToFile(FLastLogFile);
  except
    FLastLogFile := '';
  end;

  FRunning := True;
  btnBack.Enabled := False;
  btnNext.Enabled := False;
  btnCancel.Enabled := False;
  Screen.Cursor := crHourGlass;
  UpdateProgress(10, APhase);

  P := TProcess.Create(nil);
  try
    P.Executable := AExecutable;
    for I := Low(AParams) to High(AParams) do
      P.Parameters.Add(AParams[I]);
    P.Options := [poUsePipes, poStderrToOutPut];
    P.ShowWindow := swoHide;

    AppendLog('Ejecutando: ' + AExecutable + ' ' + P.Parameters.Text.Replace(
      LineEnding, ' ', [rfReplaceAll]));
    P.Execute;
    Pending := '';

    while P.Running or (P.Output.NumBytesAvailable > 0) do
    begin
      while P.Output.NumBytesAvailable > 0 do
      begin
        Count := P.Output.Read(Buffer, SizeOf(Buffer));
        if Count > 0 then
        begin
          SetString(Chunk, PAnsiChar(@Buffer[0]), Count);
          Pending := Pending + Chunk;
          while Pos(LineEnding, Pending) > 0 do
          begin
            Line := Copy(Pending, 1, Pos(LineEnding, Pending) - 1);
            Delete(Pending, 1, Pos(LineEnding, Pending) + Length(LineEnding) - 1);
            AppendLog(Line);
          end;
        end;
      end;
      UpdateProgress(50, APhase + ' — trabajando...');
      Sleep(40);
    end;

    if Pending <> '' then AppendLog(Pending);
    P.WaitOnExit;
    Result := P.ExitStatus = 0;
    if Result then
      AppendLog('[CORRECTO] Fase terminada.')
    else
    begin
      if (P.ExitStatus > 255) and ((P.ExitStatus and $FF) = 0) then
        AppendLog(Format('[ERROR] Código de salida: %d (estado Unix bruto: %d)',
          [P.ExitStatus shr 8, P.ExitStatus]))
      else
        AppendLog(Format('[ERROR] Código de salida: %d', [P.ExitStatus]));
    end;
  finally
    P.Free;
    Screen.Cursor := crDefault;
    FRunning := False;
    btnBack.Enabled := True;
    btnNext.Enabled := True;
    btnCancel.Enabled := True;
    UpdateProgress(100, APhase + ' — finalizado');
  end;
end;

function TfrmFLXInstaller.RunMasterInstaller(InstallMode: Boolean): Boolean;
var
  Missing, BashPath, PkExecPath: string;
  Params, ExecParams: array of string;
  I, N: Integer;

  procedure AddParam(const S: string);
  begin
    N := Length(Params);
    SetLength(Params, N + 1);
    Params[N] := S;
  end;

  procedure AddOption(const Opt, Val: string);
  begin
    if Trim(Val) = '' then Exit;
    AddParam(Opt);
    AddParam(Val);
  end;

begin
  if not ScriptsAvailable(Missing) then
  begin
    FLog.Add(Missing);
    MessageDlg('Faltan scripts del instalador.' + LineEnding + Missing,
      mtError, [mbOK], 0);
    Exit(False);
  end;

  SetLength(Params, 0);

  if InstallMode then
    AddParam('--install')
  else
    AddParam('--check');

  AddOption('--source', FSourceDir);
  AddOption('--binary', FBinaryPath);
  AddOption('--app-user', FAppUser);
  AddOption('--vf-mode', FVFMode);

  { En la comprobación previa todavía no se han pedido los datos de tienda.
    No enviamos opciones vacías: el script no debe recibir --shop-name sin valor. }
  AddOption('--shop-name', FShopName);
  AddOption('--shop-address', FShopAddress);
  AddOption('--shop-city', FShopCity);
  AddOption('--shop-zip', FShopZip);
  AddOption('--shop-province', FShopProvince);
  AddOption('--shop-phone', FShopPhone);
  AddOption('--shop-fax', FShopFax);
  AddOption('--shop-nif', FShopNIF);
  AddOption('--shop-db-host', FShopDBHost);
  AddOption('--shop-db-port', FShopDBPort);
  AddOption('--db-name', FDBName);
  AddOption('--db-user', FDBUser);

  AddParam('--defer-first-run');
  if InstallMode then AddParam('--yes');

  { Un ZIP puede perder el bit ejecutable, por eso invocamos el maestro
    mediante bash. La comprobación se ejecuta como usuario normal.
    Para la instalación real elevamos SOLO el script maestro mediante pkexec;
    la interfaz gráfica permanece con los permisos del usuario. }
  BashPath := '/bin/bash';
  if not FileExists(BashPath) then
    BashPath := '/usr/bin/bash';

  if InstallMode and (not IsRoot) then
  begin
    PkExecPath := '/usr/bin/pkexec';
    if not FileExists(PkExecPath) then
    begin
      MessageDlg(
        'No se encuentra /usr/bin/pkexec.' + LineEnding +
        'Es necesario PolicyKit para solicitar permisos de administrador ' +
        'desde el asistente gráfico.',
        mtError, [mbOK], 0);
      Exit(False);
    end;

    SetLength(ExecParams, Length(Params) + 2);
    ExecParams[0] := BashPath;
    ExecParams[1] := InstallerScript;
    for I := 0 to High(Params) do
      ExecParams[I + 2] := Params[I];

    AppendLog('[INFO] Solicitando autorización administrativa mediante PolicyKit.');
    Result := RunCommand(PkExecPath, ExecParams, 'Instalación de FacturLinEx');
  end
  else
  begin
    SetLength(ExecParams, Length(Params) + 2);
    ExecParams[0] := 'bash';
    ExecParams[1] := InstallerScript;
    for I := 0 to High(Params) do
      ExecParams[I + 2] := Params[I];

    Result := RunCommand('/usr/bin/env', ExecParams,
      IfThen(InstallMode, 'Instalación de FacturLinEx',
        'Comprobación previa del sistema'));
  end;
end;

function TfrmFLXInstaller.RunServerInstaller(InstallMode: Boolean): Boolean;
var
  Missing, BashPath, PkExecPath: string;
  Params, ExecParams, VerifyParams: array of string;
  I, N: Integer;

  procedure AddParam(const S: string);
  begin
    N := Length(Params);
    SetLength(Params, N + 1);
    Params[N] := S;
  end;

begin
  Result := False;

  if not ServerScriptsAvailable(Missing) then
  begin
    FLog.Add(Missing);
    MessageDlg('Faltan componentes del instalador de servidor.' + LineEnding + Missing,
      mtError, [mbOK], 0);
    Exit;
  end;

  SetLength(Params, 0);
  if InstallMode then AddParam('--install') else AddParam('--check');
  AddParam('--source'); AddParam(FSourceDir);
  AddParam('--ssh-user'); AddParam(FServerSSHUser);
  if InstallMode then AddParam('--yes');

  BashPath := '/bin/bash';
  if not FileExists(BashPath) then BashPath := '/usr/bin/bash';

  if InstallMode and (not IsRoot) then
  begin
    PkExecPath := '/usr/bin/pkexec';
    if not FileExists(PkExecPath) then
    begin
      MessageDlg('No se encuentra /usr/bin/pkexec. Es necesario PolicyKit para solicitar permisos de administrador.',
        mtError, [mbOK], 0);
      Exit;
    end;

    SetLength(ExecParams, Length(Params) + 2);
    ExecParams[0] := BashPath;
    ExecParams[1] := ServerInstallerScript;
    for I := 0 to High(Params) do
      ExecParams[I + 2] := Params[I];

    AppendLog('[INFO] Solicitando autorización administrativa para preparar el servidor.');
    { Ejecutamos la instalación elevada, pero NO usamos este código de retorno
      como confirmación definitiva. La verificación posterior decide el resultado. }
    RunCommand(PkExecPath, ExecParams, 'Instalación de servidor MariaDB');
  end
  else
  begin
    SetLength(ExecParams, Length(Params) + 2);
    ExecParams[0] := 'bash';
    ExecParams[1] := ServerInstallerScript;
    for I := 0 to High(Params) do
      ExecParams[I + 2] := Params[I];

    if not InstallMode then
    begin
      Result := RunCommand('/usr/bin/env', ExecParams, 'Comprobación previa del servidor');
      Exit;
    end;

    RunCommand('/usr/bin/env', ExecParams, 'Instalación de servidor MariaDB');
  end;

  { La instalación real se confirma siempre con una segunda prueba independiente,
    ejecutada como usuario normal. }
  SetLength(VerifyParams, 7);
  VerifyParams[0] := 'bash';
  VerifyParams[1] := ServerInstallerScript;
  VerifyParams[2] := '--verify';
  VerifyParams[3] := '--source';
  VerifyParams[4] := FSourceDir;
  VerifyParams[5] := '--ssh-user';
  VerifyParams[6] := FServerSSHUser;

  AppendLog('[INFO] Ejecutando verificación real posterior del servidor...');
  Result := RunCommand('/usr/bin/env', VerifyParams, 'Verificación final del servidor');

  if Result then
    AppendLog('[CORRECTO] Servidor validado mediante FLX_SERVER_VERIFY_OK.')
  else
    AppendLog('[ERROR] La verificación real del servidor instalado ha fallado.');
end;

procedure TfrmFLXInstaller.SaveLog;
var
  D, N: string;
begin
  try
    if FLastLogFile = '' then
    begin
      D := GetAppConfigDir(False);
      ForceDirectories(D);
      N := IncludeTrailingPathDelimiter(D)
        + 'FLXInstaller_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.log';
      FLastLogFile := N;
    end;

    FLog.Add(FormatDateTime('hh:nn:ss', Now) +
      '  Log: ' + FLastLogFile);
    FLog.SaveToFile(FLastLogFile);
  except
    on E: Exception do
      AppendLog('No se pudo guardar el log: ' + E.Message);
  end;
end;

function TfrmFLXInstaller.IsRoot: Boolean;
begin
  Result := fpGetEUID = 0;
end;

procedure TfrmFLXInstaller.OpenInstallLog(Sender: TObject);
var
  Dir, F: string;
  SR: TSearchRec;
  NewestTime: LongInt;
begin
  { Primero el fichero exacto guardado por esta ejecución. }
  if (FLastLogFile <> '') and FileExists(FLastLogFile) then
  begin
    OpenDocument(FLastLogFile);
    Exit;
  end;

  { Recuperación: localizar el FLXInstaller_FECHA_HORA.log más reciente. }
  Dir := GetAppConfigDir(False);
  F := '';
  NewestTime := -1;

  if FindFirst(IncludeTrailingPathDelimiter(Dir) + 'FLXInstaller_*.log',
               faAnyFile, SR) = 0 then
  begin
    repeat
      if SR.Time > NewestTime then
      begin
        NewestTime := SR.Time;
        F := IncludeTrailingPathDelimiter(Dir) + SR.Name;
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;

  if (F <> '') and FileExists(F) then
    OpenDocument(F)
  else
    MessageDlg(
      'No se ha localizado ningún log del instalador en:' + LineEnding + Dir,
      mtInformation, [mbOK], 0);
end;

procedure TfrmFLXInstaller.OpenToolsDiag(Sender: TObject);
var
  Dir, F: string;
  SR: TSearchRec;
  NewestTime: LongInt;
begin
  Dir := IncludeTrailingPathDelimiter(GetUserDir) + '.config/FLXTools/';
  F := '';
  NewestTime := -1;

  if FindFirst(Dir + 'Diagnostico_FLXTools_*.txt', faAnyFile, SR) = 0 then
  begin
    repeat
      if SR.Time > NewestTime then
      begin
        NewestTime := SR.Time;
        F := Dir + SR.Name;
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;

  if (F <> '') and FileExists(F) then
    OpenDocument(F)
  else
    MessageDlg('No se ha encontrado ningún diagnóstico FLXTools en:' + LineEnding + Dir,
               mtInformation, [mbOK], 0);
end;

procedure TfrmFLXInstaller.RunFacturLinEx(Sender: TObject);
var
  P: TProcess;
begin
  if not FileExists('/usr/bin/FacturLinEx') then
  begin
    MessageDlg('No existe /usr/bin/FacturLinEx.', mtWarning, [mbOK], 0);
    Exit;
  end;

  P := TProcess.Create(nil);
  try
    P.Executable := '/usr/bin/FacturLinEx';
    P.Options := [];
    P.Execute;
  finally
    P.Free;
  end;
end;

procedure TfrmFLXInstaller.RunHealthCenter(Sender: TObject);
const
  Candidates: array[0..2] of string = (
    '/usr/bin/FLXMantenimiento',
    '/usr/share/facturlinex2/Bin/FLXMantenimiento',
    '/usr/share/facturlinex2/FLXMantenimiento'
  );
var
  I: Integer;
  P: TProcess;
begin
  for I := Low(Candidates) to High(Candidates) do
    if FileExists(Candidates[I]) then
    begin
      P := TProcess.Create(nil);
      try
        P.Executable := Candidates[I];
        P.Options := [];
        P.Execute;
      finally
        P.Free;
      end;
      Exit;
    end;

  MessageDlg('No se ha localizado FLXMantenimiento en las rutas instaladas conocidas.',
             mtInformation, [mbOK], 0);
end;

procedure TfrmFLXInstaller.OpenDocumentation(Sender: TObject);
const
  Candidates: array[0..3] of string = (
    '/usr/share/facturlinex2/Documentacion',
    '/usr/share/facturlinex2/documentacion',
    '/usr/share/facturlinex2/Documentacion/VeriFactu',
    '/usr/share/facturlinex2/documentacion/VeriFactu'
  );
var
  I: Integer;
  ServerGuide: string;
begin
  if FServerMode then
  begin
    ServerGuide := IncludeTrailingPathDelimiter(FSourceDir) +
      'Instalador/servidor/GUIA_SERVIDOR.txt';
    if FileExists(ServerGuide) then
    begin
      OpenDocument(ServerGuide);
      Exit;
    end;
  end;
  for I := Low(Candidates) to High(Candidates) do
    if DirectoryExists(Candidates[I]) then
    begin
      OpenDocument(Candidates[I]);
      Exit;
    end;

  if DirectoryExists(FSourceDir + DirectorySeparator + 'Documentacion') then
    OpenDocument(FSourceDir + DirectorySeparator + 'Documentacion')
  else
    MessageDlg('No se ha localizado la documentación instalada.',
               mtInformation, [mbOK], 0);
end;


end.
