SELECT rr.runner AS runnerid,
CONCAT(ru.firstname, ' ', ru.surname) AS runnername,
SUM(CASE rr.race WHEN 15 THEN rr.points ELSE NULL END) as DCCResult,
SUM(CASE rr.race WHEN 16 THEN rr.points ELSE NULL END) as KepakResult,
SUM(CASE rr.race WHEN 17 THEN rr.points ELSE NULL END) as RTEResult,
SUM(CASE rr.race WHEN 31 THEN rr.points ELSE NULL END) as IntelResult,
SUM(CASE rr.race WHEN 32 THEN rr.points ELSE NULL END) as ESBResult,
SUM(CASE rr.race WHEN 34 THEN rr.points ELSE NULL END) as GovServicesResult,
SUM(CASE rr.race WHEN 35 THEN rr.points ELSE NULL END) as ArmyResult,
SUM(CASE rr.race WHEN 51 THEN rr.points ELSE NULL END) as DCCIrishTownResult,
SUM(CASE rr.race WHEN 63 THEN rr.points
									WHEN 64 THEN rr.points
									WHEN 65 THEN rr.points
									WHEN 66 THEN rr.points
									WHEN 67 THEN rr.points
									WHEN 68 THEN rr.points
									WHEN 69 THEN rr.points
									ELSE NULL END) as HibernianResult,
SUM(CASE rr.race WHEN 52 THEN rr.points
									WHEN 53 THEN rr.points
									WHEN 54 THEN rr.points
									WHEN 55 THEN rr.points
									WHEN 56 THEN rr.points
									ELSE NULL END) as ILPResult,
SUM(CASE rr.race WHEN 57 THEN rr.points
									WHEN 58 THEN rr.points
									WHEN 59 THEN rr.points
									WHEN 60 THEN rr.points
									WHEN 61 THEN rr.points
									ELSE NULL END) as ZurichResult,

SUM(CASE rr.race WHEN 62 THEN rr.points ELSE NULL END) as PearlIzumiResult,
lrd.racesComplete,
lrd.pointsTotal

FROM raceresult rr
JOIN runner ru ON rr.runner = ru.id
JOIN race ra ON rr.race = ra.id
JOIN event e ON ra.event = e.id
JOIN leagueevent le ON e.id = le.event
JOIN leaguerunnerdata lrd ON lrd.runner=rr.runner AND lrd.league=le.league

WHERE ru.standard BETWEEN 1 AND 7
AND ru.gender = 'M'
AND le.league = 1

GROUP BY runnerid,runnername,racesComplete,pointsTotal
ORDER BY pointsTotal DESC;