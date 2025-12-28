program FacturActBBDD;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, LResources, ActualizaBBDD, Global, Funciones, fn_mysql, zcomponent;

{$IFDEF WINDOWS}{$R FacturActBBDD.rc}{$ENDIF}

begin
  {$I FacturActBBDD.lrs}
  Application.Initialize;
  Application.CreateForm(TFActualizaBBDD, FActualizaBBDD);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.

