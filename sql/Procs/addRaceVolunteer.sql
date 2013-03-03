ALTER PROCEDURE `addRaceVolunteer`(_league INT, _race INT, _runner INT)
MAIN_BLOCK:BEGIN

IF EXISTS (SELECT runner FROM raceresult WHERE race=_race AND runner=_runner AND class='RACE_VOL') THEN
	LEAVE MAIN_BLOCK;
END IF;

IF EXISTS (SELECT runner FROM raceresult WHERE race=_race AND runner=_runner AND class='RAN') THEN
	LEAVE MAIN_BLOCK;
END IF;


INSERT INTO raceresult(race,runner,company,companyname, points,class)
SELECT _race, _runner, r.company, c.name, 0, 'RACE_VOL'
FROM runner r
LEFT JOIN company c ON r.company = c.id
WHERE r.id = _runner;


END