<?php
/**
 * Description of Zend_View_Helper_RaceResultTable
 * @author assure
 */
class Zend_View_Helper_TeamResultTable extends Zend_View_Helper_Abstract {
    //put your code here

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function teamResultTable()
    {
        $output = '<!-- team results -->';
        $output .= '<div id="teams">';
        $output .= '<table id="eventteamresults" class="tablesorter">';
        $output .= '<thead>';
        $output .= '<tr>';
        $output .= '<th>Name</th>';
        $output .= '<th>Points Total</th>';
        $output .= '<th>First</th>';
        $output .= '<th>Second</th>';
        $output .= '<th>Third</th>';
        $output .= '<th>Standard Total</th>';
        $output .= '<th>Class</th>';
        $output .= '</tr>';
        $output .= '</thead>';
        $output .= '<tbody>';
        
        foreach($this->view->teamresults as $result) :

        $output .= '<tr>';
        $output .= '<td><a href="';
        $output .= $this->view->url(array(
                'controller' => 'houses',
                'action' => 'team',
                'id' => $result->team));
        $output .= '">'.$this->view->escape($result->name).'</a></td>';
        $output .= '<td>'.($result->positiontotal).'</td>';
        $output .= '<td><a href="';
        $output .= $this->view->url(array(
            'controller' => 'runner',
            'action' => 'index',
            'id' => $result->runnerfirst));
        $output .= '">'.$this->view->escape($result->r1sn).'</a></td>';
        $output .= '<td><a href="';
                $output .= $this->view->url(array(
            'controller' => 'runner',
            'action' => 'index',
            'id' => $result->runnersecond));
        $output .= '">'.$this->view->escape($result->r2sn).'</a></td>';
        $output .= '<td><a href="';
                $output .= $this->view->url(array(
            'controller' => 'runner',
            'action' => 'index',
            'id' => $result->runnerthird));
        $output .= '">'.$this->view->escape($result->r3sn).'</a></td>';
        $output .= '<td>'.$result->standardtotal.'</td>';
        $output .= '<td>'.$result->class.'</td>';
        $output .= '</tr>';
        endforeach;
        $output .= '</tbody>';
        $output .= '</table>';
        $output .= '</div>';
        return $output;
    }
}
?>