-- Rectificativas paso 5: adaptar tablas ventasrectif0000A/B/C a multiventa.
-- IMPORTANTE: ejecutar para cada puesto/caja existente.
-- Si ya tienes datos de prueba, puedes vaciar antes estas tablas si no necesitas conservarlos.

ALTER TABLE ventasrectif0000A
  ADD COLUMN VR_TICKET INT NOT NULL DEFAULT 0 AFTER VR_ID;

ALTER TABLE ventasrectif0000B
  ADD COLUMN VR_TICKET INT NOT NULL DEFAULT 0 AFTER VR_ID;

ALTER TABLE ventasrectif0000C
  ADD COLUMN VR_TICKET INT NOT NULL DEFAULT 0 AFTER VR_ID;

-- Si la tabla fue creada con UNIQUE solo sobre VR_LINEA_VENTA, hay que quitarlo.
-- Si el nombre no existe en tu MariaDB, omite esa línea manualmente.
ALTER TABLE ventasrectif0000A DROP INDEX UK_VR_LINEA;
ALTER TABLE ventasrectif0000B DROP INDEX UK_VR_LINEA;
ALTER TABLE ventasrectif0000C DROP INDEX UK_VR_LINEA;

ALTER TABLE ventasrectif0000A
  ADD UNIQUE KEY UK_VR_TICKET_LINEA (VR_TICKET, VR_LINEA_VENTA),
  ADD KEY IDX_VR_TICKET (VR_TICKET);

ALTER TABLE ventasrectif0000B
  ADD UNIQUE KEY UK_VR_TICKET_LINEA (VR_TICKET, VR_LINEA_VENTA),
  ADD KEY IDX_VR_TICKET (VR_TICKET);

ALTER TABLE ventasrectif0000C
  ADD UNIQUE KEY UK_VR_TICKET_LINEA (VR_TICKET, VR_LINEA_VENTA),
  ADD KEY IDX_VR_TICKET (VR_TICKET);
