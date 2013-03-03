-- phpMyAdmin SQL Dump
-- version 3.3.10.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 03, 2011 at 01:08 PM
-- Server version: 5.0.91
-- PHP Version: 5.2.9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `bhaaie_members`
--
-- CREATE DATABASE `bhaaie_members` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `bhaaie_members`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `addAllRacePoints`(_race int)
BEGIN
    
    delete from racepoints where race = _race;

    insert into racepoints(race, runner, pointsbystandard, pointsbyscoringset)
    select 
    race, 
    runner, 
    10.1 - (positioninstandard  * 0.1) as pointsbystandard,
    10.1 - (positioninscoringset  * 0.1) as pointsbyscoringset
    from racepointsdata where race = _race;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `addRaceOrganiser`(_league INT, _race INT, _runner INT)
MAIN_BLOCK:BEGIN

DECLARE _points DOUBLE;
DECLARE _pointsTotal DOUBLE;

IF EXISTS (SELECT runner FROM raceresult WHERE race=_race AND runner=_runner AND class='RACE_ORG') THEN
	LEAVE MAIN_BLOCK;
END IF;

IF EXISTS (SELECT runner FROM raceresult WHERE race=_race AND runner=_runner AND class='RAN') THEN
	LEAVE MAIN_BLOCK;
END IF;

IF EXISTS (SELECT id FROM runner WHERE status <> 'M' AND id = _runner) THEN
	SET _points = 0;
ELSE
	SET _points = 11; 
END IF;

INSERT INTO raceresult(race,runner,company,companyname, points,class)
SELECT _race, _runner, r.company, c.name, _points, 'RACE_ORG'
FROM runner r
LEFT JOIN company c ON r.company = c.id
WHERE r.id = _runner;

SET _pointsTotal = getLeaguePointsTotal(_league, _runner);

UPDATE leaguerunnerdata
SET pointsTotal = _pointsTotal
WHERE league=_league and runner=_runner;


END MAIN_BLOCK$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `addRacePointDataPositions`(_race int)
BEGIN

    declare _raceType enum('M','W','C');

    update racepointsdata
    set positioninstandard = null,positioninscoringset = null,positioninagecategory = null
    where race = _race;

    set _raceType = (select type from race where id=_race);

    create temporary table if not exists  tmpPosInAgeCat (
        id int auto_increment,
        agecategory varchar(4),
        gender enum('M','W','N'),
        runner int,
        primary key(agecategory,gender,id)
      )ENGINE=MyISAM;
      
      
    create temporary table if not exists  tmpPosInStandard (
        id int auto_increment,
        standard int,
        gender enum('M','W','N'),
        runner int,
        primary key(standard,gender,id)
      )ENGINE=MyISAM;
      
    create temporary table if not exists  tmpPosInSet (
        id int auto_increment,
        scoringset int,
        gender enum('M','W','N'),
        runner int,
        primary key(scoringset,gender,id)
      )ENGINE=MyISAM;

  	

    if (_raceType = 'C') then
        insert into tmpPosInStandard(runner, standard,gender)       
        select rr.runner, rr.standard ,'W'
        from raceresult rr
        join runner ru on rr.runner = ru.id
        where rr.race = _race 
        and rr.class='RAN' 
        and ru.gender='W' 
        and ru.status='M' 
        and rr.standard is not null
        order by rr.position asc;
 
        insert into tmpPosInStandard(runner, standard,gender)       
        select rr.runner, rr.standard, 'M' 
        from raceresult rr
        join runner ru on rr.runner = ru.id
        where rr.race = _race 
        and rr.class='RAN' 
        and ru.gender='M' 
        and ru.status='M' 
        and rr.standard is not null
        order by rr.position asc;
       
        insert into tmpPosInSet(runner, scoringset,gender)  a
        select rd.runner,rd.standardscoringset, 'W' 
        from racepointsdata rd
        join raceresult rr on rd.runner=rr.runner and rd.race=rr.race
        where rd.race = _race and rd.gender='W'
        order by rr.position asc;

        insert into tmpPosInSet(runner, scoringset,gender)  
        select rd.runner,rd.standardscoringset, 'M' 
        from racepointsdata rd
        join raceresult rr on rd.runner=rr.runner and rd.race=rr.race
        where rd.race = _race and rd.gender='M'
        order by rr.position asc;

        insert into tmpPosInAgeCat(runner, agecategory, gender)
        select ru.id, getagecategory(ru.dateofbirth, curdate(), ru.gender, 0)  as agecat, 'W'
        from raceresult rr
        join runner ru on rr.runner=ru.id
        where rr.race=_race and ru.status='m'and class='RAN'and ru.gender= 'W'
        order by rr.position asc;
        
        insert into tmpPosInAgeCat(runner, agecategory, gender)
        select ru.id, getagecategory(ru.dateofbirth, curdate(), ru.gender, 0)  as agecat, 'M'
        from raceresult rr
        join runner ru on rr.runner=ru.id
        where rr.race=_race and ru.status='m'and class='RAN'and ru.gender= 'M'
        order by rr.position asc;

    else
    
        insert into tmpPosInStandard(runner, standard, gender)       
        select rr.runner, rr.standard, 'N' 
        from raceresult rr
        join runner ru on rr.runner = ru.id
        where rr.race = _race 
        and rr.class='RAN' 
        and ru.status='M' 
        and rr.standard is not null
        order by rr.position asc;

        insert into tmpPosInSet(runner, scoringset, gender)  
        select rd.runner,rd.standardscoringset, 'N' 
        from racepointsdata rd
        join raceresult rr on rd.runner=rr.runner and rd.race=rr.race
        where rd.race = _race 
        order by rr.position asc;

        insert into tmpPosInAgeCat(runner, agecategory, gender)  
        select ru.id, getagecategory(ru.dateofbirth, curdate(), ru.gender, 0)  as agecat, 'N'
        from raceresult rr
        join runner ru on rr.runner=ru.id
        where rr.race=_race and ru.status='M'and class='RAN'
        order by rr.position asc;

    end if;
    
    update racepointsdata, tmpPosInStandard
    set racepointsdata.positioninstandard = tmpPosInStandard.id
    where racepointsdata.runner = tmpPosInStandard.runner and racepointsdata.race = _race;

    drop table tmpPosInStandard;
    
    update racepointsdata, tmpPosInSet
    set racepointsdata.positioninscoringset = tmpPosInSet.id
    where racepointsdata.runner = tmpPosInSet.runner and racepointsdata.race = _race;

    drop table tmpPosInSet;
    
    update racepointsdata, tmpPosInAgeCat
    set racepointsdata.positioninagecategory = tmpPosInAgeCat.id
    where racepointsdata.runner = tmpPosInAgeCat.runner and racepointsdata.race = _race;

    drop table tmpPosInAgeCat;

  
END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `addRacePointsDataScoringSets`(_race INT)
BEGIN

	declare _raceType enum('m','w','c');
	declare _scoringthreshold int;
	declare _currentstandard int;
	declare _runningtotal int;
	declare _runningtotalM int;
	declare _runningtotalW int;
	declare _scoringset int;
	declare _scoringsetM int;
	declare _scoringsetW int;
	
	set _scoringthreshold =
        (   select l.scoringthreshold
            from league l,leagueevent le,event e,race r
            where l.id=le.league and le.event=e.id and e.id=r.event
            and r.id = _race and l.type='I'
            limit 1
        );

        set _currentstandard = 30;
	set _runningtotal = 0;
	set _runningtotalM = 0;
	set _runningtotalW = 0;
	set _scoringset = 1;
	set _scoringsetM = 1;
	set _scoringsetW = 1;

    update racepointsdata set standardscoringset = null where race = _race;
    
    create temporary table if not exists scoringstandardsets(
                                                                standard int, 
                                                                gender enum('M','W') null, 
                                                                standardcount int null, 
                                                                scoringset int null);

    set _raceType = (select type from race where id=_race);
    
    if (_raceType = 'C') then
		
		insert into scoringstandardsets(standard, standardcount,scoringset, gender)
			select standard,0,0,'W' from standard
		union
			select standard,0,0,'M' from standard;
		
        update scoringstandardsets ss,
        (
            select r.preracestandard, r.gender, count(r.preracestandard) as standardcount
            from racepointsdata r
            where r.race = _race
            group by r.preracestandard, r.gender
        ) x
        set ss.standardcount = x.standardcount
        where ss.standard = x.preracestandard and  ss.gender = x.gender;
        
        while (_currentstandard > 0) do
			
            set _runningtotalM =
                (select sum(standardcount)
                from scoringstandardsets
                where standard >= _currentstandard and scoringset =0 and gender='M');

            set _runningtotalW =
                (select sum(standardcount)
                from scoringstandardsets
                where standard >= _currentstandard and scoringset =0 and gender='W');
                
            if (_runningtotalM >= _scoringthreshold) then
                
                update scoringstandardsets 
                set scoringset= _scoringsetM 
                where standard >= _currentstandard 
                and scoringset=0 
                and gender='M';
                
                set _scoringsetM = _scoringsetM + 1;
                set _runningtotalM = 0;
            end if;
            
            if (_runningtotalW >= _scoringthreshold) then
                
                update scoringstandardsets 
                set scoringset= _scoringsetW 
                where standard >= _currentstandard 
                and scoringset=0 
                and gender='W';
                
                set _scoringsetW = _scoringsetW + 1;
                set _runningtotalW = 0;
                
            end if;
            
            set _currentstandard = _currentstandard-1;
        end while;
    
		update scoringstandardsets set scoringset= _scoringsetW where scoringset=0 and gender='W';    
    update scoringstandardsets set scoringset= _scoringsetM where scoringset=0 and gender='M';    

		update racepointsdata, scoringstandardsets
		set racepointsdata.standardscoringset = scoringstandardsets.scoringset
		where scoringstandardsets.standard = racepointsdata.preracestandard 
    and racepointsdata.gender = scoringstandardsets.gender;
    
    else
		insert into scoringstandardsets(standard, standardcount,scoringset)
			select standard,0,0 from standard order by standard desc;
		
        update scoringstandardsets ss,
        (
            select r.gender, r.preracestandard, count(r.preracestandard) as standardcount
            from racepointsdata r
            where r.race = _race
            group by r.preracestandard, r.gender
         ) x
        set ss.gender=x.gender, ss.standardcount = x.standardcount
        where ss.standard = x.preracestandard;
        
        while (_currentstandard > 0) do
            set _runningtotal =
            (select sum(standardcount)
            from scoringstandardsets
            where standard >= _currentstandard and scoringset =0);

            if (_runningtotal >= _scoringthreshold) then
                update scoringstandardsets set scoringset= _scoringset where standard >= _currentstandard and scoringset=0;
                set _scoringset = _scoringset+1;
                set _runningtotal = 0;
            end if;

            set _currentstandard = _currentstandard-1;
        end while;
        
		update scoringstandardsets set scoringset= _scoringset where scoringset=0;

		update racepointsdata, scoringstandardsets
		set racepointsdata.standardscoringset = scoringstandardsets.scoringset
		where scoringstandardsets.standard = racepointsdata.preracestandard;
		
    end if;

	drop table scoringstandardsets;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `addRaceVolunteer`(_league INT, _race INT, _runner INT)
MAIN_BLOCK:BEGIN

IF EXISTS (SELECT runner FROM raceresult WHERE race=_race AND runner=_runner AND class='RACE_VOL') THEN
	LEAVE MAIN_BLOCK;
END IF;

INSERT INTO raceresult(race,runner,company,companyname, points,class)
SELECT _race, _runner, r.company, c.name, 0, 'RACE_VOL'
FROM runner r
LEFT JOIN company c ON r.company = c.id
WHERE r.id = _runner;


END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `AddRunnerToMobileAccount`(_runner int)
BEGIN

DECLARE _account INT;

SET _account =
  (
  select account
  from textalert
  group by account
  having count(runner) <125
  limit 1
  );

if (_account is not null) then

  if not exists (select runner from textalert where runner =_runner) then
    insert into textalert(runner, account,startdate)
    values(_runner, _account, curdate());
  end if;

end if;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `addScoringLadiesTeams`(_leagueId INT, _raceId INT)
BEGIN


INSERT INTO teamraceresult(league,race,team, class, status)
SELECT _leagueId as league, _raceId as race, tm.team, 'W', 'PENDING'
FROM   raceresult rr
JOIN   runner r ON rr.runner = r.id
JOIN   teammember tm ON r.id = tm.runner
JOIN   team t ON tm.team = t.id
JOIN   race ra ON rr.race = ra.id
JOIN   event e ON ra.event = e.id
WHERE  rr.race=_raceId
AND t.status='ACTIVE'
AND r.Gender = 'W'
AND r.Status='M'
AND r.dateofrenewal <= e.date
AND t.formationdate <= e.date
AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
GROUP BY t.id
HAVING count(t.id) >=3;

UPDATE
teamraceresult X,
(
	 SELECT b.team,r.id
	 FROM raceresult rr
	 JOIN runner r on rr.runner = r.id
	 JOIN
	 (
		SELECT MIN(rr.position) AS position,  tm.team
		FROM raceresult rr
		JOIN runner r ON rr.runner = r.id
		JOIN   teammember tm ON r.id = tm.runner
    JOIN   team t ON tm.team = t.id
    JOIN   race ra ON rr.race = ra.id
    JOIN   event e ON ra.event = e.id
		JOIN   teamraceresult trr ON t.id=trr.team and trr.race=_raceId and trr.league=_leagueId
		WHERE rr.race=_raceId and r.gender='W'
    AND r.dateofrenewal <= e.date
    AND t.formationdate <= e.date
    AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
		GROUP BY tm.team
	) b
	USING (position)
	WHERE race=_raceId
) Y
SET X.runnerFirst = Y.id
WHERE X.team=Y.team and X.race=_raceId and X.league=_leagueId;

UPDATE
teamraceresult X,
(
	 SELECT b.team,r.id
	 FROM raceresult rr
	 JOIN runner r on rr.runner = r.id
	 JOIN
	 (
		SELECT MIN(rr.position) AS position,  tm.team
		FROM raceresult rr
		JOIN runner r ON rr.runner = r.id
    JOIN   teammember tm ON r.id = tm.runner
		JOIN team t ON tm.team = t.id
    JOIN   race ra ON rr.race = ra.id
    JOIN   event e ON ra.event = e.id
		JOIN   teamraceresult trr ON t.id=trr.team and trr.race=_raceId and trr.league=_leagueId
		WHERE rr.race=_raceId and r.gender='W' and r.id <> trr.runnerFirst
    AND r.dateofrenewal <= e.date
    AND t.formationdate <= e.date
    AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
    GROUP BY tm.team
	) b
	USING (position)
	WHERE race=_raceId
) Y
SET X.runnerSecond = Y.id
WHERE X.team=Y.team and X.race=_raceId and X.league=_leagueId;

UPDATE
teamraceresult X,
(
	 SELECT b.team,r.id
	 FROM raceresult rr
	 JOIN runner r on rr.runner = r.id
	 JOIN
	 (
		SELECT MIN(rr.position) AS position,  tm.team
		FROM raceresult rr
		JOIN runner r ON rr.runner = r.id
    JOIN   teammember tm ON r.id = tm.runner
    JOIN team t ON tm.team = t.id
    JOIN   race ra ON rr.race = ra.id
    JOIN   event e ON ra.event = e.id
		JOIN   teamraceresult trr ON t.id=trr.team and trr.race=_raceId and trr.league=_leagueId
		WHERE rr.race=_raceId and r.gender='W'
                   and (r.id <> trr.runnerFirst and r.id <> trr.runnerSecond)
    AND r.dateofrenewal <= e.date
    AND t.formationdate <= e.date
    AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
    GROUP BY tm.team
	) b
	USING (position)
	WHERE race=_raceId
) Y
SET X.runnerThird = Y.id
WHERE X.team=Y.team and X.race=_raceId and X.league=_leagueId;


END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `addScoringMensTeams`(_leagueId INT, _raceId INT)
BEGIN
DECLARE _mostRunnerCount INT;

CREATE TEMPORARY TABLE usedrunners(id INT);

INSERT INTO usedrunners
SELECT runnerFirst FROM teamraceresult WHERE race=_raceId and status='ACTIVE'
UNION
SELECT runnerSecond FROM teamraceresult WHERE race=_raceId and status='ACTIVE'
UNION
SELECT runnerThird FROM teamraceresult WHERE race=_raceId and status='ACTIVE';


SET _mostRunnerCount =
(
SELECT count(t.id) as runnerCount
FROM   raceresult rr
JOIN   runner r ON rr.runner = r.id
JOIN   teammember tm ON r.id = tm.runner
JOIN   team t ON tm.team = t.id
JOIN   race ra ON rr.race = ra.id
JOIN   event e ON ra.event = e.id
WHERE  rr.race=_raceId
AND t.status='ACTIVE'
AND r.Status='M'
AND rr.Standard IS NOT NULL
AND r.dateofrenewal <= e.date
AND t.formationdate <= e.date
AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
AND r.id NOT IN (SELECT id FROM usedrunners)
GROUP BY t.id
HAVING runnerCount >=3
ORDER by runnerCount DESC
LIMIT 1
);

DROP TABLE usedrunners;
IF _mostRunnerCount >= 3 THEN
CALL addScoringMensTeamsByRunnerCount(_leagueId,_raceId,3);
END IF;

IF _mostRunnerCount >= 6 THEN
CALL addScoringMensTeamsByRunnerCount(_leagueId,_raceId,6);
END IF;


IF _mostRunnerCount >= 9 THEN
CALL addScoringMensTeamsByRunnerCount(_leagueId,_raceId,9);
END IF;


IF _mostRunnerCount >= 12 THEN
CALL addScoringMensTeamsByRunnerCount(_leagueId,_raceId,12);
END IF;


IF _mostRunnerCount >= 15 THEN
CALL addScoringMensTeamsByRunnerCount(_leagueId,_raceId,15);
END IF;


IF _mostRunnerCount >= 18 THEN
CALL addScoringMensTeamsByRunnerCount(_leagueId,_raceId,18);
END IF;


IF _mostRunnerCount >= 21 THEN
CALL addScoringMensTeamsByRunnerCount(_leagueId,_raceId,21);
END IF;


END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `addScoringMensTeamsByRunnerCount`(_leagueId INT, _raceId INT, _runnerCount INT)
BEGIN
CREATE TEMPORARY TABLE usedrunners(id INT);

INSERT INTO usedrunners
SELECT runnerFirst FROM teamraceresult WHERE race=_raceId and status='ACTIVE'
UNION
SELECT runnerSecond FROM teamraceresult WHERE race=_raceId and status='ACTIVE'
UNION
SELECT runnerThird FROM teamraceresult WHERE race=_raceId and status='ACTIVE';


INSERT INTO teamraceresult(league,race,team,status)
SELECT _leagueId as league, _raceId as race, tm.team, 'PENDING'
FROM   raceresult rr
JOIN   runner r ON rr.runner = r.id
JOIN   teammember tm ON r.id = tm.runner
JOIN   team t ON tm.team = t.id
JOIN   race ra ON rr.race = ra.id
JOIN   event e ON ra.event = e.id
WHERE  rr.race=_raceId
AND rr.standard IS NOT NULL
AND t.status='ACTIVE'
AND r.Status='M'
AND r.dateofrenewal <= e.date
AND t.formationdate <= e.date
AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
AND r.id NOT IN (SELECT id FROM usedrunners)
GROUP BY t.id
HAVING count(t.id) >=_runnerCount;

UPDATE
teamraceresult X,
(
	 SELECT b.team,r.id
	 FROM raceresult rr
	 JOIN runner r on rr.runner = r.id
	 JOIN
	 (
    SELECT MIN(rr.position) AS position,  tm.team
    FROM raceresult rr
    JOIN teammember tm ON rr.runner = tm.runner
    JOIN runner r ON tm.runner = r.id
    JOIN race ra ON rr.race = ra.id
    JOIN event e ON ra.event = e.id
    JOIN team t  ON tm.team=t.id
    LEFT JOIN teamraceresult trr1 on rr.runner = trr1.runnerfirst and trr1.race = _raceId
    LEFT JOIN teamraceresult trr2 on rr.runner = trr2.runnersecond and trr2.race = _raceId
    LEFT JOIN teamraceresult trr3 on rr.runner = trr3.runnerthird and trr3.race = _raceId
    WHERE rr.race=_raceId
    AND rr.standard IS NOT NULL
    AND trr1.runnerfirst IS NULL
    AND trr2.runnersecond IS NULL
    AND trr3.runnerthird IS NULL
    AND r.dateofrenewal <= e.date
    AND t.formationdate <= e.date
    AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
    AND r.id NOT IN (SELECT id FROM usedrunners)
    GROUP BY tm.team
	) b
	USING (position)
	WHERE race=_raceId
) Y
SET X.runnerfirst = Y.id
WHERE X.team=Y.team and X.race=_raceId and X.league=_leagueId and X.runnerfirst IS NULL;

UPDATE
teamraceresult X,
(
	 SELECT b.team,r.id
	 FROM raceresult rr
	 JOIN runner r on rr.runner = r.id
	 JOIN
	 (
    SELECT MIN(rr.position) AS position,  tm.team
    FROM raceresult rr
    JOIN teammember tm ON rr.runner = tm.runner
    JOIN runner r ON tm.runner = r.id
    JOIN race ra ON rr.race = ra.id
    JOIN event e ON ra.event = e.id
    JOIN team t  ON tm.team=t.id
    LEFT JOIN teamraceresult trr1 on rr.runner = trr1.runnerfirst and trr1.race = _raceId
    LEFT JOIN teamraceresult trr2 on rr.runner = trr2.runnersecond and trr2.race = _raceId
    LEFT JOIN teamraceresult trr3 on rr.runner = trr3.runnerthird and trr3.race = _raceId
    WHERE rr.race=_raceId
    AND rr.standard IS NOT NULL
    AND trr1.runnerfirst IS NULL
    AND trr2.runnersecond IS NULL
    AND trr3.runnerthird IS NULL
    AND r.dateofrenewal <= e.date
    AND t.formationdate <= e.date
    AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
    AND r.id NOT IN (SELECT id FROM usedrunners)
    GROUP BY tm.team
	) b
	USING (position)
	WHERE race=_raceId
) Y
SET X.runnersecond = Y.id
WHERE X.team=Y.team and X.race=_raceId and X.league=_leagueId and X.runnersecond IS NULL;

UPDATE
teamraceresult X,
(
	 SELECT b.team,r.id
	 FROM raceresult rr
	 JOIN runner r on rr.runner = r.id
	 JOIN
	 (
    SELECT MIN(rr.position) AS position,  tm.team
    FROM raceresult rr
    JOIN teammember tm ON rr.runner = tm.runner
    JOIN runner r ON tm.runner = r.id
    JOIN race ra ON rr.race = ra.id
    JOIN event e ON ra.event = e.id
    JOIN team t  ON tm.team=t.id
    LEFT JOIN teamraceresult trr1 on rr.runner = trr1.runnerfirst and trr1.race = _raceId
    LEFT JOIN teamraceresult trr2 on rr.runner = trr2.runnersecond and trr2.race = _raceId
    LEFT JOIN teamraceresult trr3 on rr.runner = trr3.runnerthird and trr3.race = _raceId
    WHERE rr.race=_raceId
    AND rr.standard IS NOT NULL
    AND trr1.runnerfirst IS NULL
    AND trr2.runnersecond IS NULL
    AND trr3.runnerthird IS NULL
    AND r.dateofrenewal <= e.date
    AND t.formationdate <= e.date
    AND e.date BETWEEN tm.joindate AND COALESCE(tm.leavedate,e.date)
    AND r.id NOT IN (SELECT id FROM usedrunners)
    GROUP BY tm.team
	) b
	USING (position)
	WHERE race=_raceId
) Y
SET X.runnerthird = Y.id
WHERE X.team=Y.team and X.race=_raceId and X.league=_leagueId and X.runnerthird IS NULL;

DROP TABLE usedrunners;



END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `addScoringTeams`(_leagueId INT, _raceId INT, _gender ENUM('M','W'))
BEGIN
  IF _gender = 'M' THEN
		CALL addScoringMensTeams(_leagueId, _raceId);
	ELSE
		CALL addScoringLadiesTeams(_leagueId, _raceId);
	END IF;
END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `applyNewRunnerStandard`(_race INT, _runner INT, _standard INT)
BEGIN
START TRANSACTION;

UPDATE raceresult
SET postRaceStandard = _standard
WHERE race = _race AND runner = _runner;

UPDATE runner
SET standard = _standard
WHERE id = _runner;


COMMIT;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `clearEventResultsData`(_eventId INT(11))
BEGIN

UPDATE raceresult, race, event
SET raceresult.paceKm = NULL, raceresult.points = NULL, raceresult.postRaceStandard = NULL
WHERE raceresult.race = race.Id
AND race.event = _eventId
AND raceresult.class = 'RAN';

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `clearLeagueAndResultsData`(_leagueId INT(11))
BEGIN

UPDATE raceresult, race, event, leagueevent
SET raceresult.paceKm = NULL, raceresult.points = NULL, raceresult.postRaceStandard = NULL
WHERE raceresult.race = race.Id 
AND race.event = event.Id 
AND event.Id=leagueevent.event 
AND leagueevent.league=_leagueId;

DELETE FROM leaguerunnerdata WHERE league=_leagueId;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `createscoringsets`(_scoringthreshold int, _race int, _gender enum('m','w'))
BEGIN

set @currentstandard:=30;
set @runningtotal:=0;
set @scoringset:=1;


create temporary table if not exists scoringstandardsets(standard int, standardcount int null, scoringset int null);

insert into scoringstandardsets(standard, standardcount,scoringset)
select standard,0,0 from standard order by standard desc;

update scoringstandardsets ss,
(
    select rr.standard, count(rr.standard) as standardcount
    from raceresult rr
    join runner ru on rr.runner=ru.id
    where rr.race= _race and ru.status='m' and ru.gender=_gender and rr.standard is not null
    group by rr.standard
) x
set ss.standardcount = x.standardcount
where ss.standard = x.standard;

while (@currentstandard > 0) do

    set @runningtotal = 
    (select sum(standardcount)  
    from scoringstandardsets
    where standard >= @currentstandard and scoringset =0);

    if (@runningtotal >= _scoringthreshold) then
        update scoringstandardsets set scoringset= @scoringset where standard >= @currentstandard and scoringset=0;
        set @scoringset = @scoringset+1;
        set @runningtotal = 0;
    end if;    
    
    set @currentstandard = @currentstandard-1;

end while;

update scoringstandardsets set scoringset= @scoringset where scoringset=0;

select count(standard) as standardsinset, sum(standardcount) as runnersinset, scoringset
from scoringstandardsets
group by scoringset;
select * from scoringstandardsets;


drop table scoringstandardsets;


END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `getAllTop3ByEvent`(_eventId INT)
BEGIN

  DECLARE _nextAgeCategory VARCHAR(4);
  DECLARE no_more_rows BOOLEAN;
  DECLARE loop_cntr INT DEFAULT 0;
  DECLARE num_rows INT DEFAULT 0;
  DECLARE _categoryCursor CURSOR FOR SELECT category FROM agecategory WHERE category not in ('SM','JM','SW','JW');
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;

  CREATE TEMPORARY TABLE top3Result(catPosition INT PRIMARY KEY AUTO_INCREMENT, id INT, agecategory VARCHAR(4), gender ENUM('M','W'), raceId INT, actualPosition INT);
  CREATE TEMPORARY TABLE reservedPositions(position INT);

  INSERT INTO top3Result(id,agecategory,gender, raceId, actualPosition)
  SELECT r.id, null, r.gender, ra.id, rr.position
  FROM raceresult rr
  JOIN runner r ON rr.runner = r.id
  JOIN race ra ON rr.race = ra.id
  WHERE ra.event = _eventId
  AND rr.class = 'RAN'
  AND r.gender='M'
  AND ra.type <> 'W'
  ORDER BY position ASC
  LIMIT 3;

  INSERT INTO top3Result(id,agecategory,gender, raceId, actualPosition)
  SELECT r.id, null, r.gender, ra.id, rr.position
  FROM raceresult rr
  JOIN runner r ON rr.runner = r.id
  JOIN race ra ON rr.race = ra.id
  WHERE ra.event = _eventId
  AND rr.class = 'RAN'
  AND r.gender='W'
  AND ra.type <> 'M'
  ORDER BY position ASC
  LIMIT 3;

  INSERT INTO reservedPositions
  SELECT actualPosition FROM top3Result;

  OPEN _categoryCursor;
  SELECT FOUND_ROWS() into num_rows;

  the_loop: LOOP

    FETCH  _categoryCursor
    INTO   _nextAgeCategory;

    IF no_more_rows THEN
        CLOSE _categoryCursor;
        LEAVE the_loop;
    END IF;

    INSERT INTO top3Result(id,agecategory,gender,raceid)
    SELECT r.id, _nextAgeCategory, r.gender,ra.id
    FROM raceresult rr
    JOIN runner r ON rr.runner = r.id
    JOIN race ra ON rr.race = ra.id
    WHERE ra.event = _eventId
    AND rr.category = _nextAgeCategory
    AND rr.position not in (SELECT position FROM reservedPositions)
    AND rr.class = 'RAN'
    ORDER BY position ASC
    LIMIT 3;

    SET loop_cntr = loop_cntr + 1;

  END LOOP the_loop;

  DROP TABLE reservedPositions;

  SELECT rr.racetime, rr.position, t3.agecategory, r.gender, r.firstname, r.surname, t.name as teamname, COALESCE(rr.companyname,c.name) AS companyname
  FROM  top3Result t3
  JOIN raceresult rr ON t3.Id = rr.runner
  JOIN race ra ON rr.race = ra.id and ra.event = _eventId
  JOIN runner r ON rr.runner = r.id
  LEFT JOIN teammember tm ON r.id = tm.runner
  LEFT JOIN team t ON tm.team=t.id
  LEFT JOIN company c ON r.company = c.id
  ORDER BY r.gender,t3.catPosition, t3.agecategory;

  DROP TABLE top3Result;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `getAllTop3ByRace`(_race INT, _gender ENUM('M','W'))
BEGIN


  DECLARE _nextAgeCategory VARCHAR(4);
  DECLARE no_more_rows BOOLEAN;
  DECLARE loop_cntr INT DEFAULT 0;
  DECLARE num_rows INT DEFAULT 0;
  DECLARE _categoryCursor CURSOR FOR SELECT category FROM agecategory WHERE gender = _gender and category not in ('SM','JM','SW','JW');
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;

  CREATE TEMPORARY TABLE top3Result(catPosition INT PRIMARY KEY AUTO_INCREMENT, id INT, agecategory VARCHAR(4), gender ENUM('M','W'));

  INSERT INTO top3Result(id,agecategory,gender)
  SELECT r.id, null, _gender
  FROM raceresult rr
  JOIN runner r ON rr.runner = r.id
  WHERE rr.race = _race
  AND r.gender = _gender
  AND rr.class = 'RAN'
  ORDER BY position ASC
  LIMIT 3;

  OPEN _categoryCursor;
  SELECT FOUND_ROWS() into num_rows;

  the_loop: LOOP

    FETCH  _categoryCursor
    INTO   _nextAgeCategory;

    IF no_more_rows THEN
        CLOSE _categoryCursor;
        LEAVE the_loop;
    END IF;

    INSERT INTO top3Result(id,agecategory,gender)
    SELECT r.id, _nextAgeCategory, _gender
    FROM raceresult rr
    JOIN runner r ON rr.runner = r.id
    WHERE rr.race = _race
    AND rr.category = _nextAgeCategory
    AND r.gender = _gender
    AND rr.position > 3
    AND rr.class = 'RAN'
    ORDER BY position ASC
    LIMIT 3;

    SET loop_cntr = loop_cntr + 1;

  END LOOP the_loop;

  SELECT t3.agecategory, r.firstname, r.surname, t.name as teamname, COALESCE(rr.companyname,c.name) AS companyname
FROM
top3Result t3
JOIN raceresult rr ON t3.Id = rr.runner AND rr.race = _race
JOIN runner r ON rr.runner = r.id
LEFT JOIN teammember tm ON r.id = tm.runner
LEFT JOIN team t ON tm.team=t.id
LEFT JOIN company c ON r.company = c.id
ORDER BY t3.catPosition, t3.agecategory;


  DROP TABLE top3Result;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `getAllTop3TeamByEvent`(_eventId INT)
BEGIN
(
SELECT id,name,standardtotal,positiontotal,class
FROM
(
 SELECT t.id,t.name, trr.standardtotal,trr.positiontotal, 'W' AS class
 FROM teamraceresult trr
 JOIN team t on trr.team=t.id
 JOIN race ra ON trr.race = ra.id
 WHERE ra.event = _eventId
 AND trr.class = 'W'
 ORDER BY positiontotal ASC
) t
LIMIT 3
)
UNION
(
SELECT id,name,standardtotal,positiontotal,class
FROM
(
 SELECT t.id,t.name, trr.standardtotal,trr.positiontotal, 'A' AS class
 FROM teamraceresult trr
 JOIN team t on trr.team=t.id
 JOIN race ra ON trr.race = ra.id
 WHERE ra.event = _eventId
 AND trr.class = 'A'
 ORDER BY positiontotal ASC
) t
LIMIT 3
)
UNION
(
SELECT id,name,standardtotal,positiontotal,class
FROM
(
 SELECT t.id,t.name, trr.standardtotal,trr.positiontotal, 'B' AS class
 FROM teamraceresult trr
 JOIN team t on trr.team=t.id
 JOIN race ra ON trr.race = ra.id
 WHERE ra.event = _eventId
 AND trr.class = 'B'
 ORDER BY positiontotal ASC
) t
LIMIT 3
)
UNION
(
SELECT id,name,standardtotal,positiontotal,class
FROM
(
 SELECT t.id,t.name, trr.standardtotal,trr.positiontotal, 'C' AS class
 FROM teamraceresult trr
 JOIN team t on trr.team=t.id
 JOIN race ra ON trr.race = ra.id
 WHERE ra.event = _eventId
 AND trr.class = 'C'
 ORDER BY positiontotal ASC
) t
LIMIT 3
)
UNION
(
SELECT id,name,standardtotal,positiontotal,class
FROM
(
 SELECT t.id,t.name, trr.standardtotal,trr.positiontotal, 'D' AS class
 FROM teamraceresult trr
 JOIN team t on trr.team=t.id
 JOIN race ra ON trr.race = ra.id
 WHERE ra.event = _eventId
 AND trr.class = 'D'
 ORDER BY positiontotal ASC
) t
LIMIT 3
);
END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `getDayRunnerMatchesByEvent`(_eventId INT)
BEGIN



SELECT
ru.firstname,ru.surname,rr.position, ra.id,ru2.id as memberid,ru.id as dayid
FROM raceresult rr, runner ru, race ra, runner ru2
WHERE rr.runner=ru.id AND rr.race=ra.id and ru.firstname=ru2.firstname AND ru.surname=ru2.surname
AND ru.status != 'M' AND rr.class='RAN' AND ra.event =_eventId AND ru2.status != 'D';

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `getMatchingRunnersByEvent`(_eventId INT)
BEGIN
CREATE TEMPORARY TABLE IF NOT EXISTS tmpmatches(id INT, matchedid INT, relevance enum('a','b','c'));

INSERT INTO tmpmatches(id,matchedid,relevance)
SELECT
ru.id, 
ru_match.id,
'a'
FROM raceresult rr
INNER JOIN runner ru ON ru .id=rr.runner 
INNER JOIN race ra ON ra.id=rr.race 
INNER JOIN event e ON e.id=ra.event
INNER JOIN runner ru_match 
    ON ru.surname = ru_match.surname
    AND ru.dateofbirth = ru_match.dateofbirth
    AND ru.firstname = ru_match.firstname
    and ru_match.status not in ('D', 'PRE_REG')
WHERE ru.status='D' AND rr.class='RAN' AND e.id = _eventId
ORDER by rr.position asc;


CREATE TEMPORARY TABLE IF NOT EXISTS tmpmatchesb LIKE tmpmatches;

INSERT INTO tmpmatchesb(id,matchedid,relevance)
SELECT 
ru.id, 
ru_match.id,
'b'
FROM raceresult rr
INNER JOIN runner ru ON ru .id=rr.runner 
INNER JOIN race ra ON ra.id=rr.race 
INNER JOIN event e ON e.id=ra.event
INNER JOIN runner ru_match     
    ON ru.surname = ru_match.surname
    AND ru.firstname = ru_match.firstname
    and ru_match.status not in ('D', 'PRE_REG')
WHERE ru.status='D' AND rr.class='RAN' AND e.id = _eventId
AND ru.id not in (select id from tmpmatches)
ORDER by rr.position asc;


INSERT INTO tmpmatches SELECT * FROM tmpmatchesb; 
TRUNCATE TABLE tmpmatchesb;

INSERT INTO tmpmatchesb(id,matchedid,relevance)
select x.id, x.matchedid, x.relevance
from
(
SELECT
ru.id, 
ru_match.id as matchedid,
'c' as relevance
FROM raceresult rr
INNER JOIN runner ru ON ru .id=rr.runner
INNER JOIN race ra ON ra.id=rr.race 
INNER JOIN event e ON e.id=ra.event
INNER JOIN runner ru_match 
    ON ru.surname = ru_match.surname
    AND ru.dateofbirth = ru_match.dateofbirth
and ru_match.status not in ('D', 'PRE_REG')
WHERE ru.status='D' AND rr.class='RAN' AND e.id = _eventId
AND ru.id not in (select id from tmpmatches)
ORDER by rr.position asc
) x;

INSERT INTO tmpmatches SELECT * FROM tmpmatchesb;


select rr.position,rr.racenumber,rr.race,r1.id,r1.firstname,r1.surname,r1.standard,r1.status,r1.dateofbirth,t.relevance,r2.id as rid,r2.firstname as rfirstname,r2.surname as rsurname,r2.standard as rstandard,r2.status as rstatus,r2.dateofbirth as rdateofbirth from raceresult rr
join runner r1 on rr.runner=r1.id
join race ra on rr.race = ra.id
join event e on ra.event = e.id
left join tmpmatches t on r1.id = t.id
left join runner r2 on t.matchedid=r2.id
where e.id=_eventId and r1.status='d'
order by rr.position asc;


DROP temporary table tmpmatches;
DROP temporary table tmpmatchesb;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `getTop3ByRace`(_race INT, _category VARCHAR(20), _gender ENUM('M','W'))
BEGIN

IF _category IS NOT NULL THEN

  SELECT r.firstname, r.surname, t.name
  FROM raceresult rr
  JOIN runner r ON rr.runner = r.id
  LEFT JOIN teammember tm ON r.id = tm.runner
  LEFT JOIN team t ON tm.team=t.id
  WHERE rr.race = _race
  AND rr.category = _category
  AND r.gender = _gender
  AND rr.position > 3
  ORDER BY position ASC
  LIMIT 3;

ELSE

  SELECT r.firstname, r.surname, t.name
  FROM raceresult rr
  JOIN runner r ON rr.runner = r.id
  LEFT JOIN teammember tm ON r.id = tm.runner
  LEFT JOIN team t ON tm.team=t.id
  WHERE rr.race = _race
  AND r.gender = _gender
  ORDER BY position ASC
  LIMIT 3;

END IF;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `initRacePointsData`(_race int)
begin

    delete from racepointsdata where race=_race;

    insert into racepointsdata(race,runner, preracestandard, gender)
    select
        raceresult.race,
        raceresult.runner,
        raceresult.standard,
        runner.gender
    from   raceresult, runner
    where
        raceresult.runner=runner.id
        and  raceresult.race =_race
        and runner.status ='M'
        and raceresult.standard is not null
        and raceresult.class='RAN';

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `listRunners`(_firstName VARCHAR(30), _surName VARCHAR(30), _dob DATE)
BEGIN



SET @sql = 'SELECT * FROM runner WHERE ';
SET @sqlWhere = '';

IF (_firstName IS NOT NULL) THEN
  SET @sqlWhere = CONCAT(@sqlWhere,'firstName like ''',_firstName,'''');
END IF;

IF (_surName IS NOT NULL) THEN
  IF (_firstName IS NOT NULL) THEN
    SET @sqlWhere = CONCAT(@sqlWhere,' AND ');
  END IF;
  SET @sqlWhere = CONCAT(@sqlWhere,'surname like ''',_surName,'''');
END IF;

IF (_dob IS NOT NULL) THEN
  IF (_firstName IS NOT NULL OR _surName IS NOT NULL) THEN
    SET @sqlWhere = CONCAT(@sqlWhere,' AND ');
  END IF;
  SET @sqlWhere = CONCAT(@sqlWhere,'dateOfBirth=''',_dob,'''');
END IF;

SET @sql = CONCAT(@sql,@sqlWhere);

PREPARE s1 FROM @sql;
EXECUTE s1;
DEALLOCATE PREPARE s1;



END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `migrateCompany`(_renewalDate DATE)
BEGIN
 
  
  UPDATE teammember tm
  JOIN team t ON tm.team = t.id AND t.type='c'
  JOIN runner r ON tm.runner = r.id
  SET tm.leavedate = CURRENT_DATE()
  WHERE t.status='active' AND tm.leavedate IS NULL AND r.company<>tm.team;

  
 INSERT INTO teammember (team,runner,joindate)
 SELECT t.id,r.id, CURRENT_DATE()
 FROM runner r
 LEFT JOIN teammember tm ON r.id=tm.runner and tm.leavedate IS NULL
 JOIN company c ON r.company=c.id
 JOIN team t ON c.id = t.id and t.type='C'
 WHERE r.dateofrenewal > COALESCE(_renewalDate,'2000-1-1')
 AND tm.team IS NULL
 AND r.status = 'M'
 AND t.status='ACTIVE';

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `migrateTeam`(_companyId INT(11))
BEGIN

INSERT INTO teammember(team,runner)
SELECT team.id, runner.id
FROM runner
JOIN team on team.id=runner.company
WHERE team.id=_companyId
AND team.status="ACTIVE"
AND runner.status="M"
AND runner.id NOT IN (SELECT runner FROM teammember WHERE runner.company=team.id);


END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `synchRaceResultByRaceId`(_race INT)
BEGIN
    update raceresult rr, racepointsdata rpd
    set 
        rr.positioninstandard = rpd.positioninstandard,
        rr.positioninagecategory = rpd.positioninagecategory
    where 
        rr.race = rpd.race and rr.runner=rpd.runner and rpd.race= _race;

    update raceresult rr, racepoints rp
    set 
        rr.points = rp.pointsbyscoringset   
    where 
        rr.race=rp.race and rr.runner=rp.runner and rp.race= _race;

    update raceresult rr, race ra
    set
        rr.paceKm = CalculateRunnerPaceKM(rr.racetime, ra.distance, ra.unit)
    where rr.race = ra.Id AND ra.Id = _race;
END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateIndividualLeagueSummary`(_leagueid INT)
BEGIN
 DECLARE _nextDivision VARCHAR(2);
   DECLARE no_more_rows BOOLEAN;
   DECLARE loop_cntr INT DEFAULT 0;
   DECLARE num_rows INT DEFAULT 0;
   DECLARE _divisionCursor CURSOR FOR SELECT code FROM division WHERE type ='I';
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;

DELETE FROM leaguesummary WHERE leagueType='I' and leagueId = _leagueId;
   OPEN _divisionCursor;
   SELECT FOUND_ROWS() into num_rows;

    the_loop: LOOP

    FETCH  _divisionCursor INTO   _nextDivision;

    IF no_more_rows THEN
        CLOSE _divisionCursor;
        LEAVE the_loop;
    END IF;

	INSERT INTO leaguesummary(
								leagueid, 
								leaguetype,
								leagueparticipantid, 
								leaguestandard, 
								leaguedivision,
								leagueposition,
								
previousleagueposition,
								leaguescorecount,
								leaguepoints)

	SELECT

	t1.leagueid,
	t1.leaguetype,
	t1.leagueparticipantid,
	t1.leaguestandard,
	t1.leagueclass,
	@rownum:=@rownum+1 AS currentLeaguePosition,
	t1.previousleagueposition,
	t1.leaguescorecount,
	t1.leaguepoints

	FROM
	(
	SELECT
	lrd.league AS leagueid,
	'I' AS leaguetype,
	lrd.runner AS leagueparticipantid,
	lrd.standard AS leaguestandard,
	d.code AS leagueclass,
	null AS previousleagueposition,
	lrd.racesComplete AS leaguescorecount,
	lrd.pointsTotal AS leaguepoints
	FROM leaguerunnerdata lrd
  JOIN runner r ON lrd.runner = r.id
	JOIN division d ON (lrd.standard BETWEEN d.min AND d.max) AND d.type='I' and 
d.gender= r.gender
	LEFT JOIN leaguesummary ls ON ls.leagueparticipantid = lrd.runner and 
ls.leagueId =
	lrd.league
	WHERE lrd.league = _leagueid AND d.code=_nextDivision
	ORDER BY lrd.pointsTotal desc, lrd.racesComplete desc, lrd.standard desc
	) t1, (SELECT @rownum:=0) t2;

    SET loop_cntr = loop_cntr + 1;

  END LOOP the_loop;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateLeagueData`(_leagueId INT(11))
BEGIN

  DELETE FROM leaguerunnerdata WHERE league=_leagueId;

  INSERT INTO leaguerunnerdata(league,runner,racesComplete, pointsTotal,avgOverallPosition, standard)
  SELECT
  le.league,
  rr.runner,
  COUNT(rr.race) as racesComplete,
  getLeaguePointsTotal(le.league, rr.runner) as pointsTotal,
  AVG(rr.position) as averageOverallPosition,
  ROUND(AVG(rr.standard),0) as standard

  FROM raceresult rr
  JOIN race ra ON rr.race = ra.id
  JOIN runner ru ON rr.runner = ru.id
  JOIN event e ON ra.event = e.id
  JOIN leagueevent le ON e.id = le.event
  WHERE le.league=_leagueId AND class='RAN' AND ru.standard IS NOT NULL AND ru.status='M'
  GROUP BY le.league,rr.runner
  HAVING COALESCE(pointsTotal, 0) > 0;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updatePaceByRaceId`(_raceId INT(11))
BEGIN

UPDATE raceresult, race
SET raceresult.paceKm = CalculateRunnerPaceKM(raceresult.racetime, race.distance, race.unit)
WHERE raceresult.race = race.Id AND race.Id = _raceId;

UPDATE raceresult, race
SET
raceresult.normalisedPaceKm = CalculateRunnerNormalisedPaceKM(raceresult.paceKm, raceresult.standard, race.distance, race.unit)
WHERE raceresult.race = race.Id AND race.Id = _raceId;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updatePointsByStandard`(_leagueId INT, _raceId INT, _standard VARCHAR(2), _gender VARCHAR(2))
BEGIN

  DECLARE _minValue INT;
  DECLARE _maxValue INT;
  CREATE TEMPORARY TABLE tmpActualRaceResult(ActualPosition INT PRIMARY KEY AUTO_INCREMENT, runnerId INT, racePosition INT);

  SET _minValue = (SELECT d.min FROM division d WHERE d.code = _standard and type='I');
  SET _maxValue = (SELECT d.max FROM division d WHERE d.code = _standard and type='I');

  IF _gender IS NULL THEN

    INSERT INTO tmpActualRaceResult(runnerId, racePosition)
    SELECT rr.runner, rr.position
    FROM raceresult rr
    JOIN leaguerunnerdata lrd ON rr.runner = lrd.runner
    WHERE rr.race = _raceId
    AND lrd.league = _leagueId
    AND rr.class='RAN'
    AND lrd.standard BETWEEN _minValue AND _maxValue
    ORDER BY rr.position;

  ELSE

    INSERT INTO tmpActualRaceResult(runnerId, racePosition)
    SELECT rr.runner, rr.position
    FROM raceresult rr
    JOIN runner r ON rr.runner = r.id
    JOIN leaguerunnerdata lrd ON rr.runner = lrd.runner
    WHERE rr.race = _raceId
    AND lrd.league = _leagueId
    AND lrd.standard BETWEEN _minValue AND _maxValue
    AND r.Gender= _gender
    AND rr.class='RAN'
    ORDER BY rr.position;

  END IF;

  UPDATE raceresult rr,tmpActualRaceResult ar
  SET rr.Points = 10.1 - (ar.ActualPosition/10)
  WHERE rr.runner = ar.runnerId AND rr.race = _RaceId;

  DROP TEMPORARY TABLE tmpActualRaceResult;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updatePositionInAgeCategoryByRaceId`(_raceId INT(11))
BEGIN

 DECLARE _nextCategory VARCHAR(4);
   DECLARE no_more_rows BOOLEAN;
   DECLARE loop_cntr INT DEFAULT 0;
   DECLARE num_rows INT DEFAULT 0;
   DECLARE _catCursor CURSOR FOR select category from agecategory;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;



   OPEN _catCursor;
   SELECT FOUND_ROWS() into num_rows;

    the_loop: LOOP

    FETCH  _catCursor INTO   _nextCategory;

    IF no_more_rows THEN
        CLOSE _catCursor;
        LEAVE the_loop;
    END IF;
   CREATE TEMPORARY TABLE tmpCategoryRaceResult(actualposition INT PRIMARY KEY 
AUTO_INCREMENT, runner INT);
    INSERT INTO tmpCategoryRaceResult(runner)
    SELECT runner
    FROM raceresult
    WHERE race = _raceId AND category = _nextCategory AND class='RAN';

    UPDATE raceresult, tmpCategoryRaceResult
    SET raceresult.positioninagecategory = tmpCategoryRaceResult.actualposition
    WHERE raceresult.runner = tmpCategoryRaceResult.runner AND raceresult.race = 
_raceId;

    DELETE FROM tmpCategoryRaceResult;

    SET loop_cntr = loop_cntr + 1;

  DROP TEMPORARY TABLE tmpCategoryRaceResult;

  END LOOP the_loop;


END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updatePositionInStandardByRaceId`(_raceId INT(11))
BEGIN

DECLARE _nextstandard INT(11);
   DECLARE no_more_rows BOOLEAN;
   DECLARE loop_cntr INT DEFAULT 0;
   DECLARE num_rows INT DEFAULT 0;
   DECLARE _standardCursor CURSOR FOR select standard from standard;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;



   OPEN _standardCursor;
   SELECT FOUND_ROWS() into num_rows;

    the_loop: LOOP

    FETCH  _standardCursor INTO   _nextstandard;

    IF no_more_rows THEN
        CLOSE _standardCursor;
        LEAVE the_loop;
    END IF;
   CREATE TEMPORARY TABLE tmpStandardRaceResult(actualposition INT PRIMARY KEY 
AUTO_INCREMENT, runner INT);
    INSERT INTO tmpStandardRaceResult(runner)
    SELECT runner
    FROM raceresult
    WHERE race = _raceId AND standard = _nextstandard and class='RAN';

    UPDATE raceresult, tmpStandardRaceResult
    SET raceresult.positioninstandard = tmpStandardRaceResult.actualposition
    WHERE raceresult.runner = tmpStandardRaceResult.runner AND raceresult.race = 
_raceId;

    DELETE FROM tmpStandardRaceResult;

    SET loop_cntr = loop_cntr + 1;

  DROP TEMPORARY TABLE tmpStandardRaceResult;

  END LOOP the_loop;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updatePostRaceStandard`(_raceId INT)
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


END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateRacePoints`(_raceId INT, _gender ENUM('M','W'))
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

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateRacePointsByEventId`(_event int)
BEGIN
    
    declare _league int;
    declare _race int;
    declare _no_more_rows boolean default false;
    declare _racecursor cursor for select id from race where event = _event AND type <> 'S';
    declare continue handler for not found set _no_more_rows := true;
	
	set _league =
	(
		select l.id
		from leagueevent le, league l
		where le.league=l.id and le.event = _event and l.type='I'
	);
    
	open _racecursor;

    raceLoop: loop
        fetch _racecursor into _race;
        if _no_more_rows then
            close _racecursor;
            leave raceLoop;
        end if;

        call initRacePointsData(_race);

        call addRacePointsDataScoringSets(_race);

        call addRacePointDataPositions(_race);

        call addAllRacePoints(_race);
		
		if (_league > 8) then
			call synchRaceResultByRaceId(_race);
		end if;
        
    end loop raceLoop;
	
	if (_league > 8) then
		call updateLeagueData(_league);

		call updateIndividualLeagueSummary(_league);
	end if;
END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateRaceTimeByHandicap`(_eventId INT)
BEGIN
  update raceresult rr
  join race ra on rr.race = ra.id
  join event e on ra.event = e.id
  join staggeredhandicap sh on ra.id = sh.race
  set rr.racetime = SEC_TO_TIME(TIME_TO_SEC(rr.racetime) - ((sh.maxstandard - rr.standard) * sh.secondshandicap))
  where e.id = _eventId;
END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateResultsByEvent`(_leagueId Int, _eventName varchar(100), _distance Double, _unit ENUM('KM','Mile'))
BEGIN

DECLARE _type enum('C','W','M');
DECLARE _idToProcess INT(11);
DECLARE _rc INT;
SET _idToProcess = (SELECT r.id
                    FROM race r, event e, leagueevent le 
WHERE r.event=e.id AND e.id = le.event AND e.name=_eventName AND r.distance=_distance AND r.unit=_unit AND le.league=_leagueId);

SET _type = (SELECT type FROM race where id = _idToProcess);


IF _type = 'C' THEN
CALL updateResultsByCombinedRaceId(_idToProcess , _rc);
ELSE
CALL updateResultsByRaceId(_idToProcess , _rc);
END IF;
END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateResultsByEventId`(_eventId INT(11))
BEGIN

  DECLARE _nextRaceId INT;
  DECLARE _type enum('C','W','M');

  DECLARE no_more_rows BOOLEAN;
  DECLARE loop_cntr INT DEFAULT 0;
  DECLARE num_rows INT DEFAULT 0;
  DECLARE _raceCursor CURSOR FOR SELECT id FROM race WHERE event = _eventId AND type <> 'S';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;

      OPEN _raceCursor;
      SELECT FOUND_ROWS() into num_rows;

      the_loop: LOOP

      FETCH  _raceCursor INTO   _nextRaceId;

      IF no_more_rows THEN
        CLOSE _raceCursor;
        LEAVE the_loop;
      END IF;


      CALL updateResultsByRaceId(_nextRaceId);

      SET loop_cntr = loop_cntr + 1;

  END LOOP the_loop;

    
END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateResultsByRaceId`(_raceId Int)
BEGIN

DECLARE _type enum('C','W','M');
DECLARE _leagueId INT(11);

SET _type = (SELECT type FROM race WHERE id = _RaceId);

SET _leagueId = (SELECT l.id
                    FROM league l
                    JOIN leagueevent le ON l.id = le.league
                    JOIN event e ON le.event = e.id
                    JOIN race r ON e.id = r.event
                    WHERE r.id=_raceId AND l.type='I');

  IF _type = 'C' THEN
    CALL UpdateRacePoints(_raceId,'M');
    CALL UpdateRacePoints(_raceId,'W');
  ELSE
    CALL UpdateRacePoints(_raceId, null);
  END IF;

  UPDATE raceresult, race
  SET raceresult.paceKm = CalculateRunnerPaceKM(raceresult.racetime, race.distance, race.unit)
  WHERE raceresult.race = race.Id AND race.Id = _raceId;


  CALL UpdateLeagueData(_leagueId);

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateResultsByTrackEvent`(_eventId Int)
BEGIN

 DECLARE _nextRaceId INT(11);
 DECLARE _leagueId INT(11);
 DECLARE no_more_rows BOOLEAN;
 DECLARE loop_cntr INT DEFAULT 0;
 DECLARE num_rows INT DEFAULT 0;
 DECLARE _raceCursor CURSOR FOR SELECT id FROM race WHERE event = _eventId;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;


  SET _leagueId = (SELECT l.id
                    FROM league l
                    JOIN leagueevent le ON l.id = le.league
                    JOIN event e ON le.event = e.id
                    WHERE e.id=_eventId AND l.type='I');

INSERT INTO leaguerunnerdata(league,runner, racesComplete, pointsTotal,avgOverallPosition, standard)
  SELECT _leagueId, r.id, 0, 0, 0, rr.standard
  FROM runner r
  JOIN raceresult rr ON r.id = rr.runner
  JOIN race ra ON rr.race = ra.id
  WHERE ra.event = _eventId
  AND r.status = 'M'
  AND r.id NOT IN (SELECT DISTINCT runner FROM leaguerunnerdata WHERE league = _leagueId);


    CALL updateTrackPointsByStandard(_leagueId, _eventId,'A','M');

    CALL updateTrackPointsByStandard(_leagueId, _eventId,'B','M');

    CALL updateTrackPointsByStandard(_leagueId, _eventId,'C','M');

    CALL updateTrackPointsByStandard(_leagueId, _eventId,'D','M');

    CALL updateTrackPointsByStandard(_leagueId, _eventId,'E','M');

    CALL updateTrackPointsByStandard(_leagueId, _eventId,'F','M');

    CALL updateTrackPointsByStandard(_leagueId, _eventId,'L1','F');

    CALL updateTrackPointsByStandard(_leagueId, _eventId,'L2','F');

  UPDATE raceresult, race, event
  SET raceresult.paceKM = calculateRunnerPaceKM(raceresult.raceTime, race.distance, race.Unit)
  WHERE raceresult.race = race.Id AND race.event=event.id AND event.id=_eventId;

  UPDATE raceresult, race, event
  SET raceresult.postRaceStandard = getStandardByRaceTime(raceresult.raceTime, race.distance, race.Unit)
  WHERE raceresult.race = race.Id AND race.event=event.id AND event.id=_eventId;


  OPEN _raceCursor;
  SELECT FOUND_ROWS() into num_rows;

  the_loop: LOOP

  FETCH  _raceCursor
  INTO   _nextRaceId;

         IF no_more_rows THEN
        CLOSE _raceCursor;
        LEAVE the_loop;
    END IF;

   CALL UpdateLeagueData(_leagueId, _nextRaceId);

   SET loop_cntr = loop_cntr + 1;

  END LOOP the_loop;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateResultsWithNonScores`(_eventid INT)
BEGIN



UPDATE raceresult rr
JOIN race ra ON rr.race=ra.id
JOIN
(SELECT rr.runner, count(rr.race) as racecount
FROM raceresult rr
JOIN race ra ON rr.race=ra.id
JOIN runner ru ON rr.runner = ru.id
WHERE ru.standard IS NOT NULL AND ru.status='M'
AND ra.event=_eventid
GROUP BY rr.runner
HAVING racecount>1) t ON rr.runner=t.runner
SET rr.class='RAN_NO_SCORE'
WHERE ra.event=_eventid;

UPDATE raceresult rr
JOIN race ra ON rr.race=ra.id
JOIN
(SELECT min(t.position) as bestfinish, t.race as bestrace, t.runner
FROM
(
SELECT max(rr_inner.race) as race, rr_inner.runner, rr_inner.position
FROM raceresult rr_inner
JOIN race r_inner ON rr_inner.race=r_inner.id
JOIN runner ru_inner ON rr_inner.runner = ru_inner.id
WHERE r_inner.event=_eventid AND rr_inner.position IS NOT NULL AND ru_inner.status='M' and
ru_inner.standard IS NOT NULL
GROUP BY rr_inner.runner,rr_inner.position
) t
GROUP BY t.runner) t2 ON rr.race=t2.bestrace and rr.runner=t2.runner
SET rr.class='RAN'
WHERE rr.class='RAN_NO_SCORE';


END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateScoringMensTeamPoints`()
BEGIN
CALL updateScoringTeamPoints('A');
CALL updateScoringTeamPoints('B');
CALL updateScoringTeamPoints('C');
CALL updateScoringTeamPoints('D');
END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateScoringTeamClasses`( _raceId INT, _gender ENUM('M','W'))
BEGIN

IF _gender = 'M' THEN
  UPDATE teamraceresult SET class=NULL WHERE race =_raceId AND status='PENDING';
  UPDATE teamraceresult SET class='A' WHERE race =_raceId AND status='PENDING'AND standardtotal<31;
  UPDATE teamraceresult SET class='B' WHERE race =_raceId AND status='PENDING'AND standardtotal between 31 and 38;
  UPDATE teamraceresult SET class='C' WHERE race =_raceId AND status='PENDING'AND standardtotal between 39 and 46;
  UPDATE teamraceresult SET class='D' WHERE race =_raceId AND status='PENDING'AND standardtotal > 46;
END IF;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateScoringTeamPoints`(_class ENUM('W','A','B','C','D'))
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

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateScoringTeamPoints2`(_class ENUM('W','A','B','C','D'))
BEGIN


DECLARE _points INT Default 7;
DECLARE _idToUpdate INT;

simple_loop: LOOP

  SET _points = _points - 1;

  IF NOT EXISTS (SELECT id FROM  teamraceresult WHERE leaguePoints = 0 AND class = _class AND Race=201073) THEN
    LEAVE simple_loop;
  END IF;

  IF _points = 0 THEN
    LEAVE simple_loop;
  END IF;

  SET _idToUpdate = (SELECT id FROM  teamraceresult WHERE leaguePoints =0 AND class = _class AND Race=201073 ORDER BY positiontotal LIMIT 1);

  UPDATE teamraceresult SET leaguePoints = _points WHERE id = _idToUpdate;

END LOOP simple_loop;

  UPDATE teamraceresult
  SET leaguePoints = 1
  WHERE leaguePoints =0 AND class = _class;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateScoringTeamPointsByGender`(_gender ENUM('W','M'))
BEGIN
IF _gender = 'M' THEN
  CALL updateScoringTeamPoints('A');
  CALL updateScoringTeamPoints('B');
  CALL updateScoringTeamPoints('C');
  CALL updateScoringTeamPoints('D');
ELSE
  CALL updateScoringTeamPoints('W');
END IF;
END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateScoringTeamTotals`(_raceid INT)
BEGIN

UPDATE
teamraceresult X,
(

SELECT X1.Id, Sum(X1.standard) as standardtotal
FROM
(SELECT id, runnerfirst AS runner, rr.standard FROM teamraceresult trr
JOIN
raceresult rr ON  trr.runnerfirst=rr.runner WHERE trr.race=_raceid AND rr.race=_raceid
UNION
SELECT id, runnersecond AS runner, rr.standard FROM teamraceresult trr
JOIN
raceresult rr ON  trr.runnersecond=rr.runner WHERE trr.race=_raceid  AND rr.race=_raceid
UNION
SELECT id, runnerthird AS runner, rr.standard FROM teamraceresult trr
JOIN
raceresult rr ON  trr.runnerthird=rr.runner WHERE trr.race=_raceid  AND rr.race=_raceid
)
X1
GROUP BY X1.Id
) Y
SET X.standardtotal =  Y.standardtotal
WHERE X.Id =  Y.Id;

UPDATE
teamraceresult X,
(

SELECT X1.Id, Sum(X1.position) as positiontotal
FROM
(SELECT id, runnerfirst AS runner, rr.position FROM teamraceresult trr
JOIN
raceresult rr ON  trr.runnerfirst=rr.runner WHERE trr.race=_raceid AND rr.race=_raceid
UNION
SELECT id, runnersecond AS runner, rr.position FROM teamraceresult trr
JOIN
raceresult rr ON  trr.runnersecond=rr.runner WHERE trr.race=_raceid  AND rr.race=_raceid
UNION
SELECT id, runnerthird AS runner, rr.position FROM teamraceresult trr
JOIN
raceresult rr ON  trr.runnerthird=rr.runner WHERE trr.race=_raceid  AND rr.race=_raceid)
X1
GROUP BY X1.Id
) Y
SET X.positiontotal =  Y.positiontotal
WHERE X.Id =  Y.Id;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateSummerLeague2009`()
BEGIN
call updateResultsByEvent(1, 'DCC', 2, 'Mile');
call updateResultsByEvent(1, 'DCC', 4, 'Mile');
call updateResultsByEvent(1, 'Kepak', 8, 'Mile');
call updateResultsByEvent(1, 'RTE', 5, 'Mile');
call updateResultsByEvent(1, 'Intel', 10, 'Km');
call updateResultsByEvent(1, 'ESB', 5, 'Km');
call updateResultsByEvent(1, 'Gov Services', 5, 'Mile');
call updateResultsByEvent(1, 'Army', 6, 'Km');
call updateResultsByEvent(1, 'Pearl Izumi', 10, 'Km');
call updateResultsByEvent(1, 'DCC Irishtown', 5, 'Km');
call updateResultsByTrackEvent(19);
call updateResultsByTrackEvent(20);
call updateResultsByTrackEvent(22);
END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateTeamLeagueSummary`(_leagueId  INT)
BEGIN
DELETE FROM leaguesummary WHERE leagueType='T' and leagueId = _leagueId;

INSERT INTO leaguesummary(
								leagueid,
								leaguetype,
								leagueparticipantid,
								leaguestandard,
								leaguedivision,
								leagueposition,
                previousleagueposition,
								leaguescorecount,
								leaguepoints)

SELECT
t1.leagueid,
t1.leaguetype,
t1.leagueparticipantid,
t1.leaguestandard as leaguestandard,
'W' AS leaguedivision,
@rownum:=@rownum+1 AS leagueposition,
t1.previousleagueposition,
t1.leaguescorecount,
t1.leaguepoints - (SELECT count(1) FROM teamraceresult where team = t1.leagueparticipantid and class='OW' and league = _leagueId) as leaguepoints
FROM
(
SELECT
_leagueId AS leagueid,
'T' AS leaguetype,
l.team AS leagueparticipantid,
ROUND(AVG(standardtotal)) AS leaguestandard,
0 AS leaguedivision,
0 AS previousleagueposition,
SUM(l.leaguescorecount) AS leaguescorecount,
SUM(l.leaguepoints) AS leaguepoints
FROM
(
SELECT 1 AS leaguescorecount, team, race, standardtotal, MAX(leaguepoints) AS
leaguepoints
FROM teamraceresult trr
WHERE league = _leagueId and class  in ('W','OW')
GROUP BY team,race
) l
GROUP BY l.team
ORDER BY leaguepoints DESC
)t1, (SELECT @rownum:=0) t2;






	INSERT INTO leaguesummary(
								leagueid,
								leaguetype,
								leagueparticipantid,
								leaguestandard,
								leaguedivision,
								leagueposition,

previousleagueposition,
								leaguescorecount,
								leaguepoints)

SELECT
t1.leagueid,
t1.leaguetype,
t1.leagueparticipantid,
COALESCE(t1.leaguestandard,0) as leaguestandard,
COALESCE((SELECT code FROM division WHERE type='T' AND gender='M' AND t1.leaguestandard
BETWEEN min AND max),'D') AS leaguedivision,
@rownum:=@rownum+1 AS leagueposition,
t1.previousleagueposition,
t1.leaguescorecount,
t1.leaguepoints - (SELECT count(1) FROM teamraceresult where team = t1.leagueparticipantid and class='O' and league = _leagueId) as leaguepoints
FROM
(
SELECT
_leagueId AS leagueid,
'T' AS leaguetype,
l.team AS leagueparticipantid,
ROUND(AVG(standardtotal)) AS leaguestandard,
0 AS leaguedivision,
0 AS previousleagueposition,
SUM(l.leaguescorecount) AS leaguescorecount,
SUM(l.leaguepoints) AS leaguepoints
FROM
(
SELECT 1 AS leaguescorecount, team, race, standardtotal, MAX(leaguepoints) AS
leaguepoints
FROM teamraceresult trr
WHERE league = _leagueId and class <> 'W' and class <> 'OW'
GROUP BY team,race
) l
GROUP BY l.team
ORDER BY leaguepoints DESC
)t1, (SELECT @rownum:=0) t2;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' PROCEDURE `updateTrackPointsByStandard`(_leagueid INT, _eventId INT, _standard VARCHAR(2), _gender VARCHAR(2))
BEGIN

  DECLARE _minValue INT;
  DECLARE _maxValue INT;
  CREATE TEMPORARY TABLE tmpActualRaceResult(ActualPosition INT PRIMARY KEY AUTO_INCREMENT, runnerId INT, raceId INT, racePosition INT);

  SET _minValue = (SELECT d.min FROM division d WHERE d.code = _standard);
  SET _maxValue = (SELECT d.max FROM division d WHERE d.code = _standard);

  INSERT INTO tmpActualRaceResult(runnerId, raceId, racePosition)
    SELECT rr.runner, rr.race, rr.position
    FROM raceresult rr
    JOIN runner r ON rr.runner=r.id
    JOIN leaguerunnerdata lrd ON r.id = lrd.runner
    WHERE lrd.standard BETWEEN _minValue AND _maxValue  AND r.Gender= _gender
    AND lrd.league = _leagueid
    AND  rr.race in (SELECT id FROM race WHERE event = _eventId)
    ORDER BY rr.position;



  UPDATE raceresult rr,tmpActualRaceResult ar
  SET rr.Points = 10.1 - (ar.ActualPosition/10)
  WHERE rr.runner = ar.runnerId AND rr.race = ar.raceId;




  DROP TEMPORARY TABLE tmpActualRaceResult;

END$$

--
-- Functions
--
CREATE DEFINER='bhaaie_members'@'localhost' FUNCTION `calculateRunnerNormalisedPaceKM`(_paceKm TIME, _standard INT, _distance DOUBLE, _unit ENUM('KM','Mile')) RETURNS time
BEGIN

declare _normalisedPace TIME;

set _distance = (select getRaceDistanceKM(_distance, _unit));

set _normalisedPace  =
(select calculateRunnerPaceKM(X.normalisedtime,_distance, 'Km') as normalisedpacekm
from
(
select
SEC_TO_TIME((TIME_TO_SEC(_paceKm) + (_distance * s.slopefactor))* _distance) as normalisedtime
from standard s
where s.standard = _standard
) X
);

RETURN  _normalisedPace;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' FUNCTION `calculateRunnerPaceKM`(_raceTime TIME, _distance DOUBLE, _unit ENUM('KM','Mile')) RETURNS time
BEGIN

SET _distance =
IF (_unit = 'Mile', _distance * 1.609344, _distance);
RETURN  SEC_TO_TIME(TIME_TO_SEC(_raceTime) / _distance);

END$$

CREATE DEFINER='bhaaie_members'@'localhost' FUNCTION `getActualRunnerTime`(_raceId INT, _runnerId INT) RETURNS time
BEGIN
  declare _standard int;
  declare _handicap int;
  declare _racetime time;
  set _standard = (select standard from raceresult where runner = _runnerId and race = _raceId);
  set _racetime = (select racetime from raceresult where runner = _runnerId and race = _raceId);
  set _handicap = (select (maxstandard - _standard) * secondshandicap from staggeredhandicap where race = _raceId);
  return SEC_TO_TIME(TIME_TO_SEC(_racetime) - _handicap);
END$$

CREATE DEFINER='bhaaie_members'@'localhost' FUNCTION `getAgeCategory`(_birthDate DATE, _currentDate DATE, _gender ENUM('M','W'), _returnCode BIT) RETURNS varchar(4) CHARSET utf8
BEGIN
DECLARE _age INT(11);
DECLARE _returnValue VARCHAR(4);
SET _age = (YEAR(_currentDate)-YEAR(_birthDate)) - (RIGHT(_currentDate,5)<RIGHT(_birthDate,5));
IF _returnCode = 1 THEN
  SET _returnValue = (SELECT code FROM agecategory WHERE (_age between min and max) 
and gender=_gender);
ELSE
  SET _returnValue = (SELECT category FROM agecategory WHERE (_age between min and 
max) and gender=_gender);
END IF;
RETURN _returnValue;
END$$

CREATE DEFINER='bhaaie_members'@'localhost' FUNCTION `getAlternativePointsTotal`(_leagueId INT(11), _runnerId INT(11), _racesToCount INT) RETURNS double
BEGIN

DECLARE _pointsTotal DOUBLE;

SET _pointsTotal =
(
        SELECT SUM(points) FROM
(
      SELECT points ,@rownum:=@rownum+1 AS bestxpoints
      FROM
      (
      SELECT
      DISTINCT e.id,
      CASE rr.alternativepoints WHEN 11 THEN 10 ELSE rr.alternativepoints END AS points
      FROM raceresult rr
      JOIN race ra ON rr.race = ra.id
      JOIN event e ON ra.event = e.id
      JOIN leagueevent le ON e.id = le.event
	    WHERE runner=_runnerId AND le.league=_leagueId and rr.class in ('RAN', 'RACE_ORG', 'RACE_POINTS') order by rr.alternativepoints desc) r1, (SELECT @rownum:=0) r2
) t where t.bestxpoints <= _racesToCount
);

RETURN _pointsTotal;


END$$

CREATE DEFINER='bhaaie_members'@'localhost' FUNCTION `getClockTime`(_raceId INT, _runnerId INT) RETURNS time
BEGIN

  declare _standard int;
  declare _handicap int;
  declare _racetime time;

  set _standard = (select standard from raceresult where runner = _runnerId and race = _raceId);
  set _racetime = (select racetime from raceresult where runner = _runnerId and race = _raceId);
  set _handicap = (select (maxstandard - _standard) * secondshandicap from staggeredhandicap where race = _raceId);

 return SEC_TO_TIME(TIME_TO_SEC(_racetime) + _handicap);

END$$

CREATE DEFINER='bhaaie_members'@'localhost' FUNCTION `getLeaguePointsTotal`(_leagueId INT(11), _runnerId INT(11)) RETURNS double
BEGIN

DECLARE _pointsTotal DOUBLE;
DECLARE _racesToCount INT;

SET _racesToCount = (select racestoscore from league where id=_leagueId);


SET _pointsTotal =
(
        SELECT SUM(points) FROM
(
      SELECT points ,@rownum:=@rownum+1 AS bestxpoints
      FROM
      (
      SELECT
      DISTINCT e.id,
      CASE rr.points WHEN 11 THEN 10 ELSE rr.points END AS points
      FROM raceresult rr
      JOIN race ra ON rr.race = ra.id
      JOIN event e ON ra.event = e.id
      JOIN leagueevent le ON e.id = le.event
	    WHERE runner=_runnerId AND le.league=_leagueId and rr.class in ('RAN', 'RACE_ORG', 'RACE_POINTS') order by rr.points desc) r1, (SELECT @rownum:=0) r2
) t where t.bestxpoints <= _racesToCount 
);

RETURN _pointsTotal;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' FUNCTION `getMatchingRunnerId`(_runnerid INT) RETURNS int(11)
BEGIN

RETURN (
SELECT ru2.id
FROM runner ru,runner ru2
WHERE ru.firstname =ru2.firstname AND ru.surname=ru2.surname AND ru.dateOfBirth=ru2.dateOfBirth
AND ru.status ='D' AND ru2.status !='D' AND ru.id= _runnerid
LIMIT 1
);

END$$

CREATE DEFINER='bhaaie_members'@'localhost' FUNCTION `getRaceDistanceKM`(_distance DOUBLE, _unit ENUM('KM','Mile')) RETURNS double
BEGIN

SET _distance = IF (_unit = 'Mile', _distance * 1.609344, _distance);
RETURN  _distance;

END$$

CREATE DEFINER='bhaaie_members'@'localhost' FUNCTION `getStandard`(_raceTime TIME, _distanceKm DOUBLE) RETURNS int(11)
BEGIN

DECLARE _standard INT DEFAULT 1;

SET _standard = (
SELECT S.Standard
FROM
(
SELECT Standard, SEC_TO_TIME((((standard.slopefactor)*(_distanceKm-1)) + standard.oneKmTimeInSecs) * _distanceKm) as Expected
FROM standard WHERE id=standard
) S

WHERE S.Expected <= _raceTime
ORDER BY S.Standard DESC
LIMIT 1
);



RETURN COALESCE(_standard, 30);


END$$

CREATE DEFINER='bhaaie_members'@'localhost' FUNCTION `getStandardByRaceTime`(_raceTime TIME, _distance DOUBLE, _unit ENUM('KM','Mile')) RETURNS int(11)
BEGIN


RETURN NULL;
END$$

CREATE DEFINER='bhaaie_members'@'localhost' FUNCTION `getStandardByRunnerPace`(_raceId INT, _runnerId INT) RETURNS int(11)
BEGIN


DECLARE _raceDistance DOUBLE;
DECLARE _raceDistanceKM DOUBLE;
DECLARE _raceUnit ENUM('KM','Mile');
DECLARE _runnerPace TIME;
DECLARE _actualStandard INT;


SET _raceDistance = (SELECT distance FROM race WHERE id = _raceId);
SET _raceUnit = (SELECT unit FROM race WHERE id = _raceId);
SET _runnerPace = (SELECT paceKM FROM raceresult WHERE race = _raceId AND runner = _runnerId AND class='RAN');
SET _raceDistanceKM = (SELECT getRaceDistanceKM(_raceDistance, _raceUnit));

SET _actualStandard  =
(
SELECT
standard
FROM
(
SELECT
standard,
SEC_TO_TIME((oneKmTimeInSecs + (_raceDistanceKM * slopefactor))* _raceDistanceKM) as perdictedtime
from standard
) t
where calculateRunnerPaceKM(t.perdictedtime, _raceDistance , _raceUnit)  >= _runnerPace
limit 1
);

RETURN _actualStandard;
END$$

DELIMITER ;