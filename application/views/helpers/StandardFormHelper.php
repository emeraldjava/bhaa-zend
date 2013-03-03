<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of StandardFormHelper
 *
 * @author assure
 */
class Zend_View_Helper_StandardFormHelper extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
        $this->view = $view;
    }

    public function standardFormHelper($runner,$race)
    {
        $output = '<form name="setstandard" action="';
        $output .= $this->view->url(
            array('controller'=>'standards','action'=>'setstandard'),null,true);
        $output .= '" method="POST">';
        $output .= '<select name="standard">';
        $output .= '<option value="1">1</option>';
        $output .= '<option value="2">2</option>';
        $output .= '<option value="3">3</option>';
        $output .= '<option value="4">4</option>';
        $output .= '<option value="5">5</option>';
        $output .= '<option value="6">6</option>';
        $output .= '<option value="7">7</option>';
        $output .= '<option value="8">8</option>';
        $output .= '<option value="9">9</option>';
        $output .= '<option value="10">10</option>';
        $output .= '<option value="11">11</option>';
        $output .= '<option value="12">12</option>';
        $output .= '<option value="13">13</option>';
        $output .= '<option value="14">14</option>';
        $output .= '<option value="15">15</option>';
        $output .= '<option value="16">16</option>';
        $output .= '<option value="17">17</option>';
        $output .= '<option value="18">18</option>';
        $output .= '<option value="19">19</option>';
        $output .= '<option value="20">20</option>';
        $output .= '<option value="21">21</option>';
        $output .= '<option value="22">22</option>';
        $output .= '<option value="23">23</option>';
        $output .= '<option value="24">24</option>';
        $output .= '<option value="25">25</option>';
        $output .= '<option value="26">26</option>';
        $output .= '<option value="27">27</option>';
        $output .= '<option value="28">28</option>';
        $output .= '<option value="29">29</option>';
        $output .= '<option value="30">30</option>';
        $output .= '</select>';
        $output .= '<input type="hidden" name="runner" value="'.$runner.'"/>';
        $output .= '<input type="hidden" name="race" value="'.$race.'"/>';
        $output .= '<input type="submit" value="Std"/>';
        $output .= '</form>';
        return $output;
    }
}
?>