DROP TABLE IF EXISTS `event`;
CREATE TABLE IF NOT EXISTS `event` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `tag` varchar(20) NOT NULL,
  `location` varchar(100) NOT NULL,
  `date` date NOT NULL,
  `type` enum('Road','CC','Beach','Track') default NULL,
  `contactPerson` varchar(100) default NULL,
  `racepixs` varchar(20) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=23 ;

select * from event where YEAR(date) = 2010;

SELECT `event`.* FROM `event` WHERE (date > now()) ORDER BY `date` asc LIMIT 1;

INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES
(20103, 'North County Farmers','ncf2010', 'Swords', '2010-02-06', 'CC', NULL, 'ncf2010');
INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES
(20104, 'Dublin Airport','dubairport2010', 'ALSAA', '2010-02-13', 'CC', NULL, 'airport2010');
INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES
(20105, 'Garda/St Raphaels','garda2010', 'Garda Boat Club Islandbridge, Phoenix Park', '2010-02-27', 'CC', NULL, 'garda2010');
INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES
(20106, 'NCF Evening Challenge','ncf5km2010', '	Malahide Rugby Club', '2010-03-10', 'CC', NULL, 'ncf5k2010');
INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES
(20107, 'NUI & AIB','nuiaib2010', 'Maynooth College', '2010-03-20', 'CC', NULL, 'nuiaib2010');

INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES
(20108, 'DCC','dcc2010', 'St Pauls School, Raheny', '2010-04-10', 'Road', NULL, 'dcc2010');
INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES
(20109, 'K-Club','kclub2010', 'K-Club, Straffen', '2010-04-24', 'Road', NULL, 'kclub2010');
INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES
(201010, 'RTE','rte2010', 'RTE S&S Club, Donnybrook', '2010-05-01', 'Road', NULL, 'rte2010');
INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES
(201011, 'ESB','esb2010', 'Fontenoy GAA, Sandymount Strand', '2010-05-11', 'Beach', NULL, 'esb2010');
INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES
(201012, 'Intel','intel2010', 'Leixlip', '2010-05-22', 'Road', NULL, 'intel2010');
INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES
(201013, 'Government Services','govserv2010', 'Dunboyne', '2010-06-01', 'Road', NULL, 'govserv2010');
INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES
(201014, 'Trinity','trinity2010', 'Trinity College Dublin', '2010-06-17', 'Track', NULL, 'trinity2010');


http://www.bhaa.ie/event/intel2010
http://www.bhaa.ie/event/govserv2010
http://www.bhaa.ie/event/trinity2010

select id,name,tag,if( date >= now(),"Y","N") as future from event where id=20109;

delete from event where id in (20103,20104,20105,20106,20107);

ALTER TABLE event ADD tag varchar(20) NOT NULL AFTER name; 
update event set tag="sdcc2009" where id=1;
update event set tag="eircom2009" where id=2;
update event set tag="ncf2009" where id=3;
update event set tag="aerlingus2009" where id=4;
update event set tag="garda2009" where id=5;
update event set tag="ncf5k2009" where id=6;
update event set tag="nuiaib2009" where id=7;
update event set tag="kepak2009" where id=9;
update event set tag="dcc2009" where id=8;
update event set tag="rte2009" where id=10;
update event set tag="intel2009" where id=12;
update event set tag="esb2009" where id=13;
update event set tag="army2009" where id=16;
update event set tag="govser2009" where id=15; 
update event set tag="trinity2009" where id=17; 
update event set tag="dcc5k2009" where id=18; 
update event set tag="irishlife2009" where id=19; 
update event set tag="zurich2009" where id=20; 
update event set tag="pearlizumi2009" where id=21; 
update event set tag="hibernian2009" where id=22; 
update event set tag="teachers2009" where id=23; 
update event set tag="boi2009" where id=24; 
update event set tag="nsrt2009" where id=25; 
update event set tag="datasol2009" where id=26; 

update event set racepixs='BHAAbeach6k09' where id=24;
update event set racepixs='bhaaNSRT09' where id=25;

INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(23, 'Teachers', 'Castleknock', '2009-10-10', 'CC', NULL, 'BHAAteachers09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(24, 'Bank of Ireland', 'Dollymount', '2009-11-14', 'Beach', NULL, 'bhaaboi09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(25, 'NSRT', 'The Ward', '2009-11-26', 'CC', NULL, 'bhaansrt09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(26, 'Data Solutions', 'Marley Park', '2009-12-06', 'CC', NULL, 'bhaadatasol09');

--
-- Dumping data for table `event`
--

INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(1, 'South Dublin County Council', 'Tymon Park', '2009-01-10', 'CC', NULL, 'sdccXC09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(2, 'Eircom', 'Cherryfield Park', '2009-01-17', 'CC', NULL, 'eircomXC09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(3, 'NCF', 'Swords', '2009-01-31', 'CC', NULL, 'ncfXC09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(4, 'Aer Lingus', 'ALSAA', '2009-02-07', 'CC', NULL, 'aerlingusXC09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(5, 'Garda', 'Phoenix Park', '2009-02-21', 'CC', NULL, 'gardaXC09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(6, 'NCF Night', 'Malahide RFC', '2009-03-11', 'CC', NULL, 'ncf5k09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(7, 'NUI AIB', 'Maynooth', '2009-03-21', 'CC', NULL, 'nuiaib09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(9, 'Kepak', 'Clonee', '2009-04-18', 'CC', NULL, 'kepak09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(8, 'DCC', 'Raheny', '2009-04-04', 'Road', NULL, 'dcc09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(10, 'RTE', 'Donnybrook', '2009-05-02', 'Road', NULL, 'rte09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(12, 'Intel', 'Leixlip', '2009-05-23', 'Road', NULL, 'intel10k09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(13, 'ESB', 'Sandymount', '2009-06-09', 'Beach', NULL, 'esbbeach09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(16, 'Army', 'Phoenix Park', '2009-06-30', '', NULL, 'defence6k09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(15, 'Gov Services', 'Dundoyne', '2009-06-16', 'Road', NULL, NULL);
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(17, 'Trinity', 'Trinity', '2009-06-25', 'Track', NULL, 'trinityrelays09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(18, 'DCC Irishtown', 'DCC', '2009-07-15', 'Road', NULL, 'dcc5k09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(19, 'Irish Life', 'Irishtown', '2009-08-12', 'Track', NULL, 'BHAA3k09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(20, 'Zurich', 'Irishtown', '2009-08-26', 'Track', NULL, 'zurich09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(21, 'Pearl Izumi', 'Firhouse', '2009-09-12', 'Road', NULL, 'pearlizumi09');
INSERT INTO `event` (`id`, `name`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(22, 'Hibernian', 'Irishtown', '2009-09-02', 'Track', NULL, NULL);

INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(20101, 'South Dublin County Council','sdcc2010', 'Tymon Park', '2010-01-10', 'CC', NULL, 'sdccXC2010');
INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(20102, 'Eircom','eircom2010', 'Cherryfield Park', '2010-01-17', 'CC', NULL, 'eircomXC2010');
INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(20103, 'NCF','ncf2010', 'Swords', '2010-01-31', 'CC', NULL, 'ncfXC2010');
INSERT INTO `event` (`id`, `name`,`tag`, `location`, `date`, `type`, `contactPerson`, `racepixs`) VALUES(20081, 'South Dublin County Council','sdcc2008', 'Tymon Park', '2008-01-10', 'CC', NULL, 'sdccXC2008');

select e.id, e.name, 
(select count(runner) from raceresult as rr join race r on r.id=rr.race where r.event=e.id) as count
from event as e;

select e.id, e.name, count(runner) from raceresult as rr
join race r on r.id=rr.race
join event e on e.id=r.event
where event=23;
