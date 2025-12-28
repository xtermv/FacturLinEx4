unit uFacturaE_Signer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Process, Dialogs;

function SignFacturaEXAdES(const InputXML, OutputXML: String): Boolean;

implementation

uses
  Global,
  DOM, XMLRead, XMLWrite, DateUtils, IniFiles;

function RunCommandAndCapture(const AExecutable: String; const AParams: array of String;
  out AOutput: String): Integer;
var
  P: TProcess;
  S: TStringStream;
  i: Integer;
begin
  Result := -1;
  AOutput := '';
  P := TProcess.Create(nil);
  S := TStringStream.Create('');
  try
    P.Executable := AExecutable;
    for i := Low(AParams) to High(AParams) do
      P.Parameters.Add(AParams[i]);

    P.Options := [poUsePipes, poWaitOnExit, poStderrToOutPut];
    P.Execute;

    S.CopyFrom(P.Output, 0);
    AOutput := S.DataString;

    Result := P.ExitStatus;
  finally
    S.Free;
    P.Free;
  end;
end;

function TrimOneLine(const S: string): string;
begin
  Result := Trim(StringReplace(StringReplace(S, #13, '', [rfReplaceAll]), #10, '', [rfReplaceAll]));
end;

function ExtractAfter(const S, Prefix: string): string;
var
  p: SizeInt;
begin
  Result := '';
  p := Pos(Prefix, S);
  if p <= 0 then Exit;
  Result := Trim(Copy(S, p + Length(Prefix), MaxInt));
end;

// Convierte un HEX grande (sin 0x, puede tener letras) a decimal en string (sin límites de Int64)
function HexToDecStr(const HexIn: string): string;
var
  Hex: string;

  function MulDecBy16(const Dec: string): string;
  var
    i, carry, d, v: Integer;
    R: string;
  begin
    R := '';
    carry := 0;
    for i := Length(Dec) downto 1 do
    begin
      d := Ord(Dec[i]) - Ord('0');
      v := d * 16 + carry;
      R := Chr(Ord('0') + (v mod 10)) + R;
      carry := v div 10;
    end;
    while carry > 0 do
    begin
      R := Chr(Ord('0') + (carry mod 10)) + R;
      carry := carry div 10;
    end;
    while (Length(R) > 1) and (R[1] = '0') do Delete(R, 1, 1);
    Result := R;
  end;

  function AddHexNibble(const Dec: string; N: Integer): string;
  var
    i, carry, d, v: Integer;
    R: string;
  begin
    R := Dec;
    i := Length(R);
    carry := N;
    while (i >= 1) and (carry > 0) do
    begin
      d := Ord(R[i]) - Ord('0');
      v := d + carry;
      R[i] := Chr(Ord('0') + (v mod 10));
      carry := v div 10;
      // FPC: evitamos Dec(i) por conflicto/parseo en algunos entornos
      i := i - 1;
    end;
    while carry > 0 do
    begin
      R := Chr(Ord('0') + (carry mod 10)) + R;
      carry := carry div 10;
    end;
    while (Length(R) > 1) and (R[1] = '0') do Delete(R, 1, 1);
    Result := R;
  end;

  function HexVal(c: Char): Integer;
  begin
    if (c >= '0') and (c <= '9') then Exit(Ord(c) - Ord('0'));
    if (c >= 'a') and (c <= 'f') then Exit(10 + Ord(c) - Ord('a'));
    if (c >= 'A') and (c <= 'F') then Exit(10 + Ord(c) - Ord('A'));
    Result := 0;
  end;

var
  i, n: Integer;
  DecStr: string;
begin
  Hex := Trim(HexIn);
  while (Length(Hex) > 0) and (Hex[1] = '0') do Delete(Hex, 1, 1);
  if Hex = '' then Exit('0');

  DecStr := '0';
  for i := 1 to Length(Hex) do
  begin
    n := HexVal(Hex[i]);
    DecStr := MulDecBy16(DecStr);
    DecStr := AddHexNibble(DecStr, n);
  end;

  Result := DecStr;
end;

{
function GetUTC_Z_Now: string;
var
  OffMin: LongInt;
  U: TDateTime;
begin
  OffMin := GetLocalTimeOffset;
  U := Now - (OffMin / (24 * 60));
  Result := FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss"Z"', U);
end;
}
function GetUTC_Z_Now: string;
var
  U: TDateTime;
begin
  // Convierte la hora local del sistema a UTC REAL
  U := LocalTimeToUniversal(Now);

  // Formato XAdES: UTC con sufijo Z
  Result := FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss"Z"', U);
end;

function FindFirstByLocalNameNS(const Doc: TXMLDocument; const LocalName, NS: string): TDOMNode;
var
  N: TDOMNode;
begin
  Result := nil;
  if Doc = nil then Exit;
  N := Doc.DocumentElement;
  while Assigned(N) do
  begin
    if (N.NodeType = ELEMENT_NODE) then
    begin
      if (TDOMElement(N).LocalName = LocalName) and (TDOMElement(N).NamespaceURI = NS) then
        Exit(N);
    end;

    if Assigned(N.FirstChild) then
      N := N.FirstChild
    else
    begin
      while Assigned(N) and (not Assigned(N.NextSibling)) do
        N := N.ParentNode;
      if Assigned(N) then
        N := N.NextSibling;
    end;
  end;
end;

procedure SetNodeText(const Node: TDOMNode; const Value: string);
begin
  if Node = nil then Exit;
  if Assigned(Node.FirstChild) then
    Node.FirstChild.NodeValue := Value
  else
    Node.AppendChild(Node.OwnerDocument.CreateTextNode(Value));
end;

function FindFirstByNodeName(const Doc: TXMLDocument; const NodeName: string): TDOMNode;
var
  N: TDOMNode;
begin
  Result := nil;
  if Doc = nil then Exit;
  N := Doc.DocumentElement;
  while Assigned(N) do
  begin
    if (N.NodeType = ELEMENT_NODE) and (N.NodeName = NodeName) then
      Exit(N);

    if Assigned(N.FirstChild) then
      N := N.FirstChild
    else
    begin
      while Assigned(N) and (not Assigned(N.NextSibling)) do
        N := N.ParentNode;
      if Assigned(N) then
        N := N.NextSibling;
    end;
  end;
end;

function FindFirstChildByNodeName(const Parent: TDOMNode; const NodeName: string): TDOMNode;
var
  C: TDOMNode;
begin
  Result := nil;
  if Parent = nil then Exit;
  C := Parent.FirstChild;
  while Assigned(C) do
  begin
    if (C.NodeType = ELEMENT_NODE) and (C.NodeName = NodeName) then
      Exit(C);
    C := C.NextSibling;
  end;
end;

// Prepara XAdES antes de firmar: SigningTime UTC + CertDigest + Issuer + Serial
function PrepareXAdESFields(const InputXML, OutputPreparedXML, CertFile: string): Boolean;
var
  Doc: TXMLDocument;
  CmdOut, IssuerLine, SerialLine, SerialHex, SerialDec, DigestB64: string;
  ExitCode: Integer;

  SigningTimeNode: TDOMNode;
  CertDigestNode, DigestValueNode: TDOMNode;
  IssuerSerialNode, IssuerNameNode, SerialNumNode: TDOMNode;
begin
  Result := False;
  ReadXMLFile(Doc, InputXML);
  try
    // 1) SigningTime (xades:SigningTime) -> UTC real
    SigningTimeNode := FindFirstByNodeName(Doc, 'xades:SigningTime');
    if Assigned(SigningTimeNode) then
      SetNodeText(SigningTimeNode, GetUTC_Z_Now);

    // 2) CertDigest SHA256 base64 (DER)
    // openssl x509 -in cert.pem -outform der | openssl dgst -sha256 -binary | openssl base64 -A
    ExitCode := RunCommandAndCapture('bash', [
      '-lc',
      'openssl x509 -in ' + QuotedStr(CertFile) + ' -outform der | ' +
      'openssl dgst -sha256 -binary | openssl base64 -A'
    ], CmdOut);
    if ExitCode <> 0 then
      raise Exception.Create('Error calculando CertDigest con openssl: ' + CmdOut);

    DigestB64 := TrimOneLine(CmdOut);

    CertDigestNode := FindFirstByNodeName(Doc, 'xades:CertDigest');
    if Assigned(CertDigestNode) then
    begin
      DigestValueNode := FindFirstChildByNodeName(CertDigestNode, 'ds:DigestValue');
      if Assigned(DigestValueNode) then
        SetNodeText(DigestValueNode, DigestB64);
    end;

    // 3) Issuer (RFC2253)
    ExitCode := RunCommandAndCapture('openssl', [
      'x509', '-in', CertFile, '-noout', '-issuer', '-nameopt', 'RFC2253,utf8'
    ], CmdOut);
    if ExitCode <> 0 then
      raise Exception.Create('Error leyendo issuer con openssl: ' + CmdOut);

    IssuerLine := ExtractAfter(Trim(CmdOut), 'issuer=');

    // 4) Serial (hex -> decimal string)
    ExitCode := RunCommandAndCapture('openssl', [
      'x509', '-in', CertFile, '-noout', '-serial'
    ], CmdOut);
    if ExitCode <> 0 then
      raise Exception.Create('Error leyendo serial con openssl: ' + CmdOut);

    SerialLine := ExtractAfter(Trim(CmdOut), 'serial=');
    SerialHex := StringReplace(SerialLine, ':', '', [rfReplaceAll]);
    SerialDec := HexToDecStr(SerialHex);

    IssuerSerialNode := FindFirstByNodeName(Doc, 'xades:IssuerSerial');
    if Assigned(IssuerSerialNode) then
    begin
      IssuerNameNode := FindFirstChildByNodeName(IssuerSerialNode, 'ds:X509IssuerName');
      SerialNumNode  := FindFirstChildByNodeName(IssuerSerialNode, 'ds:X509SerialNumber');

      if Assigned(IssuerNameNode) then SetNodeText(IssuerNameNode, IssuerLine);
      if Assigned(SerialNumNode)  then SetNodeText(SerialNumNode, SerialDec);
    end;

    WriteXMLFile(Doc, OutputPreparedXML);
    Result := True;
  finally
    Doc.Free;
  end;
end;

function SignFacturaEXAdES(const InputXML, OutputXML: String): Boolean;
var
  CmdOut: String;
  ExitCode: Integer;
  Ini: TIniFile;
  CertFile, KeyFile: String;
  PreparedXML: String;
begin
  Result := False;

  //===== Lectura de la configuración para coger los certificados generados para verifactu
  Ini := TIniFile.Create(RutaIni + 'FacturConf.ini');
  try
    CertFile    := Ini.ReadString('VeriFactuTLS', 'CertFile', '');
    KeyFile     := Ini.ReadString('VeriFactuTLS', 'KeyFile', '');
  finally
    Ini.Free;
  end;
  if CertFile = '' then
    raise Exception.Create('CertFile no definido en [VeriFactuTLS]');
  if KeyFile = '' then
    raise Exception.Create('KeyFile no definido en [VeriFactuTLS]');
  //CertFile := IncludeTrailingPathDelimiter(RutaIni) + 'C2025.pem';
  //KeyFile  := IncludeTrailingPathDelimiter(RutaIni) + 'K2025.pem';

  if not FileExists(InputXML) then
    raise Exception.Create('No se encontró el XML de entrada: ' + InputXML);

  if not FileExists(CertFile) then
    raise Exception.Create('No se encontró el certificado: ' + CertFile);

  if not FileExists(KeyFile) then
    raise Exception.Create('No se encontró la clave privada: ' + KeyFile);

  PreparedXML := ChangeFileExt(OutputXML, '.prepared.xml');

  if not PrepareXAdESFields(InputXML, PreparedXML, CertFile) then
    raise Exception.Create('No se pudo preparar XAdES antes de firmar.');

  ExitCode := RunCommandAndCapture(
    'xmlsec1',
    [
      '--sign',
      '--privkey-pem', KeyFile + ',' + CertFile,

      // Mapeo de IDs (corregido)
      '--id-attr:Id', 'ds:Signature',
      '--id-attr:Id', 'xades:SignedProperties',

      // Tus pruebas anteriores (NO las elimino):
      // '--id-attr:Id', 'http://www.facturae.gob.es/formato/Versiones/Facturaev3_2_2.xml:Facturae',
      // '--id-attr:Id', 'http://uri.etsi.org/01903/v1.3.2#:SignedProperties',
      // '--id-attr:Id', 'Facturae',
      // '--id-attr:Id', 'SignedProperties',

      '--node-xpath', '//*[local-name()="Signature" and namespace-uri()="http://www.w3.org/2000/09/xmldsig#"]',

      // '--node-id', 'SIG-' + SerieNumero,

      '--output', OutputXML,
      PreparedXML
    ],
    CmdOut
  );
  
  // --- COMPROBACIÓN (opcional) ---
  // Si quieres verificar la firma en el mismo equipo:
  // RunCommandAndCapture('xmlsec1', ['--verify', OutputXML], CmdOut);
  // ShowMessage(CmdOut);

  if ExitCode <> 0 then
    raise Exception.Create('Error xmlsec1: ' + CmdOut);
    
  // --- COMPROBACIÓN LOCAL (opcional) ---
  // Verificar firma:
  // ExitCode := RunCommandAndCapture('xmlsec1', ['--verify', OutputXML], CmdOut);
  // if ExitCode <> 0 then
  //   raise Exception.Create('Firma NO válida según xmlsec1: ' + CmdOut);
  //
  // Ver detalles:
  // RunCommandAndCapture('xmlsec1', ['--verify', '--verbose', OutputXML], CmdOut);
  // ShowMessage(CmdOut);

  // --- DEBUG (opcional) ---
  // Si quieres revisar el intermedio:
  // ShowMessage('Prepared generado: ' + PreparedXML);

  Result := FileExists(OutputXML);
end;

end.
