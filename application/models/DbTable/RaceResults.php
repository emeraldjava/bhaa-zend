<?php
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of DayMembers
 *
 * @author assure
 */
class Model_DbTable_RaceResults extends Zend_Db_Table_Abstract
{
    protected $_name = 'raceresult';
    protected $_primary = array('race', 'runner');
    //protected $_rowClass = 'Model_DbTable_RaceResult';

    //$model = new Model_DbTable_RaceResults();
    //$res = $model->fetchAll();
    //Zend_Debug::dump($res,"",true);
}
?>
