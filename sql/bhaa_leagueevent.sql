
DROP TABLE IF EXISTS `leagueevent`;
CREATE TABLE IF NOT EXISTS `leagueevent` (
  `id` int(11) NOT NULL auto_increment,
  `league` int(11) default NULL,
  `event` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=39 ;

select leagueevent.league,event.tag,race.id as raceid,race.type from leagueevent
join event on event.id=leagueevent.event
join race on race.event=event.id
where league=5
and race.type in ('C','M');



select * from leagueevent where league=5;
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 5, 20101);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 5, 20102);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 5, 20103);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 5, 20104);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 5, 20105);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 5, 20106);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 5, 20107);

select * from leagueevent where league=4 order by event;

INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 4, 20107);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 4, 20106);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 4, 20105);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 4, 20101);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 4, 20102);

INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 5, 20108);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 5, 20109);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 5, 201010);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 5, 201011);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 5, 201012);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 5, 201013);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 5, 201014);

INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 6, 20108);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 6, 20109);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 6, 201010);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 6, 201011);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 6, 201012);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 6, 201013);
INSERT INTO `leagueevent` (`id`, `league`, `event`) VALUES(NULL, 6, 201014);
