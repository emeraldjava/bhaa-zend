DROP PROCEDURE `updateResultsByRaceId`//
CREATE DEFINER=`bhaa1`@`localhost` PROCEDURE `updateResultsByRaceId`(_raceId Int)
BEGIN

DECLARE _type enum('C','W','M');
DECLARE _leagueId INT(11);

SET _type = (SELECT type FROM race WHERE id = _RaceId);

SET _leagueId = (SELECT l.id
                    FROM league l
                    JOIN leagueevent le ON l.id = le.league
                    JOIN event e ON le.event = e.id
                    JOIN race r ON e.id = r.event
                    WHERE r.id=_raceId AND l.type='I');

  IF _type = 'C' THEN
    CALL UpdateRacePoints(_raceId,'M');
    CALL UpdateRacePoints(_raceId,'W');
  ELSE
    CALL UpdateRacePoints(_raceId, null);
  END IF;

  UPDATE raceresult, race
  SET raceresult.paceKm = CalculateRunnerPaceKM(raceresult.racetime, race.distance, race.unit)
  WHERE raceresult.race = race.Id AND race.Id = _raceId;


  CALL UpdateLeagueData(_leagueId);

END