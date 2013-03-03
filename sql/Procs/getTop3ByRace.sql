ALTER PROCEDURE `getTop3ByRace`(_race INT, _category VARCHAR(20), _gender ENUM('M','W'))
BEGIN

IF _category IS NOT NULL THEN

  SELECT _category as category, r.id, r.firstname, r.surname, t.name as company
  FROM raceresult rr
  JOIN runner r ON rr.runner = r.id
  LEFT JOIN teammember tm ON r.id = tm.runner
  LEFT JOIN team t ON tm.team=t.id
  WHERE rr.race = _race
  AND rr.category = _category
  AND r.gender = _gender
  AND rr.position > 3
  ORDER BY position ASC
  LIMIT 3;

ELSE

  SELECT _category as category, r.id, r.firstname, r.surname, t.name as company
  FROM raceresult rr
  JOIN runner r ON rr.runner = r.id
  LEFT JOIN teammember tm ON r.id = tm.runner
  LEFT JOIN team t ON tm.team=t.id
  WHERE rr.race = _race
  AND r.gender = _gender
  ORDER BY position ASC
  LIMIT 3;

END IF;



END $$

DELIMITER ;
<<<<<<< .mineEND=======END $$

DELIMITER ;>>>>>>> .theirs