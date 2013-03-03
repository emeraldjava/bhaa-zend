DELIMITER $$

DROP PROCEDURE IF EXISTS `updateScoringTeamClasses` $$
CREATE DEFINER=`bhaa1`@`localhost` PROCEDURE `updateScoringTeamClasses`( _raceId INT, _gender ENUM('M','W'))
BEGIN

IF _gender = 'M' THEN
  UPDATE teamraceresult SET class=NULL WHERE race =_raceId AND status='PENDING';
  UPDATE teamraceresult SET class='A' WHERE race =_raceId AND status='PENDING'AND standardtotal<31;
  UPDATE teamraceresult SET class='B' WHERE race =_raceId AND status='PENDING'AND standardtotal between 31 and 38;
  UPDATE teamraceresult SET class='C' WHERE race =_raceId AND status='PENDING'AND standardtotal between 39 and 46;
  UPDATE teamraceresult SET class='D' WHERE race =_raceId AND status='PENDING'AND standardtotal > 46;
END IF;

END $$

DELIMITER ;