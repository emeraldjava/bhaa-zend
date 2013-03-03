<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of YearEventIFrameHelper
 *
 * @author assure
 */
class Zend_View_Helper_EventsIFrameHelper extends Zend_View_Helper_Abstract
{
    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function eventsIFrameHelper($year)
    {
        $str = '<div id="'.$year.'">';
        $str .= '<iframe src="http://bhaa.ie/documents/'.$year.'/results.html" width="100%" height="800"></iframe>';
        $str .= '</div>';
        return $str;
    }
}
?>