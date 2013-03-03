
select * from raceresult;
select * from runner;
select * from event;
select * from race;

show tables;
describe standards;
describe raceresult;

call UpdateIndividualPointsByRaceId(11);

call populateStandardTimes();
call UpdateResultsByCombinedRaceId(1,0);


select * from runner where id=7713;

SELECT `isp_partners_view`.*, (CASE WHEN `password` = '*****' THEN 1 ELSE 0 END) 
AS `zend_auth_credential_match` FROM `isp_partners_view` WHERE (`username` = '*****')

SELECT `runner`.*, (CASE WHEN `id` = '7713' THEN 1 ELSE 0 END) AS `zend_auth_credential_match`
FROM `runner` WHERE (`name` = 'Paul')

SELECT `runner`.*, (CASE WHEN `name` = 'Paul' THEN 1 ELSE 0 END) AS `zend_auth_credential_match`
FROM `runner` WHERE (`id` = '7713')


describe raceresult;
ALTER TABLE raceresult ADD COLUMN standard INT;
ALTER TABLE raceresult ADD COLUMN points DOUBLE;

describe runner;
ALTER TABLE runner ADD COLUMN email VARCHAR(40);
ALTER TABLE runner ADD COLUMN mobile VARCHAR(40);

select * from raceresult where runner=7713;
select standard from runner where id=7713;
update raceresult set standard=(select standard from runner where runner.id=raceresult.runner);

CREATE TABLE login (
    id INTEGER NOT NULL AUTO_INCREMENT,
    runner INTEGER NOT NULL,
    email VARCHAR(50) NOT NULL,
    mobile VARCHAR(30) NOT NULL,
    PRIMARY KEY(id)
);
INSERT INTO login VALUES(NULL,7713,"paul.t.oconnell@gmail.com","0863701860");

CREATE TABLE sector (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    description VARCHAR(100) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE company (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    sector INTEGER,
    contact INTEGER,
    PRIMARY KEY(id)
);

CREATE TABLE team (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    sector INTEGER,
    company INTEGER,
    PRIMARY KEY(id)
);

CREATE TABLE division (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR(20),
    code VARCHAR(2),
    gender ENUM("M","W","T") DEFAULT "M",
    min INTEGER NOT NULL,
    max INTEGER NOT NULL,
    PRIMARY KEY (id)
);
INSERT INTO division VALUES (NULL,"Men Division A","A","M",1,7);
INSERT INTO division VALUES (NULL,"Men Division B","B","M",8,10);
INSERT INTO division VALUES (NULL,"Men Division C","C","M",11,13);
INSERT INTO division VALUES (NULL,"Men Division D","D","M",14,16);
INSERT INTO division VALUES (NULL,"Men Division E","E","M",17,21);
INSERT INTO division VALUES (NULL,"Men Division F","F","M",22,30);
INSERT INTO division VALUES (NULL,"Women Division A","L1","W",1,16);
INSERT INTO division VALUES (NULL,"Women Division B","L2","W",17,30);
INSERT INTO division VALUES (NULL,"Team Division A","TA","T",3,28);
INSERT INTO division VALUES (NULL,"Team Division B","TB","T",29,38);
INSERT INTO division VALUES (NULL,"Team Division C","TC","T",39,45);
INSERT INTO division VALUES (NULL,"Team Division D","TD","T",46,90);
select * from division;

CREATE TABLE league (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR(20),
    year VARCHAR(4),
    type ENUM("I","T") DEFAULT "I",
    PRIMARY KEY (id)
);
INSERT INTO league VALUES (NULL,"Summer League 2009","2009","I");
INSERT INTO league VALUES (NULL,"Winter League 2009","2009","I");
INSERT INTO league VALUES (NULL,"Team League 2009","2009","T");
select * from league;

drop table leagueevent;
CREATE TABLE leagueevent (
    id INTEGER NOT NULL AUTO_INCREMENT,
    league INTEGER,
    event INTEGER,
    PRIMARY KEY (id),
    CONSTRAINT fk_league_id FOREIGN KEY (league) REFERENCES league(id),
    CONSTRAINT fk_event_id FOREIGN KEY (event) REFERENCES event(id)
);
select * from leagueevent;
select * from event;
select * from race;
INSERT INTO leagueevent VALUES (NULL,1,8);
INSERT INTO leagueevent VALUES (NULL,1,9);
INSERT INTO leagueevent VALUES (NULL,1,10);
INSERT INTO leagueevent VALUES (NULL,1,12);
INSERT INTO leagueevent VALUES (NULL,1,13);
INSERT INTO leagueevent VALUES (NULL,1,15);

INSERT INTO leagueevent VALUES (NULL,2,1);
INSERT INTO leagueevent VALUES (NULL,2,2);
INSERT INTO leagueevent VALUES (NULL,2,3);
INSERT INTO leagueevent VALUES (NULL,2,4);
INSERT INTO leagueevent VALUES (NULL,2,5);
INSERT INTO leagueevent VALUES (NULL,2,6);
INSERT INTO leagueevent VALUES (NULL,2,7);

INSERT INTO leagueevent VALUES (NULL,3,1);
INSERT INTO leagueevent VALUES (NULL,3,2);
INSERT INTO leagueevent VALUES (NULL,3,3);
INSERT INTO leagueevent VALUES (NULL,3,4);
INSERT INTO leagueevent VALUES (NULL,3,5);
INSERT INTO leagueevent VALUES (NULL,3,6);
INSERT INTO leagueevent VALUES (NULL,3,7);
INSERT INTO leagueevent VALUES (NULL,3,8);
INSERT INTO leagueevent VALUES (NULL,3,9);
INSERT INTO leagueevent VALUES (NULL,3,10);
INSERT INTO leagueevent VALUES (NULL,3,12);
INSERT INTO leagueevent VALUES (NULL,3,13);
INSERT INTO leagueevent VALUES (NULL,3,15);
