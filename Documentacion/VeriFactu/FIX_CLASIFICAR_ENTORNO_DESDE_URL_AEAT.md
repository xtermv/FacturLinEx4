# FIX — Entorno histórico resuelto desde la URL AEAT real

Los ORIG antiguos pueden estar en SIN_CLASIFICAR porque se generaron antes
de existir la columna `entorno`.

Antes de enviar un SUB-* se toma como fuente de verdad la URL que realmente
usará `uVFSenderAEAT`.

Clasificación:
- `prewww*.aeat.es` -> PRUEBAS
- servicio VeriFactu en `aeat.es` sin `prewww` -> PRODUCCION
- URL no reconocida -> envío bloqueado

Si ORIG/SUB estaban SIN_CLASIFICAR se actualizan automáticamente.

Si ya estaban clasificados como PRUEBAS/PRODUCCION y contradicen la URL real,
NO se corrigen silenciosamente: se bloquea el envío.

No se modifica XML, hash, canonical, SOAP ni la ruta ORIG.
