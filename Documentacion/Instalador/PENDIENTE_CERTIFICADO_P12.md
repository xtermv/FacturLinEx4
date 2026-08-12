# Pendiente posterior — Certificado .p12

Este punto NO debe bloquear las pruebas del instalador.

## Requisito acordado

En una fase posterior, cuando el flujo completo de instalación esté validado:

- el asistente podrá solicitar un certificado `.p12` / `.pfx`;
- pedirá su contraseña de forma oculta;
- generará en la máquina destino los tres PEM necesarios para FacturLinEx;
- aplicará permisos restrictivos;
- NO incluirá el `.p12`, su contraseña ni los PEM en el paquete distribuido;
- el paso será OPCIONAL;
- el usuario podrá pulsar "Omitir / Configurar después";
- FacturLinEx seguirá permitiendo configurar el certificado posteriormente
  desde sus propias funciones.

No implementar hasta cerrar la prueba completa del instalador.
