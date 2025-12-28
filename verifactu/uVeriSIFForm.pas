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
    procedure BtnCancelarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnAceptarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnProbarCertClick(Sender: TObject);
  private
    FSIFCfg: TVeriSIFConfig;
  public
    // Puedes exponer algo si lo necesitas más adelante
  end;

var
  FSIFConfig: TFSIFConfig;

implementation

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
        EditP12Password.Text :=
          Ini.ReadString('VeriFactuTLS', 'P12Password', '');

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
      Ini.WriteString('VeriFactuTLS', 'P12Password', EditP12Password.Text);

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
