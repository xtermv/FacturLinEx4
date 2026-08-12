unit uFLXClienteCoste;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, ZDataset, ZAbstractConnection;

function FLX_AsegurarCampoClienteCoste(
  AConnection: TZAbstractConnection; out AError: string): Boolean;

function FLX_ClienteUsaPrecioCoste(ADataSet: TDataSet): Boolean;

implementation

var
  GComprobado: Boolean = False;
  GDisponible: Boolean = False;

function FLX_AsegurarCampoClienteCoste(
  AConnection: TZAbstractConnection; out AError: string): Boolean;
var
  Q: TZQuery;
begin
  AError := '';

  if GComprobado then
  begin
    Result := GDisponible;
    Exit;
  end;

  if not Assigned(AConnection) then
  begin
    AError := 'No hay conexión disponible para comprobar clientes.C57.';
    Result := False;
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConnection;

    try
      Q.SQL.Text :=
        'SELECT COUNT(*) AS N ' +
        'FROM INFORMATION_SCHEMA.COLUMNS ' +
        'WHERE TABLE_SCHEMA=DATABASE() ' +
        'AND TABLE_NAME=''clientes'' ' +
        'AND COLUMN_NAME=''C57''';
      Q.Open;

      if Q.FieldByName('N').AsInteger = 0 then
      begin
        Q.Close;
        Q.SQL.Text :=
          'ALTER TABLE `clientes` ' +
          'ADD COLUMN `C57` TINYINT(1) NOT NULL DEFAULT 0';
        Q.ExecSQL;
      end;

      Q.Close;
      Q.SQL.Text :=
        'SELECT COUNT(*) AS N ' +
        'FROM INFORMATION_SCHEMA.COLUMNS ' +
        'WHERE TABLE_SCHEMA=DATABASE() ' +
        'AND TABLE_NAME=''clientes'' ' +
        'AND COLUMN_NAME=''C57''';
      Q.Open;

      GDisponible := Q.FieldByName('N').AsInteger > 0;
      GComprobado := GDisponible;
      Result := GDisponible;

      if not Result then
        AError := 'No se pudo crear o localizar clientes.C57.';
    except
      on E: Exception do
      begin
        AError := E.Message;
        GDisponible := False;
        GComprobado := False;
        Result := False;
      end;
    end;
  finally
    Q.Free;
  end;
end;

function FLX_ClienteUsaPrecioCoste(ADataSet: TDataSet): Boolean;
var
  Campo: TField;
begin
  Result := False;

  if (not Assigned(ADataSet)) or
     (not ADataSet.Active) or
     ADataSet.IsEmpty then
    Exit;

  Campo := ADataSet.FindField('C57');
  if Assigned(Campo) then
    Result := Campo.AsBoolean;
end;

end.
