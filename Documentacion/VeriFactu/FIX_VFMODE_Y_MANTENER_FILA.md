# FIX acumulativo — vfMode real + mantener fila seleccionada

## 1. Entorno VeriFactu

La fuente de verdad pasa a ser `vfMode`, la misma variable global que ya usa
FacturLinEx para:

- barra/estado del sistema;
- menús VeriFactu;
- modo PRUEBAS/PRODUCCION;
- decisiones de envío.

Valores aceptados:

- PRUEBAS
- PRODUCCION
- TEST se normaliza a PRUEBAS.

La URL ya no decide el entorno; se conserva solo como información diagnóstica.

Los ORIG históricos `SIN_CLASIFICAR` NO se reclasifican masivamente.

Las nuevas subsanaciones y nuevos registros SUB-* guardan directamente el
valor actual de `vfMode`.

Si un registro ya estaba marcado explícitamente PRUEBAS/PRODUCCION y contradice
`vfMode`, el envío se bloquea por seguridad.

## 2. Mantener fila seleccionada

Antes de recargar `Q`, `LoadData` guarda:

- `sub_id`, si existe;
- en caso contrario `queue id`.

Después de `Q.Open` se hace `Locate` para volver a la misma línea.

Así, después de:

- generar/regenerar borrador;
- corregir datos;
- preparar registro final;
- crear en cola;
- preparar huella;
- validar XML;
- enviar/reintentar;

el foco permanece sobre la operación que el usuario está trabajando.

## Seguridad

Se conservan todos los estados y botones de la última revisión:
Preparar huella, Validar XML, Enviar SUB, HUELLA_PREPARADA, XML_VALIDADO,
ERROR_TECNICO y certificación PRUEBAS/PRODUCCION.
