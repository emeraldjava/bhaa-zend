CREATE TABLE `eventexceptiontype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eventexceptiontypecode` varchar(32) NOT NULL,
  `eventexceptiontypedescription` varchar(256) NULL,
  PRIMARY KEY (`id`)
 );


INSERT INTO eventexceptiontype(eventexceptiontypecode,eventexceptiontypedescription)
VALUES ('EventOrganiser', 'A BHAA member who is involved in the organising an event 
who
will be awarded 10 points as opposed to their race points (if they competed).');

INSERT INTO eventexceptiontype(eventexceptiontypecode,eventexceptiontypedescription)
VALUES ('WomenInMansRace', 'A female BHAA member who competes in a mens race at an 
event.');

INSERT INTO eventexceptiontype(eventexceptiontypecode,eventexceptiontypedescription)
VALUES ('ManInWomansRace', 'A male BHAA member who competes in a womens race at an 
event.');

INSERT INTO eventexceptiontype(eventexceptiontypecode,eventexceptiontypedescription)
VALUES ('EventVolunteer', 'A BHAA member who volunteers at an event.');