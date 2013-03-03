DELIMITER $$

DROP PROCEDURE IF EXISTS `bhaa1_members`.`migrateCompany` $$
CREATE PROCEDURE `bhaa1_members`.`migrateCompany`(_companyId INT(11))
BEGIN

INSERT INTO teammember(team,runner)
SELECT team.id, runner.id
FROM runner
JOIN team on team.id=runner.company
WHERE team.id=_companyId
AND team.status="ACTIVE"
AND runner.status="M"
AND runner.id NOT IN (SELECT runner FROM teammember WHERE runner.company=team.id);

END