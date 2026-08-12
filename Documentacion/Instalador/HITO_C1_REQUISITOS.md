# FacturLinEx 4.2.6 — Hito C.1

## Objetivo

Detectar requisitos del sistema y preparar la base del instalador profesional para Debian sin modificar el equipo de forma automática.

## Scripts

### `flx_requisitos.sh`

Modo seguro de consulta:

```bash
./Instalador/flx_requisitos.sh --check
```

Instalación explícita de dependencias obligatorias:

```bash
./Instalador/flx_requisitos.sh --install
```

El script muestra y confirma los paquetes antes de llamar a `sudo apt-get`.

### `flx_preparar_directorios.sh`

Solo comprobar:

```bash
./Instalador/flx_preparar_directorios.sh
```

Crear directorios, con confirmación:

```bash
./Instalador/flx_preparar_directorios.sh --create
```

## Seguridad

- Ningún script borra archivos.
- Ningún script toca MariaDB ni crea bases de datos.
- Ningún script modifica sudoers.
- El modo predeterminado es solo lectura.
- Toda modificación requiere una opción explícita y confirmación.

## Próximo bloque

Hito C.2: copia controlada de recursos, binario, configuración, lanzador de escritorio y manifiesto de instalación.
