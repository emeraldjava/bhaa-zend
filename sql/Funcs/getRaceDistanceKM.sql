CREATE FUNCTION `getRaceDistanceKM`(_distance DOUBLE, _unit ENUM('KM','Mile')) RETURNS double
BEGIN

SET _distance = IF (_unit = 'Mile', _distance * 1.609344, _distance);
RETURN  _distance;

END
