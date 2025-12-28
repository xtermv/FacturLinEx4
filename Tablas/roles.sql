#DROP TABLE roles0000;
CREATE TABLE roles0000
	(
	CgoRol INT(4) NOT NULL,
	DescriRol CHAR(50),
	Tiendas CHAR(10),
	Usuarios CHAR(10),
	Departa CHAR(10),
	Familias CHAR(10),
	Articulos CHAR(10),
	Clientes CHAR(10),
	Proveed CHAR(10),
	Formapag CHAR(10),
	Rutas CHAR(10),
	Fabrica CHAR(10),
	Envases CHAR(10),
	Puestos CHAR(10),
	Produccion CHAR(10),
	PRIMARY KEY krol (CgoRol),
        UNIQUE (CgoRol),
	INDEX krol (CgoRol)
	) ENGINE = InnoDB DEFAULT CHARSET=utf8;
