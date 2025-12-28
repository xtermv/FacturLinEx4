CREATE TABLE IF NOT EXISTS `provincias` (
  `CODIGO` int(11) NOT NULL default '0' COMMENT 'Codigo INE de Provincia',
  `version` int(11) NOT NULL default '0' COMMENT 'Control de concurrencia',
  `NOMBRE` varchar(200) collate utf8_bin default NULL COMMENT 'Nombre de la provincia',
  `COD_PAIS` varchar(2) collate utf8_bin default NULL COMMENT 'Codigo del pa??s al que pertenece la provincia',
  PRIMARY KEY  (`CODIGO`),
  KEY `FKCC63A66C78BEBE8` (`COD_PAIS`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Tabla maestra de provincias';

--
-- Creando INSERT para tabla `provincias`
--

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('1','0','Alava','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('2','0','Albacete','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('3','0','Alicante/Alacant','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('4','0','Almería','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('5','0','Avila','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('6','0','Badajoz','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('7','0','Balears (Illes)','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('8','0','Barcelona','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('9','0','Burgos','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('10','0','Cáceres','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('11','0','Cádiz','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('12','0','Castellón/Castelló','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('13','0','Ciudad Real','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('14','0','Córdoba','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('15','0','Coruña (A)','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('16','0','Cuenca','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('17','0','Girona','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('18','0','Granada','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('19','0','Guadalajara','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('20','0','Guipúzcoa','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('21','0','Huelva','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('22','0','Huesca','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('23','0','Jaén','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('24','0','León','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('25','0','Lleida','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('26','0','Rioja (La)','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('27','0','Lugo','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('28','0','Madrid','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('29','0','Málaga','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('30','0','Murcia','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('31','0','Navarra','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('32','0','Ourense','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('33','0','Asturias','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('34','0','Palencia','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('35','0','Palmas (Las)','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('36','0','Pontevedra','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('37','0','Salamanca','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('38','0','Santa Cruz de Tenerife','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('39','0','Cantabria','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('40','0','Segovia','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('41','0','Sevilla','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('42','0','Soria','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('43','0','Tarragona','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('44','0','Teruel','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('45','0','Toledo','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('46','0','Valencia/València','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('47','0','Valladolid','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('48','0','Vizcaya','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('49','0','Zamora','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('50','0','Zaragoza','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('51','0','Ceuta','ES');

INSERT INTO provincias (CODIGO,version,NOMBRE,COD_PAIS) VALUES('52','0','Melilla','ES');

