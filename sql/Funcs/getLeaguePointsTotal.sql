DROP FUNCTION `getLeaguePointsTotal`//
CREATE FUNCTION `getLeaguePointsTotal`(_leagueId INT(11), _runnerId INT(11)) RETURNS double
BEGIN

DECLARE _pointsTotal DOUBLE;
DECLARE _racesToCount INT;

SET _racesToCount = (select count(id) from leagueevent where league=_leagueId);
SET _racesToCount = _racesToCount - 2;


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
) t where t.bestxpoints <= 15
);

RETURN _pointsTotal;

END
