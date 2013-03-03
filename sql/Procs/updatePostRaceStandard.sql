DROP PROCEDURE `updatePostRaceStandard`//
CREATE PROCEDURE `updatePostRaceStandard`(_raceId INT)
BEGIN

UPDATE raceresult rr_outer,
(
SELECT rr.race,rr.runner,rr.racetime, rr.standard, getStandard(rr.racetime, ra.distancekm) as postRaceStandard
FROM raceresult rr ,race ra,runner ru
WHERE rr.race = ra.id AND rr.runner=ru.id AND ra.id = _raceId AND rr.class='RAN'

) t
SET rr_outer.postRaceStandard =
CASE
  WHEN t.standard IS NULL
	  THEN t.postRaceStandard
  WHEN t.standard  < t.postRaceStandard
	  THEN t.standard  + 1
  WHEN t.standard  > t.postRaceStandard
	  THEN t.standard  - 1
  WHEN t.standard  = t.postRaceStandard
    THEN t.standard
END
WHERE rr_outer.race = t.race AND rr_outer.runner=t.runner;


UPDATE raceresult, runner
SET runner.standard = raceresult.postracestandard
WHERE raceresult.runner = runner.id
AND raceresult.race = _raceId
AND COALESCE(runner.standard,0) <> raceresult.postracestandard
AND runner.status='M';


END
