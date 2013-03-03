DELIMITER $$

DROP PROCEDURE IF EXISTS `bhaa1_members`.`getDayRunnerMatchesByEvent` $$
CREATE PROCEDURE `bhaa1_members`.`getDayRunnerMatchesByEvent` (_eventId INT)
BEGIN



SELECT
ru.firstname,ru.surname,rr.position, ra.id,ru2.id as memberid,ru.id as dayid
FROM raceresult rr, runner ru, race ra, runner ru2
WHERE rr.runner=ru.id AND rr.race=ra.id and ru.firstname=ru2.firstname AND ru.surname=ru2.surname AND ru.dateofbirth = ru2.dateofbirth
AND ru.status != 'M' AND rr.class='RAN' AND ra.event =_eventId AND ru2.status != 'D';

END $$

DELIMITER ;