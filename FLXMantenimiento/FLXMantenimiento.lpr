program FLXMantenimiento;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, uFLXMantenimientoMain;

begin
  RequireDerivedFormResource := False;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TfrmFLXMantenimiento, frmFLXMantenimiento);
  Application.Run;
end.
