# VeriFactu V1.7 — Preparación estructural del campo ORIGEN

## Revisión previa de `verifactu_queue`

La tabla actual ya contiene:

- identidad (`serie`, `numero`, `fecha`, `hora`);
- estado e intentos;
- `payload_json`;
- hash, hash previo, canonical y fecha ISO;
- respuesta AEAT y errores;
- reclamación técnica;
- `tipo_factura`;
- `entorno` y campos de auditoría añadidos por migración.

Faltaba un dato persistente que indique la naturaleza del registro.

## Nuevo campo

```sql
origen VARCHAR(24) NOT NULL DEFAULT 'SIN_CLASIFICAR'
```

Valores previstos:

```text
NORMAL
RECTIFICATIVA
SUBSANACION
SIN_CLASIFICAR
```

`REENVIO` no se usa como origen: un reenvío es un intento sobre el mismo RF y
ya queda reflejado mediante `intentos`, `last_attempt_at`, estado y respuesta.

`PRUEBAS` tampoco se usa como origen: pertenece al campo `entorno`.

## Migración única

Se amplía `FLXEnsureVeriFactuAuditSchema`.

La función ya usa `GCheckedThisRun`, por lo que INFORMATION_SCHEMA y los DDL
solo se comprueban una vez durante cada ejecución de FacturLinEx.

Si `origen` ya existe no se ejecuta ningún ALTER.

Los históricos no rectificativos quedan `SIN_CLASIFICAR`. No se fuerza NORMAL,
porque no debe inventarse la naturaleza de datos antiguos.

Los históricos R1-R5 sí se pueden clasificar de forma segura como
`RECTIFICATIVA`.

## Nuevos registros

`uVeriFactu.QueueToDB_Conn` guarda automáticamente:

- F1/F2/F3 -> `NORMAL`
- R1/R2/R3/R4/R5 -> `RECTIFICATIVA`

El futuro V1.7 de envío de subsanación insertará explícitamente:

```text
SUBSANACION
```

## Centro de Control

Se añade la columna persistente `Origen`.

## Validador

El Validador Técnico comprueba:

- existencia del campo;
- valores permitidos;
- resumen por origen.

## Archivos incluidos

- `Auditoria/uFLXDatabaseMigration.pas`
- `Ventas/uVeriFactu.pas`
- `VFMonitor/uVFCentroControl.pas`
- `VFMonitor/uVFValidadorTecnico.pas`
- resto de unidades V1.6 para mantener el paquete coherente.
