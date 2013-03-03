CREATE PROCEDURE `updateOrganisersSummerLeague2009`()
BEGIN

DECLARE _DCC INT(11);
DECLARE _Kepak INT(11);
DECLARE _RTE INT(11);
DECLARE _Intel INT(11);
DECLARE _ESB INT(11);
DECLARE _Gov_Services INT(11);
DECLARE _Army INT(11);
DECLARE _DCC_Irishtown INT(11);
DECLARE _Hibernian INT(11);
DECLARE _Irish_Life INT(11);
DECLARE _Zurich INT(11);
DECLARE _Pearl_Izumi INT(11);

DELETE FROM RaceOrganiser WHERE league = 1;


SET _DCC = (SELECT id FROM event WHERE name='DCC');
IF _DCC  IS NOT NULL THEN
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_DCC, 5065, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_DCC, 7646, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_DCC, 8963, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_DCC, 5408, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_DCC, 8096, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_DCC, 8609, 1);
END IF;

SET _Kepak = (SELECT id FROM event WHERE name='Kepak');

SET _RTE = (SELECT id FROM event WHERE name='RTE');
IF _RTE  IS NOT NULL THEN
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_RTE, 7365, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_RTE, 8288, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_RTE, 7373, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_RTE, 7634, 1);
END IF;

SET _Intel = (SELECT id FROM event WHERE name='Intel');
IF _Intel  IS NOT NULL THEN
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Intel, 9378, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Intel, 9012, 1);
END IF;

SET _ESB = (SELECT id FROM event WHERE name='ESB');
IF _ESB  IS NOT NULL THEN
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_ESB, 7549, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_ESB, 7531, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_ESB, 5507, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_ESB, 7597, 1);
END IF;


SET _Gov_Services = (SELECT id FROM event WHERE name='Gov Services');
IF _Gov_Services  IS NOT NULL THEN
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Gov_Services, 7721, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Gov_Services, 7382, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Gov_Services, 7404, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Gov_Services, 8994, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Gov_Services, 7406, 1);
END IF;


SET _DCC_Irishtown = (SELECT id FROM event WHERE name='DCC Irishtown');
IF _DCC_Irishtown  IS NOT NULL THEN
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_DCC_Irishtown, 5065, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_DCC_Irishtown, 9005, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_DCC_Irishtown, 9391, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_DCC_Irishtown, 8096, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_DCC_Irishtown, 8406, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_DCC_Irishtown, 5845, 1);
END IF;


SET _Irish_Life = (SELECT id FROM event WHERE name='Irish Life and Permanent');
IF _Irish_Life  IS NOT NULL THEN
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Irish_Life, 5463, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Irish_Life, 5577, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Irish_Life, 7966, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Irish_Life, 5474, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Irish_Life, 7397, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Irish_Life, 7396, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Irish_Life, 7830, 1);
INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Irish_Life, 5794, 1);
END IF;

SET _Zurich = (SELECT id FROM event WHERE name='Zurich');
IF _Zurich  IS NOT NULL THEN
 INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Zurich, 5051, 1);
 INSERT INTO RaceOrganiser(event, runner,league) VALUES(_Zurich, 7175, 1);
END IF;

END