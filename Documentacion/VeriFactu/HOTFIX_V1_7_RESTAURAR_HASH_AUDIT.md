# HOTFIX V1.7 — restauración exacta de auditoría de hash

## Qué ocurrió

El V1.7 sustituyó `Ventas/uVeriFactu.pas` por una base que conservaba el nuevo
campo `origen`, pero no contenía la rutina añadida previamente en la revisión
`v2.2 Auditoría Criptográfica`.

`verifactu/uVFSenderAEAT.pas` sí conserva la llamada:

```pascal
VeriFactu_SaveHashAuditData(...)
```

Por eso la compilación falla.

## Qué hace este hotfix

Restaura EXACTAMENTE la declaración y la implementación de:

```pascal
procedure VeriFactu_SaveHashAuditData(const Serie: string; const Numero: Integer;
  const HashInput, FechaHoraHuso: string);
```

tomadas de la revisión `FacturLinEx_Centro_Control_VeriFactu_v2_2_auditoria_criptografica.zip`.

Mantiene simultáneamente el cambio V1.7 del campo `origen`.

## Qué NO se toca

- `uVFSenderAEAT.pas`
- XML
- canonical
- SHA-256
- hash_prev
- SOAP
- certificados
- dispatcher
- Ventas
- Facturar

## Instalación

Sustituir únicamente:

```text
Ventas/uVeriFactu.pas
```

y compilar:

```bash
lazbuild -B FacturLinEx.lpi
```

No sustituir ninguna otra unidad.
