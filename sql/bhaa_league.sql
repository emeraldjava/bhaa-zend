
DROP TABLE IF EXISTS `league`;
CREATE TABLE IF NOT EXISTS `league` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(40) default NULL,
  `year` date DEFAULT NULL,
  `type` enum('I','T') default 'I',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

select * from league;

alter table league change year startdate date;

INSERT INTO `league` (`id`, `name`, `year`, `type`) VALUES(4, 'Winter League 2009/2010', '2009-10-10', 'I');
INSERT INTO `league` (`id`, `name`, `year`, `type`) VALUES(5, 'Team League 2010', '2010-01-01', 'T');
INSERT INTO `league` (`id`, `name`, `year`, `type`) VALUES(6, 'Summer League 2010', '2010-04-01', 'I');

INSERT INTO `league` (`id`, `name`, `year`, `type`) VALUES(7, 'Winter League 2010/2010', '2010-10-09', 'I');

select
(select max(id) from league where type="I" as individual),
(select max(id) from league where type="T" as team)
from league
