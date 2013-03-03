DROP TABLE IF EXISTS `standard`;
CREATE TABLE IF NOT EXISTS `standard` (
  `id` int(11) NOT NULL auto_increment,
  `standard` int(11) NOT NULL,
  `slopefactor` double NOT NULL,
  `oneKmTimeInSecs` double NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=32;

ALTER table standard ADD COLUMN oneKmTimeInSecs2010 double NOT NULL AFTER oneKmTimeInSecs;
UPDATE standard SET oneKmTimeInSecs2010=oneKmTimeInSecs;
UPDATE standard SET oneKmTimeInSecs=(oneKmTimeInSecs2010+(oneKmTimeInSecs2010*0.02*standard));

select SEC_TO_TIME((((standard.slopefactor)*(10-1)) + standard.oneKmTimeInSecs) * 10) from standard where id=5;

select SEC_TO_TIME((((standard.slopefactor)*(km-1)) + standard.oneKmTimeInSecs) * km) from standard where id=standard;

delete from standard;
INSERT INTO standard (id,standard,slopefactor,oneKmTimeInSecs) SELECT 
	standard,
	standard,
	((TIME_TO_SEC(fourMileTime)/getRaceDistanceKm(4,'Mile')) - (TIME_TO_SEC(halfMarathonTime)/getRaceDistanceKm(13.1,'Mile'))) / (getRaceDistanceKm(4,'Mile') - getRaceDistanceKm(13.1,'Mile')),
	(slopefactor * (1 - getRaceDistanceKm(4,'Mile'))) + TIME_TO_SEC(fourMileTime)/getRaceDistanceKm(4,'Mile')
	from standarddata;
select * from standard;	

select r.id, r.firstname,r.surname
from raceresult rr
join runner r on rr.runner=r.id
where rr.race=20106 and rr.standard is null and r.status='m' and r.standard is not  null;  #26 rows

select r.id, r.firstname,r.surname
from raceresult rr
join runner r on rr.runner=r.id
where rr.race=20106 and rr.standard is null and r.status='m' and r.standard is not  null;  #5 rows

But these 2 queries show runners with no standard who have already scored in the league, quite a few.  I cant update points until these are addressed.  It would be a simple update but the question is where are these standards?

select r.id, r.firstname,r.surname
from raceresult rr
join runner r on rr.runner=r.id
join leaguerunnerdata lrd on r.id = lrd.runner and lrd.league=4
where rr.race=20105 and rr.standard is null and r.status='m' and r.standard is not  null;

select r.id, r.firstname,r.surname
from raceresult rr
join runner r on rr.runner=r.id
join leaguerunnerdata lrd on r.id = lrd.runner and lrd.league=4
where rr.race=20106 and rr.standard is null and r.status='m' and r.standard is not  null;

select * from standard;

-- display the differences between standards
select current.id, current.oneKmTimeInSecs, current.slopefactor, previous.id, previous.oneKmTimeInSecs,
(current.oneKmTimeInSecs - previous.oneKmTimeInSecs) as diff,
((current.oneKmTimeInSecs - previous.oneKmTimeInSecs)*current.slopefactor*1.6) as onemilediff
from standard current
JOIN standard previous ON ( (current.id-1) = previous.id) where current.id>1;


-- reports the standard pace, race pace min/avg/max and normalise min/avg/max.
select
s.standard as std,
count(rr.runner) as r,
sd.pace as pace,
coalesce(min(rr.paceKM),0) as r_min,
coalesce(SEC_TO_TIME(avg(TIME_TO_SEC(rr.paceKM))),0) as r_avg,
coalesce(max(rr.paceKM),0) as r_max,
coalesce(min(rr.normalisedPaceKm),0) as nor_min,
coalesce(SEC_TO_TIME(avg(TIME_TO_SEC(rr.normalisedPaceKm))),0) as nor_avg,
coalesce(max(rr.normalisedPaceKm),0) as nor_max
from standard s
join standarddata sd on sd.standard=s.standard and distance=1 and unit="KM"
left join raceresult rr on rr.standard = s.standard
group by s.standard;


-- get the pace and time for a specific standard for all recorded distances
select DISTINCT(ROUND(getRaceDistanceKM(race.distance,race.unit),1)) as dist,
SEC_TO_TIME((((standard.slopefactor) * (getRaceDistanceKm(race.distance,race.unit)-1)) + oneKmTimeInSecs) ) as pace,
SEC_TO_TIME((((standard.slopefactor) * (getRaceDistanceKm(race.distance,race.unit)-1)) + oneKmTimeInSecs) * getRaceDistanceKm(race.distance,race.unit)) as time
from race
join standard
where standard.id=1
order by dist ASC;

-- pace and time for all distances.
select sd.name as dist, ROUND(sd.km,1) as km,
SEC_TO_TIME((((standard.slopefactor) * (sd.km-1)) + oneKmTimeInSecs) ) as pace,
SEC_TO_TIME((((standard.slopefactor) * (sd.km-1)) + oneKmTimeInSecs) * sd.km) as time,
SEC_TO_TIME((((standard.slopefactor*1.05) * (sd.km-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) ) as newpace,
SEC_TO_TIME((((standard.slopefactor*1.05) * (sd.km-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) * sd.km) as newtime
from standarddistance sd
join standard
where standard.id=1
order by sd.km ASC;

-- return pace and times for distances : 1km, 1m,3km,3m,5km,5m,10km,10m,13.1,26.2
select standard.id,
(select SEC_TO_TIME((standard.slopefactor * sd.km-1) + standard.oneKmTimeInSecs) from standarddistance sd where sd.name="1k") as 1kpace,
(select SEC_TO_TIME(((standard.slopefactor * sd.km-1) + standard.oneKmTimeInSecs) * sd.km) from standarddistance sd where sd.name="1k") as 1ktime,
(select SEC_TO_TIME((standard.slopefactor * sd.km-1) + standard.oneKmTimeInSecs) from standarddistance sd where sd.name="5k") as 5kpace,
(select SEC_TO_TIME(((standard.slopefactor * sd.km-1) + standard.oneKmTimeInSecs) * sd.km) from standarddistance sd where sd.name="5k") as 5ktime,
(select SEC_TO_TIME((standard.slopefactor * sd.km-1) + standard.oneKmTimeInSecs) from standarddistance sd where sd.name="10k") as 10kpace,
(select SEC_TO_TIME(((standard.slopefactor * sd.km-1) + standard.oneKmTimeInSecs) * sd.km) from standarddistance sd where sd.name="10k") as 10ktime
from standard where standard.id=10;


select * from runner where status="I" and standard IS NULL;

select runner.id,runner.firstname,runner.surname,
(select count(raceresult.race) from raceresult where raceresult.runner=runner.id) as races from runner
where runner.status="M" and runner.standard IS NULL;

select runner.id,runner.firstname,runner.surname,count(raceresult.race) from runner
left join raceresult on raceresult.runner=runner.id
where  runner.status="M" and runner.standard IS NULL;


join raceresult on raceresult.runner=runner.id
