DROP FUNCTION `getActualRunnerTime`//
CREATE DEFINER=`bhaa1`@`localhost` FUNCTION `getActualRunnerTime`(_raceId INT, _runnerId INT) RETURNS time
BEGIN
  declare _standard int;
  declare _handicap int;
  declare _racetime time;
  set _standard = (select standard from raceresult where runner = _runnerId and race = _raceId);
  set _racetime = (select racetime from raceresult where runner = _runnerId and race = _raceId);
  set _handicap = (select (maxstandard - _standard) * secondshandicap from staggeredhandicap where race = _raceId);
  return SEC_TO_TIME(TIME_TO_SEC(_racetime) - _handicap);
END
