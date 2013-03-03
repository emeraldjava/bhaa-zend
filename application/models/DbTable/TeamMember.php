<?php
class Model_DbTable_TeamMember extends Zend_Db_Table_Abstract
{
	protected $_name = 'teammember';
	protected $_primary = array('team','runner');
    
	public function getRunnerDetailsForTeam($team)
	{
		$sql = $this->select()
			->setIntegrityCheck(false)
			->from(array('teammember'=>'teammember'))
			->join(array('runner'=>'runner'),'runner.id = teammember.runner',
				array('id','firstname','surname','gender','standard','company','team',
                    '(select count(race) from raceresult where raceresult.runner = runner.id and raceresult.race>2000) as races',
                    'dateofrenewal',
                    '(CASE (dateofrenewal >= "2009-09-01") WHEN TRUE THEN "Y" ELSE "N" END) as renewed'))
			->joinleft(array('company'=>'company'),'company.id=runner.company',array('name'))
            ->where("teammember.leavedate IS NULL")
            ->where(sprintf("teammember.team = %d",$team));
        //echo sprintf("sql %s",$sql);
		return $this->fetchAll($sql);
	}
}
?>