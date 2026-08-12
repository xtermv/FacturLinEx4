# VeriFactu V1.4 — Preparación final segura de la subsanación

## Objetivo

V1.4 convierte el borrador V1.3 en un registro candidato listo para que lo
consuma el generador VeriFactu existente.

No envía todavía.

## Protección frente a ruptura de cadena

Antes de preparar el registro final se vuelve a consultar el último registro
de `verifactu_queue`.

Si el `id` o la huella ya no coinciden con el ancla guardada en el borrador,
la operación se bloquea y obliga a regenerar el borrador.

Esto evita preparar una subsanación contra una posición antigua de la cadena.

## Payload preparado

V1.4 conserva el `payload_json` original y añade:

```text
Subsanacion
RechazoPrevio
```

Además añade metadatos internos bajo nombres `_flx_*`. Estos metadatos son de
control interno y no forman parte del registro XML AEAT.

El payload se guarda en:

```text
verifactu_subsanaciones.payload_preparado
```

y el estado pasa a:

```text
LISTO_PARA_GENERADOR
```

## Por qué V1.4 no modifica todavía uVFSenderAEAT

El sender actual ya está probado con envíos reales y genera el XML a partir
de `payload_json`. También está probado el tratamiento de respuestas
Correcto/AceptadoConErrores.

No se modifica ese sender sin trabajar sobre su fuente completo exacto:
parchearlo a partir de referencias parciales pondría en riesgo los envíos
normales ya validados.

## Garantías de esta revisión

- No modifica facturas.
- No modifica el registro original de `verifactu_queue`.
- No cambia hashes existentes.
- No altera el dispatcher.
- No contacta con la AEAT.
- Detecta borradores cuyo encadenamiento haya quedado obsoleto.
- Deja la subsanación preparada para conectar con el generador real.

## Siguiente paso

El siguiente paso debe actuar sobre el fuente exacto actual de
`uVFSenderAEAT.pas` / generador de huella:

1. leer `Subsanacion` y `RechazoPrevio` del payload preparado;
2. regenerar el ancla inmediatamente antes de producir el RF;
3. calcular canonical y SHA-256 con las funciones actuales;
4. producir el XML con `<Subsanacion>S</Subsanacion>`;
5. enviar con el transporte existente;
6. guardar respuesta/CSV en `verifactu_subsanaciones`.

La AEAT indica que la subsanación es un registro nuevo y, para trazabilidad,
se encadena como cualquier otro RF con el anterior registro generado por el SIF.
