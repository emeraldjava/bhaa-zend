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
class Model_DayMember
{
    protected $form = null;

    public function getForm()
    {
        if(!isset($this->form))
        {
            $this->form = new Form_DayMemberForm();
        }
        return $this->form;
    }

    public function save(array $data)
    {
        $form = $this->getForm();
        if (!$form->isValid($data)) {
            return false;
        }

        $logger = Zend_Registry::get('logger');

        $dob = new Zend_Date($data['dateofbirth']);
        $now = Zend_Date::now()->getIso();
        $logger->info("preregistration() form ".$uploadedData['dateofbirth']." ".$now);

        $logger->info(sprintf("Company Details : %s %s %s %s",$data['company'],$data['companyname'],$data['sector'],$data['sectorname']));
        $companyid = NULL;//$data['company'];
        if(empty($data['company'])&& !empty($data['companyname']))
        {
            $logger->info(sprintf("new company %s",$data['companyname']));
            $sector = $data['sector'];
            if(empty($data['sector']))
                $sector=49;
            
            $companyTable = new Model_DbTable_Company();
            $nextcompanyid = $companyTable->getNewCompanyId()->nextcompanyid;
            $logger->info(sprintf("nextcompanyid %d",$nextcompanyid));
            $companydata = array(
                'id' => $nextcompanyid,
                'name'=>$data['companyname'],
                'sector'=>$sector,
                'website' => NULL,
                'image' => NULL
            );
            //$companyid = $companyTable->insert($companydata);
            //$logger->info(sprintf("new company %d",$companyid));
        }
        else
        {
            $companyid = $data['company'];
        }

        $runnertable = new Model_DbTable_Runner();
        $runnerdata = array(
            //'eventid' => $data['eventid'],
            'firstname' => stripslashes($data['firstname']),
            'surname' => stripslashes($data['surname']),
            'gender' => $data['gender'],
            'dateofbirth' => $dob->toString("YYYY-MM-dd"),
            'company' => $companyid,// $data['company'],
           // 'companyname' => $data['companyname'],
            'address1' => $data['address1'],
            'address2' => $data['address2'],
            'address3' => $data['address3'],
            'email' => $data['email'],
            'mobilephone' => $data['mobile'],
            'newsletter' => $data['newsletter'],
            'textmessage' => $data['textmessage'],
            'insertdate' => Zend_Date::now()->toString("YYYY-MM-dd")
        );
        $newrunner = $runnertable->insert($runnerdata);
        $logger->info("insert runner : ".$newrunner);

        $preRegTable = new Model_DbTable_Preregistered();
        $rrdata = array(
            'event' => $data['eventid'],
            'runner' => $newrunner);
        $regregsiteredrunnerid = $preRegTable->insert($rrdata);
        $logger->info(sprintf("insert %d to Model_DbTable_Preregistered",$regregsiteredrunnerid));
        return $newrunner;
    }
}
?>