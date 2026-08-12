# VeriFactu V1.7.1 — Separación definitiva Entorno / Origen

## Entorno
Filtro independiente sobre `q.entorno`:

- PRODUCCION
- PRUEBAS
- SIN_CLASIFICAR
- TODOS

## Origen
Filtro independiente sobre `q.origen`:

- NORMAL
- RECTIFICATIVA
- SUBSANACION
- SIN_CLASIFICAR
- TODOS

Los filtros se pueden combinar.

Ejemplos:

- PRODUCCION + NORMAL
- PRODUCCION + RECTIFICATIVA
- PRODUCCION + SUBSANACION
- PRUEBAS + NORMAL

El Centro de Control muestra `Entorno` y `Origen` como columnas distintas.
El Control de Subsanaciones recibe ambos filtros y muestra también ambas columnas.

Esta revisión NO sustituye ni modifica:

- verifactu/uVFSenderAEAT.pas
- ventas.pas
- facturar.pas
- dispatcher
- XML
- SOAP
- canonical
- cálculo SHA-256

`Ventas/uVeriFactu.pas` es la revisión ya corregida por el hotfix HashAuditData fix2.
