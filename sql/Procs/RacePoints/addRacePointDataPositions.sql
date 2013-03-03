DELIMITER $$

CREATE PROCEDURE `addRacePointDataPositions`(_race int)
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
       
        insert into tmpPosInSet(runner, scoringset,gender)  
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

  
END