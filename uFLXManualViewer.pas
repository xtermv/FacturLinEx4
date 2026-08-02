unit uFLXManualViewer;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

procedure MostrarManualFacturLinEx;

implementation

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, ComCtrls, Process, LCLIntf, LCLType;

type
  TFLXManualViewerForm = class(TForm)
  private
    FPDF: string;
    FWeb: string;
    FPagina: Integer;
    FDirectorioTemporal: string;
    FPrefijoTemporal: string;
    FCabecera: TPanel;
    FPie: TPanel;
    FScroll: TScrollBox;
    FImagen: TImage;
    FTitulo: TLabel;
    FPaginaLabel: TLabel;
    FBtnAnterior: TBitBtn;
    FBtnSiguiente: TBitBtn;
    FBtnAbrirExterno: TBitBtn;
    FBtnCerrar: TBitBtn;
    procedure ConstruirInterfaz;
    function RenderizarPagina(APagina: Integer): Boolean;
    procedure AnteriorClick(Sender: TObject);
    procedure SiguienteClick(Sender: TObject);
    procedure AbrirExternoClick(Sender: TObject);
    procedure CerrarClick(Sender: TObject);
    procedure FormKeyDownManual(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LimpiarTemporales;
  public
    constructor CreateManual(AOwner: TComponent;
      const APDF, AWeb: string);
    destructor Destroy; override;
    function Inicializar: Boolean;
  end;


function BuscarEjecutableEnPath(const ANombre: string): string;
var
  Rutas: TStringList;
  I: Integer;
  Candidato: string;
begin
  Result := '';
  Rutas := TStringList.Create;
  try
    Rutas.StrictDelimiter := True;
    Rutas.Delimiter := PathSeparator;
    Rutas.DelimitedText := GetEnvironmentVariable('PATH');
    for I := 0 to Rutas.Count - 1 do
    begin
      Candidato := IncludeTrailingPathDelimiter(Rutas[I]) + ANombre;
      if FileExists(Candidato) then Exit(Candidato);
      {$IFDEF WINDOWS}
      if FileExists(Candidato + '.exe') then Exit(Candidato + '.exe');
      {$ENDIF}
    end;
  finally
    Rutas.Free;
  end;
end;

function BuscarArchivoRecursivo(const ADirectorio, ANombre,
  AExtension: string; AProfundidad: Integer): string;
var
  SR: TSearchRec;
  Ruta, Hallado: string;
begin
  Result := '';
  if (AProfundidad < 0) or not DirectoryExists(ADirectorio) then Exit;

  if FindFirst(IncludeTrailingPathDelimiter(ADirectorio) + '*',
    faAnyFile, SR) <> 0 then Exit;
  try
    repeat
      if (SR.Name = '.') or (SR.Name = '..') then Continue;
      Ruta := IncludeTrailingPathDelimiter(ADirectorio) + SR.Name;

      if (SR.Attr and faDirectory) <> 0 then
      begin
        Hallado := BuscarArchivoRecursivo(Ruta, ANombre,
          AExtension, AProfundidad - 1);
        if Hallado <> '' then Exit(Hallado);
      end
      else
      begin
        if (ANombre <> '') and SameText(SR.Name, ANombre) then
          Exit(Ruta);
        if (AExtension <> '') and
           SameText(ExtractFileExt(SR.Name), AExtension) then
          Exit(Ruta);
      end;
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
  end;
end;

function LocalizarRaizManual: string;
const
  NOMBRE_MANUAL = 'Manual_FacturLinEx_Web_v0.9';
var
  Bases: array[0..5] of string;
  I: Integer;
  Base, Candidato: string;
begin
  Result := '';
  Bases[0] := ExtractFilePath(ParamStr(0));
  Bases[1] := GetCurrentDir;
  Bases[2] := ExpandFileName(IncludeTrailingPathDelimiter(
    ExtractFilePath(ParamStr(0))) + '..');
  Bases[3] := ExpandFileName(IncludeTrailingPathDelimiter(
    GetCurrentDir) + '..');
  Bases[4] := '/usr/share/facturlinex2';
  Bases[5] := IncludeTrailingPathDelimiter(GetUserDir) + '.facturlinex2';

  for I := Low(Bases) to High(Bases) do
  begin
    Base := ExcludeTrailingPathDelimiter(Bases[I]);
    if Base = '' then Continue;

    Candidato := IncludeTrailingPathDelimiter(Base) +
      'Manual FL2 2026 - V1' + DirectorySeparator + 'v9' +
      DirectorySeparator + NOMBRE_MANUAL;
    if DirectoryExists(Candidato) then Exit(Candidato);

    Candidato := IncludeTrailingPathDelimiter(Base) + NOMBRE_MANUAL;
    if DirectoryExists(Candidato) then Exit(Candidato);

    Candidato := IncludeTrailingPathDelimiter(Base) + 'Manual' +
      DirectorySeparator + NOMBRE_MANUAL;
    if DirectoryExists(Candidato) then Exit(Candidato);
  end;
end;

procedure AbrirDocumentoExterno(const APDF, AWeb: string);
begin
  if (APDF <> '') and FileExists(APDF) then
  begin
    if not OpenDocument(APDF) then
      ShowMessage('No se ha podido abrir el PDF del manual.');
    Exit;
  end;

  if (AWeb <> '') and FileExists(AWeb) then
  begin
    if not OpenDocument(AWeb) then
      ShowMessage('No se ha podido abrir la versión web del manual.');
    Exit;
  end;

  ShowMessage('No se ha localizado ningún formato utilizable del manual.');
end;

constructor TFLXManualViewerForm.CreateManual(AOwner: TComponent;
  const APDF, AWeb: string);
begin
  inherited CreateNew(AOwner, 1);
  FPDF := APDF;
  FWeb := AWeb;
  FPagina := 1;
  FDirectorioTemporal := IncludeTrailingPathDelimiter(GetTempDir(False));
  FPrefijoTemporal := FDirectorioTemporal + 'facturlinex_manual_' +
    FormatDateTime('yyyymmddhhnnsszzz', Now);
  ConstruirInterfaz;
end;

destructor TFLXManualViewerForm.Destroy;
begin
  LimpiarTemporales;
  inherited Destroy;
end;

procedure TFLXManualViewerForm.ConstruirInterfaz;
begin
  Caption := 'FacturLinEx · Manual';
  Position := poScreenCenter;
  WindowState := wsMaximized;
  Color := RGBToColor(238, 242, 246);
  ParentFont := False;
  Font.Name := 'Sans';
  Font.Height := -11;
  KeyPreview := True;
  OnKeyDown := @FormKeyDownManual;

  FCabecera := TPanel.Create(Self);
  FCabecera.Parent := Self;
  FCabecera.Align := alTop;
  FCabecera.Height := 64;
  FCabecera.BevelOuter := bvNone;
  FCabecera.Color := RGBToColor(29, 78, 110);
  FCabecera.Caption := '';

  FTitulo := TLabel.Create(Self);
  FTitulo.Parent := FCabecera;
  FTitulo.Left := 22;
  FTitulo.Top := 13;
  FTitulo.AutoSize := True;
  FTitulo.Caption := 'Manual de FacturLinEx';
  FTitulo.ParentFont := False;
  FTitulo.Font.Name := 'Sans';
  FTitulo.Font.Height := -19;
  FTitulo.Font.Style := [fsBold];
  FTitulo.Font.Color := clWhite;

  FPaginaLabel := TLabel.Create(Self);
  FPaginaLabel.Parent := FCabecera;
  FPaginaLabel.AnchorSideRight.Control := FCabecera;
  FPaginaLabel.AnchorSideRight.Side := asrRight;
  FPaginaLabel.Anchors := [akTop, akRight];
  FPaginaLabel.AutoSize := True;
  FPaginaLabel.Top := 22;
  FPaginaLabel.Left := FCabecera.Width - 150;
  FPaginaLabel.ParentFont := False;
  FPaginaLabel.Font.Color := clWhite;
  FPaginaLabel.Caption := 'Página 1';

  FPie := TPanel.Create(Self);
  FPie.Parent := Self;
  FPie.Align := alBottom;
  FPie.Height := 62;
  FPie.BevelOuter := bvNone;
  FPie.Color := RGBToColor(224, 231, 237);
  FPie.Caption := '';

  FBtnAnterior := TBitBtn.Create(Self);
  FBtnAnterior.Parent := FPie;
  FBtnAnterior.SetBounds(18, 12, 120, 38);
  FBtnAnterior.Caption := 'Anterior';
  FBtnAnterior.OnClick := @AnteriorClick;

  FBtnSiguiente := TBitBtn.Create(Self);
  FBtnSiguiente.Parent := FPie;
  FBtnSiguiente.SetBounds(148, 12, 120, 38);
  FBtnSiguiente.Caption := 'Siguiente';
  FBtnSiguiente.OnClick := @SiguienteClick;

  FBtnAbrirExterno := TBitBtn.Create(Self);
  FBtnAbrirExterno.Parent := FPie;
  FBtnAbrirExterno.SetBounds(286, 12, 170, 38);
  FBtnAbrirExterno.Caption := 'Abrir fuera de FL';
  FBtnAbrirExterno.Hint :=
    'Abrir el PDF o la versión web con la aplicación predeterminada';
  FBtnAbrirExterno.ShowHint := True;
  FBtnAbrirExterno.OnClick := @AbrirExternoClick;

  FBtnCerrar := TBitBtn.Create(Self);
  FBtnCerrar.Parent := FPie;
  FBtnCerrar.AnchorSideRight.Control := FPie;
  FBtnCerrar.AnchorSideRight.Side := asrRight;
  FBtnCerrar.Anchors := [akTop, akRight];
  FBtnCerrar.SetBounds(FPie.Width - 138, 12, 120, 38);
  FBtnCerrar.Caption := 'Cerrar';
  FBtnCerrar.OnClick := @CerrarClick;

  FScroll := TScrollBox.Create(Self);
  FScroll.Parent := Self;
  FScroll.Align := alClient;
  FScroll.BorderStyle := bsNone;
  FScroll.AutoScroll := True;
  FScroll.Color := RGBToColor(238, 242, 246);

  FImagen := TImage.Create(Self);
  FImagen.Parent := FScroll;
  FImagen.Left := 20;
  FImagen.Top := 20;
  FImagen.AutoSize := True;
  FImagen.Center := False;
  FImagen.Proportional := False;
  FImagen.Stretch := False;
end;

function TFLXManualViewerForm.RenderizarPagina(APagina: Integer): Boolean;
var
  P: TProcess;
  ArchivoImagen: string;
begin
  Result := False;
  if (APagina < 1) or not FileExists(FPDF) then Exit;

  ArchivoImagen := FPrefijoTemporal + '.png';
  if FileExists(ArchivoImagen) then DeleteFile(ArchivoImagen);

  P := TProcess.Create(nil);
  try
    P.Executable := BuscarEjecutableEnPath('pdftoppm');
    if P.Executable = '' then Exit;

    P.Parameters.Add('-f');
    P.Parameters.Add(IntToStr(APagina));
    P.Parameters.Add('-l');
    P.Parameters.Add(IntToStr(APagina));
    P.Parameters.Add('-singlefile');
    P.Parameters.Add('-png');
    P.Parameters.Add('-r');
    P.Parameters.Add('120');
    P.Parameters.Add(FPDF);
    P.Parameters.Add(FPrefijoTemporal);
    P.Options := [poWaitOnExit];
    P.Execute;

    if (P.ExitStatus <> 0) or not FileExists(ArchivoImagen) then Exit;

    FImagen.Picture.Clear;
    FImagen.Picture.LoadFromFile(ArchivoImagen);
    FPagina := APagina;
    FPaginaLabel.Caption := 'Página ' + IntToStr(FPagina);
    FBtnAnterior.Enabled := FPagina > 1;
    FScroll.HorzScrollBar.Position := 0;
    FScroll.VertScrollBar.Position := 0;
    Result := True;
  except
    Result := False;
  end;
  P.Free;
end;

function TFLXManualViewerForm.Inicializar: Boolean;
begin
  Result := RenderizarPagina(1);
end;

procedure TFLXManualViewerForm.AnteriorClick(Sender: TObject);
begin
  if FPagina > 1 then RenderizarPagina(FPagina - 1);
end;

procedure TFLXManualViewerForm.SiguienteClick(Sender: TObject);
begin
  if not RenderizarPagina(FPagina + 1) then
    ShowMessage('No hay más páginas en el manual.');
end;

procedure TFLXManualViewerForm.AbrirExternoClick(Sender: TObject);
begin
  AbrirDocumentoExterno(FPDF, FWeb);
end;

procedure TFLXManualViewerForm.CerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TFLXManualViewerForm.FormKeyDownManual(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TFLXManualViewerForm.LimpiarTemporales;
var
  ArchivoImagen: string;
begin
  ArchivoImagen := FPrefijoTemporal + '.png';
  if FileExists(ArchivoImagen) then
    DeleteFile(ArchivoImagen);
end;

procedure MostrarManualFacturLinEx;
var
  Raiz, PDF, Web: string;
  Visor: TFLXManualViewerForm;
begin
  Raiz := LocalizarRaizManual;
  if Raiz = '' then
  begin
    ShowMessage('No se ha encontrado la carpeta del manual.' +
      LineEnding + LineEnding +
      'Ruta esperada junto al proyecto:' + LineEnding +
      'Manual FL2 2026 - V1/v9/Manual_FacturLinEx_Web_v0.9');
    Exit;
  end;

  Web := BuscarArchivoRecursivo(Raiz, 'index.html', '', 3);
  PDF := BuscarArchivoRecursivo(Raiz, '', '.pdf', 4);

  if (PDF <> '') and
     (BuscarEjecutableEnPath('pdftoppm') <> '') then
  begin
    Visor := TFLXManualViewerForm.CreateManual(Application, PDF, Web);
    try
      if Visor.Inicializar then
        Visor.ShowModal
      else
        AbrirDocumentoExterno(PDF, Web);
    finally
      Visor.Free;
    end;
  end
  else
    AbrirDocumentoExterno(PDF, Web);
end;

end.
