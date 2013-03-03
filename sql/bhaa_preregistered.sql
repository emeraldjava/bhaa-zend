DROP TABLE IF EXISTS `preregistered`;
CREATE TABLE IF NOT EXISTS `preregistered` (
  `event` int(11) NOT NULL,
  `runner` int(11) NOT NULL,
  PRIMARY KEY  (`event`,`runner`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
