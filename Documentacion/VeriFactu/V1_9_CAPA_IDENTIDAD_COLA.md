# VeriFactu V1.9 — Capa de identidad técnica de cola

## Objetivo

Preparar el soporte `ORIG` / `SUB-*` sin alterar el dispatcher normal.

La API histórica de FacturLinEx continúa trabajando como siempre por
serie+número para los registros normales. V1.9 NO cambia esa API.

Se añade una unidad paralela:

```text
VFMonitor/uVFQueueIdentity.pas
```

que trabaja inequívocamente por:

```text
id
```

o por:

```text
serie + numero + registro_uid
```

## Funciones nuevas

- `VFQ_LoadByID`
- `VFQ_LoadByIdentity`
- `VFQ_ClaimPendingByID`
- `VFQ_MarkSentByID`
- `VFQ_MarkErrorByID`
- `VFQ_RequeueByID`

Esta capa será utilizada exclusivamente por el futuro flujo de subsanación.

## Por qué no se modifica todavía uVeriFactuDispatcher

El dispatcher actual es el que utilizan los envíos normales de Ventas y
Facturar y está depurado en producción.

Modificarlo ahora para soportar `SUB-*` añadiría riesgo innecesario.

La estrategia será:

1. registros normales -> dispatcher histórico sin cambios;
2. subsanaciones -> nueva identidad por `id/registro_uid`;
3. cuando ambos caminos estén probados, valorar una unificación interna.

## Seguridad

V1.9 no:

- inserta subsanaciones;
- envía a AEAT;
- calcula hashes;
- genera XML;
- modifica `uVFSenderAEAT`;
- modifica `uVeriFactu`;
- modifica `uVeriFactuDispatcher`;
- modifica Ventas o Facturar.

## Siguiente paso V1.10

Crear el registro de cola de una subsanación ya validada:

```text
serie        = serie fiscal original
numero       = número fiscal original
registro_uid = SUB-<id_subsanacion>
origen       = SUBSANACION
estado       = PENDIENTE
payload_json = payload corregido/preparado
```

sin enviarlo todavía.

Después verificaremos que el Centro de Control puede mostrar simultáneamente
el registro ORIG y el SUB-* de la misma factura antes de conectar el envío.
