# VeriFactu V1.7.2 — JSON decimal y actualización opcional de cliente

## Corrección crítica: no reserializar importes

El editor de subsanaciones utilizaba `TJSONObject.FormatJSON`. Al parsear y
volver a serializar el documento, determinados valores de coma flotante podían
mostrarse en notación científica.

Desde esta revisión el JSON fiscal se trata de forma conservadora:

1. se valida sintácticamente;
2. se conserva el texto JSON original;
3. solo se sustituyen literalmente `cabecera.nifCliente` y
   `cabecera.nombreCliente`;
4. al preparar el registro final se añaden/reemplazan `Subsanacion` y
   `RechazoPrevio` sin reconstruir el resto del JSON.

Por tanto los importes, bases, tipos y cuotas mantienen exactamente la
representación decimal que ya tenía el payload original.

## Actualización opcional de la ficha del cliente

Si el NIF/DNI corregido es diferente del que figuraba en el payload y el JSON
contiene `cabecera.codCliente`, FacturLinEx consulta la ficha `clientes`:

- código: `C0`
- nombre: `C1`
- NIF/DNI: `C5`

Si la ficha no tiene NIF/DNI, pregunta expresamente si se desea guardar el
nuevo valor para evitar futuras incidencias.

Si la ficha contiene un valor distinto, muestra ambos valores y también exige
confirmación antes de sustituirlo.

Nunca se modifica la ficha sin autorización del usuario.

## Núcleo protegido

Esta revisión no modifica:

- `verifactu/uVFSenderAEAT.pas`
- `Ventas/ventas.pas`
- Facturar
- dispatcher
- generación XML normal
- SOAP
- hash/canonical normal
