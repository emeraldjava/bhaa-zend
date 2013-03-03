-- http://rpbouman.blogspot.com/2008/07/calculating-nth-percentile-in-mysql.html
DROP FUNCTION IF EXISTS `getTeamStandardQuartile` $$
CREATE FUNCTION `getTeamStandardQuartile`(_quartile INT(11), _race INT(11)) RETURNS int(11)
BEGIN
	
DECLARE _result INT(11);

SET _result = (SELECT  SUBSTRING_INDEX(
          SUBSTRING_INDEX(
            GROUP_CONCAT(                        
              standardtotal                             
              ORDER BY standardtotal
              SEPARATOR ','
            )
          , ','                                 
          , _quartile/4 * COUNT(*) + 1           
          )
        , ','                                   
        , -1                                     
        )
FROM    teamraceresult
WHERE   standardtotal IS NOT NULL and race=_race); 

RETURN _result;
END