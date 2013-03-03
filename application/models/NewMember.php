<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Runner
 *
 * @author assure
 */
class Model_NewMember {

    protected $form = null;

    public function getForm()
    {
        if(!isset($this->form))
        {
            $this->form = new Form_MembershipForm();
        }
        return $this->form;
    }

    public function save(array $data,$tag)
    {
        $form = $this->getForm();
        if (!$form->isValid($data)) {
            return false;
        }

        $logger = Zend_Registry::get('logger');
        $dob = new Zend_Date($data['dateofbirth']);
        $now = Zend_Date::now()->getIso();

        $logger->info(sprintf("Company Details : %s %s %s %s",$data['company'],$data['companyname'],$data['sectorid'],$data['sectorname']));
        $companyid = NULL;
        if(empty($data['company'])&& !empty($data['companyname']))
        {
            $logger->info(sprintf("new company %s",$data['companyname']));
            $sectorid = $data['sectorid'];
            if(empty($data['sectorid']))
                $sectorid=49;

            $companyTable = new Model_DbTable_Company();
            $nextcompanyid = $companyTable->getNewCompanyId()->nextcompanyid;
            $logger->info(sprintf("nextcompanyid %d",$nextcompanyid));
            $companydata = array(
                'id' => $nextcompanyid,
                'name'=>$data['companyname'],
                'sector'=>$sectorid,
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

        $membershipTable = new Model_DbTable_Membership();
        $runnerdata = array(
            'firstname' => stripslashes($data['firstname']),
            'surname' => stripslashes($data['surname']),
            'gender' => $data['gender'],
            'dateofbirth' => $dob->toString("YYYY-MM-dd"),
            'company' => $companyid,
            'companyname' => $data['companyname'],
            'address1' => $data['address1'],
            'address2' => $data['address2'],
            'address3' => $data['address3'],
            'email' => $data['email'],
            'mobile' => $data['mobile'],
            'newsletter' => $data['newsletter'],
            'textmessage' => $data['textmessage'],
            'insertdate' => Zend_Date::now()->toString("YYYY-MM-dd"),
            'tag' => $tag
        );
        $newrunner = $membershipTable->insert($runnerdata);
        $logger->info("inserted '.$tag.' membership : ".$newrunner);
        return $newrunner;
    }
}
?>