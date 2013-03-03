
DROP TABLE IF EXISTS `metadata`;
CREATE TABLE IF NOT EXISTS `metadata` (
	`entity` enum('EVENT','RACE','RUNNER','ADMIN') NOT NULL,
	`id` int(11) NOT NULL,
	`name` varchar(50) NOT NULL,
  	`value` varchar(200) NOT NULL,
  PRIMARY KEY  (`entity`,`id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SELECT `metadata`.* FROM `metadata` WHERE (entity = "EVENT") AND (id = 20107) AND (name = "EVENT_NOTE")

INSERT INTO metadata VALUES('ADMIN',0,"MEMBERSHIP_FORM","ENABLED");

INSERT INTO metadata VALUES('EVENT',20101,"EVENT_NOTE","This race has been defered dur to snow.");
INSERT INTO metadata VALUES('EVENT',20101,"EVENT_CONTACT","Mick McCartan 086-8170440");
INSERT INTO metadata VALUES('EVENT',20101,"EVENT_GMAP_LON","53.297408");
INSERT INTO metadata VALUES('EVENT',20101,"EVENT_GMAP_LAT","-6.327481");

INSERT INTO metadata VALUES('EVENT',20102,"EVENT_CONTACT","Kevin Donoghue 085-1744475, Derek Quinn 085-1740109");
INSERT INTO metadata VALUES('EVENT',20103,"EVENT_CONTACT","Paul Barnwall 087-2329577, Matt Dwyer 087-6780365");
INSERT INTO metadata VALUES('EVENT',20104,"EVENT_CONTACT","Gerry Martin 6241742(h), Eugene Foley 086-3835695");
INSERT INTO metadata VALUES('EVENT',20105,"EVENT_CONTACT","John Leonard 6662559(w), Brian Brunton 086-8282347");
INSERT INTO metadata VALUES('EVENT',20106,"EVENT_CONTACT","Paul Barnwall 087-2329577, Robert McNamara 087-6991242");

INSERT INTO metadata VALUES('EVENT',20103,"EVENT_NOTE","11.30 Combined Start. 2.5M Ladies, 5M Men");
INSERT INTO metadata VALUES('EVENT',20104,"EVENT_NOTE","11.30 2.5M Ladies, 12.00 5M Men");
INSERT INTO metadata VALUES('EVENT',20105,"EVENT_NOTE","11.30 Combined Start. 2M Ladies, 4M Men");
INSERT INTO metadata VALUES('EVENT',20106,"EVENT_NOTE","7.30PM 5Km Combined");

INSERT INTO metadata VALUES('EVENT',20107,"EVENT_NOTE","11.00 2.5M Ladies, 11.30 4M Men");
INSERT INTO metadata VALUES('EVENT',20107,"EVENT_CONTACT","Eddie Hughes 01-4947960, Maurice Timmins 01-4782317");
INSERT INTO metadata VALUES('EVENT',20107,"EVENT_FLYER","http://bhaa.ie/documents/2010/nuiaib2010/bhaa_maynooth_flyer.jpg");

INSERT INTO metadata VALUES('EVENT',20108,"EVENT_NOTE","St Pauls School, Raheny, 11.00 2M Ladies, 11.30 4M Men");
INSERT INTO metadata VALUES('EVENT',20108,"EVENT_CONTACT","Jim Kelly 01-8166720(w),Kevin O'Connell 01-2223585(w),Coilin O'Reilly 01-2227598(w)");
INSERT INTO metadata VALUES('EVENT',20108,"EVENT_FLYER","http://bhaa.ie/documents/2010/dcc2010/DCC_2010.jpg");

INSERT INTO metadata VALUES('EVENT',20109,"EVENT_NOTE","Smurfirt Clubhouse, K Club, Straffan, Co Kildare, 11.00am 10km Road Race");
INSERT INTO metadata VALUES('EVENT',20109,"EVENT_CONTACT","Gerry Byrne 086-2434712");
INSERT INTO metadata VALUES('EVENT',20109,"EVENT_FLYER","http://bhaa.ie/documents/2010/kclub2010/kclub2010.jpg");

-- INSERT INTO metadata VALUES('EVENT',20109,"EVENT_NOTE","Smurfirt Clubhouse, K Club, Straffan, Co Kildare, 11.00am 10km Road Race");
-- INSERT INTO metadata VALUES('EVENT',20109,"EVENT_CONTACT","Gerry Byrne 086-2434712");
INSERT INTO metadata VALUES('EVENT',201010,"EVENT_FLYER","http://bhaa.ie/documents/2010/rte2010/rte2010.png");

delete from metadata where id = 20107;
http://www.gorissen.info/Pierre/maps/googleMapLocation.php
<iframe width="425" height="350" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="http://www.google.com/maps/ms?ie=UTF8&amp;msa=0&amp;msid=110398891020944036591.000462e322a4a6111a4f7&amp;ll=53.371191,-6.389193&amp;spn=0.189268,0.426493&amp;output=embed"></iframe><br /><small>View <a href="http://www.google.com/maps/ms?ie=UTF8&amp;msa=0&amp;msid=110398891020944036591.000462e322a4a6111a4f7&amp;ll=53.371191,-6.389193&amp;spn=0.189268,0.426493&amp;source=embed" style="color:#0000FF;text-align:left">BHAA Race Locations</a> in a larger map</small>

