DROP TABLE IF EXISTS `teamraceresult`;
CREATE TABLE IF NOT EXISTS `teamraceresult` (
 `id` INTEGER NOT NULL AUTO_INCREMENT,
 `team` INTEGER NOT NULL,
 `league` INTEGER NOT NULL,
 `race` INTEGER NOT NULL,
 `runnerfirst` INTEGER ,
 `runnersecond` INTEGER ,
 `runnerthird` INTEGER ,
 `standardtotal` INTEGER ,
 `positiontotal` INTEGER ,
 `class` ENUM('A','B','C','D','E'),
 `leaguepoints` INTEGER  NOT NULL DEFAULT 0,
 PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

update teamraceresult set league=5 where league=6;

INSERT INTO teamraceresult(league,race,team)
SELECT 4 as league, 71 as race, t.id
FROM   raceresult rr
JOIN   runner r ON rr.runner = r.id
JOIN   teammember tm ON r.id = tm.runner
JOIN   team t ON tm.team=t.id
WHERE  race=71
AND t.name <> 'Undefined'
AND r.Gender = 'M'
GROUP BY t.id
HAVING count(t.id) >=3;

INSERT INTO teamraceresult(league,race,team)
SELECT 4 as league, 70 as race, t.id
FROM   raceresult rr
JOIN   runner r ON rr.runner = r.id
JOIN   teammember tm ON r.id = tm.runner
JOIN   team t ON tm.team=t.id
WHERE  race=70
AND t.name <> 'Undefined'
AND r.Gender = 'W'
GROUP BY t.id
HAVING count(t.id) >=3;

UPDATE teamraceresult set runnerfirst=8729, runnersecond=7305, runnerthird=7669, standardtotal=28, positiontotal=83, class="A" where race=71 and team=701;
UPDATE teamraceresult set runnerfirst=8450, runnersecond=5830, runnerthird=8722, standardtotal=30, positiontotal=111, class="A" where race=71 and team=256;
UPDATE teamraceresult set runnerfirst=7121, runnersecond=9355, runnerthird=7871, standardtotal=36, positiontotal=185, class="B" where race=71 and team=110;
UPDATE teamraceresult set runnerfirst=5387, runnersecond=5230, runnerthird=8080, standardtotal=49, positiontotal=235, class="B" where race=71 and team=204;
UPDATE teamraceresult set runnerfirst=7500, runnersecond=7666, runnerthird=8102, standardtotal=51, positiontotal=266, class="C" where race=71 and team=39;
UPDATE teamraceresult set runnerfirst=5790, runnersecond=7507, runnerthird=7699, standardtotal=58, positiontotal=278, class="D" where race=71 and team=137;

UPDATE teamraceresult set runnerfirst=8243, runnersecond=5031, runnerthird=7897, standardtotal=39, positiontotal=18, class="E" where race=70 and team=27;
UPDATE teamraceresult set runnerfirst=5790, runnersecond=7507, runnerthird=7699, standardtotal=51, positiontotal=76, class="E" where race=70 and team=137;
UPDATE teamraceresult set runnerfirst=5394, runnersecond=5686, runnerthird=5147, standardtotal=57, positiontotal=77, class="E" where race=70 and team=117;

select trr.team, r.id, r2.id from teamraceresult trr
join runner r on r.id = trr.runnerfirst
join runner r2 on r2.id = trr.runnersecond
where race=70 and trr.id=8;

-- team league
SELECT A.id, A.name,
sdcc, eircom, ncf, airport, garda,
total - (SELECT COUNT(id) FROM teamraceresult WHERE team=A.Id AND class='O') as overall
FROM
(
SELECT x.id,x.name,
SUM(CASE x.race WHEN 20102 THEN x.points ELSE NULL END) AS sdcc,
SUM(CASE x.race WHEN 20104 THEN x.points ELSE NULL END) AS eircom,
SUM(CASE x.race WHEN 20106 THEN x.points ELSE NULL END) AS ncf,
SUM(CASE x.race WHEN 20108 THEN x.points ELSE NULL END) AS airport,
SUM(CASE x.race WHEN 201010 THEN x.points ELSE NULL END) AS garda,
SUM(x.points) as total
FROM
(
SELECT t.id,t.name,trr.race,MAX(trr.leaguepoints) as points
FROM teamraceresult trr
JOIN team t on trr.team=t.id
WHERE trr.league = 5 and trr.class!='W'
GROUP BY t.id,t.name,trr.race
) x
GROUP BY x.id, x.name
) A
ORDER by overall DESC;

SELECT x.id,x.name,
SUM(CASE x.race WHEN 20102 THEN x.points ELSE NULL END) AS sdcc,
SUM(CASE x.race WHEN 20104 THEN x.points ELSE NULL END) AS eircom,
SUM(CASE x.race WHEN 20106 THEN x.points ELSE NULL END) AS ncf,
SUM(CASE x.race WHEN 20108 THEN x.points ELSE NULL END) AS airport,
SUM(CASE x.race WHEN 201010 THEN x.points ELSE NULL END) AS garda,
SUM(x.points) as total
FROM
(
SELECT t.id,t.name,trr.race,MAX(trr.leaguepoints) as points
FROM teamraceresult trr
JOIN team t on trr.team=t.id
WHERE trr.league = 5 and trr.class!='W'
GROUP BY t.id,t.name,trr.race
) x
GROUP BY x.id, x.name;



SELECT `teamraceresult`.`race`, (select MAX(leaguepoints) AS `points`, `team`.`id`, `team`.`name` FROM `teamraceresult` INNER JOIN
 `team` ON teamraceresult.team=team.id WHERE (teamraceresult.league=5) AND (teamraceresult.class!='W') GROUP BY `team`.`id`, `team`.`name`;

SELECT `teamraceresult`.`race`, (select MAX(leaguepoints)) AS `points`, `team`.`id`, `team`.`name` FROM `teamraceresult`
INNER JOIN `team` ON teamraceresult.team=team.id
WHERE (teamraceresult.league=5) AND (teamraceresult.class!='W') GROUP BY `team`.`id`, `team`.`name`;



SELECT `X`.*, SUM(CASE X.race WHEN 20102 THEN X.points ELSE NULL END) AS sdcc,
SUM(CASE X.race WHEN 20104 THEN X.points ELSE NULL END) AS eircom,
 (SUM(X.points) as total FROM SELECT `teamraceresult`.`race`, (select MAX(leaguepoints)) AS `points`, `team`.`id`, `team`.`name` FROM `teamraceresult`
 INNER JOIN `team` ON teamraceresult.team=team.id WHERE (teamraceresult.league=5) AND (teamraceresult.class!='W')
GROUP BY `team`.`id`, `team`.`name` AS `X` GROUP BY `X`.`id`, `X`.`name`

SELECT `X`.`idname`, SUM(CASE X.race WHEN 20102 THEN X.points ELSE NULL END) AS sdcc,
 SUM(CASE X.race WHEN 20104 THEN X.points ELSE NULL END) AS eircom, (SUM(X.points) as total FROM
SELECT `teamraceresult`.`race`, (select MAX(leaguepoints)) AS `points`, `team`.`id`, `team`.`name` FROM `teamraceresult`
INNER JOIN `team` ON teamraceresult.team=team.id WHERE (teamraceresult.league=5) AND (teamraceresult.class!='W')
GROUP BY `team`.`id`, `team`.`name` AS `X` GROUP BY `X`.`id`, `X`.`name`;





SELECT `A`.`id`, `A`.`name`,
sdcc2010, `eircom2010`, `ncf2010`, `airport2010`, `garda2010`,
total - (select count(id) from teamraceresult where team=A.id and class="O") as overall
FROM (SELECT `X`.`id`, `X`.`name`,
SUM(CASE X.race WHEN 20102 THEN X.points ELSE NULL END) as sdcc2010,
SUM(CASE X.race WHEN 20104 THEN X.points ELSE NULL END) as eircom2010,
SUM(CASE X.race WHEN 20106 THEN X.points ELSE NULL END) as ncf2010,
SUM(CASE X.race WHEN 20108 THEN X.points ELSE NULL END) as airport2010,
SUM(CASE X.race WHEN 201010 THEN X.points ELSE NULL END) as garda2010,
(SUM(X.points)) as total
FROM (
SELECT `teamraceresult`.`race`, (select MAX(leaguepoints)) AS `points`, `team`.`id`, `team`.`name`
FROM `teamraceresult`
INNER JOIN `team` ON teamraceresult.team=team.id
WHERE (teamraceresult.league=5) AND (teamraceresult.class!='W')
GROUP BY `team`.`id`, `team`.`name`,`teamraceresult`.`race`) AS `X`
GROUP BY `X`.`id`, `X`.`name`) AS `A`
ORDER BY `overall` desc


SELECT A.id, A.name,
sdcc, eircom, ncf, airport, garda,
total - (SELECT COUNT(id) FROM teamraceresult WHERE team=A.Id AND class='O') as overall
FROM ( SELECT x.id,x.name,
SUM(CASE x.race WHEN 20102 THEN x.points ELSE NULL END) AS sdcc,
SUM(CASE x.race WHEN 20104 THEN x.points ELSE NULL END) AS eircom,
SUM(CASE x.race WHEN 20106 THEN x.points ELSE NULL END) AS ncf,
SUM(CASE x.race WHEN 20108 THEN x.points ELSE NULL END) AS airport,
SUM(CASE x.race WHEN 201010 THEN x.points ELSE NULL END) AS garda,
SUM(x.points) as total
FROM (
SELECT t.id,t.name,trr.race,MAX(trr.leaguepoints) as points
FROM teamraceresult trr
JOIN team t on trr.team=t.id
WHERE trr.league = 5 and trr.class!='W'
GROUP BY t.id,t.name,trr.race ) x
GROUP BY x.id, x.name ) A
ORDER by overall DESC;



SELECT `A`.`id`, `A`.`name`, `sdcc2010`, 'eircom2010', 'ncf2010', 'airport2010', 'garda2010', total - (select count(id) from teamraceresult where team=A.id and class="O") as overall
FROM (SELECT `X`.`id`, `X`.`name`,
SUM(CASE X.race WHEN 20102 THEN X.points ELSE NULL END) as sdcc2010,
SUM(CASE X.race WHEN 20104 THEN X.points ELSE NULL END) as eircom2010,
SUM(CASE X.race WHEN 20106 THEN X.points ELSE NULL END) as ncf2010,
SUM(CASE X.race WHEN 20108 THEN X.points ELSE NULL END) as airport2010,
SUM(CASE X.race WHEN 201010 THEN X.points ELSE NULL END) as garda2010, (SUM(X.points)) as total FROM (SELECT `teamraceresult`.`race`, (select MAX(leaguepoints)) AS `points`, `team`.`id`, `team`.`name` FROM `teamraceresult` INNER JOIN `team` ON teamraceresult.team=team.id WHERE (teamraceresult.league=5) AND (teamraceresult.class!='W')
GROUP BY `team`.`id`, `team`.`name`, `teamraceresult`.`race`) AS `X` GROUP BY `X`.`id`, `X`.`name`) AS `A` ORDER BY `overall` desc

-- simple team race result report
select * from teamraceresult where team=49;

select race,event.tag,
runnerfirst,
(select CONCAT(runner.firstname,' ',runner.surname) from runner where runner.id = runnerfirst) as r1sn,
runnersecond,
(select CONCAT(runner.firstname,' ',runner.surname) from runner where runner.id = runnersecond) as r2sn,
runnerthird,
(select CONCAT(runner.firstname,' ',runner.surname) from runner where runner.id = runnerthird) as r3sn,
standardtotal,positiontotal,class,leaguepoints
from teamraceresult
join race on race.id=teamraceresult.race
join event on event.id = race.event
where team=49;

-- issue 404
select 
getTeamStandardQuartile(1,201202) as 'Q1',
getTeamStandardQuartile(2,201202) as 'Q2',
getTeamStandardQuartile(3,201202) as 'Q3',
getTeamStandardQuartile(4,201202) as 'Q4';

select x.class, avg(x.mintotal), avg(x.maxtotal)
from
(
select race, class, Min(standardTotal) as mintotal, Max(standardTotal) as maxtotal 
from teamraceresult
where race between 201100 and  201299  and Class='B'
group by race,class
) x;

-- select min, max and quartile for some races in 2011
select DISTINCT(race.id),event.tag,
(select Min(standardTotal) from teamraceresult where teamraceresult.race=race.id and Class='A' group by race,class) as Amin,
(select Max(standardTotal) from teamraceresult where teamraceresult.race=race.id and Class='A' group by race,class) as Amax,
getTeamStandardQuartile(1,race.id) as 'AQ1',
(select Min(standardTotal) from teamraceresult where teamraceresult.race=race.id and Class='B' group by race,class) as Bmin,
(select Max(standardTotal) from teamraceresult where teamraceresult.race=race.id and Class='B' group by race,class) as Bmax,
getTeamStandardQuartile(2,race.id) as 'BQ2',
(select Min(standardTotal) from teamraceresult where teamraceresult.race=race.id and Class='C' group by race,class) as Cmin,
(select Max(standardTotal) from teamraceresult where teamraceresult.race=race.id and Class='C' group by race,class) as Cmax,
getTeamStandardQuartile(3,race.id) as 'CQ3',
(select Min(standardTotal) from teamraceresult where teamraceresult.race=race.id and Class='D' group by race,class) as Dmin,
(select Max(standardTotal) from teamraceresult where teamraceresult.race=race.id and Class='D' group by race,class) as Dmax,
getTeamStandardQuartile(4,race.id) as 'DQ4'
from race
join event on event.id=race.event
where race.id between 201100 and 201199 and race.type IN ('M','C') and event.tag NOT IN ("trinity2011","aviva2011","ilp2011","zurich2011");


