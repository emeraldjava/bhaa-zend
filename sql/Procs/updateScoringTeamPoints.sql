DELIMITER $$

DROP PROCEDURE IF EXISTS `updateScoringTeamPoints` $$
CREATE DEFINER=`bhaa1`@`localhost` PROCEDURE `updateScoringTeamPoints`(_class ENUM('W','A','B','C','D'))
BEGIN


DECLARE _points INT Default 7;
DECLARE _idToUpdate INT;

simple_loop: LOOP

  SET _points = _points - 1;

  IF NOT EXISTS (SELECT id FROM  teamraceresult WHERE leaguePoints = 0 AND class = _class AND status='PENDING') THEN
    LEAVE simple_loop;
  END IF;

  IF _points = 0 THEN
    LEAVE simple_loop;
  END IF;

  SET _idToUpdate = (SELECT id FROM teamraceresult WHERE leaguePoints =0 AND class = _class AND status='PENDING' ORDER BY positiontotal LIMIT 1);

  UPDATE teamraceresult SET leaguePoints = _points WHERE id = _idToUpdate;

END LOOP simple_loop;

  UPDATE teamraceresult
  SET leaguePoints = 1
  WHERE leaguePoints =0 AND class = _class AND status='PENDING';

END $$

DELIMITER ;