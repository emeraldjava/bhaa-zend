DROP TABLE IF EXISTS `racetec`;
CREATE TABLE IF NOT EXISTS `racetec` (
  `id` int(11) NOT NULL auto_increment,
  `runner` varchar(8),
  `racenumber` int(8) NOT NULL,
  `event` varchar(50) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `gender` enum('M','F') NOT NULL,
  `dateofbirth` date NOT NULL,
  `agecat` varchar(5),
  `standard` varchar(2),
  `address1` varchar(50),
  `address2` varchar(50),
  `address3` varchar(50),
  `email` varchar(50),
  `newsletter` enum('Y','N') default 'N',
  `mobile` varchar(10),
  `textmessage` enum('Y','N') default 'N',
  `companyid` int(8),
  `companyname` varchar(50),
  `teamid` int(8),
  `teamname` varchar(50),
  `type` varchar(10),
  `status` varchar(2),
  `dateofrenewal` date,  
  `last_modified` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

delete from racetec;
SELECT * FROM RACETEC;

ALTER TABLE racetec ADD COLUMN dateofrenewal date AFTER teamname;

SELECT `runner`.*, 
(select id from team where team.id=teammember.team and team.status="ACTIVE") AS `teamid`,
(select name from team where team.id=teammember.team and team.status="ACTIVE") AS `teamname` FROM `runner`
 LEFT JOIN `teammember` ON teammember.runner = runner.id AND teammember.leavedate IS NULL 
 WHERE (status!='D')
 AND (CONCAT(firstname,' ',surname) like '%giblin%')
 
-- COALESE(team.name, company.name, '') as teamorcompany 

SELECT `runner`.* ,team.name as teamname,team.id as teamid,company.name as companyname,company.id as companyid,
(select getAgeCategory(runner.dateofbirth,curdate(),runner.gender,0)) as agecat 
FROM `runner`
LEFT JOIN `teammember` ON teammember.runner = runner.id AND teammember.leavedate IS NULL 
LEFT JOIN team ON teammember.team = team.id AND team.status="ACTIVE"
LEFT JOIN company ON runner.company = company.id
WHERE (runner.status!='D')
AND (CONCAT(firstname,' ',surname) like '%giblin%');

-- after
SELECT `runner`.*, `company`.`name` AS `companyname`, `company`.`id` AS `companyid`, `team`.`name` AS `teamname`, `team`.`id` AS `teamid` FROM `runner`
 LEFT JOIN `teammember` ON teammember.runner = runner.id AND teammember.leavedate IS NULL
 LEFT JOIN `company` ON runner.company = company.id
 LEFT JOIN `team` ON teammember.team = team.id AND team.status="ACTIVE" WHERE (runner.status!='D') AND (CONCAT(firstname,' ',surname) like '%peig%')

SELECT `runner`.* FROM `runner` WHERE (status='D') AND (CONCAT(firstname,' ',surname) like '%stoke%')
 
-- event/race details
-- future event
SELECT `event`.*, 
(select id from race where race.event=event.id and race.type IN ('C','W') limit 1) AS `womensrace`, 
(select id from race where race.event=event.id and race.type IN ('C','M') limit 1) AS `mensrace` FROM `event` 
WHERE (date > now()) ORDER BY `date` asc LIMIT 1

SELECT event.id,event.name,event.tag,race.id,race.distance
from event
left join race on race.event=event.id
WHERE (date > now()) ORDER BY `date` asc LIMIT 2

select * from race where event=201202;

SELECT `event`.* FROM `event` WHERE (date > now()) ORDER BY `date` asc LIMIT 1

