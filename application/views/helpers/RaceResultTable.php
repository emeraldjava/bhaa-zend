<?php
/**
 * Description of Zend_View_Helper_RaceResultTable
 * @author assure
 */
class Zend_View_Helper_RaceResultTable extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function raceResultTable($race)
    {
        $output =  '<!-- race results -->';
        $output .= '<div id="race'.$race.'">';
        $output .= '<table id="raceresults" class="tablesorter">';
        $output .= '<thead>';
        $output .= '<tr>';
        $output .= '<th>Position</th>';
        $output .= '<th>Name</th>';
        $output .= '<th>Number</th>';
        $output .= '<th>Time</th>';
        $output .= '<th>Pace KM</th>';
        $output .= '<th>Category</th>';
        $output .= '<th>Standard</th>';
        $output .= '<th>Company</th>';

       	if($this->view->user)
       	{
       		$output .= '<th>Runner</th>';
       		$output .= '<th>Result</th>';
       	}
        
        $output .= '</tr>';
        $output .= '</thead>';
        $output .= '<tbody>';

        $staggeredrace = false;
        foreach($this->view->results as $result) :

        if($result->race==$race)
        {
	        $output .= '<tr>';
	        $output .= '<td>'.$result->position.'</td>';
	        $output .= '<td>';
	        if($result->status=="M")
	        {
	            $output .= '<a href="';
	            $output .= $this->view->url(array(
	                'controller' => 'runner',
	                'action' => 'index',
	                'id' => $result->runner
	                ),null,true);
	            $output .= '">'.$result->firstname.' '.$this->view->escape($result->surname).'</a></td>';
	        }
	        else
	        {
	            $output .= $result->firstname.' '.$this->view->escape($result->surname).'</td><!-- '.$result->runner.' -->';
	        }
	
	        if(!empty($result->racepixs))
	        {
		        $output .= '<td>';
		        //$output .= '<a href="http://www.racepix.com/org/bhaa/race/';
		        //$output .= ($result->racepixs);
		        //$output .= '/bib/';
		        //$output .= ($result->racenumber);
		        //$output .= '/images.aspx" target="new">';
		        $output .= $result->racenumber;
		        //$output .= '</a>';
		        $output .= '</td>';
	        }
	        else
	        {
		        $output .= '<td>'.$result->racenumber.'</td>';
	        }
	
	        $output .= '<td>'.($result->racetime);
	        //if(is_int($result->staggeredrace))
	        //{
	        //    $staggeredrace = true;
	        //    $output .= ' <i>CT['.($result->clocktime).']</i>';
	        //}
	        if($result->showStd=="true")
	            $output .= ' ['.$result->std.']';
	        $output .= '</td>';
	            
	        $output .= '<td>'.($result->paceKM).'</td>';
	        $output .= '<td>'.($result->category).'</td>';
	        
	        $preracestadard = $result->standard;
	        if(empty($preracestadard))
	            $preracestadard = "NA";
	
	        if($result->showStd=="true")
	            $output .= '<td>'.$preracestadard.' => '.$result->postRaceStandard.' </td>';
	        else
	            $output .= '<td>'.$preracestadard.'</td>';
	
	            if($result->company!=0)
	            {
	                $output .= '<td>';
	                $output .= '<a href="';
	                $output .= $this->view->url(array(
	                    'controller' => 'houses',
	                    'action' => 'company',
	                    'id' => $result->company
	                    ),null,true);
	                $output .= '">'.$this->view->escape($result->companyname).'</a></td>';
	            }
	            else
	            {
	                $output .= '<td>'.$this->view->escape($result->companyname).'</td>';
	            }

	            if($this->view->user)
	            {
	            	$output .= '<td><a target="new" href="';
	            	$output .= $this->view->url(array(
	            		                'controller' => 'runner',
	            		                'action' => 'edit',
	            		                'id' => $result->runner
	            	),null,true);
	            	$output .= '">Edit '.$result->runner.'</a></td>';
	            	$output .= '<td><a target="new" href="';
	            	$output .= $this->view->url(array(
      		                'controller' => 'event',
       		                'action' => 'editresult',
			            	'race' => $race,
        	                'runner' => $result->runner
	            	),null,true);
	            	$output .= '">Edit Result</a></td>';
	            }
        	}
	        $output .= '</tr>';
	        endforeach;
        $output .= '</tbody>';
        $output .= '</table>';

        if($staggeredrace)//is_int($result->staggeredrace))
            $output .= ' <div align="left"><p>CT represents the clocked time from the race. This is the time plus the staggered start delay.</p></div>';

        $output .= '</div>';
        return $output;
    }
}
?>