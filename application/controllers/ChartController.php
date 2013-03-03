<?php
class ChartController extends Zend_Controller_Action
{
    function init()
    {
        $this->initView();
        $this->view->baseUrl = $this->_request->getBaseUrl();
        $this->view->user = Zend_Auth::getInstance()->getIdentity();
    }
    
    public function indexAction()
    {
    	$event = new Model_DbTable_Event();
		$events = $event->getRunnersPerEvent();
		//echo sprintf("%s<br/>",$this->getValueString($events,'name'));
		//echo sprintf("%s<br/>",$this->getValueString($events,'count'));
				
		$this->view->eventNames = $this->getValueString($events,'name');
		$this->view->runnersPerEvent = $this->getValueString($events,'count');
    	
    }
    
    // builds a flot data array
    function getValueString($events,$field)
    {
  		$str = "[";
		$size = count($events);
		for ($i=0;$i<count($events);$i++)
		{
			//			$str = $str . "[" . $i.':' . $events[$i]['id'] .','.$events[$i][$field]."]";
			//			$str = $str . "[" . $event['id'] .','.$event[$field]."]";
			
			if(is_string($events[$i][$field]))
			{
				$str = $str . "[".$i.",'".$events[$i][$field]."']";
			}
			else
			{
				$str = $str . "[".$i.",".$events[$i][$field]."]";
			}
			if($i!=($size-1))
				$str = $str.",";
		}
  		$str = $str . "]";
  		return $str;
    }
}
?>