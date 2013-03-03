DROP TABLE IF EXISTS `runner`;
CREATE TABLE IF NOT EXISTS `runner` (
  `id` int(11) NOT NULL auto_increment,
  `surname` varchar(30) NOT NULL,
  `firstname` varchar(30) NOT NULL,
  `gender` enum('M','W') NOT NULL,
  `standard` int(11) default NULL,
  `dateOfBirth` date NOT NULL,
  `company` int(11) default NULL,
  `team` int(11) default NULL,
  `email` varchar(50) NOT NULL,
  `telephone` varchar(50) NOT NULL,
  `address` varchar(50) default NULL,
  `status` enum('M','D','I') default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10001 ;

describe runner;

delete from runner where status="PRE_REG";

ALTER TABLE runner CHANGE COLUMN status status enum('M','D','I','LINKED') DEFAULT NULL;


ALTER TABLE runner CHANGE COLUMN address address1 VARCHAR(50);
ALTER TABLE runner CHANGE COLUMN dateOfBirth dateofbirth DATE;

select id, dateofrenewal, (CASE (dateofrenewal >= "2009-09-01") WHEN TRUE THEN "Y" ELSE "N" END)  from runner where id=7713;

select count(id) as t, (select count(id) from runner where insertdate>"2010-01-01") as d from runner;
SELECT (select count(id) from runner) AS `total`,
 (select count(id) from runner where status="M") AS `members`,
 (select count(id) from runner where status="I") AS `inactive`,
(select count(id) from runner where status="D") AS `day`,
 (select NOW()) AS `date` FROM `runner`

select * from runner where company=1020;
update runner set team=company where company=1020;
-- issue 32
ALTER TABLE runner ADD COLUMN insertdate date default NULL AFTER status;
update runner set insertdate="2008-01-01" where status="I";
update runner set insertdate="2009-01-01" where status="M";
ALTER TABLE runner ADD COLUMN renewaldate date default NULL AFTER insertdate;

ALTER TABLE runner ADD COLUMN address2 varchar(50) default NULL AFTER address;
ALTER TABLE runner ADD COLUMN address3 varchar(50) default NULL AFTER address2;
ALTER TABLE runner ADD COLUMN extra varchar(50) default NULL AFTER address3;
update runner set extra=address;
update runner set address = "";
--UPDATE runner SET extra = address;# Affected rows: 4655
--UPDATE runner SET address = "";# Affected rows: 733

ALTER TABLE runner ADD COLUMN newsletter enum('Y','N') default 'N' AFTER email;
ALTER TABLE runner ADD COLUMN mobilephone varchar(20) default NULL AFTER telephone;
ALTER TABLE runner ADD COLUMN textmessage enum('Y','N') default 'N' AFTER mobilephone;
ALTER TABLE runner ADD COLUMN volunteer enum('Y','N') default 'N' AFTER extra;

--CREATE FULLTEXT INDEX telephone USING BTREE ON runner (telephone);
--select id,telephone from runner WHERE MATCH (telephone) AGAINST ('"086" "087" "085"');
--select id, telephone,MATCH (telephone) AGAINST ('086' in boolean mode) from runner;

-- runner team mapping
select * from runner where id<=1040;
delete from runner where id<=1040;

select * from runner where id=7713;

select count(id) from runner where company!=team and status="M";
select * from runner where company >900;
select * from runner where ru

select count(distinct(runner)) from raceresult where runner<=100000;

-- change the gender for ladies to 'W' to match the leagues
ALTER TABLE runner MODIFY gender ENUM('M','W') DEFAULT 'M' NOT NULL;
UPDATE runner set gender="W" where gender="F";

UPDATE runner set gender="W" where gender=""
select * from runner where id=5143;

select * from raceresult where race=35;
update raceresult as rr set standard=(select standard from runner where runner.id=rr.runner)
where rr.race=35;

select * from runner where id=7713;
select * from runner where id>=7700 and id<=7800;
-- 3310 total members
select count(id) from runner;

-- 629 members with results
select count(id) from runner where exists (select runner from raceresult where id=runner);

describe runner;
-- add new column
ALTER TABLE runner ADD COLUMN status ENUM('M','D','I');
update runner set status='M' where exists (select runner from raceresult where id=runner);
update runner set status='I' where status is NULL;

SELECT `runner`.`id`, `runner`.`surname`, `runner`.`firstname`, `runner`.`gender`, `runner`.`standard`, `runner`.`dateofbirth`, `company`.`name`,`team`.`name`
FROM `runner`
INNER JOIN `company` ON runner.company = company.id
RIGHT OUTER JOIN `team` ON runner.team=team.id
WHERE (runner.status='M')  ORDER BY `surname`;

SELECT `runner`.`id`, `runner`.`surname`, `runner`.`firstname`, `runner`.`gender`, `runner`.`standard`, `runner`.`dateofbirth`,
(select nme from company where runner.company=company.id) as company,
(select name from team where runner.team=team.id) as team
FROM `runner`
WHERE (runner.status='M')  ORDER BY `surname`;

-- correct reg emails
select * from runner where email="registrar@bhaa.ie";
update runner set email="",newsletter="N" where email="registrar@bhaa.ie";

-- clear zero standards
select * from runner where standard = 0;
update runner set standard = NULL where standard=0;

SELECT count(r.id) as dupscount, firstname,surname,dateofbirth, status
from runner r
group by firstname,surname,dateofbirth, status
having count(r.id) > 1 and status='M';

-- company check
select id,firstname,surname,standard,dateofrenewal,status from runner
where company=110
and dateofrenewal>="2009-09-01";

-- standard check
select * from runner where standard=0;
update runner set standard=NULL where standard=0;
update raceresult set standard=NULL where standard=0;

-- renewal date email query
select email from runner where status="M" and dateofrenewal>"2011-01-01" and dateofrenewal<"2011-09-01" and email !="";
select count(id) from runner where status="M" and dateofrenewal>"2011-01-01" and dateofrenewal<"2011-09-01" and email !="" and newsletter="Y";

-- membership breakdown
SELECT count(id) AS `total`, 
(select count(id) from runner where status="M") AS `members`, 
(select count(id) from runner where insertdate>="2012-01-01" and dateofrenewal>="2012-01-01") AS `newmembers`, 
(select count(id) from runner where dateofrenewal>="2012-01-01") AS `renewedmembers`,
(select count(id) from runner where dateofrenewal>="2011-09-01") AS `septmembers`,
(select count(id) from runner where status="I") AS `inactive`,
(select count(id) from runner where status="D") AS `day`,
(select NOW()) AS `date` FROM `runner`

-- orphaned runners
select count(r.id)
from runner r
left join raceresult rr on r.id=rr.runner
where status='d' and rr.runner is null;

select r.id,r.firstname,r.surname
from runner r
left join raceresult rr on r.id=rr.runner
where status='d' and rr.runner is null;

delete r
from runner r
left join raceresult rr on r.id=rr.runner
where status='d' and rr.runner is null;

CALL getMatchingRunnersByEvent(201202);

-- add companyname column to runner so we can record day member details.
ALTER TABLE runner ADD COLUMN companyname VARCHAR(50) DEFAULT NULL AFTER company;
update runner 
left join company on company.id=runner.company
set runner.companyname=company.name 
where runner.company !=0;
select id,company,name from runner left join company on company.id=runner.company where company !=0;
select distinct(company) from runner where company !=0;


