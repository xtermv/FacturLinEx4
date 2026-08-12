program FLXTools;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, uFLXToolsMain;

begin
  RequireDerivedFormResource := False;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TfrmFLXTools, frmFLXTools);
  Application.Run;
end.
