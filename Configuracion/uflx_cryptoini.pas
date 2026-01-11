unit uFLX_CryptoIni;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles;

function FLX_IsEncrypted(const S: string): Boolean;

// Con Contexto explícito
function FLX_EncryptStringCtx(const Plain: string; const Context: string): string;
function FLX_DecryptStringCtx(const Enc: string; const Context: string): string;

// Wrappers sin Contexto (lo típico)
function FLX_EncryptString(const Plain: string): string;
function FLX_DecryptString(const Enc: string): string;

// Helpers directos INI
procedure FLX_IniWriteEncryptedStringCtx(Ini: TCustomIniFile;
  const Section, Ident, Plain, Context: string);

function FLX_IniReadDecryptedStringCtx(Ini: TCustomIniFile;
  const Section, Ident, Default, Context: string): string;

// Wrappers INI sin Contexto (Section|Ident)
procedure FLX_IniWriteEncryptedString(Ini: TCustomIniFile;
  const Section, Ident, Plain: string);

function FLX_IniReadDecryptedString(Ini: TCustomIniFile;
  const Section, Ident, Default: string): string;

// Atajos password (igual que string)
procedure FLX_IniWritePassword(Ini: TCustomIniFile;
  const Section, Ident, Password: string);

function FLX_IniReadPassword(Ini: TCustomIniFile;
  const Section, Ident: string; const Default: string = ''): string;

implementation

uses
  base64, BaseUnix,
  DCPcrypt2, DCPrijndael, DCPsha256;

const
  FLX_MAGIC = 'FLXENCv1$';
  FLX_SECRET_DIR  = '.config/facturlinex';
  FLX_SECRET_FILE = 'secret.key';

type
  TBytes = array of Byte;

function StrToBytes(const S: string): TBytes;
begin
  Result := nil;
  if S = '' then Exit;
  SetLength(Result, Length(S));
  Move(S[1], Result[0], Length(S));
end;

function BytesToStr(const B: TBytes): string;
begin
  if Length(B) = 0 then Exit('');
  SetLength(Result, Length(B));
  Move(B[0], Result[1], Length(B));
end;

function B64EncodeBytes(const B: TBytes): string;
begin
  if Length(B) = 0 then Exit('');
  Result := EncodeStringBase64(BytesToStr(B));
end;

function B64DecodeBytes(const S: string): TBytes;
var
  Raw: string;
begin
  Raw := DecodeStringBase64(S);
  Result := StrToBytes(Raw);
end;

function GetHomeDirSafe: string;
begin
  Result := GetEnvironmentVariable('HOME');
  if Result = '' then
    Result := GetTempDir(False);
end;

function GetSecretKeyPath: string;
begin
  Result := IncludeTrailingPathDelimiter(GetHomeDirSafe) +
            IncludeTrailingPathDelimiter(FLX_SECRET_DIR) +
            FLX_SECRET_FILE;
end;

procedure EnsureDirExists(const Dir: string);
begin
  if (Dir <> '') and (not DirectoryExists(Dir)) then
    ForceDirectories(Dir);
end;

function ReadAllTextFile(const FN: string): string;
var
  FS: TFileStream;
  S: TStringStream;
begin
  Result := '';
  if not FileExists(FN) then Exit;
  FS := TFileStream.Create(FN, fmOpenRead or fmShareDenyWrite);
  try
    S := TStringStream.Create('');
    try
      S.CopyFrom(FS, FS.Size);
      Result := Trim(S.DataString);
    finally
      S.Free;
    end;
  finally
    FS.Free;
  end;
end;

procedure WriteAllTextFile(const FN, Content: string);
var
  FS: TFileStream;
  S: TStringStream;
begin
  EnsureDirExists(ExtractFileDir(FN));
  FS := TFileStream.Create(FN, fmCreate);
  try
    S := TStringStream.Create(Content);
    try
      S.Position := 0;
      FS.CopyFrom(S, S.Size);
    finally
      S.Free;
    end;
  finally
    FS.Free;
  end;
end;

function ReadRandomBytes(Count: Integer): TBytes;
var
  FS: TFileStream;
  ReadN: Integer;
begin
  SetLength(Result, Count);

  if FileExists('/dev/urandom') then
  begin
    FS := TFileStream.Create('/dev/urandom', fmOpenRead or fmShareDenyWrite);
    try
      ReadN := FS.Read(Result[0], Count);
      if ReadN = Count then Exit;
    finally
      FS.Free;
    end;
  end;

  Randomize;
  for ReadN := 0 to Count - 1 do
    Result[ReadN] := Byte(Random(256));
end;

function GetOrCreateMasterKeyBytes: TBytes;
var
  KeyPath, KeyText: string;
  KeyRaw: TBytes;
begin
  KeyPath := GetSecretKeyPath;
  KeyText := ReadAllTextFile(KeyPath);

  if KeyText = '' then
  begin
    KeyRaw := ReadRandomBytes(32);
    KeyText := B64EncodeBytes(KeyRaw);
    WriteAllTextFile(KeyPath, KeyText);
    try
      fpchmod(PChar(KeyPath), &600);
    except
      // si falla permisos, no rompemos
    end;
  end;

  Result := B64DecodeBytes(KeyText);
  if Length(Result) < 16 then
    raise Exception.Create('Clave maestra inválida en: ' + KeyPath);
end;

function ConcatBytes(const A, B: TBytes): TBytes;
var
  LA, LB: Integer;
begin
  LA := Length(A);
  LB := Length(B);
  SetLength(Result, LA + LB);
  if LA > 0 then Move(A[0], Result[0], LA);
  if LB > 0 then Move(B[0], Result[LA], LB);
end;

{ -------- SHA256 / HMAC -------- }

function SHA256Bytes(const Data: TBytes): TBytes;
var
  H: TDCP_sha256;
  Digest: array[0..31] of Byte;
begin
  SetLength(Result, 32);
  H := TDCP_sha256.Create(nil);
  try
    H.Init;
    if Length(Data) > 0 then
      H.Update(Data[0], Length(Data));
    H.Final(Digest);
    Move(Digest[0], Result[0], 32);
  finally
    H.Free;
  end;
end;

function HMAC_SHA256(const Key, Msg: TBytes): TBytes;
const
  BlockSize = 64;
var
  K0, o_key_pad, i_key_pad: TBytes;
  i, L: Integer;
  Inner, Outer: TBytes;
begin
  if Length(Key) > BlockSize then
    K0 := SHA256Bytes(Key)
  else
    K0 := Copy(Key, 0, Length(Key));

  L := Length(K0);
  SetLength(K0, BlockSize);
  for i := L to BlockSize - 1 do
    K0[i] := 0;

  SetLength(o_key_pad, BlockSize);
  SetLength(i_key_pad, BlockSize);
  for i := 0 to BlockSize - 1 do
  begin
    o_key_pad[i] := K0[i] xor $5c;
    i_key_pad[i] := K0[i] xor $36;
  end;

  SetLength(Inner, BlockSize + Length(Msg));
  Move(i_key_pad[0], Inner[0], BlockSize);
  if Length(Msg) > 0 then
    Move(Msg[0], Inner[BlockSize], Length(Msg));
  Inner := SHA256Bytes(Inner);

  SetLength(Outer, BlockSize + Length(Inner));
  Move(o_key_pad[0], Outer[0], BlockSize);
  Move(Inner[0], Outer[BlockSize], Length(Inner));
  Result := SHA256Bytes(Outer);
end;

{ -------- PBKDF2-HMAC-SHA256 -------- }

function Int32BE(X: Integer): TBytes;
begin
  SetLength(Result, 4);
  Result[0] := Byte((X shr 24) and $FF);
  Result[1] := Byte((X shr 16) and $FF);
  Result[2] := Byte((X shr 8) and $FF);
  Result[3] := Byte(X and $FF);
end;

function PBKDF2_HMAC_SHA256(const Password, Salt: TBytes; Iterations, DKLen: Integer): TBytes;
var
  BlockCount, i, j, k: Integer;
  U, T, SaltInt, IBlock: TBytes;
  PosOut: Integer;
begin
  if Iterations < 1 then Iterations := 1;
  if DKLen < 1 then DKLen := 32;

  BlockCount := (DKLen + 31) div 32;
  SetLength(Result, DKLen);
  PosOut := 0;

  for i := 1 to BlockCount do
  begin
    IBlock := Int32BE(i);

    SetLength(SaltInt, Length(Salt) + 4);
    if Length(Salt) > 0 then
      Move(Salt[0], SaltInt[0], Length(Salt));
    Move(IBlock[0], SaltInt[Length(Salt)], 4);

    U := HMAC_SHA256(Password, SaltInt);
    T := Copy(U, 0, Length(U));

    for j := 2 to Iterations do
    begin
      U := HMAC_SHA256(Password, U);
      for k := 0 to High(T) do
        T[k] := T[k] xor U[k];
    end;

    for k := 0 to 31 do
    begin
      if PosOut >= DKLen then Break;
      Result[PosOut] := T[k];
      Inc(PosOut);
    end;
  end;
end;

function FLX_IsEncrypted(const S: string): Boolean;
begin
  Result := (Copy(S, 1, Length(FLX_MAGIC)) = FLX_MAGIC);
end;

function FLX_EncryptStringCtx(const Plain: string; const Context: string): string;
var
  MasterKey, Salt, IV: TBytes;
  KeyEnc, KeyMac: TBytes;
  PlainB, CipherB: TBytes;
  AES: TDCP_rijndael;
  PadLen, i: Integer;
  DataToMac, Mac: TBytes;
  CtxB: TBytes;
begin
  if Plain = '' then Exit('');

  MasterKey := GetOrCreateMasterKeyBytes;

  Salt := ReadRandomBytes(16);
  IV   := ReadRandomBytes(16);

  CtxB := StrToBytes(Context);

  KeyEnc := PBKDF2_HMAC_SHA256(ConcatBytes(MasterKey, CtxB), Salt, 60000, 64);
  KeyMac := Copy(KeyEnc, 32, 32);
  SetLength(KeyEnc, 32);

  PlainB := StrToBytes(Plain);
  PadLen := 16 - (Length(PlainB) mod 16);
  if PadLen = 0 then PadLen := 16;
  SetLength(PlainB, Length(PlainB) + PadLen);
  for i := Length(PlainB) - PadLen to High(PlainB) do
    PlainB[i] := Byte(PadLen);

  CipherB := Copy(PlainB, 0, Length(PlainB));
  AES := TDCP_rijndael.Create(nil);
  try
    AES.Init(KeyEnc[0], 256, @IV[0]);
    AES.EncryptCBC(CipherB[0], CipherB[0], Length(CipherB));
    AES.Burn;
  finally
    AES.Free;
  end;

  DataToMac := ConcatBytes(Salt, ConcatBytes(IV, CipherB));
  if Context <> '' then
    DataToMac := ConcatBytes(DataToMac, CtxB);

  Mac := HMAC_SHA256(KeyMac, DataToMac);

  Result := FLX_MAGIC +
            B64EncodeBytes(Salt) + '$' +
            B64EncodeBytes(IV) + '$' +
            B64EncodeBytes(CipherB) + '$' +
            B64EncodeBytes(Mac);
end;

function FLX_DecryptStringCtx(const Enc: string; const Context: string): string;
var
  Parts: TStringArray;
  MasterKey, Salt, IV, CipherB, MacStored, MacCalc: TBytes;
  KeyEnc, KeyMac: TBytes;
  AES: TDCP_rijndael;
  DataToMac: TBytes;
  CtxB: TBytes;
  PlainB: TBytes;
  PadLen: Integer;
begin
  if Enc = '' then Exit('');
  if not FLX_IsEncrypted(Enc) then
    Exit(Enc); // si está en claro, devolvemos tal cual

  Parts := Enc.Split(['$']);
  if Length(Parts) <> 5 then
    raise Exception.Create('Formato cifrado inválido.');

  Salt      := B64DecodeBytes(Parts[1]);
  IV        := B64DecodeBytes(Parts[2]);
  CipherB   := B64DecodeBytes(Parts[3]);
  MacStored := B64DecodeBytes(Parts[4]);

  if (Length(Salt) <> 16) or (Length(IV) <> 16) or (Length(MacStored) <> 32) then
    raise Exception.Create('Formato cifrado inválido (tamaños).');

  MasterKey := GetOrCreateMasterKeyBytes;
  CtxB := StrToBytes(Context);

  KeyEnc := PBKDF2_HMAC_SHA256(ConcatBytes(MasterKey, CtxB), Salt, 60000, 64);
  KeyMac := Copy(KeyEnc, 32, 32);
  SetLength(KeyEnc, 32);

  DataToMac := ConcatBytes(Salt, ConcatBytes(IV, CipherB));
  if Context <> '' then
    DataToMac := ConcatBytes(DataToMac, CtxB);

  MacCalc := HMAC_SHA256(KeyMac, DataToMac);

  // comparación simple (vale para integridad; si quieres, luego metemos constant-time)
  if (Length(MacCalc) <> Length(MacStored)) or (B64EncodeBytes(MacCalc) <> B64EncodeBytes(MacStored)) then
    raise Exception.Create('Datos cifrados manipulados o clave/contexto incorrectos.');

  PlainB := Copy(CipherB, 0, Length(CipherB));
  AES := TDCP_rijndael.Create(nil);
  try
    AES.Init(KeyEnc[0], 256, @IV[0]);
    AES.DecryptCBC(PlainB[0], PlainB[0], Length(PlainB));
    AES.Burn;
  finally
    AES.Free;
  end;

  if Length(PlainB) = 0 then Exit('');
  PadLen := PlainB[High(PlainB)];
  if (PadLen < 1) or (PadLen > 16) or (PadLen > Length(PlainB)) then
    raise Exception.Create('Padding inválido.');

  SetLength(PlainB, Length(PlainB) - PadLen);
  Result := BytesToStr(PlainB);
end;

{ -------- Wrappers sin Context -------- }

function FLX_EncryptString(const Plain: string): string;
begin
  Result := FLX_EncryptStringCtx(Plain, '');
end;

function FLX_DecryptString(const Enc: string): string;
begin
  Result := FLX_DecryptStringCtx(Enc, '');
end;

procedure FLX_IniWriteEncryptedStringCtx(Ini: TCustomIniFile;
  const Section, Ident, Plain, Context: string);
begin
  if Ini = nil then Exit;
  Ini.WriteString(Section, Ident, FLX_EncryptStringCtx(Plain, Context));
end;

function FLX_IniReadDecryptedStringCtx(Ini: TCustomIniFile;
  const Section, Ident, Default, Context: string): string;
var
  Enc: string;
begin
  if Ini = nil then Exit(Default);
  Enc := Ini.ReadString(Section, Ident, '');
  if Enc = '' then Exit(Default);

  try
    Result := FLX_DecryptStringCtx(Enc, Context);
  except
    Result := Default;
  end;
end;

procedure FLX_IniWriteEncryptedString(Ini: TCustomIniFile;
  const Section, Ident, Plain: string);
var
  Ctx: string;
begin
  if Ini = nil then Exit;
  Ctx := Section + '|' + Ident;
  Ini.WriteString(Section, Ident, FLX_EncryptStringCtx(Plain, Ctx));
end;

function FLX_IniReadDecryptedString(Ini: TCustomIniFile;
  const Section, Ident, Default: string): string;
var
  Enc, Ctx: string;
begin
  if Ini = nil then Exit(Default);
  Enc := Ini.ReadString(Section, Ident, '');
  if Enc = '' then Exit(Default);

  Ctx := Section + '|' + Ident;
  try
    Result := FLX_DecryptStringCtx(Enc, Ctx);
  except
    Result := Default;
  end;
end;

procedure FLX_IniWritePassword(Ini: TCustomIniFile;
  const Section, Ident, Password: string);
begin
  FLX_IniWriteEncryptedString(Ini, Section, Ident, Password);
end;

function FLX_IniReadPassword(Ini: TCustomIniFile;
  const Section, Ident: string; const Default: string): string;
begin
  Result := FLX_IniReadDecryptedString(Ini, Section, Ident, Default);
end;

end.

