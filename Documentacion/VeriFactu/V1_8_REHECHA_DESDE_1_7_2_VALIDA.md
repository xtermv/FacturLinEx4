# VeriFactu V1.8 — rehecha desde V1.7.2 válida

Esta revisión NO deriva de la V1.8 anterior descartada.

Base utilizada:
- V1.7.2 JSON decimal + actualización de cliente.
- FIX DEFINITIVO del editor F1 sin NIF.

Se conserva expresamente:
- apertura del editor aunque falte NIF;
- introducción/corrección de NIF;
- oferta para actualizar la ficha del cliente;
- JSON sin reserialización numérica;
- separación Entorno / Origen;
- clasificación de hash como incidencia técnica no subsanable.

## Cambio V1.8

Se añade:

```text
registro_uid VARCHAR(64) NOT NULL DEFAULT 'ORIG'
```

y el nuevo índice:

```text
UNIQUE (serie, numero, registro_uid)
```

Objetivo: permitir en el futuro que un registro original y sus subsanaciones
coexistan manteniendo exactamente la misma serie y número fiscales.

Ejemplo futuro:

```text
A26 / 1523 / ORIG
A26 / 1523 / SUB-37
```

V1.8 todavía NO inserta ninguna subsanación en `verifactu_queue`.

## Núcleo protegido

No se modifica:
- uVFSenderAEAT
- uVeriFactu
- ventas.pas
- facturar.pas
- dispatcher
- XML
- SOAP
- canonical
- SHA-256
- hash_prev
