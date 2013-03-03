
-- select charlies runners with regdate.
select MembNo,Name,Surname,RegDate from tblMembership where RegDate is not null;

select
tblMembership.MembNo,tblMembership.Name,tblMembership.Surname,tblMembership.RegDate,
runner.dateofrenewal,runner.status
from tblMembership join runner on runner.id=tblMembership.Membno
where tblMembership.RegDate is not null and runner.dateofrenewal is null;

update runner
join tblMembership on runner.id=tblMembership.MembNo
set runner.dateofrenewal = STR_TO_DATE(tblMembership.RegDate,'%m/%d/%y'),runner.status = "M"
where tblMembership.RegDate is not null and runner.dateofrenewal is null;

describe tblMembership

select
tblMembership.MembNo,tblMembership.Name,tblMembership.Surname,tblMembership.Year,tblMembership.RegDate,
runner.dateofrenewal,runner.status
from tblMembership join runner on runner.id=tblMembership.Membno
where tblMembership.Year="09";

select count(MembNo),
(select count(MembNo) from tblMembership where tblMembership.Year="10") as '2010',
(select count(MembNo) from tblMembership where tblMembership.Year="09") as '2009',
(select count(MembNo) from tblMembership where tblMembership.Year="08") as '2008',
(select count(MembNo) from tblMembership where tblMembership.Year="07") as '2007',
(select count(MembNo) from tblMembership where tblMembership.Year="06") as '2006',
(select count(MembNo) from tblMembership where tblMembership.Year is null) as 'null'
from tblMembership;

select distinct(YEAR) from tblMembership;
select distinct(tblMembership.YEAR),(select count(t.Membno) from tblMembership as t where tblMembership.YEAR = t.YEAR) nonrenewed from tblMembership;

select
tblMembership.MembNo,tblMembership.Name,tblMembership.Surname,tblMembership.Year,
runner.insertdate,runner.dateofrenewal,runner.status
from tblMembership join runner on runner.id=tblMembership.Membno
where tblMembership.Year is null and runner.status="M";

select * from runner where firstname is null;


select id,firstname,surname,email,status,dateofrenewal from runner where company=110 and status="M";

