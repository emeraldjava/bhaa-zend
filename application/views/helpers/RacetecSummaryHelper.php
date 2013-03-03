<?php
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
class Zend_View_Helper_RacetecSummaryHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function racetecSummaryHelper()
    {// position	id	firstname	surname	dateofbirth
        $output = '<div id="summary">';
        $output .= '<table id="racetecsummary" class="tablesorter">';
        $output .= '<thead>';
        $output .= '<tr>';
        $output .= '<th>Race Number</th>';
        $output .= '<th>Name</th>';
        $output .= '<th>Type</th>';
        $output .= '<th>ID</th>';
        $output .= '</tr>';
        $output .= '</thead>';
        $output .= '<tbody>';

        foreach($this->view->racetec as $runner) :
                
        $output .= '<tr><td>'.$runner->racenumber.'</td>';
        $output .= '<td>'.$runner->firstname.' '.$runner->surname.'</td>';
        $output .= '<td>'.$runner->type.'</td>';
        $output .= '<td>'.$runner->runner.'</td></tr>';
        

        endforeach;
        $output .= '</tbody>';
        $output .= '</table>';
        $output .= '</div>';
        return $output;
    }
}
?>