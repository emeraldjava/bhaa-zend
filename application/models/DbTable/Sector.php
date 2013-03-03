<?php
class Model_DbTable_Sector extends Zend_Db_Table_Abstract
{
	protected $_name = 'sector';
	protected $_primary = 'id';
	
	public function getSector($id)
    {
    	return $this->find($id)->current();
    }
    
	public function listSectors()
	{
		$sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('sector'=>'sector'),array(
    			'id',
    			'name',
    			'description',
    			'(select count(company.id) from company where company.sector = sector.id) as companies',
    			'(select count(runner.id) from runner as runner join company as company on runner.company=company.id where company.sector=sector.id and runner.status="M") as runners'))
    		->where("valid='Y'")
            ->where("id!=48")
    		->order("name asc");
        return $this->fetchAll($sql);
	}
	
	public function searchSectorsByName($sector)
	{
		$sql = $this->select()
			->from(array('sector'=>'sector'),array('id','name'))
			->where("valid='Y' and name like ?",'%'.$sector.'%');
		return $this->fetchAll($sql);
	}

    /**
     * select distinct s.id as s_id,s.name as s_name,c.id as c_id,c.name as c_name
        from sector s
        join company c on c.sector=s.id
        join runner r on r.company=c.id
        where r.status="M" and s.id= 1
        order by RAND()
        limit 1;
     */
    public function getRandomCompanyPerSector($sector)
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
			->from(array('sector'=>'sector'),array('sectorid'=>'id'))
            ->join(array('company'=>'company'),'company.sector=sector.id',array('companyid'=>'id','companyname'=>'name'))
            ->join(array('runner'=>'runner'),'runner.company=company.id',array())
            ->where('runner.status="M"')
            ->where('sector.id=?',$sector)
            ->order("RAND()")
            ->limit(1);
        //echo $sql;
        return $sql;
    }

    public function selectRandomCompanies($limit)
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
			->from(array('sector'=>'sector'),array('sectorid'=>'id'))
            ->join(array('company'=>'company'),'company.sector=sector.id',array('id'=>'id','name'=>'name'))
            ->join(array('runner'=>'runner'),'runner.company=company.id',array())
            ->where('runner.status="M"')
            ->where('sector.id!=48')
            ->order("RAND()")
            ->distinct("company.id")
            ->limit($limit);
        //echo $sql;
        //return $sql;
        return $this->fetchAll($sql);

    }
}
?>