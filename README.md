# FacturLinEx4
Multi-Terminal
FacturLinEx sistema de gestión, Almacen y Tpv Libre y Gratuito para Linux y MariaDB

# NOTA ACLARATORIA IMPORTANTE PARA SU INSTALACIÓN
# INSTALAR CON LA CONFIGURACIÓN BASE PARA QUE CREE LOS INDICES, ARTICULOS Y USUARIOS BÁSICOS NECESARIOS PARA SU FUNCIONAMIENTO
# DESPUÉS HABRÁ QUE ACTUALIZAR LA BBDD AL FICHERO .SQL QUE SE CREARÁ EN RAIZ PARA COMPLETAR LAS TABLAS CON SUS MEJORAS Y EDICIONES Y ASÍ EVITAR ERRORES Y PROBLEMAS

Tpv (Ventas y Cobros, Albaranes, Facturas, Presupuestos, etc) todo desde una misma pantalla, ágil pues el 90% de las operaciones pueden hacerse con teclado
Control de Cajas y Créditos
Albaranes, Facturas y Facturación de Albaranes (selección de criterios)
Articulos (Multi-Ean) gestión de costes, ventas, estadisticas y Margenes
Clientes
Proveedores
Familias
Departamentos
Tiendas (Estadisticas y Series de trabajo)
(También se pueden gestionar Vendedores, usuarios y otros)
Pedidos a proveedores
Historicos de operaciones, albaranes, pedidos y facturas
Estadisticas, Listados
Control de tarifas
347
Listados de Iva Recibido y Emitido
Etiquetas para Lineales y Productos (Este último con GLabels)
Comunicaciones (No desarrollado completamente)
Utilidades (Actualizador de tarifas, Backup (mediante dump o copia fisica en bbdd MyISAM y Aria), Actualizador de Stock, Diseñador de reports (No valido para envíos pdf/mail), Roles de usuarios)
Extras (Se pueden añadir módulos, actualmente solo está disponible el módulo de recibos norma  53 , pero no está terminado)
Veri*Factu - Envio de facturas controlado (temporizado) y firmado (se requiere un certificado digital en formato .p12 y ya se generan a partir de ahí los documentos) Requiere configuración.
Agenda y Pedidos en menú principal.

Envio de documentos (Albaranes/Facturas) por e-mail de forma sencilla y rápida
Control de la Impresión, copias, etc en una única pantalla

Preparado para Veri*Factu (40%) se pueden enviar facturas simplificadas y facturas , pero aún no están disponibles las rectificativas
Preparado para Face - Genera y firma correctamente el .xml requerido por Face (Validado en la propia web)
          El único detalle para Face es que los DIR3 y el CCF deberán indicarse en las Observaciones de la factura del siguiente modo:
                   CCF : XXXXX-XXXXX
                   OC : XXXXXXX
                   OG : XXXXXXX
                   UT : XXXXXXX
            El sistema ya se encargará de localizarlos y clasificarlos para el .xml
