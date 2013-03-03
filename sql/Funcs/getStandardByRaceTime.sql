CREATE FUNCTION `getStandardByRaceTime`(_raceTime TIME, _distance DOUBLE, _unit ENUM('KM','Mile')) RETURNS int(11)
BEGIN

DECLARE _racePace TIME;
DECLARE _postRaceStandard INT(11);

SET _racePace = (SELECT CalculateRunnerPaceKm(_raceTime, _distance, _unit));

CREATE TEMPORARY TABLE tmpStandardPaces
AS
SELECT
sd.Standard,
SEC_TO_TIME(
ABS(
  (
    (GetRaceDistanceKm(4, 'Mile') - GetRaceDistanceKM(5, 'Km')) * sd.slopeFactor) -
      TIME_TO_SEC(
        CalculateRunnerPaceKM(sd.fourMileTime, 4, 'Mile')
     )
  )
) AS StandardPace
FROM StandardData sd;

SET _postRaceStandard = (SELECT COALESCE(MAX(Standard), 1) AS PostRaceStandard FROM tmpStandardPaces WHERE standardpace <= _racePace);

DROP TEMPORARY TABLE IF EXISTS tmpStandardPaces;


RETURN _postRaceStandard;
END