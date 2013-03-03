DROP PROCEDURE `updatePaceByRaceId`//
CREATE PROCEDURE `updatePaceByRaceId`(_raceId INT(11))
BEGIN

UPDATE raceresult, race
SET raceresult.paceKm = CalculateRunnerPaceKM(raceresult.racetime, race.distance, race.unit)
WHERE raceresult.race = race.Id AND race.Id = _raceId;



UPDATE raceresult, race
SET
raceresult.normalisedPaceKm = CalculateRunnerNormalisedPaceKM(raceresult.paceKm, raceresult.standard, race.distance, race.unit)
WHERE raceresult.race = race.Id AND race.Id = _raceId;

END
