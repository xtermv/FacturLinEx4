 ALTER TABLE `fl2xaime`.`hisopcc0000` 
ADD COLUMN `HO19` VARCHAR(15) NULL DEFAULT NULL AFTER `HO18`;

//-----------------------------

ALTER TABLE `fl2xaime`.`factuc0000` 
ADD COLUMN `FC24` VARCHAR(15) NULL DEFAULT NULL AFTER `FC23`;

//------------------------------

update hisopcc0000 inner join clientes on C0=HO8 set HO19=C5;

//-------------------------------

update factuc0000 inner join clientes on C0=FC0 set FC24=C5;

//-------------------------------

CREATE TABLE `Mod347` (
  `CIF` char(15) NOT NULL,
  `RSocial` char(50) DEFAULT NULL,
  `Trimestre1` double(10,5) DEFAULT NULL,
  `Trimestre2` double(10,5) DEFAULT NULL,
  `Trimestre3` double(10,5) DEFAULT NULL,
  `Trimestre4` double(10,5) DEFAULT NULL,
  `Total` double(10,5) DEFAULT NULL,
  PRIMARY KEY (`CIF`) ) ENGINE=MyISAM DEFAULT CHARSET=utf8
