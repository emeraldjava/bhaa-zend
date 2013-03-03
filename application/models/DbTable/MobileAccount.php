<?php
class Model_DbTable_MobileAccount extends Zend_Db_Table_Abstract
{
	protected $_name = 'mobileaccount';
	protected $_primary = 'id';
	
	public function getMobileAccount($id)
    {
    	return $this->find($id)->current();
    }

    /**
     * select mobileaccount.*,  count(runner.id) as runnercount, 
     * (select count(mobile) from textalert where textalert.account=mobileaccount.id) AS `simplecount` 
     * from textalert  join runner on textalert.membership = runner.id 
     * join mobileaccount on textalert.account = mobileaccount.id 
     * where textalert.enddate is null 
     * and runner.textmessage='Y' 
     * group by mobileaccount.name, mobileaccount.number order by mobileaccount.id;
     * Enter description here ...
     */
    public function getAllMobileAccounts()
    {
        $sql = $this->select()
	        ->setIntegrityCheck(false)
            ->from(array('mobileaccount'=>'mobileaccount'))
            ->columns(array(
			    'count'=>new Zend_Db_Expr('count(runner.id)'),
	            'simplecount'=>new Zend_Db_Expr('(select count(runner) from textalert where textalert.account=mobileaccount.id)')))
			->join('textalert','textalert.account = mobileaccount.id',null)
            ->join('runner','textalert.runner = runner.id',null)	        
			->where('textalert.enddate is null AND runner.textmessage="Y"')
			->group('mobileaccount.name')
			->group('mobileaccount.number')
			->order('mobileaccount.id');
        $logger = Zend_Registry::get('logger');
        $logger->info($sql);
        return $this->fetchAll($sql);
    }
    
	public function getMobileAccountByName($name)
    {
    	$sql = $this->select()
			->from(array('mobileaccount'=>'mobileaccount'))
			->where(sprintf("name = '%s'",$name));
		$logger = Zend_Registry::get('logger');
        $logger->info($sql);
    	return $this->fetchAll($sql)->current();
    }
}
?>