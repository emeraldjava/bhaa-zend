<?php
class Model_DbTable_League extends Zend_Db_Table_Abstract
{
	protected $_name = 'league';
	protected $_primary = 'id';
	protected $_dependentTables = array('Model_DbTable_LeagueSummary');

	public function getLeague($id)
    {
    	return $this->find($id)->current();
    }
    
	public function getLeagues()
	{
		$sql = $this->select()->from(array('league'=>'league'))
			->order("startdate desc");
		return $this->fetchAll($sql);
	}

    public function getCurrentLeague($type="T")
    {
   		$sql = $this->select()->from(array('league'=>'league'))
            ->where('league.type = ?',$type)
            ->order("league.startdate desc")
            ->limit(1);
        return $this->fetchAll($sql)->current();
    }

    public function getDistinctYears()
	{
		$sql = $this->select()
			->from(
				array('league'=>'league'),
				array('DISTINCT(YEAR(startdate)) as year'))
			->order("startdate desc");
		return $this->fetchAll($sql);
	}

    public function getLeaguesByYear($year)
	{
		$sql = $this->select()
			->from(array('league'=>'league'),array('year'=>'YEAR(startdate)','type','id','name'))
            ->where(sprintf("YEAR(startdate) = %s",$year))
            ->orWhere(sprintf("YEAR(enddate) = %s",$year))
			->order("id desc");
		return $this->fetchAll($sql);
	}
}
?>