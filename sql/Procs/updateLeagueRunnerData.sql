ALTER PROCEDURE `updateLeagueRunnerData`(_leagueId INT, _runnerId INT)
BEGIN
DECLARE _raceCount INT;
DECLARE _pointsTotal DOUBLE;
DECLARE _avgOverallPosition DOUBLE;

  SET _raceCount = (SELECT COUNT(rr.race) FROM raceresult rr
                    JOIN race ra ON rr.race = ra.id
                    JOIN event e ON ra.event = e.id
                    JOIN leagueevent le ON e.id = le.event
                    WHERE runner=_runnerId AND le.league=_leagueId  AND class='RAN');

  SET _pointsTotal = getLeaguePointsTotal(_leagueId, _runnerId);

 SET _avgOverallPosition = COALESCE((SELECT AVG(rr.position) FROM raceresult rr
                    JOIN race ra ON rr.race = ra.id
                    JOIN event e ON ra.event = e.id
                    JOIN leagueevent le ON e.id = le.event
                    WHERE runner=_runnerId AND le.league=_leagueId), 0);


  IF EXISTS (SELECT runner FROM leaguerunnerdata WHERE league=_leagueId AND runner=_runnerId) THEN
     UPDATE leaguerunnerdata
     SET pointsTotal = _pointsTotal,
         racesComplete = _raceCount,
         avgOverallPosition = _avgOverallPosition
     WHERE league=_leagueId AND runner=_runnerId;
  ELSE
    INSERT INTO leaguerunnerdata(league,runner,racesComplete, pointsTotal,avgOverallPosition)
    VALUES (_leagueId, _runnerId, _raceCount, _pointsTotal, _avgOverallPosition);
  END IF;

END