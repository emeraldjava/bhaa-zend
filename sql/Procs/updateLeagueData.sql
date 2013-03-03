DROP PROCEDURE `updateLeagueData`//
CREATE DEFINER=`bhaa1`@`localhost` PROCEDURE `updateLeagueData`(_leagueId INT(11))
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

END