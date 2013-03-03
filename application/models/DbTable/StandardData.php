<?php
class Model_DbTable_StandardData extends Zend_Db_Table_Abstract
{
	protected $_name = 'standarddata';
	protected $_primary = array('standard','distance','unit');
	    
	public function getStandardData($standard)
	{
		$sql = $this->select()
            //->setIntegrityCheck(false)
            ->from(array('standarddata'=>'standarddata'))
            //->join(array('racestandarddata'=>'racestandarddata'),'standarddata.standard=racestandarddata.standard')
            //->join(array('race'=>'race'),'race.id=racestandarddata.race')
            ->where('standarddata.standard = ?',$standard);
            //->group('standarddata.standard');
        //echo $sql;
		return $this->fetchAll($sql);
	}
}
?>
