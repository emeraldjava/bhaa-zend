<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of RaceTimeStandard
 *
 * @author assure
 */
class Model_DbTable_RaceStandardData extends Zend_Db_Table_Abstract
{
	protected $_name = 'racestandarddata';
	protected $_primary = array('race', 'standard');

    public function getRaceStandardData($race)
	{
		$sql = $this->select()
    		->from(array('racestandarddata'=>'racestandarddata'))
    		->where('race = ?',$race);
        return $this->fetchAll($sql);
	}

    /**
     *
     * @param <type> $race
     * @return <type>
     *
     * select
        ru.id,raceresult.position,raceresult.standard,raceresult.postRaceStandard,racetime,
        rts.expected,rts.`average`,
        (racetime-rts.`average`) as averagediff,
        (racetime-rts.expected) as expecteddiff
        from raceresult raceresult
        join runner ru on raceresult.runner=ru.id
        left join racetimestandard rts on (rts.standard = raceresult.standard AND rts.race=raceresult.race)
        where raceresult.race=20106 and ru.status='M'
        order by position;
     * 
     */
    public function getRaceStandardDataReport($race)
	{
		$sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('raceresult'=>'raceresult'),
    			array('runner','standard','position','racetime','paceKM','postRaceStandard',
                    '(racetime - racestandarddata.t_average) as averagediff',
                    '(racetime - racestandarddata.t_expected) as expecteddiff',
                    '(select getStandardByRunnerPace(race.id,runner.id)) as expected'))
            ->join(array('runner'=>'runner'),
    			'raceresult.runner=runner.id',
    			array('id','firstname','surname','runnerstandard'=>'standard'))
    		->joinLeft(array('racestandarddata'=>'racestandarddata'),
    			'raceresult.race=racestandarddata.race and raceresult.standard=racestandarddata.standard',
    			array('t_expected','t_average','t_min','t_max'))
            ->join(array('race'=>'race'),
    			'raceresult.race=race.id',
    			array('standardgap'=>'(getRaceDistanceKM(race.distance,race.unit)*5)',
                    'fast'=>'(select IF(averagediff > standardgap,"SLOW->30",""))',
                    'slow'=>'(select IF(averagediff < -standardgap,"FAST->0",""))'))
    		->where('raceresult.class=?',"RAN")
    	    ->where('raceresult.race = ?',$race)
       		->where('runner.status=?',"M")
       		->order("position");
        //$logger = Zend_Registry::get('logger');
        //$logger->info($sql);
		return $this->fetchAll($sql);
	}

    public function populateRaceDetails($race)
    {
            $select = sprintf("select
                coalesce(race.id,%d) as race,
                sd.standard as standard,
                count(rr.runner) as runners,
                coalesce(SEC_TO_TIME((oneKmTimeInSecs + (getRaceDistanceKM(X.distance,X.unit)*slopefactor))*getRaceDistanceKM(X.distance,X.unit) ),0) as t_expected,
                coalesce(min(rr.racetime),0) as t_min,
                coalesce(SEC_TO_TIME(avg(TIME_TO_SEC(rr.racetime))),0) as t_avg,
                coalesce(max(rr.racetime),0) as t_max,
                IF(count(rr.runner)=0,0,
                ROUND(coalesce( (oneKmTimeInSecs + (getRaceDistanceKM(X.distance,X.unit)*slopefactor))*getRaceDistanceKM(X.distance,X.unit) ,0) -
                (coalesce( avg(TIME_TO_SEC(rr.racetime)),0)),0) ) as t_exp_avg_diff,
                coalesce(SEC_TO_TIME((oneKmTimeInSecs + (getRaceDistanceKM(race.distance,race.unit)*slopefactor))),0) as p_expected,
                coalesce(min(rr.paceKM),0) as p_min,
                coalesce(SEC_TO_TIME(avg(TIME_TO_SEC(rr.paceKM))),0) as p_avg,
                coalesce(max(rr.paceKM),0) as p_max,
                IF(count(rr.runner)=0,0,
                ROUND(coalesce( (oneKmTimeInSecs + (getRaceDistanceKM(race.distance,race.unit)*slopefactor)) ,0) -
                (coalesce( avg(TIME_TO_SEC(rr.paceKM)),0)),0) ) as p_exp_avg_diff
                from standard sd
                left join  raceresult rr on rr.standard = sd.standard and rr.race=%d
                left join  race  on rr.race = race.id
                join (select race.id,race.distance,race.unit from race where id=%d) X on coalesce(race.id,%d)=X.id
                group by sd.standard",$race,$race,$race,$race);
            $insert  = "INSERT INTO racestandarddata ".$select;
            $this->_db->query($insert);
    }


    /**
     *  select id from race where not exists (select race from racestandarddata where race.id=racestandarddata.race);
     *  $racetimestandardTable = new Model_DbTable_RaceStandardData();
        $missingracedata = $racetimestandardTable->getMissingRaceStandards();
        $this->view->missingracedata = $missingracedata;
        Zend_Debug::dump($missingracedata,"",true);
     *
     */
    public function getMissingRaceStandards()
    {
		return $this->_db->fetchAll('select id from race where not exists (select race from racestandarddata where race.id=racestandarddata.race) and race.type!="S"');
    }
}
?>
