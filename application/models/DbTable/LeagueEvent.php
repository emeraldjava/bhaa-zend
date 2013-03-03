<?php
class Model_DbTable_LeagueEvent extends Zend_Db_Table_Abstract
{
	protected $_name = 'leagueevent';
	
	public function getEventsByLeague($league)
	{
		$stmt = $this->select()
			->setIntegrityCheck(false)
			->from(array('leagueevent'=>'leagueevent'))
			->join(array('event'=>'event'),'event.id = leagueevent.event',array('id','name','tag'))
			->where('leagueevent.league = ?',$league)
			->order('leagueevent.event ASC');
		return $this->fetchAll($stmt);
	}

    /**
        select leagueevent.league,event.tag,race.id,race.type from leagueevent
        join event on event.id=leagueevent.event
        join race on race.event=event.id
        where league=5
        and race.type in ('C','M');
     */
    public function getLeagueTagsAndRaces($league,$gender)
	{
		$select = $this->select()
			->setIntegrityCheck(false)
			->from(array('leagueevent'=>'leagueevent'),
                array('(CASE leagueevent.summaryrace WHEN 0 THEN race.id ELSE leagueevent.summaryrace END) as raceid'))
            ->join(array('event'=>'event'),'event.id = leagueevent.event',array('tag'))
            ->join(array('race'=>'race'),'event.id = race.event',array())
            ->where('leagueevent.league = ?',$league)
			->where("race.type in ('C','S',?)",$gender)
            ->group('raceid')
            ->order('event.date ASC');
        return $this->fetchAll($select);
	}
}
?>