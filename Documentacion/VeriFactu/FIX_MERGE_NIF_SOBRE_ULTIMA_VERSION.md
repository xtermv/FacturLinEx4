# FIX acumulativo — NIF corregido sin retroceder estados

## Problema

El paquete `FIX_CRITICO_NIF_Corregido_en_Payload` incluía una
`uVFSubsanaciones.pas` basada en una revisión anterior.

Al sustituirla se perdieron visualmente/funcionalmente los estados introducidos
después:

- Preparar huella
- Validar XML
- Enviar SUB
- HUELLA_PREPARADA
- XML_VALIDADO
- ERROR_TECNICO
- lógica de entorno PRUEBAS / PRODUCCION

## Corrección

Esta revisión usa como base la última `uVFSubsanaciones.pas` del fix:

`FIX_Entorno_desde_URL_AEAT`

y añade solamente las columnas necesarias para el fix del NIF:

- corrected_nif
- corrected_name

Se conservan íntegramente:
- Preparar huella
- Validar XML
- Enviar SUB (PRUEBAS/PRODUCCION)
- reparación de entorno desde URL AEAT
- certificación de PRUEBAS
- estados de recuperación

También se incluyen las unidades críticas del NIF:
- uVFSubsanacionEditor.pas
- uVFSubsanacionFinal.pas
- uVFJSONPatch.pas

## Flujo esperado

DATOS_CORREGIDOS
  -> Preparar registro final
LISTO_PARA_GENERADOR
  -> Crear en cola
EN_COLA_PENDIENTE
  -> Preparar huella
HUELLA_PREPARADA
  -> Validar XML
XML_VALIDADO
  -> Enviar SUB

## Importante

No sustituir esta `uVFSubsanaciones.pas` por versiones anteriores.
