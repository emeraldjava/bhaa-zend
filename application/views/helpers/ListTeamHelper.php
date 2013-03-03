<?php 
class Zend_View_Helper_ListTeamHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }
    
    public function listTeamHelper()
    {
		$output .= '<table class="tablesorter">';
		$output .= '<thead><tr>';
		$output .= '<th>Name</th>';
		$output .= '<th>Type</th>';
		$output .= '<th>Number of Runners</th>';
		$output .= '<th>Contact</th>';
		$output .= '</tr>';
		$output .= '</thead>';
		$output .= '<tbody>';
		
		foreach($this->view->teams as $team) :
		
			$output .= '<tr>';
			$output .= '<td>';
			$output .= '<a href="';
			$output .= $this->view->url(
					array('controller'=>'team',
						'action'=>'index',
						'id'=>$team->id
					));
			$output .= '">'.$team->name.'</a>';
			$output .= '</td>';
			$output .= '<td>'.$team->type.'</td>';
			$output .= '<td>'.$team->runners.'</td>';
			$output .= '<td>'.$team->firstname.' '.$team->surname.'</td>';
			$output .= '</tr>';
		endforeach;
		
		$output .= '</table>';
		return $output;
    }
}
?>