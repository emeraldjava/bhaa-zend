<?php
class Model_DbTable_Event extends Zend_Db_Table_Abstract
{
	protected $_name = 'event';
	protected $_primary = 'id';
	
	public function getEvent($id)
    {
    	return $this->find($id)->current();
    }
    
	public function getEventByTag($tag)
    {
    	$sql = $this->select()
			->from(array('event'=>'event'),
                array('*','if (date >= now(),"Y","N") as future',
                "(select id from race where race.event=event.id and race.type IN ('C','W') limit 1) as womensrace",
                "(select id from race where race.event=event.id and race.type IN ('C','M') limit 1) as mensrace"))
			->where(sprintf("tag = '%s'",$tag));
    	return $this->fetchAll($sql)->current();
    }

	public function getDistinctYears()
	{
		$sql = $this->select()
			->from(
				array('event'=>'event'),
				array('DISTINCT(YEAR(date)) as year'))
			->order("year desc");
		return $this->fetchAll($sql);
	}
	
	public function getPastEvents($limit=0)
	{
		$stmt = $this->select()
			->from(
				array('event'=>'event'),
				array('ev'=>'id','name','tag','location','date','type',
					'YEAR(date) as year',
					'(select count(runner) from raceresult as rr join race r on r.id=rr.race where r.event=event.id) as count'))
			->where("date <= ?", new Zend_Db_Expr('now()'))
			->order("date desc");
        if($limit!=0)
            $stmt->limit($limit);
		return $this->fetchAll($stmt);
	}
	
	public function getEventsByYear($year)
	{
		$sql = $this->select()
			->from(
				array('event'=>'event'),
				array('id','name','tag','location','date','type',
                    '(select count(runner) from raceresult as rr join race r on r.id=rr.race where r.event=event.id) as count',
                    'YEAR(date) as year'))
            ->where(sprintf("YEAR(date) = %s",$year))
			->order("date asc");
		return $this->fetchAll($sql);
	}
	
	// the next three events
	//select * from event where date > CURDATE() LIMIT 1;
	public function getUpcomingEvents($limit)
	{
		$sql = $this->select()->from(array('event'=>'event'))
			->where("date > ?", new Zend_Db_Expr('now()'))
            ->order('date asc')
			->limit($limit);
		return $this->fetchAll($sql);
	}
	
	// the most recent event
	//select * from event where date < CURDATE() order by date desc limit 1
    //select id,name,tag,
    //(select id from race where race.event=event.id and race.type IN ('C','W') limit 1) as womensrace,
    //(select id from race where race.event=event.id and race.type IN ('C','M') limit 1) as mensrace
    //from event where event.id=X;
	public function getMostRecentEvent()
	{
		$sql = $this->select()
            ->from(array('event'=>'event'),array('*',
                "(select id from race where race.event=event.id and race.type IN ('C','W') limit 1) as womensrace",
                "(select id from race where race.event=event.id and race.type IN ('C','M') limit 1) as mensrace"))
			->where("DATE(date) <= ?", new Zend_Db_Expr('DATE(now())'))
			->order("date desc")
			->limit(1);
		//$logger = Zend_Registry::get('logger');
		//$logger->info($sql);
		$rowset = $this->fetchAll($sql);
		return $rowset->current();
	}

    public function getNextEvent()
	{
		$sql = $this->select()->from(array('event'=>'event'))
			->where("DATE(date) >= ?", new Zend_Db_Expr('DATE(now())'))
			->order("date asc")
			->limit(1);
		//$logger = Zend_Registry::get('logger');
		//$logger->info($sql);
		$rowset = $this->fetchAll($sql);
		return $rowset->current();
	}
	
	// returns the list of races within an event for a division - ie the womens races.
	public function getRacesByType($event,$type)
	{
		$sql = $this->select()
			->setIntegrityCheck(false)
			->from(array('event'=>'event'),array('name'))
			->join(array('race'=>'race'),'race.event = event.id',array('id','type','category'))
			->where('event.id = ?',$event)
			->where('race.type in (\'C\',?)',$type);
		//echo sprintf("racesbytype: %s<br/>",$sql);
		return $this->fetchAll($sql);
	}	
	
	//	select e.id, e.name, 
	//	(select count(runner) from raceresult as rr join race r on r.id=rr.race where r.event=e.id) as count
	//	from event as e;
	public function getRunnersPerEvent()
	{
		$sql = $this->select()
			->setIntegrityCheck(false)
			->from(array('event'=>'event'),
				array(
					'id',
					'name',
					'(select count(runner) from raceresult as rr join race r on r.id=rr.race where r.event=event.id) as count'
			))
			->where("date < ?", new Zend_Db_Expr('now()'))
			->order("date asc");
		return $this->fetchAll($sql);
	}

    function getEventSumPoints($event,$type)
    {
        $sql = $this->select()
			->setIntegrityCheck(false)
			->from(array('event'=>'event'),array('name'))
			->join(array('race'=>'race'),'race.event = event.id',array('id','type','category'))
			->where('event.id = ?',$event->id)
			->where('race.type in (\'C\',?)',$type);
		$races = $this->fetchAll($sql);

  		$sum_sql = '';
        if( count($races)!=0)
        {
            $sum_sql = $sum_sql . 'SUM(CASE rr.race ';
            foreach($races as $race)
            {
                $sum_sql = $sum_sql . sprintf('WHEN %d',$race->id) . ' THEN rr.points ';
            }
            $sum_sql = $sum_sql . sprintf("ELSE NULL END) as %s,",$event->tag);
        }
        return $sum_sql;
    }
}
?>