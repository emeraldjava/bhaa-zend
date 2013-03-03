<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of DivisionTeamHelperHelper
 *
 * @author assure
 */
class Zend_View_Helper_TeamDivisionHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function teamDivisionHelper($divisions,$leaguesummary,$leagueid)
    {
        $str = '<div id="league'.$leagueid.'" class="league-container" align="left">';
        $str .= '<div class="yui-g">';
        $str .= '<div class="yui-u first">';
        $str .= $this->view->divisionHelper("M",$divisions[8],$leaguesummary,$leagueid,'team');
        $str .= '</div>';
        $str .= '<div class="yui-u">';
        $str .= $this->view->divisionHelper("W",$divisions[12],$leaguesummary,$leagueid,'team');
        $str .= '</div>';
        $str .= '</div>';
        $str .= '</div>';
        return $str;
    }
}
?>