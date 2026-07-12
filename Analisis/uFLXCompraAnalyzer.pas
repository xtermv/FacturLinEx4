unit uFLXCompraAnalyzer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Math, ZConnection, ZDataset;

type
  TFLXProveedorCompraStat = class
  public
    Codigo: string;
    Nombre: string;
    Compras: Integer;
    TotalUds: Double;
    MediaUds: Double;
    PrecioMedio: Double;
    PrecioMin: Double;
    PrecioMax: Double;
    UltFecha: string;
    DiasUltima: Integer;
    Score: Integer;
    PrecioScore: Integer;
    RecenciaScore: Integer;
    ComprasScore: Integer;
    CantidadScore: Integer;
    EstabilidadScore: Integer;
  end;

  TFLXCompraRecomendacion = class
  public
    CodigoArticulo: string;
    Descripcion: string;
    ProveedorFicha: string;
    ProveedorFichaNombre: string;
    ProveedorActual: string;
    ProveedorActualNombre: string;
    PrecioActual: Double;
    ProveedorRecomendado: string;
    ProveedorRecomendadoNombre: string;
    PrecioRecomendado: Double;
    AhorroPct: Double;
    AhorroUnitario: Double;
    ConsumoAnual: Double;
    AhorroAnual: Double;
    ImpactoScore: Integer;
    Prioridad: string;
    Confianza: Integer;
    IndiceCompra: Integer;
    Accion: string;
    Diagnostico: string;
    MotivoPrincipal: string;
    Motivos: TStringList;
    Proveedores: TList; // TFLXProveedorCompraStat
    constructor Create;
    destructor Destroy; override;
  end;

  TFLXCompraAnalyzer = class
  private
    FConn: TZConnection;
    FTienda: string;
    FMaxFilasSQL: Integer;
    function DBName: string;
    function SQLIdent(const S: string): string;
    function ArtTable: string;
    function CompraLinTable: string;
    function VentaLinTable: string;
    procedure CargarConsumoAnual(AConsumos: TStrings);
    function TableExists(const ATable: string): Boolean;
    function NewStatFromQuery(Q: TZQuery): TFLXProveedorCompraStat;
    function BuscarStat(ARec: TFLXCompraRecomendacion; const ACodigo: string): TFLXProveedorCompraStat;
    function ElegirActual(ARec: TFLXCompraRecomendacion): TFLXProveedorCompraStat;
    function ElegirRecomendado(ARec: TFLXCompraRecomendacion): TFLXProveedorCompraStat;
    procedure CalcularScores(ARec: TFLXCompraRecomendacion);
    procedure FinalizarRecomendacion(ARec: TFLXCompraRecomendacion);
    function ProviderFilterSQL(const P1, P2, P3: string; IncludeOtros: Boolean): string;
    function SelectedProviderMatch(ARec: TFLXCompraRecomendacion; const P1, P2, P3: string): Boolean;
  public
    constructor Create(AConnection: TZConnection; const ATienda: string);
    property MaxFilasSQL: Integer read FMaxFilasSQL write FMaxFilasSQL;
    procedure Analizar(const AFiltro, P1, P2, P3: string; IncludeOtros: Boolean; AResultados: TList; AResumen: TStrings);
    procedure CargarHistoricoArticulo(const ACodigo: string; ADestino: TStrings);
  end;

implementation

constructor TFLXCompraRecomendacion.Create;
begin
  inherited Create;
  Motivos := TStringList.Create;
  Proveedores := TList.Create;
end;

destructor TFLXCompraRecomendacion.Destroy;
var I: Integer;
begin
  for I := 0 to Proveedores.Count - 1 do TObject(Proveedores[I]).Free;
  Proveedores.Free;
  Motivos.Free;
  inherited Destroy;
end;

constructor TFLXCompraAnalyzer.Create(AConnection: TZConnection; const ATienda: string);
begin
  inherited Create;
  FConn := AConnection;
  FTienda := ATienda;
  FMaxFilasSQL := 4000;
end;

function TFLXCompraAnalyzer.DBName: string;
begin
  Result := '';
  if Assigned(FConn) then Result := FConn.Database;
end;

function TFLXCompraAnalyzer.SQLIdent(const S: string): string;
begin
  Result := '`' + StringReplace(S, '`', '', [rfReplaceAll]) + '`';
end;

function TFLXCompraAnalyzer.ArtTable: string;
begin
  Result := 'artitien' + FTienda;
end;

function TFLXCompraAnalyzer.CompraLinTable: string;
begin
  Result := 'hipedidd' + FTienda;
end;

function TFLXCompraAnalyzer.VentaLinTable: string;
begin
  Result := 'hisopdd' + FTienda;
end;

procedure TFLXCompraAnalyzer.CargarConsumoAnual(AConsumos: TStrings);
var Q: TZQuery; TVentas: string;
begin
  if AConsumos = nil then Exit;
  AConsumos.Clear;
  TVentas := VentaLinTable;
  if not TableExists(TVentas) then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT HOD6 COD, ABS(SUM(HOD8)) UDS ' +
      'FROM ' + SQLIdent(TVentas) + ' ' +
      'WHERE HOD6<>'''' AND HOD0 >= DATE_SUB(CURDATE(), INTERVAL 365 DAY) ' +
      'GROUP BY HOD6 LIMIT 50000';
    Q.Open;
    while not Q.EOF do
    begin
      AConsumos.Values[Q.FieldByName('COD').AsString] := FloatToStr(Q.FieldByName('UDS').AsFloat);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

function TFLXCompraAnalyzer.TableExists(const ATable: string): Boolean;
var Q: TZQuery;
begin
  Result := False;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT COUNT(*) C FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=' + QuotedStr(DBName) +
      ' AND TABLE_NAME=' + QuotedStr(ATable);
    Q.Open;
    Result := Q.FieldByName('C').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

function TFLXCompraAnalyzer.NewStatFromQuery(Q: TZQuery): TFLXProveedorCompraStat;
begin
  Result := TFLXProveedorCompraStat.Create;
  Result.Codigo := Q.FieldByName('PROV').AsString;
  Result.Nombre := Q.FieldByName('PROVNOM').AsString;
  Result.Compras := Q.FieldByName('N').AsInteger;
  Result.TotalUds := Q.FieldByName('TOTALUDS').AsFloat;
  Result.MediaUds := Q.FieldByName('AVGUDS').AsFloat;
  Result.PrecioMedio := Q.FieldByName('PRECIOMED').AsFloat;
  Result.PrecioMin := Q.FieldByName('MINPRECIO').AsFloat;
  Result.PrecioMax := Q.FieldByName('MAXPRECIO').AsFloat;
  Result.UltFecha := Q.FieldByName('ULTFECHA').AsString;
  Result.DiasUltima := Q.FieldByName('DIASULTIMA').AsInteger;
end;

function TFLXCompraAnalyzer.BuscarStat(ARec: TFLXCompraRecomendacion; const ACodigo: string): TFLXProveedorCompraStat;
var I: Integer;
begin
  Result := nil;
  for I := 0 to ARec.Proveedores.Count - 1 do
    if TFLXProveedorCompraStat(ARec.Proveedores[I]).Codigo = ACodigo then
      Exit(TFLXProveedorCompraStat(ARec.Proveedores[I]));
end;

function TFLXCompraAnalyzer.ElegirActual(ARec: TFLXCompraRecomendacion): TFLXProveedorCompraStat;
var I: Integer; S: TFLXProveedorCompraStat;
begin
  Result := nil;
  if ARec.ProveedorFicha <> '' then
    Result := BuscarStat(ARec, ARec.ProveedorFicha);
  if Result <> nil then Exit;

  // Si el proveedor de ficha no aparece en el ultimo ano, usamos el proveedor de compra mas reciente.
  for I := 0 to ARec.Proveedores.Count - 1 do
  begin
    S := TFLXProveedorCompraStat(ARec.Proveedores[I]);
    if (Result = nil) or (S.DiasUltima < Result.DiasUltima) then Result := S;
  end;
end;

function TFLXCompraAnalyzer.ElegirRecomendado(ARec: TFLXCompraRecomendacion): TFLXProveedorCompraStat;
var I: Integer; S: TFLXProveedorCompraStat;
begin
  Result := nil;
  for I := 0 to ARec.Proveedores.Count - 1 do
  begin
    S := TFLXProveedorCompraStat(ARec.Proveedores[I]);
    if (Result = nil) or (S.Score > Result.Score) or
       ((S.Score = Result.Score) and (S.PrecioMedio < Result.PrecioMedio)) then
      Result := S;
  end;
end;

procedure TFLXCompraAnalyzer.CalcularScores(ARec: TFLXCompraRecomendacion);
var
  I: Integer;
  S: TFLXProveedorCompraStat;
  MinPrecio, MediaGlobalUds, Ratio, Variacion: Double;
begin
  MinPrecio := 0;
  MediaGlobalUds := 0;
  for I := 0 to ARec.Proveedores.Count - 1 do
  begin
    S := TFLXProveedorCompraStat(ARec.Proveedores[I]);
    if (MinPrecio = 0) or ((S.PrecioMedio > 0) and (S.PrecioMedio < MinPrecio)) then MinPrecio := S.PrecioMedio;
    MediaGlobalUds := MediaGlobalUds + S.MediaUds;
  end;
  if ARec.Proveedores.Count > 0 then MediaGlobalUds := MediaGlobalUds / ARec.Proveedores.Count;

  for I := 0 to ARec.Proveedores.Count - 1 do
  begin
    S := TFLXProveedorCompraStat(ARec.Proveedores[I]);

    S.PrecioScore := 0;
    if (S.PrecioMedio > 0) and (MinPrecio > 0) then
    begin
      Ratio := MinPrecio / S.PrecioMedio;
      S.PrecioScore := Round(40 * Ratio);
      if S.PrecioScore > 40 then S.PrecioScore := 40;
    end;

    if S.DiasUltima <= 30 then S.RecenciaScore := 15
    else if S.DiasUltima <= 90 then S.RecenciaScore := 12
    else if S.DiasUltima <= 180 then S.RecenciaScore := 8
    else if S.DiasUltima <= 365 then S.RecenciaScore := 4
    else S.RecenciaScore := 0;

    if S.Compras >= 6 then S.ComprasScore := 15
    else if S.Compras >= 4 then S.ComprasScore := 12
    else if S.Compras >= 2 then S.ComprasScore := 8
    else S.ComprasScore := 3;

    S.CantidadScore := 0;
    if (S.MediaUds > 0) and (MediaGlobalUds > 0) then
    begin
      if S.MediaUds > MediaGlobalUds then Ratio := MediaGlobalUds / S.MediaUds else Ratio := S.MediaUds / MediaGlobalUds;
      if Ratio >= 0.80 then S.CantidadScore := 15
      else if Ratio >= 0.60 then S.CantidadScore := 11
      else if Ratio >= 0.40 then S.CantidadScore := 7
      else if Ratio >= 0.20 then S.CantidadScore := 3;
    end;

    S.EstabilidadScore := 10;
    if S.PrecioMedio > 0 then
    begin
      Variacion := ((S.PrecioMax - S.PrecioMin) / S.PrecioMedio) * 100;
      if Variacion <= 3 then S.EstabilidadScore := 10
      else if Variacion <= 8 then S.EstabilidadScore := 8
      else if Variacion <= 15 then S.EstabilidadScore := 5
      else if Variacion <= 25 then S.EstabilidadScore := 2
      else S.EstabilidadScore := 0;
    end;

    S.Score := S.PrecioScore + S.RecenciaScore + S.ComprasScore + S.CantidadScore + S.EstabilidadScore;
    if S.Score > 100 then S.Score := 100;
  end;
end;

procedure TFLXCompraAnalyzer.FinalizarRecomendacion(ARec: TFLXCompraRecomendacion);
var
  Actual, Recom: TFLXProveedorCompraStat;
  DiffScore: Integer;
  Variacion: Double;
begin
  CalcularScores(ARec);
  Actual := ElegirActual(ARec);
  Recom := ElegirRecomendado(ARec);
  if (Actual = nil) or (Recom = nil) then Exit;

  ARec.ProveedorActual := Actual.Codigo;
  ARec.ProveedorActualNombre := Actual.Nombre;
  ARec.PrecioActual := Actual.PrecioMedio;
  ARec.ProveedorRecomendado := Recom.Codigo;
  ARec.ProveedorRecomendadoNombre := Recom.Nombre;
  ARec.PrecioRecomendado := Recom.PrecioMedio;
  ARec.IndiceCompra := Recom.Score;
  ARec.Confianza := Recom.Score;

  // Penalizaciones defensivas: evitan recomendaciones por compras aisladas o antiguas.
  if Recom.Compras <= 1 then ARec.Confianza := ARec.Confianza - 25;
  if Recom.DiasUltima > 180 then ARec.Confianza := ARec.Confianza - 15;
  if Recom.CantidadScore < 7 then ARec.Confianza := ARec.Confianza - 15;
  if ARec.Confianza < 0 then ARec.Confianza := 0;

  ARec.AhorroUnitario := ARec.PrecioActual - ARec.PrecioRecomendado;
  if ARec.AhorroUnitario < 0 then ARec.AhorroUnitario := 0;
  ARec.AhorroPct := 0;
  if ARec.PrecioActual > 0 then ARec.AhorroPct := (ARec.AhorroUnitario / ARec.PrecioActual) * 100;

  ARec.Motivos.Clear;
  ARec.Motivos.Add('Actual: ' + Actual.Codigo + ' - ' + Actual.Nombre +
    ' | precio medio ' + FormatFloat('0.00000', Actual.PrecioMedio) +
    ' | compras ' + IntToStr(Actual.Compras) +
    ' | ultima hace ' + IntToStr(Actual.DiasUltima) + ' dias');
  ARec.Motivos.Add('Recomendado: ' + Recom.Codigo + ' - ' + Recom.Nombre +
    ' | precio medio ' + FormatFloat('0.00000', Recom.PrecioMedio) +
    ' | compras ' + IntToStr(Recom.Compras) +
    ' | ultima hace ' + IntToStr(Recom.DiasUltima) + ' dias');
  ARec.Motivos.Add('Puntuacion recomendado: precio ' + IntToStr(Recom.PrecioScore) + '/40, recencia ' +
    IntToStr(Recom.RecenciaScore) + '/15, compras ' + IntToStr(Recom.ComprasScore) +
    '/15, cantidad ' + IntToStr(Recom.CantidadScore) + '/15, estabilidad ' +
    IntToStr(Recom.EstabilidadScore) + '/10');

  if Recom.PrecioMedio < Actual.PrecioMedio then
    ARec.Motivos.Add('El recomendado tiene un precio medio ' + FormatFloat('0.00', ARec.AhorroPct) + ' % inferior.')
  else
    ARec.Motivos.Add('El recomendado no mejora precio; se mantiene por puntuacion global.');

  if Recom.Compras <= 1 then
    ARec.Motivos.Add('Aviso: solo hay una compra comparable del recomendado; confianza reducida.')
  else if Recom.Compras >= 6 then
    ARec.Motivos.Add('Hay base historica suficiente: ' + IntToStr(Recom.Compras) + ' compras comparables.');

  if Recom.DiasUltima > 180 then
    ARec.Motivos.Add('Aviso: la ultima compra del recomendado es antigua; comparar con prudencia.')
  else if Recom.DiasUltima <= 90 then
    ARec.Motivos.Add('La compra recomendada es reciente.');

  if Recom.CantidadScore < 7 then
    ARec.Motivos.Add('Aviso: las cantidades medias no son suficientemente comparables.')
  else
    ARec.Motivos.Add('Las cantidades medias son razonablemente comparables.');

  Variacion := 0;
  if Recom.PrecioMedio > 0 then Variacion := ((Recom.PrecioMax - Recom.PrecioMin) / Recom.PrecioMedio) * 100;
  if Variacion <= 8 then
    ARec.Motivos.Add('Precio estable: variacion aproximada ' + FormatFloat('0.00', Variacion) + ' %.')
  else
    ARec.Motivos.Add('Precio variable: variacion aproximada ' + FormatFloat('0.00', Variacion) + ' %.');

  DiffScore := Recom.Score - Actual.Score;
  if Recom.Codigo = Actual.Codigo then
  begin
    ARec.Accion := 'Mantener proveedor actual';
    ARec.Diagnostico := 'OK';
    ARec.MotivoPrincipal := 'El proveedor actual es la mejor opcion segun el historico.';
  end
  else if (ARec.AhorroPct >= 5) and (ARec.Confianza >= 80) and (DiffScore >= 8) then
  begin
    ARec.Accion := 'Revisar cambio recomendado';
    ARec.Diagnostico := 'CAMBIO CLARO';
    ARec.MotivoPrincipal := 'Ahorro significativo, confianza alta y mejor puntuacion global.';
  end
  else if (ARec.AhorroPct >= 3) and (ARec.Confianza >= 65) then
  begin
    ARec.Accion := 'Posible ahorro: revisar';
    ARec.Diagnostico := 'REVISAR';
    ARec.MotivoPrincipal := 'Puede haber ahorro, pero conviene revisar detalle antes de cambiar.';
  end
  else if (ARec.AhorroPct > 0) then
  begin
    ARec.Accion := 'No cambiar automaticamente';
    ARec.Diagnostico := 'NO FIABLE';
    ARec.MotivoPrincipal := 'El ahorro existe, pero no supera los filtros de confianza/comparabilidad.';
  end
  else
  begin
    ARec.Accion := 'Mantener';
    ARec.Diagnostico := 'OK';
    ARec.MotivoPrincipal := 'No hay ahorro real frente al proveedor actual.';
  end;
  ARec.Motivos.Insert(0, ARec.MotivoPrincipal);
end;

function TFLXCompraAnalyzer.ProviderFilterSQL(const P1, P2, P3: string; IncludeOtros: Boolean): string;
var S: string;
begin
  Result := '';
  if IncludeOtros then Exit;
  S := '';
  if Trim(P1) <> '' then S := QuotedStr(Trim(P1));
  if Trim(P2) <> '' then
  begin
    if S <> '' then S := S + ',';
    S := S + QuotedStr(Trim(P2));
  end;
  if Trim(P3) <> '' then
  begin
    if S <> '' then S := S + ',';
    S := S + QuotedStr(Trim(P3));
  end;
  if S <> '' then Result := ' AND CAST(D.HPD2 AS CHAR) IN (' + S + ') ';
end;

function TFLXCompraAnalyzer.SelectedProviderMatch(ARec: TFLXCompraRecomendacion; const P1, P2, P3: string): Boolean;
var I: Integer; C: string;
begin
  Result := (Trim(P1) = '') and (Trim(P2) = '') and (Trim(P3) = '');
  if Result then Exit;
  for I := 0 to ARec.Proveedores.Count - 1 do
  begin
    C := TFLXProveedorCompraStat(ARec.Proveedores[I]).Codigo;
    if (C = Trim(P1)) or (C = Trim(P2)) or (C = Trim(P3)) then Exit(True);
  end;
end;

procedure TFLXCompraAnalyzer.Analizar(const AFiltro, P1, P2, P3: string; IncludeOtros: Boolean; AResultados: TList; AResumen: TStrings);
var
  Q: TZQuery;
  TArt, TComp, Filtro, WhereSQL, CodActual: string;
  Rec: TFLXCompraRecomendacion;
  Consumos: TStringList;
  TotalArt, Comparables, Cambios: Integer;
  AhorroPotencial, AhorroAnualPotencial: Double;

  procedure FreeResultados;
  var I: Integer;
  begin
    for I := 0 to AResultados.Count - 1 do TObject(AResultados[I]).Free;
    AResultados.Clear;
  end;

  procedure FinalizarRecActual;
  begin
    if Rec = nil then Exit;
    if Rec.Proveedores.Count >= 2 then
    begin
      Inc(Comparables);
      FinalizarRecomendacion(Rec);
      Rec.ConsumoAnual := StrToFloatDef(Consumos.Values[Rec.CodigoArticulo], 0);
      Rec.AhorroAnual := Rec.AhorroUnitario * Rec.ConsumoAnual;

      // Priorizacion por impacto: ayuda a revisar primero lo que mas dinero puede ahorrar.
      Rec.ImpactoScore := 0;
      if Rec.AhorroAnual > 0 then
      begin
        Rec.ImpactoScore := Round(Rec.AhorroAnual);
        if Rec.ImpactoScore > 100 then Rec.ImpactoScore := 100;
      end;
      Rec.Prioridad := 'BAJA';
      if (Rec.Diagnostico = 'CAMBIO CLARO') and (Rec.Confianza >= 80) and
         ((Rec.AhorroAnual >= 100) or ((Rec.AhorroPct >= 8) and (Rec.AhorroAnual >= 50))) then
        Rec.Prioridad := 'ALTA'
      else if ((Rec.Diagnostico = 'CAMBIO CLARO') or (Rec.Diagnostico = 'REVISAR')) and
              (Rec.Confianza >= 65) and ((Rec.AhorroAnual >= 25) or (Rec.AhorroPct >= 5)) then
        Rec.Prioridad := 'MEDIA'
      else if (Rec.AhorroUnitario <= 0) or (Rec.Confianza < 50) then
        Rec.Prioridad := 'BAJA';

      if Rec.AhorroAnual > 0 then
        Rec.Motivos.Add('Prioridad ' + Rec.Prioridad + ': impacto anual estimado ' + FormatFloat('0.00', Rec.AhorroAnual) + ' EUR.');

      if SelectedProviderMatch(Rec, P1, P2, P3) then
      begin
        if (Rec.ProveedorRecomendado <> Rec.ProveedorActual) and (Rec.AhorroPct >= 3) then Inc(Cambios);
        AhorroPotencial := AhorroPotencial + Rec.AhorroUnitario;
        AhorroAnualPotencial := AhorroAnualPotencial + Rec.AhorroAnual;
        AResultados.Add(Rec);
        Rec := nil;
      end;
    end;
    if Rec <> nil then Rec.Free;
    Rec := nil;
  end;

begin
  if AResultados = nil then Exit;
  FreeResultados;
  if AResumen <> nil then AResumen.Clear;

  TArt := ArtTable;
  TComp := CompraLinTable;
  if not TableExists(TComp) then raise Exception.Create('No existe la tabla ' + TComp);
  if not TableExists(TArt) then raise Exception.Create('No existe la tabla ' + TArt);
  if not TableExists('proveedores') then raise Exception.Create('No existe la tabla proveedores');

  Filtro := Trim(AFiltro);
  WhereSQL := ' WHERE D.HPD6<>'''' AND D.HPD10>0 AND D.HPD1 >= DATE_SUB(CURDATE(), INTERVAL 365 DAY) ';
  if Filtro <> '' then
    WhereSQL := WhereSQL + ' AND (D.HPD6 LIKE ' + QuotedStr('%' + Filtro + '%') +
      ' OR COALESCE(A.A1,D.HPD7) LIKE ' + QuotedStr('%' + Filtro + '%') +
      ' OR CAST(D.HPD2 AS CHAR) LIKE ' + QuotedStr('%' + Filtro + '%') +
      ' OR P.P1 LIKE ' + QuotedStr('%' + Filtro + '%') + ') ';
  WhereSQL := WhereSQL + ProviderFilterSQL(P1, P2, P3, IncludeOtros);

  TotalArt := 0; Comparables := 0; Cambios := 0; AhorroPotencial := 0; AhorroAnualPotencial := 0;
  Rec := nil; CodActual := '';
  Consumos := TStringList.Create;
  Consumos.NameValueSeparator := '=';
  CargarConsumoAnual(Consumos);
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT D.HPD6 COD, COALESCE(A.A1,D.HPD7,'''') DES, COALESCE(CAST(A.A32 AS CHAR),'''') PROVFICHA, ' +
      'COALESCE(PF.P1,'''') PROVFICHANOM, CAST(D.HPD2 AS CHAR) PROV, COALESCE(P.P1,'''') PROVNOM, ' +
      'COUNT(*) N, SUM(D.HPD8) TOTALUDS, AVG(D.HPD8) AVGUDS, AVG(D.HPD10) PRECIOMED, ' +
      'MIN(D.HPD10) MINPRECIO, MAX(D.HPD10) MAXPRECIO, MAX(D.HPD1) ULTFECHA, DATEDIFF(CURDATE(), MAX(D.HPD1)) DIASULTIMA ' +
      'FROM ' + SQLIdent(TComp) + ' D ' +
      'LEFT JOIN ' + SQLIdent(TArt) + ' A ON A.A0=D.HPD6 ' +
      'LEFT JOIN proveedores P ON P.P0=D.HPD2 ' +
      'LEFT JOIN proveedores PF ON PF.P0=A.A32 ' + WhereSQL +
      ' GROUP BY D.HPD6, COALESCE(A.A1,D.HPD7,''''), COALESCE(CAST(A.A32 AS CHAR),''''), COALESCE(PF.P1,''''), D.HPD2, P.P1 ' +
      ' ORDER BY D.HPD6, PRECIOMED LIMIT ' + IntToStr(FMaxFilasSQL);
    Q.Open;
    while not Q.EOF do
    begin
      if (CodActual <> '') and (Q.FieldByName('COD').AsString <> CodActual) then
        FinalizarRecActual;
      if Rec = nil then
      begin
        Inc(TotalArt);
        Rec := TFLXCompraRecomendacion.Create;
        CodActual := Q.FieldByName('COD').AsString;
        Rec.CodigoArticulo := CodActual;
        Rec.Descripcion := Q.FieldByName('DES').AsString;
        Rec.ProveedorFicha := Q.FieldByName('PROVFICHA').AsString;
        Rec.ProveedorFichaNombre := Q.FieldByName('PROVFICHANOM').AsString;
      end;
      Rec.Proveedores.Add(NewStatFromQuery(Q));
      Q.Next;
    end;
    FinalizarRecActual;
  finally
    Q.Free;
    Consumos.Free;
  end;

  if AResumen <> nil then
  begin
    AResumen.Add('Asesor Inteligente de Compras - motor v1.8 visual y exportacion');
    AResumen.Add('Articulos leidos: ' + IntToStr(TotalArt));
    AResumen.Add('Articulos comparables: ' + IntToStr(Comparables));
    AResumen.Add('Cambios/ahorros a revisar: ' + IntToStr(Cambios));
    AResumen.Add('Ahorro unitario acumulado orientativo: ' + FormatFloat('0.00000', AhorroPotencial));
    AResumen.Add('Ahorro anual estimado orientativo: ' + FormatFloat('0.00', AhorroAnualPotencial));
    AResumen.Add('Motor explicativo: no recomienda solo por precio, penaliza compras aisladas, antiguas o cantidades no comparables.');
    AResumen.Add('v1.8: mantiene prioridad por impacto y prepara salidas limpias para revision/negociacion.');
    AResumen.Add('Filtro proveedores: ' + P1 + ' ' + P2 + ' ' + P3);
  end;
end;

procedure TFLXCompraAnalyzer.CargarHistoricoArticulo(const ACodigo: string; ADestino: TStrings);
var Q: TZQuery; TComp: string;
begin
  if ADestino = nil then Exit;
  ADestino.Clear;
  if Trim(ACodigo) = '' then Exit;
  TComp := CompraLinTable;
  if not TableExists(TComp) then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT D.HPD1 FECHA, CAST(D.HPD2 AS CHAR) PROV, COALESCE(P.P1,'''') PNOM, D.HPD8 UDS, D.HPD10 COSTE ' +
      'FROM ' + SQLIdent(TComp) + ' D LEFT JOIN proveedores P ON P.P0=D.HPD2 ' +
      'WHERE D.HPD6=' + QuotedStr(ACodigo) + ' AND D.HPD1 >= DATE_SUB(CURDATE(), INTERVAL 365 DAY) ' +
      'ORDER BY D.HPD1 DESC LIMIT 250';
    Q.Open;
    while not Q.EOF do
    begin
      ADestino.Add('  ' + Q.FieldByName('FECHA').AsString + '  ' +
        Q.FieldByName('PROV').AsString + ' - ' + Copy(Q.FieldByName('PNOM').AsString,1,18) +
        '  Uds: ' + FormatFloat('0.##', Q.FieldByName('UDS').AsFloat) +
        '  Coste: ' + FormatFloat('0.00000', Q.FieldByName('COSTE').AsFloat));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
  if ADestino.Count = 0 then ADestino.Add('Sin historico reciente para el articulo ' + ACodigo);
end;

end.
