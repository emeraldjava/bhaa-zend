-- display matches

select X.id as newId,Y.position, Y.Id as currentId, X.firstname, Y.surname
from runner X
join
(select r.id,r.firstname,r.surname, r.dateofbirth, rr.position
from raceresult rr
join runner r on rr.runner=r.id
where race=20102 and r.status='d') Y
on X.firstname=Y.firstname AND X.surname=Y.surname AND X.dateofbirth=Y.dateofbirth
AND X.status='M' order by Y.position asc;


select
ru.id,ru.firstname,ru.surname,router.standard,avgpace,expectedpace,pacediff,pacekm as
actualpace
from raceresult router
join runner ru on router.runner=ru.id
join (
select rr.standard,
sec_to_time(avg(time_to_sec(rr.pacekm))) as avgpace,
sec_to_time((slopefactor * (6.437-1)) + onekmtimeinsecs) as expectedpace,
sec_to_time((avg(time_to_sec(rr.pacekm)))-((slopefactor * (6.437-1)) +
onekmtimeinsecs))  as pacediff
from raceresult rr
join standard s on rr.standard=s.standard
where rr.race=20101 and rr.standard>0
group by rr.standard
) X on router.standard=X.standard
where router.race=20101 and ru.status='M' and
(expectedpace+pacediff) - pacekm >30;

select * from re

select rr.runner,r.firstname,r.surname, r.status,r.standard
from raceresult rr
join runner r on rr.runner = r.id
where rr.race=20101 and rr.standard is null and rr.runner in (select runner from
leaguerunnerdata);

select rr.runner,r.firstname,r.surname,r.status,r.standard
from raceresult rr
left join runner r on rr.runner = r.id
where rr.race=20101 and r.standard = 0;

-- list the pre, post and runner standards
select runner,raceresult.standard as prerace,raceresult.postRaceStandard as post,
runner.firstname,runner.surname,runner.standard,raceresult.paceKM from raceresult
join runner on runner.id=raceresult.runner
where raceresult.standard = 0
and runner.status="M" and race=20101;

select runner,raceresult.standard as prerace,raceresult.postRaceStandard as post,
runner.firstname,runner.surname,runner.standard,raceresult.paceKM from raceresult
join runner on runner.id=raceresult.runner
where raceresult.standard is NULL
and runner.status="M" and race=20101;



select runner,standard from raceresult where race=20101 and;
update raceresult set standard=0 where race=20102 and standard is NULL;

select
ru.id,ru.firstname,ru.surname,router.standard,avgpace,expectedpace,pacediff,pacekm as
actualpace
from raceresult router
join runner ru on router.runner=ru.id
join (
select rr.standard,
sec_to_time(avg(time_to_sec(rr.pacekm))) as avgpace,
sec_to_time((slopefactor * (6.437-1)) + onekmtimeinsecs) as expectedpace,
sec_to_time((avg(time_to_sec(rr.pacekm)))-((slopefactor * (6.437-1)) +
onekmtimeinsecs))  as pacediff
from raceresult rr
join standard s on rr.standard=s.standard
where rr.race=20101 and rr.standard>0
group by rr.standard
) X on router.standard=X.standard
where router.race=20101 and ru.status='M' and
(expectedpace+pacediff) - pacekm <-60;

-- list day runners who became members after the race
select X.id as newId, Y.Id as currentId,Y.position,Y.standard, X.firstname, Y.surname
from runner X join
(select r.id,r.firstname,r.surname,r.dateofbirth,rr.position,rr.standard
from raceresult rr
join runner r on rr.runner=r.id
where race=20102 and r.status='d') Y
on X.firstname=Y.firstname AND X.surname=Y.surname
AND X.status='M' order by Y.position asc


update raceresult set runner=6064 where race=20102 and runner=11865;
update raceresult set runner=6042 where race=20102 and runner=11873;
update raceresult set runner=7843 where race=20102 and runner=11874;
update raceresult set runner=6049 where race=20102 and runner=11890;
update raceresult set runner=6036 where race=20102 and runner=11899;
update raceresult set runner=6060 where race=20102 and runner=11900;


update raceresult set runner=6065 where race=20101 and runner=11857;
update raceresult set standard=9 where race=20101 and runner=9946;
update raceresult set standard=11 where race=20101 and runner=5118;
update raceresult set standard=23 where race=20101 and runner=5821;
update raceresult set standard=null where race=20101 and runner=6020;

CALL applyNewRunnerStandard(20101,5118,11);
CALL applyNewRunnerStandard(20101,6065,11);
CALL applyNewRunnerStandard(20101,6050,15);
CALL applyNewRunnerStandard(20101,6020,17);
CALL applyNewRunnerStandard(20101,5821,23);


select * from raceresult where race=20102 and runner>=6000 and runner <=6500;
update raceresult set standard = NULL where race=20102 and runner>=6000 and runner <=6500;


-- list the pre, post and runner standards
select runner,raceresult.standard as prerace,raceresult.postRaceStandard as post,
runner.firstname,runner.surname,runner.standard,raceresult.paceKM from raceresult
join runner on runner.id=raceresult.runner
where raceresult.standard is NULL
and runner.status="M" and race=20102 order by paceKm asc;

select runner,raceresult.standard as prerace,raceresult.postRaceStandard as post,
runner.firstname,runner.surname,runner.standard,raceresult.paceKM from raceresult
join runner on runner.id=raceresult.runner
where raceresult.standard is NULL and runner.standard is not null
and runner.status="M" and race=20102;

update raceresult set standard=3 where race=20102 and runner=9736;
update raceresult set standard=5 where race=20102 and runner=1500;
update raceresult set standard=4 where race=20102 and runner=8706;
update raceresult set standard=11 where race=20102 and runner=7247;
update raceresult set standard=7 where race=20102 and runner=5535;
update raceresult set standard=6 where race=20102 and runner=7843;
update raceresult set standard=7 where race=20102 and runner=9652;
update raceresult set standard=9 where race=20102 and runner=9705;
update raceresult set standard=16 where race=20102 and runner=7356;
update raceresult set standard=22 where race=20102 and runner=9001;

update raceresult set standard=NULL where race=20102 and runner=9384;

select runner,runner.firstname,runner.surname,runner.standard,raceresult.paceKM from raceresult
join runner on runner.id=raceresult.runner
where raceresult.standard is NULL
and runner.status="M" and race=20102 order by paceKm asc;

-- nulla reilly to 14
CALL applyNewRunnerStandard(20101,8747,14);
-- men
CALL applyNewRunnerStandard(20102,4637,20);
CALL applyNewRunnerStandard(20102,7247,10);
CALL applyNewRunnerStandard(20102,8863,9);
CALL applyNewRunnerStandard(20102,5745,10);
CALL applyNewRunnerStandard(20102,8276,11);

CALL applyNewRunnerStandard(20102,5580,9);
CALL applyNewRunnerStandard(20102,5124,12);
CALL applyNewRunnerStandard(20102,7487,13);
CALL applyNewRunnerStandard(20102,9383,22);
CALL applyNewRunnerStandard(20102,9874,17);
CALL applyNewRunnerStandard(20102,8595,17);
CALL applyNewRunnerStandard(20102,7657,12);



