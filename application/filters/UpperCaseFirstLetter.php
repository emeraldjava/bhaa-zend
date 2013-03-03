<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

require_once 'Zend/Filter/Interface.php';

/**
 * Description of StripSlashes
 *
 * @author assure
 */
class Filter_UpperCaseFirstLetter implements Zend_Filter_Interface {
    
    public function filter($value)
    {
    	$filtered = strtoupper(substr($value,0,1)).strtolower(substr($value,1));
    	//$logger = Zend_Registry::get('logger');
    	//$logger->info($value.'-->'.$filtered);
    	return $filtered;
    }
}
?>