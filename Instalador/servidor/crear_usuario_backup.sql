-- Ejecutar como administrador de MariaDB y cambiar la contraseña.
CREATE USER IF NOT EXISTS 'facturlinex_backup'@'localhost'
  IDENTIFIED BY 'CAMBIAR_POR_UNA_CLAVE_SEGURA';

GRANT RELOAD, PROCESS, LOCK TABLES, BINLOG MONITOR
  ON *.* TO 'facturlinex_backup'@'localhost';

FLUSH PRIVILEGES;
