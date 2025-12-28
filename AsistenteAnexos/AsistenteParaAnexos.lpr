program AsistenteParaAnexos;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, AsistenteAnexos, funciones, global, LResources, zcomponent
  { you can add units after this };

{$IFDEF WINDOWS}{$R AsistenteParaAnexos.rc}{$ENDIF}

begin
  {$I AsistenteParaAnexos.lrs}
  Application.Initialize;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TFormAsistenteAnexos, FormAsistenteAnexos);
  Application.Run;
end.

