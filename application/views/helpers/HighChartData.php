<?php
/**
 * Helper class to generate a HighChart data set from a rowset object
 * @author assure
 */
class Zend_View_Helper_HighChartData
{
    public function highChartData($rowset,$standard)
    {
        $str = "[";
        $size = count($rowset);

		for ($i=0;$i<$size;$i++)
		{
            $std = $rowset[$i]['standard'];
            if($standard==$std)
			{
                $time = $rowset[$i]['normalisedPaceKm'];
                if(!empty($time) && ($time != "00:00:00") )
				{
					list($hh,$mm,$ss)= split(':',$time);
					$str = $str . "[".( ($hh*60*60*1000)+($mm*60*1000)+($ss*1000)).",".$std."]";
				}
                else
                {
                    $str = $str . " null ";
                }
			}
            elseif($standard==-1)
            {
                $time = $rowset[$i]['normalisedPaceKm'];
                if(!empty($time) && ($time != "00:00:00") )
				{
                    if(empty ($std))
                        $std=0;
                    
					list($hh,$mm,$ss)= split(':',$time);
					$str = $str . "[".( ($hh*60*60*1000)+($mm*60*1000)+($ss*1000)).",".$std."]";
				}
            }
            else
            {
                $str = $str . " null ";
            }
			if($i!=($size-1))
				$str = $str." ,";
		}
  		$str = $str . "]";
  		return $str;
     }
}
?>
