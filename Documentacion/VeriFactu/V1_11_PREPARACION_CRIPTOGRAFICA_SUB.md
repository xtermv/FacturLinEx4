# VeriFactu V1.11 — Preparación criptográfica SUB-*

La AEAT establece que una subsanación se trata, a efectos de trazabilidad,
como un RF más y se encadena con el anterior RF generado por el SIF.

V1.11 añade el paso:

EN_COLA_PENDIENTE -> Preparar huella -> HUELLA_PREPARADA

Se congelan:
- hash_prev;
- hash_fecha_huso / FechaHoraHusoGenRegistro;
- hash_input SIF-B exacto;
- hash SHA-256;
- hash_algoritmo.

No se duplica el cálculo. `VF_PrepareAEATHash_NoSend` llama al mismo
`BuildVeriFactuXMLFromJSON` que usa `VF_SendAEAT_HTTP`, pero no crea conexión
HTTP ni remite SOAP.

Para evitar confundir ORIG y SUB-* de la misma serie/número, la nueva
`VeriFactu_SaveHashAuditDataByID` guarda la evidencia por queue.id.
La función histórica por serie/número permanece intacta.

El SUB-* busca su huella previa por el RF generado inmediatamente antes
(id menor con hash no vacío), no mediante numero-1.

IMPORTANTE:
El XML interno aún NO se envía. V1.12 deberá ajustar y validar explícitamente
Subsanacion=S, RechazoPrevio y la identificación completa de RegistroAnterior
antes de habilitar cualquier envío.
