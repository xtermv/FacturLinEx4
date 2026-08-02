unit uFLXInformeCreditosPDF;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, LCLIntf, LazUTF8,
  ZAbstractConnection, ZDataset, Global, uFLXPDFCreditos;

procedure FLXVistaPreviaEstadoCuentaCreditos(AOwner: TComponent;
  AConnection: TZAbstractConnection; const ATienda, ACodigoCliente,
  ANombreCliente, AClienteNIF, AClienteDireccion, AClienteLocalidad,
  AClienteProvincia: string);

implementation

type
  TFLXAmbitoInforme = (faiTodo, faiMarcadas);

function FLXTablaCreditos(const ATienda: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(ATienda) do
    if ATienda[I] in ['0'..'9'] then
      Result := Result + ATienda[I];
  if Result = '' then
    Result := '0000';
  Result := 'creditos' + Result;
end;

function FLXTextoLimpio(const ATexto: string): string;
begin
  Result := StringReplace(ATexto, #13, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #10, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #9, ' ', [rfReplaceAll]);
  while Pos('  ', Result) > 0 do
    Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
  Result := Trim(Result);
end;

function FLXCortar(const ATexto: string; ALongitud: Integer): string;
begin
  Result := FLXTextoLimpio(ATexto);
  if UTF8Length(Result) > ALongitud then
    Result := UTF8Copy(Result, 1, ALongitud - 3) + '...';
end;

function FLXImporte(const AValor: Double): string;
begin
  Result := FormatFloat('#,##0.00', AValor);
end;

function FLXDocumento(Q: TZQuery): string;
var
  TipoDoc, SerieDoc, NumeroDoc: string;
begin
  TipoDoc := Trim(Q.FieldByName('CRE3').AsString);
  SerieDoc := Trim(Q.FieldByName('CRE4').AsString);
  NumeroDoc := Trim(Q.FieldByName('CRE5').AsString);

  Result := TipoDoc;
  if SerieDoc <> '' then
    Result := Result + ' ' + SerieDoc;
  if NumeroDoc <> '' then
    Result := Result + '/' + NumeroDoc;
end;

function FLXContarMarcadas(AConnection: TZAbstractConnection;
  const ATabla, ACodigoCliente: string): Integer;
var
  Q: TZQuery;
begin
  Result := 0;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;
    Q.SQL.Text := 'SELECT COUNT(*) AS N FROM `' + ATabla +
      '` WHERE CRE0=:CLIENTE AND CRE9=''S''';
    Q.ParamByName('CLIENTE').AsString := ACodigoCliente;
    Q.Open;
    Result := Q.FieldByName('N').AsInteger;
  finally
    Q.Free;
  end;
end;

function FLXElegirAmbito(AConnection: TZAbstractConnection;
  const ATabla, ACodigoCliente: string;
  out AAmbito: TFLXAmbitoInforme): Boolean;
var
  Marcadas: Integer;
  Respuesta: TModalResult;
begin
  Result := False;
  AAmbito := faiTodo;
  Marcadas := FLXContarMarcadas(AConnection, ATabla, ACodigoCliente);

  if Marcadas = 0 then
  begin
    Result := True;
    Exit;
  end;

  Respuesta := MessageDlg(
    'Hay ' + IntToStr(Marcadas) + ' linea(s) marcada(s) en rojo.' +
    LineEnding + LineEnding +
    'Si: generar solo las lineas marcadas.' + LineEnding +
    'No: generar el estado de cuenta completo.' + LineEnding +
    'Cancelar: no generar el informe.',
    mtConfirmation, [mbYes, mbNo, mbCancel], 0);

  case Respuesta of
    mrYes:
      begin
        AAmbito := faiMarcadas;
        Result := True;
      end;
    mrNo:
      begin
        AAmbito := faiTodo;
        Result := True;
      end;
  end;
end;

function FLXArchivoTemporal(const ACodigoCliente: string): string;
begin
  Result := IncludeTrailingPathDelimiter(GetTempDir(False)) +
    'FacturLinEx_Estado_Cuenta_' + ACodigoCliente + '_' +
    FormatDateTime('yyyymmdd_hhnnss', Now) + '.pdf';
end;

procedure FLXDibujarCabecera(APDF: TFLXCreditosPDFDocument; var AY: Double;
  const ATitulo, ACodigoCliente, ANombreCliente, AClienteNIF,
  AClienteDireccion, AClienteLocalidad, AClienteProvincia: string;
  AContinuacion: Boolean);
var
  EmpresaLinea, ClienteLinea, DomicilioLinea: string;
begin
  APDF.NewPage;

  APDF.SetFillColor(0.05, 0.25, 0.28);
  APDF.FillRect(0, APDF.PageHeight - 64, APDF.PageWidth, 64);
  APDF.SetFillColor(1, 1, 1);
  APDF.Text(28, APDF.PageHeight - 30, 17, Empresa, True);
  APDF.Text(28, APDF.PageHeight - 50, 11, ATitulo, True);
  if AContinuacion then
    APDF.TextRight(APDF.PageWidth - 28, APDF.PageHeight - 49, 9,
      'Continuacion', True);

  APDF.SetFillColor(0.12, 0.15, 0.18);
  EmpresaLinea := '';
  if Trim(Nif) <> '' then
    EmpresaLinea := 'NIF: ' + Nif;
  if Trim(Direccion) <> '' then
  begin
    if EmpresaLinea <> '' then
      EmpresaLinea := EmpresaLinea + ' - ';
    EmpresaLinea := EmpresaLinea + Direccion;
  end;
  if Trim(Localidad) <> '' then
    EmpresaLinea := EmpresaLinea + ' - ' + Localidad;
  if EmpresaLinea <> '' then
    APDF.Text(28, APDF.PageHeight - 82, 8, EmpresaLinea, False);

  APDF.SetFillColor(0.95, 0.97, 0.98);
  APDF.FillRect(28, APDF.PageHeight - 146, APDF.PageWidth - 56, 50);
  APDF.SetStrokeColor(0.78, 0.82, 0.84);
  APDF.StrokeRect(28, APDF.PageHeight - 146, APDF.PageWidth - 56, 50);

  ClienteLinea := 'Cliente ' + ACodigoCliente + ' - ' + ANombreCliente;
  APDF.SetFillColor(0.05, 0.25, 0.28);
  APDF.Text(40, APDF.PageHeight - 116, 12,
    FLXCortar(ClienteLinea, 78), True);

  DomicilioLinea := Trim(AClienteDireccion);
  if Trim(AClienteLocalidad) <> '' then
  begin
    if DomicilioLinea <> '' then
      DomicilioLinea := DomicilioLinea + ' - ';
    DomicilioLinea := DomicilioLinea + AClienteLocalidad;
  end;
  if Trim(AClienteProvincia) <> '' then
    DomicilioLinea := DomicilioLinea + ' (' + AClienteProvincia + ')';
  if Trim(AClienteNIF) <> '' then
    DomicilioLinea := 'NIF: ' + AClienteNIF + ' - ' + DomicilioLinea;
  APDF.SetFillColor(0.23, 0.27, 0.30);
  APDF.Text(40, APDF.PageHeight - 135, 8,
    FLXCortar(DomicilioLinea, 112), False);

  APDF.TextRight(APDF.PageWidth - 28, APDF.PageHeight - 82, 8,
    'Generado: ' + FormatDateTime('dd/mm/yyyy hh:nn', Now), False);

  AY := APDF.PageHeight - 172;
end;

procedure FLXDibujarCabeceraTabla(APDF: TFLXCreditosPDFDocument;
  var AY: Double);
begin
  APDF.SetFillColor(0.10, 0.36, 0.40);
  APDF.FillRect(28, AY - 18, APDF.PageWidth - 56, 20);
  APDF.SetFillColor(1, 1, 1);
  APDF.TextCenter(38, AY - 12, 7, 'M', True);
  APDF.Text(49, AY - 12, 7, 'FECHA', True);
  APDF.Text(107, AY - 12, 7, 'HORA', True);
  APDF.Text(151, AY - 12, 7, 'DOCUMENTO', True);
  APDF.Text(242, AY - 12, 7, 'DESCRIPCION', True);
  APDF.TextRight(636, AY - 12, 7, 'DEBE', True);
  APDF.TextRight(718, AY - 12, 7, 'HABER', True);
  APDF.TextRight(813, AY - 12, 7, 'SALDO', True);
  AY := AY - 28;
end;

procedure FLXDibujarFila(APDF: TFLXCreditosPDFDocument; var AY: Double;
  Q: TZQuery; const ASaldo: Double; AIndice: Integer);
var
  Marcada: Boolean;
  FechaTexto, HoraTexto, Descripcion: string;
begin
  Marcada := SameText(Trim(Q.FieldByName('CRE9').AsString), 'S');

  if Marcada then
  begin
    APDF.SetFillColor(1.00, 0.91, 0.91);
    APDF.FillRect(28, AY - 3, APDF.PageWidth - 56, 18);
    APDF.SetFillColor(0.72, 0.11, 0.11);
    APDF.FillRect(28, AY - 3, 3, 18);
  end
  else if Odd(AIndice) then
  begin
    APDF.SetFillColor(0.97, 0.98, 0.99);
    APDF.FillRect(28, AY - 3, APDF.PageWidth - 56, 18);
  end;

  FechaTexto := '';
  if not Q.FieldByName('CRE1').IsNull then
    FechaTexto := FormatDateTime('dd/mm/yy',
      Q.FieldByName('CRE1').AsDateTime);
  HoraTexto := '';
  if not Q.FieldByName('CRE2').IsNull then
    HoraTexto := FormatDateTime('hh:nn',
      Q.FieldByName('CRE2').AsDateTime);
  Descripcion := FLXCortar(Q.FieldByName('CRE6').AsString, 58);

  APDF.SetFillColor(0.10, 0.13, 0.16);
  if Marcada then
    APDF.TextCenter(38, AY + 2, 8, 'X', True);
  APDF.Text(49, AY + 2, 7.5, FechaTexto, False);
  APDF.Text(107, AY + 2, 7.5, HoraTexto, False);
  APDF.Text(151, AY + 2, 7.5,
    FLXCortar(FLXDocumento(Q), 17), False);
  APDF.Text(242, AY + 2, 7.5, Descripcion, Marcada);
  APDF.TextRight(636, AY + 2, 7.5,
    FLXImporte(Q.FieldByName('CRE7').AsFloat), False);
  APDF.TextRight(718, AY + 2, 7.5,
    FLXImporte(Q.FieldByName('CRE8').AsFloat), False);

  if ASaldo > 0.004 then
    APDF.SetFillColor(0.75, 0.10, 0.10)
  else if ASaldo < -0.004 then
    APDF.SetFillColor(0.10, 0.32, 0.78)
  else
    APDF.SetFillColor(0.10, 0.13, 0.16);
  APDF.TextRight(813, AY + 2, 7.5, FLXImporte(ASaldo), True);

  APDF.SetStrokeColor(0.88, 0.90, 0.91);
  APDF.SetLineWidth(0.35);
  APDF.Line(28, AY - 4, APDF.PageWidth - 28, AY - 4);
  AY := AY - 18;
end;

procedure FLXDibujarCajaResumen(APDF: TFLXCreditosPDFDocument;
  const AX, AY, AAncho, AAlto: Double; const ATitulo, AValor: string;
  const AR, AG, AB: Double);
begin
  APDF.SetFillColor(0.96, 0.97, 0.98);
  APDF.FillRect(AX, AY, AAncho, AAlto);
  APDF.SetStrokeColor(0.78, 0.82, 0.84);
  APDF.StrokeRect(AX, AY, AAncho, AAlto);
  APDF.SetFillColor(0.30, 0.34, 0.37);
  APDF.Text(AX + 10, AY + AAlto - 17, 8, ATitulo, True);
  APDF.SetFillColor(AR, AG, AB);
  APDF.TextRight(AX + AAncho - 10, AY + 12, 14, AValor, True);
end;

procedure FLXDibujarResumen(APDF: TFLXCreditosPDFDocument; var AY: Double;
  const ATitulo, ACodigoCliente, ANombreCliente, AClienteNIF,
  AClienteDireccion, AClienteLocalidad, AClienteProvincia: string;
  AConteo: Integer; ADebeLista, AHaberLista, ACuentaDebe,
  ACuentaHaber: Double; AMarcadas: Boolean);
var
  NetoLista, SaldoCuenta: Double;
  SituacionTitulo, SituacionValor, Nota: string;
  R, G, B: Double;
begin
  if AY < 135 then
    FLXDibujarCabecera(APDF, AY, ATitulo, ACodigoCliente,
      ANombreCliente, AClienteNIF, AClienteDireccion,
      AClienteLocalidad, AClienteProvincia, True);

  NetoLista := ADebeLista - AHaberLista;
  SaldoCuenta := ACuentaDebe - ACuentaHaber;

  APDF.SetFillColor(0.05, 0.25, 0.28);
  APDF.Text(28, AY, 11, 'RESUMEN DEL INFORME', True);
  APDF.SetFillColor(0.30, 0.34, 0.37);
  APDF.TextRight(APDF.PageWidth - 28, AY, 8,
    IntToStr(AConteo) + ' movimiento(s)', False);
  AY := AY - 66;

  FLXDibujarCajaResumen(APDF, 28, AY, 180, 50, 'TOTAL DEBE',
    FLXImporte(ADebeLista) + ' EUR', 0.78, 0.10, 0.10);
  FLXDibujarCajaResumen(APDF, 221, AY, 180, 50, 'TOTAL HABER',
    FLXImporte(AHaberLista) + ' EUR', 0.10, 0.32, 0.78);

  if NetoLista > 0.004 then
  begin
    SituacionTitulo := 'NETO DEL LISTADO - DEUDA';
    SituacionValor := FLXImporte(NetoLista) + ' EUR';
    R := 0.78;
    G := 0.10;
    B := 0.10;
  end
  else if NetoLista < -0.004 then
  begin
    SituacionTitulo := 'NETO DEL LISTADO - A FAVOR';
    SituacionValor := FLXImporte(Abs(NetoLista)) + ' EUR';
    R := 0.10;
    G := 0.32;
    B := 0.78;
  end
  else
  begin
    SituacionTitulo := 'NETO DEL LISTADO';
    SituacionValor := '0,00 EUR';
    R := 0.18;
    G := 0.22;
    B := 0.25;
  end;
  FLXDibujarCajaResumen(APDF, 414, AY, APDF.PageWidth - 442, 50,
    SituacionTitulo, SituacionValor, R, G, B);

  AY := AY - 26;
  APDF.SetFillColor(0.30, 0.34, 0.37);
  if SaldoCuenta > 0.004 then
    Nota := 'Situacion global de la cuenta: DEUDA ' +
      FLXImporte(SaldoCuenta) + ' EUR'
  else if SaldoCuenta < -0.004 then
    Nota := 'Situacion global de la cuenta: A FAVOR ' +
      FLXImporte(Abs(SaldoCuenta)) + ' EUR'
  else
    Nota := 'Situacion global de la cuenta: SALDO 0,00 EUR';
  APDF.Text(28, AY, 9, Nota, True);

  if AMarcadas then
  begin
    AY := AY - 16;
    APDF.Text(28, AY, 8,
      'El saldo acumulado corresponde unicamente a las lineas marcadas.',
      False);
  end;
end;

function FLXGenerarPDF(AConnection: TZAbstractConnection;
  const ATienda, ACodigoCliente, ANombreCliente, AClienteNIF,
  AClienteDireccion, AClienteLocalidad, AClienteProvincia,
  AArchivo: string; AAmbito: TFLXAmbitoInforme): Boolean;
var
  PDF: TFLXCreditosPDFDocument;
  Q, QTotales: TZQuery;
  Tabla, Titulo: string;
  Y, Saldo, DebeLista, HaberLista, CuentaDebe, CuentaHaber: Double;
  Conteo, Indice: Integer;
  SoloMarcadas: Boolean;
begin
  Result := False;
  Tabla := FLXTablaCreditos(ATienda);
  SoloMarcadas := AAmbito = faiMarcadas;

  if SoloMarcadas then
    Titulo := 'Lineas marcadas para saldar'
  else
    Titulo := 'Estado de cuenta de creditos';

  PDF := TFLXCreditosPDFDocument.Create;
  Q := TZQuery.Create(nil);
  QTotales := TZQuery.Create(nil);
  try
    PDF.SetLandscape;
    Q.Connection := AConnection;
    QTotales.Connection := AConnection;

    QTotales.SQL.Text :=
      'SELECT COUNT(*) AS N,COALESCE(SUM(CRE7),0) AS D,' +
      'COALESCE(SUM(CRE8),0) AS H FROM `' + Tabla +
      '` WHERE CRE0=:CLIENTE';
    QTotales.ParamByName('CLIENTE').AsString := ACodigoCliente;
    QTotales.Open;
    CuentaDebe := QTotales.FieldByName('D').AsFloat;
    CuentaHaber := QTotales.FieldByName('H').AsFloat;
    QTotales.Close;

    Q.SQL.Text :=
      'SELECT CRE1,CRE2,CRE3,CRE4,CRE5,CRE6,CRE7,CRE8,CRE9 ' +
      'FROM `' + Tabla + '` WHERE CRE0=:CLIENTE';
    if SoloMarcadas then
      Q.SQL.Add('AND CRE9=''S''');
    Q.SQL.Add('ORDER BY CRE1,CRE2,CRE4,CRE5');
    Q.ParamByName('CLIENTE').AsString := ACodigoCliente;
    Q.Open;

    if Q.IsEmpty then
      raise Exception.Create('No hay movimientos para generar el informe.');

    Y := 0;
    FLXDibujarCabecera(PDF, Y, Titulo, ACodigoCliente, ANombreCliente,
      AClienteNIF, AClienteDireccion, AClienteLocalidad,
      AClienteProvincia, False);
    FLXDibujarCabeceraTabla(PDF, Y);

    Saldo := 0;
    DebeLista := 0;
    HaberLista := 0;
    Conteo := 0;
    Indice := 0;

    while not Q.EOF do
    begin
      if Y < 48 then
      begin
        FLXDibujarCabecera(PDF, Y, Titulo, ACodigoCliente,
          ANombreCliente, AClienteNIF, AClienteDireccion,
          AClienteLocalidad, AClienteProvincia, True);
        FLXDibujarCabeceraTabla(PDF, Y);
      end;

      DebeLista := DebeLista + Q.FieldByName('CRE7').AsFloat;
      HaberLista := HaberLista + Q.FieldByName('CRE8').AsFloat;
      Saldo := Saldo + Q.FieldByName('CRE7').AsFloat -
        Q.FieldByName('CRE8').AsFloat;
      Inc(Conteo);
      Inc(Indice);
      FLXDibujarFila(PDF, Y, Q, Saldo, Indice);
      Q.Next;
    end;

    FLXDibujarResumen(PDF, Y, Titulo, ACodigoCliente, ANombreCliente,
      AClienteNIF, AClienteDireccion, AClienteLocalidad,
      AClienteProvincia, Conteo, DebeLista, HaberLista,
      CuentaDebe, CuentaHaber, SoloMarcadas);
    PDF.AddPageNumbers;
    PDF.SaveToFile(AArchivo);
    Result := FileExists(AArchivo);
  finally
    QTotales.Free;
    Q.Free;
    PDF.Free;
  end;
end;

procedure FLXVistaPreviaEstadoCuentaCreditos(AOwner: TComponent;
  AConnection: TZAbstractConnection; const ATienda, ACodigoCliente,
  ANombreCliente, AClienteNIF, AClienteDireccion, AClienteLocalidad,
  AClienteProvincia: string);
var
  Tabla, Archivo: string;
  Ambito: TFLXAmbitoInforme;
begin
  if not Assigned(AConnection) then
  begin
    MessageDlg('No se ha recibido una conexion a la base de datos.',
      mtError, [mbOK], 0);
    Exit;
  end;

  if not AConnection.Connected then
  begin
    MessageDlg('La conexion a la base de datos no esta activa.',
      mtError, [mbOK], 0);
    Exit;
  end;

  if Trim(ACodigoCliente) = '' then
  begin
    MessageDlg('Debe seleccionar un cliente antes de generar el informe.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  Tabla := FLXTablaCreditos(ATienda);
  if not FLXElegirAmbito(AConnection, Tabla, ACodigoCliente, Ambito) then
    Exit;

  Archivo := FLXArchivoTemporal(ACodigoCliente);
  try
    if FLXGenerarPDF(AConnection, ATienda, ACodigoCliente,
      ANombreCliente, AClienteNIF, AClienteDireccion,
      AClienteLocalidad, AClienteProvincia, Archivo, Ambito) then
    begin
      if not OpenDocument(Archivo) then
        MessageDlg('El PDF se ha generado correctamente en:' +
          LineEnding + Archivo + LineEnding +
          'No se ha encontrado un visor PDF predeterminado.',
          mtInformation, [mbOK], 0);
    end;
  except
    on E: Exception do
      MessageDlg('No se ha podido generar el estado de cuenta.' +
        LineEnding + E.Message, mtError, [mbOK], 0);
  end;
end;

end.
