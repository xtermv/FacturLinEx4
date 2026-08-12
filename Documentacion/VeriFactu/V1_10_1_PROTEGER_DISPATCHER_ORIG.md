# V1.10.1 — Protección del dispatcher normal

## Hallazgo

Los registros `SUB-*` creados en V1.10 pasaban a `EN_PROCESO` porque el
dispatcher normal seleccionaba cualquier fila `PENDIENTE`.

## Corrección mínima

Se modifica exclusivamente la selección de filas en:

- `VeriFactu_TakeNextPending`
- `VeriFactu_TakeSpecificPending`

añadiendo:

```sql
COALESCE(registro_uid,'ORIG')='ORIG'
```

Además, los `SUB-*` dejan de bloquear el orden normal de una serie en los
`NOT EXISTS`.

## No se modifica

- `uVFSenderAEAT`
- `uVeriFactuDispatcher`
- XML
- canonical
- SHA-256
- hash_prev
- SOAP
- Ventas
- Facturar
- tratamiento de respuestas AEAT

## Recuperación

Se incluye `uVFSubsanacionRecovery.pas` para devolver a `PENDIENTE` cualquier
`SUB-*` que hubiera quedado en `EN_PROCESO`. No modifica su payload.

## Siguiente paso

Cuando confirmemos que:
- `ORIG` sigue enviándose igual;
- `SUB-*` permanece en `PENDIENTE`;

pasaremos a V1.11, preparación criptográfica específica de la subsanación.
