<?php
class Model_DbTable_Standard extends Zend_Db_Table_Abstract
{
	protected $_name = 'standard';
	protected $_primary = 'id';
	
	public function getStandard($id)
    {
    	return $this->find($id)->current();
    }
    
	public function getPaces()
	{
		$sql = $this->select()->from(array('standard'=>'standard'),array('standard',
            'pace'=>'SEC_TO_TIME(oneKmTimeInSecs)',
            'pace0-01'=>'SEC_TO_TIME(oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))',
            'pace0-02'=>'SEC_TO_TIME(oneKmTimeInSecs+(oneKmTimeInSecs*.02*standard))',
            'pace0-05'=>'SEC_TO_TIME(oneKmTimeInSecs+(oneKmTimeInSecs*.05*standard))'));
        echo $sql;
		return $this->fetchAll($sql);
	}

    /**
     *  select distinct(r.id), r.firstname,r.surname,race.id,rr.paceKM,rr.racetime
        from runner r
        join raceresult rr on rr.runner=r.id
        join race race on race.id=rr.race
        where r.status='M' and (r.standard=0 or r.standard is null)
     */
    public function getRunnersWithMissingStandards()
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('runner'=>'runner'),array('id','firstname','surname'))
            ->join(array('raceresult'=>'raceresult'),'runner.id = raceresult.runner',array('paceKM','racetime'))
            ->join(array('race'=>'race'),'race.id = raceresult.race',array('race'=>'id'))
    	    ->where('runner.status = "M"')
            ->where('raceresult.class="RAN"')
            ->where('runner.standard=0 or runner.standard IS NULL')
            ->distinct('runner.id');
        //echo $sql;
        return $this->fetchAll($sql);
    }

    /**
     * List runners who have renewed and raced for the first time in a league - 
     * check their standard.
     * SELECT
        l.id,
        r.standard as old_standard,
	    r.id,
	    r.firstname,
	    r.surname,
        rr.pacekm,
	    r.dateofrenewal
        FROM raceresult rr
        JOIN runner r ON rr.runner = r.id
        JOIN race ra ON rr.race = ra.id
        JOIN event e ON ra.event = e.id
        JOIN leagueevent le ON e.id = le.event
        JOIN league l ON le.league = l.id and l.type ='I'
        WHERE ra.event = 201011
        AND r.status='M' AND r.dateofrenewal >= e.date
        ORDER BY rr.pacekm;

     */
    public function listRenewingRunnersStandard()
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('runner'=>'runner'),array('id','firstname','surname','standard','dateofrenewal'))
            ->join(array('raceresult'=>'raceresult'),'runner.id = raceresult.runner',array('paceKM','racetime'))
            ->join(array('race'=>'race'),'race.id = raceresult.race',array())
            ->join(array('event'=>'event'),'race.event = event.id',array())
            ->join(array('leagueevent'=>'leagueevent'),'event.id = leagueevent.event',array())
            ->join(array('league'=>'league'),'leagueevent.league = league.id',array())
    	    ->where('race.event = 201011')
            ->where('runner.status="M"')
            ->where('runner.dateofrenewal>=event.date')
            ->distinct('raceresult.paceKM');
        //return $sql;
        echo $sql;
        return $this->fetchAll($sql);
    }

    /**
     * select standard.id,
        (select SEC_TO_TIME((standard.slopefactor * sd.km-1) + standard.oneKmTimeInSecs) from standarddistance sd where sd.name="1k") as 1kpace,
        (select SEC_TO_TIME(((standard.slopefactor * sd.km-1) + standard.oneKmTimeInSecs) * sd.km) from standarddistance sd where sd.name="1k") as 1ktime,
        (select SEC_TO_TIME((standard.slopefactor * sd.km-1) + standard.oneKmTimeInSecs) from standarddistance sd where sd.name="5k") as 5kpace,
        (select SEC_TO_TIME(((standard.slopefactor * sd.km-1) + standard.oneKmTimeInSecs) * sd.km) from standarddistance sd where sd.name="5k") as 5ktime,
        (select SEC_TO_TIME((standard.slopefactor * sd.km-1) + standard.oneKmTimeInSecs) from standarddistance sd where sd.name="10k") as 10kpace,
        (select SEC_TO_TIME(((standard.slopefactor * sd.km-1) + standard.oneKmTimeInSecs) * sd.km) from standarddistance sd where sd.name="10k") as 10ktime
        from standard where standard.id=10;
     */
    public function standardsTable($distances,$type='time',$slopex='1',$kmx='0')
    {
        $select = $this->select()->from(array('standard'=>'standard'),array('standard'=>'standard.id'));
            foreach ($distances as $i => $distance)
            {
                if($type=='pace')
                {
                    if($kmx==0)
                        // SEC_TO_TIME((((standard.slopefactor) * (sd.km-1)) + oneKmTimeInSecs) ) as pace,
                        $select->columns(new Zend_Db_Expr(
                            sprintf('(select SEC_TO_TIME((standard.slopefactor*%f*(sd.km-1)) + (standard.oneKmTimeInSecs)) from standarddistance sd where sd.name="%s") as %s',
                                $slopex,$distance,$distance)));
                    else
                        // SEC_TO_TIME((((standard.slopefactor*1.05) * (sd.km-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) ) as newpace,
                        $select->columns(new Zend_Db_Expr(
                            sprintf('(select SEC_TO_TIME((((standard.slopefactor*%f)*(sd.km-1)) + (standard.oneKmTimeInSecs+(standard.oneKmTimeInSecs*%f*standard.standard))) from standarddistance sd where sd.name="%s") as %s',
                                $slopex,$kmx,$distance,$distance)));
                }
                else
                {
                    if($kmx==0)
                        // SEC_TO_TIME((((standard.slopefactor) * (sd.km-1)) + oneKmTimeInSecs) * sd.km) as time,
                        $select->columns(new Zend_Db_Expr(
                            sprintf('(select SEC_TO_TIME((((standard.slopefactor)*%d*(sd.km-1)) + standard.oneKmTimeInSecs) * sd.km) from standarddistance sd where sd.name="%s") as %s',
                                $slopex,$distance,$distance)));
                    else
                        // SEC_TO_TIME((((standard.slopefactor*1.05) * (sd.km-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) * sd.km) as newtime
                        $select->columns(new Zend_Db_Expr(
                            sprintf('(select SEC_TO_TIME((((standard.slopefactor*%f)*(sd.km-1)) + (standard.oneKmTimeInSecs+(standard.oneKmTimeInSecs*%f*standard.standard))) * sd.km) from standarddistance sd where sd.name="%s") as %s',
                                $slopex,$kmx,$distance,$distance)));
                }
            }
            //$select->where('standard.id = ?',$standard);
            $select->group('standard.id');
        //echo $select;
        return $this->fetchAll($select);
    }

    public function getEventStandardTable($races)
    {
        $select = $this->select()->from(array('standard'=>'standard'),array('Standard'=>'standard.id'));
        foreach ($races as $i => $race)
        {
            $subselect = sprintf('(select SEC_TO_TIME( ((standard.slopefactor*(%f-1)) + standard.oneKmTimeInSecs) * %f)) as "%s"',
                    $race->distancekm,$race->distancekm,$race->distance.' '.$race->unit);
            $select->columns(new Zend_Db_Expr($subselect));
        }
        return $this->fetchAll($select);
    }
}
?>