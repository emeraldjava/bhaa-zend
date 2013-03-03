<?php
/**
 * Description of Zend_View_Helper_RaceResultTable
 * @author assure
 */
class Zend_View_Helper_VolunteersTable extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function volunteersTable()
    {
        $output = '<!-- volunteers results -->';
        $output .= '<div id="volunteerstab">';
        $output .= '<table id="volunteers" class="tablesorter">';
        $output .= '<thead>';
        $output .= '<tr>';
        $output .= '<th>Name</th>';
        $output .= '<th>Company</th>';
        $output .= '</tr>';
        $output .= '</thead>';
        $output .= '<tbody>';
        foreach($this->view->volunteers as $result) :
        $output .= '<tr>';
        $output .= '<td>'.($result->firstname).' '.($result->surname).'</td>';
        $output .= '<td>'.($result->name).'</td>';
        $output .= '</tr>';
        endforeach;
        $output .= '</tbody>';
        $output .= '</table>';
        $output .= '</div>';
        return $output;
    }
}
?>