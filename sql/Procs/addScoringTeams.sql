DROP PROCEDURE `addScoringTeams`//
CREATE  PROCEDURE `addScoringTeams`(_leagueId INT, _raceId INT, _gender ENUM('M','W'))
BEGIN
  IF _gender = 'M' THEN
		CALL addScoringMensTeams(_leagueId, _raceId);
	ELSE
		CALL addScoringLadiesTeams(_leagueId, _raceId);
	END IF;
END
