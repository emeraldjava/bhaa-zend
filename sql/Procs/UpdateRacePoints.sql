DROP PROCEDURE `updateRacePoints`//
CREATE DEFINER=`bhaa1`@`localhost` PROCEDURE `updateRacePoints`(_raceId INT, _gender ENUM('M','W'))
BEGIN

    DECLARE _standard INT DEFAULT 30;

  	WHILE _standard > 0 DO
      UPDATE raceresult rr,
      (
        SELECT
        r_outer.race,
        r_outer.runner,
        r_outer.standardposition,
        10.1 -  (r_outer.standardposition/10.0) as standardpoints
        FROM
          (
          SELECT
          r1.race,
          r1.runner,
          @rownum:=@rownum+1 AS standardposition
          FROM
          raceresult r1, runner ru, (SELECT @rownum:=0) r2
          WHERE
          r1.runner=ru.id
          AND ru.gender= COALESCE(_gender, ru.gender)
          AND r1.race = _raceId AND r1.standard=_standard order by r1.position asc
          ) r_outer
        ) r_outer_outer
      SET rr.points = r_outer_outer.standardpoints
      WHERE rr.runner = r_outer_outer.runner AND rr.race = r_outer_outer.race;

      SET _standard = _standard - 1;
   END WHILE;

END