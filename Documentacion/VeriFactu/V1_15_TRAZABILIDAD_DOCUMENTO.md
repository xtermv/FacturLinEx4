# VeriFactu V1.15 — Trazabilidad completa por documento

Desde el Centro de Control se añade `Ver trazabilidad`.

La nueva ventana muestra, para la serie/número seleccionados:

- ORIG;
- todos los SUB-*;
- tipo fiscal y entorno;
- estado de cola y resultado AEAT;
- hash / hash_prev;
- hash_input;
- FechaHoraHusoGenRegistro;
- operación y estado de subsanación;
- indicadores Subsanacion / RechazoPrevio;
- ancla real del RegistroAnterior;
- XML validado;
- respuesta AEAT completa;
- payload JSON.

## Estándar de rejillas

Las columnas son ordenables por cabecera. Un segundo clic invierte el orden y
la cabecera activa muestra ▲ / ▼.

## Relaciones

No se inventan relaciones con rectificativas que tengan otra serie/número.
Solo se muestra una relación cuando los datos técnicos permiten demostrarla.

## Seguridad

V1.15 es exclusivamente de lectura. No modifica cola, estados, XML, hash ni
realiza comunicaciones con AEAT. Tampoco modifica uVFSenderAEAT, uVeriFactu,
dispatcher, Ventas ni Facturar.

ESC cierra únicamente la ventana de trazabilidad y vuelve al Centro de Control.
