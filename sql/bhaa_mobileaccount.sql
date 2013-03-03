
DROP TABLE IF EXISTS `mobileaccount`;
CREATE TABLE IF NOT EXISTS `mobileaccount` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) NOT NULL,
  `number` varchar(30) NOT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `remainingtexts` int(3) NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=23;
