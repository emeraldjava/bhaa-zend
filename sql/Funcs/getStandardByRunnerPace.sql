CREATE FUNCTION `getStandardByRunnerPace` (_raceId INT, _runnerId INT) RETURNS INT
BEGIN



DECLARE _raceDistance DOUBLE;
DECLARE _raceDistanceKM DOUBLE;
DECLARE _raceUnit ENUM('KM','Mile');
DECLARE _runnerPace TIME;
DECLARE _actualStandard INT;


SET _raceDistance = (SELECT distance FROM race WHERE id = _raceId);
SET _raceUnit = (SELECT unit FROM race WHERE id = _raceId);
SET _runnerPace = (SELECT paceKM FROM raceresult WHERE race = _raceId AND runner = _runnerId AND class='RAN');
SET _raceDistanceKM = (SELECT getRaceDistanceKM(_raceDistance, _raceUnit));

SET _actualStandard  =
(
SELECT
standard
FROM
(
SELECT
standard,
SEC_TO_TIME((oneKmTimeInSecs + (_raceDistanceKM * slopefactor))* _raceDistanceKM) as perdictedtime
from standard
) t
where calculateRunnerPaceKM(t.perdictedtime, _raceDistance , _raceUnit)  >= _runnerPace
limit 1
);

RETURN _actualStandard;

END

