# Hito C.7 — Asistente gráfico de instalación

Este paquete crea un proyecto Lazarus independiente:

```text
InstaladorGUI/FLXInstaller.lpi
InstaladorGUI/FLXInstaller.lpr
InstaladorGUI/uFLXInstallerMain.pas
```

## Compilación

Desde la raíz del proyecto:

```bash
chmod +x InstaladorGUI/compilar_instalador.sh
./InstaladorGUI/compilar_instalador.sh
```

O directamente:

```bash
lazbuild -B InstaladorGUI/FLXInstaller.lpi
```

El ejecutable se genera en:

```text
Bin/FLXInstaller
```

## Funcionamiento

El asistente tiene siete pasos:

1. Bienvenida.
2. Ubicación del paquete y binario.
3. Simulación obligatoria mediante `instalar_facturlinex.sh --check`.
4. Selección del entorno VeriFactu.
5. Resumen.
6. Instalación real.
7. Resultado y log.

La instalación real requiere iniciar el asistente con privilegios:

```bash
sudo ./Bin/FLXInstaller
```

La simulación puede ejecutarse como usuario normal.

## Dependencias

El proyecto necesita Lazarus/LCL para compilar. El ejecutable resultante no
necesita Lazarus instalado.

Debe convivir con los scripts de los hitos C.1–C.6 dentro de `Instalador/`.

## Seguridad

- La simulación se ejecuta antes de la instalación.
- La instalación real exige root y confirmación.
- Se utiliza el instalador maestro ya preparado.
- No se implementa borrado de bases de datos.
- La fase sudoers está omitida por defecto.
- El entorno inicial recomendado es PRUEBAS.
- El log se conserva en la configuración del usuario.

## Limitaciones de esta primera versión

- Los datos mínimos iniciales siguen pendientes de valores exactos.
- La selección gráfica de certificados se incorporará cuando se valide el
  formato exacto de `FacturConf.ini`.
- No ejecuta todavía el Centro de Salud de la aplicación instalada.
- La interfaz lee la salida del script durante la ejecución, pero las consultas
  siguen siendo síncronas para evitar compartir conexiones o estados inseguros.
