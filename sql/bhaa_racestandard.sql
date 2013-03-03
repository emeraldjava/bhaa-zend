
DROP TABLE IF EXISTS `racestandard`;
CREATE TABLE IF NOT EXISTS `racestandard` (
  `race` int(8) NOT NULL,
  `standard` int(3) NOT NULL,
  `runners` int(4) NOT NULL,
  `expected` time NOT NULL,
  `min` time NOT NULL,
  `avg` time NOT NULL,
  `max` time NOT NULL,
  `std` double NOT NULL,
  `diff` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- populate the standard data for a race
INSERT INTO racestandard(race,standard,runners,expected,min,avg,max,std,diff)
select 
race.id as race, 
rr.standard as standard, 
count(rr.runner) as runners,
SEC_TO_TIME((oneKmTimeInSecs + (getRaceDistanceKM(race.distance,race.unit)*slopefactor))) as expected,
min(rr.paceKM) as min,
SEC_TO_TIME(avg(TIME_TO_SEC(rr.paceKM))) as avg,
max(rr.paceKM) as max,
STD(rr.paceKM) as std,
((oneKmTimeInSecs + (getRaceDistanceKM(race.distance,race.unit)*slopefactor)) - avg(TIME_TO_SEC(rr.paceKM))) as diff
from race as race
join raceresult rr on race.id=rr.race
join runner r on rr.runner=r.id
join standard sd on rr.standard = sd.standard
where rr.race > 1 
group by rr.standard;

INSERT INTO racestandard(race,standard,runners,expected,min,avg,max,std,diff)
select 
race.id as race, 
rr.standard as standard, 
count(rr.runner) as runners,
SEC_TO_TIME((oneKmTimeInSecs + (getRaceDistanceKM(race.distance,race.unit)*slopefactor))) as expected,
min(rr.paceKM) as min,
SEC_TO_TIME(avg(TIME_TO_SEC(rr.paceKM))) as avg,
max(rr.paceKM) as max,
STD(rr.paceKM) as std,
((oneKmTimeInSecs + (getRaceDistanceKM(race.distance,race.unit)*slopefactor)) - avg(TIME_TO_SEC(rr.paceKM))) as diff
from raceresult rr 
left join race as race on race.id=rr.race
join runner r on rr.runner=r.id
join standard sd on rr.standard = sd.standard
where race.id=20102
group by rr.standard;

-- army 35, rte:34
select * from racestandard where race=20103;

-- compare individual race result to the race standarddata
select runner,rr.standard,paceKM,
(select expected from racestandard as rs where rs.race=rr.race and rs.standard=rr.standard) as expected,
(select min from racestandard as rs where rs.race=rr.race and rs.standard=rr.standard) as min,
(select avg from racestandard as rs where rs.race=rr.race and rs.standard=rr.standard) as avg,
(select max from racestandard as rs where rs.race=rr.race and rs.standard=rr.standard) as max,
(select std from racestandard as rs where rs.race=rr.race and rs.standard=rr.standard) as std,
(TIME_TO_SEC(paceKM) - 
TIME_TO_SEC((select avg from racestandard as rs where rs.race=rr.race and rs.standard=rr.standard))) / 
(select std from racestandard as rs where rs.race=rr.race and rs.standard=rr.standard) AS numdevs
from raceresult as rr
where rr.race=20101 and rr.standard is not null order by numdevs;

select runner,rr.standard,paceKM,
(select expected from racestandard as rs where rs.race=rr.race and rs.standard=rr.standard) as expected,
(select min from racestandard as rs where rs.race=rr.race and rs.standard=rr.standard) as min,
(select avg from racestandard as rs where rs.race=rr.race and rs.standard=rr.standard) as avg,
(select max from racestandard as rs where rs.race=rr.race and rs.standard=rr.standard) as max,
(select std from racestandard as rs where rs.race=rr.race and rs.standard=rr.standard) as std,
(TIME_TO_SEC(paceKM) - 
TIME_TO_SEC((select avg from racestandard as rs where rs.race=rr.race and rs.standard=rr.standard))) / 
(select std from racestandard as rs where rs.race=rr.race and rs.standard=rr.standard) AS numdevs
from raceresult as rr
join standard as s where
where rr.race=35 and rr.standard is not null order by numdevs;

select
rr.runner, rr.standard, rr.position, rr.paceKM, 
rs.expected, rs.min, rs.avg, rs.max, 
TIME_TO_SEC(rr.paceKM)-TIME_TO_SEC(rs.avg) as diff,
rs.std,
(TIME_TO_SEC(rr.paceKM)-TIME_TO_SEC(rs.avg))/rs.std as numdev
from raceresult as rr
join racestandard as rs on rs.race=rr.race and rs.standard=rr.standard
where rr.race=35 order by numdev;

select race.id as race, r.standard, count(runner) as runners,
SEC_TO_TIME((oneKmTimeInSecs + (getRaceDistanceKM(race.distance,race.unit)*slopefactor))) as expected,
min(rr.paceKM) as minpacekm,
SEC_TO_TIME(avg(TIME_TO_SEC(rr.paceKM))) as avgpacekm,
max(rr.paceKM) as maxpacekm,
STD(rr.paceKM) as std,
((oneKmTimeInSecs + (getRaceDistanceKM(race.distance,race.unit)*slopefactor)) - avg(TIME_TO_SEC(rr.paceKM))) as diff
from raceresult rr
join race race on race.id=rr.race
join runner r on rr.runner=r.id
join standard sd on r.standard = sd.standard
where rr.race=17 
group by r.standard order by numdevs;


select
r.standard,
max(rr.paceKM) as maxpacekm,
min(rr.paceKM) as minpacekm,
SEC_TO_TIME(avg(TIME_TO_SEC(rr.paceKM))) as avgpacekm,
fourMileTime as 4mTime,
(TIME_TO_SEC(fourMileTime)) as 4mPace,
SEC_TO_TIME(TIME_TO_SEC(fourMileTime)/(4*1.6)) as expectedpacekm
from raceresult rr
join runner r on rr.runner=r.id
join standarddata sd on r.standard = sd.standard
where rr.race=35 and r.standard > 0
group by r.standard;

select
r.standard,
max(rr.paceKM) as maxpacekm,
min(rr.paceKM) as minpacekm,
SEC_TO_TIME(avg(TIME_TO_SEC(rr.paceKM))) as avgpacekm,
SEC_TO_TIME(TIME_TO_SEC(fourMileTime)/(4*1.6)) as expectedpacekm
from raceresult rr
join runner r on rr.runner=r.id
join standarddata sd on r.standard = sd.standard
where rr.race=35 and r.standard > 0
group by r.standard;

select * from standarddata where standard=4;
select 
	standard,fourMileTime,slopeFactor,
	SEC_TO_TIME( TIME_TO_SEC(fourMileTime)/(4*1.6) ) as pacePer1Km,
	SEC_TO_TIME( TIME_TO_SEC(halfMarathonTime)/(13.1*1.6)) as pacePer21Km
from standarddata where standard=4;

select
r.standard,
min(rr.paceKM) as minpacekm,
SEC_TO_TIME(avg(TIME_TO_SEC(rr.paceKM))) as avgpacekm,
max(rr.paceKM) as maxpacekm,
SEC_TO_TIME(TIME_TO_SEC(fourMileTime)/(4*1.6)) as expectedpacekm,
SEC_TO_TIME(avg(TIME_TO_SEC(rr.paceKM))) - SEC_TO_TIME(TIME_TO_SEC(fourMileTime)/(4*1.6)) as diff
from raceresult rr
join runner r on rr.runner=r.id
join standarddata sd on r.standard = sd.standard
where rr.race=72 and r.standard > 0
group by r.standard;

select * from raceresult where race=72;
select standard from standard;
select count(runner) from raceresult where race=72 and standard=4;



describe tblMembership;
select * from tblMembership where MembNo=9946;
