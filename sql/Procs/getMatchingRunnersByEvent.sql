DROP PROCEDURE `getMatchingRunnersByEvent`//
CREATE DEFINER=`bhaa1`@`localhost` PROCEDURE `getMatchingRunnersByEvent`(_eventId INT)
BEGIN
CREATE TEMPORARY TABLE IF NOT EXISTS tmpmatches(id INT, matchedid INT, relevance enum('a','b','c'));

INSERT INTO tmpmatches(id,matchedid,relevance)
SELECT
ru.id,
ru_match.id,
'a'
FROM raceresult rr
INNER JOIN runner ru ON ru .id=rr.runner
INNER JOIN race ra ON ra.id=rr.race
INNER JOIN event e ON e.id=ra.event
INNER JOIN runner ru_match
    ON ru.surname = ru_match.surname
    AND ru.dateofbirth = ru_match.dateofbirth
    AND ru.firstname = ru_match.firstname
    and ru_match.status not in ('D', 'PRE_REG')
WHERE ru.status='D' AND rr.class='RAN' AND e.id = _eventId
ORDER by rr.position asc;


CREATE TEMPORARY TABLE IF NOT EXISTS tmpmatchesb LIKE tmpmatches;

INSERT INTO tmpmatchesb(id,matchedid,relevance)
SELECT
ru.id,
ru_match.id,
'b'
FROM raceresult rr
INNER JOIN runner ru ON ru .id=rr.runner
INNER JOIN race ra ON ra.id=rr.race
INNER JOIN event e ON e.id=ra.event
INNER JOIN runner ru_match
    ON ru.surname = ru_match.surname
    AND ru.firstname = ru_match.firstname
    and ru_match.status not in ('D', 'PRE_REG')
WHERE ru.status='D' AND rr.class='RAN' AND e.id = _eventId
AND ru.id not in (select id from tmpmatches)
ORDER by rr.position asc;


INSERT INTO tmpmatches SELECT * FROM tmpmatchesb;
TRUNCATE TABLE tmpmatchesb;

INSERT INTO tmpmatchesb(id,matchedid,relevance)
select x.id, x.matchedid, x.relevance
from
(
SELECT
ru.id,
ru_match.id as matchedid,
'c' as relevance
FROM raceresult rr
INNER JOIN runner ru ON ru .id=rr.runner
INNER JOIN race ra ON ra.id=rr.race
INNER JOIN event e ON e.id=ra.event
INNER JOIN runner ru_match
    ON ru.surname = ru_match.surname
    AND ru.dateofbirth = ru_match.dateofbirth
and ru_match.status not in ('D', 'PRE_REG')
WHERE ru.status='D' AND rr.class='RAN' AND e.id = _eventId
AND ru.id not in (select id from tmpmatches)
ORDER by rr.position asc
) x;

INSERT INTO tmpmatches SELECT * FROM tmpmatchesb;


select rr.position,t.relevance,rr.id,
r1.id,r1.firstname,r1.surname,r1.standard,r1.status,r1.dateofbirth ,
r2.id as rid,r2.firstname as rfirstname,r2.surname as rsurname,r2.standard as rstandard,r2.status as rstatus,r2.dateofbirth as rdateofbirth
from raceresult rr
join runner r1 on rr.runner=r1.id
join race ra on rr.race = ra.id
join event e on ra.event = e.id
left join tmpmatches t on r1.id = t.id
left join runner r2 on t.matchedid=r2.id
where e.id=_eventId and r1.status='d'
order by rr.position asc;


DROP temporary table tmpmatches;
DROP temporary table tmpmatchesb;

END
