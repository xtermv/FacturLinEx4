unit uVFFirmaXML;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Process;

type
  // Devuelve True si la firma se ha generado bien.
  // AInputXML  = XML original (por ejemplo, tu SIF_B_....xml)
  // AOutputXML = XML firmado (se crea/reescribe)
  // AError     = mensaje de error en caso de fallo
  TFirmaResult = record
    Ok    : Boolean;
    Error : string;
  end;

function VF_FirmarXML_Basico(const AInputXML, AOutputXML: string): TFirmaResult;

implementation

// ----------------------------------------------------------------------
// CONFIGURACIÓN BÁSICA (AJÚSTALA A TU ENTORNO)
// ----------------------------------------------------------------------

// Ruta a xmlsec1 (en Debian suele ser /usr/bin/xmlsec1)
const
  XMLSEC_BIN = '/usr/bin/xmlsec1';

// Ruta al certificado PKCS#12 y contraseña
// OJO: AJUSTA ESTAS RUTAS/CLAVE A TU CASO REAL
const
  VF_CERT_PKCS12 = '/home/xterm/certificados/mi_certificado.p12';
  VF_CERT_PASS   = 'PON_AQUI_LA_CLAVE';

// ----------------------------------------------------------------------
// Función auxiliar para ejecutar comandos externos
// ----------------------------------------------------------------------
function RunCommandAndGetOutput(const ACmd: string; out AOutput: string;
  out AExitCode: Integer): Boolean;
var
  P: TProcess;
  SL: TStringList;
begin
  Result   := False;
  AOutput  := '';
  AExitCode := -1;

  P := TProcess.Create(nil);
  SL := TStringList.Create;
  try
    {$IFDEF UNIX}
    P.Options := [poUsePipes, poWaitOnExit];
    P.Executable := '/bin/sh';
    P.Parameters.Add('-c');
    P.Parameters.Add(ACmd);
    {$ELSE}
    P.Options := [poUsePipes, poWaitOnExit];
    P.CommandLine := ACmd;
    {$ENDIF}

    try
      P.Execute;
    except
      on E: Exception do
      begin
        AOutput := 'Error al ejecutar proceso: ' + E.Message;
        Exit(False);
      end;
    end;

    SL.LoadFromStream(P.Output);
    AOutput   := SL.Text;
    AExitCode := P.ExitStatus;

    Result := (AExitCode = 0);
  finally
    SL.Free;
    P.Free;
  end;
end;

// ----------------------------------------------------------------------
// Firma XML básica con xmlsec1 (XMLDSig, NO XAdES todavía)
// ----------------------------------------------------------------------
function VF_FirmarXML_Basico(const AInputXML, AOutputXML: string): TFirmaResult;
var
  Cmd, OutText: string;
  Code: Integer;
begin
  Result.Ok    := False;
  Result.Error := '';

  // Comprobaciones iniciales
  if not FileExists(XMLSEC_BIN) then
  begin
    Result.Error := 'No se encuentra xmlsec1 en ' + XMLSEC_BIN;
    Exit;
  end;

  if not FileExists(AInputXML) then
  begin
    Result.Error := 'No se encuentra el XML de entrada: ' + AInputXML;
    Exit;
  end;

  if not FileExists(VF_CERT_PKCS12) then
  begin
    Result.Error := 'No se encuentra el certificado PKCS#12: ' + VF_CERT_PKCS12;
    Exit;
  end;

  // Comando mínimo de firma:
  //   xmlsec1 --sign --output OUT --pkcs12 cert.p12 --pwd clave IN
  //
  // Esto generará una firma XMLDSig "enveloped" sobre el documento.
  // Más adelante se puede extender a XAdES-EPES siguiendo el PDF de AEAT.
  Cmd :=
    '"' + XMLSEC_BIN + '" ' +
    '--sign ' +
    '--output "' + AOutputXML + '" ' +
    '--pkcs12 "' + VF_CERT_PKCS12 + '" ' +
    '--pwd "' + VF_CERT_PASS + '" ' +
    '"' + AInputXML + '"';

  if not RunCommandAndGetOutput(Cmd, OutText, Code) then
  begin
    Result.Error := Format('Falló xmlsec1 (código %d): %s', [Code, OutText]);
    Exit;
  end;

  if Code <> 0 then
  begin
    Result.Error := Format('xmlsec1 devolvió código %d. Salida:%s', [Code, LineEnding + OutText]);
    Exit;
  end;

  // Si llega aquí, en principio se ha firmado correctamente.
  if not FileExists(AOutputXML) then
  begin
    Result.Error := 'xmlsec1 terminó OK, pero no se encuentra el XML firmado: ' + AOutputXML;
    Exit;
  end;

  Result.Ok := True;
end;

end.
