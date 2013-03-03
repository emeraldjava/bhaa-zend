<?php
class Model_DbTable_Race extends Zend_Db_Table_Abstract
{
	protected $_name = 'race';
	protected $_primary = 'id';

	public function getRace($id)
    {
    	return $this->find($id)->current();
    }

    public function getRaceDetails($race)
    {
        $sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('race'=>'race'))
    		->join(array('event'=>'event'),'race.event = event.id',array('name','tag','date'))
    		->where('race.id = ?',$race);
        return $this->fetchRow($sql);
    }
    
	public function getEventRaces($event)
	{
        $select = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('race'=>'race'))
            ->columns('(select count(raceresult.runner) from raceresult where race.id = raceresult.race) as number')
    		->join(array('event'=>'event'),'race.event = event.id',array('name','tag','date'))
            ->where('race.type != "S"')
    		->where('race.event = ?',$event)
            ->order('race.id asc');
        return $this->fetchAll($select);
	}
	
	//select race.id, race.event, race.distance, race.file, 
	//(select name from event where event.id=race.event) as name,
	//(select count(rr.runner) from raceresult rr where race.id = rr.race) as number
	//from race as race;
	public function getAdminRaceDetails($limit=10)
	{
		$sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('race'=>'race'))
            ->columns('(select count(raceresult.runner) from raceresult where race.id = raceresult.race) as number')
            ->join(array('event'=>'event'),'race.event = event.id',array('name','tag','date'))
            ->where('race.type != "S"')
            ->order('event.date desc')
            ->limit($limit);
        return $this->fetchAll($sql);
	}
}
?>