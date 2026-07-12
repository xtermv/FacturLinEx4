unit uBackupFTPConfig;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, IniFiles, uFLX_CryptoIni, uFLXIcons;

type
  TEncryptSecretEvent = function(const AValue: string): string of object;
  TDecryptSecretEvent = function(const AValue: string): string of object;

  TBackupFTPConfigData = record
    UseFTPS: Boolean;
    Host: string;
    Port: Integer;
    User: string;
    PasswordEnc: string;
    RemoteDir: string;
    CreateRemoteDir: Boolean;
    Passive: Boolean;
    Compress: Boolean;
    ArchiveFormat: string;
    EncryptArchive: Boolean;
    ArchivePasswordEnc: string;
    DeleteSourceAfterArchive: Boolean;
    DeleteArchiveAfterFTP: Boolean;
  end;

procedure DefaultBackupFTPConfig(out Cfg: TBackupFTPConfigData);
function LoadBackupFTPConfig(const AFileName: string; out Cfg: TBackupFTPConfigData): Boolean;
procedure SaveBackupFTPConfig(const AFileName: string; const Cfg: TBackupFTPConfigData);

type
  { TfBackupFTPConfig }

  TfBackupFTPConfig = class(TForm)
    btnCancelar: TBitBtn;
    btnCerrar: TBitBtn;
    btnGuardar: TBitBtn;
    cbArchiveFormat: TComboBox;
    cbProto: TComboBox;
    chkCompress: TCheckBox;
    chkCreateRemoteDir: TCheckBox;
    chkDeleteArchiveAfterFTP: TCheckBox;
    chkDeleteSourceAfterArchive: TCheckBox;
    chkEncryptArchive: TCheckBox;
    chkPassive: TCheckBox;
    edArchivePassword: TEdit;
    edHost: TEdit;
    edPassword: TEdit;
    edPort: TEdit;
    edRemoteDir: TEdit;
    edUser: TEdit;
    lblArchiveFormat: TLabel;
    lblArchivePassword: TLabel;
    lblHost: TLabel;
    lblNote: TLabel;
    lblPassword: TLabel;
    lblPort: TLabel;
    lblProto: TLabel;
    lblRemoteDir: TLabel;
    lblUser: TLabel;
    imgHeader: TImage;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    lblConexion: TLabel;
    lblArchivo: TLabel;
    lblLimpieza: TLabel;
    pnlHeader: TPanel;
    pnlContenido: TPanel;
    pnlConexion: TPanel;
    pnlArchivo: TPanel;
    pnlLimpieza: TPanel;
    pnlFooter: TPanel;
    pnlFooterButtons: TPanel;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnCerrarClick(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FConfigFileName: string;
    FOnEncryptSecret: TEncryptSecretEvent;
    FOnDecryptSecret: TDecryptSecretEvent;
    procedure LoadFromIni;
    procedure SaveToIni;
  public
    property ConfigFileName: string read FConfigFileName write FConfigFileName;
    property OnEncryptSecret: TEncryptSecretEvent read FOnEncryptSecret write FOnEncryptSecret;
    property OnDecryptSecret: TDecryptSecretEvent read FOnDecryptSecret write FOnDecryptSecret;
  end;

var
  fBackupFTPConfig: TfBackupFTPConfig;

implementation

{$R *.lfm}

procedure DefaultBackupFTPConfig(out Cfg: TBackupFTPConfigData);
begin
  Cfg.UseFTPS := False;
  Cfg.Host := '';
  Cfg.Port := 21;
  Cfg.User := '';
  Cfg.PasswordEnc := '';
  Cfg.RemoteDir := '/copias/facturlinex';
  Cfg.CreateRemoteDir := True;
  Cfg.Passive := True;
  Cfg.Compress := True;
  Cfg.ArchiveFormat := '7z';
  Cfg.EncryptArchive := False;
  Cfg.ArchivePasswordEnc := '';
  Cfg.DeleteSourceAfterArchive := False;
  Cfg.DeleteArchiveAfterFTP := False;
end;

function LoadBackupFTPConfig(const AFileName: string; out Cfg: TBackupFTPConfigData): Boolean;
var
  Ini: TIniFile;
begin
  DefaultBackupFTPConfig(Cfg);
  Result := FileExists(AFileName);
  if not Result then
    Exit;

  Ini := TIniFile.Create(AFileName);
  try
    Cfg.UseFTPS := Ini.ReadBool('FTP', 'UseFTPS', Cfg.UseFTPS);
    Cfg.Host := Ini.ReadString('FTP', 'Host', Cfg.Host);
    Cfg.Port := Ini.ReadInteger('FTP', 'Port', Cfg.Port);
    Cfg.User := Ini.ReadString('FTP', 'User', Cfg.User);
    Cfg.PasswordEnc := Ini.ReadString('FTP', 'PasswordEnc', Cfg.PasswordEnc);
    Cfg.RemoteDir := Ini.ReadString('FTP', 'RemoteDir', Cfg.RemoteDir);
    Cfg.CreateRemoteDir := Ini.ReadBool('FTP', 'CreateRemoteDir', Cfg.CreateRemoteDir);
    Cfg.Passive := Ini.ReadBool('FTP', 'Passive', Cfg.Passive);
    Cfg.Compress := Ini.ReadBool('BACKUP', 'Compress', Cfg.Compress);
    Cfg.ArchiveFormat := Ini.ReadString('BACKUP', 'ArchiveFormat', Cfg.ArchiveFormat);
    Cfg.EncryptArchive := Ini.ReadBool('BACKUP', 'EncryptArchive', Cfg.EncryptArchive);
    Cfg.ArchivePasswordEnc := Ini.ReadString('BACKUP', 'ArchivePasswordEnc', Cfg.ArchivePasswordEnc);
    Cfg.DeleteSourceAfterArchive := Ini.ReadBool('BACKUP', 'DeleteSourceAfterArchive', Cfg.DeleteSourceAfterArchive);
    Cfg.DeleteArchiveAfterFTP := Ini.ReadBool('BACKUP', 'DeleteArchiveAfterFTP', Cfg.DeleteArchiveAfterFTP);

    if (Cfg.PasswordEnc = '') and Ini.ValueExists('FTP', 'Password') then
      Cfg.PasswordEnc := FLX_EncryptStringCtx(Ini.ReadString('FTP', 'Password', ''), 'FTP|PasswordEnc');

    if (Cfg.ArchivePasswordEnc = '') and Ini.ValueExists('BACKUP', 'ArchivePassword') then
      Cfg.ArchivePasswordEnc := FLX_EncryptStringCtx(Ini.ReadString('BACKUP', 'ArchivePassword', ''), 'BACKUP|ArchivePasswordEnc');

    Result := True;
  finally
    Ini.Free;
  end;
end;

procedure SaveBackupFTPConfig(const AFileName: string; const Cfg: TBackupFTPConfigData);
var
  Ini: TIniFile;
begin
  ForceDirectories(ExtractFileDir(AFileName));
  Ini := TIniFile.Create(AFileName);
  try
    Ini.WriteBool('FTP', 'UseFTPS', Cfg.UseFTPS);
    Ini.WriteString('FTP', 'Host', Cfg.Host);
    Ini.WriteInteger('FTP', 'Port', Cfg.Port);
    Ini.WriteString('FTP', 'User', Cfg.User);
    Ini.WriteString('FTP', 'PasswordEnc', Cfg.PasswordEnc);
    Ini.DeleteKey('FTP', 'Password');
    Ini.WriteString('FTP', 'RemoteDir', Cfg.RemoteDir);
    Ini.WriteBool('FTP', 'CreateRemoteDir', Cfg.CreateRemoteDir);
    Ini.WriteBool('FTP', 'Passive', Cfg.Passive);
    Ini.WriteBool('BACKUP', 'Compress', Cfg.Compress);
    Ini.WriteString('BACKUP', 'ArchiveFormat', Cfg.ArchiveFormat);
    Ini.WriteBool('BACKUP', 'EncryptArchive', Cfg.EncryptArchive);
    Ini.WriteString('BACKUP', 'ArchivePasswordEnc', Cfg.ArchivePasswordEnc);
    Ini.DeleteKey('BACKUP', 'ArchivePassword');
    Ini.WriteBool('BACKUP', 'DeleteSourceAfterArchive', Cfg.DeleteSourceAfterArchive);
    Ini.WriteBool('BACKUP', 'DeleteArchiveAfterFTP', Cfg.DeleteArchiveAfterFTP);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

{ TfBackupFTPConfig }

procedure TfBackupFTPConfig.FormCreate(Sender: TObject);
var
  FN: string;
begin
  Color := RGBToColor(245, 248, 252);
  pnlHeader.Color := RGBToColor(248, 251, 255);
  pnlContenido.Color := RGBToColor(245, 248, 252);
  pnlConexion.Color := RGBToColor(250, 252, 255);
  pnlArchivo.Color := RGBToColor(248, 251, 255);
  pnlLimpieza.Color := RGBToColor(236, 244, 255);
  pnlFooter.Color := RGBToColor(248, 251, 255);
  pnlFooterButtons.Color := pnlFooter.Color;

  lblTitulo.Font.Color := RGBToColor(0, 32, 80);
  lblSubtitulo.Font.Color := RGBToColor(45, 70, 105);
  lblConexion.Font.Color := RGBToColor(0, 65, 145);
  lblArchivo.Font.Color := RGBToColor(0, 65, 145);
  lblLimpieza.Font.Color := RGBToColor(0, 65, 145);
  lblNote.Font.Color := RGBToColor(45, 70, 105);

  FN := FLXIconFile('configuracion', 64);
  if FN <> '' then
    imgHeader.Picture.LoadFromFile(FN);

  FLXSetBitBtnIcon(btnGuardar, 'configuracion', 30);
  FLXSetBitBtnIcon(btnCancelar, 'cerrar', 30);

  cbProto.Items.Clear;
  cbProto.Items.Add('FTP');
  cbProto.Items.Add('FTPS');
  cbProto.ItemIndex := 0;

  cbArchiveFormat.Items.Clear;
  cbArchiveFormat.Items.Add('7z');
  cbArchiveFormat.Items.Add('tar.gz');
  cbArchiveFormat.ItemIndex := 0;

  edPassword.PasswordChar := '*';
  edArchivePassword.PasswordChar := '*';
end;

procedure TfBackupFTPConfig.FormShow(Sender: TObject);
begin
  LoadFromIni;
end;

procedure TfBackupFTPConfig.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfBackupFTPConfig.btnCerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TfBackupFTPConfig.btnGuardarClick(Sender: TObject);
begin
  SaveToIni;
end;

procedure TfBackupFTPConfig.LoadFromIni;
var
  Cfg: TBackupFTPConfigData;
begin
  if Trim(FConfigFileName) = '' then
    Exit;

  LoadBackupFTPConfig(FConfigFileName, Cfg);

  if Cfg.UseFTPS then
    cbProto.ItemIndex := 1
  else
    cbProto.ItemIndex := 0;

  edHost.Text := Cfg.Host;
  edPort.Text := IntToStr(Cfg.Port);
  edUser.Text := Cfg.User;
  edRemoteDir.Text := Cfg.RemoteDir;
  chkCreateRemoteDir.Checked := Cfg.CreateRemoteDir;
  chkPassive.Checked := Cfg.Passive;
  chkCompress.Checked := Cfg.Compress;
  cbArchiveFormat.Text := Cfg.ArchiveFormat;
  chkEncryptArchive.Checked := Cfg.EncryptArchive;
  chkDeleteSourceAfterArchive.Checked := Cfg.DeleteSourceAfterArchive;
  chkDeleteArchiveAfterFTP.Checked := Cfg.DeleteArchiveAfterFTP;

  edPassword.Text := '';
  edArchivePassword.Text := '';

  if Cfg.PasswordEnc <> '' then
  begin
    if Assigned(FOnDecryptSecret) then
      edPassword.Text := FOnDecryptSecret(Cfg.PasswordEnc)
    else
      edPassword.Text := FLX_DecryptStringCtx(Cfg.PasswordEnc, 'FTP|PasswordEnc');
  end;

  if Cfg.ArchivePasswordEnc <> '' then
  begin
    if Assigned(FOnDecryptSecret) then
      edArchivePassword.Text := FOnDecryptSecret(Cfg.ArchivePasswordEnc)
    else
      edArchivePassword.Text := FLX_DecryptStringCtx(Cfg.ArchivePasswordEnc, 'BACKUP|ArchivePasswordEnc');
  end;
end;

procedure TfBackupFTPConfig.SaveToIni;
var
  Cfg: TBackupFTPConfigData;
  Existing: TBackupFTPConfigData;
  P: Integer;
  WarnSecrets: Boolean;
begin
  if Trim(FConfigFileName) = '' then
  begin
    ShowMessage('No se ha indicado ConfigFileName.');
    Exit;
  end;

  DefaultBackupFTPConfig(Cfg);
  LoadBackupFTPConfig(FConfigFileName, Existing);

  Cfg.UseFTPS := cbProto.ItemIndex = 1;
  Cfg.Host := Trim(edHost.Text);
  P := StrToIntDef(Trim(edPort.Text), 0);
  if P <= 0 then
  begin
    ShowMessage('El puerto FTP no es válido.');
    Exit;
  end;
  Cfg.Port := P;
  Cfg.User := Trim(edUser.Text);
  Cfg.RemoteDir := Trim(edRemoteDir.Text);
  if Cfg.RemoteDir = '' then
    Cfg.RemoteDir := '/copias/facturlinex';
  Cfg.CreateRemoteDir := chkCreateRemoteDir.Checked;
  Cfg.Passive := chkPassive.Checked;
  Cfg.Compress := chkCompress.Checked;
  Cfg.ArchiveFormat := Trim(cbArchiveFormat.Text);
  if Cfg.ArchiveFormat = '' then
    Cfg.ArchiveFormat := '7z';
  Cfg.EncryptArchive := chkEncryptArchive.Checked;
  Cfg.DeleteSourceAfterArchive := chkDeleteSourceAfterArchive.Checked;
  Cfg.DeleteArchiveAfterFTP := chkDeleteArchiveAfterFTP.Checked;

  Cfg.PasswordEnc := Existing.PasswordEnc;
  Cfg.ArchivePasswordEnc := Existing.ArchivePasswordEnc;
  WarnSecrets := False;

  if Trim(edPassword.Text) <> '' then
  begin
    if Assigned(FOnEncryptSecret) then
      Cfg.PasswordEnc := FOnEncryptSecret(edPassword.Text)
    else
      Cfg.PasswordEnc := FLX_EncryptStringCtx(edPassword.Text, 'FTP|PasswordEnc');
  end
  else
    Cfg.PasswordEnc := '';

  if Trim(edArchivePassword.Text) <> '' then
  begin
    if Assigned(FOnEncryptSecret) then
      Cfg.ArchivePasswordEnc := FOnEncryptSecret(edArchivePassword.Text)
    else
      Cfg.ArchivePasswordEnc := FLX_EncryptStringCtx(edArchivePassword.Text, 'BACKUP|ArchivePasswordEnc');
  end
  else
    Cfg.ArchivePasswordEnc := '';

  SaveBackupFTPConfig(FConfigFileName, Cfg);

  if WarnSecrets then
    ShowMessage('La configuración general se ha guardado.');

  ModalResult := mrOk;
end;

end.
