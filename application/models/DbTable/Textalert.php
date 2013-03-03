<?php
class Model_DbTable_Textalert extends Zend_Db_Table_Abstract
{
	protected $_name = 'textalert';
	protected $_primary = 'account';
	
	public function getMobileAccount($id)
    {
    	return $this->find($id)->current();
    }
    
    /**
     * select runner.id,runner.firstname,runner.surname,runner.mobilephone,textalert.startdate,textalert.enddate
from textalert 
join runner on textalert.membership = runner.id
join mobileaccount on textalert.account = mobileaccount.id
where textalert.enddate is null and runner.textmessage='Y' and textalert.account=24
order by mobileaccount.id, runner,surname;
     * @param unknown_type $account
     */
	public function getMobilesLinkedToPhone($account)
    {
    	$sql = $this->select()
	    	->setIntegrityCheck(false)
			->from(
				array('textalert'=>'textalert'),
				array('runner'=>'runner.id',
				'firstname'=>'runner.firstname',
				'surname'=>'runner.surname',
				'mobile'=>'runner.mobilephone',
				'startdate'=>'textalert.startdate',
				'enddate'=>'textalert.enddate')
				)
			->join('runner','textalert.runner = runner.id',null)
			->join('mobileaccount','textalert.account = mobileaccount.id',null)
			->where(sprintf("textalert.enddate is null and runner.textmessage='Y' and textalert.account='%s'",$account))
			->order('runner.surname');
		$logger = Zend_Registry::get('logger');
        $logger->info($sql);
        return $this->fetchAll($sql);
    }
    
    /**
     * select runner.firstname,runner.surname, runner.mobilephone, mobileaccount.name
from textalert 
join runner on textalert.membership = runner.id
join mobileaccount on textalert.account = mobileaccount.id
where textalert.enddate is null and runner.textmessage='Y'
order by mobileaccount.id, runner,surname;
     */
    public function exportTextAlertDetails($mobileaccount)
    {
        $sql = $this->select()
	        ->setIntegrityCheck(false)
            ->from(array('textalert'=>'textalert'),array(
				'First Name'=>'runner.firstname',
            	'Last Name'=>'runner.surname', 
            	'Private Mobilephone 1'=>'runner.mobilephone',
            	'Company'=>'mobileaccount.username'))
			->join('runner','textalert.runner = runner.id',null)	  
            ->join('mobileaccount','textalert.account = mobileaccount.id',null)      
			->where('textalert.enddate is null AND runner.textmessage="Y"');
		if($mobileaccount!=0)
		{
			$sql->where('textalert.account = ?',$mobileaccount);		
		}
		$sql->order('mobileaccount.id')
			->order('runner.surname');
        $logger = Zend_Registry::get('logger');
        $logger->info($sql);
        return $this->fetchAll($sql);
    }
    
    public function disableTextAlert($runner)
    {
    	$date = Zend_Date::now();
    	$data = array( 'enddate' => $date->toString("YYYY-MM-dd"));
        $this->update($data,'textalert.runner = '.$runner);
    }    
}
?>