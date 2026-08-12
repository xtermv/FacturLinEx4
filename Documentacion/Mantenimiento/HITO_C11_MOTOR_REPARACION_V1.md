# Hito C.11 — Motor de Reparación v1

Primera versión compilable del motor común.

## Reparaciones incluidas

- `CERT-005`: localizar OpenSSL y guardar la ruta en `FacturConf.ini`.
- `CFG-008`: crear rutas estándar.
- `DESK-001`: regenerar el acceso de escritorio.

## Seguridad

- Cada reparación declara su riesgo.
- La configuración crea copia previa.
- Las operaciones del sistema requieren root.
- Cada ejecución queda registrada.
- No modifica facturas, hashes, XML, SOAP ni respuestas AEAT.

## Compilación

```bash
chmod +x compilar_flxrepair.sh
./compilar_flxrepair.sh
```

La reparación del esquema VeriFactu se integrará en la siguiente revisión,
usando la migración centralizada ya validada en FacturLinEx, para no duplicar
lógica SQL.
