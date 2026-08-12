# FLXTools v1

Proyecto Lazarus independiente que centraliza el acceso a FacturLinEx,
FLXInstaller, documentación y diagnóstico.

## Compilación

```bash
chmod +x FLXTools/compilar_flxtools.sh
./FLXTools/compilar_flxtools.sh
```

El ejecutable se genera en `Bin/FLXTools`.

## Funciones

- Detecta FacturLinEx y FLXInstaller.
- Abre FacturLinEx.
- Abre el instalador gráfico.
- Abre documentación.
- Comprueba OpenSSL.
- Genera diagnóstico básico sin contraseñas ni datos fiscales.
- Muestra eventos de la sesión.
- Cierra con ESC.

El Centro de Salud sigue integrado en FacturLinEx; el botón abre la aplicación
y explica la ruta de acceso.
