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
class Zend_View_Helper_EventsTableHelper extends Zend_View_Helper_Abstract
{
    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    /**
     * http://schema.org/Event
     * @return string
     */
    public function eventsTableHelper()
    {
        $str  = '<div>';
        $str .= '<table class="tablesorter">';
        $str .= '<thead>';
        $str .= '<tr> ';
        $str .= '<th>Name</th>';
        $str .= '<th>Location</th>';
        $str .= '<th>Number</th>';
        $str .= '<th>Type</th>';
        $str .= '<th>Start</th>';
        $str .= '</tr>';
        $str .= '</thead>';
        $str .= '<tbody>';

        foreach($this->view->events as $event) :
            $str .= '<tr itemscope itemtype="http://schema.org/Event">';
            $str .= '<td>';
            $str .= '<a itemprop="url" href="';
            $str .= $this->view->url(array(
                'controller'=>'event',
                'action'=>'index',
                'tag'=>$event->tag));
            $str .= '"><span itemprop="name">'.$event->name.'</span></a></td>';
            $str .= '<td itemprop="location" itemscope itemtype="http://schema.org/Place"><span itemprop="name">'.$event->location.'</span></td>';
            $str .= '<td>'.$event->count.'</td>';
            $str .= '<td>'.$event->type.'</td>';
            $str .= '<td itemprop="startDate" content="'.date('Y-m-d',strtotime($event->date)).'">'.date('l jS M Y',strtotime($event->date)).'</td>';
            $str .= '</tr>';
        endforeach;
        $str .= '</tbody>';
        $str .= '</table>';
        $str .= '</div>';
        return $str;
    }
}
?>