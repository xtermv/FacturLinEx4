# Hito C.10 — FLXCore v1

Biblioteca común inicial para FacturLinEx, FLXInstaller y FLXTools.

## Unidades

- `uFLXCorePaths`
- `uFLXCoreProcess`
- `uFLXCoreLog`
- `uFLXCoreSystem`
- `uFLXCoreDiagnostics`
- `uFLXCoreVersion`

## Compilación

```bash
lazbuild -B FLXCore/FLXCore.lpk
```

Los proyectos también pueden añadir `../FLXCore` a su ruta de unidades sin instalar el paquete.

## Integración gradual

No se sustituye de golpe código ya validado. Los `.inc` indican las primeras migraciones para FLXTools y FLXInstaller. Cada sustitución debe compilarse y probarse antes de eliminar la implementación anterior.

No modifica Ventas, VeriFactu, hashes, SOAP ni la cola.
