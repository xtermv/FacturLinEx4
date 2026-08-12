# VeriFactu V1.12 — XML específico de subsanación, sin envío

V1.12 parte de V1.11 y añade una barrera obligatoria antes de SOAP:

```text
HUELLA_PREPARADA
      ↓
Validar XML
      ↓
XML_VALIDADO
```

No existe todavía ningún botón de envío.

## Marcas de subsanación

El XML de un SUB-* se construye con:

```xml
<sum1:Subsanacion>S</sum1:Subsanacion>
```

y:

```xml
<sum1:RechazoPrevio>X</sum1:RechazoPrevio>
```

cuando el RF original fue rechazado por AEAT. En los demás casos se utiliza N.

La AEAT aclara expresamente que el alta de subsanación posterior a un rechazo
debe llevar `Subsanacion=S` y `RechazoPrevio=X`.

## RegistroAnterior real

La ruta ORIG conserva su comportamiento histórico.

Solo para SUB-* se pasan al constructor los datos reales del RF anterior:

- serie;
- número;
- fecha de expedición;
- huella.

No se inventa `numero-1` para una subsanación.

## Coherencia criptográfica

V1.12 reutiliza:
- `hash_prev` guardado por V1.11;
- `hash_fecha_huso` congelado por V1.11;
- `hash` congelado por V1.11.

Al reconstruir el XML, la huella calculada debe ser EXACTAMENTE igual a la
guardada. Si cambia un byte fiscal relevante, la operación se bloquea.

## Validaciones antes de XML_VALIDADO

Se exige que el XML contenga:
- Subsanacion=S;
- RechazoPrevio esperado;
- NumSerieFactura real del RegistroAnterior;
- fecha real del RegistroAnterior;
- huella real del RegistroAnterior;
- FechaHoraHusoGenRegistro congelada.

El XML completo se conserva en:

```text
verifactu_subsanaciones.xml_preparado
```

y la fecha de validación en:

```text
xml_validated_at
```

La estructura de `verifactu_subsanaciones` se comprueba una sola vez por
ejecución mediante `GSubSchemaChecked`.

## Núcleo protegido

Las llamadas normales a `BuildVeriFactuXMLFromJSON` no cambian de parámetros:
los nuevos argumentos tienen valores por defecto N/N y sin identidad anterior
forzada.

Por tanto, Ventas y Facturar continúan por la ruta ORIG.

## Siguiente paso

V1.13 será la primera fase que podrá realizar un envío específico de SUB-*,
pero únicamente desde `XML_VALIDADO` y reutilizando el transporte HTTP/SOAP
ya existente.
