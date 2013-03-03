DROP PROCEDURE `addScoringMensTeams`//
CREATE PROCEDURE `addScoringMensTeams`(_leagueId INT, _raceId INT)
BEGIN
DECLARE _mostRunnerCount INT;

CREATE TEMPORARY TABLE usedrunners(id INT);

INSERT INTO usedrunners
SELECT runnerFirst FROM teamraceresult WHERE race=_raceId and status='ACTIVE'
UNION
SELECT runnerSecond FROM teamraceresult WHERE race=_raceId and status='ACTIVE'
UNION
SELECT runnerThird FROM teamraceresult WHERE race=_raceId and status='ACTIVE';


SET _mostRunnerCount =
(
SELECT count(t.id) as runnerCount
FROM   raceresult rr
JOIN   runner r ON rr.runner = r.id
JOIN   teammember tm ON r.id = tm.runner
JOIN   team t ON tm.team = t.id
JOIN   race ra ON rr.race = ra.id
JOIN   event e ON ra.event = e.id
WHERE  rr.race=_raceId
AND t.status='ACTIVE'
AND r.Status='M'
AND rr.Standard IS NOT NULL
AND r.dateofrenewal <= e.date
AND t.formationdate <= e.date
AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
AND r.id NOT IN (SELECT id FROM usedrunners)
GROUP BY t.id
HAVING runnerCount >=3
ORDER by runnerCount DESC
LIMIT 1
);

DROP TABLE usedrunners;
IF _mostRunnerCount >= 3 THEN
CALL addScoringMensTeamsByRunnerCount(_leagueId,_raceId,3);
END IF;

IF _mostRunnerCount >= 6 THEN
CALL addScoringMensTeamsByRunnerCount(_leagueId,_raceId,6);
END IF;


IF _mostRunnerCount >= 9 THEN
CALL addScoringMensTeamsByRunnerCount(_leagueId,_raceId,9);
END IF;


IF _mostRunnerCount >= 12 THEN
CALL addScoringMensTeamsByRunnerCount(_leagueId,_raceId,12);
END IF;


IF _mostRunnerCount >= 15 THEN
CALL addScoringMensTeamsByRunnerCount(_leagueId,_raceId,15);
END IF;


IF _mostRunnerCount >= 18 THEN
CALL addScoringMensTeamsByRunnerCount(_leagueId,_raceId,18);
END IF;


IF _mostRunnerCount >= 21 THEN
CALL addScoringMensTeamsByRunnerCount(_leagueId,_raceId,21);
END IF;


END
