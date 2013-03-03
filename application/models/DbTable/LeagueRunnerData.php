<?php
class Model_DbTable_LeagueRunnerData extends Zend_Db_Table_Abstract
{
	protected $_name = 'leaguerunnerdata';
	protected $_primary = 'Id';

	public function leagueTable($min,$max)
	{
		$sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('l'=>'leaguerunnerdata'))
    		->join(array('r'=>'runner'),'l.runner = r.id',array('id','firstname','surname'))
    		->where('l.league = ?',1)
    		->where('r.standard > ?',$min)
    		->where('r.standard < ?',$max)
    		->order('l.pointsTotal DESC');
        return $this->fetchAll($sql);
	}

    /**
     * select r.id,r.firstname,r.surname, c.name, pointsTotal
        from leaguerunnerdata lrd
        join runner r on lrd.runner= r.id
        left join company c on r.company=c.id
        join division d on lrd.standard between d.min and d.max and d.type='I'
        where r.gender='W' and d.code='L2' and lrd.league=6
        order by pointsTotal desc limit 5;
     */
    public function getLeagueLeadersSQL($division,$limit)
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
    		->from(array('lrd'=>'leaguerunnerdata'),array('pointsTotal'))
    		->join(array('r'=>'runner'),'lrd.runner = r.id',array('runner'=>'id','firstname','surname'))
            ->joinLeft(array('c'=>'company'),'r.company=c.id',array('name'))
            ->join(array('d'=>'division'),'lrd.standard between d.min and d.max and d.type="I"',array('code','min','max','gender'))
            ->where('lrd.league = ?',6)
    		->where('r.gender = ?',$division->gender)
    		->where('d.code = ?',$division->code)
    		->order('lrd.pointsTotal DESC')
            ->limit($limit);
        //echo $sql;
        return $sql;
    }

    public function getLeagueLeaders($division,$limit)
    {
        return $this->fetchAll($this->getLeagueLeadersSQL($division,$limi));
    }
    
    public function getLeagueSummary($divisions,$limit)
	{
        $sql = $this->select()
            ->union(array(
                $this->getLeagueLeadersSQL($divisions[0],5),
                $this->getLeagueLeadersSQL($divisions[1],5),
                $this->getLeagueLeadersSQL($divisions[2],5)));
        return $this->fetchAll($sql);
	}
}
?>