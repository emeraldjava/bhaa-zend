DELIMITER $$

DROP PROCEDURE IF EXISTS `PopulateStandardTimes` $$
CREATE DEFINER=``@`` PROCEDURE `PopulateStandardTimes`()
BEGIN

DELETE FROM StandardTime;

INSERT INTO standardTime(standard, distance, unit, standardTime) Values(1,10,'KM','00:29:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(2,10,'KM','00:30:20');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(3,10,'KM','00:31:10');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(4,10,'KM','00:32:05');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(5,10,'KM','00:32:55');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(6,10,'KM','00:33:50');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(7,10,'KM','00:34:45');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(8,10,'KM','00:35:35');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(9,10,'KM','00:36:25');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(10,10,'KM','00:37:15');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(11,10,'KM','00:38:05');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(12,10,'KM','00:38:55');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(13,10,'KM','00:39:50');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(14,10,'KM','00:40:40');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(15,10,'KM','00:41:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(16,10,'KM','00:42:20');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(17,10,'KM','00:43:15');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(18,10,'KM','00:44:05');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(19,10,'KM','00:44:55');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(20,10,'KM','00:45:45');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(21,10,'KM','00:46:35');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(22,10,'KM','00:47:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(23,10,'KM','00:48:20');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(24,10,'KM','00:49:10');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(25,10,'KM','00:50:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(26,10,'KM','00:50:50');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(27,10,'KM','00:51:45');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(28,10,'KM','00:52:35');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(29,10,'KM','00:53:25');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(30,10,'KM','00:54:15');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(1,4,'Mile','00:19:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(2,4,'Mile','00:19:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(3,4,'Mile','00:20:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(4,4,'Mile','00:20:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(5,4,'Mile','00:21:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(6,4,'Mile','00:21:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(7,4,'Mile','00:22:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(8,4,'Mile','00:22:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(9,4,'Mile','00:23:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(10,4,'Mile','00:23:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(11,4,'Mile','00:24:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(12,4,'Mile','00:24:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(13,4,'Mile','00:25:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(14,4,'Mile','00:25:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(15,4,'Mile','00:26:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(16,4,'Mile','00:26:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(17,4,'Mile','00:27:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(18,4,'Mile','00:27:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(19,4,'Mile','00:28:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(20,4,'Mile','00:28:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(21,4,'Mile','00:29:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(22,4,'Mile','00:29:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(23,4,'Mile','00:30:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(24,4,'Mile','00:30:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(25,4,'Mile','00:31:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(26,4,'Mile','00:31:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(27,4,'Mile','00:32:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(28,4,'Mile','00:32:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(29,4,'Mile','00:33:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(30,4,'Mile','00:33:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(1,5,'Mile','00:23:55');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(2,5,'Mile','00:24:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(3,5,'Mile','00:25:05');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(4,5,'Mile','00:25:45');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(5,5,'Mile','00:26:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(6,5,'Mile','00:27:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(7,5,'Mile','00:27:40');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(8,5,'Mile','00:28:20');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(9,5,'Mile','00:29:00');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(10,5,'Mile','00:29:40');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(11,5,'Mile','00:30:20');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(12,5,'Mile','00:30:55');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(13,5,'Mile','00:31:35');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(14,5,'Mile','00:32:15');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(15,5,'Mile','00:32:55');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(16,5,'Mile','00:33:35');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(17,5,'Mile','00:34:15');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(18,5,'Mile','00:34:55');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(19,5,'Mile','00:35:35');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(20,5,'Mile','00:36:10');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(21,5,'Mile','00:36:50');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(22,5,'Mile','00:37:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(23,5,'Mile','00:38:10');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(24,5,'Mile','00:38:50');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(25,5,'Mile','00:39:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(26,5,'Mile','00:40:10');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(27,5,'Mile','00:40:50');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(28,5,'Mile','00:41:30');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(29,5,'Mile','00:42:10');
INSERT INTO standardTime(standard, distance, unit, standardTime) Values(30,5,'Mile','00:42:50');


#Temp way to get 5k standards
insert into standardTime(standard,standardTime, distance,unit)
select standard,SEC_TO_TIME(TIME_TO_SEC(standardtime)/2) as standardTime,5,'KM' from standardTime
where distance = 10 and unit='Km';

END $$

DROP FUNCTION IF EXISTS `CalculateRunnerPaceKM` $$
CREATE DEFINER=``@`` FUNCTION `CalculateRunnerPaceKM`(_raceTime TIME, _distance DOUBLE, _unit ENUM('KM','Mile')) RETURNS time
BEGIN
SET _distance =
IF (_unit = 'Mile', _distance * 1.609344, _distance);
RETURN  SEC_TO_TIME(TIME_TO_SEC(_raceTime) / _distance);
END $$

DROP FUNCTION IF EXISTS `GetStandardByRaceTime` $$
CREATE DEFINER=``@`` FUNCTION `GetStandardByRaceTime`(_raceTime TIME, _distance DOUBLE, _unit ENUM('KM','Mile')) RETURNS int(11)
BEGIN

DECLARE _standard INT;

SET _standard = (
SELECT COALESCE(max(standard), 30) AS standard
FROM standardTime
WHERE distance = _distance
AND unit = _unit
AND TIME_TO_SEC(standardTime) <= TIME_TO_SEC(_raceTime));

RETURN _standard;
END $$

DROP PROCEDURE IF EXISTS `UpdatePointsByStandard` $$
CREATE PROCEDURE `UpdatePointsByStandard` (_raceId INT, _standard VARCHAR(2), _gender VARCHAR(2))
BEGIN

  DECLARE _minValue INT;
  DECLARE _maxValue INT;
  CREATE TABLE ActualRaceResult(ActualPosition INT PRIMARY KEY AUTO_INCREMENT, runnerId INT, racePosition INT);

  SET _minValue = (SELECT d.min FROM division d WHERE d.code = _standard);
  SET _maxValue = (SELECT d.max FROM division d WHERE d.code = _standard);

  INSERT INTO ActualRaceResult(runnerId, racePosition)
  SELECT rr.runner, rr.position
  FROM RaceResult rr
  JOIN Runner r ON rr.runner = r.id
  WHERE rr.race = _raceId AND rr.standard BETWEEN _minValue AND _maxValue  AND r.Gender= _gender
  ORDER BY rr.position;

  UPDATE RaceResult rr,ActualRaceResult ar
  SET rr.Points = 10.1 - (ar.ActualPosition/10)
  WHERE rr.runner = ar.runnerId AND rr.race = _RaceId;

  DROP TABLE ActualRaceResult;

END $$


DROP PROCEDURE IF EXISTS `UpdateResultsByCombinedRaceId` $$
CREATE DEFINER=``@`` PROCEDURE `UpdateResultsByCombinedRaceId`(_RaceId Int, out _rc Int)
updatePoints:BEGIN

DECLARE _category VARCHAR(30);

SET _rc = 0;
SET _category = (SELECT category FROM race WHERE id = _RaceId);

# Make sure the race is a Combined race so that the handling of points is executed correctly.
IF _category IS NULL or _category != 'Combined' THEN

  SELECT 'An error occurred as you are trying to update the points on a race that is not categorised as Combined.';
  SET _rc = -1;
  LEAVE updatePoints;

ELSE

  # [Begin] Complete the points for the Male A Standard
  CALL UpdatePointsByStandard(_RaceId,'A','M');
  SELECT 'Completed Male Standard A.';
  # [End] Complete the points for the A Standard

    # [Begin] Complete the points for the Male B Standard
  CALL UpdatePointsByStandard(_RaceId,'B','M');
  SELECT 'Completed Male Standard B.';
  # [End] Complete the points for the B Standard

    # [Begin] Complete the points for the Male C Standard
  CALL UpdatePointsByStandard(_RaceId,'C','M');
  SELECT 'Completed Male Standard C.';
  # [End] Complete the points for the C Standard

    # [Begin] Complete the points for the Male D Standard
  CALL UpdatePointsByStandard(_RaceId,'D','M');
  SELECT 'Completed Male Standard D.';
  # [End] Complete the points for the D Standard

    # [Begin] Complete the points for the Male E Standard
  CALL UpdatePointsByStandard(_RaceId,'E','M');
  SELECT 'Completed Male Standard E.';
  # [End] Complete the points for the E Standard

    # [Begin] Complete the points for the Male F Standard
  CALL UpdatePointsByStandard(_RaceId,'F','M');
  SELECT 'Completed Male Standard F.';
  # [End] Complete the points for the F Standard

  # [Begin] Complete the points for the Female L1 Standard
  CALL UpdatePointsByStandard(_RaceId,'L1','F');
  SELECT 'Completed Female Standard L1.';
  # [End] Complete the points for the Female L1  Standard

  # [Begin] Complete the points for the Female L2  Standard
  CALL UpdatePointsByStandard(_RaceId,'L2','F');
  SELECT 'Completed Female Standard L2.';
  # [End] Complete the points for the Female L2  Standard

  # [Begin] Add the runners km pace based on race distance and their time.
  UPDATE raceResult, race
  SET raceResult.paceKm = CalculateRunnerPaceKM(raceResult.raceTime, race.distance, race.Unit)
  WHERE raceResult.race = race.Id AND race.Id = _raceId;
  SELECT 'Completed pace calculations for all runners.';
  # [End] Add the runners km pace based on race distance and their time.

  # [Begin] Add the post race standard for a runner.
  UPDATE raceResult, race
  SET raceResult.postRaceStandard = GetStandardByRaceTime(raceResult.raceTime, race.distance, race.Unit)
  WHERE raceResult.race = race.Id AND race.Id = _raceId;
  SELECT 'Completed post race standard calculations.';
  # [End] Add the post race standard for a runner.

  # [Begin] Process the Race Organisers
  UPDATE RaceResult rr, RaceOrganiser ro
  SET rr.Points = 10.0
  WHERE rr.runner = ro.runner AND rr.race = _RaceId;
  SELECT 'Completed race organisers updates.';
  # [End] Process the Race Organisers

END IF;

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `UpdateResultsByRaceId` $$
CREATE DEFINER=``@`` PROCEDURE `UpdateResultsByRaceId`(_RaceId Int, out _rc Int)
updatePoints:BEGIN

DECLARE _category VARCHAR(30);

SET _rc = 0;
SET _category = (SELECT category FROM race WHERE id = _RaceId);

# Make sure the race is not a Combined race so that the handling of points is executed correctly.
IF _category IS NULL or _category = 'Combined' THEN

  SELECT 'An error occurred as you are trying to update the points on a race that is is categorised as Combined.';
  SET _rc = -1;
  LEAVE updatePoints;

ELSE


IF _category = 'Mens' THEN

  # [Begin] Complete the points for the Male A Standard
  CALL UpdatePointsByStandard(_RaceId,'A', null);
  SELECT 'Completed Male Standard A.';
  # [End] Complete the points for the A Standard

    # [Begin] Complete the points for the Male B Standard
  CALL UpdatePointsByStandard(_RaceId,'B', null);
  SELECT 'Completed Male Standard B.';
  # [End] Complete the points for the B Standard

    # [Begin] Complete the points for the Male C Standard
  CALL UpdatePointsByStandard(_RaceId,'C', null);
  SELECT 'Completed Male Standard C.';
  # [End] Complete the points for the C Standard

    # [Begin] Complete the points for the Male D Standard
  CALL UpdatePointsByStandard(_RaceId,'D', null);
  SELECT 'Completed Male Standard D.';
  # [End] Complete the points for the D Standard

    # [Begin] Complete the points for the Male E Standard
  CALL UpdatePointsByStandard(_RaceId,'E', null);
  SELECT 'Completed Male Standard E.';
  # [End] Complete the points for the E Standard

    # [Begin] Complete the points for the Male F Standard
  CALL UpdatePointsByStandard(_RaceId,'F', null);
  SELECT 'Completed Male Standard F.';
  # [End] Complete the points for the F Standard

ELSEIF _category = 'Women' THEN

  # [Begin] Complete the points for the Female L1 Standard
  CALL UpdatePointsByStandard(_RaceId,'L1','F');
  SELECT 'Completed Female Standard L1.';
  # [End] Complete the points for the Female L1  Standard

  # [Begin] Complete the points for the Female L2  Standard
  CALL UpdatePointsByStandard(_RaceId,'L2','F');
  SELECT 'Completed Female Standard L2.';
  # [End] Complete the points for the Female L2  Standard

ELSE

  SELECT 'An unhandled race category was encountered.';
  SET _rc = -1;
  LEAVE updatePoints;

END IF;

  # [Begin] Add the runners km pace based on race distance and their time.
  UPDATE raceResult, race
  SET raceResult.paceKm = CalculateRunnerPaceKM(raceResult.raceTime, race.distance, race.Unit)
  WHERE raceResult.race = race.Id AND race.Id = _raceId;
  SELECT 'Completed pace calculations for all runners.';
  # [End] Add the runners km pace based on race distance and their time.

  # [Begin] Add the post race standard for a runner.
  UPDATE raceResult, race
  SET raceResult.postRaceStandard = GetStandardByRaceTime(raceResult.raceTime, race.distance, race.Unit)
  WHERE raceResult.race = race.Id AND race.Id = _raceId;
  SELECT 'Completed post race standard calculations.';
  # [End] Add the post race standard for a runner.

  # [Begin] Process the Race Organisers
  UPDATE RaceResult rr, RaceOrganiser ro
  SET rr.Points = 10.0
  WHERE rr.runner = ro.runner AND rr.race = _RaceId;
  SELECT 'Completed race organisers updates.';
  # [End] Process the Race Organisers

END IF;

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `UpdateResultsByRaceId` $$
CREATE DEFINER=``@`` PROCEDURE `UpdateResultsByRaceId`(_RaceId Int, out _rc Int)
updatePoints:BEGIN

DECLARE _category VARCHAR(30);
DECLARE _leagueId INT(11);

SET _rc = 0;
SET _category = (SELECT category FROM race WHERE id = _RaceId);

SET _leagueId = (SELECT l.id
                    FROM League l
                    JOIN LeagueEvent le ON l.id = le.league
                    JOIN Event e ON le.event = e.id
                    JOIN Race r ON e.id = r.event
                    WHERE r.id=_raceId AND l.type='I');
IF _category = 'Mens' THEN

  CALL UpdatePointsByStandard(_RaceId,'A', null);
  CALL UpdatePointsByStandard(_RaceId,'B', null);
  CALL UpdatePointsByStandard(_RaceId,'C', null);
  CALL UpdatePointsByStandard(_RaceId,'D', null);
  CALL UpdatePointsByStandard(_RaceId,'E', null);
  CALL UpdatePointsByStandard(_RaceId,'F', null);

ELSEIF _category = 'Women' THEN

  CALL UpdatePointsByStandard(_RaceId,'L1',null);
  CALL UpdatePointsByStandard(_RaceId,'L2',null);

ELSE

  SET _rc = -1;
  LEAVE updatePoints;

END IF;


  UPDATE raceResult, race
  SET raceResult.paceKm = CalculateRunnerPaceKM(raceResult.raceTime, race.distance, race.Unit)
  WHERE raceResult.race = race.Id AND race.Id = _raceId;

  UPDATE raceResult, race
  SET raceResult.postRaceStandard = GetStandardByRaceTime(raceResult.raceTime, race.distance, race.Unit)
  WHERE raceResult.race = race.Id AND race.Id = _raceId;

  CALL UpdateLeagueData(_leagueId, _raceId);

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `UpdateResultsByCombinedRaceId` $$
CREATE PROCEDURE `UpdateResultsByCombinedRaceId`(_RaceId Int, out _rc Int)
updatePoints:BEGIN

DECLARE _category VARCHAR(30);
DECLARE _leagueId INT(11);

SET _rc = 0;
SET _category = (SELECT category FROM race WHERE id = _RaceId);

# Make sure the race is a Combined race so that the handling of points is executed correctly.
IF _category IS NULL or _category != 'Combined' THEN

  SELECT 'An error occurred as you are trying to update the points on a race that is not categorised as Combined.';
  SET _rc = -1;
  LEAVE updatePoints;

ELSE

  SET _leagueId = (SELECT l.id
                    FROM League l
                    JOIN LeagueEvent le ON l.id = le.league
                    JOIN Event e ON le.event = e.id
                    JOIN Race r ON e.id = r.event
                    WHERE r.id=_raceId AND l.type='I');

  # [Begin] Complete the points for the Male A Standard
  CALL UpdatePointsByStandard(_RaceId,'A','M');
#  SELECT 'Completed Male Standard A.';
  # [End] Complete the points for the A Standard

    # [Begin] Complete the points for the Male B Standard
  CALL UpdatePointsByStandard(_RaceId,'B','M');
#  SELECT 'Completed Male Standard B.';
  # [End] Complete the points for the B Standard

    # [Begin] Complete the points for the Male C Standard
  CALL UpdatePointsByStandard(_RaceId,'C','M');
#  SELECT 'Completed Male Standard C.';
  # [End] Complete the points for the C Standard

    # [Begin] Complete the points for the Male D Standard
  CALL UpdatePointsByStandard(_RaceId,'D','M');
#  SELECT 'Completed Male Standard D.';
  # [End] Complete the points for the D Standard

    # [Begin] Complete the points for the Male E Standard
  CALL UpdatePointsByStandard(_RaceId,'E','M');
#  SELECT 'Completed Male Standard E.';
  # [End] Complete the points for the E Standard

    # [Begin] Complete the points for the Male F Standard
  CALL UpdatePointsByStandard(_RaceId,'F','M');
#  SELECT 'Completed Male Standard F.';
  # [End] Complete the points for the F Standard

  # [Begin] Complete the points for the Female L1 Standard
  CALL UpdatePointsByStandard(_RaceId,'L1','F');
#  SELECT 'Completed Female Standard L1.';
  # [End] Complete the points for the Female L1  Standard

  # [Begin] Complete the points for the Female L2  Standard
  CALL UpdatePointsByStandard(_RaceId,'L2','F');
  #SELECT 'Completed Female Standard L2.';
  # [End] Complete the points for the Female L2  Standard

  # [Begin] Add the runners km pace based on race distance and their time.
  UPDATE raceResult, race
  SET raceResult.paceKm = CalculateRunnerPaceKM(raceResult.raceTime, race.distance, race.Unit)
  WHERE raceResult.race = race.Id AND race.Id = _raceId;
#  SELECT 'Completed pace calculations for all runners.';
  # [End] Add the runners km pace based on race distance and their time.

  # [Begin] Add the post race standard for a runner.
  UPDATE raceResult, race
  SET raceResult.postRaceStandard = GetStandardByRaceTime(raceResult.raceTime, race.distance, race.Unit)
  WHERE raceResult.race = race.Id AND race.Id = _raceId;
#  SELECT 'Completed post race standard calculations.';
  # [End] Add the post race standard for a runner.

  # [Begin] Process the Race Organisers
  UPDATE RaceResult rr, RaceOrganiser ro
  SET rr.Points = 10.0
  WHERE rr.runner = ro.runner AND rr.race = _RaceId;
#  SELECT 'Completed race organisers updates.';
  # [End] Process the Race Organisers

  # [Begin] Add the league data for each competing runner.
  CALL UpdateLeagueData(_leagueId, _raceId);
  # [End] Add the league data for each competing runner.

END IF;

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `UpdatePointsByStandard` $$

CREATE PROCEDURE `UpdatePointsByStandard`(_raceId INT, _standard VARCHAR(2), _gender VARCHAR(2))
BEGIN

  DECLARE _minValue INT;
  DECLARE _maxValue INT;
  CREATE TABLE tmpActualRaceResult(ActualPosition INT PRIMARY KEY AUTO_INCREMENT, runnerId INT, racePosition INT);

  SET _minValue = (SELECT d.min FROM division d WHERE d.code = _standard);
  SET _maxValue = (SELECT d.max FROM division d WHERE d.code = _standard);

  IF _gender IS NULL THEN

    INSERT INTO tmpActualRaceResult(runnerId, racePosition)
    SELECT rr.runner, rr.position
    FROM RaceResult rr
    JOIN Runner r ON rr.runner = r.id
    WHERE rr.race = _raceId AND rr.standard BETWEEN _minValue AND _maxValue
    ORDER BY rr.position;

  ELSE

    INSERT INTO tmpActualRaceResult(runnerId, racePosition)
    SELECT rr.runner, rr.position
    FROM RaceResult rr
    JOIN Runner r ON rr.runner = r.id
    WHERE rr.race = _raceId AND rr.standard BETWEEN _minValue AND _maxValue  AND r.Gender= _gender
    ORDER BY rr.position;

  END IF;

  UPDATE RaceResult rr,tmpActualRaceResult ar
  SET rr.Points = 10.1 - (ar.ActualPosition/10)
  WHERE rr.runner = ar.runnerId AND rr.race = _RaceId;

  DROP TABLE tmpActualRaceResult;

END $$

DELIMITER;

DELIMITER $$

DROP PROCEDURE IF EXISTS `UpdateLeagueRunnerData` $$
CREATE  PROCEDURE `UpdateLeagueRunnerData`(_leagueId INT, _runnerId INT)
BEGIN

DECLARE _raceCount INT;
DECLARE _pointsTotal DOUBLE;
DECLARE _avgOverallPosition DOUBLE;

  SET _raceCount = (SELECT COUNT(rr.race) FROM RaceResult rr
                    JOIN Race ra ON rr.race = ra.id
                    JOIN Event e ON ra.event = e.id
                    JOIN LeagueEvent le ON e.id = le.event
                    WHERE runner=_runnerId AND le.league=_leagueId);

  SET _pointsTotal = getLeaguePointsTotal(_leagueId, _runnerId);

 SET _avgOverallPosition = COALESCE((SELECT AVG(rr.position) FROM RaceResult rr
                    JOIN Race ra ON rr.race = ra.id
                    JOIN Event e ON ra.event = e.id
                    JOIN LeagueEvent le ON e.id = le.event
                    WHERE runner=_runnerId AND le.league=_leagueId), 0);


  IF EXISTS (SELECT runner FROM LeagueRunnerData WHERE league=_leagueId AND runner=_runnerId) THEN
     UPDATE LeagueRunnerData
     SET pointsTotal = _pointsTotal,
         racesComplete = _raceCount,
         avgOverallPosition = _avgOverallPosition
     WHERE league=_leagueId AND runner=_runnerId;
  ELSE
    INSERT INTO LeagueRunnerData(league,runner,racesComplete, pointsTotal,avgOverallPosition)
    VALUES (_leagueId, _runnerId, _raceCount, _pointsTotal, _avgOverallPosition);
  END IF;



END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `UpdateLeagueData` $$
CREATE PROCEDURE `UpdateLeagueData`(_leagueId INT(11), _raceId INT(11))
BEGIN

  DECLARE done BOOLEAN DEFAULT 0;
  DECLARE _nextRunnerId INT;
  DECLARE _runnerId CURSOR FOR SELECT runner FROM RaceResult WHERE race = _raceId;

  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;

  OPEN _runnerId;

  REPEAT

  FETCH _runnerId INTO _nextRunnerId;

  CALL UpdateLeagueRunnerData(_leagueId, _nextRunnerId);

  UNTIL done END REPEAT;

  CLOSE _runnerId;

END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `bhaa2`.`getSlopeFactor` $$
CREATE FUNCTION `bhaa2`.`getSlopeFactor` (_standard INT(11),_raceDistanceA DOUBLE, _raceUnitA ENUM('KM','Mile'),_raceDistanceB DOUBLE, _raceUnitB ENUM('KM','Mile')) RETURNS DOUBLE
BEGIN

  DECLARE _raceTimeA TIME;
  DECLARE _raceTimeB TIME;
  DECLARE _paceA TIME;
  DECLARE _paceB TIME;
  DECLARE _paceDeltaInSecs DOUBLE;
  DECLARE _distanceDeltaInKM DOUBLE;


  SET _raceTimeA = (SELECT standardTime FROM StandardTime WHERE standard=_standard AND distance=_raceDistanceA AND unit=_raceUnitA);
  SET _raceTimeB = (SELECT standardTime FROM StandardTime WHERE standard=_standard AND distance=_raceDistanceB AND unit=_raceUnitB);


  SET _paceA = (SELECT CalculateRunnerPaceKM(_raceTimeA, _raceDistanceA, _raceUnitA));
  SET _paceB = (SELECT CalculateRunnerPaceKM(_raceTimeB, _raceDistanceB, _raceUnitB));

  SET _paceDeltaInSecs = (TIME_TO_SEC(_paceA) - TIME_TO_SEC(_paceB));
  SET _distanceDeltaInKM = (GetRaceDistanceKM(_raceDistanceA,_raceUnitA) - GetRaceDistanceKM(_raceDistanceB, _raceUnitB));


  RETURN _paceDeltaInSecs / _distanceDeltaInKM;


END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `GetStandardByRaceTime2` $$
CREATE DEFINER=``@`` FUNCTION `GetStandardByRaceTime2`(_raceTime TIME, _distance DOUBLE, _unit ENUM('KM','Mile')) RETURNS time
BEGIN

DECLARE _slope DOUBLE;
DECLARE _distanceDelta DOUBLE;
DECLARE _projectedPace TIME;
DECLARE _actualPace TIME;


SET _actualPace = (SELECT CalculateRunnerPaceKM(_raceTime, _distance, _unit));

SET _slope = 1.57;
SET _projectedPace = '00:04:25';
SET _distanceDelta = (6.4-_distance);



#RETURN SEC_TO_TIME(((_distanceDelta * _slope) - TIME_TO_SEC(_projectedPace)) * -1);
RETURN _actualPace;
END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `CalculateRunnerPaceKM` $$
CREATE FUNCTION `CalculateRunnerPaceKM`(_raceTime TIME, _distance DOUBLE, _unit ENUM('KM','Mile')) RETURNS time
BEGIN
SET _distance =
IF (_unit = 'Mile', _distance * 1.609344, _distance);
RETURN  SEC_TO_TIME(TIME_TO_SEC(_raceTime) / _distance);
END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `GetStandardByRaceTime` $$
CREATE  FUNCTION `GetStandardByRaceTime`(_raceTime TIME, _distance DOUBLE, _unit ENUM('KM','Mile')) RETURNS int(11)
BEGIN

DECLARE _standard INT;

SET _standard = (
SELECT COALESCE(max(standard), 30) AS standard
FROM standardTime
WHERE distance = _distance
AND unit = _unit
AND TIME_TO_SEC(standardTime) <= TIME_TO_SEC(_raceTime));

RETURN _standard;
END $$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `GetRaceDistanceKm` $$
CREATE DEFINER=``@`` FUNCTION `GetRaceDistanceKm`(_distance DOUBLE, _unit ENUM('KM','Mile')) RETURNS double
BEGIN

SET _distance = IF (_unit = 'Mile', _distance * 1.609344, _distance);
RETURN  _distance;

END $$

DELIMITER ;
 
DELIMITER $$

DROP FUNCTION IF EXISTS `getLeaguePointsTotal` $$
CREATE FUNCTION `getLeaguePointsTotal`(_leagueId INT(11), _runnerId INT(11)) RETURNS double
BEGIN
DECLARE _pointsTotal DOUBLE;

SET _pointsTotal =
(
  SELECT SUM(points)
  FROM
   (
    SELECT points
    FROM RaceResult rr
    JOIN Race ra ON rr.race = ra.id
    JOIN Event e ON ra.event = e.id
    JOIN LeagueEvent le ON e.id = le.event
    WHERE runner=_runnerId AND le.league=_leagueId
    ORDER BY points DESC LIMIT 8
   ) AS Best8
);

RETURN _pointsTotal;

END $$

DELIMITER ;
