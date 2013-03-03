<?php
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
class Zend_View_Helper_DayMemberHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function dayMemberHelper()
    {// position	id	firstname	surname	dateofbirth
        $output = '<div id="daymembers">';
        $output .= '<table id="raceresults" class="tablesorter">';
        $output .= '<thead>';
        $output .= '<tr>';
        $output .= '<th>Position</th>';
        $output .= '<th>Name</th>';
        $output .= '<th>DOB</th>';
        $output .= '<th>Race Number</th>';
        $output .= '</tr>';
        $output .= '</thead>';
        $output .= '<tbody>';

        foreach($this->view->daymembers as $daymember) :
                
            $output .= '<tr><td>'.$daymember->position.'</td>';
            $output .= '<td><a href="';
            $output .= $this->view->url(array(
                'controller' => 'runner',
                'action' => 'index',
                'id' => $daymember->id
                ),null,true);
            $output .= '">'.$daymember->surname.' '.$daymember->firstname.' '.$daymember->id.'</a></td>';
            $output .= '<td>'.$daymember->dateofbirth.'</td>';
            $output .= '<td><a target="new" href="';
            $output .= $this->view->url(array(
                'controller' => 'runner',
                'action' => 'transferdetails',
                'id' => $daymember->id,
                'race' => $daymember->race
                ),null,true);
            $output .= '">'.$daymember->racenumber.' : Create New Member</a></td></tr>';

        endforeach;
        $output .= '</tbody>';
        $output .= '</table>';
        $output .= '</div>';
        return $output;
    }
}
?>