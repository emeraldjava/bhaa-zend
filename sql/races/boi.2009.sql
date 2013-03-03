ALTER TABLE teamraceresult CHANGE class class ENUM('A','B','C','D','W');

update teamraceresult set runnerfirst=,runnersecond=,runnerthird= where team=18 and class="W";

insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (204,4,72,24,45,"A");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (93,4,72,26,56,"A");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (71,4,72,28,92,"A");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (58,4,72,33,191,"A");
update teamraceresult set runnerfirst=7603,runnersecond=8885,runnerthird=5245 where team=204 and class="A";
update teamraceresult set runnerfirst=5065,runnersecond=5120,runnerthird=5028 where team=93 and class="A";
update teamraceresult set runnerfirst=5125,runnersecond=7094,runnerthird=9150 where team=71 and class="A";
update teamraceresult set runnerfirst=,runnersecond=,runnerthird= where team=58 and class="A";

insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (84,4,72,35,175,"B");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (17,4,72,34,186,"B");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (110,4,72,36,224,"B");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (94,4,72,35,225,"B");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (701,4,72,38,275,"B");
update teamraceresult set runnerfirst=5767,runnersecond=8359,runnerthird=8118 where team=84 and class="B";
update teamraceresult set runnerfirst=5048,runnersecond=7218,runnerthird=7474 where team=17 and class="B";
update teamraceresult set runnerfirst=7121,runnersecond=4726,runnerthird=7871 where team=110 and class="B";
update teamraceresult set runnerfirst=9710,runnersecond=7960,runnerthird=4722 where team=94 and class="B";
update teamraceresult set runnerfirst=7305,runnersecond=7669,runnerthird=4714 where team=701 and class="B";

insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (93,4,72,39,172,"C");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (137,4,72,43,239,"C");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (204,4,72,39,249,"C");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (121,4,72,44,260,"C");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (117,4,72,44,280,"C");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (221,4,72,39,361,"C");
update teamraceresult set runnerfirst=5846,runnersecond=9005,runnerthird=5845 where team=93 and class="C";
update teamraceresult set runnerfirst=7428,runnersecond=9345,runnerthird=7507 where team=137 and class="C";
update teamraceresult set runnerfirst=5135,runnersecond=5781,runnerthird=5230 where team=204 and class="C";
update teamraceresult set runnerfirst=7365,runnersecond=7373,runnerthird=9245 where team=121 and class="C";
update teamraceresult set runnerfirst=5463,runnersecond=5788,runnerthird=5577 where team=117 and class="C";
update teamraceresult set runnerfirst=5576,runnersecond=4723,runnerthird=4742 where team=221 and class="C";

insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (90,4,72,46,262,"D");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (93,4,72,46,332,"D");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (175,4,72,51,442,"D");
insert into teamraceresult(team,league,race,standardtotal,positiontotal,class) VALUES (84,4,72,64,518,"D");
update teamraceresult set runnerfirst=8877,runnersecond=4521,runnerthird=7962 where team=90 and class="D";
update teamraceresult set runnerfirst=7143,runnersecond=5408,runnerthird=7155 where team=93 and class="D";
update teamraceresult set runnerfirst=5101,runnersecond=5404,runnerthird=7175 where team=175 and class="D";
update teamraceresult set runnerfirst=7595,runnersecond=7617,runnerthird=7615 where team=84 and class="D";

insert into teamraceresult(team,league,race,positiontotal,class) VALUES (18,4,72,386,"W");
insert into teamraceresult(team,league,race,positiontotal,class) VALUES (137,4,72,452,"W");
insert into teamraceresult(team,league,race,positiontotal,class) VALUES (117,4,72,468,"W");
update teamraceresult set runnerfirst=8747,runnersecond=8572,runnerthird=5143 where team=18 and class="W";
update teamraceresult set runnerfirst=7420,runnersecond=5861,runnerthird=7421 where team=137 and class="W";
update teamraceresult set runnerfirst=5394,runnersecond=5147,runnerthird=7569 where team=117 and class="W";



