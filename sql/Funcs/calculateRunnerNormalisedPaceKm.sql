DROP FUNCTION IF EXISTS `calculateRunnerNormalisedPaceKM` $$
CREATE FUNCTION `calculateRunnerNormalisedPaceKM`(_paceKm TIME, _standard INT, _distance DOUBLE, _unit ENUM('KM','Mile')) RETURNS time
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

END