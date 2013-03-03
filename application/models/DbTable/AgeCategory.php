<?php
class Model_DbTable_AgeCategory extends Zend_Db_Table_Abstract
{
	protected $_name = 'agecategory';
	protected $_primary = 'id';

    const SM = "SM";
    const M40 = "M40";
    const M45 = "M45";
    const M50 = "M50";
    const M55 = "M55";
    const M60 = "M60";
    const M65 = "M65";
    const M70 = "M70";
    const M75 = "M75";
    const M80 = "M80";
    const M85 = "M85";
    const JM = "JM";

    const SW = "SW";
    const W35 = "W35";
    const W40 = "W40";
    const W45 = "W45";
    const W50 = "W50";
    const W55 = "W55";
    const W60 = "W60";
    const W65 = "W65";
    const W70 = "W70";
    const JW = "JW";

	public function getAgeCategory($id)
    {
    	return $this->find($id)->current();
    }

    public function getByCategory($category)
    {
    	$sql = $this->select()
    		->from(array('agecategory'=>'agecategory'))
    		->where('category = ?',$category);
        return $this->fetchAll($sql);
    }

    /**
     *
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
     *
     * @param <type> $event
     * @return <type>
     *
     *
     */
    public function getRaceResultsByCategory($race,$category,$gender)
	{
		$sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('raceresult'=>'raceresult'),array('category'))
    		->join(array('runner'=>'runner'),'runner.id = raceresult.runner',array('id','firstname','surname','company'))
    		->where('raceresult.race = ?',$race)
       		->where('runner.gender = ?',$gender)
       		->where('raceresult.category = ?',$category)
       		->where('raceresult.position > 3')
            ->limit(3)
            ->order(array('raceresult.position asc'));
        //echo sprintf("SQL %s",$sql);
    	return $this->fetchAll($sql);
	}
}
?>