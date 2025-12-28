unit uVF_Integration;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, ZConnection, uVF_Sender;

type
  TVFUpdateStatusBarProc = procedure of object;
  TVFGetQueuePendingFunc = function(out Pending: Integer): Boolean of object;

procedure VF_SetConnection(AConn: TZConnection); overload;
procedure VF_SetConnectionObj(AConn: TObject); overload;

procedure VF_BindUI(AUpdateStatusBar: TVFUpdateStatusBarProc;
                    AGetQueuePending: TVFGetQueuePendingFunc);

procedure VF_TimerStep;

implementation

var
  GConnObj: TObject = nil; // almacenamos como TObject para aceptar tipos base/abstractos
  GUpdateStatusBar: TVFUpdateStatusBarProc = nil;
  GGetQueuePending: TVFGetQueuePendingFunc = nil;

procedure VF_StatusAdapter(const Step, Detail: string; const Level: Integer);
begin
  try
    if Assigned(GUpdateStatusBar) then
      GUpdateStatusBar();
  except
  end;
end;

procedure VF_SetConnection(AConn: TZConnection);
begin
  GConnObj := AConn;
end;

procedure VF_SetConnectionObj(AConn: TObject);
begin
  GConnObj := AConn; // puede ser TZConnection o una clase base; en runtime comprobamos
end;

procedure VF_BindUI(AUpdateStatusBar: TVFUpdateStatusBarProc;
                    AGetQueuePending: TVFGetQueuePendingFunc);
begin
  GUpdateStatusBar := AUpdateStatusBar;
  GGetQueuePending := AGetQueuePending;
end;

procedure VF_TimerStep;
var
  pending: Integer;
  R: TVFSendResult;
begin
  // 1) Refrescar barra
  try
    if Assigned(GUpdateStatusBar) then
      GUpdateStatusBar();
  except
  end;

  // 2) Pendientes
  pending := 0;
  try
    if Assigned(GGetQueuePending) then
      GGetQueuePending(pending);
  except
    pending := 0;
  end;

  // 3) Enviar 1 si procede
  if (pending > 0) and Assigned(GConnObj) then
  begin
    if GConnObj is TZConnection then
    begin
      R := VF_SendNextPending_LocalREST(TZConnection(GConnObj), @VF_StatusAdapter);
      // refresco posterior
      try
        if Assigned(GUpdateStatusBar) then
          GUpdateStatusBar();
      except
      end;
    end
    else
    begin
      // No es TZConnection en tiempo de ejecución; no enviamos para evitar crash.
    end;
  end;
end;

end.
