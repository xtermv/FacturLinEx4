unit about;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, LCLType,
  ExtCtrls, Buttons, StdCtrls, IniFiles, LResources, ComCtrls;

type
  TAboutbox = class(TForm)
    AboutPanel: TPanel;
    ButtonOk: TButton;
    Image1: TImage;
    ImageLogo: TImage;
    LabelPagProyecto: TLabel;
    MemoAgradec: TMemo;
    MemoDesarrollo: TMemo;
    MemoLicencia: TMemo;
    Notebook1: TPageControl;
    PanelBotonera: TPanel;
    LabelPaquete: TLabel;
    LabelVersion: TLabel;
    LabelAplicacion: TLabel;
    Logo: TTabSheet;
    Desarrollo: TTabSheet;
    Agradecimientos: TTabSheet;
    Licencia: TTabSheet;
    procedure ButtonOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    PnlCabecera: TPanel;
    LblTituloCabecera: TLabel;
    LblSubtituloCabecera: TLabel;
    Manifiesto: TTabSheet;
    Sistema: TTabSheet;
    VeriFactu: TTabSheet;
    Documentacion: TTabSheet;
    MemoManifiesto: TMemo;
    MemoSistema: TMemo;
    MemoVeriFactu: TMemo;
    MemoDocumentacion: TMemo;
    BtnDeclaracion: TButton;
    BtnManualVF: TButton;
    BtnManualUsuario: TButton;
    procedure AplicarDisenoModerno;
    procedure PrepararPaginasNuevas;
    procedure CargarPresentacion;
    procedure CargarSistema;
    procedure CargarVeriFactu;
    procedure CargarDocumentacion;
    procedure CargarManifiesto;
    procedure AbrirDocumento(Sender: TObject);
    function FechaEjecutable: String;
    function BuscarDocumento(const Nombres: array of String): String;
  public
    procedure CargarLicense;
  end;

procedure AboutShow();

var
  Aboutbox: TAboutbox;

implementation

uses
  Global, LCLIntf, uFLXVersionInfo;

procedure AboutShow();
begin
  with TAboutbox.Create(Application) do
    ShowModal;
end;

procedure TAboutbox.FormCreate(Sender: TObject);
begin
  Caption := 'Información del sistema - ' + FLXVersionDisplay;
  LabelAplicacion.Caption := FLX_PRODUCT_FULL_NAME;
  LabelVersion.Caption := 'Versión ' + FLXVersion;

  AplicarDisenoModerno;
  PrepararPaginasNuevas;
  CargarPresentacion;
  CargarSistema;
  CargarVeriFactu;
  CargarDocumentacion;

  MemoDesarrollo.Clear;
  MemoDesarrollo.Lines.Add('EQUIPO DE DESARROLLO Y COLABORADORES');
  MemoDesarrollo.Lines.Add('');
  MemoDesarrollo.Lines.Add('Nicolás López de Lerma Aymerich');
  MemoDesarrollo.Lines.Add('Antonio Domínguez Santos');
  MemoDesarrollo.Lines.Add('José Belenguer Belenguer');
  MemoDesarrollo.Lines.Add('Jaime Álvarez Ares');
  MemoDesarrollo.Lines.Add('Francisco Javier Pérez Vidal');
  MemoDesarrollo.Lines.Add('Elmo Calatayud Chumbes');
  MemoDesarrollo.Lines.Add('David Gámiz Jiménez');
  MemoDesarrollo.Lines.Add('Juan Manuel Martínez Gámiz');

  MemoAgradec.Clear;
  MemoAgradec.Lines.Add('TESTEO Y OTROS APORTES');
  MemoAgradec.Lines.Add('  Eduardo Maldonado');
  MemoAgradec.Lines.Add('');
  MemoAgradec.Lines.Add('LOGOS E INFOGRAFÍAS');
  MemoAgradec.Lines.Add('  María Domínguez Pozo');
  MemoAgradec.Lines.Add('  Santiago Fernández Manzi');
  MemoAgradec.Lines.Add('');
  MemoAgradec.Lines.Add('Gracias a todas las personas y negocios que continúan');
  MemoAgradec.Lines.Add('probando, utilizando y mejorando FacturLinEx.');

  CargarManifiesto;
  CargarLicense;
  Notebook1.ActivePage := Logo;
end;

procedure TAboutbox.AplicarDisenoModerno;
var
  L: TLabel;
begin
  BorderStyle := bsSizeable;
  Position := poScreenCenter;
  Width := 1080;
  Height := 700;
  Constraints.MinWidth := 920;
  Constraints.MinHeight := 600;
  Color := clWhite;

  PnlCabecera := TPanel.Create(Self);
  PnlCabecera.Parent := Self;
  PnlCabecera.Align := alTop;
  PnlCabecera.Height := 88;
  PnlCabecera.BevelOuter := bvNone;
  PnlCabecera.Color := clNavy;
  PnlCabecera.ParentBackground := False;
  PnlCabecera.Caption := '';

  LblTituloCabecera := TLabel.Create(Self);
  LblTituloCabecera.Parent := PnlCabecera;
  LblTituloCabecera.Left := 24;
  LblTituloCabecera.Top := 14;
  LblTituloCabecera.Caption := 'Información del sistema';
  LblTituloCabecera.ParentFont := False;
  LblTituloCabecera.Font.Name := 'Sans';
  LblTituloCabecera.Font.Height := -24;
  LblTituloCabecera.Font.Style := [fsBold];
  LblTituloCabecera.Font.Color := clWhite;

  LblSubtituloCabecera := TLabel.Create(Self);
  LblSubtituloCabecera.Parent := PnlCabecera;
  LblSubtituloCabecera.Left := 26;
  LblSubtituloCabecera.Top := 52;
  LblSubtituloCabecera.Caption := FLXVersionDisplay + ' · ' + FLX_RELEASE_STATUS;
  LblSubtituloCabecera.ParentFont := False;
  LblSubtituloCabecera.Font.Name := 'Sans';
  LblSubtituloCabecera.Font.Height := -13;
  LblSubtituloCabecera.Font.Color := clSilver;

  AboutPanel.Align := alLeft;
  AboutPanel.Width := 300;
  AboutPanel.BorderSpacing.Left := 12;
  AboutPanel.BorderSpacing.Top := 12;
  AboutPanel.BorderSpacing.Bottom := 12;
  AboutPanel.BevelOuter := bvNone;
  AboutPanel.BevelInner := bvNone;
  AboutPanel.Color := $00F3F6FA;
  AboutPanel.ParentBackground := False;
  AboutPanel.Caption := '';

  LabelPaquete.SetBounds(24, 20, 250, 24);
  LabelPaquete.Caption := 'Gestión LinEx';
  LabelPaquete.Font.Name := 'Sans';
  LabelPaquete.Font.Height := -16;
  LabelPaquete.Font.Style := [fsBold];
  LabelPaquete.Font.Color := clNavy;

  Image1.SetBounds(54, 62, 190, 112);
  Image1.Stretch := True;
  Image1.Proportional := True;

  LabelAplicacion.SetBounds(12, 198, 274, 34);
  LabelAplicacion.Font.Name := 'Sans';
  LabelAplicacion.Font.Height := -21;
  LabelAplicacion.Font.Style := [fsBold];
  LabelAplicacion.Font.Color := clNavy;

  LabelVersion.SetBounds(12, 239, 274, 24);
  LabelVersion.Font.Name := 'Sans';
  LabelVersion.Font.Height := -14;
  LabelVersion.Font.Style := [fsBold];
  LabelVersion.Font.Color := $00404040;

  LabelPagProyecto.SetBounds(20, 282, 260, 58);
  LabelPagProyecto.Alignment := taCenter;
  LabelPagProyecto.AutoSize := False;
  LabelPagProyecto.WordWrap := True;
  LabelPagProyecto.Caption := FLX_RELEASE_STATUS;
  LabelPagProyecto.Font.Name := 'Sans';
  LabelPagProyecto.Font.Height := -12;
  LabelPagProyecto.Font.Color := clNavy;

  PanelBotonera.Align := alBottom;
  PanelBotonera.Height := 58;
  PanelBotonera.BevelOuter := bvNone;
  PanelBotonera.Color := clWhite;
  PanelBotonera.ParentBackground := False;
  PanelBotonera.Caption := '';

  ButtonOk.Caption := 'Cerrar';
  ButtonOk.Width := 130;
  ButtonOk.Height := 34;
  ButtonOk.Top := 12;
  ButtonOk.Left := PanelBotonera.ClientWidth - ButtonOk.Width - 20;
  ButtonOk.Anchors := [akTop, akRight];
  ButtonOk.Default := True;

  Notebook1.Align := alClient;
  Notebook1.BorderSpacing.Left := 12;
  Notebook1.BorderSpacing.Top := 12;
  Notebook1.BorderSpacing.Right := 12;
  Notebook1.BorderSpacing.Bottom := 8;
  Notebook1.Font.Name := 'Sans';
  Notebook1.Font.Height := -13;

  Logo.Caption := 'Presentación';
  Desarrollo.Caption := 'Desarrollo';
  Agradecimientos.Caption := 'Agradecimientos';
  Licencia.Caption := 'GPL-3.0';

  ImageLogo.AutoSize := False;
  ImageLogo.SetBounds(190, 50, 220, 220);
  ImageLogo.Stretch := True;
  ImageLogo.Proportional := True;

  L := TLabel.Create(Self);
  L.Parent := Logo;
  L.Align := alBottom;
  L.Height := 105;
  L.AutoSize := False;
  L.Alignment := taCenter;
  L.Layout := tlCenter;
  L.WordWrap := True;
  L.Caption := FLXVersionDisplay + LineEnding +
    'Sistema de gestión comercial, TPV y facturación para GNU/Linux.' + LineEnding +
    'Software libre distribuido bajo licencia GNU GPL.';
  L.ParentFont := False;
  L.Font.Name := 'Sans';
  L.Font.Height := -15;
  L.Font.Color := $00404040;

  MemoDesarrollo.BorderStyle := bsNone;
  MemoDesarrollo.Color := clWhite;
  MemoDesarrollo.Font.Name := 'Sans';
  MemoDesarrollo.Font.Height := -14;
  MemoDesarrollo.ScrollBars := ssVertical;
  MemoDesarrollo.ReadOnly := True;

  MemoAgradec.BorderStyle := bsNone;
  MemoAgradec.Color := clWhite;
  MemoAgradec.Font.Name := 'Sans';
  MemoAgradec.Font.Height := -14;
  MemoAgradec.ScrollBars := ssVertical;
  MemoAgradec.ReadOnly := True;

  MemoLicencia.BorderStyle := bsNone;
  MemoLicencia.Color := clWhite;
  MemoLicencia.ScrollBars := ssAutoBoth;
  MemoLicencia.WordWrap := False;
  MemoLicencia.Font.Name := 'Monospace';
  MemoLicencia.Font.Height := -12;
end;

procedure TAboutbox.PrepararPaginasNuevas;
  function NuevaPagina(const Titulo: String; out Memo: TMemo): TTabSheet;
  begin
    Result := TTabSheet.Create(Self);
    Result.PageControl := Notebook1;
    Result.Caption := Titulo;
    Memo := TMemo.Create(Self);
    Memo.Parent := Result;
    Memo.Align := alClient;
    Memo.BorderStyle := bsNone;
    Memo.ReadOnly := True;
    Memo.ScrollBars := ssVertical;
    Memo.WordWrap := True;
    Memo.Color := clWhite;
    Memo.ParentFont := False;
    Memo.Font.Name := 'Sans';
    Memo.Font.Height := -14;
    Memo.BorderSpacing.Around := 14;
  end;

  procedure NuevoBoton(const Padre: TWinControl; const Texto: String;
    ATag, ALeft: Integer; out Boton: TButton);
  begin
    Boton := TButton.Create(Self);
    Boton.Parent := Padre;
    Boton.Caption := Texto;
    Boton.Tag := ATag;
    Boton.SetBounds(ALeft, 12, 190, 34);
    Boton.Anchors := [akLeft, akBottom];
    Boton.OnClick := @AbrirDocumento;
  end;

var
  PnlDocs: TPanel;
begin
  Sistema := NuevaPagina('Sistema', MemoSistema);
  VeriFactu := NuevaPagina('VeriFactu', MemoVeriFactu);
  Documentacion := NuevaPagina('Documentación', MemoDocumentacion);

  PnlDocs := TPanel.Create(Self);
  PnlDocs.Parent := Documentacion;
  PnlDocs.Align := alBottom;
  PnlDocs.Height := 58;
  PnlDocs.BevelOuter := bvNone;
  PnlDocs.Color := $00F3F6FA;
  PnlDocs.ParentBackground := False;
  PnlDocs.Caption := '';

  MemoDocumentacion.Align := alClient;
  NuevoBoton(PnlDocs, 'Declaración responsable', 1, 14, BtnDeclaracion);
  NuevoBoton(PnlDocs, 'Manual técnico VeriFactu', 2, 214, BtnManualVF);
  NuevoBoton(PnlDocs, 'Manual de usuario', 3, 414, BtnManualUsuario);

  Manifiesto := NuevaPagina('Manifiesto', MemoManifiesto);
end;

procedure TAboutbox.CargarPresentacion;
begin
  { Los controles principales ya se han preparado en AplicarDisenoModerno. }
end;

function TAboutbox.FechaEjecutable: String;
var
  Edad: LongInt;
  F: TDateTime;
begin
  Result := 'No disponible';
  Edad := FileAge(ParamStr(0));
  if Edad <> -1 then
  begin
    F := FileDateToDateTime(Edad);
    Result := FormatDateTime('dd/mm/yyyy hh:nn', F);
  end;
end;

procedure TAboutbox.CargarSistema;
begin
  MemoSistema.Clear;
  MemoSistema.Lines.Add('IDENTIFICACIÓN DE LA INSTALACIÓN');
  MemoSistema.Lines.Add('');
  MemoSistema.Lines.Add('Producto: ' + FLX_PRODUCT_FULL_NAME);
  MemoSistema.Lines.Add('Versión: ' + FLXVersion);
  MemoSistema.Lines.Add('Edición: ' + FLX_EDITION_SUFFIX);
  MemoSistema.Lines.Add('Identificador del sistema: ' + FLX_SYSTEM_ID);
  MemoSistema.Lines.Add('Identificador de compilación: ' + FLXOfficialBuildId);
  MemoSistema.Lines.Add('Estado: ' + FLX_RELEASE_STATUS);
  MemoSistema.Lines.Add('Fecha del ejecutable: ' + FechaEjecutable);
  MemoSistema.Lines.Add('Ruta del ejecutable: ' + ExpandFileName(ParamStr(0)));
  MemoSistema.Lines.Add('');
  MemoSistema.Lines.Add('ENTORNO TÉCNICO');
  MemoSistema.Lines.Add('');
  MemoSistema.Lines.Add('Sistema operativo: ' + {$I %FPCTARGETOS%});
  MemoSistema.Lines.Add('Arquitectura: ' + {$I %FPCTARGETCPU%});
  MemoSistema.Lines.Add('Compilador FPC: ' + {$I %FPCVERSION%});
  MemoSistema.Lines.Add('Versión del esquema BBDD: ' + FLX_SCHEMA_VERSION);
  MemoSistema.Lines.Add('Revisión del código fuente: ' + FLX_SOURCE_REVISION);
  MemoSistema.Lines.Add('');
  MemoSistema.Lines.Add('LICENCIA');
  MemoSistema.Lines.Add(FLX_LICENSE_NAME);
end;

procedure TAboutbox.CargarVeriFactu;
begin
  MemoVeriFactu.Clear;
  MemoVeriFactu.Lines.Add('ESTADO VERIFACTU');
  MemoVeriFactu.Lines.Add('');
  MemoVeriFactu.Lines.Add('Estado de esta versión: ' + FLX_RELEASE_STATUS);
  MemoVeriFactu.Lines.Add('Identificador del sistema: ' + FLX_SYSTEM_ID);
  MemoVeriFactu.Lines.Add('Versión SIF declarada: ' + FLXVersion);
  MemoVeriFactu.Lines.Add('Modalidad productiva: VERI*FACTU');
  MemoVeriFactu.Lines.Add('Multiobligado tributario: NO');
  MemoVeriFactu.Lines.Add('Productor: ' + FLX_PRODUCER_NAME);
  MemoVeriFactu.Lines.Add('Identificación fiscal del productor: ' + FLX_PRODUCER_ID);
  MemoVeriFactu.Lines.Add('Dirección del productor: ' + FLX_PRODUCER_ADDRESS);
  MemoVeriFactu.Lines.Add('');
  MemoVeriFactu.Lines.Add('DECLARACIÓN RESPONSABLE');
  MemoVeriFactu.Lines.Add('');
  MemoVeriFactu.Lines.Add('La versión 4.2.6J dispone de Declaración Responsable definitiva.');
  MemoVeriFactu.Lines.Add('Fecha de suscripción: 11/08/2026 · Picassent, España.');
  MemoVeriFactu.Lines.Add('Integridad HASH y encadenamiento global: verificados.');
  MemoVeriFactu.Lines.Add('F1, F2 y rectificativas implementadas: verificadas.');
  MemoVeriFactu.Lines.Add('');
  MemoVeriFactu.Lines.Add('La declaración cubre exclusivamente esta versión y este productor.');
  MemoVeriFactu.Lines.Add('Las modificaciones o recompilaciones realizadas por terceros no');
  MemoVeriFactu.Lines.Add('quedan amparadas por esta declaración.');
end;

procedure TAboutbox.CargarDocumentacion;
begin
  MemoDocumentacion.Clear;
  MemoDocumentacion.Lines.Add('DOCUMENTACIÓN DE LA VERSIÓN');
  MemoDocumentacion.Lines.Add('');
  MemoDocumentacion.Lines.Add('Desde esta sección se podrá acceder a:');
  MemoDocumentacion.Lines.Add('');
  MemoDocumentacion.Lines.Add('• Declaración responsable de la versión instalada.');
  MemoDocumentacion.Lines.Add('• Manual VeriFactu y gestión de incidencias.');
  MemoDocumentacion.Lines.Add('• Manual de uso de FacturLinEx.');
  MemoDocumentacion.Lines.Add('• Información técnica y de compilación.');
  MemoDocumentacion.Lines.Add('• Licencia y componentes de terceros.');
  MemoDocumentacion.Lines.Add('');
  MemoDocumentacion.Lines.Add('Documentación VERI*FACTU definitiva de la versión 4.2.6J.');
  MemoDocumentacion.Lines.Add('Los botones buscan primero la documentación instalada y también');
  MemoDocumentacion.Lines.Add('el árbol de desarrollo Documentacion/VeriFactu.');
  MemoDocumentacion.Lines.Add('');
  MemoDocumentacion.Lines.Add('Declaración responsable:');
  MemoDocumentacion.Lines.Add('Documentacion/VeriFactu/DeclaracionResponsable/');
  MemoDocumentacion.Lines.Add('Manual técnico:');
  MemoDocumentacion.Lines.Add('Documentacion/VeriFactu/ManualTecnico/');
end;

function TAboutbox.BuscarDocumento(const Nombres: array of String): String;
var
  I, J: Integer;
  BaseExe, RaizProyecto: String;
  Bases: array[0..11] of String;
begin
  Result := '';
  BaseExe := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  RaizProyecto := IncludeTrailingPathDelimiter(
    ExpandFileName(BaseExe + '..' + DirectorySeparator));

  { Desarrollo: junto al ejecutable, documentacion antigua y estructura 4.2.6J. }
  Bases[0] := BaseExe;
  Bases[1] := BaseExe + 'documentacion' + DirectorySeparator;
  Bases[2] := BaseExe + 'Documentacion' + DirectorySeparator + 'VeriFactu' + DirectorySeparator;
  Bases[3] := RaizProyecto + 'Documentacion' + DirectorySeparator;
  Bases[4] := RaizProyecto + 'Documentacion' + DirectorySeparator + 'VeriFactu' + DirectorySeparator;
  Bases[5] := RaizProyecto + 'Documentacion' + DirectorySeparator + 'VeriFactu' + DirectorySeparator +
    'DeclaracionResponsable' + DirectorySeparator;
  Bases[6] := RaizProyecto + 'Documentacion' + DirectorySeparator + 'VeriFactu' + DirectorySeparator +
    'ManualTecnico' + DirectorySeparator;

  { Instalación final. }
  Bases[7] := '/usr/share/facturlinex2/Documentacion/';
  Bases[8] := '/usr/share/facturlinex2/Documentacion/VeriFactu/';
  Bases[9] := '/usr/share/facturlinex2/Documentacion/VeriFactu/DeclaracionResponsable/';
  Bases[10] := '/usr/share/facturlinex2/Documentacion/VeriFactu/ManualTecnico/';
  Bases[11] := '/usr/share/facturlinex2/documentacion/';  // compatibilidad histórica

  for I := Low(Nombres) to High(Nombres) do
    for J := Low(Bases) to High(Bases) do
      if FileExists(Bases[J] + Nombres[I]) then
        Exit(Bases[J] + Nombres[I]);
end;

procedure TAboutbox.AbrirDocumento(Sender: TObject);
var
  Ruta: String;
begin
  Ruta := '';
  case TButton(Sender).Tag of
    1: Ruta := BuscarDocumento([
      'Declaracion_Responsable_FacturLinEx_' + FLXVersion + '_FINAL.pdf',
      'Declaracion_Responsable_FacturLinEx_' + FLXVersion + '.pdf',
      'Declaracion_Responsable_FacturLinEx_' + FLXVersion + '_BORRADOR.pdf',
      'declaracion_responsable.pdf',
      'Declaracion_Responsable_FacturLinEx.pdf']);
    2: Ruta := BuscarDocumento([
      'Manual_Tecnico_VERIFACTU_FacturLinEx_' + FLXVersion + '_FINAL.pdf',
      'Manual_Tecnico_VERIFACTU_FacturLinEx_' + FLXVersion + '.pdf',
      'Manual_Tecnico_VERIFACTU_FacturLinEx_' + FLXVersion + '_BORRADOR.pdf',
      'manual_verifactu.pdf',
      'Manual_Verifactu_FacturLinEx.pdf']);
    3: Ruta := BuscarDocumento(['manual_facturlinex.pdf',
      'Manual_FacturLinEx.pdf']);
  end;

  if Ruta = '' then
  begin
    MessageDlg('Documento no localizado',
      'No se ha encontrado el documento correspondiente a FacturLinEx ' +
      FLXVersion + '.' + LineEnding +
      'Compruebe la carpeta Documentacion/VeriFactu de la instalación.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  if not OpenDocument(Ruta) then
    MessageDlg('No se pudo abrir el documento', Ruta, mtError, [mbOK], 0);
end;

procedure TAboutbox.CargarManifiesto;
begin
  if not Assigned(MemoManifiesto) then Exit;
  MemoManifiesto.Clear;
  MemoManifiesto.Lines.Add('MANIFIESTO DEL PROYECTO FACTURLINEX');
  MemoManifiesto.Lines.Add('');
  MemoManifiesto.Lines.Add('FacturLinEx nace y continúa como una herramienta práctica para la gestión diaria de comercios y profesionales.');
  MemoManifiesto.Lines.Add('');
  MemoManifiesto.Lines.Add('1. Software libre. El conocimiento y las mejoras deben poder estudiarse, compartirse y continuar en el tiempo.');
  MemoManifiesto.Lines.Add('');
  MemoManifiesto.Lines.Add('2. Estabilidad. Cada mejora debe preservar lo que ya funciona y reducir riesgos en el trabajo diario.');
  MemoManifiesto.Lines.Add('');
  MemoManifiesto.Lines.Add('3. Utilidad real. Las funciones se diseñan para ahorrar tiempo, aportar información y resolver necesidades concretas.');
  MemoManifiesto.Lines.Add('');
  MemoManifiesto.Lines.Add('4. Control de los datos. La información pertenece al usuario y debe permanecer accesible, portable y protegida.');
  MemoManifiesto.Lines.Add('');
  MemoManifiesto.Lines.Add('5. Evolución compatible. FacturLinEx debe modernizarse sin obligar a abandonar instalaciones, datos o formas de trabajo válidas.');
  MemoManifiesto.Lines.Add('');
  MemoManifiesto.Lines.Add('6. Comunidad y continuidad. Cada prueba, corrección, traducción, idea y aportación ayuda a mantener vivo el proyecto.');
  MemoManifiesto.Lines.Add('');
  MemoManifiesto.Lines.Add(FLXVersionDisplay + ' mantiene estos principios y continúa su desarrollo bajo la licencia GNU GPL versión 3.');
end;

procedure TAboutbox.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ButtonOkClick(ButtonOk);
  end;
end;

procedure TAboutbox.FormShow(Sender: TObject);
begin
  Notebook1.ActivePage := Logo;
end;

procedure TAboutbox.CargarLicense;
var
  Rutas: TStringList;
  I: Integer;
  RutaLicencia: String;
begin
  MemoLicencia.Clear;
  MemoLicencia.Font.Name := 'Monospace';
  MemoLicencia.Font.Size := 9;

  Rutas := TStringList.Create;
  try
    Rutas.Add(ExtractFilePath(ParamStr(0)) + 'GPL-3.0.txt');
    Rutas.Add(ExtractFilePath(ParamStr(0)) + 'LICENSE');
    Rutas.Add(ExtractFilePath(ParamStr(0)) + 'License');
    Rutas.Add(ExtractFilePath(ParamStr(0)) + 'COPYING');
    {$IFDEF LINUX}
    Rutas.Add('/usr/share/facturlinex2/GPL-3.0.txt');
    Rutas.Add('/usr/share/facturlinex2/License');
    Rutas.Add('/usr/share/common-licenses/GPL-3');
    {$ENDIF}

    RutaLicencia := '';
    for I := 0 to Rutas.Count - 1 do
      if FileExists(Rutas[I]) then
      begin
        RutaLicencia := Rutas[I];
        Break;
      end;

    if RutaLicencia <> '' then
    begin
      try
        MemoLicencia.Lines.LoadFromFile(RutaLicencia);
        Exit;
      except
      end;
    end;

    MemoLicencia.Lines.Add('GNU GENERAL PUBLIC LICENSE');
    MemoLicencia.Lines.Add('Version 3, 29 June 2007');
    MemoLicencia.Lines.Add('');
    MemoLicencia.Lines.Add('FacturLinEx es software libre: puede redistribuirlo y/o modificarlo');
    MemoLicencia.Lines.Add('bajo los términos de la GNU General Public License versión 3.');
    MemoLicencia.Lines.Add('');
    MemoLicencia.Lines.Add('Este programa se distribuye SIN GARANTÍA ALGUNA.');
  finally
    Rutas.Free;
  end;
end;

procedure TAboutbox.ButtonOkClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutbox.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

initialization
  {$i about.lrs}

end.
