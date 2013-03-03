DROP PROCEDURE `applyNewRunnerStandard`//
CREATE DEFINER=`bhaa1`@`localhost` PROCEDURE `applyNewRunnerStandard`(_race INT, _runner INT, _standard INT)
BEGIN
START TRANSACTION;

UPDATE raceresult
SET postRaceStandard = _standard
WHERE race = _race AND runner = _runner;

UPDATE runner
SET standard = _standard
WHERE id = _runner;


COMMIT;

END
