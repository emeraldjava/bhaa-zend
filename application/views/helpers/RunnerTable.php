<?php
/**
 * Description of Zend_View_Helper_RaceResultTable
 * @author assure
 */
class Zend_View_Helper_RunnerTable extends Zend_View_Helper_Abstract {
    //put your code here

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function runnerTable()
    {
        $output =  '<!-- race results -->';
        $output .= '<div id="'.$race.'">';
        $output .= '<table id="raceresults" class="tablesorter">';
        $output .= '<thead>';
        $output .= '<tr>';
        $output .= '<th>ID</th>';
        $output .= '<th>Name</th>';
        $output .= '<th>Statue</th>';
        $output .= '</tr>';
        $output .= '</thead>';
        $output .= '<tbody>';

        foreach($this->view->runners as $runner) :

        $output .= '<tr>';
        $output .= '<td>';
        $output .= '<a target="_blank" href="';
        $output .= $this->view->url(array(
            'controller' => 'runner',
            'action' => 'index',
            'id' => $runner->id),null,null);
        $output .= '">'.$runner->id.'</a></td>';
        $output .= '<td>'.$runner->firstname.' '.$runner->surname.'</td>';
        $output .= '<td>'.$runner->status.'</td>';

        endforeach;
        $output .= '</tbody>';
        $output .= '</table>';
        $output .= '</div>';
        return $output;
    }
}
?>