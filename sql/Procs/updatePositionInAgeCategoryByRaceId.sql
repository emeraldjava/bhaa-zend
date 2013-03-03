ALTER PROCEDURE `updatePositionInAgeCategoryByRaceId`(_raceId INT(11))
BEGIN

 DECLARE _nextCategory VARCHAR(4);
   DECLARE no_more_rows BOOLEAN;
   DECLARE loop_cntr INT DEFAULT 0;
   DECLARE num_rows INT DEFAULT 0;
   DECLARE _catCursor CURSOR FOR select category from agecategory;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;



   OPEN _catCursor;
   SELECT FOUND_ROWS() into num_rows;

    the_loop: LOOP

    FETCH  _catCursor INTO   _nextCategory;

    IF no_more_rows THEN
        CLOSE _catCursor;
        LEAVE the_loop;
    END IF;
   CREATE TEMPORARY TABLE tmpCategoryRaceResult(actualposition INT PRIMARY KEY 
AUTO_INCREMENT, runner INT);
    INSERT INTO tmpCategoryRaceResult(runner)
    SELECT runner
    FROM raceresult
    WHERE race = _raceId AND category = _nextCategory AND class='RAN';

    UPDATE raceresult, tmpCategoryRaceResult
    SET raceresult.positioninagecategory = tmpCategoryRaceResult.actualposition
    WHERE raceresult.runner = tmpCategoryRaceResult.runner AND raceresult.race = 
_raceId;

    DELETE FROM tmpCategoryRaceResult;

    SET loop_cntr = loop_cntr + 1;

  DROP TEMPORARY TABLE tmpCategoryRaceResult;

  END LOOP the_loop;


END