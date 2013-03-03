
--select @maxid = max(id) from tbl

CREATE TEMPORARY TABLE IDSeq
(
    id int(11) NOT NULL
)
ENGINE=MyISAM DEFAULT CHARSET=utf8

INSERT INTO IDSeq values
declare @id int
declare @maxid int
set @id = 1000
set @maxid = 9999
while @id < @maxid
begin
    insert into IDSeq values(@id)
    set @id = @id + 1
end

select * from IDSeq;

select
    s.id
from
    idseq s
    left join tbl t on
        s.id = t.id
where t.id is null

drop table IDSeq


select l.id + 1 as start from runner as l
left outer join runner as r on l.id + 1 = r.id
where r.id is null and l.id>=8000 and l.id<8050;

select start, stop, (stop-start) as diff from (
  select m.id + 1 as start,
    (select min(id) - 1 from runner as x where x.id > m.id) as stop
  from runner as m
    left outer join runner as r on m.id = r.id - 1
  where r.id is null
) as x
where stop is not null;

select id,status from runner where id>=8000 and id<=8050;

select id,status from runner where id>=8000 and id<=8050;

select * from runner where id=8033;

select id,status from runner where id>=6000 and id<=6500;
