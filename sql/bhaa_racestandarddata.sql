DROP TABLE IF EXISTS `racestandarddata`;
CREATE TABLE IF NOT EXISTS `racestandarddata` (
  `race` int(8) NOT NULL,
  `standard` int(2) NOT NULL,
  `runners` int(4) NOT NULL,
  `t_expected` time NOT NULL,
  `t_min` time NOT NULL,
  `t_average` time NOT NULL,
  `t_max` time NOT NULL,
  `t_exp_avg_diff` int NOT NULL,
  `p_expected` time NOT NULL,
  `p_min` time NOT NULL,
  `p_average` time NOT NULL,
  `p_max` time NOT NULL,
  `p_exp_avg_diff` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

select race from racestandarddata
left join race on race.id=racestandarddata.race and racestandarddata.race=NULL

select id from race
left join racestandarddata on race.id=racestandarddata.race and racestandarddata.race=NULL

select *
from race left join racestandarddata on
    race.id = racestandarddata.race
    and racestandarddata.race is null

select id from race where not exists (select race from racestandarddata where race.id=racestandarddata.race);
select id from race where not exists (select race from racestandarddata where race.id=racestandarddata.race);



INSERT INTO racestandarddata
select
coalesce(race.id,20108) as race,
sd.standard as standard,
count(rr.runner) as runners,
coalesce(SEC_TO_TIME((oneKmTimeInSecs + (getRaceDistanceKM(X.distance,X.unit)*slopefactor))*getRaceDistanceKM(X.distance,X.unit) ),0) as t_expected,
coalesce(min(rr.racetime),0) as t_min,
coalesce(SEC_TO_TIME(avg(TIME_TO_SEC(rr.racetime))),0) as t_avg,
coalesce(max(rr.racetime),0) as t_max,
IF(count(rr.runner)=0,0,
ROUND(coalesce( (oneKmTimeInSecs + (getRaceDistanceKM(X.distance,X.unit)*slopefactor))*getRaceDistanceKM(X.distance,X.unit) ,0) -
(coalesce( avg(TIME_TO_SEC(rr.racetime)),0)),0) ) as t_exp_avg_diff,
coalesce(SEC_TO_TIME((oneKmTimeInSecs + (getRaceDistanceKM(race.distance,race.unit)*slopefactor))),0) as p_expected,
coalesce(min(rr.paceKM),0) as p_min,
coalesce(SEC_TO_TIME(avg(TIME_TO_SEC(rr.paceKM))),0) as p_avg,
coalesce(max(rr.paceKM),0) as p_max,
IF(count(rr.runner)=0,0,
ROUND(coalesce( (oneKmTimeInSecs + (getRaceDistanceKM(race.distance,race.unit)*slopefactor)) ,0) -
(coalesce( avg(TIME_TO_SEC(rr.paceKM)),0)),0) ) as t_exp_avg_diff
from standard sd
left join  raceresult rr on rr.standard = sd.standard and rr.race=20108
left join  race  on rr.race = race.id
join (select race.id,race.distance,race.unit from race where id=20108) X on coalesce(race.id,20108)=X.id
 where not exists (select race from racestandarddata where race.id=racestandarddata.race)
group by sd.standard;

select
race.id as race,
sd.standard as standard,
count(rr.runner) as runners,
coalesce(SEC_TO_TIME((oneKmTimeInSecs + (getRaceDistanceKM(X.distance,X.unit)*slopefactor))*getRaceDistanceKM(X.distance,X.unit) ),0) as t_expected,
coalesce(min(rr.racetime),0) as t_min,
coalesce(SEC_TO_TIME(avg(TIME_TO_SEC(rr.racetime))),0) as t_avg,
coalesce(max(rr.racetime),0) as t_max,
IF(count(rr.runner)=0,0,
ROUND(coalesce( (oneKmTimeInSecs + (getRaceDistanceKM(X.distance,X.unit)*slopefactor))*getRaceDistanceKM(X.distance,X.unit) ,0) -
(coalesce( avg(TIME_TO_SEC(rr.racetime)),0)),0) ) as t_exp_avg_diff,
coalesce(SEC_TO_TIME((oneKmTimeInSecs + (getRaceDistanceKM(race.distance,race.unit)*slopefactor))),0) as p_expected,
coalesce(min(rr.paceKM),0) as p_min,
coalesce(SEC_TO_TIME(avg(TIME_TO_SEC(rr.paceKM))),0) as p_avg,
coalesce(max(rr.paceKM),0) as p_max,
IF(count(rr.runner)=0,0,
ROUND(coalesce( (oneKmTimeInSecs + (getRaceDistanceKM(race.distance,race.unit)*slopefactor)) ,0) -
(coalesce( avg(TIME_TO_SEC(rr.paceKM)),0)),0) ) as t_exp_avg_diff
from standard sd
left join  raceresult rr on rr.standard = sd.standard and rr.race=20108
left join  race  on rr.race = race.id
join (select race.id,race.distance,race.unit from race where id=20108) X on coalesce(race.id,20108)=X.id
 where not exists (select race from racestandarddata where race.id=racestandarddata.race)
group by sd.standard;


-- division based standard time report
select d.id,d.name,
sec_to_time(avg(time_to_sec(rts.p_min))) as avg_pace_min,
sec_to_time(avg(time_to_sec(rts.p_average))) as avg_pace_avg,
sec_to_time(avg(time_to_sec(rts.p_max))) as avg_pace_max
from division d
join racestandarddata rts on rts.standard between d.min and d.max and rts.t_average>0
where d.type='I'
group by d.id,d.name;

-- select the DCC, RTE, INTEL and Pearl Races
select 
rsd.standard,
(select p_min from racestandarddata where race=15 and standard=standard.id) as dccmin,
(select p_average from racestandarddata where race=15 and standard=standard.id) as dccavg,
(select p_max from racestandarddata where race=15 and standard=standard.id) as dccmax,
(select p_min from racestandarddata where race=17 and standard=standard.id) as rtemin,
(select p_average from racestandarddata where race=17 and standard=standard.id) as rteavg,
(select p_max from racestandarddata where race=17 and standard=standard.id) as rtemax,
(select p_min from racestandarddata where race=31 and standard=standard.id) as intelmin,
(select p_average from racestandarddata where race=31 and standard=standard.id) as intelavg,
(select p_max from racestandarddata where race=31 and standard=standard.id) as intelmax,
(select p_min from racestandarddata where race=62 and standard=standard.id) as pearlmin,
(select p_average from racestandarddata where race=62 and standard=standard.id) as pearlavg,
(select p_max from racestandarddata where race=62 and standard=standard.id) as pearlmax
from racestandarddata rsd
join standard on standard.id=rsd.standard;


select
rsd.standard,
(select t_min from racestandarddata where race=15 and standard=standard.id) as dcctmin,
(select t_average from racestandarddata where race=15 and standard=standard.id) as dcctavg,
(select t_max from racestandarddata where race=15 and standard=standard.id) as dcctmax,
(select p_min from racestandarddata where race=15 and standard=standard.id) as dccmin,
(select p_average from racestandarddata where race=15 and standard=standard.id) as dccavg,
(select p_max from racestandarddata where race=15 and standard=standard.id) as dccmax
from racestandarddata rsd
join standard on standard.id=rsd.standard;

select d.id,d.name,d.min,d.max,
sec_to_time(avg(time_to_sec(rts.p_min))) as avg_pace_min,
sec_to_time(avg(time_to_sec(rts.p_average))) as avg_pace_avg,
sec_to_time(avg(time_to_sec(rts.p_max))) as avg_pace_max,
sec_to_time(avg(time_to_sec(rts.t_min))) as avg_time_min,
sec_to_time(avg(time_to_sec(rts.t_average))) as avg_time_avg,
sec_to_time(avg(time_to_sec(rts.t_max))) as avg_time_max
from division d
join racestandarddata rts on rts.standard between d.min and d.max and rts.t_average>0
where d.type='I' and race=15
group by d.id,d.name;


select
rsd.standard,
(select name from division where standard between d.min and d.max) as div,
(select t_min from racestandarddata where race=15 and standard=standard.id) as dcctmin,
(select t_average from racestandarddata where race=15 and standard=standard.id) as dcctavg,
(select t_max from racestandarddata where race=15 and standard=standard.id) as dcctmax,
(select p_min from racestandarddata where race=15 and standard=standard.id) as dccmin,
(select p_average from racestandarddata where race=15 and standard=standard.id) as dccavg,
(select p_max from racestandarddata where race=15 and standard=standard.id) as dccmax
from racestandarddata rsd
join standard on standard.id=rsd.standard;


