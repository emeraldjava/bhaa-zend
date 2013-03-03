<?php
class Model_Racetec
{	
	protected $form = null;
	protected $dbTable = null;
	
	/**
	 * Link the Form
	 * http://mwop.net/blog/200-Using-Zend_Form-in-Your-Models
	 */
	public function getForm()
	{
		if(!isset($this->form))
		{
			$this->form = new Form_RacetecForm();
		}
		return $this->form;
	}
	
	/**
	 * Link the DB Table
	 * http://www.dragonbe.com/2010/01/zend-framework-data-models.html
	 */
	public function getDbTable()
	{
		if (null === $dbTable) {
			$dbTable = new Model_DbTable_Racetecs();
		}
		return $dbTable;
	}
	
	public function save(array $data)
	{	
		$logger = Zend_Registry::get('logger');
		$logger->info('SAVE '.print_r($data,true));
		//$logger->info(var_dump(array_values($data)));
		
		if(empty($data['dateofrenewal']))
		{
			$data['dateofrenewal'] = Zend_Date::now()->toString('YYYY-MM-dd');
		}
		
		$storage = $this->getDbTable();
		$id = $storage->insert($data);
		$logger->info("added racetec row ".$id);
		//}
		return $id;
	}
	
	public function find($id)
	{
		$result = $this->getDbTable()->find($id);
		if (0 == count($result)) {
			return;
		}
		return $result->current();
	}
	
	public function fetchAll()
	{
		return $this->getDbTable()->fetchAll($this->getDbTable()->select()->order('last_modified desc'));
	}
	
 	public function getEventCount()
 	{
 		$query = $this->getDbTable()->select()->from(
 			array('racetec'),array('event'=>'event','count'=>new Zend_Db_Expr('count(event)')))->group('event');
 		return $this->getDbTable()->fetchAll($query);
 	}
 	
 	public function getSummary()
 	{
 		$query = $this->getDbTable()->select()->from(
 				array('racetec'),
 				array(
 					'total'=>new Zend_Db_Expr('count(id)'),
 					'members'=>new Zend_Db_Expr('(select count(id) from racetec where type="member")'),
					'renewals'=>new Zend_Db_Expr('(select count(id) from racetec where type="renewal")'),
					'nonrenewals'=>new Zend_Db_Expr('(select count(id) from racetec where type="nonrenewal")'),
					'day'=>new Zend_Db_Expr('(select count(id) from racetec where type="day")')
 					)
 				);
 		//echo $query;
 		return $this->getDbTable()->fetchAll($query);
 	}
	
	public function fetchTop()
	{
		return $this->getDbTable()->fetchAll(
			$this->getDbTable()->select()->order('last_modified desc')->limit(15, 0)
		);
	}
}
?>