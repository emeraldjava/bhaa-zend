<?php 
class Zend_View_Helper_ListCompanyHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function listCompanyHelper()
    {
		$output = '<div id="companies">';
		$output = $this->view->letter;
		if(!isset($this->view->letter))
			$output .= '<ol id="selectable">';
		else
			$output .= '<ol>';
			
		foreach($this->view->companies as $company) : 
			
			if(!isset($this->view->letter))
			{
				$output .= '<li class="ui-state-default">';
				$output .= '<a href="';
				$output .= $this->view->url(
						array('controller'=>'houses',
							'action'=>'list',
							'type'=>'company',
							'letter'=>$company->letter
						),null,true);
				$output .= '">'.$company->letter.'</a>';
    		}
    		else
    		{
				$output .= '<li>';
				$output .= '<a href="';
				$output .= $this->view->url(
						array('controller'=>'houses',
							'action'=>'company',
							'id'=>$company->id
						),null,true);
				$output .= '">'.$company->name.'</a>';
    		}
			$output .= '</li>';
		endforeach;
		$output .= '</ol>';
		$output .= '</div>';
		return $output;
    }
}
?>