unit uFLXDialogs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Forms, Controls, Graphics, StdCtrls, Buttons, ExtCtrls;

function FLXInfo(const AMsg: string; const ATitle: string = 'FacturLinEx'): Integer;
function FLXWarning(const AMsg: string; const ATitle: string = 'FacturLinEx'): Integer;
function FLXError(const AMsg: string; const ATitle: string = 'FacturLinEx'): Integer;
function FLXConfirm(const AMsg: string; const ATitle: string = 'Confirmar'): Boolean;

implementation

function FLXInfo(const AMsg: string; const ATitle: string): Integer;
begin
  Result := MessageDlg(ATitle, AMsg, mtInformation, [mbOK], 0);
end;

function FLXWarning(const AMsg: string; const ATitle: string): Integer;
begin
  Result := MessageDlg(ATitle, AMsg, mtWarning, [mbOK], 0);
end;

function FLXError(const AMsg: string; const ATitle: string): Integer;
begin
  Result := MessageDlg(ATitle, AMsg, mtError, [mbOK], 0);
end;

function FLXConfirm(const AMsg: string; const ATitle: string): Boolean;
begin
  Result := MessageDlg(ATitle, AMsg, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

end.
