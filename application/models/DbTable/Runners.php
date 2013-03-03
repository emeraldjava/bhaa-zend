<?php
class Model_DbTable_Runners extends Zend_Db_Table_Abstract
{
	protected $_name = 'runner';
	protected $_primary = 'id';
	protected $_rowClass = 'RunnerRow'; // <== THIS IS REALLY HELPFUL
	
	var $logger;
	
	public function init()
	{
		$this->logger = Zend_Registry::get('logger');
	}

	public function getRunner($runner)
	{
		return $this->find($runner)->current();
	}
}
?>