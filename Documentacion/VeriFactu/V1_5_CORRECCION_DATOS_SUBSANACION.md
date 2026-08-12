# VeriFactu V1.5 — Corrección real de datos antes de subsanar

## Qué corrige este paso

V1.5 resuelve una carencia importante de las versiones V1.2–V1.4:
hasta ahora se preparaba el flujo de subsanación, pero no se modificaban los
datos erróneos que debían enviarse corregidos.

Se incorpora el botón:

```text
Corregir datos
```

entre:

```text
Generar borrador técnico
        ↓
Corregir datos
        ↓
Preparar registro final
```

## Datos corregibles en esta primera versión

Se trabaja sobre una COPIA del `payload_json`, nunca sobre el original.

Dentro de:

```json
"cabecera"
```

se pueden corregir:

```text
nifCliente
nombreCliente
```

Estos son los campos que FacturLinEx ya utiliza para identificar al destinatario
en el payload de VeriFactu.

## Clasificación obligatoria

Antes de guardar, el usuario debe indicar:

1. La factura emitida era correcta y el error solo estaba en el registro VeriFactu.
2. La propia factura también contiene datos incorrectos.

El caso 1 permite continuar.

El caso 2 BLOQUEA la subsanación automática porque puede requerir anulación,
nueva factura o factura rectificativa.

## Inalterabilidad

No se toca:

- `verifactu_queue.payload_json`
- `hash`
- `hash_prev`
- `canonical`
- la factura original
- históricos de la factura

La copia corregida se guarda en:

```text
verifactu_subsanaciones.payload_corregido
```

con fecha y nota de auditoría.

El estado pasa a:

```text
DATOS_CORREGIDOS
```

Solo entonces se habilita:

```text
Preparar registro final
```

## Uso posterior

`uVFSubsanacionFinal.pas` utiliza primero `payload_corregido` y solo recurre
al payload original cuando no existe una copia corregida.

Por tanto, el futuro registro de subsanación se construirá con los datos
correctos y no simplemente con un cambio de estado.

## Siguiente ampliación

Los errores de importes, desglose IVA, descripción de operación u otros campos
deben corregirse mediante controles específicos y validaciones, no editando
libremente el JSON. Se irán incorporando como tipos de corrección adicionales.
