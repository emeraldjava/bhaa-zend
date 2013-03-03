
select * from sector;
describe sector;
describe runner;
select * from sct;

select count(company.id) from company where company.sector = 1

select count(runner.id) from runner as runner 
join company as company on runner.company=company.id
join sector as sector on company.sector=sector.id
and sector.id=1;

insert into sector(id,name,description,valid) VALUES(48,"Undefined","Holder for companies without a sector","Y");
update company set sector=48 where sector=0;

select id,name,sector from sct where id>50;

describe company;
insert into company(id,name,sector) select id,name,sector from sct where id>50;
