<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
class Zend_View_Helper_DivisionTeamHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function divisionTeamHelper($message,$gender,$rowset)
    {
        $output = '<div class="division">';
        $output .= '<div class="title">';
        $output .= '<h3><a href="';
        $output .= $this->view->url(
            array('controller'=>'league',
                'action'=>'team',
                'league'=>5,
                'gender'=>$gender),null,true);
        $output .= '">Team League Summary</a></h3>';
        $output .= '<div class="standard">Gender '.$message.'</div>';
        $output .= '</div>';

        $i = 0;
        foreach($rowset as $row) :
            $i++;
            $output .= '<div>'.$i.':'.$row->name.' '.$row->leaguedivision.'  '.$row->leaguepoints.'</div>';
        endforeach;

        $output .= "</div>";
        echo $output;
    }
}
?>
