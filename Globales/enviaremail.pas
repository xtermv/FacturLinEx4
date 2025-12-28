unit enviaremail;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls, lMimeWrapper, lNet, lNetComponents, lSMTP;

type

  { TfEnviarEmail }

  TfEnviarEmail = class(TForm)
    Asunto: TEdit;
    btnEnviar: TBitBtn;
    Contrasenya: TEdit;
    Destinatario: TEdit;
    FAdjunto: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MemoLogs: TMemo;
    Mensaje: TMemo;
    OD: TOpenDialog;
    pc: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    ProgressBar: TProgressBar;
    Puerto: TEdit;
    Remitente: TEdit;
    SB: TStatusBar;
    sbAdjuntar: TSpeedButton;
    Servidor: TEdit;
    SMTP: TLSMTPClientComponent;
    tsMensaje: TTabSheet;
    tsLog: TTabSheet;
    TimerQuit: TTimer;
    Usuario: TEdit;
    procedure btnEnviarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure sbAdjuntarClick(Sender: TObject);
    procedure SMTPConnect(aSocket: TLSocket);
    procedure SMTPDisconnect(aSocket: TLSocket);
    procedure SMTPError(const msg: string; aSocket: TLSocket);
    procedure SMTPFailure(aSocket: TLSocket; const aStatus: TLSMTPStatus);
    procedure SMTPReceive(aSocket: TLSocket);
    procedure SMTPSent(aSocket: TLSocket; const Bytes: Integer);
    procedure SMTPSuccess(aSocket: TLSocket; const aStatus: TLSMTPStatus);
    procedure TimerQuitTimer(Sender: TObject);
  private
    { private declarations }
    FDataSent: Int64;
    FDataSize: Int64;
    FMimeStream: TMimeStream;
    FQuit: Boolean;
  public
    { public declarations }
  end; 

  procedure ShowFormEnviarEmail;

var
  fEnviarEmail: TfEnviarEmail;

implementation

uses
  Global;

//=============== Crea el formulario ================
procedure ShowFormEnviarEmail;
begin
  with TFEnviarEmail.Create(Application) do
    begin
       ShowModal;
    end;
end;


{ TfEnviarEmail }

procedure TfEnviarEmail.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  CloseAction:=CaFree;

  if not FQuit and SMTP.Connected then begin
    CloseAction := caNone;
    SMTP.Quit;
    TimerQuit.Enabled := True;
  end else
    FMimeStream.Free;
end;

//=============== Proceso de Envio del mensaje =============
procedure TfEnviarEmail.btnEnviarClick(Sender: TObject);
begin
  // Conexión con el servidor
  if not SMTP.Connected then begin
     SMTP.Connect(Servidor.Text,Word(StrToInt(Puerto.Text)));
     SB.SimpleText:='Conectando con el servidor';
     MemoLogs.Append(SB.SimpleText);
  end else
    SMTP.Quit; // server will respond and we'll make a clean disconnect (see SMTP rfc)

  // Validando datos de usuario en el servidor
  if SMTP.HasFeature('AUTH LOGIN') then
        SMTP.AuthLogin(Usuario.Text,Contrasenya.Text)
  else if SMTP.HasFeature('AUTH PLAIN') then
     SMTP.AuthPlain(Usuario.Text,Contrasenya.Text);

  // Preparando el mensaje
  FMimeStream.Reset;
  TMimeTextSection(FMimeStream[0]).Text := Mensaje.Text;
  ProgressBar.Position := 0;
  FDataSent := 0;
  FDataSize := FMimeStream.Size;

  // Enviando el mensaje
  SMTP.SendMail(Remitente.Text, Destinatario.Text, Asunto.Text, FMimeStream);

  // Desconexion del servidor
  SMTP.Quit;
end;

//=============== Carga de datos iniciales del mensaje ========
procedure TfEnviarEmail.FormCreate(Sender: TObject);
begin
  pc.ActivePage:=tsMensaje;
  Servidor.Text:='';
  Puerto.Text:='';
  Usuario.Text:='';
  Contrasenya.Text:='';
  Remitente.Text:=Global.Empresa;
  Destinatario.Text:='';
  Asunto.Text:='Mensaje de '+Global.Empresa;
  FAdjunto.Text:='';
  Mensaje.Lines.Add('Estimados señores:');
  Mensaje.Lines.Add('');
  Mensaje.Lines.Add('Adjunto la información que nos han solicitado.');
  Mensaje.Lines.Add('');
  Mensaje.Lines.Add('Un saludo,');
  Mensaje.Lines.Add(Global.Empresa);

  SMTP.OnError:=@SMTPError;
  FMimeStream := TMimeStream.Create;
  FMimeStream.AddTextSection('');
end;

procedure TfEnviarEmail.sbAdjuntarClick(Sender: TObject);
begin
  if OD.Execute then
     if FileExists(OD.FileName) then begin
        FAdjunto.Text:=OD.FileName;
     end;
end;

procedure TfEnviarEmail.SMTPConnect(aSocket: TLSocket);
begin
  SB.SimpleText:='Conectado al servidor';
  MemoLogs.Append(SB.SimpleText);
end;

procedure TfEnviarEmail.SMTPDisconnect(aSocket: TLSocket);
begin
  SB.SimpleText:='Desconectado del servidor';
  MemoLogs.Append(SB.SimpleText);
end;

procedure TfEnviarEmail.SMTPError(const msg: string; aSocket: TLSocket);
begin
  smtp.Disconnect(True);
  SB.SimpleText:=msg;
  MemoLogs.Append(msg);
end;

procedure TfEnviarEmail.SMTPFailure(aSocket: TLSocket;
  const aStatus: TLSMTPStatus);
begin
  case aStatus of
     ssCon,
     ssData: begin
              MessageDlg('Error enviando mensaje', mtError, [mbOK], 0);
              SMTP.Rset;
            end;
     ssQuit: begin
               SMTP.Disconnect;
               Close;
             end;
  end;
end;

procedure TfEnviarEmail.SMTPReceive(aSocket: TLSocket);
var
  s, st: string;
begin
  if SMTP.GetMessage(s) > 0 then begin
     st := StringReplace(s, #13, '', [rfReplaceAll]);
     st := StringReplace(st, #10, '', [rfReplaceAll]);
     SB.SimpleText := st;
     MemoLogs.Append(s);
  end;
end;

procedure TfEnviarEmail.SMTPSent(aSocket: TLSocket; const Bytes: Integer);
begin
  FDataSent:=FDataSent + Bytes;
  ProgressBar.Position:=Round((FDataSent/FDataSize)*100);
end;

procedure TfEnviarEmail.SMTPSuccess(aSocket: TLSocket;
  const aStatus: TLSMTPStatus);
begin
  case aStatus of
    ssCon: begin
             if SMTP.HasFeature('EHLO') then
                SMTP.Ehlo(Servidor.Text)
             else
                SMTP.Helo(Servidor.Text);
           end;
    ssData: MessageDlg('Mensaje enviado satistactoriamente', mtInformation, [mbOK], 0);
    ssQuit: begin
              SMTP.Disconnect;
              if TimerQuit.Enabled then
                 Close;
            end;
  end;
end;

procedure TfEnviarEmail.TimerQuitTimer(Sender: TObject);
begin
  FQuit := True;
  Close;
end;

initialization
  {$I enviaremail.lrs}

end.

