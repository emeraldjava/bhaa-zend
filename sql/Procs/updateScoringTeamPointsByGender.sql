DROP PROCEDURE `updateScoringTeamPointsByGender`//
CREATE  PROCEDURE `updateScoringTeamPointsByGender`(_gender ENUM('W','M'))
BEGIN
IF _gender = 'M' THEN
  CALL updateScoringTeamPoints('A');
  CALL updateScoringTeamPoints('B');
  CALL updateScoringTeamPoints('C');
  CALL updateScoringTeamPoints('D');
ELSE
  CALL updateScoringTeamPoints('W');
END IF;
END
