DROP PROCEDURE `getAllTop3TeamByEvent`//
CREATE PROCEDURE `getAllTop3TeamByEvent`(_eventId INT)
BEGIN
(
SELECT id,name,standardtotal,positiontotal,class
FROM
(
 SELECT t.id,t.name, trr.standardtotal,trr.positiontotal, 'W' AS class
 FROM teamraceresult trr
 JOIN team t on trr.team=t.id
 JOIN race ra ON trr.race = ra.id
 WHERE ra.event = _eventId
 AND trr.class = 'W'
 ORDER BY positiontotal ASC
) t
LIMIT 3
)
UNION
(
SELECT id,name,standardtotal,positiontotal,class
FROM
(
 SELECT t.id,t.name, trr.standardtotal,trr.positiontotal, 'A' AS class
 FROM teamraceresult trr
 JOIN team t on trr.team=t.id
 JOIN race ra ON trr.race = ra.id
 WHERE ra.event = _eventId
 AND trr.class = 'A'
 ORDER BY positiontotal ASC
) t
LIMIT 3
)
UNION
(
SELECT id,name,standardtotal,positiontotal,class
FROM
(
 SELECT t.id,t.name, trr.standardtotal,trr.positiontotal, 'B' AS class
 FROM teamraceresult trr
 JOIN team t on trr.team=t.id
 JOIN race ra ON trr.race = ra.id
 WHERE ra.event = _eventId
 AND trr.class = 'B'
 ORDER BY positiontotal ASC
) t
LIMIT 3
)
UNION
(
SELECT id,name,standardtotal,positiontotal,class
FROM
(
 SELECT t.id,t.name, trr.standardtotal,trr.positiontotal, 'C' AS class
 FROM teamraceresult trr
 JOIN team t on trr.team=t.id
 JOIN race ra ON trr.race = ra.id
 WHERE ra.event = _eventId
 AND trr.class = 'C'
 ORDER BY positiontotal ASC
) t
LIMIT 3
)
UNION
(
SELECT id,name,standardtotal,positiontotal,class
FROM
(
 SELECT t.id,t.name, trr.standardtotal,trr.positiontotal, 'D' AS class
 FROM teamraceresult trr
 JOIN team t on trr.team=t.id
 JOIN race ra ON trr.race = ra.id
 WHERE ra.event = _eventId
 AND trr.class = 'D'
 ORDER BY positiontotal ASC
) t
LIMIT 3
);
END
