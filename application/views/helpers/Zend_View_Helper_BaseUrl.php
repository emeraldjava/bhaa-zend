<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Zend_View_Helper_BaseUrl
 *
 * @author assure
 */
class Zend_View_Helper_BaseUrl {

//    function baseUrl()
//    {
//        $base_url = substr($_SERVER['PHP_SELF'], 0, -9);
//        return $base_url;
//    }
    protected $_baseUrl;

    function __construct()
    {
        $fc = Zend_Controller_Front::getInstance();
        $this->_baseUrl =  $fc->getBaseUrl();
    }

    function baseUrl()
    {
        return $this->_baseUrl;
    }

}
?>
