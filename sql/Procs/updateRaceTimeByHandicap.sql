DROP PROCEDURE `updateRaceTimeByHandicap`//
CREATE DEFINER=`bhaa1`@`localhost` PROCEDURE `updateRaceTimeByHandicap`(_eventId INT)
BEGIN
  update raceresult rr
  join race ra on rr.race = ra.id
  join event e on ra.event = e.id
  join staggeredhandicap sh on ra.id = sh.race
  set rr.racetime = SEC_TO_TIME(TIME_TO_SEC(rr.racetime) - ((sh.maxstandard - rr.standard) * sh.secondshandicap))
  where e.id = _eventId;
END
