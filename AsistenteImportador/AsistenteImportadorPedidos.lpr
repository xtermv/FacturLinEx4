program AsistenteImportadorPedidos;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Menu, articulos, funciones, global, busquedas,
  zcomponent, gestionar, importar, importar2;

{$R *.res}

begin
  //{$I AsistenteImportadorPedidos.lrs}
  Application.Title:='Importador para Pedidos';
  Application.Initialize;
  Application.CreateForm(TFmenu, Fmenu);
  Application.Run;
end.

