<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
class Zend_View_Helper_MissingStandardTable extends Zend_View_Helper_Abstract {
    //put your code here

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function missingStandardTable()
    {
        // id   | firstname   | surname     | paceKM   | racetime | race
        $output = "<!-- missingStandardTable -->";
        $output .= '<div id="volunteers">';
        $output .= '<table id="missingstandards" class="xtablesorter">';
        $output .= '<thead>';
        $output .= '<tr>';
        $output .= '<th>Name</th>';
        $output .= '<th>ID</th>';
        $output .= '<th>Race</th>';
        $output .= '<th>Pace</th>';
        $output .= '<th>Time</th>';
        $output .= '</tr>';
        $output .= '</thead>';
        $output .= '<tbody>';

        foreach($this->view->missingStandards as $result) :
            $output .= '<tr>';
            $output .= '<td>'.($result->firstname)." ".($result->surname).'</td>';
            $output .= '<td>'.($result->id).'</td>';
            $output .= '<td>'.($result->race).'</td>';
            $output .= '<td>'.($result->paceKM).'</td>';
            $output .= '<td>'.($result->racetime).'</td>';
            $output .= '</tr>';
        endforeach;
        $output .= '</tbody>';
        $output .= '</table>';
        return $output;
    }
}
?>
