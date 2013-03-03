

DROP TABLE IF EXISTS `mobilelist`;
CREATE TABLE IF NOT EXISTS `mobilelist` (
  `id` int(11) NOT NULL auto_increment,
  `account` varchar(30) NOT NULL,
  `mobile` varchar(30) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=23;