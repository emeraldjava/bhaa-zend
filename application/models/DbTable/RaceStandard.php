<?php
class Model_DbTable_RaceStandard extends Zend_Db_Table_Abstract
{
	protected $_name = 'racestandard';
	protected $_primary = array('race', 'standard');
	
	public function getStandard($id)
    {
    	return $this->find($id)->current();
    }
    
	public function getRaceStandards($race)
	{
		$sql = $this->select()
    		->from(array('racestandard'=>'racestandard'))
    		->where('race = ?',$race);
        return $this->fetchAll($sql);
	}
	
    /*
		select
		rr.runner, rr.standard, rr.position, rr.paceKM, 
		rs.expected, rs.min, rs.avg, rs.max, 
		TIME_TO_SEC(rr.paceKM)-TIME_TO_SEC(rs.avg) as diff,
		rs.std,
		(TIME_TO_SEC(rr.paceKM)-TIME_TO_SEC(rs.avg))/rs.std as numdev
		from raceresult as rr
		join racestandard as rs on rs.race=rr.race and rs.standard=rr.standard
		where rr.race=35 order by numdev;
	*/
	public function getRunnerStandardReport($race)
	{
		$sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('raceresult'=>'raceresult'),
    			array('runner','standard','position','paceKM'))
    		->join(array('racestandard'=>'racestandard'),
    			'raceresult.race=racestandard.race and raceresult.standard=racestandard.standard',
    			array('expected','min','avg','max','std',
    				'TIME_TO_SEC(paceKM)-TIME_TO_SEC(avg) as diff',
    				'(TIME_TO_SEC(paceKM)-TIME_TO_SEC(avg))/std as numdev'))
    		->where('raceresult.race = ?',$race)
    		->order("position");
		return $this->fetchAll($sql);
	}
}
?>
