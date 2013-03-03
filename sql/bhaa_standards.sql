-- select previous members who need standard rechecked
select
runner,
raceresult.standard,
runner.standard,
runner.firstname,
runner.surname,
raceresult.paceKM
from raceresult
join runner on runner.id=raceresult.runner
where raceresult.standard is NULL
and runner.status="M" and race=20105;

-- list day runners who became members after the race
select X.id as newId, Y.Id as currentId,Y.position,Y.standard, X.firstname, Y.surname
from runner X join
(select r.id,r.firstname,r.surname,r.dateofbirth,rr.position,rr.standard
from raceresult rr
join runner r on rr.runner=r.id
where race=20105 and r.status='d') Y
on X.firstname=Y.firstname AND X.surname=Y.surname
AND X.status='M' order by Y.position asc;
select X.id as newId, Y.Id as currentId,Y.position,Y.standard, X.firstname, Y.surname
from runner X join
(select r.id,r.firstname,r.surname,r.dateofbirth,rr.position,rr.standard
from raceresult rr
join runner r on rr.runner=r.id
where race=20105 and r.status='d') Y
on X.firstname=Y.firstname AND X.surname=Y.surname
AND X.status='M' order by Y.position asc

-- spot unlinked runners
select X.id as newId, Y.Id as currentId,Y.position,Y.standard, X.firstname, Y.surname
from runner X join
(select r.id,r.firstname,r.surname,r.dateofbirth,rr.position,rr.standard
from raceresult rr
join runner r on rr.runner=r.id
where race=20105 and r.status='d') Y
on X.firstname=Y.firstname AND X.surname=Y.surname
AND X.status='M' order by Y.position asc;

-- <-35 >35 -- ru.firstname,ru.surname
select
ru.id,raceresult.position,raceresult.standard,raceresult.postRaceStandard,
avgpace,expectedpace,pacediff,pacekm as actualpace
from raceresult raceresult
join runner ru on raceresult.runner=ru.id
join ( select rr.standard,
sec_to_time(avg(time_to_sec(rr.pacekm))) as avgpace,
sec_to_time((slopefactor * (8.1-1)) + onekmtimeinsecs) as expectedpace,
sec_to_time((avg(time_to_sec(rr.pacekm)))-((slopefactor * (8.1-1)) +
onekmtimeinsecs))  as pacediff
from raceresult rr
join standard s on rr.standard=s.standard
where rr.race=20105 and rr.standard>0
group by rr.standard
) X on raceresult.standard=X.standard
where raceresult.race=20105 and ru.status='M'
and (expectedpace+pacediff) - pacekm <-35;

-- list runner times, the expected and average and differences
select
ru.id,raceresult.position,raceresult.standard,raceresult.postRaceStandard,racetime,
rts.expected,rts.`avg`,
(racetime-rts.`avg`) as averagediff,
(racetime-rts.expected) as expecteddiff
from raceresult raceresult
join runner ru on raceresult.runner=ru.id
left join racetimestandard rts on (rts.standard = raceresult.standard AND rts.race=raceresult.race)
where raceresult.race=20106 and ru.status='M'
order by position;

-- add fast/slow column 
select
ru.id,raceresult.position,raceresult.standard,raceresult.postRaceStandard,racetime,
rts.expected,rts.`avg`,
(racetime-rts.`avg`) as averagediff,
(racetime-rts.expected) as expecteddiff,
getRaceDistanceKM(race.distance,race.unit)*5 as standardgap,
(select IF(averagediff > standardgap,"FAST","")) as fast,
(select IF(averagediff < -standardgap,"SLOW","")) as slow
from raceresult raceresult
join runner ru on raceresult.runner=ru.id
join race race on race.id=raceresult.race
left join racetimestandard rts on (rts.standard = raceresult.standard AND rts.race=raceresult.race)
where raceresult.race=20105 and ru.status='M'
order by position;

