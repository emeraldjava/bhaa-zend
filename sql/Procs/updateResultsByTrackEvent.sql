DROP PROCEDURE `updateResultsByTrackEvent`//
CREATE PROCEDURE `updateResultsByTrackEvent`(_eventId Int)
BEGIN

 DECLARE _nextRaceId INT(11);
 DECLARE _leagueId INT(11);
 DECLARE no_more_rows BOOLEAN;
 DECLARE loop_cntr INT DEFAULT 0;
 DECLARE num_rows INT DEFAULT 0;
 DECLARE _raceCursor CURSOR FOR SELECT id FROM race WHERE event = _eventId;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;


  SET _leagueId = (SELECT l.id
                    FROM league l
                    JOIN leagueevent le ON l.id = le.league
                    JOIN event e ON le.event = e.id
                    WHERE e.id=_eventId AND l.type='I');

INSERT INTO leaguerunnerdata(league,runner, racesComplete, pointsTotal,avgOverallPosition, standard)
  SELECT _leagueId, r.id, 0, 0, 0, r.standard
  FROM runner r
  JOIN raceresult rr ON r.id = rr.runner
  JOIN race ra ON rr.race = ra.id
  WHERE ra.event = _eventId
  AND r.status = 'M'
  AND r.id NOT IN (SELECT DISTINCT runner FROM leaguerunnerdata WHERE league = _leagueId);


    CALL updateTrackPointsByStandard(_leagueId, _eventId,'A','M');

    CALL updateTrackPointsByStandard(_leagueId, _eventId,'B','M');

    CALL updateTrackPointsByStandard(_leagueId, _eventId,'C','M');

    CALL updateTrackPointsByStandard(_leagueId, _eventId,'D','M');

    CALL updateTrackPointsByStandard(_leagueId, _eventId,'E','M');

    CALL updateTrackPointsByStandard(_leagueId, _eventId,'F','M');

    CALL updateTrackPointsByStandard(_leagueId, _eventId,'L1','F');

    CALL updateTrackPointsByStandard(_leagueId, _eventId,'L2','F');

  UPDATE raceresult, race, event
  SET raceresult.paceKM = calculateRunnerPaceKM(raceresult.raceTime, race.distance, race.Unit)
  WHERE raceresult.race = race.Id AND race.event=event.id AND event.id=_eventId;

  UPDATE raceresult, race, event
  SET raceresult.postRaceStandard = getStandardByRaceTime(raceresult.raceTime, race.distance, race.Unit)
  WHERE raceresult.race = race.Id AND race.event=event.id AND event.id=_eventId;


  OPEN _raceCursor;
  SELECT FOUND_ROWS() into num_rows;

  the_loop: LOOP

  FETCH  _raceCursor
  INTO   _nextRaceId;

         IF no_more_rows THEN
        CLOSE _raceCursor;
        LEAVE the_loop;
    END IF;

   CALL UpdateLeagueData(_leagueId, _nextRaceId);

   SET loop_cntr = loop_cntr + 1;

  END LOOP the_loop;

END