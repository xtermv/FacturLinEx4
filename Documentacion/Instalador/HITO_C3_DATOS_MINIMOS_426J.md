# Hito C.3B — Datos mínimos FacturLinEx 4.2.6J

Se sustituye `datos_minimos_PENDIENTE.sql` por `datos_minimos.sql`.

## Registros creados si no existen

- tienda `T0=0`, con datos solicitados al instalar;
- cliente `999999` — CLIENTES DE CONTADO;
- artículo `9999999999999` — ARTICULOS VARIOS, PVP 999, IVA 21%;
- serie `A<AA>` calculada con el año actual;
- formas de pago 1..6;
- puestos A, B y C;
- rutas 1 y 2;
- tarifas base;
- usuario inicial 1 / LINEX;
- `roles0000`: no se modifica.

## Seguridad

Los INSERT son idempotentes y usan listas explícitas de columnas.
No copian saldos ni valores históricos de clientes/artículos de producción.
No sustituyen registros que ya existan.

## Usuario inicial

Usuario: `LINEX`
Clave inicial: `LINEX`

Debe cambiarse tras el primer acceso.

## Nota sobre tarifas

El código histórico `999999999` se ha alineado con el código actual del
artículo varios: `9999999999999`.
