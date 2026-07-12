unit uFLX_PedidoProveedorVentasPDF;

{$mode objfpc}{$H+}

{
  uPedidoProveedorVentasPDF.pas

  Genera un PDF imprimible con articulos vendidos en un periodo que hayan sido
  comprados alguna vez a un proveedor.

  Tablas usadas:
    proveedores
    artitien + tienda
    hisopdd + tienda
    ultimopedi + tienda
    eans

  Prioridad para reconocer el articulo vendido en hisopdd:
    1) HOD6 = codigo principal A0
    2) HOD6 = EAN0 y EAN1 apunta al articulo principal

  Articulo considerado del proveedor si:
    1) artitien.A32 = proveedor
    2) existe alguna linea en ultimopedi.AP2 = proveedor para ese articulo

  No crea pedido real. Solo genera PDF y, opcionalmente, lo envia a CUPS con lp.
}

interface

uses
  Classes, SysUtils, DateUtils, DB, ZConnection, ZDataset, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, EditBtn, ExtCtrls;

type
  TPedidoProvOrden = (
    ppoCodigo,
    ppoDescripcion,
    ppoVendidas,
    ppoCoste,
    ppoPVP,
    ppoIVA,
    ppoStock,
    ppoComprasUltPedido
  );

  TPedidoProvOrdenDir = (
    podAsc,
    podDesc
  );

  TPedidoProvFamiliaFiltro = (
    pffTodas,
    pffSoloFamilias,
    pffExcluirFamilias
  );

  TPedidoProvResultado = record
    ArchivoPDF: string;
    Lineas: Integer;
    TotalVendidas: Double;
  end;

function GenerarPedidoProveedorVentasPDF(
  AConnection: TZConnection;
  const ATienda: string;
  ACodProveedor: Integer;
  AFechaIni, AFechaFin: TDateTime;
  AOrden: TPedidoProvOrden;
  AOrdenDir: TPedidoProvOrdenDir;
  const ARutaPDF: string;
  AImprimir: Boolean = False;
  const AImpresora: string = '';
  AAbrirPDF: Boolean = True;
  AFamiliaFiltro: TPedidoProvFamiliaFiltro = pffTodas;
  const AFamilias: string = '';
  AAutorFiltro: Integer = 0;
  const AAutorNombre: string = ''
): TPedidoProvResultado;

function PedidoProvOrdenCaption(AOrden: TPedidoProvOrden): string;

procedure ShowFormFLXPedidoProveedorVentas(
  AOwner: TComponent;
  AConnection: TZConnection;
  const ATienda: string;
  const ARutaPDF: string
);

implementation

uses
  Process, Math;

const
  FLX_PEDPROVVENTASPDF_VERSION = '2026-07-10-v12-FILTRO-AUTOR-FABRICANTE';

  PDF_PAGE_W = 595.28;  // A4 vertical en puntos
  PDF_PAGE_H = 841.89;
  PDF_MARGIN_LEFT = 25.0;
  PDF_MARGIN_RIGHT = 25.0;

type
  TAnsiStringDynArray = array of AnsiString;

  TPedidoProvRow = record
    Codigo: string;
    Descripcion: string;
    Vendidas: Double;
    Coste: Double;
    PVP: Double;
    IVA: Integer;
    Stock: Double;
    ComprasUltPedido: Double;
  end;

  TPedidoProvRows = array of TPedidoProvRow;

function PedidoProvOrdenCaption(AOrden: TPedidoProvOrden): string;
begin
  case AOrden of
    ppoCodigo: Result := 'Codigo';
    ppoDescripcion: Result := 'Descripcion';
    ppoVendidas: Result := 'Udes vendidas';
    ppoCoste: Result := 'Coste';
    ppoPVP: Result := 'PVP';
    ppoIVA: Result := 'IVA';
    ppoStock: Result := 'Stock';
    ppoComprasUltPedido: Result := 'Compras ultimo pedido';
  else
    Result := 'Codigo';
  end;
end;

function CleanTiendaSuffix(const ATienda: string): string;
var
  I: Integer;
  S: string;
begin
  S := Trim(ATienda);

  // Permite que por error le pasemos "artitien0000" y se queda con "0000".
  if Pos('artitien', LowerCase(S)) = 1 then
    Delete(S, 1, Length('artitien'));

  if S = '' then
    S := '0000';

  for I := 1 to Length(S) do
    if not (S[I] in ['0'..'9', 'A'..'Z', 'a'..'z', '_']) then
      raise Exception.CreateFmt('Sufijo de tienda no valido: "%s"', [ATienda]);

  Result := S;
end;

function QTable(const ABase, ASuffix: string): string;
begin
  Result := '`' + ABase + ASuffix + '`';
end;

function OrderBySQL(AOrden: TPedidoProvOrden; ADir: TPedidoProvOrdenDir): string;
var
  Campo: string;
  Dir: string;
begin
  case AOrden of
    ppoCodigo: Campo := 'Codigo';
    ppoDescripcion: Campo := 'Descripcion';
    ppoVendidas: Campo := 'Vendidas';
    ppoCoste: Campo := 'Coste';
    ppoPVP: Campo := 'PVP';
    ppoIVA: Campo := 'IVA';
    ppoStock: Campo := 'Stock';
    ppoComprasUltPedido: Campo := 'ComprasUltPedido';
  else
    Campo := 'Codigo';
  end;

  if ADir = podDesc then
    Dir := ' DESC'
  else
    Dir := ' ASC';

  // Segundo criterio estable para que el listado no baile.
  if Campo = 'Descripcion' then
    Result := Campo + Dir + ', Codigo ASC'
  else
    Result := Campo + Dir + ', Descripcion ASC, Codigo ASC';
end;

function DefaultPDFName(ACodProveedor: Integer; AFechaIni, AFechaFin: TDateTime): string;
begin
  Result :=
    'pedido_ventas_proveedor_' +
    IntToStr(ACodProveedor) + '_' +
    FormatDateTime('yyyymmdd', AFechaIni) + '_' +
    FormatDateTime('yyyymmdd', AFechaFin) + '.pdf';
end;

function ResolvePDFFileName(const ARutaPDF: string; ACodProveedor: Integer; AFechaIni, AFechaFin: TDateTime): string;
var
  Ruta: string;
begin
  if SameText(ExtractFileExt(ARutaPDF), '.pdf') then
  begin
    Result := ARutaPDF;
    Ruta := ExtractFilePath(Result);
    if (Ruta <> '') and (not DirectoryExists(Ruta)) then
      ForceDirectories(Ruta);
    Exit;
  end;

  Ruta := Trim(ARutaPDF);
  if Ruta = '' then
    Ruta := IncludeTrailingPathDelimiter(GetUserDir) + 'pdf';

  if not DirectoryExists(Ruta) then
    ForceDirectories(Ruta);

  Result := IncludeTrailingPathDelimiter(Ruta) + DefaultPDFName(ACodProveedor, AFechaIni, AFechaFin);
end;

function LoadProveedorNombre(AConnection: TZConnection; ACodProveedor: Integer): string;
var
  Q: TZQuery;
begin
  Result := '';
  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.SQL.Text := 'SELECT P1 FROM `proveedores` WHERE P0 = :P0 LIMIT 1';
    Q.ParamByName('P0').AsInteger := ACodProveedor;
    Q.Open;
    if not Q.EOF then
      Result := Trim(Q.FieldByName('P1').AsString);
  finally
    Q.Free;
  end;

  if Result = '' then
    Result := 'Proveedor ' + IntToStr(ACodProveedor);
end;


function CleanFamiliaList(const AFamilias: string): string;
var
  I: Integer;
  Token: string;

  procedure AddToken;
  var
    V: Integer;
  begin
    if Token = '' then Exit;
    V := StrToIntDef(Token, 0);
    if Token <> '' then
    begin
      if Result <> '' then
        Result := Result + ',';
      Result := Result + IntToStr(V);
    end;
    Token := '';
  end;

begin
  Result := '';
  Token := '';

  for I := 1 to Length(AFamilias) do
  begin
    if AFamilias[I] in ['0'..'9'] then
      Token := Token + AFamilias[I]
    else
      AddToken;
  end;

  AddToken;
end;

function FamiliaFiltroCaption(AFiltro: TPedidoProvFamiliaFiltro; const AFamilias: string): string;
var
  Lista: string;
begin
  Lista := CleanFamiliaList(AFamilias);

  case AFiltro of
    pffSoloFamilias:
      if Lista <> '' then
        Result := 'Solo familias: ' + Lista
      else
        Result := 'Todas las familias';
    pffExcluirFamilias:
      if Lista <> '' then
        Result := 'Excluidas familias: ' + Lista
      else
        Result := 'Todas las familias';
  else
    Result := 'Todas las familias';
  end;
end;

function AutorFiltroCaption(AAutorFiltro: Integer; const AAutorNombre: string): string;
begin
  if AAutorFiltro > 0 then
  begin
    if Trim(AAutorNombre) <> '' then
      Result := IntToStr(AAutorFiltro) + ' - ' + Trim(AAutorNombre)
    else
      Result := IntToStr(AAutorFiltro);
  end
  else
    Result := 'Todos';
end;

function FiltrosWhereSQL(AFiltro: TPedidoProvFamiliaFiltro; const AFamilias: string; AAutorFiltro: Integer): string;
var
  Lista: string;
  Conds: string;

  procedure AddCond(const ACond: string);
  begin
    if Trim(ACond) = '' then
      Exit;

    if Conds <> '' then
      Conds := Conds + ' AND ';
    Conds := Conds + '(' + ACond + ')';
  end;

begin
  Result := '';
  Conds := '';
  Lista := CleanFamiliaList(AFamilias);

  if AFiltro <> pffTodas then
  begin
    if Lista = '' then
      raise Exception.Create('Debe indicar una o varias familias. Ejemplo: 0, 58 o 58,59');

    case AFiltro of
      pffSoloFamilias:
        AddCond('COALESCE(A.A14, 0) IN (' + Lista + ')');
      pffExcluirFamilias:
        AddCond('COALESCE(A.A14, 0) NOT IN (' + Lista + ')');
    end;
  end;

  if AAutorFiltro > 0 then
    AddCond('COALESCE(A.A20, 0) = :AUT');

  if Conds <> '' then
    Result := 'WHERE ' + Conds + ' ' + LineEnding;
end;

function CmpExpr(const AExpr: string): string;
begin
  // Normaliza comparaciones de codigos para evitar errores 1267 por mezcla de collations.
  Result := 'CONVERT(' + AExpr + ' USING utf8mb4) COLLATE utf8mb4_spanish_ci';
end;

function BuildFinalSQL(
  const ASuffix: string;
  AOrden: TPedidoProvOrden;
  AOrdenDir: TPedidoProvOrdenDir;
  AFamiliaFiltro: TPedidoProvFamiliaFiltro;
  const AFamilias: string;
  AAutorFiltro: Integer
): string;
var
  TArt: string;
  TUlt: string;
begin
  TArt := QTable('artitien', ASuffix);
  TUlt := QTable('ultimopedi', ASuffix);

  Result :=
    'SELECT ' + LineEnding +
    '  A.A0 AS Codigo, ' + LineEnding +
    '  A.A1 AS Descripcion, ' + LineEnding +
    '  VA.Vendidas AS Vendidas, ' + LineEnding +
    '  COALESCE(NULLIF(A.A24, 0), ' + LineEnding +
    '    (SELECT Uc.AP4 FROM ' + TUlt + ' Uc ' + LineEnding +
    '     WHERE ' + CmpExpr('Uc.AP0') + ' = VA.CodigoArt AND Uc.AP2 = :PROV ' + LineEnding +
    '     ORDER BY Uc.AP1 DESC LIMIT 1), 0) AS Coste, ' + LineEnding +
    '  COALESCE(A.A2, 0) AS PVP, ' + LineEnding +
    '  COALESCE(A.A3, 0) AS IVA, ' + LineEnding +
    '  COALESCE(A.A4, 0) AS Stock, ' + LineEnding +
    '  COALESCE((' + LineEnding +
    '    SELECT Up.AP3 FROM ' + TUlt + ' Up ' + LineEnding +
    '    WHERE ' + CmpExpr('Up.AP0') + ' = VA.CodigoArt ' + LineEnding +
    '      AND Up.AP2 = :PROV ' + LineEnding +
    '      AND Up.AP1 >= :FECHAINI ' + LineEnding +
    '      AND Up.AP1 <= DATE_ADD(:FECHAFIN, INTERVAL 30 DAY) ' + LineEnding +
    '    ORDER BY Up.AP1 DESC ' + LineEnding +
    '    LIMIT 1' + LineEnding +
    '  ), 0) AS ComprasUltPedido ' + LineEnding +
    'FROM tmp_flx_pedprov_ventas_art VA ' + LineEnding +
    'INNER JOIN tmp_flx_pedprov_artprov AP ON AP.CodigoArt = VA.CodigoArt ' + LineEnding +
    'INNER JOIN ' + TArt + ' A ON ' + CmpExpr('A.A0') + ' = VA.CodigoArt ' + LineEnding +
    FiltrosWhereSQL(AFamiliaFiltro, AFamilias, AAutorFiltro) +
    'ORDER BY ' + OrderBySQL(AOrden, AOrdenDir);
end;

procedure ExecSQL(AConnection: TZConnection; const ASQL: string);
var
  Q: TZQuery;
begin
  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.SQL.Text := ASQL;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure ExecSQLProv(AConnection: TZConnection; const ASQL: string; ACodProveedor: Integer);
var
  Q: TZQuery;
begin
  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.SQL.Text := ASQL;
    Q.ParamByName('PROV').AsInteger := ACodProveedor;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure ExecSQLFechas(AConnection: TZConnection; const ASQL: string; AFechaIni, AFechaFin: TDateTime);
var
  Q: TZQuery;
begin
  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.SQL.Text := ASQL;
    Q.ParamByName('FECHAINI').AsDateTime := DateOf(AFechaIni);
    Q.ParamByName('FECHAFIN').AsDateTime := DateOf(AFechaFin);
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure DropTempTables(AConnection: TZConnection);
begin
  ExecSQL(AConnection, 'DROP TEMPORARY TABLE IF EXISTS tmp_flx_pedprov_ventas_raw');
  ExecSQL(AConnection, 'DROP TEMPORARY TABLE IF EXISTS tmp_flx_pedprov_ventas_art');
  ExecSQL(AConnection, 'DROP TEMPORARY TABLE IF EXISTS tmp_flx_pedprov_artprov');
end;

procedure BuildTempTables(
  AConnection: TZConnection;
  const ASuffix: string;
  ACodProveedor: Integer;
  AFechaIni, AFechaFin: TDateTime
);
var
  TArt: string;
  THis: string;
  TUlt: string;
begin
  TArt := QTable('artitien', ASuffix);
  THis := QTable('hisopdd', ASuffix);
  TUlt := QTable('ultimopedi', ASuffix);

  DropTempTables(AConnection);

  ExecSQL(AConnection,
    'CREATE TEMPORARY TABLE tmp_flx_pedprov_ventas_raw (' + LineEnding +
    '  CodigoRaw VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,' + LineEnding +
    '  Vendidas DOUBLE NOT NULL DEFAULT 0,' + LineEnding +
    '  PRIMARY KEY (CodigoRaw)' + LineEnding +
    ') ENGINE=MEMORY'
  );

  ExecSQLFechas(AConnection,
    'INSERT INTO tmp_flx_pedprov_ventas_raw (CodigoRaw, Vendidas) ' + LineEnding +
    'SELECT ' + CmpExpr('TRIM(H.HOD6)') + ' AS CodigoRaw, SUM(H.HOD8) AS Vendidas ' + LineEnding +
    'FROM ' + THis + ' H ' + LineEnding +
    'WHERE H.HOD0 >= :FECHAINI ' + LineEnding +
    '  AND H.HOD0 <= :FECHAFIN ' + LineEnding +
    '  AND CHAR_LENGTH(TRIM(H.HOD6)) > 0 ' + LineEnding +
    'GROUP BY ' + CmpExpr('TRIM(H.HOD6)') + LineEnding +
    'HAVING ABS(SUM(H.HOD8)) > 0.0001',
    AFechaIni, AFechaFin
  );

  ExecSQL(AConnection,
    'CREATE TEMPORARY TABLE tmp_flx_pedprov_ventas_art (' + LineEnding +
    '  CodigoArt VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,' + LineEnding +
    '  Vendidas DOUBLE NOT NULL DEFAULT 0,' + LineEnding +
    '  PRIMARY KEY (CodigoArt)' + LineEnding +
    ') ENGINE=MEMORY'
  );

  // Venta cuyo HOD6 ya es codigo principal del articulo.
  ExecSQL(AConnection,
    'INSERT INTO tmp_flx_pedprov_ventas_art (CodigoArt, Vendidas) ' + LineEnding +
    'SELECT ' + CmpExpr('A.A0') + ' AS CodigoArt, SUM(V.Vendidas) AS Vendidas ' + LineEnding +
    'FROM tmp_flx_pedprov_ventas_raw V ' + LineEnding +
    'INNER JOIN ' + TArt + ' A ON ' + CmpExpr('A.A0') + ' = V.CodigoRaw ' + LineEnding +
    'GROUP BY ' + CmpExpr('A.A0') + LineEnding +
    'ON DUPLICATE KEY UPDATE Vendidas = Vendidas + VALUES(Vendidas)'
  );

  // Venta cuyo HOD6 es EAN auxiliar. Solo se usa si HOD6 no era ya codigo principal,
  // para no duplicar ventas si codigo y EAN coincidieran.
  ExecSQL(AConnection,
    'INSERT INTO tmp_flx_pedprov_ventas_art (CodigoArt, Vendidas) ' + LineEnding +
    'SELECT ' + CmpExpr('E.EAN1') + ' AS CodigoArt, SUM(V.Vendidas) AS Vendidas ' + LineEnding +
    'FROM tmp_flx_pedprov_ventas_raw V ' + LineEnding +
    'INNER JOIN `eans` E ON ' + CmpExpr('E.EAN0') + ' = V.CodigoRaw ' + LineEnding +
    'LEFT JOIN ' + TArt + ' AD ON ' + CmpExpr('AD.A0') + ' = V.CodigoRaw ' + LineEnding +
    'WHERE AD.A0 IS NULL ' + LineEnding +
    '  AND E.EAN1 IS NOT NULL ' + LineEnding +
    '  AND CHAR_LENGTH(TRIM(E.EAN1)) > 0 ' + LineEnding +
    'GROUP BY ' + CmpExpr('E.EAN1') + LineEnding +
    'ON DUPLICATE KEY UPDATE Vendidas = Vendidas + VALUES(Vendidas)'
  );

  ExecSQL(AConnection,
    'CREATE TEMPORARY TABLE tmp_flx_pedprov_artprov (' + LineEnding +
    '  CodigoArt VARCHAR(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci NOT NULL,' + LineEnding +
    '  PRIMARY KEY (CodigoArt)' + LineEnding +
    ') ENGINE=MEMORY'
  );

  // Articulos cuyo proveedor esta indicado directamente en ficha: artitien.A32.
  ExecSQLProv(AConnection,
    'INSERT IGNORE INTO tmp_flx_pedprov_artprov (CodigoArt) ' + LineEnding +
    'SELECT ' + CmpExpr('A.A0') + ' AS CodigoArt ' + LineEnding +
    'FROM ' + TArt + ' A ' + LineEnding +
    'WHERE A.A32 = :PROV ' + LineEnding +
    '  AND CHAR_LENGTH(TRIM(A.A0)) > 0',
    ACodProveedor
  );

  // Articulos que aparecen alguna vez comprados al proveedor en ultimopedi.AP2.
  ExecSQLProv(AConnection,
    'INSERT IGNORE INTO tmp_flx_pedprov_artprov (CodigoArt) ' + LineEnding +
    'SELECT ' + CmpExpr('U.AP0') + ' AS CodigoArt ' + LineEnding +
    'FROM ' + TUlt + ' U ' + LineEnding +
    'WHERE U.AP2 = :PROV ' + LineEnding +
    '  AND U.AP0 IS NOT NULL ' + LineEnding +
    '  AND CHAR_LENGTH(TRIM(U.AP0)) > 0 ' + LineEnding +
    'GROUP BY ' + CmpExpr('U.AP0'),
    ACodProveedor
  );
end;

function LoadRows(
  AConnection: TZConnection;
  const ASuffix: string;
  ACodProveedor: Integer;
  AFechaIni, AFechaFin: TDateTime;
  AOrden: TPedidoProvOrden;
  AOrdenDir: TPedidoProvOrdenDir;
  AFamiliaFiltro: TPedidoProvFamiliaFiltro;
  const AFamilias: string;
  AAutorFiltro: Integer
): TPedidoProvRows;
var
  Q: TZQuery;
  N: Integer;
  FechaIniReal: TDateTime;
begin
  SetLength(Result, 0);

  // Seguridad: si por error se pide un rango mayor, como maximo leemos 6 meses de ventas.
  FechaIniReal := DateOf(AFechaIni);
  if FechaIniReal < IncMonth(DateOf(AFechaFin), -6) then
    FechaIniReal := IncMonth(DateOf(AFechaFin), -6);

  Q := TZQuery.Create(nil);
  try
    // En MariaDB evita que una sentencia accidentalmente mala deje el servidor bloqueado.
    try
      ExecSQL(AConnection, 'SET SESSION max_statement_time = 25');
    except
      // Si el servidor no soporta max_statement_time, continuamos sin romper compatibilidad.
    end;

    BuildTempTables(AConnection, ASuffix, ACodProveedor, FechaIniReal, AFechaFin);

    Q.Connection := AConnection;
    Q.ReadOnly := True;
    Q.SQL.Text := BuildFinalSQL(ASuffix, AOrden, AOrdenDir, AFamiliaFiltro, AFamilias, AAutorFiltro);
    Q.ParamByName('PROV').AsInteger := ACodProveedor;
    if AAutorFiltro > 0 then
      Q.ParamByName('AUT').AsInteger := AAutorFiltro;
    Q.ParamByName('FECHAINI').AsDateTime := DateOf(FechaIniReal);
    Q.ParamByName('FECHAFIN').AsDateTime := DateOf(AFechaFin);
    Q.Open;

    while not Q.EOF do
    begin
      N := Length(Result);
      SetLength(Result, N + 1);

      Result[N].Codigo := Trim(Q.FieldByName('Codigo').AsString);
      Result[N].Descripcion := Trim(Q.FieldByName('Descripcion').AsString);
      Result[N].Vendidas := Q.FieldByName('Vendidas').AsFloat;
      Result[N].Coste := Q.FieldByName('Coste').AsFloat;
      Result[N].PVP := Q.FieldByName('PVP').AsFloat;
      Result[N].IVA := Q.FieldByName('IVA').AsInteger;
      Result[N].Stock := Q.FieldByName('Stock').AsFloat;
      Result[N].ComprasUltPedido := Q.FieldByName('ComprasUltPedido').AsFloat;

      Q.Next;
    end;
  finally
    Q.Free;
    try
      DropTempTables(AConnection);
    except
    end;
    try
      ExecSQL(AConnection, 'SET SESSION max_statement_time = 0');
    except
    end;
  end;
end;

function LocalFS: TFormatSettings;
begin
  Result := DefaultFormatSettings;
end;

function PdfFS: TFormatSettings;
begin
  Result := DefaultFormatSettings;
  Result.DecimalSeparator := '.';
  Result.ThousandSeparator := ',';
end;

function PdfNum(AValue: Double): string;
begin
  Result := FloatToStrF(AValue, ffFixed, 15, 2, PdfFS);
end;

function UTF8CharCount(const S: string): Integer;
var
  W: UnicodeString;
begin
  W := UTF8Decode(S);
  Result := Length(W);
end;

function UTF8Cut(const S: string; AMaxChars: Integer): string;
var
  W: UnicodeString;
begin
  if AMaxChars <= 0 then
    Exit('');

  W := UTF8Decode(S);
  if Length(W) <= AMaxChars then
    Result := S
  else if AMaxChars <= 1 then
    Result := UTF8Encode(Copy(W, 1, 1))
  else
    Result := UTF8Encode(Copy(W, 1, AMaxChars - 1)) + '...';
end;

function FitText(const S: string; AWidth: Double; AFontSize: Integer): string;
var
  MaxChars: Integer;
begin
  MaxChars := Max(1, Trunc(AWidth / (AFontSize * 0.50)));
  Result := UTF8Cut(S, MaxChars);
end;

function FormatQty(AValue: Double): string;
begin
  Result := FormatFloat('#,##0.##', AValue, LocalFS);
end;

function FormatMoney(AValue: Double): string;
begin
  Result := FormatFloat('#,##0.00', AValue, LocalFS);
end;

function ToWinAnsi(const S: string): AnsiString;
var
  W: UnicodeString;
  I: Integer;
  C: Cardinal;
  B: Byte;
begin
  Result := '';
  W := UTF8Decode(S);

  for I := 1 to Length(W) do
  begin
    C := Ord(W[I]);

    case C of
      9, 10, 13:
        B := 32;
      32..126:
        B := Byte(C);
      160..255:
        B := Byte(C);

      // Caracteres CP1252 habituales.
      8364: B := 128; // euro
      8218: B := 130;
      402:  B := 131;
      8222: B := 132;
      8230: B := 133;
      8224: B := 134;
      8225: B := 135;
      710:  B := 136;
      8240: B := 137;
      352:  B := 138;
      8249: B := 139;
      338:  B := 140;
      381:  B := 142;
      8216: B := 145;
      8217: B := 146;
      8220: B := 147;
      8221: B := 148;
      8226: B := 149;
      8211: B := 150;
      8212: B := 151;
      732:  B := 152;
      8482: B := 153;
      353:  B := 154;
      8250: B := 155;
      339:  B := 156;
      382:  B := 158;
      376:  B := 159;
    else
      B := Ord('?');
    end;

    Result := Result + AnsiChar(B);
  end;
end;

function PdfEscape(const S: string): AnsiString;
var
  A: AnsiString;
  I: Integer;
  Ch: AnsiChar;
begin
  A := ToWinAnsi(S);
  Result := '';

  for I := 1 to Length(A) do
  begin
    Ch := A[I];
    case Ch of
      '\': Result := Result + '\\';
      '(': Result := Result + '\(';
      ')': Result := Result + '\)';
      #0..#31: Result := Result + ' ';
    else
      Result := Result + Ch;
    end;
  end;
end;

function PdfText(AX, ATopY: Double; ASize: Integer; const AText: string): AnsiString;
begin
  Result :=
    'BT /F1 ' + IntToStr(ASize) + ' Tf ' +
    PdfNum(AX) + ' ' + PdfNum(PDF_PAGE_H - ATopY) + ' Td (' +
    PdfEscape(AText) + ') Tj ET' + #10;
end;

function ApproxTextWidth(const S: string; ASize: Integer): Double;
begin
  Result := UTF8CharCount(S) * ASize * 0.50;
end;

function PdfTextRight(AXRight, ATopY: Double; ASize: Integer; const AText: string): AnsiString;
var
  X: Double;
begin
  X := AXRight - ApproxTextWidth(AText, ASize);
  Result := PdfText(X, ATopY, ASize, AText);
end;

function PdfLine(AX1, ATopY1, AX2, ATopY2: Double): AnsiString;
begin
  Result :=
    PdfNum(AX1) + ' ' + PdfNum(PDF_PAGE_H - ATopY1) + ' m ' +
    PdfNum(AX2) + ' ' + PdfNum(PDF_PAGE_H - ATopY2) + ' l S' + #10;
end;

procedure PDFWriteRaw(AStream: TStream; const S: AnsiString);
begin
  if Length(S) > 0 then
    AStream.WriteBuffer(Pointer(S)^, Length(S));
end;


function PdfOffset10(AValue: Int64): AnsiString;
var
  S: string;
begin
  S := IntToStr(AValue);
  while Length(S) < 10 do
    S := '0' + S;
  Result := AnsiString(S);
end;

procedure SaveSimplePDF(const AFileName: string; const APages: array of AnsiString);
var
  FS: TFileStream;
  Offsets: array of Int64;
  TotalObjs: Integer;
  I: Integer;
  PageObj: Integer;
  ContentObj: Integer;
  StartXRef: Int64;
  Kids: AnsiString;
  Obj: AnsiString;

  procedure WriteObj(AObjNo: Integer; const ABody: AnsiString);
  begin
    Offsets[AObjNo] := FS.Position;
    PDFWriteRaw(FS, AnsiString(IntToStr(AObjNo)) + ' 0 obj' + #10);
    PDFWriteRaw(FS, ABody);
    PDFWriteRaw(FS, #10 + 'endobj' + #10);
  end;

begin
  TotalObjs := 3 + (Length(APages) * 2);
  SetLength(Offsets, TotalObjs + 1);

  FS := TFileStream.Create(AFileName, fmCreate);
  try
    PDFWriteRaw(FS, '%PDF-1.4' + #10);
    PDFWriteRaw(FS, '%' + AnsiChar($E2) + AnsiChar($E3) + AnsiChar($CF) + AnsiChar($D3) + #10);

    WriteObj(1, '<< /Type /Catalog /Pages 2 0 R >>');

    Kids := '[';
    for I := 0 to High(APages) do
    begin
      PageObj := 4 + (I * 2);
      Kids := Kids + AnsiString(IntToStr(PageObj)) + ' 0 R ';
    end;
    Kids := Kids + ']';

    WriteObj(
      2,
      '<< /Type /Pages /Kids ' + Kids + ' /Count ' +
      AnsiString(IntToStr(Length(APages))) + ' >>'
    );

    WriteObj(
      3,
      '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>'
    );

    for I := 0 to High(APages) do
    begin
      PageObj := 4 + (I * 2);
      ContentObj := PageObj + 1;

      Obj :=
        '<< /Type /Page /Parent 2 0 R ' +
        '/MediaBox [0 0 ' + AnsiString(PdfNum(PDF_PAGE_W)) + ' ' + AnsiString(PdfNum(PDF_PAGE_H)) + '] ' +
        '/Resources << /Font << /F1 3 0 R >> >> ' +
        '/Contents ' + AnsiString(IntToStr(ContentObj)) + ' 0 R >>';

      WriteObj(PageObj, Obj);

      Offsets[ContentObj] := FS.Position;
      PDFWriteRaw(FS, AnsiString(IntToStr(ContentObj)) + ' 0 obj' + #10);
      PDFWriteRaw(FS, '<< /Length ' + AnsiString(IntToStr(Length(APages[I]))) + ' >>' + #10);
      PDFWriteRaw(FS, 'stream' + #10);
      PDFWriteRaw(FS, APages[I]);
      PDFWriteRaw(FS, 'endstream' + #10);
      PDFWriteRaw(FS, 'endobj' + #10);
    end;

    StartXRef := FS.Position;
    PDFWriteRaw(FS, 'xref' + #10);
    PDFWriteRaw(FS, '0 ' + AnsiString(IntToStr(TotalObjs + 1)) + #10);
    PDFWriteRaw(FS, '0000000000 65535 f ' + #10);

    for I := 1 to TotalObjs do
      PDFWriteRaw(FS, PdfOffset10(Offsets[I]) + ' 00000 n ' + #10);

    PDFWriteRaw(FS, 'trailer' + #10);
    PDFWriteRaw(
      FS,
      '<< /Size ' + AnsiString(IntToStr(TotalObjs + 1)) + ' /Root 1 0 R >>' + #10
    );
    PDFWriteRaw(FS, 'startxref' + #10);
    PDFWriteRaw(FS, AnsiString(IntToStr(StartXRef)) + #10);
    PDFWriteRaw(FS, '%%EOF' + #10);
  finally
    FS.Free;
  end;
end;

procedure AppendPage(var APages: TAnsiStringDynArray; const AContent: AnsiString);
var
  N: Integer;
begin
  N := Length(APages);
  SetLength(APages, N + 1);
  APages[N] := AContent;
end;

function BuildPDFPages(
  const ARows: TPedidoProvRows;
  ACodProveedor: Integer;
  const AProveedorNombre: string;
  AFechaIni, AFechaFin: TDateTime;
  AOrden: TPedidoProvOrden;
  AOrdenDir: TPedidoProvOrdenDir;
  const AFamiliaTexto: string;
  const AAutorTexto: string;
  out ATotalVendidas: Double
): TAnsiStringDynArray;
var
  I: Integer;
  PageNo: Integer;
  RowTop: Double;
  Content: AnsiString;
  DirTxt: string;

  procedure AddHeader;
  begin
    Content := Content + '0.45 w' + #10;

    Content := Content + PdfText(25, 32, 14, 'Pedido orientativo por ventas de proveedor');
    Content := Content + PdfText(25, 52, 10, 'Proveedor: ' + IntToStr(ACodProveedor) + ' - ' + AProveedorNombre);
    Content := Content + PdfText(25, 64, 9, 'Autor/Fabricante: ' + AAutorTexto);
    Content := Content + PdfText(25, 76, 9, 'Rango ventas: ' + DateToStr(AFechaIni) + ' a ' + DateToStr(AFechaFin));
    Content := Content + PdfText(25, 88, 9, 'Familias: ' + AFamiliaTexto);

    if AOrdenDir = podDesc then
      DirTxt := 'descendente'
    else
      DirTxt := 'ascendente';

    Content := Content + PdfText(350, 88, 9, 'Orden: ' + PedidoProvOrdenCaption(AOrden) + ' ' + DirTxt);

    Content := Content + PdfLine(25, 102, 570, 102);

    Content := Content + PdfText(28, 119, 8, 'CODIGO');
    Content := Content + PdfText(104, 119, 8, 'DESCRIPCION');
    Content := Content + PdfTextRight(318, 119, 8, 'UDES');
    Content := Content + PdfTextRight(370, 119, 8, 'COSTE');
    Content := Content + PdfTextRight(418, 119, 8, 'PVP');
    Content := Content + PdfTextRight(453, 119, 8, 'IVA');
    Content := Content + PdfTextRight(510, 119, 8, 'STOCK');
    Content := Content + PdfTextRight(570, 119, 8, 'ULT.PED.');

    Content := Content + PdfLine(25, 128, 570, 128);
  end;

  procedure AddFooter;
  begin
    Content := Content + PdfLine(25, 808, 570, 808);
    Content := Content + PdfText(25, 823, 8, 'Generado: ' + DateTimeToStr(Now));
    Content := Content + PdfTextRight(570, 823, 8, 'Pagina ' + IntToStr(PageNo));
  end;

  procedure AddRow(const R: TPedidoProvRow);
  var
    Desc: string;
  begin
    Desc := FitText(R.Descripcion, 158, 8);

    Content := Content + PdfText(28, RowTop, 8, FitText(R.Codigo, 72, 8));
    Content := Content + PdfText(104, RowTop, 8, Desc);
    Content := Content + PdfTextRight(318, RowTop, 8, FormatQty(R.Vendidas));
    Content := Content + PdfTextRight(370, RowTop, 8, FormatMoney(R.Coste));
    Content := Content + PdfTextRight(418, RowTop, 8, FormatMoney(R.PVP));
    Content := Content + PdfTextRight(453, RowTop, 8, IntToStr(R.IVA));
    Content := Content + PdfTextRight(510, RowTop, 8, FormatQty(R.Stock));
    Content := Content + PdfTextRight(570, RowTop, 8, FormatQty(R.ComprasUltPedido));

    Content := Content + PdfLine(25, RowTop + 5, 570, RowTop + 5);
    RowTop := RowTop + 14;
  end;

begin
  SetLength(Result, 0);
  ATotalVendidas := 0;

  for I := 0 to High(ARows) do
    ATotalVendidas := ATotalVendidas + ARows[I].Vendidas;

  I := 0;
  PageNo := 1;

  repeat
    Content := '';
    AddHeader;
    RowTop := 143;

    if Length(ARows) = 0 then
    begin
      Content := Content + PdfText(28, RowTop, 10, 'No hay articulos vendidos en el periodo para este proveedor/filtro.');
      RowTop := RowTop + 18;
    end
    else
    begin
      while (I <= High(ARows)) and (RowTop <= 790) do
      begin
        AddRow(ARows[I]);
        Inc(I);
      end;
    end;

    if I > High(ARows) then
    begin
      Content := Content + PdfLine(25, RowTop + 3, 570, RowTop + 3);
      Content := Content + PdfText(28, RowTop + 18, 9, 'Total lineas: ' + IntToStr(Length(ARows)));
      Content := Content + PdfTextRight(318, RowTop + 18, 9, FormatQty(ATotalVendidas));
    end;

    AddFooter;
    AppendPage(Result, Content);
    Inc(PageNo);
  until (I > High(ARows)) or (Length(ARows) = 0);
end;

procedure ExecuteDetached(const AExe: string; const AParams: array of string);
var
  P: TProcess;
  I: Integer;
begin
  P := TProcess.Create(nil);
  try
    P.Executable := AExe;
    for I := 0 to High(AParams) do
      P.Parameters.Add(AParams[I]);

    P.Options := [];
    P.Execute;
  finally
    P.Free;
  end;
end;

procedure PrintPDF(const AFileName, APrinter: string);
begin
  if Trim(APrinter) <> '' then
    ExecuteDetached('lp', ['-d', APrinter, AFileName])
  else
    ExecuteDetached('lp', [AFileName]);
end;

procedure OpenPDF(const AFileName: string);
begin
  ExecuteDetached('xdg-open', [AFileName]);
end;


function LoadAutorNombre(AConnection: TZConnection; ACodAutor: Integer): string;
var
  Q: TZQuery;
begin
  Result := '';
  if ACodAutor <= 0 then
  begin
    Result := 'Todos';
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.ReadOnly := True;
    Q.SQL.Text := 'SELECT AUT1 FROM `autofabri` WHERE AUT0 = :AUT0 LIMIT 1';
    Q.ParamByName('AUT0').AsInteger := ACodAutor;
    Q.Open;

    if not Q.EOF then
      Result := Trim(Q.FieldByName('AUT1').AsString);
  finally
    Q.Free;
  end;

  if Result = '' then
    Result := 'Autor/Fabricante ' + IntToStr(ACodAutor);
end;

procedure LoadAutoresCombo(AConnection: TZConnection; ACombo: TComboBox);
var
  Q: TZQuery;
begin
  ACombo.Items.Clear;
  ACombo.Items.Add('Todos');

  Q := TZQuery.Create(nil);
  try
    try
      Q.Connection := AConnection;
      Q.ReadOnly := True;
      Q.SQL.Text := 'SELECT AUT0, AUT1 FROM `autofabri` ORDER BY AUT1, AUT0';
      Q.Open;

      while not Q.EOF do
      begin
        ACombo.Items.Add(Trim(Q.FieldByName('AUT0').AsString) + ' - ' + Trim(Q.FieldByName('AUT1').AsString));
        Q.Next;
      end;
    except
      // Si alguna instalacion no tiene autofabri accesible, dejamos el filtro en Todos.
    end;
  finally
    Q.Free;
  end;

  ACombo.ItemIndex := 0;
end;

function ResolverAutorTexto(AConnection: TZConnection; const ATexto: string; out ACodAutor: Integer; out ANombreAutor: string): Boolean;
var
  Q: TZQuery;
  S: string;
  P: Integer;
  C: Integer;
begin
  Result := False;
  ACodAutor := 0;
  ANombreAutor := 'Todos';

  S := Trim(ATexto);
  if (S = '') or SameText(S, 'Todos') then
  begin
    Result := True;
    Exit;
  end;

  P := Pos('-', S);
  if P > 0 then
    C := StrToIntDef(Trim(Copy(S, 1, P - 1)), -1)
  else
    C := StrToIntDef(S, -1);

  if C > 0 then
  begin
    ACodAutor := C;
    ANombreAutor := LoadAutorNombre(AConnection, C);
    Result := True;
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    try
      Q.Connection := AConnection;
      Q.ReadOnly := True;
      Q.SQL.Text :=
        'SELECT AUT0, AUT1 FROM `autofabri` ' +
        'WHERE AUT1 LIKE :TXT ' +
        'ORDER BY AUT1, AUT0 LIMIT 1';
      Q.ParamByName('TXT').AsString := '%' + S + '%';
      Q.Open;

      if not Q.EOF then
      begin
        ACodAutor := Q.FieldByName('AUT0').AsInteger;
        ANombreAutor := Trim(Q.FieldByName('AUT1').AsString);
        Result := True;
      end;
    except
      Result := False;
      ACodAutor := 0;
      ANombreAutor := '';
    end;
  finally
    Q.Free;
  end;
end;

function GenerarPedidoProveedorVentasPDF(
  AConnection: TZConnection;
  const ATienda: string;
  ACodProveedor: Integer;
  AFechaIni, AFechaFin: TDateTime;
  AOrden: TPedidoProvOrden;
  AOrdenDir: TPedidoProvOrdenDir;
  const ARutaPDF: string;
  AImprimir: Boolean;
  const AImpresora: string;
  AAbrirPDF: Boolean;
  AFamiliaFiltro: TPedidoProvFamiliaFiltro;
  const AFamilias: string;
  AAutorFiltro: Integer;
  const AAutorNombre: string
): TPedidoProvResultado;
var
  Suffix: string;
  ProveedorNombre: string;
  Rows: TPedidoProvRows;
  Pages: TAnsiStringDynArray;
  PDFFile: string;
  TotalVendidas: Double;
  FamiliaTexto: string;
  AutorTexto: string;
begin
  Result.ArchivoPDF := '';
  Result.Lineas := 0;
  Result.TotalVendidas := 0;

  try
    if AConnection = nil then
      raise Exception.Create('La conexion no esta asignada.');

    if not AConnection.Connected then
      raise Exception.Create('La conexion a la base de datos no esta abierta.');

    if ACodProveedor <= 0 then
      raise Exception.Create('El codigo de proveedor no es valido.');

    if DateOf(AFechaFin) < DateOf(AFechaIni) then
      raise Exception.Create('La fecha final no puede ser anterior a la fecha inicial.');

    Suffix := CleanTiendaSuffix(ATienda);
    FamiliaTexto := FamiliaFiltroCaption(AFamiliaFiltro, AFamilias);
    if AAutorFiltro > 0 then
    begin
      AutorTexto := Trim(AAutorNombre);
      if AutorTexto = '' then
        AutorTexto := LoadAutorNombre(AConnection, AAutorFiltro);
      AutorTexto := AutorFiltroCaption(AAutorFiltro, AutorTexto);
    end
    else
      AutorTexto := 'Todos';

    ProveedorNombre := LoadProveedorNombre(AConnection, ACodProveedor);
    Rows := LoadRows(AConnection, Suffix, ACodProveedor, AFechaIni, AFechaFin, AOrden, AOrdenDir, AFamiliaFiltro, AFamilias, AAutorFiltro);

    PDFFile := ResolvePDFFileName(ARutaPDF, ACodProveedor, AFechaIni, AFechaFin);
    Pages := BuildPDFPages(Rows, ACodProveedor, ProveedorNombre, AFechaIni, AFechaFin, AOrden, AOrdenDir, FamiliaTexto, AutorTexto, TotalVendidas);

    SaveSimplePDF(PDFFile, Pages);

    Result.ArchivoPDF := PDFFile;
    Result.Lineas := Length(Rows);
    Result.TotalVendidas := TotalVendidas;

    if AImprimir then
      PrintPDF(PDFFile, AImpresora);

    if AAbrirPDF then
      OpenPDF(PDFFile);

  except
    on E: Exception do
    begin
      ShowMessage('Error generando pedido orientativo por ventas [' + FLX_PEDPROVVENTASPDF_VERSION + ']:' + LineEnding + E.Message);
      Result.ArchivoPDF := '';
      Result.Lineas := 0;
      Result.TotalVendidas := 0;
    end;
  end;
end;


function LeadingInt(const S: string): Integer;
var
  I: Integer;
  T: string;
begin
  T := '';
  I := 1;
  while (I <= Length(S)) and (S[I] <= ' ') do Inc(I);
  while (I <= Length(S)) and (S[I] in ['0'..'9']) do
  begin
    T := T + S[I];
    Inc(I);
  end;
  Result := StrToIntDef(T, 0);
end;

procedure LoadProveedoresCombo(AConnection: TZConnection; ACombo: TComboBox);
var
  Q: TZQuery;
begin
  ACombo.Items.Clear;
  if (AConnection = nil) or (not AConnection.Connected) then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.ReadOnly := True;
    Q.SQL.Text := 'SELECT P0, P1 FROM `proveedores` ORDER BY P1, P0';
    Q.Open;
    while not Q.EOF do
    begin
      ACombo.Items.Add(IntToStr(Q.FieldByName('P0').AsInteger) + ' - ' + Trim(Q.FieldByName('P1').AsString));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

function ResolverProveedorTexto(AConnection: TZConnection; const ATexto: string; out ACodProveedor: Integer; out ANombreProveedor: string): Boolean;
var
  Q: TZQuery;
  C: Integer;
begin
  Result := False;
  ACodProveedor := 0;
  ANombreProveedor := '';

  C := LeadingInt(ATexto);
  if C > 0 then
  begin
    ACodProveedor := C;
    ANombreProveedor := LoadProveedorNombre(AConnection, C);
    Result := True;
    Exit;
  end;

  if Trim(ATexto) = '' then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.ReadOnly := True;
    Q.SQL.Text :=
      'SELECT P0, P1 FROM `proveedores` ' +
      'WHERE LOWER(P1) LIKE LOWER(:TXT) ' +
      'ORDER BY P1, P0 LIMIT 2';
    Q.ParamByName('TXT').AsString := '%' + Trim(ATexto) + '%';
    Q.Open;

    if Q.EOF then Exit;

    ACodProveedor := Q.FieldByName('P0').AsInteger;
    ANombreProveedor := Trim(Q.FieldByName('P1').AsString);
    Q.Next;

    // Si hay mas de una coincidencia, mejor seleccionar en desplegable.
    if not Q.EOF then
    begin
      ACodProveedor := 0;
      ANombreProveedor := '';
      Exit;
    end;

    Result := True;
  finally
    Q.Free;
  end;
end;


procedure LoadFamiliasCombo(AConnection: TZConnection; const ASuffix: string; ACombo: TComboBox);
var
  Q: TZQuery;
begin
  ACombo.Items.Clear;
  ACombo.Items.Add('0 - SIN FAMILIA / NO ASIGNADA');

  if (AConnection = nil) or (not AConnection.Connected) then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.ReadOnly := True;
    Q.SQL.Text := 'SELECT F0, F1 FROM ' + QTable('familias', ASuffix) + ' ORDER BY F0';
    Q.Open;
    while not Q.EOF do
    begin
      if Q.FieldByName('F0').AsInteger <> 0 then
        ACombo.Items.Add(IntToStr(Q.FieldByName('F0').AsInteger) + ' - ' + Trim(Q.FieldByName('F1').AsString));
      Q.Next;
    end;
  except
    on E: Exception do
    begin
      // Si no existiera la tabla de familias en una tienda concreta, no bloqueamos el informe.
      // Al menos dejamos visible la opcion 0 y el usuario puede escribir codigos manualmente.
    end;
  end;
  Q.Free;
end;

procedure ShowFormFLXPedidoProveedorVentas(
  AOwner: TComponent;
  AConnection: TZConnection;
  const ATienda: string;
  const ARutaPDF: string
);
var
  F: TForm;
  pnlCab, pnlCliente, pnlBotones: TPanel;
  gbProveedor, gbPeriodo, gbOrden, gbFiltros, gbSalida: TGroupBox;
  LTitulo, LSubtitulo: TLabel;
  LProv, LAutor, LDesde, LHasta, LOrden, LDir, LFamModo, LFamCodigos, LFamLista: TLabel;
  CProv, CAutor, COrden, CDir, CFamModo, CFamLista: TComboBox;
  EDesde, EHasta: TDateEdit;
  EFam: TEdit;
  ChImprimir, ChAbrir: TCheckBox;
  BOk, BCancel: TBitBtn;
  Orden: TPedidoProvOrden;
  Dir: TPedidoProvOrdenDir;
  FamFiltro: TPedidoProvFamiliaFiltro;
  CodProv: Integer;
  NomProv: string;
  CodAutor: Integer;
  NomAutor: string;
  FechaIni, FechaFin: TDateTime;
  R: TPedidoProvResultado;
  FamLista: string;

  function ComboToOrden(AIndex: Integer): TPedidoProvOrden;
  begin
    case AIndex of
      0: Result := ppoCodigo;
      1: Result := ppoDescripcion;
      2: Result := ppoVendidas;
      3: Result := ppoCoste;
      4: Result := ppoPVP;
      5: Result := ppoIVA;
      6: Result := ppoStock;
      7: Result := ppoComprasUltPedido;
    else
      Result := ppoCodigo;
    end;
  end;

begin
  F := TForm.Create(AOwner);
  try
    F.Caption := 'Pedido por ventas de proveedor';
    F.Position := poScreenCenter;
    F.BorderStyle := bsDialog;
    F.Width := 840;
    F.Height := 610;
    F.Color := $00F3F5F7;
    F.Font.Name := 'Sans';
    F.Font.Height := -13;

    pnlCab := TPanel.Create(F);
    pnlCab.Parent := F;
    pnlCab.Align := alTop;
    pnlCab.Height := 76;
    pnlCab.BevelOuter := bvNone;
    pnlCab.Color := clNavy;

    LTitulo := TLabel.Create(F);
    LTitulo.Parent := pnlCab;
    LTitulo.Left := 18;
    LTitulo.Top := 12;
    LTitulo.Caption := 'PEDIDO PDF POR VENTAS DE PROVEEDOR';
    LTitulo.ParentFont := False;
    LTitulo.Font.Name := 'Sans';
    LTitulo.Font.Height := -20;
    LTitulo.Font.Style := [fsBold];
    LTitulo.Font.Color := clWhite;

    LSubtitulo := TLabel.Create(F);
    LSubtitulo.Parent := pnlCab;
    LSubtitulo.Left := 20;
    LSubtitulo.Top := 42;
    LSubtitulo.Caption := 'Genera un PDF orientativo a partir de las ventas del periodo, con filtros por proveedor, autor/fabricante y familias.';
    LSubtitulo.ParentFont := False;
    LSubtitulo.Font.Name := 'Sans';
    LSubtitulo.Font.Height := -12;
    LSubtitulo.Font.Color := clSilver;

    pnlCliente := TPanel.Create(F);
    pnlCliente.Parent := F;
    pnlCliente.Align := alClient;
    pnlCliente.BevelOuter := bvNone;
    pnlCliente.Color := $00F3F5F7;

    gbProveedor := TGroupBox.Create(F);
    gbProveedor.Parent := pnlCliente;
    gbProveedor.SetBounds(16, 16, 800, 112);
    gbProveedor.Caption := ' PROVEEDOR Y AUTOR / FABRICANTE ';
    gbProveedor.ParentFont := False;
    gbProveedor.Font.Name := 'Sans';
    gbProveedor.Font.Height := -13;
    gbProveedor.Font.Style := [fsBold];

    LProv := TLabel.Create(F);
    LProv.Parent := gbProveedor;
    LProv.Left := 16;
    LProv.Top := 28;
    LProv.Caption := 'Proveedor';
    LProv.ParentFont := False;
    LProv.Font.Style := [];

    CProv := TComboBox.Create(F);
    CProv.Parent := gbProveedor;
    CProv.Left := 16;
    CProv.Top := 48;
    CProv.Width := 368;
    CProv.Style := csDropDown;
    CProv.Hint := 'Puede escribir codigo, parte del nombre o seleccionar de la lista';
    CProv.ShowHint := True;
    LoadProveedoresCombo(AConnection, CProv);

    LAutor := TLabel.Create(F);
    LAutor.Parent := gbProveedor;
    LAutor.Left := 404;
    LAutor.Top := 28;
    LAutor.Caption := 'Autor / Fabricante';
    LAutor.ParentFont := False;
    LAutor.Font.Style := [];

    CAutor := TComboBox.Create(F);
    CAutor.Parent := gbProveedor;
    CAutor.Left := 404;
    CAutor.Top := 48;
    CAutor.Width := 372;
    CAutor.Style := csDropDown;
    CAutor.Hint := 'Filtro opcional para bulto gordo. Deje Todos para no filtrar.';
    CAutor.ShowHint := True;
    LoadAutoresCombo(AConnection, CAutor);

    gbPeriodo := TGroupBox.Create(F);
    gbPeriodo.Parent := pnlCliente;
    gbPeriodo.SetBounds(16, 138, 248, 106);
    gbPeriodo.Caption := ' PERIODO ';
    gbPeriodo.ParentFont := False;
    gbPeriodo.Font.Name := 'Sans';
    gbPeriodo.Font.Height := -13;
    gbPeriodo.Font.Style := [fsBold];

    LDesde := TLabel.Create(F);
    LDesde.Parent := gbPeriodo;
    LDesde.Left := 16;
    LDesde.Top := 28;
    LDesde.Caption := 'Fecha inicial';
    LDesde.ParentFont := False;
    LDesde.Font.Style := [];

    EDesde := TDateEdit.Create(F);
    EDesde.Parent := gbPeriodo;
    EDesde.Left := 16;
    EDesde.Top := 48;
    EDesde.Width := 96;
    EDesde.Date := IncDay(DateOf(Now), -14);
    EDesde.Hint := 'Seleccione la fecha inicial desde el calendario o escribala manualmente.';
    EDesde.ShowHint := True;

    LHasta := TLabel.Create(F);
    LHasta.Parent := gbPeriodo;
    LHasta.Left := 132;
    LHasta.Top := 28;
    LHasta.Caption := 'Fecha final';
    LHasta.ParentFont := False;
    LHasta.Font.Style := [];

    EHasta := TDateEdit.Create(F);
    EHasta.Parent := gbPeriodo;
    EHasta.Left := 132;
    EHasta.Top := 48;
    EHasta.Width := 96;
    EHasta.Date := DateOf(Now);
    EHasta.Hint := 'Seleccione la fecha final desde el calendario o escribala manualmente.';
    EHasta.ShowHint := True;

    gbOrden := TGroupBox.Create(F);
    gbOrden.Parent := pnlCliente;
    gbOrden.SetBounds(276, 138, 264, 106);
    gbOrden.Caption := ' ORDENACION ';
    gbOrden.ParentFont := False;
    gbOrden.Font.Name := 'Sans';
    gbOrden.Font.Height := -13;
    gbOrden.Font.Style := [fsBold];

    LOrden := TLabel.Create(F);
    LOrden.Parent := gbOrden;
    LOrden.Left := 16;
    LOrden.Top := 28;
    LOrden.Caption := 'Ordenar por';
    LOrden.ParentFont := False;
    LOrden.Font.Style := [];

    COrden := TComboBox.Create(F);
    COrden.Parent := gbOrden;
    COrden.Left := 16;
    COrden.Top := 48;
    COrden.Width := 148;
    COrden.Style := csDropDownList;
    COrden.Items.Add('Codigo');
    COrden.Items.Add('Descripcion');
    COrden.Items.Add('Unidades vendidas');
    COrden.Items.Add('Coste');
    COrden.Items.Add('PVP');
    COrden.Items.Add('IVA');
    COrden.Items.Add('Stock');
    COrden.Items.Add('Compras ultimo pedido');
    COrden.ItemIndex := 2;

    LDir := TLabel.Create(F);
    LDir.Parent := gbOrden;
    LDir.Left := 176;
    LDir.Top := 28;
    LDir.Caption := 'Direccion';
    LDir.ParentFont := False;
    LDir.Font.Style := [];

    CDir := TComboBox.Create(F);
    CDir.Parent := gbOrden;
    CDir.Left := 176;
    CDir.Top := 48;
    CDir.Width := 72;
    CDir.Style := csDropDownList;
    CDir.Items.Add('Ascendente');
    CDir.Items.Add('Descendente');
    CDir.ItemIndex := 1;

    gbSalida := TGroupBox.Create(F);
    gbSalida.Parent := pnlCliente;
    gbSalida.SetBounds(552, 138, 264, 106);
    gbSalida.Caption := ' SALIDA ';
    gbSalida.ParentFont := False;
    gbSalida.Font.Name := 'Sans';
    gbSalida.Font.Height := -13;
    gbSalida.Font.Style := [fsBold];

    ChAbrir := TCheckBox.Create(F);
    ChAbrir.Parent := gbSalida;
    ChAbrir.Left := 16;
    ChAbrir.Top := 34;
    ChAbrir.Width := 180;
    ChAbrir.Caption := 'Abrir PDF al terminar';
    ChAbrir.Checked := True;
    ChAbrir.ParentFont := False;
    ChAbrir.Font.Style := [];

    ChImprimir := TCheckBox.Create(F);
    ChImprimir.Parent := gbSalida;
    ChImprimir.Left := 16;
    ChImprimir.Top := 62;
    ChImprimir.Width := 180;
    ChImprimir.Caption := 'Imprimir directamente';
    ChImprimir.Checked := False;
    ChImprimir.ParentFont := False;
    ChImprimir.Font.Style := [];

    gbFiltros := TGroupBox.Create(F);
    gbFiltros.Parent := pnlCliente;
    gbFiltros.SetBounds(16, 254, 800, 150);
    gbFiltros.Caption := ' FILTRO DE FAMILIAS ';
    gbFiltros.ParentFont := False;
    gbFiltros.Font.Name := 'Sans';
    gbFiltros.Font.Height := -13;
    gbFiltros.Font.Style := [fsBold];

    LFamModo := TLabel.Create(F);
    LFamModo.Parent := gbFiltros;
    LFamModo.Left := 16;
    LFamModo.Top := 28;
    LFamModo.Caption := 'Modo';
    LFamModo.ParentFont := False;
    LFamModo.Font.Style := [];

    CFamModo := TComboBox.Create(F);
    CFamModo.Parent := gbFiltros;
    CFamModo.Left := 16;
    CFamModo.Top := 48;
    CFamModo.Width := 220;
    CFamModo.Style := csDropDownList;
    CFamModo.Items.Add('Todas');
    CFamModo.Items.Add('Solo estas familias');
    CFamModo.Items.Add('Excluir estas familias');
    CFamModo.ItemIndex := 0;

    LFamCodigos := TLabel.Create(F);
    LFamCodigos.Parent := gbFiltros;
    LFamCodigos.Left := 256;
    LFamCodigos.Top := 28;
    LFamCodigos.Caption := 'Codigos familia';
    LFamCodigos.ParentFont := False;
    LFamCodigos.Font.Style := [];

    EFam := TEdit.Create(F);
    EFam.Parent := gbFiltros;
    EFam.Left := 256;
    EFam.Top := 48;
    EFam.Width := 520;
    EFam.Text := '';
    EFam.Hint := 'Ejemplo: 0, 58 o 58,59,60. Si selecciona una familia abajo y deja esto vacio, se usara esa familia.';
    EFam.ShowHint := True;

    LFamLista := TLabel.Create(F);
    LFamLista.Parent := gbFiltros;
    LFamLista.Left := 16;
    LFamLista.Top := 86;
    LFamLista.Caption := 'Ver familias';
    LFamLista.ParentFont := False;
    LFamLista.Font.Style := [];

    CFamLista := TComboBox.Create(F);
    CFamLista.Parent := gbFiltros;
    CFamLista.Left := 16;
    CFamLista.Top := 106;
    CFamLista.Width := 760;
    CFamLista.Style := csDropDownList;
    CFamLista.Hint := 'Listado informativo. Para una sola familia puede seleccionarla aqui y dejar Codigos familia vacio.';
    CFamLista.ShowHint := True;
    LoadFamiliasCombo(AConnection, CleanTiendaSuffix(ATienda), CFamLista);

    pnlBotones := TPanel.Create(F);
    pnlBotones.Parent := pnlCliente;
    pnlBotones.SetBounds(16, 418, 800, 58);
    pnlBotones.BevelOuter := bvNone;
    pnlBotones.Color := $00F3F5F7;

    BOk := TBitBtn.Create(F);
    BOk.Parent := pnlBotones;
    BOk.Left := 588;
    BOk.Top := 12;
    BOk.Width := 100;
    BOk.Height := 34;
    BOk.Kind := bkOK;
    BOk.Caption := 'Generar';
    BOk.ModalResult := mrOK;
    BOk.Font.Style := [fsBold];

    BCancel := TBitBtn.Create(F);
    BCancel.Parent := pnlBotones;
    BCancel.Left := 696;
    BCancel.Top := 12;
    BCancel.Width := 100;
    BCancel.Height := 34;
    BCancel.Kind := bkCancel;
    BCancel.Caption := 'Cancelar';
    BCancel.ModalResult := mrCancel;

    if F.ShowModal = mrOK then
    begin
      if not ResolverProveedorTexto(AConnection, Trim(CProv.Text), CodProv, NomProv) then
      begin
        ShowMessage('Debe indicar un proveedor valido. Si escribe por nombre y hay varias coincidencias, seleccionelo en la lista.');
        Exit;
      end;

      if not ResolverAutorTexto(AConnection, Trim(CAutor.Text), CodAutor, NomAutor) then
      begin
        ShowMessage('Debe indicar un autor/fabricante valido o dejar el filtro en Todos.');
        Exit;
      end;

      try
        if Trim(EDesde.Text) = '' then
          raise Exception.Create('Fecha inicial vacia');
        if Trim(EHasta.Text) = '' then
          raise Exception.Create('Fecha final vacia');

        FechaIni := DateOf(EDesde.Date);
        FechaFin := DateOf(EHasta.Date);
      except
        on E: Exception do
        begin
          ShowMessage('Las fechas no son validas. Seleccionelas desde el calendario o use formato dd/mm/aaaa.');
          Exit;
        end;
      end;

      Orden := ComboToOrden(COrden.ItemIndex);
      if CDir.ItemIndex = 1 then
        Dir := podDesc
      else
        Dir := podAsc;

      case CFamModo.ItemIndex of
        1: FamFiltro := pffSoloFamilias;
        2: FamFiltro := pffExcluirFamilias;
      else
        FamFiltro := pffTodas;
      end;

      FamLista := CleanFamiliaList(EFam.Text);
      if (FamFiltro <> pffTodas) and (FamLista = '') and (CFamLista.ItemIndex >= 0) then
        FamLista := CleanFamiliaList(CFamLista.Text);

      if (FamFiltro <> pffTodas) and (FamLista = '') then
      begin
        ShowMessage('Debe indicar una o varias familias. Ejemplo: 0, 58 o 58,59. Tambien puede seleccionar una familia en el desplegable inferior.');
        Exit;
      end;

      R := GenerarPedidoProveedorVentasPDF(
        AConnection,
        ATienda,
        CodProv,
        FechaIni,
        FechaFin,
        Orden,
        Dir,
        ARutaPDF,
        ChImprimir.Checked,
        '',
        ChAbrir.Checked,
        FamFiltro,
        FamLista,
        CodAutor,
        NomAutor
      );

      if R.ArchivoPDF <> '' then
        ShowMessage('PDF generado correctamente:' + LineEnding + R.ArchivoPDF + LineEnding +
          'Proveedor: ' + IntToStr(CodProv) + ' - ' + NomProv + LineEnding +
          'Autor/Fabricante: ' + AutorFiltroCaption(CodAutor, NomAutor) + LineEnding +
          'Familias: ' + FamiliaFiltroCaption(FamFiltro, FamLista) + LineEnding +
          'Lineas: ' + IntToStr(R.Lineas));
    end;
  finally
    F.Free;
  end;
end;

end.
