ALTER PROCEDURE `addRaceOrganiser`(_league INT, _race INT, _runner INT)
MAIN_BLOCK:BEGIN

DECLARE _points DOUBLE;
DECLARE _pointsTotal DOUBLE;

IF EXISTS (SELECT runner FROM raceresult WHERE race=_race AND runner=_runner AND class='RACE_ORG') THEN
	LEAVE MAIN_BLOCK;
END IF;

IF EXISTS (SELECT runner FROM raceresult WHERE race=_race AND runner=_runner AND class='RAN') THEN
	LEAVE MAIN_BLOCK;
END IF;

IF EXISTS (SELECT id FROM runner WHERE status <> 'M' AND id = _runner) THEN
	SET _points = 0;
ELSE
	SET _points = 11;
END IF;

INSERT INTO raceresult(race,runner,company,companyname, points,class)
SELECT _race, _runner, r.company, c.name, _points, 'RACE_ORG'
FROM runner r
LEFT JOIN company c ON r.company = c.id
WHERE r.id = _runner;

SET _pointsTotal = getLeaguePointsTotal(_league, _runner);

UPDATE leaguerunnerdata
SET pointsTotal = _pointsTotal
WHERE league=_league and runner=_runner;


END MAIN_BLOCK