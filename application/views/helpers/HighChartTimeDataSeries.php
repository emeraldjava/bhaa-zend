<?php
/**
 * Helper class to generate a HighChart data set from a rowset object
 * @author assure
 */
class Zend_View_Helper_HighChartTimeDataSeries
{
    public function highChartTimeDataSeries($rowset,$field,$standardfield)
    {
        $str = "[";
        $size = count($rowset);

		for ($i=0;$i<$size;$i++)
		{
            $std = $rowset[$i][$standardfield];
            $time = $rowset[$i][$field];
            if(!empty($time) && ($time != "00:00:00") )
            {
                if(!empty ($std))
                {
                   list($hh,$mm,$ss)= explode(':',$time);
                   if($std!="42.2")
                       $str = $str . "[".( ($hh*60*60*1000)+($mm*60*1000)+($ss*1000)).",".$std."]";
                }
                else
                {
                    $str = $str . " null ";
                }
            }
            elseif($time == "00:00:00")
            {
                $str = $str . " null ";
            }
            else
            {
                $str = $str . " null ";
            }

            if($i!=($size-1))
				$str = $str.",";
		}
  		$str = $str . "]";
  		return $str;
     }
}
?>
