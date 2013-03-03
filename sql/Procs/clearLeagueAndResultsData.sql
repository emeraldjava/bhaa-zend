CREATE PROCEDURE `clearLeagueAndResultsData`(_leagueId INT(11))
BEGIN

UPDATE raceresult, race, event, leagueevent
SET raceresult.paceKm = NULL, raceresult.points = NULL, raceresult.postRaceStandard = NULL
WHERE raceresult.race = race.Id 
AND race.event = event.Id 
AND event.Id=leagueevent.event 
AND leagueevent.league=_leagueId;

DELETE FROM leaguerunnerdata WHERE league=_leagueId;

END
