unit uVeriSIFForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  LCLType, ExtCtrls, uVeriSIF, Global, uVF_CertTools, IniFiles;

type

  { TFSIFConfig }

  TFSIFConfig = class(TForm)
    btnAceptar: TBitBtn;
    btnCancelar: TBitBtn;
    BtnProbarCert: TBitBtn;
    Button1: TButton;
    CheckSoloVF: TCheckBox;
    CheckMultiOT: TCheckBox;
    CheckMultiplesOT: TCheckBox;
    EditP12File: TEdit;
    EditP12Password: TEdit;
    EditOpenSSLPath: TEdit;
    EditCertFile: TEdit;
    EditKeyFile: TEdit;
    EditCAFile: TEdit;
    EditNombreSistema: TEdit;
    EditIdSistema: TEdit;
    EditVersion: TEdit;
    EditNumeroInst: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    PnlHeader: TPanel;
    LblTitulo: TLabel;
    LblSubtitulo: TLabel;
    GBSistema: TGroupBox;
    GBCertificado: TGroupBox;
    LblAyudaSistema: TLabel;
    LblAyudaTLS: TLabel;
    LblAvisoTLS: TLabel;
    LblPie: TLabel;
    procedure BtnCancelarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnAceptarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure BtnProbarCertClick(Sender: TObject);
  private
    FSIFCfg: TVeriSIFConfig;
  public
    // Puedes exponer algo si lo necesitas más adelante
  end;

var
  FSIFConfig: TFSIFConfig;

implementation

uses
  // ...
  uFLX_CryptoIni; // <-- TU unidad de encriptación (pon aquí el nombre real)


{$R *.lfm}

{ TFSIFConfig }

function SIF_GetIniPath: string;
begin
  // Usamos la misma lógica que en otras unidades:
  if Trim(RutaIni) <> '' then
    Result := IncludeTrailingPathDelimiter(RutaIni) + 'FacturConf.ini'
  else
  {$IFDEF UNIX}
    Result := IncludeTrailingPathDelimiter(
                GetEnvironmentVariable('HOME')) +
              '.facturlinex2' + DirectorySeparator + 'FacturConf.ini';
  {$ELSE}
    Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
              'FacturConf.ini';
  {$ENDIF}
end;


//-- Boton para probar si hay certificado co la información de FacturConf.ini
procedure TFSIFConfig.BtnProbarCertClick(Sender: TObject);
var
  Msg: string;
begin
  if VF_TLS_EnsurePEMsFromP12(Msg) then
    ShowMessage('OK: ' + Msg)
  else
    ShowMessage('ERROR: ' + Msg);
end;

function GenerarUUID: string;
var
  guid: TGUID;
begin
  // Crear un nuevo GUID/UUID
  CreateGUID(guid);
  // Convertirlo a string con el formato estándar
  Result := GUIDToString(guid);
end;

procedure TFSIFConfig.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      begin
        ModalResult := mrCancel;
        Key := 0;
      end;

    VK_RETURN:
      begin
        ModalResult := mrOk;
        Key := 0;
      end;
  end;
end;

procedure TFSIFConfig.FormResize(Sender: TObject);
var
  Margen, Separacion, TopContenido, AltoContenido, AnchoIzq: Integer;
begin
  if (not Assigned(GBSistema)) or (not Assigned(GBCertificado)) then Exit;

  Margen := 16;
  Separacion := 14;
  TopContenido := PnlHeader.Height + Margen;
  AltoContenido := ClientHeight - PnlHeader.Height - Panel1.Height - (Margen * 2);
  if AltoContenido < 470 then AltoContenido := 470;

  AnchoIzq := (ClientWidth - (Margen * 2) - Separacion) div 2;
  if AnchoIzq < 470 then AnchoIzq := 470;

  GBSistema.SetBounds(Margen, TopContenido, AnchoIzq, AltoContenido);
  GBCertificado.SetBounds(Margen + AnchoIzq + Separacion, TopContenido,
    ClientWidth - (Margen * 2) - Separacion - AnchoIzq, AltoContenido);

  EditNombreSistema.Width := GBSistema.ClientWidth - EditNombreSistema.Left - 18;
  Button1.Left := GBSistema.ClientWidth - Button1.Width - 18;
  EditIdSistema.Width := Button1.Left - EditIdSistema.Left - 10;
  EditVersion.Width := GBSistema.ClientWidth - EditVersion.Left - 18;
  EditNumeroInst.Width := GBSistema.ClientWidth - EditNumeroInst.Left - 18;

  EditP12File.Width := GBCertificado.ClientWidth - EditP12File.Left - 18;
  EditP12Password.Width := GBCertificado.ClientWidth - EditP12Password.Left - 18;
  EditOpenSSLPath.Width := GBCertificado.ClientWidth - EditOpenSSLPath.Left - 18;
  EditCertFile.Width := GBCertificado.ClientWidth - EditCertFile.Left - 18;
  EditKeyFile.Width := GBCertificado.ClientWidth - EditKeyFile.Left - 18;
  EditCAFile.Width := GBCertificado.ClientWidth - EditCAFile.Left - 18;

  btnCancelar.Left := Panel1.ClientWidth - btnCancelar.Width - 22;
  btnAceptar.Left := btnCancelar.Left - btnAceptar.Width - 12;
end;

procedure TFSIFConfig.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
  IniPath: string;
 begin
  // Cargar configuración desde FacturConf.ini
  VF_SIF_Load(FSIFCfg);

  // Rellenar controles
  EditNombreSistema.Text := FSIFCfg.NombreSistema;
  EditIdSistema.Text     := FSIFCfg.IdSistema;
  EditVersion.Text       := FSIFCfg.Version;
  EditNumeroInst.Text    := FSIFCfg.NumeroInstalacion;

  CheckSoloVF.Checked      := SameText(FSIFCfg.SoloVerifactu, 'S');
  CheckMultiOT.Checked     := SameText(FSIFCfg.MultiOT, 'S');
  CheckMultiplesOT.Checked := SameText(FSIFCfg.MultiplesOT, 'S');

  // 👉 Atajos de teclado
  BtnAceptar.ModalResult   := mrOk;
  BtnCancelar.ModalResult  := mrCancel;

  // 👉 Asignar teclas rápidas
  Self.KeyPreview := True;

  // 🔹 Aquí activamos teclas rápidas estándar de Lazarus
  BtnAceptar.Default  := True;   // Enter
  BtnCancelar.Cancel  := True;   // Esc

  // ===============================
  //   Cargar sección [VeriFactuTLS]
  // ===============================
  //Showmessage('Se está ejecutando FormCreate');
  IniPath := SIF_GetIniPath;
  if FileExists(IniPath) then
  begin
    Ini := TIniFile.Create(IniPath);
    try
      // Campos mínimos
      if Assigned(EditP12File) then
        EditP12File.Text :=
          Ini.ReadString('VeriFactuTLS', 'P12File', '');

      if Assigned(EditP12Password) then
      begin
        {EditP12Password.Text :=
          Ini.ReadString('VeriFactuTLS', 'P12Password', '');}
        EditP12Password.Text :=
          FLX_IniReadPassword(Ini, 'VeriFactuTLS', 'P12Password', '');
      end;

      if Assigned(EditOpenSSLPath) then
        EditOpenSSLPath.Text :=
          Ini.ReadString('VeriFactuTLS', 'OpenSSLPath', 'openssl');

      // Opcionales (solo si los has creado en el form)
      if Assigned(EditCertFile) then
        EditCertFile.Text :=
          Ini.ReadString('VeriFactuTLS', 'CertFile', '');

      if Assigned(EditKeyFile) then
        EditKeyFile.Text :=
          Ini.ReadString('VeriFactuTLS', 'KeyFile', '');

      if Assigned(EditCAFile) then
        EditCAFile.Text :=
          Ini.ReadString('VeriFactuTLS', 'CAFile', '');

    finally
      Ini.Free;
    end;
  end;

  FormResize(Self);
end;

procedure TFSIFConfig.BtnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFSIFConfig.Button1Click(Sender: TObject);
begin
   EditIdSistema.Text := GenerarUUID();
end;

procedure TFSIFConfig.BtnAceptarClick(Sender: TObject);
var
  Ini: TIniFile;
  IniPath: string;
begin
  // Volcar valores de los controles a la estructura
  FSIFCfg.NombreRazon       := Trim(Empresa);
  FSIFCfg.Nif               := Trim(Nif);
  FSIFCfg.NombreSistema     := Trim(EditNombreSistema.Text);
  FSIFCfg.IdSistema         := Trim(EditIdSistema.Text);
  FSIFCfg.Version           := Trim(EditVersion.Text);
  FSIFCfg.NumeroInstalacion := Trim(EditNumeroInst.Text);

  if CheckSoloVF.Checked      then FSIFCfg.SoloVerifactu := 'S' else FSIFCfg.SoloVerifactu := 'N';
  if CheckMultiOT.Checked     then FSIFCfg.MultiOT       := 'S' else FSIFCfg.MultiOT       := 'N';
  if CheckMultiplesOT.Checked then FSIFCfg.MultiplesOT   := 'S' else FSIFCfg.MultiplesOT   := 'N';

  // Guardar en FacturConf.ini Parte SIF
  VF_SIF_Save(FSIFCfg);

  // ===============================
  //   Guardar sección [VeriFactuTLS]
  // ===============================
  IniPath := SIF_GetIniPath;
  Ini := TIniFile.Create(IniPath);
  try
    if Assigned(EditP12File) then
      Ini.WriteString('VeriFactuTLS', 'P12File', Trim(EditP12File.Text));

    if Assigned(EditP12Password) then
    begin
      {Ini.WriteString('VeriFactuTLS', 'P12Password', EditP12Password.Text);}
      if SameText(Trim(EditP12Password.Text), 'P12Password') then
        FLX_IniWritePassword(Ini, 'VeriFactuTLS', 'P12Password', '')
      else
        FLX_IniWritePassword(Ini, 'VeriFactuTLS', 'P12Password', EditP12Password.Text);
    end;

    if Assigned(EditOpenSSLPath) then
      Ini.WriteString('VeriFactuTLS', 'OpenSSLPath', Trim(EditOpenSSLPath.Text));

    // Opcionales: rutas de salida PEM
    if Assigned(EditCertFile) then
      Ini.WriteString('VeriFactuTLS', 'CertFile', Trim(EditCertFile.Text));

    if Assigned(EditKeyFile) then
      Ini.WriteString('VeriFactuTLS', 'KeyFile', Trim(EditKeyFile.Text));

    if Assigned(EditCAFile) then
      Ini.WriteString('VeriFactuTLS', 'CAFile', Trim(EditCAFile.Text));

  finally
    Ini.Free;
  end;

  ModalResult := mrOk;
end;

end.
