#DROP TABLE histstock0000;
CREATE TABLE histstock0000 
	(
  	fecha DATE  NOT NULL,
  	hora TIME  NOT NULL,
  	puesto CHAR(2)  NOT NULL,
  	codigo CHAR(13)  NOT NULL,
  	descripcion CHAR(50) ,
  	stock DOUBLE(10,4) ,
  	stockmin DOUBLE(10,4) ,
  	stockmax DOUBLE(10,4) ,
  	PRIMARY KEY (fecha, hora, puesto, codigo)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
