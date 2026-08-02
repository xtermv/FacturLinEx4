unit uFLXPDFSimple;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TFLXPDFPage = class
  public
    Content: TStringList;
    constructor Create;
    destructor Destroy; override;
  end;

  TFLXPDFDocument = class
  private
    FPages: TList;
    FCurrent: TFLXPDFPage;
    FPageWidth: Double;
    FPageHeight: Double;
    procedure AddCommand(const ACommand: string);
    function NumberToPDF(const AValue: Double): string;
    function TextToHex(const AText: string): string;
    function TextWidthApprox(const AText: string; const ASize: Double;
      ABold: Boolean): Double;
    procedure WriteASCII(AStream: TStream; const AText: AnsiString);
  public
    constructor Create;
    destructor Destroy; override;
    procedure NewPage;
    function PageCount: Integer;
    procedure SetFillColor(const R, G, B: Double);
    procedure SetStrokeColor(const R, G, B: Double);
    procedure SetLineWidth(const AWidth: Double);
    procedure FillRect(const X, Y, W, H: Double);
    procedure StrokeRect(const X, Y, W, H: Double);
    procedure Line(const X1, Y1, X2, Y2: Double);
    procedure Text(const X, Y, ASize: Double; const AText: string;
      ABold: Boolean = False);
    procedure TextRight(const XRight, Y, ASize: Double; const AText: string;
      ABold: Boolean = False);
    procedure TextCenter(const XCenter, Y, ASize: Double; const AText: string;
      ABold: Boolean = False);
    procedure AddPageNumbers;
    procedure SaveToFile(const AFileName: string);
    property PageWidth: Double read FPageWidth;
    property PageHeight: Double read FPageHeight;
  end;

implementation

constructor TFLXPDFPage.Create;
begin
  inherited Create;
  Content := TStringList.Create;
  Content.LineBreak := #10;
end;

destructor TFLXPDFPage.Destroy;
begin
  Content.Free;
  inherited Destroy;
end;

constructor TFLXPDFDocument.Create;
begin
  inherited Create;
  FPages := TList.Create;
  FCurrent := nil;
  FPageWidth := 595.28;
  FPageHeight := 841.89;
end;

destructor TFLXPDFDocument.Destroy;
var
  I: Integer;
begin
  for I := 0 to FPages.Count - 1 do
    TObject(FPages[I]).Free;
  FPages.Free;
  inherited Destroy;
end;

procedure TFLXPDFDocument.NewPage;
begin
  FCurrent := TFLXPDFPage.Create;
  FPages.Add(FCurrent);
end;

function TFLXPDFDocument.PageCount: Integer;
begin
  Result := FPages.Count;
end;

procedure TFLXPDFDocument.AddCommand(const ACommand: string);
begin
  if not Assigned(FCurrent) then
    NewPage;
  FCurrent.Content.Add(ACommand);
end;

function TFLXPDFDocument.NumberToPDF(const AValue: Double): string;
begin
  Result := FloatToStrF(AValue, ffFixed, 15, 2);
  Result := StringReplace(Result, ',', '.', [rfReplaceAll]);
end;

function FLXUnicodeToCP1252(const ACode: Cardinal): Byte;
begin
  if ACode <= 127 then
    Exit(Byte(ACode));

  if (ACode >= 160) and (ACode <= 255) then
    Exit(Byte(ACode));

  case ACode of
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

function TFLXPDFDocument.TextToHex(const AText: string): string;
var
  I, L, Needed, J: Integer;
  B: Byte;
  Code: Cardinal;
  Hex: string;
const
  Digits: array[0..15] of Char = '0123456789ABCDEF';
begin
  Result := '<';
  I := 1;
  L := Length(AText);

  while I <= L do
  begin
    B := Ord(AText[I]);
    Code := 0;
    Needed := 0;

    if B < $80 then
    begin
      Code := B;
      Needed := 0;
    end
    else if (B and $E0) = $C0 then
    begin
      Code := B and $1F;
      Needed := 1;
    end
    else if (B and $F0) = $E0 then
    begin
      Code := B and $0F;
      Needed := 2;
    end
    else if (B and $F8) = $F0 then
    begin
      Code := B and $07;
      Needed := 3;
    end
    else
    begin
      Code := Ord('?');
      Needed := 0;
    end;

    if Needed > 0 then
    begin
      if I + Needed <= L then
      begin
        for J := 1 to Needed do
        begin
          B := Ord(AText[I + J]);
          if (B and $C0) <> $80 then
          begin
            Code := Ord('?');
            Needed := J - 1;
            Break;
          end;
          Code := (Code shl 6) or (B and $3F);
        end;
      end
      else
      begin
        Code := Ord('?');
        Needed := 0;
      end;
    end;

    B := FLXUnicodeToCP1252(Code);
    Hex := Digits[B shr 4];
    Hex := Hex + Digits[B and $0F];
    Result := Result + Hex;
    Inc(I, Needed + 1);
  end;

  Result := Result + '>';
end;

function TFLXPDFDocument.TextWidthApprox(const AText: string;
  const ASize: Double; ABold: Boolean): Double;
var
  I, CountChars: Integer;
begin
  CountChars := 0;
  I := 1;
  while I <= Length(AText) do
  begin
    Inc(CountChars);
    if Ord(AText[I]) < $80 then
      Inc(I)
    else if (Ord(AText[I]) and $E0) = $C0 then
      Inc(I, 2)
    else if (Ord(AText[I]) and $F0) = $E0 then
      Inc(I, 3)
    else if (Ord(AText[I]) and $F8) = $F0 then
      Inc(I, 4)
    else
      Inc(I);
  end;

  if ABold then
    Result := CountChars * ASize * 0.56
  else
    Result := CountChars * ASize * 0.52;
end;

procedure TFLXPDFDocument.SetFillColor(const R, G, B: Double);
begin
  AddCommand(NumberToPDF(R) + ' ' + NumberToPDF(G) + ' ' +
    NumberToPDF(B) + ' rg');
end;

procedure TFLXPDFDocument.SetStrokeColor(const R, G, B: Double);
begin
  AddCommand(NumberToPDF(R) + ' ' + NumberToPDF(G) + ' ' +
    NumberToPDF(B) + ' RG');
end;

procedure TFLXPDFDocument.SetLineWidth(const AWidth: Double);
begin
  AddCommand(NumberToPDF(AWidth) + ' w');
end;

procedure TFLXPDFDocument.FillRect(const X, Y, W, H: Double);
begin
  AddCommand(NumberToPDF(X) + ' ' + NumberToPDF(Y) + ' ' +
    NumberToPDF(W) + ' ' + NumberToPDF(H) + ' re f');
end;

procedure TFLXPDFDocument.StrokeRect(const X, Y, W, H: Double);
begin
  AddCommand(NumberToPDF(X) + ' ' + NumberToPDF(Y) + ' ' +
    NumberToPDF(W) + ' ' + NumberToPDF(H) + ' re S');
end;

procedure TFLXPDFDocument.Line(const X1, Y1, X2, Y2: Double);
begin
  AddCommand(NumberToPDF(X1) + ' ' + NumberToPDF(Y1) + ' m ' +
    NumberToPDF(X2) + ' ' + NumberToPDF(Y2) + ' l S');
end;

procedure TFLXPDFDocument.Text(const X, Y, ASize: Double;
  const AText: string; ABold: Boolean);
var
  FontName: string;
begin
  if ABold then
    FontName := '/F2'
  else
    FontName := '/F1';

  AddCommand('BT ' + FontName + ' ' + NumberToPDF(ASize) +
    ' Tf 1 0 0 1 ' + NumberToPDF(X) + ' ' + NumberToPDF(Y) +
    ' Tm ' + TextToHex(AText) + ' Tj ET');
end;

procedure TFLXPDFDocument.TextRight(const XRight, Y, ASize: Double;
  const AText: string; ABold: Boolean);
begin
  Text(XRight - TextWidthApprox(AText, ASize, ABold), Y, ASize,
    AText, ABold);
end;

procedure TFLXPDFDocument.TextCenter(const XCenter, Y, ASize: Double;
  const AText: string; ABold: Boolean);
begin
  Text(XCenter - (TextWidthApprox(AText, ASize, ABold) / 2),
    Y, ASize, AText, ABold);
end;

procedure TFLXPDFDocument.AddPageNumbers;
var
  I, OldIndex: Integer;
  OldCurrent: TFLXPDFPage;
  Texto: string;
begin
  OldCurrent := FCurrent;
  OldIndex := FPages.IndexOf(OldCurrent);
  try
    for I := 0 to FPages.Count - 1 do
    begin
      FCurrent := TFLXPDFPage(FPages[I]);
      SetFillColor(0.38, 0.42, 0.45);
      Texto := 'Página ' + IntToStr(I + 1) + ' de ' +
        IntToStr(FPages.Count);
      TextRight(FPageWidth - 36, 24, 8, Texto, False);
      Text(36, 24, 8, 'FacturLinEx - Informe IVA / Periodos', False);
    end;
  finally
    if OldIndex >= 0 then
      FCurrent := TFLXPDFPage(FPages[OldIndex])
    else
      FCurrent := OldCurrent;
  end;
end;

procedure TFLXPDFDocument.WriteASCII(AStream: TStream;
  const AText: AnsiString);
begin
  if Length(AText) > 0 then
    AStream.WriteBuffer(AText[1], Length(AText));
end;

procedure TFLXPDFDocument.SaveToFile(const AFileName: string);
var
  Stream: TFileStream;
  Offsets: array of Int64;
  ObjCount, I, PageObj, ContentObj: Integer;
  Kids, ObjText: AnsiString;
  ContentData: AnsiString;
  XRefPos: Int64;

  procedure WriteObject(const AObjectNumber: Integer;
    const AObjectText: AnsiString);
  begin
    Offsets[AObjectNumber] := Stream.Position;
    WriteASCII(Stream, AnsiString(IntToStr(AObjectNumber) +
      ' 0 obj'#10));
    WriteASCII(Stream, AObjectText);
    if (Length(AObjectText) = 0) or
       (AObjectText[Length(AObjectText)] <> #10) then
      WriteASCII(Stream, #10);
    WriteASCII(Stream, 'endobj'#10);
  end;

begin
  if FPages.Count = 0 then
    NewPage;

  ForceDirectories(ExtractFileDir(ExpandFileName(AFileName)));
  ObjCount := 4 + (FPages.Count * 2);
  SetLength(Offsets, ObjCount + 1);
  Stream := TFileStream.Create(AFileName, fmCreate);
  try
    WriteASCII(Stream, '%PDF-1.4'#10'%FacturLinEx'#10);

    WriteObject(1, '<< /Type /Catalog /Pages 2 0 R >>');

    Kids := '';
    for I := 0 to FPages.Count - 1 do
    begin
      PageObj := 5 + (I * 2);
      Kids := Kids + AnsiString(IntToStr(PageObj) + ' 0 R ');
    end;
    WriteObject(2, '<< /Type /Pages /Kids [' + Kids +
      '] /Count ' + AnsiString(IntToStr(FPages.Count)) + ' >>');

    WriteObject(3, '<< /Type /Font /Subtype /Type1 ' +
      '/BaseFont /Helvetica /Encoding /WinAnsiEncoding >>');
    WriteObject(4, '<< /Type /Font /Subtype /Type1 ' +
      '/BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>');

    for I := 0 to FPages.Count - 1 do
    begin
      PageObj := 5 + (I * 2);
      ContentObj := PageObj + 1;
      ObjText := '<< /Type /Page /Parent 2 0 R ' +
        '/MediaBox [0 0 595.28 841.89] ' +
        '/Resources << /Font << /F1 3 0 R /F2 4 0 R >> >> ' +
        '/Contents ' + AnsiString(IntToStr(ContentObj)) + ' 0 R >>';
      WriteObject(PageObj, ObjText);

      ContentData := AnsiString(TFLXPDFPage(FPages[I]).Content.Text);
      ObjText := '<< /Length ' + AnsiString(IntToStr(Length(ContentData))) +
        ' >>'#10'stream'#10 + ContentData + 'endstream';
      WriteObject(ContentObj, ObjText);
    end;

    XRefPos := Stream.Position;
    WriteASCII(Stream, 'xref'#10'0 ' + AnsiString(IntToStr(ObjCount + 1)) + #10);
    WriteASCII(Stream, '0000000000 65535 f '#10);
    for I := 1 to ObjCount do
    begin
      ObjText := AnsiString(IntToStr(Offsets[I]));
      while Length(ObjText) < 10 do
        ObjText := '0' + ObjText;
      WriteASCII(Stream, ObjText + ' 00000 n '#10);
    end;

    WriteASCII(Stream, 'trailer'#10'<< /Size ' +
      AnsiString(IntToStr(ObjCount + 1)) + ' /Root 1 0 R >>'#10);
    WriteASCII(Stream, 'startxref'#10 + AnsiString(IntToStr(XRefPos)) +
      #10'%%EOF'#10);
  finally
    Stream.Free;
  end;
end;

end.
