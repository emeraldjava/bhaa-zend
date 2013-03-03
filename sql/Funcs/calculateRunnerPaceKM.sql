CREATE FUNCTION `calculateRunnerPaceKM`(_raceTime TIME, _distance DOUBLE, _unit ENUM('KM','Mile')) RETURNS time
BEGIN

SET _distance =
IF (_unit = 'Mile', _distance * 1.609344, _distance);
RETURN  SEC_TO_TIME(TIME_TO_SEC(_raceTime) / _distance);

END
