CREATE PROCEDURE `getAllTop3ByEvent`(_eventId INT)
BEGIN

  DECLARE _nextAgeCategory VARCHAR(4);
  DECLARE no_more_rows BOOLEAN;
  DECLARE loop_cntr INT DEFAULT 0;
  DECLARE num_rows INT DEFAULT 0;
  DECLARE _categoryCursor CURSOR FOR SELECT category FROM agecategory WHERE category not in ('SM','JM','SW','JW');
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;

  CREATE TEMPORARY TABLE top3Result(catPosition INT PRIMARY KEY AUTO_INCREMENT, id INT, agecategory VARCHAR(4), gender ENUM('M','W'), raceId INT, actualPosition INT);
  CREATE TEMPORARY TABLE reservedPositions(position INT);

  INSERT INTO top3Result(id,agecategory,gender, raceId, actualPosition)
  SELECT r.id, null, r.gender, ra.id, rr.position
  FROM raceresult rr
  JOIN runner r ON rr.runner = r.id
  JOIN race ra ON rr.race = ra.id
  WHERE ra.event = _eventId
  AND rr.class = 'RAN'
  AND r.gender='M'
  AND ra.type <> 'W'
  ORDER BY position ASC
  LIMIT 3;

  INSERT INTO top3Result(id,agecategory,gender, raceId, actualPosition)
  SELECT r.id, null, r.gender, ra.id, rr.position
  FROM raceresult rr
  JOIN runner r ON rr.runner = r.id
  JOIN race ra ON rr.race = ra.id
  WHERE ra.event = _eventId
  AND rr.class = 'RAN'
  AND r.gender='W'
  AND ra.type <> 'M'
  ORDER BY position ASC
  LIMIT 3;

  INSERT INTO reservedPositions
  SELECT actualPosition FROM top3Result;

  OPEN _categoryCursor;
  SELECT FOUND_ROWS() into num_rows;

  the_loop: LOOP

    FETCH  _categoryCursor
    INTO   _nextAgeCategory;

    IF no_more_rows THEN
        CLOSE _categoryCursor;
        LEAVE the_loop;
    END IF;

    INSERT INTO top3Result(id,agecategory,gender,raceid)
    SELECT r.id, _nextAgeCategory, r.gender,ra.id
    FROM raceresult rr
    JOIN runner r ON rr.runner = r.id
    JOIN race ra ON rr.race = ra.id
    WHERE ra.event = _eventId
    AND rr.category = _nextAgeCategory
    AND rr.position not in (SELECT position FROM reservedPositions)
    AND rr.class = 'RAN'
    ORDER BY position ASC
    LIMIT 3;

    SET loop_cntr = loop_cntr + 1;

  END LOOP the_loop;

  DROP TABLE reservedPositions;

  SELECT rr.racetime, rr.position, t3.agecategory, r.gender, r.firstname, r.surname, t.name as teamname, COALESCE(rr.companyname,c.name) AS companyname
  FROM  top3Result t3
  JOIN raceresult rr ON t3.Id = rr.runner
  JOIN race ra ON rr.race = ra.id and ra.event = _eventId
  JOIN runner r ON rr.runner = r.id
  LEFT JOIN teammember tm ON r.id = tm.runner
  LEFT JOIN team t ON tm.team=t.id
  LEFT JOIN company c ON r.company = c.id
  ORDER BY r.gender,t3.catPosition, t3.agecategory;

  DROP TABLE top3Result;

END