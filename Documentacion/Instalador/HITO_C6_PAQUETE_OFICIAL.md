# Hito C.6 — Paquete oficial e integridad

Este bloque genera los paquetes separados de las ediciones J y X.

## Generar la edición J

```bash
chmod +x Instalador/*.sh

./Instalador/flx_generar_paquete_oficial.sh \
  --source "$(pwd)" \
  --output "$HOME/PaquetesFacturLinEx" \
  --version 4.2.6 \
  --edition J \
  --binary ./Bin/FacturLinEx
```

## Generar la edición X

La edición X debe compilarse por el segundo productor desde el mismo código
validado:

```bash
./Instalador/flx_generar_paquete_oficial.sh \
  --source "$(pwd)" \
  --output "$HOME/PaquetesFacturLinEx" \
  --version 4.2.6 \
  --edition X \
  --binary ./Bin/FacturLinEx
```

## Verificación del contenido

```bash
./Instalador/flx_verificar_paquete.sh \
  --package "$HOME/PaquetesFacturLinEx/FacturLinEx-4.2.6J"
```

## Resultados

- Directorio instalable.
- Archivo `.tar.gz`.
- SHA-256 del archivo comprimido.
- Manifiesto SHA-256 de cada fichero.
- Identificador `FLX-J` o `FLX-X`.
- Fecha de empaquetado.
- Commit Git, cuando está disponible.
- Estado explícito de candidato no certificado.

## Código fuente

La opción `--include-source` incorpora una copia limpia del código fuente al
paquete. La licencia libre permite modificaciones, pero una versión modificada
o recompilada por terceros no queda cubierta por la declaración responsable
del productor del paquete oficial.
