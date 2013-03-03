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
and runner.status="M" and race=20103;

--
6079			Emma	Boland	00:04:54
7348		18	Catherine	McCauley	00:05:02
6004			Aisling	Phelan	00:05:15
6046			Katy	Dempsey	00:05:20
6061			Chloe	Foley	00:05:35
6037			Maeve	Dunne	00:06:40

-- show the eircom averages
select standard,min,avg,max,runners from racestandard where race=20103;

CALL applyNewRunnerStandard(20103,6079,11);
CALL applyNewRunnerStandard(20103,7348,12);
CALL applyNewRunnerStandard(20103,6004,13);
CALL applyNewRunnerStandard(20103,6046,14);
CALL applyNewRunnerStandard(20103,6061,16);
CALL applyNewRunnerStandard(20103,6037,20);

-- spot unlinked women
select X.id as newId, Y.Id as currentId,Y.position,Y.standard, X.firstname, Y.surname
from runner X join
(select r.id,r.firstname,r.surname,r.dateofbirth,rr.position,rr.standard
from raceresult rr
join runner r on rr.runner=r.id
where race=20103 and r.status='d') Y
on X.firstname=Y.firstname AND X.surname=Y.surname
AND X.status='M' order by Y.position asc;

--
6085	11955	41		Edel	Foley

update raceresult set runner=6085 where race=20103 and runner=11955;
CALL applyNewRunnerStandard(20103,6085,11);


-- spot unlinked men
select X.id as newId, Y.Id as currentId,Y.position,Y.standard, X.firstname, Y.surname
from runner X join
(select r.id,r.firstname,r.surname,r.dateofbirth,rr.position,rr.standard
from raceresult rr
join runner r on rr.runner=r.id
where race=20104 and r.status='d') Y
on X.firstname=Y.firstname AND X.surname=Y.surname
AND X.status='M' order by Y.position asc;

--
5332	11966	41		Keith	Sherlock

update raceresult set runner=5332 where race=20104 and runner=11966;
CALL applyNewRunnerStandard(20103,6085,11);

# Men with no standard who ran some appear to have had a previous standard
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
and runner.status="M" and race=20104;

6084			Tommy	Evans	00:03:17
6074			James	Griffin	00:03:39
9133		6	Gerard	Daly	00:03:40
8705		6	Joe	Casey	00:03:42
6087			Ernie	Ramsey	00:03:46
6088			Donal	Hanratty	00:03:46
5332		8	Keith	Sherlock	00:03:48
6073			Niall	Murphy	00:03:50
7952		9	Colm	Rothery	00:03:50
7679		13	Darragh	Page	00:03:55
7145		13	Claude	McManmon	00:04:30
6081		0	Darren	Foster	00:04:40
6082			James	Doyle	00:04:48
6086			Paul	Ã“ Hara	00:04:49
6080			SeÃ¡n	McPhillips	00:05:18
6072			Stephen	Kerr	00:05:18
6032			Mark	Stanley	00:05:20

CALL applyNewRunnerStandard(20104,	6084,2);
CALL applyNewRunnerStandard(20104,	6074,5);
CALL applyNewRunnerStandard(20104,	9133,5);
CALL applyNewRunnerStandard(20104,	8705,5);
CALL applyNewRunnerStandard(20104,	6087,6);
CALL applyNewRunnerStandard(20104,	6088,6);
CALL applyNewRunnerStandard(20104,	5332,6);
CALL applyNewRunnerStandard(20104,	6073,7);
CALL applyNewRunnerStandard(20104,	7952,7);
CALL applyNewRunnerStandard(20104,	7679,7);
CALL applyNewRunnerStandard(20104,	7145,12);
CALL applyNewRunnerStandard(20104,	6081,14);
CALL applyNewRunnerStandard(20104,	6082,15);
CALL applyNewRunnerStandard(20104,	6086,15);
CALL applyNewRunnerStandard(20104,	6080,17);
CALL applyNewRunnerStandard(20104,	6072,17);
CALL applyNewRunnerStandard(20104,	6032,17);

select standard,min,avg,max,runners from racestandard where race=20104;

-- people to move

select
ru.id,ru.firstname,ru.surname,router.standard,avgpace,pacediff,pacekm as
actualpace
from raceresult router
join runner ru on router.runner=ru.id
join (
select rr.standard,
sec_to_time(avg(time_to_sec(rr.pacekm))) as avgpace,
sec_to_time((slopefactor * (8.1-1)) + onekmtimeinsecs) as expectedpace,
sec_to_time((avg(time_to_sec(rr.pacekm)))-((slopefactor * (8.1-1)) +
onekmtimeinsecs))  as pacediff
from raceresult rr
join standard s on rr.standard=s.standard
where rr.race=20103 and rr.standard>0
group by rr.standard
) X on router.standard=X.standard
where router.race=20103 and ru.status='M' and
(expectedpace+pacediff) - pacekm >35;

select
ru.id,ru.firstname,ru.surname,router.standard,avgpace,expectedpace,pacediff,pacekm as
actualpace
from raceresult router
join runner ru on router.runner=ru.id
join

(
select rr.standard,
sec_to_time(avg(time_to_sec(rr.pacekm))) as avgpace,
sec_to_time((slopefactor * (8.1-1)) + onekmtimeinsecs) as expectedpace,
sec_to_time((avg(time_to_sec(rr.pacekm)))-((slopefactor * (8.1-1)) +
onekmtimeinsecs))  as pacediff
from raceresult rr
join standard s on rr.standard=s.standard
where rr.race=20104 and rr.standard>0
group by rr.standard
) X on router.standard=X.standard
where router.race=20104 and ru.status='M' and
(expectedpace+pacediff) - pacekm >35;



select
ru.id,ru.firstname,ru.surname,router.standard,avgpace,expectedpace,pacediff,pacekm as
actualpace
from raceresult router
join runner ru on router.runner=ru.id
join

(
select rr.standard,
sec_to_time(avg(time_to_sec(rr.pacekm))) as avgpace,
sec_to_time((slopefactor * (8.1-1)) + onekmtimeinsecs) as expectedpace,
sec_to_time((avg(time_to_sec(rr.pacekm)))-((slopefactor * (8.1-1)) +
onekmtimeinsecs))  as pacediff
from raceresult rr
join standard s on rr.standard=s.standard
where rr.race=20103 and rr.standard>0
group by rr.standard
) X on router.standard=X.standard
where router.race=20103 and ru.status='M' and
(expectedpace+pacediff) - pacekm <-35;

select
ru.id,ru.firstname,ru.surname,router.standard,avgpace,expectedpace,pacediff,pacekm as
actualpace
from raceresult router
join runner ru on router.runner=ru.id
join

(
select rr.standard,
sec_to_time(avg(time_to_sec(rr.pacekm))) as avgpace,
sec_to_time((slopefactor * (8.1-1)) + onekmtimeinsecs) as expectedpace,
sec_to_time((avg(time_to_sec(rr.pacekm)))-((slopefactor * (8.1-1)) +
onekmtimeinsecs))  as pacediff
from raceresult rr
join standard s on rr.standard=s.standard
where rr.race=20104 and rr.standard>0
group by rr.standard
) X on router.standard=X.standard
where router.race=20104 and ru.status='M' and
(expectedpace+pacediff) - pacekm <-35;
