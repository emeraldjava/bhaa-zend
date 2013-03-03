<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of DayMember
 *
 * @author assure
 */
class Model_DbTable_DayMember extends Zend_Db_Table_Row_Abstract
{
    public function name()
    {
        return $this->first_name . ' ' . $this->last_name;
    }
}

?>
