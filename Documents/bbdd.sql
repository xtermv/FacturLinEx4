-- MySQL dump 10.11
--
-- Host: localhost    Database: facturlinex2
-- ------------------------------------------------------
-- Server version	5.0.75-1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `albac0000`
--

DROP TABLE IF EXISTS `albac0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `albac0000` (
  `AC0` int(11) NOT NULL default '0',
  `AC1` date NOT NULL,
  `AC2` char(2) character set latin1 NOT NULL,
  `AC3` int(7) NOT NULL default '0',
  `AC4` int(4) NOT NULL default '0',
  `AC5` double(10,2) NOT NULL default '0.00',
  `AC6` double(5,2) NOT NULL default '0.00',
  `AC7` char(1) character set latin1 NOT NULL default 'N',
  `AC8` double(10,2) NOT NULL default '0.00',
  `AC9` double(10,2) NOT NULL default '0.00',
  `AC10` char(1) character set latin1 NOT NULL default 'N',
  `AC11` blob,
  PRIMARY KEY  (`AC0`,`AC1`,`AC2`,`AC3`),
  UNIQUE KEY `AC0` (`AC0`,`AC1`,`AC2`,`AC3`),
  KEY `kac` (`AC0`,`AC1`,`AC2`,`AC3`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `albac0000`
--

LOCK TABLES `albac0000` WRITE;
/*!40000 ALTER TABLE `albac0000` DISABLE KEYS */;
INSERT INTO `albac0000` VALUES (1,'2008-05-19','A',1,2,2.00,0.00,'',300.00,348.00,'N',NULL),(1,'2008-06-10','A',14,2,2.00,0.00,'',300.00,348.00,'N',NULL),(2,'2008-05-19','A',2,2,2.00,0.00,'S',400.00,464.00,'N','Observaciones del albaran 2'),(2,'2008-05-20','A',3,3,25.00,0.00,'S',3500.00,4060.00,'N',NULL),(2,'2008-05-27','A',8,2,2.00,0.00,'S',300.00,348.00,'N',NULL),(2,'2008-05-27','A',9,2,2.00,0.00,'S',300.00,348.00,'N',NULL),(2,'2008-05-27','A',10,2,2.00,0.00,'S',300.00,348.00,'N',NULL),(2,'2008-05-27','A',11,2,2.00,0.00,'S',300.00,348.00,'N',NULL),(2,'2008-05-27','A',12,2,2.00,0.00,'S',300.00,348.00,'N',NULL),(3,'2008-05-27','A',5,4,4.00,0.00,'',600.00,696.00,'N',NULL),(3,'2008-05-27','A',6,4,4.00,0.00,'',600.00,696.00,'N',NULL),(3,'2008-05-27','A',7,4,4.00,0.00,'',600.00,696.00,'N',NULL),(3,'2008-05-27','A',13,2,2.00,0.00,'',300.00,348.00,'N',NULL);
/*!40000 ALTER TABLE `albac0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `albad0000`
--

DROP TABLE IF EXISTS `albad0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `albad0000` (
  `AD0` int(11) NOT NULL default '0',
  `AD1` date NOT NULL,
  `AD2` char(2) character set latin1 NOT NULL,
  `AD3` int(7) NOT NULL default '0',
  `AD4` int(4) NOT NULL auto_increment,
  `AD5` char(13) character set latin1 default NULL,
  `AD6` blob,
  `AD7` double(10,2) NOT NULL default '0.00',
  `AD8` double(10,3) NOT NULL default '0.000',
  `AD9` double(10,3) NOT NULL default '0.000',
  `AD10` double(5,3) NOT NULL default '0.000',
  `AD11` double(10,3) NOT NULL default '0.000',
  `AD12` int(3) NOT NULL default '0',
  `AD13` double(10,3) NOT NULL default '0.000',
  `AD14` char(23) character set latin1 default NULL,
  `AD15` char(1) character set latin1 NOT NULL default 'A',
  `AD16` char(100) character set latin1 default NULL,
  PRIMARY KEY  (`AD0`,`AD1`,`AD2`,`AD3`,`AD4`),
  UNIQUE KEY `AD0` (`AD0`,`AD1`,`AD2`,`AD3`,`AD4`),
  KEY `kad` (`AD0`,`AD1`,`AD2`,`AD3`,`AD4`),
  KEY `kad1` (`AD4`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `albad0000`
--

LOCK TABLES `albad0000` WRITE;
/*!40000 ALTER TABLE `albad0000` DISABLE KEYS */;
INSERT INTO `albad0000` VALUES (1,'2008-05-19','A',1,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(1,'2008-05-19','A',1,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(1,'2008-06-10','A',14,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(1,'2008-06-10','A',14,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(2,'2008-05-19','A',2,1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(2,'2008-05-19','A',2,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(2,'2008-05-20','A',3,1,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,NULL,'A',NULL),(2,'2008-05-20','A',3,2,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,NULL,'A',NULL),(2,'2008-05-20','A',3,3,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,NULL,'A',NULL),(2,'2008-05-27','A',8,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(2,'2008-05-27','A',8,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(2,'2008-05-27','A',9,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(2,'2008-05-27','A',9,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(2,'2008-05-27','A',10,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(2,'2008-05-27','A',10,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(2,'2008-05-27','A',11,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(2,'2008-05-27','A',11,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(2,'2008-05-27','A',12,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(2,'2008-05-27','A',12,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(3,'2008-05-27','A',5,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(3,'2008-05-27','A',5,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(3,'2008-05-27','A',5,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(3,'2008-05-27','A',5,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(3,'2008-05-27','A',6,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(3,'2008-05-27','A',6,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(3,'2008-05-27','A',6,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(3,'2008-05-27','A',6,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(3,'2008-05-27','A',7,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(3,'2008-05-27','A',7,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(3,'2008-05-27','A',7,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(3,'2008-05-27','A',7,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL),(3,'2008-05-27','A',13,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(3,'2008-05-27','A',13,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A',NULL);
/*!40000 ALTER TABLE `albad0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `arqueos0000`
--

DROP TABLE IF EXISTS `arqueos0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `arqueos0000` (
  `fecha` date NOT NULL default '0000-00-00',
  `CAJA` char(1) character set latin1 NOT NULL default 'A',
  `C2E` int(3) default '0',
  `C1E` int(3) default '0',
  `C05E` int(3) default '0',
  `C02E` int(3) default '0',
  `C01E` int(3) default '0',
  `C005E` int(3) default '0',
  `C002E` int(3) default '0',
  `C001E` int(3) default '0',
  `C500E` int(3) default '0',
  `C200E` int(3) default '0',
  `C100E` int(3) default '0',
  `C50E` int(3) default '0',
  `C20E` int(3) default '0',
  `C10E` int(3) default '0',
  `C5E` int(3) default '0',
  `CTALONES` double(6,3) unsigned default '0.000',
  `CTARJETAS` double(6,3) default '0.000',
  `FDESDE` date default '0000-00-00',
  `FHASTA` date default '0000-00-00',
  `FCAMBIO` date default '0000-00-00',
  `IEFECTIVO` double(6,2) default '0.00',
  `ITT` double(6,2) default '0.00',
  `NTT` int(3) default '0',
  `CANT` double(6,2) default '0.00',
  `TOTALC` double(6,2) default '0.00',
  `ENTREGAS` double(6,2) default '0.00',
  `DEUDASP` double(6,2) default '0.00',
  `NALB` int(3) default '0',
  `INCIDENCIA` blob,
  PRIMARY KEY  (`fecha`,`CAJA`),
  UNIQUE KEY `FECHA` (`fecha`,`CAJA`),
  KEY `kgr` (`fecha`,`CAJA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `arqueos0000`
--

LOCK TABLES `arqueos0000` WRITE;
/*!40000 ALTER TABLE `arqueos0000` DISABLE KEYS */;
/*!40000 ALTER TABLE `arqueos0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artitien0000`
--

DROP TABLE IF EXISTS `artitien0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `artitien0000` (
  `A0` char(13) character set latin1 NOT NULL,
  `A1` char(50) character set latin1 default NULL,
  `A2` double(10,2) NOT NULL default '0.00',
  `A3` int(3) NOT NULL default '0',
  `A4` double(10,4) NOT NULL default '0.0000',
  `A5` double(10,4) NOT NULL default '0.0000',
  `A6` double(10,4) NOT NULL default '0.0000',
  `A7` double(5,2) NOT NULL default '0.00',
  `A8` double(5,2) NOT NULL default '0.00',
  `A9` double(5,2) NOT NULL default '0.00',
  `A10` double(10,2) NOT NULL default '0.00',
  `A11` double(10,2) NOT NULL default '0.00',
  `A12` date default NULL,
  `A13` date default NULL,
  `A14` int(4) NOT NULL default '0',
  `A15` char(6) character set latin1 default NULL,
  `A16` char(150) character set latin1 default NULL,
  `A17` blob,
  `A18` char(5) character set latin1 default NULL,
  `A19` char(13) character set latin1 default NULL,
  `A20` int(6) NOT NULL default '0',
  `A21` double(10,3) NOT NULL default '0.000',
  `A22` char(1) character set latin1 NOT NULL default 'N',
  `A23` char(50) character set latin1 default NULL,
  `A24` double(10,3) NOT NULL default '0.000',
  `A25` double(10,3) NOT NULL default '0.000',
  `A26` double(10,3) NOT NULL default '0.000',
  `A27` int(5) NOT NULL default '0',
  `A28` double(10,2) NOT NULL default '0.00',
  `A29` double(10,2) NOT NULL default '0.00',
  `A30` double(5,2) NOT NULL default '0.00',
  `A31` double(5,2) NOT NULL default '0.00',
  `A32` int(11) NOT NULL default '0',
  `A33` int(11) NOT NULL default '0',
  `A34` varchar(20) character set latin1 default NULL,
  PRIMARY KEY  (`A0`),
  UNIQUE KEY `A0` (`A0`),
  KEY `ka` (`A0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `artitien0000`
--

LOCK TABLES `artitien0000` WRITE;
/*!40000 ALTER TABLE `artitien0000` DISABLE KEYS */;
INSERT INTO `artitien0000` VALUES ('1','ARTICULO 1',116.00,16,1229.0000,5.0000,15.0000,0.00,0.00,0.00,0.00,-83.00,'2009-01-05','2008-09-02',1,NULL,'/home/nicolas/FacturLinEx/imagenes/facturar.png',NULL,NULL,'1',1,100.000,'N','ESTANT 1',80.000,80.000,25.000,0,0.00,0.00,0.00,0.00,3,0,NULL),('2','ARTICULO 2',2.60,16,12.0000,0.0000,0.0000,0.00,0.00,0.00,0.00,-26.00,'2009-01-05','2008-09-02',1,NULL,NULL,NULL,NULL,NULL,0,2.241,'N',NULL,1.500,1.500,49.425,0,0.00,0.00,0.00,0.00,3,0,NULL),('3','ARTICULO 3',174.00,16,97.0000,10.0000,100.0000,0.00,0.00,0.00,0.00,-2.00,'2008-12-20','2008-09-02',1,NULL,'',NULL,NULL,'',0,150.000,'N','',80.000,0.000,87.500,0,0.00,0.00,0.00,0.00,3,0,NULL),('4','ARTICULO 4',230.00,7,199.0000,0.0000,0.0000,0.00,0.00,0.00,0.00,-201.00,'2008-12-20','2008-09-02',2,NULL,'',NULL,NULL,'',0,214.953,'N','',1.320,1.317,16184.318,0,0.00,0.00,0.00,0.00,3,0,NULL),('999999999','ARTICULOS VARIOS',0.00,0,-2.0000,0.0000,0.0000,0.00,0.00,0.00,0.00,0.00,'2009-01-16',NULL,0,NULL,'',NULL,NULL,'',0,0.000,'N','',0.000,0.000,0.000,0,0.00,0.00,0.00,0.00,0,0,NULL),('A1','ARTICULO CON LETRAS',116.00,16,-10.0000,0.0000,0.0000,0.00,0.00,0.00,0.00,0.00,'2008-12-20',NULL,0,NULL,'',NULL,NULL,'',0,100.000,'N','',0.000,0.000,0.000,0,0.00,0.00,0.00,0.00,0,0,NULL);
/*!40000 ALTER TABLE `artitien0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `autofabri`
--

DROP TABLE IF EXISTS `autofabri`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `autofabri` (
  `AUT0` int(4) NOT NULL default '0',
  `AUT1` char(50) character set latin1 default NULL,
  PRIMARY KEY  (`AUT0`),
  UNIQUE KEY `AUT0` (`AUT0`),
  KEY `kaut` (`AUT0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `autofabri`
--

LOCK TABLES `autofabri` WRITE;
/*!40000 ALTER TABLE `autofabri` DISABLE KEYS */;
INSERT INTO `autofabri` VALUES (1,'FABRICANTE 1'),(2,'FABRICANTE 2');
/*!40000 ALTER TABLE `autofabri` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cajas0000`
--

DROP TABLE IF EXISTS `cajas0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cajas0000` (
  `CA0` date NOT NULL,
  `CA1` int(4) NOT NULL,
  `CA2` char(2) character set latin1 NOT NULL default 'A',
  `CA3` int(4) NOT NULL,
  `CA4` double(10,2) default '0.00',
  `CA5` double(10,2) default '0.00',
  `CA6` double(10,2) default '0.00',
  `CA7` double(10,2) default '0.00',
  `CA8` double(10,2) default '0.00',
  `CA9` double(10,2) default '0.00',
  `CA10` double(10,2) default '0.00',
  `CA11` double(10,2) default '0.00',
  `CA12` double(10,2) default '0.00',
  `CA13` double(10,2) default '0.00',
  `CA14` double(10,2) default '0.00',
  `CA15` double(10,2) default '0.00',
  `CA16` double(10,2) default '0.00',
  `CA17` double(10,2) default '0.00',
  `CA18` double(10,2) default '0.00',
  `CA19` double(10,2) default '0.00',
  `CA20` double(10,2) default '0.00',
  `CA21` double(10,2) default '0.00',
  `CA22` double(10,2) default '0.00',
  `CA23` double(10,2) default '0.00',
  `CA24` double(10,2) default '0.00',
  PRIMARY KEY  (`CA0`,`CA1`,`CA2`,`CA3`),
  UNIQUE KEY `CA0` (`CA0`,`CA1`,`CA2`,`CA3`),
  KEY `kca` (`CA0`,`CA1`,`CA2`,`CA3`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `cajas0000`
--

LOCK TABLES `cajas0000` WRITE;
/*!40000 ALTER TABLE `cajas0000` DISABLE KEYS */;
INSERT INTO `cajas0000` VALUES ('2008-09-02',1,'A',1,3.00,348.00,0.00,0.00,240.00,0.00,0.00,0.00,0.00,0.00,0.00,108.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-09-02',1,'A',2,3.00,696.00,0.00,0.00,450.00,0.00,0.00,0.00,0.00,0.00,0.00,246.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-09-03',1,'A',2,2.00,464.00,0.00,0.00,300.00,0.00,0.00,0.00,0.00,0.00,0.00,164.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-09-04',1,'A',1,3.00,348.00,0.00,0.00,240.00,0.00,0.00,0.00,0.00,0.00,0.00,108.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-09-04',1,'A',2,3.00,696.00,0.00,0.00,450.00,0.00,0.00,0.00,0.00,0.00,0.00,246.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-10-15',1,'A',1,8.00,464.00,0.00,0.00,561.50,0.00,0.00,0.00,0.00,0.00,0.00,-97.50,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-10-29',1,'A',1,3.00,522.00,0.00,0.00,161.50,0.00,0.00,0.00,0.00,0.00,0.00,360.50,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-11-05',1,'A',1,4.00,237.20,-1.00,-116.00,83.00,0.00,0.00,0.00,0.00,0.00,0.00,38.20,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-11-06',1,'A',1,3.00,348.00,0.00,0.00,240.00,0.00,0.00,0.00,0.00,0.00,0.00,108.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-12-03',1,'A',1,4.00,295.20,0.00,0.00,163.00,0.00,0.00,0.00,0.00,0.00,0.00,132.20,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-12-08',1,'A',1,9.00,648.40,0.00,0.00,406.00,0.00,0.00,0.00,0.00,0.00,0.00,242.40,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-12-18',1,'A',1,4.00,464.00,0.00,0.00,320.00,0.00,0.00,0.00,0.00,0.00,0.00,144.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-12-19',1,'A',0,5.00,580.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,580.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-12-19',1,'A',1,7.00,529.80,-1.00,-116.00,244.50,0.00,0.00,0.00,0.00,0.00,0.00,169.30,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-12-19',1,'A',9999,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,529.80,161.20,150.00,0.00,0.00),('2008-12-20',1,'A',0,1.00,116.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,116.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-12-20',1,'A',1,1.00,174.00,0.00,0.00,80.00,0.00,0.00,0.00,0.00,0.00,0.00,94.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-12-20',1,'A',2,2.00,4.62,0.00,0.00,2.64,0.00,0.00,0.00,0.00,0.00,0.00,1.98,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00),('2008-12-20',1,'A',9999,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,294.62,0.00,200.00,0.00,0.00);
/*!40000 ALTER TABLE `cajas0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cambios`
--

DROP TABLE IF EXISTS `cambios`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `cambios` (
  `CA0` varchar(13) NOT NULL,
  `CA1` varchar(50) default NULL,
  `CA2` double(10,2) default NULL,
  PRIMARY KEY  (`CA0`),
  UNIQUE KEY `CA0` (`CA0`),
  KEY `kca` (`CA0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `cambios`
--

LOCK TABLES `cambios` WRITE;
/*!40000 ALTER TABLE `cambios` DISABLE KEYS */;
INSERT INTO `cambios` VALUES ('1','ARTICULO NUMERO 1',116.00),('2','ARTICULO NUMERO 2 ARTI 2 ARTI2',200.00),('3','ARTIVULO 3',232.00);
/*!40000 ALTER TABLE `cambios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `clientes` (
  `C0` int(11) NOT NULL,
  `C1` char(50) character set latin1 default NULL,
  `C2` char(50) character set latin1 default NULL,
  `C3` char(50) character set latin1 default NULL,
  `C4` char(50) character set latin1 default NULL,
  `C5` char(15) character set latin1 default NULL,
  `C6` char(20) character set latin1 default NULL,
  `C7` char(20) character set latin1 default NULL,
  `C8` int(2) default '0',
  `C9` int(2) default '0',
  `C10` int(7) NOT NULL default '0',
  `C11` int(2) default '0',
  `C12` char(10) character set latin1 default NULL,
  `C13` int(3) default '0',
  `C14` int(3) default '0',
  `C15` int(3) default '0',
  `C16` int(1) default '0',
  `C17` double(5,2) default '0.00',
  `C18` double(5,2) default '0.00',
  `C19` char(1) character set latin1 default NULL,
  `C20` double(10,2) default '0.00',
  `C21` double(10,2) default '0.00',
  `C22` double(10,2) default '0.00',
  `C23` double(10,2) default '0.00',
  `C24` double(10,2) default '0.00',
  `C25` char(50) character set latin1 default NULL,
  `C26` char(1) character set latin1 default NULL,
  `C27` char(50) character set latin1 default NULL,
  `C28` char(50) character set latin1 default NULL,
  `C29` int(11) default '0',
  `C30` char(50) character set latin1 default NULL,
  `C31` char(20) character set latin1 default NULL,
  `C32` char(50) character set latin1 default NULL,
  `C33` char(50) character set latin1 default NULL,
  `C34` char(20) character set latin1 default NULL,
  `C35` char(20) character set latin1 default NULL,
  `C36` blob,
  `C37` char(6) character set latin1 default NULL,
  `C38` char(50) character set latin1 default NULL,
  `C39` char(50) character set latin1 default NULL,
  `C40` char(50) character set latin1 default NULL,
  `C41` int(1) NOT NULL default '0',
  `C42` int(1) NOT NULL default '0',
  `C43` int(1) NOT NULL default '0',
  `C44` date default NULL,
  `C45` double(10,2) NOT NULL default '0.00',
  `C46` int(11) NOT NULL default '0',
  `C47` varchar(20) character set latin1 default NULL,
  PRIMARY KEY  (`C0`),
  UNIQUE KEY `C0` (`C0`),
  KEY `kc` (`C0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'GARCIA PEREZ, JUAN JOSE','','AVDA. ANTONIO MASA CAMPOS, 10','BADAJOZ','11111111-A','924111111','924112211',0,1,1,8,'',0,0,0,0,0.00,0.00,'',-16162.48,350.00,0.00,0.00,0.00,'','','','',0,'','','','','','',NULL,'06011','BADAJOZ','','correo@cliente1.es',0,0,0,'2008-12-20',200.00,0,NULL),(2,'CLIENTE 2','REPRESENTANTE CLIENTE 2','DIRECCION 2','LOCALIDAD 2','22222222-B','924222222','924221122',0,0,0,0,'',0,0,0,0,0.00,0.00,'S',-93960.00,0.00,0.00,0.00,0.00,'','','','',0,'','','','','','',NULL,'06002','PROVINCIA 2','','correo@cliente2.es',0,0,0,NULL,0.00,0,NULL),(3,'CLIENTE NUMERO 3','','DIRECCION 3','LOCALIDAD 3','03030303-Q','','',0,1,1,0,'',30,30,3,0,0.00,0.00,'',-38976.00,0.00,0.00,0.00,0.00,'','','','',0,'','','','','','',NULL,'06003','PROVINCIA 3','','',0,0,0,NULL,0.00,0,NULL),(4,'CLIENTE NUMERO 4','','','','','','',0,0,0,0,'',0,0,0,0,0.00,0.00,'',0.00,0.00,0.00,0.00,0.00,'','','','',0,'','','','','','',NULL,'','','','',0,0,0,NULL,0.00,0,NULL),(999999,'CLIENTES VARIOS','','DIRECCION CLIENTES VARIOS','','','','',0,0,0,0,'',0,0,0,0,0.00,0.00,'',0.00,0.00,0.00,0.00,0.00,'','','','',0,'','','','','','',NULL,'','','','',0,0,0,NULL,0.00,0,NULL);
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `creditos0000`
--

DROP TABLE IF EXISTS `creditos0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `creditos0000` (
  `CRE0` int(6) NOT NULL,
  `CRE1` date NOT NULL,
  `CRE2` time NOT NULL,
  `CRE3` char(2) character set latin1 NOT NULL,
  `CRE4` char(2) character set latin1 NOT NULL,
  `CRE5` int(7) NOT NULL,
  `CRE6` char(100) character set latin1 default NULL,
  `CRE7` double(10,2) default '0.00',
  `CRE8` double(10,2) default '0.00',
  `CRE9` char(1) character set latin1 default 'N',
  `CRE10` int(4) default NULL,
  `CRE11` blob,
  PRIMARY KEY  (`CRE0`,`CRE1`,`CRE2`,`CRE3`,`CRE4`,`CRE5`),
  UNIQUE KEY `CRE0` (`CRE0`,`CRE1`,`CRE2`,`CRE3`,`CRE4`,`CRE5`),
  KEY `kcre` (`CRE0`,`CRE1`,`CRE2`,`CRE3`,`CRE4`,`CRE5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `creditos0000`
--

LOCK TABLES `creditos0000` WRITE;
/*!40000 ALTER TABLE `creditos0000` DISABLE KEYS */;
INSERT INTO `creditos0000` VALUES (1,'2008-12-19','16:38:33','NS','A',36,'ARTICULO 1, ARTICULO CON LE, ARTICULO 2,',234.60,0.00,'N',0,''),(1,'2008-12-19','16:56:01','EN','A',37,'ENTREGA A CUENTA',0.00,100.00,'N',0,''),(1,'2008-12-19','16:59:21','NS','A',38,'ARTICULO 2, ARTICULO 2, ARTICULO 3,',179.20,0.00,'N',0,''),(1,'2008-12-19','16:59:33','NS','A',39,'ARTICULO 1,',116.00,0.00,'N',0,''),(1,'2008-12-20','17:24:28','NS','A',40,'ARTICULO 4, ARTICULO 3, ARTICULO 4, ARTICULO CON LE,',294.62,0.00,'N',0,''),(1,'2008-12-20','17:24:41','EN','A',41,'ENTREGA A CUENTA',0.00,200.00,'N',0,'');
/*!40000 ALTER TABLE `creditos0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departamentos0000`
--

DROP TABLE IF EXISTS `departamentos0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `departamentos0000` (
  `D0` int(4) NOT NULL,
  `D1` char(50) character set latin1 default NULL,
  `D2` date default NULL,
  `D3` date default NULL,
  `D4` blob,
  PRIMARY KEY  (`D0`),
  UNIQUE KEY `D0` (`D0`),
  KEY `kd` (`D0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `departamentos0000`
--

LOCK TABLES `departamentos0000` WRITE;
/*!40000 ALTER TABLE `departamentos0000` DISABLE KEYS */;
INSERT INTO `departamentos0000` VALUES (1,'DEPARTAMENTO 1','2009-01-05','2008-09-02',NULL),(2,'DEPARTAMENTO 2','2008-12-20','2008-09-02',NULL);
/*!40000 ALTER TABLE `departamentos0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `distinti`
--

DROP TABLE IF EXISTS `distinti`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `distinti` (
  `DIS0` int(7) NOT NULL default '0',
  `DIS1` char(50) character set latin1 default NULL,
  `DIS2` char(50) character set latin1 default NULL,
  `DIS3` char(50) character set latin1 default NULL,
  PRIMARY KEY  (`DIS0`),
  UNIQUE KEY `DIS0` (`DIS0`),
  KEY `kprf` (`DIS0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `distinti`
--

LOCK TABLES `distinti` WRITE;
/*!40000 ALTER TABLE `distinti` DISABLE KEYS */;
/*!40000 ALTER TABLE `distinti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eans`
--

DROP TABLE IF EXISTS `eans`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `eans` (
  `EAN0` char(13) character set latin1 NOT NULL,
  `EAN1` char(13) character set latin1 NOT NULL,
  `EAN2` char(50) character set latin1 default NULL,
  `EAN3` double(10,4) NOT NULL default '0.0000',
  `EAN4` double(10,2) NOT NULL default '0.00',
  `EAN5` double(10,5) NOT NULL default '0.00000',
  PRIMARY KEY  (`EAN0`,`EAN1`),
  UNIQUE KEY `EAN0` (`EAN0`,`EAN1`),
  KEY `kean` (`EAN0`,`EAN1`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `eans`
--

LOCK TABLES `eans` WRITE;
/*!40000 ALTER TABLE `eans` DISABLE KEYS */;
INSERT INTO `eans` VALUES ('11','1','CAJA ARTICULO 1',6.0000,0.00,6.00000);
/*!40000 ALTER TABLE `eans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `envas`
--

DROP TABLE IF EXISTS `envas`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `envas` (
  `EN0` char(13) character set latin1 NOT NULL,
  `EN1` char(50) character set latin1 default NULL,
  `EN2` double(10,3) NOT NULL default '0.000',
  `EN3` double(10,3) NOT NULL default '0.000',
  `EN4` double(10,3) NOT NULL default '0.000',
  `EN5` int(3) NOT NULL default '0',
  `EN6` double(10,3) NOT NULL default '0.000',
  `EN7` int(10) NOT NULL default '0',
  `EN8` int(10) NOT NULL default '0',
  `EN9` int(10) NOT NULL default '0',
  `EN10` int(10) NOT NULL default '0',
  `EN11` date default NULL,
  `EN12` date default NULL,
  `EN13` int(11) default NULL,
  PRIMARY KEY  (`EN0`),
  UNIQUE KEY `EN0` (`EN0`),
  KEY `ke` (`EN0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `envas`
--

LOCK TABLES `envas` WRITE;
/*!40000 ALTER TABLE `envas` DISABLE KEYS */;
INSERT INTO `envas` VALUES ('1','ENVASE 1',1.000,50.900,1.509,16,1.750,100,10,100,1,NULL,NULL,1),('2','ENVASE 3',10.000,29.310,12.931,16,15.000,10,10,100,1,NULL,NULL,1);
/*!40000 ALTER TABLE `envas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estaarti0000`
--

DROP TABLE IF EXISTS `estaarti0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `estaarti0000` (
  `TA0` char(13) character set latin1 NOT NULL,
  `TA1` int(4) NOT NULL,
  `TA2` int(2) NOT NULL,
  `TA3` double(10,2) default '0.00',
  `TA4` double(10,2) default '0.00',
  `TA5` double(10,4) default '0.0000',
  `TA6` double(10,2) default '0.00',
  `TA7` double(10,2) default '0.00',
  PRIMARY KEY  (`TA0`,`TA1`,`TA2`),
  UNIQUE KEY `TA0` (`TA0`,`TA1`,`TA2`),
  KEY `kta` (`TA0`,`TA1`,`TA2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `estaarti0000`
--

LOCK TABLES `estaarti0000` WRITE;
/*!40000 ALTER TABLE `estaarti0000` DISABLE KEYS */;
INSERT INTO `estaarti0000` VALUES ('1',2008,1,0.00,0.00,0.0000,0.00,0.00),('1',2008,2,0.00,0.00,0.0000,0.00,0.00),('1',2008,3,0.00,0.00,0.0000,0.00,0.00),('1',2008,4,0.00,0.00,0.0000,0.00,0.00),('1',2008,5,0.00,0.00,126.0000,12798.00,8320.00),('1',2008,6,0.00,0.00,82.0000,8180.00,6560.00),('1',2008,7,0.00,0.00,0.0000,0.00,0.00),('1',2008,8,0.00,0.00,0.0000,0.00,0.00),('1',2008,9,0.00,0.00,7.0000,700.00,560.00),('1',2008,10,0.00,0.00,8.0000,300.00,640.00),('1',2008,11,0.00,0.00,4.0000,400.00,320.00),('1',2008,12,6.00,480.00,11.0000,1100.00,880.00),('1',2009,1,1329.00,106320.00,1.0000,100.00,80.00),('1',2009,2,0.00,0.00,0.0000,0.00,0.00),('1',2009,3,0.00,0.00,0.0000,0.00,0.00),('1',2009,4,0.00,0.00,0.0000,0.00,0.00),('1',2009,5,0.00,0.00,0.0000,0.00,0.00),('1',2009,6,0.00,0.00,0.0000,0.00,0.00),('1',2009,7,0.00,0.00,0.0000,0.00,0.00),('1',2009,8,0.00,0.00,0.0000,0.00,0.00),('1',2009,9,0.00,0.00,0.0000,0.00,0.00),('1',2009,10,0.00,0.00,0.0000,0.00,0.00),('1',2009,11,0.00,0.00,0.0000,0.00,0.00),('1',2009,12,0.00,0.00,0.0000,0.00,0.00),('2',2008,1,0.00,0.00,0.0000,0.00,0.00),('2',2008,2,0.00,0.00,0.0000,0.00,0.00),('2',2008,3,0.00,0.00,0.0000,0.00,0.00),('2',2008,4,0.00,0.00,0.0000,0.00,0.00),('2',2008,5,0.00,0.00,82.2300,16645.00,10984.50),('2',2008,6,0.00,0.00,51.0000,10200.00,7650.00),('2',2008,7,0.00,0.00,0.0000,0.00,0.00),('2',2008,8,0.00,0.00,0.0000,0.00,0.00),('2',2008,9,0.00,0.00,9.0000,1800.00,1350.00),('2',2008,10,0.00,0.00,2.0000,400.00,3.00),('2',2008,11,0.00,0.00,2.0000,4.48,3.00),('2',2008,12,20.00,30.00,9.0000,20.16,13.50),('2',2009,1,6.00,9.00,1.0000,2.24,1.50),('2',2009,2,0.00,0.00,0.0000,0.00,0.00),('2',2009,3,0.00,0.00,0.0000,0.00,0.00),('2',2009,4,0.00,0.00,0.0000,0.00,0.00),('2',2009,5,0.00,0.00,0.0000,0.00,0.00),('2',2009,6,0.00,0.00,0.0000,0.00,0.00),('2',2009,7,0.00,0.00,0.0000,0.00,0.00),('2',2009,8,0.00,0.00,0.0000,0.00,0.00),('2',2009,9,0.00,0.00,0.0000,0.00,0.00),('2',2009,10,0.00,0.00,0.0000,0.00,0.00),('2',2009,11,0.00,0.00,0.0000,0.00,0.00),('2',2009,12,0.00,0.00,0.0000,0.00,0.00),('3',2008,1,0.00,0.00,0.0000,0.00,0.00),('3',2008,2,0.00,0.00,0.0000,0.00,0.00),('3',2008,3,0.00,0.00,0.0000,0.00,0.00),('3',2008,4,0.00,0.00,0.0000,0.00,0.00),('3',2008,5,0.00,0.00,0.0000,0.00,0.00),('3',2008,6,0.00,0.00,0.0000,0.00,0.00),('3',2008,7,0.00,0.00,0.0000,0.00,0.00),('3',2008,8,0.00,0.00,0.0000,0.00,0.00),('3',2008,9,0.00,0.00,0.0000,0.00,0.00),('3',2008,10,0.00,0.00,1.0000,150.00,80.00),('3',2008,11,0.00,0.00,0.0000,0.00,0.00),('3',2008,12,0.00,0.00,4.0000,600.00,320.00),('3',2009,1,2.00,160.00,0.0000,0.00,0.00),('3',2009,2,0.00,0.00,0.0000,0.00,0.00),('3',2009,3,0.00,0.00,0.0000,0.00,0.00),('3',2009,4,0.00,0.00,0.0000,0.00,0.00),('3',2009,5,0.00,0.00,0.0000,0.00,0.00),('3',2009,6,0.00,0.00,0.0000,0.00,0.00),('3',2009,7,0.00,0.00,0.0000,0.00,0.00),('3',2009,8,0.00,0.00,0.0000,0.00,0.00),('3',2009,9,0.00,0.00,0.0000,0.00,0.00),('3',2009,10,0.00,0.00,0.0000,0.00,0.00),('3',2009,11,0.00,0.00,0.0000,0.00,0.00),('3',2009,12,0.00,0.00,0.0000,0.00,0.00),('4',2008,1,0.00,0.00,0.0000,0.00,0.00),('4',2008,2,0.00,0.00,0.0000,0.00,0.00),('4',2008,3,0.00,0.00,0.0000,0.00,0.00),('4',2008,4,0.00,0.00,0.0000,0.00,0.00),('4',2008,5,0.00,0.00,0.0000,0.00,0.00),('4',2008,6,0.00,0.00,0.0000,0.00,0.00),('4',2008,7,0.00,0.00,0.0000,0.00,0.00),('4',2008,8,0.00,0.00,0.0000,0.00,0.00),('4',2008,9,0.00,0.00,0.0000,0.00,0.00),('4',2008,10,0.00,0.00,0.0000,0.00,0.00),('4',2008,11,0.00,0.00,0.0000,0.00,0.00),('4',2008,12,200.00,264.00,2.0000,4.32,2.64),('4',2009,1,1.00,1.32,0.0000,0.00,0.00),('4',2009,2,0.00,0.00,0.0000,0.00,0.00),('4',2009,3,0.00,0.00,0.0000,0.00,0.00),('4',2009,4,0.00,0.00,0.0000,0.00,0.00),('4',2009,5,0.00,0.00,0.0000,0.00,0.00),('4',2009,6,0.00,0.00,0.0000,0.00,0.00),('4',2009,7,0.00,0.00,0.0000,0.00,0.00),('4',2009,8,0.00,0.00,0.0000,0.00,0.00),('4',2009,9,0.00,0.00,0.0000,0.00,0.00),('4',2009,10,0.00,0.00,0.0000,0.00,0.00),('4',2009,11,0.00,0.00,0.0000,0.00,0.00),('4',2009,12,0.00,0.00,0.0000,0.00,0.00),('999999999',2009,1,0.00,0.00,2.0000,300.00,0.00),('999999999',2009,2,0.00,0.00,0.0000,0.00,0.00),('999999999',2009,3,0.00,0.00,0.0000,0.00,0.00),('999999999',2009,4,0.00,0.00,0.0000,0.00,0.00),('999999999',2009,5,0.00,0.00,0.0000,0.00,0.00),('999999999',2009,6,0.00,0.00,0.0000,0.00,0.00),('999999999',2009,7,0.00,0.00,0.0000,0.00,0.00),('999999999',2009,8,0.00,0.00,0.0000,0.00,0.00),('999999999',2009,9,0.00,0.00,0.0000,0.00,0.00),('999999999',2009,10,0.00,0.00,0.0000,0.00,0.00),('999999999',2009,11,0.00,0.00,0.0000,0.00,0.00),('999999999',2009,12,0.00,0.00,0.0000,0.00,0.00),('A1',2008,1,0.00,0.00,0.0000,0.00,0.00),('A1',2008,2,0.00,0.00,0.0000,0.00,0.00),('A1',2008,3,0.00,0.00,0.0000,0.00,0.00),('A1',2008,4,0.00,0.00,0.0000,0.00,0.00),('A1',2008,5,0.00,0.00,0.0000,0.00,0.00),('A1',2008,6,0.00,0.00,0.0000,0.00,0.00),('A1',2008,7,0.00,0.00,0.0000,0.00,0.00),('A1',2008,8,0.00,0.00,0.0000,0.00,0.00),('A1',2008,9,0.00,0.00,0.0000,0.00,0.00),('A1',2008,10,0.00,0.00,0.0000,0.00,0.00),('A1',2008,11,0.00,0.00,0.0000,0.00,0.00),('A1',2008,12,0.00,0.00,10.0000,1000.00,0.00),('A1',2009,1,0.00,0.00,0.0000,0.00,0.00),('A1',2009,2,0.00,0.00,0.0000,0.00,0.00),('A1',2009,3,0.00,0.00,0.0000,0.00,0.00),('A1',2009,4,0.00,0.00,0.0000,0.00,0.00),('A1',2009,5,0.00,0.00,0.0000,0.00,0.00),('A1',2009,6,0.00,0.00,0.0000,0.00,0.00),('A1',2009,7,0.00,0.00,0.0000,0.00,0.00),('A1',2009,8,0.00,0.00,0.0000,0.00,0.00),('A1',2009,9,0.00,0.00,0.0000,0.00,0.00),('A1',2009,10,0.00,0.00,0.0000,0.00,0.00),('A1',2009,11,0.00,0.00,0.0000,0.00,0.00),('A1',2009,12,0.00,0.00,0.0000,0.00,0.00);
/*!40000 ALTER TABLE `estaarti0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estaclie`
--

DROP TABLE IF EXISTS `estaclie`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `estaclie` (
  `CC0` int(11) NOT NULL,
  `CC1` int(4) NOT NULL,
  `CC2` int(2) NOT NULL,
  `CC3` double(10,2) default '0.00',
  `CC4` double(10,2) default '0.00',
  `CC5` double(10,2) default '0.00',
  `CC6` double(10,2) default '0.00',
  `CC7` double(10,2) default '0.00',
  PRIMARY KEY  (`CC0`,`CC1`,`CC2`),
  UNIQUE KEY `CC0` (`CC0`,`CC1`,`CC2`),
  KEY `kcc` (`CC0`,`CC1`,`CC2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `estaclie`
--

LOCK TABLES `estaclie` WRITE;
/*!40000 ALTER TABLE `estaclie` DISABLE KEYS */;
INSERT INTO `estaclie` VALUES (1,2008,1,0.00,0.00,0.00,0.00,0.00),(1,2008,2,0.00,0.00,0.00,0.00,0.00),(1,2008,3,0.00,0.00,0.00,0.00,0.00),(1,2008,4,0.00,0.00,0.00,0.00,0.00),(1,2008,5,0.00,0.00,40.00,5897.00,3530.00),(1,2008,6,0.00,0.00,18.00,2700.00,2070.00),(1,2008,7,0.00,0.00,0.00,0.00,0.00),(1,2008,8,0.00,0.00,0.00,0.00,0.00),(1,2008,9,0.00,0.00,12.00,1800.00,1380.00),(1,2008,10,0.00,0.00,0.00,0.00,0.00),(1,2008,11,0.00,0.00,4.00,302.24,241.50),(1,2008,12,0.00,0.00,25.00,1722.24,814.64),(2,2008,1,0.00,0.00,0.00,0.00,0.00),(2,2008,2,0.00,0.00,0.00,0.00,0.00),(2,2008,3,0.00,0.00,0.00,0.00,0.00),(2,2008,4,0.00,0.00,0.00,0.00,0.00),(2,2008,5,0.00,0.00,45.00,6500.00,2610.00),(2,2008,6,0.00,0.00,2.00,300.00,230.00),(2,2008,7,0.00,0.00,0.00,0.00,0.00),(2,2008,8,0.00,0.00,0.00,0.00,0.00),(2,2008,9,0.00,0.00,2.00,300.00,230.00),(2,2008,10,0.00,0.00,0.00,0.00,0.00),(2,2008,11,0.00,0.00,0.00,0.00,0.00),(2,2008,12,0.00,0.00,0.00,0.00,0.00),(3,2008,1,0.00,0.00,0.00,0.00,0.00),(3,2008,2,0.00,0.00,0.00,0.00,0.00),(3,2008,3,0.00,0.00,0.00,0.00,0.00),(3,2008,4,0.00,0.00,0.00,0.00,0.00),(3,2008,5,0.00,0.00,26.00,3900.00,2990.00),(3,2008,6,0.00,0.00,2.00,300.00,230.00),(3,2008,7,0.00,0.00,0.00,0.00,0.00),(3,2008,8,0.00,0.00,0.00,0.00,0.00),(3,2008,9,0.00,0.00,0.00,0.00,0.00),(3,2008,10,0.00,0.00,0.00,0.00,0.00),(3,2008,11,0.00,0.00,0.00,0.00,0.00),(3,2008,12,0.00,0.00,0.00,0.00,0.00),(4,2009,1,0.00,0.00,4.00,402.24,81.50),(106,2008,1,0.00,0.00,0.00,0.00,0.00),(106,2008,2,0.00,0.00,0.00,0.00,0.00),(106,2008,3,0.00,0.00,0.00,0.00,0.00),(106,2008,4,0.00,0.00,0.00,0.00,0.00),(106,2008,5,0.00,0.00,0.00,0.00,0.00),(106,2008,6,0.00,0.00,0.00,0.00,0.00),(106,2008,7,0.00,0.00,0.00,0.00,0.00),(106,2008,8,0.00,0.00,0.00,0.00,0.00),(106,2008,9,0.00,0.00,0.00,0.00,0.00),(106,2008,10,0.00,0.00,0.00,0.00,0.00),(106,2008,11,0.00,0.00,0.00,0.00,0.00),(106,2008,12,0.00,0.00,0.00,0.00,0.00),(999999,2008,1,0.00,0.00,0.00,0.00,0.00),(999999,2008,2,0.00,0.00,0.00,0.00,0.00),(999999,2008,3,0.00,0.00,0.00,0.00,0.00),(999999,2008,4,0.00,0.00,0.00,0.00,0.00),(999999,2008,5,0.00,0.00,97.23,13146.00,10174.50),(999999,2008,6,0.00,0.00,111.00,15080.00,11680.00),(999999,2008,7,0.00,0.00,0.00,0.00,0.00),(999999,2008,8,0.00,0.00,0.00,0.00,0.00),(999999,2008,9,0.00,0.00,2.00,400.00,300.00),(999999,2008,10,0.00,0.00,11.00,850.00,723.00),(999999,2008,11,0.00,0.00,2.00,102.24,81.50),(999999,2008,12,0.00,0.00,11.00,1002.24,401.50);
/*!40000 ALTER TABLE `estaclie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estadepa0000`
--

DROP TABLE IF EXISTS `estadepa0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `estadepa0000` (
  `DD0` int(4) NOT NULL,
  `DD1` int(4) NOT NULL,
  `DD2` int(2) NOT NULL,
  `DD3` double(10,2) default '0.00',
  `DD4` double(10,2) default '0.00',
  `DD5` double(10,4) default '0.0000',
  `DD6` double(10,2) default '0.00',
  `DD7` double(10,2) default '0.00',
  PRIMARY KEY  (`DD0`,`DD1`,`DD2`),
  UNIQUE KEY `DD0` (`DD0`,`DD1`,`DD2`),
  KEY `kdd` (`DD0`,`DD1`,`DD2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `estadepa0000`
--

LOCK TABLES `estadepa0000` WRITE;
/*!40000 ALTER TABLE `estadepa0000` DISABLE KEYS */;
INSERT INTO `estadepa0000` VALUES (1,2008,1,0.00,0.00,0.0000,0.00,0.00),(1,2008,2,0.00,0.00,0.0000,0.00,0.00),(1,2008,3,0.00,0.00,0.0000,0.00,0.00),(1,2008,4,0.00,0.00,0.0000,0.00,0.00),(1,2008,5,0.00,0.00,104.0000,10598.00,7600.00),(1,2008,6,0.00,0.00,80.0000,7990.00,6400.00),(1,2008,7,0.00,0.00,0.0000,0.00,0.00),(1,2008,8,0.00,0.00,0.0000,0.00,0.00),(1,2008,9,0.00,0.00,7.0000,700.00,560.00),(1,2008,10,0.00,0.00,11.0000,850.00,723.00),(1,2008,11,0.00,0.00,6.0000,404.48,323.00),(1,2008,12,13.00,255.00,24.0000,1720.16,1213.50),(1,2009,1,1337.00,106489.00,2.0000,102.24,81.50),(2,2008,1,0.00,0.00,0.0000,0.00,0.00),(2,2008,2,0.00,0.00,0.0000,0.00,0.00),(2,2008,3,0.00,0.00,0.0000,0.00,0.00),(2,2008,4,0.00,0.00,0.0000,0.00,0.00),(2,2008,5,0.00,0.00,67.2300,13645.00,10084.50),(2,2008,6,0.00,0.00,51.0000,10200.00,7650.00),(2,2008,7,0.00,0.00,0.0000,0.00,0.00),(2,2008,8,0.00,0.00,0.0000,0.00,0.00),(2,2008,9,0.00,0.00,9.0000,1800.00,1350.00),(2,2008,10,0.00,0.00,0.0000,0.00,0.00),(2,2008,11,0.00,0.00,0.0000,0.00,0.00),(2,2008,12,100.00,132.00,2.0000,4.32,2.64),(2,2009,1,1.00,1.32,0.0000,0.00,0.00);
/*!40000 ALTER TABLE `estadepa0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estafami0000`
--

DROP TABLE IF EXISTS `estafami0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `estafami0000` (
  `FF0` int(4) NOT NULL,
  `FF1` int(4) NOT NULL,
  `FF2` int(2) NOT NULL,
  `FF3` double(10,2) default '0.00',
  `FF4` double(10,2) default '0.00',
  `FF5` double(10,4) default '0.0000',
  `FF6` double(10,2) default '0.00',
  `FF7` double(10,2) default '0.00',
  PRIMARY KEY  (`FF0`,`FF1`,`FF2`),
  UNIQUE KEY `FF0` (`FF0`,`FF1`,`FF2`),
  KEY `kff` (`FF0`,`FF1`,`FF2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `estafami0000`
--

LOCK TABLES `estafami0000` WRITE;
/*!40000 ALTER TABLE `estafami0000` DISABLE KEYS */;
INSERT INTO `estafami0000` VALUES (0,2008,5,0.00,0.00,13.0000,2600.00,600.00),(1,2008,1,0.00,0.00,0.0000,0.00,0.00),(1,2008,2,0.00,0.00,0.0000,0.00,0.00),(1,2008,3,0.00,0.00,0.0000,0.00,0.00),(1,2008,4,0.00,0.00,0.0000,0.00,0.00),(1,2008,5,0.00,0.00,123.0000,12498.00,8080.00),(1,2008,6,0.00,0.00,80.0000,7990.00,6400.00),(1,2008,7,0.00,0.00,0.0000,0.00,0.00),(1,2008,8,0.00,0.00,0.0000,0.00,0.00),(1,2008,9,0.00,0.00,7.0000,700.00,560.00),(1,2008,10,0.00,0.00,11.0000,850.00,723.00),(1,2008,11,0.00,0.00,6.0000,404.48,323.00),(1,2008,12,13.00,255.00,24.0000,1720.16,1213.50),(1,2009,1,1337.00,106489.00,2.0000,102.24,81.50),(2,2008,1,0.00,0.00,0.0000,0.00,0.00),(2,2008,2,0.00,0.00,0.0000,0.00,0.00),(2,2008,3,0.00,0.00,0.0000,0.00,0.00),(2,2008,4,0.00,0.00,0.0000,0.00,0.00),(2,2008,5,0.00,0.00,69.2300,14045.00,10384.50),(2,2008,6,0.00,0.00,51.0000,10200.00,7650.00),(2,2008,7,0.00,0.00,0.0000,0.00,0.00),(2,2008,8,0.00,0.00,0.0000,0.00,0.00),(2,2008,9,0.00,0.00,9.0000,1800.00,1350.00),(2,2008,10,0.00,0.00,0.0000,0.00,0.00),(2,2008,11,0.00,0.00,0.0000,0.00,0.00),(2,2008,12,100.00,132.00,2.0000,4.32,2.64),(2,2009,1,1.00,1.32,0.0000,0.00,0.00);
/*!40000 ALTER TABLE `estafami0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estaprove`
--

DROP TABLE IF EXISTS `estaprove`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `estaprove` (
  `PP0` int(11) NOT NULL,
  `PP1` int(4) NOT NULL,
  `PP2` int(2) NOT NULL,
  `PP3` double(10,2) default '0.00',
  `PP4` double(10,2) default '0.00',
  `PP5` double(10,4) default '0.0000',
  `PP6` double(10,2) default '0.00',
  `PP7` double(10,2) default '0.00',
  PRIMARY KEY  (`PP0`,`PP1`,`PP2`),
  UNIQUE KEY `PP0` (`PP0`,`PP1`,`PP2`),
  KEY `kpp` (`PP0`,`PP1`,`PP2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `estaprove`
--

LOCK TABLES `estaprove` WRITE;
/*!40000 ALTER TABLE `estaprove` DISABLE KEYS */;
INSERT INTO `estaprove` VALUES (1,2008,1,0.00,0.00,0.0000,0.00,0.00),(1,2008,2,0.00,0.00,0.0000,0.00,0.00),(1,2008,3,0.00,0.00,0.0000,0.00,0.00),(1,2008,4,0.00,0.00,0.0000,0.00,0.00),(1,2008,5,0.00,0.00,91.0000,9100.00,7280.00),(1,2008,6,0.00,0.00,80.0000,7990.00,6400.00),(1,2008,7,0.00,0.00,0.0000,0.00,0.00),(1,2008,8,0.00,0.00,0.0000,0.00,0.00),(1,2008,9,0.00,0.00,7.0000,700.00,560.00),(1,2008,10,0.00,0.00,8.0000,300.00,640.00),(1,2008,11,0.00,0.00,4.0000,400.00,320.00),(1,2008,12,0.00,0.00,0.0000,0.00,0.00),(1,2009,1,0.00,0.00,0.0000,0.00,0.00),(1,2009,2,0.00,0.00,0.0000,0.00,0.00),(1,2009,3,0.00,0.00,0.0000,0.00,0.00),(1,2009,4,0.00,0.00,0.0000,0.00,0.00),(1,2009,5,0.00,0.00,0.0000,0.00,0.00),(1,2009,6,0.00,0.00,0.0000,0.00,0.00),(1,2009,7,0.00,0.00,0.0000,0.00,0.00),(1,2009,8,0.00,0.00,0.0000,0.00,0.00),(1,2009,9,0.00,0.00,0.0000,0.00,0.00),(1,2009,10,0.00,0.00,0.0000,0.00,0.00),(1,2009,11,0.00,0.00,0.0000,0.00,0.00),(1,2009,12,0.00,0.00,0.0000,0.00,0.00),(2,2008,1,0.00,0.00,0.0000,0.00,0.00),(2,2008,2,0.00,0.00,0.0000,0.00,0.00),(2,2008,3,0.00,0.00,0.0000,0.00,0.00),(2,2008,4,0.00,0.00,0.0000,0.00,0.00),(2,2008,5,0.00,0.00,63.2300,12646.00,9484.50),(2,2008,6,0.00,0.00,51.0000,10200.00,7650.00),(2,2008,7,0.00,0.00,0.0000,0.00,0.00),(2,2008,8,0.00,0.00,0.0000,0.00,0.00),(2,2008,9,0.00,0.00,9.0000,1800.00,1350.00),(2,2008,10,0.00,0.00,0.0000,0.00,0.00),(2,2008,11,0.00,0.00,0.0000,0.00,0.00),(2,2008,12,0.00,0.00,0.0000,0.00,0.00),(2,2009,1,0.00,0.00,0.0000,0.00,0.00),(2,2009,2,0.00,0.00,0.0000,0.00,0.00),(2,2009,3,0.00,0.00,0.0000,0.00,0.00),(2,2009,4,0.00,0.00,0.0000,0.00,0.00),(2,2009,5,0.00,0.00,0.0000,0.00,0.00),(2,2009,6,0.00,0.00,0.0000,0.00,0.00),(2,2009,7,0.00,0.00,0.0000,0.00,0.00),(2,2009,8,0.00,0.00,0.0000,0.00,0.00),(2,2009,9,0.00,0.00,0.0000,0.00,0.00),(2,2009,10,0.00,0.00,0.0000,0.00,0.00),(2,2009,11,0.00,0.00,0.0000,0.00,0.00),(2,2009,12,0.00,0.00,0.0000,0.00,0.00),(3,2008,1,0.00,0.00,0.0000,0.00,0.00),(3,2008,2,0.00,0.00,0.0000,0.00,0.00),(3,2008,3,0.00,0.00,0.0000,0.00,0.00),(3,2008,4,0.00,0.00,0.0000,0.00,0.00),(3,2008,5,0.00,0.00,0.0000,0.00,0.00),(3,2008,6,0.00,0.00,0.0000,0.00,0.00),(3,2008,7,0.00,0.00,0.0000,0.00,0.00),(3,2008,8,0.00,0.00,0.0000,0.00,0.00),(3,2008,9,0.00,0.00,0.0000,0.00,0.00),(3,2008,10,0.00,0.00,3.0000,550.00,83.00),(3,2008,11,0.00,0.00,2.0000,4.48,3.00),(3,2008,12,113.00,387.00,26.0000,1724.48,1216.14),(3,2009,1,1338.00,106490.32,2.0000,102.24,81.50),(3,2009,2,0.00,0.00,0.0000,0.00,0.00),(3,2009,3,0.00,0.00,0.0000,0.00,0.00),(3,2009,4,0.00,0.00,0.0000,0.00,0.00),(3,2009,5,0.00,0.00,0.0000,0.00,0.00),(3,2009,6,0.00,0.00,0.0000,0.00,0.00),(3,2009,7,0.00,0.00,0.0000,0.00,0.00),(3,2009,8,0.00,0.00,0.0000,0.00,0.00),(3,2009,9,0.00,0.00,0.0000,0.00,0.00),(3,2009,10,0.00,0.00,0.0000,0.00,0.00),(3,2009,11,0.00,0.00,0.0000,0.00,0.00),(3,2009,12,0.00,0.00,0.0000,0.00,0.00),(4,2009,1,0.00,0.00,0.0000,0.00,0.00),(4,2009,2,0.00,0.00,0.0000,0.00,0.00),(4,2009,3,0.00,0.00,0.0000,0.00,0.00),(4,2009,4,0.00,0.00,0.0000,0.00,0.00),(4,2009,5,0.00,0.00,0.0000,0.00,0.00),(4,2009,6,0.00,0.00,0.0000,0.00,0.00),(4,2009,7,0.00,0.00,0.0000,0.00,0.00),(4,2009,8,0.00,0.00,0.0000,0.00,0.00),(4,2009,9,0.00,0.00,0.0000,0.00,0.00),(4,2009,10,0.00,0.00,0.0000,0.00,0.00),(4,2009,11,0.00,0.00,0.0000,0.00,0.00),(4,2009,12,0.00,0.00,0.0000,0.00,0.00),(5,2009,1,0.00,0.00,0.0000,0.00,0.00),(5,2009,2,0.00,0.00,0.0000,0.00,0.00),(5,2009,3,0.00,0.00,0.0000,0.00,0.00),(5,2009,4,0.00,0.00,0.0000,0.00,0.00),(5,2009,5,0.00,0.00,0.0000,0.00,0.00),(5,2009,6,0.00,0.00,0.0000,0.00,0.00),(5,2009,7,0.00,0.00,0.0000,0.00,0.00),(5,2009,8,0.00,0.00,0.0000,0.00,0.00),(5,2009,9,0.00,0.00,0.0000,0.00,0.00),(5,2009,10,0.00,0.00,0.0000,0.00,0.00),(5,2009,11,0.00,0.00,0.0000,0.00,0.00),(5,2009,12,0.00,0.00,0.0000,0.00,0.00);
/*!40000 ALTER TABLE `estaprove` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estatien0000`
--

DROP TABLE IF EXISTS `estatien0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `estatien0000` (
  `TT0` int(4) NOT NULL,
  `TT1` int(4) NOT NULL,
  `TT2` int(2) NOT NULL,
  `TT3` double(10,2) default '0.00',
  `TT4` double(10,2) default '0.00',
  `TT5` double(10,4) default '0.0000',
  `TT6` double(10,2) default '0.00',
  `TT7` double(10,2) default '0.00',
  PRIMARY KEY  (`TT0`,`TT1`,`TT2`),
  UNIQUE KEY `TT0` (`TT0`,`TT1`,`TT2`),
  KEY `ktt` (`TT0`,`TT1`,`TT2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `estatien0000`
--

LOCK TABLES `estatien0000` WRITE;
/*!40000 ALTER TABLE `estatien0000` DISABLE KEYS */;
INSERT INTO `estatien0000` VALUES (0,2008,1,0.00,0.00,0.0000,0.00,0.00),(0,2008,2,0.00,0.00,0.0000,0.00,0.00),(0,2008,3,0.00,0.00,0.0000,0.00,0.00),(0,2008,4,0.00,0.00,0.0000,0.00,0.00),(0,2008,5,0.00,0.00,205.2300,29143.00,19064.50),(0,2008,6,0.00,0.00,133.0000,18380.00,14210.00),(0,2008,7,0.00,0.00,0.0000,0.00,0.00),(0,2008,8,0.00,0.00,0.0000,0.00,0.00),(0,2008,9,0.00,0.00,16.0000,2500.00,1910.00),(0,2008,10,0.00,0.00,11.0000,850.00,723.00),(0,2008,11,0.00,0.00,6.0000,404.48,323.00),(0,2008,12,113.00,387.00,32.0000,2324.48,1216.14),(0,2009,1,1338.00,106490.32,4.0000,402.24,81.50),(1,2008,1,0.00,0.00,0.0000,0.00,0.00),(1,2008,2,0.00,0.00,0.0000,0.00,0.00),(1,2008,3,0.00,0.00,0.0000,0.00,0.00),(1,2008,4,0.00,0.00,0.0000,0.00,0.00),(1,2008,5,0.00,0.00,0.0000,0.00,0.00),(1,2008,6,0.00,0.00,0.0000,0.00,0.00),(1,2008,7,0.00,0.00,0.0000,0.00,0.00),(1,2008,8,0.00,0.00,0.0000,0.00,0.00),(1,2008,9,0.00,0.00,0.0000,0.00,0.00),(1,2008,10,0.00,0.00,0.0000,0.00,0.00),(1,2008,11,0.00,0.00,0.0000,0.00,0.00),(1,2008,12,0.00,0.00,0.0000,0.00,0.00);
/*!40000 ALTER TABLE `estatien0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estausu0000`
--

DROP TABLE IF EXISTS `estausu0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `estausu0000` (
  `TUSU0` int(4) NOT NULL,
  `TUSU1` int(4) NOT NULL,
  `TUSU2` int(2) NOT NULL,
  `TUSU3` double(10,2) default '0.00',
  `TUSU4` double(10,2) default '0.00',
  `TUSU5` double(10,2) default '0.00',
  `TUSU6` double(10,2) default '0.00',
  `TUSU7` double(10,2) default '0.00',
  PRIMARY KEY  (`TUSU0`,`TUSU1`,`TUSU2`),
  UNIQUE KEY `TUSU0` (`TUSU0`,`TUSU1`,`TUSU2`),
  KEY `ktusu` (`TUSU0`,`TUSU1`,`TUSU2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `estausu0000`
--

LOCK TABLES `estausu0000` WRITE;
/*!40000 ALTER TABLE `estausu0000` DISABLE KEYS */;
INSERT INTO `estausu0000` VALUES (1,2008,1,0.00,0.00,0.00,0.00,0.00),(1,2008,2,0.00,0.00,0.00,0.00,0.00),(1,2008,3,0.00,0.00,0.00,0.00,0.00),(1,2008,4,0.00,0.00,0.00,0.00,0.00),(1,2008,5,0.00,0.00,2.00,200.00,160.00),(1,2008,6,0.00,0.00,0.00,0.00,0.00),(1,2008,7,0.00,0.00,0.00,0.00,0.00),(1,2008,8,0.00,0.00,0.00,0.00,0.00),(1,2008,9,0.00,0.00,0.00,0.00,0.00),(1,2008,10,0.00,0.00,0.00,0.00,0.00),(1,2008,11,0.00,0.00,0.00,0.00,0.00),(1,2008,12,0.00,0.00,0.00,0.00,0.00);
/*!40000 ALTER TABLE `estausu0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factuc0000`
--

DROP TABLE IF EXISTS `factuc0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `factuc0000` (
  `FC0` int(11) NOT NULL default '0',
  `FC1` date NOT NULL,
  `FC2` char(2) character set latin1 NOT NULL,
  `FC3` int(7) NOT NULL default '0',
  `FC4` int(4) NOT NULL default '0',
  `FC5` double(10,2) NOT NULL default '0.00',
  `FC6` double(5,2) NOT NULL default '0.00',
  `FC7` char(1) character set latin1 NOT NULL default 'N',
  `FC8` double(10,2) NOT NULL default '0.00',
  `FC9` double(10,2) NOT NULL default '0.00',
  `FC10` char(1) character set latin1 NOT NULL default 'N',
  `FC11` date default NULL,
  `FC12` double(10,3) NOT NULL default '0.000',
  `FC13` date default NULL,
  `FC14` double(10,3) NOT NULL default '0.000',
  `FC15` date default NULL,
  `FC16` double(10,3) NOT NULL default '0.000',
  `FC17` date default NULL,
  `FC18` double(10,3) NOT NULL default '0.000',
  `FC19` blob,
  `FC20` char(1) character set latin1 NOT NULL default 'N',
  PRIMARY KEY  (`FC0`,`FC1`,`FC2`,`FC3`),
  UNIQUE KEY `FC0` (`FC0`,`FC1`,`FC2`,`FC3`),
  KEY `kfc` (`FC0`,`FC1`,`FC2`,`FC3`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `factuc0000`
--

LOCK TABLES `factuc0000` WRITE;
/*!40000 ALTER TABLE `factuc0000` DISABLE KEYS */;
INSERT INTO `factuc0000` VALUES (1,'2008-12-29','A',30,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2008-12-29','A',33,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2008-12-29','A',34,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2008-12-29','A',35,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2008-12-29','A',36,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2008-12-29','A',39,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2008-12-29','A',42,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2008-12-29','A',45,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2008-12-29','A',49,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2008-12-29','A',52,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2008-12-30','A',55,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2009-01-05','A',58,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2009-01-05','A',61,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2009-01-05','A',64,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2009-01-05','A',67,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2009-01-05','A',70,2,2.00,0.00,'',300.00,348.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(1,'2009-01-05','A',71,4,4.00,0.00,'',600.00,696.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(2,'2008-12-29','A',31,15,37.00,0.00,'S',5400.00,6264.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(2,'2008-12-29','A',37,15,37.00,0.00,'S',5400.00,6264.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(2,'2008-12-29','A',40,15,37.00,0.00,'S',5400.00,6264.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(2,'2008-12-29','A',43,15,37.00,0.00,'S',5400.00,6264.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(2,'2008-12-29','A',46,15,37.00,0.00,'S',5400.00,6264.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(2,'2008-12-29','A',50,15,37.00,0.00,'S',5400.00,6264.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(2,'2008-12-29','A',53,15,37.00,0.00,'S',5400.00,6264.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(2,'2008-12-30','A',56,15,37.00,0.00,'S',5400.00,6264.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(2,'2009-01-05','A',59,15,37.00,0.00,'S',5400.00,6264.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(2,'2009-01-05','A',62,15,37.00,0.00,'S',5400.00,6264.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(2,'2009-01-05','A',65,15,37.00,0.00,'S',5400.00,6264.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(2,'2009-01-05','A',68,15,37.00,0.00,'S',5400.00,6264.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(2,'2009-01-05','A',72,15,37.00,0.00,'S',5400.00,6264.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(3,'2008-12-29','A',32,14,14.00,0.00,'',2100.00,2436.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(3,'2008-12-29','A',38,14,14.00,0.00,'',2100.00,2436.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(3,'2008-12-29','A',41,14,14.00,0.00,'',2100.00,2436.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(3,'2008-12-29','A',44,14,14.00,0.00,'',2100.00,2436.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(3,'2008-12-29','A',47,14,14.00,0.00,'',2100.00,2436.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(3,'2008-12-29','A',48,14,14.00,0.00,'',2100.00,2436.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(3,'2008-12-29','A',51,14,14.00,0.00,'',2100.00,2436.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(3,'2008-12-29','A',54,14,14.00,0.00,'',2100.00,2436.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(3,'2008-12-30','A',57,14,14.00,0.00,'',2100.00,2436.00,'N','2009-01-29',812.000,'2009-02-28',812.000,'2009-03-30',812.000,NULL,0.000,NULL,'N'),(3,'2009-01-05','A',60,14,14.00,0.00,'',2100.00,2436.00,'N','2009-02-04',812.000,'2009-03-06',812.000,'2009-04-05',812.000,NULL,0.000,NULL,'N'),(3,'2009-01-05','A',63,14,14.00,0.00,'',2100.00,2436.00,'N','2009-02-04',812.000,'2009-03-06',812.000,'2009-04-05',812.000,NULL,0.000,NULL,'N'),(3,'2009-01-05','A',66,14,14.00,0.00,'',2100.00,2436.00,'N','2009-02-04',812.000,'2009-03-06',812.000,'2009-04-05',812.000,NULL,0.000,NULL,'N'),(3,'2009-01-05','A',69,14,14.00,0.00,'',2100.00,2436.00,'N','2009-02-04',812.000,'2009-03-06',812.000,'2009-04-05',812.000,NULL,0.000,NULL,'N'),(3,'2009-01-05','A',73,14,14.00,0.00,'',2100.00,2436.00,'N','2009-02-04',812.000,'2009-03-06',812.000,'2009-04-05',812.000,NULL,0.000,NULL,'N'),(4,'2009-01-05','A',74,2,2.00,0.00,'',102.24,118.60,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N'),(4,'2009-01-16','A',75,2,2.00,0.00,'',300.00,330.00,'N',NULL,0.000,NULL,0.000,NULL,0.000,NULL,0.000,NULL,'N');
/*!40000 ALTER TABLE `factuc0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factud0000`
--

DROP TABLE IF EXISTS `factud0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `factud0000` (
  `FD0` int(11) NOT NULL default '0',
  `FD1` date NOT NULL,
  `FD2` char(2) character set latin1 NOT NULL,
  `FD3` int(7) NOT NULL default '0',
  `FD4` int(4) NOT NULL auto_increment,
  `FD5` char(13) character set latin1 default NULL,
  `FD6` blob,
  `FD7` double(10,2) NOT NULL default '0.00',
  `FD8` double(10,3) NOT NULL default '0.000',
  `FD9` double(10,3) NOT NULL default '0.000',
  `FD10` double(5,3) NOT NULL default '0.000',
  `FD11` double(10,3) NOT NULL default '0.000',
  `FD12` int(3) NOT NULL default '0',
  `FD13` double(10,3) NOT NULL default '0.000',
  `FD14` char(23) character set latin1 default NULL,
  `FD15` char(1) character set latin1 NOT NULL default 'A',
  `FD16` char(100) character set latin1 default NULL,
  PRIMARY KEY  (`FD0`,`FD1`,`FD2`,`FD3`,`FD4`),
  UNIQUE KEY `FD0` (`FD0`,`FD1`,`FD2`,`FD3`,`FD4`),
  KEY `kfd` (`FD0`,`FD1`,`FD2`,`FD3`,`FD4`),
  KEY `kfda` (`FD4`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `factud0000`
--

LOCK TABLES `factud0000` WRITE;
/*!40000 ALTER TABLE `factud0000` DISABLE KEYS */;
INSERT INTO `factud0000` VALUES (1,'2008-12-29','A',30,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',30,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',30,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',30,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',33,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',33,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',33,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',33,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',34,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',34,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',34,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',34,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',35,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',35,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',35,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',35,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',36,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',36,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',36,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',36,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',39,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',39,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',39,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',39,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',42,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',42,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',42,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',42,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',45,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',45,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',45,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',45,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',49,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',49,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',49,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',49,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',52,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',52,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-29','A',52,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-29','A',52,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-30','A',55,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-30','A',55,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 - BADAJOZ'),(1,'2008-12-30','A',55,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2008-12-30','A',55,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 - BADAJOZ'),(1,'2009-01-05','A',58,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 -'),(1,'2009-01-05','A',58,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 -'),(1,'2009-01-05','A',58,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 -'),(1,'2009-01-05','A',58,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 -'),(1,'2009-01-05','A',61,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 -'),(1,'2009-01-05','A',61,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 -'),(1,'2009-01-05','A',61,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 -'),(1,'2009-01-05','A',61,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 -'),(1,'2009-01-05','A',64,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 -'),(1,'2009-01-05','A',64,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 -'),(1,'2009-01-05','A',64,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 -'),(1,'2009-01-05','A',64,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 -'),(1,'2009-01-05','A',67,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 -'),(1,'2009-01-05','A',67,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 -'),(1,'2009-01-05','A',67,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 -'),(1,'2009-01-05','A',67,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 -'),(1,'2009-01-05','A',70,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 -'),(1,'2009-01-05','A',70,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 -'),(1,'2009-01-05','A',71,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/1 - 19/05/2008 -'),(1,'2009-01-05','A',71,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/1 - 19/05/2008 -'),(1,'2009-01-05','A',71,3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/14 - 10/06/2008 -'),(1,'2009-01-05','A',71,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/14 - 10/06/2008 -'),(2,'2008-12-29','A',31,1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',31,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',31,3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',31,4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',31,5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',31,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',31,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',31,8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',31,9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',31,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',31,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',31,12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',31,13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',31,14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',31,15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',37,15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',40,15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',43,15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',46,15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',50,15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-29','A',53,15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,NULL,'A','Albaran.: A/3 - 20/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/8 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/9 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/10 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/11 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2008-12-30','A',56,15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/12 - 27/05/2008 - LOCALIDAD 2'),(2,'2009-01-05','A',59,1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - Observaciones del albaran 2'),(2,'2009-01-05','A',59,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - Observaciones del albaran 2'),(2,'2009-01-05','A',59,3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',59,4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',59,5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',59,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/8 - 27/05/2008 -'),(2,'2009-01-05','A',59,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/8 - 27/05/2008 -'),(2,'2009-01-05','A',59,8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/9 - 27/05/2008 -'),(2,'2009-01-05','A',59,9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/9 - 27/05/2008 -'),(2,'2009-01-05','A',59,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/10 - 27/05/2008 -'),(2,'2009-01-05','A',59,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/10 - 27/05/2008 -'),(2,'2009-01-05','A',59,12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/11 - 27/05/2008 -'),(2,'2009-01-05','A',59,13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/11 - 27/05/2008 -'),(2,'2009-01-05','A',59,14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/12 - 27/05/2008 -'),(2,'2009-01-05','A',59,15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/12 - 27/05/2008 -'),(2,'2009-01-05','A',62,1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - Observaciones del albaran 2'),(2,'2009-01-05','A',62,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - Observaciones del albaran 2'),(2,'2009-01-05','A',62,3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',62,4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',62,5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',62,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/8 - 27/05/2008 -'),(2,'2009-01-05','A',62,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/8 - 27/05/2008 -'),(2,'2009-01-05','A',62,8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/9 - 27/05/2008 -'),(2,'2009-01-05','A',62,9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/9 - 27/05/2008 -'),(2,'2009-01-05','A',62,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/10 - 27/05/2008 -'),(2,'2009-01-05','A',62,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/10 - 27/05/2008 -'),(2,'2009-01-05','A',62,12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/11 - 27/05/2008 -'),(2,'2009-01-05','A',62,13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/11 - 27/05/2008 -'),(2,'2009-01-05','A',62,14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/12 - 27/05/2008 -'),(2,'2009-01-05','A',62,15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/12 - 27/05/2008 -'),(2,'2009-01-05','A',65,1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - Observaciones del albaran 2'),(2,'2009-01-05','A',65,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - Observaciones del albaran 2'),(2,'2009-01-05','A',65,3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',65,4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',65,5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',65,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/8 - 27/05/2008 -'),(2,'2009-01-05','A',65,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/8 - 27/05/2008 -'),(2,'2009-01-05','A',65,8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/9 - 27/05/2008 -'),(2,'2009-01-05','A',65,9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/9 - 27/05/2008 -'),(2,'2009-01-05','A',65,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/10 - 27/05/2008 -'),(2,'2009-01-05','A',65,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/10 - 27/05/2008 -'),(2,'2009-01-05','A',65,12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/11 - 27/05/2008 -'),(2,'2009-01-05','A',65,13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/11 - 27/05/2008 -'),(2,'2009-01-05','A',65,14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/12 - 27/05/2008 -'),(2,'2009-01-05','A',65,15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/12 - 27/05/2008 -'),(2,'2009-01-05','A',68,1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - Observaciones del albaran 2'),(2,'2009-01-05','A',68,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - Observaciones del albaran 2'),(2,'2009-01-05','A',68,3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',68,4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',68,5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',68,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/8 - 27/05/2008 -'),(2,'2009-01-05','A',68,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/8 - 27/05/2008 -'),(2,'2009-01-05','A',68,8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/9 - 27/05/2008 -'),(2,'2009-01-05','A',68,9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/9 - 27/05/2008 -'),(2,'2009-01-05','A',68,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/10 - 27/05/2008 -'),(2,'2009-01-05','A',68,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/10 - 27/05/2008 -'),(2,'2009-01-05','A',68,12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/11 - 27/05/2008 -'),(2,'2009-01-05','A',68,13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/11 - 27/05/2008 -'),(2,'2009-01-05','A',68,14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/12 - 27/05/2008 -'),(2,'2009-01-05','A',68,15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/12 - 27/05/2008 -'),(2,'2009-01-05','A',72,1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - Observaciones del albaran 2'),(2,'2009-01-05','A',72,2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/2 - 19/05/2008 - Observaciones del albaran 2'),(2,'2009-01-05','A',72,3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',72,4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',72,5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,NULL,'A','Albaran.: A/3 - 20/05/2008 -'),(2,'2009-01-05','A',72,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/8 - 27/05/2008 -'),(2,'2009-01-05','A',72,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/8 - 27/05/2008 -'),(2,'2009-01-05','A',72,8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/9 - 27/05/2008 -'),(2,'2009-01-05','A',72,9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/9 - 27/05/2008 -'),(2,'2009-01-05','A',72,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/10 - 27/05/2008 -'),(2,'2009-01-05','A',72,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/10 - 27/05/2008 -'),(2,'2009-01-05','A',72,12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/11 - 27/05/2008 -'),(2,'2009-01-05','A',72,13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/11 - 27/05/2008 -'),(2,'2009-01-05','A',72,14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/12 - 27/05/2008 -'),(2,'2009-01-05','A',72,15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/12 - 27/05/2008 -'),(3,'2008-12-29','A',32,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',32,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',32,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',32,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',32,5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',32,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',32,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',32,8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',32,9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',32,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',32,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',32,12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',32,13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',32,14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',38,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',38,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',38,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',38,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',38,5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',38,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',38,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',38,8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',38,9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',38,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',38,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',38,12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',38,13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',38,14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',41,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',41,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',41,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',41,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',41,5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',41,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',41,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',41,8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',41,9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',41,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',41,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',41,12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',41,13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',41,14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',44,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',44,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',44,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',44,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',44,5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',44,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',44,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',44,8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',44,9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',44,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',44,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',44,12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',44,13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',44,14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',47,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',47,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',47,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',47,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',47,5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',47,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',47,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',47,8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',47,9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',47,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',47,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',47,12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',47,13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',47,14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',48,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',48,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',48,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',48,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',48,5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',48,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',48,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',48,8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',48,9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',48,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',48,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',48,12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',48,13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',48,14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',51,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',51,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',51,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',51,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',51,5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',51,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',51,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',51,8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',51,9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',51,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',51,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',51,12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',51,13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',51,14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',54,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',54,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',54,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',54,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',54,5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',54,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',54,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',54,8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',54,9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',54,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',54,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',54,12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',54,13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-29','A',54,14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-30','A',57,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-30','A',57,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-30','A',57,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-30','A',57,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-30','A',57,5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-30','A',57,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-30','A',57,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-30','A',57,8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-30','A',57,9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-30','A',57,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-30','A',57,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-30','A',57,12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-30','A',57,13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2008-12-30','A',57,14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/13 - 27/05/2008 - LOCALIDAD 3'),(3,'2009-01-05','A',60,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',60,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',60,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',60,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',60,5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',60,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',60,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',60,8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',60,9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',60,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',60,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',60,12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',60,13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/13 - 27/05/2008 -'),(3,'2009-01-05','A',60,14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/13 - 27/05/2008 -'),(3,'2009-01-05','A',63,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',63,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',63,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',63,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',63,5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',63,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',63,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',63,8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',63,9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',63,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',63,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',63,12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',63,13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/13 - 27/05/2008 -'),(3,'2009-01-05','A',63,14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/13 - 27/05/2008 -'),(3,'2009-01-05','A',66,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',66,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',66,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',66,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',66,5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',66,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',66,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',66,8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',66,9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',66,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',66,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',66,12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',66,13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/13 - 27/05/2008 -'),(3,'2009-01-05','A',66,14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/13 - 27/05/2008 -'),(3,'2009-01-05','A',69,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',69,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',69,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',69,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',69,5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',69,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',69,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',69,8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',69,9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',69,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',69,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',69,12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',69,13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/13 - 27/05/2008 -'),(3,'2009-01-05','A',69,14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/13 - 27/05/2008 -'),(3,'2009-01-05','A',73,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',73,2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',73,3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',73,4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/5 - 27/05/2008 -'),(3,'2009-01-05','A',73,5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',73,6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',73,7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',73,8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/6 - 27/05/2008 -'),(3,'2009-01-05','A',73,9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',73,10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',73,11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',73,12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/7 - 27/05/2008 -'),(3,'2009-01-05','A',73,13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A','Albaran.: A/13 - 27/05/2008 -'),(3,'2009-01-05','A',73,14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,NULL,'A','Albaran.: A/13 - 27/05/2008 -'),(4,'2009-01-05','A',74,1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(4,'2009-01-05','A',74,2,'2','ARTICULO 2',1.00,2.600,2.241,0.000,2.241,16,2.600,NULL,'A',NULL),(4,'2009-01-16','A',75,1,'999999999','ARTICULOS VARIOS',1.00,116.000,100.000,0.000,100.000,16,116.000,NULL,'A',NULL),(4,'2009-01-16','A',75,2,'999999999','ARTICULOS VARIOS',1.00,214.000,200.000,0.000,200.000,7,214.000,NULL,'A',NULL);
/*!40000 ALTER TABLE `factud0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facturect0000`
--

DROP TABLE IF EXISTS `facturect0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `facturect0000` (
  `FR0` int(11) NOT NULL default '0',
  `FR1` date NOT NULL,
  `FR2` char(2) character set latin1 NOT NULL,
  `FR3` int(7) NOT NULL default '0',
  `FR4` date NOT NULL,
  `FR5` char(2) character set latin1 NOT NULL,
  `FR6` int(7) NOT NULL default '0',
  PRIMARY KEY  (`FR0`,`FR1`,`FR2`,`FR3`,`FR4`,`FR5`,`FR6`),
  UNIQUE KEY `FR0` (`FR0`,`FR1`,`FR2`,`FR3`,`FR4`,`FR5`,`FR6`),
  KEY `kfr` (`FR0`,`FR1`,`FR2`,`FR3`,`FR4`,`FR5`,`FR6`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `facturect0000`
--

LOCK TABLES `facturect0000` WRITE;
/*!40000 ALTER TABLE `facturect0000` DISABLE KEYS */;
/*!40000 ALTER TABLE `facturect0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `familias0000`
--

DROP TABLE IF EXISTS `familias0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `familias0000` (
  `F0` int(4) NOT NULL,
  `F1` char(50) character set latin1 default NULL,
  `F2` int(4) NOT NULL default '0',
  `F3` date default NULL,
  `F4` date default NULL,
  `F5` blob,
  PRIMARY KEY  (`F0`),
  UNIQUE KEY `F0` (`F0`),
  KEY `kf` (`F0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `familias0000`
--

LOCK TABLES `familias0000` WRITE;
/*!40000 ALTER TABLE `familias0000` DISABLE KEYS */;
INSERT INTO `familias0000` VALUES (1,'FAMILIA 1',1,'2009-01-05','2008-09-02',NULL),(2,'FAMILIA 2',2,'2008-12-20','2008-09-02',NULL);
/*!40000 ALTER TABLE `familias0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `formapago`
--

DROP TABLE IF EXISTS `formapago`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `formapago` (
  `FPA0` int(4) NOT NULL,
  `FPA1` char(50) character set latin1 default NULL,
  PRIMARY KEY  (`FPA0`),
  UNIQUE KEY `FPA0` (`FPA0`),
  KEY `kfpa` (`FPA0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `formapago`
--

LOCK TABLES `formapago` WRITE;
/*!40000 ALTER TABLE `formapago` DISABLE KEYS */;
INSERT INTO `formapago` VALUES (1,'CONTADO'),(2,'GIRO BANCARIO'),(3,'CHEQUE BANCARIO'),(4,'TRANSFERENCIA CC.: 2099'),(5,'TRANSFERENCIA CC.: 2100'),(6,'GIRO A 30 DIAS');
/*!40000 ALTER TABLE `formapago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hipedicc0000`
--

DROP TABLE IF EXISTS `hipedicc0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hipedicc0000` (
  `HPC0` int(4) NOT NULL default '0',
  `HPC1` date NOT NULL,
  `HPC2` int(11) NOT NULL default '0',
  `HPC3` char(2) character set latin1 NOT NULL,
  `HPC4` int(6) NOT NULL default '0',
  `HPC5` int(6) NOT NULL default '0',
  `HPC6` int(7) NOT NULL default '0',
  `HPC7` double(10,2) NOT NULL default '0.00',
  `HPC8` double(10,2) NOT NULL default '0.00',
  `HPC9` double(10,2) NOT NULL default '0.00',
  `HPC10` char(1) character set latin1 default NULL,
  `HPC11` char(1) character set latin1 default NULL,
  `HPC12` char(100) character set latin1 default NULL,
  `HPC13` char(50) character set latin1 default NULL,
  `HPC14` int(11) NOT NULL default '0',
  `HPC15` char(50) character set latin1 default NULL,
  `HPC16` char(50) character set latin1 default NULL,
  `HPC17` double(10,2) NOT NULL default '0.00',
  `HPC18` double(10,2) NOT NULL default '0.00',
  `HPC19` double(10,2) NOT NULL default '0.00',
  `HPC20` date default NULL,
  `HPC21` double(10,2) NOT NULL default '0.00',
  `HPC22` date default NULL,
  `HPC23` double(10,2) NOT NULL default '0.00',
  `HPC24` date default NULL,
  `HPC25` double(10,2) NOT NULL default '0.00',
  `HPC26` date default NULL,
  `HPC27` double(10,2) NOT NULL default '0.00',
  `HPC28` char(1) character set latin1 default NULL,
  `HPC29` char(30) character set latin1 default NULL,
  `HPC30` date default NULL,
  `HPC31` blob,
  PRIMARY KEY  (`HPC0`,`HPC1`,`HPC2`,`HPC3`,`HPC4`),
  UNIQUE KEY `HPC0` (`HPC0`,`HPC1`,`HPC2`,`HPC3`,`HPC4`),
  KEY `khpc` (`HPC0`,`HPC1`,`HPC2`,`HPC3`,`HPC4`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `hipedicc0000`
--

LOCK TABLES `hipedicc0000` WRITE;
/*!40000 ALTER TABLE `hipedicc0000` DISABLE KEYS */;
INSERT INTO `hipedicc0000` VALUES (0,'2008-09-02',3,'A',3,20,1338,106490.32,123528.77,154530.10,'S','P','PROVEEDOR3','PROVEEDOR 3',2,'CLIENTE 2','924222222',812.00,812.00,0.00,NULL,0.00,NULL,0.00,NULL,0.00,NULL,0.00,'A','BA1211','2008-09-02',NULL),(0,'2008-09-04',3,'A',7,4,113,386.70,436.70,605.00,'N','','','PROVEEDOR 3',1,'GARCIA PEREZ, JUAN JOSE','924111111',348.00,348.00,0.00,'2008-11-04',200.00,'2008-12-04',200.00,'2009-01-05',36.70,NULL,0.00,NULL,NULL,NULL,'Observaciones pedido x');
/*!40000 ALTER TABLE `hipedicc0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hipedidd0000`
--

DROP TABLE IF EXISTS `hipedidd0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hipedidd0000` (
  `HPD0` int(4) NOT NULL default '0',
  `HPD1` date NOT NULL,
  `HPD2` int(11) NOT NULL default '0',
  `HPD3` char(2) character set latin1 NOT NULL,
  `HPD4` int(5) NOT NULL,
  `HPD5` int(6) NOT NULL auto_increment,
  `HPD6` char(13) character set latin1 NOT NULL,
  `HPD7` char(50) character set latin1 default NULL,
  `HPD8` double(10,2) NOT NULL default '0.00',
  `HPD9` double(10,2) NOT NULL default '0.00',
  `HPD10` double(10,3) NOT NULL default '0.000',
  `HPD11` double(5,3) NOT NULL default '0.000',
  `HPD12` double(10,3) NOT NULL default '0.000',
  `HPD13` double(5,2) NOT NULL default '0.00',
  `HPD14` double(5,2) NOT NULL default '0.00',
  `HPD15` double(10,3) NOT NULL default '0.000',
  `HPD16` double(10,2) NOT NULL default '0.00',
  `HPD17` double(10,2) NOT NULL default '0.00',
  `HPD18` double(10,2) NOT NULL default '0.00',
  `HPD19` int(4) NOT NULL default '0',
  `HPD20` double(10,2) NOT NULL default '0.00',
  `HPD21` double(10,2) NOT NULL default '0.00',
  `HPD22` double(10,2) NOT NULL default '0.00',
  `HPD23` char(1) character set latin1 NOT NULL default 'S',
  `HPD24` char(6) character set latin1 default NULL,
  `HPD25` char(6) character set latin1 default NULL,
  `HPD26` double(10,3) NOT NULL default '0.000',
  `HPD27` double(10,3) NOT NULL default '0.000',
  `HPD28` double(10,3) NOT NULL default '0.000',
  `HPD29` double(10,3) NOT NULL default '0.000',
  PRIMARY KEY  (`HPD0`,`HPD1`,`HPD2`,`HPD3`,`HPD4`,`HPD5`),
  UNIQUE KEY `HPD0` (`HPD0`,`HPD1`,`HPD2`,`HPD3`,`HPD4`,`HPD5`),
  KEY `khpd` (`HPD0`,`HPD1`,`HPD2`,`HPD3`,`HPD4`,`HPD5`),
  KEY `khpda` (`HPD5`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `hipedidd0000`
--

LOCK TABLES `hipedidd0000` WRITE;
/*!40000 ALTER TABLE `hipedidd0000` DISABLE KEYS */;
INSERT INTO `hipedidd0000` VALUES (0,'2008-09-02',3,'A',3,1,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-75.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,2,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-75.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,3,'1','ARTICULO 1',120.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,11136.00,13920.00,1,-75.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,4,'1','ARTICULO 1',1200.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,111360.00,139200.00,1,-75.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,5,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-75.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,6,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-75.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,7,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-75.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,8,'2','ARTICULO 2',1.00,0.00,1.500,49.425,2.241,0.00,16.00,1.740,2.60,1.74,2.60,1,-4.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,9,'2','ARTICULO 2',1.00,0.00,1.500,49.425,2.241,0.00,16.00,1.740,2.60,1.74,2.60,1,-4.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,10,'2','ARTICULO 2',1.00,0.00,1.500,49.425,2.241,0.00,16.00,1.740,2.60,1.74,2.60,1,-4.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,11,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-94.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,12,'2','ARTICULO 2',1.00,0.00,1.500,49.425,2.241,0.00,16.00,1.740,2.60,1.74,2.60,1,-4.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,13,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-94.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,14,'2','ARTICULO 2',1.00,0.00,1.500,49.425,2.241,0.00,16.00,1.740,2.60,1.74,2.60,1,-4.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,15,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-94.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,16,'3','ARTICULO 3',1.00,0.00,80.000,87.500,150.000,0.00,16.00,92.800,174.00,92.80,174.00,1,99.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,17,'4','ARTICULO NUMERO 4',1.00,0.00,1.317,63.643,2.155,0.00,16.00,1.528,2.50,1.53,2.50,2,0.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,18,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-94.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,19,'2','ARTICULO 2',1.00,0.00,1.500,49.425,2.241,0.00,16.00,1.740,2.60,1.74,2.60,1,-4.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',3,'A',3,20,'3','ARTICULO 3',1.00,0.00,80.000,87.500,150.000,0.00,16.00,92.800,174.00,92.80,174.00,1,99.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-04',3,'A',7,1,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-82.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-04',3,'A',7,3,'1','ARTICULO 1',2.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,185.60,232.00,1,-82.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-04',3,'A',7,4,'2','ARTICULO 2',10.00,0.00,1.500,49.425,2.241,0.00,16.00,1.740,2.60,17.40,26.00,1,0.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-04',3,'A',7,5,'4','ARTICULO NUMERO 4',100.00,0.00,1.317,63.924,2.159,0.00,7.00,1.409,2.31,140.90,231.00,2,0.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000);
/*!40000 ALTER TABLE `hipedidd0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hisalbac0000`
--

DROP TABLE IF EXISTS `hisalbac0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hisalbac0000` (
  `HAC0` int(11) NOT NULL default '0',
  `HAC1` date NOT NULL,
  `HAC2` char(2) character set latin1 NOT NULL,
  `HAC3` int(7) NOT NULL default '0',
  `HAC4` int(4) NOT NULL default '0',
  `HAC5` double(10,2) NOT NULL default '0.00',
  `HAC6` double(5,2) NOT NULL default '0.00',
  `HAC7` char(1) character set latin1 NOT NULL default 'N',
  `HAC8` double(10,2) NOT NULL default '0.00',
  `HAC9` double(10,2) NOT NULL default '0.00',
  `HAC10` char(1) character set latin1 NOT NULL default 'N',
  `HAC11` blob,
  `HAC12` int(11) NOT NULL default '0',
  `HAC13` date NOT NULL,
  `HAC14` char(2) character set latin1 NOT NULL,
  `HAC15` int(7) NOT NULL default '0',
  PRIMARY KEY  (`HAC0`,`HAC1`,`HAC2`,`HAC3`),
  UNIQUE KEY `HAC0` (`HAC0`,`HAC1`,`HAC2`,`HAC3`),
  KEY `khac` (`HAC0`,`HAC1`,`HAC2`,`HAC3`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `hisalbac0000`
--

LOCK TABLES `hisalbac0000` WRITE;
/*!40000 ALTER TABLE `hisalbac0000` DISABLE KEYS */;
/*!40000 ALTER TABLE `hisalbac0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hisalbad0000`
--

DROP TABLE IF EXISTS `hisalbad0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hisalbad0000` (
  `HAD0` int(11) NOT NULL default '0',
  `HAD1` date NOT NULL,
  `HAD2` char(2) character set latin1 NOT NULL,
  `HAD3` int(7) NOT NULL default '0',
  `HAD4` int(4) NOT NULL auto_increment,
  `HAD5` char(13) character set latin1 default NULL,
  `HAD6` blob,
  `HAD7` double(10,2) NOT NULL default '0.00',
  `HAD8` double(10,3) NOT NULL default '0.000',
  `HAD9` double(10,3) NOT NULL default '0.000',
  `HAD10` double(5,3) NOT NULL default '0.000',
  `HAD11` double(10,3) NOT NULL default '0.000',
  `HAD12` int(3) NOT NULL default '0',
  `HAD13` double(10,3) NOT NULL default '0.000',
  `HAD14` char(23) character set latin1 default NULL,
  `HAD15` char(1) character set latin1 NOT NULL default 'A',
  `HAD16` char(100) character set latin1 default NULL,
  PRIMARY KEY  (`HAD0`,`HAD1`,`HAD2`,`HAD3`,`HAD4`),
  UNIQUE KEY `HAD0` (`HAD0`,`HAD1`,`HAD2`,`HAD3`,`HAD4`),
  KEY `khad` (`HAD0`,`HAD1`,`HAD2`,`HAD3`,`HAD4`),
  KEY `khada` (`HAD4`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `hisalbad0000`
--

LOCK TABLES `hisalbad0000` WRITE;
/*!40000 ALTER TABLE `hisalbad0000` DISABLE KEYS */;
/*!40000 ALTER TABLE `hisalbad0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hisopcc0000`
--

DROP TABLE IF EXISTS `hisopcc0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hisopcc0000` (
  `HO0` date NOT NULL,
  `HO1` time NOT NULL,
  `HO2` char(1) character set latin1 NOT NULL,
  `HO3` int(7) NOT NULL,
  `HO4` char(2) character set latin1 NOT NULL,
  `HO5` char(2) character set latin1 default NULL,
  `HO6` char(10) character set latin1 default NULL,
  `HO7` int(4) NOT NULL,
  `HO8` int(11) NOT NULL,
  `HO9` double(10,2) NOT NULL default '0.00',
  `HO10` double(5,2) NOT NULL default '0.00',
  `HO11` double(10,2) NOT NULL default '0.00',
  `HO12` double(10,2) NOT NULL default '0.00',
  `HO13` double(10,2) NOT NULL default '0.00',
  `HO14` double(10,2) NOT NULL default '0.00',
  `HO15` char(1) character set latin1 default 'N',
  PRIMARY KEY  (`HO0`,`HO1`,`HO2`,`HO3`,`HO4`),
  UNIQUE KEY `HO0` (`HO0`,`HO1`,`HO2`,`HO3`,`HO4`),
  KEY `kho` (`HO0`,`HO1`,`HO2`,`HO3`,`HO4`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `hisopcc0000`
--

LOCK TABLES `hisopcc0000` WRITE;
/*!40000 ALTER TABLE `hisopcc0000` DISABLE KEYS */;
INSERT INTO `hisopcc0000` VALUES ('1899-12-30','00:00:00','A',14,'A','AL','CONTADO',1,1,348.00,0.00,348.00,348.00,0.00,0.00,'N'),('2008-06-10','11:56:06','A',4,'A','NS','CONTADO',1,999999,348.00,0.00,348.00,348.00,0.00,0.00,'N'),('2008-06-11','13:19:04','A',0,'','NT','CONTADO',1,999999,464.00,0.00,464.00,464.00,0.00,0.00,'N'),('2008-06-19','10:11:43','A',5,'A','NS','CONTADO',1,999999,928.00,0.00,928.00,928.00,0.00,0.00,'N'),('2008-06-19','10:11:44','A',6,'A','NS','CONTADO',1,999999,348.00,0.00,348.00,348.00,0.00,0.00,'N'),('2008-06-19','10:34:58','A',0,'','NT','CONTADO',1,999999,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-06-19','10:37:49','A',0,'','NT','CONTADO',1,999999,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-06-19','10:39:22','A',0,'','NT','CONTADO',1,999999,580.00,0.00,580.00,580.00,0.00,0.00,'N'),('2008-06-19','10:41:08','A',7,'A','NT','CONTADO',1,999999,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-06-19','10:43:16','A',8,'A','NT','CONTADO',1,999999,348.00,0.00,348.00,400.00,52.00,0.00,'N'),('2008-06-19','10:55:54','A',9,'A','NT','CONTADO',1,999999,348.00,0.00,348.00,400.00,52.00,0.00,'N'),('2008-06-19','11:41:55','A',10,'A','NS','CONTADO',1,999999,232.00,0.00,232.00,0.00,-232.00,0.00,'N'),('2008-06-20','10:05:39','A',16,'A','FA','CONTADO',1,1,348.00,0.00,348.00,348.00,0.00,0.00,'N'),('2008-09-02','10:52:49','A',11,'A','NS','CONTADO',1,2,348.00,0.00,348.00,348.00,0.00,0.00,'N'),('2008-09-02','21:41:24','A',12,'A','NS','CONTADO',1,1,1044.00,0.00,1044.00,1044.00,0.00,0.00,'N'),('2008-09-03','17:23:45','A',13,'A','NS','CONTADO',1,999999,464.00,0.00,464.00,464.00,0.00,0.00,'N'),('2008-10-15','13:01:44','A',16,'A','NS','CONTADO',1,999999,464.00,0.00,464.00,464.00,0.00,0.00,'N'),('2008-10-29','09:42:13','A',17,'A','NS','CONTADO',1,999999,522.00,0.00,522.00,522.00,0.00,0.00,'N'),('2008-11-05','11:44:24','A',18,'A','NS','CONTADO',1,1,118.60,0.00,118.60,0.00,-118.60,0.00,'N'),('2008-11-05','12:12:00','A',19,'A','NS','CONTADO',1,1,-116.00,0.00,-116.00,-116.00,0.00,0.00,'N'),('2008-11-05','12:12:28','A',20,'A','NS','CONTADO',1,999999,118.60,0.00,118.60,118.60,0.00,0.00,'N'),('2008-11-06','10:50:14','A',21,'A','NS','CONTADO',1,1,348.00,0.00,348.00,0.00,-348.00,0.00,'N'),('2008-12-03','13:03:52','A',22,'A','NS','CONTADO',1,1,295.20,0.00,295.20,295.20,0.00,0.00,'N'),('2008-12-08','11:27:50','A',23,'A','NS','CONTADO',1,1,118.60,0.00,118.60,0.00,-118.60,0.00,'N'),('2008-12-08','12:04:49','A',24,'A','NS','CONTADO',1,1,118.60,0.00,118.60,0.00,-118.60,0.00,'N'),('2008-12-08','12:08:28','A',25,'A','NS','CONTADO',1,1,292.60,0.00,292.60,0.00,-292.60,0.00,'N'),('2008-12-08','19:39:28','A',26,'A','NS','CONTADO',1,999999,116.00,0.00,116.00,116.00,0.00,0.00,'N'),('2008-12-08','19:39:33','A',27,'A','NS','CONTADO',1,999999,2.60,0.00,2.60,2.60,0.00,0.00,'N'),('2008-12-19','12:21:06','A',32,'A','NS','CONTADO',1,999999,232.00,0.00,232.00,232.00,0.00,0.00,'N'),('2008-12-19','12:21:08','A',33,'A','NS','CONTADO',1,999999,-116.00,0.00,-116.00,-116.00,0.00,0.00,'N'),('2008-12-19','12:21:21','A',18,'A','FA','CONTADO',1,1,116.00,0.00,116.00,116.00,0.00,0.00,'N'),('2008-12-19','12:21:44','A',19,'A','FA','CONTADO',1,1,116.00,0.00,116.00,116.00,0.00,0.00,'N'),('2008-12-19','12:22:53','A',20,'A','FA','CONTADO',1,1,116.00,0.00,116.00,116.00,0.00,0.00,'N'),('2008-12-19','16:31:03','A',34,'A','EN','CONTADO',1,1,50.00,0.00,50.00,50.00,0.00,0.00,'N'),('2008-12-19','16:33:43','A',35,'A','CO','CONTADO',1,1,161.20,0.00,161.20,200.00,38.80,0.00,'N'),('2008-12-19','16:38:33','A',36,'A','NS','CONTADO',1,1,234.60,0.00,234.60,0.00,-234.60,0.00,'N'),('2008-12-19','16:56:01','A',37,'A','EN','CONTADO',1,1,100.00,0.00,100.00,100.00,0.00,0.00,'N'),('2008-12-19','16:59:21','A',38,'A','NS','CONTADO',1,1,179.20,0.00,179.20,0.00,-179.20,0.00,'N'),('2008-12-19','16:59:33','A',39,'A','NS','CONTADO',1,1,116.00,0.00,116.00,0.00,-116.00,0.00,'N'),('2008-12-20','17:24:28','A',40,'A','NS','CONTADO',1,1,294.62,0.00,294.62,0.00,-294.62,0.00,'N'),('2008-12-20','17:24:41','A',41,'A','EN','CONTADO',1,1,200.00,0.00,200.00,200.00,0.00,0.00,'N'),('2008-12-29','16:07:50','A',24,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-12-29','16:07:50','A',25,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2008-12-29','16:07:50','A',26,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2008-12-29','16:10:49','A',27,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-12-29','16:10:49','A',28,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2008-12-29','16:10:49','A',29,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2008-12-29','16:11:48','A',30,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-12-29','16:11:48','A',31,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2008-12-29','16:11:48','A',32,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2008-12-29','16:22:33','A',33,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-12-29','16:23:53','A',34,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-12-29','16:32:56','A',35,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-12-29','16:34:14','',36,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-12-29','16:34:14','',37,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2008-12-29','16:34:14','',38,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2008-12-29','16:38:48','',39,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-12-29','16:38:48','',40,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2008-12-29','16:38:48','',41,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2008-12-29','16:49:58','A',42,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-12-29','16:49:58','A',43,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2008-12-29','16:49:58','A',44,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2008-12-29','21:03:24','A',45,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-12-29','21:03:24','A',46,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2008-12-29','21:03:24','A',47,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2008-12-29','21:07:26','A',48,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2008-12-29','21:09:36','A',49,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-12-29','21:09:36','A',50,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2008-12-29','21:09:36','A',51,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2008-12-29','21:10:23','',52,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-12-29','21:10:23','',53,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2008-12-29','21:10:23','',54,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2008-12-30','15:56:19','A',55,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2008-12-30','15:56:19','A',56,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2008-12-30','15:56:19','A',57,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2009-01-05','10:53:18','A',58,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2009-01-05','10:53:18','A',59,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2009-01-05','10:53:18','A',60,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2009-01-05','10:58:52','',61,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2009-01-05','10:58:52','',62,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2009-01-05','10:58:52','',63,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2009-01-05','11:00:35','',64,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2009-01-05','11:00:35','',65,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2009-01-05','11:00:35','',66,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2009-01-05','11:01:53','A',67,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2009-01-05','11:01:53','A',68,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2009-01-05','11:01:53','A',69,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N'),('2009-01-05','11:30:55','A',70,'A','FA','FACTURADO',1,1,348.00,0.00,348.00,348.00,0.00,0.00,'N'),('2009-01-05','11:42:41','',71,'A','FA','FACTURADO',1,1,696.00,0.00,696.00,696.00,0.00,0.00,'N'),('2009-01-05','11:42:41','',72,'A','FA','FACTURADO',1,2,6264.00,0.00,6264.00,6264.00,0.00,0.00,'N'),('2009-01-05','11:42:41','',73,'A','FA','FACTURADO',1,3,2436.00,0.00,2436.00,2436.00,0.00,0.00,'N');
/*!40000 ALTER TABLE `hisopcc0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hisopdd0000`
--

DROP TABLE IF EXISTS `hisopdd0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hisopdd0000` (
  `HOD0` date NOT NULL,
  `HOD1` time NOT NULL,
  `HOD2` char(1) character set latin1 NOT NULL,
  `HOD3` int(7) NOT NULL,
  `HOD4` char(2) character set latin1 NOT NULL,
  `HOD5` int(5) NOT NULL auto_increment,
  `HOD6` char(13) character set latin1 default NULL,
  `HOD7` blob,
  `HOD8` double(10,2) NOT NULL default '0.00',
  `HOD9` double(10,3) NOT NULL default '0.000',
  `HOD10` double(10,3) NOT NULL default '0.000',
  `HOD11` double(5,3) NOT NULL default '0.000',
  `HOD12` double(10,3) NOT NULL default '0.000',
  `HOD13` int(3) NOT NULL default '0',
  `HOD14` double(10,3) NOT NULL default '0.000',
  `HOD15` char(23) character set latin1 default NULL,
  `HOD16` char(1) character set latin1 NOT NULL default 'A',
  PRIMARY KEY  (`HOD0`,`HOD1`,`HOD2`,`HOD3`,`HOD4`,`HOD5`),
  UNIQUE KEY `HOD0` (`HOD0`,`HOD1`,`HOD2`,`HOD3`,`HOD4`,`HOD5`),
  KEY `khdo` (`HOD0`,`HOD1`,`HOD2`,`HOD3`,`HOD4`,`HOD5`),
  KEY `khdoa` (`HOD5`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `hisopdd0000`
--

LOCK TABLES `hisopdd0000` WRITE;
/*!40000 ALTER TABLE `hisopdd0000` DISABLE KEYS */;
INSERT INTO `hisopdd0000` VALUES ('1899-12-30','00:00:00','A',14,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('1899-12-30','00:00:00','A',14,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-06-10','11:56:06','A',4,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-10','11:56:06','A',4,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-06-11','13:19:04','A',0,'',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-11','13:19:04','A',0,'',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-11','13:19:04','A',0,'',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-11','13:19:04','A',0,'',4,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:11:43','A',5,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-06-19','10:11:43','A',5,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-06-19','10:11:43','A',5,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-06-19','10:11:43','A',5,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-06-19','10:11:44','A',6,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:11:44','A',6,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:11:44','A',6,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:34:58','A',0,'',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:34:58','A',0,'',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-06-19','10:34:58','A',0,'',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:34:58','A',0,'',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-06-19','10:37:49','A',0,'',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:37:49','A',0,'',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-06-19','10:37:49','A',0,'',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:37:49','A',0,'',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-06-19','10:39:22','A',0,'',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:39:22','A',0,'',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-06-19','10:39:22','A',0,'',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:39:22','A',0,'',4,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:41:08','A',7,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:41:08','A',7,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:41:08','A',7,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-06-19','10:41:08','A',7,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-06-19','10:43:16','A',8,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:43:16','A',8,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-06-19','10:55:54','A',9,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:55:54','A',9,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','10:55:54','A',9,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','11:41:55','A',10,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-19','11:41:55','A',10,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-20','10:05:39','A',16,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-06-20','10:05:39','A',16,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-09-02','10:52:49','A',11,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-09-02','10:52:49','A',11,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-09-02','21:41:24','A',12,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-09-02','21:41:24','A',12,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-09-02','21:41:24','A',12,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-09-02','21:41:24','A',12,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-09-02','21:41:24','A',12,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-09-02','21:41:24','A',12,'A',6,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-09-03','17:23:45','A',13,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-09-03','17:23:45','A',13,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-09-04','15:44:37','A',14,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-09-04','15:44:37','A',14,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-09-04','15:44:45','A',15,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-09-04','15:44:45','A',15,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-09-04','15:44:49','A',17,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-09-04','15:44:49','A',17,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-10-15','13:01:44','A',16,'A',1,'1','CAJA ARTICULO 1',6.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-10-15','13:01:44','A',16,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-10-15','13:01:44','A',16,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-10-29','09:42:13','A',17,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-10-29','09:42:13','A',17,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-10-29','09:42:13','A',17,'A',3,'3','ARTICULO 3',1.00,174.000,150.000,0.000,150.000,16,174.000,'','A'),('2008-11-05','11:44:24','A',18,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-11-05','11:44:24','A',18,'A',2,'2','ARTICULO 2',1.00,2.600,2.241,0.000,2.240,16,2.600,'','A'),('2008-11-05','12:12:00','A',19,'A',1,'1','ARTICULO 1',-1.00,116.000,100.000,0.000,-100.000,16,-116.000,'','A'),('2008-11-05','12:12:28','A',20,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-11-05','12:12:28','A',20,'A',2,'2','ARTICULO 2',1.00,2.600,2.241,0.000,2.240,16,2.600,'','A'),('2008-11-06','10:50:14','A',21,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-11-06','10:50:14','A',21,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-11-06','10:50:14','A',21,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-03','13:03:52','A',22,'A',1,'3','ARTICULO 3',1.00,174.000,150.000,0.000,150.000,16,174.000,'','A'),('2008-12-03','13:03:52','A',22,'A',2,'2','ARTICULO 2',1.00,2.600,2.241,0.000,2.240,16,2.600,'','A'),('2008-12-03','13:03:52','A',22,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-03','13:03:52','A',22,'A',4,'2','ARTICULO 2',1.00,2.600,2.241,0.000,2.240,16,2.600,'','A'),('2008-12-08','11:27:50','A',23,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-08','11:27:50','A',23,'A',2,'2','ARTICULO 2',1.00,2.600,2.241,0.000,2.240,16,2.600,'','A'),('2008-12-08','12:04:49','A',24,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-08','12:04:49','A',24,'A',2,'2','ARTICULO 2',1.00,2.600,2.241,0.000,2.240,16,2.600,'','A'),('2008-12-08','12:08:28','A',25,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-08','12:08:28','A',25,'A',2,'2','ARTICULO 2',1.00,2.600,2.241,0.000,2.240,16,2.600,'','A'),('2008-12-08','12:08:28','A',25,'A',3,'3','ARTICULO 3',1.00,174.000,150.000,0.000,150.000,16,174.000,'','A'),('2008-12-08','19:39:28','A',26,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-08','19:39:33','A',27,'A',1,'2','ARTICULO 2',1.00,2.600,2.241,0.000,2.240,16,2.600,'','A'),('2008-12-18','16:37:45','A',28,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-18','16:38:33','A',29,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-18','16:38:42','A',30,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-18','16:39:15','A',31,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-19','12:21:06','A',32,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-19','12:21:06','A',32,'A',2,'A1','ARTICULO CON LETRAS',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-19','12:21:08','A',33,'A',1,'1','ARTICULO 1',-1.00,116.000,100.000,0.000,-100.000,16,-116.000,'','A'),('2008-12-19','12:21:21','A',18,'A',1,'A1','ARTICULO CON LETRAS',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-19','12:21:44','A',19,'A',1,'A1','ARTICULO CON LETRAS',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-19','12:22:53','A',20,'A',1,'A1','ARTICULO CON LETRAS',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-19','16:31:03','A',34,'A',1,'1','ENTREGA A CUENTA',1.00,50.000,0.000,0.000,0.000,16,50.000,'','A'),('2008-12-19','16:33:43','A',35,'A',1,'1','ENTREGA A CUENTA',1.00,0.000,0.000,0.000,0.000,0,0.000,'','A'),('2008-12-19','16:33:43','A',35,'A',2,'1','ENTREGA A CUENTA',1.00,0.000,0.000,0.000,0.000,0,0.000,'','A'),('2008-12-19','16:33:43','A',35,'A',3,'1','ENTREGA A CUENTA',1.00,0.000,0.000,0.000,0.000,0,0.000,'','A'),('2008-12-19','16:33:43','A',35,'A',4,'1','ARTICULO 1, ARTICULO 2, ARTICULO 3,',1.00,0.000,0.000,0.000,0.000,0,0.000,'','A'),('2008-12-19','16:33:43','A',35,'A',5,'1','ARTICULO 1, ARTICULO 2,',1.00,0.000,0.000,0.000,0.000,0,0.000,'','A'),('2008-12-19','16:38:33','A',36,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-19','16:38:33','A',36,'A',2,'A1','ARTICULO CON LETRAS',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-19','16:38:33','A',36,'A',3,'2','ARTICULO 2',1.00,2.600,2.241,0.000,2.240,16,2.600,'','A'),('2008-12-19','16:56:01','A',37,'A',1,'1','ENTREGA A CUENTA',1.00,100.000,0.000,0.000,0.000,16,100.000,'','A'),('2008-12-19','16:59:21','A',38,'A',1,'2','ARTICULO 2',1.00,2.600,2.241,0.000,2.240,16,2.600,'','A'),('2008-12-19','16:59:21','A',38,'A',2,'2','ARTICULO 2',1.00,2.600,2.241,0.000,2.240,16,2.600,'','A'),('2008-12-19','16:59:21','A',38,'A',3,'3','ARTICULO 3',1.00,174.000,150.000,0.000,150.000,16,174.000,'','A'),('2008-12-19','16:59:33','A',39,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-20','17:24:28','A',40,'A',1,'4','ARTICULO 4',1.00,2.320,2.160,0.000,2.160,7,2.310,'','A'),('2008-12-20','17:24:28','A',40,'A',2,'3','ARTICULO 3',1.00,174.000,150.000,0.000,150.000,16,174.000,'','A'),('2008-12-20','17:24:28','A',40,'A',3,'4','ARTICULO 4',1.00,2.320,2.160,0.000,2.160,7,2.310,'','A'),('2008-12-20','17:24:28','A',40,'A',4,'A1','ARTICULO CON LETRAS',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-20','17:24:41','A',41,'A',1,'1','ENTREGA A CUENTA',1.00,200.000,0.000,0.000,0.000,16,200.000,'','A'),('2008-12-29','16:04:51','A',22,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:04:51','A',22,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:06:56','A',23,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:06:56','A',23,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',24,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:07:50','A',24,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',24,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:07:50','A',24,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',25,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',25,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',25,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2008-12-29','16:07:50','A',25,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2008-12-29','16:07:50','A',25,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2008-12-29','16:07:50','A',25,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:07:50','A',25,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',25,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:07:50','A',25,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',25,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:07:50','A',25,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',25,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:07:50','A',25,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',25,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:07:50','A',25,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',26,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:07:50','A',26,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:07:50','A',26,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',26,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',26,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:07:50','A',26,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:07:50','A',26,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',26,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',26,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:07:50','A',26,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:07:50','A',26,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',26,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:07:50','A',26,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:07:50','A',26,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',27,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:10:49','A',27,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',27,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:10:49','A',27,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',28,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',28,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',28,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2008-12-29','16:10:49','A',28,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2008-12-29','16:10:49','A',28,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2008-12-29','16:10:49','A',28,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:10:49','A',28,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',28,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:10:49','A',28,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',28,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:10:49','A',28,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',28,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:10:49','A',28,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',28,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:10:49','A',28,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',29,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:10:49','A',29,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:10:49','A',29,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',29,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',29,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:10:49','A',29,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:10:49','A',29,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',29,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',29,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:10:49','A',29,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:10:49','A',29,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',29,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:10:49','A',29,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:10:49','A',29,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',30,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:11:48','A',30,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',30,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:11:48','A',30,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',31,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',31,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',31,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2008-12-29','16:11:48','A',31,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2008-12-29','16:11:48','A',31,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2008-12-29','16:11:48','A',31,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:11:48','A',31,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',31,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:11:48','A',31,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',31,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:11:48','A',31,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',31,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:11:48','A',31,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',31,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:11:48','A',31,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',32,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:11:48','A',32,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:11:48','A',32,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',32,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',32,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:11:48','A',32,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:11:48','A',32,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',32,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',32,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:11:48','A',32,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:11:48','A',32,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',32,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:11:48','A',32,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:11:48','A',32,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:22:33','A',33,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:22:33','A',33,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:22:33','A',33,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:22:33','A',33,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:23:53','A',34,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:23:53','A',34,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:23:53','A',34,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:23:53','A',34,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:32:56','A',35,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:32:56','A',35,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:32:56','A',35,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:32:56','A',35,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',36,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:34:14','',36,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',36,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:34:14','',36,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',37,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',37,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',37,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2008-12-29','16:34:14','',37,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2008-12-29','16:34:14','',37,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2008-12-29','16:34:14','',37,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:34:14','',37,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',37,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:34:14','',37,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',37,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:34:14','',37,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',37,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:34:14','',37,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',37,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:34:14','',37,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',38,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:34:14','',38,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:34:14','',38,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',38,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',38,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:34:14','',38,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:34:14','',38,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',38,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',38,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:34:14','',38,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:34:14','',38,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',38,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:34:14','',38,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:34:14','',38,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',39,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:38:48','',39,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',39,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:38:48','',39,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',40,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',40,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',40,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2008-12-29','16:38:48','',40,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2008-12-29','16:38:48','',40,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2008-12-29','16:38:48','',40,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:38:48','',40,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',40,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:38:48','',40,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',40,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:38:48','',40,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',40,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:38:48','',40,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',40,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:38:48','',40,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',41,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:38:48','',41,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:38:48','',41,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',41,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',41,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:38:48','',41,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:38:48','',41,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',41,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',41,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:38:48','',41,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:38:48','',41,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',41,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:38:48','',41,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:38:48','',41,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',42,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:49:58','A',42,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',42,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:49:58','A',42,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',43,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',43,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',43,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2008-12-29','16:49:58','A',43,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2008-12-29','16:49:58','A',43,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2008-12-29','16:49:58','A',43,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:49:58','A',43,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',43,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:49:58','A',43,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',43,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:49:58','A',43,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',43,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:49:58','A',43,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',43,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:49:58','A',43,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',44,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:49:58','A',44,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:49:58','A',44,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',44,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',44,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:49:58','A',44,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:49:58','A',44,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',44,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',44,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:49:58','A',44,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:49:58','A',44,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',44,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','16:49:58','A',44,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','16:49:58','A',44,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',45,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:03:24','A',45,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',45,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:03:24','A',45,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',46,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',46,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',46,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2008-12-29','21:03:24','A',46,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2008-12-29','21:03:24','A',46,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2008-12-29','21:03:24','A',46,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:03:24','A',46,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',46,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:03:24','A',46,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',46,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:03:24','A',46,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',46,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:03:24','A',46,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',46,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:03:24','A',46,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',47,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:03:24','A',47,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:03:24','A',47,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',47,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',47,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:03:24','A',47,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:03:24','A',47,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',47,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',47,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:03:24','A',47,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:03:24','A',47,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',47,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:03:24','A',47,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:03:24','A',47,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:07:26','A',48,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:07:26','A',48,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:07:26','A',48,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:07:26','A',48,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:07:26','A',48,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:07:26','A',48,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:07:26','A',48,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:07:26','A',48,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:07:26','A',48,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:07:26','A',48,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:07:26','A',48,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:07:26','A',48,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:07:26','A',48,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:07:26','A',48,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',49,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:09:36','A',49,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',49,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:09:36','A',49,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',50,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',50,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',50,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2008-12-29','21:09:36','A',50,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2008-12-29','21:09:36','A',50,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2008-12-29','21:09:36','A',50,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:09:36','A',50,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',50,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:09:36','A',50,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',50,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:09:36','A',50,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',50,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:09:36','A',50,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',50,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:09:36','A',50,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',51,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:09:36','A',51,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:09:36','A',51,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',51,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',51,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:09:36','A',51,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:09:36','A',51,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',51,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',51,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:09:36','A',51,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:09:36','A',51,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',51,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:09:36','A',51,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:09:36','A',51,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',52,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:10:23','',52,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',52,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:10:23','',52,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',53,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',53,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',53,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2008-12-29','21:10:23','',53,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2008-12-29','21:10:23','',53,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2008-12-29','21:10:23','',53,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:10:23','',53,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',53,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:10:23','',53,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',53,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:10:23','',53,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',53,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:10:23','',53,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',53,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:10:23','',53,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',54,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:10:23','',54,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:10:23','',54,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',54,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',54,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:10:23','',54,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:10:23','',54,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',54,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',54,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:10:23','',54,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:10:23','',54,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',54,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-29','21:10:23','',54,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-29','21:10:23','',54,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',55,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-30','15:56:19','A',55,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',55,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-30','15:56:19','A',55,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',56,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',56,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',56,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2008-12-30','15:56:19','A',56,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2008-12-30','15:56:19','A',56,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2008-12-30','15:56:19','A',56,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-30','15:56:19','A',56,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',56,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-30','15:56:19','A',56,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',56,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-30','15:56:19','A',56,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',56,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-30','15:56:19','A',56,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',56,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-30','15:56:19','A',56,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',57,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-30','15:56:19','A',57,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-30','15:56:19','A',57,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',57,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',57,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-30','15:56:19','A',57,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-30','15:56:19','A',57,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',57,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',57,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-30','15:56:19','A',57,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-30','15:56:19','A',57,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',57,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2008-12-30','15:56:19','A',57,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2008-12-30','15:56:19','A',57,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',58,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:53:18','A',58,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',58,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:53:18','A',58,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',59,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',59,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',59,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2009-01-05','10:53:18','A',59,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2009-01-05','10:53:18','A',59,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2009-01-05','10:53:18','A',59,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:53:18','A',59,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',59,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:53:18','A',59,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',59,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:53:18','A',59,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',59,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:53:18','A',59,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',59,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:53:18','A',59,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',60,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:53:18','A',60,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:53:18','A',60,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',60,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',60,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:53:18','A',60,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:53:18','A',60,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',60,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',60,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:53:18','A',60,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:53:18','A',60,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',60,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:53:18','A',60,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:53:18','A',60,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',61,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:58:52','',61,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',61,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:58:52','',61,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',62,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',62,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',62,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2009-01-05','10:58:52','',62,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2009-01-05','10:58:52','',62,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2009-01-05','10:58:52','',62,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:58:52','',62,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',62,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:58:52','',62,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',62,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:58:52','',62,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',62,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:58:52','',62,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',62,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:58:52','',62,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',63,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:58:52','',63,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:58:52','',63,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',63,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',63,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:58:52','',63,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:58:52','',63,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',63,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',63,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:58:52','',63,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:58:52','',63,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',63,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','10:58:52','',63,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','10:58:52','',63,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',64,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:00:35','',64,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',64,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:00:35','',64,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',65,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',65,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',65,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2009-01-05','11:00:35','',65,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2009-01-05','11:00:35','',65,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2009-01-05','11:00:35','',65,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:00:35','',65,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',65,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:00:35','',65,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',65,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:00:35','',65,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',65,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:00:35','',65,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',65,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:00:35','',65,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',66,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:00:35','',66,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:00:35','',66,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',66,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',66,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:00:35','',66,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:00:35','',66,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',66,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',66,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:00:35','',66,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:00:35','',66,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',66,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:00:35','',66,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:00:35','',66,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',67,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:01:53','A',67,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',67,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:01:53','A',67,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',68,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',68,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',68,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2009-01-05','11:01:53','A',68,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2009-01-05','11:01:53','A',68,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2009-01-05','11:01:53','A',68,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:01:53','A',68,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',68,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:01:53','A',68,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',68,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:01:53','A',68,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',68,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:01:53','A',68,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',68,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:01:53','A',68,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',69,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:01:53','A',69,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:01:53','A',69,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',69,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',69,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:01:53','A',69,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:01:53','A',69,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',69,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',69,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:01:53','A',69,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:01:53','A',69,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',69,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:01:53','A',69,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:01:53','A',69,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:30:55','A',70,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:30:55','A',70,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',71,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:42:41','',71,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',71,'A',3,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:42:41','',71,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',72,'A',1,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',72,'A',2,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',72,'A',3,'1','ARTICULO 1',10.00,116.000,100.000,0.000,1000.000,16,1160.000,'','A'),('2009-01-05','11:42:41','',72,'A',4,'2','ARTICULO 2',10.00,232.000,200.000,0.000,2000.000,16,2320.000,'','A'),('2009-01-05','11:42:41','',72,'A',5,'1','ARTICULO 1',5.00,116.000,100.000,0.000,500.000,16,580.000,'','A'),('2009-01-05','11:42:41','',72,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:42:41','',72,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',72,'A',8,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:42:41','',72,'A',9,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',72,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:42:41','',72,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',72,'A',12,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:42:41','',72,'A',13,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',72,'A',14,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:42:41','',72,'A',15,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',73,'A',1,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:42:41','',73,'A',2,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:42:41','',73,'A',3,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',73,'A',4,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',73,'A',5,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:42:41','',73,'A',6,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:42:41','',73,'A',7,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',73,'A',8,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',73,'A',9,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:42:41','',73,'A',10,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:42:41','',73,'A',11,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',73,'A',12,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A'),('2009-01-05','11:42:41','',73,'A',13,'1','ARTICULO 1',1.00,116.000,100.000,0.000,100.000,16,116.000,'','A'),('2009-01-05','11:42:41','',73,'A',14,'2','ARTICULO 2',1.00,232.000,200.000,0.000,200.000,16,232.000,'','A');
/*!40000 ALTER TABLE `hisopdd0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `histoclie`
--

DROP TABLE IF EXISTS `histoclie`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `histoclie` (
  `HC0` int(11) NOT NULL default '0',
  `HC1` date NOT NULL,
  `HC2` time NOT NULL,
  `HC3` int(5) NOT NULL auto_increment,
  `HC4` char(13) character set latin1 default NULL,
  `HC5` char(50) character set latin1 default NULL,
  `HC6` double(10,3) default '0.000',
  `HC7` double(10,2) default '0.00',
  PRIMARY KEY  (`HC0`,`HC1`,`HC2`,`HC3`),
  UNIQUE KEY `HC0` (`HC0`,`HC1`,`HC2`,`HC3`),
  KEY `khc` (`HC0`,`HC1`,`HC2`,`HC3`),
  KEY `khca` (`HC3`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `histoclie`
--

LOCK TABLES `histoclie` WRITE;
/*!40000 ALTER TABLE `histoclie` DISABLE KEYS */;
INSERT INTO `histoclie` VALUES (1,'1899-12-30','00:00:00',1,'1','ARTICULO 1',1.000,116.00),(1,'1899-12-30','00:00:00',2,'1','ARTICULO 1',1.000,116.00),(1,'1899-12-30','00:00:00',3,'2','ARTICULO 2',1.000,232.00),(1,'1899-12-30','00:00:00',4,'1','ARTICULO 1',2.000,232.00),(1,'1899-12-30','00:00:00',5,'2','ARTICULO 2',2.000,464.00),(1,'1899-12-30','00:00:00',6,'1','ARTICULO 1',1.000,116.00),(1,'1899-12-30','00:00:00',7,'2','ARTICULO 2',1.000,232.00),(1,'1899-12-30','00:00:00',8,'1','ARTICULO 1',1.000,116.00),(1,'1899-12-30','00:00:00',9,'2','ARTICULO 2',1.000,232.00),(1,'1899-12-30','00:00:00',10,'1','ARTICULO 1',1.000,116.00),(1,'1899-12-30','00:00:00',11,'2','ARTICULO 2',1.000,232.00),(1,'1899-12-30','00:00:00',12,'1','ARTICULO 1',1.000,116.00),(1,'1899-12-30','00:00:00',13,'2','ARTICULO 2',1.000,232.00),(1,'1899-12-30','00:00:00',14,'1','ARTICULO 1',1.000,116.00),(1,'1899-12-30','00:00:00',15,'2','ARTICULO 2',1.000,232.00),(1,'1899-12-30','00:00:00',16,'1','ARTICULO 1',1.000,116.00),(1,'1899-12-30','00:00:00',17,'2','ARTICULO 2',1.000,232.00),(1,'1899-12-30','00:00:00',18,'1','ARTICULO 1',1.000,116.00),(1,'1899-12-30','00:00:00',19,'2','ARTICULO 2',1.000,232.00),(1,'1899-12-30','00:00:00',20,'1','ARTICULO 1',1.000,116.00),(1,'1899-12-30','00:00:00',21,'2','ARTICULO 2',1.000,232.00),(1,'2008-05-26','19:23:49',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-05-26','19:23:49',2,'2','ARTICULO 2',1.000,232.00),(1,'2008-05-26','19:24:48',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-05-26','19:24:48',2,'2','ARTICULO 2',1.000,232.00),(1,'2008-05-28','12:52:29',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-05-28','12:52:29',2,'2','ARTICULO 2',1.000,232.00),(1,'2008-05-28','12:52:29',3,'2','ARTICULO 2',1.000,232.00),(1,'2008-05-28','13:09:35',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-05-28','13:09:35',2,'2','ARTICULO 2',1.000,232.00),(1,'2008-06-03','11:10:16',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-06-03','11:10:16',2,'2','ARTICULO 2',1.000,232.00),(1,'2008-06-20','10:05:39',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-06-20','10:05:39',2,'2','ARTICULO 2',1.000,232.00),(1,'2008-09-02','21:41:24',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-09-02','21:41:24',2,'2','ARTICULO 2',1.000,232.00),(1,'2008-09-02','21:41:24',3,'1','ARTICULO 1',1.000,116.00),(1,'2008-09-02','21:41:24',4,'2','ARTICULO 2',1.000,232.00),(1,'2008-09-02','21:41:24',5,'1','ARTICULO 1',1.000,116.00),(1,'2008-09-02','21:41:24',6,'2','ARTICULO 2',1.000,232.00),(1,'2008-09-04','15:44:37',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-09-04','15:44:37',2,'2','ARTICULO 2',1.000,232.00),(1,'2008-09-04','15:44:45',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-09-04','15:44:45',2,'2','ARTICULO 2',1.000,232.00),(1,'2008-09-04','15:44:49',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-09-04','15:44:49',2,'2','ARTICULO 2',1.000,232.00),(1,'2008-11-05','11:44:24',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-11-05','11:44:24',2,'2','ARTICULO 2',1.000,2.60),(1,'2008-11-05','12:12:00',1,'1','ARTICULO 1',-1.000,-116.00),(1,'2008-11-06','10:50:14',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-11-06','10:50:14',2,'1','ARTICULO 1',1.000,116.00),(1,'2008-11-06','10:50:14',3,'1','ARTICULO 1',1.000,116.00),(1,'2008-12-03','13:03:52',1,'3','ARTICULO 3',1.000,174.00),(1,'2008-12-03','13:03:52',2,'2','ARTICULO 2',1.000,2.60),(1,'2008-12-03','13:03:52',3,'1','ARTICULO 1',1.000,116.00),(1,'2008-12-03','13:03:52',4,'2','ARTICULO 2',1.000,2.60),(1,'2008-12-08','11:27:50',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-12-08','11:27:50',2,'2','ARTICULO 2',1.000,2.60),(1,'2008-12-08','12:04:49',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-12-08','12:04:49',2,'2','ARTICULO 2',1.000,2.60),(1,'2008-12-08','12:08:28',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-12-08','12:08:28',2,'2','ARTICULO 2',1.000,2.60),(1,'2008-12-08','12:08:28',3,'3','ARTICULO 3',1.000,174.00),(1,'2008-12-19','12:21:21',1,'A1','ARTICULO CON LETRAS',1.000,116.00),(1,'2008-12-19','12:21:44',1,'A1','ARTICULO CON LETRAS',1.000,116.00),(1,'2008-12-19','12:22:53',1,'A1','ARTICULO CON LETRAS',1.000,116.00),(1,'2008-12-19','16:38:33',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-12-19','16:38:33',2,'A1','ARTICULO CON LETRAS',1.000,116.00),(1,'2008-12-19','16:38:33',3,'2','ARTICULO 2',1.000,2.60),(1,'2008-12-19','16:59:21',1,'2','ARTICULO 2',1.000,2.60),(1,'2008-12-19','16:59:21',2,'2','ARTICULO 2',1.000,2.60),(1,'2008-12-19','16:59:21',3,'3','ARTICULO 3',1.000,174.00),(1,'2008-12-19','16:59:33',1,'1','ARTICULO 1',1.000,116.00),(1,'2008-12-20','17:24:28',1,'4','ARTICULO 4',1.000,2.31),(1,'2008-12-20','17:24:28',2,'3','ARTICULO 3',1.000,174.00),(1,'2008-12-20','17:24:28',3,'4','ARTICULO 4',1.000,2.31),(1,'2008-12-20','17:24:28',4,'A1','ARTICULO CON LETRAS',1.000,116.00),(2,'1899-12-30','00:00:00',1,'1','ARTICULO 1',1.000,116.00),(2,'1899-12-30','00:00:00',2,'2','ARTICULO 2',1.000,232.00),(2,'1899-12-30','00:00:00',3,'1','ARTICULO 1',1.000,116.00),(2,'1899-12-30','00:00:00',4,'1','ARTICULO 1',1.000,116.00),(2,'1899-12-30','00:00:00',5,'2','ARTICULO 2',1.000,232.00),(2,'1899-12-30','00:00:00',6,'1','ARTICULO 1',1.000,116.00),(2,'1899-12-30','00:00:00',7,'2','ARTICULO 2',1.000,232.00),(2,'1899-12-30','00:00:00',8,'1','ARTICULO 1',1.000,116.00),(2,'1899-12-30','00:00:00',9,'2','ARTICULO 2',1.000,232.00),(2,'1899-12-30','00:00:00',10,'1','ARTICULO 1',1.000,116.00),(2,'1899-12-30','00:00:00',11,'2','ARTICULO 2',1.000,232.00),(2,'1899-12-30','00:00:00',12,'1','ARTICULO 1',1.000,116.00),(2,'1899-12-30','00:00:00',13,'2','ARTICULO 2',1.000,232.00),(2,'2008-05-26','19:25:24',1,'1','ARTICULO 1',1.000,116.00),(2,'2008-05-26','19:25:24',2,'2','ARTICULO 2',1.000,232.00),(2,'2008-06-03','11:11:12',1,'1','ARTICULO 1',1.000,116.00),(2,'2008-06-03','11:11:12',2,'2','ARTICULO 2',1.000,232.00),(2,'2008-09-02','10:52:49',1,'1','ARTICULO 1',1.000,116.00),(2,'2008-09-02','10:52:49',2,'2','ARTICULO 2',1.000,232.00),(3,'1899-12-30','00:00:00',1,'1','ARTICULO 1',1.000,116.00),(3,'1899-12-30','00:00:00',2,'2','ARTICULO 2',1.000,232.00),(3,'1899-12-30','00:00:00',3,'1','ARTICULO 1',1.000,116.00),(3,'1899-12-30','00:00:00',4,'2','ARTICULO 2',1.000,232.00),(3,'1899-12-30','00:00:00',5,'1','ARTICULO 1',1.000,116.00),(3,'1899-12-30','00:00:00',6,'1','ARTICULO 1',1.000,116.00),(3,'1899-12-30','00:00:00',7,'2','ARTICULO 2',1.000,232.00),(3,'1899-12-30','00:00:00',8,'2','ARTICULO 2',1.000,232.00),(3,'1899-12-30','00:00:00',9,'1','ARTICULO 1',1.000,116.00),(3,'1899-12-30','00:00:00',10,'1','ARTICULO 1',1.000,116.00),(3,'1899-12-30','00:00:00',11,'2','ARTICULO 2',1.000,232.00),(3,'1899-12-30','00:00:00',12,'2','ARTICULO 2',1.000,232.00),(3,'1899-12-30','00:00:00',13,'1','ARTICULO 1',1.000,116.00),(3,'1899-12-30','00:00:00',14,'1','ARTICULO 1',1.000,116.00),(3,'1899-12-30','00:00:00',15,'2','ARTICULO 2',1.000,232.00),(3,'1899-12-30','00:00:00',16,'2','ARTICULO 2',1.000,232.00),(3,'1899-12-30','00:00:00',17,'1','ARTICULO 1',1.000,116.00),(3,'1899-12-30','00:00:00',18,'1','ARTICULO 1',1.000,116.00),(3,'1899-12-30','00:00:00',19,'2','ARTICULO 2',1.000,232.00),(3,'1899-12-30','00:00:00',20,'2','ARTICULO 2',1.000,232.00),(3,'1899-12-30','00:00:00',21,'1','ARTICULO 1',1.000,116.00),(3,'1899-12-30','00:00:00',22,'2','ARTICULO 2',1.000,232.00),(3,'2008-05-27','10:05:44',1,'1','ARTICULO 1',1.000,116.00),(3,'2008-05-27','10:05:44',2,'1','ARTICULO 1',1.000,116.00),(3,'2008-05-27','10:05:44',3,'2','ARTICULO 2',1.000,232.00),(3,'2008-05-27','10:05:44',4,'2','ARTICULO 2',1.000,232.00),(3,'2008-06-03','11:11:12',1,'1','ARTICULO 1',1.000,116.00),(3,'2008-06-03','11:11:12',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-26','13:01:20',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-26','13:01:20',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-26','13:23:12',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-26','13:23:12',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-26','19:24:52',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-26','19:24:52',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-27','10:05:44',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-27','10:05:44',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-27','17:41:12',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-27','17:41:12',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-27','17:59:32',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-27','17:59:32',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-27','18:53:36',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-27','18:53:36',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','12:45:18',1,'2','ARTICULO 2',1.230,285.36),(999999,'2008-05-28','12:45:18',2,'1','ARTICULO 1',10.000,1160.00),(999999,'2008-05-28','12:45:33',1,'1','ARTICULO 1',10.000,1160.00),(999999,'2008-05-28','12:45:33',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','12:45:33',3,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','12:46:28',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','12:46:28',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','12:46:28',3,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','12:47:53',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','12:47:53',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','12:58:29',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','12:58:29',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','12:58:29',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:09:24',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:09:24',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:09:24',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:23',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:23',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:23',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:23',4,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:23',5,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:23',6,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:23',7,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:23',8,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:23',9,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:23',10,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:23',11,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:23',12,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:23',13,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:23',14,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:23',15,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:23',16,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:23',17,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:23',18,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:23',19,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:23',20,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:23',21,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:23',22,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:36',1,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:36',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:41',1,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:41',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','13:11:41',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:41',4,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:45',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','13:11:45',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','14:14:15',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','14:14:15',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','14:14:15',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','14:14:21',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','14:14:21',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-28','14:14:21',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-28','14:14:21',4,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-30','10:16:15',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-30','10:16:15',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-30','10:16:15',3,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-30','10:16:15',4,'2','ARTICULO 2',1.000,232.00),(999999,'2008-05-30','10:16:15',5,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-30','10:18:30',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-05-30','10:18:30',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:34:23',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:34:23',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:34:23',3,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:35:52',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:35:52',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:35:52',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:35:52',4,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:35:52',5,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:35:52',6,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:36:58',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:36:58',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:36:58',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:36:58',4,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:37:32',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:37:32',2,'2','ARTICULO 2',2.000,464.00),(999999,'2008-06-02','11:37:32',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:37:32',4,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:37:32',5,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:39:29',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:39:29',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:39:29',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:39:29',4,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:40:16',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:40:16',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:40:16',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:40:16',4,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:40:16',5,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:41:00',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:41:00',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:41:00',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:41:00',4,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:41:00',5,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:41:00',6,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:41:00',7,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:00',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:00',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:00',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:00',4,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:00',5,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:03',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:03',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:43:03',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:03',4,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:43:03',5,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:03',6,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:43:24',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:24',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:43:24',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:24',4,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:24',5,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:43:24',6,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:43:32',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:32',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:43:32',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:32',4,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:43:35',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:35',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-02','11:43:35',3,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:43:35',4,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-02','11:43:35',5,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-06','10:08:44',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-06','10:45:12',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-06','11:46:56',1,'1','ARTICULO 1',1.000,104.40),(999999,'2008-06-06','11:47:43',1,'1','ARTICULO 1',1.000,104.40),(999999,'2008-06-06','11:47:43',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-06','11:47:43',3,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-06','11:47:43',4,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-06','11:47:48',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-06','11:47:48',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-06','11:47:48',3,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-06','11:47:48',4,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-06','11:47:48',5,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-10','11:56:06',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-10','11:56:06',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-11','08:32:35',1,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-11','08:32:35',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-11','13:19:04',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-11','13:19:04',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-11','13:19:04',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-11','13:19:04',4,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:11:43',1,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-19','10:11:43',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-19','10:11:43',3,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-19','10:11:43',4,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-19','10:11:44',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:11:44',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:11:44',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:34:58',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:34:58',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-19','10:34:58',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:34:58',4,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-19','10:37:49',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:37:49',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-19','10:37:49',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:37:49',4,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-19','10:39:22',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:39:22',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-19','10:39:22',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:39:22',4,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:41:08',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:41:08',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:41:08',3,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-19','10:41:08',4,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-19','10:43:16',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:43:16',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-06-19','10:55:54',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:55:54',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','10:55:54',3,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','11:41:55',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-06-19','11:41:55',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-09-03','17:23:45',1,'2','ARTICULO 2',1.000,232.00),(999999,'2008-09-03','17:23:45',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-10-15','13:01:44',1,'1','CAJA ARTICULO 1',6.000,116.00),(999999,'2008-10-15','13:01:44',2,'1','ARTICULO 1',1.000,116.00),(999999,'2008-10-15','13:01:44',3,'2','ARTICULO 2',1.000,232.00),(999999,'2008-10-29','09:42:13',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-10-29','09:42:13',2,'2','ARTICULO 2',1.000,232.00),(999999,'2008-10-29','09:42:13',3,'3','ARTICULO 3',1.000,174.00),(999999,'2008-11-05','12:12:28',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-11-05','12:12:28',2,'2','ARTICULO 2',1.000,2.60),(999999,'2008-12-08','19:39:28',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-12-08','19:39:33',1,'2','ARTICULO 2',1.000,2.60),(999999,'2008-12-18','16:37:45',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-12-18','16:38:33',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-12-18','16:38:42',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-12-18','16:39:15',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-12-19','12:21:06',1,'1','ARTICULO 1',1.000,116.00),(999999,'2008-12-19','12:21:06',2,'A1','ARTICULO CON LETRAS',1.000,116.00),(999999,'2008-12-19','12:21:08',1,'1','ARTICULO 1',-1.000,-116.00);
/*!40000 ALTER TABLE `histoclie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedicc0000`
--

DROP TABLE IF EXISTS `pedicc0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pedicc0000` (
  `PC0` int(4) NOT NULL default '0',
  `PC1` date NOT NULL,
  `PC2` int(11) NOT NULL default '0',
  `PC3` char(2) character set latin1 NOT NULL,
  `PC4` int(6) NOT NULL default '0',
  `PC5` int(6) NOT NULL default '0',
  `PC6` int(7) NOT NULL default '0',
  `PC7` double(10,2) NOT NULL default '0.00',
  `PC8` double(10,2) NOT NULL default '0.00',
  `PC9` double(10,2) NOT NULL default '0.00',
  `PC10` char(1) character set latin1 default NULL,
  `PC11` char(1) character set latin1 default NULL,
  `PC12` char(100) character set latin1 default NULL,
  `PC13` char(50) character set latin1 default NULL,
  `PC14` int(11) NOT NULL default '0',
  `PC15` char(50) character set latin1 default NULL,
  `PC16` char(50) character set latin1 default NULL,
  `PC17` double(10,2) NOT NULL default '0.00',
  `PC18` double(10,2) NOT NULL default '0.00',
  `PC19` double(10,2) NOT NULL default '0.00',
  `PC20` date default NULL,
  `PC21` double(10,2) NOT NULL default '0.00',
  `PC22` date default NULL,
  `PC23` double(10,2) NOT NULL default '0.00',
  `PC24` date default NULL,
  `PC25` double(10,2) NOT NULL default '0.00',
  `PC26` date default NULL,
  `PC27` double(10,2) NOT NULL default '0.00',
  `PC28` char(1) character set latin1 default NULL,
  `PC29` char(30) character set latin1 default NULL,
  `PC30` date default NULL,
  `PC31` blob,
  PRIMARY KEY  (`PC0`,`PC1`,`PC2`,`PC3`,`PC4`),
  UNIQUE KEY `PC0` (`PC0`,`PC1`,`PC2`,`PC3`,`PC4`),
  KEY `kpc` (`PC0`,`PC1`,`PC2`,`PC3`,`PC4`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `pedicc0000`
--

LOCK TABLES `pedicc0000` WRITE;
/*!40000 ALTER TABLE `pedicc0000` DISABLE KEYS */;
INSERT INTO `pedicc0000` VALUES (0,'2008-08-23',1,'A',1,2,2,160.00,185.60,232.00,'N','','','PROVEEDOR 1',0,NULL,NULL,0.00,0.00,0.00,'2008-09-23',266.80,NULL,0.00,NULL,0.00,NULL,0.00,NULL,NULL,NULL,NULL),(0,'2008-09-01',2,'A',2,2,3,240.00,278.40,348.00,'N','','','PROVEEDOR 2',1,'GARCIA PEREZ, JUAN JOSE','924111111',696.00,696.00,0.00,NULL,0.00,NULL,0.00,NULL,0.00,NULL,0.00,NULL,NULL,NULL,NULL),(0,'2008-09-02',1,'A',5,3,3,240.00,278.40,407.00,'N','','','PROVEEDOR 1',0,NULL,NULL,0.00,0.00,0.00,NULL,0.00,NULL,0.00,NULL,0.00,NULL,0.00,NULL,NULL,NULL,NULL),(0,'2008-09-02',1,'A',6,5,-56,-4480.00,-5196.80,-6496.00,'N','','','PROVEEDOR 1',0,NULL,NULL,0.00,0.00,0.00,NULL,0.00,NULL,0.00,NULL,0.00,NULL,0.00,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `pedicc0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidd0000`
--

DROP TABLE IF EXISTS `pedidd0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pedidd0000` (
  `PD0` int(4) NOT NULL default '0',
  `PD1` date NOT NULL,
  `PD2` int(11) NOT NULL default '0',
  `PD3` char(2) character set latin1 NOT NULL,
  `PD4` int(5) NOT NULL,
  `PD5` int(6) NOT NULL auto_increment,
  `PD6` char(13) character set latin1 NOT NULL,
  `PD7` char(50) character set latin1 default NULL,
  `PD8` double(10,2) NOT NULL default '0.00',
  `PD9` double(10,2) NOT NULL default '0.00',
  `PD10` double(10,3) NOT NULL default '0.000',
  `PD11` double(5,3) NOT NULL default '0.000',
  `PD12` double(10,3) NOT NULL default '0.000',
  `PD13` double(5,2) NOT NULL default '0.00',
  `PD14` double(5,2) NOT NULL default '0.00',
  `PD15` double(10,3) NOT NULL default '0.000',
  `PD16` double(10,2) NOT NULL default '0.00',
  `PD17` double(10,2) NOT NULL default '0.00',
  `PD18` double(10,2) NOT NULL default '0.00',
  `PD19` int(4) NOT NULL default '0',
  `PD20` double(10,2) NOT NULL default '0.00',
  `PD21` double(10,2) NOT NULL default '0.00',
  `PD22` double(10,2) NOT NULL default '0.00',
  `PD23` char(1) character set latin1 NOT NULL default 'S',
  `PD24` char(6) character set latin1 default NULL,
  `PD25` char(6) character set latin1 default NULL,
  `PD26` double(10,3) NOT NULL default '0.000',
  `PD27` double(10,3) NOT NULL default '0.000',
  `PD28` double(10,3) NOT NULL default '0.000',
  `PD29` double(10,3) NOT NULL default '0.000',
  PRIMARY KEY  (`PD0`,`PD1`,`PD2`,`PD3`,`PD4`,`PD5`),
  UNIQUE KEY `PD0` (`PD0`,`PD1`,`PD2`,`PD3`,`PD4`,`PD5`),
  KEY `kpd` (`PD0`,`PD1`,`PD2`,`PD3`,`PD4`,`PD5`),
  KEY `kpda` (`PD5`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `pedidd0000`
--

LOCK TABLES `pedidd0000` WRITE;
/*!40000 ALTER TABLE `pedidd0000` DISABLE KEYS */;
INSERT INTO `pedidd0000` VALUES (0,'2008-08-23',1,'A',1,1,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-75.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-08-23',1,'A',1,2,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-94.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-01',2,'A',2,1,'1','ARTICULO 1',2.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,185.60,232.00,1,-75.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-01',2,'A',2,3,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-75.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',1,'A',5,1,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-76.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',1,'A',5,3,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-76.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',1,'A',5,5,'3','ARTICULO 3',1.00,0.00,80.000,88.578,150.862,0.00,16.00,92.800,175.00,92.80,175.00,1,100.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',1,'A',6,1,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-76.00,0.00,0.00,'S','','',100.000,0.000,20.000,0.000),(0,'2008-09-02',1,'A',6,3,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-76.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',1,'A',6,6,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-76.00,0.00,0.00,'S','','',100.000,0.000,20.000,0.000),(0,'2008-09-02',1,'A',6,8,'1','ARTICULO 1',1.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,92.80,116.00,1,-76.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000),(0,'2008-09-02',1,'A',6,10,'1','CAJA ARTICULO 1',-60.00,0.00,80.000,25.000,100.000,0.00,16.00,92.800,116.00,-5568.00,-6960.00,1,-82.00,0.00,0.00,'S','','',0.000,0.000,0.000,0.000);
/*!40000 ALTER TABLE `pedidd0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `proveedores` (
  `P0` int(11) NOT NULL default '0',
  `P1` char(50) character set latin1 default NULL,
  `P2` char(50) character set latin1 default NULL,
  `P3` char(50) character set latin1 default NULL,
  `P4` char(6) character set latin1 default NULL,
  `P5` char(50) character set latin1 default NULL,
  `P6` char(15) character set latin1 default NULL,
  `P7` char(20) character set latin1 default NULL,
  `P8` char(20) character set latin1 default NULL,
  `P9` char(50) character set latin1 default NULL,
  `P10` char(20) character set latin1 default NULL,
  `P11` int(2) default NULL,
  `P12` char(2) character set latin1 default NULL,
  `P13` int(2) default NULL,
  `P14` char(10) character set latin1 default NULL,
  `P15` int(3) default NULL,
  `P16` int(3) default NULL,
  `P17` int(3) default NULL,
  `P18` double(5,2) default NULL,
  `P19` double(5,2) default NULL,
  `P20` char(1) character set latin1 default NULL,
  `P21` double(10,2) default NULL,
  `P22` date default NULL,
  `P23` date default NULL,
  `P24` char(50) character set latin1 default NULL,
  `P25` char(1) character set latin1 default NULL,
  `P26` char(50) character set latin1 default NULL,
  `P27` char(50) character set latin1 default NULL,
  `P28` char(50) character set latin1 default NULL,
  `P29` char(20) character set latin1 default NULL,
  `P30` char(50) character set latin1 default NULL,
  `P31` char(50) character set latin1 default NULL,
  `P32` char(20) character set latin1 default NULL,
  `P33` char(20) character set latin1 default NULL,
  `P34` char(50) character set latin1 default NULL,
  `P35` blob,
  `P36` char(6) character set latin1 default NULL,
  `P37` char(6) character set latin1 default NULL,
  `P38` int(11) default NULL,
  `P39` varchar(20) character set latin1 default NULL,
  PRIMARY KEY  (`P0`),
  UNIQUE KEY `P0` (`P0`),
  KEY `kpd` (`P0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
INSERT INTO `proveedores` VALUES (1,'PROVEEDOR 1','','','','','','','924221122','','',6,'1',NULL,'',NULL,NULL,NULL,NULL,NULL,'',NULL,'2008-11-06',NULL,'','','','','','','','','','','proveedor1@email.es',NULL,NULL,NULL,NULL,NULL),(2,'PROVEEDOR 2','','','','','','','924112211','','',NULL,'',NULL,'',NULL,NULL,NULL,NULL,NULL,'',NULL,'2008-09-04',NULL,'','','','','','','','','','','',NULL,NULL,NULL,NULL,NULL),(3,'PROVEEDOR 3','DIRECCION 3','LOCALIDAD 3','06003','PROVINCIA 3','B33221122','924121212','924212121','REPRESENTANTE 3','',NULL,'',NULL,'',NULL,NULL,NULL,NULL,NULL,'',NULL,'2009-01-05','2008-09-02','','','','','','','','','','','prove3@email.es',NULL,NULL,NULL,NULL,NULL),(4,'PROVEEDOR 4','','','','','','','','','',NULL,'',NULL,'',NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL,'','','','','','','','','','','',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `puestos0000`
--

DROP TABLE IF EXISTS `puestos0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `puestos0000` (
  `PT0` char(2) character set latin1 NOT NULL,
  `PT1` char(50) character set latin1 default NULL,
  `PT2` char(20) character set latin1 default NULL,
  `PT3` char(15) character set latin1 default NULL,
  `PT4` char(4) character set latin1 default NULL,
  `PT5` char(15) character set latin1 default NULL,
  `PT6` char(15) character set latin1 default NULL,
  PRIMARY KEY  (`PT0`),
  UNIQUE KEY `PT0` (`PT0`),
  KEY `kpt` (`PT0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `puestos0000`
--

LOCK TABLES `puestos0000` WRITE;
/*!40000 ALTER TABLE `puestos0000` DISABLE KEYS */;
INSERT INTO `puestos0000` VALUES ('A','PUESTO A','','','','',''),('B','PUESTO B','','','','',''),('C','PUESTO C','','','','','');
/*!40000 ALTER TABLE `puestos0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rutas`
--

DROP TABLE IF EXISTS `rutas`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rutas` (
  `RUT0` int(7) NOT NULL default '0',
  `RUT1` char(50) character set latin1 default NULL,
  `RUT2` char(50) character set latin1 default NULL,
  `RUT3` char(50) character set latin1 default NULL,
  PRIMARY KEY  (`RUT0`),
  UNIQUE KEY `RUT0` (`RUT0`),
  KEY `krut` (`RUT0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `rutas`
--

LOCK TABLES `rutas` WRITE;
/*!40000 ALTER TABLE `rutas` DISABLE KEYS */;
INSERT INTO `rutas` VALUES (1,'RUTA 1','LOCALIDAD 1','PROVINCIA 1'),(2,'RUTA 2','LOCALIDAD 1','PROVINCIA 1');
/*!40000 ALTER TABLE `rutas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seriesfactu`
--

DROP TABLE IF EXISTS `seriesfactu`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `seriesfactu` (
  `SF0` char(2) character set latin1 NOT NULL,
  `SF1` char(50) character set latin1 default NULL,
  `SF2` int(7) NOT NULL default '0',
  `SF3` int(7) NOT NULL default '0',
  `SF4` int(7) NOT NULL default '0',
  `SF5` char(1) character set latin1 NOT NULL default 'N',
  `SF6` int(7) NOT NULL default '0',
  `SF7` int(7) NOT NULL default '0',
  PRIMARY KEY  (`SF0`),
  UNIQUE KEY `SF0` (`SF0`),
  KEY `ksf` (`SF0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `seriesfactu`
--

LOCK TABLES `seriesfactu` WRITE;
/*!40000 ALTER TABLE `seriesfactu` DISABLE KEYS */;
INSERT INTO `seriesfactu` VALUES ('08','SERIE 08',800095,0,0,'N',0,0),('A','SERIE A 2008',75,14,41,'N',0,8),('B','SERIE B 2008',0,0,0,'N',0,0);
/*!40000 ALTER TABLE `seriesfactu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarifas`
--

DROP TABLE IF EXISTS `tarifas`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tarifas` (
  `TAR0` char(13) character set latin1 NOT NULL,
  `TAR1` double(8,3) NOT NULL default '0.000',
  `TAR2` double(10,3) NOT NULL default '0.000',
  `TAR3` double(8,3) NOT NULL default '0.000',
  `TAR4` double(10,3) NOT NULL default '0.000',
  `TAR5` double(8,3) NOT NULL default '0.000',
  `TAR6` double(10,3) NOT NULL default '0.000',
  `TAR7` double(10,2) NOT NULL default '0.00',
  `TAR8` double(10,2) NOT NULL default '0.00',
  `TAR9` double(10,2) NOT NULL default '0.00',
  PRIMARY KEY  (`TAR0`),
  UNIQUE KEY `TAR0` (`TAR0`),
  KEY `ktar` (`TAR0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `tarifas`
--

LOCK TABLES `tarifas` WRITE;
/*!40000 ALTER TABLE `tarifas` DISABLE KEYS */;
INSERT INTO `tarifas` VALUES ('1',0.000,0.000,0.000,0.000,0.000,0.000,0.00,0.00,0.00),('3',0.000,0.000,0.000,0.000,0.000,0.000,0.00,0.00,0.00),('4',0.000,0.000,0.000,0.000,0.000,0.000,0.00,0.00,0.00),('999999999',0.000,0.000,0.000,0.000,0.000,0.000,0.00,0.00,0.00),('A1',0.000,0.000,0.000,0.000,0.000,0.000,0.00,0.00,0.00);
/*!40000 ALTER TABLE `tarifas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tiendas`
--

DROP TABLE IF EXISTS `tiendas`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tiendas` (
  `T0` int(4) NOT NULL,
  `T1` char(50) character set latin1 default NULL,
  `T2` char(50) character set latin1 default NULL,
  `T3` char(50) character set latin1 default NULL,
  `T4` char(6) character set latin1 default NULL,
  `T5` char(50) character set latin1 default NULL,
  `T6` char(20) character set latin1 default NULL,
  `T7` char(20) character set latin1 default NULL,
  `T8` char(15) character set latin1 default NULL,
  `T9` date default NULL,
  `T10` date default NULL,
  `T11` char(2) character set latin1 default NULL,
  `T12` char(15) character set latin1 default NULL,
  `T13` char(4) character set latin1 default NULL,
  `T14` char(15) character set latin1 default NULL,
  `T15` char(15) character set latin1 default NULL,
  `T16` blob,
  PRIMARY KEY  (`T0`),
  UNIQUE KEY `T0` (`T0`),
  KEY `kt` (`T0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `tiendas`
--

LOCK TABLES `tiendas` WRITE;
/*!40000 ALTER TABLE `tiendas` DISABLE KEYS */;
INSERT INTO `tiendas` VALUES (0,'ALMACEN CENTRAL','DIRECCION ALMACEN CENTRAL','LOCALIDAD ALMACEN','06011','PROVINCIA ALMACEN','924111111','924222222','B06111111','2009-01-16','2008-09-02','A','localhost','3306','','',NULL);
/*!40000 ALTER TABLE `tiendas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ultimopedi0000`
--

DROP TABLE IF EXISTS `ultimopedi0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ultimopedi0000` (
  `AP0` char(13) character set latin1 NOT NULL,
  `AP1` date NOT NULL,
  `AP2` int(11) default NULL,
  `AP3` double(10,2) NOT NULL default '0.00',
  `AP4` double(10,2) NOT NULL default '0.00',
  PRIMARY KEY  (`AP0`,`AP1`),
  UNIQUE KEY `AP0` (`AP0`,`AP1`),
  KEY `kap` (`AP0`,`AP1`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `ultimopedi0000`
--

LOCK TABLES `ultimopedi0000` WRITE;
/*!40000 ALTER TABLE `ultimopedi0000` DISABLE KEYS */;
INSERT INTO `ultimopedi0000` VALUES ('1','2008-09-02',3,1.00,80.00),('1','2008-09-04',3,2.00,80.00),('2','2008-09-02',3,1.00,1.50),('2','2008-09-04',3,10.00,1.50),('3','2008-09-02',3,1.00,80.00),('4','2008-09-02',3,1.00,1.32),('4','2008-09-04',3,100.00,1.32);
/*!40000 ALTER TABLE `ultimopedi0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios0000`
--

DROP TABLE IF EXISTS `usuarios0000`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `usuarios0000` (
  `USU0` int(4) NOT NULL,
  `USU1` char(50) character set latin1 default NULL,
  `USU2` char(50) character set latin1 default NULL,
  `USU3` char(50) character set latin1 default NULL,
  `USU4` char(6) character set latin1 default NULL,
  `USU5` char(50) character set latin1 default NULL,
  `USU6` char(20) character set latin1 default NULL,
  `USU7` char(20) character set latin1 default NULL,
  `USU8` char(50) character set latin1 default NULL,
  `USU9` char(8) character set latin1 default NULL,
  `USU10` char(8) character set latin1 default NULL,
  `USU11` int(2) NOT NULL default '0',
  `USU12` blob,
  `USU13` char(150) character set latin1 default NULL,
  PRIMARY KEY  (`USU0`),
  UNIQUE KEY `USU0` (`USU0`),
  KEY `kusu` (`USU0`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `usuarios0000`
--

LOCK TABLES `usuarios0000` WRITE;
/*!40000 ALTER TABLE `usuarios0000` DISABLE KEYS */;
INSERT INTO `usuarios0000` VALUES (1,'USUARIO LINEX','DIRECCION USUARIO 1','LOCALIDAD USUARIO1','06001','PROVINCIA USUARIO 1','924111111','11111111-A','email@usuario1.es','LINEX','LINEX',0,'La clave es LINEX\n','C:\\FacturLinEx\\imagenes\\aceptar.png'),(2,'USUARIO2','','','','','','','','USU2','USU2',2,NULL,'');
/*!40000 ALTER TABLE `usuarios0000` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas0000A`
--

DROP TABLE IF EXISTS `ventas0000A`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ventas0000A` (
  `V0` int(5) NOT NULL default '0',
  `V1` int(5) NOT NULL default '0',
  `V2` int(5) NOT NULL auto_increment,
  `V3` char(13) character set latin1 NOT NULL,
  `V4` char(50) character set latin1 default NULL,
  `V5` double(10,3) NOT NULL default '0.000',
  `V6` double(10,2) NOT NULL default '0.00',
  `V7` double(10,3) NOT NULL default '0.000',
  `V8` double(10,2) NOT NULL default '0.00',
  `V9` double(10,3) NOT NULL default '0.000',
  `V10` int(3) NOT NULL default '0',
  `V11` double(10,2) NOT NULL default '0.00',
  `V12` int(11) NOT NULL default '0',
  `V13` char(1) character set latin1 NOT NULL default 'N',
  PRIMARY KEY  (`V0`,`V1`,`V2`),
  UNIQUE KEY `V0` (`V0`,`V1`,`V2`),
  KEY `kv` (`V0`,`V1`,`V2`),
  KEY `kva` (`V2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `ventas0000A`
--

LOCK TABLES `ventas0000A` WRITE;
/*!40000 ALTER TABLE `ventas0000A` DISABLE KEYS */;
/*!40000 ALTER TABLE `ventas0000A` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas0000B`
--

DROP TABLE IF EXISTS `ventas0000B`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ventas0000B` (
  `V0` int(5) NOT NULL default '0',
  `V1` int(5) NOT NULL default '0',
  `V2` int(5) NOT NULL auto_increment,
  `V3` char(13) character set latin1 NOT NULL,
  `V4` char(50) character set latin1 default NULL,
  `V5` double(10,3) NOT NULL default '0.000',
  `V6` double(10,2) NOT NULL default '0.00',
  `V7` double(10,3) NOT NULL default '0.000',
  `V8` double(10,2) NOT NULL default '0.00',
  `V9` double(10,3) NOT NULL default '0.000',
  `V10` int(3) NOT NULL default '0',
  `V11` double(10,2) NOT NULL default '0.00',
  `V12` int(11) NOT NULL default '0',
  `V13` char(1) character set latin1 NOT NULL default 'N',
  PRIMARY KEY  (`V0`,`V1`,`V2`),
  UNIQUE KEY `V0` (`V0`,`V1`,`V2`),
  KEY `kv` (`V0`,`V1`,`V2`),
  KEY `kva` (`V2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `ventas0000B`
--

LOCK TABLES `ventas0000B` WRITE;
/*!40000 ALTER TABLE `ventas0000B` DISABLE KEYS */;
/*!40000 ALTER TABLE `ventas0000B` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas0000C`
--

DROP TABLE IF EXISTS `ventas0000C`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ventas0000C` (
  `V0` int(5) NOT NULL default '0',
  `V1` int(5) NOT NULL default '0',
  `V2` int(5) NOT NULL auto_increment,
  `V3` char(13) character set latin1 NOT NULL,
  `V4` char(50) character set latin1 default NULL,
  `V5` double(10,3) NOT NULL default '0.000',
  `V6` double(10,2) NOT NULL default '0.00',
  `V7` double(10,3) NOT NULL default '0.000',
  `V8` double(10,2) NOT NULL default '0.00',
  `V9` double(10,3) NOT NULL default '0.000',
  `V10` int(3) NOT NULL default '0',
  `V11` double(10,2) NOT NULL default '0.00',
  `V12` int(11) NOT NULL default '0',
  `V13` char(1) character set latin1 NOT NULL default 'N',
  PRIMARY KEY  (`V0`,`V1`,`V2`),
  UNIQUE KEY `V0` (`V0`,`V1`,`V2`),
  KEY `kv` (`V0`,`V1`,`V2`),
  KEY `kva` (`V2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `ventas0000C`
--

LOCK TABLES `ventas0000C` WRITE;
/*!40000 ALTER TABLE `ventas0000C` DISABLE KEYS */;
/*!40000 ALTER TABLE `ventas0000C` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-01-22  9:13:42
