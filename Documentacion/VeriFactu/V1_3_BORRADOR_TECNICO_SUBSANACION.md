# VeriFactu V1.3 — Borrador técnico de subsanación

## Decisión de arquitectura

No se inserta todavía un segundo registro en `verifactu_queue`.

La cola estable actual protege la idempotencia mediante la identificación de
serie/número. Una subsanación hace referencia a la misma factura, por lo que
forzarla ahora dentro de esa cola podría romper el comportamiento ya validado.

V1.3 crea por tanto un borrador técnico separado e inmutable dentro de
`verifactu_subsanaciones`.

## Qué guarda el borrador

- Identidad de la factura original.
- `Subsanacion`.
- `RechazoPrevio`.
- Copia de `payload_json` original.
- Hash del registro original.
- Último registro generado por el SIF en el momento del borrador:
  - queue id,
  - serie,
  - número,
  - fecha,
  - huella.
- Fecha de creación del borrador.

## Encadenamiento

La AEAT indica que un registro de alta de subsanación se trata, a efectos de
trazabilidad, como un registro nuevo más y debe encadenarse con el anterior
registro generado por el SIF.

El ancla guardada por V1.3 es informativa/preparatoria. Antes de generar
definitivamente el nuevo registro deberá volver a obtenerse el último registro,
porque mientras el borrador está pendiente pueden haberse generado nuevas
facturas.

## Seguridad

V1.3:

- NO modifica el registro original.
- NO modifica `hash`, `hash_prev`, `canonical` ni `payload_json` de la cola.
- NO envía nada.
- NO reserva todavía una posición definitiva en la cadena.
- NO altera el generador normal de ventas.

## Uso

1. Abrir `Control de subsanaciones`.
2. Seleccionar la factura.
3. `Preparar subsanación`.
4. Revisar que no procede rectificativa/anulación.
5. Pulsar `Generar borrador técnico`.
6. El estado pasa a `BORRADOR_GENERADO`.

## Siguiente paso V1.4

V1.4 será la integración con el generador VeriFactu existente:

1. volver a obtener el último registro de la cadena;
2. generar el registro de alta de subsanación con los datos correctos;
3. usar el mismo algoritmo/canonicalización que los registros ordinarios;
4. calcular la nueva huella;
5. enviarlo por el mismo transporte SOAP;
6. registrar la respuesta y vincularla con `verifactu_subsanaciones`.
