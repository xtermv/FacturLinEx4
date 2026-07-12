unit uFLX_FacturaPDF;

{
  Generador rápido de PDF de facturas para FacturLinEx2
  ----------------------------------------------------

  - Lazarus 4.2 + FPC 3.2.2
  - Usa fpPDF (fcl-pdf) para generar PDF rápido
  - Usa Zeos 8 para leer cabecera y líneas de la BBDD
  - Usa variables globales existentes (Empresa, LogoEmpresa, RutaPdf, Host, etc.)

  Flujo:
    1) FLX_GenerateInvoicePDF_FromDB(...)  <-- función pública principal
       - Conecta a la BBDD usando tus globales (Host, DBUsuario, etc.)
       - Carga cabecera + cliente + líneas (factuc+tienda, factud+tienda, clientes)
       - Genera el PDF en RutaPdf/SERIE_NUMERO.pdf
       - Devuelve True/False y el nombre del PDF generado.

    2) Internamente:
       - FLX_LoadFacturaFromDB: traduce tu BBDD -> estructura TFacturaData + TStrings
       - FLX_GenerateSimpleInvoicePDF: crea el PDF con logo, QR, barcode y líneas.

  IMPORTANTE:
    - Debes adaptar las consultas SQL y nombres de campos en FLX_LoadFacturaFromDB
      a tu esquema real (factucXXXX, factudXXXX, clientes, FC0, FD0, etc.).
    - El resto de la unidad es independiente de tu esquema.
}

{$mode objfpc}{$H+}

interface

uses
  uFLX_Log, // logging
  Classes, SysUtils, DateUtils, StrUtils,
  fppdf, Dialogs,      // ✅ NECESARIO PARA ShowMessage
  ZConnection, ZDataset, ZAbstractRODataset,
  LConvEncoding, Graphics, // <-- Añadimos esta libería para la conversión de formatos (acentos etc) que retomaremos al final    // -- Colores en gráficos
  Global; // <-- Aquí suponemos que están todas tus variables globales (Empresa, Host, RutaPdf, etc.)

type
  TFacturaTipo = (ftNormal, ftSimplificada, ftAbono);

  TFacturaIVAItem = record
    TipoIVA       : Double;
    BaseImponible : Double;
    ImporteIVA    : Double;
  end;

  TFacturaData = record
    TipoFactura     : TFacturaTipo;
    Tienda          : string;
    Serie           : string;
    Numero          : Integer;
    Fecha           : TDate;

    // Empresa (desde globales)
    EmpNombre       : string;
    EmpNIF          : string;
    EmpDireccion    : string;
    EmpCP           : string;
    EmpLocalidad    : string;
    EmpProvincia    : string;
    EmpRegistro     : string;

    // Cliente (desde BBDD)
    CliCodigo       : string;
    CliNombre       : string;
    CliNIF          : string;
    CliDireccion    : string;
    CliCP           : string;
    CliLocalidad    : string;
    CliProvincia    : string;

    // Totales principales
    BaseImponible   : Double;
    ImporteIVA      : Double;
    TotalFactura    : Double;

    // Desglose IVA (3 tipos máximo, según tus globales IVA1, IVA2, IVA3)
    IVAItems        : array[0..2] of TFacturaIVAItem;
    IVAItemsCount   : Integer;
  end;

function FLX_GenerateInvoicePDF_FromDB(
  const ATienda, ASerie: string;
  ANumero: Integer;
  const AFecha: TDate;
  const ACodCliente: string;
  const AQRImageFile, ABarCodeFile: string;
  out APDFFileName: string
): Boolean;

implementation

{==============================================================================}
{  Utilidades internas                                                         }
{==============================================================================}

function FormatEUR(const AValue: Double): string;
begin
  Result := FormatFloat('#,##0.00 Euros', AValue);
end;

function FormatPct(const AValue: Double): string;
begin
  Result := FormatFloat('0.00', AValue) + '%';
end;

//-- Nueva formula que intenta utilizar una carpeta editable para que se pueda guardar el pdf
function TryEnsureWritableDir(const ADir: string; out AFinalDir: string): Boolean;
var
  D, TestFile: string;
  F: Integer;
begin
  Result := False;
  AFinalDir := '';

  D := IncludeTrailingPathDelimiter(Trim(ADir));
  if D = '' then Exit;

  try
    if not DirectoryExists(D) then
      ForceDirectories(D);
  except
    Exit; // no se pudo crear
  end;

  // Test rápido de escritura: crear un fichero temporal
  TestFile := D + '.flx_write_test.tmp';
  F := FileCreate(TestFile);
  if F = -1 then Exit;

  FileClose(F);
  DeleteFile(TestFile);

  AFinalDir := D;
  Result := True;
end;

function EnsureRutaPdf: string;
var
  HomeDir, CandidateRuta, CandidateHome, CandidateCur, FinalDir: string;
begin
  HomeDir := GetEnvironmentVariable('HOME');
  CandidateHome := IncludeTrailingPathDelimiter(HomeDir) + 'pdf' + DirectorySeparator;
  CandidateCur  := IncludeTrailingPathDelimiter(GetCurrentDir) + 'pdf' + DirectorySeparator;

  // 1) Candidato principal: RutaPdf (si está definida)
  CandidateRuta := Trim(RutaPdf);

  FLX_WriteLog('PDF', 'EnsureRutaPdf: RutaPdf=' + CandidateRuta +
                       ' Home=' + CandidateHome +
                       ' Cur=' + CandidateCur);

  // 2) Intento RutaPdf
  if (CandidateRuta <> '') and TryEnsureWritableDir(CandidateRuta, FinalDir) then
  begin
    FLX_WriteLog('PDF', 'EnsureRutaPdf: usando RutaPdf=' + FinalDir);
    Exit(FinalDir);
  end;

  // 3) Fallback a ~/pdf  (preferido frente a CurrentDir, para evitar rutas "raras" al lanzar desde menú)
  if TryEnsureWritableDir(CandidateHome, FinalDir) then
  begin
    FLX_WriteLog('PDF', 'EnsureRutaPdf: usando HOME=' + FinalDir);
    Exit(FinalDir);
  end;

  // 4) Último recurso: ./pdf
  if TryEnsureWritableDir(CandidateCur, FinalDir) then
  begin
    FLX_WriteLog('PDF', 'EnsureRutaPdf: usando CurrentDir=' + FinalDir);
    Exit(FinalDir);
  end;

  // 5) Si todo falla, devolvemos HOME/pdf (pero intentamos crearlo igualmente)
  try
    if not DirectoryExists(CandidateHome) then
      ForceDirectories(CandidateHome);
  except
    // no hacemos Exit: devolvemos CandidateHome igualmente
  end;

  FLX_WriteLog('PDF', 'EnsureRutaPdf: WARNING no se pudo asegurar ruta escribible; devolviendo ' + CandidateHome);
  Result := CandidateHome;
end;

function BuildPDFFileName(const Serie: string; Numero: Integer): string;
var
  baseDir: string;
begin
  baseDir := EnsureRutaPdf;
  Result  := baseDir + Serie + '_' + IntToStr(Numero) + '.pdf';
end;

{==============================================================================}
{  Carga de datos desde la BBDD                                                }
{==============================================================================}

function CreateZConnectionFromGlobals: TZConnection;
begin
  Result := TZConnection.Create(nil);
  Result.Protocol := DBProtocolo;  // ej: 'mysql-5', 'mariadb', etc.
  Result.HostName := DBHost;
  Result.Port     := StrToIntDef(DBPuerto, 3306);
  Result.User     := DBUsuario;
  Result.Password := DBPasswd;
  Result.Database := DBDataBase;
end;

function FLX_LoadFacturaFromDB(
  const ATienda, ASerie: string;
  ANumero: Integer;
  const AFecha: TDate;
  const ACodCliente: string;
  Conn: TZConnection;
  out AData: TFacturaData;
  ALineas: TStrings
): Boolean;
var
  QCab, QDet, QCli: TZQuery;
  tablaCab, tablaDet: string;
  lineaDesc: string;
  // Campos temporales
  BaseLinea, IVALinea, PUnit, Cantidad, ImporteLinea, DtoLinea: Double;
  SumBaseMostrada, SumIVAMostrada: Double;
  BaseRedondeada, IVARedondeado: Double;
  I: Integer;
  TipIva: Double;
  j: Integer;         // para recorrer IVAItems
  found: Boolean;     // para saber si ya tenemos ese tipo de IVA
  albaranText: string;// texto FD16
begin
  Result := False;
  SumBaseMostrada := 0;
  SumIVAMostrada  := 0;
  FillChar(AData, SizeOf(AData), 0);
  if not Assigned(Conn) then Exit;
  if not Conn.Connected then Conn.Connect;

  // ---------------------------------------------------------------------------
  // 1) Rellenar datos de empresa desde globales
  // ---------------------------------------------------------------------------
  AData.EmpNombre    := Empresa;
  AData.EmpNIF       := Nif;
  AData.EmpDireccion := Direccion;
  AData.EmpCP        := CP;
  AData.EmpLocalidad := Localidad;
  AData.EmpProvincia := Provincia;
  AData.EmpRegistro  := Registro;

  // ---------------------------------------------------------------------------
  // LOPD: EVITAR ACUMULAR TEXTO ENTRE FACTURAS
  //   Lopd1/Lopd2 son globales; si aquí hacemos "Lopd1 := Lopd1 + ...",
  //   en llamadas repetidas se duplica. Solo añadimos si NO está ya al final.
  //   (tocamos lo mínimo posible, y seguimos usando las globales)
  // ---------------------------------------------------------------------------
  if (Trim(Empresa) <> '') and (not AnsiEndsText(Empresa, TrimRight(Lopd1))) then
    Lopd1 := Lopd1 + Empresa;

  if (Trim(EMail) <> '') and (not AnsiEndsText(EMail, TrimRight(Lopd2))) then
    Lopd2 := Lopd2 + EMail;

  // De momento asumimos factura normal (puedes cambiar según serie)
  AData.TipoFactura  := ftNormal;

  AData.Tienda       := ATienda;
  AData.Serie        := ASerie;
  AData.Numero       := ANumero;
  AData.Fecha        := AFecha; // si la BBDD trae otra fecha, la sobrescribimos luego

  // Inicializamos IVAItems
  AData.IVAItemsCount := 0;
  for I := 0 to 2 do
  begin
    AData.IVAItems[I].TipoIVA       := 0.0;
    AData.IVAItems[I].BaseImponible := 0.0;
    AData.IVAItems[I].ImporteIVA    := 0.0;
  end;

  // ---------------------------------------------------------------------------
  // 2) Cabecera de factura: factuc+tienda
  // ---------------------------------------------------------------------------
  tablaCab := 'factuc' + ATienda; // p.ej. 'factuc0000A'
  QCab := TZQuery.Create(nil);
  try
    QCab.Connection := Conn;
    QCab.SQL.Text :=
      'SELECT * FROM ' + tablaCab +
      ' WHERE FC2 = :SERIE AND FC3 = :NUMERO';
    QCab.ParamByName('SERIE').AsString   := ASerie;
    QCab.ParamByName('NUMERO').AsInteger := ANumero;
    QCab.Open;

    if not QCab.IsEmpty then
    begin
      AData.Fecha         := QCab.FieldByName('FC1').AsDateTime;
      AData.CliCodigo     := QCab.FieldByName('FC0').AsString;
      AData.BaseImponible := QCab.FieldByName('FC8').AsFloat;
      AData.ImporteIVA    := (QCab.FieldByName('FC9').AsFloat - QCab.FieldByName('FC8').AsFloat);
      AData.TotalFactura  := QCab.FieldByName('FC9').AsFloat;

      if ACodCliente <> '' then
        AData.CliCodigo := ACodCliente
      else
        AData.CliCodigo := QCab.FieldByName('FC0').AsString;
    end
    else
      Exit;
  finally
    QCab.Free;
  end;

  // ---------------------------------------------------------------------------
  // 3) Datos de cliente: tabla clientes
  // ---------------------------------------------------------------------------
  if AData.CliCodigo <> '' then
  begin
    QCli := TZQuery.Create(nil);
    try
      QCli.Connection := Conn;
      QCli.SQL.Text :=
        'SELECT * FROM clientes WHERE C0 = :COD';
      QCli.ParamByName('COD').AsString := AData.CliCodigo;
      QCli.Open;

      if not QCli.IsEmpty then
      begin
        AData.CliNombre    := QCli.FieldByName('C1').AsString;
        AData.CliNIF       := QCli.FieldByName('C5').AsString;
        AData.CliDireccion := QCli.FieldByName('C3').AsString;
        AData.CliCP        := QCli.FieldByName('C37').AsString;
        AData.CliLocalidad := QCli.FieldByName('C4').AsString;
        AData.CliProvincia := QCli.FieldByName('C38').AsString;
      end;
    finally
      QCli.Free;
    end;
  end;

  // ---------------------------------------------------------------------------
  // 4) Detalle de líneas: factud+tienda
  // ---------------------------------------------------------------------------
  if Assigned(ALineas) then
    ALineas.Clear;

  tablaDet := 'factud' + ATienda;
  QDet := TZQuery.Create(nil);
  try
    QDet.Connection := Conn;
    QDet.SQL.Text :=
      'SELECT * FROM ' + tablaDet +
      ' WHERE FD2 = :SERIE AND FD3 = :NUMERO ' +
      ' ORDER BY FD4';
    QDet.ParamByName('SERIE').AsString   := ASerie;
    QDet.ParamByName('NUMERO').AsInteger := ANumero;
    QDet.Open;

    while not QDet.EOF do
    begin
      Cantidad     := QDet.FieldByName('FD7').AsFloat;
      lineaDesc    := QDet.FieldByName('FD6').AsString;
      PUnit        := QDet.FieldByName('FD8').AsFloat;
      DtoLinea     := QDet.FieldByName('FD10').AsFloat;  // % descuento de linea
      ImporteLinea := QDet.FieldByName('FD11').AsFloat;
      TipIva       := QDet.FieldByName('FD12').AsFloat;

      BaseLinea := ImporteLinea;
      IVALinea  := BaseLinea * (TipIva / 100.0);

      // --- Multi-IVA: acumular base y cuota por tipo ---
      if TipIva > 0 then
      begin
        found := False;
        for j := 0 to AData.IVAItemsCount - 1 do
        begin
          if Abs(AData.IVAItems[j].TipoIVA - TipIva) < 0.0001 then
          begin
            AData.IVAItems[j].BaseImponible := AData.IVAItems[j].BaseImponible + BaseLinea;
            AData.IVAItems[j].ImporteIVA    := AData.IVAItems[j].ImporteIVA + IVALinea;
            found := True;
            Break;
          end;
        end;

        if (not found) and (AData.IVAItemsCount < 3) then
        begin
          AData.IVAItems[AData.IVAItemsCount].TipoIVA       := TipIva;
          AData.IVAItems[AData.IVAItemsCount].BaseImponible := BaseLinea;
          AData.IVAItems[AData.IVAItemsCount].ImporteIVA    := IVALinea;
          Inc(AData.IVAItemsCount);
        end;
      end;

      if Assigned(ALineas) then
      begin
        albaranText := QDet.FieldByName('FD16').AsString;

        ALineas.Add(
          FormatFloat('0.00', Cantidad) + '|' +
          lineaDesc + '|' +
          FormatEUR(PUnit) + '|' +
          FormatPct(DtoLinea) + '|' +
          FormatEUR(ImporteLinea) + '|' +
          albaranText
        );
      end;

      QDet.Next;
    end;
  finally
    QDet.Free;
  end;

  if AData.IVAItemsCount > 0 then
  begin
    AData.ImporteIVA := 0;
    for j := 0 to AData.IVAItemsCount - 1 do
      AData.ImporteIVA := AData.ImporteIVA + AData.IVAItems[j].ImporteIVA;
  end;

  for I := 0 to AData.IVAItemsCount - 1 do
  begin
    BaseRedondeada := Round(AData.IVAItems[I].BaseImponible * 100) / 100;
    IVARedondeado  := Round(AData.IVAItems[I].ImporteIVA    * 100) / 100;

    SumBaseMostrada := SumBaseMostrada + BaseRedondeada;
    SumIVAMostrada  := SumIVAMostrada  + IVARedondeado;

    AData.IVAItems[I].BaseImponible := BaseRedondeada;
    AData.IVAItems[I].ImporteIVA    := IVARedondeado;
  end;

  AData.BaseImponible := Round(SumBaseMostrada * 100) / 100;
  AData.ImporteIVA    := Round(SumIVAMostrada  * 100) / 100;
  AData.TotalFactura  := AData.BaseImponible + AData.ImporteIVA;

  Result := True;
end;

//-- Procedimiento de conversión de texto para corregir acentos etc
function PDFText(const S: string) : string;
begin
  Result := UTF8ToISO_8859_1(S);
end;

//-- Función para justificar valores a la derecha (Usado en totales)
function PadLeft(const S: string; Width: Integer): string;
var
  L: Integer;
begin
  L := Length(S);
  if L >= Width then
    Result := S
  else
    Result := StringOfChar(' ', Width - L) + S;
end;

//-- Ajuste de línea automático
procedure PDF_WriteWrappedText(
  APDF: TPDFPage;
  AFontIdx: Integer;
  AFontSize: Integer;
  var AY: TPDFFloat;
  const AX: TPDFFloat;
  const AMaxWidthChars: Integer;
  const AText: string;
  const ALineH: TPDFFloat
);
var
  Words: TStringList;
  I: Integer;
  WordStr: string;
  CurrentLine: string;
begin
  Words := TStringList.Create;
  try
    ExtractStrings([' '], [], PChar(AText), Words);

    APDF.SetFont(AFontIdx, AFontSize);
    CurrentLine := '';

    for I := 0 to Words.Count - 1 do
    begin
      WordStr := Words[I];

      if CurrentLine = '' then
        CurrentLine := WordStr
      else
      begin
        if Length(CurrentLine) + 1 + Length(WordStr) <= AMaxWidthChars then
          CurrentLine := CurrentLine + ' ' + WordStr
        else
        begin
          APDF.WriteText(AX, AY, PDFText(CurrentLine));
          AY := AY + ALineH;
          CurrentLine := WordStr;
        end;
      end;
    end;

    if CurrentLine <> '' then
    begin
      APDF.WriteText(AX, AY, PDFText(CurrentLine));
      AY := AY + ALineH;
    end;
  finally
    Words.Free;
  end;
end;

{==============================================================================}
{  Generación del PDF rápido con logo + QR + barcode                           }
{==============================================================================}

function FLX_GenerateSimpleInvoicePDF(
  const AFileName: string;
  const AData: TFacturaData;
  Lineas: TStrings;
  const AQRImageFile, ABarCodeFile: string
): Boolean;
var
  Doc      : TPDFDocument;
  Page     : TPDFPage;
  Section  : TPDFSection;
  FontIdx, FontIdxMono  : Integer;
  X, Y     : TPDFFloat;
  LineH    : TPDFFloat;
  I,j      : Integer;
  FacturaStr, FechaStr: string;
  pageNumber, totalPages: Integer;
  timeStampStr, codeText: string;
  LogoImgId, QRImgId, BarImgId: Integer;
  sBase, sIVA, sTotal: String;
  sBaseR, sIVAR, sTotalR: String;
  S: String;
  SL: TStringList;
  sCant, sDesc, sPUnit, sDto, sImp, sAlb, lastAlb: String;
  sPUnitR, sDtoR, sImpR: string;
const
  TotLabelX = 120.0;
  TotValueX = 180.0;

  ColCantX  = 15.0;
  ColDescX  = 30.0;
  ColPUnitX = 122.0;
  ColDtoX   = 150.0;
  ColImpX   = 168.0;

  LineNumWidth = 12;
  DtoWidthChars = 8;

  IVABaseX  = 20.0;
  IVATipoX  = 55.0;
  IVAIVAX   = 90.0;
  IVATotalX = 120.0;

  TotWidthChars = 14;

  procedure StartNewDetailPage;
  begin
    Page := Doc.Pages.AddPage;
    Section.AddPage(Page);

    Page.PaperType     := ptA4;
    Page.UnitOfMeasure := uomMillimeters;

    X     := 15;
    Y     := 40;
    LineH := 5;

    Page.SetFont(FontIdx, 9);
    Page.WriteText(ColCantX,  Y, UTF8Encode('Cant.'));
    Page.WriteText(ColDescX,  Y, UTF8Encode('Descripcion'));
    Page.WriteText(ColPUnitX, Y, UTF8Encode('PVP'));
    Page.WriteText(ColDtoX,   Y, UTF8Encode('Dto %'));
    Page.WriteText(ColImpX,   Y, UTF8Encode('Total'));
    Y := Y + LineH;
    Y := Y + LineH / 2;

    Page.SetFont(FontIdxMono, 9);
  end;

  procedure StartNewFooterPage;
  begin
    Page := Doc.Pages.AddPage;
    Section.AddPage(Page);

    Page.PaperType     := ptA4;
    Page.UnitOfMeasure := uomMillimeters;

    X     := 15;
    Y     := 40;
    LineH := 5;

    Page.SetFont(FontIdxMono, 9);
  end;

begin
  Result := False;

  Doc := TPDFDocument.Create(nil);
  try
    Doc.Options := Doc.Options + [poPageOriginAtTop];
    Doc.DefaultPaperType := ptA4;

    FacturaStr := Format('%s-%d', [AData.Serie, AData.Numero]);
    Doc.Infos.Title := 'Factura ' + FacturaStr;

    Doc.StartDocument;
    Section := Doc.Sections.AddSection;
    Page := Doc.Pages.AddPage;
    Section.AddPage(Page);

    Page.PaperType := ptA4;
    Page.UnitOfMeasure := uomMillimeters;

    FontIdx := Doc.AddFont('Helvetica');
    FontIdxMono := Doc.AddFont('Courier');
    Page.SetFont(FontIdx, 10);

    X     := 15;
    Y     := 15;
    LineH := 5;

    // LOGO
    if (Trim(LogoEmpresa) <> '') and FileExists(LogoEmpresa) then
    begin
      LogoImgId := Doc.Images.AddFromFile(LogoEmpresa, False);
      Page.DrawImage(15, 40, 40, 20, LogoImgId);
    end;

    if (Trim(AQRImageFile) <> '') and FileExists(AQRImageFile) then
    begin
      Page.WriteText(94, 8, PDFText(LeyendaSuperiorQR));
      Y := Y + LineH;
    end;

    if (Trim(AQRImageFile) <> '') and FileExists(AQRImageFile) then
    begin
      QRImgId := Doc.Images.AddFromFile(AQRImageFile, False);
      Page.DrawImage(90, 40, 30, 30, QRImgId);
    end;

    if (Trim(AQRImageFile) <> '') and FileExists(AQRImageFile) then
    begin
      Page.WriteText(96, 44, PDFText(LeyendaInferiorQR));
      Y := Y + LineH;
    end;

    if (Trim(ABarCodeFile) <> '') and FileExists(ABarCodeFile) then
    begin
      BarImgId := Doc.Images.AddFromFile(ABarCodeFile, False);
      Page.DrawImage(150, 30, 40, 20, BarImgId);
    end;

    pageNumber  := 1;
    totalPages  := 1;
    timeStampStr := FormatDateTime('yyyymmddhhnnss', Now);
    codeText     := Format('%d%s%d', [pageNumber, timeStampStr, totalPages]);

    Page.SetFont(FontIdx, 8);
    Page.WriteText(150, 35, UTF8Encode(codeText));

    Y := 45;

    // DATOS EMPRESA
    Page.SetFont(FontIdx, 12);
    Page.WriteText(X, Y, PDFText(AData.EmpNombre));
    Y := Y + LineH;
    Page.SetFont(FontIdx, 9);
    Page.WriteText(X, Y, UTF8Encode('NIF: ' + AData.EmpNIF));
    Y := Y + LineH;
    Page.WriteText(X, Y, PDFText(AData.EmpDireccion + ' - ' + AData.EmpCP + ' ' + AData.EmpLocalidad));
    Y := Y + LineH;
    if AData.EmpProvincia <> '' then
    begin
      Page.WriteText(X, Y, PDFText(AData.EmpProvincia));
      Y := Y + LineH;
    end;
    if AData.EmpRegistro <> '' then
    begin
      Page.SetFont(FontIdx, 6);
      Page.WriteText(X, Y, PDFText(AData.EmpRegistro));
      Y := Y + LineH;
      Page.SetFont(FontIdx, 12);
    end;

    Y := Y + LineH;

    // DATOS FACTURA
    FechaStr := FormatDateTime('dd/mm/yyyy', AData.Fecha);
    Page.SetFont(FontIdx, 11);
    Page.WriteText(X, Y, UTF8Encode('FACTURA ' + FacturaStr));
    Y := Y + LineH;
    Page.SetFont(FontIdx, 9);
    Page.WriteText(X, Y, UTF8Encode('Fecha: ' + FechaStr));
    Y := Y + LineH * 2;

    // DATOS CLIENTE
    if AData.CliNombre <> '' then
    begin
      Page.SetFont(FontIdx, 10);
      Page.WriteText(X, Y, PDFText('Cliente: ' + AData.CliNombre));
      Y := Y + LineH;
      if AData.CliNIF <> '' then
      begin
        Page.WriteText(X, Y, UTF8Encode('NIF: ' + AData.CliNIF));
        Y := Y + LineH;
      end;
      if (AData.CliDireccion <> '') or (AData.CliLocalidad <> '') then
      begin
        Page.WriteText(X, Y, UTF8Encode(AData.CliDireccion + ' - ' + AData.CliCP + ' ' + AData.CliLocalidad));
        Y := Y + LineH;
      end;
      if AData.CliProvincia <> '' then
      begin
        Page.WriteText(X, Y, UTF8Encode(AData.CliProvincia));
        Y := Y + LineH;
      end;
      Y := Y + LineH;
    end;

    // CABECERA LÍNEAS
    Page.SetColor(clMedGray);
    Page.DrawRect(X, Y+1, 180, LineH, 1, False, True);
    Page.SetColor(clBlack);
    Page.SetFont(FontIdx, 9);
    Page.WriteText(ColCantX,  Y, UTF8Encode('Cant.'));
    Page.WriteText(ColDescX,  Y, PDFText('Descripcion'));
    Page.WriteText(ColPUnitX, Y, UTF8Encode('PVP'));
    Page.WriteText(ColDtoX,   Y, UTF8Encode('Dto %'));
    Page.WriteText(ColImpX,   Y, UTF8Encode('Total'));
    Y := Y + LineH;
    Y := Y + LineH / 2;

    // LÍNEAS
    lastAlb := '';
    Page.SetFont(FontIdxMono, 9);
    if Assigned(Lineas) then
    begin
      SL := TStringList.Create;
      try
        SL.Delimiter := '|';
        SL.StrictDelimiter := True;
        for I := 0 to Lineas.Count - 1 do
        begin
          if Y > 260 then
            StartNewDetailPage;

          S := Lineas[I];
          SL.DelimitedText := S;

          if SL.Count>=4 then
          begin
            sCant  := SL[0];
            sDesc  := SL[1];
            sPUnit := SL[2];

            // Formato nuevo: Cant|Desc|PVP|Dto|Total|Albaran
            // Compatibilidad: si llega una linea antigua, asumimos Dto 0.00%.
            if SL.Count >= 6 then
            begin
              sDto := SL[3];
              sImp := SL[4];
              sAlb := SL[5];
            end
            else
            begin
              sDto := FormatPct(0);
              sImp := SL[3];
              if SL.Count >= 5 then
                sAlb := SL[4]
              else
                sAlb := '';
            end;

            if (sAlb <> '') and (Pos('Albaran.:', sAlb) = 1) and (sAlb <> lastAlb) then
            begin
              Page.SetFont(FontIdx, 8);
              Page.WriteText(ColDescX, Y, UTF8Encode(sAlb));
              Y := Y + LineH;
              Page.SetFont(FontIdxMono, 9);
              lastAlb := sAlb;
            end;

            Page.WriteText(ColCantX, Y, UTF8Encode(sCant));
            Page.WriteText(ColDescX, Y, PDFText(sDesc));

            sPUnitR := PadLeft(sPUnit, LineNumWidth);
            sDtoR   := PadLeft(sDto,   DtoWidthChars);
            sImpR   := PadLeft(sImp,   LineNumWidth);
            Page.SetFont(FontIdxMono, 9);
            Page.WriteText(ColPUnitX, Y, PDFText(sPUnitR));
            Page.WriteText(ColDtoX,   Y, PDFText(sDtoR));
            Page.WriteText(ColImpX,   Y, PDFText(sImpR));
          end;

          Y := Y + LineH;
        end;
      finally
        SL.Free;
      end;
    end;

    Y := Y + LineH * 2;

    if Y > 230 then
      StartNewFooterPage;

    // TOTALES + IVA
    sBase  := FormatEUR(AData.BaseImponible);
    sIVA   := FormatEUR(AData.ImporteIVA);
    sTotal := FormatEUR(AData.TotalFactura);

    if AData.IVAItemsCount > 0 then
    begin
      Page.SetColor(clMedGray);
      Page.DrawRect(X, Y+1, 140, LineH, 1, False, True);
      Page.SetColor(clBlack);

      Page.SetFont(FontIdxMono, 9);
      Page.WriteText(IVABaseX,  Y, UTF8Encode('Base'));
      Page.WriteText(IVATipoX,  Y, UTF8Encode('Tipo IVA'));
      Page.WriteText(IVAIVAX,   Y, UTF8Encode('IVA'));
      Page.WriteText(IVATotalX, Y, UTF8Encode('Total'));
      Y := Y + LineH;

      for j := 0 to AData.IVAItemsCount - 1 do
      begin
        Page.WriteText(IVABaseX, Y, UTF8Encode(FormatEUR(AData.IVAItems[j].BaseImponible)));
        Page.WriteText(IVATipoX, Y, UTF8Encode(FormatFloat('0.00', AData.IVAItems[j].TipoIVA) + ' %'));
        Page.WriteText(IVAIVAX,  Y, UTF8Encode(FormatEUR(AData.IVAItems[j].ImporteIVA)));
        Page.WriteText(IVATotalX,Y, UTF8Encode(FormatEUR(AData.IVAItems[j].BaseImponible + AData.IVAItems[j].ImporteIVA)));
        Y := Y + LineH;
      end;

      Y := Y + LineH;
    end;

    sBaseR  := PadLeft(sBase,  TotWidthChars);
    sIVAR   := PadLeft(sIVA,   TotWidthChars);
    sTotalR := PadLeft(sTotal, TotWidthChars);

    Page.SetFont(FontIdxMono, 10);
    Page.WriteText(TotLabelX, Y, PDFText('Base imponible:'));
    Page.WriteText(TotValueX-10, Y, PDFText(sBaseR));
    Y := Y + LineH;

    Page.WriteText(TotLabelX, Y, PDFText('IVA:'));
    Page.WriteText(TotValueX-10, Y, PDFText(sIVAR));
    Y := Y + LineH;

    Page.SetColor(clMedGray);
    Page.DrawRect(TotLabelX-2, Y+1, 85, LineH, 1, False, True);
    Page.SetColor(clBlack);

    Page.SetFont(FontIdxMono, 11);
    Page.WriteText(TotLabelX, Y, PDFText('TOTAL:'));
    Page.WriteText(TotValueX-10, Y, PDFText(sTotalR));
    Y := Y + LineH * 2;

    if Y > 260 then
      StartNewFooterPage;

    // LOPD
    Page.SetFont(FontIdxMono, 7);
    if Lopd1 <> '' then
      PDF_WriteWrappedText(Page, FontIdxMono, 7, Y, X, 100, Lopd1, LineH);

    if Lopd2 <> '' then
      PDF_WriteWrappedText(Page, FontIdxMono, 7, Y, X, 100, Lopd2, LineH);

    ForceDirectories(ExtractFileDir(AFileName));
    FLX_WriteLog('PDF', 'Guardando PDF: ' + AFileName);
    Doc.SaveToFile(AFileName);
    FLX_WriteLog('PDF', 'PDF guardado OK: ' + AFileName);

    Result := True;
  except
    on E: Exception do
    begin
      FLX_WriteLog('PDF', 'Error PDF: ' + E.Message + ' (file=' + AFileName + ')');
      ShowMessage('Error PDF: ' + E.Message);
      Result := False;
    end;
  end;

  Doc.Free;
end;

{==============================================================================}
{  Función pública principal                                                   }
{==============================================================================}

function FLX_GenerateInvoicePDF_FromDB(
  const ATienda, ASerie: string;
  ANumero: Integer;
  const AFecha: TDate;
  const ACodCliente: string;
  const AQRImageFile, ABarCodeFile: string;
  out APDFFileName: string
): Boolean;
var
  Conn   : TZConnection;
  Fact   : TFacturaData;
  Lineas : TStringList;
  OkLoad : Boolean;
  OkPDF  : Boolean;
  QRFile, BarFile, BaseDir : string;
begin
  Result := False;
  APDFFileName := '';

  Conn := CreateZConnectionFromGlobals;
  try
    Conn.Connect;
  except
    on E: Exception do
    begin
      ShowMessage('Error conexión BBDD para PDF: ' + E.Message);
      Conn.Free;
      Exit;
    end;
  end;

  Lineas := TStringList.Create;
  try
    OkLoad := FLX_LoadFacturaFromDB(
      ATienda, ASerie, ANumero,
      AFecha, ACodCliente,
      Conn, Fact, Lineas
    );

    if not OkLoad then
    begin
      Lineas.Free;
      Conn.Free;
      Exit;
    end;

    APDFFileName := BuildPDFFileName(ASerie, ANumero);

    BaseDir := IncludeTrailingPathDelimiter(ExtractFileDir(APDFFileName));

    QRFile := AQRImageFile;
    if (Trim(QRFile) = '') or (not FileExists(QRFile)) then
      QRFile := BaseDir + 'QR.png';

    BarFile := ABarCodeFile;
    if (Trim(BarFile) = '') or (not FileExists(BarFile)) then
      BarFile := BaseDir + 'barcode.png';

    OkPDF := FLX_GenerateSimpleInvoicePDF(
      APDFFileName,
      Fact,
      Lineas,
      QRFile,
      BarFile
    );

    Result := OkPDF;
  finally
    Lineas.Free;
    Conn.Free;
  end;
end;

end.
