<?php
/*
 * Matching Runners Helper
 */
class Zend_View_Helper_MatchingRunnersHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }
    
    /**
     * +----------+-----------+-------+------------+------------------+----------+--------+-------------+------+------------+------------+----------+--------+-------------+
     | position | relevance | id    | firstname  | surname          | standard | status | dateofbirth | id   | firstname  | surname    | standard | status | dateofbirth |
     +----------+-----------+-------+------------+------------------+----------+--------+-------------+------+------------+------------+----------+--------+-------------+
     */
    public function matchingRunnersHelper()
    {
    	$output .= '<div id="matchingrunners">';
    	$output .= '<div><p>'.
    	'Relevance Type'.
    	'a - match of three key fields (name,surname and dob)'.
		'b - match of name/surname'.
		'c - match of surname/dob'.
    	'</p></div>';
    	$output .= '<div id="container">';
    	$output .= '<table id="datatable" class="display">';
        $output .= '<thead>';
        $output .= '<tr>';
        $output .= '<th>Position</th>';
        $output .= '<th>Relevance</th>';
        $output .= '<th>Day ID</th>';
        $output .= '<th>Surname</th>';
        $output .= '<th>Name</th>';
        $output .= '<th>DOB</th>';
        
        $output .= '<th>Member ID</th>';
        $output .= '<th>Surname</th>';
        $output .= '<th>Name</th>';
        $output .= '<th>DOB</th>';
        
        $output .= '</tr>';
        $output .= '</thead>';
        $output .= '<tbody>';

        foreach($this->view->matchingRunners as $result) :
        	$output .= '<tr>';
            $output .= '<td>'.($result['position']).'</td>';
            $output .= '<td>'.($result['relevance']).'</td>';
            $output .= '<td>'.($result['id']).'</td>';
            $output .= '<td>'.($result['surname']).'</td>';
            $output .= '<td>'.($result['firstname']).'</td>';
            $output .= '<td>'.($result['dateofbirth']).'</td>';
            $output .= '<td>'.($result['rid']).'</td>';
            $output .= '<td>'.($result['rsurname']).'</td>';
            $output .= '<td>'.($result['rfirstname']).'</td>';
            $output .= '<td>'.($result['rdateofbirth']).'</td>';
            $output .= '</tr>';
        endforeach;
        $output .= '</tbody>';
        $output .= '</table>';
       	$output .= '</div>';
        //$output .= '<script type="text/javascript">$("#matchingrunners").tablesorter({sortList: [[1,0]]});</script>';
        return $output;
    }
}
?>