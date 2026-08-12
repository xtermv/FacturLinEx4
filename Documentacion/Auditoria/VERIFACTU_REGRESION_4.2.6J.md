# FacturLinEx 4.2.6J — Registro de regresión VeriFactu

Estado inicial: **EN PREPARACIÓN**  
Edición: **J**  
La edición X utilizará la misma matriz sobre el mismo código fuente validado.

## Flujo protegido

1. Creación de venta o factura.
2. Generación del registro VeriFactu.
3. Generación de canonical y huella.
4. Encadenamiento con la huella anterior.
5. Inserción en `verifactu_queue`.
6. Selección de entorno.
7. Generación XML/SOAP.
8. Envío HTTPS.
9. Lectura de la respuesta AEAT.
10. Actualización de estado, intentos y respuesta.
11. Consulta desde monitor técnico.
12. Consulta desde Centro de Control.

## Matriz mínima de pruebas

| Código | Prueba | Estado |
|---|---|---|
| VF-R01 | Factura completa F1 | Pendiente |
| VF-R02 | Factura simplificada F2 | Pendiente |
| VF-R03 | Rectificativa completa | Pendiente |
| VF-R04 | Rectificativa simplificada | Pendiente |
| VF-R05 | Alta correcta en cola | Pendiente |
| VF-R06 | Continuidad HASH | Pendiente |
| VF-R07 | Envío correcto en PRUEBAS | Pendiente |
| VF-R08 | Respuesta correcta AEAT | Pendiente |
| VF-R09 | Error de conexión | Pendiente |
| VF-R10 | Error SOAP técnico | Pendiente |
| VF-R11 | Reintento técnico | Pendiente |
| VF-R12 | Rechazo AEAT no reintentable | Pendiente |
| VF-R13 | Filtro por ejercicio | Pendiente |
| VF-R14 | Separación PRUEBAS/PRODUCCIÓN | Pendiente |
| VF-R15 | Auditoría criptográfica con `hash_input` | Pendiente |

## Regla de estabilidad

Una unidad protegida modificada queda **pendiente de regresión** hasta que se ejecuten las pruebas relacionadas y se documente el resultado.

## Cambios de riesgo alto actualmente pendientes

- Conservación de `hash_input`, `hash_fecha_huso` y `hash_algoritmo`.
- Separación de entorno en `verifactu_queue`.
- Reenvío técnico limitado por año y entorno.

Estos cambios no deben considerarse cerrados hasta ejecutar una prueba controlada en entorno de pruebas.
