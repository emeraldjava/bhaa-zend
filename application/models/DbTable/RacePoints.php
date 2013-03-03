<?php
class Model_DbTable_RacePoints extends Zend_Db_Table_Abstract
{
    protected $_name = 'racepoints';
    protected $_primary = array('race', 'runner');
    
    /**
		select rr.position, rp.*, rpd.standardscoringset 
		from racepoints rp
		join raceresult rr on rp.runner=rr.runner and rp.race=rr.race
		join racepointsdata rpd on rp.runner=rpd.runner and rp.race=rpd.race
		where rp.race = xx 
		order by rr.position;
     */
    public function getPointsForRace($race)
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('racepoints'=>'racepoints'))
            ->join(array('raceresult'=>'raceresult'),
            	'racepoints.runner=raceresult.runner and racepoints.race=raceresult.race',
            	array('position','standard'))
    		->join(array('racepointsdata'=>'racepointsdata'),
    			'racepoints.runner=racepointsdata.runner and racepoints.race=racepointsdata.race',
    			array('standardscoringset'))
    		->join(array('runner'=>'runner'),'racepoints.runner=runner.id',array('gender'))
            ->where('racepoints.race = ?',$race)
            ->order('raceresult.position ASC');
        //echo $sql;
        return $this->fetchAll($sql);
    }
    
    /**
     * select s.standard, count(rr.runner) as total
		from standard s
		left join raceresult rr on s.standard=rr.standard and rr.race= xx 
		group by s.standard;
		
		SELECT `standard`.`id`, COALESCE(Count(racepointsdata.runner),0) as totalrunners
FROM `standard` 
LEFT JOIN racepointsdata on standard.id=racepointsdata.preracestandard  and  racepointsdata.race=xx and racepointsdata.gender = 'M'
GROUP BY `standard`.`id`;
     */
    public function runnersPerStandardAtRace($race,$gender="M")
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('standard'=>'standard'),array('id'))
            ->joinLeft(array('racepointsdata'=>'racepointsdata'),
            	sprintf('standard.id=racepointsdata.preracestandard and racepointsdata.race=%d and racepointsdata.gender="%s"',$race,$gender)
            	,array('total'=>new Zend_Db_Expr('COALESCE(Count(racepointsdata.runner),0)')))
            ->group('standard.id');
        //echo $sql;
        return $this->fetchAll($sql);
    }
    
    /**
     * SELECT `standard`.`id`, COALESCE(racepointsdata.standardscoringset,0) as scoringset
FROM `standard` 
LEFT JOIN racepointsdata on standard.id=racepointsdata.preracestandard  and  racepointsdata.race=xx and racepointsdata.gender = 'M'
GROUP BY `standard`.`id`;
     */
    public function scoringSetsPerStandardAtRace($race,$gender="M")
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('standard'=>'standard'),array('id'))
            ->joinLeft(array('racepointsdata'=>'racepointsdata'),
            	sprintf('standard.id=racepointsdata.preracestandard and racepointsdata.race=%d and racepointsdata.gender="%s"',$race,$gender)
            	,array('total'=>new Zend_Db_Expr('COALESCE(racepointsdata.standardscoringset,0)')))
            ->group('standard.id');
        //echo $sql;
        return $this->fetchAll($sql);
    }
}
?>