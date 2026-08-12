-- FacturLinEx 4.2.6J
-- DATOS MÍNIMOS DE INSTALACIÓN
--
-- Este fichero está diseñado para ejecutarse después de crear el esquema vacío.
-- Es idempotente: no sustituye registros existentes con la misma clave primaria.
--
-- Variables que debe establecer el instalador antes de ejecutar este fichero:
--   @FLX_TIENDA_NOMBRE
--   @FLX_TIENDA_DIRECCION
--   @FLX_TIENDA_LOCALIDAD
--   @FLX_TIENDA_CP
--   @FLX_TIENDA_PROVINCIA
--   @FLX_TIENDA_TELEFONO
--   @FLX_TIENDA_FAX
--   @FLX_TIENDA_NIF
--   @FLX_DB_HOST
--   @FLX_DB_PORT
--
-- No se crean roles0000: la instalación real aportada por el productor
-- mantiene esa tabla vacía.
--
-- La serie inicial se calcula con el año de instalación:
--   2026 -> A26
--   2027 -> A27
-- etc.

SET @FLX_SERIE := CONCAT('A', DATE_FORMAT(CURDATE(), '%y'));
SET @FLX_SERIE_DESCRI := CONCAT('SERIE FACTURACION ', YEAR(CURDATE()));

-- ============================================================
-- TIENDA INICIAL - código 0
-- ============================================================
INSERT INTO tiendas
  (T0,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11,T12,T13,T14,T15,T16,T17,T18)
SELECT
  0,
  NULLIF(@FLX_TIENDA_NOMBRE,''),
  NULLIF(@FLX_TIENDA_DIRECCION,''),
  NULLIF(@FLX_TIENDA_LOCALIDAD,''),
  NULLIF(@FLX_TIENDA_CP,''),
  NULLIF(@FLX_TIENDA_PROVINCIA,''),
  NULLIF(@FLX_TIENDA_TELEFONO,''),
  NULLIF(@FLX_TIENDA_FAX,''),
  NULLIF(@FLX_TIENDA_NIF,''),
  CURDATE(),
  CURDATE(),
  @FLX_SERIE,
  COALESCE(NULLIF(@FLX_DB_HOST,''),'localhost'),
  COALESCE(NULLIF(@FLX_DB_PORT,''),'3306'),
  NULL,NULL,NULL,NULL,NULL
WHERE NOT EXISTS (SELECT 1 FROM tiendas WHERE T0=0);

-- ============================================================
-- CLIENTE DE PASO / CONTADO
-- Basado en el registro real C0=999999, evitando copiar saldos
-- u otros datos históricos de una base en producción.
-- ============================================================
INSERT INTO clientes (C0,C1,C8,C16,C19)
SELECT 999999,'CLIENTES DE CONTADO',1,1,'N'
WHERE NOT EXISTS (SELECT 1 FROM clientes WHERE C0=999999);

-- ============================================================
-- ARTÍCULO VARIO
-- PVP 999,00; IVA 21%; PVP sin IVA 825,620 según registro real.
-- ============================================================
INSERT INTO artitien0000 (A0,A1,A2,A3,A21,A22)
SELECT '9999999999999','ARTICULOS VARIOS',999.000,21.00,825.620,'N'
WHERE NOT EXISTS (
  SELECT 1 FROM artitien0000 WHERE A0='9999999999999'
);

-- ============================================================
-- SERIE DE FACTURACIÓN DEL EJERCICIO ACTUAL
-- ============================================================
INSERT INTO seriesfactu (SF0,SF1)
SELECT @FLX_SERIE,@FLX_SERIE_DESCRI
WHERE NOT EXISTS (SELECT 1 FROM seriesfactu WHERE SF0=@FLX_SERIE);

-- ============================================================
-- FORMAS DE PAGO
-- ============================================================
INSERT INTO formapago (FPA0,FPA1)
SELECT 1,'CONTADO'
WHERE NOT EXISTS (SELECT 1 FROM formapago WHERE FPA0=1);

INSERT INTO formapago (FPA0,FPA1)
SELECT 2,'GIRO BANCARIO'
WHERE NOT EXISTS (SELECT 1 FROM formapago WHERE FPA0=2);

INSERT INTO formapago (FPA0,FPA1)
SELECT 3,'CHEQUE BANCARIO'
WHERE NOT EXISTS (SELECT 1 FROM formapago WHERE FPA0=3);

INSERT INTO formapago (FPA0,FPA1)
SELECT 4,'TRANSFERENCIA CC.: 2099'
WHERE NOT EXISTS (SELECT 1 FROM formapago WHERE FPA0=4);

INSERT INTO formapago (FPA0,FPA1)
SELECT 5,'TRANSFERENCIA CC.: 2100'
WHERE NOT EXISTS (SELECT 1 FROM formapago WHERE FPA0=5);

INSERT INTO formapago (FPA0,FPA1)
SELECT 6,'GIRO A 30 DIAS'
WHERE NOT EXISTS (SELECT 1 FROM formapago WHERE FPA0=6);

-- ============================================================
-- PUESTOS DE TRABAJO
-- ============================================================
INSERT INTO puestos0000 (PT0,PT1,PT2,PT3,PT4,PT5,PT6)
SELECT 'A','PUESTO A','','','','',''
WHERE NOT EXISTS (SELECT 1 FROM puestos0000 WHERE PT0='A');

INSERT INTO puestos0000 (PT0,PT1,PT2,PT3,PT4,PT5,PT6)
SELECT 'B','PUESTO B','','','','',''
WHERE NOT EXISTS (SELECT 1 FROM puestos0000 WHERE PT0='B');

INSERT INTO puestos0000 (PT0,PT1,PT2,PT3,PT4,PT5,PT6)
SELECT 'C','PUESTO C','','','','',''
WHERE NOT EXISTS (SELECT 1 FROM puestos0000 WHERE PT0='C');

-- ============================================================
-- RUTAS
-- La estructura actual es rutas0000(RUT0,RUT1).
-- ============================================================
INSERT INTO rutas0000 (RUT0,RUT1)
SELECT 1,'RUTA 1'
WHERE NOT EXISTS (SELECT 1 FROM rutas0000 WHERE RUT0=1);

INSERT INTO rutas0000 (RUT0,RUT1)
SELECT 2,'RUTA 2'
WHERE NOT EXISTS (SELECT 1 FROM rutas0000 WHERE RUT0=2);

-- ============================================================
-- TARIFAS
-- Se alinea ARTICULOS VARIOS con su código real actual:
-- 9999999999999 (no el antiguo 999999999).
-- ============================================================
INSERT INTO tarifas (TAR0,TAR1,TAR2,TAR3,TAR4,TAR5,TAR6,TAR7,TAR8,TAR9)
SELECT '1',0,0,0,0,0,0,0,0,0
WHERE NOT EXISTS (SELECT 1 FROM tarifas WHERE TAR0='1');

INSERT INTO tarifas (TAR0,TAR1,TAR2,TAR3,TAR4,TAR5,TAR6,TAR7,TAR8,TAR9)
SELECT '3',0,0,0,0,0,0,0,0,0
WHERE NOT EXISTS (SELECT 1 FROM tarifas WHERE TAR0='3');

INSERT INTO tarifas (TAR0,TAR1,TAR2,TAR3,TAR4,TAR5,TAR6,TAR7,TAR8,TAR9)
SELECT '4',0,0,0,0,0,0,0,0,0
WHERE NOT EXISTS (SELECT 1 FROM tarifas WHERE TAR0='4');

INSERT INTO tarifas (TAR0,TAR1,TAR2,TAR3,TAR4,TAR5,TAR6,TAR7,TAR8,TAR9)
SELECT '9999999999999',0,0,0,0,0,0,0,0,0
WHERE NOT EXISTS (SELECT 1 FROM tarifas WHERE TAR0='9999999999999');

INSERT INTO tarifas (TAR0,TAR1,TAR2,TAR3,TAR4,TAR5,TAR6,TAR7,TAR8,TAR9)
SELECT 'A1',0,0,0,0,0,0,0,0,0
WHERE NOT EXISTS (SELECT 1 FROM tarifas WHERE TAR0='A1');

-- ============================================================
-- USUARIO INICIAL
-- Se omite la antigua ruta Windows de imagen.
-- El usuario debe cambiar la clave tras el primer acceso.
-- ============================================================
INSERT INTO usuarios0000 (USU0,USU1,USU9,USU10,USU11,USU12,USU13)
SELECT 1,'USUARIO LINEX','LINEX','LINEX',0,'La clave inicial es LINEX\n',''
WHERE NOT EXISTS (SELECT 1 FROM usuarios0000 WHERE USU0=1);

-- roles0000: deliberadamente sin INSERT.
