<?php
class Model_DbTable_Team extends Zend_Db_Table_Abstract
{
	protected $_name = 'team';
	protected $_primary = 'id';

	public function getTeam($id)
    {
    	$sql = $this->select()
	    	->setIntegrityCheck(false)
			->from(array('team'=>'team'))
			->joinleft(array('runner'=>'runner'),'runner.id=team.contact',array('firstname','surname'))
			->where(sprintf("team.id = %d",$id));
		return $this->fetchAll($sql)->current();
    }
    
	public function searchForTeamsByName($teamname)
	{
		$sql = $this->select()
			->from(array('team'=>'team'),array('id','name'))
			->where("name like ?",'%'.$teamname.'%');
		return $this->fetchAll($sql);
	}
	
	public function getTeamsByStatus($status)
	{
		$sql = $this->select()
			->setIntegrityCheck(false)
			->from(array('team'=>'team'),array('id','name','status','contact','type',
                "runners"=>'(select count(runner) from teammember where teammember.team=team.id and teammember.leavedate IS NULL)'))
            ->joinLeft(array('runner'=>'runner'),'runner.id = team.contact',array('firstname','surname'))
			->where("team.status = ?",$status)
            ->order("type asc")
			->order("name asc");
		return $this->fetchAll($sql);
	}
	
	public function searchForSectorTeams($sector)
	{
		$sql = $this->select()
			->from(array('team'=>'team'),array('id','name','type','parent'))
			->where(sprintf("type=\"S\" and parent = %d",$sector));
		return $this->fetchAll($sql);
	}
	
	public function searchForCompanySectorTeams($sector)
	{
		$sql = $this->select()
			->setIntegrityCheck(false)
			->from(array('team'=>'team'),array('id','name','type','parent'))
			->join(array('company'=>'company'),'team.parent=company.id',array('sector'))
			->where("type=\"C\"")
			->where(sprintf("company.sector = %d",$sector));
		return $this->fetchAll($sql);
	}
	
	//	select * from team 
	//	left join company on team.parent=company.id
	//	where (parent=$sector OR company.sector=$sector);
	public function getTeamsBySector($sector)
	{
		$sql = $this->select()
			->setIntegrityCheck(false)
			->from(array('team'=>'team'),array('id','name','type',
				'(select count(runner) from teammember where teammember.team=team.id) as members'))
			->joinleft(array('company'=>'company'),'team.parent=company.id',array('sector'))
            ->where(sprintf("(status='ACTIVE' AND parent=%d)",$sector));
		return $this->fetchAll($sql);
	}
}
?>