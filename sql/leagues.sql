
select * from league;
describe league;
ALTER TABLE league ALTER COLUMN name varchar(40);
insert into league VALUES (0,"Winter League 09/10",2009,"I");

select * from event;
select * from event where id>=1 and id<=7;

describe leagueevent;
delete from leagueevent;
select * from leagueevent;

insert into leagueevent(id,league,event) select 0,1,event.id from event where event.id>=8 and event.id<=22;
insert into leagueevent(id,league,event) select 0,2,event.id from event where event.id>=1 and event.id<=7;

