{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010,  Nicolas Lopez de Lerma Aymerich

  PuntoDev GNU S.L. <info@puntodev.com>

  Collaborators:
                 Antonio Domínguez Santos (adslinex)

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit about;

{$mode objfpc}{$H+}

interface
uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, LCLType,
  ExtCtrls, Buttons, StdCtrls, IniFiles, LResources, ComCtrls;
type

  { TAboutbox }

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
    MemoManifiesto: TMemo;
    procedure AplicarDisenoModerno;
    procedure CargarManifiesto;
  public
    { Public declarations }
    procedure CargarLicense;
  end;

  procedure AboutShow();

var
  Aboutbox: TAboutbox;

implementation

uses
  Global;

procedure AboutShow();
begin
  with TAboutbox.Create(Application) do
  begin
    ShowModal;
  end;
end;

procedure TAboutbox.FormCreate(Sender: TObject);
begin
  Caption := 'Acerca de FacturLinEx 4.2.2';
  LabelAplicacion.Caption := 'FacturLinEx Veri*Factu';
  LabelVersion.Caption := 'Versión 4.2.2';

  AplicarDisenoModerno;

  MemoDesarrollo.Clear;
  MemoDesarrollo.Lines.Add('Equipo de desarrollo y colaboradores');
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
  MemoAgradec.Lines.Add('Testeo y otros aportes');
  MemoAgradec.Lines.Add('  Eduardo Maldonado');
  MemoAgradec.Lines.Add('');
  MemoAgradec.Lines.Add('Logos e infografías');
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
  Width := 1020;
  Height := 640;
  Constraints.MinWidth := 900;
  Constraints.MinHeight := 560;
  Color := clWhite;

  PnlCabecera := TPanel.Create(Self);
  PnlCabecera.Parent := Self;
  PnlCabecera.Align := alTop;
  PnlCabecera.Height := 88;
  PnlCabecera.BevelOuter := bvNone;
  PnlCabecera.Color := clNavy;
  PnlCabecera.ParentBackground := False;

  LblTituloCabecera := TLabel.Create(Self);
  LblTituloCabecera.Parent := PnlCabecera;
  LblTituloCabecera.Left := 24;
  LblTituloCabecera.Top := 16;
  LblTituloCabecera.Caption := 'Acerca de FacturLinEx';
  LblTituloCabecera.ParentFont := False;
  LblTituloCabecera.Font.Name := 'Sans';
  LblTituloCabecera.Font.Height := -24;
  LblTituloCabecera.Font.Style := [fsBold];
  LblTituloCabecera.Font.Color := clWhite;

  LblSubtituloCabecera := TLabel.Create(Self);
  LblSubtituloCabecera.Parent := PnlCabecera;
  LblSubtituloCabecera.Left := 26;
  LblSubtituloCabecera.Top := 52;
  LblSubtituloCabecera.Caption := 'Sistema de gestión, TPV y facturación · Software libre GPL-3.0';
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

  LabelPagProyecto.SetBounds(20, 284, 260, 38);
  LabelPagProyecto.Alignment := taCenter;
  LabelPagProyecto.AutoSize := False;
  LabelPagProyecto.WordWrap := True;
  LabelPagProyecto.Font.Name := 'Sans';
  LabelPagProyecto.Font.Height := -12;
  LabelPagProyecto.Font.Color := clNavy;

  PanelBotonera.Align := alBottom;
  PanelBotonera.Height := 58;
  PanelBotonera.BevelOuter := bvNone;
  PanelBotonera.Color := clWhite;
  PanelBotonera.ParentBackground := False;

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
  ImageLogo.SetBounds(190, 52, 220, 220);
  ImageLogo.Stretch := True;
  ImageLogo.Proportional := True;

  L := TLabel.Create(Self);
  L.Parent := Logo;
  L.Left := 36;
  L.Top := 298;
  L.Width := 520;
  L.Height := 56;
  L.AutoSize := False;
  L.Alignment := taCenter;
  L.WordWrap := True;
  L.Caption := 'FacturLinEx 4.2.2 · Gestión comercial y facturación para GNU/Linux, desarrollada y distribuida como software libre.';
  L.ParentFont := False;
  L.Font.Name := 'Sans';
  L.Font.Height := -15;
  L.Font.Color := $00404040;
  L.Anchors := [akLeft, akTop, akRight];

  MemoDesarrollo.BorderStyle := bsNone;
  MemoDesarrollo.Color := clWhite;
  MemoDesarrollo.Font.Name := 'Sans';
  MemoDesarrollo.Font.Height := -14;
  MemoDesarrollo.ScrollBars := ssVertical;

  MemoAgradec.BorderStyle := bsNone;
  MemoAgradec.Color := clWhite;
  MemoAgradec.Font.Name := 'Sans';
  MemoAgradec.Font.Height := -14;
  MemoAgradec.ScrollBars := ssVertical;

  Manifiesto := TTabSheet.Create(Self);
  Manifiesto.PageControl := Notebook1;
  Manifiesto.Caption := 'Manifiesto';
  Manifiesto.PageIndex := Licencia.PageIndex;

  MemoManifiesto := TMemo.Create(Self);
  MemoManifiesto.Parent := Manifiesto;
  MemoManifiesto.Align := alClient;
  MemoManifiesto.BorderStyle := bsNone;
  MemoManifiesto.Color := clWhite;
  MemoManifiesto.ReadOnly := True;
  MemoManifiesto.ScrollBars := ssVertical;
  MemoManifiesto.ParentFont := False;
  MemoManifiesto.Font.Name := 'Sans';
  MemoManifiesto.Font.Height := -14;

  MemoLicencia.BorderStyle := bsNone;
  MemoLicencia.Color := clWhite;
  MemoLicencia.ScrollBars := ssAutoBoth;
  MemoLicencia.WordWrap := False;
  MemoLicencia.Font.Name := 'Monospace';
  MemoLicencia.Font.Height := -12;
end;

procedure TAboutbox.CargarManifiesto;
begin
  if not Assigned(MemoManifiesto) then Exit;
  MemoManifiesto.Clear;
  MemoManifiesto.Lines.Add('MANIFIESTO DEL PROYECTO FACTURLINEX');
  MemoManifiesto.Lines.Add('');
  MemoManifiesto.Lines.Add('FacturLinEx nace y continúa como una herramienta práctica para la gestión diaria de comercios y profesionales.');
  MemoManifiesto.Lines.Add('');
  MemoManifiesto.Lines.Add('Nuestros principios:');
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
  MemoManifiesto.Lines.Add('FacturLinEx 4.2.2 mantiene estos principios y continúa su desarrollo bajo la licencia GNU GPL versión 3.');
end;

procedure TAboutbox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
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

//Acude a donde se coloque el fichero license y lo carga en un memo
//Si tenemos algún fallo en la lectura, no impide el resto de la carga
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
        { Si la lectura falla, se muestra el aviso incorporado. }
      end;
    end;

    MemoLicencia.Lines.Add('GNU GENERAL PUBLIC LICENSE');
    MemoLicencia.Lines.Add('Version 3, 29 June 2007');
    MemoLicencia.Lines.Add('');
    MemoLicencia.Lines.Add('FacturLinEx es software libre: puede redistribuirlo y/o modificarlo');
    MemoLicencia.Lines.Add('bajo los términos de la GNU General Public License versión 3,');
    MemoLicencia.Lines.Add('publicada por la Free Software Foundation.');
    MemoLicencia.Lines.Add('');
    MemoLicencia.Lines.Add('Este programa se distribuye con la esperanza de que sea útil,');
    MemoLicencia.Lines.Add('pero SIN GARANTÍA ALGUNA; ni siquiera la garantía implícita de');
    MemoLicencia.Lines.Add('COMERCIABILIDAD o IDONEIDAD PARA UN PROPÓSITO PARTICULAR.');
    MemoLicencia.Lines.Add('');
    MemoLicencia.Lines.Add('Instale el fichero GPL-3.0.txt junto al ejecutable o utilice');
    MemoLicencia.Lines.Add('/usr/share/common-licenses/GPL-3 para consultar el texto completo.');
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
