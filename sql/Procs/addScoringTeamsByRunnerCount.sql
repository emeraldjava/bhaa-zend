DROP PROCEDURE `addScoringMensTeamsByRunnerCount`//
CREATE PROCEDURE `addScoringMensTeamsByRunnerCount`(_leagueId INT, _raceId INT, _runnerCount INT)
BEGIN
CREATE TEMPORARY TABLE usedrunners(id INT);

INSERT INTO usedrunners
SELECT runnerFirst FROM teamraceresult WHERE race=_raceId and status='ACTIVE'
UNION
SELECT runnerSecond FROM teamraceresult WHERE race=_raceId and status='ACTIVE'
UNION
SELECT runnerThird FROM teamraceresult WHERE race=_raceId and status='ACTIVE';


INSERT INTO teamraceresult(league,race,team,status)
SELECT _leagueId as league, _raceId as race, tm.team, 'PENDING'
FROM   raceresult rr
JOIN   runner r ON rr.runner = r.id
JOIN   teammember tm ON r.id = tm.runner
JOIN   team t ON tm.team = t.id
JOIN   race ra ON rr.race = ra.id
JOIN   event e ON ra.event = e.id
WHERE  rr.race=_raceId
AND rr.standard IS NOT NULL
AND t.status='ACTIVE'
AND r.Status='M'
AND r.dateofrenewal <= e.date
AND t.formationdate <= e.date
AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
AND r.id NOT IN (SELECT id FROM usedrunners)
GROUP BY t.id
HAVING count(t.id) >=_runnerCount;

UPDATE
teamraceresult X,
(
	 SELECT b.team,r.id
	 FROM raceresult rr
	 JOIN runner r on rr.runner = r.id
	 JOIN
	 (
    SELECT MIN(rr.position) AS position,  tm.team
    FROM raceresult rr
    JOIN teammember tm ON rr.runner = tm.runner
    JOIN runner r ON tm.runner = r.id
    JOIN race ra ON rr.race = ra.id
    JOIN event e ON ra.event = e.id
    JOIN team t  ON tm.team=t.id
    LEFT JOIN teamraceresult trr1 on rr.runner = trr1.runnerfirst and trr1.race = _raceId
    LEFT JOIN teamraceresult trr2 on rr.runner = trr2.runnersecond and trr2.race = _raceId
    LEFT JOIN teamraceresult trr3 on rr.runner = trr3.runnerthird and trr3.race = _raceId
    WHERE rr.race=_raceId
    AND rr.standard IS NOT NULL
    AND trr1.runnerfirst IS NULL
    AND trr2.runnersecond IS NULL
    AND trr3.runnerthird IS NULL
    AND r.dateofrenewal <= e.date
    AND t.formationdate <= e.date
    AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
    AND r.id NOT IN (SELECT id FROM usedrunners)
    GROUP BY tm.team
	) b
	USING (position)
	WHERE race=_raceId
) Y
SET X.runnerfirst = Y.id
WHERE X.team=Y.team and X.race=_raceId and X.league=_leagueId and X.runnerfirst IS NULL;

UPDATE
teamraceresult X,
(
	 SELECT b.team,r.id
	 FROM raceresult rr
	 JOIN runner r on rr.runner = r.id
	 JOIN
	 (
    SELECT MIN(rr.position) AS position,  tm.team
    FROM raceresult rr
    JOIN teammember tm ON rr.runner = tm.runner
    JOIN runner r ON tm.runner = r.id
    JOIN race ra ON rr.race = ra.id
    JOIN event e ON ra.event = e.id
    JOIN team t  ON tm.team=t.id
    LEFT JOIN teamraceresult trr1 on rr.runner = trr1.runnerfirst and trr1.race = _raceId
    LEFT JOIN teamraceresult trr2 on rr.runner = trr2.runnersecond and trr2.race = _raceId
    LEFT JOIN teamraceresult trr3 on rr.runner = trr3.runnerthird and trr3.race = _raceId
    WHERE rr.race=_raceId
    AND rr.standard IS NOT NULL
    AND trr1.runnerfirst IS NULL
    AND trr2.runnersecond IS NULL
    AND trr3.runnerthird IS NULL
    AND r.dateofrenewal <= e.date
    AND t.formationdate <= e.date
    AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
    AND r.id NOT IN (SELECT id FROM usedrunners)
    GROUP BY tm.team
	) b
	USING (position)
	WHERE race=_raceId
) Y
SET X.runnersecond = Y.id
WHERE X.team=Y.team and X.race=_raceId and X.league=_leagueId and X.runnersecond IS NULL;

UPDATE
teamraceresult X,
(
	 SELECT b.team,r.id
	 FROM raceresult rr
	 JOIN runner r on rr.runner = r.id
	 JOIN
	 (
    SELECT MIN(rr.position) AS position,  tm.team
    FROM raceresult rr
    JOIN teammember tm ON rr.runner = tm.runner
    JOIN runner r ON tm.runner = r.id
    JOIN race ra ON rr.race = ra.id
    JOIN event e ON ra.event = e.id
    JOIN team t  ON tm.team=t.id
    LEFT JOIN teamraceresult trr1 on rr.runner = trr1.runnerfirst and trr1.race = _raceId
    LEFT JOIN teamraceresult trr2 on rr.runner = trr2.runnersecond and trr2.race = _raceId
    LEFT JOIN teamraceresult trr3 on rr.runner = trr3.runnerthird and trr3.race = _raceId
    WHERE rr.race=_raceId
    AND rr.standard IS NOT NULL
    AND trr1.runnerfirst IS NULL
    AND trr2.runnersecond IS NULL
    AND trr3.runnerthird IS NULL
    AND r.dateofrenewal <= e.date
    AND t.formationdate <= e.date
    AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
    AND r.id NOT IN (SELECT id FROM usedrunners)
    GROUP BY tm.team
	) b
	USING (position)
	WHERE race=_raceId
) Y
SET X.runnerthird = Y.id
WHERE X.team=Y.team and X.race=_raceId and X.league=_leagueId and X.runnerthird IS NULL;

DROP TABLE usedrunners;



END
