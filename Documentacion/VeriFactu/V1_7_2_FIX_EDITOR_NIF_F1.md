# Fix V1.7.2 — Editor de subsanación F1 sin NIF

## Problema

Al abrir `Corregir datos`, si el registro F1 no tenía NIF, la validación se
ejecutaba antes de mostrar la ventana:

`Para este F1 debe indicar el NIF/DNI correcto del destinatario.`

Eso impedía precisamente introducir el dato faltante.

## Corrección

La ventana se abre siempre aunque el NIF original esté vacío.

La validación de F1 se realiza únicamente al pulsar `Guardar corrección`.

Flujo correcto:

1. Abrir `Corregir datos`.
2. Ver NIF original vacío.
3. Introducir NIF correcto.
4. Guardar corrección.
5. Preguntar si se desea actualizar también la ficha del cliente.
6. Continuar con la subsanación.

No se modifica el motor de envío VeriFactu.
