DROP PROCEDURE `updateTrackPointsByStandard`//
CREATE PROCEDURE `updateTrackPointsByStandard`(_leagueid INT, _eventId INT, _standard VARCHAR(2), _gender VARCHAR(2))
BEGIN

  DECLARE _minValue INT;
  DECLARE _maxValue INT;
  CREATE TEMPORARY TABLE tmpActualRaceResult(ActualPosition INT PRIMARY KEY AUTO_INCREMENT, runnerId INT, raceId INT, racePosition INT);

  SET _minValue = (SELECT d.min FROM division d WHERE d.code = _standard);
  SET _maxValue = (SELECT d.max FROM division d WHERE d.code = _standard);

  INSERT INTO tmpActualRaceResult(runnerId, raceId, racePosition)
    SELECT rr.runner, rr.race, rr.position
    FROM raceresult rr
    JOIN runner r ON rr.runner=r.id
    JOIN leaguerunnerdata lrd ON r.id = lrd.runner
    WHERE lrd.standard BETWEEN _minValue AND _maxValue  AND r.Gender= _gender
    AND lrd.league = _leagueid
    AND  rr.race in (SELECT id FROM race WHERE event = _eventId)
    ORDER BY rr.position;



  UPDATE raceresult rr,tmpActualRaceResult ar
  SET rr.Points = 10.1 - (ar.ActualPosition/10)
  WHERE rr.runner = ar.runnerId AND rr.race = ar.raceId;




  DROP TEMPORARY TABLE tmpActualRaceResult;

END