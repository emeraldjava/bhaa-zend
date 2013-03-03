DROP PROCEDURE `listRunners`//
CREATE DEFINER=`bhaa1`@`localhost` PROCEDURE `listRunners`(_firstName VARCHAR(30), _surName VARCHAR(30), _dob DATE)
BEGIN



SET @sql = 'SELECT * FROM runner WHERE ';
SET @sqlWhere = '';

IF (_firstName IS NOT NULL) THEN
  SET @sqlWhere = CONCAT(@sqlWhere,'firstName like ''',_firstName,'''');
END IF;

IF (_surName IS NOT NULL) THEN
  IF (_firstName IS NOT NULL) THEN
    SET @sqlWhere = CONCAT(@sqlWhere,' AND ');
  END IF;
  SET @sqlWhere = CONCAT(@sqlWhere,'surname like ''',_surName,'''');
END IF;

IF (_dob IS NOT NULL) THEN
  IF (_firstName IS NOT NULL OR _surName IS NOT NULL) THEN
    SET @sqlWhere = CONCAT(@sqlWhere,' AND ');
  END IF;
  SET @sqlWhere = CONCAT(@sqlWhere,'dateofbirth=''',_dob,'''');
END IF;

SET @sql = CONCAT(@sql,@sqlWhere);

PREPARE s1 FROM @sql;
EXECUTE s1;
DEALLOCATE PREPARE s1;



END