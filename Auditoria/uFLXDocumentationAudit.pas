unit uFLXDocumentationAudit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uFLXAuditTypes;

type
  TFLXDocumentationAudit = class
  private
    FReport: TFLXAuditReport;
    FRoots: TStringList;
    procedure AddRoot(const APath: string);
    procedure BuildRoots;
    function FindByTokens(const ATokens: array of string;
      const AExtensions: array of string; AMaxDepth: Integer): string;
    function ScanDirectory(const ARoot: string; const ATokens,
      AExtensions: array of string; ADepth, AMaxDepth: Integer): string;
    function NameMatches(const AName: string; const ATokens,
      AExtensions: array of string): Boolean;
    procedure CheckDocument(const ACode, ATitle: string;
      const ATokens, AExtensions: array of string; ARequired: Boolean;
      const AMissingText, AAction: string);
    procedure CheckTechnicalDirectory;
  public
    constructor Create(AReport: TFLXAuditReport);
    destructor Destroy; override;
    procedure Run;
  end;

implementation

constructor TFLXDocumentationAudit.Create(AReport: TFLXAuditReport);
begin
  inherited Create;
  if not Assigned(AReport) then
    raise Exception.Create('TFLXDocumentationAudit necesita un informe de auditoria');
  FReport := AReport;
  FRoots := TStringList.Create;
  FRoots.CaseSensitive := False;
  FRoots.Sorted := True;
  FRoots.Duplicates := dupIgnore;
  BuildRoots;
end;

destructor TFLXDocumentationAudit.Destroy;
begin
  FRoots.Free;
  inherited Destroy;
end;

procedure TFLXDocumentationAudit.AddRoot(const APath: string);
var
  P: string;
begin
  if Trim(APath) = '' then Exit;
  P := ExpandFileName(APath);
  if DirectoryExists(P) then
    FRoots.Add(ExcludeTrailingPathDelimiter(P));
end;

procedure TFLXDocumentationAudit.BuildRoots;
var
  ExeDir, ProjectDir: string;
begin
  ExeDir := ExcludeTrailingPathDelimiter(
    ExtractFilePath(ExpandFileName(ParamStr(0))));
  ProjectDir := ExtractFileDir(ExeDir);

  AddRoot(ExeDir);
  AddRoot(ProjectDir);
  AddRoot(GetCurrentDir);
  AddRoot('/usr/share/facturlinex2');
  AddRoot('/usr/share/facturlinex2/Documents');
  AddRoot('/usr/share/facturlinex2/Documentacion');
  AddRoot('/usr/share/doc/facturlinex2');
end;

function TFLXDocumentationAudit.NameMatches(const AName: string;
  const ATokens, AExtensions: array of string): Boolean;
var
  I: Integer;
  LName, Ext: string;
  TokenOK, ExtOK: Boolean;
begin
  LName := LowerCase(AName);
  TokenOK := Length(ATokens) = 0;
  for I := Low(ATokens) to High(ATokens) do
    if Pos(LowerCase(ATokens[I]), LName) > 0 then
    begin
      TokenOK := True;
      Break;
    end;

  ExtOK := Length(AExtensions) = 0;
  Ext := LowerCase(ExtractFileExt(AName));
  for I := Low(AExtensions) to High(AExtensions) do
    if (LowerCase(AExtensions[I]) = Ext) or
       (LowerCase(AExtensions[I]) = LowerCase(AName)) then
    begin
      ExtOK := True;
      Break;
    end;

  Result := TokenOK and ExtOK;
end;

function TFLXDocumentationAudit.ScanDirectory(const ARoot: string;
  const ATokens, AExtensions: array of string; ADepth,
  AMaxDepth: Integer): string;
var
  SR: TSearchRec;
  FullName: string;
begin
  Result := '';
  if (ADepth > AMaxDepth) or (not DirectoryExists(ARoot)) then Exit;

  if FindFirst(IncludeTrailingPathDelimiter(ARoot) + '*', faAnyFile, SR) = 0 then
  try
    repeat
      if (SR.Name = '.') or (SR.Name = '..') then Continue;
      FullName := IncludeTrailingPathDelimiter(ARoot) + SR.Name;
      if (SR.Attr and faDirectory) <> 0 then
      begin
        if (SR.Name[1] = '.') or SameText(SR.Name, 'lib') or
           SameText(SR.Name, 'backup') or SameText(SR.Name, 'backups') then
          Continue;
        Result := ScanDirectory(FullName, ATokens, AExtensions,
          ADepth + 1, AMaxDepth);
        if Result <> '' then Exit;
      end
      else if NameMatches(SR.Name, ATokens, AExtensions) then
        Exit(ExpandFileName(FullName));
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
  end;
end;

function TFLXDocumentationAudit.FindByTokens(const ATokens: array of string;
  const AExtensions: array of string; AMaxDepth: Integer): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to FRoots.Count - 1 do
  begin
    Result := ScanDirectory(FRoots[I], ATokens, AExtensions, 0, AMaxDepth);
    if Result <> '' then Exit;
  end;
end;

procedure TFLXDocumentationAudit.CheckDocument(const ACode, ATitle: string;
  const ATokens, AExtensions: array of string; ARequired: Boolean;
  const AMissingText, AAction: string);
var
  Found: string;
begin
  Found := FindByTokens(ATokens, AExtensions, 4);
  if Found <> '' then
    FReport.Add(ACode, 'DOCUMENTACION', alOK, ATitle + ' disponible',
      'Se ha localizado el documento dentro de la instalación o del árbol de desarrollo.',
      '', Found)
  else if ARequired then
    FReport.Add(ACode, 'DOCUMENTACION', alWarning, ATitle + ' pendiente',
      AMissingText, AAction, 'No localizado en las rutas documentales conocidas')
  else
    FReport.Add(ACode, 'DOCUMENTACION', alInfo, ATitle + ' no localizado',
      AMissingText, AAction, 'Documento opcional no localizado');
end;

procedure TFLXDocumentationAudit.CheckTechnicalDirectory;
var
  I: Integer;
  DirName: string;
begin
  for I := 0 to FRoots.Count - 1 do
  begin
    DirName := IncludeTrailingPathDelimiter(FRoots[I]) +
      'Documentacion' + DirectorySeparator + 'Auditoria';
    if DirectoryExists(DirName) then
    begin
      FReport.Add('DOC006', 'DOCUMENTACION', alOK,
        'Documentación técnica de auditoría disponible',
        'Existe la carpeta de documentación técnica y regresión.', '', DirName);
      Exit;
    end;
  end;
  FReport.Add('DOC006', 'DOCUMENTACION', alWarning,
    'Documentación técnica de auditoría pendiente',
    'No se ha localizado la carpeta Documentacion/Auditoria.',
    'Incluir el libro de regresión, unidades protegidas y evidencias de auditoría.',
    'Documentacion/Auditoria');
end;

procedure TFLXDocumentationAudit.Run;
begin
  CheckDocument('DOC001', 'Manual de usuario',
    ['manual_facturlinex', 'manual facturlinex'], ['.pdf', '.html', '.htm'], True,
    'No se ha localizado un manual general de uso.',
    'Instalar o publicar el manual de usuario vigente.');

  CheckDocument('DOC002', 'Manual VeriFactu',
    ['verifactu'], ['.pdf', '.html', '.htm', '.md'], True,
    'No se ha localizado documentación específica de VeriFactu.',
    'Preparar e instalar el manual VeriFactu de la versión 4.2.6.');

  CheckDocument('DOC003', 'Declaración responsable',
    ['declaracion_responsable', 'declaracion responsable'],
    ['.pdf', '.odt', '.docx', '.txt'], True,
    'La declaración responsable todavía no está incorporada.',
    'Generar e incorporar la declaración correspondiente a la edición J o X.');

  CheckDocument('DOC004', 'Licencia de software',
    ['license', 'licencia', 'copying'],
    ['.txt', '.md', '.html', '.htm', 'license', 'copying'], True,
    'No se ha localizado el texto de licencia junto a la instalación.',
    'Incluir la licencia libre y los avisos de terceros.');

  CheckDocument('DOC005', 'Historial de cambios',
    ['changelog', 'historial_versiones', 'historial de versiones', 'cambios'],
    ['.txt', '.md', '.html', '.htm', '.pdf'], True,
    'No se ha localizado un historial de cambios de la versión.',
    'Crear y mantener el registro de cambios de FacturLinEx 4.2.6.');

  CheckTechnicalDirectory;
end;

end.
