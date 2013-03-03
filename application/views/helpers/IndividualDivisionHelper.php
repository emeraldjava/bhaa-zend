<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of IndividualDivisionHelper
 *
 * @author assure
 */
class Zend_View_Helper_IndividualDivisionHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function individualDivisionHelper($divisions,$leaguesummary,$leagueid)
    {
        $str .= '<div id="league'.$leagueid.'" class="league-container" align="left">';
        $str .= '<div class="yui-gb">';
        $str .= '<div class="yui-u first">';
        $str .= $this->view->divisionHelper("A",$divisions[0],$leaguesummary,$leagueid);
        $str .= '</div>';
        $str .= '<div class="yui-u">';
        $str .= $this->view->divisionHelper("B",$divisions[1],$leaguesummary,$leagueid);
        $str .= '</div>';
        $str .= '<div class="yui-g">';
        $str .= $this->view->divisionHelper("L1",$divisions[6],$leaguesummary,$leagueid);
        $str .= '</div>';
        $str .= '</div>';
        $str .= '<div class="yui-gb">';
        $str .= '<div class="yui-u first">';
        $str .= $this->view->divisionHelper("C",$divisions[2],$leaguesummary,$leagueid);
        $str .= '</div>';
        $str .= '<div class="yui-u">';
        $str .= $this->view->divisionHelper("D",$divisions[3],$leaguesummary,$leagueid);
        $str .= '</div>';
        $str .= '<div class="yui-g">';
        $str .= $this->view->divisionHelper("L2",$divisions[7],$leaguesummary,$leagueid);
        $str .= '</div>';
        $str .= '</div>';
        $str .= '<div class="yui-gb">';
        $str .= '<div class="yui-u first">';
        $str .= $this->view->divisionHelper("E",$divisions[4],$leaguesummary,$leagueid);
        $str .= '</div>';
        $str .= '<div class="yui-u">';
        $str .= $this->view->divisionHelper("F",$divisions[5],$leaguesummary,$leagueid);
        $str .= '</div>';
        $str .= '<div class="yui-g">';
        $str .= '<div></div>';
        $str .= '</div></div></div>';
        return $str;
    }
}
?>
