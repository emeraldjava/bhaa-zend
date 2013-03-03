DROP TABLE IF EXISTS `team`;
CREATE TABLE IF NOT EXISTS `team` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `type` enum('C','S') NOT NULL,
  `parent` int(11) NOT NULL,
  `contact` int(11),
  `status` enum('ACTIVE','PENDING','DEV') default 'DEV',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

ALTER TABLE team DROP COLUMN company;
ALTER TABLE team DROP COLUMN sector;
ALTER TABLE team ADD status enum('ACTIVE','PENDING','DEV') default 'DEV';

select * from team where id=111;
select * from company where name like "%Tri%";

-- set team contacts
update team set contact=9710 where id=94;
update team set contact=8885 where id=204;

-- sector teams per sector
select * from team where name="SAP";
select * from team where status="ACTIVE";

SELECT `team`.`id`, `team`.`name`, `team`.`type`, (select count(runner) from teammember where teammember.team=team.id) AS `members`, `company`.`sector` FROM `team` LEFT JOIN `company` ON team.parent=company.id WHERE ((parent=20 OR company.sector=20))


-- company teams per sector
select distinct(team.name) from team 
left join company on team.parent=company.id
where company.sector=20;

-- select all teams per sector
select * from team 
left join company on team.parent=company.id
where (parent=20 OR company.sector=20);

select team.id, team.name, team.type,
(select count(runner) from teammember where teammember.team=team.id) as members
from team 
left join company on team.parent=company.id
where (parent=20 OR company.sector=20);

select * from team 
join company on team.parent=company.sector
where parent=20;


-- select empty teams
select team.*
from team
left join teammember on team.id = teammember.team
where teammember.runner is null;

-- delete empty teams
delete team.* from team left join teammember on team.id = teammember.team where teammember.runner is null;

delete from team where id=0;
delete from team where id=48;
delete from team where id=49;
delete from teammember where team=0;
delete from teammember where team=48;
delete from teammember where team=49;

select id,name from team as team 
join teammember as teamember on t.id=teammeber.team
where (count(teammember.runner))>1;

-- count the size of teams
select id, name, count(tm.runner) as c,status,type as t from team as team
JOIN teammember tm ON team.id = tm.team
WHERE team.status="DEV" AND type="C"
GROUP BY tm.team
HAVING count(tm.runner) >=3;

select id,name from team where id in(61,65,67,111,166,247,388,434,670,679,939,941);
update team set status="ACTIVE" where id in(61,65,67,111,166,247,388,434,670,679,939,941);

describe team

update team set name="BML" where id=482;
update team set contact=5101 where id=175;

ALTER TABLE team ADD parent int(11) NOT NULL AFTER type; 
UPDATE team set parent=id where id<=50;
UPDATE team set parent=company where id>=50;
delete from team where id=1000;
delete from team where id=1001;
delete from team where id=493;
update team set parent=20 where id=6;
update team set parent=20 where id=37;
update team set parent=20 where id=43;
update team set parent=4 where id=44;
update team set parent=1 where id=21;
update team set parent=30 where id=27;
update team set parent=12 where id=42;
update team set parent=17 where id=35;
UPDATE team set company=0,sector=0;

select * from team join sector on team.parent=sector.id where sector.valid='N';

--colleges to education
update team set sector=12 where company=913;
update team set sector=12 where company=140;
update team set sector=12 where company=111;
update team set sector=12 where company=256;

-- move undefined teams
-- zurich, axa, hib
update team set sector=19 where company=175;
update team set sector=19 where company=71;
update team set sector=19 where company=134;
-- banking: boi
update team set sector=3 where company=161;
update team set sector=3 where company=100;
update team set sector=3 where company=84;
-- media: rte
update team set sector=25 where company=121;
-- telecoms: eircom
update team set sector=33 where company=110;
-- it : intel, norkom
update team set sector=20 where company=158;
update team set sector=20 where company=939;
-- transport : dub bus, aer lin
update team set sector=34 where company=91;
update team set sector=34 where company=67;

select company from runner where company=team and status="M";

select * from runner where company=0 and status="M";
select * from runner where team=0 and status="M";

select * from company where id=50;
select * from sector where id=50;

select * from team;
-- insert sector team
insert into team select id,name,'S',null,id,null from sector where id<50;
insert into team select id,name,'C',id,sector,null from company where id>=50;

select id, call migrateteam(id) from team where status="ACTIVE";

select * from team where status="ACTIVE";

select id,name,(select count(runner) from teammember where team=id) as runners from
team where status="ACTIVE" ORDER by count;

select id, name, count(tm.runner) as runners from team as team
JOIN teammember tm ON team.id = tm.team
WHERE team.status="ACTIVE" AND type="C"
GROUP BY tm.team
HAVING count(tm.runner) >=1 ORDER by runners desc;


SELECT
  r.id,
  CONCAT(r.firstname, ' ', r.surname) AS runnername,
  COUNT(rr.race) as racesrun,
  SUM(CASE le.event WHEN 20101 THEN 1 ELSE NULL END) AS E1, #teachers
  SUM(CASE le.event WHEN 20102 THEN 1 ELSE NULL END) AS E2, #BOI
  SUM(CASE le.event WHEN 20103 THEN 1 ELSE NULL END) AS E3, #NSRT
  SUM(CASE le.event WHEN 20104 THEN 1 ELSE NULL END) AS E4  #Data Sol
FROM runner r
JOIN teammember tm on r.id=tm.runner
JOIN team t on tm.team = t.id
JOIN raceresult rr ON r.id=rr.runner
JOIN race ra on rr.race=ra.id
JOIN leagueevent le on ra.event=le.event
WHERE r.status = 'M'
AND t.id =93
AND le.league=5
GROUP BY r.id,runnername
ORDER BY racesrun DESC;


select name, contact, runner.email from team
join runner on runner.id=team.contact
where contact IS NOT NULL;


SELECT
  r.id,
  CONCAT(r.firstname, ' ', r.surname) AS runnername,
  COUNT(rr.race) as racesrun,
  SUM(CASE le.event WHEN 23 THEN 1 ELSE NULL END) AS E1, #teachers
  SUM(CASE le.event WHEN 24 THEN 1 ELSE NULL END) AS E2, #BOI
  SUM(CASE le.event WHEN 25 THEN 1 ELSE NULL END) AS E3, #NSRT
  SUM(CASE le.event WHEN 26 THEN 1 ELSE NULL END) AS E4  #Data Sol
FROM runner r
JOIN teammember tm on r.id=tm.runner
JOIN team t on tm.team = t.id
JOIN raceresult rr ON r.id=rr.runner
JOIN race ra on rr.race=ra.id
JOIN leagueevent le on ra.event=le.event
WHERE r.status = 'M'
AND t.id =93
AND le.league=4
GROUP BY r.id,runnername
ORDER BY racesrun DESC;


SELECT
  r.id,
  CONCAT(r.firstname, ' ', r.surname) AS runnername,
  COUNT(rr.race) as racesrun,
  SUM(CASE le.event WHEN 20101 THEN 1 ELSE NULL END) AS E1, #teachers
  SUM(CASE le.event WHEN 20102 THEN 1 ELSE NULL END) AS E2, #BOI
  SUM(CASE le.event WHEN 20103 THEN 1 ELSE NULL END) AS E3, #NSRT
  SUM(CASE le.event WHEN 20104 THEN 1 ELSE NULL END) AS E4  #Data Sol
FROM runner r
JOIN teammember tm on r.id=tm.runner
JOIN team t on tm.team = t.id
JOIN raceresult rr ON r.id=rr.runner
JOIN race ra on rr.race=ra.id
JOIN leagueevent le on ra.event=le.event
WHERE r.status = 'M'
AND le.event >= 2010
AND t.id = 93
GROUP BY r.id,runnername
ORDER BY racesrun DESC;



