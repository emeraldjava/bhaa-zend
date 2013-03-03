<?php
class RegistrarController extends Zend_Controller_Action
{
	var $logger;
	
    function init()
    {
    	$this->_helper->ajaxContext()->addActionContext('registrarfilter','html')->initContext();
    	//parent::init();
    	
    	//$this->initView();

        $this->view->baseUrl = $this->_request->getBaseUrl();
        $this->view->user = Zend_Auth::getInstance()->getIdentity();
        
        $this->logger = Zend_Registry::get('logger');
    }

    function preDispatch()
    {
        $this->_helper->authRedirector->saveRequestUri();
        $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }
    }

    public function indexAction()
    {
        $membersTable = new Model_DbTable_Membership();
        $membership = $membersTable->getMembersToProcess();
        $this->view->membership = $membership;

        $runnerTable = new Model_DbTable_Runner();
        $stats = $runnerTable->membershipDetails();
        $this->view->stats = $stats;

        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getMostRecentEvent();
        $this->view->event = $event;
    }

    public function registrarfilterAction()
    {
    	if ($this->_helper->ajaxContext()->getCurrentContext())
        {
        	$runnername = $this->_request->getParam('q');
    		$runnerTable = new Model_DbTable_Runner();
        	$this->view->runners = $runnerTable->searchAllRunnersByName($runnername);
        }
    }

    public function addnewmemberAction()
    {
        $id = $this->_request->getParam('id');
        $newrunnerid = $this->_request->getParam('newrunnerid');

    	$this->logger->info(sprintf('addnewmemberAction(%d -> %d)',$id,$newrunnerid));

        $membersTable = new Model_DbTable_Membership();
        $member = $membersTable->getMember($id);

        $runnerTable = new Model_DbTable_Runner();
        $mappeddata = array(
            'id' => $newrunnerid,
            'firstname' => $member->firstname,
            'surname' => $member->surname,
            'gender' => $member->gender,
            'dateofbirth' => $member->dateofbirth,
            'status' => "M",
            'standard'=> NULL,
            'company' => $member->company,
            'address1' => $member->address1,
            'address2' => $member->address2,
            'address3' => $member->address3,
            'email' => $member->email,
            'newsletter' => $member->newsletter,
            'telephone' => $member->mobile,
            'mobilephone' => $member->mobile,
            'textmessage' => $member->textmessage,
            'volunteer' => $member->volunteer,
            'insertdate' => $member->insertdate,
            'dateofrenewal' => $member->insertdate
            );
        $runnerTable->insert($mappeddata);

        $mappeddata = array(
            'runner' => $newrunnerid,
            'type' => "processed");
        $membersTable->update($mappeddata,"id = ".$id);

        $config = array('auth' => 'login',
            'username' => 'registrar@bhaa.ie',
            'password' => 'Passw0rd10',
            'ssl' => 'SSL',//SSL or tls
            'port' => 465);//465 or 587
        $transport = new Zend_Mail_Transport_Smtp('smtp.gmail.com', $config);
        Zend_Mail::setDefaultTransport($transport);
        $mail = new Zend_Mail();

        $mail->addTo($member->email);
        $mail->setFrom('registrar@bhaa.ie', 'BHAA Registrar');
        $mail->addBcc('registrar@bhaa.ie','BHAA Registrar BCC');
        $mail->setSubject(
            sprintf('%s %s : BHAA Membership %d',
            $member->firstname,stripslashes($member->surname),$newrunnerid));

        $myView = new Zend_View();
        $myView->id = $newrunnerid;
        $myView->firstname = $member->firstname;
        $myView->surname = stripslashes($member->surname);
        $myView->gender = $member->gender;
        $myView->dateofbirth = $member->dateofbirth;//->toString("dd/MM/YYYY");
        $myView->address1 = $member->address1;
        $myView->address2 = $member->address2;
        $myView->address3 = $member->address3;
        $myView->email = $member->email;
        $myView->mobile = $member->mobile;
        $myView->sectorname = $member->sectorname;
        $myView->companyname = $member->companyname;
        $myView->company = $member->company;
        $myView->newsletter = $member->newsletter;
        $myView->textmessage = $member->textmessage;
        $myView->volunteer = $member->volunteer;

        $myView->addScriptPath(APPLICATION_PATH . '/views/scripts/registrar');
        $html_body = $myView->render('registrar.email.phtml');

        $mail->setType(Zend_Mime::MULTIPART_RELATED);
        $mail->setBodyHtml($html_body);
        $mail->send($transport);

        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimpleAndExit('index','runner', 'default',
            array('id'=>$newrunnerid));
        //$this->_helper->redirector('index', 'registrar');
    }

    public function renewmembershipAction()
    {
        $memberid = $this->_request->getParam('member');
        $runnerid = $this->_request->getParam('runner');

    	$this->logger->info(sprintf('renewmembershipAction(%d -> %d)',$memberid,$runnerid));

        $membersTable = new Model_DbTable_Membership();
        $member = $membersTable->getMember($memberid);

        $runnerTable = new Model_DbTable_Runner();
        $mappeddata = array(
            //'id' => $runnerid,
            //'firstname' => $member->firstname,
            //'surname' => $member->surname,
            //'gender' => $member->gender,
            //'dateofbirth' => $member->dateofbirth,
            'status' => "M",
            //'company' => $member->companyid,
            //'address' => $member->address1,
            //'address2' => $member->address2,
            //'address3' => $member->address3,
            'email' => $member->email,
            'newsletter' => $member->newsletter,
            //'telephone' => $member->mobile,
            'mobilephone' => $member->mobile,
            'textmessage' => $member->textmessage,
            'volunteer' => $member->volunteer,
            //'insertdate' => $member->insertdate,//Zend_Date::now()->toString("YYYY-MM-dd"),
            'dateofrenewal' => $member->insertdate// Zend_Date::now()->toString("YYYY-MM-dd")
            );
        $runnerTable->update($mappeddata,"id = ".$runnerid);

        $membersTable = new Model_DbTable_Membership();
        $mappeddata = array(
            'runner' => $runnerid,
            'type' => "processed");
        $membersTable->update($mappeddata,"id = ".$memberid);

        $this->_helper->redirector('index', 'registrar');
    }

    public function linkrunnertocompanyAction()
    {
        $id = $this->_request->getParam('id');
        $company = $this->_request->getParam('company');
        $companyname = $this->_request->getParam('companyname');

        $this->logger->info(sprintf('linkRunnerToCompanyAction(%d -> %d)',$id,$company));

        $membersTable = new Model_DbTable_Membership();
        $member = $membersTable->getMember($id);

        $mappeddata = array('company' => $company);
        $membersTable->update($mappeddata,"id = ".$id);

        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimpleAndExit('add','company', 'default',
            array('id'=>$company,'name'=>$companyname));
        //$this->_helper->redirector('index', 'registrar');
    }

    public function deleteAction()
    {
        $memberid = $this->_request->getParam('member');

        $membersTable = new Model_DbTable_Membership();
        $membership = $membersTable->delete(sprintf('id=%d',$memberid));

        $this->_helper->redirector('index', 'registrar');
    }

    /**
     * Lists the details of runners in a specific event and their membership status
     */
    public function eventmembersAction()
    {
        $eventtag = $this->_request->getParam('tag');
        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getEventByTag($eventtag);
        $this->view->event = $event;

        $raceresultTable = new Model_DbTable_RaceResult();
        $res = $raceresultTable->getUnlinkedRunners($event->id);
        $this->view->unlinked = $res;

        $daymembers = $raceresultTable->getDayMembers($event->id);
        $this->view->daymembers = $daymembers;

        $racenumber = $this->_request->getParam('racenumber');
        if(isset($racenumber))
        {
            $raceNumberDetails = $raceresultTable->getRaceResultByEventNumber($event->id,$racenumber);
            $this->view->raceNumberDetails = $raceNumberDetails;
        }
    }

    public function linkrunnerAction()
    {
        $dayid = $this->_request->getParam('dayid');
        $memberid = $this->_request->getParam('memberid');
        $race = $this->_request->getParam('race');
        $tag = $this->_request->getParam('tag');

        $raceResultTable = new Model_DbTable_RaceResult();
        $data = array('runner' => $memberid);
        $raceResultTable->update($data,sprintf('race = %d and runner = %d',$race,$dayid));

        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimpleAndExit('eventmembers','registrar','default',array('tag'=>$tag));
    }
    
    public function linkraceresultAction()
    {
        $dayid = $this->_request->getParam('dayid');
        $memberid = $this->_request->getParam('memberid');
        $race = $this->_request->getParam('race');
        $tag = $this->_request->getParam('tag');

        $raceResultTable = new Model_DbTable_RaceResult();
        $data = array('runner' => $memberid);
        $raceResultTable->update($data,sprintf('race = %d and runner = %d',$race,$dayid));
		$this->logger->info(sprintf('moved %s result for %d to %d',$tag,$dayid,$memberid));
        
        //$runnerTable = new Model_DbTable_Runner();
        //$runnerTable->delete('id='.$dayid);
        //$runnerTable->update(array('status' => 'LINKED'),'id='.$dayid);
        //$logger->info(sprintf('marked %d as LINKED - delete?',$dayid));
                
        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimpleAndExit('matchingrunners','registrar','default',array('tag'=>$tag));
    }

    public function listrunnersAction()
    {
        $firstname = $this->_request->getParam('firstname');
        $surname = $this->_request->getParam('surname');
        $dob = $this->_request->getParam('dob');

    	$this->logger->info(sprintf('listrunnersAction(%s,%s,%s)',$firstname,$surname,$dob));

        $runnerTable = new Model_DbTable_Runner();
        $this->view->runners = $runnerTable->findMatchingRunners($firstname, $surname, $dob);
    }
    
    public function matchingrunnersAction()
    {	
    	$eventtag = $this->_request->getParam('tag');
        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getEventByTag($eventtag);
        $this->view->event = $event;

        $db = Zend_Db_Table::getDefaultAdapter();
        $sql = sprintf("CALL getMatchingRunnersByEvent(%d);",$event->id);
        $this->logger->info(sprintf('matchingrunnersAction() %s',$sql));
        $stmt = $db->prepare($sql);
        $stmt->execute();
        $this->view->runners = $stmt->fetchAll();
        $stmt->closeCursor();
        
        //$logger->info("matchingrunnersAction ".$event->tag);
    }
}
?>