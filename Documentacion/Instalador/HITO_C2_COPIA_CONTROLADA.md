# Hito C.2 — Copia controlada e integración de escritorio

Este bloque instala los archivos de FacturLinEx sin crear ni modificar todavía la base de datos.

## Flujo recomendado

```bash
chmod +x Instalador/*.sh
./Instalador/flx_instalar_archivos.sh --check --binary ./Bin/FacturLinEx
sudo ./Instalador/flx_instalar_archivos.sh --install --binary ./Bin/FacturLinEx
sudo ./Instalador/flx_verificar_instalacion.sh
```

## Seguridad

- `--check` no modifica el sistema.
- Antes de sustituir una instalación existente se crea copia en `/var/backups/facturlinex2/FECHA_HORA`.
- `FacturConf.ini` no se sobrescribe si ya existe en `/etc/facturlinex2`.
- La desinstalación no elimina la base de datos ni los datos del usuario.
- `flx_desinstalar.sh --purge` elimina además configuración global y logs, pero nunca la base de datos.

## Pendiente para C.3

- Creación/configuración de MariaDB.
- Importación del esquema y datos mínimos.
- Usuario de base de datos y permisos.
- Ajustes controlados de sudoers.
