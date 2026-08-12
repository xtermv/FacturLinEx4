# Hito C.5B — Instalador maestro

El script `instalar_facturlinex.sh` unifica las fases C.1–C.4 y las ejecuta
en orden, deteniéndose ante el primer error.

## Requisitos previos

Copie dentro de `Instalador/` todos los scripts entregados en:

- C.1 Requisitos.
- C.2 Instalación de archivos.
- C.3 MariaDB.
- C.4 Configuración y sudoers.

El instalador maestro comprueba que estén presentes y sean ejecutables.

## Simulación completa

```bash
chmod +x Instalador/*.sh

./Instalador/instalar_facturlinex.sh \
  --check \
  --source "$(pwd)" \
  --binary ./Bin/FacturLinEx \
  --vf-mode PRUEBAS \
  --skip-sudoers
```

El modo `--check` no modifica el sistema y genera un log en el directorio del
paquete.

## Instalación en máquina de pruebas

```bash
sudo ./Instalador/instalar_facturlinex.sh \
  --install \
  --source "$(pwd)" \
  --binary ./Bin/FacturLinEx \
  --app-user usuario \
  --vf-mode PRUEBAS \
  --skip-sudoers
```

El log queda en `/var/log/facturlinex2/`.

## Fases

1. Requisitos del sistema.
2. Directorios.
3. Binario, recursos y acceso de escritorio.
4. MariaDB.
5. Configuración.
6. Auxiliares/sudoers.
7. Verificación final.

## Seguridad

- Simulación por defecto.
- Confirmación explícita antes de instalar.
- Parada inmediata ante errores.
- No borra bases de datos.
- No ejecuta `DROP`.
- No incluye automáticamente auxiliares en sudoers.
- La fase sudoers puede omitirse.
- La base de datos puede omitirse para una instalación cliente.
- Los datos mínimos siguen pendientes de definición exacta.
