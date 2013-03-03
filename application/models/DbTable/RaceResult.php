<?php
class Model_DbTable_RaceResult extends Zend_Db_Table_Abstract
{
    protected $_name = 'raceresult';
    protected $_primary = array('race', 'runner');
	
    public function raceResultExists($race,$runner)
    {
    	return $this->find($race,$runner)->current();
    }

    public function getRaceResultByEventNumber($event,$racenumber)
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('raceresult'=>'raceresult'))
            ->join(array('race'=>'race'),'race.id = raceresult.race')
    		->join(array('event'=>'event'),'race.event = event.id')
            ->where('event.id = ?',$event)
            ->where('raceresult.racenumber = ?',$racenumber);
        return $this->fetchRow($sql);
    }
    
    /**
     * Return the list of races with results for an event.
     * @param $event
     * @return unknown_type
     */
	public function getRaceResultsForEvent($event)
	{
		$sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('raceresult'=>'raceresult'),array('race'))
    		->join(array('race'=>'race'),'race.id = raceresult.race','category')
    		->join(array('event'=>'event'),'race.event = event.id',array('name'))
    		->distinct()
    		->where('event.id = ?',$event);
    	return $this->fetchAll($sql);
	}

	public function getRaceResults($race)
	{
		$sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('raceresult'=>'raceresult'))
    		->join(array('race'=>'race'),'race.id = raceresult.race',
                array('distance','unit',
                    'std'=>'(select getStandard(raceresult.racetime,race.distancekm))',
                    'if (event.date >= "2010-10-07","true","false") as showStd'))
    		->join(array('event'=>'event'),'race.event = event.id',array('racepixs'))
    		->join(array('runner'=>'runner'),'runner.id = raceresult.runner',array('id','firstname','surname','status'))
			->joinleft(array('company'=>'company'),'raceresult.company = company.id',array('id','name'))
            ->joinleft(array('staggeredhandicap'=>'staggeredhandicap'),'raceresult.race = staggeredhandicap.race',
				array('staggeredrace'=>'staggeredhandicap.race','clocktime'=>''))
              //  array('staggeredrace'=>'staggeredhandicap.race','clocktime'=>"(select getClockTime(staggeredhandicap.race,raceresult.runner))"))
            ->where('raceresult.class in ("RAN","RAN_NO_SCORE")')
    		->where('raceresult.race = ?',$race)
    		->where('runner.status!="D"')
            ->order('raceresult.position ASC');
        return $this->fetchAll($sql);
	}

//     public function getRacePreRegistered($event)
// 	{
// 		$sql = $this->select()
//     		->setIntegrityCheck(false)
//     		->from(array('preregistered'=>'preregistered'),array('event'))
//     		->join(array('runner'=>'runner'),'runner.id = preregistered.runner',array(
//                 'runner'=>'id','firstname','surname','gender','standard','dateofbirth'=>'dateofbirth',
//                 sprintf('(select getAgeCategory(runner.dateofbirth,"%s",runner.gender,1)) as cat',$event->date),'email','status'))
// 			->joinleft(array('company'=>'company'),'runner.company = company.id',array('name','id'))
//     		->where('preregistered.event = ?',$event->id)
//             ->order('runner.surname ASC');
//         //echo $sql;
//         return $this->fetchAll($sql);
// 	}

    public function getEventResults($event)
	{
        $select = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('raceresult'=>'raceresult'))
            ->join(array('race'=>'race'),'race.id = raceresult.race',
                array('distance','unit',
                    'std'=>'(select getStandard(raceresult.racetime,race.distancekm))',
                    'if (event.date >= "2010-10-07","true","false") as showStd'))
            ->join(array('event'=>'event'),'race.event = event.id',array('racepixs','tag'))
            ->join(array('runner'=>'runner'),'runner.id = raceresult.runner',array('id','firstname','surname','status'))
            ->joinleft(array('company'=>'company'),'raceresult.company = company.id',array('id','name'))
            ->joinleft(array('staggeredhandicap'=>'staggeredhandicap'),'raceresult.race = staggeredhandicap.race',
			        array('staggeredrace'=>'staggeredhandicap.race','clocktime'=>''))
			        //array('staggeredrace'=>'staggeredhandicap.race','clocktime'=>'(select getClockTime(staggeredhandicap.race,raceresult.runner))'))
	        ->joinLeft(
		        array('teammember'=>'teammember'),
	   	                    'teammember.runner = runner.id AND teammember.leavedate IS NULL',
		        array('(select id from team where team.id=teammember.team and team.status="ACTIVE") as teamid',
		        '(select name from team where team.id=teammember.team and team.status="ACTIVE") as teamname'))
            ->where('raceresult.class in ("RAN","RAN_NO_SCORE")')
            ->where('race.event = ?',$event)
            ->order('raceresult.position ASC');
        return $result = $this->fetchAll($select);
    }
    
    public function getRacetecExport($event)
    {
    	$select = $this->select()
	    	->setIntegrityCheck(false)
	    	->from(array('raceresult'=>'raceresult'),
	    		array(
		    		'raceresult.position',
		    		'raceresult.racenumber',
		    		'runner.id',
		    		'raceresult.racetime',
		    		'runner.surname',
		    		'runner.firstname',
		    		'runner.gender',
		    		'runner.dateofbirth',
		    		'raceresult.standard',
		    		'raceresult.category',
    				'(select name from team where team.id=teammember.team and team.status="ACTIVE") as teamname',
    				'(select id from team where team.id=teammember.team and team.status="ACTIVE") as teamid',
    	    		'company.name as companyname',
    				'company.id as companyid',
    				'(CONCAT(event.tag,"_",race.distance,race.unit)) as event',
    				'raceresult.race',
    				'runner.email',
    				'runner.newsletter',
    				'runner.mobilephone',
    				'runner.textmessage',
    				'runner.address1',
			    	'runner.address2',
			    	'runner.address3'
		    		)
	    		)
	    	->join(array('race'=>'race'),'race.id = raceresult.race',array())
	    	->join(array('event'=>'event'),'race.event = event.id',array())
	    	->join(array('runner'=>'runner'),'runner.id = raceresult.runner',array())
     	->joinleft(array('company'=>'company'),'runner.company = company.id',array())
     	->joinLeft(array('teammember'=>'teammember'),'teammember.runner = runner.id AND teammember.leavedate IS NULL',array())
    	->where('raceresult.class in ("RAN","RAN_NO_SCORE")')
    	->where('race.event = ?',$event)
    	->order('raceresult.race ASC')
    	->order('raceresult.position ASC')
    	->order('raceresult.racenumber ASC');
    	//$logger = Zend_Registry::get('logger');
    	//$logger->info($select);
    	return $result = $this->fetchAll($select);
    }

    public function getEventVolunteers($event)
	{
		$sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('raceresult'=>'raceresult'),array())
    		->join(array('race'=>'race'),'race.id = raceresult.race',array())
    		->join(array('event'=>'event'),'race.event = event.id',array())
    		->join(array('runner'=>'runner'),'runner.id = raceresult.runner',array('id','firstname','surname','status'))
			->joinleft(array('company'=>'company'),'raceresult.company = company.id',array('id','name'))
            ->where('raceresult.class in ("RACE_ORG","RACE_VOL")')
    		->where('event.id = ?',$event);
        return $this->fetchAll($sql);
	}
	
	/**
		select s.standard, 
		count(rr.runner) as total
		from standard as s
		join raceresult rr on s.standard=rr.standard
		where rr.race=72 group by s.standard;
	 */
	public function getStandardsBreakdown($race)
	{
		$sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('standard'=>'standard'),array('standard'))
    		->join(array('raceresult'=>'raceresult'),'raceresult.standard = standard.standard',array('count(raceresult.runner) as total'))
    		->where('raceresult.race = ?',$race)
	   		->group('standard.standard');
	   	return $this->fetchAll($sql);
	}
	
	public function deleteRaceResults($race)
	{
        $this->getAdapter()->delete('raceresult', array(sprintf('race = %d',$race), 'class = "RAN"'));
	}

    /**
     *   SELECT _category as category, r.id, r.firstname, r.surname, t.name as company
          FROM raceresult rr
          JOIN runner r ON rr.runner = r.id
          LEFT JOIN teammember tm ON r.id = tm.runner
          LEFT JOIN team t ON tm.team=t.id
          WHERE rr.race = _race
          AND rr.category = _category
          AND r.gender = _gender
          AND rr.position > 3
          ORDER BY position ASC
          LIMIT 3;
     */
    public function getTopThree($event,$gender)
    {
        $sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('raceresult'=>'raceresult'),array('position','companyname','category','racetime'))
    		->join(array('runner'=>'runner'),'runner.id=raceresult.runner',array('id','firstname','surname'))
            ->join(array('race'=>'race'),'race.id = raceresult.race',array())
            ->join(array('event'=>'event'),'race.event = event.id',array())
    		->where('race.event = ?',$event)
            ->where(sprintf('runner.gender= "%s"',$gender))
            //->where('raceresult.position <= 3')
            ->limit(3)
            ->order(array('raceresult.position asc'));
	   	return $this->fetchAll($sql);
    }

    /**
     *  SELECT _category as category, r.id, r.firstname, r.surname, t.name as company
          FROM raceresult rr
          JOIN runner r ON rr.runner = r.id
          LEFT JOIN teammember tm ON r.id = tm.runner
          LEFT JOIN team t ON tm.team=t.id
          WHERE rr.race = _race
          AND r.gender = _gender
          ORDER BY position ASC
          LIMIT 3;
     * @param <type> $race
     * @param <type> $gender 
     */
    public function getTopThreeByAge($agecategory,$event,$gender)
    {
        $sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('raceresult'=>'raceresult'),array('position','companyname','category','racetime'))
    		->join(array('runner'=>'runner'),'runner.id=raceresult.runner',array('id','firstname','surname'))
    		->join(array('race'=>'race'),'race.id = raceresult.race',array())
            ->join(array('event'=>'event'),'race.event = event.id',array())
    		->where('race.event = ?',$event)
            ->where(sprintf('runner.gender= "%s"',$gender))
            ->where(sprintf('raceresult.category = "%s"',$agecategory))
            ->limit(3)
            ->order(array('raceresult.position asc'));
	   	return $this->fetchAll($sql);
    }

    /**
     * select X.id as newId, Y.Id as currentId,Y.position,Y.standard, X.firstname, Y.surname
        from runner X join
        (select r.id,r.firstname,r.surname,r.dateofbirth,rr.position,rr.standard
        from raceresult rr
        join runner r on rr.runner=r.id
        where race=20105 and r.status='d') Y
        on X.firstname=Y.firstname AND X.surname=Y.surname
        AND X.status='M' order by Y.position asc;
     */
    public function getUnlinkedRunners($eventid)
    {
        $subquery = $this->select()->setIntegrityCheck(false)
            ->from(array('raceresult'=>'raceresult'),array('position','standard'))
            ->join(array('runner'=>'runner'),'runner.id=raceresult.runner',array('id','firstname','surname','dateofbirth','status'))
            ->join(array('race'=>'race'),'race.id=raceresult.race',array('raceid'=>'id'))
            ->join(array('event'=>'event'),'event.id=race.event',array())
            ->where('runner.status="D"')
            ->where('raceresult.class="RAN"')
            ->where('event.id=?',$eventid);

        $query = $this->select()->setIntegrityCheck(false)
          ->from(array('Y' => new Zend_Db_Expr( '('.$subquery.')' ) ),array('firstname','surname','dateofbirth','position','raceid') )
          ->join(array('X'=>'runner'),'X.firstname=Y.firstname AND X.surname=Y.surname',array('memberid'=>'X.id','dayid'=>'Y.id','status'=>'X.status'))
          ->where('X.status!="D"')
          ->order('Y.position asc');
        return $this->fetchAll($query);
    }

    /**
     *
     * @param <type> $eventid
     * @return <type> select raceresult.position,raceresult.racenumber,runner.id,runner.firstname,runner.surname from raceresult
		join runner on runner.id=raceresult.runner
		where runner.status!="M"
		AND raceresult.race=201074;
     */
    public function getDayMembers($eventid)
    {
        $query = $this->select()->setIntegrityCheck(false)
            ->from(array('raceresult'=>'raceresult'),array('position','racenumber','race'))
            ->join(array('runner'=>'runner'),'runner.id=raceresult.runner',
                    array('id','firstname','surname','dateofbirth'))
            ->join(array('race'=>'race'),'race.id=raceresult.race',array())
            ->join(array('event'=>'event'),'event.id=race.event',array())
            ->where('runner.status!="M"')
            ->where('raceresult.class="RAN"')
            ->where('event.id=?',$eventid);
        return $this->fetchAll($query);
    }

    //select position, standard, racetime from raceresult where race=20108;
    public function getTimes($race)
    {
		$sql = $this->select()
    		//->setIntegrityCheck(false)
    		->from(array('raceresult'=>'raceresult'),array('position','standard','racetime','postracestandard','paceKM','normalisedPaceKm'))
            ->where('raceresult.class in ("RAN","RAN_NO_SCORE")')
    		->where('raceresult.race = ?',$race);
    	return $this->fetchAll($sql);
	}

    /**
     *  $letable = new Model_DbTable_LeagueEvent();
        $events = $letable->getEventsByLeague($leagueid);
        $this->view->events = $events;

        $SQL = 'SELECT rr.runner AS runnerid, ru.firstname as firstname, ru.surname as surname, ';

        foreach($events as $eventrow)
        {
        	$eventTable = new Model_DbTable_Event();
            $event = $eventTable->find($eventrow->event)->current();
            $sum = $eventTable->getEventSumPoints($event,$division->gender);
        	$SQL = $SQL . $sum;
        }

        $SQL = $SQL . 'lrd.racesComplete, lrd.pointsTotal, c.name as company ';
		$SQL = $SQL . 'FROM raceresult rr ';
		$SQL = $SQL . 'JOIN runner ru ON rr.runner = ru.id ';
		$SQL = $SQL . 'LEFT JOIN company c ON c.id = ru.company ';
		$SQL = $SQL . 'JOIN race ra ON rr.race = ra.id ';
		$SQL = $SQL . 'JOIN event e ON ra.event = e.id ';
		$SQL = $SQL . 'JOIN leagueevent le ON e.id = le.event ';
		$SQL = $SQL . 'JOIN leaguerunnerdata lrd ON lrd.runner=rr.runner AND lrd.league=le.league ';
		$SQL = $SQL . sprintf('WHERE lrd.standard BETWEEN %d AND %d ',$division->min,$division->max);
		$SQL = $SQL . sprintf('AND ru.gender = \'%s\' ',$division->gender);
		$SQL = $SQL . sprintf('AND le.league = %d ',$leagueid);
		$SQL = $SQL . 'GROUP BY runnerid,racesComplete,pointsTotal ';
		$SQL = $SQL . 'ORDER BY pointsTotal DESC;';
     */
    public function getIndividualLeague($league,$division,$races)
    {
        $select = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('raceresult'=>'raceresult'),array())
            ->join(array('runner'=>'runner'),'runner.id=raceresult.runner',array('id','firstname','surname'));
            foreach($races as $taggedrace)
            {
                $select->columns(new Zend_Db_Expr(
                    sprintf("SUM(CASE raceresult.race WHEN %d THEN raceresult.points ELSE NULL END) as %s",
                        $taggedrace->raceid,$taggedrace->tag)));
                $select->columns(new Zend_Db_Expr(
                    sprintf("SUM(CASE raceresult.race WHEN %d THEN raceresult.standard ELSE NULL END) as %s_standard",
                        $taggedrace->raceid,$taggedrace->tag)));
            }
            $select->join(array('race'=>'race'),'race.id = raceresult.race',array())
            ->join(array('event'=>'event'),'race.event = event.id',array())
            ->join(array('leagueevent'=>'leagueevent'),'leagueevent.event = event.id',array())
            ->join(array('leaguerunnerdata'=>'leaguerunnerdata'),
                'leaguerunnerdata.runner = raceresult.runner AND leaguerunnerdata.league=leagueevent.league',
                array('racesComplete','pointsTotal','avgOverallPosition','standard'))
            ->joinLeft(array('company'=>'company'), 'company.id = runner.company',array('companyname'=>'name','companyid'=>'id'))
            ->where( sprintf('leaguerunnerdata.standard BETWEEN %d AND %d ',$division->min,$division->max))
            ->where('runner.gender= ?',$division->gender)
            ->where('leagueevent.league = ?',$league)
            ->where('raceresult.class="RAN" || raceresult.class="RACE_POINTS" || raceresult.class="RACE_ORG"')
            ->group(array('raceresult.runner','leaguerunnerdata.racesComplete','leaguerunnerdata.pointsTotal'))
            ->order(array('leaguerunnerdata.pointsTotal desc'));
        return $this->fetchAll($select);
    }

    public function name()
    {
        return $this->first_name . ' ' . $this->last_name;
    }

    /**
     * select paceKm,normalisedPaceKm,race,ROUND(getRaceDistanceKM(race.distance,race.unit),1) as dist from raceresult
join race on raceresult.race=race.id
where standard=16 order by dist;
     */
    public function getRaceTimePaceDistanceForStandard($standard)
    {
        $select = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('raceresult'=>'raceresult'),array('racetime','paceKM','normalisedPaceKm','race',
                'dist'=>new Zend_Db_Expr(sprintf('ROUND(getRaceDistanceKM(%s,%s),1)','race.distance','race.unit'))))
            ->join(array('race'=>'race'),'raceresult.race=race.id',array())
            ->where('raceresult.standard = ?',$standard)
            ->order(array('dist'));
        //echo $select;
        //Zend_Debug::dump( $this->fetchAll($select),"",true);
        return $this->fetchAll($select);
    }

    public function getAllNormalisedPaces()
    {
        return $this->fetchAll($this->getAllNormalisedPacesSQL());
    }

    public function getAllNormalisedPacesSQL()
    {
        $select = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('raceresult'=>'raceresult'),
                array('raceresult.standard',
                    'samples'=>'COUNT(normalisedPaceKm)',
                    'expectedpace'=>'SEC_TO_TIME(oneKmTimeInSecs)',
                    'min'=>'MIN(normalisedPaceKm)',
                    'avg-std'=>'SEC_TO_TIME(ROUND(AVG(TIME_TO_SEC(normalisedPaceKm)),2)-(STD(normalisedPaceKm)))',
                    'avg'=>'SEC_TO_TIME(ROUND(AVG(TIME_TO_SEC(normalisedPaceKm)),2))',
                    'avg+std'=>'SEC_TO_TIME(ROUND(AVG(TIME_TO_SEC(normalisedPaceKm)),2)+(STD(normalisedPaceKm)))',
                    'max'=>'MAX(normalisedPaceKm)'
                    ))
            ->join(array('standard'=>'standard'),'standard.standard=raceresult.standard',array(
                    //'pace*0-01'=>'SEC_TO_TIME(oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard.standard))',
                    //'pace*0-02'=>'SEC_TO_TIME(oneKmTimeInSecs+(oneKmTimeInSecs*.02*standard.standard))',
                    //'pace*0-05'=>'SEC_TO_TIME(oneKmTimeInSecs+(oneKmTimeInSecs*.05*standard.standard))'
            ))
            ->where('raceresult.class="RAN"')
            ->where('raceresult.standard IS NOT NULL')
            ->where('raceresult.standard != 0')
            ->where('raceresult.normalisedPaceKm IS NOT NULL')
            ->where('raceresult.normalisedPaceKm != ?',"00:00:00")
            ->group('raceresult.standard');
        //echo $select;
        return $select;
    }

    public function getAllNormalisedPacesByStandard($standard)
    {
        $select = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('raceresult'=>'raceresult'),array('normalisedPaceKm','standard'))
            ->where('raceresult.class="RAN"')
            ->where('raceresult.standard IS NOT NULL')
            ->where('raceresult.standard != 0')
            ->where('raceresult.standard = ?',$standard)
            ->where('raceresult.normalisedPaceKm IS NOT NULL');
        return $this->fetchAll($select);
    }

    public function updateRaceCompanyDetails($race)
    {
        $update = sprintf(
            'update raceresult '.
			'join race on raceresult.race=race.id '.
            'join runner on runner.id=raceresult.runner '.
            'left join company on runner.company=company.id '.
            'set raceresult.company=company.id '.
			'where race.id=%d '.
			'and raceresult.company IS NULL '.
			'and raceresult.companyname !="" '.
			'and runner.status="M"',$race);
        //Zend_Debug::dump( $update,"",true);
        $stmt = $this->getAdapter()->prepare($update);
        $stmt->execute();
    }
}
?>