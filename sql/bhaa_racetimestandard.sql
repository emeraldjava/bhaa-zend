DROP TABLE IF EXISTS `racetimestandard`;
CREATE TABLE IF NOT EXISTS `racetimestandard` (
  `race` int(8) NOT NULL,
  `standard` int(2) NOT NULL,
  `runners` int(4) NOT NULL,
  `expected` time NOT NULL,
  `min` time NOT NULL,
  `average` time NOT NULL,
  `max` time NOT NULL,
  `exp_avg_diff` int NOT NULL,
  `factored` time
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- populate the standard times for a race
INSERT INTO racetimestandard(race,standard,runners,expected,min,average,max,exp_avg_diff)
select
coalesce(race.id,20108) as race,
sd.standard as standard,
count(rr.runner) as runners,
coalesce(SEC_TO_TIME( (oneKmTimeInSecs + (getRaceDistanceKM(X.distance,X.unit)*slopefactor))*getRaceDistanceKM(X.distance,X.unit) ),0) as expected,
coalesce(min(rr.racetime),0) as min,
coalesce(SEC_TO_TIME(avg(TIME_TO_SEC(rr.racetime))),0) as average,
coalesce(max(rr.racetime),0) as max,
IF(count(rr.runner)=0,0,ROUND(coalesce( (oneKmTimeInSecs + (getRaceDistanceKM(X.distance,X.unit)*slopefactor))*getRaceDistanceKM(X.distance,X.unit) ,0) - (coalesce( avg(TIME_TO_SEC(rr.racetime)),0)),0) ) as exp_avg_diff
from standard sd
left join  raceresult rr on rr.standard = sd.standard and rr.race=20108
left join  race  on rr.race = race.id
join (select race.id,race.distance,race.unit from race where id=20108) X on coalesce(race.id,20108)=X.id
group by sd.standard;

select * from racetimestandard;

DROP TABLE IF EXISTS `racestd`;
CREATE TABLE IF NOT EXISTS `racestd` (
  `race` int(8) NOT NULL,
  `avgdiff` int NOT NULL,
  `fudge` int DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT into racestd(race,avgdiff)
select race,AVG(exp_avg_diff) from racetimestandard where race=20108;
select * from racestd;

select id,expected,avgdiff,SEC_TO_TIME(TIME_TO_SEC(expected)+((avgdiff*-1)*fudge)) as factored from standard
join racetimestandard on racetimestandard.standard=standard.id
join racestd on racestd.race=racetimestandard.race where racetimestandard.race=20108;

update racetimestandard
join standard on racetimestandard.standard=standard.id
join racestd on racestd.race=racetimestandard.race
set factored=(SEC_TO_TIME(TIME_TO_SEC(expected)+((avgdiff*-1)*fudge)))
where racetimestandard.race=20108

select position, standard, racetime from raceresult where race=20108;

select * from racetimestandard where race =20108;

select * from standard


select
ru.id,raceresult.position,raceresult.standard,raceresult.postRaceStandard,racetime,
rts.expected,rts.`average`,
(racetime-rts.`average`) as averagediff,
(racetime-rts.expected) as expecteddiff
from raceresult raceresult
join runner ru on raceresult.runner=ru.id
left join racetimestandard rts on (rts.standard = raceresult.standard AND rts.race=raceresult.race)
where raceresult.race=20106 and ru.status='M'
order by position;

-- fast and slow runners
select
ru.id,ru.firstname,ru.surname,
raceresult.position,raceresult.standard,raceresult.postRaceStandard,racetime,
rts.expected,rts.average,
(racetime-rts.`average`) as averagediff,
(racetime-rts.expected) as expecteddiff,
(getRaceDistanceKM(race.distance,race.unit)*5) as standardgap,
(select IF(averagediff > standardgap,"SLOW->30","")) as slow,
(select IF(averagediff < -standardgap,"FAST->0","")) as fast
from raceresult raceresult
join runner ru on raceresult.runner=ru.id
join race as race on race.id=raceresult.race
left join racetimestandard rts on (rts.standard = raceresult.standard AND rts.race=raceresult.race)
where raceresult.race=20106 and ru.status!='D'
order by position;


select distinct(race) from racetimestandard;
select race, AVG(max),Avg(min) from racetimestandard group by race;

select * from racetimestandard where race=201010;

select race,AVG(exp_avg_diff) from racetimestandard where race=201010;

select * from division;

-- division based standard time report
select d.id,d.name,sec_to_time(avg(time_to_sec(rts.average))),avg(exp_avg_diff)
from division d
join racetimestandard rts on rts.standard between d.min and d.max and rts.average>0
where race=20109 and d.type='I'
group by d.id,d.name;





