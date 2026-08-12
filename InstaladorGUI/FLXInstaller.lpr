program FLXInstaller;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, uFLXInstallerMain;


begin
  RequireDerivedFormResource := False;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TfrmFLXInstaller, frmFLXInstaller);
  Application.Run;
end.
