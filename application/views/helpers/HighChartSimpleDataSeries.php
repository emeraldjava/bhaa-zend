<?php
/**
 * Helper class to generate a HighChart data set from a rowset object
 * @author assure
 */
class Zend_View_Helper_HighChartSimpleDataSeries
{
    public function highChartSimpleDataSeries($rowset,$field)
    {
        $str = "[";
        $size = count($rowset);

		for ($i=0;$i<$size;$i++)
		{
            if($field=='paceKM'||$field=='racetime'||$field=='normalisedPaceKm')
			{
                $time = $rowset[$i][$field];
                if(!empty($time) && ($time != "00:00:00") )
				{
					list($hh,$mm,$ss)= explode(':',$time);
					$str = $str . ( ($hh*60*60*1000)+($mm*60*1000)+($ss*1000));
				}
                else
                {
                    $str = $str . " null ";
                }
			}
            elseif(is_string($rowset[$i][$field]))
			{
				$str = $str . "'".$rowset[$i][$field]."'";
			}
			else
			{
				$str = $str . $rowset[$i][$field];
			}

			if($i!=($size-1))
				$str = $str.",";
		}
  		$str = $str . "]";
        //echo sprintf("%s : %s",$field, $str);
        return $str;
     }
}