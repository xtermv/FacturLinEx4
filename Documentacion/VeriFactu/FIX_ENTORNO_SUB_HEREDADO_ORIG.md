# FIX — Entorno SUB-* heredado del ORIG

Los SUB-* nuevos guardan explícitamente el mismo entorno que el registro ORIG.

Para SUB-* ya creados con versiones anteriores, antes del envío se recupera
el entorno desde `verifactu_subsanaciones.queue_id` y se actualizan:

- `verifactu_queue.entorno` del SUB-*;
- `verifactu_subsanaciones.entorno`.

Solo se aceptan `PRUEBAS` o `PRODUCCION`. Si el ORIG tampoco tiene uno de esos
valores, el envío continúa bloqueado.

No se modifica XML, hash, canonical, SOAP, Ventas, Facturar ni dispatcher ORIG.
