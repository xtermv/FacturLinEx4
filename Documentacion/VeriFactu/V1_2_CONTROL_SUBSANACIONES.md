# VeriFactu V1.2 — Control de subsanaciones

La AEAT exige conservar inalterado el registro original. FacturLinEx crea una tabla separada `verifactu_subsanaciones` para controlar la preparación del nuevo registro.

## Operativas preparadas

- Registro aceptado o AceptadoConErrores: `Subsanacion=S`, `RechazoPrevio=N` u omitido.
- Registro rechazado / Incorrecto: `Subsanacion=S`, `RechazoPrevio=X`.

## Esta versión

- Añade el botón `Control de subsanaciones` al Centro de Control existente.
- Crea la tabla de control una sola vez mediante `CREATE TABLE IF NOT EXISTS`.
- Conserva el registro original completamente inalterado.
- No modifica hash, canonical, payload, estado de cola ni respuesta AEAT.
- No genera XML ni envía nada todavía.
- Exige revisión manual porque una corrección puede requerir factura rectificativa o anulación en vez de subsanación.

## Siguiente paso V1.3

Generar el nuevo registro de subsanación, encadenarlo como un registro más del SIF, calcular su nueva huella y prepararlo para envío sin alterar el original.
