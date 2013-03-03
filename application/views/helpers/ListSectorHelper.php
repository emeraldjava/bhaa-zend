<?php 
class Zend_View_Helper_ListSectorHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }
    
    public function listSectorHelper()
    {

		$output = '<table id="sectors" class="tablesorter">';
		$output .= '<thead>'; 
		$output .= '<tr>'; 
		$output .= '<th>Sector</th>';
		$output .= '<th>Sector Description</th>';
		$output .= '<th>Number of Companies</th>';
		$output .= '<th>Number of Runners</th>';
		$output .= '</tr>'; 
		$output .= '</thead>';
		$output .= '<tbody>'; 
		
		foreach($this->view->sectors as $sector) :	

		$output .= '<tr>';
		$output .= '<td><a href="';
		$output .= $this->view->url(
				array('controller'=>'houses',
					'action'=>'sector',
					'id'=>$sector->id
				),null,true);
		$output .= '">'.($sector->name).'</a></td>';
		$output .= '<td>'.($sector->description).'</td>';
		$output .= '<td>'.($sector->companies).'</td>';
		$output .= '<td>'.($sector->runners).'</td>';
		
		endforeach;
		$output .= '</tbody>';
		$output .= '</table>';
		return $output;
    }
}
?>