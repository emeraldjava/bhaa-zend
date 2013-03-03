DROP TABLE IF EXISTS `standarddistance`;
CREATE TABLE IF NOT EXISTS `standarddistance` (
  `name` varchar(10) NOT NULL,
  `distance` double NOT NULL,
  `unit` enum('KM','Mile') default 'KM' NOT NULL,
  `km` double NOT NULL,
  `mile` double NOT NULL
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

INSERT INTO standarddistance VALUES('1k',1,'Km',getRaceDistanceKm(1,'Km'),getRaceDistanceKm(1,'Mile'));
INSERT INTO standarddistance VALUES('2k',2,'Km',getRaceDistanceKm(2,'Km'),getRaceDistanceKm(2,'Mile'));
INSERT INTO standarddistance VALUES('3k',3,'Km',getRaceDistanceKm(3,'Km'),getRaceDistanceKm(3,'Mile'));
INSERT INTO standarddistance VALUES('4k',4,'Km',getRaceDistanceKm(4,'Km'),getRaceDistanceKm(4,'Mile'));
INSERT INTO standarddistance VALUES('5k',5,'Km',getRaceDistanceKm(5,'Km'),getRaceDistanceKm(5,'Mile'));
INSERT INTO standarddistance VALUES('6k',6,'Km',getRaceDistanceKm(6,'Km'),getRaceDistanceKm(6,'Mile'));
INSERT INTO standarddistance VALUES('7k',7,'Km',getRaceDistanceKm(7,'Km'),getRaceDistanceKm(7,'Mile'));
INSERT INTO standarddistance VALUES('8k',8,'Km',getRaceDistanceKm(8,'Km'),getRaceDistanceKm(8,'Mile'));
INSERT INTO standarddistance VALUES('9k',9,'Km',getRaceDistanceKm(9,'Km'),getRaceDistanceKm(9,'Mile'));
INSERT INTO standarddistance VALUES('10k',10,'Km',getRaceDistanceKm(10,'Km'),getRaceDistanceKm(10,'Mile'));
INSERT INTO standarddistance VALUES('1m',1,'Mile',getRaceDistanceKm(1,'Mile'),getRaceDistanceKm(1,'Km'));
INSERT INTO standarddistance VALUES('2m',2,'Mile',getRaceDistanceKm(2,'Mile'),getRaceDistanceKm(2,'Km'));
INSERT INTO standarddistance VALUES('3m',3,'Mile',getRaceDistanceKm(3,'Mile'),getRaceDistanceKm(3,'Km'));
INSERT INTO standarddistance VALUES('4m',4,'Mile',getRaceDistanceKm(4,'Mile'),getRaceDistanceKm(4,'Km'));
INSERT INTO standarddistance VALUES('5m',5,'Mile',getRaceDistanceKm(5,'Mile'),getRaceDistanceKm(5,'Km'));
INSERT INTO standarddistance VALUES('6m',6,'Mile',getRaceDistanceKm(6,'Mile'),getRaceDistanceKm(6,'Km'));
INSERT INTO standarddistance VALUES('7m',7,'Mile',getRaceDistanceKm(7,'Mile'),getRaceDistanceKm(7,'Km'));
INSERT INTO standarddistance VALUES('8m',8,'Mile',getRaceDistanceKm(8,'Mile'),getRaceDistanceKm(8,'Km'));
INSERT INTO standarddistance VALUES('9m',9,'Mile',getRaceDistanceKm(9,'Mile'),getRaceDistanceKm(9,'Km'));
INSERT INTO standarddistance VALUES('10m',10,'Mile',getRaceDistanceKm(10,'Mile'),getRaceDistanceKm(10,'Km'));
INSERT INTO standarddistance VALUES('half',13.1,'Mile',getRaceDistanceKm(13.1,'Mile'),getRaceDistanceKm(13.1,'Km'));
INSERT INTO standarddistance VALUES('mar',26.2,'Mile',getRaceDistanceKm(26.2,'Mile'),getRaceDistanceKm(26.2,'Km'));

select * from standarddistance;

