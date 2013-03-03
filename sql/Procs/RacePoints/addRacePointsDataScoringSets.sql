DELIMITER $$

CREATE PROCEDURE `addRacePointsDataScoringSets`(_race INT)
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
	
	set _scoringthreshold = 5;
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
        set ss.gender=r.gender, ss.standardcount = x.standardcount
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

END