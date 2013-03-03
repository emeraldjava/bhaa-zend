ALTER PROCEDURE `getAllTop3ByRace`(_race INT, _gender ENUM('M','W'))
BEGIN


  DECLARE _nextAgeCategory VARCHAR(4);
  DECLARE no_more_rows BOOLEAN;
  DECLARE loop_cntr INT DEFAULT 0;
  DECLARE num_rows INT DEFAULT 0;
  DECLARE _categoryCursor CURSOR FOR SELECT category FROM agecategory WHERE gender = _gender and category not in ('SM','JM','SW','JW');
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;

  CREATE TEMPORARY TABLE top3Result(catPosition INT PRIMARY KEY AUTO_INCREMENT, id INT, agecategory VARCHAR(4), gender ENUM('M','W'));

  INSERT INTO top3Result(id,agecategory,gender)
  SELECT r.id, null, _gender
  FROM raceresult rr
  JOIN runner r ON rr.runner = r.id
  WHERE rr.race = _race
  AND r.gender = _gender
  AND rr.class = 'RAN'
  ORDER BY position ASC
  LIMIT 3;

  OPEN _categoryCursor;
  SELECT FOUND_ROWS() into num_rows;

  the_loop: LOOP

    FETCH  _categoryCursor
    INTO   _nextAgeCategory;

    IF no_more_rows THEN
        CLOSE _categoryCursor;
        LEAVE the_loop;
    END IF;

    INSERT INTO top3Result(id,agecategory,gender)
    SELECT r.id, _nextAgeCategory, _gender
    FROM raceresult rr
    JOIN runner r ON rr.runner = r.id
    WHERE rr.race = _race
    AND rr.category = _nextAgeCategory
    AND r.gender = _gender
    AND rr.position > 3
    AND rr.class = 'RAN'
    ORDER BY position ASC
    LIMIT 3;

    SET loop_cntr = loop_cntr + 1;

  END LOOP the_loop;

  SELECT t3.agecategory, r.firstname, r.surname, t.name as teamname, COALESCE(rr.companyname,c.name) AS companyname
FROM
top3Result t3
JOIN raceresult rr ON t3.Id = rr.runner AND rr.race = _race
JOIN runner r ON rr.runner = r.id
LEFT JOIN teammember tm ON r.id = tm.runner
LEFT JOIN team t ON tm.team=t.id
LEFT JOIN company c ON r.company = c.id
ORDER BY t3.catPosition, t3.agecategory;


  DROP TABLE top3Result;

END