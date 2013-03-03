CREATE PROCEDURE `clearEventResultsData`(_eventId INT(11))
BEGIN

UPDATE raceresult, race, event
SET raceresult.paceKm = NULL, raceresult.points = NULL, raceresult.postRaceStandard = NULL
WHERE raceresult.race = race.Id
AND race.event = _eventId
AND raceresult.class = 'RAN';

END