<?php
class Model_DbTable_Renewal extends Zend_Db_Table_Abstract
{
	protected $_name = 'renewal';
	protected $_primary = 'code';
	
	public function getRenewal($id)
    {
    	return $this->find($id)->current();
    }
}
?>