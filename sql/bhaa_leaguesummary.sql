

 select ls.leagueposition,t.name, ls.leaguestandard, ls.leaguepoints
from leaguesummary ls
join team t on ls.leagueparticipantid=t.id
where leaguedivision <> 'w'
order by leagueposition asc
limit 10


select ls.leagueposition,t.name, ls.leaguestandard, ls.leaguepoints
from leaguesummary ls
join team t on ls.leagueparticipantid=t.id
where ls.leaguetype == 'T'
order by ls.leagueposition asc
limit 10

select * from leaguesummary where leaguetype="T";

select ls.leagueposition,t.name, ls.leaguestandard, ls.leaguepoints
from leaguesummary ls
join team t on ls.leagueparticipantid=t.id
where leaguedivision <> 'w' and leaguetype='T' and leagueid=5
order by leagueposition asc
limit 10

select ls.leagueposition,t.name, ls.leaguestandard, ls.leaguepoints
from leaguesummary ls
join team t on ls.leagueparticipantid=t.id
where leaguedivision = 'w' and leaguetype='T' and leagueid=5
order by leagueposition asc
limit 10

-- individual league
select ls.leagueposition,r.firstname,r.surname, ls.leaguestandard, ls.leaguepoints
from leaguesummary ls
join runner r on ls.leagueparticipantid=r.id
where leaguedivision ='A'
order by leagueposition asc
limit 10;


#Runners in a sector
select r.id, r.firstname, r.surname, ls.leaguestandard, ls.leaguescorecount,
ls.leaguedivision, ls.leagueposition, ls.leaguepoints
from runner r
join company c on r.company = c.id
left join leaguesummary ls on r.id = ls.leagueparticipantid and ls.leaguetype='I' and
ls.leagueid=6
where c.sector = 1 and r.status='m'
order by ls.leagueposition asc;
order by ls.leaguedivision asc,  ls.leagueposition asc;


#Runners in a sector available for recruitment
select r.id, r.firstname, r.surname, c.name, ls.leaguestandard, ls.leaguescorecount,
ls.leaguedivision, ls.leagueposition, ls.leaguepoints
from runner r
join company c on r.company = c.id
left join leaguesummary ls on r.id = ls.leagueparticipantid and ls.leaguetype='I' and
ls.leagueid=6
left join teammember tm on r.id = tm.runner
where c.sector =1 and r.status='m' and tm.team is null
order by ls.leaguedivision asc,  ls.leagueposition asc;


#Declared teams in a sector
select t.id, t.name, ls.leaguescorecount, ls.leagueposition, ls.leaguepoints,
from team t
left join leaguesummary ls on t.id = ls.leagueparticipantid and ls.leaguetype='T' and
ls.leagueid=5
where t.parent = 29 and t.type='S'
order by ls.leaguedivision asc,  ls.leagueposition asc;



#Company teams in a sector
select t.id, t.name, ls.leaguescorecount, ls.leagueposition, ls.leaguepoints
from team t
join company c on t.parent=c.id
left join leaguesummary ls on t.id = ls.leagueparticipantid and ls.leaguetype='T' and
ls.leagueid=5
where c.sector =1 and t.type='C'
order by ls.leaguedivision asc,  ls.leagueposition asc;

-- individual league result by company
select r.id, r.firstname, r.surname, ls.leaguestandard, ls.leaguescorecount,
ls.leaguedivision, ls.leagueposition, ls.leaguepoints
from runner r
join company c on r.company = c.id
left join leaguesummary ls on r.id = ls.leagueparticipantid and ls.leaguetype='I' and ls.leagueid=6
where c.id = 110 and r.status='m'
order by ls.leaguedivision asc,  ls.leagueposition asc;


select t.type, t.tid,t.tname,t.cid,t.cname, ls.*
from
(
select t.type, t.id as tid, t.name as tname, c.id as cid, c.name as cname from team t
join company c on t.parent=c.id and t.type='C' and c.sector=20 and t.status='ACTIVE'
union
select t.type, t.id as tid,t.name as tname, null as cid, null as cname from team t
join sector s on t.parent=s.id and t.type='S'and s.id=20 and t.status='ACTIVE'
) t
LEFT JOIN leaguesummary ls ON ls.leagueparticipantid=t.tid AND ls.leaguetype='T'
WHERE ls.leagueid = 5
ORDER BY ls.leaguedivision asc, ls.leagueposition asc LIMIT 10;




SELECT `X`.`type`, `X`.`id`, `X`.`name` FROM (
`SELECT `team`.`type`, `team`.`id`, `team`.`name` FROM `team` INNER JOIN `company` ON
team.parent=company.id WHERE (team.type="C") AND (team.status="ACTIVE") AND (company.sector='1')
UNION
SELECT `team`.`type`, `team`.`id`, `team`.`name` FROM `team` INNER JOIN `sector` ON
team.parent=sector.id WHERE (team.type="S") AND (team.status="ACTIVE") AND (sector.id='1')` )
AS `X` WHERE (leaguesummary.leaguetype="T") AND (leaguesummary.leagueid = 5)
ORDER BY `leaguesummary`.`leaguedivision` asc, `leaguesummary`.`leagueposition` asc LIMIT 10

select t.type, t.tid,t.tname,t.cid,t.cname, ls.*
from
(
select t.type, t.id as tid, t.name as tname, c.id as cid, c.name as cname from team t
join company c on t.parent=c.id and t.type='C' and c.sector=20 and t.status='ACTIVE'
union
select t.type, t.id as tid,t.name as tname, null as cid, null as cname from team t
join sector s on t.parent=s.id and t.type='S'and s.id=20 and t.status='ACTIVE'
) t
LEFT JOIN leaguesummary ls ON ls.leagueparticipantid=t.tid AND ls.leaguetype='T'
WHERE ls.leagueid = 5
ORDER BY ls.leaguedivision asc, ls.leagueposition asc LIMIT 10;


2010-06-04T14:58:56+00:00 INFO (6): SELECT `team`.`type`, `team`.`id`, `team`.`name` FROM `team`
 INNER JOIN `company` ON team.parent=company.id WHERE (team.type="C") AND (team.status="ACTIVE") AND (company.sector='20')
2010-06-04T14:58:56+00:00 INFO (6): SELECT `team`.`type`, `team`.`id`, `team`.`name` FROM `team`
 INNER JOIN `sector` ON team.parent=sector.id WHERE (team.type="S") AND (team.status="ACTIVE") AND (sector.id='20')

SELECT `team`.`type`, `team`.`id`, `team`.`name` FROM `team` INNER JOIN `company` ON
team.parent=company.id WHERE (team.type="C") AND (team.status="ACTIVE") AND (company.sector='20')
UNION
SELECT `team`.`type`, `team`.`id`, `team`.`name` FROM `team` INNER JOIN `sector` ON
team.parent=sector.id WHERE (team.type="S") AND (team.status="ACTIVE") AND (sector.id='20')

SELECT `X`.`type`, `X`.`id`, `X`.`name`, `leaguesummary`.* FROM `( SELECT ``team```.```type``, ``team``` AS `X`
 LEFT JOIN `leaguesummary` ON leaguesummary.leagueparticipantid=X.id WHERE (leaguesummary.leaguetype="T") AND (leaguesummary.leagueid = 5) ORDER BY `leaguesummary`.`leaguedivision` asc, `leaguesummary`.`leagueposition` asc LIMIT 10


SELECT `X`.`type`, `X`.`id`, `X`.`name`, `leaguesummary`.* FROM
(
SELECT `team`.`type`, `team`.`id`, `team`.`name` FROM `team` INNER JOIN `company` ON
team.parent=company.id WHERE (team.type="C") AND (team.status="ACTIVE") AND (company.sector='20')
UNION
SELECT `team`.`type`, `team`.`id`, `team`.`name` FROM `team` INNER JOIN `sector` ON
team.parent=sector.id WHERE (team.type="S") AND (team.status="ACTIVE") AND (sector.id='20')
)
AS `X`
 LEFT JOIN `leaguesummary` ON leaguesummary.leagueparticipantid=X.id
WHERE (leaguesummary.leaguetype="T") AND (leaguesummary.leagueid = 5)
ORDER BY `leaguesummary`.`leaguedivision` asc, `leaguesummary`.`leagueposition`
asc LIMIT 10



SELECT `team`.`type`, `team`.`id`, `team`.`name`, `company`.`id` AS `comid`, `company`.`name` AS `compname`, `leaguesummary`.* FROM `team`
 LEFT JOIN `company` ON team.parent=company.id and company.sector=20 and team.status="ACTIVE"
 LEFT JOIN `sector` ON team.parent=sector.id and sector.id=20 and team.status="ACTIVE
 LEFT JOIN `leaguesummary` ON (leaguesummary.leagueparticipantid=team.id and leaguesummary.leaguetype="T")
WHERE (leaguesummary.leagueid = 5)
AND (company.id IS NOT NULL and team.type="C")
OR (sector.id IS NOT NULL and team.type='S')

select t.type, t.id as tid, t.name as tname, c.id as cid, c.name as cname
from team t
left join company c on t.type='C' and t.parent=c.id  and c.sector=4 and t.status='ACTIVE'
left join sector s on t.parent=s.id and t.type='S'and s.id=4 and t.status='ACTIVE'
LEFT JOIN leaguesummary ls ON ls.leagueparticipantid=t.id AND ls.leaguetype='T'
WHERE ls.leagueid = 5 and (c.id is not null and t.type='C') or (s.id is not null and t.type='S');

-- list top ten in the individual league
SELECT `leaguesummary`.*, `runner`.`firstname`, `runner`.`surname` FROM `leaguesummary`
INNER JOIN `runner` ON leaguesummary.leagueparticipantid=runner.id WHERE (leaguesummary.leaguedivision = 'A')
ORDER BY `leaguesummary`.`leagueposition` asc LIMIT 10

-- ladies team summary
SELECT `leaguesummary`.*, team.* FROM `leaguesummary`
INNER JOIN `team` ON leaguesummary.leagueparticipantid=team.id
WHERE leaguesummary.leaguetype = 'T' and leaguesummary.leaguedivision='W'
ORDER BY `leaguesummary`.`leagueposition` asc LIMIT 10

-- mens team summary
SELECT `leaguesummary`.*, team.* FROM `leaguesummary`
INNER JOIN `team` ON leaguesummary.leagueparticipantid=team.id
WHERE leaguesummary.leaguetype = 'T' AND leaguesummary.leaguedivision != 'W'
ORDER BY `leaguesummary`.`leagueposition` asc LIMIT 10


SELECT `leaguesummary`.*, `team`.`name`, `team`.`type` FROM `leaguesummary`
INNER JOIN `team` ON leaguesummary.leagueparticipantid=team.id
WHERE (leaguesummary.leaguedivision = 'T') AND (leaguesummary.leaguedivision != 'W')
ORDER BY `leaguesummary`.`leagueposition` asc



SELECT `leaguesummary`.*, `team`.`name`, `team`.`type` FROM `leaguesummary` INNER JOIN `team` ON leaguesummary.leagueparticipantid=team.id WHERE (leaguesummary.leaguedivision = "T") AND (leaguesummary.leaguedivision="W") ORDER BY `leaguesummary`.`leagueposition` asc