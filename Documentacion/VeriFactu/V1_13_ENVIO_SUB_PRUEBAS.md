# VeriFactu V1.13 — Primer envío controlado de SUB-* (solo PRUEBAS)

## Barrera de seguridad

V1.13 permite por primera vez una comunicación real de una subsanación, pero
SOLO cuando:

- `verifactu_subsanaciones.estado = XML_VALIDADO`
- `verifactu_queue.origen = SUBSANACION`
- `registro_uid = SUB-<id>`
- `entorno = PRUEBAS`

Cualquier otro entorno queda bloqueado por código.

## Ruta normal ORIG protegida

`VF_SendAEAT_HTTP` no se modifica ni se refactoriza.

Se añade una función paralela dentro de `uVFSenderAEAT`:

```text
VF_SendPreparedXML_HTTP
```

que recibe el XML ya validado y reutiliza:

- `GetAEATURL`
- configuración TLS
- certificado cliente
- SNI
- timeout
- POST HTTP
- detección WSDL
- detección SOAP Fault
- interpretación `EstadoRegistro`
- detección de duplicado AEAT

No construye XML y no recalcula ninguna huella.

## Estados

```text
XML_VALIDADO
    ↓ envío manual
ENVIADA_CORRECTA
ENVIADA_CON_ERRORES
ERROR_AEAT
ERROR_TECNICO
```

En `verifactu_queue`:

- Correcto / AceptadoConErrores -> `ENVIADO`
- Incorrecto AEAT -> `ERROR`
- fallo técnico/transporte -> vuelve a `PENDIENTE`

El fallo técnico puede reintentarse manualmente desde el panel.

## Evidencias

El XML enviado se guarda con una etiqueta que incluye `SUB-*` para no
sobrescribir el XML de la factura ORIG que comparte serie/número.

La respuesta AEAT completa queda en:

```text
verifactu_queue.respuesta_text
```

del `queue.id` exacto del SUB-*.

## Qué NO se hace

- el dispatcher normal no procesa SUB-*;
- no se modifica `uVeriFactuDispatcher`;
- no se modifican Ventas ni Facturar;
- no se recalcula hash;
- no se cambia `hash_prev`;
- no se reconstruye el XML durante el envío.

## Paso posterior

Solo después de probar V1.13 con respuesta real del entorno PRUEBAS se
habilitará una V1.14 para producción, con confirmación reforzada y registro
de evidencia de la prueba superada.
