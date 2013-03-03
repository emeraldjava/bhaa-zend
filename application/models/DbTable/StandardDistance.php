<?php
/**
 * Description of StandardDistance
 * @author assure
 */
class Model_DbTable_StandardDistance extends Zend_Db_Table_Abstract
{
	protected $_name = 'standarddistance';
	protected $_primary = 'name';

    /**
     *
     * @return <type>
     * select sd.name as dist, ROUND(sd.km,1) as km,
        SEC_TO_TIME((((standard.slopefactor) * (sd.km-1)) + oneKmTimeInSecs) ) as pace,
        SEC_TO_TIME((((standard.slopefactor) * (sd.km-1)) + oneKmTimeInSecs) * sd.km) as time,
        SEC_TO_TIME((((standard.slopefactor*1.05) * (sd.km-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) ) as newpace,
        SEC_TO_TIME((((standard.slopefactor*1.05) * (sd.km-1)) + (oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) * sd.km) as newtime
        from standarddistance sd
        join standard
        where standard.id=1
        order by sd.km ASC;
     *
     */
    public function getStandardPaceTimeForStandard($standard,$slopefactor=1,$kmfactor=1)
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('standarddistance'=>'standarddistance'),array('name','dist'=>'ROUND(km,1)',
                '(SEC_TO_TIME((((standard.slopefactor) * (standarddistance.km-1)) + standard.oneKmTimeInSecs) )) as pace',
                '(SEC_TO_TIME((((standard.slopefactor) * (standarddistance.km-1)) + standard.oneKmTimeInSecs) * standarddistance.km)) as time',
                '(SEC_TO_TIME((((standard.slopefactor*1.05) * (standarddistance.km-1)) + (standard.oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) )) as newpace',
                '(SEC_TO_TIME((((standard.slopefactor*1.05) * (standarddistance.km-1)) + (standard.oneKmTimeInSecs+(oneKmTimeInSecs*.01*standard))) * standarddistance.km)) as newtime'
                ))
            ->join(array('standard'=>'standard'),'',array())
    	    ->where('standard.id = ?',$standard)
            ->order('standarddistance.km');
        //echo $sql;
        return $this->fetchAll($sql);
    }
}
?>