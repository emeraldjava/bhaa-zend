<?php
/**
 * Description of Zend_View_Helper_RaceResultTable
 * @author assure
 */
class Zend_View_Helper_PreregisteredResultTable extends Zend_View_Helper_Abstract {
    //put your code here

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function preregisteredResultTable()
    {
        $output = '<div id="preregistered" align="left" event='.$this->event->tag.'>';
        $output .= '<table class="tablesorter">';
        $output .=  '<thead>';
        $output .=  '<tr>';
        $output .=  '<th>No</th>';
        $output .=  '<th>Name</th>';
        $output .=  '<th>Company</th>';
        $output .=  '</tr>';
        $output .=  '</thead>';
        $output .=  '<tbody>';

        $i = 1;
        foreach($this->view->preregistered as $result) :

        $output .=  '<tr>';
        $output .=  '<td>'.($i++).'</td>';
        $output .=  '<td>';
            if($result->status=='M')
            {
                $output .=  '<a href="';
                $output .=  $this->view->url(array(
                    'controller' => 'runner',
                    'action' => 'index',
                    'id' => $result->runner
                    ));
                $output .=  '">'.$result->firstname.' '.$result->surname.'</a>';
            }
            else
            {
                $output .=  $this->view->escape($result->firstname) . ' '. $this->view->escape($result->surname);
            }
        $output .=  '</td>';
        $output .=  '<td>'.($result->name).'</td>';

        endforeach;

        $output .=  '</tbody>';
        $output .=  '</table>';
        $output .=  '</div>';
        return $output;
    }
}
?>