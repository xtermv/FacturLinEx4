# FLXMantenimiento v1

Interfaz gráfica para el motor común de reparaciones.

## Compilación

Copie `FLXMantenimiento/` junto a `FLXRepair/` y ejecute:

```bash
chmod +x FLXMantenimiento/compilar_mantenimiento.sh
./FLXMantenimiento/compilar_mantenimiento.sh
```

O:

```bash
lazbuild -B FLXRepair/FLXRepair.lpk
lazbuild -B FLXMantenimiento/FLXMantenimiento.lpi
```

El ejecutable queda en:

```text
Bin/FLXMantenimiento
```

## Ejecución

Como usuario normal:

```bash
./Bin/FLXMantenimiento
```

Se mostrarán reparaciones que no necesiten privilegios y las de configuración
que estén disponibles.

Para reparaciones del sistema:

```bash
sudo ./Bin/FLXMantenimiento
```

## Funcionamiento

1. El programa registra los plugins de reparación.
2. Cada plugin indica si puede ejecutarse.
3. La lista muestra código, riesgo y descripción.
4. Antes de ejecutar se solicita confirmación según el riesgo.
5. El motor ejecuta la reparación.
6. El resultado queda registrado en `flx_repair.log`.
7. La lista se vuelve a comprobar.

## Reparaciones iniciales

- `CERT-005`: configurar ruta de OpenSSL.
- `CFG-008`: crear rutas estándar.
- `DESK-001`: regenerar acceso de escritorio.

No modifica facturas, hashes, XML, SOAP, respuestas AEAT ni registros enviados.
