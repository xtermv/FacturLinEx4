unit uVFSenderAEAT;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, blcksock,
  httpsend, ssl_openssl, synautil,  // Synapse 40
  config, Funciones, Menu, Global,
  uVFFirmaXML, uVeriFactu, uVeriHash,
  uVeriSIF, uVF_CertTools;  // para vfUrlTP, Nif, Empresa, etc.

//=========== LECTURA DE INI PARA DATOS CERTIFICADOS ===========================
type
  TVFTLSConfig = record
    CertFile    : string;
    KeyFile     : string;
    KeyPassword : string;
    CAFile      : string;
  end;

type
  // Misma firma que TVFSendFunc en uVeriFactuDispatcher
  // Ahora recibe también el hash encadenado ya calculado (EncadenamientoHash)
  TVFSendFunc = function(const Serie: string; Numero: Integer;
                         const PayloadJSON: string;
                         const EncadenamientoHash: string;
                         out Hash: string; out Respuesta: string): Boolean;

function VF_SendAEAT_HTTP(const Serie: string; Numero: Integer;
  const PayloadJSON: string;
  const EncadenamientoHash: string;
  out Hash: string; out Respuesta: string): Boolean;

implementation

uses
  fpjson, jsonparser, IniFiles;

//--- Forward para poder usar JsonGetField antes de su implementación real
function JsonGetField(const JSON, Key: string): string; forward;

 // Ruta al FacturConf.ini según tu lógica de RutaIni / HOME
function VF_GetIniPath: string;
begin
  if Trim(RutaIni) <> '' then
    Result := IncludeTrailingPathDelimiter(RutaIni) + 'FacturConf.ini'
  else
  {$IFDEF UNIX}
    Result := IncludeTrailingPathDelimiter(
                IncludeTrailingPathDelimiter(GetEnvironmentVariable('HOME')) +
                '.facturlinex2') + 'FacturConf.ini';
  {$ELSE}
    Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'FacturConf.ini';
  {$ENDIF}
end;

// Carga la configuración TLS desde [VeriFactuTLS] del FacturConf.ini
procedure VF_LoadTLSConfig(out Cfg: TVFTLSConfig);
var
  ini: TIniFile;
  fn : string;
begin
  FillChar(Cfg, SizeOf(Cfg), 0);
  fn := VF_GetIniPath;
  if not FileExists(fn) then
    Exit;

  ini := TIniFile.Create(fn);
  try
    Cfg.CertFile    := ini.ReadString('VeriFactuTLS', 'CertFile', '');
    Cfg.KeyFile     := ini.ReadString('VeriFactuTLS', 'KeyFile', '');
    Cfg.KeyPassword := ini.ReadString('VeriFactuTLS', 'KeyPassword', '');
    Cfg.CAFile      := ini.ReadString('VeriFactuTLS', 'CAFile', '');
  finally
    ini.Free;
  end;
end;

//-- Normaliza NIF para AEAT
function VF_NormalizaNIF(const S: string): string;
var
  C: Char;
begin
  Result := '';
  for C in S do
    if C in ['0'..'9','A'..'Z','a'..'z'] then
      Result := Result + UpCase(C);
end;


//-- FUNCION PARA SANEAR EL JSON SIN TENER QUE MODIFICAR EL ORIGINAL QUE NO RECUERDO DONDE ESTÁ
function VF_FixJSONForAEAT(const JSON: string): string;
var
  Parser : TJSONParser;
  Data   : TJSONData;
  Root   : TJSONObject;
  Cab    : TJSONData;
  CabObj : TJSONObject;
  NIFCli : string;
begin
  Result := JSON;
  if Trim(JSON) = '' then
    Exit;

  Parser := TJSONParser.Create(JSON);
  try
    Data := Parser.Parse;
    try
      if not (Data is TJSONObject) then
        Exit;

      Root := TJSONObject(Data);

      // Buscamos la cabecera
      Cab := Root.Find('cabecera');
      if (Cab <> nil) and (Cab is TJSONObject) then
      begin
        CabObj := TJSONObject(Cab);

        // 1) Normalizar nifCliente: quitar puntos, guiones, espacios...
        NIFCli := CabObj.Get('nifCliente', '');
        if NIFCli <> '' then
          CabObj.Strings['nifCliente'] := VF_NormalizaNIF(NIFCli);

        // 2) Añadir nifEmisor si no existe
        if CabObj.Find('nifEmisor') = nil then
          CabObj.Add('nifEmisor', VF_NormalizaNIF(Nif));

        // 3) Añadir nombreEmisor si no existe
        if CabObj.Find('nombreEmisor') = nil then
          CabObj.Add('nombreEmisor', Trim(Empresa));
      end;

      // Devolvemos el JSON “arreglado”
      Result := Root.AsJSON;
    finally
      Data.Free;
    end;
  except
    // Si algo falla al parsear, devolvemos el JSON original para no romper el envío
    Result := JSON;
  end;
  Parser.Free;
end;

{==============================================================================
                           RUTAS Y LOG BÁSICO
==============================================================================}

function VF_DataPath: string;
var
  Base: string;
begin
  // ~/.local/share/verifactu
  Base := GetEnvironmentVariable('HOME');
  if Base = '' then
    Base := GetCurrentDir;

  Result := IncludeTrailingPathDelimiter(Base) +
            '.local' + DirectorySeparator +
            'share' + DirectorySeparator +
            'verifactu';
end;

procedure VF_EnsureDir(const APath: string);
begin
  if (APath <> '') and (not DirectoryExists(APath)) then
    ForceDirectories(APath);
end;

procedure VF_SafeAppendLine(const AFile, Line: string);
var
  FS: TFileStream;
  S : string;
begin
  VF_EnsureDir(ExtractFilePath(AFile));
  if FileExists(AFile) then
    FS := TFileStream.Create(AFile, fmOpenReadWrite or fmShareDenyNone)
  else
    FS := TFileStream.Create(AFile, fmCreate or fmShareDenyNone);
  try
    FS.Position := FS.Size;
    S := Line + LineEnding;
    FS.WriteBuffer(Pointer(S)^, Length(S));
  finally
    FS.Free;
  end;
end;

procedure VF_WriteDiag(const S: string);
var
  LogDir, FileName, Line: string;
begin
  try
    LogDir   := IncludeTrailingPathDelimiter(VF_DataPath) +
                'logs' + DirectorySeparator;
    VF_EnsureDir(LogDir);

    FileName := LogDir + 'sender.log';
    Line     := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + '  ' + S;

    VF_SafeAppendLine(FileName, Line);
  except
    // Nunca re-lanzamos: el log JAMÁS debe romper el flujo
  end;
end;

//-- FORMATEO DE DECIMALES

function VF_FormatDec(const S, AFormat: string): string;
var
  V: Double;
  FS: TFormatSettings;
  Tmp: string;
begin
  Result := '';
  Tmp := Trim(S);
  if Tmp = '' then
    Exit;

  // Normalizamos comas a punto
  Tmp := StringReplace(Tmp, ',', '.', [rfReplaceAll]);

  FS := DefaultFormatSettings;
  FS.DecimalSeparator := '.';

  if TryStrToFloat(Tmp, V, FS) then
    Result := FormatFloat(AFormat, V, FS)
  else
    Result := Tmp; // si no cuadra, devolvemos tal cual
end;

function VF_Dec2(const S: string): string;
begin
  Result := VF_FormatDec(S, '0.00');
end;

function VF_Dec3(const S: string): string;
begin
  Result := VF_FormatDec(S, '0.000');
end;


{==============================================================================
                 XML A: SOBRE SOAP CON JSON (lo que ya usas)
==============================================================================}

procedure VF_SaveRequestXML_A(const Serie: string; Numero: Integer;
  const Soap: string);
var
  ReqDir, FileName, Stamp: string;
  SL: TStringList;
begin
  try
    ReqDir := IncludeTrailingPathDelimiter(VF_DataPath) +
              'requests' + DirectorySeparator;
    VF_EnsureDir(ReqDir);

    Stamp    := FormatDateTime('yyyymmdd"-"hhnnss', Now);
    FileName := Format('%sA_%s_%d_%s.xml', [ReqDir, Serie, Numero, Stamp]);

    SL := TStringList.Create;
    try
      SL.Text := Soap;
      SL.SaveToFile(FileName);
    finally
      SL.Free;
    end;

    VF_WriteDiag('VF_SaveRequestXML_A: guardado XML A en ' + FileName);
  except
    on E: Exception do
      VF_WriteDiag('VF_SaveRequestXML_A error: ' + E.Message);
  end;
end;

function XML_Escape(const S: string): string;
begin
  Result := StringReplace(S, '&', '&amp;',  [rfReplaceAll]);
  Result := StringReplace(Result, '<', '&lt;',  [rfReplaceAll]);
  Result := StringReplace(Result, '>', '&gt;',  [rfReplaceAll]);
  Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
  // No escapamos comilla simple para no destrozar el JSON en XML A
end;

// XML A – metemos el JSON dentro del sobre SOAP como bloque de texto.
function BuildSoapEnvelopeFromJSON(const PayloadJSON: string): string;
var
  Escaped: string;
begin
  Escaped := XML_Escape(PayloadJSON);

  Result :=
    '<?xml version="1.0" encoding="UTF-8"?>' + LineEnding +
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ' +
    'xmlns:ver="http://www.aeat.es/verifactu/provisional">' + LineEnding +
    '  <soapenv:Header/>' + LineEnding +
    '  <soapenv:Body>' + LineEnding +
    '    <ver:EnviarFacturaVeriFactuRequest>' + LineEnding +
    '      <ver:JsonPayload>' + Escaped + '</ver:JsonPayload>' + LineEnding +
    '    </ver:EnviarFacturaVeriFactuRequest>' + LineEnding +
    '  </soapenv:Body>' + LineEnding +
    '</soapenv:Envelope>' + LineEnding;
end;

procedure VF_SaveVeriFactuXML_B(const Serie: string; Numero: Integer;
  const XML: string);
var
  ReqDir, FileName, Stamp: string;
  SL: TStringList;
begin
  try
    ReqDir := IncludeTrailingPathDelimiter(VF_DataPath) +
              'requests' + DirectorySeparator;
    VF_EnsureDir(ReqDir);

    Stamp    := FormatDateTime('yyyymmdd"-"hhnnss', Now);
    FileName := Format('%sSIF_B_%s_%d_%s.xml', [ReqDir, Serie, Numero, Stamp]);

    SL := TStringList.Create;
    try
      SL.Text := XML;
      SL.SaveToFile(FileName);
    finally
      SL.Free;
    end;

    VF_WriteDiag('VF_SaveVeriFactuXML_B: guardado XML SIF B en ' + FileName);
  except
    on E: Exception do
      VF_WriteDiag('VF_SaveVeriFactuXML_B error: ' + E.Message);
  end;
end;


{==============================================================================
               NORMALIZACIÓN NUMÉRICA (EVITAR 5.84999E+0)
==============================================================================}

function VF_NormalizeDecimal(const S: string; Digits: Integer = 2): string;
var
  V: Double;
  Tmp: string;
  OldDec: Char;
  Pattern: string;
  I: Integer;
begin
  Tmp := Trim(S);
  if Tmp = '' then
  begin
    Result := '0.';
    for I := 1 to Digits do
      Result := Result + '0';
    Exit;
  end;

  Tmp := StringReplace(Tmp, ',', '.', [rfReplaceAll]);

  OldDec := DefaultFormatSettings.DecimalSeparator;
  DefaultFormatSettings.DecimalSeparator := '.';
  try
    if not TryStrToFloat(Tmp, V) then
    begin
      // Si no se puede convertir, devolvemos tal cual
      Result := Tmp;
      Exit;
    end;

    Pattern := '0.';
    for I := 1 to Digits do
      Pattern := Pattern + '0';

    Result := FormatFloat(Pattern, V);
  finally
    DefaultFormatSettings.DecimalSeparator := OldDec;
  end;
end;

{==============================================================================
                          JsonGetField (LOCAL, MEJORADO)
==============================================================================}

// Soporta rutas tipo:
//   'cabecera.serie'
//   'lineas[0].descripcion'
//   'impuestos.ivas[1].tipo'
function JsonGetField(const JSON, Key: string): string;
var
  Parser: TJSONParser;
  Data, Cur, Child: TJSONData;
  Parts: TStringList;
  I, idxStart, idxEnd, ArrIndex: Integer;
  Part, Name, IdxStr: string;
begin
  Result := '';
  if (Trim(JSON) = '') or (Trim(Key) = '') then
    Exit;

  Parser := TJSONParser.Create(JSON);
  try
    Data := Parser.Parse;
    try
      Cur := Data;

      Parts := TStringList.Create;
      try
        Parts.Delimiter := '.';
        Parts.StrictDelimiter := True;
        Parts.DelimitedText := Key;

        for I := 0 to Parts.Count - 1 do
        begin
          Part := Parts[I];
          Name := Part;
          ArrIndex := -1;

          // ¿lleva índice de array? p.ej. 'ivas[0]'
          idxStart := Pos('[', Part);
          if idxStart > 0 then
          begin
            idxEnd := Pos(']', Part);
            if idxEnd > idxStart then
            begin
              Name   := Copy(Part, 1, idxStart - 1);
              IdxStr := Copy(Part, idxStart + 1, idxEnd - idxStart - 1);
              ArrIndex := StrToIntDef(IdxStr, -1);
            end;
          end;

          // Paso por objeto
          if Name <> '' then
          begin
            if Cur.JSONType = jtObject then
            begin
              Child := TJSONObject(Cur).Find(Name);
              if Child = nil then
                Exit; // no encontrado
              Cur := Child;
            end
            else
              Exit;
          end;

          // Paso por array
          if ArrIndex >= 0 then
          begin
            if Cur.JSONType = jtArray then
            begin
              if (ArrIndex < 0) or (ArrIndex >= TJSONArray(Cur).Count) then
                Exit;
              Cur := TJSONArray(Cur).Items[ArrIndex];
            end
            else
              Exit;
          end;
        end;

        Result := Cur.AsString;
      finally
        Parts.Free;
      end;
    finally
      Data.Free;
    end;
  except
    Result := '';
  end;
  Parser.Free;
end;

{==============================================================================
      DESCRIPCIÓN DE OPERACIÓN (RESUMEN DE VARIAS LÍNEAS DE VENTA)
==============================================================================}

function VF_BuildDescripcionOperacion(const PayloadJSON: string): string;
var
  LineasTotStr: string;
  LineasTot, I, Mostradas: Integer;
  Desc, Tmp: string;
begin
  Result := '';
  LineasTotStr := JsonGetField(PayloadJSON, 'cabecera.lineasTotales');
  LineasTotStr := StringReplace(LineasTotStr, ',', '.', [rfReplaceAll]);
  LineasTot := StrToIntDef(LineasTotStr, 0);

  if LineasTot <= 0 then
  begin
    Result := Trim(JsonGetField(PayloadJSON, 'lineas[0].descripcion'));
    if Result = '' then
      Result := 'Venta TPV';
    Exit;
  end;

  Desc := '';
  Mostradas := 0;
  for I := 0 to LineasTot - 1 do
  begin
    if Mostradas >= 3 then
      Break;

    Tmp := Trim(JsonGetField(PayloadJSON, Format('lineas[%d].descripcion', [I])));
    if Tmp = '' then
      Continue;

    if Desc <> '' then
      Desc := Desc + ' | ';
    Desc := Desc + Tmp;
    Inc(Mostradas);
  end;

  if Desc = '' then
    Desc := 'Venta TPV';

  if LineasTot > Mostradas then
    Desc := Desc + Format(' ... (+%d líneas más)', [LineasTot - Mostradas]);

  Result := Desc;
end;

{==============================================================================
          XML B: RegFactuSistemaFacturacion (SIF OFICIAL, SIN SOAP)
==============================================================================}

// Construimos el XML SIF (B) a partir del JSON actual:
//
//   cabecera.serie / numero / fecha / totalConIVA / nifCliente / nombreCliente
//   lineas[0..] para descripcion
//   impuestos.ivas[n].tipo / base / cuota  (múltiples IVAs)
function BuildVeriFactuXMLFromJSON(const Serie: string; Numero: Integer;
  const PayloadJSON: string;var AHash: string; const AHashPrev: string): string;
var
  NIFEmisor, NombreEmisor: string;
  NIFClienteRaw, NIFCliente, NombreCliente: string;
  FechaRaw, FechaAEAT, FechaHoraGenRegistro: string;
  ImporteTotal, CuotaTotal: string;
  // -- Para recalculos
  SumBaseD, TotalCalc: Double;
  SumBaseStr, OrigTotalStr: string;
  //-- Fin recalculos
  IVA_Tipo, IVA_Base, IVA_Cuota: string;
  I: Integer;
  HasAnyIVA: Boolean;
  SerieXML, TipoFacturaXML, TipoFacGlobal: string;
  PrevNumero: Integer;
  PrevNumSerie, PrevFecha: string;
  //-- Variables SIFFactu
  SIFCfg: TVeriSIFConfig;

  //-- Variables del Sistema Informático
  SIFNombreRazon, SIFNIF: string;
  SIFNombreSistema, SIFId, SIFVersion, SIFNumeroInst: string;
  SIFSoloVF, SIFMultiOT, SIFMultiplesOT: string;

  // === NUEVO: variables para HUELLTA AEAT SIF B ===
  HashAEAT: string;
  CuotaTotalD, ImporteTotalD: Double;
  NumSerieFactura: string;
  FS: TFormatSettings;

  function CleanNIF(const S: string): string;
  var
    C: Char;
  begin
    Result := '';
    for C in S do
      if C in ['0'..'9','A'..'Z','a'..'z'] then
        Result := Result + UpCase(C);
  end;

  function To2Dec(const S: string): string;
  var
    V: Double;
    Tmp: String;
  begin
    Tmp := Trim(S);
    if Tmp = '' then
      Exit('0.00');
    Tmp := StringReplace(Tmp, '.', FormatSettings.DecimalSeparator, [rfReplaceAll]);
    V := StrToFloatDef(Tmp, 0);
    Result := FormatFloat('0.00', V);
  end;

  function FechaToAEAT(const S: string): string;
  begin
  	// Esto no lo tengo claro, depende de donde obtengamos la información es así o al revés
    // JSON viene como '2025-11-21' → AEAT exige '21-11-2025'
    if Length(S) = 10 then
      Result := Copy(S, 9, 2) + '-' + Copy(S, 6, 2) + '-' + Copy(S, 1, 4)
    else
      Result := FormatDateTime('dd-mm-yyyy', Date);
  end;

  function SumStrDec2(const A, B: string): string;
  var
    VA, VB: Double;
    SA, SB: string;
  begin
    // Normalizamos por si viene con coma
    SA := StringReplace(A, ',', '.', [rfReplaceAll]);
    SB := StringReplace(B, ',', '.', [rfReplaceAll]);

    VA := StrToFloatDef(SA, 0);
    VB := StrToFloatDef(SB, 0);
    Result := FormatFloat('0.00', VA + VB);
  end;

  // =====================================================
  //   DETECCIÓN DEL TIPO DE FACTURA (F1 / F2) POR CONTEXTO
  //   - Si en el JSON existe cabecera.tipoFactura => manda
  //   - Si la serie empieza por FS (FS..., FS-...) => F2
  //   - Resto de series => F1 (factura completa)
  //   IMPORTANTE: dejamos de depender de vfTipoFactura global
  //   para evitar que todas salgan como el último tipo usado.
  // =====================================================
  function DetectTipoFacturaFromContext: string;
  var
    SerieUpper, TFJson: string;
  begin
    // 1) Primero intentamos leerlo del propio JSON (por si en el futuro lo grabamos ahí)
    TFJson := UpperCase(Trim(JsonGetField(PayloadJSON, 'cabecera.tipoFactura')));
    if (TFJson = 'F1') or (TFJson = 'F2') then
      Exit(TFJson);

    SerieUpper := UpperCase(Trim(Serie));

    // 2) Tickets / TPV: series que empiezan por FS (FS-A25, FS001, etc.) → F2
    if Copy(SerieUpper, 1, 2) = 'FS' then
      Exit('F2');

    // 3) Todo lo demás lo consideramos factura completa F1
    Result := 'F1';
  end;

begin
  // Emisor desde tus variables globales
  NIFEmisor    := Trim(Nif);
  NombreEmisor := Trim(Empresa);

  // -----------------------------------------------
  // ----- DATOS DEL SISTEMA INFORMÁTICO (SIF) -----
  // -----------------------------------------------
  // Estos valores deben coincidir con la ficha que te haya aprobado la AEAT.
  // CAMBIA SOLO ESTAS LÍNEAS cuando tengas los datos definitivos:
  SIFNombreRazon   := NombreEmisor;        // o el nombre que conste para el SIF
  SIFNIF           := NIFEmisor;           // NIF asociado al SIF

  SIFNombreSistema := 'FacturLinEx 2.0 (SIF Libre)';   // Nombre del sistema (según AEAT)
  SIFId            := Copy(GetMachineUUIDFromFile, 1, 16);  //-- Este también sería viable "SIFId := 'FacturlinexLibre';"
  															// IdSistemaInformatico (el que te asignen)
  SIFVersion       := '2.0.0';             // Versión declarada del SIF
  SIFNumeroInst    := '1';                 // Número de instalación (si solo hay una, "1")

  // Indicadores de uso (ajusta según cómo conste en tu alta SIF):
  SIFSoloVF        := 'N';  // ¿Uso posible solo Veri*Factu?  S/N
  SIFMultiOT       := 'N';  // ¿Uso posible multi OT (múltiples obligados)? S/N
  SIFMultiplesOT   := 'N';  // ¿Indicador de múltiples OT en esta instalación? S/N
  // -----------------------------------------------
  // ----- FIN DATOS SISTEMA INFORMÁTICO (SIF) -----
  // -----------------------------------------------
  // -- A ver que datos selecciona, solo cambia la versión para la prueba.
  // -----------------------------------------------
  // ----- DATOS DEL SISTEMA INFORMÁTICO (SIF) -----
  // ***** NUEVO SISTEMA CONFIGURABLE EN FORM ******
  // -----------------------------------------------
  VF_SIF_Load(SIFCfg);
  //-- SIFNombreRazon   := SIFCfg.NombreRazon;   //-- De momento mantenemos los del sistema
  //-- SIFNIF           := SIFCfg.NIF;           //-- De momento mantenemos los del sistema
  SIFNombreSistema := SIFCfg.NombreSistema;
  SIFId            := SIFCfg.IdSistema; //-- Confirmado , debe ser un código de 2 Letras o Números , pero solo 2, por defecto FL
  SIFVersion       := SIFCfg.Version;
  SIFNumeroInst    := SIFCfg.NumeroInstalacion;
  SIFSoloVF        := SIFCfg.SoloVerifactu;
  SIFMultiOT       := SIFCfg.MultiOT;
  SIFMultiplesOT   := SIFCfg.MultiplesOT;
  // -----------------------------------------------
  // ----- FIN DATOS SISTEMA INFORMÁTICO (SIF) -----
  // -----------------------------------------------

  // =====================================================
  // Tipo factura DETECTADO por contexto (no vfTipoFactura)
  //   F1 = completa
  //   F2 = simplificada
  // =====================================================
  TipoFacGlobal := DetectTipoFacturaFromContext;

  // SerieXML: por ahora usamos la serie tal cual (A25, FS-A25, etc.)
  SerieXML := Trim(Serie);
  TipoFacturaXML := TipoFacGlobal;

  VF_WriteDiag(Format(
    'BuildVeriFactuXMLFromJSON: Serie=%s Numero=%d TipoFactura=%s',
    [SerieXML, Numero, TipoFacturaXML]
  ));

  // Datos del receptor desde JSON (estructura nueva 1.2.x)
  NIFClienteRaw := JsonGetField(PayloadJSON, 'cabecera.nifCliente');
  NIFCliente    := CleanNIF(NIFClienteRaw);
  if SameText(TipoFacGlobal, 'F2') then
    NombreCliente := 'CLIENTE DE PASO' // si luego quieres, lo sacamos del JSON
  else
  begin
    NombreCliente := JsonGetField(PayloadJSON, 'cabecera.nombreCliente');
    if Trim(NombreCliente) = '' then
      NombreCliente := 'CLIENTE DE PASO - FRA'; // fallback por si acaso
  end;

  FechaRaw      := JsonGetField(PayloadJSON, 'cabecera.fecha');
  if FechaRaw = '' then
    FechaRaw := FormatDateTime('yyyy-mm-dd', Date); // seguridad

  FechaAEAT := FechaToAEAT(FechaRaw);

  ImporteTotal := JsonGetField(PayloadJSON, 'cabecera.totalConIVA');
  ImporteTotal := To2Dec(ImporteTotal); // 2 decimales

  // Fecha/hora generación registro con huso (formato ejemplo AEAT)
  FechaHoraGenRegistro :=
    FormatDateTime('yyyy"-"mm"-"dd"T"hh":"nn":"ss', Now) + '+01:00';

  // =========================
  //  CABECERA + REGISTROALTA
  //  Versión SOAP + sum/sum1 (modelo ejemplo)
  // =========================
  Result :=
    '<?xml version="1.0" encoding="UTF-8"?>' + LineEnding +
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ' + LineEnding +
    'xmlns:sum="https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/SuministroLR.xsd" ' + LineEnding +
    'xmlns:sum1="https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/SuministroInformacion.xsd" ' + LineEnding +
    'xmlns:xd="http://www.w3.org/2000/09/xmldsig#"' + LineEnding +
    'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' + LineEnding +
    '  <soapenv:Header/>' + LineEnding +
    '  <soapenv:Body>' + LineEnding +
    '    <sum:RegFactuSistemaFacturacion>' + LineEnding +
    '      <sum:Cabecera>' + LineEnding +
    '        <sum1:ObligadoEmision>' + LineEnding +
    '          <sum1:NombreRazon>' + NombreEmisor + '</sum1:NombreRazon>' + LineEnding +
    '          <sum1:NIF>' + NIFEmisor + '</sum1:NIF>' + LineEnding +
    '        </sum1:ObligadoEmision>' + LineEnding +
    '      </sum:Cabecera>' + LineEnding +
    '      <sum:RegistroFactura>' + LineEnding +
    '        <sum1:RegistroAlta>' + LineEnding +
    '          <sum1:IDVersion>1.0</sum1:IDVersion>' + LineEnding +
    '          <sum1:IDFactura>' + LineEnding +
    '            <sum1:IDEmisorFactura>' + NIFEmisor + '</sum1:IDEmisorFactura>' + LineEnding +
    '            <sum1:NumSerieFactura>' + SerieXML + '-' + IntToStr(Numero) + '</sum1:NumSerieFactura>' + LineEnding +
    '            <sum1:FechaExpedicionFactura>' + FechaAEAT + '</sum1:FechaExpedicionFactura>' + LineEnding +
    '          </sum1:IDFactura>' + LineEnding +
    '          <sum1:NombreRazonEmisor>' + NombreEmisor + '</sum1:NombreRazonEmisor>' + LineEnding +
    '          <sum1:Subsanacion>N</sum1:Subsanacion>' + LineEnding +
    '          <sum1:RechazoPrevio>N</sum1:RechazoPrevio>' + LineEnding +
    '          <sum1:TipoFactura>' + TipoFacturaXML + '</sum1:TipoFactura>' + LineEnding +
    '          <sum1:FechaOperacion>' + FechaAEAT + '</sum1:FechaOperacion>' + LineEnding;

  // -- Si Tipo F2 (Factura Simplificada)
  if SameText(TipoFacGlobal, 'F2') then
    Result := Result + '          <sum1:DescripcionOperacion>VENTA TPV</sum1:DescripcionOperacion>' + LineEnding
  else
    Result := Result + '          <sum1:DescripcionOperacion>VENTA FACTURA COMPLETA TIPO F1</sum1:DescripcionOperacion>' + LineEnding;

  // Destinatario / Contraparte (según últimos ejemplos → bloque Destinatarios)
  if Length(NIFCliente) = 9 then
    Result := Result +
      '          <sum1:Destinatarios>' + LineEnding +
      '            <sum1:IDDestinatario>' + LineEnding +
      '              <sum1:NombreRazon>' + NombreCliente + '</sum1:NombreRazon>' + LineEnding +
      '              <sum1:NIF>' + NIFCliente + '</sum1:NIF>' + LineEnding +
      '            </sum1:IDDestinatario>' + LineEnding +
      '          </sum1:Destinatarios>' + LineEnding;

  Result := Result +
    '          <sum1:Desglose>' + LineEnding;

  // =========================
  //     DESGLOSE DE IVAS
  // =========================
  HasAnyIVA  := False;
  CuotaTotal := '0.00';
  SumBaseStr := '0.00';
  I          := 0;

  while True do
  begin
    IVA_Tipo  := JsonGetField(PayloadJSON, Format('impuestos.ivas[%d].tipo', [I]));
    if IVA_Tipo = '' then
      Break; // no hay más IVAs

    IVA_Base  := JsonGetField(PayloadJSON, Format('impuestos.ivas[%d].base',  [I]));
    IVA_Cuota := JsonGetField(PayloadJSON, Format('impuestos.ivas[%d].cuota', [I]));

    IVA_Tipo  := To2Dec(IVA_Tipo);   // porcentaje con 2 decimales (21.00, 10.00, 4.00...)
    IVA_Base  := To2Dec(IVA_Base);   // base con 2 decimales (por XSD)
    IVA_Cuota := To2Dec(IVA_Cuota);  // cuota con 2 decimales

    CuotaTotal := SumStrDec2(CuotaTotal, IVA_Cuota);
    SumBaseStr := SumStrDec2(SumBaseStr, IVA_Base); //-- Calcular la Base
    HasAnyIVA  := True;

    Result := Result +
      '            <sum1:DetalleDesglose>' + LineEnding +
      '              <sum1:Impuesto>01</sum1:Impuesto>' + LineEnding +
      '              <sum1:ClaveRegimen>01</sum1:ClaveRegimen>' + LineEnding +
      '              <sum1:CalificacionOperacion>S1</sum1:CalificacionOperacion>' + LineEnding +
      '              <sum1:TipoImpositivo>' + IVA_Tipo + '</sum1:TipoImpositivo>' + LineEnding +
      '              <sum1:BaseImponibleOimporteNoSujeto>' + IVA_Base + '</sum1:BaseImponibleOimporteNoSujeto>' + LineEnding +
      '              <sum1:CuotaRepercutida>' + IVA_Cuota + '</sum1:CuotaRepercutida>' + LineEnding +
      '            </sum1:DetalleDesglose>' + LineEnding;

    Inc(I);
  end;

  // Si no hubiera IVAs (caso raro), metemos uno dummy a 0 para no dejar vacío <Desglose>
  if not HasAnyIVA then
    Result := Result +
      '            <sum1:DetalleDesglose>' + LineEnding +
      '              <sum1:Impuesto>01</sum1:Impuesto>' + LineEnding +
      '              <sum1:ClaveRegimen>01</sum1:ClaveRegimen>' + LineEnding +
      '              <sum1:CalificacionOperacion>S1</sum1:CalificacionOperacion>' + LineEnding +
      '              <sum1:TipoImpositivo>0.00</sum1:TipoImpositivo>' + LineEnding +
      '              <sum1:BaseImponibleOimporteNoSujeto>0.00</sum1:BaseImponibleOimporteNoSujeto>' + LineEnding +
      '              <sum1:CuotaRepercutida>0.00</sum1:CuotaRepercutida>' + LineEnding +
      '            </sum1:DetalleDesglose>' + LineEnding;

  Result := Result +
    '          </sum1:Desglose>' + LineEnding +
    '          <sum1:CuotaTotal>' + CuotaTotal + '</sum1:CuotaTotal>' + LineEnding;

  // --- Recalcular ImporteTotal a partir del desglose (Bases + Cuotas) ---
  SumBaseD := StrToFloatDef(
               StringReplace(SumBaseStr, ',', '.', [rfReplaceAll]),
               0
             );
  CuotaTotalD := StrToFloatDef(
                  StringReplace(CuotaTotal, ',', '.', [rfReplaceAll]),
                  0
                );
  TotalCalc := SumBaseD + CuotaTotalD;
  ImporteTotal := FormatFloat('0.00', TotalCalc);

  // (Opcional) comparar con el JSON original y dejarlo en log
  OrigTotalStr := JsonGetField(PayloadJSON, 'cabecera.totalConIVA');
  if OrigTotalStr <> '' then
  begin
    ImporteTotalD := StrToFloatDef(
                       StringReplace(OrigTotalStr, ',', '.', [rfReplaceAll]),
                       0
                     );
    if Abs(ImporteTotalD - TotalCalc) > 0.01 then
      VF_WriteDiag(Format(
        'Aviso: ImporteTotal JSON=%s, calculado=%s (se usa el calculado)',
        [OrigTotalStr, ImporteTotal]
      ));
  end;

  Result := Result +
    '          <sum1:ImporteTotal>' + ImporteTotal + '</sum1:ImporteTotal>' + LineEnding;

  // ===================================================================
  //   AHORA: CÁLCULO HUELLTA AEAT SIF B (con los datos ya montados)
  // ===================================================================
  NumSerieFactura := SerieXML + '-' + IntToStr(Numero);

  // Pasamos CuotaTotal e ImporteTotal (texto) a Double de forma neutra
  FS := DefaultFormatSettings;
  FS.DecimalSeparator := '.';
  CuotaTotalD    := StrToFloatDef(StringReplace(CuotaTotal, ',', '.', [rfReplaceAll]), 0);
  ImporteTotalD  := StrToFloatDef(StringReplace(ImporteTotal, ',', '.', [rfReplaceAll]), 0);

  HashAEAT := VF_CalcSIFHashAEAT(
    NIFEmisor,
    NumSerieFactura,
    FechaAEAT,            // 'DD-MM-YYYY'
    TipoFacturaXML,       // 'F1' / 'F2'
    CuotaTotalD,
    ImporteTotalD,
    AHashPrev,            // huella previa que ya nos llega
    FechaHoraGenRegistro  // 'YYYY-MM-DDThh:nn:ss+01:00'
  );

  // devolvemos la huella AEAT al llamador
  AHash := HashAEAT;

  // =========================
  //    ENCADENAMIENTO (HASH PREVIO)
  // =========================
  if AHashPrev <> '' then
  begin
    // Para identificar el registro anterior usamos misma serie y número-1
    PrevNumero  := Numero - 1;
    if PrevNumero < 1 then
      PrevNumero := Numero; // seguridad básica

    PrevNumSerie := SerieXML + '-' + IntToStr(PrevNumero);
    PrevFecha    := FechaAEAT; // misma fecha de expedición

    Result := Result +
      '          <sum1:Encadenamiento>' + LineEnding +
      '            <sum1:RegistroAnterior>' + LineEnding +
      '              <sum1:IDEmisorFactura>' + NIFEmisor + '</sum1:IDEmisorFactura>' + LineEnding +
      '              <sum1:NumSerieFactura>' + PrevNumSerie + '</sum1:NumSerieFactura>' + LineEnding +
      '              <sum1:FechaExpedicionFactura>' + PrevFecha + '</sum1:FechaExpedicionFactura>' + LineEnding +
      '              <sum1:Huella>' + AHashPrev + '</sum1:Huella>' + LineEnding +
      '            </sum1:RegistroAnterior>' + LineEnding +
      '          </sum1:Encadenamiento>' + LineEnding;
  end
  else
  begin
    //-- CASO DE SER LA PRIMERA FACTURA ENVIADA SE AUTOREFERENCIA
    Result := Result +
      '          <sum1:Encadenamiento>' + LineEnding +
      '            <sum1:RegistroAnterior>' + LineEnding +
      '              <sum1:IDEmisorFactura>' + NIFEmisor + '</sum1:IDEmisorFactura>' + LineEnding +
      '              <sum1:NumSerieFactura>' + SerieXML + '</sum1:NumSerieFactura>' + LineEnding +
      '              <sum1:FechaExpedicionFactura>' + FechaAEAT + '</sum1:FechaExpedicionFactura>' + LineEnding +
      '              <sum1:Huella>' + HashAEAT + '</sum1:Huella>' + LineEnding +
      '            </sum1:RegistroAnterior>' + LineEnding +
      '          </sum1:Encadenamiento>' + LineEnding;
  end;

  // =========================
  //   SISTEMA INFORMÁTICO (SIF)
  //   (valores de ejemplo, cámbialos por los reales de tu SIF)
  // =========================
  Result := Result +
    '          <sum1:SistemaInformatico>' + LineEnding +
    '            <sum1:NombreRazon>' + SIFNombreRazon + '</sum1:NombreRazon>' + LineEnding +
    '            <sum1:NIF>' + SIFNIF + '</sum1:NIF>' + LineEnding +
    '            <sum1:NombreSistemaInformatico>' + SIFNombreSistema + '</sum1:NombreSistemaInformatico>' + LineEnding +
    '            <sum1:IdSistemaInformatico>' + SIFId + '</sum1:IdSistemaInformatico>' + LineEnding +
    '            <sum1:Version>' + SIFVersion + '</sum1:Version>' + LineEnding +
    '            <sum1:NumeroInstalacion>' + SIFNumeroInst + '</sum1:NumeroInstalacion>' + LineEnding +
    '            <sum1:TipoUsoPosibleSoloVerifactu>' + SIFSoloVF + '</sum1:TipoUsoPosibleSoloVerifactu>' + LineEnding +
    '            <sum1:TipoUsoPosibleMultiOT>' + SIFMultiOT + '</sum1:TipoUsoPosibleMultiOT>' + LineEnding +
    '            <sum1:IndicadorMultiplesOT>' + SIFMultiplesOT + '</sum1:IndicadorMultiplesOT>' + LineEnding +
    '          </sum1:SistemaInformatico>' + LineEnding +
    '          <sum1:FechaHoraHusoGenRegistro>' + FechaHoraGenRegistro + '</sum1:FechaHoraHusoGenRegistro>' + LineEnding +
    '          <sum1:TipoHuella>01</sum1:TipoHuella>' + LineEnding +
    // *** AQUÍ EL CAMBIO CRÍTICO: usamos HashAEAT en vez de AHash ***
    '          <sum1:Huella>' + HashAEAT + '</sum1:Huella>' + LineEnding +
    '        </sum1:RegistroAlta>' + LineEnding +
    '      </sum:RegistroFactura>' + LineEnding +
    '    </sum:RegFactuSistemaFacturacion>' + LineEnding +
    '  </soapenv:Body>' + LineEnding +
    '</soapenv:Envelope>' + LineEnding;
end;


{==============================================================================
                           URL DE AEAT (vfUrlTP)
==============================================================================}

function GetAEATURL: string;
begin
  // Usamos tu variable global vfUrlTP (configurable desde tu app)
  Result := Trim(vfUrlTP);
  if Result = '' then
    Result := 'https://prewww1.aeat.es/wlpl/TIKE-CONT/ws/SistemaFacturacion/VerifactuSOAP';
end;

{==============================================================================
                           ENVÍO HTTP REAL (XML A)
==============================================================================}

function VF_SendAEAT_HTTP(const Serie: string; Numero: Integer;
  const PayloadJSON: string;
  const EncadenamientoHash: string;
  out Hash: string; out Respuesta: string): Boolean;
var
  Http: THTTPSend;
  SoapA, URL: string;
  SoapB : string;
  TLSCfg: TVFTLSConfig;
  SSL: TSSLOpenSSL;
  Prot, User, Pass, Host, Port, Path, Para, HRef: string;
  Dummy: string;

  //-- Variables control de errores AEAT
  AEAT_EstadoEnvio,
  AEAT_EstadoRegistro,
  AEAT_CodError,
  AEAT_DescError,
  AEAT_CSV: string;
  //------------------------------------
//-- Funcion Anidada para extraer errores de la respuesta AEAT
function ExtractTag(const XML, Tag: string): string;
var
  openTag, closeTag: string;
  p1, p2: SizeInt;
begin
  Result  := '';
  openTag := '<' + Tag + '>';
  closeTag := '</' + Tag + '>';

  p1 := Pos(openTag, XML);
  if p1 = 0 then Exit;

  p1 := p1 + Length(openTag);
  p2 := Pos(closeTag, XML);
  if (p2 = 0) or (p2 <= p1) then Exit;

  Result := Copy(XML, p1, p2 - p1);
end;
//-- Fin Funcion Anidada

begin
  Result    := False;
  Respuesta := '';

  // IMPORTANTE: devolvemos el mismo hash que recibimos
  Hash := EncadenamientoHash;

  URL := GetAEATURL;

  // Extraemos Host, etc. para SNI
  Dummy := ParseURL(URL, Prot, User, Pass, Host, Port, Path, Para);

  VF_WriteDiag(Format('VF_SendAEAT_HTTP: preparando envío %s-%d -> %s',
                      [Serie, Numero, URL]));

  // 1) Construimos el XML A (SOAP + JSON) como hasta ahora
  SoapA := BuildSoapEnvelopeFromJSON(PayloadJSON);

  // 2) Guardamos SIEMPRE XML A
  VF_SaveRequestXML_A(Serie, Numero, SoapA);

  // 3) Guardamos también XML B (SIF) CON HUELLA
  SoapB := BuildVeriFactuXMLFromJSON(Serie, Numero, PayloadJSON, Hash, GHashPrev);
  VF_SaveVeriFactuXML_B(Serie, Numero, SoapB);

  // 4) Envío HTTP solo con XML B (de momento)
  Http := THTTPSend.Create;
  try
    // Crear contexto SSL (OpenSSL)
    Http.Sock.CreateWithSSL(TSSLOpenSSL);
    SSL := TSSLOpenSSL(Http.Sock.SSL);

    // Cargar configuración TLS desde INI (si existe)
    VF_LoadTLSConfig(TLSCfg);

    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // INSERCIÓN PARA DEPURACIÓN: Registrar el XML SOAP completo
    VF_WriteDiag('--- INICIO XML SOAP (SoapB) ---');
    VF_WriteDiag(SoapB);
    VF_WriteDiag('--- FIN XML SOAP (SoapB) ---');
    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    VF_WriteDiag(Format('TLSCfg.CertFile=%s', [TLSCfg.CertFile]));
    VF_WriteDiag(Format('TLSCfg.KeyFile=%s',  [TLSCfg.KeyFile]));
    VF_WriteDiag(Format('TLSCfg.CAFile=%s',   [TLSCfg.CAFile]));
    VF_WriteDiag(Format('TLSCfg.KeyPassword=%s', [TLSCfg.KeyPassword]));

    if Assigned(SSL) then
    begin
      // Forzamos TLS 1.2 como mínimo (AEAT)
      // SSL.SSLType := LT_TLSv1_2;
      SSL.SSLType := LT_all;

      // IMPORTANTE: SNI para que el servidor sepa qué cert presentar
      if Host <> '' then
        SSL.SNIHost := Host;

      // Certificado cliente (mutual TLS)
      if TLSCfg.CertFile <> '' then
        SSL.CertificateFile := TLSCfg.CertFile;      // antes: SSL.CertFile
      if TLSCfg.KeyFile <> '' then
        SSL.PrivateKeyFile := TLSCfg.KeyFile;        // antes: SSL.KeyFile
      if TLSCfg.KeyPassword <> '' then
        SSL.KeyPassword := TLSCfg.KeyPassword;
      if TLSCfg.CAFile <> '' then
        SSL.CertCAFile := TLSCfg.CAFile;             // antes: SSL.CAFile

      // De momento NO verificamos el servidor a mano; dejamos a OpenSSL
      // SSL.VerifyCert := False;
    end;
    Http.UserAgent := 'FacturLinEx-VeriFactu/1.0';
    Http.MimeType  := 'text/xml; charset=utf-8';

    // -- Pruebas de envío del XML B SIF en lugar del SoapA
    WriteStrToStream(Http.Document, SoapB);
    Http.Document.Position := 0;

    VF_WriteDiag('VF_SendAEAT_HTTP: enviando POST a ' + URL);

    if not Http.HTTPMethod('POST', URL) then
    begin
      // ── Diagnóstico extra de error de socket / TLS ─────────────────────
      Respuesta := 'VF_SendAEAT_HTTP: fallo al hacer HTTPMethod (sin respuesta HTTP)';
      VF_WriteDiag(Respuesta);
      if Assigned(SSL) then
        // Error de socket (nivel TCP)
        Respuesta := Respuesta +
         Format(' | SockErr=%d %s | SSLErr=%d %s',
            [Http.Sock.LastError, Http.Sock.LastErrorDesc,
             SSL.LastError, SSL.LastErrorDesc]);
      VF_WriteDiag(Respuesta);
      Exit(False);
    end;

    Http.Document.Position := 0;
    Respuesta := ReadStrFromStream(Http.Document, Http.Document.Size);

    VF_WriteDiag(Format('VF_SendAEAT_HTTP: HTTP %d %s',
                        [Http.ResultCode, Http.ResultString]));

    VF_WriteDiag('VF_SendAEAT_HTTP: cuerpo respuesta AEAT: ' + Respuesta);

    if Http.ResultCode <> 200 then
    begin
      VF_WriteDiag('VF_SendAEAT_HTTP: error HTTP, cuerpo: ' + Respuesta);
      Exit(False);
    end;

    // ============================================================
    //      A PARTIR DE AQUÍ: INTERPRETAR RESPUESTA AEAT
    // ============================================================

    // Ojo con los namespaces: en tu ejemplo vienen como tikR: y tik:
    AEAT_EstadoEnvio    := ExtractTag(Respuesta, 'tikR:EstadoEnvio');
    AEAT_EstadoRegistro := ExtractTag(Respuesta, 'tikR:EstadoRegistro');
    AEAT_CodError       := ExtractTag(Respuesta, 'tikR:CodigoErrorRegistro');
    AEAT_DescError      := ExtractTag(Respuesta, 'tikR:DescripcionErrorRegistro');
    AEAT_CSV            := ExtractTag(Respuesta, 'tikR:CSV');

    // Fallback por si la AEAT cambia prefijos y deja solo el nombre simple
    if AEAT_EstadoEnvio = '' then
      AEAT_EstadoEnvio := ExtractTag(Respuesta, 'EstadoEnvio');
    if AEAT_EstadoRegistro = '' then
      AEAT_EstadoRegistro := ExtractTag(Respuesta, 'EstadoRegistro');
    if AEAT_CodError = '' then
      AEAT_CodError := ExtractTag(Respuesta, 'CodigoErrorRegistro');
    if AEAT_DescError = '' then
      AEAT_DescError := ExtractTag(Respuesta, 'DescripcionErrorRegistro');
    if AEAT_CSV = '' then
      AEAT_CSV := ExtractTag(Respuesta, 'CSV');

    VF_WriteDiag(Format(
      'AEAT -> EstadoEnvio=%s EstadoRegistro=%s CodError=%s CSV=%s Desc=%s',
      [AEAT_EstadoEnvio, AEAT_EstadoRegistro, AEAT_CodError, AEAT_CSV, AEAT_DescError]
    ));

    // ================= DECISIÓN DE "ÉXITO" O "ERROR" =================
    //
    // - Correcto            -> devolvemos True  (dispatcher la marcará ENVIADO)
    // - AceptadoConErrores -> devolvemos False (NO se marca como ENVIADO)
    // - Rechazado u otros  -> devolvemos False
    // - Si no podemos leer nada, mantenemos compatibilidad y devolvemos True.

    if SameText(AEAT_EstadoRegistro, 'Correcto') then
    begin
      Result := True;
    end
    else if SameText(AEAT_EstadoRegistro, 'AceptadoConErrores') then
    begin
      // Lo tratamos como error lógico: la factura NO debe quedar como ENVIADA
      Result := False;

      // Enriquecemos el texto de respuesta para que quede claro el motivo
      Respuesta :=
        Respuesta + LineEnding +
        Format('[AEAT AceptadoConErrores %s] %s',
               [AEAT_CodError, AEAT_DescError]);

      VF_WriteDiag('VF_SendAEAT_HTTP: EstadoRegistro = AceptadoConErrores, devolviendo Result=False');
    end
    else if (AEAT_EstadoRegistro <> '') then
    begin
      // Cualquier otro estado explícito distinto de Correcto → lo tratamos como error
      Result := False;
      Respuesta :=
        Respuesta + LineEnding +
        Format('[AEAT %s %s] %s',
               [AEAT_EstadoRegistro, AEAT_CodError, AEAT_DescError]);

      VF_WriteDiag('VF_SendAEAT_HTTP: EstadoRegistro <> Correcto, devolviendo Result=False');
    end
    else
    begin
      // No hemos encontrado EstadoRegistro -> comportamiento antiguo (asumimos OK)
      VF_WriteDiag('VF_SendAEAT_HTTP: no se encontró EstadoRegistro; se asume Correcto por compatibilidad.');
      Result := True;
    end;

  finally
    Http.Free;
  end;
end;

end.
