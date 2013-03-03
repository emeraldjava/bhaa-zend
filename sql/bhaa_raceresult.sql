DROP TABLE IF EXISTS `bhaa1_members`.`raceresult`;
CREATE TABLE  `bhaa1_members`.`raceresult` (
  `race` int(11) NOT NULL,
  `runner` int(11) NOT NULL,
  `racetime` time DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `racenumber` int(11) DEFAULT NULL,
  `category` varchar(20) DEFAULT NULL,
  `standard` int(11) DEFAULT NULL,
  `paceKM` time DEFAULT NULL,
  `points` double DEFAULT NULL,
  `postRaceStandard` int(11) DEFAULT NULL,
  `positioninstandard` int(11) unsigned DEFAULT NULL,
  `positioninagecategory` int(11) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

update race set race.type="Mile" where race.id=201037;

-- get pace, and distaces for all std 10 raceresults
select paceKm,normalisedPaceKm,race,ROUND(getRaceDistanceKM(race.distance,race.unit),1) as dist from raceresult
join race on raceresult.race=race.id
where standard=16 order by dist;

-- a list of the distinct race distances
select DISTINCT(ROUND(getRaceDistanceKM(race.distance,race.unit),1)) as dist from race where race.type!="S" order by dist;
select getRaceDistanceKM(race.distance,race.unit) as dist,id from race order by dist;

ALTER TABLE `bhaa1_members`.`raceresult` MODIFY COLUMN `class`
enum('RAN','RAN_NO_SCORE','RACE_ORG','RACE_VOL','RACE_POINTS') DEFAULT 'RAN';

select race,runner,position,companyname,company from raceresult
join race on raceresult.race=race.id
join event on event.id=race.event
where event.id=201028;

select race,runner,position,raceresult.companyname,raceresult.company,company.name,company.id from raceresult
join race on raceresult.race=race.id
join event on event.id=race.event
join runner on runner.id=raceresult.runner
left join company on runner.company=company.id
where event.id=201028;

jupdate raceresult
join race on raceresult.race=race.id
join event on event.id=race.event
join runner on runner.id=raceresult.runner
left join company on runner.company=company.id
set raceresult.companyname=company.name,raceresult.company=company.id
where event.id=201021;


describe runner;
describe raceresult;
select * from raceresult where company is not NULL;

UPDATE raceresult rr,runner ru SET rr.company=ru.company WHERE rr.runner = ru.id;

-- update companyid from companyname
select runner,company,companyname,company.id,company.name from raceresult left join company on company.name=raceresult.companyname where race=20102;
update raceresult join company on raceresult.companyname=company.name set company=company.id where race=20102;

select runner,company,companyname,company.id,company.name from raceresult left join company on company.name=raceresult.companyname where race=72;
select runner,company,companyname,company.id,company.name from raceresult left join company on raceresult.company=company.id where race=72;
update raceresult join company on raceresult.company=company.id set companyname=company.name where race=72;

-- update all past races
update raceresult join company on raceresult.company=company.id set companyname=company.name

-- clear out students
select race,runner from raceresult where companyname like "%student%";
update raceresult set companyname="" where companyname like "%student%";

select runner.id,runner.company,raceresult.company,raceresult.companyname  from runner
join raceresult on raceresult.runner=runner.id
where raceresult.race=20102;

select runner.id,runner.firstname,runner.surname,runner.company,raceresult.company,raceresult.companyname from runner
join raceresult on raceresult.runner=runner.id
where raceresult.race=20102 and runner.company IS NULL
and raceresult.company != 0 and runner.status="M";

update runner
join raceresult on raceresult.runner=runner.id
set runner.company=raceresult.company
where raceresult.race=20102 and runner.company IS NULL
and raceresult.company != 0 and runner.status="M";

select runner.id,runner.company,raceresult.company,raceresult.companyname from runner
join raceresult on raceresult.runner=runner.id
where raceresult.race=20102
and raceresult.company != 0 and runner.status="M";

update runner
join raceresult on raceresult.company=runner.company
set runner.company=raceresult.company where raceresult.race=20102
and raceresult.company != 0 and runner.status="M";


select runner, raceresult.company, company.name from raceresult join company on company.id = raceresult.company where race=20102;

select runner, raceresult.company, company.name from raceresult join company on company.id = raceresult.company where race=20102;

-- list the number of runner in each standard per race
select s.standard, 
count(rr.runner) as total
from standard as s
join raceresult rr on s.standard=rr.standard
where rr.race=72 group by s.standard;

select s.standard, 
count(rr.runner) as total
from standard as s
join raceresult rr on s.standard=rr.standard
join runner r on r.id=rr.runner
where rr.race=72 and r.gender="M" group by s.standard;

select distinct(category) from raceresult;
update raceresult set category = "SM" where category = "SeniorMen";
update raceresult set category = "SW" where category = "SeniorWomen";



select race,runner,racetime,position,standard from raceresult where TIME_TO_SEC(normalisedPaceKm<40) and normalisedPaceKm!="00:00:00";

update raceresult set normalisedPaceKm="00:00:00" where TIME_TO_SEC(normalisedPaceKm<40) and normalisedPaceKm!="00:00:00";

select * from race where id=47;


