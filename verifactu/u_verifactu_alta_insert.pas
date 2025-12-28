unit uVerifactuAltaInsert;
{
  Paso 3 (micro-paso):
  ---------------------
  Unidad mínima para insertar una fila PENDIENTE en `verifactu_envios_alta`.
  No lee aún tus tablas `factuc*/factud*` (eso será el siguiente paso). Aquí
  solo estandarizamos **una función** para insertar en la cola de envíos a
  partir de datos que tú ya tengas en memoria (serie, número, totales, etc.).

  Requisitos:
  - Lazarus 4.2 + FPC 3.2.2
  - ZeosLib 8 (TZConnection activo)

  Qué hace:
  - Si no pasas EmisorNIF, lo toma de `verifactu_config` (1ª fila).
  - Inserta una fila en `verifactu_envios_alta` con estado 'PENDIENTE'.
  - Devuelve el id (BIGINT) autoincrement insertado.

  Próximo paso (separado):
  - Escribiremos un adaptador que lea tus `factuc*/factud*` y llame a esta
    función con los valores correctos **sin romper** tu app.
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, Variants, DateUtils;

/// Inserta una fila PENDIENTE en verifactu_envios_alta.
/// Si EmisorNIF está vacío, se lee de verifactu_config (campo emisor_nif, primera fila).
/// DesgloseIVA_JSON puede ir vacío por ahora (lo rellenaremos en el siguiente paso).
function VeriAltaInsertPending(
  Conn: TZConnection;
  const TiendaCod, Serie, Numero: string;
  const FechaEmision: TDateTime;         // fecha y hora (si la tienes). Se separa internamente.
  const EmisorNIF, ReceptorNIF, ReceptorNombre: string;
  const BaseTotal, CuotaIvaTotal, TotalFactura: Currency;
  const DesgloseIVA_JSON: string = ''
): QWord; // devuelve id autoincrement (BIGINT UNSIGNED)

implementation

function _GetEmisorNIFFromConfig(Conn: TZConnection): string;
var
  Q: TZQuery;
begin
  Result := '';
  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;
    Q.SQL.Text := 'SELECT emisor_nif FROM verifactu_config ORDER BY id LIMIT 1';
    Q.Open;
    if not Q.EOF then
      Result := Trim(Q.FieldByName('emisor_nif').AsString);
  finally
    Q.Free;
  end;
end;

function VeriAltaInsertPending(
  Conn: TZConnection;
  const TiendaCod, Serie, Numero: string;
  const FechaEmision: TDateTime;
  const EmisorNIF, ReceptorNIF, ReceptorNombre: string;
  const BaseTotal, CuotaIvaTotal, TotalFactura: Currency;
  const DesgloseIVA_JSON: string
): QWord;
var
  Q: TZQuery;
  Emisor: string;
  FechaSQL: TDateTime;
  HoraSQL: string;
begin
  if Conn = nil then
    raise Exception.Create('VeriAltaInsertPending: Conn es nil');
  if not Conn.Connected then
    raise Exception.Create('VeriAltaInsertPending: la conexión Zeos no está activa');

  // Emisor NIF: si no lo han pasado, lo tomamos de config
  Emisor := Trim(EmisorNIF);
  if Emisor = '' then
    Emisor := _GetEmisorNIFFromConfig(Conn);
  if Emisor = '' then
    raise Exception.Create('No se encuentra el NIF del emisor (pásalo o configúralo en verifactu_config).');

  // Partimos fecha/hora
  FechaSQL := DateOf(FechaEmision);
  HoraSQL  := FormatDateTime('hh:nn:ss', TimeOf(FechaEmision));

  Q := TZQuery.Create(nil);
  try
    Q.Connection := Conn;
    Q.SQL.Text :=
      'INSERT INTO verifactu_envios_alta '\
      + '(tienda_cod, serie, numero, fecha_emision, hora_emision, '\
      + ' emisor_nif, receptor_nif, receptor_nombre, '\
      + ' base_total, cuota_iva_total, total_factura, '\
      + ' desglose_iva_json, estado, intentos) '\
      + 'VALUES ('\
      + ' :tienda_cod, :serie, :numero, :fecha_emision, :hora_emision, '\
      + ' :emisor_nif, :receptor_nif, :receptor_nombre, '\
      + ' :base_total, :cuota_iva_total, :total_factura, '\
      + ' :desglose_iva_json, ''PENDIENTE'', 0)';

    Q.ParamByName('tienda_cod').AsString      := TiendaCod;
    Q.ParamByName('serie').AsString           := Serie;
    Q.ParamByName('numero').AsString          := Numero;
    Q.ParamByName('fecha_emision').AsDate     := FechaSQL;
    if (HoraSQL <> '00:00:00') then
      Q.ParamByName('hora_emision').AsString  := HoraSQL
    else
      Q.ParamByName('hora_emision').Clear; // NULL si no hay hora real

    Q.ParamByName('emisor_nif').AsString      := Emisor;

    if Trim(ReceptorNIF) <> '' then
      Q.ParamByName('receptor_nif').AsString  := Trim(ReceptorNIF)
    else
      Q.ParamByName('receptor_nif').Clear; // NULL si CF

    if Trim(ReceptorNombre) <> '' then
      Q.ParamByName('receptor_nombre').AsString := Trim(ReceptorNombre)
    else
      Q.ParamByName('receptor_nombre').Clear;

    // Totales
    Q.ParamByName('base_total').AsCurrency     := BaseTotal;
    Q.ParamByName('cuota_iva_total').AsCurrency:= CuotaIvaTotal;
    Q.ParamByName('total_factura').AsCurrency  := TotalFactura;

    // Desglose (JSON crudo por ahora)
    if Trim(DesgloseIVA_JSON) <> '' then
      Q.ParamByName('desglose_iva_json').AsString := Trim(DesgloseIVA_JSON)
    else
      Q.ParamByName('desglose_iva_json').Clear; // NULL por ahora

    Q.ExecSQL;

    // Recuperar el autoincrement (MySQL/MariaDB)
    Q.SQL.Text := 'SELECT LAST_INSERT_ID() AS nid';
    Q.Open;
    if not Q.EOF then
      Result := Q.FieldByName('nid').AsLargeInt
    else
      Result := 0;
  finally
    Q.Free;
  end;
end;

end.
