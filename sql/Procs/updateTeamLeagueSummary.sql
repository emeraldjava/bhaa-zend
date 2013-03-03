DROP PROCEDURE `updateTeamLeagueSummary`//
CREATE PROCEDURE `updateTeamLeagueSummary`(_leagueId  INT)
BEGIN
DELETE FROM leaguesummary WHERE leagueType='T' and leagueId = _leagueId;

INSERT INTO leaguesummary(
								leagueid,
								leaguetype,
								leagueparticipantid,
								leaguestandard,
								leaguedivision,
								leagueposition,
                previousleagueposition,
								leaguescorecount,
								leaguepoints)

SELECT
t1.leagueid,
t1.leaguetype,
t1.leagueparticipantid,
t1.leaguestandard as leaguestandard,
'W' AS leaguedivision,
@rownum:=@rownum+1 AS leagueposition,
t1.previousleagueposition,
t1.leaguescorecount,
t1.leaguepoints - (SELECT count(1) FROM teamraceresult where team = t1.leagueparticipantid and class='OW' and league = _leagueId) as leaguepoints
FROM
(
SELECT
_leagueId AS leagueid,
'T' AS leaguetype,
l.team AS leagueparticipantid,
ROUND(AVG(standardtotal)) AS leaguestandard,
0 AS leaguedivision,
0 AS previousleagueposition,
SUM(l.leaguescorecount) AS leaguescorecount,
SUM(l.leaguepoints) AS leaguepoints
FROM
(
SELECT 1 AS leaguescorecount, team, race, standardtotal, MAX(leaguepoints) AS
leaguepoints
FROM teamraceresult trr
WHERE league = _leagueId and class  in ('W','OW')
GROUP BY team,race
) l
GROUP BY l.team
ORDER BY leaguepoints DESC
)t1, (SELECT @rownum:=0) t2;






	INSERT INTO leaguesummary(
								leagueid,
								leaguetype,
								leagueparticipantid,
								leaguestandard,
								leaguedivision,
								leagueposition,

previousleagueposition,
								leaguescorecount,
								leaguepoints)

SELECT
t1.leagueid,
t1.leaguetype,
t1.leagueparticipantid,
COALESCE(t1.leaguestandard,0) as leaguestandard,
COALESCE((SELECT code FROM division WHERE type='T' AND gender='M' AND t1.leaguestandard
BETWEEN min AND max),'D') AS leaguedivision,
@rownum:=@rownum+1 AS leagueposition,
t1.previousleagueposition,
t1.leaguescorecount,
t1.leaguepoints - (SELECT count(1) FROM teamraceresult where team = t1.leagueparticipantid and class='O' and league = _leagueId) as leaguepoints
FROM
(
SELECT
_leagueId AS leagueid,
'T' AS leaguetype,
l.team AS leagueparticipantid,
ROUND(AVG(standardtotal)) AS leaguestandard,
0 AS leaguedivision,
0 AS previousleagueposition,
SUM(l.leaguescorecount) AS leaguescorecount,
SUM(l.leaguepoints) AS leaguepoints
FROM
(
SELECT 1 AS leaguescorecount, team, race, standardtotal, MAX(leaguepoints) AS
leaguepoints
FROM teamraceresult trr
WHERE league = _leagueId and class <> 'W' and class <> 'OW'
GROUP BY team,race
) l
GROUP BY l.team
ORDER BY leaguepoints DESC
)t1, (SELECT @rownum:=0) t2;

END
