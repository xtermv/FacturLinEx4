# VeriFactu V1.10 — Crear subsanación en cola

## Qué hace

Cuando una subsanación está en:

```text
LISTO_PARA_GENERADOR
```

se habilita:

```text
Crear en cola
```

La operación crea un registro nuevo en `verifactu_queue`:

```text
serie        = serie fiscal original
numero       = número fiscal original
registro_uid = SUB-<id_subsanacion>
origen       = SUBSANACION
estado       = PENDIENTE
payload_json = payload_preparado
```

## Idempotencia

Si el mismo `SUB-<id>` ya existe, no se duplica. Se reutiliza el registro
existente y se vuelve a vincular `nuevo_queue_id`.

## Qué NO hace

- no calcula hash;
- no calcula canonical;
- no envía XML;
- no llama SOAP;
- no toca uVFSenderAEAT;
- no toca dispatcher normal;
- no modifica Ventas ni Facturar.

## Centro de Control

Se añade columna:

```text
Registro
```

para visualizar `ORIG` / `SUB-*`.

Así puede verse:

```text
A26 1523 NORMAL      ORIG
A26 1523 SUBSANACION SUB-37
```

antes de conectar el envío real.

## Siguiente paso

V1.11 calculará la identidad criptográfica final de un SUB-* usando el mismo
motor actual, pero sin alterar los registros ORIG ni el dispatcher normal.
