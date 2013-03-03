<?php
class Model_DbTable_Registration extends Zend_Db_Table_Abstract
{
	protected $_name = 'daymembership';
	protected $_primary = 'id';
	
	public function listRegisteredRunnersByEvent($event)
	{
		$sql = $this->select()
			->from(array('registration'=>'registration'))
			->where("event = ?",$event);
		//echo sprintf("sql %s",$sql);
		return $this->fetchAll($sql);
	}
}
?>