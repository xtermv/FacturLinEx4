# FIX — conservar tipo fiscal + producción sin prueba local obligatoria

## 1. Tipo fiscal de la subsanación

Una subsanación conserva la naturaleza del registro ORIG.

Ejemplos:
- F1 -> SUB F1
- F2 -> SUB F2
- R4 -> SUB R4
- R5 -> SUB R5

`uVFSubsanacionFinal.pas` introduce explícitamente
`cabecera.tipoFactura` en `payload_preparado` leyendo `q.tipo_factura`
del ORIG.

Antes de continuar se vuelve a leer el JSON y se comprueba que coincide.

`uVFSubsanacionQueue.pas` también sincroniza `tipo_factura` y `payload_json`
si el SUB-* ya existía de una revisión anterior.

Esto evita que el constructor XML deduzca F2 por una serie FS cuando el ORIG
era realmente F1.

## 2. PRODUCCION

Se elimina únicamente la obligación LOCAL añadida en V1.14 de haber realizado
antes una subsanación correcta en PRUEBAS.

Se mantienen:
- entorno real desde `Global.vfMode`;
- bloqueo si hay contradicción explícita PRUEBAS/PRODUCCION;
- escribir literalmente PRODUCCION;
- confirmación final antes del envío.

La tabla de certificación de pruebas puede seguir existiendo como evidencia,
pero ya no es un requisito para enviar en producción.

## Para un SUB ya preparado con tipo incorrecto

Volver a:
1. Preparar registro final.
2. Crear/actualizar cola.
3. Preparar huella.
4. Validar XML.
5. Enviar.

No reutilizar el XML/huella anterior porque estaban construidos con el tipo
incorrecto.
