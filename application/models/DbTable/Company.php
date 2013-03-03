<?php
class Model_DbTable_Company extends Zend_Db_Table_Abstract
{
	protected $_name = 'company';
	protected $_primary = 'id';
	
	public function getCompany($id)
    {
    	return $this->find($id)->current();
    }
    
	public function getCompaniesBySector($sector)
	{
		$sql = $this->select()
    		//->setIntegrityCheck(false)
    		->from(array('company'=>'company'),
    			array(
    				'id',
    				'name',
    				'(select count(runner.id) from runner where runner.company = company.id and runner.status="M") as runners'))
    		->where('company.sector = ?',$sector);
        return $this->fetchAll($sql);
	}
	
	// SELECT DISTINCT UPPER(LEFT(name, 1)) FROM company ORDER BY name
	public function listCompaniesByFirstLetter()
	{
		$sql = $this->select()
			->distinct("LEFT(name,1)")
    		->from(array('company'=>'company'),array('LEFT(name,1) as letter'))
   			->order('name');
   			//echo $sql;
    	//echo sprintf("%s",$sql);
        return $this->fetchAll($sql);
	}
	
	public function findCompaniesByFirstLetter($letter)
	{
		$sql = $this->select()
    		->from(array('company'=>'company'))//,array('id','name','LEFT(name,1) as letter'))
    		->columns('LEFT(name,1) as letter')
    		->where("name like ?",$letter.'%')
   			->order('name');
        //echo $sql;
        return $this->fetchAll($sql);
	}
	
	public function searchForCompaniesByName($name)
	{
		$sql = $this->select()
			->from(array('company'=>'company'),array('id','name'))
			->where("name like ?",'%'.$name.'%');
		return $this->fetchAll($sql);
	}
	
	public function getRandomCompanyLogos($num)
	{
		$sql = $this->select()
			->from(array('company'=>'company'),array('id','name','image'))
			->where("image IS NOT NULL AND image != ''")
			->order('RAND()')
			->limit($num);
		return $this->fetchAll($sql);
	}

    public function getNewCompanyId()
    {
        $sql = $this->select()
			->from(array('company'=>'company'),array('nextcompanyid'=>'(max(id)+1)'));
        //echo $sql;
        return $this->fetchRow($sql);
    }
}
?>