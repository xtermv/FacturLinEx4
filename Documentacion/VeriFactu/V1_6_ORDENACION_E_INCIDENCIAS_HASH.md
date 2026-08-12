# V1.6 — Ordenación del grid e incidencias de hash

## Ordenación
El grid vuelve al estándar FacturLinEx:
- clic en cabecera para ordenar;
- segundo clic invierte ASC/DESC;
- flecha ▲ / ▼ en la columna activa;
- orden estable con fecha/serie/número como desempate.

## Incidencias de integridad
Los diagnósticos que contienen hash, huella, encadenamiento o canonical se
clasifican como:

INCIDENCIA TECNICA HASH/ENCADENAMIENTO

No entran en el flujo de subsanación y se deshabilitan sus botones.

Un registro definitivo no debe recalcularse ni modificarse a posteriori.
Los casos históricos de pruebas deben conservarse como incidencia histórica.
