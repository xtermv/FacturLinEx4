# Hito C.4 — Configuración y permisos controlados

Este bloque prepara la configuración inicial de FacturLinEx y los posibles
scripts auxiliares que necesiten privilegios.

## Principios de seguridad

- Los scripts trabajan en modo `--check` por defecto.
- La contraseña MariaDB se solicita de forma oculta.
- `FacturConf.ini` se instala con permisos `0640`.
- Las configuraciones existentes se copian antes de sustituirse.
- El fragmento de sudoers se valida con `visudo`.
- No se concede acceso genérico a `sudo`, shells, gestores de paquetes,
  MariaDB ni comandos de copia o borrado.
- Solo se autorizan ejecutables auxiliares concretos, propiedad de `root`.
- Este bloque no modifica datos de negocio ni registros VeriFactu.

## Configuración

Simulación:

```bash
./Instalador/flx_configurar_facturlinex.sh --check \
  --db-host 127.0.0.1 \
  --db-name facturlinex2 \
  --db-user facturlinex \
  --vf-mode PRUEBAS
```

Instalación en máquina de pruebas:

```bash
sudo ./Instalador/flx_configurar_facturlinex.sh --install \
  --app-user usuario \
  --db-host 127.0.0.1 \
  --db-name facturlinex2 \
  --db-user facturlinex \
  --vf-mode PRUEBAS
```

**Importante:** antes de usar en producción hay que contrastar los nombres
exactos de secciones y claves con el `FacturConf.ini` estable del proyecto.

## Scripts auxiliares y sudoers

Primero coloque en una carpeta separada únicamente los `.sh` que realmente
deban ejecutarse con privilegios.

```bash
./Instalador/flx_instalar_auxiliares_sudoers.sh \
  --check --source ./AuxiliaresRoot --app-user usuario
```

Instalación:

```bash
sudo ./Instalador/flx_instalar_auxiliares_sudoers.sh \
  --install --source ./AuxiliaresRoot --app-user usuario
```

## Verificación

```bash
sudo ./Instalador/flx_verificar_config_sudoers.sh
```

## Pendiente antes del instalador final

Hay que revisar cuáles de los scripts actuales de FacturLinEx necesitan
realmente privilegios. El instalador final no debe copiar indiscriminadamente
todos los `.sh` al sudoers.
