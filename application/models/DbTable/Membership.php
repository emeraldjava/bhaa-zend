<?php
class Model_DbTable_Membership extends Zend_Db_Table_Abstract
{
	protected $_name = 'membership';
	protected $_primary = 'id';

    public function getMember($id)
    {
    	return $this->find($id)->current();
    }
        /**
         *
         * select membership.id,membership.firstname,membership.surname,runner.id,runner.status,runner.firstname, runner.surname
			from runner join membership ON LOWER(membership.firstname) = LOWER(runner.firstname)
			AND LOWER(membership.surname) = LOWER(runner.surname)
			AND LOWER(membership.dateofbirth) = LOWER(runner.dateofbirth)
			AND membership.status="PENDING"
			ORDER BY membership.id asc;
         * 
         * @return <type>
         */
    public function getMembersToProcess()
	{
        $sql = $this->select()
            ->from(array('membership'=>'membership'),
                array('id','firstname','surname','company','companyname','dateofbirth','type',
                    '(select (max(id)+1) from company) as newcompany'))
            ->setIntegrityCheck(false)
            ->joinLeft(array('runner'=>'runner'),
                'LOWER(membership.firstname) = LOWER(runner.firstname)
                AND LOWER(membership.surname) = LOWER(runner.surname)
                AND LOWER(membership.dateofbirth) = LOWER(runner.dateofbirth)
                AND runner.status!="D"',
                array('id as rid','status as rstatus','company as rcompany',
                    '(select max(id+1) from runner where id>=1500 and id<3638) as newid'))
            ->where("membership.type = 'newmember'")
            ->where("membership.tag = 'bhaa2012'")
            ->order("membership.id asc")
            ->distinct("id");
        return $this->fetchAll($sql);
	}
}
?>