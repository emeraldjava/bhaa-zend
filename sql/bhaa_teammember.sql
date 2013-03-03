DROP TABLE IF EXISTS `teammember`;
CREATE TABLE IF NOT EXISTS `teammember` (
  `team` int(11) NOT NULL,
  `runner` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- populate company team members
select * from runner where company=team and status="M" and company>50;
insert into teammember select company,id from runner where company=team and status="M" and company>50;

-- populate sector team members
select * from runner where company!=team and status="M" and company>50;
insert into teammember select team,id from runner where company!=team and status="M" and company>50;

select count(distinct(team)) from teammember;
select count(distinct(runner)) from teammember;

-- ordered list of teams
select * from teammember order by team asc;

-- migrate company logic
delete from teammember where team=93;
select * from teammember where team=93;

INSERT INTO teammember(team,runner)
SELECT team.id, runner.id
FROM runner
JOIN team on team.id=runner.company
WHERE team.id=93
AND team.status="ACTIVE"
AND runner.status="M"
AND runner.id NOT IN (SELECT runner FROM teammember WHERE runner.company=team.id);


-- pre/post checks on company size
select distinct(team.id),team.name,
(select count(runner) from teammember where teammember.team=team.id) as members
from team
join teammember on team.id = teammember.team
where team.status="ACTIVE"
order by team.id;

-- list teams, runners and unlinked runners
select distinct(team.id),team.name,
(select count(runner) from teammember where teammember.team=team.id) as members,
(select count(id) from runner where runner.company=team.id and runner.status="M") as runner
from team
join teammember on team.id = teammember.team
where team.status="ACTIVE"
AND team.type="C"
order by team.id;

select id,firstname,surname,
 (select count(race) from raceresult where raceresult.runner=runner.id and raceresult.race>2010) as count from runner
join teammember on teammember.runner=runner.id
where teammember.team=53;



