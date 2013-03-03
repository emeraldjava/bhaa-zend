CREATE PROCEDURE `updateResultsByCombinedRaceId`(_RaceId Int, out _rc Int)
updatePoints:BEGIN

DECLARE _leagueId INT(11);

  SET _rc = 0;

  SET _leagueId = (SELECT l.id
                    FROM league l
                    JOIN leagueevent le ON l.id = le.league
                    JOIN event e ON le.event = e.id
                    JOIN race r ON e.id = r.event
                    WHERE r.id=_raceId AND l.type='I');


  INSERT INTO leaguerunnerdata(league,runner, racesComplete, pointsTotal,avgOverallPosition, standard)
  SELECT _leagueId, r.id, 0, 0, 0, rr.standard
  FROM runner r
  JOIN raceresult rr ON r.id = rr.runner
  WHERE rr.race = _RaceId
  AND r.status ='M'
  AND rr.class = 'RAN'
  AND rr.standard IS NOT NULL
  AND r.id NOT IN (SELECT DISTINCT runner FROM leaguerunnerdata WHERE league = _leagueId);

      CALL UpdatePointsByStandard(_leagueId, _RaceId,'A','M');

      CALL UpdatePointsByStandard(_leagueId, _RaceId,'B','M');

      CALL UpdatePointsByStandard(_leagueId, _RaceId,'C','M');

      CALL UpdatePointsByStandard(_leagueId, _RaceId,'D','M');

      CALL UpdatePointsByStandard(_leagueId, _RaceId,'E','M');

      CALL UpdatePointsByStandard(_leagueId, _RaceId,'F','M');

      CALL UpdatePointsByStandard(_leagueId, _RaceId,'L1','W');

      CALL UpdatePointsByStandard(_leagueId, _RaceId,'L2','W');

  UPDATE raceresult, race
  SET raceresult.paceKM = calculateRunnerPaceKM(raceresult.raceTime, race.distance, race.Unit)
  WHERE raceresult.race = race.Id AND race.Id = _raceId;

    UPDATE raceresult, race
  SET raceresult.postRaceStandard = getStandardByRaceTime(raceresult.raceTime, race.distance, race.Unit)
  WHERE raceresult.race = race.Id AND race.Id = _raceId;


    CALL UpdateLeagueData(_leagueId, _raceId);
END 