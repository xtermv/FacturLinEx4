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
  Classes, SysUtils, DateUtils,
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

/// Genera el PDF de la factura leyendo de la BBDD y devuelve:
///   - True si OK
///   - False si hay error (se podría extender con logging)
///
/// Parámetros:
///   ATienda      -> código de tienda (para construir nombre de tabla factuc+tienda / factud+tienda)
///   ASerie       -> serie de factura (ej. 'A25', 'FS-A25', etc.)
///   ANumero      -> número de factura
///   AFecha       -> fecha de la factura (usada si la BBDD no devuelve fecha fiable)
///   ACodCliente  -> código de cliente (puede ser '' si es simplificada y no hay cliente)
///   AQRImageFile -> ruta al PNG/JPG con el QR (3x3 cm en el PDF)
///   ABarCodeFile -> ruta al PNG/JPG con el código de barras (derecha)
///
///   APDFFileName -> salida: ruta completa del PDF generado (en RutaPdf)
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
  HomeDir, Candidate1, Candidate2, FinalDir: string;
begin
  HomeDir := GetEnvironmentVariable('HOME');
  Candidate2 := IncludeTrailingPathDelimiter(HomeDir) + 'pdf' + DirectorySeparator;

  // 1) Candidato principal: lo de siempre
  if Trim(RutaPdf) <> '' then
    Candidate1 := RutaPdf
  else
    Candidate1 := IncludeTrailingPathDelimiter(GetCurrentDir) + 'pdf' + DirectorySeparator;

  // 2) Intento candidato 1
  if TryEnsureWritableDir(Candidate1, FinalDir) then
    Exit(FinalDir);

  // 3) Fallback a ~/pdf
  if TryEnsureWritableDir(Candidate2, FinalDir) then
    Exit(FinalDir);

  // 4) Último recurso: devolvemos el fallback aunque no sea escribible (evita Result vacío)
  Result := Candidate2;
end;

{ //-- Formula Original que intenta crear pdf en la carpeta del ejecutable
function EnsureRutaPdf: string;
begin
  // RutaPdf es una variable global tuya.
  // Aseguramos que no esté vacía y que exista el directorio.
  if Trim(RutaPdf) = '' then
    Result := IncludeTrailingPathDelimiter(GetCurrentDir) + 'pdf' + DirectorySeparator
  else
    Result := IncludeTrailingPathDelimiter(RutaPdf);

  if not DirectoryExists(Result) then
    ForceDirectories(Result);
end;
}

function BuildPDFFileName(const Serie: string; Numero: Integer): string;
var
  baseDir: string;
begin
  baseDir := EnsureRutaPdf;
  Result  := baseDir + Serie + '_' + IntToStr(Numero) + '.pdf';
  //--- Donde se almacena el pdf ???
  // SHOWMESSAGE(Result);
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
  //Result.ControlsCodePage := cCP_UTF8;
  //Result.AutoEncodeStrings := True;
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
  BaseLinea, IVALinea, PUnit, Cantidad, ImporteLinea: Double;
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
  
  Lopd1 := Lopd1 + Empresa;
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
  //    ADAPTAR nombres de tablas y campos según tu esquema real
  // ---------------------------------------------------------------------------
  tablaCab := 'factuc' + ATienda; // p.ej. 'factuc0000A'
  QCab := TZQuery.Create(nil);
  try
    QCab.Connection := Conn;
    QCab.SQL.Text :=
      'SELECT * FROM ' + tablaCab +
      ' WHERE FC2 = :SERIE AND FC3 = :NUMERO'; // <-- CAMBIAR FC_SERIE / FC_NUMERO a tus campos reales
    QCab.ParamByName('SERIE').AsString  := ASerie;
    QCab.ParamByName('NUMERO').AsInteger := ANumero;
    QCab.Open;

    if not QCab.IsEmpty then
    begin
      // Ejemplos de campos a adaptar:
      AData.Fecha        := QCab.FieldByName('FC1').AsDateTime;
      AData.CliCodigo    := QCab.FieldByName('FC0').AsString;
      AData.BaseImponible:= QCab.FieldByName('FC8').AsFloat;
      AData.ImporteIVA   := (QCab.FieldByName('FC9').AsFloat-QCab.FieldByName('FC8').AsFloat);
      AData.TotalFactura := QCab.FieldByName('FC9').AsFloat;

      // De momento, si no conoces los nombres exactos, dejamos estos valores
      // como venían por parámetro o a 0, y los ajustarás tú más tarde.

      if ACodCliente <> '' then
        AData.CliCodigo := ACodCliente
      else
        AData.CliCodigo := QCab.FieldByName('FC0').AsString; // aquí podrías tomarlo de la cabecera cuando sepas el campo

    end
    else
      Exit; // no existe la factura
  finally
    QCab.Free;
  end;

  // ---------------------------------------------------------------------------
  // 3) Datos de cliente: tabla clientes
  //    ADAPTAR nombres de campos según tu esquema
  // ---------------------------------------------------------------------------
  if AData.CliCodigo <> '' then
  begin
    QCli := TZQuery.Create(nil);
    try
      QCli.Connection := Conn;
      QCli.SQL.Text :=
        'SELECT * FROM clientes WHERE C0 = :COD'; // <-- CAMBIAR C_CODIGO y demás campos
      QCli.ParamByName('COD').AsString := AData.CliCodigo;
      QCli.Open;

      if not QCli.IsEmpty then
      begin
        // Ejemplos:
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
  //    ADAPTAR nombres de campos según tu esquema:
  //      - Cantidad
  //      - Descripción
  //      - Precio unitario
  //      - Importe
  //      - IVA de la línea
  // ---------------------------------------------------------------------------
  if Assigned(ALineas) then
    ALineas.Clear;

  tablaDet := 'factud' + ATienda;
  QDet := TZQuery.Create(nil);
  try
    QDet.Connection := Conn;
    QDet.SQL.Text :=
      'SELECT * FROM ' + tablaDet +
      ' WHERE FD2 = :SERIE AND FD3 = :NUMERO ' + // <-- CAMBIAR FD_SERIE / FD_NUMERO a tus campos reales
      ' ORDER BY FD4';                                  // <-- CAMBIAR FD_LINEA a tu campo de orden
    QDet.ParamByName('SERIE').AsString   := ASerie;
    QDet.ParamByName('NUMERO').AsInteger := ANumero;
    QDet.Open;

    while not QDet.EOF do
    begin
      // Ejemplos de nombres de campos a adaptar:
      Cantidad     := QDet.FieldByName('FD7').AsFloat;
      lineaDesc    := QDet.FieldByName('FD6').AsString;
      PUnit        := QDet.FieldByName('FD8').AsFloat;
      ImporteLinea := QDet.FieldByName('FD11').AsFloat;
      TipIva       := QDet.FieldByName('FD12').AsFloat; //-- El campo es el tipo de IVA ya que el importe no se almacena
      //IVALinea     := (QDet.FieldByName('FD11').AsFloat * (TipIva/100));
      // Suponemos que FD11 es BASE sin IVA
      BaseLinea := ImporteLinea;
      IVALinea  := BaseLinea * (TipIva / 100.0);
      // De momento, ponemos valores ficticios para que compiles y luego los adaptas:
      // Cantidad     := 1.0;
      // lineaDesc    := QDet.FieldByName(QDet.Fields[0].FieldName).AsString; // solo como placeholder
      // PUnit        := 0.0;
      // ImporteLinea := 0.0;
      // IVALinea     := 0.0;
      // --- Multi-IVA: acumular base y cuota por tipo ---
      if TipIva > 0 then
      begin
        found := False;
        // Buscar si ya tenemos este tipo de IVA en el array
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

        // Si no estaba y aún hay hueco, creamos entrada nueva
        if (not found) and (AData.IVAItemsCount < 3) then
        begin
          AData.IVAItems[AData.IVAItemsCount].TipoIVA       := TipIva;
          AData.IVAItems[AData.IVAItemsCount].BaseImponible := BaseLinea;
          AData.IVAItems[AData.IVAItemsCount].ImporteIVA    := IVALinea;
          Inc(AData.IVAItemsCount);
        end;
      end;
      {
      if Assigned(ALineas) then
      begin
     '%4.2f' → campo cantidad (puedes subir a 6.2f si se queda estrecho).
     '%-40s' → descripción (más o menos caracteres visibles).
     '%10s' → precio y total (ancho total del campo, incluyendo espacios a la izquierda para alinear a la derecha con Courier).
        ALineas.Add(
          Format('%4.2f  %-40s  %10s  %10s',
            [Cantidad, lineaDesc, FormatEUR(PUnit), FormatEUR(ImporteLinea)])
        );
      end;
    }
    //-- Nuevo sistema de Generacion de líneas para evitar el desfase en la creación de las mismas
      //-- Nuevo sistema de Generacion de líneas ...
      if Assigned(ALineas) then
      begin
        albaranText := QDet.FieldByName('FD16').AsString;

        // Guardamos los 4 campos + el albarán separados por |
        ALineas.Add(
          FormatFloat('0.00', Cantidad) + '|' +
          lineaDesc + '|' +
          FormatEUR(PUnit) + '|' +
          FormatEUR(ImporteLinea) + '|' +
          albaranText
        );
      end;
    
      // Aquí podrías acumular bases y cuotas por tipo de IVA para AData.IVAItems[]
      // usando tus IVA1, IVA2, IVA3. De momento lo dejamos en blanco.

      QDet.Next;
    end;
  finally
    QDet.Free;
  end;

  // Si has cargado BaseImponible / ImporteIVA / TotalFactura desde la cabecera,
  // puede haber pequeñas diferencias de redondeo con el desglose de IVA.
  // aquí ya deberían estar correctos. Si no, podrías recalcularlos a partir
  // de las líneas.
  // Para que el PDF cuadre EXACTAMENTE con el cuadro de IVAs, recalculamos
  // los totales a partir de AData.IVAItems[].
  // Ajustamos ImporteIVA a la suma de los IVAItems (por si acaso)
  if AData.IVAItemsCount > 0 then
  begin
    AData.ImporteIVA := 0;
    for j := 0 to AData.IVAItemsCount - 1 do
      AData.ImporteIVA := AData.ImporteIVA + AData.IVAItems[j].ImporteIVA;
  end;
//============================
//--- Recalculo de Totales ---
    for I := 0 to AData.IVAItemsCount - 1 do
    begin
      // Redondeamos cada grupo al mismo criterio que se muestra en pantalla (2 decimales)
      BaseRedondeada := Round(AData.IVAItems[I].BaseImponible * 100) / 100;
      IVARedondeado  := Round(AData.IVAItems[I].ImporteIVA    * 100) / 100;

      // Acumulamos *los valores ya redondeados*
      SumBaseMostrada := SumBaseMostrada + BaseRedondeada;
      SumIVAMostrada  := SumIVAMostrada  + IVARedondeado;

      // Por coherencia, opcionalmente dejamos también redondeados los propios IVAItems:
      AData.IVAItems[I].BaseImponible := BaseRedondeada;
      AData.IVAItems[I].ImporteIVA    := IVARedondeado;
    end;

    // Redondeamos a 2 decimales para evitar cosas tipo 12.339999999
    // Totales globales: sumas de lo mostrado ya redondeado
    AData.BaseImponible := Round(SumBaseMostrada * 100) / 100;
    AData.ImporteIVA    := Round(SumIVAMostrada  * 100) / 100;
    AData.TotalFactura  := AData.BaseImponible + AData.ImporteIVA;
//--- FIN Recalculo de Totales
//============================
  Result := True;
end;

//-- Procedimiento de conversión de texto para corregir acentos etc
//-- Convierte de Utf-8 a ISO-8859-1/cp1252 que es lo que maneja fppdf
function PDFText(const S: string) : string;
begin
    // Para Español / acentos típicos esto va perfecto
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
  const AMaxWidthChars: Integer;  // nº máximo de caracteres por línea (con Courier)
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
    // Separamos en palabras
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
        // ¿Cabe la palabra + espacio en la línea actual?
        if Length(CurrentLine) + 1 + Length(WordStr) <= AMaxWidthChars then
          CurrentLine := CurrentLine + ' ' + WordStr
        else
        begin
          // Imprimimos la línea actual y empezamos una nueva
          APDF.WriteText(AX, AY, PDFText(CurrentLine));
          AY := AY + ALineH;
          CurrentLine := WordStr;
        end;
      end;
    end;

    // Última línea pendiente
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
  Section  : TPDFSection;   // <--- AÑADIR ESTA LÍNEA
  FontIdx, FontIdxMono  : Integer;
  X, Y     : TPDFFloat;
  LineH    : TPDFFloat;
  I,j      : Integer;
  FacturaStr, FechaStr: string;
  pageNumber, totalPages: Integer;
  timeStampStr, codeText: string;
  LogoImgId, QRImgId, BarImgId: Integer;  // <<--- AÑADIR ESTO
  sBase, sIVA, sTotal: String; //-- PARA EL AJUSTE DE LOS TOTALES DE FACTURA
  sBaseR, sIVAR, sTotalR: String; //-- PARA EL AJUSTE DE LOS TOTALES DE FACTURA
  //-- Variables para las lineas de detalle de las facturas
  S: String;
  SL: TStringList;
  sCant, sDesc, sPUnit, sImp, sAlb, lastAlb: String;
  sPUnitR, sImpR: string;
const
  //== Números más grandes a la Derecha, números más pequeños a la Izquierda
  TotLabelX = 120.0;  // X de las etiquetas de Texto (posición Horizontal)
  TotValueX = 180.0;  // X aproximado de los valores de los campos de las variables ajustadas
  //-- Constantes para las líneas de detalle de las Facturas
  ColCantX  = 15.0;        // misma X que la cabecera "Cant."
  ColDescX  = 30.0;        // misma X que "Descripción"
  ColPUnitX = 135.0;       // ajusta para que caiga bajo "P.Unit"
  ColImpX   = 165.0;       // ajusta para que caiga bajo "Importe"

  LineNumWidth = 12;
  // -- Constantes para la tabla de desglose de IVA
  IVABaseX  = 20.0;   // columna "Base"
  IVATipoX  = 55.0;   // columna "Tipo IVA"
  IVAIVAX   = 90.0;   // columna "IVA"
  IVATotalX = 120.0;   // columna "Total"

  TotWidthChars = 14;  //-- Podemos probar entre 10 y 14 a ver cual nos gusta más
  
  // ---------- PÁGINAS NUEVAS ----------

  procedure StartNewDetailPage;
  begin
    // Nueva página para líneas de detalle
    Page := Doc.Pages.AddPage;
    Section.AddPage(Page);

    Page.PaperType     := ptA4;
    Page.UnitOfMeasure := uomMillimeters;

    // Margen superior y fuente
    X     := 15;
    Y     := 40;   // un poco por debajo del borde
    LineH := 5;

    // Cabecera de columnas de líneas
    Page.SetFont(FontIdx, 9);
    Page.WriteText(X,       Y, UTF8Encode('Cant.'));
    Page.WriteText(X+15.0,  Y, UTF8Encode('Descripcion'));
    Page.WriteText(X+120.0, Y, UTF8Encode('P.Unit'));
    Page.WriteText(X+145.0, Y, UTF8Encode('Importe'));
    Y := Y + LineH;
    Y := Y + LineH / 2;

    // Fuente monoespaciada para los datos
    Page.SetFont(FontIdxMono, 9);
  end;

  procedure StartNewFooterPage;
  begin
    // Nueva página para totales / LOPD
    Page := Doc.Pages.AddPage;
    Section.AddPage(Page);

    Page.PaperType     := ptA4;
    Page.UnitOfMeasure := uomMillimeters;

    X     := 15;
    Y     := 40;
    LineH := 5;

    Page.SetFont(FontIdxMono, 9);
  end;
  //===========================================
  //====== INICIO REAL DE LA FUNCIÓN ==========
  //===========================================
begin
  Result := False;

  Doc := TPDFDocument.Create(nil);
  try
    Doc.Options := Doc.Options + [poPageOriginAtTop];
    Doc.DefaultPaperType := ptA4;

    FacturaStr := Format('%s-%d', [AData.Serie, AData.Numero]);
    Doc.Infos.Title := 'Factura ' + FacturaStr;

    // === INICIO: creación correcta de la página con fppdf ===
    Doc.StartDocument;                          // Inicia el documento PDF
    Section := Doc.Sections.AddSection;         // Crea una sección
    Page := Doc.Pages.AddPage;                  // Crea una página
    Section.AddPage(Page);                      // Añade la página a la sección

    Page.PaperType := ptA4;                     // A4
    Page.UnitOfMeasure := uomMillimeters;       // Trabajar en mm
    // === FIN: creación de la página ===

    FontIdx := Doc.AddFont('Helvetica');
    FontIdxMono := Doc.AddFont('Courier');    // <--- Fuente monoespaciada
    Page.SetFont(FontIdx, 10);

    X     := 15;  // margen izquierdo
    Y     := 15;  // arriba
    LineH := 5;   // 5 mm por línea

    // ----------------------
    // CABECERA: LOGO + QR + BARCODE
    // ----------------------

    // LOGO (arriba izquierda)
    if (Trim(LogoEmpresa) <> '') and FileExists(LogoEmpresa) then
    begin
      LogoImgId := Doc.Images.AddFromFile(LogoEmpresa, False);
      Page.DrawImage(
        15, 40,    // X, Y en mm
        40, 20,    // ancho, alto en mm
        LogoImgId  // ID de la imagen en el documento
      );
    end;

//==== Insertamos la leyenda QR Tributario : en la parte superior del QR
    if (Trim(AQRImageFile) <> '') and FileExists(AQRImageFile) then
    begin
        Page.WriteText(94, 8, PDFText(LeyendaSuperiorQR));
        Y := Y + LineH;
    end;

    // QR (centrado) - 3x3 cm = 30x30 mm
    if (Trim(AQRImageFile) <> '') and FileExists(AQRImageFile) then
    begin
      QRImgId := Doc.Images.AddFromFile(AQRImageFile, False);
      Page.DrawImage(
        90, 40,   // X, Y
        30, 30,   // ancho, alto
        QRImgId
      );
    end;

//==== Insertamos la leyenda Veri*Factu bajo el QR
    if (Trim(AQRImageFile) <> '') and FileExists(AQRImageFile) then
    begin
        Page.WriteText(96, 44, PDFText(LeyendaInferiorQR));
        Y := Y + LineH;
    end;

    // BARCODE (derecha)
    if (Trim(ABarCodeFile) <> '') and FileExists(ABarCodeFile) then
    begin
      BarImgId := Doc.Images.AddFromFile(ABarCodeFile, False);
      Page.DrawImage(
        150, 30,  // X, Y (X centra la imágen en la hoja de forma horizontal, mientras que Y dictamina la altura a la que aparece)
        40, 20,   // ancho, alto (datos de la imágen)
        BarImgId
      );
    end;

    // Texto debajo del barcode:
    pageNumber  := 1;
    totalPages  := 1; // TODO: si en el futuro haces multi-página, actualiza esto
    timeStampStr := FormatDateTime('yyyymmddhhnnss', Now);
    codeText     := Format('%d%s%d', [pageNumber, timeStampStr, totalPages]);

    Page.SetFont(FontIdx, 8);
    Page.WriteText(150, 35, UTF8Encode(codeText));

    // Ajustamos Y para el resto de contenido
    Y := 45;

    // ----------------------
    // DATOS EMPRESA
    // ----------------------
    Page.SetFont(FontIdx, 12);
    Page.WriteText(X, Y, PDFText(AData.EmpNombre));
    Y := Y + LineH;
    Page.SetFont(FontIdx, 9);
    Page.WriteText(X, Y, UTF8Encode('NIF: ' + AData.EmpNIF));
    Y := Y + LineH;
    Page.WriteText(X, Y, PDFText(
      AData.EmpDireccion + ' - ' + AData.EmpCP + ' ' + AData.EmpLocalidad));
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

    // ----------------------
    // DATOS FACTURA
    // ----------------------
    FechaStr := FormatDateTime('dd/mm/yyyy', AData.Fecha);
    Page.SetFont(FontIdx, 11);
    Page.WriteText(X, Y, UTF8Encode('FACTURA ' + FacturaStr));
    Y := Y + LineH;
    Page.SetFont(FontIdx, 9);
    Page.WriteText(X, Y, UTF8Encode('Fecha: ' + FechaStr));
    Y := Y + LineH * 2;

    // ----------------------
    // DATOS CLIENTE (si los hay)
    // ----------------------
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
        Page.WriteText(X, Y, UTF8Encode(
          AData.CliDireccion + ' - ' + AData.CliCP + ' ' + AData.CliLocalidad));
        Y := Y + LineH;
      end;
      if AData.CliProvincia <> '' then
      begin
        Page.WriteText(X, Y, UTF8Encode(AData.CliProvincia));
        Y := Y + LineH;
      end;
      Y := Y + LineH;
    end;

    // ----------------------
    // CABECERA DE LÍNEAS (SOMBREADA)
    // ----------------------
    { -- PARECE SER QUE ESTAS FUNCIONES NO EXISTEN EN ESTA LIBRERÍA
    Page.SetGrayFill(0.90); //-- 0.0 negro | 1.0 blanco - 0.90 gris claro
    Page.DrawRect(X, Y-1, 180, LineH+1, True);  // X, Y, ancho, alto, RELLENO
    Page.SetGrayFill(0.0);  //-- Devolvemos el color standard para el texto
    }
    //-- DrawRect(X, Y, Width, Height, LineWidth, AStroke, AFill);
    Page.SetColor(clMedGray);                // gis claro de relleno
    Page.DrawRect(X, Y+1, 180, LineH,     // X, Y, ancho, alto
                  1,                      // grosor de línea (pequeño)
                  False,                    // no dibujar borde
                  True);                    // rellenar rectángulo
    Page.SetColor(clBlack);                 // volvemos al negro original para el texto
    Page.SetFont(FontIdx, 9);
    Page.WriteText(X,       Y, UTF8Encode('Cant.'));
    Page.WriteText(X+15.0,  Y, PDFText('Descripcion'));
    Page.WriteText(X+120.0, Y, UTF8Encode('P.Unit'));
    Page.WriteText(X+145.0, Y, UTF8Encode('Importe'));
    Y := Y + LineH;
    Y := Y + LineH / 2;

    // ----------------------
    // LÍNEAS
    // ----------------------
    lastAlb := '';
    Page.SetFont(FontIdxMono, 9); //-- Aqui usamos COURIER Monoespaciada para que NO descuadren los valores en la factura
    if Assigned(Lineas) then
    begin
     SL := TstringList.Create;
     try
      SL.Delimiter := '|';
      SL.StrictDelimiter := True;
      for I := 0 to Lineas.Count - 1 do
      begin
        if Y > 260 then
        begin
          // Si en algún momento quieres multi-página seria aquí donde:
          //   - Creas nueva página
          //   - Repites cabecera de columnas
          //   - Incrementas pageNumber / totalPages
          // De momento asumimos que caben en una página.
          // ----------------------
          // CABECERA DE LÍNEAS
          // ----------------------
          StartNewDetailPage;   // 👈 nueva página de detalle
          {
          Page.SetFont(FontIdx, 9);
          Page.WriteText(X,       Y, UTF8Encode('Cant.'));
          Page.WriteText(X+15.0,  Y, UTF8Encode('Descripción'));
          Page.WriteText(X+120.0, Y, UTF8Encode('P.Unit'));
          Page.WriteText(X+145.0, Y, UTF8Encode('Importe'));
          Y := Y + LineH;
          Y := Y + LineH / 2;
          pageNumber := pageNumber +1;
          totalPages := totalPages +1;
          Break;
          }
        end;
        S := Lineas[I];
        SL.DelimitedText := S;
        //-- Vamos a trabajar con 4 campos : Cant | Desc | PUnit | Importe | Albaran (Opcional)
        if SL.Count>=4 then
        begin
          sCant	:=SL[0];
          sDesc	:=SL[1];
          SPUnit:=SL[2];
          sImp	:=SL[3];
          
          if SL.Count >= 5 then
            sAlb := SL[4]
          else
            sAlb := '';

          // Si hay texto de albarán y empieza por "Albaran.: " y cambia, lo imprimimos UNA sola vez
          if (sAlb <> '') and (Pos('Albaran.:', sAlb) = 1) and (sAlb <> lastAlb) then
          begin
            // Cabecera de albarán en fuente normal
            // Page.SetFont(FontIdx, 8); // --  Pasamos todo a fuente monoespaciada para ver si justifica correctamente
            Page.SetFont(FontIdx, 8);
            Page.WriteText(ColDescX, Y, UTF8Encode(sAlb));
            Y := Y + LineH;
            // Volvemos a Courier para las líneas
            Page.SetFont(FontIdxMono, 9);
            lastAlb := sAlb;
          end;
          // Ahora la línea de detalle
          Page.WriteText(ColCantX, Y, UTF8Encode(sCant));
          Page.WriteText(ColDescX, Y, PDFText(sDesc));

          //===== PRUEBAS DE FORMATEO A LA DERECHA
          sPUnitR := PadLeft(sPUnit, LineNumWidth);
          sImpR   := PadLeft(sImp,   LineNumWidth);
          Page.SetFont(FontIdxMono, 9);
          // Page.WriteText(ColPUnitX, Y, UTF8Encode(sPUnit));
          Page.WriteText(ColPUnitX, Y, PDFText(sPUnitR)); // PRUEBA DE FORMATEO DE POSICION
          // Page.WriteText(ColImpX, Y, UTF8Encode(sImp));
          Page.WriteText(ColImpX, Y, PDFText(sImpR)); // PRUEBA DE FORMATEO DE POSICION
        end;
        Y := Y + LineH;
      end;
    finally
      SL.Free;
    end;
  end;

    Y := Y + LineH * 2;
    
    // Si no hay espacio razonable para tabla de IVA + totales, nueva página
    if Y > 230 then
      StartNewFooterPage;


    // ----------------------
    // TOTALES + DESGLOSE IVA EN TABLA
    // ----------------------
    sBase  := FormatEUR(AData.BaseImponible);
    sIVA   := FormatEUR(AData.ImporteIVA);
    sTotal := FormatEUR(AData.TotalFactura);

    // Desglose por tipo de IVA (si lo hay)
    if AData.IVAItemsCount > 0 then
    begin
    //-- Relleno fondo Cabecera Detalle Ivas
    { NO FUNCIONA EN ESTA VERSIÓN DE fppdf
      Page.SetGrayFill(0.90); //-- 0.0 negro | 1.0 blanco - 0.90 gris claro
      Page.DrawRect(X, Y-1, 180, LineH+1, True);  // X, Y, ancho, alto, RELLENO
      Page.SetGrayFill(0.0);  //-- Devolvemos el color standard para el texto
    }
    Page.SetColor(clMedGray);
    Page.DrawRect(X, Y+1, 140, LineH,
                  1,
                  False,
                  True);

    Page.SetColor(clBlack);
    //-- Relleno fondo Cabecera Detalle Ivas
    
      Page.SetFont(FontIdxMono, 9);

      // Cabecera de la tabla de IVA
      Page.WriteText(IVABaseX,  Y, UTF8Encode('Base'));
      Page.WriteText(IVATipoX,  Y, UTF8Encode('Tipo IVA'));
      Page.WriteText(IVAIVAX,   Y, UTF8Encode('IVA'));
      Page.WriteText(IVATotalX, Y, UTF8Encode('Total'));
      Y := Y + LineH;

      // (Opcional) una línea separadora hecha a base de guiones
      { COMENTADO POR ENCUADRE DE LÍNEA DE TRABAJO
      Page.WriteText(IVABaseX, Y, UTF8Encode('------------------------------------------------------------'));
      Y := Y + LineH;
      }

      // Filas por cada tipo de IVA
      for j := 0 to AData.IVAItemsCount - 1 do
      begin
        // Cálculos por tipo
        // Base = BaseImponible, IVA = ImporteIVA, Total = Base + IVA
        Page.WriteText(
          IVABaseX,
          Y,
          UTF8Encode(FormatEUR(AData.IVAItems[j].BaseImponible))
        );

        Page.WriteText(
          IVATipoX,
          Y,
          UTF8Encode(FormatFloat('0.00', AData.IVAItems[j].TipoIVA) + ' %')
        );

        Page.WriteText(
          IVAIVAX,
          Y,
          UTF8Encode(FormatEUR(AData.IVAItems[j].ImporteIVA))
        );

        Page.WriteText(
          IVATotalX,
          Y,
          UTF8Encode(
            FormatEUR(
              AData.IVAItems[j].BaseImponible + AData.IVAItems[j].ImporteIVA
            )
          )
        );

        Y := Y + LineH;
      end;

      Y := Y + LineH; // pequeño hueco antes de los totales generales
    end;


    //==== FORMATEAR TOTALES GENERALES ======
    sBaseR  := PadLeft(sBase,  TotWidthChars);
    sIVAR   := PadLeft(sIVA,   TotWidthChars);
    sTotalR := PadLeft(sTotal, TotWidthChars);


    // Totales generales
    Page.SetFont(FontIdxMono, 10);
    //Page.WriteText(TotLabelX, Y, UTF8Encode('Base imponible:'));
    //Page.WriteText(TotValueX-10, Y, UTF8Encode(sBase));
    Page.WriteText(TotLabelX, Y, PDFText('Base imponible:'));
    Page.WriteText(TotValueX-10, Y, PDFText(sBaseR));
    Y := Y + LineH;

    //Page.WriteText(TotLabelX, Y, UTF8Encode('IVA:'));
    //Page.WriteText(TotValueX-10, Y, UTF8Encode(sIVA));
    Page.WriteText(TotLabelX, Y, PDFText('IVA:'));
    Page.WriteText(TotValueX-10, Y, PDFText(sIVAR));
    Y := Y + LineH;

    //-- SOMBREADO TOTAL
    { NO FUNCIONA EN ESTA VERSIÓN DE fppdf
    Page.SetGrayFill(0.90); //-- 0.0 negro | 1.0 blanco - 0.90 gris claro
    Page.DrawRect(TotLabelX-2, Y-1, 70, LineH+1, True);  // X, Y, ancho, alto, RELLENO
    Page.SetGrayFill(0.0);  //-- Devolvemos el color standard para el texto
    }
    Page.SetColor(clMedGray);
    Page.DrawRect(TotLabelX-2, Y+1, 85, LineH,
                  1,
                  False,
                  True);
    Page.SetColor(clBlack);
    //-- FIN Relleno fondo TOTAL
    Page.SetFont(FontIdxMono, 11);
    //Page.WriteText(TotLabelX, Y, UTF8Encode('TOTAL:'));
    //Page.WriteText(TotValueX-10, Y, UTF8Encode(sTotal));
    Page.WriteText(TotLabelX, Y, PDFText('TOTAL:'));
    Page.WriteText(TotValueX-10, Y, PDFText(sTotalR));

    Y := Y + LineH * 2;


    // Si estamos muy abajo, ponemos la LOPD en página nueva
    if Y > 260 then
      StartNewFooterPage;
    // ----------------------
    // LOPD (avisos legales)
    // ----------------------
    Page.SetFont(FontIdxMono, 7); //-- Lo ajustamos a COURIER Monoespaciada para el ajuste de línea automático
    if Lopd1 <> '' then
    begin
{
      Page.WriteText(X, Y, UTF8Encode(Lopd1));
      Y := Y + LineH;
}
     //--Prueba de ajuste de línea automático
     PDF_WriteWrappedText(Page, FontIdxMono, 7, Y, X, 100, Lopd1, LineH); //-- La Y baja automáticameten cada línea, la X columna Izqda.y el 80 max caracteres por línea, mientras que LineH ajusta la altura entre líneas

    end;
    if Lopd2 <> '' then
    begin

      //-- Page.WriteText(X, Y, UTF8Encode(Lopd2));
      //-- Y := Y + LineH;
      PDF_WriteWrappedText(Page, FontIdxMono, 7, Y, X, 100, Lopd2, LineH);

    end;

    // Guardar fichero
    ForceDirectories(ExtractFileDir(AFileName));
    Doc.SaveToFile(AFileName);

    Result := True;
  except
    on E: Exception do
    begin
      // Aquí puedes integrar tu sistema de logs:
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
    
    // --- Asegurar que QR/Barcode apunten a la misma carpeta “efectiva” del PDF ---
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
