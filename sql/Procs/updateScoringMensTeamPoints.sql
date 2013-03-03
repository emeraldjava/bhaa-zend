CREATE PROCEDURE `updateScoringMensTeamPoints`()
BEGIN
CALL updateScoringTeamPoints('A');
CALL updateScoringTeamPoints('B');
CALL updateScoringTeamPoints('C');
CALL updateScoringTeamPoints('D');
END