# VeriFactu V1.1 — Validador técnico de arquitectura

## Objetivo

Añade al Centro de Control un validador específico de solo lectura. No sustituye
el monitor ni repite sus funciones.

## Acceso

Centro de Control VeriFactu → Auditoría → `Validador técnico V1.1`.

## Comprobaciones

- Existencia de `verifactu_queue`.
- 27 columnas base y de trazabilidad.
- Clave primaria e índices principales.
- Definición de estados internos de cola.
- Duplicados serie/número.
- Tipos F1, F2, F3 y rectificativas R1-R5.
- Entornos Producción/Pruebas/Sin clasificar.
- Registros EN_PROCESO caducados.
- Hash y payload de registros enviados.
- Canonical y algoritmo SHA-256.
- Resumen de respuestas AEAT.
- Identificación de `AceptadoConErrores` como candidatos al siguiente bloque de revisión/subsanación.

## Seguridad

No ejecuta `ALTER`, `UPDATE`, `INSERT`, `DELETE`, no cambia estados y no
contacta con la AEAT.

## Instalación

Sustituir:

```text
VFMonitor/uVFCentroControl.pas
```

Añadir:

```text
VFMonitor/uVFValidadorTecnico.pas
```

Y compilar:

```bash
lazbuild -B FacturLinEx.lpi
```

## Siguiente bloque

Una vez validado V1.1, el siguiente desarrollo será la gestión específica de
subsanaciones, apoyándose en los estados y respuestas que el monitor ya conserva.


## Corrección de tipos de factura

El validador reconoce como tipos VeriFactu:

```text
F1 F2 F3 R1 R2 R3 R4 R5
```

Además muestra un resumen de cuántos registros existen de cada tipo.
