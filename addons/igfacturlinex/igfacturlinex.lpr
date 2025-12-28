program igfacturlinex;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, principal, LResources;

{$IFDEF WINDOWS}{$R igfacturlinex.rc}{$ENDIF}

begin
  {$I igfacturlinex.lrs}
  Application.Initialize;
  Application.CreateForm(TformPrincipal, formPrincipal);
  Application.Run;
end.

