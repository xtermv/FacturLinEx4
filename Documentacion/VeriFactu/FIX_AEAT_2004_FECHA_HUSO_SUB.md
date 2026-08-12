# FIX AEAT 2004 — FechaHoraHusoGenRegistro actual al enviar SUB

## Síntoma

AEAT devuelve:

- código 2004
- Aceptado con errores
- FechaHoraHusoGenRegistro debe ser la fecha/hora actual del sistema AEAT,
  con margen indicado por AEAT de 240 segundos.

## Causa

En FacturLinEx la fecha/hora se congelaba al pulsar `Preparar huella`.
Si el usuario tardaba varios minutos entre:

Preparar huella -> Validar XML -> Revisar -> Enviar

el registro llegaba a AEAT con una FechaHoraHusoGenRegistro demasiado antigua.

Esto se aprecia especialmente al subsanar facturas antiguas, pero NO es la
fecha de la factura la que debe cambiar.

## Corrección

Al pulsar `Enviar SUB`, inmediatamente antes del HTTP:

1. se invalida exclusivamente la evidencia técnica previa del SUB:
   - hash
   - hash_input
   - hash_fecha_huso
   - xml_preparado

2. se vuelve temporalmente a EN_COLA_PENDIENTE;

3. se ejecuta de nuevo el constructor criptográfico:
   - FechaHoraHusoGenRegistro = hora actual local con huso;
   - nueva huella SHA-256;
   - mismo payload corregido;
   - mismo tipo fiscal;
   - mismo registro técnico SUB;

4. se reconstruye y valida inmediatamente el XML;

5. solo entonces se realiza el HTTP a AEAT.

## Lo que NO cambia

- FechaExpedicionFactura: sigue siendo la fecha histórica real.
- Serie y número.
- Tipo F1/F2/R1...R5.
- NIF/nombre corregidos.
- Subsanacion / RechazoPrevio.
- Registro ORIG.
- Envío normal de Ventas/Facturar.

## Seguridad

Si no se puede reconstruir la huella o el XML justo antes de enviar,
NO se realiza comunicación con AEAT.

La solución evita que una revisión manual prolongada provoque de nuevo el 2004.
