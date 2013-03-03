DROP TABLE IF EXISTS `staggeredhandicap`;
CREATE TABLE IF NOT EXISTS `staggeredhandicap` (
  `id` int(11) NOT NULL auto_increment,
  `race` int(11) NOT NULL,
  `maxstandard` int(4) NOT NULL,
  `secondshandicap` int(4) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=32;

INSERT into staggeredhandicap VALUES(NULL,201041,10,5);
INSERT into staggeredhandicap VALUES(NULL,201043,13,5);
INSERT into staggeredhandicap VALUES(NULL,201045,16,5);
INSERT into staggeredhandicap VALUES(NULL,201046,16,5);
INSERT into staggeredhandicap VALUES(NULL,201048,25,5);

INSERT into staggeredhandicap VALUES(NULL,201040,10,5);
update staggeredhandicap set secondshandicap=16 where race>=201060;

-- Race 1 : BHAA Members Standards 1-10
INSERT INTO race VALUES(201040,201026,"19:00:00",1,"Mile","BHAA 1-10","./csv/races/2010/aviva_2010.csv","C");

-- original query
SELECT `raceresult`.*, `race`.`distance`, `race`.`unit`, `event`.`racepixs`, `event`.`tag`, `runner`.`id`,
`runner`.`firstname`, `runner`.`surname`, `runner`.`status`, `company`.`id`, `company`.`name` FROM `raceresult`
INNER JOIN `race` ON race.id = raceresult.race
INNER JOIN `event` ON race.event = event.id
INNER JOIN `runner` ON runner.id = raceresult.runner LEFT JOIN `company` ON raceresult.company = company.id
WHERE (raceresult.class in ("RAN","RAN_NO_SCORE")) AND (race.event = 201026)
ORDER BY `raceresult`.`position`,`raceresult`.`race` ASC

SELECT `raceresult`.`race`,`raceresult`.`runner`,`raceresult`.`racetime`,`raceresult`.`standard`, `race`.`distance`,
(staggeredhandicap.maxstandard - raceresult.standard) as diff,
staggeredhandicap.*
FROM `raceresult`
INNER JOIN `race` ON race.id = raceresult.race
INNER JOIN `event` ON race.event = event.id
INNER JOIN `runner` ON runner.id = raceresult.runner
LEFT JOIN `company` ON raceresult.company = company.id
INNER JOIN `staggeredhandicap` ON staggeredhandicap.race = staggeredhandicap.race
WHERE (raceresult.class in ("RAN","RAN_NO_SCORE")) AND (race.event = 201026)
ORDER BY `raceresult`.`position` ASC
