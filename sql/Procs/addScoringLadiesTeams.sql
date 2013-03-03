DROP PROCEDURE `addScoringLadiesTeams`//
CREATE PROCEDURE `addScoringLadiesTeams`(_leagueId INT, _raceId INT)
BEGIN


INSERT INTO teamraceresult(league,race,team, class, status)
SELECT _leagueId as league, _raceId as race, tm.team, 'W', 'PENDING'
FROM   raceresult rr
JOIN   runner r ON rr.runner = r.id
JOIN   teammember tm ON r.id = tm.runner
JOIN   team t ON tm.team = t.id
JOIN   race ra ON rr.race = ra.id
JOIN   event e ON ra.event = e.id
WHERE  rr.race=_raceId
AND t.status='ACTIVE'
AND r.Gender = 'W'
AND r.Status='M'
AND r.dateofrenewal <= e.date
AND t.formationdate <= e.date
AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
GROUP BY t.id
HAVING count(t.id) >=3;

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
		JOIN runner r ON rr.runner = r.id
		JOIN   teammember tm ON r.id = tm.runner
    JOIN   team t ON tm.team = t.id
    JOIN   race ra ON rr.race = ra.id
    JOIN   event e ON ra.event = e.id
		JOIN   teamraceresult trr ON t.id=trr.team and trr.race=_raceId and trr.league=_leagueId
		WHERE rr.race=_raceId and r.gender='W'
    AND r.dateofrenewal <= e.date
    AND t.formationdate <= e.date
    AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
		GROUP BY tm.team
	) b
	USING (position)
	WHERE race=_raceId
) Y
SET X.runnerFirst = Y.id
WHERE X.team=Y.team and X.race=_raceId and X.league=_leagueId;

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
		JOIN runner r ON rr.runner = r.id
    JOIN   teammember tm ON r.id = tm.runner
		JOIN team t ON tm.team = t.id
    JOIN   race ra ON rr.race = ra.id
    JOIN   event e ON ra.event = e.id
		JOIN   teamraceresult trr ON t.id=trr.team and trr.race=_raceId and trr.league=_leagueId
		WHERE rr.race=_raceId and r.gender='W' and r.id <> trr.runnerFirst
    AND r.dateofrenewal <= e.date
    AND t.formationdate <= e.date
    AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
    GROUP BY tm.team
	) b
	USING (position)
	WHERE race=_raceId
) Y
SET X.runnerSecond = Y.id
WHERE X.team=Y.team and X.race=_raceId and X.league=_leagueId;

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
		JOIN runner r ON rr.runner = r.id
    JOIN   teammember tm ON r.id = tm.runner
    JOIN team t ON tm.team = t.id
    JOIN   race ra ON rr.race = ra.id
    JOIN   event e ON ra.event = e.id
		JOIN   teamraceresult trr ON t.id=trr.team and trr.race=_raceId and trr.league=_leagueId
		WHERE rr.race=_raceId and r.gender='W'
                   and (r.id <> trr.runnerFirst and r.id <> trr.runnerSecond)
    AND r.dateofrenewal <= e.date
    AND t.formationdate <= e.date
    AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
    GROUP BY tm.team
	) b
	USING (position)
	WHERE race=_raceId
) Y
SET X.runnerThird = Y.id
WHERE X.team=Y.team and X.race=_raceId and X.league=_leagueId;


END
