unit Mensajes;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls;

type

  { TFMensajes }

  TFMensajes = class(TForm)
    Image1: TImage;
    lbTitulo: TLabel;
    lbMensaje: TLabel;
    pnPrincipal: TPanel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);

  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FMensajes: TFMensajes;


implementation

{ TFMensajes }


{ TFMensajes }

procedure TFMensajes.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FreeAndNil(FMensajes);
end;


initialization
  {$I mensajes.lrs}

end.

