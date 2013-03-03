<?php
/**
 * Description of Preregistered
 *
 * @author assure
 */
class Model_DbTable_Preregistered extends Zend_Db_Table_Abstract
{
    protected $_name = 'preregistered';
    protected $_primary = array('event', 'runner');
}
?>