<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of TeamLeagueHelper
 *
 * @author paul
 */
class Zend_View_Helper_TeamLeagueSummaryHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

//    type	id	name	comid	compname
//    leagueid	leaguetype	leagueparticipantid
//    leaguestandard	leaguedivision	leagueposition
//    previousleagueposition	leaguescorecount	leaguepoints
    public function teamLeagueSummaryHelper(Zend_Db_Table_Rowset_Abstract $rowset) {

        $str  = '<div>';
        $str .= '<table class="tablesorter">';
        $str .= '<thead>';
        $str .= '<tr> ';
        $str .= '<th>Name</th>';
        $str .= '<th>Standard</th>';
        $str .= '<th>Division</th>';
        $str .= '<th>Position</th>';
        $str .= '<th>Races</th>';
        $str .= '<th>Points</th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';

        foreach($rowset as $row) :
            $action = "company";
            if($row->type=="S")
                $action = "team";
            $str .= '<tr>';
            $str .= '<td>';
            $str .= '<a href="';
            $str .= $this->view->url(array(
                'controller'=>'houses',
                'action'=>$action,
                'id'=>$row->id),null,true);
            $str .= '">'.$row->name.'</a></td>';
            $str .= '<td>'.$row->leaguestandard.'</td>';
            $str .= '<td>'.$row->leaguedivision.'</td>';
            $str .= '<td>'.$row->leagueposition.'</td>';
            $str .= '<td>'.$row->leaguescorecount.'</td>';
            $str .= '<td>'.$row->leaguepoints.'</td>';
        endforeach;
        $str .= '</tbody>';
        $str .= '</table>';
        $str .= '</div>';

        return $str;
    }
}
?>