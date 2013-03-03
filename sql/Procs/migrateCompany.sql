DROP PROCEDURE `migrateCompany`//
CREATE PROCEDURE `migrateCompany`(_renewalDate DATE)
BEGIN

  #1. Set the leavedate for any runner who has left a company where they were on a team there
  UPDATE teammember tm
  JOIN team t ON tm.team = t.id AND t.type='c'
  JOIN runner r ON tm.runner = r.id
  SET tm.leavedate = CURRENT_DATE()
  WHERE t.status='active' AND tm.leavedate IS NULL AND r.company<>tm.team;

  #2. Move new members to their respective teams
 INSERT INTO teammember (team,runner,joindate)
 SELECT t.id,r.id, CURRENT_DATE()
 FROM runner r
 LEFT JOIN teammember tm ON r.id=tm.runner and tm.leavedate IS NULL
 JOIN company c ON r.company=c.id
 JOIN team t ON c.id = t.id and t.type='C'
 WHERE r.dateofrenewal > COALESCE(_renewalDate,'2000-1-1')
 AND tm.team IS NULL
 AND r.status = 'M'
 AND t.status='ACTIVE';

END
