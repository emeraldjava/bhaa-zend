DELIMITER $$

CREATE PROCEDURE `initRacePointsData`(_race int)
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

END
