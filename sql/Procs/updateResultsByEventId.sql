DROP PROCEDURE `updateResultsByEventId`//
CREATE DEFINER=`bhaa1`@`localhost` PROCEDURE `updateResultsByEventId`(_eventId INT(11))
BEGIN

  DECLARE _nextRaceId INT;
  DECLARE _type enum('C','W','M');

  DECLARE no_more_rows BOOLEAN;
  DECLARE loop_cntr INT DEFAULT 0;
  DECLARE num_rows INT DEFAULT 0;
  DECLARE _raceCursor CURSOR FOR SELECT id FROM race WHERE event = _eventId AND type <> 'S';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;

      OPEN _raceCursor;
      SELECT FOUND_ROWS() into num_rows;

      the_loop: LOOP

      FETCH  _raceCursor INTO   _nextRaceId;

      IF no_more_rows THEN
        CLOSE _raceCursor;
        LEAVE the_loop;
      END IF;


      CALL updateResultsByRaceId(_nextRaceId);

      SET loop_cntr = loop_cntr + 1;

  END LOOP the_loop;


END