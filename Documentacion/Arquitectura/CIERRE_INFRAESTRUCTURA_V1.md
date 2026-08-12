# Cierre de infraestructura — integración FLXTools / Mantenimiento

Este bloque integra las herramientas ya construidas.

## Cambios

- FLXTools detecta y abre `FLXMantenimiento`.
- El instalador puede copiar `FLXTools`, `FLXMantenimiento` y `FLXInstaller`.
- Se instalan accesos `.desktop` cuando existen.
- Se añade verificación global del ecosistema.

## Compilación previa

```bash
lazbuild -B FLXRepair/FLXRepair.lpk
lazbuild -B FLXMantenimiento/FLXMantenimiento.lpi
lazbuild -B FLXTools/FLXTools.lpi
lazbuild -B InstaladorGUI/FLXInstaller.lpi
```

## Simulación de integración

```bash
./Instalador/flx_integrar_herramientas.sh --check --root "$(pwd)"
```

## Instalación en equipo de pruebas

```bash
sudo ./Instalador/flx_integrar_herramientas.sh --install --root "$(pwd)"
```

## Verificación

```bash
./Instalador/flx_verificar_ecosistema.sh
```

Con este paso queda técnicamente cerrada la primera fase de infraestructura.
Los siguientes desarrollos deben volver al bloque VeriFactu y Declaración Responsable,
salvo correcciones detectadas durante pruebas de estas herramientas.
