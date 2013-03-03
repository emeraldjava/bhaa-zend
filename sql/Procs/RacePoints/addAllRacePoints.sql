DELIMITER $$

CREATE PROCEDURE `addAllRacePoints` (_race int)

BEGIN
    
    delete from racepoints where race = _race;

    insert into racepoints(race, runner, pointsbystandard, pointsbyscoringset)
    select 
    race, 
    runner, 
    10.1 - (positioninstandard  * 0.1) as pointsbystandard,
    10.1 - (positioninscoringset  * 0.1) as pointsbyscoringset
    from racepointsdata where race = _race;

END

