DROP TABLE IF EXISTS `company`;
CREATE TABLE IF NOT EXISTS `company` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `sector` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

select * from runner

select runner.id,runner.firstname,runner.surname,runner.status,runner.dateofrenewal from runner
where (company=94 OR team=94) and runner.status="M" order by runner.status asc, runner.surname asc;

and status="M";

select runner.id,runner.surname,runner.firstname,runner.status,runner.dateofrenewal from teammember
join runner on teammember.runner=runner.id
where teammember.team=94 order by runner.surname asc;


select max(id) from company;
select * from company where id=1020;
describe company;

select * from runner where company=1020;

select * from company join sector on company.sector=sector.id where sector.valid='N';

select id, name,
	(select count(runner.id) from runner where runner.company = company.id and runner.status="M") as runners,
	(select count(runner) from teamrunner where runner.company = company.id and runner.status="M") as runners
from company where company.sector = 1;
    		

select *
FROM   raceresult rr
JOIN   runner r ON rr.runner = r.id
where rr.runner=7962;

select * from runner where id=7442;
-- banking: boi
update company set sector=3 where id=161;
update company set sector=3 where id=100;
update company set sector=3 where id=84;
update company set sector=3 where id=117;

-- american college to education
update company set sector=12 where id=913;
update company set sector=12 where id=140;
update company set sector=12 where id=111;
update company set sector=12 where id=256;
update company set sector=12 where id=92;
update company set sector=12 where id=79;
-- engineering
update company set sector=14 where id=97;
-- food
update company set sector=16 where id=367;
update company set sector=16 where id=166;
-- insurance
update company set sector=19 where id=175;
update company set sector=19 where id=71;
update company set sector=19 where id=134;
-- it : intel, norkom
update company set sector=20 where id=158;
update company set sector=20 where id=939;
update company set sector=20 where id=388;
-- media: rte
update company set sector=25 where id=121;
-- telecoms: eircom
update company set sector=33 where id=110;
-- transport : dub bus, aer lin
update company set sector=34 where id=91;
update company set sector=34 where id=67;

alter table company add website varchar(100);
alter table company add image varchar(100);


update company set website="http://www.bmsireland.ie/swords" where id=204;
update company set image="http://www.bmsireland.ie/images/header_swords.jpg" where id=204;

update company set website="http://www.irishlifepermanent.ie" where id=117;
update company set image="http://www.irishlifepermanent.ie/ipm/images/ilp_logo.gif" where id=117;

update company set website="http://www.garda.ie/" where id=94;
update company set image="http://www.garda.ie/Images/Masthead/ags_logo2.gif" where id=94;

update company set website="http://www.esb.ie" where id=97;
update company set image="http://www.esb.ie/img/logo.png" where id=97;

update company set website="http://www.dit.ie" where id=256;
update company set image="http://www.dit.ie/media/styleimages/dit_crest.gif" where id=256;

update company set website="http://www.bnymellon.com" where id=434;
update company set image="http://www.bnymellon.com/img/nav/bnymlogo2.gif" where id=434;

update company set website="http://www.intel.com/corporate/europe/emea/irl/intel/index.htm" where id=158;
update company set image="http://www.intel.com/sites/sitewide/HAT/30recode/pix/intlogo.gif" where id=158;

update company set website="http://www.grantthornton.ie/" where id=775;
update company set image="http://www.grantthornton.ie/db/Gallery/Groups/Top_Links/logo.gif" where id=775;

update company set website="http://www.rte.ie" where id=121;
update company set image="http://www.rte.ie/images/logo.gif" where id=121;

update company set website="http://www.revenue.ie" where id=137;
update company set image="http://www.revenue.ie/images/logo_revenue.gif" where id=137;

update company set website="http://www.norkom.com" where id=939;
update company set image="http://www.norkom.com/templates/norkom_home/images/nor_norkom_logo.png" where id=939;

update company set website="http://www.hse.ie/" where id=701;
update company set image="http://www.hse.ie/img/logo.jpg" where id=701;

update company set website="http://eircom.ie" where id=110;
update company set image="http://eircom.ie/bveircom/images/resEircomLogo.gif" where id=110;

update company set website="http://www.zurich.ie" where id=175;
update company set image="http://www.zurich.ie/img/zurich_logo.gif" where id=175;

update company set website="http://www.welfare.ie" where id=124;
update company set image="http://www.welfare.ie/Style%20Library/images/welfare_logo.gif" where id=124;

update company set website="http://www.dublincity.ie" where id=93;
update company set image="http://www.irishsports.ie/image?tn=Images&key=imageID&colname=image&keyval=178" where id=93;

update company set website="http://www.liueurope.com" where id=221;
update company set image="http://logo.jobsdb.com/HK/JobsDBFiles/CompanyLogo/11521_new.gif" where id=221;

