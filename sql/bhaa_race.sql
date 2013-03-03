DROP TABLE IF EXISTS `race`;
CREATE TABLE IF NOT EXISTS `race` (
  `id` int(11) NOT NULL auto_increment,
  `event` int(11) NOT NULL,
  `starttime` time NOT NULL,
  `distance` double NOT NULL,
  `unit` enum('KM','Mile') default 'KM' NOT NULL,
  `type` enum('C','W','M') default 'C' NOT NULL,
  `category` varchar(30) default 'Combined',
  `file` varchar(50) default NULL,
  PRIMARY KEY  (`id`),
  KEY `event` (`event`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=70;

select * from race where YEAR(date) = 2010;

ALTER TABLE race ADD COLUMN km double NOT NULL AFTER unit;
update race set km=getRaceDistanceKM(distance,unit);

INSERT INTO race VALUES(201040,201026,"19:00:00",1,"Mile","BHAA 1-10","./csv/races/2010/aviva_2010_1.csv","C");
INSERT INTO race VALUES(201041,201026,"19:10:00",1,"Mile","Open Sub 6 Min","./csv/races/2010/aviva_2010.csv","C");
INSERT INTO race VALUES(201042,201026,"19:20:00",1,"Mile","BHAA 11-13","./csv/races/2010/aviva_2010_2.csv","C");
INSERT INTO race VALUES(201043,201026,"19:30:00",1,"Mile","Open Sub 7 Min","./csv/races/2010/aviva_2010.csv","C");
INSERT INTO race VALUES(201044,201026,"19:40:00",1,"Mile","BHAA 14-16","./csv/races/2010/aviva_2010.csv","C");
INSERT INTO race VALUES(201045,201026,"19:50:00",1,"Mile","Open Sub 8 Min","./csv/races/2010/aviva_2010.csv","C");
INSERT INTO race VALUES(201046,201026,"20:00:00",1,"Mile","BHAA 17-30","./csv/races/2010/aviva_2010.csv","C");
INSERT INTO race VALUES(201047,201026,"20:10:00",1,"Mile","Open Sub 9 Min","./csv/races/2010/aviva_2010.csv","C");

INSERT INTO race VALUES(201011,20106,"20:00:00",5,"Km","Combined","./csv/races/2010/ncf_night_2010.csv","C");
INSERT INTO race VALUES(201012,20107,"11:00:00",2.5,"Mile","Women","./csv/races/2010/nuiaib_women_2010.csv","W");
INSERT INTO race VALUES(201013,20107,"11:30:00",4,"Mile","Men","./csv/races/2010/nuiaib_men_2010.csv","M");

INSERT INTO race VALUES(20109,20105,"11:30:00",2,"Mile","Women","./csv/races/2010/garda_women_2010.csv","W");
INSERT INTO race VALUES(201010,20105,"11:30:00",4,"Mile","Men","./csv/races/2010/garda_men_2010.csv","M");

INSERT INTO race VALUES(20105,20103,"11:30:00",2.5,"Mile","Women","./csv/races/2010/ncf_women_2010.csv","W");
INSERT INTO race VALUES(20106,20103,"11:30:00",5,"Mile","Men","./csv/races/2010/ncf_men_2010.csv","M");

INSERT INTO race VALUES(20101,20101,"12:00:00",2,"Mile","Women","./csv/races/2010/sdcc_women_2010.csv","W");
INSERT INTO race VALUES(20102,20101,"12:30:00",4,"Mile","Men","./csv/races/2010/sdcc_men_2010.csv","M");

INSERT INTO race VALUES(20103,20102,"11:30:00",2,"Mile","Women","./csv/races/2010/eircom_women_2010.csv","W");
INSERT INTO race VALUES(20104,20102,"12:00:00",5,"Mile","Men","./csv/races/2010/eircom_men_2010.csv","M");

UPDATE race set file="./csv/races/2009/data_solutions_2009.csv" where id=75;
UPDATE race set file="./csv/races/2009/nsrt_women_2009.csv" where id=73;
UPDATE race set file="./csv/races/2009/nsrt_men_2009.csv" where id=74;

UPDATE race set file="./csv/races/2009/boi_2009.csv" where id=72;

-- link the BOI, NSRT and DataSolutions 
INSERT INTO race VALUES(72,24,"11:30:00",6,"KM","Combined",NULL,"C");
INSERT INTO race VALUES(73,25,"11:00:00",4,"KM","Women",NULL,"W");
INSERT INTO race VALUES(74,25,"11:30:00",6,"KM","Men",NULL,"M");
INSERT INTO race VALUES(75,26,"10:30:00",5,"KM","Combined",NULL,"C");

-- add type column and drop total runners;
ALTER TABLE race ADD type ENUM('C','W','M') DEFAULT 'C' NOT NULL;
ALTER TABLE race DROP COLUMN totalrunner;

UPDATE race set type="M" where category like 'Men%';
UPDATE race set type="W" where category like 'Women%';
UPDATE race set type="C" where category like 'Com%';

-- insert teachers races
INSERT INTO race VALUES(70,23,"11:00:00",2,"Mile","Women",NULL,"./csv/races/2009/teachers_women_2009.csv");
INSERT INTO race VALUES(71,23,"11:00:00",4,"Mile","Men",NULL,"./csv/races/2009/teachers_men_2009.csv");

-- race csv files
UPDATE race set file="./csv/races/2009/sdcc_women_2009.csv" where id=1;
UPDATE race set file="./csv/races/2009/sdcc_men_2009.csv" where id=2;
UPDATE race set file="./csv/races/2009/eircom_women_2009.csv" where id=3;
UPDATE race set file="./csv/races/2009/eircom_men_2009.csv" where id=4;
UPDATE race set file="./csv/races/2009/ncf_women_2009.csv" where id=5;
UPDATE race set file="./csv/races/2009/ncf_men_2009.csv" where id=6;
UPDATE race set file="./csv/races/2009/aerlingus_women_2009.csv" where id=7;
UPDATE race set file="./csv/races/2009/aerlingus_men_2009.csv" where id=8;
UPDATE race set file="./csv/races/2009/garda_women_2009.csv" where id=9;
UPDATE race set file="./csv/races/2009/garda_men_2009.csv" where id=10;
UPDATE race set file="./csv/races/2009/ncf_5km_2009.csv" where id=11;
UPDATE race set file="./csv/races/2009/nuimaib_women_2009.csv" where id=12;
UPDATE race set file="./csv/races/2009/nuimaib_men_2009.csv" where id=13;
update race set file="./csv/races/2009/dcc_women_2009.csv" where id=14;
update race set file="./csv/races/2009/dcc_men_2009.csv" where id=15;
update race set file="./csv/races/2009/kepak_2009.csv" where id=16;
update race set file="./csv/races/2009/rte_2009.csv" where id=17;
update race set file="./csv/races/2009/intel_2009.csv" where id=31;
update race set file="./csv/races/2009/esb_2009.csv" where id=32;
update race set file="./csv/races/2009/army_2009.csv" where id=35;
update race set file="./csv/races/2009/gov_services_2009.csv" where id=34;
update race set file="./csv/races/2009/trinity_2009.csv" where id=36;
update race set file="./csv/races/2009/trinity_2009.csv" where id=37;
update race set file="./csv/races/2009/trinity_2009.csv" where id=38;
update race set file="./csv/races/2009/trinity_2009.csv" where id=39;
update race set file="./csv/races/2009/trinity_2009.csv" where id=40;
update race set file="./csv/races/2009/trinity_2009.csv" where id=41;
update race set file="./csv/races/2009/trinity_2009.csv" where id=42;
update race set file="./csv/races/2009/trinity_2009.csv" where id=43;
update race set file="./csv/races/2009/trinity_2009.csv" where id=44;
update race set file="./csv/races/2009/trinity_2009.csv" where id=45;
update race set file="./csv/races/2009/trinity_2009.csv" where id=46;
update race set file="./csv/races/2009/trinity_2009.csv" where id=47;
update race set file="./csv/races/2009/trinity_2009.csv" where id=48;
update race set file="./csv/races/2009/trinity_2009.csv" where id=49;
update race set file="./csv/races/2009/trinity_2009.csv" where id=50;
update race set file="./csv/races/2009/dcc_5km_2009.csv" where id=51;
update race set file="./csv/races/2009/irishlife_2009.csv" where id=52;
update race set file="./csv/races/2009/irishlife_2009.csv" where id=53;
update race set file="./csv/races/2009/irishlife_2009.csv" where id=54;
update race set file="./csv/races/2009/irishlife_2009.csv" where id=55;
update race set file="./csv/races/2009/irishlife_2009.csv" where id=56;
update race set file="./csv/races/2009/zurich_2009.csv" where id=57;
update race set file="./csv/races/2009/zurich_2009.csv" where id=58;
update race set file="./csv/races/2009/zurich_2009.csv" where id=59;
update race set file="./csv/races/2009/zurich_2009.csv" where id=60;
update race set file="./csv/races/2009/zurich_2009.csv" where id=61;
update race set file="./csv/races/2009/pearlizumi_2009.csv" where id=62;
update race set file="./csv/races/2009/hibernian_2009.csv" where id=63;
update race set file="./csv/races/2009/hibernian_2009.csv" where id=64;
update race set file="./csv/races/2009/hibernian_2009.csv" where id=65;
update race set file="./csv/races/2009/hibernian_2009.csv" where id=66;
update race set file="./csv/races/2009/hibernian_2009.csv" where id=67;
update race set file="./csv/races/2009/hibernian_2009.csv" where id=68;
update race set file="./csv/races/2009/hibernian_2009.csv" where id=69;
update race set file="./csv/races/2009/teachers_women_2009.csv" where id=70;
update race set file="./csv/races/2009/teachers_men_2009.csv" where id=71;

-- race pixs
ALTER TABLE event ADD COLUMN racepixs VARCHAR(20);

--update event set racepixs="" where id=;

update event set racepixs="sdccXC09" where id=1;
update event set racepixs="eircomXC09" where id=2;
update event set racepixs="ncfXC09" where id=3;
update event set racepixs="aerlingusXC09" where id=4;
update event set racepixs="gardaXC09" where id=5;
update event set racepixs="ncf5k09" where id=6;
update event set racepixs="nuiaib09" where id=7;
update event set racepixs="dcc09" where id=8;
update event set racepixs="kepak09" where id=9;
update event set racepixs="rte09" where id=10;
update event set racepixs="intel10k09" where id=12;
update event set racepixs="esbbeach09" where id=13;
update event set racepixs="defence6k09" where id=16;
update event set racepixs="trinityrelays09" where id=17;
update event set racepixs="dcc5k09" where id=18;
update event set racepixs="BHAA3k09" where id=19;
update event set racepixs="zurich09" where id=20;
update event set racepixs="pearlizumi09" where id=21;
