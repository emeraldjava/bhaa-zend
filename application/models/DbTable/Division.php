<?php
class Model_DbTable_Division extends Zend_Db_Table_Abstract
{
    protected $_name = 'division';
    protected $_primary = 'id';

    public function getDivision($id)
    {
    	return $this->find($id)->current();
    }

    public function getDivisonByCode($code)
    {
    	$sql = $this->select()
                ->from(array('division'=>'division'))
                ->where("code = ?",$code);
    	return $this->fetchAll($sql)->current();
    }

    public function getIndividualDivisions()
    {
        return $this->fetchAll("type='I'");
    }
}
?>