<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of EventYearComboHelper
 *
 * @author assure
 */
class Zend_View_Helper_EventYearComboHelper extends Zend_View_Helper_Abstract
{
    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function eventYearComboHelper()
    {
        $str  = '<table id="years">';
        $str .= '<tr id="year-row">';

        foreach($this->view->years as $year) :
            $str .= '<td><a href="';
            $str .= $this->view->url(array(
                'controller'=>'event',
                'action'=>'list',
                'year'=>$year->year));
            $str .= '">'.$year->year.'</a></td>';
        endforeach;


        $hardcodedyears = array(2008,2007,2006,2005,2004,2003,2002,2001,2000);
        foreach($hardcodedyears as $year) :
            $str .= '<td><a href="';
            $str .= $this->view->url(array(
                'controller'=>'event',
                'action'=>'list',
                'year'=>$year));
            $str .= '">'.$year.'</a></td>';
        endforeach;

        $str .= '</tr>';
        $str .= '</table>';
        return $str;
    }
}
?>
