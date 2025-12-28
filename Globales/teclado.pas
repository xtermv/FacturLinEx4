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

Unit teclado;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls
 // , Process // quitado por javi no usa ese unit
  , Buttons,
  StdCtrls, EditBtn;

Type

  { TFTeclado }

  TFTeclado = Class(Tform)
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Button28: TButton;
    Button29: TButton;
    Button30: TButton;
    Button31: TButton;
    Button32: TButton;
    Button33: TButton;
    Button34: TButton;
    Button35: TButton;
    Button36: TButton;
    Button37: TButton;
    Button38: TButton;
    Button39: TButton;
    Button40: TButton;
    Button41: TButton;
    Button42: TButton;
    Button43: TButton;
    Button44: TButton;
    Button45: TButton;
    Button46: TButton;
    Button47: TButton;
    Button48: TButton;
    Button49: TButton;
    Button50: TButton;
    Button51: TButton;
    Button53: TButton;
    Button54: TButton;
    Button55: TButton;
    Button56: TButton;
    Button57: TButton;
    Button58: TButton;
    Button59: TButton;
    Button60: TButton;
    Button61: TButton;
    Button62: TButton;
    EditTecla: TEdit;
    LabelTeclado: TLabel;

    Teclado: TPanel;

    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button33Click(Sender: TObject);
    procedure Button34Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button35Click(Sender: TObject);
    procedure Button30Click(Sender: TObject);
    procedure Button36Click(Sender: TObject);
    procedure Button37Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
    procedure Button38Click(Sender: TObject);
    procedure Button31Click(Sender: TObject);
    procedure Button39Click(Sender: TObject);
    procedure Button40Click(Sender: TObject);
    procedure Button41Click(Sender: TObject);
    procedure Button42Click(Sender: TObject);
    procedure Button43Click(Sender: TObject);
    procedure Button44Click(Sender: TObject);
    procedure Button45Click(Sender: TObject);
    procedure Button46Click(Sender: TObject);
    procedure Button47Click(Sender: TObject);
    procedure Button48Click(Sender: TObject);
    procedure Button49Click(Sender: TObject);
    procedure Button50Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button51Click(Sender: TObject);
    procedure Button53Click(Sender: TObject);
    procedure Button54Click(Sender: TObject);
    procedure Button55Click(Sender: TObject);
    procedure Button56Click(Sender: TObject);
    procedure Button57Click(Sender: TObject);
    procedure Button58Click(Sender: TObject);
    procedure Button60Click(Sender: TObject);
    procedure Button59Click(Sender: TObject);
    procedure Button61Click(Sender: TObject);
    procedure Button62Click(Sender: TObject);
    procedure Button32Click(Sender: TObject);


    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);

  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormTeclado2(titul: string; var texResult: string);
  
Var
  FTeclado: TFTeclado;
  Titulo, TextoResultado: string;

Implementation

uses
  Global;
  //, Funciones; // quitado por javi no usa ese unit

//=============== Crea el formulario ================
procedure ShowFormTeclado2(titul: string; var texResult: string);
begin
  titulo:=titul;
  TextoResultado:= texResult;
  with TFTeclado.Create(Application) do
    begin
       ShowModal;
    end;
  texResult:=TextoResultado;
end;

Procedure TFTeclado.Formcreate(Sender: Tobject);
Begin

   //---------------------Paneles y valores visibles por defecto

   Teclado.Visible:=True;
   LabelTeclado.Caption:=titulo;
   EditTecla.Text:='';
  
End;

Procedure TFTeclado.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

// Teclas del teclado, je, je
procedure TFTeclado.Button19Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'Q';
end;
procedure TFTeclado.Button20Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'W';
end;
procedure TFTeclado.Button21Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'E';
end;
procedure TFTeclado.Button33Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'R';
end;
procedure TFTeclado.Button34Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'T';
end;
procedure TFTeclado.Button22Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'Y';
end;
procedure TFTeclado.Button35Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'U';
end;
procedure TFTeclado.Button30Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'I';
end;
procedure TFTeclado.Button36Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'O';
end;
procedure TFTeclado.Button37Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'P';
end;
procedure TFTeclado.Button24Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'A';
end;
procedure TFTeclado.Button25Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'S';
end;
procedure TFTeclado.Button26Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'D';
end;
procedure TFTeclado.Button27Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'F';
end;
procedure TFTeclado.Button28Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'G';
end;
procedure TFTeclado.Button29Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'H';
end;
procedure TFTeclado.Button38Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'J';
end;
procedure TFTeclado.Button31Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'K';
end;
procedure TFTeclado.Button39Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'L';
end;
procedure TFTeclado.Button40Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'Ñ';
end;
procedure TFTeclado.Button41Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'Z';
end;
procedure TFTeclado.Button42Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'X';
end;
procedure TFTeclado.Button43Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'C';
end;
procedure TFTeclado.Button44Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'V';
end;
procedure TFTeclado.Button45Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'B';
end;
procedure TFTeclado.Button46Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'N';
end;
procedure TFTeclado.Button47Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'M';
end;
procedure TFTeclado.Button48Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+',';
end;
procedure TFTeclado.Button49Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'.';
end;
procedure TFTeclado.Button50Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'-';
end;
procedure TFTeclado.Button51Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+' ';
end;
procedure TFTeclado.Button23Click(Sender: TObject);
begin
 if Length(EditTecla.Text)=0 then exit;
 EditTecla.Text:=Copy(EditTecla.Text,1,Length(EditTecla.Text)-1);
end;
procedure TFTeclado.Button53Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'1';
end;
procedure TFTeclado.Button54Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'2';
end;
procedure TFTeclado.Button55Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'3';
end;
procedure TFTeclado.Button56Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'4';
end;
procedure TFTeclado.Button57Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'5';
end;
procedure TFTeclado.Button58Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'6';
end;
procedure TFTeclado.Button60Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'7';
end;
procedure TFTeclado.Button59Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'8';
end;
procedure TFTeclado.Button61Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'9';
end;
procedure TFTeclado.Button62Click(Sender: TObject);
begin
  EditTecla.Text:=EditTecla.Text+'0';
end;
// Enter: devuelve los datos escritos y cierra
procedure TFTeclado.Button32Click(Sender: TObject);
begin
  TextoResultado:=EditTecla.Text;
  Close();
end;

Initialization
  {$I teclado.lrs}

End.

