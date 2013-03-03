ALTER TABLE RaceResult ADD COLUMN PaceKM TIME;
ALTER TABLE RaceResult ADD COLUMN Points DOUBLE;
ALTER TABLE raceresult ADD COLUMN postRaceStandard INT;

DROP TABLE IF EXISTS `standardTime`;
CREATE TABLE  `standardTime` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `standard` int(11) NOT NULL,
  `standardTime` time NOT NULL,
  `distance` double NOT NULL,
  `unit` enum('KM','Mile') DEFAULT 'KM',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `RaceOrganiser`;
CREATE TABLE  `RaceOrganiser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `race` int(11) NOT NULL,
  `runner` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


