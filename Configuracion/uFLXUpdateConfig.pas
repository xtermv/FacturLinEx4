unit uFLXUpdateConfig;

{$mode objfpc}{$H+}

interface

procedure MostrarConfigActualizacionesFLX(const AIniFile, ACurrentExecutable: string);

implementation

uses
  Classes, SysUtils, Forms, Controls, Graphics, StdCtrls, ExtCtrls, Dialogs, IniFiles, Process, ComCtrls, ZDataset, BaseUnix, Global;

const
  FLX_UPD_SECTION = 'Actualizaciones';

function BoolToIni(const B: Boolean): string;
begin
  if B then Result := '1' else Result := '0';
end;

function DefaultUpdateLogFile(const AIniFile: string): string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(AIniFile)) + 'logs' +
            DirectorySeparator + 'actualizaciones.log';
end;

function RunCommandCapture(const Exe: string; const Params: array of string; out OutputText: string): Integer;
var
  P: TProcess;
  SL: TStringList;
  I: Integer;
begin
  Result := -1;
  OutputText := '';
  P := TProcess.Create(nil);
  SL := TStringList.Create;
  try
    P.Executable := Exe;
    for I := Low(Params) to High(Params) do
      P.Parameters.Add(Params[I]);
    P.Options := [poUsePipes, poWaitOnExit, poStderrToOutPut];
    try
      P.Execute;
      SL.LoadFromStream(P.Output);
      OutputText := SL.Text;
      Result := P.ExitStatus;
    except
      on E: Exception do
      begin
        OutputText := E.Message;
        Result := -1;
      end;
    end;
  finally
    SL.Free;
    P.Free;
  end;
end;


function FileSizeByName(const AFileName: string): Int64;
var
  FS: TFileStream;
begin
  Result := -1;
  if not FileExists(AFileName) then Exit;
  FS := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    Result := FS.Size;
  finally
    FS.Free;
  end;
end;

function CalcSHA256(const FileName: string; out Hash, Err: string): Boolean;
var
  OutText: string;
begin
  Result := False;
  Hash := '';
  Err := '';
  if not FileExists(FileName) then
  begin
    Err := 'No existe el ejecutable: ' + FileName;
    Exit;
  end;
  if RunCommandCapture('/usr/bin/sha256sum', [FileName], OutText) <> 0 then
  begin
    Err := 'No se pudo ejecutar sha256sum:' + LineEnding + OutText;
    Exit;
  end;
  Hash := Trim(Copy(OutText, 1, Pos(' ', OutText + ' ') - 1));
  Result := Hash <> '';
end;


function CleanSQLIdent(const S: string): string;
var
  T: string;
begin
  T := Trim(S);
  T := StringReplace(T, '`', '', [rfReplaceAll]);
  T := StringReplace(T, '"', '', [rfReplaceAll]);
  Result := LowerCase(Trim(T));
end;

function ExtractLastBacktickIdent(const S: string): string;
var
  I, P1, P2: Integer;
  Parts: TStringList;
  Part: string;
begin
  Result := '';
  Parts := TStringList.Create;
  try
    I := 1;
    while I <= Length(S) do
    begin
      P1 := Pos('`', Copy(S, I, MaxInt));
      if P1 = 0 then Break;
      P1 := I + P1 - 1;
      P2 := Pos('`', Copy(S, P1 + 1, MaxInt));
      if P2 = 0 then Break;
      P2 := P1 + P2;
      Part := Copy(S, P1 + 1, P2 - P1 - 1);
      if Trim(Part) <> '' then Parts.Add(Part);
      I := P2 + 1;
    end;
    if Parts.Count > 0 then
      Result := CleanSQLIdent(Parts[Parts.Count - 1]);
  finally
    Parts.Free;
  end;
end;

function SQLNormSpace(const S: string): string;
var
  I: Integer;
  LastSpace: Boolean;
begin
  Result := '';
  LastSpace := False;
  for I := 1 to Length(S) do
  begin
    if S[I] in [#9, #10, #13, ' '] then
    begin
      if not LastSpace then
      begin
        Result := Result + ' ';
        LastSpace := True;
      end;
    end
    else
    begin
      Result := Result + LowerCase(S[I]);
      LastSpace := False;
    end;
  end;
  Result := Trim(Result);
end;

function SQLStripTrailingComma(const S: string): string;
begin
  Result := Trim(S);
  if (Result <> '') and (Result[Length(Result)] = ',') then
    Delete(Result, Length(Result), 1);
  Result := Trim(Result);
end;

function SQLFirstTypeToken(const S: string): string;
var
  I, Paren: Integer;
  InQuote: Boolean;
  QuoteChar: Char;
begin
  Result := '';
  Paren := 0;
  InQuote := False;
  QuoteChar := #0;
  for I := 1 to Length(S) do
  begin
    if InQuote then
    begin
      Result := Result + S[I];
      if S[I] = QuoteChar then InQuote := False;
      Continue;
    end;
    if S[I] in ['''', '"'] then
    begin
      InQuote := True;
      QuoteChar := S[I];
      Result := Result + S[I];
      Continue;
    end;
    if S[I] = '(' then Inc(Paren);
    if S[I] = ')' then Dec(Paren);
    if (Paren <= 0) and (S[I] in [#9, #10, #13, ' ']) then Break;
    Result := Result + S[I];
  end;
  Result := SQLNormSpace(Result);
end;

function SQLContainsToken(const S, Token: string): Boolean;
begin
  Result := Pos(LowerCase(Token), SQLNormSpace(S)) > 0;
end;

function SQLExtractDefault(const Rest: string): string;
var
  S: string;
  P, I: Integer;
  InQuote: Boolean;
  QuoteChar: Char;
begin
  Result := '';
  S := SQLNormSpace(Rest);
  P := Pos(' default ', ' ' + S + ' ');
  if P = 0 then Exit;
  S := Trim(Copy(S, P + Length(' default '), MaxInt));
  InQuote := False;
  QuoteChar := #0;
  Result := '';
  for I := 1 to Length(S) do
  begin
    if InQuote then
    begin
      Result := Result + S[I];
      if S[I] = QuoteChar then InQuote := False;
      Continue;
    end;
    if S[I] in ['''', '"'] then
    begin
      InQuote := True;
      QuoteChar := S[I];
      Result := Result + S[I];
      Continue;
    end;
    if S[I] in [#9, #10, #13, ' '] then Break;
    Result := Result + S[I];
  end;
  Result := Trim(Result);
  if (Length(Result) >= 2) and (Result[1] in ['''', '"']) and (Result[Length(Result)] = Result[1]) then
    Result := Copy(Result, 2, Length(Result)-2);
end;

procedure MetaSet(AMeta: TStringList; const Key, Value: string);
begin
  AMeta.Values[Key] := Value;
end;

function MetaGet(AMeta: TStringList; const Key: string): string;
begin
  Result := AMeta.Values[Key];
end;

procedure MemoStep(AMemo: TMemo; const S: string);
begin
  if Assigned(AMemo) then
  begin
    AMemo.Lines.Add(FormatDateTime('hh:nn:ss', Now) + '  ' + S);
    AMemo.SelStart := Length(AMemo.Text);
    Application.ProcessMessages;
  end;
end;

function ElapsedSecondsText(const AStart: TDateTime): string;
begin
  Result := FormatFloat('0.0', (Now - AStart) * 86400.0) + ' s';
end;

function ExtractTypeBaseLen(const AType: string; out ABase: string; out ALen1, ALen2: Integer): Boolean;
var
  T, Inside, N1, N2: string;
  P1, P2, CommaPos: Integer;
begin
  Result := False;
  ABase := '';
  ALen1 := -1;
  ALen2 := -1;
  T := LowerCase(SQLNormSpace(AType));
  P1 := Pos('(', T);
  if P1 <= 0 then
  begin
    ABase := Trim(T);
    Result := ABase <> '';
    Exit;
  end;
  P2 := Pos(')', T);
  if P2 <= P1 then Exit;
  ABase := Trim(Copy(T, 1, P1 - 1));
  Inside := Trim(Copy(T, P1 + 1, P2 - P1 - 1));
  CommaPos := Pos(',', Inside);
  if CommaPos > 0 then
  begin
    N1 := Trim(Copy(Inside, 1, CommaPos - 1));
    N2 := Trim(Copy(Inside, CommaPos + 1, MaxInt));
    ALen1 := StrToIntDef(N1, -1);
    ALen2 := StrToIntDef(N2, -1);
  end
  else
    ALen1 := StrToIntDef(Inside, -1);
  Result := ABase <> '';
end;

function IsSafeWidenType(const ARefType, ALocalType: string): Boolean;
var
  RB, LB: string;
  R1, R2, L1, L2: Integer;
begin
  Result := False;
  if not ExtractTypeBaseLen(ARefType, RB, R1, R2) then Exit;
  if not ExtractTypeBaseLen(ALocalType, LB, L1, L2) then Exit;
  if RB <> LB then Exit;

  { Regla conservadora:
    - VARCHAR/CHAR/BINARY/VARBINARY: solo ampliar longitud.
    - DECIMAL/NUMERIC: solo ampliar precision manteniendo o ampliando decimales.
    - Nunca reducir, nunca cambiar familia de tipo. }
  if (RB = 'varchar') or (RB = 'char') or (RB = 'varbinary') or (RB = 'binary') then
    Result := (R1 > L1) and (L1 >= 0)
  else if (RB = 'decimal') or (RB = 'numeric') then
    Result := (R1 >= L1) and (R2 >= L2) and ((R1 > L1) or (R2 > L2)) and (L1 >= 0) and (L2 >= 0);
end;

function ExtractBacktickPairFromModify(const S: string; out ATable, AField: string): Boolean;
var
  P1, P2, P3, P4: Integer;
begin
  Result := False;
  ATable := '';
  AField := '';
  P1 := Pos('`', S);
  if P1 <= 0 then Exit;
  P2 := Pos('`', Copy(S, P1 + 1, MaxInt));
  if P2 <= 0 then Exit;
  P2 := P1 + P2;
  P3 := Pos('`', Copy(S, P2 + 1, MaxInt));
  if P3 <= 0 then Exit;
  P3 := P2 + P3;
  P4 := Pos('`', Copy(S, P3 + 1, MaxInt));
  if P4 <= 0 then Exit;
  P4 := P3 + P4;
  ATable := CleanSQLIdent(Copy(S, P1 + 1, P2 - P1 - 1));
  AField := CleanSQLIdent(Copy(S, P3 + 1, P4 - P3 - 1));
  Result := (ATable <> '') and (AField <> '');
end;

function ExtractNewTypeFromModify(const S: string): string;
var
  T: string;
  P, I: Integer;
begin
  Result := '';
  T := SQLNormSpace(S);
  P := Pos(' modify column ', LowerCase(T));
  if P <= 0 then Exit;
  T := Trim(Copy(T, P + Length(' modify column '), MaxInt));
  { Saltar nombre de campo entre `...` }
  if (Length(T) > 0) and (T[1] = '`') then
  begin
    Delete(T, 1, 1);
    P := Pos('`', T);
    if P <= 0 then Exit;
    Delete(T, 1, P);
    T := Trim(T);
  end
  else
  begin
    I := 1;
    while (I <= Length(T)) and not (T[I] in [' ', #9]) do Inc(I);
    T := Trim(Copy(T, I, MaxInt));
  end;

  I := 1;
  while (I <= Length(T)) and not (T[I] in [' ', #9, ';']) do Inc(I);
  Result := LowerCase(Trim(Copy(T, 1, I - 1)));
end;

function IsSafeWidenModifyStatement(const S: string): Boolean;
var
  TableName, FieldName, NewType, DBName, LocalType: string;
  Q: TZQuery;
begin
  Result := False;
  if Pos(' modify column ', LowerCase(SQLNormSpace(S))) <= 0 then Exit;
  if not ExtractBacktickPairFromModify(S, TableName, FieldName) then Exit;
  NewType := ExtractNewTypeFromModify(S);
  if NewType = '' then Exit;

  if (not Assigned(DataModule1)) or (not Assigned(DataModule1.dbConexion)) then Exit;
  if not DataModule1.dbConexion.Connected then
    DataModule1.dbConexion.Connect;
  DBName := DataModule1.dbConexion.Database;
  if Trim(DBName) = '' then DBName := DBDataBase;
  if Trim(DBName) = '' then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := DataModule1.dbConexion;
    Q.SQL.Text := 'select COLUMN_TYPE from information_schema.COLUMNS ' +
                  'where TABLE_SCHEMA = :db and TABLE_NAME = :t and COLUMN_NAME = :c';
    Q.ParamByName('db').AsString := DBName;
    Q.ParamByName('t').AsString := TableName;
    Q.ParamByName('c').AsString := FieldName;
    Q.Open;
    if Q.EOF then Exit;
    LocalType := LowerCase(SQLNormSpace(Q.FieldByName('COLUMN_TYPE').AsString));
    Result := IsSafeWidenType(NewType, LocalType);
  finally
    Q.Free;
  end;
end;


type
  TFLXUpdateConfigForm = class(TForm)
  private
    FIniFile: string;
    FCurrentExecutable: string;
    PnlHeader: TPanel;
    GBInfo: TGroupBox;
    Page: TPageControl;
    TabConfig, TabDB, TabHist, TabRec, TabReport: TTabSheet;
    GBConfig, GBGen, GBDBInfo, GBDBCheck, GBHist, GBRec, GBReport: TGroupBox;
    EdURL, EdExeLocal, EdCanal, EdVersionLocal, EdTmp, EdLog: TEdit;
    CkActivar, CkComprobar, CkPreparar, CkInstalar, CkSinSHA, CkReiniciar: TCheckBox;
    EdGenExe, EdGenVersion, EdGenCanal, EdGenFichero, EdGenDBVersion, EdGenSalida: TEdit;
    MemoInfo: TMemo;
    BtnGuardar, BtnCerrar, BtnGenerar, BtnUsarLocal: TButton;
    EdDBSql, EdDBVersion: TEdit;
    BtnDBExaminar, BtnDBComprobar, BtnDBGenerarPlan, BtnDBAplicarPlan, BtnDBVerVersion, BtnDBMarcarVersion: TButton;
    MemoDB, MemoHist, MemoRec, MemoReport: TMemo;
    BtnHistRefrescar, BtnRecRefrescar, BtnRecGenerar, BtnReportGenerar, BtnReportTodo: TButton;
    procedure BtnGuardarClick(Sender: TObject);
    procedure BtnCerrarClick(Sender: TObject);
    procedure BtnGenerarClick(Sender: TObject);
    procedure BtnUsarLocalClick(Sender: TObject);
    procedure BtnDBExaminarClick(Sender: TObject);
    procedure BtnDBComprobarClick(Sender: TObject);
    procedure BtnDBGenerarPlanClick(Sender: TObject);
    procedure BtnDBAplicarPlanClick(Sender: TObject);
    procedure BtnDBVerVersionClick(Sender: TObject);
    procedure BtnDBMarcarVersionClick(Sender: TObject);
    procedure BtnHistRefrescarClick(Sender: TObject);
    procedure BtnRecRefrescarClick(Sender: TObject);
    procedure BtnRecGenerarClick(Sender: TObject);
    procedure BtnReportGenerarClick(Sender: TObject);
    procedure BtnReportTodoClick(Sender: TObject);
    procedure GenerateMaintenanceReport;
    procedure FormResize(Sender: TObject);
    procedure LoadIni;
    procedure SaveIni;
    function AddLabelEdit(AParent: TWinControl; const ACaption, AText: string; var Y: Integer; AWidth: Integer = 500): TEdit;
    function AddCheck(AParent: TWinControl; const ACaption: string; AChecked: Boolean; var Y: Integer): TCheckBox;
    procedure RecolocarControles;
    procedure ParseSQLReference(const ASQLFile: string; ATables, AFields, AColMeta: TStringList);
    function ExtractCreateTableSQL(const ASQLFile, ATableName: string): string;
    function BuildSuggestedSQLPlan(const ASQLFile: string; APlan: TStringList): Boolean;
    procedure LoadDBStructure(ATables, AFields, AColMeta: TStringList);
    function MakeDBBackup(out ABackupFile, AErr: string): Boolean;
    function LoadSafePlanStatements(const APlanFile: string; AStatements, ARejected: TStringList): Boolean;
    function ExecutePlanStatements(AStatements: TStringList; out AErr: string): Integer;
    procedure RegisterDBUpdateHistory(const ASQLRef, APlanFile, ABackupFile: string; ASentencias: Integer; const AResultado, AError: string);
    procedure EnsureDBHistoryTable;
    procedure EnsureDBSchemaVersionTable;
    function GetDBSchemaVersion: string;
    procedure SetDBSchemaVersion(const AVersion, ARefSQL: string);
    procedure RefreshRecoveryInfo;
    function RecoveryScriptName: string;
  public
    constructor CreateConfig(AOwner: TComponent; const AIniFile, ACurrentExecutable: string); reintroduce;
  end;

function TFLXUpdateConfigForm.AddLabelEdit(AParent: TWinControl; const ACaption, AText: string; var Y: Integer; AWidth: Integer): TEdit;
var
  L: TLabel;
begin
  L := TLabel.Create(Self);
  L.Parent := AParent;
  L.Left := 18;
  L.Top := Y + 5;
  L.Caption := ACaption;
  L.ParentFont := False;
  L.Font.Name := 'Sans';
  L.Font.Height := -13;
  L.Font.Style := [];
  L.Font.Color := $00404040;

  Result := TEdit.Create(Self);
  Result.Parent := AParent;
  Result.Left := 190;
  Result.Top := Y;
  Result.Width := AWidth;
  Result.Height := 27;
  Result.Text := AText;
  Result.ParentFont := False;
  Result.Font.Name := 'Sans';
  Result.Font.Height := -13;
  Result.Font.Style := [];
  Inc(Y, 34);
end;

function TFLXUpdateConfigForm.AddCheck(AParent: TWinControl; const ACaption: string; AChecked: Boolean; var Y: Integer): TCheckBox;
begin
  Result := TCheckBox.Create(Self);
  Result.Parent := AParent;
  Result.Left := 190;
  Result.Top := Y;
  Result.Width := 360;
  Result.Height := 28;
  Result.Caption := ACaption;
  Result.Checked := AChecked;
  Result.ParentFont := False;
  Result.Font.Name := 'Sans';
  Result.Font.Height := -13;
  Result.Font.Style := [];
  Inc(Y, 30);
end;

constructor TFLXUpdateConfigForm.CreateConfig(AOwner: TComponent; const AIniFile, ACurrentExecutable: string);
var
  Y, YIzq, YDer: Integer;
  L, LTitle, LSubTitle: TLabel;

  procedure PrepararTab(ATab: TTabSheet);
  begin
    ATab.Color := $00F3F5F7;
    ATab.ParentFont := False;
    ATab.Font.Name := 'Sans';
    ATab.Font.Height := -13;
  end;

  procedure PrepararGrupo(AGrupo: TGroupBox; const ACaption: string);
  begin
    AGrupo.Caption := ACaption;
    AGrupo.Color := clWhite;
    AGrupo.ParentColor := False;
    AGrupo.ParentFont := False;
    AGrupo.Font.Name := 'Sans';
    AGrupo.Font.Height := -13;
    AGrupo.Font.Style := [];
  end;

  procedure PrepararBoton(ABoton: TButton; const ACaption: string; AClick: TNotifyEvent; APrincipal: Boolean = False);
  begin
    ABoton.Caption := ACaption;
    ABoton.Height := 34;
    ABoton.OnClick := AClick;
    ABoton.ParentFont := False;
    ABoton.Font.Name := 'Sans';
    ABoton.Font.Height := -13;
    if APrincipal then
      ABoton.Font.Style := [fsBold]
    else
      ABoton.Font.Style := [];
  end;

begin
  inherited CreateNew(AOwner, 1);
  FIniFile := AIniFile;
  FCurrentExecutable := ACurrentExecutable;

  Caption := 'Configuración de actualizaciones FacturLinEx';
  Position := poScreenCenter;
  BorderStyle := bsSizeable;
  BorderIcons := [biSystemMenu, biMinimize, biMaximize];
  WindowState := wsMaximized;
  Width := 1280;
  Height := 860;
  Constraints.MinWidth := 1000;
  Constraints.MinHeight := 760;
  Color := $00F3F5F7;
  ParentFont := False;
  Font.Name := 'Sans';
  Font.Height := -13;
  OnResize := @FormResize;

  PnlHeader := TPanel.Create(Self);
  PnlHeader.Parent := Self;
  PnlHeader.Align := alTop;
  PnlHeader.Height := 76;
  PnlHeader.BevelOuter := bvNone;
  PnlHeader.Color := clNavy;

  LTitle := TLabel.Create(Self);
  LTitle.Parent := PnlHeader;
  LTitle.Left := 20;
  LTitle.Top := 11;
  LTitle.Caption := 'ACTUALIZADOR Y MANTENIMIENTO FACTURLINEX';
  LTitle.ParentFont := False;
  LTitle.Font.Name := 'Sans';
  LTitle.Font.Height := -21;
  LTitle.Font.Style := [fsBold];
  LTitle.Font.Color := clWhite;

  LSubTitle := TLabel.Create(Self);
  LSubTitle.Parent := PnlHeader;
  LSubTitle.Left := 22;
  LSubTitle.Top := 43;
  LSubTitle.Caption := 'Configuración del actualizador, publicación de versiones, estructura BBDD, historial, recuperación e informe del puesto.';
  LSubTitle.ParentFont := False;
  LSubTitle.Font.Name := 'Sans';
  LSubTitle.Font.Height := -12;
  LSubTitle.Font.Color := clSilver;

  BtnCerrar := TButton.Create(Self);
  BtnCerrar.Parent := PnlHeader;
  BtnCerrar.Width := 110;
  BtnCerrar.Height := 34;
  BtnCerrar.Left := PnlHeader.Width - BtnCerrar.Width - 72;
  BtnCerrar.Top := 20;
  BtnCerrar.Anchors := [akTop, akRight];
  PrepararBoton(BtnCerrar, 'Cerrar', @BtnCerrarClick, False);

  Page := TPageControl.Create(Self);
  Page.Parent := Self;
  Page.Align := alClient;
  Page.TabPosition := tpTop;

  TabConfig := TTabSheet.Create(Self);
  TabConfig.PageControl := Page;
  TabConfig.Caption := 'Actualizador';
  PrepararTab(TabConfig);

  TabDB := TTabSheet.Create(Self);
  TabDB.PageControl := Page;
  TabDB.Caption := 'Base de datos';
  PrepararTab(TabDB);

  TabHist := TTabSheet.Create(Self);
  TabHist.PageControl := Page;
  TabHist.Caption := 'Historial';
  PrepararTab(TabHist);

  TabRec := TTabSheet.Create(Self);
  TabRec.PageControl := Page;
  TabRec.Caption := 'Recuperación';
  PrepararTab(TabRec);

  TabReport := TTabSheet.Create(Self);
  TabReport.PageControl := Page;
  TabReport.Caption := 'Informe';
  PrepararTab(TabReport);

  { CONFIGURACION }
  GBConfig := TGroupBox.Create(Self);
  GBConfig.Parent := TabConfig;
  PrepararGrupo(GBConfig, ' CONFIGURACIÓN LOCAL DEL ACTUALIZADOR ');

  Y := 28;
  EdURL := AddLabelEdit(GBConfig, 'Origen / URL', '', Y, 900);
  EdExeLocal := AddLabelEdit(GBConfig, 'Ejecutable local', '/usr/bin/FacturLinEx', Y, 900);
  EdCanal := AddLabelEdit(GBConfig, 'Canal', 'estable', Y, 200);
  EdVersionLocal := AddLabelEdit(GBConfig, 'Versión local', '', Y, 200);
  EdTmp := AddLabelEdit(GBConfig, 'Ruta temporal', '/tmp/facturlinex_update', Y, 900);
  EdLog := AddLabelEdit(GBConfig, 'Fichero de log', '', Y, 900);

  YIzq := Y + 2;
  CkActivar := AddCheck(GBConfig, 'Activar actualizador', False, YIzq);
  CkPreparar := AddCheck(GBConfig, 'Preparar descarga antes de instalar', True, YIzq);
  CkSinSHA := AddCheck(GBConfig, 'Permitir instalar sin SHA256 (NO recomendado)', False, YIzq);

  YDer := Y + 2;
  CkComprobar := AddCheck(GBConfig, 'Comprobar al inicio', True, YDer);
  CkInstalar := AddCheck(GBConfig, 'Permitir instalación real con pkexec', False, YDer);
  CkReiniciar := AddCheck(GBConfig, 'Reiniciar FacturLinEx tras actualizar', False, YDer);

  GBGen := TGroupBox.Create(Self);
  GBGen.Parent := TabConfig;
  PrepararGrupo(GBGen, ' PUBLICAR UNA NUEVA VERSIÓN / GENERAR VERSION.INI ');

  Y := 28;
  EdGenExe := AddLabelEdit(GBGen, 'Nuevo ejecutable', '', Y, 900);
  EdGenVersion := AddLabelEdit(GBGen, 'Nueva versión', '', Y, 200);
  EdGenCanal := AddLabelEdit(GBGen, 'Canal', 'estable', Y, 200);
  EdGenFichero := AddLabelEdit(GBGen, 'Fichero publicado', 'FacturLinEx', Y, 280);
  EdGenDBVersion := AddLabelEdit(GBGen, 'Versión estructura BBDD', '', Y, 200);
  EdGenSalida := AddLabelEdit(GBGen, 'Carpeta de salida', '', Y, 900);

  BtnUsarLocal := TButton.Create(Self);
  BtnUsarLocal.Parent := TabConfig;
  BtnUsarLocal.Width := 180;
  PrepararBoton(BtnUsarLocal, 'Usar ejecutable local', @BtnUsarLocalClick, False);

  BtnGenerar := TButton.Create(Self);
  BtnGenerar.Parent := TabConfig;
  BtnGenerar.Width := 180;
  PrepararBoton(BtnGenerar, 'Generar version.ini', @BtnGenerarClick, False);

  BtnGuardar := TButton.Create(Self);
  BtnGuardar.Parent := TabConfig;
  BtnGuardar.Width := 190;
  PrepararBoton(BtnGuardar, 'Guardar configuración', @BtnGuardarClick, True);

  GBInfo := TGroupBox.Create(Self);
  GBInfo.Parent := TabConfig;
  PrepararGrupo(GBInfo, ' INFORMACIÓN Y RESULTADO ');

  MemoInfo := TMemo.Create(Self);
  MemoInfo.Parent := GBInfo;
  MemoInfo.Align := alClient;
  MemoInfo.BorderSpacing.Around := 10;
  MemoInfo.ScrollBars := ssAutoBoth;
  MemoInfo.ReadOnly := True;
  MemoInfo.Color := clWhite;
  MemoInfo.ParentFont := False;
  MemoInfo.Font.Name := 'Monospace';
  MemoInfo.Font.Height := -12;
  MemoInfo.Lines.Text :=
    'Notas:' + LineEnding +
    '- El origen puede ser una carpeta local, una ruta montada o una URL http/https.' + LineEnding +
    '- Para producción es recomendable PermitirSinSHA256=0.' + LineEnding +
    '- El fichero remoto version.ini debe estar junto al ejecutable publicado.' + LineEnding +
    '- Si falta la carpeta logs, se creará automáticamente.' + LineEnding +
    '- Guardar configuración actualiza la sección [Actualizaciones] de FacturConf.ini.';

  { BASE DE DATOS }
  GBDBInfo := TGroupBox.Create(Self);
  GBDBInfo.Parent := TabDB;
  PrepararGrupo(GBDBInfo, ' COMPROBACIÓN DE ESTRUCTURA DE BASE DE DATOS ');

  L := TLabel.Create(Self);
  L.Parent := GBDBInfo;
  L.Left := 18;
  L.Top := 30;
  L.Caption := 'SQL de referencia';

  EdDBSql := TEdit.Create(Self);
  EdDBSql.Parent := GBDBInfo;
  EdDBSql.Left := 150;
  EdDBSql.Top := 25;
  EdDBSql.Height := 27;

  L := TLabel.Create(Self);
  L.Parent := GBDBInfo;
  L.Left := 18;
  L.Top := 70;
  L.Caption := 'Versión estructura';

  EdDBVersion := TEdit.Create(Self);
  EdDBVersion.Parent := GBDBInfo;
  EdDBVersion.Left := 150;
  EdDBVersion.Top := 65;
  EdDBVersion.Width := 190;
  EdDBVersion.Height := 27;
  EdDBVersion.Text := '';

  BtnDBExaminar := TButton.Create(Self);
  BtnDBExaminar.Parent := GBDBInfo;
  BtnDBExaminar.Width := 110;
  PrepararBoton(BtnDBExaminar, 'Examinar', @BtnDBExaminarClick, False);

  BtnDBVerVersion := TButton.Create(Self);
  BtnDBVerVersion.Parent := GBDBInfo;
  BtnDBVerVersion.Width := 155;
  PrepararBoton(BtnDBVerVersion, 'Ver versión BBDD', @BtnDBVerVersionClick, False);

  BtnDBMarcarVersion := TButton.Create(Self);
  BtnDBMarcarVersion.Parent := GBDBInfo;
  BtnDBMarcarVersion.Width := 185;
  PrepararBoton(BtnDBMarcarVersion, 'Marcar versión aplicada', @BtnDBMarcarVersionClick, False);

  BtnDBComprobar := TButton.Create(Self);
  BtnDBComprobar.Parent := GBDBInfo;
  BtnDBComprobar.Width := 185;
  PrepararBoton(BtnDBComprobar, 'Comprobar estructura', @BtnDBComprobarClick, True);

  BtnDBGenerarPlan := TButton.Create(Self);
  BtnDBGenerarPlan.Parent := GBDBInfo;
  BtnDBGenerarPlan.Width := 185;
  PrepararBoton(BtnDBGenerarPlan, 'Generar SQL sugerido', @BtnDBGenerarPlanClick, False);

  BtnDBAplicarPlan := TButton.Create(Self);
  BtnDBAplicarPlan.Parent := GBDBInfo;
  BtnDBAplicarPlan.Width := 185;
  PrepararBoton(BtnDBAplicarPlan, 'Aplicar SQL sugerido', @BtnDBAplicarPlanClick, False);

  L := TLabel.Create(Self);
  L.Parent := GBDBInfo;
  L.Left := 760;
  L.Top := 126;
  L.Caption := 'Se realiza una copia antes de ejecutar.';
  L.Font.Color := clGray;

  GBDBCheck := TGroupBox.Create(Self);
  GBDBCheck.Parent := TabDB;
  PrepararGrupo(GBDBCheck, ' RESULTADO DEL ANÁLISIS ');

  MemoDB := TMemo.Create(Self);
  MemoDB.Parent := GBDBCheck;
  MemoDB.Align := alClient;
  MemoDB.BorderSpacing.Around := 10;
  MemoDB.ScrollBars := ssAutoBoth;
  MemoDB.ReadOnly := True;
  MemoDB.Color := clWhite;
  MemoDB.ParentFont := False;
  MemoDB.Font.Name := 'Monospace';
  MemoDB.Font.Height := -12;
  MemoDB.Lines.Text :=
    'Fase BBDD v7: diagnóstico, plan SQL seguro, copia previa, historial y versión de estructura.' + LineEnding +
    'Seleccione un .sql de estructura generado con mysqldump --no-data y pulse Comprobar estructura.' + LineEnding +
    'Después puede generar un SQL sugerido para revisar. La aplicación del plan hace copia previa, pide confirmación y registra historial.';

  { HISTORIAL }
  GBHist := TGroupBox.Create(Self);
  GBHist.Parent := TabHist;
  PrepararGrupo(GBHist, ' HISTORIAL DE ACTUALIZACIONES DE ESTRUCTURA ');

  BtnHistRefrescar := TButton.Create(Self);
  BtnHistRefrescar.Parent := GBHist;
  BtnHistRefrescar.SetBounds(14, 28, 180, 34);
  PrepararBoton(BtnHistRefrescar, 'Refrescar historial', @BtnHistRefrescarClick, True);

  MemoHist := TMemo.Create(Self);
  MemoHist.Parent := GBHist;
  MemoHist.SetBounds(12, 76, 700, 400);
  MemoHist.Anchors := [akLeft, akTop, akRight, akBottom];
  MemoHist.ScrollBars := ssAutoBoth;
  MemoHist.ReadOnly := True;
  MemoHist.Color := clWhite;
  MemoHist.ParentFont := False;
  MemoHist.Font.Name := 'Monospace';
  MemoHist.Font.Height := -12;
  MemoHist.Lines.Text :=
    'Aquí se mostrará el historial de cambios de estructura registrados en flx_update_history.' + LineEnding +
    'Pulse Refrescar historial para consultar la base de datos activa.';

  { RECUPERACION }
  GBRec := TGroupBox.Create(Self);
  GBRec.Parent := TabRec;
  PrepararGrupo(GBRec, ' RECUPERACIÓN Y ROLLBACK REVISABLE ');

  BtnRecRefrescar := TButton.Create(Self);
  BtnRecRefrescar.Parent := GBRec;
  BtnRecRefrescar.SetBounds(14, 28, 200, 34);
  PrepararBoton(BtnRecRefrescar, 'Refrescar recuperación', @BtnRecRefrescarClick, True);

  BtnRecGenerar := TButton.Create(Self);
  BtnRecGenerar.Parent := GBRec;
  BtnRecGenerar.SetBounds(226, 28, 200, 34);
  PrepararBoton(BtnRecGenerar, 'Generar rollback .sh', @BtnRecGenerarClick, False);

  MemoRec := TMemo.Create(Self);
  MemoRec.Parent := GBRec;
  MemoRec.SetBounds(12, 76, 700, 400);
  MemoRec.Anchors := [akLeft, akTop, akRight, akBottom];
  MemoRec.ScrollBars := ssAutoBoth;
  MemoRec.ReadOnly := True;
  MemoRec.Color := clWhite;
  MemoRec.ParentFont := False;
  MemoRec.Font.Name := 'Monospace';
  MemoRec.Font.Height := -12;
  MemoRec.Lines.Text :=
    'Esta pestaña localiza copias .bak del ejecutable, ficheros temporales y genera un script rollback revisable.' + LineEnding +
    'No ejecuta el rollback automáticamente.';

  { INFORME }
  GBReport := TGroupBox.Create(Self);
  GBReport.Parent := TabReport;
  PrepararGrupo(GBReport, ' INFORME DE MANTENIMIENTO DEL PUESTO ');

  BtnReportGenerar := TButton.Create(Self);
  BtnReportGenerar.Parent := GBReport;
  BtnReportGenerar.SetBounds(14, 28, 180, 34);
  PrepararBoton(BtnReportGenerar, 'Generar informe', @BtnReportGenerarClick, True);

  BtnReportTodo := TButton.Create(Self);
  BtnReportTodo.Parent := GBReport;
  BtnReportTodo.SetBounds(206, 28, 180, 34);
  PrepararBoton(BtnReportTodo, 'Comprobar todo', @BtnReportTodoClick, False);

  MemoReport := TMemo.Create(Self);
  MemoReport.Parent := GBReport;
  MemoReport.SetBounds(12, 76, 700, 400);
  MemoReport.Anchors := [akLeft, akTop, akRight, akBottom];
  MemoReport.ScrollBars := ssAutoBoth;
  MemoReport.ReadOnly := True;
  MemoReport.Color := clWhite;
  MemoReport.ParentFont := False;
  MemoReport.Font.Name := 'Monospace';
  MemoReport.Font.Height := -12;
  MemoReport.Lines.Text :=
    'Genera un informe de diagnóstico del actualizador, ejecutable, BBDD, historial y recuperación.' + LineEnding +
    'Comprobar todo realiza una revisión completa de solo lectura y genera el informe.' + LineEnding +
    'No modifica nada. El informe se guarda también como fichero de texto en la carpeta logs.';

  LoadIni;
  RecolocarControles;
end;

procedure TFLXUpdateConfigForm.RecolocarControles;
var
  W, H, EditW, ColDer, InfoTop, InfoH: Integer;
begin
  if not Assigned(Page) then Exit;

  if Assigned(PnlHeader) and Assigned(BtnCerrar) then
    BtnCerrar.Left := PnlHeader.ClientWidth - BtnCerrar.Width - 72;

  W := TabConfig.ClientWidth;
  H := TabConfig.ClientHeight;
  if W <= 0 then Exit;

  GBConfig.SetBounds(14, 14, W - 28, 350);
  EditW := GBConfig.ClientWidth - 210;
  if EditW < 420 then EditW := 420;
  EdURL.Width := EditW;
  EdExeLocal.Width := EditW;
  EdTmp.Width := EditW;
  EdLog.Width := EditW;

  ColDer := GBConfig.ClientWidth div 2 + 35;
  CkActivar.Left := 190;
  CkPreparar.Left := 190;
  CkSinSHA.Left := 190;
  CkComprobar.Left := ColDer;
  CkInstalar.Left := ColDer;
  CkReiniciar.Left := ColDer;
  CkActivar.Width := ColDer - 205;
  CkPreparar.Width := ColDer - 205;
  CkSinSHA.Width := ColDer - 205;
  CkComprobar.Width := GBConfig.ClientWidth - ColDer - 20;
  CkInstalar.Width := GBConfig.ClientWidth - ColDer - 20;
  CkReiniciar.Width := GBConfig.ClientWidth - ColDer - 20;

  GBGen.SetBounds(14, 376, W - 28, 250);
  EditW := GBGen.ClientWidth - 210;
  if EditW < 420 then EditW := 420;
  EdGenExe.Width := EditW;
  EdGenSalida.Width := EditW;

  BtnUsarLocal.SetBounds(18, 640, 180, 34);
  BtnGenerar.SetBounds(210, 640, 180, 34);
  BtnGuardar.SetBounds(W - 208, 640, 190, 34);

  InfoTop := 686;
  InfoH := H - InfoTop - 14;
  if InfoH < 100 then InfoH := 100;
  GBInfo.SetBounds(14, InfoTop, W - 28, InfoH);

  if Assigned(GBDBInfo) then
  begin
    W := TabDB.ClientWidth;
    H := TabDB.ClientHeight;
    GBDBInfo.SetBounds(14, 14, W - 28, 184);
    EdDBSql.Width := GBDBInfo.ClientWidth - 300;
    if EdDBSql.Width < 360 then EdDBSql.Width := 360;
    BtnDBExaminar.SetBounds(EdDBSql.Left + EdDBSql.Width + 12, 22, 110, 34);
    BtnDBVerVersion.SetBounds(360, 62, 155, 34);
    BtnDBMarcarVersion.SetBounds(528, 62, 185, 34);
    BtnDBComprobar.SetBounds(150, 112, 185, 36);
    BtnDBGenerarPlan.SetBounds(350, 112, 185, 36);
    BtnDBAplicarPlan.SetBounds(550, 112, 185, 36);
    GBDBCheck.SetBounds(14, 210, W - 28, H - 224);
  end;

  if Assigned(GBHist) then
  begin
    W := TabHist.ClientWidth;
    H := TabHist.ClientHeight;
    GBHist.SetBounds(14, 14, W - 28, H - 28);
    MemoHist.SetBounds(12, 76, GBHist.ClientWidth - 24, GBHist.ClientHeight - 88);
  end;

  if Assigned(GBRec) then
  begin
    W := TabRec.ClientWidth;
    H := TabRec.ClientHeight;
    GBRec.SetBounds(14, 14, W - 28, H - 28);
    MemoRec.SetBounds(12, 76, GBRec.ClientWidth - 24, GBRec.ClientHeight - 88);
  end;

  if Assigned(GBReport) then
  begin
    W := TabReport.ClientWidth;
    H := TabReport.ClientHeight;
    GBReport.SetBounds(14, 14, W - 28, H - 28);
    MemoReport.SetBounds(12, 76, GBReport.ClientWidth - 24, GBReport.ClientHeight - 88);
  end;
end;

procedure TFLXUpdateConfigForm.FormResize(Sender: TObject);
begin
  RecolocarControles;
end;

procedure TFLXUpdateConfigForm.LoadIni;
var
  Ini: TIniFile;
begin
  if Trim(EdLog.Text) = '' then
    EdLog.Text := DefaultUpdateLogFile(FIniFile);

  if not FileExists(FIniFile) then Exit;

  Ini := TIniFile.Create(FIniFile);
  try
    EdURL.Text := Ini.ReadString(FLX_UPD_SECTION, 'URL', '');
    EdExeLocal.Text := Ini.ReadString(FLX_UPD_SECTION, 'EjecutableLocal', '/usr/bin/FacturLinEx');
    EdCanal.Text := Ini.ReadString(FLX_UPD_SECTION, 'Canal', 'estable');
    EdVersionLocal.Text := Ini.ReadString(FLX_UPD_SECTION, 'VersionLocal', '');
    EdTmp.Text := Ini.ReadString(FLX_UPD_SECTION, 'RutaTemporal', '/tmp/facturlinex_update');
    EdLog.Text := Ini.ReadString(FLX_UPD_SECTION, 'LogFile', DefaultUpdateLogFile(FIniFile));
    CkActivar.Checked := Ini.ReadBool(FLX_UPD_SECTION, 'Activar', False);
    CkComprobar.Checked := Ini.ReadBool(FLX_UPD_SECTION, 'ComprobarAlInicio', True);
    CkPreparar.Checked := Ini.ReadBool(FLX_UPD_SECTION, 'PrepararDescarga', True);
    CkInstalar.Checked := Ini.ReadBool(FLX_UPD_SECTION, 'PermitirInstalar', False);
    CkSinSHA.Checked := Ini.ReadBool(FLX_UPD_SECTION, 'PermitirSinSHA256', False);
    CkReiniciar.Checked := Ini.ReadBool(FLX_UPD_SECTION, 'ReiniciarTrasActualizar', False);
  finally
    Ini.Free;
  end;
end;

procedure TFLXUpdateConfigForm.SaveIni;
var
  Ini: TIniFile;
begin
  ForceDirectories(ExtractFileDir(FIniFile));
  Ini := TIniFile.Create(FIniFile);
  try
    Ini.WriteString(FLX_UPD_SECTION, 'Activar', BoolToIni(CkActivar.Checked));
    Ini.WriteString(FLX_UPD_SECTION, 'URL', Trim(EdURL.Text));
    Ini.WriteString(FLX_UPD_SECTION, 'EjecutableLocal', Trim(EdExeLocal.Text));
    Ini.WriteString(FLX_UPD_SECTION, 'Canal', Trim(EdCanal.Text));
    Ini.WriteString(FLX_UPD_SECTION, 'VersionLocal', Trim(EdVersionLocal.Text));
    Ini.WriteString(FLX_UPD_SECTION, 'ComprobarAlInicio', BoolToIni(CkComprobar.Checked));
    Ini.WriteString(FLX_UPD_SECTION, 'PrepararDescarga', BoolToIni(CkPreparar.Checked));
    Ini.WriteString(FLX_UPD_SECTION, 'PermitirInstalar', BoolToIni(CkInstalar.Checked));
    Ini.WriteString(FLX_UPD_SECTION, 'PermitirSinSHA256', BoolToIni(CkSinSHA.Checked));
    Ini.WriteString(FLX_UPD_SECTION, 'ReiniciarTrasActualizar', BoolToIni(CkReiniciar.Checked));
    Ini.WriteString(FLX_UPD_SECTION, 'MantenerCopias', '5');
    Ini.WriteString(FLX_UPD_SECTION, 'RutaTemporal', Trim(EdTmp.Text));
    Ini.WriteString(FLX_UPD_SECTION, 'LogFile', Trim(EdLog.Text));
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

procedure TFLXUpdateConfigForm.BtnGuardarClick(Sender: TObject);
begin
  SaveIni;
  MemoInfo.Lines.Add('');
  MemoInfo.Lines.Add('Configuración guardada: ' + FIniFile);
  ShowMessage('Configuración de actualizaciones guardada en:' + LineEnding + FIniFile);
end;

procedure TFLXUpdateConfigForm.BtnCerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TFLXUpdateConfigForm.BtnUsarLocalClick(Sender: TObject);
begin
  EdGenExe.Text := Trim(EdExeLocal.Text);
  if Trim(EdGenFichero.Text) = '' then
    EdGenFichero.Text := ExtractFileName(EdGenExe.Text);
  if Trim(EdGenSalida.Text) = '' then
    EdGenSalida.Text := Trim(EdURL.Text);
end;

procedure TFLXUpdateConfigForm.BtnGenerarClick(Sender: TObject);
var
  Hash, Err, OutDir, VersionFile, PubFile: string;
  SL: TStringList;
begin
  if Trim(EdGenExe.Text) = '' then
  begin
    ShowMessage('Indica el ejecutable nuevo.');
    Exit;
  end;
  if Trim(EdGenVersion.Text) = '' then
  begin
    ShowMessage('Indica la nueva versión.');
    Exit;
  end;
  OutDir := Trim(EdGenSalida.Text);
  if OutDir = '' then
    OutDir := ExtractFileDir(EdGenExe.Text);
  OutDir := IncludeTrailingPathDelimiter(OutDir);
  if not ForceDirectories(OutDir) then
  begin
    ShowMessage('No se pudo crear/acceder a la carpeta de salida:' + LineEnding + OutDir);
    Exit;
  end;

  if not CalcSHA256(Trim(EdGenExe.Text), Hash, Err) then
  begin
    ShowMessage(Err);
    Exit;
  end;

  PubFile := Trim(EdGenFichero.Text);
  if PubFile = '' then
    PubFile := ExtractFileName(EdGenExe.Text);

  VersionFile := OutDir + 'version.ini';
  SL := TStringList.Create;
  try
    SL.Add('[Version]');
    SL.Add('Numero=' + Trim(EdGenVersion.Text));
    SL.Add('Canal=' + Trim(EdGenCanal.Text));
    SL.Add('Fichero=' + PubFile);
    SL.Add('SHA256=' + LowerCase(Hash));
    SL.Add('Forzar=0');
    SL.Add('');
    SL.Add('[Database]');
    SL.Add('VersionDB=' + Trim(EdGenDBVersion.Text));
    SL.Add('SQLReferencia=');
    SL.Add('AplicarCambios=0');
    SL.SaveToFile(VersionFile);
  finally
    SL.Free;
  end;

  MemoInfo.Lines.Add('');
  MemoInfo.Lines.Add('version.ini generado: ' + VersionFile);
  MemoInfo.Lines.Add('SHA256=' + LowerCase(Hash));
  ShowMessage('Generado correctamente:' + LineEnding + VersionFile + LineEnding + LineEnding +
              'Recuerda copiar/publicar también el ejecutable con el nombre:' + LineEnding + PubFile);
end;


procedure TFLXUpdateConfigForm.BtnDBExaminarClick(Sender: TObject);
var
  OD: TOpenDialog;
begin
  OD := TOpenDialog.Create(Self);
  try
    OD.Title := 'Seleccionar SQL de estructura de referencia';
    OD.Filter := 'SQL (*.sql)|*.sql|Todos los ficheros|*.*';
    if OD.Execute then
      EdDBSql.Text := OD.FileName;
  finally
    OD.Free;
  end;
end;

procedure TFLXUpdateConfigForm.ParseSQLReference(const ASQLFile: string; ATables, AFields, AColMeta: TStringList);
var
  SL: TStringList;
  I, P: Integer;
  Line, ULine, TableName, FieldName, Rest, Key: string;
begin
  ATables.Clear;
  AFields.Clear;
  AColMeta.Clear;
  ATables.Sorted := True;
  ATables.Duplicates := dupIgnore;
  AFields.Sorted := True;
  AFields.Duplicates := dupIgnore;
  AColMeta.Sorted := False;
  AColMeta.Duplicates := dupIgnore;
  SL := TStringList.Create;
  try
    SL.LoadFromFile(ASQLFile);
    TableName := '';
    for I := 0 to SL.Count - 1 do
    begin
      Line := Trim(SL[I]);
      if Line = '' then Continue;
      ULine := UpperCase(Line);
      if (Pos('USE ', ULine) = 1) or (Pos('CREATE DATABASE', ULine) = 1) then
        Continue;
      if Pos('CREATE TABLE', ULine) = 1 then
      begin
        TableName := ExtractLastBacktickIdent(Line);
        if TableName <> '' then ATables.Add(TableName);
        Continue;
      end;
      if TableName <> '' then
      begin
        if Pos(')', Line) = 1 then
        begin
          TableName := '';
          Continue;
        end;
        if (Line <> '') and (Line[1] = ',') then
          Line := Trim(Copy(Line, 2, MaxInt));
        if (Line <> '') and (Line[1] = '`') then
        begin
          P := Pos('`', Copy(Line, 2, MaxInt));
          if P > 0 then
          begin
            FieldName := CleanSQLIdent(Copy(Line, 2, P - 1));
            Rest := SQLStripTrailingComma(Copy(Line, P + 2, MaxInt));
            Key := TableName + '.' + FieldName;
            if (TableName <> '') and (FieldName <> '') then
            begin
              AFields.Add(Key);
              MetaSet(AColMeta, Key + '|type', SQLFirstTypeToken(Rest));
              if SQLContainsToken(Rest, 'not null') then
                MetaSet(AColMeta, Key + '|null', 'NO')
              else if SQLContainsToken(Rest, ' null') then
                MetaSet(AColMeta, Key + '|null', 'YES')
              else
                MetaSet(AColMeta, Key + '|null', '');
              MetaSet(AColMeta, Key + '|default', SQLExtractDefault(Rest));
              MetaSet(AColMeta, Key + '|raw', Rest);
            end;
          end;
        end;
      end;
    end;
  finally
    SL.Free;
  end;
end;


function SplitTableFromKey(const K: string): string;
var
  P: Integer;
begin
  P := Pos('.', K);
  if P > 0 then Result := Copy(K, 1, P - 1) else Result := K;
end;

function SplitFieldFromKey(const K: string): string;
var
  P: Integer;
begin
  P := Pos('.', K);
  if P > 0 then Result := Copy(K, P + 1, MaxInt) else Result := '';
end;

function TFLXUpdateConfigForm.ExtractCreateTableSQL(const ASQLFile, ATableName: string): string;
var
  SL, OutSL: TStringList;
  I: Integer;
  Line, ULine, TN: string;
  Capturing: Boolean;
begin
  Result := '';
  SL := TStringList.Create;
  OutSL := TStringList.Create;
  try
    SL.LoadFromFile(ASQLFile);
    Capturing := False;
    for I := 0 to SL.Count - 1 do
    begin
      Line := SL[I];
      ULine := UpperCase(Trim(Line));
      if not Capturing then
      begin
        if Pos('CREATE TABLE', ULine) = 1 then
        begin
          TN := ExtractLastBacktickIdent(Line);
          if CleanSQLIdent(TN) = CleanSQLIdent(ATableName) then
          begin
            Capturing := True;
            OutSL.Add(Line);
            if Pos(';', Line) > 0 then Break;
          end;
        end;
      end
      else
      begin
        OutSL.Add(Line);
        if Pos(';', Line) > 0 then Break;
      end;
    end;
    if OutSL.Count > 0 then
    begin
      Result := TrimRight(OutSL.Text);
      if (Result <> '') and (Pos(';', Result) = 0) then
        Result := Result + ';';
    end;
  finally
    OutSL.Free;
    SL.Free;
  end;
end;

function TFLXUpdateConfigForm.BuildSuggestedSQLPlan(const ASQLFile: string; APlan: TStringList): Boolean;
var
  RefTables, RefFields, LocalTables, LocalFields, RefMeta, LocalMeta: TStringList;
  I, CountActions, CountReview: Integer;
  T0: TDateTime;
  K, T, F, Raw, CreateSQL, R, L: string;
begin
  Result := False;
  CountActions := 0;
  CountReview := 0;
  T0 := Now;
  Screen.Cursor := crHourGlass;
  RefTables := TStringList.Create;
  RefFields := TStringList.Create;
  LocalTables := TStringList.Create;
  LocalFields := TStringList.Create;
  RefMeta := TStringList.Create;
  LocalMeta := TStringList.Create;
  try
    ParseSQLReference(ASQLFile, RefTables, RefFields, RefMeta);
    LoadDBStructure(LocalTables, LocalFields, LocalMeta);

    APlan.Clear;
    APlan.Add('-- FacturLinEx - SQL sugerido por comprobador de estructura');
    APlan.Add('-- Fichero generado para REVISION MANUAL. No se ejecuta automaticamente.');
    APlan.Add('-- Revise siempre antes de aplicar en produccion y haga copia de seguridad.');
    APlan.Add('-- Referencia: ' + ASQLFile);
    APlan.Add('');

    APlan.Add('-- ============================================================');
    APlan.Add('-- TABLAS FALTANTES');
    APlan.Add('-- ============================================================');
    for I := 0 to RefTables.Count - 1 do
      if LocalTables.IndexOf(RefTables[I]) < 0 then
      begin
        CreateSQL := ExtractCreateTableSQL(ASQLFile, RefTables[I]);
        if CreateSQL <> '' then
        begin
          APlan.Add('');
          APlan.Add('-- Falta tabla: ' + RefTables[I]);
          APlan.Add(CreateSQL);
          Inc(CountActions);
        end
        else
        begin
          APlan.Add('-- Falta tabla, pero no se pudo extraer CREATE TABLE: ' + RefTables[I]);
          Inc(CountReview);
        end;
      end;

    APlan.Add('');
    APlan.Add('-- ============================================================');
    APlan.Add('-- CAMPOS FALTANTES');
    APlan.Add('-- ============================================================');
    for I := 0 to RefFields.Count - 1 do
    begin
      if (I mod 500 = 0) then Application.ProcessMessages;
      K := RefFields[I];
      if LocalFields.IndexOf(K) < 0 then
      begin
        T := SplitTableFromKey(K);
        F := SplitFieldFromKey(K);
        Raw := MetaGet(RefMeta, K + '|raw');
        if (T <> '') and (F <> '') and (Raw <> '') then
        begin
          APlan.Add('');
          APlan.Add('-- Falta campo: ' + K);
          APlan.Add('ALTER TABLE `' + T + '` ADD COLUMN `' + F + '` ' + Raw + ';');
          Inc(CountActions);
        end
        else
        begin
          APlan.Add('-- Falta campo, revisar manualmente: ' + K);
          Inc(CountReview);
        end;
      end;
    end;

    APlan.Add('');
    APlan.Add('-- ============================================================');
    APlan.Add('-- DIFERENCIAS DE TIPO / NULL / DEFAULT');
    APlan.Add('-- Se generan MODIFY solo para ampliaciones seguras de longitud/precision.');
    APlan.Add('-- Reducciones, cambios de familia, NULL o DEFAULT quedan como revision manual.');
    APlan.Add('-- ============================================================');
    for I := 0 to RefFields.Count - 1 do
    begin
      if (I mod 500 = 0) then Application.ProcessMessages;
      K := RefFields[I];
      if LocalFields.IndexOf(K) < 0 then Continue;
      R := MetaGet(RefMeta, K + '|type');
      L := MetaGet(LocalMeta, K + '|type');
      if (R <> '') and (L <> '') and (R <> L) then
      begin
        T := SplitTableFromKey(K);
        F := SplitFieldFromKey(K);
        Raw := MetaGet(RefMeta, K + '|raw');
        { Generar ALTER MODIFY solo si es una mejora no destructiva:
          mismo tipo base y longitud/precision superior en referencia.
          Además, para evitar efectos colaterales, solo se automatiza si NULL,
          DEFAULT y EXTRA coinciden entre referencia y local. }
        if IsSafeWidenType(R, L) and (Raw <> '') and
           (MetaGet(RefMeta, K + '|null') = MetaGet(LocalMeta, K + '|null')) and
           (MetaGet(RefMeta, K + '|default') = MetaGet(LocalMeta, K + '|default')) and
           (MetaGet(RefMeta, K + '|extra') = MetaGet(LocalMeta, K + '|extra')) then
        begin
          APlan.Add('');
          APlan.Add('-- Ampliacion segura de campo: ' + K + '  Local=' + L + '  Nuevo=' + R);
          APlan.Add('ALTER TABLE `' + T + '` MODIFY COLUMN `' + F + '` ' + Raw + ';');
          Inc(CountActions);
        end
        else
        begin
          APlan.Add('-- Revisar tipo: ' + K + '  SQL=' + R + '  Local=' + L);
          Inc(CountReview);
        end;
      end;
      R := MetaGet(RefMeta, K + '|null');
      L := MetaGet(LocalMeta, K + '|null');
      if (R <> '') and (L <> '') and (R <> L) then
      begin
        APlan.Add('-- Revisar NULL: ' + K + '  SQL=' + R + '  Local=' + L);
        Inc(CountReview);
      end;
      R := MetaGet(RefMeta, K + '|default');
      L := MetaGet(LocalMeta, K + '|default');
      if R <> L then
      begin
        APlan.Add('-- Revisar DEFAULT: ' + K + '  SQL=' + R + '  Local=' + L);
        Inc(CountReview);
      end;
    end;

    APlan.Add('');
    APlan.Add('-- Resumen:');
    APlan.Add('-- Acciones SQL generadas: ' + IntToStr(CountActions));
    APlan.Add('-- Revisiones manuales: ' + IntToStr(CountReview));
    Result := CountActions > 0;
  finally
    RefTables.Free;
    RefFields.Free;
    LocalTables.Free;
    LocalFields.Free;
    RefMeta.Free;
    LocalMeta.Free;
  end;
end;

procedure TFLXUpdateConfigForm.LoadDBStructure(ATables, AFields, AColMeta: TStringList);
var
  Q: TZQuery;
  DBName, Key, DefValue: string;
begin
  ATables.Clear;
  AFields.Clear;
  AColMeta.Clear;
  ATables.Sorted := True;
  ATables.Duplicates := dupIgnore;
  AFields.Sorted := True;
  AFields.Duplicates := dupIgnore;
  AColMeta.Sorted := False;
  AColMeta.Duplicates := dupIgnore;

  if (not Assigned(DataModule1)) or (not Assigned(DataModule1.dbConexion)) then
    raise Exception.Create('No está disponible la conexión de FacturLinEx.');
  if not DataModule1.dbConexion.Connected then
    DataModule1.dbConexion.Connect;

  DBName := DataModule1.dbConexion.Database;
  if Trim(DBName) = '' then
    DBName := DBDataBase;
  if Trim(DBName) = '' then
    raise Exception.Create('No se pudo determinar el nombre de la base de datos activa.');

  Q := TZQuery.Create(nil);
  try
    Q.Connection := DataModule1.dbConexion;
    Q.SQL.Text := 'select TABLE_NAME from information_schema.TABLES where TABLE_SCHEMA = :db';
    Q.ParamByName('db').AsString := DBName;
    Q.Open;
    while not Q.EOF do
    begin
      ATables.Add(CleanSQLIdent(Q.FieldByName('TABLE_NAME').AsString));
      Q.Next;
    end;
    Q.Close;

    Q.SQL.Text := 'select TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT, EXTRA ' +
                  'from information_schema.COLUMNS where TABLE_SCHEMA = :db';
    Q.ParamByName('db').AsString := DBName;
    Q.Open;
    while not Q.EOF do
    begin
      Key := CleanSQLIdent(Q.FieldByName('TABLE_NAME').AsString) + '.' +
             CleanSQLIdent(Q.FieldByName('COLUMN_NAME').AsString);
      AFields.Add(Key);
      MetaSet(AColMeta, Key + '|type', SQLNormSpace(Q.FieldByName('COLUMN_TYPE').AsString));
      MetaSet(AColMeta, Key + '|null', UpperCase(Trim(Q.FieldByName('IS_NULLABLE').AsString)));
      if Q.FieldByName('COLUMN_DEFAULT').IsNull then
        DefValue := ''
      else
        DefValue := SQLNormSpace(Q.FieldByName('COLUMN_DEFAULT').AsString);
      MetaSet(AColMeta, Key + '|default', DefValue);
      MetaSet(AColMeta, Key + '|extra', SQLNormSpace(Q.FieldByName('EXTRA').AsString));
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;



function TFLXUpdateConfigForm.MakeDBBackup(out ABackupFile, AErr: string): Boolean;
var
  BackupDir, CfgFile, OutText, DBName: string;
  Cfg: TStringList;
begin
  Result := False;
  ABackupFile := '';
  AErr := '';

  if (not Assigned(DataModule1)) or (not Assigned(DataModule1.dbConexion)) then
  begin
    AErr := 'No está disponible la conexión de FacturLinEx.';
    Exit;
  end;
  if not DataModule1.dbConexion.Connected then
    DataModule1.dbConexion.Connect;

  DBName := DataModule1.dbConexion.Database;
  if Trim(DBName) = '' then DBName := DBDataBase;
  if Trim(DBName) = '' then
  begin
    AErr := 'No se pudo determinar la base de datos activa.';
    Exit;
  end;

  BackupDir := IncludeTrailingPathDelimiter(ExtractFileDir(FIniFile)) + 'backups_bbdd';
  if not DirectoryExists(BackupDir) then
    if not ForceDirectories(BackupDir) then
    begin
      AErr := 'No se pudo crear la carpeta de copias:' + LineEnding + BackupDir;
      Exit;
    end;

  ABackupFile := IncludeTrailingPathDelimiter(BackupDir) +
                 'backup_' + DBName + '_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.sql';
  CfgFile := IncludeTrailingPathDelimiter(BackupDir) + '.mysqldump_facturlinex.cnf';

  Cfg := TStringList.Create;
  try
    Cfg.Add('[client]');
    if Trim(DBUsuario) <> '' then Cfg.Add('user=' + DBUsuario);
    if Trim(DBPasswd) <> '' then Cfg.Add('password=' + DBPasswd);
    if Trim(DBHost) <> '' then Cfg.Add('host=' + DBHost);
    if Trim(DBPuerto) <> '' then Cfg.Add('port=' + DBPuerto);
    Cfg.SaveToFile(CfgFile);
    fpchmod(CfgFile, &600);
  finally
    Cfg.Free;
  end;

  MemoStep(MemoDB, 'Creando copia de seguridad con mysqldump...');
  if RunCommandCapture('/usr/bin/mysqldump',
       ['--defaults-extra-file=' + CfgFile,
        '--default-character-set=utf8mb4',
        '--routines', '--triggers', '--events',
        '--result-file=' + ABackupFile,
        DBName], OutText) <> 0 then
  begin
    DeleteFile(CfgFile);
    AErr := 'mysqldump falló. No se aplicará ningún cambio.' + LineEnding + OutText;
    Exit;
  end;
  DeleteFile(CfgFile);

  if not FileExists(ABackupFile) then
  begin
    AErr := 'mysqldump terminó, pero no se encontró el fichero de copia:' + LineEnding + ABackupFile;
    Exit;
  end;

  Result := True;
end;

function StatementIsSafeForAutoApply(const S: string): Boolean;
var
  T: string;
begin
  T := SQLNormSpace(S);
  Result := False;
  if Copy(T, 1, Length('create table')) = 'create table' then
    Result := True
  else if (Copy(T, 1, Length('alter table')) = 'alter table') and
          (Pos(' add column ', T) > 0) then
    Result := True
  else if (Copy(T, 1, Length('alter table')) = 'alter table') and
          (Pos(' modify column ', T) > 0) and
          IsSafeWidenModifyStatement(S) then
    Result := True;
end;

function TFLXUpdateConfigForm.LoadSafePlanStatements(const APlanFile: string; AStatements, ARejected: TStringList): Boolean;
var
  SL: TStringList;
  I, J: Integer;
  Line, Stmt: string;
  InBlockComment: Boolean;
begin
  Result := False;
  AStatements.Clear;
  ARejected.Clear;
  SL := TStringList.Create;
  try
    SL.LoadFromFile(APlanFile);
    Stmt := '';
    InBlockComment := False;
    for I := 0 to SL.Count - 1 do
    begin
      Line := Trim(SL[I]);
      if Line = '' then Continue;
      if InBlockComment then
      begin
        if Pos('*/', Line) > 0 then InBlockComment := False;
        Continue;
      end;
      if Copy(Line, 1, 2) = '/*' then
      begin
        if Pos('*/', Line) = 0 then InBlockComment := True;
        Continue;
      end;
      if Copy(Line, 1, 2) = '--' then Continue;
      if Copy(Line, 1, 1) = '#' then Continue;

      Stmt := Stmt + Line + LineEnding;
      while Pos(';', Stmt) > 0 do
      begin
        J := Pos(';', Stmt);
        Line := Trim(Copy(Stmt, 1, J));
        Delete(Stmt, 1, J);
        if Line <> '' then
        begin
          if StatementIsSafeForAutoApply(Line) then
            AStatements.Add(Line)
          else
            ARejected.Add(Line);
        end;
      end;
    end;
    if Trim(Stmt) <> '' then
    begin
      if StatementIsSafeForAutoApply(Stmt) then
        AStatements.Add(Trim(Stmt))
      else
        ARejected.Add(Trim(Stmt));
    end;
    Result := AStatements.Count > 0;
  finally
    SL.Free;
  end;
end;

function TFLXUpdateConfigForm.ExecutePlanStatements(AStatements: TStringList; out AErr: string): Integer;
var
  Q: TZQuery;
  I: Integer;
begin
  Result := 0;
  AErr := '';
  if (not Assigned(DataModule1)) or (not Assigned(DataModule1.dbConexion)) then
  begin
    AErr := 'No está disponible la conexión de FacturLinEx.';
    Exit;
  end;
  if not DataModule1.dbConexion.Connected then
    DataModule1.dbConexion.Connect;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := DataModule1.dbConexion;
    for I := 0 to AStatements.Count - 1 do
    begin
      MemoStep(MemoDB, 'Ejecutando sentencia ' + IntToStr(I + 1) + ' de ' + IntToStr(AStatements.Count) + '...');
      Q.Close;
      Q.SQL.Text := AStatements[I];
      try
        Q.ExecSQL;
        Inc(Result);
      except
        on E: Exception do
        begin
          AErr := 'Error ejecutando sentencia ' + IntToStr(I + 1) + ':' + LineEnding +
                  E.Message + LineEnding + LineEnding + AStatements[I];
          Exit;
        end;
      end;
    end;
  finally
    Q.Free;
  end;
end;




procedure TFLXUpdateConfigForm.EnsureDBSchemaVersionTable;
var
  Q: TZQuery;
begin
  if (not Assigned(DataModule1)) or (not Assigned(DataModule1.dbConexion)) then
    raise Exception.Create('No está disponible la conexión de FacturLinEx.');
  if not DataModule1.dbConexion.Connected then
    DataModule1.dbConexion.Connect;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := DataModule1.dbConexion;
    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS `flx_schema_version` (' +
      ' `id` INT NOT NULL,' +
      ' `version_db` VARCHAR(50) NOT NULL,' +
      ' `fecha` DATETIME NOT NULL,' +
      ' `sql_referencia` VARCHAR(255) NULL,' +
      ' `usuario` VARCHAR(100) NULL,' +
      ' `equipo` VARCHAR(100) NULL,' +
      ' PRIMARY KEY (`id`)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8mb4';
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

function TFLXUpdateConfigForm.GetDBSchemaVersion: string;
var
  Q: TZQuery;
begin
  Result := '';
  EnsureDBSchemaVersionTable;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := DataModule1.dbConexion;
    Q.SQL.Text := 'SELECT version_db FROM flx_schema_version WHERE id=1';
    Q.Open;
    if not Q.EOF then
      Result := Trim(Q.FieldByName('version_db').AsString);
  finally
    Q.Free;
  end;
end;

procedure TFLXUpdateConfigForm.SetDBSchemaVersion(const AVersion, ARefSQL: string);
var
  Q: TZQuery;
  Equipo: string;
begin
  if Trim(AVersion) = '' then
    raise Exception.Create('Indique una versión de estructura BBDD.');

  EnsureDBSchemaVersionTable;
  Equipo := Trim(GetEnvironmentVariable('HOSTNAME'));
  if Equipo = '' then Equipo := Trim(GetEnvironmentVariable('COMPUTERNAME'));

  Q := TZQuery.Create(nil);
  try
    Q.Connection := DataModule1.dbConexion;
    Q.SQL.Text :=
      'REPLACE INTO flx_schema_version ' +
      '(id, version_db, fecha, sql_referencia, usuario, equipo) ' +
      'VALUES (1, :version_db, NOW(), :sql_ref, :usuario, :equipo)';
    Q.ParamByName('version_db').AsString := Trim(AVersion);
    Q.ParamByName('sql_ref').AsString := ARefSQL;
    Q.ParamByName('usuario').AsString := GetEnvironmentVariable('USER');
    Q.ParamByName('equipo').AsString := Equipo;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TFLXUpdateConfigForm.BtnDBVerVersionClick(Sender: TObject);
var
  V: string;
begin
  try
    V := GetDBSchemaVersion;
    if V = '' then
      MemoDB.Lines.Add('Versión BBDD: no marcada todavía.')
    else
      MemoDB.Lines.Add('Versión BBDD aplicada: ' + V);
  except
    on E: Exception do
      ShowMessage('No se pudo consultar la versión BBDD:' + LineEnding + E.Message);
  end;
end;

procedure TFLXUpdateConfigForm.BtnDBMarcarVersionClick(Sender: TObject);
begin
  if Trim(EdDBVersion.Text) = '' then
  begin
    ShowMessage('Indique la versión de estructura que desea marcar como aplicada.');
    Exit;
  end;
  if MessageDlg('Marcar versión BBDD aplicada',
                'Se marcará como aplicada la versión de estructura:' + LineEnding +
                Trim(EdDBVersion.Text) + LineEnding + LineEnding +
                'Esto NO modifica tablas ni campos. Solo guarda el estado de versión.' + LineEnding +
                '¿Desea continuar?', mtConfirmation, [mbYes, mbNo], 0) <> 6 then
    Exit;
  try
    SetDBSchemaVersion(Trim(EdDBVersion.Text), Trim(EdDBSql.Text));
    MemoDB.Lines.Add('Versión BBDD marcada como aplicada: ' + Trim(EdDBVersion.Text));
  except
    on E: Exception do
      ShowMessage('No se pudo marcar la versión BBDD:' + LineEnding + E.Message);
  end;
end;

procedure TFLXUpdateConfigForm.EnsureDBHistoryTable;
var
  Q: TZQuery;
begin
  if (not Assigned(DataModule1)) or (not Assigned(DataModule1.dbConexion)) then
    raise Exception.Create('No está disponible la conexión de FacturLinEx.');
  if not DataModule1.dbConexion.Connected then
    DataModule1.dbConexion.Connect;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := DataModule1.dbConexion;
    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS `flx_update_history` (' +
      ' `id` INT NOT NULL AUTO_INCREMENT,' +
      ' `fecha` DATETIME NOT NULL,' +
      ' `tipo` VARCHAR(30) NOT NULL,' +
      ' `sql_referencia` VARCHAR(255) NULL,' +
      ' `plan_sql` VARCHAR(255) NULL,' +
      ' `backup_sql` VARCHAR(255) NULL,' +
      ' `sentencias` INT NOT NULL DEFAULT 0,' +
      ' `resultado` VARCHAR(30) NOT NULL,' +
      ' `error_texto` TEXT NULL,' +
      ' `usuario` VARCHAR(100) NULL,' +
      ' `equipo` VARCHAR(100) NULL,' +
      ' PRIMARY KEY (`id`)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8mb4';
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TFLXUpdateConfigForm.BtnHistRefrescarClick(Sender: TObject);
var
  Q: TZQuery;
  I: Integer;
  UltimaOK: string;
begin
  MemoHist.Clear;
  Screen.Cursor := crHourGlass;
  try
    try
      EnsureDBHistoryTable;

      Q := TZQuery.Create(nil);
      try
        Q.Connection := DataModule1.dbConexion;
        Q.SQL.Text :=
          'SELECT fecha,tipo,sql_referencia,plan_sql,backup_sql,sentencias,resultado,usuario,equipo,error_texto ' +
          'FROM flx_update_history ORDER BY id DESC LIMIT 50';
        Q.Open;

        MemoHist.Lines.Add('Historial de estructura de la base de datos activa');
        MemoHist.Lines.Add('');
        if Q.IsEmpty then
        begin
          MemoHist.Lines.Add('No hay registros todavía.');
          MemoHist.Lines.Add('Cuando se aplique un plan SQL seguro, quedará registrado aquí.');
          Exit;
        end;

        UltimaOK := '';
        I := 0;
        while not Q.EOF do
        begin
          Inc(I);
          if (UltimaOK = '') and (UpperCase(Q.FieldByName('resultado').AsString) = 'OK') then
            UltimaOK := Q.FieldByName('fecha').AsString + ' - ' + ExtractFileName(Q.FieldByName('sql_referencia').AsString);

          MemoHist.Lines.Add('----------------------------------------');
          MemoHist.Lines.Add('#' + IntToStr(I));
          MemoHist.Lines.Add('Fecha: ' + Q.FieldByName('fecha').AsString);
          MemoHist.Lines.Add('Tipo: ' + Q.FieldByName('tipo').AsString);
          MemoHist.Lines.Add('Resultado: ' + Q.FieldByName('resultado').AsString);
          MemoHist.Lines.Add('Sentencias: ' + Q.FieldByName('sentencias').AsString);
          MemoHist.Lines.Add('Usuario/equipo: ' + Q.FieldByName('usuario').AsString + ' / ' + Q.FieldByName('equipo').AsString);
          MemoHist.Lines.Add('SQL referencia: ' + Q.FieldByName('sql_referencia').AsString);
          MemoHist.Lines.Add('Plan: ' + Q.FieldByName('plan_sql').AsString);
          MemoHist.Lines.Add('Copia: ' + Q.FieldByName('backup_sql').AsString);
          if Trim(Q.FieldByName('error_texto').AsString) <> '' then
            MemoHist.Lines.Add('Error: ' + Q.FieldByName('error_texto').AsString);
          Q.Next;
        end;

        MemoHist.Lines.Insert(2, 'Última estructura aplicada correctamente: ' + UltimaOK);
        MemoHist.Lines.Insert(3, '');
      finally
        Q.Free;
      end;
    except
      on E: Exception do
      begin
        MemoHist.Lines.Add('No se pudo leer el historial:');
        MemoHist.Lines.Add(E.Message);
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFLXUpdateConfigForm.RegisterDBUpdateHistory(const ASQLRef, APlanFile, ABackupFile: string; ASentencias: Integer; const AResultado, AError: string);
var
  Q: TZQuery;
  Equipo: string;
begin
  try
    if (not Assigned(DataModule1)) or (not Assigned(DataModule1.dbConexion)) then Exit;
    if not DataModule1.dbConexion.Connected then
      DataModule1.dbConexion.Connect;

    Equipo := Trim(GetEnvironmentVariable('HOSTNAME'));
    if Equipo = '' then Equipo := Trim(GetEnvironmentVariable('COMPUTERNAME'));

    Q := TZQuery.Create(nil);
    try
      Q.Connection := DataModule1.dbConexion;
      Q.SQL.Text :=
        'CREATE TABLE IF NOT EXISTS `flx_update_history` (' +
        ' `id` INT NOT NULL AUTO_INCREMENT,' +
        ' `fecha` DATETIME NOT NULL,' +
        ' `tipo` VARCHAR(30) NOT NULL,' +
        ' `sql_referencia` VARCHAR(255) NULL,' +
        ' `plan_sql` VARCHAR(255) NULL,' +
        ' `backup_sql` VARCHAR(255) NULL,' +
        ' `sentencias` INT NOT NULL DEFAULT 0,' +
        ' `resultado` VARCHAR(30) NOT NULL,' +
        ' `error_texto` TEXT NULL,' +
        ' `usuario` VARCHAR(100) NULL,' +
        ' `equipo` VARCHAR(100) NULL,' +
        ' PRIMARY KEY (`id`)' +
        ') ENGINE=MyISAM DEFAULT CHARSET=utf8mb4';
      Q.ExecSQL;

      Q.Close;
      Q.SQL.Text :=
        'INSERT INTO `flx_update_history` ' +
        '(`fecha`,`tipo`,`sql_referencia`,`plan_sql`,`backup_sql`,`sentencias`,`resultado`,`error_texto`,`usuario`,`equipo`) ' +
        'VALUES (NOW(), :tipo, :sqlref, :plan, :backup, :sentencias, :resultado, :error, :usuario, :equipo)';
      Q.ParamByName('tipo').AsString := 'BBDD_ESTRUCTURA';
      Q.ParamByName('sqlref').AsString := ASQLRef;
      Q.ParamByName('plan').AsString := APlanFile;
      Q.ParamByName('backup').AsString := ABackupFile;
      Q.ParamByName('sentencias').AsInteger := ASentencias;
      Q.ParamByName('resultado').AsString := AResultado;
      Q.ParamByName('error').AsString := AError;
      Q.ParamByName('usuario').AsString := GetEnvironmentVariable('USER');
      Q.ParamByName('equipo').AsString := Equipo;
      Q.ExecSQL;
    finally
      Q.Free;
    end;
  except
    on E: Exception do
    begin
      MemoDB.Lines.Add('Aviso: no se pudo registrar historial BBDD: ' + E.Message);
    end;
  end;
end;

procedure TFLXUpdateConfigForm.BtnDBAplicarPlanClick(Sender: TObject);
var
  PlanFile, BackupFile, Err: string;
  Plan, Statements, Rejected: TStringList;
  N: Integer;
  T0: TDateTime;
begin
  if Trim(EdDBSql.Text) = '' then
  begin
    ShowMessage('Seleccione primero el fichero .sql de estructura de referencia.');
    Exit;
  end;
  if not FileExists(Trim(EdDBSql.Text)) then
  begin
    ShowMessage('No existe el fichero SQL:' + LineEnding + Trim(EdDBSql.Text));
    Exit;
  end;

  PlanFile := IncludeTrailingPathDelimiter(ExtractFileDir(Trim(EdDBSql.Text))) +
              'plan_actualizacion_sugerido.sql';

  Plan := TStringList.Create;
  Statements := TStringList.Create;
  Rejected := TStringList.Create;
  Screen.Cursor := crHourGlass;
  T0 := Now;
  try
    MemoDB.Clear;
    MemoStep(MemoDB, 'Preparando aplicación controlada del SQL sugerido...');
    if not FileExists(PlanFile) then
    begin
      MemoStep(MemoDB, 'No existe plan previo. Generando plan sugerido...');
      BuildSuggestedSQLPlan(Trim(EdDBSql.Text), Plan);
      Plan.SaveToFile(PlanFile);
    end;

    MemoStep(MemoDB, 'Validando sentencias permitidas del plan...');
    LoadSafePlanStatements(PlanFile, Statements, Rejected);

    MemoDB.Lines.Add('');
    MemoDB.Lines.Add('Plan: ' + PlanFile);
    MemoDB.Lines.Add('Sentencias seguras que se pueden aplicar: ' + IntToStr(Statements.Count));
    MemoDB.Lines.Add('Sentencias rechazadas o no automáticas: ' + IntToStr(Rejected.Count));
    MemoDB.Lines.Add('');
    MemoDB.Lines.Add('Por seguridad solo se ejecutan automáticamente:');
    MemoDB.Lines.Add('- CREATE TABLE');
    MemoDB.Lines.Add('- ALTER TABLE ... ADD COLUMN');
    MemoDB.Lines.Add('- ALTER TABLE ... MODIFY COLUMN solo para ampliar campos de forma segura');
    MemoDB.Lines.Add('Reducciones, DROP, CHANGE y cambios NULL/DEFAULT quedan para revisión manual.');

    if Statements.Count = 0 then
    begin
      ShowMessage('No hay sentencias seguras para aplicar automáticamente.' + LineEnding +
                  'Revise el plan generado manualmente.');
      Exit;
    end;

    if Rejected.Count > 0 then
    begin
      MemoDB.Lines.Add('');
      MemoDB.Lines.Add('Sentencias NO ejecutadas automáticamente:');
      for N := 0 to Rejected.Count - 1 do
      begin
        if N >= 10 then
        begin
          MemoDB.Lines.Add('...');
          Break;
        end;
        MemoDB.Lines.Add(Rejected[N]);
      end;
    end;

    if MessageDlg('Aplicar SQL sugerido',
       'Se va a crear primero una copia de seguridad con mysqldump.' + LineEnding +
       'Después se ejecutarán ' + IntToStr(Statements.Count) + ' sentencias seguras.' + LineEnding + LineEnding +
       '¿Desea continuar?', mtConfirmation, [mbYes, mbNo], 0) <> 6 then
      Exit;

    if not MakeDBBackup(BackupFile, Err) then
    begin
      MemoDB.Lines.Add('');
      MemoDB.Lines.Add('ERROR COPIA: ' + Err);
      ShowMessage(Err);
      Exit;
    end;
    MemoDB.Lines.Add('Copia creada: ' + BackupFile);

    Err := '';
    N := ExecutePlanStatements(Statements, Err);
    MemoDB.Lines.Add('');
    MemoDB.Lines.Add('Sentencias ejecutadas correctamente: ' + IntToStr(N));
    if Err <> '' then
    begin
      MemoDB.Lines.Add('ERROR: ' + Err);
      RegisterDBUpdateHistory(Trim(EdDBSql.Text), PlanFile, BackupFile, N, 'ERROR', Err);
      ShowMessage('La aplicación del SQL se detuvo con error.' + LineEnding +
                  'Copia previa:' + LineEnding + BackupFile + LineEnding + LineEnding + Err);
      Exit;
    end;

    if Trim(EdDBVersion.Text) <> '' then
    begin
      SetDBSchemaVersion(Trim(EdDBVersion.Text), Trim(EdDBSql.Text));
      MemoDB.Lines.Add('Versión BBDD marcada como aplicada: ' + Trim(EdDBVersion.Text));
    end;

    RegisterDBUpdateHistory(Trim(EdDBSql.Text), PlanFile, BackupFile, N, 'OK', '');
    MemoDB.Lines.Add('Historial registrado en tabla flx_update_history.');
    MemoDB.Lines.Add('Aplicación completada correctamente.');
    MemoDB.Lines.Add('Tiempo total: ' + ElapsedSecondsText(T0));
    ShowMessage('SQL aplicado correctamente.' + LineEnding +
                'Copia previa:' + LineEnding + BackupFile + LineEnding + LineEnding +
                'Recomendado: pulse de nuevo Comprobar estructura.');
  finally
    Screen.Cursor := crDefault;
    Plan.Free;
    Statements.Free;
    Rejected.Free;
  end;
end;

procedure TFLXUpdateConfigForm.BtnDBGenerarPlanClick(Sender: TObject);
var
  Plan: TStringList;
  OutFile: string;
  T0: TDateTime;
begin
  if Trim(EdDBSql.Text) = '' then
  begin
    ShowMessage('Seleccione primero el fichero .sql de estructura de referencia.');
    Exit;
  end;
  if not FileExists(Trim(EdDBSql.Text)) then
  begin
    ShowMessage('No existe el fichero SQL:' + LineEnding + Trim(EdDBSql.Text));
    Exit;
  end;

  Plan := TStringList.Create;
  Screen.Cursor := crHourGlass;
  T0 := Now;
  try
    try
      MemoDB.Clear;
      MemoStep(MemoDB, 'Generando SQL sugerido (solo genera fichero, no ejecuta cambios)...');
      MemoStep(MemoDB, 'Leyendo SQL y cargando estructura local...');
      BuildSuggestedSQLPlan(Trim(EdDBSql.Text), Plan);
      MemoStep(MemoDB, 'Plan generado en memoria. Guardando fichero...');
      OutFile := IncludeTrailingPathDelimiter(ExtractFileDir(Trim(EdDBSql.Text))) +
                 'plan_actualizacion_sugerido.sql';
      Plan.SaveToFile(OutFile);
      MemoDB.Clear;
      MemoDB.Lines.AddStrings(Plan);
      MemoDB.Lines.Add('');
      MemoDB.Lines.Add('Plan guardado en:');
      MemoDB.Lines.Add(OutFile);
      MemoDB.Lines.Add('Tiempo total: ' + ElapsedSecondsText(T0));
      ShowMessage('SQL sugerido generado para revisión:' + LineEnding + OutFile +
                  LineEnding + LineEnding + 'No se ha ejecutado ningún cambio en la base de datos.');
    except
      on E: Exception do
      begin
        MemoDB.Lines.Add('');
        MemoDB.Lines.Add('ERROR generando SQL sugerido: ' + E.Message);
        ShowMessage('No se pudo generar el SQL sugerido:' + LineEnding + E.Message);
      end;
    end;
  finally
    Screen.Cursor := crDefault;
    Plan.Free;
  end;
end;

procedure TFLXUpdateConfigForm.BtnDBComprobarClick(Sender: TObject);
var
  RefTables, RefFields, LocalTables, LocalFields, RefMeta, LocalMeta: TStringList;
  I, MissingTables, MissingFields, DiffTypes, DiffNulls, DiffDefaults: Integer;
  K, R, L: string;
  T0: TDateTime;
begin
  if Trim(EdDBSql.Text) = '' then
  begin
    ShowMessage('Seleccione el fichero .sql de estructura de referencia.');
    Exit;
  end;
  if not FileExists(Trim(EdDBSql.Text)) then
  begin
    ShowMessage('No existe el fichero SQL:' + LineEnding + Trim(EdDBSql.Text));
    Exit;
  end;

  T0 := Now;
  Screen.Cursor := crHourGlass;
  RefTables := TStringList.Create;
  RefFields := TStringList.Create;
  LocalTables := TStringList.Create;
  LocalFields := TStringList.Create;
  RefMeta := TStringList.Create;
  LocalMeta := TStringList.Create;
  try
    MemoDB.Clear;
    MemoStep(MemoDB, 'Comprobando estructura de BBDD (solo lectura)...');
    MemoStep(MemoDB, 'SQL referencia: ' + Trim(EdDBSql.Text));
    MemoDB.Lines.Add('');

    MemoStep(MemoDB, '1/4 Analizando fichero SQL de referencia...');
    ParseSQLReference(Trim(EdDBSql.Text), RefTables, RefFields, RefMeta);
    MemoStep(MemoDB, '    SQL analizado: ' + IntToStr(RefTables.Count) + ' tablas, ' + IntToStr(RefFields.Count) + ' campos.');
    MemoStep(MemoDB, '2/4 Cargando estructura local desde INFORMATION_SCHEMA...');
    LoadDBStructure(LocalTables, LocalFields, LocalMeta);
    MemoStep(MemoDB, '    Estructura local cargada: ' + IntToStr(LocalTables.Count) + ' tablas, ' + IntToStr(LocalFields.Count) + ' campos.');
    MemoStep(MemoDB, '3/4 Comparando en memoria...');

    MemoDB.Lines.Add('Tablas esperadas en SQL: ' + IntToStr(RefTables.Count));
    MemoDB.Lines.Add('Campos esperados en SQL: ' + IntToStr(RefFields.Count));
    MemoDB.Lines.Add('Tablas locales: ' + IntToStr(LocalTables.Count));
    MemoDB.Lines.Add('Campos locales: ' + IntToStr(LocalFields.Count));
    MemoDB.Lines.Add('');

    MissingTables := 0;
    MemoDB.Lines.Add('TABLAS FALTANTES:');
    for I := 0 to RefTables.Count - 1 do
      if LocalTables.IndexOf(RefTables[I]) < 0 then
      begin
        Inc(MissingTables);
        MemoDB.Lines.Add('  X ' + RefTables[I]);
      end;
    if MissingTables = 0 then MemoDB.Lines.Add('  OK No faltan tablas.');
    MemoDB.Lines.Add('');

    MissingFields := 0;
    MemoDB.Lines.Add('CAMPOS FALTANTES:');
    for I := 0 to RefFields.Count - 1 do
    begin
      if (I mod 500 = 0) then Application.ProcessMessages;
      if LocalFields.IndexOf(RefFields[I]) < 0 then
      begin
        Inc(MissingFields);
        MemoDB.Lines.Add('  X ' + RefFields[I]);
      end;
    end;
    if MissingFields = 0 then MemoDB.Lines.Add('  OK No faltan campos.');
    MemoDB.Lines.Add('');

    DiffTypes := 0;
    MemoDB.Lines.Add('DIFERENCIAS DE TIPO/TAMAÑO:');
    for I := 0 to RefFields.Count - 1 do
    begin
      if (I mod 500 = 0) then Application.ProcessMessages;
      K := RefFields[I];
      if LocalFields.IndexOf(K) < 0 then Continue;
      R := MetaGet(RefMeta, K + '|type');
      L := MetaGet(LocalMeta, K + '|type');
      if (R <> '') and (L <> '') and (R <> L) then
      begin
        Inc(DiffTypes);
        MemoDB.Lines.Add('  ! ' + K + '  SQL=' + R + '  Local=' + L);
      end;
    end;
    if DiffTypes = 0 then MemoDB.Lines.Add('  OK No se detectan diferencias de tipo/tamaño.');
    MemoDB.Lines.Add('');

    DiffNulls := 0;
    MemoDB.Lines.Add('DIFERENCIAS NULL / NOT NULL:');
    for I := 0 to RefFields.Count - 1 do
    begin
      K := RefFields[I];
      if LocalFields.IndexOf(K) < 0 then Continue;
      R := MetaGet(RefMeta, K + '|null');
      L := MetaGet(LocalMeta, K + '|null');
      if (R <> '') and (L <> '') and (R <> L) then
      begin
        Inc(DiffNulls);
        MemoDB.Lines.Add('  ! ' + K + '  SQL=' + R + '  Local=' + L);
      end;
    end;
    if DiffNulls = 0 then MemoDB.Lines.Add('  OK No se detectan diferencias NULL/NOT NULL.');
    MemoDB.Lines.Add('');

    DiffDefaults := 0;
    MemoDB.Lines.Add('DIFERENCIAS DEFAULT (informativo):');
    for I := 0 to RefFields.Count - 1 do
    begin
      K := RefFields[I];
      if LocalFields.IndexOf(K) < 0 then Continue;
      R := MetaGet(RefMeta, K + '|default');
      L := MetaGet(LocalMeta, K + '|default');
      if (R <> L) then
      begin
        Inc(DiffDefaults);
        MemoDB.Lines.Add('  ! ' + K + '  SQL=' + R + '  Local=' + L);
      end;
    end;
    if DiffDefaults = 0 then MemoDB.Lines.Add('  OK No se detectan diferencias DEFAULT.');
    MemoDB.Lines.Add('');

    if (MissingTables = 0) and (MissingFields = 0) and (DiffTypes = 0) and (DiffNulls = 0) then
      MemoDB.Lines.Add('ESTADO: Compatible según tablas, campos y tipos básicos.')
    else
      MemoDB.Lines.Add('ESTADO: Revisión recomendada. No se ha modificado la base de datos.');

    MemoDB.Lines.Add('');
    MemoStep(MemoDB, '4/4 Finalizado. Tiempo total: ' + ElapsedSecondsText(T0));
  except
    on E: Exception do
    begin
      MemoDB.Lines.Add('');
      MemoDB.Lines.Add('ERROR: ' + E.Message);
      ShowMessage('No se pudo comprobar la estructura:' + LineEnding + E.Message);
    end;
  end;
  Screen.Cursor := crDefault;
  RefTables.Free;
  RefFields.Free;
  LocalTables.Free;
  LocalFields.Free;
  RefMeta.Free;
  LocalMeta.Free;
end;


function TFLXUpdateConfigForm.RecoveryScriptName: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(FIniFile)) + 'rollback_facturlinex.sh';
end;

procedure TFLXUpdateConfigForm.RefreshRecoveryInfo;
var
  SR: TSearchRec;
  ExeDir, ExeName, TmpDir, LogFile, PlanFile: string;
  Count: Integer;
begin
  if not Assigned(MemoRec) then Exit;
  MemoRec.Clear;
  ExeDir := ExtractFileDir(Trim(EdExeLocal.Text));
  ExeName := ExtractFileName(Trim(EdExeLocal.Text));
  TmpDir := IncludeTrailingPathDelimiter(Trim(EdTmp.Text));
  LogFile := Trim(EdLog.Text);
  PlanFile := TmpDir + 'plan_actualizacion_sugerido.sql';

  MemoRec.Lines.Add('Recuperación FacturLinEx');
  MemoRec.Lines.Add('');
  MemoRec.Lines.Add('Ejecutable local: ' + Trim(EdExeLocal.Text));
  MemoRec.Lines.Add('Carpeta ejecutable: ' + ExeDir);
  MemoRec.Lines.Add('Ruta temporal: ' + TmpDir);
  MemoRec.Lines.Add('Log: ' + LogFile);
  MemoRec.Lines.Add('');

  MemoRec.Lines.Add('Copias .bak encontradas:');
  Count := 0;
  if DirectoryExists(ExeDir) then
  begin
    if FindFirst(IncludeTrailingPathDelimiter(ExeDir) + ExeName + '.bak_*', faAnyFile, SR) = 0 then
    begin
      repeat
        if (SR.Name <> '.') and (SR.Name <> '..') then
        begin
          Inc(Count);
          MemoRec.Lines.Add('  ' + IncludeTrailingPathDelimiter(ExeDir) + SR.Name);
        end;
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
  end;
  if Count = 0 then MemoRec.Lines.Add('  No se han encontrado copias .bak para este ejecutable.');

  MemoRec.Lines.Add('');
  if FileExists(TmpDir + 'FacturLinEx.descargado') then
    MemoRec.Lines.Add('Ejecutable descargado temporal: ' + TmpDir + 'FacturLinEx.descargado')
  else
    MemoRec.Lines.Add('Ejecutable descargado temporal: no encontrado');

  if FileExists(PlanFile) then
    MemoRec.Lines.Add('Plan SQL sugerido: ' + PlanFile)
  else
    MemoRec.Lines.Add('Plan SQL sugerido: no encontrado');

  if FileExists(LogFile) then
    MemoRec.Lines.Add('Log de actualizaciones: existe')
  else
    MemoRec.Lines.Add('Log de actualizaciones: no encontrado');

  MemoRec.Lines.Add('');
  MemoRec.Lines.Add('Script rollback revisable: ' + RecoveryScriptName);
end;

procedure TFLXUpdateConfigForm.BtnRecRefrescarClick(Sender: TObject);
begin
  RefreshRecoveryInfo;
end;

procedure TFLXUpdateConfigForm.BtnRecGenerarClick(Sender: TObject);
var
  SL: TStringList;
  SR: TSearchRec;
  ExeDir, ExeName, LastBak, ScriptFile: string;
begin
  ExeDir := ExtractFileDir(Trim(EdExeLocal.Text));
  ExeName := ExtractFileName(Trim(EdExeLocal.Text));
  LastBak := '';
  if DirectoryExists(ExeDir) then
  begin
    if FindFirst(IncludeTrailingPathDelimiter(ExeDir) + ExeName + '.bak_*', faAnyFile, SR) = 0 then
    begin
      repeat
        if (SR.Name <> '.') and (SR.Name <> '..') then
          if SR.Name > ExtractFileName(LastBak) then
            LastBak := IncludeTrailingPathDelimiter(ExeDir) + SR.Name;
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
  end;

  if LastBak = '' then
  begin
    ShowMessage('No se encontró ninguna copia .bak para generar rollback.');
    RefreshRecoveryInfo;
    Exit;
  end;

  ScriptFile := RecoveryScriptName;
  SL := TStringList.Create;
  try
    SL.Add('#!/bin/sh');
    SL.Add('set -e');
    SL.Add('echo "Rollback FacturLinEx"');
    SL.Add('echo "Restaurando copia:"');
    SL.Add('echo ' + AnsiQuotedStr(LastBak, #39));
    SL.Add('echo "Destino:"');
    SL.Add('echo ' + AnsiQuotedStr(Trim(EdExeLocal.Text), #39));
    SL.Add('cp ' + AnsiQuotedStr(LastBak, #39) + ' ' + AnsiQuotedStr(Trim(EdExeLocal.Text), #39));
    SL.Add('chmod +x ' + AnsiQuotedStr(Trim(EdExeLocal.Text), #39));
    SL.Add('echo "Rollback finalizado."');
    ForceDirectories(ExtractFileDir(ScriptFile));
    SL.SaveToFile(ScriptFile);
    fpChmod(ScriptFile, &755);
  finally
    SL.Free;
  end;
  ShowMessage('Script de rollback generado:' + LineEnding + ScriptFile + LineEnding + LineEnding +
              'Revíselo antes de ejecutarlo.');
  RefreshRecoveryInfo;
end;


procedure TFLXUpdateConfigForm.GenerateMaintenanceReport;
var
  SL: TStringList;
  OutText, Hash, Err, ReportFile, LogDir, Exe: string;
  SR: TSearchRec;
  BakCount: Integer;
  Q: TZQuery;
begin
  SL := TStringList.Create;
  try
    SL.Add('INFORME DE MANTENIMIENTO FACTURLINEX');
    SL.Add('Generado: ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
    SL.Add('Equipo: ' + GetEnvironmentVariable('HOSTNAME'));
    SL.Add('Usuario sistema: ' + GetEnvironmentVariable('USER'));
    SL.Add('');

    SL.Add('[Actualizador]');
    SL.Add('INI: ' + FIniFile);
    SL.Add('Origen/URL: ' + Trim(EdURL.Text));
    SL.Add('Canal: ' + Trim(EdCanal.Text));
    SL.Add('VersionLocal INI: ' + Trim(EdVersionLocal.Text));
    SL.Add('Ruta temporal: ' + Trim(EdTmp.Text));
    SL.Add('Log: ' + Trim(EdLog.Text));
    SL.Add('Activar: ' + BoolToIni(CkActivar.Checked));
    SL.Add('Comprobar al inicio: ' + BoolToIni(CkComprobar.Checked));
    SL.Add('Permitir instalar: ' + BoolToIni(CkInstalar.Checked));
    SL.Add('Reiniciar tras actualizar: ' + BoolToIni(CkReiniciar.Checked));
    SL.Add('');

    SL.Add('[Ejecutable]');
    Exe := Trim(EdExeLocal.Text);
    SL.Add('Ruta: ' + Exe);
    if FileExists(Exe) then
    begin
      SL.Add('Existe: SI');
      SL.Add('Tamaño bytes: ' + IntToStr(FileSizeByName(Exe)));
      if CalcSHA256(Exe, Hash, Err) then
        SL.Add('SHA256: ' + Hash)
      else
        SL.Add('SHA256: ERROR: ' + Err);
      if RunCommandCapture('/usr/bin/ldd', [Exe], OutText) = 0 then
      begin
        if Pos('not found', LowerCase(OutText)) > 0 then
          SL.Add('ldd: HAY DEPENDENCIAS NO ENCONTRADAS')
        else
          SL.Add('ldd: correcto, sin not found');
      end
      else
        SL.Add('ldd: no se pudo ejecutar');
    end
    else
      SL.Add('Existe: NO');
    SL.Add('');

    SL.Add('[Copias .bak del ejecutable]');
    BakCount := 0;
    if DirectoryExists(ExtractFileDir(Exe)) then
    begin
      if FindFirst(IncludeTrailingPathDelimiter(ExtractFileDir(Exe)) + ExtractFileName(Exe) + '.bak_*', faAnyFile, SR) = 0 then
      begin
        repeat
          if (SR.Name <> '.') and (SR.Name <> '..') then
          begin
            Inc(BakCount);
            SL.Add(SR.Name + '  ' + IntToStr(SR.Size) + ' bytes');
          end;
        until FindNext(SR) <> 0;
        FindClose(SR);
      end;
    end;
    if BakCount = 0 then SL.Add('No se encontraron copias .bak.');
    SL.Add('');

    SL.Add('[Base de datos]');
    try
      if Assigned(DataModule1) and Assigned(DataModule1.dbConexion) then
      begin
        SL.Add('Conectada: ' + BoolToIni(DataModule1.dbConexion.Connected));
        SL.Add('Host: ' + DataModule1.dbConexion.HostName);
        SL.Add('Base: ' + DataModule1.dbConexion.Database);
        SL.Add('Usuario: ' + DataModule1.dbConexion.User);
        SL.Add('Version estructura marcada: ' + GetDBSchemaVersion);

        if DataModule1.dbConexion.Connected then
        begin
          Q := TZQuery.Create(nil);
          try
            Q.Connection := DataModule1.dbConexion;
            Q.SQL.Text := 'SELECT COUNT(*) AS c FROM information_schema.tables WHERE table_schema = DATABASE()';
            Q.Open;
            SL.Add('Tablas locales: ' + Q.FieldByName('c').AsString);
            Q.Close;
            Q.SQL.Text := 'SELECT COUNT(*) AS c FROM information_schema.columns WHERE table_schema = DATABASE()';
            Q.Open;
            SL.Add('Campos locales: ' + Q.FieldByName('c').AsString);
          finally
            Q.Free;
          end;
        end;
      end
      else
        SL.Add('No se encontró DataModule1.dbConexion.');
    except
      on E: Exception do SL.Add('Error leyendo BBDD: ' + E.Message);
    end;
    SL.Add('');

    SL.Add('[Ficheros de mantenimiento]');
    SL.Add('SQL referencia seleccionado: ' + Trim(EdDBSql.Text));
    SL.Add('Plan sugerido: ' + IncludeTrailingPathDelimiter(Trim(EdTmp.Text)) + 'plan_actualizacion_sugerido.sql');
    SL.Add('Script rollback: ' + RecoveryScriptName);
    if FileExists(Trim(EdLog.Text)) then
      SL.Add('Log actualizaciones: existe')
    else
      SL.Add('Log actualizaciones: no encontrado');

    MemoReport.Lines.Assign(SL);

    LogDir := ExtractFileDir(Trim(EdLog.Text));
    if Trim(LogDir) = '' then LogDir := IncludeTrailingPathDelimiter(ExtractFileDir(FIniFile)) + 'logs';
    ForceDirectories(LogDir);
    ReportFile := IncludeTrailingPathDelimiter(LogDir) + 'informe_mantenimiento_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.txt';
    SL.SaveToFile(ReportFile);
    MemoReport.Lines.Add('');
    MemoReport.Lines.Add('Informe guardado en: ' + ReportFile);
    ShowMessage('Informe generado:' + LineEnding + ReportFile);
  finally
    SL.Free;
  end;
end;

procedure TFLXUpdateConfigForm.BtnReportTodoClick(Sender: TObject);
var
  Hash, Err, OutText, Exe: string;
  T0: TDateTime;
begin
  T0 := Now;
  MemoReport.Clear;
  MemoStep(MemoReport, 'Comprobación completa iniciada.');

  Exe := Trim(EdExeLocal.Text);
  if FileExists(Exe) then
  begin
    MemoStep(MemoReport, 'Ejecutable local encontrado: ' + Exe);
    if CalcSHA256(Exe, Hash, Err) then
      MemoStep(MemoReport, 'SHA256 ejecutable local OK: ' + Hash)
    else
      MemoStep(MemoReport, 'SHA256 ejecutable local: ' + Err);

    if RunCommandCapture('/usr/bin/ldd', [Exe], OutText) = 0 then
    begin
      if Pos('not found', LowerCase(OutText)) > 0 then
        MemoStep(MemoReport, 'ldd: revisar, hay dependencias no encontradas.')
      else
        MemoStep(MemoReport, 'ldd: correcto, sin dependencias not found.');
    end
    else
      MemoStep(MemoReport, 'ldd: no se pudo ejecutar.');
  end
  else
    MemoStep(MemoReport, 'Ejecutable local NO encontrado: ' + Exe);

  try
    if Assigned(DataModule1) and Assigned(DataModule1.dbConexion) then
    begin
      if DataModule1.dbConexion.Connected then
      begin
        MemoStep(MemoReport, 'BBDD conectada: ' + DataModule1.dbConexion.Database);
        MemoStep(MemoReport, 'Versión estructura marcada: ' + GetDBSchemaVersion);
      end
      else
        MemoStep(MemoReport, 'BBDD no conectada.');
    end
    else
      MemoStep(MemoReport, 'No se encontró DataModule1.dbConexion.');
  except
    on E: Exception do
      MemoStep(MemoReport, 'Error comprobando BBDD: ' + E.Message);
  end;

  try
    RefreshRecoveryInfo;
    MemoStep(MemoReport, 'Recuperación: información actualizada.');
  except
    on E: Exception do
      MemoStep(MemoReport, 'Error refrescando recuperación: ' + E.Message);
  end;

  MemoStep(MemoReport, 'Generando informe completo...');
  GenerateMaintenanceReport;
  MemoReport.Lines.Insert(0, 'COMPROBACIÓN COMPLETA realizada en ' + ElapsedSecondsText(T0));
end;

procedure TFLXUpdateConfigForm.BtnReportGenerarClick(Sender: TObject);
begin
  GenerateMaintenanceReport;
end;

procedure MostrarConfigActualizacionesFLX(const AIniFile, ACurrentExecutable: string);
var
  F: TFLXUpdateConfigForm;
begin
  F := TFLXUpdateConfigForm.CreateConfig(Application, AIniFile, ACurrentExecutable);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

end.
