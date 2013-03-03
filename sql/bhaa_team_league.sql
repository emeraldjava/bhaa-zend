SELECT A.Id, A.Name, sdccPoints, sdccVPoints, eircomPoints, eircomVPoints,
totalPoints+COALESCE(totalVPoints,0) as overallTotalPoints
FROM
  (
  SELECT x.id,x.name,
  SUM(CASE x.race WHEN 20102 THEN x.points ELSE NULL END) AS sdccPoints,
  SUM(CASE x.race WHEN 20104 THEN x.points ELSE NULL END) AS eircomPoints,
  SUM(x.points) as totalPoints
  FROM
    (
      SELECT t.id,t.name,trr.race,MAX(trr.leaguepoints) as points
      FROM teamraceresult trr
      JOIN team t on trr.team=t.id
      WHERE trr.league = 5 and trr.class <> 'O'
      GROUP BY t.id,t.name,trr.race
    ) x
  GROUP BY x.id, x.name
)
A
LEFT JOIN
(
    SELECT x.id,x.name,
    SUM(CASE x.race WHEN 20102 THEN 6 ELSE NULL END) AS sdccVPoints,
    SUM(CASE x.race WHEN 20104 THEN 6 ELSE NULL END) AS eircomVPoints,
    SUM(x.points) as totalVPoints
  FROM
    (
      SELECT t.id,t.name,trr.race,MAX(trr.leaguepoints) as points
      FROM teamraceresult trr
      JOIN team t on trr.team=t.id
      WHERE trr.league = 5 and trr.class = 'O'
      GROUP BY t.id,t.name,trr.race
    ) x
  GROUP BY x.id, x.name
) B
USING(id)
ORDER by overallTotalPoints DESC;
