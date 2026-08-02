unit uFLXExportGrid;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, DBGrids, Grids, Process;

procedure ExportarGridAPDF(AGrid: TDBGrid; const AFileName, ATitulo: String;
  ACabecera: TStrings);
procedure ExportarGridACSV(AGrid: TDBGrid; const AFileName: String);
function PrevisualizarPDFPredeterminado(const AFileName: String;
  out AMensaje: String): Boolean;
function ImprimirPDFPredeterminado(const AFileName: String;
  out AMensaje: String): Boolean;

implementation

type
  TIntArray = array of Integer;
  TDoubleArray = array of Double;
  TInt64Array = array of Int64;

const
  PDF_ANCHO = 842.0;   // A4 apaisado
  PDF_ALTO = 595.0;
  PDF_MARGEN = 28.0;

function ReemplazarFlechas(const S: String): String;
begin
  Result := StringReplace(S, ' ▲', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' ▼', '', [rfReplaceAll]);
end;

function UTF8AWinAnsiSimple(const S: String): RawByteString;
var
  I, L, CodePoint: Integer;
  B1, B2, B3: Byte;

  function MapearCP1252(AValue: Integer): Byte;
  begin
    if (AValue >= 0) and (AValue <= 255) then
      Exit(Byte(AValue));
    case AValue of
      $20AC: Result := 128;
      $201A: Result := 130;
      $0192: Result := 131;
      $201E: Result := 132;
      $2026: Result := 133;
      $2020: Result := 134;
      $2021: Result := 135;
      $02C6: Result := 136;
      $2030: Result := 137;
      $0160: Result := 138;
      $2039: Result := 139;
      $0152: Result := 140;
      $017D: Result := 142;
      $2018: Result := 145;
      $2019: Result := 146;
      $201C: Result := 147;
      $201D: Result := 148;
      $2022: Result := 149;
      $2013: Result := 150;
      $2014: Result := 151;
      $02DC: Result := 152;
      $2122: Result := 153;
      $0161: Result := 154;
      $203A: Result := 155;
      $0153: Result := 156;
      $017E: Result := 158;
      $0178: Result := 159;
    else
      Result := Ord('?');
    end;
  end;

begin
  Result := '';
  I := 1;
  L := Length(S);
  while I <= L do
  begin
    B1 := Byte(S[I]);
    if B1 < $80 then
    begin
      CodePoint := B1;
      Inc(I);
    end
    else if ((B1 and $E0) = $C0) and (I + 1 <= L) then
    begin
      B2 := Byte(S[I + 1]);
      CodePoint := ((B1 and $1F) shl 6) or (B2 and $3F);
      Inc(I, 2);
    end
    else if ((B1 and $F0) = $E0) and (I + 2 <= L) then
    begin
      B2 := Byte(S[I + 1]);
      B3 := Byte(S[I + 2]);
      CodePoint := ((B1 and $0F) shl 12) or ((B2 and $3F) shl 6) or
        (B3 and $3F);
      Inc(I, 3);
    end
    else
    begin
      CodePoint := Ord('?');
      Inc(I);
    end;
    Result := Result + AnsiChar(MapearCP1252(CodePoint));
  end;
end;

function BytesAHex(const S: RawByteString): RawByteString;
const
  HexChars = '0123456789ABCDEF';
var
  I, P: Integer;
  B: Byte;
begin
  SetLength(Result, Length(S) * 2);
  P := 1;
  for I := 1 to Length(S) do
  begin
    B := Byte(S[I]);
    Result[P] := HexChars[(B shr 4) + 1];
    Result[P + 1] := HexChars[(B and $0F) + 1];
    Inc(P, 2);
  end;
end;

function NumPDF(AValue: Double): String;
begin
  Result := StringReplace(FormatFloat('0.###', AValue), ',', '.', [rfReplaceAll]);
end;

procedure AnadirTexto(AComandos: TStrings; X, Y, ASize: Double;
  const ATexto: String; ABold: Boolean; AAncho: Double;
  AAlignment: TAlignment);
var
  Fuente: String;
  TextoAnsi, HexTexto: RawByteString;
  MaxChars: Integer;
  AnchoEstimado, PosX: Double;
begin
  if AAncho <= 0 then Exit;
  MaxChars := Trunc(AAncho / (ASize * 0.53));
  TextoAnsi := UTF8AWinAnsiSimple(ATexto);
  if Length(TextoAnsi) > MaxChars then
  begin
    if MaxChars > 3 then
      TextoAnsi := Copy(TextoAnsi, 1, MaxChars - 3) + '...'
    else
      TextoAnsi := Copy(TextoAnsi, 1, MaxChars);
  end;
  HexTexto := BytesAHex(TextoAnsi);
  AnchoEstimado := Length(TextoAnsi) * ASize * 0.53;
  PosX := X;
  case AAlignment of
    taRightJustify: PosX := X + AAncho - AnchoEstimado - 2;
    taCenter: PosX := X + (AAncho - AnchoEstimado) / 2;
  end;
  if PosX < X then PosX := X;
  if ABold then Fuente := '/F2' else Fuente := '/F1';
  AComandos.Add('BT ' + Fuente + ' ' + NumPDF(ASize) +
    ' Tf 1 0 0 1 ' + NumPDF(PosX) + ' ' + NumPDF(Y) +
    ' Tm <' + String(HexTexto) + '> Tj ET');
end;

procedure AnadirLinea(AComandos: TStrings; X1, Y1, X2, Y2: Double);
begin
  AComandos.Add('0.72 G 0.35 w ' + NumPDF(X1) + ' ' + NumPDF(Y1) +
    ' m ' + NumPDF(X2) + ' ' + NumPDF(Y2) + ' l S 0 G');
end;

procedure AnadirRectRelleno(AComandos: TStrings; X, Y, W, H, Gris: Double);
begin
  AComandos.Add(NumPDF(Gris) + ' g ' + NumPDF(X) + ' ' + NumPDF(Y) + ' ' +
    NumPDF(W) + ' ' + NumPDF(H) + ' re f 0 g');
end;

procedure EscribirRaw(AStream: TStream; const S: RawByteString);
begin
  if Length(S) > 0 then AStream.WriteBuffer(S[1], Length(S));
end;

function Rellenar10(AValue: Int64): String;
begin
  Result := IntToStr(AValue);
  while Length(Result) < 10 do Result := '0' + Result;
end;

procedure EscribirObjeto(AStream: TStream; ANumero: Integer;
  const AContenido: RawByteString; var AOffsets: TInt64Array);
begin
  AOffsets[ANumero] := AStream.Position;
  EscribirRaw(AStream, RawByteString(IntToStr(ANumero) + ' 0 obj'#10));
  EscribirRaw(AStream, AContenido);
  EscribirRaw(AStream, #10'endobj'#10);
end;

procedure GuardarPDF(const AFileName: String; APaginas: TStrings);
var
  FS: TFileStream;
  Offsets: TInt64Array;
  ObjCount, I, PagObj, ContObj: Integer;
  Kids, Contenido, Obj: RawByteString;
  XRefPos: Int64;
begin
  ObjCount := 4 + APaginas.Count * 2;
  SetLength(Offsets, ObjCount + 1);
  FS := TFileStream.Create(AFileName, fmCreate);
  try
    EscribirRaw(FS, '%PDF-1.4'#10'%FacturLinEx'#10);
    EscribirObjeto(FS, 1, '<< /Type /Catalog /Pages 2 0 R >>', Offsets);

    Kids := '';
    for I := 0 to APaginas.Count - 1 do
    begin
      PagObj := 5 + I * 2;
      Kids := Kids + RawByteString(IntToStr(PagObj) + ' 0 R ');
    end;
    EscribirObjeto(FS, 2, RawByteString('<< /Type /Pages /Kids [' +
      String(Kids) + '] /Count ' + IntToStr(APaginas.Count) + ' >>'), Offsets);
    EscribirObjeto(FS, 3,
      '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>',
      Offsets);
    EscribirObjeto(FS, 4,
      '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>',
      Offsets);

    for I := 0 to APaginas.Count - 1 do
    begin
      PagObj := 5 + I * 2;
      ContObj := PagObj + 1;
      Obj := RawByteString('<< /Type /Page /Parent 2 0 R /MediaBox [0 0 842 595] ' +
        '/Resources << /Font << /F1 3 0 R /F2 4 0 R >> >> /Contents ' +
        IntToStr(ContObj) + ' 0 R >>');
      EscribirObjeto(FS, PagObj, Obj, Offsets);
      Contenido := RawByteString(APaginas[I]);
      Obj := RawByteString('<< /Length ' + IntToStr(Length(Contenido)) +
        ' >>'#10'stream'#10) + Contenido + #10'endstream';
      EscribirObjeto(FS, ContObj, Obj, Offsets);
    end;

    XRefPos := FS.Position;
    EscribirRaw(FS, RawByteString('xref'#10'0 ' + IntToStr(ObjCount + 1) + #10));
    EscribirRaw(FS, '0000000000 65535 f '#10);
    for I := 1 to ObjCount do
      EscribirRaw(FS, RawByteString(Rellenar10(Offsets[I]) + ' 00000 n '#10));
    EscribirRaw(FS, RawByteString('trailer'#10'<< /Size ' +
      IntToStr(ObjCount + 1) + ' /Root 1 0 R >>'#10'startxref'#10 +
      IntToStr(XRefPos) + #10'%%EOF'#10));
  finally
    FS.Free;
  end;
end;

procedure ObtenerColumnasVisibles(AGrid: TDBGrid; out AIndices: TIntArray;
  out AAnchos: TDoubleArray);
var
  I, N: Integer;
  TotalPeso, Disponible, Escala, Suma: Double;
begin
  N := 0;
  SetLength(AIndices, AGrid.Columns.Count);
  SetLength(AAnchos, AGrid.Columns.Count);
  TotalPeso := 0;
  for I := 0 to AGrid.Columns.Count - 1 do
    if AGrid.Columns[I].Visible and Assigned(AGrid.Columns[I].Field) then
    begin
      AIndices[N] := I;
      AAnchos[N] := AGrid.Columns[I].Width;
      if AAnchos[N] < 35 then AAnchos[N] := 35;
      TotalPeso := TotalPeso + AAnchos[N];
      Inc(N);
    end;
  SetLength(AIndices, N);
  SetLength(AAnchos, N);
  if N = 0 then Exit;

  Disponible := PDF_ANCHO - 2 * PDF_MARGEN;
  if TotalPeso <= 0 then TotalPeso := N;
  for I := 0 to N - 1 do
    AAnchos[I] := Disponible * AAnchos[I] / TotalPeso;

  Suma := 0;
  for I := 0 to N - 1 do
  begin
    if AAnchos[I] < 34 then AAnchos[I] := 34;
    Suma := Suma + AAnchos[I];
  end;
  if Suma > Disponible then
  begin
    Escala := Disponible / Suma;
    for I := 0 to N - 1 do AAnchos[I] := AAnchos[I] * Escala;
  end;
end;

procedure ExportarGridAPDF(AGrid: TDBGrid; const AFileName, ATitulo: String;
  ACabecera: TStrings);
var
  Paginas, Comandos: TStringList;
  Indices: TIntArray;
  Anchos: TDoubleArray;
  DataSet: TDataSet;
  OldRecNo, I, C, TotalPaginas: Integer;
  X, Y, TopTabla, AltoFila, FontSize, HeaderFontSize: Double;
  Texto, TituloColumna: String;
  Alineacion: TAlignment;

  procedure IniciarPagina;
  var
    J: Integer;
  begin
    Comandos.Clear;
    AnadirTexto(Comandos, PDF_MARGEN, PDF_ALTO - 35, 15, ATitulo, True,
      PDF_ANCHO - 2 * PDF_MARGEN, taLeftJustify);
    Y := PDF_ALTO - 53;
    if Assigned(ACabecera) then
      for J := 0 to ACabecera.Count - 1 do
      begin
        AnadirTexto(Comandos, PDF_MARGEN, Y, 8.5, ACabecera[J], False,
          PDF_ANCHO - 2 * PDF_MARGEN, taLeftJustify);
        Y := Y - 11;
      end;
    Y := Y - 4;
    TopTabla := Y;
    AnadirRectRelleno(Comandos, PDF_MARGEN, TopTabla - 18,
      PDF_ANCHO - 2 * PDF_MARGEN, 18, 0.90);
    X := PDF_MARGEN;
    for J := 0 to High(Indices) do
    begin
      TituloColumna := ReemplazarFlechas(AGrid.Columns[Indices[J]].Title.Caption);
      AnadirTexto(Comandos, X + 2, TopTabla - 13, HeaderFontSize,
        TituloColumna, True, Anchos[J] - 4, taCenter);
      AnadirLinea(Comandos, X, TopTabla, X, TopTabla - 18);
      X := X + Anchos[J];
    end;
    AnadirLinea(Comandos, PDF_MARGEN, TopTabla,
      PDF_ANCHO - PDF_MARGEN, TopTabla);
    AnadirLinea(Comandos, PDF_MARGEN, TopTabla - 18,
      PDF_ANCHO - PDF_MARGEN, TopTabla - 18);
    AnadirLinea(Comandos, PDF_ANCHO - PDF_MARGEN, TopTabla,
      PDF_ANCHO - PDF_MARGEN, TopTabla - 18);
    Y := TopTabla - 18 - AltoFila;
  end;

  procedure CerrarPagina;
  begin
    Paginas.Add(Comandos.Text);
  end;

begin
  if (AGrid = nil) or (AGrid.DataSource = nil) or
     (AGrid.DataSource.DataSet = nil) then
    raise Exception.Create('El grid no tiene un conjunto de datos asignado.');
  DataSet := AGrid.DataSource.DataSet;
  if not DataSet.Active then
    raise Exception.Create('El conjunto de datos no está abierto.');

  ObtenerColumnasVisibles(AGrid, Indices, Anchos);
  if Length(Indices) = 0 then
    raise Exception.Create('No hay columnas visibles para exportar.');

  Paginas := TStringList.Create;
  Comandos := TStringList.Create;
  try
    if Length(Indices) >= 12 then FontSize := 5.7
    else if Length(Indices) >= 9 then FontSize := 6.3
    else FontSize := 7.2;
    HeaderFontSize := FontSize;
    AltoFila := 13;
    IniciarPagina;

    OldRecNo := DataSet.RecNo;
    DataSet.DisableControls;
    try
      DataSet.First;
      I := 0;
      while not DataSet.EOF do
      begin
        if Y < 38 then
        begin
          CerrarPagina;
          IniciarPagina;
        end;
        if Odd(I) then
          AnadirRectRelleno(Comandos, PDF_MARGEN, Y - 2,
            PDF_ANCHO - 2 * PDF_MARGEN, AltoFila, 0.97);
        X := PDF_MARGEN;
        for C := 0 to High(Indices) do
        begin
          Texto := AGrid.Columns[Indices[C]].Field.DisplayText;
          Alineacion := AGrid.Columns[Indices[C]].Alignment;
          if Alineacion = taLeftJustify then
            Alineacion := AGrid.Columns[Indices[C]].Field.Alignment;
          AnadirTexto(Comandos, X + 2, Y + 2, FontSize, Texto, False,
            Anchos[C] - 4, Alineacion);
          AnadirLinea(Comandos, X, Y + AltoFila - 2, X, Y - 2);
          X := X + Anchos[C];
        end;
        AnadirLinea(Comandos, PDF_ANCHO - PDF_MARGEN, Y + AltoFila - 2,
          PDF_ANCHO - PDF_MARGEN, Y - 2);
        AnadirLinea(Comandos, PDF_MARGEN, Y - 2,
          PDF_ANCHO - PDF_MARGEN, Y - 2);
        Y := Y - AltoFila;
        Inc(I);
        DataSet.Next;
      end;
      if I = 0 then
        AnadirTexto(Comandos, PDF_MARGEN + 8, Y, 9,
          'No hay registros para mostrar.', False,
          PDF_ANCHO - 2 * PDF_MARGEN - 16, taLeftJustify);
      CerrarPagina;
    finally
      try
        if OldRecNo > 0 then DataSet.RecNo := OldRecNo;
      except
      end;
      DataSet.EnableControls;
    end;

    TotalPaginas := Paginas.Count;
    for I := 0 to TotalPaginas - 1 do
      Paginas[I] := Paginas[I] +
        'BT /F1 7 Tf 1 0 0 1 720 16 Tm <' +
        String(BytesAHex(UTF8AWinAnsiSimple('Página ' + IntToStr(I + 1) +
          ' de ' + IntToStr(TotalPaginas)))) + '> Tj ET'#10;

    GuardarPDF(AFileName, Paginas);
  finally
    Comandos.Free;
    Paginas.Free;
  end;
end;

function EscaparCSV(const S: String): String;
begin
  Result := StringReplace(S, '"', '""', [rfReplaceAll]);
  Result := '"' + Result + '"';
end;

procedure ExportarGridACSV(AGrid: TDBGrid; const AFileName: String);
var
  SL: TStringList;
  FS: TFileStream;
  DataSet: TDataSet;
  Indices: TIntArray;
  Anchos: TDoubleArray;
  I, OldRecNo: Integer;
  Linea: String;
begin
  if (AGrid = nil) or (AGrid.DataSource = nil) or
     (AGrid.DataSource.DataSet = nil) then
    raise Exception.Create('El grid no tiene un conjunto de datos asignado.');
  DataSet := AGrid.DataSource.DataSet;
  if not DataSet.Active then
    raise Exception.Create('El conjunto de datos no está abierto.');
  ObtenerColumnasVisibles(AGrid, Indices, Anchos);
  if Length(Indices) = 0 then
    raise Exception.Create('No hay columnas visibles para exportar.');

  SL := TStringList.Create;
  try
    Linea := '';
    for I := 0 to High(Indices) do
    begin
      if I > 0 then Linea := Linea + ';';
      Linea := Linea + EscaparCSV(ReemplazarFlechas(
        AGrid.Columns[Indices[I]].Title.Caption));
    end;
    SL.Add(Linea);

    OldRecNo := DataSet.RecNo;
    DataSet.DisableControls;
    try
      DataSet.First;
      while not DataSet.EOF do
      begin
        Linea := '';
        for I := 0 to High(Indices) do
        begin
          if I > 0 then Linea := Linea + ';';
          Linea := Linea + EscaparCSV(
            AGrid.Columns[Indices[I]].Field.DisplayText);
        end;
        SL.Add(Linea);
        DataSet.Next;
      end;
    finally
      try
        if OldRecNo > 0 then DataSet.RecNo := OldRecNo;
      except
      end;
      DataSet.EnableControls;
    end;

    // BOM UTF-8 para que LibreOffice/Excel reconozcan correctamente acentos.
    FS := TFileStream.Create(AFileName, fmCreate);
    try
      EscribirRaw(FS, #$EF#$BB#$BF);
      EscribirRaw(FS, RawByteString(SL.Text));
    finally
      FS.Free;
    end;
  finally
    SL.Free;
  end;
end;

function PrevisualizarPDFPredeterminado(const AFileName: String;
  out AMensaje: String): Boolean;
var
  P: TProcess;
  Ejecutable: String;
begin
  Result := False;
  AMensaje := '';

  if not FileExists(AFileName) then
  begin
    AMensaje := 'No se encontró el PDF que se quiere previsualizar: ' + AFileName;
    Exit;
  end;

  if FileExists('/usr/bin/xdg-open') then
    Ejecutable := '/usr/bin/xdg-open'
  else if FileExists('/usr/bin/gio') then
    Ejecutable := '/usr/bin/gio'
  else
  begin
    AMensaje := 'No se encontró xdg-open ni gio para abrir el visor de PDF. ' +
      'El archivo permanece en: ' + AFileName;
    Exit;
  end;

  P := TProcess.Create(nil);
  try
    P.Executable := Ejecutable;
    if ExtractFileName(Ejecutable) = 'gio' then
      P.Parameters.Add('open');
    P.Parameters.Add(AFileName);
    try
      // No se espera al cierre del visor: la previsualización debe ser inmediata.
      P.Execute;
      Result := True;
      AMensaje := 'El PDF se ha abierto en el visor predeterminado.';
    except
      on E: Exception do
        AMensaje := 'No se pudo abrir la previsualización: ' + E.Message +
          '. El PDF permanece en: ' + AFileName;
    end;
  finally
    P.Free;
  end;
end;

function ImprimirPDFPredeterminado(const AFileName: String;
  out AMensaje: String): Boolean;
var
  P: TProcess;
  Ejecutable: String;
begin
  Result := False;
  AMensaje := '';
  if FileExists('/usr/bin/lp') then Ejecutable := '/usr/bin/lp'
  else if FileExists('/usr/bin/lpr') then Ejecutable := '/usr/bin/lpr'
  else
  begin
    AMensaje := 'No se encontró el comando lp ni lpr. El PDF se ha guardado en: ' +
      AFileName;
    Exit;
  end;

  P := TProcess.Create(nil);
  try
    P.Executable := Ejecutable;
    P.Parameters.Add(AFileName);
    P.Options := [poWaitOnExit];
    try
      P.Execute;
      Result := P.ExitStatus = 0;
      if Result then
        AMensaje := 'El PDF se ha enviado a la impresora predeterminada.'
      else
        AMensaje := 'No se pudo enviar el PDF a la impresora. Código de salida: ' +
          IntToStr(P.ExitStatus) + '. El archivo permanece en: ' + AFileName;
    except
      on E: Exception do
        AMensaje := 'No se pudo ejecutar la impresión: ' + E.Message +
          '. El PDF permanece en: ' + AFileName;
    end;
  finally
    P.Free;
  end;
end;

end.
