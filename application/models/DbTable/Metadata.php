<?php
class Model_DbTable_Metadata extends Zend_Db_Table_Abstract
{
	protected $_name = 'metadata';
	protected $_primary = array('entity','id','name');
	
	const TYPE_EVENT = "EVENT";
	const TYPE_ADMIN = "ADMIN";

	const EVENT_NOTE = "EVENT_NOTE";
	const EVENT_GMAP_LON = "EVENT_GMAP_LON";
	const EVENT_GMAP_LAT = "EVENT_GMAP_LAT";
	const EVENT_CONTACT = "EVENT_CONTACT";
	const EVENT_FLYER = "EVENT_FLYER";

    const MEMBERSHIP_FORM = "MEMBERSHIP_FORM";

    const ENABLED = "ENABLED";
    const DISABLED = "DISABLED";

    public function getMetadata($entity,$id,$name)
    {
        $sql = $this->select()
        ->from(array('metadata'=>'metadata'))
        ->where(sprintf('entity = "%s"',$entity))
        ->where(sprintf('id = %d',$id))
        ->where(sprintf('name = "%s"',$name));
    	return $this->fetchRow($sql);
    }
}
?>