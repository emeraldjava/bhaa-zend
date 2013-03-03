DELIMITER $$

CREATE PROCEDURE `updateRacePointsByEventId`(_event int)
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
    

END
