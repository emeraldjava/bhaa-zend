
select * from runner where firstname="Jimmy";

SELECT `runner`.`id` AS `membno`, `runner`.`surname`, `runner`.`firstname` AS `name`, (CASE gender WHEN "M" THEN "M" ELSE "L" END) AS `gender`,
`runner`.`standard` AS `std`, date_format(dateofbirth,'%d/%m/%Y') AS `dateofbirth`, (select getAgeCategory(runner.dateofbirth,"2010-01-16",runner.gender,1))
AS `cat`, (select name from company where runner.company = company.id) AS `companyname`, (select id from team where team.id=teammember.team and team.status="ACTIVE")
AS `teamid`, (select name from team where team.id=teammember.team and team.status="ACTIVE") AS `teamname` FROM `runner` LEFT JOIN `teammember`
ON teammember.runner = runner.id WHERE (runner.status='M')  AND surname regexp '^\s*[A-L]*\s*' ORDER BY `surname` asc

SELECT `runner`.`id` AS `membno`, `runner`.`surname`, `runner`.`firstname` AS `name`, (CASE gender WHEN "M" THEN "M" ELSE "L" END) AS `gender`,
`runner`.`standard` AS `std`, date_format(dateofbirth,'%d/%m/%Y') AS `dateofbirth`, (select getAgeCategory(runner.dateofbirth,"2010-01-16",runner.gender,1))
AS `cat`, (select name from company where runner.company = company.id) AS `companyname`, (select id from team where team.id=teammember.team and team.status="ACTIVE")
AS `teamid`, (select name from team where team.id=teammember.team and team.status="ACTIVE") AS `teamname` FROM `runner` LEFT JOIN `teammember`
ON teammember.runner = runner.id WHERE (runner.status='I') ORDER BY `surname` asc

SELECT `runner`.`id` AS `membno`, `runner`.`surname`, `runner`.`firstname` AS `name`, (CASE gender WHEN "M" THEN "M" ELSE "L" END) AS `gender`,
`runner`.`standard` AS `std`, date_format(dateofbirth,'%d/%m/%Y') AS `dateofbirth`, (select getAgeCategory(runner.dateofbirth,"2010-01-16",runner.gender,1))
AS `cat`, (select name from company where runner.company = company.id) AS `companyname` FROM `runner` LEFT JOIN `teammember`
ON teammember.runner = runner.id WHERE (runner.status='I') ORDER BY `surname` asc


SELECT `runner`.`id` AS `membno`, `runner`.`surname`, `runner`.`firstname` AS `name`,
 (CASE gender WHEN "M" THEN "M" ELSE "L" END) AS `gender`, `runner`.`standard` AS `std`,
date_format(dateofbirth,'%d/%m/%Y') AS `dateofbirth`,
 (select getAgeCategory(runner.dateofbirth,"2010-02-06",runner.gender,1)) AS `cat`,
 (select name from company where runner.company = company.id) AS `companyname`,
 (select id from team where team.id=teammember.team
and team.status="ACTIVE") AS `teamid` FROM `runner` LEFT JOIN `teammember` ON
teammember.runner = runner.id WHERE (runner.dateofrenewal>='2009-09-01') AND (LEFT(surname,1)
regexp '[A-Z]') ORDER BY `surname`;
