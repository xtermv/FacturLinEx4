-- Referencia documental. FacturLinEx lo aplica automáticamente una sola vez.
ALTER TABLE verifactu_queue
  ADD COLUMN origen VARCHAR(24) NOT NULL DEFAULT 'SIN_CLASIFICAR';

UPDATE verifactu_queue
SET origen='RECTIFICATIVA'
WHERE origen='SIN_CLASIFICAR'
  AND tipo_factura IN ('R1','R2','R3','R4','R5');
