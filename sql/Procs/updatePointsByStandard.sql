ALTER PROCEDURE `updatePointsByStandard`(_leagueId INT, _raceId INT, _standard VARCHAR(2), _gender VARCHAR(2))
BEGIN

  DECLARE _minValue INT;
  DECLARE _maxValue INT;
  CREATE TEMPORARY TABLE tmpActualRaceResult(ActualPosition INT PRIMARY KEY AUTO_INCREMENT, runnerId INT, racePosition INT);

  SET _minValue = (SELECT d.min FROM division d WHERE d.code = _standard);
  SET _maxValue = (SELECT d.max FROM division d WHERE d.code = _standard);

  IF _gender IS NULL THEN

    INSERT INTO tmpActualRaceResult(runnerId, racePosition)
    SELECT rr.runner, rr.position
    FROM raceresult rr
    JOIN leaguerunnerdata lrd ON rr.runner = lrd.runner
    WHERE rr.race = _raceId
    AND lrd.league = _leagueId
    AND rr.class='RAN'
    AND lrd.standard BETWEEN _minValue AND _maxValue
    ORDER BY rr.position;

  ELSE

    INSERT INTO tmpActualRaceResult(runnerId, racePosition)
    SELECT rr.runner, rr.position
    FROM raceresult rr
    JOIN runner r ON rr.runner = r.id
    JOIN leaguerunnerdata lrd ON rr.runner = lrd.runner
    WHERE rr.race = _raceId
    AND lrd.league = _leagueId
    AND lrd.standard BETWEEN _minValue AND _maxValue
    AND r.Gender= _gender
    AND rr.class='RAN'
    ORDER BY rr.position;

  END IF;

  UPDATE raceresult rr,tmpActualRaceResult ar
  SET rr.Points = 10.1 - (ar.ActualPosition/10)
  WHERE rr.runner = ar.runnerId AND rr.race = _RaceId;

  DROP TEMPORARY TABLE tmpActualRaceResult;

END