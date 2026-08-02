unit uFLXRecibosFacturasPDF;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  Buttons, LCLIntf, LazUTF8, Process, ZAbstractConnection, ZDataset;

function FLXGestionarRecibosFacturas(AOwner: TComponent;
  AConnection: TZAbstractConnection; const ATienda: string;
  AClavesFacturas: TStrings; out AFacturasMarcadasPagadas: Boolean): Boolean;

implementation

uses
  Global, uFLXPDFRecibos;

type
  TFLXAccionRecibo = (
    farCancelar,
    farVistaPrevia,
    farGuardarPDF,
    farImprimir
  );

  TFLXFacturaRecibo = class
  public
    Clave: string;
    Fecha: TDateTime;
    Serie: string;
    Numero: string;
    Importe: Double;
    Pagada: Boolean;
  end;

  TFLXClienteRecibo = class
  public
    Codigo: string;
    Nombre: string;
    NIFCliente: string;
    DireccionCliente: string;
    CPCliente: string;
    LocalidadCliente: string;
    ProvinciaCliente: string;
    Facturas: TList;
    constructor Create;
    destructor Destroy; override;
    function Total: Double;
  end;

const
  FLX_MR_PREVIEW = 101;
  FLX_MR_SAVE = 102;
  FLX_MR_PRINT = 103;

constructor TFLXClienteRecibo.Create;
begin
  inherited Create;
  Facturas := TList.Create;
end;

destructor TFLXClienteRecibo.Destroy;
var
  I: Integer;
begin
  for I := 0 to Facturas.Count - 1 do
    TObject(Facturas[I]).Free;
  Facturas.Free;
  inherited Destroy;
end;

function TFLXClienteRecibo.Total: Double;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Facturas.Count - 1 do
    Result := Result + TFLXFacturaRecibo(Facturas[I]).Importe;
end;

function FLXTablaFacturas(const ATienda: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(ATienda) do
    if ATienda[I] in ['0'..'9'] then
      Result := Result + ATienda[I];

  if Result = '' then
    Result := '0000';

  Result := 'factuc' + Result;
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

function FLXNombreArchivoSeguro(const ATexto: string): string;
var
  I: Integer;
  C: Char;
begin
  Result := '';
  for I := 1 to Length(ATexto) do
  begin
    C := ATexto[I];
    if C in ['A'..'Z', 'a'..'z', '0'..'9', '-', '_'] then
      Result := Result + C
    else if C in [' ', '.', '/', '\', ':'] then
      Result := Result + '_';
  end;

  while Pos('__', Result) > 0 do
    Result := StringReplace(Result, '__', '_', [rfReplaceAll]);

  Result := Trim(Result);
  if Result = '' then
    Result := 'Cliente';
end;

function FLXParsearClave(const AClave: string; out ACliente, AFechaISO,
  ASerie, ANumero: string): Boolean;
var
  Partes: TStringList;
begin
  Result := False;
  ACliente := '';
  AFechaISO := '';
  ASerie := '';
  ANumero := '';

  Partes := TStringList.Create;
  try
    ExtractStrings([#9], [], PChar(AClave), Partes);
    if Partes.Count <> 4 then
      Exit;

    ACliente := Trim(Partes[0]);
    AFechaISO := Trim(Partes[1]);
    ASerie := Trim(Partes[2]);
    ANumero := Trim(Partes[3]);

    Result := (ACliente <> '') and (AFechaISO <> '') and
      (ASerie <> '') and (ANumero <> '');
  finally
    Partes.Free;
  end;
end;

function FLXFechaISO(const AFechaISO: string; out AFecha: TDateTime): Boolean;
var
  Anio, Mes, Dia: Word;
begin
  Result := False;
  AFecha := 0;

  if Length(AFechaISO) <> 10 then
    Exit;

  Anio := StrToIntDef(Copy(AFechaISO, 1, 4), 0);
  Mes := StrToIntDef(Copy(AFechaISO, 6, 2), 0);
  Dia := StrToIntDef(Copy(AFechaISO, 9, 2), 0);

  try
    AFecha := EncodeDate(Anio, Mes, Dia);
    Result := True;
  except
    Result := False;
  end;
end;

function FLXCompararFacturas(Item1, Item2: Pointer): Integer;
var
  A, B: TFLXFacturaRecibo;
begin
  A := TFLXFacturaRecibo(Item1);
  B := TFLXFacturaRecibo(Item2);

  if A.Fecha < B.Fecha then
    Exit(-1);
  if A.Fecha > B.Fecha then
    Exit(1);

  Result := CompareText(A.Serie, B.Serie);
  if Result = 0 then
    Result := CompareText(A.Numero, B.Numero);
end;

procedure FLXLiberarGrupos(AGrupos: TList);
var
  I: Integer;
begin
  if not Assigned(AGrupos) then
    Exit;

  for I := 0 to AGrupos.Count - 1 do
    TObject(AGrupos[I]).Free;
  AGrupos.Free;
end;

function FLXCargarSeleccion(AConnection: TZAbstractConnection;
  const ATienda: string; AClavesFacturas: TStrings; out AGrupos: TList;
  out AClavesValidas: TStringList; out APagadas: Integer): Boolean;
var
  Q: TZQuery;
  IndiceClientes: TStringList;
  Grupo: TFLXClienteRecibo;
  Factura: TFLXFacturaRecibo;
  Cliente, FechaISO, Serie, Numero: string;
  Fecha: TDateTime;
  I, PosCliente: Integer;
  Tabla: string;
begin
  Result := False;
  AGrupos := TList.Create;
  AClavesValidas := TStringList.Create;
  AClavesValidas.Sorted := True;
  AClavesValidas.Duplicates := dupIgnore;
  APagadas := 0;

  if (not Assigned(AConnection)) or
     (not Assigned(AClavesFacturas)) or
     (AClavesFacturas.Count = 0) then
    Exit;

  Tabla := FLXTablaFacturas(ATienda);
  IndiceClientes := TStringList.Create;
  Q := TZQuery.Create(nil);
  try
    IndiceClientes.Sorted := True;
    IndiceClientes.Duplicates := dupIgnore;

    Q.Connection := AConnection;
    Q.SQL.Text :=
      'SELECT F.FC0,F.FC1,F.FC2,F.FC3,F.FC9,F.FC23,' +
      'C.C1 AS CLI_NOMBRE,C.C5 AS CLI_NIF,' +
      'C.C3 AS CLI_DIRECCION,C.C37 AS CLI_CP,' +
      'C.C4 AS CLI_LOCALIDAD,C.C38 AS CLI_PROVINCIA ' +
      'FROM `' + Tabla + '` F ' +
      'LEFT JOIN clientes C ON C.C0=F.FC0 ' +
      'WHERE F.FC0=:CLIENTE AND F.FC1=:FECHA ' +
      'AND F.FC2=:SERIE AND F.FC3=:NUMERO';

    for I := 0 to AClavesFacturas.Count - 1 do
    begin
      if not FLXParsearClave(AClavesFacturas[I], Cliente, FechaISO,
        Serie, Numero) then
        Continue;

      if not FLXFechaISO(FechaISO, Fecha) then
        Continue;

      Q.Close;
      Q.ParamByName('CLIENTE').AsString := Cliente;
      Q.ParamByName('FECHA').AsDateTime := Fecha;
      Q.ParamByName('SERIE').AsString := Serie;
      Q.ParamByName('NUMERO').AsString := Numero;
      Q.Open;

      if Q.IsEmpty then
        Continue;

      PosCliente := IndiceClientes.IndexOf(Cliente);
      if PosCliente < 0 then
      begin
        Grupo := TFLXClienteRecibo.Create;
        Grupo.Codigo := Q.FieldByName('FC0').AsString;
        Grupo.Nombre := Q.FieldByName('CLI_NOMBRE').AsString;
        if Trim(Grupo.Nombre) = '' then
          Grupo.Nombre := 'Cliente ' + Grupo.Codigo;
        Grupo.NIFCliente := Q.FieldByName('CLI_NIF').AsString;
        Grupo.DireccionCliente := Q.FieldByName('CLI_DIRECCION').AsString;
        Grupo.CPCliente := Q.FieldByName('CLI_CP').AsString;
        Grupo.LocalidadCliente := Q.FieldByName('CLI_LOCALIDAD').AsString;
        Grupo.ProvinciaCliente := Q.FieldByName('CLI_PROVINCIA').AsString;

        AGrupos.Add(Grupo);
        IndiceClientes.AddObject(Cliente, Grupo);
      end
      else
        Grupo := TFLXClienteRecibo(IndiceClientes.Objects[PosCliente]);

      Factura := TFLXFacturaRecibo.Create;
      Factura.Clave := AClavesFacturas[I];
      Factura.Fecha := Q.FieldByName('FC1').AsDateTime;
      Factura.Serie := Q.FieldByName('FC2').AsString;
      Factura.Numero := Q.FieldByName('FC3').AsString;
      Factura.Importe := Q.FieldByName('FC9').AsFloat;
      Factura.Pagada := SameText(Trim(Q.FieldByName('FC23').AsString), 'S');
      if Factura.Pagada then
        Inc(APagadas);

      Grupo.Facturas.Add(Factura);
      AClavesValidas.Add(Factura.Clave);
    end;

    for I := 0 to AGrupos.Count - 1 do
      TFLXClienteRecibo(AGrupos[I]).Facturas.Sort(@FLXCompararFacturas);

    Result := (AGrupos.Count > 0) and (AClavesValidas.Count > 0);
  finally
    Q.Free;
    IndiceClientes.Free;
  end;
end;

function FLXContarFacturas(AGrupos: TList): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to AGrupos.Count - 1 do
    Result := Result + TFLXClienteRecibo(AGrupos[I]).Facturas.Count;
end;

function FLXTotalGeneral(AGrupos: TList): Double;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to AGrupos.Count - 1 do
    Result := Result + TFLXClienteRecibo(AGrupos[I]).Total;
end;

function FLXElegirAccion(AOwner: TComponent; AGrupos: TList;
  APagadas: Integer): TFLXAccionRecibo;
var
  F: TForm;
  Titulo, Resumen, Nota: TLabel;
  Caja: TPanel;
  BtnPreview, BtnGuardar, BtnImprimir, BtnCancelar: TButton;
  R: TModalResult;
  NumFacturas: Integer;
begin
  Result := farCancelar;
  NumFacturas := FLXContarFacturas(AGrupos);

  F := TForm.CreateNew(AOwner, 1);
  try
    F.Caption := 'FacturLinEx - Recibos PDF';
    F.BorderStyle := bsDialog;
    F.Position := poScreenCenter;
    F.ClientWidth := 690;
    F.ClientHeight := 300;
    F.Color := $00F8FAFC;

    Titulo := TLabel.Create(F);
    Titulo.Parent := F;
    Titulo.SetBounds(24, 20, 642, 32);
    Titulo.AutoSize := False;
    Titulo.Caption := 'GENERAR RECIBOS DE LAS FACTURAS SELECCIONADAS';
    Titulo.Font.Name := 'Sans';
    Titulo.Font.Height := -18;
    Titulo.Font.Style := [fsBold];
    Titulo.Font.Color := $0033210F;

    Caja := TPanel.Create(F);
    Caja.Parent := F;
    Caja.SetBounds(24, 60, 642, 112);
    Caja.BevelOuter := bvNone;
    Caja.ParentBackground := False;
    Caja.Color := $00F5E9DE;

    Resumen := TLabel.Create(F);
    Resumen.Parent := Caja;
    Resumen.SetBounds(18, 16, 606, 46);
    Resumen.AutoSize := False;
    Resumen.WordWrap := True;
    Resumen.Font.Name := 'Sans';
    Resumen.Font.Height := -14;
    Resumen.Font.Style := [fsBold];
    Resumen.Caption :=
      IntToStr(NumFacturas) + ' factura(s), ' +
      IntToStr(AGrupos.Count) + ' cliente(s), total ' +
      FLXImporte(FLXTotalGeneral(AGrupos)) + ' EUR.';

    Nota := TLabel.Create(F);
    Nota.Parent := Caja;
    Nota.SetBounds(18, 62, 606, 40);
    Nota.AutoSize := False;
    Nota.WordWrap := True;
    Nota.Font.Name := 'Sans';
    Nota.Font.Height := -12;

    if APagadas > 0 then
      Nota.Caption := IntToStr(APagadas) +
        ' factura(s) ya constan como pagadas. Se incluirán igualmente. ' +
        'Solo «Imprimir y marcar pagadas» actualizará la casilla Pagado.'
    else
      Nota.Caption :=
        'Se generará un PDF independiente por cliente. Vista previa y ' +
        'Guardar PDF no modifican las facturas.';

    BtnPreview := TButton.Create(F);
    BtnPreview.Parent := F;
    BtnPreview.SetBounds(24, 205, 145, 38);
    BtnPreview.Caption := 'Vista previa';
    BtnPreview.ModalResult := FLX_MR_PREVIEW;
    BtnPreview.Default := True;

    BtnGuardar := TButton.Create(F);
    BtnGuardar.Parent := F;
    BtnGuardar.SetBounds(177, 205, 145, 38);
    BtnGuardar.Caption := 'Guardar PDF';
    BtnGuardar.ModalResult := FLX_MR_SAVE;

    BtnImprimir := TButton.Create(F);
    BtnImprimir.Parent := F;
    BtnImprimir.SetBounds(330, 205, 210, 38);
    BtnImprimir.Caption := 'Imprimir y marcar pagadas';
    BtnImprimir.ModalResult := FLX_MR_PRINT;

    BtnCancelar := TButton.Create(F);
    BtnCancelar.Parent := F;
    BtnCancelar.SetBounds(548, 205, 118, 38);
    BtnCancelar.Caption := 'Cancelar';
    BtnCancelar.ModalResult := mrCancel;
    BtnCancelar.Cancel := True;

    R := F.ShowModal;
    case R of
      FLX_MR_PREVIEW: Result := farVistaPrevia;
      FLX_MR_SAVE: Result := farGuardarPDF;
      FLX_MR_PRINT: Result := farImprimir;
    end;
  finally
    F.Free;
  end;
end;

procedure FLXDibujarCabecera(APDF: TFLXRecibosPDFDocument;
  AGrupo: TFLXClienteRecibo; const ANumeroRecibo: string;
  AContinuacion: Boolean; out AY: Double);
var
  EmpresaLinea, ClienteLinea, DomicilioLinea: string;
begin
  APDF.NewPage;

  APDF.SetFillColor(0.05, 0.25, 0.28);
  APDF.FillRect(0, APDF.PageHeight - 74, APDF.PageWidth, 74);
  APDF.SetFillColor(1, 1, 1);
  APDF.Text(38, APDF.PageHeight - 32, 18, Empresa, True);
  APDF.Text(38, APDF.PageHeight - 55, 12,
    'RECIBO / JUSTIFICANTE DE PAGO', True);

  if AContinuacion then
    APDF.TextRight(APDF.PageWidth - 38, APDF.PageHeight - 54, 9,
      'Continuación', True);

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

  APDF.SetFillColor(0.18, 0.21, 0.24);
  APDF.Text(38, APDF.PageHeight - 94, 8.5,
    FLXCortar(EmpresaLinea, 90), False);
  APDF.TextRight(APDF.PageWidth - 38, APDF.PageHeight - 94, 8.5,
    'Recibo: ' + ANumeroRecibo, True);
  APDF.TextRight(APDF.PageWidth - 38, APDF.PageHeight - 109, 8.5,
    'Fecha: ' + FormatDateTime('dd/mm/yyyy', Date), False);

  APDF.SetFillColor(0.95, 0.97, 0.98);
  APDF.FillRect(38, APDF.PageHeight - 183, APDF.PageWidth - 76, 56);
  APDF.SetStrokeColor(0.78, 0.83, 0.86);
  APDF.StrokeRect(38, APDF.PageHeight - 183, APDF.PageWidth - 76, 56);

  ClienteLinea := 'Cliente ' + AGrupo.Codigo + ' - ' + AGrupo.Nombre;
  APDF.SetFillColor(0.05, 0.25, 0.28);
  APDF.Text(50, APDF.PageHeight - 151, 12,
    FLXCortar(ClienteLinea, 75), True);

  DomicilioLinea := Trim(AGrupo.DireccionCliente);
  if Trim(AGrupo.CPCliente) <> '' then
    DomicilioLinea := DomicilioLinea + ' - ' + AGrupo.CPCliente;
  if Trim(AGrupo.LocalidadCliente) <> '' then
    DomicilioLinea := DomicilioLinea + ' ' + AGrupo.LocalidadCliente;
  if Trim(AGrupo.ProvinciaCliente) <> '' then
    DomicilioLinea := DomicilioLinea + ' (' + AGrupo.ProvinciaCliente + ')';
  if Trim(AGrupo.NIFCliente) <> '' then
    DomicilioLinea := 'NIF: ' + AGrupo.NIFCliente + ' - ' + DomicilioLinea;

  APDF.SetFillColor(0.23, 0.27, 0.30);
  APDF.Text(50, APDF.PageHeight - 171, 8.5,
    FLXCortar(DomicilioLinea, 94), False);

  AY := APDF.PageHeight - 212;
end;

procedure FLXDibujarIntroduccion(APDF: TFLXRecibosPDFDocument;
  AGrupo: TFLXClienteRecibo; var AY: Double);
var
  Texto: string;
begin
  APDF.SetFillColor(0.97, 0.96, 0.90);
  APDF.FillRect(38, AY - 42, APDF.PageWidth - 76, 44);

  APDF.SetFillColor(0.18, 0.21, 0.24);
  Texto := 'Recibimos de ' + AGrupo.Nombre + ' la cantidad total de ' +
    FLXImporte(AGrupo.Total) +
    ' EUR, correspondiente a las facturas relacionadas a continuación.';
  APDF.Text(50, AY - 17, 9.5, FLXCortar(Texto, 96), False);
  APDF.Text(50, AY - 32, 9.5,
    FLXCortar(Copy(Texto, 97, Length(Texto)), 96), False);

  AY := AY - 66;
end;

procedure FLXDibujarCabeceraTabla(APDF: TFLXRecibosPDFDocument;
  var AY: Double);
begin
  APDF.SetFillColor(0.10, 0.36, 0.40);
  APDF.FillRect(38, AY - 18, APDF.PageWidth - 76, 22);

  APDF.SetFillColor(1, 1, 1);
  APDF.Text(50, AY - 12, 8, 'FECHA', True);
  APDF.Text(150, AY - 12, 8, 'FACTURA', True);
  APDF.Text(270, AY - 12, 8, 'CONCEPTO', True);
  APDF.TextRight(APDF.PageWidth - 50, AY - 12, 8, 'IMPORTE', True);
  AY := AY - 30;
end;

procedure FLXDibujarFila(APDF: TFLXRecibosPDFDocument; var AY: Double;
  AFactura: TFLXFacturaRecibo; AIndice: Integer);
var
  Documento: string;
begin
  if Odd(AIndice) then
  begin
    APDF.SetFillColor(0.97, 0.98, 0.99);
    APDF.FillRect(38, AY - 5, APDF.PageWidth - 76, 22);
  end;

  Documento := Trim(AFactura.Serie) + '/' + Trim(AFactura.Numero);

  APDF.SetFillColor(0.13, 0.16, 0.19);
  APDF.Text(50, AY + 1, 9,
    FormatDateTime('dd/mm/yyyy', AFactura.Fecha), False);
  APDF.Text(150, AY + 1, 9, FLXCortar(Documento, 18), True);
  APDF.Text(270, AY + 1, 9, 'Pago de factura', False);
  APDF.TextRight(APDF.PageWidth - 50, AY + 1, 9,
    FLXImporte(AFactura.Importe) + ' EUR', False);

  APDF.SetStrokeColor(0.88, 0.90, 0.92);
  APDF.Line(38, AY - 7, APDF.PageWidth - 38, AY - 7);
  AY := AY - 25;
end;

procedure FLXDibujarTotalYFirma(APDF: TFLXRecibosPDFDocument;
  AGrupo: TFLXClienteRecibo; const ANumeroRecibo: string; var AY: Double);
begin
  if AY < 190 then
  begin
    FLXDibujarCabecera(APDF, AGrupo, ANumeroRecibo, True, AY);
    FLXDibujarCabeceraTabla(APDF, AY);
  end;

  APDF.SetFillColor(0.90, 0.95, 0.93);
  APDF.FillRect(APDF.PageWidth - 236, AY - 35, 198, 40);
  APDF.SetStrokeColor(0.40, 0.58, 0.50);
  APDF.StrokeRect(APDF.PageWidth - 236, AY - 35, 198, 40);

  APDF.SetFillColor(0.05, 0.25, 0.28);
  APDF.Text(APDF.PageWidth - 224, AY - 10, 10, 'TOTAL RECIBIDO', True);
  APDF.TextRight(APDF.PageWidth - 50, AY - 25, 15,
    FLXImporte(AGrupo.Total) + ' EUR', True);

  AY := AY - 78;

  APDF.SetFillColor(0.22, 0.25, 0.28);
  APDF.Text(50, AY, 8.5,
    'Este justificante acredita el pago de las facturas indicadas.', False);
  APDF.Text(50, AY - 15, 8.5,
    'No sustituye a las facturas originales ni constituye una nueva factura.',
    False);

  APDF.SetStrokeColor(0.45, 0.48, 0.50);
  APDF.Line(APDF.PageWidth - 238, AY - 50,
    APDF.PageWidth - 50, AY - 50);
  APDF.TextCenter(APDF.PageWidth - 144, AY - 65, 8,
    'Firma y sello', False);
end;

function FLXArchivoConDatos(const AArchivo: string): Boolean;
var
  S: TFileStream;
begin
  Result := False;
  if not FileExists(AArchivo) then
    Exit;

  S := TFileStream.Create(AArchivo, fmOpenRead or fmShareDenyNone);
  try
    Result := S.Size > 0;
  finally
    S.Free;
  end;
end;

function FLXCrearReciboPDF(AGrupo: TFLXClienteRecibo;
  const AArchivo: string): Boolean;
var
  PDF: TFLXRecibosPDFDocument;
  Y: Double;
  I: Integer;
  Factura: TFLXFacturaRecibo;
  NumeroRecibo: string;
begin
  Result := False;
  PDF := TFLXRecibosPDFDocument.Create;
  try
    NumeroRecibo := 'REC-' + FormatDateTime('yyyymmdd-hhnnss', Now) +
      '-' + AGrupo.Codigo;

    FLXDibujarCabecera(PDF, AGrupo, NumeroRecibo, False, Y);
    FLXDibujarIntroduccion(PDF, AGrupo, Y);
    FLXDibujarCabeceraTabla(PDF, Y);

    for I := 0 to AGrupo.Facturas.Count - 1 do
    begin
      Factura := TFLXFacturaRecibo(AGrupo.Facturas[I]);

      if Y < 110 then
      begin
        FLXDibujarCabecera(PDF, AGrupo, NumeroRecibo, True, Y);
        FLXDibujarCabeceraTabla(PDF, Y);
      end;

      FLXDibujarFila(PDF, Y, Factura, I);
    end;

    FLXDibujarTotalYFirma(PDF, AGrupo, NumeroRecibo, Y);
    PDF.AddPageNumbers;
    PDF.SaveToFile(AArchivo);
    Result := FLXArchivoConDatos(AArchivo);
  finally
    PDF.Free;
  end;
end;

function FLXGenerarPDFs(AGrupos: TList; const ADirectorio: string;
  AArchivos: TStrings; out AError: string): Boolean;
var
  I: Integer;
  Grupo: TFLXClienteRecibo;
  Archivo, Sello: string;
begin
  Result := False;
  AError := '';
  AArchivos.Clear;

  if not ForceDirectories(ADirectorio) then
  begin
    AError := 'No se pudo crear o acceder a la carpeta: ' + ADirectorio;
    Exit;
  end;

  Sello := FormatDateTime('yyyymmdd_hhnnss_zzz', Now);

  try
    for I := 0 to AGrupos.Count - 1 do
    begin
      Grupo := TFLXClienteRecibo(AGrupos[I]);
      Archivo := IncludeTrailingPathDelimiter(ADirectorio) +
        'Recibo_' + FLXNombreArchivoSeguro(Grupo.Codigo + '_' +
        Grupo.Nombre) + '_' + Sello + '.pdf';

      if not FLXCrearReciboPDF(Grupo, Archivo) then
        raise Exception.Create('No se pudo generar: ' + Archivo);

      AArchivos.Add(Archivo);
    end;

    Result := AArchivos.Count = AGrupos.Count;
  except
    on E: Exception do
    begin
      AError := E.Message;
      Result := False;
    end;
  end;
end;

function FLXVistaPrevia(AArchivos: TStrings; out AError: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  AError := '';

  for I := 0 to AArchivos.Count - 1 do
    if not OpenDocument(AArchivos[I]) then
    begin
      Result := False;
      AError := 'No se pudo abrir el visor PDF para:' + LineEnding +
        AArchivos[I];
      Exit;
    end;
end;

function FLXComandoImpresion: string;
begin
  Result := '';
  if FileExists('/usr/bin/lp') then
    Result := '/usr/bin/lp'
  else if FileExists('/usr/bin/lpr') then
    Result := '/usr/bin/lpr';
end;

function FLXImprimirArchivo(const AArchivo: string;
  out AError: string): Boolean;
var
  P: TProcess;
  Ejecutable: string;
begin
  Result := False;
  AError := '';
  Ejecutable := FLXComandoImpresion;

  if Ejecutable = '' then
  begin
    AError := 'No se encontró /usr/bin/lp ni /usr/bin/lpr. ' +
      'Instale el cliente de impresión CUPS o use Vista previa.';
    Exit;
  end;

  P := TProcess.Create(nil);
  try
    P.Executable := Ejecutable;
    P.Parameters.Add(AArchivo);
    P.Options := [poWaitOnExit];

    try
      P.Execute;
      Result := P.ExitStatus = 0;
      if not Result then
        AError := 'El sistema de impresión devolvió el código ' +
          IntToStr(P.ExitStatus) + ' para:' + LineEnding + AArchivo;
    except
      on E: Exception do
      begin
        AError := E.Message;
        Result := False;
      end;
    end;
  finally
    P.Free;
  end;
end;

function FLXImprimirPDFs(AArchivos: TStrings;
  out AError: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  AError := '';

  for I := 0 to AArchivos.Count - 1 do
    if not FLXImprimirArchivo(AArchivos[I], AError) then
      Exit;

  Result := True;
end;

function FLXMarcarPagadas(AConnection: TZAbstractConnection;
  const ATienda: string; AClaves: TStrings; out AError: string): Boolean;
var
  Q: TZQuery;
  SQL: string;
  Cliente, FechaISO, Serie, Numero: string;
  Fecha: TDateTime;
  I: Integer;
  Sufijo: string;
begin
  Result := False;
  AError := '';

  if (not Assigned(AConnection)) or (AClaves.Count = 0) then
  begin
    AError := 'No hay facturas válidas para marcar como pagadas.';
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;
    SQL := 'UPDATE `' + FLXTablaFacturas(ATienda) +
      '` SET FC23=''S'' WHERE ';

    for I := 0 to AClaves.Count - 1 do
    begin
      if not FLXParsearClave(AClaves[I], Cliente, FechaISO,
        Serie, Numero) then
        Continue;
      if not FLXFechaISO(FechaISO, Fecha) then
        Continue;

      if I > 0 then
        SQL := SQL + ' OR ';

      Sufijo := IntToStr(I);
      SQL := SQL + '(FC0=:C' + Sufijo +
        ' AND FC1=:F' + Sufijo +
        ' AND FC2=:S' + Sufijo +
        ' AND FC3=:N' + Sufijo + ')';
    end;

    Q.SQL.Text := SQL;

    for I := 0 to AClaves.Count - 1 do
    begin
      if not FLXParsearClave(AClaves[I], Cliente, FechaISO,
        Serie, Numero) then
        Continue;
      if not FLXFechaISO(FechaISO, Fecha) then
        Continue;

      Sufijo := IntToStr(I);
      Q.ParamByName('C' + Sufijo).AsString := Cliente;
      Q.ParamByName('F' + Sufijo).AsDateTime := Fecha;
      Q.ParamByName('S' + Sufijo).AsString := Serie;
      Q.ParamByName('N' + Sufijo).AsString := Numero;
    end;

    Q.ExecSQL;
    Result := True;
  except
    on E: Exception do
    begin
      AError := E.Message;
      Result := False;
    end;
  end;

  Q.Free;
end;

function FLXListaArchivos(AArchivos: TStrings): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to AArchivos.Count - 1 do
  begin
    if Result <> '' then
      Result := Result + LineEnding;
    Result := Result + ExtractFileName(AArchivos[I]);
  end;
end;

function FLXGestionarRecibosFacturas(AOwner: TComponent;
  AConnection: TZAbstractConnection; const ATienda: string;
  AClavesFacturas: TStrings; out AFacturasMarcadasPagadas: Boolean): Boolean;
var
  Grupos: TList;
  ClavesValidas: TStringList;
  Archivos: TStringList;
  Accion: TFLXAccionRecibo;
  Directorio, ErrorTexto: string;
  DialogoDirectorio: TSelectDirectoryDialog;
  Pagadas: Integer;
  SeleccionCargada: Boolean;
begin
  Result := False;
  AFacturasMarcadasPagadas := False;
  Grupos := nil;
  ClavesValidas := nil;
  Archivos := TStringList.Create;
  try
    SeleccionCargada := False;
    try
      SeleccionCargada := FLXCargarSeleccion(
        AConnection, ATienda, AClavesFacturas,
        Grupos, ClavesValidas, Pagadas
      );
    except
      on E: Exception do
      begin
        ShowMessage(
          'NO SE PUDIERON LEER LAS FACTURAS PARA EL RECIBO.' +
          LineEnding + LineEnding + E.Message
        );
        Exit;
      end;
    end;

    if not SeleccionCargada then
    begin
      ShowMessage('No se han encontrado facturas válidas en la selección.');
      Exit;
    end;

    Accion := FLXElegirAccion(AOwner, Grupos, Pagadas);
    if Accion = farCancelar then
      Exit;

    case Accion of
      farVistaPrevia:
        begin
          Directorio := IncludeTrailingPathDelimiter(GetTempDir(False)) +
            'FacturLinEx_Recibos_' +
            FormatDateTime('yyyymmdd_hhnnss_zzz', Now);

          if not FLXGenerarPDFs(Grupos, Directorio, Archivos,
            ErrorTexto) then
          begin
            ShowMessage('No se pudieron generar los recibos:' +
              LineEnding + ErrorTexto);
            Exit;
          end;

          if not FLXVistaPrevia(Archivos, ErrorTexto) then
          begin
            ShowMessage(ErrorTexto);
            Exit;
          end;

          Result := True;
        end;

      farGuardarPDF:
        begin
          DialogoDirectorio := TSelectDirectoryDialog.Create(nil);
          try
            DialogoDirectorio.Title :=
              'Seleccione la carpeta para guardar los recibos';
            DialogoDirectorio.InitialDir := GetCurrentDir;

            if not DialogoDirectorio.Execute then
              Exit;

            Directorio := DialogoDirectorio.FileName;
          finally
            DialogoDirectorio.Free;
          end;

          if not FLXGenerarPDFs(Grupos, Directorio, Archivos,
            ErrorTexto) then
          begin
            ShowMessage('No se pudieron guardar los recibos:' +
              LineEnding + ErrorTexto);
            Exit;
          end;

          ShowMessage('Recibos guardados correctamente:' + LineEnding +
            FLXListaArchivos(Archivos));
          Result := True;
        end;

      farImprimir:
        begin
          Directorio := IncludeTrailingPathDelimiter(GetTempDir(False)) +
            'FacturLinEx_Recibos_Impresion_' +
            FormatDateTime('yyyymmdd_hhnnss_zzz', Now);

          if not FLXGenerarPDFs(Grupos, Directorio, Archivos,
            ErrorTexto) then
          begin
            ShowMessage('No se pudieron generar los recibos:' +
              LineEnding + ErrorTexto);
            Exit;
          end;

          if not FLXImprimirPDFs(Archivos, ErrorTexto) then
          begin
            ShowMessage('No se completó la impresión. Las facturas no ' +
              'se han marcado como pagadas.' + LineEnding + LineEnding +
              ErrorTexto);
            Exit;
          end;

          if not FLXMarcarPagadas(AConnection, ATienda, ClavesValidas,
            ErrorTexto) then
          begin
            ShowMessage('Los recibos fueron enviados a la impresora, ' +
              'pero no se pudo actualizar la casilla Pagado:' +
              LineEnding + ErrorTexto);
            Exit;
          end;

          AFacturasMarcadasPagadas := True;
          ShowMessage(IntToStr(Archivos.Count) +
            ' recibo(s) enviado(s) a la impresora.' + LineEnding +
            'Las facturas incluidas se han marcado como pagadas.');
          Result := True;
        end;
    end;
  finally
    Archivos.Free;
    ClavesValidas.Free;
    FLXLiberarGrupos(Grupos);
  end;
end;

end.
