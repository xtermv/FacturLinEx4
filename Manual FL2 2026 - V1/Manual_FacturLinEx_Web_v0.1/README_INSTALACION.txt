MANUAL WEB DE FACTURLINEX - EDICIÓN v0.1
================================================

CONTENIDO
- index.html: página principal del manual.
- capitulos/: capítulos completos.
- assets/: estilos, buscador y recursos visuales.
- descargas/: versiones PDF y DOCX.

PUBLICACIÓN RÁPIDA
1. Descomprima todo el contenido conservando las carpetas.
2. Copie la carpeta completa al directorio público del servidor web.
   Ejemplos habituales:
   - Apache (Debian): /var/www/html/manual-facturlinex/
   - Nginx (Debian):  /var/www/html/manual-facturlinex/
3. Abra en el navegador:
   https://SU-DOMINIO/manual-facturlinex/

No necesita PHP, base de datos, Node.js ni ningún proceso de instalación.
Todos los enlaces son relativos, por lo que puede publicarse en un dominio,
un subdominio o una subcarpeta.

PRUEBA LOCAL
Puede abrir index.html directamente con Firefox o Chromium. El buscador también
funciona sin servidor porque el índice está incluido como JavaScript local.

ACTUALIZACIONES
Para actualizar el manual, sustituya la carpeta completa por la nueva versión o
copie únicamente los archivos modificados conservando la estructura.

PERMISOS RECOMENDADOS EN LINUX
sudo chown -R www-data:www-data /var/www/html/manual-facturlinex
sudo find /var/www/html/manual-facturlinex -type d -exec chmod 755 {} \;
sudo find /var/www/html/manual-facturlinex -type f -exec chmod 644 {} \;
