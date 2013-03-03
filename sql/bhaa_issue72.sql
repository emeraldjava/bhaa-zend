select id, firstname, surname from runner where id=7713;
select count(id) from membership;

-- match re-registering runners
select membership.id, runner.id, runner.firstname, runner.surname,runner.status from runner
join membership ON  membership.firstname = runner.firstname
AND membership.surname = runner.surname
AND membership.dateofbirth = runner.dateOfBirth
AND membership.status = "PENDING"
ORDER BY membership.id asc;

delete r
from runner r
left join raceresult rr on r.id=rr.runner
where status='d' and rr.runner is null;


--
select membership.id, membership.companyid,membership.companyname, runner.id, runner.firstname, runner.surname,runner.status,runner.company from runner
join membership ON  membership.firstname = runner.firstname
AND membership.surname = runner.surname
AND membership.companyid != runner.company
AND membership.dateofbirth = runner.dateOfBirth
AND membership.status = "PENDING" AND runner.status != "D" and membership.runner=0;

-- match members based with date of Birth
select membership.id,membership.firstname,membership.surname,runner.id,runner.status,runner.firstname, runner.surname
from runner join membership ON LOWER(membership.firstname) = LOWER(runner.firstname)
AND LOWER(membership.surname) = LOWER(runner.surname)
AND LOWER(membership.dateofbirth) = LOWER(runner.dateOfBirth)
AND membership.status="PENDING"
ORDER BY membership.id asc;

-- match members where the dob is blank.
select membership.id,membership.firstname,membership.surname,runner.id,runner.status,runner.firstname,runner.surname
from runner join membership ON LOWER(membership.firstname) = LOWER(runner.firstname)
AND LOWER(membership.surname) = LOWER(runner.surname) AND membership.dateofbirth = "0000-00-00"
ORDER BY membership.id asc;

-- update blank dob's
update membership set runner=7981,dateofbirth=(select r.dateOfBirth from runner as r where r.id=7981) where id=23;
update membership set dateofbirth=(select r.dateOfBirth from runner as r where r.id=10727) where id=10;
update membership set dateofbirth="1983-04-28" where id=9;
update membership set dateofbirth="1979-01-27" where id=18;
update membership set dateofbirth="1973-05-02" where id=20;
select * from membership where dateofbirth="0000-00-00";
delete from membership where id=93;

-- null runners
select * from membership where runner is NULL;
insert into company values(1006,"Mount Carmel Hospital",7,NULL,NULL)
insert into company values(1007,"Original Solutions",20,NULL,NULL)
update membership set companyid=329 where id=9;
update membership set companyid=701 where id=10;
update membership set companyid=161 where id=12;
update membership set companyid=1006 where id=13;
update membership set companyid=1007 where id=15;
update membership set companyid=94 where id=18;
update membership set companyid=93 where id=20;

insert into runner
select
6011,m.surname,m.firstname,m.gender,'0',m.dateofbirth,m.companyid,NULL,
m.email,m.newsletter,"",m.mobile,m.textmessage,
m.address1,m.address2,m.address3,NULL,
m.volunteer,"M",m.insertdate,DATE_ADD(m.insertdate,INTERVAL 1 YEAR)
from membership as m where m.id=20;
update membership set status="NEW",runner=6011 where id=20;

-- 
select * from membership where runner=0 order by id asc;

update membership set runner=4521 where id=67;
update membership set runner=7622 where id=68;

DROP TABLE IF EXISTS `migrate`;
CREATE TABLE IF NOT EXISTS `migrate` (
  `member` int(11) NOT NULL,
  `runner` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

insert into migrate select membership.id,runner.id
from runner join membership ON
LOWER(membership.firstname) = LOWER(runner.firstname)
AND LOWER(membership.surname) = LOWER(runner.surname)
AND LOWER(membership.dateofbirth) = LOWER(runner.dateOfBirth)
AND membership.status = "PENDING" AND runner.status != "D" and membership.runner=0
ORDER BY membership.id asc;

select membership.id,membership.firstname,membership.surname,membership.dateofbirth,runner.id,runner.status,runner.firstname,runner.surname,runner.dateOfBirth
insert into migrate select membership.id,runner.id
from runner join membership ON
LOWER(membership.firstname) = LOWER(runner.firstname)
AND LOWER(membership.surname) = LOWER(runner.surname)
AND membership.status = "PENDING" AND runner.status != "D" and membership.runner=0
ORDER BY membership.id asc;

select * from migrate;
select membership.id,membership.runner,migrate.runner from membership join migrate WHERE migrate.member=membership.id;
update membership join migrate on migrate.member=membership.id
set membership.runner=migrate.runner,membership.dateofbirth=(select dateOfBirth from runner where runner.id=migrate.runner) where membership.runner=0;


update membership set membership.runner=(select runner.id from runner))
join membership ON LOWER(membership.firstname) = LOWER(runner.firstname)
AND LOWER(membership.surname) = LOWER(runner.surname)
AND LOWER(membership.dateofbirth) = LOWER(runner.dateOfBirth)
AND membership.status = "PENDING" AND runner.status != "D" and membership.runner=0
ORDER BY membership.id asc;

--select membership.id, membership.companyid,membership.companyname, runner.id, runner.firstname, runner.surname,runner.status,runner.company from runner
select membership.id, membership.companyid,membership.companyname, runner.id, runner.firstname, runner.surname,runner.status,runner.company from runner
join membership ON  membership.firstname = runner.firstname
AND membership.surname = runner.surname
AND membership.dateofbirth = runner.dateOfBirth
AND membership.status = "PENDING" AND runner.status != "D" and membership.runner=0 order by membership.id asc;



select membership.id, membership.runner, runner.id, runner.firstname, runner.surname,runner.status,runner.company from runner
join membership ON membership.surname = runner.surname
AND membership.status = "PENDING" AND runner.status != "D" and membership.runner=0 order by membership.id asc;
--  membership.firstname = runner.firstname

select * from company;
describe company;

select * from membership;
select count(id) from membership;
select count(id) from membership where status="NEW";
select id,runner,firstname,surname from membership where status="PENDING" order by id asc;

select * from membership where surname="Bruton";

select * from membership where companyname="Microsoft";
update membership set companyid=971 where companyname="Microsoft";

select * from membership order by id asc;

-- 48,74,78,79,80 ->6000,1,2,3,4
insert into runner
select
'6004',m.surname,m.firstname,m.gender,'0',m.dateofbirth,m.companyid,NULL,
m.email,m.newsletter,"",m.mobile,m.textmessage,
m.address1,m.address2,m.address3,NULL,
m.volunteer,"M",m.insertdate,DATE_ADD(m.insertdate,INTERVAL 1 YEAR)
from membership as m where m.id=80;
update membership set status="NEW",runner=6004 where id=80;

select * from runner where company=971 and status="M";
select * from runner where id=6000,6001,6002,6003,6004;

describe runner;
describe membership;

-- add runners 6012->6029
insert into runner select 6029,
m.surname,m.firstname,m.gender,'0',m.dateofbirth,m.companyid,NULL,
m.email,m.newsletter,"",m.mobile,m.textmessage,
m.address1,m.address2,m.address3,NULL,
m.volunteer,"M",m.insertdate,DATE_ADD(m.insertdate,INTERVAL 1 YEAR)
from membership as m where m.id=111;
update membership set status="NEW",runner=6029 where id=111;

select id,runner,firstname,surname from membership where status="PENDING" order by id desc;

select r.id,r.firstname,r.surname,r.status,r.insertdate,r.renewaldate from runner as r join membership on membership.runner=r.id AND membership.status="PENDING";

update runner join membership on membership.runner=runner.id
set runner.status="M",runner.renewaldate=DATE_ADD(NOW(),INTERVAL 1 YEAR)
where membership.status="PENDING";

describe membership;
update membership set status="RENEWAL" where status="PENDING" and id<113;

select id,runner,firstname,surname,dateofbirth from membership where status="PENDING" order by id desc;

update membership set runner=5001 where id=115;
update membership set runner=7428 where id=116;
update membership set runner=5518 where id=117;
update membership set runner=7969 where id=118;
update membership set runner=7684 where id=119;
update membership set runner=7424 where id=121;

update runner join membership on membership.runner=runner.id
set runner.status="M",runner.renewaldate=DATE_ADD(NOW(),INTERVAL 1 YEAR)
where membership.status="PENDING";
update membership set status="PENDING" where id = 0;

insert into runner
select
6032,m.surname,m.firstname,m.gender,'0',m.dateofbirth,m.companyid,NULL,
m.email,m.newsletter,"",m.mobile,m.textmessage,
m.address1,m.address2,m.address3,NULL,
m.volunteer,"M",m.insertdate,DATE_ADD(m.insertdate,INTERVAL 1 YEAR)
from membership as m where m.id=114;
update membership set status="NEW",runner=6032 where id=114;

-- 6032


