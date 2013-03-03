DROP PROCEDURE `updateResultsByEvent`//
CREATE PROCEDURE `updateResultsByEvent`(_leagueId Int, _eventName varchar(100), _distance Double, _unit ENUM('KM','Mile'))
BEGIN

DECLARE _type enum('C','W','M');
DECLARE _idToProcess INT(11);
DECLARE _rc INT;
SET _idToProcess = (SELECT r.id
                    FROM race r, event e, leagueevent le 
WHERE r.event=e.id AND e.id = le.event AND e.name=_eventName AND r.distance=_distance AND r.unit=_unit AND le.league=_leagueId);

SET _type = (SELECT type FROM race where id = _idToProcess);


IF _type = 'C' THEN
CALL updateResultsByCombinedRaceId(_idToProcess , _rc);
ELSE
CALL updateResultsByRaceId(_idToProcess , _rc);
END IF;
END