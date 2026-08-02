unit uFLXPresupuestoPDF;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZAbstractConnection;

procedure FLXVistaPreviaPreProPDF(AOwner: TComponent;
  AConnection: TZAbstractConnection; const ATienda: string;
  const AEsPresupuesto: Boolean; const ACliente: string;
  const AFecha: TDateTime; const ASerie, ANumero, AObservaciones: string);

implementation

uses
  DB, Dialogs, LCLIntf, ZDataset, Global, uFLXPDFPresupuestos;

type
  TFLXIVAResumen = record
    TipoIVA: Double;
    Base: Double;
    Cuota: Double;
    Total: Double;
  end;

  TFLXIVAResumenArray = array of TFLXIVAResumen;

const
  C_MARGEN = 32.0;
  C_ANCHO_UTIL = 531.0;
  C_Y_MIN_LINEAS = 132.0;

function FLXTablaSegura(const APrefijo, ATienda: string): string;
var
  I: Integer;
  S: string;
begin
  S := Trim(ATienda);
  for I := 1 to Length(S) do
    if not (S[I] in ['0'..'9', 'A'..'Z', 'a'..'z', '_']) then
      raise Exception.Create('Código de tienda no válido para generar el PDF.');
  Result := APrefijo + S;
end;

function FLXNombreArchivoSeguro(const S: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
    if S[I] in ['0'..'9', 'A'..'Z', 'a'..'z', '-', '_'] then
      Result := Result + S[I]
    else if S[I] = ' ' then
      Result := Result + '_';
  if Result = '' then
    Result := 'documento';
end;

function FLXImporte(const AValue: Double): string;
begin
  Result := FormatFloat('#,##0.00', AValue) + ' ' + txtMoneda;
end;

function FLXNumero(const AValue: Double; const ADecimales: Integer): string;
begin
  case ADecimales of
    0: Result := FormatFloat('#,##0', AValue);
    1: Result := FormatFloat('#,##0.0', AValue);
    3: Result := FormatFloat('#,##0.000', AValue);
  else
    Result := FormatFloat('#,##0.00', AValue);
  end;
end;

function FLXTextoPlano(const S: string): string;
var
  I: Integer;
  EspacioAnterior: Boolean;
  C: Char;
begin
  Result := '';
  EspacioAnterior := False;
  for I := 1 to Length(S) do
  begin
    C := S[I];
    if C in [#9, #10, #13] then
      C := ' ';
    if C = ' ' then
    begin
      if EspacioAnterior then
        Continue;
      EspacioAnterior := True;
    end
    else
      EspacioAnterior := False;
    Result := Result + C;
  end;
  Result := Trim(Result);
end;

procedure FLXPartirTexto(const ATexto: string; const AMaxCaracteres: Integer;
  ALineas: TStrings);
var
  Resto, Linea, Palabra: string;
  P: Integer;
begin
  ALineas.Clear;
  Resto := FLXTextoPlano(ATexto);
  if Resto = '' then
  begin
    ALineas.Add('');
    Exit;
  end;

  while Resto <> '' do
  begin
    Linea := '';
    while Resto <> '' do
    begin
      P := Pos(' ', Resto);
      if P = 0 then
      begin
        Palabra := Resto;
        Resto := '';
      end
      else
      begin
        Palabra := Copy(Resto, 1, P - 1);
        Delete(Resto, 1, P);
        Resto := TrimLeft(Resto);
      end;

      if (Linea = '') and (Length(Palabra) > AMaxCaracteres) then
      begin
        Linea := Copy(Palabra, 1, AMaxCaracteres);
        Palabra := Copy(Palabra, AMaxCaracteres + 1, MaxInt);
        if Palabra <> '' then
          if Resto <> '' then
            Resto := Palabra + ' ' + Resto
          else
            Resto := Palabra;
        Break;
      end;

      if (Linea <> '') and (Length(Linea) + 1 + Length(Palabra) > AMaxCaracteres) then
      begin
        if Resto <> '' then
          Resto := Palabra + ' ' + Resto
        else
          Resto := Palabra;
        Break;
      end;

      if Linea = '' then
        Linea := Palabra
      else
        Linea := Linea + ' ' + Palabra;
    end;
    ALineas.Add(Linea);
  end;
end;

procedure FLXAcumularIVA(var AResumen: TFLXIVAResumenArray;
  const ATipo, ABase, ATotal: Double);
var
  I, N: Integer;
begin
  for I := 0 to High(AResumen) do
    if Abs(AResumen[I].TipoIVA - ATipo) < 0.0001 then
    begin
      AResumen[I].Base := AResumen[I].Base + ABase;
      AResumen[I].Cuota := AResumen[I].Cuota + (ATotal - ABase);
      AResumen[I].Total := AResumen[I].Total + ATotal;
      Exit;
    end;

  N := Length(AResumen);
  SetLength(AResumen, N + 1);
  AResumen[N].TipoIVA := ATipo;
  AResumen[N].Base := ABase;
  AResumen[N].Cuota := ATotal - ABase;
  AResumen[N].Total := ATotal;
end;

procedure FLXDibujarCabecera(APDF: TFLXPDFDocument; var AY: Double;
  const ATitulo, AClienteCodigo, AClienteNombre, AClienteNIF,
  AClienteDireccion, AClienteLocalidad, AClienteCP, AClienteProvincia,
  ASerie, ANumero: string; const AFecha: TDateTime;
  const AContinuacion: Boolean);
var
  DocTexto, LocalidadCompleta: string;
begin
  APDF.NewPage;

  APDF.SetFillColor(0.04, 0.29, 0.32);
  APDF.FillRect(0, 770, APDF.PageWidth, 72);
  APDF.SetFillColor(1, 1, 1);
  APDF.Text(C_MARGEN, 812, 18, Empresa, True);
  APDF.Text(C_MARGEN, 791, 9, Trim(Direccion + ' - ' + CP + ' ' + Localidad), False);
  APDF.Text(C_MARGEN, 777, 8, 'NIF: ' + Nif + '   Tel.: ' + Telefono + '   ' + EMail, False);

  APDF.SetFillColor(0.88, 0.95, 0.95);
  APDF.FillRect(390, 780, 173, 48);
  APDF.SetFillColor(0.04, 0.24, 0.27);
  APDF.TextCenter(476.5, 810, 13, ATitulo, True);
  DocTexto := Trim(ASerie) + '-' + Trim(ANumero);
  if AContinuacion then
    DocTexto := DocTexto + '  (continuación)';
  APDF.TextCenter(476.5, 792, 10, DocTexto, True);
  APDF.TextCenter(476.5, 779, 8, FormatDateTime('dd/mm/yyyy', AFecha), False);

  APDF.SetFillColor(0.97, 0.98, 0.98);
  APDF.FillRect(C_MARGEN, 678, C_ANCHO_UTIL, 75);
  APDF.SetStrokeColor(0.78, 0.84, 0.85);
  APDF.SetLineWidth(0.7);
  APDF.StrokeRect(C_MARGEN, 678, C_ANCHO_UTIL, 75);
  APDF.SetFillColor(0.04, 0.29, 0.32);
  APDF.Text(44, 736, 9, 'CLIENTE', True);
  APDF.SetFillColor(0.16, 0.18, 0.20);
  APDF.Text(44, 716, 11, AClienteNombre, True);
  APDF.TextRight(551, 716, 9, 'Código: ' + AClienteCodigo, False);
  APDF.TextRight(551, 700, 9, 'NIF/CIF: ' + AClienteNIF, False);
  APDF.Text(44, 699, 9, AClienteDireccion, False);
  LocalidadCompleta := Trim(AClienteCP + ' ' + AClienteLocalidad);
  if Trim(AClienteProvincia) <> '' then
    LocalidadCompleta := Trim(LocalidadCompleta + ' - ' + AClienteProvincia);
  APDF.Text(44, 684, 9, LocalidadCompleta, False);

  AY := 652;
end;

procedure FLXDibujarCabeceraTabla(APDF: TFLXPDFDocument; var AY: Double);
begin
  APDF.SetFillColor(0.11, 0.37, 0.40);
  APDF.FillRect(C_MARGEN, AY - 17, C_ANCHO_UTIL, 21);
  APDF.SetFillColor(1, 1, 1);
  APDF.Text(38, AY - 10, 8, 'Código', True);
  APDF.Text(95, AY - 10, 8, 'Descripción', True);
  APDF.TextRight(386, AY - 10, 8, 'Cant.', True);
  APDF.TextRight(442, AY - 10, 8, 'PVP', True);
  APDF.TextRight(482, AY - 10, 8, 'Dto.', True);
  APDF.TextRight(518, AY - 10, 8, 'IVA', True);
  APDF.TextRight(557, AY - 10, 8, 'Total', True);
  AY := AY - 23;
end;

procedure FLXDibujarLinea(APDF: TFLXPDFDocument; var AY: Double;
  const AIndice: Integer; const ACodigo, ADescripcion: string;
  const ACantidad, APVP, ADescuento, AIVA, ATotal: Double;
  ADescripcionPartida: TStrings);
var
  Alto, TextoY: Double;
  I: Integer;
begin
  FLXPartirTexto(ADescripcion, 47, ADescripcionPartida);
  Alto := 18;
  if ADescripcionPartida.Count > 1 then
    Alto := 28;

  if Odd(AIndice) then
  begin
    APDF.SetFillColor(0.965, 0.975, 0.977);
    APDF.FillRect(C_MARGEN, AY - Alto + 4, C_ANCHO_UTIL, Alto);
  end;

  APDF.SetFillColor(0.15, 0.17, 0.18);
  TextoY := AY - 8;
  APDF.Text(38, TextoY, 7.8, ACodigo, False);
  for I := 0 to ADescripcionPartida.Count - 1 do
  begin
    if I > 1 then
      Break;
    APDF.Text(95, TextoY - (I * 10), 7.8, ADescripcionPartida[I], False);
  end;
  APDF.TextRight(386, TextoY, 7.8, FLXNumero(ACantidad, 3), False);
  APDF.TextRight(442, TextoY, 7.8, FLXNumero(APVP, 2), False);
  if Abs(ADescuento) > 0.0001 then
    APDF.TextRight(482, TextoY, 7.8, FLXNumero(ADescuento, 2) + '%', False)
  else
    APDF.TextRight(482, TextoY, 7.8, '-', False);
  APDF.TextRight(518, TextoY, 7.8, FLXNumero(AIVA, 0) + '%', False);
  APDF.TextRight(557, TextoY, 7.8, FLXNumero(ATotal, 2), True);

  APDF.SetStrokeColor(0.88, 0.90, 0.91);
  APDF.SetLineWidth(0.35);
  APDF.Line(C_MARGEN, AY - Alto + 4, C_MARGEN + C_ANCHO_UTIL, AY - Alto + 4);
  AY := AY - Alto;
end;

procedure FLXDibujarTotales(APDF: TFLXPDFDocument; var AY: Double;
  const AResumen: TFLXIVAResumenArray; const ASubtotal, ADescuentos,
  ABase, AIVA, ATotal: Double; const AObservaciones: string);
var
  I: Integer;
  YIVA, YTot: Double;
  Obs: TStringList;
  J: Integer;
begin
  if AY > 300 then
    AY := 286;

  APDF.SetFillColor(0.97, 0.98, 0.98);
  APDF.FillRect(C_MARGEN, 112, 300, 158);
  APDF.SetStrokeColor(0.80, 0.84, 0.85);
  APDF.StrokeRect(C_MARGEN, 112, 300, 158);
  APDF.SetFillColor(0.04, 0.29, 0.32);
  APDF.Text(44, 250, 9, 'DESGLOSE DE IMPUESTOS', True);
  APDF.SetFillColor(0.28, 0.31, 0.32);
  APDF.Text(44, 232, 8, 'IVA', True);
  APDF.TextRight(160, 232, 8, 'Base', True);
  APDF.TextRight(238, 232, 8, 'Cuota', True);
  APDF.TextRight(322, 232, 8, 'Total', True);
  YIVA := 215;
  for I := 0 to High(AResumen) do
  begin
    APDF.Text(44, YIVA, 8, FLXNumero(AResumen[I].TipoIVA, 2) + '%', False);
    APDF.TextRight(160, YIVA, 8, FLXNumero(AResumen[I].Base, 2), False);
    APDF.TextRight(238, YIVA, 8, FLXNumero(AResumen[I].Cuota, 2), False);
    APDF.TextRight(322, YIVA, 8, FLXNumero(AResumen[I].Total, 2), False);
    YIVA := YIVA - 15;
    if YIVA < 160 then
      Break;
  end;

  if Trim(AObservaciones) <> '' then
  begin
    APDF.SetFillColor(0.04, 0.29, 0.32);
    APDF.Text(44, 146, 8, 'OBSERVACIONES', True);
    APDF.SetFillColor(0.25, 0.27, 0.28);
    Obs := TStringList.Create;
    try
      FLXPartirTexto(AObservaciones, 65, Obs);
      for J := 0 to Obs.Count - 1 do
      begin
        if J > 2 then
          Break;
        APDF.Text(44, 132 - (J * 10), 7.4, Obs[J], False);
      end;
    finally
      Obs.Free;
    end;
  end;

  APDF.SetFillColor(0.94, 0.97, 0.97);
  APDF.FillRect(350, 151, 213, 119);
  APDF.SetStrokeColor(0.70, 0.79, 0.80);
  APDF.StrokeRect(350, 151, 213, 119);
  APDF.SetFillColor(0.25, 0.28, 0.29);
  YTot := 248;
  APDF.Text(365, YTot, 8.5, 'Subtotal', False);
  APDF.TextRight(548, YTot, 8.5, FLXImporte(ASubtotal), False);
  YTot := YTot - 19;
  if Abs(ADescuentos) > 0.005 then
  begin
    APDF.Text(365, YTot, 8.5, 'Descuentos', False);
    APDF.TextRight(548, YTot, 8.5, '-' + FLXImporte(Abs(ADescuentos)), False);
    YTot := YTot - 19;
  end;
  APDF.Text(365, YTot, 8.5, 'Base imponible', False);
  APDF.TextRight(548, YTot, 8.5, FLXImporte(ABase), False);
  YTot := YTot - 19;
  APDF.Text(365, YTot, 8.5, 'IVA', False);
  APDF.TextRight(548, YTot, 8.5, FLXImporte(AIVA), False);

  APDF.SetFillColor(0.04, 0.29, 0.32);
  APDF.FillRect(350, 112, 213, 35);
  APDF.SetFillColor(1, 1, 1);
  APDF.Text(365, 124, 12, 'TOTAL', True);
  APDF.TextRight(548, 124, 13, FLXImporte(ATotal), True);

  APDF.SetFillColor(0.40, 0.43, 0.44);
  APDF.Text(C_MARGEN, 88, 7.5,
    'Documento comercial no fiscal. Validez sujeta a las condiciones indicadas por la empresa.', False);
end;

procedure FLXVistaPreviaPreProPDF(AOwner: TComponent;
  AConnection: TZAbstractConnection; const ATienda: string;
  const AEsPresupuesto: Boolean; const ACliente: string;
  const AFecha: TDateTime; const ASerie, ANumero, AObservaciones: string);
var
  QCabecera, QLineas, QCliente: TZQuery;
  PDF: TFLXPDFDocument;
  LineasDesc: TStringList;
  ResumenIVA: TFLXIVAResumenArray;
  TablaCabecera, TablaDetalle, TipoDocumento, NombrePDF: string;
  ClienteNombre, ClienteNIF, ClienteDireccion, ClienteLocalidad,
    ClienteCP, ClienteProvincia: string;
  Y, Cantidad, PVP, PrecioSinIVA, Dto, BaseLinea, TipoIVA,
    TotalLinea, Subtotal, Descuentos, BaseTotal, IVATotal,
    TotalDocumento, BrutoLinea, AltoNecesario: Double;
  Indice: Integer;
begin
  if not Assigned(AConnection) then
    raise Exception.Create('No hay conexión disponible para generar el PDF.');
  if Trim(ACliente) = '' then
    raise Exception.Create('Falta el cliente del presupuesto/proforma.');
  if Trim(ASerie) = '' then
    raise Exception.Create('Falta la serie del presupuesto/proforma.');
  if Trim(ANumero) = '' then
    raise Exception.Create('Falta el número del presupuesto/proforma.');

  if AEsPresupuesto then
  begin
    TipoDocumento := 'PRESUPUESTO';
    TablaCabecera := FLXTablaSegura('presuc', ATienda);
    TablaDetalle := FLXTablaSegura('presud', ATienda);
  end
  else
  begin
    TipoDocumento := 'FACTURA PROFORMA';
    TablaCabecera := FLXTablaSegura('proforc', ATienda);
    TablaDetalle := FLXTablaSegura('proford', ATienda);
  end;

  QCabecera := TZQuery.Create(nil);
  QCliente := TZQuery.Create(nil);
  QLineas := TZQuery.Create(nil);
  PDF := TFLXPDFDocument.Create;
  LineasDesc := TStringList.Create;
  try
    // La cabecera y el detalle se validan dentro del mismo tipo documental.
    // Por tanto, presupuesto 3 y proforma 3 son documentos independientes y
    // nunca comparten líneas aunque coincidan cliente, fecha, serie y número.
    QCabecera.Connection := AConnection;
    QCabecera.SQL.Text :=
      'SELECT PRC0 FROM ' + TablaCabecera +
      ' WHERE PRC0=:pCliente AND PRC1=:pFecha ' +
      'AND PRC2=:pSerie AND PRC3=:pNumero LIMIT 1';
    QCabecera.ParamByName('pCliente').AsString := Trim(ACliente);
    QCabecera.ParamByName('pFecha').AsDate := Trunc(AFecha);
    QCabecera.ParamByName('pSerie').AsString := Trim(ASerie);
    QCabecera.ParamByName('pNumero').AsString := Trim(ANumero);
    QCabecera.Open;
    if QCabecera.IsEmpty then
      raise Exception.Create('No existe la cabecera del ' + LowerCase(TipoDocumento) +
        ' seleccionado.');

    QCliente.Connection := AConnection;
    QCliente.SQL.Text :=
      'SELECT C0,C1,C3,C4,C5,C37,C38 FROM clientes WHERE C0=:pCliente LIMIT 1';
    QCliente.ParamByName('pCliente').AsString := Trim(ACliente);
    QCliente.Open;
    if not QCliente.IsEmpty then
    begin
      ClienteNombre := QCliente.FieldByName('C1').AsString;
      ClienteDireccion := QCliente.FieldByName('C3').AsString;
      ClienteLocalidad := QCliente.FieldByName('C4').AsString;
      ClienteNIF := QCliente.FieldByName('C5').AsString;
      ClienteCP := QCliente.FieldByName('C37').AsString;
      ClienteProvincia := QCliente.FieldByName('C38').AsString;
    end
    else
      ClienteNombre := 'Cliente ' + Trim(ACliente);

    QLineas.Connection := AConnection;
    QLineas.SQL.Text :=
      'SELECT PRD4,PRD5,PRD6,PRD7,PRD8,PRD9,PRD10,PRD11,PRD12,PRD13 ' +
      'FROM ' + TablaDetalle + ' WHERE PRD0=:pCliente AND PRD1=:pFecha ' +
      'AND PRD2=:pSerie AND PRD3=:pNumero ORDER BY PRD4';
    QLineas.ParamByName('pCliente').AsString := Trim(ACliente);
    QLineas.ParamByName('pFecha').AsDate := Trunc(AFecha);
    QLineas.ParamByName('pSerie').AsString := Trim(ASerie);
    QLineas.ParamByName('pNumero').AsString := Trim(ANumero);
    QLineas.Open;
    if QLineas.IsEmpty then
      raise Exception.Create('El presupuesto/proforma no tiene líneas para generar el PDF.');

    SetLength(ResumenIVA, 0);
    Subtotal := 0;
    Descuentos := 0;
    BaseTotal := 0;
    IVATotal := 0;
    TotalDocumento := 0;

    FLXDibujarCabecera(PDF, Y, TipoDocumento, Trim(ACliente), ClienteNombre,
      ClienteNIF, ClienteDireccion, ClienteLocalidad, ClienteCP,
      ClienteProvincia, Trim(ASerie), Trim(ANumero), AFecha, False);
    FLXDibujarCabeceraTabla(PDF, Y);

    QLineas.First;
    Indice := 0;
    while not QLineas.EOF do
    begin
      Cantidad := QLineas.FieldByName('PRD7').AsFloat;
      PVP := QLineas.FieldByName('PRD8').AsFloat;
      PrecioSinIVA := QLineas.FieldByName('PRD9').AsFloat;
      Dto := QLineas.FieldByName('PRD10').AsFloat;
      BaseLinea := QLineas.FieldByName('PRD11').AsFloat;
      TipoIVA := QLineas.FieldByName('PRD12').AsFloat;
      TotalLinea := QLineas.FieldByName('PRD13').AsFloat;

      FLXPartirTexto(QLineas.FieldByName('PRD6').AsString, 47, LineasDesc);
      if LineasDesc.Count > 1 then
        AltoNecesario := 28
      else
        AltoNecesario := 18;

      if Y - AltoNecesario < C_Y_MIN_LINEAS then
      begin
        FLXDibujarCabecera(PDF, Y, TipoDocumento, Trim(ACliente), ClienteNombre,
          ClienteNIF, ClienteDireccion, ClienteLocalidad, ClienteCP,
          ClienteProvincia, Trim(ASerie), Trim(ANumero), AFecha, True);
        FLXDibujarCabeceraTabla(PDF, Y);
      end;

      FLXDibujarLinea(PDF, Y, Indice,
        QLineas.FieldByName('PRD5').AsString,
        QLineas.FieldByName('PRD6').AsString,
        Cantidad, PVP, Dto, TipoIVA, TotalLinea, LineasDesc);

      BrutoLinea := Cantidad * PrecioSinIVA;
      Subtotal := Subtotal + BrutoLinea;
      Descuentos := Descuentos + (BrutoLinea - BaseLinea);
      BaseTotal := BaseTotal + BaseLinea;
      IVATotal := IVATotal + (TotalLinea - BaseLinea);
      TotalDocumento := TotalDocumento + TotalLinea;
      FLXAcumularIVA(ResumenIVA, TipoIVA, BaseLinea, TotalLinea);

      Inc(Indice);
      QLineas.Next;
    end;

    if Y < 310 then
    begin
      FLXDibujarCabecera(PDF, Y, TipoDocumento, Trim(ACliente), ClienteNombre,
        ClienteNIF, ClienteDireccion, ClienteLocalidad, ClienteCP,
        ClienteProvincia, Trim(ASerie), Trim(ANumero), AFecha, True);
    end;
    FLXDibujarTotales(PDF, Y, ResumenIVA, Subtotal, Descuentos,
      BaseTotal, IVATotal, TotalDocumento, AObservaciones);

    PDF.AddPageNumbers('FacturLinEx - ' + TipoDocumento + ' ' +
      Trim(ASerie) + '-' + Trim(ANumero));

    NombrePDF := IncludeTrailingPathDelimiter(GetTempDir(False)) +
      'FacturLinEx_' + FLXNombreArchivoSeguro(TipoDocumento) + '_' +
      FLXNombreArchivoSeguro(Trim(ASerie)) + '_' +
      FLXNombreArchivoSeguro(Trim(ANumero)) + '_' +
      FormatDateTime('yyyymmdd_hhnnss', Now) + '.pdf';
    PDF.SaveToFile(NombrePDF);

    if not OpenDocument(NombrePDF) then
      ShowMessage('PDF generado correctamente en:'#13#10 + NombrePDF +
        #13#10#13#10 + 'No se pudo abrir automáticamente el visor PDF.');
  finally
    LineasDesc.Free;
    PDF.Free;
    QLineas.Free;
    QCliente.Free;
    QCabecera.Free;
  end;
end;

end.
