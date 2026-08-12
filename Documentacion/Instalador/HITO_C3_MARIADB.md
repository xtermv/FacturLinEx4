# Hito C.3 — Preparación de MariaDB

## Alcance

Este paquete prepara una instalación nueva sin tocar bases existentes por defecto:

- comprueba el cliente MariaDB/MySQL;
- crea la base con `utf8mb4_spanish_ci`;
- crea un usuario limitado a esa base;
- importa el esquema vacío cuando la base aún no contiene tablas;
- verifica conexión y número de tablas.

## Modo seguro

```bash
./Instalador/flx_preparar_mariadb.sh --check
```

No conecta ni modifica nada.

## Instalación en una máquina de pruebas

```bash
chmod +x Instalador/*.sh
./Instalador/flx_preparar_mariadb.sh --install
```

El script solicita las contraseñas de forma oculta. No deben pasarse por argumentos.

## Verificación

```bash
./Instalador/flx_verificar_mariadb.sh
```

## Protección de instalaciones existentes

Si la base ya existe, el script se detiene. `--allow-existing` permite revisar el caso,
pero aun así no importa el esquema si ya hay tablas y nunca ejecuta `DROP DATABASE`.

## Pendiente

Los datos mínimos de negocio no se inventan. Deben facilitarse y validarse antes de
crear `datos_minimos.sql` definitivo e idempotente.
