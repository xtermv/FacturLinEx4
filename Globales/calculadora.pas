{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2008,

  Nicolas Lopez de Lerma Aymerich
  PuntoDev GNU S.L. <info@puntodev.com>
  
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

Unit calculadora;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls
 // , Process //quitado por javi no se usa
  , Buttons, StdCtrls, EditBtn;

Type

  { TFCalculadora }

  TFCalculadora = Class(Tform)
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button16: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    EditNume: TEdit;
    LabelCalculadora: TLabel;
    PanelCalculadora: TPanel;

    procedure Button11Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);


    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);

  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormCalculadora2(titul: string; var texResult: string);
  
Var
  FCalculadora: TFCalculadora;
  Titulo, TextoResultado: string;

Implementation

uses
  Global
//  , Funciones//quitado por javi no se usa
  ;

//=============== Crea el formulario ================
procedure ShowFormCalculadora2(titul: string; var texResult: string);
begin
  titulo:=titul;
  TextoResultado:= texResult;
  with TFCalculadora.Create(Application) do
    begin
       ShowModal;
    end;
  texResult:=TextoResultado;
end;

Procedure TFCalculadora.Formcreate(Sender: Tobject);
Begin

   //---------------------Paneles y valores visibles por defecto

   PanelCalculadora.Visible:=True;
   LabelCalculadora.Caption:=titulo;
   EditNume.Text:='';
  
End;

Procedure TFCalculadora.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

// Teclas del teclado, je, je
procedure TFCalculadora.Button11Click(Sender: TObject);
begin
  EditNume.Text:=EditNume.Text+'0';
end;
procedure TFCalculadora.Button8Click(Sender: TObject);
begin
  EditNume.Text:=EditNume.Text+'1';
end;
procedure TFCalculadora.Button9Click(Sender: TObject);
begin
  EditNume.Text:=EditNume.Text+'2';
end;
procedure TFCalculadora.Button10Click(Sender: TObject);
begin
  EditNume.Text:=EditNume.Text+'3';
end;
procedure TFCalculadora.Button5Click(Sender: TObject);
begin
  EditNume.Text:=EditNume.Text+'4';
end;
procedure TFCalculadora.Button6Click(Sender: TObject);
begin
  EditNume.Text:=EditNume.Text+'5';
end;
procedure TFCalculadora.Button7Click(Sender: TObject);
begin
  EditNume.Text:=EditNume.Text+'6';
end;
procedure TFCalculadora.Button2Click(Sender: TObject);
begin
  EditNume.Text:=EditNume.Text+'7';
end;
procedure TFCalculadora.Button3Click(Sender: TObject);
begin
  EditNume.Text:=EditNume.Text+'8';
end;
procedure TFCalculadora.Button4Click(Sender: TObject);
begin
  EditNume.Text:=EditNume.Text+'9';
end;
procedure TFCalculadora.Button12Click(Sender: TObject);
begin
  EditNume.Text:=EditNume.Text+'.';
end;
procedure TFCalculadora.Button14Click(Sender: TObject);
begin
  EditNume.Text:=FloatToStr(StrToFloat(EditNume.Text)*-1)
end;
procedure TFCalculadora.Button13Click(Sender: TObject);
begin
  EditNume.Text:='';
end;

// Enter: devuelve los datos escritos y cierra
procedure TFCalculadora.Button16Click(Sender: TObject);
begin
  TextoResultado:=EditNume.Text;
  Close();
end;

Initialization
  {$I calculadora.lrs}

End.

