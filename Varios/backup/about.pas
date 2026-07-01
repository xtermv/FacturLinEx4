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
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
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
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
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
  // Asignamos el valor de la versión del programa para mostrar en pantalla
  //-- JOSE -- LabelVersion.Caption := 'Desarrollo 2.5 - Rev.1/2015-20250402';
  LabelVersion.Caption := 'Desarrollo 4.0. - Rev.2601Beta2.0';

  // A por estos datos y otros como Nombre del producto, versión, etc
  // se podría acudir a un fichero
{ Por cambio en los e-mail
  MemoDesarrollo.Lines.Add('Nicolás López de Lerma Aymerich <nicolas@esdebian.org>');
  MemoDesarrollo.Lines.Add('Antonio Domínguez Santos           <adslinex@esdebian.org>');
  MemoDesarrollo.Lines.Add('José Belenguer Belenguer              <xterm@esdebian.org>');
  MemoDesarrollo.Lines.Add('Jaime Alvarez Ares                         <xaime@esdebian.org>');
  MemoDesarrollo.Lines.Add('Franciso Javier Perez Vidal              <f-javier@esdebian.org>');
  MemoDesarrollo.Lines.Add('Elmo Calatayud Chumbes              <ec.calatayud@gmail.com>');
  MemoDesarrollo.Lines.Add('David Gámiz Jiménez ');
  MemoDesarrollo.Lines.Add('Juan Manuel Martínez Gámiz');
}
  MemoDesarrollo.Lines.Add('Nicolás López de Lerma Aymerich ');
  MemoDesarrollo.Lines.Add('Antonio Domínguez Santos ');
  MemoDesarrollo.Lines.Add('José Belenguer Belenguer ');
  MemoDesarrollo.Lines.Add('Jaime Alvarez Ares ');
  MemoDesarrollo.Lines.Add('Franciso Javier Perez Vidal ');
  MemoDesarrollo.Lines.Add('Elmo Calatayud Chumbes ');
  MemoDesarrollo.Lines.Add('David Gámiz Jiménez ');
  MemoDesarrollo.Lines.Add('Juan Manuel Martínez Gámiz ');

  MemoAgradec.Lines.Add('Testeo y otros aportes: ');
  MemoAgradec.Lines.Add('  Eduardo Maldonado ');
  MemoAgradec.Lines.Add(' ');
  MemoAgradec.Lines.Add('Logos e infografías: ');
  MemoAgradec.Lines.Add('  María Domínguez Pozo ');
  MemoAgradec.Lines.add('  Santiago Fernández Manzi ');
  MemoAgradec.Lines.Add(' ');
  MemoAgradec.Lines.Add('Traducción: ');
  MemoAgradec.Lines.Add(' ');
  MemoAgradec.Lines.Add(' Continuamos el desarrollo de FacturLinEx 2 ');

  CargarLicense;
  //CargarIcono(RUTA) está por definir, con este metodo sería mucho más fácil cambiar el icono
  //CargarColaboradores(RUTA), lo mismo que el anterior
end;

procedure TAboutbox.FormShow(Sender: TObject);
begin
  Exit;
  self.Canvas.Brush.Color:=  clSkyblue;
  AboutPanel.Canvas.Brush.Color:= clSkyBlue;
  Notebook1.Brush.Color:= clSkyBlue;

end;

//Acude a donde se coloque el fichero license y lo carga en un memo
//Si tenemos algún fallo en la lectura, no impide el resto de la carga
procedure TAboutbox.CargarLicense;
var
  F: TextFile;
  Txt: String;
  RutaLicencia: String;
begin
  MemoLicencia.Font.Size:=7;
  RutaLicencia:=ExtractFilePath(ParamStr(0))+'License';
  {$IFDEF LINUX}
    if ExtractFilePath(ParamStr(0))='/usr/bin/' then RutaLicencia:='/usr/share/facturlinex2/License';
  {$ENDIF}
  if not FileExists(RutaLicencia) then exit;
  AssignFile(F, RutaLicencia);
  Reset(F);
  while not EOF(F) do
  begin
    Readln(F, Txt);
    MemoLicencia.Lines.Add(Txt);
  end;
  CloseFile(F);
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
