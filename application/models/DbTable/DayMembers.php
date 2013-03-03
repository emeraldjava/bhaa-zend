<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of DayMembers
 *
 * @author assure
 */
class Model_DbTable_DayMembers extends Zend_Db_Table_Abstract
{
    protected $_name = 'daymembership';
    protected $_rowClass = 'Model_DbTable_DayMember';

    public function fetchAllInLastNameOrder()
    {
        return $this->fetchAll(null, array('firstname', 'surname'));
    }

    public function fetchUserById($id)
    {
        $id = (int)$id;
        return $this->_fetchRow('id = '. $id);
    }

    public function exportDayRunners($event)
	{
		$sql = $this->select()
			->from(array('daymembership'=>'daymembership'),
				array('id as raceno',
                    'id as membership',
                    'surname','firstname as name',
					'(CASE gender WHEN "M" THEN "M" ELSE "L" END) as gender',
					'id as std',
					'date_format(dateofbirth,\'%d/%m/%Y\') as dateofbirth',
					sprintf('(select getAgeCategory(dateofbirth,"%s",gender,1)) as cat',$event->date),
					'companyname'))
            ->where(sprintf("eventid='%d'",$event->id))
			->order(array('surname asc','firstname asc'));
        return $this->fetchAll($sql);
	}
}
?>
