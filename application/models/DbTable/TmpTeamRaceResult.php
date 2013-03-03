<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of TmpTeamRaceResult
 *
 * @author assure
 */
class Model_DbTable_TmpTeamRaceResult extends Zend_Db_Table_Abstract
{
	protected $_name = 'tmpteamraceresult';
	protected $_primary = 'id';

    public function getTeamDetailsSQL()
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('tmpteamraceresult'=>'tmpteamraceresult'),
                    array(
                        'id',
                        'team',
                        '(select name from team where team.id=tmpteamraceresult.team) as teamname',
                        'standardtotal','positiontotal',
                        'runnerfirst',
                        '(select CONCAT(firstname,\' \',surname) from runner where runner.id = tmpteamraceresult.runnerfirst) as r1sn',
                        'runnersecond',
                        '(select CONCAT(firstname,\' \',surname) from runner where runner.id = tmpteamraceresult.runnersecond) as r2sn',
                        'runnerthird',
                        '(select CONCAT(firstname,\' \',surname) from runner where runner.id = tmpteamraceresult.runnerthird) as r3sn',
                        'class')
                )
            //->join(array('team'=>'team'),'team.id = tmpteamraceresult.team',array('name'))
            //->join(array('race'=>'race'),'race.id = tmpteamraceresult.race',array())
            ->order(array('class asc','positiontotal'));
        return $sql;
    }
}
?>
