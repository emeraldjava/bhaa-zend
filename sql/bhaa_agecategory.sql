DROP TABLE IF EXISTS `agecategory`;
CREATE TABLE IF NOT EXISTS `agecategory` (
    id INTEGER NOT NULL AUTO_INCREMENT,
    category VARCHAR(4),
    code VARCHAR(2),
    gender ENUM("M","W") DEFAULT "M",
    min INTEGER NOT NULL,
    max INTEGER NOT NULL,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8;

select getAgeCategory("1977-11-18","2010-01-23","M",1);
call getAgeCategory("1977-11-18","2010-01-23","M",1);

INSERT INTO agecategory VALUES (NULL,"SM","S","M",18,39);
INSERT INTO agecategory VALUES (NULL,"M40","1","M",40,44);
INSERT INTO agecategory VALUES (NULL,"M45","2","M",45,49);
INSERT INTO agecategory VALUES (NULL,"M50","3","M",50,54);
INSERT INTO agecategory VALUES (NULL,"M55","4","M",55,59);
INSERT INTO agecategory VALUES (NULL,"M60","5","M",60,64);
INSERT INTO agecategory VALUES (NULL,"M65","6","M",65,69);
INSERT INTO agecategory VALUES (NULL,"M70","7","M",70,74);
INSERT INTO agecategory VALUES (NULL,"M75","8","M",75,79);
INSERT INTO agecategory VALUES (NULL,"M80","9","M",80,84);
INSERT INTO agecategory VALUES (NULL,"M85","10","M",85,120);
INSERT INTO agecategory VALUES (NULL,"JM","11","M",0,17);
INSERT INTO agecategory VALUES (NULL,"SW","W","W",18,34);
INSERT INTO agecategory VALUES (NULL,"W35","A","W",35,39);
INSERT INTO agecategory VALUES (NULL,"W40","B","W",40,44);
INSERT INTO agecategory VALUES (NULL,"W45","C","W",45,49);
INSERT INTO agecategory VALUES (NULL,"W50","D","W",50,54);
INSERT INTO agecategory VALUES (NULL,"W55","E","W",55,59);
INSERT INTO agecategory VALUES (NULL,"W60","F","W",60,64);
INSERT INTO agecategory VALUES (NULL,"W65","G","W",65,69);
INSERT INTO agecategory VALUES (NULL,"W70","H","W",70,120);
INSERT INTO agecategory VALUES (NULL,"JW","I","W",0,17);

select * from agecategory;

-- list the runners in each age category
select ac.category, 
count(rr.runner) as total
from agecategory as ac
join raceresult rr on rr.category=ac.category
where rr.race=72 group by ac.category order by ac.id;


SELECT `raceresult`.`runner`, `raceresult`.`race`, `raceresult`.`category`, `runner`.`firstname`, `runner`.`surname` FROM `raceresult`
 INNER JOIN `runner` ON runner.id = raceresult.runner WHERE (raceresult.race = '75') AND (runner.gender = 'M') AND (raceresult.category = 'SM') ORDER BY `raceresult`.`position` asc LIMIT 3

SELECT `raceresult`.`category`, `runner`.`id`, `runner`.`firstname`, `runner`.`surname`, `runner`.`company`
FROM `raceresult`
INNER JOIN `runner` ON runner.id = raceresult.runner
WHERE (raceresult.race = '75')
AND (runner.gender = 'M')
AND (raceresult.category = 'SM')
ORDER BY `raceresult`.`position` asc LIMIT 3

--AND (raceresult.position > 3)

select agecategory.category, agecategory.gender, runner.id
from agecategory
INNER JOIN `raceresult` ON raceresult.race = 75
INNER JOIN `runner` ON runner.id = raceresult.runner
AND (runner.gender = 'M')
AND (raceresult.category = 'SM')
ORDER BY `raceresult`.`position` asc LIMIT 3;

SELECT `raceresult`.`category`, `runner`.`id`, `runner`.`firstname`, `runner`.`surname`, `runner`.`company`
FROM `raceresult`
INNER JOIN `runner` ON runner.id = raceresult.runner
WHERE (raceresult.race = '75')
AND (runner.gender = 'M')
AND (raceresult.category = 'SM')
ORDER BY `raceresult`.`position` asc LIMIT 3

-- age category breakdown
select rr.category, count(rr.runner) as amount
from raceresult rr
join race r on rr.race = r.id
join runner ru on rr.runner = ru.id
where r.event = 20103 and ru.gender='M'
group by rr.category
order by amount desc;

select rr.category, count(rr.runner) as amount
from raceresult rr
join race r on rr.race = r.id
join runner ru on rr.runner = ru.id
where r.event >= 2010
group by rr.category
order by amount desc;


select ru.gender, count(rr.runner) as amount
from raceresult rr
join race r on rr.race = r.id
join runner ru on rr.runner = ru.id
where r.event = 20103
group by ru.gender
order by amount desc;


select getAgeCategory('1977-11-18','2020-07-01','M',0) as agecat;

