DROP TABLE IF EXISTS `standarddata`;
CREATE TABLE IF NOT EXISTS `standarddata` (
  `standard` int(11) NOT NULL,
  `distance` double NOT NULL,
  `unit` enum('KM','Mile') default 'KM' NOT NULL,
  `pace` time NOT NULL,
  `time` time NOT NULL
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=32 ;

INSERT INTO standarddata select id,1,'KM',
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(1,'Km')-1)) + oneKmTimeInSecs) ),
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(1,'Km')-1)) + oneKmTimeInSecs) * getRaceDistanceKm(1,'Km'))
FROM standard;
INSERT INTO standarddata select id,2,'KM',
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(2,'Km')-1)) + oneKmTimeInSecs) ),
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(2,'Km')-1)) + oneKmTimeInSecs) * getRaceDistanceKm(2,'Km'))
FROM standard;
INSERT INTO standarddata select id,3,'KM',
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(3,'Km')-1)) + oneKmTimeInSecs) ),
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(3,'Km')-1)) + oneKmTimeInSecs) * getRaceDistanceKm(3,'Km'))
FROM standard;
INSERT INTO standarddata select id,5,'KM',
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(5,'Km')-1)) + oneKmTimeInSecs) ),
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(5,'Km')-1)) + oneKmTimeInSecs) * getRaceDistanceKm(5,'Km'))
FROM standard;
INSERT INTO standarddata select id,8,'KM',
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(8,'Km')-1)) + oneKmTimeInSecs) ),
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(8,'Km')-1)) + oneKmTimeInSecs) * getRaceDistanceKm(8,'Km'))
FROM standard;
INSERT INTO standarddata select id,10,'KM',
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(10,'Km')-1)) + oneKmTimeInSecs) ),
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(10,'Km')-1)) + oneKmTimeInSecs) * getRaceDistanceKm(10,'Km'))
FROM standard;
INSERT INTO standarddata select id,1,'Mile',
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(1,'Mile')-1)) + oneKmTimeInSecs) ),
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(1,'Mile')-1)) + oneKmTimeInSecs) * getRaceDistanceKm(1,'Mile'))
FROM standard;
INSERT INTO standarddata select id,2,'Mile',
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(2,'Mile')-1)) + oneKmTimeInSecs) ),
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(2,'Mile')-1)) + oneKmTimeInSecs) * getRaceDistanceKm(2,'Mile'))
FROM standard;
INSERT INTO standarddata select id,3,'Mile',
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(3,'Mile')-1)) + oneKmTimeInSecs) ),
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(3,'Mile')-1)) + oneKmTimeInSecs) * getRaceDistanceKm(3,'Mile'))
FROM standard;
INSERT INTO standarddata select id,5,'Mile',
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(5,'Mile')-1)) + oneKmTimeInSecs) ),
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(5,'Mile')-1)) + oneKmTimeInSecs) * getRaceDistanceKm(5,'Mile'))
FROM standard;
INSERT INTO standarddata select id,8,'Mile',
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(8,'Mile')-1)) + oneKmTimeInSecs) ),
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(8,'Mile')-1)) + oneKmTimeInSecs) * getRaceDistanceKm(8,'Mile'))
FROM standard;
INSERT INTO standarddata select id,10,'Mile',
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(10,'Mile')-1)) + oneKmTimeInSecs) ),
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(10,'Mile')-1)) + oneKmTimeInSecs) * getRaceDistanceKm(10,'Mile'))
FROM standard;      
INSERT INTO standarddata select id,13.1,'Mile',
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(13.1,'Mile')-1)) + oneKmTimeInSecs) ),
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(13.1,'Mile')-1)) + oneKmTimeInSecs) * getRaceDistanceKm(13.1,'Mile'))
FROM standard;      
INSERT INTO standarddata select id,26.2,'Mile',
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(26.2,'Mile')-1)) + oneKmTimeInSecs) ),
SEC_TO_TIME(((slopefactor * (getRaceDistanceKm(26.2,'Mile')-1)) + oneKmTimeInSecs) * getRaceDistanceKm(26.2,'Mile'))
FROM standard;

-- apply a factor to the various values
select standard,
SEC_TO_TIME((((slopefactor*1.0) * (getRaceDistanceKm(1,'Km')-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) * getRaceDistanceKm(1,'Km')) as 1km,
SEC_TO_TIME((((slopefactor*1.0) * (getRaceDistanceKm(1,'Mile')-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) * getRaceDistanceKm(1,'Mile')) as 1m,
SEC_TO_TIME((((slopefactor*1.0) * (getRaceDistanceKm(2,'Mile')-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) * getRaceDistanceKm(2,'Mile')) as 2m,
SEC_TO_TIME((((slopefactor*1.0) * (getRaceDistanceKm(5,'Km')-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) * getRaceDistanceKm(5,'Km')) as 5km,
SEC_TO_TIME((((slopefactor*1.0) * (getRaceDistanceKm(5,'Mile')-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) * getRaceDistanceKm(4,'Mile')) as 4m,
SEC_TO_TIME((((slopefactor*1.0) * (getRaceDistanceKm(8,'Mile')-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) * getRaceDistanceKm(5,'Mile')) as 5m,
SEC_TO_TIME((((slopefactor*1.0) * (getRaceDistanceKm(10,'Km')-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) * getRaceDistanceKm(10,'Km')) as 10km,
SEC_TO_TIME((((slopefactor*1.0) * (getRaceDistanceKm(10,'Mile')-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) * getRaceDistanceKm(10,'Mile')) as 10m,
SEC_TO_TIME((((slopefactor*1.0) * (getRaceDistanceKm(13.1,'Mile')-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) * getRaceDistanceKm(13.1,'Mile')) as half,
SEC_TO_TIME((((slopefactor*1.0) * (getRaceDistanceKm(26.2,'Mile')-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) * getRaceDistanceKm(26.2,'Mile')) as mar
FROM standard;
