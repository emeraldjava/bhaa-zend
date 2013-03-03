<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
class Zend_View_Helper_DivisionHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function divisionHelper($code,$division,$leaguesummary,$leagueid,$action='individual')
    {
        $name = 'divisioncode';
        $value = $division->code;
        if($action=="team")
        {
            $name = 'gender';
            $value = $division->gender;
        }
        $output = '<div class="division">';
        $output .= '<div class="title">';
        $output .= '<h3><a href="';
        $output .= $this->view->url(
            array('controller'=>'league',
                'action'=>$action,
                'league'=>$leagueid,
                $name=>$value),null,true);
        $output .= '">'.$division->name.'</a></h3>';
        $output .= '<div class="standard">Standards '.$division->min.' to '.$division->max.'</div>';
        $output .= '</div>';

        $i = 0;
        foreach($leaguesummary as $summary) :
            if($summary->leaguedivision==$code && $summary->leagueid==$leagueid)
            {
                $i++;
                $output .= '<div>'.$i.':'.$summary->name.' '.$summary->leaguepoints.'/'.$summary->leaguescorecount.'</div>';
            }
        endforeach;

        $output .= "</div>";
        return $output;
    }
}
?>
