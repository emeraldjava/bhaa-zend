
CREATE PROCEDURE `updateResultsWithNonScores`(_eventid INT)
BEGIN



UPDATE raceresult rr
JOIN race ra ON rr.race=ra.id
JOIN
(SELECT rr.runner, count(rr.race) as racecount
FROM raceresult rr
JOIN race ra ON rr.race=ra.id
JOIN runner ru ON rr.runner = ru.id
WHERE ru.standard IS NOT NULL AND ru.status='M'
AND ra.event=_eventid
GROUP BY rr.runner
HAVING racecount>1) t ON rr.runner=t.runner
SET rr.class='RAN_NO_SCORE'
WHERE ra.event=_eventid;

UPDATE raceresult rr
JOIN race ra ON rr.race=ra.id
JOIN
(SELECT min(t.position) as bestfinish, t.race as bestrace, t.runner
FROM
(
SELECT max(rr_inner.race) as race, rr_inner.runner, rr_inner.position
FROM raceresult rr_inner
JOIN race r_inner ON rr_inner.race=r_inner.id
JOIN runner ru_inner ON rr_inner.runner = ru_inner.id
WHERE r_inner.event=_eventid AND rr_inner.position IS NOT NULL AND ru_inner.status='M' and
ru_inner.standard IS NOT NULL
GROUP BY rr_inner.runner,rr_inner.position
) t
GROUP BY t.runner) t2 ON rr.race=t2.bestrace and rr.runner=t2.runner
SET rr.class='RAN'
WHERE rr.class='RAN_NO_SCORE';


END