unit uPromoEngine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DateUtils, Math, DB, ZAbstractConnection, ZConnection,
  ZDataset, StdCtrls;

procedure EnsurePromoTables(const Conn: TZAbstractConnection; const Tienda: string);

function ResolveArticuloPrincipal(const Conn: TZAbstractConnection; const Tienda, Codigo: string): string;

function ApplyPromoToEdits(const Conn: TZAbstractConnection; const Tienda, Articulo, Cliente: string;
  const Familia: Integer; const FechaHora: TDateTime; const EditPvpIva, EditPvpSinIva, EditIvaPct: TEdit): Boolean;

procedure ApplyTicketPromosToTotalEdits(const Conn: TZAbstractConnection; const Tienda: string;
  const VentasLines: TDataSet; const Cliente: string; const FechaHora: TDateTime;
  const Edit12, Edit13, Edit14, Edit15: TEdit);

procedure MarcarPromosCaducadas(const Conn: TZAbstractConnection; const Tienda: string; const FechaHora: TDateTime);

implementation

type
  TPromoTipo = (ptNone, ptPrecioFijo, ptDtoPct, ptNxM, ptSegundaPct, ptPackPrecio);

  TLineAgg = record
    Articulo: string;        // siempre código principal
    Qty: Double;
    PrecioUnitIva: Double;   // precio unitario con IVA guardado en la línea
  end;

function StrToPromoTipo(const S: string): TPromoTipo;
var
  U: string;
begin
  U := UpperCase(Trim(S));
  if (U='PRECIO_FIJO') or (U='PRECIO') then Exit(ptPrecioFijo);
  if (U='DTO_PCT') or (U='DTO') or (U='DESCUENTO') then Exit(ptDtoPct);
  if (U='N_X_M') or (U='NXM') then Exit(ptNxM);
  if (U='SEGUNDA_UND_PCT') or (U='2A_UND_PCT') then Exit(ptSegundaPct);
  if (U='PACK_PRECIO') or (U='PACK') then Exit(ptPackPrecio);
  Result := ptNone;
end;

function SafeStrToFloat(const S: string; const Def: Double = 0): Double;
var
  FS: TFormatSettings;
begin
  FS := DefaultFormatSettings;
  FS.DecimalSeparator := '.';
  try
    Result := StrToFloat(S);
  except
    try
      Result := StrToFloat(StringReplace(S, ',', '.', [rfReplaceAll]), FS);
    except
      Result := Def;
    end;
  end;
end;

function Round2(const V: Double): Double;
begin
  Result := System.Round(V * 100) / 100;
end;

function ResolveArticuloPrincipal(const Conn: TZAbstractConnection; const Tienda, Codigo: string): string;
var
  Q: TZQuery;
  C: string;
begin
  C := Trim(Codigo);
  if C = '' then Exit('');
  Result := C;

  if Conn = nil then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;

    // 1) Si ya existe como A0, lo dejamos tal cual
    try
      Q.SQL.Text := 'SELECT A0 FROM artitien' + Tienda + ' WHERE A0=:c LIMIT 1';
      Q.ParamByName('c').AsString := C;
      Q.Open;
      if not Q.EOF then
        Exit(C);
    except
      Q.Close;
    end;

    Q.Close;

    // 2) Si es un auxiliar / EAN, devolvemos EAN1
    try
      Q.SQL.Text := 'SELECT EAN1 FROM eans WHERE EAN0=:c LIMIT 1';
      Q.ParamByName('c').AsString := C;
      Q.Open;
      if not Q.EOF then
        Result := Trim(Q.FieldByName('EAN1').AsString)
      else
        Result := C;
    except
      Result := C;
    end;
  finally
    Q.Free;
  end;
end;

function PromoArticuloMatchesAnyCode(const Conn: TZAbstractConnection; const Tienda, PromoArticulo, CodigoOriginal, CodigoPrincipal: string): Boolean;
var
  P: string;
begin
  P := Trim(PromoArticulo);

  // Regla sin artículo => genérica
  if P = '' then Exit(True);

  // Coincidencia directa
  if (P = CodigoOriginal) or (P = CodigoPrincipal) then
    Exit(True);

  // Coincidencia por principal (soporta promo guardada con otro EA)
  Result := ResolveArticuloPrincipal(Conn, Tienda, P) = CodigoPrincipal;
end;

procedure EnsurePromoTables(const Conn: TZAbstractConnection; const Tienda: string);
var
  Q: TZQuery;
begin
  if Conn = nil then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;

    // Tabla de reglas pro
    try
      Q.SQL.Text :=
        'CREATE TABLE IF NOT EXISTS promo_rules' + Tienda + ' ('+
        ' id int(11) NOT NULL AUTO_INCREMENT,'+
        ' activo char(1) NOT NULL DEFAULT ''S'','+
        ' prioridad int(11) NOT NULL DEFAULT 0,'+
        ' tipo char(20) NOT NULL DEFAULT ''PRECIO_FIJO'','+
        ' inicio_dt datetime DEFAULT NULL,'+
        ' fin_dt datetime DEFAULT NULL,'+
        ' articulo char(13) DEFAULT '''','+
        ' familia int(11) DEFAULT -1,'+
        ' cliente char(13) DEFAULT '''','+
        ' descripcion char(80) NOT NULL DEFAULT '''','+
        ' texto_ticket char(60) NOT NULL DEFAULT '''','+
        ' precio_fijo double(10,3) NOT NULL DEFAULT 0.000,'+
        ' dto_pct double(5,2) NOT NULL DEFAULT 0.00,'+
        ' n int(11) NOT NULL DEFAULT 0,'+
        ' m int(11) NOT NULL DEFAULT 0,'+
        ' seg_pct double(5,2) NOT NULL DEFAULT 0.00,'+
        ' pack_code char(20) NOT NULL DEFAULT '''','+
        ' created_at datetime DEFAULT CURRENT_TIMESTAMP,'+
        ' updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,'+
        ' PRIMARY KEY (id),'+
        ' KEY k_activo_rango (activo,inicio_dt,fin_dt),'+
        ' KEY k_articulo_rango (articulo,activo,inicio_dt,fin_dt),'+
        ' KEY k_familia_rango (familia,activo,inicio_dt,fin_dt),'+
        ' KEY k_cliente_rango (cliente,activo,inicio_dt,fin_dt),'+
        ' KEY k_tipo_prio (tipo,prioridad)'+
        ') ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;';
      Q.ExecSQL;
    except
      // no bloqueamos ventas por fallo en autocreación
    end;

    // Tabla pack futura
    try
      Q.SQL.Text :=
        'CREATE TABLE IF NOT EXISTS promo_pack_items' + Tienda + ' ('+
        ' id int(11) NOT NULL AUTO_INCREMENT,'+
        ' pack_code char(20) NOT NULL,'+
        ' articulo char(13) NOT NULL,'+
        ' qty double(10,3) NOT NULL DEFAULT 1.000,'+
        ' PRIMARY KEY (id),'+
        ' KEY k_pack (pack_code),'+
        ' KEY k_pack_art (pack_code, articulo)'+
        ') ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;';
      Q.ExecSQL;
    except
    end;
  finally
    Q.Free;
  end;
end;

function GetBestPromoRulesLine(const Conn: TZAbstractConnection; const Tienda, Articulo, Cliente: string;
  const Familia: Integer; const FechaHora: TDateTime; out Tipo: TPromoTipo; out PrecioFijo, DtoPct: Double): Boolean;
var
  Q: TZQuery;
  TableName, ArtPrincipal, PromoArt: string;
begin
  Result := False;
  Tipo := ptNone;
  PrecioFijo := 0;
  DtoPct := 0;

  if Conn = nil then Exit;

  TableName := 'promo_rules' + Tienda;
  ArtPrincipal := ResolveArticuloPrincipal(Conn, Tienda, Articulo);

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;
    Q.SQL.Text :=
      'SELECT tipo, articulo, precio_fijo, dto_pct '+
      'FROM ' + TableName + ' '+
      'WHERE activo=''S'' '+
      '  AND (tipo IN (''PRECIO_FIJO'',''DTO_PCT'')) '+
      '  AND (inicio_dt IS NULL OR inicio_dt<=:fh) '+
      '  AND (fin_dt IS NULL OR fin_dt>=:fh) '+
      '  AND (familia IS NULL OR familia=-1 OR familia=:fam) '+
      '  AND (cliente='''' OR cliente IS NULL OR cliente=:cli) '+
      'ORDER BY prioridad DESC, id DESC';
    Q.ParamByName('fh').AsDateTime := FechaHora;
    Q.ParamByName('fam').AsInteger := Familia;
    Q.ParamByName('cli').AsString := Cliente;
    Q.Open;

    while not Q.EOF do
    begin
      PromoArt := Trim(Q.FieldByName('articulo').AsString);
      if PromoArticuloMatchesAnyCode(Conn, Tienda, PromoArt, Articulo, ArtPrincipal) then
      begin
        Tipo := StrToPromoTipo(Q.FieldByName('tipo').AsString);
        PrecioFijo := Q.FieldByName('precio_fijo').AsFloat;
        DtoPct := Q.FieldByName('dto_pct').AsFloat;
        Exit(Tipo <> ptNone);
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

function GetLegacyPromoPrecio(const Conn: TZAbstractConnection; const Tienda, Articulo: string;
  const FechaHora: TDateTime; out PrecioIva: Double): Boolean;
var
  Q: TZQuery;
  TableName, ArtPrincipal, PromoArt: string;
  D: TDateTime;
begin
  Result := False;
  PrecioIva := 0;

  if Conn = nil then Exit;

  TableName := 'promo' + Tienda;
  ArtPrincipal := ResolveArticuloPrincipal(Conn, Tienda, Articulo);
  D := DateOf(FechaHora);

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;
    Q.SQL.Text :=
      'SELECT P0, P7 '+
      'FROM ' + TableName + ' '+
      'WHERE (P10 IS NULL OR P10='''' OR P10=''A'') '+
      '  AND :d BETWEEN P5 AND P6 '+
      'ORDER BY P6 DESC';
    Q.ParamByName('d').AsDate := D;
    Q.Open;

    while not Q.EOF do
    begin
      PromoArt := Trim(Q.FieldByName('P0').AsString);
      if PromoArticuloMatchesAnyCode(Conn, Tienda, PromoArt, Articulo, ArtPrincipal) then
      begin
        PrecioIva := Q.FieldByName('P7').AsFloat;
        Exit(True);
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

function ApplyPromoToEdits(const Conn: TZAbstractConnection; const Tienda, Articulo, Cliente: string;
  const Familia: Integer; const FechaHora: TDateTime; const EditPvpIva, EditPvpSinIva, EditIvaPct: TEdit): Boolean;
var
  Tipo: TPromoTipo;
  PrecioIva, PrecioSinIva, IvaPct, PrecioFijo, DtoPct, PrecioLegacy: Double;
begin
  Result := False;
  if (Conn = nil) or (Trim(Articulo) = '') then Exit;

  EnsurePromoTables(Conn, Tienda);

  PrecioIva := SafeStrToFloat(EditPvpIva.Text, 0);
  IvaPct := SafeStrToFloat(EditIvaPct.Text, 0);

  // 1) Reglas PRO lineales
  if GetBestPromoRulesLine(Conn, Tienda, Articulo, Cliente, Familia, FechaHora, Tipo, PrecioFijo, DtoPct) then
  begin
    case Tipo of
      ptPrecioFijo:
        PrecioIva := PrecioFijo;
      ptDtoPct:
        if DtoPct > 0 then
          PrecioIva := PrecioIva * (1 - (DtoPct / 100));
    end;

    PrecioIva := Round2(PrecioIva);
    if IvaPct <> 0 then
      PrecioSinIva := PrecioIva / (1 + (IvaPct / 100))
    else
      PrecioSinIva := PrecioIva;

    EditPvpIva.Text := FormatFloat('0.00', PrecioIva);
    EditPvpSinIva.Text := FormatFloat('0.000', PrecioSinIva);
    Exit(True);
  end;

  // 2) Legacy precio fijo
  if GetLegacyPromoPrecio(Conn, Tienda, Articulo, FechaHora, PrecioLegacy) then
  begin
    PrecioIva := Round2(PrecioLegacy);
    if IvaPct <> 0 then
      PrecioSinIva := PrecioIva / (1 + (IvaPct / 100))
    else
      PrecioSinIva := PrecioIva;

    EditPvpIva.Text := FormatFloat('0.00', PrecioIva);
    EditPvpSinIva.Text := FormatFloat('0.000', PrecioSinIva);
    Exit(True);
  end;
end;

function CalcPromoDiscount_NxM(const Qty: Double; const PrecioUnitIva: Double; const N, M: Integer): Double;
var
  Groups, FreeUnits: Integer;
begin
  Result := 0;
  if (N <= 0) or (M <= 0) then Exit(0);
  if N <= M then Exit(0);

  Groups := Trunc(Qty / N);
  if Groups <= 0 then Exit(0);

  FreeUnits := Groups * (N - M);
  Result := FreeUnits * PrecioUnitIva;
end;

function CalcPromoDiscount_SegundaPct(const Qty: Double; const PrecioUnitIva: Double; const SegPct: Double): Double;
var
  Pairs: Integer;
begin
  Result := 0;
  if SegPct <= 0 then Exit(0);

  Pairs := Trunc(Qty / 2);
  if Pairs <= 0 then Exit(0);

  Result := Pairs * PrecioUnitIva * (SegPct / 100);
end;

procedure ApplyTicketPromosToTotalEdits(const Conn: TZAbstractConnection; const Tienda: string;
  const VentasLines: TDataSet; const Cliente: string; const FechaHora: TDateTime;
  const Edit12, Edit13, Edit14, Edit15: TEdit);
var
  Q: TZQuery;
  TableName: string;
  DiscountTotal, ImporteOrig, TotalFinal: Double;
  CurArt, CurPrincipal, RuleArt: string;
  CurQty, CurPvp: Double;
  Agg: array of TLineAgg;
  i, Idx: Integer;

  function GetAggIndex(const Art: string): Integer;
  var
    j: Integer;
  begin
    Result := -1;
    for j := 0 to High(Agg) do
      if Agg[j].Articulo = Art then Exit(j);
  end;

begin
  if (Conn = nil) or (VentasLines = nil) or (not VentasLines.Active) then Exit;

  EnsurePromoTables(Conn, Tienda);

  // Agrupar por artículo principal (soporta líneas metidas por EA)
  SetLength(Agg, 0);
  VentasLines.DisableControls;
  try
    VentasLines.First;
    while not VentasLines.EOF do
    begin
      CurArt := Trim(VentasLines.FieldByName('V3').AsString);
      CurPrincipal := ResolveArticuloPrincipal(Conn, Tienda, CurArt);
      CurQty := VentasLines.FieldByName('V5').AsFloat;
      CurPvp := VentasLines.FieldByName('V6').AsFloat;

      if (CurPrincipal <> '') and (CurQty > 0) and (CurPvp > 0) then
      begin
        Idx := GetAggIndex(CurPrincipal);
        if Idx < 0 then
        begin
          SetLength(Agg, Length(Agg) + 1);
          Agg[High(Agg)].Articulo := CurPrincipal;
          Agg[High(Agg)].Qty := CurQty;
          Agg[High(Agg)].PrecioUnitIva := CurPvp;
        end
        else
        begin
          Agg[Idx].Qty := Agg[Idx].Qty + CurQty;
          Agg[Idx].PrecioUnitIva := CurPvp;
        end;
      end;

      VentasLines.Next;
    end;
  finally
    VentasLines.EnableControls;
  end;

  DiscountTotal := 0;
  TableName := 'promo_rules' + Tienda;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;
    Q.SQL.Text :=
      'SELECT tipo, articulo, n, m, seg_pct '+
      'FROM ' + TableName + ' '+
      'WHERE activo=''S'' '+
      '  AND (tipo IN (''N_X_M'',''SEGUNDA_UND_PCT'')) '+
      '  AND (inicio_dt IS NULL OR inicio_dt<=:fh) '+
      '  AND (fin_dt IS NULL OR fin_dt>=:fh) '+
      '  AND (cliente='''' OR cliente IS NULL OR cliente=:cli) '+
      'ORDER BY prioridad DESC, id DESC';
    Q.ParamByName('fh').AsDateTime := FechaHora;
    Q.ParamByName('cli').AsString := Cliente;
    Q.Open;

    while not Q.EOF do
    begin
      RuleArt := Trim(Q.FieldByName('articulo').AsString);

      // En esta fase aplicamos ticket-level por artículo
      if RuleArt <> '' then
      begin
        RuleArt := ResolveArticuloPrincipal(Conn, Tienda, RuleArt);
        Idx := GetAggIndex(RuleArt);

        if Idx >= 0 then
        begin
          case StrToPromoTipo(Q.FieldByName('tipo').AsString) of
            ptNxM:
              DiscountTotal := DiscountTotal + CalcPromoDiscount_NxM(
                                  Agg[Idx].Qty,
                                  Agg[Idx].PrecioUnitIva,
                                  Q.FieldByName('n').AsInteger,
                                  Q.FieldByName('m').AsInteger);

            ptSegundaPct:
              DiscountTotal := DiscountTotal + CalcPromoDiscount_SegundaPct(
                                  Agg[Idx].Qty,
                                  Agg[Idx].PrecioUnitIva,
                                  Q.FieldByName('seg_pct').AsFloat);
          end;
        end;
      end;

      Q.Next;
    end;
  finally
    Q.Free;
  end;

  DiscountTotal := Round2(DiscountTotal);
  if DiscountTotal <= 0 then Exit;

  ImporteOrig := SafeStrToFloat(Edit12.Text, 0);
  if ImporteOrig <= 0 then Exit;

  TotalFinal := ImporteOrig - DiscountTotal;
  if TotalFinal < 0 then TotalFinal := 0;

  // Edit12 = importe original
  // Edit14 = total tras promo
  // Edit13 = % dto equivalente
  // Edit15 = entrega inicial
  Edit14.Text := FormatFloat('0.00', TotalFinal);
  Edit15.Text := Edit14.Text;

  if ImporteOrig > 0 then
    Edit13.Text := FormatFloat('0.00', ((ImporteOrig - TotalFinal) * 100 / ImporteOrig))
  else
    Edit13.Text := '0.00';
end;

procedure MarcarPromosCaducadas(const Conn: TZAbstractConnection; const Tienda: string; const FechaHora: TDateTime);
var
  Q: TZQuery;
begin
  if Conn = nil then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;
    Q.SQL.Text :=
      'UPDATE promo' + Tienda + ' '+
      'SET P10=''F'' '+
      'WHERE (P10 IS NULL OR P10='''' OR P10=''A'') '+
      '  AND P6 < :d';
    Q.ParamByName('d').AsDate := DateOf(FechaHora);
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

end.
