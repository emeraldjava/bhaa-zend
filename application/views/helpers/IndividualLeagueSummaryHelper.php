<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of IndividualLeagueSummaryTable
 *
 * @author paul
 */
class Zend_View_Helper_IndividualLeagueSummaryHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    //'id' => int 4629
    //'firstname' => string 'Bill' (length=4)
    //'surname' => string 'Quinn' (length=5)
    //'companyid' => int 97
    //'companyname' => string 'ESB' (length=3)
    //'leagueid' => int 6
    //'leaguetype' => string 'I' (length=1)
    //'leagueparticipantid' => int 4629
    //'leaguestandard' => int 25
    //'leaguedivision' => string 'F' (length=1)
    //'leagueposition' => int 10
    //'previousleagueposition' => null
    //'leaguescorecount' => int 1
    //'leaguepoints' => float 19.8
    public function individualLeagueSummaryHelper(Zend_Db_Table_Rowset_Abstract $rowset,$displayCompany=true) {

        $str  = '<div>';
        $str .= '<table class="tablesorter">';
        $str .= '<thead>';
        $str .= '<tr> ';
        $str .= '<th>Name</th>';
        if($displayCompany)
            $str .= '<th>Company</th>';
        //$str .= '<th>Standard</th>';
        $str .= '<th>Division</th>';
        $str .= '<th>Position</th>';
        $str .= '<th>Races</th>';
        $str .= '<th>Points</th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';

        foreach($rowset as $row) :
            $str .= '<tr>';
            $str .= '<td><a href="';
            $str .= $this->view->url(array(
                'controller'=>'runner',
                'action'=>'index',
                'id'=>$row->id),null,true);
            $str .= '">'.$row->firstname.' '.$row->surname. '</a></td>';
            if($displayCompany)
            {
                $str .= '<td><a href="';
                $str .= $this->view->url(array(
                    'controller'=>'houses',
                    'action'=>'company',
                    'id'=>$row->companyid),null,true);
                $str .= '">'.$row->companyname.'</a></td>';
            }
            $str .= '<td><a href="';
            $str .= $this->view->url(array(
                'controller'=>'league',
                'action'=>'individual',
                'league'=>$row->leagueid,
                'divisioncode'=>$row->leaguedivision),null,true);
            $str .= '">'.$row->leaguedivision.'</a></td>';
            $str .= '<td>'.$row->leagueposition.'</td>';
            $str .= '<td>'.$row->leaguescorecount.'</td>';
            $str .= '<td>'.$row->leaguepoints.'</td>';
            $str .= '</tr>';
        endforeach;
        $str .= '</tbody>';
        $str .= '</table>';
        $str .= '</div>';

        return $str;
    }
}
?>