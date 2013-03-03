<?php
class Model_DbTable_Runireland extends Zend_Db_Table_Abstract
{
	protected $_name = 'runireland';
	protected $_primary = 'sid';
	
	public function getRunner($runner)
	{
		return $this->find($runner)->current();
	}
	
    public function export($event)
	{
		$sql = $this->select()
			->setIntegrityCheck(false)
			->from(array('runireland'=>'runireland'),
				array('sid',
					'firstname as name',
					'surname',
					'gender',
					'bhaatag as std', 
					'date_format(dateofbirth,\'%d/%m/%Y\') as dateofbirth',
					sprintf('(select getAgeCategory(runireland.dateofbirth,"%s",(CASE gender WHEN "m" THEN "M" ELSE "W" END),1)) as cat',$event->date),
					'company as companyname')
					)
            ->where(sprintf("runireland.SKU='%s'",$event->tag))
			->order(array('surname asc','firstname asc'));
        //$logger = Zend_Registry::get('logger');
        //$logger->info($sql);
		return $this->fetchAll($sql);
	}
}
?>