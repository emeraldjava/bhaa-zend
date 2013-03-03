DELIMITER $$

DROP FUNCTION `getAgeCategory` $$
CREATE DEFINER=`bhaa1_mread`@`localhost` FUNCTION `getAgeCategory`(_birthDate DATE, _currentDate DATE, _gender ENUM('M','W'), _returnCode BIT) RETURNS varchar(4) CHARSET utf8
BEGIN
DECLARE _age INT(11);
DECLARE _returnValue VARCHAR(4);
SET _age = (YEAR(_currentDate)-YEAR(_birthDate)) - (RIGHT(_currentDate,5)<RIGHT(_birthDate,5));
IF _returnCode = 1 THEN
  SET _returnValue = (SELECT code FROM agecategory WHERE (_age between min and max)
and gender=_gender);
ELSE
  SET _returnValue = (SELECT category FROM agecategory WHERE (_age between min and
max) and gender=_gender);
END IF;
RETURN _returnValue;

END $$

DELIMITER ;
