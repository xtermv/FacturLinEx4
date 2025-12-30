unit uFacturaE_Generator;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DOM, XMLWrite, DateUtils, DB;

type
  TFacturaEGenerator = class
  private
    FDoc: TXMLDocument;

    function AddNode(Parent: TDOMNode; const Name: String): TDOMElement;
    procedure AddTextNode(Parent: TDOMNode; const Name, Value: String);
    function FormatDateISO(ADate: TDateTime): String;
    function SafeFieldAsString(DS: TDataSet; const FieldName: String): String;
    function SafeFieldAsFloat(DS: TDataSet; const FieldName: String): Double;

    function CleanPostCode(const S: String): String;

    // -- NUEVO: tiempo UTC real para XAdES (evita Now local + 'Z')
    function FormatDateTimeUTC_Z(const ALocalDT: TDateTime): string;

    procedure AddXAdESBES_Template(const ParentNode: TDOMElement;
      const TargetNodeId, SignatureId, SignedPropsId, ObjectId: string);

    procedure ParseAdministrativeCentres(
      const Obs: String;
      out OrganoGestor, OficinaContable, UnidadTramitadora, CCF: String
    );

  public
    constructor Create;
    destructor Destroy; override;

    procedure BuildFacturaE(
      dbCabecera, dbDetalles, dbCliente: TDataSet;
      const OutputFile: String
    );
  end;

implementation

uses
  Global,uFLX_Log;

{ TFacturaEGenerator }

constructor TFacturaEGenerator.Create;
begin
  inherited Create;
  FDoc := TXMLDocument.Create;
end;

destructor TFacturaEGenerator.Destroy;
begin
  FreeAndNil(FDoc);
  inherited Destroy;
end;

function TFacturaEGenerator.AddNode(Parent: TDOMNode; const Name: String): TDOMElement;
begin
  Result := FDoc.CreateElement(Name);
  if Assigned(Parent) then
    Parent.AppendChild(Result)
  else
    FDoc.AppendChild(Result);
end;

procedure TFacturaEGenerator.AddTextNode(Parent: TDOMNode; const Name, Value: String);
var
  N: TDOMElement;
begin
  N := AddNode(Parent, Name);
  N.AppendChild(FDoc.CreateTextNode(Value));
end;

function TFacturaEGenerator.FormatDateISO(ADate: TDateTime): String;
begin
  Result := FormatDateTime('yyyy"-"mm"-"dd', ADate);
end;

function TFacturaEGenerator.CleanPostCode(const S: String): String;
var
  Tmp: String;
begin
  Tmp := Trim(S);
  if Tmp = '' then Exit('00000');
  while Length(Tmp) < 5 do Tmp := '0' + Tmp;
  Result := Copy(Tmp, 1, 5);
end;

function TFacturaEGenerator.SafeFieldAsString(DS: TDataSet; const FieldName: String): String;
begin
  try
    if (DS = nil) or (not DS.Active) then Exit('');
    Result := Trim(DS.FieldByName(FieldName).AsString);
  except
    Result := '';
  end;
end;

function TFacturaEGenerator.SafeFieldAsFloat(DS: TDataSet; const FieldName: String): Double;
begin
  try
    if (DS = nil) or (not DS.Active) then Exit(0.0);
    Result := DS.FieldByName(FieldName).AsFloat;
  except
    Result := 0.0;
  end;
end;

// -- NUEVO: formatea en UTC real con sufijo Z (XAdES)
function TFacturaEGenerator.FormatDateTimeUTC_Z(const ALocalDT: TDateTime): string;
var
  U: TDateTime;
begin
  // DateUtils: LocalTimeToUniversal convierte de local -> UTC
  U := LocalTimeToUniversal(ALocalDT);
  Result := FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss"Z"', U);
end;

// Recuperamos el parámetro CCF
procedure TFacturaEGenerator.ParseAdministrativeCentres(
  const Obs: String;
  out OrganoGestor, OficinaContable, UnidadTramitadora, CCF: String);

  function Normalize(const S: String): String;
  const
    FromChars = 'ÁÉÍÓÚÜÑáéíóúüñ';
    ToChars   = 'AEIOUUNaeiouun';
  var
    i, p: Integer;
    R: String;
  begin
    R := LowerCase(S);
    for i := 1 to Length(R) do
    begin
      p := Pos(R[i], FromChars);
      if p > 0 then R[i] := ToChars[p];
    end;
    Result := R;
  end;

  function Extract(const Text: String; const Key: String): String;
  var
    NText, NKey: String;
    p, i: Integer;
  begin
    Result := '';
    NText := Normalize(Text);
    NKey  := Normalize(Key);
    p := Pos(NKey, NText);
    if p = 0 then Exit;
    i := p + Length(NKey);
    while (i <= Length(Text)) and (Text[i] in [' ', ':']) do Inc(i);
    while (i <= Length(Text)) and not (Text[i] in [#10, #13, ',']) do
    begin
      Result := Result + Text[i];
      Inc(i);
    end;
    Result := Trim(Result);
  end;

begin
  OrganoGestor      := Extract(Obs, 'og');
  OficinaContable   := Extract(Obs, 'oc');
  UnidadTramitadora := Extract(Obs, 'ut');
  CCF               := Extract(Obs, 'ccf'); // Ahora sí lo leemos
end;

procedure TFacturaEGenerator.AddXAdESBES_Template(const ParentNode: TDOMElement;
  const TargetNodeId, SignatureId, SignedPropsId, ObjectId: string);
var
  Sig, SignedInfo, Ref, Transforms, Trans, DM, SM, CM: TDOMElement;
  KeyInfo, X509Data: TDOMElement;

  ObjNode, QP, SP, SSP, SDOP: TDOMElement;
  SigningCert, CertNode, CertDigest, IssuerSerial: TDOMElement;
  Policy, PolicyId, SigPolicyId, PolicyHash, HashMethod, PolicyQuals, PolicyQual, SPURI: TDOMElement;
  DOF: TDOMElement;

  // Ids internos para referenciar correctamente SignedDataObjectProperties
  RefDocId: string;
begin
  // --- Id de la referencia al documento (para DataObjectFormat) ---
  RefDocId := SignatureId + '-RefDoc';

  Sig := AddNode(ParentNode, 'ds:Signature');
  Sig.SetAttribute('Id', SignatureId);

  // -------- SignedInfo --------
  SignedInfo := AddNode(Sig, 'ds:SignedInfo');

  CM := AddNode(SignedInfo, 'ds:CanonicalizationMethod');
  CM.SetAttribute('Algorithm', 'http://www.w3.org/2001/10/xml-exc-c14n#');

  SM := AddNode(SignedInfo, 'ds:SignatureMethod');
  // RSA-SHA256 (lo normal hoy en Facturae)
  SM.SetAttribute('Algorithm', 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256');

  // -------- Reference #1 : Documento (enveloped) --------
  Ref := AddNode(SignedInfo, 'ds:Reference');
  Ref.SetAttribute('Id', RefDocId);
  Ref.SetAttribute('URI', ''); // firma enveloped sobre el documento completo
  Transforms := AddNode(Ref, 'ds:Transforms');

  // Transform 1: enveloped-signature (quita ds:Signature del cálculo)
  Trans := AddNode(Transforms, 'ds:Transform');
  Trans.SetAttribute('Algorithm', 'http://www.w3.org/2000/09/xmldsig#enveloped-signature');

  // Transform 2: canonicalización exclusiva (muy habitual y estable)
  Trans := AddNode(Transforms, 'ds:Transform');
  Trans.SetAttribute('Algorithm', 'http://www.w3.org/2001/10/xml-exc-c14n#');

  DM := AddNode(Ref, 'ds:DigestMethod');
  DM.SetAttribute('Algorithm', 'http://www.w3.org/2001/04/xmlenc#sha256');
  AddTextNode(Ref, 'ds:DigestValue', '');

  // -------- Reference #2 : SignedProperties (obligatoria en XAdES) --------
  Ref := AddNode(SignedInfo, 'ds:Reference');
  Ref.SetAttribute('Type', 'http://uri.etsi.org/01903#SignedProperties');
  Ref.SetAttribute('URI', '#' + SignedPropsId);

  DM := AddNode(Ref, 'ds:DigestMethod');
  DM.SetAttribute('Algorithm', 'http://www.w3.org/2001/04/xmlenc#sha256');
  AddTextNode(Ref, 'ds:DigestValue', '');

  // SignatureValue (lo rellenará el signer)
  AddTextNode(Sig, 'ds:SignatureValue', '');

  // KeyInfo / X509Certificate (lo rellenará el signer)
  KeyInfo := AddNode(Sig, 'ds:KeyInfo');
  X509Data := AddNode(KeyInfo, 'ds:X509Data');
  AddTextNode(X509Data, 'ds:X509Certificate', '');

  // -------- Object + QualifyingProperties (XAdES) --------
  ObjNode := AddNode(Sig, 'ds:Object');
  if Trim(ObjectId) <> '' then
    ObjNode.SetAttribute('Id', ObjectId);

  QP := AddNode(ObjNode, 'xades:QualifyingProperties');
  // Namespace XAdES v1.3.2 (el que encaja con ETSI TS 101 903 v1.3.2)
  QP.SetAttribute('xmlns:xades', 'http://uri.etsi.org/01903/v1.3.2#');
  QP.SetAttribute('Target', '#' + SignatureId);

  // -------- SignedProperties --------
  SP := AddNode(QP, 'xades:SignedProperties');
  SP.SetAttribute('Id', SignedPropsId);

  // ---- SignedSignatureProperties ----
  SSP := AddNode(SP, 'xades:SignedSignatureProperties');

  // SigningTime (UTC real)
  AddTextNode(SSP, 'xades:SigningTime', FormatDateTimeUTC_Z(Now));

  // SigningCertificate (MUY importante para interoperabilidad)
  SigningCert := AddNode(SSP, 'xades:SigningCertificate');
  CertNode := AddNode(SigningCert, 'xades:Cert');

  CertDigest := AddNode(CertNode, 'xades:CertDigest');
  HashMethod := AddNode(CertDigest, 'ds:DigestMethod');
  HashMethod.SetAttribute('Algorithm', 'http://www.w3.org/2001/04/xmlenc#sha256');
  AddTextNode(CertDigest, 'ds:DigestValue', ''); // signer debe poner digest del cert

  IssuerSerial := AddNode(CertNode, 'xades:IssuerSerial');
  AddTextNode(IssuerSerial, 'ds:X509IssuerName', '');     // signer debe rellenar
  AddTextNode(IssuerSerial, 'ds:X509SerialNumber', '');   // signer debe rellenar

  // SignaturePolicyIdentifier (estructura XAdES correcta)
  Policy := AddNode(SSP, 'xades:SignaturePolicyIdentifier');
  PolicyId := AddNode(Policy, 'xades:SignaturePolicyId');

  SigPolicyId := AddNode(PolicyId, 'xades:SigPolicyId');
  // En XAdES, lo típico es Identifier (+ opcional Description)
  AddTextNode(SigPolicyId, 'xades:Identifier',
    'http://www.facturae.es/politica_de_firma_formato_facturae/politica_de_firma_formato_facturae_v3_1.pdf');
  AddTextNode(SigPolicyId, 'xades:Description', 'Política de firma Formato Facturae v3.1');

  PolicyHash := AddNode(PolicyId, 'xades:SigPolicyHash');
  HashMethod := AddNode(PolicyHash, 'ds:DigestMethod');
  // Facturae política v3.1 históricamente se publica con hash SHA1 en ejemplos
  HashMethod.SetAttribute('Algorithm', 'http://www.w3.org/2000/09/xmldsig#sha1');
  AddTextNode(PolicyHash, 'ds:DigestValue', 'Ohixl6upD6av8N7pEvDABhEL6hM=');

  // SigPolicyQualifiers/SPURI (opcional, pero ayuda a validadores)
  PolicyQuals := AddNode(PolicyId, 'xades:SigPolicyQualifiers');
  PolicyQual := AddNode(PolicyQuals, 'xades:SigPolicyQualifier');
  SPURI := AddNode(PolicyQual, 'xades:SPURI');
  SPURI.AppendChild(FDoc.CreateTextNode(
    'http://www.facturae.es/politica_de_firma_formato_facturae/politica_de_firma_formato_facturae_v3_1.pdf'
  ));

  // ---- SignedDataObjectProperties (recomendado) ----
  SDOP := AddNode(SP, 'xades:SignedDataObjectProperties');

  DOF := AddNode(SDOP, 'xades:DataObjectFormat');
  DOF.SetAttribute('ObjectReference', '#' + RefDocId);
  AddTextNode(DOF, 'xades:MimeType', 'text/xml');
  // (Opcional) AddTextNode(DOF, 'xades:Description', 'Facturae 3.2.2');

  // (NOTA) No añadimos UnsignedProperties aquí; XAdES-BES/EPES base no lo requiere.
end;

procedure TFacturaEGenerator.BuildFacturaE(
  dbCabecera, dbDetalles, dbCliente: TDataSet;
  const OutputFile: String
);
type
  TVatInfo = record
    Rate: Double;
    Base: Double;
    Tax: Double;
  end;
var
  Root, FileHeader, Batch, Parties, Invoices, Invoice: TDOMElement;
  InvHeader, InvIssueData, PlaceNode, PeriodNode: TDOMElement;
  VATs: array of TVatInfo;
  idx: Integer;
  Serie, Numero, BatchId, EmpresaLimpia: String;
  Fecha: TDateTime;
  TotalFactura, BaseTotal, TaxTotal: Double;
  OG, OC, UT, Obs, CCF_Val: String;

  procedure AddOrUpdateVAT(ARate, ABase, ATax: Double);
  var j: Integer;
  begin
    for j := 0 to High(VATs) do
      if Abs(VATs[j].Rate - ARate) < 0.0001 then
      begin
        VATs[j].Base := VATs[j].Base + ABase;
        VATs[j].Tax  := VATs[j].Tax  + ATax;
        Exit;
      end;
    SetLength(VATs, Length(VATs) + 1);
    VATs[High(VATs)].Rate := ARate;
    VATs[High(VATs)].Base := ABase;
    VATs[High(VATs)].Tax  := ATax;
  end;

  procedure BuildSellerParty(AParent: TDOMElement);
  var SellerParty, TaxId, LegalEntity, Addr, Contact: TDOMElement;
  begin
    SellerParty := AddNode(AParent, 'SellerParty');
    TaxId := AddNode(SellerParty, 'TaxIdentification');
    AddTextNode(TaxId, 'PersonTypeCode', 'J');
    AddTextNode(TaxId, 'ResidenceTypeCode', 'R');
    AddTextNode(TaxId, 'TaxIdentificationNumber', Nif);

    LegalEntity := AddNode(SellerParty, 'LegalEntity');
    EmpresaLimpia := StringReplace(Empresa, '  ', ' ', [rfReplaceAll]);
    AddTextNode(LegalEntity, 'CorporateName', EmpresaLimpia);
    AddTextNode(LegalEntity, 'TradeName', EmpresaLimpia);

    // Sin etiquetas extrañas aquí

    Addr := AddNode(LegalEntity, 'AddressInSpain');
    AddTextNode(Addr, 'Address', Direccion);
    AddTextNode(Addr, 'PostCode', CleanPostCode(CP));
    AddTextNode(Addr, 'Town', Localidad);
    AddTextNode(Addr, 'Province', Provincia);
    AddTextNode(Addr, 'CountryCode', 'ESP');

    Contact := AddNode(LegalEntity, 'ContactDetails');
    AddTextNode(Contact, 'Telephone', Telefono);
    AddTextNode(Contact, 'ElectronicMail', eMail);
  end;

  procedure BuildBuyerParty(AParent: TDOMElement);
  var
    BuyerParty, TaxId, LegalEntity, Addr, Contact: TDOMElement;
    Admin, C, AddrC: TDOMElement;
    NIFCli, NomCli, DirCli, CPCli, PobCli, ProvCli, TelCli, MailCli: String;

    procedure AddCentre(const CodeRaw, Role, RoleName, APostCode: String);
    var
      CodeOnly, FullDesc: String;
      pDash: Integer;
    begin
      // MiFacturae puede incluir descripción tras el código: "GE00... - Nombre"
      CodeOnly := Trim(CodeRaw);
      FullDesc := '';
      pDash := Pos('-', CodeOnly);
      if pDash > 0 then
      begin
        FullDesc := Trim(CodeOnly);
        CodeOnly := Trim(Copy(CodeOnly, 1, pDash - 1));
      end;

      C := AddNode(Admin, 'AdministrativeCentre');
      AddTextNode(C, 'CentreCode', CodeOnly);
      AddTextNode(C, 'RoleTypeCode', Role);
      AddTextNode(C, 'Name', UpperCase(RoleName)); // MiFacturae/FACe: nombres en MAYÚSCULAS
      AddrC := AddNode(C, 'AddressInSpain');
      AddTextNode(AddrC, 'Address', DirCli);
      AddTextNode(AddrC, 'PostCode', CleanPostCode(APostCode));
      AddTextNode(AddrC, 'Town', PobCli);
      AddTextNode(AddrC, 'Province', ProvCli);
      AddTextNode(AddrC, 'CountryCode', 'ESP');
      // En MiFacturae suele aparecer también la descripción completa (opcional)
      if FullDesc <> '' then
        AddTextNode(C, 'CentreDescription', FullDesc);
    end;

  begin
    NIFCli  := SafeFieldAsString(dbCliente, 'C5');
    NomCli  := SafeFieldAsString(dbCliente, 'C1');
    DirCli  := SafeFieldAsString(dbCliente, 'C3');
    CPCli   := SafeFieldAsString(dbCliente, 'C37');
    PobCli  := SafeFieldAsString(dbCliente, 'C4');
    ProvCli := SafeFieldAsString(dbCliente, 'C38');
    TelCli  := SafeFieldAsString(dbCliente, 'C6');
    MailCli := SafeFieldAsString(dbCliente, 'C40');

    BuyerParty := AddNode(AParent, 'BuyerParty');
    TaxId := AddNode(BuyerParty, 'TaxIdentification');
    AddTextNode(TaxId, 'PersonTypeCode', 'J');
    AddTextNode(TaxId, 'ResidenceTypeCode', 'R');
    AddTextNode(TaxId, 'TaxIdentificationNumber', NIFCli);

    if (OG <> '') or (OC <> '') or (UT <> '') then
    begin
      Admin := AddNode(BuyerParty, 'AdministrativeCentres');
      // Orden MiFacturae: 02 (Órgano Gestor), 03 (Unidad Tramitadora), 01 (Oficina Contable)
      if OG <> '' then AddCentre(OG, '02', 'ORGANO GESTOR', CPCli);
      if UT <> '' then AddCentre(UT, '03', 'UNIDAD TRAMITADORA', CPCli);
      if OC <> '' then AddCentre(OC, '01', 'OFICINA CONTABLE', CPCli);
    end;
    
    FLX_WriteLog('FACTURAE', 'DIR3 parseado -> OG=' + OG + ' OC=' + OC + ' UT=' + UT + ' CCF=' + CCF_Val);

    LegalEntity := AddNode(BuyerParty, 'LegalEntity');
    AddTextNode(LegalEntity, 'CorporateName', NomCli);
    Addr := AddNode(LegalEntity, 'AddressInSpain');
    AddTextNode(Addr, 'Address', DirCli);
    AddTextNode(Addr, 'PostCode', CleanPostCode(CPCli));
    AddTextNode(Addr, 'Town', PobCli);
    AddTextNode(Addr, 'Province', ProvCli);
    AddTextNode(Addr, 'CountryCode', 'ESP');

    Contact := AddNode(LegalEntity, 'ContactDetails');
    AddTextNode(Contact, 'Telephone', TelCli);
    AddTextNode(Contact, 'ElectronicMail', MailCli);
  end;

  procedure AccumulateVAT;
  var Cant, PU, BaseL, TotalL, IVA, ImpIVA, Dto: Double;
  begin
    if (dbDetalles = nil) or (not dbDetalles.Active) then Exit;
    dbDetalles.First;
    while not dbDetalles.EOF do
    begin
      Cant  := SafeFieldAsFloat(dbDetalles, 'IMP7');
      PU    := SafeFieldAsFloat(dbDetalles, 'IMP9');
      BaseL := SafeFieldAsFloat(dbDetalles, 'IMP11');
      IVA   := SafeFieldAsFloat(dbDetalles, 'IMP12');
      TotalL:= SafeFieldAsFloat(dbDetalles, 'IMP13');
      Dto   := SafeFieldAsFloat(dbDetalles, 'IMP10');
      if (BaseL = 0) and (Cant <> 0) then BaseL := Cant * PU * (1 - Dto / 100);
      if TotalL = 0 then TotalL := BaseL * (1 + IVA / 100);
      ImpIVA := TotalL - BaseL;
      AddOrUpdateVAT(IVA, BaseL, ImpIVA);
      dbDetalles.Next;
    end;
  end;

  procedure BuildTaxes(AParent: TDOMElement);
  var TaxesOutputs, TaxNode, TB, TA: TDOMElement; j: Integer;
  begin
    TaxesOutputs := AddNode(AParent, 'TaxesOutputs');
    for j := 0 to High(VATs) do
    begin
      TaxNode := AddNode(TaxesOutputs, 'Tax');
      AddTextNode(TaxNode, 'TaxTypeCode', '01');
      AddTextNode(TaxNode, 'TaxRate', FormatFloat('0.00', VATs[j].Rate));
      TB := AddNode(TaxNode, 'TaxableBase');
      AddTextNode(TB, 'TotalAmount', FormatFloat('0.00', VATs[j].Base));
      TA := AddNode(TaxNode, 'TaxAmount');
      AddTextNode(TA, 'TotalAmount', FormatFloat('0.00', VATs[j].Tax));
    end;
  end;

  procedure BuildTotals(AParent: TDOMElement);
  var InvoiceTotals: TDOMElement;
  begin
    InvoiceTotals := AddNode(AParent, 'InvoiceTotals');
    AddTextNode(InvoiceTotals, 'TotalGrossAmount', FormatFloat('0.00', BaseTotal));
    AddTextNode(InvoiceTotals, 'TotalGeneralDiscounts', '0.00');
    AddTextNode(InvoiceTotals, 'TotalGeneralSurcharges', '0.00');
    AddTextNode(InvoiceTotals, 'TotalGrossAmountBeforeTaxes', FormatFloat('0.00', BaseTotal));
    AddTextNode(InvoiceTotals, 'TotalTaxOutputs', FormatFloat('0.00', TaxTotal));
    AddTextNode(InvoiceTotals, 'TotalTaxesWithheld', '0.00');
    AddTextNode(InvoiceTotals, 'InvoiceTotal', FormatFloat('0.00', TotalFactura));
    AddTextNode(InvoiceTotals, 'TotalOutstandingAmount', FormatFloat('0.00', TotalFactura));
    AddTextNode(InvoiceTotals, 'TotalExecutableAmount', FormatFloat('0.00', TotalFactura));
  end;

  { MODIFICADO: Ahora acepta el CCF como parámetro }
  procedure BuildItems(AParent: TDOMElement; const ACCF: String);
  var Items, ItemNode, TaxesNode, TaxNode, TB, TA: TDOMElement;
      Cant, PU, BaseL, IVA, ImpIVA, Dto: Double;
      Desc, CodArt: String;
      LineNo: Integer;
  begin
    Items := AddNode(AParent, 'Items');
    LineNo := 0;
    dbDetalles.First;
    while not dbDetalles.EOF do
    begin
      Cant   := SafeFieldAsFloat(dbDetalles, 'IMP7');
      PU     := SafeFieldAsFloat(dbDetalles, 'IMP9');
      BaseL  := SafeFieldAsFloat(dbDetalles, 'IMP11');
      IVA    := SafeFieldAsFloat(dbDetalles, 'IMP12');
      Dto    := SafeFieldAsFloat(dbDetalles, 'IMP10');
      Desc   := SafeFieldAsString(dbDetalles, 'IMP6');
      CodArt := SafeFieldAsString(dbDetalles, 'IMP5');
      if (BaseL = 0) and (Cant <> 0) then BaseL := Cant * PU * (1 - Dto / 100);
      ImpIVA := (BaseL * IVA) / 100;

      ItemNode := AddNode(Items, 'InvoiceLine');

      Inc(LineNo);

      { --- CCF / referencias FACe (MiFacturae) --- }
      // En la factura oficial de MiFacturae, el CCF aparece como ReceiverContractReference
      // y además se suele repetir en la descripción del ítem.
      if ACCF <> '' then
      begin
        AddTextNode(ItemNode, 'ReceiverContractReference', ACCF);
        AddTextNode(ItemNode, 'ReceiverContractDate', FormatDateISO(Fecha));
        // Secuencia con un decimal (1.0, 2.0, ...) como en MiFacturae
        AddTextNode(ItemNode, 'SequenceNumber', FormatFloat('0.0', LineNo));
      end;

      // Descripción (si hay CCF, lo añadimos al final como hace MiFacturae)
      if (ACCF <> '') and (Pos(ACCF, Desc) = 0) then
        AddTextNode(ItemNode, 'ItemDescription', Desc + ' - Código de control de la factura (CCF): ' + ACCF)
      else
        AddTextNode(ItemNode, 'ItemDescription', Desc);
      AddTextNode(ItemNode, 'Quantity', FormatFloat('0.######', Cant));
      AddTextNode(ItemNode, 'UnitOfMeasure', '01');
      AddTextNode(ItemNode, 'UnitPriceWithoutTax', FormatFloat('0.00000', PU));
      AddTextNode(ItemNode, 'TotalCost', FormatFloat('0.00', BaseL));
      AddTextNode(ItemNode, 'GrossAmount', FormatFloat('0.00', BaseL));

      TaxesNode := AddNode(ItemNode, 'TaxesOutputs');
      TaxNode   := AddNode(TaxesNode, 'Tax');
      AddTextNode(TaxNode, 'TaxTypeCode', '01');
      AddTextNode(TaxNode, 'TaxRate', FormatFloat('0.00', IVA));
      TB := AddNode(TaxNode, 'TaxableBase');
      AddTextNode(TB, 'TotalAmount', FormatFloat('0.00', BaseL));
      TA := AddNode(TaxNode, 'TaxAmount');
      AddTextNode(TA, 'TotalAmount', FormatFloat('0.00', ImpIVA));

      // ArticleCode: en FacturaE 3.2.2 suele dar error de validación (FACE/xmllint).
      // Para mantener compatibilidad, NO lo emitimos. Si necesitas conservarlo, añádelo al texto del ItemDescription o
      // mapea a un campo permitido por esquema (pero sin romper el orden de la secuencia).

      dbDetalles.Next;
    end;
  end;

begin
  Serie        := dbCabecera.Fields[2].AsString;
  Numero       := dbCabecera.Fields[3].AsString;
  Fecha        := dbCabecera.Fields[1].AsDateTime;
  TotalFactura := dbCabecera.Fields[9].AsFloat;

  Obs := dbCabecera.Fields[19].AsString;
  // Extraemos también el CCF de las observaciones
  ParseAdministrativeCentres(Obs, OG, OC, UT, CCF_Val);

  BaseTotal := 0; TaxTotal := 0;
  SetLength(VATs, 0);

  Root := AddNode(nil, 'fe:Facturae');
  Root.SetAttribute('xmlns:fe', 'http://www.facturae.gob.es/formato/Versiones/Facturaev3_2_2.xml');
  Root.SetAttribute('xmlns:ds', 'http://www.w3.org/2000/09/xmldsig#');

  FileHeader := AddNode(Root, 'FileHeader');
  AddTextNode(FileHeader, 'SchemaVersion', '3.2.2');
  AddTextNode(FileHeader, 'Modality', 'I');
  AddTextNode(FileHeader, 'InvoiceIssuerType', 'EM');

  Batch := AddNode(FileHeader, 'Batch');
  BatchId := Nif + Numero + Serie; // MiFacturae/FACe: NIF + Numero + Serie
  AddTextNode(Batch, 'BatchIdentifier', BatchId);
  AddTextNode(Batch, 'InvoicesCount', '1');
  AddTextNode(AddNode(Batch, 'TotalInvoicesAmount'), 'TotalAmount', FormatFloat('0.00', TotalFactura));
  AddTextNode(AddNode(Batch, 'TotalOutstandingAmount'), 'TotalAmount', FormatFloat('0.00', TotalFactura));
  AddTextNode(AddNode(Batch, 'TotalExecutableAmount'), 'TotalAmount', FormatFloat('0.00', TotalFactura));
  AddTextNode(Batch, 'InvoiceCurrencyCode', 'EUR');

  Parties := AddNode(Root, 'Parties');
  BuildSellerParty(Parties);
  BuildBuyerParty(Parties);

  Invoices := AddNode(Root, 'Invoices');
  Invoice  := AddNode(Invoices, 'Invoice');
  InvHeader := AddNode(Invoice, 'InvoiceHeader');
  AddTextNode(InvHeader, 'InvoiceNumber', Numero);
  AddTextNode(InvHeader, 'InvoiceSeriesCode', Serie);
  AddTextNode(InvHeader, 'InvoiceDocumentType', 'FC');
  AddTextNode(InvHeader, 'InvoiceClass', 'OO');

  InvIssueData := AddNode(Invoice, 'InvoiceIssueData');
  AddTextNode(InvIssueData, 'IssueDate', FormatDateISO(Fecha));

  { --- MODIFICADO (mínimo): campos que MiFacturae suele incluir y que FACe espera en facturas “CCF” --- }
  // OperationDate: en MiFacturae suele coincidir con la fecha de emisión
  AddTextNode(InvIssueData, 'OperationDate', FormatDateISO(Fecha));

  // PlaceOfIssue: lo tomamos del domicilio del emisor (CP + Localidad) si existe
  if (Trim(CP) <> '') or (Trim(Localidad) <> '') then
  begin
    PlaceNode := AddNode(InvIssueData, 'PlaceOfIssue');
    if Trim(CP) <> '' then
      AddTextNode(PlaceNode, 'PostCode', CleanPostCode(CP));
    if Trim(Localidad) <> '' then
      AddTextNode(PlaceNode, 'PlaceOfIssueDescription', UpperCase(Localidad));
  end;

  // InvoicingPeriod: para factura puntual usamos mismo día (Start=End=Fecha)
  PeriodNode := AddNode(InvIssueData, 'InvoicingPeriod');
  AddTextNode(PeriodNode, 'StartDate', FormatDateISO(Fecha));
  AddTextNode(PeriodNode, 'EndDate',   FormatDateISO(Fecha));

  // Moneda / idioma
  AddTextNode(InvIssueData, 'InvoiceCurrencyCode', 'EUR');
  AddTextNode(InvIssueData, 'TaxCurrencyCode', 'EUR');
  AddTextNode(InvIssueData, 'LanguageName', 'es');

  // InvoiceDescription: si hay CCF, lo indicamos aquí como hace MiFacturae
  if Trim(CCF_Val) <> '' then
    AddTextNode(InvIssueData, 'InvoiceDescription', 'Código de control de la factura (CCF): ' + Trim(CCF_Val));

  AccumulateVAT;
  for idx := 0 to High(VATs) do
  begin
    BaseTotal := BaseTotal + VATs[idx].Base;
    TaxTotal  := TaxTotal  + VATs[idx].Tax;
  end;

  BuildTaxes(Invoice);
  BuildTotals(Invoice);

  // Pasamos el CCF para que se añada en cada línea
  BuildItems(Invoice, CCF_Val);

  AddXAdESBES_Template(
    Root,
    '',
    'SIG-' + BatchId,
    'SignedProps-' + BatchId,
    'Object-' + BatchId
  );

  WriteXMLFile(FDoc, OutputFile);
end;

end.