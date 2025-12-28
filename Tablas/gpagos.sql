CREATE TABLE IF NOT EXISTS gpagos0000 ( 
	Fecha DATE NOT NULL, 
	Importe DOUBLE(10,3) NOT NULL DEFAULT 0, 
	Concepto CHAR(50)  NOT NULL, 
	Observaciones BLOB,  
PRIMARY KEY kld (Fecha,Importe,Concepto), UNIQUE (Fecha,Importe,Concepto), INDEX kld (Fecha,Importe,Concepto)) ENGINE = InnoDB DEFAULT CHARSET=utf8;
