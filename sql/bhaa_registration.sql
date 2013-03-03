DROP TABLE IF EXISTS `registration`;
CREATE TABLE IF NOT EXISTS `registration` (
  `id` int(11) NOT NULL auto_increment,
  `event` int(11),
  `runner` int(4),
  `firstname` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `gender` varchar(1) NOT NULL,
  `dateofbirth` date NOT NULL,
  `address` varchar(50),
  `address2` varchar(50),
  `address3` varchar(50),
  `email` varchar(50) NOT NULL,
  `mobile` varchar(50)  NOT NULL,
  `company` int(11),
  `sector` int(11),
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;