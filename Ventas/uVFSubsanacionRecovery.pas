unit uVFSubsanacionRecovery;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, ZConnection, ZDataset;

function VF_RecoverSubsanacionesInProcess(AConn: TZConnection;
  out ARecovered: Integer; out AError: string): Boolean;

implementation

function VF_RecoverSubsanacionesInProcess(AConn: TZConnection;
  out ARecovered: Integer; out AError: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  ARecovered := 0;
  AError := '';

  if (AConn = nil) or (not AConn.Connected) then
  begin
    AError := 'No existe una conexión activa con MariaDB.';
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;
    Q.SQL.Text :=
      'UPDATE verifactu_queue SET estado=''PENDIENTE'',token=NULL,' +
      'claimed_by=NULL,claimed_at=NULL,claimed_until=NULL,updated_at=NOW() ' +
      'WHERE origen=''SUBSANACION'' ' +
      'AND COALESCE(registro_uid,''ORIG'')<>''ORIG'' ' +
      'AND estado=''EN_PROCESO''';
    Q.ExecSQL;
    ARecovered := Q.RowsAffected;
    Result := True;
  except
    on E: Exception do
      AError := E.Message;
  end;
  Q.Free;
end;

end.
