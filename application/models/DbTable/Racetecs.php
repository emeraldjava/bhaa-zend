<?php
class Model_DbTable_Racetecs extends Zend_Db_Table_Abstract
{
	protected $_name = 'racetec';
	protected $_primary = 'id';
	
	public function get($id)
    {
    	return $this->find($id)->current();
    }
}
?>