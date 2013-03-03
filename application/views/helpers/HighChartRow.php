<?php
/**
 * Helper class to generate a HighChart data set from a rowset object
 * @author assure
 */
class Zend_View_Helper_HighChartRow
{
    public function highChartRow($rowset,$standard)
    {
        $str = "[";
        $size = count($rowset);
		for ($i=0;$i<$size;$i++)
		{
            $std = $rowset[$i]['total'];
            $str .= $std;
            
			if($i!=($size-1))
				$str .= " ,";
		}
  		$str .= "]";
  		return $str;
     }
}
?>
