unit uFLX_EmailPDF;

{
  Envío de emails con PDF adjunto para FacturLinEx2
  -------------------------------------------------

  - Lazarus + FPC
  - Synapse (smtpsend, synautil, ssl_openssl)
  - Usa las variables globales de correo definidas en Global:
      CorreoEmisor, CorreoHost, CorreoPuerto,
      CorreoUsuario, CorreoClave,
      CorreoTLS, CorreoSSL, etc.

  Función principal:
    FLX_SendFacturaPDFMail(
      Destinatario, DestinatarioCC, Asunto, Cuerpo, PDFFileName, ErrorText
    ): Boolean;

  Ejemplo de uso (desde tu formulario de impresión):

    var
      PDFFile, Err: string;
      Ok: Boolean;
    begin
      // Suponiendo que ya has generado el PDF con uFLX_FacturaPDF:
      Ok := FLX_GenerateInvoicePDF_FromDB(ATienda, ASerie, ANum,
                                          AFecha, ACodCliente,
                                          AQRImageFile, ABarCodeFile,
                                          PDFFile);
      if Ok then
      begin
        if dbClientes.FieldByName('C55').AsBoolean then
        begin
          Ok := FLX_SendFacturaPDFMail(
                  edDestinatario.Text,
                  edDestinatarioCopia.Text,
                  edAsunto.Text,
                  mmTexto.Lines.Text,
                  PDFFile,
                  Err
                );
          if not Ok then
            ShowMessage('Error al enviar correo: ' + Err);
        end;
      end;
    end;

}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  smtpsend, synautil, blcksock, ssl_openssl,
  synacode, synachar, base64, // unidades para control de la codificacion
  Global;  // aquí tienes CorreoHost, CorreoPuerto, CorreoUsuario, etc.

/// Envía un email con un PDF adjunto.
///   Destinatario      -> dirección principal (To)
///   DestinatarioCC    -> lista de CC separada por comas o punto y coma
///   Asunto            -> Subject
///   Cuerpo            -> texto plano del mensaje (UTF-8)
///   PDFFileName       -> ruta completa al PDF generado
///   ErrorText         -> descripción del error si FALLA
///
/// Devuelve True si se ha enviado correctamente.
function FLX_SendFacturaPDFMail(
  const Destinatario, DestinatarioCC, Asunto, Cuerpo, PDFFileName: string;
  out ErrorText: string
): Boolean;

implementation

// Devuelve una boundary "única" para el MIME
function FLX_MakeBoundary: string;
begin
  Result := '----=_FLX_' + IntToHex(Random(MaxInt), 8);
end;

// Normaliza lista de direcciones separadas por coma o punto y coma
procedure FLX_SplitAddressList(const AList: string; AOut: TStrings);
var
  Tmp: string;
  i: Integer;
begin
  AOut.Clear;
  Tmp := AList;
  // Unificamos separadores: ; -> ,
  Tmp := StringReplace(Tmp, ';', ',', [rfReplaceAll]);
  // Usamos CommaText de TStringList
  AOut.CommaText := Tmp;

  // Quitamos espacios sobrantes
  for i := AOut.Count - 1 downto 0 do
  begin
    AOut[i] := Trim(AOut[i]);
    if AOut[i] = '' then
      AOut.Delete(i);
  end;
end;

// Construye el mensaje completo (cabeceras + cuerpo MIME con PDF adjunto)
function FLX_BuildMailText(
  const FromAddr, ToAddr, CcAddrs, Subject, BodyText, PDFFileName: string
): TStringList;
var
  Boundary: string;
  Archivo: TFileStream;
  MemStream: TMemoryStream;
  InputStr: AnsiString;
  Base64Str: AnsiString;
  FileNameOnly: string;
  i, ChunkSize: Integer;
  Linea: string;
begin
  Result := TStringList.Create;

  Boundary    := FLX_MakeBoundary;
  FileNameOnly := ExtractFileName(PDFFileName);

  // ==== CABECERAS ====
  Result.Add('From: ' + FromAddr);
  Result.Add('To: ' + ToAddr);

  if Trim(CcAddrs) <> '' then
    Result.Add('Cc: ' + CcAddrs);

  Result.Add('Subject: ' + Subject);

  // Deja que el servidor ponga la Date si quieres, pero si prefieres:
  Result.Add('Date: ' + FormatDateTime('ddd, dd mmm yyyy hh:nn:ss " +0100"', Now));
  Result.Add('MIME-Version: 1.0');
  Result.Add('Content-Type: multipart/mixed; boundary="' + Boundary + '"');

  // Línea EN BLANCO obligatoria entre cabeceras y cuerpo
  Result.Add('');

  // ==== CUERPO TEXTO ====
  Result.Add('--' + Boundary);
  Result.Add('Content-Type: text/plain; charset="UTF-8"');
  Result.Add('Content-Transfer-Encoding: 8bit');
  Result.Add('');
  Result.Add(BodyText);
  Result.Add('');  // pequeña separación antes del adjunto

  // ==== ADJUNTO PDF (si existe) ====
  if FileExists(PDFFileName) then
  begin
    Archivo := TFileStream.Create(PDFFileName, fmOpenRead or fmShareDenyWrite);
    try
      MemStream := TMemoryStream.Create;
      try
        MemStream.CopyFrom(Archivo, Archivo.Size);
        MemStream.Position := 0;

        SetLength(InputStr, MemStream.Size);
        if MemStream.Size > 0 then
          MemStream.ReadBuffer(InputStr[1], MemStream.Size);

        // Codificamos el binario a Base64 (una cadena larga)
        Base64Str := EncodeBase64(InputStr);
      finally
        MemStream.Free;
      end;
    finally
      Archivo.Free;
    end;

    // Parte del adjunto
    Result.Add('--' + Boundary);
    Result.Add('Content-Type: application/pdf; name="' + FileNameOnly + '"');
    Result.Add('Content-Disposition: attachment; filename="' + FileNameOnly + '"');
    Result.Add('Content-Transfer-Encoding: base64');
    Result.Add('');

    // Partimos el Base64 en líneas de máx. 76 caracteres
    i := 1;
    ChunkSize := 76;
    while i <= Length(Base64Str) do
    begin
      Linea := Copy(Base64Str, i, ChunkSize);
      Result.Add(Linea);
      Inc(i, ChunkSize);
    end;

    Result.Add(''); // por limpieza
  end;

  // ==== FIN DEL MENSAJE MIME ====
  Result.Add('--' + Boundary + '--');
  Result.Add('');
end;

// Función principal de envío
function FLX_SendFacturaPDFMail(
  const Destinatario, DestinatarioCC, Asunto, Cuerpo, PDFFileName: string;
  out ErrorText: string
): Boolean;
var
  SMTP: TSMTPSend;
  Mensaje: TStringList;
  CCList: TStringList;
  i: Integer;
begin
  Result := False;
  ErrorText := '';

  // --- Validaciones básicas ---
  if Trim(CorreoEmisor) = '' then
  begin
    ErrorText := 'Falta correo electrónico del EMISOR (CorreoEmisor).';
    Exit;
  end;

  if Trim(Destinatario) = '' then
  begin
    ErrorText := 'Falta correo electrónico del DESTINATARIO.';
    Exit;
  end;

  if Trim(CorreoHost) = '' then
  begin
    ErrorText := 'Falta servidor SMTP (CorreoHost).';
    Exit;
  end;

  if Trim(CorreoUsuario) = '' then
  begin
    ErrorText := 'Falta usuario SMTP (CorreoUsuario).';
    Exit;
  end;

  if Trim(CorreoClave) = '' then
  begin
    ErrorText := 'Falta contraseña SMTP (CorreoClave).';
    Exit;
  end;

  // --- Construimos el mensaje completo (cabeceras + cuerpo + adjunto) ---
  Mensaje := FLX_BuildMailText(
               CorreoEmisor,
               Destinatario,
               DestinatarioCC,
               Asunto,
               Cuerpo,
               PDFFileName
             );

  CCList := TStringList.Create;
  try
    // Preparamos lista de CC bien troceada
    FLX_SplitAddressList(DestinatarioCC, CCList);

    // --- Configuración SMTP ---
    SMTP := TSMTPSend.Create;
    try
      SMTP.TargetHost := CorreoHost;
      SMTP.TargetPort := CorreoPuerto;   // en Global la tienes como string
      SMTP.Username   := CorreoUsuario;
      SMTP.Password   := CorreoClave;
      SMTP.AutoTLS    := CorreoTLS;      // Boolean global tuyo
      SMTP.FullSSL    := CorreoSSL;      // Boolean global tuyo

      // Conectamos y autenticamos
      if not SMTP.Login then
      begin
        ErrorText := 'Error al conectar o autenticar con el servidor SMTP.';
        Exit;
      end;

      // From
      if not SMTP.MailFrom(CorreoEmisor, Length(Mensaje.Text)) then
      begin
        ErrorText := 'Error al especificar el remitente (MAIL FROM).';
        Exit;
      end;

      // To principal
      if not SMTP.MailTo(Destinatario) then
      begin
        ErrorText := 'Error al especificar el destinatario (RCPT TO).';
        Exit;
      end;

      // CC (si los hay)
      for i := 0 to CCList.Count - 1 do
      begin
        if not SMTP.MailTo(CCList[i]) then
        begin
          ErrorText := 'Error al especificar destinatario en CC: ' + CCList[i];
          Exit;
        end;
      end;

      // Datos del mensaje
      if not SMTP.MailData(Mensaje) then
      begin
        ErrorText := 'Error al enviar datos del mensaje (MAIL DATA).';
        Exit;
      end;

      // Cierre limpio
      SMTP.Logout;
      Result := True;
    finally
      SMTP.Free;
    end;
  finally
    Mensaje.Free;
    CCList.Free;
  end;
end;

initialization
  Randomize;

end.
