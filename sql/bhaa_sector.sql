

DROP TABLE IF EXISTS `sector`;
CREATE TABLE IF NOT EXISTS `sector` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(250) NOT NULL,
  `valid` CHAR(1) DEFAULT "Y",
  PRIMARY KEY  (`id`)
);

update sector set name="Generic Sector" where id=48;

DELETE FROM sector;
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(1, 'Accountants', 'Accountants', "Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(2, 'Agriculture', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(3, 'Banking','',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(4, 'Construction', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(5, 'Architects', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(7, 'Dublin Hospitals', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(8, 'Dublin Hotels', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(9, 'Dublin Motors', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(10, 'Dublin Plumbers','',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(11, 'Army', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(12, 'Education', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(13, 'Electrical', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(14, 'Engineering', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(15, 'Finance','',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(16, 'Food', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(17, 'Govt Depts','',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(18, 'Health', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(19, 'Insurance', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(20, 'Information Technology', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(22, 'Legal','',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(23, 'Leisure', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(24, 'Dublin Councils', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(25, 'Media', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(26, 'Mining Natural Resources', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(28, 'Printers', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(29, 'Retail/Wholesale', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(30, 'Teachers','',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(31, 'Security','',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(32, 'Tax', '',"N");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(33, 'Telecoms', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(34, 'Transport','',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(36, 'Admin','',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(38, 'Stockbroker', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(39, 'Combined Man','',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(40, 'Pharmacy', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(42, 'Colleges', '',"N");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(47, 'Govt Agencies', '',"Y");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(6, 'IT Ladies', '',"N");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(21, 'Accountants Ladies','',"N");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(27, 'Teachers Ladies', '',"N");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(35, 'Govt Depts Ladies','',"N");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(37, 'IT Men Team 2','',"N");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(43, 'IT Men Team 3','',"N");
INSERT INTO `sector` (`id`, `name`, `description`,`valid`) VALUES(44, 'Build/Con Men Team 2','',"N");

update sector set name="Hospitals",valid="Y" where id=7;
update sector set name="Hotels",valid="Y" where id=8;
update sector set name="Motors",valid="Y" where id=9;
update sector set name="Plumbers",valid="Y" where id=10;
update sector set name="Manufacturing",valid="Y" where id=39;
update sector set name="Colleges",valid="N" where id=42;
update sector set valid="N" where id=32;

select * from sector;

select id,firstname,surname,runner.email,
(select count(race) from raceresult where raceresult.runner = runner.id and raceresult.race>2000) as races from runner
where team=29 and status="M" order by races desc;

select id,company,team from runner where team=29 and status="M";

select id,company,team,tblMembership.CompanyNo,tblMembership.TeamNo from runner
join tblMembership on tblMembership.MembNo=runner.id
where team=29 and status="M";


select id, name, 
	(select count(company.id) from company where company.sector = sector.id) as companies,
	(select count(runner.id) from runner as runner join company as company on runner.company=company.id where company.sector=sector.id and runner.status="M") as runners')
from sector where valid='Y';

select id, name, 
	(select count(company.id) from company join teammember as teammember on teammember.team=company.id and company.sector = sector.id) as companies,
	(select count(company.id) from company where company.sector = sector.id) as allcompanies,
	(select count(runner.id) from runner as runner join company as company on runner.company=company.id where company.sector=sector.id and runner.status="M") as runners
from sector where valid='Y';
    		