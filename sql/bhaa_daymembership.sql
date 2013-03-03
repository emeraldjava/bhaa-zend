DROP TABLE IF EXISTS `daymembership`;
CREATE TABLE IF NOT EXISTS `daymembership` (
  `id` int(11) NOT NULL auto_increment,
  `eventid` int(11),
  `firstname` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `gender` enum('M','W') NOT NULL,
  `dateofbirth` date NOT NULL,
  `address1` varchar(50),
  `address2` varchar(50),
  `address3` varchar(50),
  `email` varchar(50) NOT NULL,
  `newsletter` enum('Y','N') default 'Y',
  `mobile` varchar(10),
  `textmessage` enum('Y','N') default 'Y',
  `companyid` int(11),
  `companyname` varchar(50),
  `insertdate` date NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;