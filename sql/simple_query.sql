SQL to look all the results for a runner in a league

SELECT e.name, rr.position, CONCAT( r.firstname, ' ', r.surname ) AS runnername, rr.points, rr.racetime, rr.paceKM, r.standard, rr.postracestandard, ABS( (
(
r.standard - rr.postracestandard
) / r.standard ) *100
) AS PercentageStandardChange
FROM raceresult rr
JOIN runner r ON rr.runner = r.id
JOIN race ra ON rr.race = ra.id
JOIN event e ON ra.event = e.Id
JOIN leagueevent le ON e.Id = le.event
WHERE r.Firstname = 'Sean'
AND r.surname = 'slattery'
AND le.league =1
AND rr.PaceKM IS NOT NULL;

SELECT e.name, rr.position, CONCAT( r.firstname, ' ', r.surname ) AS runnername, rr.points, rr.racetime, rr.paceKM, r.standard, rr.postracestandard, ABS( (
(
r.standard - rr.postracestandard
) / r.standard ) *100
) AS PercentageStandardChange
FROM raceresult rr
JOIN runner r ON rr.runner = r.id
JOIN race ra ON rr.race = ra.id
JOIN event e ON ra.event = e.Id
JOIN leagueevent le ON e.Id = le.event
WHERE r.Firstname = 'Paul'
AND r.surname = 'O\'Connell'
AND le.league =1
AND rr.PaceKM IS NOT NULL;

SELECT e.name, rr.position, CONCAT( r.firstname, ' ', r.surname ) AS runnername, rr.points, rr.racetime, rr.paceKM, r.standard, rr.postracestandard, ABS( (
(
r.standard - rr.postracestandard
) / r.standard ) *100
) AS PercentageStandardChange
FROM raceresult rr
JOIN runner r ON rr.runner = r.id
JOIN race ra ON rr.race = ra.id
JOIN event e ON ra.event = e.Id
JOIN leagueevent le ON e.Id = le.event
WHERE r.id = 7713
AND le.league =1
AND rr.PaceKM IS NOT NULL;


Get a division A table (obviously you can do this for any range so the B range etc.

SELECT CONCAT( r.firstname, ' ', r.surname ) AS runnername, r.standard, l.racescomplete, l.avgOverallPosition, l.pointsTotal
FROM leaguerunnerdata l
JOIN runner r ON l.runner = r.id
WHERE l.league =1
AND r.standard
BETWEEN 1 AND 7 ORDER BY l.pointsTotal DESC; 

SELECT CONCAT( r.firstname, ' ', r.surname ) AS runnername, r.standard, l.racescomplete, l.avgOverallPosition, l.pointsTotal
FROM leaguerunnerdata l
JOIN runner r ON l.runner = r.id
WHERE l.league =1
AND r.standard
BETWEEN 8 AND 15 ORDER BY l.pointsTotal DESC; 


select count(runner) as number from raceresult where race=62;
select * from race where race.event=21;

-- list all runners for an event
select count(runner) as number 
from raceresult rr
JOIN race r ON r.id = rr.race
JOIN event e on e.id = r.event AND e.id=1;

select * from race where event=1;
select * from raceresult where race=2;
describe race;

-- races with name and file
select race.id, race.event, event.name, race.distance, race.file
from race as race 
JOIN event event ON race.event = event.id
where event.id=1;

select race.id, race.event, event.name, race.distance, race.file, count(rr.runner) as n
from race as race 
JOIN event event ON race.event = event.id
JOIN raceresult rr ON race.id = rr.race
where race.id=2;

-- list all races, totals and files
select race.id, race.event, race.distance, race.file, 
(select name from event where event.id=race.event) as name,
(select count(rr.runner) from raceresult rr where race.id = rr.race) as number
from race as race;
