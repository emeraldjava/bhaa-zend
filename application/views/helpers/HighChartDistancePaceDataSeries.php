<?php
/**
 * Helper class to generate a HighChart data set from a rowset object
 * @author assure
 */
class Zend_View_Helper_HighChartDistancePaceDataSeries extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function highChartDistancePaceDataSeries($rowset,$field='pace')
    {
        $str = "[";
        $size = count($rowset);

		for ($i=0;$i<$size;$i++)
		{
            $distance=$rowset[$i]['distance'];
            $unit=$rowset[$i]['unit'];

            if($unit=="Mile")
                $distance=$distance*1.6;

            $timeField = $rowset[$i][$field];
            //echo sprintf("%d %s &s",$distance,$unit,$timeField);
            if(!empty($timeField) && ($timeField != "00:00:00") )
            {
                if(!empty ($distance))
                {
                   list($hh,$mm,$ss)= explode(':',$timeField);
                    $str .= "[".( ($hh*60*60*1000)+($mm*60*1000)+($ss*1000)).",".$distance."]";
                }
                else
                {
                    $str .= "[0,".$distance."]";
                //    $str .= " null ";
                }
            }
//            elseif($timeField == "00:00:00")
//            {
//                $str .= " null ";
//            }
//            else
//            {}

            if($i!=($size-1))
				$str .= ",";
		}
  		$str .= "]";
  		return $str;
     }
}
?>
