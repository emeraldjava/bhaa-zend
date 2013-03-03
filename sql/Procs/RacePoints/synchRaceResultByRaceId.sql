DELIMITER $$

CREATE PROCEDURE `synchRaceResultByRaceId`(_race INT)
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
        rr.paceKm = CalculateRunnerPaceKM(rr.paceKm, rr.standard, ra.distance, ra.unit)
    where rr.race = ra.Id AND ra.Id = _race;
END
