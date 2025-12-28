#DROP TABLE puestos0000;
CREATE TABLE puestos0000
	(
	PT0 char(2) NOT NULL,
	PT1 char(50) default NULL,
	PT2 char(20) default NULL,
	PT3 char(15) default NULL,
	PT4 char(4) default NULL,
	PT5 char(15) default NULL,
	PT6 char(15) default NULL,
	PRIMARY KEY kpt (PT0),
	UNIQUE (PT0),
	INDEX kpt (PT0)
	);
