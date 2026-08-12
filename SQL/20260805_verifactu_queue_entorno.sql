-- FacturLinEx 4.2.6 - separación PRUEBAS / PRODUCCION
-- Ejecutar una sola vez con todos los puestos cerrados.

ALTER TABLE verifactu_queue
  ADD COLUMN entorno VARCHAR(16) NOT NULL DEFAULT 'SIN_CLASIFICAR' AFTER tipo_factura;

CREATE INDEX idx_vf_entorno_fecha_estado
  ON verifactu_queue (entorno, fecha, estado);

-- IMPORTANTE: no se reclasifican automáticamente los registros históricos.
-- Deben permanecer SIN_CLASIFICAR hasta poder acreditar su origen.
