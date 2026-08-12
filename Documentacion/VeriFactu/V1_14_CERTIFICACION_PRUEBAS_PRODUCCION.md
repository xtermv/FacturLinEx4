# VeriFactu V1.14 — Puerta de certificación PRUEBAS → PRODUCCIÓN

## Objetivo

V1.14 permite dejar preparada la ruta de PRODUCCIÓN sin permitir que se use
antes de haber demostrado una subsanación correcta en PRUEBAS.

## Evidencia persistente

Se crea una sola vez:

```text
verifactu_sub_certificacion
```

Cada prueba SUB con respuesta:

```text
EstadoRegistro = Correcto
Entorno = PRUEBAS
```

genera una evidencia con:

- sub_id;
- queue_id;
- respuesta completa;
- fecha/hora de certificación.

Una misma queue_id no se duplica.

`AceptadoConErrores` NO abre producción.

## Doble barrera de PRODUCCIÓN

Una subsanación en PRODUCCIÓN solo puede enviarse si:

1. existe al menos una evidencia PRUEBAS / Correcto;
2. el usuario escribe literalmente `PRODUCCION`;
3. confirma un segundo diálogo de advertencia.

La función `VF_SendValidatedSubsanacion` vuelve a consultar la evidencia aunque
la interfaz ya la haya comprobado. Por tanto, no depende únicamente del botón.

## PRUEBAS

El envío de PRUEBAS sigue funcionando como V1.13.

Cuando AEAT devuelve `Correcto`, se registra automáticamente la evidencia que
habilitará futuros envíos de subsanación en PRODUCCIÓN.

## Comprobación de estructura

`uVFSubsanacionCertificacion` utiliza `GCertSchemaChecked`, por lo que el
`CREATE TABLE IF NOT EXISTS` se comprueba una sola vez por ejecución.

## Núcleo protegido

No se modifica:
- `uVFSenderAEAT.pas` respecto a V1.13;
- dispatcher ORIG;
- Ventas;
- Facturar;
- XML;
- canonical;
- hash / hash_prev.

V1.14 modifica únicamente el control de acceso al transporte SUB-* y el
registro de evidencia de pruebas.

## Recomendación de prueba

Antes de usar PRODUCCIÓN:

1. ejecutar un SUB-* en entorno PRUEBAS;
2. comprobar `ENVIADA_CORRECTA`;
3. cerrar/reabrir FacturLinEx;
4. confirmar que la evidencia persiste;
5. solo entonces probar una subsanación real de PRODUCCIÓN.
