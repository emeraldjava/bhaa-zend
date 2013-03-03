DROP TABLE `division`;
CREATE TABLE IF NOT EXISTS `division` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(20) default NULL,
  `code` varchar(2) default NULL,
  `gender` enum('M','W','T') default 'M',
  `min` int(11) NOT NULL,
  `max` int(11) NOT NULL,
  `type` enum('I','T') default 'I',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `division`
--

INSERT INTO `division` (`id`, `name`, `code`, `gender`, `min`, `max`,`type`) VALUES(1, 'Men Division A', 'A', 'M', 1, 7,'I');
INSERT INTO `division` (`id`, `name`, `code`, `gender`, `min`, `max`,`type`) VALUES(2, 'Men Division B', 'B', 'M', 8, 10,'I');
INSERT INTO `division` (`id`, `name`, `code`, `gender`, `min`, `max`,`type`) VALUES(3, 'Men Division C', 'C', 'M', 11, 13,'I');
INSERT INTO `division` (`id`, `name`, `code`, `gender`, `min`, `max`,`type`) VALUES(4, 'Men Division D', 'D', 'M', 14, 16,'I');
INSERT INTO `division` (`id`, `name`, `code`, `gender`, `min`, `max`,`type`) VALUES(5, 'Men Division E', 'E', 'M', 17, 21,'I');
INSERT INTO `division` (`id`, `name`, `code`, `gender`, `min`, `max`,`type`) VALUES(6, 'Men Division F', 'F', 'M', 22, 30,'I');
INSERT INTO `division` (`id`, `name`, `code`, `gender`, `min`, `max`,`type`) VALUES(7, 'Women Division A', 'L1', 'W', 1, 16,'I');
INSERT INTO `division` (`id`, `name`, `code`, `gender`, `min`, `max`,`type`) VALUES(8, 'Women Division B', 'L2', 'W', 17, 30,'I');

INSERT INTO `division` (`id`, `name`, `code`, `gender`, `min`, `max`,`type`) VALUES(9, 'Mens Team League A', 'A', 'M', 1, 30,'T');
INSERT INTO `division` (`id`, `name`, `code`, `gender`, `min`, `max`,`type`) VALUES(10, 'Mens Team League B', 'B', 'M', 31, 38,'T');
INSERT INTO `division` (`id`, `name`, `code`, `gender`, `min`, `max`,`type`) VALUES(11, 'Mens Team League C', 'C', 'M', 39, 46,'T');
INSERT INTO `division` (`id`, `name`, `code`, `gender`, `min`, `max`,`type`) VALUES(12, 'Mens Team League D', 'D', 'M', 47, 90,'T');
INSERT INTO `division` (`id`, `name`, `code`, `gender`, `min`, `max`,`type`) VALUES(13, 'Womens Team League', 'W', 'W', 1, 90,'T');
