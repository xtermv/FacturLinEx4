# FIX CRÍTICO — Persistencia del NIF corregido en subsanaciones

## Problema

El editor permitía introducir un NIF correcto, pero el flujo dependía
exclusivamente de que la sustitución dentro de `payload_corregido` hubiera
funcionado. Si no lo hacía, el registro final podía volver a utilizar el
payload original y reenviar el mismo error.

## Solución

Se añaden campos explícitos:

- `corrected_nif`
- `corrected_name`

Al guardar el editor se conservan siempre esos valores.

Al preparar el registro final:

1. se parte de `payload_corregido` si existe, o del original como fallback;
2. se vuelve a aplicar `corrected_nif`;
3. se vuelve a aplicar `corrected_name`;
4. se lee de nuevo `cabecera.nifCliente`;
5. si NO coincide exactamente con `corrected_nif`, se BLOQUEA el proceso;
6. solo entonces se añaden `Subsanacion` y `RechazoPrevio`.

No se reserializan importes ni se usa FormatJSON.

## Registros ya creados

Para una subsanación existente que se creó antes de este fix, hay que volver
a abrir `Corregir datos` y pulsar `Guardar corrección` una vez para que se
rellenen `corrected_nif/corrected_name`. No es necesario rehacer la factura
original.

Después se debe volver a `Preparar registro final`, porque el payload preparado
anterior no contiene la garantía nueva.
